Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3EUCjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:39:36 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:20905
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804Ab3EUCje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:39:34 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 21 May 2013 10:39:47 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
CC: <gregkh@linuxfoundation.org>, <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] imx-drm: imx-tve: Check the return value of
 'regulator_enable()'
Message-ID: <20130521023945.GB3080@S2101-09.ap.freescale.net>
References: <1369058151-24986-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1369058151-24986-1-git-send-email-fabio.estevam@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 10:55:49AM -0300, Fabio Estevam wrote:
> Check the return value of 'regulator_enable()' to fix the following build error:
> 
s/error/warning

It may be helpful to mention that the warning shows up since commit
c8801a8 (regulator: core: Mark all get and enable calls as
__must_check).

Other than these, 

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> drivers/staging/imx-drm/imx-tve.c: In function 'imx_tve_probe':
> drivers/staging/imx-drm/imx-tve.c:671:19: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/staging/imx-drm/imx-tve.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
> index a6efa8f6..ce65ad3 100644
> --- a/drivers/staging/imx-drm/imx-tve.c
> +++ b/drivers/staging/imx-drm/imx-tve.c
> @@ -668,7 +668,9 @@ static int imx_tve_probe(struct platform_device *pdev)
>  	tve->dac_reg = devm_regulator_get(&pdev->dev, "dac");
>  	if (!IS_ERR(tve->dac_reg)) {
>  		regulator_set_voltage(tve->dac_reg, 2750000, 2750000);
> -		regulator_enable(tve->dac_reg);
> +		ret = regulator_enable(tve->dac_reg);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	tve->clk = devm_clk_get(&pdev->dev, "tve");
> -- 
> 1.8.1.2
> 
> 

