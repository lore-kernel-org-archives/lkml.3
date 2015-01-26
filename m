Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbbAZEQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:16:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40433 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbbAZEQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:16:40 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-e8-54c5bfa5901a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        sangbae90.lee@samsung.com, inki.dae@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v10 2/7] devfreq: event: Add exynos-ppmu devfreq-event driver
Date: Mon, 26 Jan 2015 13:16:28 +0900
Message-id: <1422245793-8552-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
References: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWyRsSkUHfp/qMhBosWqFg8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtjn86yGKxatcfRgdBjzXz1jB67Jx1l91j8Z6XTB6bVnWyeWxeUu/R
	t2UVo8fnTXIB7FFcNimpOZllqUX6dglcGSs3aRdsLai48W05YwPj6pguRk4OCQETiS03fzND
	2GISF+6tZ+ti5OIQEljKKHH15mxWmKLH7dsYIRLTGSUafv9mgnCamCReP5zDCFLFJqAlsf/F
	DTYQW0RAT6Lz2B52kCJmgenMEpMXTAQbJSzgK7F/4y2gbg4OFgFVibU9mSBhXgEXiSn7z0Nt
	U5BYtnwmmM0p4CoxseE5I0i5EFDN9+9cICMlBD6yS5x6+hLsbBYBAYlvkw+xgNRICMhKbDoA
	9Y2kxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREYWaf/PZuwg/HeAetD
	jAIcjEo8vA3NR0OEWBPLiitzDzGaAm2YyCwlmpwPjN+8knhDYzMjC1MTU2Mjc0szJXHe11I/
	g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwBvKzXprIaVztlKq2xODvvKI6C1mF4Nj+xRFL
	5lxbpr4jzn+ailP97WO+y1dtXH9pGeea3In38+vT9rOtFItYP/+TbhNj+najzbrfVD7sEqu5
	Zpv8uX0Ht/TRJYJ7sxXZbm2qT5Jhtli26maTx2e3cF/Wu9Vqs07++M09wWvK/Y6baXbnRBfM
	VmIpzkg01GIuKk4EAIF3TEunAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jQd2l+4+GGHyfK2bxeM1iJouNM9az
	Wlz/8pzVYtL9CSwWr18YWvQ/fs1scbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVr3HmG3OP7pIIvFql1/GB0EPdbMW8PosXPWXXaPxXteMnlsWtXJ5rF5Sb1H
	35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAH2gpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcxYuUm7YGtB
	xY1vyxkbGFfHdDFyckgImEg8bt/GCGGLSVy4t56ti5GLQ0hgOqNEw+/fTBBOE5PE64dzwKrY
	BLQk9r+4wQZiiwjoSXQe28MOUsQsMJ1ZYvKCiawgCWEBX4n9G28BdXNwsAioSqztyQQJ8wq4
	SEzZf54VYpuCxLLlM8FsTgFXiYkNzxlByoWAar5/55rAyLuAkWEVo2hqQXJBcVJ6rpFecWJu
	cWleul5yfu4mRnDcPpPewbiqweIQowAHoxIPr0bj0RAh1sSy4srcQ4wSHMxKIrzlU4BCvCmJ
	lVWpRfnxRaU5qcWHGE2BbprILCWanA9MKXkl8YbGJmZGlkbmhhZGxuZK4rxK9m0hQgLpiSWp
	2ampBalFMH1MHJxSDYwTjpdMKjUof1/5+4FPbNpB/nlvb9s9NtE03H+Ir/d1xbviXOV3HXO7
	arewq1ZISKSKSD89vfXrJcm0q/lv/JNObX4jqLzh7oXmMu79UwT+hea/y3xofelT97uSD4H3
	3BMnWWX/2rlRiGHWr8R/U/ab/1hrycPS3N23TO/x/Ayvt3tiX18r4xZQYinOSDTUYi4qTgQA
	8/MTzPECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds exynos-ppmu devfreq-event driver to get performance data
