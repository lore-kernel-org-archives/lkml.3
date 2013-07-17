Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab3GQX5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:57:34 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36377 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3GQX5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:57:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Luciano Coelho <coelho@ti.com>
Cc: mturquette@linaro.org, Mark Rutland <mark.rutland@arm.com>, balbi@ti.com,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm@vger.kernel.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
Date: Thu, 18 Jul 2013 01:58:17 +0200
Message-ID: <1698879.DLaB5pbe5M@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1372682370.21065.68.camel@cumari.coelho.fi>
References: <1372149330-24335-1-git-send-email-coelho@ti.com> <1372425670.21065.61.camel@cumari.coelho.fi> <1372682370.21065.68.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luciano,

On Monday 01 July 2013 15:39:30 Luciano Coelho wrote:
> On Fri, 2013-06-28 at 16:21 +0300, Luciano Coelho wrote:
> > On Fri, 2013-06-28 at 15:18 +0300, Felipe Balbi wrote:
> > > On Fri, Jun 28, 2013 at 03:13:52PM +0300, Luciano Coelho wrote:
> > > > On Fri, 2013-06-28 at 14:41 +0300, Felipe Balbi wrote:
> > > > > On Fri, Jun 28, 2013 at 02:22:11PM +0300, Luciano Coelho wrote:
> > > > > > On Fri, 2013-06-28 at 13:31 +0300, Luciano Coelho wrote:
> > > > > > > (fixed Mike's address)
> > > > > > > 
> > > > > > > On Fri, 2013-06-28 at 11:21 +0100, Mark Rutland wrote:
> > > > > > > > On Fri, Jun 28, 2013 at 10:53:35AM +0100, Luciano Coelho 
wrote:
> > > > > > > > > On Fri, 2013-06-28 at 10:38 +0100, Mark Rutland wrote:
> > > > > > > > > > On Tue, Jun 25, 2013 at 09:35:30AM +0100, Luciano Coelho 
wrote:
> > > > > > > > > > > +Optional properties:
> > > > > > > > > > > +--------------------
> > > > > > > > > > > +
> > > > > > > > > > > +- refclock: the internal WLAN reference clock frequency
> > > > > > > > > > > (required for
> > > > > > > > > > > +  WiLink6 and WiLink7; not used for WiLink8).  Must be
> > > > > > > > > > > one of the
> > > > > > > > > > > +  following:
> > > > > > > > > > > +	0 = 19.2 MHz
> > > > > > > > > > > +	1 = 26.0 MHz
> > > > > > > > > > > +	2 = 38.4 MHz
> > > > > > > > > > > +	3 = 52.0 MHz
> > > > > > > > > > > +	4 = 38.4 MHz, XTAL
> > > > > > > > > > > +	5 = 26.0 MHz, XTAL
> > > > > > > > > > > +
> > > > > > > > > > > +- tcxoclock: the internal WLAN TCXO clock frequency
> > > > > > > > > > > (required for
> > > > > > > > > > > +  WiLink7 not used for WiLink6 and WiLink8).  Must be
> > > > > > > > > > > one of the
> > > > > > > > > > > +  following:
> > > > > > > > > > > +	0 = 19.200 MHz
> > > > > > > > > > > +	1 = 26.000 MHz
> > > > > > > > > > > +	2 = 38.400 MHz
> > > > > > > > > > > +	3 = 52.000 MHz
> > > > > > > > > > > +	4 = 16.368 MHz
> > > > > > > > > > > +	5 = 32.736 MHz
> > > > > > > > > > > +	6 = 16.800 MHz
> > > > > > > > > > > +	7 = 33.600 MHz
> > > > > > > > > > 
> > > > > > > > > > This looks suspiciously like what we have the common clock
> > > > > > > > > > bindings for:
> > > > > > > > > > 
> > > > > > > > > > refclk {
> > > > > > > > > > 
> > > > > > > > > > 	compatible = "fixed-clock";
> > > > > > > > > > 	#clock-cells = <0>;
> > > > > > > > > > 	clock-frequency = <19200000>;
> > > > > > > > > > 
> > > > > > > > > > }
> > > > > > > > > > 
> > > > > > > > > > wilink {
> > > > > > > > > > 
> > > > > > > > > > 	compatible = "ti,wilink7";
> > > > > > > > > > 	interrupt-parent = <&some_interrupt_controller>;
> > > > > > > > > > 	interrupts = <0 1 1>;
> > > > > > > > > > 	clocks = <&refclk>, <&refclk>;
> > > > > > > > > > 	clock-names = "refclk", "txoclk";
> > > > > > > > > > 
> > > > > > > > > > };
> > > > > > > > > > 
> > > > > > > > > > Could you not use them?
> > > > > > > > > 
> > > > > > > > > Hmmm... this actually does look good.  But these are
> > > > > > > > > internal clocks in the modules, they cannot be accessed from
> > > > > > > > > outside.  Does it make sense to register them with the clock
> > > > > > > > > framework?
> > > > > > > > 
> > > > > > > > Given we already have a common way of describing clocks, I
> > > > > > > > think it makes sense to use it -- people already understand
> > > > > > > > the common bindings, and it's less code to add add to the
> > > > > > > > kernel. I don't think the fact these clocks are internal
> > > > > > > > should prevent us from describing them as we would an external
> > > > > > > > clock.
> > > > > > > 
> > > > > > > Yes, I agree with you.  Thanks for the suggestion! I think it
> > > > > > > will look much better.  And now that I dug a bit more into the
> > > > > > > code, I can see that there are only structs being populated, so
> > > > > > > there shouldn't be any other side-effects.
> > > > > > 
> > > > > > Hmmm, one thing that escaped me.  Besides the frequency, I also
> > > > > > need a boolean that tells if the clock is XTAL or not.  I can't
> > > > > > figure out how to pass this if I use the generic clock framework. 
> > > > > > Any suggestions?
> > > > > 
> > > > > Could you use clock-output-names for that ?
> > > > > 
> > > > > XTAL clock:
> > > > > 
> > > > > refclk {
> > > > > 
> > > > > 	compatible = "fixed-clock";
> > > > > 	#clock cells = <0>;
> > > > > 	clock-frequency = <19200000>;
> > > > > 	clock-output-names = "xtal";
> > > > > 
> > > > > };
> > > > > 
> > > > > non-XTAL clock:
> > > > > 
> > > > > refclk {
> > > > > 
> > > > > 	compatible = "fixed-clock";
> > > > > 	#clock cells = <0>;
> > > > > 	clock-frequency = <19200000>;
> > > > > 	clock-output-names = "osc"; /* any better name ? */
> > > > > 
> > > > > };
> > > > 
> > > > This starts looking a bit hacky.  Using the output name as a flag is
> > > > not very pretty.
> > > > 
> > > > I think it would be better to have a separate flag for it in the wlan
> > > > node.  Like an optional "refclock-xtal" boolean or something.  The
> > > > downside of this is that we would be adding information about the
> > > > clock details in the wilink node. :(
> > > > 
> > > > OTOH, we could add a flag to the generic clock binding? A new optional
> > > > boolean that tells whether the clock is XTAL or not:
> > > > 
> > > > refclk {
> > > > 
> > > > 	compatible = "fixed-clock";
> > > > 	#clock cells = <0>;
> > > > 	clock-frequency = <19200000>;
> > > > 	clock-xtal;
> > > > 
> > > > };
> > > > 
> > > > Do you think that would make sense?
> > > 
> > > sure, that looks alright to me. Surely there are other devices out there
> > > who want to know if the clock comes from a crystal or not ?!?
> > 
> > Mike, what do you think about this idea? If it sounds okay to you, I can
> > cook up a patch adding this flag.
> 
> Hmmm... I started implementing this whole thing, but using these clocks
> as "fixed-clock"s is not so straightforward.  The problem is that I
> would need to register my driver as a clock provider and add the OF
> match for "fixed-clock".
> 
> If I do that, all the other "fixed-clock" nodes would be passed to my
> driver too, which is wrong.  Or, the platform should register the
> "fixed-clock" match, but this would be wrong too, since it would find
> *my* fixed-clocks.
> 
> The only thing I can come up with is to make a small clock driver (maybe
> even inside the WiLink module itself) that registers a new type of
> clock, "ti,wilink-clock" or something.  But this would really be
> overkill, wouldn't it?
> 
> Any other ideas?

One possibility would be to just call clk_get_rate() on the clock from the 
WiLink driver, which would return the fixed frequency specified in DT, and 
configure the WiLink hardware accordingly. This might be a bit hackish though.

-- 
Regards,

Laurent Pinchart

