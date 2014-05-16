Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaEPMbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:31:05 -0400
Received: from isis.lip6.fr ([132.227.60.2]:50294 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbaEPMbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:31:03 -0400
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2014 08:31:02 EDT
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: benoit.taine@lip6.fr, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging/rtl8192u: Put EXPORT_SYMBOL just after the exported function
Date: Fri, 16 May 2014 14:22:41 +0200
Message-Id: <1400242961-6781-1-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Fri, 16 May 2014 14:22:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export of symbols statement must be placed right after the definition to meet
kernel coding style guidelines. This issue was reported by checkpatch.

A simplified version of the semantic patch that makes this change is as
follows (http://coccinelle.lip6.fr/):

// <smpl>

@ r @ identifier f; @@
- EXPORT_SYMBOL(f);

@@ identifier r.f; @@
  f(...) { ... }
+ EXPORT_SYMBOL(f);

// </smpl>

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c         |    3 
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c    |   52 +++++---------
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c |   42 ++++-------
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c         |    3 
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c         |   19 ++---
 drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c       |    3 
 6 files changed, 52 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index a98414a..92707fb 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -1387,6 +1387,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	 * hardware as a DMA target */
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_rx);
 
 #define MGMT_FRAME_FIXED_PART_LENGTH            0x24
 
@@ -2643,6 +2644,4 @@ void ieee80211_rx_mgt(struct ieee80211_device *ieee,
 
 	}
 }
-
 EXPORT_SYMBOL(ieee80211_rx_mgt);
-EXPORT_SYMBOL(ieee80211_rx);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 9caf6fd..d2eea3c 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -28,11 +28,13 @@ short ieee80211_is_54g(const struct ieee80211_network *net)
 {
 	return (net->rates_ex_len > 0) || (net->rates_len > 4);
 }
+EXPORT_SYMBOL(ieee80211_is_54g);
 
 short ieee80211_is_shortslot(const struct ieee80211_network *net)
 {
 	return net->capability & WLAN_CAPABILITY_SHORT_SLOT;
 }
+EXPORT_SYMBOL(ieee80211_is_shortslot);
 
 /* returns the total length needed for pleacing the RATE MFIE
  * tag and the EXTENDED RATE MFIE tag if needed.
@@ -415,6 +417,7 @@ void ieee80211_send_probe_requests(struct ieee80211_device *ieee)
 		ieee80211_send_probe(ieee);
 	}
 }
+EXPORT_SYMBOL(ieee80211_send_probe_requests);
 
 /* this performs syncro scan blocking the caller until all channels
  * in the allowed channel map has been checked.
@@ -485,7 +488,7 @@ out:
 	up(&ieee->scan_sem);
 }
 }
-
+EXPORT_SYMBOL(ieee80211_softmac_scan_syncro);
 
 static void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
@@ -563,7 +566,7 @@ void ieee80211_stop_send_beacons(struct ieee80211_device *ieee)
 	if (ieee->softmac_features & IEEE_SOFTMAC_BEACONS)
 		ieee80211_beacons_stop(ieee);
 }
-
+EXPORT_SYMBOL(ieee80211_stop_send_beacons);
 
 void ieee80211_start_send_beacons(struct ieee80211_device *ieee)
 {
@@ -572,7 +575,7 @@ void ieee80211_start_send_beacons(struct ieee80211_device *ieee)
 	if(ieee->softmac_features & IEEE_SOFTMAC_BEACONS)
 		ieee80211_beacons_start(ieee);
 }
-
+EXPORT_SYMBOL(ieee80211_start_send_beacons);
 
 static void ieee80211_softmac_stop_scan(struct ieee80211_device *ieee)
 {
@@ -600,6 +603,7 @@ void ieee80211_stop_scan(struct ieee80211_device *ieee)
 	else
 		ieee->stop_scan(ieee->dev);
 }
+EXPORT_SYMBOL(ieee80211_stop_scan);
 
 /* called with ieee->lock held */
 static void ieee80211_start_scan(struct ieee80211_device *ieee)
@@ -638,6 +642,7 @@ void ieee80211_start_scan_syncro(struct ieee80211_device *ieee)
 		ieee->scan_syncro(ieee->dev);
 
 }
