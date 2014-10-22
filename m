Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027AbaJVVGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:06:52 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:43155 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbaJVVGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:06:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 11/59] dmaengine: Move slave caps to dma_device
Date: Thu, 23 Oct 2014 00:06:47 +0300
Message-ID: <2410712.ymOohptKuc@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413992653-21963-12-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com> <1413992653-21963-12-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for the patch.

On Wednesday 22 October 2014 17:43:25 Maxime Ripard wrote:
> The previous code was relying on the fact that the slave_caps were to be
> defined on a per channel basis.
> 
> However, this proved to be a bit overkill, since every driver filling these
> so far were hardcoding it, disregarding which channel was actually given.
> 
> Add these capabilities to the dma_device structure, so that drivers can just
> provide them at probe time, and be done with it.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/linux/dmaengine.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 6b74d9d8977e..98f8163dfbac 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -593,6 +593,14 @@ struct dma_tx_state {
>   * @fill_align: alignment shift for memset operations
>   * @dev_id: unique device ID
>   * @dev: struct device reference for dma mapping api
> + * @src_addr_widths: bit mask of src addr widths the device supports
> + * @dst_addr_widths: bit mask of dst addr widths the device supports
> + * @directions: bit mask of slave direction the device supports since
> + * 	the enum dma_transfer_direction is not defined as bits for
> + * 	each type of direction, the dma controller should fill (1 <<
> + * 	<TYPE>) and same should be checked by controller as well
> + * @residue_granularity: granularity of the transfer residue reported
> + *	by tx_status
>   * @device_alloc_chan_resources: allocate resources and return the
>   *	number of allocated descriptors
>   * @device_free_chan_resources: release DMA channel's resources
> @@ -643,6 +651,10 @@ struct dma_device {
>  	struct device *dev;
> 
>  	bool generic_slave_caps;
> +	u32 src_addr_widths;
> +	u32 dst_addr_widths;
> +	u32 directions;
> +	enum dma_residue_granularity residue_granularity;
> 
>  	int (*device_alloc_chan_resources)(struct dma_chan *chan);
>  	void (*device_free_chan_resources)(struct dma_chan *chan);
> @@ -807,6 +819,11 @@ static inline int dma_get_slave_caps(struct dma_chan
> *chan, struct dma_slave_cap if (device->generic_slave_caps)
>  		return -ENXIO;
> 
> +	caps->src_addr_widths = device->src_addr_widths;
> +	caps->dst_addr_widths = device->dst_addr_widths;
> +	caps->directions = device->directions;
> +	caps->residue_granularity = device->residue_granularity;
> +
>  	caps->cmd_pause = !!device->device_pause;
>  	caps->cmd_terminate = !!device->device_terminate_all;

-- 
Regards,

Laurent Pinchart

