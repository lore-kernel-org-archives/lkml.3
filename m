Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3G3PbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:31:12 -0400
Received: from benson.vm.bytemark.co.uk ([212.110.190.137]:54160 "EHLO
	benson.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3G3PbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:31:10 -0400
X-Greylist: delayed 1302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jul 2013 11:31:10 EDT
Message-ID: <1375196953.32691.61.camel@kazak.uk.xensource.com>
Subject: Re: [linux-sunxi] [PATCH 04/10] pinctrl: sunxi: Wrap long
 compatible declaration lines
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-sunxi@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org, Emilio Lopez <emilio@elopez.com.ar>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 30 Jul 2013 16:09:13 +0100
In-Reply-To: <1375196394-21138-5-git-send-email-maxime.ripard@free-electrons.com>
References: <1375196394-21138-1-git-send-email-maxime.ripard@free-electrons.com>
	 <1375196394-21138-5-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 16:59 +0200, Maxime Ripard wrote:
> The compatible declaration and their associated data are exceeding the
> 80-characters width limit.
> 
> Split these lines to make them more readable and fit in the kernel
> coding guidelines.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-sunxi.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
> index 5985e60..246310b 100644
> --- a/drivers/pinctrl/pinctrl-sunxi.c
> +++ b/drivers/pinctrl/pinctrl-sunxi.c
> @@ -628,10 +628,22 @@ static void sunxi_pinctrl_irq_handler(unsigned irq, struct irq_desc *desc)
>  }
>  
>  static struct of_device_id sunxi_pinctrl_match[] = {
> -	{ .compatible = "allwinner,sun4i-a10-pinctrl", .data = (void *)&sun4i_a10_pinctrl_data },
> -	{ .compatible = "allwinner,sun5i-a10s-pinctrl", .data = (void *)&sun5i_a10s_pinctrl_data },
> -	{ .compatible = "allwinner,sun5i-a13-pinctrl", .data = (void *)&sun5i_a13_pinctrl_data },
> -	{ .compatible = "allwinner,sun6i-a31-pinctrl", .data = (void *)&sun6i_a31_pinctrl_data },
> +	{
> +		.compatible = "allwinner,sun4i-a10-pinctrl",
> +		.data = (void *)&sun4i_a10_pinctrl_data,
> +	},

I'm not sure this is actually an improvement, the original reads quite
naturally even if it is a little long. What about a #define such that
you can write:
         COMPAT("allwinner,sun4i-a10-pinctrl", sun4i_a10_pinctrl_data),
and thereby stay within 80-chars?

If you wanted to go overboard you could code the macro such that:
        SUNXI_COMPAT(sun4i,a10),
expanded to what you want, that's pretty obfuscated though.

Ian.

