Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab3LKJou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:44:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54484 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3LKJos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:44:48 -0500
Date: Wed, 11 Dec 2013 10:44:40 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        sameo@linux.intel.com, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lee.jones@linaro.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 01/15] mfd: menelaus: Drop __exit section annotation
Message-ID: <20131211094440.GG18888@pengutronix.de>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386042188-12246-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 09:42:54PM -0600, Felipe Balbi wrote:
> we could build that as a driver.
What is "that". How can it not be a driver? Do you mean modular? In that
case there is no problem, the only thing that doesn't work is unloading
the module.

Best regards
Uwe
 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/mfd/menelaus.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> index ad25bfa..975ff9e 100644
> --- a/drivers/mfd/menelaus.c
> +++ b/drivers/mfd/menelaus.c
> @@ -1262,7 +1262,7 @@ fail:
>  	return err;
>  }
>  
> -static int __exit menelaus_remove(struct i2c_client *client)
> +static int menelaus_remove(struct i2c_client *client)
>  {
>  	struct menelaus_chip	*menelaus = i2c_get_clientdata(client);
>  
> @@ -1283,7 +1283,7 @@ static struct i2c_driver menelaus_i2c_driver = {
>  		.name		= DRIVER_NAME,
>  	},
>  	.probe		= menelaus_probe,
> -	.remove		= __exit_p(menelaus_remove),
> +	.remove		= menelaus_remove,
>  	.id_table	= menelaus_id,
>  };
>  

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
