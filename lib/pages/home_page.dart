import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_travel/dao/homo_dao.dart';
import 'package:flutter_travel/model/common_model.dart';
import 'dart:convert';

import 'package:flutter_travel/model/home_model.dart';
import 'package:flutter_travel/widget/local_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'http://images6.fanpop.com/image/photos/40400000/One-Piece-maouki-40476927-2560-1440.jpg',
    'http://images6.fanpop.com/image/photos/40400000/Fairy-Tail-maouki-40449790-1920-1080.jpg',
    'http://images6.fanpop.com/image/photos/40400000/Fairy-Tail-maouki-40449793-1920-1080.jpg'
  ];

  double appBarAlpha = 0;
  List<CommonModel> localNavList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  _onScroll(double offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  loadData() async {
//    HomeDao.fetch().then((result) {
//      setState(() {
//        resultString = json.encode(result);
//      });
//    }).catchError((e){
//      setState(() {
//        resultString = e.toString();
//      });
//    });
    try {
      HomeModel homeModel = await HomeDao.fetch();
      setState(() {
        localNavList = homeModel.localNavList;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification &&
                    scrollNotification.depth == 0) {
                  _onScroll(scrollNotification.metrics.pixels);
                }
              },
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 160,
                    child: Swiper(
                      itemCount: _imageUrls.length,
                      autoplay: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          _imageUrls[index],
                          fit: BoxFit.fill,
                        );
                      },
                      pagination: SwiperPagination(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 4, 4, 7),
                    child: LocalNav(
                      localNavList: localNavList,
                    ),
                  ),
                  Container(
                    height: 800,
                    child: ListTile(
                      title: Text("resultString"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Opacity(
            opacity: appBarAlpha,
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('首页'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
