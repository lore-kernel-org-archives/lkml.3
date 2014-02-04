Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaBDTqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:46:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56645 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaBDTqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:46:06 -0500
Date: Tue, 4 Feb 2014 20:45:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86: Use preempt_disable_notrace() in cycles_2_ns()
Message-ID: <20140204194556.GE5002@laptop.programming.kicks-ass.net>
References: <20140204141315.2a968a72@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204141315.2a968a72@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 02:13:15PM -0500, Steven Rostedt wrote:
> When debug preempt is enabled, preempt_disable() can be traced by
> function and function graph tracing.
> 
> There's a place in the function graph tracer that calls trace_clock()
> which eventually calls cycles_2_ns() outside of the recursion
> protection. When cycles_2_ns() calls preempt_disable() it gets traced
> and the graph tracer will go into a recursive loop causing a crash or
> worse, a triple fault.
> 
> Simple fix is to use preempt_disable_notrace() in cycles_2_ns, which
> makes sense because the preempt_disable() tracing may use that code
> too, and it tracing it, even with recursion protection is rather
> pointless.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Indeed, thanks!
