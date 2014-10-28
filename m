Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaJ1MgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:36:24 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:49686 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaJ1MgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:36:21 -0400
Date: Tue, 28 Oct 2014 12:36:11 +0000
From: Will Deacon <will.deacon@arm.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arm64: ARCH_PFN_OFFSET should be unsigned long
Message-ID: <20141028123610.GC12136@arm.com>
References: <1414475041-31480-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414475041-31480-1-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 05:44:01AM +0000, Neil Zhang wrote:
> pfns are unsigned long, but PHYS_PFN_OFFSET is phys_addr_t. This leads
> to page_to_pfn() returning phys_addr_t which cause type mismatches in
> some print statements.

Do you have a specific example? Both of those types are 64-bit on arm64.

Will

> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  arch/arm64/include/asm/memory.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index ccc7087..a62cd07 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -142,7 +142,7 @@ static inline void *phys_to_virt(phys_addr_t x)
>   *  virt_to_page(k)	convert a _valid_ virtual address to struct page *
>   *  virt_addr_valid(k)	indicates whether a virtual address is valid
>   */
> -#define ARCH_PFN_OFFSET		PHYS_PFN_OFFSET
> +#define ARCH_PFN_OFFSET		((unsigned long)PHYS_PFN_OFFSET)
>  
>  #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
>  #define	virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
> -- 
> 1.7.9.5
> 
> 
