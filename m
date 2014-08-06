Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbaHFSuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:50:19 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:53462 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbaHFSuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:50:17 -0400
MIME-Version: 1.0
In-Reply-To: <17153.1407349640@turing-police.cc.vt.edu>
References: <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com>
	<17153.1407349640@turing-police.cc.vt.edu>
Date: Wed, 6 Aug 2014 20:50:15 +0200
X-Google-Sender-Auth: e6-yShgRuloiAVkkeLpw2LMBGqo
Message-ID: <CAMuHMdVJQd0Mb8aXbd9iqkabzKdw9WSR791LxqUoVEJ1g1kaHA@mail.gmail.com>
Subject: Re: [PATCH 1/1] spi: Remove unused definitions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Nick Krause <xerofoiffy@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 8:27 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Wed, 06 Aug 2014 13:53:17 -0400, Nick Krause said:
>> Remove unused definition which cause the following warnings
>>
>> drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
>> include/linux/fs.h:193:0: note: this is the location of the previous definition
>> drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
>> include/linux/fs.h:192:0: note: this is the location of the previous definition
>
>> -#define WRITE 0
>> -#define READ  1
>
> NAK.  Full stop.  These are potentially used in an inner macro someplace, and by
> removing these, the conflicting values from fs.h will be used instead.
>
> #define READ                    0
> #define WRITE                   RW_MASK
>
> So if there *is* a use in an inner macro, you just screwed the pooch
> and introduced a bug in this "clean up" - somebody will be expecting to see
> a 0 for a READ, and will receive a 1 instead.  This can't end well.
>
> Nick - how *exactly* did you identify that these are in fact not used?
> Given your history of submitting poorly researched patches, you're going to
> have to justify the "unused" better than the handwaving you've done here.

Just looking into this...

It seems READ and WRITE are not used at all in this file.

To be 100% sure, I tried to find with which kernel config this warning shows up.
It doesn't happen for omap1_defconfig with CONFIG_SPI_OMAP_100K,
which was the most likely culprit.

It does happen with sparc/sparc64 allmodconfig. However, changing or
removing the READ and WRITE definitions in drivers/spi/spi-omap-100k.c
doesn't have any influence on the preprocessed source files
("make drivers/spi/spi-omap-100k.i", modulo line number changes),
for both omap1 and sparc builds.

(Nick: I believe the above is what people really want to see)

So I conclude they are really not used, and they can be safely removed.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
