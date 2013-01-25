Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab3AYWrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:47:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60004 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab3AYWqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:46:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 12/19] pinctrl: exynos: don't mark probing functions as __init
Date: Fri, 25 Jan 2013 22:44:11 +0000
Message-Id: <1359153858-31992-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:v0GGnCVAv2P3zerf5oKp6rU2WrYQDL1GKx9sryH5q/z
 QEWfBZmr1srpwQrB4BfP7j9w43h4BjW5S/y7wA63X9TKZ+ACQx
 XeXPQMme8YOTEJYHWfhc5HIQwJrUdGDccgGRyB0IDB4mZ4bIIl
 qfk2Xx0IJ8NK5OvKbG57PIl563McE/FbkgO0C6QzKOzx3iWIXk
 niHe5P2YrQSS8UNP4ppdK76rlAoUXHVQRLzzrq8qSu0B0Jp6Rt
 qQeMbfBcWl1T//kIQqQtPRRhDn/QBM7pKeOM8S9De8jFS1SzZw
 72ygCN5lbk5MU+rhp8DcIWwoTxxQuCP4yjHRXVyaI5yS1IUPaR
 a6bHDSmV712726niP8L0zY8Q8+XZ0TntPe21Ne9WI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions called from a driver probe() method must not be
marked __init, because they may get called after the
init phase is done, when the device shows up late, or
because of deferred probing.

Without this patch, building exynos_defconfig results in
multiple warnings like:

WARNING: drivers/pinctrl/built-in.o(.text+0x51bc): Section mismatch in reference from the function exynos5440_pinctrl_probe() to the function .init.text:exynos5440_gpiolib_register()
The function exynos5440_pinctrl_probe() references
the function __init exynos5440_gpiolib_register().
This is often because exynos5440_pinctrl_probe lacks a __init
annotation or the annotation of exynos5440_gpiolib_register is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/pinctrl/pinctrl-exynos5440.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
index de05b64..1427299 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -599,7 +599,7 @@ static int exynos5440_gpio_direction_output(struct gpio_chip *gc, unsigned offse
 }
 
 /* parse the pin numbers listed in the 'samsung,exynos5440-pins' property */
-static int __init exynos5440_pinctrl_parse_dt_pins(struct platform_device *pdev,
+static int exynos5440_pinctrl_parse_dt_pins(struct platform_device *pdev,
 			struct device_node *cfg_np, unsigned int **pin_list,
 			unsigned int *npins)
 {
@@ -630,7 +630,7 @@ static int __init exynos5440_pinctrl_parse_dt_pins(struct platform_device *pdev,
  * Parse the information about all the available pin groups and pin functions
  * from device node of the pin-controller.
  */
-static int __init exynos5440_pinctrl_parse_dt(struct platform_device *pdev,
+static int exynos5440_pinctrl_parse_dt(struct platform_device *pdev,
 				struct exynos5440_pinctrl_priv_data *priv)
 {
 	struct device *dev = &pdev->dev;
@@ -723,7 +723,7 @@ static int __init exynos5440_pinctrl_parse_dt(struct platform_device *pdev,
 }
 
 /* register the pinctrl interface with the pinctrl subsystem */
-static int __init exynos5440_pinctrl_register(struct platform_device *pdev,
+static int exynos5440_pinctrl_register(struct platform_device *pdev,
 				struct exynos5440_pinctrl_priv_data *priv)
 {
 	struct device *dev = &pdev->dev;
@@ -798,7 +798,7 @@ static int __init exynos5440_pinctrl_register(struct platform_device *pdev,
 }
 
 /* register the gpiolib interface with the gpiolib subsystem */
-static int __init exynos5440_gpiolib_register(struct platform_device *pdev,
+static int exynos5440_gpiolib_register(struct platform_device *pdev,
 				struct exynos5440_pinctrl_priv_data *priv)
 {
 	struct gpio_chip *gc;
@@ -831,7 +831,7 @@ static int __init exynos5440_gpiolib_register(struct platform_device *pdev,
 }
 
 /* unregister the gpiolib interface with the gpiolib subsystem */
-static int __init exynos5440_gpiolib_unregister(struct platform_device *pdev,
+static int exynos5440_gpiolib_unregister(struct platform_device *pdev,
 				struct exynos5440_pinctrl_priv_data *priv)
 {
 	int ret = gpiochip_remove(priv->gc);
-- 
1.8.0

