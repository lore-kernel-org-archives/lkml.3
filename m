Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3F1Jxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:53:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32900 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab3F1Jxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:53:49 -0400
Message-ID: <1372413215.21065.41.camel@cumari.coelho.fi>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
From: Luciano Coelho <coelho@ti.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm@vger.kernel.org" <linux-arm@vger.kernel.org>
Date: Fri, 28 Jun 2013 12:53:35 +0300
In-Reply-To: <20130628093848.GA2139@e106331-lin.cambridge.arm.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
	 <20130628093848.GA2139@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 10:38 +0100, Mark Rutland wrote:
> On Tue, Jun 25, 2013 at 09:35:30AM +0100, Luciano Coelho wrote:
> > +Optional properties:
> > +--------------------
> > +
> > +- refclock: the internal WLAN reference clock frequency (required for
> > +  WiLink6 and WiLink7; not used for WiLink8).  Must be one of the
> > +  following:
> > +	0 = 19.2 MHz
> > +	1 = 26.0 MHz
> > +	2 = 38.4 MHz
> > +	3 = 52.0 MHz
> > +	4 = 38.4 MHz, XTAL
> > +	5 = 26.0 MHz, XTAL
> > +
> > +- tcxoclock: the internal WLAN TCXO clock frequency (required for
> > +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
> > +  following:
> > +	0 = 19.200 MHz
> > +	1 = 26.000 MHz
> > +	2 = 38.400 MHz
> > +	3 = 52.000 MHz
> > +	4 = 16.368 MHz
> > +	5 = 32.736 MHz
> > +	6 = 16.800 MHz
> > +	7 = 33.600 MHz
> 
> This looks suspiciously like what we have the common clock bindings for:
> 
> refclk {
> 	compatible = "fixed-clock";
> 	#clock-cells = <0>;
> 	clock-frequency = <19200000>;
> }
> 
> wilink {
> 	compatible = "ti,wilink7";
> 	interrupt-parent = <&some_interrupt_controller>;
> 	interrupts = <0 1 1>;
> 	clocks = <&refclk>, <&refclk>;
> 	clock-names = "refclk", "txoclk";
> };
> 
> Could you not use them?

Hmmm... this actually does look good.  But these are internal clocks in
the modules, they cannot be accessed from outside.  Does it make sense
to register them with the clock framework?

--
Luca.

