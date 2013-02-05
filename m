Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab3BEHWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:22:31 -0500
Received: from forward17.mail.yandex.net ([95.108.253.142]:42240 "EHLO
	forward17.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3BEHW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:22:29 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Honghui Zhang <zhanghonghui@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re:[PATCH] sched/rt: Decrease number of calls of push_rt_task() in push_rt_tasks()
MIME-Version: 1.0
Message-Id: <500221360048944@web26g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 05 Feb 2013 11:22:24 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 2013/2/1 5:57, Kirill Tkhai wrote:
> 
>> 31.01.2013, 20:08, "Steven Rostedt" <rostedt@goodmis.org>:
>>
>>> On Mon, 2013-01-28 at 03:46 +0400, Kirill Tkhai wrote:
>>>
>>>> The patch aims to decrease the number of calls of push_rt_task()
>>>> in push_rt_tasks().
>>>>
>>>> It's not necessary to push more than 'num_online_cpus() - 1' tasks.
>>>> If just pushed task doesn't leave its new CPU during our local call
>>>> of push_rt_tasks() than we won't push another task to the CPU.
>>>> If it leave or change priority than it will pull new task by itself.
>>>
>>> I'm curious. Have you hit situations where this was an issue? Or was
>>> this just discovered by code review?
>>
>> No, I did't hit this situation. It's impossible to hook every situation.
>>
>> Thanks for your explanation.
>>
>> Kirill
> 
> Suppose we have a large number of cpus(say 4096), with the last one running
> a low-priority task on it. Is it possible with this patch we will never reach
> the last cpu in case that previous cpu has complete the pulled task?

Yes. But this patch is about several pushable tasks on the same cpu.

Kirill

 -- 
