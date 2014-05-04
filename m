Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaEDRmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:42:42 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15777 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751362AbaEDRml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 13:42:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+u0GUxrOe7xVmU/FT3+2VXsTPFyTCPSeA=
X-DKIM: OpenDKIM Filter v2.0.1 titan A5D3D56B00B
Date: Sun, 4 May 2014 13:42:16 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Olof Johansson <olof@lixom.net>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Marek Vasut <marex@denx.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 1/5] ARM: defconfigs: add MTD_SPI_NOR (new dependency
 for M25P80)
Message-ID: <20140504174216.GV28159@titan.lakedaemon.net>
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com>
 <1397719309-2022-2-git-send-email-computersforpeace@gmail.com>
 <535A8FC9.8040707@wwwdotorg.org>
 <20140429190603.GB9418@norris-Latitude-E6410>
 <20140430114548.GQ28159@titan.lakedaemon.net>
 <CAOesGMi0zK8H=Ok81ZLhssvG5gsbvanY4dct_PF95Exq6p3tfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMi0zK8H=Ok81ZLhssvG5gsbvanY4dct_PF95Exq6p3tfg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 03:51:11PM -0700, Olof Johansson wrote:
> On Wed, Apr 30, 2014 at 4:45 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > On Tue, Apr 29, 2014 at 12:06:03PM -0700, Brian Norris wrote:
> >> Hi Stephen,
> >>
> >> On Fri, Apr 25, 2014 at 10:39:37AM -0600, Stephen Warren wrote:
> >> > On 04/17/2014 01:21 AM, Brian Norris wrote:
> >> > > These defconfigs contain the CONFIG_M25P80 symbol, which is now
> >> > > dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to the
> >> > > relevant defconfigs.
> >> > >
> >> > > At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.
> >> >
> >> > I hadn't realized that the problem this patch solves was already present
> >> > in the code, so this patch is simply catching up the defconfigs rather
> >> > than part of a series which changed the code to cause the problem.
> >>
> >> Yes, this is "catching up the defconfigs." The SPI_NOR framework is new,
> >> and I didn't want to generate defconfig noise until a few things
> >> stabilized (particularly, its Kconfig symbol name).
> >>
> >> > So, this needs to be applied ASAP.
> >> >
> >> > I think this should be split it up so that each defconfig can go through
> >> > the tree that owns it to avoid conflicts. If you repost split up, I can
> >> > apply the tegra_defconfig change to the Tegra tree.
> >>
> >> OK, I'll try to split it up. Is ARM unique in tracking defconfigs in
> >> separate trees? I assume MIPS, PowerPC, and Blackfin won't require the
> >> same splitting? I'd like to avoid 31 patches when <20 could suffice.
> >
> > wrt arm-soc, typically they take all changes to multi_v7_defconfig
> > directly since it is prone to conflicts.  All the other ones are managed
> > by the individual sub-arch maintainers.
> >
> >> I'll also rebase on linux-next. I think there may be a few conflicts.
> >
> > I can't speak for the other sub-archs, but I typically prefer that
> > patches be based on an -rc tag, -rc1 if possible.
> 
> This is making a trivial patch a pain to get merged.

Sorry.

> Cases like these are easiest that we just take the patch directly in
> an early-merge branch (i.e. cleanup or fixes-non-critical, or a
> generic depends branch), and if there's conflicts as topics are merged
> in from subplatforms we can deal with it then.

Are you referring to basing on -rc1, or the series being split up to
the individual sub-arch maintainers?

*slightly* confused,

Jason.
