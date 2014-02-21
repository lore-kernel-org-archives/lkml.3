Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaBUTw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:52:59 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:43727 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbaBUTw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:52:57 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Ball <chris@printf.net>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Amarinder Bindra <a-bindra@ti.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] mmc: host: MMC_OMAP_HS should depend on HAS_DMA
Date: Fri, 21 Feb 2014 20:52:51 +0100
Message-Id: <1393012371-22320-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393012371-22320-1-git-send-email-geert@linux-m68k.org>
References: <1393012371-22320-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

    drivers/built-in.o: In function `omap_hsmmc_pre_dma_transfer':
    omap_hsmmc.c:(.text+0x5a0928): undefined reference to `dma_map_sg'
    drivers/built-in.o: In function `omap_hsmmc_dma_cleanup':
    omap_hsmmc.c:(.text+0x5a0e8e): undefined reference to `dma_unmap_sg'
    drivers/built-in.o: In function `omap_hsmmc_dma_callback':
    omap_hsmmc.c:(.text+0x5a1f58): undefined reference to `dma_unmap_sg'
    drivers/built-in.o: In function `omap_hsmmc_post_req':
    omap_hsmmc.c:(.text+0x5a2082): undefined reference to `dma_unmap_sg'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mmc/host/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index bfe2133d0b9c..2496b9d649f1 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -296,6 +296,7 @@ config MMC_OMAP
 
 config MMC_OMAP_HS
 	tristate "TI OMAP High Speed Multimedia Card Interface support"
+	depends on HAS_DMA
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	help
 	  This selects the TI OMAP High Speed Multimedia card Interface.
-- 
1.7.9.5

