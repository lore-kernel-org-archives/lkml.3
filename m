Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab3E3TiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:38:21 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11195 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759827Ab3E3TiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:38:13 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/tk1Xl3a1Z3NdwjEbjYQ5UJf35c6c+79U=
Date: Thu, 30 May 2013 15:37:08 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Arnaud Ebalard <arno@natisbad.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 12/13] ARM: kirkwood: remove redundant DT board files
Message-ID: <20130530193708.GC31290@titan.lakedaemon.net>
References: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369855975-21489-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369855975-21489-13-git-send-email-sebastian.hesselbarth@gmail.com>
 <8738t4q1kv.fsf@natisbad.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738t4q1kv.fsf@natisbad.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 11:06:08AM +0200, Arnaud Ebalard wrote:
> Hi Jason and Sebastian,
> 
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> writes:
> 
> > With DT support for mv643xx_eth board specific init for some boards now
> > is unneccessary. Remove those board files, Kconfig entries, and
> > corresponding entries in kirkwood_defconfig.
> >
> > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > ---
> > Note: board-km_kirkwood.c is also removed, as Valentin Longchamp confirmed
> > the lock-up is not caused by accessing clock gating registers but rather
> > non-existent device registers. This will be addressed by dtsi separation
> > for kirkwood and bobcat SoC variants.
> >
> > Changelog:
> > v3->v4:
> > - remove more boards that don't require board specific setup
> >
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Lennert Buytenhek <buytenh@wantstofly.org>
> > Cc: Jason Cooper <jason@lakedaemon.net>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: netdev@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linuxppc-dev@lists.ozlabs.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/arm/configs/kirkwood_defconfig           |   16 ----
> >  arch/arm/mach-kirkwood/Kconfig                |  117 -------------------------
> >  arch/arm/mach-kirkwood/Makefile               |   16 ----
> >  arch/arm/mach-kirkwood/board-dnskw.c          |    7 --
> >  arch/arm/mach-kirkwood/board-dockstar.c       |   32 -------
> >  arch/arm/mach-kirkwood/board-dreamplug.c      |   35 --------
> >  arch/arm/mach-kirkwood/board-dt.c             |   62 +------------
> >  arch/arm/mach-kirkwood/board-goflexnet.c      |   34 -------
> >  arch/arm/mach-kirkwood/board-guruplug.c       |   33 -------
> >  arch/arm/mach-kirkwood/board-ib62x0.c         |   29 ------
> >  arch/arm/mach-kirkwood/board-iconnect.c       |   10 ---
> >  arch/arm/mach-kirkwood/board-iomega_ix2_200.c |   34 -------
> >  arch/arm/mach-kirkwood/board-km_kirkwood.c    |   44 ----------
> >  arch/arm/mach-kirkwood/board-lsxl.c           |   16 ----
> >  arch/arm/mach-kirkwood/board-mplcec4.c        |   14 ---
> >  arch/arm/mach-kirkwood/board-ns2.c            |   35 --------
> >  arch/arm/mach-kirkwood/board-openblocks_a6.c  |   26 ------
> >  arch/arm/mach-kirkwood/board-readynas.c       |    6 --
> 
> Just a stupid note: With Thomas ongoing work to get mvebu-pcie driver in
> place and enabled for kirkwood, some boards setup files will also lose
> their pcie init routines, which may allow you to kill those additonal
> files soon.

Yes, we're very excited about this ;-)

> For instance 6bd98481ab34 (arm: kirkwood: NETGEAR ReadyNAS Duo v2 init
> PCIe via DT) currently sitting in jcooper/mvebu/pcie_kirkwood removes
> the PCIE init routine in board-readynas.c, and yours remove ge00
> init. With both applied, the whole file can go away.
> 
> AFAICT, this may be the case soon for:
> 
>  arch/arm/mach-kirkwood/board-iconnect.c   (36e5722089)
>  arch/arm/mach-kirkwood/board-mplcec4.c    (9470fbfb8d)
>  arch/arm/mach-kirkwood/board-nsa310.c     (40fa8e5da2)
>  arch/arm/mach-kirkwood/board-readynas.c   (6bd98481ab)
>  arch/arm/mach-kirkwood/board-ts219.c      (259e234608)

Would you mind putting a patch together (for after v3.10 drops) to do
this?  If you applied Sebastian's series on top of mvebu/pcie_kirkwood,
that should get you almost there.  The last half of his series is going
in after v3.10...

You may want to try merging in mvebu/boards and mvebu/soc.  Those have
the changes to use dt for the restart and power-off drivers.  That'll
allow us to empty out a few more board files.  mvebu/dt also has a patch
from Valentin allowing us to remove the keymile board as well.

thx,

Jason.
