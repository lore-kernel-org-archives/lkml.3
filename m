Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaCLLsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:48:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14998 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbaCLLsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:48:20 -0400
Date: Wed, 12 Mar 2014 20:48:01 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/4] devfreq: exynos4: Add ppmu's clock control and code clean
 about regulator control
In-reply-to: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Message-id: <1394624882-2989-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
DLP-Filter: Pass
X-AuditID: cbfee68e-b7f566d000002344-74-532049803ce1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkULfBUyHYYOEeJYvrX56zWpxtesNu
	0f0j2+LyrjlsFp97jzBa3G5cwWbx5sdZJovHK96yO3B4LN7zksmjb8sqRo/jN7YzeXzeJBfA
	EsVlk5Kak1mWWqRvl8CVsfrnO5aCRboVNyZsZmtgvK3SxcjJISFgIvGhfzMrhC0mceHeejYQ
	W0hgKaPEpe4CmJppu1cydzFyAcWnM0rcOboIymlkknjys5URpIpNQEti/4sbYN0iAuYSu5b+
	ZAMpYhZYyyjx6NMcsISwQIbEp6u/2UFsFgFVienTDoA18wq4SLStX8kGsU5O4sOeR2A1nAKu
	ElfXHGeEOMlF4s/FLSwgQyUE5rFLPG//ywoxSEDi2+RDQAkOoISsxKYDzBBzJCUOrrjBMoFR
	eAEjwypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwDA//e9Z3w7GmwesDzEmA42byCwlmpwP
	jJO8knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDI
	G+ywN3KTNFuwj6e15REGh/mRzYEfNM1u6k+qyZy7i2XBTc6XHmlLrwnpxryp5RVcaMI497Lw
	KiUxZ27Odo6Y2bJJslZVMR76O+18K658r03WTD/zV1yzfZ5+cm9H1nH+gCu/2BPVn1/j91Eq
	1uEpuVRYccO1Z35NduXdRxuT1pxzeezjp8RSnJFoqMVcVJwIAG9dLo6JAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jQd0GT4Vgg09XJS2uf3nOanG26Q27
	RfePbIvLu+awWXzuPcJocbtxBZvFmx9nmSwer3jL7sDhsXjPSyaPvi2rGD2O39jO5PF5k1wA
	S1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozVP9+xFCzSrbgxYTNbA+Nt
	lS5GTg4JAROJabtXMkPYYhIX7q1n62Lk4hASmM4ocefoImYIp5FJ4snPVkaQKjYBLYn9L26w
	gdgiAuYSu5b+BOtgFljLKPHo0xywhLBAhsSnq7/ZQWwWAVWJ6dMOgDXzCrhItK1fyQaxTk7i
	w55HYDWcAq4SV9ccB6sRAqr5c3ELywRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcx
	guPomfQOxlUNFocYBTgYlXh4F2rKBwuxJpYVV+YeYpTgYFYS4d1lqxAsxJuSWFmVWpQfX1Sa
	k1p8iDEZ6KqJzFKiyfnAGM8riTc0NjEzsjQyN7QwMjYnTVhJnPdgq3WgkEB6YklqdmpqQWoR
	zBYmDk6pBkanx1mCbimSMV7rJH6W+Kx+/27esykPLD6qHfzoscCHo3zXnTyDJQuyhfNs5rn8
	+nvi7ts5xh+2bc1+edtXt3K/0sE9R7nmr4/Ofqm/ZM2+F/8PLLWack41Ysb7Iymv9nHt3uwh
	++fu3523j231MmOXulxwhqUhSvFpw/2iyb8P7r36OCVlafBOViWW4oxEQy3mouJEADsG72Dn	AgAA
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
References: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
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
 drivers/devfreq/exynos/exynos4_bus.c | 107 ++++++++++++++++++++++++++++++-----
 1 file changed, 93 insertions(+), 14 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 16fb3cb..0c5b99e 100644
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
 
-	devfreq_unregister_opp_notifier(dev, data->devfreq);
+	/*
+	 * Un-map memory man and disable regulator/clocks
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
+
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
@@ -1005,8 +1030,67 @@ static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
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
+
+	/* Get regulators to control voltage of int/mif block */
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
+	case TYPE_BUSF_EXYNOS4x12:
+		data->vdd_mif = devm_regulator_get(dev, "vdd_mif");
+		if (IS_ERR(data->vdd_mif)) {
+			dev_err(dev, "Failed to get the regulator vdd_mif\n");
+			ret = PTR_ERR(data->vdd_mif);
+			goto err_clocks;
+		}
+		ret = regulator_enable(data->vdd_mif);
+		if (ret < 0) {
+			dev_err(dev, "Failed to enable regulator of vdd_mif\n");
+			goto err_clocks;
+		}
+		break;
+	case TYPE_BUSF_EXYNOS4210:
+	default:
+		dev_err(data->dev, "Unknown device type\n");
+		return -EINVAL;
+	};
+
 	return 0;
 
+err_clocks:
+	for (i = 0; i < PPMU_END; i++) {
+		if (data->clk_ppmu[i])
+			clk_disable_unprepare(data->clk_ppmu[i]);
+	}
 err_iomap:
 	for (i = 0; i < PPMU_END; i++) {
 		if (data->ppmu[i].hw_base)
@@ -1068,19 +1152,6 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
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
@@ -1133,6 +1204,11 @@ err_notifier_opp:
 	devfreq_remove_device(data->devfreq);
 err_opp:
 	for (i = 0; i < PPMU_END; i++) {
+		if (data->clk_ppmu[i])
+			clk_disable_unprepare(data->clk_ppmu[i]);
+	}
+
+	for (i = 0; i < PPMU_END; i++) {
 		if (data->ppmu[i].hw_base)
 			iounmap(data->ppmu[i].hw_base);
 	}
@@ -1144,7 +1220,10 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
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

