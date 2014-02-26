Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaBZI3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 03:29:31 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64529 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaBZI33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 03:29:29 -0500
Date: Wed, 26 Feb 2014 08:29:22 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [RFCv3 3/7] mfd: twl4030-madc: Cleanup driver
Message-ID: <20140226082922.GH9195@lee--X1>
References: <1393193271-16717-1-git-send-email-sre@debian.org>
 <1393374270-20079-1-git-send-email-sre@debian.org>
 <1393374270-20079-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393374270-20079-4-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some style fixes in twl4030-madc driver.
> 
> Reported-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/mfd/twl4030-madc.c       | 108 ++++++++++++++++++---------------------
>  include/linux/i2c/twl4030-madc.h |   2 +-
>  2 files changed, 51 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
> index 81484ee..c23025b 100644
> --- a/drivers/mfd/twl4030-madc.c
> +++ b/drivers/mfd/twl4030-madc.c

>  /*
> - * Return battery temperature
> + * Return battery temperature in degree Celsius

degrees

<snip>

> -	int count = 0, count_req = 0, i;
> -	u8 reg;
> +	int count = 0, i;

Ugly, please declare on separate lines.

>  	for_each_set_bit(i, &channels, TWL4030_MADC_MAX_CHANNELS) {
> -		reg = reg_base + 2 * i;

Odd for this to be removed, as you calculate more than once now.

> -		buf[i] = twl4030_madc_channel_raw_read(madc, reg);
> +		buf[i] = twl4030_madc_channel_raw_read(madc, reg_base + 2 * i);

Better to bracket the math for clarity.

<snip>

> +			dev_err(madc->dev, "Unable to read register 0x%X\n",
> +				reg_base + 2 * i);

Here's the other calculation.

> +	regmask = (chan == 0) ? TWL4030_BCI_TYPEN : TWL4030_BCI_ITHEN;

regmask = chan ? TWL4030_BCI_ITHEN : TWL4030_BCI_TYPEN; 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
