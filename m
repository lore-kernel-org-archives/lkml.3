Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbaFWQpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:45:38 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45493 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbaFWQpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:45:35 -0400
Date: Mon, 23 Jun 2014 09:45:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, dave.hansen@intel.com,
        ak@linux.intel.com, umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
Message-ID: <20140623164529.GE4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140621025958.GA7185@linux.vnet.ibm.com>
 <20140623062615.GB19860@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.11.1406230848540.2892@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406230848540.2892@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062316-9332-0000-0000-0000012C5141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 08:51:08AM -0500, Christoph Lameter wrote:
> On Mon, 23 Jun 2014, Peter Zijlstra wrote:
> 
> > On the topic of these threads; I recently noticed RCU grew a metric ton
> > of them, I found some 75 rcu kthreads on my box, wth up with that?
> 
> Would kworker threads work for rcu? That would also avoid the shifting
> around of RCU threads for NOHZ configurations (which seems to have to be
> done manually right now). The kworker subsystem work that allows
> restriction to non NOHZ hardware threads would then also allow the
> shifting of the rcu threads which would simplify the whole endeavor.

Short term, I am planning to use a different method to automate the
binding of the rcuo kthreads to housekeeping CPUs, but longer term,
it might well make a lot of sense to move to workqueues and the kworker
threads.

							Thanx, Paul

