Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbaLCEZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 23:25:34 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:37952 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaLCEZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 23:25:33 -0500
From: Kevin Pietsch <kevinpietsch@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Kevin Pietsch <kevinpietsch@gmail.com>
Subject: [PATCH 1/1] Staging: ft1000: fix whitespace and brace coding style issues
Date: Tue,  2 Dec 2014 23:25:22 -0500
Message-Id: <1417580722-21899-1-git-send-email-kevinpietsch@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed braces from single line if, else, for statements.
Replaced space indents with tabs. Fixed whitespace errors around operators.

Signed-off-by: Kevin Pietsch <kevinpietsch@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 225 +++++++++--------------
 1 file changed, 90 insertions(+), 135 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 44575c7..444ea53 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -176,11 +176,10 @@ u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index)
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
@@ -208,11 +207,10 @@ static inline void ft1000_write_dpram_mag_16(struct net_device *dev,
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
 
@@ -337,18 +335,16 @@ static void ft1000_reset_asic(struct net_device *dev)
 	 * Let's use the register provided by the Magnemite ASIC to reset the
 	 * ASIC and DSP.
 	 */
-	if (info->AsicID == MAGNEMITE_ID) {
+	if (info->AsicID == MAGNEMITE_ID)
 		ft1000_write_reg(dev, FT1000_REG_RESET,
 				 (DSP_RESET_BIT | ASIC_RESET_BIT));
-	}
 	mdelay(1);
-	if (info->AsicID == ELECTRABUZZ_ID) {
+	if (info->AsicID == ELECTRABUZZ_ID)
 		/* set watermark to -1 in order to not generate an interrupt */
 		ft1000_write_reg(dev, FT1000_REG_WATERMARK, 0xffff);
-	} else {
+	else
 		/* set watermark to -1 in order to not generate an interrupt */
 		ft1000_write_reg(dev, FT1000_REG_MAG_WATERMARK, 0xffff);
-	}
 	/* clear interrupts */
 	tempword = ft1000_read_reg(dev, FT1000_REG_SUP_ISR);
 	DEBUG(1, "ft1000_hw: interrupt status register = 0x%x\n", tempword);
@@ -412,18 +408,16 @@ static int ft1000_reset_card(struct net_device *dev)
 		if (info->AsicID == ELECTRABUZZ_ID) {
 			ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
 					 FT1000_DPRAM_RX_BASE);
-			for (i = 0; i < MAX_DSP_SESS_REC; i++) {
+			for (i = 0; i < MAX_DSP_SESS_REC; i++)
 				info->DSPSess.Rec[i] =
 					ft1000_read_reg(dev,
 							FT1000_REG_DPRAM_DATA);
-			}
 		} else {
 			ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
 					 FT1000_DPRAM_MAG_RX_BASE);
-			for (i = 0; i < MAX_DSP_SESS_REC / 2; i++) {
+			for (i = 0; i < MAX_DSP_SESS_REC / 2; i++)
 				info->DSPSess.MagRec[i] =
 					inl(dev->base_addr + FT1000_REG_MAG_DPDATA);
-			}
 		}
 		spin_unlock_irqrestore(&info->dpram_lock, flags);
 	}
@@ -457,9 +451,8 @@ static int ft1000_reset_card(struct net_device *dev)
 			tempword =
 				ft1000_read_dpram_mag_16(dev, FT1000_MAG_DPRAM_FEFE,
 							 FT1000_MAG_DPRAM_FEFE_INDX);
-			if (tempword == 0xfefe) {
+			if (tempword == 0xfefe)
 				break;
-			}
 			mdelay(20);
 		}
 
@@ -478,9 +471,8 @@ static int ft1000_reset_card(struct net_device *dev)
 	if (card_download(dev, fw_entry->data, fw_entry->size)) {
 		DEBUG(1, "card download unsuccessful\n");
 		return false;
-	} else {
+	} else
 		DEBUG(1, "card download successful\n");
-	}
 
 	mdelay(10);
 
