Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaDAIF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:05:58 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35177 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaDAIFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:05:52 -0400
Message-ID: <533A7357.6080708@hitachi.com>
Date: Tue, 01 Apr 2014 17:05:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 14/28] ktap: add runtime/kp_events.[c|h]
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com> <1396014469-5937-15-git-send-email-jovi.zhangwei@gmail.com> <533930EF.8080703@hitachi.com> <CAGdX0WHarh12K_2D8M=UAtwEJaZr_eZupXzsw-SXqd2X4NGTmg@mail.gmail.com> <533A63C8.70800@hitachi.com> <CAGdX0WFSqzWwbpS4zc6L-_nP7xYRjV4Q8e-sah-iX14KcNgDNw@mail.gmail.com>
In-Reply-To: <CAGdX0WFSqzWwbpS4zc6L-_nP7xYRjV4Q8e-sah-iX14KcNgDNw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/01 16:28), Jovi Zhangwei wrote:

>>>>> Note:
>>>>> Why ktap support 'kdebug.kprobe' and 'kdebug.tracepoint' when
>>>>> it already support perf backend event(trace xxx {})?
>>>>>
>>>>> Because benchmark shows raw kprobe and tracpoint interface is faster
>>>>> than perf backed tracing, nearly 10+%, it's more fair to compare
>>>>> with Systemtap by raw tracing syntax, not perf backend tracing.
>>>>>
>>>>
>>>> Do we really need it just for a +10% performance? I doubt that.
>>>> I think the benefit point of ktap is "dynamic & simple programmable
>>>> tracer in kernel", not the good performance at least at this point.
>>>> Thus I think we should start ktap only with perf backend.
>>>>
>>> Yeah, agreed, most people like the perf-backed tracing syntax,
>>> that raw trace interface is just for benchmark when I wanted to look
>>> overhead compare with stap, the result is very inspiring, ktap table
>>> operation overhead is lower than stap.
>>>
>>> On the performance overhead of dynamic tracing tools(ktap/stap/dtrace),
>>> it's interesting enough that dtrace was used in production many year,
>>> _but_ IMO the runtime of dtrace is slow after I checked dtrace source
>>> code :),  system workload does big matter than tracing tool overhead.
>>
>> Yeah, I see that less overhead is also required especially for enterprise
>> people. I just doubt that it is solved by ktap itself. Should we improve
>> perf(or ftrace) to export more effective interfaces for this kind of
>> tracers?
>>
> Yes, I also think it would be better to improve perf/ftrace unified callback
> overhead, not to let each tracer(stap/ktap/lttng) develop its own raw
> trace callback for performance reason.
> 
> Those raw trace interfaces(only designed for benchmark) will be remove
> in next version, if we think it's worth to continue.

Of course, I think ktap scripting flexibility should be merged to upstream :)
I just surprised that the size of this series. If you reform this series
for incremental build (this means that we can do git-bisect on this series),
I think that will be much easier to test and review.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


