Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaCVMdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 08:33:50 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53382 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaCVMdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 08:33:46 -0400
Message-ID: <532D836B.3010200@kernel.org>
Date: Sat, 22 Mar 2014 12:34:51 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 07/15] iio: adc: at91: add sam9rl support
References: <1395064628-644-1-git-send-email-alexandre.belloni@free-electrons.com> <1395064628-644-8-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395064628-644-8-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/14 13:57, Alexandre Belloni wrote:
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>   drivers/iio/adc/at91_adc.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
> index a51b8badbf8e..3b5bacd4d8da 100644
> --- a/drivers/iio/adc/at91_adc.c
> +++ b/drivers/iio/adc/at91_adc.c
> @@ -1346,6 +1346,20 @@ static struct at91_adc_caps at91sam9260_caps = {
>   	},
>   };
>
> +static struct at91_adc_caps at91sam9rl_caps = {
> +	.has_ts = true,
> +	.calc_startup_ticks = calc_startup_ticks_9260,	/* same as 9260 */
> +	.num_channels = 6,
> +	.registers = {
> +		.channel_base = AT91_ADC_CHR(0),
> +		.drdy_mask = AT91_ADC_DRDY,
> +		.status_register = AT91_ADC_SR,
> +		.trigger_register = AT91_ADC_TRGR_9G45,
> +		.mr_prescal_mask = AT91_ADC_PRESCAL_9260,
> +		.mr_startup_mask = AT91_ADC_STARTUP_9G45,
> +	},
> +};
> +
>   static struct at91_adc_caps at91sam9g45_caps = {
>   	.has_ts = true,
>   	.calc_startup_ticks = calc_startup_ticks_9260,	/* same as 9260 */
> @@ -1380,6 +1394,7 @@ static struct at91_adc_caps at91sam9x5_caps = {
>
>   static const struct of_device_id at91_adc_dt_ids[] = {
>   	{ .compatible = "atmel,at91sam9260-adc", .data = &at91sam9260_caps },
> +	{ .compatible = "atmel,at91sam9rl-adc", .data = &at91sam9rl_caps },
>   	{ .compatible = "atmel,at91sam9g45-adc", .data = &at91sam9g45_caps },
>   	{ .compatible = "atmel,at91sam9x5-adc", .data = &at91sam9x5_caps },
>   	{},
> @@ -1391,6 +1406,9 @@ static const struct platform_device_id at91_adc_ids[] = {
>   		.name = "at91sam9260-adc",
>   		.driver_data = (unsigned long)&at91sam9260_caps,
>   	}, {
> +		.name = "at91sam9rl-adc",
> +		.driver_data = (unsigned long)&at91sam9rl_caps,
> +	}, {
>   		.name = "at91sam9g45-adc",
>   		.driver_data = (unsigned long)&at91sam9g45_caps,
>   	}, {
>

