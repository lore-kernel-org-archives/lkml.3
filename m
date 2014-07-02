Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaGBRzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:55:13 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44748 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaGBRzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:55:11 -0400
Date: Wed, 2 Jul 2014 10:55:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140702175501.GW4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
 <20140702153915.GQ4603@linux.vnet.ibm.com>
 <20140702160412.GO19379@twins.programming.kicks-ass.net>
 <20140702170838.GS4603@linux.vnet.ibm.com>
 <20140702172600.GR19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702172600.GR19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070217-8236-0000-0000-0000038CE281
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 07:26:00PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 02, 2014 at 10:08:38AM -0700, Paul E. McKenney wrote:
> > As were others, not that long ago.  Today is the first hint that I got
> > that you feel otherwise.  But it does look like the softirq approach to
> > callback processing needs to stick around for awhile longer.  Nice to
> > hear that softirq is now "sane and normal" again, I guess.  ;-)
> 
> Nah, softirqs are still totally annoying :-)

Name me one thing that isn't annoying.  ;-)

> So I've lost detail again, but it seems to me that on all CPUs that are
> actually getting ticks, waking tasks to process the RCU state is
> entirely over doing it. Might as well keep processing their RCU state
> from the tick as was previously done.

And that is in fact the approach taken by my patch.  For which I just
kicked off testing, so expect an update later today.  (And that -is-
optimistic!  A pessimistic viewpoint would hold that the patch would
turn out to be so broken that it would take -weeks- to get a fix!)

							Thanx, Paul