of each IP for Samsung Exynos SoC. These event from Exynos PPMU provide
useful information about the behavior of the SoC that you can use when
analyzing system performance, and made visible and can be counted using
logic in each IP.

This patch is based on existing drivers/devfreq/exynos/exynos-ppmu.c

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/devfreq/event/Kconfig       |   9 +
 drivers/devfreq/event/Makefile      |   1 +
 drivers/devfreq/event/exynos-ppmu.c | 374 ++++++++++++++++++++++++++++++++++++
 drivers/devfreq/event/exynos-ppmu.h |  93 +++++++++
 4 files changed, 477 insertions(+)
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c
 create mode 100644 drivers/devfreq/event/exynos-ppmu.h

diff --git a/drivers/devfreq/event/Kconfig b/drivers/devfreq/event/Kconfig
index 1ced42c..a11720a 100644
--- a/drivers/devfreq/event/Kconfig
+++ b/drivers/devfreq/event/Kconfig
@@ -13,4 +13,13 @@ menuconfig PM_DEVFREQ_EVENT
 
 if PM_DEVFREQ_EVENT
 
+config DEVFREQ_EVENT_EXYNOS_PPMU
+	bool "EXYNOS PPMU (Platform Performance Monitoring Unit) DEVFREQ event Driver"
+	depends on ARCH_EXYNOS
+	select PM_OPP
+	help
+	  This add the devfreq-event driver for Exynos SoC. It provides PPMU
+	  (Platform Performance Monitoring Unit) counters to estimate the
+	  utilization of each module.
+
 endif # PM_DEVFREQ_EVENT
diff --git a/drivers/devfreq/event/Makefile b/drivers/devfreq/event/Makefile
index dc56005..be146ea 100644
--- a/drivers/devfreq/event/Makefile
+++ b/drivers/devfreq/event/Makefile
@@ -1 +1,2 @@
 # Exynos DEVFREQ Event Drivers
