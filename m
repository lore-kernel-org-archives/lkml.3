Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab3GHM7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:59:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64406 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3GHM7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:59:51 -0400
X-AuditID: cbfee68e-b7f276d000002279-cb-51dab7c6dd08
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sbkim73@samsung.com, broonie@kernel.org, lgirdwood@gmail.com,
        sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [v2 PATCH 2/6] regulator: s2mps11: Implement set_ramp_rate callback
 for bucks
Date: Sat, 29 Jun 2013 18:21:16 +0530
Message-id: <1372510280-31931-3-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSrXts+61Ag/mHeSymPnzCZnHgzw5G
	i29XOpgsLu+aw2ZxeMUBJouTf3oZLU53s1pcXPGFyWLu70ZWiznT3zE5cHks+HyF3WPnrLvs
	HptWdbJ53Lm2h81j3slAj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4MpYPOMBe0GfVkXzqS/M
	DYw/lboYOTkkBEwkzq/aywxhi0lcuLeerYuRi0NIYCmjxK/TnUwwRZNXXmOCSCxilFh1ejGU
	08Ykca9nJ1A7BwebgJHEq2N2IA0iAgoSm3ufsYLUMAu8ZZRYuvQGC0hCWCBC4uyxrawgNouA
	qkTbrhXsIDavgKvE5PnbWCG2KUi0LjsEFucUcJPomnwd7AohoJqPe9rBFksIHGOXWLp2EwvE
	IAGJb5MPsYAcISEgK7HpANQ7khIHV9xgmcAovICRYRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+
	7iZGYFyc/vesbwfjzQPWhxiTgcZNZJYSTc4HxlVeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaB
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhgZGeenT4kuK9nRWjKRn1fC8w1jRPT6NZeTHqfb
	fz7i08D0p/5c9gurczKvC+JsVI8zFB5kYp+Ry3mL9b/l8c43s106OX/4F8hptSp+Tmndcr6u
	Y1Vcqow41583rxvNjob6ntZp6fgQ+J9HfsfDKjW33JaEaLsbe38LzTvr1HZtC6fnK/VCByWW
	4oxEQy3mouJEAOV68ruhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAd1j228FGnz6yWQx9eETNosDf3Yw
	Wny70sFkcXnXHDaLwysOMFmc/NPLaHG6m9Xi4oovTBZzfzeyWsyZ/o7Jgctjwecr7B47Z91l
	99i0qpPN4861PWwe804GevRtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjMUzHrAX9GlVNJ/6wtzA+FOpi5GTQ0LARGLyymtMELaYxIV769m6GLk4hAQW
	MUqsOr2YCcJpY5K417OTuYuRg4NNwEji1TE7kAYRAQWJzb3PWEFqmAXeMkosXXqDBSQhLBAh
	cfbYVlYQm0VAVaJt1wp2EJtXwFVi8vxtrBDbFCRalx0Ci3MKuEl0Tb4OdoUQUM3HPe1MExh5
	FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjrpnUjsYVzZYHGIU4GBU4uGVOH0zUIg1
	say4MvcQowQHs5IIrzjrrUAh3pTEyqrUovz4otKc1OJDjMlAV01klhJNzgcmhLySeENjE3NT
	Y1NLEwsTM0vShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYGTTyi8q3jz1Q28zY2bLkZWd
	pgp9BacWHTQ8sjb/W/8HrovpO5v2M925Ylgtn6jJasK3PWKq5gXH2SzrT28/r/VD8++Ep0G/
	G/eFZE0X+cO/L67cJOr8Zq+32+1WB0RsCsqNeB9c43jCe8XPT5E8Uewfw/fMWit+RGJ9j23D
	/jubrtZzPdp66bsSS3FGoqEWc1FxIgDXkqo+/gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implementing set_ramp_rate() and using standard constraints for getting
ramp_delay and ramp_disable, instead of getting it as s2mps11 specific data
through platform data, makes driver more compliant with framework and reduces
the complexity for adding DT support.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/s2mps11.c         |  117 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/samsung/s2mps11.h |   11 +++
 2 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index a671eb6..4bebcb6 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -16,6 +16,7 @@
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/regmap.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
@@ -104,6 +105,121 @@ static int s2mps11_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 	return DIV_ROUND_UP(abs(new_volt - old_volt), ramp_delay);
 }
 
