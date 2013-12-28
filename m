Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3L1RD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 12:03:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42392 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3L1RD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 12:03:57 -0500
Date: Sat, 28 Dec 2013 18:03:42 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps65910: Simplify setting enable_mask for
 regulators
Message-ID: <20131228170342.GJ23493@pengutronix.de>
References: <1388199755.8941.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1388199755.8941.0.camel@phoenix>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:26:47 up 126 days,  1:57, 38 users,  load average: 0.00, 0.03,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 11:02:35AM +0800, Axel Lin wrote:
> BBCH_BBCHEN_MASK is equivalent to TPS65910_SUPPLY_STATE_ENABLED.
> So all regulators have the same enable_mask setting.
> 

Thanks for spotting this. You could also remove BBCH_BBCHEN_* from
include/linux/mfd/tps65910.h.

Regards,

Markus

> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/tps65910-regulator.c | 16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
> index 979ea0a..f50dd84 100644
> --- a/drivers/regulator/tps65910-regulator.c
> +++ b/drivers/regulator/tps65910-regulator.c
> @@ -1207,21 +1207,7 @@ static int tps65910_probe(struct platform_device *pdev)
>  		pmic->desc[i].type = REGULATOR_VOLTAGE;
>  		pmic->desc[i].owner = THIS_MODULE;
>  		pmic->desc[i].enable_reg = pmic->get_ctrl_reg(i);
> -
> -		switch (i) {
> -		case TPS65910_REG_VBB:
> -			if (tps65910_chip_id(tps65910) == TPS65910)
> -				pmic->desc[i].enable_mask = BBCH_BBCHEN_MASK;
> -			else
> -				pmic->desc[i].enable_mask =
> -					TPS65910_SUPPLY_STATE_ENABLED;
> -			break;
> -
> -		default:
> -			pmic->desc[i].enable_mask =
> -				TPS65910_SUPPLY_STATE_ENABLED;
> -			break;
> -		}
> +		pmic->desc[i].enable_mask = TPS65910_SUPPLY_STATE_ENABLED;
>  
>  		config.dev = tps65910->dev;
>  		config.init_data = reg_data;
> -- 
> 1.8.1.2
> 
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
