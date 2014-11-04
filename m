Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaKDA0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:26:22 -0500
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:34639 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751176AbaKDA0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:26:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:69:355:379:541:960:966:968:973:982:988:989:1087:1260:1345:1359:1437:1605:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2559:2562:2693:2734:2892:2895:2896:2899:2901:2902:2904:2923:2924:2925:2926:3138:3139:3140:3141:3142:3743:3865:3866:3867:3868:3870:3871:3872:4250:4321:4384:4385:4395:4423:4605:4647:5007:6238:6261:6690:7208:7875:7903:7904:8603:8660:8829:8957:9010:9121:9165:9592:10004:10226:10848:10946:11026:11232:11233:11657:11914:12043:12050:12291:12294:12296:12438:12517:12519:12555:12679:12683:12707:12737:12740:13138:13148:13230:13231:13972:14394:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: balls99_6fe054b49131c
X-Filterd-Recvd-Size: 108741
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH V2 2/2] ASoC: staging: ft1000: Logging message neatening
Date: Mon,  3 Nov 2014 16:25:44 -0800
Message-Id: <a7140e598b199bbc7cb93d0a62d7e6240aa563c2.1415060503.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141104000656.GA17825@kroah.com>
References: <20141104000656.GA17825@kroah.com>
In-Reply-To: <cover.1415060503.git.joe@perches.com>
References: <cover.1415060503.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more common logging style.

o Convert DEBUG macros to pr_debug
o Add pr_fmt
o Remove embedded function names from pr_debug
o Convert printks to pr_<level>
o Coalesce formats and align arguments
o Add missing terminating newlines

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |   6 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   | 340 ++++++++-------------
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   | 136 ++++-----
 .../staging/ft1000/ft1000-usb/ft1000_download.c    | 138 ++++-----
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      | 194 +++++-------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |  85 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   2 -
 7 files changed, 383 insertions(+), 518 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index deb1256..1150050 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -20,6 +20,8 @@
 
   ---------------------------------------------------------------------------*/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define __KERNEL_SYSCALLS__
 
 #include <linux/module.h>
@@ -316,7 +318,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 
 	file_version = *(long *)pFileStart;
 	if (file_version != 6) {
-		printk(KERN_ERR "ft1000: unsupported firmware version %ld\n", file_version);
+		pr_err("unsupported firmware version %ld\n", file_version);
 		Status = FAILURE;
 	}
 
@@ -688,7 +690,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 				uiState = STATE_SECTION_PROV;
 			} else {
 				netdev_dbg(dev,
-					   "FT1000:download:Download error: Bad Port IDs in Pseudo Record\n");
+					   "Download error: Bad Port IDs in Pseudo Record\n");
 				netdev_dbg(dev, "\t Port Source = 0x%2.2x\n",
 					   pHdr->portsrc);
 				netdev_dbg(dev, "\t Port Destination = 0x%2.2x\n",
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index c6bee28..11dbe36 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -17,6 +17,8 @@
   Suite 330, Boston, MA 02111-1307, USA.
   -------------------------------------------------------------------------*/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -44,12 +46,6 @@
 #include <pcmcia/cisreg.h>
 #include <pcmcia/ds.h>
 
-#ifdef FT_DEBUG
-#define DEBUG(n, args...) printk(KERN_DEBUG args);
-#else
-#define DEBUG(n, args...)
-#endif
-
 #include <linux/delay.h>
 #include "ft1000.h"
 
@@ -282,12 +278,9 @@ static void ft1000_enable_interrupts(struct net_device *dev)
 {
 	u16 tempword;
 
-	DEBUG(1, "ft1000_hw:ft1000_enable_interrupts()\n");
 	ft1000_write_reg(dev, FT1000_REG_SUP_IMASK, ISR_DEFAULT_MASK);
 	tempword = ft1000_read_reg(dev, FT1000_REG_SUP_IMASK);
-	DEBUG(1,
-	      "ft1000_hw:ft1000_enable_interrupts:current interrupt enable mask = 0x%x\n",
-	      tempword);
+	pr_debug("current interrupt enable mask = 0x%x\n", tempword);
 }
 
 /*---------------------------------------------------------------------------
@@ -304,12 +297,9 @@ static void ft1000_disable_interrupts(struct net_device *dev)
 {
 	u16 tempword;
 
-	DEBUG(1, "ft1000_hw: ft1000_disable_interrupts()\n");
 	ft1000_write_reg(dev, FT1000_REG_SUP_IMASK, ISR_MASK_ALL);
 	tempword = ft1000_read_reg(dev, FT1000_REG_SUP_IMASK);
-	DEBUG(1,
-	      "ft1000_hw:ft1000_disable_interrupts:current interrupt enable mask = 0x%x\n",
-	      tempword);
+	pr_debug("current interrupt enable mask = 0x%x\n", tempword);
 }
 
 /*---------------------------------------------------------------------------
@@ -329,8 +319,6 @@ static void ft1000_reset_asic(struct net_device *dev)
 	struct ft1000_pcmcia *pcmcia = info->priv;
 	u16 tempword;
 
-	DEBUG(1, "ft1000_hw:ft1000_reset_asic called\n");
-
 	(*info->ft1000_reset) (pcmcia->link);
 
 	/*
@@ -351,10 +339,10 @@ static void ft1000_reset_asic(struct net_device *dev)
 	}
 	/* clear interrupts */
 	tempword = ft1000_read_reg(dev, FT1000_REG_SUP_ISR);
-	DEBUG(1, "ft1000_hw: interrupt status register = 0x%x\n", tempword);
+	pr_debug("interrupt status register = 0x%x\n", tempword);
 	ft1000_write_reg(dev, FT1000_REG_SUP_ISR, tempword);
 	tempword = ft1000_read_reg(dev, FT1000_REG_SUP_ISR);
-	DEBUG(1, "ft1000_hw: interrupt status register = 0x%x\n", tempword);
+	pr_debug("interrupt status register = 0x%x\n", tempword);
 
 }
 
@@ -377,8 +365,6 @@ static int ft1000_reset_card(struct net_device *dev)
 	unsigned long flags;
 	struct prov_record *ptr;
 
-	DEBUG(1, "ft1000_hw:ft1000_reset_card called.....\n");
-
 	info->CardReady = 0;
 	info->ProgConStat = 0;
 	info->squeseqnum = 0;
@@ -388,8 +374,7 @@ static int ft1000_reset_card(struct net_device *dev)
 
 	/* Make sure we free any memory reserve for provisioning */
 	while (list_empty(&info->prov_list) == 0) {
-		DEBUG(0,
-		      "ft1000_hw:ft1000_reset_card:deleting provisioning record\n");
+		pr_debug("deleting provisioning record\n");
 		ptr = list_entry(info->prov_list.next, struct prov_record, list);
 		list_del(&ptr->list);
 		kfree(ptr->pprov_data);
@@ -397,11 +382,10 @@ static int ft1000_reset_card(struct net_device *dev)
 	}
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
-		DEBUG(1, "ft1000_hw:ft1000_reset_card:resetting DSP\n");
+		pr_debug("resetting DSP\n");
 		ft1000_write_reg(dev, FT1000_REG_RESET, DSP_RESET_BIT);
 	} else {
-		DEBUG(1,
-		      "ft1000_hw:ft1000_reset_card:resetting ASIC and DSP\n");
+		pr_debug("resetting ASIC and DSP\n");
 		ft1000_write_reg(dev, FT1000_REG_RESET,
 				 (DSP_RESET_BIT | ASIC_RESET_BIT));
 	}
@@ -428,17 +412,16 @@ static int ft1000_reset_card(struct net_device *dev)
 		spin_unlock_irqrestore(&info->dpram_lock, flags);
 	}
 
-	DEBUG(1, "ft1000_hw:ft1000_reset_card:resetting ASIC\n");
+	pr_debug("resetting ASIC\n");
 	mdelay(10);
 	/* reset ASIC */
 	ft1000_reset_asic(dev);
 
-	DEBUG(1, "ft1000_hw:ft1000_reset_card:downloading dsp image\n");
+	pr_debug("downloading dsp image\n");
 
 	if (info->AsicID == MAGNEMITE_ID) {
 		/* Put dsp in reset and take ASIC out of reset */
-		DEBUG(0,
-		      "ft1000_hw:ft1000_reset_card:Put DSP in reset and take ASIC out of reset\n");
+		pr_debug("Put DSP in reset and take ASIC out of reset\n");
 		ft1000_write_reg(dev, FT1000_REG_RESET, DSP_RESET_BIT);
 
 		/* Setting MAGNEMITE ASIC to big endian mode */
@@ -450,7 +433,7 @@ static int ft1000_reset_card(struct net_device *dev)
 		ft1000_write_reg(dev, FT1000_REG_RESET, 0);
 		/* FLARION_DSP_ACTIVE; */
 		mdelay(10);
-		DEBUG(0, "ft1000_hw:ft1000_reset_card:Take DSP out of reset\n");
+		pr_debug("Take DSP out of reset\n");
 
 		/* Wait for 0xfefe indicating dsp ready before starting download */
 		for (i = 0; i < 50; i++) {
@@ -464,8 +447,7 @@ static int ft1000_reset_card(struct net_device *dev)
 		}
 
 		if (i == 50) {
-			DEBUG(0,
-			      "ft1000_hw:ft1000_reset_card:No FEFE detected from DSP\n");
+			pr_debug("No FEFE detected from DSP\n");
 			return false;
 		}
 
@@ -476,10 +458,10 @@ static int ft1000_reset_card(struct net_device *dev)
 	}
 
 	if (card_download(dev, fw_entry->data, fw_entry->size)) {
-		DEBUG(1, "card download unsuccessful\n");
+		pr_debug("card download unsuccessful\n");
 		return false;
 	} else {
-		DEBUG(1, "card download successful\n");
+		pr_debug("card download successful\n");
 	}
 
 	mdelay(10);
@@ -494,8 +476,7 @@ static int ft1000_reset_card(struct net_device *dev)
 		/* Initialize DSP heartbeat area to ho */
 		ft1000_write_dpram(dev, FT1000_HI_HO, ho);
 		tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
-		DEBUG(1, "ft1000_hw:ft1000_reset_asic:hi_ho value = 0x%x\n",
-		      tempword);
+		pr_debug("hi_ho value = 0x%x\n", tempword);
 	} else {
 		/* Initialize DSP heartbeat area to ho */
 		ft1000_write_dpram_mag_16(dev, FT1000_MAG_HI_HO, ho_mag,
@@ -503,8 +484,7 @@ static int ft1000_reset_card(struct net_device *dev)
 		tempword =
 			ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO,
 						 FT1000_MAG_HI_HO_INDX);
-		DEBUG(1, "ft1000_hw:ft1000_reset_card:hi_ho value = 0x%x\n",
-		      tempword);
+		pr_debug("hi_ho value = 0x%x\n", tempword);
 	}
 
 	info->CardReady = 1;
@@ -541,8 +521,7 @@ static int ft1000_chkcard(struct net_device *dev)
 	 */
 	tempword = ft1000_read_reg(dev, FT1000_REG_SUP_IMASK);
 	if (tempword == 0) {
-		DEBUG(1,
-		      "ft1000_hw:ft1000_chkcard: IMASK = 0 Card not detected\n");
+		pr_debug("IMASK = 0 Card not detected\n");
 		return false;
 	}
 	/*
@@ -551,8 +530,7 @@ static int ft1000_chkcard(struct net_device *dev)
 	 */
 	tempword = ft1000_read_reg(dev, FT1000_REG_ASIC_ID);
 	if (tempword == 0xffff) {
-		DEBUG(1,
-		      "ft1000_hw:ft1000_chkcard: Version = 0xffff Card not detected\n");
+		pr_debug("Version = 0xffff Card not detected\n");
 		return false;
 	}
 	return true;
@@ -589,8 +567,7 @@ static void ft1000_hbchk(u_long data)
 				      (dev, FT1000_MAG_HI_HO,
 				       FT1000_MAG_HI_HO_INDX));
 		}
-		DEBUG(1, "ft1000_hw:ft1000_hbchk:hi_ho value = 0x%x\n",
-		      tempword);
+		pr_debug("hi_ho value = 0x%x\n", tempword);
 		/* Let's perform another check if ho is not detected */
 		if (tempword != ho) {
 			if (info->AsicID == ELECTRABUZZ_ID) {
@@ -601,8 +578,7 @@ static void ft1000_hbchk(u_long data)
 			}
 		}
 		if (tempword != ho) {
-			printk(KERN_INFO
-			       "ft1000: heartbeat failed - no ho detected\n");
+			pr_info("heartbeat failed - no ho detected\n");
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				info->DSP_TIME[0] =
 					ft1000_read_dpram(dev, FT1000_DSP_TIMER0);
@@ -632,8 +608,7 @@ static void ft1000_hbchk(u_long data)
 			}
 			info->DrvErrNum = DSP_HB_INFO;
 			if (ft1000_reset_card(dev) == 0) {
-				printk(KERN_INFO
-				       "ft1000: Hardware Failure Detected - PC Card disabled\n");
+				pr_info("Hardware Failure Detected - PC Card disabled\n");
 				info->ProgConStat = 0xff;
 				return;
 			}
@@ -650,8 +625,7 @@ static void ft1000_hbchk(u_long data)
 			tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
 		}
 		if (tempword & FT1000_DB_HB) {
-			printk(KERN_INFO
-			       "ft1000: heartbeat doorbell not clear by firmware\n");
+			pr_info("heartbeat doorbell not clear by firmware\n");
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				info->DSP_TIME[0] =
 					ft1000_read_dpram(dev, FT1000_DSP_TIMER0);
@@ -681,8 +655,7 @@ static void ft1000_hbchk(u_long data)
 			}
 			info->DrvErrNum = DSP_HB_INFO;
 			if (ft1000_reset_card(dev) == 0) {
-				printk(KERN_INFO
-				       "ft1000: Hardware Failure Detected - PC Card disabled\n");
+				pr_info("Hardware Failure Detected - PC Card disabled\n");
 				info->ProgConStat = 0xff;
 				return;
 			}
@@ -730,8 +703,7 @@ static void ft1000_hbchk(u_long data)
 		}
 
 		if (tempword != hi) {
-			printk(KERN_INFO
-			       "ft1000: heartbeat failed - cannot write hi into DPRAM\n");
+			pr_info("heartbeat failed - cannot write hi into DPRAM\n");
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				info->DSP_TIME[0] =
 					ft1000_read_dpram(dev, FT1000_DSP_TIMER0);
@@ -761,8 +733,7 @@ static void ft1000_hbchk(u_long data)
 			}
 			info->DrvErrNum = DSP_HB_INFO;
 			if (ft1000_reset_card(dev) == 0) {
-				printk(KERN_INFO
-				       "ft1000: Hardware Failure Detected - PC Card disabled\n");
+				pr_info("Hardware Failure Detected - PC Card disabled\n");
 				info->ProgConStat = 0xff;
 				return;
 			}
