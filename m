Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbaICVlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:41:32 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52582 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaICVl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:41:29 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 4/4] staging: et131x: Fix whitespace - alignment matching open parenthesis
Date: Wed,  3 Sep 2014 22:40:57 +0100
Message-Id: <1409780457-6060-4-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409780457-6060-1-git-send-email-mark.einon@gmail.com>
References: <1409780457-6060-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix occurrences in et131x.c of:

CHECK: Alignment should match open parenthesis

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c | 130 +++++++++++++++++++++-------------------
 1 file changed, 67 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 1ac9e7e..2543ac0 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -594,11 +594,11 @@ static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 	  *    byte addressing).
 	  */
 	if (pci_write_config_byte(pdev, LBCIF_CONTROL_REGISTER,
-			LBCIF_CONTROL_LBCIF_ENABLE | LBCIF_CONTROL_I2C_WRITE))
+				  LBCIF_CONTROL_LBCIF_ENABLE |
+					LBCIF_CONTROL_I2C_WRITE))
 		return -EIO;
 
 	/* Prepare EEPROM address for Step 3 */
-
 	for (retries = 0; retries < MAX_NUM_WRITE_RETRIES; retries++) {
 		/* Write the address to the LBCIF Address Register */
 		if (pci_write_config_dword(pdev, LBCIF_ADDRESS_REGISTER, addr))
@@ -654,7 +654,7 @@ static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 
 	while (1) {
 		if (pci_write_config_byte(pdev, LBCIF_CONTROL_REGISTER,
-			LBCIF_CONTROL_LBCIF_ENABLE))
+					  LBCIF_CONTROL_LBCIF_ENABLE))
 			writeok = 0;
 
 		/* Do read until internal ACK_ERROR goes away meaning write
@@ -666,7 +666,8 @@ static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 					       addr);
 			do {
 				pci_read_config_dword(pdev,
-					LBCIF_DATA_REGISTER, &val);
+						      LBCIF_DATA_REGISTER,
+						      &val);
 			} while ((val & 0x00010000) == 0);
 		} while (val & 0x00040000);
 
@@ -747,7 +748,7 @@ static int et131x_init_eeprom(struct et131x_adapter *adapter)
 	 */
 	if (pci_read_config_byte(pdev, ET1310_PCI_EEPROM_STATUS, &eestatus)) {
 		dev_err(&pdev->dev,
-		       "Could not read PCI config space for EEPROM Status\n");
+			"Could not read PCI config space for EEPROM Status\n");
 		return -EIO;
 	}
 
@@ -771,7 +772,8 @@ static int et131x_init_eeprom(struct et131x_adapter *adapter)
 		}
 		if (pdev->revision  != 0x01 || write_failed) {
 			dev_err(&pdev->dev,
-			    "Fatal EEPROM Status Error - 0x%04x\n", eestatus);
+				"Fatal EEPROM Status Error - 0x%04x\n",
+				eestatus);
 
 			/* This error could mean that there was an error
 			 * reading the eeprom or that the eeprom doesn't exist.
@@ -829,7 +831,7 @@ static void et131x_rx_dma_enable(struct et131x_adapter *adapter)
 		csr = readl(&adapter->regs->rxdma.csr);
 		if (csr & ET_RXDMA_CSR_HALT_STATUS) {
 			dev_err(&adapter->pdev->dev,
-			    "RX Dma failed to exit halt state.  CSR 0x%08x\n",
+				"RX Dma failed to exit halt state. CSR 0x%08x\n",
 				csr);
 		}
 	}
@@ -850,8 +852,8 @@ static void et131x_rx_dma_disable(struct et131x_adapter *adapter)
 		csr = readl(&adapter->regs->rxdma.csr);
 		if (!(csr & ET_RXDMA_CSR_HALT_STATUS))
 			dev_err(&adapter->pdev->dev,
-			      "RX Dma failed to enter halt state. CSR 0x%08x\n",
-			      csr);
+				"RX Dma failed to enter halt state. CSR 0x%08x\n",
+				csr);
 	}
 }
 
@@ -865,8 +867,8 @@ static void et131x_tx_dma_enable(struct et131x_adapter *adapter)
 	/* Setup the transmit dma configuration register for normal
 	 * operation
 	 */
