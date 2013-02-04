Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab3BDMPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:15:12 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:44605 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3BDL4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:10 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/73] regulator: ab8500: Removed initialization of body biasing
Date: Mon,  4 Feb 2013 11:53:26 +0000
Message-Id: <1359978868-28736-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

Body biasing is handled by PRCMU and should not be overwritten
by the kernel.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   18 ------------------
 drivers/regulator/ab8500.c                    |   18 ------------------
 include/linux/regulator/ab8500.h              |    3 ---
 3 files changed, 39 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index ac512bc..a138587 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -239,24 +239,6 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL1VAMIC,         0x03, 0x00),
 	/*
-	 * VBBN                     = force OFF
-	 * VBBP                     = force OFF
-	 * NOTE! PRCMU register
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_ARMREGU2,               0x0f, 0x00),
-	/*
-	 * VBBNSel1                 = VBBP = VBBPFB
-	 * VBBPSel1                 = 0 V
-	 * NOTE! PRCMU register
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VBBSEL1,                0x0f, 0x00),
-	/*
-	 * VBBNSel2                 = VBBP = VBBPFB
-	 * VBBPSel2                 = 0 V
-	 * NOTE! PRCMU register
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VBBSEL2,                0x0f, 0x00),
-	/*
 	 * Vsmps1Regu               = HW control
 	 * Vsmps1SelCtrl            = Vsmps1 voltage defined by Vsmsp1Sel2
 	 */
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 0c4a871..d88ff3e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -749,12 +749,6 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_REGUCTRL1VAMIC,		0x03, 0x84, 0x03),
 	/*
-	 * 0x03, VBBPRegu
-	 * 0x0c, VBBNRegu
-	 * NOTE! PRCMU register
-	 */
-	REG_INIT(AB8500_ARMREGU2,		0x04, 0x01, 0x0f),
-	/*
 	 * 0x03, Vsmps1Regu
 	 * 0x0c, Vsmps1SelCtrl
 	 * 0x10, Vsmps1AutoMode
@@ -803,18 +797,6 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_VRF1VAUX3REGU,		0x04, 0x0a, 0x0f),
 	/*
-	 * 0x0c, VBBPSel1
-	 * 0x03, VBBNSel1
-	 * NOTE! PRCMU register
-	 */
-	REG_INIT(AB8500_VBBSEL1,		0x04, 0x11, 0x0f),
-	/*
-	 * 0x0c, VBBNSel2
-	 * 0x03, VBBPSel2
-	 * NOTE! PRCMU register
-	 */
-	REG_INIT(AB8500_VBBSEL2,		0x04, 0x12, 0x0f),
-	/*
 	 * 0x3f, Vsmps1Sel1
 	 */
 	REG_INIT(AB8500_VSMPS1SEL1,		0x04, 0x13, 0x3f),
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 7ac3281..dd7944f 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -78,7 +78,6 @@ enum ab8500_regulator_reg {
 	AB8500_REGUMISC1,
 	AB8500_VAUDIOSUPPLY,
 	AB8500_REGUCTRL1VAMIC,
-	AB8500_ARMREGU2, /* NOTE! PRCMU register */
 	AB8500_VSMPS1REGU,
 	AB8500_VSMPS2REGU,
 	AB8500_VSMPS3REGU, /* NOTE! PRCMU register */
@@ -87,8 +86,6 @@ enum ab8500_regulator_reg {
 	AB8500_EXTSUPPLYREGU,
 	AB8500_VAUX12REGU,
 	AB8500_VRF1VAUX3REGU,
-	AB8500_VBBSEL1, /* NOTE! PRCMU register */
-	AB8500_VBBSEL2, /* NOTE! PRCMU register */
 	AB8500_VSMPS1SEL1,
 	AB8500_VSMPS1SEL2,
 	AB8500_VSMPS1SEL3,
-- 
1.7.9.5

