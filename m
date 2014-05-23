Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaEWEE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:04:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39944 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaEWEE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:04:26 -0400
Message-ID: <537EC8A5.8070508@oracle.com>
Date: Fri, 23 May 2014 00:03:49 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: spinlock recursion in migrate_swap_stop
References: <5371122D.6020605@oracle.com> <537AB86B.4020901@oracle.com> <20140520110431.GX2485@laptop.programming.kicks-ass.net> <537B52BD.1080807@oracle.com> <537CA54A.8030408@oracle.com> <20140521131948.GF2485@laptop.programming.kicks-ass.net> <20140521164959.GI5226@laptop.programming.kicks-ass.net> <537D6244.6040106@oracle.com> <20140522065915.GJ30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140522065915.GJ30445@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 02:59 AM, Peter Zijlstra wrote:
> On Wed, May 21, 2014 at 10:34:44PM -0400, Sasha Levin wrote:
>> On 05/21/2014 12:49 PM, Peter Zijlstra wrote:
>>> On Wed, May 21, 2014 at 03:19:48PM +0200, Peter Zijlstra wrote:
>>>>> On Wed, May 21, 2014 at 09:08:26AM -0400, Sasha Levin wrote:
>>>>>>> +++ b/kernel/sched/core.c
>>>>>>> @@ -1154,6 +1156,7 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p)
>>>>>>>                 goto out;
>>>>>>>
>>>>>>>         trace_sched_swap_numa(cur, arg.src_cpu, p, arg.dst_cpu);
>>>>>>> +       BUG_ON(cur == p);
>>>>>>>         ret = stop_two_cpus(arg.dst_cpu, arg.src_cpu, migrate_swap_stop, &arg);
>>>>>>>
>>>>>>>  out:
>>>>>>>
>>>>>>>
>>>>>>> Which seems to get hit. This sounds like a race with task moving to
>>>>>>> other cpu maybe?
>>>>>
>>>>> Oi, good call that, lemme go stare.
>>> I think something simple like this should be sufficient to avoid the
>>> problem of selecting oneself as a flip target.
>>
>> Why would that happen in the first place?
> 
> We do all that with preemption enabled, because its big and expensive,
> so its entirely possible that current (env->p) got moved around while we
> were doing it, at which point we'll look at it as a possible dst, while
> its already our src.

Seems to be working fine now, thanks!


Thanks,
Sasha

