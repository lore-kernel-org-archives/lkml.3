Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbaIRSM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaIRSM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:12:56 -0400
Date: Thu, 18 Sep 2014 20:12:51 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Liang Chen <liangchen.linux@gmail.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: x86: directly use kvm_make_request again
Message-ID: <20140918181250.GA16481@potion.brq.redhat.com>
References: <1411058317-23646-1-git-send-email-liangchen.linux@gmail.com>
 <1411058317-23646-3-git-send-email-liangchen.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411058317-23646-3-git-send-email-liangchen.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-18 12:38-0400, Liang Chen:
> A one-line wrapper around kvm_make_request does not seem
> particularly useful. Replace kvm_mmu_flush_tlb() with
> kvm_make_request() again to free the namespace a bit.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/mmu.c              | 16 +++++-----------
>  arch/x86/kvm/vmx.c              |  2 +-
>  arch/x86/kvm/x86.c              | 11 ++++++++---
>  4 files changed, 14 insertions(+), 16 deletions(-)
> [...]
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9eb5458..fc3df50 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> [...]
> @@ -6018,8 +6024,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
>  			kvm_mmu_sync_roots(vcpu);
>  		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
> -			++vcpu->stat.tlb_flush;
> -			kvm_x86_ops->tlb_flush(vcpu);
> +			kvm_vcpu_flush_tlb(vcpu);
>  		}

(Braces are not necessary.)
