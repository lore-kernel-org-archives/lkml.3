Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3GPOog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:44:36 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:49269 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3GPOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:44:34 -0400
Message-ID: <51E55B7D.2040209@linux.vnet.ibm.com>
Date: Tue, 16 Jul 2013 20:11:01 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, bhelgaas@google.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: workqueue, pci: INFO: possible recursive locking detected
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071614-5140-0000-0000-00000386C60C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been seeing this warning every time during boot. I haven't
spent time digging through it though... Please let me know if
any machine-specific info is needed.

Regards,
Srivatsa S. Bhat


----------------------------------------------------

=============================================
[ INFO: possible recursive locking detected ]
3.11.0-rc1-lockdep-fix-a #6 Not tainted
---------------------------------------------
kworker/0:1/142 is trying to acquire lock:
 ((&wfc.work)){+.+.+.}, at: [<ffffffff81077100>] flush_work+0x0/0xb0

but task is already holding lock:
 ((&wfc.work)){+.+.+.}, at: [<ffffffff81075dd9>] process_one_work+0x169/0x610

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock((&wfc.work));
  lock((&wfc.work));

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/0:1/142:
 #0:  (events){.+.+.+}, at: [<ffffffff81075dd9>] process_one_work+0x169/0x610
 #1:  ((&wfc.work)){+.+.+.}, at: [<ffffffff81075dd9>] process_one_work+0x169/0x610
 #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff8139a3ba>] device_attach+0x2a/0xc0

stack backtrace:
CPU: 0 PID: 142 Comm: kworker/0:1 Not tainted 3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
Workqueue: events work_for_cpu_fn
 ffff881036fecd88 ffff881036fef678 ffffffff8161a919 0000000000000003
 ffff881036fec400 ffff881036fef6a8 ffffffff810c2234 ffff881036fec400
 ffff881036fecd88 ffff881036fec400 0000000000000000 ffff881036fef708
Call Trace:
 [<ffffffff8161a919>] dump_stack+0x59/0x80
 [<ffffffff810c2234>] print_deadlock_bug+0xf4/0x100
 [<ffffffff810c3d14>] validate_chain+0x504/0x750
 [<ffffffff810c426d>] __lock_acquire+0x30d/0x580
 [<ffffffff810c4577>] lock_acquire+0x97/0x170
 [<ffffffff81077100>] ? start_flush_work+0x220/0x220
 [<ffffffff81077148>] flush_work+0x48/0xb0
 [<ffffffff81077100>] ? start_flush_work+0x220/0x220
 [<ffffffff810c2c10>] ? mark_held_locks+0x80/0x130
 [<ffffffff81074cfb>] ? queue_work_on+0x4b/0xa0
 [<ffffffff810c2f85>] ? trace_hardirqs_on_caller+0x105/0x1d0
 [<ffffffff810c305d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81077320>] work_on_cpu+0x80/0x90
 [<ffffffff8106f950>] ? wqattrs_hash+0x190/0x190
 [<ffffffff812d37b0>] ? pci_pm_prepare+0x60/0x60
 [<ffffffff812a0059>] ? cpumask_next_and+0x29/0x50
 [<ffffffff812d38da>] __pci_device_probe+0x9a/0xe0
 [<ffffffff81620850>] ? _raw_spin_unlock_irq+0x30/0x50
 [<ffffffff812d4be2>] ? pci_dev_get+0x22/0x30
 [<ffffffff812d4c2a>] pci_device_probe+0x3a/0x60
 [<ffffffff81620850>] ? _raw_spin_unlock_irq+0x30/0x50
 [<ffffffff8139a4bc>] really_probe+0x6c/0x320
 [<ffffffff8139a7b7>] driver_probe_device+0x47/0xa0
 [<ffffffff8139a8c0>] ? __driver_attach+0xb0/0xb0
 [<ffffffff8139a913>] __device_attach+0x53/0x60
 [<ffffffff81398404>] bus_for_each_drv+0x74/0xa0
 [<ffffffff8139a430>] device_attach+0xa0/0xc0
 [<ffffffff812cb2d9>] pci_bus_add_device+0x39/0x60
 [<ffffffff812eec21>] virtfn_add+0x251/0x3e0
 [<ffffffff810c305d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff812ef29f>] sriov_enable+0x22f/0x3d0
 [<ffffffff812ef48d>] pci_enable_sriov+0x4d/0x60
 [<ffffffffa0143045>] be_vf_setup+0x175/0x410 [be2net]
 [<ffffffffa01493ca>] be_setup+0x37a/0x4b0 [be2net]
 [<ffffffffa0149ac0>] be_probe+0x5c0/0x820 [be2net]
 [<ffffffff812d37fe>] local_pci_probe+0x4e/0x90
 [<ffffffff8106f968>] work_for_cpu_fn+0x18/0x30
 [<ffffffff81075e4a>] process_one_work+0x1da/0x610
 [<ffffffff81075dd9>] ? process_one_work+0x169/0x610
 [<ffffffff8107650c>] worker_thread+0x28c/0x3a0
 [<ffffffff81076280>] ? process_one_work+0x610/0x610
 [<ffffffff8107da3e>] kthread+0xee/0x100
 [<ffffffff8107d950>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8162a71c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107d950>] ? __init_kthread_worker+0x70/0x70

