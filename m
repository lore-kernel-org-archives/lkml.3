Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbaALUBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 15:01:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38284 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaALUBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 15:01:07 -0500
Date: Sun, 12 Jan 2014 21:00:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/1] lockdep: Kill held_lock->check and "int check" arg
 of __lock_acquire()
Message-ID: <20140112200049.GO7572@laptop.programming.kicks-ass.net>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
 <20140109163120.GA8038@redhat.com>
 <20140109170823.GF7572@laptop.programming.kicks-ass.net>
 <20140112094041.GB31809@gmail.com>
 <20140112174532.GA12147@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140112174532.GA12147@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 06:45:32PM +0100, Oleg Nesterov wrote:
> But could someone please explain me what should lockdep_no_validate
> actually do? 1704f47b5 "lockdep: Add novalidate class for dev->mutex
> conversion" doesn't tell which kind of warnings it tries to avoid,
> and it looks buggy (see another email from me).

It should disable lock-order checks for the locks that set that as
class. So we can still do the simple checks like detect if we free
memory with a held lock in and make sure we do not return to userspace
with a held lock; but the class should not participate in the lock
graph.

I'll have a look at your earlier email again; I did note the question
but it slipped my mind :/