+static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
+{
+	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+	unsigned int ramp_val, ramp_shift, ramp_reg = S2MPS11_REG_RAMP_BUCK;
+	unsigned int ramp_enable = 1, enable_shift = 0;
+	int ret;
+
+	switch (rdev->desc->id) {
+	case S2MPS11_BUCK1:
+		if (ramp_delay > s2mps11->ramp_delay16)
+			s2mps11->ramp_delay16 = ramp_delay;
+		else
+			ramp_delay = s2mps11->ramp_delay16;
+
+		ramp_shift = S2MPS11_BUCK16_RAMP_SHIFT;
+		break;
+	case S2MPS11_BUCK2:
+		enable_shift = S2MPS11_BUCK2_RAMP_EN_SHIFT;
+		if (!ramp_delay) {
+			ramp_enable = 0;
+			break;
+		}
+
+		s2mps11->ramp_delay2 = ramp_delay;
+		ramp_shift = S2MPS11_BUCK2_RAMP_SHIFT;
+		ramp_reg = S2MPS11_REG_RAMP;
+		break;
+	case S2MPS11_BUCK3:
+		enable_shift = S2MPS11_BUCK3_RAMP_EN_SHIFT;
+		if (!ramp_delay) {
+			ramp_enable = 0;
+			break;
+		}
+
+		if (ramp_delay > s2mps11->ramp_delay34)
+			s2mps11->ramp_delay34 = ramp_delay;
+		else
+			ramp_delay = s2mps11->ramp_delay34;
+
+		ramp_shift = S2MPS11_BUCK34_RAMP_SHIFT;
+		ramp_reg = S2MPS11_REG_RAMP;
+		break;
+	case S2MPS11_BUCK4:
+		enable_shift = S2MPS11_BUCK4_RAMP_EN_SHIFT;
+		if (!ramp_delay) {
+			ramp_enable = 0;
+			break;
+		}
+
+		if (ramp_delay > s2mps11->ramp_delay34)
+			s2mps11->ramp_delay34 = ramp_delay;
+		else
+			ramp_delay = s2mps11->ramp_delay34;
+
+		ramp_shift = S2MPS11_BUCK34_RAMP_SHIFT;
+		ramp_reg = S2MPS11_REG_RAMP;
+		break;
+	case S2MPS11_BUCK5:
+		s2mps11->ramp_delay5 = ramp_delay;
+		ramp_shift = S2MPS11_BUCK5_RAMP_SHIFT;
+		break;
+	case S2MPS11_BUCK6:
+		enable_shift = S2MPS11_BUCK6_RAMP_EN_SHIFT;
+		if (!ramp_delay) {
+			ramp_enable = 0;
+			break;
+		}
+
+		if (ramp_delay > s2mps11->ramp_delay16)
+			s2mps11->ramp_delay16 = ramp_delay;
+		else
+			ramp_delay = s2mps11->ramp_delay16;
+
+		ramp_shift = S2MPS11_BUCK16_RAMP_SHIFT;
+		break;
+	case S2MPS11_BUCK7:
+	case S2MPS11_BUCK8:
+	case S2MPS11_BUCK10:
+		if (ramp_delay > s2mps11->ramp_delay7810)
+			s2mps11->ramp_delay7810 = ramp_delay;
+		else
+			ramp_delay = s2mps11->ramp_delay7810;
+
+		ramp_shift = S2MPS11_BUCK7810_RAMP_SHIFT;
+		break;
+	case S2MPS11_BUCK9:
+		s2mps11->ramp_delay9 = ramp_delay;
+		ramp_shift = S2MPS11_BUCK9_RAMP_SHIFT;
+		break;
+	default:
+		return 0;
+	}
+
+	if (!ramp_enable)
+		goto ramp_disable;
+
+	if (enable_shift) {
+		ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
+					1 << enable_shift, 1 << enable_shift);
+		if (ret) {
+			dev_err(&rdev->dev, "failed to enable ramp rate\n");
+			return ret;
+		}
+	}
+
+	ramp_val = get_ramp_delay(ramp_delay);
+
+	return regmap_update_bits(rdev->regmap, ramp_reg,
+				  ramp_val << ramp_shift, 1 << ramp_shift);
+
+ramp_disable:
+	return regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP, 0,
+				  1 << enable_shift);
+}
+
 static struct regulator_ops s2mps11_ldo_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
@@ -124,6 +240,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= s2mps11_regulator_set_voltage_time_sel,
+	.set_ramp_delay		= s2mps11_set_ramp_delay,
 };
 
 #define regulator_desc_ldo1(num)	{		\
diff --git a/include/linux/mfd/samsung/s2mps11.h b/include/linux/mfd/samsung/s2mps11.h
index 4e94dc6..d0d52ea 100644
--- a/include/linux/mfd/samsung/s2mps11.h
+++ b/include/linux/mfd/samsung/s2mps11.h
@@ -191,6 +191,17 @@ enum s2mps11_regulators {
 #define S2MPS11_BUCK_N_VOLTAGES (S2MPS11_BUCK_VSEL_MASK + 1)
 #define S2MPS11_RAMP_DELAY	25000		/* uV/us */
 
+
+#define S2MPS11_BUCK2_RAMP_SHIFT	6
+#define S2MPS11_BUCK34_RAMP_SHIFT	4
+#define S2MPS11_BUCK5_RAMP_SHIFT	6
+#define S2MPS11_BUCK16_RAMP_SHIFT	4
+#define S2MPS11_BUCK7810_RAMP_SHIFT	2
+#define S2MPS11_BUCK9_RAMP_SHIFT	0
+#define S2MPS11_BUCK2_RAMP_EN_SHIFT	3
+#define S2MPS11_BUCK3_RAMP_EN_SHIFT	2
+#define S2MPS11_BUCK4_RAMP_EN_SHIFT	1
+#define S2MPS11_BUCK6_RAMP_EN_SHIFT	0
 #define S2MPS11_PMIC_EN_SHIFT	6
 #define S2MPS11_REGULATOR_MAX (S2MPS11_REG_MAX - 3)
 
-- 
1.7.0.4

