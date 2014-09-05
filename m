Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbaIEKfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:35:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62880 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbaIEKfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:35:07 -0400
Date: Fri, 5 Sep 2014 12:35:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung@kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH v4 2/6] perf/x86: add support for sampling PEBS machine
 state registers
Message-ID: <20140905103501.GA30329@gmail.com>
References: <1409756351-25743-1-git-send-email-eranian@google.com>
 <1409756351-25743-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409756351-25743-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> PEBS can capture machine state regs at retiremnt of the sampled
> instructions. When precise sampling is enabled on an event, PEBS
> is used, so substitute the interrupted state with the PEBS state.
> Note that not all registers are captured by PEBS. Those missing
> are replaced by the interrupt state counter-parts.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 9dc4199..139a8a5 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -886,6 +886,23 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  	regs.bp = pebs->bp;
>  	regs.sp = pebs->sp;
>  
> +	if (sample_type & PERF_SAMPLE_REGS_INTR) {
> +		regs.ax = pebs->ax;
> +		regs.bx = pebs->bx;
> +		regs.cx = pebs->cx;
> +		regs.si = pebs->si;
> +		regs.di = pebs->di;
> +
> +		regs.r8 = pebs->r8;
> +		regs.r9 = pebs->r9;
> +		regs.r10 = pebs->r10;
> +		regs.r11 = pebs->r11;
> +		regs.r12 = pebs->r12;
> +		regs.r13 = pebs->r13;
> +		regs.r14 = pebs->r14;
> +		regs.r14 = pebs->r15;

Beyond regs.r15, is pebs->dx left out on purpose? It's part of 
pebs_record_hsw so presumably the hardware fills it in.

Thanks,

	Ingo
