Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbaLAMgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:36:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbaLAMgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:36:50 -0500
Date: Mon, 1 Dec 2014 13:36:45 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pali =?UTF-8?B?Um9o?= =?UTF-8?B?w6Fy?= <pali.rohar@gmail.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 3/3] i8k: Add support for Dell XPS 13
Message-ID: <20141201133645.2a423043@endymion.delvare>
In-Reply-To: <1417381240-7641-3-git-send-email-linux@roeck-us.net>
References: <1417381240-7641-1-git-send-email-linux@roeck-us.net>
	<1417381240-7641-3-git-send-email-linux@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2014 13:00:40 -0800, Guenter Roeck wrote:
> XPS 13 does not support turbo speed, so its initialization data
> matches that of XPS M140. Make XPS initialization data generic,
> and add support for XPS 13.
> 
> Cc: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Applies on top of Pali's patch series. 
> 
>  drivers/char/i8k.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index cdb2dc7..6d2caa9 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -705,7 +705,7 @@ enum i8k_configs {
>  	DELL_LATITUDE_E6540,
>  	DELL_PRECISION_490,
>  	DELL_STUDIO,
> -	DELL_XPS_M140,
> +	DELL_XPS,
>  };
>  
>  static const struct i8k_config_data i8k_config_data[] = {
> @@ -725,7 +725,7 @@ static const struct i8k_config_data i8k_config_data[] = {
>  		.fan_mult = 1,
>  		.fan_max = I8K_FAN_HIGH,
>  	},
> -	[DELL_XPS_M140] = {
> +	[DELL_XPS] = {
>  		.fan_mult = 1,
>  		.fan_max = I8K_FAN_HIGH,
>  	},
> @@ -829,12 +829,20 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
>  		.driver_data = (void *)&i8k_config_data[DELL_STUDIO],
>  	},
>  	{
> +		.ident = "Dell XPS 13",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "XPS13"),
> +		},
> +		.driver_data = (void *)&i8k_config_data[DELL_XPS],
> +	},
> +	{
>  		.ident = "Dell XPS M140",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
>  			DMI_MATCH(DMI_PRODUCT_NAME, "MXC051"),
>  		},
> -		.driver_data = (void *)&i8k_config_data[DELL_XPS_M140],
> +		.driver_data = (void *)&i8k_config_data[DELL_XPS],
>  	},
>  	{ }
>  };

Looks reasonable.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support
