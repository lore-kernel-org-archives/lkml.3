Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3BDMEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:04:20 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:35023 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab3BDL5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:21 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 48/73] regulator: ab8500: Use regulator_list_voltage_table()
Date: Mon,  4 Feb 2013 11:54:03 +0000
Message-Id: <1359978868-28736-49-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following a recent move to regulator_list_voltage_table() for
all previous abx500 related platforms this converts all recent
platform updates over too.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   61 +++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 40 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 0dfb4e5..5218502 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -99,7 +99,7 @@ static const unsigned int ldo_vaux3_voltages[] = {
 	2910000,
 };
 
-static const int ldo_vaux56_voltages[] = {
+static const unsigned int ldo_vaux56_voltages[] = {
 	1800000,
 	1050000,
 	1100000,
@@ -110,7 +110,7 @@ static const int ldo_vaux56_voltages[] = {
 	2790000,
 };
 
-static const int ldo_vaux3_ab8540_voltages[] = {
+static const unsigned int ldo_vaux3_ab8540_voltages[] = {
 	1200000,
 	1500000,
 	1800000,
@@ -132,7 +132,7 @@ static const unsigned int ldo_vintcore_voltages[] = {
 	1350000,
 };
 
-static const int ldo_sdio_voltages[] = {
+static const unsigned int ldo_sdio_voltages[] = {
 	1160000,
 	1050000,
 	1100000,
@@ -653,6 +653,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -664,8 +665,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8505_LDO_AUX2] = {
 		.desc = {
@@ -675,6 +674,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -686,8 +686,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8505_LDO_AUX3] = {
 		.desc = {
@@ -697,6 +695,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+			.volt_table	= ldo_vaux3_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -708,8 +707,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_voltages),
 	},
 	[AB8505_LDO_AUX4] = {
 		.desc = {
@@ -719,6 +716,7 @@ static struct ab8500_regulator_info
 			.id		= AB9540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
@@ -732,8 +730,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8505_LDO_AUX5] = {
 		.desc = {
@@ -743,6 +739,7 @@ static struct ab8500_regulator_info
 			.id		= AB8505_LDO_AUX5,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
+			.volt_table	= ldo_vaux56_voltages,
 		},
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux5 register */
@@ -755,8 +752,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x55,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux56_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux56_voltages),
 	},
 	[AB8505_LDO_AUX6] = {
 		.desc = {
@@ -766,6 +761,7 @@ static struct ab8500_regulator_info
 			.id		= AB8505_LDO_AUX6,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
+			.volt_table	= ldo_vaux56_voltages,
 		},
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux6 register */
@@ -778,8 +774,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x56,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux56_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux56_voltages),
 	},
 	[AB8505_LDO_INTCORE] = {
 		.desc = {
@@ -789,6 +783,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -800,8 +795,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 	},
 
 	/*
@@ -945,6 +938,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -956,8 +950,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_AUX2] = {
 		.desc = {
@@ -967,6 +959,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -978,8 +971,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_AUX3] = {
 		.desc = {
@@ -989,6 +980,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+			.volt_table	= ldo_vaux3_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1000,8 +992,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_voltages),
 	},
 	[AB9540_LDO_AUX4] = {
 		.desc = {
@@ -1011,6 +1001,7 @@ static struct ab8500_regulator_info
 			.id		= AB9540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
@@ -1024,8 +1015,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_INTCORE] = {
 		.desc = {
@@ -1035,6 +1024,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1046,8 +1036,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 	},
 
 	/*
@@ -1204,8 +1192,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_AUX2] = {
 		.desc = {
@@ -1215,6 +1201,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1226,8 +1213,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_AUX3] = {
 		.desc = {
@@ -1237,6 +1222,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
+			.volt_table	= ldo_vaux3_ab8540_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1248,8 +1234,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_ab8540_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
 	},
 	[AB8540_LDO_AUX4] = {
 		.desc = {
@@ -1259,6 +1243,7 @@ static struct ab8500_regulator_info
 			.id		= AB9540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
@@ -1272,8 +1257,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_INTCORE] = {
 		.desc = {
@@ -1283,6 +1266,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1294,8 +1278,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 	},
 
 	/*
@@ -1422,7 +1404,8 @@ static struct ab8500_regulator_info
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8540_LDO_SDIO,
 			.owner		= THIS_MODULE,
-			.n_voltages = ARRAY_SIZE(ldo_sdio_voltages),
+			.n_voltages 	= ARRAY_SIZE(ldo_sdio_voltages),
+			.volt_table	= ldo_sdio_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1434,8 +1417,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x88,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_sdio_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_sdio_voltages),
 	},
 };
 
-- 
1.7.9.5

