Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbaCXCH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 22:07:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:28162 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaCXCHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 22:07:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,717,1389772800"; 
   d="log'?scan'208";a="498014993"
Date: Mon, 24 Mar 2014 10:07:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Andy Honig <ahonig@google.com>,
        linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathias Krause <minipli@googlemail.com>, Tejun Heo <tj@kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [x86, kaslr] INFO: possible circular locking dependency detected
Message-ID: <20140324020712.GA8878@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20140310024559.GC9322@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kees,

FYI, the problem is still in linux-next, first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/kaslr
commit e2b32e6785138d92d2a40e0d0473575c8c7310a2
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Tue Feb 25 16:59:17 2014 -0800
Commit:     H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue Feb 25 17:07:26 2014 -0800

    x86, kaslr: randomize module base load address
    

+----------------------------------------------------------+-----------+------------+---------------+
|                                                          | v3.14-rc4 | e2b32e6785 | next-20140321 |
+----------------------------------------------------------+-----------+------------+---------------+
| boot_successes                                           | 589       | 53         | 5             |
| boot_failures                                            | 11        | 147        | 14            |
| BUG:unable_to_handle_kernel_paging_request               | 8         | 3          |               |
| BUG:kernel_boot_crashed                                  | 1         |            |               |
| BUG:kernel_boot_hang                                     | 2         | 4          |               |
| WARNING:CPU:PID:at_mm/page_alloc.c:free_area_init_node() | 3         |            |               |
| Oops:SMP_DEBUG_PAGEALLOC                                 | 3         | 1          |               |
| EIP_is_at_strnlen                                        | 3         |            |               |
| Kernel_panic-not_syncing:Fatal_exception                 | 3         | 1          |               |
| backtrace:free_area_init_node                            | 3         |            |               |
| backtrace:warn_slowpath_null                             | 3         |            |               |
| backtrace:free_area_init_nodes                           | 3         |            |               |
| backtrace:zone_sizes_init                                | 3         |            |               |
| backtrace:paging_init                                    | 3         |            |               |
| backtrace:native_pagetable_init                          | 3         |            |               |
| backtrace:printk                                         | 3         |            |               |
| INFO:possible_circular_locking_dependency_detected       | 0         | 139        | 11            |
| backtrace:register_kprobe                                | 0         | 139        | 11            |
| backtrace:init_test_probes                               | 0         | 139        | 11            |
| backtrace:init_kprobes                                   | 0         | 139        | 11            |
| backtrace:kernel_init_freeable                           | 0         | 140        | 11            |
| backtrace:kprobe_optimizer                               | 0         | 139        | 11            |
| BUG:soft_lockup-CPU_stuck_for_s                          | 0         | 1          |               |
| EIP_is_at_raw_write_unlock_irq                           | 0         | 1          |               |
| Kernel_panic-not_syncing:softlockup:hung_tasks           | 0         | 1          |               |
| backtrace:cryptomgr_test                                 | 0         | 1          |               |
| EIP_is_at__change_page_attr_set_clr                      | 0         | 1          |               |
| backtrace:set_memory_np                                  | 0         | 1          |               |
| backtrace:free_init_pages                                | 0         | 1          |               |
| backtrace:populate_rootfs                                | 0         | 1          |               |
| BUG:Int_CR2(null)                                        | 0         | 1          |               |
| backtrace:kvm_get_tsc_khz                                | 0         | 1          |               |
| backtrace:kvmclock_init                                  | 0         | 1          |               |
| INFO:suspicious_RCU_usage                                | 0         | 0          | 3             |
| INFO:rcu_sched_detected_stalls_on_CPUs/tasks             | 0         | 0          | 10            |
| INFO:task_blocked_for_more_than_seconds                  | 0         | 0          | 14            |
| INFO:lockdep_is_turned_off                               | 0         | 0          | 14            |
| EIP_is_at_native_safe_halt                               | 0         | 0          | 14            |
| EIP_is_at_default_send_IPI_mask_logical                  | 0         | 0          | 14            |
| Kernel_panic-not_syncing:hung_task:blocked_tasks         | 0         | 0          | 14            |
| backtrace:do_fork                                        | 0         | 0          | 3             |
| backtrace:SyS_clone                                      | 0         | 0          | 3             |
| backtrace:vfs_read                                       | 0         | 0          | 2             |
| backtrace:SyS_read                                       | 0         | 0          | 2             |
| backtrace:cpu_startup_entry                              | 0         | 0          | 14            |
| backtrace:watchdog                                       | 0         | 0          | 14            |
| backtrace:register_kretprobes                            | 0         | 0          | 11            |
| backtrace:vfs_write                                      | 0         | 0          | 1             |
| backtrace:SyS_write                                      | 0         | 0          | 1             |
+----------------------------------------------------------+-----------+------------+---------------+

[    5.027064] Kprobe smoke test started
[    5.123444] 
[    5.124372] ======================================================
[    5.125977] [ INFO: possible circular locking dependency detected ]
[    5.126685] 3.14.0-rc7-next-20140321 #16 Not tainted
[    5.126685] -------------------------------------------------------
[    5.126685] kworker/1:1/26 is trying to acquire lock:
[    5.126685]  (text_mutex){+.+.+.}, at: [<d197e40d>] kprobe_optimizer+0x270/0x448
[    5.126685] 
[    5.126685] but task is already holding lock:
[    5.126685]  (module_mutex){+.+...}, at: [<d197e1d7>] kprobe_optimizer+0x3a/0x448
[    5.126685] 
[    5.126685] which lock already depends on the new lock.
[    5.126685] 
[    5.126685] 
[    5.126685] the existing dependency chain (in reverse order) is:
[    5.126685] 
-> #2 (module_mutex){+.+...}:
[    5.126685]        [<d1103e6b>] __lock_acquire+0x226c/0x29cc
[    5.126685]        [<d11046b3>] lock_acquire+0xe8/0x149
[    5.126685]        [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
[    5.126685]        [<d105f26b>] module_alloc+0xa0/0x153
[    5.126685]        [<d1167e7f>] alloc_insn_page+0x1b/0x2b
[    5.126685]        [<d197fd32>] __get_insn_slot+0x1ff/0x2a8
[    5.126685]        [<d197a3f7>] arch_prepare_kprobe+0x7b/0x1b4
[    5.126685]        [<d1981d33>] register_kprobe+0x89b/0xb1f
[    5.126685]        [<d116520f>] init_test_probes+0x8c/0x8ed
[    5.126685]        [<d1f3ceaa>] init_kprobes+0x260/0x288
[    5.126685]        [<d10021e2>] do_one_initcall+0x133/0x2b2
[    5.126685]        [<d1f09aee>] kernel_init_freeable+0x483/0x5ff
[    5.126685]        [<d1955732>] kernel_init+0x16/0x1fa
[    5.126685]        [<d1982d61>] ret_from_kernel_thread+0x21/0x30
[    5.126685] 
-> #1 (kprobe_insn_slots.mutex){+.+.+.}:
[    5.126685]        [<d1103e6b>] __lock_acquire+0x226c/0x29cc
[    5.126685]        [<d11046b3>] lock_acquire+0xe8/0x149
[    5.126685]        [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
[    5.126685]        [<d197fb56>] __get_insn_slot+0x23/0x2a8
[    5.126685]        [<d197a3f7>] arch_prepare_kprobe+0x7b/0x1b4
[    5.126685]        [<d1981d33>] register_kprobe+0x89b/0xb1f
[    5.126685]        [<d116520f>] init_test_probes+0x8c/0x8ed
[    5.126685]        [<d1f3ceaa>] init_kprobes+0x260/0x288
[    5.126685]        [<d10021e2>] do_one_initcall+0x133/0x2b2
[    5.126685]        [<d1f09aee>] kernel_init_freeable+0x483/0x5ff
[    5.126685]        [<d1955732>] kernel_init+0x16/0x1fa
[    5.126685]        [<d1982d61>] ret_from_kernel_thread+0x21/0x30
[    5.126685] 
-> #0 (text_mutex){+.+.+.}:
[    5.126685]        [<d11003c1>] check_prev_add+0x1ac/0xb33
[    5.126685]        [<d1103e6b>] __lock_acquire+0x226c/0x29cc
[    5.126685]        [<d11046b3>] lock_acquire+0xe8/0x149
[    5.126685]        [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
[    5.126685]        [<d197e40d>] kprobe_optimizer+0x270/0x448
[    5.126685]        [<d10ad1ae>] process_one_work+0x3a4/0x6a8
[    5.126685]        [<d10af44e>] worker_thread+0x349/0x5dd
[    5.126685]        [<d10bab6e>] kthread+0x13f/0x152
[    5.126685]        [<d1982d61>] ret_from_kernel_thread+0x21/0x30
[    5.126685] 
[    5.126685] other info that might help us debug this:
[    5.126685] 
[    5.126685] Chain exists of:
  text_mutex --> kprobe_insn_slots.mutex --> module_mutex

[    5.126685]  Possible unsafe locking scenario:
[    5.126685] 
[    5.126685]        CPU0                    CPU1
[    5.126685]        ----                    ----
[    5.126685]   lock(module_mutex);
[    5.126685]                                lock(kprobe_insn_slots.mutex);
[    5.126685]                                lock(module_mutex);
[    5.126685]   lock(text_mutex);
[    5.126685] 
[    5.126685]  *** DEADLOCK ***
[    5.126685] 
[    5.126685] 5 locks held by kworker/1:1/26:
[    5.126685]  #0:  ("events"){.+.+..}, at: [<d10ad11d>] process_one_work+0x313/0x6a8
[    5.126685]  #1:  ((optimizing_work).work){+.+...}, at: [<d10ad11d>] process_one_work+0x313/0x6a8
[    5.126685]  #2:  (kprobe_mutex){+.+.+.}, at: [<d197e1bd>] kprobe_optimizer+0x20/0x448
[    5.126685]  #3:  (module_mutex){+.+...}, at: [<d197e1d7>] kprobe_optimizer+0x3a/0x448
[    5.126685]  #4:  (cpu_hotplug.lock){++++++}, at: [<d1080552>] get_online_cpus+0x51/0xc3
[    5.126685] 
[    5.126685] stack backtrace:
[    5.126685] CPU: 1 PID: 26 Comm: kworker/1:1 Not tainted 3.14.0-rc7-next-20140321 #16
[    5.126685] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.126685] Workqueue: events kprobe_optimizer
[    5.126685]  d35a15c0 d2c5dd74 d1966a95 d229b38c d2c5dda4 d195f07e d1c9d76f d1c9d521
[    5.126685]  d1c9d4e9 d1c9d50a d1c9d4e9 d35a15c0 d2c5ddb8 d35a1a64 d35a1a94 d35a15c0
[    5.126685]  d2c5dde8 d11003c1 d35a1a64 d35a1a7c d2492de4 d11001e5 00000009 d229b27c
[    5.126685] Call Trace:
[    5.126685]  [<d1966a95>] dump_stack+0xb8/0x108
[    5.126685]  [<d195f07e>] print_circular_bug+0x5ec/0x638
[    5.126685]  [<d11003c1>] check_prev_add+0x1ac/0xb33
[    5.126685]  [<d11001e5>] ? check_irq_usage+0xf0/0x120
[    5.126685]  [<d1103e6b>] ? __lock_acquire+0x226c/0x29cc
[    5.126685]  [<d1103e6b>] __lock_acquire+0x226c/0x29cc
[    5.126685]  [<d11046b3>] lock_acquire+0xe8/0x149
[    5.126685]  [<d197e40d>] ? kprobe_optimizer+0x270/0x448
[    5.126685]  [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
[    5.126685]  [<d197e40d>] ? kprobe_optimizer+0x270/0x448
[    5.126685]  [<d197363d>] ? mutex_unlock+0x16/0x26
[    5.126685]  [<d10805b1>] ? get_online_cpus+0xb0/0xc3
[    5.126685]  [<d197e40d>] kprobe_optimizer+0x270/0x448
[    5.126685]  [<d10ad1ae>] process_one_work+0x3a4/0x6a8
[    5.126685]  [<d10ad11d>] ? process_one_work+0x313/0x6a8
[    5.126685]  [<d10af44e>] worker_thread+0x349/0x5dd
[    5.126685]  [<d10af105>] ? manage_workers.isra.20+0x3fc/0x3fc
[    5.126685]  [<d10bab6e>] kthread+0x13f/0x152
[    5.126685]  [<d10c0000>] ? __hrtimer_start_range_ns+0x413/0x635
[    5.126685]  [<d1982d61>] ret_from_kernel_thread+0x21/0x30
[    5.126685]  [<d10baa2f>] ? kthread_stop+0x103/0x103

git bisect start 3b55c3c0ec2eb3f163f15559f3962df717f53ccb v3.13 --
git bisect good 3962dfbe22a8d65e4162354cc859440293d85524  # 16:55     27+      2  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect good dcb99fd9b08cfe1afe426af4d8d3cbc429190f15  # 17:15     27+      0  Linux 3.14-rc7
git bisect good 5a02b8848ab78148f442126c6c7e32553326c00d  # 17:38     27+      0  Merge remote-tracking branch 'thermal/next'
git bisect good 1b89b74cc212e138793d688321f8424a96a1c534  # 18:04     27+      1  Merge remote-tracking branch 'dt-rh/for-next'
git bisect  bad 6ecd774cc7ff8b15a950c827630b852c0dc48ab2  # 18:43     10-      1  Merge remote-tracking branch 'char-misc/char-misc-next'
git bisect  bad d8be03aa8bf754fa0ec3a20885a2387e43a418fe  # 19:07     16-      7  Merge remote-tracking branch 'percpu/for-next'
git bisect  bad 0e56c90c132b64427c8c55fd85003ec1f17dba6d  # 19:45     36-      4  Merge remote-tracking branch 'edac-amd/for-next'
git bisect  bad 67ae3b36794de69d58e66fb50be0fa0d68574c17  # 20:12     29-      8  Merge remote-tracking branch 'tip/auto-latest'
git bisect good e224ef010790d873c4672a408f442c08b901567f  # 20:50    200+      1  Merge remote-tracking branch 'spi/for-next'
git bisect good a49712343611eb2aca50b2034910e8873b453118  # 21:15    200+      5  Merge branch 'perf/core'
git bisect good 626bfe396b8bfe0c2c94fe44bc985103abfe4b6f  # 21:46    200+      2  Merge branch 'x86/apic'
git bisect good 72a500453a77e0980c0c2b4ed9fe8b521e7ac523  # 22:25    200+      5  Merge branch 'x86/debug'
git bisect  bad c519db7a10228d5f0d6baf3deaa2c869f8b57bb9  # 22:55     65-      7  Merge branch 'x86/kaslr'
git bisect good 3db4cafdfd05717dc939780134e53023a3c1f15f  # 23:42    200+      9  x86/boot: Fix non-EFI build
git bisect good 4fd69331ad227a4d8de26592d017b73e00caca9f  # 00:28    200+      4  Merge remote-tracking branch 'tip/x86/urgent' into efi-for-mingo
git bisect good 4f72c11ae1f01bfc65faf7687b7fdab5ab5ed04a  # 01:04    200+      6  Merge branch 'x86/efi'
git bisect good 9d90b2ca54ad8b0b9f3ff20e9a93fb07450b0fb1  # 01:54    200+      5  Merge branch 'x86/hash'
git bisect good 564ce606924e378825118a95937d9b03a6f1d1bf  # 02:16    200+      4  Merge branch 'x86/iommu'
git bisect  bad e2b32e6785138d92d2a40e0d0473575c8c7310a2  # 02:38      8-     13  x86, kaslr: randomize module base load address
# first bad commit: [e2b32e6785138d92d2a40e0d0473575c8c7310a2] x86, kaslr: randomize module base load address
git bisect good cfbf8d4857c26a8a307fb7cd258074c9dcd8c691  # 03:36    600+     11  Linux 3.14-rc4
git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 03:36      0-     14  Add linux-next specific files for 20140321
git bisect good 774868c7094d35b4518be3d0e654de000a5d11fc  # 04:29    600+     15  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 04:29      0-     14  Add linux-next specific files for 20140321


It's very reproducible with this script:

#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/yocto-minimal-i386.cgz

kvm=(  
        qemu-system-x86_64 -cpu kvm64 -enable-kvm
        -kernel $kernel
        -initrd $initrd
        -smp 2
        -m 256M
        -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
        -net user,vlan=0
        -net nic,vlan=1,model=e1000
        -net user,vlan=1
        -boot order=nc
        -no-reboot
        -watchdog i6300esb
        -serial stdio
        -display none
        -monitor null
)

append=(
        debug
        sched_debug
        apic=debug
        ignore_loglevel
        sysrq_always_enabled
        panic=10
        prompt_ramdisk=0
        earlyprintk=ttyS0,115200
        console=ttyS0,115200
        console=tty0
        vga=normal
        root=/dev/ram0
        rw
)

"${kvm[@]}" --append "${append[*]}"

Thanks,
Fengguang

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-sb04-58:20140323155059:i386-randconfig-c4-03230733:3.14.0-rc7-next-20140321:16"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-next-20140321 (kbuild@cairo) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #16 SMP Sun Mar 23 07:44:25 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x12dfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x12981000, 0x12981fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x12982000, 0x12982fff] PGTABLE
[    0.000000] BRK [0x12983000, 0x12983fff] PGTABLE
[    0.000000] BRK [0x12984000, 0x12985fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ffc000-0x13ffdfff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000] max_low_pfn =3D 13ffe, highstart_pfn =3D 13ffe
[    0.000000] Low memory ends at vaddr d3ffe000
[    0.000000] High memory starts at vaddr d3ffe000
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffb001, primary cpu clock
[    0.000000] BRK [0x12986000, 0x12986fff] PGTABLE
[    0.000000] Node: 0, start_pfn: 1, end_pfn: 9f
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0=20
[    0.000000] Node: 0, start_pfn: 100, end_pfn: 13ffe
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000 10000=20
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat d3ffc000, node_mem_map d3=
8da028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @d3ca3000 s29312 r0 d23936 u53=
248
[    0.000000] pcpu-alloc: s29312 r0 d23936 u53248 alloc=3D13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13ca5e80
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81020
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-c4-03230733/next:ma=
ster/.vmlinuz-06ed26d1de59ce7cbbe68378b7e470be169750e5-20140323074615-7-lkp=
-sb04 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-c4-03230733=
/06ed26d1de59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next-20140321 =
drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 294032K/327280K available (9743K kernel code, 1453K =
rwdata, 4156K rodata, 772K init, 9320K bss, 33248K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff9fe000   ( 690 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xd1f08000 - 0xd1fc9000   ( 772 kB)
[    0.000000]       .data : 0xd1984022 - 0xd1f06500   (5641 kB)
[    0.000000]       .text : 0xd1000000 - 0xd1984022   (9744 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd3412000 soft=3Dd3414000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-next-20140321 (kbuild@cairo) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #16 SMP Sun Mar 23 07:44:25 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x12dfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x12981000, 0x12981fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x12982000, 0x12982fff] PGTABLE
[    0.000000] BRK [0x12983000, 0x12983fff] PGTABLE
[    0.000000] BRK [0x12984000, 0x12985fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ffc000-0x13ffdfff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000] max_low_pfn =3D 13ffe, highstart_pfn =3D 13ffe
[    0.000000] Low memory ends at vaddr d3ffe000
[    0.000000] High memory starts at vaddr d3ffe000
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffb001, primary cpu clock
[    0.000000] BRK [0x12986000, 0x12986fff] PGTABLE
[    0.000000] Node: 0, start_pfn: 1, end_pfn: 9f
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0=20
[    0.000000] Node: 0, start_pfn: 100, end_pfn: 13ffe
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000 10000=20
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat d3ffc000, node_mem_map d3=
8da028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @d3ca3000 s29312 r0 d23936 u53=
248
[    0.000000] pcpu-alloc: s29312 r0 d23936 u53248 alloc=3D13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13ca5e80
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81020
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-c4-03230733/next:ma=
ster/.vmlinuz-06ed26d1de59ce7cbbe68378b7e470be169750e5-20140323074615-7-lkp=
-sb04 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-c4-03230733=
/06ed26d1de59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next-20140321 =
drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 294032K/327280K available (9743K kernel code, 1453K =
rwdata, 4156K rodata, 772K init, 9320K bss, 33248K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff9fe000   ( 690 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xd1f08000 - 0xd1fc9000   ( 772 kB)
[    0.000000]       .data : 0xd1984022 - 0xd1f06500   (5641 kB)
[    0.000000]       .text : 0xd1000000 - 0xd1984022   (9744 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd3412000 soft=3Dd3414000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 12 of 12 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3092.516 MHz processor
[    0.009999] Calibrating delay loop (skipped) preset value.. 6187.74 Bogo=
MIPS (lpj=3D10308386)
[    0.010018] pid_max: default: 32768 minimum: 301
[    0.013526] ACPI: Core revision 20140214
[    0.150353] ACPI: All ACPI Tables successfully acquired
[    0.154651] Security Framework initialized
[    0.156684] Yama: becoming mindful.
[    0.160344] Mount-cache hash table entries: 512
[    0.167582] Initializing cgroup subsys debug
[    0.168887] Initializing cgroup subsys blkio
[    0.173375] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.173375] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.173375] tlb_flushall_shift: 6
[    0.180692] debug: unmapping init [mem 0xd1fc9000-0xd1fcefff]
[    0.194066] Getting VERSION: 50014
[    0.196691] Getting VERSION: 50014
[    0.200018] Getting ID: 0
[    0.203357] Getting ID: f000000
[    0.204539] Getting LVT0: 8700
[    0.205650] Getting LVT1: 8400
[    0.206686] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.210100] enabled ExtINT on CPU#0
[    0.212404] ENABLING IO-APIC IRQs
[    0.213349] init IO_APIC IRQs
[    0.216685]  apic 0 pin 0 not connected
[    0.218005] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.220063] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.223387] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.226733] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.230052] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.233393] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.235819] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.236736] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.240067] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.242465] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.243397] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.246723] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.250057] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.253391] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.256716] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.260053]  apic 0 pin 16 not connected
[    0.263342]  apic 0 pin 17 not connected
[    0.264537]  apic 0 pin 18 not connected
[    0.265740]  apic 0 pin 19 not connected
[    0.266676]  apic 0 pin 20 not connected
[    0.267868]  apic 0 pin 21 not connected
[    0.270011]  apic 0 pin 22 not connected
[    0.271212]  apic 0 pin 23 not connected
[    0.273498] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.275180] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.283343] Using local APIC timer interrupts.
[    0.283343] calibrating APIC timer ...
[    0.289999] ... lapic delta =3D 6230421
[    0.289999] ... PM-Timer delta =3D 356832
[    0.289999] ... PM-Timer result ok
[    0.289999] ..... delta 6230421
[    0.289999] ..... mult: 267594571
[    0.289999] ..... calibration result: 3322891
[    0.289999] ..... CPU clock speed is 3083.0571 MHz.
[    0.289999] ..... host bus clock speed is 996.3223 MHz.
[    0.290154] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.309311] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.311380] CPU 1 irqstacks, hard=3Dd34fc000 soft=3Dd34fe000
[    0.316692] x86: Booting SMP configuration:
[    0.319734] .... node  #0, CPUs:      #1
[    0.006666] Initializing CPU#1
[    0.009999] kvm-clock: cpu 1, msr 0:13ffb021, secondary cpu clock
[    0.009999] masked ExtINT on CPU#1
[    0.340040] x86: Booted up 1 node, 2 CPUs
[    0.341748] ----------------
[    0.342798] | NMI testsuite:
[    0.343341] --------------------
[    0.344430]   remote IPI:
[    0.346676] KVM setup async PF for cpu 1
[    0.348486] kvm-stealtime: cpu 1, msr 13cb2e80
[    0.360077]   ok  |
[    0.361060]    local IPI:  ok  |
[    0.380022] --------------------
[    0.381041] Good, all   2 testcases passed! |
[    0.382200] ---------------------------------
[    0.383343] smpboot: Total of 2 processors activated (12375.48 BogoMIPS)
[    0.393411] gcov: version magic: 0x3430382a
[    0.401049] evm: security.ima
[    0.402005] evm: security.capability
[    0.416173] regulator-dummy: no parameters
[    0.420493] NET: Registered protocol family 16
[    0.427933] cpuidle: using governor ladder
[    0.429122] cpuidle: using governor menu
[    0.430777] ACPI: bus type PCI registered
[    0.433632] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.435743] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.436676] PCI: Using configuration type 1 for base access
[    0.654223] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.656749] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.661515] ACPI: Added _OSI(Module Device)
[    0.663345] ACPI: Added _OSI(Processor Device)
[    0.666674] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.667808] ACPI: Added _OSI(Processor Aggregator Device)
[    0.880918] ACPI: Interpreter enabled
[    0.882436] ACPI: (supports S0 S5)
[    0.883343] ACPI: Using IOAPIC for interrupt routing
[    0.885436] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.375121] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.386790] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.388257] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.425246] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.438092] PCI host bridge to bus 0000:00
[    1.439351] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.440035] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.456719] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.458160] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.458261] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.473558] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.490707] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.516339] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.531731] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.540495] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.542945] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.550016] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.553346] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.567871] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.573770] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.580031] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.597202] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.623417] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.625987] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.648612] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.666666] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.691017] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.693811] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.718078] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.750953] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.752394] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.781771] pci_bus 0000:00: on NUMA node 0
[    1.831391] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.848739] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.884954] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.909385] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.912980] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.965970] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.975518] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.976687] vgaarb: loaded
[    1.977721] vgaarb: bridge control possible 0000:00:02.0
[    1.992309] ACPI: bus type USB registered
[    1.994682] usbcore: registered new interface driver usbfs
[    1.997388] usbcore: registered new interface driver hub
[    2.003763] usbcore: registered new device driver usb
[    2.008009] Linux video capture interface: v2.00
[    2.009620] pps_core: LinuxPPS API ver. 1 registered
[    2.010010] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    2.013533] PTP clock support registered
[    2.030181] PCI: Using ACPI for IRQ routing
[    2.033352] PCI: pci_cache_line_size set to 64 bytes
[    2.034949] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    2.036410] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    2.056972] Switched to clocksource kvm-clock
[    2.060804] FS-Cache: Loaded
[    2.062492] pnp: PnP ACPI init
[    2.063834] ACPI: bus type PNP registered
[    2.078403] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    2.081851] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.084119] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    2.087399] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.094813] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    2.101208] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.104418] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    2.110930] pnp 00:03: [dma 2]
[    2.113031] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.123483] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    2.127832] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.130977] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    2.134201] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.162976] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.177737] pnp: PnP ACPI: found 7 devices
[    2.179076] ACPI: bus type PNP unregistered
[    2.329607] PM-Timer running at invalid rate: 105% of normal - aborting.
[    2.331275] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.333671] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.338202] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.339860] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    2.345813] NET: Registered protocol family 1
[    2.347177] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.349609] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.351040] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.355696] pci 0000:00:02.0: Boot video device
[    2.357153] PCI: CLS 0 bytes, default 64
[    2.379711] Unpacking initramfs...
[    3.364819] debug: unmapping init [mem 0xd3cbd000-0xd3feffff]
[    3.417039] NatSemi SCx200 Driver
[    3.467373] Initializing RT-Tester: OK
[    3.474005] futex hash table entries: 512 (order: 3, 32768 bytes)
[    3.484806] Initialise system trusted keyring
[    4.383782] tsc: Refined TSC clocksource calibration: 3092.547 MHz
[    5.027064] Kprobe smoke test started
[    5.123444]=20
[    5.124372] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    5.125977] [ INFO: possible circular locking dependency detected ]
[    5.126685] 3.14.0-rc7-next-20140321 #16 Not tainted
[    5.126685] -------------------------------------------------------
[    5.126685] kworker/1:1/26 is trying to acquire lock:
[    5.126685]  (text_mutex){+.+.+.}, at: [<d197e40d>] kprobe_optimizer+0x2=
70/0x448
[    5.126685]=20
[    5.126685] but task is already holding lock:
[    5.126685]  (module_mutex){+.+...}, at: [<d197e1d7>] kprobe_optimizer+0=
x3a/0x448
[    5.126685]=20
[    5.126685] which lock already depends on the new lock.
[    5.126685]=20
[    5.126685]=20
[    5.126685] the existing dependency chain (in reverse order) is:
[    5.126685]=20
-> #2 (module_mutex){+.+...}:
[    5.126685]        [<d1103e6b>] __lock_acquire+0x226c/0x29cc
[    5.126685]        [<d11046b3>] lock_acquire+0xe8/0x149
[    5.126685]        [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
[    5.126685]        [<d105f26b>] module_alloc+0xa0/0x153
[    5.126685]        [<d1167e7f>] alloc_insn_page+0x1b/0x2b
[    5.126685]        [<d197fd32>] __get_insn_slot+0x1ff/0x2a8
[    5.126685]        [<d197a3f7>] arch_prepare_kprobe+0x7b/0x1b4
[    5.126685]        [<d1981d33>] register_kprobe+0x89b/0xb1f
[    5.126685]        [<d116520f>] init_test_probes+0x8c/0x8ed
[    5.126685]        [<d1f3ceaa>] init_kprobes+0x260/0x288
[    5.126685]        [<d10021e2>] do_one_initcall+0x133/0x2b2
[    5.126685]        [<d1f09aee>] kernel_init_freeable+0x483/0x5ff
[    5.126685]        [<d1955732>] kernel_init+0x16/0x1fa
[    5.126685]        [<d1982d61>] ret_from_kernel_thread+0x21/0x30
[    5.126685]=20
-> #1 (kprobe_insn_slots.mutex){+.+.+.}:
[    5.126685]        [<d1103e6b>] __lock_acquire+0x226c/0x29cc
[    5.126685]        [<d11046b3>] lock_acquire+0xe8/0x149
[    5.126685]        [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
[    5.126685]        [<d197fb56>] __get_insn_slot+0x23/0x2a8
[    5.126685]        [<d197a3f7>] arch_prepare_kprobe+0x7b/0x1b4
[    5.126685]        [<d1981d33>] register_kprobe+0x89b/0xb1f
[    5.126685]        [<d116520f>] init_test_probes+0x8c/0x8ed
[    5.126685]        [<d1f3ceaa>] init_kprobes+0x260/0x288
[    5.126685]        [<d10021e2>] do_one_initcall+0x133/0x2b2
[    5.126685]        [<d1f09aee>] kernel_init_freeable+0x483/0x5ff
[    5.126685]        [<d1955732>] kernel_init+0x16/0x1fa
[    5.126685]        [<d1982d61>] ret_from_kernel_thread+0x21/0x30
[    5.126685]=20
-> #0 (text_mutex){+.+.+.}:
[    5.126685]        [<d11003c1>] check_prev_add+0x1ac/0xb33
[    5.126685]        [<d1103e6b>] __lock_acquire+0x226c/0x29cc
[    5.126685]        [<d11046b3>] lock_acquire+0xe8/0x149
[    5.126685]        [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
[    5.126685]        [<d197e40d>] kprobe_optimizer+0x270/0x448
[    5.126685]        [<d10ad1ae>] process_one_work+0x3a4/0x6a8
[    5.126685]        [<d10af44e>] worker_thread+0x349/0x5dd
[    5.126685]        [<d10bab6e>] kthread+0x13f/0x152
[    5.126685]        [<d1982d61>] ret_from_kernel_thread+0x21/0x30
[    5.126685]=20
[    5.126685] other info that might help us debug this:
[    5.126685]=20
[    5.126685] Chain exists of:
  text_mutex --> kprobe_insn_slots.mutex --> module_mutex

[    5.126685]  Possible unsafe locking scenario:
[    5.126685]=20
[    5.126685]        CPU0                    CPU1
[    5.126685]        ----                    ----
[    5.126685]   lock(module_mutex);
[    5.126685]                                lock(kprobe_insn_slots.mutex);
[    5.126685]                                lock(module_mutex);
[    5.126685]   lock(text_mutex);
[    5.126685]=20
[    5.126685]  *** DEADLOCK ***
[    5.126685]=20
[    5.126685] 5 locks held by kworker/1:1/26:
[    5.126685]  #0:  ("events"){.+.+..}, at: [<d10ad11d>] process_one_work+=
0x313/0x6a8
[    5.126685]  #1:  ((optimizing_work).work){+.+...}, at: [<d10ad11d>] pro=
cess_one_work+0x313/0x6a8
[    5.126685]  #2:  (kprobe_mutex){+.+.+.}, at: [<d197e1bd>] kprobe_optimi=
zer+0x20/0x448
[    5.126685]  #3:  (module_mutex){+.+...}, at: [<d197e1d7>] kprobe_optimi=
zer+0x3a/0x448
[    5.126685]  #4:  (cpu_hotplug.lock){++++++}, at: [<d1080552>] get_onlin=
e_cpus+0x51/0xc3
[    5.126685]=20
[    5.126685] stack backtrace:
[    5.126685] CPU: 1 PID: 26 Comm: kworker/1:1 Not tainted 3.14.0-rc7-next=
-20140321 #16
[    5.126685] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.126685] Workqueue: events kprobe_optimizer
[    5.126685]  d35a15c0 d2c5dd74 d1966a95 d229b38c d2c5dda4 d195f07e d1c9d=
76f d1c9d521
[    5.126685]  d1c9d4e9 d1c9d50a d1c9d4e9 d35a15c0 d2c5ddb8 d35a1a64 d35a1=
a94 d35a15c0
[    5.126685]  d2c5dde8 d11003c1 d35a1a64 d35a1a7c d2492de4 d11001e5 00000=
009 d229b27c
[    5.126685] Call Trace:
[    5.126685]  [<d1966a95>] dump_stack+0xb8/0x108
[    5.126685]  [<d195f07e>] print_circular_bug+0x5ec/0x638
[    5.126685]  [<d11003c1>] check_prev_add+0x1ac/0xb33
[    5.126685]  [<d11001e5>] ? check_irq_usage+0xf0/0x120
[    5.126685]  [<d1103e6b>] ? __lock_acquire+0x226c/0x29cc
[    5.126685]  [<d1103e6b>] __lock_acquire+0x226c/0x29cc
[    5.126685]  [<d11046b3>] lock_acquire+0xe8/0x149
[    5.126685]  [<d197e40d>] ? kprobe_optimizer+0x270/0x448
[    5.126685]  [<d19701ca>] mutex_lock_nested+0x8d/0xa9e
[    5.126685]  [<d197e40d>] ? kprobe_optimizer+0x270/0x448
[    5.126685]  [<d197363d>] ? mutex_unlock+0x16/0x26
[    5.126685]  [<d10805b1>] ? get_online_cpus+0xb0/0xc3
[    5.126685]  [<d197e40d>] kprobe_optimizer+0x270/0x448
[    5.126685]  [<d10ad1ae>] process_one_work+0x3a4/0x6a8
[    5.126685]  [<d10ad11d>] ? process_one_work+0x313/0x6a8
[    5.126685]  [<d10af44e>] worker_thread+0x349/0x5dd
[    5.126685]  [<d10af105>] ? manage_workers.isra.20+0x3fc/0x3fc
[    5.126685]  [<d10bab6e>] kthread+0x13f/0x152
[    5.126685]  [<d10c0000>] ? __hrtimer_start_range_ns+0x413/0x635
[    5.126685]  [<d1982d61>] ret_from_kernel_thread+0x21/0x30
[    5.126685]  [<d10baa2f>] ? kthread_stop+0x103/0x103
[  110.470004] INFO: rcu_sched detected stalls on CPUs/tasks:
[  110.473326] INFO: Stall ended before state dump start
[  240.636755] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  240.638339]       Not tainted 3.14.0-rc7-next-20140321 #16
[  240.639732] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  240.642176] swapper/0       D d1fc7ac0     0     1      0 0x00000000
[  240.644044]  d34a3d94 00000046 d1fc7ac0 d1fc7ac0 d1ca4a15 d35a15c0 d34a8=
000 d229b16c
[  240.647170]  d224351c 00000000 00000001 000002f7 d34a8000 d1de421c d34a8=
000 d34a845c
[  240.653673]  d34a8000 00000000 d34a3d8c d1106215 00000007 00000006 d34a8=
000 d1970670
[  240.666839] Call Trace:
[  240.667871]  [<d1106215>] ? mark_held_locks+0x9e/0xda
[  240.669263]  [<d1970670>] ? mutex_lock_nested+0x533/0xa9e
[  240.677387]  [<d196c5e2>] schedule+0xf2/0x102
[  240.678650]  [<d196cb41>] schedule_preempt_disabled+0x2b/0x50
[  240.686888]  [<d19706c1>] mutex_lock_nested+0x584/0xa9e
[  240.688333]  [<d110663e>] ? trace_hardirqs_on+0x27/0x37
[  240.689658]  [<d19814f1>] register_kprobe+0x59/0xb1f
[  240.697694]  [<d11f23dd>] ? __kmalloc+0x1e6/0x2d9
[  240.699048]  [<d11f23dd>] ? __kmalloc+0x1e6/0x2d9
[  240.707022]  [<d198214c>] ? register_kretprobe+0x195/0x34d
[  240.708399]  [<d198214c>] ? register_kretprobe+0x195/0x34d
[  240.709751]  [<d1982250>] register_kretprobe+0x299/0x34d
[  240.717838]  [<d198234c>] register_kretprobes+0x48/0xad
[  240.719251]  [<d11658aa>] init_test_probes+0x727/0x8ed
[  240.727393]  [<d1f3ceaa>] init_kprobes+0x260/0x288
[  240.728654]  [<d1971044>] ? __mutex_unlock_slowpath+0x469/0x4e5
[  240.736910]  [<d1106519>] ? trace_hardirqs_on_caller+0x2c8/0x3c6
[  240.738363]  [<d1971044>] ? __mutex_unlock_slowpath+0x469/0x4e5
[  240.739844]  [<d1106519>] ? trace_hardirqs_on_caller+0x2c8/0x3c6
[  240.748113]  [<d110663e>] ? trace_hardirqs_on+0x27/0x37
[  240.749488]  [<d197363d>] ? mutex_unlock+0x16/0x26
[  240.757511]  [<d1f3cc4a>] ? gcov_fs_init+0x101/0x101
[  240.758852]  [<d10021e2>] do_one_initcall+0x133/0x2b2
[  240.766973]  [<d1f086bd>] ? repair_env_string+0x32/0xd3
[  240.768294]  [<d1f0868b>] ? do_early_param+0x126/0x126
[  240.769629]  [<d10b76e2>] ? parse_args+0x43a/0x635
[  240.777720]  [<d1f0868b>] ? do_early_param+0x126/0x126
[  240.779051]  [<d1f09aee>] kernel_init_freeable+0x483/0x5ff
[  240.787149]  [<d1f09aee>] ? kernel_init_freeable+0x483/0x5ff
[  240.788541]  [<d1955732>] kernel_init+0x16/0x1fa
[  240.789833]  [<d1982d61>] ret_from_kernel_thread+0x21/0x30
[  240.797978]  [<d195571c>] ? rest_init+0x282/0x282
[  240.799264] INFO: lockdep is turned off.
[  240.807195] sending NMI to all CPUs:
[  240.808360] NMI backtrace for cpu 0
[  240.809492] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc7-next-20=
140321 #16
[  240.809991] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  240.809991] task: d1da2e68 ti: d1d9c000 task.ti: d1d9c000
[  240.809991] EIP: 0060:[<d1065132>] EFLAGS: 00200246 CPU: 0
[  240.809991] EIP is at native_safe_halt+0x13/0x23
[  240.809991] EAX: d10211fe EBX: 00000000 ECX: d1da2e68 EDX: 00000000
[  240.809991] ESI: 00000000 EDI: d1d9c000 EBP: d1d9df8c ESP: d1d9df8c
[  240.809991]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  240.809991] CR0: 8005003b CR2: ffffffff CR3: 11fd2000 CR4: 000006b0
[  240.809991] Stack:
[  240.809991]  d1d9df94 d1021238 d1d9df9c d102205d d1d9dfc8 d10f4f13 d1d9d=
fb4 d1d9dfec
[  240.809991]  d1d9dfec 00020800 a6a98400 46914a7f 00000002 00020800 d1fd4=
800 d1d9dfd4
[  240.809991]  d1955709 00000000 d1d9dfe8 d1f09643 d1f830d0 7af9ca19 00000=
800 d1d9dff8
[  240.809991] Call Trace:
[  240.809991]  [<d1021238>] default_idle+0x50/0x61
[  240.809991]  [<d102205d>] arch_cpu_idle+0x17/0x27
[  240.809991]  [<d10f4f13>] cpu_startup_entry+0x64b/0x696
[  240.809991]  [<d1955709>] rest_init+0x26f/0x282
[  240.809991]  [<d1f09643>] start_kernel+0xaeb/0xb13
[  240.809991]  [<d1f0834e>] i386_start_kernel+0xe9/0xfb
[  240.809991] Code: 83 15 34 f8 00 d2 00 fb 83 05 38 f8 00 d2 01 83 15 3c =
f8 00 d2 00 5d c3 55 83 05 40 f8 00 d2 01 89 e5 83 15 44 f8 00 d2 00 fb f4 =
<83> 05 48 f8 00 d2 01 83 15 4c f8 00 d2 00 5d c3 55 83 05 50 f8
[  240.979102] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 170.709 msecs
[  240.810514] NMI backtrace for cpu 1
[  240.810514] CPU: 1 PID: 18 Comm: khungtaskd Not tainted 3.14.0-rc7-next-=
20140321 #16
[  240.810514] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  240.810514] task: d34f4c20 ti: d3572000 task.ti: d3572000
[  240.810514] EIP: 0060:[<d1059f6e>] EFLAGS: 00010046 CPU: 1
[  240.810514] EIP is at default_send_IPI_mask_logical+0x197/0x266
[  240.810514] EAX: fffff000 EBX: 00000c00 ECX: d34f4c20 EDX: fffff000
[  240.810514] ESI: 00000c00 EDI: 03000000 EBP: d3573ee8 ESP: d3573ed8
[  240.810514]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  240.810514] CR0: 8005003b CR2: 00000000 CR3: 11fd2000 CR4: 000006b0
[  240.810514] Stack:
[  240.810514]  00000246 d34a8000 d34a816c 000003ff d3573ef4 d105a139 d34a8=
000 d3573f04
[  240.810514]  d105a3e9 d1c9371e d34a8000 d3573f30 d11692cc 00000003 00007=
fff 00007fff
[  240.810514]  00000078 d34a8000 d34a816c d34e3750 00000000 d1168c1c d3573=
fac d10bab6e
[  240.810514] Call Trace:
[  240.810514]  [<d105a139>] default_send_IPI_all+0x2b/0xb0
[  240.810514]  [<d105a3e9>] arch_trigger_all_cpu_backtrace+0x7d/0x10d
[  240.810514]  [<d11692cc>] watchdog+0x6b0/0x9ef
[  240.810514]  [<d1168c1c>] ? reset_hung_task_detector+0x1d/0x1d
[  240.810514]  [<d10bab6e>] kthread+0x13f/0x152
[  240.810514]  [<d10c0000>] ? __hrtimer_start_range_ns+0x413/0x635
[  240.810514]  [<d1982d61>] ret_from_kernel_thread+0x21/0x30
[  240.810514]  [<d10baa2f>] ? kthread_stop+0x103/0x103
[  240.810514] Code: 46 00 d2 01 83 15 b4 46 00 d2 00 eb 13 80 cf 04 83 05 =
b8 46 00 d2 01 89 de 83 15 bc 46 00 d2 00 a1 d0 03 dc d1 89 b0 00 d3 ff ff =
<f7> 45 f0 00 02 00 00 75 61 83 3d 90 de db d1 00 75 1e 83 05 c8
[  240.980503] Kernel panic - not syncing: hung_task: blocked tasks
[  240.980506] CPU: 1 PID: 18 Comm: khungtaskd Not tainted 3.14.0-rc7-next-=
20140321 #16
[  240.980507] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  240.980513]  00000000 d3573ee8 d1966a95 d34a8000 d3573f00 d195d840 00000=
246 d34a8000
[  240.980518]  d34a816c 000003ff d3573f30 d11692e4 d1ca5143 00000003 00007=
fff 00007fff
[  240.980523]  00000078 d34a8000 d34a816c d34e3750 00000000 d1168c1c d3573=
fac d10bab6e
[  240.980524] Call Trace:
[  240.980527]  [<d1966a95>] dump_stack+0xb8/0x108
[  240.980531]  [<d195d840>] panic+0x165/0x3f3
[  240.980534]  [<d11692e4>] watchdog+0x6c8/0x9ef
[  240.980537]  [<d1168c1c>] ? reset_hung_task_detector+0x1d/0x1d
[  240.980539]  [<d10bab6e>] kthread+0x13f/0x152
[  240.980544]  [<d10c0000>] ? __hrtimer_start_range_ns+0x413/0x635
[  240.980548]  [<d1982d61>] ret_from_kernel_thread+0x21/0x30
[  240.980550]  [<d10baa2f>] ? kthread_stop+0x103/0x103
[  240.983808] Kernel Offset: 0x10000000 from 0xc1000000 (relocation range:=
 0xc0000000-0xd47fdfff)
