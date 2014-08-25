Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaHYJBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:01:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaHYJBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:01:18 -0400
Message-ID: <53FAFB53.7040806@redhat.com>
Date: Mon, 25 Aug 2014 11:01:07 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix xen guest panic due to lack of KVM_REQ_EVENT
References: <1408953506-7289-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1408953506-7289-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/08/2014 09:58, Wanpeng Li ha scritto:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c10408e..b7c0073 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4928,6 +4928,8 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
>  		if (!mask)
>  			kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	}
> +	if (!(int_shadow || mask))
> +		kvm_make_request(KVM_REQ_EVENT, vcpu);
>  }
>  
>  static void inject_emulated_exception(struct kvm_vcpu *vcpu)

No, this patch undoes the optimization in the buggy patch.

A KVM_REQ_EVENT must be missing somewhere else.

Paolo