@@ -802,8 +773,8 @@ static void ft1000_send_cmd(struct net_device *dev, u16 *ptempbuffer, int size,
 	if ((size & 0x0001)) {
 		size++;
 	}
-	DEBUG(1, "FT1000:ft1000_send_cmd:total length = %d\n", size);
-	DEBUG(1, "FT1000:ft1000_send_cmd:length = %d\n", ntohs(*ptempbuffer));
+	pr_debug("total length = %d\n", size);
+	pr_debug("length = %d\n", ntohs(*ptempbuffer));
 	/*
 	 * put message into slow queue area
 	 * All messages are in the form total_len + pseudo header + message body
@@ -830,8 +801,7 @@ static void ft1000_send_cmd(struct net_device *dev, u16 *ptempbuffer, int size,
 		ft1000_write_reg(dev, FT1000_REG_DPRAM_DATA, size);
 		/* Write pseudo header and messgae body */
 		for (i = 0; i < (size >> 1); i++) {
-			DEBUG(1, "FT1000:ft1000_send_cmd:data %d = 0x%x\n", i,
-			      *ptempbuffer);
+			pr_debug("data %d = 0x%x\n", i, *ptempbuffer);
 			tempword = htons(*ptempbuffer++);
 			ft1000_write_reg(dev, FT1000_REG_DPRAM_DATA, tempword);
 		}
@@ -844,18 +814,16 @@ static void ft1000_send_cmd(struct net_device *dev, u16 *ptempbuffer, int size,
 		ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
 				 FT1000_DPRAM_MAG_TX_BASE + 1);
 		for (i = 0; i < (size >> 2); i++) {
-			DEBUG(1, "FT1000:ft1000_send_cmd:data = 0x%x\n",
-			      *ptempbuffer);
+			pr_debug("data = 0x%x\n", *ptempbuffer);
 			outw(*ptempbuffer++,
 			     dev->base_addr + FT1000_REG_MAG_DPDATAL);
-			DEBUG(1, "FT1000:ft1000_send_cmd:data = 0x%x\n",
-			      *ptempbuffer);
+			pr_debug("data = 0x%x\n", *ptempbuffer);
 			outw(*ptempbuffer++,
 			     dev->base_addr + FT1000_REG_MAG_DPDATAH);
 		}
-		DEBUG(1, "FT1000:ft1000_send_cmd:data = 0x%x\n", *ptempbuffer);
+		pr_debug("data = 0x%x\n", *ptempbuffer);
 		outw(*ptempbuffer++, dev->base_addr + FT1000_REG_MAG_DPDATAL);
-		DEBUG(1, "FT1000:ft1000_send_cmd:data = 0x%x\n", *ptempbuffer);
+		pr_debug("data = 0x%x\n", *ptempbuffer);
 		outw(*ptempbuffer++, dev->base_addr + FT1000_REG_MAG_DPDATAH);
 	}
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
@@ -896,9 +864,7 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 			       FT1000_MAG_PH_LEN_INDX)) + sizeof(struct pseudo_hdr);
 	}
 	if (size > maxsz) {
-		DEBUG(1,
-		      "FT1000:ft1000_receive_cmd:Invalid command length = %d\n",
-		      size);
+		pr_debug("Invalid command length = %d\n", size);
 		return false;
 	} else {
 		ppseudohdr = (u16 *)pbuffer;
@@ -915,7 +881,7 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 			ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
 					 FT1000_DPRAM_MAG_RX_BASE);
 			*pbuffer = inw(dev->base_addr + FT1000_REG_MAG_DPDATAH);
-			DEBUG(1, "ft1000_hw:received data = 0x%x\n", *pbuffer);
+			pr_debug("received data = 0x%x\n", *pbuffer);
 			pbuffer++;
 			ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
 					 FT1000_DPRAM_MAG_RX_BASE + 1);
@@ -931,10 +897,10 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 			}
 			/* copy odd aligned word */
 			*pbuffer = inw(dev->base_addr + FT1000_REG_MAG_DPDATAL);
-			DEBUG(1, "ft1000_hw:received data = 0x%x\n", *pbuffer);
+			pr_debug("received data = 0x%x\n", *pbuffer);
 			pbuffer++;
 			*pbuffer = inw(dev->base_addr + FT1000_REG_MAG_DPDATAH);
-			DEBUG(1, "ft1000_hw:received data = 0x%x\n", *pbuffer);
+			pr_debug("received data = 0x%x\n", *pbuffer);
 			pbuffer++;
 		}
 		if (size & 0x0001) {
@@ -953,8 +919,7 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 			tempword ^= *ppseudohdr++;
 		}
 		if ((tempword != *ppseudohdr)) {
-			DEBUG(1,
-			      "FT1000:ft1000_receive_cmd:Pseudo header checksum mismatch\n");
+			pr_debug("Pseudo header checksum mismatch\n");
 			/* Drop this message */
 			return false;
 		}
@@ -1003,14 +968,13 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 		/* Get the message type which is total_len + PSEUDO header + msgtype + message body */
 		pdrvmsg = (struct drv_msg *)&cmdbuffer[0];
 		msgtype = ntohs(pdrvmsg->type);
-		DEBUG(1, "Command message type = 0x%x\n", msgtype);
+		pr_debug("Command message type = 0x%x\n", msgtype);
 		switch (msgtype) {
 		case DSP_PROVISION:
-			DEBUG(0,
-			      "Got a provisioning request message from DSP\n");
+			pr_debug("Got a provisioning request message from DSP\n");
 			mdelay(25);
 			while (list_empty(&info->prov_list) == 0) {
-				DEBUG(0, "Sending a provisioning message\n");
+				pr_debug("Sending a provisioning message\n");
 				/* Make sure SLOWQ doorbell is clear */
 				tempword =
 					ft1000_read_reg(dev, FT1000_REG_DOORBELL);
@@ -1035,12 +999,12 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				ppseudo_hdr->portsrc = 0;
 				/* Calculate new checksum */
 				ppseudo_hdr->checksum = *pmsg++;
-				DEBUG(1, "checksum = 0x%x\n",
-				      ppseudo_hdr->checksum);
+				pr_debug("checksum = 0x%x\n",
+					 ppseudo_hdr->checksum);
 				for (i = 1; i < 7; i++) {
 					ppseudo_hdr->checksum ^= *pmsg++;
-					DEBUG(1, "checksum = 0x%x\n",
-					      ppseudo_hdr->checksum);
+					pr_debug("checksum = 0x%x\n",
+						 ppseudo_hdr->checksum);
 				}
 
 				ft1000_send_cmd(dev, (u16 *)ptr->pprov_data, len, SLOWQ_TYPE);
@@ -1058,7 +1022,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 			pmediamsg = (struct media_msg *)&cmdbuffer[0];
 			if (info->ProgConStat != 0xFF) {
 				if (pmediamsg->state) {
-					DEBUG(1, "Media is up\n");
+					pr_debug("Media is up\n");
 					if (info->mediastate == 0) {
 						netif_carrier_on(dev);
 						netif_wake_queue(dev);
@@ -1067,7 +1031,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 						info->ConTm = tv.tv_sec;
 					}
 				} else {
-					DEBUG(1, "Media is down\n");
+					pr_debug("Media is down\n");
 					if (info->mediastate == 1) {
 						info->mediastate = 0;
 						netif_carrier_off(dev);
@@ -1077,7 +1041,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				}
 			}
 			else {
-				DEBUG(1, "Media is down\n");
+				pr_debug("Media is down\n");
 				if (info->mediastate == 1) {
 					info->mediastate = 0;
 					netif_carrier_off(dev);
@@ -1089,9 +1053,9 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 		case DSP_INIT_MSG:
 			pdspinitmsg = (struct dsp_init_msg *)&cmdbuffer[0];
 			memcpy(info->DspVer, pdspinitmsg->DspVer, DSPVERSZ);
-			DEBUG(1, "DSPVER = 0x%2x 0x%2x 0x%2x 0x%2x\n",
-			      info->DspVer[0], info->DspVer[1], info->DspVer[2],
-			      info->DspVer[3]);
+			pr_debug("DSPVER = 0x%2x 0x%2x 0x%2x 0x%2x\n",
+				 info->DspVer[0], info->DspVer[1],
+				 info->DspVer[2], info->DspVer[3]);
 			memcpy(info->HwSerNum, pdspinitmsg->HwSerNum,
 			       HWSERNUMSZ);
 			memcpy(info->Sku, pdspinitmsg->Sku, SKUSZ);
@@ -1111,27 +1075,26 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				       CALVERSZ);
 				memcpy(info->RfCalDate, pdspinitmsg->RfCalDate,
 				       CALDATESZ);
-				DEBUG(1, "RFCalVer = 0x%2x 0x%2x\n",
-				      info->RfCalVer[0], info->RfCalVer[1]);
+				pr_debug("RFCalVer = 0x%2x 0x%2x\n",
+					 info->RfCalVer[0], info->RfCalVer[1]);
 			}
 
 			break;
 		case DSP_STORE_INFO:
-			DEBUG(1, "FT1000:drivermsg:Got DSP_STORE_INFO\n");
+			pr_debug("Got DSP_STORE_INFO\n");
 			tempword = ntohs(pdrvmsg->length);
 			info->DSPInfoBlklen = tempword;
 			if (tempword < (MAX_DSP_SESS_REC - 4)) {
 				pmsg = (u16 *)&pdrvmsg->data[0];
 				for (i = 0; i < ((tempword + 1) / 2); i++) {
-					DEBUG(1,
-					      "FT1000:drivermsg:dsp info data = 0x%x\n",
-					      *pmsg);
+					pr_debug("dsp info data = 0x%x\n",
+						 *pmsg);
 					info->DSPInfoBlk[i + 10] = *pmsg++;
 				}
 			}
 			break;
 		case DSP_GET_INFO:
-			DEBUG(1, "FT1000:drivermsg:Got DSP_GET_INFO\n");
+			pr_debug("Got DSP_GET_INFO\n");
 			/*
 			 * copy dsp info block to dsp
 			 * allow any outstanding ioctl to finish
@@ -1182,7 +1145,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 
 			break;
 		case GET_DRV_ERR_RPT_MSG:
-			DEBUG(1, "FT1000:drivermsg:Got GET_DRV_ERR_RPT_MSG\n");
+			pr_debug("Got GET_DRV_ERR_RPT_MSG\n");
 			/*
 			 * copy driver error message to dsp
 			 * allow any outstanding ioctl to finish
@@ -1273,7 +1236,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 	unsigned long flags;
 
 	doorbell = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
-	DEBUG(1, "Doorbell = 0x%x\n", doorbell);
+	pr_debug("Doorbell = 0x%x\n", doorbell);
 
 	if (doorbell & FT1000_ASIC_RESET_REQ) {
 		/* Copy DSP session record from info block */
@@ -1298,7 +1261,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 		/* clear ASIC RESET request */
 		ft1000_write_reg(dev, FT1000_REG_DOORBELL,
 				 FT1000_ASIC_RESET_REQ);
-		DEBUG(1, "Got an ASIC RESET Request\n");
+		pr_debug("Got an ASIC RESET Request\n");
 		ft1000_write_reg(dev, FT1000_REG_DOORBELL,
 				 FT1000_ASIC_RESET_DSP);
 
@@ -1310,8 +1273,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 	}
 
 	if (doorbell & FT1000_DSP_ASIC_RESET) {
-		DEBUG(0,
-		      "FT1000:ft1000_parse_dpram_msg: Got a dsp ASIC reset message\n");
+		pr_debug("Got a dsp ASIC reset message\n");
 		ft1000_write_reg(dev, FT1000_REG_DOORBELL,
 				 FT1000_DSP_ASIC_RESET);
 		udelay(200);
@@ -1319,8 +1281,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 	}
 
 	if (doorbell & FT1000_DB_DPRAM_RX) {
-		DEBUG(1,
-		      "FT1000:ft1000_parse_dpram_msg: Got a slow queue message\n");
+		pr_debug("Got a slow queue message\n");
 		nxtph = FT1000_DPRAM_RX_BASE + 2;
 		if (info->AsicID == ELECTRABUZZ_ID) {
 			total_len =
@@ -1331,8 +1292,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 				      (dev, FT1000_MAG_TOTAL_LEN,
 				       FT1000_MAG_TOTAL_LEN_INDX));
 		}
-		DEBUG(1, "FT1000:ft1000_parse_dpram_msg:total length = %d\n",
-		      total_len);
+		pr_debug("total length = %d\n", total_len);
 		if ((total_len < MAX_CMD_SQSIZE) && (total_len > sizeof(struct pseudo_hdr))) {
 			total_len += nxtph;
 			/*
@@ -1351,7 +1311,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 					 (dev, FT1000_MAG_PORT_ID,
 					  FT1000_MAG_PORT_ID_INDX) & 0xff);
 			}
-			DEBUG(1, "DSP_QID = 0x%x\n", portid);
+			pr_debug("DSP_QID = 0x%x\n", portid);
 
 			if (portid == DRIVERID) {
 				/* We are assumming one driver message from the DSP at a time. */
@@ -1387,7 +1347,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 							 FT1000_MAG_DSP_TIMER3_INDX);
 		}
 		info->DrvErrNum = DSP_CONDRESET_INFO;
-		DEBUG(1, "ft1000_hw:DSP conditional reset requested\n");
+		pr_debug("DSP conditional reset requested\n");
 		ft1000_reset_card(dev);
 		ft1000_write_reg(dev, FT1000_REG_DOORBELL,
 				 FT1000_DB_COND_RESET);
@@ -1397,7 +1357,7 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 		doorbell & ~(FT1000_DB_DPRAM_RX | FT1000_ASIC_RESET_REQ |
 			     FT1000_DB_COND_RESET | 0xff00);
 	if (doorbell) {
-		DEBUG(1, "Clearing unexpected doorbell = 0x%x\n", doorbell);
+		pr_debug("Clearing unexpected doorbell = 0x%x\n", doorbell);
 		ft1000_write_reg(dev, FT1000_REG_DOORBELL, doorbell);
 	}
 
@@ -1425,7 +1385,6 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 	u32 templong;
 	u16 tempword;
 
-	DEBUG(1, "ft1000:ft1000_hw:ft1000_flush_fifo called\n");
 	if (pcmcia->PktIntfErr > MAX_PH_ERR) {
 		if (info->AsicID == ELECTRABUZZ_ID) {
 			info->DSP_TIME[0] =
@@ -1531,23 +1490,23 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 		} while ((tempword & 0x03) != 0x03);
 		if (info->AsicID == ELECTRABUZZ_ID) {
 			i++;
-			DEBUG(0, "Flushing FIFO complete = %x\n", tempword);
+			pr_debug("Flushing FIFO complete = %x\n", tempword);
 			/* Flush last word in FIFO. */
 			tempword = ft1000_read_reg(dev, FT1000_REG_DFIFO);
 			/* Update FIFO counter for DSP */
 			i = i * 2;
-			DEBUG(0, "Flush Data byte count to dsp = %d\n", i);
+			pr_debug("Flush Data byte count to dsp = %d\n", i);
 			info->fifo_cnt += i;
 			ft1000_write_dpram(dev, FT1000_FIFO_LEN,
 					   info->fifo_cnt);
 		} else {
-			DEBUG(0, "Flushing FIFO complete = %x\n", tempword);
+			pr_debug("Flushing FIFO complete = %x\n", tempword);
 			/* Flush last word in FIFO */
 			templong = inl(dev->base_addr + FT1000_REG_MAG_DFR);
 			tempword = inw(dev->base_addr + FT1000_REG_SUP_STAT);
-			DEBUG(0, "FT1000_REG_SUP_STAT = 0x%x\n", tempword);
+			pr_debug("FT1000_REG_SUP_STAT = 0x%x\n", tempword);
 			tempword = inw(dev->base_addr + FT1000_REG_MAG_DFSR);
-			DEBUG(0, "FT1000_REG_MAG_DFSR = 0x%x\n", tempword);
+			pr_debug("FT1000_REG_MAG_DFSR = 0x%x\n", tempword);
 		}
 		if (DrvErrNum) {
 			pcmcia->PktIntfErr++;
@@ -1581,7 +1540,6 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 	u32 *ptemplong;
 	u32 templong;
 
-	DEBUG(1, "ft1000_copy_up_pkt\n");
 	/* Read length */
 	if (info->AsicID == ELECTRABUZZ_ID) {
 		tempword = ft1000_read_reg(dev, FT1000_REG_DFIFO);
@@ -1591,10 +1549,10 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 		len = ntohs(tempword);
 	}
 	chksum = tempword;
-	DEBUG(1, "Number of Bytes in FIFO = %d\n", len);
+	pr_debug("Number of Bytes in FIFO = %d\n", len);
 
 	if (len > ENET_MAX_SIZE) {
-		DEBUG(0, "size of ethernet packet invalid\n");
+		pr_debug("size of ethernet packet invalid\n");
 		if (info->AsicID == MAGNEMITE_ID) {
 			/* Read High word to complete 32 bit access */
 			tempword = ft1000_read_reg(dev, FT1000_REG_MAG_DFRH);
@@ -1607,7 +1565,7 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 	skb = dev_alloc_skb(len + 12 + 2);
 
 	if (skb == NULL) {
-		DEBUG(0, "No Network buffers available\n");
+		pr_debug("No Network buffers available\n");
 		/* Read High word to complete 32 bit access */
 		if (info->AsicID == MAGNEMITE_ID) {
 			tempword = ft1000_read_reg(dev, FT1000_REG_MAG_DFRH);
@@ -1628,37 +1586,37 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 		tempword = ft1000_read_reg(dev, FT1000_REG_DFIFO);
 	} else {
 		tempword = ft1000_read_reg(dev, FT1000_REG_MAG_DFRH);
-		DEBUG(1, "Pseudo = 0x%x\n", tempword);
+		pr_debug("Pseudo = 0x%x\n", tempword);
 		chksum ^= tempword;
 
 		tempword = ft1000_read_reg(dev, FT1000_REG_MAG_DFRL);
-		DEBUG(1, "Pseudo = 0x%x\n", tempword);
+		pr_debug("Pseudo = 0x%x\n", tempword);
 		chksum ^= tempword;
 
 		tempword = ft1000_read_reg(dev, FT1000_REG_MAG_DFRH);
-		DEBUG(1, "Pseudo = 0x%x\n", tempword);
+		pr_debug("Pseudo = 0x%x\n", tempword);
 		chksum ^= tempword;
 
 		tempword = ft1000_read_reg(dev, FT1000_REG_MAG_DFRL);
-		DEBUG(1, "Pseudo = 0x%x\n", tempword);
+		pr_debug("Pseudo = 0x%x\n", tempword);
 		chksum ^= tempword;
 
 		tempword = ft1000_read_reg(dev, FT1000_REG_MAG_DFRH);
-		DEBUG(1, "Pseudo = 0x%x\n", tempword);
+		pr_debug("Pseudo = 0x%x\n", tempword);
 		chksum ^= tempword;
 
 		tempword = ft1000_read_reg(dev, FT1000_REG_MAG_DFRL);
-		DEBUG(1, "Pseudo = 0x%x\n", tempword);
+		pr_debug("Pseudo = 0x%x\n", tempword);
 		chksum ^= tempword;
 
 		/* read checksum value */
 		tempword = ft1000_read_reg(dev, FT1000_REG_MAG_DFRH);
-		DEBUG(1, "Pseudo = 0x%x\n", tempword);
+		pr_debug("Pseudo = 0x%x\n", tempword);
 	}
 
 	if (chksum != tempword) {
-		DEBUG(0, "Packet checksum mismatch 0x%x 0x%x\n", chksum,
-		      tempword);
+		pr_debug("Packet checksum mismatch 0x%x 0x%x\n",
+			 chksum, tempword);
 		ft1000_flush_fifo(dev, DSP_PKTPHCKSUM_INFO);
 		info->stats.rx_errors++;
 		kfree_skb(skb);
@@ -1701,22 +1659,22 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
 		ptemplong = (u32 *)pbuffer;
 		for (i = 0; i < len / 4; i++) {
 			templong = inl(dev->base_addr + FT1000_REG_MAG_DFR);
-			DEBUG(1, "Data = 0x%8x\n", templong);
+			pr_debug("Data = 0x%8x\n", templong);
 			*ptemplong++ = templong;
 		}
 
 		/* Need to read one more word if odd align. */
 		if (len & 0x0003) {
 			templong = inl(dev->base_addr + FT1000_REG_MAG_DFR);
-			DEBUG(1, "Data = 0x%8x\n", templong);
+			pr_debug("Data = 0x%8x\n", templong);
 			*ptemplong++ = templong;
 		}
 
 	}
 
-	DEBUG(1, "Data passed to Protocol layer:\n");
+	pr_debug("Data passed to Protocol layer:\n");
 	for (i = 0; i < len + 12; i++) {
-		DEBUG(1, "Protocol Data: 0x%x\n ", *ptemp++);
+		pr_debug("Protocol Data: 0x%x\n", *ptemp++);
 	}
 
 	skb->dev = dev;
@@ -1768,8 +1726,6 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 	int i;
 	u32 *plong;
 
-	DEBUG(1, "ft1000_hw: copy_down_pkt()\n");
-
 	/* Check if there is room on the FIFO */
 	if (len > ft1000_read_fifo_len(dev)) {
 		udelay(10);
@@ -1789,8 +1745,7 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 			udelay(20);
 		}
 		if (len > ft1000_read_fifo_len(dev)) {
-			DEBUG(1,
-			      "ft1000_hw:ft1000_copy_down_pkt:Transmit FIFO is fulli - pkt drop\n");
+			pr_debug("Transmit FIFO is full - pkt drop\n");
 			info->stats.tx_errors++;
 			return SUCCESS;
 		}
@@ -1821,39 +1776,30 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 	if (info->AsicID == ELECTRABUZZ_ID) {
 		/* copy first word to UFIFO_BEG reg */
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_BEG, pseudo.buff[0]);
-		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 0 BEG = 0x%04x\n",
-		      pseudo.buff[0]);
+		pr_debug("data 0 BEG = 0x%04x\n", pseudo.buff[0]);
 
 		/* copy subsequent words to UFIFO_MID reg */
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[1]);
-		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 1 MID = 0x%04x\n",
-		      pseudo.buff[1]);
+		pr_debug("data 1 MID = 0x%04x\n", pseudo.buff[1]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[2]);
-		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 2 MID = 0x%04x\n",
-		      pseudo.buff[2]);
+		pr_debug("data 2 MID = 0x%04x\n", pseudo.buff[2]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[3]);
-		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 3 MID = 0x%04x\n",
-		      pseudo.buff[3]);
+		pr_debug("data 3 MID = 0x%04x\n", pseudo.buff[3]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[4]);
-		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 4 MID = 0x%04x\n",
-		      pseudo.buff[4]);
+		pr_debug("data 4 MID = 0x%04x\n", pseudo.buff[4]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[5]);
-		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 5 MID = 0x%04x\n",
-		      pseudo.buff[5]);
+		pr_debug("data 5 MID = 0x%04x\n", pseudo.buff[5]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[6]);
-		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 6 MID = 0x%04x\n",
-		      pseudo.buff[6]);
+		pr_debug("data 6 MID = 0x%04x\n", pseudo.buff[6]);
 		ft1000_write_reg(dev, FT1000_REG_UFIFO_MID, pseudo.buff[7]);
