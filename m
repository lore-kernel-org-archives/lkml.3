Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbbAGLkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:40:32 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50687 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbAGLkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:40:31 -0500
Date: Wed, 7 Jan 2015 12:40:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Yao Dongdong <yaodongdong@huawei.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [sched/core] BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000068
Message-ID: <20150107114024.GE23965@worktop.programming.kicks-ass.net>
References: <20150106230611.GA19001@wfg-t540p.sh.intel.com>
 <20150106230818.GB19001@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106230818.GB19001@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 03:08:18PM -0800, Fengguang Wu wrote:
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 293508K/327280K available (9326K kernel code, 3522K rwdata, 2656K rodata, 1108K init, 5048K bss, 33772K reserved, 0K cma-reserved)
> [    0.000000] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    0.000000] IP: [<ffffffff880bebe6>] do_set_cpus_allowed+0x18/0x51
> [    0.000000] PGD 0 
> [    0.000000] Oops: 0000 [#1] SMP 
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.19.0-rc2-gbb82635 #49
> [    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] task: ffffffff88e14e80 ti: ffffffff88e00000 task.ti: ffffffff88e00000
> [    0.000000] RIP: 0010:[<ffffffff880bebe6>]  [<ffffffff880bebe6>] do_set_cpus_allowed+0x18/0x51
> [    0.000000] RSP: 0000:ffffffff88e03ec8  EFLAGS: 00010002
> [    0.000000] RAX: 0000000000000000 RBX: ffffffff88e14e80 RCX: 0000000000000001
> [    0.000000] RDX: 0000000000000000 RSI: ffffffff88a146c8 RDI: ffffffff88e14e80
> [    0.000000] RBP: ffffffff88e03ed8 R08: ffffffff88e15000 R09: 0000000000000000
> [    0.000000] R10: ffffffff8916a4e8 R11: 0000000000000000 R12: ffffffff88a146c8
> [    0.000000] R13: 0000000000000008 R14: 0000000000000002 R15: 0000000000000000
> [    0.000000] FS:  0000000000000000(0000) GS:ffff880013a00000(0000) knlGS:0000000000000000
> [    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    0.000000] CR2: 0000000000000068 CR3: 0000000008e0e000 CR4: 00000000000006b0
> [    0.000000] Stack:
> [    0.000000]  ffffffff88e14e80 ffff880013a11a00 ffffffff88e03f18 ffffffff880bf136
> [    0.000000]  00000000ffffffff ffff880013a11a00 0000000000000008 0000000000000008
> [    0.000000]  0000000000011a00 0000000000014500 ffffffff88e03f48 ffffffff891a8c10
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff880bf136>] init_idle+0x88/0x142
> [    0.000000]  [<ffffffff891a8c10>] sched_init+0x2c5/0x333
> [    0.000000]  [<ffffffff891861db>] start_kernel+0x32d/0x7f5
> [    0.000000]  [<ffffffff89185120>] ? early_idt_handlers+0x120/0x120
> [    0.000000]  [<ffffffff8918559c>] x86_64_start_reservations+0x46/0x4f
> [    0.000000]  [<ffffffff891856e7>] x86_64_start_kernel+0x142/0x158
> [    0.000000] Code: 31 db 48 83 c4 18 89 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 48 ff 05 7a 5b 25 01 48 89 e5 41 54 49 89 f4 53 48 89 fb 48 8b 47 60 <48> 8b 40 68 48 85 c0 74 09 48 ff 05 62 5b 25 01 ff d0 49 8b 04 
> [    0.000000] RIP  [<ffffffff880bebe6>] do_set_cpus_allowed+0x18/0x51
> [    0.000000]  RSP <ffffffff88e03ec8>
> [    0.000000] CR2: 0000000000000068
> [    0.000000] ---[ end trace cfb024ef67550cb2 ]---
> [    0.000000] Kernel panic - not syncing: Fatal exception

The below delta seems to fix this...

---
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7254,6 +7254,11 @@ void __init sched_init(void)
 	enter_lazy_tlb(&init_mm, current);
 
 	/*
+	 * During early bootup we pretend to be a normal task:
+	 */
+	current->sched_class = &fair_sched_class;
+
+	/*
 	 * Make us the idle thread. Technically, schedule() should not be
 	 * called from this thread, however somewhere below it might be,
 	 * but because we are the idle thread, we just pick up running again
@@ -7263,11 +7268,6 @@ void __init sched_init(void)
 
 	calc_load_update = jiffies + LOAD_FREQ;
 
-	/*
-	 * During early bootup we pretend to be a normal task:
-	 */
-	current->sched_class = &fair_sched_class;
-
 #ifdef CONFIG_SMP
 	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
 	/* May be allocated at isolcpus cmdline parse time */
