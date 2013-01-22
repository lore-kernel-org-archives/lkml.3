Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3AVOaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:30:20 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:48614 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab3AVOaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:30:12 -0500
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=203/3=5D=20staging=3A=20et131x=3A=20Modify=20block=20comments=20to=20fit=20with=20networking=20style?=
Date: Tue, 22 Jan 2013 14:29:49 +0000
Message-Id: <1358864989-4859-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358864989-4859-1-git-send-email-mark.einon@gmail.com>
References: <1358864989-4859-1-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for moving et131x to drivers/net, fixup the block
comments to match the preferred networking style - no /* on separate
line, but */ are on a seperate line.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |  370 ++++++++++++++-------------------------
 1 file changed, 132 insertions(+), 238 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 6db6d01..4a7c302 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1,5 +1,4 @@
-/*
- * Agere Systems Inc.
+/* Agere Systems Inc.
  * 10/100/1000 Base-T Ethernet Driver for the ET1301 and ET131x series MACs
  *
  * Copyright © 2005 Agere Systems Inc.
@@ -50,7 +49,6 @@
  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
  * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  * DAMAGE.
- *
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -102,8 +100,7 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver for the ET1310 by Agere S
 #define INTERNAL_MEM_RX_OFFSET  0x1FF	/* 50%   Tx, 50%   Rx */
 
 /* ISR defines */
-/*
- * For interrupts, normal running is:
+/* For interrupts, normal running is:
  *       rxdma_xfr_done, phy_interrupt, mac_stat_interrupt,
  *       watchdog_interrupt & txdma_xfer_done
  *
@@ -245,8 +242,7 @@ struct pkt_stat_desc {
 
 /* Typedefs for the RX DMA status word */
 
-/*
- * rx status word 0 holds part of the status bits of the Rx DMA engine
+/* rx status word 0 holds part of the status bits of the Rx DMA engine
  * that get copied out to memory by the ET-1310.  Word 0 is a 32 bit word
  * which contains the Free Buffer ring 0 and 1 available offset.
  *
@@ -256,8 +252,7 @@ struct pkt_stat_desc {
  * bit 26 Wrap flag for FBR0
  */
 
-/*
- * RXSTAT_WORD1_t structure holds part of the status bits of the Rx DMA engine
+/* RXSTAT_WORD1_t structure holds part of the status bits of the Rx DMA engine
  * that get copied out to memory by the ET-1310.  Word 3 is a 32 bit word
  * which contains the Packet Status Ring available offset.
  *
@@ -267,8 +262,7 @@ struct pkt_stat_desc {
  * bit 29-31 unused
  */
 
