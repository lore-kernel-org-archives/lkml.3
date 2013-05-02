Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3EBVCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:02:14 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:40999 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3EBVCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:02:13 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: jic23@cam.ac.uk
Cc: ch.naveen@samsung.com, lars@metafoo.de, sachin.kamat@linaro.org,
        dianders@chromium.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] iio: adc: exynos_adc: use devm_ioremap_resource()
Date: Thu,  2 May 2013 23:10:31 +0200
Message-Id: <1367529031-4915-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace calls to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_request_and_ioremap.cocci.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/iio/adc/exynos_adc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 9f3a8ef..22d034a 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -270,16 +270,16 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	info = iio_priv(indio_dev);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	info->regs = devm_request_and_ioremap(&pdev->dev, mem);
-	if (!info->regs) {
-		ret = -ENOMEM;
+	info->regs = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(info->regs)) {
+		ret = PTR_ERR(info->regs);
 		goto err_iio;
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	info->enable_reg = devm_request_and_ioremap(&pdev->dev, mem);
-	if (!info->enable_reg) {
-		ret = -ENOMEM;
+	info->enable_reg = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(info->enable_reg)) {
+		ret = PTR_ERR(info->enable_reg);
 		goto err_iio;
 	}
 
-- 
1.7.10.4

