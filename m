Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaBMLgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:36:53 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60661 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaBMLgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:36:51 -0500
Date: Thu, 13 Feb 2014 11:36:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Adam Thomson <adam.thomson@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/2] mfd: da9055: Add DT support for PMIC
Message-ID: <20140213113643.GM32508@lee--X1>
References: <cover.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
 <e11bde69763b77a6b17b851c7d18a892d193411f.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e11bde69763b77a6b17b851c7d18a892d193411f.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> ---
>  drivers/mfd/da9055-i2c.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/da9055-i2c.c b/drivers/mfd/da9055-i2c.c
> index 8103e43..d4d4c16 100644
> --- a/drivers/mfd/da9055-i2c.c
> +++ b/drivers/mfd/da9055-i2c.c
> @@ -15,6 +15,8 @@
>  #include <linux/device.h>
>  #include <linux/i2c.h>
>  #include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> 
>  #include <linux/mfd/da9055/core.h>
> 
> @@ -66,6 +68,11 @@ static struct i2c_device_id da9055_i2c_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, da9055_i2c_id);
> 
> +static const struct of_device_id da9055_of_match[] = {
> +       { .compatible = "dlg,da9055-pmic", },
> +       { }
> +};
> +
>  static struct i2c_driver da9055_i2c_driver = {
>         .probe = da9055_i2c_probe,
>         .remove = da9055_i2c_remove,
> @@ -73,6 +80,7 @@ static struct i2c_driver da9055_i2c_driver = {
>         .driver = {
>                 .name = "da9055-pmic",
>                 .owner = THIS_MODULE,
> +               .of_match_table = of_match_ptr(da9055_of_match),
>         },
>  };

Patch looks okay to me, but needs an Ack from the DT guys.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
