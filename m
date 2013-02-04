Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3BDL5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:57:30 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:46217 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3BDL52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:28 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 51/73] regulator: ab8500: Regulator vaux8 not declared using correct name
Date: Mon,  4 Feb 2013 11:54:06 +0000
Message-Id: <1359978868-28736-52-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

vaux8 regulator isn't declared correctly for the AB8505.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   21 +++++++++++++--------
 drivers/regulator/ab8500.c                    |    6 +++---
 include/linux/regulator/ab8500.h              |    2 +-
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 1b51f6d..b0f5e8f 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -109,6 +109,11 @@ static struct regulator_consumer_supply ab8505_vaux5_consumers[] = {
 static struct regulator_consumer_supply ab8505_vaux6_consumers[] = {
 };
 
+static struct regulator_consumer_supply ab8505_vaux8_consumers[] = {
+	/* AB8500 audio codec device */
+	REGULATOR_SUPPLY("v-aux8", NULL),
+};
+
 static struct regulator_consumer_supply ab8505_vadc_consumers[] = {
 	/* Internal general-purpose ADC */
 	REGULATOR_SUPPLY("vddadc", "ab8500-gpadc.0"),
@@ -609,7 +614,7 @@ static struct ab8500_regulator_reg_init ab8505_reg_init[] = {
 	INIT_REGULATOR_REGISTER(AB8505_REGUMISC1,              0xfe, 0x10),
 	/*
 	 * VaudioEna                = disabled
-	 * VdmicEna                 = disabled
+	 * Vaux8Ena                 = disabled
 	 * Vamic1Ena                = disabled
 	 * Vamic2Ena                = disabled
 	 */
@@ -725,8 +730,8 @@ static struct ab8500_regulator_reg_init ab8505_reg_init[] = {
 	INIT_REGULATOR_REGISTER(AB8505_REGUCTRLDISCH,          0xfc, 0x00),
 	/*
 	 * VanaDisch                = short discharge time
-	 * VdmicPullDownEna         = pulldown disabled when Vdmic is disabled
-	 * VdmicDisch               = short discharge time
+	 * Vaux8PullDownEna         = pulldown disabled when Vaux8 is disabled
+	 * Vaux8Disch               = short discharge time
 	 */
 	INIT_REGULATOR_REGISTER(AB8505_REGUCTRLDISCH2,         0x16, 0x00),
 	/*
@@ -879,14 +884,14 @@ struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] = {
 		.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic2_consumers),
 		.consumer_supplies = ab8500_vamic2_consumers,
 	},
-	/* supply for v-dmic, VDMIC LDO */
-	[AB8505_LDO_DMIC] = {
+	/* supply for v-aux8, VAUX8 LDO */
+	[AB8505_LDO_AUX8] = {
 		.constraints = {
-			.name = "V-DMIC",
+			.name = "V-AUX8",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8500_vdmic_consumers),
-		.consumer_supplies = ab8500_vdmic_consumers,
+		.num_consumer_supplies = ARRAY_SIZE(ab8505_vaux8_consumers),
+		.consumer_supplies = ab8505_vaux8_consumers,
 	},
 	/* supply for v-intcore12, VINTCORE12 LDO */
 	[AB8505_LDO_INTCORE] = {
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 7089a38..12ec061 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -883,12 +883,12 @@ static struct ab8500_regulator_info
 		.update_mask		= 0x10,
 		.update_val		= 0x10,
 	},
-	[AB8505_LDO_DMIC] = {
+	[AB8505_LDO_AUX8] = {
 		.desc = {
-			.name		= "LDO-DMIC",
+			.name		= "LDO-AUX8",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8505_LDO_DMIC,
+			.id		= AB8505_LDO_AUX8,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_1800000_voltage,
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index caa9f6a..1d33586 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -42,7 +42,7 @@ enum ab8505_regulator_id {
 	AB8505_LDO_AUDIO,
 	AB8505_LDO_ANAMIC1,
 	AB8505_LDO_ANAMIC2,
-	AB8505_LDO_DMIC,
+	AB8505_LDO_AUX8,
 	AB8505_LDO_ANA,
 	AB8505_SYSCLKREQ_2,
 	AB8505_SYSCLKREQ_4,
-- 
1.7.9.5

