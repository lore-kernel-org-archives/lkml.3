Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaAMSgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:36:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbaAMSgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:36:00 -0500
Date: Mon, 13 Jan 2014 19:35:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/1] lockdep: Kill held_lock->check and "int check" arg
	of __lock_acquire()
Message-ID: <20140113183555.GA14125@redhat.com>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net> <20140109163120.GA8038@redhat.com> <20140109170823.GF7572@laptop.programming.kicks-ass.net> <20140112094041.GB31809@gmail.com> <20140112174532.GA12147@redhat.com> <20140112200049.GO7572@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140112200049.GO7572@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Peter Zijlstra wrote:
>
> On Sun, Jan 12, 2014 at 06:45:32PM +0100, Oleg Nesterov wrote:
> > But could someone please explain me what should lockdep_no_validate
> > actually do? 1704f47b5 "lockdep: Add novalidate class for dev->mutex
> > conversion" doesn't tell which kind of warnings it tries to avoid,
> > and it looks buggy (see another email from me).
>
> It should disable lock-order checks for the locks that set that as
> class. So we can still do the simple checks like detect if we free
> memory with a held lock in and make sure we do not return to userspace
> with a held lock; but the class should not participate in the lock
> graph.

Yes, this is what I more or less understood, but I was confused anyway.
Somehow I thought that this patch tries to suppress the warnings caused
by rw_semaphore -> mutex conversion, and I was completely puzzled. But
3142788b79 "drivers/base: Convert dev->sem to mutex" actually did the
semaphore -> mutex change!

Everything is clear now, thanks!

Oleg.