[  240.983808] Rebooting in 10 seconds..
Elapsed time: 245
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
4-03230733/06ed26d1de59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next=
-20140321 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug api=
c=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/i386-randconfig-c4-03230733/next:master/.vmlinuz-0=
6ed26d1de59ce7cbbe68378b7e470be169750e5-20140323074615-7-lkp-sb04 branch=3D=
next/master BOOT_IMAGE=3D/kernel/i386-randconfig-c4-03230733/06ed26d1de59ce=
7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next-20140321 drbd.minor_coun=
t=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 320 -smp 2 -=
net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::57709-:22 =
-boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfi=
le /dev/shm/kboot/pid-yocto-lkp-sb04-58 -serial file:/dev/shm/kboot/serial-=
yocto-lkp-sb04-58 -daemonize -display none -monitor null=20

--nFreZHaLTZJo0R7j
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-c4-03230733-06ed26d1de59ce7cbbe68378b7e470be169750e5-INFO:-possible-circular-locking-dependency-detected-52519.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNC0w
MzIzMDczMy9uZXh0Om1hc3RlcjozYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3
ZjUzY2NiOmJpc2VjdC11c2IKCjIwMTQtMDMtMjMtMTU6MTk6MDMgM2I1NWMzYzBlYzJlYjNm
MTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3
MzMtM2I1NWMzYzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYgpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzNiNTVjM2Mw
ZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIz
MDczMy0zYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5k
Y29uZmlnLWM0LTAzMjMwNzMzLTNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdm
NTNjY2IKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy8zYjU1
YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL3ZtbGludXotMy4xNC4wLXJj
Ny0xMDcxMy1nM2I1NWMzYwoKMjAxNC0wMy0yMy0xNTo0NTowNCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuLi4uLgkyLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQpbICAgIDQuMTk1
NTE0XSBLcHJvYmUgc21va2UgdGVzdCBzdGFydGVkClsgICAgNC4yOTY3NTRdIApbICAgIDQu
Mjk3NjMyXSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KWyAgICA0LjI5OTI0NF0gWyBJTkZPOiBwb3NzaWJsZSBjaXJjdWxhciBsb2Nr
aW5nIGRlcGVuZGVuY3kgZGV0ZWN0ZWQgXQpbICAgIDQuMzAwMDIzXSAzLjE0LjAtcmM3LTEw
NzEzLWczYjU1YzNjICMxIE5vdCB0YWludGVkClsgICAgNC4zMDAwMjNdIC0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KWyAgICA0LjMw
MDAyM10ga3dvcmtlci8xOjEvMjUgaXMgdHJ5aW5nIHRvIGFjcXVpcmUgbG9jazoKWyAgICA0
LjMwMDAyM10gICh0ZXh0X211dGV4KXsrLisuKy59LCBhdDogWzxjZTM3OWYwNT5dIGtwcm9i
ZV9vcHRpbWl6ZXIrMHgyNzAvMHg0NDgKWyAgICA0LjMwMDAyM10gClsgICAgNC4zMDAwMjNd
IGJ1dCB0YXNrIGlzIGFscmVhZHkgaG9sZGluZyBsb2NrOgpbICAgIDQuMzAwMDIzXSAgKG1v
ZHVsZV9tdXRleCl7Ky4rLi4ufSwgYXQ6IFs8Y2UzNzljY2Y+XSBrcHJvYmVfb3B0aW1pemVy
KzB4M2EvMHg0NDgKWyAgICA0LjMwMDAyM10gClsgICAgNC4zMDAwMjNdIHdoaWNoIGxvY2sg
YWxyZWFkeSBkZXBlbmRzIG9uIHRoZSBuZXcgbG9jay4KWyAgICA0LjMwMDAyM10gClsgICAg
NC4zMDAwMjNdIApbICAgIDQuMzAwMDIzXSB0aGUgZXhpc3RpbmcgZGVwZW5kZW5jeSBjaGFp
biAoaW4gcmV2ZXJzZSBvcmRlcikgaXM6ClsgICAgNC4zMDAwMjNdIAotPiAjMiAobW9kdWxl
X211dGV4KXsrLisuLi59OgpbICAgIDQuMzAwMDIzXSAgICAgICAgWzxjZGIwNDYxYj5dIF9f
bG9ja19hY3F1aXJlKzB4MjI2Yy8weDI5Y2MKWyAgICA0LjMwMDAyM10gICAgICAgIFs8Y2Ri
MDRlNjM+XSBsb2NrX2FjcXVpcmUrMHhlOC8weDE0OQpbICAgIDQuMzAwMDIzXSAgICAgICAg
WzxjZTM2YmNjMj5dIG11dGV4X2xvY2tfbmVzdGVkKzB4OGQvMHhhOWUKWyAgICA0LjMwMDAy
M10gICAgICAgIFs8Y2RhNWYyNjU+XSBtb2R1bGVfYWxsb2MrMHhhMC8weDE1MwpbICAgIDQu
MzAwMDIzXSAgICAgICAgWzxjZGI2N2RkNz5dIGFsbG9jX2luc25fcGFnZSsweDFiLzB4MmIK
WyAgICA0LjMwMDAyM10gICAgICAgIFs8Y2UzN2I4MmE+XSBfX2dldF9pbnNuX3Nsb3QrMHgx
ZmYvMHgyYTgKWyAgICA0LjMwMDAyM10gICAgICAgIFs8Y2UzNzVlZWY+XSBhcmNoX3ByZXBh
cmVfa3Byb2JlKzB4N2IvMHgxYjQKWyAgICA0LjMwMDAyM10gICAgICAgIFs8Y2UzN2Q4MmI+
XSByZWdpc3Rlcl9rcHJvYmUrMHg4OWIvMHhiMWYKWyAgICA0LjMwMDAyM10gICAgICAgIFs8
Y2RiNjUxNjc+XSBpbml0X3Rlc3RfcHJvYmVzKzB4OGMvMHg4ZWQKWyAgICA0LjMwMDAyM10g
ICAgICAgIFs8Y2U5Mzc2NWM+XSBpbml0X2twcm9iZXMrMHgyNjAvMHgyODgKWyAgICA0LjMw
MDAyM10gICAgICAgIFs8Y2RhMDIxZTI+XSBkb19vbmVfaW5pdGNhbGwrMHgxMzMvMHgyYjIK
WyAgICA0LjMwMDAyM10gICAgICAgIFs8Y2U5MDNhZWU+XSBrZXJuZWxfaW5pdF9mcmVlYWJs
ZSsweDQ4My8weDVmZgpbICAgIDQuMzAwMDIzXSAgICAgICAgWzxjZTM1MTIzOT5dIGtlcm5l
bF9pbml0KzB4MTYvMHgxZmEKWyAgICA0LjMwMDAyM10gICAgICAgIFs8Y2UzN2U4NjE+XSBy
ZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjEvMHgzMApbICAgIDQuMzAwMDIzXSAKLT4gIzEg
KGtwcm9iZV9pbnNuX3Nsb3RzLm11dGV4KXsrLisuKy59OgpbICAgIDQuMzAwMDIzXSAgICAg
ICAgWzxjZGIwNDYxYj5dIF9fbG9ja19hY3F1aXJlKzB4MjI2Yy8weDI5Y2MKWyAgICA0LjMw
MDAyM10gICAgICAgIFs8Y2RiMDRlNjM+XSBsb2NrX2FjcXVpcmUrMHhlOC8weDE0OQpbICAg
IDQuMzAwMDIzXSAgICAgICAgWzxjZTM2YmNjMj5dIG11dGV4X2xvY2tfbmVzdGVkKzB4OGQv
MHhhOWUKWyAgICA0LjMwMDAyM10gICAgICAgIFs8Y2UzN2I2NGU+XSBfX2dldF9pbnNuX3Ns
b3QrMHgyMy8weDJhOApbICAgIDQuMzAwMDIzXSAgICAgICAgWzxjZTM3NWVlZj5dIGFyY2hf
cHJlcGFyZV9rcHJvYmUrMHg3Yi8weDFiNApbICAgIDQuMzAwMDIzXSAgICAgICAgWzxjZTM3
ZDgyYj5dIHJlZ2lzdGVyX2twcm9iZSsweDg5Yi8weGIxZgpbICAgIDQuMzAwMDIzXSAgICAg
ICAgWzxjZGI2NTE2Nz5dIGluaXRfdGVzdF9wcm9iZXMrMHg4Yy8weDhlZApbICAgIDQuMzAw
MDIzXSAgICAgICAgWzxjZTkzNzY1Yz5dIGluaXRfa3Byb2JlcysweDI2MC8weDI4OApbICAg
IDQuMzAwMDIzXSAgICAgICAgWzxjZGEwMjFlMj5dIGRvX29uZV9pbml0Y2FsbCsweDEzMy8w
eDJiMgpbICAgIDQuMzAwMDIzXSAgICAgICAgWzxjZTkwM2FlZT5dIGtlcm5lbF9pbml0X2Zy
ZWVhYmxlKzB4NDgzLzB4NWZmClsgICAgNC4zMDAwMjNdICAgICAgICBbPGNlMzUxMjM5Pl0g
a2VybmVsX2luaXQrMHgxNi8weDFmYQpbICAgIDQuMzAwMDIzXSAgICAgICAgWzxjZTM3ZTg2
MT5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMS8weDMwClsgICAgNC4zMDAwMjNdIAot
PiAjMCAodGV4dF9tdXRleCl7Ky4rLisufToKWyAgICA0LjMwMDAyM10gICAgICAgIFs8Y2Ri
MDBiNzE+XSBjaGVja19wcmV2X2FkZCsweDFhYy8weGIzMwpbICAgIDQuMzAwMDIzXSAgICAg
ICAgWzxjZGIwNDYxYj5dIF9fbG9ja19hY3F1aXJlKzB4MjI2Yy8weDI5Y2MKWyAgICA0LjMw
MDAyM10gICAgICAgIFs8Y2RiMDRlNjM+XSBsb2NrX2FjcXVpcmUrMHhlOC8weDE0OQpbICAg
IDQuMzAwMDIzXSAgICAgICAgWzxjZTM2YmNjMj5dIG11dGV4X2xvY2tfbmVzdGVkKzB4OGQv
MHhhOWUKWyAgICA0LjMwMDAyM10gICAgICAgIFs8Y2UzNzlmMDU+XSBrcHJvYmVfb3B0aW1p
emVyKzB4MjcwLzB4NDQ4ClsgICAgNC4zMDAwMjNdICAgICAgICBbPGNkYWFkMTAzPl0gcHJv
Y2Vzc19vbmVfd29yaysweDNhNC8weDZhOApbICAgIDQuMzAwMDIzXSAgICAgICAgWzxjZGFh
ZjNhMz5dIHdvcmtlcl90aHJlYWQrMHgzNDkvMHg1ZGQKWyAgICA0LjMwMDAyM10gICAgICAg
IFs8Y2RhYmFhYWU+XSBrdGhyZWFkKzB4MTNmLzB4MTUyClsgICAgNC4zMDAwMjNdICAgICAg
ICBbPGNlMzdlODYxPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIxLzB4MzAKWyAgICA0
LjMwMDAyM10gClsgICAgNC4zMDAwMjNdIG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVz
IGRlYnVnIHRoaXM6ClsgICAgNC4zMDAwMjNdIApbICAgIDQuMzAwMDIzXSBDaGFpbiBleGlz
dHMgb2Y6CiAgdGV4dF9tdXRleCAtLT4ga3Byb2JlX2luc25fc2xvdHMubXV0ZXggLS0+IG1v
ZHVsZV9tdXRleAoKWyAgICA0LjMwMDAyM10gIFBvc3NpYmxlIHVuc2FmZSBsb2NraW5nIHNj
ZW5hcmlvOgpbICAgIDQuMzAwMDIzXSAKWyAgICA0LjMwMDAyM10gICAgICAgIENQVTAgICAg
ICAgICAgICAgICAgICAgIENQVTEKWyAgICA0LjMwMDAyM10gICAgICAgIC0tLS0gICAgICAg
ICAgICAgICAgICAgIC0tLS0KWyAgICA0LjMwMDAyM10gICBsb2NrKG1vZHVsZV9tdXRleCk7
ClsgICAgNC4zMDAwMjNdICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb2NrKGtw
cm9iZV9pbnNuX3Nsb3RzLm11dGV4KTsKWyAgICA0LjMwMDAyM10gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGxvY2sobW9kdWxlX211dGV4KTsKWyAgICA0LjMwMDAyM10gICBs
b2NrKHRleHRfbXV0ZXgpOwpbICAgIDQuMzAwMDIzXSAKWyAgICA0LjMwMDAyM10gICoqKiBE
RUFETE9DSyAqKioKWyAgICA0LjMwMDAyM10gClsgICAgNC4zMDAwMjNdIDUgbG9ja3MgaGVs
ZCBieSBrd29ya2VyLzE6MS8yNToKWyAgICA0LjMwMDAyM10gICMwOiAgKCJldmVudHMiKXsu
Ky4rLi59LCBhdDogWzxjZGFhZDA3Mj5dIHByb2Nlc3Nfb25lX3dvcmsrMHgzMTMvMHg2YTgK
WyAgICA0LjMwMDAyM10gICMxOiAgKChvcHRpbWl6aW5nX3dvcmspLndvcmspeysuKy4uLn0s
IGF0OiBbPGNkYWFkMDcyPl0gcHJvY2Vzc19vbmVfd29yaysweDMxMy8weDZhOApbICAgIDQu
MzAwMDIzXSAgIzI6ICAoa3Byb2JlX211dGV4KXsrLisuKy59LCBhdDogWzxjZTM3OWNiNT5d
IGtwcm9iZV9vcHRpbWl6ZXIrMHgyMC8weDQ0OApbICAgIDQuMzAwMDIzXSAgIzM6ICAobW9k
dWxlX211dGV4KXsrLisuLi59LCBhdDogWzxjZTM3OWNjZj5dIGtwcm9iZV9vcHRpbWl6ZXIr
MHgzYS8weDQ0OApbICAgIDQuMzAwMDIzXSAgIzQ6ICAoY3B1X2hvdHBsdWcubG9jayl7Kysr
KysrfSwgYXQ6IFs8Y2RhODA1NDU+XSBnZXRfb25saW5lX2NwdXMrMHg1MS8weGMzClsgICAg
NC4zMDAwMjNdIApbICAgIDQuMzAwMDIzXSBzdGFjayBiYWNrdHJhY2U6ClsgICAgNC4zMDAw
MjNdIENQVTogMSBQSUQ6IDI1IENvbW06IGt3b3JrZXIvMToxIE5vdCB0YWludGVkIDMuMTQu
MC1yYzctMTA3MTMtZzNiNTVjM2MgIzEKWyAgICA0LjMwMDAyM10gSGFyZHdhcmUgbmFtZTog
Qm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDQuMzAwMDIzXSBXb3Jr
cXVldWU6IGV2ZW50cyBrcHJvYmVfb3B0aW1pemVyClsgICAgNC4zMDAwMjNdICBkMWU1ZTE1
MCBkMTAwZGQ3NCBjZTM2MjU5MCBjZWM5NTJiYyBkMTAwZGRhNCBjZTM1YWI2NCBjZTY5ODk0
NCBjZTY5ODZmNgpbICAgIDQuMzAwMDIzXSAgY2U2OTg2YmUgY2U2OTg2ZGYgY2U2OTg2YmUg
ZDFlNWUxNTAgZDEwMGRkYjggZDFlNWU1ZTAgZDFlNWU2MTAgZDFlNWUxNTAKWyAgICA0LjMw
MDAyM10gIGQxMDBkZGU4IGNkYjAwYjcxIGQxZTVlNWUwIGQxZTVlNWY4IGNlZThjZjk0IGNk
YjAwOTk1IDAwMDAwMDA5IGNlYzk1MWFjClsgICAgNC4zMDAwMjNdIENhbGwgVHJhY2U6Clsg
ICAgNC4zMDAwMjNdICBbPGNlMzYyNTkwPl0gZHVtcF9zdGFjaysweGI4LzB4MTA4ClsgICAg
NC4zMDAwMjNdICBbPGNlMzVhYjY0Pl0gcHJpbnRfY2lyY3VsYXJfYnVnKzB4NWVjLzB4NjM4
ClsgICAgNC4zMDAwMjNdICBbPGNkYjAwYjcxPl0gY2hlY2tfcHJldl9hZGQrMHgxYWMvMHhi
MzMKWyAgICA0LjMwMDAyM10gIFs8Y2RiMDA5OTU+XSA/IGNoZWNrX2lycV91c2FnZSsweGYw
LzB4MTIwClsgICAgNC4zMDAwMjNdICBbPGNkYjA0NjFiPl0gPyBfX2xvY2tfYWNxdWlyZSsw
eDIyNmMvMHgyOWNjClsgICAgNC40NDAxNDVdIHRzYzogUmVmaW5lZCBUU0MgY2xvY2tzb3Vy
Y2UgY2FsaWJyYXRpb246IDI0OTMuOTkxIE1IegpbICAgIDQuMzAwMDIzXSAgWzxjZGIwNDYx
Yj5dIF9fbG9ja19hY3F1aXJlKzB4MjI2Yy8weDI5Y2MKWyAgICA0LjMwMDAyM10gIFs8Y2Ri
MDRlNjM+XSBsb2NrX2FjcXVpcmUrMHhlOC8weDE0OQpbICAgIDQuMzAwMDIzXSAgWzxjZTM3
OWYwNT5dID8ga3Byb2JlX29wdGltaXplcisweDI3MC8weDQ0OApbICAgIDQuMzAwMDIzXSAg
WzxjZTM2YmNjMj5dIG11dGV4X2xvY2tfbmVzdGVkKzB4OGQvMHhhOWUKWyAgICA0LjMwMDAy
M10gIFs8Y2UzNzlmMDU+XSA/IGtwcm9iZV9vcHRpbWl6ZXIrMHgyNzAvMHg0NDgKWyAgICA0
LjMwMDAyM10gIFs8Y2UzNmYxMzU+XSA/IG11dGV4X3VubG9jaysweDE2LzB4MjYKWyAgICA0
LjMwMDAyM10gIFs8Y2RhODA1YTQ+XSA/IGdldF9vbmxpbmVfY3B1cysweGIwLzB4YzMKWyAg
ICA0LjMwMDAyM10gIFs8Y2UzNzlmMDU+XSBrcHJvYmVfb3B0aW1pemVyKzB4MjcwLzB4NDQ4
ClsgICAgNC4zMDAwMjNdICBbPGNkYWFkMTAzPl0gcHJvY2Vzc19vbmVfd29yaysweDNhNC8w
eDZhOApbICAgIDQuMzAwMDIzXSAgWzxjZGFhZDA3Mj5dID8gcHJvY2Vzc19vbmVfd29yaysw
eDMxMy8weDZhOApbICAgIDQuMzAwMDIzXSAgWzxjZGFhZjNhMz5dIHdvcmtlcl90aHJlYWQr
MHgzNDkvMHg1ZGQKWyAgICA0LjMwMDAyM10gIFs8Y2RhYWYwNWE+XSA/IG1hbmFnZV93b3Jr
ZXJzLmlzcmEuMjArMHgzZmMvMHgzZmMKWyAgICA0LjMwMDAyM10gIFs8Y2RhYmFhYWU+XSBr
dGhyZWFkKzB4MTNmLzB4MTUyClsgICAgNC4zMDAwMjNdICBbPGNkYWMwMDAwPl0gPyBfX2hy
dGltZXJfc3RhcnRfcmFuZ2VfbnMrMHg1MDUvMHg2MzUKWyAgICA0LjMwMDAyM10gIFs8Y2Uz
N2U4NjE+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjEvMHgzMApbICAgIDQuMzAwMDIz
XSAgWzxjZGFiYTk2Zj5dID8ga3RocmVhZF9zdG9wKzB4MTAzLzB4MTAzCgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy8zYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2
MmRmNzE3ZjUzY2NiL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItNDQ6MjAxNDAzMjMxNTU2MTc6
aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzctMTA3MTMtZzNiNTVjM2M6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy8zYjU1YzNjMGVjMmViM2Yx
NjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNnLXF1YW50YWwtbGtwLXNiMDQtNjI6MjAx
NDAzMjMyMzU2MTk6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzctMTA3
MTMtZzNiNTVjM2M6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy8zYjU1
YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNnLXF1YW50YWwtaXZ5
dG93bjItODE6MjAxNDAzMjMxNTU2MjE6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMu
MTQuMC1yYzctMTA3MTMtZzNiNTVjM2M6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0w
MzIzMDczMy8zYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNn
LXlvY3RvLWl2eXRvd24yLTM5OjIwMTQwMzIzMTU1NjI1OmkzODYtcmFuZGNvbmZpZy1jNC0w
MzIzMDczMzozLjE0LjAtcmM3LTEwNzEzLWczYjU1YzNjOjEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzQtMDMyMzA3MzMvM2I1NWMzYzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1
M2NjYi9kbWVzZy15b2N0by1sa3Atc2IwNC00OToyMDE0MDMyMzIzNTYyNzppMzg2LXJhbmRj
b25maWctYzQtMDMyMzA3MzM6My4xNC4wLXJjNy0xMDcxMy1nM2I1NWMzYzoxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYz
OTYyZGY3MTdmNTNjY2IvZG1lc2cteW9jdG8tbGtwLXNiMDQtMjA6MjAxNDAzMjMyMzU2Mzg6
aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzctMTA3MTMtZzNiNTVjM2M6
MQoyOjY6NiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29tbWl0
IDNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IKZ2l0IGNoZWNrb3V0
IHYzLjEzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctYzQtMDMyMzA3MzMvbmV4dDptYXN0ZXI6ZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZTpiaXNlY3QtdXNiCgoyMDE0LTAzLTIzLTE1OjU3OjIwIGQ4ZWMyNmQ3
ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0
LTAzMjMwNzMzLWQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9k
OGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
YzQtMDMyMzA3MzMtZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkz
ODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy1kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4
MTQyMTBmMGU2NGJlCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3
MzMvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS92bWxpbnV6LTMu
MTMuMAoKMjAxNC0wMy0yMy0xNjozMjoyMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkzCTUJ
MTAJMjUJMjcgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My4xMwpnaXQgYmlzZWN0
IHN0YXJ0IDNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IgdjMuMTMg
LS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiM2I1NWMzYzBlYzJl
YjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYiIsICItZyIsICJ2My4xMyIsICIvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9ob21lL3dmZy91c2Iv
b2JqLWJpc2VjdCJdCkJpc2VjdGluZzogMjM5MzIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDE1IHN0ZXBzKQpbMzk2MmRmYmUyMmE4ZDY1ZTQxNjIzNTRj
Yzg1OTQ0MDI5M2Q4NTUyNF0gTWVyZ2UgYnJhbmNoICdmb3ItbGludXMnIG9mIGdpdDovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9tYXNvbi9saW51eC1idHJm
cwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvbmV4dDptYXN0ZXI6Mzk2MmRmYmUy
MmE4ZDY1ZTQxNjIzNTRjYzg1OTQ0MDI5M2Q4NTUyNDpiaXNlY3QtdXNiCgoyMDE0LTAzLTIz
LTE2OjM2OjA4IDM5NjJkZmJlMjJhOGQ2NWU0MTYyMzU0Y2M4NTk0NDAyOTNkODU1MjQgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTM5NjJkZmJlMjJhOGQ2NWU0MTYyMzU0Y2M4
NTk0NDAyOTNkODU1MjQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jNC0wMzIzMDczMy8zOTYyZGZiZTIyYThkNjVlNDE2MjM1NGNjODU5NDQwMjkzZDg1
NTI0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtMzk2MmRmYmUyMmE4ZDY1ZTQxNjIzNTRj
Yzg1OTQ0MDI5M2Q4NTUyNAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy0zOTYyZGZiZTIy
YThkNjVlNDE2MjM1NGNjODU5NDQwMjkzZDg1NTI0Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzQtMDMyMzA3MzMvMzk2MmRmYmUyMmE4ZDY1ZTQxNjIzNTRjYzg1OTQ0MDI5
M2Q4NTUyNC92bWxpbnV6LTMuMTQuMC1yYzItMDA1NDAtZzM5NjJkZmIKCjIwMTQtMDMtMjMt
MTY6NTM6MDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEuCTE3CTI2CTI3IFNVQ0NFU1MKCkJp
c2VjdGluZzogMTE4MDUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDE0IHN0ZXBzKQpbZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYx
NV0gTGludXggMy4xNC1yYzcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzL25leHQ6
bWFzdGVyOmRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTU6YmlzZWN0
LXVzYgoKMjAxNC0wMy0yMy0xNjo1NTo0NCBkY2I5OWZkOWIwOGNmZTFhZmU0MjZhZjRkOGQz
Y2JjNDI5MTkwZjE1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy1kY2I5OWZkOWIw
OGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvZGNiOTlmZDliMDhjZmUxYWZlNDI2
YWY0ZDhkM2NiYzQyOTE5MGYxNQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLWRjYjk5ZmQ5
YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYzQtMDMy
MzA3MzMtZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNQprZXJuZWw6
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzL2RjYjk5ZmQ5YjA4Y2ZlMWFm
ZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUvdm1saW51ei0zLjE0LjAtcmM3CgoyMDE0LTAzLTIz
LTE3OjExOjQ0IGRldGVjdGluZyBib290IHN0YXRlIC4uCTIJMwk2CTEzCTI1CTI3IFNVQ0NF
U1MKCkJpc2VjdGluZzogMTA3MTMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDE0IHN0ZXBzKQpbNWEwMmI4ODQ4YWI3ODE0OGY0NDIxMjZjNmM3ZTMyNTUz
MzI2YzAwZF0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAndGhlcm1hbC9uZXh0Jwpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvbmV4dDptYXN0ZXI6NWEwMmI4ODQ4YWI3
ODE0OGY0NDIxMjZjNmM3ZTMyNTUzMzI2YzAwZDpiaXNlY3QtdXNiCgoyMDE0LTAzLTIzLTE3
OjE1OjUyIDVhMDJiODg0OGFiNzgxNDhmNDQyMTI2YzZjN2UzMjU1MzMyNmMwMGQgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTVhMDJiODg0OGFiNzgxNDhmNDQyMTI2YzZjN2Uz
MjU1MzMyNmMwMGQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jNC0wMzIzMDczMy81YTAyYjg4NDhhYjc4MTQ4ZjQ0MjEyNmM2YzdlMzI1NTMzMjZjMDBk
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtNWEwMmI4ODQ4YWI3ODE0OGY0NDIxMjZjNmM3
ZTMyNTUzMzI2YzAwZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy01YTAyYjg4NDhhYjc4
MTQ4ZjQ0MjEyNmM2YzdlMzI1NTMzMjZjMDBkCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzQtMDMyMzA3MzMvNWEwMmI4ODQ4YWI3ODE0OGY0NDIxMjZjNmM3ZTMyNTUzMzI2
YzAwZC92bWxpbnV6LTMuMTQuMC1yYzctMDMyNTQtZzVhMDJiODgKCjIwMTQtMDMtMjMtMTc6
MzU6NTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTI2CTI3IFNVQ0NFU1MKCkJpc2VjdGlu
ZzogNzQ1OSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMg
c3RlcHMpClsxYjg5Yjc0Y2MyMTJlMTM4NzkzZDY4ODMyMWY4NDI0YTk2YTFjNTM0XSBNZXJn
ZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdkdC1yaC9mb3ItbmV4dCcKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Iv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWM0LTAzMjMwNzMzL25leHQ6bWFzdGVyOjFiODliNzRjYzIxMmUxMzg3OTNkNjg4
MzIxZjg0MjRhOTZhMWM1MzQ6YmlzZWN0LXVzYgoKMjAxNC0wMy0yMy0xNzozODozMiAxYjg5
Yjc0Y2MyMTJlMTM4NzkzZDY4ODMyMWY4NDI0YTk2YTFjNTM0IGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1jNC0wMzIzMDczMy0xYjg5Yjc0Y2MyMTJlMTM4NzkzZDY4ODMyMWY4NDI0YTk2YTFjNTM0
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3
MzMvMWI4OWI3NGNjMjEyZTEzODc5M2Q2ODgzMjFmODQyNGE5NmExYzUzNAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLWM0LTAzMjMwNzMzLTFiODliNzRjYzIxMmUxMzg3OTNkNjg4MzIxZjg0MjRhOTZhMWM1
MzQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
Ly5pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtMWI4OWI3NGNjMjEyZTEzODc5M2Q2ODgz
MjFmODQyNGE5NmExYzUzNAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAz
MjMwNzMzLzFiODliNzRjYzIxMmUxMzg3OTNkNjg4MzIxZjg0MjRhOTZhMWM1MzQvdm1saW51
ei0zLjE0LjAtcmM3LTA3Mjg0LWcxYjg5Yjc0CgoyMDE0LTAzLTIzLTE3OjQ4OjMyIGRldGVj
dGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4JMgk0CTkJMjMJMjUuCTI2Li4uLi4uLi4uLi4u
LgkyNyBTVUNDRVNTCgpCaXNlY3Rpbmc6IDM0MjkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbNmVjZDc3NGNjN2ZmOGIxNWE5NTBjODI3
NjMwYjg1MmMwZGM0OGFiMl0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnY2hhci1t
aXNjL2NoYXItbWlzYy1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvbmV4
dDptYXN0ZXI6NmVjZDc3NGNjN2ZmOGIxNWE5NTBjODI3NjMwYjg1MmMwZGM0OGFiMjpiaXNl
Y3QtdXNiCgoyMDE0LTAzLTIzLTE4OjA0OjEwIDZlY2Q3NzRjYzdmZjhiMTVhOTUwYzgyNzYz
MGI4NTJjMGRjNDhhYjIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTZlY2Q3NzRj
YzdmZjhiMTVhOTUwYzgyNzYzMGI4NTJjMGRjNDhhYjIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy82ZWNkNzc0Y2M3ZmY4YjE1YTk1
MGM4Mjc2MzBiODUyYzBkYzQ4YWIyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtNmVjZDc3
NGNjN2ZmOGIxNWE5NTBjODI3NjMwYjg1MmMwZGM0OGFiMgp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1jNC0w
MzIzMDczMy02ZWNkNzc0Y2M3ZmY4YjE1YTk1MGM4Mjc2MzBiODUyYzBkYzQ4YWIyCmtlcm5l
bDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvNmVjZDc3NGNjN2ZmOGIx
NWE5NTBjODI3NjMwYjg1MmMwZGM0OGFiMi92bWxpbnV6LTMuMTQuMC1yYzctMTAxMzYtZzZl
Y2Q3NzQKCjIwMTQtMDMtMjMtMTg6MzM6MTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTIJ
Mwk1CTcJOQkxMC4uLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQpbICAgIDIuMjE1MzE5XSBLcHJv
YmUgc21va2UgdGVzdCBzdGFydGVkClsgICAgMi4zMTAxNzldIApbICAgIDIuMzExMzIyXSA9
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
WyAgICAyLjMxMzI3N10gWyBJTkZPOiBwb3NzaWJsZSBjaXJjdWxhciBsb2NraW5nIGRlcGVu
ZGVuY3kgZGV0ZWN0ZWQgXQpbICAgIDIuMzEzMzkxXSAzLjE0LjAtcmM3LTEwMTM2LWc2ZWNk
Nzc0ICMxIE5vdCB0YWludGVkClsgICAgMi4zMTMzOTFdIC0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KWyAgICAyLjMxMzM5MV0ga3dv
cmtlci8wOjEvMjQgaXMgdHJ5aW5nIHRvIGFjcXVpcmUgbG9jazoKWyAgICAyLjMxMzM5MV0g
ICh0ZXh0X211dGV4KXsrLisuKy59LCBhdDogWzxjYTU3YTc3ZD5dIGtwcm9iZV9vcHRpbWl6
ZXIrMHgyNzAvMHg0NDgKWyAgICAyLjMxMzM5MV0gClsgICAgMi4zMTMzOTFdIGJ1dCB0YXNr
IGlzIGFscmVhZHkgaG9sZGluZyBsb2NrOgpbICAgIDIuMzEzMzkxXSAgKG1vZHVsZV9tdXRl
eCl7Ky4rLi4ufSwgYXQ6IFs8Y2E1N2E1NDc+XSBrcHJvYmVfb3B0aW1pemVyKzB4M2EvMHg0
NDgKWyAgICAyLjMxMzM5MV0gClsgICAgMi4zMTMzOTFdIHdoaWNoIGxvY2sgYWxyZWFkeSBk
ZXBlbmRzIG9uIHRoZSBuZXcgbG9jay4KWyAgICAyLjMxMzM5MV0gClsgICAgMi4zMTMzOTFd
IApbICAgIDIuMzEzMzkxXSB0aGUgZXhpc3RpbmcgZGVwZW5kZW5jeSBjaGFpbiAoaW4gcmV2
ZXJzZSBvcmRlcikgaXM6ClsgICAgMi4zMTMzOTFdIAotPiAjMiAobW9kdWxlX211dGV4KXsr
LisuLi59OgpbICAgIDIuMzEzMzkxXSAgICAgICAgWzxjOWQwNDY5Yz5dIF9fbG9ja19hY3F1
aXJlKzB4MjI2Yy8weDI5Y2MKWyAgICAyLjMxMzM5MV0gICAgICAgIFs8YzlkMDRlZTQ+XSBs
b2NrX2FjcXVpcmUrMHhlOC8weDE0OQpbICAgIDIuMzEzMzkxXSAgICAgICAgWzxjYTU2YzUz
YT5dIG11dGV4X2xvY2tfbmVzdGVkKzB4OGQvMHhhOWUKWyAgICAyLjMxMzM5MV0gICAgICAg
IFs8YzljNWYyNjU+XSBtb2R1bGVfYWxsb2MrMHhhMC8weDE1MwpbICAgIDIuMzEzMzkxXSAg
ICAgICAgWzxjOWQ2OGZhOT5dIGFsbG9jX2luc25fcGFnZSsweDFiLzB4MmIKWyAgICAyLjMx
MzM5MV0gICAgICAgIFs8Y2E1N2MwYTI+XSBfX2dldF9pbnNuX3Nsb3QrMHgxZmYvMHgyYTgK
WyAgICAyLjMxMzM5MV0gICAgICAgIFs8Y2E1NzY3Njc+XSBhcmNoX3ByZXBhcmVfa3Byb2Jl
KzB4N2IvMHgxYjQKWyAgICAyLjMxMzM5MV0gICAgICAgIFs8Y2E1N2UwYTM+XSByZWdpc3Rl
cl9rcHJvYmUrMHg4OWIvMHhiMWYKWyAgICAyLjMxMzM5MV0gICAgICAgIFs8YzlkNjYzMzk+
XSBpbml0X3Rlc3RfcHJvYmVzKzB4OGMvMHg4ZWQKWyAgICAyLjMxMzM5MV0gICAgICAgIFs8
Y2FiMzc2ZTA+XSBpbml0X2twcm9iZXMrMHgyNjAvMHgyODgKWyAgICAyLjMxMzM5MV0gICAg
ICAgIFs8YzljMDIxZTI+XSBkb19vbmVfaW5pdGNhbGwrMHgxMzMvMHgyYjIKWyAgICAyLjMx
MzM5MV0gICAgICAgIFs8Y2FiMDNhZWU+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDQ4My8w
eDVmZgpbICAgIDIuMzEzMzkxXSAgICAgICAgWzxjYTU1MWFhZD5dIGtlcm5lbF9pbml0KzB4
MTYvMHgxZmEKWyAgICAyLjMxMzM5MV0gICAgICAgIFs8Y2E1N2YwYzE+XSByZXRfZnJvbV9r
ZXJuZWxfdGhyZWFkKzB4MjEvMHgzMApbICAgIDIuMzEzMzkxXSAKLT4gIzEgKGtwcm9iZV9p
bnNuX3Nsb3RzLm11dGV4KXsrLisuKy59OgpbICAgIDIuMzEzMzkxXSAgICAgICAgWzxjOWQw
NDY5Yz5dIF9fbG9ja19hY3F1aXJlKzB4MjI2Yy8weDI5Y2MKWyAgICAyLjMxMzM5MV0gICAg
ICAgIFs8YzlkMDRlZTQ+XSBsb2NrX2FjcXVpcmUrMHhlOC8weDE0OQpbICAgIDIuMzEzMzkx
XSAgICAgICAgWzxjYTU2YzUzYT5dIG11dGV4X2xvY2tfbmVzdGVkKzB4OGQvMHhhOWUKWyAg
ICAyLjMxMzM5MV0gICAgICAgIFs8Y2E1N2JlYzY+XSBfX2dldF9pbnNuX3Nsb3QrMHgyMy8w
eDJhOApbICAgIDIuMzEzMzkxXSAgICAgICAgWzxjYTU3Njc2Nz5dIGFyY2hfcHJlcGFyZV9r
cHJvYmUrMHg3Yi8weDFiNApbICAgIDIuMzEzMzkxXSAgICAgICAgWzxjYTU3ZTBhMz5dIHJl
Z2lzdGVyX2twcm9iZSsweDg5Yi8weGIxZgpbICAgIDIuMzEzMzkxXSAgICAgICAgWzxjOWQ2
NjMzOT5dIGluaXRfdGVzdF9wcm9iZXMrMHg4Yy8weDhlZApbICAgIDIuMzEzMzkxXSAgICAg
ICAgWzxjYWIzNzZlMD5dIGluaXRfa3Byb2JlcysweDI2MC8weDI4OApbICAgIDIuMzEzMzkx
XSAgICAgICAgWzxjOWMwMjFlMj5dIGRvX29uZV9pbml0Y2FsbCsweDEzMy8weDJiMgpbICAg
IDIuMzEzMzkxXSAgICAgICAgWzxjYWIwM2FlZT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4
NDgzLzB4NWZmClsgICAgMi4zMTMzOTFdICAgICAgICBbPGNhNTUxYWFkPl0ga2VybmVsX2lu
aXQrMHgxNi8weDFmYQpbICAgIDIuMzEzMzkxXSAgICAgICAgWzxjYTU3ZjBjMT5dIHJldF9m
cm9tX2tlcm5lbF90aHJlYWQrMHgyMS8weDMwClsgICAgMi4zMTMzOTFdIAotPiAjMCAodGV4
dF9tdXRleCl7Ky4rLisufToKWyAgICAyLjMxMzM5MV0gICAgICAgIFs8YzlkMDBiZjI+XSBj
aGVja19wcmV2X2FkZCsweDFhYy8weGIzMwpbICAgIDIuMzEzMzkxXSAgICAgICAgWzxjOWQw
NDY5Yz5dIF9fbG9ja19hY3F1aXJlKzB4MjI2Yy8weDI5Y2MKWyAgICAyLjMxMzM5MV0gICAg
ICAgIFs8YzlkMDRlZTQ+XSBsb2NrX2FjcXVpcmUrMHhlOC8weDE0OQpbICAgIDIuMzEzMzkx
XSAgICAgICAgWzxjYTU2YzUzYT5dIG11dGV4X2xvY2tfbmVzdGVkKzB4OGQvMHhhOWUKWyAg
ICAyLjMxMzM5MV0gICAgICAgIFs8Y2E1N2E3N2Q+XSBrcHJvYmVfb3B0aW1pemVyKzB4Mjcw
LzB4NDQ4ClsgICAgMi4zMTMzOTFdICAgICAgICBbPGM5Y2FkMTAzPl0gcHJvY2Vzc19vbmVf
d29yaysweDNhNC8weDZhOApbICAgIDIuMzEzMzkxXSAgICAgICAgWzxjOWNhZjNhMz5dIHdv
cmtlcl90aHJlYWQrMHgzNDkvMHg1ZGQKWyAgICAyLjMxMzM5MV0gICAgICAgIFs8YzljYmFh
YWU+XSBrdGhyZWFkKzB4MTNmLzB4MTUyClsgICAgMi4zMTMzOTFdICAgICAgICBbPGNhNTdm
MGMxPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIxLzB4MzAKWyAgICAyLjMxMzM5MV0g
ClsgICAgMi4zMTMzOTFdIG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRo
aXM6ClsgICAgMi4zMTMzOTFdIApbICAgIDIuMzEzMzkxXSBDaGFpbiBleGlzdHMgb2Y6CiAg
dGV4dF9tdXRleCAtLT4ga3Byb2JlX2luc25fc2xvdHMubXV0ZXggLS0+IG1vZHVsZV9tdXRl
eAoKWyAgICAyLjMxMzM5MV0gIFBvc3NpYmxlIHVuc2FmZSBsb2NraW5nIHNjZW5hcmlvOgpb
ICAgIDIuMzEzMzkxXSAKWyAgICAyLjMxMzM5MV0gICAgICAgIENQVTAgICAgICAgICAgICAg
ICAgICAgIENQVTEKWyAgICAyLjMxMzM5MV0gICAgICAgIC0tLS0gICAgICAgICAgICAgICAg
ICAgIC0tLS0KWyAgICAyLjMxMzM5MV0gICBsb2NrKG1vZHVsZV9tdXRleCk7ClsgICAgMi4z
MTMzOTFdICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb2NrKGtwcm9iZV9pbnNu
X3Nsb3RzLm11dGV4KTsKWyAgICAyLjMxMzM5MV0gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGxvY2sobW9kdWxlX211dGV4KTsKWyAgICAyLjMxMzM5MV0gICBsb2NrKHRleHRf
bXV0ZXgpOwpbICAgIDIuMzEzMzkxXSAKWyAgICAyLjMxMzM5MV0gICoqKiBERUFETE9DSyAq
KioKWyAgICAyLjMxMzM5MV0gClsgICAgMi4zMTMzOTFdIDUgbG9ja3MgaGVsZCBieSBrd29y
a2VyLzA6MS8yNDoKWyAgICAyLjMxMzM5MV0gICMwOiAgKCJldmVudHMiKXsuKy4rLi59LCBh
dDogWzxjOWNhZDA3Mj5dIHByb2Nlc3Nfb25lX3dvcmsrMHgzMTMvMHg2YTgKWyAgICAyLjMx
MzM5MV0gICMxOiAgKChvcHRpbWl6aW5nX3dvcmspLndvcmspeysuKy4uLn0sIGF0OiBbPGM5
Y2FkMDcyPl0gcHJvY2Vzc19vbmVfd29yaysweDMxMy8weDZhOApbICAgIDIuMzEzMzkxXSAg
IzI6ICAoa3Byb2JlX211dGV4KXsrLisuKy59LCBhdDogWzxjYTU3YTUyZD5dIGtwcm9iZV9v
cHRpbWl6ZXIrMHgyMC8weDQ0OApbICAgIDIuMzEzMzkxXSAgIzM6ICAobW9kdWxlX211dGV4
KXsrLisuLi59LCBhdDogWzxjYTU3YTU0Nz5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgzYS8weDQ0
OApbICAgIDIuMzEzMzkxXSAgIzQ6ICAoY3B1X2hvdHBsdWcubG9jayl7KysrKysrfSwgYXQ6
IFs8YzljODA1NDU+XSBnZXRfb25saW5lX2NwdXMrMHg1MS8weGMzClsgICAgMi4zMTMzOTFd
IApbICAgIDIuMzEzMzkxXSBzdGFjayBiYWNrdHJhY2U6ClsgICAgMi4zMTMzOTFdIENQVTog
MCBQSUQ6IDI0IENvbW06IGt3b3JrZXIvMDoxIE5vdCB0YWludGVkIDMuMTQuMC1yYzctMTAx
MzYtZzZlY2Q3NzQgIzEKWyAgICAyLjMxMzM5MV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9j
aHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuMzEzMzkxXSBXb3JrcXVldWU6IGV2
ZW50cyBrcHJvYmVfb3B0aW1pemVyClsgICAgMi4zMTMzOTFdICBjZjY1MGFkMCBjZjdmYmQ3
NCBjYTU2MmUwNCBjYWU5NTFjYyBjZjdmYmRhNCBjYTU1YjNkOCBjYTg5ODhhYyBjYTg5ODY1
ZQpbICAgIDIuMzEzMzkxXSAgY2E4OTg2MjYgY2E4OTg2NDcgY2E4OTg2MjYgY2Y2NTBhZDAg
Y2Y3ZmJkYjggY2Y2NTBmNjAgY2Y2NTBmOTAgY2Y2NTBhZDAKWyAgICAyLjMxMzM5MV0gIGNm
N2ZiZGU4IGM5ZDAwYmYyIGNmNjUwZjYwIGNmNjUwZjc4IGNiMDhjZmZjIGM5ZDAwYTE2IDAw
MDAwMDA5IGNhZTk1MGJjClsgICAgMi4zMTMzOTFdIENhbGwgVHJhY2U6ClsgICAgMi4zMTMz
OTFdICBbPGNhNTYyZTA0Pl0gZHVtcF9zdGFjaysweGI4LzB4MTA4ClsgICAgMi4zMTMzOTFd
ICBbPGNhNTViM2Q4Pl0gcHJpbnRfY2lyY3VsYXJfYnVnKzB4NWVjLzB4NjM4ClsgICAgMi4z
MTMzOTFdICBbPGM5ZDAwYmYyPl0gY2hlY2tfcHJldl9hZGQrMHgxYWMvMHhiMzMKWyAgICAy
LjMxMzM5MV0gIFs8YzlkMDBhMTY+XSA/IGNoZWNrX2lycV91c2FnZSsweGYwLzB4MTIwClsg
ICAgMi4zMTMzOTFdICBbPGM5ZDA0NjljPl0gPyBfX2xvY2tfYWNxdWlyZSsweDIyNmMvMHgy
OWNjClsgICAgMi4zMTMzOTFdICBbPGM5ZDA0NjljPl0gX19sb2NrX2FjcXVpcmUrMHgyMjZj
LzB4MjljYwpbICAgIDIuMzEzMzkxXSAgWzxjOWQwNGVlND5dIGxvY2tfYWNxdWlyZSsweGU4
LzB4MTQ5ClsgICAgMi4zMTMzOTFdICBbPGNhNTdhNzdkPl0gPyBrcHJvYmVfb3B0aW1pemVy
KzB4MjcwLzB4NDQ4ClsgICAgMi4zMTMzOTFdICBbPGNhNTZjNTNhPl0gbXV0ZXhfbG9ja19u
ZXN0ZWQrMHg4ZC8weGE5ZQpbICAgIDIuMzEzMzkxXSAgWzxjYTU3YTc3ZD5dID8ga3Byb2Jl
X29wdGltaXplcisweDI3MC8weDQ0OApbICAgIDIuMzEzMzkxXSAgWzxjYTU2ZjlhZD5dID8g
bXV0ZXhfdW5sb2NrKzB4MTYvMHgyNgpbICAgIDIuMzEzMzkxXSAgWzxjOWM4MDVhND5dID8g
Z2V0X29ubGluZV9jcHVzKzB4YjAvMHhjMwpbICAgIDIuMzEzMzkxXSAgWzxjYTU3YTc3ZD5d
IGtwcm9iZV9vcHRpbWl6ZXIrMHgyNzAvMHg0NDgKWyAgICAyLjMxMzM5MV0gIFs8YzljYWQx
MDM+XSBwcm9jZXNzX29uZV93b3JrKzB4M2E0LzB4NmE4ClsgICAgMi4zMTMzOTFdICBbPGM5
Y2FkMDcyPl0gPyBwcm9jZXNzX29uZV93b3JrKzB4MzEzLzB4NmE4ClsgICAgMi4zMTMzOTFd
ICBbPGM5Y2FmM2EzPl0gd29ya2VyX3RocmVhZCsweDM0OS8weDVkZApbICAgIDIuMzEzMzkx
XSAgWzxjOWNhZjA1YT5dID8gbWFuYWdlX3dvcmtlcnMuaXNyYS4yMCsweDNmYy8weDNmYwpb
ICAgIDIuMzEzMzkxXSAgWzxjOWNiYWFhZT5dIGt0aHJlYWQrMHgxM2YvMHgxNTIKWyAgICAy
LjMxMzM5MV0gIFs8YzljYzAwMDA+XSA/IF9faHJ0aW1lcl9zdGFydF9yYW5nZV9ucysweDUw
NS8weDYzNQpbICAgIDIuMzEzMzkxXSAgWzxjYTU3ZjBjMT5dIHJldF9mcm9tX2tlcm5lbF90
aHJlYWQrMHgyMS8weDMwClsgICAgMi4zMTMzOTFdICBbPGM5Y2JhOTZmPl0gPyBrdGhyZWFk
X3N0b3ArMHgxMDMvMHgxMDMKWyAgICAyLjUwOTUzNV0gdHNjOiBSZWZpbmVkIFRTQyBjbG9j
a3NvdXJjZSBjYWxpYnJhdGlvbjogMjY5My40MjkgTUh6Cgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jNC0wMzIzMDczMy82ZWNkNzc0Y2M3ZmY4YjE1YTk1MGM4Mjc2MzBiODUyYzBkYzQ4
YWIyL2RtZXNnLXlvY3RvLWlubi0xNzoyMDE0MDMyMzE4NDI0NDppMzg2LXJhbmRjb25maWct
YzQtMDMyMzA3MzM6OgoxMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1
bTIwMTQtMDMtMjMgMTg6NDM6MTQgUkVQRUFUIENPVU5UOiAxMjAgICMgL2NjL3dmZy91c2It
YmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDI4NTIgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbZDhiZTAzYWE4YmY3NTRmYTBl
YzNhMjA4ODVhMjM4N2U0M2E0MThmZV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAn
cGVyY3B1L2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvbmV4dDpt
YXN0ZXI6ZDhiZTAzYWE4YmY3NTRmYTBlYzNhMjA4ODVhMjM4N2U0M2E0MThmZTpiaXNlY3Qt
dXNiCgoyMDE0LTAzLTIzLTE4OjQzOjE5IGQ4YmUwM2FhOGJmNzU0ZmEwZWMzYTIwODg1YTIz
ODdlNDNhNDE4ZmUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLWQ4YmUwM2FhOGJm
NzU0ZmEwZWMzYTIwODg1YTIzODdlNDNhNDE4ZmUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9kOGJlMDNhYThiZjc1NGZhMGVjM2Ey
MDg4NWEyMzg3ZTQzYTQxOGZlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtZDhiZTAzYWE4
YmY3NTRmYTBlYzNhMjA4ODVhMjM4N2U0M2E0MThmZQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1jNC0wMzIz
MDczMy1kOGJlMDNhYThiZjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQzYTQxOGZlCmtlcm5lbDog
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvZDhiZTAzYWE4YmY3NTRmYTBl
YzNhMjA4ODVhMjM4N2U0M2E0MThmZS92bWxpbnV6LTMuMTQuMC1yYzctMDgxOTMtZ2Q4YmUw
M2EKCjIwMTQtMDMtMjMtMTg6NTc6MjAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4JMS4J
Mgk2CTcJOC4JOQkxMAkxMS4JMTMuLgkxNiBURVNUIEZBSUxVUkUKWyAgICA1LjU2Nzg2MF0g
S3Byb2JlIHNtb2tlIHRlc3Qgc3RhcnRlZApbICAgIDUuNjYwMTgyXSAKWyAgICA1LjY2MTQ3
OF0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09ClsgICAgNS42NjMzODNdIFsgSU5GTzogcG9zc2libGUgY2lyY3VsYXIgbG9ja2luZyBk
ZXBlbmRlbmN5IGRldGVjdGVkIF0KWyAgICA1LjY2MzM4M10gMy4xNC4wLXJjNy0wODE5My1n
ZDhiZTAzYSAjMSBOb3QgdGFpbnRlZApbICAgIDUuNjYzMzgzXSAtLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgNS42NjMzODNd
IGt3b3JrZXIvMToxLzI1IGlzIHRyeWluZyB0byBhY3F1aXJlIGxvY2s6ClsgICAgNS42NjMz
ODNdICAodGV4dF9tdXRleCl7Ky4rLisufSwgYXQ6IFs8Y2Q3NzU2ZmQ+XSBrcHJvYmVfb3B0
aW1pemVyKzB4MjcwLzB4NDQ4ClsgICAgNS42NjMzODNdIApbICAgIDUuNjYzMzgzXSBidXQg
dGFzayBpcyBhbHJlYWR5IGhvbGRpbmcgbG9jazoKWyAgICA1LjY2MzM4M10gIChtb2R1bGVf
bXV0ZXgpeysuKy4uLn0sIGF0OiBbPGNkNzc1NGM3Pl0ga3Byb2JlX29wdGltaXplcisweDNh
LzB4NDQ4ClsgICAgNS42NjMzODNdIApbICAgIDUuNjYzMzgzXSB3aGljaCBsb2NrIGFscmVh
ZHkgZGVwZW5kcyBvbiB0aGUgbmV3IGxvY2suClsgICAgNS42NjMzODNdIApbICAgIDUuNjYz
MzgzXSAKWyAgICA1LjY2MzM4M10gdGhlIGV4aXN0aW5nIGRlcGVuZGVuY3kgY2hhaW4gKGlu
IHJldmVyc2Ugb3JkZXIpIGlzOgpbICAgIDUuNjYzMzgzXSAKLT4gIzIgKG1vZHVsZV9tdXRl
eCl7Ky4rLi4ufToKWyAgICA1LjY2MzM4M10gICAgICAgIFs8Y2NmMDQ4NjA+XSBfX2xvY2tf
YWNxdWlyZSsweDIyNmMvMHgyOWNjClsgICAgNS42NjMzODNdICAgICAgICBbPGNjZjA1MGE4
Pl0gbG9ja19hY3F1aXJlKzB4ZTgvMHgxNDkKWyAgICA1LjY2MzM4M10gICAgICAgIFs8Y2Q3
Njc0YmE+XSBtdXRleF9sb2NrX25lc3RlZCsweDhkLzB4YTllClsgICAgNS42NjMzODNdICAg
ICAgICBbPGNjZTVmNDI5Pl0gbW9kdWxlX2FsbG9jKzB4YTAvMHgxNTMKWyAgICA1LjY2MzM4
M10gICAgICAgIFs8Y2NmNjkxNmQ+XSBhbGxvY19pbnNuX3BhZ2UrMHgxYi8weDJiClsgICAg
NS42NjMzODNdICAgICAgICBbPGNkNzc3MDIyPl0gX19nZXRfaW5zbl9zbG90KzB4MWZmLzB4
MmE4ClsgICAgNS42NjMzODNdICAgICAgICBbPGNkNzcxNmU3Pl0gYXJjaF9wcmVwYXJlX2tw
cm9iZSsweDdiLzB4MWI0ClsgICAgNS42NjMzODNdICAgICAgICBbPGNkNzc5MDIzPl0gcmVn
aXN0ZXJfa3Byb2JlKzB4ODliLzB4YjFmClsgICAgNS42NjMzODNdICAgICAgICBbPGNjZjY2
NGZkPl0gaW5pdF90ZXN0X3Byb2JlcysweDhjLzB4OGVkClsgICAgNS42NjMzODNdICAgICAg
ICBbPGNkZDMwNmUwPl0gaW5pdF9rcHJvYmVzKzB4MjYwLzB4Mjg4ClsgICAgNS42NjMzODNd
ICAgICAgICBbPGNjZTAyMWUyPl0gZG9fb25lX2luaXRjYWxsKzB4MTMzLzB4MmIyClsgICAg
NS42NjMzODNdICAgICAgICBbPGNkY2ZjYWVlPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHg0
ODMvMHg1ZmYKWyAgICA1LjY2MzM4M10gICAgICAgIFs8Y2Q3NGNlNWQ+XSBrZXJuZWxfaW5p
dCsweDE2LzB4MWZhClsgICAgNS42NjMzODNdICAgICAgICBbPGNkNzdhMDQxPl0gcmV0X2Zy
b21fa2VybmVsX3RocmVhZCsweDIxLzB4MzAKWyAgICA1LjY2MzM4M10gCi0+ICMxIChrcHJv
YmVfaW5zbl9zbG90cy5tdXRleCl7Ky4rLisufToKWyAgICA1LjY2MzM4M10gICAgICAgIFs8
Y2NmMDQ4NjA+XSBfX2xvY2tfYWNxdWlyZSsweDIyNmMvMHgyOWNjClsgICAgNS42NjMzODNd
ICAgICAgICBbPGNjZjA1MGE4Pl0gbG9ja19hY3F1aXJlKzB4ZTgvMHgxNDkKWyAgICA1LjY2
MzM4M10gICAgICAgIFs8Y2Q3Njc0YmE+XSBtdXRleF9sb2NrX25lc3RlZCsweDhkLzB4YTll
ClsgICAgNS42NjMzODNdICAgICAgICBbPGNkNzc2ZTQ2Pl0gX19nZXRfaW5zbl9zbG90KzB4
MjMvMHgyYTgKWyAgICA1LjY2MzM4M10gICAgICAgIFs8Y2Q3NzE2ZTc+XSBhcmNoX3ByZXBh
cmVfa3Byb2JlKzB4N2IvMHgxYjQKWyAgICA1LjY2MzM4M10gICAgICAgIFs8Y2Q3NzkwMjM+
XSByZWdpc3Rlcl9rcHJvYmUrMHg4OWIvMHhiMWYKWyAgICA1LjY2MzM4M10gICAgICAgIFs8
Y2NmNjY0ZmQ+XSBpbml0X3Rlc3RfcHJvYmVzKzB4OGMvMHg4ZWQKWyAgICA1LjY2MzM4M10g
ICAgICAgIFs8Y2RkMzA2ZTA+XSBpbml0X2twcm9iZXMrMHgyNjAvMHgyODgKWyAgICA1LjY2
MzM4M10gICAgICAgIFs8Y2NlMDIxZTI+XSBkb19vbmVfaW5pdGNhbGwrMHgxMzMvMHgyYjIK
WyAgICA1LjY2MzM4M10gICAgICAgIFs8Y2RjZmNhZWU+XSBrZXJuZWxfaW5pdF9mcmVlYWJs
ZSsweDQ4My8weDVmZgpbICAgIDUuNjYzMzgzXSAgICAgICAgWzxjZDc0Y2U1ZD5dIGtlcm5l
bF9pbml0KzB4MTYvMHgxZmEKWyAgICA1LjY2MzM4M10gICAgICAgIFs8Y2Q3N2EwNDE+XSBy
ZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjEvMHgzMApbICAgIDUuNjYzMzgzXSAKLT4gIzAg
KHRleHRfbXV0ZXgpeysuKy4rLn06ClsgICAgNS42NjMzODNdICAgICAgICBbPGNjZjAwZGI2
Pl0gY2hlY2tfcHJldl9hZGQrMHgxYWMvMHhiMzMKWyAgICA1LjY2MzM4M10gICAgICAgIFs8
Y2NmMDQ4NjA+XSBfX2xvY2tfYWNxdWlyZSsweDIyNmMvMHgyOWNjClsgICAgNS42NjMzODNd
ICAgICAgICBbPGNjZjA1MGE4Pl0gbG9ja19hY3F1aXJlKzB4ZTgvMHgxNDkKWyAgICA1LjY2
MzM4M10gICAgICAgIFs8Y2Q3Njc0YmE+XSBtdXRleF9sb2NrX25lc3RlZCsweDhkLzB4YTll
ClsgICAgNS42NjMzODNdICAgICAgICBbPGNkNzc1NmZkPl0ga3Byb2JlX29wdGltaXplcisw
eDI3MC8weDQ0OApbICAgIDUuNjYzMzgzXSAgICAgICAgWzxjY2VhZDJjNz5dIHByb2Nlc3Nf
b25lX3dvcmsrMHgzYTQvMHg2YTgKWyAgICA1LjY2MzM4M10gICAgICAgIFs8Y2NlYWY1Njc+
XSB3b3JrZXJfdGhyZWFkKzB4MzQ5LzB4NWRkClsgICAgNS42NjMzODNdICAgICAgICBbPGNj
ZWJhYzcyPl0ga3RocmVhZCsweDEzZi8weDE1MgpbICAgIDUuNjYzMzgzXSAgICAgICAgWzxj
ZDc3YTA0MT5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMS8weDMwClsgICAgNS42NjMz
ODNdIApbICAgIDUuNjYzMzgzXSBvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVscCB1cyBkZWJ1
ZyB0aGlzOgpbICAgIDUuNjYzMzgzXSAKWyAgICA1LjY2MzM4M10gQ2hhaW4gZXhpc3RzIG9m
OgogIHRleHRfbXV0ZXggLS0+IGtwcm9iZV9pbnNuX3Nsb3RzLm11dGV4IC0tPiBtb2R1bGVf
bXV0ZXgKClsgICAgNS42NjMzODNdICBQb3NzaWJsZSB1bnNhZmUgbG9ja2luZyBzY2VuYXJp
bzoKWyAgICA1LjY2MzM4M10gClsgICAgNS42NjMzODNdICAgICAgICBDUFUwICAgICAgICAg
ICAgICAgICAgICBDUFUxClsgICAgNS42NjMzODNdICAgICAgICAtLS0tICAgICAgICAgICAg
ICAgICAgICAtLS0tClsgICAgNS42NjMzODNdICAgbG9jayhtb2R1bGVfbXV0ZXgpOwpbICAg
IDUuNjYzMzgzXSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9jayhrcHJvYmVf
aW5zbl9zbG90cy5tdXRleCk7ClsgICAgNS42NjMzODNdICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBsb2NrKG1vZHVsZV9tdXRleCk7ClsgICAgNS42NjMzODNdICAgbG9jayh0
ZXh0X211dGV4KTsKWyAgICA1LjY2MzM4M10gClsgICAgNS42NjMzODNdICAqKiogREVBRExP
Q0sgKioqClsgICAgNS42NjMzODNdIApbICAgIDUuNjYzMzgzXSA1IGxvY2tzIGhlbGQgYnkg
a3dvcmtlci8xOjEvMjU6ClsgICAgNS42NjMzODNdICAjMDogICgiZXZlbnRzIil7LisuKy4u
fSwgYXQ6IFs8Y2NlYWQyMzY+XSBwcm9jZXNzX29uZV93b3JrKzB4MzEzLzB4NmE4ClsgICAg
NS42NjMzODNdICAjMTogICgob3B0aW1pemluZ193b3JrKS53b3JrKXsrLisuLi59LCBhdDog
ClsgICAgNS43OTY4ODJdIHRzYzogUmVmaW5lZCBUU0MgY2xvY2tzb3VyY2UgY2FsaWJyYXRp
b246IDI4OTIuOTg3IE1IegoKWyAgICA1LjY2MzM4M10gWzxjY2VhZDIzNj5dIHByb2Nlc3Nf
b25lX3dvcmsrMHgzMTMvMHg2YTgKWyAgICA1LjY2MzM4M10gICMyOiAgKGtwcm9iZV9tdXRl
eCl7Ky4rLisufSwgYXQ6IFs8Y2Q3NzU0YWQ+XSBrcHJvYmVfb3B0aW1pemVyKzB4MjAvMHg0
NDgKWyAgICA1LjY2MzM4M10gICMzOiAgKG1vZHVsZV9tdXRleCl7Ky4rLi4ufSwgYXQ6IFs8
Y2Q3NzU0Yzc+XSBrcHJvYmVfb3B0aW1pemVyKzB4M2EvMHg0NDgKWyAgICA1LjY2MzM4M10g
ICM0OiAgKGNwdV9ob3RwbHVnLmxvY2speysrKysrK30sIGF0OiBbPGNjZTgwNzA5Pl0gZ2V0
X29ubGluZV9jcHVzKzB4NTEvMHhjMwpbICAgIDUuNjYzMzgzXSAKWyAgICA1LjY2MzM4M10g
c3RhY2sgYmFja3RyYWNlOgpbICAgIDUuNjYzMzgzXSBDUFU6IDEgUElEOiAyNSBDb21tOiBr
d29ya2VyLzE6MSBOb3QgdGFpbnRlZCAzLjE0LjAtcmM3LTA4MTkzLWdkOGJlMDNhICMxClsg
ICAgNS42NjMzODNdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAx
LzAxLzIwMTEKWyAgICA1LjY2MzM4M10gV29ya3F1ZXVlOiBldmVudHMga3Byb2JlX29wdGlt
aXplcgpbICAgIDUuNjYzMzgzXSAgY2M2NjYxNTAgY2I5NmZkNzQgY2Q3NWUxYjQgY2UwOGUy
NGMgY2I5NmZkYTQgY2Q3NTY3ODggY2RhOTFkOTIgY2RhOTFiNDQKWyAgICA1LjY2MzM4M10g
IGNkYTkxYjBjIGNkYTkxYjJkIGNkYTkxYjBjIGNjNjY2MTUwIGNiOTZmZGI4IGNjNjY2NWUw
IGNjNjY2NjEwIGNjNjY2MTUwClsgICAgNS42NjMzODNdICBjYjk2ZmRlOCBjY2YwMGRiNiBj
YzY2NjVlMCBjYzY2NjVmOCBjZTI4NWVjYyBjY2YwMGJkYSAwMDAwMDAwOSBjZTA4ZTEzYwpb
ICAgIDUuNjYzMzgzXSBDYWxsIFRyYWNlOgpbICAgIDUuNjYzMzgzXSAgWzxjZDc1ZTFiND5d
IGR1bXBfc3RhY2srMHhiOC8weDEwOApbICAgIDUuNjYzMzgzXSAgWzxjZDc1Njc4OD5dIHBy
aW50X2NpcmN1bGFyX2J1ZysweDVlYy8weDYzOApbICAgIDUuNjYzMzgzXSAgWzxjY2YwMGRi
Nj5dIGNoZWNrX3ByZXZfYWRkKzB4MWFjLzB4YjMzClsgICAgNS42NjMzODNdICBbPGNjZjAw
YmRhPl0gPyBjaGVja19pcnFfdXNhZ2UrMHhmMC8weDEyMApbICAgIDUuNjYzMzgzXSAgWzxj
Y2YwNDg2MD5dID8gX19sb2NrX2FjcXVpcmUrMHgyMjZjLzB4MjljYwpbICAgIDUuNjYzMzgz
XSAgWzxjY2YwNDg2MD5dIF9fbG9ja19hY3F1aXJlKzB4MjI2Yy8weDI5Y2MKWyAgICA1LjY2
MzM4M10gIFs8Y2NmMDUwYTg+XSBsb2NrX2FjcXVpcmUrMHhlOC8weDE0OQpbICAgIDUuNjYz
MzgzXSAgWzxjZDc3NTZmZD5dID8ga3Byb2JlX29wdGltaXplcisweDI3MC8weDQ0OApbICAg
IDUuNjYzMzgzXSAgWzxjZDc2NzRiYT5dIG11dGV4X2xvY2tfbmVzdGVkKzB4OGQvMHhhOWUK
WyAgICA1LjY2MzM4M10gIFs8Y2Q3NzU2ZmQ+XSA/IGtwcm9iZV9vcHRpbWl6ZXIrMHgyNzAv
MHg0NDgKWyAgICA1LjY2MzM4M10gIFs8Y2Q3NmE5MmQ+XSA/IG11dGV4X3VubG9jaysweDE2
LzB4MjYKWyAgICA1LjY2MzM4M10gIFs8Y2NlODA3Njg+XSA/IGdldF9vbmxpbmVfY3B1cysw
eGIwLzB4YzMKWyAgICA1LjY2MzM4M10gIFs8Y2Q3NzU2ZmQ+XSBrcHJvYmVfb3B0aW1pemVy
KzB4MjcwLzB4NDQ4ClsgICAgNS42NjMzODNdICBbPGNjZWFkMmM3Pl0gcHJvY2Vzc19vbmVf
d29yaysweDNhNC8weDZhOApbICAgIDUuNjYzMzgzXSAgWzxjY2VhZDIzNj5dID8gcHJvY2Vz
c19vbmVfd29yaysweDMxMy8weDZhOApbICAgIDUuNjYzMzgzXSAgWzxjY2VhZjU2Nz5dIHdv
cmtlcl90aHJlYWQrMHgzNDkvMHg1ZGQKWyAgICA1LjY2MzM4M10gIFs8Y2NlYWYyMWU+XSA/
IG1hbmFnZV93b3JrZXJzLmlzcmEuMjArMHgzZmMvMHgzZmMKWyAgICA1LjY2MzM4M10gIFs8
Y2NlYmFjNzI+XSBrdGhyZWFkKzB4MTNmLzB4MTUyClsgICAgNS42NjMzODNdICBbPGNjZWMw
MDAwPl0gPyBfX2hydGltZXJfc3RhcnRfcmFuZ2VfbnMrMHgzNDEvMHg2MzUKWyAgICA1LjY2
MzM4M10gIFs8Y2Q3N2EwNDE+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjEvMHgzMApb
ICAgIDUuNjYzMzgzXSAgWzxjY2ViYWIzMz5dID8ga3RocmVhZF9zdG9wKzB4MTAzLzB4MTAz
Cgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9kOGJlMDNhYThiZjc1NGZh
MGVjM2EyMDg4NWEyMzg3ZTQzYTQxOGZlL2RtZXNnLXlvY3RvLXJvYW0tMjQ6MjAxNDAzMjMx
OTA2Mzg6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzctMDgxOTMtZ2Q4
YmUwM2E6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9kOGJlMDNhYThi
Zjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQzYTQxOGZlL2RtZXNnLXF1YW50YWwtY2Fpcm8tMjY6
MjAxNDAzMjMxOTA2NDU6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzct
MDgxOTMtZ2Q4YmUwM2E6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9k
OGJlMDNhYThiZjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQzYTQxOGZlL2RtZXNnLXlvY3RvLXJv
YW0tMzk6MjAxNDAzMjMxOTA2NDM6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQu
MC1yYzctMDgxOTMtZ2Q4YmUwM2E6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIz
MDczMy9kOGJlMDNhYThiZjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQzYTQxOGZlL2RtZXNnLXlv
Y3RvLWxrcC1zYjA0LTM4OjIwMTQwMzI0MDMwNzA2OmkzODYtcmFuZGNvbmZpZy1jNC0wMzIz
MDczMzozLjE0LjAtcmM3LTA4MTkzLWdkOGJlMDNhOjEKMTM6NTo3IGFsbF9nb29kOmJhZDph
bGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDkwOSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpClswZTU2YzkwYzEzMmI2NDQyN2M4YzU1ZmQ4
NTAwM2VjMWYxN2RiYTZkXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdlZGFjLWFt
ZC9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzL25leHQ6bWFzdGVy
OjBlNTZjOTBjMTMyYjY0NDI3YzhjNTVmZDg1MDAzZWMxZjE3ZGJhNmQ6YmlzZWN0LXVzYgoK
MjAxNC0wMy0yMy0xOTowNzoyNiAwZTU2YzkwYzEzMmI2NDQyN2M4YzU1ZmQ4NTAwM2VjMWYx
N2RiYTZkIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy0wZTU2YzkwYzEzMmI2NDQy
N2M4YzU1ZmQ4NTAwM2VjMWYxN2RiYTZkCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvMGU1NmM5MGMxMzJiNjQ0MjdjOGM1NWZkODUw
MDNlYzFmMTdkYmE2ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTBlNTZjOTBjMTMyYjY0
NDI3YzhjNTVmZDg1MDAzZWMxZjE3ZGJhNmQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMt
MGU1NmM5MGMxMzJiNjQ0MjdjOGM1NWZkODUwMDNlYzFmMTdkYmE2ZAprZXJuZWw6IC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzBlNTZjOTBjMTMyYjY0NDI3YzhjNTVm
ZDg1MDAzZWMxZjE3ZGJhNmQvdm1saW51ei0zLjE0LjAtcmM3LTA4MDQ4LWcwZTU2YzkwCgoy
MDE0LTAzLTIzLTE5OjM1OjI3IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4JMS4JNQk3
CTE1CTIyCTI4CTMyCTM0CTM1CTM2Li4gVEVTVCBGQUlMVVJFClsgICAgMy44Nzc4MDNdIEtw
cm9iZSBzbW9rZSB0ZXN0IHN0YXJ0ZWQKWyAgICAzLjk2MzQwOF0gClsgICAgMy45NjQxOTRd
ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQpbICAgIDMuOTY1NTExXSBbIElORk86IHBvc3NpYmxlIGNpcmN1bGFyIGxvY2tpbmcgZGVw
ZW5kZW5jeSBkZXRlY3RlZCBdClsgICAgMy45NjY2ODRdIDMuMTQuMC1yYzctMDgwNDgtZzBl
NTZjOTAgIzEgTm90IHRhaW50ZWQKWyAgICAzLjk2NjY4NF0gLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgIDMuOTY2Njg0XSBr
d29ya2VyLzE6MS8yNSBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpbICAgIDMuOTY2Njg0
XSAgKHRleHRfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGMzMTc1ODM1Pl0ga3Byb2JlX29wdGlt
aXplcisweDI3MC8weDQ0OApbICAgIDMuOTY2Njg0XSAKWyAgICAzLjk2NjY4NF0gYnV0IHRh
c2sgaXMgYWxyZWFkeSBob2xkaW5nIGxvY2s6ClsgICAgMy45NjY2ODRdICAobW9kdWxlX211
dGV4KXsrLisuLi59LCBhdDogWzxjMzE3NTVmZj5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgzYS8w
eDQ0OApbICAgIDMuOTY2Njg0XSAKWyAgICAzLjk2NjY4NF0gd2hpY2ggbG9jayBhbHJlYWR5
IGRlcGVuZHMgb24gdGhlIG5ldyBsb2NrLgpbICAgIDMuOTY2Njg0XSAKWyAgICAzLjk2NjY4
NF0gClsgICAgMy45NjY2ODRdIHRoZSBleGlzdGluZyBkZXBlbmRlbmN5IGNoYWluIChpbiBy
ZXZlcnNlIG9yZGVyKSBpczoKWyAgICAzLjk2NjY4NF0gCi0+ICMyIChtb2R1bGVfbXV0ZXgp
eysuKy4uLn06ClsgICAgMy45NjY2ODRdICAgICAgICBbPGMyOTA0NDA0Pl0gX19sb2NrX2Fj
cXVpcmUrMHgyMjZjLzB4MjljYwpbICAgIDMuOTY2Njg0XSAgICAgICAgWzxjMjkwNGM0Yz5d
IGxvY2tfYWNxdWlyZSsweGU4LzB4MTQ5ClsgICAgMy45NjY2ODRdICAgICAgICBbPGMzMTY3
NWYyPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg4ZC8weGE5ZQpbICAgIDMuOTY2Njg0XSAgICAg
ICAgWzxjMjg1ZWZjZD5dIG1vZHVsZV9hbGxvYysweGEwLzB4MTUzClsgICAgMy45NjY2ODRd
ICAgICAgICBbPGMyOTY4ZDExPl0gYWxsb2NfaW5zbl9wYWdlKzB4MWIvMHgyYgpbICAgIDMu
OTY2Njg0XSAgICAgICAgWzxjMzE3NzE1YT5dIF9fZ2V0X2luc25fc2xvdCsweDFmZi8weDJh
OApbICAgIDMuOTY2Njg0XSAgICAgICAgWzxjMzE3MTgxZj5dIGFyY2hfcHJlcGFyZV9rcHJv
YmUrMHg3Yi8weDFiNApbICAgIDMuOTY2Njg0XSAgICAgICAgWzxjMzE3OTE1Yj5dIHJlZ2lz
dGVyX2twcm9iZSsweDg5Yi8weGIxZgpbICAgIDMuOTY2Njg0XSAgICAgICAgWzxjMjk2NjBh
MT5dIGluaXRfdGVzdF9wcm9iZXMrMHg4Yy8weDhlZApbICAgIDMuOTY2Njg0XSAgICAgICAg
WzxjMzczMDU5YT5dIGluaXRfa3Byb2JlcysweDI2MC8weDI4OApbICAgIDMuOTY2Njg0XSAg
ICAgICAgWzxjMjgwMjFlMj5dIGRvX29uZV9pbml0Y2FsbCsweDEzMy8weDJiMgpbICAgIDMu
OTY2Njg0XSAgICAgICAgWzxjMzZmY2FlZT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4NDgz
LzB4NWZmClsgICAgMy45NjY2ODRdICAgICAgICBbPGMzMTRjZmZiPl0ga2VybmVsX2luaXQr
MHgxNi8weDFmYQpbICAgIDMuOTY2Njg0XSAgICAgICAgWzxjMzE3YTE4MT5dIHJldF9mcm9t
X2tlcm5lbF90aHJlYWQrMHgyMS8weDMwClsgICAgMy45NjY2ODRdIAotPiAjMSAoa3Byb2Jl
X2luc25fc2xvdHMubXV0ZXgpeysuKy4rLn06ClsgICAgMy45NjY2ODRdICAgICAgICBbPGMy
OTA0NDA0Pl0gX19sb2NrX2FjcXVpcmUrMHgyMjZjLzB4MjljYwpbICAgIDMuOTY2Njg0XSAg
ICAgICAgWzxjMjkwNGM0Yz5dIGxvY2tfYWNxdWlyZSsweGU4LzB4MTQ5ClsgICAgMy45NjY2
ODRdICAgICAgICBbPGMzMTY3NWYyPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg4ZC8weGE5ZQpb
ICAgIDMuOTY2Njg0XSAgICAgICAgWzxjMzE3NmY3ZT5dIF9fZ2V0X2luc25fc2xvdCsweDIz
LzB4MmE4ClsgICAgMy45NjY2ODRdICAgICAgICBbPGMzMTcxODFmPl0gYXJjaF9wcmVwYXJl
X2twcm9iZSsweDdiLzB4MWI0ClsgICAgMy45NjY2ODRdICAgICAgICBbPGMzMTc5MTViPl0g
cmVnaXN0ZXJfa3Byb2JlKzB4ODliLzB4YjFmClsgICAgMy45NjY2ODRdICAgICAgICBbPGMy
OTY2MGExPl0gaW5pdF90ZXN0X3Byb2JlcysweDhjLzB4OGVkClsgICAgMy45NjY2ODRdICAg
ICAgICBbPGMzNzMwNTlhPl0gaW5pdF9rcHJvYmVzKzB4MjYwLzB4Mjg4ClsgICAgMy45NjY2
ODRdICAgICAgICBbPGMyODAyMWUyPl0gZG9fb25lX2luaXRjYWxsKzB4MTMzLzB4MmIyClsg
ICAgMy45NjY2ODRdICAgICAgICBbPGMzNmZjYWVlPl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHg0ODMvMHg1ZmYKWyAgICAzLjk2NjY4NF0gICAgICAgIFs8YzMxNGNmZmI+XSBrZXJuZWxf
aW5pdCsweDE2LzB4MWZhClsgICAgMy45NjY2ODRdICAgICAgICBbPGMzMTdhMTgxPl0gcmV0
X2Zyb21fa2VybmVsX3RocmVhZCsweDIxLzB4MzAKWyAgICAzLjk2NjY4NF0gCi0+ICMwICh0
ZXh0X211dGV4KXsrLisuKy59OgpbICAgIDMuOTY2Njg0XSAgICAgICAgWzxjMjkwMDk1YT5d
IGNoZWNrX3ByZXZfYWRkKzB4MWFjLzB4YjMzClsgICAgMy45NjY2ODRdICAgICAgICBbPGMy
OTA0NDA0Pl0gX19sb2NrX2FjcXVpcmUrMHgyMjZjLzB4MjljYwpbICAgIDMuOTY2Njg0XSAg
ICAgICAgWzxjMjkwNGM0Yz5dIGxvY2tfYWNxdWlyZSsweGU4LzB4MTQ5ClsgICAgMy45NjY2
ODRdICAgICAgICBbPGMzMTY3NWYyPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg4ZC8weGE5ZQpb
ICAgIDMuOTY2Njg0XSAgICAgICAgWzxjMzE3NTgzNT5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgy
NzAvMHg0NDgKWyAgICAzLjk2NjY4NF0gICAgICAgIFs8YzI4YWNlNmI+XSBwcm9jZXNzX29u
ZV93b3JrKzB4M2E0LzB4NmE4ClsgICAgMy45NjY2ODRdICAgICAgICBbPGMyOGFmMTBiPl0g
d29ya2VyX3RocmVhZCsweDM0OS8weDVkZApbICAgIDMuOTY2Njg0XSAgICAgICAgWzxjMjhi
YTgxNj5dIGt0aHJlYWQrMHgxM2YvMHgxNTIKWyAgICAzLjk2NjY4NF0gICAgICAgIFs8YzMx
N2ExODE+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjEvMHgzMApbICAgIDMuOTY2Njg0
XSAKWyAgICAzLjk2NjY4NF0gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcg
dGhpczoKWyAgICAzLjk2NjY4NF0gClsgICAgMy45NjY2ODRdIENoYWluIGV4aXN0cyBvZjoK
ICB0ZXh0X211dGV4IC0tPiBrcHJvYmVfaW5zbl9zbG90cy5tdXRleCAtLT4gbW9kdWxlX211
dGV4CgpbICAgIDMuOTY2Njg0XSAgUG9zc2libGUgdW5zYWZlIGxvY2tpbmcgc2NlbmFyaW86
ClsgICAgMy45NjY2ODRdIApbICAgIDMuOTY2Njg0XSAgICAgICAgQ1BVMCAgICAgICAgICAg
ICAgICAgICAgQ1BVMQpbICAgIDMuOTY2Njg0XSAgICAgICAgLS0tLSAgICAgICAgICAgICAg
ICAgICAgLS0tLQpbICAgIDMuOTY2Njg0XSAgIGxvY2sobW9kdWxlX211dGV4KTsKWyAgICAz
Ljk2NjY4NF0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxvY2soa3Byb2JlX2lu
c25fc2xvdHMubXV0ZXgpOwpbICAgIDMuOTY2Njg0XSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgbG9jayhtb2R1bGVfbXV0ZXgpOwpbICAgIDMuOTY2Njg0XSAgIGxvY2sodGV4
dF9tdXRleCk7ClsgICAgMy45NjY2ODRdIApbICAgIDMuOTY2Njg0XSAgKioqIERFQURMT0NL
ICoqKgpbICAgIDMuOTY2Njg0XSAKWyAgICAzLjk2NjY4NF0gNSBsb2NrcyBoZWxkIGJ5IGt3
b3JrZXIvMToxLzI1OgpbICAgIDMuOTY2Njg0XSAgIzA6ICAoImV2ZW50cyIpey4rLisuLn0s
IGF0OiBbPGMyOGFjZGRhPl0gcHJvY2Vzc19vbmVfd29yaysweDMxMy8weDZhOApbICAgIDMu
OTY2Njg0XSAgIzE6ICAoKG9wdGltaXppbmdfd29yaykud29yayl7Ky4rLi4ufSwgYXQ6IFs8
YzI4YWNkZGE+XSBwcm9jZXNzX29uZV93b3JrKzB4MzEzLzB4NmE4ClsgICAgMy45NjY2ODRd
ICAjMjogIChrcHJvYmVfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGMzMTc1NWU1Pl0ga3Byb2Jl
X29wdGltaXplcisweDIwLzB4NDQ4ClsgICAgMy45NjY2ODRdICAjMzogIChtb2R1bGVfbXV0
ZXgpeysuKy4uLn0sIGF0OiBbPGMzMTc1NWZmPl0ga3Byb2JlX29wdGltaXplcisweDNhLzB4
NDQ4ClsgICAgMy45NjY2ODRdICAjNDogIChjcHVfaG90cGx1Zy5sb2NrKXsrKysrKyt9LCBh
dDogWzxjMjg4MDJhZD5dIGdldF9vbmxpbmVfY3B1cysweDUxLzB4YzMKWyAgICAzLjk2NjY4
NF0gClsgICAgMy45NjY2ODRdIHN0YWNrIGJhY2t0cmFjZToKWyAgICAzLjk2NjY4NF0gQ1BV
OiAxIFBJRDogMjUgQ29tbToga3dvcmtlci8xOjEgTm90IHRhaW50ZWQgMy4xNC4wLXJjNy0w
ODA0OC1nMGU1NmM5MCAjMQpbICAgIDMuOTY2Njg0XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBC
b2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMy45NjY2ODRdIFdvcmtxdWV1ZTog
ZXZlbnRzIGtwcm9iZV9vcHRpbWl6ZXIKWyAgICAzLjk2NjY4NF0gIGQxZTU2MTUwIGQxN2Zk
ZDc0IGMzMTVlMmYwIGMzYThlMGFjIGQxN2ZkZGE0IGMzMTU2OGM0IGMzNDkxYjQ4IGMzNDkx
OGZhClsgICAgMy45NjY2ODRdICBjMzQ5MThjMiBjMzQ5MThlMyBjMzQ5MThjMiBkMWU1NjE1
MCBkMTdmZGRiOCBkMWU1NjVlMCBkMWU1NjYxMCBkMWU1NjE1MApbICAgIDMuOTY2Njg0XSAg
ZDE3ZmRkZTggYzI5MDA5NWEgZDFlNTY1ZTAgZDFlNTY1ZjggYzNjODVkNzQgYzI5MDA3N2Ug
MDAwMDAwMDkgYzNhOGRmOWMKWyAgICAzLjk2NjY4NF0gQ2FsbCBUcmFjZToKWyAgICAzLjk2
NjY4NF0gIFs8YzMxNWUyZjA+XSBkdW1wX3N0YWNrKzB4YjgvMHgxMDgKWyAgICAzLjk2NjY4
NF0gIFs8YzMxNTY4YzQ+XSBwcmludF9jaXJjdWxhcl9idWcrMHg1ZWMvMHg2MzgKWyAgICAz
Ljk2NjY4NF0gIFs8YzI5MDA5NWE+XSBjaGVja19wcmV2X2FkZCsweDFhYy8weGIzMwpbICAg
IDMuOTY2Njg0XSAgWzxjMjkwMDc3ZT5dID8gY2hlY2tfaXJxX3VzYWdlKzB4ZjAvMHgxMjAK
WyAgICAzLjk2NjY4NF0gIFs8YzI5MDQ0MDQ+XSA/IF9fbG9ja19hY3F1aXJlKzB4MjI2Yy8w
eDI5Y2MKWyAgICAzLjk2NjY4NF0gIFs8YzI5MDQ0MDQ+XSBfX2xvY2tfYWNxdWlyZSsweDIy
NmMvMHgyOWNjClsgICAgMy45NjY2ODRdICBbPGMyOTA0YzRjPl0gbG9ja19hY3F1aXJlKzB4
ZTgvMHgxNDkKWyAgICAzLjk2NjY4NF0gIFs8YzMxNzU4MzU+XSA/IGtwcm9iZV9vcHRpbWl6
ZXIrMHgyNzAvMHg0NDgKWyAgICAzLjk2NjY4NF0gIFs8YzMxNjc1ZjI+XSBtdXRleF9sb2Nr
X25lc3RlZCsweDhkLzB4YTllClsgICAgMy45NjY2ODRdICBbPGMzMTc1ODM1Pl0gPyBrcHJv
YmVfb3B0aW1pemVyKzB4MjcwLzB4NDQ4ClsgICAgMy45NjY2ODRdICBbPGMzMTZhYTY1Pl0g
PyBtdXRleF91bmxvY2srMHgxNi8weDI2ClsgICAgMy45NjY2ODRdICBbPGMyODgwMzBjPl0g
PyBnZXRfb25saW5lX2NwdXMrMHhiMC8weGMzClsgICAgMy45NjY2ODRdICBbPGMzMTc1ODM1
Pl0ga3Byb2JlX29wdGltaXplcisweDI3MC8weDQ0OApbICAgIDMuOTY2Njg0XSAgWzxjMjhh
Y2U2Yj5dIHByb2Nlc3Nfb25lX3dvcmsrMHgzYTQvMHg2YTgKWyAgICAzLjk2NjY4NF0gIFs8
YzI4YWNkZGE+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHgzMTMvMHg2YTgKWyAgICAzLjk2NjY4
NF0gIFs8YzI4YWYxMGI+XSB3b3JrZXJfdGhyZWFkKzB4MzQ5LzB4NWRkClsgICAgMy45NjY2
ODRdICBbPGMyOGFlZGMyPl0gPyBtYW5hZ2Vfd29ya2Vycy5pc3JhLjIwKzB4M2ZjLzB4M2Zj
ClsgICAgMy45NjY2ODRdICBbPGMyOGJhODE2Pl0ga3RocmVhZCsweDEzZi8weDE1MgpbICAg
IDMuOTY2Njg0XSAgWzxjMjhjMDAwMD5dID8gaHJ0aW1lcl9nZXRfbmV4dF9ldmVudCsweDEw
ZC8weDE0MwpbICAgIDMuOTY2Njg0XSAgWzxjMzE3YTE4MT5dIHJldF9mcm9tX2tlcm5lbF90
aHJlYWQrMHgyMS8weDMwClsgICAgMy45NjY2ODRdICBbPGMyOGJhNmQ3Pl0gPyBrdGhyZWFk
X3N0b3ArMHgxMDMvMHgxMDMKWyAgICA0LjI2MDA5M10gdHNjOiBSZWZpbmVkIFRTQyBjbG9j
a3NvdXJjZSBjYWxpYnJhdGlvbjogMjQ5My45ODUgTUh6Cgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jNC0wMzIzMDczMy8wZTU2YzkwYzEzMmI2NDQyN2M4YzU1ZmQ4NTAwM2VjMWYxN2Ri
YTZkL2RtZXNnLXlvY3RvLWl2eXRvd24yLTE3OjIwMTQwMzIzMTk0NTAwOmkzODYtcmFuZGNv
bmZpZy1jNC0wMzIzMDczMzozLjE0LjAtcmM3LTA4MDQ4LWcwZTU2YzkwOjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvMGU1NmM5MGMxMzJiNjQ0MjdjOGM1NWZkODUw
MDNlYzFmMTdkYmE2ZC9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTE2OjIwMTQwMzIzMTk0NTA1
OmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMzozLjE0LjAtcmM3LTA4MDQ4LWcwZTU2Yzkw
OjEKMzQ6Mjo0IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTIz
IDE5OjQ1OjI5IFJFUEVBVCBDT1VOVDogMjAwICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVw
ZWF0G1swbQoKQmlzZWN0aW5nOiA3NjQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbNjdhZTNiMzY3OTRkZTY5ZDU4ZTY2ZmI1MGJlMGZh
MGQ2ODU3NGMxN10gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAndGlwL2F1dG8tbGF0
ZXN0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvbmV4dDptYXN0ZXI6NjdhZTNi
MzY3OTRkZTY5ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNzpiaXNlY3QtdXNiCgoyMDE0LTAz
LTIzLTE5OjQ1OjM0IDY3YWUzYjM2Nzk0ZGU2OWQ1OGU2NmZiNTBiZTBmYTBkNjg1NzRjMTcg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTY3YWUzYjM2Nzk0ZGU2OWQ1OGU2NmZi
NTBiZTBmYTBkNjg1NzRjMTcKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jNC0wMzIzMDczMy82N2FlM2IzNjc5NGRlNjlkNThlNjZmYjUwYmUwZmEwZDY4
NTc0YzE3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtNjdhZTNiMzY3OTRkZTY5ZDU4ZTY2
ZmI1MGJlMGZhMGQ2ODU3NGMxNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy02N2FlM2Iz
Njc5NGRlNjlkNThlNjZmYjUwYmUwZmEwZDY4NTc0YzE3Cmtlcm5lbDogL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzQtMDMyMzA3MzMvNjdhZTNiMzY3OTRkZTY5ZDU4ZTY2ZmI1MGJlMGZh
MGQ2ODU3NGMxNy92bWxpbnV6LTMuMTQuMC1yYzctMDgwMzAtZzY3YWUzYjMKCjIwMTQtMDMt
MjMtMjA6MDA6MzQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLgkxLgkyLgk0CTUuLgk3Lgk4
CTkJMTQJMTUJMTgJMjAJMjIJMjYJMjkgVEVTVCBGQUlMVVJFClsgICAgNC4zNzQ1NThdIEtw
cm9iZSBzbW9rZSB0ZXN0IHN0YXJ0ZWQKWyAgICA0LjQ2Njg2MV0gClsgICAgNC40NjgxMDJd
ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQpbICAgIDQuNDcwMDQ3XSBbIElORk86IHBvc3NpYmxlIGNpcmN1bGFyIGxvY2tpbmcgZGVw
ZW5kZW5jeSBkZXRlY3RlZCBdClsgICAgNC40NzAwNDddIDMuMTQuMC1yYzctMDgwMzAtZzY3
YWUzYjMgIzEgTm90IHRhaW50ZWQKWyAgICA0LjQ3MDA0N10gLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgIDQuNDcwMDQ3XSBr
d29ya2VyLzA6MS8yNCBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpbICAgIDQuNDcwMDQ3
XSAgKHRleHRfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGM5Yjc1ODM1Pl0ga3Byb2JlX29wdGlt
aXplcisweDI3MC8weDQ0OApbICAgIDQuNDcwMDQ3XSAKWyAgICA0LjQ3MDA0N10gYnV0IHRh
c2sgaXMgYWxyZWFkeSBob2xkaW5nIGxvY2s6ClsgICAgNC40NzAwNDddICAobW9kdWxlX211
dGV4KXsrLisuLi59LCBhdDogWzxjOWI3NTVmZj5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgzYS8w
eDQ0OApbICAgIDQuNDcwMDQ3XSAKWyAgICA0LjQ3MDA0N10gd2hpY2ggbG9jayBhbHJlYWR5
IGRlcGVuZHMgb24gdGhlIG5ldyBsb2NrLgpbICAgIDQuNDcwMDQ3XSAKWyAgICA0LjQ3MDA0
N10gClsgICAgNC40NzAwNDddIHRoZSBleGlzdGluZyBkZXBlbmRlbmN5IGNoYWluIChpbiBy
ZXZlcnNlIG9yZGVyKSBpczoKWyAgICA0LjQ3MDA0N10gCi0+ICMyIChtb2R1bGVfbXV0ZXgp
eysuKy4uLn06ClsgICAgNC40NzAwNDddICAgICAgICBbPGM5MzA0NDEwPl0gX19sb2NrX2Fj
cXVpcmUrMHgyMjZjLzB4MjljYwpbICAgIDQuNDcwMDQ3XSAgICAgICAgWzxjOTMwNGM1OD5d
IGxvY2tfYWNxdWlyZSsweGU4LzB4MTQ5ClsgICAgNC40NzAwNDddICAgICAgICBbPGM5YjY3
NWYyPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg4ZC8weGE5ZQpbICAgIDQuNDcwMDQ3XSAgICAg
ICAgWzxjOTI1ZWZjZj5dIG1vZHVsZV9hbGxvYysweGEwLzB4MTUzClsgICAgNC40NzAwNDdd
ICAgICAgICBbPGM5MzY4ZDFlPl0gYWxsb2NfaW5zbl9wYWdlKzB4MWIvMHgyYgpbICAgIDQu
NDcwMDQ3XSAgICAgICAgWzxjOWI3NzE1YT5dIF9fZ2V0X2luc25fc2xvdCsweDFmZi8weDJh
OApbICAgIDQuNDcwMDQ3XSAgICAgICAgWzxjOWI3MTgxZj5dIGFyY2hfcHJlcGFyZV9rcHJv
YmUrMHg3Yi8weDFiNApbICAgIDQuNDcwMDQ3XSAgICAgICAgWzxjOWI3OTE1Yj5dIHJlZ2lz
dGVyX2twcm9iZSsweDg5Yi8weGIxZgpbICAgIDQuNDcwMDQ3XSAgICAgICAgWzxjOTM2NjBh
ZT5dIGluaXRfdGVzdF9wcm9iZXMrMHg4Yy8weDhlZApbICAgIDQuNDcwMDQ3XSAgICAgICAg
WzxjYTEyYzU5YT5dIGluaXRfa3Byb2JlcysweDI2MC8weDI4OApbICAgIDQuNDcwMDQ3XSAg
ICAgICAgWzxjOTIwMjFlMj5dIGRvX29uZV9pbml0Y2FsbCsweDEzMy8weDJiMgpbICAgIDQu
NDcwMDQ3XSAgICAgICAgWzxjYTBmOGFlZT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4NDgz
LzB4NWZmClsgICAgNC40NzAwNDddICAgICAgICBbPGM5YjRjZmY2Pl0ga2VybmVsX2luaXQr
MHgxNi8weDFmYQpbICAgIDQuNDcwMDQ3XSAgICAgICAgWzxjOWI3YTE4MT5dIHJldF9mcm9t
X2tlcm5lbF90aHJlYWQrMHgyMS8weDMwClsgICAgNC40NzAwNDddIAotPiAjMSAoa3Byb2Jl
X2luc25fc2xvdHMubXV0ZXgpeysuKy4rLn06ClsgICAgNC40NzAwNDddICAgICAgICBbPGM5
MzA0NDEwPl0gX19sb2NrX2FjcXVpcmUrMHgyMjZjLzB4MjljYwpbICAgIDQuNDcwMDQ3XSAg
ICAgICAgWzxjOTMwNGM1OD5dIGxvY2tfYWNxdWlyZSsweGU4LzB4MTQ5ClsgICAgNC40NzAw
NDddICAgICAgICBbPGM5YjY3NWYyPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg4ZC8weGE5ZQpb
ICAgIDQuNDcwMDQ3XSAgICAgICAgWzxjOWI3NmY3ZT5dIF9fZ2V0X2luc25fc2xvdCsweDIz
LzB4MmE4ClsgICAgNC40NzAwNDddICAgICAgICBbPGM5YjcxODFmPl0gYXJjaF9wcmVwYXJl
X2twcm9iZSsweDdiLzB4MWI0ClsgICAgNC40NzAwNDddICAgICAgICBbPGM5Yjc5MTViPl0g
cmVnaXN0ZXJfa3Byb2JlKzB4ODliLzB4YjFmClsgICAgNC40NzAwNDddICAgICAgICBbPGM5
MzY2MGFlPl0gaW5pdF90ZXN0X3Byb2JlcysweDhjLzB4OGVkClsgICAgNC40NzAwNDddICAg
ICAgICBbPGNhMTJjNTlhPl0gaW5pdF9rcHJvYmVzKzB4MjYwLzB4Mjg4ClsgICAgNC40NzAw
NDddICAgICAgICBbPGM5MjAyMWUyPl0gZG9fb25lX2luaXRjYWxsKzB4MTMzLzB4MmIyClsg
ICAgNC40NzAwNDddICAgICAgICBbPGNhMGY4YWVlPl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHg0ODMvMHg1ZmYKWyAgICA0LjQ3MDA0N10gICAgICAgIFs8YzliNGNmZjY+XSBrZXJuZWxf
aW5pdCsweDE2LzB4MWZhClsgICAgNC40NzAwNDddICAgICAgICBbPGM5YjdhMTgxPl0gcmV0
X2Zyb21fa2VybmVsX3RocmVhZCsweDIxLzB4MzAKWyAgICA0LjQ3MDA0N10gCi0+ICMwICh0
ZXh0X211dGV4KXsrLisuKy59OgpbICAgIDQuNDcwMDQ3XSAgICAgICAgWzxjOTMwMDk2Nj5d
IGNoZWNrX3ByZXZfYWRkKzB4MWFjLzB4YjMzClsgICAgNC40NzAwNDddICAgICAgICBbPGM5
MzA0NDEwPl0gX19sb2NrX2FjcXVpcmUrMHgyMjZjLzB4MjljYwpbICAgIDQuNDcwMDQ3XSAg
ICAgICAgWzxjOTMwNGM1OD5dIGxvY2tfYWNxdWlyZSsweGU4LzB4MTQ5ClsgICAgNC40NzAw
NDddICAgICAgICBbPGM5YjY3NWYyPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg4ZC8weGE5ZQpb
ICAgIDQuNDcwMDQ3XSAgICAgICAgWzxjOWI3NTgzNT5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgy
NzAvMHg0NDgKWyAgICA0LjQ3MDA0N10gICAgICAgIFs8YzkyYWNlNmU+XSBwcm9jZXNzX29u
ZV93b3JrKzB4M2E0LzB4NmE4ClsgICAgNC40NzAwNDddICAgICAgICBbPGM5MmFmMTBlPl0g
d29ya2VyX3RocmVhZCsweDM0OS8weDVkZApbICAgIDQuNDcwMDQ3XSAgICAgICAgWzxjOTJi
YTgxOT5dIGt0aHJlYWQrMHgxM2YvMHgxNTIKWyAgICA0LjQ3MDA0N10gICAgICAgIFs8Yzli
N2ExODE+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjEvMHgzMApbICAgIDQuNDcwMDQ3
XSAKWyAgICA0LjQ3MDA0N10gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcg
dGhpczoKWyAgICA0LjQ3MDA0N10gClsgICAgNC40NzAwNDddIENoYWluIGV4aXN0cyBvZjoK
ICB0ZXh0X211dGV4IC0tPiBrcHJvYmVfaW5zbl9zbG90cy5tdXRleCAtLT4gbW9kdWxlX211
dGV4CgpbICAgIDQuNDcwMDQ3XSAgUG9zc2libGUgdW5zYWZlIGxvY2tpbmcgc2NlbmFyaW86
ClsgICAgNC40NzAwNDddIApbICAgIDQuNDcwMDQ3XSAgICAgICAgQ1BVMCAgICAgICAgICAg
ICAgICAgICAgQ1BVMQpbICAgIDQuNDcwMDQ3XSAgICAgICAgLS0tLSAgICAgICAgICAgICAg
ICAgICAgLS0tLQpbICAgIDQuNDcwMDQ3XSAgIGxvY2sobW9kdWxlX211dGV4KTsKWyAgICA0
LjQ3MDA0N10gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxvY2soa3Byb2JlX2lu
c25fc2xvdHMubXV0ZXgpOwpbICAgIDQuNDcwMDQ3XSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgbG9jayhtb2R1bGVfbXV0ZXgpOwpbICAgIDQuNDcwMDQ3XSAgIGxvY2sodGV4
dF9tdXRleCk7ClsgICAgNC40NzAwNDddIApbICAgIDQuNDcwMDQ3XSAgKioqIERFQURMT0NL
ICoqKgpbICAgIDQuNDcwMDQ3XSAKWyAgICA0LjQ3MDA0N10gNSBsb2NrcyBoZWxkIGJ5IGt3
b3JrZXIvMDoxLzI0OgpbICAgIDQuNDcwMDQ3XSAgIzA6ICAoImV2ZW50cyIpey4rLisuLn0s
IGF0OiBbPGM5MmFjZGRkPl0gcHJvY2Vzc19vbmVfd29yaysweDMxMy8weDZhOApbICAgIDQu
NDcwMDQ3XSAgIzE6ICAoKG9wdGltaXppbmdfd29yaykud29yayl7Ky4rLi4ufSwgYXQ6IFs8
YzkyYWNkZGQ+XSBwcm9jZXNzX29uZV93b3JrKzB4MzEzLzB4NmE4ClsgICAgNC40NzAwNDdd
ICAjMjogIChrcHJvYmVfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGM5Yjc1NWU1Pl0ga3Byb2Jl
X29wdGltaXplcisweDIwLzB4NDQ4ClsgICAgNC40NzAwNDddICAjMzogIChtb2R1bGVfbXV0
ZXgpeysuKy4uLn0sIGF0OiBbPGM5Yjc1NWZmPl0ga3Byb2JlX29wdGltaXplcisweDNhLzB4
NDQ4ClsgICAgNC40NzAwNDddICAjNDogIChjcHVfaG90cGx1Zy5sb2NrKXsrKysrKyt9LCBh
dDogWzxjOTI4MDJiMD5dIGdldF9vbmxpbmVfY3B1cysweDUxLzB4YzMKWyAgICA0LjQ3MDA0
N10gClsgICAgNC40NzAwNDddIHN0YWNrIGJhY2t0cmFjZToKWyAgICA0LjQ3MDA0N10gQ1BV
OiAwIFBJRDogMjQgQ29tbToga3dvcmtlci8wOjEgTm90IHRhaW50ZWQgMy4xNC4wLXJjNy0w
ODAzMC1nNjdhZTNiMyAjMQpbICAgIDQuNDcwMDQ3XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBC
b2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgNC40NzAwNDddIFdvcmtxdWV1ZTog
ZXZlbnRzIGtwcm9iZV9vcHRpbWl6ZXIKWyAgICA0LjQ3MDA0N10gIGNkZTYwYWQwIGNkZjI5
ZDc0IGM5YjVlMmVkIGNhNDhhMGFjIGNkZjI5ZGE0IGM5YjU2OGMxIGM5ZTkxNTY4IGM5ZTkx
MzFhClsgICAgNC40NzAwNDddICBjOWU5MTJlMiBjOWU5MTMwMyBjOWU5MTJlMiBjZGU2MGFk
MCBjZGYyOWRiOCBjZGU2MGY2MCBjZGU2MGY5MCBjZGU2MGFkMApbICAgIDQuNDcwMDQ3XSAg
Y2RmMjlkZTggYzkzMDA5NjYgY2RlNjBmNjAgY2RlNjBmNzggY2E2ODFkYmMgYzkzMDA3OGEg
MDAwMDAwMDkgY2E0ODlmOWMKWyAgICA0LjQ3MDA0N10gQ2FsbCBUcmFjZToKWyAgICA0LjQ3
MDA0N10gIFs8YzliNWUyZWQ+XSBkdW1wX3N0YWNrKzB4YjgvMHgxMDgKWyAgICA0LjQ3MDA0
N10gIFs8YzliNTY4YzE+XSBwcmludF9jaXJjdWxhcl9idWcrMHg1ZWMvMHg2MzgKWyAgICA0
LjQ3MDA0N10gIFs8YzkzMDA5NjY+XSBjaGVja19wcmV2X2FkZCsweDFhYy8weGIzMwpbICAg
IDQuNDcwMDQ3XSAgWzxjOTMwMDc4YT5dID8gY2hlY2tfaXJxX3VzYWdlKzB4ZjAvMHgxMjAK
WyAgICA0LjQ3MDA0N10gIFs8YzkzMDQ0MTA+XSA/IF9fbG9ja19hY3F1aXJlKzB4MjI2Yy8w
eDI5Y2MKWyAgICA0LjQ3MDA0N10gIFs8YzkzMDQ0MTA+XSBfX2xvY2tfYWNxdWlyZSsweDIy
NmMvMHgyOWNjClsgICAgNC40NzAwNDddICBbPGM5MzA0YzU4Pl0gbG9ja19hY3F1aXJlKzB4
ZTgvMHgxNDkKWyAgICA0LjQ3MDA0N10gIFs8YzliNzU4MzU+XSA/IGtwcm9iZV9vcHRpbWl6
ZXIrMHgyNzAvMHg0NDgKWyAgICA0LjQ3MDA0N10gIFs8YzliNjc1ZjI+XSBtdXRleF9sb2Nr
X25lc3RlZCsweDhkLzB4YTllClsgICAgNC40NzAwNDddICBbPGM5Yjc1ODM1Pl0gPyBrcHJv
YmVfb3B0aW1pemVyKzB4MjcwLzB4NDQ4ClsgICAgNC40NzAwNDddICBbPGM5YjZhYTY1Pl0g
PyBtdXRleF91bmxvY2srMHgxNi8weDI2ClsgICAgNC40NzAwNDddICBbPGM5MjgwMzBmPl0g
PyBnZXRfb25saW5lX2NwdXMrMHhiMC8weGMzClsgICAgNC40NzAwNDddICBbPGM5Yjc1ODM1
Pl0ga3Byb2JlX29wdGltaXplcisweDI3MC8weDQ0OApbICAgIDQuNDcwMDQ3XSAgWzxjOTJh
Y2U2ZT5dIHByb2Nlc3Nfb25lX3dvcmsrMHgzYTQvMHg2YTgKWyAgICA0LjQ3MDA0N10gIFs8
YzkyYWNkZGQ+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHgzMTMvMHg2YTgKWyAgICA0LjQ3MDA0
N10gIFs8YzkyYWYxMGU+XSB3b3JrZXJfdGhyZWFkKzB4MzQ5LzB4NWRkClsgICAgNC40NzAw
NDddICBbPGM5MmFlZGM1Pl0gPyBtYW5hZ2Vfd29ya2Vycy5pc3JhLjIwKzB4M2ZjLzB4M2Zj
ClsgICAgNC40NzAwNDddICBbPGM5MmJhODE5Pl0ga3RocmVhZCsweDEzZi8weDE1MgpbICAg
IDQuNDcwMDQ3XSAgWzxjOTJjMDAwMD5dID8gaHJ0aW1lcl9nZXRfbmV4dF9ldmVudCsweDEw
ZC8weDE0MwpbICAgIDQuNDcwMDQ3XSAgWzxjOWI3YTE4MT5dIHJldF9mcm9tX2tlcm5lbF90
aHJlYWQrMHgyMS8weDMwClsgICAgNC40NzAwNDddICBbPGM5MmJhNmRhPl0gPyBrdGhyZWFk
X3N0b3ArMHgxMDMvMHgxMDMKWyAgICA0LjcyMzYxN10gdHNjOiBSZWZpbmVkIFRTQyBjbG9j
a3NvdXJjZSBjYWxpYnJhdGlvbjogMjg5Mi45ODEgTUh6Cgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jNC0wMzIzMDczMy82N2FlM2IzNjc5NGRlNjlkNThlNjZmYjUwYmUwZmEwZDY4NTc0
YzE3L2RtZXNnLXF1YW50YWwtY2Fpcm8tNDQ6MjAxNDAzMjMyMDExMjY6aTM4Ni1yYW5kY29u
ZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzctMDgwMzAtZzY3YWUzYjM6MQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy82N2FlM2IzNjc5NGRlNjlkNThlNjZmYjUwYmUw
ZmEwZDY4NTc0YzE3L2RtZXNnLXF1YW50YWwtbGtwLXNiMDQtMzc6MjAxNDAzMjQwNDExMjg6
aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzctMDgwMzAtZzY3YWUzYjM6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy82N2FlM2IzNjc5NGRlNjlk
NThlNjZmYjUwYmUwZmEwZDY4NTc0YzE3L2RtZXNnLXlvY3RvLWxrcC1zYjA0LTE6MjAxNDAz
MjQwNDExMjE6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzctMDgwMzAt
ZzY3YWUzYjM6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy82N2FlM2Iz
Njc5NGRlNjlkNThlNjZmYjUwYmUwZmEwZDY4NTc0YzE3L2RtZXNnLXlvY3RvLWxrcC1zYjA0
LTU5OjIwMTQwMzI0MDQxMTI3OmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMzozLjE0LjAt
cmM3LTA4MDMwLWc2N2FlM2IzOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3
MzMvNjdhZTNiMzY3OTRkZTY5ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNy9kbWVzZy15b2N0
by1sa3Atc2IwNC02MToyMDE0MDMyNDA0MTEzMjppMzg2LXJhbmRjb25maWctYzQtMDMyMzA3
MzM6My4xNC4wLXJjNy0wODAzMC1nNjdhZTNiMzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWM0LTAzMjMwNzMzLzY3YWUzYjM2Nzk0ZGU2OWQ1OGU2NmZiNTBiZTBmYTBkNjg1NzRjMTcv
ZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC0xNDoyMDE0MDMyNDA0MTEzNDppMzg2LXJhbmRjb25m
aWctYzQtMDMyMzA3MzM6My4xNC4wLXJjNy0wODAzMC1nNjdhZTNiMzoxCjI3OjY6OCBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiA3NDYgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbZTIyNGVmMDEwNzkwZDg3
M2M0NjcyYTQwOGY0NDJjMDhiOTAxNTY3Zl0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5j
aCAnc3BpL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvbmV4dDpt
YXN0ZXI6ZTIyNGVmMDEwNzkwZDg3M2M0NjcyYTQwOGY0NDJjMDhiOTAxNTY3ZjpiaXNlY3Qt
dXNiCgoyMDE0LTAzLTIzLTIwOjEyOjEzIGUyMjRlZjAxMDc5MGQ4NzNjNDY3MmE0MDhmNDQy
YzA4YjkwMTU2N2YgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLWUyMjRlZjAxMDc5
MGQ4NzNjNDY3MmE0MDhmNDQyYzA4YjkwMTU2N2YKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9lMjI0ZWYwMTA3OTBkODczYzQ2NzJh
NDA4ZjQ0MmMwOGI5MDE1NjdmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtZTIyNGVmMDEw
NzkwZDg3M2M0NjcyYTQwOGY0NDJjMDhiOTAxNTY3Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1jNC0wMzIz
MDczMy1lMjI0ZWYwMTA3OTBkODczYzQ2NzJhNDA4ZjQ0MmMwOGI5MDE1NjdmCmtlcm5lbDog
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvZTIyNGVmMDEwNzkwZDg3M2M0
NjcyYTQwOGY0NDJjMDhiOTAxNTY3Zi92bWxpbnV6LTMuMTQuMC1yYzctMDc0NzItZ2UyMjRl
ZjAKCjIwMTQtMDMtMjMtMjA6NDI6MTQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxNQkyMAkz
MQkzNAk0Mgk0OAk1Nwk2Mgk3NAkxMDAJMTE4CTE1MwkxOTgJMTk5LgkyMDAgU1VDQ0VTUwoK
bGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgcmVtb3RlLXRyYWNraW5nIGJyYW5j
aCAndGlwL2F1dG8tbGF0ZXN0JwpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQg
YmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgNjdhZTNiMzY3OTRkZTY5
ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNyBlMjI0ZWYwMTA3OTBkODczYzQ2NzJhNDA4ZjQ0
MmMwOGI5MDE1NjdmIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGUyMjRlZjAuLi4g
TWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnc3BpL2Zvci1uZXh0JwpIRUFEIGlzIG5v
dyBhdCA2ZTQ2NjQ1Li4uIExpbnV4IDMuMTEKQmlzZWN0aW5nOiAyODAgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpClthNDk3MTIzNDM2MTFl
YjJhY2E1MGIyMDM0OTEwZTg4NzNiNDUzMTE4XSBNZXJnZSBicmFuY2ggJ3BlcmYvY29yZScK
bGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91
c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWM0LTAzMjMwNzMzL25leHQ6bWFzdGVyOmE0OTcxMjM0MzYxMWViMmFjYTUw
YjIwMzQ5MTBlODg3M2I0NTMxMTg6YmlzZWN0LXVzYgoKMjAxNC0wMy0yMy0yMDo1MToyMSBh
NDk3MTIzNDM2MTFlYjJhY2E1MGIyMDM0OTEwZTg4NzNiNDUzMTE4IGNvbXBpbGluZwpRdWV1
ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNv
bmZpZy1jNC0wMzIzMDczMy1hNDk3MTIzNDM2MTFlYjJhY2E1MGIyMDM0OTEwZTg4NzNiNDUz
MTE4CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMy
MzA3MzMvYTQ5NzEyMzQzNjExZWIyYWNhNTBiMjAzNDkxMGU4ODczYjQ1MzExOAp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5k
Y29uZmlnLWM0LTAzMjMwNzMzLWE0OTcxMjM0MzYxMWViMmFjYTUwYjIwMzQ5MTBlODg3M2I0
NTMxMTgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlLy5pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtYTQ5NzEyMzQzNjExZWIyYWNhNTBi
MjAzNDkxMGU4ODczYjQ1MzExOAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0
LTAzMjMwNzMzL2E0OTcxMjM0MzYxMWViMmFjYTUwYjIwMzQ5MTBlODg3M2I0NTMxMTgvdm1s
aW51ei0zLjE0LjAtcmM3LTAwMzA2LWdhNDk3MTIzCgoyMDE0LTAzLTIzLTIwOjU2OjIxIGRl
dGVjdGluZyBib290IHN0YXRlIC4uLgkyCTUJMTMuCTE2CTIxCTI3CTQ0CTU2CTYzCTc0CTg5
CTEwNwkxMjUJMTMwCTEzNgkxNDUJMTU3CTE3MAkxNzUJMTc4CTE4NQkxOTMJMTk1LgkxOTcu
LgkxOTguLgkxOTkuLgkyMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMzkgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCls2MjZiZmUzOTZiOGJm
ZTBjMmM5NGZlNDRiYzk4NTEwM2FiZmU0YjZmXSBNZXJnZSBicmFuY2ggJ3g4Ni9hcGljJwpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvbmV4dDptYXN0ZXI6NjI2YmZlMzk2Yjhi
ZmUwYzJjOTRmZTQ0YmM5ODUxMDNhYmZlNGI2ZjpiaXNlY3QtdXNiCgoyMDE0LTAzLTIzLTIx
OjE1OjI4IDYyNmJmZTM5NmI4YmZlMGMyYzk0ZmU0NGJjOTg1MTAzYWJmZTRiNmYgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTYyNmJmZTM5NmI4YmZlMGMyYzk0ZmU0NGJjOTg1
MTAzYWJmZTRiNmYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jNC0wMzIzMDczMy82MjZiZmUzOTZiOGJmZTBjMmM5NGZlNDRiYzk4NTEwM2FiZmU0YjZm
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtNjI2YmZlMzk2YjhiZmUwYzJjOTRmZTQ0YmM5
ODUxMDNhYmZlNGI2Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy02MjZiZmUzOTZiOGJm
ZTBjMmM5NGZlNDRiYzk4NTEwM2FiZmU0YjZmCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzQtMDMyMzA3MzMvNjI2YmZlMzk2YjhiZmUwYzJjOTRmZTQ0YmM5ODUxMDNhYmZl
NGI2Zi92bWxpbnV6LTMuMTQuMC1yYzctMDA0NDgtZzYyNmJmZTMKCjIwMTQtMDMtMjMtMjE6
MzY6MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxCTQJNi4JOQkyOAkzMwk1NAk3OQk5NAkx
MTcJMTIxCTEyMgkxNDMJMTU5CTE3NwkxODMJMTk3CTIwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6
IDg1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBz
KQpbNzJhNTAwNDUzYTc3ZTA5ODBjMGMyYjRlZDlmZThiNTIxZTdhYzUyM10gTWVyZ2UgYnJh
bmNoICd4ODYvZGVidWcnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9uZXh0Om1h
c3Rlcjo3MmE1MDA0NTNhNzdlMDk4MGMwYzJiNGVkOWZlOGI1MjFlN2FjNTIzOmJpc2VjdC11
c2IKCjIwMTQtMDMtMjMtMjE6NDY6MzQgNzJhNTAwNDUzYTc3ZTA5ODBjMGMyYjRlZDlmZThi
NTIxZTdhYzUyMyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtNzJhNTAwNDUzYTc3
ZTA5ODBjMGMyYjRlZDlmZThiNTIxZTdhYzUyMwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzcyYTUwMDQ1M2E3N2UwOTgwYzBjMmI0
ZWQ5ZmU4YjUyMWU3YWM1MjMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy03MmE1MDA0NTNh
NzdlMDk4MGMwYzJiNGVkOWZlOGI1MjFlN2FjNTIzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMw
NzMzLTcyYTUwMDQ1M2E3N2UwOTgwYzBjMmI0ZWQ5ZmU4YjUyMWU3YWM1MjMKa2VybmVsOiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy83MmE1MDA0NTNhNzdlMDk4MGMw
YzJiNGVkOWZlOGI1MjFlN2FjNTIzL3ZtbGludXotMy4xNC4wLXJjNy0wMDUwMi1nNzJhNTAw
NAoKMjAxNC0wMy0yMy0yMjowNTozNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTIJMwk4CTIx
CTMyCTU1CTg4CTEwNQkxMjUJMTM2CTE1MQkxNjAJMTcwCTE3OAkxODkuCTE5MAkxOTIJMTk1
Li4uLgkxOTYJMTk3Li4uLi4JMTk4Li4uLgkxOTkuLgkyMDAgU1VDQ0VTUwoKQmlzZWN0aW5n
OiA0MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVw
cykKW2M1MTlkYjdhMTAyMjhkNWYwZDZiYWYzZGVhYTJjODY5ZjhiNTdiYjldIE1lcmdlIGJy
YW5jaCAneDg2L2thc2xyJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvbmV4dDpt
YXN0ZXI6YzUxOWRiN2ExMDIyOGQ1ZjBkNmJhZjNkZWFhMmM4NjlmOGI1N2JiOTpiaXNlY3Qt
dXNiCgoyMDE0LTAzLTIzLTIyOjI1OjM4IGM1MTlkYjdhMTAyMjhkNWYwZDZiYWYzZGVhYTJj
ODY5ZjhiNTdiYjkgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLWM1MTlkYjdhMTAy
MjhkNWYwZDZiYWYzZGVhYTJjODY5ZjhiNTdiYjkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9jNTE5ZGI3YTEwMjI4ZDVmMGQ2YmFm
M2RlYWEyYzg2OWY4YjU3YmI5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtYzUxOWRiN2Ex
MDIyOGQ1ZjBkNmJhZjNkZWFhMmM4NjlmOGI1N2JiOQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1jNC0wMzIz
MDczMy1jNTE5ZGI3YTEwMjI4ZDVmMGQ2YmFmM2RlYWEyYzg2OWY4YjU3YmI5Cmtlcm5lbDog
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvYzUxOWRiN2ExMDIyOGQ1ZjBk
NmJhZjNkZWFhMmM4NjlmOGI1N2JiOS92bWxpbnV6LTMuMTQuMC1yYzctMDA1NDQtZ2M1MTlk
YjcKCjIwMTQtMDMtMjMtMjI6NDQ6MzggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLgkzCTUu
CTcJMTIJMTMJMTQJMTgJMjUJMzYJNDYJNTcJNjUuLi4uIFRFU1QgRkFJTFVSRQpbICAgIDEu
ODcyMTk4XSBJbml0cmFtZnMgdW5wYWNraW5nIGZhaWxlZDoganVuayBpbiBjb21wcmVzc2Vk
IGFyY2hpdmUKWyAgICAxLjg3NDM5MF0gZGVidWc6IHVubWFwcGluZyBpbml0IFttZW0gMHhk
MjdhYjAwMC0weGQzZmVmZmZmXQoKQlVHOiBrZXJuZWwgYm9vdCBjcmFzaGVkCkVsYXBzZWQg
dGltZTogMTUKcWVtdS1zeXN0ZW0teDg2XzY0IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0gLWtl
cm5lbCAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9jNTE5ZGI3YTEwMjI4
ZDVmMGQ2YmFmM2RlYWEyYzg2OWY4YjU3YmI5L3ZtbGludXotMy4xNC4wLXJjNy0wMDU0NC1n
YzUxOWRiNyAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwx
MTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5y
Y3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBu
bWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUy
MDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9u
ZXh0Om1hc3RlcjpjNTE5ZGI3YTEwMjI4ZDVmMGQ2YmFmM2RlYWEyYzg2OWY4YjU3YmI5OmJp
c2VjdC11c2IvLnZtbGludXotYzUxOWRiN2ExMDIyOGQ1ZjBkNmJhZjNkZWFhMmM4NjlmOGI1
N2JiOS0yMDE0MDMyMzIyNDQxNy02NS1pdnl0b3duMiBicmFuY2g9bmV4dC9tYXN0ZXIgQk9P
VF9JTUFHRT0va2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9jNTE5ZGI3YTEw
MjI4ZDVmMGQ2YmFmM2RlYWEyYzg2OWY4YjU3YmI5L3ZtbGludXotMy4xNC4wLXJjNy0wMDU0
NC1nYzUxOWRiNyBkcmJkLm1pbm9yX2NvdW50PTgnICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMv
aW5pdHJkL3F1YW50YWwtY29yZS1pMzg2LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQgbmljLHZs
YW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0xLGhvc3Rmd2Q9dGNwOjo0MTQ1NC06
MjIgLWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBi
YXNlPWxvY2FsdGltZSAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1pdnl0
b3duMi04MSAtc2VyaWFsIGZpbGU6L2Rldi9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwtaXZ5
dG93bjItODEgLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzL2M1MTlkYjdhMTAyMjhkNWYwZDZiYWYz
ZGVhYTJjODY5ZjhiNTdiYjkvZG1lc2cteW9jdG8tbGtwLXNiMDQtMTU6MjAxNDAzMjQwNjU0
NTk6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzctMDA1NDQtZ2M1MTlk
Yjc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9jNTE5ZGI3YTEwMjI4
ZDVmMGQ2YmFmM2RlYWEyYzg2OWY4YjU3YmI5L2RtZXNnLXlvY3RvLWxrcC1zYjA0LTI4OjIw
MTQwMzI0MDY1NDU5OmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMzozLjE0LjAtcmM3LTAw
NTQ0LWdjNTE5ZGI3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvYzUx
OWRiN2ExMDIyOGQ1ZjBkNmJhZjNkZWFhMmM4NjlmOGI1N2JiOS9kbWVzZy15b2N0by14aWFu
LTEzOjIwMTQwMzIzMjI1NTAwOmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMzozLjE0LjAt
cmM3LTAwNTQ0LWdjNTE5ZGI3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3
MzMvYzUxOWRiN2ExMDIyOGQ1ZjBkNmJhZjNkZWFhMmM4NjlmOGI1N2JiOS9kbWVzZy1xdWFu
dGFsLXhpYW4tMjQ6MjAxNDAzMjMyMjU1MDM6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMz
OjMuMTQuMC1yYzctMDA1NDQtZ2M1MTlkYjc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
NC0wMzIzMDczMy9jNTE5ZGI3YTEwMjI4ZDVmMGQ2YmFmM2RlYWEyYzg2OWY4YjU3YmI5L2Rt
ZXNnLXlvY3RvLWxrcC1zYjA0LTY6MjAxNDAzMjQwNjU1MDU6aTM4Ni1yYW5kY29uZmlnLWM0
LTAzMjMwNzMzOjMuMTQuMC1yYzctMDA1NDQtZ2M1MTlkYjc6MQo2MTo1OjcgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMjYgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpClszZGI0Y2FmZGZkMDU3MTdkYzkzOTc4
MDEzNGU1MzAyM2EzYzFmMTVmXSB4ODYvYm9vdDogRml4IG5vbi1FRkkgYnVpbGQKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzL25leHQ6bWFzdGVyOjNkYjRjYWZkZmQwNTcxN2Rj
OTM5NzgwMTM0ZTUzMDIzYTNjMWYxNWY6YmlzZWN0LXVzYgoKMjAxNC0wMy0yMy0yMjo1NTox
NSAzZGI0Y2FmZGZkMDU3MTdkYzkzOTc4MDEzNGU1MzAyM2EzYzFmMTVmIGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1jNC0wMzIzMDczMy0zZGI0Y2FmZGZkMDU3MTdkYzkzOTc4MDEzNGU1MzAyM2Ez
YzFmMTVmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQt
MDMyMzA3MzMvM2RiNGNhZmRmZDA1NzE3ZGM5Mzk3ODAxMzRlNTMwMjNhM2MxZjE1Zgp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLWM0LTAzMjMwNzMzLTNkYjRjYWZkZmQwNTcxN2RjOTM5NzgwMTM0ZTUzMDIz
YTNjMWYxNWYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtM2RiNGNhZmRmZDA1NzE3ZGM5
Mzk3ODAxMzRlNTMwMjNhM2MxZjE1ZgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWM0LTAzMjMwNzMzLzNkYjRjYWZkZmQwNTcxN2RjOTM5NzgwMTM0ZTUzMDIzYTNjMWYxNWYv
dm1saW51ei0zLjE0LjAtcmMzLTAwMDE1LWczZGI0Y2FmCgoyMDE0LTAzLTIzLTIzOjE4OjE1
IGRldGVjdGluZyBib290IHN0YXRlIC4JMQk1CTE4CTI3CTMwCTM0Li4JNDAJNDcJNTEuCTUz
CTU4CTYwCTY1CTY2CTY3CTcyCTc5CTg4CTEwMQkxMTAJMTE5CTEyMwkxMjYuLgkxMzkJMTYx
CTE5NQkxOTguCTE5OS4uLi4uLi4uLi4uLi4JMjAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTMg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpCls0
ZmQ2OTMzMWFkMjI3YTRkOGRlMjY1OTJkMDE3YjczZTAwY2FjYTlmXSBNZXJnZSByZW1vdGUt
dHJhY2tpbmcgYnJhbmNoICd0aXAveDg2L3VyZ2VudCcgaW50byBlZmktZm9yLW1pbmdvCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9t
ZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9uZXh0Om1hc3Rlcjo0ZmQ2OTMzMWFkMjI3
YTRkOGRlMjY1OTJkMDE3YjczZTAwY2FjYTlmOmJpc2VjdC11c2IKCjIwMTQtMDMtMjMtMjM6
NDI6NTIgNGZkNjkzMzFhZDIyN2E0ZDhkZTI2NTkyZDAxN2I3M2UwMGNhY2E5ZiBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctYzQtMDMyMzA3MzMtNGZkNjkzMzFhZDIyN2E0ZDhkZTI2NTkyZDAxN2I3
M2UwMGNhY2E5ZgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWM0LTAzMjMwNzMzLzRmZDY5MzMxYWQyMjdhNGQ4ZGUyNjU5MmQwMTdiNzNlMDBjYWNhOWYK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kz
ODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy00ZmQ2OTMzMWFkMjI3YTRkOGRlMjY1OTJkMDE3
YjczZTAwY2FjYTlmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9i
dWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTRmZDY5MzMxYWQyMjdh
NGQ4ZGUyNjU5MmQwMTdiNzNlMDBjYWNhOWYKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jNC0wMzIzMDczMy80ZmQ2OTMzMWFkMjI3YTRkOGRlMjY1OTJkMDE3YjczZTAwY2Fj
YTlmL3ZtbGludXotMy4xNC4wLXJjNS0wMDAxNi1nNGZkNjkzMwoKMjAxNC0wMy0yNC0wMDow
Nzo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uCTQuCTExCTE2CTI5CTUx
CTYyCTc4CTgzCTEyMQkxMzYJMTYxCTE5OC4uLi4uLi4JMTk5Li4uLi4uLgkyMDAgU1VDQ0VT
UwoKQmlzZWN0aW5nOiA3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAzIHN0ZXBzKQpbNGY3MmMxMWFlMWYwMWJmYzY1ZmFmNzY4N2I3ZmRhYjVhYjVlZDA0
YV0gTWVyZ2UgYnJhbmNoICd4ODYvZWZpJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3
MzMvbmV4dDptYXN0ZXI6NGY3MmMxMWFlMWYwMWJmYzY1ZmFmNzY4N2I3ZmRhYjVhYjVlZDA0
YTpiaXNlY3QtdXNiCgoyMDE0LTAzLTI0LTAwOjI4OjU3IDRmNzJjMTFhZTFmMDFiZmM2NWZh
Zjc2ODdiN2ZkYWI1YWI1ZWQwNGEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTRm
NzJjMTFhZTFmMDFiZmM2NWZhZjc2ODdiN2ZkYWI1YWI1ZWQwNGEKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy80ZjcyYzExYWUxZjAx
YmZjNjVmYWY3Njg3YjdmZGFiNWFiNWVkMDRhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMt
NGY3MmMxMWFlMWYwMWJmYzY1ZmFmNzY4N2I3ZmRhYjVhYjVlZDA0YQp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZp
Zy1jNC0wMzIzMDczMy00ZjcyYzExYWUxZjAxYmZjNjVmYWY3Njg3YjdmZGFiNWFiNWVkMDRh
Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvNGY3MmMxMWFl
MWYwMWJmYzY1ZmFmNzY4N2I3ZmRhYjVhYjVlZDA0YS92bWxpbnV6LTMuMTQuMC1yYzctMDA1
MzYtZzRmNzJjMTEKCjIwMTQtMDMtMjQtMDA6NTI6NTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4uLgkxCTQuCTYJMTQuCTIwCTIyCTMzCTM5Lgk1MAk1MQk3Mwk4NQkxMjgJMTU0CTE3OQkx
OTkJMjAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzlkOTBiMmNhNTRhZDhiMGI5ZjNmZjIwZTlh
OTNmYjA3NDUwYjBmYjFdIE1lcmdlIGJyYW5jaCAneDg2L2hhc2gnCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1jNC0wMzIzMDczMy9uZXh0Om1hc3Rlcjo5ZDkwYjJjYTU0YWQ4YjBiOWYzZmYyMGU5
YTkzZmIwNzQ1MGIwZmIxOmJpc2VjdC11c2IKCjIwMTQtMDMtMjQtMDE6MDQ6NTkgOWQ5MGIy
Y2E1NGFkOGIwYjlmM2ZmMjBlOWE5M2ZiMDc0NTBiMGZiMSBjb21waWxpbmcKUXVldWVkIGJ1
aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
YzQtMDMyMzA3MzMtOWQ5MGIyY2E1NGFkOGIwYjlmM2ZmMjBlOWE5M2ZiMDc0NTBiMGZiMQpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMz
LzlkOTBiMmNhNTRhZDhiMGI5ZjNmZjIwZTlhOTNmYjA3NDUwYjBmYjEKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1jNC0wMzIzMDczMy05ZDkwYjJjYTU0YWQ4YjBiOWYzZmYyMGU5YTkzZmIwNzQ1MGIwZmIx
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8u
aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTlkOTBiMmNhNTRhZDhiMGI5ZjNmZjIwZTlh
OTNmYjA3NDUwYjBmYjEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIz
MDczMy85ZDkwYjJjYTU0YWQ4YjBiOWYzZmYyMGU5YTkzZmIwNzQ1MGIwZmIxL3ZtbGludXot
My4xNC4wLXJjNy0wMDU0MC1nOWQ5MGIyYwoKMjAxNC0wMy0yNC0wMTozNzowMCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLi4uLgkzLgkxMQkyNgkzOAk3NwkxMTgJMTMzCTEzNgkxNjAJMTg5
CTE5NAkxOTUuLgkxOTYuLi4JMTk3Li4JMTk4CTE5OS4uLi4JMjAwIFNVQ0NFU1MKCkJpc2Vj
dGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0
ZXApCls1NjRjZTYwNjkyNGUzNzg4MjUxMThhOTU5MzdkOWIwM2E2ZjFkMWJmXSBNZXJnZSBi
cmFuY2ggJ3g4Ni9pb21tdScKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzL25leHQ6
bWFzdGVyOjU2NGNlNjA2OTI0ZTM3ODgyNTExOGE5NTkzN2Q5YjAzYTZmMWQxYmY6YmlzZWN0
LXVzYgoKMjAxNC0wMy0yNC0wMTo1NDowMiA1NjRjZTYwNjkyNGUzNzg4MjUxMThhOTU5Mzdk
OWIwM2E2ZjFkMWJmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy01NjRjZTYwNjky
NGUzNzg4MjUxMThhOTU5MzdkOWIwM2E2ZjFkMWJmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvNTY0Y2U2MDY5MjRlMzc4ODI1MTE4
YTk1OTM3ZDliMDNhNmYxZDFiZgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTU2NGNlNjA2
OTI0ZTM3ODgyNTExOGE5NTkzN2Q5YjAzYTZmMWQxYmYKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYzQtMDMy
MzA3MzMtNTY0Y2U2MDY5MjRlMzc4ODI1MTE4YTk1OTM3ZDliMDNhNmYxZDFiZgprZXJuZWw6
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzU2NGNlNjA2OTI0ZTM3ODgy
NTExOGE5NTkzN2Q5YjAzYTZmMWQxYmYvdm1saW51ei0zLjE0LjAtcmM3LTAwNTQyLWc1NjRj
ZTYwCgoyMDE0LTAzLTI0LTAyOjAxOjAyIGRldGVjdGluZyBib290IHN0YXRlIC4uCTMJMTIJ
MjEJMjgJMzcJNDkJNzgJMTAwCTEzMAkxNDYJMTg4CTE5NAkxOTYJMTk3CTE5OC4JMTk5Li4u
Li4uLi4uLgkyMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbZTJiMzJlNjc4NTEzOGQ5MmQyYTQw
ZTBkMDQ3MzU3NWM4YzczMTBhMl0geDg2LCBrYXNscjogcmFuZG9taXplIG1vZHVsZSBiYXNl
IGxvYWQgYWRkcmVzcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvbmV4dDptYXN0
ZXI6ZTJiMzJlNjc4NTEzOGQ5MmQyYTQwZTBkMDQ3MzU3NWM4YzczMTBhMjpiaXNlY3QtdXNi
CgoyMDE0LTAzLTI0LTAyOjE2OjA0IGUyYjMyZTY3ODUxMzhkOTJkMmE0MGUwZDA0NzM1NzVj
OGM3MzEwYTIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLWUyYjMyZTY3ODUxMzhk
OTJkMmE0MGUwZDA0NzM1NzVjOGM3MzEwYTIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9lMmIzMmU2Nzg1MTM4ZDkyZDJhNDBlMGQw
NDczNTc1YzhjNzMxMGEyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMtZTJiMzJlNjc4NTEz
OGQ5MmQyYTQwZTBkMDQ3MzU3NWM4YzczMTBhMgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDcz
My1lMmIzMmU2Nzg1MTM4ZDkyZDJhNDBlMGQwNDczNTc1YzhjNzMxMGEyCmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvZTJiMzJlNjc4NTEzOGQ5MmQyYTQw
ZTBkMDQ3MzU3NWM4YzczMTBhMi92bWxpbnV6LTMuMTQuMC1yYzQtMDAwMDEtZ2UyYjMyZTYK
CjIwMTQtMDMtMjQtMDI6Mzc6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTIuCTggVEVTVCBG
QUlMVVJFClsgICAgMS4yMzU4NjldIFVucGFja2luZyBpbml0cmFtZnMuLi4KWyAgICAxLjIz
Nzk0Ml0gSW5pdHJhbWZzIHVucGFja2luZyBmYWlsZWQ6IGp1bmsgaW4gY29tcHJlc3NlZCBh
cmNoaXZlClsgICAgMS4yNDAwODddIGRlYnVnOiB1bm1hcHBpbmcgaW5pdCBbbWVtIDB4Y2U3
YWIwMDAtMHhjZmZlZmZmZl0KWyAgICAxLjI0MjM4Ml0gQlVHOiB1bmFibGUgdG8gaGFuZGxl
IGtlcm5lbCBwYWdpbmcgcmVxdWVzdApFbGFwc2VkIHRpbWU6IDUKcWVtdS1zeXN0ZW0teDg2
XzY0IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0gLWtlcm5lbCAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jNC0wMzIzMDczMy9lMmIzMmU2Nzg1MTM4ZDkyZDJhNDBlMGQwNDczNTc1YzhjNzMx
MGEyL3ZtbGludXotMy4xNC4wLXJjNC0wMDAwMS1nZTJiMzJlNiAtYXBwZW5kICdodW5nX3Rh
c2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBz
eXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAw
IHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21w
dF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3Jt
YWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9uZXh0Om1hc3RlcjplMmIzMmU2Nzg1MTM4
ZDkyZDJhNDBlMGQwNDczNTc1YzhjNzMxMGEyOmJpc2VjdC11c2IvLnZtbGludXotZTJiMzJl
Njc4NTEzOGQ5MmQyYTQwZTBkMDQ3MzU3NWM4YzczMTBhMi0yMDE0MDMyNDAyMzY0OC0xMTEt
YXRoZW5zIGJyYW5jaD1uZXh0L21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWM0LTAzMjMwNzMzL2UyYjMyZTY3ODUxMzhkOTJkMmE0MGUwZDA0NzM1NzVjOGM3
MzEwYTIvdm1saW51ei0zLjE0LjAtcmM0LTAwMDAxLWdlMmIzMmU2IGRyYmQubWlub3JfY291
bnQ9OCcgIC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLWkzODYu
Y2d6IC1tIDI1NiAtc21wIDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNl
cix2bGFuPTEsaG9zdGZ3ZD10Y3A6OjEwMTMxLToyMiAtYm9vdCBvcmRlcj1uYyAtbm8tcmVi
b290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1kcml2ZSBmaWxl
PS9mcy9MQUJFTD1LVk0vZGlzazAtcXVhbnRhbC1hdGhlbnMtNSxtZWRpYT1kaXNrLGlmPXZp
cnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2sxLXF1YW50YWwtYXRoZW5zLTUs
bWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrMi1x
dWFudGFsLWF0aGVucy01LG1lZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9M
QUJFTD1LVk0vZGlzazMtcXVhbnRhbC1hdGhlbnMtNSxtZWRpYT1kaXNrLGlmPXZpcnRpbyAt
ZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2s0LXF1YW50YWwtYXRoZW5zLTUsbWVkaWE9
ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrNS1xdWFudGFs
LWF0aGVucy01LG1lZGlhPWRpc2ssaWY9dmlydGlvIC1waWRmaWxlIC9kZXYvc2htL2tib290
L3BpZC1xdWFudGFsLWF0aGVucy01IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJp
YWwtcXVhbnRhbC1hdGhlbnMtNSAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3Ig
bnVsbCAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvZTJiMzJlNjc4NTEz
OGQ5MmQyYTQwZTBkMDQ3MzU3NWM4YzczMTBhMi9kbWVzZy1xdWFudGFsLWlubi00MjoyMDE0
MDMyNDAyMzgwNTppMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzM6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jNC0wMzIzMDczMy9lMmIzMmU2Nzg1MTM4ZDkyZDJhNDBlMGQwNDczNTc1
YzhjNzMxMGEyL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMjk6MjAxNDAzMjQwMjM4MDk6aTM4
Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzQtMDAwMDEtZ2UyYjMyZTY6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9lMmIzMmU2Nzg1MTM4ZDkyZDJh
NDBlMGQwNDczNTc1YzhjNzMxMGEyL2RtZXNnLXlvY3RvLWNhaXJvLTE6MjAxNDAzMjQwMjM4
MTI6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzQtMDAwMDEtZ2UyYjMy
ZTY6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy9lMmIzMmU2Nzg1MTM4
ZDkyZDJhNDBlMGQwNDczNTc1YzhjNzMxMGEyL2RtZXNnLXlvY3RvLWNhaXJvLTMwOjIwMTQw
MzI0MDIzODEyOmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMzozLjE0LjAtcmM0LTAwMDAx
LWdlMmIzMmU2OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvZTJiMzJl
Njc4NTEzOGQ5MmQyYTQwZTBkMDQ3MzU3NWM4YzczMTBhMi9kbWVzZy15b2N0by1pdnl0b3du
Mi0xMDoyMDE0MDMyNDAyMzgxMzppMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzM6My4xNC4w
LXJjNC0wMDAwMS1nZTJiMzJlNjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMw
NzMzL2UyYjMyZTY3ODUxMzhkOTJkMmE0MGUwZDA0NzM1NzVjOGM3MzEwYTIvZG1lc2cteW9j
dG8tcm9hbS00NToyMDE0MDMyNDAyMzgxMzppMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzM6
My4xNC4wLXJjNC0wMDAwMS1nZTJiMzJlNjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0
LTAzMjMwNzMzL2UyYjMyZTY3ODUxMzhkOTJkMmE0MGUwZDA0NzM1NzVjOGM3MzEwYTIvZG1l
c2cteW9jdG8tcm9hbS03OjIwMTQwMzI0MDIzODE1OmkzODYtcmFuZGNvbmZpZy1jNC0wMzIz
MDczMzozLjE0LjAtcmM0LTAwMDAxLWdlMmIzMmU2OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzQtMDMyMzA3MzMvZTJiMzJlNjc4NTEzOGQ5MmQyYTQwZTBkMDQ3MzU3NWM4YzczMTBh
Mi9kbWVzZy15b2N0by1zbmItNDE6MjAxNDAzMjQwMjM4MTY6aTM4Ni1yYW5kY29uZmlnLWM0
LTAzMjMwNzMzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvZTJiMzJl
Njc4NTEzOGQ5MmQyYTQwZTBkMDQ3MzU3NWM4YzczMTBhMi9kbWVzZy15b2N0by14aWFuLTI0
OjIwMTQwMzI0MDIzODIxOmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMzozLjE0LjAtcmM0
LTAwMDAxLWdlMmIzMmU2OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMv
ZTJiMzJlNjc4NTEzOGQ5MmQyYTQwZTBkMDQ3MzU3NWM4YzczMTBhMi9kbWVzZy1xdWFudGFs
LWNhaXJvLTI1OjIwMTQwMzI0MDIzODIzOmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMzoz
LjE0LjAtcmM0LTAwMDAxLWdlMmIzMmU2OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQt
MDMyMzA3MzMvZTJiMzJlNjc4NTEzOGQ5MmQyYTQwZTBkMDQ3MzU3NWM4YzczMTBhMi9kbWVz
Zy15b2N0by1pdnl0b3duMi04NjoyMDE0MDMyNDAyMzgyMzppMzg2LXJhbmRjb25maWctYzQt
MDMyMzA3MzM6My4xNC4wLXJjNC0wMDAwMS1nZTJiMzJlNjoxCjY6MTE6MTMgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKCmUyYjMyZTY3ODUxMzhkOTJkMmE0MGUwZDA0NzM1NzVjOGM3
MzEwYTIgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IGUyYjMyZTY3ODUxMzhkOTJk
MmE0MGUwZDA0NzM1NzVjOGM3MzEwYTIKQXV0aG9yOiBLZWVzIENvb2sgPGtlZXNjb29rQGNo
cm9taXVtLm9yZz4KRGF0ZTogICBUdWUgRmViIDI1IDE2OjU5OjE3IDIwMTQgLTA4MDAKCiAg
ICB4ODYsIGthc2xyOiByYW5kb21pemUgbW9kdWxlIGJhc2UgbG9hZCBhZGRyZXNzCiAgICAK
ICAgIFJhbmRvbWl6ZSB0aGUgbG9hZCBhZGRyZXNzIG9mIG1vZHVsZXMgaW4gdGhlIGtlcm5l
bCB0byBtYWtlIGtBU0xSCiAgICBlZmZlY3RpdmUgZm9yIG1vZHVsZXMuICBNb2R1bGVzIGNh
biBvbmx5IGJlIGxvYWRlZCB3aXRoaW4gYSBwYXJ0aWN1bGFyCiAgICByYW5nZSBvZiB2aXJ0
dWFsIGFkZHJlc3Mgc3BhY2UuICBUaGlzIHBhdGNoIGFkZHMgMTAgYml0cyBvZiBlbnRyb3B5
IHRvCiAgICB0aGUgbG9hZCBhZGRyZXNzIGJ5IGFkZGluZyAxLTEwMjQgKiBQQUdFX1NJWkUg
dG8gdGhlIGJlZ2lubmluZyByYW5nZQogICAgd2hlcmUgbW9kdWxlcyBhcmUgbG9hZGVkLgog
ICAgCiAgICBUaGUgc2luZ2xlIGJhc2Ugb2Zmc2V0IHdhcyBjaG9zZW4gYmVjYXVzZSByYW5k
b21pemluZyBlYWNoIG1vZHVsZQogICAgbG9hZCBlbmRzIHVwIHdhc3RpbmcvZnJhZ21lbnRp
bmcgbWVtb3J5IHRvbyBtdWNoLiBQcmlvciBhcHByb2FjaGVzIHRvCiAgICBtaW5pbWl6aW5n
IGZyYWdtZW50YXRpb24gd2hpbGUgZG9pbmcgcmFuZG9taXphdGlvbiB0ZW5kIHRvIHJlc3Vs
dCBpbgogICAgd29yc2UgZW50cm9weSB0aGFuIGp1c3QgZG9pbmcgYSBzaW5nbGUgYmFzZSBh
ZGRyZXNzIG9mZnNldC4KICAgIAogICAgRXhhbXBsZSBrQVNMUiBib290IHdpdGhvdXQgdGhp
cyBjaGFuZ2UsIHdpdGggYSBzaW5nbGUgbW9kdWxlIGxvYWRlZDoKICAgIC0tLVsgTW9kdWxl
cyBdLS0tCiAgICAweGZmZmZmZmZmYzAwMDAwMDAtMHhmZmZmZmZmZmMwMDAxMDAwICAgICAg
ICAgICA0SyAgICAgcm8gICAgIEdMQiB4ICBwdGUKICAgIDB4ZmZmZmZmZmZjMDAwMTAwMC0w
eGZmZmZmZmZmYzAwMDIwMDAgICAgICAgICAgIDRLICAgICBybyAgICAgR0xCIE5YIHB0ZQog
ICAgMHhmZmZmZmZmZmMwMDAyMDAwLTB4ZmZmZmZmZmZjMDAwNDAwMCAgICAgICAgICAgOEsg
ICAgIFJXICAgICBHTEIgTlggcHRlCiAgICAweGZmZmZmZmZmYzAwMDQwMDAtMHhmZmZmZmZm
ZmMwMjAwMDAwICAgICAgICAyMDMySyAgICAgICAgICAgICAgICAgICBwdGUKICAgIDB4ZmZm
ZmZmZmZjMDIwMDAwMC0weGZmZmZmZmZmZmYwMDAwMDAgICAgICAgIDEwMDZNICAgICAgICAg
ICAgICAgICAgIHBtZAogICAgLS0tWyBFbmQgTW9kdWxlcyBdLS0tCiAgICAKICAgIEV4YW1w
bGUga0FTTFIgYm9vdCBhZnRlciB0aGlzIGNoYW5nZSwgc2FtZSBtb2R1bGUgbG9hZGVkOgog
ICAgLS0tWyBNb2R1bGVzIF0tLS0KICAgIDB4ZmZmZmZmZmZjMDAwMDAwMC0weGZmZmZmZmZm
YzAyMDAwMDAgICAgICAgICAgIDJNICAgICAgICAgICAgICAgICAgIHBtZAogICAgMHhmZmZm
ZmZmZmMwMjAwMDAwLTB4ZmZmZmZmZmZjMDNiZjAwMCAgICAgICAgMTc4OEsgICAgICAgICAg
ICAgICAgICAgcHRlCiAgICAweGZmZmZmZmZmYzAzYmYwMDAtMHhmZmZmZmZmZmMwM2MwMDAw
ICAgICAgICAgICA0SyAgICAgcm8gICAgIEdMQiB4ICBwdGUKICAgIDB4ZmZmZmZmZmZjMDNj
MDAwMC0weGZmZmZmZmZmYzAzYzEwMDAgICAgICAgICAgIDRLICAgICBybyAgICAgR0xCIE5Y
IHB0ZQogICAgMHhmZmZmZmZmZmMwM2MxMDAwLTB4ZmZmZmZmZmZjMDNjMzAwMCAgICAgICAg
ICAgOEsgICAgIFJXICAgICBHTEIgTlggcHRlCiAgICAweGZmZmZmZmZmYzAzYzMwMDAtMHhm
ZmZmZmZmZmMwNDAwMDAwICAgICAgICAgMjQ0SyAgICAgICAgICAgICAgICAgICBwdGUKICAg
IDB4ZmZmZmZmZmZjMDQwMDAwMC0weGZmZmZmZmZmZmYwMDAwMDAgICAgICAgIDEwMDRNICAg
ICAgICAgICAgICAgICAgIHBtZAogICAgLS0tWyBFbmQgTW9kdWxlcyBdLS0tCiAgICAKICAg
IFNpZ25lZC1vZmYtYnk6IEFuZHkgSG9uaWcgPGFob25pZ0Bnb29nbGUuY29tPgogICAgTGlu
azogaHR0cDovL2xrbWwua2VybmVsLm9yZy9yLzIwMTQwMjI2MDA1OTE2LkdBMjcwODNAd3d3
Lm91dGZsdXgubmV0CiAgICBTaWduZWQtb2ZmLWJ5OiBLZWVzIENvb2sgPGtlZXNjb29rQGNo
cm9taXVtLm9yZz4KICAgIFNpZ25lZC1vZmYtYnk6IEguIFBldGVyIEFudmluIDxocGFAbGlu
dXguaW50ZWwuY29tPgoKOjA0MDAwMCAwNDAwMDAgOTg5NDRkNDMwZjA4NDk4ZDRjYWM4Njll
ZjQxZjkzZDE2YzY5ZWJlYiA5YWZlNzhhMzYyNGU0MzVlZWVkMDBjYmU3YWJkZjkzOWVlZGI3
ODYyIE0JRG9jdW1lbnRhdGlvbgo6MDQwMDAwIDA0MDAwMCA1NTJlOTdlZDJjYWM2NGUzZWYz
OTM4ZDRkNWE3MTVmMTdhNmYwOWY3IGJkZTU2ZDY0OGY2YzM5MWY2ODhhYjFiMDdkYzNhMDlm
M2U0Y2Q2YTAgTQlhcmNoCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzL25leHQ6bWFzdGVy
OmNmYmY4ZDQ4NTdjMjZhOGEzMDdmYjdjZDI1ODA3NGM5ZGNkOGM2OTE6YmlzZWN0LXVzYgoK
MjAxNC0wMy0yNC0wMjozODozOSBjZmJmOGQ0ODU3YzI2YThhMzA3ZmI3Y2QyNTgwNzRjOWRj
ZDhjNjkxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy1jZmJmOGQ0ODU3YzI2YThh
MzA3ZmI3Y2QyNTgwNzRjOWRjZDhjNjkxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvY2ZiZjhkNDg1N2MyNmE4YTMwN2ZiN2NkMjU4
MDc0YzlkY2Q4YzY5MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLWNmYmY4ZDQ4NTdjMjZh
OGEzMDdmYjdjZDI1ODA3NGM5ZGNkOGM2OTEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMt
Y2ZiZjhkNDg1N2MyNmE4YTMwN2ZiN2NkMjU4MDc0YzlkY2Q4YzY5MQprZXJuZWw6IC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzL2NmYmY4ZDQ4NTdjMjZhOGEzMDdmYjdj
ZDI1ODA3NGM5ZGNkOGM2OTEvdm1saW51ei0zLjE0LjAtcmM0CgoyMDE0LTAzLTI0LTAzOjA2
OjM5IGRldGVjdGluZyBib290IHN0YXRlIC4uCTEJNAkxMC4JMTEuLgkxOAkyMwkyOQk1Mwk2
NQk3Ngk4Mgk4NAk4NQkxMDQJMTI3CTE0MwkxNjUJMTg2CTE5NgkyMDQJMjI2CTI0MAkyNTcJ
Mjg3CTMxMwkzMzMJMzUzCTM2NQkzOTgJNDY3CTUyNQk1NDYJNTY0CTU4Ngk1OTYJNTk4Li4u
Li4uLi4uLi4JNTk5Li4uLi4JNjAwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvbmV4dDptYXN0ZXI6MDZl
ZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNTpiaXNlY3QtdXNiCiBURVNU
IEZBSUxVUkUKWyAgIDI0LjUwMzE0N10gc29jazogcHJvY2VzcyBgdHJpbml0eS1tYWluJyBp
cyB1c2luZyBvYnNvbGV0ZSBzZXRzb2Nrb3B0IFNPX0JTRENPTVBBVApbICAgNzguMjAxNTEx
XSAKWyAgIDc4LjIwMjY5Nl0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQpbICAg
NzguMjA0MzM5XSBbIElORk86IHN1c3BpY2lvdXMgUkNVIHVzYWdlLiBdClsgICA3OC4yMDU5
NzVdIDMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMSAjMTYgTm90IHRhaW50ZWQKWyAgIDc4LjIy
NTgxMV0gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgNzguMjI3NDc0XSBp
bmNsdWRlL2xpbnV4L2Nncm91cC5oOjY4NyBzdXNwaWNpb3VzIHJjdV9kZXJlZmVyZW5jZV9j
aGVjaygpIHVzYWdlIQpbICAgNzguMjMwODYyXSAKWyAgIDc4LjIzMDg2Ml0gb3RoZXIgaW5m
byB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgIDc4LjIzMDg2Ml0gClsgICA3
OC4yNTI3NjZdIApbICAgNzguMjUyNzY2XSByY3Vfc2NoZWR1bGVyX2FjdGl2ZSA9IDEsIGRl
YnVnX2xvY2tzID0gMApbICAgNzguMjU1NTkxXSBubyBsb2NrcyBoZWxkIGJ5IHNoLzI0NjUw
LgpbICAgNzguMjU3MTUzXSAKWyAgIDc4LjI1NzE1M10gc3RhY2sgYmFja3RyYWNlOgpbICAg
NzguMjU5NTk0XSBDUFU6IDAgUElEOiAyNDY1MCBDb21tOiBzaCBOb3QgdGFpbnRlZCAzLjE0
LjAtcmM3LW5leHQtMjAxNDAzMjEgIzE2ClsgICA3OC4yODA1NjJdIEhhcmR3YXJlIG5hbWU6
IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDc4LjI4MjQ3Nl0gIDAw
MDAwMDAwIGNiM2I5ZWEwIGM2ZDY2YTk1IDAwMDAwMDAxIGNiM2I5ZWJjIGM2NGZkZjc2IGM3
MDlkNzZmIGNiMzJjMTQwClsgICA3OC4yODY0MDhdICBjYjMxYTBhMCAwMDAwMDAwMCBjYjMx
YTljNCBjYjNiOWVlMCBjNjU1ODFiYSBjYjA0YTQwMCBjYjMxYTBhMCBjNzFlMGJiOApbICAg
NzguMzA0NDY4XSAgMDA2MzNmNTQgY2IzMWEwYTAgY2IzZGEzMDAgY2IzMWEyZDggY2IzYjlm
NDAgYzY0N2VhYmYgMDAwMDAwMDAgMDAwMDAwMDAKWyAgIDc4LjMwODM2OF0gQ2FsbCBUcmFj
ZToKWyAgIDc4LjMwOTY4MV0gIFs8YzZkNjZhOTU+XSBkdW1wX3N0YWNrKzB4YjgvMHgxMDgK
WyAgIDc4LjMyMDk1NF0gIFs8YzY0ZmRmNzY+XSBsb2NrZGVwX3JjdV9zdXNwaWNpb3VzKzB4
MWViLzB4MjAyClsgICA3OC4zNDA3NDZdICBbPGM2NTU4MWJhPl0gY2dyb3VwX2V4aXQrMHgx
ZjUvMHg0NjQKWyAgIDc4LjM0MjQ3NF0gIFs8YzY0N2VhYmY+XSBjb3B5X3Byb2Nlc3MrMHgy
MzcwLzB4MjQzOQpbICAgNzguMzQ0MjUwXSAgWzxjNjQ3ZWQyOT5dIGRvX2ZvcmsrMHhiMS8w
eDQ1NApbICAgNzguMzQ1OTA1XSAgWzxjNjg5OTJkZD5dID8gX2NvcHlfdG9fdXNlcisweDcz
LzB4OWEKWyAgIDc4LjM0NzY5MF0gIFs8YzZkNzZiMmE+XSA/IHJlc3RvcmVfYWxsKzB4Zi8w
eGYKWyAgIDc4LjM2NzQzNV0gIFs8YzY0N2YxOTE+XSBTeVNfY2xvbmUrMHgyNC8weDQyClsg
ICA3OC4zNjkwODhdICBbPGM2ZDc2YWYxPl0gc3lzY2FsbF9jYWxsKzB4Ny8weGIKWyAgMTcy
Ljg1MDA1OV0gcmFuZG9tOiBub25ibG9ja2luZyBwb29sIGlzIGluaXRpYWxpemVkCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3
OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2cteW9jdG8tbGtwLXNiMDQtNTg6MjAxNDAzMjMxNTUw
NTk6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzctbmV4dC0yMDE0MDMy
MToxNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy8wNmVkMjZkMWRlNTlj
ZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXlvY3RvLWxrcC1zYjA0LTQ5OjIw
MTQwMzIzMjMxNzI4OmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMzozLjE0LjAtcmM3LW5l
eHQtMjAxNDAzMjE6MTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvMDZl
ZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy1xdWFudGFsLWxr
cC1zYjA0LTUyOjIwMTQwMzIzMTU1MDQ1OmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMzoz
LjE0LjAtcmM3LW5leHQtMjAxNDAzMjE6MTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzQt
MDMyMzA3MzMvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVz
Zy1xdWFudGFsLWxrcC1zYjA0LTIzOjIwMTQwMzIzMTU1MDU3OmkzODYtcmFuZGNvbmZpZy1j
NC0wMzIzMDczMzozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjE6MTYKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzQtMDMyMzA3MzMvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUx
Njk3NTBlNS9kbWVzZy15b2N0by1sa3Atc2IwNC0xODoyMDE0MDMyMzE1NTEwNTppMzg2LXJh
bmRjb25maWctYzQtMDMyMzA3MzM6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxOjE2Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3
OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2cteW9jdG8tbGtwLXNiMDQtOToyMDE0MDMyMzE1NTA0
MTppMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzM6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIx
OjE2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzA2ZWQyNmQxZGU1OWNl
N2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2cteW9jdG8taXZ5dG93bjItMzI6MjAx
NDAzMjMxNTE3Mzc6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzctbmV4
dC0yMDE0MDMyMToxNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy8wNmVk
MjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXF1YW50YWwtbGtw
LXNiMDQtNDY6MjAxNDAzMjMyMzE3Mjg6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMu
MTQuMC1yYzctbmV4dC0yMDE0MDMyMToxNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0w
MzIzMDczMy8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNn
LXlvY3RvLWNhaXJvLTM5OjIwMTQwMzIzMTUxNzE5OmkzODYtcmFuZGNvbmZpZy1jNC0wMzIz
MDczMzozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjE6MTYKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzQtMDMyMzA3MzMvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBl
NS9kbWVzZy15b2N0by1sa3Atc2IwNC0yOToyMDE0MDMyMzE1NTEwMjppMzg2LXJhbmRjb25m
aWctYzQtMDMyMzA3MzM6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxOjE2Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3
MGJlMTY5NzUwZTUvZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC00NjoyMDE0MDMyMzE1NTExMTpp
Mzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzM6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxOjE2
CjU6MTE6MTQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRhY2hlZCBIRUFEIDI5
MTQ5ODddIFJldmVydCAieDg2LCBrYXNscjogcmFuZG9taXplIG1vZHVsZSBiYXNlIGxvYWQg
YWRkcmVzcyIKIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA0MiBkZWxldGlv
bnMoLSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1jNC0wMzIzMDczMy9uZXh0Om1hc3RlcjoyOTE0OTg3NDJjOGZiNjAzZTZmOTIwZGJiNjAy
ZWQ4ZDgxYzFhZTQwOmJpc2VjdC11c2IKCjIwMTQtMDMtMjQtMDM6MzY6MjUgMjkxNDk4NzQy
YzhmYjYwM2U2ZjkyMGRiYjYwMmVkOGQ4MWMxYWU0MCBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzQt
MDMyMzA3MzMtMjkxNDk4NzQyYzhmYjYwM2U2ZjkyMGRiYjYwMmVkOGQ4MWMxYWU0MApDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzI5
MTQ5ODc0MmM4ZmI2MDNlNmY5MjBkYmI2MDJlZDhkODFjMWFlNDAKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1j
NC0wMzIzMDczMy0yOTE0OTg3NDJjOGZiNjAzZTZmOTIwZGJiNjAyZWQ4ZDgxYzFhZTQwCnN0
YXR1czogRkFJTDogbm8gY29tbWl0IDI5MTQ5ODc0MmM4ZmI2MDNlNmY5MjBkYmI2MDJlZDhk
ODFjMWFlNDAgZm9yIGJ1aWxkIHRhc2sgaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTI5
MTQ5ODc0MmM4ZmI2MDNlNmY5MjBkYmI2MDJlZDhkODFjMWFlNDAKMjAxNC0wMy0yNC0wMzo0
NToyNSAyOTE0OTg3NDJjOGZiNjAzZTZmOTIwZGJiNjAyZWQ4ZDgxYzFhZTQwIFNLSVAgQlJP
S0VOIEJVSUxECk5vIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIz
MDczMy8yOTE0OTg3NDJjOGZiNjAzZTZmOTIwZGJiNjAyZWQ4ZDgxYzFhZTQwCgo9PT09PT09
PT0gdXBzdHJlYW0gPT09PT09PT09Cldhcm5pbmc6IHlvdSBhcmUgbGVhdmluZyAxIGNvbW1p
dCBiZWhpbmQsIG5vdCBjb25uZWN0ZWQgdG8KYW55IG9mIHlvdXIgYnJhbmNoZXM6CgogIDI5
MTQ5ODcgUmV2ZXJ0ICJ4ODYsIGthc2xyOiByYW5kb21pemUgbW9kdWxlIGJhc2UgbG9hZCBh
ZGRyZXNzIgoKSWYgeW91IHdhbnQgdG8ga2VlcCB0aGVtIGJ5IGNyZWF0aW5nIGEgbmV3IGJy
YW5jaCwgdGhpcyBtYXkgYmUgYSBnb29kIHRpbWUKdG8gZG8gc28gd2l0aDoKCiBnaXQgYnJh
bmNoIG5ld19icmFuY2hfbmFtZSAyOTE0OTg3CgpIRUFEIGlzIG5vdyBhdCA3NzQ4NjhjLi4u
IE1lcmdlIGJyYW5jaCAncGVyZi11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzL25leHQ6
bWFzdGVyOjc3NDg2OGM3MDk0ZDM1YjQ1MThiZTNkMGU2NTRkZTAwMGE1ZDExZmM6YmlzZWN0
LXVzYgoKMjAxNC0wMy0yNC0wMzo0NTozMCA3NzQ4NjhjNzA5NGQzNWI0NTE4YmUzZDBlNjU0
ZGUwMDBhNWQxMWZjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy03NzQ4NjhjNzA5
NGQzNWI0NTE4YmUzZDBlNjU0ZGUwMDBhNWQxMWZjCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvNzc0ODY4YzcwOTRkMzViNDUxOGJl
M2QwZTY1NGRlMDAwYTVkMTFmYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLTc3NDg2OGM3
MDk0ZDM1YjQ1MThiZTNkMGU2NTRkZTAwMGE1ZDExZmMKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYzQtMDMy
MzA3MzMtNzc0ODY4YzcwOTRkMzViNDUxOGJlM2QwZTY1NGRlMDAwYTVkMTFmYwprZXJuZWw6
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzc3NDg2OGM3MDk0ZDM1YjQ1
MThiZTNkMGU2NTRkZTAwMGE1ZDExZmMvdm1saW51ei0zLjE0LjAtcmM3LTAwMDY2LWc3NzQ4
NjhjCgoyMDE0LTAzLTI0LTA0OjAzOjMwIGRldGVjdGluZyBib290IHN0YXRlIC4uLgk2CTEy
CTI2CTM1CTQ2CTY1CTc2Lgk3OAk4MQk4OQkxMDIJMTE2CTEyOQkxNDUJMjExCTIzMwkyNTQJ
Mjg1CTI5NwkzMzIJMzU1CTM4Nwk0MDkJNDE3CTQ2NAk1MDQJNTQwCTU0OQk1NjEJNTY2CTU3
Nwk1OTcuLi4uLi4uLi4uCTU5OAk1OTkuLgk2MDAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51
eC1uZXh0ID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA3NzQ4NjhjLi4u
IE1lcmdlIGJyYW5jaCAncGVyZi11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApIRUFEIGlzIG5vdyBh
dCAwNmVkMjZkLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDMy
MQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM0
LTAzMjMwNzMzL25leHQ6bWFzdGVyOjA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJl
MTY5NzUwZTU6YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJFClsgICAyNC41MDMxNDddIHNvY2s6
IHByb2Nlc3MgYHRyaW5pdHktbWFpbicgaXMgdXNpbmcgb2Jzb2xldGUgc2V0c29ja29wdCBT
T19CU0RDT01QQVQKWyAgIDc4LjIwMTUxMV0gClsgICA3OC4yMDI2OTZdID09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0KWyAgIDc4LjIwNDMzOV0gWyBJTkZPOiBzdXNwaWNpb3Vz
IFJDVSB1c2FnZS4gXQpbICAgNzguMjA1OTc1XSAzLjE0LjAtcmM3LW5leHQtMjAxNDAzMjEg
IzE2IE5vdCB0YWludGVkClsgICA3OC4yMjU4MTFdIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0KWyAgIDc4LjIyNzQ3NF0gaW5jbHVkZS9saW51eC9jZ3JvdXAuaDo2ODcgc3Vz
cGljaW91cyByY3VfZGVyZWZlcmVuY2VfY2hlY2soKSB1c2FnZSEKWyAgIDc4LjIzMDg2Ml0g
ClsgICA3OC4yMzA4NjJdIG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRo
aXM6ClsgICA3OC4yMzA4NjJdIApbICAgNzguMjUyNzY2XSAKWyAgIDc4LjI1Mjc2Nl0gcmN1
X3NjaGVkdWxlcl9hY3RpdmUgPSAxLCBkZWJ1Z19sb2NrcyA9IDAKWyAgIDc4LjI1NTU5MV0g
bm8gbG9ja3MgaGVsZCBieSBzaC8yNDY1MC4KWyAgIDc4LjI1NzE1M10gClsgICA3OC4yNTcx
NTNdIHN0YWNrIGJhY2t0cmFjZToKWyAgIDc4LjI1OTU5NF0gQ1BVOiAwIFBJRDogMjQ2NTAg
Q29tbTogc2ggTm90IHRhaW50ZWQgMy4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxICMxNgpbICAg
NzguMjgwNTYyXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8w
MS8yMDExClsgICA3OC4yODI0NzZdICAwMDAwMDAwMCBjYjNiOWVhMCBjNmQ2NmE5NSAwMDAw
MDAwMSBjYjNiOWViYyBjNjRmZGY3NiBjNzA5ZDc2ZiBjYjMyYzE0MApbICAgNzguMjg2NDA4
XSAgY2IzMWEwYTAgMDAwMDAwMDAgY2IzMWE5YzQgY2IzYjllZTAgYzY1NTgxYmEgY2IwNGE0
MDAgY2IzMWEwYTAgYzcxZTBiYjgKWyAgIDc4LjMwNDQ2OF0gIDAwNjMzZjU0IGNiMzFhMGEw
IGNiM2RhMzAwIGNiMzFhMmQ4IGNiM2I5ZjQwIGM2NDdlYWJmIDAwMDAwMDAwIDAwMDAwMDAw
ClsgICA3OC4zMDgzNjhdIENhbGwgVHJhY2U6ClsgICA3OC4zMDk2ODFdICBbPGM2ZDY2YTk1
Pl0gZHVtcF9zdGFjaysweGI4LzB4MTA4ClsgICA3OC4zMjA5NTRdICBbPGM2NGZkZjc2Pl0g
bG9ja2RlcF9yY3Vfc3VzcGljaW91cysweDFlYi8weDIwMgpbICAgNzguMzQwNzQ2XSAgWzxj
NjU1ODFiYT5dIGNncm91cF9leGl0KzB4MWY1LzB4NDY0ClsgICA3OC4zNDI0NzRdICBbPGM2
NDdlYWJmPl0gY29weV9wcm9jZXNzKzB4MjM3MC8weDI0MzkKWyAgIDc4LjM0NDI1MF0gIFs8
YzY0N2VkMjk+XSBkb19mb3JrKzB4YjEvMHg0NTQKWyAgIDc4LjM0NTkwNV0gIFs8YzY4OTky
ZGQ+XSA/IF9jb3B5X3RvX3VzZXIrMHg3My8weDlhClsgICA3OC4zNDc2OTBdICBbPGM2ZDc2
YjJhPl0gPyByZXN0b3JlX2FsbCsweGYvMHhmClsgICA3OC4zNjc0MzVdICBbPGM2NDdmMTkx
Pl0gU3lTX2Nsb25lKzB4MjQvMHg0MgpbICAgNzguMzY5MDg4XSAgWzxjNmQ3NmFmMT5dIHN5
c2NhbGxfY2FsbCsweDcvMHhiClsgIDE3Mi44NTAwNTldIHJhbmRvbTogbm9uYmxvY2tpbmcg
cG9vbCBpcyBpbml0aWFsaXplZAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDcz
My8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXlvY3Rv
LWxrcC1zYjA0LTU4OjIwMTQwMzIzMTU1MDU5OmkzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDcz
MzozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjE6MTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzQtMDMyMzA3MzMvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9k
bWVzZy15b2N0by1sa3Atc2IwNC00OToyMDE0MDMyMzIzMTcyODppMzg2LXJhbmRjb25maWct
YzQtMDMyMzA3MzM6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxOjE2Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWM0LTAzMjMwNzMzLzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJl
MTY5NzUwZTUvZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC01MjoyMDE0MDMyMzE1NTA0NTppMzg2
LXJhbmRjb25maWctYzQtMDMyMzA3MzM6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxOjE2Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzA2ZWQyNmQxZGU1OWNlN2NiYmU2
ODM3OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC0yMzoyMDE0MDMy
MzE1NTA1NzppMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzM6My4xNC4wLXJjNy1uZXh0LTIw
MTQwMzIxOjE2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzA2ZWQyNmQx
ZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2cteW9jdG8tbGtwLXNiMDQt
MTg6MjAxNDAzMjMxNTUxMDU6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1y
YzctbmV4dC0yMDE0MDMyMToxNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDcz
My8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXlvY3Rv
LWxrcC1zYjA0LTk6MjAxNDAzMjMxNTUwNDE6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMz
OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMToxNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
NC0wMzIzMDczMy8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2Rt
ZXNnLXlvY3RvLWl2eXRvd24yLTMyOjIwMTQwMzIzMTUxNzM3OmkzODYtcmFuZGNvbmZpZy1j
NC0wMzIzMDczMzozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjE6MTYKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzQtMDMyMzA3MzMvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUx
Njk3NTBlNS9kbWVzZy1xdWFudGFsLWxrcC1zYjA0LTQ2OjIwMTQwMzIzMjMxNzI4OmkzODYt
cmFuZGNvbmZpZy1jNC0wMzIzMDczMzozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjE6MTYKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzMvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4
Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy15b2N0by1jYWlyby0zOToyMDE0MDMyMzE1MTcx
OTppMzg2LXJhbmRjb25maWctYzQtMDMyMzA3MzM6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIx
OjE2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzLzA2ZWQyNmQxZGU1OWNl
N2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2cteW9jdG8tbGtwLXNiMDQtMjk6MjAx
NDAzMjMxNTUxMDI6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMuMTQuMC1yYzctbmV4
dC0yMDE0MDMyMToxNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNC0wMzIzMDczMy8wNmVk
MjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXF1YW50YWwtbGtw
LXNiMDQtNDY6MjAxNDAzMjMxNTUxMTE6aTM4Ni1yYW5kY29uZmlnLWM0LTAzMjMwNzMzOjMu
MTQuMC1yYzctbmV4dC0yMDE0MDMyMToxNgo1OjExOjE0IGFsbF9nb29kOmJhZDphbGxfYmFk
IGJvb3RzCgo=

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc7-next-20140321"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc7 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLUB_CPU_PARTIAL is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
CONFIG_MODULE_SIG_SHA384=y
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha384"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=64
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=m
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=3
CONFIG_ARCH_HAVE_MEMORY_PRESENT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_DISCONTIGMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_DISCONTIGMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_NUMA is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=m
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=m
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=m
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=m
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_SCx200_DOCFLASH=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_GPIO=m
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=y
# CONFIG_ZRAM_LZ4_COMPRESS is not set
# CONFIG_ZRAM_DEBUG is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_XEN_BLKDEV_FRONTEND is not set
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
CONFIG_BLK_DEV_CMD640=m
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=m
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=m
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=m
# CONFIG_DM_CACHE_MQ is not set
CONFIG_DM_CACHE_CLEANER=m
# CONFIG_DM_ERA is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
CONFIG_DM_VERITY=m
# CONFIG_DM_SWITCH is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_TCA6416=m
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=m
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=m
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=m
CONFIG_INPUT_LEDS=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=m
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=m
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_HANWANG=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_UCB1400=m
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
# CONFIG_TOUCHSCREEN_WM9712 is not set
# CONFIG_TOUCHSCREEN_WM9713 is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=m
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_SUR40=m
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_TOUCHSCREEN_ZFORCE=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_HVC_DRIVER=y
# CONFIG_HVC_XEN is not set
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=m
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
# CONFIG_TCG_XEN is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_I2C is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_DA9055=m
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_LP3943=m
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM8350=m
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#
CONFIG_GPIO_UCB1400=m

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_MAX8925_POWER=m
CONFIG_WM8350_POWER=m
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX8998=m
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=m
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9055=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LTC2945=m
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=m
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_WM8350 is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=m
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=m
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=m
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=m
CONFIG_UCB1400_CORE=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=m
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=m
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=m
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=m
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8998=m
CONFIG_REGULATOR_MAX77686=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_S2MPA01 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=m
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=m
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=m
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TWL4030=m
CONFIG_REGULATOR_WM8350=y
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog TV USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_STK1160_COMMON=y
# CONFIG_VIDEO_STK1160_AC97 is not set
CONFIG_VIDEO_STK1160=y

