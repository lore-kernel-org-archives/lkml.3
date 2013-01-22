Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3AVOaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:30:55 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40408 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab3AVOaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:30:08 -0500
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/3] staging: et131x: Trivial camel case fixes
Date: Tue, 22 Jan 2013 14:29:48 +0000
Message-Id: <1358864989-4859-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358864989-4859-1-git-send-email-mark.einon@gmail.com>
References: <1358864989-4859-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch now highlights some camel case flag names. Fix these issues.

Also fix some remaining lines > 80chars issues for completeness.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   50 ++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 2b2f315..6db6d01 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -139,19 +139,19 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver for the ET1310 by Agere S
 #define NIC_SEND_HANG_THRESHOLD	0
 
 /* MP_TCB flags */
-#define fMP_DEST_MULTI			0x00000001
-#define fMP_DEST_BROAD			0x00000002
+#define FMP_DEST_MULTI			0x00000001
+#define FMP_DEST_BROAD			0x00000002
 
 /* MP_ADAPTER flags */
-#define fMP_ADAPTER_INTERRUPT_IN_USE	0x00000008
+#define FMP_ADAPTER_INTERRUPT_IN_USE	0x00000008
 
 /* MP_SHARED flags */
-#define fMP_ADAPTER_LOWER_POWER		0x00200000
+#define FMP_ADAPTER_LOWER_POWER		0x00200000
 
-#define fMP_ADAPTER_NON_RECOVER_ERROR	0x00800000
-#define fMP_ADAPTER_HARDWARE_ERROR	0x04000000
+#define FMP_ADAPTER_NON_RECOVER_ERROR	0x00800000
+#define FMP_ADAPTER_HARDWARE_ERROR	0x04000000
 
-#define fMP_ADAPTER_FAIL_SEND_MASK	0x3ff00000
+#define FMP_ADAPTER_FAIL_SEND_MASK	0x3ff00000
 
 /* Some offsets in PCI config space that are actually used. */
 #define ET1310_PCI_MAC_ADDRESS		0xA4
@@ -1062,7 +1062,7 @@ static void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 	writel(ctl, &adapter->regs->txmac.ctl);
 
 	/* Ready to start the RXDMA/TXDMA engine */
-	if (adapter->flags & fMP_ADAPTER_LOWER_POWER) {
+	if (adapter->flags & FMP_ADAPTER_LOWER_POWER) {
 		et131x_rx_dma_enable(adapter);
 		et131x_tx_dma_enable(adapter);
 	}
@@ -2068,7 +2068,7 @@ static void et131x_enable_txrx(struct net_device *netdev)
 	et131x_tx_dma_enable(adapter);
 
 	/* Enable device interrupts */
-	if (adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE)
+	if (adapter->flags & FMP_ADAPTER_INTERRUPT_IN_USE)
 		et131x_enable_interrupts(adapter);
 
 	/* We're ready to move some data, so start the queue */
@@ -2167,7 +2167,7 @@ static void et1310_enable_phy_coma(struct et131x_adapter *adapter)
 
 	/* Stop sending packets. */
 	spin_lock_irqsave(&adapter->send_hw_lock, flags);
-	adapter->flags |= fMP_ADAPTER_LOWER_POWER;
+	adapter->flags |= FMP_ADAPTER_LOWER_POWER;
 	spin_unlock_irqrestore(&adapter->send_hw_lock, flags);
 
 	/* Wait for outstanding Receive packets */
@@ -2220,7 +2220,7 @@ static void et1310_disable_phy_coma(struct et131x_adapter *adapter)
 	et131x_adapter_setup(adapter);
 
 	/* Allow Tx to restart */
-	adapter->flags &= ~fMP_ADAPTER_LOWER_POWER;
+	adapter->flags &= ~FMP_ADAPTER_LOWER_POWER;
 
 	et131x_enable_txrx(adapter->netdev);
 }
@@ -3041,13 +3041,15 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 	if (phydev && phydev->speed == SPEED_1000) {
 		if (++adapter->tx_ring.since_irq == PARM_TX_NUM_BUFS_DEF) {
 			/* Last element & Interrupt flag */
-			desc[frag - 1].flags = TXDESC_FLAG_INTPROC | TXDESC_FLAG_LASTPKT;
+			desc[frag - 1].flags =
+				    TXDESC_FLAG_INTPROC | TXDESC_FLAG_LASTPKT;
 			adapter->tx_ring.since_irq = 0;
 		} else { /* Last element */
 			desc[frag - 1].flags = TXDESC_FLAG_LASTPKT;
 		}
 	} else
