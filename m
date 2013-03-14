Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804Ab3CNPnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:43:23 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:45774 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933510Ab3CNPnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:43:20 -0400
MIME-Version: 1.0
In-Reply-To: <1363262445.25967.30.camel@gandalf.local.home>
References: <1363254519.26965.9.camel@laptop> <1363262445.25967.30.camel@gandalf.local.home>
From: Paul Turner <pjt@google.com>
Date: Thu, 14 Mar 2013 08:42:43 -0700
Message-ID: <CAPM31RK-fSJj9o2PhgJ05wHBSStbf6hx4F8Nv=inB90x4Sx=VQ@mail.gmail.com>
Subject: Re: [PATCH] sched,trace: Allow tracing the preemption decision on wakeup
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        tglx <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah -- this one is a real no brainer to move; looks good :)

On Thu, Mar 14, 2013 at 5:00 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2013-03-14 at 10:48 +0100, Peter Zijlstra wrote:
>> Thomas noted that we do the wakeup preemption check after the wakeup
>> trace point, this means the tracepoint cannot test/report this decision;
>> which is rather important for latency sensitive workloads. Therefore
>> move the tracepoint after doing the preemption check.
>>
>> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
>> ---
>>  kernel/sched/core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index b36635e..849deb9 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1288,8 +1288,8 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
>>  static void
>>  ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>>  {
>> -     trace_sched_wakeup(p, true);
>>       check_preempt_curr(rq, p, wake_flags);
>> +     trace_sched_wakeup(p, true);
>>
>>       p->state = TASK_RUNNING;
>>  #ifdef CONFIG_SMP
>>
>
>
