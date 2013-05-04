Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab3EDLNB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 07:13:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54832 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab3EDLM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 07:12:59 -0400
Date: Sat, 4 May 2013 13:19:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: mingo@kernel.org, a.p.zijlstra@chello.nl
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf/x86/intel/lbr: Demand proper privileges
 for PERF_SAMPLE_BRANCH_KERNEL
Message-ID: <20130504111907.GA3411@pd.tnic>
References: <20130503121256.230745028@chello.nl>
 <tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 04, 2013 at 01:22:57AM -0700, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  0f5c78b5f33ce940034743e5f9485fc81ad75b0f
> Gitweb:     http://git.kernel.org/tip/0f5c78b5f33ce940034743e5f9485fc81ad75b0f
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Fri, 3 May 2013 14:11:25 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sat, 4 May 2013 08:37:48 +0200
> 
> perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
> 
> We should always have proper privileges when requesting kernel
> data.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: <stable@kernel.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: eranian@google.com
> Link: http://lkml.kernel.org/r/20130503121256.230745028@chello.nl
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Link: http://lkml.kernel.org/n/tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org
> ---
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index de341d4..0e92871 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
>  	if (br_type & PERF_SAMPLE_BRANCH_USER)
>  		mask |= X86_BR_USER;
>  
> -	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
> +	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
> +		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
> +			return -EACCES;

It is probably not too late to amend this patch and remove the "-EACCES":

arch/x86/kernel/cpu/perf_event_intel_lbr.c: In function ‘intel_pmu_setup_sw_lbr_filter’:
arch/x86/kernel/cpu/perf_event_intel_lbr.c:323:4: warning: ‘return’ with a value, in function returning void [enabled by default]

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
