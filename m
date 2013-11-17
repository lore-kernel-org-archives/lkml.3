Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3KQJnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 04:43:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50772 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3KQJni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 04:43:38 -0500
Date: Sun, 17 Nov 2013 10:43:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131117094320.GN16796@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109151014.GN16117@laptop.programming.kicks-ass.net>
 <20131114152304.GC5364@laptop.programming.kicks-ass.net>
 <20131114153301.GD5364@laptop.programming.kicks-ass.net>
 <528575E2.4000700@hitachi.com>
 <20131115122833.GE10456@twins.programming.kicks-ass.net>
 <20131115091521.3ad917fe@gandalf.local.home>
 <20131115142851.GA17498@localhost.localdomain>
 <52887617.7050302@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52887617.7050302@hitachi.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 04:53:59PM +0900, Masami Hiramatsu wrote:
> Agreed.
> FYI, kprobes has a recursion detection counter and it is reported via
> debugfs/tracing/kprobe_profile :)

Perf also has a recursion counter (4 actually, not reported to
userspace), but the problem with the irq_work_exit thing is that its a
non-recursive event loop, so recursion checks don't actually work to
catch it.
