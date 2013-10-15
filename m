Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab3JOUhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:37:23 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42899 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3JOUhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:37:20 -0400
Date: Tue, 15 Oct 2013 22:37:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] bug: Use xchg() to update WARN_ON_ONCE() static variable
Message-ID: <20131015203715.GC3269@localhost.localdomain>
References: <20131015155806.04e2613f@gandalf.local.home>
 <20131015201816.GA3269@localhost.localdomain>
 <20131015162540.5275728a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015162540.5275728a@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 04:25:40PM -0400, Steven Rostedt wrote:
> On Tue, 15 Oct 2013 22:18:48 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> 
> > How about just updating __warned without a cmpxchg. It's not that critical
> > if the update is not seen immediately to other CPUs. OTOH it's critical
> > that's it is visible immediately to the current CPU
> 
> Well, I didn't use cmpxchg() I used xchg() which is actually quite
> faster.

Still, I doubt it's that cheap.

> 
> > 
> > I mean some warrning can be hard to reproduce and happen to some users
> > while staying for several kernel releases. If it's repetitive, the xchg
> > might impact the performance.
> 
> But do we care about that? A WARN_ON() means the kernel (or hardware)
> is buggy. It should be fixed.

Sure it should, doesn't mean it is. I've seen warnings that stayed on my
boot for several releases with non responsive maintainers (fortunately now
it seems that is got fixed).

> 
> But Andrew's ONCE() request is something we would want to avoid the
> xchg() every time.

We we use it yeah.

> 
> > 
> > I may be overly paranoid, but I think barrier() (so that at least
> > we don't recurse locally) alone would be better.
> 
> Heh, Boris is giving me the same argument on IRC ;-)
> 
> -- Steve
