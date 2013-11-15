Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab3KOD3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 22:29:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab3KOD3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 22:29:43 -0500
Date: Thu, 14 Nov 2013 22:29:07 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: perf code using smp_processor_id() in preemptible [00000000] code
Message-ID: <20131115032907.GA25243@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: using smp_processor_id() in preemptible [00000000] code: trinity-main/890
caller is p4_pmu_schedule_events+0x25/0x4c0
CPU: 0 PID: 890 Comm: trinity-main Not tainted 3.12.0+ #3 
Hardware name: Dell Inc.                 Precision WorkStation 470    /0P7996, BIOS A05 05/18/2005
 ffff88001e675668 ffff880025e79d00 ffffffff8171f332 0000000000000000
 ffff880025e79d18 ffffffff8133132a 0000000000000002 ffff880025e79dc0
 ffffffff81018e55 ffff88001e675668 00000000000080d0 ffff88001e675668
Call Trace:
 [<ffffffff8171f332>] dump_stack+0x4e/0x7a
 [<ffffffff8133132a>] debug_smp_processor_id+0xca/0xe0
 [<ffffffff81018e55>] p4_pmu_schedule_events+0x25/0x4c0
 [<ffffffff811a5c9f>] ? kmem_cache_alloc_trace+0x12f/0x2d0
 [<ffffffff810160ff>] ? allocate_fake_cpuc+0x2f/0x90
 [<ffffffff81016443>] x86_pmu_event_init+0x193/0x440
 [<ffffffff81146850>] perf_init_event+0x250/0x330
 [<ffffffff81146600>] ? perf_pmu_unregister+0x160/0x160
 [<ffffffff81146ca8>] perf_event_alloc+0x378/0x420
 [<ffffffff81147335>] SYSC_perf_event_open+0x5e5/0xa80
 [<ffffffff81147b89>] SyS_perf_event_open+0x9/0x10
 [<ffffffff81731ee4>] tracesys+0xdd/0xe2

