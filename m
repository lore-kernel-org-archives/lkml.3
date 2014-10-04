Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaJDNqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 09:46:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:6054 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaJDNqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 09:46:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,653,1406617200"; 
   d="scan'208";a="600683083"
Date: Sat, 4 Oct 2014 21:46:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [perf] BUG: unable to handle kernel NULL pointer dereference at
 00000085
Message-ID: <20141004134622.GA5214@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Peter,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git perf/core

commit a54b3e27e27c1bb6d2610eade895c04934c2667e
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed Sep 24 13:48:42 2014 +0200
Commit:     Peter Zijlstra <peterz@infradead.org>
CommitDate: Thu Oct 2 23:11:50 2014 +0200

    perf: improve perf_sample_data struct layout
    
    This patch reorders fields in the perf_sample_data
    struct in order to minimize the number of cachelines
    touched in perf_sample_data_init(). It also removes
    some intializations which are redundant with the
    code in kernel/events/core.c
    
    Cc: mingo@elte.hu
    Cc: ak@linux.intel.com
    Cc: jolsa@redhat.com
    Cc: acme@redhat.com
    Cc: cebbert.lkml@gmail.com
    Cc: peterz@infradead.org
    
    Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/1411559322-16548-7-git-send-email-eranian@google.com

Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+-------------------------------------------------------+------------+------------+------------------+
|                                                       | da2ff6572c | a54b3e27e2 | v3.17-rc7_100306 |
+-------------------------------------------------------+------------+------------+------------------+
| boot_successes                                        | 886        | 227        | 18               |
| boot_failures                                         | 314        | 73         | 4                |
| BUG:kernel_boot_hang                                  | 295        | 52         |                  |
| WARNING:at_fs/proc/generic.c:remove_proc_entry()      | 16         | 8          |                  |
| backtrace:cleanup_net                                 | 16         | 8          |                  |
| BUG:kernel_test_crashed                               | 4          | 9          | 1                |
| BUG:unable_to_handle_kernel                           | 0          | 4          | 2                |
| Oops                                                  | 0          | 4          | 2                |
| EIP_is_at_perf_prepare_sample                         | 0          | 4          | 2                |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 0          | 3          | 2                |
| backtrace:iterate_dir                                 | 0          | 2          |                  |
| backtrace:SyS_getdents64                              | 0          | 2          |                  |
| backtrace:do_sys_open                                 | 0          | 1          |                  |
| backtrace:SyS_openat                                  | 0          | 1          |                  |
| backtrace:vfs_fstatat                                 | 0          | 1          | 1                |
| backtrace:SyS_fstatat64                               | 0          | 1          | 1                |
| Kernel_panic-not_syncing:Fatal_exception              | 0          | 1          |                  |
| BUG:kernel_boot_crashed                               | 0          | 0          | 1                |
| backtrace:__fdget_raw                                 | 0          | 0          | 1                |
| backtrace:SyS_fcntl64                                 | 0          | 0          | 1                |
+-------------------------------------------------------+------------+------------+------------------+

