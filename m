Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3C1QNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:13:01 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54478 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab3C1QNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:13:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 33/33] ARM: ux500: Regulators: Bring the AB8500 regulator platform data up-to-date
Date: Thu, 28 Mar 2013 16:11:33 +0000
Message-Id: <1364487093-19551-34-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite a few changes in this patch, including: supply-name changes, new
consumers, initialisation and capability updates and new regulators.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   75 ++++++++++++++++---------
 1 file changed, 47 insertions(+), 28 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 30e61e0..3249bb9 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -66,7 +66,7 @@ static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
 	/* BH1780GLS ambient light sensor */
 	REGULATOR_SUPPLY("vcc", "2-0029"),
 	/* lsm303dlh accelerometer */
-	REGULATOR_SUPPLY("vdd", "3-0018"),
+	REGULATOR_SUPPLY("vdd", "2-0018"),
 	/* lsm303dlhc accelerometer */
 	REGULATOR_SUPPLY("vdd", "2-0019"),
 	/* lsm303dlh magnetometer */
@@ -93,9 +93,16 @@ static struct regulator_consumer_supply ab8500_vaux2_consumers[] = {
 	REGULATOR_SUPPLY("vmmc", "sdi4"),
 	/* AB8500 audio codec */
 	REGULATOR_SUPPLY("vcc-N2158", "ab8500-codec.0"),
+	/* AB8500 accessory detect 1 */
+	REGULATOR_SUPPLY("vcc-N2158", "ab8500-acc-det.0"),
+	/* AB8500 Tv-out device */
+	REGULATOR_SUPPLY("vcc-N2158", "mcde_tv_ab8500.4"),
+	/* AV8100 HDMI device */
+	REGULATOR_SUPPLY("vcc-N2158", "av8100_hdmi.3"),
 };
 
 static struct regulator_consumer_supply ab8500_vaux3_consumers[] = {
+	REGULATOR_SUPPLY("v-SD-STM", "stm"),
 	/* External MMC slot power */
 	REGULATOR_SUPPLY("vmmc", "sdi0"),
 };
@@ -126,6 +133,10 @@ static struct regulator_consumer_supply ab8500_vtvout_consumers[] = {
 	REGULATOR_SUPPLY("vtvout", "ab8500-denc.0"),
 	/* Internal general-purpose ADC */
 	REGULATOR_SUPPLY("vddadc", "ab8500-gpadc.0"),
+	/* ADC for charger */
+	REGULATOR_SUPPLY("vddadc", "ab8500-charger.0"),
+	/* AB8500 Tv-out device */
+	REGULATOR_SUPPLY("vtvout", "mcde_tv_ab8500.4"),
 };
 
 static struct regulator_consumer_supply ab8500_vaud_consumers[] = {
@@ -153,6 +164,8 @@ static struct regulator_consumer_supply ab8500_vintcore_consumers[] = {
 	REGULATOR_SUPPLY("v-intcore", NULL),
 	/* USB Transceiver */
 	REGULATOR_SUPPLY("vddulpivio18", "ab8500-usb.0"),
+	/* Handled by abx500 clk driver */
+	REGULATOR_SUPPLY("v-intcore", "abx500-clk.0"),
 };
 
 static struct regulator_consumer_supply ab8505_usb_consumers[] = {
@@ -161,8 +174,15 @@ static struct regulator_consumer_supply ab8505_usb_consumers[] = {
 };
 
 static struct regulator_consumer_supply ab8500_vana_consumers[] = {
-	/* External displays, connector on board, 1v8 power supply */
-	REGULATOR_SUPPLY("vsmps2", "mcde.0"),
+	/* DB8500 DSI */
+	REGULATOR_SUPPLY("vdddsi1v2", "mcde"),
+	REGULATOR_SUPPLY("vdddsi1v2", "b2r2_core"),
+	REGULATOR_SUPPLY("vdddsi1v2", "b2r2_1_core"),
+	REGULATOR_SUPPLY("vdddsi1v2", "dsilink.0"),
+	REGULATOR_SUPPLY("vdddsi1v2", "dsilink.1"),
+	REGULATOR_SUPPLY("vdddsi1v2", "dsilink.2"),
+	/* DB8500 CSI */
+	REGULATOR_SUPPLY("vddcsi1v2", "mmio_camera"),
 };
 
 /* ab8500 regulator register initialization */
@@ -304,9 +324,9 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3REGU,          0x03, 0x00),
 	/*
-	 * Vaux1Sel                 = 2.5 V
+	 * Vaux1Sel                 = 2.8 V
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VAUX1SEL,               0x0f, 0x08),
+	INIT_REGULATOR_REGISTER(AB8500_VAUX1SEL,               0x0f, 0x0C),
 	/*
 	 * Vaux2Sel                 = 2.9 V
 	 */
@@ -342,18 +362,11 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	[AB8500_LDO_AUX1] = {
 		.constraints = {
 			.name = "V-DISPLAY",
-			.min_uV = 2500000,
-			.max_uV = 2900000,
+			.min_uV = 2800000,
+			.max_uV = 3300000,
 			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
 					  REGULATOR_CHANGE_STATUS,
 			.boot_on = 1, /* display is on at boot */
-			/*
-			 * This voltage cannot be disabled right now because
-			 * it is somehow affecting the external MMC
-			 * functionality, though that typically will use
-			 * AUX3.
-			 */
-			.always_on = 1,
 		},
 		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux1_consumers),
 		.consumer_supplies = ab8500_vaux1_consumers,
@@ -365,7 +378,10 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 			.min_uV = 1100000,
 			.max_uV = 3300000,
 			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS,
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
 		},
 		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux2_consumers),
 		.consumer_supplies = ab8500_vaux2_consumers,
@@ -377,7 +393,10 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 			.min_uV = 1100000,
 			.max_uV = 3300000,
 			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS,
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
 		},
 		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux3_consumers),
 		.consumer_supplies = ab8500_vaux3_consumers,
@@ -431,15 +450,23 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	[AB8500_LDO_INTCORE] = {
 		.constraints = {
 			.name = "V-INTCORE",
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+			.min_uV = 1250000,
+			.max_uV = 1350000,
+			.input_uV = 1800000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE |
+					  REGULATOR_CHANGE_DRMS,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
 		},
 		.num_consumer_supplies = ARRAY_SIZE(ab8500_vintcore_consumers),
 		.consumer_supplies = ab8500_vintcore_consumers,
 	},
-	/* supply for U8500 CSI/DSI, VANA LDO */
+	/* supply for U8500 CSI-DSI, VANA LDO */
 	[AB8500_LDO_ANA] = {
 		.constraints = {
-			.name = "V-CSI/DSI",
+			.name = "V-CSI-DSI",
 			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 		},
 		.num_consumer_supplies = ARRAY_SIZE(ab8500_vana_consumers),
@@ -999,16 +1026,8 @@ void mop500_regulator_init(void)
 	struct regulator_init_data *regulator;
 
 	/*
-	 * Handle VextSupply1 on older boards than HREFP_V22_V1x
-	 * (turn off in suspend)
+	 * Temporarily turn on Vaux2 on 8520 machine
 	 */
-	if (cpu_is_u8500v20() || cpu_is_u8500v21()) {
-		/* disable VextSupply1 in suspend */
-		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY1];
-		regulator->constraints.state_mem.disabled = 1;
-		regulator->constraints.state_standby.disabled = 1;
-	}
-
 	if (cpu_is_u8520()) {
 		/* Vaux2 initialized to be on */
 		ab8500_modify_reg_init(AB8505_VAUX12REGU, 0x0f, 0x05);
-- 
1.7.10.4

