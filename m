Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab3K2RJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:09:23 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:47234 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab3K2RJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:09:21 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Mark Brown <broonie@kernel.org>, Jingoo Han <jg1.han@samsung.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: omap-100k: remove pointless _remove function
Date: Fri, 29 Nov 2013 18:09:07 +0100
Message-Id: <1385744947-10283-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Commit [8074cf06: use devm_spi_register_master()] removed the last
bit of omap1_spi100k_remove function that had side effects.  After
call to spi_unregister_master was removed, the function consisted
of:

2. call to platform_get_drvdata whose return value was only used in:
2. call to spi_master_get_devdata whose return value was not used,
3. an if statement checking if zero was not zero, and
4. call to platform_get_resource whose return value was not used.

Ah, yes, and of course, final return 0. ;)

Since omap1_spi100k_remove no longer does anything, it can be
safely removed.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/spi/spi-omap-100k.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index b6ed82b..0d32054 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -470,31 +470,12 @@ err:
 	return status;
 }
 
-static int omap1_spi100k_remove(struct platform_device *pdev)
-{
-	struct spi_master       *master;
-	struct omap1_spi100k    *spi100k;
-	struct resource         *r;
-	int			status = 0;
-
-	master = platform_get_drvdata(pdev);
-	spi100k = spi_master_get_devdata(master);
-
-	if (status != 0)
-		return status;
-
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	return 0;
-}
-
 static struct platform_driver omap1_spi100k_driver = {
 	.driver = {
 		.name		= "omap1_spi100k",
 		.owner		= THIS_MODULE,
 	},
 	.probe		= omap1_spi100k_probe,
-	.remove		= omap1_spi100k_remove,
 };
 
 module_platform_driver(omap1_spi100k_driver);
@@ -502,4 +483,3 @@ module_platform_driver(omap1_spi100k_driver);
 MODULE_DESCRIPTION("OMAP7xx SPI 100k controller driver");
 MODULE_AUTHOR("Fabrice Crohas <fcrohas@gmail.com>");
 MODULE_LICENSE("GPL");
-
-- 
1.8.4.1

