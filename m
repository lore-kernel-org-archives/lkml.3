Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3JBPZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:25:47 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:44434 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3JBPZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:25:44 -0400
Date: Wed, 2 Oct 2013 17:25:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v4 0/3] qrwlock: Introducing a queue read/write lock
 implementation
Message-ID: <20131002152539.GB15757@gmail.com>
References: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com>
 <20131002151937.GU3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002151937.GU3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Oct 02, 2013 at 10:09:03AM -0400, Waiman Long wrote:
> > v3->v4:
> >  - Optimize the fast path with better cold cache behavior and
> >    performance.
> >  - Removing some testing code.
> >  - Make x86 use queue rwlock with no user configuration.
> 
> >  arch/x86/Kconfig                      |    1 +
> >  arch/x86/include/asm/spinlock.h       |    2 +
> >  arch/x86/include/asm/spinlock_types.h |    4 +
> >  include/asm-generic/qrwlock.h         |  256 +++++++++++++++++++++++++++++++++
> >  include/linux/rwlock.h                |   15 ++
> >  include/linux/rwlock_types.h          |   13 ++
> >  kernel/Kconfig.locks                  |    7 +
> >  lib/Makefile                          |    1 +
> >  lib/qrwlock.c                         |  247 +++++++++++++++++++++++++++++++
> >  lib/spinlock_debug.c                  |   19 +++
> >  10 files changed, 565 insertions(+), 0 deletions(-)
> >  create mode 100644 include/asm-generic/qrwlock.h
> >  create mode 100644 lib/qrwlock.c
> 
> 
> Where's the ---- for removing the old rwlock from x86?

Also, if we go this route then please name it as much rwlock_t as possible 
- we didn't rename spinlock internals to 'qspinlock' either when queueing 
was added.

It's a new implementation, not a different lock type.

For a test prototype it's OK - just not for the final form IMO.

Also, at first glance there's little reason why this should be x86 only. 
It uses fairly generic SMP primitives that should be available on every 
architecture.

Assuming the performance figures are right.

Thanks,

	Ingo
