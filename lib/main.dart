import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/users/2');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final String name;
  final String email;
  final String phone;
  final int Size;

  Post({this.name, this.email, this.phone, this.Size});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

void main() => runApp(MyApp(post: fetchPost()));

class MyApp extends StatelessWidget {
  final Future<Post> post;

  MyApp({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(children: [
                        Icon(Icons.account_circle),
                        SizedBox(
                          width: 5,
                        ),
                        Text(snapshot.data.name),
                      ]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(children: [
                        Icon(Icons.mail),
                        SizedBox(
                          width: 5,
                        ),
                        Text(snapshot.data.email)
                      ]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(children: [
                        Icon(Icons.phone),
                        SizedBox(
                          width: 5,
                        ),
                        Text(snapshot.data.phone)
                      ]),
                    ],
                  ),
                ]);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
