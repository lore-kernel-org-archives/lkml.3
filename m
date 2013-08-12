Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3HLQbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:31:14 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:54081 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab3HLQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:31:13 -0400
Date: Mon, 12 Aug 2013 17:31:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Michael Brunner <BrunnerMichael@t-online.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Chris Healy <chealy@imsco-us.com>
Subject: Re: [PATCH] mfd: Add support for COMe-bHL6 and COMe-cTH6 to Kontron
 PLD driver
Message-ID: <20130812152515.GA3636@lee--X1>
References: <20130809173343.7843a13a@charybdis>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130809173343.7843a13a@charybdis>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Aug 2013, Michael Brunner wrote:

> This patch adds DMI system IDs for the new Kontron modules COMe-bHL6 and
> COMe-cTH6 to the Kontron PLD driver.
> 
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> ---
>  drivers/mfd/kempld-core.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)

Applied with Kevin's Ack, thanks.

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

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
