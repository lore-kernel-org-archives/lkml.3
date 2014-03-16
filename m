Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaCPRyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 13:54:40 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39309 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaCPRyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 13:54:38 -0400
Message-ID: <5325E599.8080308@kernel.org>
Date: Sun, 16 Mar 2014 17:55:37 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 03/15] iio: adc: at91: cleanup platform_data
References: <1394040940-18246-1-git-send-email-alexandre.belloni@free-electrons.com> <1394040940-18246-4-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1394040940-18246-4-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/14 17:35, Alexandre Belloni wrote:
> num_channels and registers are not used anymore since they are defined inside
> the driver and assigned by matching the id_table.
>
> Also, struct at91_adc_reg_desc is now only used inside the driver.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>

Hmm. Looking on in the series, I'm guessing taking the lot through IIO
once everyone is happy is probably the way to go.

I'll be wanting acks from Atmel maintainers for pretty much all of them though.

Jonathan
> ---
>   drivers/iio/adc/at91_adc.c             | 19 +++++++++++++++++++
>   include/linux/platform_data/at91_adc.h | 23 -----------------------
>   2 files changed, 19 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
> index 89777ed9abd8..1beae65aef2c 100644
> --- a/drivers/iio/adc/at91_adc.c
> +++ b/drivers/iio/adc/at91_adc.c
> @@ -46,6 +46,25 @@
>   #define TOUCH_SAMPLE_PERIOD_US		2000	/* 2ms */
>   #define TOUCH_PEN_DETECT_DEBOUNCE_US	200
>
> +/**
> + * struct at91_adc_reg_desc - Various informations relative to registers
> + * @channel_base:	Base offset for the channel data registers
> + * @drdy_mask:		Mask of the DRDY field in the relevant registers
> +			(Interruptions registers mostly)
> + * @status_register:	Offset of the Interrupt Status Register
> + * @trigger_register:	Offset of the Trigger setup register
> + * @mr_prescal_mask:	Mask of the PRESCAL field in the adc MR register
> + * @mr_startup_mask:	Mask of the STARTUP field in the adc MR register
> + */
> +struct at91_adc_reg_desc {
> +	u8	channel_base;
> +	u32	drdy_mask;
> +	u8	status_register;
> +	u8	trigger_register;
> +	u32	mr_prescal_mask;
> +	u32	mr_startup_mask;
> +};
> +
>   struct at91_adc_caps {
>   	bool	has_ts;		/* Support touch screen */
>   	bool	has_tsmr;	/* only at91sam9x5, sama5d3 have TSMR reg */
> diff --git a/include/linux/platform_data/at91_adc.h b/include/linux/platform_data/at91_adc.h
> index b3ca1e94e0c8..fcf73879dbfe 100644
> --- a/include/linux/platform_data/at91_adc.h
> +++ b/include/linux/platform_data/at91_adc.h
> @@ -8,25 +8,6 @@
>   #define _AT91_ADC_H_
>
>   /**
> - * struct at91_adc_reg_desc - Various informations relative to registers
> - * @channel_base:	Base offset for the channel data registers
> - * @drdy_mask:		Mask of the DRDY field in the relevant registers
> -			(Interruptions registers mostly)
> - * @status_register:	Offset of the Interrupt Status Register
> - * @trigger_register:	Offset of the Trigger setup register
> - * @mr_prescal_mask:	Mask of the PRESCAL field in the adc MR register
> - * @mr_startup_mask:	Mask of the STARTUP field in the adc MR register
> - */
> -struct at91_adc_reg_desc {
> -	u8	channel_base;
> -	u32	drdy_mask;
> -	u8	status_register;
> -	u8	trigger_register;
> -	u32	mr_prescal_mask;
> -	u32	mr_startup_mask;
> -};
> -
> -/**
>    * struct at91_adc_trigger - description of triggers
>    * @name:		name of the trigger advertised to the user
>    * @value:		value to set in the ADC's trigger setup register
> @@ -42,8 +23,6 @@ struct at91_adc_trigger {
>   /**
>    * struct at91_adc_data - platform data for ADC driver
>    * @channels_used:		channels in use on the board as a bitmask
> - * @num_channels:		global number of channels available on the board
> - * @registers:			Registers definition on the board
>    * @startup_time:		startup time of the ADC in microseconds
>    * @trigger_list:		Triggers available in the ADC
>    * @trigger_number:		Number of triggers available in the ADC
> @@ -52,8 +31,6 @@ struct at91_adc_trigger {
>    */
>   struct at91_adc_data {
>   	unsigned long			channels_used;
> -	u8				num_channels;
> -	struct at91_adc_reg_desc	*registers;
>   	u8				startup_time;
>   	struct at91_adc_trigger		*trigger_list;
>   	u8				trigger_number;
>

