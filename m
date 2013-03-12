Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab3CLIdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:33:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42281 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127Ab3CLIdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:33:20 -0400
Message-ID: <513EE819.6040204@ti.com>
Date: Tue, 12 Mar 2013 09:32:25 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130301 Thunderbird/17.0.3
MIME-Version: 1.0
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
CC: <linux-omap@vger.kernel.org>, <jarkko.nikula@bitmer.com>,
        <lgirdwood@gmail.com>, <broonie@opensource.wolfsonmicro.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] omap: convert to devm_ioremap_resource()
References: <1363017537-11602-1-git-send-email-silviupopescu1990@gmail.com>
In-Reply-To: <1363017537-11602-1-git-send-email-silviupopescu1990@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 04:58 PM, Silviu-Mihai Popescu wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
>  sound/soc/omap/omap-dmic.c  |    9 +++------
>  sound/soc/omap/omap-mcpdm.c |    8 +++-----
>  2 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/sound/soc/omap/omap-dmic.c b/sound/soc/omap/omap-dmic.c
> index 77e9e7e..8ebaf11 100644
> --- a/sound/soc/omap/omap-dmic.c
> +++ b/sound/soc/omap/omap-dmic.c
> @@ -493,12 +493,9 @@ static int asoc_dmic_probe(struct platform_device *pdev)
>  		goto err_put_clk;
>  	}
>  
> -	dmic->io_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!dmic->io_base) {
> -		dev_err(&pdev->dev, "cannot remap\n");
> -		ret = -ENOMEM;
> -		goto err_put_clk;
> -	}
> +	dmic->io_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(dmic->io_base))
> +		return PTR_ERR(dmic->io_base);
>  
>  	ret = snd_soc_register_dai(&pdev->dev, &omap_dmic_dai);
>  	if (ret)
> diff --git a/sound/soc/omap/omap-mcpdm.c b/sound/soc/omap/omap-mcpdm.c
> index 079f277..ddfcc18 100644
> --- a/sound/soc/omap/omap-mcpdm.c
> +++ b/sound/soc/omap/omap-mcpdm.c
> @@ -464,11 +464,9 @@ static int asoc_mcpdm_probe(struct platform_device *pdev)
>  	if (res == NULL)
>  		return -ENOMEM;
>  
> -	mcpdm->io_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!mcpdm->io_base) {
> -		dev_err(&pdev->dev, "cannot remap\n");
> -		return -ENOMEM;
> -	}
> +	mcpdm->io_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(mcpdm->io_base))
> +		return PTR_ERR(mcpdm->io_base);
>  
>  	mcpdm->irq = platform_get_irq(pdev, 0);
>  	if (mcpdm->irq < 0)
> 


-- 
Péter
