Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab3EOKCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 06:02:00 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:42437 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab3EOJwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:52:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/39] ARM: ux500: Remove unnecessary attributes from DMA channel request pdata
Date: Wed, 15 May 2013 10:51:34 +0100
Message-Id: <1368611522-9984-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
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
index 45af303..72754e3 100644
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

