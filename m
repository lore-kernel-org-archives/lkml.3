Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaIXHt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:49:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:38398 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaIXHt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:49:56 -0400
Date: Wed, 24 Sep 2014 09:49:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, acme@redhat.com, cebbert.lkml@gmail.com
Subject: Re: [PATCH v6 2/6] perf/x86: add support for sampling PEBS machine
 state registers
Message-ID: <20140924074951.GT16043@twins.programming.kicks-ass.net>
References: <1411484269-32311-1-git-send-email-eranian@google.com>
 <1411484269-32311-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411484269-32311-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 04:57:45PM +0200, Stephane Eranian wrote:
> PEBS can capture machine state regs at retiremnt of the sampled
> instructions. When precise sampling is enabled on an event, PEBS
> is used, so substitute the interrupted state with the PEBS state.
> Note that not all registers are captured by PEBS. Those missing
> are replaced by the interrupt state counter-parts.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |   22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index b1553d0..0318023 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -886,6 +886,28 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  	regs.bp = pebs->bp;
>  	regs.sp = pebs->sp;
>  
> +	if (sample_type & PERF_SAMPLE_REGS_INTR) {
> +		regs.ax = pebs->ax;
> +		regs.bx = pebs->bx;
> +		regs.cx = pebs->cx;
> +		regs.dx = pebs->dx;
> +		regs.si = pebs->si;
> +		regs.di = pebs->di;
> +		regs.sp = pebs->sp;
> +		regs.bp = pebs->bp;
> +
> +		regs.eflags = pebs->flags;
> +
> +		regs.r8 = pebs->r8;
> +		regs.r9 = pebs->r9;
> +		regs.r10 = pebs->r10;
> +		regs.r11 = pebs->r11;
> +		regs.r12 = pebs->r12;
> +		regs.r13 = pebs->r13;
> +		regs.r14 = pebs->r14;
> +		regs.r15 = pebs->r15;
> +	}

You also lost the x86_32 compile fix I send earlier.
