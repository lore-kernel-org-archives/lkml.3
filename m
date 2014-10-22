Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbaJVVGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:06:17 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:43147 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbaJVVGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:06:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 09/59] dmaengine: Remove the need to declare device_control
Date: Thu, 23 Oct 2014 00:06:13 +0300
Message-ID: <1564848.hByj3lEMqB@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413992653-21963-10-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com> <1413992653-21963-10-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for the patch.

On Wednesday 22 October 2014 17:43:23 Maxime Ripard wrote:
> In order to migrate the drivers without triggering a BUG_ON for the
> converted drivers, which would cause bisectability issues, we need to
> remove that check before removing the device_control function entirely.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/dma/dmaengine.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 9b2cd74b8f2e..98e9431f85ec 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -820,8 +820,6 @@ int dma_async_device_register(struct dma_device *device)
> !device->device_prep_dma_sg);
>  	BUG_ON(dma_has_cap(DMA_CYCLIC, device->cap_mask) &&
>  		!device->device_prep_dma_cyclic);
> -	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
> -		!device->device_control);
>  	BUG_ON(dma_has_cap(DMA_INTERLEAVE, device->cap_mask) &&
>  		!device->device_prep_interleaved_dma);

-- 
Regards,

Laurent Pinchart

