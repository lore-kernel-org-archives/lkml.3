Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaE0QDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:03:24 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:37832 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaE0QDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:03:22 -0400
Message-ID: <5384B735.6050501@hp.com>
Date: Tue, 27 May 2014 12:03:01 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, hpa@zytor.com, jason.low2@hp.com,
        aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mutex: Documentation rewrite
References: <1400694115.2646.4.camel@buesod1.americas.hpqcorp.net> <1400858184.2527.2.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1400858184.2527.2.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 11:16 AM, Davidlohr Bueso wrote:
> From: Davidlohr Bueso<davidlohr@hp.com>
>
>
> +
> +(ii) midpath: aka optimistic spinning, tries to spin for acquisition
> +     when there are no pending waiters and the lock owner is currently

That is not true. The spinning code doesn't check if there is any 
pending waiters. So some tasks can be spinning while the others are 
sleeping. The only checks are: 1) The lock owner is running; 2) there is 
no other higher-priority ready-to-run task (need_resched).

> +     running on a different CPU. The rationale is that if the lock owner
> +     is running, it is likely to release the lock soon. The mutex spinners
> +     are queued up using MCS lock so that only one spinner can compete for
> +     the mutex.
> +
> +     The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spinlock
> +     with the desirable properties of being fair and with each cpu trying
> +     to acquire the lock spinning on a local variable. It avoids expensive
> +     cacheline bouncing that common test-and-set spinlock implementations
> +     incur. An MCS-like lock is specially tailored for optimistic spinning
> +     for sleeping lock implementation. An important feature of the customized
> +     MCS lock is that it has the extra property that spinners are able to exit
> +     the MCS spinlock queue when they need to reschedule. This further helps
> +     avoid situations where MCS spinners that need to reschedule would continue
> +     waiting to spin on mutex owner, only to go directly to slowpath upon
> +     obtaining the MCS lock.
> +
> +
> +(iii) slowpath: last resort, if the lock is still unable to be acquired,
> +      the task is added to the wait-queue and sleeps until it can be taken.

It would be more clear to say "until woken up by the unlock path".

Other than that, the others look fine to me.

-Longman




