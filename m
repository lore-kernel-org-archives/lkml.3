Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3DVKmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:42:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:45175 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab3DVKl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:41:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="230233265"
Date: Mon, 22 Apr 2013 15:40:29 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 08/32] dmaengine: ste_dma40: Optimise local MAX() macro
Message-ID: <20130422101029.GP24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-9-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:11:50AM +0100, Lee Jones wrote:
> The current implementation of the DMA40's local MAX() macro evaluates
> its arguments more times than is necessary. This patch strips it
> optimises it to only evaluate what's appropriate.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Reported-by: Harvey Harrison <harvey.harrison@gmail.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/dma/ste_dma40.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index b21a8a3..7b451b2 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -53,7 +53,7 @@
>  #define D40_ALLOC_PHY		BIT(30)
>  #define D40_ALLOC_LOG_FREE	BIT(0)
>  
> -#define MAX(a, b) (((a) < (b)) ? (b) : (a))
> +#define MAX(a, b) ((a > b) ? a : b)
Am not a big fan of own redefines, can you use kernel max() macro instead

--
~Vinod
>  
>  #define D40_IS_SRC(dir)  ((dir == STEDMA40_PERIPH_TO_MEM) ? true : false)
>  #define D40_IS_DST(dir) (((dir == STEDMA40_MEM_TO_PERIPH) || \
> -- 
> 1.7.10.4
> 
