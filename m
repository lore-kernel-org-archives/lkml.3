Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3KIQIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 11:08:38 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:40627 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3KIQIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 11:08:34 -0500
Date: Sat, 9 Nov 2013 17:08:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131109160829.GF26079@localhost.localdomain>
References: <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109141039.GM16117@laptop.programming.kicks-ass.net>
 <20131109145258.GB26079@localhost.localdomain>
 <20131109151356.GA4971@laptop.programming.kicks-ass.net>
 <20131109152659.GD26079@localhost.localdomain>
 <20131109155938.GC4971@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109155938.GC4971@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 04:59:38PM +0100, Peter Zijlstra wrote:
> On Sat, Nov 09, 2013 at 04:27:01PM +0100, Frederic Weisbecker wrote:
> > In fact, raising an irq work from an irq work should simply be prohibited. That's not a sane
> > behaviour.
> 
> Well, it is because as you raised on IRC we could be holding locks and
> trying to avoid deadlocks. This is the very reason irq_work gets used in
> printk.
> 
> And its not a recursive run()->work()->queue() either, because as you said this
> tracepoint is in arch code _after_ work_run completes.

Yeah, indeed :(

> 
> All in all an exceedingly vexing issue.

Yep, the only sane way to solve this now is to check that signal pending, unfortunately
as you said it's not acquired that we can even just check this lockless...
