Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3EaL4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:56:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33719 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3EaLz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:55:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18WRGGgfGz29+hoV2HQNlB488zlxV79nwo=
Date: Fri, 31 May 2013 07:54:50 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Arnaud Ebalard <arno@natisbad.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v5 12/13] ARM: kirkwood: remove redundant DT board files
Message-ID: <20130531115450.GA3803@titan.lakedaemon.net>
References: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369855975-21489-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369855975-21489-13-git-send-email-sebastian.hesselbarth@gmail.com>
 <8738t4q1kv.fsf@natisbad.org>
 <20130530193708.GC31290@titan.lakedaemon.net>
 <87txlknluf.fsf@natisbad.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txlknluf.fsf@natisbad.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaud,

On Fri, May 31, 2013 at 12:28:56AM +0200, Arnaud Ebalard wrote:
> Hi,
> 
> Jason Cooper <jason@lakedaemon.net> writes:
> 
> >> For instance 6bd98481ab34 (arm: kirkwood: NETGEAR ReadyNAS Duo v2 init
> >> PCIe via DT) currently sitting in jcooper/mvebu/pcie_kirkwood removes
> >> the PCIE init routine in board-readynas.c, and yours remove ge00
> >> init. With both applied, the whole file can go away.
> >> 
> >> AFAICT, this may be the case soon for:
> >> 
> >>  arch/arm/mach-kirkwood/board-iconnect.c   (36e5722089)
> >>  arch/arm/mach-kirkwood/board-mplcec4.c    (9470fbfb8d)
> >>  arch/arm/mach-kirkwood/board-nsa310.c     (40fa8e5da2)
> >>  arch/arm/mach-kirkwood/board-readynas.c   (6bd98481ab)
> >>  arch/arm/mach-kirkwood/board-ts219.c      (259e234608)
> >
> > Would you mind putting a patch together (for after v3.10 drops) to do
> > this?  If you applied Sebastian's series on top of mvebu/pcie_kirkwood,
> > that should get you almost there.  The last half of his series is going
> > in after v3.10...
> 
> Something like the quick quilt-generated patch at the end of this email
> (done after a dummy merge of Sebastian's set in mvebu/pcie_kirkwood)? 

yep.

> I will take a look at what remains after Sebastian's set hit one of
> your branch but I guess he will have included most of what is in the
> patch to help you with the merge.
> 
> Anyway, at the end here is what DT board files would remain:
> 
> $ ls -1 arch/arm/mach-kirkwood/board-*.c
> arch/arm/mach-kirkwood/board-dnskw.c

This one seems to just be setting a gpio to enable reboot after power
failure.  Should be simple to move to DT.

> arch/arm/mach-kirkwood/board-dt.c

We obviously need this one. ;-)

> arch/arm/mach-kirkwood/board-lsxl.c

This is taken care of in mvebu/boards

  391a16c ARM: Kirkwood: Convert LSXL to restart-poweroff driver.

> arch/arm/mach-kirkwood/board-ts219.c

Also in mvebu/boards

  4350a47 ARM: Kirkwood: Make use of the QNAP Power off driver.

> Just one question though: the removal of MACH_*_DT in Kconfig removes
> the automatic selection of useful board specific options like
> ARM_APPENDED_DTB, ARM_ATAG_DTB_COMPAT, POWER_RESET_RESTART,
> POWER_RESET_QNAP. Is that expected?

I would select POWER_RESET_QNAP and POWER_RESET_RESTART in Kconfig for
ARCH_KIRKWOOD_DT, and put ARM_APPENDED_DTB and ARM_ATAG_DTB_COMPAT into
the defconfig.

thx,

Jason.
