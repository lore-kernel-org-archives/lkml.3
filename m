Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaEHAJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 20:09:07 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53213 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaEHAJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 20:09:04 -0400
Date: Wed, 7 May 2014 17:08:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 19/45] rcutorture: Print negatives for SRCU
 counter wraparound
Message-ID: <20140508000858.GX8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-19-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507213426.GK27924@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507213426.GK27924@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050800-7164-0000-0000-000001979406
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:34:26PM -0700, josh@joshtriplett.org wrote:
> On Mon, Apr 28, 2014 at 05:25:07PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The srcu_torture_stats() function prints SRCU's per-CPU c[] array with
> > an unsigned format, which means that the number one less than zero is
> > a very large number.  This commit therefore prints this array with a
> > signed format in order to improve readability of the rcutorture output.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Nit below; with that:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> >  kernel/rcu/rcutorture.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> > index 3845ea99ccd4..0141fcff6bb9 100644
> > --- a/kernel/rcu/rcutorture.c
> > +++ b/kernel/rcu/rcutorture.c
> > @@ -486,15 +486,16 @@ static void srcu_torture_barrier(void)
> >  
> >  static void srcu_torture_stats(char *page)
> >  {
> > +	long c0, c1;
> >  	int cpu;
> >  	int idx = srcu_ctl.completed & 0x1;
> >  
> >  	page += sprintf(page, "%s%s per-CPU(idx=%d):",
> >  		       torture_type, TORTURE_FLAG, idx);
> >  	for_each_possible_cpu(cpu) {
> > -		page += sprintf(page, " %d(%lu,%lu)", cpu,
> > -			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
> > -			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
> > +		c0 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx];
> > +		c1 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx];
> > +		page += sprintf(page, " %d(%ld,%ld)", cpu, c0, c1);
> 
> Nit: I'd suggest declaring the variables inside the loop, or not using
> intermediate variables at all.

Fair enough!  Can't see that I am gaining much by them.

							Thanx, Paul

