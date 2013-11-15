Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3KOKDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:03:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48572 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3KOKDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:03:00 -0500
Date: Fri, 15 Nov 2013 11:02:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: gorcunov@gmail.com
Subject: Re: perf code using smp_processor_id() in preemptible [00000000] code
Message-ID: <20131115100254.GC2965@twins.programming.kicks-ass.net>
References: <20131115032907.GA25243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115032907.GA25243@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 10:29:07PM -0500, Dave Jones wrote:
> BUG: using smp_processor_id() in preemptible [00000000] code: trinity-main/890
> caller is p4_pmu_schedule_events+0x25/0x4c0

Whee, wherever did you dig up that dinosaur ;-)

> CPU: 0 PID: 890 Comm: trinity-main Not tainted 3.12.0+ #3 
> Hardware name: Dell Inc.                 Precision WorkStation 470    /0P7996, BIOS A05 05/18/2005
>  ffff88001e675668 ffff880025e79d00 ffffffff8171f332 0000000000000000
>  ffff880025e79d18 ffffffff8133132a 0000000000000002 ffff880025e79dc0
>  ffffffff81018e55 ffff88001e675668 00000000000080d0 ffff88001e675668
> Call Trace:
>  [<ffffffff8171f332>] dump_stack+0x4e/0x7a
>  [<ffffffff8133132a>] debug_smp_processor_id+0xca/0xe0
>  [<ffffffff81018e55>] p4_pmu_schedule_events+0x25/0x4c0
>  [<ffffffff811a5c9f>] ? kmem_cache_alloc_trace+0x12f/0x2d0
>  [<ffffffff810160ff>] ? allocate_fake_cpuc+0x2f/0x90
>  [<ffffffff81016443>] x86_pmu_event_init+0x193/0x440
>  [<ffffffff81146850>] perf_init_event+0x250/0x330
>  [<ffffffff81146600>] ? perf_pmu_unregister+0x160/0x160
>  [<ffffffff81146ca8>] perf_event_alloc+0x378/0x420
>  [<ffffffff81147335>] SYSC_perf_event_open+0x5e5/0xa80
>  [<ffffffff81147b89>] SyS_perf_event_open+0x9/0x10
>  [<ffffffff81731ee4>] tracesys+0xdd/0xe2

Hrmm, I'm not entire sure what we should do here; Cyrill, do you have
clue?
