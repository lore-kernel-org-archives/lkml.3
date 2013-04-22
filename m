Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab3DVKMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:12:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:22946 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab3DVKMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:12:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="289689737"
Date: Mon, 22 Apr 2013 15:11:25 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 20/32] dmaengine: ste_dma40: Move rev error-check up to
 revision acquisition
Message-ID: <20130422094125.GI24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-21-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-21-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:12:02AM +0100, Lee Jones wrote:
> At the moment we fetch the hardware revision, then do some stuff, then
> check whether the revision is correct and return in error if it's not.
> Well we may as well check it as soon as we know what it is, so let's
> move the check right up underneath where we acquire the version.
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
>  drivers/dma/ste_dma40.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 28fe153..282dd59 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -3185,6 +3185,10 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
>  	 * DB8540v1 has revision 4
>  	 */
>  	rev = AMBA_REV_BITS(pid);
> +	if (rev < 2) {
> +		d40_err(&pdev->dev, "hardware revision: %d is not supported", rev);
> +		goto failure;
> +	}
>  
>  	plat_data = pdev->dev.platform_data;
>  
> @@ -3199,12 +3203,6 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
>  	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with %d physical channels\n",
>  		 rev, res->start, num_phy_chans);
>  
> -	if (rev < 2) {
> -		d40_err(&pdev->dev, "hardware revision: %d is not supported",
> -			rev);
> -		goto failure;
> -	}
> -
>  	base = kzalloc(ALIGN(sizeof(struct d40_base), 4) +
>  		       (num_phy_chans + num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) *
>  		       sizeof(struct d40_chan), GFP_KERNEL);
> -- 
> 1.7.10.4
> 
