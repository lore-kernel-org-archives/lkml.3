Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab3EWLIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:08:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:2905 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758082Ab3EWLIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:08:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,728,1363158000"; 
   d="scan'208";a="338795226"
Date: Thu, 23 May 2013 16:02:05 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] dma: ste_dma40: fix up static memcpy event lines
Message-ID: <20130523103205.GE30200@intel.com>
References: <1367610578-2437-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367610578-2437-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 09:49:38PM +0200, Linus Walleij wrote:
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
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Vinod: seeking an ACK for this to take it with the rest of
> Lee's patches in a DMA40 branch in ARM SoC.
> ---
Acked-by: Vinod Koul <vinod.koul@intel.com>

Anyone else remaining, if so pls do ping :)

--
~Vinod
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
> -- 
> 1.7.11.3
> 
