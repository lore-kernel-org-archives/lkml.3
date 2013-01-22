Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3AVOWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:22:48 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:65049 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3AVOWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:22:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130118225940.GH4051@tassilo.jf.intel.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
	<1358264386-24633-4-git-send-email-eranian@google.com>
	<20130118225940.GH4051@tassilo.jf.intel.com>
Date: Tue, 22 Jan 2013 15:22:43 +0100
Message-ID: <CABPqkBQ4c1x7KQ5j4uTP9Tnz41esc2iGnWgnYxidezmZp=Hhww@mail.gmail.com>
Subject: Re: [PATCH v6 03/18] perf/x86: add flags to event constraints
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 11:59 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> --- a/arch/x86/kernel/cpu/perf_event_intel.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
>> @@ -1367,8 +1367,10 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
>>
>>       if (x86_pmu.event_constraints) {
>>               for_each_event_constraint(c, x86_pmu.event_constraints) {
>> -                     if ((event->hw.config & c->cmask) == c->code)
>> +                     if ((event->hw.config & c->cmask) == c->code) {
>> +                             event->hw.flags |= c->flags;
>>                               return c;
>> +                     }
>
> It's not fully clear where that hw.flags field gets initially zeroed. Is that implicit
> in the allocation? Some comments would be good about its live cycle.
>
Yes, this is by allocation.
I used |= in case we need to add more flags in the future.
I will add a comment.

> Or just use a = instead of |=? Why would you have multiple flags in different places?
>
> -Andi
