Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab3GRMNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:13:04 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52992 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756913Ab3GRMNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:13:01 -0400
Date: Thu, 18 Jul 2013 17:42:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too
 frequently
Message-ID: <20130718121245.GA3745@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130716202015.GX17211@twins.programming.kicks-ass.net>
 <1374014881.2332.21.camel@j-VirtualBox>
 <20130717072504.GY17211@twins.programming.kicks-ass.net>
 <1374048701.6000.21.camel@j-VirtualBox>
 <20130717093913.GP23818@dyad.programming.kicks-ass.net>
 <1374076741.7412.35.camel@j-VirtualBox>
 <20130717161815.GR23818@dyad.programming.kicks-ass.net>
 <51E6D9B7.1030705@redhat.com>
 <20130717180156.GS23818@dyad.programming.kicks-ass.net>
 <1374120144.1816.45.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1374120144.1816.45.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071812-5806-0000-0000-0000221A8DB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > idle_balance(u64 idle_duration)
> > {
> >   u64 cost = 0;
> > 
> >   for_each_domain(sd) {
> >     if (cost + sd->cost > idle_duration/N)
> >       break;
> > 
> >     ...
> > 
> >     sd->cost = (sd->cost + this_cost) / 2;
> >     cost += this_cost;
> >   }
> > }
> > 
> > I would've initially suggested using something like N=2 since we're dealing
> > with averages and half should ensure we don't run over except for the worst
> > peaks. But we could easily use a bigger N.
> 
> I ran a few AIM7 workloads for the 8 socket HT enabled case and I needed
> to set N to more than 20 in order to get the big performance gains.
> 

As per your observation, newly idle balancing isn't picking tasks and
mostly finding the domains to be balanced. find_busiest_queue() is
under rcu. So where and how are we getting these performance gains?

Is it that tasks are getting woken up and queued while the cpu is doing
newly idle load balance? Or is it that the regular CPU_IDLE balancing
which follows idle_balance() does a more aggressive balancing and hence
is able to find a task to balance?


-- 
Thanks and Regards
Srikar Dronamraju

