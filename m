Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbaE2Up3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:45:29 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44664 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaE2Up1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:45:27 -0400
From: Chaitanya Hazarey <c@24.io>
To: dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        burzalodowa@gmail.com, andrea.merello@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 2/5] Staging: rtl8192u: r8192U_wx.c removed commented dead code
Date: Thu, 29 May 2014 13:45:18 -0700
Message-Id: <1401396321-29363-2-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401396321-29363-1-git-send-email-c@24.io>
References: <1401396321-29363-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed dead code, commented out printks and DMESG.

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_wx.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 675a12d..7dc2a96 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -341,10 +341,8 @@ static int r8192_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 	if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 		struct iw_scan_req *req = (struct iw_scan_req *)b;
 		if (req->essid_len) {
-			//printk("==**&*&*&**===>scan set ssid:%s\n", req->essid);
 			ieee->current_network.ssid_len = req->essid_len;
 			memcpy(ieee->current_network.ssid, req->essid, req->essid_len);
-			//printk("=====>network ssid:%s\n", ieee->current_network.ssid);
 		}
 	}
 
@@ -703,7 +701,6 @@ static int r8192_wx_get_retry(struct net_device *dev,
 		wrqu->retry.flags = IW_RETRY_LIMIT | IW_RETRY_MIN;
 		wrqu->retry.value = priv->retry_data;
 	}
-	//printk("returning %d",wrqu->retry.value);
 
 
 	return 0;
@@ -730,7 +727,6 @@ static int r8192_wx_set_sens(struct net_device *dev,
 
 	short err = 0;
 	down(&priv->wx_sem);
-	//DMESG("attempt to set sensivity to %ddb",wrqu->sens.value);
 	if (priv->rf_set_sens == NULL) {
 		err = -1; /* we have not this support for this radio */
 		goto exit;
@@ -754,7 +750,6 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 	int ret = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee80211;
-	//printk("===>%s()\n", __func__);
 
 
 	down(&priv->wx_sem);
@@ -828,7 +823,6 @@ static int r8192_wx_set_auth(struct net_device *dev,
 					union iwreq_data *data, char *extra)
 {
 	int ret = 0;
-	//printk("====>%s()\n", __func__);
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	down(&priv->wx_sem);
 	ret = ieee80211_wx_set_auth(priv->ieee80211, info, &(data->param), extra);
@@ -840,7 +834,6 @@ static int r8192_wx_set_mlme(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *wrqu, char *extra)
 {
-	//printk("====>%s()\n", __func__);
 
 	int ret = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
@@ -855,13 +848,11 @@ static int r8192_wx_set_gen_ie(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *data, char *extra)
 {
-	   //printk("====>%s(), len:%d\n", __func__, data->length);
 	int ret = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	down(&priv->wx_sem);
 	ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, data->data.length);
 	up(&priv->wx_sem);
-	//printk("<======%s(), ret:%d\n", __func__, ret);
 	return ret;
 
 
@@ -992,7 +983,6 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 	tmp_level = (&ieee->current_network)->stats.rssi;
 	tmp_qual = (&ieee->current_network)->stats.signal;
 	tmp_noise = (&ieee->current_network)->stats.noise;
-	//printk("level:%d, qual:%d, noise:%d\n", tmp_level, tmp_qual, tmp_noise);
 
 	wstats->qual.level = tmp_level;
 	wstats->qual.qual = tmp_qual;
-- 
1.9.1

