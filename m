Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3FXKlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:41:20 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:61769 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3FXKlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:41:19 -0400
MIME-Version: 1.0
In-Reply-To: <51C7B9B8.6090309@intel.com>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com> <51C7B9B8.6090309@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 24 Jun 2013 03:40:47 -0700
Message-ID: <CAPM31RKq4sVR2_mU8PWx8dK+STQDj3Geyi8dVg3MnL=ymjfV6Q@mail.gmail.com>
Subject: Re: [Resend patch v8 0/13] use runnable load in schedule balance
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz,
        Clark Williams <clark.williams@gmail.com>, tony.luck@intel.com,
        keescook@chromium.org, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 8:15 PM, Alex Shi <alex.shi@intel.com> wrote:
> On 06/20/2013 10:18 AM, Alex Shi wrote:
>> Resend patchset for more convenient pick up.
>> This patch set combine 'use runnable load in balance' serials and 'change
>> 64bit variables to long type' serials. also collected Reviewed-bys, and
>> Tested-bys.
>>
>> The only changed code is fixing load to load_avg convert in UP mode, which
>> found by PeterZ in task_h_load().
>>
>> Paul still has some concern of blocked_load_avg out of balance consideration.
>> but I didn't see the blocked_load_avg usage was thought through now, or some
>> strong reason to make it into balance.
>> So, according to benchmarks testing result I keep patches unchanged.
>
> Ingo & Peter,
>
> This patchset was discussed spread and deeply.
>
> Now just 6th/8th patch has some arguments on them, Paul think it is
> better to consider blocked_load_avg in balance, since it is helpful on
> some scenarios, but I think on most of scenarios, the blocked_load_avg
> just cause load imbalance among cpus. and plus testing show with
> blocked_load_avg the performance is just worse on some benchmarks. So, I
> still prefer to keep it out of balance.

I think you have perhaps misunderstood what I was trying to explain.

I have no problems with not including blocked load in load-balance, in
fact, I encouraged not accumulating it in an average of averages in
CPU load.

The problem is that your current approach has removed it both from
load-balance _and_ from shares distribution; isolation matters as much
as performance in the cgroup case (otherwise you would just not use
cgroups).  I would expect the latter to have quite negative effects on
fairness, this is my primary concern.

>
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg455196.html
>
> Is it the time to do the decision or give more comments? Thanks!
>>
>> Regards
>> Alex
>>
>> [Resend patch v8 01/13] Revert "sched: Introduce temporary
>> [Resend patch v8 02/13] sched: move few runnable tg variables into
>> [Resend patch v8 03/13] sched: set initial value of runnable avg for
>> [Resend patch v8 04/13] sched: fix slept time double counting in
>> [Resend patch v8 05/13] sched: update cpu load after task_tick.
>> [Resend patch v8 06/13] sched: compute runnable load avg in cpu_load
>> [Resend patch v8 07/13] sched: consider runnable load average in
>> [Resend patch v8 08/13] sched/tg: remove blocked_load_avg in balance
>> [Resend patch v8 09/13] sched: change cfs_rq load avg to unsigned
>> [Resend patch v8 10/13] sched/tg: use 'unsigned long' for load
>> [Resend patch v8 11/13] sched/cfs_rq: change atomic64_t removed_load
>> [Resend patch v8 12/13] sched/tg: remove tg.load_weight
>> [Resend patch v8 13/13] sched: get_rq_runnable_load() can be static
>>
>
>
> --
> Thanks
>     Alex
