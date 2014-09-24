Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaIXIzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:55:54 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52056 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaIXIzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:55:52 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, davem@davemloft.net, angus@agibson.me,
        tklauser@distanz.ch, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/4] staging: et131x: Use ether_addr_copy when copying ethernet addresses
Date: Wed, 24 Sep 2014 09:54:39 +0100
Message-Id: <1411548882-10639-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411506437.29268.13.camel@joe-AO725>
References: <1411506437.29268.13.camel@joe-AO725>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 4b2ae49..b976c75 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3188,15 +3188,13 @@ static void et131x_hwaddr_init(struct et131x_adapter *adapter)
 		 * working with so we need to copy the current
 		 * address into the permanent address
 		 */
-		memcpy(adapter->rom_addr,
-		       adapter->addr, ETH_ALEN);
+		ether_addr_copy(adapter->rom_addr, adapter->addr);
 	} else {
 		/* We do not have an override address, so set the
 		 * current address to the permanent address and add
 		 * it to the device
 		 */
-		memcpy(adapter->addr,
-		       adapter->rom_addr, ETH_ALEN);
+		ether_addr_copy(adapter->addr, adapter->rom_addr);
 	}
 }
 
@@ -4048,7 +4046,7 @@ static void et131x_multicast(struct net_device *netdev)
 	netdev_for_each_mc_addr(ha, netdev) {
 		if (i == NIC_MAX_MCAST_LIST)
 			break;
-		memcpy(adapter->multicast_list[i++], ha->addr, ETH_ALEN);
+		ether_addr_copy(adapter->multicast_list[i++], ha->addr);
 	}
 	adapter->multicast_addr_count = i;
 
@@ -4178,7 +4176,7 @@ static int et131x_change_mtu(struct net_device *netdev, int new_mtu)
 	et131x_init_send(adapter);
 
 	et131x_hwaddr_init(adapter);
-	memcpy(netdev->dev_addr, adapter->addr, ETH_ALEN);
+	ether_addr_copy(netdev->dev_addr, adapter->addr);
 
 	/* Init the device with the new settings */
 	et131x_adapter_setup(adapter);
@@ -4296,7 +4294,7 @@ static int et131x_pci_setup(struct pci_dev *pdev,
 	netif_napi_add(netdev, &adapter->napi, et131x_poll, 64);
 
 	/* Copy address into the net_device struct */
-	memcpy(netdev->dev_addr, adapter->addr, ETH_ALEN);
+	ether_addr_copy(netdev->dev_addr, adapter->addr);
 
 	rc = -ENOMEM;
 
-- 
1.7.10.4

