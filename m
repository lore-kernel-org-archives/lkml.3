Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab3IJJTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:19:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41500 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3IJJTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:19:53 -0400
Date: Tue, 10 Sep 2013 11:19:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [RFC] seqcount: Add lockdep functionality to
 seqcount/seqlock structures
Message-ID: <20130910091945.GR26785@twins.programming.kicks-ass.net>
References: <1378788166-18474-1-git-send-email-john.stultz@linaro.org>
 <20130910081156.GK26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910081156.GK26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:11:56AM +0200, Peter Zijlstra wrote:
> On Mon, Sep 09, 2013 at 09:42:46PM -0700, John Stultz wrote:
> > +++ b/include/linux/lockdep.h
> > @@ -510,6 +510,21 @@ static inline void print_irqtrace_events(struct task_struct *curr)
> >  
> >  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >  # ifdef CONFIG_PROVE_LOCKING
> > +#  define seqcount_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
> > +#  define seqcount_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
> > +# else
> > +#  define seqcount_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
> > +#  define seqcount_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
> > +# endif
> > +# define seqcount_release(l, n, i)		lock_release(l, n, i)
> > +#else
> > +# define seqcount_acquire(l, s, t, i)		do { } while (0)
> > +# define seqcount_acquire_read(l, s, t, i)	do { } while (0)
> > +# define seqcount_release(l, n, i)		do { } while (0)
> > +#endif
> 
> Please look at a recent lockdep.h, this pattern changed a little.

And when you're there, can you please remove the superfluous whitespace
before rwsem_release and lock_map_release ?
