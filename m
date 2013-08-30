Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab3H3A2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:28:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:44468 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab3H3A2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:28:21 -0400
Message-ID: <1377822408.4028.44.camel@pasglop>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Michael Neuling <michael.neuling@au1.ibm.com>
Date: Fri, 30 Aug 2013 10:26:48 +1000
In-Reply-To: <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	 <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	 <1377751465.4028.20.camel@pasglop> <20130829070012.GC27322@gmail.com>
	 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 16:42 -0700, Linus Torvalds wrote:

> For architecture people (ie Ben, if you want to try this on ppc64),
> the thing that it needs from an architecture:
> 
>  - the raw_spinlock_t and the "unsigned long" needs to fit in a u64.

I assume you mean unsigned int ? :-)

 .../...

>  - the architecture needs to implement a simple
> "arch_spin_value_unlocked()" macro, which takes a raw_spinlock_t value
> and says whether it is unlocked or not.

What's wrong with the existing arch_spin_is_locked() ?

BTW. Do you have your test case at hand ?

Cheers,
Ben.

