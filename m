Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3KLPAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:00:24 -0500
Received: from multi.imgtec.com ([194.200.65.239]:53008 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab3KLPAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:00:19 -0500
Message-ID: <52824267.7010505@imgtec.com>
Date: Tue, 12 Nov 2013 14:59:51 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-metag@vger.kernel.org>
Subject: Re: [PATCH 05/11] metag: use generic fixmap.h
References: <1384262545-20875-1-git-send-email-msalter@redhat.com> <1384262545-20875-6-git-send-email-msalter@redhat.com>
In-Reply-To: <1384262545-20875-6-git-send-email-msalter@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_12_15_00_14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13 13:22, Mark Salter wrote:
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: James Hogan <james.hogan@imgtec.com>
> CC: linux-metag@vger.kernel.org

Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

> ---
>  arch/metag/include/asm/fixmap.h | 32 +-------------------------------
>  1 file changed, 1 insertion(+), 31 deletions(-)
> 
> diff --git a/arch/metag/include/asm/fixmap.h b/arch/metag/include/asm/fixmap.h
> index 3331275..af621b0 100644
> --- a/arch/metag/include/asm/fixmap.h
> +++ b/arch/metag/include/asm/fixmap.h
> @@ -51,37 +51,7 @@ enum fixed_addresses {
>  #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
>  #define FIXADDR_START	((FIXADDR_TOP - FIXADDR_SIZE) & PMD_MASK)
>  
> -#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
> -#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
> -
> -extern void __this_fixmap_does_not_exist(void);
> -/*
> - * 'index to address' translation. If anyone tries to use the idx
> - * directly without tranlation, we catch the bug with a NULL-deference
> - * kernel oops. Illegal ranges of incoming indices are caught too.
> - */
> -static inline unsigned long fix_to_virt(const unsigned int idx)
> -{
> -	/*
> -	 * this branch gets completely eliminated after inlining,
> -	 * except when someone tries to use fixaddr indices in an
> -	 * illegal way. (such as mixing up address types or using
> -	 * out-of-range indices).
> -	 *
> -	 * If it doesn't get removed, the linker will complain
> -	 * loudly with a reasonably clear error message..
> -	 */
> -	if (idx >= __end_of_fixed_addresses)
> -		__this_fixmap_does_not_exist();
> -
> -	return __fix_to_virt(idx);
> -}
> -
> -static inline unsigned long virt_to_fix(const unsigned long vaddr)
> -{
> -	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
> -	return __virt_to_fix(vaddr);
> -}
> +#include <asm-generic/fixmap.h>
>  
>  #define kmap_get_fixmap_pte(vaddr) \
>  	pte_offset_kernel( \
> 

