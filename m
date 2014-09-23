Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaIWID4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:03:56 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59069 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaIWIDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:03:52 -0400
Message-ID: <54212958.2000804@redhat.com>
Date: Tue, 23 Sep 2014 10:03:36 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chen Yucong <slaoub@gmail.com>, gleb@kernel.org
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kvm: use macros to compute bank MSRs
References: <1411440275-24631-1-git-send-email-slaoub@gmail.com>
In-Reply-To: <1411440275-24631-1-git-send-email-slaoub@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/09/2014 04:44, Chen Yucong ha scritto:
> Avoid open coded calculations for bank MSRs by using well-defined
> macros that hide the index of higher bank MSRs.
> 
> No semantic changes.
> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>
> ---
>  arch/x86/kvm/x86.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 31e55ae..e8c1e3b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1825,7 +1825,7 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  		break;
>  	default:
>  		if (msr >= MSR_IA32_MC0_CTL &&
> -		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
> +		    msr < MSR_IA32_MCx_CTL(bank_num)) {
>  			u32 offset = msr - MSR_IA32_MC0_CTL;
>  			/* only 0 or all 1s can be written to IA32_MCi_CTL
>  			 * some Linux kernels though clear bit 10 in bank 4 to
> @@ -2184,7 +2184,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  
>  	case MSR_IA32_MCG_CTL:
>  	case MSR_IA32_MCG_STATUS:
> -	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
> +	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
>  		return set_msr_mce(vcpu, msr, data);
>  
>  	/* Performance counters are not protected by a CPUID bit,
> @@ -2350,7 +2350,7 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  		break;
>  	default:
>  		if (msr >= MSR_IA32_MC0_CTL &&
> -		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
> +		    msr < MSR_IA32_MCx_CTL(bank_num)) {
>  			u32 offset = msr - MSR_IA32_MC0_CTL;
>  			data = vcpu->arch.mce_banks[offset];
>  			break;
> @@ -2531,7 +2531,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  	case MSR_IA32_MCG_CAP:
>  	case MSR_IA32_MCG_CTL:
>  	case MSR_IA32_MCG_STATUS:
> -	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
> +	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
>  		return get_msr_mce(vcpu, msr, pdata);
>  	case MSR_K7_CLK_CTL:
>  		/*
> 

Thanks, applied.

Paolo
