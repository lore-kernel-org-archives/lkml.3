Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaBEEyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 23:54:39 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26118 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbaBEEyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 23:54:38 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+VqfCt80Tp8CD+IhUp4ISLsbdQCzHKhkI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 93AF551DD01
Date: Tue, 4 Feb 2014 23:54:15 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] irqchip: orion: bridge irq fixes for v3.14-rc1
Message-ID: <20140205045415.GN8533@titan.lakedaemon.net>
References: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:38:03PM +0100, Sebastian Hesselbarth wrote:
> This is a small patch set to fix some shortcomings how Orion bridge
> irqs are handled. The patches are based on v3.13-rc8 and should go
> into v3.14. They can possibly also marked for -stable down to v3.10.
> 
> This patches are the result of a discussion about a stale watchdog irq,
> that can accidentially trigger the watchdog's irq handler and cause a
> reset [1].
> 
> The first patch will add a write to clear already pending interrupts
> on init. The second patch replaces handle_level_irq with handle_edge_irq
> which is more appropriate for bridge irqs which are edge-triggered.
> The last patch finally, fixes stale interrupts by installing an
> .irq_enable callback, that will clear a possible pending interrupt
> before unmasking it.
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg302106.html
> 
> Sebastian Hesselbarth (3):
>   irqchip: orion: clear bridge cause register on init
>   irqchip: orion: use handle_edge_irq on bridge irqs
>   irqchip: orion: clear stale interrupts in irq_enable
> 
>  drivers/irqchip/irq-orion.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)

Whole series applied to mvebu-next/irqchip-fixes (v2 for 3/3).  Once I
see that the outstanding pull requests for mvebu/irqchip have been
merged into mainline, I'll be changing the name of this branch to
mvebu/irqchip-fixes.  I just don't want to upset the applecart atm.

Oh yeah, Cc'd for stable back to v3.10.

thx,

Jason.
