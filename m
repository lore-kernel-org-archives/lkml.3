Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3BADv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:51:27 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:55037 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3BADv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:51:26 -0500
Date: Thu, 31 Jan 2013 22:51:21 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sboyd@codeaurora.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        catalin.marinas@arm.com, marc.zyngier@arm.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH v4 13/13] ARM: fix type of PHYS_PFN_OFFSET to unsigned
 long
In-Reply-To: <1359669512-31276-14-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1301312250580.6300@xanadu.home>
References: <1359669512-31276-1-git-send-email-cyril@ti.com> <1359669512-31276-14-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, Cyril Chemparathy wrote:

> On LPAE machines, PHYS_OFFSET evaluates to a phys_addr_t and this type is
> inherited by the PHYS_PFN_OFFSET definition as well.  Consequently, the kernel
> build emits warnings of the form:
> 
> init/main.c: In function 'start_kernel':
> init/main.c:588:7: warning: format '%lx' expects argument of type 'long unsigned int', but argument 2 has type 'phys_addr_t' [-Wformat]
> 
> This patch fixes this warning by pinning down the PFN type to unsigned long.
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/include/asm/memory.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index f3a7f76..32e9e5a 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -223,7 +223,7 @@ static inline unsigned long __phys_to_virt(unsigned long x)
>   * direct-mapped view.  We assume this is the first page
>   * of RAM in the mem_map as well.
>   */
> -#define PHYS_PFN_OFFSET	(PHYS_OFFSET >> PAGE_SHIFT)
> +#define PHYS_PFN_OFFSET	((unsigned long)(PHYS_OFFSET >> PAGE_SHIFT))
>  
>  /*
>   * These are *only* valid on the kernel direct mapped RAM memory.
> -- 
> 1.7.9.5
> 
