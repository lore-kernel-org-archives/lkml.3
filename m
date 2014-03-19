Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbaCSIU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:20:58 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:56012 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009AbaCSIUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:20:52 -0400
From: Mathieu Maret <mathieu.maret@gmail.com>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mathieu Maret <mathieu.maret@gmail.com>
Subject: [PATCH 5/5] staging: wlags49_h2: Correct coding style in wl_netdev.c
Date: Wed, 19 Mar 2014 09:20:35 +0100
Message-Id: <1395217235-2979-5-git-send-email-mathieu.maret@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395217235-2979-1-git-send-email-mathieu.maret@gmail.com>
References: <1395217235-2979-1-git-send-email-mathieu.maret@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove space between parenthesis.
Test with simple statement does not need brackets.
Simplify test condition

Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
---
 drivers/staging/wlags49_h2/wl_netdev.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index 6455956..22d9ba3 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -113,7 +113,7 @@
 		status = hcf_rcv_msg(&(lp->hcfCtx), desc, 0) \
 	} while (0)
 
-#define BLOCK_INPUT_DMA(buf, len) memcpy( buf, desc_next->buf_addr, pktlen )
+#define BLOCK_INPUT_DMA(buf, len) memcpy(buf, desc_next->buf_addr, pktlen)
 
 /*******************************************************************************
  * function prototypes
@@ -225,17 +225,15 @@ struct net_device_stats *wl_stats(struct net_device *dev)
 #ifdef USE_WDS
 
 	for (count = 0; count < NUM_WDS_PORTS; count++) {
-		if (dev == lp->wds_port[count].dev) {
+		if (dev == lp->wds_port[count].dev)
 			pStats = &(lp->wds_port[count].stats);
-		}
 	}
 
 #endif /* USE_WDS */
 
 	/* If pStats is still NULL, then the device is not a WDS port */
-	if (pStats == NULL) {
+	if (pStats == NULL)
 		pStats = &(lp->stats);
-	}
 
 	wl_unlock(lp, &flags);
 
@@ -578,9 +576,8 @@ void wl_tx_timeout(struct net_device *dev)
 #endif /* USE_WDS */
 
 	/* If pStats is still NULL, then the device is not a WDS port */
-	if (pStats == NULL) {
+	if (pStats == NULL)
 		pStats = &(lp->stats);
-	}
 
 	/* Accumulate the timeout error */
 	pStats->tx_errors++;
@@ -663,9 +660,8 @@ int wl_send(struct wl_private *lp)
 		}
 	}
 
-	if (lp->txF.skb == NULL) {
+	if (lp->txF.skb == NULL)
 		return FALSE;
-	}
 
 	/* If the device has resources (FIDs) available, then Tx the packet */
 	/* Format the TxRequest and send it to the adapter */
@@ -926,9 +922,8 @@ int wl_rx(struct net_device *dev)
 					DBG_ERROR(DbgInfo,
 						  "Rx request to card FAILED\n");
 
-					if (port == 0) {
+					if (port == 0)
 						lp->stats.rx_dropped++;
-					}
 #ifdef USE_WDS
 					else {
 						lp->wds_port[port -
@@ -942,9 +937,8 @@ int wl_rx(struct net_device *dev)
 			} else {
 				DBG_ERROR(DbgInfo, "Could not alloc skb\n");
 
-				if (port == 0) {
+				if (port == 0)
 					lp->stats.rx_dropped++;
-				}
 #ifdef USE_WDS
 				else {
 					lp->wds_port[port -
@@ -1657,9 +1651,8 @@ void wl_wds_netif_carrier_on(struct wl_private *lp)
 
 	if (lp != NULL) {
 		for (count = 0; count < NUM_WDS_PORTS; count++) {
-			if (lp->wds_port[count].is_registered) {
+			if (lp->wds_port[count].is_registered)
 				netif_carrier_on(lp->wds_port[count].dev);
-			}
 		}
 	}
 }				/* wl_wds_netif_carrier_on */
@@ -1819,7 +1812,8 @@ int wl_rx_dma(struct net_device *dev)
 
 	DBG_PARAM(DbgInfo, "dev", "%s (0x%p)", dev->name, dev);
 
-	if (((lp = dev->priv) != NULL) && !(lp->flags & WVLAN2_UIL_BUSY)) {
+	lp = dev->priv;
+	if ((lp != NULL) && !(lp->flags & WVLAN2_UIL_BUSY)) {
 
 #ifdef USE_RTS
 		if (lp->useRTS == 1) {
@@ -1935,9 +1929,8 @@ int wl_rx_dma(struct net_device *dev)
 					DBG_ERROR(DbgInfo,
 						  "Could not alloc skb\n");
 
-					if (port == 0) {
+					if (port == 0)
 						lp->stats.rx_dropped++;
-					}
 #ifdef USE_WDS
 					else {
 						lp->wds_port[port -
-- 
1.9.0

