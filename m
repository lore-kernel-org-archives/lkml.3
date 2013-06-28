Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab3F1Kdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:33:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42207 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754879Ab3F1Kdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:33:42 -0400
Date: Fri, 28 Jun 2013 11:33:34 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "mturquette@linaro.org"@arm.com
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
Message-ID: <20130628103334.GC2139@e106331-lin.cambridge.arm.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
 <20130628093848.GA2139@e106331-lin.cambridge.arm.com>
 <1372413215.21065.41.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372413215.21065.41.camel@cumari.coelho.fi>
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resending with the correct address for Mike Turquette]

On Fri, Jun 28, 2013 at 10:53:35AM +0100, Luciano Coelho wrote:
> On Fri, 2013-06-28 at 10:38 +0100, Mark Rutland wrote:
> > On Tue, Jun 25, 2013 at 09:35:30AM +0100, Luciano Coelho wrote:
> > > +Optional properties:
> > > +--------------------
> > > +
> > > +- refclock: the internal WLAN reference clock frequency (required for
> > > +  WiLink6 and WiLink7; not used for WiLink8).  Must be one of the
> > > +  following:
> > > +	0 = 19.2 MHz
> > > +	1 = 26.0 MHz
> > > +	2 = 38.4 MHz
> > > +	3 = 52.0 MHz
> > > +	4 = 38.4 MHz, XTAL
> > > +	5 = 26.0 MHz, XTAL
> > > +
> > > +- tcxoclock: the internal WLAN TCXO clock frequency (required for
> > > +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
> > > +  following:
> > > +	0 = 19.200 MHz
> > > +	1 = 26.000 MHz
> > > +	2 = 38.400 MHz
> > > +	3 = 52.000 MHz
> > > +	4 = 16.368 MHz
> > > +	5 = 32.736 MHz
> > > +	6 = 16.800 MHz
> > > +	7 = 33.600 MHz
> > 
> > This looks suspiciously like what we have the common clock bindings for:
> > 
> > refclk {
> > 	compatible = "fixed-clock";
> > 	#clock-cells = <0>;
> > 	clock-frequency = <19200000>;
> > }
> > 
> > wilink {
> > 	compatible = "ti,wilink7";
> > 	interrupt-parent = <&some_interrupt_controller>;
> > 	interrupts = <0 1 1>;
> > 	clocks = <&refclk>, <&refclk>;
> > 	clock-names = "refclk", "txoclk";
> > };
> > 
> > Could you not use them?
> 
> Hmmm... this actually does look good.  But these are internal clocks in
> the modules, they cannot be accessed from outside.  Does it make sense
> to register them with the clock framework?

Given we already have a common way of describing clocks, I think it
makes sense to use it -- people already understand the common bindings,
and it's less code to add add to the kernel. I don't think the fact
these clocks are internal should prevent us from describing them as we
would an external clock.

Perhaps Mike Turquette [Cc'd] has an opinion on the matter. 

Thanks,
Mark.
_______________________________________________
devicetree-discuss mailing list
devicetree-discuss@lists.ozlabs.org
https://lists.ozlabs.org/listinfo/devicetree-discuss

