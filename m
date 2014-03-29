Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaC2ARi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:17:38 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:53346 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaC2ARh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:17:37 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/8] Generic serial earlycon
To: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <CAL_JsqKjGjyYypwneCmNc1qeKe0ZOG9gz3QSJ37-HwHXKu3iRA@mail.gmail.com>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com> < 201403221054.39799.arnd@arndb.de> < CAL_JsqKjGjyYypwneCmNc1qeKe0ZOG9gz3QSJ37-HwHXKu3iRA@mail.gmail.com>
Date: Fri, 28 Mar 2014 17:17:32 -0700
Message-Id: <20140329001732.BECE2C41FF4@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014 09:14:31 -0500, Rob Herring <robherring2@gmail.com> wrote:
> On Sat, Mar 22, 2014 at 4:54 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 21 March 2014, Rob Herring wrote:
> >> From: Rob Herring <robh@kernel.org>
> >>
> >> This started out as an attempt to add arm64's earlyprintk support to ARM
> >> in order to get an earlier, runtime setup console on multi-platform
> >> kernels. The first issue was needing the fixmap support which
> >> conveniently Mark Salter was working on and is mostly in place now. Like
> >> many things on ARM and arm64 now, it then became where do I put the now
> >> common, shared code. After digging more into various early console/printk
> >> support, it turns out the 8250_early.c setup code was the best starting
> >> point.
> >>
> >> This is based on Mark Salter's fixmap support currently in linux-next.
> >> This is tested on arm64 and ARM with pl011 and 8250. The ARM support
> >> also requires fixmap and fixed mapping support which are not yet in place.
> >> I have some patches in my tree to support fixmap, but they need some more
> >> work. Fortunately, once fixmap is in place, it is just a Kconfig option
> >> to enable earlycon support on ARM. A git tree is available here[1].
> >>
> >> Based on this series, I would like to add support for doing earlycon
> >> setup using DT.
> >
> > Hi Rob,
> >
> > I like this series a lot, great work!
> >
> > I would consider the DT parsing support essential here, we should not
> > merge the patches until that is done as well, because I don't want
> > to see users pass earlycon command line options in DT when they can
> > use the established "linux,stdout-path" property instead. I would
> > expect that in almost every case in which we are booting using DT
> > today, we can just use linux,stdout-path to locate the device that
> > the boot loader has already set up and start usign it.
> 
> I think this series stands on its own. It is largely refactoring
> existing code and supporting existing command line options (arm64 just
> changes from earlyprintk= to earlycon=). There will be cases where
> changing the kernel command line is the only way to setup the
> earlycon. Also, I think we would still want the kernel command line to
> control whether or not we enable the earlycon (i.e. earlycon=dt).
> There's not a standard way for how bootloaders would decide to set
> "linux,stdout-path" or not.

I agree. I really like this series and I don't think it needs to wait
for DT parsing.

Another issue is that the earlycon assumes the port is already set up,
but the /chosen/stdout-path binding doesn't guarantee that. We'll have
to make sure the kernel knows when it is valid to use
/chosen/stdout-path before enabling an early console.

g.

