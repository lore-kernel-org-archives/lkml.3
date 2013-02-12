Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab3BLIm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 03:42:58 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:61143 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab3BLIm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 03:42:56 -0500
Date: Tue, 12 Feb 2013 09:42:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 4/5] perf, x86: Support full width counting v2
Message-ID: <20130212084250.GA19475@gmail.com>
References: <1360265019-23865-1-git-send-email-andi@firstfloor.org>
 <1360265019-23865-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360265019-23865-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Recent Intel CPUs like Haswell and IvyBridge have a new alternative MSR
> range for perfctrs that allows writing the full counter width. Enable this
> range if the hardware reports it using a new capability bit.
> 
> This lowers the overhead of perf stat slightly because it has to do less
> interrupts to accumulate the counter value. On Haswell it also avoids some
> problems with TSX aborting when the end of the counter range is reached.
> 
> v2: Print the feature at boot
> Reviewed-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/uapi/asm/msr-index.h  |    3 +++
>  arch/x86/kernel/cpu/perf_event.h       |    1 +
>  arch/x86/kernel/cpu/perf_event_intel.c |    7 +++++++
>  3 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> index 433a59f..af41a77 100644
> --- a/arch/x86/include/uapi/asm/msr-index.h
> +++ b/arch/x86/include/uapi/asm/msr-index.h
> @@ -163,6 +163,9 @@
>  #define MSR_KNC_EVNTSEL0               0x00000028
>  #define MSR_KNC_EVNTSEL1               0x00000029
>  
> +/* Alternative perfctr range with full access. */
> +#define MSR_IA32_PMC0			0x000004c1
> +
>  /* AMD64 MSRs. Not complete. See the architecture manual for a more
>     complete list. */
>  
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index ded4667..adaa0b0 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -278,6 +278,7 @@ union perf_capabilities {
>  		u64	pebs_arch_reg:1;
>  		u64	pebs_format:4;
>  		u64	smm_freeze:1;
> +		u64	fw_write:1;

No brownies for obfuscation: that should be named 
full_width_write, not a meaningless abbreviation that anyone 
crossing the code could mistake as 'firewall write' or 'forward 
write' or anything.

Also a comment line at the field should explain its meaning.

Thanks,

	Ingo
