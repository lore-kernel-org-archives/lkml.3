Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab3LILtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:49:19 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39141 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab3LILtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:49:14 -0500
MIME-Version: 1.0
In-Reply-To: <5292ED4D.7070403@ti.com>
References: <1384158778-27555-1-git-send-email-yuvaraj.cd@samsung.com>
	<1384158778-27555-2-git-send-email-yuvaraj.cd@samsung.com>
	<CAKuRcOKwe5ka__SGAi8CV6L7=M7cJH_yj-WxBE79MC+-p9EUwg@mail.gmail.com>
	<5292ED4D.7070403@ti.com>
Date: Mon, 9 Dec 2013 17:19:13 +0530
Message-ID: <CAKuRcOJ2w6y7d3+GFxTKbEp87hV1mg15CLR+nuU=98M3DmNogA@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] Phy: Exynos: Add Exynos5250 sata phy driver
From: Yuvaraj Kumar <yuvaraj.cd@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, sachin.kamat@linaro.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Christoffer Dall <christoffer.dall@linaro.org>, aditya.ps@samsung.com,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        Vasanth Ananthan <vasanth.a@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 11:55 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Friday 22 November 2013 11:31 AM, Yuvaraj Kumar wrote:
>> Any comments on this patch?
>>
>> On Mon, Nov 11, 2013 at 2:02 PM, Yuvaraj Kumar C D <yuvaraj.cd@gmail.com> wrote:
>>> This patch adds the sata phy driver for Exynos5250.Exynos5250 sata
>>> phy comprises of CMU and TRSV blocks which are of I2C register Map.
>>> So this patch also adds a i2c client driver, which is used configure
>>> the CMU and TRSV block of exynos5250 SATA PHY.
>>>
>>> This patch incorporates the generic phy framework to deal with sata
>>> phy.
>>>
>>> This patch depends on the below patches
>>>         [1].drivers: phy: add generic PHY framework
>>>                 by Kishon Vijay Abraham I<kishon@ti.com>
>>>         [2].ata: ahci_platform: Manage SATA PHY
>>>                 by Roger Quadros <rogerq@ti.com>
>>> Changes from V1:
>>>         1.Adapted to latest version of Generic PHY framework
>>>         2.Removed exynos_sata_i2c_remove function.
>>>
>>> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
>>> Signed-off-by: Girish K S <ks.giri@samsung.com>
>>> Signed-off-by: Vasanth Ananthan <vasanth.a@samsung.com>
>>> ---
>>>  drivers/phy/Kconfig               |    7 ++
>>>  drivers/phy/Makefile              |    1 +
>>>  drivers/phy/exynos5250_phy_i2c.c  |   43 +++++++
>>>  drivers/phy/sata_phy_exynos5250.c |  245 +++++++++++++++++++++++++++++++++++++
>>>  drivers/phy/sata_phy_exynos5250.h |   33 +++++
>>>  5 files changed, 329 insertions(+)
>>>  create mode 100644 drivers/phy/exynos5250_phy_i2c.c
>>>  create mode 100644 drivers/phy/sata_phy_exynos5250.c
>>>  create mode 100644 drivers/phy/sata_phy_exynos5250.h
>>>
>>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>>> index 349bef2..8afd423 100644
>>> --- a/drivers/phy/Kconfig
>>> +++ b/drivers/phy/Kconfig
>>> @@ -15,4 +15,11 @@ config GENERIC_PHY
>>>           phy users can obtain reference to the PHY. All the users of this
>>>           framework should select this config.
>>>
>>> +config EXYNOS5250_SATA_PHY
>>> +       tristate "Exynos5250 Sata SerDes/PHY driver"
>>> +       depends on GENERIC_PHY && SOC_EXYNOS5250
>
> select GENERIC_PHY?
Ok
>>> +       help
>>> +         Support for Exynos5250 sata SerDes/Phy found on Samsung
>>> +         SoCs.
>
> checkpatch gives a warning if it doesn't have atleast 4 help lines :-s
Ok.I will add more description.
>>> +
>>>  endmenu
>>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>>> index 9e9560f..824f47b 100644
>>> --- a/drivers/phy/Makefile
>>> +++ b/drivers/phy/Makefile
>>> @@ -3,3 +3,4 @@
>>>  #
>>>
>>>  obj-$(CONFIG_GENERIC_PHY)      += phy-core.o
>>> +obj-$(CONFIG_EXYNOS5250_SATA_PHY)      += sata_phy_exynos5250.o exynos5250_phy_i2c.o
>>> diff --git a/drivers/phy/exynos5250_phy_i2c.c b/drivers/phy/exynos5250_phy_i2c.c
>>> new file mode 100644
>>> index 0000000..752c8fe
>>> --- /dev/null
>>> +++ b/drivers/phy/exynos5250_phy_i2c.c
>>> @@ -0,0 +1,43 @@
>>> +/*
>>> + * Copyright (C) 2013 Samsung Electronics Co.Ltd
>>> + * Author:
>>> + *     Yuvaraj C D <yuvaraj.cd@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute  it and/or modify it
>>> + * under  the terms of  the GNU General  Public License as published by the
>>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>>> + * option) any later version.
>>> + *
>>> + */
>>> +
>>> +#include <linux/kernel.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/module.h>
>>> +#include "sata_phy_exynos5250.h"
>
> arrange these headers in alphabetical order.. so it's easier to check if a
> header has already been added while adding new headers.
ok.
>>> +
>>> +static int exynos_sata_i2c_probe(struct i2c_client *client,
>>> +               const struct i2c_device_id *i2c_id)
>>> +{
>>> +       sataphy_attach_i2c_client(client);
>>> +
>>> +       dev_info(&client->adapter->dev,
>>> +               "attached %s into sataphy i2c adapter successfully\n",
>>> +               client->name);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static const struct i2c_device_id phy_i2c_device_match[] = {
>>> +       { "sata-phy-i2c", 0 },
>
> pls use .compatible to assign compatible strings. Do you have dt documentation?
it is of the type i2c_device_id.I think above is true for "of_device_id" type.
For some reason i2c client drivers do need ".id_table" rather than
".of_match_table" to get probed.
Please refer http://comments.gmane.org/gmane.linux.drivers.i2c/15169
> It should be *exynos,sata-phy-i2c*.
Ok. I can use "exynos,sata-phy-i2c".
>>> +};
>>> +MODULE_DEVICE_TABLE(of, phy_i2c_device_match);
>>> +
>>> +struct i2c_driver sataphy_i2c_driver = {
>>> +       .probe    = exynos_sata_i2c_probe,
>>> +       .id_table = phy_i2c_device_match,
>>> +       .driver   = {
>>> +               .name = "sata-phy-i2c",
>>> +               .owner = THIS_MODULE,
>>> +               .of_match_table = (void *)phy_i2c_device_match,
>
> use of_match_ptr here.
I think " .of_match_table " not required .With the above reference I
can remove it?
>>> +               },
>>> +};
>>> diff --git a/drivers/phy/sata_phy_exynos5250.c b/drivers/phy/sata_phy_exynos5250.c
>>> new file mode 100644
>>> index 0000000..13f4ce0
>>> --- /dev/null
>>> +++ b/drivers/phy/sata_phy_exynos5250.c
>>> @@ -0,0 +1,245 @@
>>> +/*
>>> + * Samsung SATA SerDes(PHY) driver
>>> + *
>>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>>> + * Authors: Girish K S <ks.giri@samsung.com>
>>> + *         Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#include <linux/delay.h>
>>> +#include <linux/io.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_address.h>
>>> +#include <linux/phy/phy.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/spinlock.h>
>>> +#include <linux/clk.h>
>>> +#include "sata_phy_exynos5250.h"
>
> arrange these in alphabetical order..
Ok .
>>> +
>>> +static struct i2c_client *phy_i2c_client;
>
> using globals :-s
> how are you planning to handle when your SoC have multiple instances of this IP?
This driver is very specific for exynos5250, which has only one SATA
controller and a dedicated i2c controller for SATA PHY communication.
>>> +
>>> +struct exynos_sata_phy {
>>> +       struct phy *phy;
>>> +       struct clk *phyclk;
>>> +       void __iomem *regs;
>>> +       void __iomem *pmureg;
>
> Tomasz mentioned in some other patch about using syscon interface for setting
> pmureg. I think it's applicable here too.
Ok.i will move to regmap framework.
>>> +};
>>> +
>>> +static bool wait_for_reg_status(void __iomem *base, u32 reg, u32 checkbit,
>>> +                               u32 status)
>>> +{
>>> +       unsigned long timeout = jiffies + usecs_to_jiffies(1000);
>>> +       while (time_before(jiffies, timeout)) {
>>> +               if ((readl(base + reg) & checkbit) == status)
>>> +                       return true;
>>> +       }
>>> +       return false;
>>> +}
>>> +
>>> +void sataphy_attach_i2c_client(struct i2c_client *sata_phy)
>
> exynos_sata_phy_i2c_client?
Ok
>>> +{
>>> +       if (sata_phy)
>>> +               phy_i2c_client = sata_phy;
>
> you should return EPROBE_DEFER if sata_phy is NULL so that your i2c client will
> try and attach with this driver again.
Ok
>>> +}
>>> +
>>> +static int __set_phy_state(struct exynos_sata_phy *state, unsigned int on)
>>> +{
>>> +       u32 reg;
>>> +
>>> +       reg = readl(state->pmureg);
>>> +       if (on)
>>> +               reg |= EXYNOS_SATA_PHY_EN;
>>> +       else
>>> +               reg &= ~EXYNOS_SATA_PHY_EN;
>>> +       writel(reg, state->pmureg);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static int exynos_sata_phy_power_on(struct phy *phy)
>>> +{
>>> +       struct exynos_sata_phy *state = phy_get_drvdata(phy);
>>> +
>>> +       return __set_phy_state(state, 1);
>>> +}
>>> +
>>> +static int exynos_sata_phy_power_off(struct phy *phy)
>>> +{
>>> +       struct exynos_sata_phy *state = phy_get_drvdata(phy);
>>> +
>>> +       return __set_phy_state(state, 0);
>>> +}
>>> +
>>> +static int exynos_sataphy_parse_dt(struct device *dev,
>>> +                               struct exynos_sata_phy *sata)
>>> +{
> exynos_sata_phy_parse_dt
>>> +       struct device_node *np = dev->of_node;
>>> +       struct device_node *sataphy_pmu;
>>> +
>>> +       sataphy_pmu = of_get_child_by_name(np, "sataphy-pmu");
>>> +       if (!sataphy_pmu) {
>>> +               dev_err(dev, "No PMU interface for sata-phy\n");
>>> +               return -ENODEV;
>>> +       }
>>> +
>>> +       sata->pmureg = of_iomap(sataphy_pmu, 0);
>>> +       if (!sata->pmureg) {
>>> +               dev_err(dev, "Can't get sata-phy pmu control register\n");
>>> +               of_node_put(sataphy_pmu);
>>> +               return -ENXIO;
>>> +       }
>
> As mentioned earlier you should use syscon interface for setting pmu registers.
Ok.
>>> +
>>> +       of_node_put(sataphy_pmu);
>>> +       return 0;
>>> +}
>>> +
>>> +static int exynos_sata_phy_init(struct phy *phy)
>>> +{
>>> +       u32 val;
>>> +       int ret = 0;
>>> +       u8 buf[] = { 0x3A, 0x0B };
>>> +       struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
>>> +
>>> +       if (!phy_i2c_client)
>>> +               return -EPROBE_DEFER;
>>> +
>>> +       writel(EXYNOS_SATA_PHY_EN, sata_phy->pmureg);
>>> +
>>> +       val = 0;
>>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>>> +
>>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
>>> +       val |= 0xFF;
>>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>>> +
>>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
>>> +       val |= LINK_RESET;
>>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>>> +
>>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
>>> +       val |= RESET_CMN_RST_N;
>>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
>>> +       val &= ~PHCTRLM_REF_RATE;
>>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
>>> +
>>> +       /* High speed enable for Gen3 */
>>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
>>> +       val |= PHCTRLM_HIGH_SPEED;
>>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
>>> +
>>> +       val |= CTRL0_P0_PHY_CALIBRATED_SEL | CTRL0_P0_PHY_CALIBRATED;
>>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_CTRL0);
>>> +
>>> +       writel(0x2, sata_phy->regs + EXYNOS5_SATA_MODE0);
>>> +
>>> +       ret = i2c_master_send(phy_i2c_client, buf, sizeof(buf));
>>> +       if (ret < 0)
>>> +               return -ENXIO;
>
> huh.. Shouldn't this be done in your phy_i2c driver? Then you won't need the
> attach i2c client stuff.
we are configuring the SATA PHY TX and RX Bit Width Select using the
i2c client driver.Unless we reset and configure the SATA PHY
controller,anything on this particular i2c bus is unregonized.
>>> +
>>> +       /* release cmu reset */
>>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
>>> +       val &= ~RESET_CMN_RST_N;
>>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>>> +
>>> +       val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
>>> +       val |= RESET_CMN_RST_N;
>>> +       writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
>>> +
>>> +       return (wait_for_reg_status(sata_phy->regs, EXYNOS5_SATA_PHSATA_STATM,
>>> +               PHSTATM_PLL_LOCKED, 1)) ? 0 : -EINVAL;
>>> +
>>> +}
>>> +
>>> +static struct phy_ops exynos_sata_phy_ops = {
>>> +       .init           = exynos_sata_phy_init,
>>> +       .power_on       = exynos_sata_phy_power_on,
>>> +       .power_off      = exynos_sata_phy_power_off,
>
> you don't need exit callback that is complimentary to init?
>>> +       .owner          = THIS_MODULE,
>>> +};
>>> +
>>> +static int exynos_sata_phy_probe(struct platform_device *pdev)
>>> +{
>>> +       struct exynos_sata_phy *sata;
>>> +       struct device *dev = &pdev->dev;
>>> +       struct resource *res;
>>> +       struct phy_provider *phy_provider;
>>> +       int ret = 0;
>>> +
>>> +       sata = devm_kzalloc(dev, sizeof(*sata), GFP_KERNEL);
>>> +       if (!sata)
>>> +               return -ENOMEM;
>>> +
>>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +
>>> +       sata->regs = devm_ioremap_resource(dev, res);
>>> +       if (IS_ERR(sata->regs))
>>> +               return PTR_ERR(sata->regs);
>>> +
>>> +       dev_set_drvdata(dev, sata);
>>> +
>>> +       if (i2c_add_driver(&sataphy_i2c_driver)) {
>>> +               dev_err(dev, "failed to register sataphy i2c driver\n");
>>> +               return -ENOENT;
>>> +       }
>>> +
>>> +       sata->phyclk = devm_clk_get(dev, "sata_phyctrl");
>>> +       if (IS_ERR(sata->phyclk)) {
>>> +               dev_err(dev, "failed to get clk for PHY\n");
>>> +               return PTR_ERR(sata->phyclk);
>>> +       }
>>> +
>>> +       ret = clk_prepare_enable(sata->phyclk);
>>> +       if (ret < 0) {
>>> +               dev_err(dev, "failed to enable source clk\n");
>>> +               return ret;
>>> +       }
>>> +
>>> +       if (dev->of_node) {
>>> +               ret = exynos_sataphy_parse_dt(dev, sata);
>>> +               if (ret)
>>> +                       return ret;
>>> +       }
>>> +
>>> +       phy_provider = devm_of_phy_provider_register(dev,
>>> +                                       of_phy_simple_xlate);
>>> +       if (IS_ERR(phy_provider))
>>> +               return PTR_ERR(phy_provider);
>>> +
>>> +       sata->phy = devm_phy_create(dev, &exynos_sata_phy_ops, NULL);
>>> +       if (IS_ERR(sata->phy)) {
>>> +               dev_err(dev, "failed to create PHY\n");
>>> +               return PTR_ERR(sata->phy);
>>> +       }
>>> +       phy_set_drvdata(sata->phy, sata);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static const struct of_device_id exynos_sata_phy_of_match[] = {
>>> +       { .compatible = "samsung,exynos5250-sata-phy" },
>>> +       { },
>>> +};
>>> +MODULE_DEVICE_TABLE(of, exynos_sata_phy_of_match);
>>> +
>>> +static struct platform_driver exynos_sata_phy_driver = {
>>> +       .probe  = exynos_sata_phy_probe,
>>> +       .driver = {
>>> +               .of_match_table = exynos_sata_phy_of_match,
>
> use of_match_ptr..
>>> +               .name  = "samsung,sata-phy",
>>> +               .owner = THIS_MODULE,
>>> +       }
>>> +};
>>> +module_platform_driver(exynos_sata_phy_driver);
>>> +
>>> +MODULE_DESCRIPTION("Samsung SerDes PHY driver");
>>> +MODULE_LICENSE("GPL");
>
> GPL v2?
ok
>>> +MODULE_AUTHOR("ks.giri <ks.giri@samsung.com>");
>>> +MODULE_AUTHOR("Yuvaraj C D <yuvaraj.cd@samsung.com>");
>>> diff --git a/drivers/phy/sata_phy_exynos5250.h b/drivers/phy/sata_phy_exynos5250.h
>>> new file mode 100644
>>> index 0000000..64e38a1
>>> --- /dev/null
>>> +++ b/drivers/phy/sata_phy_exynos5250.h
>>> @@ -0,0 +1,33 @@
>>> +/*
>>> + *
>>> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
>>> + * Author:
>>> + *     Yuvaraj Kumar C D<yuvaraj.cd@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute  it and/or modify it
>>> + * under  the terms of  the GNU General  Public License as published by the
>>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>>> + * option) any later version.
>>> + */
>>> +
>>> +#define EXYNOS5_SATA_RESET             0x4
>>> +#define EXYNOS5_SATA_MODE0              0x10
>>> +#define EXYNOS5_SATA_CTRL0              0x14
>>> +#define EXYNOS5_SATA_STAT0             0x18
>>> +#define EXYNOS5_SATA_PHSATA_CTRLM       0xE0
>>> +#define EXYNOS5_SATA_PHSATA_CTRL0       0xE4
>>> +#define EXYNOS5_SATA_PHSATA_STATM       0xF0
>>> +#define EXYNOS5_SATA_PHSTAT0            0xF4
>
> use tabs instead of spaces.. looks like there is some alignment problem.
Ok.
>
> Thanks
> Kishon
