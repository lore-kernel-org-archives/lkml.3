Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3FPIgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 04:36:36 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60576 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3FPIge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 04:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwdcdf0Zy82P70YsaF2Kqf4UTKKeDfMN0MPXXwSrGr4yw@mail.gmail.com>
References: <CA+55aFwdcdf0Zy82P70YsaF2Kqf4UTKKeDfMN0MPXXwSrGr4yw@mail.gmail.com>
Date: Sun, 16 Jun 2013 10:36:33 +0200
X-Google-Sender-Auth: pxSu7T9zr9ARFva8dKxYT4GF3Zw
Message-ID: <CAMuHMdWMYxg9QC_4EpDgcgevsTAt=3v6iaCa0cHxtzYbMheQ-w@mail.gmail.com>
Subject: Re: Linux 3.10-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 12:12 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> David Daney (3):
>       smp.h: Use local_irq_{save,restore}() in !SMP version of on_each_cpu().

This change (commit f21afc25f9ed45b8ffe200d0f071b0caec3ed2ef, which hasn't
been in linux-next), broke at least mn10300 and ia64:

include/linux/smp.h:148:2: error: implicit declaration of function
'local_irq_save' [-Werror=implicit-function-declaration]
include/linux/smp.h:150:2: error: implicit declaration of function
'local_irq_restore' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [arch/mn10300/kernel/asm-offsets.s] Error 1
http://kisskb.ellerman.id.au/kisskb/buildresult/8968250/

arch/mn10300/include/asm/irqflags.h:71:2: error: implicit declaration
of function 'raw_smp_processor_id'
[-Werror=implicit-function-declaration]
arch/mn10300/include/asm/irqflags.h:71:2: error: implicit declaration
of function 'raw_smp_processor_id'
[-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [arch/mn10300/kernel/smp.o] Error 1
http://kisskb.ellerman.id.au/kisskb/buildresult/8968248/

arch/ia64/include/asm/irqflags.h:49:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:60:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:67:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:76:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:82:18: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:49:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:60:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:67:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:76:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:82:18: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:49:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:60:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:67:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:76:1: error: 'IA64_PSR_I' undeclared
(first use in this function)
arch/ia64/include/asm/irqflags.h:82:18: error: 'IA64_PSR_I' undeclared
(first use in this function)
make[2]: *** [kernel/softirq.o] Error 1
http://kisskb.ellerman.id.au/kisskb/buildresult/8968433/

Reverting it seems to fix the failures (complete build still in progress).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
