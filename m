Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3BFKyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:54:53 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:32951 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3BFKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/49] regulator: ab8500: Further populate initialisation registers
Date: Wed,  6 Feb 2013 10:53:23 +0000
Message-Id: <1360148051-7560-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supplies access to some extra settings provided by the
AB8500 regulator device. We also update some of the existing
initialisation values in accordance with internal ST-Ericsson code
submissions. This single patch was originally a collection of updates
which have been squashed together to aid with clarity.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   40 +++++++++++++++++++++++--
 drivers/regulator/ab8500.c                    |   39 ++++++++++++++++++++++--
 include/linux/regulator/ab8500.h              |    8 +++++
 3 files changed, 81 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 2a17bc5..4b3c519 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -126,6 +126,7 @@ struct ab8500_regulator_reg_init
 ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	/*
 	 * VanaRequestCtrl          = HP/LP depending on VxRequest
+	 * VpllRequestCtrl          = HP/LP depending on VxRequest
 	 * VextSupply1RequestCtrl   = HP/LP depending on VxRequest
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL2, 0x00),
@@ -142,12 +143,16 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL4, 0x00),
 	/*
+	 * Vsmps1SysClkReq1HPValid  = enabled
+	 * Vsmps2SysClkReq1HPValid  = enabled
+	 * Vsmps3SysClkReq1HPValid  = enabled
 	 * VanaSysClkReq1HPValid    = disabled
+	 * VpllSysClkReq1HPValid    = enabled
 	 * Vaux1SysClkReq1HPValid   = disabled
 	 * Vaux2SysClkReq1HPValid   = disabled
 	 * Vaux3SysClkReq1HPValid   = disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0x17),
 	/*
 	 * VextSupply1SysClkReq1HPValid = disabled
 	 * VextSupply2SysClkReq1HPValid = disabled
@@ -234,6 +239,34 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL1VAMIC, 0x00),
 	/*
+	 * VBBN                     = force OFF
+	 * VBBP                     = force OFF
+	 * NOTE! PRCMU register
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_ARMREGU2,               0x00),
+	/*
+	 * VBBNSel1                 = VBBP = VBBPFB
+	 * VBBPSel1                 = 0 V
+	 * NOTE! PRCMU register
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VBBSEL1,                0x00),
+	/*
+	 * VBBNSel2                 = VBBP = VBBPFB
+	 * VBBPSel2                 = 0 V
+	 * NOTE! PRCMU register
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VBBSEL2,                0x00),
+	/*
+	 * Vsmps1Regu               = HW control
+	 * Vsmps1SelCtrl            = Vsmps1 voltage defined by Vsmsp1Sel2
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VSMPS1REGU,             0x06),
+	/*
+	 * Vsmps2Regu               = HW control
+	 * Vsmps2SelCtrl            = Vsmps2 voltage defined by Vsmsp2Sel2
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VSMPS2REGU,             0x06),
+	/*
 	 * VPll                     = Hw controlled
 	 * VanaRegu                 = force off
 	 */
@@ -257,9 +290,10 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VAUX12REGU, 0x01),
 	/*
-	 * Vaux3regu                = force off
+	 * Vrf1Regu                 = HW control
+	 * Vaux3Regu                = force off
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3REGU, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3REGU, 0x08),
 	/*
 	 * Vsmps1                   = 1.15V
 	 */
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 09014f3..4d9d556 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -477,7 +477,7 @@ struct ab8500_reg_init {
 static struct ab8500_reg_init ab8500_reg_init[] = {
 	/*
 	 * 0x30, VanaRequestCtrl
-	 * 0x0C, VpllRequestCtrl
+	 * 0x0c, VpllRequestCtrl
 	 * 0xc0, VextSupply1RequestCtrl
 	 */
 	REG_INIT(AB8500_REGUREQUESTCTRL2,	0x03, 0x04, 0xfc),
@@ -494,12 +494,16 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_REGUREQUESTCTRL4,	0x03, 0x06, 0x07),
 	/*
+	 * 0x01, Vsmps1SysClkReq1HPValid
+	 * 0x02, Vsmps2SysClkReq1HPValid
+	 * 0x04, Vsmps3SysClkReq1HPValid
 	 * 0x08, VanaSysClkReq1HPValid
+	 * 0x10, VpllSysClkReq1HPValid
 	 * 0x20, Vaux1SysClkReq1HPValid
 	 * 0x40, Vaux2SysClkReq1HPValid
 	 * 0x80, Vaux3SysClkReq1HPValid
 	 */
-	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xe8),
+	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xff),
 	/*
 	 * 0x10, VextSupply1SysClkReq1HPValid
 	 * 0x20, VextSupply2SysClkReq1HPValid
@@ -578,6 +582,34 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_REGUCTRL1VAMIC,		0x03, 0x84, 0x03),
 	/*
+	 * 0x0c, VBBNRegu
+	 * 0x03, VBBPRegu
+	 * NOTE! PRCMU register
+	 */
+	REG_INIT(AB8500_ARMREGU2,		0x04, 0x01, 0x0f),
+	/*
+	 * 0x0c, VBBPSel1
+	 * 0x03, VBBNSel1
+	 * NOTE! PRCMU register
+	 */
+	REG_INIT(AB8500_VBBSEL1,		0x04, 0x11, 0x0f),
+	/*
+	 * 0x0c, VBBNSel2
+	 * 0x03, VBBPSel2
+	 * NOTE! PRCMU register
+	 */
+	REG_INIT(AB8500_VBBSEL2,		0x04, 0x12, 0x0f),
+	/*
+	 * 0x03, Vsmps1Regu
+	 * 0x0c, Vsmps1SelCtrl
+	 */
+	REG_INIT(AB8500_VSMPS1REGU,		0x04, 0x03, 0x0f),
+	/*
+	 * 0x03, Vsmps2Regu
+	 * 0x0c, Vsmps2SelCtrl
+	 */
+	REG_INIT(AB8500_VSMPS2REGU,		0x04, 0x04, 0x0f),
+	/*
 	 * 0x0c, VanaRegu
 	 * 0x03, VpllRegu
 	 */
@@ -601,9 +633,10 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_VAUX12REGU,		0x04, 0x09, 0x0f),
 	/*
+	 * 0x0c, Vrf1Regu
 	 * 0x03, Vaux3Regu
 	 */
-	REG_INIT(AB8500_VRF1VAUX3REGU,		0x04, 0x0a, 0x03),
+	REG_INIT(AB8500_VRF1VAUX3REGU,		0x04, 0x0a, 0x0f),
 	/*
 	 * 0x3f, Vsmps1Sel1
 	 */
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 7bd73bb..2c6c962 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -86,7 +86,15 @@ enum ab8500_regulator_reg {
 	AB8500_REGUCTRL2SPARE,
 	AB8500_REGUCTRLDISCH,
 	AB8500_REGUCTRLDISCH2,
+	AB8500_ARMREGU2, /* NOTE! PRCMU register */
+	AB8500_VBBSEL1, /* NOTE! PRCMU register */
+	AB8500_VBBSEL2, /* NOTE! PRCMU register */
+	AB8500_VSMPS1REGU,
+	AB8500_VSMPS2REGU,
+	AB8500_VSMPS3REGU, /* NOTE! PRCMU register */
 	AB8500_VSMPS1SEL1,
+	AB8500_VSMPS3SEL1, /* NOTE! PRCMU register */
+	AB8500_VSMPS3SEL2, /* NOTE! PRCMU register */
 	AB8500_NUM_REGULATOR_REGISTERS,
 };
 
-- 
1.7.9.5

