Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaB1VzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:55:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43741 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaB1VzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:55:24 -0500
Date: Fri, 28 Feb 2014 22:55:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228215511.GB6835@laptop.programming.kicks-ass.net>
References: <530FC1C6.5040209@zytor.com>
 <20140227183008.6be081b7@gandalf.local.home>
 <530FCE6C.4080808@zytor.com>
 <alpine.DEB.2.10.1402271957380.6210@vincent-weaver-1.um.maine.edu>
 <20140228203405.GH11910@linux.vnet.ibm.com>
 <20140228154716.0198d7cb@gandalf.local.home>
 <20140228205409.GB14089@laptop.programming.kicks-ass.net>
 <20140228211733.GK11910@linux.vnet.ibm.com>
 <20140228212700.GH14089@laptop.programming.kicks-ass.net>
 <20140228215150.GM11910@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228215150.GM11910@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 01:51:50PM -0800, Paul E. McKenney wrote:
> On Fri, Feb 28, 2014 at 10:27:00PM +0100, Peter Zijlstra wrote:
> > On Fri, Feb 28, 2014 at 01:17:33PM -0800, Paul E. McKenney wrote:
> > > This code isn't running in idle context is it?  If so, RCU will happily
> > > free out from under it.  CONFIG_PROVE_RCU should detect this sort of thing,
> > > though.
> > 
> > Well, interrupts/NMIs can happen when idle, but the interrupt/NMI
> > entry code deals with the idle state AFAIK.
> 
> Yep, rcu_irq_enter() and rcu_nmi_enter() deal with that.  More worried
> about this being code invoked from some energy-efficiency driver or
> another within the idle loop.

Right, so any tracepoint can end up there; but I thought there was
already the rule that tracepoints needed RCU enabled.
