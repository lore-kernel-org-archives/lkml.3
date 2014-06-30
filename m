Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaF3IrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:47:14 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:44149 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaF3IrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:47:12 -0400
Date: Mon, 30 Jun 2014 11:47:07 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Pending interrupt may be delivered after INIT
Message-ID: <20140630084707.GJ18167@minantech.com>
References: <1404117327-20976-1-git-send-email-namit@cs.technion.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404117327-20976-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 11:35:27AM +0300, Nadav Amit wrote:
> We encountered a scenario in which after an INIT is delivered, a pending
> interrupt is delivered, although it was sent before the INIT.  As the SDM
> states in section 10.4.7.1, the ISR and the IRR should be cleared after INIT as
> KVM does.  This also means that pending interrupts should be cleared.  This
> patch clears upon reset (and INIT) the pending interrupts; and at the same
> occassion clears the pending exceptions, since they may cause a similar issue.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/x86.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f32a025..863ac07 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6835,6 +6835,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu)
>  	atomic_set(&vcpu->arch.nmi_queued, 0);
>  	vcpu->arch.nmi_pending = 0;
>  	vcpu->arch.nmi_injected = false;
> +	vcpu->arch.interrupt.pending = false;
> +	vcpu->arch.exception.pending = false;
kvm_clear_interrupt_queue(vcpu);
kvm_clear_exception_queue(vcpu);

>  
>  	memset(vcpu->arch.db, 0, sizeof(vcpu->arch.db));
>  	vcpu->arch.dr6 = DR6_FIXED_1;
> -- 
> 1.9.1
> 

--
			Gleb.