@@ -581,24 +573,21 @@ static void ft1000_hbchk(u_long data)
 
 	if (info->CardReady == 1) {
 		/* Perform dsp heartbeat check */
-		if (info->AsicID == ELECTRABUZZ_ID) {
+		if (info->AsicID == ELECTRABUZZ_ID)
 			tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
-		} else {
+		else
 			tempword =
 				ntohs(ft1000_read_dpram_mag_16
 				  (dev, FT1000_MAG_HI_HO,
 				   FT1000_MAG_HI_HO_INDX));
-		}
 		DEBUG(1, "ft1000_hw:ft1000_hbchk:hi_ho value = 0x%x\n",
 			  tempword);
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
 			printk(KERN_INFO
@@ -646,9 +635,8 @@ static void ft1000_hbchk(u_long data)
 
 		tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
 		/* Let's check doorbell again if fail */
-		if (tempword & FT1000_DB_HB) {
+		if (tempword & FT1000_DB_HB)
 			tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
-		}
 		if (tempword & FT1000_DB_HB) {
 			printk(KERN_INFO
 				   "ft1000: heartbeat doorbell not clear by firmware\n");
@@ -696,36 +684,30 @@ static void ft1000_hbchk(u_long data)
 		 * Set dedicated area to hi and ring appropriate doorbell according
 		 * to hi/ho heartbeat protocol
 		 */
-		if (info->AsicID == ELECTRABUZZ_ID) {
+		if (info->AsicID == ELECTRABUZZ_ID)
 			ft1000_write_dpram(dev, FT1000_HI_HO, hi);
-		} else {
+		else
 			ft1000_write_dpram_mag_16(dev, FT1000_MAG_HI_HO, hi_mag,
 						  FT1000_MAG_HI_HO_INDX);
-		}
 
-		if (info->AsicID == ELECTRABUZZ_ID) {
+		if (info->AsicID == ELECTRABUZZ_ID)
 			tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
-		} else {
+		else
 			tempword =
 				ntohs(ft1000_read_dpram_mag_16
 				  (dev, FT1000_MAG_HI_HO,
 				   FT1000_MAG_HI_HO_INDX));
-		}
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
 
@@ -799,9 +781,8 @@ static void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size,
 
 	size += sizeof(struct pseudo_hdr);
 	/* check for odd byte and increment to 16-bit word align value */
-	if ((size & 0x0001)) {
+	if ((size & 0x0001))
 		size++;
-	}
 	DEBUG(1, "FT1000:ft1000_send_cmd:total length = %d\n", size);
 	DEBUG(1, "FT1000:ft1000_send_cmd:length = %d\n", ntohs(*ptempbuffer));
 	/*
@@ -810,18 +791,18 @@ static void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size,
 	 */
 	spin_lock_irqsave(&info->dpram_lock, flags);
 
-    /* Make sure SLOWQ doorbell is clear */
-    tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
-    i=0;
-    while (tempword & FT1000_DB_DPRAM_TX) {
-        mdelay(10);
-        i++;
-        if (i==10) {
-            spin_unlock_irqrestore(&info->dpram_lock, flags);
-            return;
-        }
-        tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
-    }
+	/* Make sure SLOWQ doorbell is clear */
+	tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
+	i = 0;
+	while (tempword & FT1000_DB_DPRAM_TX) {
+		mdelay(10);
+		i++;
+		if (i == 10) {
+			spin_unlock_irqrestore(&info->dpram_lock, flags);
+			return;
+		}
+		tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
+	}
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
 		ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
@@ -887,14 +868,13 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 	u16 tempword;
 	unsigned long flags;
 
-	if (info->AsicID == ELECTRABUZZ_ID) {
+	if (info->AsicID == ELECTRABUZZ_ID)
 		size = ( ft1000_read_dpram(dev, *pnxtph) ) + sizeof(struct pseudo_hdr);
-	} else {
+	else
 		size =
 			ntohs(ft1000_read_dpram_mag_16
 			  (dev, FT1000_MAG_PH_LEN,
 			   FT1000_MAG_PH_LEN_INDX)) + sizeof(struct pseudo_hdr);
-	}
 	if (size > maxsz) {
 		DEBUG(1,
 			  "FT1000:ft1000_receive_cmd:Invalid command length = %d\n",
@@ -949,9 +929,8 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 		 * Calculate pseudo header checksum
 		 */
 		tempword = *ppseudohdr++;
-		for (i = 1; i < 7; i++) {
+		for (i = 1; i < 7; i++)
 			tempword ^= *ppseudohdr++;
-		}
 		if ((tempword != *ppseudohdr)) {
 			DEBUG(1,
 				  "FT1000:ft1000_receive_cmd:Pseudo header checksum mismatch\n");
@@ -992,14 +971,11 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 		u16 wrd;
 	} convert;
 
-    if (info->AsicID == ELECTRABUZZ_ID) {
-        tempword = FT1000_DPRAM_RX_BASE+2;
-    }
-    else {
-        tempword = FT1000_DPRAM_MAG_RX_BASE;
-    }
-    if ( ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword) ) {
-
+	if (info->AsicID == ELECTRABUZZ_ID)
+		tempword = FT1000_DPRAM_RX_BASE+2;
+	else
+		tempword = FT1000_DPRAM_MAG_RX_BASE;
+	if (ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword)) {
 		/* Get the message type which is total_len + PSEUDO header + msgtype + message body */
 		pdrvmsg = (struct drv_msg *) & cmdbuffer[0];
 		msgtype = ntohs(pdrvmsg->type);
@@ -1018,9 +994,8 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
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
@@ -1057,14 +1032,23 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 		case MEDIA_STATE:
 			pmediamsg = (struct media_msg *) & cmdbuffer[0];
 			if (info->ProgConStat != 0xFF) {
-			if (pmediamsg->state) {
-				DEBUG(1, "Media is up\n");
-				if (info->mediastate == 0) {
-					netif_carrier_on(dev);
-					netif_wake_queue(dev);
-					info->mediastate = 1;
-					do_gettimeofday(&tv);
-					info->ConTm = tv.tv_sec;
+				if (pmediamsg->state) {
+					DEBUG(1, "Media is up\n");
+					if (info->mediastate == 0) {
+						netif_carrier_on(dev);
+						netif_wake_queue(dev);
+						info->mediastate = 1;
+						do_gettimeofday(&tv);
+						info->ConTm = tv.tv_sec;
+					}
+				} else {
+					DEBUG(1, "Media is down\n");
+					if (info->mediastate == 1) {
+						info->mediastate = 0;
+						netif_carrier_off(dev);
+						netif_stop_queue(dev);
+						info->ConTm = 0;
+					}
 				}
 			} else {
 				DEBUG(1, "Media is down\n");
@@ -1075,16 +1059,6 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 					info->ConTm = 0;
 				}
 			}
-            }
-            else {
-                DEBUG(1, "Media is down\n");
-                if (info->mediastate == 1) {
-                    info->mediastate = 0;
-                    netif_carrier_off(dev);
-                    netif_stop_queue(dev);
-                    info->ConTm = 0;
-                }
-            }
 			break;
 		case DSP_INIT_MSG:
 			pdspinitmsg = (struct dsp_init_msg *) & cmdbuffer[0];
@@ -1142,9 +1116,8 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				mdelay(10);
 				tempword =
 					ft1000_read_reg(dev, FT1000_REG_DOORBELL);
-				if (tempword & FT1000_DB_DPRAM_TX) {
+				if (tempword & FT1000_DB_DPRAM_TX)
 					mdelay(10);
-				}
 			}
 
 			if ((tempword & FT1000_DB_DPRAM_TX) == 0) {
@@ -1171,9 +1144,8 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
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
@@ -1193,9 +1165,8 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				mdelay(10);
 				tempword =
 					ft1000_read_reg(dev, FT1000_REG_DOORBELL);
-				if (tempword & FT1000_DB_DPRAM_TX) {
+				if (tempword & FT1000_DB_DPRAM_TX)
 					mdelay(10);
-				}
 			}
 
 			if ((tempword & FT1000_DB_DPRAM_TX) == 0) {
@@ -1220,10 +1191,9 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				/* Insert application id */
 				ppseudo_hdr->portsrc = 0;
 				/* Calculate new checksum */
-                ppseudo_hdr->checksum = *pmsg++;
-                for (i=1; i<7; i++) {
-                    ppseudo_hdr->checksum ^= *pmsg++;
-                }
+				ppseudo_hdr->checksum = *pmsg++;
+				for (i = 1; i < 7; i++)
+					ppseudo_hdr->checksum ^= *pmsg++;
 				pmsg = (u16 *) & tempbuffer[16];
 				*pmsg++ = htons(RSP_DRV_ERR_RPT_MSG);
 				*pmsg++ = htons(0x000e);
@@ -1303,11 +1273,10 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 		ft1000_write_reg(dev, FT1000_REG_DOORBELL,
 				 FT1000_ASIC_RESET_DSP);
 
-		if (info->AsicID == MAGNEMITE_ID) {
+		if (info->AsicID == MAGNEMITE_ID)
 			/* Setting MAGNEMITE ASIC to big endian mode */
 			ft1000_write_reg(dev, FT1000_REG_SUP_CTRL,
 					 HOST_INTF_BE);
-		}
 	}
 
 	if (doorbell & FT1000_DSP_ASIC_RESET) {
@@ -1335,8 +1304,8 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 		DEBUG(1, "FT1000:ft1000_parse_dpram_msg:total length = %d\n",
 			  total_len);
 		if ((total_len < MAX_CMD_SQSIZE) && (total_len > sizeof(struct pseudo_hdr))) {
-            total_len += nxtph;
-            cnt = 0;
+			total_len += nxtph;
+			cnt = 0;
 			/*
 			 * ft1000_read_reg will return a value that needs to be byteswap
 			 * in order to get DSP_QID_OFFSET.
@@ -1355,10 +1324,9 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 			}
 			DEBUG(1, "DSP_QID = 0x%x\n", portid);
 
-			if (portid == DRIVERID) {
+			if (portid == DRIVERID)
 				/* We are assumming one driver message from the DSP at a time. */
 				ft1000_proc_drvmsg(dev);
-			}
 		}
 		ft1000_write_reg(dev, FT1000_REG_DOORBELL, FT1000_DB_DPRAM_RX);
 	}
@@ -1515,18 +1483,17 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 					tempword =
 						inw(dev->base_addr +
 						FT1000_REG_SUP_IMASK);
-					if (tempword == 0) {
+					if (tempword == 0)
 						/* This indicates that we can not communicate with the ASIC */
 						info->DrvErrNum =
 							FIFO_FLUSH_BADCNT;
-					} else {
+					else {
 						/* Let's assume that we really flush the FIFO */
 						pcmcia->PktIntfErr++;
 						return;
 					}
-				} else {
+				} else
 					info->DrvErrNum = FIFO_FLUSH_MAXLIMIT;
-				}
 				return;
 			}
 			tempword = inw(dev->base_addr + FT1000_REG_SUP_STAT);
@@ -1551,9 +1518,8 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 			tempword = inw(dev->base_addr + FT1000_REG_MAG_DFSR);
 			DEBUG(0, "FT1000_REG_MAG_DFSR = 0x%x\n", tempword);
 		}
