Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3DUJ4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 05:56:31 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41540 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3DUJ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:56:30 -0400
Date: Sun, 21 Apr 2013 11:56:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Jan Beulich <jbeulich@suse.com>
Subject: Re: [PATCH] perf, x86: Fix some broken initconsts
Message-ID: <20130421095626.GA10683@gmail.com>
References: <1366515819-18081-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366515819-18081-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
> index 4b7731b..2cfe648 100644
> --- a/arch/x86/kernel/cpu/perf_event_knc.c
> +++ b/arch/x86/kernel/cpu/perf_event_knc.c
> @@ -17,7 +17,7 @@ static const u64 knc_perfmon_event_map[] =
>    [PERF_COUNT_HW_BRANCH_MISSES]		= 0x002b,
>  };
>  
> -static __initconst u64 knc_hw_cache_event_ids
> +static __initconst const u64 knc_hw_cache_event_ids
>  				[PERF_COUNT_HW_CACHE_MAX]
>  				[PERF_COUNT_HW_CACHE_OP_MAX]
>  				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
> @@ -284,7 +284,7 @@ static struct attribute *intel_knc_formats_attr[] = {
>  	NULL,
>  };
>  
> -static __initconst struct x86_pmu knc_pmu = {
> +static __initconst const struct x86_pmu knc_pmu = {
>  	.name			= "knc",
>  	.handle_irq		= knc_pmu_handle_irq,
>  	.disable_all		= knc_pmu_disable_all,

Already fixed in:

  c391c7884633 x86: Constify a few items

Thanks,

	Ingo
