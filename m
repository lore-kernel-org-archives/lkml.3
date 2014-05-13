Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840AbaEMLKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:10:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:64235 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760593AbaEMLKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:10:19 -0400
X-IronPort-AV: E=Sophos;i="4.97,1043,1389715200"; 
   d="scan'208";a="30455860"
Message-ID: <5371EF7A.7060908@cn.fujitsu.com>
Date: Tue, 13 May 2014 19:10:02 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf,tools: Remove usage of trace_sched_wakeup(.success)
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net> <20140513072208.GB7980@gmail.com> <5371BCF8.7030708@cn.fujitsu.com> <20140513100333.GW30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140513100333.GW30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 07:03 PM, Peter Zijlstra wrote:
> On Tue, May 13, 2014 at 03:34:32PM +0900, Dongsheng Yang wrote:
>> On 05/13/2014 04:22 PM, Ingo Molnar wrote:
>>> * Peter Zijlstra <peterz@infradead.org> wrote:
>>>
>>>> trace_sched_wakeup(.success) is a dead argument and has been for ages,
>>> Always 0, or random value?
>> Hi Ingo,
>>
>> It is always 1 currently.
>>
>> Peter believe that .success is not useful and I pointed that perf sched
>> latency
>> is using it now. Then he post this patch to remove the usage here.
>>
>> Please go to the following link for more about this issue.
> It is _not_ usable. You're proposing to abuse the existing parameter. A
> wakeup doing an enqueue or not has nothing _WHAT_SO_EVER_ to do with
> success.
>
> Now what I think you wanted to do is make it easier to match
> trace_sched_switch() statements with trace_sched_wakeup() statements.
> And since you only get the trace_sched_switch() on dequeue, you want to
> know which trace_sched_wakeup() calls did an enqueue.

Ha, yes, indeed. In perf sched latency, we need to know the timestamp
when a task enqueue and then we can calculate the delay time.
So I want to take the use of success parameter in trace_sched_wakeup()
to indicate that *this* wakeup did an enqueue.

But now I think it is okey if you really mind adding more tracepoints in
scheduler. And I posted a patch after your patch in this thread to make
perf sched latency work well.
>
> But that's completely and utterly unrelated to success.

