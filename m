Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaHRCPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 22:15:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:23510 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaHRCPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 22:15:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,882,1400050800"; 
   d="scan'208";a="589445467"
Date: Mon, 18 Aug 2014 10:17:15 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Nadav Amit <namit@cs.technion.ac.il>, pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Increase the number of fixed MTRR regs to 10
Message-ID: <20140818021715.GA7019@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1403101279-23759-1-git-send-email-namit@cs.technion.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403101279-23759-1-git-send-email-namit@cs.technion.ac.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nadav,
On Wed, Jun 18, 2014 at 05:21:19PM +0300, Nadav Amit wrote:
>Recent Intel CPUs have 10 variable range MTRRs. Since operating systems
>sometime make assumptions on CPUs while they ignore capability MSRs, it is
>better for KVM to be consistent with recent CPUs. Reporting more MTRRs than
>actually supported has no functional implications.
>
>Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>---
> arch/x86/include/asm/kvm_host.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index 4931415..0bab29d 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -95,7 +95,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
> #define KVM_REFILL_PAGES 25
> #define KVM_MAX_CPUID_ENTRIES 80
> #define KVM_NR_FIXED_MTRR_REGION 88
>-#define KVM_NR_VAR_MTRR 8
>+#define KVM_NR_VAR_MTRR 10
> 

We observed that there is obvious regression caused by this commit, 32bit 
win7 guest show blue screen during boot.

Regards,
Wanpeng Li 

> #define ASYNC_PF_PER_VCPU 64
> 
>-- 
>1.9.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
