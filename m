Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbbAUXGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:06:53 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:52155 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbbAUXGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:06:35 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: ux500: Remove unused functions and structs
Date: Thu, 22 Jan 2015 00:09:42 +0100
Message-Id: <1421881782-23716-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421881782-23716-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1421881782-23716-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove same unused functions and structs.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |  106 -------------------------
 arch/arm/mach-ux500/board-mop500-regulators.h |    5 --
 2 files changed, 111 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 32d744e..2b8f685 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -19,17 +19,6 @@ static struct regulator_consumer_supply gpio_en_3v3_consumers[] = {
        REGULATOR_SUPPLY("vdd33a", "smsc911x.0"),
 };
 
-struct regulator_init_data gpio_en_3v3_regulator = {
-       .constraints = {
-               .name = "EN-3V3",
-               .min_uV = 3300000,
-               .max_uV = 3300000,
-               .valid_ops_mask = REGULATOR_CHANGE_STATUS,
-       },
-       .num_consumer_supplies = ARRAY_SIZE(gpio_en_3v3_consumers),
-       .consumer_supplies = gpio_en_3v3_consumers,
-};
-
 /*
  * TPS61052 regulator
  */
@@ -43,17 +32,6 @@ static struct regulator_consumer_supply tps61052_vaudio_consumers[] = {
 	REGULATOR_SUPPLY("vintdclassint", "ab8500-codec.0"),
 };
 
-struct regulator_init_data tps61052_regulator = {
-	.constraints = {
-		.name = "vaudio-hf",
-		.min_uV = 4500000,
-		.max_uV = 4500000,
-		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies = ARRAY_SIZE(tps61052_vaudio_consumers),
-	.consumer_supplies = tps61052_vaudio_consumers,
-};
-
 static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
 	/* Main display, u8500 R3 uib */
 	REGULATOR_SUPPLY("vddi", "mcde_disp_sony_acx424akp.0"),
@@ -483,11 +461,6 @@ static struct regulator_consumer_supply ab8500_ext_supply3_consumers[] = {
 	REGULATOR_SUPPLY("vinvsim", "sim-detect.0"),
 };
 
-/* extended configuration for VextSupply2, only used for HREFP_V20 boards */
-static struct ab8500_ext_regulator_cfg ab8500_ext_supply2 = {
-	.hwreq = true,
-};
-
 /*
  * AB8500 external regulators
  */
@@ -984,82 +957,3 @@ struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.ext_regulator          = ab8500_ext_regulators,
 	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
 };
-
-struct ab8500_regulator_platform_data ab8505_regulator_plat_data = {
-	.reg_init               = ab8505_reg_init,
-	.num_reg_init           = ARRAY_SIZE(ab8505_reg_init),
-	.regulator              = ab8505_regulators,
-	.num_regulator          = ARRAY_SIZE(ab8505_regulators),
-};
-
-static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
-{
-	int i;
-
-	if (cpu_is_u8520()) {
-		for (i = ARRAY_SIZE(ab8505_reg_init) - 1; i >= 0; i--) {
-			if (ab8505_reg_init[i].id == id) {
-				u8 initval = ab8505_reg_init[i].value;
-				initval = (initval & ~mask) | (value & mask);
-				ab8505_reg_init[i].value = initval;
-
-				BUG_ON(mask & ~ab8505_reg_init[i].mask);
-				return;
-			}
-		}
-	} else {
-		for (i = ARRAY_SIZE(ab8500_reg_init) - 1; i >= 0; i--) {
-			if (ab8500_reg_init[i].id == id) {
-				u8 initval = ab8500_reg_init[i].value;
-				initval = (initval & ~mask) | (value & mask);
-				ab8500_reg_init[i].value = initval;
-
-				BUG_ON(mask & ~ab8500_reg_init[i].mask);
-				return;
-			}
-		}
-	}
-
-	BUG_ON(1);
-}
-
-void mop500_regulator_init(void)
-{
-	struct regulator_init_data *regulator;
-
-	/*
-	 * Temporarily turn on Vaux2 on 8520 machine
-	 */
-	if (cpu_is_u8520()) {
-		/* Vaux2 initialized to be on */
-		ab8500_modify_reg_init(AB8505_VAUX12REGU, 0x0f, 0x05);
-	}
-
-	/*
-	 * Handle AB8500_EXT_SUPPLY2 on HREFP_V20_V50 boards (do it for
-	 * all HREFP_V20 boards)
-	 */
-	if (cpu_is_u8500v20()) {
-		/* VextSupply2RequestCtrl =  HP/OFF depending on VxRequest */
-		ab8500_modify_reg_init(AB8500_REGUREQUESTCTRL3, 0x01, 0x01);
-
-		/* VextSupply2SysClkReq1HPValid = SysClkReq1 controlled */
-		ab8500_modify_reg_init(AB8500_REGUSYSCLKREQ1HPVALID2,
-			0x20, 0x20);
-
-		/* VextSupply2 = force HP at initialization */
-		ab8500_modify_reg_init(AB8500_EXTSUPPLYREGU, 0x0c, 0x04);
-
-		/* enable VextSupply2 during platform active */
-		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
-		regulator->constraints.always_on = 1;
-
-		/* disable VextSupply2 in suspend */
-		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
-		regulator->constraints.state_mem.disabled = 1;
-		regulator->constraints.state_standby.disabled = 1;
-
-		/* enable VextSupply2 HW control (used in suspend) */
-		regulator->driver_data = (void *)&ab8500_ext_supply2;
-	}
-}
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 9bece38..88da2b8 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -15,10 +15,5 @@
 #include <linux/regulator/ab8500.h>
 
 extern struct ab8500_regulator_platform_data ab8500_regulator_plat_data;
-extern struct ab8500_regulator_platform_data ab8505_regulator_plat_data;
-extern struct regulator_init_data tps61052_regulator;
-extern struct regulator_init_data gpio_en_3v3_regulator;
-
-void mop500_regulator_init(void);
 
 #endif
-- 
1.7.10.4

