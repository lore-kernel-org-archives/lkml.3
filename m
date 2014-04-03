Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaDCL5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:57:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38123 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaDCL5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:57:32 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-9d-533d4cab298e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com,
        Younggun Jang <yg1004.jang@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] drivers: mfd: Add support of exynos-pmu driver
Date: Thu, 03 Apr 2014 13:56:57 +0200
Message-id: <4187440.t3CeqIPlpy@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1396427085-4696-2-git-send-email-pankaj.dubey@samsung.com>
References: <1396427085-4696-1-git-send-email-pankaj.dubey@samsung.com>
 <1396427085-4696-2-git-send-email-pankaj.dubey@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e+xoO5qH9tgg+t3RSyWTbrLZjH/yDlW
	iwN/djBa9C64ymZx/+tRRotNj6+xWlzeNYfNYsb5fUwWty/zWiza+oXdonXvEXaL092sFhdX
	fGGy2NGymsWBz6OluYfNY9OqTjaPO9f2sHnMOxnosXlJvUffllWMHp83yQWwR3HZpKTmZJal
	FunbJXBlzO/XKriiX7Fr/Xu2BsZral2MnBwSAiYS529dZoawxSQu3FvP1sXIxSEkMJ1R4trT
	g4wQTguTxLdFExhBqtgErCQmtq8Cs0UEtCU6L99jBSliFtjKLPFkagtTFyMHh7CAt8S3biGQ
	GhYBVYlVuyaD1fMKaEpMWfqeDcQWFfCU2LF9JZjNKeAh8ez/UXaIZa2MElsP/WWDaBCU+DH5
	HguIzSwgL7Fv/1RWCFtHYn/rNLYJjAKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjBkfNMegfjqgaLQ4wCHIxKPLyWUjbBQqyJZcWVuYcYJTiYlUR411nZBgvxpiRW
	VqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgVF2fnBdq8Cni1qv/
	K6L//l4csNaufGFs3F/L5a9bP197/FEgzltuvvwRS2dmkcudy4Pa9/mUOL5scMmODFo4/cqZ
	NTLvPVlTr96QrzTfK/XTVuT+KZnYm7O/TdM5Zi6xdN7hx7WxNS/k/5ydmP6v93jJMr5J6QYL
	82Z7sTaEvDy7b8mNysk8pkosxRmJhlrMRcWJABWYfYSYAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, April 02, 2014 05:24:44 PM Pankaj Dubey wrote:
> From: Younggun Jang <yg1004.jang@samsung.com>
> 
> This driver is mainly used for setting misc bits of register from PMU IP
> of Exynos SoC which will be required to configure before Suspend/Resume.
> Currently all these settings are done in "arch/arm/mach-exynos/pmu.c" but
> moving ahead for ARM64 based SoC support, there is a need of DT based
> implementation of PMU driver.

PMU support for ARM32 EXYNOS SoCs is heavily SoC dependent and there
is very little code shared between diffirent SoCs.  Unless PMU setup
for Samsung ARM64 SoCs is similar to some existing ARM32 EXYNOS SoCs
it may be better to just add a separate PMU driver for Samsung ARM64
SoCs. IOW it would be best to show that this patch series is really
useful before merging it.

When it comes to the current patches it would be better to do changes
converting PMU support to be a platform driver first for the existing
arch/arm/mach-exynos/pmu.c file and then move+rename this file in
the separate patch.  Currently the code changes are done at the same
time as the code movement which makes them difficult to review/verify.

There are also some minor issues with the new code:

[...]