-/*
- * struct rx_status_block is a structure representing the status of the Rx
+/* struct rx_status_block is a structure representing the status of the Rx
  * DMA engine it sits in free memory, and is pointed to by 0x101c / 0x1020
  */
 struct rx_status_block {
@@ -276,8 +270,7 @@ struct rx_status_block {
 	u32 word1;
 };
 
-/*
- * Structure for look-up table holding free buffer ring pointers, addresses
+/* Structure for look-up table holding free buffer ring pointers, addresses
  * and state.
  */
 struct fbr_lookup {
@@ -293,8 +286,7 @@ struct fbr_lookup {
 	dma_addr_t	 buffsize;
 };
 
-/*
- * struct rx_ring is the sructure representing the adaptor's local
+/* struct rx_ring is the sructure representing the adaptor's local
  * reference(s) to the rings
  */
 struct rx_ring {
@@ -317,8 +309,7 @@ struct rx_ring {
 };
 
 /* TX defines */
-/*
- * word 2 of the control bits in the Tx Descriptor ring for the ET-1310
+/* word 2 of the control bits in the Tx Descriptor ring for the ET-1310
  *
  * 0-15: length of packet
  * 16-27: VLAN tag
@@ -356,8 +347,7 @@ struct tx_desc {
 	u32 flags;	/* data (detailed above) */
 };
 
-/*
- * The status of the Tx DMA engine it sits in free memory, and is pointed to
+/* The status of the Tx DMA engine it sits in free memory, and is pointed to
  * by 0x101c / 0x1020. This is a DMA10 type
  */
 
@@ -406,15 +396,13 @@ struct tx_ring {
 	int since_irq;
 };
 
-/*
- * Do not change these values: if changed, then change also in respective
+/* Do not change these values: if changed, then change also in respective
  * TXdma and Rxdma engines
  */
 #define NUM_DESC_PER_RING_TX         512    /* TX Do not change these values */
 #define NUM_TCB                      64
 
-/*
- * These values are all superseded by registry entries to facilitate tuning.
+/* These values are all superseded by registry entries to facilitate tuning.
  * Once the desired performance has been achieved, the optimal registry values
  * should be re-populated to these #defines:
  */
@@ -559,8 +547,7 @@ static int eeprom_wait_ready(struct pci_dev *pdev, u32 *status)
 	u32 reg;
 	int i;
 
-	/*
-	 * 1. Check LBCIF Status Register for bits 6 & 3:2 all equal to 0 and
+	/* 1. Check LBCIF Status Register for bits 6 & 3:2 all equal to 0 and
 	 *    bits 7,1:0 both equal to 1, at least once after reset.
 	 *    Subsequent operations need only to check that bits 1:0 are equal
 	 *    to 1 prior to starting a single byte read/write
@@ -581,8 +568,7 @@ static int eeprom_wait_ready(struct pci_dev *pdev, u32 *status)
 	return -ETIMEDOUT;
 }
 
-/**
- * eeprom_write - Write a byte to the ET1310's EEPROM
+/* eeprom_write - Write a byte to the ET1310's EEPROM
  * @adapter: pointer to our private adapter structure
  * @addr: the address to write
  * @data: the value to write
@@ -600,8 +586,7 @@ static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 	u32 status;
 	u32 val = 0;
 
-	/*
-	 * For an EEPROM, an I2C single byte write is defined as a START
+	/* For an EEPROM, an I2C single byte write is defined as a START
 	 * condition followed by the device address, EEPROM address, one byte
 	 * of data and a STOP condition.  The STOP condition will trigger the
 	 * EEPROM's internally timed write cycle to the nonvolatile memory.
@@ -613,12 +598,11 @@ static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 	if (err)
 		return err;
 
-	 /*
-	 * 2. Write to the LBCIF Control Register:  bit 7=1, bit 6=1, bit 3=0,
-	 *    and bits 1:0 both =0.  Bit 5 should be set according to the
-	 *    type of EEPROM being accessed (1=two byte addressing, 0=one
-	 *    byte addressing).
-	 */
+	 /* 2. Write to the LBCIF Control Register:  bit 7=1, bit 6=1, bit 3=0,
+	  *    and bits 1:0 both =0.  Bit 5 should be set according to the
+	  *    type of EEPROM being accessed (1=two byte addressing, 0=one
+	  *    byte addressing).
+	  */
 	if (pci_write_config_byte(pdev, LBCIF_CONTROL_REGISTER,
 			LBCIF_CONTROL_LBCIF_ENABLE | LBCIF_CONTROL_I2C_WRITE))
 		return -EIO;
@@ -631,14 +615,12 @@ static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 		/* Write the address to the LBCIF Address Register */
 		if (pci_write_config_dword(pdev, LBCIF_ADDRESS_REGISTER, addr))
 			break;
-		/*
-		 * Write the data to the LBCIF Data Register (the I2C write
+		/* Write the data to the LBCIF Data Register (the I2C write
 		 * will begin).
 		 */
 		if (pci_write_config_byte(pdev, LBCIF_DATA_REGISTER, data))
 			break;
-		/*
-		 * Monitor bit 1:0 of the LBCIF Status Register.  When bits
+		/* Monitor bit 1:0 of the LBCIF Status Register.  When bits
 		 * 1:0 are both equal to 1, the I2C write has completed and the
 		 * internal write cycle of the EEPROM is about to start.
 		 * (bits 1:0 = 01 is a legal state while waiting from both
@@ -649,8 +631,7 @@ static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 		if (err < 0)
 			return 0;
 
-		/*
-		 * Check bit 3 of the LBCIF Status Register.  If  equal to 1,
+		/* Check bit 3 of the LBCIF Status Register.  If  equal to 1,
 		 * an error has occurred.Don't break here if we are revision
 		 * 1, this is so we do a blind write for load bug.
 		 */
@@ -658,8 +639,7 @@ static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 			&& adapter->pdev->revision == 0)
 			break;
 
-		/*
-		 * Check bit 2 of the LBCIF Status Register.  If equal to 1 an
+		/* Check bit 2 of the LBCIF Status Register.  If equal to 1 an
 		 * ACK error has occurred on the address phase of the write.
 		 * This could be due to an actual hardware failure or the
 		 * EEPROM may still be in its internal write cycle from a
@@ -667,8 +647,7 @@ static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 		  *repeated later.
 		 */
 		if (status & LBCIF_STATUS_ACK_ERROR) {
-			/*
-			 * This could be due to an actual hardware failure
+			/* This could be due to an actual hardware failure
 			 * or the EEPROM may still be in its internal write
 			 * cycle from a previous write. This write operation
 			 * was ignored and must be repeated later.
@@ -681,8 +660,7 @@ static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 		break;
 	}
 
-	/*
-	 * Set bit 6 of the LBCIF Control Register = 0.
+	/* Set bit 6 of the LBCIF Control Register = 0.
 	 */
 	udelay(10);
 
@@ -711,8 +689,7 @@ static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 	return writeok ? 0 : -EIO;
 }
 
-/**
- * eeprom_read - Read a byte from the ET1310's EEPROM
+/* eeprom_read - Read a byte from the ET1310's EEPROM
  * @adapter: pointer to our private adapter structure
  * @addr: the address from which to read
  * @pdata: a pointer to a byte in which to store the value of the read
@@ -727,16 +704,14 @@ static int eeprom_read(struct et131x_adapter *adapter, u32 addr, u8 *pdata)
 	int err;
 	u32 status;
 
-	/*
-	 * A single byte read is similar to the single byte write, with the
+	/* A single byte read is similar to the single byte write, with the
 	 * exception of the data flow:
 	 */
 
 	err = eeprom_wait_ready(pdev, NULL);
 	if (err)
 		return err;
-	/*
-	 * Write to the LBCIF Control Register:  bit 7=1, bit 6=0, bit 3=0,
+	/* Write to the LBCIF Control Register:  bit 7=1, bit 6=0, bit 3=0,
 	 * and bits 1:0 both =0.  Bit 5 should be set according to the type
 	 * of EEPROM being accessed (1=two byte addressing, 0=one byte
 	 * addressing).
@@ -744,27 +719,23 @@ static int eeprom_read(struct et131x_adapter *adapter, u32 addr, u8 *pdata)
 	if (pci_write_config_byte(pdev, LBCIF_CONTROL_REGISTER,
 				  LBCIF_CONTROL_LBCIF_ENABLE))
 		return -EIO;
-	/*
-	 * Write the address to the LBCIF Address Register (I2C read will
+	/* Write the address to the LBCIF Address Register (I2C read will
 	 * begin).
 	 */
 	if (pci_write_config_dword(pdev, LBCIF_ADDRESS_REGISTER, addr))
 		return -EIO;
-	/*
-	 * Monitor bit 0 of the LBCIF Status Register.  When = 1, I2C read
+	/* Monitor bit 0 of the LBCIF Status Register.  When = 1, I2C read
 	 * is complete. (if bit 1 =1 and bit 0 stays = 0, a hardware failure
 	 * has occurred).
 	 */
 	err = eeprom_wait_ready(pdev, &status);
 	if (err < 0)
 		return err;
-	/*
-	 * Regardless of error status, read data byte from LBCIF Data
+	/* Regardless of error status, read data byte from LBCIF Data
 	 * Register.
 	 */
 	*pdata = err;
-	/*
-	 * Check bit 2 of the LBCIF Status Register.  If = 1,
+	/* Check bit 2 of the LBCIF Status Register.  If = 1,
 	 * then an error has occurred.
 	 */
 	return (status & LBCIF_STATUS_ACK_ERROR) ? -EIO : 0;
@@ -838,8 +809,7 @@ static int et131x_init_eeprom(struct et131x_adapter *adapter)
 	return 0;
 }
 
-/**
- * et131x_rx_dma_enable - re-start of Rx_DMA on the ET1310.
+/* et131x_rx_dma_enable - re-start of Rx_DMA on the ET1310.
  * @adapter: pointer to our adapter structure
  */
 static void et131x_rx_dma_enable(struct et131x_adapter *adapter)
