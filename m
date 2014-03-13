Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaCMIUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:20:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34738 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaCMIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:17:45 -0400
X-AuditID: cbfee690-b7f266d00000287c-a6-5321699d9a8e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 3/8] devfreq: exynos4: Add ppmu's clock control and code
 clean about regulator control
Date: Thu, 13 Mar 2014 17:17:24 +0900
Message-id: <1394698649-20996-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkUHdupmKwwf5F4hYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4Mq49PcPY8FO/YoLnbOYGxiPqXUxcnJICJhIXJmwkBXCFpO4
	cG89WxcjF4eQwFJGifa3vxhhij4/XsAOkZjOKHHyxmomCKeRSWLFpgdg7WwCWhL7X9xgA7FF
	BMwldi39CTaKWeAZk8St/j4mkISwQJZEw53PYA0sAqoSbzuWsYDYvAKuEmdWNTFDrJOT+LDn
	ETuIzSngJnHz7jSwXiGgmgutU5hBhkoIfGSXWHn7OwvEIAGJb5MPAdkcQAlZiU0HoOZIShxc
	cYNlAqPwAkaGVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxiBcXX637MJOxjvHbA+xJgMNG4i
	s5Rocj4wLvNK4g2NzYwsTE1MjY3MLc1IE1YS51V7lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJ
	g1OqgbHep8t+H4fEqgc71EqsN6xnWqS6SiP8TUptQCHDzC1BWveTQv7GVBwXalKuWqycLmJx
	mWU6i8TmyWVzNk188s/J9k2q97TFe66bZSzarnvnmPRdJYEF2uulGNkttRb0eT7wuHSpIk//
	1Jp/yv8dDT6bTHr/8MVJ66+7Cj46u9ndLw+dOG1R6BUlluKMREMt5qLiRABF7paywQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO7cTMVgg7cPeS06en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx49LfP4wFO/UrLnTO
	Ym5gPKbWxcjJISFgIvH58QJ2CFtM4sK99WxdjFwcQgLTGSVO3ljNBOE0Mkms2PSAFaSKTUBL
	Yv+LG2wgtoiAucSupT/BOpgFnjFJ3OrvYwJJCAtkSTTc+QzWwCKgKvG2YxkLiM0r4CpxZlUT
	M8Q6OYkPex6BreYUcJO4eXcaWK8QUM2F1inMExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvX
	S87P3cQIjtpnUjsYVzZYHGIU4GBU4uFdsVwhWIg1say4MvcQowQHs5IIr6ePYrAQb0piZVVq
	UX58UWlOavEhxmSgqyYyS4km5wMTSl5JvKGxiZmRpZG5oYWRsTlpwkrivAdarQOFBNITS1Kz
	U1MLUotgtjBxcEo1MDK9vWOhKLx97fzEfR91GLfNT1QIi5IUPVz95Olkrmfvzf+/fXho6eaX
	abvv9Srbpr2dp/PXeMmWSWt/H0xTu/FJZaniW2VOAaX2u2ZiO9+paBoA4zemYfK0Ssb1Ptee
	zxFNkWw1FEy87BM13X6Fupv7tr3Mb+aK7DuzLaL/zvN37bt7FoQ981NiKc5INNRiLipOBAD1
	pP1LHgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are not the clock controller of ppmudmc0/1. This patch control the clock
of ppmudmc0/1 which is used for monitoring memory bus utilization.

Also, this patch code clean about regulator control and free resource
when calling exit/remove function.

For example,
busfreq@106A0000 {
	compatible = "samsung,exynos4x12-busfreq";

	/* Clock for PPMUDMC0/1 */
	clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
	clock-names = "ppmudmc0", "ppmudmc1";

	/* Regulator for MIF/INT block */
	vdd_mif-supply = <&buck1_reg>;
	vdd_int-supply = <&buck3_reg>;
};

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 114 ++++++++++++++++++++++++++++++-----
 1 file changed, 100 insertions(+), 14 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 1a0effa..a2a3a47 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -62,6 +62,11 @@ enum exynos_ppmu_idx {
 	PPMU_END,
 };
 
+static const char *exynos_ppmu_clk_name[] = {
+	[PPMU_DMC0]	= "ppmudmc0",
+	[PPMU_DMC1]	= "ppmudmc1",
+};
+
 #define EX4210_LV_MAX	LV_2
 #define EX4x12_LV_MAX	LV_4
 #define EX4210_LV_NUM	(LV_2 + 1)
