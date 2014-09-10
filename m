Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaIJIvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:51:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:3200 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaIJIve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:51:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,497,1406617200"; 
   d="log'?scan'208";a="589076678"
Date: Wed, 10 Sep 2014 16:51:05 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [ftrace] WARNING: CPU: 0 PID: 1 at kernel/trace/trace.c:1127
 register_tracer()
Message-ID: <20140910085105.GA21362@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Steven,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git ftrace/core

commit 87354059881ce9315181604dc17076c535f4d744
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Tue Jul 22 20:41:42 2014 -0400
Commit:     Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue Sep 9 19:26:06 2014 -0400

    ftrace: Add helper function ftrace_ops_get_func()
    
    Add the helper function to what the mcount trampoline is to call
    for a ftrace_ops function. This helper will be used by arch code
    in the future to set up dynamic trampolines. But as this does the
    same tests that are performed in choosing what function to call for
    the default mcount trampoline, might as well use it to clean up
    the existing code.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

+---------------------------------------------------+------------+------------+------------------+
|                                                   | f1ff6348b3 | 8735405988 | v3.17-rc4_091007 |
+---------------------------------------------------+------------+------------+------------------+
| boot_successes                                    | 60         | 0          | 0                |
| boot_failures                                     | 0          | 20         | 13               |
| WARNING:at_kernel/trace/trace.c:register_tracer() | 0          | 20         | 13               |
| backtrace:register_tracer                         | 0          | 20         | 13               |
| backtrace:init_graph_trace                        | 0          | 20         | 13               |
| backtrace:kernel_init_freeable                    | 0          | 20         | 13               |
+---------------------------------------------------+------------+------------+------------------+

FAILED!
[    0.330606] ------------[ cut here ]------------
[    0.330606] ------------[ cut here ]------------
[    0.331418] WARNING: CPU: 0 PID: 1 at kernel/trace/trace.c:1127 register_tracer+0x1e5/0x309()
[    0.331418] WARNING: CPU: 0 PID: 1 at kernel/trace/trace.c:1127 register_tracer+0x1e5/0x309()
[    0.333146] CPU: 0 PID: 1 Comm: swapper Not tainted 3.17.0-rc4-00002-g8735405 #1
[    0.333146] CPU: 0 PID: 1 Comm: swapper Not tainted 3.17.0-rc4-00002-g8735405 #1
[    0.334406]  0000000000000000
[    0.334406]  0000000000000000 ffff88001284fe18 ffff88001284fe18 ffffffff8223c6b4 ffffffff8223c6b4 ffff88001284fe50 ffff88001284fe50

[    0.335758]  ffffffff810ca314
[    0.335758]  ffffffff810ca314 ffffffff81172420 ffffffff81172420 ffffffff83560880 ffffffff83560880 ffffffff83638cc0 ffffffff83638cc0

[    0.337101]  ffffffff82bc6397
[    0.337101]  ffffffff82bc6397 ffffffff8371a910 ffffffff8371a910 ffff88001284fe60 ffff88001284fe60 ffffffff810ca468 ffffffff810ca468

[    0.338435] Call Trace:
[    0.338435] Call Trace:
[    0.338886]  [<ffffffff8223c6b4>] dump_stack+0x2e/0x3e
[    0.338886]  [<ffffffff8223c6b4>] dump_stack+0x2e/0x3e
[    0.339777]  [<ffffffff810ca314>] warn_slowpath_common+0x9d/0xcb
[    0.339777]  [<ffffffff810ca314>] warn_slowpath_common+0x9d/0xcb
[    0.340015]  [<ffffffff81172420>] ? register_tracer+0x1e5/0x309
[    0.340015]  [<ffffffff81172420>] ? register_tracer+0x1e5/0x309
[    0.341041]  [<ffffffff810ca468>] warn_slowpath_null+0x28/0x31
[    0.341041]  [<ffffffff810ca468>] warn_slowpath_null+0x28/0x31
[    0.342054]  [<ffffffff81172420>] register_tracer+0x1e5/0x309
[    0.342054]  [<ffffffff81172420>] register_tracer+0x1e5/0x309
[    0.343055]  [<ffffffff836711fd>] ? init_graph_debugfs+0x4b/0x4b
[    0.343055]  [<ffffffff836711fd>] ? init_graph_debugfs+0x4b/0x4b
[    0.344098]  [<ffffffff83671299>] init_graph_trace+0x9c/0xa5
[    0.344098]  [<ffffffff83671299>] init_graph_trace+0x9c/0xa5
[    0.345081]  [<ffffffff836498ee>] do_one_initcall+0x181/0x2b4
[    0.345081]  [<ffffffff836498ee>] do_one_initcall+0x181/0x2b4
[    0.346076]  [<ffffffff83649bf5>] kernel_init_freeable+0x1d4/0x2ca
[    0.346076]  [<ffffffff83649bf5>] kernel_init_freeable+0x1d4/0x2ca
[    0.347145]  [<ffffffff8222f48c>] ? rest_init+0x150/0x150
[    0.347145]  [<ffffffff8222f48c>] ? rest_init+0x150/0x150
[    0.348085]  [<ffffffff8222f4a1>] kernel_init+0x15/0x16e
[    0.348085]  [<ffffffff8222f4a1>] kernel_init+0x15/0x16e
[    0.349006]  [<ffffffff8225313a>] ret_from_fork+0x7a/0xb0
[    0.349006]  [<ffffffff8225313a>] ret_from_fork+0x7a/0xb0
[    0.350009]  [<ffffffff8222f48c>] ? rest_init+0x150/0x150
[    0.350009]  [<ffffffff8222f48c>] ? rest_init+0x150/0x150
[    0.351004] ---[ end trace 2345852dbca13bd5 ]---
[    0.351004] ---[ end trace 2345852dbca13bd5 ]---

git bisect start a228a329e35a8738fd65282d38d6fb5bd01fc612 2ce7598c9a453e0acd0e07be7be3f5eb39608ebd --
git bisect  bad bb03cddc19085b8e20bbc578f45cb8d964a6e858  # 09:56      0-      3  Merge 'nfs/linux-next' into devel-hourly-2014091007
git bisect good 0dc01152a147470985a0f388aa0f989c17e35936  # 10:07     20+      0  Merge 'tip/perf/urgent' into devel-hourly-2014091007
git bisect good 0ace2a219b583ac59acebbb711d9aa9ed48e36d9  # 10:17     20+      0  Merge 'kees/gcc-bug' into devel-hourly-2014091007
git bisect  bad 24a777839a576d0b58ede0cfeac54700f91a6aa2  # 10:27      0-      2  Merge 'trace/ftrace/core' into devel-hourly-2014091007
git bisect good 428128377a8d63c026b3b3ae42fcacd2a3b9cf66  # 10:40     20+      0  Merge 'arm-soc/renesas/soc3' into devel-hourly-2014091007
git bisect  bad 4930d280aba6672eb44c7adcc0d47c0af8936c72  # 10:49      0-     20  ftrace: Grab any ops for a rec for enabled_functions output
git bisect  bad 87354059881ce9315181604dc17076c535f4d744  # 10:58      0-     20  ftrace: Add helper function ftrace_ops_get_func()
git bisect good f1ff6348b30b3658d138f05643149706f99078ae  # 11:11     20+      0  ftrace: Add separate function for non recursive callbacks
# first bad commit: [87354059881ce9315181604dc17076c535f4d744] ftrace: Add helper function ftrace_ops_get_func()
git bisect good f1ff6348b30b3658d138f05643149706f99078ae  # 11:16     60+      0  ftrace: Add separate function for non recursive callbacks
git bisect  bad a228a329e35a8738fd65282d38d6fb5bd01fc612  # 11:16      0-     13  0day head guard for 'devel-hourly-2014091007'
git bisect good 619df5d2870b80696fd32521376560e0a4223e44  # 11:32     60+      0  Merge tag 'microblaze-3.17-rc5' of git://git.monstr.eu/linux-2.6-microblaze
git bisect good ec86f34b250695542dd261d5dddf3e00bae4cc1c  # 12:06     60+      0  Add linux-next specific files for 20140909


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
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

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivb41-70:20140910105750:x86_64-randconfig-s1-09100924::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc4-00002-g8735405 (kbuild@snb) (gcc ve=
rsion 4.9.1 (Debian 4.9.1-11) ) #1 PREEMPT Wed Sep 10 10:55:26 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-s1-09100924/linux-devel:devel-hourly-2014091007:87354059881ce931518160=
4dc17076c535f4d744:bisect-linux-9/.vmlinuz-87354059881ce9315181604dc17076c5=
35f4d744-20140910105611-2-ivb41 branch=3Dlinux-devel/devel-hourly-201409100=
7 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-09100924/87354059881ce931518160=
4dc17076c535f4d744/vmlinuz-3.17.0-rc4-00002-g8735405 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04d79000, 0x04d79fff] PGTABLE
[    0.000000] BRK [0x04d7a000, 0x04d7afff] PGTABLE
[    0.000000] BRK [0x04d7b000, 0x04d7bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x04d7c000, 0x04d7cfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cd6000-0x13fdffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0CF0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE1854 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000BF9 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE17A4 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE181C 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13cd5001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2dca740
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-s1-09100924/linux-devel:devel-hourly-2014091007:87354059881ce93=
15181604dc17076c535f4d744:bisect-linux-9/.vmlinuz-87354059881ce9315181604dc=
17076c535f4d744-20140910105611-2-ivb41 branch=3Dlinux-devel/devel-hourly-20=
14091007 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-09100924/87354059881ce93=
15181604dc17076c535f4d744/vmlinuz-3.17.0-rc4-00002-g8735405 drbd.minor_coun=
t=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 253432K/327160K available (18774K kernel code, 9089K=
 rwdata, 11256K rodata, 1120K init, 22628K bss, 73728K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:48 0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc4-00002-g8735405 (kbuild@snb) (gcc ve=
rsion 4.9.1 (Debian 4.9.1-11) ) #1 PREEMPT Wed Sep 10 10:55:26 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-s1-09100924/linux-devel:devel-hourly-2014091007:87354059881ce931518160=
4dc17076c535f4d744:bisect-linux-9/.vmlinuz-87354059881ce9315181604dc17076c5=
35f4d744-20140910105611-2-ivb41 branch=3Dlinux-devel/devel-hourly-201409100=
7 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-09100924/87354059881ce931518160=
4dc17076c535f4d744/vmlinuz-3.17.0-rc4-00002-g8735405 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04d79000, 0x04d79fff] PGTABLE
[    0.000000] BRK [0x04d7a000, 0x04d7afff] PGTABLE
[    0.000000] BRK [0x04d7b000, 0x04d7bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x04d7c000, 0x04d7cfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cd6000-0x13fdffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0CF0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE1854 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000BF9 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE17A4 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE181C 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13cd5001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2dca740
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-s1-09100924/linux-devel:devel-hourly-2014091007:87354059881ce93=
15181604dc17076c535f4d744:bisect-linux-9/.vmlinuz-87354059881ce9315181604dc=
17076c535f4d744-20140910105611-2-ivb41 branch=3Dlinux-devel/devel-hourly-20=
14091007 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-09100924/87354059881ce93=
15181604dc17076c535f4d744/vmlinuz-3.17.0-rc4-00002-g8735405 drbd.minor_coun=
t=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 253432K/327160K available (18774K kernel code, 9089K=
 rwdata, 11256K rodata, 1120K init, 22628K bss, 73728K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:48 0
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D26935080)
5387.01 BogoMIPS (lpj=3D26935080)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140724
[    0.020000] ACPI: Core revision 20140724
[    0.020000] ACPI:=20
[    0.020000] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.020048] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.020048] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.021214] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.021214] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.023001] Initializing cgroup subsys net_cls
[    0.023001] Initializing cgroup subsys net_cls
[    0.023806] Initializing cgroup subsys perf_event
[    0.023806] Initializing cgroup subsys perf_event
[    0.024713] mce: CPU supports 10 MCE banks
[    0.024713] mce: CPU supports 10 MCE banks
[    0.025484] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.025484] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.025484] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.025484] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.027450] CPU:=20
[    0.027450] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.030248] Performance Events:=20
[    0.030248] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.032691]=20
[    0.032691] **********************************************************
[    0.032691]=20
[    0.032691] **********************************************************
[    0.034103] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.034103] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.035242] **                                                      **
[    0.035242] **                                                      **
[    0.036390] ** trace_printk() being used. Allocating extra memory.  **
[    0.036390] ** trace_printk() being used. Allocating extra memory.  **
[    0.037529] **                                                      **
[    0.037529] **                                                      **
[    0.038669] ** This means that this is a DEBUG kernel and it is     **
[    0.038669] ** This means that this is a DEBUG kernel and it is     **
[    0.039809] ** unsafe for produciton use.                           **
[    0.039809] ** unsafe for produciton use.                           **
[    0.040027] **                                                      **
[    0.040027] **                                                      **
[    0.041171] ** If you see this message and you are not debugging    **
[    0.041171] ** If you see this message and you are not debugging    **
[    0.042314] ** the kernel, report this immediately to your vendor!  **
[    0.042314] ** the kernel, report this immediately to your vendor!  **
[    0.043449] **                                                      **
[    0.043449] **                                                      **
[    0.044599] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.044599] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.045729] **********************************************************
[    0.045729] **********************************************************
[    0.047712] Testing tracer nop:=20
[    0.047712] Testing tracer nop: PASSED
PASSED
[    0.050230] Getting VERSION: 1050014
[    0.050230] Getting VERSION: 1050014
[    0.050881] Getting VERSION: 1050014
[    0.050881] Getting VERSION: 1050014
[    0.051521] Getting ID: 0
[    0.051521] Getting ID: 0
[    0.051997] Getting ID: ff000000
[    0.051997] Getting ID: ff000000
[    0.052583] Getting LVT0: 8700
[    0.052583] Getting LVT0: 8700
[    0.053127] Getting LVT1: 8400
[    0.053127] Getting LVT1: 8400
[    0.053701] enabled ExtINT on CPU#0
[    0.053701] enabled ExtINT on CPU#0
[    0.054951] ENABLING IO-APIC IRQs
[    0.054951] ENABLING IO-APIC IRQs
[    0.055556] init IO_APIC IRQs
[    0.055556] init IO_APIC IRQs
[    0.056083]  apic 0 pin 0 not connected
[    0.056083]  apic 0 pin 0 not connected
[    0.056810] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.056810] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.058222] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.058222] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.059636] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.059636] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.060024] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.060024] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.061422] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.061422] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.062819] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.062819] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.064223] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.064223] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.065614] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.065614] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.067010] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.067010] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.068409] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.068409] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.070024] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.070024] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.071450] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.071450] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.072878] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.072878] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.074292] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.074292] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.075721] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.075721] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.077139] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.077139] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.078569]  apic 0 pin 16 not connected
[    0.078569]  apic 0 pin 16 not connected
[    0.080012]  apic 0 pin 17 not connected
[    0.080012]  apic 0 pin 17 not connected
[    0.080704]  apic 0 pin 18 not connected
[    0.080704]  apic 0 pin 18 not connected
[    0.081395]  apic 0 pin 19 not connected
[    0.081395]  apic 0 pin 19 not connected
[    0.082094]  apic 0 pin 20 not connected
[    0.082094]  apic 0 pin 20 not connected
[    0.082781]  apic 0 pin 21 not connected
[    0.082781]  apic 0 pin 21 not connected
[    0.083478]  apic 0 pin 22 not connected
[    0.083478]  apic 0 pin 22 not connected
[    0.084174]  apic 0 pin 23 not connected
[    0.084174]  apic 0 pin 23 not connected
[    0.085005] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.085005] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.086024] Using local APIC timer interrupts.
[    0.086024] calibrating APIC timer ...
[    0.086024] Using local APIC timer interrupts.
[    0.086024] calibrating APIC timer ...
[    0.090000] ... lapic delta =3D 6249629
[    0.090000] ... lapic delta =3D 6249629
[    0.090000] ... PM-Timer delta =3D 357918
[    0.090000] ... PM-Timer delta =3D 357918
[    0.090000] ... PM-Timer result ok
[    0.090000] ... PM-Timer result ok
[    0.090000] ..... delta 6249629
[    0.090000] ..... delta 6249629
[    0.090000] ..... mult: 268419521
[    0.090000] ..... mult: 268419521
[    0.090000] ..... calibration result: 9999406
[    0.090000] ..... calibration result: 9999406
[    0.090000] ..... CPU clock speed is 2693.2359 MHz.
[    0.090000] ..... CPU clock speed is 2693.2359 MHz.
[    0.090000] ..... host bus clock speed is 999.9406 MHz.
[    0.090000] ..... host bus clock speed is 999.9406 MHz.
[    0.090000] gcov: version magic: 0x3430392a
[    0.090000] gcov: version magic: 0x3430392a
[    0.090808] Testing tracer function:=20
[    0.090808] Testing tracer function: PASSED
PASSED
[    0.221556] Testing ftrace regs(no arch support):=20
[    0.221556] Testing ftrace regs(no arch support): PASSED
PASSED
[    0.222526] Testing tracer function_graph:=20
[    0.222526] Testing tracer function_graph: .. no entries found .... no e=
ntries found ..FAILED!
FAILED!
[    0.330606] ------------[ cut here ]------------
[    0.330606] ------------[ cut here ]------------
[    0.331418] WARNING: CPU: 0 PID: 1 at kernel/trace/trace.c:1127 register=
_tracer+0x1e5/0x309()
[    0.331418] WARNING: CPU: 0 PID: 1 at kernel/trace/trace.c:1127 register=
_tracer+0x1e5/0x309()
[    0.333146] CPU: 0 PID: 1 Comm: swapper Not tainted 3.17.0-rc4-00002-g87=
35405 #1
[    0.333146] CPU: 0 PID: 1 Comm: swapper Not tainted 3.17.0-rc4-00002-g87=
35405 #1
[    0.334406]  0000000000000000
[    0.334406]  0000000000000000 ffff88001284fe18 ffff88001284fe18 ffffffff=
8223c6b4 ffffffff8223c6b4 ffff88001284fe50 ffff88001284fe50

[    0.335758]  ffffffff810ca314
[    0.335758]  ffffffff810ca314 ffffffff81172420 ffffffff81172420 ffffffff=
83560880 ffffffff83560880 ffffffff83638cc0 ffffffff83638cc0

[    0.337101]  ffffffff82bc6397
[    0.337101]  ffffffff82bc6397 ffffffff8371a910 ffffffff8371a910 ffff8800=
1284fe60 ffff88001284fe60 ffffffff810ca468 ffffffff810ca468

[    0.338435] Call Trace:
[    0.338435] Call Trace:
[    0.338886]  [<ffffffff8223c6b4>] dump_stack+0x2e/0x3e
[    0.338886]  [<ffffffff8223c6b4>] dump_stack+0x2e/0x3e
[    0.339777]  [<ffffffff810ca314>] warn_slowpath_common+0x9d/0xcb
[    0.339777]  [<ffffffff810ca314>] warn_slowpath_common+0x9d/0xcb
[    0.340015]  [<ffffffff81172420>] ? register_tracer+0x1e5/0x309
[    0.340015]  [<ffffffff81172420>] ? register_tracer+0x1e5/0x309
[    0.341041]  [<ffffffff810ca468>] warn_slowpath_null+0x28/0x31
[    0.341041]  [<ffffffff810ca468>] warn_slowpath_null+0x28/0x31
[    0.342054]  [<ffffffff81172420>] register_tracer+0x1e5/0x309
[    0.342054]  [<ffffffff81172420>] register_tracer+0x1e5/0x309
[    0.343055]  [<ffffffff836711fd>] ? init_graph_debugfs+0x4b/0x4b
[    0.343055]  [<ffffffff836711fd>] ? init_graph_debugfs+0x4b/0x4b
[    0.344098]  [<ffffffff83671299>] init_graph_trace+0x9c/0xa5
[    0.344098]  [<ffffffff83671299>] init_graph_trace+0x9c/0xa5
[    0.345081]  [<ffffffff836498ee>] do_one_initcall+0x181/0x2b4
[    0.345081]  [<ffffffff836498ee>] do_one_initcall+0x181/0x2b4
[    0.346076]  [<ffffffff83649bf5>] kernel_init_freeable+0x1d4/0x2ca
[    0.346076]  [<ffffffff83649bf5>] kernel_init_freeable+0x1d4/0x2ca
[    0.347145]  [<ffffffff8222f48c>] ? rest_init+0x150/0x150
[    0.347145]  [<ffffffff8222f48c>] ? rest_init+0x150/0x150
[    0.348085]  [<ffffffff8222f4a1>] kernel_init+0x15/0x16e
[    0.348085]  [<ffffffff8222f4a1>] kernel_init+0x15/0x16e
[    0.349006]  [<ffffffff8225313a>] ret_from_fork+0x7a/0xb0
[    0.349006]  [<ffffffff8225313a>] ret_from_fork+0x7a/0xb0
[    0.350009]  [<ffffffff8222f48c>] ? rest_init+0x150/0x150
[    0.350009]  [<ffffffff8222f48c>] ? rest_init+0x150/0x150
[    0.351004] ---[ end trace 2345852dbca13bd5 ]---
[    0.351004] ---[ end trace 2345852dbca13bd5 ]---
[    0.351832] Testing tracer branch:=20
[    0.351832] Testing tracer branch: PASSED
PASSED
[    0.464137] prandom: seed boundary self test passed
[    0.464137] prandom: seed boundary self test passed
[    0.465436] prandom: 100 self tests passed
[    0.465436] prandom: 100 self tests passed
[    0.467110] regulator-dummy: no parameters
[    0.467110] regulator-dummy: no parameters
[    0.468050] RTC time: 10:56:17, date: 09/10/14
[    0.468050] RTC time: 10:56:17, date: 09/10/14
[    0.469247] NET: Registered protocol family 16
[    0.469247] NET: Registered protocol family 16
[    0.471816] cpuidle: using governor menu
[    0.471816] cpuidle: using governor menu
[    0.501256] ACPI: bus type PCI registered
[    0.501256] ACPI: bus type PCI registered
[    0.502051] dca service started, version 1.12.1
[    0.502051] dca service started, version 1.12.1
[    0.502937] PCI: Using configuration type 1 for base access
[    0.502937] PCI: Using configuration type 1 for base access
[    0.530899] ACPI: Added _OSI(Module Device)
[    0.530899] ACPI: Added _OSI(Module Device)
[    0.531640] ACPI: Added _OSI(Processor Device)
[    0.531640] ACPI: Added _OSI(Processor Device)
[    0.532408] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.532408] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.533219] ACPI: Added _OSI(Processor Aggregator Device)
[    0.533219] ACPI: Added _OSI(Processor Aggregator Device)
[    0.536572] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.536572] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.543166] ACPI: Interpreter enabled
[    0.543166] ACPI: Interpreter enabled
[    0.543852] ACPI Exception: AE_NOT_FOUND,=20
[    0.543852] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
 (20140724/hwxface-580)
[    0.545481] ACPI Exception: AE_NOT_FOUND,=20
[    0.545481] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
 (20140724/hwxface-580)
[    0.547178] ACPI: (supports S0 S3 S5)
[    0.547178] ACPI: (supports S0 S3 S5)
[    0.547827] ACPI: Using IOAPIC for interrupt routing
[    0.547827] ACPI: Using IOAPIC for interrupt routing
[    0.548767] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.548767] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.565711] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.565711] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.566803] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.566803] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.568026] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.568026] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.571593] PCI host bridge to bus 0000:00
[    0.571593] PCI host bridge to bus 0000:00
[    0.572324] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.572324] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.573279] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.573279] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.574344] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.574344] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.575412] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.575412] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.576480] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.576480] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.577545] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.577545] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.578613] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.578613] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.579801] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.579801] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.580089] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.580089] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.582203] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.582203] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.584205] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.584205] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.587434] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.587434] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.590246] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.590246] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.591479] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.591479] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.592615] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.592615] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.593869] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.593869] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.595445] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.595445] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.596827] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.596827] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.598073] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.598073] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.599855] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.599855] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.601045] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.601045] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.603142] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.603142] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.608769] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.608769] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.610505] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.610505] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.612317] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.612317] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.614126] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.614126] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.618702] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.618702] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.620484] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.620484] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.621929] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.621929] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.625967] pci_bus 0000:00: on NUMA node 0
[    0.625967] pci_bus 0000:00: on NUMA node 0
[    0.628314] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.628314] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.630562] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.630562] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.631958] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.631958] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.633361] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.633361] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.634564] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.634564] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.636242] ACPI:=20
[    0.636242] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.638409] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.638409] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.639814] vgaarb: loaded
[    0.639814] vgaarb: loaded
[    0.640005] vgaarb: bridge control possible 0000:00:02.0
[    0.640005] vgaarb: bridge control possible 0000:00:02.0
[    0.641925] media: Linux media interface: v0.10
[    0.641925] media: Linux media interface: v0.10
[    0.642784] Linux video capture interface: v2.00
[    0.642784] Linux video capture interface: v2.00
[    0.643667] pps_core: LinuxPPS API ver. 1 registered
[    0.643667] pps_core: LinuxPPS API ver. 1 registered
[    0.644529] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.644529] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.646089] PTP clock support registered
[    0.646089] PTP clock support registered
[    0.646811] EDAC MC: Ver: 3.0.0
[    0.646811] EDAC MC: Ver: 3.0.0
[    0.647853] wmi: Mapper loaded
[    0.647853] wmi: Mapper loaded
[    0.648535] PCI: Using ACPI for IRQ routing
[    0.648535] PCI: Using ACPI for IRQ routing
[    0.649280] PCI: pci_cache_line_size set to 64 bytes
[    0.649280] PCI: pci_cache_line_size set to 64 bytes
[    0.650108] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.650108] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.651140] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.651140] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.652975] irda_init()
[    0.652975] irda_init()
[    0.653489] NET: Registered protocol family 23
[    0.653489] NET: Registered protocol family 23
[    0.654313] Bluetooth: Core ver 2.19
[    0.654313] Bluetooth: Core ver 2.19
[    0.654971] NET: Registered protocol family 31
[    0.654971] NET: Registered protocol family 31
[    0.655748] Bluetooth: HCI device and connection manager initialized
[    0.655748] Bluetooth: HCI device and connection manager initialized
[    0.656870] Bluetooth: HCI socket layer initialized
[    0.656870] Bluetooth: HCI socket layer initialized
[    0.657721] Bluetooth: L2CAP socket layer initialized
[    0.657721] Bluetooth: L2CAP socket layer initialized
[    0.658622] Bluetooth: SCO socket layer initialized
[    0.658622] Bluetooth: SCO socket layer initialized
[    0.659516] NET: Registered protocol family 8
[    0.659516] NET: Registered protocol family 8
[    0.660020] NET: Registered protocol family 20
[    0.660020] NET: Registered protocol family 20
[    0.661005] nfc: nfc_init: NFC Core ver 0.1
[    0.661005] nfc: nfc_init: NFC Core ver 0.1
[    0.661807] NET: Registered protocol family 39
[    0.661807] NET: Registered protocol family 39
[    0.663793] hpet0: at MMIO 0xfed00000, IRQs
[    0.663793] hpet0: at MMIO 0xfed00000, IRQs 2 2, 8, 8, 0, 0