-		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:data 7 MID = 0x%04x\n",
-		      pseudo.buff[7]);
+		pr_debug("data 7 MID = 0x%04x\n", pseudo.buff[7]);
 
 		/* Write PPP type + IP Packet into Downlink FIFO */
 		for (i = 0; i < (len >> 1) - 1; i++) {
 			ft1000_write_reg(dev, FT1000_REG_UFIFO_MID,
 					 htons(*packet));
-			DEBUG(1,
-			      "ft1000_hw:ft1000_copy_down_pkt:data %d MID = 0x%04x\n",
-			      i + 8, htons(*packet));
+			pr_debug("data %d MID = 0x%04x\n",
+				 i + 8, htons(*packet));
 			packet++;
 		}
 
@@ -1861,39 +1807,31 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 		if (len & 0x0001) {
 			ft1000_write_reg(dev, FT1000_REG_UFIFO_MID,
 					 htons(*packet));
-			DEBUG(1,
-			      "ft1000_hw:ft1000_copy_down_pkt:data MID = 0x%04x\n",
-			      htons(*packet));
+			pr_debug("data MID = 0x%04x\n", htons(*packet));
 			packet++;
 			ft1000_write_reg(dev, FT1000_REG_UFIFO_END,
 					 htons(*packet));
-			DEBUG(1,
-			      "ft1000_hw:ft1000_copy_down_pkt:data %d MID = 0x%04x\n",
-			      i + 8, htons(*packet));
+			pr_debug("data %d MID = 0x%04x\n",
+				 i + 8, htons(*packet));
 		} else {
 			ft1000_write_reg(dev, FT1000_REG_UFIFO_END,
 					 htons(*packet));
-			DEBUG(1,
-			      "ft1000_hw:ft1000_copy_down_pkt:data %d MID = 0x%04x\n",
-			      i + 8, htons(*packet));
+			pr_debug("data %d MID = 0x%04x\n",
+				 i + 8, htons(*packet));
 		}
 	} else {
 		outl(*(u32 *)&pseudo.buff[0],
 		     dev->base_addr + FT1000_REG_MAG_UFDR);
-		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-		      *(u32 *)&pseudo.buff[0]);
+		pr_debug("Pseudo = 0x%8x\n", *(u32 *)&pseudo.buff[0]);
 		outl(*(u32 *)&pseudo.buff[2],
 		     dev->base_addr + FT1000_REG_MAG_UFDR);
-		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-		      *(u32 *)&pseudo.buff[2]);
+		pr_debug("Pseudo = 0x%8x\n", *(u32 *)&pseudo.buff[2]);
 		outl(*(u32 *)&pseudo.buff[4],
 		     dev->base_addr + FT1000_REG_MAG_UFDR);
-		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-		      *(u32 *)&pseudo.buff[4]);
+		pr_debug("Pseudo = 0x%8x\n", *(u32 *)&pseudo.buff[4]);
 		outl(*(u32 *)&pseudo.buff[6],
 		     dev->base_addr + FT1000_REG_MAG_UFDR);
-		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-		      *(u32 *)&pseudo.buff[6]);
+		pr_debug("Pseudo = 0x%8x\n", *(u32 *)&pseudo.buff[6]);
 
 		plong = (u32 *)packet;
 		/* Write PPP type + IP Packet into Downlink FIFO */
@@ -1903,9 +1841,7 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 
 		/* Check for odd alignment */
 		if (len & 0x0003) {
-			DEBUG(1,
-			      "ft1000_hw:ft1000_copy_down_pkt:data = 0x%8x\n",
-			      *plong);
+			pr_debug("data = 0x%8x\n", *plong);
 			outl(*plong++, dev->base_addr + FT1000_REG_MAG_UFDR);
 		}
 		outl(1, dev->base_addr + FT1000_REG_MAG_UFER);
@@ -1926,11 +1862,7 @@ static struct net_device_stats *ft1000_stats(struct net_device *dev)
 
 static int ft1000_open(struct net_device *dev)
 {
-
-	DEBUG(0, "ft1000_hw: ft1000_open is called\n");
-
 	ft1000_reset_card(dev);
-	DEBUG(0, "ft1000_hw: ft1000_open is ended\n");
 
 	/* schedule ft1000_hbchk to perform periodic heartbeat checks on DSP and ASIC */
 	init_timer(&poll_timer);
@@ -1938,7 +1870,6 @@ static int ft1000_open(struct net_device *dev)
 	poll_timer.data = (u_long)dev;
 	add_timer(&poll_timer);
 
-	DEBUG(0, "ft1000_hw: ft1000_open is ended2\n");
 	return 0;
 }
 
@@ -1946,13 +1877,11 @@ static int ft1000_close(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 
-	DEBUG(0, "ft1000_hw: ft1000_close()\n");
-
 	info->CardReady = 0;
 	del_timer(&poll_timer);
 
 	if (ft1000_card_present == 1) {
-		DEBUG(0, "Media is down\n");
+		pr_debug("Media is down\n");
 		netif_stop_queue(dev);
 
 		ft1000_disable_interrupts(dev);
@@ -1969,27 +1898,24 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ft1000_info *info = netdev_priv(dev);
 	u8 *pdata;
 
-	DEBUG(1, "ft1000_hw: ft1000_start_xmit()\n");
 	if (skb == NULL) {
-		DEBUG(1, "ft1000_hw: ft1000_start_xmit:skb == NULL!!!\n");
+		pr_debug("skb == NULL!!!\n");
 		return 0;
 	}
 
-	DEBUG(1, "ft1000_hw: ft1000_start_xmit:length of packet = %d\n",
-	      skb->len);
+	pr_debug("length of packet = %d\n", skb->len);
 
 	pdata = (u8 *)skb->data;
 
 	if (info->mediastate == 0) {
 		/* Drop packet is mediastate is down */
-		DEBUG(1, "ft1000_hw:ft1000_copy_down_pkt:mediastate is down\n");
+		pr_debug("mediastate is down\n");
 		return SUCCESS;
 	}
 
 	if ((skb->len < ENET_HEADER_SIZE) || (skb->len > ENET_MAX_SIZE)) {
 		/* Drop packet which has invalid size */
-		DEBUG(1,
-		      "ft1000_hw:ft1000_copy_down_pkt:invalid ethernet length\n");
+		pr_debug("invalid ethernet length\n");
 		return SUCCESS;
 	}
 	ft1000_copy_down_pkt(dev, (u16 *) (pdata + ENET_HEADER_SIZE - 2),
@@ -2008,8 +1934,6 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 	u16 inttype;
 	int cnt;
 
-	DEBUG(1, "ft1000_hw: ft1000_interrupt()\n");
-
 	if (info->CardReady == 0) {
 		ft1000_disable_interrupts(dev);
 		return IRQ_HANDLED;
@@ -2031,7 +1955,7 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 			ft1000_parse_dpram_msg(dev);
 
 		if (inttype & ISR_RCV) {
-			DEBUG(1, "Data in FIFO\n");
+			pr_debug("Data in FIFO\n");
 
 			cnt = 0;
 			do {
@@ -2056,12 +1980,13 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 		}
 		/* clear interrupts */
 		tempword = ft1000_read_reg(dev, FT1000_REG_SUP_ISR);
-		DEBUG(1, "ft1000_hw: interrupt status register = 0x%x\n", tempword);
+		pr_debug("interrupt status register = 0x%x\n", tempword);
 		ft1000_write_reg(dev, FT1000_REG_SUP_ISR, tempword);
 
 		/* Read interrupt type */
 		inttype = ft1000_read_reg(dev, FT1000_REG_SUP_ISR);
-		DEBUG(1, "ft1000_hw: interrupt status register after clear = 0x%x\n", inttype);
+		pr_debug("interrupt status register after clear = 0x%x\n",
+			 inttype);
 	}
 	ft1000_enable_interrupts(dev);
 	return IRQ_HANDLED;
@@ -2073,8 +1998,6 @@ void stop_ft1000_card(struct net_device *dev)
 	struct prov_record *ptr;
 	/* int cnt; */
 
-	DEBUG(0, "ft1000_hw: stop_ft1000_card()\n");
-
 	info->CardReady = 0;
 	ft1000_card_present = 0;
 	netif_stop_queue(dev);
@@ -2143,9 +2066,8 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 			.ndo_get_stats = &ft1000_stats,
 		};
 
-	DEBUG(1, "ft1000_hw: init_ft1000_card()\n");
-	DEBUG(1, "ft1000_hw: irq = %d\n", link->irq);
-	DEBUG(1, "ft1000_hw: port = 0x%04x\n", link->resource[0]->start);
+	pr_debug("irq = %d, port = 0x%04llx\n",
+		 link->irq, (unsigned long long)link->resource[0]->start);
 
 	flarion_ft1000_cnt++;
 
@@ -2168,9 +2090,9 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 
 	memset(info, 0, sizeof(struct ft1000_info));
 
-	DEBUG(1, "address of dev = 0x%8x\n", (u32)dev);
-	DEBUG(1, "address of dev info = 0x%8x\n", (u32)info);
-	DEBUG(0, "device name = %s\n", dev->name);
+	pr_debug("address of dev = 0x%p\n", dev);
+	pr_debug("address of dev info = 0x%p\n", info);
+	pr_debug("device name = %s\n", dev->name);
 
 	memset(&info->stats, 0, sizeof(struct net_device_stats));
 
@@ -2202,7 +2124,7 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 
 	dev->netdev_ops = &ft1000ops;		/* Slavius 21.10.2009 due to kernel changes */
 
-	DEBUG(0, "device name = %s\n", dev->name);
+	pr_debug("device name = %s\n", dev->name);
 
 	dev->irq = link->irq;
 	dev->base_addr = link->resource[0]->start;
@@ -2222,21 +2144,21 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 	}
 
 	if (register_netdev(dev) != 0) {
-		DEBUG(0, "ft1000: Could not register netdev");
+		pr_debug("Could not register netdev\n");
 		goto err_reg;
 	}
 
 	info->AsicID = ft1000_read_reg(dev, FT1000_REG_ASIC_ID);
 	if (info->AsicID == ELECTRABUZZ_ID) {
-		DEBUG(0, "ft1000_hw: ELECTRABUZZ ASIC\n");
+		pr_debug("ELECTRABUZZ ASIC\n");
 		if (request_firmware(&fw_entry, "ft1000.img", &link->dev) != 0) {
-			printk(KERN_INFO "ft1000: Could not open ft1000.img\n");
+			pr_info("Could not open ft1000.img\n");
 			goto err_unreg;
 		}
 	} else {
-		DEBUG(0, "ft1000_hw: MAGNEMITE ASIC\n");
+		pr_debug("MAGNEMITE ASIC\n");
 		if (request_firmware(&fw_entry, "ft2000.img", &link->dev) != 0) {
-			printk(KERN_INFO "ft1000: Could not open ft2000.img\n");
+			pr_info("Could not open ft2000.img\n");
 			goto err_unreg;
 		}
 	}
@@ -2245,8 +2167,8 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 
 	ft1000_card_present = 1;
 	dev->ethtool_ops = &ops;
-	printk(KERN_INFO "ft1000: %s: addr 0x%04lx irq %d, MAC addr %pM\n",
-	       dev->name, dev->base_addr, dev->irq, dev->dev_addr);
+	pr_info("%s: addr 0x%04lx irq %d, MAC addr %pM\n",
+		dev->name, dev->base_addr, dev->irq, dev->dev_addr);
 	return dev;
 
 err_unreg:
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 658f3ca..c8d2782 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -26,6 +26,9 @@
  *
  *---------------------------------------------------------------------------
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -87,13 +90,13 @@ struct dpram_blk *ft1000_get_buffer(struct list_head *bufflist)
 	spin_lock_irqsave(&free_buff_lock, flags);
 	/* Check if buffer is available */
 	if (list_empty(bufflist)) {
-		DEBUG("ft1000_get_buffer:  No more buffer - %d\n", numofmsgbuf);
+		pr_debug("No more buffer - %d\n", numofmsgbuf);
 		ptr = NULL;
 	} else {
 		numofmsgbuf--;
 		ptr = list_entry(bufflist->next, struct dpram_blk, list);
 		list_del(&ptr->list);
-		/* DEBUG("ft1000_get_buffer: number of free msg buffers = %d\n", numofmsgbuf); */
+		/* pr_debug("number of free msg buffers = %d\n", numofmsgbuf); */
 	}
 	spin_unlock_irqrestore(&free_buff_lock, flags);
 
@@ -125,7 +128,7 @@ void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist)
 	/* Put memory back to list */
 	list_add_tail(&pdpram_blk->list, plist);
 	numofmsgbuf++;
-	/*DEBUG("ft1000_free_buffer: number of free msg buffers = %d\n", numofmsgbuf); */
+	/*pr_debug("number of free msg buffers = %d\n", numofmsgbuf); */
 	spin_unlock_irqrestore(&free_buff_lock, flags);
 }
 
