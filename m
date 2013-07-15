Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3GOOZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:25:07 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36615 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab3GOOZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:25:05 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Otavio Salvador <otavio@ossystems.com.br>
Subject: Re: [PATCH 2/5] ARM: mxs-lradc: Simplify mxs_lradc_trigger_init error handle
Date: Mon, 15 Jul 2013 16:24:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Lars-Peter Clausen" <lars@metafoo.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br> <1373898160-8460-2-git-send-email-otavio@ossystems.com.br>
In-Reply-To: <1373898160-8460-2-git-send-email-otavio@ossystems.com.br>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307151624.57438.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Otavio Salvador,

> As we have a 'ret' variable with the iio_trigger_register return, this
> can be used as result.
> 
> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
> ---
>  drivers/staging/iio/adc/mxs-lradc.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c
> b/drivers/staging/iio/adc/mxs-lradc.c index d92c97a..6d41846 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -671,14 +671,12 @@ static int mxs_lradc_trigger_init(struct iio_dev
> *iio) trig->ops = &mxs_lradc_trigger_ops;
> 
>  	ret = iio_trigger_register(trig);
> -	if (ret) {
> +	if (ret)
>  		iio_trigger_free(trig);
> -		return ret;
> -	}
> 
>  	iio->trig = trig;


You are still setting iio->trig , you dont want to do that in case of failure

> -	return 0;
> +	return ret;
>  }
> 
>  static void mxs_lradc_trigger_remove(struct iio_dev *iio)

Best regards,
Marek Vasut
