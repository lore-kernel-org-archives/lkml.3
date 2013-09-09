Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3IIPyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:54:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3IIPwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:52:13 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 2/2] regulator: da9210: add Device Tree support
Date: Mon,  9 Sep 2013 17:52:00 +0200
Message-Id: <1378741920-11085-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1378741920-11085-1-git-send-email-g.liakhovetski@gmx.de>
References: <1378741920-11085-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:RDA0xxyFWhxo15tKkXqQfqOLWDERG+dGFgwD0WdBtP8
 drkFsjTlh+YqLNDKILh+LjCvUiuR0PeM5cLNwwJPKGqTLDAgOb
 J6B9k+muDjgH8PwdB2CrUTsyfbINZLXRWiNfPdfi8SMOIlAYJL
 oFXq7AsSsCFyTBH7y150yWHiJ4FrEN3t+QKKJql9N7oCznILHz
 aLnZP1rB0tcz0ROmIJSZP006xQBJKv3Jj+Ab27zyMihxHtYWMf
 MNcPHPmkaNt/VKGdq4wEkDQxvxdQJS+UO0R1HAGRe4+NGY8BZu
 7s9PtHscjuWGlpS4yYJca6s7VEdtloOx1imfYM7d1WpVRDiEDb
 tzHi7EMc7tq1HKRKQjNlFbAn+P7cMH0GrtepiC+mIcq9ne5xZg
 UhFm0/mLqYhyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic Device Tree support to the da9210 regulator driver -
with no special properties, since also driver's platform data only contains
standard regulator initialisation parameters.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/regulator/da9210-regulator.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/da9210-regulator.c b/drivers/regulator/da9210-regulator.c
index f0fe54b..f7ccff14 100644
--- a/drivers/regulator/da9210-regulator.c
+++ b/drivers/regulator/da9210-regulator.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/regmap.h>
 
 #include "da9210-regulator.h"
@@ -126,7 +127,8 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct da9210 *chip;
-	struct da9210_pdata *pdata = i2c->dev.platform_data;
+	struct device *dev = &i2c->dev;
+	struct da9210_pdata *pdata = dev_get_platdata(dev);
 	struct regulator_dev *rdev = NULL;
 	struct regulator_config config = { };
 	int error;
@@ -147,10 +149,11 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
 	}
 
 	config.dev = &i2c->dev;
-	if (pdata)
-		config.init_data = &pdata->da9210_constraints;
+	config.init_data = pdata ? &pdata->da9210_constraints :
+		of_get_regulator_init_data(dev, dev->of_node);
 	config.driver_data = chip;
 	config.regmap = chip->regmap;
+	config.of_node = dev->of_node;
 
 	rdev = regulator_register(&da9210_reg, &config);
 	if (IS_ERR(rdev)) {
-- 
1.7.2.5

