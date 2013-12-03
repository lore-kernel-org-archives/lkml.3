Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab3LCJY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:24:27 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54314 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab3LCJYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:24:21 -0500
Date: Tue, 3 Dec 2013 09:24:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        sameo@linux.intel.com, grant.likely@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/4] MFD: TPS65218: Add driver for the TPS65218 PMIC
Message-ID: <20131203092410.GD11828@lee--X1>
References: <1386053006-6480-1-git-send-email-j-keerthy@ti.com>
 <1386053006-6480-3-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386053006-6480-3-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The TPS65218 chip is a power management IC for Portable Navigation Systems
> and Tablet Computing devices. It contains the following components:
> 
>  - Regulators.
>  - Over Temperature warning and Shut down.
> 
> This patch adds support for tps65218 mfd device. At this time only
> the regulator functionality is made available.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  drivers/mfd/Kconfig          |   14 ++
>  drivers/mfd/Makefile         |    1 +
>  drivers/mfd/tps65218.c       |  281 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/tps65218.h |  288 ++++++++++++++++++++++++++++++++++++++++++

<snip>

> +config MFD_TPS65218
> +	tristate "TI TPS65218 Power Management chips"
> +	depends on I2C
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	help
> +	  If you say yes here you get support for the TPS65218 series of
> +	  Power Management chips.
> +	  These include voltage regulators, gpio and other features
> +	  that are often used in portable devices.

Perhaps you should add a note that only the regulator component is
currently supported.

<snip>

> new file mode 100644
> index 0000000..8c61640
> --- /dev/null
> +++ b/drivers/mfd/tps65218.c
> @@ -0,0 +1,281 @@
> +/*
> + * TPS65218 chip family multi-function driver

Instead of calling it an MFD driver (is there such a thing?) I think
you should mention its true purpose, as per the datasheet.

<snip>

> +static const struct of_device_id of_tps65218_match_table[] = {
> +	{ .compatible = "ti,tps65218", },
> +	{ /* end */ }

I think the end comment is superfluous.

However, if you _really_ want to put something in there, I dislike
"/* Sentinel */" the least.

> +static int tps65218_probe(struct i2c_client *client,
> +				const struct i2c_device_id *ids)
> +{

<snip>

> +	ret = of_platform_populate(client->dev.of_node, NULL, NULL,
> +				   &client->dev);

What are you trying to do here?

Register each regulator as a platform device?

<snip>

> +static const struct i2c_device_id tps65218_id_table[] = {
> +	{"tps65218", TPS65218},
> +};

This has a different structure to of_tps65218_match_table, please
ensure they're the same. I prefer spaces after '{' and before '}'.

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
