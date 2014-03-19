Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbaCSIWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:22:03 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60612 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaCSIUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:20:44 -0400
From: Mathieu Maret <mathieu.maret@gmail.com>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mathieu Maret <mathieu.maret@gmail.com>
Subject: [PATCH 3/5] staging: wlags49_h2: Correct comment style in wl_netdev.c
Date: Wed, 19 Mar 2014 09:20:33 +0100
Message-Id: <1395217235-2979-3-git-send-email-mathieu.maret@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395217235-2979-1-git-send-email-mathieu.maret@gmail.com>
References: <1395217235-2979-1-git-send-email-mathieu.maret@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code is using C99 code style, so change them to kernel style

Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
---
 drivers/staging/wlags49_h2/wl_netdev.c | 158 +++++++++++++++++++--------------
 1 file changed, 89 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index d9f9237..255d291 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -140,7 +140,7 @@ int wl_init(struct net_device *dev)
 {
 	DBG_PARAM(DbgInfo, "dev", "%s (0x%p)", dev->name, dev);
 	return 0;
-}				// wl_init
+}				/* wl_init */
 
 /*============================================================================*/
 
@@ -168,12 +168,14 @@ int wl_config(struct net_device *dev, struct ifmap *map)
 	DBG_PARAM(DbgInfo, "dev", "%s (0x%p)", dev->name, dev);
 	DBG_PARAM(DbgInfo, "map", "0x%p", map);
 
-	/* The only thing we care about here is a port change. Since this not needed,
-	   ignore the request. */
+	/*
+	 * The only thing we care about here is a port change.
+	 * Since this not needed, ignore the request. 
+	 */
 	DBG_TRACE(DbgInfo, "%s: %s called.\n", dev->name, __func__);
 
 	return 0;
-}				// wl_config
+}				/* wl_config */
 
 /*============================================================================*/
 
@@ -204,7 +206,7 @@ struct net_device_stats *wl_stats(struct net_device *dev)
 	struct net_device_stats *pStats;
 	struct wl_private *lp = wl_priv(dev);
 
-	//DBG_PARAM( DbgInfo, "dev", "%s (0x%p)", dev->name, dev );
+	/*DBG_PARAM( DbgInfo, "dev", "%s (0x%p)", dev->name, dev ); */
 
 	pStats = NULL;
 
@@ -236,7 +238,7 @@ struct net_device_stats *wl_stats(struct net_device *dev)
 	wl_unlock(lp, &flags);
 
 	return pStats;
-}				// wl_stats
+}				/* wl_stats */
 
 /*============================================================================*/
 
@@ -287,7 +289,8 @@ int wl_open(struct net_device *dev)
 				  status);
 		}
 	}
-	// Holding the lock too long, make a gap to allow other processes
+
+	/* Holding the lock too long, make a gap to allow other processes */
 	wl_unlock(lp, &flags);
 	wl_lock(lp, &flags);
 
@@ -298,15 +301,15 @@ int wl_open(struct net_device *dev)
 		status = wl_apply(lp);
 	}
 
-	// Holding the lock too long, make a gap to allow other processes
+	/* Holding the lock too long, make a gap to allow other processes */
 	wl_unlock(lp, &flags);
 	wl_lock(lp, &flags);
 
-	if (status != HCF_SUCCESS) {
-		// Unsuccessful, try reset of the card to recover
+	/* Unsuccessful, try reset of the card to recover */
+	if (status != HCF_SUCCESS)
 		status = wl_reset(dev);
-	}
-	// Holding the lock too long, make a gap to allow other processes
+
+	/* Holding the lock too long, make a gap to allow other processes */
 	wl_unlock(lp, &flags);
 	wl_lock(lp, &flags);
 
@@ -314,7 +317,8 @@ int wl_open(struct net_device *dev)
 		netif_carrier_on(dev);
 		WL_WDS_NETIF_CARRIER_ON(lp);
 
-		lp->is_handling_int = WL_HANDLING_INT;	// Start handling interrupts
+		/* Start handling interrupts */
+		lp->is_handling_int = WL_HANDLING_INT;
 		wl_act_int_on(lp);
 
 		netif_start_queue(dev);
@@ -327,7 +331,7 @@ int wl_open(struct net_device *dev)
 	wl_unlock(lp, &flags);
 
 	return status;
-}				// wl_open
+}				/* wl_open */
 
 /*============================================================================*/
 
@@ -363,17 +367,19 @@ int wl_close(struct net_device *dev)
 	netif_carrier_off(dev);
 	WL_WDS_NETIF_CARRIER_OFF(lp);
 
