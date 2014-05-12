Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbaELRlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:41:12 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:42187 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755366AbaELRlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:41:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8KADcHcVNbsHLF/2dsb2JhbABZgwasagkBBQGaG4EaF3SCUxMcIxiBAiQTiEUBz0WFVoh8hEcBA48liiIBiwSIA4M4Ow
Date: Mon, 12 May 2014 19:41:06 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] net/wireless/sme.c: replace memcpy by ether_addr_copy
Message-Id: <20140512194106.98f34913dded9af040f31d3d@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/wireless/sme.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index acdcb4a8..6f88abc 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -225,7 +225,7 @@ void cfg80211_conn_work(struct work_struct *work)
 			continue;
 		}
 		if (wdev->conn->params.bssid) {
-			memcpy(bssid_buf, wdev->conn->params.bssid, ETH_ALEN);
+			ether_addr_copy(bssid_buf, wdev->conn->params.bssid);
 			bssid = bssid_buf;
 		}
 		if (cfg80211_conn_do_work(wdev)) {
@@ -263,7 +263,7 @@ static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 	if (!bss)
 		return NULL;
 
-	memcpy(wdev->conn->bssid, bss->bssid, ETH_ALEN);
+	ether_addr_copy(wdev->conn->bssid, bss->bssid);
 	wdev->conn->params.bssid = wdev->conn->bssid;
 	wdev->conn->params.channel = bss->channel;
 	wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
@@ -444,7 +444,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 	memcpy(&wdev->conn->params, connect, sizeof(*connect));
 	if (connect->bssid) {
 		wdev->conn->params.bssid = wdev->conn->bssid;
-		memcpy(wdev->conn->bssid, connect->bssid, ETH_ALEN);
+		ether_addr_copy(wdev->conn->bssid, connect->bssid);
 	}
 
 	if (connect->ie) {
@@ -474,7 +474,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 	bss = cfg80211_get_conn_bss(wdev);
 
 	if (prev_bssid) {
-		memcpy(wdev->conn->prev_bssid, prev_bssid, ETH_ALEN);
+		ether_addr_copy(wdev->conn->prev_bssid, prev_bssid);
 		wdev->conn->prev_bssid_valid = true;
 	}
 
@@ -616,8 +616,8 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		memset(&wrqu, 0, sizeof(wrqu));
 		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 		if (bssid && status == WLAN_STATUS_SUCCESS) {
-			memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
-			memcpy(wdev->wext.prev_bssid, bssid, ETH_ALEN);
+			ether_addr_copy(wrqu.ap_addr.sa_data, bssid);
+			ether_addr_copy(wdev->wext.prev_bssid, bssid);
 			wdev->wext.prev_bssid_valid = true;
 		}
 		wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
@@ -697,7 +697,7 @@ void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 
 	ev->type = EVENT_CONNECT_RESULT;
 	if (bssid)
-		memcpy(ev->cr.bssid, bssid, ETH_ALEN);
+		ether_addr_copy(ev->cr.bssid, bssid);
 	if (req_ie_len) {
 		ev->cr.req_ie = ((u8 *)ev) + sizeof(*ev);
 		ev->cr.req_ie_len = req_ie_len;
@@ -763,8 +763,8 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
 
 	memset(&wrqu, 0, sizeof(wrqu));
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
-	memcpy(wdev->wext.prev_bssid, bss->bssid, ETH_ALEN);
+	ether_addr_copy(wrqu.ap_addr.sa_data, bss->bssid);
+	ether_addr_copy(wdev->wext.prev_bssid, bss->bssid);
 	wdev->wext.prev_bssid_valid = true;
 	wireless_send_event(wdev->netdev, SIOCGIWAP, &wrqu, NULL);
 #endif
-- 
1.9.1

