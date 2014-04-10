Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161210AbaDJUtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:49:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57342 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131AbaDJUtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:49:10 -0400
Date: Thu, 10 Apr 2014 22:48:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140410204856.GO10526@twins.programming.kicks-ass.net>
References: <20140409151922.5fa5d999@gandalf.local.home>
 <20140410094430.56ca9ee1@sluggy.gateway.2wire.net>
 <5346B2C8.6000207@linutronix.de>
 <20140410153617.GN10526@twins.programming.kicks-ass.net>
 <20140410151741.617f86d9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410151741.617f86d9@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 03:17:41PM -0400, Steven Rostedt wrote:
> On Thu, 10 Apr 2014 17:36:17 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> 
> > It defaults to the total number of CPUs in the system, given the default
> > setup (all CPUs in a single balance domain), this should result in all
> > CPUs working concurrently on the boosted read sides.
> 
> Unfortunately, it currently defaults to the number of possible CPUs in
> the system. I should probably move the default assignment to after SMP
> is setup. Currently it happens in early boot before all the CPUs are
> running. On boot up, the limit is set to NR_CPUS which should be much
> higher than what the system has, but shouldn't matter during boot. But
> after all the CPUs are up and running, it can lower it to online CPUs.
> 
> I think I'll go and make v3 of this patch.

Yah, I should have read the patch in more than 5 seconds flat I suppose
:-)

modifying the number post smp bringup should be fine.
