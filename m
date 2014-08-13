Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaHMMip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:38:45 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54078 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaHMMio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:38:44 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jg1.han@samsung.com, cooloney@gmail.com, lee.jones@linaro.org,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, thierry.reding@gmail.com
Cc: peter.griffin@linaro.org, patches@linaro.org, linux-fbdev@vger.kernel.org,
        linux-pwm@vger.kernel.org
Subject: [PATCH] backlight: remove .owner field for drivers using module_platform_driver
Date: Wed, 13 Aug 2014 13:38:38 +0100
Message-Id: <1407933518-7214-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the superflous .owner field for drivers which
use the module_platform_driver or platform_driver_register api,
as this is overriden in __platform_driver_register.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/video/backlight/88pm860x_bl.c    | 1 -
 drivers/video/backlight/aat2870_bl.c     | 1 -
 drivers/video/backlight/adp5520_bl.c     | 1 -
 drivers/video/backlight/as3711_bl.c      | 1 -
 drivers/video/backlight/da903x_bl.c      | 1 -
 drivers/video/backlight/da9052_bl.c      | 1 -
 drivers/video/backlight/ep93xx_bl.c      | 1 -
 drivers/video/backlight/gpio_backlight.c | 1 -
 drivers/video/backlight/lm3533_bl.c      | 1 -
 drivers/video/backlight/lp8788_bl.c      | 1 -
 drivers/video/backlight/max8925_bl.c     | 1 -
 drivers/video/backlight/ot200_bl.c       | 1 -
 drivers/video/backlight/pandora_bl.c     | 1 -
 drivers/video/backlight/platform_lcd.c   | 1 -
 drivers/video/backlight/pwm_bl.c         | 1 -
 drivers/video/backlight/tps65217_bl.c    | 1 -
 drivers/video/backlight/wm831x_bl.c      | 1 -
 17 files changed, 17 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 7db5234..6214fc6 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -265,7 +265,6 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 static struct platform_driver pm860x_backlight_driver = {
 	.driver		= {
 		.name	= "88pm860x-backlight",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= pm860x_backlight_probe,
 };
diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
index ec5350f..5e6401b 100644
--- a/drivers/video/backlight/aat2870_bl.c
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -217,7 +217,6 @@ static int aat2870_bl_remove(struct platform_device *pdev)
 static struct platform_driver aat2870_bl_driver = {
 	.driver = {
 		.name	= "aat2870-backlight",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= aat2870_bl_probe,
 	.remove		= aat2870_bl_remove,
diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index f37097a..b56cb3f 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -374,7 +374,6 @@ static SIMPLE_DEV_PM_OPS(adp5520_bl_pm_ops, adp5520_bl_suspend,
 static struct platform_driver adp5520_bl_driver = {
 	.driver		= {
 		.name	= "adp5520-backlight",
-		.owner	= THIS_MODULE,
 		.pm	= &adp5520_bl_pm_ops,
 	},
 	.probe		= adp5520_bl_probe,
diff --git a/drivers/video/backlight/as3711_bl.c b/drivers/video/backlight/as3711_bl.c
index bb1fc45..734a915 100644
--- a/drivers/video/backlight/as3711_bl.c
+++ b/drivers/video/backlight/as3711_bl.c
@@ -467,7 +467,6 @@ static int as3711_backlight_probe(struct platform_device *pdev)
 static struct platform_driver as3711_backlight_driver = {
 	.driver		= {
 		.name	= "as3711-backlight",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= as3711_backlight_probe,
 };
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 12c5d84..f793738 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -162,7 +162,6 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 static struct platform_driver da903x_backlight_driver = {
 	.driver		= {
 		.name	= "da903x-backlight",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= da903x_backlight_probe,
 };
diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
index 20d55be..d4bd74bd 100644
--- a/drivers/video/backlight/da9052_bl.c
+++ b/drivers/video/backlight/da9052_bl.c
@@ -173,7 +173,6 @@ static struct platform_driver da9052_wled_driver = {
 	.id_table	= da9052_wled_ids,
 	.driver	= {
 		.name	= "da9052-wled",
-		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index 0d1f633..0067931 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -128,7 +128,6 @@ static SIMPLE_DEV_PM_OPS(ep93xxbl_pm_ops, ep93xxbl_suspend, ep93xxbl_resume);
 static struct platform_driver ep93xxbl_driver = {
 	.driver		= {
 		.name	= "ep93xx-bl",
-		.owner	= THIS_MODULE,
 		.pm	= &ep93xxbl_pm_ops,
 	},
 	.probe		= ep93xxbl_probe,
diff --git a/drivers/video/backlight/gpio_backlight.c b/drivers/video/backlight/gpio_backlight.c
index 1cea688..ff2d540 100644
--- a/drivers/video/backlight/gpio_backlight.c
+++ b/drivers/video/backlight/gpio_backlight.c
@@ -157,7 +157,6 @@ static struct of_device_id gpio_backlight_of_match[] = {
 static struct platform_driver gpio_backlight_driver = {
 	.driver		= {
 		.name		= "gpio-backlight",
-		.owner		= THIS_MODULE,
 		.of_match_table = of_match_ptr(gpio_backlight_of_match),
 	},
 	.probe		= gpio_backlight_probe,
diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
index cff1fbe..0e2337f 100644
--- a/drivers/video/backlight/lm3533_bl.c
+++ b/drivers/video/backlight/lm3533_bl.c
@@ -397,7 +397,6 @@ static void lm3533_bl_shutdown(struct platform_device *pdev)
 static struct platform_driver lm3533_bl_driver = {
 	.driver = {
 		.name	= "lm3533-backlight",
-		.owner	= THIS_MODULE,
 		.pm	= &lm3533_bl_pm_ops,
 	},
 	.probe		= lm3533_bl_probe,
diff --git a/drivers/video/backlight/lp8788_bl.c b/drivers/video/backlight/lp8788_bl.c
index daba34d..a8eeeb4 100644
--- a/drivers/video/backlight/lp8788_bl.c
+++ b/drivers/video/backlight/lp8788_bl.c
@@ -321,7 +321,6 @@ static struct platform_driver lp8788_bl_driver = {
 	.remove = lp8788_backlight_remove,
 	.driver = {
 		.name = LP8788_DEV_BACKLIGHT,
-		.owner = THIS_MODULE,
 	},
 };
 module_platform_driver(lp8788_bl_driver);
diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index 66fa08c..7b738d6 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -197,7 +197,6 @@ static int max8925_backlight_probe(struct platform_device *pdev)
 static struct platform_driver max8925_backlight_driver = {
 	.driver		= {
 		.name	= "max8925-backlight",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= max8925_backlight_probe,
 };
diff --git a/drivers/video/backlight/ot200_bl.c b/drivers/video/backlight/ot200_bl.c
index f5a5202..3acdb9f 100644
--- a/drivers/video/backlight/ot200_bl.c
+++ b/drivers/video/backlight/ot200_bl.c
@@ -152,7 +152,6 @@ static int ot200_backlight_remove(struct platform_device *pdev)
 static struct platform_driver ot200_backlight_driver = {
 	.driver		= {
 		.name	= "ot200-backlight",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= ot200_backlight_probe,
 	.remove		= ot200_backlight_remove,
diff --git a/drivers/video/backlight/pandora_bl.c b/drivers/video/backlight/pandora_bl.c
index 2098c5d..b515c50 100644
--- a/drivers/video/backlight/pandora_bl.c
+++ b/drivers/video/backlight/pandora_bl.c
@@ -148,7 +148,6 @@ static int pandora_backlight_probe(struct platform_device *pdev)
 static struct platform_driver pandora_backlight_driver = {
 	.driver		= {
 		.name	= "pandora-backlight",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= pandora_backlight_probe,
 };
diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index c3d2e20..872a3bf 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -148,7 +148,6 @@ MODULE_DEVICE_TABLE(of, platform_lcd_of_match);
 static struct platform_driver platform_lcd_driver = {
 	.driver		= {
 		.name	= "platform-lcd",
-		.owner	= THIS_MODULE,
 		.pm	= &platform_lcd_pm_ops,
 		.of_match_table = of_match_ptr(platform_lcd_of_match),
 	},
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 38ca88b..77ee475 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -398,7 +398,6 @@ static const struct dev_pm_ops pwm_backlight_pm_ops = {
 static struct platform_driver pwm_backlight_driver = {
 	.driver		= {
 		.name		= "pwm-backlight",
-		.owner		= THIS_MODULE,
 		.pm		= &pwm_backlight_pm_ops,
 		.of_match_table	= of_match_ptr(pwm_backlight_of_match),
 	},
diff --git a/drivers/video/backlight/tps65217_bl.c b/drivers/video/backlight/tps65217_bl.c
index 595dcf5..c745df3 100644
--- a/drivers/video/backlight/tps65217_bl.c
+++ b/drivers/video/backlight/tps65217_bl.c
@@ -329,7 +329,6 @@ static int tps65217_bl_probe(struct platform_device *pdev)
 static struct platform_driver tps65217_bl_driver = {
 	.probe		= tps65217_bl_probe,
 	.driver		= {
-		.owner	= THIS_MODULE,
 		.name	= "tps65217-bl",
 	},
 };
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 8b9455e..6f59616 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -217,7 +217,6 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 static struct platform_driver wm831x_backlight_driver = {
 	.driver		= {
 		.name	= "wm831x-backlight",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= wm831x_backlight_probe,
 };
-- 
1.9.1

