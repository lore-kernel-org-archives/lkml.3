Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3H1NhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:37:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38153 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3H1NhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:37:10 -0400
Date: Wed, 28 Aug 2013 15:37:00 +0200
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
Message-ID: <20130828133700.GQ10002@twins.programming.kicks-ass.net>
References: <169431377178121@web21f.yandex.ru>
 <521BB71F.6080300@hp.com>
 <66111377605355@web12m.yandex.ru>
 <20130827091436.3d5971a0@gandalf.local.home>
 <20130827135309.GF10002@twins.programming.kicks-ass.net>
 <20130828012128.GT3871@linux.vnet.ibm.com>
 <20130828081937.GH10002@twins.programming.kicks-ass.net>
 <20130828085957.728a5375@gandalf.local.home>
 <20130828130529.GP10002@twins.programming.kicks-ass.net>
 <20130828091530.7ffe9ad0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828091530.7ffe9ad0@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 09:15:30AM -0400, Steven Rostedt wrote:
> Are you for the smp_mb__after_spin_unlock() ?

Sure, if the performance gains of having it out-weight the added
complexity of having it :-)

Nice non answer methinks, no? Muwhaha. To me having one more or less
'conditional' full mb primitive really doesn't matter anymore.

I'm presuming you're doing this for performance gains on anything other
than x86 though, as x86 has a non-atomic unlock and thus always requires
the full barrier thing here (yes yes I know ia32 still exists but people
should really really really kill that thing already).

> I'm getting confused by who is arguing what :-)

Hehe ;-)
