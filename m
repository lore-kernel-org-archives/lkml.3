Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3JYHwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 03:52:09 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18904 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab3JYHwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 03:52:04 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-2a-526a23227cb0
Message-id: <526A231E.2090504@samsung.com>
Date: Fri, 25 Oct 2013 09:51:58 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        kyungmin.park@samsung.com, t.figa@samsung.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org
Subject: Re: [RFC 04/12] phy: Add simple-phy driver
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
 <1382365111-6533-5-git-send-email-t.stanislaws@samsung.com>
 <52694238.7050607@ti.com>
In-reply-to: <52694238.7050607@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xa7pKyllBBj87+SzmHznHanHl63s2
	i0n3J7BY9C64ymZx4WkPm8XZpjfsFpd3zWGzmHF+H5PF0wkX2SymLDrManH4TTurxYzJL9ks
	1s94zWJxbMYSRgc+jzvX9rB53O8+zuTRt2UVo8fxG9uZPD5vkgtgjeKySUnNySxLLdK3S+DK
	eP1/CnvBZqOK/7fXszcwPtXoYuTkkBAwkejuPMUMYYtJXLi3nq2LkYtDSGApo8TxNbPYIZzP
	jBIzH+9nB6niFdCSOHFwNRuIzSKgKrF26RGwbjagSceWfGYEsUUFwiSONv1khagXlPgx+R4L
	iC0C1Ht65w9mkKHMAg+YJDat3wdWJCxgLNG65DfUtoWMEit3TWcCSXAKqElsurYObCqzgI7E
	/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93E
	CImYrzsYlx6zOsQowMGoxMObMCMzSIg1say4MvcQowQHs5IIb4d0VpAQb0piZVVqUX58UWlO
	avEhRiYOTqkGxlvvl56a0ZP5InDlu1DX0jNsD5cGTVp0p/jq3rjY5+kL+1cJON4J//I58dsS
	nn+PfP+rctrN4LmYnZobsvrHCuuYn5kCjn+v3z2s3j7LJmG1w46vF3v97+03dnzmeGYbx+6L
	q1O27dDyjGPYxyyysJLPYEe6uvy1nZuXWu99dqVy++Kv7WfmhS5RYinOSDTUYi4qTgQACsmq
	2HYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Please refer to the comments below.

On 10/24/2013 05:52 PM, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Monday 21 October 2013 07:48 PM, Tomasz Stanislawski wrote:
>> Add simple-phy driver to support a single register
>> PHY interfaces present on Exynos4 SoC.
> 
> How are these PHY interfaces modelled in the SoC? Where does the register
> actually reside?

Initially, I was planning to add PHY for HDMI_PHY register in
power management register set on s5pv310 soc.

However other PHYs use very similar interface (setting bit 0).
This includes DAC_PHY, ADC_PHY, PCIe_PHY, SATA_PHY.
Moreover it suits well to USBDEVICE_PHY, USBHOST_PHY.
That is why I thought about using something more generic
to handle all those phys without introducing a herd of
200-lines-long drivers.

>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> ---
>>  drivers/phy/Kconfig      |    5 ++
>>  drivers/phy/Makefile     |    1 +
>>  drivers/phy/phy-simple.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 134 insertions(+)
>>  create mode 100644 drivers/phy/phy-simple.c
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index ac239ac..619c657 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -38,4 +38,9 @@ config TWL4030_USB
>>  	  This transceiver supports high and full speed devices plus,
>>  	  in host mode, low speed.
>>  
>> +config PHY_SIMPLE
>> +	tristate "Simple PHY driver"
> 
> This is too generic a name to be used. Lets name it something specific to what
> it is used for (EXYNOS/HDMI.. ?).

Ok. It could be renamed to EXYNOS-SIMPLE-PHY or EXYNOS-1BIT-PHY or EXYNOS-GENERIC-PHY
or something similar. Any ideas?

