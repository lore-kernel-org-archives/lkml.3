Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab3EBCo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 22:44:59 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:52245
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832Ab3EBCo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 22:44:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 2 May 2013 10:44:44 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: mxs: Use set and clear capabilities of the gpio
 controller
Message-ID: <20130502024443.GE3442@S2101-09.ap.freescale.net>
References: <1367244438-5322-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1367244438-5322-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 04:07:18PM +0200, Maxime Ripard wrote:
> The current driver doesn't use the set and clear registers found on the
> mxs gpio controller.
> 
> This leads the generic gpio controller to be using some internal value
> to avoid looking up the value stored in the registers, making it behave
> pretty much like a cache.
> 
> This raises some coherency problem when a gpio is not modified by the
> gpio controller, while it can easily be fixed by using the set and clear
> registers.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/gpio/gpio-mxs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
> index 25000b0..f8e6af2 100644
> --- a/drivers/gpio/gpio-mxs.c
> +++ b/drivers/gpio/gpio-mxs.c
> @@ -326,7 +326,8 @@ static int mxs_gpio_probe(struct platform_device *pdev)
>  
>  	err = bgpio_init(&port->bgc, &pdev->dev, 4,
>  			 port->base + PINCTRL_DIN(port),
> -			 port->base + PINCTRL_DOUT(port), NULL,
> +			 port->base + PINCTRL_DOUT(port) + MXS_SET,
> +			 port->base + PINCTRL_DOUT(port) + MXS_CLR,
>  			 port->base + PINCTRL_DOE(port), NULL, 0);
>  	if (err)
>  		goto out_irqdesc_free;
> -- 
> 1.8.1.2
> 

