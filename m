Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaBSIfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:35:11 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64695 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaBSIfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:35:09 -0500
Message-ID: <1392798903.31957.5.camel@phoenix>
Subject: [PATCH 3/3 v2] regulator: tps65218: Add OF dependency
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Keerthy <j-keerthy@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Feb 2014 16:35:03 +0800
In-Reply-To: <1392798801.31957.3.camel@phoenix>
References: <1392798801.31957.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a DT-only driver, so make it depend on OF and remove of_match_ptr in
the code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/Kconfig              |  2 +-
 drivers/regulator/tps65218-regulator.c | 14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index b05da880..b7c95e8 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -515,7 +515,7 @@ config REGULATOR_TPS65217
 
 config REGULATOR_TPS65218
 	tristate "TI TPS65218 Power regulators"
-	depends on MFD_TPS65218
+	depends on MFD_TPS65218 && OF
 	help
 	  This driver supports TPS65218 voltage regulator chips. TPS65218
 	  provides six step-down converters and one general-purpose LDO
diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index 1fb1db5..cec72fa 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -243,14 +243,12 @@ static int tps65218_regulator_probe(struct platform_device *pdev)
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
 
@@ -274,7 +272,7 @@ static struct platform_driver tps65218_regulator_driver = {
 	.driver = {
 		.name = "tps65218-pmic",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(tps65218_of_match),
+		.of_match_table = tps65218_of_match,
 	},
 	.probe = tps65218_regulator_probe,
 };
-- 
1.8.1.2



