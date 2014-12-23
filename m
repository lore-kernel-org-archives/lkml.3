Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbaLWUtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 15:49:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40894 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaLWUtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 15:49:08 -0500
Date: Tue, 23 Dec 2014 21:49:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, sakari.ailus@iki.fi, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, j.anaszewski@samsung.com,
        apw@canonical.com, joe@perches.com
Subject: Re: [PATCH] media: i2c/adp1653: devicetree support for adp1653
Message-ID: <20141223204903.GA1780@amd>
References: <20141203214641.GA1390@amd>
 <20141223152325.75e8cb4a@concha.lan.sisa.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223152325.75e8cb4a@concha.lan.sisa.samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-12-23 15:23:25, Mauro Carvalho Chehab wrote:
> Em Wed, 3 Dec 2014 22:46:41 +0100
> Pavel Machek <pavel@ucw.cz> escreveu:
> 
> > 
> > We are moving to device tree support on OMAP3, but that currently
> > breaks ADP1653 driver. This adds device tree support, plus required
> > documentation.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> Please be sure to check your patch with checkpatch. There are several
> issues on it:

> WARNING: DT compatible string "adi,adp1653" appears un-documented -- check ./Documentation/devicetree/bindings/
> #78: FILE: arch/arm/boot/dts/omap3-n900.dts:572:
> +		compatible = "adi,adp1653";

Hmm. Take a look at part quoted below. Someone needs to fix
checkpatch. Ccing authors.

> ERROR: trailing whitespace
> WARNING: line over 80 characters

Will fix.

> ERROR: trailing statements should be on next line
> #177: FILE: drivers/media/i2c/adp1653.c:454:
> +	if (!child) return -EINVAL;

I actually did these on purporse... the function is trivial, and by
keeping returns on one line it fits into screen. I see you want it
fixed below, so I'll do that for next version.

								Pavel

> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/adp1653.txt
> > @@ -0,0 +1,38 @@
> > +* Analog Devices ADP1653 flash LED driver
> > +
> > +Required Properties:
> > +
> > +  - compatible: Must contain one of the following
> > +    - "adi,adp1653"
> > +
> > +  - reg: I2C slave address
> > +
> > +  - gpios: References to the GPIO that controls the power for the chip.
> > +
> > +There are two led outputs available - flash and indicator. One led is
> > +represented by one child node, nodes need to be named "flash" and "indicator".
> > +
> > +Required properties of the LED child node:
> > +- max-microamp : see Documentation/devicetree/bindings/leds/common.txt
> > +
> > +Required properties of the flash LED child node:
> > +
> > +- flash-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
> > +- flash-timeout-microsec : see Documentation/devicetree/bindings/leds/common.txt
> > +
> > +Example:
> > +
> > +        adp1653: led-controller@30 {
> > +                compatible = "adi,adp1653";
> > +		reg = <0x30>;
> > +                gpios = <&gpio3 24 GPIO_ACTIVE_HIGH>; /* 88 */
> > +
> > +		flash {
> > +                        flash-timeout-microsec = <500000>;
> > +                        flash-max-microamp = <320000>;
> > +                        max-microamp = <50000>;
> > +		};
> > +                indicator {
> > +                        max-microamp = <17500>;
> > +		};
> > +        };

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
