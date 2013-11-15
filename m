Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab3KOMLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:11:01 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:45724 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3KOMKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:10:53 -0500
Date: Fri, 15 Nov 2013 16:10:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf code using smp_processor_id() in preemptible [00000000] code
Message-ID: <20131115121051.GC26143@moon>
References: <20131115032907.GA25243@redhat.com>
 <20131115100254.GC2965@twins.programming.kicks-ass.net>
 <20131115101946.GG1754@moon>
 <20131115113046.GA26143@moon>
 <20131115115150.GC10456@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115115150.GC10456@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:51:50PM +0100, Peter Zijlstra wrote:
> ok, this will make the error go away, but what about the semantics of
> the case? Does it really matter for the grouping on which cpu we compute
> it? That is can we end up with a different group for one cpu as for
> another?
> 
> Or do we simply need a coherent single cpu to do the computation with?
> In which case raw_smp_processor_id() would also suffice.
> 
> If we can indeed get a different result depending on which cpu we do the
> computation, then things are broken, because it might be a task group
> we're building which has to be able to migrate around with the task.

The events are sensitive to which cpu they're scheduled to execute on
(if HT is turned on, we need to setup thread bit in register).
As far as I understand once events are assigned to cpu_hw_events
they are executing on this cpu, when tasks are migrated to another
cpu, they're re-scheduled. Or I miss something obvious here?

> 
> In that case we must compute the maximal group that can be scheduled on
> all cpus.
> 
> This wasn't at all clear.
