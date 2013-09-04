Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430Ab3IDT6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:58:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51073 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab3IDT6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:58:18 -0400
Message-ID: <522790D6.6080803@wwwdotorg.org>
Date: Wed, 04 Sep 2013 13:58:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>, gnurou@gmail.com,
        linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC 2/5] gpiolib: export descriptor-based GPIO interface
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com> <1378294169-22661-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1378294169-22661-3-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 05:29 AM, Alexandre Courbot wrote:
> This patch exports the gpiod_* family of API functions, a safer
> alternative to the legacy gpio interface. Differences between the gpiod
> and gpio APIs are:
> 
> - gpio works with integers, whereas gpiod operates on opaque handlers
>   which cannot be forged or used before proper acquisition
> - gpiod get/set functions are aware of the active low state of a GPIO
> - gpio consumers should now include <linux/gpio/consumer.h> to access
>   the new interface, whereas chips drivers will use
>   <linux/gpio/driver.h>
> 
> The legacy gpio API is now built as inline functions on top of gpiod.
> 

> diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h

> +struct gpio_chip {

> +	int			(*get_direction)(struct gpio_chip *chip,
> +						unsigned offset);
> +	int			(*direction_input)(struct gpio_chip *chip,
> +						unsigned offset);
> +	int			(*get)(struct gpio_chip *chip,
> +						unsigned offset);
> +	int			(*direction_output)(struct gpio_chip *chip,
> +						unsigned offset, int value);
> +	int			(*set_debounce)(struct gpio_chip *chip,
> +						unsigned offset,
> +						unsigned debounce);
> +
> +	void			(*set)(struct gpio_chip *chip,
> +						unsigned offset, int value);
> +

Minor nit: It might be nice to sort/group these entries more cohesively,
i.e. get_direction, direction_input, direction_output, get, set,
set_debounce?
