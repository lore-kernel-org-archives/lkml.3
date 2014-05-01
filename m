Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaEAUcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:32:08 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52152 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaEAUcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:32:06 -0400
MIME-Version: 1.0
In-Reply-To: <1398962356.2970.128.camel@schen9-DESK>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	<1398914496.22957.11.camel@buesod1.americas.hpqcorp.net>
	<1398962356.2970.128.camel@schen9-DESK>
Date: Thu, 1 May 2014 13:32:05 -0700
X-Google-Sender-Auth: tcZVA7v2f5VleEXkMgYjc-ilfeI
Message-ID: <CAGQ1y=4QvnR-uY+euqECYTJOwOXpxm2i1HBwUuwYEvYyVyArxQ@mail.gmail.com>
Subject: Re: [PATCH v3] rwsem: Support optimistic spinning
From: Jason Low <jason.low2@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 9:39 AM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> On Wed, 2014-04-30 at 20:21 -0700, Davidlohr Bueso wrote:
>
>> +
>> +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
>> +{
>> +     struct task_struct *owner;
>> +     bool on_cpu = true;
>> +
>> +     if (need_resched())
>> +             return 0;
>> +
>> +     rcu_read_lock();
>> +     owner = ACCESS_ONCE(sem->owner);
>> +     if (owner)
>> +             on_cpu = owner->on_cpu;
>> +     rcu_read_unlock();
>> +
>> +     /*
>> +      * If lock->owner is not set, the mutex owner may have
>> +      * just acquired it and not set the owner yet or the mutex
>
> Nitpick. Change the above 2 mutex in comment to rwsem.

On that note, we may also change "lock->owner" to "sem->owner" for consistency.

Thanks,
Jason
