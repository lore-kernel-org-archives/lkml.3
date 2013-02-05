Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3BEXLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:11:04 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:52181 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab3BEXK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:10:56 -0500
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] spi: s3c64xx: add support for exynos5440 spi
Date: Tue,  5 Feb 2013 15:09:44 -0800
Message-Id: <1360105784-12282-5-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the exynos5440 spi controller.
The integration of the spi IP in exynos5440 is different from
other SoC's. The I/O pins are no more configured via gpio, they
have dedicated pins.

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index f06bbee..bf26abc 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1547,6 +1547,15 @@ static struct s3c64xx_spi_port_config exynos4_spi_port_config = {
 	.clk_from_cmu	= true,
 };
 
+static struct s3c64xx_spi_port_config exynos5440_spi_port_config = {
+	.fifo_lvl_mask	= { 0xff },
+	.rx_lvl_offset	= 15,
+	.tx_st_done	= 25,
+	.high_speed	= true,
+	.clk_from_cmu	= true,
+	.quirks		= S3C64XX_SPI_QUIRK_GPIO | S3C64XX_SPI_QUIRK_POLL,
+};
+
 static struct platform_device_id s3c64xx_spi_driver_ids[] = {
 	{
 		.name		= "s3c2443-spi",
@@ -1575,6 +1584,9 @@ static const struct of_device_id s3c64xx_spi_dt_match[] = {
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
1.7.10.4

