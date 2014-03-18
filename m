Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaCRK6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:58:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42385 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbaCRK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:58:05 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] regulator: arizona-ldo1: Correct default regulator init_data
Date: Tue, 18 Mar 2014 10:49:17 +0000
Message-Id: <1395139757-6907-9-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both 5102 and 8997 have the regulator capable of supplying 1.8V, and the
voltage step from the 5110 regulator is different from what is specified
in the default description. This patch updates the default regulator
description to match 5110 and selects the 1.8V capable description for
8997.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index a67013f..9a3c292 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -154,11 +154,9 @@ static const struct regulator_desc arizona_ldo1 = {
 
 	.vsel_reg = ARIZONA_LDO1_CONTROL_1,
 	.vsel_mask = ARIZONA_LDO1_VSEL_MASK,
-	.bypass_reg = ARIZONA_LDO1_CONTROL_1,
-	.bypass_mask = ARIZONA_LDO1_BYPASS,
 	.min_uV = 900000,
-	.uV_step = 50000,
-	.n_voltages = 7,
+	.uV_step = 25000,
+	.n_voltages = 13,
 	.enable_time = 500,
 
 	.owner = THIS_MODULE,
@@ -261,6 +259,7 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	 */
 	switch (arizona->type) {
 	case WM5102:
+	case WM8997:
 		desc = &arizona_ldo1_hc;
 		ldo1->init_data = arizona_ldo1_dvfs;
 		break;
-- 
1.7.2.5

