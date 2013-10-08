Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3JHP2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:28:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40785 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452Ab3JHP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:28:14 -0400
Date: Tue, 8 Oct 2013 16:28:12 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Nishanth Menon <nm@ti.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH V3] clk: palmas: add clock driver for palmas
Message-ID: <20131008152812.GA4981@e106331-lin.cambridge.arm.com>
References: <1381238480-18852-1-git-send-email-ldewangan@nvidia.com>
 <525408B3.1000107@ti.com>
 <5254193A.70104@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5254193A.70104@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 03:39:54PM +0100, Laxman Dewangan wrote:
> Thanks Nishanth for review.
> 
> On Tuesday 08 October 2013 06:59 PM, Nishanth Menon wrote:
> > On 10/08/2013 08:21 AM, Laxman Dewangan wrote:
> >> Palmas devices has two clock output CLK32K_KG and CLK32K_KG_AUDIO
> > not all palmas devices have 2 clocks - example: tps659038
> 
> This is for generic palmas and I have seen it for TPS65913, TPS65914, 
> TPS80036. If the generic one is not compatible then it need to add  
> device specific and at that time, it is require to update the binding 
> document accordingly.

We've just been given an example of where it's not compatible.

> 
> >           |    7 +
> >   drivers/clk/Makefile                               |    1 +
> >   drivers/clk/clk-palmas.c                           |  340 ++++++++++++++++++++
> >
> > http://www.spinics.net/lists/devicetree/msg04855.html
> > Do we do 2 patches now? one seperate for binding and implementation?
> > What is our current preference now a days?
> 
> Currently it is implementation + binding doc in one patch.

I believe the general consensus is that separate DT patches are
preferred.

> 
> >
> >>   Palmas device has two clock output pins for 32KHz, KG and KG_AUDIO.
> >> +
> >> +This binding uses the common clock binding ./clock-bindings.txt.
> > proper link would be to provide
> > Documentation/devicetree/bindings/clock/clock-bindings.txt ?
> 
> Hmm, other patch I got feedback from DT maintainers to do not use the 
> absolute path as document directory may change

I'd not seen this, but I don't have a strong preference either way. This
document will go under Documentation/devicetree/bindings/clock, so a
relative path seems Ok.

> 
> >> +
> >> +Clock 32KHz KG is output 0 of the driver and clock 32KHz is output 1.
> >> +
> >> +Required properties:
> >> +- compatible : shall be "ti,palmas-clk".
> > To handle variants of Palmas chips in production, you'd want to be
> > specific here clk32k_kg and clk32k_kg_audio.
> 
> The compatible is the device sub module level, not the clock level. Same 
> thing we are following on regulators.

Yes, we don't need a separate compatible string for each clock within a
block providing those clocks.

> 
> 
> >
> >> +
> >> +     Optional subnode properties:
> >> +     ti,clock-boot-enable: Enable clock at the time of booting.
> > Dumb question: Why is this needed? should'nt relevant drivers do a
> > clk_get to enable the relevant clocks?
> 
> If some board needs this clock to be always available for rest of system 
> to work without any specific driver then this flag is useful.

Do we _actually_ need this right now, or is this hypothetical?

If we don't need it now, remove it. If you think we need it know, please
describe exactly why (i.e. what device needs the clock to work, why does
this affect the rest of the board if we don't ahve a driver for that
device, why don't we just write a driver for that device).

> 
> 
> >
> >> +     ti,external-sleep-control: The clock is enable/disabled by state
> >> +             of external enable input pins ENABLE, ENABLE2 and NSLEEP.
> >> +             The valid value for the external pins are:
> >> +                     1 for ENABLE1
> >> +                     2 for ENABLE2
> >> +                     3 for NSLEEP.

I asked this on the last version (before having noticed this one). What
actually drives those pins to control the clock(s)?

Is this for setting the clock to be controlled by the external pin, or
is the clock hard-wired to a particular pin?

Thanks,
Mark.
