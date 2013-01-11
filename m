Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3AKRxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:53:13 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44818 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751775Ab3AKRxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:53:11 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+QpGcbB7r0XsXb+Qr0a1Sr
Date: Fri, 11 Jan 2013 09:52:53 -0800
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <mporter@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 08/14] mmc: omap_hsmmc: convert to
 dma_request_slave_channel_compat()
Message-ID: <20130111175253.GG14149@atomide.com>
References: <1357883330-5364-1-git-send-email-mporter@ti.com>
 <1357883330-5364-9-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357883330-5364-9-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <mporter@ti.com> [130110 21:47]:
> Convert dmaengine channel requests to use
> dma_request_slave_channel_compat(). This supports the DT case of
> platforms requiring channel selection from either the OMAP DMA or
> the EDMA engine. AM33xx only boots from DT and is the only user
> implementing EDMA so in the !DT case we can default to the OMAP DMA
> filter.

Acked-by: Tony Lindgren <tony@atomide.com>

> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index bc58078..e79b12d 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1915,14 +1915,20 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
>  	dma_cap_zero(mask);
>  	dma_cap_set(DMA_SLAVE, mask);
>  
> -	host->rx_chan = dma_request_channel(mask, omap_dma_filter_fn, &rx_req);
> +	host->rx_chan =
> +		dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
> +						 &rx_req, &pdev->dev, "rx");
> +
>  	if (!host->rx_chan) {
>  		dev_err(mmc_dev(host->mmc), "unable to obtain RX DMA engine channel %u\n", rx_req);
>  		ret = -ENXIO;
>  		goto err_irq;
>  	}
>  
> -	host->tx_chan = dma_request_channel(mask, omap_dma_filter_fn, &tx_req);
> +	host->tx_chan =
> +		dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
> +						 &tx_req, &pdev->dev, "tx");
> +
>  	if (!host->tx_chan) {
>  		dev_err(mmc_dev(host->mmc), "unable to obtain TX DMA engine channel %u\n", tx_req);
>  		ret = -ENXIO;
> -- 
> 1.7.9.5
> 
