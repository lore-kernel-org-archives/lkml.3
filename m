Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaE1Ocn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:32:43 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:62855 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaE1OcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:32:25 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com,
        andrea.merello@gmail.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 2/2] Staging: rtl8192u: r8192U_wx.c Added {} braces and newlines
Date: Wed, 28 May 2014 07:32:39 -0700
Message-Id: <1401287559-7692-2-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401287559-7692-1-git-send-email-c@24.io>
References: <1401287559-7692-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added {} braces and newlines to address the following:

ERROR: else should follow close brace '}'
ERROR: space required before the open brace '{'
ERROR: trailing statements should be on next line
ERROR: space required before the open parenthesis '('
ERROR: that open brace { should be on the previous line

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_wx.c | 84 ++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 1ba03ad..1af7c5d 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -315,7 +315,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 		}
 
 		if (val == IW_MAX_FREQUENCIES)
-		break;
+			break;
 	}
 	range->num_frequency = val;
 	range->num_channels = val;
@@ -333,15 +333,14 @@ static int r8192_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 	struct ieee80211_device *ieee = priv->ieee80211;
 	int ret = 0;
 
-	if (!priv->up) return -ENETDOWN;
+	if (!priv->up)
+		return -ENETDOWN;
 
 	if (priv->ieee80211->LinkDetectInfo.bBusyTraffic == true)
 		return -EAGAIN;
