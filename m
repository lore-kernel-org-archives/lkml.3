Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3DVKXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:23:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:15153 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3DVKXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:23:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="322855758"
Date: Mon, 22 Apr 2013 15:22:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 16/32] dmaengine: ste_dma40: Remove unnecessary call to
 d40_phy_cfg()
Message-ID: <20130422095218.GN24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-17-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-17-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:11:58AM +0100, Lee Jones wrote:
> All configuration left in d40_phy_cfg() is runtime configurable and
> there is already a call into it from d40_runtime_config(), so let's
> rely on that.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
> ---
>  drivers/dma/ste_dma40.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 178a03c..1c570b6 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -2437,9 +2437,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
>  	}
>  
>  	pm_runtime_get_sync(d40c->base->dev);
> -	/* Fill in basic CFG register values */
> -	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
> -		    &d40c->dst_def_cfg, chan_is_logical(d40c));
>  
>  	d40_set_prio_realtime(d40c);
>  
> -- 
> 1.7.10.4
> 
