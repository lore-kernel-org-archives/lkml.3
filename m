Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaBERT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:19:29 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:46320 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaBERT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:19:27 -0500
MIME-Version: 1.0
In-Reply-To: <1388728091-18564-7-git-send-email-zheng.z.yan@intel.com>
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
	<1388728091-18564-7-git-send-email-zheng.z.yan@intel.com>
Date: Wed, 5 Feb 2014 18:19:27 +0100
Message-ID: <CABPqkBQS=kSyRb0hb7DSTAOmUpB03_Cq70Wi1NvHj+DAQc4FVQ@mail.gmail.com>
Subject: Re: [PATCH 06/14] perf, core: always switch pmu specific data during
 context switch
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 6:48 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> If two tasks were both forked from the same parent task, Events in their perf
> task contexts can be the same. Perf core optimizes context switch oout in this
> case.
>
> Previous patch inroduces pmu specific data. The data is task specific, so we
> should switch the data even when context switch is optimized out.
>
Reviwed-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  kernel/events/core.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index b6650ab..d6d8dea 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2319,6 +2319,8 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
>                         next->perf_event_ctxp[ctxn] = ctx;
>                         ctx->task = next;
>                         next_ctx->task = task;
> +                       ctx->task_ctx_data = xchg(&next_ctx->task_ctx_data,
> +                                                 ctx->task_ctx_data);
>                         do_switch = 0;
>
>                         perf_event_sync_stat(ctx, next_ctx);
> --
> 1.8.4.2
>
