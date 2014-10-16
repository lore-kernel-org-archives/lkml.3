Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaJPKft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:35:49 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:36807 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaJPKfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:35:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 02/53] dmaengine: Make channel allocation callbacks optional
Date: Thu, 16 Oct 2014 13:35:59 +0300
Message-ID: <20788205.g2PTrafGoN@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413454672-27400-3-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com> <1413454672-27400-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for the patch.

On Thursday 16 October 2014 12:17:01 Maxime Ripard wrote:
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
> BUG_ON(dma_has_cap(DMA_INTERLEAVE, device->cap_mask) &&
>  		!device->device_prep_interleaved_dma);
> 
> -	BUG_ON(!device->device_alloc_chan_resources);
> -	BUG_ON(!device->device_free_chan_resources);
>  	BUG_ON(!device->device_tx_status);
>  	BUG_ON(!device->device_issue_pending);
>  	BUG_ON(!device->dev);

This will make dma_chan_get() or dma_chan_put() crash if the alloc or free 
functions are not implemented.

-- 
Regards,

Laurent Pinchart

