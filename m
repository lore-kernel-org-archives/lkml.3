Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaLPX1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:27:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43913 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaLPX1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:27:04 -0500
X-AuditID: cbfee68f-f791c6d000004834-57-5490bfc50556
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv4 3/8] devfreq: event: Add exynos-ppmu devfreq event driver
Date: Wed, 17 Dec 2014 08:26:52 +0900
Message-id: <1418772417-5164-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
References: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSoHt0/4QQg++d0haP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6M9etPMBW0xlU82bqYuYHxmk8XIyeHhICJxNGrO9ghbDGJC/fWs3UxcnEICSxl
	lOg78JoVpujYwtksILaQwCJGiSdvSyHsJiaJ29eVQWw2AS2J/S9usIHYIgIyElc3bmcBGcQs
	0Mgs8WXZfyaQhLCAt8T0z7fBtrEIqEpc3NMJ1MDBwSvgIrHthQvELgWJZctngu3lFHCVaLmx
	mglil4tE59WdrCAzJQSusUvMnvKYEWKOgMS3yYdYQOZICMhKbDrADDFHUuLgihssExiFFzAy
	rGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIjJ3T/57172C8e8D6EKMAB6MSD29AYX+IEGti
	WXFl7iFGU6ANE5mlRJPzgRGaVxJvaGxmZGFqYmpsZG5ppiTOu1DqZ7CQQHpiSWp2ampBalF8
	UWlOavEhRiYOTqkGxqOTjs90WzRxi7PUhFfby8wCakv67Fd8/ZZ8tCUnvChnt1PdtpIrDydV
	lpzotjB9eYFhhtDUR20JhjcUFJSkBWZP2XV09frIxkAv3xTL24YRv2pnzTF4t9Gu7OCTrTWR
	po+mzfF90ryrTJNHbFV90DSRxScbquQOnM3q6byu/uWuR7ZB8uv0B0osxRmJhlrMRcWJAP+q
	4kKYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jAd2j+yeEGMy6xG/xeM1iJovrX56z
	Wsw/co7VYtL9CSwWr18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVbt+sPowO+xZt4aRo+ds+6yeyze85LJY/OSeo++LasYPT5vkgtgi2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOllJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLF+/Qmmgta4iidbFzM3MF7z6WLk5JAQ
	MJE4tnA2C4QtJnHh3no2EFtIYBGjxJO3pRB2E5PE7evKIDabgJbE/hc3wGpEBGQkrm7cDtTL
	xcEs0Mgs8WXZfyaQhLCAt8T0z7fZQWwWAVWJi3s6gRo4OHgFXCS2vXCB2KUgsWz5TFYQm1PA
	VaLlxmomiF0uEp1Xd7JOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Mp9J72Bc
	1WBxiFGAg1GJhzewsD9EiDWxrLgy9xCjBAezkgivxaIJIUK8KYmVValF+fFFpTmpxYcYTYGO
	msgsJZqcD0waeSXxhsYmZkaWRuaGFkbG5krivEr2bSFCAumJJanZqakFqUUwfUwcnFINjN2t
	4nbJzJvtZYy/1p0RXn1U7Yv6j9eeC4RWzPPYeNvx8VEvH3v9mw+fMnnP0jJW12m60ZbYvNjz
	/kxNg8nyd1X0GQyDF4e+FArukfmy0E8qz6OsZ83vNif+/Ke79s04NrVx9bJTS7uOnXnieZ97
	fkyqhVfr1BdsvtcOVHa+vvJe3MhoVsj5SiWW4oxEQy3mouJEAI74tD7iAgAA
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
---
 drivers/devfreq/Kconfig             |   9 +
 drivers/devfreq/event/Makefile      |   1 +
 drivers/devfreq/event/exynos-ppmu.c | 397 ++++++++++++++++++++++++++++++++++++
 3 files changed, 407 insertions(+)
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 4d15b62..8b282c4 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -89,4 +89,13 @@ config ARM_EXYNOS5_BUS_DEVFREQ
 
 comment "DEVFREQ Event Drivers"
 