-	/* Shutdown the adapter:
-	   Disable adapter interrupts
-	   Stop Tx/Rx
-	   Update statistics
-	   Set low power mode
+	/*
+	 * Shutdown the adapter:
+	 * Disable adapter interrupts
+	 * Stop Tx/Rx
+	 * Update statistics
+	 * Set low power mode
 	 */
 
 	wl_lock(lp, &flags);
 
 	wl_act_int_off(lp);
-	lp->is_handling_int = WL_NOT_HANDLING_INT;	// Stop handling interrupts
+	/* Stop handling interrupts */
+	lp->is_handling_int = WL_NOT_HANDLING_INT;
 
 #ifdef USE_RTS
 	if (lp->useRTS == 1) {
@@ -389,7 +395,7 @@ int wl_close(struct net_device *dev)
 	wl_unlock(lp, &flags);
 
 	return 0;
-}				// wl_close
+}				/* wl_close */
 
 /*============================================================================*/
 
@@ -404,7 +410,7 @@ static void wl_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 		snprintf(info->bus_info, sizeof(info->bus_info),
 			 "PCMCIA FIXME");
 	}
-}				// wl_get_drvinfo
+}				/* wl_get_drvinfo */
 
 static struct ethtool_ops wl_ethtool_ops = {
 	.get_drvinfo = wl_get_drvinfo,
@@ -469,7 +475,7 @@ int wl_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 #endif /* USE_UIL */
 
 		switch (cmd) {
-			// ================== Private IOCTLs (up to 16) ==================
+			/* ================== Private IOCTLs (up to 16) ================== */
 #ifdef USE_UIL
 		case WVLAN2_IOCTL_UIL:
 			DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL\n");
@@ -497,7 +503,7 @@ out_act_int_on_unlock:
 	wl_unlock(lp, &flags);
 
 	return ret;
-}				// wl_ioctl
+}				/* wl_ioctl */
 
 /*============================================================================*/
 
@@ -578,7 +584,7 @@ void wl_tx_timeout(struct net_device *dev)
 	pStats->tx_errors++;
 
 	wl_unlock(lp, &flags);
-}				// wl_tx_timeout
+}				/* wl_tx_timeout */
 
 /*============================================================================*/
 
@@ -619,11 +625,12 @@ int wl_send(struct wl_private *lp)
 		return FALSE;
 	}
 
-	/* Check for the availability of FIDs; if none are available, don't take any
-	   frames off the txQ */
-	if (lp->hcfCtx.IFB_RscInd == 0) {
+	/*
+	 * Check for the availability of FIDs; if none are available,
+	 * don't take any frames off the txQ
+	 */
+	if (lp->hcfCtx.IFB_RscInd == 0)
 		return FALSE;
-	}
 
 	/* Reclaim the TxQ Elements and place them back on the free queue */
 	if (!list_empty(&(lp->txQ[0]))) {
@@ -697,7 +704,7 @@ int wl_send(struct wl_private *lp)
 	}
 
 	return TRUE;
-}				// wl_send
+}				/* wl_send */
 
 /*============================================================================*/
 
@@ -786,7 +793,7 @@ int wl_tx(struct sk_buff *skb, struct net_device *dev, int port)
 	wl_act_int_on(lp);
 	wl_unlock(lp, &flags);
 	return 0;
-}				// wl_tx
+}				/* wl_tx */
 
 /*============================================================================*/
 
@@ -947,7 +954,7 @@ int wl_rx(struct net_device *dev)
 	}
 
 	return 0;
-}				// wl_rx
+}				/* wl_rx */
 
 /*============================================================================*/
 
@@ -972,8 +979,12 @@ int wl_rx(struct net_device *dev)
 
 void wl_multicast(struct net_device *dev)
 {
-#if 1				//;? (HCF_TYPE) & HCF_TYPE_STA //;?should we return an error status in AP mode
-//;?seems reasonable that even an AP-only driver could afford this small additional footprint
+#if 1				/* (HCF_TYPE) & HCF_TYPE_STA */
+	/*
+	 * should we return an error status in AP mode ?
+	 * seems reasonable that even an AP-only driver
+	 * could afford this small additional footprint
+	 */
 
 	int x;
 	struct netdev_hw_addr *ha;
@@ -1065,9 +1076,11 @@ void wl_multicast(struct net_device *dev)
 				hcf_put_info(&(lp->hcfCtx),
 					     (LTVP) & (lp->ltvRecord));
 
-				/* Turning on this filter will prevent all multicast frames from
-				   being sent up from the device; however, this is a static RID,
-				   so a call to wl_apply() is needed */
+				/*
+				 * Turning on this filter will prevent all multicast frames from
+				 * being sent up from the device; however, this is a static RID,
+				 * so a call to wl_apply() is needed
+				 */
 				lp->ltvRecord.len = 2;
 				lp->ltvRecord.typ = CFG_CNF_RX_ALL_GROUP_ADDR;
 				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(1);
@@ -1082,7 +1095,7 @@ void wl_multicast(struct net_device *dev)
 		wl_unlock(lp, &flags);
 	}
 #endif /* HCF_STA */
