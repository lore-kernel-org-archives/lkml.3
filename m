Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaLXGzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 01:55:21 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:35984 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751060AbaLXGzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 01:55:19 -0500
Message-ID: <549A6321.3000703@arm.com>
Date: Wed, 24 Dec 2014 06:54:25 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/5] ASoC: dwc: Switch to managed clock resource
References: <cover.1419342218.git.Andrew.Jackson@arm.com> <9af8128918e2da97801f1122ae06336b1bd1012f.1419342218.git.Andrew.Jackson@arm.com>
In-Reply-To: <9af8128918e2da97801f1122ae06336b1bd1012f.1419342218.git.Andrew.Jackson@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/14 13:56, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
> 
> Simplify error handling during probe by using managed clock
> resources.

In my haste to get to the Christmas turkey I missed a clk_put elsewhere.  Will fix and resubmit.

     Andrew

> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
> ---
>  sound/soc/dwc/designware_i2s.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
> index 9573ec7..b3dc535 100644
> --- a/sound/soc/dwc/designware_i2s.c
> +++ b/sound/soc/dwc/designware_i2s.c
> @@ -407,13 +407,13 @@ static int dw_i2s_probe(struct platform_device *pdev)
>  
>  	dev->capability = pdata->cap;
>  	dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
> -	dev->clk = clk_get(&pdev->dev, NULL);
> +	dev->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(dev->clk))
>  		return  PTR_ERR(dev->clk);
>  
>  	ret = clk_prepare_enable(dev->clk);
>  	if (ret < 0)
> -		goto err_clk_put;
> +		return ret;
>  
>  	dev_set_drvdata(&pdev->dev, dev);
>  	ret = snd_soc_register_component(&pdev->dev, &dw_i2s_component,
> @@ -427,8 +427,6 @@ static int dw_i2s_probe(struct platform_device *pdev)
>  
>  err_clk_disable:
>  	clk_disable(dev->clk);
> -err_clk_put:
> -	clk_put(dev->clk);
>  	return ret;
>  }
>  
> 

