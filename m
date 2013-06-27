Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab3F0BYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 21:24:48 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:39658 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3F0BYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 21:24:47 -0400
Message-ID: <51CB9450.80601@hp.com>
Date: Wed, 26 Jun 2013 21:24:32 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <20130626201713.GH6123@two.firstfloor.org> <51CB57F6.6010003@hp.com> <20130626212221.GI6123@two.firstfloor.org> <51CB7898.5070206@hp.com> <20130627010658.GL6123@two.firstfloor.org> <51CB9233.7020508@hp.com>
In-Reply-To: <51CB9233.7020508@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 09:15 PM, Waiman Long wrote:
> On 06/26/2013 09:06 PM, Andi Kleen wrote:
>>> In the uncontended case, doing spin_unlock_wait will be similar to
>>> spin_can_lock. This, when combined with a cmpxchg, is still faster
>>> than doing 2 atomic operations in spin_lock/spin_unlock.
>> I'm totally against any new users of spin_unlock_wait()
>>
>> It has bizarre semantics, most likely will make various
>> lock optimizations impossible, it's race condition hell
>> for most users etc.
>>
>> spin_can_lock() is not quite as bad has a lot of the similar problems.
>>
>>> BTW, spin_can_lock is just the negation of spin_is_locked.
>> e.g. with elision it's not.
>>
>> -Andi
>
> OK, it is about Haswell's lock elision feature. I will see what I can 
> do to remove those problematic function calls.

It will be hard to know what changes will be needed without knowing the 
exact semantics of the spinlock functions with lock elision. Can you 
explain a little more what bizarre semantics you are referring to?

regards,
Longman
