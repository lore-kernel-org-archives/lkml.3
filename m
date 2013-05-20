Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab3ETR6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:58:55 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63675 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab3ETR6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:58:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19zWORWaqlwyTrQdeP9WdwUkX7NRSHaRwU=
Date: Mon, 20 May 2013 13:58:27 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
Message-ID: <20130520175827.GC31290@titan.lakedaemon.net>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130516184658.0650f838@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516184658.0650f838@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 06:46:58PM +0200, Thomas Petazzoni wrote:
> Sebastian, Jason, Andrew, Gregory,
> 
> On Sat, 11 May 2013 03:08:00 +0200, Sebastian Hesselbarth wrote:
> > Marvell EBU SoCs share some common clock functions that register core
> > clocks or clock gates from SoC specific data. These clock drivers are
> > organized by function and over time the drivers filled up with #ifdefs
> > to separate different SoC specific code.
> > 
> > This patch set first adds a new element to clock gate descriptors to
> > allow to pass clk flags per clock gate. (Patch 1)
> > 
> > Then it restructures MVEBU clock drivers into common clock setup and
> > SoC specific files and Kconfig options. The driver's init functions
> > are also registered to get called with of_clk_init. (Patches 2, 3-6)
> > 
> > It then switches Dove, Kirkwood, and Armada 370/XP to make use of
> > of_clk_init instead of mvebu_clocks_init. (Patches 7-9)
> > 
> > Finally, all obsolete files and Kconfig options are removed. (Patch 10)
> > 
> > It has been tested on CuBox (Dove) and Dockstar (Kirkwood) by me.
> > Armada 370 and XP are compile tested only and should get their Tested-by
> > from Thomas and Gregory, respectively.
> > 
> > @Mike: As this only touches MVEBU related code, I suggest to take it
> > all through the corresponding ARM branch.
> > 
> > Sebastian Hesselbarth (10):
> >   clk: mvebu: introduce per-clock-gate flags
> >   clk: mvebu: add common clock functions for core clk and clk gating
> >   clk: mvebu: add Dove SoC-centric clock init
> >   clk: mvebu: add Kirkwood SoC-centric clock init
> >   clk: mvebu: add Armada 370 SoC-centric clock init
> >   clk: mvebu: add Armada XP SoC-centric clock init
> >   ARM: dove: move DT boards to SoC-centric clock init
> >   ARM: kirkwood: move DT boards to SoC-centric clock init
> >   ARM: mvebu: move DT boards to SoC-centric clock init
> >   clk: mvebu: desintegrate obsolete file
> 
> Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 
> I've tested on Armada 370 DB (after reverting the ARM core patch that
> prevents this platform from booting) and the Armada XP DB. Both boards
> boot fine, and detect PCIe devices as they should.
> 
> There is some conflict between this set of commits and the two commits
> that modify the PCIe clocks in my PCIe series. I've pushed a branch at
> https://github.com/MISL-EBU-System-SW/mainline-public/tree/marvell-pcie-v10-and-seb-clks
> which has the mvebu PCIe stuff + Sebastian patches on top of it, with
> the conflicts resolved. The tricky thing is that since Sebastian is
> adding new clock files, and then removing the old ones, it's pretty
> easy to "loose" the changes the two PCIe clock patches are doing. The
> branch above works on Armada 370/XP, so you can compare the clock files
> if needed.

hmm, in my haste yesterday, I did this in the opposite order (clk, then
pcie on top).  I'm going to reshuffle them because I don't want pcie
depending on and waiting for this clock series to be ready :)

The good news is everything (except kirkwood-pcie, ran out of time) made
it through linux-next!  Also, kisskb is now building mvebu_defconfig in
addition to all the other ones.

thx,

Jason.
