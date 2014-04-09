Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbaDIJMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:12:17 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:37256 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaDIJMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <534506B1.4040908@samsung.com>
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
	<1396967856-27470-2-git-send-email-t.stanislaws@samsung.com>
	<534506B1.4040908@samsung.com>
Date: Wed, 9 Apr 2014 14:42:07 +0530
Message-ID: <CAPdUM4M109_kzY6cUMJQPSwgazvWmNDWL1JeXgiqnzvH8dhK2Q@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] phy: Add exynos-simple-phy driver
From: Rahul Sharma <r.sh.open@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 9 April 2014 14:07, Andrzej Hajda <a.hajda@samsung.com> wrote:
> Hi Tomasz,
>
> On 04/08/2014 04:37 PM, Tomasz Stanislawski wrote:
>> Add exynos-simple-phy driver to support a single register
>> PHY interfaces present on Exynos4 SoC.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> ---
>>  .../devicetree/bindings/phy/samsung-phy.txt        |   24 +++
>>  drivers/phy/Kconfig                                |    5 +
>>  drivers/phy/Makefile                               |    1 +
>>  drivers/phy/exynos-simple-phy.c                    |  154 ++++++++++++++++++++
>>  4 files changed, 184 insertions(+)
>>  create mode 100644 drivers/phy/exynos-simple-phy.c
>>
>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> index b422e38..f97c4c3 100644
>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> @@ -114,3 +114,27 @@ Example:
>>               compatible = "samsung,exynos-sataphy-i2c";
>>               reg = <0x38>;
>>       };
>> +
>> +Samsung S5P/EXYNOS SoC series SIMPLE PHY
>> +-------------------------------------------------
>> +
>> +Required properties:
>> +- compatible : should be one of the listed compatibles:
>> +     - "samsung,exynos4210-simple-phy"
>> +     - "samsung,exynos4412-simple-phy"
>> +- reg : offset and length of the register set;
>> +- #phy-cells : from the generic phy bindings, must be 1;
>> +
>> +For "samsung,exynos4210-simple-phy" compatible PHYs the second cell in
>> +the PHY specifier identifies the PHY and its meaning is as follows:
>> +  0 - HDMI PHY,
>> +  1 - DAC PHY,
>> +  2 - ADC PHY,
>> +  3 - PCIE PHY.
>> +  4 - SATA PHY.
>> +
>> +For "samsung,exynos4412-simple-phy" compatible PHYs the second cell in
>> +the PHY specifier identifies the PHY and its meaning is as follows:
>> +  0 - HDMI PHY,
>> +  1 - ADC PHY,
>
> What about using preprocessor macros?
>
>> +
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 3bb05f1..65ab783 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -166,4 +166,9 @@ config PHY_XGENE
>>       help
>>         This option enables support for APM X-Gene SoC multi-purpose PHY.
>>
>> +config EXYNOS_SIMPLE_PHY
>> +     tristate "Exynos Simple PHY driver"
>> +     help
>> +       Support for 1-bit PHY controllers on SoCs from Exynos family.
>> +
>>  endmenu
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index 2faf78e..88c5b60 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -18,3 +18,4 @@ obj-$(CONFIG_PHY_EXYNOS4210_USB2)   += phy-exynos4210-usb2.o
>>  obj-$(CONFIG_PHY_EXYNOS4X12_USB2)    += phy-exynos4x12-usb2.o
>>  obj-$(CONFIG_PHY_EXYNOS5250_USB2)    += phy-exynos5250-usb2.o
>>  obj-$(CONFIG_PHY_XGENE)                      += phy-xgene.o
>> +obj-$(CONFIG_EXYNOS_SIMPLE_PHY)              += exynos-simple-phy.o
>> diff --git a/drivers/phy/exynos-simple-phy.c b/drivers/phy/exynos-simple-phy.c
>> new file mode 100644
>> index 0000000..57ad338
>> --- /dev/null
>> +++ b/drivers/phy/exynos-simple-phy.c
>> @@ -0,0 +1,154 @@
>> +/*
>> + * Exynos Simple PHY driver
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
>> +#include <linux/of_device.h>
>> +#include <linux/phy/phy.h>
>> +
>> +#define EXYNOS_PHY_ENABLE    (1 << 0)
>> +
>> +static int exynos_phy_power_on(struct phy *phy)
>> +{
>> +     void __iomem *reg = phy_get_drvdata(phy);
>> +     u32 val;
>> +
>> +     val = readl(reg);
>> +     val |= EXYNOS_PHY_ENABLE;
>> +     writel(val, reg);
>> +
>> +     return 0;
>> +}
>> +
>> +static int exynos_phy_power_off(struct phy *phy)
>> +{
>> +     void __iomem *reg = phy_get_drvdata(phy);
>> +     u32 val;
>> +
>> +     val = readl(reg);
>> +     val &= ~EXYNOS_PHY_ENABLE;
>> +     writel(val, reg);
>> +
>> +     return 0;
>> +}
>> +
>> +static struct phy_ops exynos_phy_ops = {
>> +     .power_on       = exynos_phy_power_on,
>> +     .power_off      = exynos_phy_power_off,
>> +     .owner          = THIS_MODULE,
>> +};
>> +
>> +static const u32 exynos4210_offsets[] = {
>> +     0x0700, /* HDMI_PHY */
>> +     0x070C, /* DAC_PHY */
>> +     0x0718, /* ADC_PHY */
>> +     0x071C, /* PCIE_PHY */
>> +     0x0720, /* SATA_PHY */
>> +     ~0, /* end mark */
>> +};
>> +
>> +static const u32 exynos4412_offsets[] = {
>> +     0x0700, /* HDMI_PHY */
>> +     0x0718, /* ADC_PHY */
>> +     ~0, /* end mark */
>> +};
>
> Why have you selected only these registers?
> According to specs Exynos 4210 has 9 and 4412 has 7 control registers
> with 'phy-enable' functionality.
> I guess MIPI would require little more work as it has also reset bits,
> but it will be still better than separate driver.
>
>> +
>> +static const struct of_device_id exynos_phy_of_match[] = {
>> +     { .compatible = "samsung,exynos4210-simple-phy",
>> +       .data = exynos4210_offsets},
>> +     { .compatible = "samsung,exynos4412-simple-phy",
>> +       .data = exynos4412_offsets},
>> +     { },
>> +};
>> +MODULE_DEVICE_TABLE(of, exynos_phy_of_match);
>> +
>> +static struct phy *exynos_phy_xlate(struct device *dev,
>> +                                     struct of_phandle_args *args)
>> +{
>> +     struct phy **phys = dev_get_drvdata(dev);
>> +     int index = args->args[0];
>> +     int i;
>> +
>> +     /* verify if index is valid */
>> +     for (i = 0; i <= index; ++i)
>> +             if (!phys[i])
>> +                     return ERR_PTR(-ENODEV);
>> +
>> +     return phys[index];
>> +}
>> +
>> +static int exynos_phy_probe(struct platform_device *pdev)
>> +{
>> +     const struct of_device_id *of_id = of_match_device(
>> +             of_match_ptr(exynos_phy_of_match), &pdev->dev);
>> +     const u32 *offsets = of_id->data;
>> +     int count;
>> +     struct device *dev = &pdev->dev;
>> +     struct phy **phys;
>> +     struct resource *res;
>> +     void __iomem *regs;
>> +     int i;
>> +     struct phy_provider *phy_provider;
>> +
>> +     /* count number of phys to create */
>> +     for (count = 0; offsets[count] != ~0; ++count)
>> +             ;
>
> count = ARRAY_SIZE(offsets) - 1;
>
>> +
>> +     phys = devm_kzalloc(dev, (count + 1) * sizeof(phys[0]), GFP_KERNEL);
>> +     if (!phys)
>> +             return -ENOMEM;
>> +
>> +     dev_set_drvdata(dev, phys);
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +
>> +     regs = devm_ioremap(dev, res->start, res->end - res->start);
>> +     if (!regs) {
>> +             dev_err(dev, "failed to ioremap registers\n");
>> +             return -EFAULT;
>> +     }
>
> Why not devm_ioremap_resource? If not, resource_size function calculates
> length of resource correctly.
>
> Anyway I like the idea of implementing multiple phys in one driver.
> The only drawback I see is that some phys will be created even there are
> no consumers for them. To avoid such situation you can try to use
> lazy approach - create phy only if there is request for it,
> exynos_phy_xlate callback should allow this.
>
> Regards
> Andrzej
>

Idea looks good. How about keeping compatible which is independent
of SoC, something like "samsung,exynos-simple-phy" and provide Reg
and Bit through phy provider node. This way we can avoid SoC specific
hardcoding in phy driver and don't need to look into dt bindings for
each new SoC.

We can use syscon interface to access PMU bits like USB phy.
PMU is already registered as system controller

Regards,
Rahul Sharma.

>> +
>> +     /* NOTE: last entry in phys[] is NULL */
>> +     for (i = 0; i < count; ++i) {
>> +             phys[i] = devm_phy_create(dev, &exynos_phy_ops, NULL);
>> +             if (IS_ERR(phys[i])) {
>> +                     dev_err(dev, "failed to create PHY %d\n", i);
>> +                     return PTR_ERR(phys[i]);
>> +             }
>> +             phy_set_drvdata(phys[i], regs + offsets[i]);
>> +     }
>> +
>> +     phy_provider = devm_of_phy_provider_register(dev, exynos_phy_xlate);
>> +     if (IS_ERR(phy_provider)) {
>> +             dev_err(dev, "failed to register PHY provider\n");
>> +             return PTR_ERR(phy_provider);
>> +     }
>> +
>> +     dev_info(dev, "added %d phys\n", count);
>> +
>> +     return 0;
>> +}
>> +
>> +static struct platform_driver exynos_phy_driver = {
>> +     .probe  = exynos_phy_probe,
>> +     .driver = {
>> +             .of_match_table = exynos_phy_of_match,
>> +             .name  = "exynos-simple-phy",
>> +             .owner = THIS_MODULE,
>> +     }
>> +};
>> +module_platform_driver(exynos_phy_driver);
>> +
>> +MODULE_DESCRIPTION("Exynos Simple PHY driver");
>> +MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
>> +MODULE_LICENSE("GPL v2");
>>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
