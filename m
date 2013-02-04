Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3BDMFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:05:00 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:57792 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3BDL5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:16 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 45/73] regulator: ab8500: Update voltage handling for fixed voltage regulators
Date: Mon,  4 Feb 2013 11:54:00 +0000
Message-Id: <1359978868-28736-46-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few over-lapping methods for voltage selection operating
in the AB8500 regulator driver currently. This patch removes unused,
unnecessary variables from the regulator_info structures and provides
voltage tables for those regulators which have fixed voltages.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   89 ++++++++++++++++++++------------------------
 1 file changed, 41 insertions(+), 48 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index c204380..ae2d755 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -143,6 +143,26 @@ static const int ldo_sdio_voltages[] = {
 	3050000,
 };
 
+static const int fixed_1200000_voltage[] = {
+	1200000,
+};
+
+static const int fixed_1800000_voltage[] = {
+	1800000,
+};
+
+static const int fixed_2000000_voltage[] = {
+	2000000,
+};
+
+static const int fixed_2050000_voltage[] = {
+	2050000,
+};
+
+static const int fixed_3300000_voltage[] = {
+	3300000,
+};
+
 static int ab8500_regulator_enable(struct regulator_dev *rdev)
 {
 	int ret;
@@ -401,7 +421,6 @@ static struct regulator_ops ab8500_regulator_mode_ops = {
 	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
 	.set_mode		= ab8500_regulator_set_mode,
 	.get_mode		= ab8500_regulator_get_mode,
-	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
 	.list_voltage		= regulator_list_voltage_table,
 	.set_voltage_time_sel 	= ab8500_regulator_set_voltage_time_sel,
 };
@@ -410,7 +429,6 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.enable			= ab8500_regulator_enable,
 	.disable		= ab8500_regulator_disable,
 	.is_enabled		= ab8500_regulator_is_enabled,
-	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
 	.list_voltage		= regulator_list_voltage_table,
 };
 
@@ -522,7 +540,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2000000,
+			.volt_table	= fixed_2000000_voltage,
 			.enable_time	= 500,
 		},
 		.delay			= 500,
@@ -542,7 +560,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2000000,
+			.volt_table	= fixed_2000000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -557,7 +575,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2050000,
+			.volt_table	= fixed_2050000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -572,7 +590,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2050000,
+			.volt_table	= fixed_2050000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -587,7 +605,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 1800000,
+			.volt_table	= fixed_1800000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -606,7 +624,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 1200000,
+			.volt_table	= fixed_1200000_voltage,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
@@ -636,8 +654,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -660,8 +676,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -684,8 +698,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x0a,
@@ -708,8 +720,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
 		.update_bank		= 0x04,
@@ -734,8 +744,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
 		},
-		.min_uV			= 1050000,
-		.max_uV			= 2790000,
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux5 register */
 		.update_bank		= 0x01,
@@ -759,8 +767,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
 		},
-		.min_uV			= 1050000,
-		.max_uV			= 2790000,
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux6 register */
 		.update_bank		= 0x01,
@@ -784,8 +790,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -813,9 +817,9 @@ static struct ab8500_regulator_info
 			.id		= AB8505_LDO_ADC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
 		.delay			= 10000,
-		.fixed_uV		= 2000000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -832,8 +836,8 @@ static struct ab8500_regulator_info
 			.id             = AB9540_LDO_USB,
 			.owner          = THIS_MODULE,
 			.n_voltages     = 1,
+			.volt_table	= fixed_3300000_voltage,
 		},
-		.fixed_uV               = 3300000,
 		.update_bank            = 0x03,
 		.update_reg             = 0x82,
 		.update_mask            = 0x03,
@@ -849,8 +853,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
-		.fixed_uV		= 2000000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x02,
@@ -864,8 +868,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
@@ -879,8 +883,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x10,
@@ -894,8 +898,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1800000_voltage,
 		},
-		.fixed_uV		= 1800000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x04,
@@ -912,8 +916,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1200000_voltage,
 		},
-		.fixed_uV		= 1200000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x06,
@@ -942,8 +946,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -966,8 +968,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -990,8 +990,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x0a,
@@ -1014,8 +1012,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
 		.update_bank		= 0x04,
@@ -1040,8 +1036,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1069,9 +1063,9 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
 		.delay			= 10000,
-		.fixed_uV		= 2000000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1088,8 +1082,8 @@ static struct ab8500_regulator_info
 			.id             = AB9540_LDO_USB,
 			.owner          = THIS_MODULE,
 			.n_voltages     = 1,
+			.volt_table	= fixed_3300000_voltage,
 		},
-		.fixed_uV               = 3300000,
 		.update_bank            = 0x03,
 		.update_reg             = 0x82,
 		.update_mask            = 0x03,
@@ -1105,8 +1099,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
-		.fixed_uV		= 2000000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x02,
@@ -1120,8 +1114,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
@@ -1135,8 +1129,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x10,
@@ -1150,8 +1144,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1800000_voltage,
 		},
-		.fixed_uV		= 1800000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x04,
@@ -1169,8 +1163,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1200000_voltage,
 		},
-		.fixed_uV		= 1200000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x06,
@@ -1198,6 +1192,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table     = ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1429,8 +1424,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages = ARRAY_SIZE(ldo_sdio_voltages),
 		},
-		.min_uV			= 1050000,
-		.max_uV			= 3050000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x88,
-- 
1.7.9.5

