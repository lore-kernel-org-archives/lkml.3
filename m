Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaDXLJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:09:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDXIx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 064/182] regulator: arizona-ldo1: Correct default regulator init_data
Date: Thu, 24 Apr 2014 09:49:49 +0100
Message-Id: <1398329507-5911-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/regulator/arizona-ldo1.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 81d8681..7917bb2 100644
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

