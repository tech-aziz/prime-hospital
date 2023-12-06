import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config/colors.dart';
import '../../global_widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  static String route ="/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WebViewController _controller = WebViewController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) => {},
        onPageStarted: (url) => {},
        onPageFinished: (url) => {},
      ))
      ..loadRequest(Uri.parse('https://www.primehospitalltd.com/'));
  }

  @override
  Widget build(BuildContext context) {
    //user will exit or not
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                alignment: Alignment.center,
                content: const Text('Do you want to close the app?',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.9)),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            exit(0);
                          },
                          child: customButton(
                            textColor: Colors.white,
                            btnName: 'Yes',
                            borderColor: AppColors.primary,
                            context: context,
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async{
                            Get.back();
                          },
                          child: customButton(
                              textColor: Colors.white,
                              btnName: 'No',
                              borderColor: AppColors.primary,
                              context: context),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ) ??
          false;
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: WillPopScope(
              onWillPop: () async {
                if (await _controller.canGoBack()) {
                  _controller.goBack();

                  return false;
                } else {
                  showExitPopup();
                  return true;
                }
              },
              child: WebViewWidget(
                controller: _controller,
              ))),
    );
  }
}
