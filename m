Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3GAJn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:43:28 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:44438 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3GAJn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:43:27 -0400
Date: Mon, 1 Jul 2013 15:13:11 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Lei Wen <leiwen@marvell.com>
Cc: Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] sched: add trace events for task and rq usage
 tracking
Message-ID: <20130701094311.GA32363@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1372662634-12833-1-git-send-email-leiwen@marvell.com>
 <1372662634-12833-2-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1372662634-12833-2-git-send-email-leiwen@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070109-3864-0000-0000-000008E0C30D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lei Wen <leiwen@marvell.com> [2013-07-01 15:10:32]:

> Since we could track task in the entity level now, we may want to
> investigate tasks' running status by recording the trace info, so that
> could make some tuning if needed.
> 
> Signed-off-by: Lei Wen <leiwen@marvell.com>
> ---
>  include/trace/events/sched.h |   73 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/fair.c          |   29 +++++++++++++++--
>  2 files changed, 100 insertions(+), 2 deletions(-)

[...]

> 
> +TRACE_EVENT(sched_cfs_rq_runnable_load,
> +
> +	TP_PROTO(int cpu, unsigned long load, unsigned long total),
> +
> +	TP_ARGS(cpu, load, total),
> +
> +	TP_STRUCT__entry(
> +		__field(int, cpu)
> +		__field(unsigned long, load)
> +		__field(unsigned long, total)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu   = cpu;
> +		__entry->load  = load;
> +		__entry->total = total;
> +	),
> +
> +	TP_printk("cpu=%d avg=%lu total=%lu",
> +			__entry->cpu,
> +			__entry->load,
> +			__entry->total)
> +);
> +
> +TRACE_EVENT(sched_cfs_rq_blocked_load,
> +
> +	TP_PROTO(int cpu, unsigned long load, unsigned long total),
> +
> +	TP_ARGS(cpu, load, total),
> +
> +	TP_STRUCT__entry(
> +		__field(int, cpu)
> +		__field(unsigned long, load)
> +		__field(unsigned long, total)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu   = cpu;
> +		__entry->load  = load;
> +		__entry->total = total;
> +	),
> +
> +	TP_printk("cpu=%d avg=%lu total=%lu",
> +			__entry->cpu,
> +			__entry->load,
> +			__entry->total)
> +);
> +
>  #endif /* _TRACE_SCHED_H */

above trace points are same and be folded using EVENT_CLASS:

+DECLARE_EVENT_CLASS(sched_cfs_rq_load_contri_template,
+
+	TP_PROTO(int cpu, unsigned long load, unsigned long total),
+
+	TP_ARGS(cpu, load, total),
+
+	TP_STRUCT__entry(
+		__field(int, cpu)
+		__field(unsigned long, load)
+		__field(unsigned long, total)
+	),
+
+	TP_fast_assign(
+		__entry->cpu   = cpu;
+		__entry->load  = load;
+		__entry->total = total;
+	),
+
+	TP_printk("cpu=%d avg=%lu total=%lu",
+			__entry->cpu,
+			__entry->load,
+			__entry->total)
+);
+
+DEFINE_EVENT(sched_cfs_rq_load_contri_template, sched_cfs_rq_runnable_load,
+	TP_PROTO(int cpu, unsigned long load, unsigned long total),
+	TP_ARGS(cpu, load, total));
+
+DEFINE_EVENT(sched_cfs_rq_load_contri_template, sched_cfs_rq_blocked_load,
+	TP_PROTO(int cpu, unsigned long load, unsigned long total),
+	TP_ARGS(cpu, load, total));
+

