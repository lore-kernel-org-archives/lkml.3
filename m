Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3KFVlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:41:39 -0500
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:59233
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524Ab3KFVlg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:41:36 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zz98dIc89bh1432I4015Ic8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2149h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h906i1155h192ch)
Date: Wed, 6 Nov 2013 13:41:25 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Chris Ball <cjb@laptop.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 1/2] mmc: arasan: Add driver for Arasan SDHCI
References: <1383151090-13885-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1383151090-13885-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <b3f788b3-dfc3-422e-9a74-b796c0fd3207@DB8EHSMHS004.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

any comments from your side? Could you consider applying it to your
tree, please?

	Thanks,
	Sören

On Wed, Oct 30, 2013 at 09:38:09AM -0700, Soren Brinkmann wrote:
> Add a driver for Arasan's SDHCI controller core.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> v2:
>  - document 'interrupts' and 'interrupt-parent' properties in the driver
>    bindings
>  - append '-8.9a' IP version specifier to comaptibility string
> ---
>  .../devicetree/bindings/mmc/arasan,sdhci.txt       |  27 +++
>  MAINTAINERS                                        |   1 +
>  drivers/mmc/host/Kconfig                           |  12 ++
>  drivers/mmc/host/Makefile                          |   1 +
>  drivers/mmc/host/sdhci-of-arasan.c                 | 224 +++++++++++++++++++++
>  5 files changed, 265 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mmc/arasan,sdhci.txt
>  create mode 100644 drivers/mmc/host/sdhci-of-arasan.c
> 
> diff --git a/Documentation/devicetree/bindings/mmc/arasan,sdhci.txt b/Documentation/devicetree/bindings/mmc/arasan,sdhci.txt
> new file mode 100644
> index 000000000000..ef4c5ac753e8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/arasan,sdhci.txt
> @@ -0,0 +1,27 @@
> +Device Tree Bindings for the Arasan SDCHI Controller
> +
> +  The bindings follow the mmc[1], clock[2] and interrupt[3] bindings. Only
> +  deviations are documented here.
> +
> +  [1] Documentation/devicetree/bindings/mmc/mmc.txt
> +  [2] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +  [3] Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> +
> +Required Properties:
> +  - compatible: Compatibility string. Must be 'arasan,sdhci-8.9a'
> +  - reg: From mmc bindings: Register location and length.
> +  - clocks: From clock bindings: Handles to clock inputs.
> +  - clock-names: From clock bindings: Tuple including "clk_xin" and "clk_ahb"
> +  - interrupts: Interrupt specifier
> +  - interrupt-parent: Phandle for the interrupt controller that services
> +		      interrupts for this device.
> +
> +Example:
> +	sdhci@e0100000 {
> +		compatible = "arasan,sdhci-8.9a";
> +		reg = <0xe0100000 0x1000>;
> +		clock-names = "clk_xin", "clk_ahb";
> +		clocks = <&clkc 21>, <&clkc 32>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <0 24 4>;
> +	} ;
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3438384d270c..5ede7f722025 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1357,6 +1357,7 @@ T:	git git://git.xilinx.com/linux-xlnx.git
>  S:	Supported
>  F:	arch/arm/mach-zynq/
>  F:	drivers/cpuidle/cpuidle-zynq.c
> +F:	drivers/mmc/host/sdhci-of-arasan.c
>  
>  ARM SMMU DRIVER
>  M:	Will Deacon <will.deacon@arm.com>
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 7fc5099e44b2..1eb090c187bb 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -104,6 +104,18 @@ config MMC_SDHCI_PLTFM
>  
>  	  If unsure, say N.
>  
> +config MMC_SDHCI_OF_ARASAN
> +	tristate "SDHCI OF support for the Arasan SDHCI controllers"
> +	depends on MMC_SDHCI_PLTFM
> +	depends on OF
> +	help
> +	  This selects the Arasan Secure Digital Host Controller Interface
> +	  (SDHCI). This hardware is found e.g. in Xilinx' Zynq SoC.
> +
> +	  If you have a controller with this interface, say Y or M here.
> +
> +	  If unsure, say N.
> +
>  config MMC_SDHCI_OF_ESDHC
>  	tristate "SDHCI OF support for the Freescale eSDHC controller"
>  	depends on MMC_SDHCI_PLTFM
> diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
> index c41d0c364509..f93617ec6548 100644
> --- a/drivers/mmc/host/Makefile
> +++ b/drivers/mmc/host/Makefile
> @@ -57,6 +57,7 @@ obj-$(CONFIG_MMC_SDHCI_CNS3XXX)		+= sdhci-cns3xxx.o
>  obj-$(CONFIG_MMC_SDHCI_ESDHC_IMX)	+= sdhci-esdhc-imx.o
>  obj-$(CONFIG_MMC_SDHCI_DOVE)		+= sdhci-dove.o
>  obj-$(CONFIG_MMC_SDHCI_TEGRA)		+= sdhci-tegra.o
> +obj-$(CONFIG_MMC_SDHCI_OF_ARASAN)	+= sdhci-of-arasan.o
>  obj-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
>  obj-$(CONFIG_MMC_SDHCI_OF_HLWD)		+= sdhci-of-hlwd.o
>  obj-$(CONFIG_MMC_SDHCI_BCM_KONA)	+= sdhci-bcm-kona.o
> diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
> new file mode 100644
> index 000000000000..98464bc732f6
> --- /dev/null
> +++ b/drivers/mmc/host/sdhci-of-arasan.c
> @@ -0,0 +1,224 @@
> +/*
> + * Arasan Secure Digital Host Controller Interface.
> + * Copyright (C) 2011 - 2012 Michal Simek <monstr@monstr.eu>
> + * Copyright (c) 2012 Wind River Systems, Inc.
> + * Copyright (C) 2013 Pengutronix e.K.
> + * Copyright (C) 2013 Xilinx Inc.
> + *
> + * Based on sdhci-of-esdhc.c
> + *
> + * Copyright (c) 2007 Freescale Semiconductor, Inc.
> + * Copyright (c) 2009 MontaVista Software, Inc.
> + *
> + * Authors: Xiaobo Xie <X.Xie@freescale.com>
> + *	    Anton Vorontsov <avorontsov@ru.mvista.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or (at
> + * your option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include "sdhci-pltfm.h"
> +
> +#define SDHCI_ARASAN_CLK_CTRL_OFFSET	0x2c
> +
> +#define CLK_CTRL_TIMEOUT_SHIFT		16
> +#define CLK_CTRL_TIMEOUT_MASK		(0xf << CLK_CTRL_TIMEOUT_SHIFT)
> +#define CLK_CTRL_TIMEOUT_MIN_EXP	13
> +
> +/**
> + * struct sdhci_arasan_data
> + * @clk_ahb:	Pointer to the AHB clock
> + */
> +struct sdhci_arasan_data {
> +	struct clk	*clk_ahb;
> +};
> +
> +static unsigned int sdhci_arasan_get_timeout_clock(struct sdhci_host *host)
> +{
> +	u32 div;
> +	unsigned long freq;
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +
> +	div = readl(host->ioaddr + SDHCI_ARASAN_CLK_CTRL_OFFSET);
> +	div = (div & CLK_CTRL_TIMEOUT_MASK) >> CLK_CTRL_TIMEOUT_SHIFT;
> +
> +	freq = clk_get_rate(pltfm_host->clk);
> +	freq /= 1 << (CLK_CTRL_TIMEOUT_MIN_EXP + div);
> +
> +	return freq;
> +}
> +
> +static struct sdhci_ops sdhci_arasan_ops = {
> +	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
> +	.get_timeout_clock = sdhci_arasan_get_timeout_clock,
> +};
> +
> +static struct sdhci_pltfm_data sdhci_arasan_pdata = {
> +	.ops = &sdhci_arasan_ops,
> +};
> +
> +#ifdef CONFIG_PM_SLEEP
> +/**
> + * sdhci_arasan_suspend - Suspend method for the driver
> + * @dev:	Address of the device structure
> + * Returns 0 on success and error value on error
> + *
> + * Put the device in a low power state.
> + */
> +static int sdhci_arasan_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct sdhci_host *host = platform_get_drvdata(pdev);
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	struct sdhci_arasan_data *sdhci_arasan = pltfm_host->priv;
> +	int ret;
> +
> +	ret = sdhci_suspend_host(host);
> +	if (ret)
> +		return ret;
> +
> +	clk_disable(pltfm_host->clk);
> +	clk_disable(sdhci_arasan->clk_ahb);
> +
> +	return 0;
> +}
> +
> +/**
> + * sdhci_arasan_resume - Resume method for the driver
> + * @dev:	Address of the device structure
> + * Returns 0 on success and error value on error
> + *
> + * Resume operation after suspend
> + */
> +static int sdhci_arasan_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct sdhci_host *host = platform_get_drvdata(pdev);
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	struct sdhci_arasan_data *sdhci_arasan = pltfm_host->priv;
> +	int ret;
> +
> +	ret = clk_enable(sdhci_arasan->clk_ahb);
> +	if (ret) {
> +		dev_err(dev, "Cannot enable AHB clock.\n");
> +		return ret;
> +	}
> +
> +	ret = clk_enable(pltfm_host->clk);
> +	if (ret) {
> +		dev_err(dev, "Cannot enable SD clock.\n");
> +		clk_disable(sdhci_arasan->clk_ahb);
> +		return ret;
> +	}
> +
> +	return sdhci_resume_host(host);
> +}
> +#endif /* ! CONFIG_PM_SLEEP */
> +
> +static SIMPLE_DEV_PM_OPS(sdhci_arasan_dev_pm_ops, sdhci_arasan_suspend,
> +			 sdhci_arasan_resume);
> +
> +static int sdhci_arasan_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct clk *clk_xin;
> +	struct sdhci_host *host;
> +	struct sdhci_pltfm_host *pltfm_host;
> +	struct sdhci_arasan_data *sdhci_arasan;
> +
> +	sdhci_arasan = devm_kzalloc(&pdev->dev, sizeof(*sdhci_arasan),
> +			GFP_KERNEL);
> +	if (!sdhci_arasan)
> +		return -ENOMEM;
> +
> +	sdhci_arasan->clk_ahb = devm_clk_get(&pdev->dev, "clk_ahb");
> +	if (IS_ERR(sdhci_arasan->clk_ahb)) {
> +		dev_err(&pdev->dev, "clk_ahb clock not found.\n");
> +		return PTR_ERR(sdhci_arasan->clk_ahb);
> +	}
> +
> +	clk_xin = devm_clk_get(&pdev->dev, "clk_xin");
> +	if (IS_ERR(clk_xin)) {
> +		dev_err(&pdev->dev, "clk_xin clock not found.\n");
> +		return PTR_ERR(clk_xin);
> +	}
> +
> +	ret = clk_prepare_enable(sdhci_arasan->clk_ahb);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to enable AHB clock.\n");
> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(clk_xin);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to enable SD clock.\n");
> +		goto clk_dis_ahb;
> +	}
> +
> +	host = sdhci_pltfm_init(pdev, &sdhci_arasan_pdata, 0);
> +	if (IS_ERR(host)) {
> +		ret = PTR_ERR(host);
> +		dev_err(&pdev->dev, "platform init failed (%u)\n", ret);
> +		goto clk_disable_all;
> +	}
> +
> +	sdhci_get_of_property(pdev);
> +	pltfm_host = sdhci_priv(host);
> +	pltfm_host->priv = sdhci_arasan;
> +	pltfm_host->clk = clk_xin;
> +
> +	ret = sdhci_add_host(host);
> +	if (ret) {
> +		dev_err(&pdev->dev, "platform register failed (%u)\n", ret);
> +		goto err_pltfm_free;
> +	}
> +
> +	return 0;
> +
> +err_pltfm_free:
> +	sdhci_pltfm_free(pdev);
> +clk_disable_all:
> +	clk_disable_unprepare(clk_xin);
> +clk_dis_ahb:
> +	clk_disable_unprepare(sdhci_arasan->clk_ahb);
> +
> +	return ret;
> +}
> +
> +static int sdhci_arasan_remove(struct platform_device *pdev)
> +{
> +	struct sdhci_host *host = platform_get_drvdata(pdev);
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	struct sdhci_arasan_data *sdhci_arasan = pltfm_host->priv;
> +
> +	clk_disable_unprepare(pltfm_host->clk);
> +	clk_disable_unprepare(sdhci_arasan->clk_ahb);
> +
> +	return sdhci_pltfm_unregister(pdev);
> +}
> +
> +static const struct of_device_id sdhci_arasan_of_match[] = {
> +	{ .compatible = "arasan,sdhci-8.9a" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, sdhci_arasan_of_match);
> +
> +static struct platform_driver sdhci_arasan_driver = {
> +	.driver = {
> +		.name = "sdhci-arasan",
> +		.owner = THIS_MODULE,
> +		.of_match_table = sdhci_arasan_of_match,
> +		.pm = &sdhci_arasan_dev_pm_ops,
> +	},
> +	.probe = sdhci_arasan_probe,
> +	.remove = sdhci_arasan_remove,
> +};
> +
> +module_platform_driver(sdhci_arasan_driver);
> +
> +MODULE_DESCRIPTION("Driver for the Arasan SDHCI Controller");
> +MODULE_AUTHOR("Soeren Brinkmann <soren.brinkmann@xilinx.com");
> +MODULE_LICENSE("GPL");
> -- 
> 1.8.4.1
> 
> 

