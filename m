Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750885AbaCXEGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 00:06:34 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34722 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaCXEGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 00:06:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140324020712.GA8878@localhost>
References: <20140310024559.GC9322@localhost>
	<20140324020712.GA8878@localhost>
Date: Sun, 23 Mar 2014 22:06:32 -0600
X-Google-Sender-Auth: 9CyYxNtoaJ6GtYCTxjU2vgqIGGU
Message-ID: <CAGXu5jJCJ9jZwHjHrTzSwTM+ZW=tskq9Qj9Oga5zas1N7wUwkg@mail.gmail.com>
Subject: Re: [x86, kaslr] INFO: possible circular locking dependency detected
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Andy Honig <ahonig@google.com>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathias Krause <minipli@googlemail.com>, Tejun Heo <tj@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 8:07 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Kees,
>
> FYI, the problem is still in linux-next, first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/kaslr
> commit e2b32e6785138d92d2a40e0d0473575c8c7310a2
> Author:     Kees Cook <keescook@chromium.org>
> AuthorDate: Tue Feb 25 16:59:17 2014 -0800
> Commit:     H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue Feb 25 17:07:26 2014 -0800
>
>     x86, kaslr: randomize module base load address

Peter, can you take the patch that was sent to fix this?

https://lkml.org/lkml/2014/3/10/531

-Kees

