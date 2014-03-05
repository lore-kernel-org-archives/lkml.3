Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbaCEVgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:36:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:46730 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaCEVge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:36:34 -0500
Date: Wed, 5 Mar 2014 22:36:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Revert "irqchip: irq-dove: Add PMU interrupt
 controller."
In-Reply-To: <20140305192005.GX21483@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1403052222220.18573@ionos.tec.linutronix.de>
References: <20140304030838.GA1872@titan.lakedaemon.net> <1393911160-7688-1-git-send-email-jason@lakedaemon.net> <20140305004139.GT21483@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1403051445020.18573@ionos.tec.linutronix.de>
 <20140305192005.GX21483@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Russell King - ARM Linux wrote:
> On Wed, Mar 05, 2014 at 03:42:34PM +0100, Thomas Gleixner wrote:
> > On Wed, 5 Mar 2014, Russell King - ARM Linux wrote:
> > > This results in the RTC alarm test receiving exactly one interrupt for
> > > each alarm expiry, as it should do.  Thoughts?
> > 
> > You are worried about clearing an interrupt which is transitory and
> > not kept active at the device level until you handled it for real,
> > right?
> 
> Yep.  Let's take the code:
> 
> 	ldr	r0, [r1]		; read the interrupt cause register
> 	and	r0, r0, r2		; clear interrupts we've serviced
> 	str	r0, [r1]		; write it back
> 
> The problem here is if a transitory interrupt is received between the
> load and store, the write can clear it back to zero.  There's nothing
> which can be done to get around that - which is why I'd prefer to do
> this as infrequently as necessary.

Yes, that's the only sensible thing you can do. Is there any transient
interrupt connected to that irq controller or is this as vague as the
rest of the documentation?
 
> > Is the datasheet for this stuff public available?
> 
> Thankfully, it is, but like many such things, it'll leave you with /lots/
> of questions.  In the case of this register, the documentation only goes
> as far as describing the bits, but doesn't really describe their behaviour.
> Much of that can only come via experimentation with the hardware. :(

Sigh. I really want to understand why SoC companies waste lots of
resources to implement pointless and disfunctional variants of
interrupt controllers (or timers) over and over.

Thanks,

	tglx

