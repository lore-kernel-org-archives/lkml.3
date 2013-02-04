Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3BDMRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:17:25 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:49591 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab3BDLz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:55:56 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/73] regulator: ab8500: Added SysClkReq1 control of Vpll
Date: Mon,  4 Feb 2013 11:53:19 +0000
Message-Id: <1359978868-28736-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Martin PERSSON <martin.persson@stericsson.com>
Tested-by: David PARIS <david.paris-nonst@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    4 +++-
 drivers/regulator/ab8500.c                    |    5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 42eef80..ae0695b 100644
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
@@ -143,13 +144,14 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL4, 0x00),
 	/*
 	 * VanaSysClkReq1HPValid    = disabled
+	 * VpllSysClkReq1HPValid    = enabled
 	 * Vaux1SysClkReq1HPValid   = disabled
 	 * Vaux2SysClkReq1HPValid   = disabled
 	 * Vaux3SysClkReq1HPValid   = disabled
 	 * Vsmps2SysClkReq1HPValid  = enabled
 	 * Vsmps1SysClkReq1HPValid  = enabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0x03),
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0x13),
 	/*
 	 * VextSupply1SysClkReq1HPValid = disabled
 	 * VextSupply2SysClkReq1HPValid = disabled
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 84cd11c..8edc413 100644
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
@@ -497,11 +497,12 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 * 0x01, Vsmps1SysClkReq1HPValid
 	 * 0x02, Vsmps2SysClkReq1HPValid
 	 * 0x08, VanaSysClkReq1HPValid
+	 * 0x10, VpllSysClkReq1HPValid
 	 * 0x20, Vaux1SysClkReq1HPValid
 	 * 0x40, Vaux2SysClkReq1HPValid
 	 * 0x80, Vaux3SysClkReq1HPValid
 	 */
-	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xeb),
+	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xfb),
 	/*
 	 * 0x10, VextSupply1SysClkReq1HPValid
 	 * 0x20, VextSupply2SysClkReq1HPValid
-- 
1.7.9.5

