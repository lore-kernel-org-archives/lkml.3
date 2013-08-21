Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab3HUMQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:16:27 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1662 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751498Ab3HUMQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:16:25 -0400
Message-ID: <5214AF8E.1010406@nod.at>
Date: Wed, 21 Aug 2013 14:16:14 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux-Arch <linux-arch@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [RFC] Get rid of SUBARCH
References: <1377073172-3662-1-git-send-email-richard@nod.at> <CAMuHMdWk-EPTNmPB1O1+F7YVQLjhQsFJznYwA3t6UCGUU1T9PQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWk-EPTNmPB1O1+F7YVQLjhQsFJznYwA3t6UCGUU1T9PQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.08.2013 14:07, schrieb Geert Uytterhoeven:
> On Wed, Aug 21, 2013 at 10:19 AM, Richard Weinberger <richard@nod.at> wrote:
>> This series is an attempt to remove the SUBARCH make parameter.
>> It as introduced at the times of Linux 2.5 for UML to tell the UML
>> build system what the real architecture is.
>>
>> But we actually don't need SUBARCH, we can store this information
>> in the .config file.
> 
> Haha, now you have OS_ARCH (shouldn't that be called HOST_ARCH?) instead,
> which is available only for UM?

We have already OS (which is always "Linux"), so OS_ARCH is IMHO a good choice.
UML always needs to know what the underlying arch is.

OS_ARCH is not only visible to arch/um/ because of that code in the global Makefile:

# UML needs a little special treatment here.  It wants to use the host
# toolchain, so needs $(SUBARCH) passed to checkstack.pl.  Everyone
# else wants $(ARCH), including people doing cross-builds, which means
# that $(SUBARCH) doesn't work here.
ifeq ($(ARCH), um)
CHECKSTACK_ARCH := $(SUBARCH)
else
CHECKSTACK_ARCH := $(ARCH)
endif

scripts/tags.sh also needs some work. V2 will contain a patch for that.

>> The series touches also m68k, sh, mips and unicore32.
>> These architectures magically select a cross compiler if ARCH != SUBARCH.
>> Do really need that behavior?
> 
> This does remove functionality.
> It allows to build a kernel using e.g. "make ARCH=m68k".

If this functionality is expected and has users I'll happily keep that.

> Perhaps this can be moved to generic code? Most (not all!) cross-toolchains
> are called $ARCH-{unknown-,}linux{,-gnu}.
> Exceptions are e.g. am33_2.0-linux and bfin-uclinux.

Sounds good.

>> [PATCH 1/8] um: Create defconfigs for i386 and x86_64
>> [PATCH 3/8] um: Remove old defconfig
> 
> Why not merge these two, so git copy/rename detection will show only the real
> changes?

Will do.

Thanks,
//richard
