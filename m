Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3ILOUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:20:22 -0400
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:56901 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539Ab3ILOUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:20:20 -0400
Date: Thu, 12 Sep 2013 14:20:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
In-Reply-To: <20130912063940.GC11583@gmail.com>
Message-ID: <00000141128b3e55-996e72db-3257-4d38-801a-ab70a7a20ca2-000000@email.amazonses.com>
References: <20130909105347.GK31370@twins.programming.kicks-ass.net> <20130909132343.GN3966@linux.vnet.ibm.com> <20130909133604.GC31370@twins.programming.kicks-ass.net> <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com>
 <20130909150854.GD26785@twins.programming.kicks-ass.net> <0000014103534c88-48ee11a3-a581-4e52-b2df-3a1168047d96-000000@email.amazonses.com> <20130909160024.GA25555@gmail.com> <20130909120328.583a586d@gandalf.local.home> <20130909161130.GA27188@gmail.com>
 <0000014109cebf30-d652cc46-6cf8-4bf1-8ca3-8f9a12c1d7e9-000000@email.amazonses.com> <20130912063940.GC11583@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.12-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Ingo Molnar wrote:

>
> * Christoph Lameter <cl@linux.com> wrote:
>
> > On Mon, 9 Sep 2013, Ingo Molnar wrote:
> >
> > > I saw those, he posted 'needs testing' patches. He still behaved
> > > passive-aggressively, pretending that it was some difficult task to
> > > perform, as if we were pulling his teeth.
> >
> > I need your review of those. I will rediff as soon as rc1 is out to send
> > something that can be put into -next. Please tell me until then if the
> > approach is ok. I dont think we can do anything in the merge window.
>
> The patch looked OK. Have you tested it, such as using a this_cpu op on a
> PREEMPT=y kernel in a preemptible section? That should trigger the preempt
> warning.

The reason that certain __this_cpu ops were converted to raw_cpu ops is
because they triggered the preemption check. The test was done in a kvm
environment (as evident from the description).



