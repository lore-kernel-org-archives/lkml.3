Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbbAAPhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:37:10 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46879 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbbAAPhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:37:05 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-ux500: board-mop500-regulators.c:  Remove unused function
Date: Thu,  1 Jan 2015 16:40:05 +0100
Message-Id: <1420126805-28098-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function mop500_regulator_init() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   41 -------------------------
 arch/arm/mach-ux500/board-mop500-regulators.h |    2 --
 2 files changed, 43 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 32d744e..156e83b 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -1022,44 +1022,3 @@ static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
 
 	BUG_ON(1);
 }
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
index 9bece38..dc3ee77 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -19,6 +19,4 @@ extern struct ab8500_regulator_platform_data ab8505_regulator_plat_data;
 extern struct regulator_init_data tps61052_regulator;
 extern struct regulator_init_data gpio_en_3v3_regulator;
 
-void mop500_regulator_init(void);
-
 #endif
-- 
1.7.10.4

