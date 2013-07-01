Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3GAMTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:19:03 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:39480 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3GAMTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:19:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130701094311.GA32363@linux.vnet.ibm.com>
References: <1372662634-12833-1-git-send-email-leiwen@marvell.com>
	<1372662634-12833-2-git-send-email-leiwen@marvell.com>
	<20130701094311.GA32363@linux.vnet.ibm.com>
Date: Mon, 1 Jul 2013 20:18:59 +0800
Message-ID: <CALZhoSSoZHTM_NE=7EB7bGY83=D4dgZyYNX1WRd+Lafsdn11TA@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: add trace events for task and rq usage tracking
From: Lei Wen <adrian.wenl@gmail.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Lei Wen <leiwen@marvell.com>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamalesh,

On Mon, Jul 1, 2013 at 5:43 PM, Kamalesh Babulal
<kamalesh@linux.vnet.ibm.com> wrote:
> * Lei Wen <leiwen@marvell.com> [2013-07-01 15:10:32]:
>
>> Since we could track task in the entity level now, we may want to
>> investigate tasks' running status by recording the trace info, so that
>> could make some tuning if needed.
>>
>> Signed-off-by: Lei Wen <leiwen@marvell.com>
>> ---
>>  include/trace/events/sched.h |   73 ++++++++++++++++++++++++++++++++++++++++++
>>  kernel/sched/fair.c          |   29 +++++++++++++++--
>>  2 files changed, 100 insertions(+), 2 deletions(-)
>
> [...]
>
>>
>> +TRACE_EVENT(sched_cfs_rq_runnable_load,
>> +
>> +     TP_PROTO(int cpu, unsigned long load, unsigned long total),
>> +
>> +     TP_ARGS(cpu, load, total),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(int, cpu)
>> +             __field(unsigned long, load)
>> +             __field(unsigned long, total)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu   = cpu;
>> +             __entry->load  = load;
>> +             __entry->total = total;
>> +     ),
>> +
>> +     TP_printk("cpu=%d avg=%lu total=%lu",
>> +                     __entry->cpu,
>> +                     __entry->load,
>> +                     __entry->total)
>> +);
>> +
>> +TRACE_EVENT(sched_cfs_rq_blocked_load,
>> +
>> +     TP_PROTO(int cpu, unsigned long load, unsigned long total),
>> +
>> +     TP_ARGS(cpu, load, total),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(int, cpu)
>> +             __field(unsigned long, load)
>> +             __field(unsigned long, total)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu   = cpu;
>> +             __entry->load  = load;
>> +             __entry->total = total;
>> +     ),
>> +
>> +     TP_printk("cpu=%d avg=%lu total=%lu",
>> +                     __entry->cpu,
>> +                     __entry->load,
>> +                     __entry->total)
>> +);
>> +
>>  #endif /* _TRACE_SCHED_H */
>
> above trace points are same and be folded using EVENT_CLASS:

Nice abstract. I would merge your change for my V2 patch.

Thanks,
Lei

>
> +DECLARE_EVENT_CLASS(sched_cfs_rq_load_contri_template,
> +
> +       TP_PROTO(int cpu, unsigned long load, unsigned long total),
> +
> +       TP_ARGS(cpu, load, total),
> +
> +       TP_STRUCT__entry(
> +               __field(int, cpu)
> +               __field(unsigned long, load)
> +               __field(unsigned long, total)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->cpu   = cpu;
> +               __entry->load  = load;
> +               __entry->total = total;
> +       ),
> +
> +       TP_printk("cpu=%d avg=%lu total=%lu",
> +                       __entry->cpu,
> +                       __entry->load,
> +                       __entry->total)
> +);
> +
> +DEFINE_EVENT(sched_cfs_rq_load_contri_template, sched_cfs_rq_runnable_load,
> +       TP_PROTO(int cpu, unsigned long load, unsigned long total),
> +       TP_ARGS(cpu, load, total));
> +
> +DEFINE_EVENT(sched_cfs_rq_load_contri_template, sched_cfs_rq_blocked_load,
> +       TP_PROTO(int cpu, unsigned long load, unsigned long total),
> +       TP_ARGS(cpu, load, total));
> +
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
