Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaAFFjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 00:39:16 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:51347 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaAFFjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 00:39:15 -0500
From: Dan LaManna <dan.lamanna@gmail.com>
To: gregkh@linuxfoundation.org, teobaluta@gmail.com, andrea.merello@gmail.com,
        linville@tuxdriver.com, rusty@rustcorp.com.au
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan LaManna <dan.lamanna@gmail.com>
Subject: [PATCH V2] Staging: rtl8187se: fix styling issues in r8180_wx.c
Date: Mon,  6 Jan 2014 00:38:51 -0500
Message-Id: <1388986731-1815-1-git-send-email-dan.lamanna@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the r8180_wx.c which fixes various whitespace issues,
brace issues, casting/declaration syntax issues, and increases
clarity in multi-line return statement.

Signed-off-by: Dan LaManna <dan.lamanna@gmail.com>
---
 drivers/staging/rtl8187se/r8180_wx.c |   53 +++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 4e01653..eff2265 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -61,7 +61,7 @@ static int r8180_wx_set_key(struct net_device *dev,
 		return 0;
 
 	if (erq->length > 0) {
-		u32* tkey = (u32*) key;
+		u32 *tkey = (u32 *) key;
 		priv->key0[0] = tkey[0];
 		priv->key0[1] = tkey[1];
 		priv->key0[2] = tkey[2];
@@ -295,7 +295,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 		}
 
 		if (val == IW_MAX_FREQUENCIES)
-		break;
+			break;
 	}
 
 	range->num_frequency = val;
@@ -311,14 +311,14 @@ static int r8180_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	int ret;
-	struct ieee80211_device* ieee = priv->ieee80211;
+	struct ieee80211_device *ieee = priv->ieee80211;
 
 
 	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	if (wrqu->data.flags & IW_SCAN_THIS_ESSID)	{
-		struct iw_scan_req* req = (struct iw_scan_req*)b;
+		struct iw_scan_req *req = (struct iw_scan_req *)b;
 		if (req->essid_len)		{
 			ieee->current_network.ssid_len = req->essid_len;
 			memcpy(ieee->current_network.ssid, req->essid, req->essid_len);
@@ -516,7 +516,8 @@ static int r8180_wx_set_enc(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	if (priv->hw_wep) ret = r8180_wx_set_key(dev, info, wrqu, key);
+	if (priv->hw_wep)
+		ret = r8180_wx_set_key(dev, info, wrqu, key);
 	else	{
 		DMESG("Setting SW wep key");
 		ret = ieee80211_wx_set_encode(priv->ieee80211, info, wrqu, key);
@@ -541,7 +542,7 @@ static int r8180_wx_set_scan_type(struct net_device *dev, struct iw_request_info
 	iwreq_data *wrqu, char *p)	{
 
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	int *parms = (int*)p;
+	int *parms = (int *)p;
 	int mode = parms[0];
 
 	if (priv->ieee80211->bHwRadioOff)
@@ -872,7 +873,7 @@ static int r8180_wx_set_preamble(struct net_device *dev,
 	if (*extra < 0 || *extra > 2)
 		ret = -1;
 	else
-		priv->plcp_preamble_mode = *((short *)extra) ;
+		priv->plcp_preamble_mode = *((short *)extra);
 
 
 
@@ -1035,7 +1036,7 @@ static int r8180_wx_set_channelplan(struct net_device *dev,
 		/* Set new channel map */
 		for (i = 1; i <= DefaultChannelPlan[*val].Len; i++)
 			GET_DOT11D_INFO(priv->ieee80211)->channel_map[DefaultChannelPlan[*val].Channel[i-1]] = 1;
-		
+
 	}
 	up(&priv->wx_sem);
 
@@ -1070,8 +1071,7 @@ static int r8180_wx_set_forcerate(struct net_device *dev,
 	printk("==============>%s(): forcerate is %d\n", __func__, forcerate);
 	if ((forcerate == 2) || (forcerate == 4) || (forcerate == 11) || (forcerate == 22) || (forcerate == 12) ||
 		(forcerate == 18) || (forcerate == 24) || (forcerate == 36) || (forcerate == 48) || (forcerate == 72) ||
-		(forcerate == 96) || (forcerate == 108))
-	{
+		(forcerate == 96) || (forcerate == 108)) {
 		priv->ForcedDataRate = 1;
 		priv->ieee80211->rate = forcerate * 5;
 	}	else if (forcerate == 0)	{
@@ -1358,22 +1358,35 @@ static inline int is_same_network(struct ieee80211_network *src,
 		 * We treat all <hidden> with the same BSSID and channel
 		 * as one network
 		 */
-		return (((src->ssid_len == dst->ssid_len) || (ieee->iw_mode == IW_MODE_INFRA)) && /* YJ,mod, 080819,for hidden ap */
-			(src->channel == dst->channel) &&
-			!memcmp(src->bssid, dst->bssid, ETH_ALEN) &&
-			(!memcmp(src->ssid, dst->ssid, src->ssid_len) || (ieee->iw_mode == IW_MODE_INFRA)) &&  /* YJ,mod, 080819,for hidden ap */
-			((src->capability & WLAN_CAPABILITY_IBSS) ==
-			(dst->capability & WLAN_CAPABILITY_IBSS)) &&
-			((src->capability & WLAN_CAPABILITY_BSS) ==
-			(dst->capability & WLAN_CAPABILITY_BSS)));
+		if (src->channel != dst->channel)
+			return 0;
+
+		if (memcmp(src->bssid, dst->bssid, ETH_ALEN) != 0)
+			return 0;
+
+		if (ieee->iw_mode != IW_MODE_INFRA) {
+			if (src->ssid_len != dst->ssid_len)
+				return 0;
+			if (memcmp(src->ssid, dst->ssid, src->ssid_len) != 0)
+				return 0;
+		}
+
+		if ((src->capability & WLAN_CAPABILITY_IBSS) !=
+		    (dst->capability & WLAN_CAPABILITY_IBSS))
+			return 0;
+		if ((src->capability & WLAN_CAPABILITY_BSS) !=
+		    (dst->capability & WLAN_CAPABILITY_BSS))
+			return 0;
+
+		return 1;
 }
 
 /* WB modified to show signal to GUI on 18-01-2008 */
 static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device* ieee = priv->ieee80211;
-	struct iw_statistics* wstats = &priv->wstats;
+	struct ieee80211_device *ieee = priv->ieee80211;
+	struct iw_statistics *wstats = &priv->wstats;
 	int tmp_level = 0;
 	int tmp_qual = 0;
 	int tmp_noise = 0;
-- 
1.7.10.4

