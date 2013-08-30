Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3H3RR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:17:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43756 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab3H3RR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:17:27 -0400
Date: Fri, 30 Aug 2013 19:17:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130830171707.GV31370@twins.programming.kicks-ass.net>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
 <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
 <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
 <1377751465.4028.20.camel@pasglop>
 <20130829070012.GC27322@gmail.com>
 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 09:43:07AM -0700, Linus Torvalds wrote:

> We'll see. The real problem is that I'm not sure if I can even see the
> scalability issue on any machine I actually personally want to use
> (read: silent). On my current  system I can only get up to 15%
> _raw_spin_lock by just stat'ing the same file over and over and over
> again from lots of threads.

Yeah, silent basically limits you to i7 single socket systems and sadly
Intel doesn't seem to want to make those with more than 4 cores on :/

I've got a i7-K part (SNB iirc) with a _huge_ scythe cooler and a high
efficiency fanless PSU for a system that's near noiseless -- as in my
Thinkpad actually makes more noise.