[    0.664702] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.664702] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.671076] Switched to clocksource kvm-clock
[    0.671076] Switched to clocksource kvm-clock
[    0.672366] Warning: could not register annotated branches stats
[    0.672366] Warning: could not register annotated branches stats
[    0.718625] FS-Cache: Loaded
[    0.718625] FS-Cache: Loaded
[    0.719226] pnp: PnP ACPI init
[    0.719226] pnp: PnP ACPI init
[    0.719923] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.719923] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.721434] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.721434] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.722668] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.722668] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.724108] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.724108] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.725307] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.725307] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.726775] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.726775] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.728041] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.728041] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.729423] pnp 00:03: [dma 2]
[    0.729423] pnp 00:03: [dma 2]
[    0.730033] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.730033] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.731290] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.731290] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.732735] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.732735] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.734000] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.734000] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.735437] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.735437] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.737585] pnp: PnP ACPI: found 6 devices
[    0.737585] pnp: PnP ACPI: found 6 devices
[    0.738309] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.738309] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.744786] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.744786] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.745754] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.745754] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.746712] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.746712] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.747663] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.747663] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.748615] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.748615] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.749569] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.749569] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.750655] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.750655] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.751796] NET: Registered protocol family 2
[    0.751796] NET: Registered protocol family 2
[    0.753192] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    0.753192] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    0.754902] TCP bind hash table entries: 4096 (order: 6, 262144 bytes)
[    0.754902] TCP bind hash table entries: 4096 (order: 6, 262144 bytes)
[    0.756366] TCP: Hash tables configured (established 4096 bind 4096)
[    0.756366] TCP: Hash tables configured (established 4096 bind 4096)
[    0.757528] TCP: reno registered
[    0.757528] TCP: reno registered
[    0.758106] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.758106] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.759166] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.759166] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.760732] NET: Registered protocol family 1
[    0.760732] NET: Registered protocol family 1
[    0.761518] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.761518] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.762549] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.762549] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.763551] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.763551] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.764622] pci 0000:00:02.0: Boot video device
[    0.764622] pci 0000:00:02.0: Boot video device
[    0.765431] PCI: CLS 0 bytes, default 64
[    0.765431] PCI: CLS 0 bytes, default 64
[    0.766551] Unpacking initramfs...
[    0.766551] Unpacking initramfs...
[    0.844168] Freeing initrd memory: 3112K (ffff880013cd6000 - ffff880013f=
e0000)
[    0.844168] Freeing initrd memory: 3112K (ffff880013cd6000 - ffff880013f=
e0000)
[    0.846831] Machine check injector initialized
[    0.846831] Machine check injector initialized
[    0.847823] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.847823] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.848864] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.848864] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.851147] des3_ede-x86_64: performance on this CPU would be suboptimal=
: disabling des3_ede-x86_64.
[    0.851147] des3_ede-x86_64: performance on this CPU would be suboptimal=
: disabling des3_ede-x86_64.
[    0.852715] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.852715] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.854265] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    0.854265] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    0.856037] cryptomgr_test (22) used greatest stack depth: 14512 bytes l=
eft
[    0.856037] cryptomgr_test (22) used greatest stack depth: 14512 bytes l=
eft
[    0.858023] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    0.858023] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    0.859226] PCLMULQDQ-NI instructions are not detected.
[    0.859226] PCLMULQDQ-NI instructions are not detected.
[    0.860172] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.860172] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.861269] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.861269] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.862355] AVX or AES-NI instructions are not detected.
[    0.862355] AVX or AES-NI instructions are not detected.
[    0.863267] AVX instructions are not detected.
[    0.863267] AVX instructions are not detected.
[    0.864030] AVX instructions are not detected.
[    0.864030] AVX instructions are not detected.
[    0.864794] AVX2 or AES-NI instructions are not detected.
[    0.864794] AVX2 or AES-NI instructions are not detected.
[    0.865721] AVX2 instructions are not detected.
[    0.865721] AVX2 instructions are not detected.
[    0.866573] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.866573] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.869189] spin_lock-torture: Creating torture_shuffle task
[    0.869189] spin_lock-torture: Creating torture_shuffle task
[    0.870402] spin_lock-torture: Creating torture_stutter task
[    0.870402] spin_lock-torture: Creating torture_stutter task
[    0.871430] spin_lock-torture: torture_shuffle task started
[    0.871430] spin_lock-torture: torture_shuffle task started
[    0.872408] spin_lock-torture: Creating lock_torture_writer task
[    0.872408] spin_lock-torture: Creating lock_torture_writer task
[    0.873473] spin_lock-torture: torture_stutter task started
[    0.873473] spin_lock-torture: torture_stutter task started
[    0.874451] spin_lock-torture: Creating lock_torture_writer task
[    0.874451] spin_lock-torture: Creating lock_torture_writer task
[    0.875515] spin_lock-torture: lock_torture_writer task started
[    0.875515] spin_lock-torture: lock_torture_writer task started
[    0.876588] spin_lock-torture: Creating lock_torture_stats task
[    0.876588] spin_lock-torture: Creating lock_torture_stats task
[    0.877645] spin_lock-torture: lock_torture_writer task started
[    0.877645] spin_lock-torture: lock_torture_writer task started
[    0.879499] futex hash table entries: 256 (order: 2, 20480 bytes)
[    0.879499] futex hash table entries: 256 (order: 2, 20480 bytes)
[    0.890074] spin_lock-torture: lock_torture_stats task started
[    0.890074] spin_lock-torture: lock_torture_stats task started
[    1.840143] tsc: Refined TSC clocksource calibration: 2693.504 MHz
[    1.840143] tsc: Refined TSC clocksource calibration: 2693.504 MHz
[    1.886706] zpool: loaded
[    1.886706] zpool: loaded
[    1.887466] zbud: loaded
[    1.887466] zbud: loaded
[    1.890167] FS-Cache: Netfs 'cifs' registered for caching
[    1.890167] FS-Cache: Netfs 'cifs' registered for caching
[    1.891861] Key type cifs.spnego registered
[    1.891861] Key type cifs.spnego registered
[    1.892772] fuse init (API version 7.23)
[    1.892772] fuse init (API version 7.23)
[    1.893752] 9p: Installing v9fs 9p2000 file system support
[    1.893752] 9p: Installing v9fs 9p2000 file system support
[    1.895251] FS-Cache: Netfs 'ceph' registered for caching
[    1.895251] FS-Cache: Netfs 'ceph' registered for caching
[    1.896199] ceph: loaded (mds proto 32)
[    1.896199] ceph: loaded (mds proto 32)
[    1.896884] msgmni has been set to 501
[    1.896884] msgmni has been set to 501
[    1.897858] Key type big_key registered
[    1.897858] Key type big_key registered
[    1.912408] NET: Registered protocol family 38
[    1.912408] NET: Registered protocol family 38
[    1.913250] Key type asymmetric registered
[    1.913250] Key type asymmetric registered
[    1.913958] start plist test
[    1.913958] start plist test
[    1.920776] end plist test
[    1.920776] end plist test
[    1.921862] test_firmware: interface ready
[    1.921862] test_firmware: interface ready
[    1.922888] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.922888] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.923763] crc32: self tests passed, processed 225944 bytes in 129469 n=
sec
[    1.923763] crc32: self tests passed, processed 225944 bytes in 129469 n=
sec
[    1.925096] crc32c: CRC_LE_BITS =3D 64
[    1.925096] crc32c: CRC_LE_BITS =3D 64
[    1.925713] crc32c: self tests passed, processed 225944 bytes in 71816 n=
sec
[    1.925713] crc32c: self tests passed, processed 225944 bytes in 71816 n=
sec
[    1.943757] crc32_combine: 8373 self tests passed
[    1.943757] crc32_combine: 8373 self tests passed
[    1.961283] crc32c_combine: 8373 self tests passed
[    1.961283] crc32c_combine: 8373 self tests passed
[    1.962351] xz_dec_test: module loaded
[    1.962351] xz_dec_test: module loaded
[    1.963005] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    1.963005] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    1.964841] rbtree testing
[    1.964841] rbtree testing -> 11864 cycles
 -> 11864 cycles
[    2.475569] augmented rbtree testing
[    2.475569] augmented rbtree testing -> 16661 cycles
 -> 16661 cycles
[    3.192746] rivafb_setup START
[    3.192746] rivafb_setup START
[    3.193631] vmlfb: initializing
[    3.193631] vmlfb: initializing
[    3.194235] Could not find Carillo Ranch MCH device.
[    3.194235] Could not find Carillo Ranch MCH device.
[    3.195201] no IO addresses supplied
[    3.195201] no IO addresses supplied
[    3.198474] v86d (107) used greatest stack depth: 13600 bytes left
[    3.198474] v86d (107) used greatest stack depth: 13600 bytes left
[    3.200161] uvesafb: Getting VBE info block failed (eax=3D0x10a, err=3D0)
[    3.200161] uvesafb: Getting VBE info block failed (eax=3D0x10a, err=3D0)
[    3.201282] uvesafb: vbe_init() failed with -22
[    3.201282] uvesafb: vbe_init() failed with -22
[    3.202086] uvesafb: probe of uvesafb.0 failed with error -22
[    3.202086] uvesafb: probe of uvesafb.0 failed with error -22
[    3.203216] ipmi message handler version 39.2
[    3.203216] ipmi message handler version 39.2
[    3.204005] IPMI System Interface driver.
[    3.204005] IPMI System Interface driver.
[    3.204805] ipmi_si: Adding default-specified kcs state machine
[    3.204805] ipmi_si: Adding default-specified kcs state machine

[    3.205841] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.205841] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.207569] ipmi_si: Interface detection failed
[    3.207569] ipmi_si: Interface detection failed
[    3.208374] ipmi_si: Adding default-specified smic state machine
[    3.208374] ipmi_si: Adding default-specified smic state machine

[    3.209425] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.209425] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.211194] ipmi_si: Interface detection failed
[    3.211194] ipmi_si: Interface detection failed
[    3.211980] ipmi_si: Adding default-specified bt state machine
[    3.211980] ipmi_si: Adding default-specified bt state machine

[    3.212998] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.212998] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.214673] ipmi_si: Interface detection failed
[    3.214673] ipmi_si: Interface detection failed
[    3.215722] ipmi_si: Unable to find any System Interface(s)
[    3.215722] ipmi_si: Unable to find any System Interface(s)
[    3.216861] IPMI Watchdog: driver initialized
[    3.216861] IPMI Watchdog: driver initialized
[    3.217718] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    3.217718] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    3.219479] IPMI poweroff: Unable to register powercycle sysctl
[    3.219479] IPMI poweroff: Unable to register powercycle sysctl
[    3.223353] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.223353] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.224636] ACPI: Power Button [PWRF]
[    3.224636] ACPI: Power Button [PWRF]
[    3.226169] ERST DBG: ERST support is disabled.
[    3.226169] ERST DBG: ERST support is disabled.
[    3.226964] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.226964] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.251184] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.251184] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.252130] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.252130] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.280775] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.280775] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.283775] Initializing Nozomi driver 2.1d
[    3.283775] Initializing Nozomi driver 2.1d
[    3.284773] lp: driver loaded but no devices found
[    3.284773] lp: driver loaded but no devices found
[    3.285847] Non-volatile memory driver v1.3
[    3.285847] Non-volatile memory driver v1.3
[    3.286840] Linux agpgart interface v0.103
[    3.286840] Linux agpgart interface v0.103
[    3.287952] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    3.287952] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    3.289685] [drm] Initialized drm 1.1.0 20060810
[    3.289685] [drm] Initialized drm 1.1.0 20060810
[    3.290720] [drm] radeon kernel modesetting enabled.
[    3.290720] [drm] radeon kernel modesetting enabled.
[    3.292151] dummy-irq: no IRQ given.  Use irq=3DN
[    3.292151] dummy-irq: no IRQ given.  Use irq=3DN
[    3.293016] Phantom Linux Driver, version n0.9.8, init OK
[    3.293016] Phantom Linux Driver, version n0.9.8, init OK
[    3.294224] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.294224] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.295674] c2port c2port0: C2 port uc added
[    3.295674] c2port c2port0: C2 port uc added
[    3.296419] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    3.296419] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    3.297945] Guest personality initialized and is inactive
[    3.297945] Guest personality initialized and is inactive
[    3.298963] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D58)
[    3.298963] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D58)
[    3.300126] Initialized host personality
[    3.300126] Initialized host personality
[    3.300810] mic_init not running on X100 ret -19
[    3.300810] mic_init not running on X100 ret -19
[    3.302589] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    3.302589] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    3.303754] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    3.303754] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    3.305069] device id =3D 2440
[    3.305069] device id =3D 2440
[    3.305572] device id =3D 2480
[    3.305572] device id =3D 2480
[    3.306083] device id =3D 24c0
[    3.306083] device id =3D 24c0
[    3.306584] device id =3D 24d0
[    3.306584] device id =3D 24d0
[    3.307091] device id =3D 25a1
[    3.307091] device id =3D 25a1
[    3.307592] device id =3D 2670
[    3.307592] device id =3D 2670
[    3.308161] platform physmap-flash.0: failed to claim resource 0
[    3.308161] platform physmap-flash.0: failed to claim resource 0
[    3.346072] No valid DiskOnChip devices found
[    3.346072] No valid DiskOnChip devices found
[    3.346900] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.346900] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.348508] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.348508] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.350339] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.350339] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.352109] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.352109] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.353722] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.353722] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.355329] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.355329] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.356928] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    3.356928] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    3.358012] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    3.358012] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    3.358808] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    3.358808] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    3.359816] flash size: 128 MiB
[    3.359816] flash size: 128 MiB
[    3.360493] page size: 512 bytes
[    3.360493] page size: 512 bytes
[    3.361186] OOB area size: 16 bytes
[    3.361186] OOB area size: 16 bytes
[    3.361792] sector size: 16 KiB
[    3.361792] sector size: 16 KiB
[    3.362344] pages number: 262144
[    3.362344] pages number: 262144
[    3.362900] pages per sector: 32
[    3.362900] pages per sector: 32
[    3.363464] bus width: 8
[    3.363464] bus width: 8
[    3.363909] bits in sector size: 14
[    3.363909] bits in sector size: 14
[    3.364518] bits in page size: 9
[    3.364518] bits in page size: 9
[    3.365083] bits in OOB size: 4
[    3.365083] bits in OOB size: 4
[    3.365623] flash size with OOB: 135168 KiB
[    3.365623] flash size with OOB: 135168 KiB
[    3.366345] page address bytes: 4
[    3.366345] page address bytes: 4
[    3.366918] sector address bytes: 3
[    3.366918] sector address bytes: 3
[    3.367529] options: 0x42
[    3.367529] options: 0x42
[    3.369240] Scanning device for bad blocks
[    3.369240] Scanning device for bad blocks
[    3.401724] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.401724] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.402812] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.402812] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.405506] Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[    3.405506] Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[    3.408272] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[    3.408272] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[    3.411006] libphy: Fixed MDIO Bus: probed
[    3.411006] libphy: Fixed MDIO Bus: probed
[    3.412178] arcnet loaded.
[    3.412178] arcnet loaded.
[    3.412658] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[    3.412658] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[    3.413836] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    3.413836] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    3.415119] arcnet: raw mode (`r') encapsulation support loaded.
[    3.415119] arcnet: raw mode (`r') encapsulation support loaded.
[    3.416155] arcnet: cap mode (`c') encapsulation support loaded.
[    3.416155] arcnet: cap mode (`c') encapsulation support loaded.
[    3.417187] arcnet: COM90xx chipset support
[    3.417187] arcnet: COM90xx chipset support
[    3.738629] S3: No ARCnet cards found.
[    3.738629] S3: No ARCnet cards found.
[    3.739329] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[    3.739329] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[    3.740587] E-mail me if you actually test this driver, please!
[    3.740587] E-mail me if you actually test this driver, please!
[    3.741607]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[    3.741607]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[    3.743360] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    3.743360] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    3.744298] Copyright (c) 2007 Atheros Corporation.
[    3.744298] Copyright (c) 2007 Atheros Corporation.
[    3.745310] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[    3.745310] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[    3.747258] Brocade 10G Ethernet driver - version: 3.2.23.0
[    3.747258] Brocade 10G Ethernet driver - version: 3.2.23.0
[    3.748524] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    3.748524] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    3.749832] atp.c:v1.09=3Dac 2002/10/01 Donald Becker <becker@scyld.com>
[    3.749832] atp.c:v1.09=3Dac 2002/10/01 Donald Becker <becker@scyld.com>
[    3.751536] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    3.751536] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    3.752538] tehuti: Options: hw_csum=20
[    3.752538] tehuti: Options: hw_csum=20
[    3.753292] YAM driver version 0.8 by F1OAT/F6FBB
[    3.753292] YAM driver version 0.8 by F1OAT/F6FBB
[    3.755350] AX.25: bpqether driver version 004
[    3.755350] AX.25: bpqether driver version 004
[    3.756134] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    3.756134] baycom_ser_hdx: version 0.10
[    3.756134] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    3.756134] baycom_ser_hdx: version 0.10
[    3.759072] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    3.759072] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    3.760087] hdlcdrv: version 0.8
[    3.760087] hdlcdrv: version 0.8
[    3.760710] PPP generic driver version 2.4.2
[    3.760710] PPP generic driver version 2.4.2
[    3.761612] PPP Deflate Compression module registered
[    3.761612] PPP Deflate Compression module registered
[    3.762503] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    3.762503] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    3.763711] CSLIP: code copyright 1989 Regents of the University of Cali=
fornia.
[    3.763711] CSLIP: code copyright 1989 Regents of the University of Cali=
fornia.
[    3.764967] Madge ATM Ambassador driver version 1.2.4
[    3.764967] Madge ATM Ambassador driver version 1.2.4
[    3.765879] Madge ATM Horizon [Ultra] driver version 1.2.1
[    3.765879] Madge ATM Horizon [Ultra] driver version 1.2.1
[    3.766874] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
[    3.766874] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
[    3.768089] idt77252_init: at ffffffff836aa084
[    3.768089] idt77252_init: at ffffffff836aa084
[    3.768897] Solos PCI Driver Version 1.04
[    3.768897] Solos PCI Driver Version 1.04
[    3.769637] adummy: version 1.0
[    3.769637] adummy: version 1.0
[    3.771578] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.771578] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.773823] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.773823] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.775125] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.775125] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.776153] parkbd: no such parport
[    3.776153] parkbd: no such parport
[    3.777098] mousedev: PS/2 mouse device common for all mice
[    3.777098] mousedev: PS/2 mouse device common for all mice
[    3.779261] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.779261] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.781596] mk712: device not present
[    3.781596] mk712: device not present
[    3.782417] I2O subsystem v1.325
[    3.782417] I2O subsystem v1.325
[    3.782983] i2o: max drivers =3D 8
[    3.782983] i2o: max drivers =3D 8
[    3.783740] I2O Configuration OSM v1.323
[    3.783740] I2O Configuration OSM v1.323
[    3.784462] I2O ProcFS OSM v1.316
[    3.784462] I2O ProcFS OSM v1.316
[    3.785112] i2c /dev entries driver
[    3.785112] i2c /dev entries driver
[    3.786233] i2c-parport-light: adapter type unspecified
[    3.786233] i2c-parport-light: adapter type unspecified
[    3.787506] IR RC6 protocol handler initialized
[    3.787506] IR RC6 protocol handler initialized
[    3.788293] IR JVC protocol handler initialized
[    3.788293] IR JVC protocol handler initialized
[    3.789076] IR SANYO protocol handler initialized
[    3.789076] IR SANYO protocol handler initialized
[    3.789886] IR Sharp protocol handler initialized
[    3.789886] IR Sharp protocol handler initialized
[    3.790733] IR MCE Keyboard/mouse protocol handler initialized
[    3.790733] IR MCE Keyboard/mouse protocol handler initialized
[    3.791748] IR XMP protocol handler initialized
[    3.791748] IR XMP protocol handler initialized
[    3.792778] vivi-000: V4L2 device registered as video0
[    3.792778] vivi-000: V4L2 device registered as video0
[    3.793671] Video Technology Magazine Virtual Video Capture Board ver 0.=
8.1 successfully loaded.
[    3.793671] Video Technology Magazine Virtual Video Capture Board ver 0.=
8.1 successfully loaded.
[    3.795367] m2m-testdev m2m-testdev.0: Device registered as /dev/video1
[    3.795367] m2m-testdev m2m-testdev.0: Device registered as /dev/video1
[    3.796947] pps pps0: new PPS source ktimer
[    3.796947] pps pps0: new PPS source ktimer
[    3.797683] pps pps0: ktimer PPS source registered
[    3.797683] pps pps0: ktimer PPS source registered
[    3.798513] pps_ldisc: PPS line discipline registered
[    3.798513] pps_ldisc: PPS line discipline registered
[    3.799388] pps_parport: parallel port PPS client
[    3.799388] pps_parport: parallel port PPS client
[    3.800255] Driver for 1-wire Dallas network protocol.
[    3.800255] Driver for 1-wire Dallas network protocol.
[    3.801304] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    3.801304] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    3.806831] Bluetooth: Virtual HCI driver ver 1.5
[    3.806831] Bluetooth: Virtual HCI driver ver 1.5
[    3.808278] sdhci: Secure Digital Host Controller Interface driver
[    3.808278] sdhci: Secure Digital Host Controller Interface driver
[    3.809343] sdhci: Copyright(c) Pierre Ossman
[    3.809343] sdhci: Copyright(c) Pierre Ossman
[    3.811091] iw_cm: couldn't register sysctl paths
[    3.811091] iw_cm: couldn't register sysctl paths
[    3.812448] rdma_ucm: couldn't register sysctl paths
[    3.812448] rdma_ucm: couldn't register sysctl paths
[    3.814218] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.814218] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.818239] msi_laptop: Brightness ignored, must be controlled by ACPI v=
ideo driver
[    3.818239] msi_laptop: Brightness ignored, must be controlled by ACPI v=
ideo driver
[    3.819868] dell_wmi: No known WMI GUID found
[    3.819868] dell_wmi: No known WMI GUID found
[    3.820701] dell_wmi_aio: No known WMI GUID found
[    3.820701] dell_wmi_aio: No known WMI GUID found
[    3.821576] acer_wmi: Acer Laptop ACPI-WMI Extras
[    3.821576] acer_wmi: Acer Laptop ACPI-WMI Extras
[    3.822399] acer_wmi: No or unsupported WMI interface, unable to load
[    3.822399] acer_wmi: No or unsupported WMI interface, unable to load
[    3.823499] acerhdf: error getting hardware information
[    3.823499] acerhdf: error getting hardware information
[    3.824502] hdaps: supported laptop not found!
[    3.824502] hdaps: supported laptop not found!
[    3.825270] hdaps: driver init failed (ret=3D-19)!
[    3.825270] hdaps: driver init failed (ret=3D-19)!
[    3.826122] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[    3.826122] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[    3.827951] alienware_wmi: alienware-wmi: No known WMI GUID found
[    3.827951] alienware_wmi: alienware-wmi: No known WMI GUID found
[    3.829220] oprofile: using NMI interrupt.
[    3.829220] oprofile: using NMI interrupt.
[    3.829955] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    3.829955] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    3.831550] drop_monitor: Initializing network drop monitor service
[    3.831550] drop_monitor: Initializing network drop monitor service
[    3.832748] NET: Registered protocol family 26
[    3.832748] NET: Registered protocol family 26
[    3.833599] Netfilter messages via NETLINK v0.30.
[    3.833599] Netfilter messages via NETLINK v0.30.
[    3.834508] nf_conntrack version 0.5.0 (2004 buckets, 8016 max)
[    3.834508] nf_conntrack version 0.5.0 (2004 buckets, 8016 max)
[    3.835774] ctnetlink v0.93: registering with nfnetlink.
[    3.835774] ctnetlink v0.93: registering with nfnetlink.
[    3.836901] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    3.836901] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    3.838038] nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilte=
r.org>
[    3.838038] nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilte=
r.org>
[    3.839604] IPVS: Registered protocols (TCP, ESP)
[    3.839604] IPVS: Registered protocols (TCP, ESP)
[    3.840522] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[    3.840522] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[    3.841784] IPVS: Each connection entry needs 376 bytes at least
[    3.841784] IPVS: Each connection entry needs 376 bytes at least
[    3.842854] IPVS: Creating netns size=3D1720 id=3D0
[    3.842854] IPVS: Creating netns size=3D1720 id=3D0
[    3.843719] IPVS: ipvs loaded.
[    3.843719] IPVS: ipvs loaded.
[    3.844296] IPVS: [rr] scheduler registered.
[    3.844296] IPVS: [rr] scheduler registered.
[    3.845044] IPVS: [lc] scheduler registered.
[    3.845044] IPVS: [lc] scheduler registered.
[    3.845785] IPVS: [wlc] scheduler registered.
[    3.845785] IPVS: [wlc] scheduler registered.
[    3.846556] IPVS: [lblc] scheduler registered.
[    3.846556] IPVS: [lblc] scheduler registered.
[    3.847335] IPVS: [lblcr] scheduler registered.
[    3.847335] IPVS: [lblcr] scheduler registered.
[    3.848126] IPVS: [dh] scheduler registered.
[    3.848126] IPVS: [dh] scheduler registered.
[    3.848872] IPVS: [sh] scheduler registered.
[    3.848872] IPVS: [sh] scheduler registered.
[    3.849616] IPVS: [sed] scheduler registered.
[    3.849616] IPVS: [sed] scheduler registered.
[    3.850398] IPVS: [nq] scheduler registered.
[    3.850398] IPVS: [nq] scheduler registered.
[    3.851150] ipip: IPv4 over IPv4 tunneling driver
[    3.851150] ipip: IPv4 over IPv4 tunneling driver
[    3.852321] IPv4 over IPsec tunneling driver
[    3.852321] IPv4 over IPsec tunneling driver
[    3.853567] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.853567] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.854608] arp_tables: (C) 2002 David S. Miller
[    3.854608] arp_tables: (C) 2002 David S. Miller
[    3.855481] TCP: cubic registered
[    3.855481] TCP: cubic registered
[    3.856070] Initializing XFRM netlink socket
[    3.856070] Initializing XFRM netlink socket
[    3.857330] NET: Registered protocol family 10
[    3.857330] NET: Registered protocol family 10
[    3.859130] mip6: Mobile IPv6
[    3.859130] mip6: Mobile IPv6
[    3.859675] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.859675] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.861597] NET: Registered protocol family 15
[    3.861597] NET: Registered protocol family 15
[    3.862438] NET: Registered protocol family 4
[    3.862438] NET: Registered protocol family 4
[    3.863255] NET: Registered protocol family 9
[    3.863255] NET: Registered protocol family 9
[    3.864013] X25: Linux Version 0.2
[    3.864013] X25: Linux Version 0.2
[    3.865812] NET: Registered protocol family 6
[    3.865812] NET: Registered protocol family 6
[    3.869572] NET: Registered protocol family 11
[    3.869572] NET: Registered protocol family 11
[    3.870451] NET: Registered protocol family 3
[    3.870451] NET: Registered protocol family 3
[    3.871739] IrCOMM protocol (Dag Brattli)
[    3.871739] IrCOMM protocol (Dag Brattli)
[    3.873989] Bluetooth: RFCOMM TTY layer initialized
[    3.873989] Bluetooth: RFCOMM TTY layer initialized
[    3.874850] Bluetooth: RFCOMM socket layer initialized
[    3.874850] Bluetooth: RFCOMM socket layer initialized
[    3.875758] Bluetooth: RFCOMM ver 1.11
[    3.875758] Bluetooth: RFCOMM ver 1.11
[    3.876426] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.876426] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.877351] Bluetooth: BNEP socket layer initialized
[    3.877351] Bluetooth: BNEP socket layer initialized
[    3.878210] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    3.878210] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    3.879225] Bluetooth: HIDP socket layer initialized
[    3.879225] Bluetooth: HIDP socket layer initialized
[    3.880472] NET: Registered protocol family 33
[    3.880472] NET: Registered protocol family 33
[    3.881251] Key type rxrpc registered
[    3.881251] Key type rxrpc registered
[    3.881881] Key type rxrpc_s registered
[    3.881881] Key type rxrpc_s registered
[    3.882738] RxRPC: Registered security type 2 'rxkad'
[    3.882738] RxRPC: Registered security type 2 'rxkad'
[    3.883681] l2tp_core: L2TP core driver, V2.0
[    3.883681] l2tp_core: L2TP core driver, V2.0
[    3.884446] l2tp_netlink: L2TP netlink interface
[    3.884446] l2tp_netlink: L2TP netlink interface
[    3.885269] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[    3.885269] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[    3.886300] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    3.886300] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    3.887805] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    3.887805] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    3.888962] NET: Registered protocol family 12
[    3.888962] NET: Registered protocol family 12
[    3.889783] NET: Registered protocol family 35
[    3.889783] NET: Registered protocol family 35
[    3.890708] tipc: Activated (version 2.0.0)
[    3.890708] tipc: Activated (version 2.0.0)
[    3.891659] NET: Registered protocol family 30
[    3.891659] NET: Registered protocol family 30
[    3.892711] tipc: Started in single node mode
[    3.892711] tipc: Started in single node mode
[    3.893531] 9pnet: Installing 9P2000 support
[    3.893531] 9pnet: Installing 9P2000 support
[    3.894369] NET: Registered protocol family 36
[    3.894369] NET: Registered protocol family 36
[    3.895290] Key type dns_resolver registered
[    3.895290] Key type dns_resolver registered
[    3.896048] Key type ceph registered
[    3.896048] Key type ceph registered
[    3.896819] libceph: loaded (mon/osd proto 15/24)
[    3.896819] libceph: loaded (mon/osd proto 15/24)
[    3.897640] openvswitch: Open vSwitch switching datapath
[    3.897640] openvswitch: Open vSwitch switching datapath
[    3.898855] NET: Registered protocol family 40
[    3.898855] NET: Registered protocol family 40
[    3.899631] mpls_gso: MPLS GSO support
[    3.899631] mpls_gso: MPLS GSO support
[    3.901791]=20
[    3.901791] printing PIC contents
[    3.901791]=20
[    3.901791] printing PIC contents
[    3.902631] ... PIC  IMR: ffff
[    3.902631] ... PIC  IMR: ffff
[    3.903171] ... PIC  IRR: 1013
[    3.903171] ... PIC  IRR: 1013
[    3.903703] ... PIC  ISR: 0000
[    3.903703] ... PIC  ISR: 0000
[    3.904240] ... PIC ELCR: 0c00
[    3.904240] ... PIC ELCR: 0c00
[    3.904767] printing local APIC contents on CPU#0/0:
[    3.904767] printing local APIC contents on CPU#0/0:
[    3.905621] ... APIC ID:      00000000 (0)
[    3.905621] ... APIC ID:      00000000 (0)
[    3.906328] ... APIC VERSION: 01050014
[    3.906328] ... APIC VERSION: 01050014
[    3.906973] ... APIC TASKPRI: 00000000 (00)
[    3.906973] ... APIC TASKPRI: 00000000 (00)
[    3.907700] ... APIC PROCPRI: 00000000
[    3.907700] ... APIC PROCPRI: 00000000
[    3.908348] ... APIC LDR: 01000000
[    3.908348] ... APIC LDR: 01000000
[    3.908932] ... APIC DFR: ffffffff
[    3.908932] ... APIC DFR: ffffffff
[    3.909522] ... APIC SPIV: 000001ff
[    3.909522] ... APIC SPIV: 000001ff
[    3.910130] ... APIC ISR field:
[    3.910130] ... APIC ISR field:
[    3.910291] 00000000
[    3.910291] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    3.910291] ... APIC TMR field:
[    3.910291] ... APIC TMR field:
[    3.910291] 00000000
[    3.910291] 000000000e2000000e200000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    3.910291] ... APIC IRR field:
[    3.910291] ... APIC IRR field:
[    3.910291] 00000000
[    3.910291] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    3.910291] ... APIC ESR: 00000000
[    3.910291] ... APIC ESR: 00000000
[    3.910291] ... APIC ICR: 00000831
[    3.910291] ... APIC ICR: 00000831
[    3.910291] ... APIC ICR2: 01000000
[    3.910291] ... APIC ICR2: 01000000
[    3.910291] ... APIC LVTT: 000000ef
[    3.910291] ... APIC LVTT: 000000ef
[    3.910291] ... APIC LVTPC: 00010000
[    3.910291] ... APIC LVTPC: 00010000
[    3.910291] ... APIC LVT0: 00010700
[    3.910291] ... APIC LVT0: 00010700
[    3.910291] ... APIC LVT1: 00000400
[    3.910291] ... APIC LVT1: 00000400
[    3.910291] ... APIC LVTERR: 000000fe
[    3.910291] ... APIC LVTERR: 000000fe
[    3.910291] ... APIC TMICT: 0009416a
[    3.910291] ... APIC TMICT: 0009416a
[    3.910291] ... APIC TMCCT: 00000000
[    3.910291] ... APIC TMCCT: 00000000
[    3.910291] ... APIC TDCR: 00000003
[    3.910291] ... APIC TDCR: 00000003
[    3.910291]=20
[    3.910291]=20
[    3.922847] number of MP IRQ sources: 15.
[    3.922847] number of MP IRQ sources: 15.
[    3.923553] number of IO-APIC #0 registers: 24.
[    3.923553] number of IO-APIC #0 registers: 24.
[    3.924335] testing the IO APIC.......................
[    3.924335] testing the IO APIC.......................
[    3.925237] IO APIC #0......
[    3.925237] IO APIC #0......
[    3.925734] .... register #00: 00000000
[    3.925734] .... register #00: 00000000
[    3.926398] .......    : physical APIC id: 00
[    3.926398] .......    : physical APIC id: 00
[    3.927151] .......    : Delivery Type: 0
[    3.927151] .......    : Delivery Type: 0
[    3.927839] .......    : LTS          : 0
[    3.927839] .......    : LTS          : 0
[    3.928537] .... register #01: 00170011
[    3.928537] .... register #01: 00170011
[    3.929207] .......     : max redirection entries: 17
[    3.929207] .......     : max redirection entries: 17
[    3.930114] .......     : PRQ implemented: 0
[    3.930114] .......     : PRQ implemented: 0
[    3.930850] .......     : IO APIC version: 11
[    3.930850] .......     : IO APIC version: 11
[    3.931608] .... register #02: 00000000
[    3.931608] .... register #02: 00000000
[    3.932276] .......     : arbitration: 00
[    3.932276] .......     : arbitration: 00
[    3.932963] .... IRQ redirection table:
[    3.932963] .... IRQ redirection table:
[    3.933639] 1    0    0   0   0    0    0    00
[    3.933639] 1    0    0   0   0    0    0    00
[    3.934431] 0    0    0   0   0    1    1    31
[    3.934431] 0    0    0   0   0    1    1    31
[    3.935220] 0    0    0   0   0    1    1    30
[    3.935220] 0    0    0   0   0    1    1    30
[    3.936002] 0    0    0   0   0    1    1    33
[    3.936002] 0    0    0   0   0    1    1    33
[    3.936791] 1    0    0   0   0    1    1    34
[    3.936791] 1    0    0   0   0    1    1    34
[    3.937581] 1    1    0   0   0    1    1    35
[    3.937581] 1    1    0   0   0    1    1    35
[    3.938368] 0    0    0   0   0    1    1    36
[    3.938368] 0    0    0   0   0    1    1    36
[    3.939159] 0    0    0   0   0    1    1    37
[    3.939159] 0    0    0   0   0    1    1    37
[    3.939941] 0    0    0   0   0    1    1    38
[    3.939941] 0    0    0   0   0    1    1    38
[    3.940756] 0    1    0   0   0    1    1    39
[    3.940756] 0    1    0   0   0    1    1    39
[    3.941548] 1    1    0   0   0    1    1    3A
[    3.941548] 1    1    0   0   0    1    1    3A
[    3.942340] 1    1    0   0   0    1    1    3B
[    3.942340] 1    1    0   0   0    1    1    3B
[    3.943131] 0    0    0   0   0    1    1    3C
[    3.943131] 0    0    0   0   0    1    1    3C
[    3.943915] 0    0    0   0   0    1    1    3D
[    3.943915] 0    0    0   0   0    1    1    3D
[    3.944708] 0    0    0   0   0    1    1    3E
[    3.944708] 0    0    0   0   0    1    1    3E
[    3.945499] 0    0    0   0   0    1    1    3F
[    3.945499] 0    0    0   0   0    1    1    3F
[    3.946290] 1    0    0   0   0    0    0    00
[    3.946290] 1    0    0   0   0    0    0    00
[    3.947084] 1    0    0   0   0    0    0    00
[    3.947084] 1    0    0   0   0    0    0    00
[    3.947866] 1    0    0   0   0    0    0    00
[    3.947866] 1    0    0   0   0    0    0    00
[    3.948656] 1    0    0   0   0    0    0    00
[    3.948656] 1    0    0   0   0    0    0    00
[    3.949446] 1    0    0   0   0    0    0    00
[    3.949446] 1    0    0   0   0    0    0    00
[    3.950256] 1    0    0   0   0    0    0    00
[    3.950256] 1    0    0   0   0    0    0    00
[    3.951049] 1    0    0   0   0    0    0    00
[    3.951049] 1    0    0   0   0    0    0    00
[    3.951835] 1    0    0   0   0    0    0    00
[    3.951835] 1    0    0   0   0    0    0    00
[    3.952617] IRQ to pin mappings:
[    3.952617] IRQ to pin mappings:
[    3.953183] IRQ0=20
[    3.953183] IRQ0 -> 0:2-> 0:2

