Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbaGISyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:54:04 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:65331 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbaGISwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:52:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 2/3] mmc: MMC_SH_MMCIF should depend on HAS_DMA
Date: Wed,  9 Jul 2014 20:52:41 +0200
Message-Id: <1404931962-25917-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404931962-25917-1-git-send-email-geert@linux-m68k.org>
References: <1404931962-25917-1-git-send-email-geert@linux-m68k.org>
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
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v2:
  - Add Acked-by
---
 drivers/mmc/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 97f6452e0d23..9ac9d8387df0 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -624,7 +624,7 @@ config MMC_DW_PCI
 
 config MMC_SH_MMCIF
 	tristate "SuperH Internal MMCIF support"
-	depends on MMC_BLOCK
+	depends on MMC_BLOCK && HAS_DMA
 	depends on SUPERH || ARCH_SHMOBILE || COMPILE_TEST
 	help
 	  This selects the MMC Host Interface controller (MMCIF).
-- 
1.9.1

