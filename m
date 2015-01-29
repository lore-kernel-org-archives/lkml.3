Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbbA2Phh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:37:37 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:50530 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbbA2Phg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:37:36 -0500
Date: Thu, 29 Jan 2015 17:37:01 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: kirill.shutemov@linux.intel.com, gxt@mprc.pku.edu.cn,
        james.hogan@imgtec.com, linux@arm.linux.org.uk, nm@ti.com,
        tyler.baker@linaro.org, mm-commits@vger.kernel.org
Subject: Re: + mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch
 added to -mm tree
Message-ID: <20150129153701.GB21698@node.dhcp.inet.fi>
References: <54c69dbb.9IbFgxgVUFfaIvqP%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54c69dbb.9IbFgxgVUFfaIvqP%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 12:04:11PM -0800, akpm@linux-foundation.org wrote:
> diff -puN arch/unicore32/mm/pgd.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm arch/unicore32/mm/pgd.c
> --- a/arch/unicore32/mm/pgd.c~mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm
> +++ a/arch/unicore32/mm/pgd.c
> @@ -69,6 +69,7 @@ pgd_t *get_pgd_slow(struct mm_struct *mm
>  
>  no_pte:
>  	pmd_free(mm, new_pmd);
> +	mm_dec_nr_pmds(mm);
>  no_pmd:
>  	free_pages((unsigned long)new_pgd, 0);
>  no_pgd:
> @@ -96,7 +97,9 @@ void free_pgd_slow(struct mm_struct *mm,
>  	pte = pmd_pgtable(*pmd);
>  	pmd_clear(pmd);
>  	pte_free(mm, pte);
> +	atomic_long_dec(&mm->nr_ptes);
>  	pmd_free(mm, pmd);
> +	mm_dec_nr_pmds(mm)
>  free:
>  	free_pages((unsigned long) pgd, 0);
>  }

>From 77c258a2489f67a5019a29469650e9bca70645d9 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Thu, 29 Jan 2015 14:39:17 +0200
Subject: [PATCH] unicore32: missed semicolon

---
 arch/unicore32/mm/pgd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/unicore32/mm/pgd.c b/arch/unicore32/mm/pgd.c
index 1bc00d0305d4..2ade20d8eab3 100644
--- a/arch/unicore32/mm/pgd.c
+++ b/arch/unicore32/mm/pgd.c
@@ -99,7 +99,7 @@ void free_pgd_slow(struct mm_struct *mm, pgd_t *pgd)
 	pte_free(mm, pte);
 	atomic_long_dec(&mm->nr_ptes);
 	pmd_free(mm, pmd);
-	mm_dec_nr_pmds(mm)
+	mm_dec_nr_pmds(mm);
 free:
 	free_pages((unsigned long) pgd, 0);
 }
-- 
 Kirill A. Shutemov
