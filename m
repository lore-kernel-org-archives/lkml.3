Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaAUKY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:24:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53477 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaAUKY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:24:56 -0500
Date: Tue, 21 Jan 2014 11:24:52 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm@lists.infradead.org
Subject: Re: [PATCH] imx27: pinctrl: fix wrong offset to ICONFB
Message-ID: <20140121102452.GA25016@pengutronix.de>
References: <1389835103-14811-1-git-send-email-chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389835103-14811-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:39:20 up 149 days, 19:10, 47 users,  load average: 0.25, 0.16,
 0.15
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 16, 2014 at 09:18:23AM +0800, Chris Ruehl wrote:
> The offset to ICONFB was incorrect, this patch set the correct value 0x14.
> dev_dbg in function imx1_write_2bit print the wrong address and had been
> moved after address calculation.
> 
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>

Reviewed-by: Markus Pargmann <mpa@pengutronix.de>

Perhaps this should go to the stable tree too for 3.13 and 3.14?

Regards,

Markus

> ---
>  drivers/pinctrl/pinctrl-imx1-core.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-imx1-core.c b/drivers/pinctrl/pinctrl-imx1-core.c
> index f77914a..8dfc3dc 100644
> --- a/drivers/pinctrl/pinctrl-imx1-core.c
> +++ b/drivers/pinctrl/pinctrl-imx1-core.c
> @@ -45,7 +45,7 @@ struct imx1_pinctrl {
>  #define MX1_DDIR 0x00
>  #define MX1_OCR 0x04
>  #define MX1_ICONFA 0x0c
> -#define MX1_ICONFB 0x10
> +#define MX1_ICONFB 0x14
>  #define MX1_GIUS 0x20
>  #define MX1_GPR 0x38
>  #define MX1_PUEN 0x40
> @@ -97,13 +97,13 @@ static void imx1_write_2bit(struct imx1_pinctrl *ipctl, unsigned int pin_id,
>  	u32 old_val;
>  	u32 new_val;
>  
> -	dev_dbg(ipctl->dev, "write: register 0x%p offset %d value 0x%x\n",
> -			reg, offset, value);
> -
>  	/* Use the next register if the pin's port pin number is >=16 */
>  	if (pin_id % 32 >= 16)
>  		reg += 0x04;
>  
> +	dev_dbg(ipctl->dev, "write: register 0x%p offset %d value 0x%x\n",
> +			reg, offset, value);
> +
>  	/* Get current state of pins */
>  	old_val = readl(reg);
>  	old_val &= mask;
> -- 
> 1.7.10.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
