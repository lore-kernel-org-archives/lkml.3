Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbaELRay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:30:54 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:4865 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbaELRax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:30:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8KAHEEcVNbsHLF/2dsb2JhbABZgwasagkBBQGaG4EaF3SCUxMcIxiBAiQTiEUBz0WFVoh8hEcBA48liiIBiwSIA4M4Ow
Date: Mon, 12 May 2014 19:30:50 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] net/wireless/ibss.c: replace memcpy by ether_addr_copy
Message-Id: <20140512193050.1ba6a301b20af3f4e7e43870@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also fixes some comment checkpatch warnings

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/wireless/ibss.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index a6b5bda..a0a1381 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -49,7 +49,7 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 				GFP_KERNEL);
 #ifdef CONFIG_CFG80211_WEXT
 	memset(&wrqu, 0, sizeof(wrqu));
-	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+	ether_addr_copy(wrqu.ap_addr.sa_data, bssid);
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 #endif
 }
@@ -72,7 +72,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 		return;
 
 	ev->type = EVENT_IBSS_JOINED;
-	memcpy(ev->ij.bssid, bssid, ETH_ALEN);
+	ether_addr_copy(ev->ij.bssid, bssid);
 	ev->ij.channel = channel;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
@@ -98,11 +98,10 @@ static int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		return -EALREADY;
 
 	if (!params->basic_rates) {
-		/*
-		* If no rates were explicitly configured,
-		* use the mandatory rate set for 11b or
-		* 11a for maximum compatibility.
-		*/
+		/* If no rates were explicitly configured,
+		 * use the mandatory rate set for 11b or
+		 * 11a for maximum compatibility.
+		 */
 		struct ieee80211_supported_band *sband =
 			rdev->wiphy.bands[params->chandef.chan->band];
 		int j;
@@ -190,8 +189,7 @@ static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 
 	rdev_set_qos_map(rdev, dev, NULL);
 
-	/*
-	 * Delete all the keys ... pairwise keys can't really
+	/* Delete all the keys ... pairwise keys can't really
 	 * exist any more anyway, but default keys might.
 	 */
 	if (rdev->ops->del_key)
@@ -524,7 +522,7 @@ int cfg80211_ibss_wext_siwap(struct net_device *dev,
 		return err;
 
 	if (bssid) {
-		memcpy(wdev->wext.bssid, bssid, ETH_ALEN);
+		ether_addr_copy(wdev->wext.bssid, bssid);
 		wdev->wext.ibss.bssid = wdev->wext.bssid;
 	} else
 		wdev->wext.ibss.bssid = NULL;
@@ -550,9 +548,9 @@ int cfg80211_ibss_wext_giwap(struct net_device *dev,
 
 	wdev_lock(wdev);
 	if (wdev->current_bss)
-		memcpy(ap_addr->sa_data, wdev->current_bss->pub.bssid, ETH_ALEN);
+		ether_addr_copy(ap_addr->sa_data, wdev->current_bss->pub.bssid);
 	else if (wdev->wext.ibss.bssid)
-		memcpy(ap_addr->sa_data, wdev->wext.ibss.bssid, ETH_ALEN);
+		ether_addr_copy(ap_addr->sa_data, wdev->wext.ibss.bssid);
 	else
 		memset(ap_addr->sa_data, 0, ETH_ALEN);
 
-- 
1.9.1
