Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3HVLCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:02:49 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:60534 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab3HVLCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:02:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jingoo Han <jg1.han@samsung.com>, "'Simon Horman'" <horms@verge.net.au>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: sh-pfc: remove unnecessary platform_set_drvdata()
Date: Thu, 22 Aug 2013 13:04:02 +0200
Message-ID: <1510830.GiieqIPrhn@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <001b01ce9edb$70236f80$506a4e80$%han@samsung.com>
References: <001b01ce9edb$70236f80$506a4e80$%han@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

Thank you for the patch.

On Thursday 22 August 2013 11:00:55 Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Linus, can you take this for v3.12 ? If it's too late I'll take it in my tree 
and will include it in the v3.13 pull request.

> ---
>  drivers/pinctrl/sh-pfc/core.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/sh-pfc/core.c b/drivers/pinctrl/sh-pfc/core.c
> index 9e66614..738f14f 100644
> --- a/drivers/pinctrl/sh-pfc/core.c
> +++ b/drivers/pinctrl/sh-pfc/core.c
> @@ -539,8 +539,6 @@ static int sh_pfc_remove(struct platform_device *pdev)
>  	if (pfc->info->ops && pfc->info->ops->exit)
>  		pfc->info->ops->exit(pfc);
> 
> -	platform_set_drvdata(pdev, NULL);
> -
>  	return 0;
>  }
-- 
Regards,

Laurent Pinchart

