Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3LPRHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:07:38 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:40062 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab3LPRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:07:35 -0500
Date: Mon, 16 Dec 2013 17:07:28 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: (max8997) Handle the potential error for
 mfd_add_devices
Message-ID: <20131216170728.GU18769@lee--X1>
References: <1387195317-2876-1-git-send-email-lpapp@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387195317-2876-1-git-send-email-lpapp@kde.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The $SUBJECT line does not conform to what's expected of MFD commits.

The $SUBJECT line is vague and you are missing a commit body.

Please read:
  Documentation/SubmittingPatches

Specifically No2.

> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
>  drivers/mfd/max8997.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index 791aea3..ace1a2b 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -227,19 +227,19 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  	pm_runtime_set_active(max8997->dev);
>  
>  	max8997_irq_init(max8997);
> -

Why have you removed this line?

> -	mfd_add_devices(max8997->dev, -1, max8997_devs,
> +	ret = mfd_add_devices(max8997->dev, -1, max8997_devs,
>  			ARRAY_SIZE(max8997_devs),
>  			NULL, 0, NULL);
> +	if (ret < 0) {
> +		dev_err(max8997->dev, "cannot add mfd cells\n");

We're adding devices here, not cells.

  "failed to add devices"

> +		goto err_mfd;
> +	}
>  
>  	/*
>  	 * TODO: enable others (flash, muic, rtc, battery, ...) and
>  	 * check the return value
>  	 */
>  
> -	if (ret < 0)
> -		goto err_mfd;
> -
>  	/* MAX8997 has a power button input. */
>  	device_init_wakeup(max8997->dev, pdata->wakeup);
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
