Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab3EPFt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:49:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:58291 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab3EPFtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:49:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="334897310"
Date: Thu, 16 May 2013 10:43:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au, arnd@arndb.de,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 33/39] dmaengine: ste_dma40_ll: Use the BIT macro to
 replace ugly '(1 << x)'s
Message-ID: <20130516051357.GF27639@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-34-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368611522-9984-34-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:51:56AM +0100, Lee Jones wrote:
> The aim is to make the code that little more readable.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Vinod Koul <vinod.koul@intel.com>

Hopefully all the BIT conversion in the driver are done in this

--
~Vinod
> ---
>  drivers/dma/ste_dma40_ll.c |   44 ++++++++++++++++++++++----------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
> index 121c0ce..5ddd724 100644
> --- a/drivers/dma/ste_dma40_ll.c
> +++ b/drivers/dma/ste_dma40_ll.c
> @@ -20,28 +20,28 @@ void d40_log_cfg(struct stedma40_chan_cfg *cfg,
>  	/* src is mem? -> increase address pos */
>  	if (cfg->dir ==  DMA_MEM_TO_DEV ||
>  	    cfg->dir ==  DMA_MEM_TO_MEM)
> -		l1 |= 1 << D40_MEM_LCSP1_SCFG_INCR_POS;
> +		l1 |= BIT(D40_MEM_LCSP1_SCFG_INCR_POS);
>  
>  	/* dst is mem? -> increase address pos */
>  	if (cfg->dir ==  DMA_DEV_TO_MEM ||
>  	    cfg->dir ==  DMA_MEM_TO_MEM)
> -		l3 |= 1 << D40_MEM_LCSP3_DCFG_INCR_POS;
> +		l3 |= BIT(D40_MEM_LCSP3_DCFG_INCR_POS);
>  
>  	/* src is hw? -> master port 1 */
>  	if (cfg->dir ==  DMA_DEV_TO_MEM ||
>  	    cfg->dir ==  DMA_DEV_TO_DEV)
> -		l1 |= 1 << D40_MEM_LCSP1_SCFG_MST_POS;
> +		l1 |= BIT(D40_MEM_LCSP1_SCFG_MST_POS);
>  
>  	/* dst is hw? -> master port 1 */
>  	if (cfg->dir ==  DMA_MEM_TO_DEV ||
>  	    cfg->dir ==  DMA_DEV_TO_DEV)
> -		l3 |= 1 << D40_MEM_LCSP3_DCFG_MST_POS;
> +		l3 |= BIT(D40_MEM_LCSP3_DCFG_MST_POS);
>  
> -	l3 |= 1 << D40_MEM_LCSP3_DCFG_EIM_POS;
> +	l3 |= BIT(D40_MEM_LCSP3_DCFG_EIM_POS);
>  	l3 |= cfg->dst_info.psize << D40_MEM_LCSP3_DCFG_PSIZE_POS;
>  	l3 |= cfg->dst_info.data_width << D40_MEM_LCSP3_DCFG_ESIZE_POS;
>  
> -	l1 |= 1 << D40_MEM_LCSP1_SCFG_EIM_POS;
> +	l1 |= BIT(D40_MEM_LCSP1_SCFG_EIM_POS);
>  	l1 |= cfg->src_info.psize << D40_MEM_LCSP1_SCFG_PSIZE_POS;
>  	l1 |= cfg->src_info.data_width << D40_MEM_LCSP1_SCFG_ESIZE_POS;
>  
> @@ -58,39 +58,39 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg, u32 *src_cfg, u32 *dst_cfg)
>  	if ((cfg->dir == DMA_DEV_TO_MEM) ||
>  	    (cfg->dir == DMA_DEV_TO_DEV)) {
>  		/* Set master port to 1 */
> -		src |= 1 << D40_SREG_CFG_MST_POS;
> +		src |= BIT(D40_SREG_CFG_MST_POS);
>  		src |= D40_TYPE_TO_EVENT(cfg->dev_type);
>  
>  		if (cfg->src_info.flow_ctrl == STEDMA40_NO_FLOW_CTRL)
> -			src |= 1 << D40_SREG_CFG_PHY_TM_POS;
> +			src |= BIT(D40_SREG_CFG_PHY_TM_POS);
>  		else
>  			src |= 3 << D40_SREG_CFG_PHY_TM_POS;
>  	}
>  	if ((cfg->dir == DMA_MEM_TO_DEV) ||
>  	    (cfg->dir == DMA_DEV_TO_DEV)) {
>  		/* Set master port to 1 */
> -		dst |= 1 << D40_SREG_CFG_MST_POS;
> +		dst |= BIT(D40_SREG_CFG_MST_POS);
>  		dst |= D40_TYPE_TO_EVENT(cfg->dev_type);
>  
>  		if (cfg->dst_info.flow_ctrl == STEDMA40_NO_FLOW_CTRL)
> -			dst |= 1 << D40_SREG_CFG_PHY_TM_POS;
> +			dst |= BIT(D40_SREG_CFG_PHY_TM_POS);
>  		else
>  			dst |= 3 << D40_SREG_CFG_PHY_TM_POS;
>  	}
>  	/* Interrupt on end of transfer for destination */
> -	dst |= 1 << D40_SREG_CFG_TIM_POS;
> +	dst |= BIT(D40_SREG_CFG_TIM_POS);
>  
>  	/* Generate interrupt on error */
> -	src |= 1 << D40_SREG_CFG_EIM_POS;
> -	dst |= 1 << D40_SREG_CFG_EIM_POS;
> +	src |= BIT(D40_SREG_CFG_EIM_POS);
> +	dst |= BIT(D40_SREG_CFG_EIM_POS);
>  
>  	/* PSIZE */
>  	if (cfg->src_info.psize != STEDMA40_PSIZE_PHY_1) {
> -		src |= 1 << D40_SREG_CFG_PHY_PEN_POS;
> +		src |= BIT(D40_SREG_CFG_PHY_PEN_POS);
>  		src |= cfg->src_info.psize << D40_SREG_CFG_PSIZE_POS;
>  	}
>  	if (cfg->dst_info.psize != STEDMA40_PSIZE_PHY_1) {
> -		dst |= 1 << D40_SREG_CFG_PHY_PEN_POS;
> +		dst |= BIT(D40_SREG_CFG_PHY_PEN_POS);
>  		dst |= cfg->dst_info.psize << D40_SREG_CFG_PSIZE_POS;
>  	}
>  
> @@ -100,14 +100,14 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg, u32 *src_cfg, u32 *dst_cfg)
>  
>  	/* Set the priority bit to high for the physical channel */
>  	if (cfg->high_priority) {
> -		src |= 1 << D40_SREG_CFG_PRI_POS;
> -		dst |= 1 << D40_SREG_CFG_PRI_POS;
> +		src |= BIT(D40_SREG_CFG_PRI_POS);
> +		dst |= BIT(D40_SREG_CFG_PRI_POS);
>  	}
>  
>  	if (cfg->src_info.big_endian)
> -		src |= 1 << D40_SREG_CFG_LBE_POS;
> +		src |= BIT(D40_SREG_CFG_LBE_POS);
>  	if (cfg->dst_info.big_endian)
> -		dst |= 1 << D40_SREG_CFG_LBE_POS;
> +		dst |= BIT(D40_SREG_CFG_LBE_POS);
>  
>  	*src_cfg = src;
>  	*dst_cfg = dst;
> @@ -157,15 +157,15 @@ static int d40_phy_fill_lli(struct d40_phy_lli *lli,
>  
>  	/* If this scatter list entry is the last one, no next link */
>  	if (next_lli == 0)
> -		lli->reg_lnk = 0x1 << D40_SREG_LNK_PHY_TCP_POS;
> +		lli->reg_lnk = BIT(D40_SREG_LNK_PHY_TCP_POS);
>  	else
>  		lli->reg_lnk = next_lli;
>  
>  	/* Set/clear interrupt generation on this link item.*/
>  	if (term_int)
> -		lli->reg_cfg |= 0x1 << D40_SREG_CFG_TIM_POS;
> +		lli->reg_cfg |= BIT(D40_SREG_CFG_TIM_POS);
>  	else
> -		lli->reg_cfg &= ~(0x1 << D40_SREG_CFG_TIM_POS);
> +		lli->reg_cfg &= ~BIT(D40_SREG_CFG_TIM_POS);
>  
>  	/* Post link */
>  	lli->reg_lnk |= 0 << D40_SREG_LNK_PHY_PRE_POS;
> -- 
> 1.7.10.4
> 
