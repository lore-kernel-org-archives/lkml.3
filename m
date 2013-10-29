Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3J2JxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:53:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60855 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab3J2JxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:53:01 -0400
Message-ID: <526F8573.6050209@ti.com>
Date: Tue, 29 Oct 2013 15:22:51 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm@vger.kernel.org>, <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>
Subject: Re: [PATCH v2 1/5] phy: Add new Exynos USB PHY driver
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com> <1382710529-12082-2-git-send-email-k.debski@samsung.com> <526A90B9.3040501@ti.com> <025b01ced3e4$ec685db0$c5391910$%debski@samsung.com>
In-Reply-To: <025b01ced3e4$ec685db0$c5391910$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 28 October 2013 07:22 PM, Kamil Debski wrote:
> Hi Kishon,
> 
> Thank you for your review! I will answer your comments below.
> 
>> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
>> Sent: Friday, October 25, 2013 5:40 PM
>>
>> Hi,
>>
>> On Friday 25 October 2013 07:45 PM, Kamil Debski wrote:
>>> Add a new driver for the Exynos USB PHY. The new driver uses the
>>> generic PHY framework. The driver includes support for the Exynos
>> 4x10
>>> and 4x12 SoC families.
>>>
>>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  .../devicetree/bindings/phy/samsung-usbphy.txt     |   51 +++
>>>  drivers/phy/Kconfig                                |   21 ++
>>>  drivers/phy/Makefile                               |    3 +
>>>  drivers/phy/phy-exynos-usb.c                       |  245
>> ++++++++++++++
>>>  drivers/phy/phy-exynos-usb.h                       |   94 ++++++
>>>  drivers/phy/phy-exynos4210-usb.c                   |  295
>> +++++++++++++++++
>>>  drivers/phy/phy-exynos4212-usb.c                   |  343
>> ++++++++++++++++++++
>>>  7 files changed, 1052 insertions(+)
>>>  create mode 100644
>>> Documentation/devicetree/bindings/phy/samsung-usbphy.txt
>>>  create mode 100644 drivers/phy/phy-exynos-usb.c  create mode 100644
>>> drivers/phy/phy-exynos-usb.h  create mode 100644
>>> drivers/phy/phy-exynos4210-usb.c  create mode 100644
>>> drivers/phy/phy-exynos4212-usb.c
>>>
>>> diff --git a/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
>>> b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
>>> new file mode 100644
>>> index 0000000..f112b37
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
>>> @@ -0,0 +1,51 @@
>>> +Samsung S5P/EXYNOS SoC series USB PHY
>>> +-------------------------------------------------
>>> +
>>> +Required properties:
>>> +- compatible : should be one of the listed compatibles:
>>> +	- "samsung,exynos4210-usbphy"
>>> +	- "samsung,exynos4212-usbphy"
>>> +- reg : a list of registers used by phy driver
>>> +	- first and obligatory is the location of phy modules registers
>>> +	- second and also required is the location of isolation registers
>>> +	  (isolation registers control the physical connection between
>> the in
>>> +	  SoC modules and outside of the SoC, this also can be called
>> enable
>>> +	  control in the documentation of the SoC)
>>> +	- third is the location of the mode switch register, this only
>> applies
>>> +	  to SoCs that have such a feature; mode switching enables to
>> have
>>> +	  both host and device used the same SoC pins and is commonly
>> used
>>> +	  when OTG is supported
>>> +- #phy-cells : from the generic phy bindings, must be 1;
>>> +
>>> +The second cell in the PHY specifier identifies the PHY its meaning
>>> +is SoC dependent. For the currently supported SoCs (Exynos 4210 and
>>> +Exynos 4212) it is as follows:
>>> +  0 - USB device,
>>> +  1 - USB host,
>>> +  2 - HSIC0,
>>> +  3 - HSIC1,
>>
>> HSIC is supposedly to be transceiver less no? You have to program
>> something in the digital side?
>> You have a single IP that have all these functionalities?
> 
> There is a single USB PHY controller for all the above functionalities
> (i.e. host, device, hsic 0 and 1).

