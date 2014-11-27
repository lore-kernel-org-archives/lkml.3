Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbaK0RIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:08:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaK0RIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:08:02 -0500
Message-ID: <54775A6B.9060905@redhat.com>
Date: Thu, 27 Nov 2014 18:07:55 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: use MSR_ICR instead of a number
References: <1417018025-1189-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1417018025-1189-1-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26/11/2014 17:07, Radim Krčmář wrote:
> 0x830 MSR is 0x300 xAPIC MMIO, which is MSR_ICR.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  This applies on top of Amit's
>    [PATCH v2] KVM: x86: Fix reserved x2apic registers
>  in which I noticed this minor deficit.
> 
>  arch/x86/kvm/lapic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9c90d31..687874f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1887,7 +1887,7 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  		return 1;
>  
>  	/* if this is ICR write vector before command */
> -	if (msr == 0x830)
> +	if (reg == APIC_ICR)
>  		apic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
>  	return apic_reg_write(apic, reg, (u32)data);
>  }
> @@ -1908,7 +1908,7 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
>  
>  	if (apic_reg_read(apic, reg, 4, &low))
>  		return 1;
> -	if (msr == 0x830)
> +	if (reg == APIC_ICR)
>  		apic_reg_read(apic, APIC_ICR2, 4, &high);
>  
>  	*data = (((u64)high) << 32) | low;
> 

Applied, thanks.

Paolo
