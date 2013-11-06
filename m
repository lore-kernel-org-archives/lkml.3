Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab3KFFkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:40:53 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:56741 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3KFFkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:40:52 -0500
Date: Wed, 6 Nov 2013 06:40:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michel Lespinasse <walken@google.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com,
        dhowells@redhat.com, willy@linux.intel.com, tglx@linutronix.de,
        rostedt@goodmis.org, airlied@gmail.com,
        maarten.lankhorst@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/8] locking: Move mutex into kernel/locking/
Message-ID: <20131106054048.GB23746@gmail.com>
References: <20131105105244.666320103@infradead.org>
 <20131105110026.878790658@infradead.org>
 <CANN689EVEQUXUm9Nwu=-Gzr85tkMPVOEFWX=8dQQ3WbqfyZy5w@mail.gmail.com>
 <20131105212029.GT28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105212029.GT28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Nov 05, 2013 at 12:26:38PM -0800, Michel Lespinasse wrote:
> > On Tue, Nov 5, 2013 at 4:10 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > Index: linux-2.6/kernel/Makefile
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/Makefile
> > > +++ linux-2.6/kernel/Makefile
> > > @@ -7,7 +7,7 @@ obj-y     = fork.o exec_domain.o panic.o
> > >             sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
> > >             signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
> > >             extable.o params.o posix-timers.o \
> > > -           kthread.o sys_ni.o posix-cpu-timers.o mutex.o \
> > > +           kthread.o sys_ni.o posix-cpu-timers.o \
> > >             hrtimer.o rwsem.o nsproxy.o semaphore.o \
> > >             notifier.o ksysfs.o cred.o reboot.o \
> > >             async.o range.o groups.o lglock.o smpboot.o
> > 
> > This is probably a stupid question, but I haven't been able to find
> > one kernel version that this applies cleanly over ???
> 
> Oh my bad, it appears I made it against a working tree, not an actual 
> published tree. That said, I don't think the rejects should be super 
> hard to fix.
> 
> If people don't object to the idea I'll respin against something 
> published and testable.

Please do it against the locking tree (tip:core/locking), it has pending 
changes plus v3.12 as well.

Thanks,

	Ingo