[    3.953643] IRQ1=20
[    3.953643] IRQ1 -> 0:1-> 0:1

[    3.954108] IRQ3=20
[    3.954108] IRQ3 -> 0:3-> 0:3

[    3.954567] IRQ4=20
[    3.954567] IRQ4 -> 0:4-> 0:4

[    3.955034] IRQ5=20
[    3.955034] IRQ5 -> 0:5-> 0:5

[    3.955494] IRQ6=20
[    3.955494] IRQ6 -> 0:6-> 0:6

[    3.955953] IRQ7=20
[    3.955953] IRQ7 -> 0:7-> 0:7

[    3.956418] IRQ8=20
[    3.956418] IRQ8 -> 0:8-> 0:8

[    3.956879] IRQ9=20
[    3.956879] IRQ9 -> 0:9-> 0:9

[    3.957342] IRQ10=20
[    3.957342] IRQ10 -> 0:10-> 0:10

[    3.957830] IRQ11=20
[    3.957830] IRQ11 -> 0:11-> 0:11

[    3.958325] IRQ12=20
[    3.958325] IRQ12 -> 0:12-> 0:12

[    3.958813] IRQ13=20
[    3.958813] IRQ13 -> 0:13-> 0:13

[    3.959309] IRQ14=20
[    3.959309] IRQ14 -> 0:14-> 0:14

[    3.959796] IRQ15=20
[    3.959796] IRQ15 -> 0:15-> 0:15

