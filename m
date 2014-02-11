Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaBKQb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:31:57 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50690 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaBKQby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:31:54 -0500
Date: Tue, 11 Feb 2014 08:13:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@freedesktop.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 5/9] rcu: Use MAX_NICE to replace hard coding of 19.
Message-ID: <20140211161313.GV4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <20140211153732.GA2985@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211153732.GA2985@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021116-0928-0000-0000-000006389463
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 07:37:32AM -0800, Josh Triplett wrote:
> On Tue, Feb 11, 2014 at 03:34:49PM +0800, Dongsheng Yang wrote:
> > Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> > cc: Josh Triplett <josh@freedesktop.org>
> > cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > cc: Peter Zijlstra <peterz@infradead.org>
> > cc: Ingo Molnar <mingo@kernel.org>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

I get complaints about MAX_NICE being undefined, and I don't see any
definition of MAX_NICE in sched.h as of 3.14-rc2.  Am I looking in
the wrong place, or is this symbol not yet quite in mainline?

						Thanx, Paul

> >  kernel/rcu/torture.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/rcu/torture.c b/kernel/rcu/torture.c
> > index 732f8ae..219761d 100644
> > --- a/kernel/rcu/torture.c
> > +++ b/kernel/rcu/torture.c
> > @@ -805,7 +805,7 @@ rcu_torture_writer(void *arg)
> >  	static DEFINE_RCU_RANDOM(rand);
> >  
> >  	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
> > -	set_user_nice(current, 19);
> > +	set_user_nice(current, MAX_NICE);
> >  
> >  	do {
> >  		schedule_timeout_uninterruptible(1);
> > @@ -871,7 +871,7 @@ rcu_torture_fakewriter(void *arg)
> >  	DEFINE_RCU_RANDOM(rand);
> >  
> >  	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
> > -	set_user_nice(current, 19);
> > +	set_user_nice(current, MAX_NICE);
> >  
> >  	do {
> >  		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
> > @@ -987,7 +987,7 @@ rcu_torture_reader(void *arg)
> >  	unsigned long long ts;
> >  
> >  	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
> > -	set_user_nice(current, 19);
> > +	set_user_nice(current, MAX_NICE);
> >  	if (irqreader && cur_ops->irq_capable)
> >  		setup_timer_on_stack(&t, rcu_torture_timer, 0);
> >  
> > @@ -1584,7 +1584,7 @@ static int rcu_torture_barrier_cbs(void *arg)
> >  
> >  	init_rcu_head_on_stack(&rcu);
> >  	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task started");
> > -	set_user_nice(current, 19);
> > +	set_user_nice(current, MAX_NICE);
> >  	do {
> >  		wait_event(barrier_cbs_wq[myid],
> >  			   (newphase =
> > -- 
> > 1.8.2.1
> > 
> 

