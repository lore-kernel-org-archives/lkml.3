Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3HRDY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 23:24:27 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:38345 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab3HRDY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 23:24:26 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 17 Aug 2013 20:24:18 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/11] Fixes for 3.12
Message-ID: <20130818032417.GP28923@leaf>
References: <20130818013735.GA27234@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130818013735.GA27234@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 06:37:35PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series contains a number of miscellaneous fixes:
> 
> 1.	Switch to expedited grace periods during hibernation operations
> 	(courtesy of Borislav Petkov).
> 
> 2.	Restrict above expediting to systems of 256 or fewer CPUs.
> 
> 3.	Make RCU debugobjects fixup actions leak callbacks rather than
> 	risking corrupting the callback lists.
> 
> 4.	Propagate above callback leaking to debugobjects's callers.
> 
> 5.	Make call_rcu() leak callbacks when debugobjects indicates an error.
> 
> 6.	Switch to expedited grace periods during suspend/resume operations
> 	(Courtesy of Bjørn Mork).
> 
> 7.	Avoid needless self-wakeups from the grace-period kthreads.
> 
> 8.	Make list_first_or_null_rcu() use list_entry_rcu() (courtesy of
> 	Tejun Heo).
> 
> 9.	Fix irq_work_queue() build error for TREE_PREEMPT_RCU for some
> 	configurations (courtesy of James Hogan).
> 
> 10.	Simplify _rcu_barrier() processing per Linus Torvalds feedback.
> 
> 11.	Avoid signed-overflow undefined behavior in time_after() and friends.

Comments on 2, 6, and 11; for the rest:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
