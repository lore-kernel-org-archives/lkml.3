Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaBLJ6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:58:39 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40405 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaBLJ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:58:37 -0500
Date: Wed, 12 Feb 2014 09:58:28 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mfd: 88pm800: Fix I2C device resource leak if probe fails
Message-ID: <20140212095828.GW15081@lee--X1>
References: <1392198701-20547-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392198701-20547-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> During probe the driver allocates two dummy I2C devices for subchips in
> function pm800_pages_init(). Additionally this function allocates
> regmaps for these subchips. If any of these steps fail then these dummy
> I2C devices are not freed and resources leak.
> 
> On pm800_pages_init() fail the driver must call pm800_pages_exit() to
> unregister dummy I2C devices.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mfd/88pm800.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
> index 7dca1e640970..28627c1ff9da 100644
> --- a/drivers/mfd/88pm800.c
> +++ b/drivers/mfd/88pm800.c
> @@ -586,8 +586,8 @@ static int pm800_probe(struct i2c_client *client,
>  	return 0;
>  
>  err_device_init:
> -	pm800_pages_exit(chip);
>  err_page_init:
> +	pm800_pages_exit(chip);
>  err_subchip_alloc:
>  	pm80x_deinit();
>  out_init:

If you're going to do this, then can you clean-up the superfluous
goto labels please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
