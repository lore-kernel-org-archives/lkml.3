Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab3DMPUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:20:04 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49200 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab3DMPUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:20:02 -0400
Date: Sat, 13 Apr 2013 08:19:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 3/7] rcu: Kick adaptive-ticks CPUs that are
 holding up RCU grace periods
Message-ID: <20130413151943.GX29861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365808754-20762-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAFTL4hz9Lf6uPDNR865O3GUK3gEVJy-nSTu8okFJXV3U+KsbDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hz9Lf6uPDNR865O3GUK3gEVJy-nSTu8okFJXV3U+KsbDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041315-5806-0000-0000-000020B70ED8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 04:06:58PM +0200, Frederic Weisbecker wrote:
> 2013/4/13 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >
> > Adaptive-ticks CPUs inform RCU when they enter kernel mode, but they do
> > not necessarily turn the scheduler-clock tick back on.  This state of
> > affairs could result in RCU waiting on an adaptive-ticks CPU running
> > for an extended period in kernel mode.  Such a CPU will never run the
> > RCU state machine, and could therefore indefinitely extend the RCU state
> > machine, sooner or later resulting in an OOM condition.
> >
> > This patch, inspired by an earlier patch by Frederic Weisbecker, therefore
> > causes RCU's force-quiescent-state processing to check for this condition
> > and to send an IPI to CPUs that remain in that state for too long.
> > "Too long" currently means about three jiffies by default, which is
> > quite some time for a CPU to remain in the kernel without blocking.
> > The rcu_tree.jiffies_till_first_fqs and rcutree.jiffies_till_next_fqs
> > sysfs variables may be used to tune "too long" if needed.
> >
> > Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> It might be better if I take this patch to get it through
> tip:timers/nohz so that I can keep it in sync with the rest. What do
> you think?

Works for me!  Let me know when you have picked it up and I will drop
it from my tree.

							Thanx, Paul

