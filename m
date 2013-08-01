Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3HANeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:34:15 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:62306 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab3HANeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:34:13 -0400
MIME-Version: 1.0
In-Reply-To: <1375352315.22084.138.camel@shinybook.infradead.org>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	<1999586.84BnWE5EUh@thinkpad>
	<20130731191209.GA8027@netboy>
	<1409617.9untvfnOTJ@flatron>
	<20130731200017.GC8027@netboy>
	<20130731201457.GA24642@n2100.arm.linux.org.uk>
	<CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com>
	<20130731204817.GC24642@n2100.arm.linux.org.uk>
	<CAKON4Ozfe=endqnXWkcWR2HuJ489Otpcu2QsjB0DNg6jpRgG+Q@mail.gmail.com>
	<1375352315.22084.138.camel@shinybook.infradead.org>
Date: Thu, 1 Aug 2013 09:34:10 -0400
Message-ID: <CAKON4OyhF+_Q8dWNBDjag=A=v=J2NE0h8+1mms2uvUMS8+45eA@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Domenico Andreoli <cavokz@gmail.com>, mbizon@freebox.fr,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 6:18 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2013-07-31 at 17:26 -0400, jonsmirl@gmail.com wrote:
>> Alternatively you may be of the belief that it is impossible to get
>> rid of the board specific code. But x86 doesn't have any of it, why
>> should ARM?
>
> The reason x86 doesn't have it is because it carries three decades worth
> of legacy baggage so that it can still look like a 1980s IBM PC when
> necessary.
>
> There *have* been some x86 platforms which abandon that legacy crap, and
> for those we *do* have board-specific code. (Is James still maintaining
> Voyager support? It feels very strange to talk about Voyager with it
> *not* being the 'legacy crap' in question...)
>
> We've even seen *recent* attempts to abandon the legacy crap in the
> embedded x86 space, which backtracked and added it all back again — in
> part because x86 lacked any sane way to describe the hardware if it
> wasn't pretending to be a PC. ACPI doesn't cut it, and DT "wasn't
> invented here"...
>
> Unless you want the ARM world to settle on a strategy of "all the world
> is an Assabet", I'd be careful what you wish for...

So there should be shades for gray in this area. Try to eliminate all
of the board specific code you can, and then only if that fails add
board specific support to the kernel.

But you take device trees pretty far. I believe Grant has even used
one to describe an FPGA that he can dynamically load code into and
change its function.  Not sure how he did it, I wasn't paying too
close of attention when he was talking about it.

I do believe a great deal of this simple plumbing can be eliminated.
Like how to hook up GPIO, I2C, SPI, etc. We're pretty far down that
road.

A path like this seems like it would be beneficial...
1) Implement DT schemas. Use those to enforce as much regularity as
possible into the device tree descriptions for common classes of
things (controllers especially - DMA, I2C, I2S, SPI, Uarts, etc)..
Form a group to review any changes to the common schema.
2) Cleaning up the controller classes is going to cause some DT churn.
Hide backward compatibility in a quirks layer.
3) Continue the process of removing all possible board specific code
that can be reasonably covered in device trees.
4) There will be some board specific code left at the end of this
process. But anyone who looks at should agree that the functions
handled by the code are something that is unreasonable to address in
the DT system.


>
> --
> dwmw2
>



-- 
Jon Smirl
jonsmirl@gmail.com
