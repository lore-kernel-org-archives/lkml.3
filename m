Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaGHIrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:47:47 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57122 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaGHIro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:47:44 -0400
MIME-Version: 1.0
In-Reply-To: <53BBACF4.4070800@nod.at>
References: <20140705112238.16142.42735.stgit@zurg>
	<20140707150523.cc671116bf366e8db73209c5@linux-foundation.org>
	<CALYGNiMjL_GYqqkid4yQsubpnbydVXxTPnKW0GqJcg05x9zbHQ@mail.gmail.com>
	<CAFLxGvzxvuizdHyjQ0SjUm8jJcj=w+qS5ut-u76Xo-m2sftvvw@mail.gmail.com>
	<CALYGNiOTC8KOxWwRo+f=6JmtUYhJ=1cQNq-Us1BZbW85r4P+ug@mail.gmail.com>
	<53BBA9B4.7050609@nod.at>
	<CALYGNiNSFoW6Z_1o3JfV-cCeay1QmTptrt4kWHVegkuw+-6A8A@mail.gmail.com>
	<53BBACF4.4070800@nod.at>
Date: Tue, 8 Jul 2014 12:47:44 +0400
Message-ID: <CALYGNiND3xk4DGkM_RYApmX7BMkg=cKX2gUpyyOry0ny_DVrkA@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH] checkstack: use $UTS_MACHINE as target architecture
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 12:33 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 08.07.2014 10:30, schrieb Konstantin Khlebnikov:
>> On Tue, Jul 8, 2014 at 12:20 PM, Richard Weinberger <richard@nod.at> wrote:
>>> Am 08.07.2014 10:16, schrieb Konstantin Khlebnikov:
>>>> On Tue, Jul 8, 2014 at 12:01 PM, Richard Weinberger
>>>> <richard.weinberger@gmail.com> wrote:
>>>>> On Tue, Jul 8, 2014 at 7:48 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>>>>>> On Tue, Jul 8, 2014 at 2:05 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>>>>>>> On Sat, 05 Jul 2014 15:22:38 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>>>>>>>
>>>>>>>> This fixes command # make checkstack for i386/x86_64.
>>>>>>>> Looks like $UTS_MACHINE is exactly what scripts/checkstack.pl needs.
>>>>>>>>
>>>>>>>> By default $UTS_MACHINE is equal to $ARCH, but some arch/${ARCH}/Makefile
>>>>>>>> overrides it. This patch updates it also in arch/x86/Makefile.um
>>>>>>>>
>>>>>>>> broken in ffee0de ("x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT")
>>>>>>>
>>>>>>> The changelog doesn't describe the bug which is being fixed.  It should
>>>>>>> do so please.  If there are any compiler/make error messages then those
>>>>>>> should be included.
>>>>>>>
>>>>>>
>>>>>> Oh, ok. checkstalk.pl needs either i386 or x86_64, x86 isn't enough.
>>>>>>
>>>>>> $ make checkstack
>>>>>> objdump -d vmlinux $(find . -name '*.ko') | \
>>>>>> perl /home/blind/src/linux-stable/scripts/checkstack.pl x86
>>>>>> wrong or unknown architecture "x86"
>>>>>
>>>>> And now we need ARCH, SUBARCH and UTS_MACHINE on UML? :-(
>>>>
>>>> Nope UTS_MACHINE is autodetected, see hunk Makefile.x86 in my patch.
>>>>
>>>> I thought about cleaning this part of UML.
>>>> For example we could move arch/x86/um into arch/um/x86 and use # make
>>>> ARCH=um/x86
>>>
>>> No way. We moved the x86 stuff to arch/x86/ a few Years ago by design.
>>
>> Ok, fine. We could leave it in arch/x86/um and use make ARCH=x86/um
>
> I don't like this. Please keep ARCH=um as is.
>
>>>
>>>> after collecting this stuff together it woud be easier to get rid of
>>>> forever-broken parts.
>>>> As I see UML has been designed to work everywhere but SMP seem never worked
>>>> as well as any host os except of linux or other arch except x86.
>>>
>>> Currently UML runs only on x86_32/64.
>>> Adding/fixing SMP support should be doable.
>>
>> This might be quite difficult on top of current ptrace-based design.
>> I thought about running userspace in kvm context, this might be much
>> faster than ptrace but requires indirect uaccess like for 4gb-split.
>> But it's very unlikely that I'll find time for that.
>
> Erm, UML is a systemcall emulator based on ptrace().
> If you make it use any KVM backend there is 0 usecase for UML because we can just use qemu/kvmtool.

But kernel stays in userspace, so it could be easily debugged.
It's like merge kvmtool+linux into one application.

>
> Thanks,
> //richard
