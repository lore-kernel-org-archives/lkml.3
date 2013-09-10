Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3IJQOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:14:19 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50419 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3IJQOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:14:17 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20130910152845.GI31370@twins.programming.kicks-ass.net>
References: <20130903132933.GA24955@gmail.com>
	<CA+55aFxBTjfx304zstOVq3Hm3vmjgC5gOJaxXG5E_iWq_WXGTw@mail.gmail.com>
	<20130909100544.GI31370@twins.programming.kicks-ass.net>
	<CAMsRxfLEO15kKrbmtKKXuW-JTtCCgiuXS6wFs9kiLmG1wge24A@mail.gmail.com>
	<20130910115306.GA6091@gmail.com>
	<CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
	<20130910133845.GB7537@gmail.com>
	<CAMsRxfJ5HG+0AiooOUFh8TzvCoK3YcBFpeAF0eTzdkDm=wB84g@mail.gmail.com>
	<20130910152845.GI31370@twins.programming.kicks-ass.net>
Date: Tue, 10 Sep 2013 18:14:17 +0200
Message-ID: <CAMsRxfK-5HsZH-5QpxiZ+=dBF_k_akpckO0p_SfJ_kkdGHersg@mail.gmail.com>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was: Re:
 [GIT PULL] perf changes for v3.12)
From: Stephane Eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 5:28 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Sep 10, 2013 at 07:15:19AM -0700, Stephane Eranian wrote:
>> The threshold is where to generate the interrupt. It does not mean
>> where to stop PEBS recording.
>
> It does, since we don't set a reset value. So once a PEBS assist
> happens, that counter stops until we reprogram it in the PMI.
>
I agree with you.

I am curious to see what's in those entries. If they are all zeroes, then
we know only the pointer is bogus. Let me add some instrumentation
to check that.

>> So it is possible that in HSW, we may
>> get into a situation where it takes time to get to the handler to stop
>> the PMU. I don't know how given we use NMI. Well, unless we were
>> already servicing an NMI at the time. But given that we stop the PMU
>> almost immediately in the handler, I don't see how that would
>> possible.  The other oddity in HSW is that we clear the NMI on entry
>> to the handler and not at the end. I never gotten an good explanation
>> as to why that was necessary. So maybe it is related...
>
> Even if the PMI was delayed that counter would never do another entry.
> So I really don't see how we can have more than nr_counters PEBS entries
> in the buffer.

I agree.
