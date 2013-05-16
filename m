Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab3EPLRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:17:20 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58870
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527Ab3EPLRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:17:18 -0400
Date: Thu, 16 May 2013 13:16:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>, michael@ellerman.id.au,
        benh@kernel.crashing.org, Linux PPC dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for
 PERF_SAMPLE_BRANCH_KERNEL
Message-ID: <20130516111634.GA15314@twins.programming.kicks-ass.net>
References: <20130503121122.931661809@chello.nl>
 <20130503121256.230745028@chello.nl>
 <CABPqkBTvcQAyXfeiJwpPsNtbs4ffsVguXE631dK_rbzHpwBdOg@mail.gmail.com>
 <20130516090916.GF19669@dyad.programming.kicks-ass.net>
 <8578.1368699317@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8578.1368699317@ale.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 08:15:17PM +1000, Michael Neuling wrote:
> Peter,
> 
> BTW PowerPC also has the ability to filter on conditional branches.  Any
> chance we could add something like the follow to perf also?
> 

I don't see an immediate problem with that except that we on x86 need to
implement that in the software filter. Stephane do you see any
fundamental issue with that?

> 
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index fb104e5..891c769 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -157,8 +157,9 @@ enum perf_branch_sample_type {
>  	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << 4, /* any call branch */
>  	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << 5, /* any return branch */
>  	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << 6, /* indirect calls */
> +	PERF_SAMPLE_BRANCH_CONDITIONAL  = 1U << 7, /* conditional branches */
>  
> -	PERF_SAMPLE_BRANCH_MAX		= 1U << 7, /* non-ABI */
> +	PERF_SAMPLE_BRANCH_MAX		= 1U << 8, /* non-ABI */
>  };
>  
>  #define PERF_SAMPLE_BRANCH_PLM_ALL \
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index cdf58ec..5b0b89d 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -676,6 +676,7 @@ static const struct branch_mode branch_modes[] = {
>  	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
>  	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
>  	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
> +	BRANCH_OPT("cnd", PERF_SAMPLE_BRANCH_CONDITIONAL),
>  	BRANCH_END
>  };
>  
