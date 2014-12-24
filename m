Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaLXM34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:29:56 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:43441 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaLXM3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:29:53 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "sasha.levin@oracle.com" <sasha.levin@oracle.com>,
        "hughd@google.com" <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH 10/38] arc: drop _PAGE_FILE and pte_file()-related
 helpers
Thread-Topic: [PATCH 10/38] arc: drop _PAGE_FILE and pte_file()-related
 helpers
Thread-Index: AQHQH3SBz61hfi42akCCUjmFe20Ejw==
Date: Wed, 24 Dec 2014 12:29:44 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BC95FE@IN01WEMBXA.internal.synopsys.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1419423766-114457-11-git-send-email-kirill.shutemov@linux.intel.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On Wednesday 24 December 2014 05:54 PM, Kirill A. Shutemov wrote:
> We've replaced remap_file_pages(2) implementation with emulation.
> Nobody creates non-linear mapping anymore.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> ---
>  arch/arc/include/asm/pgtable.h | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arc/include/asm/pgtable.h b/arch/arc/include/asm/pgtable.h
> index 6b0b7f7ef783..55694ee428d4 100644
> --- a/arch/arc/include/asm/pgtable.h
> +++ b/arch/arc/include/asm/pgtable.h
> @@ -61,7 +61,6 @@
>  #define _PAGE_WRITE         (1<<4)	/* Page has user write perm (H) */
>  #define _PAGE_READ          (1<<5)	/* Page has user read perm (H) */
>  #define _PAGE_MODIFIED      (1<<6)	/* Page modified (dirty) (S) */
> -#define _PAGE_FILE          (1<<7)	/* page cache/ swap (S) */
>  #define _PAGE_GLOBAL        (1<<8)	/* Page is global (H) */
>  #define _PAGE_PRESENT       (1<<10)	/* TLB entry is valid (H) */
>  
> @@ -73,7 +72,6 @@
>  #define _PAGE_READ          (1<<3)	/* Page has user read perm (H) */
>  #define _PAGE_ACCESSED      (1<<4)	/* Page is accessed (S) */
>  #define _PAGE_MODIFIED      (1<<5)	/* Page modified (dirty) (S) */
> -#define _PAGE_FILE          (1<<6)	/* page cache/ swap (S) */
>  #define _PAGE_GLOBAL        (1<<8)	/* Page is global (H) */
>  #define _PAGE_PRESENT       (1<<9)	/* TLB entry is valid (H) */
>  #define _PAGE_SHARED_CODE   (1<<11)	/* Shared Code page with cmn vaddr
> @@ -268,15 +266,6 @@ static inline void pmd_set(pmd_t *pmdp, pte_t *ptep)
>  	pte;								\
>  })
>  
> -/* TBD: Non linear mapping stuff */
> -static inline int pte_file(pte_t pte)
> -{
> -	return pte_val(pte) & _PAGE_FILE;
> -}
> -
> -#define PTE_FILE_MAX_BITS	30
> -#define pgoff_to_pte(x)         __pte(x)
> -#define pte_to_pgoff(x)		(pte_val(x) >> 2)
>  #define pte_pfn(pte)		(pte_val(pte) >> PAGE_SHIFT)
>  #define pfn_pte(pfn, prot)	(__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot)))
>  #define __pte_index(addr)	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
> @@ -358,13 +347,13 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
>  #endif
>  
>  extern void paging_init(void);
> -extern pgd_t swapper_pg_dir[] __aligned(PAGE_SIZE);
> +xtern pgd_t swapper_pg_dir[] __aligned(PAGE_SIZE);

I don't think u intended that. Otherwise

Acked-by: Vineet Gupta <vgupta@synopsys.com>

Thx,
-Vineet

