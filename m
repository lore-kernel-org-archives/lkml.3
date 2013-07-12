Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab3GLTtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:49:24 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:59440 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab3GLTtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:49:21 -0400
Message-ID: <51E05DBD.4070600@cogentembedded.com>
Date: Fri, 12 Jul 2013 23:49:17 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH 6/8] DMA: shdma: pass SoC-specific configuration to the
 driver via OF matching
References: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de> <1373636638-18496-7-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1373636638-18496-7-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/12/2013 05:43 PM, Guennadi Liakhovetski wrote:

> Similar to the non-DT case, this patch passes SoC-specific configuration
> to the driver via device ID matching, instead of platform data.

> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
[...]

> diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
> index a6d53fa..b095d74 100644
> --- a/drivers/dma/sh/shdmac.c
> +++ b/drivers/dma/sh/shdmac.c
[...]
> @@ -665,6 +666,14 @@ static const struct shdma_ops sh_dmae_shdma_ops = {
>   	.get_partial = sh_dmae_get_partial,
>   };
>
> +static const struct of_device_id sh_dmae_of_match[] = {
> +	{.compatible = "renesas,shdma",},
> +	{.compatible = "renesas,shdma-r8a73a4", .data = r8a73a4_shdma_devid,},
> +	{.compatible = "renesas,shdma-r8a7740", .data = r8a7740_shdma_devid,},

    Previously used style assumed spaced after { and before }. Indeed, 
that would be more consistent with the following line.

> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
> +
>   static int sh_dmae_probe(struct platform_device *pdev)
>   {
>   	struct sh_dmae_pdata *pdata;
[...]
> @@ -915,12 +928,6 @@ static int sh_dmae_remove(struct platform_device *pdev)
>   	return 0;
>   }
>
> -static const struct of_device_id sh_dmae_of_match[] = {
> -	{ .compatible = "renesas,shdma", },
> -	{ }
> -};
> -MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
> -

WBR, Sergei


