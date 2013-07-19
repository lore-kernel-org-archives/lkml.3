Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3GSU6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 16:58:14 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:5033 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3GSU6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 16:58:13 -0400
Message-ID: <51E9A861.4040803@hp.com>
Date: Fri, 19 Jul 2013 16:58:09 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mutex: Fix mutex_can_spin_on_owner
References: <20130719183101.GA20909@twins.programming.kicks-ass.net> <51E98EB4.3080307@hp.com> <alpine.DEB.2.02.1307192139140.4089@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307192139140.4089@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 03:41 PM, Thomas Gleixner wrote:
> On Fri, 19 Jul 2013, Waiman Long wrote:
>> On 07/19/2013 02:31 PM, Peter Zijlstra wrote:
>>>    	rcu_read_lock();
>>> -	if (lock->owner)
>>> -		retval = lock->owner->on_cpu;
>>> +	owner = ACCESS_ONCE(lock->owner);
>>> +	if (owner)
>>> +		retval = owner->on_cpu;
>>>    	rcu_read_unlock();
>>>    	/*
>>>    	 * if lock->owner is not set, the mutex owner may have just
>>> acquired
>> I am fine with this change. However, the compiler is smart enough to
>> not do two memory accesses to the same memory location. So this will
>> not change the generated code. Below is the relevant x86 code for
>> that section of code:
> That's true for your particular compiler, but it's not guaranteed at
> all. So it matters even when your compiler generates the same
> code. Others might not. There is a world outside of x8664.
>
> Thanks,
>
> 	tglx

I supposed that only the gcc compiler can be used to build Linux kernel 
as the kernel source uses a lot of features specific to gcc. 
Optimizations like these are done by the front end of the compiler which 
should be universal across all the architecture. So what I want to say 
is that there is nothing specific to x86-64 or any architecture here. 
This is what a good compiler should do.

I am not against the fix as it makes the intention more clear. I am just 
saying that there won't be any performance change because of this.

Regards,
Longman
