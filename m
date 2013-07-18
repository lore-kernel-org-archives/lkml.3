Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3GRHXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:23:01 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60320 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3GRHW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:22:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130717223033.GF3385@free.fr>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
	<20130716004727.b60b2c96.akpm@linux-foundation.org>
	<20130716005611.e4ccab02.akpm@linux-foundation.org>
	<201307161008.07643.yann.morin.1998@free.fr>
	<20130716180408.GA19863@merkur.ravnborg.org>
	<20130717211649.GA5619@merkur.ravnborg.org>
	<20130717223033.GF3385@free.fr>
Date: Thu, 18 Jul 2013 09:22:58 +0200
X-Google-Sender-Auth: qBKU8g_6mqJMuqck5oT4shup050
Message-ID: <CAMuHMdXzcRxEBqavTx-kEq6CNAx5fYug0w8kjDw=vNfS2iX4Fw@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        hyojun.im@lge.com, chan.jeong@lge.com,
        Andy Lee <raphael.andy.lee@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:30 AM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> On 2013-07-17 23:16 +0200, Sam Ravnborg spake thusly:
>> > We could extend the symbol option part to retreive values from a binary.
>> > Something like this:
>> >
>> > config FOOBAR
>> >         bool
>> >         option exec="true"
>> >
>> > FOOBAR would assume the value "y" if the command true has exit code == 0, otherwise "n".
>> > And similar conversions for other types.
>> >
>> > This only extendt Kconfig slightly - using an already present method to import
>> > external values.
>> >
>> > The drawback I see with this approach is that we may execute a lot of small programs
>> > where the value is never used.
>>
>> Following is a quick patch implmenting this idea.
>> You need to run gperf manually to enable this.
>>
>> "gperf -C scripts/kconfig/zconf.gperf > scripts/kconfig/zconf.hash.c"
>>
>> I did not figure out how to use the built-in rules to generate this file :-(
>
> make REGENERATE_PARSERS=y menuconfig
>
>> I have tested this lightly - as we should discuss if this is a viable way forward.
>
> Instead of extending the Kconfig language, I was thinking (as initially
> suggested by Andrew) of generating a Kconfig file before all config
> targets, and source that Kconfig file from $(TOPDIR)/Kconfig.

I also prefer the generated Kconfig file.
It keeps all these checks in a single place, instead of spreading it over all
Kconfig files. This allows to keep better control over the list of checks, and
notice when it gets out-of-hand.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
