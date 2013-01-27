Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3A0HaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 02:30:12 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:55195 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3A0HaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 02:30:06 -0500
Message-ID: <1359271792.30887.2.camel@phoenix>
Subject: [PATCH] regulator: Add missing of_node_put()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Shawn Guo <shawn.guo@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 27 Jan 2013 15:29:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name() returns a node pointer with refcount incremented, use
of_node_put() on it when done.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Cc: Gyungoh Yoo <jack.yoo@maxim-ic.com>
Cc: MyungJoo Ham <myungjoo.ham@smasung.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
Hi,
I don't have these hardware, only compile test.
Axel
 drivers/regulator/88pm8607.c               |    1 +
 drivers/regulator/da9052-regulator.c       |    1 +
 drivers/regulator/max8907-regulator.c      |    1 +
 drivers/regulator/max8925-regulator.c      |    1 +
 drivers/regulator/max8997.c                |    2 ++
 drivers/regulator/mc13xxx-regulator-core.c |    1 +
 drivers/regulator/palmas-regulator.c       |    1 +
 drivers/regulator/tps65910-regulator.c     |    2 ++
 8 files changed, 10 insertions(+)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index a957e8c..a84048a 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -363,6 +363,7 @@ static int pm8607_regulator_dt_init(struct platform_device *pdev,
 			break;
 		}
 	}
+	of_node_put(nproot);
 	return 0;
 }
 #else
diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index c6d8651..fe06ff6 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -385,6 +385,7 @@ static int da9052_regulator_probe(struct platform_device *pdev)
 				break;
 			}
 		}
+		of_node_put(nproot);
 #endif
 	}
 
diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index d40cf7f..dccf9ff 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -239,6 +239,7 @@ static int max8907_regulator_parse_dt(struct platform_device *pdev)
 
 	ret = of_regulator_match(&pdev->dev, regulators, max8907_matches,
 				 ARRAY_SIZE(max8907_matches));
+	of_node_put(regulators);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
 			ret);
diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 446a854..f4f52f0 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -263,6 +263,7 @@ static int max8925_regulator_dt_init(struct platform_device *pdev,
 
 	rcount = of_regulator_match(&pdev->dev, np,
 				&max8925_regulator_matches[ridx], 1);
+	of_node_put(np);
 	if (rcount < 0)
 		return -ENODEV;
 	config->init_data =	max8925_regulator_matches[ridx].init_data;
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 5556a15..7d2b1b5 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -937,6 +937,7 @@ static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
 				pdata->num_regulators, GFP_KERNEL);
 	if (!rdata) {
+		of_node_put(regulators_np);
 		dev_err(&pdev->dev, "could not allocate memory for regulator data\n");
 		return -ENOMEM;
 	}
@@ -959,6 +960,7 @@ static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 		rdata->reg_node = reg_np;
 		rdata++;
 	}
+	of_node_put(regulators_np);
 
 	if (of_get_property(pmic_np, "max8997,pmic-buck1-uses-gpio-dvs", NULL))
 		pdata->buck1_gpiodvs = true;
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 2ecf1d8..04cf962 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -175,6 +175,7 @@ int mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
 	for_each_child_of_node(parent, child)
 		num++;
 
+	of_node_put(parent);
 	return num;
 }
 EXPORT_SYMBOL_GPL(mc13xxx_get_num_regulators_dt);
diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index c9e912f..bb6ea5e 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -535,6 +535,7 @@ static void palmas_dt_to_pdata(struct device *dev,
 
 	ret = of_regulator_match(dev, regulators, palmas_matches,
 			PALMAS_NUM_REGS);
+	of_node_put(regulators);
 	if (ret < 0) {
 		dev_err(dev, "Error parsing regulator init data: %d\n", ret);
 		return;
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index b0e4c0b..32ca2b0 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -994,11 +994,13 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 		matches = tps65911_matches;
 		break;
 	default:
+		of_node_put(regulators);
 		dev_err(&pdev->dev, "Invalid tps chip version\n");
 		return NULL;
 	}
 
 	ret = of_regulator_match(&pdev->dev, regulators, matches, count);
+	of_node_put(regulators);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
 			ret);
-- 
1.7.9.5



