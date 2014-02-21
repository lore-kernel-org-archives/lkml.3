Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaBUU0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:26:16 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37858 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaBUU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:26:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: MTD_NAND_SH_FLCTL should depend on HAS_DMA
Date: Fri, 21 Feb 2014 21:27:27 +0100
Message-ID: <8022927.N4UoME29Ho@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393012474-22399-1-git-send-email-geert@linux-m68k.org>
References: <1393012474-22399-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

On Friday 21 February 2014 20:54:34 Geert Uytterhoeven wrote:
> If NO_DMA=y:
> 
>     drivers/built-in.o: In function `flctl_dma_fifo0_transfer':
>     sh_flctl.c:(.text+0x210398): undefined reference to `dma_map_single'
>     sh_flctl.c:(.text+0x2104b0): undefined reference to `dma_unmap_single'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/mtd/nand/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 90ff447bf043..e7786913280a 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -458,6 +458,7 @@ config MTD_NAND_MXC
> 
>  config MTD_NAND_SH_FLCTL
>  	tristate "Support for NAND on Renesas SuperH FLCTL"
> +	depends on HAS_DMA
>  	depends on SUPERH || ARCH_SHMOBILE || COMPILE_TEST
>  	help
>  	  Several Renesas SuperH CPU has FLCTL. This option enables support

-- 
Regards,

Laurent Pinchart