[  267.547006] debug: unmapping init [mem 0xc28f9000-0xc2b03fff]
[  267.694378] random: init urandom read with 4 bits of entropy available
[  279.465522] sock: process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
[  285.269144] BUG: unable to handle kernel NULL pointer dereference at 00000085
[  285.273002] IP: [<c11259a1>] perf_prepare_sample+0x33e/0x496
[  285.276062] *pde = 00000000 
[  285.279106] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  285.279106] Modules linked in:
[  285.279106] CPU: 1 PID: 1583 Comm: trinity-main Not tainted 3.17.0-rc4-00210-ga54b3e2 #1
[  285.279106] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[  285.279106] task: c9475e80 ti: c9670000 task.ti: c9670000
[  285.279106] EIP: 0060:[<c11259a1>] EFLAGS: 00010046 CPU: 1
[  285.279106] EIP is at perf_prepare_sample+0x33e/0x496
[  285.279106] EAX: 00000000 EBX: 00000000 ECX: 00000049 EDX: 00000000
[  285.279106] ESI: cfd71c40 EDI: cfd71b84 EBP: cfd71b58 ESP: cfd71b34
[  285.279106]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  285.279106] CR0: 80050033 CR2: 00000085 CR3: 095b4000 CR4: 000006d0
[  285.279106] DR0: 41000043 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  285.279106] DR6: ffff0ff0 DR7: 00010602
[  285.279106] Stack:
[  285.279106]  00000000 00000060 00000000 0003a16b 00000000 c96860d0 00000000 c96860d0
[  285.279106]  00000000 cfd71bb0 c1125d87 cfd71da8 00000002 00000000 00000000 c1125d59
[  285.279106]  00000000 cfd71c40 00000000 4df5a9a0 00000009 00600001 c104e439 00000001
[  285.279106] Call Trace:
[  285.279106]  [<c1125d87>] __perf_event_overflow+0x28e/0x33c
[  285.279106]  [<c1125d59>] ? __perf_event_overflow+0x260/0x33c
[  285.279106]  [<c104e439>] ? pvclock_clocksource_read+0xc2/0x195
[  285.279106]  [<c11266b3>] perf_swevent_overflow+0x6f/0xa0
[  285.279106]  [<c1126824>] perf_swevent_event+0x140/0x14a
[  285.279106]  [<c1126955>] perf_tp_event+0x127/0x2b2
[  285.279106]  [<c104e439>] ? pvclock_clocksource_read+0xc2/0x195
[  285.279106]  [<c1099a7d>] ? update_curr+0x18a/0x269
[  285.279106]  [<c104e439>] ? pvclock_clocksource_read+0xc2/0x195
[  285.279106]  [<c104e439>] ? pvclock_clocksource_read+0xc2/0x195
[  285.279106]  [<c104e439>] ? pvclock_clocksource_read+0xc2/0x195
[  285.279106]  [<c108aead>] perf_trace_sched_stat_runtime+0xea/0xf5
[  285.279106]  [<c104e439>] ? pvclock_clocksource_read+0xc2/0x195
[  285.279106]  [<c108aead>] ? perf_trace_sched_stat_runtime+0xea/0xf5
[  285.279106]  [<c1099a7d>] ? update_curr+0x18a/0x269
[  285.279106]  [<c1099a7d>] update_curr+0x18a/0x269
[  285.279106]  [<c109c29b>] enqueue_task_fair+0x98/0xf16
[  285.279106]  [<c109826d>] ? sched_clock_cpu+0x1b5/0x1dd
[  285.279106]  [<c108dd4a>] ? update_rq_clock+0x36/0x7d
[  285.279106]  [<c108de27>] enqueue_task+0x96/0x9d
[  285.279106]  [<c108e471>] activate_task+0x3b/0x3f
[  285.279106]  [<c108e488>] ttwu_activate+0x13/0x4a
[  285.279106]  [<c108e80b>] ttwu_do_activate+0x44/0x53
[  285.279106]  [<c10937d3>] try_to_wake_up+0x55d/0x5c5
[  285.279106]  [<c10d1a00>] ? add_timer_on+0xbc/0x130
[  285.279106]  [<c109389e>] wake_up_process+0x63/0x68
[  285.279106]  [<c10d1a74>] ? add_timer_on+0x130/0x130
[  285.279106]  [<c10d1a81>] process_timeout+0xd/0xf
[  285.279106]  [<c10d1b75>] call_timer_fn+0xf2/0x255
[  285.279106]  [<c10d1a74>] ? add_timer_on+0x130/0x130
[  285.279106]  [<c10d1f52>] run_timer_softirq+0x27a/0x29c
[  285.279106]  [<c10d1a74>] ? add_timer_on+0x130/0x130
[  285.279106]  [<c106743c>] ? __tasklet_hrtimer_trampoline+0x4c/0x4c
[  285.279106]  [<c10675cf>] __do_softirq+0x193/0x422
[  285.279106]  [<c106743c>] ? __tasklet_hrtimer_trampoline+0x4c/0x4c
[  285.279106]  [<c1006371>] do_softirq_own_stack+0x26/0x2c
[  285.279106]  <IRQ> 
[  285.279106]  [<c1067bea>] irq_exit+0x6c/0x86
[  285.279106]  [<c1042466>] smp_trace_apic_timer_interrupt+0x15c/0x168
[  285.279106]  [<c1d82546>] trace_apic_timer_interrupt+0x32/0x38
[  285.279106]  [<c10a007b>] ? pick_next_task_fair+0x47f/0x61f
[  285.279106]  [<c1d80ac0>] ? _raw_spin_unlock_irqrestore+0x5e/0xb2
[  285.279106]  [<c1190adb>] __slab_free+0xc2/0x6f5
[  285.279106]  [<c1052d04>] ? lookup_address_in_pgd+0xb/0xa2
[  285.279106]  [<c10add33>] ? debug_check_no_locks_freed+0x108/0x120
[  285.279106]  [<c11914b8>] kmem_cache_free+0x3aa/0x447
[  285.279106]  [<c11914b8>] ? kmem_cache_free+0x3aa/0x447
[  285.279106]  [<c11b0f5b>] ? final_putname+0x3b/0x3e
[  285.279106]  [<c11b0f5b>] ? final_putname+0x3b/0x3e
[  285.279106]  [<c11b0f5b>] final_putname+0x3b/0x3e
[  285.279106]  [<c11a2457>] do_sys_open+0x375/0x380
[  285.279106]  [<c1d80000>] ? alarm_timer_nsleep_restart+0x5b/0x125
[  285.279106]  [<c11a249c>] SyS_openat+0x1b/0x1d
[  285.279106]  [<c1d81c76>] syscall_call+0x7/0x7
[  285.279106] Code: 4e 74 66 8b 47 06 85 c9 66 89 45 e0 0f 94 c2 0f b6 da 8b 04 9d fc e0 60 c2 40 89 04 9d fc e0 60 c2 31 c0 84 d2 0f 85 83 00 00 00 <8b> 59 3c 8d 43 ff 3d fe ff ff bf 0f 97 c1 0f b6 d1 8b 04 95 d4
[  285.279106] EIP: [<c11259a1>] perf_prepare_sample+0x33e/0x496 SS:ESP 0068:cfd71b34
[  285.279106] CR2: 0000000000000085
[  285.279106] ---[ end trace a1faeec14f7aba60 ]---
[  285.279106] Kernel panic - not syncing: Fatal exception in interrupt

