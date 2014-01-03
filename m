Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaACSYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:24:21 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:64717 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaACSYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:24:20 -0500
MIME-Version: 1.0
In-Reply-To: <201401031804.34124.arnd@arndb.de>
References: <1388763959-27491-1-git-send-email-geert@linux-m68k.org>
	<201401031804.34124.arnd@arndb.de>
Date: Fri, 3 Jan 2014 19:24:19 +0100
X-Google-Sender-Auth: LkxpaPV9f2vw8BFJIgvqbDuOUR0
Message-ID: <CAMuHMdXoZJEgMXH0K1d5kDs+XSM_KMkigUq+mKYVQezdxZ929g@mail.gmail.com>
Subject: Re: [PATCH] arm/smp: Make boot_secondary() static
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 6:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 03 January 2014, Geert Uytterhoeven wrote:
>> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>>
>> After becoming a mandatory function, boot_secondary() is no longer used
>> outside arch/arm/kernel/smp.c. Hence make it static.
>> The code is reshuffled a bit to avoid a forward declaration.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> How about taking it one step further by removing the function entirely?
> Like this:
>
> @@ -92,6 +92,9 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
>  {
>         int ret;
>
> +       if (!smp_ops.smp_boot_secondary)
> +               return -ENOSYS;
> +
>         /*
>          * We need to tell the secondary core where to find
>          * its stack and the page tables.
> @@ -111,7 +114,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
>         /*
>          * Now bring the CPU into our world.
>          */
> -       ret = boot_secondary(cpu, idle);
> +       ret = smp_ops.smp_boot_secondary(cpu, idle);
>         if (ret == 0) {
>                 /*
>                  * CPU was successfully started, wait for it

Fine for me.

Do you want me to fold this into my patch, or will you apply this on top?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