Ok.
> 
>>> +
>>> +Example:
>>> +
>>> +For Exynos 4412 (compatible with Exynos 4212):
>>> +
>>> +exynos_usbphy: exynos-usbphy@125B0000 {
>>> +	compatible = "samsung,exynos4212-usbphy";
>>> +	reg = <0x125B0000 0x100 0x10020704 0x0c 0x1001021c 0x4>;
>>> +	ranges;
>>> +	#address-cells = <1>;
>>> +	#size-cells = <1>;
>>
>> The above 3 properties aren't documented? Are they needed here?
> 
> My bad. I was working on two branches and corrected it in only one
> of them.
> 
>>> +	clocks = <&clock 305>, <&clock 2>, <&clock 2>, <&clock 2>,
>>> +							<&clock 2>;
>>> +	clock-names = "phy", "device", "host", "hsic0", "hsic1";
>>> +	status = "okay";
>>> +	#phy-cells = <1>;
>>> +};
>>> +
>>> +Then the PHY can be used in other nodes such as:
>>> +
>>> +ehci@12580000 {
>>> +	status = "okay";
>>> +	phys = <&exynos_usbphy 2>;
>>> +	phy-names = "hsic0";
>>> +};
>>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig index
>>> 349bef2..2f7ac0a 100644
>>> --- a/drivers/phy/Kconfig
>>> +++ b/drivers/phy/Kconfig
>>> @@ -15,4 +15,25 @@ config GENERIC_PHY
>>>  	  phy users can obtain reference to the PHY. All the users of
>> this
>>>  	  framework should select this config.
>>>
>>> +config PHY_EXYNOS_USB
>>> +	tristate "Samsung USB PHY driver (using the Generic PHY
>> Framework)"
>> Mentioning *Generic PHY Framework* is not necessary.
>> *select GENERIC_PHY* here
> 
> This was added to distinguish this driver from the ols USB PHY driver.
> I agree that in the final version it should be removed. I understand that
> the correct way to do this is by removing the old driver when the new gets
> merged. Yes?

