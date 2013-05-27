Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab3E0KeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:34:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49983 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3E0KeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:34:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Jonathan Cameron'" <jic23@kernel.org>
Subject: Re: [PATCH 3.9-stable] staging:iio:light:tsl2x7x: fix the error handling in tsl2x7x_probe()
References: <000101ce5828$545e10b0$fd1a3210$%choi@samsung.com>
Date: Mon, 27 May 2013 11:33:59 +0100
In-Reply-To: <000101ce5828$545e10b0$fd1a3210$%choi@samsung.com> (Jonghwan
	Choi's message of "Fri, 24 May 2013 11:42:27 +0900")
Message-ID: <871u8sogo8.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonghwan,

Jonghwan Choi <jhbird.choi@samsung.com> writes:

> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

I'm queuing this patch to the 3.5 kernel as well, as it looks like it
is also applicable.

Cheers,
-- 
Luis


>
> ------------------
>
> From: "Wei Yongjun <yongjun_wei@trendmicro.com.cn>"
>
> commit 3b813798aa7030f1beef638c75f8b0008f737a82 upstream
>
> Fix to return -EINVAL in the i2c device found error handling
> case instead of 0, as done elsewhere in this function.
> And also correct the fail1 and fail2 lable to do the right thing.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> Signed-off-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/staging/iio/light/tsl2x7x_core.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/iio/light/tsl2x7x_core.c
> b/drivers/staging/iio/light/tsl2x7x_core.c
> index a58731e..2d40c03 100644
> --- a/drivers/staging/iio/light/tsl2x7x_core.c
> +++ b/drivers/staging/iio/light/tsl2x7x_core.c
> @@ -1869,6 +1869,7 @@ static int tsl2x7x_probe(struct i2c_client *clientp,
>  		dev_info(&chip->client->dev,
>  				"%s: i2c device found does not match
> expected id\n",
>  				__func__);
> +		ret = -EINVAL;
>  		goto fail1;
>  	}
>  
> @@ -1907,7 +1908,7 @@ static int tsl2x7x_probe(struct i2c_client *clientp,
>  		if (ret) {
>  			dev_err(&clientp->dev,
>  				"%s: irq request failed", __func__);
> -			goto fail2;
> +			goto fail1;
>  		}
>  	}
>  
> @@ -1920,17 +1921,17 @@ static int tsl2x7x_probe(struct i2c_client *clientp,
>  	if (ret) {
>  		dev_err(&clientp->dev,
>  			"%s: iio registration failed\n", __func__);
> -		goto fail1;
> +		goto fail2;
>  	}
>  
>  	dev_info(&clientp->dev, "%s Light sensor found.\n", id->name);
>  
>  	return 0;
>  
> -fail1:
> +fail2:
>  	if (clientp->irq)
>  		free_irq(clientp->irq, indio_dev);
> -fail2:
> +fail1:
>  	iio_device_free(indio_dev);
>  
>  	return ret;
