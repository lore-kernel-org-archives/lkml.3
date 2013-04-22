Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab3DVKKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:10:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:61708 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab3DVKKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:10:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="298892734"
Date: Mon, 22 Apr 2013 15:08:44 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 22/32] dmaengine: ste_dma40: Allocate plat_data on
 declaration
Message-ID: <20130422093844.GG24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-23-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-23-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:12:04AM +0100, Lee Jones wrote:
> It's the way that most other drivers do it.
> 
> Very trivial clean-up which reduces line count and simplifies code.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Vinod Koul <vnod.koul@intel.com>

--
~Vinod
> ---
>  drivers/dma/ste_dma40.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 805049c..6f9f801 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -3119,7 +3119,7 @@ static int __init d40_phy_res_init(struct d40_base *base)
>  
>  static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
>  {
> -	struct stedma40_platform_data *plat_data;
> +	struct stedma40_platform_data *plat_data = pdev->dev.platform_data;
>  	struct clk *clk = NULL;
>  	void __iomem *virtbase = NULL;
>  	struct resource *res = NULL;
> @@ -3190,8 +3190,6 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
>  		goto failure;
>  	}
>  
> -	plat_data = pdev->dev.platform_data;
> -
>  	/* The number of physical channels on this HW */
>  	if (plat_data->num_of_phy_chans)
>  		num_phy_chans = plat_data->num_of_phy_chans;
> -- 
> 1.7.10.4
> 
