Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3BADnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:43:02 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:53623 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3BADnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:43:00 -0500
Date: Thu, 31 Jan 2013 22:42:57 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sboyd@codeaurora.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        catalin.marinas@arm.com, marc.zyngier@arm.com,
        linus.walleij@linaro.org, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v4 07/13] ARM: LPAE: define ARCH_LOW_ADDRESS_LIMIT for
 bootmem
In-Reply-To: <1359669512-31276-8-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1301312242300.6300@xanadu.home>
References: <1359669512-31276-1-git-send-email-cyril@ti.com> <1359669512-31276-8-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, Cyril Chemparathy wrote:

> This patch adds an architecture defined override for ARCH_LOW_ADDRESS_LIMIT.
> On PAE systems, the absence of this override causes bootmem to incorrectly
> limit itself to 32-bit addressable physical memory.
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  arch/arm/include/asm/memory.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index 73cf03a..8825abb 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -275,6 +275,8 @@ static inline __deprecated void *bus_to_virt(unsigned long x)
>  #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
>  #define virt_addr_valid(kaddr)	((unsigned long)(kaddr) >= PAGE_OFFSET && (unsigned long)(kaddr) < (unsigned long)high_memory)
>  
> +#define ARCH_LOW_ADDRESS_LIMIT		PHYS_MASK
> +
>  #endif
>  
>  #include <asm-generic/memory_model.h>
> -- 
> 1.7.9.5
> 
