Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaJKFQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 01:16:31 -0400
Received: from mga03.intel.com ([134.134.136.65]:47899 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbaJKFQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 01:16:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,696,1406617200"; 
   d="scan'208";a="587125899"
Date: Sat, 11 Oct 2014 13:16:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [x86, PCI, ACPI] WARNING: CPU: 0 PID: 3 at kernel/rcu/tree.c:2360
 rcu_process_callbacks+0x43f/0x531()
Message-ID: <20141011051627.GB21803@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiang,

FYI, we noticed the below changes on

https://github.com/jiangliu/linux.git ioapic/hotplug_v6
commit e96f3bd3186db57bbde9f4e5c57d8328f7f0ec79 ("x86, PCI, ACPI: Kill private function resource_to_addr() in arch/x86/pci/acpi.c")


+------------------------------------------------------+------------+------------+
|                                                      | 452b6361c4 | e96f3bd318 |
+------------------------------------------------------+------------+------------+
| boot_successes                                       | 20         | 13         |
| boot_failures                                        | 0          | 6          |
| WARNING:at_kernel/rcu/tree.c:rcu_process_callbacks() | 0          | 6          |
| backtrace:smpboot_thread_fn                          | 0          | 4          |
| page_allocation_failure:order:,mode                  | 0          | 1          |
| backtrace:cpu_startup_entry                          | 0          | 1          |
| backtrace:vmalloc                                    | 0          | 1          |
| backtrace:SyS_init_module                            | 0          | 1          |
| backtrace:acpi_bus_scan                              | 0          | 1          |
| backtrace:acpi_scan_init                             | 0          | 1          |
| backtrace:acpi_init                                  | 0          | 1          |
| backtrace:kernel_init_freeable                       | 0          | 1          |
+------------------------------------------------------+------------+------------+


[    1.323479] PCI: CLS 0 bytes, default 64
[    1.325701] Trying to unpack rootfs image as initramfs...
[    1.852166] ------------[ cut here ]------------
[    1.853652] WARNING: CPU: 0 PID: 3 at kernel/rcu/tree.c:2360 rcu_process_callbacks+0x43f/0x531()
[    1.856015] Modules linked in:
[    1.856015] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.17.0-rc6-00063-g1e527ce #1
[    1.856015] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.856015]  0000000000000000 ffff8800136efd58 ffffffff819d5e8b 0000000000000000
[    1.856015]  ffff8800136efd90 ffffffff810e7670 ffffffff8112f441 ffffffff82057400
[    1.856015]  0000000000000004 0000000000000000 0000000000000246 ffff8800136efda0
[    1.856015] Call Trace:
[    1.856015]  [<ffffffff819d5e8b>] dump_stack+0x4d/0x66
[    1.856015]  [<ffffffff810e7670>] warn_slowpath_common+0x7f/0x98
[    1.856015]  [<ffffffff8112f441>] ? rcu_process_callbacks+0x43f/0x531
[    1.856015]  [<ffffffff810e773c>] warn_slowpath_null+0x1a/0x1c
[    1.856015]  [<ffffffff8112f441>] rcu_process_callbacks+0x43f/0x531
[    1.856015]  [<ffffffff810eac98>] __do_softirq+0x131/0x2e4
[    1.856015]  [<ffffffff810eae74>] run_ksoftirqd+0x29/0x65
[    1.856015]  [<ffffffff81102c0a>] smpboot_thread_fn+0x194/0x1b2
[    1.856015]  [<ffffffff81102a76>] ? SyS_setgroups+0x106/0x106
[    1.856015]  [<ffffffff810ffd7b>] kthread+0xe4/0xec
[    1.856015]  [<ffffffff810ffc97>] ? kthread_create_on_node+0x18c/0x18c
[    1.856015]  [<ffffffff819dd27c>] ret_from_fork+0x7c/0xb0
[    1.856015]  [<ffffffff810ffc97>] ? kthread_create_on_node+0x18c/0x18c
[    1.856015] ---[ end trace c038ce2226e5515b ]---
[    2.010076] Freeing initrd memory: 4692K (ffff880013b5b000 - ffff880013ff0000)



Thanks,
Fengguang
