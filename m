Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058Ab3IZN6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:58:11 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52543 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab3IZN6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:58:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdU3LdDhbp_AKjD7b8Wytbqfp29DrPwTdtwQa2hUNdcy3Q@mail.gmail.com>
References: <1377073172-3662-1-git-send-email-richard@nod.at>
 <1377073172-3662-3-git-send-email-richard@nod.at> <CALkWK0kCrQ9hPABD_XQ9QFG-vByP+xZWZs+RkVK77+cX7Odz7g@mail.gmail.com>
 <52441025.9030308@nod.at> <CALkWK0k5neR50h+AWEF5AgnpbgWMitZUnbv_caVzt6HiUA6mXg@mail.gmail.com>
 <52441407.9010603@nod.at> <CALkWK0=FG4COEjv5+mu1JRiiFQ2k6vop1mhFPmAT4bjtYeK6nA@mail.gmail.com>
 <52442108.1020304@nod.at> <CALkWK0nm=9n7DiV0MaGKVLMs=vxAiiQUx=OFuOg-DinkdMej5A@mail.gmail.com>
 <CALkWK0ndMtyQxE0uK4H-Ly6oy+tRn-SFc=_1WoC2QAp2uy0dtw@mail.gmail.com> <CAMuHMdU3LdDhbp_AKjD7b8Wytbqfp29DrPwTdtwQa2hUNdcy3Q@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 26 Sep 2013 19:27:27 +0530
Message-ID: <CALkWK0=6ThJtdu_tqqQFisJSFGE=bfsXAzEo+Yys7wjQS_eYCw@mail.gmail.com>
Subject: Re: [PATCH 2/8] um: Do not use SUBARCH
To: Geert Uytterhoeven <geert@linux-m68k.org>
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

Geert Uytterhoeven wrote:
> Sorry for chiming in, but... what about cross compiling?
> SUBARCH=x86 should give you a 32-bit ia32 kernel, right?

User-Mode Linux only supports two host architectures (called $SUBARCH)
at the moment: i386 and x86_64. If you leave out the $SUBARCH on
either an i386 or x86_64 machine, my patch will automatically pick the
$(uname -m) architecture to build with. To cross-compile, specify the
$SUBARCH explicitly.
