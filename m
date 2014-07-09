Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaGIQQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:16:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaGIQQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:16:12 -0400
Message-ID: <53BD6974.8010306@redhat.com>
Date: Wed, 09 Jul 2014 18:10:28 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Pending interrupt may be delivered after
 INIT
References: <20140630084707.GJ18167@minantech.com> <1404118982-9429-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1404118982-9429-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/06/2014 11:03, Nadav Amit ha scritto:
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
> index f32a025..6425a31 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6835,6 +6835,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu)
>  	atomic_set(&vcpu->arch.nmi_queued, 0);
>  	vcpu->arch.nmi_pending = 0;
>  	vcpu->arch.nmi_injected = false;
> +	kvm_clear_interrupt_queue(vcpu);
> +	kvm_clear_exception_queue(vcpu);
>
>  	memset(vcpu->arch.db, 0, sizeof(vcpu->arch.db));
>  	vcpu->arch.dr6 = DR6_FIXED_1;
>

Applied to kvm/queue, thanks.

Paolo
