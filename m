Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3CMGoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:44:17 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:34021 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab3CMGoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:44:04 -0400
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: grant.likely@secretlab.ca, t.figa@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        Girish K S <girishks2000@gmail.com>
Subject: [PATCH V3 3/5] spi: s3c64xx: Added provision for non-gpio i/o's
Date: Wed, 13 Mar 2013 12:13:32 +0530
Message-Id: <1363157014-9615-4-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Girish K S <girishks2000@gmail.com>

Currently the drivers supports only the GPIO based i/o pins.
But there are Exynos SoC's that use the same controller with
dedicated i/o pins.

This patch  provides provision to support gpio/dedicated pins.
The decision is made by parsing the "gpios" property in the spi
node.

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
 drivers/spi/spi-s3c64xx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 054b8d4..94716d1 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1112,6 +1112,9 @@ static int s3c64xx_spi_parse_dt_gpio(struct s3c64xx_spi_driver_data *sdd)
 	struct device *dev = &sdd->pdev->dev;
 	int idx, gpio, ret;
 
+	if (!of_find_property(dev->of_node, "gpios", NULL))
+		return 0;
+
 	/* find gpios for mosi, miso and clock lines */
 	for (idx = 0; idx < 3; idx++) {
 		gpio = of_get_gpio(dev->of_node, idx);
@@ -1138,6 +1141,11 @@ free_gpio:
 static void s3c64xx_spi_dt_gpio_free(struct s3c64xx_spi_driver_data *sdd)
 {
 	unsigned int idx;
+	struct device *dev = &sdd->pdev->dev;
+
+	if (!of_find_property(dev->of_node, "gpios", NULL))
+		return;
+
 	for (idx = 0; idx < 3; idx++)
 		gpio_free(sdd->gpios[idx]);
 }
-- 
1.8.0

