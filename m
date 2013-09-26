Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3IZOgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:36:46 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:50537 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3IZOgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <524443AC.3040409@nod.at>
References: <1377073172-3662-1-git-send-email-richard@nod.at>
 <1377073172-3662-3-git-send-email-richard@nod.at> <CALkWK0kCrQ9hPABD_XQ9QFG-vByP+xZWZs+RkVK77+cX7Odz7g@mail.gmail.com>
 <52441025.9030308@nod.at> <CALkWK0k5neR50h+AWEF5AgnpbgWMitZUnbv_caVzt6HiUA6mXg@mail.gmail.com>
 <52441407.9010603@nod.at> <CALkWK0=FG4COEjv5+mu1JRiiFQ2k6vop1mhFPmAT4bjtYeK6nA@mail.gmail.com>
 <52442108.1020304@nod.at> <CALkWK0nm=9n7DiV0MaGKVLMs=vxAiiQUx=OFuOg-DinkdMej5A@mail.gmail.com>
 <CALkWK0ndMtyQxE0uK4H-Ly6oy+tRn-SFc=_1WoC2QAp2uy0dtw@mail.gmail.com>
 <CAMuHMdU3LdDhbp_AKjD7b8Wytbqfp29DrPwTdtwQa2hUNdcy3Q@mail.gmail.com> <524443AC.3040409@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 26 Sep 2013 20:06:01 +0530
Message-ID: <CALkWK0kcd03t9W4O24wiVBQ8SZQ8ZcrbvQaUkcCm+y5n=d1wPw@mail.gmail.com>
Subject: Re: [PATCH 2/8] um: Do not use SUBARCH
To: Richard Weinberger <richard@nod.at>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
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

Richard Weinberger wrote:
>> Sorry for chiming in, but... what about cross compiling?
>> SUBARCH=x86 should give you a 32-bit ia32 kernel, right?
>
> Correct.
> Users expect from SUBARCH=x86 a i386 32bit UML kernel.

This is an insane expectation. This is kernel convention (it has
nothing to do with uml):

SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
 -e s/sun4u/sparc64/ \
 -e s/arm.*/arm/ -e s/sa110/arm/ \
 -e s/s390x/s390/ -e s/parisc64/parisc/ \
 -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )

config 64BIT
bool "64-bit kernel" if ARCH = "x86"
default ARCH != "i386"
---help---
 Say yes to build a 64-bit kernel - formerly known as x86_64
 Say no to build a 32-bit kernel - formerly known as i386

If you want to stand on your head and demand that all these
conventions be changed against all reason, I have nothing further to
say.
