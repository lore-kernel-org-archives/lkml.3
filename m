Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3LGJBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 04:01:33 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45872 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3LGJBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 04:01:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAOZdJXWukOZt9KCjph3wWPkt5NO166syL1BKS6CZHExxc=edGA@mail.gmail.com>
References: <529CEA30.8010805@infradead.org>
	<CAOZdJXWukOZt9KCjph3wWPkt5NO166syL1BKS6CZHExxc=edGA@mail.gmail.com>
Date: Sat, 7 Dec 2013 10:01:12 +0100
X-Google-Sender-Auth: x3zdgr9CLvTEs_DimhxJnjLfptw
Message-ID: <CAMuHMdUOyQhky0Df5NoUF4a8etz5gKxjQBzXdVwrcL8kCCv=0A@mail.gmail.com>
Subject: Re: [PATCH] init.h: add missing initcall variants
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Timur Tabi <timur@tabi.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Timur Tabi <timur@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 7, 2013 at 4:31 AM, Timur Tabi <timur@tabi.org> wrote:
> On Mon, Dec 2, 2013 at 2:14 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Add missing initcall variants when building for loadable modules.
>> This fixes this build error on powerpc allmodconfig:
>>
>> drivers/tty/ehv_bytechan.c: error: type defaults to 'int' in declaration of 'console_initcall' [-Werror=implicit-int]
>
> Acked-by: Timur Tabi <timur@tabi.org>
>
> However, I wonder if it makes sense to have a console_initcall in a
> module at all.  Is it possible to load and use a console driver as a
> module?

Of course.

Its use for debugging is limited though, as you obviously won't get output
from it before the module is loaded and the console is registered.

As long as it's e.g. autoloaded from an initramfs, it'll work.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
