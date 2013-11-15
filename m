Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3KOM26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:28:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51071 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3KOM2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:28:51 -0500
Date: Fri, 15 Nov 2013 13:28:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131115122833.GE10456@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109151014.GN16117@laptop.programming.kicks-ass.net>
 <20131114152304.GC5364@laptop.programming.kicks-ass.net>
 <20131114153301.GD5364@laptop.programming.kicks-ass.net>
 <528575E2.4000700@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528575E2.4000700@hitachi.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 10:16:18AM +0900, Masami Hiramatsu wrote:
> Kprobes itself can detect nested call by using per-cpu current-running
> kprobe pointer. And if it is nested, it just skips calling handlers.
> Anyway, I don't recommend to probe inside the handlers, but yes,
> you can trace perf-handler by ftrace B). I actually traced a kprobe-bug
> by kprobe-tracer last night, that was amazing :)

Ah, ok, so that would avoid the worst problems. Good. Should we still
mark the entire perf swevent path as __kprobes just to be sure?
