Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbaEOOjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:39:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaEOOjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:39:53 -0400
Message-ID: <5374D18D.6020608@redhat.com>
Date: Thu, 15 May 2014 10:39:09 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: mtk.manpages@gmail.com, Peter Zijlstra <peterz@infradead.org>
CC: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <20140515081444.GD11096@twins.programming.kicks-ass.net> <5374BE9E.8080408@redhat.com> <20140515132235.GM30445@twins.programming.kicks-ass.net> <CAKgNAkjrS8WWMoQzsiOkMVn1_Bf06uFCL6ECU7z=mv0fszg+gQ@mail.gmail.com>
In-Reply-To: <CAKgNAkjrS8WWMoQzsiOkMVn1_Bf06uFCL6ECU7z=mv0fszg+gQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 09:49 AM, Michael Kerrisk (man-pages) wrote:
> On Thu, May 15, 2014 at 3:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Thu, May 15, 2014 at 09:18:22AM -0400, Carlos O'Donell wrote:
>>> On 05/15/2014 04:14 AM, Peter Zijlstra wrote:
>>>> On Wed, May 14, 2014 at 04:23:38PM -0400, Carlos O'Donell wrote:
>>>>> There are other syscalls like gettid() that have a:
>>>>> NOTE: There is no glibc wrapper for this system call; see NOTES.
>>>>
>>>> Yes, can we finally fix that please? It gets tedious having to endlessly
>>>> copy/paste that thing around.
>>>
>>> What exactly would you like fixed?
>>
>> Not having gettid() in glibc.
> 
> Get in the line ;-).
> http://sourceware.org/bugzilla/show_bug.cgi?id=6399

I have no objections to this, but I absolutely object to this without
someone documenting and gathering consensus for consistent terminology
to be used between the kernel and glibc.

The relevant comment is here:
https://sourceware.org/bugzilla/show_bug.cgi?id=6399#c26

I'd like to see a glibc manual patch for the threads.texi file, which
can be completely linux-specific, to document gettid() and nomenclature.
It should talk about the nomenclature used to discuss these interfaces
and explain when it is or isn't valid to use a task id and with what 
functions.

For example does gettid *really* return a pid_t as considered by
userspace? It's not a full out process...

Cheers,
Carlos.