> diff --git a/drivers/mfd/exynos-pmu.c b/drivers/mfd/exynos-pmu.c
> new file mode 100644
> index 0000000..24abd9b
> --- /dev/null
> +++ b/drivers/mfd/exynos-pmu.c
> @@ -0,0 +1,534 @@
> +/*
> + * Copyright (c) 2014-2015 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com/

2015?

[...]

> +static int __init exynos4210_pmu_init(void)
> +{
> +	exynos_pmu_config = exynos4210_pmu_config;
> +	pmu_data->pmu_id = PMU_EXYNOS4210;
> +	pr_info("EXYNOS4210 PMU Initialize\n");
> +
> +	return 0;
> +}
> +
> +static int __init exynos4212_pmu_init(void)
> +{
> +	exynos_pmu_config = exynos4x12_pmu_config;
> +	pmu_data->pmu_id = PMU_EXYNOS4212;
> +	pr_info("EXYNOS4x12 PMU Initialize\n");
> +
> +	return 0;
> +}
> +
> +static int __init exynos4412_pmu_init(void)
> +{
> +	exynos_pmu_config = exynos4x12_pmu_config;
> +	pmu_data->pmu_id = PMU_EXYNOS4412;
> +	pr_info("EXYNOS4412 PMU Initialize\n");
> +
> +	return 0;
> +}
> +
> +static int __init exynos5250_pmu_init(void)
> +{
> +	unsigned int value;
> +
> +	/*
> +	 * When SYS_WDTRESET is set, watchdog timer reset request
> +	 * is ignored by power management unit.
> +	 */
> +	value = __raw_readl(pmu_data->regs + EXYNOS5_AUTO_WDTRESET_DISABLE);
> +	value &= ~EXYNOS5_SYS_WDTRESET;
> +	__raw_writel(value, pmu_data->regs + EXYNOS5_AUTO_WDTRESET_DISABLE);
> +
> +	value = __raw_readl(pmu_data->regs + EXYNOS5_MASK_WDTRESET_REQUEST);
> +	value &= ~EXYNOS5_SYS_WDTRESET;
> +	__raw_writel(value, pmu_data->regs + EXYNOS5_MASK_WDTRESET_REQUEST);
> +
> +	exynos_pmu_config = exynos5250_pmu_config;
> +	pmu_data->pmu_id = PMU_EXYNOS5250;
> +	pr_info("EXYNOS5250 PMU Initialize\n");
> +
> +	return 0;
> +}
> +
> +/*
> + * PMU platform driver and devicetree bindings.
> + */
> +static struct of_device_id exynos_pmu_of_device_ids[] = {
> +	{
> +		.compatible = "samsung,exynos4210-pmu",
> +		.data = (void *)exynos4210_pmu_init
> +	},
> +	{
> +		.compatible = "samsung,exynos4212-pmu",
> +		.data = (void *)exynos4212_pmu_init
> +	},
> +	{
> +		.compatible = "samsung,exynos4412-pmu",
> +		.data = (void *)exynos4412_pmu_init
> +	},
> +	{
> +		.compatible = "samsung,exynos5250-pmu",
> +		.data = (void *)exynos5250_pmu_init
> +	},
> +	{},
> +};
> +
> +static int exynos_pmu_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	exynos_pmu_init_t exynos_pmu_init;
> +	struct resource *res;
> +
> +	pmu_data = devm_kzalloc(&pdev->dev,
> +			sizeof(struct exynos_pmu_data), GFP_KERNEL);
> +	if (!pmu_data) {
> +		dev_err(&pdev->dev, "exynos_pmu driver probe failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	pmu_data->dev = &pdev->dev;
> +
> +	match = of_match_node(exynos_pmu_of_device_ids, pdev->dev.of_node);
> +	exynos_pmu_init = match->data;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	pmu_data->regs = devm_ioremap_resource(&pdev->dev, res);

devm_ioremap_resouce() return value should be checked for errors with

if (IS_ERR(pmu_data->regs))
	return PTR_ERR(pmu_data->regs);

> +
> +	exynos_pmu_init();

exynos*_pmu_init() methods should be void as they always return 0 and
the return value is ignored anyway.

Also they cannot be marked with __init as the driver probe function
itself is not marked with __init (it cannot be beacuse of possibility
of doing unbind/bind through sysfs).

> +
> +	return 0;
> +};
> +
> +static int exynos_pmu_remove(struct platform_device *pdev)
> +{
> +	exynos_pmu_config = NULL;
> +
> +	return 0;
> +}
> +
> +static struct platform_driver exynos_pmu_driver = {
> +	.driver  = {
> +		.name   = "exynos-pmu",
> +		.of_match_table = exynos_pmu_of_device_ids,
> +	},
> +	.probe = exynos_pmu_probe,
> +	.remove = exynos_pmu_remove,
> +};
> +
> +static int __init exynos_pmu_driver_init(void)
> +{
> +	return platform_driver_register(&exynos_pmu_driver);
> +}
> +arch_initcall(exynos_pmu_driver_init);
> +
> +MODULE_AUTHOR("Younggun Jang <yg1004.jang@samsung.com");
> +MODULE_DESCRIPTION("Exynos PMU driver");
> +MODULE_LICENSE("GPL v2");

This driver can be build as module now but:
- exynos_sys_powerdown_conf() is not exported
- there is no exynos_pmu_driver_exit()

Also it is not clear what happens if exynos_sys_powerdown_conf() is called
while there are no platform devices binded to a driver but driver itself is
loaded.

[...]

> diff --git a/include/linux/mfd/samsung/exynos-regs-pmu.h b/include/linux/mfd/samsung/exynos-regs-pmu.h
> new file mode 100644
> index 0000000..ed8259d
> --- /dev/null
> +++ b/include/linux/mfd/samsung/exynos-regs-pmu.h
> @@ -0,0 +1,308 @@
> +/*
> + * Copyright (c) 2014-2015 Samsung Electronics Co., Ltd.

2015?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

