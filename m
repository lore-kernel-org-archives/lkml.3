Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbbALRZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:25:42 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60220 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbALRZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:25:41 -0500
Date: Mon, 12 Jan 2015 17:25:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] arm64: allow late use of early_ioremap
Message-ID: <20150112172534.GJ13360@arm.com>
References: <1421081711-1128-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421081711-1128-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 04:55:11PM +0000, Mark Salter wrote:
> Commit 0e63ea48b4d8 (arm64/efi: add missing call to early_ioremap_reset())
> added a missing call to early_ioremap_reset(). This triggers a BUG if code
> tries using early_ioremap() after the early_ioremap_reset(). This is a
> problem for some ACPI code which needs short-lived temporary mappings
> after paging_init() but before mm_init(). This patch adds definitions for
> the __late_set_fixmap() and __late_clear_fixmap() which avoids the BUG
> by allowing later use of early_ioremap().
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Leif Lindholm <leif.lindholm@linaro.org>
> CC: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/include/asm/fixmap.h | 3 +++
>  1 file changed, 3 insertions(+)

Given that we don't support ACPI on arm64 in mainline, I assume this can
wait until at least 3.20?

Will

> diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
> index 9ef6eca..e629c70 100644
> --- a/arch/arm64/include/asm/fixmap.h
> +++ b/arch/arm64/include/asm/fixmap.h
> @@ -61,6 +61,9 @@ void __init early_fixmap_init(void);
>  
>  #define __early_set_fixmap __set_fixmap
>  
> +#define __late_set_fixmap __set_fixmap
> +#define __late_clear_fixmap(idx) __set_fixmap((idx), 0, FIXMAP_PAGE_CLEAR)
> +
>  extern void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
>  
>  #include <asm-generic/fixmap.h>
> -- 
> 1.8.3.1
> 
> 
