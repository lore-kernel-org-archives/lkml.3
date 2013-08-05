Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3HEGDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:03:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab3HEGDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:03:31 -0400
Date: Mon, 5 Aug 2013 09:03:24 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: fix check the reserved bits on the gpte of L2
Message-ID: <20130805060324.GA1550@redhat.com>
References: <51FF3127.5030206@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FF3127.5030206@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 12:59:19PM +0800, Xiao Guangrong wrote:
> Current code always uses arch.mmu to check the reserved bits on guest gpte
> which is valid only for L1 guest, we should use arch.nested_mmu instead when
> we translate gva to gpa for the L2 guest
> 
> Fix it by using @mmu instead since it is adapted to the current mmu mode
> automatically
> 
> The bug can be triggered when nested npt is used and L1 guest and L2 guest
> use different mmu mode
> 
> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Reviewed-by: Gleb Natapov <gleb@redhat.com>

> ---
>  arch/x86/kvm/paging_tmpl.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 7769699..3a75828 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -218,8 +218,7 @@ retry_walk:
>  		if (unlikely(!is_present_gpte(pte)))
>  			goto error;
> 
> -		if (unlikely(is_rsvd_bits_set(&vcpu->arch.mmu, pte,
> -					      walker->level))) {
> +		if (unlikely(is_rsvd_bits_set(mmu, pte, walker->level))) {
>  			errcode |= PFERR_RSVD_MASK | PFERR_PRESENT_MASK;
>  			goto error;
>  		}
> -- 
> 1.8.1.4

--
			Gleb.
