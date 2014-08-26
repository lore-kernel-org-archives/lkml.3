Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbaHZV1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:27:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:57030 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbaHZV1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:27:52 -0400
Date: Tue, 26 Aug 2014 23:27:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: peterz@infradead.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] perf, x86: Remove incorrect model number from Haswell
 perf
In-Reply-To: <1409006611-30741-2-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.10.1408262325200.3323@nanos>
References: <1409006611-30741-1-git-send-email-andi@firstfloor.org> <1409006611-30741-2-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 89bc750..e280a86 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2541,10 +2541,9 @@ __init int intel_pmu_init(void)
>  
>  
>  	case 60: /* 22nm Haswell */
> +	case 70:
>  	case 63:
>  	case 69:
> -	case 70:
> -	case 71:

So what's the point of making the obvious onliner patch

-	case 71:

into something which reorders the sorted case numbers?

And of course, this patch is missing any explanation WHY 71 is
incorrect and how it got there in the first place.

Thanks,

	tglx


