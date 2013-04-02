Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023Ab3DBINP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:13:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60786 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3DBINM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:13:12 -0400
Date: Tue, 2 Apr 2013 10:13:09 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm: imx: Remove enabled field from struct imx_chip
Message-ID: <20130402081309.GL1906@pengutronix.de>
References: <1364741987.3834.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364741987.3834.2.camel@phoenix>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:12:45 up 282 days, 23:24, 40 users,  load average: 0.55, 0.58,
 1.57
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31, 2013 at 10:59:47PM +0800, Axel Lin wrote:
> We can test PWMF_ENABLED bit to know if pwm is enabled or not.
> Thus remove enabled field from struct imx_chip.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Looks good.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/pwm/pwm-imx.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> index 3f5677b..ec28798 100644
> --- a/drivers/pwm/pwm-imx.c
> +++ b/drivers/pwm/pwm-imx.c
> @@ -43,7 +43,6 @@ struct imx_chip {
>  	struct clk	*clk_per;
>  	struct clk	*clk_ipg;
>  
> -	int		enabled;
>  	void __iomem	*mmio_base;
>  
>  	struct pwm_chip	chip;
> @@ -135,7 +134,7 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
>  		MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
>  		MX3_PWMCR_DBGEN | MX3_PWMCR_CLKSRC_IPG_HIGH;
>  
> -	if (imx->enabled)
> +	if (test_bit(PWMF_ENABLED, &pwm->flags))
>  		cr |= MX3_PWMCR_EN;
>  
>  	writel(cr, imx->mmio_base + MX3_PWMCR);
> @@ -186,8 +185,6 @@ static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>  
>  	imx->set_enable(chip, true);
>  
> -	imx->enabled = 1;
> -
>  	return 0;
>  }
>  
> @@ -198,7 +195,6 @@ static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>  	imx->set_enable(chip, false);
>  
>  	clk_disable_unprepare(imx->clk_per);
> -	imx->enabled = 0;
>  }
>  
>  static struct pwm_ops imx_pwm_ops = {
> -- 
> 1.7.10.4
> 
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
