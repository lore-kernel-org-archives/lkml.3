Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbbAETRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:17:42 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:33103 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbbAETRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:17:40 -0500
MIME-Version: 1.0
In-Reply-To: <20150105134514.GS30905@twins.programming.kicks-ass.net>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	<1415292718-19785-4-git-send-email-pawel.moll@arm.com>
	<20150105134514.GS30905@twins.programming.kicks-ass.net>
Date: Mon, 5 Jan 2015 11:17:39 -0800
Message-ID: <CALAqxLV+-XXqvOnKsuyBGD3ak7X8KJ05trW_kRT3WQi5sYzKJQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
From: John Stultz <john.stultz@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Pawel Moll <pawel.moll@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 5:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Nov 06, 2014 at 04:51:58PM +0000, Pawel Moll wrote:
>> Currently three clocks are implemented: CLOCK_REALITME = 0,
>> CLOCK_MONOTONIC = 1 and CLOCK_MONOTONIC_RAW = 2. The clock field is
>> 5 bits wide to allow for future extension to custom, non-POSIX clock
>> sources(MAX_CLOCK for those is 16, see include/uapi/linux/time.h) like
>> ARM CoreSight (hardware trace) timestamp generator.
>
>> @@ -304,7 +305,16 @@ struct perf_event_attr {
>>                               mmap2          :  1, /* include mmap with inode data     */
>>                               comm_exec      :  1, /* flag comm events that are due to an exec */
>>                               uevents        :  1, /* allow uevents into the buffer */
>> -                             __reserved_1   : 38;
>> +
>> +                             /*
>> +                              * clock: one of the POSIX clock IDs:
>> +                              *
>> +                              * 0 - CLOCK_REALTIME
>> +                              * 1 - CLOCK_MONOTONIC
>> +                              * 4 - CLOCK_MONOTONIC_RAW
>> +                              */
>> +                             clock          :  5, /* clock type */
>> +                             __reserved_1   : 33;
>>
>>       union {
>>               __u32           wakeup_events;    /* wakeup every n events */
>
> This would put a constraint on actually changing MAX_CLOCKS, are the
> time people OK with that? Thomas, John?

Yea, I'd not want to enshrine MAX_CLOCKS if we can avoid it. We're
getting a bit close to it these days.

thanks
-john