[    3.960311] .................................... done.
[    3.960311] .................................... done.
[    3.961411] bootconsole [earlyser0] disabled
[    3.961411] bootconsole [earlyser0] disabled
[    3.962324] registered taskstats version 1
[    3.962707] Running tests on trace events:
[    3.963085] Testing event thermal_apic_exit: OK
[    3.980220] Testing event thermal_apic_entry: OK
[    4.010156] Testing event threshold_apic_exit: OK
[    4.040174] Testing event threshold_apic_entry: OK
[    4.070186] Testing event call_function_single_exit: OK
[    4.100409] Testing event call_function_single_entry: OK
[    4.130219] Testing event call_function_exit: OK
[    4.160156] Testing event call_function_entry: OK
[    4.190166] Testing event irq_work_exit: OK
[    4.220155] Testing event irq_work_entry: OK
[    4.250163] Testing event x86_platform_ipi_exit: OK
[    4.280140] Testing event x86_platform_ipi_entry: OK
[    4.310171] Testing event error_apic_exit: OK
[    4.340163] Testing event error_apic_entry: OK
[    4.370158] Testing event spurious_apic_exit: OK
[    4.400154] Testing event spurious_apic_entry: OK
[    4.430156] Testing event reschedule_exit: OK
[    4.460150] Testing event reschedule_entry: OK
[    4.490163] Testing event local_timer_exit: OK
[    4.520144] Testing event local_timer_entry: OK
[    4.550162] Testing event nmi_handler: OK
[    4.580150] Testing event emulate_vsyscall: OK
[    4.610165] Testing event sys_exit: OK
[    4.640170] Testing event sys_enter: OK
[    4.670167] Testing event mce_record: OK
[    4.700151] Testing event tlb_flush: OK
[    4.730174] Testing event page_fault_kernel: OK
[    4.760139] Testing event page_fault_user: OK
[    4.790351] Testing event task_rename: OK
[    4.820178] Testing event task_newtask: OK
[    4.850157] Testing event softirq_raise: OK
[    4.880149] Testing event softirq_exit: OK
[    4.910156] Testing event softirq_entry: OK
[    4.940146] Testing event irq_handler_exit: OK
[    4.970155] Testing event irq_handler_entry: OK
[    5.000134] Testing event signal_deliver: OK
[    5.030155] Testing event signal_generate: OK
[    5.060145] Testing event workqueue_execute_end: OK
[    5.090157] Testing event workqueue_execute_start: OK
[    5.120141] Testing event workqueue_activate_work: OK
[    5.150153] Testing event workqueue_queue_work: OK
[    5.180142] Testing event sched_wake_idle_without_ipi: OK
[    5.210162] Testing event sched_swap_numa: OK
[    5.240148] Testing event sched_stick_numa: OK
[    5.270157] Testing event sched_move_numa: OK
[    5.300403] Testing event sched_pi_setprio: OK
[    5.330166] Testing event sched_stat_runtime: OK
[    5.360149] Testing event sched_stat_blocked: OK
[    5.390163] Testing event sched_stat_iowait: OK
[    5.420143] Testing event sched_stat_sleep: OK
[    5.450154] Testing event sched_stat_wait: OK
[    5.480139] Testing event sched_process_exec: OK
[    5.510154] Testing event sched_process_fork: OK
[    5.540145] Testing event sched_process_wait: OK
[    5.570159] Testing event sched_wait_task: OK
[    5.600162] Testing event sched_process_exit: OK
[    5.630167] Testing event sched_process_free: OK
[    5.660140] Testing event sched_migrate_task: OK
[    5.690159] Testing event sched_switch: OK
[    5.720151] Testing event sched_wakeup_new: OK
[    5.750160] Testing event sched_wakeup: OK
[    5.780147] Testing event sched_kthread_stop_ret: OK
[    5.810155] Testing event sched_kthread_stop: OK
[    5.840278] Testing event lock_release: OK
[    5.870207] Testing event lock_acquire: OK
[    5.900170] Testing event console: OK
[    5.930161] Testing event rcu_barrier: OK
[    5.960140] Testing event rcu_torture_read: OK
[    5.990158] Testing event rcu_batch_end: OK
[    6.020144] Testing event rcu_invoke_kfree_callback: OK
[    6.050163] Testing event rcu_invoke_callback: OK
[    6.080151] Testing event rcu_batch_start: OK
[    6.110155] Testing event rcu_kfree_callback: OK
[    6.140144] Testing event rcu_callback: OK
[    6.170162] Testing event rcu_prep_idle: OK
[    6.200139] Testing event rcu_dyntick: OK
[    6.230158] Testing event rcu_fqs: OK
[    6.260137] Testing event rcu_quiescent_state_report: OK
[    6.290154] Testing event rcu_unlock_preempted_task: OK
[    6.320141] Testing event rcu_preempt_task: OK
[    6.350156] Testing event rcu_nocb_wake: OK
[    6.380162] Testing event rcu_grace_period_init: OK
[    6.410154] Testing event rcu_future_grace_period: OK
[    6.440154] Testing event rcu_grace_period: OK
[    6.470160] Testing event rcu_utilization: OK
[    6.500399] Testing event tick_stop: OK
[    6.530163] Testing event itimer_expire: OK
[    6.560139] Testing event itimer_state: OK
[    6.590157] Testing event hrtimer_cancel: OK
[    6.620143] Testing event hrtimer_expire_exit: OK
[    6.650164] Testing event hrtimer_expire_entry: OK
[    6.680149] Testing event hrtimer_start: OK
[    6.710159] Testing event hrtimer_init: OK
[    6.740153] Testing event timer_cancel: OK
[    6.770157] Testing event timer_expire_exit: OK
[    6.800139] Testing event timer_expire_entry: OK
[    6.830172] Testing event timer_start: OK
[    6.860145] Testing event timer_init: OK
[    6.890162] Testing event ftrace_test_filter: OK
[    6.920144] Testing event dev_pm_qos_remove_request: OK
[    6.950157] Testing event dev_pm_qos_update_request: OK
[    6.980148] Testing event dev_pm_qos_add_request: OK
[    7.010175] Testing event pm_qos_update_flags: OK
[    7.040163] Testing event pm_qos_update_target: OK
[    7.070194] Testing event pm_qos_update_request_timeout: OK
[    7.100192] Testing event pm_qos_remove_request: OK
[    7.130183] Testing event pm_qos_update_request: OK
[    7.160157] Testing event pm_qos_add_request: OK
[    7.190164] Testing event power_domain_target: OK
[    7.220144] Testing event clock_set_rate: OK
[    7.250159] Testing event clock_disable: OK
[    7.280148] Testing event clock_enable: OK
[    7.310159] Testing event wakeup_source_deactivate: OK
[    7.340149] Testing event wakeup_source_activate: OK
[    7.370173] Testing event suspend_resume: OK
[    7.400143] Testing event device_pm_callback_end: OK
[    7.430173] Testing event device_pm_callback_start: OK
[    7.460144] Testing event cpu_frequency: OK
[    7.490163] Testing event pstate_sample: OK
[    7.520165] Testing event cpu_idle: OK
[    7.550174] Testing event mm_filemap_add_to_page_cache: OK
[    7.580173] Testing event mm_filemap_delete_from_page_cache: OK
[    7.610181] Testing event oom_score_adj_update: OK
[    7.640165] Testing event mm_lru_activate: OK
[    7.670162] Testing event mm_lru_insertion: OK
[    7.700146] Testing event mm_vmscan_lru_shrink_inactive: OK
[    7.730166] Testing event mm_vmscan_writepage: OK
[    7.760148] Testing event mm_vmscan_memcg_isolate: OK
[    7.790167] Testing event mm_vmscan_lru_isolate: OK
[    7.820152] Testing event mm_shrink_slab_end: OK
[    7.850159] Testing event mm_shrink_slab_start: OK
[    7.880224] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    7.910164] Testing event mm_vmscan_memcg_reclaim_end: OK
[    7.940397] Testing event mm_vmscan_direct_reclaim_end: OK
[    7.970191] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    8.000156] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    8.030171] Testing event mm_vmscan_direct_reclaim_begin: OK
[    8.060153] Testing event mm_vmscan_wakeup_kswapd: OK
[    8.090170] Testing event mm_vmscan_kswapd_wake: OK
[    8.120180] Testing event mm_vmscan_kswapd_sleep: OK
[    8.150181] Testing event mm_page_alloc_extfrag: OK
[    8.180150] Testing event mm_page_pcpu_drain: OK
[    8.210183] Testing event mm_page_alloc_zone_locked: OK
[    8.240174] Testing event mm_page_alloc: OK
[    8.270177] Testing event mm_page_free_batched: OK
[    8.300162] Testing event mm_page_free: OK
[    8.330188] Testing event kmem_cache_free: OK
[    8.360158] Testing event kfree: OK
[    8.390180] Testing event kmem_cache_alloc_node: OK
[    8.420155] Testing event kmalloc_node: OK
[    8.450159] Testing event kmem_cache_alloc: OK
[    8.480155] Testing event kmalloc: OK
[    8.510160] Testing event mm_numa_migrate_ratelimit: OK
[    8.540147] Testing event mm_migrate_pages: OK
[    8.570168] Testing event writeback_single_inode: OK
[    8.600141] Testing event writeback_single_inode_start: OK
[    8.630159] Testing event writeback_wait_iff_congested: OK
[    8.660142] Testing event writeback_congestion_wait: OK
[    8.690152] Testing event writeback_sb_inodes_requeue: OK
[    8.720146] Testing event balance_dirty_pages: OK
[    8.750174] Testing event bdi_dirty_ratelimit: OK
[    8.780159] Testing event global_dirty_state: OK
[    8.810164] Testing event writeback_queue_io: OK
[    8.840153] Testing event wbc_writepage: OK
[    8.870169] Testing event writeback_bdi_unregister: OK
[    8.900142] Testing event writeback_bdi_register: OK
[    8.930159] Testing event writeback_wake_background: OK
[    8.960140] Testing event writeback_nowork: OK
[    8.990156] Testing event writeback_pages_written: OK
[    9.020142] Testing event writeback_wait: OK
[    9.050182] Testing event writeback_written: OK
[    9.080253] Testing event writeback_start: OK
[    9.110176] Testing event writeback_exec: OK
[    9.140215] Testing event writeback_queue: OK
[    9.170170] Testing event writeback_write_inode: OK
[    9.200142] Testing event writeback_write_inode_start: OK
[    9.230181] Testing event writeback_dirty_inode: OK
[    9.260142] Testing event writeback_dirty_inode_start: OK
[    9.290157] Testing event writeback_dirty_page: OK
[    9.320152] Testing event swiotlb_bounced: OK
[    9.350169] Testing event gpio_value: OK
[    9.380461] Testing event gpio_direction: OK
[    9.410179] Testing event regulator_set_voltage_complete: OK
[    9.440155] Testing event regulator_set_voltage: OK
[    9.470272] Testing event regulator_disable_complete: OK
[    9.500194] Testing event regulator_disable: OK
[    9.530173] Testing event regulator_enable_complete: OK
[    9.560159] Testing event regulator_enable_delay: OK
[    9.590174] Testing event regulator_enable: OK
[    9.620167] Testing event urandom_read: OK
[    9.650163] Testing event random_read: OK
[    9.680153] Testing event extract_entropy_user: OK
[    9.710171] Testing event extract_entropy: OK
[    9.740152] Testing event get_random_bytes_arch: OK
[    9.770167] Testing event get_random_bytes: OK
[    9.800174] Testing event xfer_secondary_pool: OK
[    9.830185] Testing event add_disk_randomness: OK
[    9.860146] Testing event add_input_randomness: OK
[    9.890161] Testing event debit_entropy: OK
[    9.920145] Testing event push_to_pool: OK
[    9.950160] Testing event credit_entropy_bits: OK
[    9.980145] Testing event mix_pool_bytes_nolock: OK
[   10.010159] Testing event mix_pool_bytes: OK
[   10.040156] Testing event add_device_randomness: OK
[   10.070167] Testing event drm_vblank_event_delivered: OK
[   10.100139] Testing event drm_vblank_event_queued: OK
[   10.130160] Testing event drm_vblank_event: OK
[   10.160138] Testing event radeon_semaphore_wait: OK
[   10.190155] Testing event radeon_semaphore_signale: OK
[   10.220137] Testing event radeon_fence_wait_end: OK
[   10.250155] Testing event radeon_fence_wait_begin: OK
[   10.280139] Testing event radeon_fence_emit: OK
[   10.310154] Testing event radeon_vm_flush: OK
[   10.340151] Testing event radeon_vm_set_page: OK
[   10.370164] Testing event radeon_vm_bo_update: OK
[   10.400138] Testing event radeon_vm_grab_id: OK
[   10.430163] Testing event radeon_cs: OK
[   10.460141] Testing event radeon_bo_create: OK
[   10.490157] Testing event intel_gpu_freq_change: OK
[   10.520138] Testing event i915_reg_rw: OK
[   10.550354] Testing event i915_flip_complete: OK
[   10.580250] Testing event i915_flip_request: OK
[   10.610250] Testing event i915_ring_wait_end: OK
[   10.640212] Testing event i915_ring_wait_begin: OK
[   10.670223] Testing event i915_gem_request_wait_end: OK
[   10.700196] Testing event i915_gem_request_wait_begin: OK
[   10.730235] Testing event i915_gem_request_retire: OK
[   10.760192] Testing event i915_gem_request_complete: OK
[   10.790232] Testing event i915_gem_request_add: OK
[   10.820199] Testing event i915_gem_ring_flush: OK
[   10.850175] Testing event i915_gem_ring_dispatch: OK
[   10.880151] Testing event i915_gem_ring_sync_to: OK
[   10.910159] Testing event i915_gem_evict_vm: OK
[   10.940141] Testing event i915_gem_evict_everything: OK
[   10.970158] Testing event i915_gem_evict: OK
[   11.000142] Testing event i915_gem_object_destroy: OK
[   11.030161] Testing event i915_gem_object_clflush: OK
[   11.060145] Testing event i915_gem_object_fault: OK
[   11.090153] Testing event i915_gem_object_pread: OK
[   11.120504] Testing event i915_gem_object_pwrite: OK
[   11.150201] Testing event i915_gem_object_change_domain: OK
[   11.180156] Testing event i915_vma_unbind: OK
[   11.210157] Testing event i915_vma_bind: OK
[   11.240146] Testing event i915_gem_object_create: OK
[   11.270217] Testing event i915_pipe_update_end: OK
[   11.290158] Testing event i915_pipe_update_vblank_evaded: OK
[   11.310159] Testing event i915_pipe_update_start: OK
[   11.330174] Testing event regcache_drop_region: OK
[   11.350160] Testing event regmap_async_complete_done: OK
[   11.370159] Testing event regmap_async_complete_start: OK
[   11.390166] Testing event regmap_async_io_complete: OK
[   11.410164] Testing event regmap_async_write_start: OK
[   11.430165] Testing event regmap_cache_bypass: OK
[   11.450164] Testing event regmap_cache_only: OK
[   11.470167] Testing event regcache_sync: OK
[   11.490159] Testing event regmap_hw_write_done: OK
[   11.510167] Testing event regmap_hw_write_start: OK
[   11.530169] Testing event regmap_hw_read_done: OK
[   11.550160] Testing event regmap_hw_read_start: OK
[   11.570165] Testing event regmap_reg_read_cache: OK
[   11.590160] Testing event regmap_reg_read: OK
[   11.610167] Testing event regmap_reg_write: OK
[   11.630171] Testing event fence_wait_end: OK
[   11.650162] Testing event fence_wait_start: OK
[   11.670169] Testing event fence_signaled: OK
[   11.690164] Testing event fence_enable_signal: OK
[   11.710161] Testing event fence_destroy: OK
[   11.730168] Testing event fence_init: OK
[   11.750164] Testing event fence_emit: OK
[   11.770159] Testing event fence_annotate_wait_on: OK
[   11.790166] Testing event spi_transfer_stop: OK
[   11.810164] Testing event spi_transfer_start: OK
[   11.830171] Testing event spi_message_done: OK
[   11.850160] Testing event spi_message_start: OK
[   11.870164] Testing event spi_message_submit: OK
[   11.890159] Testing event spi_master_busy: OK
[   11.910171] Testing event spi_master_idle: OK
[   11.930169] Testing event smbus_result: OK
[   11.950163] Testing event smbus_reply: OK
[   11.970173] Testing event smbus_read: OK
[   11.990165] Testing event smbus_write: OK
[   12.010161] Testing event i2c_result: OK
[   12.030163] Testing event i2c_reply: OK
[   12.050174] Testing event i2c_read: OK
[   12.070167] Testing event i2c_write: OK
[   12.090173] Testing event v4l2_qbuf: OK
[   12.110159] Testing event v4l2_dqbuf: OK
[   12.130170] Testing event aer_event: OK
[   12.150161] Testing event mc_event: OK
[   12.170177] Testing event extlog_mem_event: OK
[   12.190163] Testing event udp_fail_queue_rcv_skb: OK
[   12.210172] Testing event sock_exceed_buf_limit: OK
[   12.230171] Testing event sock_rcvqueue_full: OK
[   12.250161] Testing event napi_poll: OK
[   12.270210] Testing event netif_rx_ni_entry: OK
[   12.290240] Testing event netif_rx_entry: OK
[   12.310224] Testing event netif_receive_skb_entry: OK
[   12.330195] Testing event napi_gro_receive_entry: OK
[   12.350244] Testing event napi_gro_frags_entry: OK
[   12.370174] Testing event netif_rx: OK
[   12.390211] Testing event netif_receive_skb: OK
[   12.410196] Testing event net_dev_queue: OK
[   12.430183] Testing event net_dev_xmit: OK
[   12.450192] Testing event net_dev_start_xmit: OK
[   12.470267] Testing event skb_copy_datagram_iovec: OK
[   12.490177] Testing event consume_skb: OK
[   12.510157] Testing event kfree_skb: OK
[   12.530283] Testing event 9p_protocol_dump: OK
[   12.550161] Testing event 9p_client_res: OK
[   12.570163] Testing event 9p_client_req: OK
[   12.590186] Running tests on trace event systems:
[   12.590642] Testing event system 9p: OK
[   12.610267] Testing event system skb: OK
[   12.630228] Testing event system net: OK
[   12.650206] Testing event system napi: OK
[   12.670186] Testing event system sock: OK
[   12.690274] Testing event system udp: OK
[   12.710286] Testing event system ras: OK
[   12.730214] Testing event system v4l2: OK
[   12.750203] Testing event system i2c: OK
[   12.770247] Testing event system spi: OK
[   12.790208] Testing event system fence: OK
[   12.810197] Testing event system regmap: OK
[   12.830233] Testing event system i915: OK
[   12.850488] Testing event system radeon: OK
[   12.870237] Testing event system drm: OK
[   12.890212] Testing event system random: OK
[   12.910284] Testing event system regulator: OK
[   12.930292] Testing event system gpio: OK
[   12.950208] Testing event system swiotlb: OK
[   12.970223] Testing event system writeback: OK
[   12.990247] Testing event system migrate: OK
[   13.010256] Testing event system kmem: OK
[   13.030246] Testing event system vmscan: OK
[   13.050237] Testing event system pagemap: OK
[   13.070233] Testing event system oom: OK
[   13.090225] Testing event system filemap: OK
[   13.110204] Testing event system power: OK
[   13.130266] Testing event system test: OK
[   13.150224] Testing event system timer: OK
[   13.170213] Testing event system rcu: OK
[   13.190273] Testing event system printk: OK
[   13.210241] Testing event system lock: OK
[   13.230295] Testing event system sched: OK
[   13.250272] Testing event system workqueue: OK
[   13.270221] Testing event system signal: OK
[   13.290235] Testing event system irq: OK
[   13.310222] Testing event system task: OK
[   13.330238] Testing event system exceptions: OK
[   13.350241] Testing event system tlb: OK
[   13.370211] Testing event system mce: OK
[   13.390234] Testing event system raw_syscalls: OK
[   13.410233] Testing event system vsyscall: OK
[   13.430248] Testing event system syscalls: OK
[   13.450813] Testing event system nmi: OK
[   13.470213] Testing event system irq_vectors: OK
[   13.490322] Running tests on all trace events:
[   13.490746] Testing all events: OK
[   13.511584] Running tests again, along with the function tracer
[   13.512189] Running tests on trace events:
[   13.512613] Testing event thermal_apic_exit: OK
[   13.531059] Testing event thermal_apic_entry: OK
[   13.550423] Testing event threshold_apic_exit: OK
[   13.570401] Testing event threshold_apic_entry: OK
[   13.590390] Testing event call_function_single_exit: OK
[   13.610415] Testing event call_function_single_entry: OK
[   13.630418] Testing event call_function_exit: OK
[   13.650407] Testing event call_function_entry: OK
[   13.670406] Testing event irq_work_exit: OK
[   13.690385] Testing event irq_work_entry: OK
[   13.710366] Testing event x86_platform_ipi_exit: OK
[   13.730444] Testing event x86_platform_ipi_entry: OK
[   13.750366] Testing event error_apic_exit: OK
[   13.770373] Testing event error_apic_entry: OK
[   13.790397] Testing event spurious_apic_exit: OK
[   13.810382] Testing event spurious_apic_entry: OK
[   13.830439] Testing event reschedule_exit: OK
[   13.850706] Testing event reschedule_entry: OK
[   13.870387] Testing event local_timer_exit: OK
[   13.890394] Testing event local_timer_entry: OK
[   13.910439] Testing event nmi_handler: OK
[   13.930445] Testing event emulate_vsyscall: OK
[   13.950382] Testing event sys_exit: OK
[   13.970456] Testing event sys_enter: OK
[   13.990479] Testing event mce_record: OK
[   14.010388] Testing event tlb_flush: OK
[   14.030457] Testing event page_fault_kernel: OK
[   14.050383] Testing event page_fault_user: OK
[   14.070452] Testing event task_rename: OK
[   14.090384] Testing event task_newtask: OK
[   14.110388] Testing event softirq_raise: OK
[   14.130353] Testing event softirq_exit: OK
[   14.150412] Testing event softirq_entry: OK
[   14.170387] Testing event irq_handler_exit: OK
[   14.190353] Testing event irq_handler_entry: OK
[   14.210421] Testing event signal_deliver: OK
[   14.230419] Testing event signal_generate: OK
[   14.250396] Testing event workqueue_execute_end: OK
[   14.270583] Testing event workqueue_execute_start: OK
[   14.290389] Testing event workqueue_activate_work: OK
[   14.310410] Testing event workqueue_queue_work: OK
[   14.330419] Testing event sched_wake_idle_without_ipi: OK
[   14.350340] Testing event sched_swap_numa: OK
[   14.370388] Testing event sched_stick_numa: OK
[   14.390369] Testing event sched_move_numa: OK
[   14.410379] Testing event sched_pi_setprio: OK
[   14.430434] Testing event sched_stat_runtime: OK
[   14.450420] Testing event sched_stat_blocked: OK
[   14.470418] Testing event sched_stat_iowait: OK
[   14.490410] Testing event sched_stat_sleep: OK
[   14.510468] Testing event sched_stat_wait: OK
[   14.530412] Testing event sched_process_exec: OK
[   14.550341] Testing event sched_process_fork: OK
[   14.570422] Testing event sched_process_wait: OK
[   14.590522] Testing event sched_wait_task: OK
[   14.610380] Testing event sched_process_exit: OK
[   14.630421] Testing event sched_process_free: OK
[   14.650390] Testing event sched_migrate_task: OK
[   14.670406] Testing event sched_switch: OK
[   14.690607] Testing event sched_wakeup_new: OK
[   14.710419] Testing event sched_wakeup: OK
[   14.730412] Testing event sched_kthread_stop_ret: OK
[   14.750345] Testing event sched_kthread_stop: OK
[   14.770333] Testing event lock_release: OK
[   14.790435] Testing event lock_acquire: OK
[   14.810413] Testing event console: OK
[   14.830407] Testing event rcu_barrier: OK
[   14.850372] Testing event rcu_torture_read: OK
[   14.870639] Testing event rcu_batch_end: OK
[   14.890380] Testing event rcu_invoke_kfree_callback: OK
[   14.910393] Testing event rcu_invoke_callback: OK
[   14.930434] Testing event rcu_batch_start: OK
[   14.950387] Testing event rcu_kfree_callback: OK
[   14.970387] Testing event rcu_callback: OK
[   14.990411] Testing event rcu_prep_idle: OK
[   15.010391] Testing event rcu_dyntick: OK
[   15.030423] Testing event rcu_fqs: OK
[   15.050443] Testing event rcu_quiescent_state_report: OK
[   15.070418] Testing event rcu_unlock_preempted_task: OK
[   15.090397] Testing event rcu_preempt_task: OK
[   15.110435] Testing event rcu_nocb_wake: OK
[   15.130390] Testing event rcu_grace_period_init: OK
[   15.150397] Testing event rcu_future_grace_period: OK
[   15.170433] Testing event rcu_grace_period: OK
[   15.190405] Testing event rcu_utilization: OK
[   15.210409] Testing event tick_stop: OK
[   15.230447] Testing event itimer_expire: OK
[   15.250407] Testing event itimer_state: OK
[   15.270388] Testing event hrtimer_cancel: OK
[   15.290398] Testing event hrtimer_expire_exit: OK
[   15.310387] Testing event hrtimer_expire_entry: OK
[   15.330441] Testing event hrtimer_start: OK
[   15.350421] Testing event hrtimer_init: OK
[   15.370380] Testing event timer_cancel: OK
[   15.390395] Testing event timer_expire_exit: OK
[   15.410408] Testing event timer_expire_entry: OK
[   15.430441] Testing event timer_start: OK
[   15.450387] Testing event timer_init: OK
[   15.470411] Testing event ftrace_test_filter: OK
[   15.490384] Testing event dev_pm_qos_remove_request: OK
[   15.510407] Testing event dev_pm_qos_update_request: OK
[   15.530444] Testing event dev_pm_qos_add_request: OK
[   15.550414] Testing event pm_qos_update_flags: OK
[   15.570402] Testing event pm_qos_update_target: OK
[   15.590368] Testing event pm_qos_update_request_timeout: OK
[   15.610416] Testing event pm_qos_remove_request: OK
[   15.630432] Testing event pm_qos_update_request: OK
[   15.650423] Testing event pm_qos_add_request: OK
[   15.670393] Testing event power_domain_target: OK
[   15.690409] Testing event clock_set_rate: OK
[   15.710365] Testing event clock_disable: OK
[   15.730360] Testing event clock_enable: OK
[   15.750353] Testing event wakeup_source_deactivate: OK
[   15.770359] Testing event wakeup_source_activate: OK
[   15.790384] Testing event suspend_resume: OK
[   15.810343] Testing event device_pm_callback_end: OK
[   15.830409] Testing event device_pm_callback_start: OK
[   15.850423] Testing event cpu_frequency: OK
[   15.870411] Testing event pstate_sample: OK
[   15.890453] Testing event cpu_idle: OK
[   15.910412] Testing event mm_filemap_add_to_page_cache: OK
[   15.930416] Testing event mm_filemap_delete_from_page_cache: OK
[   15.950369] Testing event oom_score_adj_update: OK
[   15.970386] Testing event mm_lru_activate: OK
[   15.990382] Testing event mm_lru_insertion: OK
[   16.010360] Testing event mm_vmscan_lru_shrink_inactive: OK
[   16.030434] Testing event mm_vmscan_writepage: OK
[   16.050365] Testing event mm_vmscan_memcg_isolate: OK
[   16.070516] Testing event mm_vmscan_lru_isolate: OK
[   16.090682] Testing event mm_shrink_slab_end: OK
[   16.110405] Testing event mm_shrink_slab_start: OK
[   16.130433] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   16.150410] Testing event mm_vmscan_memcg_reclaim_end: OK
[   16.170352] Testing event mm_vmscan_direct_reclaim_end: OK
[   16.190371] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   16.210354] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   16.230371] Testing event mm_vmscan_direct_reclaim_begin: OK
[   16.250342] Testing event mm_vmscan_wakeup_kswapd: OK
[   16.270341] Testing event mm_vmscan_kswapd_wake: OK
[   16.290345] Testing event mm_vmscan_kswapd_sleep: OK
[   16.310348] Testing event mm_page_alloc_extfrag: OK
[   16.330397] Testing event mm_page_pcpu_drain: OK
[   16.350328] Testing event mm_page_alloc_zone_locked: OK
[   16.370353] Testing event mm_page_alloc: OK
[   16.390327] Testing event mm_page_free_batched: OK
[   16.410347] Testing event mm_page_free: OK
[   16.430384] Testing event kmem_cache_free: OK
[   16.450329] Testing event kfree: OK
[   16.470336] Testing event kmem_cache_alloc_node: OK
[   16.490370] Testing event kmalloc_node: OK
[   16.510340] Testing event kmem_cache_alloc: OK
[   16.530370] Testing event kmalloc: OK
[   16.550354] Testing event mm_numa_migrate_ratelimit: OK
[   16.570358] Testing event mm_migrate_pages: OK
[   16.590360] Testing event writeback_single_inode: OK
[   16.610388] Testing event writeback_single_inode_start: OK
[   16.630372] Testing event writeback_wait_iff_congested: OK
[   16.650346] Testing event writeback_congestion_wait: OK
[   16.670390] Testing event writeback_sb_inodes_requeue: OK
[   16.690342] Testing event balance_dirty_pages: OK
[   16.710341] Testing event bdi_dirty_ratelimit: OK
[   16.730372] Testing event global_dirty_state: OK
[   16.750345] Testing event writeback_queue_io: OK
[   16.770362] Testing event wbc_writepage: OK
[   16.790379] Testing event writeback_bdi_unregister: OK
[   16.810347] Testing event writeback_bdi_register: OK
[   16.830384] Testing event writeback_wake_background: OK
[   16.850409] Testing event writeback_nowork: OK
[   16.870347] Testing event writeback_pages_written: OK
[   16.890348] Testing event writeback_wait: OK
[   16.910358] Testing event writeback_written: OK
[   16.930390] Testing event writeback_start: OK
[   16.950348] Testing event writeback_exec: OK
[   16.970401] Testing event writeback_queue: OK
[   16.990336] Testing event writeback_write_inode: OK
[   17.010346] Testing event writeback_write_inode_start: OK
[   17.030398] Testing event writeback_dirty_inode: OK
[   17.050368] Testing event writeback_dirty_inode_start: OK
[   17.070477] Testing event writeback_dirty_page: OK
[   17.090392] Testing event swiotlb_bounced: OK
[   17.110359] Testing event gpio_value: OK
[   17.130445] Testing event gpio_direction: OK
[   17.150365] Testing event regulator_set_voltage_complete: OK
[   17.170355] Testing event regulator_set_voltage: OK
[   17.190346] Testing event regulator_disable_complete: OK
[   17.210385] Testing event regulator_disable: OK
[   17.230384] Testing event regulator_enable_complete: OK
[   17.250341] Testing event regulator_enable_delay: OK
[   17.270370] Testing event regulator_enable: OK
[   17.290615] Testing event urandom_read: OK
[   17.310356] Testing event random_read: OK
[   17.330421] Testing event extract_entropy_user: OK
[   17.350344] Testing event extract_entropy: OK
[   17.370340] Testing event get_random_bytes_arch: OK
[   17.390388] Testing event get_random_bytes: OK
[   17.410347] Testing event xfer_secondary_pool: OK
[   17.430362] Testing event add_disk_randomness: OK
[   17.450390] Testing event add_input_randomness: OK
[   17.470345] Testing event debit_entropy: OK
[   17.490343] Testing event push_to_pool: OK
[   17.510387] Testing event credit_entropy_bits: OK
[   17.530390] Testing event mix_pool_bytes_nolock: OK
[   17.550360] Testing event mix_pool_bytes: OK
[   17.570357] Testing event add_device_randomness: OK
[   17.590359] Testing event drm_vblank_event_delivered: OK
[   17.610357] Testing event drm_vblank_event_queued: OK
[   17.630384] Testing event drm_vblank_event: OK
[   17.650347] Testing event radeon_semaphore_wait: OK
[   17.670353] Testing event radeon_semaphore_signale: OK
[   17.690366] Testing event radeon_fence_wait_end: OK
[   17.710364] Testing event radeon_fence_wait_begin: OK
[   17.730349] Testing event radeon_fence_emit: OK
[   17.750365] Testing event radeon_vm_flush: OK
[   17.770351] Testing event radeon_vm_set_page: OK
[   17.790357] Testing event radeon_vm_bo_update: OK
[   17.810363] Testing event radeon_vm_grab_id: OK
[   17.830370] Testing event radeon_cs: OK
[   17.850345] Testing event radeon_bo_create: OK
[   17.870358] Testing event intel_gpu_freq_change: OK
[   17.890348] Testing event i915_reg_rw: OK
[   17.910350] Testing event i915_flip_complete: OK
[   17.930385] Testing event i915_flip_request: OK
[   17.950346] Testing event i915_ring_wait_end: OK
[   17.970347] Testing event i915_ring_wait_begin: OK
[   17.990372] Testing event i915_gem_request_wait_end: OK
[   18.010343] Testing event i915_gem_request_wait_begin: OK
[   18.030356] Testing event i915_gem_request_retire: OK
[   18.050410] Testing event i915_gem_request_complete: OK
[   18.070440] Testing event i915_gem_request_add: OK
[   18.090341] Testing event i915_gem_ring_flush: OK
[   18.110366] Testing event i915_gem_ring_dispatch: OK
[   18.130398] Testing event i915_gem_ring_sync_to: OK
[   18.150374] Testing event i915_gem_evict_vm: OK
[   18.170371] Testing event i915_gem_evict_everything: OK
[   18.190355] Testing event i915_gem_evict: OK
[   18.210356] Testing event i915_gem_object_destroy: OK
[   18.230400] Testing event i915_gem_object_clflush: OK
[   18.250415] Testing event i915_gem_object_fault: OK
[   18.270364] Testing event i915_gem_object_pread: OK
[   18.290369] Testing event i915_gem_object_pwrite: OK
[   18.310364] Testing event i915_gem_object_change_domain: OK
[   18.330375] Testing event i915_vma_unbind: OK
[   18.350370] Testing event i915_vma_bind: OK
[   18.370338] Testing event i915_gem_object_create: OK
[   18.390340] Testing event i915_pipe_update_end: OK
[   18.410360] Testing event i915_pipe_update_vblank_evaded: OK
[   18.430358] Testing event i915_pipe_update_start: OK
[   18.450356] Testing event regcache_drop_region: OK
[   18.470383] Testing event regmap_async_complete_done: OK
[   18.490361] Testing event regmap_async_complete_start: OK
[   18.510336] Testing event regmap_async_io_complete: OK
[   18.530386] Testing event regmap_async_write_start: OK
[   18.550337] Testing event regmap_cache_bypass: OK
[   18.570338] Testing event regmap_cache_only: OK
[   18.590367] Testing event regcache_sync: OK
[   18.610344] Testing event regmap_hw_write_done: OK
[   18.630364] Testing event regmap_hw_write_start: OK
[   18.650343] Testing event regmap_hw_read_done: OK
[   18.670342] Testing event regmap_hw_read_start: OK
[   18.690326] Testing event regmap_reg_read_cache: OK
[   18.710350] Testing event regmap_reg_read: OK
[   18.730663] Testing event regmap_reg_write: OK
[   18.750334] Testing event fence_wait_end: OK
[   18.770367] Testing event fence_wait_start: OK
[   18.790357] Testing event fence_signaled: OK
[   18.810327] Testing event fence_enable_signal: OK
[   18.830389] Testing event fence_destroy: OK
[   18.850350] Testing event fence_init: OK
[   18.870330] Testing event fence_emit: OK
[   18.890376] Testing event fence_annotate_wait_on: OK
[   18.910348] Testing event spi_transfer_stop: OK
[   18.930382] Testing event spi_transfer_start: OK
[   18.950373] Testing event spi_message_done: OK
[   18.970348] Testing event spi_message_start: OK
[   18.990339] Testing event spi_message_submit: OK
[   19.010365] Testing event spi_master_busy: OK
[   19.030350] Testing event spi_master_idle: OK
[   19.050369] Testing event smbus_result: OK
[   19.070433] Testing event smbus_reply: OK
[   19.090323] Testing event smbus_read: OK
[   19.110336] Testing event smbus_write: OK
[   19.130394] Testing event i2c_result: OK
[   19.150349] Testing event i2c_reply: OK
[   19.170374] Testing event i2c_read: OK
[   19.190361] Testing event i2c_write: OK
[   19.210348] Testing event v4l2_qbuf: OK
[   19.230348] Testing event v4l2_dqbuf: OK
[   19.250351] Testing event aer_event: OK
[   19.270337] Testing event mc_event: OK
[   19.290343] Testing event extlog_mem_event: OK
[   19.310357] Testing event udp_fail_queue_rcv_skb: OK
[   19.330371] Testing event sock_exceed_buf_limit: OK
[   19.350339] Testing event sock_rcvqueue_full: OK
[   19.370385] Testing event napi_poll: OK
[   19.390335] Testing event netif_rx_ni_entry: OK
[   19.410352] Testing event netif_rx_entry: OK
[   19.430381] Testing event netif_receive_skb_entry: OK
[   19.450345] Testing event napi_gro_receive_entry: OK
[   19.470340] Testing event napi_gro_frags_entry: OK
[   19.490378] Testing event netif_rx: OK
[   19.510347] Testing event netif_receive_skb: OK
[   19.530341] Testing event net_dev_queue: OK
[   19.550346] Testing event net_dev_xmit: OK
[   19.570337] Testing event net_dev_start_xmit: OK
[   19.590332] Testing event skb_copy_datagram_iovec: OK
[   19.610381] Testing event consume_skb: OK
[   19.630353] Testing event kfree_skb: OK
[   19.650342] Testing event 9p_protocol_dump: OK
[   19.670384] Testing event 9p_client_res: OK
[   19.690332] Testing event 9p_client_req: OK
[   19.710346] Running tests on trace event systems:
[   19.710903] Testing event system 9p: OK
[   19.730417] Testing event system skb: OK
[   19.750355] Testing event system net: OK
[   19.770425] Testing event system napi: OK
[   19.790407] Testing event system sock: OK
[   19.810365] Testing event system udp: OK
[   19.830411] Testing event system ras: OK
[   19.850414] Testing event system v4l2: OK
[   19.870373] Testing event system i2c: OK
[   19.890392] Testing event system spi: OK
[   19.910403] Testing event system fence: OK
[   19.930414] Testing event system regmap: OK
[   19.950416] Testing event system i915: OK
[   19.970497] Testing event system radeon: OK
[   19.990402] Testing event system drm: OK
[   20.010351] Testing event system random: OK
[   20.030453] Testing event system regulator: OK
[   20.050386] Testing event system gpio: OK
[   20.070407] Testing event system swiotlb: OK
[   20.090389] Testing event system writeback: OK
[   20.110433] Testing event system migrate: OK
[   20.130398] Testing event system kmem: OK
[   20.150439] Testing event system vmscan: OK
[   20.170666] Testing event system pagemap: OK
[   20.190368] Testing event system oom: OK
[   20.210390] Testing event system filemap: OK
[   20.230396] Testing event system power: OK
[   20.250445] Testing event system test: OK
[   20.270385] Testing event system timer: OK
[   20.290413] Testing event system rcu: OK
[   20.310442] Testing event system printk: OK
[   20.330415] Testing event system lock: OK
[   20.350401] Testing event system sched: OK
[   20.370454] Testing event system workqueue: OK
[   20.390386] Testing event system signal: OK
[   20.410369] Testing event system irq: OK
[   20.430405] Testing event system task: OK
[   20.450394] Testing event system exceptions: OK
[   20.470404] Testing event system tlb: OK
[   20.490353] Testing event system mce: OK
[   20.510387] Testing event system raw_syscalls: OK
[   20.530395] Testing event system vsyscall: OK
[   20.550392] Testing event system syscalls: OK
[   20.571896] Testing event system nmi: OK
[   20.590520] Testing event system irq_vectors: OK
[   20.610446] Running tests on all trace events:
[   20.610950] Testing all events: OK
[   20.633480] Testing ftrace filter: OK
[   20.635945]   Magic number: 14:718:931
[   20.636624] console [netcon0] enabled
[   20.636968] netconsole: network logging started
[   20.637551] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   20.638104] EDD information not available.
[   20.647397] Freeing unused kernel memory: 1120K (ffffffff83648000 - ffff=
ffff83760000)
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
Starting udev
/etc/rcS.d/S03udev: line 72: can't create /proc/sys/kernel/hotplug: nonexis=
tent directory
[   21.415915] (stc): gdata/new_proto/recv or reg_complete_cb not ready
[   21.416510] fmdrv: Failed to get ST write func pointer
[   21.417003] (stc):  chnl_id 8 not supported
[   21.417371] fmdrv: st_unregister failed -93
[   21.417779] fmdrv: Unable to prepare FM CORE
[   21.430504] S03udev (872) used greatest stack depth: 13280 bytes left
Kernel tests: Boot OK!
[   60.891095] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
Sending all processes the KILL signal...
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
Rebooting...=20
[   89.920234] Unregister pv shared memory for cpu 0
[   89.921022] spin_lock-torture: Unscheduled system shutdown detected
[   89.921559] no ifx modem active;
[   89.923023] reboot: Restarting system
[   89.923343] reboot: machine restart
Elapsed time: 95
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s1-09100924/87354059881ce9315181604dc17076c535f4d744/vmlinuz-3.17.0-rc4-00=
002-g8735405 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pani=
c=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s=
1-09100924/linux-devel:devel-hourly-2014091007:87354059881ce9315181604dc170=
76c535f4d744:bisect-linux-9/.vmlinuz-87354059881ce9315181604dc17076c535f4d7=
44-20140910105611-2-ivb41 branch=3Dlinux-devel/devel-hourly-2014091007 BOOT=
_IMAGE=3D/kernel/x86_64-randconfig-s1-09100924/87354059881ce9315181604dc170=
76c535f4d744/vmlinuz-3.17.0-rc4-00002-g8735405 drbd.minor_count=3D8'  -init=
rd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 -net nic,vla=
n=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdo=
g i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-ivb41-70=
 -serial file:/dev/shm/kboot/serial-yocto-ivb41-70 -daemonize -display none=
 -monitor null=20

