Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3EVM7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:59:45 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:62955 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3EVM7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:59:43 -0400
Message-ID: <519CC142.7050301@cogentembedded.com>
Date: Wed, 22 May 2013 16:59:46 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: nsekhar@ti.com, khilman@deeprootsystems.com, linux@arm.linux.org.uk,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/11] gpio: davinci: coding style correction
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com> <1369206634-6778-3-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1369206634-6778-3-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 22-05-2013 11:10, Philip Avinash wrote:

> 1. Corrects coding and commenting styles
> 2. Variables name change to meaningful name
> 3. Remove unnecessary variable usage
> 4. Add BINTEN macro definition
>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
>   drivers/gpio/gpio-davinci.c |  182 +++++++++++++++++++++----------------------
>   1 file changed, 89 insertions(+), 93 deletions(-)

> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 17df6db..d308955 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
[...]
> @@ -31,10 +31,11 @@ struct davinci_gpio_regs {
>   	u32	intstat;
>   };
>
> +#define BINTEN	0x08 /* GPIO Interrupt Per-Bank Enable Register */

    Empty line needed here.

>   #define chip2controller(chip)	\
>   	container_of(chip, struct davinci_gpio_controller, chip)
>
[...]
> @@ -98,8 +94,8 @@ static int davinci_direction_in(struct gpio_chip *chip, unsigned offset)
>   	return __davinci_direction(chip, offset, false, 0);
>   }
>
> -static int
> -davinci_direction_out(struct gpio_chip *chip, unsigned offset, int value)
> +static int davinci_direction_out(struct gpio_chip *chip, unsigned offset,
> +		int value)

     This line should be aligned under the next character after (.

[...]
> @@ -113,22 +109,22 @@ davinci_direction_out(struct gpio_chip *chip, unsigned offset, int value)
[...]
>   /*
>    * Assuming the pin is muxed as a gpio output, set its output value.
>    */
> -static void
> -davinci_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +static void davinci_gpio_set(struct gpio_chip *chip, unsigned offset,
> +		int value)

     Same here.

[...]
> @@ -368,16 +363,16 @@ static int __init davinci_gpio_irq_setup(void)
[...]
>   	for (gpio = 0, bank = 0; gpio < ngpio; bank++, gpio += 32) {
> -		chips[bank].chip.to_irq = gpio_to_irq_banked;
> -		chips[bank].irq_base = soc_info->gpio_unbanked
> -			? -EINVAL
> -			: (soc_info->intc_irq_num + gpio);
> +		ctlrs[bank].chip.to_irq = gpio_to_irq_banked;
> +		ctlrs[bank].irq_base = soc_info->gpio_unbanked ?
> +			-EINVAL : (soc_info->intc_irq_num + gpio);

    () not needed here.

WBR, Sergei

