Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900AbaEMOXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:23:00 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:49422 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891AbaEMOW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:22:57 -0400
Date: Tue, 13 May 2014 10:22:52 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Tom Rini <trini@ti.com>, Robert Nelson <robertcnelson@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Matt Ranostay <mranostay@gmail.com>,
        robh+dt@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>
Subject: Re: [PATCH v2] ARM: dts: am335x-bone-common: Add i2c2 definition
Message-ID: <20140513142252.GG32082@beef>
References: <1399686184-1594-1-git-send-email-mranostay@gmail.com>
 <20140512195050.GB5668@atomide.com>
 <CAOCHtYiYwx_bEsyqkbUTTAbhBYESzvfBOOYeVuFXPS1dDy0ZKA@mail.gmail.com>
 <20140512201517.GC5668@atomide.com>
 <CAOCHtYg6XpF0Gbo4iFqsFvP=QSivQQvCzov8UfxeLXMzrRYEWw@mail.gmail.com>
 <20140512204213.GD5668@atomide.com>
 <CAOCHtYgg7jwxswH+mqF3RA7-0RP-nGuft+Ze-GRwu1fbA6+0Bw@mail.gmail.com>
 <537215D3.70306@ti.com>
 <CABxcv=nq9XvyN0aPOBFDm0UyoaW-Htyy0tyP3YhYaDnDUo3a5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABxcv=nq9XvyN0aPOBFDm0UyoaW-Htyy0tyP3YhYaDnDUo3a5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 04:06:02PM +0200, Javier Martinez Canillas wrote:
> On Tue, May 13, 2014 at 2:53 PM, Tom Rini <trini@ti.com> wrote:
> > On 05/12/2014 04:57 PM, Robert Nelson wrote:
> >>>> Either case if fine with me.  As who knows when the dtc "overlay" will
> >>>> every truly make it mainline, as the capemgr was the only real kernel
> >>>> user of the i2c/at24 eeprom information.
> >>>
> >>> Sounds like we should keep it disabled though so u-boot can be used
> >>> to toggle it while waiting for the capemgr. That's because the board
> >>> has a header for pins, so it's not exactly limited to just the capes.
> >>>
> >>> Anybody working on enabling/disabling cape dtb configurations in u-boot?
> >>
> >> Well,
> >>
> >> Would Tom even approve of that in mainline u-boot? He didn't want my
> >> "invert" the gpio to enable the usb hub on the older beagle xm A/B..
> >>
> >> http://lists.denx.de/pipermail/u-boot/2014-January/172154.html
> >>
> >> http://lists.denx.de/pipermail/u-boot/2014-January/172274.html
> 
> Using fdt set from the bootloader to use the same FDT for similar
> boards (like the example with Beagle xM variants) is kind of trying to
> replicate what we used to do from boards files where it was possible
> to manage a set of boards using the same platform code.
> 
> But Device Trees are meant to describe hardware and thus should be
> static, if two board are almost identical but slightly different, then
> are two different hardware where each need its proper FDT that
> describes it.
> 
> >
> > I would think that using the 'fdt' command in U-Boot to add all
> > properties of every cape found on a running system would drive someone
> > to madness quite quickly.  Moving all of Pantelis' work for dynamic
> > device trees from the kernel to N bootloaders (U-Boot, barebox, UEFI,
> > etc) sounds like a step in the wrong direction.
> >
> 
> Agreed. I think that until the device tree overlay and the cape
> manager find their way into mainline we should treat capes as if they
> were expansion boards attached to a Computer-on-Module. That is, a
> static based board which its own DTS including the BB{B,W} as an dtsi
> and not something that can be added on runtime.

It's far more complicated than a SOM plus carrier board. Consider that
you can have any 4 of these capes stacked on the BBB/BBW in any
combination (assuming no resource conflicts). Capturing all possible
combinations in static dtsis is not practical.

-Matt
