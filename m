Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbaEGP3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:29:32 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53989 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaEGP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:29:29 -0400
Date: Wed, 7 May 2014 17:29:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        khilman@linaro.org, tglx@linutronix.de, axboe@fb.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/nohz] nohz: Move full nohz kick to its own IPI
Message-ID: <20140507152922.GB16694@localhost.localdomain>
References: <tip-72aacf0259bb7d53b7a3b5b2f7bf982acaa52b61@git.kernel.org>
 <20140505123706.GP17778@laptop.programming.kicks-ass.net>
 <20140505133113.GD1429@laptop.programming.kicks-ass.net>
 <20140505150356.GB2099@localhost.localdomain>
 <20140505151228.GR26782@laptop.programming.kicks-ass.net>
 <20140505153405.GD2099@localhost.localdomain>
 <20140507151735.GQ30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507151735.GQ30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 05:17:35PM +0200, Peter Zijlstra wrote:
> On Mon, May 05, 2014 at 05:34:08PM +0200, Frederic Weisbecker wrote:
> > On Mon, May 05, 2014 at 05:12:28PM +0200, Peter Zijlstra wrote:
> > > > Note the current ordering:
> > > > 
> > > >     cmpxchg(&qsd->pending, 0, 1)       get ipi
> > > >     csd_lock(qsd->csd)                 xchg(&qsd->pending, 1)
> > > >     send ipi                           csd_unlock(qsd->csd)
> > > > 
> > > > 
> > > > So there shouldn't be racing updaters. Also ipi sender shouldn't
> > > > race with ipi receiver, the update shouldn't always eventually see
> > > > the unlock happening.
> > > 
> > > Yeah, I've not spotted how this particular train wreck happens either.
> > > 
> > > The problem is reproduction, it took me 9 hours to confirm I could
> > > reproduce the problem on my machine. So how long to I run it with this
> > > patch reverted to show its gone..
> > 
> > Maybe it could be favoured cpu hotplug. Anyway converting to irq_work should
> > fix it.
> 
> Ingo needs a commit msg for the revert of this patch; do you think you
> have time to look into _why_ this patch is broken and write such a
> thing?

I can try but I need to reproduce it. Do you have any clue on how to do so?
Also which HEAD were you guys using?

Thanks.
