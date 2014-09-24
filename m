Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaIXJsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:48:33 -0400
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:45726 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbaIXJsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:48:30 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: mturquette@linaro.org, ben-linux@fluff.org, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, tomasz.figa@gmail.com, emilio@elopez.com.ar,
        maxime.ripard@free-electrons.com, t-kristo@ti.com,
        sboyd@codeaurora.org
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH 3/5] clk: Remove .owner field for driver
Date: Wed, 24 Sep 2014 15:15:29 +0530
Message-Id: <1411551929-27868-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/clk/clk-axi-clkgen.c             |    1 -
 drivers/clk/clk-max77686.c               |    1 -
 drivers/clk/clk-max77802.c               |    1 -
 drivers/clk/clk-palmas.c                 |    1 -
 drivers/clk/clk-twl6040.c                |    1 -
 drivers/clk/clk-wm831x.c                 |    1 -
 drivers/clk/qcom/mmcc-apq8084.c          |    1 -
 drivers/clk/qcom/mmcc-msm8960.c          |    1 -
 drivers/clk/qcom/mmcc-msm8974.c          |    1 -
 drivers/clk/samsung/clk-s3c2410-dclk.c   |    1 -
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c |    1 -
 drivers/clk/sunxi/clk-sun6i-apb0.c       |    1 -
 drivers/clk/sunxi/clk-sun6i-ar100.c      |    1 -
 drivers/clk/sunxi/clk-sun8i-apb0.c       |    1 -
 drivers/clk/ti/clk-dra7-atl.c            |    1 -
 15 files changed, 15 deletions(-)

diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
index 1127ee4..e619285 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -544,7 +544,6 @@ static int axi_clkgen_remove(struct platform_device *pdev)
 static struct platform_driver axi_clkgen_driver = {
 	.driver = {
 		.name = "adi-axi-clkgen",
-		.owner = THIS_MODULE,
 		.of_match_table = axi_clkgen_ids,
 	},
 	.probe = axi_clkgen_probe,
diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
index ed0beb4..86cdb3a 100644
--- a/drivers/clk/clk-max77686.c
+++ b/drivers/clk/clk-max77686.c
@@ -73,7 +73,6 @@ MODULE_DEVICE_TABLE(platform, max77686_clk_id);
 static struct platform_driver max77686_clk_driver = {
 	.driver = {
 		.name  = "max77686-clk",
-		.owner = THIS_MODULE,
 	},
 	.probe = max77686_clk_probe,
 	.remove = max77686_clk_remove,
diff --git a/drivers/clk/clk-max77802.c b/drivers/clk/clk-max77802.c
index 8e480c5..0729dc7 100644
--- a/drivers/clk/clk-max77802.c
+++ b/drivers/clk/clk-max77802.c
@@ -84,7 +84,6 @@ MODULE_DEVICE_TABLE(platform, max77802_clk_id);
 static struct platform_driver max77802_clk_driver = {
 	.driver = {
 		.name  = "max77802-clk",
-		.owner = THIS_MODULE,
 	},
 	.probe = max77802_clk_probe,
 	.remove = max77802_clk_remove,
diff --git a/drivers/clk/clk-palmas.c b/drivers/clk/clk-palmas.c
index 781630e..8d45992 100644
--- a/drivers/clk/clk-palmas.c
+++ b/drivers/clk/clk-palmas.c
@@ -292,7 +292,6 @@ static int palmas_clks_remove(struct platform_device *pdev)
 static struct platform_driver palmas_clks_driver = {
 	.driver = {
 		.name = "palmas-clk",
-		.owner = THIS_MODULE,
 		.of_match_table = palmas_clks_of_match,
 	},
 	.probe = palmas_clks_probe,
diff --git a/drivers/clk/clk-twl6040.c b/drivers/clk/clk-twl6040.c
index 1ada79a..4a75513 100644
--- a/drivers/clk/clk-twl6040.c
+++ b/drivers/clk/clk-twl6040.c
@@ -112,7 +112,6 @@ static int twl6040_clk_remove(struct platform_device *pdev)
 static struct platform_driver twl6040_clk_driver = {
 	.driver = {
 		.name = "twl6040-clk",
-		.owner = THIS_MODULE,
 	},
 	.probe = twl6040_clk_probe,
 	.remove = twl6040_clk_remove,
diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
index b131041..ef67719 100644
--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -395,7 +395,6 @@ static struct platform_driver wm831x_clk_driver = {
 	.probe = wm831x_clk_probe,
 	.driver		= {
 		.name	= "wm831x-clk",
-		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/clk/qcom/mmcc-apq8084.c b/drivers/clk/qcom/mmcc-apq8084.c
index 751eea3..dab988a 100644
--- a/drivers/clk/qcom/mmcc-apq8084.c
+++ b/drivers/clk/qcom/mmcc-apq8084.c
@@ -3341,7 +3341,6 @@ static struct platform_driver mmcc_apq8084_driver = {
 	.remove		= mmcc_apq8084_remove,
 	.driver		= {
 		.name	= "mmcc-apq8084",
-		.owner	= THIS_MODULE,
 		.of_match_table = mmcc_apq8084_match_table,
 	},
 };
diff --git a/drivers/clk/qcom/mmcc-msm8960.c b/drivers/clk/qcom/mmcc-msm8960.c
index 2e80a21..68da36c 100644
--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -2679,7 +2679,6 @@ static struct platform_driver mmcc_msm8960_driver = {
 	.remove		= mmcc_msm8960_remove,
 	.driver		= {
 		.name	= "mmcc-msm8960",
-		.owner	= THIS_MODULE,
 		.of_match_table = mmcc_msm8960_match_table,
 	},
 };
diff --git a/drivers/clk/qcom/mmcc-msm8974.c b/drivers/clk/qcom/mmcc-msm8974.c
index bc8f519..be94c54 100644
--- a/drivers/clk/qcom/mmcc-msm8974.c
+++ b/drivers/clk/qcom/mmcc-msm8974.c
@@ -2570,7 +2570,6 @@ static struct platform_driver mmcc_msm8974_driver = {
 	.remove		= mmcc_msm8974_remove,
 	.driver		= {
 		.name	= "mmcc-msm8974",
-		.owner	= THIS_MODULE,
 		.of_match_table = mmcc_msm8974_match_table,
 	},
 };
diff --git a/drivers/clk/samsung/clk-s3c2410-dclk.c b/drivers/clk/samsung/clk-s3c2410-dclk.c
index 0449cc0..f4f29ed6 100644
--- a/drivers/clk/samsung/clk-s3c2410-dclk.c
+++ b/drivers/clk/samsung/clk-s3c2410-dclk.c
@@ -426,7 +426,6 @@ MODULE_DEVICE_TABLE(platform, s3c24xx_dclk_driver_ids);
 static struct platform_driver s3c24xx_dclk_driver = {
 	.driver = {
 		.name		= "s3c24xx-dclk",
-		.owner		= THIS_MODULE,
 		.pm		= &s3c24xx_dclk_pm_ops,
 	},
 	.probe = s3c24xx_dclk_probe,
diff --git a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
index e10d052..64f3e46 100644
--- a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
+++ b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
@@ -99,7 +99,6 @@ static int sun6i_a31_apb0_gates_clk_probe(struct platform_device *pdev)
 static struct platform_driver sun6i_a31_apb0_gates_clk_driver = {
 	.driver = {
 		.name = "sun6i-a31-apb0-gates-clk",
-		.owner = THIS_MODULE,
 		.of_match_table = sun6i_a31_apb0_gates_clk_dt_ids,
 	},
 	.probe = sun6i_a31_apb0_gates_clk_probe,
diff --git a/drivers/clk/sunxi/clk-sun6i-apb0.c b/drivers/clk/sunxi/clk-sun6i-apb0.c
index 1fa2337..7076360 100644
--- a/drivers/clk/sunxi/clk-sun6i-apb0.c
+++ b/drivers/clk/sunxi/clk-sun6i-apb0.c
@@ -65,7 +65,6 @@ static const struct of_device_id sun6i_a31_apb0_clk_dt_ids[] = {
 static struct platform_driver sun6i_a31_apb0_clk_driver = {
 	.driver = {
 		.name = "sun6i-a31-apb0-clk",
-		.owner = THIS_MODULE,
 		.of_match_table = sun6i_a31_apb0_clk_dt_ids,
 	},
 	.probe = sun6i_a31_apb0_clk_probe,
diff --git a/drivers/clk/sunxi/clk-sun6i-ar100.c b/drivers/clk/sunxi/clk-sun6i-ar100.c
index eca8ca0..acca532 100644
--- a/drivers/clk/sunxi/clk-sun6i-ar100.c
+++ b/drivers/clk/sunxi/clk-sun6i-ar100.c
@@ -221,7 +221,6 @@ static const struct of_device_id sun6i_a31_ar100_clk_dt_ids[] = {
 static struct platform_driver sun6i_a31_ar100_clk_driver = {
 	.driver = {
 		.name = "sun6i-a31-ar100-clk",
-		.owner = THIS_MODULE,
 		.of_match_table = sun6i_a31_ar100_clk_dt_ids,
 	},
 	.probe = sun6i_a31_ar100_clk_probe,
diff --git a/drivers/clk/sunxi/clk-sun8i-apb0.c b/drivers/clk/sunxi/clk-sun8i-apb0.c
index 1f5ba9b..155d002 100644
--- a/drivers/clk/sunxi/clk-sun8i-apb0.c
+++ b/drivers/clk/sunxi/clk-sun8i-apb0.c
@@ -56,7 +56,6 @@ static const struct of_device_id sun8i_a23_apb0_clk_dt_ids[] = {
 static struct platform_driver sun8i_a23_apb0_clk_driver = {
 	.driver = {
 		.name = "sun8i-a23-apb0-clk",
-		.owner = THIS_MODULE,
 		.of_match_table = sun8i_a23_apb0_clk_dt_ids,
 	},
 	.probe = sun8i_a23_apb0_clk_probe,
diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index af29359..990e1d9 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -301,7 +301,6 @@ MODULE_DEVICE_TABLE(of, of_dra7_atl_clk_match_tbl);
 static struct platform_driver dra7_atl_clk_driver = {
 	.driver = {
 		.name = "dra7-atl",
-		.owner = THIS_MODULE,
 		.of_match_table = of_dra7_atl_clk_match_tbl,
 	},
 	.probe = of_dra7_atl_clk_probe,
-- 
1.7.9.5

