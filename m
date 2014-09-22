Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaIVJ2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:28:21 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37213 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaIVJ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:28:19 -0400
Message-ID: <541FEBB2.2070708@redhat.com>
Date: Mon, 22 Sep 2014 11:28:18 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 9/9] kvm, mem-hotplug: Unpin and remove kvm_arch->apic_access_page.
References: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com> <1411210071-14727-10-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1411210071-14727-10-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/09/2014 12:47, Tang Chen ha scritto:
> @@ -4534,8 +4539,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm))
> -		vmcs_write64(APIC_ACCESS_ADDR,
> -			     page_to_phys(vmx->vcpu.kvm->arch.apic_access_page));
> +		kvm_vcpu_reload_apic_access_page(vcpu);
>  
>  	if (vmx_vm_has_apicv(vcpu->kvm))
>  		memset(&vmx->pi_desc, 0, sizeof(struct pi_desc));

Please make the call unconditional in kvm_vcpu_reset.

> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 9c8ae32..99378d7 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3624,6 +3624,11 @@ static bool svm_has_secondary_apic_access(struct kvm_vcpu *vcpu)
>  	return false;
>  }
>  
> +static void svm_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
> +{
> +	return;
> +}
> +
>  static int svm_vm_has_apicv(struct kvm *kvm)
>  {
>  	return 0;

I will ask you to modify the vmx_has_secondary_apic_access callback in
such a way that svm_set_apic_access_page_addr is not needed, so please
remove it from v8.

Paolo
