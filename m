Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaBRNL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:11:59 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47530 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbaBRNL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:11:58 -0500
Message-ID: <1392729108.18579.1.camel@phoenix>
Subject: [PATCH RFT] regulator: tps65910: Allow missing init_data for
 diagnostics
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Markus Pargmann <mpa@pengutronix.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 18 Feb 2014 21:11:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator core supports this to allow the configuration to be inspected
at runtime even if no software management is enabled.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65910-regulator.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index f50dd84..3c8bd34 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1050,7 +1050,7 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 	*tps65910_reg_matches = matches;
 
 	for (idx = 0; idx < count; idx++) {
-		if (!matches[idx].init_data || !matches[idx].of_node)
+		if (!matches[idx].of_node)
 			continue;
 
 		pmic_plat_data->tps65910_pmic_init_data[idx] =
@@ -1080,7 +1080,6 @@ static int tps65910_probe(struct platform_device *pdev)
 	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
 	struct regulator_config config = { };
 	struct tps_info *info;
-	struct regulator_init_data *reg_data;
 	struct regulator_dev *rdev;
 	struct tps65910_reg *pmic;
 	struct tps65910_board *pmic_plat_data;
@@ -1151,14 +1150,6 @@ static int tps65910_probe(struct platform_device *pdev)
 
 	for (i = 0; i < pmic->num_regulators && i < TPS65910_NUM_REGS;
 			i++, info++) {
-
-		reg_data = pmic_plat_data->tps65910_pmic_init_data[i];
-
-		/* Regulator API handles empty constraints but not NULL
-		 * constraints */
-		if (!reg_data)
-			continue;
-
 		/* Register the regulators */
 		pmic->info[i] = info;
 
@@ -1210,7 +1201,7 @@ static int tps65910_probe(struct platform_device *pdev)
 		pmic->desc[i].enable_mask = TPS65910_SUPPLY_STATE_ENABLED;
 
 		config.dev = tps65910->dev;
-		config.init_data = reg_data;
+		config.init_data = pmic_plat_data->tps65910_pmic_init_data[i];
 		config.driver_data = pmic;
 		config.regmap = tps65910->regmap;
 
-- 
1.8.1.2



