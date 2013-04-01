Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab3DAFQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:16:21 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60767 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab3DAFQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:16:20 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-a6-51591821a611
Date: Mon, 1 Apr 2013 14:16:28 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/5] sched: factor out code to should_we_balance()
Message-ID: <20130401051628.GD12015@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
 <1364558306.5053.87.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364558306.5053.87.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 12:58:26PM +0100, Peter Zijlstra wrote:
> On Thu, 2013-03-28 at 16:58 +0900, Joonsoo Kim wrote:
> > +static int should_we_balance(struct lb_env *env)
> > +{
> > +       struct sched_group *sg = env->sd->groups;
> > +       int cpu, balance_cpu = -1;
> > +
> > +       /*
> > +        * In the newly idle case, we will allow all the cpu's
> > +        * to do the newly idle load balance.
> > +        */
> > +       if (env->idle == CPU_NEWLY_IDLE)
> > +               return 1;
> > +
> > +       /* Try to find first idle cpu */
> > +       for_each_cpu_and(cpu, sched_group_cpus(sg), env->cpus)
> > +               if (cpumask_test_cpu(cpu, sched_group_mask(sg)) &&
> > +                       idle_cpu(cpu)) {
> > +                               balance_cpu = cpu;
> > +                               break;
> > +                       }
> 
> /me hands you a bucket of curlies too.. use them I'll send you another
> bucket when this one gets empty!

Thanks!

> (We always put in curlies on multi lines statements -- as opposed to
> multi statement blocks where they're required)

Okay. I will do that when respin.

Thanks.

> 
> > +
> > +       if (balance_cpu == -1)
> > +               balance_cpu = group_balance_cpu(sg);
> > +
> > +       /*
> > +        * First idle cpu or the first cpu(busiest) in this sched
> > group
> > +        * is eligible for doing load balancing at this and above
> > domains.
> > +        */
> > +       if (balance_cpu != env->dst_cpu)
> > +               return 0;
> > +
> > +       return 1;
> > +}
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
