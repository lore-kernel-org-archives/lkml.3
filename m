Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944Ab3DOIlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:41:16 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53312 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964914Ab3DOIlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:41:02 -0400
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: grant.likely@secretlab.ca, t.figa@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        Girish K S <girishks2000@gmail.com>
Subject: [PATCH RESEND V3 5/5] spi: s3c64xx: Added support for exynos5440 spi
Date: Mon, 15 Apr 2013 14:10:30 +0530
Message-Id: <1366015230-18243-4-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366015230-18243-1-git-send-email-ks.giri@samsung.com>
References: <1366015230-18243-1-git-send-email-ks.giri@samsung.com>
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
index 7fdc940..01db8f7 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1550,6 +1550,15 @@ static struct s3c64xx_spi_port_config exynos4_spi_port_config = {
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
@@ -1578,6 +1587,9 @@ static const struct of_device_id s3c64xx_spi_dt_match[] = {
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

