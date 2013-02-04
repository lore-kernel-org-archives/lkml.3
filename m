Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3BDMRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:17:41 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47008 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3BDLzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:55:55 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/73] regulator: ab8500: Add init values for vsmps1/2
Date: Mon,  4 Feb 2013 11:53:18 +0000
Message-Id: <1359978868-28736-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Persson <martin.persson@stericsson.com>

Signed-off-by: Martin Persson <martin.persson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Emeric VIGIER <emeric.vigier@stericsson.com>
Reviewed-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   14 +++++++++++++-
 drivers/regulator/ab8500.c                    |   14 +++++++++++++-
 include/linux/regulator/ab8500.h              |    2 ++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index ba379f7..42eef80 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -146,8 +146,10 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 * Vaux1SysClkReq1HPValid   = disabled
 	 * Vaux2SysClkReq1HPValid   = disabled
 	 * Vaux3SysClkReq1HPValid   = disabled
+	 * Vsmps2SysClkReq1HPValid  = enabled
+	 * Vsmps1SysClkReq1HPValid  = enabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0x03),
 	/*
 	 * VextSupply1SysClkReq1HPValid = disabled
 	 * VextSupply2SysClkReq1HPValid = disabled
@@ -252,6 +254,16 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VBBSEL2,                0x00),
 	/*
+	 * Vsmps1SelCtrl            = Vsmps1 voltage defined by Vsmsp1Sel2
+	 * Vsmps1Regu               = HW control
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VSMPS1REGU,             0x06),
+	/*
+	 * Vsmps2SelCtrl            = Vsmps2 voltage defined by Vsmsp2Sel2
+	 * Vsmps2Regu               = HW control
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VSMPS2REGU,             0x06),
+	/*
 	 * VPll                     = Hw controlled
 	 * VanaRegu                 = force off
 	 */
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index b369411..84cd11c 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -494,12 +494,14 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_REGUREQUESTCTRL4,	0x03, 0x06, 0x07),
 	/*
+	 * 0x01, Vsmps1SysClkReq1HPValid
+	 * 0x02, Vsmps2SysClkReq1HPValid
 	 * 0x08, VanaSysClkReq1HPValid
 	 * 0x20, Vaux1SysClkReq1HPValid
 	 * 0x40, Vaux2SysClkReq1HPValid
 	 * 0x80, Vaux3SysClkReq1HPValid
 	 */
-	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xe8),
+	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xeb),
 	/*
 	 * 0x10, VextSupply1SysClkReq1HPValid
 	 * 0x20, VextSupply2SysClkReq1HPValid
@@ -596,6 +598,16 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_VBBSEL2,		0x04, 0x12, 0x0f),
 	/*
+	 * 0x0c, Vsmps1SelCtrl
+	 * 0x03, Vsmps1Regu
+	 */
+	REG_INIT(AB8500_VSMPS1REGU,		0x04, 0x03, 0x0f),
+	/*
+	 * 0x0c, Vsmps2SelCtrl
+	 * 0x03, Vsmps2Regu
+	 */
+	REG_INIT(AB8500_VSMPS2REGU,		0x04, 0x04, 0x0f),
+	/*
 	 * 0x0c, VanaRegu
 	 * 0x03, VpllRegu
 	 */
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index d61adb9..e54c8af 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -89,6 +89,8 @@ enum ab8500_regulator_reg {
 	AB8500_ARMREGU2, /* NOTE! PRCMU register */
 	AB8500_VBBSEL1, /* NOTE! PRCMU register */
 	AB8500_VBBSEL2, /* NOTE! PRCMU register */
+	AB8500_VSMPS1REGU,
+	AB8500_VSMPS2REGU,
 	AB8500_VSMPS1SEL1,
 	AB8500_NUM_REGULATOR_REGISTERS,
 };
-- 
1.7.9.5

