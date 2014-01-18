Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaARLbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:31:14 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38108 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaARLbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:31:08 -0500
Message-ID: <52DA6609.50009@kernel.org>
Date: Sat, 18 Jan 2014 11:31:21 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Marek Vasut <marex@denx.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iio: mxs-lradc: fix buffer overflow
References: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com> <1389628923-8689-2-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1389628923-8689-2-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/14 16:02, Alexandre Belloni wrote:
> Fixes:
> drivers/staging/iio/adc/mxs-lradc.c:1556 mxs_lradc_probe() error: buffer
> overflow 'iio->channels' 15 <= 15
>
> The reported available scales for in_voltage15 were also wrong.
>
> The realbits lookup is not necessary as all the channels of the LRADC have the
> same resolution, use LRADC_RESOLUTION instead.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Applied to the fixes-for-3.14new branch of iio.git.  This will go upstream
after 3.14-rc1 is tagged.

It's a little clunky having a simple array some of which isn't used for these
but I guess it does give fairly simple code.

Thanks,
> ---
>   drivers/staging/iio/adc/mxs-lradc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
> index df71669bb60e..aa86849daeba 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -1613,7 +1613,7 @@ static int mxs_lradc_probe(struct platform_device *pdev)
>   			 * of the array.
>   			 */
>   			scale_uv = ((u64)lradc->vref_mv[i] * 100000000) >>
> -				   (iio->channels[i].scan_type.realbits - s);
> +				   (LRADC_RESOLUTION - s);
>   			lradc->scale_avail[i][s].nano =
>   					do_div(scale_uv, 100000000) * 10;
>   			lradc->scale_avail[i][s].integer = scale_uv;
>
