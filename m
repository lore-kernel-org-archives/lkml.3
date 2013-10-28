Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab3J1WQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 18:16:31 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757642Ab3J1WQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 18:16:29 -0400
Message-ID: <526EE234.2070709@nod.at>
Date: Mon, 28 Oct 2013 23:16:20 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        libseccomp-discuss@lists.sourceforge.net,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ARM seccomp filters and EABI/OABI
References: <CALCETrXyLBXmimjLepU=y1igmWpwcdWUNCqNjMHi_jyLw0pHMA@mail.gmail.com> <CAFLxGvwT+KDSTjJnd8HUhQivmpB3ZwjrXs1OxF8ctL7k6tN0Lw@mail.gmail.com> <4195093.ULJiSLViSo@sifl>
In-Reply-To: <4195093.ULJiSLViSo@sifl>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.10.2013 22:53, schrieb Paul Moore:
> On Thursday, October 24, 2013 09:55:57 PM Richard Weinberger wrote:
>> On Wed, Oct 23, 2013 at 11:02 PM, Andy Lutomirski <luto@amacapital.net> 
> wrote:
>>> I'm looking at the seccomp code, the ARM entry code, and the
>>> syscall(2) manpage, and I'm a bit lost.  (The fact that I don't really
>>> speak ARM assembly doesn't help.)  My basic question is: what happens
>>> if an OABI syscall happens?
>>>
>>> AFAICS, the syscall arguments for EABI are r0..r5, although their
>>> ordering is a bit odd*.  For OABI, r6 seems to play some role, but I'm
>>> lost as to what it is.  The seccomp_bpf_load function won't load r6,
>>> so there had better not be anything useful in there...  (Also, struct
>>> seccomp_data will have issues with a seventh "argument".)
>>>
>>> But what happens to the syscall number?  For an EABI syscall, it's in
>>> r7.  For an OABI syscall, it's in the swi instruction and gets copied
>>> to r7 on entry.  If a debugger changes r7, presumably the syscall
>>> number changes.
>>>
>>> Oddly, there are two different syscall tables.  The major differences
>>> seem to be that some of the OABI entries have their argument order
>>> changed.  But there's also a magic constant 0x900000 added to the
>>> syscall number somewhere -- is it reflected in _sigsys._syscall?  Is
>>> it reflected in ucontext's r7?
>>>
>>> I'm a bit surprised to see that both the EABI and OABI ABIs show up as
>>> AUDIT_ARCH_ARM.
>>>
>>> Can any of you shed some light on this?  I don't have an ARM system I
>>> can test on, but if one of you can point me at a decent QEMU image, I
>>> can play around.
>>
>> Maybe this helps:
>> http://people.debian.org/~aurel32/qemu/armel/
> 
> Thanks for the pointer, although those images look quite old, has anyone done 
> a refresh?

You are free to run "apt-get upgrade" within the said images. :-)

Thanks,
//richard
