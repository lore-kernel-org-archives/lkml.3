Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbaBFSFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:05:33 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24294 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751942AbaBFSFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:05:32 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+KjnKPDmFNEQzki6rs+88/YzTHSuINF40=
X-DKIM: OpenDKIM Filter v2.0.1 titan 60F6751F9DF
Date: Thu, 6 Feb 2014 13:05:06 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 0/3] irqchip: orion: bridge irq fixes for v3.14-rc1
Message-ID: <20140206180506.GJ8533@titan.lakedaemon.net>
References: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140205045415.GN8533@titan.lakedaemon.net>
 <20140206171039.GC12542@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206171039.GC12542@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 02:10:40PM -0300, Ezequiel Garcia wrote:
> On Tue, Feb 04, 2014 at 11:54:15PM -0500, Jason Cooper wrote:
> > On Thu, Jan 23, 2014 at 11:38:03PM +0100, Sebastian Hesselbarth wrote:
> > > This is a small patch set to fix some shortcomings how Orion bridge
> > > irqs are handled. The patches are based on v3.13-rc8 and should go
> > > into v3.14. They can possibly also marked for -stable down to v3.10.
> > > 
> > > This patches are the result of a discussion about a stale watchdog irq,
> > > that can accidentially trigger the watchdog's irq handler and cause a
> > > reset [1].
> > > 
> > > The first patch will add a write to clear already pending interrupts
> > > on init. The second patch replaces handle_level_irq with handle_edge_irq
> > > which is more appropriate for bridge irqs which are edge-triggered.
> > > The last patch finally, fixes stale interrupts by installing an
> > > .irq_enable callback, that will clear a possible pending interrupt
> > > before unmasking it.
> > > 
> > > [1] http://www.spinics.net/lists/arm-kernel/msg302106.html
> > > 
> > > Sebastian Hesselbarth (3):
> > >   irqchip: orion: clear bridge cause register on init
> > >   irqchip: orion: use handle_edge_irq on bridge irqs
> > >   irqchip: orion: clear stale interrupts in irq_enable
> > > 
> > >  drivers/irqchip/irq-orion.c | 18 ++++++++++++++++--
> > >  1 file changed, 16 insertions(+), 2 deletions(-)
> > 
> > Whole series applied to mvebu-next/irqchip-fixes (v2 for 3/3).  Once I
> > see that the outstanding pull requests for mvebu/irqchip have been
> > merged into mainline, I'll be changing the name of this branch to
> > mvebu/irqchip-fixes.  I just don't want to upset the applecart atm.
> > 
> > Oh yeah, Cc'd for stable back to v3.10.
> > 
> 
> If you want to pick this:
> 
> Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Added, thanks for testing!

thx,

Jason.
