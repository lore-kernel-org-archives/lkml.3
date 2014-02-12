Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaBLI7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:59:25 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:34163 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaBLI7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:59:23 -0500
Date: Wed, 12 Feb 2014 08:59:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 02/14] mfd: sec: Select different RTC regmaps for devices
Message-ID: <20140212085913.GP15081@lee--X1>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
 <1392123837-5517-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392123837-5517-3-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch prepares for adding support for S2MPS14 RTC driver by
> selecting different regmaps for S2MPS1X/S5M876X RTC devices.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/sec-core.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index 6021c54f74cf..0efa69e123ee 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -199,7 +199,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
>  			    const struct i2c_device_id *id)
>  {
>  	struct sec_platform_data *pdata = dev_get_platdata(&i2c->dev);
> -	const struct regmap_config *regmap;
> +	const struct regmap_config *regmap, *regmap_rtc;
>  	struct sec_pmic_dev *sec_pmic;
>  	int ret;
>  
> @@ -233,15 +233,25 @@ static int sec_pmic_probe(struct i2c_client *i2c,
>  	switch (sec_pmic->device_type) {
>  	case S2MPS11X:
>  		regmap = &s2mps11_regmap_config;
> +		/*
> +		 * The rtc-s5m driver does not support S2MPS11 and there
> +		 * is no mfd_cell for S2MPS11 RTC device.
> +		 * However we must pass something to devm_regmap_init_i2c()
> +		 * so use S5M-like regmap config even though it wouldn't work.
> +		 */
> +		regmap_rtc = &sec_rtc_regmap_config;

An odd predicament, but it doesn't look as though the semantics have
changed.

I guess this set will need to go in as one so for now:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
