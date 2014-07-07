Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaGGGh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:37:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:25552 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaGGGhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:37:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="539568289"
Message-ID: <53BA4004.7@intel.com>
Date: Mon, 07 Jul 2014 14:36:52 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 08/16] perf, x86: allocate space for storing LBR stack
References: <1404714527-18603-1-git-send-email-zheng.z.yan@intel.com> <1404714527-18603-10-git-send-email-zheng.z.yan@intel.com>
In-Reply-To: <1404714527-18603-10-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please ignore this patch

On 07/07/2014 02:28 PM, Yan, Zheng wrote:
> When the LBR call stack is enabled, it is necessary to save/restore
> the LBR stack on context switch. We can use pmu specific data to
> store LBR stack when task is scheduled out. This patch adds code
> that allocates the pmu specific data.
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> Reviewed-by: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c | 1 +
>  arch/x86/kernel/cpu/perf_event.h | 7 +++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 8868e9b..2008c2a 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1907,6 +1907,7 @@ static struct pmu pmu = {
>  
>  	.event_idx		= x86_pmu_event_idx,
>  	.sched_task		= x86_pmu_sched_task,
> +	.task_ctx_size          = sizeof(struct x86_perf_task_context),
>  };
>  
>  void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index cc25819..b0eabca 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -472,6 +472,13 @@ struct x86_pmu {
>  	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
>  };
>  
> +struct x86_perf_task_context {
> +	u64 lbr_from[MAX_LBR_ENTRIES];
> +	u64 lbr_to[MAX_LBR_ENTRIES];
> +	int lbr_callstack_users;
> +	int lbr_stack_state;
> +};
> +
>  enum {
>  	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT = PERF_SAMPLE_BRANCH_MAX_SHIFT,
>  	PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE,
> 

