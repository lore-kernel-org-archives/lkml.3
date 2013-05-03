Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762Ab3ECOmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:42:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:23953 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762442Ab3ECOmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:42:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,605,1363158000"; 
   d="scan'208";a="297108268"
Date: Fri, 3 May 2013 07:41:57 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for
 PERF_SAMPLE_BRANCH_KERNEL
Message-ID: <20130503144157.GQ19487@tassilo.jf.intel.com>
References: <20130503121122.931661809@chello.nl>
 <20130503121256.230745028@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503121256.230745028@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 02:11:25PM +0200, Peter Zijlstra wrote:
> We should always have proper privileges when requesting kernel data.
> 
> Cc: Andi Kleen <ak@linux.intel.com>

Acked-by: Andi Kleen <ak@linux.intel.com>

> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filte
>  	if (br_type & PERF_SAMPLE_BRANCH_USER)
>  		mask |= X86_BR_USER;
>  
> -	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
> +	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
> +		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
> +			return -EACCES;
>  		mask |= X86_BR_KERNEL;
> +	}
>  
>  	/* we ignore BRANCH_HV here */
>  
> 
> 

-- 
ak@linux.intel.com -- Speaking for myself only
