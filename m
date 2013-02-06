Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3BFK4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:56:36 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50012 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab3BFKzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:24 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Zhenhua HUANG <zhenhua.huang@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 45/49] regulator: ab8500: Introduce aux5, aux6 regulators for AB8540
Date: Wed,  6 Feb 2013 10:54:07 +0000
Message-Id: <1360148051-7560-46-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhenhua HUANG <zhenhua.huang@stericsson.com>

Introduce aux5, aux6 into ab8540 regulator framework.

Signed-off-by: Zhenhua HUANG <zhenhua.huang@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Maxime COQUELIN <maxime.coquelin@stericsson.com>
Reviewed-by: David PARIS <david.paris@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/regulator/ab8500.c       |   65 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/ab8500.h |    2 ++
 2 files changed, 67 insertions(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index b69b4f5..5ddeff4 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -151,6 +151,21 @@ static const unsigned int ldo_vaux3_ab8540_voltages[] = {
 	3050000,
 };
 
+static const int ldo_vaux56_ab8540_voltages[] = {
+	750000, 760000, 770000, 780000, 790000, 800000,
+	810000, 820000, 830000, 840000, 850000, 860000,
+	870000, 880000, 890000, 900000, 910000, 920000,
+	930000, 940000, 950000, 960000, 970000, 980000,
+	990000, 1000000, 1010000, 1020000, 1030000,
+	1040000, 1050000, 1060000, 1070000, 1080000,
+	1090000, 1100000, 1110000, 1120000, 1130000,
+	1140000, 1150000, 1160000, 1170000, 1180000,
+	1190000, 1200000, 1210000, 1220000, 1230000,
+	1240000, 1250000, 1260000, 1270000, 1280000,
+	1290000, 1300000, 1310000, 1320000, 1330000,
+	1340000, 1350000, 1360000, 1800000, 2790000,
+};
+
 static const unsigned int ldo_vintcore_voltages[] = {
 	1200000,
 	1225000,
@@ -1560,6 +1575,54 @@ static struct ab8500_regulator_info
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
 	},
+	[AB8540_LDO_AUX5] = {
+		.desc = {
+			.name		= "LDO-AUX5",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8540_LDO_AUX5,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
+		},
+		.load_lp_uA		= 20000,
+		/* values for Vaux5Regu register */
+		.update_bank		= 0x04,
+		.update_reg		= 0x32,
+		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
+		/* values for Vaux5SEL register */
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x33,
+		.voltage_mask		= 0x3f,
+		.voltages		= ldo_vaux56_ab8540_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
+	},
+	[AB8540_LDO_AUX6] = {
+		.desc = {
+			.name		= "LDO-AUX6",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8540_LDO_AUX6,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
+		},
+		.load_lp_uA		= 20000,
+		/* values for Vaux6Regu register */
+		.update_bank		= 0x04,
+		.update_reg		= 0x35,
+		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
+		/* values for Vaux6SEL register */
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x36,
+		.voltage_mask		= 0x3f,
+		.voltages		= ldo_vaux56_ab8540_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
+	},
 	[AB8540_LDO_INTCORE] = {
 		.desc = {
 			.name		= "LDO-INTCORE",
@@ -2965,6 +3028,8 @@ static struct of_regulator_match ab8540_regulator_match[] = {
 	{ .name	= "ab8500_ldo_aux2",    .driver_data = (void *) AB8540_LDO_AUX2, },
 	{ .name	= "ab8500_ldo_aux3",    .driver_data = (void *) AB8540_LDO_AUX3, },
 	{ .name	= "ab8500_ldo_aux4",    .driver_data = (void *) AB8540_LDO_AUX4, },
+	{ .name	= "ab8500_ldo_aux5",    .driver_data = (void *) AB8540_LDO_AUX5, },
+	{ .name	= "ab8500_ldo_aux6",    .driver_data = (void *) AB8540_LDO_AUX6, },
 	{ .name	= "ab8500_ldo_intcore", .driver_data = (void *) AB8540_LDO_INTCORE, },
 	{ .name	= "ab8500_ldo_tvout",   .driver_data = (void *) AB8540_LDO_TVOUT, },
 	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB8540_LDO_AUDIO, },
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index bb0140c..b490a16 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -74,6 +74,8 @@ enum ab8540_regulator_id {
 	AB8540_LDO_AUX2,
 	AB8540_LDO_AUX3,
 	AB8540_LDO_AUX4,
+	AB8540_LDO_AUX5,
+	AB8540_LDO_AUX6,
 	AB8540_LDO_INTCORE,
 	AB8540_LDO_TVOUT,
 	AB8540_LDO_AUDIO,
-- 
1.7.9.5

