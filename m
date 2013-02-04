Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3BDLzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:55:55 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43368 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3BDLzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:55:52 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 02/73] regulator: ab8500: Initialize Vrf1 regulator
Date: Mon,  4 Feb 2013 11:53:17 +0000
Message-Id: <1359978868-28736-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vrf1 regulator is put in HW control at initialization. Forcing
this regulator to HW control in suspend is removed.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Martin PERSSON <martin.persson@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    5 +++--
 drivers/regulator/ab8500.c                    |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 0cc9edc..ba379f7 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -275,9 +275,10 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
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
index ac07fc8..b369411 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -619,9 +619,10 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
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
-- 
1.7.9.5

