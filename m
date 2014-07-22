Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaGVHAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:00:11 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42889 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaGVHAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:00:06 -0400
From: Kiran Padwal <kiran.padwal21@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rashika.kheria@gmail.com, rusty@rustcorp.com.au,
        valentina.manea.m@gmail.com, gulsah.1004@gmail.com, wkang77@gmail.com,
        kiran.padwal21@gmail.com, joe@perches.com, jonathankim@gctsemi.com,
        deanahn@gctsemi.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: gdm724x: gdm_lte.c: Fix warning of prefer ether_addr_copy()
Date: Tue, 22 Jul 2014 12:26:42 +0530
Message-Id: <1406012202-31208-1-git-send-email-kiran.padwal21@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warnings:
WARNING: "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)".

Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
---
 drivers/staging/gdm724x/gdm_lte.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index bc6d574..6df6c70 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -626,7 +626,7 @@ static void gdm_lte_netif_rx(struct net_device *dev, char *buf,
 			void *addr = buf + sizeof(struct iphdr) +
 				sizeof(struct udphdr) +
 				offsetof(struct dhcp_packet, chaddr);
-			memcpy(nic->dest_mac_addr, addr, ETH_ALEN);
+			ether_addr_copy(nic->dest_mac_addr, addr);
 		}
 	}
 
@@ -639,7 +639,7 @@ static void gdm_lte_netif_rx(struct net_device *dev, char *buf,
 	}
 
 	/* Format the data so that it can be put to skb */
-	memcpy(mac_header_data, nic->dest_mac_addr, ETH_ALEN);
+	ether_addr_copy(mac_header_data, nic->dest_mac_addr);
 	memcpy(mac_header_data + ETH_ALEN, nic->src_mac_addr, ETH_ALEN);
 
 	vlan_eth.h_vlan_TCI = htons(nic->vlan_id);
@@ -842,9 +842,9 @@ static void form_mac_address(u8 *dev_addr, u8 *nic_src, u8 *nic_dest,
 {
 	/* Form the dev_addr */
 	if (!mac_address)
-		memcpy(dev_addr, gdm_lte_macaddr, ETH_ALEN);
+		ether_addr_copy(dev_addr, gdm_lte_macaddr);
 	else
-		memcpy(dev_addr, mac_address, ETH_ALEN);
+		ether_addr_copy(dev_addr, mac_address);
 
 	/* The last byte of the mac address
 	 * should be less than or equal to 0xFC
@@ -858,7 +858,7 @@ static void form_mac_address(u8 *dev_addr, u8 *nic_src, u8 *nic_dest,
 	memcpy(nic_src, dev_addr, 3);
 
 	/* Copy the nic_dest from dev_addr*/
-	memcpy(nic_dest, dev_addr, ETH_ALEN);
+	ether_addr_copy(nic_dest, dev_addr);
 }
 
 static void validate_mac_address(u8 *mac_address)
-- 
1.7.9.5

