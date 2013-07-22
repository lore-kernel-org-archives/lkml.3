Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab3GVQa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:30:59 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61615 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3GVQa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=otbR-n7f=O3+YTPnfO6wRWz2aEcUnbjHoD746GsNgFW3tzQ@mail.gmail.com>
References: <1374235814-17834-1-git-send-email-ruslan.bilovol@ti.com>
	<51E948F0.4070307@ti.com>
	<CAB=otbR-n7f=O3+YTPnfO6wRWz2aEcUnbjHoD746GsNgFW3tzQ@mail.gmail.com>
Date: Mon, 22 Jul 2013 19:30:55 +0300
X-Google-Sender-Auth: ZuHxoyqG3ZoXr-NVbBe14xOCaEo
Message-ID: <CAB=otbSCzM8U=tJBseeA0MXcmrnp7v_9mj7=hq0=nRUGhYm2mA@mail.gmail.com>
Subject: Re: [PATCH] arm: dts: twl6030: typical connection to omap4 as a
 separate dtsi file
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Nishanth Menon <nm@ti.com>
Cc: benoit.cousson@linaro.org, tony@atomide.com, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        uri.y@variscite.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also CCing correct devicetree list that was changed recently

On Mon, Jul 22, 2013 at 7:24 PM, Ruslan Bilovol <ruslan.bilovol@ti.com> wrote:
> Hi Nishanth,
>
> On Fri, Jul 19, 2013 at 5:10 PM, Nishanth Menon <nm@ti.com> wrote:
>>
>> On 07/19/2013 07:10 AM, Ruslan Bilovol wrote:
>>>
>>> The OMAP4 SoC family uses specially-designed
>>> PMIC (power management IC) companion chip for power
>>> management needs: TWL6030/TWL6032.
>>> Therefore there is a typical connection of PMIC to OMAP4
>>> so we can figure it out into separate .dtsi file
>>> and do not duplicate over board-specific files.
>>>
>>> Tested on OMAP4 SDP board and compile-tested for Panda board
>>>
>>> Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
>>> ---
>>>   arch/arm/boot/dts/omap4-panda-common.dtsi |   21 +---------------
>>>   arch/arm/boot/dts/omap4-sdp.dts           |   21 +---------------
>>>   arch/arm/boot/dts/twl6030_omap4.dtsi      |   38
>>> +++++++++++++++++++++++++++++
>>
>> arch/arm/boot/dts/omap4-var-som.dts ?
>
> There is no muxing for TWL6030 in that file at all, so I didn't add it.
> Moreover, that file seems to be not maintained since added (just
> generic fixes or framework changes that came to all other files)
> Second thing - I do not have schematics and HW for verification.
> But if somebody from Variscite can confirm that omap4 is typically
> connected to PMIC, I'm happy to add it as separate patch.
> So I CCed Uri Yosef who is original author of the omap4-var-som.dts
>
> Regards,
> Ruslan
>
>>
>>>   3 files changed, 40 insertions(+), 40 deletions(-)
>>>   create mode 100644 arch/arm/boot/dts/twl6030_omap4.dtsi
>>>
>>> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi
>>> b/arch/arm/boot/dts/omap4-panda-common.dtsi
>>> index faa95b5..d796302 100644
>>> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
>>> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
>>> @@ -109,23 +109,9 @@
>>>         };
>>>   };
>>>
>>> -&omap4_pmx_wkup {
>>> -       pinctrl-names = "default";
>>> -       pinctrl-0 = <
>>> -                       &twl6030_wkup_pins
>>> -       >;
>>> -
>>> -       twl6030_wkup_pins: pinmux_twl6030_wkup_pins {
>>> -               pinctrl-single,pins = <
>>> -                       0x14 (PIN_OUTPUT | MUX_MODE2)           /*
>>> fref_clk0_out.sys_drm_msecure */
>>> -               >;
>>> -       };
>>> -};
>>> -
>>>   &omap4_pmx_core {
>>>         pinctrl-names = "default";
>>>         pinctrl-0 = <
>>> -                       &twl6030_pins
>>>                         &twl6040_pins
>>>                         &mcpdm_pins
>>>                         &mcbsp1_pins
>>> @@ -134,12 +120,6 @@
>>>                         &hsusbb1_pins
>>>         >;
>>>
>>> -       twl6030_pins: pinmux_twl6030_pins {
>>> -               pinctrl-single,pins = <
>>> -                       0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)
>>> /* sys_nirq1.sys_nirq1 */
>>> -               >;
>>> -       };
>>> -
>>>         twl6040_pins: pinmux_twl6040_pins {
>>>                 pinctrl-single,pins = <
>>>                         0xe0 (PIN_OUTPUT | MUX_MODE3)   /*
>>> hdq_sio.gpio_127 */
>>> @@ -265,6 +245,7 @@
>>>   };
>>>
>>>   #include "twl6030.dtsi"
>>> +#include "twl6030_omap4.dtsi"
>>>
>>>   &i2c2 {
>>>         pinctrl-names = "default";
>>> diff --git a/arch/arm/boot/dts/omap4-sdp.dts
>>> b/arch/arm/boot/dts/omap4-sdp.dts
>>> index 7951b4e..91030c3 100644
>>> --- a/arch/arm/boot/dts/omap4-sdp.dts
>>> +++ b/arch/arm/boot/dts/omap4-sdp.dts
>>> @@ -142,23 +142,9 @@
>>>         };
>>>   };
>>>
>>> -&omap4_pmx_wkup {
>>> -       pinctrl-names = "default";
>>> -       pinctrl-0 = <
>>> -                       &twl6030_wkup_pins
>>> -       >;
>>> -
>>> -       twl6030_wkup_pins: pinmux_twl6030_wkup_pins {
>>> -               pinctrl-single,pins = <
>>> -                       0x14 (PIN_OUTPUT | MUX_MODE2)           /*
>>> fref_clk0_out.sys_drm_msecure */
>>> -               >;
>>> -       };
>>> -};
>>> -
>>>   &omap4_pmx_core {
>>>         pinctrl-names = "default";
>>>         pinctrl-0 = <
>>> -                       &twl6030_pins
>>>                         &twl6040_pins
>>>                         &mcpdm_pins
>>>                         &dmic_pins
>>> @@ -193,12 +179,6 @@
>>>                 >;
>>>         };
>>>
>>> -       twl6030_pins: pinmux_twl6030_pins {
>>> -               pinctrl-single,pins = <
>>> -                       0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)
>>> /* sys_nirq1.sys_nirq1 */
>>> -               >;
>>> -       };
>>> -
>>>         twl6040_pins: pinmux_twl6040_pins {
>>>                 pinctrl-single,pins = <
>>>                         0xe0 (PIN_OUTPUT | MUX_MODE3)           /*
>>> hdq_sio.gpio_127 */
>>> @@ -337,6 +317,7 @@
>>>   };
>>>
>>>   #include "twl6030.dtsi"
>>> +#include "twl6030_omap4.dtsi"
>>>
>>>   &i2c2 {
>>>         pinctrl-names = "default";
>>> diff --git a/arch/arm/boot/dts/twl6030_omap4.dtsi
>>> b/arch/arm/boot/dts/twl6030_omap4.dtsi
>>> new file mode 100644
>>> index 0000000..a4fa570
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/twl6030_omap4.dtsi
>>> @@ -0,0 +1,38 @@
>>> +/*
>>> + * Copyright (C) 2013 Texas Instruments Incorporated -
>>> http://www.ti.com/
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +&twl {
>>> +       /*
>>> +        * On most OMAP4 platforms, the twl6030 IRQ line is connected
>>> +        * to the SYS_NIRQ1 line on OMAP and the twl6030 MSECURE line is
>>> +        * connected to the fref_clk0_out.sys_drm_msecure line.
>>> +        * Therefore, configure the defaults for the SYS_NIRQ1 and
>>> +        * fref_clk0_out.sys_drm_msecure pins here.
>>> +        */
>>> +       pinctrl-names = "default";
>>> +       pinctrl-0 = <
>>> +               &twl6030_pins
>>> +               &twl6030_wkup_pins
>>> +       >;
>>> +};
>>> +
>>> +&omap4_pmx_wkup {
>>> +       twl6030_wkup_pins: pinmux_twl6030_wkup_pins {
>>> +               pinctrl-single,pins = <
>>> +                       0x14 (PIN_OUTPUT | MUX_MODE2)           /*
>>> fref_clk0_out.sys_drm_msecure */
>>> +               >;
>>> +       };
>>> +};
>>> +
>>> +&omap4_pmx_core {
>>> +       twl6030_pins: pinmux_twl6030_pins {
>>> +               pinctrl-single,pins = <
>>> +                       0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)
>>> /* sys_nirq1.sys_nirq1 */
>>> +               >;
>>> +       };
>>> +};
>>>
>>
>>
>> --
>> Regards,
>> Nishanth Menon
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
