Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaBCJzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:55:48 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:38550 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBCJzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:55:46 -0500
Date: Mon, 3 Feb 2014 09:55:41 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 10/18] mfd: max14577: Add detection of device type
Message-ID: <20140203095541.GK13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-11-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390911522-28209-11-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch continues the preparation for adding support for max77836
> device to existing max14577 driver.
> 
> Add enum for types of devices supported by this driver. The device type
> will be detected by matching of_device_id, or i2c_device_id as a
> fallback.
> 
> The patch also moves to separate function the code related to displaying
> DeviceID register values.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/mfd/max14577.c               |   61 +++++++++++++++++++++++-----------
>  include/linux/mfd/max14577-private.h |   12 ++++---
>  2 files changed, 50 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index 1d8104213b3e..224aba8c5b3f 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -20,6 +20,7 @@

<snip>

> +static void max14577_print_dev_type(struct maxim_core *maxim_core)
> +{
> +	u8 reg_data, vendor_id, device_id;
> +	int ret = max14577_read_reg(maxim_core->regmap_muic,
> +			MAXIM_MUIC_REG_DEVICEID, &reg_data);

I'm not a big fan of declaring variables whilst feeding them with
function return values. Can you separate the two please?

> +	if (ret) {
> +		dev_err(maxim_core->dev, "Failed to read DEVICEID
> register: %d\n",

I think this is too many chars.

> +				ret);
> +		return;
> +	}
> +

<snip>

> -	ret = max14577_read_reg(maxim_core->regmap_muic,
> -			MAXIM_MUIC_REG_DEVICEID, &reg_data);
> -	if (ret) {
> -		dev_err(maxim_core->dev, "Device not found on this channel: %d\n",
> -				ret);
> -		return ret;
> +	if (np) {
> +		const struct of_device_id *of_id =
> +			of_match_device(max14577_dt_match, &i2c->dev);

Again this is a bit messy. Bring it down onto a separate line.

> +		if (of_id)
> +			maxim_core->dev_type = (unsigned int)of_id->data;
> +	} else {
> +		maxim_core->dev_type = id->driver_data;
>  	}

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