@@ -875,8 +845,7 @@ static void et131x_rx_dma_enable(struct et131x_adapter *adapter)
 	}
 }
 
-/**
- * et131x_rx_dma_disable - Stop of Rx_DMA on the ET1310
+/* et131x_rx_dma_disable - Stop of Rx_DMA on the ET1310
  * @adapter: pointer to our adapter structure
  */
 static void et131x_rx_dma_disable(struct et131x_adapter *adapter)
@@ -896,8 +865,7 @@ static void et131x_rx_dma_disable(struct et131x_adapter *adapter)
 	}
 }
 
-/**
- * et131x_tx_dma_enable - re-start of Tx_DMA on the ET1310.
+/* et131x_tx_dma_enable - re-start of Tx_DMA on the ET1310.
  * @adapter: pointer to our adapter structure
  *
  * Mainly used after a return to the D0 (full-power) state from a lower state.
@@ -921,8 +889,7 @@ static inline void add_12bit(u32 *v, int n)
 	*v = INDEX12(*v + n) | (*v & ET_DMA12_WRAP);
 }
 
-/**
- * et1310_config_mac_regs1 - Initialize the first part of MAC regs
+/* et1310_config_mac_regs1 - Initialize the first part of MAC regs
  * @adapter: pointer to our adapter structure
  */
 static void et1310_config_mac_regs1(struct et131x_adapter *adapter)
@@ -984,8 +951,7 @@ static void et1310_config_mac_regs1(struct et131x_adapter *adapter)
 	writel(0, &macregs->cfg1);
 }
 
-/**
- * et1310_config_mac_regs2 - Initialize the second part of MAC regs
+/* et1310_config_mac_regs2 - Initialize the second part of MAC regs
  * @adapter: pointer to our adapter structure
  */
 static void et1310_config_mac_regs2(struct et131x_adapter *adapter)
@@ -1026,7 +992,8 @@ static void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 
 	/* Now we need to initialize the MAC Configuration 2 register */
 	/* preamble 7, check length, huge frame off, pad crc, crc enable
-	   full duplex off */
+	 * full duplex off
+	 */
 	cfg2 |= 0x7 << ET_MAC_CFG2_PREAMBLE_SHIFT;
 	cfg2 |= ET_MAC_CFG2_IFMODE_LEN_CHECK;
 	cfg2 |= ET_MAC_CFG2_IFMODE_PAD_CRC;
@@ -1068,8 +1035,7 @@ static void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 	}
 }
 
-/**
- * et1310_in_phy_coma - check if the device is in phy coma
+/* et1310_in_phy_coma - check if the device is in phy coma
  * @adapter: pointer to our adapter structure
  *
  * Returns 0 if the device is not in phy coma, 1 if it is in phy coma
@@ -1383,8 +1349,7 @@ static void et1310_config_macstat_regs(struct et131x_adapter *adapter)
 	writel(0xFFFE7E8B, &macstat->carry_reg2_mask);
 }
 
-/**
- * et131x_phy_mii_read - Read from the PHY through the MII Interface on the MAC
+/* et131x_phy_mii_read - Read from the PHY through the MII Interface on the MAC
  * @adapter: pointer to our private adapter structure
  * @addr: the address of the transceiver
  * @reg: the register to read
@@ -1433,7 +1398,8 @@ static int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
 	}
 
 	/* If we hit here we were able to read the register and we need to
-	 * return the value to the caller */
+	 * return the value to the caller
+	 */
 	*value = readl(&mac->mii_mgmt_stat) & ET_MAC_MIIMGMT_STAT_PHYCRTL_MASK;
 
 	/* Stop the read operation */
@@ -1458,8 +1424,7 @@ static int et131x_mii_read(struct et131x_adapter *adapter, u8 reg, u16 *value)
 	return et131x_phy_mii_read(adapter, phydev->addr, reg, value);
 }
 
-/**
- * et131x_mii_write - Write to a PHY register through the MII interface of the MAC
+/* et131x_mii_write - Write to a PHY reg through the MII interface of the MAC
  * @adapter: pointer to our private adapter structure
  * @reg: the register to read
  * @value: 16-bit value to write
@@ -1523,8 +1488,7 @@ static int et131x_mii_write(struct et131x_adapter *adapter, u8 reg, u16 value)
 	/* Stop the write operation */
 	writel(0, &mac->mii_mgmt_cmd);
 
-	/*
-	 * set the registers we touched back to the state at which we entered
+	/* set the registers we touched back to the state at which we entered
 	 * this function
 	 */
 	writel(mii_addr, &mac->mii_mgmt_addr);
@@ -1590,7 +1554,8 @@ static void et1310_config_flow_control(struct et131x_adapter *adapter)
 			   (remote_async_pause == TRUEPHY_BIT_CLEAR)) {
 			adapter->flowcontrol = FLOW_NONE;
 		} else {/* if (remote_pause == TRUEPHY_CLEAR_BIT &&
-			       remote_async_pause == TRUEPHY_SET_BIT) */
+			 *     remote_async_pause == TRUEPHY_SET_BIT)
+			 */
 			if (adapter->wanted_flow == FLOW_BOTH)
 				adapter->flowcontrol = FLOW_RXONLY;
 			else
@@ -1599,8 +1564,7 @@ static void et1310_config_flow_control(struct et131x_adapter *adapter)
 	}
 }
 
-/**
- * et1310_update_macstat_host_counters - Update the local copy of the statistics
+/* et1310_update_macstat_host_counters - Update the local copy of the statistics
  * @adapter: pointer to the adapter structure
  */
 static void et1310_update_macstat_host_counters(struct et131x_adapter *adapter)
@@ -1627,8 +1591,7 @@ static void et1310_update_macstat_host_counters(struct et131x_adapter *adapter)
 	stats->rx_other_errs        += readl(&macstat->rx_fragment_packets);
 }
 
