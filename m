Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3HSAcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 20:32:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59007 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab3HSAcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 20:32:52 -0400
Date: Sun, 18 Aug 2013 17:32:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 02/11] rcu: Expedite during suspend and
 resume only on smallish systems
Message-ID: <20130819003242.GS29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818013735.GA27234@linux.vnet.ibm.com>
 <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376789876-27594-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818031831.GM28923@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818031831.GM28923@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081900-2398-0000-0000-0000019D0743
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 08:18:32PM -0700, Josh Triplett wrote:
> On Sat, Aug 17, 2013 at 06:37:47PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Expedited grace periods are of dubious benefit on very large systems,
> > so this commit restricts their automated use during suspend and resume
> > to systems of 256 or fewer CPUs.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This seems odd.  If expedited grace periods don't help on large systems,
> shouldn't you just compile them out entirely and ignore rcu_expedited,
> rather than just in this one special case?

Longer term, a bunch of stuff will need optimization for larger systems.
Expedited RCU grace periods, rcu_barrier(), possibly even grace-period
initialization and cleanup.  Also smp_call_function(), along with other
primitives that have broadcast semantics.  These changes would allow
this hack to be removed.

The most straightforward approach would be to provision helper kthreads,
increasing the number of helper kthreads with the number of CPUs.  But
I would like to see actual problems due to the lack of scalability before
adding more complexity to RCU.  ;-)

> In any case, if this patch still makes sense, please squash it into the
> previous one.

Fair enough, done!

							Thanx, Paul

