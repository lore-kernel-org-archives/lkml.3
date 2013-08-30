Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3H3CqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 22:46:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:48879 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab3H3CqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 22:46:02 -0400
Message-ID: <1377830702.4028.50.camel@pasglop>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Date: Fri, 30 Aug 2013 12:45:02 +1000
In-Reply-To: <CA+55aFw8o3h+ydR7PQK2a0BpN62o-7MQ38TXZkhvv6hVpcwbxA@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	 <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	 <1377751465.4028.20.camel@pasglop> <20130829070012.GC27322@gmail.com>
	 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	 <1377822408.4028.44.camel@pasglop>
	 <CA+55aFz4rJAAWopcSEJct55jUgCHY_6ZD=GSkKFmWanvd0otuw@mail.gmail.com>
	 <29797.1377828380@ale.ozlabs.ibm.com> <1377829857.4028.46.camel@pasglop>
	 <CA+55aFw8o3h+ydR7PQK2a0BpN62o-7MQ38TXZkhvv6hVpcwbxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 19:35 -0700, Linus Torvalds wrote:
> That said, on power, you have that "ACCESS_ONCE()" implicit in the
> *type*, not in the code, so an "arch_spinlock_t" is fundamentally
> volatile in itself. It's one of the reasons I despise "volatile":
> things like volatility are _not_ attributes of a variable or a type,
> but of the code in question. Something can be volatile in one context,
> but not in another (one context might be locked, for example).

Right, we can probably change that to use ACCESS_ONCE... volatile tend
to never quite do what you expect anyway.

Cheers,
Ben.


