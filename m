Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaBOR6F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 12:58:05 -0500
Received: from mail.active-venture.com ([67.228.131.205]:56532 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaBOR6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 12:58:03 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sat, 15 Feb 2014 11:58:00 -0600
X-Originating-IP: 108.223.40.66
Message-ID: <52FFAAA7.6040104@roeck-us.net>
Date: Sat, 15 Feb 2014 09:57:59 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-c6x-dev@linux-c6x.org
CC: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Guenter Roeck <linux@roeck-us.net>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] c6x: Include init.h in asm/cache.h
References: <1391781742-32250-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1391781742-32250-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 06:02 AM, Guenter Roeck wrote:
> arch/c6x/include/asm/cache.h uses __init and thus needs to include init.h.
> This fixes the following c6x build error.
>
> arch/c6x/include/asm/cache.h:63:20: error: expected '=', ',', ';',
> 'asm' or '__attribute__' before 'c6x_cache_init'
>   extern void __init c6x_cache_init(void);
>
> Problem was inadvertendly introduced with commit c28aa1f
> (printk/cache: mark printk_once test variable __read_mostly).
>
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>   arch/c6x/include/asm/cache.h |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/c6x/include/asm/cache.h b/arch/c6x/include/asm/cache.h
> index 09c5a0f..86648c0 100644
> --- a/arch/c6x/include/asm/cache.h
> +++ b/arch/c6x/include/asm/cache.h
> @@ -12,6 +12,7 @@
>   #define _ASM_C6X_CACHE_H
>
>   #include <linux/irqflags.h>
> +#include <linux/init.h>
>
>   /*
>    * Cache line size
>

ping ... c6x builds still fail in mainline due to this problem.
Anyone interested in a fix ?

Guenter

