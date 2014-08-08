Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbaHHHIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:08:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:50277 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931AbaHHHES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:04:18 -0400
Date: Fri, 8 Aug 2014 09:04:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: kan.liang@intel.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, x86: Fix :pp without LBR
Message-ID: <20140808070413.GC3935@laptop>
References: <1407456534-15747-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407456534-15747-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 05:08:54PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> This fixes a side effect of Kan's earlier patch to probe the LBRs at boot
> time. Normally when the LBRs are disabled cycles:pp is disabled too.
> So for example cycles:pp doesn't work.
> 
> However this is not needed with PEBSv2 and later (Haswell) because
> it does not need LBRs to correct the IP-off-by-one.
> 
> So add an extra check for PEBSv2 that also allows :pp
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 2879ecd..0646d3b 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -387,7 +387,7 @@ int x86_pmu_hw_config(struct perf_event *event)
>  			precise++;
>  
>  			/* Support for IP fixup */
> -			if (x86_pmu.lbr_nr)
> +			if (x86_pmu.lbr_nr || x86_pmu.intel_cap.pebs_format >= 2)
>  				precise++;

Thanks