--rwEMma7ioTxnRzrJ
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-s1-09100924-a228a329e35a8738fd65282d38d6fb5bd01fc612-WARNING:---at----register_tracer+-x-80387.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgYTIyOGEzMi4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA5MTAwNycKZ2l0IGNoZWNrb3V0IDJjZTc1OThjOWE0NTNlMGFjZDBlMDdi
ZTdiZTNmNWViMzk2MDhlYmQKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDkxMDA3OjJjZTc1OThjOWE0NTNlMGFjZDBlMDdiZTdiZTNmNWViMzk2MDhlYmQ6Ymlz
ZWN0LWxpbnV4LTkKCjIwMTQtMDktMTAgMDk6NDI6NDAgMmNlNzU5OGM5YTQ1M2UwYWNkMGUw
N2JlN2JlM2Y1ZWIzOTYwOGViZCByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MTAwOTI0LzJjZTc1OThjOWE0NTNlMGFjZDBlMDdiZTdiZTNmNWViMzk2MDhlYmQvdm1s
aW51ei0zLjE3LjAtcmM0CgoyMDE0LTA5LTEwIDA5OjQyOjQwIGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4JNgkxNiBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDJjZTc1OThjOWE0
NTNlMGFjZDBlMDdiZTdiZTNmNWViMzk2MDhlYmQKZ2l0IGJpc2VjdCBzdGFydCBhMjI4YTMy
OWUzNWE4NzM4ZmQ2NTI4MmQzOGQ2ZmI1YmQwMWZjNjEyIDJjZTc1OThjOWE0NTNlMGFjZDBl
MDdiZTdiZTNmNWViMzk2MDhlYmQgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6
IFsiLWIiLCAiYTIyOGEzMjllMzVhODczOGZkNjUyODJkMzhkNmZiNWJkMDFmYzYxMiIsICIt
ZyIsICIyY2U3NTk4YzlhNDUzZTBhY2QwZTA3YmU3YmUzZjVlYjM5NjA4ZWJkIiwgIi9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1iaXNl
Y3QvbGludXgtOS9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAxNTMyIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKW2JiMDNjZGRjMTkwODVi
OGUyMGJiYzU3OGY0NWNiOGQ5NjRhNmU4NThdIE1lcmdlICduZnMvbGludXgtbmV4dCcgaW50
byBkZXZlbC1ob3VybHktMjAxNDA5MTAwNwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtOS9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wOTEwMDkyNC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA5MTAwNzpiYjAz
Y2RkYzE5MDg1YjhlMjBiYmM1NzhmNDVjYjhkOTY0YTZlODU4OmJpc2VjdC1saW51eC05Cgoy
MDE0LTA5LTEwIDA5OjQ1OjQxIGJiMDNjZGRjMTkwODViOGUyMGJiYzU3OGY0NWNiOGQ5NjRh
NmU4NTggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0LWJiMDNjZGRjMTkw
ODViOGUyMGJiYzU3OGY0NWNiOGQ5NjRhNmU4NTgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0L2JiMDNjZGRjMTkwODViOGUyMGJi
YzU3OGY0NWNiOGQ5NjRhNmU4NTgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC1i
YjAzY2RkYzE5MDg1YjhlMjBiYmM1NzhmNDVjYjhkOTY0YTZlODU4ChtbMTszNW0yMDE0LTA5
LTEwIDA5OjQ5OjQyIE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQt
c2VydmVkL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0LWJiMDNjZGRjMTkwODViOGUy
MGJiYzU3OGY0NWNiOGQ5NjRhNmU4NTgbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmItc21va2UveDg2
XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQtYmIwM2NkZGMxOTA4NWI4ZTIwYmJjNTc4ZjQ1
Y2I4ZDk2NGE2ZTg1OAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkx
MDA5MjQvYmIwM2NkZGMxOTA4NWI4ZTIwYmJjNTc4ZjQ1Y2I4ZDk2NGE2ZTg1OC92bWxpbnV6
LTMuMTcuMC1yYzQtMDA3MDYtZ2JiMDNjZGQKCjIwMTQtMDktMTAgMDk6NTI6NDIgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4gVEVTVCBGQUlMVVJFCkZBSUxFRCEKWyAgICAwLjQ0
MTAwN10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC40NDEw
MDddIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuNDQyNDE3
XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGtlcm5lbC90cmFjZS90cmFjZS5jOjExMjcg
cmVnaXN0ZXJfdHJhY2VyKzB4MWU1LzB4MzA5KCkKWyAgICAwLjQ0MjQxN10gV0FSTklORzog
Q1BVOiAwIFBJRDogMSBhdCBrZXJuZWwvdHJhY2UvdHJhY2UuYzoxMTI3IHJlZ2lzdGVyX3Ry
YWNlcisweDFlNS8weDMwOSgpClsgICAgMC40NDUzODldIENQVTogMCBQSUQ6IDEgQ29tbTog
c3dhcHBlciBOb3QgdGFpbnRlZCAzLjE3LjAtcmM0LTAwNzA2LWdiYjAzY2RkICMxClsgICAg
MC40NDUzODldIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE3
LjAtcmM0LTAwNzA2LWdiYjAzY2RkICMxClsgICAgMC40NDg0OTNdICAwMDAwMDAwMDAwMDAw
MDAwClsgICAgMC40NDg0OTNdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMTI4NGZlMTgg
ZmZmZjg4MDAxMjg0ZmUxOCBmZmZmZmZmZjgyMjM4YzZhIGZmZmZmZmZmODIyMzhjNmEgZmZm
Zjg4MDAxMjg0ZmU1MCBmZmZmODgwMDEyODRmZTUwCgpbICAgIDAuNDUwNjYzXSAgZmZmZmZm
ZmY4MTBjYTM5NgpbICAgIDAuNDUwNjYzXSAgZmZmZmZmZmY4MTBjYTM5NiBmZmZmZmZmZjgx
MTczMDczIGZmZmZmZmZmODExNzMwNzMgZmZmZmZmZmY4MzU1ODY4MCBmZmZmZmZmZjgzNTU4
NjgwIGZmZmZmZmZmODM2MzA4YzAgZmZmZmZmZmY4MzYzMDhjMAoKWyAgICAwLjQ1MzMzMV0g
IGZmZmZmZmZmODJiYmZlOGQKWyAgICAwLjQ1MzMzMV0gIGZmZmZmZmZmODJiYmZlOGQgZmZm
ZmZmZmY4MzcxMDkxMCBmZmZmZmZmZjgzNzEwOTEwIGZmZmY4ODAwMTI4NGZlNjAgZmZmZjg4
MDAxMjg0ZmU2MCBmZmZmZmZmZjgxMGNhNGVhIGZmZmZmZmZmODEwY2E0ZWEKClsgICAgMC40
NTc3MDFdIENhbGwgVHJhY2U6ClsgICAgMC40NTc3MDFdIENhbGwgVHJhY2U6ClsgICAgMC40
NjAwMzhdICBbPGZmZmZmZmZmODIyMzhjNmE+XSBkdW1wX3N0YWNrKzB4MmUvMHgzZQpbICAg
IDAuNDYwMDM4XSAgWzxmZmZmZmZmZjgyMjM4YzZhPl0gZHVtcF9zdGFjaysweDJlLzB4M2UK
WyAgICAwLjQ2NTg2M10gIFs8ZmZmZmZmZmY4MTBjYTM5Nj5dIHdhcm5fc2xvd3BhdGhfY29t
bW9uKzB4OWQvMHhjYgpbICAgIDAuNDY1ODYzXSAgWzxmZmZmZmZmZjgxMGNhMzk2Pl0gd2Fy
bl9zbG93cGF0aF9jb21tb24rMHg5ZC8weGNiClsgICAgMC40NzAwMzVdICBbPGZmZmZmZmZm
ODExNzMwNzM+XSA/IHJlZ2lzdGVyX3RyYWNlcisweDFlNS8weDMwOQpbICAgIDAuNDcwMDM1
XSAgWzxmZmZmZmZmZjgxMTczMDczPl0gPyByZWdpc3Rlcl90cmFjZXIrMHgxZTUvMHgzMDkK
WyAgICAwLjQ3MzExOV0gIFs8ZmZmZmZmZmY4MTBjYTRlYT5dIHdhcm5fc2xvd3BhdGhfbnVs
bCsweDI4LzB4MzEKWyAgICAwLjQ3MzExOV0gIFs8ZmZmZmZmZmY4MTBjYTRlYT5dIHdhcm5f
c2xvd3BhdGhfbnVsbCsweDI4LzB4MzEKWyAgICAwLjQ3ODEwMl0gIFs8ZmZmZmZmZmY4MTE3
MzA3Mz5dIHJlZ2lzdGVyX3RyYWNlcisweDFlNS8weDMwOQpbICAgIDAuNDc4MTAyXSAgWzxm
ZmZmZmZmZjgxMTczMDczPl0gcmVnaXN0ZXJfdHJhY2VyKzB4MWU1LzB4MzA5ClsgICAgMC40
ODAwMzJdICBbPGZmZmZmZmZmODM2NjgxZmQ+XSA/IGluaXRfZ3JhcGhfZGVidWdmcysweDRi
LzB4NGIKWyAgICAwLjQ4MDAzMl0gIFs8ZmZmZmZmZmY4MzY2ODFmZD5dID8gaW5pdF9ncmFw
aF9kZWJ1Z2ZzKzB4NGIvMHg0YgpbICAgIDAuNDgzODcxXSAgWzxmZmZmZmZmZjgzNjY4Mjk5
Pl0gaW5pdF9ncmFwaF90cmFjZSsweDljLzB4YTUKWyAgICAwLjQ4Mzg3MV0gIFs8ZmZmZmZm
ZmY4MzY2ODI5OT5dIGluaXRfZ3JhcGhfdHJhY2UrMHg5Yy8weGE1ClsgICAgMC40ODY5NTJd
ICBbPGZmZmZmZmZmODM2NDA4ZWU+XSBkb19vbmVfaW5pdGNhbGwrMHgxODEvMHgyYjQKWyAg
ICAwLjQ4Njk1Ml0gIFs8ZmZmZmZmZmY4MzY0MDhlZT5dIGRvX29uZV9pbml0Y2FsbCsweDE4
MS8weDJiNApbICAgIDAuNDg5NDY1XSAgWzxmZmZmZmZmZjgzNjQwYmY1Pl0ga2VybmVsX2lu
aXRfZnJlZWFibGUrMHgxZDQvMHgyY2EKWyAgICAwLjQ4OTQ2NV0gIFs8ZmZmZmZmZmY4MzY0
MGJmNT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MWQ0LzB4MmNhClsgICAgMC40OTAwMzFd
ICBbPGZmZmZmZmZmODIyMmJhOGM+XSA/IHJlc3RfaW5pdCsweDE1MC8weDE1MApbICAgIDAu
NDkwMDMxXSAgWzxmZmZmZmZmZjgyMjJiYThjPl0gPyByZXN0X2luaXQrMHgxNTAvMHgxNTAK
WyAgICAwLjQ5MTc3Nl0gIFs8ZmZmZmZmZmY4MjIyYmFhMT5dIGtlcm5lbF9pbml0KzB4MTUv
MHgxNmUKWyAgICAwLjQ5MTc3Nl0gIFs8ZmZmZmZmZmY4MjIyYmFhMT5dIGtlcm5lbF9pbml0
KzB4MTUvMHgxNmUKWyAgICAwLjQ5NDA0MF0gIFs8ZmZmZmZmZmY4MjI0ZjczYT5dIHJldF9m
cm9tX2ZvcmsrMHg3YS8weGIwClsgICAgMC40OTQwNDBdICBbPGZmZmZmZmZmODIyNGY3M2E+
XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgIDAuNDk1Nzg5XSAgWzxmZmZmZmZmZjgy
MjJiYThjPl0gPyByZXN0X2luaXQrMHgxNTAvMHgxNTAKWyAgICAwLjQ5NTc4OV0gIFs8ZmZm
ZmZmZmY4MjIyYmE4Yz5dID8gcmVzdF9pbml0KzB4MTUwLzB4MTUwClsgICAgMC40OTc3MDVd
IC0tLVsgZW5kIHRyYWNlIDBlZWQ0M2E3YTc3NjhhZDQgXS0tLQpbICAgIDAuNDk3NzA1XSAt
LS1bIGVuZCB0cmFjZSAwZWVkNDNhN2E3NzY4YWQ0IF0tLS0KL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTEwMDkyNC9iYjAzY2RkYzE5MDg1YjhlMjBiYmM1NzhmNDVjYjhkOTY0
YTZlODU4L2RtZXNnLXlvY3RvLWtidWlsZC0xMjoyMDE0MDkxMDA5NTQxMTp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTEwMDkyNDozLjE3LjAtcmM0LTAwNzA2LWdiYjAzY2RkOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC9iYjAzY2RkYzE5MDg1YjhlMjBiYmM1
NzhmNDVjYjhkOTY0YTZlODU4L2RtZXNnLXlvY3RvLWtidWlsZC0xNDoyMDE0MDkxMDA5NTQx
Njp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNDozLjE3LjAtcmM0LTAwNzA2LWdiYjAz
Y2RkOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC9iYjAzY2RkYzE5
MDg1YjhlMjBiYmM1NzhmNDVjYjhkOTY0YTZlODU4L2RtZXNnLXlvY3RvLWtidWlsZC0yNDoy
MDE0MDkxMDA5NTQxMDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNDozLjE3LjAtcmM0
LTAwNzA2LWdiYjAzY2RkOjEKMDozOjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sx
OzM1bTIwMTQtMDktMTAgMDk6NTY6NDMgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJp
c2VjdC9saW51eC05L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogNzA2IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKWzBk
YzAxMTUyYTE0NzQ3MDk4NWEwZjM4OGFhMGY5ODljMTdlMzU5MzZdIE1lcmdlICd0aXAvcGVy
Zi91cmdlbnQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwOTEwMDcKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4LTkvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIw
MTQwOTEwMDc6MGRjMDExNTJhMTQ3NDcwOTg1YTBmMzg4YWEwZjk4OWMxN2UzNTkzNjpiaXNl
Y3QtbGludXgtOQoKMjAxNC0wOS0xMCAwOTo1Njo0NCAwZGMwMTE1MmExNDc0NzA5ODVhMGYz
ODhhYTBmOTg5YzE3ZTM1OTM2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDky
NC0wZGMwMTE1MmExNDc0NzA5ODVhMGYzODhhYTBmOTg5YzE3ZTM1OTM2CkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC8wZGMwMTE1
MmExNDc0NzA5ODVhMGYzODhhYTBmOTg5YzE3ZTM1OTM2CndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmIveDg2XzY0LXJhbmRjb25maWct
czEtMDkxMDA5MjQtMGRjMDExNTJhMTQ3NDcwOTg1YTBmMzg4YWEwZjk4OWMxN2UzNTkzNgob
WzE7MzVtMjAxNC0wOS0xMCAxMDowMTo0NCBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxk
LXRlc3RzL2J1aWxkLXNlcnZlZC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC0wZGMw
MTE1MmExNDc0NzA5ODVhMGYzODhhYTBmOTg5YzE3ZTM1OTM2G1swbQpSZXRyeSBidWlsZCAu
Lgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
c25iLXNtb2tlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0LTBkYzAxMTUyYTE0NzQ3
MDk4NWEwZjM4OGFhMGY5ODljMTdlMzU5MzYKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MTAwOTI0LzBkYzAxMTUyYTE0NzQ3MDk4NWEwZjM4OGFhMGY5ODljMTdl
MzU5MzYvdm1saW51ei0zLjE3LjAtcmM0LTAwMTQ0LWcwZGMwMTE1CgoyMDE0LTA5LTEwIDEw
OjA0OjQ0IGRldGVjdGluZyBib290IHN0YXRlIC4uCTQJNgkyMCBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDU2MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAg
c3RlcHMpClswYWNlMmEyMTliNTgzYWM1OWFjZWJiYjcxMWQ5YWE5ZWQ0OGUzNmQ5XSBNZXJn
ZSAna2Vlcy9nY2MtYnVnJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDkxMDA3CnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJp
c2VjdC9saW51eC05L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0L2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDkxMDA3OjBhY2UyYTIxOWI1ODNhYzU5YWNlYmJiNzExZDlhYTllZDQ4ZTM2
ZDk6YmlzZWN0LWxpbnV4LTkKCjIwMTQtMDktMTAgMTA6MDc6MTUgMGFjZTJhMjE5YjU4M2Fj
NTlhY2ViYmI3MTFkOWFhOWVkNDhlMzZkOSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmIveDg2XzY0LXJhbmRjb25maWctczEt
MDkxMDA5MjQtMGFjZTJhMjE5YjU4M2FjNTlhY2ViYmI3MTFkOWFhOWVkNDhlMzZkOQpDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQv
MGFjZTJhMjE5YjU4M2FjNTlhY2ViYmI3MTFkOWFhOWVkNDhlMzZkOQp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MTAwOTI0LTBhY2UyYTIxOWI1ODNhYzU5YWNlYmJiNzExZDlhYTllZDQ4
ZTM2ZDkKG1sxOzM1bTIwMTQtMDktMTAgMTA6MTE6MTUgTm8gYnVpbGQgc2VydmVkIGZpbGUg
L2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5
MjQtMGFjZTJhMjE5YjU4M2FjNTlhY2ViYmI3MTFkOWFhOWVkNDhlMzZkORtbMG0KUmV0cnkg
YnVpbGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC0wYWNlMmEy
MTliNTgzYWM1OWFjZWJiYjcxMWQ5YWE5ZWQ0OGUzNmQ5Cmtlcm5lbDogL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC8wYWNlMmEyMTliNTgzYWM1OWFjZWJiYjcxMWQ5
YWE5ZWQ0OGUzNmQ5L3ZtbGludXotMy4xNy4wLXJjNC0wMDY0MS1nMGFjZTJhMgoKMjAxNC0w
OS0xMCAxMDoxNDoxNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uCTUJMTkJMjAgU1VDQ0VT
UwoKQmlzZWN0aW5nOiA2NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgNyBzdGVwcykKWzI0YTc3NzgzOWE1NzZkMGI1OGVkZTBjZmVhYzU0NzAwZjkxYTZh
YTJdIE1lcmdlICd0cmFjZS9mdHJhY2UvY29yZScgaW50byBkZXZlbC1ob3VybHktMjAxNDA5
MTAwNwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2MvYm9vdC1iaXNlY3QvbGludXgtOS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC9saW51eC1k
ZXZlbDpkZXZlbC1ob3VybHktMjAxNDA5MTAwNzoyNGE3Nzc4MzlhNTc2ZDBiNThlZGUwY2Zl
YWM1NDcwMGY5MWE2YWEyOmJpc2VjdC1saW51eC05CgoyMDE0LTA5LTEwIDEwOjE3OjQ1IDI0
YTc3NzgzOWE1NzZkMGI1OGVkZTBjZmVhYzU0NzAwZjkxYTZhYTIgY29tcGlsaW5nClF1ZXVl
ZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MTAwOTI0LTI0YTc3NzgzOWE1NzZkMGI1OGVkZTBjZmVhYzU0NzAw
ZjkxYTZhYTIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MTAwOTI0LzI0YTc3NzgzOWE1NzZkMGI1OGVkZTBjZmVhYzU0NzAwZjkxYTZhYTIK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3Nu
Yi94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC0yNGE3Nzc4MzlhNTc2ZDBiNThlZGUw
Y2ZlYWM1NDcwMGY5MWE2YWEyChtbMTszNW0yMDE0LTA5LTEwIDEwOjIyOjQ1IE5vIGJ1aWxk
IHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MTAwOTI0LTI0YTc3NzgzOWE1NzZkMGI1OGVkZTBjZmVhYzU0NzAwZjkxYTZh
YTIbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWctczEtMDkx
MDA5MjQtMjRhNzc3ODM5YTU3NmQwYjU4ZWRlMGNmZWFjNTQ3MDBmOTFhNmFhMgprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQvMjRhNzc3ODM5YTU3NmQw
YjU4ZWRlMGNmZWFjNTQ3MDBmOTFhNmFhMi92bWxpbnV6LTMuMTcuMC1yYzQtMDA2NjctZzI0
YTc3NzgKCjIwMTQtMDktMTAgMTA6MjQ6NDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4u
IFRFU1QgRkFJTFVSRQpGQUlMRUQhClsgICAgMC40NTEzODBdIC0tLS0tLS0tLS0tLVsgY3V0
IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuNDUxMzgwXSAtLS0tLS0tLS0tLS1bIGN1dCBo
ZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjQ1MzMzMl0gV0FSTklORzogQ1BVOiAwIFBJRDog
MSBhdCBrZXJuZWwvdHJhY2UvdHJhY2UuYzoxMTI3IHJlZ2lzdGVyX3RyYWNlcisweDFlNS8w
eDMwOSgpClsgICAgMC40NTMzMzJdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQga2VybmVs
L3RyYWNlL3RyYWNlLmM6MTEyNyByZWdpc3Rlcl90cmFjZXIrMHgxZTUvMHgzMDkoKQpbICAg
IDAuNDU3NDM5XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4x
Ny4wLXJjNC0wMDY2Ny1nMjRhNzc3OCAjMQpbICAgIDAuNDU3NDM5XSBDUFU6IDAgUElEOiAx
IENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNy4wLXJjNC0wMDY2Ny1nMjRhNzc3OCAj
MQpbICAgIDAuNDYwMTE5XSAgMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuNDYwMTE5XSAgMDAw
MDAwMDAwMDAwMDAwMCBmZmZmODgwMDExNDRmZTE4IGZmZmY4ODAwMTE0NGZlMTggZmZmZmZm
ZmY4MjIzOGM2YSBmZmZmZmZmZjgyMjM4YzZhIGZmZmY4ODAwMTE0NGZlNTAgZmZmZjg4MDAx
MTQ0ZmU1MAoKWyAgICAwLjQ2MzE5OF0gIGZmZmZmZmZmODEwY2EzOTYKWyAgICAwLjQ2MzE5
OF0gIGZmZmZmZmZmODEwY2EzOTYgZmZmZmZmZmY4MTE3MzA3MyBmZmZmZmZmZjgxMTczMDcz
IGZmZmZmZmZmODM1NTg2ODAgZmZmZmZmZmY4MzU1ODY4MCBmZmZmZmZmZjgzNjMwOGMwIGZm
ZmZmZmZmODM2MzA4YzAKClsgICAgMC40NzAxNDZdICBmZmZmZmZmZjgyYmJmZThkClsgICAg
MC40NzAxNDZdICBmZmZmZmZmZjgyYmJmZThkIGZmZmZmZmZmODM3MTA5MTAgZmZmZmZmZmY4
MzcxMDkxMCBmZmZmODgwMDExNDRmZTYwIGZmZmY4ODAwMTE0NGZlNjAgZmZmZmZmZmY4MTBj
YTRlYSBmZmZmZmZmZjgxMGNhNGVhCgpbICAgIDAuNDczMDk0XSBDYWxsIFRyYWNlOgpbICAg
IDAuNDczMDk0XSBDYWxsIFRyYWNlOgpbICAgIDAuNDc0MDMyXSAgWzxmZmZmZmZmZjgyMjM4
YzZhPl0gZHVtcF9zdGFjaysweDJlLzB4M2UKWyAgICAwLjQ3NDAzMl0gIFs8ZmZmZmZmZmY4
MjIzOGM2YT5dIGR1bXBfc3RhY2srMHgyZS8weDNlClsgICAgMC40NzU5NTBdICBbPGZmZmZm
ZmZmODEwY2EzOTY+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDlkLzB4Y2IKWyAgICAwLjQ3
NTk1MF0gIFs8ZmZmZmZmZmY4MTBjYTM5Nj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4OWQv
MHhjYgpbICAgIDAuNDc4MTgyXSAgWzxmZmZmZmZmZjgxMTczMDczPl0gPyByZWdpc3Rlcl90
cmFjZXIrMHgxZTUvMHgzMDkKWyAgICAwLjQ3ODE4Ml0gIFs8ZmZmZmZmZmY4MTE3MzA3Mz5d
ID8gcmVnaXN0ZXJfdHJhY2VyKzB4MWU1LzB4MzA5ClsgICAgMC40ODAwNDFdICBbPGZmZmZm
ZmZmODEwY2E0ZWE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyOC8weDMxClsgICAgMC40ODAw
NDFdICBbPGZmZmZmZmZmODEwY2E0ZWE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyOC8weDMx
ClsgICAgMC40ODIyNzVdICBbPGZmZmZmZmZmODExNzMwNzM+XSByZWdpc3Rlcl90cmFjZXIr
MHgxZTUvMHgzMDkKWyAgICAwLjQ4MjI3NV0gIFs8ZmZmZmZmZmY4MTE3MzA3Mz5dIHJlZ2lz
dGVyX3RyYWNlcisweDFlNS8weDMwOQpbICAgIDAuNDg0NDUzXSAgWzxmZmZmZmZmZjgzNjY4
MWZkPl0gPyBpbml0X2dyYXBoX2RlYnVnZnMrMHg0Yi8weDRiClsgICAgMC40ODQ0NTNdICBb
PGZmZmZmZmZmODM2NjgxZmQ+XSA/IGluaXRfZ3JhcGhfZGVidWdmcysweDRiLzB4NGIKWyAg
ICAwLjQ4NjcxNF0gIFs8ZmZmZmZmZmY4MzY2ODI5OT5dIGluaXRfZ3JhcGhfdHJhY2UrMHg5
Yy8weGE1ClsgICAgMC40ODY3MTRdICBbPGZmZmZmZmZmODM2NjgyOTk+XSBpbml0X2dyYXBo
X3RyYWNlKzB4OWMvMHhhNQpbICAgIDAuNDg4ODUwXSAgWzxmZmZmZmZmZjgzNjQwOGVlPl0g
ZG9fb25lX2luaXRjYWxsKzB4MTgxLzB4MmI0ClsgICAgMC40ODg4NTBdICBbPGZmZmZmZmZm
ODM2NDA4ZWU+XSBkb19vbmVfaW5pdGNhbGwrMHgxODEvMHgyYjQKWyAgICAwLjQ5MDAzOV0g
IFs8ZmZmZmZmZmY4MzY0MGJmNT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MWQ0LzB4MmNh
ClsgICAgMC40OTAwMzldICBbPGZmZmZmZmZmODM2NDBiZjU+XSBrZXJuZWxfaW5pdF9mcmVl
YWJsZSsweDFkNC8weDJjYQpbICAgIDAuNDkyMzgzXSAgWzxmZmZmZmZmZjgyMjJiYThjPl0g
PyByZXN0X2luaXQrMHgxNTAvMHgxNTAKWyAgICAwLjQ5MjM4M10gIFs8ZmZmZmZmZmY4MjIy
YmE4Yz5dID8gcmVzdF9pbml0KzB4MTUwLzB4MTUwClsgICAgMC40OTQ0MjJdICBbPGZmZmZm
ZmZmODIyMmJhYTE+XSBrZXJuZWxfaW5pdCsweDE1LzB4MTZlClsgICAgMC40OTQ0MjJdICBb
PGZmZmZmZmZmODIyMmJhYTE+XSBrZXJuZWxfaW5pdCsweDE1LzB4MTZlClsgICAgMC40OTY0
MjZdICBbPGZmZmZmZmZmODIyNGY3M2E+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAg
IDAuNDk2NDI2XSAgWzxmZmZmZmZmZjgyMjRmNzNhPl0gcmV0X2Zyb21fZm9yaysweDdhLzB4
YjAKWyAgICAwLjUwMDA0NV0gIFs8ZmZmZmZmZmY4MjIyYmE4Yz5dID8gcmVzdF9pbml0KzB4
MTUwLzB4MTUwClsgICAgMC41MDAwNDVdICBbPGZmZmZmZmZmODIyMmJhOGM+XSA/IHJlc3Rf
aW5pdCsweDE1MC8weDE1MApbICAgIDAuNTAyMTU3XSAtLS1bIGVuZCB0cmFjZSA3ZDZmNzU5
N2RkZTA4MmJkIF0tLS0KWyAgICAwLjUwMjE1N10gLS0tWyBlbmQgdHJhY2UgN2Q2Zjc1OTdk
ZGUwODJiZCBdLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQvMjRh
Nzc3ODM5YTU3NmQwYjU4ZWRlMGNmZWFjNTQ3MDBmOTFhNmFhMi9kbWVzZy1xdWFudGFsLWti
dWlsZC0xODoyMDE0MDkxMDEwMjUwOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNDoz
LjE3LjAtcmM0LTAwNjY3LWcyNGE3Nzc4OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTEwMDkyNC8yNGE3Nzc4MzlhNTc2ZDBiNThlZGUwY2ZlYWM1NDcwMGY5MWE2YWEyL2Rt
ZXNnLXF1YW50YWwta2J1aWxkLTIzOjIwMTQwOTEwMTAyNTA5Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA5MTAwOTI0OjMuMTcuMC1yYzQtMDA2NjctZzI0YTc3Nzg6MQowOjI6MiBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOS0xMCAxMDoyNzo0NyBSRVBFQVQg
Q09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTkvb2JqLWJpc2VjdC8ucmVwZWF0
G1swbQoKQmlzZWN0aW5nOiAyNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgNSBzdGVwcykKWzQyODEyODM3N2E4ZDYzYzAyNmIzYjNhZTQyZmNhY2QyYTNi
OWNmNjZdIE1lcmdlICdhcm0tc29jL3JlbmVzYXMvc29jMycgaW50byBkZXZlbC1ob3VybHkt
MjAxNDA5MTAwNwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtOS9vYmotYmlzZWN0CmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA5MTAwNzo0MjgxMjgzNzdhOGQ2M2MwMjZi
M2IzYWU0MmZjYWNkMmEzYjljZjY2OmJpc2VjdC1saW51eC05CgoyMDE0LTA5LTEwIDEwOjI3
OjQ3IDQyODEyODM3N2E4ZDYzYzAyNmIzYjNhZTQyZmNhY2QyYTNiOWNmNjYgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0LTQyODEyODM3N2E4ZDYzYzAyNmIzYjNhZTQy
ZmNhY2QyYTNiOWNmNjYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MTAwOTI0LzQyODEyODM3N2E4ZDYzYzAyNmIzYjNhZTQyZmNhY2QyYTNi
OWNmNjYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC00MjgxMjgzNzdhOGQ2M2Mw
MjZiM2IzYWU0MmZjYWNkMmEzYjljZjY2ChtbMTszNW0yMDE0LTA5LTEwIDEwOjM0OjQ4IE5v
IGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MTAwOTI0LTQyODEyODM3N2E4ZDYzYzAyNmIzYjNhZTQyZmNhY2Qy
YTNiOWNmNjYbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWct
czEtMDkxMDA5MjQtNDI4MTI4Mzc3YThkNjNjMDI2YjNiM2FlNDJmY2FjZDJhM2I5Y2Y2Ngpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQvNDI4MTI4Mzc3
YThkNjNjMDI2YjNiM2FlNDJmY2FjZDJhM2I5Y2Y2Ni92bWxpbnV6LTMuMTcuMC1yYzQtMDA2
NTgtZzQyODEyODMKCjIwMTQtMDktMTAgMTA6Mzc6NDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4JMS4JMjAgU1VDQ0VTUwoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgdHJh
Y2UvZnRyYWNlL2NvcmUKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2Vj
dApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDI0YTc3NzgzOWE1NzZkMGI1OGVk
ZTBjZmVhYzU0NzAwZjkxYTZhYTIgNDI4MTI4Mzc3YThkNjNjMDI2YjNiM2FlNDJmY2FjZDJh
M2I5Y2Y2NiAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA0MjgxMjgzLi4uIE1lcmdl
ICdhcm0tc29jL3JlbmVzYXMvc29jMycgaW50byBkZXZlbC1ob3VybHktMjAxNDA5MTAwNwpI
RUFEIGlzIG5vdyBhdCBiNGQzMzE4Li4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J2NyeXB0by9tYXN0ZXInCkJpc2VjdGluZzogNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzQ5MzBkMjgwYWJhNjY3MmViNDRjN2FkY2Mw
ZDQ3YzBhZjg5MzZjNzJdIGZ0cmFjZTogR3JhYiBhbnkgb3BzIGZvciBhIHJlYyBmb3IgZW5h
YmxlZF9mdW5jdGlvbnMgb3V0cHV0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXgtOS9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC05L29iai1iaXNlY3QK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MTAwOTI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkxMDA3OjQ5MzBkMjgw
YWJhNjY3MmViNDRjN2FkY2MwZDQ3YzBhZjg5MzZjNzI6YmlzZWN0LWxpbnV4LTkKCjIwMTQt
MDktMTAgMTA6NDA6MzUgNDkzMGQyODBhYmE2NjcyZWI0NGM3YWRjYzBkNDdjMGFmODkzNmM3
MiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9zbmIveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQtNDkzMGQyODBhYmE2Njcy
ZWI0NGM3YWRjYzBkNDdjMGFmODkzNmM3MgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQvNDkzMGQyODBhYmE2NjcyZWI0NGM3YWRj
YzBkNDdjMGFmODkzNmM3Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0LTQ5MzBk
MjgwYWJhNjY3MmViNDRjN2FkY2MwZDQ3YzBhZjg5MzZjNzIKG1sxOzM1bTIwMTQtMDktMTAg
MTA6NDU6MzUgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2
ZWQveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQtNDkzMGQyODBhYmE2NjcyZWI0NGM3
YWRjYzBkNDdjMGFmODkzNmM3MhtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTEwMDkyNC00OTMwZDI4MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0N2Mw
YWY4OTM2YzcyCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDky
NC80OTMwZDI4MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0N2MwYWY4OTM2YzcyL3ZtbGludXotMy4x
Ny4wLXJjNC0wMDAwNC1nNDkzMGQyOAoKMjAxNC0wOS0xMCAxMDo0NzozNiBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuLi4uIFRFU1QgRkFJTFVSRQpGQUlMRUQhClsgICAgMC4zMzA2MThdIC0t
LS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMzMwNjE4XSAtLS0t
LS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjMzMTY0N10gV0FSTklO
RzogQ1BVOiAwIFBJRDogMSBhdCBrZXJuZWwvdHJhY2UvdHJhY2UuYzoxMTI3IHJlZ2lzdGVy
X3RyYWNlcisweDFlNS8weDMwOSgpClsgICAgMC4zMzE2NDddIFdBUk5JTkc6IENQVTogMCBQ
SUQ6IDEgYXQga2VybmVsL3RyYWNlL3RyYWNlLmM6MTEyNyByZWdpc3Rlcl90cmFjZXIrMHgx
ZTUvMHgzMDkoKQpbICAgIDAuMzMzNDI5XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIg
Tm90IHRhaW50ZWQgMy4xNy4wLXJjNC0wMDAwNC1nNDkzMGQyOCAjMQpbICAgIDAuMzMzNDI5
XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNy4wLXJjNC0w
MDAwNC1nNDkzMGQyOCAjMQpbICAgIDAuMzM0NzIyXSAgMDAwMDAwMDAwMDAwMDAwMApbICAg
IDAuMzM0NzIyXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDEyODRmZTE4IGZmZmY4ODAw
MTI4NGZlMTggZmZmZmZmZmY4MjIzYzZiNCBmZmZmZmZmZjgyMjNjNmI0IGZmZmY4ODAwMTI4
NGZlNTAgZmZmZjg4MDAxMjg0ZmU1MAoKWyAgICAwLjMzNjA4N10gIGZmZmZmZmZmODEwY2Ez
MTQKWyAgICAwLjMzNjA4N10gIGZmZmZmZmZmODEwY2EzMTQgZmZmZmZmZmY4MTE3MjQyMCBm
ZmZmZmZmZjgxMTcyNDIwIGZmZmZmZmZmODM1NjA4ODAgZmZmZmZmZmY4MzU2MDg4MCBmZmZm
ZmZmZjgzNjM4Y2MwIGZmZmZmZmZmODM2MzhjYzAKClsgICAgMC4zMzc0NDZdICBmZmZmZmZm
ZjgyYmM2Mzk3ClsgICAgMC4zMzc0NDZdICBmZmZmZmZmZjgyYmM2Mzk3IGZmZmZmZmZmODM3
MWE5MTAgZmZmZmZmZmY4MzcxYTkxMCBmZmZmODgwMDEyODRmZTYwIGZmZmY4ODAwMTI4NGZl
NjAgZmZmZmZmZmY4MTBjYTQ2OCBmZmZmZmZmZjgxMGNhNDY4CgpbICAgIDAuMzM4Nzk2XSBD
YWxsIFRyYWNlOgpbICAgIDAuMzM4Nzk2XSBDYWxsIFRyYWNlOgpbICAgIDAuMzM5MjM2XSAg
WzxmZmZmZmZmZjgyMjNjNmI0Pl0gZHVtcF9zdGFjaysweDJlLzB4M2UKWyAgICAwLjMzOTIz
Nl0gIFs8ZmZmZmZmZmY4MjIzYzZiND5dIGR1bXBfc3RhY2srMHgyZS8weDNlClsgICAgMC4z
NDAwMThdICBbPGZmZmZmZmZmODEwY2EzMTQ+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDlk
LzB4Y2IKWyAgICAwLjM0MDAxOF0gIFs8ZmZmZmZmZmY4MTBjYTMxND5dIHdhcm5fc2xvd3Bh
dGhfY29tbW9uKzB4OWQvMHhjYgpbICAgIDAuMzQxMDgwXSAgWzxmZmZmZmZmZjgxMTcyNDIw
Pl0gPyByZWdpc3Rlcl90cmFjZXIrMHgxZTUvMHgzMDkKWyAgICAwLjM0MTA4MF0gIFs8ZmZm
ZmZmZmY4MTE3MjQyMD5dID8gcmVnaXN0ZXJfdHJhY2VyKzB4MWU1LzB4MzA5ClsgICAgMC4z
NDIxMTddICBbPGZmZmZmZmZmODEwY2E0Njg+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyOC8w
eDMxClsgICAgMC4zNDIxMTddICBbPGZmZmZmZmZmODEwY2E0Njg+XSB3YXJuX3Nsb3dwYXRo
X251bGwrMHgyOC8weDMxClsgICAgMC4zNDMxNTFdICBbPGZmZmZmZmZmODExNzI0MjA+XSBy
ZWdpc3Rlcl90cmFjZXIrMHgxZTUvMHgzMDkKWyAgICAwLjM0MzE1MV0gIFs8ZmZmZmZmZmY4
MTE3MjQyMD5dIHJlZ2lzdGVyX3RyYWNlcisweDFlNS8weDMwOQpbICAgIDAuMzQ0MTYwXSAg
WzxmZmZmZmZmZjgzNjcxMWZkPl0gPyBpbml0X2dyYXBoX2RlYnVnZnMrMHg0Yi8weDRiClsg
ICAgMC4zNDQxNjBdICBbPGZmZmZmZmZmODM2NzExZmQ+XSA/IGluaXRfZ3JhcGhfZGVidWdm
cysweDRiLzB4NGIKWyAgICAwLjM0NTIxMl0gIFs8ZmZmZmZmZmY4MzY3MTI5OT5dIGluaXRf
Z3JhcGhfdHJhY2UrMHg5Yy8weGE1ClsgICAgMC4zNDUyMTJdICBbPGZmZmZmZmZmODM2NzEy
OTk+XSBpbml0X2dyYXBoX3RyYWNlKzB4OWMvMHhhNQpbICAgIDAuMzQ2MjAzXSAgWzxmZmZm
ZmZmZjgzNjQ5OGVlPl0gZG9fb25lX2luaXRjYWxsKzB4MTgxLzB4MmI0ClsgICAgMC4zNDYy
MDNdICBbPGZmZmZmZmZmODM2NDk4ZWU+XSBkb19vbmVfaW5pdGNhbGwrMHgxODEvMHgyYjQK
WyAgICAwLjM0NzIwOF0gIFs8ZmZmZmZmZmY4MzY0OWJmNT5dIGtlcm5lbF9pbml0X2ZyZWVh
YmxlKzB4MWQ0LzB4MmNhClsgICAgMC4zNDcyMDhdICBbPGZmZmZmZmZmODM2NDliZjU+XSBr
ZXJuZWxfaW5pdF9mcmVlYWJsZSsweDFkNC8weDJjYQpbICAgIDAuMzQ4MzA1XSAgWzxmZmZm
ZmZmZjgyMjJmNDhjPl0gPyByZXN0X2luaXQrMHgxNTAvMHgxNTAKWyAgICAwLjM0ODMwNV0g
IFs8ZmZmZmZmZmY4MjIyZjQ4Yz5dID8gcmVzdF9pbml0KzB4MTUwLzB4MTUwClsgICAgMC4z
NDkyNTldICBbPGZmZmZmZmZmODIyMmY0YTE+XSBrZXJuZWxfaW5pdCsweDE1LzB4MTZlClsg
ICAgMC4zNDkyNTldICBbPGZmZmZmZmZmODIyMmY0YTE+XSBrZXJuZWxfaW5pdCsweDE1LzB4
MTZlClsgICAgMC4zNTAwMjFdICBbPGZmZmZmZmZmODIyNTMxM2E+XSByZXRfZnJvbV9mb3Jr
KzB4N2EvMHhiMApbICAgIDAuMzUwMDIxXSAgWzxmZmZmZmZmZjgyMjUzMTNhPl0gcmV0X2Zy
b21fZm9yaysweDdhLzB4YjAKWyAgICAwLjM1MDk4M10gIFs8ZmZmZmZmZmY4MjIyZjQ4Yz5d
ID8gcmVzdF9pbml0KzB4MTUwLzB4MTUwClsgICAgMC4zNTA5ODNdICBbPGZmZmZmZmZmODIy
MmY0OGM+XSA/IHJlc3RfaW5pdCsweDE1MC8weDE1MApbICAgIDAuMzUyMDgxXSAtLS1bIGVu
ZCB0cmFjZSBhZGM5MmM4MDg1MjBkOTY4IF0tLS0KWyAgICAwLjM1MjA4MV0gLS0tWyBlbmQg
dHJhY2UgYWRjOTJjODA4NTIwZDk2OCBdLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDkxMDA5MjQvNDkzMGQyODBhYmE2NjcyZWI0NGM3YWRjYzBkNDdjMGFmODkzNmM3Mi9k
bWVzZy15b2N0by1pdmI0MS0xMToyMDE0MDkxMDEwNDkwMTp4ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTEwMDkyNDo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQvNDkz
MGQyODBhYmE2NjcyZWI0NGM3YWRjYzBkNDdjMGFmODkzNmM3Mi9kbWVzZy15b2N0by1pdmI0
MS0xMzoyMDE0MDkxMDEwNDkwMzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNDo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQvNDkzMGQyODBhYmE2NjcyZWI0
NGM3YWRjYzBkNDdjMGFmODkzNmM3Mi9kbWVzZy15b2N0by1pdmI0MS0xNDoyMDE0MDkxMDEw
NDkwMjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNDo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDkxMDA5MjQvNDkzMGQyODBhYmE2NjcyZWI0NGM3YWRjYzBkNDdjMGFm
ODkzNmM3Mi9kbWVzZy15b2N0by1pdmI0MS0xOToyMDE0MDkxMDEwNDkwMjp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTEwMDkyNDo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkx
MDA5MjQvNDkzMGQyODBhYmE2NjcyZWI0NGM3YWRjYzBkNDdjMGFmODkzNmM3Mi9kbWVzZy15
b2N0by1pdmI0MS0xOjIwMTQwOTEwMTA0OTAxOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAw
OTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC80OTMwZDI4MGFi
YTY2NzJlYjQ0YzdhZGNjMGQ0N2MwYWY4OTM2YzcyL2RtZXNnLXlvY3RvLWl2YjQxLTIxOjIw
MTQwOTEwMTA0OTAxOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC80OTMwZDI4MGFiYTY2NzJlYjQ0YzdhZGNj
MGQ0N2MwYWY4OTM2YzcyL2RtZXNnLXlvY3RvLWl2YjQxLTI5OjIwMTQwOTEwMTA0OTAyOng4
Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wOTEwMDkyNC80OTMwZDI4MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0N2MwYWY4OTM2Yzcy
L2RtZXNnLXlvY3RvLWl2YjQxLTMxOjIwMTQwOTEwMTA0OTAxOng4Nl82NC1yYW5kY29uZmln
LXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC80
OTMwZDI4MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0N2MwYWY4OTM2YzcyL2RtZXNnLXlvY3RvLWl2
YjQxLTM0OjIwMTQwOTEwMTA0OTAyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC80OTMwZDI4MGFiYTY2NzJl
YjQ0YzdhZGNjMGQ0N2MwYWY4OTM2YzcyL2RtZXNnLXlvY3RvLWl2YjQxLTM2OjIwMTQwOTEw
MTA0OTAxOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTEwMDkyNC80OTMwZDI4MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0N2Mw
YWY4OTM2YzcyL2RtZXNnLXlvY3RvLWl2YjQxLTM4OjIwMTQwOTEwMTA0OTAzOng4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTEwMDkyNC80OTMwZDI4MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0N2MwYWY4OTM2YzcyL2RtZXNn
LXlvY3RvLWl2YjQxLTQ1OjIwMTQwOTEwMTA0OTAyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC80OTMwZDI4
MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0N2MwYWY4OTM2YzcyL2RtZXNnLXlvY3RvLWl2YjQxLTUz
OjIwMTQwOTEwMTA0OTAzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC80OTMwZDI4MGFiYTY2NzJlYjQ0Yzdh
ZGNjMGQ0N2MwYWY4OTM2YzcyL2RtZXNnLXlvY3RvLWl2YjQxLTU1OjIwMTQwOTEwMTA0OTAy
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTEwMDkyNC80OTMwZDI4MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0N2MwYWY4OTM2
YzcyL2RtZXNnLXlvY3RvLWl2YjQxLTU4OjIwMTQwOTEwMTA0OTAzOng4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDky
NC80OTMwZDI4MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0N2MwYWY4OTM2YzcyL2RtZXNnLXlvY3Rv
LWl2YjQxLTYwOjIwMTQwOTEwMTA0OTAyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC80OTMwZDI4MGFiYTY2
NzJlYjQ0YzdhZGNjMGQ0N2MwYWY4OTM2YzcyL2RtZXNnLXlvY3RvLWl2YjQxLTY1OjIwMTQw
OTEwMTA0OTAyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC80OTMwZDI4MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0
N2MwYWY4OTM2YzcyL2RtZXNnLXlvY3RvLWl2YjQxLTcyOjIwMTQwOTEwMTA0OTAxOng4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTEwMDkyNC80OTMwZDI4MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0N2MwYWY4OTM2YzcyL2Rt
ZXNnLXlvY3RvLWl2YjQxLTczOjIwMTQwOTEwMTA0OTAzOng4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC80OTMw
ZDI4MGFiYTY2NzJlYjQ0YzdhZGNjMGQ0N2MwYWY4OTM2YzcyL2RtZXNnLXlvY3RvLWl2YjQx
LTk6MjAxNDA5MTAxMDQ5MDI6eDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQ6OgowOjIw
OjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA5LTEwIDEwOjQ5
OjQyIFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtOS9vYmotYmlz
ZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbODczNTQwNTk4ODFjZTkzMTUxODE2MDRkYzE3
MDc2YzUzNWY0ZDc0NF0gZnRyYWNlOiBBZGQgaGVscGVyIGZ1bmN0aW9uIGZ0cmFjZV9vcHNf
Z2V0X2Z1bmMoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtOS9vYmotYmlzZWN0CmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA5MTAwNzo4NzM1NDA1OTg4MWNlOTMxNTE4
MTYwNGRjMTcwNzZjNTM1ZjRkNzQ0OmJpc2VjdC1saW51eC05CgoyMDE0LTA5LTEwIDEwOjQ5
OjQ0IDg3MzU0MDU5ODgxY2U5MzE1MTgxNjA0ZGMxNzA3NmM1MzVmNGQ3NDQgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0LTg3MzU0MDU5ODgxY2U5MzE1MTgxNjA0ZGMx
NzA3NmM1MzVmNGQ3NDQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MTAwOTI0Lzg3MzU0MDU5ODgxY2U5MzE1MTgxNjA0ZGMxNzA3NmM1MzVm
NGQ3NDQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC04NzM1NDA1OTg4MWNlOTMx
NTE4MTYwNGRjMTcwNzZjNTM1ZjRkNzQ0ChtbMTszNW0yMDE0LTA5LTEwIDEwOjUzOjQ1IE5v
IGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MTAwOTI0LTg3MzU0MDU5ODgxY2U5MzE1MTgxNjA0ZGMxNzA3NmM1
MzVmNGQ3NDQbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWct
czEtMDkxMDA5MjQtODczNTQwNTk4ODFjZTkzMTUxODE2MDRkYzE3MDc2YzUzNWY0ZDc0NApr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQvODczNTQwNTk4
ODFjZTkzMTUxODE2MDRkYzE3MDc2YzUzNWY0ZDc0NC92bWxpbnV6LTMuMTcuMC1yYzQtMDAw
MDItZzg3MzU0MDUKCjIwMTQtMDktMTAgMTA6NTY6NDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4uIFRFU1QgRkFJTFVSRQpGQUlMRUQhClsgICAgMC4zMzA1ODhdIC0tLS0tLS0tLS0tLVsg
Y3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMzMwNTg4XSAtLS0tLS0tLS0tLS1bIGN1
dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjMzMTQxNF0gV0FSTklORzogQ1BVOiAwIFBJ
RDogMSBhdCBrZXJuZWwvdHJhY2UvdHJhY2UuYzoxMTI3IHJlZ2lzdGVyX3RyYWNlcisweDFl
NS8weDMwOSgpClsgICAgMC4zMzE0MTRdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQga2Vy
bmVsL3RyYWNlL3RyYWNlLmM6MTEyNyByZWdpc3Rlcl90cmFjZXIrMHgxZTUvMHgzMDkoKQpb
ICAgIDAuMzMzMTY5XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQg
My4xNy4wLXJjNC0wMDAwMi1nODczNTQwNSAjMQpbICAgIDAuMzMzMTY5XSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNy4wLXJjNC0wMDAwMi1nODczNTQw
NSAjMQpbICAgIDAuMzM0NDYxXSAgMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMzM0NDYxXSAg
MDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDEyODRmZTE4IGZmZmY4ODAwMTI4NGZlMTggZmZm
ZmZmZmY4MjIzYzZiNCBmZmZmZmZmZjgyMjNjNmI0IGZmZmY4ODAwMTI4NGZlNTAgZmZmZjg4
MDAxMjg0ZmU1MAoKWyAgICAwLjMzNTgyMV0gIGZmZmZmZmZmODEwY2EzMTQKWyAgICAwLjMz
NTgyMV0gIGZmZmZmZmZmODEwY2EzMTQgZmZmZmZmZmY4MTE3MjQyMCBmZmZmZmZmZjgxMTcy
NDIwIGZmZmZmZmZmODM1NjA4ODAgZmZmZmZmZmY4MzU2MDg4MCBmZmZmZmZmZjgzNjM4Y2Mw
IGZmZmZmZmZmODM2MzhjYzAKClsgICAgMC4zMzcxODBdICBmZmZmZmZmZjgyYmM2Mzk3Clsg
ICAgMC4zMzcxODBdICBmZmZmZmZmZjgyYmM2Mzk3IGZmZmZmZmZmODM3MWE5MTAgZmZmZmZm
ZmY4MzcxYTkxMCBmZmZmODgwMDEyODRmZTYwIGZmZmY4ODAwMTI4NGZlNjAgZmZmZmZmZmY4
MTBjYTQ2OCBmZmZmZmZmZjgxMGNhNDY4CgpbICAgIDAuMzM4NTM5XSBDYWxsIFRyYWNlOgpb
ICAgIDAuMzM4NTM5XSBDYWxsIFRyYWNlOgpbICAgIDAuMzM4OTg3XSAgWzxmZmZmZmZmZjgy
MjNjNmI0Pl0gZHVtcF9zdGFjaysweDJlLzB4M2UKWyAgICAwLjMzODk4N10gIFs8ZmZmZmZm
ZmY4MjIzYzZiND5dIGR1bXBfc3RhY2srMHgyZS8weDNlClsgICAgMC4zMzk4OTddICBbPGZm
ZmZmZmZmODEwY2EzMTQ+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDlkLzB4Y2IKWyAgICAw
LjMzOTg5N10gIFs8ZmZmZmZmZmY4MTBjYTMxND5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4
OWQvMHhjYgpbICAgIDAuMzQwMDE0XSAgWzxmZmZmZmZmZjgxMTcyNDIwPl0gPyByZWdpc3Rl
cl90cmFjZXIrMHgxZTUvMHgzMDkKWyAgICAwLjM0MDAxNF0gIFs8ZmZmZmZmZmY4MTE3MjQy
MD5dID8gcmVnaXN0ZXJfdHJhY2VyKzB4MWU1LzB4MzA5ClsgICAgMC4zNDEwNjBdICBbPGZm
ZmZmZmZmODEwY2E0Njg+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyOC8weDMxClsgICAgMC4z
NDEwNjBdICBbPGZmZmZmZmZmODEwY2E0Njg+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyOC8w
eDMxClsgICAgMC4zNDIwODZdICBbPGZmZmZmZmZmODExNzI0MjA+XSByZWdpc3Rlcl90cmFj
ZXIrMHgxZTUvMHgzMDkKWyAgICAwLjM0MjA4Nl0gIFs8ZmZmZmZmZmY4MTE3MjQyMD5dIHJl
Z2lzdGVyX3RyYWNlcisweDFlNS8weDMwOQpbICAgIDAuMzQzMDkxXSAgWzxmZmZmZmZmZjgz
NjcxMWZkPl0gPyBpbml0X2dyYXBoX2RlYnVnZnMrMHg0Yi8weDRiClsgICAgMC4zNDMwOTFd
ICBbPGZmZmZmZmZmODM2NzExZmQ+XSA/IGluaXRfZ3JhcGhfZGVidWdmcysweDRiLzB4NGIK
WyAgICAwLjM0NDE0N10gIFs8ZmZmZmZmZmY4MzY3MTI5OT5dIGluaXRfZ3JhcGhfdHJhY2Ur
MHg5Yy8weGE1ClsgICAgMC4zNDQxNDddICBbPGZmZmZmZmZmODM2NzEyOTk+XSBpbml0X2dy
YXBoX3RyYWNlKzB4OWMvMHhhNQpbICAgIDAuMzQ1MTQ1XSAgWzxmZmZmZmZmZjgzNjQ5OGVl
Pl0gZG9fb25lX2luaXRjYWxsKzB4MTgxLzB4MmI0ClsgICAgMC4zNDUxNDVdICBbPGZmZmZm
ZmZmODM2NDk4ZWU+XSBkb19vbmVfaW5pdGNhbGwrMHgxODEvMHgyYjQKWyAgICAwLjM0NjE1
NF0gIFs8ZmZmZmZmZmY4MzY0OWJmNT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MWQ0LzB4
MmNhClsgICAgMC4zNDYxNTRdICBbPGZmZmZmZmZmODM2NDliZjU+XSBrZXJuZWxfaW5pdF9m
cmVlYWJsZSsweDFkNC8weDJjYQpbICAgIDAuMzQ3MjM4XSAgWzxmZmZmZmZmZjgyMjJmNDhj
Pl0gPyByZXN0X2luaXQrMHgxNTAvMHgxNTAKWyAgICAwLjM0NzIzOF0gIFs8ZmZmZmZmZmY4
MjIyZjQ4Yz5dID8gcmVzdF9pbml0KzB4MTUwLzB4MTUwClsgICAgMC4zNDgxODhdICBbPGZm
ZmZmZmZmODIyMmY0YTE+XSBrZXJuZWxfaW5pdCsweDE1LzB4MTZlClsgICAgMC4zNDgxODhd
ICBbPGZmZmZmZmZmODIyMmY0YTE+XSBrZXJuZWxfaW5pdCsweDE1LzB4MTZlClsgICAgMC4z
NTAwMDldICBbPGZmZmZmZmZmODIyNTMxM2E+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApb
ICAgIDAuMzUwMDA5XSAgWzxmZmZmZmZmZjgyMjUzMTNhPl0gcmV0X2Zyb21fZm9yaysweDdh
LzB4YjAKWyAgICAwLjM1MDk2Nl0gIFs8ZmZmZmZmZmY4MjIyZjQ4Yz5dID8gcmVzdF9pbml0
KzB4MTUwLzB4MTUwClsgICAgMC4zNTA5NjZdICBbPGZmZmZmZmZmODIyMmY0OGM+XSA/IHJl
c3RfaW5pdCsweDE1MC8weDE1MApbICAgIDAuMzUxOTU1XSAtLS1bIGVuZCB0cmFjZSAzZmE2
NzA5OWJiYWVlMWYyIF0tLS0KWyAgICAwLjM1MTk1NV0gLS0tWyBlbmQgdHJhY2UgM2ZhNjcw
OTliYmFlZTFmMiBdLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQv
ODczNTQwNTk4ODFjZTkzMTUxODE2MDRkYzE3MDc2YzUzNWY0ZDc0NC9kbWVzZy15b2N0by1p
dmI0MS0xMDE6MjAxNDA5MTAxMDU3NTA6eDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQ6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0Lzg3MzU0MDU5ODgxY2U5
MzE1MTgxNjA0ZGMxNzA3NmM1MzVmNGQ3NDQvZG1lc2cteW9jdG8taXZiNDEtMTIwOjIwMTQw
OTEwMTA1NzUwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC84NzM1NDA1OTg4MWNlOTMxNTE4MTYwNGRjMTcw
NzZjNTM1ZjRkNzQ0L2RtZXNnLXlvY3RvLWl2YjQxLTEyMToyMDE0MDkxMDEwNTc1MDp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNDo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDkxMDA5MjQvODczNTQwNTk4ODFjZTkzMTUxODE2MDRkYzE3MDc2YzUzNWY0ZDc0NC9k
bWVzZy15b2N0by1pdmI0MS0xMjc6MjAxNDA5MTAxMDU3NTA6eDg2XzY0LXJhbmRjb25maWct
czEtMDkxMDA5MjQ6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0Lzg3
MzU0MDU5ODgxY2U5MzE1MTgxNjA0ZGMxNzA3NmM1MzVmNGQ3NDQvZG1lc2cteW9jdG8taXZi
NDEtMTU6MjAxNDA5MTAxMDU3NTA6eDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQ6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0Lzg3MzU0MDU5ODgxY2U5MzE1
MTgxNjA0ZGMxNzA3NmM1MzVmNGQ3NDQvZG1lc2cteW9jdG8taXZiNDEtMjc6MjAxNDA5MTAx
MDU3NTA6eDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQ6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MTAwOTI0Lzg3MzU0MDU5ODgxY2U5MzE1MTgxNjA0ZGMxNzA3NmM1
MzVmNGQ3NDQvZG1lc2cteW9jdG8taXZiNDEtMjg6MjAxNDA5MTAxMDU3NTA6eDg2XzY0LXJh
bmRjb25maWctczEtMDkxMDA5MjQ6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MTAwOTI0Lzg3MzU0MDU5ODgxY2U5MzE1MTgxNjA0ZGMxNzA3NmM1MzVmNGQ3NDQvZG1lc2ct
eW9jdG8taXZiNDEtMzE6MjAxNDA5MTAxMDU3NTA6eDg2XzY0LXJhbmRjb25maWctczEtMDkx
MDA5MjQ6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0Lzg3MzU0MDU5
ODgxY2U5MzE1MTgxNjA0ZGMxNzA3NmM1MzVmNGQ3NDQvZG1lc2cteW9jdG8taXZiNDEtMzY6
MjAxNDA5MTAxMDU3NDk6eDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQ6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0Lzg3MzU0MDU5ODgxY2U5MzE1MTgxNjA0
ZGMxNzA3NmM1MzVmNGQ3NDQvZG1lc2cteW9jdG8taXZiNDEtMzoyMDE0MDkxMDEwNTc1MDp4
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNDo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDkxMDA5MjQvODczNTQwNTk4ODFjZTkzMTUxODE2MDRkYzE3MDc2YzUzNWY0ZDc0
NC9kbWVzZy15b2N0by1pdmI0MS00MjoyMDE0MDkxMDEwNTc1MDp4ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wOTEwMDkyNDo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQv
ODczNTQwNTk4ODFjZTkzMTUxODE2MDRkYzE3MDc2YzUzNWY0ZDc0NC9kbWVzZy15b2N0by1p
dmI0MS00MzoyMDE0MDkxMDEwNTc1MDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNDo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQvODczNTQwNTk4ODFjZTkz
MTUxODE2MDRkYzE3MDc2YzUzNWY0ZDc0NC9kbWVzZy15b2N0by1pdmI0MS00OjIwMTQwOTEw
MTA1NzUwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTEwMDkyNC84NzM1NDA1OTg4MWNlOTMxNTE4MTYwNGRjMTcwNzZj
NTM1ZjRkNzQ0L2RtZXNnLXlvY3RvLWl2YjQxLTUwOjIwMTQwOTEwMTA1NzUwOng4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTEwMDkyNC84NzM1NDA1OTg4MWNlOTMxNTE4MTYwNGRjMTcwNzZjNTM1ZjRkNzQ0L2RtZXNn
LXlvY3RvLWl2YjQxLTU2OjIwMTQwOTEwMTA1NzUwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC84NzM1NDA1
OTg4MWNlOTMxNTE4MTYwNGRjMTcwNzZjNTM1ZjRkNzQ0L2RtZXNnLXlvY3RvLWl2YjQxLTYx
OjIwMTQwOTEwMTA1NzUwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC84NzM1NDA1OTg4MWNlOTMxNTE4MTYw
NGRjMTcwNzZjNTM1ZjRkNzQ0L2RtZXNnLXlvY3RvLWl2YjQxLTcwOjIwMTQwOTEwMTA1NzUw
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTEwMDkyNC84NzM1NDA1OTg4MWNlOTMxNTE4MTYwNGRjMTcwNzZjNTM1ZjRk
NzQ0L2RtZXNnLXlvY3RvLWl2YjQxLTg5OjIwMTQwOTEwMTA1NzQ5Ong4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MTAwOTI0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDky
NC84NzM1NDA1OTg4MWNlOTMxNTE4MTYwNGRjMTcwNzZjNTM1ZjRkNzQ0L2RtZXNnLXlvY3Rv
LWl2YjQxLTkxOjIwMTQwOTEwMTA1NzUwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC84NzM1NDA1OTg4MWNl
OTMxNTE4MTYwNGRjMTcwNzZjNTM1ZjRkNzQ0L2RtZXNnLXlvY3RvLWl2YjQxLTkyOjIwMTQw
OTEwMTA1NzQ5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjoKMDoyMDoyMCBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOS0xMCAxMDo1ODoxNyBSRVBF
QVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTkvb2JqLWJpc2VjdC8ucmVw
ZWF0G1swbQoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAwIHN0ZXBzKQpbZjFmZjYzNDhiMzBiMzY1OGQxMzhmMDU2NDMxNDk3MDZm
OTkwNzhhZV0gZnRyYWNlOiBBZGQgc2VwYXJhdGUgZnVuY3Rpb24gZm9yIG5vbiByZWN1cnNp
dmUgY2FsbGJhY2tzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC05L29iai1iaXNlY3QKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkxMDA3OmYxZmY2MzQ4YjMwYjM2NThk
MTM4ZjA1NjQzMTQ5NzA2Zjk5MDc4YWU6YmlzZWN0LWxpbnV4LTkKCjIwMTQtMDktMTAgMTA6
NTg6MjAgZjFmZjYzNDhiMzBiMzY1OGQxMzhmMDU2NDMxNDk3MDZmOTkwNzhhZSBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmIv
eDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQtZjFmZjYzNDhiMzBiMzY1OGQxMzhmMDU2
NDMxNDk3MDZmOTkwNzhhZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDkxMDA5MjQvZjFmZjYzNDhiMzBiMzY1OGQxMzhmMDU2NDMxNDk3MDZm
OTkwNzhhZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0LWYxZmY2MzQ4YjMwYjM2
NThkMTM4ZjA1NjQzMTQ5NzA2Zjk5MDc4YWUKG1sxOzM1bTIwMTQtMDktMTAgMTE6MDQ6MjAg
Tm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2XzY0
LXJhbmRjb25maWctczEtMDkxMDA5MjQtZjFmZjYzNDhiMzBiMzY1OGQxMzhmMDU2NDMxNDk3
MDZmOTkwNzhhZRtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wOTEwMDkyNC1mMWZmNjM0OGIzMGIzNjU4ZDEzOGYwNTY0MzE0OTcwNmY5OTA3OGFl
Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC9mMWZmNjM0
OGIzMGIzNjU4ZDEzOGYwNTY0MzE0OTcwNmY5OTA3OGFlL3ZtbGludXotMy4xNy4wLXJjNC0w
MDAwMS1nZjFmZjYzNAoKMjAxNC0wOS0xMCAxMTowNzoyMCBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLi4uCTEJMTQJMTcJMjAgU1VDQ0VTUwoKODczNTQwNTk4ODFjZTkzMTUxODE2MDRkYzE3
MDc2YzUzNWY0ZDc0NCBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgODczNTQwNTk4
ODFjZTkzMTUxODE2MDRkYzE3MDc2YzUzNWY0ZDc0NApBdXRob3I6IFN0ZXZlbiBSb3N0ZWR0
IChSZWQgSGF0KSA8cm9zdGVkdEBnb29kbWlzLm9yZz4KRGF0ZTogICBUdWUgSnVsIDIyIDIw
OjQxOjQyIDIwMTQgLTA0MDAKCiAgICBmdHJhY2U6IEFkZCBoZWxwZXIgZnVuY3Rpb24gZnRy
YWNlX29wc19nZXRfZnVuYygpCiAgICAKICAgIEFkZCB0aGUgaGVscGVyIGZ1bmN0aW9uIHRv
IHdoYXQgdGhlIG1jb3VudCB0cmFtcG9saW5lIGlzIHRvIGNhbGwKICAgIGZvciBhIGZ0cmFj
ZV9vcHMgZnVuY3Rpb24uIFRoaXMgaGVscGVyIHdpbGwgYmUgdXNlZCBieSBhcmNoIGNvZGUK
ICAgIGluIHRoZSBmdXR1cmUgdG8gc2V0IHVwIGR5bmFtaWMgdHJhbXBvbGluZXMuIEJ1dCBh
cyB0aGlzIGRvZXMgdGhlCiAgICBzYW1lIHRlc3RzIHRoYXQgYXJlIHBlcmZvcm1lZCBpbiBj
aG9vc2luZyB3aGF0IGZ1bmN0aW9uIHRvIGNhbGwgZm9yCiAgICB0aGUgZGVmYXVsdCBtY291
bnQgdHJhbXBvbGluZSwgbWlnaHQgYXMgd2VsbCB1c2UgaXQgdG8gY2xlYW4gdXAKICAgIHRo
ZSBleGlzdGluZyBjb2RlLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBTdGV2ZW4gUm9zdGVk
dCA8cm9zdGVkdEBnb29kbWlzLm9yZz4KCjowNDAwMDAgMDQwMDAwIDJhOTllY2U0NjdhZjU5
N2YyNmI0YmY0NTFjNWFlY2IyODg3YmUxMDAgNTZiODI3YmRkYTExODcxNmRiYmM3MDliYzRj
ZDAzMThkMmYwNTE0YiBNCWluY2x1ZGUKOjA0MDAwMCAwNDAwMDAgZmYyN2M2ODkzN2UyNDkw
NzU4ZTk3MjNmZDkxNDFkMjE5ZDg4MjE2MiAzOGVlNzVmMTY4MTM2NjRlYjU0NTRhMTg0ZDc2
NWExYTJiODMyNDgzIE0Ja2VybmVsCmJpc2VjdCBydW4gc3VjY2VzcwpIRUFEIGlzIG5vdyBh
dCBmMWZmNjM0Li4uIGZ0cmFjZTogQWRkIHNlcGFyYXRlIGZ1bmN0aW9uIGZvciBub24gcmVj
dXJzaXZlIGNhbGxiYWNrcwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIw
MTQwOTEwMDc6ZjFmZjYzNDhiMzBiMzY1OGQxMzhmMDU2NDMxNDk3MDZmOTkwNzhhZTpiaXNl
Y3QtbGludXgtOQoKMjAxNC0wOS0xMCAxMToxMToyMSBmMWZmNjM0OGIzMGIzNjU4ZDEzOGYw
NTY0MzE0OTcwNmY5OTA3OGFlIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEt
MDkxMDA5MjQvZjFmZjYzNDhiMzBiMzY1OGQxMzhmMDU2NDMxNDk3MDZmOTkwNzhhZS92bWxp
bnV6LTMuMTcuMC1yYzQtMDAwMDEtZ2YxZmY2MzQKCjIwMTQtMDktMTAgMTE6MTE6MjEgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMjIJMjQuCTUxCTU4CTU5Lgk2MCBTVUNDRVNTCgpQcmV2
aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBmMWZmNjM0Li4uIGZ0cmFjZTogQWRkIHNlcGFyYXRl
IGZ1bmN0aW9uIGZvciBub24gcmVjdXJzaXZlIGNhbGxiYWNrcwpIRUFEIGlzIG5vdyBhdCBh
MjI4YTMyLi4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDkxMDA3
JwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
czEtMDkxMDA5MjQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTEwMDc6YTIyOGEz
MjllMzVhODczOGZkNjUyODJkMzhkNmZiNWJkMDFmYzYxMjpiaXNlY3QtbGludXgtOQogVEVT
VCBGQUlMVVJFCkZBSUxFRCEKWyAgICAwLjQxMTIzM10gLS0tLS0tLS0tLS0tWyBjdXQgaGVy
ZSBdLS0tLS0tLS0tLS0tClsgICAgMC40MTEyMzNdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbICAgIDAuNDEyOTYzXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0
IGtlcm5lbC90cmFjZS90cmFjZS5jOjExMjcgcmVnaXN0ZXJfdHJhY2VyKzB4MWU1LzB4MzA5
KCkKWyAgICAwLjQxMjk2M10gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCBrZXJuZWwvdHJh
Y2UvdHJhY2UuYzoxMTI3IHJlZ2lzdGVyX3RyYWNlcisweDFlNS8weDMwOSgpClsgICAgMC40
MTY4NDZdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE3LjAt
cmM0LXdsLTAxNTMyLWdhMjI4YTMyICMxNTkKWyAgICAwLjQxNjg0Nl0gQ1BVOiAwIFBJRDog
MSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTcuMC1yYzQtd2wtMDE1MzItZ2EyMjhh
MzIgIzE1OQpbICAgIDAuNDE5NTk5XSAgMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuNDE5NTk5
XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDExNDRmZTE4IGZmZmY4ODAwMTE0NGZlMTgg
ZmZmZmZmZmY4MjIzZWJhYSBmZmZmZmZmZjgyMjNlYmFhIGZmZmY4ODAwMTE0NGZlNTAgZmZm
Zjg4MDAxMTQ0ZmU1MAoKWyAgICAwLjQyMTgzOV0gIGZmZmZmZmZmODEwY2EzOTYKWyAgICAw
LjQyMTgzOV0gIGZmZmZmZmZmODEwY2EzOTYgZmZmZmZmZmY4MTE3MzA3YSBmZmZmZmZmZjgx
MTczMDdhIGZmZmZmZmZmODM1NjZmNDAgZmZmZmZmZmY4MzU2NmY0MCBmZmZmZmZmZjgzNjNm
NTQwIGZmZmZmZmZmODM2M2Y1NDAKClsgICAgMC40MjcyNjVdICBmZmZmZmZmZjgyYmNhODZk
ClsgICAgMC40MjcyNjVdICBmZmZmZmZmZjgyYmNhODZkIGZmZmZmZmZmODM3MWY5MTAgZmZm
ZmZmZmY4MzcxZjkxMCBmZmZmODgwMDExNDRmZTYwIGZmZmY4ODAwMTE0NGZlNjAgZmZmZmZm
ZmY4MTBjYTRlYSBmZmZmZmZmZjgxMGNhNGVhCgpbICAgIDAuNDMwMDIwXSBDYWxsIFRyYWNl
OgpbICAgIDAuNDMwMDIwXSBDYWxsIFRyYWNlOgpbICAgIDAuNDMwOTA0XSAgWzxmZmZmZmZm
ZjgyMjNlYmFhPl0gZHVtcF9zdGFjaysweDJlLzB4M2UKWyAgICAwLjQzMDkwNF0gIFs8ZmZm
ZmZmZmY4MjIzZWJhYT5dIGR1bXBfc3RhY2srMHgyZS8weDNlClsgICAgMC40MzI4NzBdICBb
PGZmZmZmZmZmODEwY2EzOTY+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDlkLzB4Y2IKWyAg
ICAwLjQzMjg3MF0gIFs8ZmZmZmZmZmY4MTBjYTM5Nj5dIHdhcm5fc2xvd3BhdGhfY29tbW9u
KzB4OWQvMHhjYgpbICAgIDAuNDM1MTI4XSAgWzxmZmZmZmZmZjgxMTczMDdhPl0gPyByZWdp
c3Rlcl90cmFjZXIrMHgxZTUvMHgzMDkKWyAgICAwLjQzNTEyOF0gIFs8ZmZmZmZmZmY4MTE3
MzA3YT5dID8gcmVnaXN0ZXJfdHJhY2VyKzB4MWU1LzB4MzA5ClsgICAgMC40NDAwNDhdICBb
PGZmZmZmZmZmODEwY2E0ZWE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyOC8weDMxClsgICAg
MC40NDAwNDhdICBbPGZmZmZmZmZmODEwY2E0ZWE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgy
OC8weDMxClsgICAgMC40NDIxNzRdICBbPGZmZmZmZmZmODExNzMwN2E+XSByZWdpc3Rlcl90
cmFjZXIrMHgxZTUvMHgzMDkKWyAgICAwLjQ0MjE3NF0gIFs8ZmZmZmZmZmY4MTE3MzA3YT5d
IHJlZ2lzdGVyX3RyYWNlcisweDFlNS8weDMwOQpbICAgIDAuNDQ0MTc4XSAgWzxmZmZmZmZm
ZjgzNjc3MWZkPl0gPyBpbml0X2dyYXBoX2RlYnVnZnMrMHg0Yi8weDRiClsgICAgMC40NDQx
NzhdICBbPGZmZmZmZmZmODM2NzcxZmQ+XSA/IGluaXRfZ3JhcGhfZGVidWdmcysweDRiLzB4
NGIKWyAgICAwLjQ0NjM5OV0gIFs8ZmZmZmZmZmY4MzY3NzI5OT5dIGluaXRfZ3JhcGhfdHJh
Y2UrMHg5Yy8weGE1ClsgICAgMC40NDYzOTldICBbPGZmZmZmZmZmODM2NzcyOTk+XSBpbml0
X2dyYXBoX3RyYWNlKzB4OWMvMHhhNQpbICAgIDAuNDQ4NDc0XSAgWzxmZmZmZmZmZjgzNjRm
OGVlPl0gZG9fb25lX2luaXRjYWxsKzB4MTgxLzB4MmI0ClsgICAgMC40NDg0NzRdICBbPGZm
ZmZmZmZmODM2NGY4ZWU+XSBkb19vbmVfaW5pdGNhbGwrMHgxODEvMHgyYjQKWyAgICAwLjQ1
MDA1MF0gIFs8ZmZmZmZmZmY4MzY0ZmJmNT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MWQ0
LzB4MmNhClsgICAgMC40NTAwNTBdICBbPGZmZmZmZmZmODM2NGZiZjU+XSBrZXJuZWxfaW5p
dF9mcmVlYWJsZSsweDFkNC8weDJjYQpbICAgIDAuNDUyMzAwXSAgWzxmZmZmZmZmZjgyMjMx
OWNjPl0gPyByZXN0X2luaXQrMHgxNTAvMHgxNTAKWyAgICAwLjQ1MjMwMF0gIFs8ZmZmZmZm
ZmY4MjIzMTljYz5dID8gcmVzdF9pbml0KzB4MTUwLzB4MTUwClsgICAgMC40NTQxMjRdICBb
PGZmZmZmZmZmODIyMzE5ZTE+XSBrZXJuZWxfaW5pdCsweDE1LzB4MTZlClsgICAgMC40NTQx
MjRdICBbPGZmZmZmZmZmODIyMzE5ZTE+XSBrZXJuZWxfaW5pdCsweDE1LzB4MTZlClsgICAg
MC40NTYwNDZdICBbPGZmZmZmZmZmODIyNTU2ZmE+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhi
MApbICAgIDAuNDU2MDQ2XSAgWzxmZmZmZmZmZjgyMjU1NmZhPl0gcmV0X2Zyb21fZm9yaysw
eDdhLzB4YjAKWyAgICAwLjQ1NzkxM10gIFs8ZmZmZmZmZmY4MjIzMTljYz5dID8gcmVzdF9p
bml0KzB4MTUwLzB4MTUwClsgICAgMC40NTc5MTNdICBbPGZmZmZmZmZmODIyMzE5Y2M+XSA/
IHJlc3RfaW5pdCsweDE1MC8weDE1MApbICAgIDAuNDYwMTQ1XSAtLS1bIGVuZCB0cmFjZSAw
MTg4YjUyZjE0ODJhYjI4IF0tLS0KWyAgICAwLjQ2MDE0NV0gLS0tWyBlbmQgdHJhY2UgMDE4
OGI1MmYxNDgyYWIyOCBdLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5
MjQvYTIyOGEzMjllMzVhODczOGZkNjUyODJkMzhkNmZiNWJkMDFmYzYxMi9kbWVzZy15b2N0
by1rYnVpbGQtMzI6MjAxNDA5MTAwOTQxMjY6eDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5
MjQ6My4xNy4wLXJjNC13bC0wMTUzMi1nYTIyOGEzMjoxNTkKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTEwMDkyNC9hMjI4YTMyOWUzNWE4NzM4ZmQ2NTI4MmQzOGQ2ZmI1YmQw
MWZjNjEyL2RtZXNnLXlvY3RvLWtidWlsZC04OjIwMTQwOTEwMDk0MTIwOng4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MTAwOTI0OjMuMTcuMC1yYzQtd2wtMDE1MzItZ2EyMjhhMzI6MTU5Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQvYTIyOGEzMjllMzVhODczOGZk
NjUyODJkMzhkNmZiNWJkMDFmYzYxMi9kbWVzZy15b2N0by1rYnVpbGQtMTU6MjAxNDA5MTAw
OTQxMjY6eDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQ6My4xNy4wLXJjNC13bC0wMTUz
Mi1nYTIyOGEzMjoxNTkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC9h
MjI4YTMyOWUzNWE4NzM4ZmQ2NTI4MmQzOGQ2ZmI1YmQwMWZjNjEyL2RtZXNnLXlvY3RvLWti
dWlsZC0xODoyMDE0MDkxMDA5NDEyNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNDoz
LjE3LjAtcmM0LXdsLTAxNTMyLWdhMjI4YTMyOjE1OQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MTAwOTI0L2EyMjhhMzI5ZTM1YTg3MzhmZDY1MjgyZDM4ZDZmYjViZDAxZmM2
MTIvZG1lc2ctdm0tdnAtcXVhbnRhbC14ODZfNjQtNjM6MjAxNDA5MTAxMDE2MDA6eDg2XzY0
LXJhbmRjb25maWctczEtMDkxMDA5MjQ6My4xNy4wLXJjNC13bC0wMTUzMi1nYTIyOGEzMjox
NTkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC9hMjI4YTMyOWUzNWE4
NzM4ZmQ2NTI4MmQzOGQ2ZmI1YmQwMWZjNjEyL2RtZXNnLXlvY3RvLWtidWlsZC0xOToyMDE0
MDkxMDA5NDExOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNDozLjE3LjAtcmM0LXds
LTAxNTMyLWdhMjI4YTMyOjE1OQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAw
OTI0L2EyMjhhMzI5ZTM1YTg3MzhmZDY1MjgyZDM4ZDZmYjViZDAxZmM2MTIvZG1lc2ctdm0t
dnAtcXVhbnRhbC14ODZfNjQtMjoyMDE0MDkxMDEwMTQ1MTp4ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTEwMDkyNDozLjE3LjAtcmM0LXdsLTAxNTMyLWdhMjI4YTMyOjE1OQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0L2EyMjhhMzI5ZTM1YTg3MzhmZDY1MjgyZDM4
ZDZmYjViZDAxZmM2MTIvZG1lc2ctcXVhbnRhbC1rYnVpbGQtOToyMDE0MDkxMDA5NDAxOTp4
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNDozLjE3LjAtcmM0LXdsLTAxNTMyLWdhMjI4
YTMyOjE1OQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0L2EyMjhhMzI5
ZTM1YTg3MzhmZDY1MjgyZDM4ZDZmYjViZDAxZmM2MTIvZG1lc2cteW9jdG8taXZiNDEtODM6
MjAxNDA5MTAwOTM0MjY6eDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQ6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0L2EyMjhhMzI5ZTM1YTg3MzhmZDY1Mjgy
ZDM4ZDZmYjViZDAxZmM2MTIvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTg6MjAxNDA5MTAwOTQw
MTE6eDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5MjQ6My4xNy4wLXJjNC13bC0wMTUzMi1n
YTIyOGEzMjoxNTkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC9hMjI4
YTMyOWUzNWE4NzM4ZmQ2NTI4MmQzOGQ2ZmI1YmQwMWZjNjEyL2RtZXNnLXlvY3RvLWtidWls
ZC02OjIwMTQwOTEwMDk0MTI2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjMuMTcu
MC1yYzQtd2wtMDE1MzItZ2EyMjhhMzI6MTU5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDkxMDA5MjQvYTIyOGEzMjllMzVhODczOGZkNjUyODJkMzhkNmZiNWJkMDFmYzYxMi9k
bWVzZy15b2N0by1rYnVpbGQtMjY6MjAxNDA5MTAwOTQxMjU6eDg2XzY0LXJhbmRjb25maWct
czEtMDkxMDA5MjQ6My4xNy4wLXJjNC13bC0wMTUzMi1nYTIyOGEzMjoxNTkKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC9hMjI4YTMyOWUzNWE4NzM4ZmQ2NTI4MmQz
OGQ2ZmI1YmQwMWZjNjEyL2RtZXNnLXlvY3RvLWtidWlsZC0yOjIwMTQwOTEwMDk0MTIxOng4
Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0OjMuMTcuMC1yYzQtd2wtMDE1MzItZ2EyMjhh
MzI6MTU5CjA6MTM6MTMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkhFQUQgaXMgbm93
IGF0IGEyMjhhMzIgMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQwOTEw
MDcnCgo9PT09PT09PT0gbGludXMvbWFzdGVyID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBv
c2l0aW9uIHdhcyBhMjI4YTMyLi4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJs
eS0yMDE0MDkxMDA3JwpIRUFEIGlzIG5vdyBhdCA2MTlkZjVkLi4uIE1lcmdlIHRhZyAnbWlj
cm9ibGF6ZS0zLjE3LXJjNScgb2YgZ2l0Oi8vZ2l0Lm1vbnN0ci5ldS9saW51eC0yLjYtbWlj
cm9ibGF6ZQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctczEtMDkxMDA5MjQvbGludXM6bWFzdGVyOjYxOWRmNWQyODcwYjgwNjk2ZmQzMjUy
MTM3NjU2MGUwYTQyMjNlNDQ6YmlzZWN0LWxpbnV4LTkKCjIwMTQtMDktMTAgMTE6MTY6Mjgg
NjE5ZGY1ZDI4NzBiODA2OTZmZDMyNTIxMzc2NTYwZTBhNDIyM2U0NCBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmIveDg2XzY0
LXJhbmRjb25maWctczEtMDkxMDA5MjQtNjE5ZGY1ZDI4NzBiODA2OTZmZDMyNTIxMzc2NTYw
ZTBhNDIyM2U0NApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDkxMDA5MjQvNjE5ZGY1ZDI4NzBiODA2OTZmZDMyNTIxMzc2NTYwZTBhNDIyM2U0
NAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
c25iL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0LTYxOWRmNWQyODcwYjgwNjk2ZmQz
MjUyMTM3NjU2MGUwYTQyMjNlNDQKG1sxOzM1bTIwMTQtMDktMTAgMTE6MjM6MjggTm8gYnVp
bGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2XzY0LXJhbmRj
b25maWctczEtMDkxMDA5MjQtNjE5ZGY1ZDI4NzBiODA2OTZmZDMyNTIxMzc2NTYwZTBhNDIy
M2U0NBtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTEwMDkyNC02MTlkZjVkMjg3MGI4MDY5NmZkMzI1MjEzNzY1NjBlMGE0MjIzZTQ0Cmtlcm5l
bDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC82MTlkZjVkMjg3MGI4
MDY5NmZkMzI1MjEzNzY1NjBlMGE0MjIzZTQ0L3ZtbGludXotMy4xNy4wLXJjNC0wMDE0Ni1n
NjE5ZGY1ZAoKMjAxNC0wOS0xMCAxMToyODoyOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4u
CTMyCTM0CTM2CTM3CTYwIFNVQ0NFU1MKCgo9PT09PT09PT0gbmV4dC9tYXN0ZXIgPT09PT09
PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDYxOWRmNWQuLi4gTWVyZ2UgdGFnICdt
aWNyb2JsYXplLTMuMTctcmM1JyBvZiBnaXQ6Ly9naXQubW9uc3RyLmV1L2xpbnV4LTIuNi1t
aWNyb2JsYXplCkhFQUQgaXMgbm93IGF0IGVjODZmMzQuLi4gQWRkIGxpbnV4LW5leHQgc3Bl
Y2lmaWMgZmlsZXMgZm9yIDIwMTQwOTA5CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC9uZXh0Om1hc3RlcjplYzg2ZjM0
YjI1MDY5NTU0MmRkMjYxZDVkZGRmM2UwMGJhZTRjYzFjOmJpc2VjdC1saW51eC05CgoyMDE0
LTA5LTEwIDExOjMzOjAyIGVjODZmMzRiMjUwNjk1NTQyZGQyNjFkNWRkZGYzZTAwYmFlNGNj
MWMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0LWVjODZmMzRiMjUwNjk1
NTQyZGQyNjFkNWRkZGYzZTAwYmFlNGNjMWMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0L2VjODZmMzRiMjUwNjk1NTQyZGQyNjFk
NWRkZGYzZTAwYmFlNGNjMWMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTEwMDkyNC1lYzg2
ZjM0YjI1MDY5NTU0MmRkMjYxZDVkZGRmM2UwMGJhZTRjYzFjChtbMTszNW0yMDE0LTA5LTEw
IDExOjU4OjAzIE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2Vy
dmVkL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MTAwOTI0LWVjODZmMzRiMjUwNjk1NTQyZGQy
NjFkNWRkZGYzZTAwYmFlNGNjMWMbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmItc21va2UveDg2XzY0
LXJhbmRjb25maWctczEtMDkxMDA5MjQtZWM4NmYzNGIyNTA2OTU1NDJkZDI2MWQ1ZGRkZjNl
MDBiYWU0Y2MxYwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkxMDA5
MjQvZWM4NmYzNGIyNTA2OTU1NDJkZDI2MWQ1ZGRkZjNlMDBiYWU0Y2MxYy92bWxpbnV6LTMu
MTcuMC1yYzQtbmV4dC0yMDE0MDkwOQoKMjAxNC0wOS0xMCAxMjowMjowMyBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAJNC4uCTMxCTQyCTQ2Lgk2MCBTVUNDRVNTCgo=

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.17.0-rc4-00002-g8735405"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.17.0-rc4 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
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
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
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
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_X86_16BIT is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
# CONFIG_KEXEC_VERIFY_SIG is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_DPM_WATCHDOG=y
CONFIG_DPM_WATCHDOG_TIMEOUT=12
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_PCIEAER is not set
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_ACPI_EXTLOG=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
CONFIG_NET_UDP_TUNNEL=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_VTI=y
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_LOG_COMMON=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_ZONES=y
# CONFIG_NF_CONNTRACK_PROCFS is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_H323=y
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_BROADCAST=y
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
CONFIG_NF_CONNTRACK_SNMP=y
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NF_CT_NETLINK_TIMEOUT=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_PROTO_DCCP=y
CONFIG_NF_NAT_PROTO_UDPLITE=y
CONFIG_NF_NAT_PROTO_SCTP=y
CONFIG_NF_NAT_AMANDA=y
CONFIG_NF_NAT_FTP=y
# CONFIG_NF_NAT_IRC is not set
CONFIG_NF_NAT_SIP=y
CONFIG_NF_NAT_TFTP=y
CONFIG_NETFILTER_SYNPROXY=y
CONFIG_NF_TABLES=y
# CONFIG_NF_TABLES_INET is not set
CONFIG_NFT_EXTHDR=y
CONFIG_NFT_META=y
CONFIG_NFT_CT=y
CONFIG_NFT_RBTREE=y
# CONFIG_NFT_HASH is not set
CONFIG_NFT_COUNTER=y
CONFIG_NFT_LOG=y
CONFIG_NFT_LIMIT=y
CONFIG_NFT_NAT=y
CONFIG_NFT_REJECT=y
CONFIG_NFT_COMPAT=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
CONFIG_NETFILTER_XT_TARGET_CT=y
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_HL=y
CONFIG_NETFILTER_XT_TARGET_HMARK=y
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NETMAP=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_REDIRECT=y
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
CONFIG_NETFILTER_XT_MATCH_BPF=y
CONFIG_NETFILTER_XT_MATCH_CGROUP=y
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPCOMP=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_IPVS=y
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=y
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
CONFIG_NETFILTER_XT_MATCH_U32=y
# CONFIG_IP_SET is not set
CONFIG_IP_VS=y
# CONFIG_IP_VS_IPV6 is not set
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
# CONFIG_IP_VS_WRR is not set
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=y
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
# CONFIG_IP_VS_FTP is not set
CONFIG_IP_VS_NFCT=y

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_LOG_ARP=y
CONFIG_NF_LOG_IPV4=y
# CONFIG_NF_TABLES_IPV4 is not set
# CONFIG_NF_TABLES_ARP is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_RPFILTER=y
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
# CONFIG_IP_NF_TARGET_REJECT is not set
CONFIG_IP_NF_TARGET_SYNPROXY=y
CONFIG_NF_NAT_IPV4=y
# CONFIG_IP_NF_TARGET_MASQUERADE is not set
# CONFIG_IP_NF_TARGET_NETMAP is not set
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_NF_NAT_SNMP_BASIC=y
# CONFIG_NF_NAT_PPTP is not set
CONFIG_NF_NAT_H323=y
# CONFIG_IP_NF_MANGLE is not set
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_CHAIN_ROUTE_IPV6=y
# CONFIG_NFT_CHAIN_NAT_IPV6 is not set
CONFIG_NFT_REJECT_IPV6=y
CONFIG_NF_LOG_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_AH=y
CONFIG_IP6_NF_MATCH_EUI64=y
CONFIG_IP6_NF_MATCH_FRAG=y
CONFIG_IP6_NF_MATCH_OPTS=y
CONFIG_IP6_NF_MATCH_HL=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_MATCH_MH=y
CONFIG_IP6_NF_MATCH_RPFILTER=y
CONFIG_IP6_NF_MATCH_RT=y
CONFIG_IP6_NF_TARGET_HL=y
# CONFIG_IP6_NF_FILTER is not set
# CONFIG_IP6_NF_TARGET_SYNPROXY is not set
CONFIG_IP6_NF_MANGLE=y
# CONFIG_IP6_NF_RAW is not set
CONFIG_NF_NAT_IPV6=y
# CONFIG_IP6_NF_TARGET_MASQUERADE is not set
# CONFIG_IP6_NF_TARGET_NPT is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_TIPC_MEDIA_IB is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
# CONFIG_L2TP_IP is not set
CONFIG_L2TP_ETH=y
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_6LOWPAN is not set
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=y
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
# CONFIG_BAYCOM_PAR is not set
CONFIG_YAM=y
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=y
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
CONFIG_VLSI_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIDTL1=y
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=y
CONFIG_BT_WILINK=y
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=y
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_TRF7970A=y
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_PN544 is not set
CONFIG_NFC_MICROREAD=y
CONFIG_NFC_MICROREAD_I2C=y
CONFIG_NFC_ST21NFCA=y
# CONFIG_NFC_ST21NFCA_I2C is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_FENCE_TRACE=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_PCI=y
CONFIG_MTD_PCMCIA=y
CONFIG_MTD_PCMCIA_ANONYMOUS=y
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
CONFIG_MTD_DATAFLASH_OTP=y
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=y
# CONFIG_MTD_NAND_DENALI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Bus Driver
#
CONFIG_INTEL_MIC_BUS=y

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=y
CONFIG_NET_TEAM=y
# CONFIG_NET_TEAM_MODE_BROADCAST is not set
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
# CONFIG_NET_TEAM_MODE_RANDOM is not set
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
# CONFIG_VXLAN is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_NTB_NETDEV=y
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
# CONFIG_TUN is not set
CONFIG_VETH=y
# CONFIG_VIRTIO_NET is not set
CONFIG_NLMON=y
CONFIG_SUNGEM_PHY=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_PCI is not set
CONFIG_ARCNET_COM20020_CS=y
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_TCP=y
CONFIG_ATM_LANAI=y
# CONFIG_ATM_ENI is not set
CONFIG_ATM_FIRESTREAM=y
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=y
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=y
# CONFIG_ATM_HORIZON_DEBUG is not set
# CONFIG_ATM_IA is not set
CONFIG_ATM_FORE200E=y
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
# CONFIG_ATM_HE is not set
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_3C589=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_XGENE is not set
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
# CONFIG_ATL1E is not set
CONFIG_ATL1C=y
CONFIG_ALX=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
CONFIG_TIGON3=y
CONFIG_BNX2X=y
CONFIG_BNX2X_SRIOV=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_CX_ECAT=y
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
# CONFIG_KS8851 is not set
CONFIG_KS8851_MLL=y
CONFIG_KSZ884X_PCI=y
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_ENC28J60=y
CONFIG_ENC28J60_WRITEVERIFY=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=y
CONFIG_NE2K_PCI=y
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
CONFIG_SIS190=y
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
# CONFIG_EPIC100 is not set
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
CONFIG_SMSC9420=y
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
# CONFIG_STMMAC_PLATFORM is not set
# CONFIG_STMMAC_PCI is not set
# CONFIG_STMMAC_DEBUG_FS is not set
CONFIG_STMMAC_DA=y
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
# CONFIG_CASSINI is not set
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MICREL_KS8995MA=y
CONFIG_PLIP=y
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
# CONFIG_PPPOE is not set
# CONFIG_PPPOL2TP is not set
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# Host-side USB support is needed for USB Network Adapter support
#
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_SERIAL_WACOM4=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
# CONFIG_TOUCHSCREEN_CYTTSP4_SPI is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZFORCE=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
# CONFIG_SERIAL_8250_DMA is not set
# CONFIG_SERIAL_8250_PCI is not set
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MRST_MAX3110 is not set
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_SC16IS7XX is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_SERIAL_MEN_Z135=y
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
# CONFIG_MWAVE is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
CONFIG_TCG_ST33_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=y
# CONFIG_ACPI_I2C_OPREGION is not set
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
CONFIG_SPI_DW_MID_DMA=y
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2406=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_88PM860X is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_CHARGER_TPS65090=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_TPS40422=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=y
CONFIG_ACPI_INT3403_THERMAL=y
CONFIG_INTEL_SOC_DTS_THERMAL=y

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC is not set
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_AB3100=y
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
# CONFIG_REGULATOR_DA9063 is not set
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_DA9211 is not set
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LTC3589=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8998=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_S2MPA01 is not set
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
# CONFIG_LIRC is not set
# CONFIG_IR_NEC_DECODER is not set
# CONFIG_IR_RC5_DECODER is not set
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
# CONFIG_IR_SONY_DECODER is not set
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_SHARP_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
CONFIG_IR_XMP_DECODER=y
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=y
CONFIG_VIDEO_MEM2MEM_TESTDEV=y

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
CONFIG_RADIO_SI470X=y
# CONFIG_I2C_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
CONFIG_RADIO_MAXIRADIO=y
CONFIG_RADIO_TEA5764=y
CONFIG_RADIO_TEA5764_XTAL=y
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_RADIO_WL128X=y

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
CONFIG_DVB_FIREDTV_INPUT=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

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
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_PTN3460 is not set
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_SM501=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630A=y
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_PANDORA=y
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_AS3711 is not set
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_HDMI=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO=y
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
# CONFIG_UWB_WHCI is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_USDHI6ROL0=y
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
# CONFIG_INFINIBAND_QIB is not set
CONFIG_INFINIBAND_AMSO1100=y
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_MLX5_INFINIBAND is not set
CONFIG_INFINIBAND_NES=y
# CONFIG_INFINIBAND_NES_DEBUG is not set
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
# CONFIG_INFINIBAND_IPOIB_DEBUG is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82975X=y
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_IE31200 is not set
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MIC_X100_DMA=y
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
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
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
CONFIG_ALIENWARE_WMI=y
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_LAPTOP=y
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
CONFIG_DELL_SMO8800=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
CONFIG_HP_ACCEL=y
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=y
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_COMPAL_LAPTOP is not set
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_TOSHIBA_HAPS=y
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
# CONFIG_INTEL_OAKTRAIL is not set
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

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
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_MAX77693=y
# CONFIG_EXTCON_SM5502 is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LPSS is not set
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_ST_SPEAR1310_MIPHY=y
CONFIG_PHY_ST_SPEAR1340_MIPHY=y
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y
CONFIG_RAS=y
CONFIG_THUNDERBOLT=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set
# CONFIG_EFI_RUNTIME_MAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CEPH_FS=y
CONFIG_CEPH_FSCACHE=y
CONFIG_CEPH_FS_POSIX_ACL=y
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_UPCALL=y
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SMB2 is not set
CONFIG_CIFS_FSCACHE=y
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
# CONFIG_9P_FSCACHE is not set
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
CONFIG_MMIOTRACE=y
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_TEST_RHASHTABLE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_UDELAY=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_EFI is not set
CONFIG_X86_PTDUMP=y
CONFIG_EFI_PGT_DUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
# CONFIG_CRYPTO_DRBG_HMAC is not set
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=y
CONFIG_CRYPTO_DEV_QAT=y
CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
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
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--rwEMma7ioTxnRzrJ--
