Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaESLvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbaESLvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:51:21 -0400
Message-ID: <5379E43E.9070502@redhat.com>
Date: Mon, 19 May 2014 13:00:14 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: vmx: DR7 masking on task switch emulation is wrong
References: <1400482250-16631-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1400482250-16631-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/05/2014 08:50, Nadav Amit ha scritto:
> The DR7 masking which is done on task switch emulation should be in hex format
> (clearing the local breakpoints enable bits 0,2,4 and 6).
>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 138ceff..286d510 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5439,7 +5439,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
>  	}
>
>  	/* clear all local breakpoint enable flags */
> -	vmcs_writel(GUEST_DR7, vmcs_readl(GUEST_DR7) & ~55);
> +	vmcs_writel(GUEST_DR7, vmcs_readl(GUEST_DR7) & ~0x55);
>
>  	/*
>  	 * TODO: What about debug traps on tss switch?
>

Thanks, applying to kvm/queue.

Paolo
