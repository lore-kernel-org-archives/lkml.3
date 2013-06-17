Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab3FQJyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:54:23 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:48072 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3FQJyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <51B2948A.60309@intel.com>
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com>
	<1370590169-24804-2-git-send-email-alex.shi@intel.com>
	<CAKfTPtA=pVQ69pfv97kgcdawgHbQbkbXW4sFGN6_bAzZcD9b9Q@mail.gmail.com>
	<51B2948A.60309@intel.com>
Date: Mon, 17 Jun 2013 11:54:21 +0200
Message-ID: <CAKfTPtBuMsQtHds0sWvgfpV1nkr76_mOn83jZDk9216vX3F+Ow@mail.gmail.com>
Subject: Re: [RFC patch 1/4] sched: change cfs_rq load avg to unsigned long
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 June 2013 04:18, Alex Shi <alex.shi@intel.com> wrote:
> On 06/07/2013 05:07 PM, Vincent Guittot wrote:
>> On 7 June 2013 09:29, Alex Shi <alex.shi@intel.com> wrote:
>>> > Since the 'u64 runnable_load_avg, blocked_load_avg' in cfs_rq struct are
>>> > smaller than 'unsigned long' cfs_rq->load.weight. We don't need u64
>>> > vaiables to describe them. unsigned long is more efficient and convenience.
>>> >
>> Hi Alex,
>>
>> I just want to point out that we can't have more than 48388 tasks with
>> highest priority on a runqueue with an unsigned long on a 32 bits
>> system.  I don't know if we can reach such kind of limit on a 32bits
>> machine ? For sure, not on an embedded system.
>
> Thanks question!
> It should be a talked problem. I just remember the conclusion is when
> you get the up bound task number, you already run out the memory space
> on 32 bit.
>
> Just for kernel resource for a process, it need 2 pages stack.
> mm_struct, task_struct, task_stats, vm_area_struct, page table etc.
> these are already beyond 4 pages. so 4 * 4k * 48388 = 774MB. plus user
> level resources.
>
> So, usually the limited task number in Linux is often far lower this
> number: $ulimit -u.
>
> Anyway, at least, the runnable_load_avg is smaller then load.weight. if
> load.weight can use long type, runablle_load_avg is no reason can't.

Alex,

You can add my tested-by for this patchset.

Regards,
Vincent

>
> --
> Thanks
>     Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
