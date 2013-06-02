Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab3FBPMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 11:12:53 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48377 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3FBPMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 11:12:44 -0400
Message-ID: <51AB60F1.5060002@jic23.retrosnub.co.uk>
Date: Sun, 02 Jun 2013 16:12:49 +0100
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonghwan Choi <jhbird.choi@samsung.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Jonathan Cameron'" <jic23@kernel.org>
Subject: Re: [PATCH 3.9-stable] staging:iio:light:tsl2x7x: fix the error handling
 in tsl2x7x_probe()
References: <000101ce5828$545e10b0$fd1a3210$%choi@samsung.com>
In-Reply-To: <000101ce5828$545e10b0$fd1a3210$%choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 03:42 AM, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?
It's a pretty unlikely problem to hit in reality so up to you on whether
you think it worth picking up.  Also note that only the -EINVAL bit
is actually a fix. The rest of it was some incidental tidying up.

Jonathan

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

