Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3CFLUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:20:46 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:46864 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab3CFLUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:20:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130306103120.GA16827@gmail.com>
References: <513568A0.6020804@huawei.com>
	<CABPqkBTTn6E=FS6WiCWopcScHDVa9F6bu5-pw8Ma7TK2aunkvQ@mail.gmail.com>
	<20130306103120.GA16827@gmail.com>
Date: Wed, 6 Mar 2013 12:20:41 +0100
Message-ID: <CABPqkBS7ceR1jvYq2rHMj0r7MU3yanQqdLN70FibZv+0SA-fBA@mail.gmail.com>
Subject: Re: [PATCH] perf: remove include of cgroup.h from perf_event.h
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 11:31 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> > - * This is a per-cpu dynamically allocated data structure.
>> > - */
>> > -struct perf_cgroup_info {
>> > -       u64                             time;
>> > -       u64                             timestamp;
>> > -};
>> > -
>> > -struct perf_cgroup {
>> > -       struct                          cgroup_subsys_state css;
>> > -       struct                          perf_cgroup_info *info; /* timing info, one per cpu */
>> > -};
>> > -#endif
>> > -
>> > +struct perf_cgroup;
>>
>> The problem is that you have struct perf_cgroup in the struct perf_event
>> structure. Today, this field is not referenced outside of kernel/events/core.c But
>> it is available outside this file. If someday the field is reference, your changes
>> will have to do reverted. So I am wondering what is the point of the change right
>> now?
>
> It's standard practice to not define the type for task_struct or other kernel
> subsystems.
>
> For example slab caches can be created via kmem_cache_create() anywhere in the tree,
> but the internal structure is only known to the SLAB subsystem.
>
I am fine with the change.
