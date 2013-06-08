Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3FHCTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 22:19:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:56346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab3FHCTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 22:19:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,825,1363158000"; 
   d="scan'208";a="346652746"
Message-ID: <51B2948A.60309@intel.com>
Date: Sat, 08 Jun 2013 10:18:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
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
Subject: Re: [RFC patch 1/4] sched: change cfs_rq load avg to unsigned long
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com> <1370590169-24804-2-git-send-email-alex.shi@intel.com> <CAKfTPtA=pVQ69pfv97kgcdawgHbQbkbXW4sFGN6_bAzZcD9b9Q@mail.gmail.com>
In-Reply-To: <CAKfTPtA=pVQ69pfv97kgcdawgHbQbkbXW4sFGN6_bAzZcD9b9Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 05:07 PM, Vincent Guittot wrote:
> On 7 June 2013 09:29, Alex Shi <alex.shi@intel.com> wrote:
>> > Since the 'u64 runnable_load_avg, blocked_load_avg' in cfs_rq struct are
>> > smaller than 'unsigned long' cfs_rq->load.weight. We don't need u64
>> > vaiables to describe them. unsigned long is more efficient and convenience.
>> >
> Hi Alex,
> 
> I just want to point out that we can't have more than 48388 tasks with
> highest priority on a runqueue with an unsigned long on a 32 bits
> system.  I don't know if we can reach such kind of limit on a 32bits
> machine ? For sure, not on an embedded system.

Thanks question!
It should be a talked problem. I just remember the conclusion is when
you get the up bound task number, you already run out the memory space
on 32 bit.

Just for kernel resource for a process, it need 2 pages stack.
mm_struct, task_struct, task_stats, vm_area_struct, page table etc.
these are already beyond 4 pages. so 4 * 4k * 48388 = 774MB. plus user
level resources.

So, usually the limited task number in Linux is often far lower this
number: $ulimit -u.

Anyway, at least, the runnable_load_avg is smaller then load.weight. if
load.weight can use long type, runablle_load_avg is no reason can't.

-- 
Thanks
    Alex
