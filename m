Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbbA0XRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:17:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55937 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbbA0XRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:17:13 -0500
Date: Wed, 28 Jan 2015 00:17:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: N900 v3.19-rc5 arm atags_to_fdt.c is broken
Message-ID: <20150127231711.GB27641@amd>
References: <201501232239.55801@pali>
 <201501232336.36187@pali>
 <20150126161454.GE28663@atomide.com>
 <201501261723.10505@pali>
 <20150126170323.GF28663@atomide.com>
 <alpine.LFD.2.11.1501261318590.1322@knanqh.ubzr>
 <20150127133739.GB25306@amd>
 <alpine.LFD.2.11.1501271014160.1322@knanqh.ubzr>
 <20150127175359.GE11502@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271309450.1322@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501271309450.1322@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2015-01-27 13:50:22, Nicolas Pitre wrote:
> On Tue, 27 Jan 2015, Russell King - ARM Linux wrote:
> 
> > On Tue, Jan 27, 2015 at 10:16:24AM -0500, Nicolas Pitre wrote:
> > > On Tue, 27 Jan 2015, Pavel Machek wrote:
> > > > (Note, that in 3.19 dts for n900 got too big, so we are actually
> > > > triggering old bugs. That means that this is a regression fix, and
> > > > should go in ASAP).
> > > 
> > > It is queued here:
> > > http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8294/1
> > 
> > Irrespective of that patch, I commented on another thread (about adding
> > the serial number to DT):
> > 
> > | How about something a little more radical.
> > | 
> > | Rather than trying to squeeze various ATAGs into DT, why don't we add a
> > | standard ATAG to contain the DT and pass that through into the kernel.
> > | This is IMHO how we _should_ have done the ATAG compatibility from the
> > | start.
> > | 
> > | That means we could get rid of most of the libfdt in the decompressor,
> > | and instead resolve the differences in the kernel.
> > 
> > That would allow us to get rid of all the FDT compatibility code in the
> > decompressor, and when we encounter these special ATAGs, we can deal with
> > them in the kernel instead of having to mess around with the DT.  I'd
> > also assume (although I haven't checked) that it would be much easier to
> > add additional DT properties in the kernel environment, rather than in
> > the rather restrictive decompressor environment.
> 
> Well...
> 
> I was initially against any ATAG-to-DT compatibility at all.  IMHO the 
> "right" solution is to update the bootloader.
> 
> However people complained that updating the bootloader wasn't possible. 
> I therefore suggested they go with a shim layer I termed the "impedance 
> matcher" acting like an intermediate boot stage converting their (often 
> unofficial and out-of-tree) ATAGs into proper DT nodes.  Some people did 
> exactly that and it works wonderfully for them. It also works 
> wonderfully for kernel maintenance as the platform specific tweaks are 
> kept out of the kernel tree.
> 
> Still, that wasn't good enough for some cases as the move to DT 
> regressed some platforms that just used to work before.  Concatenating a 
> DTB to zImage was tolerable but installing an additional shim layer was 
> too much.  Hence the ATAG-to-DT compat code in the decompressor.  This 
> was meant to smooth things around the transition to DT, etc.  After all, 
> those devices with non-replaceable bootloaders where shim layers are not 
> possible should get out of commission eventually?

N900 is still phone that is best-supported by the mainline,
AFAICT. Yes, it is rather sad, but it means that no, it is probably
not going out of commission anytime soon.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
