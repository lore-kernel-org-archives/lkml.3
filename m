Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3BDL4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:56:48 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:58806 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3BDL4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:45 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 31/73] regulator: ab8500: Remove Vsafe settings
Date: Mon,  4 Feb 2013 11:53:46 +0000
Message-Id: <1359978868-28736-32-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

The Vsafe regulator should not be handled by kernel, it should be
setup before the kernel starts. This patch removes the setting of
Vsmsp3Regu.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    6 ------
 drivers/regulator/ab8500.c                    |    6 ------
 include/linux/regulator/ab8500.h              |    1 -
 3 files changed, 13 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index f9f3fc3..7c36734 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -265,12 +265,6 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VSMPS2REGU,             0x0f, 0x06),
 	/*
-	 * Vsmps3Regu               = HW control
-	 * Vsmps3SelCtrl            = Vsmps3 voltage defined by Vsmps3Sel2
-	 * NOTE! PRCMU register
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VSMPS3REGU,             0x0f, 0x06),
-	/*
 	 * VPll                     = Hw controlled
 	 * VanaRegu                 = force off
 	 */
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 3f5db96..a9841133 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -744,12 +744,6 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_VSMPS2REGU,		0x04, 0x04, 0x3f),
 	/*
-	 * 0x03, Vsmps3Regu
-	 * 0x0c, Vsmps3SelCtrl
-	 * NOTE! PRCMU register
-	 */
-	REG_INIT(AB8500_VSMPS3REGU,		0x04, 0x05, 0x0f),
-	/*
 	 * 0x03, VpllRegu
 	 * 0x0c, VanaRegu
 	 */
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 74955db..d158dcf 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -81,7 +81,6 @@ enum ab8500_regulator_reg {
 	AB8500_REGUCTRL1VAMIC,
 	AB8500_VSMPS1REGU,
 	AB8500_VSMPS2REGU,
-	AB8500_VSMPS3REGU, /* NOTE! PRCMU register */
 	AB8500_VPLLVANAREGU,
 	AB8500_VREFDDR,
 	AB8500_EXTSUPPLYREGU,
-- 
1.7.9.5

