Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbbA1Vys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:54:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55852 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbbA1U3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:29:07 -0500
Date: Wed, 28 Jan 2015 19:03:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rob Herring <robherring2@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Message-ID: <20150128180322.GA16868@amd>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <20150127174818.GM26493@n2100.arm.linux.org.uk>
 <20150128005032.GK28663@atomide.com>
 <201501281458.22088@pali>
 <alpine.LFD.2.11.1501280925400.1322@knanqh.ubzr>
 <CAL_Jsq+rESm8q44ABRbh9hqMsfcMNx0kcXJ5ONbn1=ue-RvHFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_Jsq+rESm8q44ABRbh9hqMsfcMNx0kcXJ5ONbn1=ue-RvHFg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2015-01-28 09:57:18, Rob Herring wrote:
> On Wed, Jan 28, 2015 at 8:33 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> > On Wed, 28 Jan 2015, Pali Rohár wrote:
> >
> >> On Wednesday 28 January 2015 01:50:33 Tony Lindgren wrote:
> >> > On omaps, the bootrom passes the bootreason in r1 to the
> >> > bootloader that can do whatever it wants with it. We could
> >> > maybe pass it in the kernel cmdline to the watchdog driver
> >> > for user space?
> >> >
> >>
> >> Not truth for N900. Bootreason depends on PRM_RSTST omap
> >> register, state of vbat charger pins, time how long was power key
> >> pressed, R&D data stored in CAL partition and other undocumented
> >> registers for omap HS devices. I already tried to implement at
> >> least some subset of it in userspace (or kernel), but it is
> >> impossible because NOLO bootloader clear status of PRM_RSTST
> >> register.
> >>
> >> There is also copy of PRM_RSTST register stored at address
> >> 0x4020FFB8 (tracing data) but that address is rewritten (probably
> >> by kernel), so we really cannot implement reading bootreason in
> >> kernel.
> >>
> >> But in early stage in uboot it is possible to read 0x4020FFB8
> >> address and get some part of bootreason. But still PRM_RSTST is
> >> not enough!
> >>
> >> I would be happy if DT kernel can export /proc/atags file with
> >> ATAGs passed by bootloader. It would be enough for me. In
> >> userspace I can parse content and do what is needed.
> >
> > What about defining a DT boot reason property instead?
> > Maybe it already exists?  If not, it's something that could certainly be
> > generically used on other platforms too.
> 
> I'm fine with that, but we just need to have a standard kernel
> userspace interface in addition to something like
> /proc/device-tree/bootreason. Perhaps this can be the default
> implementation for the watchdog dev. Someday when we decide DT is crap
> and have a new boot interface, we'll have people relying on
> /proc/device-tree. I hope to be retired when that happens...

Huh. Who thought putting device-tree into /proc was good idea? That
should have gone to /sys, as it is not process related...

Anyway, bootreason does not depend on device-tree, so it should not be
in device-tree specific subdirectory.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
