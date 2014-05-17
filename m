Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964894AbaEQRFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:05:25 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:51817 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964813AbaEQRFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:05:24 -0400
From: Joel Pelaez Jorge <joelpelaez@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Bob Copeland <me@bobcopeland.com>,
        Andrea Merello <andrea.merello@gmail.com>,
        Joe Perches <joe@perches.com>, Teodora Baluta <teobaluta@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>, Dave Jones <davej@redhat.com>,
        Ana Rey <anarey@gmail.com>, Xenia Ragiadakou <burzalodowa@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joel Pelaez Jorge <joelpelaez@gmail.com>
Subject: [PATCH] Staging: rtl8192u: Remove old WIRELESS_EXT support
Date: Sat, 17 May 2014 12:05:01 -0500
Message-Id: <1400346301-18389-1-git-send-email-joelpelaez@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove support for building against ancient WIRELESS_EXT versions,
only leaving support for the current version: 22

Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211.h    | 14 ---------
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c |  5 +--
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c | 38 ++---------------------
 drivers/staging/rtl8192u/r8192U_core.c            |  6 +---
 drivers/staging/rtl8192u/r8192U_wx.c              | 20 +-----------
 5 files changed, 5 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index cac2056..3b40b61 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -354,12 +354,10 @@ enum	_ReasonCode{
 #define ieee80211_wx_get_scan		ieee80211_wx_get_scan_rsl
 #define ieee80211_wx_set_encode		ieee80211_wx_set_encode_rsl
 #define ieee80211_wx_get_encode		ieee80211_wx_get_encode_rsl
-#if WIRELESS_EXT >= 18
 #define ieee80211_wx_set_mlme		ieee80211_wx_set_mlme_rsl
 #define ieee80211_wx_set_auth		ieee80211_wx_set_auth_rsl
 #define ieee80211_wx_set_encode_ext	ieee80211_wx_set_encode_ext_rsl
 #define ieee80211_wx_get_encode_ext	ieee80211_wx_get_encode_ext_rsl
-#endif
 
 
 typedef struct ieee_param {
@@ -392,16 +390,6 @@ typedef struct ieee_param {
 }ieee_param;
 
 
-#if WIRELESS_EXT < 17
-#define IW_QUAL_QUAL_INVALID   0x10
-#define IW_QUAL_LEVEL_INVALID  0x20
-#define IW_QUAL_NOISE_INVALID  0x40
-#define IW_QUAL_QUAL_UPDATED   0x1
-#define IW_QUAL_LEVEL_UPDATED  0x2
-#define IW_QUAL_NOISE_UPDATED  0x4
-#endif
-
-
 // linux under 2.6.9 release may not support it, so modify it for common use
 #define MSECS(t) msecs_to_jiffies(t)
 #define msleep_interruptible_rsl  msleep_interruptible
@@ -2398,7 +2386,6 @@ extern int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 extern int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
 				   struct iw_request_info *info,
 				   union iwreq_data *wrqu, char *key);
-#if WIRELESS_EXT >= 18
 extern int ieee80211_wx_get_encode_ext(struct ieee80211_device *ieee,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra);
@@ -2411,7 +2398,6 @@ extern int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
 extern int ieee80211_wx_set_mlme(struct ieee80211_device *ieee,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra);
-#endif
 extern int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len);
 
 /* ieee80211_softmac.c */
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index a98414a..b32f965 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -950,7 +950,6 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 	//IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, skb->data, skb->len);
 #ifdef NOT_YET
-#if WIRELESS_EXT > 15
 	/* Put this code here so that we avoid duplicating it in all
 	 * Rx paths. - Jean II */
 #ifdef IW_WIRELESS_SPY		/* defined in iw_handler.h */
@@ -964,18 +963,16 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		wireless_spy_update(dev, hdr->addr2, &wstats);
 	}
 #endif /* IW_WIRELESS_SPY */
-#endif /* WIRELESS_EXT > 15 */
 	hostap_update_rx_stats(local->ap, hdr, rx_stats);
 #endif
 
-#if WIRELESS_EXT > 15
 	if (ieee->iw_mode == IW_MODE_MONITOR) {
 		ieee80211_monitor_rx(ieee, skb, rx_stats);
 		stats->rx_packets++;
 		stats->rx_bytes += skb->len;
 		return 1;
 	}
-#endif
+
 	if (ieee->host_decrypt) {
 		int idx = 0;
 		if (skb->len >= hdrlen + 3)
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
index bdf67ec..b2660fe 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -194,37 +194,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 	iwe.u.data.length = p - custom;
 	if (iwe.u.data.length)
 	    start = iwe_stream_add_point(info, start, stop, &iwe, custom);
-#if (WIRELESS_EXT < 18)
-	if (ieee->wpa_enabled && network->wpa_ie_len){
-		char buf[MAX_WPA_IE_LEN * 2 + 30];
-	//	printk("WPA IE\n");
-		u8 *p = buf;
-		p += sprintf(p, "wpa_ie=");
-		for (i = 0; i < network->wpa_ie_len; i++) {
-			p += sprintf(p, "%02x", network->wpa_ie[i]);
-		}
-
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		iwe.u.data.length = strlen(buf);
-		start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-	}
-
-	if (ieee->wpa_enabled && network->rsn_ie_len){
-		char buf[MAX_WPA_IE_LEN * 2 + 30];
-
-		u8 *p = buf;
-		p += sprintf(p, "rsn_ie=");
-		for (i = 0; i < network->rsn_ie_len; i++) {
-			p += sprintf(p, "%02x", network->rsn_ie[i]);
-		}
 
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		iwe.u.data.length = strlen(buf);
-		start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-	}
-#else
 	memset(&iwe, 0, sizeof(iwe));
 	if (network->wpa_ie_len)
 	{
@@ -243,8 +213,6 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 		iwe.u.data.length = network->rsn_ie_len;
 		start = iwe_stream_add_point(info, start, stop, &iwe, buf);
 	}
-#endif
-
 
 	/* Add EXTRA: Age to display seconds since last beacon/probe response
 	 * for given network. */
@@ -521,7 +489,7 @@ int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
 
 	return 0;
 }
