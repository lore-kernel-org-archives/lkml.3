Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaGJMsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:48:07 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:57420 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaGJMsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:48:05 -0400
MIME-Version: 1.0
In-Reply-To: <1404931962-25917-3-git-send-email-geert@linux-m68k.org>
References: <1404931962-25917-1-git-send-email-geert@linux-m68k.org>
	<1404931962-25917-3-git-send-email-geert@linux-m68k.org>
Date: Thu, 10 Jul 2014 14:48:05 +0200
Message-ID: <CAPDyKFp7Xodp1-AxP-ZOqMchxaX4Gsu7giR0+1Qq0S2k9fonNQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mmc: MMC_USDHI6ROL0 should depend on HAS_DMA
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 20:52, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> If NO_DMA=y:
>
>     drivers/built-in.o: In function `usdhi6_dma_setup':
>     usdhi6rol0.c:(.text+0x5c35fc): undefined reference to `dma_map_sg'
>     drivers/built-in.o: In function `usdhi6_dma_stop_unmap':
>     usdhi6rol0.c:(.text+0x5c3738): undefined reference to `dma_unmap_sg'
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks! Applied for next.

Kind regards
Uffe

> ---
> v2:
>   - New
> ---
>  drivers/mmc/host/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 9ac9d8387df0..5ccde78e0110 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -698,6 +698,7 @@ config MMC_WMT
>
>  config MMC_USDHI6ROL0
>         tristate "Renesas USDHI6ROL0 SD/SDIO Host Controller support"
> +       depends on HAS_DMA
>         help
>           This selects support for the Renesas USDHI6ROL0 SD/SDIO
>           Host Controller
> --
> 1.9.1
>
