Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab3EBI6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:58:46 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48994 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3EBI6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:58:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: Remove unnecessary attributes from DMA channel request pdata
Date: Thu,  2 May 2013 09:58:33 +0100
Message-Id: <1367485113-3647-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA data width and packet size information is only required at channel
configuration time. Any information passed from platform data is passed
directly to the DMA40 driver to use during channel allocation, but these
pieces of information are subsequently ignored by the driver, so we may
as well remove them.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/usb.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/mach-ux500/usb.c b/arch/arm/mach-ux500/usb.c
index e0ea490..821703d 100644
--- a/arch/arm/mach-ux500/usb.c
+++ b/arch/arm/mach-ux500/usb.c
@@ -15,19 +15,11 @@
 #define MUSB_DMA40_RX_CH { \
 		.mode = STEDMA40_MODE_LOGICAL, \
 		.dir = STEDMA40_PERIPH_TO_MEM, \
-		.src_info.data_width = STEDMA40_WORD_WIDTH, \
-		.dst_info.data_width = STEDMA40_WORD_WIDTH, \
-		.src_info.psize = STEDMA40_PSIZE_LOG_16, \
-		.dst_info.psize = STEDMA40_PSIZE_LOG_16, \
 	}
 
 #define MUSB_DMA40_TX_CH { \
 		.mode = STEDMA40_MODE_LOGICAL, \
 		.dir = STEDMA40_MEM_TO_PERIPH, \
-		.src_info.data_width = STEDMA40_WORD_WIDTH, \
-		.dst_info.data_width = STEDMA40_WORD_WIDTH, \
-		.src_info.psize = STEDMA40_PSIZE_LOG_16, \
-		.dst_info.psize = STEDMA40_PSIZE_LOG_16, \
 	}
 
 static struct stedma40_chan_cfg musb_dma_rx_ch[UX500_MUSB_DMA_NUM_RX_CHANNELS]
-- 
1.7.10.4

