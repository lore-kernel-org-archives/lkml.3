Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab3GPFPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:15:24 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:62252 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3GPFPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:15:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWR12v9vHYZM1RJC3zJA0JCdr5K8VY3Gn2+HaR+5iNfzw@mail.gmail.com>
References: <1373361330-3946-1-git-send-email-realmz6@kernel.org>
	<CAMuHMdWR12v9vHYZM1RJC3zJA0JCdr5K8VY3Gn2+HaR+5iNfzw@mail.gmail.com>
Date: Tue, 16 Jul 2013 13:15:22 +0800
Message-ID: <CAMk6uBmHe9TOxfyrVfJ3BwmvPK3kAY81X=h6Ebed1W1GzNOYnQ@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.11
From: Steven Miao <realmz6@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Steven Miao <realmz6@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Tue, Jul 16, 2013 at 1:28 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Steven,
>
> On Tue, Jul 9, 2013 at 11:15 AM, Steven Miao <realmz6@kernel.org> wrote:
>> Steven Miao (2):
>>       smp: refine bf561 smpboot code
>
> Unfortunately this landed too late in -next to notice:
>
> arch/blackfin/mach-common/smp.c:150:2: error: conversion to non-scalar
> type requested
> arch/blackfin/mach-common/smp.c:185:23: error: incompatible types when
> assigning to type 'atomic_t' from type 'int'
> arch/blackfin/mach-common/smp.c:186:24: error: incompatible types when
> assigning to type 'atomic_t' from type 'int'
> make[2]: *** [arch/blackfin/mach-common/smp.o] Error 1
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/9115952/
>
> It's a bit embarrassing to break your own core code (with a patch that was
> submitted for public review in August 2012?).
>
> The last two can be trivially-fixed with the following
> (whitespace-damaged gmail)
> patch:
>
> --- a/arch/blackfin/mach-common/smp.c
> +++ b/arch/blackfin/mach-common/smp.c
> @@ -182,8 +182,8 @@ static void bfin_ipi_init(void)
>   struct ipi_data *bfin_ipi_data;
>   for_each_possible_cpu(cpu) {
>   bfin_ipi_data = &per_cpu(bfin_ipi, cpu);
> - bfin_ipi_data->bits = 0;
> - bfin_ipi_data->count = 0;
> + atomic_set(&bfin_ipi_data->bits, 0);
> + atomic_set(&bfin_ipi_data->count, 0);
>   }
>  }

Sorry, I should use atomic_ops to hanle atomic_t type.
>
> but the first one is non-trivial: using xchg() on atomic_t is a bit gross...
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
