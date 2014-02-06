Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaBFLyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:54:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:13940 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766AbaBFLyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:54:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="470778086"
Date: Thu, 6 Feb 2014 19:53:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched/preempt] INFO: rcu_sched self-detected stall on CPU { 1}
Message-ID: <20140206115333.GA28544@localhost>
References: <20140206095646.GE17971@localhost>
 <20140206112731.GH4941@twins.programming.kicks-ass.net>
 <20140206114635.GA27429@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206114635.GA27429@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 07:46:35PM +0800, Fengguang Wu wrote:
> On Thu, Feb 06, 2014 at 12:27:31PM +0100, Peter Zijlstra wrote:
> > On Thu, Feb 06, 2014 at 05:56:46PM +0800, Fengguang Wu wrote:
> > > Hi Peter,
> > > 
> > > We noticed the below RCU stalls which will block the system.
> > > The problem is bisected to
> > > 
> > > commit 8cb75e0c4ec9786b81439761eac1d18d4a931af3
> > > Author:     Peter Zijlstra <peterz@infradead.org>
> > > AuthorDate: Wed Nov 20 12:22:37 2013 +0100
> > > Commit:     Ingo Molnar <mingo@kernel.org>
> > > CommitDate: Mon Jan 13 17:38:55 2014 +0100
> > > 
> > >     sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
> > >     
> > >  arch/x86/include/asm/mwait.h |  2 +-
> > >  include/linux/preempt.h      | 15 +++++++++++++++
> > >  include/linux/sched.h        | 15 +++++++++++++++
> > >  kernel/cpu/idle.c            | 17 ++++++++++-------
> > >  kernel/sched/core.c          |  3 +--
> > >  5 files changed, 42 insertions(+), 10 deletions(-)
> > > 
> > > [   85.786775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=15000 jiffies g=233 c=232 q=1940)
> > 
> > Did the initial kernel contain the below?
> 
> Nope, so I was testing some old tip sched/core..  Bisect log is

Peter, I just checked and find no longer showing up in new kernel tests.
So it must have been fixed up. Sorry for the noises!

Regards,
Fengguang
