Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab3GXNKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:10:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43214 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab3GXNKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:10:22 -0400
Message-ID: <51EFD235.4060704@ti.com>
Date: Wed, 24 Jul 2013 16:10:13 +0300
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Uri Yosef <uri.y@variscite.com>
CC: Nishanth Menon <nm@ti.com>, <benoit.cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: dts: twl6030: typical connection to omap4 as a separate
 dtsi file
References: <1374235814-17834-1-git-send-email-ruslan.bilovol@ti.com>	<51E948F0.4070307@ti.com>	<CAB=otbR-n7f=O3+YTPnfO6wRWz2aEcUnbjHoD746GsNgFW3tzQ@mail.gmail.com> <CAHooxd4DB7FT0+mNJVN7f91Ug2y9rOo0n1KenNfLLyN2CvnbSw@mail.gmail.com>
In-Reply-To: <CAHooxd4DB7FT0+mNJVN7f91Ug2y9rOo0n1KenNfLLyN2CvnbSw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.248.4.197]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uri,

On 07/24/2013 10:05 AM, Uri Yosef wrote:
> Hi Ruslan,
>
> Our OMAP4 SOM connection to PMIC is similar to Blaze SDP4430.


Thank you for confirmation, I will add this in next patch series.

Regards,
Ruslan

