Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbaAGJe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:34:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60715 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbaAGJew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:34:52 -0500
Message-ID: <52CBCA16.3000203@ti.com>
Date: Tue, 7 Jan 2014 15:04:14 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yuvaraj Kumar <yuvaraj.cd@gmail.com>
CC: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        sunil joshi <joshi@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        Vasanth Ananthan <vasanth.a@samsung.com>
Subject: Re: [PATCH V4 1/2] Phy: Exynos: Add Exynos5250 sata phy driver
References: <1388408823-4963-1-git-send-email-yuvaraj.cd@samsung.com>	<1388408823-4963-2-git-send-email-yuvaraj.cd@samsung.com>	<52C2A113.507@ti.com> <CAKuRcOLm0paFVs=O_U3ebQ4MgZ14Mhf9Eus3y3Xs+Rc0J-r__A@mail.gmail.com>
In-Reply-To: <CAKuRcOLm0paFVs=O_U3ebQ4MgZ14Mhf9Eus3y3Xs+Rc0J-r__A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 January 2014 07:13 PM, Yuvaraj Kumar wrote:
> On Tue, Dec 31, 2013 at 4:18 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> Hi Yuvaraj,
>>
>>
>> On Monday 30 December 2013 06:37 PM, Yuvaraj Kumar C D wrote:
>>>
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
>>>
>>> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
>>> Signed-off-by: Girish K S <ks.giri@samsung.com>
>>> Signed-off-by: Vasanth Ananthan <vasanth.a@samsung.com>
>>> ---
>>> Changes from V3:
>>>         1.Moved devm_phy_create before to devm_phy_provider_register.
>>>
>>> Changes from V2:
>>>         1.Removed of_match_table
>>>         2.Moved to syscon interface for PMU handling.
>>>
>>> Changes from V1:
>>>         1.Adapted to latest version of Generic PHY framework
>>>         2.Removed exynos_sata_i2c_remove function.
>>>
>>>
>>>   drivers/phy/Kconfig               |   11 ++
>>>   drivers/phy/Makefile              |    1 +
>>>   drivers/phy/exynos5250_phy_i2c.c  |   44 ++++++++
>>>   drivers/phy/sata_phy_exynos5250.c |  220
>>> +++++++++++++++++++++++++++++++++++++
>>>   drivers/phy/sata_phy_exynos5250.h |   35 ++++++
>>>   5 files changed, 311 insertions(+)
>>>   create mode 100644 drivers/phy/exynos5250_phy_i2c.c
>>>   create mode 100644 drivers/phy/sata_phy_exynos5250.c
>>>   create mode 100644 drivers/phy/sata_phy_exynos5250.h
>>>
>>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>>> index d0611b8..6ea124d 100644
>>> --- a/drivers/phy/Kconfig
>>> +++ b/drivers/phy/Kconfig
>>> @@ -57,4 +57,15 @@ config PHY_EXYNOS_DP_VIDEO
>>>         help
>>>           Support for Display Port PHY found on Samsung EXYNOS SoCs.
>>>
>>> +config EXYNOS5250_SATA_PHY
>>> +       tristate "Exynos5250 Sata SerDes/PHY driver"
>>> +       depends on SOC_EXYNOS5250
>>> +       select GENERIC_PHY
>>> +       select MFD_SYSCON if ARCH_EXYNOS5
>>> +       help
>>> +         Enable this to support SATA SerDes/Phy found on Samsung's
>>> +         Exynos5250 based SoCs.This SerDes/Phy supports SATA 1.5 Gb/s,
>>> +         SATA 3.0 Gb/s, SATA 6.0 Gb/s speeds.It supports one SATA host
>>> +         port to accept one SATA device.
>>> +
>>>   endmenu
>>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>>> index 4e4adc9..b73eb73 100644
>>> --- a/drivers/phy/Makefile
>>> +++ b/drivers/phy/Makefile
>>> @@ -8,3 +8,4 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)     +=
>>> phy-exynos-mipi-video.o
>>>   obj-$(CONFIG_PHY_MVEBU_SATA)          += phy-mvebu-sata.o
>>>   obj-$(CONFIG_OMAP_USB2)                       += phy-omap-usb2.o
>>>   obj-$(CONFIG_TWL4030_USB)             += phy-twl4030-usb.o
>>> +obj-$(CONFIG_EXYNOS5250_SATA_PHY)      += sata_phy_exynos5250.o
>>> exynos5250_phy_i2c.o
>>> diff --git a/drivers/phy/exynos5250_phy_i2c.c
>>> b/drivers/phy/exynos5250_phy_i2c.c
>>> new file mode 100644
>>> index 0000000..c0c1150
>>> --- /dev/null
>>> +++ b/drivers/phy/exynos5250_phy_i2c.c
>>> @@ -0,0 +1,44 @@
>>> +/*
>>> + * Copyright (C) 2013 Samsung Electronics Co.Ltd
>>> + * Author:
>>> + *     Yuvaraj C D <yuvaraj.cd@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute  it and/or modify
>>> it
>>> + * under  the terms of  the GNU General  Public License as published by
>>> the
>>> + * Free Software Foundation;  either version 2 of the  License, or (at
>>> your
>>> + * option) any later version.
>>> + *
>>> + */
>>> +
>>> +#include <linux/i2c.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include "sata_phy_exynos5250.h"
>>> +
>>> +static int exynos_sata_i2c_probe(struct i2c_client *client,
>>> +               const struct i2c_device_id *i2c_id)
>>> +{
>>> +       int ret = 0;
>>> +       ret = sataphy_attach_i2c_client(client);
>>> +       if (ret < 0)
>>> +               return ret;
>>> +
>>> +       dev_info(&client->adapter->dev,
>>> +               "attached %s into sataphy i2c adapter successfully\n",
>>> +               client->name);
>>> +
>>> +       return ret;
>>> +}
>>> +
>>> +static const struct i2c_device_id sataphy_i2c_device_match[] = {
>>> +       { "exynos-sataphy-i2c", 0 },
>>> +};
>>> +
>>> +struct i2c_driver sataphy_i2c_driver = {
>>> +       .probe          = exynos_sata_i2c_probe,
>>> +       .id_table       = sataphy_i2c_device_match,
>>> +       .driver   = {
>>> +               .name = "exynos-sataphy-i2c",
>>> +               .owner = THIS_MODULE,
>>> +               },
>>> +};
>>> diff --git a/drivers/phy/sata_phy_exynos5250.c
>>> b/drivers/phy/sata_phy_exynos5250.c
>>> new file mode 100644
>>> index 0000000..0765863
>>> --- /dev/null
>>> +++ b/drivers/phy/sata_phy_exynos5250.c
>>> @@ -0,0 +1,220 @@
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
>>> +#include <linux/clk.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/io.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_address.h>
>>> +#include <linux/phy/phy.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/regmap.h>
>>> +#include <linux/spinlock.h>
>>> +#include <linux/mfd/syscon.h>
>>> +#include "sata_phy_exynos5250.h"
>>> +
>>> +static struct i2c_client *phy_i2c_client;
>>> +
>>> +struct exynos_sata_phy {
>>> +       struct phy *phy;
>>> +       struct clk *phyclk;
>>> +       void __iomem *regs;
>>> +       void __iomem *pmureg;
>>> +};
>>> +
>>> +static bool wait_for_reg_status(void __iomem *base, u32 reg, u32
>>> checkbit,
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
>>> +int sataphy_attach_i2c_client(struct i2c_client *sata_phy)
>>> +{
>>> +       if (!sata_phy)
>>> +               return -EPROBE_DEFER;
>>> +       else
>>> +               phy_i2c_client = sata_phy;
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static int exynos_sata_phy_power_on(struct phy *phy)
>>> +{
>>> +       struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
>>> +
>>> +       if (sata_phy->pmureg)
>>> +               regmap_update_bits(sata_phy->pmureg,
>>> SATAPHY_CONTROL_OFFSET,
>>> +                       EXYNOS5_SATAPHY_PMU_ENABLE, EXYNOS_SATA_PHY_EN);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static int exynos_sata_phy_power_off(struct phy *phy)
>>> +{
>>> +       struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
>>> +
>>> +       if (sata_phy->pmureg)
>>> +               regmap_update_bits(sata_phy->pmureg,
>>> SATAPHY_CONTROL_OFFSET,
>>> +                       EXYNOS5_SATAPHY_PMU_ENABLE, ~EXYNOS_SATA_PHY_EN);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static int exynos_sata_phy_init(struct phy *phy)
>>> +{
>>> +       u32 val = 0;
>>> +       int ret = 0;
>>> +       u8 buf[] = { 0x3A, 0x0B };
>>> +       struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
>>> +
>>> +       if (sata_phy->pmureg)
>>> +               regmap_update_bits(sata_phy->pmureg,
>>> SATAPHY_CONTROL_OFFSET,
>>> +                       EXYNOS5_SATAPHY_PMU_ENABLE, EXYNOS_SATA_PHY_EN);
>>> +
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
>>> +       return (wait_for_reg_status(sata_phy->regs,
>>> EXYNOS5_SATA_PHSATA_STATM,
>>> +               PHSTATM_PLL_LOCKED, 1)) ? 0 : -EINVAL;
>>> +
>>> +}
>>> +
>>> +static struct phy_ops exynos_sata_phy_ops = {
>>> +       .init           = exynos_sata_phy_init,
>>> +       .power_on       = exynos_sata_phy_power_on,
>>> +       .power_off      = exynos_sata_phy_power_off,
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
>>> +       sata->pmureg = syscon_regmap_lookup_by_phandle(dev->of_node,
>>> +                                       "samsung,syscon-phandle");
>>> +       if (!sata->pmureg) {
>>> +               dev_err(dev, "syscon regmap lookup failed.\n");
>>> +               return PTR_ERR(sata->pmureg);
>>> +       }
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
>>> +       sata->phy = devm_phy_create(dev, &exynos_sata_phy_ops, NULL);
>>> +       if (IS_ERR(sata->phy)) {
>>> +               dev_err(dev, "failed to create PHY\n");
>>> +               return PTR_ERR(sata->phy);
>>> +       }
>>> +
>>> +       phy_provider = devm_of_phy_provider_register(dev,
>>> +                                       of_phy_simple_xlate);
>>> +       if (IS_ERR(phy_provider))
>>> +               return PTR_ERR(phy_provider);
>>> +
>>> +       phy_set_drvdata(sata->phy, sata);
>>
>>
>> huh.. phy_provider_register should be after phy_set_drvdata.
> Sorry, I misunderstood.I will address this with the Bartlomiej
> Zolnierkiewicz comments in the next version.

cool.. thanks.

-Kishon
>>
>> Cheers
>> Kishon

