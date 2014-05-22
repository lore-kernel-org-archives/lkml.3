Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaEVFfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:35:54 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:44431 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaEVFfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:35:53 -0400
Date: Thu, 22 May 2014 11:05:40 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: spinlock recursion in migrate_swap_stop
Message-ID: <20140522053540.GA26857@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <5371122D.6020605@oracle.com>
 <537AB86B.4020901@oracle.com>
 <20140520110431.GX2485@laptop.programming.kicks-ass.net>
 <537B52BD.1080807@oracle.com>
 <537CA54A.8030408@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <537CA54A.8030408@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052205-6102-0000-0000-000005A14791
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 927fa33..b5e11c7 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1154,6 +1156,7 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p)
>                 goto out;
>
>         trace_sched_swap_numa(cur, arg.src_cpu, p, arg.dst_cpu);
> +       BUG_ON(cur == p);

I am not sure how this check can ever be successful because at the start
of this function migrate_swap() we have

  if (arg.src_cpu == arg.dst_cpu)
	  goto out;


if cur is actually p; then should the above condition should always be
successul right?

Or am I missing something?

>         ret = stop_two_cpus(arg.dst_cpu, arg.src_cpu, migrate_swap_stop, &arg);
>
>  out:
>
>
> Which seems to get hit. This sounds like a race with task moving to
> other cpu maybe?
>

--
Thanks and Regards
Srikar Dronamraju

