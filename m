Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaIEEaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 00:30:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65518 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaIEEaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 00:30:25 -0400
X-AuditID: cbfee691-f79546d0000011a1-a5-54093c5ee3e3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, linux-pm@vger.kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        a.kesavan@samsung.com, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        b.zolnierkie@samsung.com, nm@ti.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RFC PATCH 2/5] devfreq: event: Add exynos-ppmu devfreq evnet driver
Date: Fri, 05 Sep 2014 13:30:16 +0900
Message-id: <1409891419-28560-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
References: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkUDfOhjPEoOWAucXjNYuZLDbOWM9q
	cf3Lc1aL3gVX2SzONr1ht9j0+BqrxeVdc9gsPvceYbSYcX4fk8XtxhVsFm9+nGWyeLziLbvF
	ql1/GB14PXbOusvusXjPSyaPzUvqPfq2rGL0OH5jO5PH501yAWxRXDYpqTmZZalF+nYJXBkb
	v8xjLzieVnFk/m7GBsanIV2MHBwSAiYSfZ15XYycQKaYxIV769m6GLk4hASWMkos/n6UESJh
	IrH61GJmiMR0RomPX66ygySEBJqYJPb0xILYbAJaEvtf3GADsUUEzCT27fjLCtLALLCDSeLa
	gR9gk4QFfCWarjxkArFZBFQlNvdcZgGxeQVcJV7e6IHaJifxYc8jsAWcAm4Sa+9fY4JY5ipx
	8fgksCskBM6xS7RPvccCMUhA4tvkQywQ78hKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihO
	Si8y1StOzC0uzUvXS87P3cQIjJXT/55N3MF4/4D1IUYBDkYlHt4fXzlChFgTy4orcw8xmgJt
	mMgsJZqcD4zIvJJ4Q2MzIwtTE1NjI3NLMyVxXh3pn8FCAumJJanZqakFqUXxRaU5qcWHGJk4
	OKUaGG0aL57rK5ro772rcLvGc8Hd/2uNV1VXPFJ7Ob+DrcJXIK3iXZD1DflX6jfKGy6fm1/Q
	wmRo6Ct8f+eGmoW3vFJO/J37ZpGAo1jCsXjbn0Ic3AYP7m6cs6ZmSc6tLq+L1bt9eetfvPnv
	W3N6mmDIQdYDyyV3Rjd6xO/mKly+47zNWqnUym+8zEosxRmJhlrMRcWJALJ1tWiQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQd04G84QgwXrtC0er1nMZLFxxnpW
	i+tfnrNa9C64ymZxtukNu8Wmx9dYLS7vmsNm8bn3CKPFjPP7mCxuN65gs3jz4yyTxeMVb9kt
	Vu36w+jA67Fz1l12j8V7XjJ5bF5S79G3ZRWjx/Eb25k8Pm+SC2CLamC0yUhNTEktUkjNS85P
	ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6VEmhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMOYsfHLPPaC42kVR+bvZmxgfBrSxcjJISFgIrH61GJmCFtM
	4sK99WxdjFwcQgLTGSU+frnKDpIQEmhiktjTEwtiswloSex/cYMNxBYRMJPYt+MvK0gDs8AO
	JolrB34wgiSEBXwlmq48ZAKxWQRUJTb3XGYBsXkFXCVe3uhhhNgmJ/FhzyOwBZwCbhJr719j
	gljmKnHx+CTmCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx+IzqR2MKxssDjEK
	cDAq8fAu+MwRIsSaWFZcmXuIUYKDWUmE1+sNUIg3JbGyKrUoP76oNCe1+BCjKdBVE5mlRJPz
	gWkiryTe0NjEzMjSyNzQwsjYXEmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QD47Kq6RH7Z61c
	e8/n9VM3x07DRtFf12f7f2Q5Om+Jdny80VrvJWJJl1U81tvlrvsgGVHq6PNwf+dc4T0F/zsD
	5C4/45gTc9zh+vX/kauLvtQ6PstcNzVIcuGhiwWmux9sOHLwKMefl5GHC1q9yq6YbhI5WmT/
	LefsT9Y5DQXNNvFaWQcETFMTuZVYijMSDbWYi4oTAXdIJO7bAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add exynos-ppmu devfreq event driver to provider raw data about