+EXPORT_SYMBOL(ieee80211_start_scan_syncro);
 
 inline struct sk_buff *ieee80211_authentication_req(struct ieee80211_network *beacon,
 	struct ieee80211_device *ieee, int challengelen)
@@ -1709,8 +1714,6 @@ ieee80211_rx_assoc_rq(struct ieee80211_device *ieee, struct sk_buff *skb)
 	//FIXME
 }
 
-
-
 static void ieee80211_sta_ps_send_null_frame(struct ieee80211_device *ieee,
 					     short pwr)
 {
@@ -1721,7 +1724,7 @@ static void ieee80211_sta_ps_send_null_frame(struct ieee80211_device *ieee,
 		softmac_ps_mgmt_xmit(buf, ieee);
 
 }
-
+/* EXPORT_SYMBOL(ieee80211_sta_ps_send_null_frame); */
 
 static short ieee80211_sta_ps_sleep(struct ieee80211_device *ieee, u32 *time_h,
 				    u32 *time_l)
@@ -1889,6 +1892,8 @@ void ieee80211_ps_tx_ack(struct ieee80211_device *ieee, short success)
 	}
 	spin_unlock_irqrestore(&ieee->lock, flags);
 }
+EXPORT_SYMBOL(ieee80211_ps_tx_ack);
+
 static void ieee80211_process_action(struct ieee80211_device *ieee,
 				     struct sk_buff *skb)
 {
@@ -2188,6 +2193,7 @@ void ieee80211_softmac_xmit(struct ieee80211_txb *txb, struct ieee80211_device *
 	spin_unlock_irqrestore(&ieee->lock,flags);
 
 }
+EXPORT_SYMBOL(ieee80211_softmac_xmit);
 
 /* called with ieee->lock acquired */
 static void ieee80211_resume_tx(struct ieee80211_device *ieee)
@@ -2229,6 +2235,7 @@ void ieee80211_reset_queue(struct ieee80211_device *ieee)
 	spin_unlock_irqrestore(&ieee->lock,flags);
 
 }
+EXPORT_SYMBOL(ieee80211_reset_queue);
 
 void ieee80211_wake_queue(struct ieee80211_device *ieee)
 {
@@ -2269,7 +2276,7 @@ void ieee80211_wake_queue(struct ieee80211_device *ieee)
 exit :
 	spin_unlock_irqrestore(&ieee->lock,flags);
 }
-
+EXPORT_SYMBOL(ieee80211_wake_queue);
 
 void ieee80211_stop_queue(struct ieee80211_device *ieee)
 {
@@ -2284,7 +2291,7 @@ void ieee80211_stop_queue(struct ieee80211_device *ieee)
 	//spin_unlock_irqrestore(&ieee->lock,flags);
 
 }
-
+EXPORT_SYMBOL(ieee80211_stop_queue);
 
 inline void ieee80211_randomize_cell(struct ieee80211_device *ieee)
 {
@@ -2502,6 +2509,8 @@ void ieee80211_disassociate(struct ieee80211_device *ieee)
 	notify_wx_assoc_event(ieee);
 
 }
+EXPORT_SYMBOL(ieee80211_disassociate);
+
 static void ieee80211_associate_retry_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
@@ -2581,6 +2590,7 @@ struct sk_buff *ieee80211_get_beacon(struct ieee80211_device *ieee)
 
 	return skb;
 }
+EXPORT_SYMBOL(ieee80211_get_beacon);
 
 void ieee80211_softmac_stop_protocol(struct ieee80211_device *ieee)
 {
@@ -2589,7 +2599,7 @@ void ieee80211_softmac_stop_protocol(struct ieee80211_device *ieee)
 	ieee80211_stop_protocol(ieee);
 	up(&ieee->wx_sem);
 }
-
+EXPORT_SYMBOL(ieee80211_softmac_stop_protocol);
 
 void ieee80211_stop_protocol(struct ieee80211_device *ieee)
 {
@@ -2615,6 +2625,7 @@ void ieee80211_softmac_start_protocol(struct ieee80211_device *ieee)
 	ieee80211_start_protocol(ieee);
 	up(&ieee->wx_sem);
 }
