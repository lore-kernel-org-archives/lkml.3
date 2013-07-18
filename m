Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab3GRTDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:03:53 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:21758 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079Ab3GRTDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:03:52 -0400
Message-ID: <1374174227.1792.39.camel@j-VirtualBox>
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too
 frequently
From: Jason Low <jason.low2@hp.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
Date: Thu, 18 Jul 2013 12:03:47 -0700
In-Reply-To: <20130718121245.GA3745@linux.vnet.ibm.com>
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
	 <20130718121245.GA3745@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 17:42 +0530, Srikar Dronamraju wrote:
> > > 
> > > idle_balance(u64 idle_duration)
> > > {
> > >   u64 cost = 0;
> > > 
> > >   for_each_domain(sd) {
> > >     if (cost + sd->cost > idle_duration/N)
> > >       break;
> > > 
> > >     ...
> > > 
> > >     sd->cost = (sd->cost + this_cost) / 2;
> > >     cost += this_cost;
> > >   }
> > > }
> > > 
> > > I would've initially suggested using something like N=2 since we're dealing
> > > with averages and half should ensure we don't run over except for the worst
> > > peaks. But we could easily use a bigger N.
> > 
> > I ran a few AIM7 workloads for the 8 socket HT enabled case and I needed
> > to set N to more than 20 in order to get the big performance gains.
> > 
> 
> As per your observation, newly idle balancing isn't picking tasks and
> mostly finding the domains to be balanced. find_busiest_queue() is
> under rcu. So where and how are we getting these performance gains?

I actually just ran fserver on 8 sockets (which idle balance lowers the
performance in this workload at this socket count), and for this
workload, idle balancing is finding tasks to move fairly often on a
per-cpu basis. So I guess it is not always the case that idle balancing
isn't moving tasks on this box.

Jason

