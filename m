Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaE0Jax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:30:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37688 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaE0Jaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:30:52 -0400
Message-ID: <1401183045.4090.33.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH] regulator: ltc3589: Fix module dependency
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Date: Tue, 27 May 2014 11:30:45 +0200
In-Reply-To: <1401169909.11231.1.camel@phoenix>
References: <1401169909.11231.1.camel@phoenix>
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

Am Dienstag, den 27.05.2014, 13:51 +0800 schrieb Axel Lin:
> Make this driver depend on I2C and select REGMAP_I2C to fix build failure.
> Also allows this driver to be built as module.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

> ---
>  drivers/regulator/Kconfig | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index 8f5c880..c2fa0b4 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -273,7 +273,9 @@ config REGULATOR_LP8788
>  	  This driver supports LP8788 voltage regulator chip.
>  
>  config REGULATOR_LTC3589
> -	bool "LTC3589 8-output voltage regulator"
> +	tristate "LTC3589 8-output voltage regulator"
> +	depends on I2C
> +	select REGMAP_I2C

thanks
Philipp

