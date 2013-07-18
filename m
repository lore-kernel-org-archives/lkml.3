Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3GRHrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:47:10 -0400
Received: from r-mail2.rd.orange.com ([217.108.152.42]:33778 "EHLO
	r-mail2.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3GRHrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:47:08 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new streaming format
Date: Thu, 18 Jul 2013 09:47:02 +0200
User-Agent: KMail/1.13.5 (Linux/3.9.10-ilmarinen-nv; KDE/4.4.5; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild" <linux-kbuild@vger.kernel.org>,
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
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com> <CAMuHMdXzcRxEBqavTx-kEq6CNAx5fYug0w8kjDw=vNfS2iX4Fw@mail.gmail.com> <20130718003408.bb9d5b51.akpm@linux-foundation.org>
In-Reply-To: <20130718003408.bb9d5b51.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307180947.02456.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 18 Jul 2013 07:47:02.0947 (UTC) FILETIME=[FDF0DF30:01CE838A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, All,

On Thursday 18 July 2013 09:34:08 Andrew Morton wrote:
> On Thu, 18 Jul 2013 09:22:58 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Thu, Jul 18, 2013 at 12:30 AM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> > > On 2013-07-17 23:16 +0200, Sam Ravnborg spake thusly:
> > >> > We could extend the symbol option part to retreive values from a binary.
> > >> > Something like this:
> > >> >
> > >> > config FOOBAR
> > >> >         bool
> > >> >         option exec="true"
> > >> >
> > >> > FOOBAR would assume the value "y" if the command true has exit code == 0, otherwise "n".
> > >> > And similar conversions for other types.
> > >> >
> > >> > This only extendt Kconfig slightly - using an already present method to import
> > >> > external values.
> > >> Following is a quick patch implmenting this idea.
> > >> You need to run gperf manually to enable this.
> > >>
> > >> "gperf -C scripts/kconfig/zconf.gperf > scripts/kconfig/zconf.hash.c"
> > >>
> > >> I did not figure out how to use the built-in rules to generate this file :-(
> > >
> > > make REGENERATE_PARSERS=y menuconfig
> > >
> > >> I have tested this lightly - as we should discuss if this is a viable way forward.
> > >
> > > Instead of extending the Kconfig language, I was thinking (as initially
> > > suggested by Andrew) of generating a Kconfig file before all config
> > > targets, and source that Kconfig file from $(TOPDIR)/Kconfig.
> > 
> > I also prefer the generated Kconfig file.
> > It keeps all these checks in a single place, instead of spreading it over all
> > Kconfig files. This allows to keep better control over the list of checks, and
> > notice when it gets out-of-hand.
> 
> I prefer the "option exec" approach, actually.  That way the shell-outs
> are colocated with the code which uses

Indeed, but in this case, all the checks will be spread-out in the Kconfig
files, and not easily locatable. Having all in a single script will also
more easily raise eyebrows when that script appears in a diffstat. Noticing
the 'exec' option risks being a bit less easy.

But, that's not my call to decide. ;-)

> them and they will only be executed
> if you've actually selected that subsystem for building (I think?).

If I understand the code correctly (which is still to be proven), the
exec option is run at parse-time, once.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
