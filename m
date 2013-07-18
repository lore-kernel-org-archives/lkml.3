Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3GRHeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:34:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3GRHeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:34:16 -0400
Date: Thu, 18 Jul 2013 00:34:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, Sam Ravnborg <sam@ravnborg.org>,
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
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
Message-Id: <20130718003408.bb9d5b51.akpm@linux-foundation.org>
In-Reply-To: <CAMuHMdXzcRxEBqavTx-kEq6CNAx5fYug0w8kjDw=vNfS2iX4Fw@mail.gmail.com>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
	<20130716004727.b60b2c96.akpm@linux-foundation.org>
	<20130716005611.e4ccab02.akpm@linux-foundation.org>
	<201307161008.07643.yann.morin.1998@free.fr>
	<20130716180408.GA19863@merkur.ravnborg.org>
	<20130717211649.GA5619@merkur.ravnborg.org>
	<20130717223033.GF3385@free.fr>
	<CAMuHMdXzcRxEBqavTx-kEq6CNAx5fYug0w8kjDw=vNfS2iX4Fw@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jul 2013 09:22:58 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Thu, Jul 18, 2013 at 12:30 AM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> > On 2013-07-17 23:16 +0200, Sam Ravnborg spake thusly:
> >> > We could extend the symbol option part to retreive values from a binary.
> >> > Something like this:
> >> >
> >> > config FOOBAR
> >> >         bool
> >> >         option exec="true"
> >> >
> >> > FOOBAR would assume the value "y" if the command true has exit code == 0, otherwise "n".
> >> > And similar conversions for other types.
> >> >
> >> > This only extendt Kconfig slightly - using an already present method to import
> >> > external values.
> >> >
> >> > The drawback I see with this approach is that we may execute a lot of small programs
> >> > where the value is never used.
> >>
> >> Following is a quick patch implmenting this idea.
> >> You need to run gperf manually to enable this.
> >>
> >> "gperf -C scripts/kconfig/zconf.gperf > scripts/kconfig/zconf.hash.c"
> >>
> >> I did not figure out how to use the built-in rules to generate this file :-(
> >
> > make REGENERATE_PARSERS=y menuconfig
> >
> >> I have tested this lightly - as we should discuss if this is a viable way forward.
> >
> > Instead of extending the Kconfig language, I was thinking (as initially
> > suggested by Andrew) of generating a Kconfig file before all config
> > targets, and source that Kconfig file from $(TOPDIR)/Kconfig.
> 
> I also prefer the generated Kconfig file.
> It keeps all these checks in a single place, instead of spreading it over all
> Kconfig files. This allows to keep better control over the list of checks, and
> notice when it gets out-of-hand.

I prefer the "option exec" approach, actually.  That way the shell-outs
are colocated with the code which uses them and they will only be executed
if you've actually selected that subsystem for building (I think?).

