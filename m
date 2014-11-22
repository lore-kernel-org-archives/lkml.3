Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaKVTME (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 14:12:04 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:12111 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751137AbaKVTMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 14:12:02 -0500
Date: Sat, 22 Nov 2014 14:11:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [ftrace/x86/extable] WARNING: CPU: 0 PID: 1 at init/main.c:803
 do_one_initcall()
Message-ID: <20141122141139.78927371@gandalf.local.home>
In-Reply-To: <20141122184349.GB29361@wfg-t540p.sh.intel.com>
References: <20141122184349.GB29361@wfg-t540p.sh.intel.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2014 10:43:49 -0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git rfc/seq-buf
> 
> commit 716c18f8e57c5eff4725f0b5acbdb2fead202d8c

Yeah I had a brain fart with this patch that my tests quickly caught
(which I push to my repo for your basic tests as I start testing with
my own tests). But it wasn't up for very long before I rebased it with
a working patch.


> Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
> AuthorDate: Tue Nov 18 21:14:11 2014 -0500
> Commit:     Steven Rostedt <rostedt@goodmis.org>
> CommitDate: Tue Nov 18 23:26:23 2014 -0500

Is it possible for your tests to see if a branch was rebased before
posting bug reports to LKML? This gave me a scare that my new code had
the same brain fart in it.

-- Steve


> 
>     ftrace/x86/extable: Add is_ftrace_trampoline() function
>     
>     Stack traces that happen from function tracing check if the address
>     on the stack is a __kernel_text_address(). That is, is the address
>     kernel code. This calls core_kernel_text() which returns true
>     if the address is part of the builtin kernel code. It also calls
>     is_module_text_address() which returns true if the address belongs
>     to module code.
>     
>     But what is missing is ftrace dynamically allocated trampolines.
>     These trampolines are allocated for individual ftrace_ops that
>     call the ftrace_ops callback functions directly. But if they do a
>     stack trace, the code checking the stack wont detect them as they
>     are neither core kernel code nor module address space.
>     
>     Adding another field to ftrace_ops that also stores the size of
>     the trampoline assigned to it we can create a new function called
>     is_ftrace_trampoline() that returns true if the address is a
>     dynamically allocate ftrace trampoline. Note, it ignores trampolines
>     that are not dynamically allocated as they will return true with
>     the core_kernel_text() function.
>     
>     Link: http://lkml.kernel.org/r/20141119034829.497125839@goodmis.org
>     
>     Cc: Thomas Gleixner <tglx@linutronix.de>
>     Cc: Ingo Molnar <mingo@redhat.com>
>     Cc: "H. Peter Anvin" <hpa@zytor.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> +-------------------------------------------------------------------------+------------+------------+------------+
> |                                                                         | 766d21c795 | 716c18f8e5 | d165a751a0 |
> +-------------------------------------------------------------------------+------------+------------+------------+
> | boot_successes                                                          | 60         | 0          | 0          |
> | boot_failures                                                           | 0          | 20         | 16         |
> | WARNING:at_init/main.c:do_one_initcall()                                | 0          | 20         | 16         |
> | initcall_init_kprobes_returned_with_preemption_imbalance                | 0          | 20         | 16         |
> | BUG:scheduling_while_atomic                                             | 0          | 20         | 11         |
> | BUG:workqueue_leaked_lock_or_atomic:kworker                             | 0          | 1          | 2          |
> | backtrace:init_kprobes                                                  | 0          | 20         | 16         |
> | backtrace:warn_slowpath_fmt                                             | 0          | 20         | 16         |
> | backtrace:kernel_init_freeable                                          | 0          | 20         | 16         |
> | backtrace:event_trace_self_tests                                        | 0          | 20         | 11         |
> | backtrace:event_trace_self_tests_init                                   | 0          | 20         | 11         |
> | backtrace:dump_stack                                                    | 0          | 1          | 2          |
> | backtrace:test_work                                                     | 0          | 1          | 2          |
> | initcall_event_trace_self_tests_init_returned_with_preemption_imbalance | 0          | 18         | 7          |
> | backtrace:unregister_ftrace_function                                    | 0          | 18         | 7          |
> | BUG:kernel_boot_hang                                                    | 0          | 0          | 2          |
> +-------------------------------------------------------------------------+------------+------------+------------+
> 
> [    1.649109] Kprobe smoke test: passed successfully
> [    1.649888] ------------[ cut here ]------------
> [    1.649888] ------------[ cut here ]------------
> [    1.650631] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x1a9/0x200()
> [    1.650631] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x1a9/0x200()
> [    1.652149] initcall init_kprobes+0x0/0x1d2 returned with preemption imbalance 
> [    1.652149] initcall init_kprobes+0x0/0x1d2 returned with preemption imbalance 
> [    1.653357] Modules linked in:
> [    1.653357] Modules linked in:
> 
> [    1.653857] CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc1-00020-g716c18f #58
> [    1.653857] CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc1-00020-g716c18f #58
> [    1.655071]  0000000000000009
> [    1.655071]  0000000000000009 ffff88001345fdf8 ffff88001345fdf8 ffffffff816356b2 ffffffff816356b2 ffff88001345fe38 ffff88001345fe38
> 
> [    1.656312]  ffffffff8108da6a
> [    1.656312]  ffffffff8108da6a ffff88001345fe58 ffff88001345fe58 0000000000000000 0000000000000000 0000000000000001 0000000000000001
> 
> [    1.657542]  0000000000000001
> [    1.657542]  0000000000000001 ffffffff81f09df6 ffffffff81f09df6 0000000000000000 0000000000000000 ffff88001345fe98 ffff88001345fe98
> 
> [    1.658800] Call Trace:
> [    1.658800] Call Trace:
> [    1.659200]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
> [    1.659200]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
> [    1.660020]  [<ffffffff8108da6a>] warn_slowpath_common+0x7a/0xa0
> [    1.660020]  [<ffffffff8108da6a>] warn_slowpath_common+0x7a/0xa0
> [    1.660991]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
> [    1.660991]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
> [    1.661994]  [<ffffffff8108dad6>] warn_slowpath_fmt+0x46/0x50
> [    1.661994]  [<ffffffff8108dad6>] warn_slowpath_fmt+0x46/0x50
> [    1.662900]  [<ffffffff81f09fbf>] ? init_kprobes+0x1c9/0x1d2
> [    1.662900]  [<ffffffff81f09fbf>] ? init_kprobes+0x1c9/0x1d2
> [    1.663810]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
> [    1.663810]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
> [    1.665184]  [<ffffffff810003c9>] do_one_initcall+0x1a9/0x200
> [    1.665184]  [<ffffffff810003c9>] do_one_initcall+0x1a9/0x200
> [    1.666615]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
> [    1.666615]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
> [    1.668170]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
> [    1.668170]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
> [    1.669476]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
> [    1.669476]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
> [    1.670763]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
> [    1.670763]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
> [    1.672123]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
> [    1.672123]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
> [    1.673365] ---[ end trace 660d24cf53fa6caf ]---
> [    1.673365] ---[ end trace 660d24cf53fa6caf ]---
> 
> git bisect start d165a751a05de3cd926f1378b0df3de3b7cab051 fc14f9c1272f62c3e8d01300f52467c0d9af50f9 --
> git bisect  bad 36e2c5fccd02b60b6e98f08aa61d33f43188fb08  # 16:03      0-     15  Merge 'jlayton/nfsd-3.20' into devel-lkp-ib04-smoke-201411191439
> git bisect  bad 847d1c3e2f2d8703f63b73420eb7a46c26f54e9b  # 16:35      0-     17  Merge 'shawnguo/imx/soc' into devel-lkp-ib04-smoke-201411191439
> git bisect  bad d4620f93d2a5011fe43d5de0ac8c8fd670b00705  # 17:19      0-     16  Merge 'pm/bleeding-edge' into devel-lkp-ib04-smoke-201411191439
> git bisect good d5b06eebb3c327b5ae53d4a80aa4a8061a8ba125  # 17:41     20+      0  0day base guard for 'devel-lkp-ib04-smoke-201411191439'
> git bisect  bad 5bc53bc9b7a94d183337b5233472a2480abbc655  # 18:36      0-     16  Merge 'trace/rfc/seq-buf' into devel-lkp-ib04-smoke-201411191439
> git bisect  bad c965f1fce4bc52abaaea95113a50c97b183b311e  # 19:39      0-     17  blktrace/tracing: Use trace_seq_has_overflowed() helper function
> git bisect good 8520dedbbf7578a397ecdfcf6ab83f775f914cfe  # 20:19     20+      0  tracing: kdb: Fix kernel livelock with empty buffers
> git bisect good a9ce7c36aa4256019180c590d60e2fad7431c749  # 20:43     20+      0  tracing: Fix race of function probes counting
> git bisect  bad f745f25c1f01464c376b7fe82e34db08ed22f321  # 21:06      0-      2  x86/kvm/tracing: Use helper function trace_seq_buffer_ptr()
> git bisect  bad 716c18f8e57c5eff4725f0b5acbdb2fead202d8c  # 21:23      0-     20  ftrace/x86/extable: Add is_ftrace_trampoline() function
> git bisect good 766d21c7953e3b02699183309d997b1c2cd9e0bb  # 22:32     20+      0  ftrace/x86: Add frames pointers to trampoline as necessary
> # first bad commit: [716c18f8e57c5eff4725f0b5acbdb2fead202d8c] ftrace/x86/extable: Add is_ftrace_trampoline() function
> git bisect good 766d21c7953e3b02699183309d997b1c2cd9e0bb  # 22:36     60+      0  ftrace/x86: Add frames pointers to trampoline as necessary
> git bisect  bad d165a751a05de3cd926f1378b0df3de3b7cab051  # 22:36      0-     16  0day head guard for 'devel-lkp-ib04-smoke-201411191439'
> git bisect good fc14f9c1272f62c3e8d01300f52467c0d9af50f9  # 22:39     60+      2  Linux 3.18-rc5
> git bisect good fad15b648058ee5ea4b352888afa9030e0092f1b  # 23:18     60+      0  Add linux-next specific files for 20141118
> 
> 
> This script may reproduce the error.
> 
> ----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> initrd=yocto-minimal-x86_64.cgz
> 
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
> 
> kvm=(
> 	qemu-system-x86_64
> 	-cpu kvm64
> 	-enable-kvm
> 	-kernel $kernel
> 	-initrd $initrd
> 	-m 320
> 	-smp 1
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-rtc base=localtime
> 	-serial stdio
> 	-display none
> 	-monitor null 
> )
> 
> append=(
> 	hung_task_panic=1
> 	earlyprintk=ttyS0,115200
> 	debug
> 	apic=debug
> 	sysrq_always_enabled
> 	rcupdate.rcu_cpu_stall_timeout=100
> 	panic=-1
> 	softlockup_panic=1
> 	nmi_watchdog=panic
> 	oops=panic
> 	load_ramdisk=2
> 	prompt_ramdisk=0
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> 	drbd.minor_count=8
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
> 
> Thanks,
> Fengguang

