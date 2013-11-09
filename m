Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab3KIIcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 03:32:13 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:60898 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3KIIcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 03:32:07 -0500
MIME-Version: 1.0
Date: Sat, 9 Nov 2013 12:32:06 +0400
Message-ID: <CAA1sL1SNn7O5CQbJn+dC5EjJKM-kfZq+brWLotC7LCNYVNBmeQ@mail.gmail.com>
Subject: Warning: NO_HZ FULL will not work with unstable sched clock
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
It first appeared some time after 3.9 or 3.10 and still persist.
I guess bisect is not required?

WARNING: CPU: 1 PID: 6 at kernel/time/tick-sched.c:187
can_stop_full_tick+0x8d/0x9a()
NO_HZ FULL will not work with unstable sched clock
Modules linked in:

CPU: 1 PID: 6 Comm: kworker/u8:0 Not tainted 3.12.0-01714-ga1212d2 #1
Hardware name:                  /D525MW, BIOS
MWPNT10N.86A.0084.2011.0726.1300 07/26/2011
 00000000000000bb ffff8800bea83e88 ffffffff813ba3b0 0000000000000050
 ffff8800bea83ed8 ffff8800bea83ec8 ffffffff81031441 ffff8800bb07a170
 ffffffff810687db 0000000000000000 0000000000000001 ffff8800bea91ac0
Call Trace:
 <IRQ>  [<ffffffff813ba3b0>] dump_stack+0x46/0x58
 [<ffffffff81031441>] warn_slowpath_common+0x78/0x92
 [<ffffffff810687db>] ? can_stop_full_tick+0x8d/0x9a
 [<ffffffff810314f1>] warn_slowpath_fmt+0x42/0x44
 [<ffffffff81052353>] ? account_system_time+0x114/0x15c
 [<ffffffff810687db>] can_stop_full_tick+0x8d/0x9a
 [<ffffffff810689ef>] tick_nohz_irq_exit+0x77/0x93
 [<ffffffff81034c28>] irq_exit+0xd3/0xdc
 [<ffffffff81021b7c>] smp_apic_timer_interrupt+0x40/0x4d
 [<ffffffff813c474a>] apic_timer_interrupt+0x6a/0x70
 <EOI>  [<ffffffff8104da85>] ? finish_task_switch+0x6f/0xd1
 [<ffffffff8104da5a>] ? finish_task_switch+0x44/0xd1
 [<ffffffff813bd0ae>] __schedule+0x75a/0x7f3
 [<ffffffff813be291>] ? _raw_spin_unlock_irqrestore+0x9/0xb
 [<ffffffff8104d704>] ? complete+0x43/0x4b
 [<ffffffff8104068c>] ? umh_complete+0x17/0x20
 [<ffffffff81040710>] ? __call_usermodehelper+0x7b/0x80
 [<ffffffff81042b96>] ? process_one_work+0x2f4/0x304
 [<ffffffff813bd3f6>] schedule+0x5f/0x61
 [<ffffffff810433ba>] worker_thread+0x2a8/0x2ad
 [<ffffffff81043112>] ? manage_workers.isra.31+0x1b9/0x1b9
 [<ffffffff81047b86>] kthread+0xb6/0xbe
 [<ffffffff81047ad0>] ? __kthread_parkme+0x68/0x68
 [<ffffffff813c39fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff81047ad0>] ? __kthread_parkme+0x68/0x68