-		desc[frag - 1].flags = TXDESC_FLAG_INTPROC | TXDESC_FLAG_LASTPKT;
+		desc[frag - 1].flags =
+				    TXDESC_FLAG_INTPROC | TXDESC_FLAG_LASTPKT;
 
 	desc[0].flags |= TXDESC_FLAG_FIRSTPKT;
 
@@ -3168,9 +3170,9 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *adapter)
 
 		if ((shbufva[0] == 0xffff) &&
 		    (shbufva[1] == 0xffff) && (shbufva[2] == 0xffff)) {
-			tcb->flags |= fMP_DEST_BROAD;
+			tcb->flags |= FMP_DEST_BROAD;
 		} else if ((shbufva[0] & 0x3) == 0x0001) {
-			tcb->flags |=  fMP_DEST_MULTI;
+			tcb->flags |=  FMP_DEST_MULTI;
 		}
 	}
 
@@ -3225,7 +3227,7 @@ static int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
 		/* We need to see if the link is up; if it's not, make the
 		 * netif layer think we're good and drop the packet
 		 */
-		if ((adapter->flags & fMP_ADAPTER_FAIL_SEND_MASK) ||
+		if ((adapter->flags & FMP_ADAPTER_FAIL_SEND_MASK) ||
 					!netif_carrier_ok(netdev)) {
 			dev_kfree_skb_any(skb);
 			skb = NULL;
@@ -3262,9 +3264,9 @@ static inline void free_send_packet(struct et131x_adapter *adapter,
 	struct net_device_stats *stats = &adapter->net_stats;
 	u64  dma_addr;
 
-	if (tcb->flags & fMP_DEST_BROAD)
+	if (tcb->flags & FMP_DEST_BROAD)
 		atomic_inc(&adapter->stats.broadcast_pkts_xmtd);
-	else if (tcb->flags & fMP_DEST_MULTI)
+	else if (tcb->flags & FMP_DEST_MULTI)
 		atomic_inc(&adapter->stats.multicast_pkts_xmtd);
 	else
 		atomic_inc(&adapter->stats.unicast_pkts_xmtd);
@@ -4351,7 +4353,7 @@ static void et131x_isr_handler(struct work_struct *work)
 		 * to do is disable the interrupts and set the flag to cause us
 		 * to reset so we can solve this issue.
 		 */
-		/* MP_SET_FLAG( adapter, fMP_ADAPTER_HARDWARE_ERROR); */
+		/* MP_SET_FLAG( adapter, FMP_ADAPTER_HARDWARE_ERROR); */
 
 		dev_warn(&adapter->pdev->dev,
 			 "RXMAC interrupt, error 0x%08x.  Requesting reset\n",
@@ -4466,7 +4468,7 @@ static int et131x_open(struct net_device *netdev)
 		return result;
 	}
 
-	adapter->flags |= fMP_ADAPTER_INTERRUPT_IN_USE;
+	adapter->flags |= FMP_ADAPTER_INTERRUPT_IN_USE;
 
 	et131x_up(netdev);
 
@@ -4485,7 +4487,7 @@ static int et131x_close(struct net_device *netdev)
 
 	et131x_down(netdev);
 
-	adapter->flags &= ~fMP_ADAPTER_INTERRUPT_IN_USE;
+	adapter->flags &= ~FMP_ADAPTER_INTERRUPT_IN_USE;
 	free_irq(adapter->pdev->irq, netdev);
 
 	/* Stop the error timer */
@@ -4695,17 +4697,17 @@ static void et131x_tx_timeout(struct net_device *netdev)
 	unsigned long flags;
 
 	/* If the device is closed, ignore the timeout */
-	if (~(adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE))
+	if (~(adapter->flags & FMP_ADAPTER_INTERRUPT_IN_USE))
 		return;
 
 	/* Any nonrecoverable hardware error?
 	 * Checks adapter->flags for any failure in phy reading
 	 */
-	if (adapter->flags & fMP_ADAPTER_NON_RECOVER_ERROR)
+	if (adapter->flags & FMP_ADAPTER_NON_RECOVER_ERROR)
 		return;
 
 	/* Hardware failure? */
-	if (adapter->flags & fMP_ADAPTER_HARDWARE_ERROR) {
+	if (adapter->flags & FMP_ADAPTER_HARDWARE_ERROR) {
 		dev_err(&adapter->pdev->dev, "hardware error - reset\n");
 		return;
 	}
-- 
1.7.10.4

