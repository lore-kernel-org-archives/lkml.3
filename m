Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaI3V16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:27:58 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56872 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaI3V14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:27:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?Vincent_Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        linux-next@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1412105803-9954-1-git-send-email-vincent.stehle@laposte.net>
Cc: linux-kernel@vger.kernel.org,
        =?utf-8?q?Vincent_Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        "Jyri Sarha" <jsarha@ti.com>
References: <20140930162635.GA7135@roeck-us.net>
 <1412105803-9954-1-git-send-email-vincent.stehle@laposte.net>
Message-ID: <20140930212730.19023.54223@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH linux-next] clk-gpio-gate: include gpio/consumer to fix build
Date: Tue, 30 Sep 2014 14:27:30 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Vincent Stehlé (2014-09-30 12:36:43)
> This fixes the following build error:
> 
>   drivers/clk/clk-gpio-gate.c: In function ‘clk_gpio_gate_enable’:
>   drivers/clk/clk-gpio-gate.c:36:2: error: implicit declaration of function ‘gpiod_set_value’ [-Werror=implicit-function-declaration]
>   drivers/clk/clk-gpio-gate.c: In function ‘clk_gpio_gate_is_enabled’:
>   drivers/clk/clk-gpio-gate.c:52:2: error: implicit declaration of function ‘gpiod_get_value’ [-Werror=implicit-function-declaration]
>   drivers/clk/clk-gpio-gate.c: In function ‘clk_register_gpio_gate’:
>   drivers/clk/clk-gpio-gate.c:79:2: error: implicit declaration of function ‘gpiod_is_active_low’ [-Werror=implicit-function-declaration]
>   drivers/clk/clk-gpio-gate.c:85:3: error: implicit declaration of function ‘desc_to_gpio’ [-Werror=implicit-function-declaration]
>   drivers/clk/clk-gpio-gate.c:125:2: error: implicit declaration of function ‘gpiod_put’ [-Werror=implicit-function-declaration]
>   drivers/clk/clk-gpio-gate.c: In function ‘of_clk_gpio_gate_delayed_register_get’:
>   drivers/clk/clk-gpio-gate.c:169:2: error: implicit declaration of function ‘gpio_to_desc’ [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Jyri Sarha <jsarha@ti.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> ---
> 
> Hi,
> 
> This can be seen with e.g. linux next-20140930 and arm alldefconfig.

Fixed with:

https://git.linaro.org/people/mike.turquette/linux.git/commit/44b4aa97bea84fa8ac179155f147e3483cc7a6e0

Regards,
Mike

> 
> Best regards,
> 
> V.
> 
>  drivers/clk/clk-gpio-gate.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/clk-gpio-gate.c b/drivers/clk/clk-gpio-gate.c
> index 9dde885..08e4322 100644
> --- a/drivers/clk/clk-gpio-gate.c
> +++ b/drivers/clk/clk-gpio-gate.c
> @@ -13,6 +13,7 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/of_gpio.h>
>  #include <linux/err.h>
>  #include <linux/device.h>
> -- 
> 2.1.0
> 