the utilization of each IP in Exynos SoC series.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/devfreq/Kconfig             |  10 +
 drivers/devfreq/event/Makefile      |   1 +
 drivers/devfreq/event/exynos-ppmu.c | 410 ++++++++++++++++++++++++++++++++++++
 3 files changed, 421 insertions(+)
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index ef839e7..4fbbcea 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -90,4 +90,14 @@ config ARM_EXYNOS5_BUS_DEVFREQ
 
 comment "DEVFREQ Event Drivers"
 
+config DEVFREQ_EVENT_EXYNOS_PPMU
+	bool "EXYNOS PPMU (Performance Profiling Monitoring Unit) DEVFREQ event Driver"
+	depends on ARCH_EXYNOS
+	select ARCH_HAS_OPP
+	select PM_OPP
+	help
+	 This add the DEVFREQ event driver for Exynos SoC. It provides PPMU
+	 (Performance Profiling Monitoring Unit) counters to estimate the
+	 utilization of each module.
+
 endif # PM_DEVFREQ
diff --git a/drivers/devfreq/event/Makefile b/drivers/devfreq/event/Makefile
index dc56005..be146ea 100644
--- a/drivers/devfreq/event/Makefile
+++ b/drivers/devfreq/event/Makefile
@@ -1 +1,2 @@
 # Exynos DEVFREQ Event Drivers
