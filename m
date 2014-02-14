Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaBNJer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:34:47 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57180 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaBNJeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:34:44 -0500
Date: Fri, 14 Feb 2014 09:34:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [RFC V1] mfd: da9063: Add support for production silicon variant
 code
Message-ID: <20140214093435.GI3403@lee--X1>
References: <201402131031.s1DAVWrJ023725@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201402131031.s1DAVWrJ023725@swsrvapps-01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> 
> Add the correct silicon variant code ID (0x5) to the driver. This
> new code is the 'production' variant code ID for DA9063.
>  
> This patch will remove the older variant code ID which matches the
> pre-production silicon ID (0x3) for the DA9063 chip.
> 
> There is also some small amount of correction done in this patch: it
> renames various incorrectly named variables and moves the dev_info()
> call before the variant ID test.
> 
> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> ---
> 
>  drivers/mfd/da9063-core.c       | 36 ++++++++++++++++++++----------------
>  include/linux/mfd/da9063/core.h |  7 ++++++-
>  2 files changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
> index 26937cd..80ce35a 100644
> --- a/drivers/mfd/da9063-core.c
> +++ b/drivers/mfd/da9063-core.c
> @@ -1,3 +1,4 @@
> +

Unnecessary new line.

<snip>

> +	da9063->model = chip_id;

Why have you gone to lengths to rename 'model' to 'chip_id' locally,
but still call it 'model' in the global container?

> diff --git a/include/linux/mfd/da9063/core.h b/include/linux/mfd/da9063/core.h
> index 2d2a0af..2265ccb 100644
> --- a/include/linux/mfd/da9063/core.h
> +++ b/include/linux/mfd/da9063/core.h
> @@ -1,3 +1,4 @@
> +

Remove this.

>  /*
>   * Definitions for DA9063 MFD driver
>   *
> @@ -33,6 +34,10 @@ enum da9063_models {
>  	PMIC_DA9063 = 0x61,
>  };
>  
> +enum da9063_variant_codes {
> +	PMIC_DA9063_BB = 0x5

Why not support both? It's only an extra few chars in the if().

> +};
> +
>  /* Interrupts */
>  enum da9063_irqs {
>  	DA9063_IRQ_ONKEY = 0,
> @@ -72,7 +77,7 @@ struct da9063 {
>  	/* Device */
>  	struct device	*dev;
>  	unsigned short	model;

Don't you want to change this to chip_id?

> -	unsigned short	revision;
> +	unsigned char	variant_code;
>  	unsigned int	flags;
>  
>  	/* Control interface */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
