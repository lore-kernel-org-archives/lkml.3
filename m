Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaKWREI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 12:04:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38862 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaKWREF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 12:04:05 -0500
Date: Sun, 23 Nov 2014 18:04:00 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Mike Looijmans <milo-software@users.sourceforge.net>
Subject: Re: [5/5] i2c: davinci: use ICPFUNC to toggle I2C as gpio for bus
 recovery
Message-ID: <20141123170400.GC4431@pengutronix.de>
References: <1416477788-5544-6-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416477788-5544-6-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 20, 2014 at 12:03:08PM +0200, Grygorii Strashko wrote:
> @@ -664,6 +759,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  		if (!of_property_read_u32(pdev->dev.of_node, "clock-frequency",
>  			&prop))
>  			dev->pdata->bus_freq = prop / 1000;
> +		dev->pdata->has_pfunc = true;
I don't understand this. Why does this ICPFUNC recovery work if the bus
is probed by oftree, but doesn't if not?

>  	} else if (!dev->pdata) {
>  		dev->pdata = &davinci_i2c_platform_data_default;
>  	}
> @@ -705,7 +801,9 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  	adap->timeout = DAVINCI_I2C_TIMEOUT;
>  	adap->dev.of_node = pdev->dev.of_node;
>  
> -	if (dev->pdata->scl_pin) {
> +	if (dev->pdata->has_pfunc)
> +		adap->bus_recovery_info = &davinci_i2c_scl_recovery_info;
> +	else if (dev->pdata->scl_pin) {
>  		adap->bus_recovery_info = &davinci_i2c_gpio_recovery_info;
>  		adap->bus_recovery_info->scl_gpio = dev->pdata->scl_pin;
>  		adap->bus_recovery_info->sda_gpio = dev->pdata->sda_pin;
> diff --git a/include/linux/platform_data/i2c-davinci.h b/include/linux/platform_data/i2c-davinci.h
> index 2312d19..89fd347 100644
> --- a/include/linux/platform_data/i2c-davinci.h
> +++ b/include/linux/platform_data/i2c-davinci.h
> @@ -18,6 +18,7 @@ struct davinci_i2c_platform_data {
>  	unsigned int	bus_delay;	/* post-transaction delay (usec) */
>  	unsigned int    sda_pin;        /* GPIO pin ID to use for SDA */
>  	unsigned int    scl_pin;        /* GPIO pin ID to use for SCL */
> +	bool		has_pfunc;	/*chip has a ICPFUNC register */
Space after /* please

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
