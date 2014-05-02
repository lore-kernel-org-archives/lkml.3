Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaEBQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:16:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaEBPmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 062/151] regulator: arizona-ldo1: Correct default regulator init_data
Date: Fri,  2 May 2014 08:37:30 -0700
Message-Id: <1399045139-4531-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit a35ff2861690eaf9dbb38fa744a8a9e6f4ebfd61 upstream.

Both 5102 and 8997 have the regulator capable of supplying 1.8V, and the
voltage step from the 5110 regulator is different from what is specified
in the default description. This patch updates the default regulator
description to match 5110 and selects the 1.8V capable description for
8997.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/regulator/arizona-ldo1.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 4f6c205..f0ea4fd 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -153,11 +153,9 @@ static const struct regulator_desc arizona_ldo1 = {
 
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
@@ -203,6 +201,7 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	 */
 	switch (arizona->type) {
 	case WM5102:
+	case WM8997:
 		desc = &arizona_ldo1_hc;
 		ldo1->init_data = arizona_ldo1_dvfs;
 		break;
-- 
1.9.1

