Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3H1NFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:05:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36734 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab3H1NFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:05:45 -0400
Date: Wed, 28 Aug 2013 15:05:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alexander Fyodorov <halcy@yandex.ru>, Waiman Long <waiman.long@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue
 spinlock implementation
Message-ID: <20130828130529.GP10002@twins.programming.kicks-ass.net>
References: <336901377100289@web16f.yandex.ru>
 <5215638E.5020702@hp.com>
 <169431377178121@web21f.yandex.ru>
 <521BB71F.6080300@hp.com>
 <66111377605355@web12m.yandex.ru>
 <20130827091436.3d5971a0@gandalf.local.home>
 <20130827135309.GF10002@twins.programming.kicks-ass.net>
 <20130828012128.GT3871@linux.vnet.ibm.com>
 <20130828081937.GH10002@twins.programming.kicks-ass.net>
 <20130828085957.728a5375@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828085957.728a5375@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 08:59:57AM -0400, Steven Rostedt wrote:
> On Wed, 28 Aug 2013 10:19:37 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> 
> > > An unlock followed by a lock needs to act like a full barrier, but there
> > > is no requirement that a lock or unlock taken separately act like a
> > > full barrier.
> > 
> > But that is already a property of the acquisition/release barrier.
> 
> As I mentioned in my fixes for the -rt swait barrier patches I sent.

Not to me you didn't ;-)

> Spin locks only prevent leaks out of the critical section. It does not
> guarantee leaks into the critical section, thus:

What's your point? You're just re-iterating the semantics in case
anybody forgot about them?