+EXPORT_SYMBOL(ieee80211_softmac_start_protocol);
 
 void ieee80211_start_protocol(struct ieee80211_device *ieee)
 {
@@ -3138,6 +3149,7 @@ SendDisassociation(
 				//dev_kfree_skb_any(skb);//edit by thomas
 		}
 }
+EXPORT_SYMBOL(SendDisassociation);
 
 int ieee80211_wpa_supplicant_ioctl(struct ieee80211_device *ieee, struct iw_point *p)
 {
@@ -3193,6 +3205,7 @@ out:
 
 	return ret;
 }
+EXPORT_SYMBOL(ieee80211_wpa_supplicant_ioctl);
 
 void notify_wx_assoc_event(struct ieee80211_device *ieee)
 {
@@ -3204,25 +3217,4 @@ void notify_wx_assoc_event(struct ieee80211_device *ieee)
 		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
 	wireless_send_event(ieee->dev, SIOCGIWAP, &wrqu, NULL);
 }
-
-EXPORT_SYMBOL(ieee80211_get_beacon);
-EXPORT_SYMBOL(ieee80211_wake_queue);
-EXPORT_SYMBOL(ieee80211_stop_queue);
-EXPORT_SYMBOL(ieee80211_reset_queue);
-EXPORT_SYMBOL(ieee80211_softmac_stop_protocol);
-EXPORT_SYMBOL(ieee80211_softmac_start_protocol);
-EXPORT_SYMBOL(ieee80211_is_shortslot);
-EXPORT_SYMBOL(ieee80211_is_54g);
-EXPORT_SYMBOL(ieee80211_wpa_supplicant_ioctl);
-EXPORT_SYMBOL(ieee80211_ps_tx_ack);
-EXPORT_SYMBOL(ieee80211_softmac_xmit);
-EXPORT_SYMBOL(ieee80211_stop_send_beacons);
 EXPORT_SYMBOL(notify_wx_assoc_event);
-EXPORT_SYMBOL(SendDisassociation);
-EXPORT_SYMBOL(ieee80211_disassociate);
-EXPORT_SYMBOL(ieee80211_start_send_beacons);
-EXPORT_SYMBOL(ieee80211_stop_scan);
-EXPORT_SYMBOL(ieee80211_send_probe_requests);
-EXPORT_SYMBOL(ieee80211_softmac_scan_syncro);
-EXPORT_SYMBOL(ieee80211_start_scan_syncro);
-//EXPORT_SYMBOL(ieee80211_sta_ps_send_null_frame);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index 7b7d929..a381768 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -26,7 +26,7 @@ const long ieee80211_wlan_frequencies[] = {
 	2452, 2457, 2462, 2467,
 	2472, 2484
 };
-
+EXPORT_SYMBOL(ieee80211_wlan_frequencies);
 
 int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_request_info *a,
 			     union iwreq_data *wrqu, char *b)
@@ -83,7 +83,7 @@ out:
 	up(&ieee->wx_sem);
 	return ret;
 }
