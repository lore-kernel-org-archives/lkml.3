Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaENUYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:24:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaENUY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:24:28 -0400
Message-ID: <5373D0CA.2050204@redhat.com>
Date: Wed, 14 May 2014 16:23:38 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: mtk.manpages@gmail.com, Darren Hart <dvhart@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
In-Reply-To: <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 03:03 PM, Michael Kerrisk (man-pages) wrote:
>> However, unless I'm sorely mistaken, the larger problem is that glibc
>> removed the futex() call entirely, so these man pages don't describe
> 
> I don't think futex() ever was in glibc--that's by design, and
> completely understandable: no user-space application would want to
> directly use futex(). (BTW, I mispoke in my earlier mail when I said I
> wanted documentation suitable for "writers of library functions" -- I
> meant suitable for "writers of *C library*".)

I fully agree with Michael here.

The futex() syscall was never exposed to userspace specifically because
it was an interface we did not want to support forever with a stable ABI.
The futex() syscall is an implementation detail that is shared between
the kernel and the writers of core runtimes for Linux.

The fact that the futex() syscall is out of date is my fault, is the fault
of Linux kernel developers, etc. etc., we should all have reached out to
Michael with patches to keep this developer-centric documentation updated.
 
>> something users even have access to anymore. I had to revert to calling
>> the syscalls directly in the futextest test suite because of this:
>>
>> http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inclu
>> de/futextest.h#n67
>>
>>
>> Which basically defines:
>>
>> #define futex(uaddr, op, val, timeout, uaddr2, val3, opflags) \
>>         syscall(SYS_futex, uaddr, op | opflags, val, timeout, uaddr2, val3)
>>
>>
>> Adding Carlos for his perspective.
>>
>> If I'm wrong, or we can restore the futex() call, great. If not... Should
>> we keep the man-pages and document it as syscall(SYS_futex, ..., op, ...) ?
> 
> We should keep the man page ;-). I just need to add some words to
> point out the use of syscall(). Mostly though, I'm interested in
> getting documentation of the operations listed below :-).

Agreed. The man page should get expanded and should be as detailed as possible
about the interface the kernel is exposing.

There are other syscalls like gettid() that have a:
NOTE: There is no glibc wrapper for this system call; see NOTES.

That's what should happen here with futex() (though NOTES does mention this,
but it's not called out at the top of the man page).

Cheers,
Carlos.
