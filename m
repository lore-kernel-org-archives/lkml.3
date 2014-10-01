Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaJAPSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:18:36 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:48796 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaJAPRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:17:53 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s91FHoei004311, This message is accepted by code: ctloc85258
From: Chun-Hao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Subject: [PATCH v2 net-next 10/10] r8169:call "rtl8168_driver_start" "rtl8168_driver_stop" only when hardware dash function is enabled
Date: Wed, 1 Oct 2014 23:17:21 +0800
Message-ID: <1412176641-24393-10-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412176641-24393-1-git-send-email-hau@realtek.com>
References: <1412176641-24393-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two functions are used to inform dash firmware that driver is been
brought up or brought down. So call these two functions only when hardware dash
function is enabled.

Signed-off-by: Chun-Hao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 305f3b4..c03891b 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -7387,9 +7387,10 @@ static void rtl_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	if (tp->mac_version == RTL_GIGA_MAC_VER_27 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_28 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_31) {
+	if ((tp->mac_version == RTL_GIGA_MAC_VER_27 ||
+	     tp->mac_version == RTL_GIGA_MAC_VER_28 ||
+	     tp->mac_version == RTL_GIGA_MAC_VER_31) &&
+	    r8168_check_dash(tp)) {
 		rtl8168_driver_stop(tp);
 	}
 
@@ -7822,9 +7823,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			   rtl_chip_infos[chipset].jumbo_tx_csum ? "ok" : "ko");
 	}
 
-	if (tp->mac_version == RTL_GIGA_MAC_VER_27 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_28 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_31) {
+	if ((tp->mac_version == RTL_GIGA_MAC_VER_27 ||
+	     tp->mac_version == RTL_GIGA_MAC_VER_28 ||
+	     tp->mac_version == RTL_GIGA_MAC_VER_31) &&
+	    r8168_check_dash(tp)) {
 		rtl8168_driver_start(tp);
 	}
 
-- 
1.8.3.2

