Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3AaWFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:05:07 -0500
Received: from forward2h.mail.yandex.net ([84.201.187.147]:60804 "EHLO
	forward2h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab3AaWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:05:04 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2013 17:05:04 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1359648490.17639.107.camel@gandalf.local.home>
References: <2016751359330408@web20f.yandex.ru> <1359648490.17639.107.camel@gandalf.local.home>
Subject: Re: [PATCH] sched/rt: Decrease number of calls of push_rt_task() in push_rt_tasks()
MIME-Version: 1.0
Message-Id: <313901359669474@web15h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 01 Feb 2013 01:57:54 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



31.01.2013, 20:08, "Steven Rostedt" <rostedt@goodmis.org>:
> On Mon, 2013-01-28 at 03:46 +0400, Kirill Tkhai wrote:
>
>> šThe patch aims to decrease the number of calls of push_rt_task()
>> šin push_rt_tasks().
>>
>> šIt's not necessary to push more than 'num_online_cpus() - 1' tasks.
>> šIf just pushed task doesn't leave its new CPU during our local call
>> šof push_rt_tasks() than we won't push another task to the CPU.
>> šIf it leave or change priority than it will pull new task by itself.
>
> I'm curious. Have you hit situations where this was an issue? Or was
> this just discovered by code review?

No, I did't hit this situation. It's impossible to hook every situation.

Thanks for your explanation.

Kirill

>
> -- Steve
>
>> šSigned-off-by: Kirill V Tkhai <tkhai@yandex.ru>
>> šCC: Steven Rostedt <rostedt@goodmis.org>
>> šCC: Ingo Molnar <mingo@kernel.org>
>> šCC: Peter Zijlstra <peterz@infradead.org>
>> šCC: linux-rt-users <linux-rt-users@vger.kernel.org>
>> š---
>> šškernel/sched/rt.c | ššš4 +++-
>> šš1 file changed, 3 insertions(+), 1 deletion(-)
>> šdiff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
>> šindex 4e8f0f4..edf046d 100644
>> š--- a/kernel/sched/rt.c
>> š+++ b/kernel/sched/rt.c
>> š@@ -1703,8 +1703,10 @@ out:
>>
>> ššstatic void push_rt_tasks(struct rq *rq)
>> šš{
>> š+ int num_cpus = num_online_cpus() - 1;
>> š+
>> šššššššššš/* push_rt_task will return true if it moved an RT */
>> š- while (push_rt_task(rq))
>> š+ while (push_rt_task(rq) && --num_cpus > 0)
>> šššššššššššššššššš;
>> šš}
