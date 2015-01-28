Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbbA2Bkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:40:40 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37079 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbbA2Bki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:40:38 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Joe Perches <joe@perches.com>, Greg Donald <gdonald@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>,
        Nicky Chorley <ndchorley@gmail.com>, Jiayi Ye <yejiayily@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ft1000: ft1000-pcmcia: ft1000_hw: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:43:18 +0100
Message-Id: <1422484998-10400-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index d5475b7..3c42737 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -1230,7 +1230,6 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 	struct ft1000_info *info = netdev_priv(dev);
 	u16 doorbell;
 	u16 portid;
-	u16 nxtph;
 	u16 total_len;
 	int i = 0;
 	unsigned long flags;
@@ -1282,7 +1281,6 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 
 	if (doorbell & FT1000_DB_DPRAM_RX) {
 		pr_debug("Got a slow queue message\n");
-		nxtph = FT1000_DPRAM_RX_BASE + 2;
 		if (info->AsicID == ELECTRABUZZ_ID) {
 			total_len =
 				ft1000_read_dpram(dev, FT1000_DPRAM_RX_BASE);
@@ -1294,7 +1292,6 @@ static int ft1000_parse_dpram_msg(struct net_device *dev)
 		}
 		pr_debug("total length = %d\n", total_len);
 		if ((total_len < MAX_CMD_SQSIZE) && (total_len > sizeof(struct pseudo_hdr))) {
-			total_len += nxtph;
 			/*
 			 * ft1000_read_reg will return a value that needs to be byteswap
 			 * in order to get DSP_QID_OFFSET.
@@ -1382,7 +1379,6 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 	struct ft1000_info *info = netdev_priv(dev);
 	struct ft1000_pcmcia *pcmcia = info->priv;
 	u16 i;
-	u32 templong;
 	u16 tempword;
 
 	if (pcmcia->PktIntfErr > MAX_PH_ERR) {
@@ -1422,8 +1418,7 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 				tempword =
 					ft1000_read_reg(dev, FT1000_REG_DFIFO_STAT);
 			} else {
-				templong =
-					inl(dev->base_addr + FT1000_REG_MAG_DFR);
+				inl(dev->base_addr + FT1000_REG_MAG_DFR);
 				tempword =
 					inw(dev->base_addr + FT1000_REG_MAG_DFSR);
 			}
@@ -1502,7 +1497,7 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 		} else {
 			pr_debug("Flushing FIFO complete = %x\n", tempword);
 			/* Flush last word in FIFO */
-			templong = inl(dev->base_addr + FT1000_REG_MAG_DFR);
+			inl(dev->base_addr + FT1000_REG_MAG_DFR);
 			tempword = inw(dev->base_addr + FT1000_REG_SUP_STAT);
 			pr_debug("FT1000_REG_SUP_STAT = 0x%x\n", tempword);
 			tempword = inw(dev->base_addr + FT1000_REG_MAG_DFSR);
-- 
1.7.10.4

