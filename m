Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbaHGLsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:48:43 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:59193 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335AbaHGLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:48:42 -0400
Date: Thu, 7 Aug 2014 13:48:31 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Wei.Yang@windriver.com
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH v1] MIPS: perf: Mark pmu interupt IRQF_NO_THREAD
Message-ID: <20140807114831.GB29898@linux-mips.org>
References: <1407217067-1144-1-git-send-email-Wei.Yang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407217067-1144-1-git-send-email-Wei.Yang@windriver.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 01:37:47PM +0800, Wei.Yang@windriver.com wrote:

> From: Yang Wei <Wei.Yang@windriver.com>
> 
> In RT kernel, I ran into the following calltrace, so PMU interrupts cannot
> be threaded
> 
> in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/0
> INFO: lockdep is turned off.
> Call Trace:
> [<ffffffff8088595c>] dump_stack+0x1c/0x50
> [<ffffffff801a958c>] __might_sleep+0x13c/0x148
> [<ffffffff80891c54>] rt_spin_lock+0x3c/0xb0
> [<ffffffff801ad29c>] __wake_up+0x3c/0x80
> [<ffffffff80243ba4>] perf_event_wakeup+0x8c/0xf8
> [<ffffffff80243c50>] perf_pending_event+0x40/0x78
> [<ffffffff8023d88c>] irq_work_run+0x74/0xc0
> [<ffffffff80152640>] mipsxx_pmu_handle_shared_irq+0x110/0x228
> [<ffffffff8015276c>] mipsxx_pmu_handle_irq+0x14/0x30
> [<ffffffff801ffda4>] handle_irq_event_percpu+0xbc/0x470
> [<ffffffff80204478>] handle_percpu_irq+0x98/0xc8
> [<ffffffff801ff284>] generic_handle_irq+0x4c/0x68
> [<ffffffff8089748c>] do_IRQ+0x2c/0x48
> [<ffffffff80105864>] plat_irq_dispatch+0x64/0xd0 

Hm...  I don't see why based on this backtrace you concluce the
handler needs to be marked IRQF_NO_THREAD.  However there's another
reason to mark it IRQF_NO_THREAD.  IRQ threads may be rescheduled to
other CPUs but this handler is fiddling with per-CPU resources.

See https://patchwork.linux-mips.org/patch/2818/ for a similar
scenario a few years ago.

  Ralf
