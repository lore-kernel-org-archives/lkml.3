Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab3KEVUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:20:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39921 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3KEVUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:20:51 -0500
Date: Tue, 5 Nov 2013 22:20:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, rostedt@goodmis.org,
        airlied@gmail.com, maarten.lankhorst@canonical.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 1/8] locking: Move mutex into kernel/locking/
Message-ID: <20131105212029.GT28601@twins.programming.kicks-ass.net>
References: <20131105105244.666320103@infradead.org>
 <20131105110026.878790658@infradead.org>
 <CANN689EVEQUXUm9Nwu=-Gzr85tkMPVOEFWX=8dQQ3WbqfyZy5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689EVEQUXUm9Nwu=-Gzr85tkMPVOEFWX=8dQQ3WbqfyZy5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 12:26:38PM -0800, Michel Lespinasse wrote:
> On Tue, Nov 5, 2013 at 4:10 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Index: linux-2.6/kernel/Makefile
> > ===================================================================
> > --- linux-2.6.orig/kernel/Makefile
> > +++ linux-2.6/kernel/Makefile
> > @@ -7,7 +7,7 @@ obj-y     = fork.o exec_domain.o panic.o
> >             sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
> >             signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
> >             extable.o params.o posix-timers.o \
> > -           kthread.o sys_ni.o posix-cpu-timers.o mutex.o \
> > +           kthread.o sys_ni.o posix-cpu-timers.o \
> >             hrtimer.o rwsem.o nsproxy.o semaphore.o \
> >             notifier.o ksysfs.o cred.o reboot.o \
> >             async.o range.o groups.o lglock.o smpboot.o
> 
> This is probably a stupid question, but I haven't been able to find
> one kernel version that this applies cleanly over ???

Oh my bad, it appears I made it against a working tree, not an actual
published tree. That said, I don't think the rejects should be super
hard to fix.

If people don't object to the idea I'll respin against something
published and testable.


