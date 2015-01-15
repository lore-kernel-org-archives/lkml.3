Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbbAOPMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:12:37 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55409 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbbAOPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:12:35 -0500
Message-ID: <54B7D8D4.2070203@gmail.com>
Date: Thu, 15 Jan 2015 16:12:20 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>
CC: mtk.manpages@gmail.com, "Carlos O'Donell" <carlos@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de> <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com> <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de> <CF9A731D.913E6%dvhart@linux.intel.com>
In-Reply-To: <CF9A731D.913E6%dvhart@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Darren,

I give you the same apology as to Thomas for the 
long-delayed response to your mail.

And I repeat my note to Thomas:
In the next day or two, I hope to send out the new version
of the futex(2) page for review. The new draft is a bit
bigger (okay -- 4 x bigger) than the current page. And there 
are a quite number of FIXMEs that I've placed in the page 
for various points--some minor, but a few major--that need
to be checked or fixed. Would you have some time to review
that page? 

In the meantime, I have a couple of questions, which, if 
you could answer them, I would work some changes into the 
page before sending.

1. In various places, distinction is made between non-PI 
   futexs and PI futexes. But what determines that distinction?
   From the kernel's perspective, hat make a futex one type
   or another? I presume it is to do with the types of blocking
   waiters on the futex, but it would be good to have a formal
   definition.

2. Can you say something about the pairing requirements of
   FUTEX_WAIT_REQUEUE_PI and FUTEX_CMP_REQUEUE_PI. 
   What is the requirement and why do we need it?

Most of the rest of this mail is just a checklist noting
what I did with your comments. No response is needed 
in most cases, but there is one that I have marked with
"???". If you could reply to that. I'd be grateful.

On 05/15/2014 10:35 PM, Darren Hart wrote:
> On 5/15/14, 7:14, "Thomas Gleixner" <tglx@linutronix.de> wrote:
> 
> Wow Thomas, I planned to do exactly this and you beat me to it. Again.
> Thanks for getting this started.
> 
> Michael, I imagine you want something more condensed, and I'll add to what
> tglx posted (inline below) to try and get you that, but if you have
> questions and need to fill in the gap, the paper I presented at RTLWS11 in
> '09 covers this particularly nasty OPCODE in detail:
> 
> http://lwn.net/images/conf/rtlws11/papers/proc/p10.pdf
> 
> I believe Michael is looking for some higher level documentation, like how
> to use these and what they are intended for. 

Yes, that would be good.

> Probably something more like
> Ulrich's Futexes are Tricky paper - but let's start with getting the op
> codes, arguments, and return codes fleshed out.

Okay.

> For all the PI opcodes, we should probably mention something about the
> futex value scheme (TID), whereas the other opcodes do not require any
> specific value scheme.
> 
> No Owner:	0
> Owner:		TID
> Waiters:	TID | FUTEX_WAITERS
> 
> This is the relevant section from the referenced paper:
> 				
> The PI futex operations diverge from the oth-
> ers in that they impose a policy describing how
> the futex value is to be used. If the lock is un-
> owned, the futex value shall be 0. If owned, it
> shall be the thread id (tid) of the owning thread.
> If there are threads contending for the lock, then
> the FUTEX_WAITERS flag is set. With this policy in
> place, userspace can atomically acquire an unowned
> lock or release an uncontended lock using an atomic
> instruction and their own tid. A non-zero futex
> value will force waiters into the kernel to lock. The
> FUTEX_WAITERS flag forces the owner into the kernel
> to unlock. If the callers are forced into the kernel,
> they then deal directly with an underlying rt_mutex
> which implements the priority inheritance semantics.
> After the rt_mutex is acquired, the futex value is up-
> dated accordingly, before the calling thread returns
> to userspace.
>
> It is important to note that the kernel will update the futex value prior
> to returning to userspace. Unlike other futex op codes,
> FUTEX_CMP_REUQUE_PI (and FUTEX_WAIT_REQUEUE_PI, FUTEX_LOCK_PI are designed
> for the implementation of very specific IPC mechanisms).

??? Great text. May I presume that I can take this text 
and freely adapt it for the man page? (Actually, this is a 
request for forgiveness, rather than permission :-).)

>> FUTEX_CMP_REQUEUE_PI
>>
>> 	PI aware variant of FUTEX_CMP_REQUEUE. Inner futex at uaddr is
>> 	a non PI futex. Outer futex to which is requeued is a PI futex
>> 	at uaddr2.
> 
> Inner/outer terminology applies specifically to the glibc pthread
> condition variable and mutex use case, but is overly specific for the man
> page. Consider:
> 
> PI aware variant for FUTEX_CMP_REQUEUE. Requeue tasks blocked on uaddr via
> FUTEX_WAIT_REQUEUE_PI from a non-PI source futex (uaddr) to a PI target
> futex (uaddr2).