right.
> 
>>> +	help
>>> +	  Enable this to support Samsung USB phy helper driver for
>> Samsung SoCs.
>>> +	  This driver provides common interface to interact, for Samsung
>>> +	  USB 2.0 PHY driver.
>>
>> If it's going to be used only for usb2, name it PHY_EXYNOS_USB2.
> 
> I agree.
> 
>>> +
>>> +config PHY_EXYNOS4210_USB
>>> +	bool "Support for Exynos 4210"
>>> +	depends on PHY_EXYNOS_USB
>>> +	depends on CPU_EXYNOS4210
>>> +	help
>>> +	  Enable USB PHY support for Exynos 4210
>>> +
>>> +config PHY_EXYNOS4212_USB
>>> +	bool "Support for Exynos 4212"
>>> +	depends on PHY_EXYNOS_USB
>>> +	depends on (SOC_EXYNOS4212 || SOC_EXYNOS4412)
>>> +	help
>>> +	  Enable USB PHY support for Exynos 4212
>>
>> How difference is USB PHY in Exynos 4212 from Exynos 4210? If th
> ere
>> isn't much, I would suggest to use a single driver.
> 
> My idea for the driver is to have a single driver for the whole Exynos USB2
> PHY. The core of the driver is in phy-exynos-usb.c and phy-exynos*-usb.c
> provide registers and setup sequences for particular SoC versions.
> 
> There are a few differences between Exynos 4210, 4212, 5250 and S5PV210:
> - the registers are different on each
> - the setup sequence is different 
> - 4212 and 5250 have a single pair of regular USB OTG DEVICE/HOST lines
> - 4210 has a USB OTG and a separate USB HOST lines
> - S5PV210 has both USB OTG and a separate USB HOST but lacks any HSIC
>   interfaces
> 
> I agree with you that it is best to add as little code as possible.
> Hence the idea to have a separate driver core and additional files for
> distinctive SoCs. Enabling PHY_EXYNOS4210_USB (or other SoC specific
> options)
> does not add another driver it only includes support for enabled SoC.
> 
> It would be possible to skip this distinction altogether and include support
> for all SoCs in the driver without config options.
> 
>>> +
>>>  endmenu
>>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile index
>>> 9e9560f..ca3dc82 100644
>>> --- a/drivers/phy/Makefile
>>> +++ b/drivers/phy/Makefile
>>> @@ -3,3 +3,6 @@
>>>  #
>>>
>>>  obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
>>> +obj-$(CONFIG_PHY_EXYNOS_USB)		+= phy-exynos-usb.o
>>> +obj-$(CONFIG_PHY_EXYNOS4210_USB)	+= phy-exynos4210-usb.o
>>> +obj-$(CONFIG_PHY_EXYNOS4212_USB)	+= phy-exynos4212-usb.o
>>> diff --git a/drivers/phy/phy-exynos-usb.c
>>> b/drivers/phy/phy-exynos-usb.c new file mode 100644 index
>>> 0000000..d4a26df
>>> --- /dev/null
>>> +++ b/drivers/phy/phy-exynos-usb.c
>>
>> phy-exynos-usb2.c?
> 
> Ok.
> 
>>> @@ -0,0 +1,245 @@
>>> +/*
>>> + * Samsung S5P/EXYNOS SoC series USB PHY driver
>>> + *
>>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>>> + * Author: Kamil Debski <k.debski@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> +modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#include <linux/clk.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/io.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_address.h>
>>> +#include <linux/phy/phy.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/spinlock.h>
>>> +#include "phy-exynos-usb.h"
>>> +
>>> +static int exynos_uphy_power_on(struct phy *phy)
>>
>> exynos_usb2_phy here and everywhere below.
> 
> Ok.
> 
>>> +{
>>> +	struct uphy_instance *inst = phy_get_drvdata(phy);
>>> +	struct uphy_driver *drv = inst->drv;
>>> +	int ret;
>>> +
>>> +	dev_info(drv->dev, "Request to power_on \"%s\" usb phy\n",
>>> +							inst->cfg->label);
>>
>> make it dev_dbg if it's necessary.
> 
> Ok.
> 
>>> +	ret = clk_prepare_enable(drv->clk);
>>> +	if (ret)
>>> +		return ret;
>>> +	if (inst->cfg->power_on) {
>>> +		spin_lock(&drv->lock);
>>> +		ret = inst->cfg->power_on(inst);
>>> +		spin_unlock(&drv->lock);
>>> +	}
>>> +	clk_disable_unprepare(drv->clk);
>>
>> hmm.. don't you need the clock to be on during the duration of the PHY
>> operation?
> 
> I think that it is enough to have the clock enabled only during changes.
> 
>>> +	return ret;
>>> +}
>>> +
>>> +static int exynos_uphy_power_off(struct phy *phy) {
>>> +	struct uphy_instance *inst = phy_get_drvdata(phy);
>>> +	struct uphy_driver *drv = inst->drv;
>>> +	int ret;
>>> +
>>> +	dev_info(drv->dev, "Request to power_off \"%s\" usb phy\n",
>>> +							inst->cfg->label);
>>
>> dev_dbg?
> 
> Ok.
> 
>>> +	ret = clk_prepare_enable(drv->clk);
>>> +	if (ret)
>>> +		return ret;
>>> +	if (inst->cfg->power_off) {
>>> +		spin_lock(&drv->lock);
>>> +		ret = inst->cfg->power_off(inst);
>>> +		spin_unlock(&drv->lock);
>>> +	}
>>> +	clk_disable_unprepare(drv->clk);
>>> +	return ret;
>>> +}
>>> +
>>> +static struct phy_ops exynos_uphy_ops = {
>>> +	.power_on	= exynos_uphy_power_on,
>>> +	.power_off	= exynos_uphy_power_off,
>>> +	.owner		= THIS_MODULE,
>>> +};
>>> +
>>> +static struct phy *exynos_uphy_xlate(struct device *dev,
>>> +					struct of_phandle_args *args)
>>> +{
>>> +	struct uphy_driver *drv;
>>> +
>>> +	drv = dev_get_drvdata(dev);
>>> +	if (!drv)
>>> +		return ERR_PTR(-EINVAL);
>>> +
>>> +	if (WARN_ON(args->args[0] >= drv->cfg->num_phys))
>>> +		return ERR_PTR(-ENODEV);
>>> +
>>> +	return drv->uphy_instances[args->args[0]].phy;
>>> +}
>>> +
>>> +static const struct of_device_id exynos_uphy_of_match[];
>>> +
>>> +static int exynos_uphy_probe(struct platform_device *pdev) {
>>> +	struct uphy_driver *drv;
>>> +	struct device *dev = &pdev->dev;
>>> +	struct resource *mem;
>>> +	struct phy_provider *phy_provider;
>>> +
>>> +	const struct of_device_id *match;
>>> +	const struct uphy_config *cfg;
>>> +	struct clk *clk;
>>> +
>>> +	int i;
>>> +
>>> +	match = of_match_node(exynos_uphy_of_match, pdev->dev.of_node);
>>> +	if (!match) {
>>> +		dev_err(dev, "of_match_node() failed\n");
>>> +		return -EINVAL;
>>> +	}
>>> +	cfg = match->data;
>>> +	if (!cfg) {
>>> +		dev_err(dev, "Failed to get configuration\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	drv = devm_kzalloc(dev, sizeof(struct uphy_driver) +
>>> +		cfg->num_phys * sizeof(struct uphy_instance), GFP_KERNEL);
>>> +
>>> +	if (!drv) {
>>> +		dev_err(dev, "Failed to allocate memory\n");
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	dev_set_drvdata(dev, drv);
>>> +	spin_lock_init(&drv->lock);
>>> +
>>> +	drv->cfg = cfg;
>>> +	drv->dev = dev;
>>> +
>>> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +
>> empty blank line.
> 
> Will fix.
> 
>>> +	drv->reg_phy = devm_ioremap_resource(dev, mem);
>>> +	if (IS_ERR(drv->reg_phy)) {
>>> +		dev_err(dev, "Failed to map register memory (phy)\n");
>>> +		return PTR_ERR(drv->reg_phy);
>>> +	}
>>> +
>>> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>>> +	drv->reg_isol = devm_ioremap_resource(dev, mem);
>>> +	if (IS_ERR(drv->reg_isol)) {
>>> +		dev_err(dev, "Failed to map register memory (isolation)\n");
>>> +		return PTR_ERR(drv->reg_isol);
>>> +	}
>>> +
>>> +	switch (drv->cfg->cpu) {
>>> +	case TYPE_EXYNOS4210:
>>> +	case TYPE_EXYNOS4212:
>>
>> Lets not add such cpu checks inside driver.
> 
> Some SoC have a special register, which switches the OTG lines between
> device and host modes. I understand that it might not be the prettiest
> code. I see this as a good compromise between having a single huge
> driver for all Exynos SoCs and having a multiple drivers for each SoC
> version. PHY IPs in these chips very are similar but have to be handled
> differently. Any other ideas to solve this issue?

revision checks?
> 
>>> +		mem = platform_get_resource(pdev, IORESOURCE_MEM, 2);
>>> +		drv->reg_mode = devm_ioremap_resource(dev, mem);
>>> +		if (IS_ERR(drv->reg_mode)) {
>>> +			dev_err(dev, "Failed to map register memory (mode
>> switch)\n");
>>> +			return PTR_ERR(drv->reg_mode);
>>> +		}
>>> +		break;
>>> +	default:
>>> +		break;
>>> +	}
>>> +
>>> +	phy_provider = devm_of_phy_provider_register(dev,
>>> +							exynos_uphy_xlate);
>>> +	if (IS_ERR(phy_provider)) {
>>> +		dev_err(drv->dev, "Failed to register phy provider\n");
>>> +		return PTR_ERR(phy_provider);
>>> +	}
>>> +
>>> +	drv->clk = devm_clk_get(dev, "phy");
>>> +	if (IS_ERR(drv->clk)) {
>>> +		dev_err(dev, "Failed to get clock of phy controller\n");
>>> +		return PTR_ERR(drv->clk);
>>> +	}
>>> +
>>> +	for (i = 0; i < drv->cfg->num_phys; i++) {
>>> +		char *label = drv->cfg->phys[i].label;
>>> +		struct uphy_instance *p = &drv->uphy_instances[i];
>>> +
>>> +		dev_info(dev, "Creating phy \"%s\"\n", label);
>>> +		p->phy = devm_phy_create(dev, &exynos_uphy_ops, NULL);
>>> +		if (IS_ERR(p->phy)) {
>>> +			dev_err(drv->dev, "Failed to create uphy \"%s\"\n",
>>> +						label);
>>> +			return PTR_ERR(p->phy);
>>> +		}
>>> +
>>> +		p->cfg = &drv->cfg->phys[i];
>>> +		p->drv = drv;
>>> +		phy_set_drvdata(p->phy, p);
>>> +
>>> +		clk = clk_get(dev, p->cfg->label);
>>> +		if (IS_ERR(clk)) {
>>> +			dev_err(dev, "Failed to get clock of \"%s\" phy\n",
>>> +
> p->cfg->label);
>>> +			return PTR_ERR(clk);
>>> +		}
>>> +
>>> +		p->rate = clk_get_rate(clk);
>>> +
>>> +		if (p->cfg->rate_to_clk) {
>>> +			p->clk = p->cfg->rate_to_clk(p->rate);
>>> +			if (p->clk == CLKSEL_ERROR) {
>>> +				dev_err(dev, "Clock rate (%ld) not
> supported\n",
>>> +								p->rate);
>>> +				clk_put(clk);
>>> +				return -EINVAL;
>>> +			}
>>> +		}
>>> +		clk_put(clk);
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +#ifdef CONFIG_PHY_EXYNOS4210_USB
>> Do we really need this?
> 
> No we don't. The driver can always support all Exynos SoC versions. These
> config options were added for flexibility.
> 
>>
>>> +extern const struct uphy_config exynos4210_uphy_config; #endif
>>> +
>>> +#ifdef CONFIG_PHY_EXYNOS4212_USB
>>
>> Same here.
>>> +extern const struct uphy_config exynos4212_uphy_config; #endif
>>> +
>>> +static const struct of_device_id exynos_uphy_of_match[] = { #ifdef
>>> +CONFIG_PHY_EXYNOS4210_USB
>>
>> #if not needed here.
> 
> If the #ifdef CONFIG_PHY_EXYNOS4210_USB is removed then yes. Otherwise
> it is necessary - exynos4210_uphy_config may be undefined.
> 
>>> +	{
>>> +		.compatible = "samsung,exynos4210-usbphy",
>>> +		.data = &exynos4210_uphy_config,
>>> +	},
>>> +#endif
>>> +#ifdef CONFIG_PHY_EXYNOS4212_USB
>>
>> here too.
>>> +	{
>>> +		.compatible = "samsung,exynos4212-usbphy",
>>> +		.data = &exynos4212_uphy_config,
>>> +	},
>>> +#endif
>>> +	{ },
>>> +};
>>> +
>>> +static struct platform_driver exynos_uphy_driver = {
>>> +	.probe	= exynos_uphy_probe,
>>> +	.driver = {
>>> +		.of_match_table	= exynos_uphy_of_match,
>>> +		.name		= "exynos-usbphy-new",
>> "exynos-usb2-phy".
>>> +		.owner		= THIS_MODULE,
>>> +	}
>>> +};
>>> +
>>> +module_platform_driver(exynos_uphy_driver);
>>> +MODULE_DESCRIPTION("Samsung S5P/EXYNOS SoC USB PHY driver");
>>> +MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
>>> +MODULE_LICENSE("GPL v2"); MODULE_ALIAS("platform:exynos-uphy-new");
>>> +
>>> diff --git a/drivers/phy/phy-exynos-usb.h
>>> b/drivers/phy/phy-exynos-usb.h new file mode 100644 index
>>> 0000000..f45cb3c
>>> --- /dev/null
>>> +++ b/drivers/phy/phy-exynos-usb.h
>>> @@ -0,0 +1,94 @@
>>> +/*
>>> + * Samsung S5P/EXYNOS SoC series USB PHY driver
>>> + *
>>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>>> + * Author: Kamil Debski <k.debski@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> +modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#ifndef _PHY_SAMSUNG_NEW_H
>>> +#define _PHY_SAMSUNG_NEW_H
>>> +
>>> +#include <linux/clk.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/io.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_address.h>
>>> +#include <linux/phy/phy.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/spinlock.h>
>>> +
>>> +#define CLKSEL_ERROR                       -1
>>> +
>>> +#ifndef KHZ
>>> +#define KHZ 1000
>>> +#endif
>>> +
>>> +#ifndef MHZ
>>> +#define MHZ (KHZ * KHZ)
>>> +#endif
>>> +
>>> +enum phy_type {
>>> +	PHY_DEVICE,
>>> +	PHY_HOST,
>>> +};
>>> +
>>> +enum samsung_cpu_type {
>>> +	TYPE_S3C64XX,
>>> +	TYPE_EXYNOS4210,
>>> +	TYPE_EXYNOS4212,
>>
>> No *cpu_type* inside driver files.
> 
> I guess that you are in favor a "a separate driver for each phy version".
> For me it can be both. But we have to discuss which apporach is better:
> 1) separate driver for each phy version - no iffs and significant code
>    duplication

Creating separate driver for each PHY version is not recommended.
drivers/usb/dwc3/dwc3-omap.c is used for two different SoCs with different
register offsets for your reference.
> 2) a single driver driver supporting all Exynos variants - it needs ifs,
>    code is always bigger

IMO it can be done without #if's. Use revision checks or compatible values.
> 3) a single driver with support for particular SoC enabled in the config
> file
>    - with ifs, but the driver can be compiled smaller

Sorry, don't prefer ifs in driver files.

Thanks
Kishon
