Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaBRMVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:21:09 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57796 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbaBRMVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:21:07 -0500
Message-ID: <1392726059.13262.0.camel@phoenix>
Subject: [PATCH 1/2] regulator: tps65218: Add terminate entry for
 of_device_id table
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Keerthy <j-keerthy@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Feb 2014 20:20:59 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes below build error:
FATAL: drivers/regulator/tps65218-regulator: struct of_device_id is not terminated with a NULL entry!

Also remove of_match_ptr as this is a DT-only driver.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65218-regulator.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index 958276c..00c0114 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -96,6 +96,7 @@ static const struct of_device_id tps65218_of_match[] = {
 	TPS65218_OF_MATCH("ti,tps65218-dcdc5", tps65218_pmic_regs[DCDC5]),
 	TPS65218_OF_MATCH("ti,tps65218-dcdc6", tps65218_pmic_regs[DCDC6]),
 	TPS65218_OF_MATCH("ti,tps65218-ldo1", tps65218_pmic_regs[LDO1]),
+	{ }
 };
 MODULE_DEVICE_TABLE(of, tps65218_of_match);
 
@@ -242,14 +243,12 @@ static int tps65218_regulator_probe(struct platform_device *pdev)
 	int id;
 
 	match = of_match_device(tps65218_of_match, &pdev->dev);
-	if (match) {
-		template = match->data;
-		id = template->id;
-		init_data = of_get_regulator_init_data(&pdev->dev,
-						      pdev->dev.of_node);
-	} else {
+	if (!match)
 		return -ENODEV;
-	}
+
+	template = match->data;
+	id = template->id;
+	init_data = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node);
 
 	platform_set_drvdata(pdev, tps);
 
@@ -290,7 +289,7 @@ static struct platform_driver tps65218_regulator_driver = {
 	.driver = {
 		.name = "tps65218-pmic",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(tps65218_of_match),
+		.of_match_table = tps65218_of_match,
 	},
 	.probe = tps65218_regulator_probe,
 	.remove = tps65218_regulator_remove,
-- 
1.8.1.2



