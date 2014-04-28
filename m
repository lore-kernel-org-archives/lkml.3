Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaD1FsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 01:48:01 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:64886 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaD1Frz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 01:47:55 -0400
MIME-Version: 1.0
In-Reply-To: <535AE9D2.9070605@gmail.com>
References: <1398153795-28475-1-git-send-email-gautam.vivek@samsung.com>
	<1398153795-28475-2-git-send-email-gautam.vivek@samsung.com>
	<535AE9D2.9070605@gmail.com>
Date: Mon, 28 Apr 2014 11:17:53 +0530
X-Google-Sender-Auth: wEBl12cuLyGwsoJEaY-l0MNg0gw
Message-ID: <CAFp+6iGc1zEqwpbGKejDSDta12ASZ=_P7dFBKmtJpTnE7-VTwA@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, kishon <kishon@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,


On Sat, Apr 26, 2014 at 4:33 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Vivek,
>
>
> On 22.04.2014 10:03, Vivek Gautam wrote:
>>
>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>> The new driver uses the generic PHY framework and will interact
>> with DWC3 controller present on Exynos5 series of SoCs.
>> Thereby, removing old phy-samsung-usb3 driver and related code
>> used untill now which was based on usb/phy framework.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>   .../devicetree/bindings/phy/samsung-phy.txt        |   40 ++
>>   drivers/phy/Kconfig                                |   11 +
>>   drivers/phy/Makefile                               |    1 +
>>   drivers/phy/phy-exynos5-usbdrd.c                   |  629
>> ++++++++++++++++++++
>>   4 files changed, 681 insertions(+)
>>   create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
>>
>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> index b422e38..51efe4c 100644
>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> @@ -114,3 +114,43 @@ Example:
>>                 compatible = "samsung,exynos-sataphy-i2c";
>>                 reg = <0x38>;
>>         };
>> +
>> +Samsung Exynos5 SoC series USB DRD PHY controller

[snip]

>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 3bb05f1..8a5d2b4 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -166,4 +166,15 @@ config PHY_XGENE
>>         help
>>           This option enables support for APM X-Gene SoC multi-purpose
>> PHY.
>>
>> +config PHY_EXYNOS5_USBDRD
>> +       tristate "Exynos5 SoC series USB DRD PHY driver"
>> +       depends on ARCH_EXYNOS5 && OF
>> +       depends on HAS_IOMEM
>> +       select GENERIC_PHY
>> +       select MFD_SYSCON
>> +       help
>> +         Enable USB DRD PHY support for Exynos 5 SoC series.
>> +         This driver provides PHY interface for USB 3.0 DRD controller
>> +         present on Exynos5 SoC series.
>> +
>
>
> I think you should probably keep the entries sorted, so this one should be
> somewhere around other EXYNOS PHYs.

Right, thanks for pointing this out.
Will move this along with other PHY_EXYNOS USB* configs.

>
>
>>   endmenu
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index 2faf78e..31baa0c 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -18,3 +18,4 @@ obj-$(CONFIG_PHY_EXYNOS4210_USB2)     +=
>> phy-exynos4210-usb2.o
>>   obj-$(CONFIG_PHY_EXYNOS4X12_USB2)     += phy-exynos4x12-usb2.o
>>   obj-$(CONFIG_PHY_EXYNOS5250_USB2)     += phy-exynos5250-usb2.o
>>   obj-$(CONFIG_PHY_XGENE)                       += phy-xgene.o
>> +obj-$(CONFIG_PHY_EXYNOS5_USBDRD)       += phy-exynos5-usbdrd.o
>
>
> Ditto.

Ok

