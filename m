Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3GVIKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:10:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54303 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab3GVIKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:10:34 -0400
Message-ID: <1374480595.4355.5.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH] imx-drm: imx-tve: Remove unneeded check for
 platform_get_resource()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Date: Mon, 22 Jul 2013 10:09:55 +0200
In-Reply-To: <1374455982-18055-1-git-send-email-festevam@gmail.com>
References: <1374455982-18055-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 21.07.2013, 22:19 -0300 schrieb Fabio Estevam:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> As devm_ioremap_resource() is used on probe, there is no need to explicitly 
> check the return value from platform_get_resource(), as this is something that
> devm_ioremap_resource() takes care by itself.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/staging/imx-drm/imx-tve.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
> index a56797d..8232cea 100644
> --- a/drivers/staging/imx-drm/imx-tve.c
> +++ b/drivers/staging/imx-drm/imx-tve.c
> @@ -623,11 +623,6 @@ static int imx_tve_probe(struct platform_device *pdev)
>  	}
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "failed to get memory region\n");
> -		return -ENOENT;
> -	}
> -
>  	base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(base))
>  		return PTR_ERR(base);

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

