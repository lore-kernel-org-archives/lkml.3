Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaFWAPs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 20:15:48 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39794 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaFWAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 20:15:46 -0400
Date: Mon, 23 Jun 2014 09:15:37 +0900
From: Simon Horman <horms@verge.net.au>
To: Vincent =?utf-8?Q?Stehl=C3=A9?= <vincent.stehle@laposte.net>
Cc: linux-sh@vger.kernel.org, linux-next@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH linux-next] ARM: shmobile: rcar-gen2: update call to
 dma_contiguous_reserve_area
Message-ID: <20140623001537.GA8798@verge.net.au>
References: <1403170270-17877-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403170270-17877-1-git-send-email-vincent.stehle@laposte.net>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 11:31:10AM +0200, Vincent Stehlé wrote:
> Commit 5ea3b1b2f8ad 'cma: add placement specifier for "cma=" kernel parameter'
> adds a new 'fixed' parameter to dma_contiguous_reserve_area(). Update
> rcar_gen2_reserve() accordingly.
> 
> This fixes the following compilation error:
> 
>   arch/arm/mach-shmobile/setup-rcar-gen2.c: In function ‘rcar_gen2_reserve’:
>   arch/arm/mach-shmobile/setup-rcar-gen2.c:182:10: error: too few arguments to function ‘dma_contiguous_reserve_area’
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> 
> Hi,
> 
> This can be seen with linux next-20140619 and e.g. arm allmodconfig.

Thanks, I will queue this up in the branch where the patch
that adds this problem lies.

> Best regards,
> 
> V.
> 
>  arch/arm/mach-shmobile/setup-rcar-gen2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-shmobile/setup-rcar-gen2.c b/arch/arm/mach-shmobile/setup-rcar-gen2.c
> index 73fb2a6..42d5b43 100644
> --- a/arch/arm/mach-shmobile/setup-rcar-gen2.c
> +++ b/arch/arm/mach-shmobile/setup-rcar-gen2.c
> @@ -179,6 +179,6 @@ void __init rcar_gen2_reserve(void)
>  #ifdef CONFIG_DMA_CMA
>  	if (mrc.size)
>  		dma_contiguous_reserve_area(mrc.size, mrc.base, 0,
> -					    &rcar_gen2_dma_contiguous);
> +					    &rcar_gen2_dma_contiguous, true);
>  #endif
>  }
> -- 
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
