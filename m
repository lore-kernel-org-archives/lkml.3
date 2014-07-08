Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbaGHTYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:24:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46445 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbaGHTYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140708164525.GB12935@roeck-us.net>
References: <CAPDOMVid3nbw0-3n_5d8QF_c5uOosWyYRPtqW29ZUB9Ziz7F+Q@mail.gmail.com>
	<53BB6D8F.70900@roeck-us.net>
	<CAMuHMdVS79CpOiNkB60Vdrbe_ba=C=ONTFbsXbkcjJacSLaZYw@mail.gmail.com>
	<20140708164525.GB12935@roeck-us.net>
Date: Tue, 8 Jul 2014 21:24:49 +0200
X-Google-Sender-Auth: 8kQQ-KOKzPwswIkUKHTbQIGESpc
Message-ID: <CAMuHMdVpWMboV1JGnOY7BtB1Qcm2=70Q079NPSGfut4Kjz34dQ@mail.gmail.com>
Subject: Re: Compile issues with se7206_defconfig
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 6:45 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> > net/built-in.o: In function `__sk_run_filter':
>> > filter.c:(.text+0x3156c): undefined reference to `__fpscr_values'
>> > filter.c:(.text+0x31760): undefined reference to `__fpscr_values'
>> > filter.c:(.text+0x31c8c): undefined reference to `__fpscr_values'
>> > filter.c:(.text+0x31f00): undefined reference to `__fpscr_values'
>> > filter.c:(.text+0x323b0): undefined reference to `__fpscr_values'
>>
>> Toolchain issue: the compiler doesn't recognize the option to disable
>> the FPU, so it isn't passed, cfr.
>> www.spinics.net/lists/netdev/msg278300.html
>
> Seems that similar problems were fixed earlier without requiring a toolchain
> change. What is different this time (besides the apparent difficulty to build a
> new toolchain) ? Or am I missing something ?

sh4-linux-gcc doesn't recognize -m2a-nofpu, so that is not passed.
It does recognize -m4a-nofpu, but when that's passed, it complains
about opcode not valid for this cpu variant in inline asm/

Ah, it also recognizes -m4-nofpu. If I add that, se7206_defconfig builds.
I assume a proper sh2a-linux toolchain will not recognize the -m4-nofpu,
so it won't be passed due to $(call cc-option).

Does this sound like an acceptable solution? If yes, I'll send a patch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