-	writel(ET_TXDMA_SNGL_EPKT|(PARM_DMA_CACHE_DEF << ET_TXDMA_CACHE_SHIFT),
-					&adapter->regs->txdma.csr);
+	writel(ET_TXDMA_SNGL_EPKT | (PARM_DMA_CACHE_DEF << ET_TXDMA_CACHE_SHIFT),
+	       &adapter->regs->txdma.csr);
 }
 
 static inline void add_10bit(u32 *v, int n)
@@ -976,7 +978,7 @@ static void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 	/* Initialize loop back to off */
 	cfg1 &= ~(ET_MAC_CFG1_LOOPBACK | ET_MAC_CFG1_RX_FLOW);
 	if (adapter->flowcontrol == FLOW_RXONLY ||
-				adapter->flowcontrol == FLOW_BOTH)
+	    adapter->flowcontrol == FLOW_BOTH)
 		cfg1 |= ET_MAC_CFG1_RX_FLOW;
 	writel(cfg1, &mac->cfg1);
 
@@ -1010,8 +1012,8 @@ static void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 
 	if (delay == 100) {
 		dev_warn(&adapter->pdev->dev,
-		    "Syncd bits did not respond correctly cfg1 word 0x%08x\n",
-			cfg1);
+			 "Syncd bits did not respond correctly cfg1 word 0x%08x\n",
+			 cfg1);
 	}
 
 	/* Enable txmac */
@@ -1276,7 +1278,7 @@ static void et1310_config_macstat_regs(struct et131x_adapter *adapter)
  * @value: pointer to a 16-bit value in which the value will be stored
  */
 static int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
-	      u8 reg, u16 *value)
+			       u8 reg, u16 *value)
 {
 	struct mac_regs __iomem *mac = &adapter->regs->mac;
 	int status = 0;
@@ -1308,9 +1310,9 @@ static int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
 	/* If we hit the max delay, we could not read the register */
 	if (delay == 50) {
 		dev_warn(&adapter->pdev->dev,
-			    "reg 0x%08x could not be read\n", reg);
+			 "reg 0x%08x could not be read\n", reg);
 		dev_warn(&adapter->pdev->dev, "status is  0x%08x\n",
-			    mii_indicator);
+			 mii_indicator);
 
 		status = -EIO;
 		goto out;
@@ -1385,11 +1387,11 @@ static int et131x_mii_write(struct et131x_adapter *adapter, u8 addr, u8 reg,
 		u16 tmp;
 
 		dev_warn(&adapter->pdev->dev,
-		    "reg 0x%08x could not be written", reg);
+			 "reg 0x%08x could not be written", reg);
 		dev_warn(&adapter->pdev->dev, "status is  0x%08x\n",
-			    mii_indicator);
+			 mii_indicator);
 		dev_warn(&adapter->pdev->dev, "command is  0x%08x\n",
-			    readl(&mac->mii_mgmt_cmd));
+			 readl(&mac->mii_mgmt_cmd));
 
 		et131x_mii_read(adapter, reg, &tmp);
 
@@ -1857,7 +1859,7 @@ static void et131x_tx_dma_disable(struct et131x_adapter *adapter)
 {
 	/* Setup the transmit dma configuration register */
 	writel(ET_TXDMA_CSR_HALT | ET_TXDMA_SNGL_EPKT,
-					&adapter->regs->txdma.csr);
+	       &adapter->regs->txdma.csr);
 }
 
 /* et131x_enable_txrx - Enable tx/rx queues */
