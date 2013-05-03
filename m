Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761066Ab3ECMqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:46:17 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35740 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3ECMqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:46:16 -0400
Message-ID: <1367585170.7397.1.camel@phoenix>
Subject: [PATCH] regulator: Remove all platform_set_drvdata(pdev, NULL) in
 drivers
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>, Milo Kim <milo.kim@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 03 May 2013 20:46:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 0998d06310 "device-core: Ensure drvdata = NULL when no driver is bound",
this is done by driver core after device_release or on probe failure.
Thus we can remove all platform_set_drvdata(pdev, NULL) in drivers.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/88pm8607.c           | 1 -
 drivers/regulator/lp8788-buck.c        | 1 -
 drivers/regulator/lp8788-ldo.c         | 2 --
 drivers/regulator/max8925-regulator.c  | 1 -
 drivers/regulator/mc13783-regulator.c  | 2 --
 drivers/regulator/mc13892-regulator.c  | 2 --
 drivers/regulator/pcap-regulator.c     | 1 -
 drivers/regulator/pcf50633-regulator.c | 1 -
 drivers/regulator/tps65217-regulator.c | 2 --
 drivers/regulator/virtual.c            | 2 --
 drivers/regulator/wm831x-dcdc.c        | 7 -------
 drivers/regulator/wm831x-isink.c       | 2 --
 drivers/regulator/wm831x-ldo.c         | 2 --
 drivers/regulator/wm8400-regulator.c   | 1 -
 drivers/regulator/wm8994-regulator.c   | 2 --
 15 files changed, 29 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 493948a..8a7cb1f 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -406,7 +406,6 @@ static int pm8607_regulator_remove(struct platform_device *pdev)
 {
 	struct pm8607_regulator_info *info = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(info->regulator);
 	return 0;
 }
diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index eb1e1e8..0b015f2 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -533,7 +533,6 @@ static int lp8788_buck_remove(struct platform_device *pdev)
 {
 	struct lp8788_buck *buck = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(buck->regulator);
 
 	return 0;
diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index 0ce2c4c..0527d87 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -561,7 +561,6 @@ static int lp8788_dldo_remove(struct platform_device *pdev)
 {
 	struct lp8788_ldo *ldo = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(ldo->regulator);
 
 	return 0;
@@ -622,7 +621,6 @@ static int lp8788_aldo_remove(struct platform_device *pdev)
 {
 	struct lp8788_ldo *ldo = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(ldo->regulator);
 
 	return 0;
diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 3597da8..e6d54a5 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -327,7 +327,6 @@ static int max8925_regulator_remove(struct platform_device *pdev)
 {
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(rdev);
 
 	return 0;
diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index fdf7f0a..5ff99d2 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -466,8 +466,6 @@ static int mc13783_regulator_remove(struct platform_device *pdev)
 	struct mc13xxx_regulator_priv *priv = platform_get_drvdata(pdev);
 	int i;
 
-	platform_set_drvdata(pdev, NULL);
-
 	for (i = 0; i < priv->num_regulators; i++)
 		regulator_unregister(priv->regulators[i]);
 
diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index b716283..1037e07 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -636,8 +636,6 @@ static int mc13892_regulator_remove(struct platform_device *pdev)
 	struct mc13xxx_regulator_priv *priv = platform_get_drvdata(pdev);
 	int i;
 
-	platform_set_drvdata(pdev, NULL);
-
 	for (i = 0; i < priv->num_regulators; i++)
 		regulator_unregister(priv->regulators[i]);
 
diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index 4899342..1a73a29 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -260,7 +260,6 @@ static int pcap_regulator_remove(struct platform_device *pdev)
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 
 	regulator_unregister(rdev);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 534075e..54df9f7 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -106,7 +106,6 @@ static int pcf50633_regulator_remove(struct platform_device *pdev)
 {
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(rdev);
 
 	return 0;
diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index df39518..2df4616 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -405,8 +405,6 @@ static int tps65217_regulator_remove(struct platform_device *pdev)
 	for (i = 0; i < TPS65217_NUM_REGULATOR; i++)
 		regulator_unregister(tps->rdev[i]);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index 01c66e9..a9d4284 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -330,8 +330,6 @@ static int regulator_virtual_remove(struct platform_device *pdev)
 	if (drvdata->enabled)
 		regulator_disable(drvdata->regulator);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 0af6898..46938cf 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -567,8 +567,6 @@ static int wm831x_buckv_remove(struct platform_device *pdev)
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 	struct wm831x *wm831x = dcdc->wm831x;
 
-	platform_set_drvdata(pdev, NULL);
-
 	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "HC")),
 			    dcdc);
 	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV")),
@@ -714,8 +712,6 @@ static int wm831x_buckp_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
-
 	free_irq(wm831x_irq(dcdc->wm831x, platform_get_irq_byname(pdev, "UV")),
 			    dcdc);
 	regulator_unregister(dcdc->regulator);
@@ -849,8 +845,6 @@ static int wm831x_boostp_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
-
 	free_irq(wm831x_irq(dcdc->wm831x, platform_get_irq_byname(pdev, "UV")),
 		 dcdc);
 	regulator_unregister(dcdc->regulator);
@@ -940,7 +934,6 @@ static int wm831x_epe_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(dcdc->regulator);
 
 	return 0;
diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 68586ee..16ebdf9 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -225,8 +225,6 @@ static int wm831x_isink_remove(struct platform_device *pdev)
 {
 	struct wm831x_isink *isink = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
-
 	free_irq(wm831x_irq(isink->wm831x, platform_get_irq(pdev, 0)), isink);
 
 	regulator_unregister(isink->regulator);
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 1ec379a..9ff883f 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -338,8 +338,6 @@ static int wm831x_gp_ldo_remove(struct platform_device *pdev)
 {
 	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
-
 	free_irq(wm831x_irq(ldo->wm831x,
 			    platform_get_irq_byname(pdev, "UV")), ldo);
 	regulator_unregister(ldo->regulator);
diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index c6a32ea..a09f03e 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -250,7 +250,6 @@ static int wm8400_regulator_remove(struct platform_device *pdev)
 {
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(rdev);
 
 	return 0;
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index a612c35..8f2a8a7 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -185,8 +185,6 @@ static int wm8994_ldo_remove(struct platform_device *pdev)
 {
 	struct wm8994_ldo *ldo = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
-
 	regulator_unregister(ldo->regulator);
 
 	return 0;
-- 
1.8.1.2



