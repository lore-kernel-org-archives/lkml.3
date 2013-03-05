Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3CEKhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:37:34 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:13394 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3CEKhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:37:31 -0500
Message-ID: <5135CAD8.2020409@huawei.com>
Date: Tue, 5 Mar 2013 18:37:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] perf: remove include of cgroup.h from perf_event.h
References: <513568A0.6020804@huawei.com> <CABPqkBTTn6E=FS6WiCWopcScHDVa9F6bu5-pw8Ma7TK2aunkvQ@mail.gmail.com>
In-Reply-To: <CABPqkBTTn6E=FS6WiCWopcScHDVa9F6bu5-pw8Ma7TK2aunkvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/5 16:33, Stephane Eranian wrote:
> On Tue, Mar 5, 2013 at 4:38 AM, Li Zefan <lizefan@huawei.com> wrote:
>> Move struct perf_cgroup_info and perf_cgroup to kernel/perf/core.c,
>> and then we can remove include of cgroup.h.
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
>> ---
>>  include/linux/perf_event.h | 18 +-----------------
>>  kernel/events/core.c       | 15 +++++++++++++++
>>  2 files changed, 16 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index e47ee46..8737e1c 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -21,7 +21,6 @@
>>   */
>>
>>  #ifdef CONFIG_PERF_EVENTS
>> -# include <linux/cgroup.h>
>>  # include <asm/perf_event.h>
>>  # include <asm/local64.h>
>>  #endif
>> @@ -299,22 +298,7 @@ struct swevent_hlist {
>>  #define PERF_ATTACH_GROUP      0x02
>>  #define PERF_ATTACH_TASK       0x04
>>
>> -#ifdef CONFIG_CGROUP_PERF
>> -/*
>> - * perf_cgroup_info keeps track of time_enabled for a cgroup.
>> - * This is a per-cpu dynamically allocated data structure.
>> - */
>> -struct perf_cgroup_info {
>> -       u64                             time;
>> -       u64                             timestamp;
>> -};
>> -
>> -struct perf_cgroup {
>> -       struct                          cgroup_subsys_state css;
>> -       struct                          perf_cgroup_info *info; /* timing info, one per cpu */
>> -};
>> -#endif
>> -
>> +struct perf_cgroup;
> 
> The problem is that you have struct perf_cgroup in the struct perf_event
> structure. Today, this field is not referenced outside of kernel/events/core.c
> But it is available outside this file. If someday the field is reference, your
> changes will have to do reverted. So I am wondering what is the point
> of the change right now?
> 

I touch cgroup.h quite frequently, so I'd like to reduce the compile time caused
by cgroup.h changes, so I've made a few patches to remove cgroup.h from some
header files.

It's better to expose as less interfaces as possible, and if someone wants to
export someting he should think about if it's the right thing to do.

Like we often make static functions usable to external users, and also often do the
reverse thing, this patch is nothing special.

