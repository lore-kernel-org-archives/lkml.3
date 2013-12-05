Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3LECNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:13:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:40241 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3LECNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:13:05 -0500
Date: Thu, 5 Dec 2013 03:12:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Neil Zhang <zhangwm@marvell.com>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        haojian.zhuang@gmail.com, LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM: gic_arch_extn (Was: [PATCH v3] irqchip: mmp: add dt support
 for wakeup)
In-Reply-To: <20131205005216.GA4360@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1312050157550.30673@ionos.tec.linutronix.de>
References: <1386159214-31483-1-git-send-email-zhangwm@marvell.com> <alpine.DEB.2.02.1312042234190.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312042347350.30673@ionos.tec.linutronix.de> <20131205005216.GA4360@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Thu, 5 Dec 2013, Russell King - ARM Linux wrote:
> On Thu, Dec 05, 2013 at 01:41:53AM +0100, Thomas Gleixner wrote:
> > @all who feel responsible for gic_arch_extn
> > 
> > On Wed, 4 Dec 2013, Thomas Gleixner wrote:
> > > I'm going to reply in a separate mail on this, because you have
> > > brought this to my attention, but you are not responsible in the first
> > > place for this brainfart.
> > 
> > Who came up with that gic_arch_extn concept in the first place?
> 
> If you'd spend more time reviewing IRQ patches then maybe you'd catch
> this at review time.  So please stop your rediculous whinging when
> most of the problem is your own lack of time.

I'm not a native english speaker, so I want to make sure in the first
place that you meant:

    "ridiculous whingeing" 

Assumed that you meant that, let me ridicule you a bit.

The gic_arch_extn concept got merged with:

    commit d7ed36a4ea84e3a850f9932e2058ceef987d1acd
    Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Date:   Wed Mar 2 08:03:22 2011 +0100

    ARM: 6777/1: gic: Add hooks for architecture specific extensions

    <SNIP>

    Cc: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Acked-by: Colin Cross <ccross@android.com>
    Tested-by: Colin Cross <ccross@android.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

    ---
    arch/arm/common/gic.c		|   47 ++++++++++++....
    arch/arm/include/asm/hardware/gic.h |    1

The patch in question was never cc'ed to me and you merged it on your
own.

So now you have the chuzpe to blame me for that, just because this
code moved to drivers/irqchip with

     commit 81243e444c6e9d1625073e4a3d3bc244c8a545f0
     Author: Rob Herring <rob.herring@calxeda.com>
     Date:   Tue Nov 20 21:21:40 2012 -0600

     irqchip: Move ARM GIC to drivers/irqchip
    
almost two years later?

The code move neither exempts you from the responsibility of merging
it nor does it imply a retroactive responsibility for me to review all
patches which went into that code prior to the move.

Thanks,

	tglx
