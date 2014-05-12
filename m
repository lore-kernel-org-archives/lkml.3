Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbaELNQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:16:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:33924 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158AbaELNQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:16:49 -0400
Message-ID: <5370C9BD.4040201@atmel.com>
Date: Mon, 12 May 2014 15:16:45 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-input@vger.kernel.org>, Liam Girdwood <lrg@slimlogic.co.uk>
CC: <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 2/2] input: atmel-wm97xx: only build for AVR32
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-1-git-send-email-arnd@arndb.de> <1399560990-1402858-16-git-send-email-arnd@arndb.de>
In-Reply-To: <1399560990-1402858-16-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 16:56, Arnd Bergmann :
> Building this driver on ARM/at91 always gives us this error message:
> 
> drivers/input/touchscreen/atmel-wm97xx.c:63:2: error: #error Unknown CPU, this driver only supports AT32AP700X CPUs.
> 
> Clearly this configuration is not meant to work, so let's just prevent
> it in Kconfig. If we ever want to use it on another platform, we should
> also pass proper resources for GPIO, IRQ and memory, which are hardcoded
> to AT32AP700X at the moment.

Yes it seems so:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> ---
>  drivers/input/touchscreen/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index e2f0264..fe4c264 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -640,7 +640,7 @@ config TOUCHSCREEN_WM9713
>  
>  config TOUCHSCREEN_WM97XX_ATMEL
>  	tristate "WM97xx Atmel accelerated touch"
> -	depends on TOUCHSCREEN_WM97XX && (AVR32 || ARCH_AT91)
> +	depends on TOUCHSCREEN_WM97XX && AVR32
>  	help
>  	  Say Y here for support for streaming mode with WM97xx touchscreens
>  	  on Atmel AT91 or AVR32 systems with an AC97C module.
> 


-- 
Nicolas Ferre
