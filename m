Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaAPW2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:28:25 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34164 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAPW2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:28:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140116222456.GA6723@kroah.com>
References: <1389910800-13083-1-git-send-email-geert@linux-m68k.org>
	<20140116222456.GA6723@kroah.com>
Date: Thu, 16 Jan 2014 23:28:21 +0100
X-Google-Sender-Auth: u2lXzgPKxsfdUIPj1uQMCumkPG8
Message-ID: <CAMuHMdXOf0vs7GehLPg_kaL2pgyKraRkM3=bC3EsKWra_xrKTQ@mail.gmail.com>
Subject: Re: [PATCH] sh: kgdb: Add missing #include <linux/sched.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 11:24 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jan 16, 2014 at 11:20:00PM +0100, Geert Uytterhoeven wrote:
>> From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
>>
>> arch/sh/kernel/kgdb.c: In function 'sleeping_thread_to_gdb_regs':
>> arch/sh/kernel/kgdb.c:225:32: error: implicit declaration of function 'task_stack_page' [-Werror=implicit-function-declaration]
>> arch/sh/kernel/kgdb.c:242:23: error: dereferencing pointer to incomplete type
>> arch/sh/kernel/kgdb.c:243:22: error: dereferencing pointer to incomplete type
>> arch/sh/kernel/kgdb.c: In function 'singlestep_trap_handler':
>> arch/sh/kernel/kgdb.c:310:27: error: 'SIGTRAP' undeclared (first use in this function)
>> arch/sh/kernel/kgdb.c:310:27: note: each undeclared identifier is reported only once for each function it appears in
>>
>> This is introduced by commit 16559ae48c76f1ceb970b9719dea62b77eb5d06b
>> ("kgdb: remove #include <linux/serial_8250.h> from kgdb.h").
>
> Which showed up in 3.9-rc1, seems that no one seems to care about this
> arch/config much :)

That's why I didn't dare to add a CC to stable myself ;-)

BTW, the patch is also a few months old.

>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
>> [geert: Reworded and reformatted]
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> Cc: stable <stable@vger.kernel.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
