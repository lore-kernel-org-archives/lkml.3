Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaF3As7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 20:48:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbaF3As5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 20:48:57 -0400
From: Bandan Das <bsd@redhat.com>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: pbonzini@redhat.com, gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix lapic.c debug prints
References: <1404034131-2392-1-git-send-email-namit@cs.technion.ac.il>
Date: Sun, 29 Jun 2014 20:48:41 -0400
In-Reply-To: <1404034131-2392-1-git-send-email-namit@cs.technion.ac.il> (Nadav
	Amit's message of "Sun, 29 Jun 2014 12:28:51 +0300")
Message-ID: <jpgr427kys6.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nadav Amit <namit@cs.technion.ac.il> writes:

> In two cases lapic.c does not use the apic_debug macro correctly. This patch
> fixes them.
>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/lapic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 0069118..3855103 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1451,7 +1451,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
>  	vcpu->arch.apic_arb_prio = 0;
>  	vcpu->arch.apic_attention = 0;
>  
> -	apic_debug(KERN_INFO "%s: vcpu=%p, id=%d, base_msr="
> +	apic_debug("%s: vcpu=%p, id=%d, base_msr="
>  		   "0x%016" PRIx64 ", base_address=0x%0lx.\n", __func__,
>  		   vcpu, kvm_apic_id(apic),
>  		   vcpu->arch.apic_base, apic->base_address);
> @@ -1895,7 +1895,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>  		/* evaluate pending_events before reading the vector */
>  		smp_rmb();
>  		sipi_vector = apic->sipi_vector;
> -		pr_debug("vcpu %d received sipi with vector # %x\n",
> +		apic_debug("vcpu %d received sipi with vector # %x\n",

Why don't we just use pr_debug all throughout ?

>  			 vcpu->vcpu_id, sipi_vector);
>  		kvm_vcpu_deliver_sipi_vector(vcpu, sipi_vector);
>  		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
