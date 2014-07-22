Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbaGVOaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:30:08 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40142 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaGVOaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:30:06 -0400
Message-ID: <53CE7566.8020906@gmail.com>
Date: Tue, 22 Jul 2014 19:59:58 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org
CC: kgene.kim@samsung.com, pawel.moll@arm.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        galak@codeaurora.org, ch.naveen@samsung.com,
        linux-input <linux-input@vger.kernel.org>, heiko.stuebner@bq.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2] iio: exynos-adc: add experimental touchscreen support
References: <5068889.1KfVx3ksNo@wuerfel>
In-Reply-To: <5068889.1KfVx3ksNo@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 22 July 2014 06:33 PM, Arnd Bergmann wrote:

(...)

>   
> +static int exynos_read_s3c64xx_ts(struct iio_dev *indio_dev, int *x, int *y)
> +{
> +	struct exynos_adc *info = iio_priv(indio_dev);
> +	unsigned long timeout;
> +	int ret;
> +
> +	mutex_lock(&indio_dev->mlock);
> +	info->read_ts = true;
> +
> +	reinit_completion(&info->completion);
> +
> +	writel(ADC_S3C2410_TSC_PULL_UP_DISABLE | ADC_TSC_AUTOPST,
> +	       ADC_V1_TSC(info->regs));
> +
> +	/* Select the ts channel to be used and Trigger conversion */
> +	info->data->start_conv(info, ADC_S3C2410_MUX_TS);
> +
> +	timeout = wait_for_completion_timeout
> +			(&info->completion, EXYNOS_ADC_TIMEOUT);

Should be properly aligned:

	wait_for_completion_timeout(&info->completion,
				    EXYNOS_ADC_TIMEOUT);

-- 
Regards,
Varka Bhadram

