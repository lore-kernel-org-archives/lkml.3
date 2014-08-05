Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbaHEIr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:47:26 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57452 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441AbaHEIrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:47:23 -0400
Date: Tue, 5 Aug 2014 10:47:17 +0200
From: Robert Richter <rric@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>, Rob Herring <robherring2@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder
 SoC
Message-ID: <20140805084717.GH4703@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKgfjV4sEZOWuH4YcMjeOA_yNDvZLv_jTi_Sb=27cOD3g@mail.gmail.com>
 <20140730174803.GF20162@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.07.14 18:48:03, Mark Rutland wrote:
> > >> +             uaa0: serial@87e024000000 {
> > >> +                     compatible = "arm,pl011", "arm,primecell";
> > >> +                     reg = <0x87e0 0x24000000 0x0 0x1000>;
> > >> +                     interrupts = <1 21 4>;
> > >> +                     clocks = <&refclk50mhz>;
> > >> +                     clock-names = "apb_pclk";
> > >
> > > Is this actually the apb_pclk, or is the the uartclk? I assume it's the
> > > latter.
> > 
> > Shouldn't new bindings have both clocks here? A single clock was a
> > mistake I think (mine in fact).
> 
> I don't think we fixed it up in the end. It made drivers look a bit messy and
> it dropped off my priority queue.

On 31.07.14 10:22:19, Rob Herring wrote:
> On Thu, Jul 31, 2014 at 7:34 AM, Robert Richter <rric@kernel.org> wrote:
> > On 30.07.14 11:37:38, Rob Herring wrote:
> >> On Wed, Jul 30, 2014 at 10:46 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> >> > On Wed, Jul 30, 2014 at 04:06:31PM +0100, Robert Richter wrote:
> >> >> From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> >> >> +             uaa0: serial@87e024000000 {
> >> >> +                     compatible = "arm,pl011", "arm,primecell";
> >> >> +                     reg = <0x87e0 0x24000000 0x0 0x1000>;
> >> >> +                     interrupts = <1 21 4>;
> >> >> +                     clocks = <&refclk50mhz>;
> >> >> +                     clock-names = "apb_pclk";
> >> >
> >> > Is this actually the apb_pclk, or is the the uartclk? I assume it's the
> >> > latter.
> >>
> >> Shouldn't new bindings have both clocks here? A single clock was a
> >> mistake I think (mine in fact).
> >
> > Do you mean
> >                         clock-names = "uartclk", "apb_pclk";
> > here?
> 
> Yes, but Mark said this change never happened so maybe it is fine. In
> any case, follow the pl011 binding documentation.

Right:

Documentation/devicetree/bindings/arm/primecell.txt:
- clocks : From common clock binding. First clock is phandle to clock for apb
        pclk. Additional clocks are optional and specific to those peripherals.
- clock-names : From common clock binding. Shall be "apb_pclk" for first clock.

Documentation/devicetree/bindings/serial/pl011.txt
- clocks:  When present, must refer to exactly one clock named
           "apb_pclk"

There is no binding documentation at all for "uartclk".

It seems we should should leave clock-names = "apb_pclk" as it is.

Mark, Rob, would this be ok?

Thanks,

-Robert
