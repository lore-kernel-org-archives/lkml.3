Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab3HNI0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:26:16 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63633 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759410Ab3HNI0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130813223622.GA12790@roeck-us.net>
References: <20130813063501.728847844@linuxfoundation.org>
	<520A1D56.2050507@roeck-us.net>
	<20130813175858.GC7336@kroah.com>
	<20130813201936.GA18358@roeck-us.net>
	<CAMuHMdVetwp7r=O_svmnyHBEQzdg-OdRxRB-3TJVQeQ7KULU7g@mail.gmail.com>
	<20130813223622.GA12790@roeck-us.net>
Date: Wed, 14 Aug 2013 10:26:12 +0200
X-Google-Sender-Auth: ONIKwmQ56kID7aT1v3OPgCL6kA4
Message-ID: <CAMuHMdVsR3Af+ccWMq6aU99UUAtCXyf8Ss0fbSYw7tR_w2mwkA@mail.gmail.com>
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

On Wed, Aug 14, 2013 at 12:36 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> > cris/...:
>> > In file included from include/linux/page-flags.h:8:0,
>> >                  from kernel/bounds.c:9:
>> > include/linux/types.h:25:1: error: unknown type name '__kernel_ino_t'
>> > include/linux/types.h:29:1: error: unknown type name '__kernel_off_t'
>> > include/linux/types.h:30:1: error: unknown type name '__kernel_pid_t'
>> > include/linux/types.h:31:1: error: unknown type name '__kernel_daddr_t'
>> > include/linux/types.h:33:1: error: unknown type name '__kernel_suseconds_t'
>> >
>> > That one might be tricky (or simple if someone knows what is wrong).
>>
>> Fixed in v3.5-rc1:
>>
>> commit 74f077d2a7651409c44bb323471f219a4b0d2aab
>> Author: Jiri Slaby <jslaby@suse.cz>
>> Date:   Mon Apr 2 13:40:17 2012 +0200
>>
>>     cris: posix_types.h, include asm-generic/posix_types.h
>>
> It does fix above error, but then there is another error:
>
>   AS      arch/cris/arch-v10/lib/checksum.o
> In file included from <command-line>:4:0:
> /home/groeck/src/linux-stable/include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
> make[1]: *** [arch/cris/arch-v10/lib/checksum.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
>   AS      arch/cris/arch-v10/lib/checksumcopy.o
> In file included from <command-line>:4:0:
> /home/groeck/src/linux-stable/include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
> make[1]: *** [arch/cris/arch-v10/lib/checksumcopy.o] Error 1

commit 7b91747d42a1012e3781dd09fa638d113809e3fd
Author: Paul Gortmaker <paul.gortmaker@windriver.com>
Date:   Wed Apr 18 21:58:43 2012 +0200

    cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile

    Most of these have been purged years ago.  This one silently lived
    on until commit 69349c2dc01c489eccaa4c472542c08e370c6d7e

        "kconfig: fix IS_ENABLED to not require all options to be defined"

    In the above, we use some macro trickery to create a conditional that
    is valid in CPP and in C usage.  However that trickery doesn't sit
    well if you have the legacy "-traditional" flag enabled.  You'll get:

      AS      arch/cris/arch-v10/lib/checksum.o
    In file included from <command-line>:4:0:
    include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
    make[2]: *** [arch/cris/arch-v10/lib/checksum.o] Error 1

    Everything builds fine w/o "-traditional" so simply drop it from this
    location as well.

    Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
    Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
