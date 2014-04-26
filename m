Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaDZMxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 08:53:00 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55700 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaDZMwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 08:52:18 -0400
Message-ID: <535BAC5B.2090707@kernel.org>
Date: Sat, 26 Apr 2014 13:53:47 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org
Subject: Re: [PATCH 1/5 v2] iio: exynos_adc: use indio_dev->dev structure
 to handle child nodes
References: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com> <1398512276-4105-2-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1398512276-4105-2-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/14 12:37, Naveen Krishna Chatradhi wrote:
> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>
> Using pdev->dev with device_for_each_child() would iterate over all
> of the children of the platform device and delete them.
> Thus, causing crashes during module unload.
>
> We should be using the indio_dev->dev structure for
> registering/unregistering child nodes.
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> Reported-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
> ---
Oops, I applied this one earlier (from v1) but didn't send the email...
Never mind as there were no changes.
> This change was tested on top of
>     https://lkml.org/lkml/2014/4/21/481 from Doug.
>
>   drivers/iio/adc/exynos_adc.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index d25b262..affa93f 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -344,7 +344,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
>
>   	exynos_adc_hw_init(info);
>
> -	ret = of_platform_populate(np, exynos_adc_match, NULL, &pdev->dev);
> +	ret = of_platform_populate(np, exynos_adc_match, NULL, &indio_dev->dev);
>   	if (ret < 0) {
>   		dev_err(&pdev->dev, "failed adding child nodes\n");
>   		goto err_of_populate;
> @@ -353,7 +353,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
>   	return 0;
>
>   err_of_populate:
> -	device_for_each_child(&pdev->dev, NULL,
> +	device_for_each_child(&indio_dev->dev, NULL,
>   				exynos_adc_remove_devices);
>   	regulator_disable(info->vdd);
>   	clk_disable_unprepare(info->clk);
> @@ -369,7 +369,7 @@ static int exynos_adc_remove(struct platform_device *pdev)
>   	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
>   	struct exynos_adc *info = iio_priv(indio_dev);
>
> -	device_for_each_child(&pdev->dev, NULL,
> +	device_for_each_child(&indio_dev->dev, NULL,
>   				exynos_adc_remove_devices);
>   	regulator_disable(info->vdd);
>   	clk_disable_unprepare(info->clk);
>

