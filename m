Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3LJBeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:34:31 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36368 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3LJBe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:34:29 -0500
X-Originating-IP: 173.246.103.110
Date: Mon, 9 Dec 2013 17:34:17 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Linux-Arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v5 tip/core/locking 6/7] locking: Add an
 smp_mb__after_unlock_lock() for UNLOCK+LOCK barrier
Message-ID: <20131210013417.GB24138@jtriplet-mobl1>
References: <20131210012738.GA24317@linux.vnet.ibm.com>
 <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386638883-25379-6-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386638883-25379-6-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:28:02PM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The Linux kernel has traditionally required that an UNLOCK+LOCK pair
> act as a full memory barrier when either (1) that UNLOCK+LOCK pair
> was executed by the same CPU or task, or (2) the same lock variable
> was used for the UNLOCK and LOCK.  It now seems likely that very few
> places in the kernel rely on this full-memory-barrier semantic, and
> with the advent of queued locks, providing this semantic either requires
> complex reasoning, or for some architectures, added overhead.
> 
> This commit therefore adds a smp_mb__after_unlock_lock(), which may be
> placed after a LOCK primitive to restore the full-memory-barrier semantic.
> All definitions are currently no-ops, but will be upgraded for some
> architectures when queued locks arrive.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Linux-Arch <linux-arch@vger.kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>

It seems quite unfortunate that this isn't in some common location, and
then only overridden by architectures that need to do so.

More importantly: you document this earlier in the patch series than you
introduce it.

- Josh Triplett
