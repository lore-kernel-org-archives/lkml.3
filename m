Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965177Ab3BMWy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:54:28 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:39483 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3BMWy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:54:26 -0500
Message-ID: <511C1990.1090205@gmail.com>
Date: Thu, 14 Feb 2013 09:54:08 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 4/4] gpiolib: rename local offset variables to "hwgpio"
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com> <1360738983-22436-5-git-send-email-gnurou@gmail.com>
In-Reply-To: <1360738983-22436-5-git-send-email-gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/02/13 18:03, Alexandre Courbot wrote:
> From: Alexandre Courbot <acourbot@nvidia.com>
> 
> Their value being obtained by gpio_chip_hwgpio(), this better reflects
> their use.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpio/gpiolib.c | 70 +++++++++++++++++++++++++-------------------------
>  1 file changed, 35 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index d8aa1a0..42838c2 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -72,7 +72,7 @@ struct gpio_desc {
>  };
>  static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
>  
> -#define GPIO_OFFSET_VALID(chip, offset) (offset >= 0 && offset < chip->ngpio)
> +#define GPIO_HWNUM_VALID(chip, hwgpio) (hwgpio >= 0 && hwgpio < chip->ngpio)

Nitpicky - Is it accurate to call these hardware numbers? Don't some of
the platforms remap the gpio numbers? These numbers may not match
against the platform's datasheet for example.

~Ryan

