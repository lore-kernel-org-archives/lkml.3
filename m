Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030874Ab3HITZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:25:42 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39386 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030789Ab3HITZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:25:38 -0400
Date: Fri, 9 Aug 2013 12:25:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michael Brunner <BrunnerMichael@t-online.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Chris Healy <chealy@imsco-us.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mfd: Add support for COMe-bHL6 and COMe-cTH6 to Kontron
 PLD driver
Message-ID: <20130809192536.GC10417@roeck-us.net>
References: <20130809173343.7843a13a@charybdis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809173343.7843a13a@charybdis>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 05:33:43PM +0200, Michael Brunner wrote:
> This patch adds DMI system IDs for the new Kontron modules COMe-bHL6 and
> COMe-cTH6 to the Kontron PLD driver.
> 
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/mfd/kempld-core.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
> index 686a456..ee28e76 100644
> --- a/drivers/mfd/kempld-core.c
> +++ b/drivers/mfd/kempld-core.c
> @@ -413,6 +413,15 @@ static struct platform_driver kempld_driver = {
>  
>  static struct dmi_system_id __initdata kempld_dmi_table[] = {
>  	{
> +		.ident = "BHL6",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
> +			DMI_MATCH(DMI_BOARD_NAME, "COMe-bHL6"),
> +		},
> +		.driver_data = (void *)&kempld_platform_data_generic,
> +		.callback = kempld_create_platform_device,
> +	},
> +	{
>  		.ident = "CCR2",
>  		.matches = {
>  			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
> @@ -596,6 +605,15 @@ static struct dmi_system_id __initdata kempld_dmi_table[] = {
>  		.driver_data = (void *)&kempld_platform_data_generic,
>  		.callback = kempld_create_platform_device,
>  	},
> +	{
> +		.ident = "UTH6",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
> +			DMI_MATCH(DMI_BOARD_NAME, "COMe-cTH6"),
> +		},
> +		.driver_data = (void *)&kempld_platform_data_generic,
> +		.callback = kempld_create_platform_device,
> +	},
>  	{}
>  };
>  MODULE_DEVICE_TABLE(dmi, kempld_dmi_table);
> 
