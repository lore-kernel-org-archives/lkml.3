Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaCELFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:05:09 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:31160 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaCELFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:05:07 -0500
Message-ID: <531704DA.5000200@atmel.com>
Date: Wed, 5 Mar 2014 19:04:58 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jonathan Cameron <jic23@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH] iio: adc: at91_adc: correct default shtim value
References: <1393870024-20704-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1393870024-20704-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alexandre

On 3/4/2014 2:07 AM, Alexandre Belloni wrote:
> When sample_hold_time is zero (this is the case when DT is not used or if
> atmel,adc-sample-hold-time is omitted), then the calculated shtim is large.
>
> Make that 0, which is the default for that register and the ADC will then use a
> sane value of 2/ADCCLK or 1/ADCCLK depending on the version.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Thanks for the fix and

Acked-by: Josh Wu<josh.wu@atmel.com>

Best Regards,
Josh Wu
> ---
>   drivers/iio/adc/at91_adc.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
> index 5b1aa027c034..0b103f905607 100644
> --- a/drivers/iio/adc/at91_adc.c
> +++ b/drivers/iio/adc/at91_adc.c
> @@ -1004,8 +1004,11 @@ static int at91_adc_probe(struct platform_device *pdev)
>   	 * the best converted final value between two channels selection
>   	 * The formula thus is : Sample and Hold Time = (shtim + 1) / ADCClock
>   	 */
> -	shtim = round_up((st->sample_hold_time * adc_clk_khz /
> -			  1000) - 1, 1);
> +	if (st->sample_hold_time > 0)
> +		shtim = round_up((st->sample_hold_time * adc_clk_khz / 1000)
> +				 - 1, 1);
> +	else
> +		shtim = 0;
>   
>   	reg = AT91_ADC_PRESCAL_(prsc) & st->registers->mr_prescal_mask;
>   	reg |= AT91_ADC_STARTUP_(ticks) & st->registers->mr_startup_mask;

