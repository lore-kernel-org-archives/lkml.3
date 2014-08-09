Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaHIMou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 08:44:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:49734 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751023AbaHIMot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 08:44:49 -0400
Date: Sat, 9 Aug 2014 08:44:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140809084439.05778e33@gandalf.local.home>
In-Reply-To: <20140809061514.GK9918@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
	<1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<20140808191326.GE3935@laptop>
	<20140808205826.GG5821@linux.vnet.ibm.com>
	<20140809061514.GK9918@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2014 08:15:14 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

 
> As for idle tasks, I'm not sure about those, I think that we should say
> NO to anything that would require waking idle CPUs, push the pain to
> ftrace/kprobes, we should _not_ be waking idle cpus.

I agree, but I haven't had a chance to review the patch set (will
probably do that on Monday, just got back from vacation last week and
was inundated by other things). Does the idle waking happen only when
there's something queued in the call_rcu_tasks()? It should definitely
not be waking all the time. That's just wrong.

But if it only wakes when something is queued, it wouldn't be burdening
anything, unless it is needed.

-- Steve
