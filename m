Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaJ0QgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:36:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41728 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaJ0QgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:36:03 -0400
Message-ID: <1414427749.2421.5.camel@pengutronix.de>
Subject: Re: [PATCH v2 06/10] mfd: tps65910: Use the standard DT property
 system-power-controller
From: Lucas Stach <l.stach@pengutronix.de>
To: Romain Perier <romain.perier@gmail.com>
Cc: heiko@sntech.de, devicetree@vger.kernel.org, broonie@kernel.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, robh@kernel.org, mark.rutland@arm.com,
        johan@kernel.org, linux-pm@vger.kernel.org, linux@roeck-us.net,
        lee.jones@linaro.org, balbi@ti.com, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Date: Mon, 27 Oct 2014 17:35:49 +0100
In-Reply-To: <1414427215-14380-6-git-send-email-romain.perier@gmail.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
	 <1414427215-14380-6-git-send-email-romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 27.10.2014, 16:26 +0000 schrieb Romain Perier:
> No longer use custom property to define poweroff capability, use the standard
> DT property instead.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  drivers/mfd/tps65910.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index 7612d89..a7faff2 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -423,8 +423,7 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
>  
>  	board_info->irq = client->irq;
>  	board_info->irq_base = -1;
> -	board_info->pm_off = of_property_read_bool(np,
> -			"ti,system-power-controller");
> +	board_info->pm_off = of_is_system_power_controller();
>  
>  	return board_info;
>  }
You are breaking compatibility with older DTs here. This is not
acceptable.

You may change all in-tree DTs to use the new property and also patch
the driver to understand it, but you must make sure that the driver
still understands the old, custom property. And especially in this case
it isn't really hard to do.

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

