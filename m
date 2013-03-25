Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3CYDNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 23:13:55 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35836 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3CYDNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 23:13:53 -0400
Date: Sun, 24 Mar 2013 20:09:56 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/5] power: pm2301_charger: Remove __dev* annotations
Message-ID: <20130325030956.GA16489@lizard>
References: <1362922449-27531-1-git-send-email-lars@metafoo.de>
 <1362922449-27531-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362922449-27531-4-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 02:34:08PM +0100, Lars-Peter Clausen wrote:
> The removal of __devinit and friends seems to have overlapped with the addition
> of the pm2301_charger driver. Currently the driver fails to build with the
> following errors:
> 
> 	drivers/power/pm2301_charger.c:843:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'pm2xxx_wall_charger_probe'
> 	drivers/power/pm2301_charger.c:1013:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'pm2xxx_wall_charger_remove'
> 	drivers/power/pm2301_charger.c:1049:11: error: 'pm2xxx_wall_charger_probe' undeclared here (not in a function)
> 	drivers/power/pm2301_charger.c:1050:2: error: implicit declaration of function '__devexit_p'
> 	drivers/power/pm2301_charger.c:1050:24: error: 'pm2xxx_wall_charger_remove' undeclared here (not in a function)
> 
> This patch removes the __dev* annotations, which fixes the build errors.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied to battery-urgent.git, thanks a lot!

> ---
>  drivers/power/pm2301_charger.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
> index ed48d75..ca424b8 100644
> --- a/drivers/power/pm2301_charger.c
> +++ b/drivers/power/pm2301_charger.c
> @@ -851,7 +851,7 @@ static int pm2xxx_wall_charger_suspend(struct i2c_client *i2c_client,
>  	return 0;
>  }
>  
> -static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
> +static int pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
>  		const struct i2c_device_id *id)
>  {
>  	struct pm2xxx_platform_data *pl_data = i2c_client->dev.platform_data;
> @@ -1021,7 +1021,7 @@ free_device_info:
>  	return ret;
>  }
>  
> -static int __devexit pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
> +static int pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
>  {
>  	struct pm2xxx_charger *pm2 = i2c_get_clientdata(i2c_client);
>  
> @@ -1058,7 +1058,7 @@ MODULE_DEVICE_TABLE(i2c, pm2xxx_id);
>  
>  static struct i2c_driver pm2xxx_charger_driver = {
>  	.probe = pm2xxx_wall_charger_probe,
> -	.remove = __devexit_p(pm2xxx_wall_charger_remove),
> +	.remove = pm2xxx_wall_charger_remove,
>  	.suspend = pm2xxx_wall_charger_suspend,
>  	.resume = pm2xxx_wall_charger_resume,
>  	.driver = {
> -- 
> 1.8.0
> 
> 
