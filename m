Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab3F0HHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:07:31 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48880 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3F0HH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:07:29 -0400
MIME-Version: 1.0
In-Reply-To: <51CBC186.3080401@asianux.com>
References: <51CBA43F.9050000@asianux.com>
	<51CBAA1E.8000206@asianux.com>
	<51CBB1A9.5080203@asianux.com>
	<51CBC186.3080401@asianux.com>
Date: Thu, 27 Jun 2013 09:07:29 +0200
X-Google-Sender-Auth: FWAYZZ6BQ6A53HjMpmpoKytzPrg
Message-ID: <CAMuHMdVCv=MOJ8C4U=QHntQKZ=rThoKvXorgcR6jFRCA8hLULQ@mail.gmail.com>
Subject: Re: [PATCH] arch: m32r: include: asm: add ioread*_rep() and iowrite*_rep()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 6:37 AM, Chen Gang <gang.chen@asianux.com> wrote:
> --- a/arch/m32r/include/asm/io.h
> +++ b/arch/m32r/include/asm/io.h
> @@ -169,6 +169,20 @@ static inline void _writel(unsigned long l, unsigned long addr)
>  #define iowrite16 writew
>  #define iowrite32 writel
>
> +#define ioread8_rep(p, dst, count) \
> +       insb((unsigned long) (p), (dst), (count))

As ioread8() is mapped to readb() (I/O memory space), not inb() (I/O
port space),
ioread8_rep() should map to readsb() (which m32r doesn't have yet
BTW), not insb().
For m32r this does matter, as inb() and readb() use different mechanisms
internally.

It seems include/asm-generic/io.h also has this wrong?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
