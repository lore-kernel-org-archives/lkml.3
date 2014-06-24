Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaFXKGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:06:37 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59489 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXKGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:06:33 -0400
Message-ID: <53A94DA1.50703@collabora.co.uk>
Date: Tue, 24 Jun 2014 12:06:25 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        tbroch@chromium.org, Tomasz Figa <t.figa@samsung.com>,
        jwerner@chromium.org
Subject: Re: [RFC 4/4] ARM: dts: exynos5250: Add Spring device tree
References: <1403486483-4063-1-git-send-email-afaerber@suse.de>	<1403486483-4063-5-git-send-email-afaerber@suse.de>	<CAD=FV=WHAqASC+bp8mGVnhfr79F5LapJCTLtSfgUG8XuRUSCqw@mail.gmail.com>	<53A8AE4C.6080702@suse.de> <CAD=FV=W96QpDhh1NSaVwrXYjL6Jr-v4sq1-eRSfT=tErw_KCOQ@mail.gmail.com>
In-Reply-To: <CAD=FV=W96QpDhh1NSaVwrXYjL6Jr-v4sq1-eRSfT=tErw_KCOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 06/24/2014 06:05 AM, Doug Anderson wrote:
> Andreas,
> 
> On Mon, Jun 23, 2014 at 3:46 PM, Andreas Färber <afaerber@suse.de> wrote:
>> Hi Doug,
>>
>> Am 23.06.2014 21:47, schrieb Doug Anderson:
>>> Thanks for posting!  A first pass on this is below...
>>
>> Thanks a lot for your quick review! My first big .dts patch, and no
>> datasheets for the hardware at hand as a user.
>>
>> A first pass of replies to my defense. ;)
>>
>>> On Sun, Jun 22, 2014 at 6:21 PM, Andreas Färber <afaerber@suse.de> wrote:
>> [...]
>>>> diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
>>>> new file mode 100644
>>>> index 0000000..e857d44
>>>> --- /dev/null
>>>> +++ b/arch/arm/boot/dts/exynos5250-spring.dts
>>>> @@ -0,0 +1,556 @@
>>>> +/*
>>>> + * Google Spring board device tree source
>>>> + *
>>>> + * Copyright (c) 2013 Google, Inc
>>>> + * Copyright (c) 2014 SUSE LINUX Products GmbH
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation.
>>>> + */
>>>> +
>>>> +/dts-v1/;
>>>> +#include "exynos5250.dtsi"
>>>> +#include "exynos5250-cros-common.dtsi"
>>>
>>> It is possible we may want to backpedal on the use of
>>> "exynos5250-cros-common.dtsi".  I know that Olof (now CCed) said he
>>> wasn't a fan of how it turned out.
>>>
>>> The original idea was that it should include the arbitrary set of
>>> things that are common between a chunk of Chrome OS boards.  As more
>>> boards were introduced things would need to migrate from the "common"
>>> file to the board files.
>>>
>>> At the moment the current conventional wisdom is that some duplication
>>> is better than the confusing movement of everything back and forth.
>>> See exynos5420-peach-pit and exynos5800-peach-pi in ToT linux-next.
>>>
>>>

Another option is to identify DTS fragments that are common across boards and
create .dtsi files for these specific chunks instead of trying to group all set
of common things on a single .dtsi file.

For example, a quite common design for OMAP2+ based boards is to use a SMSC LAN
chip connected to OMAP's General-Purpose Memory Controller (GPMC). So the
following files were created to reduce DTS duplication:

arch/arm/boot/dts/omap-gpmc-smsc911x.dtsi
arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi

Now that I think about it, is the same that what you did for
arm/boot/dts/cros-ec-keyboard.dtsi.

Maybe splitting exynos5250-cros-common.dtsi in a set of .dtsi files will make it
more flexible/reusable?

