Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbaCDHPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:15:38 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63941 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbaCDHNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:13:08 -0500
From: Axel Rasmussen <axel.rasmussen1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 3/9] drivers: staging: rtl8187se: wrap excessively long lines
Date: Tue,  4 Mar 2014 00:12:51 -0700
Message-Id: <94874449b0ef5b78df2d913b0edbf48970c87bcb.1393916553.git.axel.rasmussen1@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393916553.git.axel.rasmussen1@gmail.com>
References: <cover.1393916553.git.axel.rasmussen1@gmail.com>
In-Reply-To: <cover.1393916553.git.axel.rasmussen1@gmail.com>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com> <cover.1393916553.git.axel.rasmussen1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c | 40 ++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 67c2583..344ef74 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -258,7 +258,9 @@ static int proc_get_stats_tx(struct seq_file *m, void *v)
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	unsigned long totalOK;
 
-	totalOK = priv->stats.txnpokint+priv->stats.txhpokint+priv->stats.txlpokint;
+	totalOK = priv->stats.txnpokint + priv->stats.txhpokint +
+		priv->stats.txlpokint;
+
 	seq_printf(m,
 		"TX OK: %lu\n"
 		"TX Error: %lu\n"
@@ -468,9 +470,11 @@ static short check_nic_enought_desc(struct net_device *dev, int priority)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = netdev_priv(dev);
-	int requiredbyte, required;
+	int requiredbyte;
+	int required;
 
-	requiredbyte = priv->ieee80211->fts + sizeof(struct ieee80211_header_data);
+	requiredbyte = priv->ieee80211->fts +
+		sizeof(struct ieee80211_header_data);
 
 	if (ieee->current_network.QoS_Enable)
 		requiredbyte += 2;
@@ -484,7 +488,7 @@ static short check_nic_enought_desc(struct net_device *dev, int priority)
 	 * between the tail and the head
 	 */
 
-	return (required+2 < get_curr_tx_free_desc(dev, priority));
+	return required + 2 < get_curr_tx_free_desc(dev, priority);
 }
 
 void fix_tx_fifo(struct net_device *dev)
@@ -742,43 +746,50 @@ static short alloc_tx_desc_ring(struct net_device *dev, int bufsize, int count,
 
 		switch (addr) {
 		case TX_MANAGEPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txmapbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&priv->txmapbufs,
+				buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer NP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_BKPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txbkpbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&priv->txbkpbufs,
+				buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer LP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_BEPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txbepbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&priv->txbepbufs,
+				buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer NP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_VIPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txvipbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&priv->txvipbufs,
+				buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer LP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_VOPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txvopbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&priv->txvopbufs,
+				buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer NP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_HIGHPRIORITY_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txhpbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&priv->txhpbufs,
+				buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer HP");
 				return -ENOMEM;
 			}
 			break;
 		case TX_BEACON_RING_ADDR:
-			if (-1 == buffer_add(&(priv->txbeaconbufs), buf, dma_tmp, NULL)) {
+			if (-1 == buffer_add(&priv->txbeaconbufs,
+				buf, dma_tmp, NULL)) {
 				DMESGE("Unable to allocate mem for buffer BP");
 				return -ENOMEM;
 			}
@@ -897,8 +908,8 @@ static short alloc_rx_desc_ring(struct net_device *dev, u16 bufsize, int count)
 		return -1;
 	}
 
-	desc = (u32 *)pci_alloc_consistent(pdev, sizeof(u32)*rx_desc_size*count+256,
-					  &dma_desc);
+	desc = (u32 *)pci_alloc_consistent(pdev,
+		sizeof(u32) * rx_desc_size * count + 256, &dma_desc);
 
 	if (dma_desc & 0xff)
 		/*
@@ -935,7 +946,8 @@ static short alloc_rx_desc_ring(struct net_device *dev, u16 bufsize, int count)
 		tmp = tmp+rx_desc_size;
 	}
 
-	*(tmp-rx_desc_size) = *(tmp-rx_desc_size) | (1<<30); /* this is the last descriptor */
+	/* this is the last descriptor */
+	*(tmp - rx_desc_size) = *(tmp - rx_desc_size) | (1 << 30);
 
 	return 0;
 }
-- 
1.8.3.2

