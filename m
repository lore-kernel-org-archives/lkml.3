Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaJ1WGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:06:49 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:49034 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaJ1WGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:06:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v4 57/58] dmaengine: Add a warning for drivers not using the generic slave caps retrieval
Date: Wed, 29 Oct 2014 00:06:54 +0200
Message-ID: <3524784.Rq7vyuKpLx@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1414531573-18807-58-git-send-email-maxime.ripard@free-electrons.com>
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com> <1414531573-18807-58-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for the patch.

On Tuesday 28 October 2014 22:26:12 Maxime Ripard wrote:
> For the slave caps retrieval to be really useful, most drivers need to
> implement it.
> 
> Hence, we need to be slightly more aggressive, and trigger a warning at
> registration time for drivers that don't fill their caps infos in order to
> encourage them to implement it.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/dma/dmaengine.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 98e9431f85ec..300c8cd2786c 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -827,6 +827,9 @@ int dma_async_device_register(struct dma_device *device)
> BUG_ON(!device->device_issue_pending);
>  	BUG_ON(!device->dev);
> 
> +	WARN(dma_has_cap(DMA_SLAVE, device->cap_mask) && !device->directions,
> +	     "this driver doesn't support generic slave capabilities
> reporting\n"); +
>  	/* note: this only matters in the
>  	 * CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH=n case
>  	 */

-- 
Regards,

Laurent Pinchart

