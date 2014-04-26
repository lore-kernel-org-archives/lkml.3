Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaDZKDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 06:03:20 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:54799 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaDZKDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 06:03:19 -0400
Message-ID: <535B84BE.8020005@kernel.org>
Date: Sat, 26 Apr 2014 11:04:46 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jimmy Li <coder.liss@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]staging:iio:ad2s1200 fix missing parenthesis in a for
 statment.
References: <20140425025229.GA12200@gmail.com>
In-Reply-To: <20140425025229.GA12200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 03:52, Jimmy Li wrote:
> Signed-off-by: Jimmy Li <coder.liss@gmail.com>

Applied to the fixes-togreg branch of iio.git

Thanks,
> ---
>   drivers/staging/iio/resolver/ad2s1200.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/iio/resolver/ad2s1200.c b/drivers/staging/iio/resolver/ad2s1200.c
> index e2b4820..017d2f8 100644
> --- a/drivers/staging/iio/resolver/ad2s1200.c
> +++ b/drivers/staging/iio/resolver/ad2s1200.c
> @@ -107,7 +107,7 @@ static int ad2s1200_probe(struct spi_device *spi)
>   	int pn, ret = 0;
>   	unsigned short *pins = spi->dev.platform_data;
>
> -	for (pn = 0; pn < AD2S1200_PN; pn++)
> +	for (pn = 0; pn < AD2S1200_PN; pn++) {
>   		ret = devm_gpio_request_one(&spi->dev, pins[pn], GPIOF_DIR_OUT,
>   					    DRV_NAME);
>   		if (ret) {
> @@ -115,6 +115,7 @@ static int ad2s1200_probe(struct spi_device *spi)
>   							pins[pn]);
>   			return ret;
>   		}
> +	}
>   	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*st));
>   	if (!indio_dev)
>   		return -ENOMEM;
>

