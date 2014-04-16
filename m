Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbaDPTEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:04:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbaDPTEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:04:02 -0400
Date: Wed, 16 Apr 2014 16:03:29 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix page-tables reserved bits
Message-ID: <20140416190329.GB8773@amt.cnet>
References: <1396582264-9864-1-git-send-email-namit@cs.technion.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396582264-9864-1-git-send-email-namit@cs.technion.ac.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 06:31:04AM +0300, Nadav Amit wrote:
> KVM does not handle the reserved bits of x86 page tables correctly:
> In PAE, bits 5:8 are reserved in the PDPTE.
> In IA-32e, bit 8 is not reserved.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/mmu.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index f5704d9..3993976 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3538,7 +3538,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
>  	case PT32E_ROOT_LEVEL:
>  		context->rsvd_bits_mask[0][2] =
>  			rsvd_bits(maxphyaddr, 63) |
> -			rsvd_bits(7, 8) | rsvd_bits(1, 2);	/* PDPTE */
> +			rsvd_bits(5, 8) | rsvd_bits(1, 2);	/* PDPTE */
>  		context->rsvd_bits_mask[0][1] = exb_bit_rsvd |
>  			rsvd_bits(maxphyaddr, 62);	/* PDE */
>  		context->rsvd_bits_mask[0][0] = exb_bit_rsvd |
> @@ -3550,9 +3550,9 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
>  		break;
>  	case PT64_ROOT_LEVEL:
>  		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
> -			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
> +			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
>  		context->rsvd_bits_mask[0][2] = exb_bit_rsvd |
> -			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
> +			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);

Bit 7 is not reserved either, for the PDPTE (its PageSize bit).

