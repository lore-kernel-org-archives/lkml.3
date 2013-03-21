Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3CUHJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:09:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:15616 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab3CUHI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:08:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="305474907"
Date: Thu, 21 Mar 2013 12:13:53 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Matt Porter <mporter@ti.com>
Cc: Chris Ball <cjb@laptop.org>, Dan Williams <djbw@fb.com>,
        Sekhar Nori <nsekhar@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] dmaengine: add dma_get_slave_sg_limits()
Message-ID: <20130321064353.GF10326@intel.com>
References: <1362599767-11292-1-git-send-email-mporter@ti.com>
 <1362599767-11292-2-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362599767-11292-2-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 02:56:05PM -0500, Matt Porter wrote:
> Add a dmaengine API to retrieve slave SG transfer limits.
> 
> The API is optionally implemented by dmaengine drivers and when
> unimplemented will return a NULL pointer. A client driver using
> this API provides the required dma channel, address width, and
> burst size of the transfer. dma_get_slave_sg_limits() returns an
> SG limits structure with the maximum number and size of SG segments
> that the given channel can handle.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
> +static inline struct dma_slave_sg_limits
> +*dma_get_slave_sg_limits(struct dma_chan *chan,
> +		       enum dma_slave_buswidth addr_width,
> +		       u32 maxburst)
> +{
> +	if (chan->device->device_slave_sg_limits)
> +		return chan->device->device_slave_sg_limits(chan,
> +							  addr_width,
> +							  maxburst);
Hi Matt,

Sorry for delayed reply, this series was sent just before i went for vacation :)

I agree with Lars, that returning pointer maynot be good idea. So this bit needs
work. Also the readblity of above is bad by complying to 80char limit. I would
make it easier to read

--
~Vinod
> +
> +	return NULL;
> +}
> +
>  enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
>  #ifdef CONFIG_DMA_ENGINE
>  enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
> 
