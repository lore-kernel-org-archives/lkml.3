Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3C1Pon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:44:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:12703 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab3C1Pol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:44:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,927,1355126400"; 
   d="scan'208";a="277220631"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] perf, x86: Allow setting period 1
References: <1362785070-12860-1-git-send-email-andi@firstfloor.org>
Date: Thu, 28 Mar 2013 08:44:40 -0700
In-Reply-To: <1362785070-12860-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 8 Mar 2013 15:24:30 -0800")
Message-ID: <m238vfil5j.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> I had some requests for setting period 1, so that every event of something
> is caught.  To my knowledge there is no limit to 1 on Intel hardware.
> Just remove the check for minimum 2

Ping! patch is missing review.

>
> If specific CPUs have problems we can black list them.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index bf0f01a..2b394ae 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -946,11 +946,6 @@ int x86_perf_event_set_period(struct perf_event *event)
>  		hwc->last_period = period;
>  		ret = 1;
>  	}
> -	/*
> -	 * Quirk: certain CPUs dont like it if just 1 hw_event is left:
> -	 */
> -	if (unlikely(left < 2))
> -		left = 2;
>  
>  	if (left > x86_pmu.max_period)
>  		left = x86_pmu.max_period;

-- 
ak@linux.intel.com -- Speaking for myself only
