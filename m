Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaHDN2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:28:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaHDN2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:28:08 -0400
Date: Mon, 4 Aug 2014 15:25:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140804132525.GA18722@redhat.com>
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com> <20140802145616.GA18195@redhat.com> <20140802225757.GB8101@linux.vnet.ibm.com> <20140803133318.GB671@redhat.com> <20140803220535.GH8101@linux.vnet.ibm.com> <53DED5D1.6030504@cn.fujitsu.com> <20140804010938.GI8101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804010938.GI8101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Paul E. McKenney wrote:
>
> On Mon, Aug 04, 2014 at 08:37:37AM +0800, Lai Jiangshan wrote:
> > An alternative solution:
> > srcu_read_lock() before exit_notify(), srcu_read_unlock() after the last preempt_disable()
> > in the do_exit, and synchronize_srcu() in rcu_tasks_kthread().
>
> That is a good way to synchronize with the exiting tasks, and I will
> probably that that approach.
>
> I -thought- that Oleg was concerned about safely building the list to
> start with, though.

But for_each_process_thread() under rcu_read_lock() should work except
it can miss the exiting tasks.

So it seems that the clever Lai's trick should solve the problem.

Oleg.

