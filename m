Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3F0Inv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:43:51 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58563 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3F0Inr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <3279444.s8HediXDkj@wuerfel>
References: <51CBA43F.9050000@asianux.com>
	<51CBC186.3080401@asianux.com>
	<CAMuHMdVCv=MOJ8C4U=QHntQKZ=rThoKvXorgcR6jFRCA8hLULQ@mail.gmail.com>
	<3279444.s8HediXDkj@wuerfel>
Date: Thu, 27 Jun 2013 10:43:46 +0200
X-Google-Sender-Auth: gLIem79pLHaojJB_cFjTqrbJMUI
Message-ID: <CAMuHMdX=n4y9o4qBU2jouH0aJP1BcJrgAKZFfgVTBTymWFB=6Q@mail.gmail.com>
Subject: Re: [PATCH] arch: m32r: include: asm: add ioread*_rep() and iowrite*_rep()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chen Gang <gang.chen@asianux.com>, Hirokazu Takata <takata@linux-m32r.org>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 10:25 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 27 June 2013 09:07:29 Geert Uytterhoeven wrote:
>> On Thu, Jun 27, 2013 at 6:37 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> > --- a/arch/m32r/include/asm/io.h
>> > +++ b/arch/m32r/include/asm/io.h
>> > @@ -169,6 +169,20 @@ static inline void _writel(unsigned long l, unsigned long addr)
>> >  #define iowrite16 writew
>> >  #define iowrite32 writel
>> >
>> > +#define ioread8_rep(p, dst, count) \
>> > +       insb((unsigned long) (p), (dst), (count))
>>
>> As ioread8() is mapped to readb() (I/O memory space), not inb() (I/O
>> port space),
>> ioread8_rep() should map to readsb() (which m32r doesn't have yet
>> BTW), not insb().
>> For m32r this does matter, as inb() and readb() use different mechanisms
>> internally.
>>
>> It seems include/asm-generic/io.h also has this wrong?
>
> Yes, you are right. I thought we had fixed that long ago.
>
> Does the patch below look ok to you? Note that none of the architectures
> using asm-generic/io.h supports PIO access and it works by chance
> this way, but we should definitely fix it.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
