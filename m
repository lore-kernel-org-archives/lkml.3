Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaANA6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:58:47 -0500
Received: from blackpearl.yuhu.biz ([85.14.7.126]:37768 "EHLO
	BlackPearl.yuhu.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbaANA6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:58:13 -0500
Message-ID: <52D48BA6.2080701@yuhu.biz>
Date: Tue, 14 Jan 2014 02:58:14 +0200
From: Marian Marinov <mm@yuhu.biz>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: lxc-devel@lists.linuxcontainers.org, cgroups@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Li Zefan <lizefan@huawei.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC: cgroups aware proc
References: <52D35CD0.9070602@huawei.com> <52D41316.5080508@yuhu.biz> <20140113171238.GS31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140113171238.GS31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 07:12 PM, Peter Zijlstra wrote:
> On Mon, Jan 13, 2014 at 06:23:50PM +0200, Marian Marinov wrote:
>> Hello Peter,
>>
>> I need help with the scheduler.
>>
>> I'm currently trying to patch the /proc/loadavg to show the load that is
>> only related to the processes from the current cgroup.
>>
>> I looked trough the code and I was hoping that tsk->sched_task_group->cfs_rq
>> struct will give me the needed information, but unfortunately for me, it did
>> not.
>>
>> Can you advise me, how to approach this problem?
>
> Yeah, don't :-) Really, loadavg is a stupid metric.

Yes... stupid, but unfortunately everyone is looking at it :(

>
>> I'm totally new to the scheduler code.
>
> Luckily you won't actually have to touch much of it. Most of the actual
> loadavg code lives in the first ~400 lines of kernel/sched/proc.c, read
> and weep. Its one of the best documented bits around.

I looked trough it but I don't understand how to introduce the per cgroup calculation.

I looked trough the headers and found the following, which is already implemented.

   task->sched_task_group->load_avg
   task->sched_task_group->cfs_rq->load_avg
   task->sched_task_group->cfs_rq->load.weight
   task->sched_task_group->cfs_rq->runnable_load_avg

Unfortunately there is almost no documentation for these elements of the cfs_rq and task_group structs.

It seams to me that part of the per task group loadavg code is already present.

>
> Your proposition however is extremely expensive, you turn something
> that's already expensive O(nr_cpus) into something O(nr_cpus *
> nr_cgroups).
>
> I'm fairly sure people will not like that, esp. for something of such
> questionable use as the loadavg -- its really only a pretty number that
> doesn't mean all that much.

I know that its use is questionable but in my case I need to have it, or I will not be able to offer correct loadavg 
values in the containers.


>
>> -------- Original Message --------
>> From: Li Zefan <lizefan@huawei.com>
>>
>> Then you should add Peter, Ingo and LKML to your Cc list. :)
>
> You failed that, let me fix that.
>
>

