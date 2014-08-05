Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbaHEJIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:08:02 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:64974 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753AbaHEJH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:07:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140719091156.GA31772@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
	<43703371.jktNRIezc3@wuerfel>
	<20140719084152.GA31564@ravnborg.org>
	<4967546.K5Yf5hcJE1@wuerfel>
	<20140719091156.GA31772@ravnborg.org>
Date: Tue, 5 Aug 2014 11:07:55 +0200
X-Google-Sender-Auth: BG2RjgsVkAVkNPzEhtHKC3VygsA
Message-ID: <CAMuHMdUUSMGghDVDpdQygQCv0OWGP-Lwxzy004xRpR6BsZS81A@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] asm-generic/io.h: Implement generic {read,write}s*()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 11:11 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sat, Jul 19, 2014 at 11:05:33AM +0200, Arnd Bergmann wrote:
>> On Saturday 19 July 2014 10:41:52 Sam Ravnborg wrote:
>> > > >
>> > > > This set:
>> > > > #define inb_p(addr)     inb(addr)
>> > > > #define inw_p(addr)     inw(addr)
>> > > > #define inl_p(addr)     inl(addr)
>> > > > #define outb_p(x, addr) outb((x), (addr))
>> > > > #define outw_p(x, addr) outw((x), (addr))
>> > > > #define outl_p(x, addr) outl((x), (addr))
>> > > >
>> > > > Should have a comment that say they are deprecated.
>> > > > Especially the "b" variants still have many users.
>> > >
>> > > Are they? I don't remember ever seeing a reason to deprecate
>> > > them. We could perhaps enclose them in #ifdef CONFIG_ISA, but
>> > > there may also be some drivers that use the same code for ISA
>> > > and PCI, and it doesn't really hurt on PCI.
>> >
>> > It is my understanding that inl and inl_p are the same these days.
>> > A quick grep indicate that only m68k define the
>> > _p variant different from the other.
>> > But I failed to find and description of the difference between the
>> > two which is why I assumed they were identical and thus no need for both.
>>
>> I don't know why m68k needs it, it's really an x86-specific
>> thing, see slow_down_io() in arch/x86/include/asm/io.h.
>
> I had missed the x86 versions when grepping.
> Hmm, and with the macro tricks they play in asm/io.h this
> file is not at all grep friendly.
>
> So xxx_p is for pause (or something like that).
> This also matches that m68k do some tricks with delay() in the _p variants.
> Thanks for the explanation.

m68k's isa_delay() uses the same approach as x86's slow_down_io(),
but only for Q40/Q60, which has a "real" ISA bus that accepts legacy
ISA expansion cards (http://www.q40.de/).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
