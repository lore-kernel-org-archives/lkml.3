Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaIKJK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:10:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaIKJKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:10:52 -0400
Message-ID: <5411670D.9000801@redhat.com>
Date: Thu, 11 Sep 2014 11:10:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/7] kvm: Use APIC_DEFAULT_PHYS_BASE macro as the apic
 access page address.
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com> <1410413886-32213-2-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1410413886-32213-2-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/09/2014 07:38, Tang Chen ha scritto:
> We have APIC_DEFAULT_PHYS_BASE defined as 0xfee00000, which is also the address of
> apic access page. So use this macro.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Reviewed-by: Gleb Natapov <gleb@kernel.org>
> ---
>  arch/x86/kvm/svm.c | 3 ++-
>  arch/x86/kvm/vmx.c | 6 +++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ddf7427..1d941ad 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1257,7 +1257,8 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
>  	svm->asid_generation = 0;
>  	init_vmcb(svm);
>  
> -	svm->vcpu.arch.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
> +	svm->vcpu.arch.apic_base = APIC_DEFAULT_PHYS_BASE |
> +				   MSR_IA32_APICBASE_ENABLE;
>  	if (kvm_vcpu_is_bsp(&svm->vcpu))
>  		svm->vcpu.arch.apic_base |= MSR_IA32_APICBASE_BSP;
>  
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index bfe11cf..4b80ead 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -3999,13 +3999,13 @@ static int alloc_apic_access_page(struct kvm *kvm)
>  		goto out;
>  	kvm_userspace_mem.slot = APIC_ACCESS_PAGE_PRIVATE_MEMSLOT;
>  	kvm_userspace_mem.flags = 0;
> -	kvm_userspace_mem.guest_phys_addr = 0xfee00000ULL;
> +	kvm_userspace_mem.guest_phys_addr = APIC_DEFAULT_PHYS_BASE;
>  	kvm_userspace_mem.memory_size = PAGE_SIZE;
>  	r = __kvm_set_memory_region(kvm, &kvm_userspace_mem);
>  	if (r)
>  		goto out;
>  
> -	page = gfn_to_page(kvm, 0xfee00);
> +	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
>  	if (is_error_page(page)) {
>  		r = -EFAULT;
>  		goto out;
> @@ -4477,7 +4477,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>  
>  	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
>  	kvm_set_cr8(&vmx->vcpu, 0);
> -	apic_base_msr.data = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
> +	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
>  	if (kvm_vcpu_is_bsp(&vmx->vcpu))
>  		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
>  	apic_base_msr.host_initiated = true;
> 

Applied, thanks.

Paolo
