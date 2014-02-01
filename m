Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbaBAOqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 09:46:09 -0500
Received: from smtp-out-059.synserver.de ([212.40.185.59]:1067 "EHLO
	smtp-out-052.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751640AbaBAOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 09:46:07 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24163
Message-ID: <52ED08AD.9060403@metafoo.de>
Date: Sat, 01 Feb 2014 15:46:05 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Johannes Thumshirn <morbidrsa@gmail.com>
CC: Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adc: viperboard: Call platform_set_drvdata before
 devm_iio_device_register
References: <1391265593-13986-1-git-send-email-morbidrsa@gmail.com>
In-Reply-To: <1391265593-13986-1-git-send-email-morbidrsa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 03:39 PM, Johannes Thumshirn wrote:
> Call platform_set_drvdata before devm_iio_device_register to avoid possible
> race condition when accessing driver data.

I don't think the driver data is accessed from within any of the IIO device
callbacks. In fact I don't think it is accessed at all with the latest
conversion to devm_iio_device_register(). So I think the call to
platform_set_drvdata can just be removed.

> 
> Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
> ---
>  drivers/iio/adc/viperboard_adc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/adc/viperboard_adc.c b/drivers/iio/adc/viperboard_adc.c
> index d0add8f..7d9bd05 100644
> --- a/drivers/iio/adc/viperboard_adc.c
> +++ b/drivers/iio/adc/viperboard_adc.c
> @@ -133,14 +133,14 @@ static int vprbrd_adc_probe(struct platform_device *pdev)
>  	indio_dev->channels = vprbrd_adc_iio_channels;
>  	indio_dev->num_channels = ARRAY_SIZE(vprbrd_adc_iio_channels);
>  
> +	platform_set_drvdata(pdev, indio_dev);
> +
>  	ret = devm_iio_device_register(&pdev->dev, indio_dev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "could not register iio (adc)");
>  		return ret;
>  	}
>  
> -	platform_set_drvdata(pdev, indio_dev);
> -
>  	return 0;
>  }
>  
> 

