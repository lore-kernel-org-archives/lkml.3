Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab3ING5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 02:57:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:27336 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3ING53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 02:57:29 -0400
Message-ID: <523408C8.3040606@huawei.com>
Date: Sat, 14 Sep 2013 14:57:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hung_task: change sysctl_hung_task_check_count to int
References: <5233CE5E.7040004@huawei.com> <5233CFBF.4000803@huawei.com> <20130914055359.GB364@gmail.com>
In-Reply-To: <20130914055359.GB364@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On 2013/9/14 10:47, Li Zefan wrote:
>>> As sysctl_hung_task_check_count is unsigned long, when this value is
>>> assigned to max_count in check_hung_uninterruptible_tasks(), it's
>>> truncated to int type.
>>>
>>> Therefore if we write 2^32 to sysctl.hung_task_check_count, hung task
>>> detection will be effectively disabled.
>>>
>>> Not a big deal, but still it's better to fix this inconsistency.
>>>
>>> Signed-off-by: Li Zefan <lizefan@huawei.com>
>>> ---
>>>  include/linux/sched/sysctl.h | 2 +-
>>>  kernel/hung_task.c           | 2 +-
>>>  kernel/sysctl.c              | 4 ++--
>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
>>> index bf8086b..9552afa 100644
>>> --- a/include/linux/sched/sysctl.h
>>> +++ b/include/linux/sched/sysctl.h
>>> @@ -2,8 +2,8 @@
>>>  #define _SCHED_SYSCTL_H
>>>  
>>>  #ifdef CONFIG_DETECT_HUNG_TASK
>>> +extern int	     sysctl_hung_task_check_count;
>>>  extern unsigned int  sysctl_hung_task_panic;
>>> -extern unsigned long sysctl_hung_task_check_count;
>>>  extern unsigned long sysctl_hung_task_timeout_secs; extern unsigned 
>>>  long sysctl_hung_task_warnings; extern int 
>>>  proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
> 
> Looks good, but I suppose most of the unsigned longs above ought to be 
> downgraded to int as well?
> 

They can be, but they don't have to be.

> Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks!

