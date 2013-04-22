Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3DVKIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:08:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:2358 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab3DVKIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:08:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="289687985"
Date: Mon, 22 Apr 2013 15:07:25 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 19/32] dmaengine: ste_dma40: Move more setup into the
 configuration routines
Message-ID: <20130422093725.GF24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-20-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-20-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:12:01AM +0100, Lee Jones wrote:
> The less configuration we can do during the allocation of a channel the
> better. As this will mean the likelihood of requiring extra information
> which isn't normally passed through the dma_request_channel() is lessened.
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
>  drivers/dma/ste_dma40.c |   22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 04cc75f..28fe153 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -2440,16 +2440,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
>  
>  	d40_set_prio_realtime(d40c);
>  
> -	if (chan_is_logical(d40c)) {
> -		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
> -			d40c->lcpa = d40c->base->lcpa_base +
> -				d40c->dma_cfg.src_dev_type * D40_LCPA_CHAN_SIZE;
> -		else
> -			d40c->lcpa = d40c->base->lcpa_base +
> -				d40c->dma_cfg.dst_dev_type *
> -				D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
> -	}
> -
>  	if (chan_is_logical(d40c))
>  		d40_log_gim_unmask(&d40c->src_def_cfg, &d40c->dst_def_cfg);
>  
> @@ -2793,9 +2783,17 @@ static int d40_set_runtime_config(struct dma_chan *chan,
>  		return ret;
>  
>  	/* Fill in register values */
> -	if (chan_is_logical(d40c))
> +	if (chan_is_logical(d40c)) {
> +		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
> +			d40c->lcpa = d40c->base->lcpa_base +
> +				d40c->dma_cfg.dev_type * D40_LCPA_CHAN_SIZE;
> +		else
> +			d40c->lcpa = d40c->base->lcpa_base +
> +				d40c->dma_cfg.dev_type *
> +				D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
> +
>  		d40_log_cfg(cfg, &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
> -	else
> +	} else
>  		d40_phy_cfg(cfg, &d40c->src_def_cfg, &d40c->dst_def_cfg);
>  
>  	/* These settings will take precedence later */
> -- 
> 1.7.10.4
> 
