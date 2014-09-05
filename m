Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaIEDU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 23:20:26 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46800 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbaIEDUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 23:20:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140904211631.46b8cad8@as>
References: <1409756351-25743-1-git-send-email-eranian@google.com>
	<1409756351-25743-3-git-send-email-eranian@google.com>
	<20140904211631.46b8cad8@as>
Date: Fri, 5 Sep 2014 05:20:23 +0200
Message-ID: <CABPqkBRUkLw3J1MJrehpU1CQz4gtZc1Quo0tbxauoUTc0307wg@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] perf/x86: add support for sampling PEBS machine
 state registers
From: Stephane Eranian <eranian@google.com>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 4:16 AM, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
> On Wed,  3 Sep 2014 16:59:07 +0200
> Stephane Eranian <eranian@google.com> wrote:
>
>> PEBS can capture machine state regs at retiremnt of the sampled
>> instructions. When precise sampling is enabled on an event, PEBS
>> is used, so substitute the interrupted state with the PEBS state.
>> Note that not all registers are captured by PEBS. Those missing
>> are replaced by the interrupt state counter-parts.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel_ds.c |   17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> b/arch/x86/kernel/cpu/perf_event_intel_ds.c index 9dc4199..139a8a5
>> 100644 --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> @@ -886,6 +886,23 @@ static void __intel_pmu_pebs_event(struct
>> perf_event *event, regs.bp = pebs->bp;
>>       regs.sp = pebs->sp;
>>
>> +     if (sample_type & PERF_SAMPLE_REGS_INTR) {
>> +             regs.ax = pebs->ax;
>> +             regs.bx = pebs->bx;
>> +             regs.cx = pebs->cx;
>> +             regs.si = pebs->si;
>> +             regs.di = pebs->di;
>> +
>> +             regs.r8 = pebs->r8;
>> +             regs.r9 = pebs->r9;
>> +             regs.r10 = pebs->r10;
>> +             regs.r11 = pebs->r11;
>> +             regs.r12 = pebs->r12;
>> +             regs.r13 = pebs->r13;
>> +             regs.r14 = pebs->r14;
>> +             regs.r14 = pebs->r15;
>                      ^^^
>                      r15 ???
>
Oops, good catch. I will fix in v5.
Thanks.

>> +     }
>> +
>>       if (event->attr.precise_ip > 1 &&
>> x86_pmu.intel_cap.pebs_format >= 2) { regs.ip = pebs->real_ip;
>>               regs.flags |= PERF_EFLAGS_EXACT;
>