@@ -153,17 +156,17 @@ int ft1000_create_dev(struct ft1000_usb *dev)
 	/* make a new device name */
 	sprintf(dev->DeviceName, "%s%d", "FT1000_", dev->CardNumber);
 
-	DEBUG("%s: number of instance = %d\n", __func__, ft1000_flarion_cnt);
-	DEBUG("DeviceCreated = %x\n", dev->DeviceCreated);
+	pr_debug("number of instance = %d\n", ft1000_flarion_cnt);
+	pr_debug("DeviceCreated = %x\n", dev->DeviceCreated);
 
 	if (dev->DeviceCreated) {
-		DEBUG("%s: \"%s\" already registered\n", __func__, dev->DeviceName);
+		pr_debug("\"%s\" already registered\n", dev->DeviceName);
 		return -EIO;
 	}
 
 
 	/* register the device */
-	DEBUG("%s: \"%s\" debugfs device registration\n", __func__, dev->DeviceName);
+	pr_debug("\"%s\" debugfs device registration\n", dev->DeviceName);
 
 	tmp = kmalloc(sizeof(struct ft1000_debug_dirs), GFP_KERNEL);
 	if (tmp == NULL) {
@@ -189,7 +192,7 @@ int ft1000_create_dev(struct ft1000_usb *dev)
 	tmp->int_number = dev->CardNumber;
 	list_add(&(tmp->list), &(dev->nodes.list));
 
-	DEBUG("%s: registered debugfs directory \"%s\"\n", __func__, dev->DeviceName);
+	pr_debug("registered debugfs directory \"%s\"\n", dev->DeviceName);
 
 	/* initialize application information */
 	dev->appcnt = 0;
@@ -241,10 +244,6 @@ void ft1000_destroy_dev(struct net_device *netdev)
 	struct list_head *pos, *q;
 	struct ft1000_debug_dirs *dir;
 
-	DEBUG("%s called\n", __func__);
-
-
-
 	if (dev->DeviceCreated) {
 		ft1000_flarion_cnt--;
 		list_for_each_safe(pos, q, &dev->nodes.list) {
@@ -256,8 +255,7 @@ void ft1000_destroy_dev(struct net_device *netdev)
 				kfree(dir);
 			}
 		}
-		DEBUG("%s: unregistered device \"%s\"\n", __func__,
-		      dev->DeviceName);
+		pr_debug("unregistered device \"%s\"\n", dev->DeviceName);
 
 		/* Make sure we free any memory reserve for slow Queue */
 		for (i = 0; i < MAX_NUM_APP; i++) {
@@ -303,17 +301,17 @@ static int ft1000_open(struct inode *inode, struct file *file)
 	struct ft1000_usb *dev = (struct ft1000_usb *)inode->i_private;
 	int i, num;
 
-	DEBUG("%s called\n", __func__);
 	num = (MINOR(inode->i_rdev) & 0xf);
-	DEBUG("ft1000_open: minor number=%d\n", num);
+	pr_debug("minor number=%d\n", num);
 
 	info = file->private_data = netdev_priv(dev->net);
 
-	DEBUG("f_owner = %p number of application = %d\n", (&file->f_owner), dev->appcnt);
+	pr_debug("f_owner = %p number of application = %d\n",
+		 &file->f_owner, dev->appcnt);
 
 	/* Check if maximum number of application exceeded */
 	if (dev->appcnt > MAX_NUM_APP) {
-		DEBUG("Maximum number of application exceeded\n");
+		pr_debug("Maximum number of application exceeded\n");
 		return -EACCES;
 	}
 
@@ -326,7 +324,7 @@ static int ft1000_open(struct inode *inode, struct file *file)
 
 	/* Fail due to lack of application info block */
 	if (i == MAX_NUM_APP) {
-		DEBUG("Could not find an application info block\n");
+		pr_debug("Could not find an application info block\n");
 		return -EACCES;
 	}
 
@@ -362,33 +360,32 @@ static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
 	struct ft1000_usb *dev = info->priv;
 	int i;
 
-	/* DEBUG("ft1000_poll_dev called\n"); */
 	if (ft1000_flarion_cnt == 0) {
-		DEBUG("FT1000:ft1000_poll_dev called when ft1000_flarion_cnt is zero\n");
+		pr_debug("called with ft1000_flarion_cnt value zero\n");
 		return -EBADF;
 	}
 
 	/* Search for matching file object */
 	for (i = 0; i < MAX_NUM_APP; i++) {
 		if (dev->app_info[i].fileobject == &file->f_owner) {
-			/* DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", dev->app_info[i].app_id); */
+			/* pr_debug("Message is for AppId = %d\n", dev->app_info[i].app_id); */
 			break;
 		}
 	}
 
 	/* Could not find application info block */
 	if (i == MAX_NUM_APP) {
-		DEBUG("FT1000:ft1000_ioctl:Could not find application info block\n");
+		pr_debug("Could not find application info block\n");
 		return -EACCES;
 	}
 
 	if (list_empty(&dev->app_info[i].app_sqlist) == 0) {
-		DEBUG("FT1000:ft1000_poll_dev:Message detected in slow queue\n");
+		pr_debug("Message detected in slow queue\n");
 		return(POLLIN | POLLRDNORM | POLLPRI);
 	}
 
 	poll_wait(file, &dev->app_info[i].wait_dpram_msg, wait);
-	/* DEBUG("FT1000:ft1000_poll_dev:Polling for data from DSP\n"); */
+	/* pr_debug("Polling for data from DSP\n"); */
 
 	return 0;
 }
@@ -429,27 +426,25 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 	unsigned short ledStat = 0;
 	unsigned short conStat = 0;
 
-	/* DEBUG("ft1000_ioctl called\n"); */
-
 	if (ft1000_flarion_cnt == 0) {
-		DEBUG("FT1000:ft1000_ioctl called when ft1000_flarion_cnt is zero\n");
+		pr_debug("called with ft1000_flarion_cnt of zero\n");
 		return -EBADF;
 	}
 
-	/* DEBUG("FT1000:ft1000_ioctl:command = 0x%x argument = 0x%8x\n", command, (u32)argument); */
+	/* pr_debug("command = 0x%x argument = 0x%8x\n", command, (u32)argument); */
 
 	info = file->private_data;
 	ft1000dev = info->priv;
 	cmd = _IOC_NR(command);
-	/* DEBUG("FT1000:ft1000_ioctl:cmd = 0x%x\n", cmd); */
+	/* pr_debug("cmd = 0x%x\n", cmd); */
 
 	/* process the command */
 	switch (cmd) {
 	case IOCTL_REGISTER_CMD:
-		DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_REGISTER called\n");
+		pr_debug("IOCTL_FT1000_REGISTER called\n");
 		result = get_user(tempword, (__u16 __user *)argp);
 		if (result) {
-			DEBUG("result = %d failed to get_user\n", result);
+			pr_debug("result = %d failed to get_user\n", result);
 			break;
 		}
 		if (tempword == DSPBCMSGID) {
@@ -457,7 +452,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 			for (i = 0; i < MAX_NUM_APP; i++) {
 				if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
 					ft1000dev->app_info[i].DspBCMsgFlag = 1;
-					DEBUG("FT1000:ft1000_ioctl:Registered for broadcast messages\n");
+					pr_debug("Registered for broadcast messages\n");
 					break;
 				}
 			}
@@ -465,34 +460,35 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 		break;
 
 	case IOCTL_GET_VER_CMD:
-		DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_VER called\n");
+		pr_debug("IOCTL_FT1000_GET_VER called\n");
 
 		get_ver_data.drv_ver = FT1000_DRV_VER;
 
 		if (copy_to_user(argp, &get_ver_data, sizeof(get_ver_data))) {
-			DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
+			pr_debug("copy fault occurred\n");
 			result = -EFAULT;
 			break;
 		}
 
-		DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n", (unsigned int)get_ver_data.drv_ver);
+		pr_debug("driver version = 0x%x\n",
+			 (unsigned int)get_ver_data.drv_ver);
 
 		break;
 	case IOCTL_CONNECT:
 		/* Connect Message */
-		DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_CONNECT\n");
+		pr_debug("IOCTL_FT1000_CONNECT\n");
 		ConnectionMsg[79] = 0xfc;
 		result = card_send_command(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
 
 		break;
 	case IOCTL_DISCONNECT:
 		/* Disconnect Message */
-		DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_DISCONNECT\n");
+		pr_debug("IOCTL_FT1000_DISCONNECT\n");
 		ConnectionMsg[79] = 0xfd;
 		result = card_send_command(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
 		break;
 	case IOCTL_GET_DSP_STAT_CMD:
-		/* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DSP_STAT called\n"); */
+		/* pr_debug("IOCTL_FT1000_GET_DSP_STAT\n"); */
 		memset(&get_stat_data, 0, sizeof(get_stat_data));
 		memcpy(get_stat_data.DspVer, info->DspVer, DSPVERSZ);
 		memcpy(get_stat_data.HwSerNum, info->HwSerNum, HWSERNUMSZ);
@@ -502,10 +498,10 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 		if (info->ProgConStat != 0xFF) {
 			ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_LED, (u8 *)&ledStat, FT1000_MAG_DSP_LED_INDX);
 			get_stat_data.LedStat = ntohs(ledStat);
-			DEBUG("FT1000:ft1000_ioctl: LedStat = 0x%x\n", get_stat_data.LedStat);
+			pr_debug("LedStat = 0x%x\n", get_stat_data.LedStat);
 			ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_CON_STATE, (u8 *)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
 			get_stat_data.ConStat = ntohs(conStat);
-			DEBUG("FT1000:ft1000_ioctl: ConStat = 0x%x\n", get_stat_data.ConStat);
+			pr_debug("ConStat = 0x%x\n", get_stat_data.ConStat);
 		} else {
 			get_stat_data.ConStat = 0x0f;
 		}
@@ -517,13 +513,13 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 		get_stat_data.nRxBytes = info->stats.rx_bytes;
 		do_gettimeofday(&tv);
 		get_stat_data.ConTm = (u32)(tv.tv_sec - info->ConTm);
-		DEBUG("Connection Time = %d\n", (int)get_stat_data.ConTm);
+		pr_debug("Connection Time = %d\n", (int)get_stat_data.ConTm);
 		if (copy_to_user(argp, &get_stat_data, sizeof(get_stat_data))) {
-			DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
+			pr_debug("copy fault occurred\n");
 			result = -EFAULT;
 			break;
 		}
-		DEBUG("ft1000_chioctl: GET_DSP_STAT succeed\n");
+		pr_debug("GET_DSP_STAT succeed\n");
 		break;
 	case IOCTL_SET_DPRAM_CMD:
 	{
@@ -537,7 +533,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 		u16 app_index;
 		u16 status;
 
-		/* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_SET_DPRAM called\n");*/
+		/* pr_debug("IOCTL_FT1000_SET_DPRAM called\n");*/
 
 
 		if (ft1000_flarion_cnt == 0)
@@ -553,17 +549,17 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 
 		if (info->CardReady) {
 
-			/* DEBUG("FT1000:ft1000_ioctl: try to SET_DPRAM \n"); */
+			/* pr_debug("try to SET_DPRAM\n"); */
 
 			/* Get the length field to see how many bytes to copy */
 			result = get_user(msgsz, (__u16 __user *)argp);
 			if (result)
 				break;
 			msgsz = ntohs(msgsz);
-			/* DEBUG("FT1000:ft1000_ioctl: length of message = %d\n", msgsz); */
+			/* pr_debug("length of message = %d\n", msgsz); */
 
 			if (msgsz > MAX_CMD_SQSIZE) {
-				DEBUG("FT1000:ft1000_ioctl: bad message length = %d\n", msgsz);
+				pr_debug("bad message length = %d\n", msgsz);
 				result = -EINVAL;
 				break;
 			}
@@ -574,7 +570,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 				break;
 
 			if (copy_from_user(dpram_data, argp, msgsz+2)) {
-				DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
+				pr_debug("copy fault occurred\n");
 				result = -EFAULT;
 			} else {
 				/* Check if this message came from a registered application */
@@ -584,7 +580,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 					}
 				}
 				if (i == MAX_NUM_APP) {
-					DEBUG("FT1000:No matching application fileobject\n");
+					pr_debug("No matching application fileobject\n");
 					result = -EINVAL;
 					kfree(dpram_data);
 					break;
@@ -593,13 +589,13 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 
 				/* Check message qtype type which is the lower byte within qos_class */
 				qtype = ntohs(dpram_data->pseudohdr.qos_class) & 0xff;
-				/* DEBUG("FT1000_ft1000_ioctl: qtype = %d\n", qtype); */
+				/* pr_debug("qtype = %d\n", qtype); */
 				if (qtype) {
 				} else {
 					/* Put message into Slow Queue */
 					/* Only put a message into the DPRAM if msg doorbell is available */
 					status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
-					/* DEBUG("FT1000_ft1000_ioctl: READ REGISTER tempword=%x\n", tempword); */
+					/* pr_debug("READ REGISTER tempword=%x\n", tempword); */
 					if (tempword & FT1000_DB_DPRAM_TX) {
 						/* Suspend for 2ms and try again due to DSP doorbell busy */
 						mdelay(2);
@@ -615,7 +611,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 									mdelay(3);
 									status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
 									if (tempword & FT1000_DB_DPRAM_TX) {
-										DEBUG("FT1000:ft1000_ioctl:Doorbell not available\n");
+										pr_debug("Doorbell not available\n");
 										result = -ENOTTY;
 										kfree(dpram_data);
 										break;
@@ -625,7 +621,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 						}
 					}
 
-					/*DEBUG("FT1000_ft1000_ioctl: finished reading register\n"); */
+					/*pr_debug("finished reading register\n"); */
 
 					/* Make sure we are within the limits of the slow queue memory limitation */
 					if ((msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ)) {
@@ -642,10 +638,10 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 						ppseudo_hdr->portsrc = ft1000dev->app_info[app_index].app_id;
 						/* Calculate new checksum */
 						ppseudo_hdr->checksum = *pmsg++;
-						/* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
+						/* pr_debug("checksum = 0x%x\n", ppseudo_hdr->checksum); */
 						for (i = 1; i < 7; i++) {
 							ppseudo_hdr->checksum ^= *pmsg++;
-							/* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
+							/* pr_debug("checksum = 0x%x\n", ppseudo_hdr->checksum); */
 						}
 						pmsg++;
 						ppseudo_hdr = (struct pseudo_hdr *)pmsg;
@@ -659,7 +655,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 				}
 			}
 		} else {
-			DEBUG("FT1000:ft1000_ioctl: Card not ready take messages\n");
+			pr_debug("Card not ready take messages\n");
 			result = -EACCES;
 		}
 		kfree(dpram_data);
@@ -672,7 +668,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 		struct IOCTL_DPRAM_BLK __user *pioctl_dpram;
 		int msglen;
 
-		/* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM called\n"); */
+		/* pr_debug("IOCTL_FT1000_GET_DPRAM called\n"); */
 
 		if (ft1000_flarion_cnt == 0)
 			return -EBADF;
@@ -680,14 +676,14 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 		/* Search for matching file object */
 		for (i = 0; i < MAX_NUM_APP; i++) {
 			if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
-				/*DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
+				/*pr_debug("Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
 				break;
 			}
 		}
 
 		/* Could not find application info block */
 		if (i == MAX_NUM_APP) {
-			DEBUG("FT1000:ft1000_ioctl:Could not find application info block\n");
+			pr_debug("Could not find application info block\n");
 			result = -EBADF;
 			break;
 		}
@@ -695,21 +691,21 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 		result = 0;
 		pioctl_dpram = argp;
 		if (list_empty(&ft1000dev->app_info[i].app_sqlist) == 0) {
-			/* DEBUG("FT1000:ft1000_ioctl:Message detected in slow queue\n"); */
+			/* pr_debug("Message detected in slow queue\n"); */
 			spin_lock_irqsave(&free_buff_lock, flags);
 			pdpram_blk = list_entry(ft1000dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
 			list_del(&pdpram_blk->list);
 			ft1000dev->app_info[i].NumOfMsg--;
-			/* DEBUG("FT1000:ft1000_ioctl:NumOfMsg for app %d = %d\n", i, ft1000dev->app_info[i].NumOfMsg); */
+			/* pr_debug("NumOfMsg for app %d = %d\n", i, ft1000dev->app_info[i].NumOfMsg); */
 			spin_unlock_irqrestore(&free_buff_lock, flags);
 			msglen = ntohs(*(u16 *)pdpram_blk->pbuffer) + PSEUDOSZ;
 			result = get_user(msglen, &pioctl_dpram->total_len);
 			if (result)
 				break;
 			msglen = htons(msglen);
-			/* DEBUG("FT1000:ft1000_ioctl:msg length = %x\n", msglen); */
+			/* pr_debug("msg length = %x\n", msglen); */
 			if (copy_to_user(&pioctl_dpram->pseudohdr, pdpram_blk->pbuffer, msglen)) {
-				DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
+				pr_debug("copy fault occurred\n");
 				result = -EFAULT;
 				break;
 			}
@@ -717,12 +713,12 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 			ft1000_free_buffer(pdpram_blk, &freercvpool);
 			result = msglen;
 		}
-		/* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM no message\n"); */
+		/* pr_debug("IOCTL_FT1000_GET_DPRAM no message\n"); */
 	}
 	break;
 
 	default:
-		DEBUG("FT1000:ft1000_ioctl:unknown command: 0x%x\n", command);
+		pr_debug("unknown command: 0x%x\n", command);
 		result = -ENOTTY;
 		break;
 	}
@@ -750,8 +746,6 @@ static int ft1000_release(struct inode *inode, struct file *file)
 	int i;
 	struct dpram_blk *pdpram_blk;
 
-	DEBUG("ft1000_release called\n");
-
 	dev = file->private_data;
 	info = netdev_priv(dev);
 	ft1000dev = info->priv;
@@ -764,7 +758,7 @@ static int ft1000_release(struct inode *inode, struct file *file)
 	/* Search for matching file object */
 	for (i = 0; i < MAX_NUM_APP; i++) {
 		if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
-			/* DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
+			/* pr_debug("Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
 			break;
 		}
 	}
@@ -773,7 +767,7 @@ static int ft1000_release(struct inode *inode, struct file *file)
 		return 0;
 
 	while (list_empty(&ft1000dev->app_info[i].app_sqlist) == 0) {
-		DEBUG("Remove and free memory queue up on slow queue\n");
+		pr_debug("Remove and free memory queue up on slow queue\n");
 		pdpram_blk = list_entry(ft1000dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
 		list_del(&pdpram_blk->list);
 		ft1000_free_buffer(pdpram_blk, &freercvpool);
@@ -781,7 +775,7 @@ static int ft1000_release(struct inode *inode, struct file *file)
 
 	/* initialize application information */
 	ft1000dev->appcnt--;
-	DEBUG("ft1000_chdev:%s:appcnt = %d\n", __func__, ft1000dev->appcnt);
+	pr_debug("appcnt = %d\n", ft1000dev->appcnt);
 	ft1000dev->app_info[i].fileobject = NULL;
 
 	return 0;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 2cce422..e8126325 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -4,6 +4,8 @@
  * This file is part of Express Card USB Driver
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
@@ -118,10 +120,9 @@ static int check_usb_db(struct ft1000_usb *ft1000dev)
 	while (loopcnt < 10) {
 		status = ft1000_read_register(ft1000dev, &temp,
 					      FT1000_REG_DOORBELL);
-		DEBUG("check_usb_db: read FT1000_REG_DOORBELL value is %x\n",
-		      temp);
+		pr_debug("read FT1000_REG_DOORBELL value is %x\n", temp);
 		if (temp & 0x0080) {
-			DEBUG("FT1000:Got checkusb doorbell\n");
+			pr_debug("Got checkusb doorbell\n");
 			status = ft1000_write_register(ft1000dev, 0x0080,
 						       FT1000_REG_DOORBELL);
 			status = ft1000_write_register(ft1000dev, 0x0100,
@@ -139,12 +140,12 @@ static int check_usb_db(struct ft1000_usb *ft1000dev)
 	while (loopcnt < 20) {
 		status = ft1000_read_register(ft1000dev, &temp,
 					      FT1000_REG_DOORBELL);
-		DEBUG("FT1000:check_usb_db:Doorbell = 0x%x\n", temp);
+		pr_debug("Doorbell = 0x%x\n", temp);
 		if (temp & 0x8000) {
 			loopcnt++;
 			msleep(10);
 		} else	{
-			DEBUG("check_usb_db: door bell is cleared, return 0\n");
+			pr_debug("door bell is cleared, return 0\n");
 			return 0;
 		}
 	}
@@ -166,12 +167,11 @@ static u16 get_handshake(struct ft1000_usb *ft1000dev, u16 expected_value)
 		status = ft1000_write_register(ft1000dev,  FT1000_DB_DNLD_RX,
 					       FT1000_REG_DOORBELL);
 		if (ft1000dev->fcodeldr) {
-			DEBUG(" get_handshake: fcodeldr is %d\n",
-			      ft1000dev->fcodeldr);
+			pr_debug("fcodeldr is %d\n", ft1000dev->fcodeldr);
 			ft1000dev->fcodeldr = 0;
 			status = check_usb_db(ft1000dev);
 			if (status != 0) {
-				DEBUG("get_handshake: check_usb_db failed\n");
+				pr_debug("check_usb_db failed\n");
 				break;
 			}
 			status = ft1000_write_register(ft1000dev,
@@ -232,14 +232,14 @@ static u16 get_handshake_usb(struct ft1000_usb *ft1000dev, u16 expected_value)
 			status = ft1000_read_dpram32(ft1000dev, 0,
 						     (u8 *)&(ft1000dev->tempbuf[0]), 64);
 			for (temp = 0; temp < 16; temp++) {
-				DEBUG("tempbuf %d = 0x%x\n", temp,
-				      ft1000dev->tempbuf[temp]);
+				pr_debug("tempbuf %d = 0x%x\n",
+					 temp, ft1000dev->tempbuf[temp]);
 			}
 			status = ft1000_read_dpram16(ft1000dev,
 						     DWNLD_MAG1_HANDSHAKE_LOC,
 						     (u8 *)&handshake, 1);
-			DEBUG("handshake from read_dpram16 = 0x%x\n",
-			      handshake);
+			pr_debug("handshake from read_dpram16 = 0x%x\n",
+				 handshake);
 			if (ft1000dev->dspalive == ft1000dev->tempbuf[6]) {
 				handshake = 0;
 			} else {
@@ -409,7 +409,7 @@ static int write_dpram32_and_check(struct ft1000_usb *ft1000dev,
 			if ((tempbuffer[31] & 0xfe00) == 0xfe00) {
 				if (check_buffers(tempbuffer, resultbuffer, 28,
 						  0)) {
-					DEBUG("FT1000:download:DPRAM write failed 1 during bootloading\n");
+					pr_debug("DPRAM write failed 1 during bootloading\n");
 					usleep_range(9000, 11000);
 					break;
 				}
@@ -419,14 +419,14 @@ static int write_dpram32_and_check(struct ft1000_usb *ft1000dev,
 
 				if (check_buffers(tempbuffer, resultbuffer, 16,
 						  24)) {
-					DEBUG("FT1000:download:DPRAM write failed 2 during bootloading\n");
+					pr_debug("DPRAM write failed 2 during bootloading\n");
 					usleep_range(9000, 11000);
 					break;
 				}
 			} else {
 				if (check_buffers(tempbuffer, resultbuffer, 32,
 						  0)) {
-					DEBUG("FT1000:download:DPRAM write failed 3 during bootloading\n");
+					pr_debug("DPRAM write failed 3 during bootloading\n");
 					usleep_range(9000, 11000);
 					break;
 				}
@@ -453,7 +453,7 @@ static int write_blk(struct ft1000_usb *ft1000dev, u16 **pUsFile, u8 **pUcFile,
 	u16 tempword;
 	u16 tempbuffer[64];
 
-	/*DEBUG("FT1000:download:start word_length = %d\n",(int)word_length); */
+	/*pr_debug("start word_length = %d\n",(int)word_length); */
 	dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
 	tempword = *(*pUsFile);
 	(*pUsFile)++;
@@ -483,9 +483,9 @@ static int write_blk(struct ft1000_usb *ft1000dev, u16 **pUsFile, u8 **pUcFile,
 			}
 		}
 
-		/*DEBUG("write_blk: loopcnt is %d\n", loopcnt); */
-		/*DEBUG("write_blk: bootmode = %d\n", bootmode); */
-		/*DEBUG("write_blk: dpram = %x\n", dpram); */
+		/*pr_debug("loopcnt is %d\n", loopcnt); */
+		/*pr_debug("write_blk: bootmode = %d\n", bootmode); */
+		/*pr_debug("write_blk: dpram = %x\n", dpram); */
 		if (ft1000dev->bootmode == 0) {
 			if (dpram >= 0x3F4)
 				status = ft1000_write_dpram32(ft1000dev, dpram,
@@ -497,7 +497,8 @@ static int write_blk(struct ft1000_usb *ft1000dev, u16 **pUsFile, u8 **pUcFile,
 			status = write_dpram32_and_check(ft1000dev, tempbuffer,
 							 dpram);
 			if (status != 0) {
-				DEBUG("FT1000:download:Write failed tempbuffer[31] = 0x%x\n", tempbuffer[31]);
+				pr_debug("Write failed tempbuffer[31] = 0x%x\n",
+					 tempbuffer[31]);
 				break;
 			}
 		}
@@ -508,7 +509,7 @@ static int write_blk(struct ft1000_usb *ft1000dev, u16 **pUsFile, u8 **pUcFile,
 
 static void usb_dnld_complete(struct urb *urb)
 {
-	/* DEBUG("****** usb_dnld_complete\n"); */
+	/* pr_debug("****** usb_dnld_complete\n"); */
 }
 
 /* writes a block of DSP image to DPRAM
@@ -552,18 +553,17 @@ static int scram_start_dwnld(struct ft1000_usb *ft1000dev, u16 *hshake,
 {
 	int status = 0;
 
-	DEBUG("FT1000:STATE_START_DWNLD\n");
 	if (ft1000dev->usbboot)
 		*hshake = get_handshake_usb(ft1000dev, HANDSHAKE_DSP_BL_READY);
 	else
 		*hshake = get_handshake(ft1000dev, HANDSHAKE_DSP_BL_READY);
 	if (*hshake == HANDSHAKE_DSP_BL_READY) {
-		DEBUG("scram_dnldr: handshake is HANDSHAKE_DSP_BL_READY, call put_handshake(HANDSHAKE_DRIVER_READY)\n");
+		pr_debug("handshake is HANDSHAKE_DSP_BL_READY, call put_handshake(HANDSHAKE_DRIVER_READY)\n");
 		put_handshake(ft1000dev, HANDSHAKE_DRIVER_READY);
 	} else if (*hshake == HANDSHAKE_TIMEOUT_VALUE) {
 		status = -ETIMEDOUT;
 	} else {
-		DEBUG("FT1000:download:Download error: Handshake failed\n");
+		pr_debug("Download error: Handshake failed\n");
 		status = -ENETRESET;
 	}
 	*state = STATE_BOOT_DWNLD;
@@ -576,17 +576,17 @@ static int request_code_segment(struct ft1000_usb *ft1000dev, u16 **s_file,
 	long word_length;
 	int status = 0;
 
-	/*DEBUG("FT1000:REQUEST_CODE_SEGMENT\n");i*/
 	word_length = get_request_value(ft1000dev);
-	/*DEBUG("FT1000:word_length = 0x%x\n", (int)word_length); */
+	/*pr_debug("word_length = 0x%x\n", (int)word_length); */
 	/*NdisMSleep (100); */
 	if (word_length > MAX_LENGTH) {
-		DEBUG("FT1000:download:Download error: Max length exceeded\n");
+		pr_debug("Download error: Max length exceeded\n");
 		return -1;
 	}
 	if ((word_length * 2 + (long)c_file) > (long)endpoint) {
 		/* Error, beyond boot code range.*/
-		DEBUG("FT1000:download:Download error: Requested len=%d exceeds BOOT code boundary.\n", (int)word_length);
+		pr_debug("Download error: Requested len=%d exceeds BOOT code boundary\n",
+			 (int)word_length);
 		return -1;
 	}
 	if (word_length & 0x1)
@@ -595,7 +595,7 @@ static int request_code_segment(struct ft1000_usb *ft1000dev, u16 **s_file,
 
 	if (boot_case) {
 		status = write_blk(ft1000dev, s_file, c_file, word_length);
-		/*DEBUG("write_blk returned %d\n", status); */
+		/*pr_debug("write_blk returned %d\n", status); */
 	} else {
 		status = write_blk_fifo(ft1000dev, s_file, c_file, word_length);
 		if (ft1000dev->usbboot == 0)
@@ -641,8 +641,6 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 	struct prov_record *pprov_record;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
-	DEBUG("Entered   scram_dnldr...\n");
-
 	ft1000dev->fcodeldr = 0;
 	ft1000dev->usbboot = 0;
 	ft1000dev->dspalive = 0xffff;
@@ -674,7 +672,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 			break;
 
 		case STATE_BOOT_DWNLD:
-			DEBUG("FT1000:STATE_BOOT_DWNLD\n");
+			pr_debug("STATE_BOOT_DWNLD\n");
 			ft1000dev->bootmode = 1;
 			handshake = get_handshake(ft1000dev, HANDSHAKE_REQUEST);
 			if (handshake == HANDSHAKE_REQUEST) {
@@ -684,22 +682,22 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 				request = get_request_type(ft1000dev);
 				switch (request) {
 				case REQUEST_RUN_ADDRESS:
-					DEBUG("FT1000:REQUEST_RUN_ADDRESS\n");
+					pr_debug("REQUEST_RUN_ADDRESS\n");
 					put_request_value(ft1000dev,
 							  loader_code_address);
 					break;
 				case REQUEST_CODE_LENGTH:
-					DEBUG("FT1000:REQUEST_CODE_LENGTH\n");
+					pr_debug("REQUEST_CODE_LENGTH\n");
 					put_request_value(ft1000dev,
 							  loader_code_size);
 					break;
 				case REQUEST_DONE_BL:
-					DEBUG("FT1000:REQUEST_DONE_BL\n");
+					pr_debug("REQUEST_DONE_BL\n");
 					/* Reposition ptrs to beginning of code section */
 					s_file = (u16 *) (boot_end);
 					c_file = (u8 *) (boot_end);
-					/* DEBUG("FT1000:download:s_file = 0x%8x\n", (int)s_file); */
-					/* DEBUG("FT1000:download:c_file = 0x%8x\n", (int)c_file); */
+					/* pr_debug("download:s_file = 0x%8x\n", (int)s_file); */
+					/* pr_debug("FT1000:download:c_file = 0x%8x\n", (int)c_file); */
 					state = STATE_CODE_DWNLD;
 					ft1000dev->fcodeldr = 1;
 					break;
@@ -710,8 +708,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 								      true);
 					break;
 				default:
-					DEBUG
-						("FT1000:download:Download error: Bad request type=%d in BOOT download state.\n",
+					pr_debug("Download error: Bad request type=%d in BOOT download state\n",
 						 request);
 					status = -1;
 					break;
@@ -723,15 +720,14 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					put_handshake(ft1000dev,
 						      HANDSHAKE_RESPONSE);
 			} else {
-				DEBUG
-					("FT1000:download:Download error: Handshake failed\n");
+				pr_debug("Download error: Handshake failed\n");
 				status = -1;
 			}
 
 			break;
 
 		case STATE_CODE_DWNLD:
-			/* DEBUG("FT1000:STATE_CODE_DWNLD\n"); */
+			/* pr_debug("STATE_CODE_DWNLD\n"); */
 			ft1000dev->bootmode = 0;
 			if (ft1000dev->usbboot)
 				handshake =
@@ -751,40 +747,33 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					request = get_request_type(ft1000dev);
 				switch (request) {
 				case REQUEST_FILE_CHECKSUM:
-					DEBUG
-						("FT1000:download:image_chksum = 0x%8x\n",
+					pr_debug("image_chksum = 0x%8x\n",
 						 image_chksum);
 					put_request_value(ft1000dev,
 							  image_chksum);
 					break;
 				case REQUEST_RUN_ADDRESS:
-					DEBUG
-						("FT1000:download:  REQUEST_RUN_ADDRESS\n");
+					pr_debug("REQUEST_RUN_ADDRESS\n");
 					if (correct_version) {
-						DEBUG
-							("FT1000:download:run_address = 0x%8x\n",
+						pr_debug("run_address = 0x%8x\n",
 							 (int)run_address);
 						put_request_value(ft1000dev,
 								  run_address);
 					} else {
-						DEBUG
-							("FT1000:download:Download error: Got Run address request before image offset request.\n");
+						pr_debug("Download error: Got Run address request before image offset request\n");
 						status = -1;
 						break;
 					}
 					break;
 				case REQUEST_CODE_LENGTH:
-					DEBUG
-						("FT1000:download:REQUEST_CODE_LENGTH\n");
+					pr_debug("REQUEST_CODE_LENGTH\n");
 					if (correct_version) {
-						DEBUG
-							("FT1000:download:run_size = 0x%8x\n",
+						pr_debug("run_size = 0x%8x\n",
 							 (int)run_size);
 						put_request_value(ft1000dev,
 								  run_size);
 					} else {
-						DEBUG
-							("FT1000:download:Download error: Got Size request before image offset request.\n");
+						pr_debug("Download error: Got Size request before image offset request\n");
 						status = -1;
 						break;
 					}
@@ -801,10 +790,9 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					state = STATE_DONE_DWNLD;
 					break;
 				case REQUEST_CODE_SEGMENT:
-					/* DEBUG("FT1000:download: REQUEST_CODE_SEGMENT - CODELOADER\n"); */
+					/* pr_debug("REQUEST_CODE_SEGMENT - CODELOADER\n"); */
 					if (!correct_version) {
-						DEBUG
-							("FT1000:download:Download error: Got Code Segment request before image offset request.\n");
+						pr_debug("Download error: Got Code Segment request before image offset request\n");
 						status = -1;
 						break;
 					}
@@ -817,8 +805,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					break;
 
 				case REQUEST_MAILBOX_DATA:
-					DEBUG
-						("FT1000:download: REQUEST_MAILBOX_DATA\n");
+					pr_debug("REQUEST_MAILBOX_DATA\n");
 					/* Convert length from byte count to word count. Make sure we round up. */
 					word_length =
 						(long)(pft1000info->DSPInfoBlklen +
@@ -852,8 +839,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					break;
 
 				case REQUEST_VERSION_INFO:
-					DEBUG
-						("FT1000:download:REQUEST_VERSION_INFO\n");
+					pr_debug("REQUEST_VERSION_INFO\n");
 					word_length =
 						file_hdr->version_data_size;
 					put_request_value(ft1000dev,
@@ -887,8 +873,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					break;
 
 				case REQUEST_CODE_BY_VERSION:
-					DEBUG
-						("FT1000:download:REQUEST_CODE_BY_VERSION\n");
+					pr_debug("REQUEST_CODE_BY_VERSION\n");
 					correct_version = false;
 					requested_version =
 						get_request_value(ft1000dev);
@@ -907,8 +892,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 						if (dsp_img_info->version ==
 						    requested_version) {
 							correct_version = true;
-							DEBUG
-								("FT1000:download: correct_version is TRUE\n");
+							pr_debug("correct_version is TRUE\n");
 							s_file =
 								(u16 *) (pFileStart
 									 +
@@ -941,8 +925,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 						/*
 						 * Error, beyond boot code range.
 						 */
-						DEBUG
-							("FT1000:download:Download error: Bad Version Request = 0x%x.\n",
+						pr_debug("Download error: Bad Version Request = 0x%x.\n",
 							 (int)requested_version);
 						status = -1;
 						break;
@@ -950,8 +933,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					break;
 
 				default:
-					DEBUG
-						("FT1000:download:Download error: Bad request type=%d in CODE download state.\n",
+					pr_debug("Download error: Bad request type=%d in CODE download state.\n",
 						 request);
 					status = -1;
 					break;
@@ -963,20 +945,19 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					put_handshake(ft1000dev,
 						      HANDSHAKE_RESPONSE);
 			} else {
-				DEBUG
-					("FT1000:download:Download error: Handshake failed\n");
+				pr_debug("Download error: Handshake failed\n");
 				status = -1;
 			}
 
 			break;
 
 		case STATE_DONE_DWNLD:
-			DEBUG("FT1000:download:Code loader is done...\n");
+			pr_debug("Code loader is done...\n");
 			state = STATE_SECTION_PROV;
 			break;
 
 		case STATE_SECTION_PROV:
-			DEBUG("FT1000:download:STATE_SECTION_PROV\n");
+			pr_debug("STATE_SECTION_PROV\n");
 			pseudo_header = (struct pseudo_hdr *)c_file;
 
 			if (pseudo_header->checksum ==
@@ -1031,13 +1012,12 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 				/* Checksum did not compute */
 				status = -1;
 			}
-			DEBUG
-				("ft1000:download: after STATE_SECTION_PROV, state = %d, status= %d\n",
+			pr_debug("after STATE_SECTION_PROV, state = %d, status= %d\n",
 				 state, status);
 			break;
 
 		case STATE_DONE_PROV:
-			DEBUG("FT1000:download:STATE_DONE_PROV\n");
+			pr_debug("STATE_DONE_PROV\n");
 			state = STATE_DONE_FILE;
 			break;
 
@@ -1064,7 +1044,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 
 	}			/* End while */
 
-	DEBUG("Download exiting with status = 0x%8x\n", status);
+	pr_debug("Download exiting with status = 0x%8x\n", status);
 	ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX,
 			      FT1000_REG_DOORBELL);
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index da11955..d12cfc9 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -4,6 +4,8 @@
  * This file is part of Express Card USB Driver
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
@@ -52,7 +54,7 @@ static int ft1000_control(struct ft1000_usb *ft1000dev, unsigned int pipe,
 	int ret;
 
 	if ((ft1000dev == NULL) || (ft1000dev->dev == NULL)) {
-		DEBUG("ft1000dev or ft1000dev->dev == NULL, failure\n");
+		pr_debug("ft1000dev or ft1000dev->dev == NULL, failure\n");
 		return -ENODEV;
 	}
 
@@ -212,7 +214,7 @@ int fix_ft1000_read_dpram32(struct ft1000_usb *ft1000dev, u16 indx,
 		*buffer++ = buf[pos++];
 		*buffer++ = buf[pos++];
 	} else {
-		DEBUG("fix_ft1000_read_dpram32: DPRAM32 Read failed\n");
+		pr_debug("DPRAM32 Read failed\n");
 		*buffer++ = 0;
 		*buffer++ = 0;
 		*buffer++ = 0;
@@ -246,7 +248,7 @@ int fix_ft1000_write_dpram32(struct ft1000_usb *ft1000dev, u16 indx, u8 *buffer)
 		buf[pos2++] = *buffer++;
 		ret = ft1000_write_dpram32(ft1000dev, pos1, buf, 16);
 	} else {
-		DEBUG("fix_ft1000_write_dpram32: DPRAM32 Read failed\n");
+		pr_debug("DPRAM32 Read failed\n");
 		return ret;
 	}
 
@@ -270,8 +272,7 @@ int fix_ft1000_write_dpram32(struct ft1000_usb *ft1000dev, u16 indx, u8 *buffer)
 			for (i = 0; i < 16; i++) {
 				if (tempbuffer[i] != resultbuffer[i]) {
 					ret = -1;
-					DEBUG("%s Failed to write\n",
-					      __func__);
+					pr_debug("Failed to write\n");
 				}
 			}
 		}
@@ -292,14 +293,14 @@ static void card_reset_dsp(struct ft1000_usb *ft1000dev, bool value)
 				      FT1000_REG_SUP_CTRL);
 
 	if (value) {
-		DEBUG("Reset DSP\n");
+		pr_debug("Reset DSP\n");
 		status = ft1000_read_register(ft1000dev, &tempword,
 					      FT1000_REG_RESET);
 		tempword |= DSP_RESET_BIT;
 		status = ft1000_write_register(ft1000dev, tempword,
 					       FT1000_REG_RESET);
 	} else {
-		DEBUG("Activate DSP\n");
+		pr_debug("Activate DSP\n");
 		status = ft1000_read_register(ft1000dev, &tempword,
 					      FT1000_REG_RESET);
 		tempword |= DSP_ENCRYPTED;
@@ -329,7 +330,7 @@ int card_send_command(struct ft1000_usb *ft1000dev, void *ptempbuffer,
 	unsigned short temp;
 	unsigned char *commandbuf;
 
-	DEBUG("card_send_command: enter card_send_command... size=%d\n", size);
+	pr_debug("enter card_send_command... size=%d\n", size);
 
 	commandbuf = kmalloc(size + 2, GFP_KERNEL);
 	if (!commandbuf)
@@ -364,7 +365,7 @@ int card_send_command(struct ft1000_usb *ft1000dev, void *ptempbuffer,
 
 #if 0
 	if ((temp & 0x0100) == 0)
-		DEBUG("card_send_command: Message sent\n");
+		pr_debug("Message sent\n");
 #endif
 	return ret;
 }
@@ -390,7 +391,7 @@ int dsp_reload(struct ft1000_usb *ft1000dev)
 	status = ft1000_write_register(ft1000dev, tempword, FT1000_REG_RESET);
 	msleep(1000);
 	status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_RESET);
-	DEBUG("Reset Register = 0x%x\n", tempword);
+	pr_debug("Reset Register = 0x%x\n", tempword);
 
 	/* Toggle DSP reset */
 	card_reset_dsp(ft1000dev, 1);
@@ -405,7 +406,7 @@ int dsp_reload(struct ft1000_usb *ft1000dev)
 	status =
 		ft1000_read_dpram32(ft1000dev, FT1000_MAG_DPRAM_FEFE_INDX,
 				    (u8 *)&templong, 4);
-	DEBUG("templong (fefe) = 0x%8x\n", templong);
+	pr_debug("templong (fefe) = 0x%8x\n", templong);
 
 	/* call codeloader */
 	status = scram_dnldr(ft1000dev, pFileStart, FileLength);
@@ -415,8 +416,6 @@ int dsp_reload(struct ft1000_usb *ft1000dev)
 
 	msleep(1000);
 
-	DEBUG("dsp_reload returned\n");
-
 	return 0;
 }
 
@@ -427,8 +426,6 @@ static void ft1000_reset_asic(struct net_device *dev)
 	struct ft1000_usb *ft1000dev = info->priv;
 	u16 tempword;
 
-	DEBUG("ft1000_hw:ft1000_reset_asic called\n");
-
 	/* Let's use the register provided by the Magnemite ASIC to reset the
 	 * ASIC and DSP.
 	 */
@@ -442,10 +439,10 @@ static void ft1000_reset_asic(struct net_device *dev)
 
 	/* clear interrupts */
 	ft1000_read_register(ft1000dev, &tempword, FT1000_REG_SUP_ISR);
-	DEBUG("ft1000_hw: interrupt status register = 0x%x\n", tempword);
+	pr_debug("interrupt status register = 0x%x\n", tempword);
 	ft1000_write_register(ft1000dev, tempword, FT1000_REG_SUP_ISR);
 	ft1000_read_register(ft1000dev, &tempword, FT1000_REG_SUP_ISR);
-	DEBUG("ft1000_hw: interrupt status register = 0x%x\n", tempword);
+	pr_debug("interrupt status register = 0x%x\n", tempword);
 }
 
 static int ft1000_reset_card(struct net_device *dev)
@@ -455,15 +452,13 @@ static int ft1000_reset_card(struct net_device *dev)
 	u16 tempword;
 	struct prov_record *ptr;
 
-	DEBUG("ft1000_hw:ft1000_reset_card called.....\n");
-
 	ft1000dev->fCondResetPend = true;
 	info->CardReady = 0;
 	ft1000dev->fProvComplete = false;
 
 	/* Make sure we free any memory reserve for provisioning */
 	while (list_empty(&info->prov_list) == 0) {
-		DEBUG("ft1000_reset_card:deleting provisioning record\n");
+		pr_debug("deleting provisioning record\n");
 		ptr =
 			list_entry(info->prov_list.next, struct prov_record, list);
 		list_del(&ptr->list);
@@ -471,13 +466,13 @@ static int ft1000_reset_card(struct net_device *dev)
 		kfree(ptr);
 	}
 
-	DEBUG("ft1000_hw:ft1000_reset_card: reset asic\n");
+	pr_debug("reset asic\n");
 	ft1000_reset_asic(dev);
 
-	DEBUG("ft1000_hw:ft1000_reset_card: call dsp_reload\n");
+	pr_debug("call dsp_reload\n");
 	dsp_reload(ft1000dev);
 
-	DEBUG("dsp reload successful\n");
+	pr_debug("dsp reload successful\n");
 
 	mdelay(10);
 
@@ -486,7 +481,7 @@ static int ft1000_reset_card(struct net_device *dev)
 			     FT1000_MAG_HI_HO_INDX);
 	ft1000_read_dpram16(ft1000dev, FT1000_MAG_HI_HO, (u8 *)&tempword,
 			    FT1000_MAG_HI_HO_INDX);
-	DEBUG("ft1000_hw:ft1000_reset_card:hi_ho value = 0x%x\n", tempword);
+	pr_debug("hi_ho value = 0x%x\n", tempword);
 
 	info->CardReady = 1;
 
@@ -520,14 +515,13 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 *packet, u16 len)
 	struct pseudo_hdr hdr;
 
 	if (!pInfo->CardReady) {
-		DEBUG("ft1000_copy_down_pkt::Card Not Ready\n");
+		pr_debug("Card Not Ready\n");
 		return -ENODEV;
 	}
 
 	count = sizeof(struct pseudo_hdr) + len;
 	if (count > MAX_BUF_SIZE) {
-		DEBUG("Error:ft1000_copy_down_pkt:Message Size Overflow!\n");
-		DEBUG("size = %d\n", count);
+		pr_debug("Message Size Overflow! size = %d\n", count);
 		return -EINVAL;
 	}
 
@@ -564,7 +558,7 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 *packet, u16 len)
 	ret = usb_submit_urb(pFt1000Dev->tx_urb, GFP_ATOMIC);
 
 	if (ret) {
-		DEBUG("ft1000 failed tx_urb %d\n", ret);
+		pr_debug("failed tx_urb %d\n", ret);
 		return ret;
 	}
 	pInfo->stats.tx_packets++;
@@ -585,12 +579,12 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	int maxlen, pipe;
 
 	if (skb == NULL) {
-		DEBUG("ft1000_hw: ft1000_start_xmit:skb == NULL!!!\n");
+		pr_debug("skb == NULL!!!\n");
 		return NETDEV_TX_OK;
 	}
 
 	if (pFt1000Dev->status & FT1000_STATUS_CLOSING) {
-		DEBUG("network driver is closed, return\n");
+		pr_debug("network driver is closed, return\n");
 		goto err;
 	}
 
@@ -602,13 +596,13 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (pInfo->mediastate == 0) {
 		/* Drop packet is mediastate is down */
-		DEBUG("ft1000_hw:ft1000_start_xmit:mediastate is down\n");
+		pr_debug("mediastate is down\n");
 		goto err;
 	}
 
 	if ((skb->len < ENET_HEADER_SIZE) || (skb->len > ENET_MAX_SIZE)) {
 		/* Drop packet which has invalid size */
-		DEBUG("ft1000_hw:ft1000_start_xmit:invalid ethernet length\n");
+		pr_debug("invalid ethernet length\n");
 		goto err;
 	}
 
@@ -628,7 +622,7 @@ static int ft1000_open(struct net_device *dev)
 	struct ft1000_usb *pFt1000Dev = pInfo->priv;
 	struct timeval tv;
 
-	DEBUG("ft1000_open is called for card %d\n", pFt1000Dev->CardNumber);
+	pr_debug("ft1000_open is called for card %d\n", pFt1000Dev->CardNumber);
 
 	pInfo->stats.rx_bytes = 0;
 	pInfo->stats.tx_bytes = 0;
@@ -676,11 +670,9 @@ int init_ft1000_netdev(struct ft1000_usb *ft1000dev)
 	char card_nr[2];
 	u8 gCardIndex = 0;
 
-	DEBUG("Enter init_ft1000_netdev...\n");
-
 	netdev = alloc_etherdev(sizeof(struct ft1000_info));
 	if (!netdev) {
-		DEBUG("init_ft1000_netdev: can not allocate network device\n");
+		pr_debug("can not allocate network device\n");
 		return -ENOMEM;
 	}
 
@@ -690,7 +682,7 @@ int init_ft1000_netdev(struct ft1000_usb *ft1000dev)
 
 	dev_alloc_name(netdev, netdev->name);
 
-	DEBUG("init_ft1000_netdev: network device name is %s\n", netdev->name);
+	pr_debug("network device name is %s\n", netdev->name);
 
 	if (strncmp(netdev->name, "eth", 3) == 0) {
 		card_nr[0] = netdev->name[3];
@@ -702,7 +694,7 @@ int init_ft1000_netdev(struct ft1000_usb *ft1000dev)
 		}
 
 		ft1000dev->CardNumber = gCardIndex;
-		DEBUG("card number = %d\n", ft1000dev->CardNumber);
+		pr_debug("card number = %d\n", ft1000dev->CardNumber);
 	} else {
 		netdev_err(ft1000dev->net, "ft1000: Invalid device name\n");
 		ret_val = -ENXIO;
@@ -738,7 +730,7 @@ int init_ft1000_netdev(struct ft1000_usb *ft1000dev)
 
 	ft1000dev->net = netdev;
 
-	DEBUG("Initialize free_buff_lock and freercvpool\n");
+	pr_debug("Initialize free_buff_lock and freercvpool\n");
 	spin_lock_init(&free_buff_lock);
 
 	/* initialize a list of buffers to be use for queuing
@@ -790,7 +782,6 @@ int reg_ft1000_netdev(struct ft1000_usb *ft1000dev,
 
 	netdev = ft1000dev->net;
 	pInfo = netdev_priv(ft1000dev->net);
-	DEBUG("Enter reg_ft1000_netdev...\n");
 
 	ft1000_read_register(ft1000dev, &pInfo->AsicID, FT1000_REG_ASIC_ID);
 
@@ -799,15 +790,13 @@ int reg_ft1000_netdev(struct ft1000_usb *ft1000dev,
 
 	rc = register_netdev(netdev);
 	if (rc) {
-		DEBUG("reg_ft1000_netdev: could not register network device\n");
+		pr_debug("could not register network device\n");
 		free_netdev(netdev);
 		return rc;
 	}
 
 	ft1000_create_dev(ft1000dev);
 
-	DEBUG("reg_ft1000_netdev returned\n");
-
 	pInfo->CardReady = 1;
 
 	return 0;
@@ -832,7 +821,7 @@ static int ft1000_copy_up_pkt(struct urb *urb)
 	u16 *chksum;
 
 	if (ft1000dev->status & FT1000_STATUS_CLOSING) {
-		DEBUG("network driver is closed, return\n");
+		pr_debug("network driver is closed, return\n");
 		return 0;
 	}
 	/* Read length */
@@ -854,7 +843,7 @@ static int ft1000_copy_up_pkt(struct urb *urb)
 	skb = dev_alloc_skb(len + 12 + 2);
 
 	if (skb == NULL) {
-		DEBUG("ft1000_copy_up_pkt: No Network buffers available\n");
+		pr_debug("No Network buffers available\n");
 		info->stats.rx_errors++;
 		ft1000_submit_rx_urb(info);
 		return -1;
@@ -905,7 +894,7 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info)
 	struct ft1000_usb *pFt1000Dev = info->priv;
 
 	if (pFt1000Dev->status & FT1000_STATUS_CLOSING) {
-		DEBUG("network driver is closed, return\n");
+		pr_debug("network driver is closed, return\n");
 		return -ENODEV;
 	}
 
@@ -919,8 +908,7 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info)
 	result = usb_submit_urb(pFt1000Dev->rx_urb, GFP_ATOMIC);
 
 	if (result) {
-		pr_err("ft1000_submit_rx_urb: submitting rx_urb %d failed\n",
-		       result);
+		pr_err("submitting rx_urb %d failed\n", result);
 		return result;
 	}
 
@@ -935,7 +923,7 @@ int ft1000_close(struct net_device *net)
 
 	ft1000dev->status |= FT1000_STATUS_CLOSING;
 
-	DEBUG("ft1000_close: pInfo=%p, ft1000dev=%p\n", pInfo, ft1000dev);
+	pr_debug("pInfo=%p, ft1000dev=%p\n", pInfo, ft1000dev);
 	netif_carrier_off(net);
 	netif_stop_queue(net);
 	ft1000dev->status &= ~FT1000_STATUS_CLOSING;
@@ -952,7 +940,7 @@ static int ft1000_chkcard(struct ft1000_usb *dev)
 	int status;
 
 	if (dev->fCondResetPend) {
-		DEBUG("ft1000_hw:ft1000_chkcard:Card is being reset, return FALSE\n");
+		pr_debug("Card is being reset, return FALSE\n");
 		return TRUE;
 	}
 	/* Mask register is used to check for device presence since it is never
@@ -960,7 +948,7 @@ static int ft1000_chkcard(struct ft1000_usb *dev)
 	 */
 	status = ft1000_read_register(dev, &tempword, FT1000_REG_SUP_IMASK);
 	if (tempword == 0) {
-		DEBUG("ft1000_hw:ft1000_chkcard: IMASK = 0 Card not detected\n");
+		pr_debug("IMASK = 0 Card not detected\n");
 		return FALSE;
 	}
 	/* The system will return the value of 0xffff for the version register
@@ -969,7 +957,7 @@ static int ft1000_chkcard(struct ft1000_usb *dev)
 	status = ft1000_read_register(dev, &tempword, FT1000_REG_ASIC_ID);
 	if (tempword != 0x1b01) {
 		dev->status |= FT1000_STATUS_CLOSING;
-		DEBUG("ft1000_hw:ft1000_chkcard: Version = 0xffff Card not detected\n");
+		pr_debug("Version = 0xffff Card not detected\n");
 		return FALSE;
 	}
 	return TRUE;
@@ -994,8 +982,7 @@ static bool ft1000_receive_cmd(struct ft1000_usb *dev, u16 *pbuffer,
 				    FT1000_MAG_PH_LEN_INDX);
 	size = ntohs(size) + PSEUDOSZ;
 	if (size > maxsz) {
-		DEBUG("FT1000:ft1000_receive_cmd:Invalid command length = %d\n",
-		      size);
+		pr_debug("Invalid command length = %d\n", size);
 		return FALSE;
 	}
 	ppseudohdr = (u16 *)pbuffer;
@@ -1058,17 +1045,15 @@ static int ft1000_dsp_prov(void *arg)
 	int status;
 	u16 TempShortBuf[256];
 
-	DEBUG("*** DspProv Entered\n");
-
 	while (list_empty(&info->prov_list) == 0) {
-		DEBUG("DSP Provisioning List Entry\n");
+		pr_debug("DSP Provisioning List Entry\n");
 
 		/* Check if doorbell is available */
-		DEBUG("check if doorbell is cleared\n");
+		pr_debug("check if doorbell is cleared\n");
 		status =
 			ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
 		if (status) {
-			DEBUG("ft1000_dsp_prov::ft1000_read_register error\n");
+			pr_debug("ft1000_read_register error\n");
 			break;
 		}
 
@@ -1076,7 +1061,7 @@ static int ft1000_dsp_prov(void *arg)
 			mdelay(10);
 			i++;
 			if (i == 10) {
-				DEBUG("FT1000:ft1000_dsp_prov:message drop\n");
+				pr_debug("message drop\n");
 				return -1;
 			}
 			ft1000_read_register(dev, &tempword,
@@ -1084,7 +1069,7 @@ static int ft1000_dsp_prov(void *arg)
 		}
 
 		if (!(tempword & FT1000_DB_DPRAM_TX)) {
-			DEBUG("*** Provision Data Sent to DSP\n");
+			pr_debug("*** Provision Data Sent to DSP\n");
 
 			/* Send provisioning data */
 			ptr =
@@ -1123,7 +1108,7 @@ static int ft1000_dsp_prov(void *arg)
 		usleep_range(9000, 11000);
 	}
 
-	DEBUG("DSP Provisioning List Entry finished\n");
+	pr_debug("DSP Provisioning List Entry finished\n");
 
 	msleep(100);
 
@@ -1158,37 +1143,26 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 	status = ft1000_read_dpram32(dev, 0x200, cmdbuffer, size);
 
 #ifdef JDEBUG
-	DEBUG("ft1000_proc_drvmsg:cmdbuffer\n");
-	for (i = 0; i < size; i += 5) {
-		if ((i + 5) < size)
-			DEBUG("0x%x, 0x%x, 0x%x, 0x%x, 0x%x\n", cmdbuffer[i],
-			      cmdbuffer[i + 1], cmdbuffer[i + 2],
-			      cmdbuffer[i + 3], cmdbuffer[i + 4]);
-		else {
-			for (j = i; j < size; j++)
-				DEBUG("0x%x ", cmdbuffer[j]);
-			DEBUG("\n");
-			break;
-		}
-	}
+	print_hex_dump_debug("cmdbuffer: ", HEX_DUMP_OFFSET, 16, 1,
+			     cmdbuffer, size, true);
 #endif
 	pdrvmsg = (struct drv_msg *)&cmdbuffer[2];
 	msgtype = ntohs(pdrvmsg->type);
-	DEBUG("ft1000_proc_drvmsg:Command message type = 0x%x\n", msgtype);
+	pr_debug("Command message type = 0x%x\n", msgtype);
 	switch (msgtype) {
 	case MEDIA_STATE:{
-		DEBUG("ft1000_proc_drvmsg:Command message type = MEDIA_STATE");
+		pr_debug("Command message type = MEDIA_STATE\n");
 		pmediamsg = (struct media_msg *)&cmdbuffer[0];
 		if (info->ProgConStat != 0xFF) {
 			if (pmediamsg->state) {
-				DEBUG("Media is up\n");
+				pr_debug("Media is up\n");
 				if (info->mediastate == 0) {
 					if (dev->NetDevRegDone)
 						netif_wake_queue(dev->net);
 					info->mediastate = 1;
 				}
 			} else {
-				DEBUG("Media is down\n");
+				pr_debug("Media is down\n");
 				if (info->mediastate == 1) {
 					info->mediastate = 0;
 					if (dev->NetDevRegDone)
@@ -1196,7 +1170,7 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 				}
 			}
 		} else {
-			DEBUG("Media is down\n");
+			pr_debug("Media is down\n");
 			if (info->mediastate == 1) {
 				info->mediastate = 0;
 				info->ConTm = 0;
@@ -1205,20 +1179,20 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 		break;
 	}
 	case DSP_INIT_MSG:{
-		DEBUG("ft1000_proc_drvmsg:Command message type = DSP_INIT_MSG");
+		pr_debug("Command message type = DSP_INIT_MSG\n");
 		pdspinitmsg = (struct dsp_init_msg *)&cmdbuffer[2];
 		memcpy(info->DspVer, pdspinitmsg->DspVer, DSPVERSZ);
-		DEBUG("DSPVER = 0x%2x 0x%2x 0x%2x 0x%2x\n",
-		      info->DspVer[0], info->DspVer[1], info->DspVer[2],
-		      info->DspVer[3]);
+		pr_debug("DSPVER = 0x%2x 0x%2x 0x%2x 0x%2x\n",
+			 info->DspVer[0], info->DspVer[1], info->DspVer[2],
+			 info->DspVer[3]);
 		memcpy(info->HwSerNum, pdspinitmsg->HwSerNum,
 		       HWSERNUMSZ);
 		memcpy(info->Sku, pdspinitmsg->Sku, SKUSZ);
 		memcpy(info->eui64, pdspinitmsg->eui64, EUISZ);
-		DEBUG("EUI64=%2x.%2x.%2x.%2x.%2x.%2x.%2x.%2x\n",
-		      info->eui64[0], info->eui64[1], info->eui64[2],
-		      info->eui64[3], info->eui64[4], info->eui64[5],
-		      info->eui64[6], info->eui64[7]);
+		pr_debug("EUI64=%2x.%2x.%2x.%2x.%2x.%2x.%2x.%2x\n",
+			 info->eui64[0], info->eui64[1], info->eui64[2],
+			 info->eui64[3], info->eui64[4], info->eui64[5],
+			 info->eui64[6], info->eui64[7]);
 		dev->net->dev_addr[0] = info->eui64[0];
 		dev->net->dev_addr[1] = info->eui64[1];
 		dev->net->dev_addr[2] = info->eui64[2];
@@ -1233,13 +1207,13 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 			memcpy(info->RfCalVer, pdspinitmsg->RfCalVer, CALVERSZ);
 			memcpy(info->RfCalDate, pdspinitmsg->RfCalDate,
 			       CALDATESZ);
-			DEBUG("RFCalVer = 0x%2x 0x%2x\n", info->RfCalVer[0],
-			      info->RfCalVer[1]);
+			pr_debug("RFCalVer = 0x%2x 0x%2x\n",
+				 info->RfCalVer[0], info->RfCalVer[1]);
 		}
 		break;
 	}
 	case DSP_PROVISION:{
-		DEBUG("ft1000_proc_drvmsg:Command message type = DSP_PROVISION\n");
+		pr_debug("Command message type = DSP_PROVISION\n");
 
 		/* kick off dspprov routine to start provisioning
 		 * Send provisioning data to DSP
@@ -1253,20 +1227,19 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 			dev->fProvComplete = true;
 			status = ft1000_write_register(dev, FT1000_DB_HB,
 						       FT1000_REG_DOORBELL);
-			DEBUG("FT1000:drivermsg:No more DSP provisioning data in dsp image\n");
+			pr_debug("No more DSP provisioning data in dsp image\n");
 		}
-		DEBUG("ft1000_proc_drvmsg:DSP PROVISION is done\n");
+		pr_debug("DSP PROVISION is done\n");
 		break;
 	}
 	case DSP_STORE_INFO:{
-		DEBUG("ft1000_proc_drvmsg:Command message type = DSP_STORE_INFO");
-		DEBUG("FT1000:drivermsg:Got DSP_STORE_INFO\n");
+		pr_debug("Command message type = DSP_STORE_INFO");
 		tempword = ntohs(pdrvmsg->length);
 		info->DSPInfoBlklen = tempword;
 		if (tempword < (MAX_DSP_SESS_REC - 4)) {
 			pmsg = (u16 *)&pdrvmsg->data[0];
 			for (i = 0; i < ((tempword + 1) / 2); i++) {
-				DEBUG("FT1000:drivermsg:dsp info data = 0x%x\n", *pmsg);
+				pr_debug("dsp info data = 0x%x\n", *pmsg);
 				info->DSPInfoBlk[i + 10] = *pmsg++;
 			}
 		} else {
@@ -1275,7 +1248,7 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 		break;
 	}
 	case DSP_GET_INFO:{
-		DEBUG("FT1000:drivermsg:Got DSP_GET_INFO\n");
+		pr_debug("Got DSP_GET_INFO\n");
 		/* copy dsp info block to dsp */
 		dev->DrvMsgPend = 1;
 		/* allow any outstanding ioctl to finish */
@@ -1331,7 +1304,7 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 		break;
 	}
 	case GET_DRV_ERR_RPT_MSG:{
-		DEBUG("FT1000:drivermsg:Got GET_DRV_ERR_RPT_MSG\n");
+		pr_debug("Got GET_DRV_ERR_RPT_MSG\n");
 		/* copy driver error message to dsp */
 		dev->DrvMsgPend = 1;
 		/* allow any outstanding ioctl to finish */
@@ -1399,7 +1372,6 @@ static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 	status = 0;
 out:
 	kfree(cmdbuffer);
-	DEBUG("return from ft1000_proc_drvmsg\n");
 	return status;
 }
 
@@ -1417,7 +1389,7 @@ static int dsp_broadcast_msg_id(struct ft1000_usb *dev)
 			< MAX_MSG_LIMIT)) {
 			pdpram_blk = ft1000_get_buffer(&freercvpool);
 			if (pdpram_blk == NULL) {
-				DEBUG("Out of memory in free receive command pool\n");
+				pr_debug("Out of memory in free receive command pool\n");
 				dev->app_info[i].nRxMsgMiss++;
 				return -1;
 			}
@@ -1437,7 +1409,7 @@ static int dsp_broadcast_msg_id(struct ft1000_usb *dev)
 			} else {
 				dev->app_info[i].nRxMsgMiss++;
 				ft1000_free_buffer(pdpram_blk, &freercvpool);
-				DEBUG("pdpram_blk::ft1000_get_buffer NULL\n");
+				pr_debug("ft1000_get_buffer NULL\n");
 				return -1;
 			}
 		}
@@ -1452,7 +1424,7 @@ static int handle_misc_portid(struct ft1000_usb *dev)
 
 	pdpram_blk = ft1000_get_buffer(&freercvpool);
 	if (pdpram_blk == NULL) {
-		DEBUG("Out of memory in free receive command pool\n");
+		pr_debug("Out of memory in free receive command pool\n");
 		return -1;
 	}
 	if (!ft1000_receive_cmd(dev, pdpram_blk->pbuffer, MAX_CMD_SQSIZE))
@@ -1465,7 +1437,8 @@ static int handle_misc_portid(struct ft1000_usb *dev)
 			break;
 	}
 	if (i == MAX_NUM_APP) {
-		DEBUG("FT1000:ft1000_parse_dpram_msg: No application matching id = %d\n", ((struct pseudo_hdr *)pdpram_blk->pbuffer)->portdest);
+		pr_debug("No application matching id = %d\n",
+			 ((struct pseudo_hdr *)pdpram_blk->pbuffer)->portdest);
 		goto exit_failure;
 	} else if (dev->app_info[i].NumOfMsg > MAX_MSG_LIMIT) {
 		goto exit_failure;
@@ -1495,7 +1468,7 @@ int ft1000_poll(void *dev_id)
 	u16 portid;
 
 	if (ft1000_chkcard(dev) == FALSE) {
-		DEBUG("ft1000_poll::ft1000_chkcard: failed\n");
+		pr_debug("failed\n");
 		return -1;
 	}
 	status = ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
@@ -1514,7 +1487,7 @@ int ft1000_poll(void *dev_id)
 			if (size < MAX_CMD_SQSIZE) {
 				switch (portid) {
 				case DRIVERID:
-					DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type: FT1000_DB_DPRAM_RX : portid DRIVERID\n");
+					pr_debug("FT1000_REG_DOORBELL message type: FT1000_DB_DPRAM_RX : portid DRIVERID\n");
 					status = ft1000_proc_drvmsg(dev, size);
 					if (status != 0)
 						return status;
@@ -1527,7 +1500,8 @@ int ft1000_poll(void *dev_id)
 					break;
 				}
 			} else
-				DEBUG("FT1000:dpc:Invalid total length for SlowQ = %d\n", size);
+				pr_debug("Invalid total length for SlowQ = %d\n",
+					 size);
 			status = ft1000_write_register(dev,
 						       FT1000_DB_DPRAM_RX,
 						       FT1000_REG_DOORBELL);
@@ -1547,7 +1521,7 @@ int ft1000_poll(void *dev_id)
 					break;
 			}
 			if (i == 100) {
-				DEBUG("Unable to reset ASIC\n");
+				pr_debug("Unable to reset ASIC\n");
 				return 0;
 			}
 			usleep_range(9000, 11000);
@@ -1560,7 +1534,7 @@ int ft1000_poll(void *dev_id)
 						       FT1000_REG_DOORBELL);
 			usleep_range(9000, 11000);
 		} else if (tempword & FT1000_ASIC_RESET_REQ) {
-			DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type:  FT1000_ASIC_RESET_REQ\n");
+			pr_debug("FT1000_REG_DOORBELL message type: FT1000_ASIC_RESET_REQ\n");
 			/* clear ASIC reset request from DSP */
 			status = ft1000_write_register(dev,
 						       FT1000_ASIC_RESET_REQ,
@@ -1579,7 +1553,7 @@ int ft1000_poll(void *dev_id)
 						       FT1000_ASIC_RESET_DSP,
 						       FT1000_REG_DOORBELL);
 		} else if (tempword & FT1000_DB_COND_RESET) {
-			DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type:  FT1000_DB_COND_RESET\n");
+			pr_debug("FT1000_REG_DOORBELL message type: FT1000_DB_COND_RESET\n");
 			if (!dev->fAppMsgPend) {
 				/* Reset ASIC and DSP */
 				status = ft1000_read_dpram16(dev,
@@ -1600,7 +1574,7 @@ int ft1000_poll(void *dev_id)
 							     FT1000_MAG_DSP_TIMER3_INDX);
 				info->CardReady = 0;
 				info->DrvErrNum = DSP_CONDRESET_INFO;
-				DEBUG("ft1000_hw:DSP conditional reset requested\n");
+				pr_debug("DSP conditional reset requested\n");
 				info->ft1000_reset(dev->net);
 			} else {
 				dev->fProvComplete = false;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 244e3d6..a6b55f4 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -7,6 +7,9 @@
  * $Id:
  *====================================================
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/usb.h>
@@ -45,7 +48,7 @@ static int ft1000_poll_thread(void *arg)
 		if (!gPollingfailed) {
 			ret = ft1000_poll(arg);
 			if (ret != 0) {
-				DEBUG("ft1000_poll_thread: polling failed\n");
+				pr_debug("polling failed\n");
 				gPollingfailed = true;
 			}
 		}
@@ -71,9 +74,8 @@ static int ft1000_probe(struct usb_interface *interface,
 		return -ENOMEM;
 
 	dev = interface_to_usbdev(interface);
-	DEBUG("ft1000_probe: usb device descriptor info:\n");
-	DEBUG("ft1000_probe: number of configuration is %d\n",
-	      dev->descriptor.bNumConfigurations);
+	pr_debug("usb device descriptor info - number of configuration is %d\n",
+		 dev->descriptor.bNumConfigurations);
 
 	ft1000dev->dev = dev;
 	ft1000dev->status = 0;
@@ -85,42 +87,38 @@ static int ft1000_probe(struct usb_interface *interface,
 		goto err_fw;
 	}
 
-	DEBUG("ft1000_probe is called\n");
 	numaltsetting = interface->num_altsetting;
-	DEBUG("ft1000_probe: number of alt settings is :%d\n", numaltsetting);
+	pr_debug("number of alt settings is: %d\n", numaltsetting);
 	iface_desc = interface->cur_altsetting;
-	DEBUG("ft1000_probe: number of endpoints is %d\n",
-	      iface_desc->desc.bNumEndpoints);
-	DEBUG("ft1000_probe: descriptor type is %d\n",
-	      iface_desc->desc.bDescriptorType);
-	DEBUG("ft1000_probe: interface number is %d\n",
-	      iface_desc->desc.bInterfaceNumber);
-	DEBUG("ft1000_probe: alternatesetting is %d\n",
-	      iface_desc->desc.bAlternateSetting);
-	DEBUG("ft1000_probe: interface class is %d\n",
-	      iface_desc->desc.bInterfaceClass);
-	DEBUG("ft1000_probe: control endpoint info:\n");
-	DEBUG("ft1000_probe: descriptor0 type -- %d\n",
-	      iface_desc->endpoint[0].desc.bmAttributes);
-	DEBUG("ft1000_probe: descriptor1 type -- %d\n",
-	      iface_desc->endpoint[1].desc.bmAttributes);
-	DEBUG("ft1000_probe: descriptor2 type -- %d\n",
-	      iface_desc->endpoint[2].desc.bmAttributes);
+	pr_debug("number of endpoints is: %d\n",
+		 iface_desc->desc.bNumEndpoints);
+	pr_debug("descriptor type is: %d\n", iface_desc->desc.bDescriptorType);
+	pr_debug("interface number is: %d\n",
+		 iface_desc->desc.bInterfaceNumber);
+	pr_debug("alternatesetting is: %d\n",
+		 iface_desc->desc.bAlternateSetting);
+	pr_debug("interface class is: %d\n", iface_desc->desc.bInterfaceClass);
+	pr_debug("control endpoint info:\n");
+	pr_debug("descriptor0 type -- %d\n",
+		 iface_desc->endpoint[0].desc.bmAttributes);
+	pr_debug("descriptor1 type -- %d\n",
+		 iface_desc->endpoint[1].desc.bmAttributes);
+	pr_debug("descriptor2 type -- %d\n",
+		 iface_desc->endpoint[2].desc.bmAttributes);
 
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
 		endpoint =
 			(struct usb_endpoint_descriptor *)&iface_desc->
 			endpoint[i].desc;
-		DEBUG("endpoint %d\n", i);
-		DEBUG("bEndpointAddress=%x, bmAttributes=%x\n",
-		      endpoint->bEndpointAddress, endpoint->bmAttributes);
+		pr_debug("endpoint %d\n", i);
+		pr_debug("bEndpointAddress=%x, bmAttributes=%x\n",
+			 endpoint->bEndpointAddress, endpoint->bmAttributes);
 		if ((endpoint->bEndpointAddress & USB_DIR_IN)
 		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
 			USB_ENDPOINT_XFER_BULK)) {
 			ft1000dev->bulk_in_endpointAddr =
 				endpoint->bEndpointAddress;
-			DEBUG("ft1000_probe: in: %d\n",
-			      endpoint->bEndpointAddress);
+			pr_debug("in: %d\n", endpoint->bEndpointAddress);
 		}
 
 		if (!(endpoint->bEndpointAddress & USB_DIR_IN)
@@ -128,17 +126,17 @@ static int ft1000_probe(struct usb_interface *interface,
 			USB_ENDPOINT_XFER_BULK)) {
 			ft1000dev->bulk_out_endpointAddr =
 				endpoint->bEndpointAddress;
-			DEBUG("ft1000_probe: out: %d\n",
-			      endpoint->bEndpointAddress);
+			pr_debug("out: %d\n", endpoint->bEndpointAddress);
 		}
 	}
 
-	DEBUG("bulk_in=%d, bulk_out=%d\n", ft1000dev->bulk_in_endpointAddr,
-	      ft1000dev->bulk_out_endpointAddr);
+	pr_debug("bulk_in=%d, bulk_out=%d\n",
+		 ft1000dev->bulk_in_endpointAddr,
+		 ft1000dev->bulk_out_endpointAddr);
 
 	ret = request_firmware(&dsp_fw, "ft3000.img", &dev->dev);
 	if (ret < 0) {
-		pr_err("Error request_firmware().\n");
+		pr_err("Error request_firmware()\n");
 		goto err_fw;
 	}
 
@@ -155,7 +153,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	FileLength = dsp_fw->size;
 	release_firmware(dsp_fw);
 
-	DEBUG("ft1000_probe: start downloading dsp image...\n");
+	pr_debug("start downloading dsp image...\n");
 
 	ret = init_ft1000_netdev(ft1000dev);
 	if (ret)
@@ -163,7 +161,7 @@ static int ft1000_probe(struct usb_interface *interface,
 
 	pft1000info = netdev_priv(ft1000dev->net);
 
-	DEBUG("In probe: pft1000info=%p\n", pft1000info);
+	pr_debug("pft1000info=%p\n", pft1000info);
 	ret = dsp_reload(ft1000dev);
 	if (ret) {
 		pr_err("Problem with DSP image loading\n");
@@ -187,10 +185,10 @@ static int ft1000_probe(struct usb_interface *interface,
 			goto err_thread;
 		}
 		msleep(100);
-		DEBUG("ft1000_probe::Waiting for Card Ready\n");
+		pr_debug("Waiting for Card Ready\n");
 	}
 
-	DEBUG("ft1000_probe::Card Ready!!!! Registering network device\n");
+	pr_debug("Card Ready!!!! Registering network device\n");
 
 	ret = reg_ft1000_netdev(ft1000dev, interface);
 	if (ret)
@@ -216,24 +214,21 @@ static void ft1000_disconnect(struct usb_interface *interface)
 	struct ft1000_info *pft1000info;
 	struct ft1000_usb *ft1000dev;
 
-	DEBUG("ft1000_disconnect is called\n");
-
 	pft1000info = (struct ft1000_info *)usb_get_intfdata(interface);
-	DEBUG("In disconnect pft1000info=%p\n", pft1000info);
+	pr_debug("In disconnect pft1000info=%p\n", pft1000info);
 
 	if (pft1000info) {
 		ft1000dev = pft1000info->priv;
 		if (ft1000dev->pPollThread)
 			kthread_stop(ft1000dev->pPollThread);
 
-		DEBUG("ft1000_disconnect: threads are terminated\n");
+		pr_debug("threads are terminated\n");
 
 		if (ft1000dev->net) {
-			DEBUG("ft1000_disconnect: destroy char driver\n");
+			pr_debug("destroy char driver\n");
 			ft1000_destroy_dev(ft1000dev->net);
 			unregister_netdev(ft1000dev->net);
-			DEBUG
-				("ft1000_disconnect: network device unregistered\n");
+			pr_debug("network device unregistered\n");
 			free_netdev(ft1000dev->net);
 
 		}
@@ -241,7 +236,7 @@ static void ft1000_disconnect(struct usb_interface *interface)
 		usb_free_urb(ft1000dev->rx_urb);
 		usb_free_urb(ft1000dev->tx_urb);
 
-		DEBUG("ft1000_disconnect: urb freed\n");
+		pr_debug("urb freed\n");
 
 		kfree(ft1000dev);
 	}
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 418e6df..fea60d5 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -28,8 +28,6 @@ struct app_info_block {
 					*/
 } __packed;
 
-#define DEBUG(args...) pr_info(args)
-
 #define FALSE           0
 #define TRUE            1
 
-- 
2.1.2

