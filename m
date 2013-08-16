Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3HPQ50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:57:26 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:56305 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3HPQ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130815123422.GT24092@twins.programming.kicks-ass.net>
References: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1375778203-31343-3-git-send-email-iamjoonsoo.kim@lge.com>
	<20130815123422.GT24092@twins.programming.kicks-ass.net>
Date: Sat, 17 Aug 2013 01:57:20 +0900
Message-ID: <CAAmzW4N21Y3hKNKJjXpqLajMwAuKM_FqstsJDEm-6heXM_myMw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] sched: factor out code to should_we_balance()
From: JoonSoo Kim <js1304@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static int should_we_balance(struct lb_env *env)
>> +{
>> +     struct sched_group *sg = env->sd->groups;
>> +     struct cpumask *sg_cpus, *sg_mask;
>> +     int cpu, balance_cpu = -1;
>> +
>> +     /*
>> +      * In the newly idle case, we will allow all the cpu's
>> +      * to do the newly idle load balance.
>> +      */
>> +     if (env->idle == CPU_NEWLY_IDLE)
>> +             return 1;
>> +
>> +     sg_cpus = sched_group_cpus(sg);
>> +     sg_mask = sched_group_mask(sg);
>> +     /* Try to find first idle cpu */
>> +     for_each_cpu_and(cpu, sg_cpus, env->cpus) {
>> +             if (!cpumask_test_cpu(cpu, sg_mask) || idle_cpu(cpu))
>
> Did you want to write !idle_cpu() ?
>

You are right. I made a mistake when I wrote v2 for style change.

Thanks for spotting this.
