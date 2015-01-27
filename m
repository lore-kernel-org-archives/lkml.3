Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087AbbA0Wdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:33:46 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:58347 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060AbbA0Wdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:33:43 -0500
Date: Tue, 27 Jan 2015 22:33:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rob Herring <robherring2@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Message-ID: <20150127223331.GP26493@n2100.arm.linux.org.uk>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <20150127132127.GA869@amd>
 <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com>
 <201501271532.25540@pali>
 <20150127174818.GM26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271446330.1322@knanqh.ubzr>
 <20150127210943.GN26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271614280.1322@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501271614280.1322@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 04:34:47PM -0500, Nicolas Pitre wrote:
> On Tue, 27 Jan 2015, Russell King - ARM Linux wrote:
> > Or we pass both the ATAGs and wrapped DT to the kernel when both exist,
> > and let the kernel deal with it in a much saner environment than the
> > restricted decompressor environment.
> 
> ... which would be a step backward in the context of the transition to 
> DT we accepted.  People will have even less of an incentive to fix their 
> stuff.

Where's the people fixing their stuff today?  I think your position is
something of an idealist rather than a realist - the reality is that
five years down the line of DT, the platforms which have not converted
are now *never* going to convert, irrespective of how much "incentive"
we may think we should apply to the situation.

So, at some point we have to start thinking as a realist rather than
an idealist, and realise that there are platforms out there which are
/never/ going to convert.

Most of my platforms here are /never/ going to convert to DT-only
booting quite simply because they don't have anyone working on that
stuff, and no one is willing to put the effort in.

The only platforms which I have which have converted are:
- OMAP SDP4430
- Versatile Express
- SolidRun Hummingboard & Cubox-i

Quite literally everything else is *never* going to support native DT
booting - and I'd go as far as to say that if I ever wanted to put the
effort in, I probably couldn't, because the boot loader sources aren't
available anymore.  (eg, the LDP3430 situation is such a mess that even
if the boot loader source is still available, identifying the correct
board version is near on impossible given the multitude of different
variants of the same product.)

The older Versatile and Integrator platforms, for example, are going
to be booting with the appended DTB for as long as they're around.
Most likely all the PXA platforms too, and, the IOP32x based N2100
boxes (which already need their kernels wrapped because the provided
boot loader has had environment saving disabled.)

As much as you may not like it, ATAGs are here to stay now, at least
on the older platforms, and no amount of "incentives" will change that.

> > However, there's another consideration to be had here before we can say
> > that: how many people out there want to run a mainline (or even an
> > updated kernel derived from mainline) on this device?  If there's a
> > sizable following for the device wanting updated support, then it's
> > something we really need to consider supporting inspite of our
> > disappointment with Nokia inventing these "proprietary" tags.
> 
> If there is indeed a sizable following for the device then someone 
> should figure out how to cope with upstream kernels, either through the 
> installation of some intermediate bootloader that can talk FDT directly, 
> or via a shim layer.  None of that has to be performed by nor linked 
> with the kernel binary, nor maintained in the kernel tree. And it's not 
> even that hard to do: we have precedents on other platforms with crappy 
> bootloaders where this just works.

That's a rediculous position if you want something which "just works"
on as much hardware as possible, which is, after all, what the single
zImage project is all about.

To be pro single-zImage, and anti popular hardware is quite contradictory.

You only have to look at x86 for this: just because ACPI came along does
not mean that the Linux kernel started demanding that ACPI is the only
way to describe the world.  Linux continues to directly support all the
old boot protocols that it did since the days of i386, such as the e820
memory interface and doesn't convert these to an ACPI table just because
it can.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
