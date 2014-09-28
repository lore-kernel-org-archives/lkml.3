Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaI1QhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:37:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:36647 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbaI1QhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:37:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,615,1406617200"; 
   d="scan'208";a="580292089"
Date: Sun, 28 Sep 2014 21:37:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de
Subject: Re: [PATCH 2/9] dmaengine: Make channel allocation callbacks
 optional
Message-ID: <20140928160757.GJ1638@intel.com>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
 <1411808085-27792-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411808085-27792-3-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 10:54:38AM +0200, Maxime Ripard wrote:
> Nowadays, some drivers don't have anything in there channel allocation
> callbacks anymore.
> 
> Remove the BUG_ON if those callbacks aren't implemented, in order to allow
> drivers to not implement them.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/dma/dmaengine.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index d5d30ed863ce..cfcb181b1184 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -817,8 +817,6 @@ int dma_async_device_register(struct dma_device *device)
>  	BUG_ON(dma_has_cap(DMA_INTERLEAVE, device->cap_mask) &&
>  		!device->device_prep_interleaved_dma);
>  
> -	BUG_ON(!device->device_alloc_chan_resources);
> -	BUG_ON(!device->device_free_chan_resources);
Dont think we have drivers without free. IIRC cppi one might be only
instance

-- 
~Vinod
>  	BUG_ON(!device->device_tx_status);
>  	BUG_ON(!device->device_issue_pending);
>  	BUG_ON(!device->dev);
> -- 
> 2.1.0
> 

-- 
