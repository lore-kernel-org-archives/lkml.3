Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaHMKmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:42:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59548 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaHMKmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:42:08 -0400
Date: Wed, 13 Aug 2014 12:41:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, acme@kernel.org,
        zheng.z.yan@intel.com, ak@linux.intel.com, tglx@linutronix.de,
        bp@suse.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/uncore: move NHM-EX/ WSM-EX specific
 code to seperate file
Message-ID: <20140813104153.GB20522@pd.tnic>
References: <1406704935-27708-4-git-send-email-zheng.z.yan@intel.com>
 <tip-c1e46580c3b7bf25053519cf39f01a2f9ea4d865@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-c1e46580c3b7bf25053519cf39f01a2f9ea4d865@git.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 01:23:12AM -0700, tip-bot for Yan, Zheng wrote:
> Commit-ID:  c1e46580c3b7bf25053519cf39f01a2f9ea4d865
> Gitweb:     http://git.kernel.org/tip/c1e46580c3b7bf25053519cf39f01a2f9ea4d865
> Author:     Yan, Zheng <zheng.z.yan@intel.com>
> AuthorDate: Wed, 30 Jul 2014 15:22:15 +0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 13 Aug 2014 07:51:08 +0200
> 
> perf/x86/uncore: move NHM-EX/WSM-EX specific code to seperate file
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/r/1406704935-27708-4-git-send-email-zheng.z.yan@intel.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/cpu/Makefile                       |    2 +-
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c      | 1038 +-------------
>  arch/x86/kernel/cpu/perf_event_intel_uncore.h      |  185 +--
>  ...el_uncore.c => perf_event_intel_uncore_nhmex.c} | 1483 +++-----------------
>  4 files changed, 196 insertions(+), 2512 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index 7dee866..7e1fd4e 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -37,7 +37,7 @@ endif
>  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
>  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
>  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_uncore_snb.o
> -obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore_snbep.o
> +obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore_snbep.o perf_event_intel_uncore_nhmex.o
>  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o

These filenames are begging to go to a separate dir. arch/x86/perf/
would be a good one, peterz says.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
