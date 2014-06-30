Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbaF3P7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:59:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42878 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbaF3P5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:57:49 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Keerthy J <j-keerthy@ti.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 4/6] regulator: palmas: Rename palmas_regs_info to palmas_generic_regs_info
Date: Mon, 30 Jun 2014 10:57:37 -0500
Message-ID: <1404143859-8160-5-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404143859-8160-1-git-send-email-nm@ti.com>
References: <1404143859-8160-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit d6f83370ed978d5570b7c8c22988310cb9376202 (regulator: palmas:
Add tps65917 PMIC support) palmas_regs_info naming is confusing as it is
a driver data parameter and a local variable. To prevent mistaken
updates, rename the local variable to palmas_generic_regs_info.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/palmas-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index f75fb90..d6b734f 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -41,7 +41,7 @@ static const struct regulator_linear_range smps_high_ranges[] = {
 	REGULATOR_LINEAR_RANGE(3300000, 0x7A, 0x7f, 0),
 };
 
-static struct palmas_regs_info palmas_regs_info[] = {
+static struct palmas_regs_info palmas_generic_regs_info[] = {
 	{
 		.name		= "SMPS12",
 		.sname		= "smps1-in",
@@ -1417,7 +1417,7 @@ static struct palmas_pmic_driver_data palmas_ddata = {
 	.ldo_begin = PALMAS_REG_LDO1,
 	.ldo_end = PALMAS_REG_LDOUSB,
 	.max_reg = PALMAS_NUM_REGS,
-	.palmas_regs_info = palmas_regs_info,
+	.palmas_regs_info = palmas_generic_regs_info,
 	.palmas_matches = palmas_matches,
 	.sleep_req_info = palma_sleep_req_info,
 	.smps_register = palmas_smps_registration,
-- 
1.7.9.5

