// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetUserData extends StatelessWidget {
  const GetUserData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String documentId = uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            UserModel.username = data['Info']['username'].toString();
            UserModel.email = data['Info']['email'].toString();
            UserModel.password = data['Info']['password'].toString();
            // UserModel.imageUrl = data['Info']['imageUrl'].toString();
            // UserModel.bio = data['Info']['bio'].toString();

            return HomePage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}