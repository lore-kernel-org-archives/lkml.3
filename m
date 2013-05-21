Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3EULIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 07:08:00 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63367 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3EULH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 07:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <519B278B.6030708@asianux.com>
References: <5199B7D6.40907@asianux.com>
	<20130520091008.GB31359@mudshark.cambridge.arm.com>
	<519AE6D7.1090401@asianux.com>
	<CAMuHMdWNHPDkf35MYMKnxt5pn3a+dsT4jgYxuuHrp+mpZMckfw@mail.gmail.com>
	<519B278B.6030708@asianux.com>
Date: Tue, 21 May 2013 13:07:58 +0200
X-Google-Sender-Auth: QKJoQOTGHhMPEqraZLtuJLP6YV4
Message-ID: <CAMuHMdWqDDe4gtjO8A2ds_46NQ_XGkVFj9TqJPGWtAtr7_ef8A@mail.gmail.com>
Subject: Re: [PATCH] arm64: kernel: need extern variable 'screen_info' for
 related driver using.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 9:51 AM, Chen Gang <gang.chen@asianux.com> wrote:
> On 05/21/2013 02:57 PM, Geert Uytterhoeven wrote:
>> On Tue, May 21, 2013 at 5:15 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>>> >> I think it would be better if we added a something like
>>>> >> CONFIG_HAVE_VGA_CONSOLE, which VGA_CONSOLE can then depend on. Architectures
>>>> >> like x86 can then select the former, and we can remove the long list of
>>>> >> architectures from the current option.
>>> >
>>> > I guess your meaning is:
>>> >
>>> >   under arm64, actually, need not support 'VGA_CONSOLE', and 'screen_info' is useless.
>>> >   So better to define 'CONFIG_HAVE_VGA_CONSOLE' which 'VGA_CONSOLE' can depend on it, and in arm64, we do not define CONFIG_HAVE_VGA_CONSOLE.
>>> >
>>> > Is it correct ?
>> No, you missed "and we can remove the long list of architectures from the
>> current option".
>>
>
> OK, thanks.
>
> Is it correct: "it is unnecessary to add 'screen_info' to the code, for
> arm64 will never support 'VGA_CONSOLE'" ?

On arm (not (yet?) arm64), drivers/video/console/dummycon.c also uses
screen_info. The default text mode resolution may come from atags.

>>> > If so, I recommend to add depend item for VGA_CONSOLE directly:
>> I strongly support CONFIG_HAVE_VGA_CONSOLE.
>
> For me, I still recommend add 'ARM64' in the long list of architectures
> for 'VGA_CONSOLE', I have 3 reasons, please check:
>
> a. current implementation only changes one area which only related with
> arm64 and 'VGA_CONSOLE', but if use 'CONFIG_HAVE_VGA_CONSOLE', that will
> touch many multiple platforms dependency, at least we need discuss about
> it with multiple platforms guys for it, firstly.

Sure. But this can be one cleanup patch.

> b. We can find some cases to use CONFIG_HAVE_* as dpend on, but I can
> not find any cases which let CONFIG_'samename' depend on
> CONFIG_HAVE_'samename'.

A similar mechanism is used for PC-style floppy support, but the naming
is different, cfr. drivers/block/Kconfig:

config BLK_DEV_FD
        tristate "Normal floppy disk support"
        depends on ARCH_MAY_HAVE_PC_FDC

so perhaps ARCH_MAY_HAVE_VGA?

PARPORT_PC could use the same mechanism.

> c. The original way still has effect, although it seems not quit
> beautiful, but it is correct and still clear for readers, it is still
> sustainable.

Most/every new architecture needs to add a depend to it.

BTW, I should have done this when sending out the patch to add CRIS to the
list of dependencies...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
