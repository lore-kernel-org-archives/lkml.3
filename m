Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbaFQQTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:19:48 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59904 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933512AbaFQQTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:19:45 -0400
Date: Tue, 17 Jun 2014 17:19:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 4/9] mfd: palmas: Add tps65917 support
Message-ID: <20140617161940.GO29841@lee--X1>
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
 <1401272423-25761-5-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401272423-25761-5-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add tps65917 PMIC support. tps65917 is a subset of palmas PMIC.
> Some of the register definitions and the interrupt mappings
> are different.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  drivers/mfd/palmas.c |  176 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 171 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> index d280d78..485d755 100644
> --- a/drivers/mfd/palmas.c
> +++ b/drivers/mfd/palmas.c

[...]

> +struct palmas_driver_data {
> +	unsigned int *features;
> +	struct regmap_irq_chip *irq_chip;
> +};
> +
> +static struct palmas_driver_data palmas_data = {
> +	.features = &palmas_features,
> +	.irq_chip = &palmas_irq_chip,
> +};
> +
> +static struct palmas_driver_data tps659038_data = {
> +	.features = &tps659038_features,
> +	.irq_chip = &palmas_irq_chip,
> +};
> +
> +static struct palmas_driver_data tps65917_data = {
> +	.features = &tps659038_features,
> +	.irq_chip = &tps65917_irq_chip,
> +};
> +

[...]

> @@ -375,6 +539,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>  {
>  	struct palmas *palmas;
>  	struct palmas_platform_data *pdata;
> +	struct palmas_driver_data *driver_data;
>  	struct device_node *node = i2c->dev.of_node;
>  	int ret = 0, i;
>  	unsigned int reg, addr, *features;
> @@ -408,7 +573,8 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>  	if (!match)
>  		return -ENODATA;
>  
> -	features = (unsigned int *)match->data;
> +	driver_data = (struct palmas_driver_data *)match->data;
> +	features = (unsigned int *)driver_data->features;
>  	palmas->features = *features;

Couple of things a) I don't think the cast is required here and b) you
may as well do away with the local features variable here.

Just do:
  palmas->features = *driver_data->features;

Once fixed, re-submit with my:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