-}				// wl_multicast
+}				/* wl_multicast */
 
 /*============================================================================*/
 
@@ -1095,7 +1108,7 @@ void wl_multicast(struct net_device *dev, int num_addrs, void *addrs)
 	DBG_PARAM(DbgInfo, "addrs", "0x%p", addrs);
 
 #error Obsolete set multicast interface!
-}				// wl_multicast
+}				/* wl_multicast */
 
 /*============================================================================*/
 
@@ -1149,8 +1162,12 @@ struct net_device *wl_device_alloc(void)
 	if (!dev)
 		return NULL;
 
-	/* Initialize the 'next' pointer in the struct. Currently only used for PCI,
-	   but do it here just in case it's used for other buses in the future */
+	/*
+	 * Initialize the 'next' pointer in the struct.
+	 * Currently only used for PCI,
+	 * but do it here just in case it's used
+	 * for other buses in the future
+	 */
 	lp = wl_priv(dev);
 
 	/* Check MTU */
@@ -1178,7 +1195,7 @@ struct net_device *wl_device_alloc(void)
 	WL_WDS_DEVICE_ALLOC(lp);
 
 	return dev;
-}				// wl_device_alloc
+}				/* wl_device_alloc */
 
 /*============================================================================*/
 
@@ -1206,7 +1223,7 @@ void wl_device_dealloc(struct net_device *dev)
 	WL_WDS_DEVICE_DEALLOC(lp);
 
 	free_netdev(dev);
-}				// wl_device_dealloc
+}				/* wl_device_dealloc */
 
 /*============================================================================*/
 
@@ -1236,7 +1253,7 @@ int wl_tx_port0(struct sk_buff *skb, struct net_device *dev)
 #ifdef ENABLE_DMA
 	return wl_tx_dma(skb, dev, HCF_PORT_0);
 #endif
-}				// wl_tx_port0
+}				/* wl_tx_port0i */
 
 /*============================================================================*/
 
@@ -1264,7 +1281,7 @@ int wl_tx_port1(struct sk_buff *skb, struct net_device *dev)
 {
 	DBG_TX(DbgInfo, "Tx on Port 1\n");
 	return wl_tx(skb, dev, HCF_PORT_1);
-}				// wl_tx_port1
+}				/* wl_tx_port1 */
 
 /*============================================================================*/
 
@@ -1290,7 +1307,7 @@ int wl_tx_port2(struct sk_buff *skb, struct net_device *dev)
 {
 	DBG_TX(DbgInfo, "Tx on Port 2\n");
 	return wl_tx(skb, dev, HCF_PORT_2);
-}				// wl_tx_port2
+}				/* wl_tx_port2 */
 
 /*============================================================================*/
 
@@ -1316,7 +1333,7 @@ int wl_tx_port3(struct sk_buff *skb, struct net_device *dev)
 {
 	DBG_TX(DbgInfo, "Tx on Port 3\n");
 	return wl_tx(skb, dev, HCF_PORT_3);
-}				// wl_tx_port3
+}				/* wl_tx_port3 */
 
 /*============================================================================*/
 
@@ -1342,7 +1359,7 @@ int wl_tx_port4(struct sk_buff *skb, struct net_device *dev)
 {
 	DBG_TX(DbgInfo, "Tx on Port 4\n");
 	return wl_tx(skb, dev, HCF_PORT_4);
-}				// wl_tx_port4
+}				/* wl_tx_port4 */
 
 /*============================================================================*/
 
@@ -1368,7 +1385,7 @@ int wl_tx_port5(struct sk_buff *skb, struct net_device *dev)
 {
 	DBG_TX(DbgInfo, "Tx on Port 5\n");
 	return wl_tx(skb, dev, HCF_PORT_5);
-}				// wl_tx_port5
+}				/* wl_tx_port5 */
 
 /*============================================================================*/
 
