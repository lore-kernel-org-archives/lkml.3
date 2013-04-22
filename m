Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab3DVKQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:16:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:22195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab3DVKP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:15:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="298895692"
Date: Mon, 22 Apr 2013 15:14:32 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 14/32] dmaengine: ste_dma40: Remove 'always true'
 checking
Message-ID: <20130422094432.GK24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-15-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-15-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:11:56AM +0100, Lee Jones wrote:
> Before allocating memory for logical channels, the current driver
> checks to see if there are any. Well as the dma40_memcpy_channels[]
> array is always populated, the check is always true. Best to
> remove the check.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Vinod Koul <vnod.koul@intel.com>

The init should be updated to use devm_ versions..

--
~Vinod
> ---
>  drivers/dma/ste_dma40.c |   16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index a39ef74..ec0d6ab 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -3273,17 +3273,11 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
>  	if (!base->lookup_phy_chans)
>  		goto failure;
>  
> -	if (num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) {
> -		/*
> -		 * The max number of logical channels are event lines for all
> -		 * src devices and dst devices
> -		 */
> -		base->lookup_log_chans = kzalloc(num_log_chans *
> -						 sizeof(struct d40_chan *),
> -						 GFP_KERNEL);
> -		if (!base->lookup_log_chans)
> -			goto failure;
> -	}
> +	base->lookup_log_chans = kzalloc(num_log_chans *
> +					 sizeof(struct d40_chan *),
> +					 GFP_KERNEL);
> +	if (!base->lookup_log_chans)
> +		goto failure;
>  
>  	base->reg_val_backup_chan = kmalloc(base->num_phy_chans *
>  					    sizeof(d40_backup_regs_chan),
> -- 
> 1.7.10.4
> 