@@ -2092,7 +2094,8 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 							GFP_KERNEL);
 		if (!fbr->ring_virtaddr) {
 			dev_err(&adapter->pdev->dev,
-			   "Cannot alloc memory for Free Buffer Ring %d\n", id);
+				"Cannot alloc memory for Free Buffer Ring %d\n",
+				id);
 			return -ENOMEM;
 		}
 	}
@@ -2151,7 +2154,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	if (!rx_ring->ps_ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
-			  "Cannot alloc memory for Packet Status Ring\n");
+			"Cannot alloc memory for Packet Status Ring\n");
 		return -ENOMEM;
 	}
 
@@ -2168,7 +2171,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 					    GFP_KERNEL);
 	if (!rx_ring->rx_status_block) {
 		dev_err(&adapter->pdev->dev,
-			  "Cannot alloc memory for Status Block\n");
+			"Cannot alloc memory for Status Block\n");
 		return -ENOMEM;
 	}
 	rx_ring->num_rfd = NIC_DEFAULT_NUM_RFD;
@@ -2242,8 +2245,8 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 					rx_ring->psr_num_entries;
 
 		dma_free_coherent(&adapter->pdev->dev, pktstat_ringsize,
-				    rx_ring->ps_ring_virtaddr,
-				    rx_ring->ps_ring_physaddr);
+				  rx_ring->ps_ring_virtaddr,
+				  rx_ring->ps_ring_physaddr);
 
 		rx_ring->ps_ring_virtaddr = NULL;
 	}
@@ -2251,8 +2254,9 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	/* Free area of memory for the writeback of status information */
 	if (rx_ring->rx_status_block) {
 		dma_free_coherent(&adapter->pdev->dev,
-			sizeof(struct rx_status_block),
-			rx_ring->rx_status_block, rx_ring->rx_status_bus);
+				  sizeof(struct rx_status_block),
+				  rx_ring->rx_status_block,
+				  rx_ring->rx_status_bus);
 		rx_ring->rx_status_block = NULL;
 	}
 
