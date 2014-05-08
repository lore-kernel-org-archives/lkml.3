Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaEHPA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:00:29 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11378 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbaEHPAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:00:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 08 May 2014 07:55:42 -0700
Message-ID: <536B9B7A.9060105@nvidia.com>
Date: Thu, 8 May 2014 23:58:02 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] gpio: include linux/bug.h in interface header
References: <7225229.HqAtN0I8Si@wuerfel>
In-Reply-To: <7225229.HqAtN0I8Si@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 10:42 PM, Arnd Bergmann wrote:
> Today's linux-next kernel started showing build errors for the
> use of WARN_ON in linux/gpio/consumer.h:
>
> In file included from drivers/video/backlight/pwm_bl.c:13:0:
> include/linux/gpio/consumer.h: In function 'gpiod_put':
> include/linux/gpio/consumer.h:81:2: error: implicit declaration of function 'WARN_ON' [-Werror=implicit-function-declaration]
>
> It's not clear why this never happened before, but this patch
> fixes it by including the header that contains the defintion
> of this macro.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>

I guess this went unnoticed because this part of the code is only active 
if compiled without gpiolib, which is not a very common configuration. 
Sorry about that.

>
> Signed-off-by: Arnd Bergmann <arnd@arnd.de>
>
> diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
> index bed128e..073b9b1 100644
> --- a/include/linux/gpio/consumer.h
> +++ b/include/linux/gpio/consumer.h
> @@ -1,6 +1,7 @@
>   #ifndef __LINUX_GPIO_CONSUMER_H
>   #define __LINUX_GPIO_CONSUMER_H
>
> +#include <linux/bug.h>
>   #include <linux/err.h>
>   #include <linux/kernel.h>
>
>
