Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaLSOxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:53:48 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:39959 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaLSOxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:53:47 -0500
Message-ID: <54943BF8.4050008@cogentembedded.com>
Date: Fri, 19 Dec 2014 17:53:44 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>,
        Alexander Stein <alexanders83@web.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ALSA: atmel: fix building the ac97 driver for at91-multiplatform
References: <1418944390-27719-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1418944390-27719-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/19/2014 2:13 AM, Alexandre Belloni wrote:

> From: Arnd Bergmann <arnd@arndb.de>

> at91 will no longer export the mach/cpu.h and mach/hardware.h header files
> in the future, which would break building the atmel ac97c driver.

> Since the cpu_is_* check is only used to find out whether we are running
> on avr32 or arm/at91, we can hardcode that check in the ARM case.

> Unfortunately the driver is missing other work to be useful again on ARM,
> if anyone wants to actually use it, they need to add a DT binding, and
> the driver should really be converted to use the ASoC framework.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Link: http://www.spinics.net/lists/arm-kernel/msg382068.html
> ---
>   sound/atmel/ac97c.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

> diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
> index b59427d5a697..83975f8d5947 100644
> --- a/sound/atmel/ac97c.c
> +++ b/sound/atmel/ac97c.c
> @@ -34,10 +34,10 @@
>   #include <linux/platform_data/dma-dw.h>
>   #include <linux/dma/dw.h>
>
> +#ifdef CONFIG_AVR32
>   #include <mach/cpu.h>
> -
> -#ifdef CONFIG_ARCH_AT91
> -#include <mach/hardware.h>
> +#else
> +#define cpu_is_at32ap7000() (0)

    () around 0 not needed at all.

[...]

WBR, Sergei

