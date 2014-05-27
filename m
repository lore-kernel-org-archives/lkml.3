Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaE0UJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:09:57 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:55223 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaE0UJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:09:55 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, andrea.merello@gmail.com,
        linville@tuxdriver.com, burzalodowa@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, c@24.io
Subject: [PATCH 6/6] Staging: rtl8192u: r8180_93cx6.c & r8192U_wx.c fix checkpatch.pl errors and warnings
Date: Tue, 27 May 2014 13:09:50 -0700
Message-Id: <1401221390-10655-6-git-send-email-c@24.io>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401221390-10655-1-git-send-email-c@24.io>
References: <1401221390-10655-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up dead code, added curly {} braces where needed
	and fixed the following:

ERROR: do not use C99 // comments
ERROR: else should follow close brace '}'
ERROR: space required after that ',' (ctx:VxV)
ERROR: space required before the open brace '{'
ERROR: spaces required around that '=' (ctx:WxV)
ERROR: space required after that close brace '}'
ERROR: spaces required around that '=' (ctx:VxW)
ERROR: spaces required around that '=' (ctx:VxV)
ERROR: spaces required around that '<' (ctx:VxV)
ERROR: spaces required around that '!=' (ctx:WxV)
ERROR: spaces required around that '==' (ctx:VxV)
ERROR: spaces required around that '!=' (ctx:VxV)
ERROR: spaces required around that '&&' (ctx:VxV)
ERROR: trailing statements should be on next line
ERROR: space prohibited before that '--' (ctx:WxO)
ERROR: need consistent spacing around '|' (ctx:VxW)
ERROR: need consistent spacing around '*' (ctx:WxV)
ERROR: space required before the open parenthesis '('
ERROR: that open brace { should be on the previous line
ERROR: space prohibited after that open parenthesis '('
ERROR: space prohibited before that close parenthesis ')'

WARNING: missing space after struct definition
WARNING: Missing a blank line after declarations
WARNING: please, no spaces at the start of a line
WARNING: suspect code indent for conditional statements (16, 16)
WARNING: __func__ should be used instead of gcc specific __FUNCTION__

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_wx.c |  131 ++++++++++++++++------------------
 1 file changed, 61 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 7480c0e..ad95895 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -740,77 +740,72 @@ exit:
 	return err;
 }
 