>
>
> +----------------------------------------------------------+-----------+------------+---------------+
> |                                                          | v3.14-rc4 | e2b32e6785 | next-20140321 |
> +----------------------------------------------------------+-----------+------------+---------------+
> | boot_successes                                           | 589       | 53         | 5             |
> | boot_failures                                            | 11        | 147        | 14            |
> | BUG:unable_to_handle_kernel_paging_request               | 8         | 3          |               |
> | BUG:kernel_boot_crashed                                  | 1         |            |               |
> | BUG:kernel_boot_hang                                     | 2         | 4          |               |
> | WARNING:CPU:PID:at_mm/page_alloc.c:free_area_init_node() | 3         |            |               |
> | Oops:SMP_DEBUG_PAGEALLOC                                 | 3         | 1          |               |
> | EIP_is_at_strnlen                                        | 3         |            |               |
> | Kernel_panic-not_syncing:Fatal_exception                 | 3         | 1          |               |
> | backtrace:free_area_init_node                            | 3         |            |               |
> | backtrace:warn_slowpath_null                             | 3         |            |               |
> | backtrace:free_area_init_nodes                           | 3         |            |               |
> | backtrace:zone_sizes_init                                | 3         |            |               |
> | backtrace:paging_init                                    | 3         |            |               |
> | backtrace:native_pagetable_init                          | 3         |            |               |
> | backtrace:printk                                         | 3         |            |               |
> | INFO:possible_circular_locking_dependency_detected       | 0         | 139        | 11            |
> | backtrace:register_kprobe                                | 0         | 139        | 11            |
> | backtrace:init_test_probes                               | 0         | 139        | 11            |
> | backtrace:init_kprobes                                   | 0         | 139        | 11            |
> | backtrace:kernel_init_freeable                           | 0         | 140        | 11            |
> | backtrace:kprobe_optimizer                               | 0         | 139        | 11            |
> | BUG:soft_lockup-CPU_stuck_for_s                          | 0         | 1          |               |
> | EIP_is_at_raw_write_unlock_irq                           | 0         | 1          |               |
> | Kernel_panic-not_syncing:softlockup:hung_tasks           | 0         | 1          |               |
> | backtrace:cryptomgr_test                                 | 0         | 1          |               |
> | EIP_is_at__change_page_attr_set_clr                      | 0         | 1          |               |
> | backtrace:set_memory_np                                  | 0         | 1          |               |
> | backtrace:free_init_pages                                | 0         | 1          |               |
> | backtrace:populate_rootfs                                | 0         | 1          |               |
> | BUG:Int_CR2(null)                                        | 0         | 1          |               |
> | backtrace:kvm_get_tsc_khz                                | 0         | 1          |               |
> | backtrace:kvmclock_init                                  | 0         | 1          |               |
> | INFO:suspicious_RCU_usage                                | 0         | 0          | 3             |
> | INFO:rcu_sched_detected_stalls_on_CPUs/tasks             | 0         | 0          | 10            |
> | INFO:task_blocked_for_more_than_seconds                  | 0         | 0          | 14            |
> | INFO:lockdep_is_turned_off                               | 0         | 0          | 14            |
> | EIP_is_at_native_safe_halt                               | 0         | 0          | 14            |
> | EIP_is_at_default_send_IPI_mask_logical                  | 0         | 0          | 14            |
> | Kernel_panic-not_syncing:hung_task:blocked_tasks         | 0         | 0          | 14            |
> | backtrace:do_fork                                        | 0         | 0          | 3             |
> | backtrace:SyS_clone                                      | 0         | 0          | 3             |
> | backtrace:vfs_read                                       | 0         | 0          | 2             |
> | backtrace:SyS_read                                       | 0         | 0          | 2             |
> | backtrace:cpu_startup_entry                              | 0         | 0          | 14            |
> | backtrace:watchdog                                       | 0         | 0          | 14            |
> | backtrace:register_kretprobes                            | 0         | 0          | 11            |
> | backtrace:vfs_write                                      | 0         | 0          | 1             |
> | backtrace:SyS_write                                      | 0         | 0          | 1             |
> +----------------------------------------------------------+-----------+------------+---------------+
>
> [    5.027064] Kprobe smoke test started
> [    5.123444]
> [    5.124372] ======================================================
> [    5.125977] [ INFO: possible circular locking dependency detected ]
> [    5.126685] 3.14.0-rc7-next-20140321 #16 Not tainted
> [    5.126685] -------------------------------------------------------
> [    5.126685] kworker/1:1/26 is trying to acquire lock:
> [    5.126685]  (text_mutex){+.+.+.}, at: [<d197e40d>] kprobe_optimizer+0x270/0x448
> [    5.126685]
> [    5.126685] but task is already holding lock:
> [    5.126685]  (module_mutex){+.+...}, at: [<d197e1d7>] kprobe_optimizer+0x3a/0x448
> [    5.126685]
> [    5.126685] which lock already depends on the new lock.
> [    5.126685]
> [    5.126685]
> [    5.126685] the existing dependency chain (in reverse order) is:
> [    5.126685]
> -> #2 (module_mutex){+.+...}:
> [    5.126685]        [<d1103e6b>] __lock_acquire+0x226c/0x29cc
> [    5.126685]        [<d11046b3>] lock_acquire+0xe8/0x149
> [    5.126685]        [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
> [    5.126685]        [<d105f26b>] module_alloc+0xa0/0x153
> [    5.126685]        [<d1167e7f>] alloc_insn_page+0x1b/0x2b
> [    5.126685]        [<d197fd32>] __get_insn_slot+0x1ff/0x2a8
> [    5.126685]        [<d197a3f7>] arch_prepare_kprobe+0x7b/0x1b4
> [    5.126685]        [<d1981d33>] register_kprobe+0x89b/0xb1f
> [    5.126685]        [<d116520f>] init_test_probes+0x8c/0x8ed
> [    5.126685]        [<d1f3ceaa>] init_kprobes+0x260/0x288
> [    5.126685]        [<d10021e2>] do_one_initcall+0x133/0x2b2
> [    5.126685]        [<d1f09aee>] kernel_init_freeable+0x483/0x5ff
> [    5.126685]        [<d1955732>] kernel_init+0x16/0x1fa
> [    5.126685]        [<d1982d61>] ret_from_kernel_thread+0x21/0x30
> [    5.126685]
> -> #1 (kprobe_insn_slots.mutex){+.+.+.}:
> [    5.126685]        [<d1103e6b>] __lock_acquire+0x226c/0x29cc
> [    5.126685]        [<d11046b3>] lock_acquire+0xe8/0x149
> [    5.126685]        [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
> [    5.126685]        [<d197fb56>] __get_insn_slot+0x23/0x2a8
> [    5.126685]        [<d197a3f7>] arch_prepare_kprobe+0x7b/0x1b4
> [    5.126685]        [<d1981d33>] register_kprobe+0x89b/0xb1f
> [    5.126685]        [<d116520f>] init_test_probes+0x8c/0x8ed
> [    5.126685]        [<d1f3ceaa>] init_kprobes+0x260/0x288
> [    5.126685]        [<d10021e2>] do_one_initcall+0x133/0x2b2
> [    5.126685]        [<d1f09aee>] kernel_init_freeable+0x483/0x5ff
> [    5.126685]        [<d1955732>] kernel_init+0x16/0x1fa
> [    5.126685]        [<d1982d61>] ret_from_kernel_thread+0x21/0x30
> [    5.126685]
> -> #0 (text_mutex){+.+.+.}:
> [    5.126685]        [<d11003c1>] check_prev_add+0x1ac/0xb33
> [    5.126685]        [<d1103e6b>] __lock_acquire+0x226c/0x29cc
> [    5.126685]        [<d11046b3>] lock_acquire+0xe8/0x149
> [    5.126685]        [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
> [    5.126685]        [<d197e40d>] kprobe_optimizer+0x270/0x448
> [    5.126685]        [<d10ad1ae>] process_one_work+0x3a4/0x6a8
> [    5.126685]        [<d10af44e>] worker_thread+0x349/0x5dd
> [    5.126685]        [<d10bab6e>] kthread+0x13f/0x152
> [    5.126685]        [<d1982d61>] ret_from_kernel_thread+0x21/0x30
> [    5.126685]
> [    5.126685] other info that might help us debug this:
> [    5.126685]
> [    5.126685] Chain exists of:
>   text_mutex --> kprobe_insn_slots.mutex --> module_mutex
>
> [    5.126685]  Possible unsafe locking scenario:
> [    5.126685]
> [    5.126685]        CPU0                    CPU1
> [    5.126685]        ----                    ----
> [    5.126685]   lock(module_mutex);
> [    5.126685]                                lock(kprobe_insn_slots.mutex);
> [    5.126685]                                lock(module_mutex);
> [    5.126685]   lock(text_mutex);
> [    5.126685]
> [    5.126685]  *** DEADLOCK ***
> [    5.126685]
> [    5.126685] 5 locks held by kworker/1:1/26:
> [    5.126685]  #0:  ("events"){.+.+..}, at: [<d10ad11d>] process_one_work+0x313/0x6a8
> [    5.126685]  #1:  ((optimizing_work).work){+.+...}, at: [<d10ad11d>] process_one_work+0x313/0x6a8
> [    5.126685]  #2:  (kprobe_mutex){+.+.+.}, at: [<d197e1bd>] kprobe_optimizer+0x20/0x448
> [    5.126685]  #3:  (module_mutex){+.+...}, at: [<d197e1d7>] kprobe_optimizer+0x3a/0x448
> [    5.126685]  #4:  (cpu_hotplug.lock){++++++}, at: [<d1080552>] get_online_cpus+0x51/0xc3
> [    5.126685]
> [    5.126685] stack backtrace:
> [    5.126685] CPU: 1 PID: 26 Comm: kworker/1:1 Not tainted 3.14.0-rc7-next-20140321 #16
> [    5.126685] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    5.126685] Workqueue: events kprobe_optimizer
> [    5.126685]  d35a15c0 d2c5dd74 d1966a95 d229b38c d2c5dda4 d195f07e d1c9d76f d1c9d521
> [    5.126685]  d1c9d4e9 d1c9d50a d1c9d4e9 d35a15c0 d2c5ddb8 d35a1a64 d35a1a94 d35a15c0
> [    5.126685]  d2c5dde8 d11003c1 d35a1a64 d35a1a7c d2492de4 d11001e5 00000009 d229b27c
> [    5.126685] Call Trace:
> [    5.126685]  [<d1966a95>] dump_stack+0xb8/0x108
> [    5.126685]  [<d195f07e>] print_circular_bug+0x5ec/0x638
> [    5.126685]  [<d11003c1>] check_prev_add+0x1ac/0xb33
> [    5.126685]  [<d11001e5>] ? check_irq_usage+0xf0/0x120
> [    5.126685]  [<d1103e6b>] ? __lock_acquire+0x226c/0x29cc
> [    5.126685]  [<d1103e6b>] __lock_acquire+0x226c/0x29cc
> [    5.126685]  [<d11046b3>] lock_acquire+0xe8/0x149
> [    5.126685]  [<d197e40d>] ? kprobe_optimizer+0x270/0x448
> [    5.126685]  [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
> [    5.126685]  [<d197e40d>] ? kprobe_optimizer+0x270/0x448
> [    5.126685]  [<d197363d>] ? mutex_unlock+0x16/0x26
> [    5.126685]  [<d10805b1>] ? get_online_cpus+0xb0/0xc3
> [    5.126685]  [<d197e40d>] kprobe_optimizer+0x270/0x448
> [    5.126685]  [<d10ad1ae>] process_one_work+0x3a4/0x6a8
> [    5.126685]  [<d10ad11d>] ? process_one_work+0x313/0x6a8
> [    5.126685]  [<d10af44e>] worker_thread+0x349/0x5dd
> [    5.126685]  [<d10af105>] ? manage_workers.isra.20+0x3fc/0x3fc
> [    5.126685]  [<d10bab6e>] kthread+0x13f/0x152
> [    5.126685]  [<d10c0000>] ? __hrtimer_start_range_ns+0x413/0x635
> [    5.126685]  [<d1982d61>] ret_from_kernel_thread+0x21/0x30
> [    5.126685]  [<d10baa2f>] ? kthread_stop+0x103/0x103
>
> git bisect start 3b55c3c0ec2eb3f163f15559f3962df717f53ccb v3.13 --
> git bisect good 3962dfbe22a8d65e4162354cc859440293d85524  # 16:55     27+      2  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
> git bisect good dcb99fd9b08cfe1afe426af4d8d3cbc429190f15  # 17:15     27+      0  Linux 3.14-rc7
> git bisect good 5a02b8848ab78148f442126c6c7e32553326c00d  # 17:38     27+      0  Merge remote-tracking branch 'thermal/next'
> git bisect good 1b89b74cc212e138793d688321f8424a96a1c534  # 18:04     27+      1  Merge remote-tracking branch 'dt-rh/for-next'
> git bisect  bad 6ecd774cc7ff8b15a950c827630b852c0dc48ab2  # 18:43     10-      1  Merge remote-tracking branch 'char-misc/char-misc-next'
> git bisect  bad d8be03aa8bf754fa0ec3a20885a2387e43a418fe  # 19:07     16-      7  Merge remote-tracking branch 'percpu/for-next'
> git bisect  bad 0e56c90c132b64427c8c55fd85003ec1f17dba6d  # 19:45     36-      4  Merge remote-tracking branch 'edac-amd/for-next'
> git bisect  bad 67ae3b36794de69d58e66fb50be0fa0d68574c17  # 20:12     29-      8  Merge remote-tracking branch 'tip/auto-latest'
> git bisect good e224ef010790d873c4672a408f442c08b901567f  # 20:50    200+      1  Merge remote-tracking branch 'spi/for-next'
> git bisect good a49712343611eb2aca50b2034910e8873b453118  # 21:15    200+      5  Merge branch 'perf/core'
> git bisect good 626bfe396b8bfe0c2c94fe44bc985103abfe4b6f  # 21:46    200+      2  Merge branch 'x86/apic'
> git bisect good 72a500453a77e0980c0c2b4ed9fe8b521e7ac523  # 22:25    200+      5  Merge branch 'x86/debug'
> git bisect  bad c519db7a10228d5f0d6baf3deaa2c869f8b57bb9  # 22:55     65-      7  Merge branch 'x86/kaslr'
> git bisect good 3db4cafdfd05717dc939780134e53023a3c1f15f  # 23:42    200+      9  x86/boot: Fix non-EFI build
> git bisect good 4fd69331ad227a4d8de26592d017b73e00caca9f  # 00:28    200+      4  Merge remote-tracking branch 'tip/x86/urgent' into efi-for-mingo
> git bisect good 4f72c11ae1f01bfc65faf7687b7fdab5ab5ed04a  # 01:04    200+      6  Merge branch 'x86/efi'
> git bisect good 9d90b2ca54ad8b0b9f3ff20e9a93fb07450b0fb1  # 01:54    200+      5  Merge branch 'x86/hash'
> git bisect good 564ce606924e378825118a95937d9b03a6f1d1bf  # 02:16    200+      4  Merge branch 'x86/iommu'
> git bisect  bad e2b32e6785138d92d2a40e0d0473575c8c7310a2  # 02:38      8-     13  x86, kaslr: randomize module base load address
> # first bad commit: [e2b32e6785138d92d2a40e0d0473575c8c7310a2] x86, kaslr: randomize module base load address
> git bisect good cfbf8d4857c26a8a307fb7cd258074c9dcd8c691  # 03:36    600+     11  Linux 3.14-rc4
> git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 03:36      0-     14  Add linux-next specific files for 20140321
> git bisect good 774868c7094d35b4518be3d0e654de000a5d11fc  # 04:29    600+     15  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 04:29      0-     14  Add linux-next specific files for 20140321
>
>
> It's very reproducible with this script:
>
> #!/bin/bash
>
> kernel=$1
> initrd=yocto-minimal-i386.cgz
>
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/yocto-minimal-i386.cgz
>
> kvm=(
>         qemu-system-x86_64 -cpu kvm64 -enable-kvm
>         -kernel $kernel
>         -initrd $initrd
>         -smp 2
>         -m 256M
>         -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
>         -net user,vlan=0
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -serial stdio
>         -display none
>         -monitor null
> )
>
> append=(
>         debug
>         sched_debug
>         apic=debug
>         ignore_loglevel
>         sysrq_always_enabled
>         panic=10
>         prompt_ramdisk=0
>         earlyprintk=ttyS0,115200
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw
> )
>
> "${kvm[@]}" --append "${append[*]}"
>
> Thanks,
> Fengguang



-- 
Kees Cook
Chrome OS Security
