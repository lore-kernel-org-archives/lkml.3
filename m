Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab3EFLxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 07:53:07 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:30485 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3EFLxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 07:53:04 -0400
Message-ID: <518799A0.1000900@atmel.com>
Date: Mon, 6 May 2013 13:53:04 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>, "'Vinod Koul'" <vinod.koul@intel.com>
CC: "'Dan Williams'" <djbw@fb.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dma: at_hdmac: remove unnecessary platform_set_drvdata()
References: <002701ce4a0d$47c62000$d7526000$@samsung.com>
In-Reply-To: <002701ce4a0d$47c62000$d7526000$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 05:53, Jingoo Han :
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/dma/at_hdmac.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index e923cda..c093ab7 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1472,7 +1472,6 @@ err_of_dma_controller_register:
>   	dma_async_device_unregister(&atdma->dma_common);
>   	dma_pool_destroy(atdma->dma_desc_pool);
>   err_pool_create:
> -	platform_set_drvdata(pdev, NULL);
>   	free_irq(platform_get_irq(pdev, 0), atdma);
>   err_irq:
>   	clk_disable(atdma->clk);
> @@ -1497,7 +1496,6 @@ static int at_dma_remove(struct platform_device *pdev)
>   	dma_async_device_unregister(&atdma->dma_common);
>
>   	dma_pool_destroy(atdma->dma_desc_pool);
> -	platform_set_drvdata(pdev, NULL);
>   	free_irq(platform_get_irq(pdev, 0), atdma);
>
>   	list_for_each_entry_safe(chan, _chan, &atdma->dma_common.channels,
>


-- 
Nicolas Ferre
