Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab3GAVCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:02:10 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:44735 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab3GAVCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <1372630948.2083.3.camel@joe-AO722>
References: <1372585689-29492-1-git-send-email-geert@linux-m68k.org>
	<1372630948.2083.3.camel@joe-AO722>
Date: Mon, 1 Jul 2013 23:02:06 +0200
X-Google-Sender-Auth: D0AGZ4vkRgTfxN9PaFd3IdUmCxc
Message-ID: <CAMuHMdUA3+gLi00Tvik2SjZaRYSC2sMMmP9TMH=Vb1dAubXx3Q@mail.gmail.com>
Subject: Re: [PATCH] m68k/setup: Use pr_*() instead of plain printk()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 12:22 AM, Joe Perches <joe@perches.com> wrote:
>> diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
>
>> @@ -161,7 +161,7 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
> []
>> -                             printk("m68k_parse_bootinfo: too many memory chunks\n");
>> +                             pr_warn("m68k_parse_bootinfo: too many memory chunks\n");
>
> These are generally better written by
> removing the hand-written function name
> and using "%s: ", __func__
>
>                                 pr_warn("%s: too many memory chunks\n",
>                                         __func__);

I had tried that, too. But surprisingly (although the same function
name was in two
messages), it increased the size of the kernel image.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
