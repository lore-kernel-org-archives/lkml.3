Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab3HWNQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:16:21 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:40189 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab3HWNQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:16:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wei Yongjun <weiyj.lk@gmail.com>, yongjun_wei@trendmicro.com.cn
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] drm/rcar-du: remove redundant dev_err call in rcar_du_lvdsenc_get_resources()
Date: Fri, 23 Aug 2013 15:17:35 +0200
Message-ID: <1469162.DSLg1AW9lg@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAPgLHd-LxjfpSm2U67HVn+eWFqU0P7Ku0XQrNMv0D--8+CoKvg@mail.gmail.com>
References: <CAPgLHd-LxjfpSm2U67HVn+eWFqU0P7Ku0XQrNMv0D--8+CoKvg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 August 2013 21:15:16 Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function devm_ioremap_resource() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check should be
> replaced with IS_ERR(). Also remove the dev_err call to avoid redundant
> error message and check for return value of platform_get_resource_byname().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Dave, could you please pick the patch up ?

> ---
> v1 -> v2; remove return value check of platform_get_resource_byname()
> ---
>  drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
> b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c index a0f6a17..fe1f6f5 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
> @@ -144,18 +144,9 @@ static int rcar_du_lvdsenc_get_resources(struct
> rcar_du_lvdsenc *lvds, sprintf(name, "lvds.%u", lvds->index);
> 
>  	mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
> -	if (mem == NULL) {
> -		dev_err(&pdev->dev, "failed to get memory resource for %s\n",
> -			name);
> -		return -EINVAL;
> -	}
> -
>  	lvds->mmio = devm_ioremap_resource(&pdev->dev, mem);
> -	if (lvds->mmio == NULL) {
> -		dev_err(&pdev->dev, "failed to remap memory resource for %s\n",
> -			name);
> -		return -ENOMEM;
> -	}
> +	if (IS_ERR(lvds->mmio))
> +		return PTR_ERR(lvds->mmio);
> 
>  	lvds->clock = devm_clk_get(&pdev->dev, name);
>  	if (IS_ERR(lvds->clock)) {

-- 
Regards,

Laurent Pinchart

