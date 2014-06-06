Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaFFM7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:59:42 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:47645 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaFFM7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:59:41 -0400
MIME-Version: 1.0
Date: Fri, 6 Jun 2014 18:29:39 +0530
Message-ID: <CAKnSG-aSwcGN6fX2vkmh0VOqprHNTjOv7t9Rtqg_3FibB-8MtA@mail.gmail.com>
Subject: Arm Target System hangs on uart_open/uart_write
From: Abhijit Lamsoge <abhijitelinux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
I've ported my driver to Linux Kernel 3.8.13.
Earlier it was working fine for 3.5.x Kernels.
I register a uart device file for data transfer like "/dev/xyz"
All the tty_ops for this UART driver are initialized to my own tty
uart_open/read/write/close functions.
Which are respectively called, when a sys_open comes on the above device file.

However,
the captured dmesg from "cat /proc/kmsg" shows all the correct prints
from the driver, and data is also transferred.
But the system "HANGS" giving the following message.
---------------------------------------------XX------------------------------------------------------------------------
181.350280] WARNING: at kernel/workqueue.c:1300 __queue_work+0x2c8/0x36c()
<4>[  181.353851] Modules linked in:
<4>[  181.355468] [<c001b3d0>] (unwind_backtrace+0x0/0xf0) from
[<c0042830>] (warn_slowpath_common+0x4c/0x64)
<4>[  181.360412] [<c0042830>] (warn_slowpath_common+0x4c/0x64) from
[<c0042864>] (warn_slowpath_null+0x1c/0x24)
<4>[  181.365447] [<c0042864>] (warn_slowpath_null+0x1c/0x24) from
[<c00587ac>] (__queue_work+0x2c8/0x36c)
<4>[  181.370178] [<c00587ac>] (__queue_work+0x2c8/0x36c) from
[<c00588b0>] (queue_work_on+0x40/0x4c)
<4>[  181.374694] [<c00588b0>] (queue_work_on+0x40/0x4c) from
[<c025a5e8>] (n_tty_open+0xa4/0x124)
<4>[  181.379028] [<c025a5e8>] (n_tty_open+0xa4/0x124) from
[<c025c8d8>] (tty_ldisc_open+0x50/0x74)
<4>[  181.383453] [<c025c8d8>] (tty_ldisc_open+0x50/0x74) from
[<c025d02c>] (tty_ldisc_setup+0x18/0x68)
<4>[  181.388092] [<c025d02c>] (tty_ldisc_setup+0x18/0x68) from
[<c02567bc>] (tty_init_dev+0xe0/0x17c)
<4>[  181.392639] [<c02567bc>] (tty_init_dev+0xe0/0x17c) from
[<c0256fe0>] (tty_open+0x2b0/0x518)
<4>[  181.396942] [<c0256fe0>] (tty_open+0x2b0/0x518) from
[<c00d45b0>] (chrdev_open+0x100/0x17c)
<4>[  181.401245] [<c00d45b0>] (chrdev_open+0x100/0x17c) from
[<c00cee7c>] (do_dentry_open+0x1d4/0x284)
<4>[  181.405853] [<c00cee7c>] (do_dentry_open+0x1d4/0x284) from
[<c00cef64>] (finish_open+0x38/0x4c)
<4>[  181.410400] [<c00cef64>] (finish_open+0x38/0x4c) from
[<c00dd1f0>] (do_last.isra.19+0x974/0xb98)
<4>[  181.414916] [<c00dd1f0>] (do_last.isra.19+0x974/0xb98) from
[<c00dd4bc>] (path_openat+0xa8/0x47c)
<4>[  181.419464] [<c00dd4bc>] (path_openat+0xa8/0x47c) from
[<c00ddb4c>] (do_filp_open+0x2c/0x78)
<4>[  181.423797] [<c00ddb4c>] (do_filp_open+0x2c/0x78) from
[<c00cffd4>] (do_sys_open+0xe4/0x174)
<4>[  181.428131] [<c00cffd4>] (do_sys_open+0xe4/0x174) from
[<c0013e00>] (ret_fast_syscall+0x0/0x30)
<4>[  181.432586] ---[ end trace d39416ed62ef112f ]---


------------------More stuff------------------------------

