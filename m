Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaEEPeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:34:20 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63811 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaEEPeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:34:17 -0400
Date: Mon, 5 May 2014 17:34:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        khilman@linaro.org, tglx@linutronix.de, axboe@fb.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/nohz] nohz: Move full nohz kick to its own IPI
Message-ID: <20140505153405.GD2099@localhost.localdomain>
References: <tip-72aacf0259bb7d53b7a3b5b2f7bf982acaa52b61@git.kernel.org>
 <20140505123706.GP17778@laptop.programming.kicks-ass.net>
 <20140505133113.GD1429@laptop.programming.kicks-ass.net>
 <20140505150356.GB2099@localhost.localdomain>
 <20140505151228.GR26782@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505151228.GR26782@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 05:12:28PM +0200, Peter Zijlstra wrote:
> > Note the current ordering:
> > 
> >     cmpxchg(&qsd->pending, 0, 1)       get ipi
> >     csd_lock(qsd->csd)                 xchg(&qsd->pending, 1)
> >     send ipi                           csd_unlock(qsd->csd)
> > 
> > 
> > So there shouldn't be racing updaters. Also ipi sender shouldn't
> > race with ipi receiver, the update shouldn't always eventually see
> > the unlock happening.
> 
> Yeah, I've not spotted how this particular train wreck happens either.
> 
> The problem is reproduction, it took me 9 hours to confirm I could
> reproduce the problem on my machine. So how long to I run it with this
> patch reverted to show its gone..

Maybe it could be favoured cpu hotplug. Anyway converting to irq_work should
fix it.
