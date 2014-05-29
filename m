Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaE2HhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:37:21 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48444 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaE2HhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:37:20 -0400
Date: Thu, 29 May 2014 08:37:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH 4/5] mfd: axp209x: Drop the parent supplies field
Message-ID: <20140529073713.GF1954@lee--X1>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
 <1401297069-7423-5-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401297069-7423-5-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now that the regulator code get its parent supplies purely from the DT, we can
> drop the parent supplies resources in the MFD driver.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/mfd/axp20x.c | 11 -----------
>  1 file changed, 11 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
> index 5734f8c82abf..6231adbb295d 100644
> --- a/drivers/mfd/axp20x.c
> +++ b/drivers/mfd/axp20x.c
> @@ -140,15 +140,6 @@ static const struct regmap_irq_chip axp20x_regmap_irq_chip = {
>  	.init_ack_masked	= true,
>  };
>  
> -static const char * axp20x_supplies[] = {
> -	"acin",
> -	"vin2",
> -	"vin3",
> -	"ldo24in",
> -	"ldo3in",
> -	"ldo5in",
> -};
> -
>  static struct mfd_cell axp20x_cells[] = {
>  	{
>  		.name			= "axp20x-pek",
> @@ -156,8 +147,6 @@ static struct mfd_cell axp20x_cells[] = {
>  		.resources		= axp20x_pek_resources,
>  	}, {
>  		.name			= "axp20x-regulator",
> -		.parent_supplies	= axp20x_supplies,
> -		.num_parent_supplies	= ARRAY_SIZE(axp20x_supplies),
>  	},
>  };
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
