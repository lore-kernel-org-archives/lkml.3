Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaELKqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:46:19 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46738 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbaELKqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:46:18 -0400
Message-ID: <5370A672.1050103@redhat.com>
Date: Mon, 12 May 2014 12:46:10 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix CR3 reserved bits check in long mode
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il> <1397781312-6885-1-git-send-email-namit@cs.technion.ac.il> <1397781312-6885-2-git-send-email-namit@cs.technion.ac.il> <536DD1AC.9070605@web.de> <536DD432.30809@web.de>
In-Reply-To: <536DD432.30809@web.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/05/2014 09:24, Jan Kiszka ha scritto:
> From: Jan Kiszka <jan.kiszka@siemens.com>
>
> Regression of 346874c9: PAE is set in long mode, but that does not mean
> we have valid PDPTRs.
>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  arch/x86/kvm/x86.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c5582c3..198aac8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -701,10 +701,11 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  		return 0;
>  	}
>
> -	if (is_long_mode(vcpu) && (cr3 & CR3_L_MODE_RESERVED_BITS))
> -		return 1;
> -	if (is_pae(vcpu) && is_paging(vcpu) &&
> -	    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
> +	if (is_long_mode(vcpu)) {
> +		if (cr3 & CR3_L_MODE_RESERVED_BITS)
> +			return 1;
> +	} else if (is_pae(vcpu) && is_paging(vcpu) &&
> +		   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
>  		return 1;
>
>  	vcpu->arch.cr3 = cr3;
>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

will apply tomorrow, thanks.

Paolo
