Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab3BEK1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:27:12 -0500
Received: from forward3h.mail.yandex.net ([84.201.187.148]:44436 "EHLO
	forward3h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3BEK1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:27:10 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Honghui Zhang <zhanghonghui@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re:[PATCH] sched/rt: Decrease number of calls of push_rt_task() in push_rt_tasks()
MIME-Version: 1.0
Message-Id: <798741360060024@web12h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 05 Feb 2013 14:27:04 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 2013/2/5 15:22, Kirill Tkhai wrote:
> 
>>> Suppose we have a large number of cpus(say 4096), with the last one running
>>> a low-priority task on it. Is it possible with this patch we will never reach
>>> the last cpu in case that previous cpu has complete the pulled task?
>>
>> Yes. But this patch is about several pushable tasks on the same cpu.
>>
>> Kirill
> 
> Maybe I haven't make myself understood, but in that case, there will be a higher-priority
> task in the runqueue of the pushing cpu, and a lower-priority task running in the last cpu
> which could not be preempt by push_rt_task(), I don't think it's acceptable.

Sure, I tried to prevent the fact of call of this function with locks of spinlocks etc. It may
be useful on system like 2 CPU, but it's not necessary for large systems. I'm not persist in this.

Kirill

> 
> Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html


 -- 
