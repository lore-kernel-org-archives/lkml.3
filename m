Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab3BDMSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:18:06 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:46213 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab3BDLzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:55:50 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>
Subject: [PATCH 01/73] regulator: ab8500: Remove VBB from suspend force
Date: Mon,  4 Feb 2013 11:53:16 +0000
Message-Id: <1359978868-28736-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove VBB from suspend force and add correct init values

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Martin Persson <martin.persson@stericsson.com>
Reviewed-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   18 ++++++++++++++++++
 drivers/regulator/ab8500.c                    |   18 ++++++++++++++++++
 include/linux/regulator/ab8500.h              |    3 +++
 3 files changed, 39 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 2a17bc5..0cc9edc 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -234,6 +234,24 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
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
 	 * VPll                     = Hw controlled
 	 * VanaRegu                 = force off
 	 */
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 09014f3..ac07fc8 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -578,6 +578,24 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
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
 	 * 0x0c, VanaRegu
 	 * 0x03, VpllRegu
 	 */
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 7bd73bb..d61adb9 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -86,6 +86,9 @@ enum ab8500_regulator_reg {
 	AB8500_REGUCTRL2SPARE,
 	AB8500_REGUCTRLDISCH,
 	AB8500_REGUCTRLDISCH2,
+	AB8500_ARMREGU2, /* NOTE! PRCMU register */
+	AB8500_VBBSEL1, /* NOTE! PRCMU register */
+	AB8500_VBBSEL2, /* NOTE! PRCMU register */
 	AB8500_VSMPS1SEL1,
 	AB8500_NUM_REGULATOR_REGISTERS,
 };
-- 
1.7.9.5

