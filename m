Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966952AbaFTLLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:11:05 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:51855 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966703AbaFTLLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:11:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vincent =?ISO-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-sh@vger.kernel.org, linux-next@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH linux-next] ARM: shmobile: rcar-gen2: update call to dma_contiguous_reserve_area
Date: Fri, 20 Jun 2014 13:11:42 +0200
Message-ID: <5123262.2QjNse2sTm@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1403170270-17877-1-git-send-email-vincent.stehle@laposte.net>
References: <1403170270-17877-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

Thank you for the patch.

On Thursday 19 June 2014 11:31:10 Vincent Stehlé wrote:
> Commit 5ea3b1b2f8ad 'cma: add placement specifier for "cma=" kernel
> parameter' adds a new 'fixed' parameter to dma_contiguous_reserve_area().
> Update rcar_gen2_reserve() accordingly.
> 
> This fixes the following compilation error:
> 
>   arch/arm/mach-shmobile/setup-rcar-gen2.c: In function ‘rcar_gen2_reserve’:
> arch/arm/mach-shmobile/setup-rcar-gen2.c:182:10: error: too few arguments
> to function ‘dma_contiguous_reserve_area’
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
> Hi,
> 
> This can be seen with linux next-20140619 and e.g. arm allmodconfig.
> 
> Best regards,
> 
> V.
> 
>  arch/arm/mach-shmobile/setup-rcar-gen2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-shmobile/setup-rcar-gen2.c
> b/arch/arm/mach-shmobile/setup-rcar-gen2.c index 73fb2a6..42d5b43 100644
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

-- 
Regards,

Laurent Pinchart