git bisect start cd90db63d24d44a6796a77eae18d9c733674297b fe82dcec644244676d55a1384c958d5f67979adb --
git bisect good 82e4c9f29ef4460339d830d127cc47a07dd405fb  # 11:21     95+      0  Merge 'security/next' into devel-hourly-2014100306
git bisect good eab01918d942fb45b0d2adf4e94f09fe85b742cb  # 12:05     95+      6  Merge 'peterz-queue/sched/core' into devel-hourly-2014100306
git bisect  bad 5e8d71d46481296149cee42f6c93c670491886a0  # 12:43     29-      2  Merge 'peterz-queue/perf/urgent' into devel-hourly-2014100306
git bisect  bad 3bdd8ee42e47c8360e074bd17198cc71af68496b  # 14:02      7-      1  Merge 'peterz-queue/perf/core' into devel-hourly-2014100306
git bisect good 35550da389ba8752f024a44ef14b74001c4fc4d3  # 14:55    300+    135  perf record: Use strerror_r instead of strerror
git bisect good e5685730e2c620f97bc12380e9370e857e5bd7a7  # 15:18    300+     31  perf record: Use ring buffer consume method to look like other tools
git bisect good e4b356b56cfe77b800a9bc2e6efefa6a069b8a78  # 15:55    300+     88  perf evlist: Unmap when all refcounts to fd are gone and events drained
git bisect good 07394b5f13a04f86b27e0ddd96a36c7d9bfe1a4f  # 17:35    300+    132  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core
git bisect good dfcdc1a2c512eedb5c707ce84e3ab9ca8e2d276d  # 19:40    300+     10  perf/x86: Use KERN_INFO when checking PMU fails on virtual environment
git bisect good 559cb6657390b8a2f68cfe5aa1a58f41932ecb80  # 21:34    300+      6  perf tools: add core support for sampling intr machine state regs
git bisect good da2ff6572c79eaceed133cd8bdd253d3fa36c658  # 23:50    300+     39  perf record: add new -I option to sample interrupted machine state
git bisect  bad a54b3e27e27c1bb6d2610eade895c04934c2667e  # 00:56     94-      6  perf: improve perf_sample_data struct layout
# first bad commit: [a54b3e27e27c1bb6d2610eade895c04934c2667e] perf: improve perf_sample_data struct layout
git bisect good da2ff6572c79eaceed133cd8bdd253d3fa36c658  # 01:27    900+    314  perf record: add new -I option to sample interrupted machine state
git bisect  bad cd90db63d24d44a6796a77eae18d9c733674297b  # 01:27      0-      4  0day head guard for 'devel-hourly-2014100306'
git bisect good ee042ec88022249b848306dd6e87ffd2fd88a839  # 04:51    900+     16  Merge tag 'md/3.17-final-fix' of git://neil.brown.name/md


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 2
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-127:20141004010255:i386-randconfig-c0-10030750::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Linux version 3.17.0-rc4-00210-ga54b3e2 (kbuild@cairo) (gcc =
version 4.9.1 (Debian 4.9.1-11) ) #1 SMP PREEMPT Sat Oct 4 00:49:03 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x100000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[c00f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x037fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 4k
[    0.000000] BRK [0x03344000, 0x03344fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
[    0.000000] BRK [0x03345000, 0x03345fff] PGTABLE
[    0.000000] BRK [0x03346000, 0x03346fff] PGTABLE
[    0.000000] BRK [0x03347000, 0x03347fff] PGTABLE
[    0.000000] BRK [0x03348000, 0x03348fff] PGTABLE
[    0.000000] BRK [0x03349000, 0x03349fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13fdffff]
[    0.000000]  [mem 0x12400000-0x13fdffff] page 4k
[    0.000000] cma: Reserved 32 MiB at 10000000
[    0.000000] RAMDISK: [mem 0x12793000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE1885 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13fdffff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77792 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @d2128000 s1344576 r0 d23488 =
u1368064
[    0.000000] pcpu-alloc: s1344576 r0 d23488 u1368064 alloc=3D334*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1212a880
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80990
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-c0-10030750/linux-devel:devel-hourly-2014100306:a54b3e27e27c1bb6d=
2610eade895c04934c2667e:bisect-linux-1/.vmlinuz-a54b3e27e27c1bb6d2610eade89=
5c04934c2667e-20141004005105-94-ivb41 branch=3Dlinux-devel/devel-hourly-201=
4100306 BOOT_IMAGE=3D/kernel/i386-randconfig-c0-10030750/a54b3e27e27c1bb6d2=
610eade895c04934c2667e/vmlinuz-3.17.0-rc4-00210-ga54b3e2 drbd.minor_count=
=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 226780K/327160K available (13836K kernel code, 4407K=
 rwdata, 7316K rodata, 2092K init, 8352K bss, 100380K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd47e0000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3fe0000   ( 319 MB)
[    0.000000]       .init : 0xc28f9000 - 0xc2b04000   (2092 kB)
[    0.000000]       .data : 0xc1d83629 - 0xc28f7e00   (11729 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1d83629   (13837 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:440 0
[    0.000000] CPU 0 irqstacks, hard=3Dcfc1a000 soft=3Dcfc1c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.17.0-rc4-00210-ga54b3e2 (kbuild@cairo) (gcc =
version 4.9.1 (Debian 4.9.1-11) ) #1 SMP PREEMPT Sat Oct 4 00:49:03 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x100000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[c00f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x037fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 4k
[    0.000000] BRK [0x03344000, 0x03344fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
[    0.000000] BRK [0x03345000, 0x03345fff] PGTABLE
[    0.000000] BRK [0x03346000, 0x03346fff] PGTABLE
[    0.000000] BRK [0x03347000, 0x03347fff] PGTABLE
[    0.000000] BRK [0x03348000, 0x03348fff] PGTABLE
[    0.000000] BRK [0x03349000, 0x03349fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13fdffff]
[    0.000000]  [mem 0x12400000-0x13fdffff] page 4k
[    0.000000] cma: Reserved 32 MiB at 10000000
[    0.000000] RAMDISK: [mem 0x12793000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE1885 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13fdffff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77792 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @d2128000 s1344576 r0 d23488 =
u1368064
[    0.000000] pcpu-alloc: s1344576 r0 d23488 u1368064 alloc=3D334*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1212a880
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80990
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-c0-10030750/linux-devel:devel-hourly-2014100306:a54b3e27e27c1bb6d=
2610eade895c04934c2667e:bisect-linux-1/.vmlinuz-a54b3e27e27c1bb6d2610eade89=
5c04934c2667e-20141004005105-94-ivb41 branch=3Dlinux-devel/devel-hourly-201=
4100306 BOOT_IMAGE=3D/kernel/i386-randconfig-c0-10030750/a54b3e27e27c1bb6d2=
610eade895c04934c2667e/vmlinuz-3.17.0-rc4-00210-ga54b3e2 drbd.minor_count=
=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 226780K/327160K available (13836K kernel code, 4407K=
 rwdata, 7316K rodata, 2092K init, 8352K bss, 100380K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd47e0000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3fe0000   ( 319 MB)
[    0.000000]       .init : 0xc28f9000 - 0xc2b04000   (2092 kB)
[    0.000000]       .data : 0xc1d83629 - 0xc28f7e00   (11729 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1d83629   (13837 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:440 0
[    0.000000] CPU 0 irqstacks, hard=3Dcfc1a000 soft=3Dcfc1c000
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 5167 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D26935080)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.030135] ACPI: Core revision 20140724
[    0.460784] ACPI: All ACPI Tables successfully acquired
[    0.466244] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.470030] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.482984] mce: CPU supports 10 MCE banks
[    0.484222] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.484222] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.500092] debug: unmapping init [mem 0xc2b04000-0xc2b0cfff]
[    0.530378] Getting VERSION: 1050014
[    0.531607] Getting VERSION: 1050014
[    0.532803] Getting ID: 0
[    0.533815] Getting ID: f000000
[    0.540026] Getting LVT0: 8700
[    0.541153] Getting LVT1: 8400
[    0.550011] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.551497] enabled ExtINT on CPU#0
[    0.560121] ENABLING IO-APIC IRQs
[    0.570117] init IO_APIC IRQs
[    0.571440]  apic 0 pin 0 not connected
[    0.580287] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.590168] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.600076] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.610148] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.620100] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.622851] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.630139] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.633096] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.640132] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.650118] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.652411] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.660211] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.670135] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.672715] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.680156] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.690152] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.700040]  apic 0 pin 16 not connected
[    0.701533]  apic 0 pin 17 not connected
[    0.710019]  apic 0 pin 18 not connected
[    0.720013]  apic 0 pin 19 not connected
[    0.730016]  apic 0 pin 20 not connected
[    0.740008]  apic 0 pin 21 not connected
[    0.741277]  apic 0 pin 22 not connected
[    0.742747]  apic 0 pin 23 not connected
[    0.744452] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.750019] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.761760] Using local APIC timer interrupts.
[    0.761760] calibrating APIC timer ...
[    0.770000] ... lapic delta =3D 12423560
[    0.770000] ... PM-Timer delta =3D 711528
[    0.770000] APIC calibration not consistent with PM-Timer: 198ms instead=
 of 100ms
