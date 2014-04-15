Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaDOOAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:00:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39591 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbaDOOAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:00:30 -0400
Message-ID: <534D3B58.8010606@ti.com>
Date: Tue, 15 Apr 2014 19:29:52 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@wwwdotorg.org>, <dong.aisheng@linaro.org>,
        <sameo@linux.intel.com>
CC: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>	<1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>	<534BD447.1080909@ti.com>	<CAFp+6iF=SpEax+5KUhZkmtkwp=Pj7LbAHOoySgOwJx_50u6GZQ@mail.gmail.com>	<534BDBBC.5010701@ti.com>	<CAFp+6iFFW8XQg_UtYEZfaiENULZDD8A7_9fr4f2no=qfau7-sQ@mail.gmail.com>	<534BE200.8080009@ti.com> <CAFp+6iHWa8RoO8Ey5B+Lj6Z10ZRJ5+2BDrTD=VNUv5Hw=9gUCg@mail.gmail.com> <534BE77E.5090902@gmail.com>
In-Reply-To: <534BE77E.5090902@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 14 April 2014 07:19 PM, Tomasz Figa wrote:
> On 14.04.2014 15:40, Vivek Gautam wrote:
>> On Mon, Apr 14, 2014 at 6:56 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>>
>>>
>>> On Monday 14 April 2014 06:50 PM, Vivek Gautam wrote:
>>>> On Mon, Apr 14, 2014 at 6:29 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>>>>
>>>>>
>>>>> On Monday 14 April 2014 06:12 PM, Vivek Gautam wrote:
>>>>>> Hi,
>>>>>>
>>>>>>
>>>>>> On Mon, Apr 14, 2014 at 5:57 PM, Kishon Vijay Abraham I <kishon@ti.com>
>>>>>> wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On Tuesday 08 April 2014 08:06 PM, Vivek Gautam wrote:
>>>>>>>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>>>>>>>> The new driver uses the generic PHY framework and will interact
>>>>>>>> with DWC3 controller present on Exynos5 series of SoCs.
>>>>>>>> Thereby, removing old phy-samsung-usb3 driver and related code
>>>>>>>> used untill now which was based on usb/phy framework.
>>>>>>>>
>>>>>>>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>>>>>>> ---
>>>>>>>>   .../devicetree/bindings/phy/samsung-phy.txt        |   42 ++
>>>>>>>>   drivers/phy/Kconfig                                |   11 +
>>>>>>>>   drivers/phy/Makefile                               |    1 +
>>>>>>>>   drivers/phy/phy-exynos5-usbdrd.c                   |  668
>>>>>>>> ++++++++++++++++++++
>>>>>>>>   4 files changed, 722 insertions(+)
>>>>>>>>   create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
>>>>>>>>
>>>>>>>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>>>>>>> b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>>>>>>> index 28f9edb..6d99ba9 100644
>>>>>>>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>>>>>>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>>>>>>> @@ -74,3 +74,45 @@ phy-consumer@12340000 {
>>>>>>>>
>>>>>>>>   Refer to DT bindings documentation of particular PHY consumer devices
>>>>>>>> for more
>>>>>>>>   information about required PHYs and the way of specification.
>>>>>>>> +
>>>>>>>> +Samsung Exynos5 SoC series USB DRD PHY controller
>>>>>>>> +--------------------------------------------------
>>>>>>>> +
>>>>>>>> +Required properties:
>>>>>>>> +- compatible : Should be set to one of the following supported values:
>>>>>>>> +     - "samsung,exynos5250-usbdrd-phy" - for exynos5250 SoC,
>>>>>>>> +     - "samsung,exynos5420-usbdrd-phy" - for exynos5420 SoC.
>>>>>>>> +- reg : Register offset and length of USB DRD PHY register set;
>>>>>>>> +- clocks: Clock IDs array as required by the controller
>>>>>>>> +- clock-names: names of clocks correseponding to IDs in the clock
>>>>>>>> property;
>>>>>>>> +            Required clocks:
>>>>>>>> +     - phy: main PHY clock (same as USB DRD controller i.e. DWC3 IP
>>>>>>>> clock),
>>>>>>>> +            used for register access.
>>>>>>>> +     - ref: PHY's reference clock (usually crystal clock), associated by
>>>>>>>> +            phy name, used to determine bit values for clock settings
>>>>>>>> +            register.
>>>>>>>> +     Additional clock required for Exynos5420:
>>>>>>>> +     - usb30_sclk_100m: Additional special clock used for PHY operation
>>>>>>>> +                        depicted as 'sclk_usbphy30' in CMU of Exynos5420.
>>>>>>>> +- samsung,syscon-phandle: phandle for syscon interface, which is used to
>>>>>>>> +                       control pmu registers for power isolation.
>>>>>>>> +- samsung,pmu-offset: phy power control register offset to
>>>>>>>> pmu-system-controller
>>>>>>>> +                   base.
>>>>>>>> +- #phy-cells : from the generic PHY bindings, must be 1;
>>>>>>>> +
>>>>>>>> +For "samsung,exynos5250-usbdrd-phy" and "samsung,exynos5420-usbdrd-phy"
>>>>>>>> +compatible PHYs, the second cell in the PHY specifier identifies the
>>>>>>>> +PHY id, which is interpreted as follows:
>>>>>>>> +  0 - UTMI+ type phy,
>>>>>>>> +  1 - PIPE3 type phy,
>>>>>>>> +
>>>>>>>> +Example:
>>>>>>>> +     usb3_phy: usbphy@12100000 {
>>>>>>>> +             compatible = "samsung,exynos5250-usbdrd-phy";
>>>>>>>> +             reg = <0x12100000 0x100>;
>>>>>>>> +             clocks = <&clock 286>, <&clock 1>;
>>>>>>>> +             clock-names = "phy", "usb3phy_refclk";
>>>>>>>> +             samsung,syscon-phandle = <&pmu_syscon>;
>>>>>>>> +             samsung,pmu-offset = <0x704>;
>>>>>>>> +             #phy-cells = <1>;
>>>>>>>> +     };
>>>>>>>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>>>>>>>> index 8d3c49c..d955a05 100644
>>>>>>>> --- a/drivers/phy/Kconfig
>>>>>>>> +++ b/drivers/phy/Kconfig
>>>>>>>> @@ -166,4 +166,15 @@ config PHY_XGENE
>>>>>>>>        help
>>>>>>>>          This option enables support for APM X-Gene SoC multi-purpose PHY.
>>>>>>>>
>>>>>>>> +config PHY_EXYNOS5_USBDRD
>>>>>>>> +     tristate "Exynos5 SoC series USB DRD PHY driver"
>>>>>>>> +     depends on ARCH_EXYNOS5 && OF
>>>>>>>> +     depends on HAS_IOMEM
>>>>>>>> +     select GENERIC_PHY
>>>>>>>> +     select MFD_SYSCON
>>>>>>>
>>>>>>> Lets try to avoid select in Kconfig. We've got enough problems with that.
>>>>>>
>>>>>> I hope you meant with "select MFD_SYSCON".
>>>>>> We are referencing the syscon for accessing pmu reg, for which we need
>>>>>> this config to be selected.
>>>>>> Other Exynos phy drivers also need this config and for that they have
>>>>>> selected this.
>>>>>>
>>>>>> Do you want me to do it any other way ?
>>>>>
>>>>> depends on is one option.
>>>>
>>>> Ok, i can see there are places where depends_on MFD_SYSCON is used.
>>>> "drivers/gpu/drm/exynos/Kconfig:60"
>>>>
>>>> so, do you want me to fix at other places too ?
>>>>
>>>> But i also have a question here.
>>>> MFD_SYSCON is a subsystem that's facilitating us in getting our work
>>>> done here by giving an access to pmu_system_controller.
>>>> So unless MFD_SYSCON is exposed, the phy driver will not be exposed to us.
>>>> So is that valid enough really ?
>>>
>>> maybe in the Kconfig for MFD_SYSCON, we can select it if PHY_EXYNOS5_USBDRD is
>>> enabled?
>>>
>>> config MFD_SYSCON
>>> default y if PHY_EXYNOS5_USBDRD
>>
>> Yes, that seems to be one option. But we will end up adding this
>> dependency for all the drivers which want to use syscon.
>>
>> Adding few people who worked on MFS_SYSCON, just to gather ideas.
>>
>> Re-quoting our problem here:
>> "Inside our phy driver we are accessing power mgt unit registers,
>> which we register using syscon in ut device tree.
>> Now we don't want to select MFD_SYSCON from our phy driver, instead
>> want to go 'depend_on' way."
>>
>> So one solution seems to be enabling MFD_SYSCON by default, if any of
>> driver using syscon is enabled.
>> Can we use some other way here ?
> 
> This is an awful idea from maintainability perspective... This means that every
> driver depending on MFD_SYSCON would have to add new "default y if" to
> MFD_SYSCON Kconfig entry. Even with respect to readability, it is more logical
> to have all dependencies of a driver listed in its Kconfig entry.
> 
> Anyway, PHY_EXYNOS5_USBDRD can't work without MFD_SYSCON and somehow this needs
> to be stated. I believe select is the right thing here and I'm not sure why it
> could be a problem. The biggest reason for going this way is that users

'select' selects a module without caring for the dependencies and introduce
compilation warnings. It should always be used with caution.

Thanks
Kishon