>
>
>> diff --git a/drivers/phy/phy-exynos5-usbdrd.c
>> b/drivers/phy/phy-exynos5-usbdrd.c
>> new file mode 100644
>> index 0000000..89d7ae8
>> --- /dev/null
>> +++ b/drivers/phy/phy-exynos5-usbdrd.c
>> @@ -0,0 +1,629 @@
>> +/*
>> + * Samsung EXYNOS5 SoC series USB DRD PHY driver
>> + *
>> + * Phy provider for USB 3.0 DRD controller on Exynos5 SoC series
>> + *
>> + * Copyright (C) 2014 Samsung Electronics Co., Ltd.
>> + * Author: Vivek Gautam <gautam.vivek@samsung.com>
>> + *

[snip]

>> +       } phys[EXYNOS5_DRDPHYS_NUM];
>> +       unsigned int extrefclk;
>> +       struct clk *ref_clk;
>> +       unsigned long ref_rate;
>> +};
>> +
>> +#define to_usbdrd_phy(inst) \
>> +       container_of((inst), struct exynos5_usbdrd_phy, \
>> +                    phys[(inst)->index]);
>
>
> This should be made a static inline to enforce type checking.

Ok, will make this as static inline routine, so that compiler don't
skip type checking.

>
>
>> +
>> +/*
>> + * exynos5_rate_to_clk() converts the supplied clock rate to the value
>> that
>> + * can be written to the phy register.
>> + */
>> +static unsigned int exynos5_rate_to_clk(unsigned long rate)
>> +{
>> +       unsigned int clksel;
>> +
>> +       /* EXYNOS5_FSEL_MASK */
>> +
>> +       switch (rate) {
>> +       case 9600 * KHZ:
>> +               clksel = EXYNOS5_FSEL_9MHZ6;
>> +               break;
>> +       case 10 * MHZ:
>> +               clksel = EXYNOS5_FSEL_10MHZ;
>> +               break;
>> +       case 12 * MHZ:
>> +               clksel = EXYNOS5_FSEL_12MHZ;
>> +               break;
>> +       case 19200 * KHZ:
>> +               clksel = EXYNOS5_FSEL_19MHZ2;
>> +               break;
>> +       case 20 * MHZ:
>> +               clksel = EXYNOS5_FSEL_20MHZ;
>> +               break;
>> +       case 24 * MHZ:
>> +               clksel = EXYNOS5_FSEL_24MHZ;
>> +               break;
>> +       case 50 * MHZ:
>> +               clksel = EXYNOS5_FSEL_50MHZ;
>> +               break;
>> +       default:
>> +               clksel = -EINVAL;
>
>
> Based on clksel (and return value of this function) being unsigned I don't
> think this is a good idea. You should probably adapt the approach from
> Exynos USB 2 PHY, where a function like this return an integer status code
> and returns the bitfield value through a pointer passed as another argument.

Right, will amend this as suggested.

>
>
>> +       }
>> +
>> +       return clksel;
>> +}
>> +
>> +static void exynos5_usbdrd_phy_isol(struct phy_usb_instance *inst,
>> +                                               unsigned int on)
>> +{
>> +       if (!inst->reg_pmu)
>> +               return;
>> +
>> +       regmap_update_bits(inst->reg_pmu, inst->pmu_offset,
>> +                          EXYNOS5_USBDRD_PMU_ISOL, ~on);
>
>
> I don't think ~on is correct here. Even if technically it produces the
> correct value, because bit 0 is being changed here, this should be fixed. If
> EXYNOS5_USBDRD_PMU_ISOL wasn't BIT(0), then always 1 would be written, as on
> could be 0 or 1 and ~on respectively 0xffffffff or 0xfffffffe.
>
> I'd suggest something like this:
>
> unsigned int val = on ? 0 : EXYNOS5_USBDRD_PMU_ISOL;

Sure will change this as suggested.

[snip]

>> +const struct usbdrd_phy_config exynos5_usbdrd_phy_cfg[] = {
>> +       {
>> +               .id             = EXYNOS5_DRDPHY_UTMI,
>> +               .phy_isol       = exynos5_usbdrd_phy_isol,
>> +               .phy_init       = exynos5_usbdrd_utmi_init,
>> +               .set_refclk     = exynos5_usbdrd_utmi_set_refclk,
>> +       },
>> +       {
>> +               .id             = EXYNOS5_DRDPHY_PIPE3,
>> +               .phy_isol       = exynos5_usbdrd_phy_isol,
>> +               .phy_init       = exynos5_usbdrd_pipe3_init,
>> +               .set_refclk     = exynos5_usbdrd_pipe3_set_refclk,
>> +       },
>> +       {},
>
>
> You seem to use a fixed number of PHYs. Do you still need this sentinel
> entry?

Right, we don't need this sentinel entry since we have limited the
number of PHYs to EXYNOS5_DRDPHYS_NUM.
Will remove this.

>
>
>> +};

[snip]

>> +
>> +       match = of_match_node(exynos5_usbdrd_phy_of_match,
>> pdev->dev.of_node);
>> +       if (!match) {
>
>
> This can't happen, otherwise probe() wouldn't be called at all.
True, will remove this check.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
