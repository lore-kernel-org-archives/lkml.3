Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab3LRR1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:27:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:60563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3LRR1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:27:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,508,1384329600"; 
   d="scan'208";a="426737424"
Date: Wed, 18 Dec 2013 21:58:52 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dma: pl08x: allow zero slave channels
Message-ID: <20131218162852.GM16227@intel.com>
References: <1386976583-31395-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386976583-31395-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 12:16:23AM +0100, Linus Walleij wrote:
> It might happen that a platform wants to use its DMA engine for
> memcpy only, and then we have zero slave channels to initialize,
> so allow the slave initialization to return zero.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied, this one

--
~Vinod
> ---
>  drivers/dma/amba-pl08x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index ec4ee5c1fe9d..f68f1c1d560b 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -2167,7 +2167,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
>  	/* Register slave channels */
>  	ret = pl08x_dma_init_virtual_channels(pl08x, &pl08x->slave,
>  			pl08x->pd->num_slave_channels, true);
> -	if (ret <= 0) {
> +	if (ret < 0) {
>  		dev_warn(&pl08x->adev->dev,
>  			"%s failed to enumerate slave channels - %d\n",
>  				__func__, ret);
> -- 
> 1.8.3.1
> 

-- 