-		if (DrvErrNum) {
+		if (DrvErrNum)
 			pcmcia->PktIntfErr++;
-		}
 	}
 }
 
@@ -1611,9 +1577,8 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 	if (skb == NULL) {
 		DEBUG(0, "No Network buffers available\n");
 		/* Read High word to complete 32 bit access */
-		if (info->AsicID == MAGNEMITE_ID) {
+		if (info->AsicID == MAGNEMITE_ID)
 			tempword = ft1000_read_reg(dev, FT1000_REG_MAG_DFRH);
-		}
 		ft1000_flush_fifo(dev, 0);
 		info->stats.rx_errors++;
 		return FAILURE;
@@ -1717,9 +1682,8 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 	}
 
 	DEBUG(1, "Data passed to Protocol layer:\n");
-	for (i = 0; i < len + 12; i++) {
+	for (i = 0; i < len + 12; i++)
 		DEBUG(1, "Protocol Data: 0x%x\n ", *ptemp++);
-	}
 
 	skb->dev = dev;
 	skb->protocol = eth_type_trans(skb, dev);
@@ -1775,21 +1739,16 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
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
 			DEBUG(1,
 				  "ft1000_hw:ft1000_copy_down_pkt:Transmit FIFO is fulli - pkt drop\n");
@@ -1798,11 +1757,10 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
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
@@ -1815,9 +1773,8 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
 	pseudo.blk.qos_class = 0;
 	/* Calculate pseudo header checksum */
 	pseudo.blk.checksum = pseudo.buff[0];
-	for (i = 1; i < 7; i++) {
+	for (i = 1; i < 7; i++)
 		pseudo.blk.checksum ^= pseudo.buff[i];
-	}
 
 	/* Production Mode */
 	if (info->AsicID == ELECTRABUZZ_ID) {
@@ -1899,9 +1856,8 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
 
 		plong = (u32 *) packet;
 		/* Write PPP type + IP Packet into Downlink FIFO */
-		for (i = 0; i < (len >> 2); i++) {
+		for (i = 0; i < (len >> 2); i++)
 			outl(*plong++, dev->base_addr + FT1000_REG_MAG_UFDR);
-		}
 
 		/* Check for odd alignment */
 		if (len & 0x0003) {
@@ -2047,11 +2003,10 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
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

