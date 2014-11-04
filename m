Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaKDCMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:12:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaKDCMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:12:13 -0500
Date: Mon, 3 Nov 2014 18:11:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Feng Kan <fkan@apm.com>
Cc: patches@apm.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        mathias.nyman@intel.com, Bao Truong <btruong@apm.com>
Subject: Re: [PATCH] usb:host:xhci-plat: 64-bit dma addressing support
Message-ID: <20141104021103.GA23756@kroah.com>
References: <1415066368-3829-1-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415066368-3829-1-git-send-email-fkan@apm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 05:59:28PM -0800, Feng Kan wrote:
> Use dma_addr_t to support 64-bit plaforms, which access beyond 32 bit
> address range.
> 
> Signed-off-by: Bao Truong <btruong@apm.com>
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>  drivers/usb/host/xhci-plat.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 01d1862..8cf83f0 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -97,13 +97,14 @@ static int xhci_plat_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Initialize dma_mask and coherent_dma_mask to 32-bits */
> -	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> +	ret = dma_set_coherent_mask(&pdev->dev,
> +					DMA_BIT_MASK(sizeof(dma_addr_t)*8));

Is the comment still correct now?

