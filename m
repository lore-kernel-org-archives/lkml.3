Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab3EGHbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:31:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36908 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3EGHbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:31:42 -0400
Date: Tue, 7 May 2013 08:31:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] dma: ste_dma40: fix up static memcpy event lines
Message-ID: <20130507073136.GS24153@gmail.com>
References: <1367610578-2437-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367610578-2437-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 May 2013, Linus Walleij wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The commit
> "dmaengine: ste_dma40: Assign memcpy channels in the driver"
> had two problems:
> - It assigned magic numbers to the memcpy event lines
>   instead of giving them symbolic names.
> - It seems to have missed one of the memcpy event lines,
>   number 51.
> 
> This patch fixes it up.

Looks good to me: Acked-by Lee Jones <lee.jones@linaro.org>

> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Vinod: seeking an ACK for this to take it with the rest of
> Lee's patches in a DMA40 branch in ARM SoC.
> ---
>  drivers/dma/ste_dma40.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 12de79e..cd7b480 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -56,7 +56,21 @@
>  #define MAX(a, b) (((a) < (b)) ? (b) : (a))
>  
>  /* Reserved event lines for memcpy only. */
> -static int dma40_memcpy_channels[] = { 56, 57, 58, 59, 60 };
> +#define DB8500_DMA_MEMCPY_EV_0	51
> +#define DB8500_DMA_MEMCPY_EV_1	56
> +#define DB8500_DMA_MEMCPY_EV_2	57
> +#define DB8500_DMA_MEMCPY_EV_3	58
> +#define DB8500_DMA_MEMCPY_EV_4	59
> +#define DB8500_DMA_MEMCPY_EV_5	60
> +
> +static int dma40_memcpy_channels[] = {
> +	DB8500_DMA_MEMCPY_EV_0,
> +	DB8500_DMA_MEMCPY_EV_1,
> +	DB8500_DMA_MEMCPY_EV_2,
> +	DB8500_DMA_MEMCPY_EV_3,
> +	DB8500_DMA_MEMCPY_EV_4,
> +	DB8500_DMA_MEMCPY_EV_5,
> +};
>  
>  /**
>   * enum 40_command - The different commands and/or statuses.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