-
+EXPORT_SYMBOL(ieee80211_wx_set_freq);
 
 int ieee80211_wx_get_freq(struct ieee80211_device *ieee,
 			     struct iw_request_info *a,
@@ -101,6 +101,7 @@ int ieee80211_wx_get_freq(struct ieee80211_device *ieee,
 
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_wx_get_freq);
 
 int ieee80211_wx_get_wap(struct ieee80211_device *ieee,
 			    struct iw_request_info *info,
@@ -129,7 +130,7 @@ int ieee80211_wx_get_wap(struct ieee80211_device *ieee,
 
 	return 0;
 }
-
+EXPORT_SYMBOL(ieee80211_wx_get_wap);
 
 int ieee80211_wx_set_wap(struct ieee80211_device *ieee,
 			 struct iw_request_info *info,
@@ -176,6 +177,7 @@ out:
 	up(&ieee->wx_sem);
 	return ret;
 }
+EXPORT_SYMBOL(ieee80211_wx_set_wap);
 
  int ieee80211_wx_get_essid(struct ieee80211_device *ieee, struct iw_request_info *a,union iwreq_data *wrqu,char *b)
 {
@@ -211,6 +213,7 @@ out:
 	return ret;
 
 }
+EXPORT_SYMBOL(ieee80211_wx_get_essid);
 
 int ieee80211_wx_set_rate(struct ieee80211_device *ieee,
 			     struct iw_request_info *info,
@@ -223,8 +226,7 @@ int ieee80211_wx_set_rate(struct ieee80211_device *ieee,
 	//FIXME: we might want to limit rate also in management protocols.
 	return 0;
 }
-
-
+EXPORT_SYMBOL(ieee80211_wx_set_rate);
 
 int ieee80211_wx_get_rate(struct ieee80211_device *ieee,
 			     struct iw_request_info *info,
@@ -237,7 +239,7 @@ int ieee80211_wx_get_rate(struct ieee80211_device *ieee,
 
 	return 0;
 }
-
+EXPORT_SYMBOL(ieee80211_wx_get_rate);
 
 int ieee80211_wx_set_rts(struct ieee80211_device *ieee,
 			     struct iw_request_info *info,
@@ -254,6 +256,7 @@ int ieee80211_wx_set_rts(struct ieee80211_device *ieee,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_wx_set_rts);
 
 int ieee80211_wx_get_rts(struct ieee80211_device *ieee,
 			     struct iw_request_info *info,
@@ -264,6 +267,8 @@ int ieee80211_wx_get_rts(struct ieee80211_device *ieee,
 	wrqu->rts.disabled = (wrqu->rts.value == DEFAULT_RTS_THRESHOLD);
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_wx_get_rts);
+
 int ieee80211_wx_set_mode(struct ieee80211_device *ieee, struct iw_request_info *a,
 			     union iwreq_data *wrqu, char *b)
 {
@@ -294,6 +299,7 @@ out:
 	up(&ieee->wx_sem);
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_wx_set_mode);
 
 void ieee80211_wx_sync_scan_wq(struct work_struct *work)
 {
@@ -378,6 +384,7 @@ out:
 	up(&ieee->wx_sem);
 	return ret;
 }
+EXPORT_SYMBOL(ieee80211_wx_set_scan);
 
 int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
 			      struct iw_request_info *a,
@@ -432,6 +439,7 @@ out:
 	up(&ieee->wx_sem);
 	return ret;
 }
+EXPORT_SYMBOL(ieee80211_wx_set_essid);
 
  int ieee80211_wx_get_mode(struct ieee80211_device *ieee, struct iw_request_info *a,
 			     union iwreq_data *wrqu, char *b)
@@ -440,6 +448,7 @@ out:
 	wrqu->mode = ieee->iw_mode;
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_wx_get_mode);
 
  int ieee80211_wx_set_rawtx(struct ieee80211_device *ieee,
 			       struct iw_request_info *info,
@@ -477,6 +486,7 @@ out:
 
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_wx_set_rawtx);
 
 int ieee80211_wx_get_name(struct ieee80211_device *ieee,
 			     struct iw_request_info *info,
@@ -502,7 +512,7 @@ int ieee80211_wx_get_name(struct ieee80211_device *ieee,
 
 	return 0;
 }
-
+EXPORT_SYMBOL(ieee80211_wx_get_name);
 
 /* this is mostly stolen from hostap */
 int ieee80211_wx_set_power(struct ieee80211_device *ieee,
@@ -553,6 +563,7 @@ exit:
 	return ret;
 
 }
+EXPORT_SYMBOL(ieee80211_wx_set_power);
 
 /* this is stolen from hostap */
 int ieee80211_wx_get_power(struct ieee80211_device *ieee,
@@ -593,21 +604,4 @@ exit:
 	return ret;
 
 }
-EXPORT_SYMBOL(ieee80211_wx_get_essid);
-EXPORT_SYMBOL(ieee80211_wx_set_essid);
-EXPORT_SYMBOL(ieee80211_wx_set_rate);
-EXPORT_SYMBOL(ieee80211_wx_get_rate);
-EXPORT_SYMBOL(ieee80211_wx_set_wap);
-EXPORT_SYMBOL(ieee80211_wx_get_wap);
-EXPORT_SYMBOL(ieee80211_wx_set_mode);
-EXPORT_SYMBOL(ieee80211_wx_get_mode);
-EXPORT_SYMBOL(ieee80211_wx_set_scan);
-EXPORT_SYMBOL(ieee80211_wx_get_freq);
-EXPORT_SYMBOL(ieee80211_wx_set_freq);
-EXPORT_SYMBOL(ieee80211_wx_set_rawtx);
-EXPORT_SYMBOL(ieee80211_wx_get_name);
-EXPORT_SYMBOL(ieee80211_wx_set_power);
 EXPORT_SYMBOL(ieee80211_wx_get_power);
-EXPORT_SYMBOL(ieee80211_wlan_frequencies);
-EXPORT_SYMBOL(ieee80211_wx_set_rts);
-EXPORT_SYMBOL(ieee80211_wx_get_rts);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 6779bdd..953717f 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -236,6 +236,7 @@ void ieee80211_txb_free(struct ieee80211_txb *txb) {
 		return;
 	kfree(txb);
 }
+EXPORT_SYMBOL(ieee80211_txb_free);
 
 static struct ieee80211_txb *ieee80211_alloc_txb(int nr_frags, int txb_size,
 						 gfp_t gfp_mask)
@@ -913,5 +914,3 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 	return 1;
 
 }
-
-EXPORT_SYMBOL(ieee80211_txb_free);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
index bdf67ec..38f124d 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -305,6 +305,7 @@ int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
 
 	return err;
 }
+EXPORT_SYMBOL(ieee80211_wx_get_scan);
 
 int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 			    struct iw_request_info *info,
@@ -479,6 +480,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_wx_set_encode);
 
 int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
 			    struct iw_request_info *info,
@@ -521,6 +523,8 @@ int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
 
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_wx_get_encode);
+
 #if (WIRELESS_EXT >= 18)
 int ieee80211_wx_set_encode_ext(struct ieee80211_device *ieee,
 			       struct iw_request_info *info,
@@ -695,6 +699,7 @@ done:
 	}
 	return ret;
 }
