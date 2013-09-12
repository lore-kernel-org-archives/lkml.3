Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab3ILGjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:39:46 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:34349 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3ILGjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:39:44 -0400
Date: Thu, 12 Sep 2013 08:39:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20130912063940.GC11583@gmail.com>
References: <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909132343.GN3966@linux.vnet.ibm.com>
 <20130909133604.GC31370@twins.programming.kicks-ass.net>
 <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com>
 <20130909150854.GD26785@twins.programming.kicks-ass.net>
 <0000014103534c88-48ee11a3-a581-4e52-b2df-3a1168047d96-000000@email.amazonses.com>
 <20130909160024.GA25555@gmail.com>
 <20130909120328.583a586d@gandalf.local.home>
 <20130909161130.GA27188@gmail.com>
 <0000014109cebf30-d652cc46-6cf8-4bf1-8ca3-8f9a12c1d7e9-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014109cebf30-d652cc46-6cf8-4bf1-8ca3-8f9a12c1d7e9-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Mon, 9 Sep 2013, Ingo Molnar wrote:
> 
> > I saw those, he posted 'needs testing' patches. He still behaved 
> > passive-aggressively, pretending that it was some difficult task to 
> > perform, as if we were pulling his teeth.
> 
> I need your review of those. I will rediff as soon as rc1 is out to send 
> something that can be put into -next. Please tell me until then if the 
> approach is ok. I dont think we can do anything in the merge window.

The patch looked OK. Have you tested it, such as using a this_cpu op on a 
PREEMPT=y kernel in a preemptible section? That should trigger the preempt 
warning.

Thanks,

	Ingo
