Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaLOJi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:38:27 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:37316 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaLOJiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:38:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141215183217.0529.AA925319@jp.panasonic.com>
References: <20141215183217.0529.AA925319@jp.panasonic.com>
Date: Mon, 15 Dec 2014 10:38:23 +0100
X-Google-Sender-Auth: x0R6dqROBor7SIJPpoBIhlqzCN0
Message-ID: <CAMuHMdWOAWr40YOoOVRvV-gPUU+ioSnShzHYcMoGpvhUO6chXw@mail.gmail.com>
Subject: Re: [Question] How to print size_t type variable?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Murray <amurray@mpc-data.co.uk>,
        linux-m68k <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yamada-san,


On Mon, Dec 15, 2014 at 10:32 AM, Masahiro Yamada
<yamada.m@jp.panasonic.com> wrote:
> I read through Documentation/printk-formats.txt
>
> It clearly says to use "%zu" or "%zx" to print size_t variables,
> but I still have a question.
>
>
> Assume we have code something like:
>
>     printk("%zx", (size_t)10);
>
>
> I think this code works fine as long as it includes
> the compiler-provided <stddef.h>.
>
> In the kernel space, however, <stddef.h> is never included.
> Instead, size_t is defined by include/linux/types.h
> and include/uapi/asm-generic/posix_types.h.
>
>
> That is, size_t is defined independently from the compiler you are using,
> although the compiler still decides which variable type is expected for the "%zx" format.

That's correct.

> This causes compiler warnings for some compilers.
>
> On bare-metal m68k toolchains, for example, size_t is "unsignd long",
> whearas it is "unsigned int" on kernel.org m68k toolchains.
>
>
> I see such warnings when I built the kernel with bare-metal m68k toolchains.
>
>
> $ git describe
> v3.18
> $ make ARCH=m68k  CROSS_COMPILE=m68k-elf-  defconfig all
>   HOSTCC  scripts/basic/fixdep
>   HOSTCC  scripts/kconfig/conf.o
>   SHIPPED scripts/kconfig/zconf.tab.c
>   SHIPPED scripts/kconfig/zconf.lex.c
>   SHIPPED scripts/kconfig/zconf.hash.c
>   HOSTCC  scripts/kconfig/zconf.tab.o
>   HOSTLD  scripts/kconfig/conf
> *** Default configuration is based on 'multi_defconfig'
> kernel/time/Kconfig:163:warning: range is invalid
> #
> # configuration written to .config
> #
>
>   [ snip ]
>
>   LD      init/mounts.o
>   CC      init/initramfs.o
> init/initramfs.c: In function 'populate_rootfs':
> init/initramfs.c:635:5: warning: format '%zd' expects argument of type 'signed size_t', but argument 2 has type 'ssize_t' [-Wformat]

Please use a compiler configured for Linux, i.e. m68k-linux-*.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