+EXPORT_SYMBOL(ieee80211_wx_set_encode_ext);
 
 int ieee80211_wx_get_encode_ext(struct ieee80211_device *ieee,
 			       struct iw_request_info *info,
@@ -750,6 +755,7 @@ int ieee80211_wx_get_encode_ext(struct ieee80211_device *ieee,
 
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_wx_get_encode_ext);
 
 int ieee80211_wx_set_mlme(struct ieee80211_device *ieee,
 			       struct iw_request_info *info,
@@ -766,6 +772,7 @@ int ieee80211_wx_set_mlme(struct ieee80211_device *ieee,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_wx_set_mlme);
 
 int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
 			       struct iw_request_info *info,
@@ -828,7 +835,9 @@ int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(ieee80211_wx_set_auth);
 #endif
+
 int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 {
 	u8 *buf;
@@ -862,14 +871,4 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 	return 0;
 
 }
-
 EXPORT_SYMBOL(ieee80211_wx_set_gen_ie);
-#if (WIRELESS_EXT >= 18)
-EXPORT_SYMBOL(ieee80211_wx_set_mlme);
-EXPORT_SYMBOL(ieee80211_wx_set_auth);
-EXPORT_SYMBOL(ieee80211_wx_set_encode_ext);
-EXPORT_SYMBOL(ieee80211_wx_get_encode_ext);
-#endif
-EXPORT_SYMBOL(ieee80211_wx_get_scan);
-EXPORT_SYMBOL(ieee80211_wx_set_encode);
-EXPORT_SYMBOL(ieee80211_wx_get_encode);
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
index 53ec2d4..0484145 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
@@ -1319,6 +1319,7 @@ void HTUpdateSelfAndPeerSetting(struct ieee80211_device *ieee,	struct ieee80211_
 		//
 	}
 }
+EXPORT_SYMBOL(HTUpdateSelfAndPeerSetting);
 
 /********************************************************************************************************************
  *function:  check whether HT control field exists
@@ -1416,5 +1417,3 @@ void HTSetConnectBwModeCallback(struct ieee80211_device *ieee)
 
 	pHTInfo->bSwBwInProgress = false;
 }
-
-EXPORT_SYMBOL(HTUpdateSelfAndPeerSetting);

