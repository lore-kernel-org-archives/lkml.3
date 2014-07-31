Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaGaUzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:55:10 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47226 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaGaUzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:55:08 -0400
Date: Thu, 31 Jul 2014 13:55:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 04/10] rcu: Export RCU-tasks APIs to GPL
 modules
Message-ID: <20140731205502.GB11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1406767182-4356-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140731165620.GC12697@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731165620.GC12697@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073120-9332-0000-0000-0000018F680E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 09:56:20AM -0700, josh@joshtriplett.org wrote:
> On Wed, Jul 30, 2014 at 05:39:36PM -0700, Paul E. McKenney wrote:
> > From: Steven Rostedt <rostedt@goodmis.org>
> > 
> > This commit exports the RCU-tasks APIs, call_rcu_tasks(),
> > synchronize_rcu_tasks(), and rcu_barrier_tasks(), to GPL-licensed
> > kernel modules.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> Should this remain a separate patch, or go into the patch that creates
> these APIs?

Excellent question.  Keeping them separate for now, but...

							Thanx, Paul

> >  kernel/rcu/update.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > index c8d304dc6d8a..1bfc07ed854e 100644
> > --- a/kernel/rcu/update.c
> > +++ b/kernel/rcu/update.c
> > @@ -429,6 +429,7 @@ void synchronize_rcu_tasks(void)
> >  	/* Wait for the grace period. */
> >  	wait_rcu_gp(call_rcu_tasks);
> >  }
> > +EXPORT_SYMBOL_GPL(synchronize_rcu_tasks);
> >  
> >  /**
> >   * rcu_barrier_tasks - Wait for in-flight call_rcu_tasks() callbacks.
> > @@ -441,6 +442,7 @@ void rcu_barrier_tasks(void)
> >  	/* There is only one callback queue, so this is easy.  ;-) */
> >  	synchronize_rcu_tasks();
> >  }
> > +EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
> >  
> >  /* RCU-tasks kthread that detects grace periods and invokes callbacks. */
> >  static int __noreturn rcu_tasks_kthread(void *arg)
> > -- 
> > 1.8.1.5
> > 
> 

