import 'dart:async';
import 'dart:collection';


import 'package:flutter/services.dart';

enum WifiState { error, success, already }

class Wifi {
  static const MethodChannel _channel = const MethodChannel('plugins.ly.com/wifi');

  static Future<String> get ssid async {
    return await _channel.invokeMethod('ssid');
  }
  static Future<String> get bssid async {
    return await _channel.invokeMethod('bssid');
  }

  static Future<int> get level async {
    return await _channel.invokeMethod('level');
  }

  static Future<String> get ip async {
    return await _channel.invokeMethod('ip');
  }

  static Future<List<WifiResult>> list(String key) async {
    final Map<String, dynamic> params = {
      'key': key,
    };
    var results = await _channel.invokeMethod('list', params);
    List<WifiResult> resultList = [];
    for (int i = 0; i < results.length; i++) {
      resultList.add(WifiResult(results[i]['ssid'], results[i]['level']));
    }
    return resultList;
  }
  static Future<List<WifiBSSIDResult>> bssidList(String key) async {
    final Map<String, dynamic> params = {
      'key': key,
    };
    var bssidResults = await _channel.invokeMethod('bssidList', params);
    List<WifiBSSIDResult> bssidResultList = [];
    for (int i = 0; i < bssidResults.length; i++) {
      bssidResultList.add(WifiBSSIDResult(bssidResults[i]['bssid'], bssidResults[i]['level']));
    }
    return bssidResultList;

  }

  static Future<Map<String, List<int>>> accessPointList(String key) async {
    final Map<String, dynamic> params = {
      'key': key,
    };
    var accessPoints = await _channel.invokeMethod('accessPointList', params);
    accessPoints.forEach((key,value) => print('${k}: ${v}'));
    return accessPoints;

  }


  static Future<WifiState> connection(String ssid, String password) async {
    final Map<String, dynamic> params = {
      'ssid': ssid,
      'password': password,
    };
    int state = await _channel.invokeMethod('connection', params);
    switch (state) {
      case 0:
        return WifiState.error;
      case 1:
        return WifiState.success;
      case 2:
        return WifiState.already;
      default:
        return WifiState.error;
    }
  }
}

class WifiResult {
  String ssid;
  int level;

  WifiResult(this.ssid, this.level);
}
class WifiBSSIDResult {
  String bssid;
  int level;
  WifiBSSIDResult(this.bssid, this.level);
}
