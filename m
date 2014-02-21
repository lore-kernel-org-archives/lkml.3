Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaBUTxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:53:00 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:54142 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaBUTw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:52:57 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Ball <chris@printf.net>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Amarinder Bindra <a-bindra@ti.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] mmc: host: MMC_SH_MMCIF should depend on HAS_DMA
Date: Fri, 21 Feb 2014 20:52:50 +0100
Message-Id: <1393012371-22320-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

    drivers/built-in.o: In function `sh_mmcif_start_dma_tx':
    sh_mmcif.c:(.text+0x5a3286): undefined reference to `dma_map_sg'
    drivers/built-in.o: In function `sh_mmcif_start_dma_rx':
    sh_mmcif.c:(.text+0x5a33fc): undefined reference to `dma_map_sg'
    drivers/built-in.o: In function `sh_mmcif_end_cmd':
    sh_mmcif.c:(.text+0x5a3668): undefined reference to `dma_unmap_sg'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mmc/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 1384f67abe21..bfe2133d0b9c 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -611,7 +611,7 @@ config MMC_DW_PCI
 
 config MMC_SH_MMCIF
 	tristate "SuperH Internal MMCIF support"
-	depends on MMC_BLOCK
+	depends on MMC_BLOCK && HAS_DMA
 	depends on SUPERH || ARCH_SHMOBILE || COMPILE_TEST
 	help
 	  This selects the MMC Host Interface controller (MMCIF).
-- 
1.7.9.5

