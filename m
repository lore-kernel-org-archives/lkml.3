Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3FRFAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:00:44 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57416 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab3FRFAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:00:41 -0400
From: girishks2000@gmail.com
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: broonie@kernel.org, Girish K S <girishks2000@gmail.com>
Subject: [RESEND PATCH v1 3/3] spi: s3c64xx: Added support for exynos5440 spi
Date: Tue, 18 Jun 2013 10:30:11 +0530
Message-Id: <51bfe978.4266420a.3737.352e@mx.google.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371531611-29031-1-git-send-email-0000-cover-letter.patch>
References: <1371531611-29031-1-git-send-email-0000-cover-letter.patch>
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
 drivers/spi/spi-s3c64xx.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index eaf9e1c..bd43888 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1608,6 +1608,15 @@ static struct s3c64xx_spi_port_config exynos4_spi_port_config = {
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
@@ -1636,6 +1645,9 @@ static const struct of_device_id s3c64xx_spi_dt_match[] = {
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
1.7.5.4

