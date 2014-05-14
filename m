Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaENKod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:44:33 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:51848 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaENKo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:44:29 -0400
MIME-Version: 1.0
In-Reply-To: <5372E76C.8050908@zytor.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<1399971749-4004-1-git-send-email-lftan@altera.com>
	<CAAG0J9-ieBNfyRa6kf22TNd_3mg57GYuGHagQ-pPLY41iM3Zyg@mail.gmail.com>
	<CAFiDJ5-ez-Brqr8q3=XbODzLtFFU=e4qS12bCPo=5FE1JTNr+A@mail.gmail.com>
	<5371EAEB.5030100@imgtec.com>
	<CAFiDJ58w31gm_z3Y1Q6ZREQPW4F6uVB+vy3X1r_3kLgaEE3O1w@mail.gmail.com>
	<5371F25E.6020805@imgtec.com>
	<5372E76C.8050908@zytor.com>
Date: Wed, 14 May 2014 12:44:28 +0200
X-Google-Sender-Auth: -tohnuihDIFaS2_9ATn-Xxgfx5c
Message-ID: <CAMuHMdUpy=xpQ3wJ0RahYJ+Bkwf3EL5KPWvmOqs_vQG5cXGwGg@mail.gmail.com>
Subject: Re: [PATCH 01/25] asm-generic: Change time_t and clock_t to 64 bit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Hogan <james.hogan@imgtec.com>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 5:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/13/2014 03:22 AM, James Hogan wrote:
>>> When we export this posix_types.h file for user software, they need to
>>> define this config, eg: CONFIG_32BIT_TIME to use 32 bit time. Is this
>>> what we want to do?
>>
>> Yeh, good point, that won't work.
>
> How about:
>
> #include <asm-generic/types/time32.h>
>
> The asm-generic/types/ directory can be used for all kinds of type
> templates, like int-ll64.h and the (now removed) former int-l64.h.

That should more or less work. But better call it time-l.h, as time_t
should be 64-bit on 64-bit architectures. Else 32/64-bit architectures
still need an #ifdef.

Will time_t stay "long" (and not become "long long") on 64-bit?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
