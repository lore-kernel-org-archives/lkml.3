Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab3FQGLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:11:43 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37464 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3FQGLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:11:40 -0400
Message-ID: <51BEA896.6050206@linaro.org>
Date: Mon, 17 Jun 2013 11:41:34 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: thierry.reding@gmail.com, patches@linaro.org,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 02/15] sudmac: Convert to use devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-3-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1370864113-17895-3-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 05:05 PM, Tushar Behera wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: Vinod Koul <vinod.koul@intel.com>
> CC: Dan Williams <djbw@fb.com>
> ---
>  drivers/dma/sh/sudmac.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
> index e7c94bb..0a81e30 100644
> --- a/drivers/dma/sh/sudmac.c
> +++ b/drivers/dma/sh/sudmac.c
> @@ -360,9 +360,9 @@ static int sudmac_probe(struct platform_device *pdev)
>  
>  	dma_dev = &su_dev->shdma_dev.dma_dev;
>  
> -	su_dev->chan_reg = devm_request_and_ioremap(&pdev->dev, chan);
> -	if (!su_dev->chan_reg)
> -		return err;
> +	su_dev->chan_reg = devm_ioremap_resource(&pdev->dev, chan);
> +	if (IS_ERR(su_dev->chan_reg))
> +		return PTR_ERR(su_dev->chan_reg);
>  
>  	dma_cap_set(DMA_SLAVE, dma_dev->cap_mask);
>  
> 

Ping.

-- 
Tushar Behera
