Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946030AbaD3Us2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:48:28 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:59369 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaD3Us0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:48:26 -0400
Message-ID: <536161F5.7090508@kernel.org>
Date: Wed, 30 Apr 2014 21:49:57 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, t.figa@samsung.com
Subject: Re: [PATCH 5/5 v3] iio: exynos_adc: do a reinit_completion before
 the conversion
References: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com> <1398850015-17761-6-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1398850015-17761-6-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/14 10:26, Naveen Krishna Chatradhi wrote:
> Add reinit_completion() before the wait_for_completion_timeout in
> raw_read() call.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
Applied to the togreg branch of iio.git
I wasn't sure if this one was technically a fix, but as it isn't
marked clearly as such it can go in during the next merge window.
I won't have pushed this out to a non rebasing branch until tomorrow
so if this fixes an observed issue then let me know and it might move
to the fixes-togreg branch.

Thanks,

Jonathan
> ---
> Changes since v2:
> None
> Changes since v1:
> None
> v0:
> This change is a part of the patch reviewed at https://lkml.org/lkml/2013/11/5/92
>
>   drivers/iio/adc/exynos_adc.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index eddc58e..010578f 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -151,6 +151,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>   		return -EINVAL;
>
>   	mutex_lock(&indio_dev->mlock);
> +	reinit_completion(&info->completion);
>
>   	/* Select the channel to be used and Trigger conversion */
>   	if (info->version == ADC_V2) {
>

