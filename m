Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315Ab3DQRLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:11:40 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56107 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935546Ab3DQRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:11:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+GyTgyuk/5hUhbPYI3NV2d
Date: Wed, 17 Apr 2013 10:11:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Roger Quadros <rogerq@ti.com>, Robert Nelson <robertcnelson@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        b-cousson@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: omap3-beagle-xm: Add USB Host support for
 Rev Ax/Bx
Message-ID: <20130417171132.GY10155@atomide.com>
References: <1366029306-1824-1-git-send-email-rogerq@ti.com>
 <516BF4F3.5060904@ti.com>
 <20130417005232.GV10155@atomide.com>
 <CAOCHtYgFnCy5Qn2LeJOK96_NdwzxzVe8Vrb8cL=K9AdzPUtQow@mail.gmail.com>
 <516E5597.7050801@compulab.co.il>
 <516E5F9E.3050204@ti.com>
 <516E94FA.9060606@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <516E94FA.9060606@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Igor Grinberg <grinberg@compulab.co.il> [130417 05:31]:
> On 04/17/13 11:38, Roger Quadros wrote:
> > On 04/17/2013 10:56 AM, Igor Grinberg wrote:
> >> On 04/17/13 04:30, Robert Nelson wrote:
> >>> On Tue, Apr 16, 2013 at 7:52 PM, Tony Lindgren <tony@atomide.com> wrote:
> >>>> * Roger Quadros <rogerq@ti.com> [130415 05:44]:
> >>>>> On 04/15/2013 03:35 PM, Roger Quadros wrote:
> >>>>>> Provide RESET and Power regulators for the USB PHY,
> >>>>>> the USB Host port mode and the PHY device.
> >>>>>>
> >>>>>> Also provide pin multiplexer information for USB host
> >>>>>> pins.
> >>>>>>
> >>>>>> This will not work for Rev Cx boards because of reversed logic
> >>>>>> for USB_POWER_Enable.
> >>>>>>
> >>>>>> CC: Benoît Cousson <b-cousson@ti.com>
> >>>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >>>>>> ---
> >>>>>>  arch/arm/boot/dts/omap3-beagle-xm.dts |   62 +++++++++++++++++++++++++++++++++
> >>>>>>  1 files changed, 62 insertions(+), 0 deletions(-)
> >>>>>>
> >>>>>> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
> >>>>>> index 5a31964..d394c51 100644
> >>>>>> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
> >>>>>> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
> >>>>>> @@ -57,6 +57,60 @@
> >>>>>>             ti,mcbsp = <&mcbsp2>;
> >>>>>>             ti,codec = <&twl_audio>;
> >>>>>>     };
> >>>>>> +
> >>>>>> +   /* HS USB Port 2 RESET */
> >>>>>> +   hsusb2_reset: hsusb2_reset_reg {
> >>>>>> +           compatible = "regulator-fixed";
> >>>>>> +           regulator-name = "hsusb2_reset";
> >>>>>> +           regulator-min-microvolt = <3300000>;
> >>>>>> +           regulator-max-microvolt = <3300000>;
> >>>>>> +           gpio = <&gpio5 19 0>;   /* gpio_147 */
> >>>>>> +           startup-delay-us = <70000>;
> >>>>>> +           enable-active-high;
> >>>>>> +   };
> >>>>>> +
> >>>>>> +   /* HS USB Port 2 Power */
> >>>>>> +   hsusb2_power: hsusb2_power_reg {
> >>>>>> +           compatible = "regulator-fixed";
> >>>>>> +           regulator-name = "hsusb2_vbus";
> >>>>>> +           regulator-min-microvolt = <3300000>;
> >>>>>> +           regulator-max-microvolt = <3300000>;
> >>>>>> +           gpio = <&twl_gpio 18 0>;        /* GPIO LEDA */
> >>>>>> +           startup-delay-us = <70000>;
> >>>>>> +           enable-active-high;     /* FIXME: active-low for Rev. C */
> >>>>>
> >>>>> Benoit & Tony,
> >>>>>
> >>>>> Any ideas how to tackle the reversed logic for Rev. C boards?
> >>>>
> >>>> Sounds like we need a shared omap3-beage.dtsi, then omap3-beagle-xm.dts
> >>>> and omap3-beagle-rev-c.dts. Then xm and rev-c can both include the
> >>>
> >>> Bike-sheding, but we might want to make that "omap3-beagle-xmc.dts" as
> >>> there is the "rev c" variant of the original beagle...
> >>>
> >>> It's too bad we can't read the 3 gpio pin states in the device tree
> >>> and make a decision.
> >>
> >> I would recommend to move the detection to the boot loader and
> >> adjust the DT blob at run time (in the boot loader).
> >> This way, we will not need to deal with all the (sub)revision stuff.
> >>
> >>
> > Moving the detection to bootloader is fine, but modifying the DT at
> > runtime would create a debug/maintenance issue. Instead it could just
> > pick one of the .DTBs and pass it to kernel.
> 
> Like this will not create create any debug/maintenance issues.... ;-)
> We have no problem with debug, as all the DT nodes can be seen in
> both U-Boot (with fdt commands) and Linux through procfs...
> 
> I've just dropped my 2 cents and I don't really insist...

The dynamic configuration from the bootloader can also be done too, I
don't think they are mutually exclusive. 
 
> > Since most users will be using rev-c, I think we should keep the original
> > file 'omap3-beagle-xm.dts" as it is for rev-c boards.
> > I can just create a new dts file for Revisions A and B that will be
> > like so.
> > 
> > +++ b/arch/arm/boot/dts/omap3-beagle-xm-ab.dts
> > @@ -0,0 +1,6 @@
> > +/include/ "omap3-beagle-xm.dts"
> > +
> > +/* On Rev A/B USBHOST_PWR_EN is active high */
> > +&hsusb2_power {
> > +       enable-active-high;
> > +};
> > 
> > Since omap3-beagle and omap3-beagle-xm use different SoC versions and have
> > quite many differences, I don't think it is a good idea to create a common
> > file between the two.

Sounds good to me. But please also add the revision info to the compatible
flags for both .dts files.

Regards,

Tony
