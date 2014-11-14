Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950AbaKNAW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:22:59 -0500
Received: from exprod5og126.obsmtp.com ([64.18.0.251]:42174 "HELO
	exprod5og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964856AbaKNAW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:22:56 -0500
MIME-Version: 1.0
In-Reply-To: <1415128009-12182-1-git-send-email-fkan@apm.com>
References: <1415128009-12182-1-git-send-email-fkan@apm.com>
Date: Thu, 13 Nov 2014 16:22:55 -0800
Message-ID: <CAL85gmA=dD7RC2MW5qTsOS+SmcptVuj4PMVo7CKd8v1KbDSz0g@mail.gmail.com>
Subject: Re: [PATCH V2] usb:host:xhci-plat: 64-bit dma addressing support
From: Feng Kan <fkan@apm.com>
To: patches <patches@apm.com>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mathias.nyman@intel.com
Cc: Feng Kan <fkan@apm.com>, Bao Truong <btruong@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just want to ping this again to see if there is any comments, thanks.

On Tue, Nov 4, 2014 at 11:06 AM, Feng Kan <fkan@apm.com> wrote:
> Use dma_addr_t to support 64-bit plaforms, which access beyond the default
> 32 bit address range.
>
> Signed-off-by: Bao Truong <btruong@apm.com>
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>  Changes:
>         V2: fixed GKH's comment regarding not mark up the comment after
>             code change.
>
>  drivers/usb/host/xhci-plat.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 3d78b0c..f75764f 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -96,14 +96,18 @@ static int xhci_plat_probe(struct platform_device *pdev)
>                         return ret;
>         }
>
> -       /* Initialize dma_mask and coherent_dma_mask to 32-bits */
> -       ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> +       /*
> +        * Initialize dma_mask and coherent_dma_mask to valid DMA or bus
> +        * address for the platform.
> +        */
> +       ret = dma_set_coherent_mask(&pdev->dev,
> +                                       DMA_BIT_MASK(sizeof(dma_addr_t)*8));
>         if (ret)
>                 return ret;
>         if (!pdev->dev.dma_mask)
>                 pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
>         else
> -               dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
> +               dma_set_mask(&pdev->dev, DMA_BIT_MASK(sizeof(dma_addr_t)*8));
>
>         hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
>         if (!hcd)
> --
> 1.9.1
>