Thanks for that text. It is easier to grasp.

>>
>> 	The waiters on uaddr must wait in FUTEX_WAIT_REQUEUE_PI.
>>
>> 	The argument val is contains the number of waiters on uaddr
>> 	which are immediately woken up. Must be 1 for this opcode.
> 
> Because the point is to avoid the thundering herd in the first place, and
> other nasty little races and faulting corner cases...

I added the piece about "thundering herd".

>> 	The timeout argument is abused to transport the number of
>> 	waiters which are requeued on to the futex at uaddr2. The
>> 	pointer is typecasted to u32.
> 
> 
>           val3 contains the expected value of uaddr (same as
> FUTEX_CMP_REQUEUE)

Yes. (The text now says that 'val3' has the same purpose as 
for FUTEX_CMP_REQUEUE.)

>> Darren, can you fill in the missing details?
> 
> Yup...
> 
>>
>> 	[EFAULT] Kernel was unable to access the futex value at uaddr
>> 		 or uaddr2
>>
>> 	[ENOMEM] Kernel could not allocate state
>>
>> 	[EINVAL] The supplied uaddr/uaddr2 arguments do not point to a
>> 		 valid object, i.e. pointer is not 4 byte aligned
>>
>> 	[EINVAL] uaddr equal uaddr2. Requeue to same futex.
>>
>> 	[EINVAL] The kernel detected inconsistent state between the
>> 		 user space state at uaddr and the kernel state,
>> 		 i.e. it detected a waiter which waits in
>> 		 FUTEX_LOCK_PI on uaddr
> 
>                    instead of FUTEX_WAIT_REQUEUE_PI.

Thanks. I added that detail.

>> 	[EINVAL] The kernel detected inconsistent state between the
>> 		 user space state at uaddr and the kernel state,
>> 		 i.e. it detected a waiter which waits in
>> 		 FUTEX_WAIT[_BITSET] on uaddr
>>
>> 	[EINVAL] The kernel detected inconsistent state between the
>> 		 user space state at uaddr2 and the kernel state,
>> 		 i.e. it detected a waiter which waits in
>> 		 FUTEX_WAIT on uaddr2.
> 
>           [EINVAL] The kernel detected the FUTEX_CMP_REQUEUE_PI call is
>                    attempting to requeue a task to a futex other than that
>                    specified by the matching FUTEX_WAIT_REQUEUE_PI call for
>                    that task.

Thanks. Added.

> A number of these EINVALs can probably be combined into "Kernel detected
> bad state" as far as the C library is concerned, but we can consolidate
> later. But basically, EINVAL is returned if the non-pi to pi or op pairing
> semantics are violated.

I think the page probably needs some text to cover that point. I'll add
a FIXME for review.

>>  	[EINVAL] The supplied bitset is zero.
> 
> Bitset doesn't apply to FUTEX_CMP_REQUEUE_PI.

Thanks.

>           [EINVAL] nr_wake != 1

Thanks, I'd already spotted this, but it's good to have confirmation.

> EAGAIN == EWOULDBLOCK. We use each in the kernel, but will just refer to
> them here as EAGAIN.

Yes. And I've followed that convention now in the man page.

>> 	[EAGAIN] uaddr1 readout is not equal the compare value in
>> 		 argument val3
>>
>> 	[EAGAIN] The futex owner TID of uaddr2 is about to exit, but
>> 		 has not yet handled the internal state cleanup. Try
>> 		 again.
>>
>> 	[EPERM]  Caller is not allowed to attach the waiter to the
>> 		 futex at uaddr2 Can be a legitimate issue or a hint
>> 		 for state corruption in user space
>>
>> 	[ESRCH]	 The TID in the user space value at uaddr2 does not exist
> 
> Hrm, I'm missing ESRCH and EPERM in my state diagrams.... put yes, we can
> get ESRCH when looking up PI state, and we can return that from
> futex_requeue.... That needs some time to review...
> 
> I'm not seeing the EPERM path, where is that coming from?

Any further insight on the above?

>> 	[EDEADLOCK] The requeuing of a waiter to the kernel representation
>> 		    of the PI futex at uaddr2 detected a deadlock scenario.
>>
>>        [ENOSYS] Not implemented on all architectures and not supported
>> 		 on some CPU variants (runtime detection)
> 
> Return value >= 0 is successful, indicating the number of of tasks
> requeued or woken (3 requeued and 1 woken would return 4).

Yes. Already noted.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
