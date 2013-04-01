Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab3DAV65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:58:57 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:46072 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab3DAV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:58:55 -0400
Message-ID: <515A0317.1070800@gmail.com>
Date: Mon, 01 Apr 2013 15:58:47 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] timekeeping: Add tracepoints for xtime changes - v2
References: <1363710477-4203-1-git-send-email-dsahern@gmail.com> <CANcMJZCJK_8r6y0MbhhgyTkk=7dMOFZO-KkeVy4MLE5PZxEZqg@mail.gmail.com>
In-Reply-To: <CANcMJZCJK_8r6y0MbhhgyTkk=7dMOFZO-KkeVy4MLE5PZxEZqg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/13 12:55 PM, John Stultz wrote:
>
> Sorry I missed this, I no longer receive emails at that address.

Noted. I'll update the address on future versions (and dropped the IBM 
one from this thread).

>     diff --git a/include/trace/events/timekeeping.h
>     b/include/trace/events/timekeeping.h
>     new file mode 100644
>     index 0000000..ff7a631
>     --- /dev/null
>     +++ b/include/trace/events/timekeeping.h
>     @@ -0,0 +1,51 @@
>     +#undef TRACE_SYSTEM
>     +#define TRACE_SYSTEM timekeeping
>     +
>     +#if !defined(_TRACE_TIMEKEEP_H) || defined(TRACE_HEADER_MULTI_READ)
>     +#define _TRACE_TIMEKEEP_H
>     +
>     +#include <linux/tracepoint.h>
>     +#include <linux/time.h>
>     +
>     +DECLARE_EVENT_CLASS(xtime_template,

> So xtime is becoming more of a historical reference in the code. Should
> this maybe be timespec_template? Or timeupdate_template?

What I want is to track updates (user, ntpd, other) to the timespec 
returned for gettimeofday (or, per the comment in that function, 
getnstimeofday). The event will have the new value for that timekeeper 
and the perf_clock timestamp as well so I can update the correlation.

I'm fine with calling it timespec_template. No religion on the names, 
only the feature.

--8<--

> This all looks reasonable. Though do we need to be more explicit in what
> we're tracing here? ie: CLOCK_REALTIME timestamps?

The tracepoints don't care about the what and the tp names follow the 
convention of trace_<function_name> so you know where it is triggering.

>
> I'd someday eventually like to rework the timekeeping core to be mostly
> ktime_t based, building time in a more logical method up from
> CLOCK_MONOTONIC rather then using CLOCK_REALTIME as our base and
> subtracting time from that. I'm just worried about what sort of
> constraints these tracepoints may put on a larger rework in the future.

Understood. And my comment above is not going to help -- ie., telling 
perf specific tracepoints which include function names. Should I 
consolidate this into a single trace_tod_update() that gets invoked in 
various places? The locations can move without affecting perf. I just 
want the tod update; where it happens should not matter.

David

David
