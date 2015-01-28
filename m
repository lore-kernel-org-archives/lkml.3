Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633AbbA1CHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:07:49 -0500
Received: from relais.videotron.ca ([24.201.245.36]:14044 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933586AbbA1CHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:07:47 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 27 Jan 2015 21:07:43 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Rob Herring <robherring2@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
In-reply-to: <20150127223331.GP26493@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.11.1501272027390.1322@knanqh.ubzr>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <20150127132127.GA869@amd>
 <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com>
 <201501271532.25540@pali> <20150127174818.GM26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271446330.1322@knanqh.ubzr>
 <20150127210943.GN26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271614280.1322@knanqh.ubzr>
 <20150127223331.GP26493@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Russell King - ARM Linux wrote:

> On Tue, Jan 27, 2015 at 04:34:47PM -0500, Nicolas Pitre wrote:
> > On Tue, 27 Jan 2015, Russell King - ARM Linux wrote:
> > > Or we pass both the ATAGs and wrapped DT to the kernel when both exist,
> > > and let the kernel deal with it in a much saner environment than the
> > > restricted decompressor environment.
> > 
> > ... which would be a step backward in the context of the transition to 
> > DT we accepted.  People will have even less of an incentive to fix their 
> > stuff.
> 
> Where's the people fixing their stuff today?

At least some people in this thread are, otherwise they'd still be away 
hacking on their own.

> I think your position is something of an idealist rather than a 
> realist - the reality is that five years down the line of DT, the 
> platforms which have not converted are now *never* going to convert, 
> irrespective of how much "incentive" we may think we should apply to 
> the situation.

Don't get me wrong.  I'm not expecting those platforms to do native DT 
booting ever.  However "faking" DT booting with already proven solutions 
that don't bastardize the kernel further should be encouraged.

> > If there is indeed a sizable following for the device then someone 
> > should figure out how to cope with upstream kernels, either through the 
> > installation of some intermediate bootloader that can talk FDT directly, 
> > or via a shim layer.  None of that has to be performed by nor linked 
> > with the kernel binary, nor maintained in the kernel tree. And it's not 
> > even that hard to do: we have precedents on other platforms with crappy 
> > bootloaders where this just works.
> 
> That's a rediculous position if you want something which "just works"
> on as much hardware as possible, which is, after all, what the single
> zImage project is all about.

Agreed.

> To be pro single-zImage, and anti popular hardware is quite contradictory.

Indeed.  I'm not against popular hardware.

> You only have to look at x86 for this: just because ACPI came along does
> not mean that the Linux kernel started demanding that ACPI is the only
> way to describe the world.  Linux continues to directly support all the
> old boot protocols that it did since the days of i386, such as the e820
> memory interface and doesn't convert these to an ACPI table just because
> it can.

Booting from a floppy boot sector is no longer supported though.

But that's besides the point.  If someone needs a 5-line addition to 
atags_to_fdt.c in order to boot some old stuff then let's just do it and 
move on. I'll happily ACK the patch. The code is there and it is not 
going away soon.

However, if something more involved is needed, is platform specific and 
is likely to require about as many lines in the kernel than it would 
need in some externat shim then the shim solution should be encouraged 
instead.  After all that's why LILO, Syslinux and Grub were created on 
X86: to Supplement the crappy PC BIOS boot interface.  And if the 
hardware is popular, then finding a motivated hacker to do it shouldn't 
be too hard, right?

In other words, what prevents someone from creating, say, a custom 
minimal Barebox version that sits on top of the existing N900 
bootloader?  Wouldn't that provide a much better user experience?


Nicolas
