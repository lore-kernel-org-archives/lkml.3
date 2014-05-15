Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaEOBhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 21:37:42 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65207 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaEOBhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 21:37:40 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53741A5A.7070503@roeck-us.net>
Date: Wed, 14 May 2014 18:37:30 -0700
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
Subject: Re: [PATCH v2 2/5] arm64: Support reboot through watchdog subsystem
References: <1399681883-891-1-git-send-email-linux@roeck-us.net> <1399681883-891-3-git-send-email-linux@roeck-us.net>
In-Reply-To: <1399681883-891-3-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 05:31 PM, Guenter Roeck wrote:
> The watchdog subsystem provides an API to perform a system reboot.
> Use it.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Any comments / Ack from the arm maintainers ?

Thanks,
Guenter

> ---
> v2: No change
>
>   arch/arm64/kernel/process.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 6391485..29c2bc0 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -42,6 +42,7 @@
>   #include <linux/hw_breakpoint.h>
>   #include <linux/personality.h>
>   #include <linux/notifier.h>
> +#include <linux/watchdog.h>
>
>   #include <asm/compat.h>
>   #include <asm/cacheflush.h>
> @@ -144,6 +145,8 @@ void machine_restart(char *cmd)
>   	if (arm_pm_restart)
>   		arm_pm_restart(reboot_mode, cmd);
>
> +	watchdog_do_reboot(reboot_mode, cmd);
> +
>   	/*
>   	 * Whoops - the architecture was unable to reboot.
>   	 */
>

