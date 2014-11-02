Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaKBUP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:15:56 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:44042 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaKBUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:15:54 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411012308490.5308@nanos>
References: <cover.1414190806.git.luto@amacapital.net> <266afcba1d1f91ea5501e4e16e94bbbc1a9339b6.1414190806.git.luto@amacapital.net>
 <alpine.DEB.2.11.1411012058030.5308@nanos> <CALCETrXBkc8_rMdr0ueBTBYwSVQ7C3juZo4JCEY9UU=rm_nNww@mail.gmail.com>
 <alpine.DEB.2.11.1411012135040.5308@nanos> <CALCETrVjG4T-+jZ+4AZX-i9s_Do8BY=+fp1JmWCxnbAfGiVvug@mail.gmail.com>
 <alpine.DEB.2.11.1411012308490.5308@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 2 Nov 2014 12:15:29 -0800
Message-ID: <CALCETrWhGUDn0OzsTc1dxMvpSEw9fnRiyjP79FRvF7DTJic6oQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] perf: Add pmu callbacks to track event mapping and unmapping
To: Thomas Gleixner <tglx@linutronix.de>
Cc: X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        Vince Weaver <vince@deater.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Kees Cook <keescook@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2014 at 3:10 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 1 Nov 2014, Andy Lutomirski wrote:
>> On Nov 1, 2014 1:39 PM, "Thomas Gleixner" <tglx@linutronix.de> wrote:
>> > On Sat, 1 Nov 2014, Andy Lutomirski wrote:
>> > > There's plenty of room to tighten up the restrictions further, but
>> > > this is, I think, a decent first step, and it solves the problem of
>> > > information leaking into seccomp sandboxes.
>> >
>> > In which way?
>>
>> All the performance counters were readable without using any syscalls.
>> That leaks hints as to which events are in use, and it possibly leaks
>> interesting side channel information.   With this series applied, you
>> need a at least mmap an rdpmc-able event, which most seccomp sandboxes
>> won't allow.
>
> Ok. So you are preventing the seccomp sandboxes to open/mmap a counter.
>

Yes.

Conversely, if someone lets perf_event_open through a seccomp filter,
then the sandboxed code can probably gather more interesting
information using perf_event_open the normal way than they can by
poking at rdpmc.

--Andy

>> Unfortunately, rdpmc access to counters can't be controlled
>> individually, so it's hard to do all that much better than this.
>
> Yeah, I know ...
>
> Thanks,
>
>         tglx



-- 
Andy Lutomirski
AMA Capital Management, LLC
