Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaBER06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:26:58 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:37479 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaBER04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:26:56 -0500
MIME-Version: 1.0
In-Reply-To: <1388728091-18564-9-git-send-email-zheng.z.yan@intel.com>
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
	<1388728091-18564-9-git-send-email-zheng.z.yan@intel.com>
Date: Wed, 5 Feb 2014 18:26:55 +0100
Message-ID: <CABPqkBT+HRbPdOHebzr1vePXWqTgifYJC6OKc1yqwZhSKAPASg@mail.gmail.com>
Subject: Re: [PATCH 08/14] perf, x86: allocate space for storing LBR stack
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
> When the LBR call stack is enabled, it is necessary to save/restore
> the LBR stack on context switch. We can use pmu specific data to
> store LBR stack when task is scheduled out. This patch adds code
> that allocates the pmu specific data.
>
Reviewed-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c | 1 +
>  arch/x86/kernel/cpu/perf_event.h | 7 +++++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 69e2095..2e43f1b 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1879,6 +1879,7 @@ static struct pmu pmu = {
>
>         .event_idx              = x86_pmu_event_idx,
>         .sched_task             = x86_pmu_sched_task,
> +       .task_ctx_size          = sizeof(struct x86_perf_task_context),
>  };
>
>  void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 3ef4b79..3ed9629 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -459,6 +459,13 @@ struct x86_pmu {
>         struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
>  };
>
> +struct x86_perf_task_context {
> +       u64 lbr_from[MAX_LBR_ENTRIES];
> +       u64 lbr_to[MAX_LBR_ENTRIES];
> +       int lbr_callstack_users;
> +       int lbr_stack_state;
> +};
> +
>  enum {
>         PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT = PERF_SAMPLE_BRANCH_MAX_SHIFT,
>         PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE,
> --
> 1.8.4.2
>
