Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3AYBit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:38:49 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:9078 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3AYBin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:38:43 -0500
Message-ID: <5101E211.20606@huawei.com>
Date: Fri, 25 Jan 2013 09:38:25 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] sched: split out css_online/css_offline from tg
 creation/destruction
References: <5100D4FE.9080205@huawei.com> <5100D518.8000103@huawei.com> <20130124100434.GD26351@gmail.com>
In-Reply-To: <20130124100434.GD26351@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/24 18:04, Ingo Molnar wrote:
> 
> * Li Zefan <lizefan@huawei.com> wrote:
> 
>>  extern struct task_group *sched_create_group(struct task_group *parent);
>> +extern void sched_online_group(struct task_group *tg,
>> +			       struct task_group *parent);
>>  extern void sched_destroy_group(struct task_group *tg);
>> +extern void sched_offline_group(struct task_group *tg);
> 
> Btw., a rename of these APIs might be in order, along the usual 
> patterns:
> 
>   sched_task_group_create()
>   sched_task_group_online()
>   sched_task_group_offline()
>   sched_task_group_destroy()
> 
>   etc.
> 
> that way the naming is more hierarchical and there's no clash 
> with the sched_group concept which is about something else.
> 
> (In a separate patch.)
> 

Agreed. I'll send a cleanup patch to you when those patches hit mainline.
(That will be 3.9-rc1 or later)

