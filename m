Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029Ab3FSHqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:46:16 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54033 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328Ab3FSHqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:46:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+credThYkVh4vo071xPr+2
Date: Wed, 19 Jun 2013 00:46:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] ARM: dts: omap4-panda: Add USB Host support
Message-ID: <20130619074605.GW5523@atomide.com>
References: <1371571487-14389-1-git-send-email-rogerq@ti.com>
 <1371571487-14389-2-git-send-email-rogerq@ti.com>
 <51C106A1.9030001@ti.com>
 <51C15F7E.5020305@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C15F7E.5020305@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130619 00:42]:
> Hi Benoit,
> 
> On 06/19/2013 04:17 AM, Benoit Cousson wrote:
> > Hi Roger,
> > 
> > On 06/18/2013 11:04 AM, Roger Quadros wrote:
> >> Provide the RESET and Power regulators for the USB PHY,
> >> the USB Host port mode and the PHY device.
> >>
> >> Also provide pin multiplexer information for the USB host
> >> pins.
> >>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >> ---
> >>   arch/arm/boot/dts/omap4-panda-common.dtsi |   62 +++++++++++++++++++++++++++++
> >>   1 files changed, 62 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
> >> index 00cbaa5..7a21e8e 100644
> >> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
> >> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
> >> @@ -59,6 +59,42 @@
> >>               "AFML", "Line In",
> >>               "AFMR", "Line In";
> >>       };
> >> +
> >> +    /* HS USB Port 1 RESET */
> >> +    hsusb1_reset: hsusb1_reset_reg {
> >> +        compatible = "regulator-fixed";
> >> +        regulator-name = "hsusb1_reset";
> >> +        regulator-min-microvolt = <3300000>;
> >> +        regulator-max-microvolt = <3300000>;
> >> +        gpio = <&gpio2 30 0>;    /* gpio_62 */
> >> +        startup-delay-us = <70000>;
> >> +        enable-active-high;
> >> +    };
> > 
> > Is this really a regulator? Or just a GPIO line used to reset the USB PHY?
> 
> It is in fact a GPIO line used as reset.
> > 
> > If this is the case, I don't think it should be represented as a regulator.
> 
> Why not? I think it fits very well in the regulator device model. I couldn't find a better
> way to represent this. It gives us a way to specify not only the GPIO line but also
> the polarity. I know mostly reset is active low but still there is flexibility as you never
> know for sure.

I think it's really a mux + a comparator. But from Linux driver point of view
a regulator fits well as we don't have anything better. After all, the pin
voltage changes, and then something can be done based on the comparator
value.
 
> Do you have any better ideas?

We have a similar issue with the MMC1 PBIAS. I think in the long run we
should expand regulator (and possibly pinctrl) framework(s) to handle
comparators. We could just assume that a comparatator is a regulator,
and have a comparator binding that just uses the regulator code.
 
> FYI. The USB PHY driver is already treating reset as a regulator and is into 3.10. Reworking that
> will take some time. Not getting these in will prevent USB host/ethernet support on panda.

Yes and we need to have some solution for v3.11 as we've dropped the
legacy data for omap4. Otherwise things won't work properly.

Regards,

Tony