[    0.770000] APIC delta adjusted to PM-Timer: 6250018 (12423560)
[    0.770000] TSC delta adjusted to PM-Timer: 269349613 (535403409)
[    0.770000] ..... delta 6250018
[    0.770000] ..... mult: 268436229
[    0.770000] ..... calibration result: 10000028
[    0.770000] ..... CPU clock speed is 2693.4961 MHz.
[    0.770000] ..... host bus clock speed is 1000.0028 MHz.
[    0.770290] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.820849] Testing tracer nop: PASSED
[    0.850584] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.871974] CPU 1 irqstacks, hard=3Dcfd6e000 soft=3Dcfd70000
[    0.873831] x86: Booting SMP configuration:
[    0.875322] .... node  #0, CPUs:      #1
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:13fdf041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.930162] x86: Booted up 1 node, 2 CPUs
[    0.931829] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.930021] KVM setup async PF for cpu 1
[    0.930021] kvm-stealtime: cpu 1, msr 12278880
[    1.040074] Testing tracer function: PASSED
[    1.205952] Testing ftrace regs(no arch support): PASSED
[    1.280088] Testing tracer irqsoff: PASSED
[    1.400069] Testing tracer preemptoff: PASSED
[    1.520079] Testing tracer preemptirqsoff: PASSED
[    1.650053] Testing tracer branch: PASSED
[    1.854422] regulator-dummy: no parameters
[    1.880528] RTC time:  0:58:04, date: 10/04/14
[    1.890520] NET: Registered protocol family 16
[    1.920561] cpuidle: using governor ladder
[    1.950175] ACPI: bus type PCI registered
[    1.952689] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    1.952689] PCI: Using configuration type 1 for base access
[    2.960551] Running resizable hashtable tests...
[    2.961868]   Adding 2048 keys
[    3.295516]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    3.297529]   Table expansion iteration 0...
[    3.350066]   Verifying lookups...
[    3.350066]   Table expansion iteration 1...
[    3.380050]   Verifying lookups...
[    3.380050]   Table expansion iteration 2...
[    3.410053]   Verifying lookups...
[    3.410053]   Table expansion iteration 3...
[    3.440067]   Verifying lookups...
[    3.440067]   Table shrinkage iteration 0...
[    3.450055]   Verifying lookups...
[    3.450055]   Table shrinkage iteration 1...
[    3.470060]   Verifying lookups...
[    3.470060]   Table shrinkage iteration 2...
[    3.480044]   Verifying lookups...
[    3.480044]   Table shrinkage iteration 3...
[    3.490049]   Verifying lookups...
[    3.490049]   Deleting 2048 keys
[    3.711616] ACPI: Added _OSI(Module Device)
[    3.711616] ACPI: Added _OSI(Processor Device)
[    3.711616] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.711616] ACPI: Added _OSI(Processor Aggregator Device)
[    3.722309] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:3)
[    4.151300] ACPI: Interpreter enabled
[    4.152592] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140724/hwxface-580)
[    4.161093] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140724/hwxface-580)
[    4.180375] ACPI: (supports S0 S3 S5)
[    4.180375] ACPI: Using IOAPIC for interrupt routing
[    4.182375] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    5.744333] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    5.750123] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    5.752411] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    5.823428] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    5.850708] PCI host bridge to bus 0000:00
[    5.852254] pci_bus 0000:00: root bus resource [bus 00-ff]
[    5.852254] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    5.852254] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    5.870067] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    5.871716] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    5.871716] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    5.871716] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    5.910061] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    5.912010] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    5.953454] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    5.983269] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    6.001841] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    6.010913] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    6.012642] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    6.014272] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    6.030021] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    6.055085] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    6.090543] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    6.092720] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    6.142637] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    6.143631] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    6.170028] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    6.191962] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    6.223382] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    6.229817] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    6.231044] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    6.279176] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    6.320777] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    6.322983] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    6.400269] pci_bus 0000:00: on NUMA node 0
[    6.523995] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    6.560227] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    6.593422] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    6.652712] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    6.693016] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    6.850000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    6.911573] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    6.920020] vgaarb: loaded
[    6.920020] vgaarb: bridge control possible 0000:00:02.0
[    7.020151] SCSI subsystem initialized
[    7.024992] Linux video capture interface: v2.00
[    7.060930] pps_core: LinuxPPS API ver. 1 registered
[    7.060930] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    7.062732] PTP clock support registered
[    7.090841] EDAC MC: Ver: 3.0.0
[    7.091778] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    7.100194] PCI: Using ACPI for IRQ routing
[    7.120048] PCI: pci_cache_line_size set to 64 bytes
[    7.121481] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    7.121794] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    7.163128] Bluetooth: Core ver 2.19
[    7.180346] NET: Registered protocol family 31
[    7.181688] Bluetooth: HCI device and connection manager initialized
[    7.181688] Bluetooth: HCI socket layer initialized
[    7.181688] Bluetooth: L2CAP socket layer initialized
[    7.182954] Bluetooth: SCO socket layer initialized
[    7.200155] NET: Registered protocol family 8
[    7.210011] NET: Registered protocol family 20
[    7.211878] nfc: nfc_init: NFC Core ver 0.1
[    7.213788] NET: Registered protocol family 39
[    7.231172] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    7.273765] Switched to clocksource kvm-clock
[    7.278785] Warning: could not register all branches stats
[    7.291136] Warning: could not register annotated branches stats
[    8.206568] FS-Cache: Loaded
[    8.208504] pnp: PnP ACPI init
[    8.217589] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    8.228621] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    8.231825] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    8.278280] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    8.298156] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    8.301345] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    8.330371] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    8.362170] pnp 00:03: [dma 2]
[    8.364501] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    8.381480] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    8.384799] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    8.405199] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    8.459213] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    8.564485] pnp: PnP ACPI: found 6 devices
[    8.974634] PM-Timer running at invalid rate: 105% of normal - aborting.
[    8.977579] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    8.979076] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    8.980509] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    9.008436] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    9.009803] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    9.011196] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    9.046392] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    9.048674] NET: Registered protocol family 2
[    9.091568] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    9.093282] TCP bind hash table entries: 4096 (order: 5, 180224 bytes)
[    9.099860] TCP: Hash tables configured (established 4096 bind 4096)
[    9.101753] TCP: reno registered
[    9.123499] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    9.135259] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    9.153342] NET: Registered protocol family 1
[    9.203862] RPC: Registered named UNIX socket transport module.
[    9.207946] RPC: Registered udp transport module.
[    9.209602] RPC: Registered tcp transport module.
[    9.216924] RPC: Registered tcp NFSv4.1 backchannel transport module
--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--gBBFr7Ir9EOA20Yy--
