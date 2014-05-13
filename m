Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaEMVPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:15:13 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:33147 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbaEMVPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:15:08 -0400
Date: Tue, 13 May 2014 23:15:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] irq_work: Let arch tell us if it can raise irq work
Message-ID: <20140513211503.GG13828@localhost.localdomain>
References: <1399991921-17618-1-git-send-email-fweisbec@gmail.com>
 <1399991921-17618-2-git-send-email-fweisbec@gmail.com>
 <20140513170942.GC5226@laptop.programming.kicks-ass.net>
 <20140513193327.GF13828@localhost.localdomain>
 <20140513204802.GJ2485@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513204802.GJ2485@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 10:48:02PM +0200, Peter Zijlstra wrote:
> On Tue, May 13, 2014 at 09:33:29PM +0200, Frederic Weisbecker wrote:
> > On Tue, May 13, 2014 at 07:09:42PM +0200, Peter Zijlstra wrote:
> > > On Tue, May 13, 2014 at 04:38:37PM +0200, Frederic Weisbecker wrote:
> > > > We prepare for executing the full nohz kick through an irq work. But
> > > > if we do this as is, we'll run into conflicting tick locking: the tick
> > > > holds the hrtimer lock and the nohz kick may do so too.
> > > 
> > > It does? How does the tick end up holding that lock?
> > > 
> > > Normal hrtimer callbacks run without holding the hrtimer lock -- I made
> > > it so.
> > > 
> > > This means tick_sched_timer() is called without hrtimer lock, and I
> > > don't see it taking it anywhere in tick_sched_do_timer() or
> > > tick_sched_handle().
> > 
> > Check hrtimer_interrupt(), it takes the per cpu base->lock.
> 
> check __run_hrtimer() which drops base->lock over calling ->function.

Oh! I had lockdep splats a few days ago. But I think I worked too many hours
on it and eventually developed some brainfarted pet assumptions all along :-(

It was probably due to some other mistakes of mine. Ok, lets try again.