+obj-$(CONFIG_DEVFREQ_EVENT_EXYNOS_PPMU) += exynos-ppmu.o
diff --git a/drivers/devfreq/event/exynos-ppmu.c b/drivers/devfreq/event/exynos-ppmu.c
new file mode 100644
index 0000000..135be0a
--- /dev/null
+++ b/drivers/devfreq/event/exynos-ppmu.c
@@ -0,0 +1,374 @@
+/*
+ * exynos_ppmu.c - EXYNOS PPMU (Platform Performance Monitoring Unit) support
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author : Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This driver is based on drivers/devfreq/exynos/exynos_ppmu.c
+ */
+
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/suspend.h>
+#include <linux/devfreq-event.h>
+
+#include "exynos-ppmu.h"
+
+struct exynos_ppmu_data {
+	void __iomem *base;
+	struct clk *clk;
+};
+
+struct exynos_ppmu {
+	struct devfreq_event_dev **edev;
+	struct devfreq_event_desc *desc;
+	unsigned int num_events;
+
+	struct device *dev;
+	struct mutex lock;
+
+	struct exynos_ppmu_data ppmu;
+};
+
+#define PPMU_EVENT(name)			\
+	{ "ppmu-event0-"#name, PPMU_PMNCNT0 },	\
+	{ "ppmu-event1-"#name, PPMU_PMNCNT1 },	\
+	{ "ppmu-event2-"#name, PPMU_PMNCNT2 },	\
+	{ "ppmu-event3-"#name, PPMU_PMNCNT3 }
+
+struct __exynos_ppmu_events {
+	char *name;
+	int id;
+} ppmu_events[] = {
+	/* For Exynos3250, Exynos4 and Exynos5260 */
+	PPMU_EVENT(g3d),
+	PPMU_EVENT(fsys),
+
+	/* For Exynos4 SoCs and Exynos3250 */
+	PPMU_EVENT(dmc0),
+	PPMU_EVENT(dmc1),
+	PPMU_EVENT(cpu),
+	PPMU_EVENT(rightbus),
+	PPMU_EVENT(leftbus),
+	PPMU_EVENT(lcd0),
+	PPMU_EVENT(camif),
+
+	/* Only for Exynos3250 and Exynos5260 */
+	PPMU_EVENT(mfc),
+
+	/* Only for Exynos4 SoCs */
+	PPMU_EVENT(mfc-left),
+	PPMU_EVENT(mfc-right),
+
+	/* Only for Exynos5260 SoCs */
+	PPMU_EVENT(drex0-s0),
+	PPMU_EVENT(drex0-s1),
+	PPMU_EVENT(drex1-s0),
+	PPMU_EVENT(drex1-s1),
+	PPMU_EVENT(eagle),
+	PPMU_EVENT(kfc),
+	PPMU_EVENT(isp),
+	PPMU_EVENT(fimc),
+	PPMU_EVENT(gscl),
+	PPMU_EVENT(mscl),
+	PPMU_EVENT(fimd0x),
+	PPMU_EVENT(fimd1x),
+	{ /* sentinel */ },
+};
+
+static int exynos_ppmu_find_ppmu_id(struct devfreq_event_dev *edev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ppmu_events); i++)
+		if (!strcmp(edev->desc->name, ppmu_events[i].name))
+			return ppmu_events[i].id;
+
+	return -EINVAL;
+}
+
+static int exynos_ppmu_disable(struct devfreq_event_dev *edev)
+{
+	struct exynos_ppmu *info = devfreq_event_get_drvdata(edev);
+	u32 pmnc;
+
+	/* Disable all counters */
+	__raw_writel(PPMU_CCNT_MASK |
+		     PPMU_PMCNT0_MASK |
+		     PPMU_PMCNT1_MASK |
+		     PPMU_PMCNT2_MASK |
+		     PPMU_PMCNT3_MASK,
+		     info->ppmu.base + PPMU_CNTENC);
+
+	/* Disable PPMU */
+	pmnc = __raw_readl(info->ppmu.base + PPMU_PMNC);
+	pmnc &= ~PPMU_PMNC_ENABLE_MASK;
+	__raw_writel(pmnc, info->ppmu.base + PPMU_PMNC);
+
+	return 0;
+}
+
+static int exynos_ppmu_set_event(struct devfreq_event_dev *edev)
+{
+	struct exynos_ppmu *info = devfreq_event_get_drvdata(edev);
+	int id = exynos_ppmu_find_ppmu_id(edev);
+	u32 pmnc, cntens;
+
+	if (id < 0)
+		return id;
+
+	/* Enable specific counter */
+	cntens = __raw_readl(info->ppmu.base + PPMU_CNTENS);
+	cntens |= (PPMU_CCNT_MASK | (PPMU_ENABLE << id));
+	__raw_writel(cntens, info->ppmu.base + PPMU_CNTENS);
+
+	/* Set the event of Read/Write data count  */
+	__raw_writel(PPMU_RO_DATA_CNT | PPMU_WO_DATA_CNT,
+			info->ppmu.base + PPMU_BEVTxSEL(id));
+
+	/* Reset cycle counter/performance counter and enable PPMU */
+	pmnc = __raw_readl(info->ppmu.base + PPMU_PMNC);
+	pmnc &= ~(PPMU_PMNC_ENABLE_MASK
+			| PPMU_PMNC_COUNTER_RESET_MASK
+			| PPMU_PMNC_CC_RESET_MASK);
+	pmnc |= (PPMU_ENABLE << PPMU_PMNC_ENABLE_SHIFT);
+	pmnc |= (PPMU_ENABLE << PPMU_PMNC_COUNTER_RESET_SHIFT);
+	pmnc |= (PPMU_ENABLE << PPMU_PMNC_CC_RESET_SHIFT);
+	__raw_writel(pmnc, info->ppmu.base + PPMU_PMNC);
+
+	return 0;
+}
+
+static int exynos_ppmu_get_event(struct devfreq_event_dev *edev,
+				struct devfreq_event_data *edata)
+{
+	struct exynos_ppmu *info = devfreq_event_get_drvdata(edev);
+	int id = exynos_ppmu_find_ppmu_id(edev);
+	u32 pmnc, cntenc;
+
+	if (id < 0)
+		return -EINVAL;
+
+	/* Disable PPMU */
+	pmnc = __raw_readl(info->ppmu.base + PPMU_PMNC);
+	pmnc &= ~PPMU_PMNC_ENABLE_MASK;
+	__raw_writel(pmnc, info->ppmu.base + PPMU_PMNC);
+
+	/* Read cycle count */
+	edata->total_count = __raw_readl(info->ppmu.base + PPMU_CCNT);
+
+	/* Read performance count */
+	switch (id) {
+	case PPMU_PMNCNT0:
+	case PPMU_PMNCNT1:
+	case PPMU_PMNCNT2:
+		edata->load_count
+			= __raw_readl(info->ppmu.base + PPMU_PMNCT(id));
+		break;
+	case PPMU_PMNCNT3:
+		edata->load_count =
+			((__raw_readl(info->ppmu.base + PPMU_PMCNT3_HIGH) << 8)
+			| __raw_readl(info->ppmu.base + PPMU_PMCNT3_LOW));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Disable specific counter */
+	cntenc = __raw_readl(info->ppmu.base + PPMU_CNTENC);
+	cntenc |= (PPMU_CCNT_MASK | (PPMU_ENABLE << id));
+	__raw_writel(cntenc, info->ppmu.base + PPMU_CNTENC);
+
+	dev_dbg(&edev->dev, "%s (event: %ld/%ld)\n", edev->desc->name,
+					edata->load_count, edata->total_count);
+
+	return 0;
+}
+
+static struct devfreq_event_ops exynos_ppmu_ops = {
+	.disable = exynos_ppmu_disable,
+	.set_event = exynos_ppmu_set_event,
+	.get_event = exynos_ppmu_get_event,
+};
+
+static int of_get_devfreq_events(struct device_node *np,
+				 struct exynos_ppmu *info)
+{
+	struct devfreq_event_desc *desc;
+	struct device *dev = info->dev;
+	struct device_node *events_np, *node;
+	int i, j, count;
+
+	events_np = of_get_child_by_name(np, "events");
+	if (!events_np) {
+		dev_err(dev,
+			"failed to get child node of devfreq-event devices\n");
+		return -EINVAL;
+	}
+
+	count = of_get_child_count(events_np);
+	desc = devm_kzalloc(dev, sizeof(*desc) * count, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+	info->num_events = count;
+
+	j = 0;
+	for_each_child_of_node(events_np, node) {
+		for (i = 0; i < ARRAY_SIZE(ppmu_events); i++) {
+			if (!ppmu_events[i].name)
+				continue;
+
+			if (!of_node_cmp(node->name, ppmu_events[i].name))
+				break;
+		}
+
+		if (i == ARRAY_SIZE(ppmu_events)) {
+			dev_warn(dev,
+				"don't know how to configure events : %s\n",
+				node->name);
+			continue;
+		}
+
+		desc[j].ops = &exynos_ppmu_ops;
+		desc[j].driver_data = info;
+
+		of_property_read_string(node, "event-name", &desc[j].name);
+
+		j++;
+
+		of_node_put(node);
+	}
+	info->desc = desc;
+
+	of_node_put(events_np);
+
+	return 0;
+}
+
+static int exynos_ppmu_parse_dt(struct exynos_ppmu *info)
+{
+	struct device *dev = info->dev;
+	struct device_node *np = dev->of_node;
+	int ret = 0;
+
+	if (!np) {
+		dev_err(dev, "failed to find devicetree node\n");
+		return -EINVAL;
+	}
+
+	/* Maps the memory mapped IO to control PPMU register */
+	info->ppmu.base = of_iomap(np, 0);
+	if (IS_ERR_OR_NULL(info->ppmu.base)) {
+		dev_err(dev, "failed to map memory region\n");
+		return -ENOMEM;
+	}
+
+	info->ppmu.clk = devm_clk_get(dev, "ppmu");
+	if (IS_ERR(info->ppmu.clk)) {
+		info->ppmu.clk = NULL;
+		dev_warn(dev, "cannot get PPMU clock\n");
+	}
+
+	ret = of_get_devfreq_events(np, info);
+	if (ret < 0) {
+		dev_err(dev, "failed to parse exynos ppmu dt node\n");
+		goto err;
+	}
+
+	return 0;
+
+err:
+	iounmap(info->ppmu.base);
+
+	return ret;
+}
+
+static int exynos_ppmu_probe(struct platform_device *pdev)
+{
+	struct exynos_ppmu *info;
+	struct devfreq_event_dev **edev;
+	struct devfreq_event_desc *desc;
+	int i, ret = 0, size;
+
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	mutex_init(&info->lock);
+	info->dev = &pdev->dev;
+
+	/* Parse dt data to get resource */
+	ret = exynos_ppmu_parse_dt(info);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"failed to parse devicetree for resource\n");
+		return ret;
+	}
+	desc = info->desc;
+
+	size = sizeof(struct devfreq_event_dev *) * info->num_events;
+	info->edev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!info->edev) {
+		dev_err(&pdev->dev,
+			"failed to allocate memory devfreq-event devices\n");
+		return -ENOMEM;
+	}
+	edev = info->edev;
+	platform_set_drvdata(pdev, info);
+
+	for (i = 0; i < info->num_events; i++) {
+		edev[i] = devm_devfreq_event_add_edev(&pdev->dev, &desc[i]);
+		if (IS_ERR(edev)) {
+			ret = PTR_ERR(edev);
+			dev_err(&pdev->dev,
+				"failed to add devfreq-event device\n");
+			goto err;
+		}
+	}
+
+	clk_prepare_enable(info->ppmu.clk);
+
+	return 0;
+err:
+	iounmap(info->ppmu.base);
+
+	return ret;
+}
+
+static int exynos_ppmu_remove(struct platform_device *pdev)
+{
+	struct exynos_ppmu *info = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(info->ppmu.clk);
+	iounmap(info->ppmu.base);
+
+	return 0;
+}
+
+static struct of_device_id exynos_ppmu_id_match[] = {
+	{ .compatible = "samsung,exynos-ppmu", },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver exynos_ppmu_driver = {
+	.probe	= exynos_ppmu_probe,
+	.remove	= exynos_ppmu_remove,
+	.driver = {
+		.name	= "exynos-ppmu",
+		.of_match_table = exynos_ppmu_id_match,
+	},
+};
+module_platform_driver(exynos_ppmu_driver);
+
+MODULE_DESCRIPTION("Exynos PPMU(Platform Performance Monitoring Unit) driver");
+MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/devfreq/event/exynos-ppmu.h b/drivers/devfreq/event/exynos-ppmu.h
new file mode 100644
index 0000000..4e831d4
--- /dev/null
+++ b/drivers/devfreq/event/exynos-ppmu.h
@@ -0,0 +1,93 @@
+/*
+ * exynos_ppmu.h - EXYNOS PPMU header file
+ *
+ * Copyright (c) 2015 Samsung Electronics Co., Ltd.
+ * Author : Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __EXYNOS_PPMU_H__
+#define __EXYNOS_PPMU_H__
+
+enum ppmu_state {
+	PPMU_DISABLE = 0,
+	PPMU_ENABLE,
+};
+
+enum ppmu_counter {
+	PPMU_PMNCNT0 = 0,
+	PPMU_PMNCNT1,
+	PPMU_PMNCNT2,
+	PPMU_PMNCNT3,
+
+	PPMU_PMNCNT_MAX,
+};
+
+enum ppmu_event_type {
+	PPMU_RO_BUSY_CYCLE_CNT	= 0x0,
+	PPMU_WO_BUSY_CYCLE_CNT	= 0x1,
+	PPMU_RW_BUSY_CYCLE_CNT	= 0x2,
+	PPMU_RO_REQUEST_CNT	= 0x3,
+	PPMU_WO_REQUEST_CNT	= 0x4,
+	PPMU_RO_DATA_CNT	= 0x5,
+	PPMU_WO_DATA_CNT	= 0x6,
+	PPMU_RO_LATENCY		= 0x12,
+	PPMU_WO_LATENCY		= 0x16,
+};
+
+enum ppmu_reg {
+	/* PPC control register */
+	PPMU_PMNC		= 0x00,
+	PPMU_CNTENS		= 0x10,
+	PPMU_CNTENC		= 0x20,
+	PPMU_INTENS		= 0x30,
+	PPMU_INTENC		= 0x40,
+	PPMU_FLAG		= 0x50,
+
+	/* Cycle Counter and Performance Event Counter Register */
+	PPMU_CCNT		= 0x100,
+	PPMU_PMCNT0		= 0x110,
+	PPMU_PMCNT1		= 0x120,
+	PPMU_PMCNT2		= 0x130,
+	PPMU_PMCNT3_HIGH	= 0x140,
+	PPMU_PMCNT3_LOW		= 0x150,
+
+	/* Bus Event Generator */
+	PPMU_BEVT0SEL		= 0x1000,
+	PPMU_BEVT1SEL		= 0x1100,
+	PPMU_BEVT2SEL		= 0x1200,
+	PPMU_BEVT3SEL		= 0x1300,
+	PPMU_COUNTER_RESET	= 0x1810,
+	PPMU_READ_OVERFLOW_CNT	= 0x1810,
+	PPMU_READ_UNDERFLOW_CNT	= 0x1814,
+	PPMU_WRITE_OVERFLOW_CNT	= 0x1850,
+	PPMU_WRITE_UNDERFLOW_CNT = 0x1854,
+	PPMU_READ_PENDING_CNT	= 0x1880,
+	PPMU_WRITE_PENDING_CNT	= 0x1884
+};
+
+/* PMNC register */
+#define PPMU_PMNC_CC_RESET_SHIFT	2
+#define PPMU_PMNC_COUNTER_RESET_SHIFT	1
+#define PPMU_PMNC_ENABLE_SHIFT		0
+#define PPMU_PMNC_START_MODE_MASK	BIT(16)
+#define PPMU_PMNC_CC_DIVIDER_MASK	BIT(3)
+#define PPMU_PMNC_CC_RESET_MASK		BIT(2)
+#define PPMU_PMNC_COUNTER_RESET_MASK	BIT(1)
+#define PPMU_PMNC_ENABLE_MASK		BIT(0)
+
+/* CNTENS/CNTENC/INTENS/INTENC/FLAG register */
+#define PPMU_CCNT_MASK			BIT(31)
+#define PPMU_PMCNT3_MASK		BIT(3)
+#define PPMU_PMCNT2_MASK		BIT(2)
+#define PPMU_PMCNT1_MASK		BIT(1)
+#define PPMU_PMCNT0_MASK		BIT(0)
+
+/* PPMU_PMNCTx/PPMU_BETxSEL registers */
+#define PPMU_PMNCT(x)			(PPMU_PMCNT0 + (0x10 * x))
+#define PPMU_BEVTxSEL(x)		(PPMU_BEVT0SEL + (0x100 * x))
+
+#endif /* __EXYNOS_PPMU_H__ */
-- 
1.8.5.5

