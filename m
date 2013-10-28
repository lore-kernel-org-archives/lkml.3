Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3J1HyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:54:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34046 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3J1HyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:54:06 -0400
Date: Mon, 28 Oct 2013 08:54:01 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Peter Chen <peter.chen@freescale.com>
Cc: linus.walleij@linaro.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] pinctrl: imx: fix using pin->input_val wrongly
Message-ID: <20131028075401.GH30088@pengutronix.de>
Mail-Followup-To: Peter Chen <peter.chen@freescale.com>,
	linus.walleij@linaro.org, shawn.guo@linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1382940076-11898-1-git-send-email-peter.chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382940076-11898-1-git-send-email-peter.chen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:53:33 up 64 days, 17:24, 41 users,  load average: 0.03, 0.05,
 0.10
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 02:01:16PM +0800, Peter Chen wrote:
> The commit: "pinctrl: imx: Use struct type for pins" relaced
> pin->input_reg by pin->input_val wrongly, fix it at this commit.
> 
> Signed-off-by: Peter Chen <peter.chen@freescale.com>

Oops.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/pinctrl/pinctrl-imx.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> index d78dd81..4779b8e 100644
> --- a/drivers/pinctrl/pinctrl-imx.c
> +++ b/drivers/pinctrl/pinctrl-imx.c
> @@ -245,11 +245,11 @@ static int imx_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
>  			 * The input_reg[i] here is actually some IOMUXC general
>  			 * purpose register, not regular select input register.
>  			 */
> -			val = readl(ipctl->base + pin->input_val);
> +			val = readl(ipctl->base + pin->input_reg);
>  			val &= ~mask;
>  			val |= select << shift;
> -			writel(val, ipctl->base + pin->input_val);
> -		} else if (pin->input_val) {
> +			writel(val, ipctl->base + pin->input_reg);
> +		} else if (pin->input_reg) {
>  			/*
>  			 * Regular select input register can never be at offset
>  			 * 0, and we only print register value for regular case.
> -- 
> 1.7.1
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
