Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3IZL6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:58:14 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64006 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab3IZL6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:58:11 -0400
MIME-Version: 1.0
In-Reply-To: <52440DE0.1030807@nod.at>
References: <1377073172-3662-1-git-send-email-richard@nod.at>
 <1377073172-3662-2-git-send-email-richard@nod.at> <CALkWK0=W38JpZoGVkPYD4qd=+Pt1G7oYPEK_R=c8TAW6W=wxyg@mail.gmail.com>
 <52440DE0.1030807@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 26 Sep 2013 17:27:29 +0530
Message-ID: <CALkWK0nEy90VrWawTpYsLNJcnyRSizgArCa-qnzpuJQkyK6zHA@mail.gmail.com>
Subject: Re: [PATCH 1/8] um: Create defconfigs for i386 and x86_64
To: Richard Weinberger <richard@nod.at>
Cc: linux-arch@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        geert@linux-m68k.org, ralf@linux-mips.org, lethal@linux-sh.org,
        Jeff Dike <jdike@addtoit.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
>> $ file linux
>> linux: ELF 32-bit LSB  executable, Intel 80386, version 1 (SYSV),
>> dynamically linked (uses shared libs), for GNU/Linux 2.6.32, not
>> stripped
>> $ ./linux ubd0=busybox-rootfs
>> [...]
>> Kernel panic - not syncing: No init found.  Try passing init= option
>> to kernel. See Linux Documentation/init.txt for guidance.
>
> I don't know that rootfs but it looks like there is no init.

Ofcourse there's an init on the busybox-rootfs, and I'm able to boot
it with an x86_64 Linux. The reason for panic is incorrect: I think
(although not sure) a 32-bit rootfs userland will work.

>> [1]    25526 abort (core dumped)  linux ubd0=busybox-rootfs
>>                                                            %
>>
>> Rubbish.
>
> UML core dumps at panic() by design.

On a related note, why does it screw up my terminal? I have to `reset`
to get a nice working terminal.

> Seriously, my plan is to get rid of SUBARCH, that's why I did not push your patches
> upstream and I've send the rid of SUBARCH patch series.
> It turned out that other archs depend on SUBARCH too therefore some more thinking is needed.
> Time passed, merge window closed, $dayjob needed some attention...

Don't let some grand plan stall reasonable patches that fix immediate problems.

> That said, your "arch/um: make it work with defconfig and x86_64" patch is also not perfect.
> "make defconfig ARCH=um SUBARCH=x86" will create x86_64 defconfig, which is wrong and breaks existing
> setups.

Wrong.

  $ make defconfig ARCH=um SUBARCH=i386
  *** Default configuration is based on 'i386_defconfig'
  #
  # configuration written to .config
  #

I can build a 32-bit kernel just fine with my patch applied.
