Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070Ab3BMOfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:35:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44272 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab3BMOfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:35:11 -0500
Date: Wed, 13 Feb 2013 15:35:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, gleb@redhat.com, riel@redhat.com,
        shuah.khan@hp.com, mtosatti@redhat.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tip:x86/mm] x86/kvm: Fix compile warning in
 kvm_register_steal_time()
Message-ID: <20130213143503.GA26948@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, mingo@kernel.org,
	hpa@zytor.com, linux-kernel@vger.kernel.org,
	dave@linux.vnet.ibm.com, gleb@redhat.com, riel@redhat.com,
	shuah.khan@hp.com, mtosatti@redhat.com, tglx@linutronix.de,
	linux-tip-commits@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1360119442.8356.8.camel@lorien2>
 <tip-136867f517cbc3f8a91f035677911a6b503c3323@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-136867f517cbc3f8a91f035677911a6b503c3323@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 04:36:02AM -0800, tip-bot for Shuah Khan wrote:
> Commit-ID:  136867f517cbc3f8a91f035677911a6b503c3323
> Gitweb:     http://git.kernel.org/tip/136867f517cbc3f8a91f035677911a6b503c3323
> Author:     Shuah Khan <shuah.khan@hp.com>
> AuthorDate: Tue, 5 Feb 2013 19:57:22 -0700
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Mon, 11 Feb 2013 11:04:31 +0100
> 
> x86/kvm: Fix compile warning in kvm_register_steal_time()
> 
> Fix the following compile warning in kvm_register_steal_time():
> 
>   CC      arch/x86/kernel/kvm.o
>   arch/x86/kernel/kvm.c: In function ‘kvm_register_steal_time’: arch/x86/kernel/kvm.c:302:3:
>   warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 3 has type ‘phys_addr_t’ [-Wformat]
> 
> Introduced via:
> 
>   5dfd486c4750 x86, kvm: Fix kvm's use of __pa() on percpu areas
>   d76565344512 x86, mm: Create slow_virt_to_phys()
>   f3c4fbb68e93 x86, mm: Use new pagetable helpers in try_preserve_large_page()
>   4cbeb51b860c x86, mm: Pagetable level size/shift/mask helpers
>   a25b9316841c x86, mm: Make DEBUG_VIRTUAL work earlier in boot
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> Acked-by: Gleb Natapov <gleb@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: shuahkhan@gmail.com
> Cc: avi@redhat.com
> Cc: gleb@redhat.com
> Cc: mst@redhat.com
> Link: http://lkml.kernel.org/r/1360119442.8356.8.camel@lorien2
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/kvm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index aa7e58b..9cec202 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -298,8 +298,8 @@ static void kvm_register_steal_time(void)
>  	memset(st, 0, sizeof(*st));
>  
>  	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
> -	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %lx\n",
> -		cpu, slow_virt_to_phys(st));
> +	pr_info("kvm-stealtime: cpu %d, msr %llx\n",
> +		cpu, (unsigned long long) slow_virt_to_phys(st));

I'm guessing this - like a bunch of other places in the kernel - should
be converted to the new %pa printk format once the last has been merged:

http://marc.info/?l=linux-kernel&m=135883371328510&w=2

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
