Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3IIR3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:29:15 -0400
Received: from mail.openrapids.net ([64.15.138.104]:40593 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754543Ab3IIR3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:29:12 -0400
Date: Mon, 9 Sep 2013 13:29:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
	section?
Message-ID: <20130909172908.GA31239@Krystal>
References: <20130909124547.GB16280@somewhere> <20130909085504.2ddd7e69@gandalf.local.home> <20130909130851.GC16280@somewhere> <20130909092142.05780991@gandalf.local.home> <20130909134505.GF16280@somewhere> <20130909135656.GT3966@linux.vnet.ibm.com> <20130909101629.32df27a2@gandalf.local.home> <20130909161708.GX3966@linux.vnet.ibm.com> <20130909123422.7936e868@gandalf.local.home> <20130909165836.GB3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909165836.GB3966@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Sep 09, 2013 at 12:34:22PM -0400, Steven Rostedt wrote:
[...]
> > "rcu_is_ignored()" or "rcu_is_not_active()", "rcu_is_watching_you()"
> 
> You know, I am strongly tempted by "rcu_is_watching_you()", but I have
> this feeling that it is too cute for its own good.  ;-)

Wow, I just got off the plane, and look at what happened to this thread
;-)

Referring to your earlier question Paul, what I meant by my earlier
email on naming has been addressed by Steven: when exposing a new RCU
API, even if it is just for in-kernel use, we should be really cautious
not to tie it to implementation, but rather to concepts. Basically, my
original thought is that we should be able to express the exact same
concept in the kernel RCU implementation and in Userspace RCU. Here,
binding the name on whether the CPU is watching RCU really makes no
sense for urcu, since all the RCU flavors we currently have are watching
threads, not CPUs.

Hence my proposal for "rcu_read_check()". It could be "rcu_is_active()"
too, I don't really mind. It really minds: Is RCU actively watching the
current execution context ? This can be translated to a runtime check
too: is it safe to call rcu_read_lock() form this context ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
