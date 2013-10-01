Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab3JAGj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 02:39:59 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:41632 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3JAGj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 02:39:58 -0400
Date: Tue, 1 Oct 2013 08:39:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] sched, wait: Make the __wait_event*() interface more
 friendly
Message-ID: <20131001063954.GA19111@gmail.com>
References: <20130930152242.207382649@infradead.org>
 <20130930152625.131613711@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930152625.131613711@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Change all __wait_event*() implementations to match the corresponding
> wait_event*() signature for convenience.
> 
> In particular this does away with the weird 'ret' logic. Since there
> are __wait_event*() users this requires we update them too.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/mips/kernel/rtlx.c         |   19 +++---
>  include/linux/tty.h             |   10 +--
>  include/linux/wait.h            |  113 +++++++++++++++++++---------------------
>  net/irda/af_irda.c              |    5 -
>  net/netfilter/ipvs/ip_vs_sync.c |    7 --
>  5 files changed, 73 insertions(+), 81 deletions(-)

Since now everyone seems to agree about this series, and since this 
particular patch changes generated code it would be really nice to split 
it into about ten per interface patches:

  - __wait_event_interruptible()
  - __wait_event_interruptible_timeout()
  - __wait_event_interruptible_exclusive()
  - __wait_event_interruptible_lock_irq()
  - __wait_event_interruptible_tty()
  - __wait_event()
  - __wait_event_timeout()
  - __wait_event_killable()
  - __wait_event_interruptible_lock_irq_timeout()

The changes seem to be mostly isolated, they are even in separate patch 
hunks most of the time making a splitup relatively easy - with a handful 
of semantic interdependencies.

There's very little downside to doing it the split-up way, and there's a 
lot of bisection and bug review upside, should any of these changes prove 
problematic...

Thanks,

	Ingo