@@ -2345,7 +2349,7 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 		writel(free_buff_ring, offset);
 	} else {
 		dev_err(&adapter->pdev->dev,
-			  "%s illegal Buffer Index returned\n", __func__);
+			"%s illegal Buffer Index returned\n", __func__);
 	}
 
 	/* The processing on this RFD is done, so put it back on the tail of
@@ -2738,19 +2742,19 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 			} else {
 				desc[frag].len_vlan = skb_headlen(skb) / 2;
 				dma_addr = dma_map_single(&adapter->pdev->dev,
-							 skb->data,
-							 (skb_headlen(skb) / 2),
-							 DMA_TO_DEVICE);
+							  skb->data,
+							  (skb_headlen(skb) / 2),
+							  DMA_TO_DEVICE);
 				desc[frag].addr_lo = lower_32_bits(dma_addr);
 				desc[frag].addr_hi = upper_32_bits(dma_addr);
 				frag++;
 
 				desc[frag].len_vlan = skb_headlen(skb) / 2;
 				dma_addr = dma_map_single(&adapter->pdev->dev,
-							 skb->data +
-							 (skb_headlen(skb) / 2),
-							 (skb_headlen(skb) / 2),
-							 DMA_TO_DEVICE);
+							  skb->data +
+							  (skb_headlen(skb) / 2),
+							  (skb_headlen(skb) / 2),
+							  DMA_TO_DEVICE);
 				desc[frag].addr_lo = lower_32_bits(dma_addr);
 				desc[frag].addr_hi = upper_32_bits(dma_addr);
 				frag++;
@@ -2804,7 +2808,7 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 	add_10bit(&tx_ring->send_idx, thiscopy);
 
 	if (INDEX10(tx_ring->send_idx) == 0 ||
-		  INDEX10(tx_ring->send_idx) == NUM_DESC_PER_RING_TX) {
+	    INDEX10(tx_ring->send_idx) == NUM_DESC_PER_RING_TX) {
 		tx_ring->send_idx &= ~ET_DMA10_MASK;
 		tx_ring->send_idx ^= ET_DMA10_WRAP;
 	}
@@ -2947,7 +2951,7 @@ static int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
 		 * netif layer think we're good and drop the packet
 		 */
 		if ((adapter->flags & FMP_ADAPTER_FAIL_SEND_MASK) ||
-					!netif_carrier_ok(netdev)) {
+		    !netif_carrier_ok(netdev)) {
 			dev_kfree_skb_any(skb);
 			skb = NULL;
 
@@ -2975,7 +2979,7 @@ static int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
  * Assumption - Send spinlock has been acquired
  */
 static inline void free_send_packet(struct et131x_adapter *adapter,
-						struct tcb *tcb)
+				    struct tcb *tcb)
 {
 	unsigned long flags;
 	struct tx_desc *desc = NULL;
@@ -3358,7 +3362,7 @@ static void et131x_hwaddr_init(struct et131x_adapter *adapter)
 		 * address into the permanent address
 		 */
 		memcpy(adapter->rom_addr,
-			adapter->addr, ETH_ALEN);
+		       adapter->addr, ETH_ALEN);
 	} else {
 		/* We do not have an override address, so set the
 		 * current address to the permanent address and add
@@ -3399,15 +3403,15 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 		static const u16 replay[2] = { 0x1E0, 0x2ED };
 
 		if (pci_write_config_word(pdev, ET1310_PCI_ACK_NACK,
-					       acknak[max_payload])) {
+					  acknak[max_payload])) {
 			dev_err(&pdev->dev,
-			  "Could not write PCI config space for ACK/NAK\n");
+				"Could not write PCI config space for ACK/NAK\n");
 			goto err_out;
 		}
 		if (pci_write_config_word(pdev, ET1310_PCI_REPLAY,
-					       replay[max_payload])) {
+					  replay[max_payload])) {
 			dev_err(&pdev->dev,
-			  "Could not write PCI config space for Replay Timer\n");
+				"Could not write PCI config space for Replay Timer\n");
 			goto err_out;
 		}
 	}
@@ -3417,7 +3421,7 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 	 */
 	if (pci_write_config_byte(pdev, ET1310_PCI_L0L1LATENCY, 0x11)) {
 		dev_err(&pdev->dev,
-		  "Could not write PCI config space for Latency Timers\n");
+			"Could not write PCI config space for Latency Timers\n");
 		goto err_out;
 	}
 
@@ -3438,7 +3442,7 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 
 	for (i = 0; i < ETH_ALEN; i++) {
 		if (pci_read_config_byte(pdev, ET1310_PCI_MAC_ADDRESS + i,
-					adapter->rom_addr + i)) {
+					 adapter->rom_addr + i)) {
 			dev_err(&pdev->dev, "Could not read PCI config space for MAC address\n");
 			goto err_out;
 		}
@@ -3510,7 +3514,7 @@ static int et131x_adapter_memory_alloc(struct et131x_adapter *adapter)
 	status = et131x_tx_dma_memory_alloc(adapter);
 	if (status) {
 		dev_err(&adapter->pdev->dev,
-			  "et131x_tx_dma_memory_alloc FAILED\n");
+			"et131x_tx_dma_memory_alloc FAILED\n");
 		et131x_tx_dma_memory_free(adapter);
 		return status;
 	}
@@ -3518,7 +3522,7 @@ static int et131x_adapter_memory_alloc(struct et131x_adapter *adapter)
 	status = et131x_rx_dma_memory_alloc(adapter);
 	if (status) {
 		dev_err(&adapter->pdev->dev,
-			  "et131x_rx_dma_memory_alloc FAILED\n");
+			"et131x_rx_dma_memory_alloc FAILED\n");
 		et131x_adapter_memory_free(adapter);
 		return status;
 	}
@@ -3558,7 +3562,7 @@ static void et131x_adjust_link(struct net_device *netdev)
 			u16 register18;
 
 			et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
