Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbaCNJa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:30:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64220 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbaCNJaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:30:16 -0400
X-AuditID: cbfee68f-b7f156d00000276c-53-5322cc26d023
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 3/8] devfreq: exynos4: Use common ppmu driver and get ppmu
 address from dt data
Date: Fri, 14 Mar 2014 18:30:03 +0900
Message-id: <1394789408-14648-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
References: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkWFftjFKwwblTghYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4Mr4vyum4Hx0xZxJjUwNjNc9uxg5OCQETCRO9AZ2MXICmWIS
	F+6tZ+ti5OIQEljKKHG/+T0zRMJE4nn7GajEIkaJqRNaWSCcRiaJM99OMIJUsQloSex/cYMN
	xBYRMJfYtfQnWAezwDMmiVv9fUwgCWGBZIlD22eCjWURUJV4ePkKmM0r4CqxeONTdoh1chIf
	9jwCszkF3CTeNk8DWyAEVNPXfYAJZKiEwEt2iae7LzJBDBKQ+Db5EAvEP7ISmw5AnS0pcXDF
	DZYJjMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYgTG1Ol/z/p3MN49YH2IMRlo3ERm
	KdHkfGBM5pXEGxqbGVmYmpgaG5lbmpEmrCTOe/9hUpCQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGRsWl9/9EXl46o1Vh0oG9eqUP1jmsUQ3SchYJ6aj2Y3yaOqPCijsqrW0yb+v+/l2HjdkZ
	jnTx7WTa+En5rfBCgWcfZT0OztL02NQZuM2VwZMr6OtnU9efPc8WfNt8qX2VeZn6k8Si29K1
	y8Vn7un3DPd2+WMQL2Dc7Pbm/B6/D0xzZeyuT/qboMRSnJFoqMVcVJwIAGXzhw6/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgK7aGaVgg+mv2Cw6en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4/+umILz0RVzJjUy
	NTBe9+xi5OSQEDCReN5+hg3CFpO4cG89kM3FISSwiFFi6oRWFginkUnizLcTjCBVbAJaEvtf
	3ADrEBEwl9i19CdYB7PAMyaJW/19TCAJYYFkiUPbZzKD2CwCqhIPL18Bs3kFXCUWb3zKDrFO
	TuLDnkdgNqeAm8Tb5mlgC4SAavq6DzBNYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93
	EyM4Zp9J7WBc2WBxiFGAg1GJh9fhsGKwEGtiWXFl7iFGCQ5mJRFehnlKwUK8KYmVValF+fFF
	pTmpxYcYk4GumsgsJZqcD0wneSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1I
	LYLZwsTBKdXAeKxl9s22i/smnZ7PVORyqfbin57fRuVlnQXTOq0M1h5R2fP+xYTAtdZ8xZNs
	rHjtUmMTYoVtVU+3fNTRZGUUXX1r9cmLgaJVnCmSUefOJ7CtCpuTGZu11/Eo758pVx7F+kkk
	ZGSqHO09K+FWIfbpofg+w98FJm1bhWJKTt3tvrLuzMLnk3Q8lViKMxINtZiLihMB3Rp8DR0D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use common ppmu driver of exynos_ppmu.c driver instead of individual
function related to PPC because PPMU is integrated module with both PPC and
Bus event generator. When using PPMU to get bus performance read/write event,
exynos4_bus.c don't need to consider memory type.

And get ppmu address from dt data by using dt helper function (of_iomap).
And then this patch delete duplicate defined structure/enum.

For example,
busfreq@106A0000 {
	compatible = "samsung,exynos4x12-busfreq";
	reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
	regs-name = "PPMU_DMC0", "PPMU_DMC1";
};

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/Makefile      |   2 +-
 drivers/devfreq/exynos/exynos4_bus.c | 234 +++++++++++++++++++----------------
 2 files changed, 129 insertions(+), 107 deletions(-)

diff --git a/drivers/devfreq/exynos/Makefile b/drivers/devfreq/exynos/Makefile
index bfaaf5b..49bc917 100644
--- a/drivers/devfreq/exynos/Makefile
+++ b/drivers/devfreq/exynos/Makefile
@@ -1,3 +1,3 @@
 # Exynos DEVFREQ Drivers
-obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos4_bus.o
+obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos_ppmu.o exynos4_bus.o
 obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos_ppmu.o exynos5_bus.o
diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 2d2b44b..8ccbb31 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -24,17 +24,19 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/module.h>
 
+#include <mach/map.h>
+
+#include "exynos_ppmu.h"
+#include "exynos4_bus.h"
+
 /* Exynos4 ASV has been in the mailing list, but not upstreamed, yet. */
 #ifdef CONFIG_EXYNOS_ASV
 extern unsigned int exynos_result_of_asv;
 #endif
 
-#include <mach/map.h>
-
-#include "exynos4_bus.h"
-
 #define MAX_SAFEVOLT	1200000 /* 1.2V */
 
 enum exynos4_busf_type {
@@ -45,22 +47,6 @@ enum exynos4_busf_type {
 /* Assume that the bus is saturated if the utilization is 40% */
 #define BUS_SATURATION_RATIO	40
 
-enum ppmu_counter {
-	PPMU_PMNCNT0 = 0,
-	PPMU_PMCCNT1,
-	PPMU_PMNCNT2,
-	PPMU_PMNCNT3,
-	PPMU_PMNCNT_MAX,
-};
-struct exynos4_ppmu {
-	void __iomem *hw_base;
-	unsigned int ccnt;
-	unsigned int event;
-	unsigned int count[PPMU_PMNCNT_MAX];
-	bool ccnt_overflow;
-	bool count_overflow[PPMU_PMNCNT_MAX];
-};
-
 enum busclk_level_idx {
 	LV_0 = 0,
 	LV_1,
@@ -69,6 +55,13 @@ enum busclk_level_idx {
 	LV_4,
 	_LV_END
 };
+
+enum exynos_ppmu_idx {
+	PPMU_DMC0,
+	PPMU_DMC1,
+	PPMU_END,
+};
+
 #define EX4210_LV_MAX	LV_2
 #define EX4x12_LV_MAX	LV_4
 #define EX4210_LV_NUM	(LV_2 + 1)
@@ -92,7 +85,7 @@ struct busfreq_data {
 	struct regulator *vdd_int;
 	struct regulator *vdd_mif; /* Exynos4412/4212 only */
 	struct busfreq_opp_info curr_oppinfo;
-	struct exynos4_ppmu dmc[2];
+	struct exynos_ppmu ppmu[PPMU_END];
 
 	struct notifier_block pm_notifier;
 	struct mutex lock;
@@ -102,12 +95,6 @@ struct busfreq_data {
 	unsigned int top_divtable[_LV_END];
 };
 
-struct bus_opp_table {
-	unsigned int idx;
-	unsigned long clk;
-	unsigned long volt;
-};
-
 /* 4210 controls clock of mif and voltage of int */
 static struct bus_opp_table exynos4210_busclk_table[] = {
 	{LV_0, 400000, 1150000},
@@ -525,27 +512,22 @@ static int exynos4x12_set_busclk(struct busfreq_data *data,
 	return 0;
 }
 
-
 static void busfreq_mon_reset(struct busfreq_data *data)
 {
 	unsigned int i;
 
-	for (i = 0; i < 2; i++) {
-		void __iomem *ppmu_base = data->dmc[i].hw_base;
+	for (i = 0; i < PPMU_END; i++) {
+		void __iomem *ppmu_base = data->ppmu[i].hw_base;
 
-		/* Reset PPMU */
-		__raw_writel(0x8000000f, ppmu_base + 0xf010);
-		__raw_writel(0x8000000f, ppmu_base + 0xf050);
-		__raw_writel(0x6, ppmu_base + 0xf000);
-		__raw_writel(0x0, ppmu_base + 0xf100);
+		/* Reset the performance and cycle counters */
+		exynos_ppmu_reset(ppmu_base);
 
-		/* Set PPMU Event */
-		data->dmc[i].event = 0x6;
-		__raw_writel(((data->dmc[i].event << 12) | 0x1),
-			     ppmu_base + 0xfc);
+		/* Setup count registers to monitor read/write transactions */
+		data->ppmu[i].event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
+		exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT3,
+					data->ppmu[i].event[PPMU_PMNCNT3]);
 
-		/* Start PPMU */
-		__raw_writel(0x1, ppmu_base + 0xf000);
+		exynos_ppmu_start(ppmu_base);
 	}
 }
 
@@ -553,23 +535,20 @@ static void exynos4_read_ppmu(struct busfreq_data *data)
 {
 	int i, j;
 
-	for (i = 0; i < 2; i++) {
-		void __iomem *ppmu_base = data->dmc[i].hw_base;
-		u32 overflow;
+	for (i = 0; i < PPMU_END; i++) {
+		void __iomem *ppmu_base = data->ppmu[i].hw_base;
 
-		/* Stop PPMU */
-		__raw_writel(0x0, ppmu_base + 0xf000);
+		exynos_ppmu_stop(ppmu_base);
 
 		/* Update local data from PPMU */
-		overflow = __raw_readl(ppmu_base + 0xf050);
-
-		data->dmc[i].ccnt = __raw_readl(ppmu_base + 0xf100);
-		data->dmc[i].ccnt_overflow = overflow & (1 << 31);
-
-		for (j = 0; j < PPMU_PMNCNT_MAX; j++) {
-			data->dmc[i].count[j] = __raw_readl(
-					ppmu_base + (0xf110 + (0x10 * j)));
-			data->dmc[i].count_overflow[j] = overflow & (1 << j);
+		data->ppmu[i].ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
+
+		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
+			if (data->ppmu[i].event[j] == 0)
+				data->ppmu[i].count[j] = 0;
+			else
+				data->ppmu[i].count[j] =
+					exynos_ppmu_read(ppmu_base, j);
 		}
 	}
 
@@ -699,66 +678,42 @@ out:
 	return err;
 }
 
-static int exynos4_get_busier_dmc(struct busfreq_data *data)
+static int exynos4_get_busier_ppmu(struct busfreq_data *data)
 {
-	u64 p0 = data->dmc[0].count[0];
-	u64 p1 = data->dmc[1].count[0];
-
-	p0 *= data->dmc[1].ccnt;
-	p1 *= data->dmc[0].ccnt;
-
-	if (data->dmc[1].ccnt == 0)
-		return 0;
+	int i, j;
+	int busy = 0;
+	unsigned int temp = 0;
+
+	for (i = 0; i < PPMU_END; i++) {
+		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
+			if (data->ppmu[i].count[j] > temp) {
+				temp = data->ppmu[i].count[j];
+				busy = i;
+			}
+		}
+	}
 
-	if (p0 > p1)
-		return 0;
-	return 1;
+	return busy;
 }
 
 static int exynos4_bus_get_dev_status(struct device *dev,
 				      struct devfreq_dev_status *stat)
 {
 	struct busfreq_data *data = dev_get_drvdata(dev);
-	int busier_dmc;
-	int cycles_x2 = 2; /* 2 x cycles */
-	void __iomem *addr;
-	u32 timing;
-	u32 memctrl;
+	int busier;
 
 	exynos4_read_ppmu(data);
-	busier_dmc = exynos4_get_busier_dmc(data);
+	busier = exynos4_get_busier_ppmu(data);
 	stat->current_frequency = data->curr_oppinfo.rate;
 
-	if (busier_dmc)
-		addr = S5P_VA_DMC1;
-	else
-		addr = S5P_VA_DMC0;
-
-	memctrl = __raw_readl(addr + 0x04); /* one of DDR2/3/LPDDR2 */
-	timing = __raw_readl(addr + 0x38); /* CL or WL/RL values */
-
-	switch ((memctrl >> 8) & 0xf) {
-	case 0x4: /* DDR2 */
-		cycles_x2 = ((timing >> 16) & 0xf) * 2;
-		break;
-	case 0x5: /* LPDDR2 */
-	case 0x6: /* DDR3 */
-		cycles_x2 = ((timing >> 8) & 0xf) + ((timing >> 0) & 0xf);
-		break;
-	default:
-		pr_err("%s: Unknown Memory Type(%d).\n", __func__,
-		       (memctrl >> 8) & 0xf);
-		return -EINVAL;
-	}
-
 	/* Number of cycles spent on memory access */
-	stat->busy_time = data->dmc[busier_dmc].count[0] / 2 * (cycles_x2 + 2);
+	stat->busy_time = data->ppmu[busier].count[PPMU_PMNCNT3];
 	stat->busy_time *= 100 / BUS_SATURATION_RATIO;
-	stat->total_time = data->dmc[busier_dmc].ccnt;
+	stat->total_time = data->ppmu[busier].ccnt;
 
 	/* If the counters have overflown, retry */
-	if (data->dmc[busier_dmc].ccnt_overflow ||
-	    data->dmc[busier_dmc].count_overflow[0])
+	if (data->ppmu[busier].ccnt_overflow ||
+	    data->ppmu[busier].count_overflow[0])
 		return -EAGAIN;
 
 	return 0;
@@ -766,6 +721,13 @@ static int exynos4_bus_get_dev_status(struct device *dev,
 
 static void exynos4_bus_exit(struct device *dev)
 {
+	struct busfreq_data *data = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < PPMU_END; i++) {
+		if (data->ppmu[i].hw_base)
+			iounmap(data->ppmu[i].hw_base);
+	}
 }
 
 static struct devfreq_dev_profile exynos4_devfreq_profile = {
@@ -1025,6 +987,39 @@ static struct of_device_id exynos4_busfreq_id_match[] = {
 	},
 };
 
+static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
+{
+	struct device *dev = data->dev;
+	struct device_node *np = dev->of_node;
+	int i, ret;
+
+	if (!np) {
+		dev_err(dev, "Failed to find devicetree node\n");
+		return -EINVAL;
+	}
+
+	/* Maps the memory mapped IO to control PPMU register */
+	for (i = 0; i < PPMU_END; i++) {
+		data->ppmu[i].hw_base = of_iomap(np, i);
+		if (IS_ERR_OR_NULL(data->ppmu[i].hw_base)) {
+			dev_err(dev, "Failed to map memory region\n");
+			data->ppmu[i].hw_base = NULL;
+			ret = -EINVAL;
+			goto err_iomap;
+		}
+	}
+
+	return 0;
+
+err_iomap:
+	for (i = 0; i < PPMU_END; i++) {
+		if (data->ppmu[i].hw_base)
+			iounmap(data->ppmu[i].hw_base);
+	}
+
+	return ret;
+}
+
 static int exynos4_busfreq_get_driver_data(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1042,7 +1037,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	struct busfreq_data *data;
 	struct dev_pm_opp *opp;
 	struct device *dev = &pdev->dev;
-	int err = 0;
+	int i, err = 0;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(struct busfreq_data), GFP_KERNEL);
 	if (data == NULL) {
@@ -1051,10 +1046,16 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	}
 
 	data->type = exynos4_busfreq_get_driver_data(pdev);
-	data->dmc[0].hw_base = S5P_VA_DMC0;
-	data->dmc[1].hw_base = S5P_VA_DMC1;
 	data->pm_notifier.notifier_call = exynos4_busfreq_pm_notifier_event;
 	data->dev = dev;
+
+	/* Parse dt data to get register/regulator */
+	err = exynos4_busfreq_parse_dt(data);
+	if (err < 0) {
+		dev_err(dev, "Failed to parse dt for resource\n");
+		return err;
+	}
+
 	mutex_init(&data->lock);
 
 	switch (data->type) {
@@ -1102,12 +1103,20 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	busfreq_mon_reset(data);
-
+	/* Reigster Exynos4's devfreq instance with 'simple_ondemand' gov */
 	data->devfreq = devfreq_add_device(dev, &exynos4_devfreq_profile,
 					   "simple_ondemand", NULL);
-	if (IS_ERR(data->devfreq))
-		return PTR_ERR(data->devfreq);
+	if (IS_ERR(data->devfreq)) {
+		dev_err(dev, "Failed to add devfreq device\n");
+		err = PTR_ERR(data->devfreq);
+		goto err_devfreq;
+	}
+
+	/*
+	 * Start PPMU(Performance Profiling Monitoring Unit) to check
+	 * utilization of each IP in the Exynos4 SoC.
+	 */
+	busfreq_mon_reset(data);
 
 	/* Register opp_notifier for Exynos4 busfreq */
 	err = devfreq_register_opp_notifier(dev, data->devfreq);
@@ -1128,9 +1137,22 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 err_notifier_pm:
 	devfreq_unregister_opp_notifier(dev, data->devfreq);
 err_notifier_opp:
+	/*
+	 * The devfreq_remove_device() would execute finally devfreq->profile
+	 * ->exit(). To avoid duplicate resource free operation, return directly
+	 * before executing resource free below 'err_devfreq' goto statement.
+	 */
 	devfreq_remove_device(data->devfreq);
 
 	return err;
+
+err_devfreq:
+	for (i = 0; i < PPMU_END; i++) {
+		if (data->ppmu[i].hw_base)
+			iounmap(data->ppmu[i].hw_base);
+	}
+
+	return err;
 }
 
 static int exynos4_busfreq_remove(struct platform_device *pdev)
-- 
1.8.0

