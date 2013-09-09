Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3IIPM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:12:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53381 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3IIPM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:12:26 -0400
Date: Mon, 9 Sep 2013 17:08:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909150854.GD26785@twins.programming.kicks-ass.net>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <1378488088.31445.39.camel@edumazet-glaptop>
 <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909132343.GN3966@linux.vnet.ibm.com>
 <20130909133604.GC31370@twins.programming.kicks-ass.net>
 <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 02:49:42PM +0000, Christoph Lameter wrote:
> On Mon, 9 Sep 2013, Peter Zijlstra wrote:
> 
> > On Mon, Sep 09, 2013 at 06:23:43AM -0700, Paul E. McKenney wrote:
> > > And guys, I have to say that the advice on which per-CPU primitive to use
> > > varies wildly and randomly.  For all I know, each of you individually
> > > might well be sticking to the same story, but taken together, your
> > > collective advice is strongly resembling white noise.
> >
> > Its partly because cl and I disagree on things. He doesn't seem to care
> > much about validation and believes that people will not make mistakes
> > with this stuff.
> 
> Slander. Certainly validation is good. Its just that PREEMPT kernels are
> not in use 

Complete bullshit, its part of the mainline kernel, lots of people run
them -- including me, and any patch is supposed to keep it working.

> and AFAICT the full preempt stuff requires significant developer
> support and complicates the code without much benefit.

More bullshit, each and every patch submitted must fully support all
preemption modes supported by the kernel. CONFIG_PREEMPT is in, no two
ways about it. Breaking it is a regression and reason to revert stuff.

Therefore every Linux developer supports it per definition. And clearly
the complication is worth it for enough people, otherwise it wouldn't be
there.

The absolute worst part about you is your inability/unwillingness to
look beyond your immediate concern. Please pull head from arse.

> Having said that I am trying to support preeempt checks. The newest
> __get_cpu_var patchset introduces the preempt checks that you want.

Good, I did see some patches from you but haven't come around to looking
at them.