-/**
- * et1310_handle_macstat_interrupt
+/* et1310_handle_macstat_interrupt
  * @adapter: pointer to the adapter structure
  *
  * One of the MACSTAT counters has wrapped.  Update the local copy of
@@ -1719,8 +1682,7 @@ static int et131x_mdio_reset(struct mii_bus *bus)
 	return 0;
 }
 
-/**
- *	et1310_phy_power_down	-	PHY power control
+/*	et1310_phy_power_down	-	PHY power control
  *	@adapter: device to control
  *	@down: true for off/false for back on
  *
@@ -1740,8 +1702,7 @@ static void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
 	et131x_mii_write(adapter, MII_BMCR, data);
 }
 
-/**
- * et131x_xcvr_init - Init the phy if we are setting it into force mode
+/* et131x_xcvr_init - Init the phy if we are setting it into force mode
  * @adapter: pointer to our private adapter structure
  *
  */
@@ -1772,8 +1733,7 @@ static void et131x_xcvr_init(struct et131x_adapter *adapter)
 	}
 }
 
-/**
- * et131x_configure_global_regs	- configure JAGCore global regs
+/* et131x_configure_global_regs	- configure JAGCore global regs
  * @adapter: pointer to our adapter structure
  *
  * Used to configure the global registers on the JAGCore
@@ -1819,8 +1779,7 @@ static void et131x_configure_global_regs(struct et131x_adapter *adapter)
 	writel(0, &regs->watchdog_timer);
 }
 
-/**
- * et131x_config_rx_dma_regs - Start of Rx_DMA init sequence
+/* et131x_config_rx_dma_regs - Start of Rx_DMA init sequence
  * @adapter: pointer to our adapter structure
  */
 static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
@@ -1927,8 +1886,7 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	spin_unlock_irqrestore(&adapter->rcv_lock, flags);
 }
 
-/**
- * et131x_config_tx_dma_regs - Set up the tx dma section of the JAGCore.
+/* et131x_config_tx_dma_regs - Set up the tx dma section of the JAGCore.
  * @adapter: pointer to our private adapter structure
  *
  * Configure the transmit engine with the ring buffers we have created
@@ -1959,8 +1917,7 @@ static void et131x_config_tx_dma_regs(struct et131x_adapter *adapter)
 	adapter->tx_ring.send_idx = 0;
 }
 
-/**
- * et131x_adapter_setup - Set the adapter up as per cassini+ documentation
+/* et131x_adapter_setup - Set the adapter up as per cassini+ documentation
  * @adapter: pointer to our private adapter structure
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
@@ -1988,8 +1945,7 @@ static void et131x_adapter_setup(struct et131x_adapter *adapter)
 	et131x_xcvr_init(adapter);
 }
 
-/**
- * et131x_soft_reset - Issue a soft reset to the hardware, complete for ET1310
+/* et131x_soft_reset - Issue a soft reset to the hardware, complete for ET1310
  * @adapter: pointer to our private adapter structure
  */
 static void et131x_soft_reset(struct et131x_adapter *adapter)
@@ -2011,8 +1967,7 @@ static void et131x_soft_reset(struct et131x_adapter *adapter)
 	writel(0, &adapter->regs->mac.cfg1);
 }
 
-/**
- *	et131x_enable_interrupts	-	enable interrupt
+/*	et131x_enable_interrupts	-	enable interrupt
  *	@adapter: et131x device
  *
  *	Enable the appropriate interrupts on the ET131x according to our
@@ -2032,8 +1987,7 @@ static void et131x_enable_interrupts(struct et131x_adapter *adapter)
 	writel(mask, &adapter->regs->global.int_mask);
 }
 
-/**
- *	et131x_disable_interrupts	-	interrupt disable
+/*	et131x_disable_interrupts	-	interrupt disable
  *	@adapter: et131x device
  *
  *	Block all interrupts from the et131x device at the device itself
@@ -2044,8 +1998,7 @@ static void et131x_disable_interrupts(struct et131x_adapter *adapter)
 	writel(INT_MASK_DISABLE, &adapter->regs->global.int_mask);
 }
 
-/**
- * et131x_tx_dma_disable - Stop of Tx_DMA on the ET1310
+/* et131x_tx_dma_disable - Stop of Tx_DMA on the ET1310
  * @adapter: pointer to our adapter structure
  */
 static void et131x_tx_dma_disable(struct et131x_adapter *adapter)
@@ -2055,8 +2008,7 @@ static void et131x_tx_dma_disable(struct et131x_adapter *adapter)
 					&adapter->regs->txdma.csr);
 }
 
-/**
- * et131x_enable_txrx - Enable tx/rx queues
+/* et131x_enable_txrx - Enable tx/rx queues
  * @netdev: device to be enabled
  */
 static void et131x_enable_txrx(struct net_device *netdev)
@@ -2075,8 +2027,7 @@ static void et131x_enable_txrx(struct net_device *netdev)
 	netif_start_queue(netdev);
 }
 
-/**
- * et131x_disable_txrx - Disable tx/rx queues
+/* et131x_disable_txrx - Disable tx/rx queues
  * @netdev: device to be disabled
  */
 static void et131x_disable_txrx(struct net_device *netdev)
@@ -2094,8 +2045,7 @@ static void et131x_disable_txrx(struct net_device *netdev)
 	et131x_disable_interrupts(adapter);
 }
 
-/**
- * et131x_init_send - Initialize send data structures
+/* et131x_init_send - Initialize send data structures
  * @adapter: pointer to our private adapter structure
  */
 static void et131x_init_send(struct et131x_adapter *adapter)
@@ -2128,8 +2078,7 @@ static void et131x_init_send(struct et131x_adapter *adapter)
 	tx_ring->send_tail = NULL;
 }
 
-/**
- * et1310_enable_phy_coma - called when network cable is unplugged
+/* et1310_enable_phy_coma - called when network cable is unplugged
  * @adapter: pointer to our adapter structure
  *
  * driver receive an phy status change interrupt while in D0 and check that
@@ -2158,8 +2107,7 @@ static void et1310_enable_phy_coma(struct et131x_adapter *adapter)
 	/* Save the GbE PHY speed and duplex modes. Need to restore this
 	 * when cable is plugged back in
 	 */
