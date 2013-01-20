Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3ATNRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 08:17:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:57781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab3ATNRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 08:17:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,500,1355126400"; 
   d="scan'208";a="193141992"
Date: Sun, 20 Jan 2013 04:52:43 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Matt Porter <mporter@ti.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] dmaengine: add dma_get_channel_caps()
Message-ID: <20130120125243.GD23398@intel.com>
References: <1357844826-30746-1-git-send-email-mporter@ti.com>
 <1357844826-30746-2-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357844826-30746-2-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 02:07:04PM -0500, Matt Porter wrote:
> +/* struct dmaengine_chan_caps - expose capability of a channel
> + * Note: each channel can have same or different capabilities
> + *
> + * This primarily classifies capabilities into
> + * a) APIs/ops supported
> + * b) channel physical capabilities
> + *
> + * @cap_mask: api/ops capability (DMA_INTERRUPT and DMA_PRIVATE
> + *	       are invalid api/ops and will never be set)
> + * @seg_nr: maximum number of SG segments supported on a SG/SLAVE
> + *	    channel (0 for no maximum or not a SG/SLAVE channel)
> + * @seg_len: maximum length of SG segments supported on a SG/SLAVE
> + *	     channel (0 for no maximum or not a SG/SLAVE channel)
> + */
> +struct dmaengine_chan_caps {
> +	dma_cap_mask_t cap_mask;
> +	int seg_nr;
> +	int seg_len;
> +};
Now am really unclear why we would need direction as argument.

Also, I would add the channel physical capablities like direction, widths,
lengths etc supported.
 
> +/**
> + * dma_get_channel_caps - flush pending transactions to HW
flush pending... ???

> + * driver does not implement per channel capbilities then
> + * NULL is returned.
> + */
> +static inline struct dmaengine_chan_caps
> +*dma_get_channel_caps(struct dma_chan *chan, enum dma_transfer_direction dir)
you need to add this for when CONFIG_DMA_ENGINE is not defined as well.
> +{
> +	if (chan->device->device_channel_caps)
> +		return chan->device->device_channel_caps(chan, dir);
> +	return NULL;
> +}
> +
>  enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
>  #ifdef CONFIG_DMA_ENGINE
>  enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
--
~Vinod
