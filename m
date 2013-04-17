Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3DQBao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:30:44 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:64971 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab3DQBan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:30:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130417005232.GV10155@atomide.com>
References: <1366029306-1824-1-git-send-email-rogerq@ti.com>
	<516BF4F3.5060904@ti.com>
	<20130417005232.GV10155@atomide.com>
Date: Tue, 16 Apr 2013 20:30:42 -0500
Message-ID: <CAOCHtYgFnCy5Qn2LeJOK96_NdwzxzVe8Vrb8cL=K9AdzPUtQow@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: omap3-beagle-xm: Add USB Host support for Rev Ax/Bx
From: Robert Nelson <robertcnelson@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Roger Quadros <rogerq@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, b-cousson@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 7:52 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Roger Quadros <rogerq@ti.com> [130415 05:44]:
>> On 04/15/2013 03:35 PM, Roger Quadros wrote:
>> > Provide RESET and Power regulators for the USB PHY,
>> > the USB Host port mode and the PHY device.
>> >
>> > Also provide pin multiplexer information for USB host
>> > pins.
>> >
>> > This will not work for Rev Cx boards because of reversed logic
>> > for USB_POWER_Enable.
>> >
>> > CC: Benoît Cousson <b-cousson@ti.com>
>> > Signed-off-by: Roger Quadros <rogerq@ti.com>
>> > ---
>> >  arch/arm/boot/dts/omap3-beagle-xm.dts |   62 +++++++++++++++++++++++++++++++++
>> >  1 files changed, 62 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
>> > index 5a31964..d394c51 100644
>> > --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
>> > +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
>> > @@ -57,6 +57,60 @@
>> >             ti,mcbsp = <&mcbsp2>;
>> >             ti,codec = <&twl_audio>;
>> >     };
>> > +
>> > +   /* HS USB Port 2 RESET */
>> > +   hsusb2_reset: hsusb2_reset_reg {
>> > +           compatible = "regulator-fixed";
>> > +           regulator-name = "hsusb2_reset";
>> > +           regulator-min-microvolt = <3300000>;
>> > +           regulator-max-microvolt = <3300000>;
>> > +           gpio = <&gpio5 19 0>;   /* gpio_147 */
>> > +           startup-delay-us = <70000>;
>> > +           enable-active-high;
>> > +   };
>> > +
>> > +   /* HS USB Port 2 Power */
>> > +   hsusb2_power: hsusb2_power_reg {
>> > +           compatible = "regulator-fixed";
>> > +           regulator-name = "hsusb2_vbus";
>> > +           regulator-min-microvolt = <3300000>;
>> > +           regulator-max-microvolt = <3300000>;
>> > +           gpio = <&twl_gpio 18 0>;        /* GPIO LEDA */
>> > +           startup-delay-us = <70000>;
>> > +           enable-active-high;     /* FIXME: active-low for Rev. C */
>>
>> Benoit & Tony,
>>
>> Any ideas how to tackle the reversed logic for Rev. C boards?
>
> Sounds like we need a shared omap3-beage.dtsi, then omap3-beagle-xm.dts
> and omap3-beagle-rev-c.dts. Then xm and rev-c can both include the

Bike-sheding, but we might want to make that "omap3-beagle-xmc.dts" as
there is the "rev c" variant of the original beagle...

It's too bad we can't read the 3 gpio pin states in the device tree
and make a decision.

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
