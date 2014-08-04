Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaHDSgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:36:41 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:45039 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaHDSgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:36:39 -0400
Message-ID: <53DFD2B3.3090101@hp.com>
Date: Mon, 04 Aug 2014 14:36:35 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH 1/7] locking/rwsem: don't resched at the end of optimistic
 spinning
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com> <1407119782-41119-2-git-send-email-Waiman.Long@hp.com> <20140804075528.GI9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140804075528.GI9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 03:55 AM, Peter Zijlstra wrote:
> On Sun, Aug 03, 2014 at 10:36:16PM -0400, Waiman Long wrote:
>> For a fully preemptive kernel, a call to preempt_enable() could
>> potentially trigger a task rescheduling event. In the case of rwsem
>> optimistic spinning, the task has either gotten the lock or is going
>> to sleep soon. So there is no point to do rescheduling here.
> Uh what? Why shouldn't we preempt if we've gotten the lock? What if a
> FIFO task just woke up?

I didn't mean that we shouldn't preempt if there is a higher priority 
task. I am sure that there will be other preemption points along the way 
that a higher priority task can take over the CPU. I just want to say 
that doing it here may not be the best place especially if the task is 
going to sleep soon.

If you think this patch does not make sense, I can remove it as other 
patches in the set has no dependency on this one.

-Longman
