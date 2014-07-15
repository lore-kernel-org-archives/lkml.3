Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbaGOJCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:02:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49979 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbaGOI7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:59:25 -0400
Date: Tue, 15 Jul 2014 09:59:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Harini Katakam <harinikatakamlinux@gmail.com>
Cc: "wim@iguana.be" <wim@iguana.be>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "harini.katakam@xilinx.com" <harini.katakam@xilinx.com>
Subject: Re: [PATCH v3 2/2] devicetree: Add Cadence WDT devicetree bindings
 documentation
Message-ID: <20140715085914.GT26465@leverpostej>
References: <1405340169-2820-1-git-send-email-harinik@xilinx.com>
 <1405340169-2820-2-git-send-email-harinik@xilinx.com>
 <20140714150749.GH26465@leverpostej>
 <CAFcVECK9U_3+3htTAu7r-agi43mC9Z2pqHeS9TpHTbZ3=o-o8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFcVECK9U_3+3htTAu7r-agi43mC9Z2pqHeS9TpHTbZ3=o-o8w@mail.gmail.com>
Thread-Topic: [PATCH v3 2/2] devicetree: Add Cadence WDT devicetree bindings
 documentation
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 07:39:40AM +0100, Harini Katakam wrote:
> Hi Mark,
> 
> On Mon, Jul 14, 2014 at 8:37 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Mon, Jul 14, 2014 at 01:16:09PM +0100, Harini Katakam wrote:
> >> Add cadence-wdt bindings documentation.
> >>
> >> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> >> ---
> >>
> >> v3 changes:
> >> - Change reset property type and improve description.
> >> - Improve description of clocks and interrupts.
> >> - Use watchdog@ in the example.
> >> - Use only cdns compatible string for now.
> >>
> >> v2:
> >> No changes
> >>
> >> ---
> >>  .../devicetree/bindings/watchdog/cadence-wdt.txt   |   27 ++++++++++++++++++++
> >>  1 file changed, 27 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> >> new file mode 100644
> >> index 0000000..ab23e38
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> >> @@ -0,0 +1,27 @@
> >> +Zynq Watchdog Device Tree Bindings
> >> +-------------------------------------------
> >> +
> >> +Required properties:
> >> +- compatible         : Should be "cdns,wdt-r1p2".
> >> +- clocks             : Input clock specifier. This should be the ref clk.
> >
> > This wording makes it sound like the watchdog block has more than one
> > clock input. Does it?
> 
> It doesn't. It has one APB clock - named pclk.

Ok. Could we refer to that by name in the description then? The phrase
"This should be the ref clk" makes it sound like there are other clocks
we aren't describing.

> >
> >> +- reg                        : Physical base address and size of WDT registers map.
> >> +- interrupts         : Property with a value describing the interrupt
> >> +                       number. This interrupt is used for indication
> >> +                       when the watchdog times out.
> >
> > Just say "the watchdog timeout interrupt", or (better) use the name of
> > the interrupt from the documentation.
> 
> OK. Yeah I'll do that. The interrupt name is wd_irq.

That sounds good to me.
 
> >
> >> +- interrupt-parent   : Must be core interrupt controller.
> >> +
> >> +Optional properties
> >> +- reset                      : If this property exists, then a reset is done
> >> +                       when watchdog times out.
> >
> > That's a bit of an ambiguous name (too easy to misconstrue as a reset
> > device reference). Do any other watchdogs have similar properties?
> 
> I could change it to "reset-on-timeout" if that better.
> From the documentation of other drivers, there seems to be a reset-type
> property in atmel. Dint find any other reset related properties.
> 

Ok. reset-on-timeout sounds like a better property name to avoid
possible confusion.

That said, what happens if we don't specify the device should reset the
system (but have a timeout-sec property)?

Thanks,
Mark.
