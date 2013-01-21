Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab3AUKJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:09:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3AUKJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:50 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 23/33] pwm: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:16 +0100
Message-Id: <1358762966-20791-24-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:yhlmZYU3Z4PtkNNCR7CBJfuC/EW8DvTO3s8HU9AkLeD
 8p8RhoCptkEoSZ5g3ZoQRMWiieEEw/BpZMX7m+/aE3gvYnwk53
 SHRORWftzKmI3Woz8XKI0/laJ+UNBgKvyJ/ridrYRYKwlocqRF
 QRHGLUlFHHp5VBv/6oKYzbbVufoAvlKeMHIqO2NwNHzR4aRPlG
 WwXGbmT2Utm8hCcH+/jtEqZPPxPtoEijRo4iXWx+wcDBevSU9d
 HW8TRv7Hjpcu+0dXuwwQbLviJJjUFK1jbUFoBYLJZPkb9Audcv
 R1BNbP6zr37VmPy9WzMszcqYkwDi8YIZn3ntui/BZAd2ZkhpT2
 EK9Qo0OMfQvNYKcgl6xKmKvGrkchdtrt0Wyiz/GYxzuUpP4oMC
 /cUrl9XtGqt9HLeILPy1HyFeg9ZQqlvNcdVhJkqfFKLi3rtuF8
 SDRCa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/pwm/pwm-imx.c      | 6 +++---
 drivers/pwm/pwm-lpc32xx.c  | 6 +++---
 drivers/pwm/pwm-mxs.c      | 6 +++---
 drivers/pwm/pwm-puv3.c     | 6 +++---
 drivers/pwm/pwm-pxa.c      | 6 +++---
 drivers/pwm/pwm-spear.c    | 6 +++---
 drivers/pwm/pwm-tegra.c    | 6 +++---
 drivers/pwm/pwm-tiecap.c   | 6 +++---
 drivers/pwm/pwm-tiehrpwm.c | 6 +++---
 drivers/pwm/pwm-tipwmss.c  | 6 +++---
 drivers/pwm/pwm-vt8500.c   | 6 +++---
 11 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 65a86bd..3f5677b 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -274,9 +274,9 @@ static int imx_pwm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	imx->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
-	if (imx->mmio_base == NULL)
-		return -EADDRNOTAVAIL;
+	imx->mmio_base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(imx->mmio_base))
+		return PTR_ERR(imx->mmio_base);
 
 	data = of_id->data;
 	imx->config = data->config;
diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index 1410644..b3f0d0d 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -110,9 +110,9 @@ static int lpc32xx_pwm_probe(struct platform_device *pdev)
 	if (!res)
 		return -EINVAL;
 
-	lpc32xx->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!lpc32xx->base)
-		return -EADDRNOTAVAIL;
+	lpc32xx->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(lpc32xx->base))
+		return PTR_ERR(lpc32xx->base);
 
 	lpc32xx->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(lpc32xx->clk))
diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
index 7ec345f..a53d309 100644
--- a/drivers/pwm/pwm-mxs.c
+++ b/drivers/pwm/pwm-mxs.c
@@ -139,9 +139,9 @@ static int mxs_pwm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	mxs->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!mxs->base)
-		return -EADDRNOTAVAIL;
+	mxs->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mxs->base))
+		return PTR_ERR(mxs->base);
 
 	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
 	if (IS_ERR(pinctrl))
diff --git a/drivers/pwm/pwm-puv3.c b/drivers/pwm/pwm-puv3.c
index b882f60..db964e6e 100644
--- a/drivers/pwm/pwm-puv3.c
+++ b/drivers/pwm/pwm-puv3.c
@@ -123,9 +123,9 @@ static int pwm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	puv3->base = devm_request_and_ioremap(&pdev->dev, r);
-	if (puv3->base == NULL)
-		return -EADDRNOTAVAIL;
+	puv3->base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(puv3->base))
+		return PTR_ERR(puv3->base);
 
 	puv3->chip.dev = &pdev->dev;
 	puv3->chip.ops = &puv3_pwm_ops;
diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index f32fc4e..20370e6 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -165,9 +165,9 @@ static int pwm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	pwm->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
-	if (pwm->mmio_base == NULL)
-		return -EADDRNOTAVAIL;
+	pwm->mmio_base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(pwm->mmio_base))
+		return PTR_ERR(pwm->mmio_base);
 
 	ret = pwmchip_add(&pwm->chip);
 	if (ret < 0) {
diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 83b21d9..69a2d9e 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -192,9 +192,9 @@ static int spear_pwm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	pc->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!pc->mmio_base)
-		return -EADDRNOTAVAIL;
+	pc->mmio_base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(pc->mmio_base))
+		return PTR_ERR(pc->mmio_base);
 
 	pc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pc->clk))
diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index 30c0e2b..71900e8 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -186,9 +186,9 @@ static int tegra_pwm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	pwm->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!pwm->mmio_base)
-		return -EADDRNOTAVAIL;
+	pwm->mmio_base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(pwm->mmio_base))
+		return PTR_ERR(pwm->mmio_base);
 
 	platform_set_drvdata(pdev, pwm);
 
diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 5cf016d..27a67d6 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -238,9 +238,9 @@ static int ecap_pwm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	pc->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!pc->mmio_base)
-		return -EADDRNOTAVAIL;
+	pc->mmio_base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(pc->mmio_base))
+		return PTR_ERR(pc->mmio_base);
 
 	ret = pwmchip_add(&pc->chip);
 	if (ret < 0) {
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 72a6dd4..5a13995 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -453,9 +453,9 @@ static int ehrpwm_pwm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	pc->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!pc->mmio_base)
-		return  -EADDRNOTAVAIL;
+	pc->mmio_base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(pc->mmio_base))
+		return PTR_ERR(pc->mmio_base);
 
 	/* Acquire tbclk for Time Base EHRPWM submodule */
 	pc->tbclk = devm_clk_get(&pdev->dev, "tbclk");
diff --git a/drivers/pwm/pwm-tipwmss.c b/drivers/pwm/pwm-tipwmss.c
index 3448a1c..17cbc59 100644
--- a/drivers/pwm/pwm-tipwmss.c
+++ b/drivers/pwm/pwm-tipwmss.c
@@ -75,9 +75,9 @@ static int pwmss_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	info->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!info->mmio_base)
-		return -EADDRNOTAVAIL;
+	info->mmio_base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(info->mmio_base))
+		return PTR_ERR(info->mmio_base);
 
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
index b0ba2d4..f9de9b2 100644
--- a/drivers/pwm/pwm-vt8500.c
+++ b/drivers/pwm/pwm-vt8500.c
@@ -178,9 +178,9 @@ static int vt8500_pwm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	chip->base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!chip->base)
-		return -EADDRNOTAVAIL;
+	chip->base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(chip->base))
+		return PTR_ERR(chip->base);
 
 	ret = clk_prepare(chip->clk);
 	if (ret < 0) {
-- 
1.8.1.1

