Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3H3Ccd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 22:32:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:45728 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab3H3Ccb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 22:32:31 -0400
Message-ID: <1377829857.4028.46.camel@pasglop>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Date: Fri, 30 Aug 2013 12:30:57 +1000
In-Reply-To: <29797.1377828380@ale.ozlabs.ibm.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	 <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	 <1377751465.4028.20.camel@pasglop> <20130829070012.GC27322@gmail.com>
	 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	 <1377822408.4028.44.camel@pasglop>
	 <CA+55aFz4rJAAWopcSEJct55jUgCHY_6ZD=GSkKFmWanvd0otuw@mail.gmail.com>
	 <29797.1377828380@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 12:06 +1000, Michael Neuling wrote:

> powerpc patch below. I'm using arch_spin_is_locked() to implement
> arch_spin_value_unlocked().

>  
> +static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock)
> +{
> +	return !arch_spin_is_locked(&lock);
> +}
> +

Arguably, it should be done the other way around :-) 

arch_spin_value_unlocked semantics is to basically operate on an already
read copy of the value, while arch_spin_is_locked() has ACCESS_ONE
semantics on *top* of that.

Or we can keep both completely separate like Linus does on x86.

Cheers,
Ben.


