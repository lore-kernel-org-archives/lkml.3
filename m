Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaCLRhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:37:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:38251 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaCLRhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:37:07 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19lRQO9ERFI2qZ+8phx84lZ
Date: Wed, 12 Mar 2014 10:37:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] dma: omap-dma: Implement device_slave_caps callback
Message-ID: <20140312173700.GA1996@atomide.com>
References: <1394199404-7870-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394199404-7870-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [140307 05:39]:
> With the callback implemented omap-dma can provide information to client
> drivers regarding to supported address widths, directions, residue
> granularity, etc.

This may need some testing against linux next with Russell's
omap-dma.c clean-up series merged there. Peter, care to check
if this patch is still valid against linux next?

Regards,

Tony
 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/dma/omap-dma.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
> index 64ceca2920b8..b19f04f4390b 100644
> --- a/drivers/dma/omap-dma.c
> +++ b/drivers/dma/omap-dma.c
> @@ -1088,6 +1088,23 @@ static void omap_dma_free(struct omap_dmadev *od)
>  	}
>  }
>  
> +#define OMAP_DMA_BUSWIDTHS	(BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) | \
> +				 BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) | \
> +				 BIT(DMA_SLAVE_BUSWIDTH_4_BYTES))
> +
> +static int omap_dma_device_slave_caps(struct dma_chan *dchan,
> +				      struct dma_slave_caps *caps)
> +{
> +	caps->src_addr_widths = OMAP_DMA_BUSWIDTHS;
> +	caps->dstn_addr_widths = OMAP_DMA_BUSWIDTHS;
> +	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
> +	caps->cmd_pause = true;
> +	caps->cmd_terminate = true;
> +	caps->residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
> +
> +	return 0;
> +}
> +
>  static int omap_dma_probe(struct platform_device *pdev)
>  {
>  	struct omap_dmadev *od;
> @@ -1118,6 +1135,7 @@ static int omap_dma_probe(struct platform_device *pdev)
>  	od->ddev.device_prep_slave_sg = omap_dma_prep_slave_sg;
>  	od->ddev.device_prep_dma_cyclic = omap_dma_prep_dma_cyclic;
>  	od->ddev.device_control = omap_dma_control;
> +	od->ddev.device_slave_caps = omap_dma_device_slave_caps;
>  	od->ddev.dev = &pdev->dev;
>  	INIT_LIST_HEAD(&od->ddev.channels);
>  	INIT_LIST_HEAD(&od->pending);
> -- 
> 1.9.0
> 
