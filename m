Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaCPGOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 02:14:19 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:56028 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaCPGOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 02:14:18 -0400
Message-ID: <1394950455.5470.16.camel@marge.simpson.net>
Subject: Re: cond_resched() and RCU CPU stall warnings
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@elte.hu, josh@joshtriplett.org,
        laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Date: Sun, 16 Mar 2014 07:14:15 +0100
In-Reply-To: <1394950182.5470.15.camel@marge.simpson.net>
References: <20140316015914.GA22102@linux.vnet.ibm.com>
	 <1394950182.5470.15.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-16 at 07:09 +0100, Mike Galbraith wrote: 
> On Sat, 2014-03-15 at 18:59 -0700, Paul E. McKenney wrote: 

> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index b46131ef6aab..994d2b0fd0b2 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4075,6 +4075,9 @@ int __sched _cond_resched(void)
> >  		__cond_resched();
> >  		return 1;
> >  	}
> > +	preempt_disable();
> > +	rcu_note_context_switch(smp_processor_id());
> > +	preempt_enable();
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL(_cond_resched);
> 
> Hm.  Since you only care about the case where your task is solo, how
> about do racy checks, 100% accuracy isn't required is it?  Seems you
> wouldn't want to unconditionally do that in tight loops.

(or do that in scheduler_tick()?)

