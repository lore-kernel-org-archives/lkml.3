Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaEOBiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 21:38:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57426 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaEOBiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 21:38:04 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53741A70.8090606@roeck-us.net>
Date: Wed, 14 May 2014 18:37:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] arm: Support reboot through watchdog subsystem
References: <1399681883-891-1-git-send-email-linux@roeck-us.net> <1399681883-891-4-git-send-email-linux@roeck-us.net>
In-Reply-To: <1399681883-891-4-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 05:31 PM, Guenter Roeck wrote:
> The watchdog subsystem provides an API to perform a system reboot.
> Use it.
>
> With this change, the arm_pm_restart callback is now optional,
> so check if it is set before calling it.
>
> Tested-by: Jonas Jensen <jonas.jensen@gmail.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Any comments / ack from the arm maintainers ?

Thanks,
Guenter

> ---
> v2: No change
>
>   arch/arm/kernel/process.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 81ef686..c3b7b5e 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -32,6 +32,7 @@
>   #include <linux/hw_breakpoint.h>
>   #include <linux/leds.h>
>   #include <linux/reboot.h>
> +#include <linux/watchdog.h>
>
>   #include <asm/cacheflush.h>
>   #include <asm/idmap.h>
> @@ -230,7 +231,10 @@ void machine_restart(char *cmd)
>   	local_irq_disable();
>   	smp_send_stop();
>
> -	arm_pm_restart(reboot_mode, cmd);
> +	if (arm_pm_restart)
> +		arm_pm_restart(reboot_mode, cmd);
> +
> +	watchdog_do_reboot(reboot_mode, cmd);
>
>   	/* Give a grace period for failure to restart of 1s */
>   	mdelay(1000);
>