-					 &register18);
+					&register18);
 			et131x_mii_write(adapter, phydev->addr,
 					 PHY_MPHY_CONTROL_REG, register18 | 0x4);
 			et131x_mii_write(adapter, phydev->addr, PHY_INDEX_REG,
@@ -3591,15 +3595,15 @@ static void et131x_adjust_link(struct net_device *netdev)
 			u16 register18;
 
 			et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
-					 &register18);
+					&register18);
 			et131x_mii_write(adapter, phydev->addr,
-					PHY_MPHY_CONTROL_REG, register18 | 0x4);
+					 PHY_MPHY_CONTROL_REG, register18 | 0x4);
 			et131x_mii_write(adapter, phydev->addr,
-					PHY_INDEX_REG, register18 | 0x8402);
+					 PHY_INDEX_REG, register18 | 0x8402);
 			et131x_mii_write(adapter, phydev->addr,
-					PHY_DATA_REG, register18 | 511);
+					 PHY_DATA_REG, register18 | 511);
 			et131x_mii_write(adapter, phydev->addr,
-					PHY_MPHY_CONTROL_REG, register18);
+					 PHY_MPHY_CONTROL_REG, register18);
 		}
 
 		/* Free the packets being actively sent & stopped */
@@ -3861,8 +3865,8 @@ static irqreturn_t et131x_isr(int irq, void *dev_id)
 		u32 txdma_err = readl(&iomem->txdma.tx_dma_error);
 
 		dev_warn(&adapter->pdev->dev,
-			    "TXDMA_ERR interrupt, error = %d\n",
-			    txdma_err);
+			 "TXDMA_ERR interrupt, error = %d\n",
+			 txdma_err);
 	}
 
 	/* Handle Free Buffer Ring 0 and 1 Low interrupt */
@@ -3925,8 +3929,8 @@ static irqreturn_t et131x_isr(int irq, void *dev_id)
 		/* TRAP();*/
 
 		dev_warn(&adapter->pdev->dev,
-			    "RxDMA_ERR interrupt, error %x\n",
-			    readl(&iomem->txmac.tx_test));
+			 "RxDMA_ERR interrupt, error %x\n",
+			 readl(&iomem->txmac.tx_test));
 	}
 
 	/* Handle the Wake on LAN Event */
@@ -4319,9 +4323,9 @@ static void et131x_tx_timeout(struct net_device *netdev)
 					       flags);
 
 			dev_warn(&adapter->pdev->dev,
-				"Send stuck - reset.  tcb->WrIndex %x, flags 0x%08x\n",
-				tcb->index,
-				tcb->flags);
+				 "Send stuck - reset. tcb->WrIndex %x, flags 0x%08x\n",
+				 tcb->index,
+				 tcb->flags);
 
 			adapter->netdev->stats.tx_errors++;
 
@@ -4361,7 +4365,7 @@ static int et131x_change_mtu(struct net_device *netdev, int new_mtu)
 	result = et131x_adapter_memory_alloc(adapter);
 	if (result != 0) {
 		dev_warn(&adapter->pdev->dev,
-			"Change MTU failed; couldn't re-alloc DMA memory\n");
+			 "Change MTU failed; couldn't re-alloc DMA memory\n");
 		return result;
 	}
 
@@ -4500,7 +4504,7 @@ static int et131x_pci_setup(struct pci_dev *pdev,
 
 	adapter->mii_bus->name = "et131x_eth_mii";
 	snprintf(adapter->mii_bus->id, MII_BUS_ID_SIZE, "%x",
-		(adapter->pdev->bus->number << 8) | adapter->pdev->devfn);
+		 (adapter->pdev->bus->number << 8) | adapter->pdev->devfn);
 	adapter->mii_bus->priv = netdev;
 	adapter->mii_bus->read = et131x_mdio_read;
 	adapter->mii_bus->write = et131x_mdio_write;
-- 
2.1.0

