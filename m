Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3L3VDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:03:11 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42345 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab3L3VDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:03:10 -0500
MIME-Version: 1.0
In-Reply-To: <14411385250870@web21g.yandex.ru>
References: <5290F68C.4060900@roeck-us.net>
	<14411385250870@web21g.yandex.ru>
Date: Mon, 30 Dec 2013 22:03:09 +0100
X-Google-Sender-Auth: m2_9QptRDL2xTpL0Ppgn8wZPEek
Message-ID: <CAMuHMdU74A9sDcv8B213m8cryiBfTH7BC_8OuzfK020Hq3VV4g@mail.gmail.com>
Subject: Re: New build failures in v3.13-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kirill Tkhai <tkhai@yandex.ru>, "David S. Miller" <davem@davemloft.net>,
        sparclinux <sparclinux@vger.kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC davem, sparclinux

On Sun, Nov 24, 2013 at 12:54 AM, Kirill Tkhai <tkhai@yandex.ru> wrote:
> 23.11.2013, 22:40, "Guenter Roeck" <linux@roeck-us.net>:
>> =======================
>> Building sparc64:allmodconfig ... failed
>> --------------
>> Error log:
>> arch/sparc/kernel/kgdb_64.c: In function 'kgdb_trap':
>> arch/sparc/kernel/kgdb_64.c:162:7: error: implicit declaration of function 'exception_enter' [-Werror=implicit-function-declaration]
>> arch/sparc/kernel/kgdb_64.c:176:2: error: implicit declaration of function 'exception_exit' [-Werror=implicit-function-declaration]
>> cc1: all warnings being treated as errors
>> make[2]: *** [arch/sparc/kernel/kgdb_64.o] Error 1
>>
>> Introduced by commit 812cb83a5 (sparc64: Implement HAVE_CONTEXT_TRACKING).
>>
>> Reverting that commit fixes the problem.
>>
>
> The patch below fixes the problem:
>
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> ---
>  arch/sparc/kernel/kgdb_64.c | 1 +
>  1 file changed, 1 insertion(+)
> diff --git a/arch/sparc/kernel/kgdb_64.c b/arch/sparc/kernel/kgdb_64.c
> index 60b19f5..b45fe3f 100644
> --- a/arch/sparc/kernel/kgdb_64.c
> +++ b/arch/sparc/kernel/kgdb_64.c
> @@ -6,6 +6,7 @@
>  #include <linux/kgdb.h>
>  #include <linux/kdebug.h>
>  #include <linux/ftrace.h>
> +#include <linux/context_tracking.h>
>
>  #include <asm/cacheflush.h>
>  #include <asm/kdebug.h>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
