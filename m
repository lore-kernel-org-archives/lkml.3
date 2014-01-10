Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaAJLZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:25:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57984 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaAJLZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:25:43 -0500
Message-ID: <1389353136.5854.13.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v3 1/2] Documentation: Add GPIO reset binding to reset
 binding documentation
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Roger Quadros <rogerq@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Date: Fri, 10 Jan 2014 12:25:36 +0100
In-Reply-To: <201401081708.26679.arnd@arndb.de>
References: <1389179464-11963-1-git-send-email-p.zabel@pengutronix.de>
	 <201401081708.26679.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Am Mittwoch, den 08.01.2014, 17:08 +0100 schrieb Arnd Bergmann:
> On Wednesday 08 January 2014, Philipp Zabel wrote:
> > += GPIO Reset consumers =
> > +
> > +For the common case of reset lines controlled by GPIOs, the GPIO binding
> > +documented in devicetree/bindings/gpio/gpio.txt should be used:
> > +
> > +Required properties:
> > +reset-gpios or         Reset GPIO using standard GPIO bindings,
> > +<name>-reset-gpios:    optionally named to specify the reset line
> > +
> > +Optional properties:
> > +reset-boot-asserted or         Boolean. If set, the corresponding reset is
> > +<name>-reset-boot-asserted:    initially asserted and should be kept that way
> > +                               until released by the driver.
> 
> I don't get this one. Why would you use a different reset binding for the case
> where the reset line is connected to the gpio controller rather than a
> specialized reset controller?
> 
> I was expecting to see the definition of a generic reset controller that
> in turn uses gpio lines, like
> 
> 
>         reset { 
>                 compatible = "gpio-reset";
>                 /* provides three reset lines through these GPIOs */
>                 gpios = <&gpioA 1 &gpioB 7 <gpioD 17>;
>                 #reset-cells = <1>;
>         };
> 
>         foo {
>                 ...
>                 resets = <&reset 0>; /* uses first reset line of the gpio-reset controller */
>         };

That is what I initially proposed...

> I realize it would be a little more verbose, but it also seems more
> regular and wouldn't stand out from the rest of the reset interfaces.

... but it can also be argued that GPIO resets shouldn't stand out from
other GPIOs.

Mark Rutland spoke out against having a 'GPIO reset device' node in the
device tree:

http://comments.gmane.org/gmane.linux.drivers.devicetree/41596

and I see his point. Using different bindings for reset controller IPs
and for single GPIOs better describes the actual hardware and it is less
Linux specific: it still allows an OS without gpio-reset framework to
let each driver handle the GPIO itself.

Also Stephen Warren pointed out that we'll have to support the existing
GPIO bindings anyway: in the meantime there are a lot of GPIO resets in
various device trees that use the GPIO bindings.

regards
Philipp

