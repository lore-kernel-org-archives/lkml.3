Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3I0JWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 05:22:50 -0400
Received: from mout.gmx.net ([212.227.17.21]:65462 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab3I0JWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 05:22:44 -0400
Message-ID: <52454E58.3010305@gmx.de>
Date: Fri, 27 Sep 2013 11:22:32 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: Richard Weinberger <richard@nod.at>, linux-arch@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, geert@linux-m68k.org,
        ralf@linux-mips.org, lethal@linux-sh.org,
        Jeff Dike <jdike@addtoit.com>, gxt@mprc.pku.edu.cn,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/8] um: Create defconfigs for i386 and x86_64
References: <1377073172-3662-1-git-send-email-richard@nod.at> <1377073172-3662-2-git-send-email-richard@nod.at> <CALkWK0=W38JpZoGVkPYD4qd=+Pt1G7oYPEK_R=c8TAW6W=wxyg@mail.gmail.com> <52440DE0.1030807@nod.at>
In-Reply-To: <52440DE0.1030807@nod.at>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:2YaV8MxdfXdqR40wi+bN9mUWqp5GHAiqCfPXpSl0P2GMCa6xPVq
 dIGo+DWirZMYUL9AeMI7INKvFrrP0khWggyfH86DHrbAG0N1i6uBBZjk8MSpZpgjQdIYbZC
 vz0NaNaXaALMYINkBmj2v6NvBFAGyVsNHw0OctK4++Lz+h4J6Yp89cDWK6wgpoxQDGOCpN8
 3kWwppM/u4RGIQ8/8s4Og==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 12:35 PM, Richard Weinberger wrote:
> Am 26.09.2013 12:20, schrieb Ramkumar Ramachandra:
>> Richard Weinberger wrote:
>>> This patch is based on: https://lkml.org/lkml/2013/7/4/396
>>>
>>> Cc: Ramkumar Ramachandra <artagnon@gmail.com>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>>  arch/um/configs/i386_defconfig   | 954 +++++++++++++++++++++++++++++++++++++++
>>>  arch/um/configs/x86_64_defconfig | 943 ++++++++++++++++++++++++++++++++++++++
>>>  2 files changed, 1897 insertions(+)
>>>  create mode 100644 arch/um/configs/i386_defconfig
>>>  create mode 100644 arch/um/configs/x86_64_defconfig
>>
>> First, I'm pissed that the upstream tree doesn't build and run out of
>> the box months after I submitted a fix in July (and it's September
>> now). Fact that you dropped my sane patches aside and decided to write
>> a much larger series aside, user-mode Linux in upstream is broken.
>> This means that any user who does:
>>
>> $ ARCH=um make defconfig
>> $ ARCH=um make
>>
>> will end up with a *broken* Linux _today_. Unless the user is living
>> in the Stone Age with a 32-bit computer, this is what she will see
>> when she attempts to boot up Linux:

:-{

Grmpf

There are a lot of 32 bit user land linux installation (beside my own,
look at the x86 Gentoo world) in the wild - even running on modern 64bit
CPUs. The simple reason is that those installations run fine and the
performance "boost" of 64bit often isn't worth a new reinstallation.

--
the stone-age-Toralf

> 
> Not here.
> 
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
> 
>> CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc2-00083-g4b97280 #1
>> 0b869fbc 08272f87 0b869fdc 0820c5cd 00000001 00000000 00000000 00000000
>>        0b869fe8 0820c126 08252593 0b869ff8 08059317 00000000 00000001 00000000
>>        00000000 0b869f94:  [<0805a11c>] show_stack+0x54/0x8c
>> 0b869fb4:  [<0820e3c8>] dump_stack+0x16/0x1b
>> 0b869fc8:  [<0820c5cd>] panic+0x67/0x149
>> 0b869fe0:  [<0820c126>] kernel_init+0xab/0xaf
>> 0b869fec:  [<08059317>] new_thread_handler+0x63/0x7c
>> 0b869ffc:  [<00000000>] 0x0
>>
>>
>> EIP: 0023:[<f7717430>] CPU: 0 Not tainted ESP: 002b:ffc386dc EFLAGS: 00000296
>>     Not tainted
>> EAX: 00000000 EBX: 000063ba ECX: 00000013 EDX: 000063ba
>> ESI: 000063b6 EDI: 00000002 EBP: ffc38708 DS: 002b ES: 002b
>> 0b869f44:  [<0806aff4>] show_regs+0xb4/0xbc
>> 0b869f70:  [<0805b23b>] panic_exit+0x20/0x36
>> 0b869f84:  [<0808521b>] notifier_call_chain+0x28/0x4b
>> 0b869fac:  [<0808526c>] atomic_notifier_call_chain+0x15/0x17
>> 0b869fbc:  [<0820c5de>] panic+0x78/0x149
>> 0b869fe0:  [<0820c126>] kernel_init+0xab/0xaf
>> 0b869fec:  [<08059317>] new_thread_handler+0x63/0x7c
>> 0b869ffc:  [<00000000>] 0x0
>>
>> [1]    25526 abort (core dumped)  linux ubd0=busybox-rootfs
>>                                                            %
>>
>> Rubbish.
> 
> UML core dumps at panic() by design.
> 
>> When I rebase my original patches (exactly 2 small independent
>> patches) onto the new upstream, stuff works as usual. If you're not
>> convinced, try the um-build branch from
>> https://github.com/artagnon/linux for yourself.
> 
>> Are you against accepting good patches and stalling work? What is your
>> plan exactly?
> 
> Sure, my great plan is to destroy Linux. I work for Microsoft. ;-)
> 
> Seriously, my plan is to get rid of SUBARCH, that's why I did not push your patches
> upstream and I've send the rid of SUBARCH patch series.
> It turned out that other archs depend on SUBARCH too therefore some more thinking is needed.
> Time passed, merge window closed, $dayjob needed some attention...
> 
> That said, your "arch/um: make it work with defconfig and x86_64" patch is also not perfect.
> "make defconfig ARCH=um SUBARCH=x86" will create x86_64 defconfig, which is wrong and breaks existing
> setups.
> Secondly, what stops you from running "make defconfig ARCH=um SUBARCH=x86_64" to run your x86_64 bit
> userspace?
> 
> Thanks,
> //richard
> 


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
