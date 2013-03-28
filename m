Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab3C1QMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:12:34 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64729 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab3C1QMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/33] regulator: ab8500: Use regulator_list_voltage_table()
Date: Thu, 28 Mar 2013 16:11:18 +0000
Message-Id: <1364487093-19551-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following a recent move to regulator_list_voltage_table() for
all previous abx500 related platforms this converts all recent
platform updates over too.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   62 ++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index e6f4666..9c3fc09 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -96,7 +96,7 @@ static const unsigned int ldo_vaux3_voltages[] = {
 	2910000,
 };
 
-static const int ldo_vaux56_voltages[] = {
+static const unsigned int ldo_vaux56_voltages[] = {
 	1800000,
 	1050000,
 	1100000,
@@ -107,7 +107,7 @@ static const int ldo_vaux56_voltages[] = {
 	2790000,
 };
 
-static const int ldo_vaux3_ab8540_voltages[] = {
+static const unsigned int ldo_vaux3_ab8540_voltages[] = {
 	1200000,
 	1500000,
 	1800000,
@@ -129,7 +129,7 @@ static const unsigned int ldo_vintcore_voltages[] = {
 	1350000,
 };
 
-static const int ldo_sdio_voltages[] = {
+static const unsigned int ldo_sdio_voltages[] = {
 	1160000,
 	1050000,
 	1100000,
@@ -651,6 +651,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -662,8 +663,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8505_LDO_AUX2] = {
 		.desc = {
@@ -673,6 +672,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -684,8 +684,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8505_LDO_AUX3] = {
 		.desc = {
@@ -695,6 +693,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+			.volt_table	= ldo_vaux3_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -706,8 +705,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_voltages),
 	},
 	[AB8505_LDO_AUX4] = {
 		.desc = {
@@ -717,6 +714,7 @@ static struct ab8500_regulator_info
 			.id		= AB9540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
@@ -730,8 +728,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8505_LDO_AUX5] = {
 		.desc = {
@@ -741,6 +737,7 @@ static struct ab8500_regulator_info
 			.id		= AB8505_LDO_AUX5,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
+			.volt_table	= ldo_vaux56_voltages,
 		},
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux5 register */
@@ -753,8 +750,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x55,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux56_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux56_voltages),
 	},
 	[AB8505_LDO_AUX6] = {
 		.desc = {
@@ -764,6 +759,7 @@ static struct ab8500_regulator_info
 			.id		= AB8505_LDO_AUX6,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
+			.volt_table	= ldo_vaux56_voltages,
 		},
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux6 register */
@@ -776,8 +772,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x56,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux56_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux56_voltages),
 	},
 	[AB8505_LDO_INTCORE] = {
 		.desc = {
@@ -787,6 +781,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -798,8 +793,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 		.voltage_shift		= 3,
 	},
 
@@ -944,6 +937,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -955,8 +949,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_AUX2] = {
 		.desc = {
@@ -966,6 +958,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -977,8 +970,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_AUX3] = {
 		.desc = {
@@ -988,6 +979,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+			.volt_table	= ldo_vaux3_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -999,8 +991,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_voltages),
 	},
 	[AB9540_LDO_AUX4] = {
 		.desc = {
@@ -1010,6 +1000,7 @@ static struct ab8500_regulator_info
 			.id		= AB9540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
@@ -1023,8 +1014,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_INTCORE] = {
 		.desc = {
@@ -1034,6 +1023,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1045,8 +1035,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 		.voltage_shift		= 3,
 	},
 
@@ -1192,6 +1180,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1203,8 +1192,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_AUX2] = {
 		.desc = {
@@ -1214,6 +1201,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1225,8 +1213,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_AUX3] = {
 		.desc = {
@@ -1236,6 +1222,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
+			.volt_table	= ldo_vaux3_ab8540_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1247,8 +1234,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_ab8540_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
 	},
 	[AB8540_LDO_AUX4] = {
 		.desc = {
@@ -1258,6 +1243,7 @@ static struct ab8500_regulator_info
 			.id		= AB9540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
@@ -1271,8 +1257,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_INTCORE] = {
 		.desc = {
@@ -1282,6 +1266,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1293,8 +1278,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 		.voltage_shift		= 3,
 	},
 
@@ -1409,7 +1392,8 @@ static struct ab8500_regulator_info
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8540_LDO_SDIO,
 			.owner		= THIS_MODULE,
-			.n_voltages = ARRAY_SIZE(ldo_sdio_voltages),
+			.n_voltages 	= ARRAY_SIZE(ldo_sdio_voltages),
+			.volt_table	= ldo_sdio_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1421,8 +1405,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x88,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_sdio_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_sdio_voltages),
 	},
 };
 
-- 
1.7.10.4

