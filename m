Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161334Ab3DEGhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:37:46 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:32855 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3DEGho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:37:44 -0400
X-Auth-Info: oFKiORtWmCTIlZ+VRZ00wfw6022hAXeDSYJr+mt2mSg=
From: Marek Vasut <marex@denx.de>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH] mmc: mxs-mmc: Add support for non-removable cards
Date: Fri, 5 Apr 2013 08:37:39 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: cjb@laptop.org, shawn.guo@linaro.org, fabio.estevam@freescale.com,
        otavio@ossystems.com.br, broonie@opensource.wolfsonmicro.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1365135518-31549-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1365135518-31549-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304050837.39520.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alexandre Pereira da Silva,

> Some boards and card slots doesn't have card detect feature available.
> In that case allow to mark the cards as non-removable, via devicetree.
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Looks good,

Reviewed-by: Marek Vasut <marex@denx.de>

btw. did you know you can let git send-email automatically handle CC for you so 
you don't have to type it into the command line by simply sticking

Cc: Us Er <e@ma.il>

in the commit message? Preferably under the SoB line.

> ---
>  drivers/mmc/host/mxs-mmc.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> index 4efe302..7d2cd74 100644
> --- a/drivers/mmc/host/mxs-mmc.c
> +++ b/drivers/mmc/host/mxs-mmc.c
> @@ -95,6 +95,9 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
>  	struct mxs_mmc_host *host = mmc_priv(mmc);
>  	struct mxs_ssp *ssp = &host->ssp;
> 
> +	if (mmc->caps & MMC_CAP_NONREMOVABLE)
> +		return 1;
> +
>  	return !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
>  		 BM_SSP_STATUS_CARD_DETECT);
>  }
> @@ -691,6 +694,9 @@ static int mxs_mmc_probe(struct platform_device *pdev)
>  	if (flags & OF_GPIO_ACTIVE_LOW)
>  		host->wp_inverted = 1;
> 
> +	if (of_find_property(np, "non-removable", NULL))
> +		mmc->caps |= MMC_CAP_NONREMOVABLE;
> +
>  	mmc->f_min = 400000;
>  	mmc->f_max = 288000000;
>  	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;

Best regards,
Marek Vasut
