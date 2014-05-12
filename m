Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbaELPZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:25:07 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:51702 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758427AbaELPZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:25:05 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: himangi774@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging/wlan-ng: replace printk() with pr_xxx()
Date: Mon, 12 May 2014 17:22:47 +0200
Message-Id: <1399908167-19271-4-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399908167-19271-1-git-send-email-denis.pithon@gmail.com>
References: <1399908167-19271-1-git-send-email-denis.pithon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding style issues concerning printk() usage.

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 61a3092..3577d20 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -384,8 +384,9 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 		 */
 		if (skb->protocol != ETH_P_80211_RAW) {
 			netif_start_queue(wlandev->netdev);
-			printk(KERN_NOTICE
-			       "Tx attempt prior to association, frame dropped.\n");
+			pr_notice(
+			   "Tx attempt prior to association, frame dropped\n"
+			);
 			wlandev->linux_stats.tx_dropped++;
 			result = 0;
 			goto failed;
@@ -684,8 +685,9 @@ static int p80211knetdev_set_mac_address(netdevice_t *dev, void *addr)
 	 * change the netdev address
 	 */
 	if (result != 0 || resultcode->data != P80211ENUM_resultcode_success) {
-		printk(KERN_ERR
-		       "Low-level driver failed dot11req_mibset(dot11MACAddress).\n");
+		pr_err(
+		  "Low-level driver failed dot11req_mibset(dot11MACAddress)\n"
+		);
 		result = -EADDRNOTAVAIL;
 	} else {
 		/* everything's ok, change the addr in netdev */
@@ -764,7 +766,7 @@ int wlan_setup(wlandevice_t *wlandev, struct device *physdev)
 	/* Allocate and initialize the wiphy struct */
 	wiphy = wlan_create_wiphy(physdev, wlandev);
 	if (wiphy == NULL) {
-		printk(KERN_ERR "Failed to alloc wiphy.\n");
+		pr_err("Failed to alloc wiphy.\n");
 		return 1;
 	}
 
@@ -772,7 +774,7 @@ int wlan_setup(wlandevice_t *wlandev, struct device *physdev)
 	netdev = alloc_netdev(sizeof(struct wireless_dev), "wlan%d",
 				ether_setup);
 	if (netdev == NULL) {
-		printk(KERN_ERR "Failed to alloc netdev.\n");
+		pr_err("Failed to alloc netdev.\n");
 		wlan_free_wiphy(wiphy);
 		result = 1;
 	} else {
@@ -1104,8 +1106,7 @@ static void p80211knetdev_tx_timeout(netdevice_t *netdev)
 	if (wlandev->tx_timeout) {
 		wlandev->tx_timeout(wlandev);
 	} else {
-		printk(KERN_WARNING "Implement tx_timeout for %s\n",
-		       wlandev->nsdname);
+		pr_warn("Implement tx_timeout for %s\n", wlandev->nsdname);
 		netif_wake_queue(wlandev->netdev);
 	}
 }
-- 
1.8.1.4

