Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaLJJ7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:59:49 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37633 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaLJJ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:59:45 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-5c-5488198d7945
Message-id: <1418205580.16644.19.camel@AMDC1943>
Subject: Re: [RFC PATCHv2 4/7] devfreq: event: Add exynos-ppmu devfreq event
 driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, rafael.j.wysocki@intel.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Date: Wed, 10 Dec 2014 10:59:40 +0100
In-reply-to: <1418134386-14681-5-git-send-email-cw00.choi@samsung.com>
References: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
 <1418134386-14681-5-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xK7q9kh0hBm+W6ls8XrOYyWLjjPWs
	Fte/PGe1mH/kHKtF74KrbBZnm96wW2x6fI3V4vKuOWwWn3uPMFrMOL+PyeJ24wo2i8cr3rJb
	rNr1h9GB12PnrLvsHov3vGTy2Lyk3qNvyypGj8+b5AJYo7hsUlJzMstSi/TtErgyNh/8xVKw
	ILeir1evgXFSRBcjB4eEgInEn7V2XYycQKaYxIV769m6GLk4hASWMkrMe/mMGcL5zChx+OQf
	dpAqXgEDiZ8HnjGB2MICoRJrJ69hAbHZBIwlNi9fwgZiiwhoSMz8e4URxGYWuM4kceeGJ4jN
	IqAqcW9iNyuIzSngJnG34wYLxIJGRokbnavYIBrUJSbNW8QMcZ2yRGO/G8ReQYkfk++xQJTI
	S2xe85Z5AqPALCQds5CUzUJStoCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSHR82cG4
	+JjVIUYBDkYlHl5zxdYQIdbEsuLK3EOMEhzMSiK8GVwdIUK8KYmVValF+fFFpTmpxYcYmTg4
	pRoYmdYc+cjy3tvRz/Udo2rOjFvKEut/6rf+m8wVXb/o8QWrBbyme7Wjzv9RyH90nSNa/Nil
	XQ/TizVTIlJDO0uqSm8pdildOPXe8brGOcMnLxRiBTalvGPZavNnhsEBqcSZz4UvbHW31Lpm
	usWmaq5dZAxXm/Lh8rmxZxWjCxWVsrVcN1/qL7mnxFKckWioxVxUnAgAxdK7iWwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-12-09 at 23:13 +0900, Chanwoo Choi wrote:
> This patch add exynos-ppmu devfreq event driver to provider raw data about
> the utilization of each IP in Exynos SoC series.
> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/Kconfig             |   9 +
>  drivers/devfreq/event/Makefile      |   1 +
>  drivers/devfreq/event/exynos-ppmu.c | 409 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 419 insertions(+)
>  create mode 100644 drivers/devfreq/event/exynos-ppmu.c

I would rather see this as an incremental change for existing
exynos_ppmu.c file. However I do not insists on that.

