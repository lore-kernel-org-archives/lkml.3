Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3FLL3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 07:29:19 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:36135 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3FLL3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 07:29:17 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: linux-pwm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pwm: Fill in missing .owner fields
Date: Wed, 12 Jun 2013 13:29:13 +0200
Message-Id: <1371036553-32263-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers don't set the .owner fields of the struct device_driver or
struct pwm_ops, which causes the module usage count to become wrong.

Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
---
 drivers/pwm/pwm-atmel-tcb.c | 1 +
 drivers/pwm/pwm-bfin.c      | 1 +
 drivers/pwm/pwm-imx.c       | 1 +
 drivers/pwm/pwm-lpc32xx.c   | 1 +
 drivers/pwm/pwm-mxs.c       | 1 +
 drivers/pwm/pwm-pca9685.c   | 1 +
 drivers/pwm/pwm-puv3.c      | 1 +
 drivers/pwm/pwm-spear.c     | 1 +
 drivers/pwm/pwm-tegra.c     | 1 +
 9 files changed, 9 insertions(+)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 09be626..ba6ce01 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -434,6 +434,7 @@ MODULE_DEVICE_TABLE(of, atmel_tcb_pwm_dt_ids);
 static struct platform_driver atmel_tcb_pwm_driver = {
 	.driver = {
 		.name = "atmel-tcb-pwm",
+		.owner = THIS_MODULE,
 		.of_match_table = atmel_tcb_pwm_dt_ids,
 	},
 	.probe = atmel_tcb_pwm_probe,
diff --git a/drivers/pwm/pwm-bfin.c b/drivers/pwm/pwm-bfin.c
index 7631ef1..9985d83 100644
--- a/drivers/pwm/pwm-bfin.c
+++ b/drivers/pwm/pwm-bfin.c
@@ -149,6 +149,7 @@ static int bfin_pwm_remove(struct platform_device *pdev)
 static struct platform_driver bfin_pwm_driver = {
 	.driver = {
 		.name = "bfin-pwm",
+		.owner = THIS_MODULE,
 	},
 	.probe = bfin_pwm_probe,
 	.remove = bfin_pwm_remove,
diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index c938bae..2b7c4f8 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -295,6 +295,7 @@ static int imx_pwm_remove(struct platform_device *pdev)
 static struct platform_driver imx_pwm_driver = {
 	.driver		= {
 		.name	= "imx-pwm",
+		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(imx_pwm_dt_ids),
 	},
 	.probe		= imx_pwm_probe,
diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index 8272883..efb6c7b 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -171,6 +171,7 @@ MODULE_DEVICE_TABLE(of, lpc32xx_pwm_dt_ids);
 static struct platform_driver lpc32xx_pwm_driver = {
 	.driver = {
 		.name = "lpc32xx-pwm",
+		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(lpc32xx_pwm_dt_ids),
 	},
 	.probe = lpc32xx_pwm_probe,
diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
index 6489a4b..2c77b81 100644
--- a/drivers/pwm/pwm-mxs.c
+++ b/drivers/pwm/pwm-mxs.c
@@ -182,6 +182,7 @@ MODULE_DEVICE_TABLE(of, mxs_pwm_dt_ids);
 static struct platform_driver mxs_pwm_driver = {
 	.driver = {
 		.name = "mxs-pwm",
+		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(mxs_pwm_dt_ids),
 	},
 	.probe = mxs_pwm_probe,
diff --git a/drivers/pwm/pwm-pca9685.c b/drivers/pwm/pwm-pca9685.c
index 2afc904..c9f9e65 100644
--- a/drivers/pwm/pwm-pca9685.c
+++ b/drivers/pwm/pwm-pca9685.c
@@ -199,6 +199,7 @@ static const struct pwm_ops pca9685_pwm_ops = {
 	.config = pca9685_pwm_config,
 	.request = pca9685_pwm_request,
 	.free = pca9685_pwm_free,
+	.owner = THIS_MODULE,
 };
 
 static struct regmap_config pca9685_regmap_i2c_config = {
diff --git a/drivers/pwm/pwm-puv3.c b/drivers/pwm/pwm-puv3.c
index ed6007b..a9a2808 100644
--- a/drivers/pwm/pwm-puv3.c
+++ b/drivers/pwm/pwm-puv3.c
@@ -146,6 +146,7 @@ static int pwm_remove(struct platform_device *pdev)
 static struct platform_driver puv3_pwm_driver = {
 	.driver = {
 		.name = "PKUnity-v3-PWM",
+		.owner = THIS_MODULE,
 	},
 	.probe = pwm_probe,
 	.remove = pwm_remove,
diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 6d99e2c..a54d214 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -259,6 +259,7 @@ MODULE_DEVICE_TABLE(of, spear_pwm_of_match);
 static struct platform_driver spear_pwm_driver = {
 	.driver = {
 		.name = "spear-pwm",
+		.owner = THIS_MODULE,
 		.of_match_table = spear_pwm_of_match,
 	},
 	.probe = spear_pwm_probe,
diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index a540293..74298c5 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -239,6 +239,7 @@ MODULE_DEVICE_TABLE(of, tegra_pwm_of_match);
 static struct platform_driver tegra_pwm_driver = {
 	.driver = {
 		.name = "tegra-pwm",
+		.owner = THIS_MODULE,
 		.of_match_table = tegra_pwm_of_match,
 	},
 	.probe = tegra_pwm_probe,
-- 
1.8.2

