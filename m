Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbaHFQqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:46:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbaHFQqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:46:36 -0400
Date: Wed, 6 Aug 2014 18:46:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: WARN_ON_ONCE(in_nmi()) hit in irq_work_queue_on
Message-ID: <20140806164633.GY3935@laptop>
References: <20140806162113.GC14261@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806162113.GC14261@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 12:21:13PM -0400, Dave Jones wrote:
> WARNING: CPU: 3 PID: 18062 at kernel/irq_work.c:72 irq_work_queue_on+0x11e/0x140()
> CPU: 3 PID: 18062 Comm: trinity-subchil Not tainted 3.16.0+ #34
>  0000000000000009 00000000903774d1 ffff880244e06c00 ffffffff9a7f1e37
>  0000000000000000 ffff880244e06c38 ffffffff9a0791dd ffff880244fce180
>  0000000000000003 ffff880244e06d58 ffff880244e06ef8 0000000000000000
> Call Trace:
>  <NMI>  [<ffffffff9a7f1e37>] dump_stack+0x4e/0x7a
>  [<ffffffff9a0791dd>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff9a07930a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff9a17ca1e>] irq_work_queue_on+0x11e/0x140
>  [<ffffffff9a10a2c7>] tick_nohz_full_kick_cpu+0x57/0x90
>  [<ffffffff9a186cd5>] __perf_event_overflow+0x275/0x350
>  [<ffffffff9a184f80>] ? perf_event_task_disable+0xa0/0xa0
>  [<ffffffff9a01a4cf>] ? x86_perf_event_set_period+0xbf/0x150
>  [<ffffffff9a187934>] perf_event_overflow+0x14/0x20
>  [<ffffffff9a020386>] intel_pmu_handle_irq+0x206/0x410
>  [<ffffffff9a0b54d3>] ? arch_vtime_task_switch+0x63/0x130
>  [<ffffffff9a01937b>] perf_event_nmi_handler+0x2b/0x50
>  [<ffffffff9a007b72>] nmi_handle+0xd2/0x390
>  [<ffffffff9a007aa5>] ? nmi_handle+0x5/0x390
>  [<ffffffff9a0d131b>] ? lock_release+0xab/0x330
>  [<ffffffff9a008062>] default_do_nmi+0x72/0x1c0
>  [<ffffffff9a0c925f>] ? cpuacct_account_field+0xcf/0x200
>  [<ffffffff9a008268>] do_nmi+0xb8/0x100
>  [<ffffffff9a7ff66a>] end_repeat_nmi+0x1e/0x2e
>  [<ffffffff9a0c925f>] ? cpuacct_account_field+0xcf/0x200
>  [<ffffffff9a0d131b>] ? lock_release+0xab/0x330
>  [<ffffffff9a0d131b>] ? lock_release+0xab/0x330
>  [<ffffffff9a0d131b>] ? lock_release+0xab/0x330
>  <<EOE>>  [<ffffffff9a0c9277>] cpuacct_account_field+0xe7/0x200
>  [<ffffffff9a0c9195>] ? cpuacct_account_field+0x5/0x200
>  [<ffffffff9a0b4d18>] account_system_time+0x98/0x1a0
>  [<ffffffff9a0b4e4e>] __vtime_account_system+0x2e/0x40
>  [<ffffffff9a0b5419>] vtime_user_enter+0x59/0x90
>  [<ffffffff9a18e183>] ? context_tracking_user_enter+0xd3/0x1f0
>  [<ffffffff9a18e183>] context_tracking_user_enter+0xd3/0x1f0
>  [<ffffffff9a013815>] syscall_trace_leave+0xa5/0x210
>  [<ffffffff9a7fd8bf>] int_check_syscall_exit_work+0x34/0x3d
> ---[ end trace 73831bdc3ef3ba75 ]---

Urgh, Frederic, any idea how that happened? 
