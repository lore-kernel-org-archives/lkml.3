Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3IZQHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:07:39 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:40496 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3IZQHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:07:35 -0400
MIME-Version: 1.0
In-Reply-To: <52444CED.40401@nod.at>
References: <1377073172-3662-1-git-send-email-richard@nod.at>
 <1377073172-3662-3-git-send-email-richard@nod.at> <CALkWK0kCrQ9hPABD_XQ9QFG-vByP+xZWZs+RkVK77+cX7Odz7g@mail.gmail.com>
 <52441025.9030308@nod.at> <CALkWK0k5neR50h+AWEF5AgnpbgWMitZUnbv_caVzt6HiUA6mXg@mail.gmail.com>
 <52441407.9010603@nod.at> <CALkWK0=FG4COEjv5+mu1JRiiFQ2k6vop1mhFPmAT4bjtYeK6nA@mail.gmail.com>
 <52442108.1020304@nod.at> <CALkWK0nm=9n7DiV0MaGKVLMs=vxAiiQUx=OFuOg-DinkdMej5A@mail.gmail.com>
 <CALkWK0ndMtyQxE0uK4H-Ly6oy+tRn-SFc=_1WoC2QAp2uy0dtw@mail.gmail.com>
 <CAMuHMdU3LdDhbp_AKjD7b8Wytbqfp29DrPwTdtwQa2hUNdcy3Q@mail.gmail.com>
 <524443AC.3040409@nod.at> <CALkWK0kcd03t9W4O24wiVBQ8SZQ8ZcrbvQaUkcCm+y5n=d1wPw@mail.gmail.com>
 <52444CED.40401@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 26 Sep 2013 21:36:54 +0530
Message-ID: <CALkWK0=u8CdtmbaOtA5=jxuWsei2ZQhxDwSsnhAR=ZRBNyoH6Q@mail.gmail.com>
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
> And, of course, this makes your patch valid.
> Can you also please ensure that your new defconfigs are minimal?

Yeah, it's close to a minimal configuration for the 3.10 kernel
(latest at the time of patch submission). I was aiming to minimize the
diff between the current defconfig and the two new defconfigs in
configs/. The slim diffstat does the talking:

 arch/um/Kconfig.common                          |   5 -
 arch/um/Makefile                                |  11 ++
 arch/um/{defconfig => configs/i386_defconfig}   | 209 +++++++++++++-------
 arch/um/{defconfig => configs/x86_64_defconfig} | 250 +++++++++++++++---------
 arch/x86/um/Kconfig                             |   5 +
 5 files changed, 306 insertions(+), 174 deletions(-)
 copy arch/um/{defconfig => configs/i386_defconfig} (86%)
 rename arch/um/{defconfig => configs/x86_64_defconfig} (83%)

If we find some deficiencies, we can always update it. For now, please
commit these two patches.

Thanks.
