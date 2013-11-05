Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3KEU0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:26:41 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50822 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab3KEU0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:26:39 -0500
MIME-Version: 1.0
In-Reply-To: <20131105110026.878790658@infradead.org>
References: <20131105105244.666320103@infradead.org>
	<20131105110026.878790658@infradead.org>
Date: Tue, 5 Nov 2013 12:26:38 -0800
Message-ID: <CANN689EVEQUXUm9Nwu=-Gzr85tkMPVOEFWX=8dQQ3WbqfyZy5w@mail.gmail.com>
Subject: Re: [RFC 1/8] locking: Move mutex into kernel/locking/
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, rostedt@goodmis.org,
        airlied@gmail.com, maarten.lankhorst@canonical.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 4:10 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Index: linux-2.6/kernel/Makefile
> ===================================================================
> --- linux-2.6.orig/kernel/Makefile
> +++ linux-2.6/kernel/Makefile
> @@ -7,7 +7,7 @@ obj-y     = fork.o exec_domain.o panic.o
>             sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
>             signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
>             extable.o params.o posix-timers.o \
> -           kthread.o sys_ni.o posix-cpu-timers.o mutex.o \
> +           kthread.o sys_ni.o posix-cpu-timers.o \
>             hrtimer.o rwsem.o nsproxy.o semaphore.o \
>             notifier.o ksysfs.o cred.o reboot.o \
>             async.o range.o groups.o lglock.o smpboot.o

This is probably a stupid question, but I haven't been able to find
one kernel version that this applies cleanly over ???

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