+obj-$(CONFIG_DEVFREQ_EVENT_EXYNOS_PPMU) += exynos-ppmu.o
diff --git a/drivers/devfreq/event/exynos-ppmu.c b/drivers/devfreq/event/exynos-ppmu.c
new file mode 100644
index 0000000..54fd492
--- /dev/null
+++ b/drivers/devfreq/event/exynos-ppmu.c
@@ -0,0 +1,410 @@
+/*
+ * exynos_ppmu.c - EXYNOS PPMU (Performance Profiling Monitoring Units) support
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
+#include <linux/devfreq.h>
+
+#define PPMU_ENABLE             BIT(0)
+#define PPMU_DISABLE            0x0
+#define PPMU_CYCLE_RESET        BIT(1)
+#define PPMU_COUNTER_RESET      BIT(2)
+
+#define PPMU_ENABLE_COUNT0      BIT(0)
+#define PPMU_ENABLE_COUNT1      BIT(1)
+#define PPMU_ENABLE_COUNT2      BIT(2)
+#define PPMU_ENABLE_COUNT3      BIT(3)
+#define PPMU_ENABLE_CYCLE       BIT(31)
+
+#define PPMU_CNTENS		0x10
+#define PPMU_FLAG		0x50
+#define PPMU_CCNT_OVERFLOW	BIT(31)
+#define PPMU_CCNT		0x100
+
+#define PPMU_PMCNT0		0x110
+#define PPMU_PMCNT_OFFSET	0x10
+#define PMCNT_OFFSET(x)		(PPMU_PMCNT0 + (PPMU_PMCNT_OFFSET * x))
+
+#define PPMU_BEVT0SEL		0x1000
+#define PPMU_BEVTSEL_OFFSET	0x100
+#define PPMU_BEVTSEL(x)		(PPMU_BEVT0SEL + (x * PPMU_BEVTSEL_OFFSET))
+
+#define RD_DATA_COUNT		0x5
+#define WR_DATA_COUNT		0x6
+#define RDWR_DATA_COUNT		0x7
+
+enum exynos_ppmu_type {
+	TYPE_PPMU_EXYNOS4210,
+};
+
+enum ppmu_counter {
+	PPMU_PMNCNT0,
+	PPMU_PMNCNT1,
+	PPMU_PMNCNT2,
+	PPMU_PMNCNT3,
+	PPMU_PMNCNT_MAX,
+};
+
+/* Platform data */
+struct exynos_ppmu_data {
+	struct devfreq *devfreq;
+	struct devfreq_event_dev **edev;
+	struct devfreq_event_desc *events;
+	unsigned int num_events;
+
+	struct device *dev;
+	struct clk *clk_ppmu;
+	struct mutex lock;
+
+	enum exynos_ppmu_type type;
+
+	struct __exynos_ppmu {
+		void __iomem *hw_base;
+		unsigned int ccnt;
+		unsigned int event[PPMU_PMNCNT_MAX];
+		unsigned int count[PPMU_PMNCNT_MAX];
+		unsigned long long ns;
+		ktime_t reset_time;
+		bool ccnt_overflow;
+		bool count_overflow[PPMU_PMNCNT_MAX];
+	} ppmu;
+};
+
+static int exynos_ppmu_enable(struct devfreq_event_dev *edev)
+{
+	struct exynos_ppmu_data *exynos_ppmu = edev_get_drvdata(edev);
+
+	__raw_writel(PPMU_ENABLE, exynos_ppmu->ppmu.hw_base);
+
+	return 0;
+}
+
+static int exynos_ppmu_disable(struct devfreq_event_dev *edev)
+{
+	struct exynos_ppmu_data *exynos_ppmu = edev_get_drvdata(edev);
+
+	__raw_writel(PPMU_DISABLE, exynos_ppmu->ppmu.hw_base);
+
+	return 0;
+}
+
+static int exynos_ppmu_set_event(struct devfreq_event_dev *edev)
+{
+	struct exynos_ppmu_data *exynos_ppmu = edev_get_drvdata(edev);
+	void __iomem *ppmu_base = exynos_ppmu->ppmu.hw_base;
+	int id = edev->desc->id;
+
+	__raw_writel(RDWR_DATA_COUNT, ppmu_base + PPMU_BEVTSEL(id));
+
+	return 0;
+}
+
+static int exynos_ppmu_get_event(struct devfreq_event_dev *edev)
+{
+	struct exynos_ppmu_data *exynos_ppmu = edev_get_drvdata(edev);
+	void __iomem *ppmu_base = exynos_ppmu->ppmu.hw_base;
+	int id = edev->desc->id;
+	int count, total_count;
+
+	total_count = __raw_readl(ppmu_base + PPMU_CCNT);
+
+	if (id == PPMU_PMNCNT3)
+		count = ((__raw_readl(ppmu_base + PMCNT_OFFSET(id)) << 8) |
+			  __raw_readl(ppmu_base + PMCNT_OFFSET(id + 1)));
+	else
+		count = __raw_readl(ppmu_base + PMCNT_OFFSET(id));
+
+	count = (count * 100) / total_count;
+
+	return count;
+}
+
+static int exynos_ppmu_reset(struct devfreq_event_dev *edev)
+{
+	struct exynos_ppmu_data *exynos_ppmu = edev_get_drvdata(edev);
+	void __iomem *ppmu_base = exynos_ppmu->ppmu.hw_base;
+
+	__raw_writel(PPMU_CYCLE_RESET | PPMU_COUNTER_RESET, ppmu_base);
+	__raw_writel(PPMU_ENABLE_CYCLE  |
+		     PPMU_ENABLE_COUNT0 |
+		     PPMU_ENABLE_COUNT1 |
+		     PPMU_ENABLE_COUNT2 |
+		     PPMU_ENABLE_COUNT3,
+		     ppmu_base + PPMU_CNTENS);
+
+	return 0;
+}
+
+static struct devfreq_event_ops exynos_ppmu_ops = {
+	.enable		= exynos_ppmu_enable,
+	.disable	= exynos_ppmu_disable,
+	.set_event	= exynos_ppmu_set_event,
+	.get_event	= exynos_ppmu_get_event,
+	.reset		= exynos_ppmu_reset,
+};
+
+static struct of_device_id exynos_ppmu_id_match[] = {
+	{
+		.compatible = "samsung,exynos4210-ppmu",
+		.data = (void *)TYPE_PPMU_EXYNOS4210,
+	},
+};
+
+struct __exynos_ppmu_events {
+	char *name;
+	int id;
+} ppmu_events[] = {
+	{ "ppmu-dmc0-pmcnt0", PPMU_PMNCNT0 },
+	{ "ppmu-dmc0-pmcnt1", PPMU_PMNCNT1 },
+	{ "ppmu-dmc0-pmcnt2", PPMU_PMNCNT2 },
+	{ "ppmu-dmc0-pmcnt3", PPMU_PMNCNT3 },
+
+	{ "ppmu-dmc1-pmcnt0", PPMU_PMNCNT0 },
+	{ "ppmu-dmc1-pmcnt1", PPMU_PMNCNT1 },
+	{ "ppmu-dmc1-pmcnt2", PPMU_PMNCNT2 },
+	{ "ppmu-dmc1-pmcnt3", PPMU_PMNCNT3 },
+
+	{ "ppmu-cpu-pmcnt0", PPMU_PMNCNT0 },
+	{ "ppmu-cpu-pmcnt1", PPMU_PMNCNT1 },
+	{ "ppmu-cpu-pmcnt2", PPMU_PMNCNT2 },
+	{ "ppmu-cpu-pmcnt3", PPMU_PMNCNT3 },
+
+	{ "ppmu-rightbus-pmcnt0", PPMU_PMNCNT0 },
+	{ "ppmu-rightbus-pmcnt1", PPMU_PMNCNT1 },
+	{ "ppmu-rightbus-pmcnt2", PPMU_PMNCNT2 },
+	{ "ppmu-rightbus-pmcnt3", PPMU_PMNCNT3 },
+
+	{ "ppmu-leftbus-pmcnt0", PPMU_PMNCNT0 },
+	{ "ppmu-leftbus-pmcnt1", PPMU_PMNCNT1 },
+	{ "ppmu-leftbus-pmcnt2", PPMU_PMNCNT2 },
+	{ "ppmu-leftbus-pmcnt3", PPMU_PMNCNT3 },
+
+	{ "ppmu-camif-pmcnt0", PPMU_PMNCNT0 },
+	{ "ppmu-camif-pmcnt1", PPMU_PMNCNT1 },
+	{ "ppmu-camif-pmcnt2", PPMU_PMNCNT2 },
+	{ "ppmu-camif-pmcnt3", PPMU_PMNCNT3 },
+
+	{ "ppmu-lcd0-pmcnt0", PPMU_PMNCNT0 },
+	{ "ppmu-lcd0-pmcnt1", PPMU_PMNCNT1 },
+	{ "ppmu-lcd0-pmcnt2", PPMU_PMNCNT2 },
+	{ "ppmu-lcd0-pmcnt3", PPMU_PMNCNT3 },
+
+	{ "ppmu-g3d-pmcnt0", PPMU_PMNCNT0 },
+	{ "ppmu-g3d-pmcnt1", PPMU_PMNCNT1 },
+	{ "ppmu-g3d-pmcnt2", PPMU_PMNCNT2 },
+	{ "ppmu-g3d-pmcnt3", PPMU_PMNCNT3 },
+
+	{ "ppmu-mfc-pmcnt0", PPMU_PMNCNT0 },
+	{ "ppmu-mfc-pmcnt1", PPMU_PMNCNT1 },
+	{ "ppmu-mfc-pmcnt2", PPMU_PMNCNT2 },
+	{ "ppmu-mfc-pmcnt3", PPMU_PMNCNT3 },
+
+	{ "ppmu-fsys-pmcnt0", PPMU_PMNCNT0 },
+	{ "ppmu-fsys-pmcnt1", PPMU_PMNCNT1 },
+	{ "ppmu-fsys-pmcnt2", PPMU_PMNCNT2 },
+	{ "ppmu-fsys-pmcnt3", PPMU_PMNCNT3 },
+	{ /* sentinel */ },
+};
+
+static int of_get_devfreq_events(struct device_node *np,
+				struct exynos_ppmu_data *exynos_ppmu)
+{
+	struct devfreq_event_desc *events;
+	struct device *dev = exynos_ppmu->dev;
+	struct device_node *events_np, *node;
+	int i, j, count;
+
+	events_np = of_find_node_by_name(np, "events");
+	if (!events_np) {
+		dev_err(dev, "Failed to find ppmus sub-node\n");
+		return -EINVAL;
+	}
+
+	count = of_get_child_count(events_np);
+	events = devm_kzalloc(dev, sizeof(struct devfreq_event_desc) * count,
+			      GFP_KERNEL);
+	if (!events)
+		return -ENOMEM;
+	exynos_ppmu->num_events = count;
+
+	j = 0;
+	for_each_child_of_node(events_np, node) {
+		for (i = 0; i < ARRAY_SIZE(ppmu_events); i++) {
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
+		events[j].id = ppmu_events[i].id;
+		events[j].ops = &exynos_ppmu_ops;
+		events[j].owner	= THIS_MODULE;
+		events[j].dev = dev;
+		events[j].driver_data = exynos_ppmu;
+		of_property_read_string(node, "event-name", &events[j].name);
+		j++;
+	}
+	exynos_ppmu->events = events;
+
+	return 0;
+}
+
+static int exynos_ppmu_parse_dt(struct exynos_ppmu_data *exynos_ppmu)
+{
+	struct device *dev = exynos_ppmu->dev;
+	struct device_node *np = dev->of_node;
+	int ret = 0;
+
+	if (!np) {
+		dev_err(dev, "Failed to find devicetree node\n");
+		return -EINVAL;
+	}
+
+	/* Maps the memory mapped IO to control PPMU register */
+	exynos_ppmu->ppmu.hw_base = of_iomap(np, 0);
+	if (IS_ERR_OR_NULL(exynos_ppmu->ppmu.hw_base)) {
+		dev_err(dev, "Failed to map memory region\n");
+		ret = -EINVAL;
+		goto err_iomap;
+	}
+
+	/* FIXME: Get the clock of ppmu and enable this clock */
+	exynos_ppmu->clk_ppmu = devm_clk_get(dev, "ppmu");
+	if (IS_ERR(exynos_ppmu->clk_ppmu))
+		dev_warn(dev, "Failed to get PPMU clock\n");
+
+	ret = of_get_devfreq_events(np, exynos_ppmu);
+	if (ret < 0) {
+		dev_err(dev, "Failed to parse exynos ppmu dt node\n");
+		goto err_clock;
+	}
+
+	return 0;
+
+err_clock:
+	clk_disable_unprepare(exynos_ppmu->clk_ppmu);
+err_iomap:
+	iounmap(exynos_ppmu->ppmu.hw_base);
+
+	return ret;
+}
+
+static int exynos_ppmu_get_driver_data(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos_ppmu_id_match, dev->of_node);
+	if (!match)
+		return -ENODEV;
+
+	return (int) match->data;
+}
+
+static int exynos_ppmu_probe(struct platform_device *pdev)
+{
+	struct exynos_ppmu_data *exynos_ppmu;
+	struct devfreq_event_dev **edev;
+	struct devfreq_event_desc *events;
+	int i, ret = 0, size;
+
+	/* Allocate the memory of exynos_ppmu_data and initialize it */
+	exynos_ppmu = devm_kzalloc(&pdev->dev, sizeof(struct exynos_ppmu_data),
+				   GFP_KERNEL);
+	if (!exynos_ppmu)
+		return -ENOMEM;
+
+	mutex_init(&exynos_ppmu->lock);
+	exynos_ppmu->type = exynos_ppmu_get_driver_data(pdev);
+	exynos_ppmu->dev = &pdev->dev;
+
+	/* Parse dt data to get resource */
+	ret = exynos_ppmu_parse_dt(exynos_ppmu);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to parse DT node for resource\n");
+		return ret;
+	}
+	events = exynos_ppmu->events;
+
+	size = sizeof(struct devfreq_event_dev *) * exynos_ppmu->num_events;
+	exynos_ppmu->edev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!exynos_ppmu->edev) {
+		dev_err(&pdev->dev,
+			"Failed to allocate memory devfreq_event_dev list\n");
+		return -ENOMEM;
+	}
+	edev = exynos_ppmu->edev;
+	platform_set_drvdata(pdev, exynos_ppmu);
+
+	for (i = 0; i < exynos_ppmu->num_events; i++) {
+		edev[i] = devfreq_add_event_device(&pdev->dev, &events[i]);
+		if (IS_ERR(edev)) {
+			ret = PTR_ERR(edev);
+			dev_err(&pdev->dev, "Failed to add devfreq evt dev\n");
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	clk_disable_unprepare(exynos_ppmu->clk_ppmu);
+	iounmap(exynos_ppmu->ppmu.hw_base);
+
+	return ret;
+}
+
+static int exynos_ppmu_remove(struct platform_device *pdev)
+{
+	struct exynos_ppmu_data *exynos_ppmu = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(exynos_ppmu->clk_ppmu);
+	iounmap(exynos_ppmu->ppmu.hw_base);
+
+	/* Remove devfreq instance */
+	devfreq_remove_device(exynos_ppmu->devfreq);
+
+	return 0;
+}
+
+static const struct platform_device_id exynos_ppmu_id[] = {
+	{ "exynos4210-ppmu", TYPE_PPMU_EXYNOS4210 },
+	{ },
+};
+
+static struct platform_driver exynos_ppmu_driver = {
+	.probe	= exynos_ppmu_probe,
+	.remove	= exynos_ppmu_remove,
+	.id_table = exynos_ppmu_id,
+	.driver = {
+		.name	= "exynos-ppmu",
+		.owner	= THIS_MODULE,
+		.of_match_table = exynos_ppmu_id_match,
+	},
+};
+
+module_platform_driver(exynos_ppmu_driver);
+
+MODULE_DESCRIPTION("EXYNOS PPMU(Performance Profiling Monitoring Unit) driver");
+MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:exynos-ppmu");
-- 
1.8.0