>> +	help
>> +	  Support for PHY controllers configured using single register.
>> +
>>  endmenu
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index 0dd8a98..3d68e19 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -5,3 +5,4 @@
>>  obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
>>  obj-$(CONFIG_OMAP_USB2)		+= phy-omap-usb2.o
>>  obj-$(CONFIG_TWL4030_USB)	+= phy-twl4030-usb.o
>> +obj-$(CONFIG_PHY_SIMPLE)	+= phy-simple.o
>> diff --git a/drivers/phy/phy-simple.c b/drivers/phy/phy-simple.c
>> new file mode 100644
>> index 0000000..4a28af7
>> --- /dev/null
>> +++ b/drivers/phy/phy-simple.c
>> @@ -0,0 +1,128 @@
>> +/*
>> + * Simple PHY driver
>> + *
>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>> + * Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/phy/phy.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/spinlock.h>
>> +
>> +struct simple_phy {
>> +	spinlock_t slock;
>> +	u32 on_value;
>> +	u32 off_value;
>> +	u32 mask;
>> +	void __iomem *regs;
>> +};
>> +
>> +static int sphy_set(struct simple_phy *sphy, bool on)
>> +{
>> +	u32 reg;
>> +
>> +	spin_lock(&sphy->slock);
> 
> Lets add spin_lock only when it is absolutely necessary. When your PHY provider
> implements only a single PHY, it is not needed. phy_power_on and phy_power_off
> is already protected by the framework.

ok

>> +
>> +	reg = readl(sphy->regs);
>> +	reg &= ~sphy->mask;
>> +	reg |= sphy->mask & (on ? sphy->on_value : sphy->off_value);
>> +	writel(reg, sphy->regs);
>> +
>> +	spin_unlock(&sphy->slock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int simple_phy_power_on(struct phy *phy)
>> +{
>> +	return sphy_set(phy_get_drvdata(phy), 1);
>> +}
>> +
>> +static int simple_phy_power_off(struct phy *phy)
>> +{
>> +	return sphy_set(phy_get_drvdata(phy), 0);
>> +}
>> +
>> +static struct phy_ops simple_phy_ops = {
>> +	.power_on	= simple_phy_power_on,
>> +	.power_off	= simple_phy_power_off,
>> +	.owner		= THIS_MODULE,
>> +};
>> +
>> +static int simple_phy_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct simple_phy *sphy;
>> +	struct resource *res;
>> +	struct phy_provider *phy_provider;
>> +	struct phy *phy;
>> +
>> +	sphy = devm_kzalloc(dev, sizeof(*sphy), GFP_KERNEL);
>> +	if (!sphy)
>> +		return -ENOMEM;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +
>> +	sphy->regs = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(sphy->regs)) {
>> +		dev_err(dev, "failed to ioremap registers\n");
>> +		return PTR_ERR(sphy->regs);
>> +	}
>> +
>> +	spin_lock_init(&sphy->slock);
>> +
>> +	phy_provider = devm_of_phy_provider_register(dev, NULL);
> 
> pass 'of_phy_simple_xlate' instead of NULL.
>> +	if (IS_ERR(phy_provider)) {
>> +		dev_err(dev, "failed to register PHY provider\n");
>> +		return PTR_ERR(phy_provider);
>> +	}
>> +
>> +	phy = devm_phy_create(dev, &simple_phy_ops, NULL);
>> +	if (IS_ERR(phy)) {
>> +		dev_err(dev, "failed to create PHY\n");
>> +		return PTR_ERR(phy);
>> +	}
>> +
>> +	sphy->mask = 1;
>> +	sphy->on_value = ~0;
>> +	sphy->off_value = 0;
>> +
>> +	of_property_read_u32(dev->of_node, "mask", &sphy->mask);
> 
> This means your driver will depend on dt data to describe how the register
> should look like. Not a good idea.

I can remove it. No problem. The driver can justt use fixed
mask=1,on-value=1,off-value=0.
Adding mentioned attributes greatly improves driver flexibility
but such a flexibility is not needed currently for s5pv310 phys.

But frankly, I do not exactly follow what is a rationale for such police
in DT. It forces developer to write a lot of redundant code.
Moreover, some clock drivers seams to violate it.
Clock "picochip,pc3x3-gated-clk" is an example. One can find similar tricks
in pinctrl.

>> +	of_property_read_u32(dev->of_node, "on-value", &sphy->on_value);
>> +	of_property_read_u32(dev->of_node, "off-value", &sphy->off_value);
>> +
>> +	phy_set_drvdata(phy, sphy);
>> +
>> +	dev_info(dev, "probe successful\n");
> Lets not make the boot noisy.
> 

ok. s/dev_info/dev_dbg is good enough?

> Thanks
> Kishon
> 

Could you take a look on other patches in this RFC?

Regards,
Tomasz Stanislawski
