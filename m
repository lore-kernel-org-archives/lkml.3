Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3CMGpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:45:40 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:65312 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab3CMGoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:44:12 -0400
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: grant.likely@secretlab.ca, t.figa@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        Girish K S <girishks2000@gmail.com>
Subject: [PATCH V3 5/5] spi: s3c64xx: Added support for exynos5440 spi
Date: Wed, 13 Mar 2013 12:13:34 +0530
Message-Id: <1363157014-9615-6-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Girish K S <girishks2000@gmail.com>

This patch adds support for the exynos5440 spi controller.
The integration of the spi IP in exynos5440 is different from
other SoC's. The I/O pins are no more configured via gpio, they
have dedicated pins.

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
 drivers/spi/spi-s3c64xx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index ac557f8..bb52a70 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1546,6 +1546,15 @@ static struct s3c64xx_spi_port_config exynos4_spi_port_config = {
 	.clk_from_cmu	= true,
 };
 
+static struct s3c64xx_spi_port_config exynos5440_spi_port_config = {
+	.fifo_lvl_mask	= { 0x1ff },
+	.rx_lvl_offset	= 15,
+	.tx_st_done	= 25,
+	.high_speed	= true,
+	.clk_from_cmu	= true,
+	.quirks		= S3C64XX_SPI_QUIRK_POLL,
+};
+
 static struct platform_device_id s3c64xx_spi_driver_ids[] = {
 	{
 		.name		= "s3c2443-spi",
@@ -1574,6 +1583,9 @@ static const struct of_device_id s3c64xx_spi_dt_match[] = {
 	{ .compatible = "samsung,exynos4210-spi",
 			.data = (void *)&exynos4_spi_port_config,
 	},
+	{ .compatible = "samsung,exynos5440-spi",
+			.data = (void *)&exynos5440_spi_port_config,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, s3c64xx_spi_dt_match);
-- 
1.8.0

