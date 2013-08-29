Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3H2Gla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:41:30 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58112 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3H2Gl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:41:28 -0400
Date: Thu, 29 Aug 2013 08:41:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARC: Add perf support
Message-ID: <20130829064124.GB27322@gmail.com>
References: <1377720814-2779-1-git-send-email-mjonker@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377720814-2779-1-git-send-email-mjonker@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mischa Jonker <Mischa.Jonker@synopsys.com> wrote:

> +/* The "generalized" performance events seem to really be a copy
> +   of the available events on x86 processors; the mapping to ARC
> +   events is not always possible 1-to-1. Fortunately, there doesn't
> +   seem to be an exact definition for these events, so we can cheat
> +   a bit where necessary */
> +static const char * const arc_pmu_ev_hw_map[] = {
> +	/* cycles not in halted state */
> +	[PERF_COUNT_HW_CPU_CYCLES] = "crun",
> +	/* reference cycles not in halted state; also "crun" as we don't
> +	   do Dynamic Voltage/Frequency Scaling (yet) */
> +	[PERF_COUNT_HW_REF_CPU_CYCLES] = "crun",
> +	/* Unclear what this means, Intel uses 0x013c, which according to
> +	   their datasheet means "unhalted reference cycles". Don't ask
> +	   me what the difference is with PERF_COUNT_HW_REF_CPU_CYCLES */
> +	[PERF_COUNT_HW_BUS_CYCLES] = "crun",
> +	[PERF_COUNT_HW_INSTRUCTIONS] = "iall",
> +	[PERF_COUNT_HW_BRANCH_MISSES] = "bpfail",
> +	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = "ijmp",
> +	/* ARC can either measure stalls per pipeline stage, or all stalls
> +	   combined; for now we assign all stalls to STALLED_CYCLES_BACKEND
> +	   and all pipeline flushes (e.g. caused by mispredicts, etc.) to
> +	   STALLED_CYCLES_FRONTEND.
> +
> +	   We could start multiple performance counters and combine everything
> +	   afterwards, but that makes it complicated, and users can always
> +	   use PERF_TYPE_RAW.
> +
> +	   Note that I$ cache misses aren't counted by either of the two! */

Haven't really looked at the patch in detail, just noticed the following 
nit, please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

Thanks,

        Ingo
