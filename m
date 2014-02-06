Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbaBFRKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:10:47 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42127 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756351AbaBFRKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:10:45 -0500
Date: Thu, 6 Feb 2014 14:10:40 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] irqchip: orion: bridge irq fixes for v3.14-rc1
Message-ID: <20140206171039.GC12542@localhost>
References: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140205045415.GN8533@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140205045415.GN8533@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 11:54:15PM -0500, Jason Cooper wrote:
> On Thu, Jan 23, 2014 at 11:38:03PM +0100, Sebastian Hesselbarth wrote:
> > This is a small patch set to fix some shortcomings how Orion bridge
> > irqs are handled. The patches are based on v3.13-rc8 and should go
> > into v3.14. They can possibly also marked for -stable down to v3.10.
> > 
> > This patches are the result of a discussion about a stale watchdog irq,
> > that can accidentially trigger the watchdog's irq handler and cause a
> > reset [1].
> > 
> > The first patch will add a write to clear already pending interrupts
> > on init. The second patch replaces handle_level_irq with handle_edge_irq
> > which is more appropriate for bridge irqs which are edge-triggered.
> > The last patch finally, fixes stale interrupts by installing an
> > .irq_enable callback, that will clear a possible pending interrupt
> > before unmasking it.
> > 
> > [1] http://www.spinics.net/lists/arm-kernel/msg302106.html
> > 
> > Sebastian Hesselbarth (3):
> >   irqchip: orion: clear bridge cause register on init
> >   irqchip: orion: use handle_edge_irq on bridge irqs
> >   irqchip: orion: clear stale interrupts in irq_enable
> > 
> >  drivers/irqchip/irq-orion.c | 18 ++++++++++++++++--
> >  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> Whole series applied to mvebu-next/irqchip-fixes (v2 for 3/3).  Once I
> see that the outstanding pull requests for mvebu/irqchip have been
> merged into mainline, I'll be changing the name of this branch to
> mvebu/irqchip-fixes.  I just don't want to upset the applecart atm.
> 
> Oh yeah, Cc'd for stable back to v3.10.
> 

If you want to pick this:

Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Tested Kirkwood Topkick and Dove Cubox. Quite frankly, I haven't checked
this series prevents an "errant watchdog", but just pursued a boot test.

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
