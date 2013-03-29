Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3C2L6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:58:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43627 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3C2L6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:58:39 -0400
Message-ID: <1364558306.5053.87.camel@laptop>
Subject: Re: [PATCH 2/5] sched: factor out code to should_we_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Fri, 29 Mar 2013 12:58:26 +0100
In-Reply-To: <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 16:58 +0900, Joonsoo Kim wrote:
> +static int should_we_balance(struct lb_env *env)
> +{
> +       struct sched_group *sg = env->sd->groups;
> +       int cpu, balance_cpu = -1;
> +
> +       /*
> +        * In the newly idle case, we will allow all the cpu's
> +        * to do the newly idle load balance.
> +        */
> +       if (env->idle == CPU_NEWLY_IDLE)
> +               return 1;
> +
> +       /* Try to find first idle cpu */
> +       for_each_cpu_and(cpu, sched_group_cpus(sg), env->cpus)
> +               if (cpumask_test_cpu(cpu, sched_group_mask(sg)) &&
> +                       idle_cpu(cpu)) {
> +                               balance_cpu = cpu;
> +                               break;
> +                       }

/me hands you a bucket of curlies too.. use them I'll send you another
bucket when this one gets empty!

(We always put in curlies on multi lines statements -- as opposed to
multi statement blocks where they're required)

> +
> +       if (balance_cpu == -1)
> +               balance_cpu = group_balance_cpu(sg);
> +
> +       /*
> +        * First idle cpu or the first cpu(busiest) in this sched
> group
> +        * is eligible for doing load balancing at this and above
> domains.
> +        */
> +       if (balance_cpu != env->dst_cpu)
> +               return 0;
> +
> +       return 1;
> +}


