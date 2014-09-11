Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaIKXRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:17:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:52864 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbaIKXRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:17:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,508,1406617200"; 
   d="scan'208";a="601722824"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Cc: Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3 3/5] regulator/axp20x: use axp2xx consolidated header
Date: Thu, 11 Sep 2014 16:15:55 -0700
Message-Id: <1410477357-6407-4-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410477357-6407-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1410477357-6407-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AXP20x driver has been extended to support axp288 variant. Header file
and common data structures has also been renamed to suit the new
scope of devices supported.

This patch makes use of the renamed header and structure.

Acked-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/regulator/axp20x-regulator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index 004aadb..c9b6803 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -20,7 +20,7 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
-#include <linux/mfd/axp20x.h>
+#include <linux/mfd/axp2xx.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/of_regulator.h>
 
@@ -161,7 +161,7 @@ static struct of_regulator_match axp20x_matches[] = {
 
 static int axp20x_set_dcdc_freq(struct platform_device *pdev, u32 dcdcfreq)
 {
-	struct axp20x_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
+	struct axp2xx_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
 
 	if (dcdcfreq < 750) {
 		dcdcfreq = 750;
@@ -232,7 +232,7 @@ static int axp20x_set_dcdc_workmode(struct regulator_dev *rdev, int id, u32 work
 static int axp20x_regulator_probe(struct platform_device *pdev)
 {
 	struct regulator_dev *rdev;
-	struct axp20x_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
+	struct axp2xx_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
 	struct regulator_config config = { };
 	struct regulator_init_data *init_data;
 	int ret, i;
-- 
1.9.1