> 
> diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
> index 4d15b62..d4559f7 100644
> --- a/drivers/devfreq/Kconfig
> +++ b/drivers/devfreq/Kconfig
> @@ -89,4 +89,13 @@ config ARM_EXYNOS5_BUS_DEVFREQ
>  
>  comment "DEVFREQ Event Drivers"
>  
> +config DEVFREQ_EVENT_EXYNOS_PPMU
> +	bool "EXYNOS PPMU (Performance Profiling Monitoring Unit) DEVFREQ event Driver"
> +	depends on ARCH_EXYNOS
> +	select PM_OPP
> +	help
> +	 This add the DEVFREQ event driver for Exynos SoC. It provides PPMU
> +	 (Performance Profiling Monitoring Unit) counters to estimate the
> +	 utilization of each module.
> +
>  endif # PM_DEVFREQ
> diff --git a/drivers/devfreq/event/Makefile b/drivers/devfreq/event/Makefile
> index dc56005..be146ea 100644
> --- a/drivers/devfreq/event/Makefile
> +++ b/drivers/devfreq/event/Makefile
> @@ -1 +1,2 @@
>  # Exynos DEVFREQ Event Drivers
> +obj-$(CONFIG_DEVFREQ_EVENT_EXYNOS_PPMU) += exynos-ppmu.o
> diff --git a/drivers/devfreq/event/exynos-ppmu.c b/drivers/devfreq/event/exynos-ppmu.c
> new file mode 100644
> index 0000000..2706f23
> --- /dev/null
> +++ b/drivers/devfreq/event/exynos-ppmu.c
> @@ -0,0 +1,409 @@
> +/*
> + * exynos_ppmu.c - EXYNOS PPMU (Performance Profiling Monitoring Units) support
> + *
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + * Author : Chanwoo Choi <cw00.choi@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This driver is based on drivers/devfreq/exynos/exynos_ppmu.c
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +#include <linux/suspend.h>
> +#include <linux/devfreq.h>
> +
> +#define PPMU_ENABLE             BIT(0)
> +#define PPMU_DISABLE            0x0
> +#define PPMU_CYCLE_RESET        BIT(1)
> +#define PPMU_COUNTER_RESET      BIT(2)
> +
> +#define PPMU_ENABLE_COUNT0      BIT(0)
> +#define PPMU_ENABLE_COUNT1      BIT(1)
> +#define PPMU_ENABLE_COUNT2      BIT(2)
> +#define PPMU_ENABLE_COUNT3      BIT(3)
> +#define PPMU_ENABLE_CYCLE       BIT(31)
> +
> +#define PPMU_CNTENS		0x10
> +#define PPMU_FLAG		0x50
> +#define PPMU_CCNT_OVERFLOW	BIT(31)
> +#define PPMU_CCNT		0x100
> +
> +#define PPMU_PMCNT0		0x110
> +#define PPMU_PMCNT_OFFSET	0x10
> +#define PMCNT_OFFSET(x)		(PPMU_PMCNT0 + (PPMU_PMCNT_OFFSET * x))
> +
> +#define PPMU_BEVT0SEL		0x1000
> +#define PPMU_BEVTSEL_OFFSET	0x100
> +#define PPMU_BEVTSEL(x)		(PPMU_BEVT0SEL + (x * PPMU_BEVTSEL_OFFSET))
> +
> +#define RD_DATA_COUNT		0x5
> +#define WR_DATA_COUNT		0x6
> +#define RDWR_DATA_COUNT		0x7
> +
> +enum ppmu_counter {
> +	PPMU_PMNCNT0,
> +	PPMU_PMNCNT1,
> +	PPMU_PMNCNT2,
> +	PPMU_PMNCNT3,
> +	PPMU_PMNCNT_MAX,
> +};
> +
> +/* Platform data */
> +struct exynos_ppmu_data {
> +	struct devfreq *devfreq;

Looks like not used here.

> +	struct devfreq_event_dev **event_dev;
> +	struct devfreq_event_desc *desc;
> +	unsigned int num_events;
> +
> +	struct device *dev;
> +	struct clk *clk_ppmu;
> +	struct mutex lock;
> +
> +	struct __exynos_ppmu {
> +		void __iomem *hw_base;
> +		unsigned int ccnt;
> +		unsigned int event[PPMU_PMNCNT_MAX];
> +		unsigned int count[PPMU_PMNCNT_MAX];
> +		unsigned long long ns;
> +		ktime_t reset_time;
> +		bool ccnt_overflow;
> +		bool count_overflow[PPMU_PMNCNT_MAX];
> +	} ppmu;
> +};
> +
> +struct __exynos_ppmu_events {
> +	char *name;
> +	int id;
> +} ppmu_events[] = {
> +	{ "ppmu-dmc0-pmcnt0", PPMU_PMNCNT0 },
> +	{ "ppmu-dmc0-pmcnt1", PPMU_PMNCNT1 },
> +	{ "ppmu-dmc0-pmcnt2", PPMU_PMNCNT2 },
> +	{ "ppmu-dmc0-pmcnt3", PPMU_PMNCNT3 },
> +
> +	{ "ppmu-dmc1-pmcnt0", PPMU_PMNCNT0 },
> +	{ "ppmu-dmc1-pmcnt1", PPMU_PMNCNT1 },
> +	{ "ppmu-dmc1-pmcnt2", PPMU_PMNCNT2 },
> +	{ "ppmu-dmc1-pmcnt3", PPMU_PMNCNT3 },
> +
> +	{ "ppmu-cpu-pmcnt0", PPMU_PMNCNT0 },
> +	{ "ppmu-cpu-pmcnt1", PPMU_PMNCNT1 },
> +	{ "ppmu-cpu-pmcnt2", PPMU_PMNCNT2 },
> +	{ "ppmu-cpu-pmcnt3", PPMU_PMNCNT3 },
> +
> +	{ "ppmu-rightbus-pmcnt0", PPMU_PMNCNT0 },
> +	{ "ppmu-rightbus-pmcnt1", PPMU_PMNCNT1 },
> +	{ "ppmu-rightbus-pmcnt2", PPMU_PMNCNT2 },
> +	{ "ppmu-rightbus-pmcnt3", PPMU_PMNCNT3 },
> +
> +	{ "ppmu-leftbus-pmcnt0", PPMU_PMNCNT0 },
> +	{ "ppmu-leftbus-pmcnt1", PPMU_PMNCNT1 },
> +	{ "ppmu-leftbus-pmcnt2", PPMU_PMNCNT2 },
> +	{ "ppmu-leftbus-pmcnt3", PPMU_PMNCNT3 },
> +
> +	{ "ppmu-camif-pmcnt0", PPMU_PMNCNT0 },
> +	{ "ppmu-camif-pmcnt1", PPMU_PMNCNT1 },
> +	{ "ppmu-camif-pmcnt2", PPMU_PMNCNT2 },
> +	{ "ppmu-camif-pmcnt3", PPMU_PMNCNT3 },
> +
> +	{ "ppmu-lcd0-pmcnt0", PPMU_PMNCNT0 },
> +	{ "ppmu-lcd0-pmcnt1", PPMU_PMNCNT1 },
> +	{ "ppmu-lcd0-pmcnt2", PPMU_PMNCNT2 },
> +	{ "ppmu-lcd0-pmcnt3", PPMU_PMNCNT3 },
> +
> +	{ "ppmu-g3d-pmcnt0", PPMU_PMNCNT0 },
> +	{ "ppmu-g3d-pmcnt1", PPMU_PMNCNT1 },
> +	{ "ppmu-g3d-pmcnt2", PPMU_PMNCNT2 },
> +	{ "ppmu-g3d-pmcnt3", PPMU_PMNCNT3 },
> +
> +	{ "ppmu-mfc-pmcnt0", PPMU_PMNCNT0 },
> +	{ "ppmu-mfc-pmcnt1", PPMU_PMNCNT1 },
> +	{ "ppmu-mfc-pmcnt2", PPMU_PMNCNT2 },
> +	{ "ppmu-mfc-pmcnt3", PPMU_PMNCNT3 },
> +
> +	{ "ppmu-fsys-pmcnt0", PPMU_PMNCNT0 },
> +	{ "ppmu-fsys-pmcnt1", PPMU_PMNCNT1 },
> +	{ "ppmu-fsys-pmcnt2", PPMU_PMNCNT2 },
> +	{ "ppmu-fsys-pmcnt3", PPMU_PMNCNT3 },
> +	{ /* sentinel */ },
> +};
> +
> +static int exynos_ppmu_enable(struct devfreq_event_dev *event_dev)
> +{
> +	struct exynos_ppmu_data *exynos_ppmu = event_dev_get_drvdata(event_dev);
> +
> +	__raw_writel(PPMU_ENABLE, exynos_ppmu->ppmu.hw_base);
> +
> +	return 0;
> +}
> +
> +static int exynos_ppmu_disable(struct devfreq_event_dev *event_dev)
> +{
> +	struct exynos_ppmu_data *exynos_ppmu = event_dev_get_drvdata(event_dev);
> +
> +	__raw_writel(PPMU_DISABLE, exynos_ppmu->ppmu.hw_base);
> +
> +	return 0;
> +}
> +
> +static bool exynos_ppmu_is_enabled(struct devfreq_event_dev *event_dev)
> +{
> +	struct exynos_ppmu_data *exynos_ppmu = event_dev_get_drvdata(event_dev);
> +	int val;
> +
> +	val = __raw_readl(exynos_ppmu->ppmu.hw_base);
> +	if (val & PPMU_ENABLE)
> +		return true;
> +
> +	return false;
> +}
> +
> +static int exynos_ppmu_find_ppmu_id(struct devfreq_event_dev *event_dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ppmu_events); i++)
> +		if (!strcmp(event_dev->desc->name, ppmu_events[i].name))
> +			return ppmu_events[i].id;
> +
> +	return -EINVAL;
> +}
> +
> +static int exynos_ppmu_set_event(struct devfreq_event_dev *event_dev,
> +				enum devfreq_event_type event_type)
> +{
> +	struct exynos_ppmu_data *exynos_ppmu = event_dev_get_drvdata(event_dev);
> +	void __iomem *ppmu_base = exynos_ppmu->ppmu.hw_base;
> +	int id = exynos_ppmu_find_ppmu_id(event_dev);
> +
> +	__raw_writel(RDWR_DATA_COUNT, ppmu_base + PPMU_BEVTSEL(id));
> +
> +	return 0;
> +}
> +
> +static int exynos_ppmu_get_event(struct devfreq_event_dev *event_dev,
> +				enum devfreq_event_type event_type,
> +				int *total_event)
> +{
> +	struct exynos_ppmu_data *exynos_ppmu = event_dev_get_drvdata(event_dev);
> +	void __iomem *ppmu_base = exynos_ppmu->ppmu.hw_base;
> +	int id = exynos_ppmu_find_ppmu_id(event_dev);
> +	int cnt, total_cnt;
> +
> +	total_cnt = __raw_readl(ppmu_base + PPMU_CCNT);
> +
> +	if (id == PPMU_PMNCNT3)
> +		cnt = ((__raw_readl(ppmu_base + PMCNT_OFFSET(id)) << 8) |
> +			  __raw_readl(ppmu_base + PMCNT_OFFSET(id + 1)));
> +	else
> +		cnt = __raw_readl(ppmu_base + PMCNT_OFFSET(id));
> +
> +	*total_event = total_cnt;
> +
> +	return cnt;
> +}
> +
> +static int exynos_ppmu_reset(struct devfreq_event_dev *event_dev)
> +{
> +	struct exynos_ppmu_data *exynos_ppmu = event_dev_get_drvdata(event_dev);
> +	void __iomem *ppmu_base = exynos_ppmu->ppmu.hw_base;
> +
> +	__raw_writel(PPMU_CYCLE_RESET | PPMU_COUNTER_RESET, ppmu_base);
> +	__raw_writel(PPMU_ENABLE_CYCLE  |
> +		     PPMU_ENABLE_COUNT0 |
> +		     PPMU_ENABLE_COUNT1 |
> +		     PPMU_ENABLE_COUNT2 |
> +		     PPMU_ENABLE_COUNT3,
> +		     ppmu_base + PPMU_CNTENS);
> +	__raw_writel(PPMU_ENABLE, exynos_ppmu->ppmu.hw_base);
> +
> +	return 0;
> +}
> +
> +static struct devfreq_event_ops exynos_ppmu_ops = {
> +	.enable		= exynos_ppmu_enable,
> +	.disable	= exynos_ppmu_disable,
> +	.is_enabled	= exynos_ppmu_is_enabled,
> +	.set_event	= exynos_ppmu_set_event,
> +	.get_event	= exynos_ppmu_get_event,
> +	.reset		= exynos_ppmu_reset,
> +};
> +
> +static int of_get_devfreq_events(struct device_node *np,
> +				struct exynos_ppmu_data *exynos_ppmu)
> +{
> +	struct devfreq_event_desc *desc;
> +	struct device *dev = exynos_ppmu->dev;
> +	struct device_node *events_np, *node;
> +	int i, j, count;
> +
> +	events_np = of_find_node_by_name(np, "events");

of_get_child_by_name()

> +	if (!events_np) {
> +		dev_err(dev, "Failed to find ppmus sub-node\n");
> +		return -EINVAL;
> +	}
> +
> +	count = of_get_child_count(events_np);
> +	desc = devm_kzalloc(dev, sizeof(struct devfreq_event_desc) * count,
> +			      GFP_KERNEL);
> +	if (!desc)
> +		return -ENOMEM;
> +	exynos_ppmu->num_events = count;
> +
> +	j = 0;
> +	for_each_child_of_node(events_np, node) {
> +		for (i = 0; i < ARRAY_SIZE(ppmu_events); i++) {
> +			if (!of_node_cmp(node->name, ppmu_events[i].name))
> +				break;
> +		}
> +
> +		if (i == ARRAY_SIZE(ppmu_events)) {
> +			dev_warn(dev,
> +				"don't know how to configure events : %s\n",
> +				node->name);
> +			continue;
> +		}
> +		desc[j].ops = &exynos_ppmu_ops;
> +		desc[j].driver_data = exynos_ppmu;
> +		desc[j].event_type |= DEVFREQ_EVENT_TYPE_RAW_DATA;
> +		of_property_read_string(node, "event-name", &desc[j].name);
> +		j++;
> +	}
> +	exynos_ppmu->desc = desc;

of_node_put() for 'events_np' and 'node' in loop.

> +
> +	return 0;
> +}
> +
> +static int exynos_ppmu_parse_dt(struct exynos_ppmu_data *exynos_ppmu)
> +{
> +	struct device *dev = exynos_ppmu->dev;
> +	struct device_node *np = dev->of_node;
> +	int ret = 0;
> +
> +	if (!np) {
> +		dev_err(dev, "Failed to find devicetree node\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Maps the memory mapped IO to control PPMU register */
> +	exynos_ppmu->ppmu.hw_base = of_iomap(np, 0);
> +	if (IS_ERR_OR_NULL(exynos_ppmu->ppmu.hw_base)) {
> +		dev_err(dev, "Failed to map memory region\n");
> +		ret = -EINVAL;
> +		goto err_iomap;
> +	}
> +
> +	/* FIXME: Get the clock of ppmu and enable this clock */
> +	exynos_ppmu->clk_ppmu = devm_clk_get(dev, "ppmu");
> +	if (IS_ERR(exynos_ppmu->clk_ppmu))
> +		dev_warn(dev, "Failed to get PPMU clock\n");
> +
> +	ret = of_get_devfreq_events(np, exynos_ppmu);
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to parse exynos ppmu dt node\n");
> +		goto err_clock;
> +	}
> +
> +	return 0;
> +
> +err_clock:
> +	clk_disable_unprepare(exynos_ppmu->clk_ppmu);

Not needed. Clock is not enabled here.

> +err_iomap:
> +	iounmap(exynos_ppmu->ppmu.hw_base);
> +
> +	return ret;
> +}
> +
> +static int exynos_ppmu_probe(struct platform_device *pdev)
> +{
> +	struct exynos_ppmu_data *exynos_ppmu;
> +	struct devfreq_event_dev **event_dev;
> +	struct devfreq_event_desc *desc;
> +	int i, ret = 0, size;
> +
> +	/* Allocate the memory of exynos_ppmu_data and initialize it */
> +	exynos_ppmu = devm_kzalloc(&pdev->dev, sizeof(struct exynos_ppmu_data),
> +				   GFP_KERNEL);
> +	if (!exynos_ppmu)
> +		return -ENOMEM;
> +
> +	mutex_init(&exynos_ppmu->lock);
> +	exynos_ppmu->dev = &pdev->dev;
> +
> +	/* Parse dt data to get resource */
> +	ret = exynos_ppmu_parse_dt(exynos_ppmu);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to parse DT node for resource\n");
> +		return ret;
> +	}
> +	desc = exynos_ppmu->desc;
> +
> +	size = sizeof(struct devfreq_event_dev *) * exynos_ppmu->num_events;
> +	exynos_ppmu->event_dev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
> +	if (!exynos_ppmu->event_dev) {
> +		dev_err(&pdev->dev,
> +			"Failed to allocate memory devfreq_event_dev list\n");
> +		return -ENOMEM;
> +	}
> +	event_dev = exynos_ppmu->event_dev;
> +	platform_set_drvdata(pdev, exynos_ppmu);

Missing clk_prepare_enable().

> +
> +	for (i = 0; i < exynos_ppmu->num_events; i++) {
> +		event_dev[i] = devfreq_add_event_device(&pdev->dev, &desc[i]);
> +		if (IS_ERR(event_dev)) {
> +			ret = PTR_ERR(event_dev);
> +			dev_err(&pdev->dev, "Failed to add devfreq evt dev\n");
> +			goto err;
> +		}
> +	}
> +
> +	return 0;
> +err:
> +	clk_disable_unprepare(exynos_ppmu->clk_ppmu);
> +	iounmap(exynos_ppmu->ppmu.hw_base);
> +
> +	return ret;
> +}
> +
> +static int exynos_ppmu_remove(struct platform_device *pdev)
> +{
> +	struct exynos_ppmu_data *exynos_ppmu = platform_get_drvdata(pdev);
> +
> +	clk_disable_unprepare(exynos_ppmu->clk_ppmu);
> +	iounmap(exynos_ppmu->ppmu.hw_base);
> +
> +	/* Remove devfreq instance */
> +	devfreq_remove_device(exynos_ppmu->devfreq);

Shouldn't this be devfreq_remove_event_dev()?

Best regards,
Krzysztof


