Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3BDL5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:57:38 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38589 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3BDL5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:35 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 55/73] regulator: ab8500: Provide ExtSupply register init values for AB8505
Date: Mon,  4 Feb 2013 11:54:10 +0000
Message-Id: <1359978868-28736-56-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Wallin <mattias.wallin@stericsson.com>

On the AB8505 chip the ExtSupply balls are not mounted.
However the ExtSupply register is there and this patch set the
correct init value for that register. On HREF520 it saves 300uA.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    8 ++++++++
 drivers/regulator/ab8500.c                    |    8 ++++++++
 include/linux/regulator/ab8500.h              |    1 +
 3 files changed, 17 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 6c232b7..cc6ec35 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -651,6 +651,14 @@ static struct ab8500_regulator_reg_init ab8505_reg_init[] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8505_VPLLVANAREGU,           0x0f, 0x02),
 	/*
+	 * VextSupply1Regu          = force OFF (OTP_ExtSupply12LPnPolarity 1)
+	 * VextSupply2Regu          = force OFF (OTP_ExtSupply12LPnPolarity 1)
+	 * VextSupply3Regu          = force OFF (OTP_ExtSupply3LPnPolarity 0)
+	 * ExtSupply2Bypass         = ExtSupply12LPn ball is 0 when Ena is 0
+	 * ExtSupply3Bypass         = ExtSupply3LPn ball is 0 when Ena is 0
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_EXTSUPPLYREGU,          0xff, 0x30),
+	/*
 	 * Vaux1Regu                = force HP
 	 * Vaux2Regu                = force off
 	 */
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index f78cad5..e654f0a 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1803,6 +1803,14 @@ static struct ab8500_reg_init ab8505_reg_init[] = {
 	 */
 	REG_INIT(AB8505_VPLLVANAREGU,		0x04, 0x06, 0x0f),
 	/*
+	 * 0x03, VextSupply1Regu
+	 * 0x0c, VextSupply2Regu
+	 * 0x30, VextSupply3Regu
+	 * 0x40, ExtSupply2Bypass
+	 * 0x80, ExtSupply3Bypass
+	 */
+	REG_INIT(AB8505_EXTSUPPLYREGU,		0x04, 0x08, 0xff),
+	/*
 	 * 0x03, Vaux1Regu
 	 * 0x0c, Vaux2Regu
 	 */
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 1d33586..5977c47 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -158,6 +158,7 @@ enum ab8505_regulator_reg {
 	AB8505_VSMPSBREGU,
 	AB8505_VSAFEREGU, /* NOTE! PRCMU register */
 	AB8505_VPLLVANAREGU,
+	AB8505_EXTSUPPLYREGU,
 	AB8505_VAUX12REGU,
 	AB8505_VRF1VAUX3REGU,
 	AB8505_VSMPSASEL1,
-- 
1.7.9.5

