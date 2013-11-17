Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab3KQVb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 16:31:28 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4265 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab3KQVbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 16:31:20 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <5289359B.8090506@broadcom.com>
Date: Sun, 17 Nov 2013 22:31:07 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Borislav Petkov" <bp@alien8.de>
cc: lkml <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmsmac: Fix build dep on LEDS_CLASS
References: <20131117133702.GA30840@pd.tnic>
In-Reply-To: <20131117133702.GA30840@pd.tnic>
X-WSS-ID: 7E97EA051508964248-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/13 14:37, Borislav Petkov wrote:
> From: Borislav Petkov<bp@suse.de>
>
> When building randconfigs with CONFIG_BCMA_DRIVER_GPIO=y, I get
>
> drivers/built-in.o: In function `brcms_led_unregister':
> (.text+0x351aca): undefined reference to `led_classdev_unregister'
> drivers/built-in.o: In function `brcms_led_register':
> (.text+0x351c65): undefined reference to `led_classdev_register'
>
> during the final linking stage because brcmsmac/led.c needs LEDS_CLASS
> for reg/dereg. Fix that.

Wouldn't it be better to fix it in brcmsmac.

Gr AvS

> Cc: "Rafał Miłecki"<zajec5@gmail.com>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Borislav Petkov<bp@suse.de>
> ---
>
> I'm attaching the .config in question.
>
>   drivers/bcma/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index 7c081b38ef3e..74dba9ca1413 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -74,7 +74,7 @@ config BCMA_DRIVER_GMAC_CMN
>
>   config BCMA_DRIVER_GPIO
>   	bool "BCMA GPIO driver"
> -	depends on BCMA&&  GPIOLIB
> +	depends on BCMA&&  GPIOLIB&&  LEDS_CLASS
>   	help
>   	  Driver to provide access to the GPIO pins of the bcma bus.
>


