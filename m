Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3FXG7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:59:16 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:8133
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440Ab3FXG7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:59:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z1039mz98dI936eI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 24 Jun 2013 14:59:30 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Simon Pearson <spearson@acumalabs.com>
CC: <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 001/001] gpio-mxs: Select faster gpio-generic set methods
Message-ID: <20130624065929.GC26254@S2101-09.ap.freescale.net>
References: <51C497EF.1070108@acumalabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51C497EF.1070108@acumalabs.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 11:14:07AM -0700, Simon Pearson wrote:
> From: Simon Pearson <spearson@acumalabs.com>
> 
> Kernel 3.8.4.  By defining both the set and clear registers,
> the speed of the gpio isimproved. gpio-generic.c, selects the
> bgpio_set_with_clear() which isfaster than the current
> bgpio_set_set().  This has performance implications for all
> bitbang drivers (i2c, spi, etc).  Slow SPI as compared to
> 2.6.35.33 improved by a factor of 10 (80kHz CLK to 800kHz CLK).
> 
> Signed-off-by: Simon Pearson <spearson@acumalabs.com>

The latest mainline kernel already has the improvement made by commit
90dae4e (gpio: mxs: Use set and clear capabilities of the gpio
controller).

Shawn

> 
> ---
> --- a/drivers/gpio/gpio-mxs.c.orig    2013-03-20 13:11:19.000000000 -0700
> +++ b/drivers/gpio/gpio-mxs.c    2013-06-21 10:02:33.000000000 -0700
> @@ -292,7 +292,8 @@ static int mxs_gpio_probe(struct platfor
> 
>      err = bgpio_init(&port->bgc, &pdev->dev, 4,
>               port->base + PINCTRL_DIN(port),
> -             port->base + PINCTRL_DOUT(port), NULL,
> +             port->base + PINCTRL_DOUT(port) + MXS_SET,
> +             port->base + PINCTRL_DOUT(port) + MXS_CLR,
>               port->base + PINCTRL_DOE(port), NULL, 0);
>      if (err)
>          goto out_irqdesc_free;

