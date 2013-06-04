Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064Ab3FDHXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:23:38 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:59814 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759368Ab3FDHXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:23:35 -0400
Message-ID: <51AD95D6.1060907@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 15:23:02 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/3] sched: don't repeat the initialization in sched_init()
References: <51AD87A8.6080608@linux.vnet.ibm.com> <51AD87D0.7020300@linux.vnet.ibm.com> <CAPM31RJfWWJuMg-2Byb7uGFQPQY1v+8OWVpwO2Ggz_mtTYpjVQ@mail.gmail.com>
In-Reply-To: <CAPM31RJfWWJuMg-2Byb7uGFQPQY1v+8OWVpwO2Ggz_mtTYpjVQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060407-2000-0000-0000-00000C5DC83C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul

On 06/04/2013 02:52 PM, Paul Turner wrote:
> On Mon, Jun 3, 2013 at 11:23 PM, Michael Wang

[snip]

> 
> This comment has become unglued from what it's supposed to be attached
> to (it's tied to root_task_group.shares & init_tg_cfs_entry, not
> init_cfs_bandwidth).

Thanks for your review and notify :)

What about put the comment with init_tg_cfs_entry()?

'root_task_group.shares' may not needed to be covered under the comment,
after all, it won't have any peers to flaunt it's share...

Regards,
Michael Wang

> 
>> +       init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
>> +#endif
>> +
>>         for_each_possible_cpu(i) {
>>                 struct rq *rq;
>>
>> @@ -6966,28 +6991,7 @@ void __init sched_init(void)
>>                 init_cfs_rq(&rq->cfs);
>>                 init_rt_rq(&rq->rt, rq);
>>  #ifdef CONFIG_FAIR_GROUP_SCHED
>> -               root_task_group.shares = ROOT_TASK_GROUP_LOAD;
>>                 INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
>> -               /*
>> -                * How much cpu bandwidth does root_task_group get?
>> -                *
>> -                * In case of task-groups formed thr' the cgroup filesystem, it
>> -                * gets 100% of the cpu resources in the system. This overall
>> -                * system cpu resource is divided among the tasks of
>> -                * root_task_group and its child task-groups in a fair manner,
>> -                * based on each entity's (task or task-group's) weight
>> -                * (se->load.weight).
>> -                *
>> -                * In other words, if root_task_group has 10 tasks of weight
>> -                * 1024) and two child groups A0 and A1 (of weight 1024 each),
>> -                * then A0's share of the cpu resource is:
>> -                *
>> -                *      A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = 8.33%
>> -                *
>> -                * We achieve this by letting root_task_group's tasks sit
>> -                * directly in rq->cfs (i.e root_task_group->se[] = NULL).
>> -                */
>> -               init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
>>                 init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
>>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>>
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 

