Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965710Ab3FTSxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:53:08 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40463 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965649Ab3FTSxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:53:05 -0400
Message-ID: <51C34F8D.2000806@gmail.com>
Date: Thu, 20 Jun 2013 12:53:01 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing/perf: perf_trace_buf/perf_xxx hacks.
References: <20130618192147.GA19443@redhat.com>   <20130619121039.GA19225@twins.programming.kicks-ass.net>   <20130619152844.GA9176@redhat.com> <20130619175139.GA20454@redhat.com>   <51C1FD7F.9090606@gmail.com> <20130619195822.GA16489@redhat.com>  <1371752633.18733.96.camel@gandalf.local.home> <51C34B70.60808@gmail.com> <1371754078.18733.106.camel@gandalf.local.home>
In-Reply-To: <1371754078.18733.106.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/13 12:47 PM, Steven Rostedt wrote:
> On Thu, 2013-06-20 at 12:35 -0600, David Ahern wrote:
>> On 6/20/13 12:23 PM, Steven Rostedt wrote:
>>>
>>> I ran this:
>>>
>>>    perf stat --repeat 100 -- perf bench sched pipe > /tmp/perf-bench-sched.{before, after}
>>
>> You want to compare:
>>     perf stat --repeat 100 -p 1 -- perf bench sched pipe
>>
>> so that event is tagged to pid 1 and not the perf-bench workload.
>
> I guess I'm a bit confused. What's the significance of measuring pid 1
> (init)?

I believe Oleg's point is the overhead for tasks without events 
associated with them. To show that create an event tagged to the init 
task and then run some workload -- like perf bench shed pipe. It shows 
that all tasks take a hit, not just the one getting profiled.

David
