Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750966Ab3IZN0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:26:12 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63186 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3IZN0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:26:06 -0400
MIME-Version: 1.0
In-Reply-To: <CALkWK0ndMtyQxE0uK4H-Ly6oy+tRn-SFc=_1WoC2QAp2uy0dtw@mail.gmail.com>
References: <1377073172-3662-1-git-send-email-richard@nod.at>
	<1377073172-3662-3-git-send-email-richard@nod.at>
	<CALkWK0kCrQ9hPABD_XQ9QFG-vByP+xZWZs+RkVK77+cX7Odz7g@mail.gmail.com>
	<52441025.9030308@nod.at>
	<CALkWK0k5neR50h+AWEF5AgnpbgWMitZUnbv_caVzt6HiUA6mXg@mail.gmail.com>
	<52441407.9010603@nod.at>
	<CALkWK0=FG4COEjv5+mu1JRiiFQ2k6vop1mhFPmAT4bjtYeK6nA@mail.gmail.com>
	<52442108.1020304@nod.at>
	<CALkWK0nm=9n7DiV0MaGKVLMs=vxAiiQUx=OFuOg-DinkdMej5A@mail.gmail.com>
	<CALkWK0ndMtyQxE0uK4H-Ly6oy+tRn-SFc=_1WoC2QAp2uy0dtw@mail.gmail.com>
Date: Thu, 26 Sep 2013 15:26:06 +0200
X-Google-Sender-Auth: c9mgEBMiyOZqwSMTEGFW8E0oEMk
Message-ID: <CAMuHMdU3LdDhbp_AKjD7b8Wytbqfp29DrPwTdtwQa2hUNdcy3Q@mail.gmail.com>
Subject: Re: [PATCH 2/8] um: Do not use SUBARCH
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Richard Weinberger <richard@nod.at>,
        Linux-Arch <linux-arch@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 3:13 PM, Ramkumar Ramachandra
<artagnon@gmail.com> wrote:
> Ramkumar Ramachandra wrote:
>> Richard Weinberger wrote:
>>> I told you already that "make defconfig ARCH=um SUBARCH=x86" will spuriously
>>> create a x86_64 config on x86_64.
>>> This breaks existing setups.
>>
>> I'll fix this and resubmit soon.
>
> Wait a minute. You're now arguing about whether the generic "x86"
> means i386 or x86_64. Its meaning is already defined in
> arch/x86/Kconfig and arch/x86/um/Kconfig: see the config 64BIT. Unless
> i386 is explicitly specified, the default is to build a 64-bit kernel.
> That is already defined for a normal Linux kernel, and user-mode Linux
> should not break that convention. So, in the example you pulled out of
> your hat:
>
>   $ make defconfig ARCH=um SUBARCH=x86
>
> the user should expect a 64-bit build, and not an i386 build as you
> say. Both my patches are correct, and the "regression" that you
> pointed out is a red herring.

Sorry for chiming in, but... what about cross compiling?
SUBARCH=x86 should give you a 32-bit ia32 kernel, right?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