> Regards,
> Uri Yosef
>
>
>
> On Mon, Jul 22, 2013 at 7:24 PM, Ruslan Bilovol<ruslan.bilovol@ti.com>wrote:
>
>> Hi Nishanth,
>>
>> On Fri, Jul 19, 2013 at 5:10 PM, Nishanth Menon<nm@ti.com>  wrote:
>>> On 07/19/2013 07:10 AM, Ruslan Bilovol wrote:
>>>> The OMAP4 SoC family uses specially-designed
>>>> PMIC (power management IC) companion chip for power
>>>> management needs: TWL6030/TWL6032.
>>>> Therefore there is a typical connection of PMIC to OMAP4
>>>> so we can figure it out into separate .dtsi file
>>>> and do not duplicate over board-specific files.
>>>>
>>>> Tested on OMAP4 SDP board and compile-tested for Panda board
>>>>
>>>> Signed-off-by: Ruslan Bilovol<ruslan.bilovol@ti.com>
>>>> ---
>>>>    arch/arm/boot/dts/omap4-panda-common.dtsi |   21 +---------------
>>>>    arch/arm/boot/dts/omap4-sdp.dts           |   21 +---------------
>>>>    arch/arm/boot/dts/twl6030_omap4.dtsi      |   38
>>>> +++++++++++++++++++++++++++++
>>> arch/arm/boot/dts/omap4-var-som.dts ?
>> There is no muxing for TWL6030 in that file at all, so I didn't add it.
>> Moreover, that file seems to be not maintained since added (just
>> generic fixes or framework changes that came to all other files)
>> Second thing - I do not have schematics and HW for verification.
>> But if somebody from Variscite can confirm that omap4 is typically
>> connected to PMIC, I'm happy to add it as separate patch.
>> So I CCed Uri Yosef who is original author of the omap4-var-som.dts
>>
>> Regards,
>> Ruslan
>>
>>>>    3 files changed, 40 insertions(+), 40 deletions(-)
>>>>    create mode 100644 arch/arm/boot/dts/twl6030_omap4.dtsi
>>>>
>>>> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi
>>>> b/arch/arm/boot/dts/omap4-panda-common.dtsi
>>>> index faa95b5..d796302 100644
>>>> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
>>>> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
>>>> @@ -109,23 +109,9 @@
>>>>          };
>>>>    };
>>>>
>>>> -&omap4_pmx_wkup {
>>>> -       pinctrl-names = "default";
>>>> -       pinctrl-0 =<
>>>> -&twl6030_wkup_pins
>>>> ->;
>>>> -
>>>> -       twl6030_wkup_pins: pinmux_twl6030_wkup_pins {
>>>> -               pinctrl-single,pins =<
>>>> -                       0x14 (PIN_OUTPUT | MUX_MODE2)           /*
>>>> fref_clk0_out.sys_drm_msecure */
>>>> ->;
>>>> -       };
>>>> -};
>>>> -
>>>>    &omap4_pmx_core {
>>>>          pinctrl-names = "default";
>>>>          pinctrl-0 =<
>>>> -&twl6030_pins
>>>>                          &twl6040_pins
>>>>                          &mcpdm_pins
>>>>                          &mcbsp1_pins
>>>> @@ -134,12 +120,6 @@
>>>>                          &hsusbb1_pins
>>>>          >;
>>>>
>>>> -       twl6030_pins: pinmux_twl6030_pins {
>>>> -               pinctrl-single,pins =<
>>>> -                       0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)
>>>> /* sys_nirq1.sys_nirq1 */
>>>> ->;
>>>> -       };
>>>> -
>>>>          twl6040_pins: pinmux_twl6040_pins {
>>>>                  pinctrl-single,pins =<
>>>>                          0xe0 (PIN_OUTPUT | MUX_MODE3)   /*
>>>> hdq_sio.gpio_127 */
>>>> @@ -265,6 +245,7 @@
>>>>    };
>>>>
>>>>    #include "twl6030.dtsi"
>>>> +#include "twl6030_omap4.dtsi"
>>>>
>>>>    &i2c2 {
>>>>          pinctrl-names = "default";
>>>> diff --git a/arch/arm/boot/dts/omap4-sdp.dts
>>>> b/arch/arm/boot/dts/omap4-sdp.dts
>>>> index 7951b4e..91030c3 100644
>>>> --- a/arch/arm/boot/dts/omap4-sdp.dts
>>>> +++ b/arch/arm/boot/dts/omap4-sdp.dts
>>>> @@ -142,23 +142,9 @@
>>>>          };
>>>>    };
>>>>
>>>> -&omap4_pmx_wkup {
>>>> -       pinctrl-names = "default";
>>>> -       pinctrl-0 =<
>>>> -&twl6030_wkup_pins
>>>> ->;
>>>> -
>>>> -       twl6030_wkup_pins: pinmux_twl6030_wkup_pins {
>>>> -               pinctrl-single,pins =<
>>>> -                       0x14 (PIN_OUTPUT | MUX_MODE2)           /*
>>>> fref_clk0_out.sys_drm_msecure */
>>>> ->;
>>>> -       };
>>>> -};
>>>> -
>>>>    &omap4_pmx_core {
>>>>          pinctrl-names = "default";
>>>>          pinctrl-0 =<
>>>> -&twl6030_pins
>>>>                          &twl6040_pins
>>>>                          &mcpdm_pins
>>>>                          &dmic_pins
>>>> @@ -193,12 +179,6 @@
>>>>                  >;
>>>>          };
>>>>
>>>> -       twl6030_pins: pinmux_twl6030_pins {
>>>> -               pinctrl-single,pins =<
>>>> -                       0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)
>>>> /* sys_nirq1.sys_nirq1 */
>>>> ->;
>>>> -       };
>>>> -
>>>>          twl6040_pins: pinmux_twl6040_pins {
>>>>                  pinctrl-single,pins =<
>>>>                          0xe0 (PIN_OUTPUT | MUX_MODE3)           /*
>>>> hdq_sio.gpio_127 */
>>>> @@ -337,6 +317,7 @@
>>>>    };
>>>>
>>>>    #include "twl6030.dtsi"
>>>> +#include "twl6030_omap4.dtsi"
>>>>
>>>>    &i2c2 {
>>>>          pinctrl-names = "default";
>>>> diff --git a/arch/arm/boot/dts/twl6030_omap4.dtsi
>>>> b/arch/arm/boot/dts/twl6030_omap4.dtsi
>>>> new file mode 100644
>>>> index 0000000..a4fa570
>>>> --- /dev/null
>>>> +++ b/arch/arm/boot/dts/twl6030_omap4.dtsi
>>>> @@ -0,0 +1,38 @@
>>>> +/*
>>>> + * Copyright (C) 2013 Texas Instruments Incorporated -
>>>> http://www.ti.com/
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation.
>>>> + */
>>>> +
>>>> +&twl {
>>>> +       /*
>>>> +        * On most OMAP4 platforms, the twl6030 IRQ line is connected
>>>> +        * to the SYS_NIRQ1 line on OMAP and the twl6030 MSECURE line is
>>>> +        * connected to the fref_clk0_out.sys_drm_msecure line.
>>>> +        * Therefore, configure the defaults for the SYS_NIRQ1 and
>>>> +        * fref_clk0_out.sys_drm_msecure pins here.
>>>> +        */
>>>> +       pinctrl-names = "default";
>>>> +       pinctrl-0 =<
>>>> +&twl6030_pins
>>>> +&twl6030_wkup_pins
>>>> +>;
>>>> +};
>>>> +
>>>> +&omap4_pmx_wkup {
>>>> +       twl6030_wkup_pins: pinmux_twl6030_wkup_pins {
>>>> +               pinctrl-single,pins =<
>>>> +                       0x14 (PIN_OUTPUT | MUX_MODE2)           /*
>>>> fref_clk0_out.sys_drm_msecure */
>>>> +>;
>>>> +       };
>>>> +};
>>>> +
>>>> +&omap4_pmx_core {
>>>> +       twl6030_pins: pinmux_twl6030_pins {
>>>> +               pinctrl-single,pins =<
>>>> +                       0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)
>>>> /* sys_nirq1.sys_nirq1 */
>>>> +>;
>>>> +       };
>>>> +};
>>>>
>>>
>>> --
>>> Regards,
>>> Nishanth Menon
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