+config DEVFREQ_EVENT_EXYNOS_PPMU
+	bool "EXYNOS PPMU (Platform Performance Monitoring Unit) DEVFREQ event Driver"
+	depends on ARCH_EXYNOS
+	select PM_OPP
+	help
+	 This add the DEVFREQ event driver for Exynos SoC. It provides PPMU
+	 (Platform Performance Monitoring Unit) counters to estimate the
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
index 0000000..60f9eb0
--- /dev/null
+++ b/drivers/devfreq/event/exynos-ppmu.c
@@ -0,0 +1,397 @@
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
+enum ppmu_counter {
+	PPMU_PMNCNT0 = 0,
+	PPMU_PMNCNT1,
+	PPMU_PMNCNT2,
+	PPMU_PMNCNT3,
+
+	PPMU_PMNCNT_MAX,
+};
+
+struct exynos_ppmu_data {
+	struct devfreq_event_dev **edev;
+	struct devfreq_event_desc *desc;
+	unsigned int num_events;
+
+	struct device *dev;
+	struct clk *clk_ppmu;
+	struct mutex lock;
+
+	struct __exynos_ppmu {
+		void __iomem *base;
+		unsigned int event[PPMU_PMNCNT_MAX];
+		unsigned int count[PPMU_PMNCNT_MAX];
+		bool ccnt_overflow;
+		bool count_overflow[PPMU_PMNCNT_MAX];
+	} ppmu;
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
+static int exynos_ppmu_reset(struct devfreq_event_dev *edev)
+{
+	struct exynos_ppmu_data *data = devfreq_event_get_drvdata(edev);
+
+	__raw_writel(PPMU_CYCLE_RESET | PPMU_COUNTER_RESET, data->ppmu.base);
+	__raw_writel(PPMU_ENABLE_CYCLE  |
+		     PPMU_ENABLE_COUNT0 |
+		     PPMU_ENABLE_COUNT1 |
+		     PPMU_ENABLE_COUNT2 |
+		     PPMU_ENABLE_COUNT3,
+		     data->ppmu.base + PPMU_CNTENS);
+
+	return 0;
+}
+
+static int exynos_ppmu_set_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type)
+{
+	struct exynos_ppmu_data *data = devfreq_event_get_drvdata(edev);
+	int id = exynos_ppmu_find_ppmu_id(edev);
+
+	if (id < 0)
+		return id;
+
+	if (type != edev->desc->type)
+		return -EINVAL;
+
+	/* Reset the performance and cycle counters */
+	exynos_ppmu_reset(edev);
+
+	/* Setup count registers to monitor read/write transactions */
+	__raw_writel(RDWR_DATA_COUNT, data->ppmu.base + PPMU_BEVTSEL(id));
+
+	/* Start monitoring of PPMU IP */
+	__raw_writel(PPMU_ENABLE, data->ppmu.base);
+
+	return 0;
+}
+
+static int exynos_ppmu_get_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type,
+				struct devfreq_event_data *edata)
+{
+	struct exynos_ppmu_data *data = devfreq_event_get_drvdata(edev);
+	int id = exynos_ppmu_find_ppmu_id(edev);
+
+	if (id < 0)
+		return -EINVAL;
+
+	if (type != edev->desc->type)
+		return -EINVAL;
+
+	/* Stop monitoring of PPMU IP */
+	__raw_writel(PPMU_DISABLE, data->ppmu.base);
+
+	/* Read total count cycle from of PPMU IP */
+	edata->total_event = __raw_readl(data->ppmu.base + PPMU_CCNT);
+
+	if (id == PPMU_PMNCNT3)
+		edata->event =
+			((__raw_readl(data->ppmu.base + PMCNT_OFFSET(id)) << 8)
+			| __raw_readl(data->ppmu.base + PMCNT_OFFSET(id + 1)));
+	else
+		edata->event = __raw_readl(data->ppmu.base + PMCNT_OFFSET(id));
+
+	dev_dbg(&edev->dev, "%s (event: %ld/%ld)\n", edev->desc->name,
+					edata->event, edata->total_event);
+
+	return 0;
+}
+
+static struct devfreq_event_ops exynos_ppmu_ops = {
+	.set_event = exynos_ppmu_set_event,
+	.get_event = exynos_ppmu_get_event,
+};
+
+static int of_get_devfreq_events(struct device_node *np,
+				 struct exynos_ppmu_data *data)
+{
+	struct devfreq_event_desc *desc;
+	struct device *dev = data->dev;
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
+	data->num_events = count;
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
+		desc[j].driver_data = data;
+		desc[j].type |= DEVFREQ_EVENT_TYPE_RAW_DATA;
+
+		of_property_read_string(node, "event-name", &desc[j].name);
+
+		j++;
+
+		of_node_put(node);
+	}
+	data->desc = desc;
+
+	of_node_put(events_np);
+
+	return 0;
+}
+
+static int exynos_ppmu_parse_dt(struct exynos_ppmu_data *data)
+{
+	struct device *dev = data->dev;
+	struct device_node *np = dev->of_node;
+	int ret = 0;
+
+	if (!np) {
+		dev_err(dev, "failed to find devicetree node\n");
+		return -EINVAL;
+	}
+
+	/* Maps the memory mapped IO to control PPMU register */
+	data->ppmu.base = of_iomap(np, 0);
+	if (IS_ERR_OR_NULL(data->ppmu.base)) {
+		dev_err(dev, "failed to map memory region\n");
+		return -EINVAL;
+	}
+
+	data->clk_ppmu = devm_clk_get(dev, "ppmu");
+	if (IS_ERR(data->clk_ppmu)) {
+		data->clk_ppmu = NULL;
+		dev_warn(dev, "failed to get PPMU clock\n");
+	}
+
+	ret = of_get_devfreq_events(np, data);
+	if (ret < 0) {
+		dev_err(dev, "failed to parse exynos ppmu dt node\n");
+		goto err;
+	}
+
+	return 0;
+
+err:
+	iounmap(data->ppmu.base);
+
+	return ret;
+}
+
+static int exynos_ppmu_probe(struct platform_device *pdev)
+{
+	struct exynos_ppmu_data *data;
+	struct devfreq_event_dev **edev;
+	struct devfreq_event_desc *desc;
+	int i, ret = 0, size;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	mutex_init(&data->lock);
+	data->dev = &pdev->dev;
+
+	/* Parse dt data to get resource */
+	ret = exynos_ppmu_parse_dt(data);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"failed to parse devicetree for resource\n");
+		return ret;
+	}
+	desc = data->desc;
+
+	size = sizeof(struct devfreq_event_dev *) * data->num_events;
+	data->edev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!data->edev) {
+		dev_err(&pdev->dev,
+			"failed to allocate memory devfreq-event devices\n");
+		return -ENOMEM;
+	}
+	edev = data->edev;
+	platform_set_drvdata(pdev, data);
+
+	for (i = 0; i < data->num_events; i++) {
+		edev[i] = devfreq_event_add_edev(&pdev->dev, &desc[i]);
+		if (IS_ERR(edev)) {
+			ret = PTR_ERR(edev);
+			dev_err(&pdev->dev,
+				"failed to add devfreq-event device\n");
+			goto err;
+		}
+	}
+
+	clk_prepare_enable(data->clk_ppmu);
+
+	return 0;
+err:
+	iounmap(data->ppmu.base);
+
+	return ret;
+}
+
+static int exynos_ppmu_remove(struct platform_device *pdev)
+{
+	struct exynos_ppmu_data *data = platform_get_drvdata(pdev);
+	int i, ret = 0;
+
+	for (i = 0; i < data->num_events; i++) {
+		ret = devfreq_event_remove_edev(data->edev[i]);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"failed to remove devfreq-event device\n");
+			goto err;
+		}
+	}
+
+err:
+	clk_disable_unprepare(data->clk_ppmu);
+	iounmap(data->ppmu.base);
+
+	return ret;
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
+		.owner	= THIS_MODULE,
+		.of_match_table = exynos_ppmu_id_match,
+	},
+};
+module_platform_driver(exynos_ppmu_driver);
+
+MODULE_DESCRIPTION("Exynos PPMU(Platform Performance Monitoring Unit) driver");
+MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:exynos-ppmu");
-- 
1.8.5.5