-#if (WIRELESS_EXT >= 18)
+
 int ieee80211_wx_set_encode_ext(struct ieee80211_device *ieee,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
@@ -828,7 +796,7 @@ int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
 	}
 	return 0;
 }
-#endif
+
 int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 {
 	u8 *buf;
@@ -864,12 +832,10 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 }
 
 EXPORT_SYMBOL(ieee80211_wx_set_gen_ie);
-#if (WIRELESS_EXT >= 18)
 EXPORT_SYMBOL(ieee80211_wx_set_mlme);
 EXPORT_SYMBOL(ieee80211_wx_set_auth);
 EXPORT_SYMBOL(ieee80211_wx_set_encode_ext);
 EXPORT_SYMBOL(ieee80211_wx_get_encode_ext);
-#endif
 EXPORT_SYMBOL(ieee80211_wx_get_scan);
 EXPORT_SYMBOL(ieee80211_wx_set_encode);
 EXPORT_SYMBOL(ieee80211_wx_get_encode);
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 1bb6143..7fde6e9 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -4981,12 +4981,8 @@ static int rtl8192_usb_probe(struct usb_interface *intf,
 
 	dev->netdev_ops = &rtl8192_netdev_ops;
 
-#if WIRELESS_EXT >= 12
-#if WIRELESS_EXT < 17
-	dev->get_wireless_stats = r8192_get_wireless_stats;
-#endif
 	dev->wireless_handlers = (struct iw_handler_def *) &r8192_wx_handlers_def;
-#endif
+
 	dev->type = ARPHRD_ETHER;
 
 	dev->watchdog_timeo = HZ*3;	//modified by john, 0805
diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 72db773..abae163 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -319,10 +319,8 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	}
 	range->num_frequency = val;
 	range->num_channels = val;
-#if WIRELESS_EXT > 17
 	range->enc_capa = IW_ENC_CAPA_WPA|IW_ENC_CAPA_WPA2|
 			  IW_ENC_CAPA_CIPHER_TKIP|IW_ENC_CAPA_CIPHER_CCMP;
-#endif
 	tmp->scan_capa = 0x01;
 	return 0;
 }
@@ -732,7 +730,6 @@ exit:
 	return err;
 }
 
-#if (WIRELESS_EXT >= 18)
 //hw security need to reorganized.
 static int r8192_wx_set_enc_ext(struct net_device *dev,
 					struct iw_request_info *info,
@@ -842,7 +839,7 @@ static int r8192_wx_set_mlme(struct net_device *dev,
 	up(&priv->wx_sem);
 	return ret;
 }
-#endif
+
 static int r8192_wx_set_gen_ie(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *data, char *extra)
@@ -890,11 +887,7 @@ static iw_handler r8192_wx_handlers[] =
 	NULL,                     /* SIOCWIWTHRSPY */
 	r8192_wx_set_wap,	  /* SIOCSIWAP */
 	r8192_wx_get_wap,         /* SIOCGIWAP */
-#if (WIRELESS_EXT >= 18)
 	r8192_wx_set_mlme,                     /* MLME-- */
-#else
-	 NULL,
-#endif
 	dummy,                     /* SIOCGIWAPLIST -- deprecated */
 	r8192_wx_set_scan,        /* SIOCSIWSCAN */
 	r8192_wx_get_scan,        /* SIOCGIWSCAN */
@@ -923,17 +916,10 @@ static iw_handler r8192_wx_handlers[] =
 	r8192_wx_set_gen_ie,//NULL,			/* SIOCSIWGENIE */
 	NULL,			/* SIOCSIWGENIE */
 
-#if (WIRELESS_EXT >= 18)
 	r8192_wx_set_auth,//NULL,			/* SIOCSIWAUTH */
 	NULL,//r8192_wx_get_auth,//NULL,			/* SIOCSIWAUTH */
 	r8192_wx_set_enc_ext,			/* SIOCSIWENCODEEXT */
 	NULL,//r8192_wx_get_enc_ext,//NULL,			/* SIOCSIWENCODEEXT */
-#else
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-#endif
 	NULL,			/* SIOCSIWPMKSA */
 	NULL,			 /*---hole---*/
 
@@ -977,7 +963,6 @@ static iw_handler r8192_private_handler[] = {
 	r8192_wx_force_reset,
 };
 
-//#if WIRELESS_EXT >= 17
 struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 {
        struct r8192_priv *priv = ieee80211_priv(dev);
@@ -1006,7 +991,6 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 	wstats->qual.updated = IW_QUAL_ALL_UPDATED| IW_QUAL_DBM;
 	return wstats;
 }
-//#endif
 
 
 struct iw_handler_def  r8192_wx_handlers_def={
@@ -1015,8 +999,6 @@ struct iw_handler_def  r8192_wx_handlers_def={
 	.private = r8192_private_handler,
 	.num_private = ARRAY_SIZE(r8192_private_handler),
 	.num_private_args = sizeof(r8192_private_args) / sizeof(struct iw_priv_args),
-#if WIRELESS_EXT >= 17
 	.get_wireless_stats = r8192_get_wireless_stats,
-#endif
 	.private_args = (struct iw_priv_args *)r8192_private_args,
 };
-- 
1.9.3

