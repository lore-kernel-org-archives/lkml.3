Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaFPH12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:27:28 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54034 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753947AbaFPH10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:27:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/bxBMYFV/Em4ELCjLXi+Mu
Date: Mon, 16 Jun 2014 00:27:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Benoit Cousson <bcousson@baylibre.com>, Paul Walmsley <paul@pwsan.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Elliot <jelliott@ti.com>, Darren Etheridge <detheridge@ti.com>,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com
Subject: Re: [PATCH 2/2] arm: dts: add support for AM437x StarterKit
Message-ID: <20140616072720.GX17845@atomide.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
 <1402676147-3711-3-git-send-email-balbi@ti.com>
 <20140613162334.GI8319@saruman.home>
 <20140613163118.GJ8319@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613163118.GJ8319@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140613 09:33]:
> On Fri, Jun 13, 2014 at 11:23:34AM -0500, Felipe Balbi wrote:
> > On Fri, Jun 13, 2014 at 11:15:47AM -0500, Felipe Balbi wrote:
> > > --- /dev/null
> > > +++ b/arch/arm/boot/dts/am437x-sk-evm.dts
> > > @@ -0,0 +1,539 @@
> > > +/*
> > > + * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com/
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + */
> > > +
> > > +/* AM437x SK EVM */
> > > +
> > > +/dts-v1/;
> > > +
> > > +#include "am4372.dtsi"
> > > +#include <dt-bindings/pinctrl/am43xx.h>
> > > +#include <dt-bindings/pwm/pwm.h>
> > > +#include <dt-bindings/gpio/gpio.h>
> > > +#include <dt-bindings/input/input.h>
> > > +
> > > +/ {
> > > +	model = "TI AM437x SK EVM";
> > > +	compatible = "ti,am437x-sk-evm","ti,am4372","ti,am43";
> > > +
> > > +	aliases {
> > > +		display0 = &lcd0;
> > > +	};
> > > +
> > > +	vmmcsd_fixed: fixedregulator-sd {
> > > +		compatible = "regulator-fixed";
> > > +		regulator-name = "vmmcsd_fixed";
> > > +		regulator-min-microvolt = <3300000>;
> > > +		regulator-max-microvolt = <3300000>;
> > > +		enable-active-high;
> > > +	};
> > > +
> > > +	v33_fixed: fixedregulator-v33 {
> > > +		compatible = "regulator-fixed";
> > > +		regulator-name = "v33_fixed";
> > > +		regulator-min-microvolt = <3300000>;
> > > +		regulator-max-microvolt = <3300000>;
> > > +		enable-active-high;
> > > +	};
> > > +
> > > +	v18_fixed: fixedregulator-v18 {
> > > +		compatible = "regulator-fixed";
> > > +		regulator-name = "v18_fixed";
> > > +		regulator-min-microvolt = <1800000>;
> > > +		regulator-max-microvolt = <1800000>;
> > > +		enable-active-high;
> > > +	};

Chances are these are not fixed regulators.. Typically the these
come from external regulators controlled by GPIO pins. Sounds
like you have the schematics so it would be best to verify it.
If they come from something not yet supported, let's at least
document it with comments.

Also looks like all the am43xx boards are using vmmcsd_fixed,
might be worth checking those as well while at it.

Regards,

Tony
