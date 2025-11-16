import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';
import 'package:provider/provider.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  Note? _editingNote;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we're editing an existing note
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Note) {
      _editingNote = args;
      _titleController.text = _editingNote!.title;
      _contentController.text = _editingNote!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingNote == null ? 'Add New Note' : 'Edit Note'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveNote(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(_editingNote == null ? 'Save Note' : 'Update Note'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote(BuildContext context) {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty!')),
      );
      return;
    }

    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    
    if (_editingNote == null) {
      // Create new note
      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        content: _contentController.text,
        createdAt: DateTime.now(),
      );
      noteProvider.addNote(newNote);
    } else {
      // Update existing note
      final updatedNote = Note(
        id: _editingNote!.id,
        title: _titleController.text,
        content: _contentController.text,
        createdAt: _editingNote!.createdAt,
      );
      noteProvider.updateNote(updatedNote);
    }
    
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}