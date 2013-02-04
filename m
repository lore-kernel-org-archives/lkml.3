Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab3BDL5C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:57:02 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:52791 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3BDL47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:59 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH 37/73] regulator: ab8500: add support for ab8505
Date: Mon,  4 Feb 2013 11:53:52 +0000
Message-Id: <1359978868-28736-38-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for ab8505 regulators. It uses the
ab9540 regulators and the ab8500 init regulator settings.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |  148 +++++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500-regulators.h |    1 +
 drivers/regulator/ab8500.c                    |    7 +-
 3 files changed, 155 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 16745e2..6b9c810 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -99,6 +99,9 @@ static struct regulator_consumer_supply ab8500_vaux3_consumers[] = {
 	REGULATOR_SUPPLY("vmmc", "sdi0"),
 };
 
+static struct regulator_consumer_supply ab8505_vaux4_consumers[] = {
+};
+
 static struct regulator_consumer_supply ab8500_vtvout_consumers[] = {
 	/* TV-out DENC supply */
 	REGULATOR_SUPPLY("vtvout", "ab8500-denc.0"),
@@ -472,6 +475,141 @@ static struct regulator_init_data ab8500_ext_regulators[] = {
 	},
 };
 
+struct regulator_init_data ab8505_regulators[AB9540_NUM_REGULATORS] = {
+	/* supplies to the display/camera */
+	[AB9540_LDO_AUX1] = {
+		.supply_regulator = "ab8500-ext-supply3",
+		.constraints = {
+			.name = "V-DISPLAY",
+			.min_uV = 2800000,
+			.max_uV = 3300000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS,
+			.boot_on = 1, /* display is on at boot */
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux1_consumers),
+		.consumer_supplies = ab8500_vaux1_consumers,
+	},
+	/* supplies to the on-board eMMC */
+	[AB9540_LDO_AUX2] = {
+		.supply_regulator = "ab8500-ext-supply3",
+		.constraints = {
+			.name = "V-eMMC1",
+			.min_uV = 1100000,
+			.max_uV = 3300000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux2_consumers),
+		.consumer_supplies = ab8500_vaux2_consumers,
+	},
+	/* supply for VAUX3, supplies to SDcard slots */
+	[AB9540_LDO_AUX3] = {
+		.supply_regulator = "ab8500-ext-supply3",
+		.constraints = {
+			.name = "V-MMC-SD",
+			.min_uV = 1100000,
+			.max_uV = 3300000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux3_consumers),
+		.consumer_supplies = ab8500_vaux3_consumers,
+	},
+	/* supply for VAUX4, supplies to NFC and standalone secure element */
+	[AB9540_LDO_AUX4] = {
+		.constraints = {
+			.name = "V-NFC-SE",
+			.min_uV = 1100000,
+			.max_uV = 3300000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8505_vaux4_consumers),
+		.consumer_supplies = ab8505_vaux4_consumers,
+	},
+	/* supply for tvout, gpadc, TVOUT LDO */
+	[AB9540_LDO_TVOUT] = {
+		.constraints = {
+			.name = "V-TVOUT",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vtvout_consumers),
+		.consumer_supplies = ab8500_vtvout_consumers,
+	},
+	/* supply for ab8500-vaudio, VAUDIO LDO */
+	[AB9540_LDO_AUDIO] = {
+		.constraints = {
+			.name = "V-AUD",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaud_consumers),
+		.consumer_supplies = ab8500_vaud_consumers,
+	},
+	/* supply for v-anamic1 VAMic1-LDO */
+	[AB9540_LDO_ANAMIC1] = {
+		.constraints = {
+			.name = "V-AMIC1",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic1_consumers),
+		.consumer_supplies = ab8500_vamic1_consumers,
+	},
+	/* supply for v-amic2, VAMIC2 LDO, reuse constants for AMIC1 */
+	[AB9540_LDO_ANAMIC2] = {
+		.constraints = {
+			.name = "V-AMIC2",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic2_consumers),
+		.consumer_supplies = ab8500_vamic2_consumers,
+	},
+	/* supply for v-dmic, VDMIC LDO */
+	[AB9540_LDO_DMIC] = {
+		.constraints = {
+			.name = "V-DMIC",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vdmic_consumers),
+		.consumer_supplies = ab8500_vdmic_consumers,
+	},
+	/* supply for v-intcore12, VINTCORE12 LDO */
+	[AB9540_LDO_INTCORE] = {
+		.constraints = {
+			.name = "V-INTCORE",
+			.min_uV = 1250000,
+			.max_uV = 1350000,
+			.input_uV = 1800000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE |
+					  REGULATOR_CHANGE_DRMS,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vintcore_consumers),
+		.consumer_supplies = ab8500_vintcore_consumers,
+	},
+	/* supply for U8500 CSI-DSI, VANA LDO */
+	[AB9540_LDO_ANA] = {
+		.constraints = {
+			.name = "V-CSI-DSI",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vana_consumers),
+		.consumer_supplies = ab8500_vana_consumers,
+	},
+};
+
 struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.reg_init               = ab8500_reg_init,
 	.num_reg_init           = ARRAY_SIZE(ab8500_reg_init),
@@ -481,6 +619,16 @@ struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
 };
 
+/* Use the AB8500 init settings for AB8505 as they are the same right now */
+struct ab8500_regulator_platform_data ab8505_regulator_plat_data = {
+	.reg_init               = ab8500_reg_init,
+	.num_reg_init           = ARRAY_SIZE(ab8500_reg_init),
+	.regulator              = ab8505_regulators,
+	.num_regulator          = ARRAY_SIZE(ab8505_regulators),
+	.ext_regulator          = ab8500_ext_regulators,
+	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
+};
+
 static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
 {
 	int i;
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 3d4c412..9bece38 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -15,6 +15,7 @@
 #include <linux/regulator/ab8500.h>
 
 extern struct ab8500_regulator_platform_data ab8500_regulator_plat_data;
+extern struct ab8500_regulator_platform_data ab8505_regulator_plat_data;
 extern struct regulator_init_data tps61052_regulator;
 extern struct regulator_init_data gpio_en_3v3_regulator;
 
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 861a669..a3d8e76 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1441,6 +1441,11 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		reg_init_size = AB9540_NUM_REGULATOR_REGISTERS;
 		match = ab9540_regulator_matches;
 		match_size = ARRAY_SIZE(ab9540_regulator_matches)
+	} else if (is_ab8505(ab8500)) {
+		regulator_info = ab9540_regulator_info;
+		regulator_info_size = ARRAY_SIZE(ab9540_regulator_info);
+		reg_init = ab8500_reg_init;
+		reg_init_size = AB8500_NUM_REGULATOR_REGISTERS;
 	} else {
 		regulator_info = ab8500_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
@@ -1531,7 +1536,7 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
 	int regulator_info_size;
 
 
-	if (is_ab9540(ab8500)) {
+	if (is_ab9540(ab8500) || is_ab8505(ab8500)) {
 		regulator_info = ab9540_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab9540_regulator_info);
 	} else {
-- 
1.7.9.5

