Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab3C1Png (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:43:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:17445 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab3C1Pnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:43:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,927,1355126400"; 
   d="scan'208";a="308708015"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] perf, x86: Add Sandy Bridge constraints for CYCLE_ACTIVITY.*
References: <1362784968-12542-1-git-send-email-andi@firstfloor.org>
Date: Thu, 28 Mar 2013 08:43:33 -0700
In-Reply-To: <1362784968-12542-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 8 Mar 2013 15:22:48 -0800")
Message-ID: <m27gkril7e.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>

Ping! Patch is missing review.

-Andi

>
> Add CYCLE_ACTIVITY.CYCLES_NO_DISPATCH/CYCLES_L1D_PENDING
> These recently documented events have restrictions to counter 0-3
> and counter 2 respectively.  The scheduler needs to know that
> to schedule them correctly.
>
> IvyBridge already has the necessary constraints.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 5b59c6c..0d2f9d8 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -104,6 +104,8 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
>  	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
>  	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
>  	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
> +	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_DISPATCH */
> +	INTEL_UEVENT_CONSTRAINT(0x02a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
>  	EVENT_CONSTRAINT_END
>  };

-- 
ak@linux.intel.com -- Speaking for myself only
