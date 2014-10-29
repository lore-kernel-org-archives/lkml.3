Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbaJ2RxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:53:10 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:51972 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbaJ2Rwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:52:34 -0400
MIME-Version: 1.0
In-Reply-To: <20141028215140.GA23970@linux.vnet.ibm.com>
References: <20141028215140.GA23970@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 29 Oct 2014 13:52:03 -0400
Message-ID: <CAJhHMCDw3oUF9TNPGFzkVNrq2X3XcdjqmS-O5pEQESb=83exAg@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 0/9] Per-CPU-variable updates
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 5:51 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Hello!
>
> This series updates RCU's handling of per-CPU variables, mostly
> moving from "cpu" function arguments to various "this_"-style accessors
> for per-CPU variables:
>
> 1.      Drop the rdtp argument from RCU's dyntick-idle and sysidle
>         functions, substituting this_cpu_ptr(), courtesy of Christoph
>         Lameter.
>
> 2.      Use DEFINE_PER_CPU_SHARED_ALIGNED for rcu_data structures in
>         order to avoid false sharing with other per-CPU variables.
>
> 3-9.    Remove "cpu" arguments from a number of RCU functions that are
>         only ever invoked on that CPU, and use appropriate "this_"-style
>         accesssors for the per-CPU variables.
>

Reviewd-by: Pranith Kumar <bobby.prani@gmail.com>


>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
>  b/include/linux/rcupdate.h |    2 +-
>  b/include/linux/rcutiny.h  |    2 +-
>  b/include/linux/rcutree.h  |    4 ++--
>  b/kernel/cpu.c             |   19 +++++++++++++------
>  b/kernel/rcu/tiny.c        |    2 +-
>  b/kernel/rcu/tree.c        |   25 +++++++++++++------------
>  b/kernel/rcu/tree.h        |    4 ++--
>  b/kernel/rcu/tree_plugin.h |   11 +++++++----
>  b/kernel/sched/core.c      |    2 +-
>  b/kernel/softirq.c         |    2 +-
>  b/kernel/time/tick-sched.c |    2 +-
>  b/kernel/time/timer.c      |    3 +--
>  include/linux/rcupdate.h   |    2 +-
>  include/linux/rcutree.h    |    2 +-
>  kernel/rcu/tree.c          |   30 +++++++++++++++---------------
>  kernel/rcu/tree.h          |    8 ++++----
>  kernel/rcu/tree_plugin.h   |   42 +++++++++++++++++++++---------------------
>  17 files changed, 86 insertions(+), 76 deletions(-)
>



-- 
Pranith
