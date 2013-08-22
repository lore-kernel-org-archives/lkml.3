Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab3HVM6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:58:31 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:32963 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab3HVM60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:58:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130821195157.GA18191@merkur.ravnborg.org>
References: <1377073172-3662-1-git-send-email-richard@nod.at>
	<CAMuHMdWk-EPTNmPB1O1+F7YVQLjhQsFJznYwA3t6UCGUU1T9PQ@mail.gmail.com>
	<20130821195157.GA18191@merkur.ravnborg.org>
Date: Thu, 22 Aug 2013 14:58:26 +0200
X-Google-Sender-Auth: DQd6oaOmPgxqVsLie5zKrdlpX8o
Message-ID: <CAMuHMdWqwQxxky7UDnh-oxN13C-sxfnxKVBuBz1GU_RtJvbf3A@mail.gmail.com>
Subject: Re: [RFC] Get rid of SUBARCH
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Richard Weinberger <richard@nod.at>,
        Linux-Arch <linux-arch@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 9:51 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> > The series touches also m68k, sh, mips and unicore32.
>> > These architectures magically select a cross compiler if ARCH != SUBARCH.
>> > Do really need that behavior?
>>
>> This does remove functionality.
>> It allows to build a kernel using e.g. "make ARCH=m68k".
>>
>> Perhaps this can be moved to generic code? Most (not all!) cross-toolchains
>> are called $ARCH-{unknown-,}linux{,-gnu}.
>> Exceptions are e.g. am33_2.0-linux and bfin-uclinux.
>
> Today you can specify CROSS_COMPILE in Kconfig.
> With this we should be able to remove these hacks.

The correct CROSS_COMPILE value depends on the host environment, not
on the target configuration.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
