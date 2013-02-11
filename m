Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab3BKJGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:06:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab3BKJGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:06:37 -0500
Date: Mon, 11 Feb 2013 11:06:26 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, avi@redhat.com,
        mtosatti@redhat.com, mst@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH linux-next] x86/kvm: Fix compile warning in
 kvm_register_steal_time()
Message-ID: <20130211090626.GV7837@redhat.com>
References: <1360119442.8356.8.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=cp1255
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1360119442.8356.8.camel@lorien2>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 07:57:22PM -0700, Shuah Khan wrote:
> Fix the following compile warning in kvm_register_steal_time():
>   CC      arch/x86/kernel/kvm.o
> arch/x86/kernel/kvm.c: In function ‘kvm_register_steal_time’:
> arch/x86/kernel/kvm.c:302:3: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 3 has type ‘phys_addr_t’ [-Wformat]
> 
Ingo, the warning is from the tip tree. Can you take the fix?

> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  arch/x86/kernel/kvm.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index fe75a28..b686a90 100644
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
>  }
>  
>  static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
> -- 
> 1.7.9.5
> 
> 

--
			Gleb.
