Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab3JOUZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:25:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:49148 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759739Ab3JOUZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:25:43 -0400
Date: Tue, 15 Oct 2013 16:25:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] bug: Use xchg() to update WARN_ON_ONCE() static
 variable
Message-ID: <20131015162540.5275728a@gandalf.local.home>
In-Reply-To: <20131015201816.GA3269@localhost.localdomain>
References: <20131015155806.04e2613f@gandalf.local.home>
	<20131015201816.GA3269@localhost.localdomain>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 22:18:48 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:


> How about just updating __warned without a cmpxchg. It's not that critical
> if the update is not seen immediately to other CPUs. OTOH it's critical
> that's it is visible immediately to the current CPU

Well, I didn't use cmpxchg() I used xchg() which is actually quite
faster.

> 
> I mean some warrning can be hard to reproduce and happen to some users
> while staying for several kernel releases. If it's repetitive, the xchg
> might impact the performance.

But do we care about that? A WARN_ON() means the kernel (or hardware)
is buggy. It should be fixed.

But Andrew's ONCE() request is something we would want to avoid the
xchg() every time.

> 
> I may be overly paranoid, but I think barrier() (so that at least
> we don't recurse locally) alone would be better.

Heh, Boris is giving me the same argument on IRC ;-)

-- Steve
