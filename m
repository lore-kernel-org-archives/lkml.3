Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaHLWsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 18:48:32 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:53059 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaHLWsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 18:48:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140812070915.GM9918@twins.programming.kicks-ass.net>
References: <20140812060031.GA25239@quad>
	<20140812070915.GM9918@twins.programming.kicks-ass.net>
Date: Wed, 13 Aug 2014 00:48:30 +0200
Message-ID: <CABPqkBSdrv9S+sUG5SB8ksxC3Y6jOd+SuRBA1nbpZ7AKSpqM2w@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/uncore: export basic memory events for IVT IMC PMU
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 9:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 12, 2014 at 08:00:31AM +0200, Stephane Eranian wrote:
>>  arch/x86/kernel/cpu/perf_event_intel_uncore.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> index cfc6f9d..800e087 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> @@ -1391,6 +1391,7 @@ static struct intel_uncore_type ivt_uncore_imc = {
>>       .fixed_ctr_bits = 48,
>>       .fixed_ctr      = SNBEP_MC_CHy_PCI_PMON_FIXED_CTR,
>>       .fixed_ctl      = SNBEP_MC_CHy_PCI_PMON_FIXED_CTL,
>> +     .event_descs    = snbep_uncore_imc_events,
>>       IVT_UNCORE_PCI_COMMON_INIT(),
>>  };
>
> I changed that to the below; seeing how I have the uncore splitup
> patches.
>
Looks good to me.

> Also, I'm very tempted to do a s/ivt/ivbep/ on that whole thing. We
> really should not mix all these stupid names.
>
That's okay with me.

Thanks.

> ---
> Subject: perf/x86/uncore: export basic memory events for IVT IMC PMU
> From: Stephane Eranian <eranian@google.com>
> Date: Tue, 12 Aug 2014 08:00:31 +0200
>
> This patch exposes two basic events for Ivytown IMC uncore PMU:
>
> - cas_count_read: number of full-cache line reads to memory controller
> - cas_count_write: number of full-cache line writes to memory controller
>
> Those events use the same encoding as for SNB-EP, so reuse the same
> event table. See specification in:
>
> http://www.intel.com/content/dam/www/public/us/en/documents/manuals/xeon-e5-2600-v2-uncore-manual.pdf
>
> By aggregating all the read and write events from all the memory controllers
> of each processor socket, one can determine the total memory bandwidth utilization.
>
> Cc: zheng.z.yan@intel.com
> Cc: mingo@elte.hu
> Cc: ak@linux.intel.com
> Signed-off-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/20140812060031.GA25239@quad
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
> @@ -1422,6 +1422,7 @@ static struct intel_uncore_type ivt_unco
>         .fixed_ctr_bits = 48,
>         .fixed_ctr      = SNBEP_MC_CHy_PCI_PMON_FIXED_CTR,
>         .fixed_ctl      = SNBEP_MC_CHy_PCI_PMON_FIXED_CTL,
> +       .event_descs    = snbep_uncore_imc_events,
>         IVT_UNCORE_PCI_COMMON_INIT(),
>  };
>
