Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaIJNte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:49:34 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:57621 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaIJNtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:49:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140908152206.GH6758@twins.programming.kicks-ass.net>
References: <CABPqkBRREcix0TtLLUgiq8uabUqG=m2un79WKLqPXF=LccSQbw@mail.gmail.com>
	<20140908124945.GD17728@krava.brq.redhat.com>
	<CABPqkBRPWh+=CfXBYaYW=P6FJke3KB-7y-U1ky8JAKjDY3JaEg@mail.gmail.com>
	<20140908143107.GG17728@krava.brq.redhat.com>
	<20140908152206.GH6758@twins.programming.kicks-ass.net>
Date: Wed, 10 Sep 2014 15:49:32 +0200
Message-ID: <CABPqkBTp2Sh788hmgC-w74MzTJZ-ySzEM-Su2M4oMO4OgDMsJA@mail.gmail.com>
Subject: Re: [PATCH] perf: Do not check PERF_EVENT_STATE_EXIT on syscall read path
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,



On Mon, Sep 8, 2014 at 5:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Sep 08, 2014 at 04:31:07PM +0200, Jiri Olsa wrote:
>> Revert PERF_EVENT_STATE_EXIT check on read syscall path.
>> It breaks standard way to read counter, which is to open
>> the counter, wait for the monitored process to die and
>> read the counter.
>>
>> Reported-by: Stephane Eranian <eranian@google.com>
>> Acked-by: Stephane Eranian <eranian@google.com>
>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Stephane Eranian <eranian@google.com>
>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>
> Thanks!
Still don't see this fix in tip.git.

>> ---
>>  kernel/events/core.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index d8cb4d21a346..6d1c9ce1643e 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -3600,8 +3600,7 @@ perf_read_hw(struct perf_event *event, char __user *buf, size_t count)
>>        * error state (i.e. because it was pinned but it couldn't be
>>        * scheduled on to the CPU at some point).
>>        */
>> -     if ((event->state == PERF_EVENT_STATE_ERROR) ||
>> -         (event->state == PERF_EVENT_STATE_EXIT))
>> +     if (event->state == PERF_EVENT_STATE_ERROR)
>>               return 0;
>>
>>       if (count < event->read_size)
>> --
>> 1.8.3.1
>>
