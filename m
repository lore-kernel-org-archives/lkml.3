Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab3HGOHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:07:05 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43333 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097Ab3HGOHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:07:03 -0400
Message-ID: <52025481.8050705@redhat.com>
Date: Wed, 07 Aug 2013 16:06:57 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Gleb Natapov <gleb@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: fix check the reserved bits on the gpte of
 L2
References: <51FF3127.5030206@linux.vnet.ibm.com>
In-Reply-To: <51FF3127.5030206@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 06:59 AM, Xiao Guangrong wrote:
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
> ---
>   arch/x86/kvm/paging_tmpl.h | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 7769699..3a75828 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -218,8 +218,7 @@ retry_walk:
>   		if (unlikely(!is_present_gpte(pte)))
>   			goto error;
>
> -		if (unlikely(is_rsvd_bits_set(&vcpu->arch.mmu, pte,
> -					      walker->level))) {
> +		if (unlikely(is_rsvd_bits_set(mmu, pte, walker->level))) {
>   			errcode |= PFERR_RSVD_MASK | PFERR_PRESENT_MASK;
>   			goto error;
>   		}
>

Applied, thanks.

Paolo
