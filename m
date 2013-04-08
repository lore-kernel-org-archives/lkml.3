Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393Ab3DHHxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:53:34 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:40515 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3DHHxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 03:53:33 -0400
Date: Mon, 8 Apr 2013 08:53:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: ab8500-ext: Remove get_voltage to avoid
 duplicate implementation
Message-ID: <20130408075328.GD3084@gmail.com>
References: <1365347548.9931.1.camel@phoenix>
 <1365347870.9931.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1365347870.9931.7.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Apr 2013, Axel Lin wrote:

> The implementation of ab8500_ext_fixed_get_voltage is identical to
> ab8500_ext_list_voltage. We can avoid the duplicate implementation by just
> remove get_voltage. For fixed regulator, regulator core will call
> list_voltage(rdev, 0) to get voltage if both get_voltage get_voltage_sel are
> not implemented.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Nice simplification:

Acked-by: Lee Jones <lee.jones@linaro.org>

> ---
>  drivers/regulator/ab8500-ext.c |   16 ----------------
>  1 file changed, 16 deletions(-)
> 
> diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> index c7896af..9aee21c 100644
> --- a/drivers/regulator/ab8500-ext.c
> +++ b/drivers/regulator/ab8500-ext.c
> @@ -237,21 +237,6 @@ static unsigned int ab8500_ext_regulator_get_mode(struct regulator_dev *rdev)
>  	return ret;
>  }
>  
> -static int ab8500_ext_fixed_get_voltage(struct regulator_dev *rdev)
> -{
> -	struct regulation_constraints *regu_constraints = rdev->constraints;
> -
> -	if (regu_constraints == NULL) {
> -		dev_err(rdev_get_dev(rdev), "regulator constraints null pointer\n");
> -		return -EINVAL;
> -	}
> -	if (regu_constraints->min_uV && regu_constraints->max_uV) {
> -		if (regu_constraints->min_uV == regu_constraints->max_uV)
> -			return regu_constraints->min_uV;
> -	}
> -	return -EINVAL;
> -}
> -
>  static int ab8500_ext_list_voltage(struct regulator_dev *rdev,
>  				   unsigned selector)
>  {
> @@ -275,7 +260,6 @@ static struct regulator_ops ab8500_ext_regulator_ops = {
>  	.is_enabled		= ab8500_ext_regulator_is_enabled,
>  	.set_mode		= ab8500_ext_regulator_set_mode,
>  	.get_mode		= ab8500_ext_regulator_get_mode,
> -	.get_voltage		= ab8500_ext_fixed_get_voltage,
>  	.list_voltage		= ab8500_ext_list_voltage,
>  };
>  

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