-	/*
-	 * TODO - when PM is re-enabled, check if we need to
+	/* TODO - when PM is re-enabled, check if we need to
 	 * perform a similar task as this -
 	 * adapter->pdown_speed = adapter->ai_force_speed;
 	 * adapter->pdown_duplex = adapter->ai_force_duplex;
@@ -2183,8 +2131,7 @@ static void et1310_enable_phy_coma(struct et131x_adapter *adapter)
 	writel(pmcsr, &adapter->regs->global.pm_csr);
 }
 
-/**
- * et1310_disable_phy_coma - Disable the Phy Coma Mode
+/* et1310_disable_phy_coma - Disable the Phy Coma Mode
  * @adapter: pointer to our adapter structure
  */
 static void et1310_disable_phy_coma(struct et131x_adapter *adapter)
@@ -2230,9 +2177,10 @@ static inline u32 bump_free_buff_ring(u32 *free_buff_ring, u32 limit)
 	u32 tmp_free_buff_ring = *free_buff_ring;
 	tmp_free_buff_ring++;
 	/* This works for all cases where limit < 1024. The 1023 case
-	   works because 1023++ is 1024 which means the if condition is not
-	   taken but the carry of the bit into the wrap bit toggles the wrap
-	   value correctly */
+	 * works because 1023++ is 1024 which means the if condition is not
+	 * taken but the carry of the bit into the wrap bit toggles the wrap
+	 * value correctly
+	 */
 	if ((tmp_free_buff_ring & ET_DMA10_MASK) > limit) {
 		tmp_free_buff_ring &= ~ET_DMA10_MASK;
 		tmp_free_buff_ring ^= ET_DMA10_WRAP;
@@ -2243,8 +2191,7 @@ static inline u32 bump_free_buff_ring(u32 *free_buff_ring, u32 limit)
 	return tmp_free_buff_ring;
 }
 
-/**
- * et131x_rx_dma_memory_alloc
+/* et131x_rx_dma_memory_alloc
  * @adapter: pointer to our private adapter structure
  *
  * Returns 0 on success and errno on failure (as defined in errno.h)
@@ -2384,8 +2331,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	pr_info("Packet Status Ring %llx\n",
 		(unsigned long long) rx_ring->ps_ring_physaddr);
 
-	/*
-	 * NOTE : dma_alloc_coherent(), used above to alloc DMA regions,
+	/* NOTE : dma_alloc_coherent(), used above to alloc DMA regions,
 	 * ALWAYS returns SAC (32-bit) addresses. If DAC (64-bit) addresses
 	 * are ever returned, make sure the high part is retrieved here before
 	 * storing the adjusted address.
@@ -2411,8 +2357,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	return 0;
 }
 
-/**
- * et131x_rx_dma_memory_free - Free all memory allocated within this module.
+/* et131x_rx_dma_memory_free - Free all memory allocated within this module.
  * @adapter: pointer to our private adapter structure
  */
 static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
@@ -2499,8 +2444,7 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	rx_ring->num_ready_recv = 0;
 }
 
-/**
- * et131x_init_recv - Initialize receive data structures.
+/* et131x_init_recv - Initialize receive data structures.
  * @adapter: pointer to our private adapter structure
  *
  * Returns 0 on success and errno on failure (as defined in errno.h)
@@ -2537,8 +2481,7 @@ static int et131x_init_recv(struct et131x_adapter *adapter)
 	return 0;
 }
 
-/**
- * et131x_set_rx_dma_timer - Set the heartbeat timer according to line rate.
+/* et131x_set_rx_dma_timer - Set the heartbeat timer according to line rate.
  * @adapter: pointer to our adapter structure
  */
 static void et131x_set_rx_dma_timer(struct et131x_adapter *adapter)
@@ -2557,8 +2500,7 @@ static void et131x_set_rx_dma_timer(struct et131x_adapter *adapter)
 	}
 }
 
-/**
- * NICReturnRFD - Recycle a RFD and put it back onto the receive list
+/* NICReturnRFD - Recycle a RFD and put it back onto the receive list
  * @adapter: pointer to our adapter
  * @rfd: pointer to the RFD
  */
@@ -2618,8 +2560,7 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 	WARN_ON(rx_local->num_ready_recv > rx_local->num_rfd);
 }
 
