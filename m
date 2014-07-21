Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaGUNiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:38:08 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:50682 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbaGUNiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:38:06 -0400
Date: Mon, 21 Jul 2014 15:33:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/16] i2c: i2c-mv64xxx: Drop class based scanning to
 improve bootup time
Message-ID: <20140721133304.GC10623@lunn.ch>
References: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
 <1404992799-3705-8-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404992799-3705-8-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 01:46:27PM +0200, Wolfram Sang wrote:
> This driver has been flagged to drop class based instantiation. The removal
> improves boot-up time and is unneeded for embedded controllers. Users have been
> warned to switch for some time now, so we can actually do the removal. Keep the
> DEPRECATED flag, so the core can inform users that the behaviour finally
> changed now. After another transition period, this flag can go, too.

Hi Wolfram

Acked-by: Andrew Lunn <andrew@lunn.ch>

As far as i know, none of the arm boards using this driver make use of
class based instantiation. The majority use DT now, the exception
being Orion5x.  So you could jump straight to removing the flag if you
wanted.

   Andrew
 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/i2c/busses/i2c-mv64xxx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
> index 9f4b775e2e39..6dc5ded86f62 100644
> --- a/drivers/i2c/busses/i2c-mv64xxx.c
> +++ b/drivers/i2c/busses/i2c-mv64xxx.c
> @@ -863,7 +863,7 @@ mv64xxx_i2c_probe(struct platform_device *pd)
>  	drv_data->adapter.dev.parent = &pd->dev;
>  	drv_data->adapter.algo = &mv64xxx_i2c_algo;
>  	drv_data->adapter.owner = THIS_MODULE;
> -	drv_data->adapter.class = I2C_CLASS_HWMON | I2C_CLASS_SPD | I2C_CLASS_DEPRECATED;
> +	drv_data->adapter.class = I2C_CLASS_DEPRECATED;
>  	drv_data->adapter.nr = pd->id;
>  	drv_data->adapter.dev.of_node = pd->dev.of_node;
>  	platform_set_drvdata(pd, drv_data);
> -- 
> 2.0.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
