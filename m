Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaCJHSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 03:18:18 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:57301 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaCJHSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 03:18:16 -0400
Message-ID: <531D66FE.20703@lab.ntt.co.jp>
Date: Mon, 10 Mar 2014 16:17:18 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando_b1@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/clock: prevent tracing recursion in sched_clock_cpu()
References: <1394083528.4524.3.camel@nexus> <20140306055113.2306397d@gandalf.local.home>
In-Reply-To: <20140306055113.2306397d@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 07:51 PM, Steven Rostedt wrote:
> On Thu, 06 Mar 2014 14:25:28 +0900
> Fernando Luis Vázquez Cao <fernando_b1@lab.ntt.co.jp> wrote:
>
>> From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
>>
>> Prevent tracing of preempt_disable/enable() in sched_clock_cpu().
>> When CONFIG_DEBUG_PREEMPT is enabled, preempt_disable/enable() are
>> traced and this causes trace_clock() users (and probably others) to
>> go into an infinite recursion. Systems with a stable sched_clock()
>> are not affected.
>>
>> This problem is similar to that fixed by upstream commit 95ef1e52922
>> ("KVM guest: prevent tracing recursion with kvmclock").
> Also similar to: 569d6557ab957.
>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thank you four your review, Peter, Steven.

By the way, who is going to pick this patch? Do you want
me to resend with Steven's Acked-by added?

- Fernando