#
# Analog/digital TV USB devices
#

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=y
# CONFIG_VIDEO_EM28XX_V4L2 is not set
# CONFIG_VIDEO_EM28XX_ALSA is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=m
CONFIG_I2C_SI470X=m
CONFIG_RADIO_SI4713=y
# CONFIG_USB_SI4713 is not set
CONFIG_PLATFORM_SI4713=m
CONFIG_I2C_SI4713=m
CONFIG_RADIO_SI476X=m
CONFIG_USB_MR800=m
CONFIG_USB_DSBR=m
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_RADIO_SHARK=m
CONFIG_RADIO_SHARK2=y
CONFIG_USB_KEENE=m
CONFIG_USB_RAREMONO=y
# CONFIG_USB_MA901 is not set
CONFIG_RADIO_TEA5764=m
CONFIG_RADIO_SAA7706H=m
CONFIG_RADIO_TEF6862=m
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_VIDEO_TVEEPROM=y
# CONFIG_CYPRESS_FIRMWARE is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=y

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=m
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=m
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=m
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_AC97_CODEC=m
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_USB is not set
CONFIG_SND_SOC=m
CONFIG_SND_ATMEL_SOC=m
CONFIG_SND_SOC_INTEL_SST=m
CONFIG_SND_SOC_INTEL_SST_ACPI=m
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_AK4554 is not set
CONFIG_SND_SOC_AK4642=m
CONFIG_SND_SOC_AK5386=m
CONFIG_SND_SOC_CS42L52=m
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS4270 is not set
CONFIG_SND_SOC_CS4271=m
CONFIG_SND_SOC_HDMI_CODEC=m
# CONFIG_SND_SOC_PCM1681 is not set
CONFIG_SND_SOC_PCM512x=m
CONFIG_SND_SOC_PCM512x_I2C=m
CONFIG_SND_SOC_SGTL5000=m
CONFIG_SND_SOC_SI476X=m
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_TAS5086=m
CONFIG_SND_SOC_TLV320AIC3X=m
# CONFIG_SND_SOC_WM8510 is not set
CONFIG_SND_SOC_WM8523=m
# CONFIG_SND_SOC_WM8580 is not set
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8737=m
CONFIG_SND_SOC_WM8741=m
CONFIG_SND_SOC_WM8750=m
# CONFIG_SND_SOC_WM8753 is not set
CONFIG_SND_SOC_WM8776=m
# CONFIG_SND_SOC_WM8804 is not set
# CONFIG_SND_SOC_WM8903 is not set
CONFIG_SND_SOC_WM8962=m
CONFIG_SND_SOC_TPA6130A2=m
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_OSS=m
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
# CONFIG_SOUND_VMIDI is not set
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=m
# CONFIG_SOUND_MPU401 is not set
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=m
CONFIG_PSS_MIXER=y
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
# CONFIG_SOUND_AEDSP16 is not set
# CONFIG_SOUND_KAHLUA is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CP2112=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_HUION=y
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=m
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=y
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=m
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=m
CONFIG_USB_MUSB_HDRC=m
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=m
CONFIG_USB_MUSB_UX500=m
CONFIG_USB_UX500_DMA=y
# CONFIG_MUSB_PIO_ONLY is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
# CONFIG_USB_DWC3_EXYNOS is not set
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_KEYSTONE=m

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_SIMPLE=m
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
# CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_METRO=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MXUPORT=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=m
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
CONFIG_USB_SERIAL_WISHBONE=m
CONFIG_USB_SERIAL_ZTE=m
CONFIG_USB_SERIAL_SSU100=m
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=m
CONFIG_NOP_USB_XCEIV=m
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=m
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_NET48XX=m
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_PCA9685=y
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=m
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_IDE_DISK=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=y
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_ACPI_PROCESSOR=m
CONFIG_XEN_HAVE_PVMMU=y
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=m
CONFIG_CHROMEOS_PSTORE=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=m
CONFIG_PWM_TWL=m
CONFIG_PWM_TWL_LED=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_OMAP_CONTROL_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_SAMSUNG_USB2 is not set
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
CONFIG_MCB=m
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=m
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
# CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
CONFIG_IMA_DEFAULT_HASH_SHA256=y
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha256"
CONFIG_IMA_APPRAISE=y
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_CRC64_ECMA=m
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
CONFIG_FONT_7x14=y
CONFIG_FONT_PEARL_8x8=y
CONFIG_FONT_ACORN_8x8=y
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set

--nFreZHaLTZJo0R7j--
