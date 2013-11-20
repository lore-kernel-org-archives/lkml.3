Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3KTNe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:34:28 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:37522 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3KTNeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:34:25 -0500
MIME-Version: 1.0
In-Reply-To: <201311200137.20917.arnd@arndb.de>
References: <1376996476-12027-2-git-send-email-geert@linux-m68k.org>
	<201311191335.40506.arnd@arndb.de>
	<CAMuHMdXvn2GigpnH020XA1JvtF=4ZxwrOF4T=ocGgjhrcbWkgg@mail.gmail.com>
	<201311200137.20917.arnd@arndb.de>
Date: Wed, 20 Nov 2013 14:34:24 +0100
X-Google-Sender-Auth: eoPVmrmb8DSyyCEeIAKJIcaxA_g
Message-ID: <CAMuHMdVKLFzz0zoEKGLQF+o=MwHX5_FMDtq0FuqF3_x00w6XrA@mail.gmail.com>
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

On Wed, Nov 20, 2013 at 1:37 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 19 November 2013, Geert Uytterhoeven wrote:
>> On Tue, Nov 19, 2013 at 1:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> > I'm pretty sure you are right with this, but I don't remember at all
>> > what I suggested and don't understand what the problem (if any) is.
>> > Can you remind me?
>>
>> Me neither :-(
>> You said https://lkml.org/lkml/2011/8/13/109, and Al's umode_t
>> consolidation has been completed.
>>
>> I think it had to do with include/uapi/asm-generic/types.h including
>> <asm-generic/int-ll64.h>. Let's try...
>>
>> In userspace, it will include <asm-generic/int-ll64.h> from uapi to get
>> e.g. __u32.
>> In kernelspace, it will include plain <asm-generic/int-ll64.h> (to get e.g.
>> u32), which will in turn include <uapi/asm-generic/int-ll64.h> (to also
>> get e.g. __u32).
>>
>> As there's only include/uapi/asm-generic/types.h, but not
>> include/asm-generic/types.h (the individual architectures still have their
>> own asm/types.h), you cannot easily move (the contents of) int-ll64.h
>> to asm-generic/types.h for both the normal and uapi headers.
>>
>> Does this make sense?
>
> I'm pretty sure I was not talking about include/uapi/asm-generic/types.h
> there, and I still think we can just move include/asm-generic/int-ll64.h
> to include/asm-generic/types.h but leave the uapi logic in place.

The puzzle pieces are starting to fit: at that time, we still had
include/asm-generic/types.h, which got later renamed to
include/uapi/asm-generic/types.h...

> All architectures that do nothing but #include <asm-generic/int-ll64.h>
> from asm/types.h at the moment can then remove their private file and
> use the generic version, the others need to change to #include
> <asm-generic/types.h>.
>
> You can no longer #include <uapi/asm-generic/types.h> from kernel space
> after this change, since it refers to <asm-generic/int-ll64.h> which
> now only exists in user space, but that's ok because it would be a bug
> to include already (it defines the wrong types), and we don't.

I'll see what I can do...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
