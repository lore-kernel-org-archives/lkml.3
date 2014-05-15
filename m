Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaEOTTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbaEOTTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:19:23 -0400
Message-ID: <5375110A.1010307@redhat.com>
Date: Thu, 15 May 2014 15:10:02 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Davidlohr Bueso <davidlohr@hp.com>,
        mtk.manpages@gmail.com
CC: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com>	 <CF98E3EF.90564%dvhart@linux.intel.com>	 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <1400100977.3865.30.camel@buesod1.americas.hpqcorp.net> <53740A30.20807@zytor.com>
In-Reply-To: <53740A30.20807@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 08:28 PM, H. Peter Anvin wrote:
> On 05/14/2014 01:56 PM, Davidlohr Bueso wrote:
>>>
>>>> However, unless I'm sorely mistaken, the larger problem is that glibc
>>>> removed the futex() call entirely, so these man pages don't describe
>>>
>>> I don't think futex() ever was in glibc--that's by design, and
>>> completely understandable: no user-space application would want to
>>> directly use futex(). 
>>
>> That's actually not quite true. There are plenty of software efforts out
>> there that use futex calls directly to implement userspace serialization
>> mechanisms as an alternative to the bulky sysv semaphores. I worked
>> closely with an in-memory DB project that makes heavy use of them. Not
>> everyone can simply rely on pthreads.
>>
> 
> More fundamentally, futex(2), like clone(2), are things that can be
> legitimately by user space without automatically breaking all of glibc.
>  There are some other things where that is *not* true, because glibc
> relies on being able to mediate all accesses to a kernel facility, but
> not here.

Careful there. There is *some* danger in using clone(2) because of the
coordination required to implement thread-local storage. I'm sure you're
aware of this, but I'd like the record to show that we're going to need
clear documentation of what's considered safe given the known
implementations.

Cheers,
Carlos.

