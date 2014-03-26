Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaCZNf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:35:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63496 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbaCZNf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:35:26 -0400
Date: Wed, 26 Mar 2014 13:35:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jon Ringle <jon@ringle.org>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH v2 2/2] serial: sc16is7xx: Add bindings documentation
 for the SC16IS7XX UARTs
Message-ID: <20140326133518.GA6209@e106331-lin.cambridge.arm.com>
References: <1395771564-30534-1-git-send-email-jon@ringle.org>
 <1395771564-30534-2-git-send-email-jon@ringle.org>
 <20140326090855.GP10341@e106331-lin.cambridge.arm.com>
 <CAMwGMjxK2C_ciW6LwdMHE5wYkOHtkP00extF1-qcZ2xYoDr=7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMwGMjxK2C_ciW6LwdMHE5wYkOHtkP00extF1-qcZ2xYoDr=7g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 12:49:59PM +0000, Jon Ringle wrote:
> On Wed, Mar 26, 2014 at 5:08 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Tue, Mar 25, 2014 at 06:19:24PM +0000, jon@ringle.org wrote:
> >> +- interrupt-parent: The phandle for the interrupt controller that
> >> +  services interrupts for this IC.
> >> +- interrupts: Specifies the interrupt source of the parent interrupt
> >> +  controller. The format of the interrupt specifier depends on the
> >> +  parent interrupt controller.
> >
> > Just describe what the device-specific interrupt logically is, not what
> > the interrupts property means in general.
> >
> 
> Something like this ok?:
> 
> -interrupts: Should contain the UART interrupt

Sure.

> 
> >> +- clocks: phandle to the IC source clock.
> >
> > Nit: clocks aren't just referred to with phandles; there's a clock
> > specifier too.
> >
> > Either correct the type here or don't mention the type at all, given
> > this is a common property.
> >
> 
> I'm not sure what to do here. Many of the other
> devicetree/bindings/serial/*.txt use phandle verbage and also the
> devicetree/bindings/clock-bindings.txt documentation for clocks refers
> the type as phandle too:
> 
> ==Clock consumers==
> 
> Required properties:
> clocks:         List of phandle and clock specifier pairs, one pair
>                 for each clock input to the device.  Note: if the
>                 clock provider specifies '0' for #clock-cells, then
>                 only the phandle portion of the pair will appear.
> 

Those bindings which refer to clocks as just being phandles are simply
wrong.

While clocks _may_ be simply phandles, that isn't the general case (and
when this is the case they can be thought of as having a zero cell
clock-specifier). The quoted portion of the core clock bindings
describes clocks as consisting of "phandle and and clock specifier
pairs", not just phandles.

> Is something like this ok?:
> 
> clocks: reference to the source clock

Sure. That'll be fine.

Thanks,
Mark.