@@ -86,6 +91,7 @@ struct busfreq_data {
 	struct regulator *vdd_mif; /* Exynos4412/4212 only */
 	struct busfreq_opp_info curr_oppinfo;
 	struct exynos_ppmu ppmu[PPMU_END];
+	struct clk *clk_ppmu[PPMU_END];
 
 	struct notifier_block pm_notifier;
 	struct mutex lock;
@@ -722,8 +728,26 @@ static int exynos4_bus_get_dev_status(struct device *dev,
 static void exynos4_bus_exit(struct device *dev)
 {
 	struct busfreq_data *data = dev_get_drvdata(dev);
+	int i;
+
+	/*
+	 * Un-map memory map and disable regulator/clocks
+	 * to prevent power leakage.
+	 */
+	regulator_disable(data->vdd_int);
+	if (data->type == TYPE_BUSF_EXYNOS4x12)
+		regulator_disable(data->vdd_mif);
+
+	for (i = 0; i < PPMU_END; i++) {
+		if (data->clk_ppmu[i])
+			clk_disable_unprepare(data->clk_ppmu[i]);
+	}
 
-	devfreq_unregister_opp_notifier(dev, data->devfreq);
+	for (i = 0; i < PPMU_END; i++) {
+		if (data->ppmu[i].hw_base)
+			iounmap(data->ppmu[i].hw_base);
+
+	}
 }
 
 static struct devfreq_dev_profile exynos4_devfreq_profile = {
@@ -987,6 +1011,7 @@ static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
 {
 	struct device *dev = data->dev;
 	struct device_node *np = dev->of_node;
+	const char **clk_name = exynos_ppmu_clk_name;
 	int i, ret;
 
 	if (!np) {
@@ -1005,8 +1030,70 @@ static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
 		}
 	}
 
+	/*
+	 * Get PPMU's clocks to control them. But, if PPMU's clocks
+	 * is default 'pass' state, this driver don't need control
+	 * PPMU's clock.
+	 */
+	for (i = 0; i < PPMU_END; i++) {
+		data->clk_ppmu[i] = devm_clk_get(dev, clk_name[i]);
+		if (IS_ERR_OR_NULL(data->clk_ppmu[i])) {
+			dev_warn(dev, "Cannot get %s clock\n", clk_name[i]);
+			data->clk_ppmu[i] = NULL;
+		}
+
+		ret = clk_prepare_enable(data->clk_ppmu[i]);
+		if (ret < 0) {
+			dev_warn(dev, "Cannot enable %s clock\n", clk_name[i]);
+			data->clk_ppmu[i] = NULL;
+			goto err_clocks;
+		}
+	}
+
+	/* Get regulator to control voltage of int block */
+	data->vdd_int = devm_regulator_get(dev, "vdd_int");
+	if (IS_ERR(data->vdd_int)) {
+		dev_err(dev, "Failed to get the regulator of vdd_int\n");
+		ret = PTR_ERR(data->vdd_int);
+		goto err_clocks;
+	}
+	ret = regulator_enable(data->vdd_int);
+	if (ret < 0) {
+		dev_err(dev, "Failed to enable regulator of vdd_int\n");
+		goto err_clocks;
+	}
+
+	switch (data->type) {
+	case TYPE_BUSF_EXYNOS4210:
+		break;
+	case TYPE_BUSF_EXYNOS4x12:
+		/* Get regulator to control voltage of mif blk if Exynos4x12 */
+		data->vdd_mif = devm_regulator_get(dev, "vdd_mif");
+		if (IS_ERR(data->vdd_mif)) {
+			dev_err(dev, "Failed to get the regulator vdd_mif\n");
+			ret = PTR_ERR(data->vdd_mif);
+			goto err_regulator;
+		}
+		ret = regulator_enable(data->vdd_mif);
+		if (ret < 0) {
+			dev_err(dev, "Failed to enable regulator of vdd_mif\n");
+			goto err_regulator;
+		}
+		break;
+	default:
+		dev_err(dev, "Unknown device type : %d\n", data->type);
+		return -EINVAL;
+	};
+
 	return 0;
 
+err_regulator:
+	regulator_disable(data->vdd_int);
+err_clocks:
+	for (i = 0; i < PPMU_END; i++) {
+		if (data->clk_ppmu[i])
+			clk_disable_unprepare(data->clk_ppmu[i]);
+	}
 err_iomap:
 	for (i = 0; i < PPMU_END; i++) {
 		if (data->ppmu[i].hw_base)
@@ -1068,19 +1155,6 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	data->vdd_int = devm_regulator_get(dev, "vdd_int");
-	if (IS_ERR(data->vdd_int)) {
-		dev_err(dev, "Cannot get the regulator \"vdd_int\"\n");
-		return PTR_ERR(data->vdd_int);
-	}
-	if (data->type == TYPE_BUSF_EXYNOS4x12) {
-		data->vdd_mif = devm_regulator_get(dev, "vdd_mif");
-		if (IS_ERR(data->vdd_mif)) {
-			dev_err(dev, "Cannot get the regulator \"vdd_mif\"\n");
-			return PTR_ERR(data->vdd_mif);
-		}
-	}
-
 	rcu_read_lock();
 	opp = dev_pm_opp_find_freq_floor(dev,
 					 &exynos4_devfreq_profile.initial_freq);
@@ -1123,6 +1197,15 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	return 0;
 
 err_opp:
+	regulator_disable(data->vdd_int);
+	if (data->type == TYPE_BUSF_EXYNOS4x12)
+		regulator_disable(data->vdd_mif);
+
+	for (i = 0; i < PPMU_END; i++) {
+		if (data->clk_ppmu[i])
+			clk_disable_unprepare(data->clk_ppmu[i]);
+	}
+
 	for (i = 0; i < PPMU_END; i++) {
 		if (data->ppmu[i].hw_base)
 			iounmap(data->ppmu[i].hw_base);
@@ -1135,7 +1218,10 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
 {
 	struct busfreq_data *data = platform_get_drvdata(pdev);
 
+	/* Unregister all of notifier chain */
 	unregister_pm_notifier(&data->pm_notifier);
+	devfreq_unregister_opp_notifier(data->dev, data->devfreq);
+
 	devfreq_remove_device(data->devfreq);
 
 	return 0;
-- 
1.8.0

