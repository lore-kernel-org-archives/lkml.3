Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaBUUZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:25:47 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37853 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaBUUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:25:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Amarinder Bindra <a-bindra@ti.com>
Cc: Chris Ball <chris@printf.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mmc: host: MMC_SH_MMCIF should depend on HAS_DMA
Date: Fri, 21 Feb 2014 21:26:59 +0100
Message-ID: <1491186.LfrL8k5P1F@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393012371-22320-1-git-send-email-geert@linux-m68k.org>
References: <1393012371-22320-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patches.

On Friday 21 February 2014 20:52:50 Geert Uytterhoeven wrote:
> If NO_DMA=y:
> 
>     drivers/built-in.o: In function `sh_mmcif_start_dma_tx':
>     sh_mmcif.c:(.text+0x5a3286): undefined reference to `dma_map_sg'
>     drivers/built-in.o: In function `sh_mmcif_start_dma_rx':
>     sh_mmcif.c:(.text+0x5a33fc): undefined reference to `dma_map_sg'
>     drivers/built-in.o: In function `sh_mmcif_end_cmd':
>     sh_mmcif.c:(.text+0x5a3668): undefined reference to `dma_unmap_sg'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

For both,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/mmc/host/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 1384f67abe21..bfe2133d0b9c 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -611,7 +611,7 @@ config MMC_DW_PCI
> 
>  config MMC_SH_MMCIF
>  	tristate "SuperH Internal MMCIF support"
> -	depends on MMC_BLOCK
> +	depends on MMC_BLOCK && HAS_DMA
>  	depends on SUPERH || ARCH_SHMOBILE || COMPILE_TEST
>  	help
>  	  This selects the MMC Host Interface controller (MMCIF).

-- 
Regards,

Laurent Pinchart