-/**
- * nic_rx_pkts - Checks the hardware for available packets
+/* nic_rx_pkts - Checks the hardware for available packets
  * @adapter: pointer to our adapter
  *
  * Returns rfd, a pointer to our MPRFD.
@@ -2802,8 +2743,7 @@ out:
 	return rfd;
 }
 
-/**
- * et131x_handle_recv_interrupt - Interrupt handler for receive processing
+/* et131x_handle_recv_interrupt - Interrupt handler for receive processing
  * @adapter: pointer to our adapter
  *
  * Assumption, Rcv spinlock has been acquired.
@@ -2857,8 +2797,7 @@ static void et131x_handle_recv_interrupt(struct et131x_adapter *adapter)
 		adapter->rx_ring.unfinished_receives = false;
 }
 
-/**
- * et131x_tx_dma_memory_alloc
+/* et131x_tx_dma_memory_alloc
  * @adapter: pointer to our private adapter structure
  *
  * Returns 0 on success and errno on failure (as defined in errno.h).
@@ -2914,8 +2853,7 @@ static int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
 	return 0;
 }
 
-/**
- * et131x_tx_dma_memory_free - Free all memory allocated within this module
+/* et131x_tx_dma_memory_free - Free all memory allocated within this module
  * @adapter: pointer to our private adapter structure
  *
  * Returns 0 on success and errno on failure (as defined in errno.h).
@@ -2947,8 +2885,7 @@ static void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 	kfree(adapter->tx_ring.tcb_ring);
 }
 
-/**
- * nic_send_packet - NIC specific send handler for version B silicon.
+/* nic_send_packet - NIC specific send handler for version B silicon.
  * @adapter: pointer to our adapter
  * @tcb: pointer to struct tcb
  *
@@ -2996,7 +2933,8 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 			 */
 			if (skb_headlen(skb) <= 1514) {
 				/* Low 16bits are length, high is vlan and
-				   unused currently so zero */
+				 * unused currently so zero
+				 */
 				desc[frag].len_vlan = skb_headlen(skb);
 				dma_addr = dma_map_single(&adapter->pdev->dev,
 							  skb->data,
@@ -3126,8 +3064,7 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 	return 0;
 }
 
-/**
- * send_packet - Do the work to send a packet
+/* send_packet - Do the work to send a packet
  * @skb: the packet(s) to send
  * @adapter: a pointer to the device's private adapter structure
  *
@@ -3198,8 +3135,7 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *adapter)
 	return 0;
 }
 
-/**
- * et131x_send_packets - This function is called by the OS to send packets
+/* et131x_send_packets - This function is called by the OS to send packets
  * @skb: the packet(s) to send
  * @netdev:device on which to TX the above packet(s)
  *
@@ -3248,8 +3184,7 @@ static int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
 	return status;
 }
 
-/**
- * free_send_packet - Recycle a struct tcb
+/* free_send_packet - Recycle a struct tcb
  * @adapter: pointer to our adapter
  * @tcb: pointer to struct tcb
  *
@@ -3321,8 +3256,7 @@ static inline void free_send_packet(struct et131x_adapter *adapter,
 	WARN_ON(adapter->tx_ring.used < 0);
 }
 
-/**
- * et131x_free_busy_send_packets - Free and complete the stopped active sends
+/* et131x_free_busy_send_packets - Free and complete the stopped active sends
  * @adapter: pointer to our adapter
  *
  * Assumption - Send spinlock has been acquired
@@ -3365,8 +3299,7 @@ static void et131x_free_busy_send_packets(struct et131x_adapter *adapter)
 	adapter->tx_ring.used = 0;
 }
 
-/**
- * et131x_handle_send_interrupt - Interrupt handler for sending processing
+/* et131x_handle_send_interrupt - Interrupt handler for sending processing
  * @adapter: pointer to our adapter
  *
  * Re-claim the send resources, complete sends and get more to send from
@@ -3624,8 +3557,8 @@ static struct ethtool_ops et131x_ethtool_ops = {
 	.get_regs	= et131x_get_regs,
 	.get_link	= ethtool_op_get_link,
 };
-/**
- * et131x_hwaddr_init - set up the MAC Address on the ET1310
+
+/* et131x_hwaddr_init - set up the MAC Address on the ET1310
  * @adapter: pointer to our private adapter structure
  */
 static void et131x_hwaddr_init(struct et131x_adapter *adapter)
@@ -3635,14 +3568,12 @@ static void et131x_hwaddr_init(struct et131x_adapter *adapter)
 	 * device
 	 */
 	if (is_zero_ether_addr(adapter->rom_addr)) {
-		/*
-		 * We need to randomly generate the last octet so we
+		/* We need to randomly generate the last octet so we
 		 * decrease our chances of setting the mac address to
 		 * same as another one of our cards in the system
 		 */
 		get_random_bytes(&adapter->addr[5], 1);
-		/*
-		 * We have the default value in the register we are
+		/* We have the default value in the register we are
 		 * working with so we need to copy the current
 		 * address into the permanent address
 		 */
@@ -3658,8 +3589,7 @@ static void et131x_hwaddr_init(struct et131x_adapter *adapter)
 	}
 }
 
-/**
- * et131x_pci_init	 - initial PCI setup
+/* et131x_pci_init	 - initial PCI setup
  * @adapter: pointer to our private adapter structure
  * @pdev: our PCI device
  *
@@ -3751,8 +3681,7 @@ err_out:
 	goto out;
 }
 
-/**
- * et131x_error_timer_handler
+/* et131x_error_timer_handler
  * @data: timer-specific variable; here a pointer to our adapter structure
  *
  * The routine called when the error timer expires, to track the number of
@@ -3766,7 +3695,8 @@ static void et131x_error_timer_handler(unsigned long data)
 	if (et1310_in_phy_coma(adapter)) {
 		/* Bring the device immediately out of coma, to
 		 * prevent it from sleeping indefinitely, this
-		 * mechanism could be improved! */
+		 * mechanism could be improved!
+		 */
 		et1310_disable_phy_coma(adapter);
 		adapter->boot_coma = 20;
 	} else {
@@ -3792,8 +3722,7 @@ static void et131x_error_timer_handler(unsigned long data)
 	mod_timer(&adapter->error_timer, jiffies + TX_ERROR_PERIOD * HZ / 1000);
 }
 
-/**
- * et131x_adapter_memory_free - Free all memory allocated for use by Tx & Rx
+/* et131x_adapter_memory_free - Free all memory allocated for use by Tx & Rx
  * @adapter: pointer to our private adapter structure
  */
 static void et131x_adapter_memory_free(struct et131x_adapter *adapter)
@@ -3803,8 +3732,7 @@ static void et131x_adapter_memory_free(struct et131x_adapter *adapter)
 	et131x_rx_dma_memory_free(adapter);
 }
 
-/**
- * et131x_adapter_memory_alloc
+/* et131x_adapter_memory_alloc
  * @adapter: pointer to our private adapter structure
  *
  * Returns 0 on success, errno on failure (as defined in errno.h).
@@ -3847,8 +3775,7 @@ static void et131x_adjust_link(struct net_device *netdev)
 	struct  phy_device *phydev = adapter->phydev;
 
 	if (phydev && phydev->link != adapter->link) {
-		/*
-		 * Check to see if we are in coma mode and if
+		/* Check to see if we are in coma mode and if
 		 * so, disable it because we will not be able
 		 * to read PHY values until we are out.
 		 */
