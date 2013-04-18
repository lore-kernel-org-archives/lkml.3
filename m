Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967736Ab3DRRHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:07:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56574 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967565Ab3DRRHA (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 18 Apr 2013 13:07:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@linaro.org>, Arnd Bergman <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] spi/s3c64xx: Fix non-dmaengine usage
Date: Thu, 18 Apr 2013 18:06:54 +0100
Message-Id: <1366304814-19428-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multiplatform conversion in commit 788437 (spi: s3c64xx: move to
generic dmaengine API) tested for the use of the Samsung-specific DMA
API with SAMSUNG_DMADEV when in fact S3C_DMA should be used. This
renderd DMA based transfers non-functional on platforms not using
dmaengine.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/spi/spi-s3c64xx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 4ab992b..6d6537d 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -34,7 +34,7 @@
 
 #include <linux/platform_data/spi-s3c64xx.h>
 
-#ifdef CONFIG_SAMSUNG_DMADEV
+#ifdef CONFIG_S3C_DMA
 #include <mach/dma.h>
 #endif
 
@@ -199,7 +199,7 @@ struct s3c64xx_spi_driver_data {
 	unsigned                        cur_speed;
 	struct s3c64xx_spi_dma_data	rx_dma;
 	struct s3c64xx_spi_dma_data	tx_dma;
-#ifdef CONFIG_SAMSUNG_DMADEV
+#ifdef CONFIG_S3C_DMA
 	struct samsung_dma_ops		*ops;
 #endif
 	struct s3c64xx_spi_port_config	*port_conf;
@@ -283,7 +283,7 @@ static void s3c64xx_spi_dmacb(void *data)
 	spin_unlock_irqrestore(&sdd->lock, flags);
 }
 
-#ifdef CONFIG_SAMSUNG_DMADEV
+#ifdef CONFIG_S3C_DMA
 /* FIXME: remove this section once arch/arm/mach-s3c64xx uses dmaengine */
 
 static struct s3c2410_dma_client s3c64xx_spi_dma_client = {
-- 
1.7.10.4

