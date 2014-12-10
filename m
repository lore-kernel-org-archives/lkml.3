Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbaLJNl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:41:28 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42066 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbaLJNl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:41:27 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Wed, 10 Dec 2014 14:41:23 +0100
Message-ID: <1837178.qSFs3O0Xsc@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1418155621-21644-4-git-send-email-pali.rohar@gmail.com>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1418155621-21644-4-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2014 21:07:01 Pali Rohár wrote:
> Now we have autodetection code for fan multiplier and maximal fan speed so we do
> not need to have those constants for each laptop in kernel driver code.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
> !!!Please do not apply this patch until all affected machines will be tested!!!
> 
> I tested autodetection code only on Dell Latitude E6440 (where it worked).
> Other machines which needs to be tested:
> 
> Dell Latitude D520
> Dell Latitude E6540
> Dell Precision WorkStation 490
> Dell Studio
> Dell XPS M140 (MXC051)

Just a note: "or in dmi" has to be removed from a couple of comments.

Gabriele

> ---
>  drivers/char/i8k.c |   88 +---------------------------------------------------
>  1 file changed, 1 insertion(+), 87 deletions(-)
> 
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index 8bdbed2..bf74644 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -725,42 +725,6 @@ static int __init i8k_init_hwmon(void)
>  	return 0;
>  }
>  
> -struct i8k_config_data {
> -	int fan_mult;
> -	int fan_max;
> -};
> -
> -enum i8k_configs {
> -	DELL_LATITUDE_D520,
> -	DELL_LATITUDE_E6540,
> -	DELL_PRECISION_490,
> -	DELL_STUDIO,
> -	DELL_XPS_M140,
> -};
> -
> -static const struct i8k_config_data i8k_config_data[] = {
> -	[DELL_LATITUDE_D520] = {
> -		.fan_mult = 1,
> -		.fan_max = I8K_FAN_TURBO,
> -	},
> -	[DELL_LATITUDE_E6540] = {
> -		.fan_mult = 1,
> -		.fan_max = I8K_FAN_HIGH,
> -	},
> -	[DELL_PRECISION_490] = {
> -		.fan_mult = 1,
> -		.fan_max = I8K_FAN_TURBO,
> -	},
> -	[DELL_STUDIO] = {
> -		.fan_mult = 1,
> -		.fan_max = I8K_FAN_HIGH,
> -	},
> -	[DELL_XPS_M140] = {
> -		.fan_mult = 1,
> -		.fan_max = I8K_FAN_HIGH,
> -	},
> -};
> -
>  static struct dmi_system_id i8k_dmi_table[] __initdata = {
>  	{
>  		.ident = "Dell Inspiron",
> @@ -784,30 +748,6 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
>  		},
>  	},
>  	{
> -		.ident = "Dell Latitude D520",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude D520"),
> -		},
> -		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_D520],
> -	},
> -	{
> -		.ident = "Dell Latitude E6440",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6440"),
> -		},
> -		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_E6540],
> -	},
> -	{
> -		.ident = "Dell Latitude E6540",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6540"),
> -		},
> -		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_E6540],
> -	},
> -	{
>  		.ident = "Dell Latitude 2",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> @@ -822,22 +762,13 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
>  		},
>  	},
>  	{
> -		.ident = "Dell Inspiron 3",
> +		.ident = "Dell Inspiron 4",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
>  			DMI_MATCH(DMI_PRODUCT_NAME, "MP061"),
>  		},
>  	},
>  	{
> -		.ident = "Dell Precision 490",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> -			DMI_MATCH(DMI_PRODUCT_NAME,
> -				  "Precision WorkStation 490"),
> -		},
> -		.driver_data = (void *)&i8k_config_data[DELL_PRECISION_490],
> -	},
> -	{
>  		.ident = "Dell Precision",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> @@ -864,7 +795,6 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
>  			DMI_MATCH(DMI_PRODUCT_NAME, "Studio"),
>  		},
> -		.driver_data = (void *)&i8k_config_data[DELL_STUDIO],
>  	},
>  	{
>  		.ident = "Dell XPS M140",
> @@ -872,7 +802,6 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
>  			DMI_MATCH(DMI_PRODUCT_NAME, "MXC051"),
>  		},
> -		.driver_data = (void *)&i8k_config_data[DELL_XPS_M140],
>  	},
>  	{ }
>  };
> @@ -884,8 +813,6 @@ MODULE_DEVICE_TABLE(dmi, i8k_dmi_table);
>   */
>  static int __init i8k_probe(void)
>  {
> -	const struct i8k_config_data *conf;
> -	const struct dmi_system_id *id;
>  	int fan, val, ret;
>  
>  	/*
> @@ -915,19 +842,6 @@ static int __init i8k_probe(void)
>  			return -ENODEV;
>  	}
>  
> -	/*
> -	 * Autodetect fan multiplier and maximal fan speed from dmi config
> -	 * Values specified in module parameters override values from dmi
> -	 */
> -	id = dmi_first_match(i8k_dmi_table);
> -	if (id && id->driver_data) {
> -		conf = id->driver_data;
> -		if (fan_mult <= 0 && conf->fan_mult > 0)
> -			fan_mult = conf->fan_mult;
> -		if (fan_max <= 0 && conf->fan_max > 0)
> -			fan_max = conf->fan_max;
> -	}
> -
>  	if (fan_mult <= 0) {
>  		/*
>  		 * Autodetect fan multiplier for each fan based on nominal rpm
> 

