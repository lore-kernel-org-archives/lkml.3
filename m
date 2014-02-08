Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaBHLqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 06:46:09 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:41100 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaBHLqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 06:46:07 -0500
Message-ID: <52F6191D.3070404@kernel.org>
Date: Sat, 08 Feb 2014 11:46:37 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: max1363: Use devm_regulator_get_optional for optional
 regulator
References: <1390846227-28320-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1390846227-28320-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/14 18:10, Guenter Roeck wrote:
> In kernel version 3.13, devm_regulator_get() may return no error
> if a regulator is undeclared. regulator_get_voltage() will return
> -EINVAL if this happens. This causes the driver to fail loading if
> the vref regulator is not declared.
>
> Since vref is optional, call devm_regulator_get_optional instead.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Applied and marked for stable.

Thanks,
> ---
> Should be a candidate for -stable (v3.12+).
>
>   drivers/iio/adc/max1363.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
> index e283f2f..3602592 100644
> --- a/drivers/iio/adc/max1363.c
> +++ b/drivers/iio/adc/max1363.c
> @@ -1560,7 +1560,7 @@ static int max1363_probe(struct i2c_client *client,
>   	st->client = client;
>
>   	st->vref_uv = st->chip_info->int_vref_mv * 1000;
> -	vref = devm_regulator_get(&client->dev, "vref");
> +	vref = devm_regulator_get_optional(&client->dev, "vref");
>   	if (!IS_ERR(vref)) {
>   		int vref_uv;
>
>

