Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab3AYOSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:18:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab3AYOO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:14:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 12/19] pinctrl: exynos: don't mark probing functions as __init
Date: Fri, 25 Jan 2013 14:14:29 +0000
Message-Id: <1359123276-15833-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:tif8eVFcrOesVUvyoRaEwlKAjwr5gz9rieqO2i3e9tT
 5cOzERWzTD8Abt1wPjaI3go65F93Yq68bFN9mPey0pKGSjDlyl
 mzk8Z8ZxV8UH1aip7Ds7l98+s4TWw8NKk9WYspDMYyNPGatEir
 qihsqkO2L/N2v301zzwB2Y/9ABC443O4beTGhasIGMTXfWkvYf
 g1BSovQtdFSELPhdYHHYjSLQrGJjQqNAzhSvycx2Nz08/Escmn
 fxU4qrjcy/doKkPdUjhQn3ULPUBBbAQuZEA5wCGQGOKRWcwTyG
 S2k/aJT5PLgeZZwZ2O0Enbz7HPVsWK0XcRKtzAU3a6jk9Elqwv
 hPsWMWVMmIaDfoIvHk6iaInEWRpm4Iq62VzIS4ncx
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

