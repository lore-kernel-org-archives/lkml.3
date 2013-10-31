Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3JaXvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:51:07 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:59194 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab3JaXvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:51:05 -0400
MIME-Version: 1.0
In-Reply-To: <1590011.bKaf2byiPL@sifl>
References: <CALCETrXyLBXmimjLepU=y1igmWpwcdWUNCqNjMHi_jyLw0pHMA@mail.gmail.com>
 <4195093.ULJiSLViSo@sifl> <526EE234.2070709@nod.at> <1590011.bKaf2byiPL@sifl>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 31 Oct 2013 16:50:44 -0700
Message-ID: <CALCETrWfH7BqkbVU35pbUjym3zhKC2tWJgr_9C13zgZmFW2OvA@mail.gmail.com>
Subject: Re: ARM seccomp filters and EABI/OABI
To: Paul Moore <paul@paul-moore.com>
Cc: Richard Weinberger <richard@nod.at>,
        libseccomp-discuss@lists.sourceforge.net,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 12:38 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Monday, October 28, 2013 11:16:20 PM Richard Weinberger wrote:
>> Am 28.10.2013 22:53, schrieb Paul Moore:
>> > On Thursday, October 24, 2013 09:55:57 PM Richard Weinberger wrote:
>> >> On Wed, Oct 23, 2013 at 11:02 PM, Andy Lutomirski <luto@amacapital.net>
>> >
>> > wrote:
>> >>> I'm looking at the seccomp code, the ARM entry code, and the
>> >>> syscall(2) manpage, and I'm a bit lost.  (The fact that I don't really
>> >>> speak ARM assembly doesn't help.)  My basic question is: what happens
>> >>> if an OABI syscall happens?
>> >>>
>> >>> AFAICS, the syscall arguments for EABI are r0..r5, although their
>> >>> ordering is a bit odd*.  For OABI, r6 seems to play some role, but I'm
>> >>> lost as to what it is.  The seccomp_bpf_load function won't load r6,
>> >>> so there had better not be anything useful in there...  (Also, struct
>> >>> seccomp_data will have issues with a seventh "argument".)
>> >>>
>> >>> But what happens to the syscall number?  For an EABI syscall, it's in
>> >>> r7.  For an OABI syscall, it's in the swi instruction and gets copied
>> >>> to r7 on entry.  If a debugger changes r7, presumably the syscall
>> >>> number changes.
>> >>>
>> >>> Oddly, there are two different syscall tables.  The major differences
>> >>> seem to be that some of the OABI entries have their argument order
>> >>> changed.  But there's also a magic constant 0x900000 added to the
>> >>> syscall number somewhere -- is it reflected in _sigsys._syscall?  Is
>> >>> it reflected in ucontext's r7?
>> >>>
>> >>> I'm a bit surprised to see that both the EABI and OABI ABIs show up as
>> >>> AUDIT_ARCH_ARM.
>> >>>
>> >>> Can any of you shed some light on this?  I don't have an ARM system I
>> >>> can test on, but if one of you can point me at a decent QEMU image, I
>> >>> can play around.
>> >>
>> >> Maybe this helps:
>> >> http://people.debian.org/~aurel32/qemu/armel/
>> >
>> > Thanks for the pointer, although those images look quite old, has anyone
>> > done a refresh?
>>
>> You are free to run "apt-get upgrade" within the said images. :-)
>
> Okay, true ;)

Except it didn't work...  I fixed it with 'apt-key adv --recv-keys
--keyserver keyserver.ubuntu.com <key id from update's error
message>'.

I have yet to build a working kernel for this thing, though.
Apparently kernels since 3.8 have something wrong in the "versatile"
board file.  Do any of you have a working .config and qemu -M option?

>
> --
> paul moore
> www.paul-moore.com
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
