Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbaGISwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:52:50 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:34686 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbaGISws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:52:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 1/3] mmc: MMC_OMAP_HS should depend on HAS_DMA
Date: Wed,  9 Jul 2014 20:52:40 +0200
Message-Id: <1404931962-25917-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
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
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v2:
  - Add Acked-by
---
 drivers/mmc/host/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index a5652548230a..97f6452e0d23 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -303,6 +303,7 @@ config MMC_OMAP
 
 config MMC_OMAP_HS
 	tristate "TI OMAP High Speed Multimedia Card Interface support"
+	depends on HAS_DMA
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	help
 	  This selects the TI OMAP High Speed Multimedia card Interface.
-- 
1.9.1

