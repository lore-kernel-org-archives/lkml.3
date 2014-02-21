Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbaBUNmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:42:39 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51094 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439AbaBUNmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:42:36 -0500
Message-ID: <1392990143.17821.1.camel@phoenix>
Subject: [PATCH] regulator: tps65217: Allow missing init_data for diagnostics
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: AnilKumar Ch <anilkumar@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Feb 2014 21:42:23 +0800
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
 drivers/regulator/tps65217-regulator.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index fd441f2..10b78d2 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -202,7 +202,7 @@ static struct tps65217_board *tps65217_parse_dt(struct platform_device *pdev)
 		return NULL;
 
 	for (i = 0; i < count; i++) {
-		if (!reg_matches[i].init_data || !reg_matches[i].of_node)
+		if (!reg_matches[i].of_node)
 			continue;
 
 		pdata->tps65217_init_data[i] = reg_matches[i].init_data;
@@ -222,7 +222,6 @@ static int tps65217_regulator_probe(struct platform_device *pdev)
 {
 	struct tps65217 *tps = dev_get_drvdata(pdev->dev.parent);
 	struct tps65217_board *pdata = dev_get_platdata(tps->dev);
-	struct regulator_init_data *reg_data;
 	struct regulator_dev *rdev;
 	struct regulator_config config = { };
 	int i;
@@ -243,19 +242,9 @@ static int tps65217_regulator_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, tps);
 
 	for (i = 0; i < TPS65217_NUM_REGULATOR; i++) {
-
-		reg_data = pdata->tps65217_init_data[i];
-
-		/*
-		 * Regulator API handles empty constraints but not NULL
-		 * constraints
-		 */
-		if (!reg_data)
-			continue;
-
 		/* Register the regulators */
 		config.dev = tps->dev;
-		config.init_data = reg_data;
+		config.init_data = pdata->tps65217_init_data[i];
 		config.driver_data = tps;
 		config.regmap = tps->regmap;
 		if (tps->dev->of_node)
-- 
1.8.1.2



