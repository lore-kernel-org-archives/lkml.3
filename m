Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760400AbaGYVAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 17:00:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:59845 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaGYVAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:00:17 -0400
Date: Fri, 25 Jul 2014 23:00:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
In-Reply-To: <2870044.iEzUSaptji@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1407252217350.23352@nanos>
References: <20140724212620.GO3935@laptop> <20140725124037.GL20603@laptop.programming.kicks-ass.net> <20140725132541.GT12054@laptop.lan> <2870044.iEzUSaptji@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, Rafael J. Wysocki wrote:
> On Friday, July 25, 2014 03:25:41 PM Peter Zijlstra wrote:
> > OK, so Rafael said there's devices that keep on raising their interrupt
> > until they get attention. Ideally this won't happen because the device
> > is suspended etc.. But I'm sure there's some broken piece of hardware
> > out there that'll make it go boom.
> 
> So here's an idea.
> 
> What about returning IRQ_NONE rather than IRQ_HANDLED for "suspended"
> interrupts (after all, that's what a sane driver would do for a
> suspended device I suppose)?
> 
> If the line is really shared and the interrupt is taken care of by
> the other guy sharing the line, we'll be all fine.
> 
> If that is not the case, on the other hand, and something's really
> broken, we'll end up disabling the interrupt and marking it as
> IRQS_SPURIOUS_DISABLED (if I understand things correctly).

We should not wait 100k unhandled interrupts in that case. We know
already at the first unhandled interrupt that the shit hit the fan.

I'll have a deeper look how we can sanitize the whole wake/no_suspend
logic vs. shared interrupts. Need to look at the usage sites first.

Thanks,

	tglx