-	if (wrqu->data.flags & IW_SCAN_THIS_ESSID)
-	{
+	if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 		struct iw_scan_req *req = (struct iw_scan_req *)b;
-		if (req->essid_len)
-		{
+		if (req->essid_len) {
 			//printk("==**&*&*&**===>scan set ssid:%s\n", req->essid);
 			ieee->current_network.ssid_len = req->essid_len;
 			memcpy(ieee->current_network.ssid, req->essid, req->essid_len);
@@ -354,9 +353,9 @@ static int r8192_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 		priv->ieee80211->scanning = 0;
 		ieee80211_softmac_scan_syncro(priv->ieee80211);
 		ret = 0;
+	} else {
+		ret = ieee80211_wx_set_scan(priv->ieee80211, a, wrqu, b);
 	}
-	else
-	ret = ieee80211_wx_set_scan(priv->ieee80211, a, wrqu, b);
 	up(&priv->wx_sem);
 	return ret;
 }
@@ -369,7 +368,8 @@ static int r8192_wx_get_scan(struct net_device *dev, struct iw_request_info *a,
 	int ret;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	if (!priv->up) return -ENETDOWN;
+	if (!priv->up)
+		return -ENETDOWN;
 
 	down(&priv->wx_sem);
 
@@ -530,7 +530,8 @@ static int r8192_wx_set_enc(struct net_device *dev,
 				{0x00, 0x00, 0x00, 0x00, 0x00, 0x03} };
 	int i;
 
-	if (!priv->up) return -ENETDOWN;
+	if (!priv->up)
+		return -ENETDOWN;
 
 	down(&priv->wx_sem);
 
@@ -546,8 +547,10 @@ static int r8192_wx_set_enc(struct net_device *dev,
 
 		for (i = 0; i < 4; i++) {
 			hwkey[i] |=  key[4*i+0]&mask;
-			if (i == 1 && (4*i+1) == wrqu->encoding.length) mask = 0x00;
-			if (i == 3 && (4*i+1) == wrqu->encoding.length) mask = 0x00;
+			if (i == 1 && (4*i+1) == wrqu->encoding.length)
+				mask = 0x00;
+			if (i == 3 && (4*i+1) == wrqu->encoding.length)
+				mask = 0x00;
 			hwkey[i] |= (key[4*i+1]&mask)<<8;
 			hwkey[i] |= (key[4*i+2]&mask)<<16;
 			hwkey[i] |= (key[4*i+3]&mask)<<24;
@@ -557,12 +560,23 @@ static int r8192_wx_set_enc(struct net_device *dev,
 		#define CONF_WEP104 0x14
 
 		switch (wrqu->encoding.flags & IW_ENCODE_INDEX) {
-		case 0: key_idx = ieee->tx_keyidx; break;
-		case 1:	key_idx = 0; break;
-		case 2:	key_idx = 1; break;
-		case 3:	key_idx = 2; break;
-		case 4:	key_idx	= 3; break;
-		default: break;
+		case 0:
+			key_idx = ieee->tx_keyidx;
+			break;
+		case 1:
+			key_idx = 0;
+			break;
+		case 2:
+			key_idx = 1;
+			break;
+		case 3:
+			key_idx = 2;
+			break;
+		case 4:
+			key_idx	= 3;
+			break;
+		default:
+			break;
 		}
 
 		if (wrqu->encoding.length == 0x5) {
@@ -591,8 +605,9 @@ static int r8192_wx_set_enc(struct net_device *dev,
 				0,                      //DefaultKey
 				hwkey);                 //KeyContent
 
+		} else {
+			printk("wrong type in WEP, not WEP40 and WEP104\n");
 		}
-		else printk("wrong type in WEP, not WEP40 and WEP104\n");
 
 	}
 
@@ -600,8 +615,8 @@ static int r8192_wx_set_enc(struct net_device *dev,
 }
 
 
-static int r8192_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa, union
-					iwreq_data *wrqu, char *p){
+static int r8192_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa,
+					union iwreq_data *wrqu, char *p){
 
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	int *parms = (int *)p;
@@ -751,18 +766,18 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 		struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 		struct iw_point *encoding = &wrqu->encoding;
 		u8 idx = 0, alg = 0, group = 0;
-		if ((encoding->flags & IW_ENCODE_DISABLED) ||
-		ext->alg == IW_ENCODE_ALG_NONE) //none is not allowed to use hwsec WB 2008.07.01
+		if ((encoding->flags & IW_ENCODE_DISABLED) || ext->alg == IW_ENCODE_ALG_NONE)
+			//none is not allowed to use hwsec WB 2008.07.01
 			goto end_hw_sec;
 
-		alg =  (ext->alg == IW_ENCODE_ALG_CCMP)?KEY_TYPE_CCMP:ext->alg; // as IW_ENCODE_ALG_CCMP is defined to be 3 and KEY_TYPE_CCMP is defined to 4;
+		// as IW_ENCODE_ALG_CCMP is defined to be 3 and KEY_TYPE_CCMP is defined to 4;
+		alg =  (ext->alg == IW_ENCODE_ALG_CCMP)?KEY_TYPE_CCMP:ext->alg;
 		idx = encoding->flags & IW_ENCODE_INDEX;
 		if (idx)
 			idx--;
 		group = ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY;
 
-		if ((!group) || (IW_MODE_ADHOC == ieee->iw_mode) || (alg ==  KEY_TYPE_WEP40))
-		{
+		if ((!group) || (IW_MODE_ADHOC == ieee->iw_mode) || (alg ==  KEY_TYPE_WEP40)) {
 			if ((ext->key_len == 13) && (alg == KEY_TYPE_WEP40))
 				alg = KEY_TYPE_WEP104;
 			ieee->pairwise_key_type = alg;
@@ -770,8 +785,7 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 		}
 		memcpy((u8 *)key, ext->key, 16); //we only get 16 bytes key.why? WB 2008.7.1
 
-		if ((alg & KEY_TYPE_WEP40) && (ieee->auth_mode != 2))
-		{
+		if ((alg & KEY_TYPE_WEP40) && (ieee->auth_mode != 2)) {
 
 			setKey(dev,
 					idx,//EntryNo
@@ -780,9 +794,7 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 					zero, //MacAddr
 					0,              //DefaultKey
 					key);           //KeyContent
-		}
-		else if (group)
-		{
+		} else if (group) {
 			ieee->group_key_type = alg;
 			setKey(dev,
 					idx,//EntryNo
@@ -791,9 +803,7 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 					broadcast_addr, //MacAddr
 					0,              //DefaultKey
 					key);           //KeyContent
-		}
-		else //pairwise key
-		{
+		} else {//pairwise key
 			setKey(dev,
 					4,//EntryNo
 					idx, //KeyIndex
@@ -863,8 +873,7 @@ static int dummy(struct net_device *dev, struct iw_request_info *a,
 }
 
 
-static iw_handler r8192_wx_handlers[] =
-{
+static iw_handler r8192_wx_handlers[] = {
 	NULL,                     /* SIOCSIWCOMMIT */
 	r8192_wx_get_name,	  /* SIOCGIWNAME */
 	dummy,                    /* SIOCSIWNWID */
@@ -971,8 +980,7 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 	int tmp_level = 0;
 	int tmp_qual = 0;
 	int tmp_noise = 0;
-	if (ieee->state < IEEE80211_LINKED)
-	{
+	if (ieee->state < IEEE80211_LINKED) {
 		wstats->qual.qual = 0;
 		wstats->qual.level = 0;
 		wstats->qual.noise = 0;
-- 
1.9.1

