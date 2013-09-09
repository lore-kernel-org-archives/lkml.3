Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3IIOto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:49:44 -0400
Received: from a9-99.smtp-out.amazonses.com ([54.240.9.99]:54125 "EHLO
	a9-99.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640Ab3IIOtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:49:43 -0400
Date: Mon, 9 Sep 2013 14:49:42 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
In-Reply-To: <20130909133604.GC31370@twins.programming.kicks-ass.net>
Message-ID: <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com>
References: <20130905195234.GA20555@linux.vnet.ibm.com> <20130906105934.GF20519@somewhere> <20130906151851.GQ3966@linux.vnet.ibm.com> <1378488088.31445.39.camel@edumazet-glaptop> <20130906174117.GU3966@linux.vnet.ibm.com> <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net> <20130909132343.GN3966@linux.vnet.ibm.com> <20130909133604.GC31370@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.09-54.240.9.99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013, Peter Zijlstra wrote:

> On Mon, Sep 09, 2013 at 06:23:43AM -0700, Paul E. McKenney wrote:
> > And guys, I have to say that the advice on which per-CPU primitive to use
> > varies wildly and randomly.  For all I know, each of you individually
> > might well be sticking to the same story, but taken together, your
> > collective advice is strongly resembling white noise.
>
> Its partly because cl and I disagree on things. He doesn't seem to care
> much about validation and believes that people will not make mistakes
> with this stuff.

Slander. Certainly validation is good. Its just that PREEMPT kernels are
not in use and AFAICT the full preempt stuff requires significant developer
support and complicates the code without much benefit.

Having said that I am trying to support preeempt checks. The newest
__get_cpu_var patchset introduces the preempt checks that you want.