[  218.371063] INFO: rcu_preempt detected stalls on CPUs/tasks: { 0}
(detected by 1, t=2690 jiffies, g=1881, c=1880, q=87)
[  218.376617] Backtrace for cpu 1 (current):
[  218.378753] [<c001b3d0>] (unwind_backtrace+0x0/0xf0) from
[<c0019304>] (smp_send_all_cpu_backtrace+0x58/0xcc)
[  218.383850] [<c0019304>] (smp_send_all_cpu_backtrace+0x58/0xcc)
from [<c0094fac>] (rcu_check_callbacks+0x574/0x730)
[  218.389190] [<c0094fac>] (rcu_check_callbacks+0x574/0x730) from
[<c004f12c>] (update_process_times+0x3c/0x6c)
[  218.394287] [<c004f12c>] (update_process_times+0x3c/0x6c) from
[<c007eabc>] (tick_sched_timer+0x58/0x8c)
[  218.399139] [<c007eabc>] (tick_sched_timer+0x58/0x8c) from
[<c00620c8>] (__run_hrtimer.isra.16+0x50/0xd0)
[  218.404052] [<c00620c8>] (__run_hrtimer.isra.16+0x50/0xd0) from
[<c0062a68>] (hrtimer_interrupt+0x140/0x2a0)
[  218.409088] [<c0062a68>] (hrtimer_interrupt+0x140/0x2a0) from
[<c0019e34>] (arch_timer_handler_phys+0x2c/0x3c)
[  218.414215] [<c0019e34>] (arch_timer_handler_phys+0x2c/0x3c) from
[<c008f984>] (handle_percpu_devid_irq+0x80/0xa0)
[  218.419525] [<c008f984>] (handle_percpu_devid_irq+0x80/0xa0) from
[<c008c448>] (generic_handle_irq+0x20/0x30)
[  218.424621] [<c008c448>] (generic_handle_irq+0x20/0x30) from
[<c0014d5c>] (handle_IRQ+0x7c/0xac)
[  218.429138] [<c0014d5c>] (handle_IRQ+0x7c/0xac) from [<c000849c>]
(gic_handle_irq+0x3c/0x5c)
[  218.433441] [<c000849c>] (gic_handle_irq+0x3c/0x5c) from
[<c0013980>] (__irq_svc+0x40/0x74)
[  218.437744] Exception stack(0xeab87dd0 to 0xeab87e18)
[  218.440338] 7dc0:                                     00000002
00000002 00000000 00000001
[  218.444519] 7de0: eab87e3c c1395b80 c1395b80 c1395b88 00c8f000
00000001 00000000 00000000
[  218.448699] 7e00: 00000001 eab87e18 c0025458 c0082e68 20000113 ffffffff
[  218.452117] [<c0013980>] (__irq_svc+0x40/0x74) from [<c0082e68>]
(generic_exec_single+0x7c/0x94)
[  218.456634] [<c0082e68>] (generic_exec_single+0x7c/0x94) from
[<c0082fd4>] (smp_call_function_single+0x154/0x1d8)
[  218.461883] [<c0082fd4>] (smp_call_function_single+0x154/0x1d8)
from [<c0083480>] (smp_call_function+0x34/0x64)
[  218.467041] [<c0083480>] (smp_call_function+0x34/0x64) from
[<c0019ba4>] (flush_tlb_kernel_range+0x50/0x60)
[  218.472045] [<c0019ba4>] (flush_tlb_kernel_range+0x50/0x60) from
[<c0393f9c>] (binder_deferred_func+0x4ac/0x5f8)
[  218.477294] [<c0393f9c>] (binder_deferred_func+0x4ac/0x5f8) from
[<c00577f8>] (process_one_work+0x260/0x408)
[  218.482330] [<c00577f8>] (process_one_work+0x260/0x408) from
[<c0058050>] (worker_thread+0x2c8/0x428)
[  218.487060] [<c0058050>] (worker_thread+0x2c8/0x428) from
[<c005e418>] (kthread+0xa0/0xac)
[  218.491302] [<c005e418>] (kthread+0xa0/0xac) from [<c0013e98>]
(ret_from_fork+0x14/0x3c)
[  218.495452]
[  218.495452] sending IPI to all other CPUs:

----------------------Ends here-------------------------------

I am not sure, whether it's a problem of hardware, as when the kthread
schedules the work on CPU #1 for ARM.
There is no "unable to handle" message.
I am not am expert on how kernel internally handles workqueues and
schedules/puts them on the processor.

Any pointers in this regard are welcome.

-- Abhijit