>>>> +/ {
>>>> +       model = "Google Spring";
>>>> +       compatible = "google,spring", "samsung,exynos5250", "samsung,exynos5";
>>>> +
>>>> +       pinctrl@11400000 {
>>>
>>> The new best way to do things is to put this down at the bottom.  See
>>> exynos5420-peach-pit as an example:
>>>
>>> &pinctrl_0 {
>>>   ...
>>> }
>>>
>>> Note that I believe it was decided that top-level references like that
>>> should be sorted alphabetically.
>>
>> Thanks for the hint. (My chosen sort order here was by address.)
>>
>>> If you wanted to apply that run to exynos5250-snow I don't think it
>>> would be a terrible idea.
>>
>> I can of course apply changes to Snow, but I cannot test them myself.
> 
> If you want to send up a patch like that I'm happy to give it a once
> over and also to test it.  ...but don't feel obligated
> 
> 
>>>> +               s5m8767_dvs: s5m8767-dvs {
>>>> +                       samsung,pins = "gpd1-0", "gpd1-1", "gpd1-2";
>>>> +                       samsung,pin-function = <0>;
>>>> +                       samsung,pin-pud = <1>;
>>>> +                       samsung,pin-drv = <0>;
>>>> +               };
>>>> +
>>>> +               s5m8767_ds: s5m8767-ds {
>>>> +                       samsung,pins = "gpx2-3", "gpx2-4", "gpx2-5";
>>>> +                       samsung,pin-function = <0>;
>>>> +                       samsung,pin-pud = <1>;
>>>> +                       samsung,pin-drv = <0>;
>>>> +               };
>>>> +
>>>> +               tps65090_irq: tps65090-irq {
>>>> +                       samsung,pins = "gpx2-6";
>>>> +                       samsung,pin-function = <0>;
>>>> +                       samsung,pin-pud = <0>;
>>>> +                       samsung,pin-drv = <0>;
>>>> +               };
>>>> +
>>>> +               s5m8767_irq: s5m8767-irq {
>>>> +                       samsung,pins = "gpx3-2";
>>>> +                       samsung,pin-function = <0>;
>>>> +                       samsung,pin-pud = <0>;
>>>> +                       samsung,pin-drv = <0>;
>>>> +               };
>>>> +
>>>> +               hdmi_hpd_irq: hdmi-hpd-irq {
>>>> +                       samsung,pins = "gpx3-7";
>>>> +                       samsung,pin-function = <0>;
>>>> +                       samsung,pin-pud = <1>;
>>>> +                       samsung,pin-drv = <0>;
>>>> +               };
>>>> +       };
>>>> +
>>>> +       pinctrl@13400000 {
>>>> +               hsic_reset: hsic-reset {
>>>> +                       samsung,pins = "gpe1-0";
>>>> +                       samsung,pin-function = <1>;
>>>> +                       samsung,pin-pud = <0>;
>>>> +                       samsung,pin-drv = <0>;
>>>> +               };
>>>
>>> I'm pretty sure that the HSIC reset needed some funky code to make it
>>> work and I'm not sure what the status of that is upstream
>>
>> Yeah, you mentioned something along those lines. However it's the
>> equivalent of the usb3-vbus-en in -snow.dts. Rename or drop?
> 
> On snow locally I see USB2 vbus is gpx1-1 and USB3 vbus is gpx2-7.  I
> don't see that in spring.
> 
> This will take more time than I have right now to track down.  I added
> Julius to the thread in case he has time to answer and can suggest
> what to do for upstream purposes.  I may be able to look more
> tomorrow.
> 
> You can always send up the next version and include this and we'll
> look at it again.
> 
> 
>>>> +       };
>>>> +
>>>> +       vbat: vbat-fixed-regulator {
>>>> +               compatible = "regulator-fixed";
>>>> +               regulator-name = "vbat-supply";
>>>> +               regulator-boot-on;
>>>> +       };
>>>> +
>>>> +       usb@12000000 {
>>>> +               status = "okay";
>>>> +       };
>>>> +
>>>> +       usb3_vbus_reg: regulator-usb3 {
>>>> +               compatible = "regulator-fixed";
>>>> +               regulator-name = "P5.0V_USB3CON";
>>>> +               regulator-min-microvolt = <5000000>;
>>>> +               regulator-max-microvolt = <5000000>;
>>>> +               gpio = <&gpe1 0 1>;
>>>> +               pinctrl-names = "default";
>>>> +               pinctrl-0 = <&hsic_reset>;
>>>> +               enable-active-high;
>>>> +       };
>>>> +
>>>> +       phy@12100000 {
>>>> +               vbus-supply = <&usb3_vbus_reg>;
>>>> +       };
>>>> +
>>>> +       usb@12110000 {
>>>> +               samsung,vbus-gpio = <&gpx1 1 0>;
>>>> +               status = "okay";
>>>> +       };
>>>> +
>>>> +       usb@12120000 {
>>>> +               status = "okay";
>>>> +       };
>>>> +
>>>> +       mmc@12220000 {
>>>> +               /* MMC2 pins are used as GPIO for eDP bridge control. */
>>>> +               status = "disabled";
>>>> +       };
>>>> +
>>>> +       mmc@12230000 {
>>>> +               status = "disabled";
>>>> +       };
>>>> +
>>>> +       i2c@12C60000 {
>>>> +               max77686@09 {
>>>
>>> There is no max77686 on spring.  It uses s5m8767 in the place of max77686.
>>>
>>> ...you've got "status = disabled", just remove it.
>>
>> That's because it's inherited from exynos5250-cros-common.dtsi.
> 
> Ah, right.  So if we're keeping cros-common the proper thing to do is
> to move it out of cros-common in a patch before this one.  ...but I
> think people might be happier if you simply don't include cros-common.
> 
> 
>> The rtc that the system successfully uses is "s5m-rtc", which I guess is
>> on the s5m8767 then? (Confusing that 3.8 Spring had this rtc node
>> despite Snow's max77686 not having it.)
> 
> I think it's not really supposed to.  It was a bit of a hack to handle
> the fact that the RTC has two different i2c addresses on both the
> 77686 and this PMIC.  The max77686 driver upstream handles it all in
> code and doesn't ask the device tree to list both addresses.
> 
> I think that _upstream_ snow doesn't have the node but _downstream_
> spring might have the node (though having a child of a disabled node
> isn't particularly useful).
> 
> 

Personally I think that "status = [enabled | disabled]" only makes sense for IP
blocks that are part of the SoC but may or may not be used by a board (e.g: i2c
and spi buses, sdhci and usb host controllers, etc).

DTS should be a description of the hardware so I agree that having a disabled
node for a device that is not present in the board is not right.

>>>> +                       #address-cells = <1>;
>>>> +                       #size-cells = <0>;
>>>> +                       status = "disabled";
>>>> +
>>>> +                       rtc {
>>>> +                               reg = <0x6>;
>>>> +                       };
>>>> +               };
>>>> +
>>>> +               s5m8767_pmic@66 {
>>>> +                       compatible = "samsung,s5m8767-pmic";
>>>> +                       reg = <0x66>;
>>>> +                       interrupt-parent = <&gpx3>;
>>>> +                       interrupts = <2 0>;
>>>> +                       pinctrl-names = "default";
>>>> +                       pinctrl-0 = <&s5m8767_irq &s5m8767_dvs &s5m8767_ds>;
>>>> +                       wakeup-source;
>>>> +
>>>> +                       s5m8767,pmic-buck-dvs-gpios = <&gpd1 0 1>, /* DVS1 */
>>>> +                                                     <&gpd1 1 1>, /* DVS2 */
>>>> +                                                     <&gpd1 2 1>; /* DVS3 */
>>>> +
>>>> +                       s5m8767,pmic-buck-ds-gpios = <&gpx2 3 1>, /* SET1 */
>>>> +                                                    <&gpx2 4 1>, /* SET2 */
>>>> +                                                    <&gpx2 5 1>; /* SET3 */
>>>
>>> The final "1" in each of the GPIO specifiers above should be GPIO_ACTIVE_LOW.
>>>
>>>
>>>> +
>>>> +                       /*
>>>> +                        * The following arrays of DVS voltages are not used, since we are
>>>> +                        * not using GPIOs to control PMIC bucks, but they must be defined
>>>> +                        * to please the driver.
>>>> +                        */
>>>> +                       s5m8767,pmic-buck2-dvs-voltage = <1350000>, <1300000>,
>>>> +                                                        <1250000>, <1200000>,
>>>> +                                                        <1150000>, <1100000>,
>>>> +                                                        <1000000>, <950000>;
>>>> +
>>>> +                       s5m8767,pmic-buck3-dvs-voltage = <1100000>, <1100000>,
>>>> +                                                        <1100000>, <1100000>,
>>>> +                                                        <1000000>, <1000000>,
>>>> +                                                        <1000000>, <1000000>;
>>>> +
>>>> +                       s5m8767,pmic-buck4-dvs-voltage = <1200000>, <1200000>,
>>>> +                                                        <1200000>, <1200000>,
>>>> +                                                        <1200000>, <1200000>,
>>>> +                                                        <1200000>, <1200000>;
>>>> +
>>>> +                       clocks {
>>>> +                               compatible = "samsung,s5m8767-clk";
>>>> +                               #clock-cells = <1>;
>>>> +                               clock-output-names = "en32khz_ap",
>>>> +                                                    "en32khz_cp",
>>>> +                                                    "en32khz_bt";
>>>> +                       };
>>>> +
>>>> +                       regulators {
>>>> +                               s5m_ldo4_reg: LDO4 {
>>>> +                                       regulator-name = "P1.0V_LDO_OUT4";
>>>> +                                       regulator-min-microvolt = <1000000>;
>>>> +                                       regulator-max-microvolt = <1000000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <0>;
>>>
>>> I think that "op_mode" here is questionable.  Adding Javier to the
>>> thread who was looking at this for max77802 and possibly max77686.
>>
>> Confirming that this op_mode is present in the original 3.8 device tree.
> 
> Yes and it needs to be handled eventually.  It makes suspend/resume
> work properly.  ...but I think it needs to be thought out better.
> 
> ...but given that other users of this PMIC have it I guess it makes
> sense to leave it in.  Javier was going to try to think it through
> better for max77686 and max77802.
> 
>

The op_mode property is supported in mainline for this driver. I think that is
not a great binding tbh since the property has a generic name while it's
specific to the s5m8767 PMIC. But the driver uses it so makes sense to have it
in the DTS.

I've on my TODO list after the Max 77802 PMIC driver is merged to propose a
property for the generic regulator binding along the lines of what you proposed
in [0].

If a generic property is added to the regulator binding, the
exynos5250-spring.dts can later be changed to use this new property or keep
using the s5m8767 specific one since the driver has to keep supporting it for
backward compatibility.

>> (I used dtc to compile my /proc/device-tree tarball back to .dts, so it
>> has hexadecimal <0x0> but that shouldn't matter to dtc AFAIU.)
>>
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo5_reg: LDO5 {
>>>> +                                       regulator-name = "P1.0V_LDO_OUT5";
>>>> +                                       regulator-min-microvolt = <1000000>;
>>>> +                                       regulator-max-microvolt = <1000000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <0>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo6_reg: LDO6 {
>>>> +                                       regulator-name = "vdd_mydp";
>>>> +                                       regulator-min-microvolt = <1000000>;
>>>> +                                       regulator-max-microvolt = <1000000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo7_reg: LDO7 {
>>>> +                                       regulator-name = "P1.1V_LDO_OUT7";
>>>> +                                       regulator-min-microvolt = <1100000>;
>>>> +                                       regulator-max-microvolt = <1100000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo8_reg: LDO8 {
>>>> +                                       regulator-name = "P1.0V_LDO_OUT8";
>>>> +                                       regulator-min-microvolt = <1000000>;
>>>> +                                       regulator-max-microvolt = <1000000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo10_reg: LDO10 {
>>>> +                                       regulator-name = "P1.8V_LDO_OUT10";
>>>> +                                       regulator-min-microvolt = <1800000>;
>>>> +                                       regulator-max-microvolt = <1800000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo11_reg: LDO11 {
>>>> +                                       regulator-name = "P1.8V_LDO_OUT11";
>>>> +                                       regulator-min-microvolt = <1800000>;
>>>> +                                       regulator-max-microvolt = <1800000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <0>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo12_reg: LDO12 {
>>>> +                                       regulator-name = "P3.0V_LDO_OUT12";
>>>> +                                       regulator-min-microvolt = <3000000>;
>>>> +                                       regulator-max-microvolt = <3000000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo13_reg: LDO13 {
>>>> +                                       regulator-name = "P1.8V_LDO_OUT13";
>>>> +                                       regulator-min-microvolt = <1800000>;
>>>> +                                       regulator-max-microvolt = <1800000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <0>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo14_reg: LDO14 {
>>>> +                                       regulator-name = "P1.8V_LDO_OUT14";
>>>> +                                       regulator-min-microvolt = <1800000>;
>>>> +                                       regulator-max-microvolt = <1800000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo15_reg: LDO15 {
>>>> +                                       regulator-name = "P1.0V_LDO_OUT15";
>>>> +                                       regulator-min-microvolt = <1000000>;
>>>> +                                       regulator-max-microvolt = <1000000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo16_reg: LDO16 {
>>>> +                                       regulator-name = "P1.8V_LDO_OUT16";
>>>> +                                       regulator-min-microvolt = <1800000>;
>>>> +                                       regulator-max-microvolt = <1800000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo17_reg: LDO17 {
>>>> +                                       regulator-name = "P2.8V_LDO_OUT17";
>>>> +                                       regulator-min-microvolt = <2800000>;
>>>> +                                       regulator-max-microvolt = <2800000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <0>;
>>>> +                               };
>>>> +
>>>> +                               s5m_ldo25_reg: LDO25 {
>>>> +                                       regulator-name = "vdd_bridge";
>>>> +                                       regulator-min-microvolt = <1200000>;
>>>> +                                       regulator-max-microvolt = <1200000>;
>>>> +                                       regulator-always-on;
>>>> +                                       op_mode = <1>;
>>>> +                               };
>>>> +
>>>> +                               BUCK1 {
>>>> +                                       regulator-name = "vdd_mif";
>>>> +                                       regulator-min-microvolt = <950000>;
>>>> +                                       regulator-max-microvolt = <1300000>;
>>>> +                                       regulator-always-on;
>>>> +                                       regulator-boot-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               BUCK2 {
>>>> +                                       regulator-name = "vdd_arm";
>>>> +                                       regulator-min-microvolt = <850000>;
>>>> +                                       regulator-max-microvolt = <1350000>;
>>>> +                                       regulator-always-on;
>>>> +                                       regulator-boot-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               BUCK3 {
>>>> +                                       regulator-name = "vdd_int";
>>>> +                                       regulator-min-microvolt = <900000>;
>>>> +                                       regulator-max-microvolt = <1200000>;
>>>> +                                       regulator-always-on;
>>>> +                                       regulator-boot-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               BUCK4 {
>>>> +                                       regulator-name = "vdd_g3d";
>>>> +                                       regulator-min-microvolt = <850000>;
>>>> +                                       regulator-max-microvolt = <1300000>;
>>>> +                                       regulator-boot-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +
>>>> +                               BUCK5 {
>>>> +                                       regulator-name = "P1.8V_BUCK_OUT5";
>>>> +                                       regulator-min-microvolt = <1800000>;
>>>> +                                       regulator-max-microvolt = <1800000>;
>>>> +                                       regulator-always-on;
>>>> +                                       regulator-boot-on;
>>>> +                                       op_mode = <1>;
>>>> +                               };
>>>> +
>>>> +                               BUCK6 {
>>>> +                                       regulator-name = "P1.2V_BUCK_OUT6";
>>>> +                                       regulator-min-microvolt = <1200000>;
>>>> +                                       regulator-max-microvolt = <1200000>;
>>>> +                                       regulator-always-on;
>>>> +                                       regulator-boot>
>>>
>> -on;
>>>> +                                       op_mode = <0>;
>>>> +                               };
>>>> +
>>>> +                               BUCK9 {
>>>> +                                       regulator-name = "vdd_ummc";
>>>> +                                       regulator-min-microvolt = <950000>;
>>>> +                                       regulator-max-microvolt = <3000000>;
>>>> +                                       regulator-always-on;
>>>> +                                       regulator-boot-on;
>>>> +                                       op_mode = <3>;
>>>> +                               };
>>>> +                       };
>>>> +               };
>>>> +       };
>>>> +
>>>> +       i2c@12C70000 {
>>>> +               trackpad {
>>>> +                       status = "disabled";
>>>
>>> Having this bogus entry here doesn't add anything.  Remove it until
>>> the trackpad should be added.  See http://crbug.com/371114 for a
>>> slightly stale bug about trackpad.
>>
>> You misunderstand: This resolves an error about the cypress,cyapa
>> inherited from -cros-common.dtsi. Spring uses a different device and two
>> different I2C addresses.
> 
> Ah, right.  I forgot about cros5250-common.
> 
> 
>> Nodes named trackpad-bootloader and trackpad-alt are prepared here:
>> https://github.com/afaerber/linux/commits/spring-next
> 
> It might work, but you run into pinctrl problems.  You need to put the
> pinctrl node _somewhere_ and if you put it with the trackpad entries
> themselves then you get conflicts.  ...and it doesn't belong in the
> i2c bus (though that's what we have locally in our tree)
> 
> See <http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/30953>
> for some background.
> 
> 
>>>> +               };
>>>> +       };
>>>> +
>>>> +       i2c@12CA0000 {
>>>> +               embedded-controller {
>>>
>>> Add "cros_ec" alias like snow.
>>>
>>>
>>>> +                       compatible = "google,cros-ec-i2c";
>>>> +                       reg = <0x1e>;
>>>> +                       interrupts = <6 0>;
>>>> +                       interrupt-parent = <&gpx1>;
>>>> +                       wakeup-source;
>>>> +
>>>> +                       keyboard-controller {
>>>
>>> Don't include keyboard-controller here.  Add:
>>>
>>> #include "cros-ec-keyboard.dtsi"
>>>
>>> ...at the bottom.  Note that I think that the spring EC has a special
>>> "charger" key that it uses to indicate when a charger was plugged in
>>> and unplugged.  I'm not sure how that will end up getting supported
>>> upstream but you could just leave it out for now.
>>
>> Is there such a pending patch for snow? That's what I modeled after.
> 
> Yeah, and it appears to be in linux-next.  (1a395e3 ARM: dts: Use the
> cros-ec-keyboard fragment in exynos5250-snow).  It actually ended up
> going through the tegra tree since it was in a series with a similar
> tegra change.  I asked Kukjin to pick it up via merge but he didn't
> appear to.
> 
> 
>> Where is cros-ec-keyboard.dtsi? Don't see it in
>> http://git.kernel.org/cgit/linux/kernel/git/kgene/linux-samsung.git/tree/arch/arm/boot/dts?h=for-next
>> or
>> http://git.kernel.org/cgit/linux/kernel/git/kgene/linux-samsung.git/tree/include/dt-bindings?h=for-next
>>
>> Are you proposing I factor it out?
>>
>>>> +                               compatible = "google,cros-ec-keyb";
>>>> +                               keypad,num-rows = <8>;
>>>> +                               keypad,num-columns = <13>;
>>>
>>> Don't you need pinctrl here?
>>
>> The keyboard is usable; what would pinctrl be needed for? There's none
>> in the 3.8 device tree.
> 
> Generally it's good to have the pinctrl listed to configure the IRQ
> properly (get the pulls right).  It might work without it but it's a
> little less ideal I think.
> 
> I see this, right?
> 
>                         pinctrl-names = "default";
>                         pinctrl-0 = <&ec_irq>;
> 
> ...in the downstream "arch/arm/boot/dts/exynos5250-spring.dts"
> 
> 
>>>> +                               google,needs-ghost-filter;
>>>> +                               linux,keymap = <
>>>> +                                       0x0001007d      /* L_META */
>>>> +                                       0x0002003b      /* F1 */
>>>> +                                       0x00030030      /* B */
>>>> +                                       0x00040044      /* F10 */
>>>> +                                       0x00060031      /* N */
>>>> +                                       0x0008000d      /* = */
>>>> +                                       0x000a0064      /* R_ALT */
>>>> +
>>>> +                                       0x01010001      /* ESC */
>>>> +                                       0x0102003e      /* F4 */
>>>> +                                       0x01030022      /* G */
>>>> +                                       0x01040041      /* F7 */
>>>> +                                       0x01060023      /* H */
>>>> +                                       0x01080028      /* ' */
>>>> +                                       0x01090043      /* F9 */
>>>> +                                       0x010b000e      /* BKSPACE */
>>>> +
>>>> +                                       0x0200001d      /* L_CTRL */
>>>> +                                       0x0201000f      /* TAB */
>>>> +                                       0x0202003d      /* F3 */
>>>> +                                       0x02030014      /* T */
>>>> +                                       0x02040040      /* F6 */
>>>> +                                       0x0205001b      /* ] */
>>>> +                                       0x02060015      /* Y */
>>>> +                                       0x02070056      /* 102ND */
>>>> +                                       0x0208001a      /* [ */
>>>> +                                       0x02090042      /* F8 */
>>>> +
>>>> +                                       0x03010029      /* GRAVE */
>>>> +                                       0x0302003c      /* F2 */
>>>> +                                       0x03030006      /* 5 */
>>>> +                                       0x0304003f      /* F5 */
>>>> +                                       0x03060007      /* 6 */
>>>> +                                       0x0308000c      /* - */
>>>> +                                       0x030b002b      /* \ */
>>>> +
>>>> +                                       0x04000061      /* R_CTRL */
>>>> +                                       0x0401001e      /* A */
>>>> +                                       0x04020020      /* D */
>>>> +                                       0x04030021      /* F */
>>>> +                                       0x0404001f      /* S */
>>>> +                                       0x04050025      /* K */
>>>> +                                       0x04060024      /* J */
>>>> +                                       0x04080027      /* ; */
>>>> +                                       0x04090026      /* L */
>>>> +                                       0x040a002b      /* \ */
>>>> +                                       0x040b001c      /* ENTER */
>>>> +
>>>> +                                       0x0501002c      /* Z */
>>>> +                                       0x0502002e      /* C */
>>>> +                                       0x0503002f      /* V */
>>>> +                                       0x0504002d      /* X */
>>>> +                                       0x05050033      /* , */
>>>> +                                       0x05060032      /* M */
>>>> +                                       0x0507002a      /* L_SHIFT */
>>>> +                                       0x05080035      /* / */
>>>> +                                       0x05090034      /* . */
>>>> +                                       0x050B0039      /* SPACE */
>>>> +
>>>> +                                       0x06010002      /* 1 */
>>>> +                                       0x06020004      /* 3 */
>>>> +                                       0x06030005      /* 4 */
>>>> +                                       0x06040003      /* 2 */
>>>> +                                       0x06050009      /* 8 */
>>>> +                                       0x06060008      /* 7 */
>>>> +                                       0x0608000b      /* 0 */
>>>> +                                       0x0609000a      /* 9 */
>>>> +                                       0x060a0038      /* L_ALT */
>>>> +                                       0x060b006c      /* DOWN */
>>>> +                                       0x060c006a      /* RIGHT */
>>>> +
>>>> +                                       0x07010010      /* Q */
>>>> +                                       0x07020012      /* E */
>>>> +                                       0x07030013      /* R */
>>>> +                                       0x07040011      /* W */
>>>> +                                       0x07050017      /* I */
>>>> +                                       0x07060016      /* U */
>>>> +                                       0x07070036      /* R_SHIFT */
>>>> +                                       0x07080019      /* P */
>>>> +                                       0x07090018      /* O */
>>>> +                                       0x070b0067      /* UP */
>>>> +                                       0x070c0069      /* LEFT */
>>>> +                               >;
>>>> +                       };
>>>> +               };
>>>> +
>>>> +               power-regulator {
>>>> +                       compatible = "ti,tps65090";
>>>
>>> I doubt tps65090 will "just work".  Does it?
>>
>> Good question. How to tell? :) Not familiar with clocks and regulators.
>> I don't see the nodes referenced anywhere, so I could just try to drop
>> (as I would, as per my cover letter, propose for anything non-essential
>> that turns controversial).
> 
> What does "dmesg | grep tps65090" say?
> 
> What does this show:
>   grep "" /sys/class/regulator/*/name
> 
> 
>> If we drop tps65090, can we safely drop vbat-fixed-regulator as well?
> 
> Yes
> 
> 
>>> On spring the tps65090 is not directly on the same i2c bus as the EC.
>>> It's actually hidden behind the EC.
>>>
>>> Locally in the ChromeOS tree there appears to be a forked copy of the
>>> 65090 regulator driver that's in use just for spring.  See this from
>>> the ChromeOS 3.8 tree:
>>>
>>> ./drivers/regulator/tps65090-regulator.c
>>> ./drivers/regulator/cros_ec-tps65090.c
>>>
>>> The Spring version of the driver sends EC commands directly to access
>>> the tps65090.
>>>
>>> It is possible (untested) that you could also talk to tps65090 over an
>>> i2c tunnel.  On exynos5420-peach-pit we have a full fledged i2c
>>> tunnel, but you may be able to extend the tunnel to export an i2c
>>> tunnel for spring using something like
>>> <https://chromium-review.googlesource.com/66116>
>>
>> The SBS battery thingy (not in this patch) should also be behind some
>> tunnel. There's none defined in -cros-common.dtsi or in my patch, and
>> still it shows up in dmesg to my surprise, complaining "Couldn't read
>> remote-bus property".
> 
> Might be due to the cros5250-common.  ...but yes, the battery should
> be behind the tunnel too and the patches needed for Spring haven't
> been posted by anyone yet.  I picked up a whole bunch of cros_ec
> cleanup patches and thought that the tunnel patches for spring could
> possible go up after those land.
> 
> 
>>>> +                       reg = <0x48>;
>>>> +
>>>> +                       /*
>>>> +                        * Config irq to disable internal pulls
>>>> +                        * even though we run in polling mode.
>>>> +                        */
>>>> +                       pinctrl-names = "default";
>>>> +                       pinctrl-0 = <&tps65090_irq>;
>>>> +
>>>> +                       vsys1-supply = <&vbat>;
>>>> +                       vsys2-supply = <&vbat>;
>>>> +                       vsys3-supply = <&vbat>;
>>>> +                       infet1-supply = <&vbat>;
>>>> +                       infet2-supply = <&vbat>;
>>>> +                       infet3-supply = <&vbat>;
>>>> +                       infet4-supply = <&vbat>;
>>>> +                       infet5-supply = <&vbat>;
>>>> +                       infet6-supply = <&vbat>;
>>>> +                       infet7-supply = <&vbat>;
>>>> +                       vsys-l1-supply = <&vbat>;
>>>> +                       vsys-l2-supply = <&vbat>;
>>>> +
>>>> +                       regulators {
>>>> +                               fet1 {
>>>> +                                       regulator-name = "vcd_led";
>>>> +                                       regulator-min-microvolt = <12000000>;
>>>> +                                       regulator-max-microvolt = <12000000>;
>>>> +                               };
>>>> +                               fet3 {
>>>> +                                       regulator-name = "wwan_r";
>>>> +                                       regulator-min-microvolt = <3300000>;
>>>> +                                       regulator-max-microvolt = <3300000>;
>>>> +                                       regulator-always-on;
>>>> +                               };
>>>> +                               fet5 {
>>>> +                                       regulator-name = "cam";
>>>> +                                       regulator-min-microvolt = <3300000>;
>>>> +                                       regulator-max-microvolt = <3300000>;
>>>> +                                       regulator-always-on;
>>>> +                               };
>>>> +                               fet6 {
>>>> +                                       regulator-name = "lcd_vdd";
>>>> +                                       regulator-min-microvolt = <3300000>;
>>>> +                                       regulator-max-microvolt = <3300000>;
>>>> +                               };
>>>> +                               fet7 {
>>>> +                                       regulator-name = "ts";
>>>> +                                       regulator-min-microvolt = <5000000>;
>>>> +                                       regulator-max-microvolt = <5000000>;
>>>> +                               };
>>>> +                       };
>>>> +
>>>> +                       charger {
>>>> +                               compatible = "ti,tps65090-charger";
>>>> +                       };
>>>> +               };
>>>> +       };
>>>> +
>>>> +       hdmi {
>>>> +               hdmi-en-supply = <&s5m_ldo8_reg>;
>>>> +               vdd-supply = <&s5m_ldo8_reg>;
>>>> +               vdd_osc-supply = <&s5m_ldo10_reg>;
>>>> +               vdd_pll-supply = <&s5m_ldo8_reg>;
>>>> +       };
>>>> +
>>>> +       fimd@14400000 {
>>>> +               status = "okay";
>>>> +               samsung,invert-vclk;
>>>> +       };
>>>> +
>>>> +       dp-controller@145B0000 {
>>>> +               status = "okay";
>>>> +               pinctrl-names = "default";
>>>> +               pinctrl-0 = <&dp_hpd>;
>>>
>>> This is probably not right.  It looks as if spring uses gpc3-0 for
>>> display port HPD (as a GPIO).  The upstream has this in the
>>> exynos5250-pinctrl.dtsi as a different pin.
>>>
>>> I think you'll need to define your own pinctrl here.
>>>
>>>
>>>> +               samsung,color-space = <0>;
>>>> +               samsung,dynamic-range = <0>;
>>>> +               samsung,ycbcr-coeff = <0>;
>>>> +               samsung,color-depth = <1>;
>>>> +               samsung,link-rate = <0x0a>;
>>>> +               samsung,lane-count = <1>;
>>>> +               samsung,hpd-gpio = <&gpc3 0 0>;
>>>> +
>>>> +               display-timings {
>>>> +                       native-mode = <&timing1>;
>>>> +
>>>> +                       timing1: timing@1 {
>>>> +                               clock-frequency = <70589280>;
>>>> +                               hactive = <1366>;
>>>> +                               vactive = <768>;
>>>> +                               hfront-porch = <40>;
>>>> +                               hback-porch = <40>;
>>>> +                               hsync-len = <32>;
>>>> +                               vback-porch = <10>;
>>>> +                               vfront-porch = <12>;
>>>> +                               vsync-len = <6>;
>>>> +                       };
>>>> +               };
>>>> +       };
>>>> +
>>>> +       fixed-rate-clocks {
>>>> +               xxti {
>>>> +                       compatible = "samsung,clock-xxti";
>>>> +                       clock-frequency = <24000000>;
>>>> +               };
>>>> +       };
>>>> +};
>>
>> Will check on the other suggestions.
> 
> -Doug
> 

Best regards,
Javier

[0]: https://patchwork.kernel.org/patch/1855331/
