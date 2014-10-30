Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbaJ3LmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:42:19 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33347 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759085AbaJ3LmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:42:16 -0400
Message-ID: <54522412.1070808@collabora.co.uk>
Date: Thu, 30 Oct 2014 12:42:10 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [RFT v3 05/14] regulator: max77802: Don't ignore return value
 of current opmode
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com> <1414668053-31370-6-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1414668053-31370-6-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/30/2014 12:20 PM, Krzysztof Kozlowski wrote:
> The return value of regmap_read() of current opmode for regulator was
> silently ignored and whatever happened to be in 'val' variable was used
> as new opmode. This could lead to using bogus opmode.
> 
> Don't ignore what regmap_read() returns. If it fails just fall back to
> normal opmode.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/regulator/max77802.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
> index b9958d927297..60daca2028e9 100644
> --- a/drivers/regulator/max77802.c
> +++ b/drivers/regulator/max77802.c
> @@ -606,7 +606,13 @@ static int max77802_pmic_probe(struct platform_device *pdev)
>  		config.of_node = pdata->regulators[i].of_node;
>  
>  		ret = regmap_read(iodev->regmap, regulators[i].enable_reg, &val);
> -		val = val >> shift & MAX77802_OPMODE_MASK;
> +		if (ret < 0) {
> +			dev_warn(&pdev->dev,
> +				"cannot read current mode for %d\n", i);
> +			val = MAX77802_OPMODE_NORMAL;
> +		} else {
> +			val = val >> shift & MAX77802_OPMODE_MASK;
> +		}
>  
>  		/*
>  		 * If the regulator is disabled and the system warm rebooted,
> 

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
