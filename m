Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3GJEdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 00:33:05 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:60043 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3GJEdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 00:33:00 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jlu@pengutronix.de, arnd@arndb.de, pantelis.antoniou@gmail.com,
        Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH] pps-gpio: add pinctrl suppport
Date: Sat, 29 Jun 2013 21:54:32 +0000
Message-Id: <1372542872-17970-1-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.8.2.rc3.6.g407929c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pincontrol support to pps-gpio driver for selecting the
repective GPIO muxing if applicable.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 drivers/pps/clients/pps-gpio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index eae0eda..8d51d10 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -33,6 +33,9 @@
 #include <linux/pps-gpio.h>
 #include <linux/gpio.h>
 #include <linux/list.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
 
@@ -93,6 +96,7 @@ static int pps_gpio_probe(struct platform_device *pdev)
 	const char *gpio_label;
 	int ret;
 	int pps_default_params;
+	struct pinctrl *pinctrl;
 	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
 	struct device_node *np = pdev->dev.of_node;
 
@@ -121,6 +125,11 @@ static int pps_gpio_probe(struct platform_device *pdev)
 			data->assert_falling_edge = true;
 	}
 
+	/* PINCTL setup */
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl))
+		pr_warn("pins are not configured from the driver\n");
+
 	/* GPIO setup */
 	ret = devm_gpio_request(&pdev->dev, data->gpio_pin, gpio_label);
 	if (ret) {
-- 
1.8.2.rc3.6.g407929c

