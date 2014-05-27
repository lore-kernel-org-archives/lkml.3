Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaE0Jdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:33:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49213 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaE0Jdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:33:44 -0400
Message-ID: <1401183221.4090.34.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH] regulator: ltc3589: Remove ltc3589_list_voltage_fixed
 function
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 27 May 2014 11:33:41 +0200
In-Reply-To: <1401170709.11231.3.camel@phoenix>
References: <1401170709.11231.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 27.05.2014, 14:05 +0800 schrieb Axel Lin:
> When fixed_uV is set and n_voltage is 1, regulator core will return
> rdev->desc->fixed_uV in regulator_get_voltage() and regulator_list_voltage().
> 
> Rename ltc3589_standby_regulator_ops to ltc3589_fixed_standby_regulator_ops,
> this makes the code clear that the ops is for fixed voltage regulator.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Looks good to me.

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

> ---
>  drivers/regulator/ltc3589.c | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/regulator/ltc3589.c b/drivers/regulator/ltc3589.c
> index fef64ee..110a99e 100644
> --- a/drivers/regulator/ltc3589.c
> +++ b/drivers/regulator/ltc3589.c
> @@ -160,15 +160,6 @@ static int ltc3589_set_suspend_mode(struct regulator_dev *rdev,
>  	return regmap_update_bits(ltc3589->regmap, LTC3589_VCCR, mask, bit);
>  }
>  
> -static int ltc3589_list_voltage_fixed(struct regulator_dev *rdev,
> -				      unsigned int selector)
> -{
> -	if (selector)
> -		return -EINVAL;
> -
> -	return rdev->desc->fixed_uV;
> -}
> -
>  /* SW1, SW2, SW3, LDO2 */
>  static struct regulator_ops ltc3589_linear_regulator_ops = {
>  	.enable = regulator_enable_regmap,
> @@ -188,12 +179,10 @@ static struct regulator_ops ltc3589_fixed_regulator_ops = {
>  	.enable = regulator_enable_regmap,
>  	.disable = regulator_disable_regmap,
>  	.is_enabled = regulator_is_enabled_regmap,
> -	.list_voltage = ltc3589_list_voltage_fixed,
>  };
>  
>  /* LDO1 */
> -static struct regulator_ops ltc3589_standby_regulator_ops = {
> -	.list_voltage = ltc3589_list_voltage_fixed,
> +static struct regulator_ops ltc3589_fixed_standby_regulator_ops = {
>  };
>  
>  /* LDO4 */
> @@ -242,7 +231,7 @@ static struct ltc3589_regulator ltc3589_regulators[LTC3589_NUM_REGULATORS] = {
>  	LTC3589_LINEAR_REG(SW2, B2DTV1),
>  	LTC3589_LINEAR_REG(SW3, B3DTV1),
>  	LTC3589_FIXED_REG(BB_OUT),
> -	LTC3589_REG(LDO1, standby, 0, 0, 0, 0),
> +	LTC3589_REG(LDO1, fixed_standby, 0, 0, 0, 0),
>  	LTC3589_LINEAR_REG(LDO2, L2DTV1),
>  	LTC3589_FIXED_REG(LDO3),
>  	LTC3589_REG(LDO4, table, LTC3589_OVEN_LDO4, LTC3589_L2DTV2, 0x60, 0),

thanks
Philipp