@@ -1394,7 +1411,7 @@ int wl_tx_port6(struct sk_buff *skb, struct net_device *dev)
 {
 	DBG_TX(DbgInfo, "Tx on Port 6\n");
 	return wl_tx(skb, dev, HCF_PORT_6);
-}				// wl_tx_port6
+}				/* wl_tx_port6 */
 
 /*============================================================================*/
 
@@ -1436,12 +1453,13 @@ void wl_wds_device_alloc(struct wl_private *lp)
 		lp->wds_port[count].dev = dev_wds;
 
 		/* Re-use wl_init for all the devices, as it currently does nothing, but
-		   is required. Re-use the stats/tx_timeout handler for all as well; the
-		   WDS port which is requesting these operations can be determined by
-		   the net_device pointer. Set the private member of all devices to point
-		   to the same net_device struct; that way, all information gets
-		   funnelled through the one "real" net_device. Name the WDS ports
-		   "wds<n>" */
+		 * is required. Re-use the stats/tx_timeout handler for all as well; the
+		 * WDS port which is requesting these operations can be determined by
+		 * the net_device pointer. Set the private member of all devices to point
+		 * to the same net_device struct; that way, all information gets
+		 * funnelled through the one "real" net_device. Name the WDS ports
+		 * "wds<n>"
+		 * */
 		lp->wds_port[count].dev->init = &wl_init;
 		lp->wds_port[count].dev->get_stats = &wl_stats;
 		lp->wds_port[count].dev->tx_timeout = &wl_tx_timeout;
@@ -1460,7 +1478,7 @@ void wl_wds_device_alloc(struct wl_private *lp)
 	lp->wds_port[5].dev->hard_start_xmit = &wl_tx_port6;
 
 	WL_WDS_NETIF_STOP_QUEUE(lp);
-}				// wl_wds_device_alloc
+}				/* wl_wds_device_alloc */
 
 /*============================================================================*/
 
@@ -1500,7 +1518,7 @@ void wl_wds_device_dealloc(struct wl_private *lp)
 			lp->wds_port[count].dev = NULL;
 		}
 	}
-}				// wl_wds_device_dealloc
+}				/* wl_wds_device_dealloc */
 
 /*============================================================================*/
 
@@ -1536,7 +1554,7 @@ void wl_wds_netif_start_queue(struct wl_private *lp)
 			}
 		}
 	}
-}				// wl_wds_netif_start_queue
+}				/* wl_wds_netif_start_queue */
 
 /*============================================================================*/
 
@@ -1572,7 +1590,7 @@ void wl_wds_netif_stop_queue(struct wl_private *lp)
 			}
 		}
 	}
-}				// wl_wds_netif_stop_queue
+}				/* wl_wds_netif_stop_queue */
 
 /*============================================================================*/
 
@@ -1608,7 +1626,7 @@ void wl_wds_netif_wake_queue(struct wl_private *lp)
 			}
 		}
 	}
-}				// wl_wds_netif_wake_queue
+}				/* wl_wds_netif_wake_queue */
 
 /*============================================================================*/
 
@@ -1642,7 +1660,7 @@ void wl_wds_netif_carrier_on(struct wl_private *lp)
 			}
 		}
 	}
-}				// wl_wds_netif_carrier_on
+}				/* wl_wds_netif_carrier_on */
 
 /*============================================================================*/
 
@@ -1675,7 +1693,7 @@ void wl_wds_netif_carrier_off(struct wl_private *lp)
 		}
 	}
 
-}				// wl_wds_netif_carrier_off
+}				/* wl_wds_netif_carrier_off */
 
 /*============================================================================*/
 
@@ -1765,7 +1783,7 @@ int wl_send_dma(struct wl_private *lp, struct sk_buff *skb, int port)
 	dev_kfree_skb(skb);
 
 	return TRUE;
-}				// wl_send_dma
+}				/* wl_send_dma */
 
 /*============================================================================*/
 
@@ -1808,8 +1826,10 @@ int wl_rx_dma(struct net_device *dev)
 		}
 #endif /* USE_RTS */
 
-		//if( lp->dma.status == 0 )
-		//{
+		/*
+		 *if( lp->dma.status == 0 )
+		 *{
+		 */
 		desc = hcf_dma_rx_get(&(lp->hcfCtx));
 
 		if (desc != NULL) {
@@ -1926,11 +1946,11 @@ int wl_rx_dma(struct net_device *dev)
 				}
 			}
 		}
-		//}
+		/*}*/
 	}
 
 	return 0;
-}				// wl_rx_dma
+}				/* wl_rx_dma */
 
 /*============================================================================*/
-#endif // ENABLE_DMA
+#endif /* ENABLE_DMA */
-- 
1.9.0

