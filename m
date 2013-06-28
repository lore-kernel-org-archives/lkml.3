Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3F1NVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:21:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42725 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab3F1NVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:21:45 -0400
Message-ID: <1372425670.21065.61.camel@cumari.coelho.fi>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
From: Luciano Coelho <coelho@ti.com>
To: <mturquette@linaro.org>
CC: <balbi@ti.com>, Mark Rutland <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm@vger.kernel.org" <linux-arm-kernel@lists.infradead.org>
Date: Fri, 28 Jun 2013 16:21:10 +0300
In-Reply-To: <20130628121859.GP11297@arwen.pp.htv.fi>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
	 <20130628093848.GA2139@e106331-lin.cambridge.arm.com>
	 <1372413215.21065.41.camel@cumari.coelho.fi>
	 <20130628102145.GB2139@e106331-lin.cambridge.arm.com>
	 <1372415514.21065.50.camel@cumari.coelho.fi>
	 <1372418531.21065.53.camel@cumari.coelho.fi>
	 <20130628114129.GO11297@arwen.pp.htv.fi>
	 <1372421632.21065.60.camel@cumari.coelho.fi>
	 <20130628121859.GP11297@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 15:18 +0300, Felipe Balbi wrote:
> On Fri, Jun 28, 2013 at 03:13:52PM +0300, Luciano Coelho wrote:
> > On Fri, 2013-06-28 at 14:41 +0300, Felipe Balbi wrote:
> > > On Fri, Jun 28, 2013 at 02:22:11PM +0300, Luciano Coelho wrote:
> > > > On Fri, 2013-06-28 at 13:31 +0300, Luciano Coelho wrote:
> > > > > (fixed Mike's address)
> > > > > 
> > > > > On Fri, 2013-06-28 at 11:21 +0100, Mark Rutland wrote:
> > > > > > On Fri, Jun 28, 2013 at 10:53:35AM +0100, Luciano Coelho wrote:
> > > > > > > On Fri, 2013-06-28 at 10:38 +0100, Mark Rutland wrote:
> > > > > > > > On Tue, Jun 25, 2013 at 09:35:30AM +0100, Luciano Coelho wrote:
> > > > > > > > > +Optional properties:
> > > > > > > > > +--------------------
> > > > > > > > > +
> > > > > > > > > +- refclock: the internal WLAN reference clock frequency (required for
> > > > > > > > > +  WiLink6 and WiLink7; not used for WiLink8).  Must be one of the
> > > > > > > > > +  following:
> > > > > > > > > +	0 = 19.2 MHz
> > > > > > > > > +	1 = 26.0 MHz
> > > > > > > > > +	2 = 38.4 MHz
> > > > > > > > > +	3 = 52.0 MHz
> > > > > > > > > +	4 = 38.4 MHz, XTAL
> > > > > > > > > +	5 = 26.0 MHz, XTAL
> > > > > > > > > +
> > > > > > > > > +- tcxoclock: the internal WLAN TCXO clock frequency (required for
> > > > > > > > > +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
> > > > > > > > > +  following:
> > > > > > > > > +	0 = 19.200 MHz
> > > > > > > > > +	1 = 26.000 MHz
> > > > > > > > > +	2 = 38.400 MHz
> > > > > > > > > +	3 = 52.000 MHz
> > > > > > > > > +	4 = 16.368 MHz
> > > > > > > > > +	5 = 32.736 MHz
> > > > > > > > > +	6 = 16.800 MHz
> > > > > > > > > +	7 = 33.600 MHz
> > > > > > > > 
> > > > > > > > This looks suspiciously like what we have the common clock bindings for:
> > > > > > > > 
> > > > > > > > refclk {
> > > > > > > > 	compatible = "fixed-clock";
> > > > > > > > 	#clock-cells = <0>;
> > > > > > > > 	clock-frequency = <19200000>;
> > > > > > > > }
> > > > > > > > 
> > > > > > > > wilink {
> > > > > > > > 	compatible = "ti,wilink7";
> > > > > > > > 	interrupt-parent = <&some_interrupt_controller>;
> > > > > > > > 	interrupts = <0 1 1>;
> > > > > > > > 	clocks = <&refclk>, <&refclk>;
> > > > > > > > 	clock-names = "refclk", "txoclk";
> > > > > > > > };
> > > > > > > > 
> > > > > > > > Could you not use them?
> > > > > > > 
> > > > > > > Hmmm... this actually does look good.  But these are internal clocks in
> > > > > > > the modules, they cannot be accessed from outside.  Does it make sense
> > > > > > > to register them with the clock framework?
> > > > > > 
> > > > > > Given we already have a common way of describing clocks, I think it
> > > > > > makes sense to use it -- people already understand the common bindings,
> > > > > > and it's less code to add add to the kernel. I don't think the fact
> > > > > > these clocks are internal should prevent us from describing them as we
> > > > > > would an external clock.
> > > > > 
> > > > > Yes, I agree with you.  Thanks for the suggestion! I think it will look
> > > > > much better.  And now that I dug a bit more into the code, I can see
> > > > > that there are only structs being populated, so there shouldn't be any
> > > > > other side-effects.
> > > > 
> > > > Hmmm, one thing that escaped me.  Besides the frequency, I also need a
> > > > boolean that tells if the clock is XTAL or not.  I can't figure out how
> > > > to pass this if I use the generic clock framework.  Any suggestions?
> > > 
> > > Could you use clock-output-names for that ?
> > > 
> > > XTAL clock:
> > > 
> > > refclk {
> > > 	compatible = "fixed-clock";
> > > 	#clock cells = <0>;
> > > 	clock-frequency = <19200000>;
> > > 	clock-output-names = "xtal";
> > > };
> > > 
> > > non-XTAL clock:
> > > 
> > > refclk {
> > > 	compatible = "fixed-clock";
> > > 	#clock cells = <0>;
> > > 	clock-frequency = <19200000>;
> > > 	clock-output-names = "osc"; /* any better name ? */
> > > };
> > 
> > This starts looking a bit hacky.  Using the output name as a flag is not
> > very pretty.
> > 
> > I think it would be better to have a separate flag for it in the wlan
> > node.  Like an optional "refclock-xtal" boolean or something.  The
> > downside of this is that we would be adding information about the clock
> > details in the wilink node. :(
> > 
> > OTOH, we could add a flag to the generic clock binding? A new optional
> > boolean that tells whether the clock is XTAL or not:
> > 
> > refclk {
> > 	compatible = "fixed-clock";
> > 	#clock cells = <0>;
> > 	clock-frequency = <19200000>;
> > 	clock-xtal;
> > };
> > 
> > Do you think that would make sense?
> 
> sure, that looks alright to me. Surely there are other devices out there
> who want to know if the clock comes from a crystal or not ?!?

Mike, what do you think about this idea? If it sounds okay to you, I can
cook up a patch adding this flag.

--
Cheers,
Luca.

