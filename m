Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaDPGnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:43:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:35950 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaDPGnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:43:09 -0400
Message-ID: <1397630569.32730.10.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>
Date: Wed, 16 Apr 2014 16:42:49 +1000
In-Reply-To: <20140416160617.bd724cb4061f04409546650b@canb.auug.org.au>
References: <20140416160617.bd724cb4061f04409546650b@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 16:06 +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
> 
> arch/powerpc/platforms/44x/warp.c: In function 'warp_probe':
> arch/powerpc/platforms/44x/warp.c:52:2: error: 'ISA_DMA_THRESHOLD' undeclared (first use in this function)
> arch/powerpc/mm/dma-noncoherent.c: In function '__dma_alloc_coherent':
> arch/powerpc/mm/dma-noncoherent.c:159:13: error: 'ISA_DMA_THRESHOLD' undeclared (first use in this function)
> 
> Probably caused by commit ff35bd54456e ("lib/scatterlist: make
> ARCH_HAS_SG_CHAIN an actual Kconfig") which removed an implicit include
> of <asm/dma.h> with the removal of the arch specific scatterlist.h.
> 
> I have added the following patch for today:

Patch looks good, poke me next week when I'm back and I'll apply it

or send it to Linus or akpm with my

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 16 Apr 2014 16:03:01 +1000
> Subject: [PATCH] lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig fix
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/powerpc/mm/dma-noncoherent.c | 1 +
>  arch/powerpc/platforms/44x/warp.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/powerpc/mm/dma-noncoherent.c b/arch/powerpc/mm/dma-noncoherent.c
> index 7b6c10750179..d85e86aac7fb 100644
> --- a/arch/powerpc/mm/dma-noncoherent.c
> +++ b/arch/powerpc/mm/dma-noncoherent.c
> @@ -33,6 +33,7 @@
>  #include <linux/export.h>
>  
>  #include <asm/tlbflush.h>
> +#include <asm/dma.h>
>  
>  #include "mmu_decl.h"
>  
> diff --git a/arch/powerpc/platforms/44x/warp.c b/arch/powerpc/platforms/44x/warp.c
> index 534574a97ec9..3a104284b338 100644
> --- a/arch/powerpc/platforms/44x/warp.c
> +++ b/arch/powerpc/platforms/44x/warp.c
> @@ -25,6 +25,7 @@
>  #include <asm/time.h>
>  #include <asm/uic.h>
>  #include <asm/ppc4xx.h>
> +#include <asm/dma.h>
>  
> 
>  static __initdata struct of_device_id warp_of_bus[] = {
> -- 
> 1.9.2
> 


