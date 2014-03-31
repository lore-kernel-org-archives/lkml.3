Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaCaKOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:14:33 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:54414 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbaCaKOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <533930EF.8080703@hitachi.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396014469-5937-15-git-send-email-jovi.zhangwei@gmail.com>
	<533930EF.8080703@hitachi.com>
Date: Mon, 31 Mar 2014 18:14:31 +0800
Message-ID: <CAGdX0WHarh12K_2D8M=UAtwEJaZr_eZupXzsw-SXqd2X4NGTmg@mail.gmail.com>
Subject: Re: [PATCH 14/28] ktap: add runtime/kp_events.[c|h]
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

On Mon, Mar 31, 2014 at 5:10 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2014/03/28 22:47), Jovi Zhangwei wrote:
>> kp_events.c handle ktap events management(registry, destroy, event callback)
>>
>> This file is core event management interface between ktap and kernel.
>>
>> Exposed functions:
>> 1). kp_events_init/kp_events_exit
>>
>> 2). kp_event_create_kprobe
>>         create kprobe event, for example:
>>                 kdebug.kprobe("SyS_futex", function () {})
>>
>> 3). kp_event_create_tracepoint
>>         create tracepoint event, for example"
>>                 kdebug.tracepoint("sys_futex_enter", function () {})
>>
>> 4). kp_event_create
>>         create perf backend event, for example:
>>                 trace sched:sched_switch { print(argstr) }
>>
>>         It call kernel function 'perf_event_create_kernel_counter' to
>>         register event(tracepoint/kprobe/uprobe)
>>
>> 5). kp_event_getarg
>>         get argument of event, from arg0 to arg9,
>>         only can be called in probe context.
>>                 trace sched:sched_switch { print(arg0, arg1) }
>>
>> 6). kp_event_stringify/kp_event_tostr
>>         stringify argstr, sometimes if store argstr as key to table,
>>         then it need to stringify firstly, like below:
>>                 var s={} trace sched:sched_switch { s[argstr] += 1 }
>>         (This is quite rare usage, but ktap support it)
>>
>> Note:
>> Why ktap support 'kdebug.kprobe' and 'kdebug.tracepoint' when
>> it already support perf backend event(trace xxx {})?
>>
>> Because benchmark shows raw kprobe and tracpoint interface is faster
>> than perf backed tracing, nearly 10+%, it's more fair to compare
>> with Systemtap by raw tracing syntax, not perf backend tracing.
>>
>
> Do we really need it just for a +10% performance? I doubt that.
> I think the benefit point of ktap is "dynamic & simple programmable
> tracer in kernel", not the good performance at least at this point.
> Thus I think we should start ktap only with perf backend.
>
Yeah, agreed, most people like the perf-backed tracing syntax,
that raw trace interface is just for benchmark when I wanted to look
overhead compare with stap, the result is very inspiring, ktap table
operation overhead is lower than stap.

On the performance overhead of dynamic tracing tools(ktap/stap/dtrace),
it's interesting enough that dtrace was used in production many year,
_but_ IMO the runtime of dtrace is slow after I checked dtrace source
code :),  system workload does big matter than tracing tool overhead.

Thanks.

Jovi
