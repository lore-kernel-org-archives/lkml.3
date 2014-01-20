Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaATFct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 00:32:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:28268 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaATFcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 00:32:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="469324412"
Date: Mon, 20 Jan 2014 10:01:04 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Florian Meier <florian.meier@koalo.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] dmaengine: Add DMA_PRIVATE to BCM2835 driver
Message-ID: <20140120043103.GB26823@intel.com>
References: <52D96315.9090604@koalo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D96315.9090604@koalo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 06:06:29PM +0100, Florian Meier wrote:
> Without DMA_PRIVATE the driver is not able to allocate more than one channel.
> Since it uses dma_get_any_slave_channel that calls private_candidate,
> the second allocation fails at
> /* some channels are already publicly allocated */
> Maybe it should be fixed in the core, but at least this fixes the bug.
> 
> Signed-off-by: Florian Meier <florian.meier@koalo.de>
> ---
>  drivers/dma/bcm2835-dma.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
> index 6ae0708..a036021 100644
> --- a/drivers/dma/bcm2835-dma.c
> +++ b/drivers/dma/bcm2835-dma.c
> @@ -611,6 +611,7 @@ static int bcm2835_dma_probe(struct platform_device *pdev)
>  	od->base = base;
>  
>  	dma_cap_set(DMA_SLAVE, od->ddev.cap_mask);
> +	dma_cap_set(DMA_PRIVATE, od->ddev.cap_mask);
>  	dma_cap_set(DMA_CYCLIC, od->ddev.cap_mask);
>  	od->ddev.device_alloc_chan_resources = bcm2835_dma_alloc_chan_resources;
>  	od->ddev.device_free_chan_resources = bcm2835_dma_free_chan_resources;

Applied, thanks

--
~Vinod
