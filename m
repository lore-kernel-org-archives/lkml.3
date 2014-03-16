Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaCPSRo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 14:17:44 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39447 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbaCPSRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 14:17:42 -0400
Message-ID: <5325EB01.5060700@kernel.org>
Date: Sun, 16 Mar 2014 18:18:41 +0000
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
Subject: Re: [PATCH 05/15] ARM: at91: sam9m10g45ek: Add touchscreen support
 through at91_adc
References: <1394040940-18246-1-git-send-email-alexandre.belloni@free-electrons.com> <1394040940-18246-6-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1394040940-18246-6-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/14 17:35, Alexandre Belloni wrote:
> at91_adc now supports reading a touchscreen for ADCs without a TSMR register.
> Enable touchscreen support through at91_adc. This allows to use both a
> touchscreen and the remaining ADC channel at the same time.
>
> Also, lower the clock for the ADC as it allows to have more stable reads and
> this is the speed used by atmel_tsadcc.
Are there any side effects on the adc read if that functionality was previously
being used?  I doubt it matters, but probably wants to be mentioned here if there
is.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/mach-at91/at91sam9g45.c        | 2 +-
>   arch/arm/mach-at91/board-sam9m10g45ek.c | 1 +
>   2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
> index 2f455ce35268..3c519a7a938f 100644
> --- a/arch/arm/mach-at91/at91sam9g45.c
> +++ b/arch/arm/mach-at91/at91sam9g45.c
> @@ -181,7 +181,7 @@ static struct clk vdec_clk = {
>   static struct clk adc_op_clk = {
>   	.name		= "adc_op_clk",
>   	.type		= CLK_TYPE_PERIPHERAL,
> -	.rate_hz	= 13200000,
> +	.rate_hz	= 300000,
>   };
>
>   /* AES/TDES/SHA clock - Only for sam9m11/sam9g56 */
> diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
> index ef39078c8ce2..4d775b796ce4 100644
> --- a/arch/arm/mach-at91/board-sam9m10g45ek.c
> +++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
> @@ -315,6 +315,7 @@ static struct at91_adc_data ek_adc_data = {
>   	.channels_used = BIT(0) | BIT(1) | BIT(2) | BIT(3) | BIT(4) | BIT(5) | BIT(6) | BIT(7),
>   	.use_external_triggers = true,
>   	.vref = 3300,
> +	.touchscreen_type = ATMEL_ADC_TOUCHSCREEN_4WIRE,
>   };
>
>   /*
>

