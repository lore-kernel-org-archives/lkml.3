Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab3HMUto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:49:44 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43723 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938Ab3HMUtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130813201936.GA18358@roeck-us.net>
References: <20130813063501.728847844@linuxfoundation.org>
	<520A1D56.2050507@roeck-us.net>
	<20130813175858.GC7336@kroah.com>
	<20130813201936.GA18358@roeck-us.net>
Date: Tue, 13 Aug 2013 22:49:42 +0200
X-Google-Sender-Auth: z97zW3WJGV5FNx_OJ0UX4xmgZN4
Message-ID: <CAMuHMdVetwp7r=O_svmnyHBEQzdg-OdRxRB-3TJVQeQ7KULU7g@mail.gmail.com>
Subject: Re: [ 00/17] 3.4.58-stable review
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:19 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> powerpc/chroma_defconfig:
> arch/powerpc/mm/numa.c: In function 'do_init_bootmem':
> arch/powerpc/mm/numa.c:529:19: error: 'aa.arrays' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> arch/powerpc/mm/numa.c:642:22: note: 'aa.arrays' was declared here
> cc1: all warnings being treated as errors
>
> No idea. Code looks all different in 3.10.

Never seen in my log collection from kissb, which doesn't build
chroma_defconfig.

> m68k/allmodconfig:
> drivers/hid/hid-microsoft.c: In function 'ms_report_fixup':
> drivers/hid/hid-microsoft.c:52:18: error: macro "memcmp" passed 6 arguments, but takes just 3
> drivers/hid/hid-microsoft.c:51:5: error: 'memcmp' undeclared (first use in this function)
> drivers/hid/hid-microsoft.c:51:5: note: each undeclared identifier is reported only once for each function it appears in

Fixed in v3.7-rc6:

commit 6b90466cfec2a2fe027187d675d8d14217c12d82
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Mon Nov 12 10:16:09 2012 +0100

    HID: microsoft: do not use compound literal - fix build

> blackfin/defconfig:
> ERROR: "vm_iomap_memory" [drivers/video/fb.ko] undefined!
> make[1]: *** [__modpost] Error 1
>
> sh/defconfig:
> drivers/built-in.o: In function `fb_mmap':
> fbmem.c:(.text+0x5e8): undefined reference to `vm_iomap_memory'
>
> Both look similar and might be easy to fix if someone knows what is wrong.

Fixed in v3.9:

commit 3c0b9de6d37a481673e81001c57ca0e410c72346
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Apr 27 13:25:38 2013 -0700

    vm: add no-mmu vm_iomap_memory() stub

> cris/...:
> In file included from include/linux/page-flags.h:8:0,
>                  from kernel/bounds.c:9:
> include/linux/types.h:25:1: error: unknown type name '__kernel_ino_t'
> include/linux/types.h:29:1: error: unknown type name '__kernel_off_t'
> include/linux/types.h:30:1: error: unknown type name '__kernel_pid_t'
> include/linux/types.h:31:1: error: unknown type name '__kernel_daddr_t'
> include/linux/types.h:33:1: error: unknown type name '__kernel_suseconds_t'
>
> That one might be tricky (or simple if someone knows what is wrong).

Fixed in v3.5-rc1:

commit 74f077d2a7651409c44bb323471f219a4b0d2aab
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Mon Apr 2 13:40:17 2012 +0200

    cris: posix_types.h, include asm-generic/posix_types.h

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
