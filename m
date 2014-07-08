Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaGHKNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:13:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46468 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaGHKNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:13:31 -0400
Date: Tue, 8 Jul 2014 12:13:41 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 06/22] i810: Use pci_zalloc_consistent
Message-ID: <20140708101341.GV17271@phenom.ffwll.local>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <cover.1403530604.git.joe@perches.com>
 <35ea0a682ee80b86e38172d4a5a7a2ad9ec7d274.1403530604.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35ea0a682ee80b86e38172d4a5a7a2ad9ec7d274.1403530604.git.joe@perches.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:41:34AM -0700, Joe Perches wrote:
> Remove the now unnecessary memset too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Since I seem to be the last idiot to have touched i810.ko:
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/gpu/drm/i810/i810_dma.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dma.c
> index e88bac1..bae897d 100644
> --- a/drivers/gpu/drm/i810/i810_dma.c
> +++ b/drivers/gpu/drm/i810/i810_dma.c
> @@ -393,15 +393,14 @@ static int i810_dma_initialize(struct drm_device *dev,
>  
>  	/* Program Hardware Status Page */
>  	dev_priv->hw_status_page =
> -	    pci_alloc_consistent(dev->pdev, PAGE_SIZE,
> -				 &dev_priv->dma_status_page);
> +		pci_zalloc_consistent(dev->pdev, PAGE_SIZE,
> +				      &dev_priv->dma_status_page);
>  	if (!dev_priv->hw_status_page) {
>  		dev->dev_private = (void *)dev_priv;
>  		i810_dma_cleanup(dev);
>  		DRM_ERROR("Can not allocate hardware status page\n");
>  		return -ENOMEM;
>  	}
> -	memset(dev_priv->hw_status_page, 0, PAGE_SIZE);
>  	DRM_DEBUG("hw status page @ %p\n", dev_priv->hw_status_page);
>  
>  	I810_WRITE(0x02080, dev_priv->dma_status_page);
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
