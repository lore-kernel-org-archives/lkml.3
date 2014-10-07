Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaJGIwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:52:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16860 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaJGIwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:52:34 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-da-5433a9cfe362
Message-id: <5433A9CD.8090007@samsung.com>
Date: Tue, 07 Oct 2014 10:52:29 +0200
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Markus Pargmann <mpa@pengutronix.de>, Mark Brown <broonie@kernel.org>
Cc: kernel@pengutronix.de, Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] regulator: Remove unnecessary ena_gpio initializations
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-6-git-send-email-mpa@pengutronix.de>
In-reply-to: <1412626635-7404-6-git-send-email-mpa@pengutronix.de>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xy7rnVxqHGMx/ymMx9eETNovXLwwt
	Vk3dyWLx7UoHk8Wmx9dYLS7vmsNmcep2L7sDu8fOWXfZPTat6mTz2Lyk3qP/r4FH35ZVjB6f
	N8kFsEVx2aSk5mSWpRbp2yVwZbQvuM5YsJu/YtPHk2wNjG95uhg5OSQETCSu7/nFBmGLSVy4
	tx7MFhJYyijR9Dm0i5ELyP7MKPFq5kRGkASvgJbEj1n/WUFsFgFViW8zj7GA2GwCHhLTvvcw
	g9iiAhESJ+/uYYeoF5T4MfkeWI2IgKfEunV3WUGGMgu0MErc3H+YCSQhLOAvMXv7WWaIzZUS
	32Z9BlvGKeAksWXBBbA4s4CZxKOWdVC2vMTmNW+ZJzAKzEKyYxaSsllIyhYwMq9iFE0tTS4o
	TkrPNdQrTswtLs1L10vOz93ECAn1LzsYFx+zOsQowMGoxMO7wdA4RIg1say4MvcQowQHs5II
	75YKoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGDWE7+TWqD498n/f81dcEpo6Q4o6IAD6fvfsP
	JCd+zjscf17Wp3hvtcPvKx/ze5kfFn9Z8WthWL6g2n72H8fY237/2zL3wO8n3w66NezqnjLp
	5/0fN3bfM/6YoNYwX9ZrosqduYeelPRl1qma3b1zj01/98e+fz2P8vStC3aFHZI6MXfhnmmb
	7yixFGckGmoxFxUnAgAdfjCIUwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.10.2014 22:17, Markus Pargmann wrote:
> It is not necessary to setup config.ena_gpio with -EINVAL or similar.
> This patch removes these unnecessary initializations.
>
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> ---
>   drivers/regulator/pfuze100-regulator.c | 1 -
>   drivers/regulator/s5m8767.c            | 2 --
>   2 files changed, 3 deletions(-)
>
> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> index c879dff597ee..d7455ee309bf 100644
> --- a/drivers/regulator/pfuze100-regulator.c
> +++ b/drivers/regulator/pfuze100-regulator.c
> @@ -509,7 +509,6 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
>   		config.init_data = init_data;
>   		config.driver_data = pfuze_chip;
>   		config.of_node = match_of_node(i);
> -		config.ena_gpio = -EINVAL;
>
>   		pfuze_chip->regulators[i] =
>   			devm_regulator_register(&client->dev, desc, &config);
> diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
> index d258e6613831..2c7817f12516 100644
> --- a/drivers/regulator/s5m8767.c
> +++ b/drivers/regulator/s5m8767.c
> @@ -949,8 +949,6 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
>   		config.driver_data = s5m8767;
>   		config.regmap = iodev->regmap_pmic;
>   		config.of_node = pdata->regulators[i].reg_node;
> -		config.ena_gpio = -EINVAL;
> -		config.ena_gpio_flags = 0;
>   		if (gpio_is_valid(pdata->regulators[i].ext_control_gpio))
>   			s5m8767_regulator_config_ext_control(s5m8767,
>   					&pdata->regulators[i], &config);

This would bring back problem with carried over ena_gpio (commit 
f4fbb3ce342bc1 "regulator: s5m8767: Fix carried over ena_gpio assignment").

The "config" is re-used in loop for next regulators. This means that the 
"config.ena_gpio" has to be set here to prevent using the same value for 
next regulator.

I think these lines shouldn't be removed.

Best regards,
Krzysztof
