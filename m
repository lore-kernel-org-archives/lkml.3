Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaENUpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:45:11 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:52291 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaENUpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:45:07 -0400
MIME-Version: 1.0
In-Reply-To: <5373D0CA.2050204@redhat.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 May 2014 13:44:46 -0700
Message-ID: <CALCETrU+DgzcjwjLUuvUrxnDDtjELOdPWXOgPFfbHiL6p-XvPA@mail.gmail.com>
Subject: Re: futex(2) man page update help request
To: "Carlos O'Donell" <carlos@redhat.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 1:23 PM, Carlos O'Donell <carlos@redhat.com> wrote:
> On 05/14/2014 03:03 PM, Michael Kerrisk (man-pages) wrote:
>>> However, unless I'm sorely mistaken, the larger problem is that glibc
>>> removed the futex() call entirely, so these man pages don't describe
>>
>> I don't think futex() ever was in glibc--that's by design, and
>> completely understandable: no user-space application would want to
>> directly use futex(). (BTW, I mispoke in my earlier mail when I said I
>> wanted documentation suitable for "writers of library functions" -- I
>> meant suitable for "writers of *C library*".)
>
> I fully agree with Michael here.
>
> The futex() syscall was never exposed to userspace specifically because
> it was an interface we did not want to support forever with a stable ABI.
> The futex() syscall is an implementation detail that is shared between
> the kernel and the writers of core runtimes for Linux.
>
> The fact that the futex() syscall is out of date is my fault, is the fault
> of Linux kernel developers, etc. etc., we should all have reached out to
> Michael with patches to keep this developer-centric documentation updated.

I realize that this is out of scope for linux-abi, but I *stongly*
disagree with this notion.  futex() needs to be just as stable as
anything else: old glibc versions must continue to work.  I just
jumped through a bunch of hoops to keep a single glibc patch release
in OpenSUSE 9 working in a maintainable way; breaking futex will break
far more than that.

Additionally, at least the FUTEX_WAIT and FUTEX_WAKE operations are
extremely useful, and they can do things that are tedious at best
using mutexes and condvars.  It's a simple API to use.  I use it, and
I've seen plenty of other open-source apps using the futex API
directly.

I think the best way forward might be to try to convince the glibc
maintainers to add the wrapper.

--Andy
