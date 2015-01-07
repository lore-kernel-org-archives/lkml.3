Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbbAGH1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:27:46 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52711 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbbAGH1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:27:45 -0500
From: Arjun AK <arjunak234@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        Arjun AK <arjunak234@gmail.com>
Subject: [PATCH] staging: ft1000: Fix code style issue
Date: Wed,  7 Jan 2015 12:57:05 +0530
Message-Id: <1420615625-25738-1-git-send-email-arjunak234@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary braces from single statement blocks.

Signed-off-by: Arjun AK <arjunak234@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 101 ++++++++---------------
 1 file changed, 35 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index e9a37ee..809e32c 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -172,11 +172,10 @@ u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index)
 	spin_lock_irqsave(&info->dpram_lock, flags);
 	ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR, offset);
 	/* check if we want to read upper or lower 32-bit word */
-	if (Index) {
+	if (Index)
 		data = ft1000_read_reg(dev, FT1000_REG_MAG_DPDATAL);
-	} else {
+	else
 		data = ft1000_read_reg(dev, FT1000_REG_MAG_DPDATAH);
-	}
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
 
 	return data;
@@ -204,11 +203,10 @@ static inline void ft1000_write_dpram_mag_16(struct net_device *dev,
 	/* Provide mutual exclusive access while reading ASIC registers. */
 	spin_lock_irqsave(&info->dpram_lock, flags);
 	ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR, offset);
-	if (Index) {
+	if (Index)
 		ft1000_write_reg(dev, FT1000_REG_MAG_DPDATAL, value);
-	} else {
+	else
 		ft1000_write_reg(dev, FT1000_REG_MAG_DPDATAH, value);
-	}
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
 }
 
@@ -440,9 +438,8 @@ static int ft1000_reset_card(struct net_device *dev)
 			tempword =
 				ft1000_read_dpram_mag_16(dev, FT1000_MAG_DPRAM_FEFE,
 							 FT1000_MAG_DPRAM_FEFE_INDX);
-			if (tempword == 0xfefe) {
+			if (tempword == 0xfefe)
 				break;
-			}
 			mdelay(20);
 		}
 
