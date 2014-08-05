Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaHEIuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:50:05 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:52725 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbaHEIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:50:01 -0400
MIME-Version: 1.0
In-Reply-To: <5659104.6O7AZx76W6@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<17186253.ZJUn1qWK0f@wuerfel>
	<alpine.DEB.2.10.1407181140250.24854@nanos>
	<5659104.6O7AZx76W6@wuerfel>
Date: Tue, 5 Aug 2014 10:49:59 +0200
X-Google-Sender-Auth: _NfjPsWsoiUYTALlmDvmgnVE3hw
Message-ID: <CAMuHMdVRwTefEsKOMb2gotq5b7JoQ7Z2a8-5dERD7r4MwJdTvg@mail.gmail.com>
Subject: Re: [PATCH v2 21/29] nios2: Futex operations
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 11:55 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 18 July 2014 11:42:34 Thomas Gleixner wrote:
>> On Fri, 18 Jul 2014, Arnd Bergmann wrote:
>> > On Friday 18 July 2014 14:07:42 Ley Foon Tan wrote:
>> > > On Thu, Jul 17, 2014 at 7:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > If this understanding is right, we can probably just merge the
>> > m68k implementation into the asm-generic version, as that does
>> > exactly that, and just isn't SMP safe. I'm still unsure whether
>> > I'm missing something here though, as everything else seems to
>> > do this in assembly, even for non-SMP machines that could use
>> > the trivial method that m68k has.
>>
>> For UP relying of pagefault disable should be good enough indeed. I
>> guess the asm for the other UP stuff results from looking at
>> architectures or copying from architectures which did this in ASM
>
> Ok, thanks for the confirmation!
>
> Ley Foon Tan, I think the best way forward then is for you to
> take the m68k code and copy (or move) that into asm-generic/futex.h
> under an #ifndef CONFIG_SMP.

Yes, that should work.

I tried that a while ago for OpenRISC, but never cleant it up and sent it out.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
