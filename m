Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab3ENJ7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:59:13 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46432 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab3ENJ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:59:12 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: broonie@kernel.org, grant.likely@linaro.org
Cc: swarren@wwwdotorg.org, spi-devel-general@lists.sourceforge.net,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers/spi/spi-tegra114.c clean use of devm_ioremap_resource()
Date: Tue, 14 May 2013 12:07:12 +0200
Message-Id: <1368526032-31371-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check of 'r' and calls to dev_err are already done in devm_ioremap_resource,
so no need to do them twice.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/spi/spi-tegra114.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 598eb45..18a6592 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1059,18 +1059,12 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	spin_lock_init(&tspi->lock);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "No IO memory resource\n");
-		ret = -ENODEV;
-		goto exit_free_master;
-	}
-	tspi->phys = r->start;
 	tspi->base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(tspi->base)) {
 		ret = PTR_ERR(tspi->base);
-		dev_err(&pdev->dev, "ioremap failed: err = %d\n", ret);
 		goto exit_free_master;
 	}
+	tspi->phys = r->start;
 
 	spi_irq = platform_get_irq(pdev, 0);
 	tspi->irq = spi_irq;
-- 
1.7.10.4