-//hw security need to reorganized.
+/*hw security need to reorganized. */
 static int r8192_wx_set_enc_ext(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *wrqu, char *extra)
 {
-	int ret=0;
+	int ret = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee80211;
-	//printk("===>%s()\n", __func__);
-
 
 	down(&priv->wx_sem);
 	ret = ieee80211_wx_set_encode_ext(priv->ieee80211, info, wrqu, extra);
 
 	{
-		u8 broadcast_addr[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
+		u8 broadcast_addr[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 		u8 zero[6] = {0};
 		u32 key[4] = {0};
 		struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 		struct iw_point *encoding = &wrqu->encoding;
 		u8 idx = 0, alg = 0, group = 0;
+
 		if ((encoding->flags & IW_ENCODE_DISABLED) ||
-		ext->alg == IW_ENCODE_ALG_NONE) //none is not allowed to use hwsec WB 2008.07.01
+				ext->alg == IW_ENCODE_ALG_NONE)
+			/*none is not allowed to use hwsec WB 2008.07.01 */
 			goto end_hw_sec;
 
-		alg =  (ext->alg == IW_ENCODE_ALG_CCMP)?KEY_TYPE_CCMP:ext->alg; // as IW_ENCODE_ALG_CCMP is defined to be 3 and KEY_TYPE_CCMP is defined to 4;
+		/* as IW_ENCODE_ALG_CCMP is defined to be 3 and KEY_TYPE_CCMP is defined to 4; */
+		alg =  (ext->alg == IW_ENCODE_ALG_CCMP)?KEY_TYPE_CCMP:ext->alg;
 		idx = encoding->flags & IW_ENCODE_INDEX;
 		if (idx)
-			idx --;
+			idx--;
 		group = ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY;
 
-		if ((!group) || (IW_MODE_ADHOC == ieee->iw_mode) || (alg ==  KEY_TYPE_WEP40))
-		{
-			if ((ext->key_len == 13) && (alg == KEY_TYPE_WEP40) )
+		if ((!group) || (IW_MODE_ADHOC == ieee->iw_mode) || (alg ==  KEY_TYPE_WEP40)) {
+			if ((ext->key_len == 13) && (alg == KEY_TYPE_WEP40))
 				alg = KEY_TYPE_WEP104;
 			ieee->pairwise_key_type = alg;
 			EnableHWSecurityConfig8192(dev);
 		}
-		memcpy((u8 *)key, ext->key, 16); //we only get 16 bytes key.why? WB 2008.7.1
-
-		if ((alg & KEY_TYPE_WEP40) && (ieee->auth_mode !=2) )
-		{
-
-			setKey( dev,
-					idx,//EntryNo
-					idx, //KeyIndex
-					alg,  //KeyType
-					zero, //MacAddr
-					0,              //DefaultKey
-					key);           //KeyContent
-		}
-		else if (group)
-		{
+		memcpy((u8 *)key, ext->key, 16); /*we only get 16 bytes key.why? WB 2008.7.1 */
+
+		if ((alg & KEY_TYPE_WEP40) && (ieee->auth_mode != 2)) {
+
+			setKey(dev,
+					idx,/*EntryNo */
+					idx, /*KeyIndex */
+					alg,  /*KeyType */
+					zero, /*MacAddr */
+					0,              /*DefaultKey */
+					key);           /*KeyContent */
+		} else if (group) {
 			ieee->group_key_type = alg;
-			setKey( dev,
-					idx,//EntryNo
-					idx, //KeyIndex
-					alg,  //KeyType
-					broadcast_addr, //MacAddr
-					0,              //DefaultKey
-					key);           //KeyContent
-		}
-		else //pairwise key
-		{
-			setKey( dev,
-					4,//EntryNo
-					idx, //KeyIndex
-					alg,  //KeyType
-					(u8 *)ieee->ap_mac_addr, //MacAddr
-					0,              //DefaultKey
-					key);           //KeyContent
+			setKey(dev,
+					idx,/*EntryNo */
+					idx, /*KeyIndex */
+					alg,  /*KeyType */
+					broadcast_addr, /*MacAddr */
+					0,              /*DefaultKey */
+					key);           /*KeyContent */
+		} else /*pairwise key */ {
+			setKey(dev,
+					4,/*EntryNo */
+					idx, /*KeyIndex */
+					alg,  /*KeyType */
+					(u8 *)ieee->ap_mac_addr, /*MacAddr */
+					0,              /*DefaultKey */
+					key);           /*KeyContent */
 		}
 
 
@@ -826,9 +821,9 @@ static int r8192_wx_set_auth(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *data, char *extra)
 {
-	int ret=0;
-	//printk("====>%s()\n", __func__);
+	int ret = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
+
 	down(&priv->wx_sem);
 	ret = ieee80211_wx_set_auth(priv->ieee80211, info, &(data->param), extra);
 	up(&priv->wx_sem);
@@ -839,10 +834,9 @@ static int r8192_wx_set_mlme(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *wrqu, char *extra)
 {
-	//printk("====>%s()\n", __func__);
-
-	int ret=0;
+	int ret = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
+
 	down(&priv->wx_sem);
 	ret = ieee80211_wx_set_mlme(priv->ieee80211, info, wrqu, extra);
 
@@ -854,27 +848,25 @@ static int r8192_wx_set_gen_ie(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *data, char *extra)
 {
-	   //printk("====>%s(), len:%d\n", __func__, data->length);
-	int ret=0;
+	int ret = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
+
 	down(&priv->wx_sem);
 	ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, data->data.length);
 	up(&priv->wx_sem);
-	//printk("<======%s(), ret:%d\n", __func__, ret);
 	return ret;
 
 
 }
 
 static int dummy(struct net_device *dev, struct iw_request_info *a,
-		 union iwreq_data *wrqu,char *b)
+		 union iwreq_data *wrqu, char *b)
 {
 	return -1;
 }
 
 
-static iw_handler r8192_wx_handlers[] =
-{
+static iw_handler r8192_wx_handlers[] = {
 	NULL,                     /* SIOCSIWCOMMIT */
 	r8192_wx_get_name,	  /* SIOCGIWNAME */
 	dummy,                    /* SIOCSIWNWID */
@@ -923,13 +915,13 @@ static iw_handler r8192_wx_handlers[] =
 	r8192_wx_get_power,                    /* SIOCGIWPOWER */
 	NULL,			/*---hole---*/
 	NULL,			/*---hole---*/
-	r8192_wx_set_gen_ie,//NULL,			/* SIOCSIWGENIE */
+	r8192_wx_set_gen_ie,/*NULL, */			/* SIOCSIWGENIE */
 	NULL,			/* SIOCSIWGENIE */
 
-	r8192_wx_set_auth,//NULL,			/* SIOCSIWAUTH */
-	NULL,//r8192_wx_get_auth,//NULL,			/* SIOCSIWAUTH */
+	r8192_wx_set_auth,/*NULL, */			/* SIOCSIWAUTH */
+	NULL,/*r8192_wx_get_auth,*//*NULL,*/			/* SIOCSIWAUTH */
 	r8192_wx_set_enc_ext,			/* SIOCSIWENCODEEXT */
-	NULL,//r8192_wx_get_enc_ext,//NULL,			/* SIOCSIWENCODEEXT */
+	NULL,/*r8192_wx_get_enc_ext,*//*NULL,*/			/* SIOCSIWENCODEEXT */
 	NULL,			/* SIOCSIWPMKSA */
 	NULL,			 /*---hole---*/
 
@@ -962,27 +954,27 @@ static const struct iw_priv_args r8192_private_args[] = {
 
 
 static iw_handler r8192_private_handler[] = {
-//	r8192_wx_set_monitor,  /* SIOCIWFIRSTPRIV */
+/*	r8192_wx_set_monitor, *//* SIOCIWFIRSTPRIV */
 	r8192_wx_set_crcmon,   /*SIOCIWSECONDPRIV*/
-//	r8192_wx_set_forceassociate,
-//	r8192_wx_set_beaconinterval,
-//	r8192_wx_set_monitor_type,
+/*	r8192_wx_set_forceassociate, */
+/*	r8192_wx_set_beaconinterval, */
+/*	r8192_wx_set_monitor_type, */
 	r8192_wx_set_scan_type,
 	r8192_wx_set_rawtx,
-	//r8192_wx_null,
+	/*r8192_wx_null, */
 	r8192_wx_force_reset,
 };
 
 struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 {
-       struct r8192_priv *priv = ieee80211_priv(dev);
+	struct r8192_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee80211;
 	struct iw_statistics *wstats = &priv->wstats;
 	int tmp_level = 0;
 	int tmp_qual = 0;
 	int tmp_noise = 0;
-	if(ieee->state < IEEE80211_LINKED)
-	{
+
+	if (ieee->state < IEEE80211_LINKED) {
 		wstats->qual.qual = 0;
 		wstats->qual.level = 0;
 		wstats->qual.noise = 0;
@@ -990,20 +982,19 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 		return wstats;
 	}
 
-       tmp_level = (&ieee->current_network)->stats.rssi;
+	tmp_level = (&ieee->current_network)->stats.rssi;
 	tmp_qual = (&ieee->current_network)->stats.signal;
 	tmp_noise = (&ieee->current_network)->stats.noise;
-	//printk("level:%d, qual:%d, noise:%d\n", tmp_level, tmp_qual, tmp_noise);
 
 	wstats->qual.level = tmp_level;
 	wstats->qual.qual = tmp_qual;
 	wstats->qual.noise = tmp_noise;
-	wstats->qual.updated = IW_QUAL_ALL_UPDATED| IW_QUAL_DBM;
+	wstats->qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
 	return wstats;
 }
 
 
-struct iw_handler_def  r8192_wx_handlers_def={
+struct iw_handler_def  r8192_wx_handlers_def = {
 	.standard = r8192_wx_handlers,
 	.num_standard = ARRAY_SIZE(r8192_wx_handlers),
 	.private = r8192_private_handler,
-- 
1.7.9.5

