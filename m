Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3EPLOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:14:50 -0400
Received: from sauhun.de ([89.238.76.85]:56074 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab3EPLOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:14:43 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org
Subject: [PATCH 05/33] drivers/gpio: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:33 +0200
Message-Id: <1368702961-4325-6-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/gpio/gpio-mvebu.c |    5 -----
 drivers/gpio/gpio-tegra.c |    5 -----
 2 files changed, 10 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index bf69a7e..3a4816a 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -619,11 +619,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	 * per-CPU registers */
 	if (soc_variant == MVEBU_GPIO_SOC_VARIANT_ARMADAXP) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		if (!res) {
-			dev_err(&pdev->dev, "Cannot get memory resource\n");
-			return -ENODEV;
-		}
-
 		mvchip->percpu_membase = devm_ioremap_resource(&pdev->dev,
 							       res);
 		if (IS_ERR(mvchip->percpu_membase))
diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index da4cb5b..9a62672 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -463,11 +463,6 @@ static int tegra_gpio_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Missing MEM resource\n");
-		return -ENODEV;
-	}
-
 	regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
-- 
1.7.10.4

