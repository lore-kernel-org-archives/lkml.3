Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab3FSUDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:03:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757514Ab3FSUDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:03:15 -0400
Date: Wed, 19 Jun 2013 21:58:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing/perf: perf_trace_buf/perf_xxx hacks.
Message-ID: <20130619195822.GA16489@redhat.com>
References: <20130618192147.GA19443@redhat.com> <20130619121039.GA19225@twins.programming.kicks-ass.net> <20130619152844.GA9176@redhat.com> <20130619175139.GA20454@redhat.com> <51C1FD7F.9090606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C1FD7F.9090606@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19, David Ahern wrote:
>
> On 6/19/13 11:51 AM, Oleg Nesterov wrote:
>>
>> not sure these numbers actually mean
>> something, but still.

Yes.

>> So, the test-case:
>>
>> 	int pipe1[2], pipe2[2];
>
> Same as "perf bench sched pipe"

You just cruelly disclosed the fact that I do not use perf.

Thanks. So,

	# perf record -e sched:sched_switch -p1 &
	[1] 516
	# perf bench sched pipe

3 times.

before:

     Total time: 30.119 [sec]

      30.119501 usecs/op
          33201 ops/sec

     Total time: 30.634 [sec]

      30.634105 usecs/op
          32643 ops/sec

     Total time: 30.100 [sec]

      30.100209 usecs/op
          33222 ops/sec


after:

     Total time: 29.645 [sec]

      29.645941 usecs/op
          33731 ops/sec

     Total time: 29.759 [sec]

      29.759075 usecs/op
          33603 ops/sec

     Total time: 29.803 [sec]

      29.803522 usecs/op
          33553 ops/sec

Hmm. Actually sched-pipe.c is a bit more "heavy", it does switch_mm().
And I used taskset. But it seems that this test-case shows the similar
results.

Oleg.

