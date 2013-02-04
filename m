Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab3BDL4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:56:45 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:46928 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab3BDL4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:43 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 30/73] regulator: ab8500: Remove Vsafe voltage settings
Date: Mon,  4 Feb 2013 11:53:45 +0000
Message-Id: <1359978868-28736-31-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

The Vsafe regulator should not be handled by the kernel, it
should be setup before the kernel starts. This patch removes
the voltage settings.

Current consumption will increase slightly (rough estimate 25
uA) when the platform is in the low power state because SoC
sets a voltage of 0.95 V where the kernel set a voltage of
0.925 V.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   10 ----------
 drivers/regulator/ab8500.c                    |   10 ----------
 include/linux/regulator/ab8500.h              |    2 --
 3 files changed, 22 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 8473ee1..f9f3fc3 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -265,22 +265,12 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VSMPS2REGU,             0x0f, 0x06),
 	/*
-	 * Vsmps3Sel2               = 1.2125 V
-	 * NOTE! PRCMU register
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VSMPS3SEL2,             0x7f, 0x29),
-	/*
 	 * Vsmps3Regu               = HW control
 	 * Vsmps3SelCtrl            = Vsmps3 voltage defined by Vsmps3Sel2
 	 * NOTE! PRCMU register
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VSMPS3REGU,             0x0f, 0x06),
 	/*
-	 * Vsmps3Sel1               = 0.9 V
-	 * NOTE! PRCMU register
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VSMPS3SEL1,             0x7f, 0x10),
-	/*
 	 * VPll                     = Hw controlled
 	 * VanaRegu                 = force off
 	 */
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 406c561..3f5db96 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -802,16 +802,6 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_VSMPS2SEL3,		0x04, 0x19, 0x3f),
 	/*
-	 * 0x7f, Vsmps3Sel1
-	 * NOTE! PRCMU register
-	 */
-	REG_INIT(AB8500_VSMPS3SEL1,             0x04, 0x1b, 0x7f),
-	/*
-	 * 0x7f, Vsmps3Sel2
-	 * NOTE! PRCMU register
-	 */
-	REG_INIT(AB8500_VSMPS3SEL2,             0x04, 0x1c, 0x7f),
-	/*
 	 * 0x0f, Vaux1Sel
 	 */
 	REG_INIT(AB8500_VAUX1SEL,		0x04, 0x1f, 0x0f),
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 094d24c..74955db 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -93,8 +93,6 @@ enum ab8500_regulator_reg {
 	AB8500_VSMPS2SEL1,
 	AB8500_VSMPS2SEL2,
 	AB8500_VSMPS2SEL3,
-	AB8500_VSMPS3SEL1, /* NOTE! PRCMU register */
-	AB8500_VSMPS3SEL2, /* NOTE! PRCMU register */
 	AB8500_VAUX1SEL,
 	AB8500_VAUX2SEL,
 	AB8500_VRF1VAUX3SEL,
-- 
1.7.9.5

