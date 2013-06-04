Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3FECDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 22:03:52 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59834 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3FECDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:03:38 -0400
Date: Tue, 4 Jun 2013 06:14:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu: Hotplug and PROVE_RCU_DELAY not playing well
 together
Message-ID: <20130604131408.GK11597@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1370035669.26799.85.camel@gandalf.local.home>
 <20130602025425.GE3957@linux.vnet.ibm.com>
 <20130602141814.GA24198@linux.vnet.ibm.com>
 <1370283591.26799.95.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370283591.26799.95.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060502-7606-0000-0000-00000C2A5577
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 02:19:51PM -0400, Steven Rostedt wrote:
> On Sun, 2013-06-02 at 07:18 -0700, Paul E. McKenney wrote:
> 
> > ------------------------------------------------------------------------
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index d12470e..9a08bdc 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1320,9 +1320,9 @@ static int rcu_gp_init(struct rcu_state *rsp)
> >  					    rnp->grphi, rnp->qsmask);
> >  		raw_spin_unlock_irq(&rnp->lock);
> >  #ifdef CONFIG_PROVE_RCU_DELAY
> > -		if ((prandom_u32() % (rcu_num_nodes * 8)) == 0 &&
> > +		if ((prandom_u32() % (rcu_num_nodes + 1)) == 0 &&
> >  		    system_state == SYSTEM_RUNNING)
> > -			schedule_timeout_uninterruptible(2);
> > +			udelay(200);
> >  #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
> >  		cond_resched();
> >  	}
> 
> I ran this for a bit. Where it usually crashes in less than a minute,
> this ran for over 10 minutes without issue.
> 
> Tested-by: Steven Rostedt <rostedt@goodmis.org>

Thank you!!!

And yes, if this was production code rather than test code, I probably
would have favored a solution like yours.

							Thanx, Paul

