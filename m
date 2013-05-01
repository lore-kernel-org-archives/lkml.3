Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3EASmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:42:38 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:32920 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3EASmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:42:32 -0400
Message-ID: <51816214.1060308@gmail.com>
Date: Wed, 01 May 2013 14:42:28 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 09/10] sched: task_sched_runtime introduce micro optimization
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com> <1367291838-5490-10-git-send-email-kosaki.motohiro@gmail.com> <20130501110047.GD28253@dyad.programming.kicks-ass.net>
In-Reply-To: <20130501110047.GD28253@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/1/13 7:00 AM), Peter Zijlstra wrote:
> On Mon, Apr 29, 2013 at 11:17:17PM -0400, kosaki.motohiro@gmail.com wrote:
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> rq lock in task_sched_runtime() is necessary for two reasons. 1)
>> accessing se.sum_exec_runtime is inatomic on 32bit and 2)
>> do_task_delta_exec() require it.
>>
>> And then, 64bit can avoid holds rq lock when add_delta is false.
>>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> ---
>>  kernel/sched/core.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index b817e6d..24ba1c6 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2657,6 +2657,12 @@ unsigned long long task_sched_runtime(struct task_struct *p, bool add_delta)
>>  	struct rq *rq;
>>  	u64 ns = 0;
>>  
>> +	/* Micro optimization. */
> 
> Instead of the above; how about something like:
> 
>   /* 64-bit doesn't need locks to atomically read a 64bit value */

Looks nicer. Indeed.



