Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaKQQyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 11:54:07 -0500
Received: from forward20.mail.yandex.net ([95.108.253.145]:44643 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaKQQyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 11:54:04 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@arm.com>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <ktkhai@parallels.com>
Subject: Re:[PATCH v5] sched/deadline: support dl task migration during cpu hotplug
MIME-Version: 1.0
Message-Id: <391401416243011@web3h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 17 Nov 2014 19:50:11 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Hi Kirill,
> On Thu, Nov 13, 2014 at 01:21:31PM +0300, Kirill Tkhai wrote:
> 
>>>>>>> @@ -1185,8 +1223,9 @@ static int find_later_rq(struct task_struct *task)
>>>>>>> * We have to consider system topology and task affinity
>>>>>>> * first, then we can look for a suitable cpu.
>>>>>>> */
>>>>>>> - cpumask_copy(later_mask, task_rq(task)->rd->span);
>>>>>>> - cpumask_and(later_mask, later_mask, cpu_active_mask);
>>>>>>> + cpumask_copy(later_mask, cpu_active_mask);
>>>>>>> + if (likely(task_rq(task)->online))
>>>>>>> + cpumask_and(later_mask, later_mask, task_rq(task)->rd->span);
>>>>>>> cpumask_and(later_mask, later_mask, &task->cpus_allowed);
>>>>>>> best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
>>>>>>> task, later_mask);
>>>>
>>>> Also, we should think about the following situation.
>>>>
>>>> DL task is left on dead rq. In your scheme it will be moved by the timer.
>>>> But what will be if somebody changes the class of the task (before timer)?
>>>
>>> I think timer will be cancelled in switched_from_dl().
>>
>> Yeah, but nobody will move this task to alive rq.
>>
>>> Regards,
>>> Wanpeng Li
>>>
>>>> In this case the task still remains on dead rq.
>>>>
>>>> We should handle this situation in some way.
> 
> Your proposal is a great appreciated.

Sadly, I‘m travelling at the moment, I‘m not able to do something till december.

> Regards,
> Wanpeng Li
> 
>>>> Kirill
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at http://www.tux.org/lkml/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
