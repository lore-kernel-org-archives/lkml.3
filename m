Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3GWLQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:16:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab3GWLQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:16:57 -0400
Message-ID: <51EE6613.7050507@redhat.com>
Date: Tue, 23 Jul 2013 13:16:35 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kvm: switch to use hypervisor_cpuid_base()
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <1374572465-15278-3-git-send-email-jasowang@redhat.com>
In-Reply-To: <1374572465-15278-3-git-send-email-jasowang@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/07/2013 11:41, Jason Wang ha scritto:
> Switch to use hypervisor_cpuid_base() to detect KVM.
> 
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  arch/x86/include/asm/kvm_para.h |   17 ++---------------
>  1 files changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 695399f..79bd075 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -2,6 +2,7 @@
>  #define _ASM_X86_KVM_PARA_H
>  
>  #include <asm/processor.h>
> +#include <asm/hypervisor.h>
>  #include <uapi/asm/kvm_para.h>
>  
>  extern void kvmclock_init(void);
> @@ -87,24 +88,10 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
>  
>  static inline bool kvm_para_available(void)
>  {
> -	unsigned int eax, ebx, ecx, edx;
> -	char signature[13];
> -
>  	if (boot_cpu_data.cpuid_level < 0)
>  		return false;	/* So we don't blow up on old processors */
>  
> -	if (cpu_has_hypervisor) {
> -		cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
> -		memcpy(signature + 0, &ebx, 4);
> -		memcpy(signature + 4, &ecx, 4);
> -		memcpy(signature + 8, &edx, 4);
> -		signature[12] = 0;
> -
> -		if (strcmp(signature, "KVMKVMKVM") == 0)
> -			return true;
> -	}
> -
> -	return false;
> +        return hypervisor_cpuid_base("KVMKVMKVM", 0);
>  }
>  
>  static inline unsigned int kvm_arch_para_features(void)
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

