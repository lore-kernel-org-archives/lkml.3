Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab3EFIsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:48:24 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:9648 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab3EFIsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:48:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 6 May 2013 16:48:30 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Linus Walleij'" <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>,
        "'Fabio Estevam'" <fabio.estevam@freescale.com>
Subject: Re: [PATCH 2/4] pinctrl: mxs: remove unnecessary
 platform_set_drvdata()
Message-ID: <20130506084828.GH1749@S2101-09.ap.freescale.net>
References: <001f01ce4a0b$b21c5520$1654ff60$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <001f01ce4a0b$b21c5520$1654ff60$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 12:42:13PM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/pinctrl/pinctrl-mxs.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
> index b45c4eb..f5d5643 100644
> --- a/drivers/pinctrl/pinctrl-mxs.c
> +++ b/drivers/pinctrl/pinctrl-mxs.c
> @@ -515,7 +515,6 @@ int mxs_pinctrl_probe(struct platform_device *pdev,
>  	return 0;
>  
>  err:
> -	platform_set_drvdata(pdev, NULL);
>  	iounmap(d->base);
>  	return ret;
>  }
> @@ -525,7 +524,6 @@ int mxs_pinctrl_remove(struct platform_device *pdev)
>  {
>  	struct mxs_pinctrl_data *d = platform_get_drvdata(pdev);
>  
> -	platform_set_drvdata(pdev, NULL);
>  	pinctrl_unregister(d->pctl);
>  	iounmap(d->base);
>  
> -- 
> 1.7.2.5
> 
> 

