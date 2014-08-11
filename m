Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaHKTZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:25:07 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42501 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaHKTZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140811190644.GA3711@ld-irv-0074>
References: <1407604073-7484-1-git-send-email-geert@linux-m68k.org>
	<20140811175036.GU3711@ld-irv-0074>
	<CAMuHMdUNoD5qFhfVP2jJvgqPi=c6xe6YAbmQWYt_ir7rtqp_OQ@mail.gmail.com>
	<20140811190644.GA3711@ld-irv-0074>
Date: Mon, 11 Aug 2014 21:25:03 +0200
X-Google-Sender-Auth: YTPH9yO4-1CbhmpDnX7ETbILRbU
Message-ID: <CAMuHMdVaNsd6dO0rNNiP2GxekQdeJQ1mLhoppR=WrRPJ=uUawg@mail.gmail.com>
Subject: Re: [PATCH] mtd: nand: Use ULL-suffix for big u64 constant
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Mon, Aug 11, 2014 at 9:06 PM, Brian Norris
<computersforpeace@gmail.com> wrote:
> I'm curious: do your broken compilers also generate broken code/data?
> i.e., does gcc 4.4.7 give 250000000000 its proper ULL value still?

Yes it does (checked the assembler output).

>> > However, I could be convinced to apply this, if only to satisfy broken
>> > tools and to avoid addressing this question over and over...
>>
>> So please apply. Too many people are still using 32-bit targets and
>> gcc < 4.6.
>
> OK, you've convinced me ;) Applied to l2-mtd.git/next, with an editorial
> comment.

Thanks!

BTW, I had some faint memories of integer constants never being 64-bit
without the "LL" suffix, but that's no longer true in c99 (I did check that a
few days ago).

The warning does go away when adding -std=c99 with gcc-4.4.
Interestingly, it doesn't appear with -std=c89 with gcc 4.6.2 or 4.8.2.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
