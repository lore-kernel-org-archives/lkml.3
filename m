Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbaDAH2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:28:03 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:60686 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaDAH2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:28:00 -0400
MIME-Version: 1.0
In-Reply-To: <533A63C8.70800@hitachi.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396014469-5937-15-git-send-email-jovi.zhangwei@gmail.com>
	<533930EF.8080703@hitachi.com>
	<CAGdX0WHarh12K_2D8M=UAtwEJaZr_eZupXzsw-SXqd2X4NGTmg@mail.gmail.com>
	<533A63C8.70800@hitachi.com>
Date: Tue, 1 Apr 2014 15:28:00 +0800
Message-ID: <CAGdX0WFSqzWwbpS4zc6L-_nP7xYRjV4Q8e-sah-iX14KcNgDNw@mail.gmail.com>
Subject: Re: Re: [PATCH 14/28] ktap: add runtime/kp_events.[c|h]
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 2:59 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2014/03/31 19:14), Jovi Zhangwei wrote:
>> On Mon, Mar 31, 2014 at 5:10 PM, Masami Hiramatsu
>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>> (2014/03/28 22:47), Jovi Zhangwei wrote:
>>>> kp_events.c handle ktap events management(registry, destroy, event callback)
>>>>
>>>> This file is core event management interface between ktap and kernel.
>>>>
>>>> Exposed functions:
>>>> 1). kp_events_init/kp_events_exit
>>>>
>>>> 2). kp_event_create_kprobe
>>>>         create kprobe event, for example:
>>>>                 kdebug.kprobe("SyS_futex", function () {})
>>>>
>>>> 3). kp_event_create_tracepoint
>>>>         create tracepoint event, for example"
>>>>                 kdebug.tracepoint("sys_futex_enter", function () {})
>>>>
>>>> 4). kp_event_create
>>>>         create perf backend event, for example:
>>>>                 trace sched:sched_switch { print(argstr) }
>>>>
>>>>         It call kernel function 'perf_event_create_kernel_counter' to
>>>>         register event(tracepoint/kprobe/uprobe)
>>>>
>>>> 5). kp_event_getarg
>>>>         get argument of event, from arg0 to arg9,
>>>>         only can be called in probe context.
>>>>                 trace sched:sched_switch { print(arg0, arg1) }
>>>>
>>>> 6). kp_event_stringify/kp_event_tostr
>>>>         stringify argstr, sometimes if store argstr as key to table,
>>>>         then it need to stringify firstly, like below:
>>>>                 var s={} trace sched:sched_switch { s[argstr] += 1 }
>>>>         (This is quite rare usage, but ktap support it)
>>>>
>>>> Note:
>>>> Why ktap support 'kdebug.kprobe' and 'kdebug.tracepoint' when
>>>> it already support perf backend event(trace xxx {})?
>>>>
>>>> Because benchmark shows raw kprobe and tracpoint interface is faster
>>>> than perf backed tracing, nearly 10+%, it's more fair to compare
>>>> with Systemtap by raw tracing syntax, not perf backend tracing.
>>>>
>>>
>>> Do we really need it just for a +10% performance? I doubt that.
>>> I think the benefit point of ktap is "dynamic & simple programmable
>>> tracer in kernel", not the good performance at least at this point.
>>> Thus I think we should start ktap only with perf backend.
>>>
>> Yeah, agreed, most people like the perf-backed tracing syntax,
>> that raw trace interface is just for benchmark when I wanted to look
>> overhead compare with stap, the result is very inspiring, ktap table
>> operation overhead is lower than stap.
>>
>> On the performance overhead of dynamic tracing tools(ktap/stap/dtrace),
>> it's interesting enough that dtrace was used in production many year,
>> _but_ IMO the runtime of dtrace is slow after I checked dtrace source
>> code :),  system workload does big matter than tracing tool overhead.
>
> Yeah, I see that less overhead is also required especially for enterprise
> people. I just doubt that it is solved by ktap itself. Should we improve
> perf(or ftrace) to export more effective interfaces for this kind of
> tracers?
>
Yes, I also think it would be better to improve perf/ftrace unified callback
overhead, not to let each tracer(stap/ktap/lttng) develop its own raw
trace callback for performance reason.

Those raw trace interfaces(only designed for benchmark) will be remove
in next version, if we think it's worth to continue.

Thanks.

Jovi
