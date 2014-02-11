Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaBKMX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:23:56 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:49173 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaBKMXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:23:53 -0500
Date: Tue, 11 Feb 2014 12:23:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 7/7] mfd: max8998: Fix possible NULL pointer dereference
 on i2c_new_dummy error
Message-ID: <20140211122346.GV32042@lee--X1>
References: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
 <1392113015-11180-7-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392113015-11180-7-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Krzysztof Kozlowski wrote:

> During probe the driver allocates dummy I2C device for RTC with i2c_new_dummy() but it does not check the return value of this call.
> 
> In case of error (i2c_new_device(): memory allocation failure or I2C
> address cannot be used) this function returns NULL which is later used
> by i2c_unregister_device().
> 
> If i2c_new_dummy() fails for RTC device, fail also the probe for
> main MFD driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mfd/max8998.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
> index 612ca404e150..61ea1826f8b4 100644
> --- a/drivers/mfd/max8998.c
> +++ b/drivers/mfd/max8998.c
> @@ -215,6 +215,10 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
>  	mutex_init(&max8998->iolock);
>  
>  	max8998->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
> +	if (!max8998->rtc) {
> +		dev_err(&i2c->dev, "Failed to allocate I2C device for RTC\n");
> +		return -ENODEV;
> +	}
>  	i2c_set_clientdata(max8998->rtc, max8998);
>  
>  	max8998_irq_init(max8998);

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
