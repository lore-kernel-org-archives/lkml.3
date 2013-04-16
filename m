Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935858Ab3DPOgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:36:14 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16678 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935731Ab3DPOgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:36:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 16 Apr 2013 07:36:05 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>
CC: <rob.herring@calxeda.com>, <gg@slimlogic.co.uk>, <ian@slimlogic.co.uk>,
        <j-keerthy@ti.com>, <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] gpio: palmas: add dt support
Date: Tue, 16 Apr 2013 20:01:45 +0530
Message-ID: <1366122705-3579-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_device_id table for Palma GPIO to be enable the
driver from DT file.

The driver can be registered from DT file as:
	palmas: tps65913@58 {
		:::::::::::
		palmas_gpio: palmas_gpio {
			compatible = "ti,palmas-gpio";
			gpio-controller;
			#gpio-cells = <2>;
		};
	};

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
Remove the ifdefs of CONFIG_OF around of_device_id structure for
defining compatible values.

 drivers/gpio/gpio-palmas.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-palmas.c b/drivers/gpio/gpio-palmas.c
index e3a4e56..5802662 100644
--- a/drivers/gpio/gpio-palmas.c
+++ b/drivers/gpio/gpio-palmas.c
@@ -134,7 +134,7 @@ static int palmas_gpio_probe(struct platform_device *pdev)
 	palmas_gpio->gpio_chip.get	= palmas_gpio_get;
 	palmas_gpio->gpio_chip.dev = &pdev->dev;
 #ifdef CONFIG_OF_GPIO
-	palmas_gpio->gpio_chip.of_node = palmas->dev->of_node;
+	palmas_gpio->gpio_chip.of_node = pdev->dev.of_node;
 #endif
 	palmas_pdata = dev_get_platdata(palmas->dev);
 	if (palmas_pdata && palmas_pdata->gpio_base)
@@ -159,9 +159,16 @@ static int palmas_gpio_remove(struct platform_device *pdev)
 	return gpiochip_remove(&palmas_gpio->gpio_chip);
 }
 
+static struct of_device_id of_palmas_gpio_match[] = {
+	{ .compatible = "ti,palmas-gpio"},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_palmas_gpio_match);
+
 static struct platform_driver palmas_gpio_driver = {
 	.driver.name	= "palmas-gpio",
 	.driver.owner	= THIS_MODULE,
+	.driver.of_match_table = of_palmas_gpio_match,
 	.probe		= palmas_gpio_probe,
 	.remove		= palmas_gpio_remove,
 };
-- 
1.7.1.1

