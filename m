Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaC1W12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 18:27:28 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33982 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaC1W11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 18:27:27 -0400
Message-ID: <5335F74A.9020507@gmail.com>
Date: Fri, 28 Mar 2014 22:27:22 +0000
From: paulmcquad <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, gamerh2o@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Staging:et131x: change memcpy()  ether_addr_copy()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 63f3c8948d5264ab22695502b201ff50edb9028d Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Fri, 28 Mar 2014 22:16:22 +0000
Subject: [PATCH] Staging:et131x: change memcpy()  ether_addr_copy()

replace memcpy() with ether_addr_copy()
make checkpatch.pl clean

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/et131x/et131x.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index e516bb6..a35d3c8 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3523,7 +3523,7 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
             goto err_out;
         }
     }
-    memcpy(adapter->addr, adapter->rom_addr, ETH_ALEN);
+    ether_addr_copy(adapter->addr, adapter->rom_addr, ETH_ALEN);
 out:
     return rc;
 err_out:
@@ -3770,7 +3770,7 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
     adapter->registry_jumbo_packet = 1514;    /* 1514-9216 */
 
     /* Set the MAC address to a default */
-    memcpy(adapter->addr, default_mac, ETH_ALEN);
+    ether_addr_copy(adapter->addr, default_mac, ETH_ALEN);
 
     return adapter;
 }
@@ -4337,7 +4337,7 @@ static void et131x_multicast(struct net_device *netdev)
     netdev_for_each_mc_addr(ha, netdev) {
         if (i == NIC_MAX_MCAST_LIST)
             break;
-        memcpy(adapter->multicast_list[i++], ha->addr, ETH_ALEN);
+    ether_addr_copy(adapter->multicast_list[i++], ha->addr, ETH_ALEN);
     }
     adapter->multicast_addr_count = i;
 
@@ -4473,7 +4473,7 @@ static int et131x_change_mtu(struct net_device *netdev, int new_mtu)
     et131x_init_send(adapter);
 
     et131x_hwaddr_init(adapter);
-    memcpy(netdev->dev_addr, adapter->addr, ETH_ALEN);
+    ether_addr_copy(netdev->dev_addr, adapter->addr, ETH_ALEN);
 
     /* Init the device with the new settings */
     et131x_adapter_setup(adapter);
@@ -4644,7 +4644,7 @@ static int et131x_pci_setup(struct pci_dev *pdev,
     INIT_WORK(&adapter->task, et131x_isr_handler);
 
     /* Copy address into the net_device struct */
-    memcpy(netdev->dev_addr, adapter->addr, ETH_ALEN);
+    ether_addr_copy(netdev->dev_addr, adapter->addr, ETH_ALEN);
 
     /* Init variable for counting how long we do not have link status */
     adapter->boot_coma = 0;
-- 
1.8.3.2

