Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbbARLlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:41:15 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:62652 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbARLj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:39:58 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Fabian Vogt <fabian@ritter-vogt.de>
Subject: [PATCH 6/8] gpio/zevio: Use of_mm_gpiochip_remove
Date: Sun, 18 Jan 2015 12:39:31 +0100
Message-Id: <1421581173-28416-7-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since d621e8bae5ac9c67 (Create of_mm_gpiochip_remove), there is a
counterpart for of_mm_gpiochip_add.

This patch implements the remove function of the driver making use of
it.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Fabian Vogt <fabian@ritter-vogt.de>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpio-zevio.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpio/gpio-zevio.c b/drivers/gpio/gpio-zevio.c
index f769cd5..6f02d7c 100644
--- a/drivers/gpio/gpio-zevio.c
+++ b/drivers/gpio/gpio-zevio.c
@@ -181,6 +181,8 @@ static int zevio_gpio_probe(struct platform_device *pdev)
 	if (!controller)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, controller);
+
 	/* Copy our reference */
 	controller->chip.gc = zevio_gpio_chip;
 	controller->chip.gc.dev = &pdev->dev;
@@ -202,6 +204,15 @@ static int zevio_gpio_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int zevio_gpio_remove(struct platform_device *pdev)
+{
+	struct zevio_gpio *controller = platform_get_drvdata(pdev);
+
+	of_mm_gpiochip_remove(&controller->chip);
+
+	return 0;
+}
+
 static const struct of_device_id zevio_gpio_of_match[] = {
 	{ .compatible = "lsi,zevio-gpio", },
 	{ },
@@ -215,6 +226,7 @@ static struct platform_driver zevio_gpio_driver = {
 		.of_match_table = zevio_gpio_of_match,
 	},
 	.probe		= zevio_gpio_probe,
+	.remove		= zevio_gpio_remove,
 };
 module_platform_driver(zevio_gpio_driver);
 
-- 
2.1.4

