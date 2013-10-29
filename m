Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3J2Kvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:51:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58359 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3J2Kvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:51:31 -0400
Message-ID: <526F9329.7090901@ti.com>
Date: Tue, 29 Oct 2013 16:21:21 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: "'Vivek Gautam'" <gautamvivek1987@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm@vger.kernel.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Mateusz Krawczuk'" <mat.krawczuk@gmail.com>
Subject: Re: [RFC PATCH 2/5] phy: Add WIP Exynos 5250 support to the Exynos
 USB PHY driver
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com> <1382710529-12082-3-git-send-email-k.debski@samsung.com> <526A91B9.1060901@ti.com> <CAFp+6iF2agMNaNhg=6Xx79erV45V=TobH=+GdziFx8j70g8MDw@mail.gmail.com> <526F8609.5010106@ti.com> <030b01ced48f$b1e17e00$15a47a00$%debski@samsung.com>
In-Reply-To: <030b01ced48f$b1e17e00$15a47a00$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 29 October 2013 03:44 PM, Kamil Debski wrote:
> Hi,
> 
>> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
>> Sent: Tuesday, October 29, 2013 10:55 AM
>>
>> Hi,
>>
>> On Monday 28 October 2013 08:11 PM, Vivek Gautam wrote:
>>> Hi Kishon,
>>>
>>>
>>> On Fri, Oct 25, 2013 at 9:13 PM, Kishon Vijay Abraham I
>> <kishon@ti.com> wrote:
>>>> Hi,
>>>>
>>>> On Friday 25 October 2013 07:45 PM, Kamil Debski wrote:
>>>>> Add support for Exynos 5250. This is work-in-progress commit. Not
>>>>> for merging.
>>>>>
>>>>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
>>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>> ---
>>>>>  drivers/phy/Kconfig              |    7 +
>>>>>  drivers/phy/Makefile             |    1 +
>>>>>  drivers/phy/phy-exynos-usb.c     |   10 +
>>>>>  drivers/phy/phy-exynos-usb.h     |    1 +
>>>>>  drivers/phy/phy-exynos5250-usb.c |  411
>>>>> ++++++++++++++++++++++++++++++++++++++
>>>>>  5 files changed, 430 insertions(+)
>>>>>  create mode 100644 drivers/phy/phy-exynos5250-usb.c
>>>>>
>>>>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig index
>>>>> 2f7ac0a..0f598d0 100644
>>>>> --- a/drivers/phy/Kconfig
>>>>> +++ b/drivers/phy/Kconfig
>>>>> @@ -36,4 +36,11 @@ config PHY_EXYNOS4212_USB
>>>>>       help
>>>>>         Enable USB PHY support for Exynos 4212
>>>>>
>>>>> +config PHY_EXYNOS5250_USB
>>>>> +     bool "Support for Exynos 5250"
>>>>> +     depends on PHY_EXYNOS_USB
>>>>
>>>> This should be a separate driver. Not necessary to use
>> PHY_EXYNOS_USB.
>>>>> +     depends on SOC_EXYNOS5250
>>>>> +     help
>>>>> +       Enable USB PHY support for Exynos 5250
>>>>> +
>>>>>  endmenu
>>>>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile index
>>>>> ca3dc82..0dff0dd 100644
>>>>> --- a/drivers/phy/Makefile
>>>>> +++ b/drivers/phy/Makefile
>>>>> @@ -6,3 +6,4 @@ obj-$(CONFIG_GENERIC_PHY)     += phy-core.o
>>>>>  obj-$(CONFIG_PHY_EXYNOS_USB)         += phy-exynos-usb.o
>>>>>  obj-$(CONFIG_PHY_EXYNOS4210_USB)     += phy-exynos4210-usb.o
>>>>>  obj-$(CONFIG_PHY_EXYNOS4212_USB)     += phy-exynos4212-usb.o
>>>>> +obj-$(CONFIG_PHY_EXYNOS5250_USB)     += phy-exynos5250-usb.o
>>>>> diff --git a/drivers/phy/phy-exynos-usb.c
>>>>> b/drivers/phy/phy-exynos-usb.c index d4a26df..172b774 100644
>>>>> --- a/drivers/phy/phy-exynos-usb.c
>>>>> +++ b/drivers/phy/phy-exynos-usb.c
>>>>> @@ -212,6 +212,10 @@ extern const struct uphy_config
>>>>> exynos4210_uphy_config;  extern const struct uphy_config
>>>>> exynos4212_uphy_config;  #endif
>>>>>
>>>>> +#ifdef CONFIG_PHY_EXYNOS5250_USB
>>>>> +extern const struct uphy_config exynos5250_uphy_config; #endif
>>>>> +
>>>>>  static const struct of_device_id exynos_uphy_of_match[] =
>> {  #ifdef
>>>>> CONFIG_PHY_EXYNOS4210_USB
>>>>>       {
>>>>> @@ -225,6 +229,12 @@ static const struct of_device_id
>> exynos_uphy_of_match[] = {
>>>>>               .data = &exynos4212_uphy_config,
>>>>>       },
>>>>>  #endif
>>>>> +#ifdef CONFIG_PHY_EXYNOS5250_USB
>>>>> +     {
>>>>> +             .compatible = "samsung,exynos5250-usbphy",
>>>>> +             .data = &exynos5250_uphy_config,
>>>>> +     },
>>>>> +#endif
>>>>>       { },
>>>>>  };
>>>>>
>>>>> diff --git a/drivers/phy/phy-exynos-usb.h
>>>>> b/drivers/phy/phy-exynos-usb.h index f45cb3c..a9febfa 100644
>>>>> --- a/drivers/phy/phy-exynos-usb.h
>>>>> +++ b/drivers/phy/phy-exynos-usb.h
>>>>> @@ -42,6 +42,7 @@ enum samsung_cpu_type {
>>>>>       TYPE_S3C64XX,
>>>>>       TYPE_EXYNOS4210,
>>>>>       TYPE_EXYNOS4212,
>>>>> +     TYPE_EXYNOS5250,
>>>>
>>>> No cpu types here.
>>>
>>> One question here.
>>> In case we move to single driver for Exynos4 SoCs (4210, 4212 and
>> 4412
>>> later) as well as S5PV210,
>>> there will be certain things changing from one SoC to another, how
>>> should we target that in case we don't have CPU types ?
>>> May be i am misinterpreting your suggestion ?
>>
>> We should be using the IP revision register or check for compatible
>> values.
>>
> 
> In case of this driver the compatible is checked. Maybe it is not as
> straight forward, but the choice is based on compatible value.
> Compatible is matched to an appropriate data entry in the of_device_id
> table. The data entry contains a cpu field which contains the information
> which PHY version we have. Maybe the "cpu" name is confusing and should be
> changed to something like "version" or "revision".

you don't have a revision register in the PHY IP which can be used?
> 
> For example:
> "samsung,exynos4212-usbphy" compatible is matched to exynos4212_uphy_config
> via data field of of_device_id, and the cpu field of exynos4212_uphy_config
> is equal to TYPE_EXYNOS4212.
> This way in the code all what is needed is to check the value of cpu field.
> It already got matched through the compatible.
> 
> Still, Tomasz Figa's idea sound good - using a boolean flag
> "has_mode_switch".

hmm, could be.

Thanks
Kishon
