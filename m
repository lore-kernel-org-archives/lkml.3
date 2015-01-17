Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbbAQT1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 14:27:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:14847 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbbAQT1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 14:27:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,417,1418112000"; 
   d="scan'208";a="638798914"
User-Agent: Microsoft-MacOutlook/14.4.6.141106
Date: Sat, 17 Jan 2015 11:26:54 -0800
Subject: Re: futex(2) man page update help request
From: Darren Hart <dvhart@linux.intel.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "Carlos O'Donell" <carlos@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <D0DFF430.B7F94%dvhart@linux.intel.com>
Thread-Topic: futex(2) man page update help request
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
 <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>
 <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
 <CF9A731D.913E6%dvhart@linux.intel.com>
 <54B7D8D4.2070203@gmail.com>
 <D0DEF1AE.B7EDE%dvhart@linux.intel.com>
 <54BA2872.5040003@gmail.com>
In-Reply-To: <54BA2872.5040003@gmail.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 1/17/15, 1:16 AM, "Michael Kerrisk (man-pages)"
<mtk.manpages@gmail.com> wrote:

>Hello Darren,
>
>On 01/17/2015 02:33 AM, Darren Hart wrote:
>> Corrected Davidlohr's email address.
>
>Thanks!
>
>> On 1/15/15, 7:12 AM, "Michael Kerrisk (man-pages)"
>> <mtk.manpages@gmail.com> wrote:
>> 
>>> Hello Darren,
>>>
>>> I give you the same apology as to Thomas for the
>>> long-delayed response to your mail.
>>>
>>> And I repeat my note to Thomas:
>>> In the next day or two, I hope to send out the new version
>>> of the futex(2) page for review. The new draft is a bit
>>> bigger (okay -- 4 x bigger) than the current page. And there
>>> are a quite number of FIXMEs that I've placed in the page
>>> for various points--some minor, but a few major--that need
>>> to be checked or fixed. Would you have some time to review
>>> that page?
>> 
>> I'll make the time for that. I've wanted to see this for a while, so
>>thank
>> you for working on it!
>
>Great!
>
>>> In the meantime, I have a couple of questions, which, if
>>> you could answer them, I would work some changes into the
>>> page before sending.
>>>
>>> 1. In various places, distinction is made between non-PI
>>>   futexs and PI futexes. But what determines that distinction?
>>>   From the kernel's perspective, hat make a futex one type
>>>   or another? I presume it is to do with the types of blocking
>>>   waiters on the futex, but it would be good to have a formal
>>>   definition.
>> 
>> You're right in that a uaddr is a uaddr is a uaddr. Also "there is no
>>such
>> thing as a futex", it doesn't exist as any kind of identifiable object,
>>so
>> these discussions can get rather confusing :-)
>
>So, I want to make sure that I am clear on what you mean you say this.
>You say "there is no such thing as a futex" because from the kernel's
>perspective there is no visible entity in the uncontended case
>(where everything can be dealt with in user space). And from user-space,
>in the uncontended case all we're doing is memory operations. Right?
>
>On the other hand, from a kernel perspective, we could say that a
>futex "exists" in the contended phases, since the kernel has allocated
>state associated with the uaddr. Right?


Sorry, this was more anecdotal, and probably more of a distraction than
constructive. I just meant that unlike other things which you can point to
a specific struct for (task, rt_mutex, etc.), a "futex" has it's state
distributed across the backing store (uaddr), the queue (futex_q), the
pi_state, the rt_mutex, etc, and these span kernel space and userspace.
Your description above is correct.

>
>> A "futex" becomes a PI futex when it is "created" via a PI futex op
>>code.
>
>Precisely which PI op codes? Is it: FUTEX_LOCK_PI, FUTEX_TRYLOCK_PI, and
>FUTEX_CMP_REQUEUE_PI, and not FUTEX_WAIT_REQUEUE_PI or FUTEX_UNLOCK_PI?

Based on your wording below about taking a user POV on this, I'm going to
say "yes" here. These opcodes paired with the PI futex value policy
(described below) defines a "futex" as PI aware. These were created very
specifically in support of PI pthread_mutexes, so it makes a lot more
sense to talk about a PI aware pthread_mutex, than a PI aware futex, since
there is a lot of policy and scaffolding that has to be built up around it
to use it properly (this is what a PI pthread_mutex is).

>> At that point, the syscall will ensure a pi_state is populated for the
>> futex_q entry. See futex_lock_pi() for example. Before the locks are
>> taken, there is a call to refill_pi_state_cache() which preps a pi_state
>> for assignment later in futex_lock_pi_atomic(). This pi_state provides
>>the
>> necessary linkage to perform the priority boosting in the event of a
>> priority inversion. This is handled externally from the futexes via the
>> rt_mutex construct.
>> 
>> Clear as mud?
>
>Not quite that bad, but... The thing is, still, the man page has text
>such as the following (based on your wording):
>
>       FUTEX_CMP_REQUEUE_PI (since Linux 2.6.31)
>              This operation is a PI-aware variant of FUTEX_CMP_REQUEUE.
>              It    requeues    waiters    that    are    blocked    via
>              FUTEX_WAIT_REQUEUE_PI  on uaddr from a non-PI source futex
>              (uaddr) to a PI target futex (uaddr2).
>
>And elsewhere you said
>
>    EINVAL is returned if the non-pi to pi or
>    op pairing semantics are violated.
>
>When someone in user-land (e.g., me) reads pieces like that, they then
>want to find somewhere in the man page a description of what makes a
>futex a *PI futex* and probably some statements of the distinction
>between PI and non-PI futexes. And those statements should be from a
>perspective that is somewhat comprehensible to user-space. I'm not
>yet confident that I can do that. Do you care to take a shot at it?

Hrm, tricky indeed. From userspace, what makes a "futex" PI is the policy
agreement between kernel and userspace (which is the value of the futex:
0, TID, TID|WAITERS, and never just WAITERS, and the use of PI aware futex
op codes when making the futex syscalls.

For a longer discussion of this policy, see Documentation/pi-futex.txt.
Also note that this policy can be combined with that for robust futexes,
adding the OWNERDIED component.

--
Darren Hart
Intel Open Source Technology Center






