Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbbA2BSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:18:41 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63131 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbbA2BSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:18:39 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Gulsah Kose <gulsah.1004@gmail.com>, Joe Perches <joe@perches.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ft1000: ft1000-usb: ft1000_hw: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:45:12 +0100
Message-Id: <1422485112-10757-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   84 +++++++++++--------------
 1 file changed, 37 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index d12cfc9..fa76b56 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -284,36 +284,35 @@ int fix_ft1000_write_dpram32(struct ft1000_usb *ft1000dev, u16 indx, u8 *buffer)
 /* reset or activate the DSP */
 static void card_reset_dsp(struct ft1000_usb *ft1000dev, bool value)
 {
-	int status = 0;
 	u16 tempword;
 
-	status = ft1000_write_register(ft1000dev, HOST_INTF_BE,
+	ft1000_write_register(ft1000dev, HOST_INTF_BE,
 				       FT1000_REG_SUP_CTRL);
-	status = ft1000_read_register(ft1000dev, &tempword,
+	ft1000_read_register(ft1000dev, &tempword,
 				      FT1000_REG_SUP_CTRL);
 
 	if (value) {
 		pr_debug("Reset DSP\n");
-		status = ft1000_read_register(ft1000dev, &tempword,
+		ft1000_read_register(ft1000dev, &tempword,
 					      FT1000_REG_RESET);
 		tempword |= DSP_RESET_BIT;
-		status = ft1000_write_register(ft1000dev, tempword,
+		ft1000_write_register(ft1000dev, tempword,
 					       FT1000_REG_RESET);
 	} else {
 		pr_debug("Activate DSP\n");
-		status = ft1000_read_register(ft1000dev, &tempword,
+		ft1000_read_register(ft1000dev, &tempword,
 					      FT1000_REG_RESET);
 		tempword |= DSP_ENCRYPTED;
 		tempword &= ~DSP_UNENCRYPTED;
-		status = ft1000_write_register(ft1000dev, tempword,
+		ft1000_write_register(ft1000dev, tempword,
 					       FT1000_REG_RESET);
-		status = ft1000_read_register(ft1000dev, &tempword,
+		ft1000_read_register(ft1000dev, &tempword,
 					      FT1000_REG_RESET);
 		tempword &= ~EFUSE_MEM_DISABLE;
 		tempword &= ~DSP_RESET_BIT;
-		status = ft1000_write_register(ft1000dev, tempword,
+		ft1000_write_register(ft1000dev, tempword,
 					       FT1000_REG_RESET);
-		status = ft1000_read_register(ft1000dev, &tempword,
+		ft1000_read_register(ft1000dev, &tempword,
 					      FT1000_REG_RESET);
 	}
 }
@@ -937,7 +936,6 @@ int ft1000_close(struct net_device *net)
 static int ft1000_chkcard(struct ft1000_usb *dev)
 {
 	u16 tempword;
-	int status;
 
 	if (dev->fCondResetPend) {
 		pr_debug("Card is being reset, return FALSE\n");
@@ -946,7 +944,7 @@ static int ft1000_chkcard(struct ft1000_usb *dev)
 	/* Mask register is used to check for device presence since it is never
 	 * set to zero.
 	 */
-	status = ft1000_read_register(dev, &tempword, FT1000_REG_SUP_IMASK);
+	ft1000_read_register(dev, &tempword, FT1000_REG_SUP_IMASK);
 	if (tempword == 0) {
 		pr_debug("IMASK = 0 Card not detected\n");
 		return FALSE;
@@ -954,7 +952,7 @@ static int ft1000_chkcard(struct ft1000_usb *dev)
 	/* The system will return the value of 0xffff for the version register
 	 * if the device is not present.
 	 */
-	status = ft1000_read_register(dev, &tempword, FT1000_REG_ASIC_ID);
+	ft1000_read_register(dev, &tempword, FT1000_REG_ASIC_ID);
 	if (tempword != 0x1b01) {
 		dev->status |= FT1000_STATUS_CLOSING;
 		pr_debug("Version = 0xffff Card not detected\n");
@@ -972,13 +970,11 @@ static bool ft1000_receive_cmd(struct ft1000_usb *dev, u16 *pbuffer,
 			       int maxsz)
 {
 	u16 size;
-	int ret;
 	u16 *ppseudohdr;
 	int i;
 	u16 tempword;
 
-	ret =
-		ft1000_read_dpram16(dev, FT1000_MAG_PH_LEN, (u8 *)&size,
+	ft1000_read_dpram16(dev, FT1000_MAG_PH_LEN, (u8 *)&size,
 				    FT1000_MAG_PH_LEN_INDX);
 	size = ntohs(size) + PSEUDOSZ;
 	if (size > maxsz) {
@@ -988,34 +984,28 @@ static bool ft1000_receive_cmd(struct ft1000_usb *dev, u16 *pbuffer,
 	ppseudohdr = (u16 *)pbuffer;
 	ft1000_write_register(dev, FT1000_DPRAM_MAG_RX_BASE,
 			      FT1000_REG_DPRAM_ADDR);
-	ret =
-		ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
+	ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
 	pbuffer++;
 	ft1000_write_register(dev, FT1000_DPRAM_MAG_RX_BASE + 1,
 			      FT1000_REG_DPRAM_ADDR);
 	for (i = 0; i <= (size >> 2); i++) {
-		ret =
-			ft1000_read_register(dev, pbuffer,
+		ft1000_read_register(dev, pbuffer,
 					     FT1000_REG_MAG_DPDATAL);
 		pbuffer++;
-		ret =
-			ft1000_read_register(dev, pbuffer,
+		ft1000_read_register(dev, pbuffer,
 					     FT1000_REG_MAG_DPDATAH);
 		pbuffer++;
 	}
 	/* copy odd aligned word */
-	ret =
-		ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAL);
+	ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAL);
 
 	pbuffer++;
-	ret =
-		ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
+	ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
 
 	pbuffer++;
 	if (size & 0x0001) {
 		/* copy odd byte from fifo */
-		ret =
-			ft1000_read_register(dev, &tempword,
+		ft1000_read_register(dev, &tempword,
 					     FT1000_REG_DPRAM_DATA);
 		*pbuffer = ntohs(tempword);
 	}
@@ -1474,14 +1464,14 @@ int ft1000_poll(void *dev_id)
 	status = ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
 	if (!status) {
 		if (tempword & FT1000_DB_DPRAM_RX) {
-			status = ft1000_read_dpram16(dev,
+			ft1000_read_dpram16(dev,
 						     0x200, (u8 *)&data, 0);
 			size = ntohs(data) + 16 + 2;
 			if (size % 4) {
 				modulo = 4 - (size % 4);
 				size = size + modulo;
 			}
-			status = ft1000_read_dpram16(dev, 0x201,
+			ft1000_read_dpram16(dev, 0x201,
 						     (u8 *)&portid, 1);
 			portid &= 0xff;
 			if (size < MAX_CMD_SQSIZE) {
@@ -1493,27 +1483,27 @@ int ft1000_poll(void *dev_id)
 						return status;
 					break;
 				case DSPBCMSGID:
-					status = dsp_broadcast_msg_id(dev);
+					dsp_broadcast_msg_id(dev);
 					break;
 				default:
-					status = handle_misc_portid(dev);
+					handle_misc_portid(dev);
 					break;
 				}
 			} else
 				pr_debug("Invalid total length for SlowQ = %d\n",
 					 size);
-			status = ft1000_write_register(dev,
+			ft1000_write_register(dev,
 						       FT1000_DB_DPRAM_RX,
 						       FT1000_REG_DOORBELL);
 		} else if (tempword & FT1000_DSP_ASIC_RESET) {
 			/* Let's reset the ASIC from the Host side as well */
-			status = ft1000_write_register(dev, ASIC_RESET_BIT,
+			ft1000_write_register(dev, ASIC_RESET_BIT,
 						       FT1000_REG_RESET);
-			status = ft1000_read_register(dev, &tempword,
+			ft1000_read_register(dev, &tempword,
 						      FT1000_REG_RESET);
 			i = 0;
 			while (tempword & ASIC_RESET_BIT) {
-				status = ft1000_read_register(dev, &tempword,
+				ft1000_read_register(dev, &tempword,
 							      FT1000_REG_RESET);
 				usleep_range(9000, 11000);
 				i++;
@@ -1526,49 +1516,49 @@ int ft1000_poll(void *dev_id)
 			}
 			usleep_range(9000, 11000);
 			/* Program WMARK register */
-			status = ft1000_write_register(dev, 0x600,
+			ft1000_write_register(dev, 0x600,
 						       FT1000_REG_MAG_WATERMARK);
 			/* clear ASIC reset doorbell */
-			status = ft1000_write_register(dev,
+			ft1000_write_register(dev,
 						       FT1000_DSP_ASIC_RESET,
 						       FT1000_REG_DOORBELL);
 			usleep_range(9000, 11000);
 		} else if (tempword & FT1000_ASIC_RESET_REQ) {
 			pr_debug("FT1000_REG_DOORBELL message type: FT1000_ASIC_RESET_REQ\n");
 			/* clear ASIC reset request from DSP */
-			status = ft1000_write_register(dev,
+			ft1000_write_register(dev,
 						       FT1000_ASIC_RESET_REQ,
 						       FT1000_REG_DOORBELL);
-			status = ft1000_write_register(dev, HOST_INTF_BE,
+			ft1000_write_register(dev, HOST_INTF_BE,
 						       FT1000_REG_SUP_CTRL);
 			/* copy dsp session record from Adapter block */
-			status = ft1000_write_dpram32(dev, 0,
+			ft1000_write_dpram32(dev, 0,
 						      (u8 *)&info->DSPSess.Rec[0], 1024);
-			status = ft1000_write_register(dev, 0x600,
+			ft1000_write_register(dev, 0x600,
 						       FT1000_REG_MAG_WATERMARK);
 			/* ring doorbell to tell DSP that
 			 * ASIC is out of reset
 			 * */
-			status = ft1000_write_register(dev,
+			ft1000_write_register(dev,
 						       FT1000_ASIC_RESET_DSP,
 						       FT1000_REG_DOORBELL);
 		} else if (tempword & FT1000_DB_COND_RESET) {
 			pr_debug("FT1000_REG_DOORBELL message type: FT1000_DB_COND_RESET\n");
 			if (!dev->fAppMsgPend) {
 				/* Reset ASIC and DSP */
-				status = ft1000_read_dpram16(dev,
+				ft1000_read_dpram16(dev,
 							     FT1000_MAG_DSP_TIMER0,
 							     (u8 *)&(info->DSP_TIME[0]),
 							     FT1000_MAG_DSP_TIMER0_INDX);
-				status = ft1000_read_dpram16(dev,
+				ft1000_read_dpram16(dev,
 							     FT1000_MAG_DSP_TIMER1,
 							     (u8 *)&(info->DSP_TIME[1]),
 							     FT1000_MAG_DSP_TIMER1_INDX);
-				status = ft1000_read_dpram16(dev,
+				ft1000_read_dpram16(dev,
 							     FT1000_MAG_DSP_TIMER2,
 							     (u8 *)&(info->DSP_TIME[2]),
 							     FT1000_MAG_DSP_TIMER2_INDX);
-				status = ft1000_read_dpram16(dev,
+				ft1000_read_dpram16(dev,
 							     FT1000_MAG_DSP_TIMER3,
 							     (u8 *)&(info->DSP_TIME[3]),
 							     FT1000_MAG_DSP_TIMER3_INDX);
-- 
1.7.10.4

