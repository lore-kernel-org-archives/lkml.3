Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaGIV1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:27:17 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:60983 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaGIV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:27:15 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/2] spi: sh-msiof: SPI_SH_MSIOF should depend on HAS_DMA
Date: Wed,  9 Jul 2014 23:27:08 +0200
Message-Id: <1404941228-9922-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404941228-9922-1-git-send-email-geert+renesas@glider.be>
References: <1404941228-9922-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

    drivers/built-in.o: In function `sh_msiof_release_dma':
    spi-sh-msiof.c:(.text+0x23cbfe): undefined reference to `dma_unmap_single'
    drivers/built-in.o: In function `sh_msiof_request_dma':
    spi-sh-msiof.c:(.text+0x23cd5e): undefined reference to `dma_map_single'
    spi-sh-msiof.c:(.text+0x23cd70): undefined reference to `dma_mapping_error'
    spi-sh-msiof.c:(.text+0x23cdca): undefined reference to `dma_unmap_single'
    drivers/built-in.o: In function `sh_msiof_dma_once':
    spi-sh-msiof.c:(.text+0x23d450): undefined reference to `dma_sync_single_for_cpu'
    spi-sh-msiof.c:(.text+0x23d5ea): undefined reference to `dma_sync_single_for_cpu'

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/spi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index d46b4b9e73b2..ab70bca8c7e1 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -446,7 +446,7 @@ config SPI_SC18IS602
 
 config SPI_SH_MSIOF
 	tristate "SuperH MSIOF SPI controller"
-	depends on HAVE_CLK
+	depends on HAVE_CLK && HAS_DMA
 	depends on SUPERH || ARCH_SHMOBILE || COMPILE_TEST
 	help
 	  SPI driver for SuperH and SH Mobile MSIOF blocks.
-- 
1.9.1

