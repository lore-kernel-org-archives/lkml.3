Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaHSTYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 15:24:14 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40575 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbaHSTYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 15:24:12 -0400
Date: Tue, 19 Aug 2014 12:24:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: mark.rutland@arm.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v6] input: drv260x: Add TI drv260x haptics driver
Message-ID: <20140819192401.GA32080@core.coreip.homeip.net>
References: <1408117670-19750-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408117670-19750-1-git-send-email-dmurphy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Fri, Aug 15, 2014 at 10:47:50AM -0500, Dan Murphy wrote:
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 2ff4425..99f6762 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -676,4 +676,13 @@ config INPUT_SOC_BUTTON_ARRAY
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called soc_button_array.
>  
> +config INPUT_DRV260X_HAPTICS
> +	tristate "TI DRV260X haptics support"
> +	depends on INPUT && I2C

This also needs "select REGMAP_I2C"

> +	help
> +	  Say Y to enable support for the TI DRV260X haptics driver.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called drv260x-haptics.
> +

[...]

> +#ifndef _LINUX_DRV260X_PDATA_H
> +#define _LINUX_DRV260X_PDATA_H
> +
> +struct drv260x_platform_data {
> +	int enable_gpio;

I do not see this used anywhere.

> +	u32 library_selection;
> +	u32 mode;
> +	u32 vib_rated_voltage;
> +	u32 vib_overdrive_voltage;
> +};
> +
> +#endif

I fixed up the above issues and did a few more formatting changes and applied
to my 'next' branch. Please take a peek and holler if you see something wrong.

Thanks.

-- 
Dmitry
