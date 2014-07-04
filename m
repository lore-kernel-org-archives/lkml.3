Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbaGDKDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:03:05 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47638 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbaGDJzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:55:54 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Cc: gnurou@gmail.com, linus.walleij@linaro.org, trblinux@gmail.com
Subject: [PATCH] gpiolib: of: Update debug messages for of_get_named_gpiod_flags
Date: Fri,  4 Jul 2014 15:22:09 +0530
Message-Id: <1404467529-26301-1-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is the debug output (only a few examples) before and after the patch.

$ dmesg | grep of_get_named_gpiod_flags

Before:
of_get_named_gpiod_flags: can't parse gpios property of node '/mmc@12220000[0]'
of_get_named_gpiod_flags exited with status 0

After:
of_get_named_gpiod_flags: can't parse 'wp-gpios' property of node '/mmc@12220000[0]'
of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio-keys/power[0]' - status (0)

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
 drivers/gpio/gpiolib-of.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index af7e25c..e60cdab 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -82,15 +82,16 @@ struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
 	ret = of_parse_phandle_with_args(np, propname, "#gpio-cells", index,
 					 &gg_data.gpiospec);
 	if (ret) {
-		pr_debug("%s: can't parse gpios property of node '%s[%d]'\n",
-			__func__, np->full_name, index);
+		pr_debug("%s: can't parse '%s' property of node '%s[%d]'\n",
+			__func__, propname, np->full_name, index);
 		return ERR_PTR(ret);
 	}
 
 	gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
 
 	of_node_put(gg_data.gpiospec.np);
-	pr_debug("%s exited with status %d\n", __func__,
+	pr_debug("%s: parsed '%s' property of node '%s[%d]' - status (%d)\n",
+		 __func__, propname, np->full_name, index,
 		 PTR_ERR_OR_ZERO(gg_data.out_gpio));
 	return gg_data.out_gpio;
 }
-- 
1.7.9.5

