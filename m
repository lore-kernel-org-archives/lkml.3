Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701Ab3ECOni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:43:38 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46159 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308Ab3ECOei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:34:38 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 35/63] ARM: ux500: Remove unnecessary attributes from DMA channel request pdata
Date: Fri,  3 May 2013 15:32:21 +0100
Message-Id: <1367591569-32197-36-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
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

