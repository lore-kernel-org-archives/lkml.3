Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab3IIOyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:54:39 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36042 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3IIOyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:54:36 -0400
MIME-Version: 1.0
In-Reply-To: <87zjrmujzu.fsf@linaro.org>
References: <1378449204-8601-1-git-send-email-koen@dominion.thruhere.net>
	<52297CCF.3090200@ti.com>
	<50E637BB-5A62-477C-B943-9687BC3488BC@dominion.thruhere.net>
	<A83CF7D5-0A26-4740-9F4D-51E5C1592EEF@dominion.thruhere.net>
	<13CEC5D4-080F-499B-8451-7AFEDE065F27@dominion.thruhere.net>
	<87zjrmujzu.fsf@linaro.org>
Date: Mon, 9 Sep 2013 07:54:35 -0700
Message-ID: <CAGa+x85rS5No2gH4jcfxeaEgr2fw=b5_Av5-mMw_6yW04PpL9Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
From: Kevin Hilman <khilman@linaro.org>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: George Cherian <george.cherian@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>, bcousson@baylibre.com,
        Tony Lindgren <tony@atomide.com>, rob.herring@calxeda.com,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, ijc+devicetree@hellion.org.uk,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 7:50 AM, Kevin Hilman <khilman@linaro.org> wrote:
> Koen Kooi <koen@dominion.thruhere.net> writes:
>
>> Op 6 sep. 2013, om 10:51 heeft Koen Kooi <koen@dominion.thruhere.net> het volgende geschreven:
>>
>>>
>>> Op 6 sep. 2013, om 09:10 heeft Koen Kooi <koen@dominion.thruhere.net> het volgende geschreven:
>>>
>>>>
>>>> Op 6 sep. 2013, om 08:57 heeft George Cherian <george.cherian@ti.com> het volgende geschreven:
>>>>
>>>>> On 9/6/2013 12:03 PM, Koen Kooi wrote:
>>>>>> The BeagleBone Black is basically a regular BeagleBone with eMMC and HDMI added,
>>>>>> so create a common dtsi both can use. MMC support for AM335x still isn't in, so
>>>>>> only the LDO change has been added.
>>>>>>
>>>>>> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
>>>>>> ---
>>>>>> .../{am335x-bone.dts => am335x-bone-common.dtsi}   |   3 -
>>>>>> arch/arm/boot/dts/am335x-bone.dts                  | 256 +--------------------
>>>>>> arch/arm/boot/dts/am335x-boneblack.dts             |  18 ++
>>>>>> 3 files changed, 19 insertions(+), 258 deletions(-)
>>>>>> copy arch/arm/boot/dts/{am335x-bone.dts => am335x-bone-common.dtsi} (99%)
>>>>>> create mode 100644 arch/arm/boot/dts/am335x-boneblack.dts
>>>>> How did you test am335x-boneblack.dtb? where are the Makefile changes for boneblack?
>>>>
>>>> Ah, I missed the makefile in my commit. I have a bunch of other patches on top to make more stuff work.
>>>>
>>>> [..]
>>>>
>>>>>>
>>>>>> --- /dev/null
>>>>>> +++ b/arch/arm/boot/dts/am335x-boneblack.dts
>>>>>> @@ -0,0 +1,18 @@
>>>>>> +/*
>>>>>> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
>>>>>> + *
>>>>>> + * This program is free software; you can redistribute it and/or modify
>>>>>> + * it under the terms of the GNU General Public License version 2 as
>>>>>> + * published by the Free Software Foundation.
>>>>>> + */
>>>>>> +/dts-v1/;
>>>>>> +
>>>>>> +#include "am33xx.dtsi"
>>>>> Why cant we add am33xx.dtsi  in am335x-bone-common.dtsi ?
>>>>
>>>> That didn't work when I tried it. It did work before the preprocessor changes when using /include/
>>>>
>>>>>> +#include "am335x-bone-common.dtsi"
>>>>>> +
>>>>>> +&ldo3_reg {
>>>>>> + regulator-min-microvolt = <1800000>;
>>>>>> + regulator-max-microvolt = <1800000>;
>>>>>> + regulator-always-on;
>>>>>> +};
>>>>>> +
>>>>> With this ldo values mmc was not working for me on Boneblack.
>>>>> got it working with
>>>>>
>>>>> &ldo3_reg {
>>>>>    regulator-min-microvolt = <1800000>;
>>>>>    regulator-max-microvolt = <3300000>;
>>>>>    regulator-always-on;
>>>>> };
>>>>
>>>> That LDO is shared, the other consumer will get fried if you use 3.3V. I forget if it's DDR3 or HDMI.
>>>
>>> On the black the LDOs changed, so for mmc (which (*$)@()$@) still isn't in mainline) you need:
>>>
>>> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
>>> index e76d575..ae90a30 100644
>>> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
>>> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
>>> @@ -362,6 +362,13 @@
>>>                        regulator-always-on;
>>>                };
>>>        };
>>> +
>>> +       vmmcsd_fixed: fixedregulator@0 {
>>> +               compatible = "regulator-fixed";
>>> +               regulator-name = "vmmcsd_fixed";
>>> +               regulator-min-microvolt = <3300000>;
>>> +               regulator-max-microvolt = <3300000>;
>>> +       };
>>> };
>>>
>>> &cpsw_emac0 {
>>> diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
>>> index b4237fc..e092a61 100644
>>> --- a/arch/arm/boot/dts/am335x-boneblack.dts
>>> +++ b/arch/arm/boot/dts/am335x-boneblack.dts
>>> @@ -16,7 +16,12 @@
>>>        regulator-always-on;
>>> };
>>>
>>> -&mmc2 {
>>> +&mmc1 {
>>> +       vmmc-supply = <&vmmcsd_fixed>;
>>> +};
>>> +
>>> +&mmc2 {
>>> +       vmmc-supply = <&vmmcsd_fixed>;
>>>        pinctrl-names = "default";
>>>        pinctrl-0 = <&emmc_pins>;
>>>        vmmc-supply = <&ldo3_reg>;
>>
>> And links to all the patches:
>>
>> Card-detect fix: https://github.com/koenkooi/linux/commit/c3c87f330812275ce6aa791e2a81f4c124fe981b
>> Add eMMC DT node: https://github.com/koenkooi/linux/commit/22459b61a7e80e05ab1cd02b9ec0a4467bf9fa4b
>> Fix mmc regulator: https://github.com/koenkooi/linux/commit/8007217893b7d809782e08fa1f0d56b1083ec00d
>>
>> As soon as TI gets their act together and the EDMA/MMC patchset is in
>> Linus' tree I'll rebase and submit the above properly.
>
> In the meantime, can you resubmit the minimal splitup with the LDO
> change?

doh, I see you already did, sorry for the noise.

Kevin
