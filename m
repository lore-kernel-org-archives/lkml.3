Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3BDMD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:03:28 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43588 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3BDL53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:29 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 52/73] ARM ux500: Remove external regulators from AB8505 init data
Date: Mon,  4 Feb 2013 11:54:07 +0000
Message-Id: <1359978868-28736-53-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

They are nonexistent on this platform.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Tested-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index b0f5e8f..6c232b7 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -759,7 +759,6 @@ static struct ab8500_regulator_reg_init ab8505_reg_init[] = {
 struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] = {
 	/* supplies to the display/camera */
 	[AB8505_LDO_AUX1] = {
-		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-DISPLAY",
 			.min_uV = 2800000,
@@ -773,7 +772,6 @@ struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] = {
 	},
 	/* supplies to the on-board eMMC */
 	[AB8505_LDO_AUX2] = {
-		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-eMMC1",
 			.min_uV = 1100000,
@@ -789,7 +787,6 @@ struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] = {
 	},
 	/* supply for VAUX3, supplies to SDcard slots */
 	[AB8505_LDO_AUX3] = {
-		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-MMC-SD",
 			.min_uV = 1100000,
@@ -936,8 +933,6 @@ struct ab8500_regulator_platform_data ab8505_regulator_plat_data = {
 	.num_reg_init           = ARRAY_SIZE(ab8505_reg_init),
 	.regulator              = ab8505_regulators,
 	.num_regulator          = ARRAY_SIZE(ab8505_regulators),
-	.ext_regulator          = ab8500_ext_regulators,
-	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
 };
 
 static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
-- 
1.7.9.5

