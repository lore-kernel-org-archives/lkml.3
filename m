Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaLXOIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 09:08:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbaLXOIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 09:08:48 -0500
Message-ID: <1419430091.11699.0.camel@t520.localdomain>
Subject: Re: [PATCH 15/38] c6x: drop pte_file()
From: Mark Salter <msalter@redhat.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: akpm@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        davej@redhat.com, sasha.levin@oracle.com, hughd@google.com,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aurelien Jacquiot <a-jacquiot@ti.com>
Date: Wed, 24 Dec 2014 09:08:11 -0500
In-Reply-To: <1419423766-114457-16-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
	 <1419423766-114457-16-git-send-email-kirill.shutemov@linux.intel.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-24 at 14:22 +0200, Kirill A. Shutemov wrote:
> We've replaced remap_file_pages(2) implementation with emulation.
> Nobody creates non-linear mapping anymore.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> ---
>  arch/c6x/include/asm/pgtable.h | 5 -----
>  1 file changed, 5 deletions(-)
> 

Acked-by: Mark Salter <msalter@redhat.com>

> diff --git a/arch/c6x/include/asm/pgtable.h b/arch/c6x/include/asm/pgtable.h
> index c0eed5b18860..78d4483ba40c 100644
> --- a/arch/c6x/include/asm/pgtable.h
> +++ b/arch/c6x/include/asm/pgtable.h
> @@ -50,11 +50,6 @@ extern void paging_init(void);
>  #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
>  #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
>  
> -static inline int pte_file(pte_t pte)
> -{
> -	return 0;
> -}
> -
>  #define set_pte(pteptr, pteval) (*(pteptr) = pteval)
>  #define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
>  


