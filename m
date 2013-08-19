Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782Ab3HSEGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:06:00 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45864 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3HSEF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:05:59 -0400
Date: Sun, 18 Aug 2013 21:05:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 5/5] rcu: Make rcutorture emit online
 failures if verbose
Message-ID: <20130819040549.GF29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818022453.GA3475@linux.vnet.ibm.com>
 <1376792717-3755-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376792717-3755-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818025905.GE28923@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818025905.GE28923@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081904-5518-0000-0000-0000114D6AB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 07:59:05PM -0700, Josh Triplett wrote:
> On Sat, Aug 17, 2013 at 07:25:17PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Although rcutorture counts CPU-hotplug online failures, it does
> > not explicitly record which CPUs were having trouble coming online.
> > This commit therefore emits a console message when online failure occurs.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> One completely optional note below; with or without that change,
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> >  kernel/rcutorture.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index 7d42d13..15bec39 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -1437,7 +1437,13 @@ rcu_torture_onoff(void *arg)
> >  					 torture_type, cpu);
> >  			starttime = jiffies;
> >  			n_online_attempts++;
> > -			if (cpu_up(cpu) == 0) {
> > +			ret = cpu_up(cpu);
> > +			if (ret != 0) {
> 
> Or just "if (ret) {"

Makes sense, fixed!

							Thanx, Paul

