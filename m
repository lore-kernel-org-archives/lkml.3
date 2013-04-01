Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab3DAWQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:16:16 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:46463 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3DAWQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:16:15 -0400
Message-ID: <515A072A.3080307@linaro.org>
Date: Mon, 01 Apr 2013 15:16:10 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] timekeeping: Add tracepoints for xtime changes - v2
References: <1363710477-4203-1-git-send-email-dsahern@gmail.com> <CANcMJZCJK_8r6y0MbhhgyTkk=7dMOFZO-KkeVy4MLE5PZxEZqg@mail.gmail.com> <515A0317.1070800@gmail.com>
In-Reply-To: <515A0317.1070800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 02:58 PM, David Ahern wrote:
> On 4/1/13 12:55 PM, John Stultz wrote:
>
>> This all looks reasonable. Though do we need to be more explicit in what
>> we're tracing here? ie: CLOCK_REALTIME timestamps?
>
> The tracepoints don't care about the what and the tp names follow the 
> convention of trace_<function_name> so you know where it is triggering.
>
>>
>> I'd someday eventually like to rework the timekeeping core to be mostly
>> ktime_t based, building time in a more logical method up from
>> CLOCK_MONOTONIC rather then using CLOCK_REALTIME as our base and
>> subtracting time from that. I'm just worried about what sort of
>> constraints these tracepoints may put on a larger rework in the future.
>
> Understood. And my comment above is not going to help -- ie., telling 
> perf specific tracepoints which include function names. Should I 
> consolidate this into a single trace_tod_update() that gets invoked in 
> various places? The locations can move without affecting perf. I just 
> want the tod update; where it happens should not matter.
>

I guess what I'm getting at is: What ABI are we creating here?  Can 
these tracepoints come and go without any consequence? Or would changing 
them in the future cause application breakage?

I'm somewhat worried even trace_tod_update() is maybe too vague (again 
not that the name specifically is critical, but that the semantics we're 
specifying are clear). In other words, I think you're wanting a 
tracepoint at any time CLOCK_REALTIME is updated by anything other then 
the normal progression of time? Is that right?

You may want to also include the leapsecond modification in the tracing 
as well.

thanks
-john
