Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709AbaEFKsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 06:48:41 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:39160 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934660AbaEFKsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 06:48:38 -0400
Date: Tue, 6 May 2014 03:48:33 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: Re: [PATCH v5 4/6] arm64: Add 4 levels of page tables definition
 with 4KB pages
Message-ID: <20140506104833.GA3066@lvm>
References: <000401cf64e5$d6c18990$84449cb0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000401cf64e5$d6c18990$84449cb0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 11:34:12AM +0900, Jungseok Lee wrote:
> This patch adds hardware definition and types for 4 levels of
> translation tables with 4KB pages.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Steve Capper <steve.capper@linaro.org>
> Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> ---
>  arch/arm64/include/asm/pgtable-4level-hwdef.h |   50 +++++++++++++++++
>  arch/arm64/include/asm/pgtable-4level-types.h |   71 +++++++++++++++++++++++++
>  2 files changed, 121 insertions(+)
>  create mode 100644 arch/arm64/include/asm/pgtable-4level-hwdef.h
>  create mode 100644 arch/arm64/include/asm/pgtable-4level-types.h
> 
> diff --git a/arch/arm64/include/asm/pgtable-4level-hwdef.h b/arch/arm64/include/asm/pgtable-4level-hwdef.h
> new file mode 100644
> index 0000000..0ec84e2
> --- /dev/null
> +++ b/arch/arm64/include/asm/pgtable-4level-hwdef.h
> @@ -0,0 +1,50 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_PGTABLE_4LEVEL_HWDEF_H
> +#define __ASM_PGTABLE_4LEVEL_HWDEF_H
> +
> +#define PTRS_PER_PTE		512
> +#define PTRS_PER_PMD		512
> +#define PTRS_PER_PUD		512
> +#define PTRS_PER_PGD		512
> +
> +/*
> + * PGDIR_SHIFT determines the size a top-level page table entry can map.
> + */
> +#define PGDIR_SHIFT		39
> +#define PGDIR_SIZE		(_AC(1, UL) << PGDIR_SHIFT)
> +#define PGDIR_MASK		(~(PGDIR_SIZE-1))
> +
> +/*
> + * PUD_SHIFT determines the size the second level page table entry can map.
> + */
> +#define PUD_SHIFT		30
> +#define PUD_SIZE		(_AC(1, UL) << PUD_SHIFT)
> +#define PUD_MASK		(~(PUD_SIZE-1))
> +
> +/*
> + * PMD_SHIFT determines the size the third level page table entry can map.
> + */
> +#define PMD_SHIFT		21
> +#define PMD_SIZE		(_AC(1, UL) << PMD_SHIFT)
> +#define PMD_MASK		(~(PMD_SIZE-1))
> +
> +/*
> + * section address mask and size definitions.
> + */
> +#define SECTION_SHIFT		21
> +#define SECTION_SIZE		(_AC(1, UL) << SECTION_SHIFT)
> +#define SECTION_MASK		(~(SECTION_SIZE-1))
> +
> +#endif
> diff --git a/arch/arm64/include/asm/pgtable-4level-types.h b/arch/arm64/include/asm/pgtable-4level-types.h
> new file mode 100644
> index 0000000..7ad8dd2
> --- /dev/null
> +++ b/arch/arm64/include/asm/pgtable-4level-types.h
> @@ -0,0 +1,71 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_PGTABLE_4LEVEL_TYPES_H
> +#define __ASM_PGTABLE_4LEVEL_TYPES_H
> +
> +#include <asm/types.h>
> +
> +typedef u64 pteval_t;
> +typedef u64 pmdval_t;
> +typedef u64 pudval_t;
> +typedef u64 pgdval_t;
> +
> +#undef STRICT_MM_TYPECHECKS
> +
> +#ifdef STRICT_MM_TYPECHECKS
> +
> +/*
> + * These are used to make use of C type-checking..
> + */
> +typedef struct { pteval_t pte; } pte_t;
> +typedef struct { pmdval_t pmd; } pmd_t;
> +typedef struct { pudval_t pud; } pud_t;
> +typedef struct { pgdval_t pgd; } pgd_t;
> +typedef struct { pteval_t pgprot; } pgprot_t;
> +
> +#define pte_val(x)	((x).pte)
> +#define pmd_val(x)	((x).pmd)
> +#define pud_val(x)	((x).pud)
> +#define pgd_val(x)	((x).pgd)
> +#define pgprot_val(x)	((x).pgprot)
> +
> +#define __pte(x)	((pte_t) { (x) } )
> +#define __pmd(x)	((pmd_t) { (x) } )
> +#define __pud(x)	((pud_t) { (x) } )
> +#define __pgd(x)	((pgd_t) { (x) } )
> +#define __pgprot(x)	((pgprot_t) { (x) } )
> +
> +#else	/* !STRICT_MM_TYPECHECKS */
> +
> +typedef pteval_t pte_t;
> +typedef pmdval_t pmd_t;
> +typedef pudval_t pud_t;
> +typedef pgdval_t pgd_t;
> +typedef pteval_t pgprot_t;
> +
> +#define pte_val(x)	(x)
> +#define pmd_val(x)	(x)
> +#define pud_val(x)	(x)
> +#define pgd_val(x)	(x)
> +#define pgprot_val(x)	(x)
> +
> +#define __pte(x)	(x)
> +#define __pmd(x)	(x)
> +#define __pud(x)	(x)
> +#define __pgd(x)	(x)
> +#define __pgprot(x)	(x)
> +
> +#endif /* STRICT_MM_TYPECHECKS */
> +
> +#endif /* __ASM_PGTABLE_4LEVEL_TYPES_H */
> -- 
> 1.7.10.4
> 
> 
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
