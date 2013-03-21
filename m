Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab3CUOct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:32:49 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10102 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab3CUOcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:32:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 21 Mar 2013 07:32:44 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>
CC: <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] gpio: palmas: add dt support
Date: Thu, 21 Mar 2013 20:00:14 +0530
Message-ID: <1363876214-25933-1-git-send-email-ldewangan@nvidia.com>
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
 drivers/gpio/gpio-palmas.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-palmas.c b/drivers/gpio/gpio-palmas.c
index e3a4e56..fddaa0d 100644
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
@@ -159,9 +159,18 @@ static int palmas_gpio_remove(struct platform_device *pdev)
 	return gpiochip_remove(&palmas_gpio->gpio_chip);
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id of_palmas_gpio_match[] = {
+	{ .compatible = "ti,palmas-gpio"},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_palmas_gpio_match);
+#endif
+
 static struct platform_driver palmas_gpio_driver = {
 	.driver.name	= "palmas-gpio",
 	.driver.owner	= THIS_MODULE,
+	.driver.of_match_table = of_match_ptr(of_palmas_gpio_match),
 	.probe		= palmas_gpio_probe,
 	.remove		= palmas_gpio_remove,
 };
-- 
1.7.1.1

