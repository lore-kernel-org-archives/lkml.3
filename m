Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3EXLWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:22:31 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:58612 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3EXLWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:22:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: Provide supplies for AUX1, AUX2 and AUX3
Date: Fri, 24 May 2013 12:22:19 +0100
Message-Id: <1369394539-3713-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug introduced in the v3.10 merge window.

The AB8500 External Regulator driver has recently landed upstream,
which registers each of the 3 external regulators located on the
AB8500. If these regulators are marked as 'always on', there is a
potential for power-loss. If they're not and are seemingly unused
the Regulator subsystem will attempt to disable them to save power.
This causes an issue for AUX1, AUX2 and AUX3 as they obtain their
power from EXT3. So we're specifying that here to prevent EXT3 from
being powered down.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 33c353b..d6b7c85 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -374,6 +374,7 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	/* supplies to the display/camera */
 	[AB8500_LDO_AUX1] = {
+		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-DISPLAY",
 			.min_uV = 2800000,
@@ -387,6 +388,7 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	},
 	/* supplies to the on-board eMMC */
 	[AB8500_LDO_AUX2] = {
+		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-eMMC1",
 			.min_uV = 1100000,
@@ -402,6 +404,7 @@ static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	},
 	/* supply for VAUX3, supplies to SDcard slots */
 	[AB8500_LDO_AUX3] = {
+		.supply_regulator = "ab8500-ext-supply3",
 		.constraints = {
 			.name = "V-MMC-SD",
 			.min_uV = 1100000,
-- 
1.7.10.4

