Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab3GMLnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:43:09 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:56001 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3GMLnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:43:07 -0400
From: Dragos Foianu <dragos.foianu@gmail.com>
To: davem@davemloft.net
Cc: ben@decadent.org.uk, pshelar@nicira.com, mschmidt@redhat.com,
        ebiederm@xmission.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dragos Foianu <dragos.foianu@gmail.com>
Subject: [PATCH] ethtool: fixed trailing statements in ethtool
Date: Sat, 13 Jul 2013 14:43:00 +0100
Message-Id: <1373722980-19704-1-git-send-email-dragos.foianu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied fixes suggested by checkpatch.pl.

Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>
---
 net/core/ethtool.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index ab5fa63..78e9d92 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -279,11 +279,16 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 {
 	u32 flags = 0;
 
-	if (dev->features & NETIF_F_LRO)	     flags |= ETH_FLAG_LRO;
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_RX) flags |= ETH_FLAG_RXVLAN;
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_TX) flags |= ETH_FLAG_TXVLAN;
-	if (dev->features & NETIF_F_NTUPLE)	     flags |= ETH_FLAG_NTUPLE;
-	if (dev->features & NETIF_F_RXHASH)	     flags |= ETH_FLAG_RXHASH;
+	if (dev->features & NETIF_F_LRO)
+		flags |= ETH_FLAG_LRO;
+	if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
+		flags |= ETH_FLAG_RXVLAN;
+	if (dev->features & NETIF_F_HW_VLAN_CTAG_TX)
+		flags |= ETH_FLAG_TXVLAN;
+	if (dev->features & NETIF_F_NTUPLE)
+		flags |= ETH_FLAG_NTUPLE;
+	if (dev->features & NETIF_F_RXHASH)
+		flags |= ETH_FLAG_RXHASH;
 
 	return flags;
 }
@@ -295,11 +300,16 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
 
-	if (data & ETH_FLAG_LRO)	features |= NETIF_F_LRO;
-	if (data & ETH_FLAG_RXVLAN)	features |= NETIF_F_HW_VLAN_CTAG_RX;
-	if (data & ETH_FLAG_TXVLAN)	features |= NETIF_F_HW_VLAN_CTAG_TX;
-	if (data & ETH_FLAG_NTUPLE)	features |= NETIF_F_NTUPLE;
-	if (data & ETH_FLAG_RXHASH)	features |= NETIF_F_RXHASH;
+	if (data & ETH_FLAG_LRO)
+		features |= NETIF_F_LRO;
+	if (data & ETH_FLAG_RXVLAN)
+		features |= NETIF_F_HW_VLAN_CTAG_RX;
+	if (data & ETH_FLAG_TXVLAN)
+		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (data & ETH_FLAG_NTUPLE)
+		features |= NETIF_F_NTUPLE;
+	if (data & ETH_FLAG_RXHASH)
+		features |= NETIF_F_RXHASH;
 
 	/* allow changing only bits set in hw_features */
 	changed = (features ^ dev->features) & ETH_ALL_FEATURES;
-- 
1.7.10.4

