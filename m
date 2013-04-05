Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765145Ab3DEJON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:14:13 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:25340
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341Ab3DEJOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:14:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 5 Apr 2013 17:13:55 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: <cjb@laptop.org>, <marex@denx.de>, <fabio.estevam@freescale.com>,
        <otavio@ossystems.com.br>, <broonie@opensource.wolfsonmicro.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: mxs-mmc: Add support for non-removable cards
Message-ID: <20130405091352.GC2667@S2101-09.ap.freescale.net>
References: <1365135518-31549-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1365135518-31549-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 01:18:38AM -0300, Alexandre Pereira da Silva wrote:
> Some boards and card slots doesn't have card detect feature available.
> In that case allow to mark the cards as non-removable, via devicetree.
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Marc already sent a similar patch[1] for that.

Shawn

[1] http://thread.gmane.org/gmane.linux.kernel.mmc/19823/focus=19825

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
> -- 
> 1.7.10
> 