@@ -3861,8 +3788,7 @@ static void et131x_adjust_link(struct net_device *netdev)
 		if (phydev->link) {
 			adapter->boot_coma = 20;
 			if (phydev && phydev->speed == SPEED_10) {
-				/*
-				 * NOTE - Is there a way to query this without
+				/* NOTE - Is there a way to query this without
 				 * TruePHY?
 				 * && TRU_QueryCoreType(adapter->hTruePhy, 0)==
 				 * EMI_TRUEPHY_A13O) {
@@ -3924,8 +3850,7 @@ static void et131x_adjust_link(struct net_device *netdev)
 			/* Re-initialize the send structures */
 			et131x_init_send(adapter);
 
-			/*
-			 * Bring the device back to the state it was during
+			/* Bring the device back to the state it was during
 			 * init prior to autonegotiation being complete. This
 			 * way, when we get the auto-neg complete interrupt,
 			 * we can complete init by calling config_mac_regs2.
@@ -3955,7 +3880,7 @@ static int et131x_mii_probe(struct net_device *netdev)
 	}
 
 	phydev = phy_connect(netdev, dev_name(&phydev->dev),
-			&et131x_adjust_link, 0, PHY_INTERFACE_MODE_MII);
+			     &et131x_adjust_link, 0, PHY_INTERFACE_MODE_MII);
 
 	if (IS_ERR(phydev)) {
 		dev_err(&adapter->pdev->dev, "Could not attach to PHY\n");
@@ -3982,8 +3907,7 @@ static int et131x_mii_probe(struct net_device *netdev)
 	return 0;
 }
 
-/**
- * et131x_adapter_init
+/* et131x_adapter_init
  * @adapter: pointer to the private adapter struct
  * @pdev: pointer to the PCI device
  *
@@ -4020,8 +3944,7 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 	return adapter;
 }
 
-/**
- * et131x_pci_remove
+/* et131x_pci_remove
  * @pdev: a pointer to the device's pci_dev structure
  *
  * Registered in the pci_driver structure, this function is called when the
@@ -4048,8 +3971,7 @@ static void et131x_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-/**
- * et131x_up - Bring up a device for use.
+/* et131x_up - Bring up a device for use.
  * @netdev: device to be opened
  */
 static void et131x_up(struct net_device *netdev)
@@ -4060,8 +3982,7 @@ static void et131x_up(struct net_device *netdev)
 	phy_start(adapter->phydev);
 }
 
-/**
- * et131x_down - Bring down the device
+/* et131x_down - Bring down the device
  * @netdev: device to be brought down
  */
 static void et131x_down(struct net_device *netdev)
@@ -4110,8 +4031,7 @@ static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
 #define ET131X_PM_OPS NULL
 #endif
 
-/**
- * et131x_isr - The Interrupt Service Routine for the driver.
+/* et131x_isr - The Interrupt Service Routine for the driver.
  * @irq: the IRQ on which the interrupt was received.
  * @dev_id: device-specific info (here a pointer to a net_device struct)
  *
@@ -4199,8 +4119,7 @@ out:
 	return IRQ_RETVAL(handled);
 }
 
-/**
- * et131x_isr_handler - The ISR handler
+/* et131x_isr_handler - The ISR handler
  * @p_adapter, a pointer to the device's private adapter structure
  *
  * scheduled to run in a deferred context by the ISR. This is where the ISR's
@@ -4213,8 +4132,7 @@ static void et131x_isr_handler(struct work_struct *work)
 	u32 status = adapter->stats.interrupt_status;
 	struct address_map __iomem *iomem = adapter->regs;
 
-	/*
-	 * These first two are by far the most common.  Once handled, we clear
+	/* These first two are by far the most common.  Once handled, we clear
 	 * their two bits in the status word.  If the word is now zero, we
 	 * exit.
 	 */
@@ -4245,8 +4163,7 @@ static void et131x_isr_handler(struct work_struct *work)
 
 	/* Handle Free Buffer Ring 0 and 1 Low interrupt */
 	if (status & (ET_INTR_RXDMA_FB_R0_LOW | ET_INTR_RXDMA_FB_R1_LOW)) {
-		/*
-		 * This indicates the number of unused buffers in RXDMA free
+		/* This indicates the number of unused buffers in RXDMA free
 		 * buffer ring 0 is <= the limit you programmed. Free buffer
 		 * resources need to be returned.  Free buffers are consumed as
 		 * packets are passed from the network to the host. The host
@@ -4258,16 +4175,14 @@ static void et131x_isr_handler(struct work_struct *work)
 		 * method of returning resources.
 		 */
 
-		/*
-		 *  If the user has flow control on, then we will
+		/*  If the user has flow control on, then we will
 		 * send a pause packet, otherwise just exit
 		 */
 		if (adapter->flowcontrol == FLOW_TXONLY ||
 		    adapter->flowcontrol == FLOW_BOTH) {
 			u32 pm_csr;
 
-			/*
-			 * Tell the device to send a pause packet via the back
+			/* Tell the device to send a pause packet via the back
 			 * pressure register (bp req and bp xon/xoff)
 			 */
 			pm_csr = readl(&iomem->global.pm_csr);
@@ -4278,8 +4193,7 @@ static void et131x_isr_handler(struct work_struct *work)
 
 	/* Handle Packet Status Ring Low Interrupt */
 	if (status & ET_INTR_RXDMA_STAT_LOW) {
-		/*
-		 * Same idea as with the two Free Buffer Rings. Packets going
+		/* Same idea as with the two Free Buffer Rings. Packets going
 		 * from the network to the host each consume a free buffer
 		 * resource and a packet status resource. These resoures are
 		 * passed to the OS. When the OS is done with the resources,
@@ -4290,8 +4204,7 @@ static void et131x_isr_handler(struct work_struct *work)
 
 	/* Handle RXDMA Error Interrupt */
 	if (status & ET_INTR_RXDMA_ERR) {
-		/*
-		 * The rxdma_error interrupt is sent when a time-out on a
+		/* The rxdma_error interrupt is sent when a time-out on a
 		 * request issued by the JAGCore has occurred or a completion is
 		 * returned with an un-successful status. In both cases the
 		 * request is considered complete. The JAGCore will
@@ -4314,8 +4227,7 @@ static void et131x_isr_handler(struct work_struct *work)
 
 	/* Handle the Wake on LAN Event */
 	if (status & ET_INTR_WOL) {
-		/*
-		 * This is a secondary interrupt for wake on LAN. The driver
+		/* This is a secondary interrupt for wake on LAN. The driver
 		 * should never see this, if it does, something serious is
 		 * wrong. We will TRAP the message when we are in DBG mode,
 		 * otherwise we will ignore it.
@@ -4327,8 +4239,7 @@ static void et131x_isr_handler(struct work_struct *work)
 	if (status & ET_INTR_TXMAC) {
 		u32 err = readl(&iomem->txmac.err);
 
-		/*
-		 * When any of the errors occur and TXMAC generates an
+		/* When any of the errors occur and TXMAC generates an
 		 * interrupt to report these errors, it usually means that
 		 * TXMAC has detected an error in the data stream retrieved
 		 * from the on-chip Tx Q. All of these errors are catastrophic
@@ -4340,16 +4251,14 @@ static void et131x_isr_handler(struct work_struct *work)
 			 "TXMAC interrupt, error 0x%08x\n",
 			 err);
 
-		/*
-		 * If we are debugging, we want to see this error, otherwise we
+		/* If we are debugging, we want to see this error, otherwise we
 		 * just want the device to be reset and continue
 		 */
 	}
 
 	/* Handle RXMAC Interrupt */
 	if (status & ET_INTR_RXMAC) {
-		/*
-		 * These interrupts are catastrophic to the device, what we need
+		/* These interrupts are catastrophic to the device, what we need
 		 * to do is disable the interrupts and set the flag to cause us
 		 * to reset so we can solve this issue.
 		 */
@@ -4364,16 +4273,14 @@ static void et131x_isr_handler(struct work_struct *work)
 			 readl(&iomem->rxmac.ctrl),
 			 readl(&iomem->rxmac.rxq_diag));
 
-		/*
-		 * If we are debugging, we want to see this error, otherwise we
+		/* If we are debugging, we want to see this error, otherwise we
 		 * just want the device to be reset and continue
 		 */
 	}
 
 	/* Handle MAC_STAT Interrupt */
 	if (status & ET_INTR_MAC_STAT) {
-		/*
-		 * This means at least one of the un-masked counters in the
+		/* This means at least one of the un-masked counters in the
 		 * MAC_STAT block has rolled over. Use this to maintain the top,
 		 * software managed bits of the counter(s).
 		 */
@@ -4382,8 +4289,7 @@ static void et131x_isr_handler(struct work_struct *work)
 
 	/* Handle SLV Timeout Interrupt */
 	if (status & ET_INTR_SLV_TIMEOUT) {
-		/*
-		 * This means a timeout has occurred on a read or write request
+		/* This means a timeout has occurred on a read or write request
 		 * to one of the JAGCore registers. The Global Resources block
 		 * has terminated the request and on a read request, returned a
 		 * "fake" value. The most likely reasons are: Bad Address or the
@@ -4394,8 +4300,7 @@ out:
 	et131x_enable_interrupts(adapter);
 }
 
-/**
- * et131x_stats - Return the current device statistics.
+/* et131x_stats - Return the current device statistics.
  * @netdev: device whose stats are being queried
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
@@ -4441,8 +4346,7 @@ static struct net_device_stats *et131x_stats(struct net_device *netdev)
 	return stats;
 }
 
-/**
- * et131x_open - Open the device for use.
+/* et131x_open - Open the device for use.
  * @netdev: device to be opened
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
@@ -4475,8 +4379,7 @@ static int et131x_open(struct net_device *netdev)
 	return result;
 }
 
-/**
- * et131x_close - Close the device
+/* et131x_close - Close the device
  * @netdev: device to be closed
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
@@ -4494,8 +4397,7 @@ static int et131x_close(struct net_device *netdev)
 	return del_timer_sync(&adapter->error_timer);
 }
 
-/**
- * et131x_ioctl - The I/O Control handler for the driver
+/* et131x_ioctl - The I/O Control handler for the driver
  * @netdev: device on which the control request is being made
  * @reqbuf: a pointer to the IOCTL request buffer
  * @cmd: the IOCTL command code
@@ -4513,8 +4415,7 @@ static int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf,
 	return phy_mii_ioctl(adapter->phydev, reqbuf, cmd);
 }
 
-/**
- * et131x_set_packet_filter - Configures the Rx Packet filtering on the device
+/* et131x_set_packet_filter - Configures the Rx Packet filtering on the device
  * @adapter: pointer to our private adapter structure
  *
  * FIXME: lot of dups with MAC code
@@ -4542,8 +4443,7 @@ static int et131x_set_packet_filter(struct et131x_adapter *adapter)
 	if ((filter & ET131X_PACKET_TYPE_PROMISCUOUS) || filter == 0)
 		pf_ctrl &= ~7;	/* Clear filter bits */
 	else {
-		/*
-		 * Set us up with Multicast packet filtering.  Three cases are
+		/* Set us up with Multicast packet filtering.  Three cases are
 		 * possible - (1) we have a multi-cast list, (2) we receive ALL
 		 * multicast entries or (3) we receive none.
 		 */
@@ -4579,8 +4479,7 @@ static int et131x_set_packet_filter(struct et131x_adapter *adapter)
 	return status;
 }
 
-/**
- * et131x_multicast - The handler to configure multicasting on the interface
+/* et131x_multicast - The handler to configure multicasting on the interface
  * @netdev: a pointer to a net_device struct representing the device
  */
 static void et131x_multicast(struct net_device *netdev)
@@ -4649,8 +4548,7 @@ static void et131x_multicast(struct net_device *netdev)
 	spin_unlock_irqrestore(&adapter->lock, flags);
 }
 
-/**
- * et131x_tx - The handler to tx a packet on the device
+/* et131x_tx - The handler to tx a packet on the device
  * @skb: data to be Tx'd
  * @netdev: device on which data is to be Tx'd
  *
@@ -4682,8 +4580,7 @@ static int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
 	return status;
 }
 
-/**
- * et131x_tx_timeout - Timeout handler
+/* et131x_tx_timeout - Timeout handler
  * @netdev: a pointer to a net_device struct representing the device
  *
  * The handler called when a Tx request times out. The timeout period is
@@ -4741,8 +4638,7 @@ static void et131x_tx_timeout(struct net_device *netdev)
 	spin_unlock_irqrestore(&adapter->tcb_send_qlock, flags);
 }
 
-/**
- * et131x_change_mtu - The handler called to change the MTU for the device
+/* et131x_change_mtu - The handler called to change the MTU for the device
  * @netdev: device whose MTU is to be changed
  * @new_mtu: the desired MTU
  *
@@ -4792,8 +4688,7 @@ static int et131x_change_mtu(struct net_device *netdev, int new_mtu)
 	return result;
 }
 
-/**
- * et131x_set_mac_addr - handler to change the MAC address for the device
+/* et131x_set_mac_addr - handler to change the MAC address for the device
  * @netdev: device whose MAC is to be changed
  * @new_mac: the desired MAC address
  *
@@ -4866,8 +4761,7 @@ static const struct net_device_ops et131x_netdev_ops = {
 	.ndo_do_ioctl		= et131x_ioctl,
 };
 
-/**
- * et131x_pci_setup - Perform device initialization
+/* et131x_pci_setup - Perform device initialization
  * @pdev: a pointer to the device's pci_dev structure
  * @ent: this device's entry in the pci_device_id table
  *
-- 
1.7.10.4

