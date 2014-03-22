Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaCVMc7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 08:32:59 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53369 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaCVMcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 08:32:55 -0400
Message-ID: <532D8338.3060409@kernel.org>
Date: Sat, 22 Mar 2014 12:34:00 +0000
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
Subject: Re: [PATCH v2 05/15] ARM: at91: sam9m10g45ek: Add touchscreen support
 through at91_adc
References: <1395064628-644-1-git-send-email-alexandre.belloni@free-electrons.com> <1395064628-644-6-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395064628-644-6-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/14 13:56, Alexandre Belloni wrote:
> at91_adc now supports reading a touchscreen for ADCs without a TSMR register.
> Enable touchscreen support through at91_adc. This allows to use both a
> touchscreen and the remaining ADC channel at the same time.
>
> Also, lower the clock for the ADC as it allows to have more stable reads and
> this is the speed used by atmel_tsadcc.
> It lowers the maximum throughput rate from 440000 samples per second to 12958
> samples per second. It shouldn't be an issue as the CPU is not able to keep up
> reading samples at that frequency.
Thanks for adding this detail.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
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

