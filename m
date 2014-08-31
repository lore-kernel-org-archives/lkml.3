Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaHaOOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 10:14:24 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:58775 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaHaOOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 10:14:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAJhHMCDaSAzU3zvhY2FRFoBaQH4oQBTsUsYMU6pvBbCXydROZQ@mail.gmail.com>
References: <1409369788-22563-1-git-send-email-bobby.prani@gmail.com>
	<CAMuHMdV_naTfQOLwOshWq1Q15kSE39a8GWChsjt3RrWRcd6peg@mail.gmail.com>
	<CAJhHMCDaSAzU3zvhY2FRFoBaQH4oQBTsUsYMU6pvBbCXydROZQ@mail.gmail.com>
Date: Sun, 31 Aug 2014 16:14:21 +0200
X-Google-Sender-Auth: qXGM5o3Rp_gy2E7hj9bkGpJ5bOM
Message-ID: <CAMuHMdWMct-06aEMNdHWv7A-9SyLwu3pZfmF9ZxTrFGA2=ab_A@mail.gmail.com>
Subject: Re: [RFC PATCH] powerpc: Wire up three syscalls
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anton Blanchard <anton@samba.org>, Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pranith,

On Sun, Aug 31, 2014 at 2:52 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> On Sun, Aug 31, 2014 at 4:53 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Sat, Aug 30, 2014 at 5:36 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>>> I see that the three syscalls seccomp, getrandom and memfd_create are not wired
>>> because of which we get a warning while compilation.
>>>
>>> So I wired them up in this patch. What else needs to be done? I tried the
>>> memfd_test after compiling this kernel, but it is failing. What am I missing for
>>> this to work? Any advice is really appreciated! :)
>>
>> Did it fail due to the (silly) "ifeq ($(ARCH),X86)" checks in
>> tools/testing/selftests/memfd/Makefile?
>
> I removed that check and compiled memfd_test.c by hand. This is the
> following error which I get when I run the test:
>
> $ ./memfd_test
> memfd: CREATE
> memfd: BASIC
> 10 != 0 = GET_SEALS(3)
> Aborted
>
> This is basically when checking the seals which we already added. It
> should return 10 (F_SEAL_SHRINK | F_SEAL_WRITE), instead it is returning 0.

So it does fail.

> What else needs to be done for this to properly work? I see that for
> m68k, you just wired it up like in this patch. Did it work after that?

To be honest, I didn't run any tests.

I had a few spare minutes, so I wanted to give it a try, but "make kselftest"
doesn't work with building in a separate directory (O=), doesn't support
CROSS_COMPILE=, etc... So I gave up (for now).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
