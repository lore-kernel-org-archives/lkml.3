Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaFYFjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:39:25 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55851 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaFYFjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:39:24 -0400
Date: Wed, 25 Jun 2014 07:39:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, tglx@linutronix.de,
        cl@linux.com, dave.hansen@intel.com, ak@linux.intel.com,
        umgwanakikbuti@gmail.com, eric.dumazet@gmail.com,
        josh@joshtriplett.org, oleg@redhat.com
Subject: Re: [GIT PULL rcu/urgent] Fixes for 3.16
Message-ID: <20140625053920.GA21231@gmail.com>
References: <20140624135857.GA3203@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624135857.GA3203@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This series includes the following:
> 
> 1.	Export a pair of debug-object interfaces for RCU that will
> 	allow the slab allocators to avoid a recursion bug located
> 	by Sasha Levin.  Strictly speaking, this is not a regression,
> 	but it would be good to enable the fix.
> 
> 2.	Address a serious performance regression on an open/close
> 	micro-benchmark located by Dave Hansen.  The offending commit
> 	is ac1bea85781e (Make cond_resched() report RCU quiescent states).
> 
> Both have been exposed to -next testing, and are available in the git
> repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git urgent.2014.06.23a
> 
> for you to fetch changes up to 4a81e8328d3791a4f99bf5b436d050f6dc5ffea3:
> 
>   rcu: Reduce overhead of cond_resched() checks for RCU (2014-06-23 11:19:32 -0700)
> 
> ----------------------------------------------------------------
> Paul E. McKenney (2):
>       rcu: Export debug_init_rcu_head() and and debug_init_rcu_head()
>       rcu: Reduce overhead of cond_resched() checks for RCU
> 
>  Documentation/kernel-parameters.txt |   6 ++
>  include/linux/rcupdate.h            |  46 +++---------
>  kernel/rcu/tree.c                   | 140 ++++++++++++++++++++++++++++--------
>  kernel/rcu/tree.h                   |   6 +-
>  kernel/rcu/tree_plugin.h            |   2 +-
>  kernel/rcu/update.c                 |  22 +-----
>  kernel/sched/core.c                 |   7 +-
>  7 files changed, 137 insertions(+), 92 deletions(-)
> 

Pulled into tip:core/urgent, thanks a lot Paul!

	Ingo