@@ -570,12 +567,10 @@ static void ft1000_hbchk(u_long data)
 		pr_debug("hi_ho value = 0x%x\n", tempword);
 		/* Let's perform another check if ho is not detected */
 		if (tempword != ho) {
-			if (info->AsicID == ELECTRABUZZ_ID) {
+			if (info->AsicID == ELECTRABUZZ_ID)
 				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
-			}
-			else {
+			else
 				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
-			}
 		}
 		if (tempword != ho) {
 			pr_info("heartbeat failed - no ho detected\n");
@@ -621,9 +616,8 @@ static void ft1000_hbchk(u_long data)
 
 		tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
 		/* Let's check doorbell again if fail */
-		if (tempword & FT1000_DB_HB) {
+		if (tempword & FT1000_DB_HB)
 			tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
-		}
 		if (tempword & FT1000_DB_HB) {
 			pr_info("heartbeat doorbell not clear by firmware\n");
 			if (info->AsicID == ELECTRABUZZ_ID) {
@@ -686,19 +680,15 @@ static void ft1000_hbchk(u_long data)
 		}
 		/* Let's write hi again if fail */
 		if (tempword != hi) {
-			if (info->AsicID == ELECTRABUZZ_ID) {
+			if (info->AsicID == ELECTRABUZZ_ID)
 				ft1000_write_dpram(dev, FT1000_HI_HO, hi);
-			}
-			else {
+			else
 				ft1000_write_dpram_mag_16(dev, FT1000_MAG_HI_HO, hi_mag, FT1000_MAG_HI_HO_INDX);
-			}
 
-			if (info->AsicID == ELECTRABUZZ_ID) {
+			if (info->AsicID == ELECTRABUZZ_ID)
 				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
-			}
-			else {
+			else
 				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
-			}
 
 		}
 
@@ -770,9 +760,8 @@ static void ft1000_send_cmd(struct net_device *dev, u16 *ptempbuffer, int size,
 
 	size += sizeof(struct pseudo_hdr);
 	/* check for odd byte and increment to 16-bit word align value */
-	if ((size & 0x0001)) {
+	if ((size & 0x0001))
 		size++;
-	}
 	pr_debug("total length = %d\n", size);
 	pr_debug("length = %d\n", ntohs(*ptempbuffer));
 	/*
@@ -915,9 +904,8 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 		 * Calculate pseudo header checksum
 		 */
 		tempword = *ppseudohdr++;
-		for (i = 1; i < 7; i++) {
+		for (i = 1; i < 7; i++)
 			tempword ^= *ppseudohdr++;
-		}
 		if ((tempword != *ppseudohdr)) {
 			pr_debug("Pseudo header checksum mismatch\n");
 			/* Drop this message */
@@ -957,12 +945,10 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 		u16 wrd;
 	} convert;
 
-	if (info->AsicID == ELECTRABUZZ_ID) {
+	if (info->AsicID == ELECTRABUZZ_ID)
 		tempword = FT1000_DPRAM_RX_BASE+2;
-	}
-	else {
+	else
 		tempword = FT1000_DPRAM_MAG_RX_BASE;
-	}
 	if (ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword)) {
 
 		/* Get the message type which is total_len + PSEUDO header + msgtype + message body */
@@ -982,9 +968,8 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				while (tempword & FT1000_DB_DPRAM_TX) {
 					mdelay(5);
 					i++;
-					if (i == 10) {
+					if (i == 10)
 						break;
-					}
 				}
 				ptr =
 					list_entry(info->prov_list.next,
@@ -1105,9 +1090,8 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				mdelay(10);
 				tempword =
 					ft1000_read_reg(dev, FT1000_REG_DOORBELL);
-				if (tempword & FT1000_DB_DPRAM_TX) {
+				if (tempword & FT1000_DB_DPRAM_TX)
 					mdelay(10);
-				}
 			}
 
 			if ((tempword & FT1000_DB_DPRAM_TX) == 0) {
@@ -1134,9 +1118,8 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				ppseudo_hdr->portsrc = 0;
 				/* Calculate new checksum */
 				ppseudo_hdr->checksum = *pmsg++;
-				for (i = 1; i < 7; i++) {
+				for (i = 1; i < 7; i++)
 					ppseudo_hdr->checksum ^= *pmsg++;
-				}
 				info->DSPInfoBlk[8] = 0x7200;
 				info->DSPInfoBlk[9] =
 					htons(info->DSPInfoBlklen);
@@ -1156,9 +1139,8 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				mdelay(10);
 				tempword =
 					ft1000_read_reg(dev, FT1000_REG_DOORBELL);
-				if (tempword & FT1000_DB_DPRAM_TX) {
+				if (tempword & FT1000_DB_DPRAM_TX)
 					mdelay(10);
-				}
 			}
 
 			if ((tempword & FT1000_DB_DPRAM_TX) == 0) {
@@ -1184,9 +1166,8 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				ppseudo_hdr->portsrc = 0;
 				/* Calculate new checksum */
 				ppseudo_hdr->checksum = *pmsg++;
-				for (i = 1; i < 7; i++) {
+				for (i = 1; i < 7; i++)
 					ppseudo_hdr->checksum ^= *pmsg++;
-				}
 				pmsg = (u16 *)&tempbuffer[16];
 				*pmsg++ = htons(RSP_DRV_ERR_RPT_MSG);
 				*pmsg++ = htons(0x000e);
@@ -1508,9 +1489,8 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 			tempword = inw(dev->base_addr + FT1000_REG_MAG_DFSR);
 			pr_debug("FT1000_REG_MAG_DFSR = 0x%x\n", tempword);
 		}
-		if (DrvErrNum) {
+		if (DrvErrNum)
 			pcmcia->PktIntfErr++;
-		}
 	}
 }
 
@@ -1567,9 +1547,8 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 	if (skb == NULL) {
 		pr_debug("No Network buffers available\n");
 		/* Read High word to complete 32 bit access */
-		if (info->AsicID == MAGNEMITE_ID) {
+		if (info->AsicID == MAGNEMITE_ID)
 			tempword = ft1000_read_reg(dev, FT1000_REG_MAG_DFRH);
-		}
 		ft1000_flush_fifo(dev, 0);
 		info->stats.rx_errors++;
 		return FAILURE;
@@ -1673,9 +1652,8 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 	}
 
 	pr_debug("Data passed to Protocol layer:\n");
-	for (i = 0; i < len + 12; i++) {
+	for (i = 0; i < len + 12; i++)
 		pr_debug("Protocol Data: 0x%x\n", *ptemp++);
-	}
 
 	skb->dev = dev;
 	skb->protocol = eth_type_trans(skb, dev);
@@ -1729,21 +1707,16 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 	/* Check if there is room on the FIFO */
 	if (len > ft1000_read_fifo_len(dev)) {
 		udelay(10);
-		if (len > ft1000_read_fifo_len(dev)) {
+		if (len > ft1000_read_fifo_len(dev))
 			udelay(20);
-		}
-		if (len > ft1000_read_fifo_len(dev)) {
+		if (len > ft1000_read_fifo_len(dev))
 			udelay(20);
-		}
-		if (len > ft1000_read_fifo_len(dev)) {
+		if (len > ft1000_read_fifo_len(dev))
 			udelay(20);
-		}
-		if (len > ft1000_read_fifo_len(dev)) {
+		if (len > ft1000_read_fifo_len(dev))
 			udelay(20);
-		}
-		if (len > ft1000_read_fifo_len(dev)) {
+		if (len > ft1000_read_fifo_len(dev))
 			udelay(20);
-		}
 		if (len > ft1000_read_fifo_len(dev)) {
 			pr_debug("Transmit FIFO is full - pkt drop\n");
 			info->stats.tx_errors++;
@@ -1751,11 +1724,10 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 		}
 	}
 	/* Create pseudo header and send pseudo/ip to hardware */
-	if (info->AsicID == ELECTRABUZZ_ID) {
+	if (info->AsicID == ELECTRABUZZ_ID)
 		pseudo.blk.length = len;
-	} else {
+	else
 		pseudo.blk.length = ntohs(len);
-	}
 	pseudo.blk.source = DSPID;	/* Need to swap to get in correct order */
 	pseudo.blk.destination = HOSTID;
 	pseudo.blk.portdest = NETWORKID;	/* Need to swap to get in correct order */
@@ -1768,9 +1740,8 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 	pseudo.blk.qos_class = 0;
 	/* Calculate pseudo header checksum */
 	pseudo.blk.checksum = pseudo.buff[0];
-	for (i = 1; i < 7; i++) {
+	for (i = 1; i < 7; i++)
 		pseudo.blk.checksum ^= pseudo.buff[i];
-	}
 
 	/* Production Mode */
 	if (info->AsicID == ELECTRABUZZ_ID) {
@@ -1835,9 +1806,8 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 
 		plong = (u32 *)packet;
 		/* Write PPP type + IP Packet into Downlink FIFO */
-		for (i = 0; i < (len >> 2); i++) {
+		for (i = 0; i < (len >> 2); i++)
 			outl(*plong++, dev->base_addr + FT1000_REG_MAG_UFDR);
-		}
 
 		/* Check for odd alignment */
 		if (len & 0x0003) {
@@ -1969,11 +1939,10 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 						ft1000_read_reg(dev,
 								FT1000_REG_MAG_DFSR);
 				}
-				if (tempword & 0x1f) {
+				if (tempword & 0x1f)
 					ft1000_copy_up_pkt(dev);
-				} else {
+				else
 					break;
-				}
 				cnt++;
 			} while (cnt < MAX_RCV_LOOP);
 
-- 
2.1.0

