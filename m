Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaCFKvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:51:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51081 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaCFKvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:51:38 -0500
Date: Thu, 6 Mar 2014 11:51:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, StevenRostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/clock: prevent tracing recursion in
 sched_clock_cpu()
Message-ID: <20140306105131.GK9987@twins.programming.kicks-ass.net>
References: <1394083528.4524.3.camel@nexus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394083528.4524.3.camel@nexus>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 02:25:28PM +0900, Fernando Luis Vázquez Cao wrote:
> From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> 
> Prevent tracing of preempt_disable/enable() in sched_clock_cpu().
> When CONFIG_DEBUG_PREEMPT is enabled, preempt_disable/enable() are
> traced and this causes trace_clock() users (and probably others) to
> go into an infinite recursion. Systems with a stable sched_clock()
> are not affected.
> 
> This problem is similar to that fixed by upstream commit 95ef1e52922
> ("KVM guest: prevent tracing recursion with kvmclock").
> 
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Thanks!
