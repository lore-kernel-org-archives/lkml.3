Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaIVJdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:33:31 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62261 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaIVJd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:33:29 -0400
Message-ID: <541FECE8.3070203@redhat.com>
Date: Mon, 22 Sep 2014 11:33:28 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 5/9] kvm, mem-hotplug: Reload L1's apic access page
 in vcpu_enter_guest().
References: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com> <1411210071-14727-6-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1411210071-14727-6-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/09/2014 12:47, Tang Chen ha scritto:
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
> @@ -4379,6 +4384,7 @@ static struct kvm_x86_ops svm_x86_ops = {
>  	.update_cr8_intercept = update_cr8_intercept,
>  	.set_virtual_x2apic_mode = svm_set_virtual_x2apic_mode,
>  	.has_secondary_apic_access = svm_has_secondary_apic_access,
> +	.set_apic_access_page_addr = svm_set_apic_access_page_addr,
>  	.vm_has_apicv = svm_vm_has_apicv,
>  	.load_eoi_exitmap = svm_load_eoi_exitmap,
>  	.hwapic_isr_update = svm_hwapic_isr_update,

Something's wrong in the way you're generating the patches, because
you're adding these hunks twice.

Paolo
