Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3KHTl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:41:29 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:39097 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595Ab3KHTl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:41:28 -0500
Date: Fri, 8 Nov 2013 20:41:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: suravee.suthikulpanit@amd.com
Cc: mingo@kernel.org, mingo@redhat.com, jacob.w.shin@gmail.com,
        oleg@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        hpa@zytor.com, tgl@domain.invalid, linux-kernel@vger.kernel.org,
        sherry.hurwitz@amd.com
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20131108194122.GA14606@localhost.localdomain>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 11:11:06AM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Jacob Shin <jacob.w.shin@gmail.com>
> 
> Implement hardware breakpoint address mask for AMD Family 16h and
> above processors. CPUID feature bit indicates hardware support for
> DRn_ADDR_MASK MSRs. These masks further qualify DRn/DR7 hardware
> breakpoint addresses to allow matching of larger addresses ranges.
> 
> Valuable advice and pseudo code from Oleg Nesterov <oleg@redhat.com>
> 
> Signed-off-by: Jacob Shin <jacob.w.shin@gmail.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/cpufeature.h     |  2 ++
>  arch/x86/include/asm/debugreg.h       |  5 ++++
>  arch/x86/include/asm/hw_breakpoint.h  |  1 +
>  arch/x86/include/uapi/asm/msr-index.h |  4 +++
>  arch/x86/kernel/cpu/amd.c             | 19 ++++++++++++++
>  arch/x86/kernel/hw_breakpoint.c       | 47 ++++++++++++++---------------------
>  6 files changed, 49 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index d3f5c63..26609bb 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -170,6 +170,7 @@
>  #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
>  #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
>  #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
> +#define X86_FEATURE_BPEXT	(6*32+26) /* data breakpoint extension */

Does this feature only work on data breakpoint or is instruction breakpoint
address range supported as well?
