Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3KSUgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:36:32 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43927 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3KSUg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:36:28 -0500
MIME-Version: 1.0
In-Reply-To: <201311191335.40506.arnd@arndb.de>
References: <1376996476-12027-2-git-send-email-geert@linux-m68k.org>
	<1384859955-27837-1-git-send-email-geert@linux-m68k.org>
	<201311191335.40506.arnd@arndb.de>
Date: Tue, 19 Nov 2013 21:36:28 +0100
X-Google-Sender-Auth: d9WqMlyUquwe9vYd68e92JZ4Ox0
Message-ID: <CAMuHMdXvn2GigpnH020XA1JvtF=4ZxwrOF4T=ocGgjhrcbWkgg@mail.gmail.com>
Subject: Re: [PATCH RESEND] asm/types.h: Remove include/asm-generic/int-l64.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Randy Dunlap <rdunlap@xenotime.net>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Nov 19, 2013 at 1:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 19 November 2013, Geert Uytterhoeven wrote:
>> Now all 64-bit architectures have been converted to int-ll64.h, we can
>> remove int-l64.h in kernelspace.
>>
>> For backwards compatibility, alpha, ia64, mips64, and powerpc64 still use
>> int-l64.h in userspace.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

>> Since <asm/types.h> (from include/uapi/asm-generic/types.h) is used for
>> both kernel and user space, include/asm-generic/int-ll64.h cannot just
>> become include/asm-generic/types.h, as Arnd suggested.
>
> I'm pretty sure you are right with this, but I don't remember at all
> what I suggested and don't understand what the problem (if any) is.
> Can you remind me?

Me neither :-(
You said https://lkml.org/lkml/2011/8/13/109, and Al's umode_t
consolidation has been completed.

I think it had to do with include/uapi/asm-generic/types.h including
<asm-generic/int-ll64.h>. Let's try...

In userspace, it will include <asm-generic/int-ll64.h> from uapi to get
e.g. __u32.
In kernelspace, it will include plain <asm-generic/int-ll64.h> (to get e.g.
u32), which will in turn include <uapi/asm-generic/int-ll64.h> (to also
get e.g. __u32).

As there's only include/uapi/asm-generic/types.h, but not
include/asm-generic/types.h (the individual architectures still have their
own asm/types.h), you cannot easily move (the contents of) int-ll64.h
to asm-generic/types.h for both the normal and uapi headers.

Does this make sense?

Note that this discussion is about what to do with the remaining int-ll64.h,
not about removing int-l64.h, which is what this patch is really about.
So _this_ patch can just go in.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
