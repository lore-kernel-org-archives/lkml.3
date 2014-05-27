Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaE0UJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:09:55 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44262 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaE0UJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:09:53 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, andrea.merello@gmail.com,
        linville@tuxdriver.com, burzalodowa@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, c@24.io
Subject: [PATCH 5/6] Staging: rtl8192u: r8180_93cx6.c & r8192U_wx.c fix checkpatch.pl errors and warnings
Date: Tue, 27 May 2014 13:09:49 -0700
Message-Id: <1401221390-10655-5-git-send-email-c@24.io>
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
 drivers/staging/rtl8192u/r8192U_wx.c |  144 ++++++++++++++++++----------------
 1 file changed, 76 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 6b48c08..7480c0e 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -388,9 +388,10 @@ static int r8192_wx_set_essid(struct net_device *dev,
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	int ret;
+
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_essid(priv->ieee80211,a,wrqu,b);
+	ret = ieee80211_wx_set_essid(priv->ieee80211, a, wrqu, b);
 
 	up(&priv->wx_sem);
 
@@ -482,10 +483,11 @@ static int r8192_wx_set_wap(struct net_device *dev,
 
 	int ret;
 	struct r8192_priv *priv = ieee80211_priv(dev);
-//        struct sockaddr *temp = (struct sockaddr *)awrq;
+/*      struct sockaddr *temp = (struct sockaddr *)awrq; */
+
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_wap(priv->ieee80211,info,awrq,extra);
+	ret = ieee80211_wx_set_wap(priv->ieee80211, info, awrq, extra);
 
 	up(&priv->wx_sem);
 
@@ -500,7 +502,7 @@ static int r8192_wx_get_wap(struct net_device *dev,
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	return ieee80211_wx_get_wap(priv->ieee80211,info,wrqu,extra);
+	return ieee80211_wx_get_wap(priv->ieee80211, info, wrqu, extra);
 }
 
 
@@ -520,36 +522,34 @@ static int r8192_wx_set_enc(struct net_device *dev,
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee80211;
 	int ret;
-
-	//u32 TargetContent;
-	u32 hwkey[4]={0,0,0,0};
-	u8 mask=0xff;
-	u32 key_idx=0;
-	//u8 broadcast_addr[6] ={	0xff,0xff,0xff,0xff,0xff,0xff};
-	u8 zero_addr[4][6] ={	{0x00,0x00,0x00,0x00,0x00,0x00},
-				{0x00,0x00,0x00,0x00,0x00,0x01},
-				{0x00,0x00,0x00,0x00,0x00,0x02},
-				{0x00,0x00,0x00,0x00,0x00,0x03} };
+	u32 hwkey[4] = {0, 0, 0, 0};
+	u8 mask = 0xff;
+	u32 key_idx = 0;
+	u8 zero_addr[4][6] = {	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
+				{0x00, 0x00, 0x00, 0x00, 0x00, 0x01},
+				{0x00, 0x00, 0x00, 0x00, 0x00, 0x02},
+				{0x00, 0x00, 0x00, 0x00, 0x00, 0x03} };
 	int i;
 
-       if(!priv->up) return -ENETDOWN;
+	if (!priv->up)
+		return -ENETDOWN;
 
 	down(&priv->wx_sem);
 
 	RT_TRACE(COMP_SEC, "Setting SW wep key");
-	ret = ieee80211_wx_set_encode(priv->ieee80211,info,wrqu,key);
+	ret = ieee80211_wx_set_encode(priv->ieee80211, info, wrqu, key);
 
 	up(&priv->wx_sem);
 
+	/*sometimes, the length is zero while we do not type key value */
+	if (wrqu->encoding.length != 0) {
 
-
-	//sometimes, the length is zero while we do not type key value
-	if(wrqu->encoding.length!=0){
-
-		for(i=0 ; i<4 ; i++){
+		for (i = 0; i < 4 ; i++) {
 			hwkey[i] |=  key[4*i+0]&mask;
-			if(i==1&&(4*i+1)==wrqu->encoding.length) mask=0x00;
-			if(i==3&&(4*i+1)==wrqu->encoding.length) mask=0x00;
+			if (i == 1 && (4*i+1) == wrqu->encoding.length)
+				mask = 0x00;
+			if (i == 3 && (4*i+1) == wrqu->encoding.length)
+				mask = 0x00;
 			hwkey[i] |= (key[4*i+1]&mask)<<8;
 			hwkey[i] |= (key[4*i+2]&mask)<<16;
 			hwkey[i] |= (key[4*i+3]&mask)<<24;
@@ -558,56 +558,65 @@ static int r8192_wx_set_enc(struct net_device *dev,
 		#define CONF_WEP40  0x4
 		#define CONF_WEP104 0x14
 
-		switch (wrqu->encoding.flags & IW_ENCODE_INDEX){
-		case 0: key_idx = ieee->tx_keyidx; break;
-		case 1:	key_idx = 0; break;
-		case 2:	key_idx = 1; break;
-		case 3:	key_idx = 2; break;
-		case 4:	key_idx	= 3; break;
-		default: break;
+		switch (wrqu->encoding.flags & IW_ENCODE_INDEX) {
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
 
-		if(wrqu->encoding.length==0x5){
-				ieee->pairwise_key_type = KEY_TYPE_WEP40;
+		if (wrqu->encoding.length == 0x5) {
+			ieee->pairwise_key_type = KEY_TYPE_WEP40;
 			EnableHWSecurityConfig8192(dev);
 
-			setKey( dev,
-				key_idx,                //EntryNo
-				key_idx,                //KeyIndex
-				KEY_TYPE_WEP40,         //KeyType
+			setKey(dev,
+				key_idx,                /*EntryNo */
+				key_idx,                /*KeyIndex */
+				KEY_TYPE_WEP40,         /*KeyType */
 				zero_addr[key_idx],
-				0,                      //DefaultKey
-				hwkey);                 //KeyContent
-
-		}
+				0,                      /*DefaultKey */
+				hwkey);                 /*KeyContent */
 
-		else if(wrqu->encoding.length==0xd){
-				ieee->pairwise_key_type = KEY_TYPE_WEP104;
-				EnableHWSecurityConfig8192(dev);
+		} else if (wrqu->encoding.length == 0xd) {
+			ieee->pairwise_key_type = KEY_TYPE_WEP104;
+			EnableHWSecurityConfig8192(dev);
 
-			setKey( dev,
-				key_idx,                //EntryNo
-				key_idx,                //KeyIndex
-				KEY_TYPE_WEP104,        //KeyType
+			setKey(dev,
+				key_idx,                /*EntryNo */
+				key_idx,                /*KeyIndex */
+				KEY_TYPE_WEP104,        /*KeyType */
 				zero_addr[key_idx],
-				0,                      //DefaultKey
-				hwkey);                 //KeyContent
+				0,                      /*DefaultKey */
+				hwkey);                 /*KeyContent */
 
+		} else {
+			printk("wrong type in WEP, not WEP40 and WEP104\n");
 		}
-		else printk("wrong type in WEP, not WEP40 and WEP104\n");
-
 	}
 
 	return ret;
 }
 
 
-static int r8192_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa, union
- iwreq_data *wrqu, char *p){
+static int r8192_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa,
+					union iwreq_data *wrqu, char *p){
 
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	int *parms=(int *)p;
-	int mode=parms[0];
+	int *parms = (int *)p;
+	int mode = parms[0];
 
 	priv->ieee80211->active_scan = mode;
 
@@ -626,24 +635,24 @@ static int r8192_wx_set_retry(struct net_device *dev,
 	down(&priv->wx_sem);
 
 	if (wrqu->retry.flags & IW_RETRY_LIFETIME ||
-	    wrqu->retry.disabled){
+	    wrqu->retry.disabled) {
 		err = -EINVAL;
 		goto exit;
 	}
-	if (!(wrqu->retry.flags & IW_RETRY_LIMIT)){
+	if (!(wrqu->retry.flags & IW_RETRY_LIMIT)) {
 		err = -EINVAL;
 		goto exit;
 	}
 
-	if(wrqu->retry.value > R8180_MAX_RETRY){
-		err= -EINVAL;
+	if (wrqu->retry.value > R8180_MAX_RETRY) {
+		err = -EINVAL;
 		goto exit;
 	}
 	if (wrqu->retry.flags & IW_RETRY_MAX) {
 		priv->retry_rts = wrqu->retry.value;
 		DMESG("Setting retry for RTS/CTS data to %d", wrqu->retry.value);
 
-	}else {
+	} else {
 		priv->retry_data = wrqu->retry.value;
 		DMESG("Setting retry for non RTS/CTS data to %d", wrqu->retry.value);
 	}
@@ -689,7 +698,6 @@ static int r8192_wx_get_retry(struct net_device *dev,
 		wrqu->retry.flags = IW_RETRY_LIMIT | IW_RETRY_MIN;
 		wrqu->retry.value = priv->retry_data;
 	}
-	//printk("returning %d",wrqu->retry.value);
 
 
 	return 0;
@@ -700,7 +708,8 @@ static int r8192_wx_get_sens(struct net_device *dev,
 				union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	if(priv->rf_set_sens == NULL)
+
+	if (priv->rf_set_sens == NULL)
 		return -1; /* we have not this support for this radio */
 	wrqu->sens.value = priv->sens;
 	return 0;
@@ -713,18 +722,17 @@ static int r8192_wx_set_sens(struct net_device *dev,
 {
 
 	struct r8192_priv *priv = ieee80211_priv(dev);
-
 	short err = 0;
+
 	down(&priv->wx_sem);
-	//DMESG("attempt to set sensivity to %ddb",wrqu->sens.value);
-	if(priv->rf_set_sens == NULL) {
-		err= -1; /* we have not this support for this radio */
+	if (priv->rf_set_sens == NULL) {
+		err = -1; /* we have not this support for this radio */
 		goto exit;
 	}
-	if(priv->rf_set_sens(dev, wrqu->sens.value) == 0)
+	if (priv->rf_set_sens(dev, wrqu->sens.value) == 0)
 		priv->sens = wrqu->sens.value;
 	else
-		err= -EINVAL;
+		err = -EINVAL;
 
 exit:
 	up(&priv->wx_sem);
-- 
1.7.9.5

