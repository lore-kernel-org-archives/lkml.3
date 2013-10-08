Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab3JHUks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:40:48 -0400
Received: from tex.lwn.net ([70.33.254.29]:53621 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab3JHUkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:40:47 -0400
Date: Tue, 8 Oct 2013 14:40:45 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] rcu: Create rcu_sync infrastructure
Message-ID: <20131008144045.6f9f4401@lwn.net>
In-Reply-To: <20131008103830.180541879@infradead.org>
References: <20131008102505.404025673@infradead.org>
	<20131008103830.180541879@infradead.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, so this is a real nit, but...in the changelog:

>         static inline void rcu_sync_enter(struct rcu_sync_struct *xxx)
>         {
>                 atomic_inc(&xxx->counter);
>                 synchronize_sched();
>         }
> 
>         static inline void rcu_sync_enter(struct rcu_sync_struct *xxx)
>         {
>                 synchronize_sched();
>                 atomic_dec(&xxx->counter);
>         }

That second rcu_sync_enter should really be rcu_sync_exit.

Is the "xxx" there to test spamassassin configurations? :)

jon
