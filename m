Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757AbaLKE7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:59:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:59677 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933739AbaLKE7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:59:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="427633012"
Date: Wed, 10 Dec 2014 20:59:27 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [kprobes] WARNING: at kernel/trace/trace_kprobe.c:1393
 kprobe_trace_self_tests_init()
Message-ID: <20141211045927.GA6145@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

commit 003002e04ed38618fc37b92ba128f5ca79d39f4f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed Jun 5 12:12:16 2013 +0900
Commit:     Ingo Molnar <mingo@kernel.org>
CommitDate: Thu Jun 20 14:25:48 2013 +0200

    kprobes: Fix arch_prepare_kprobe to handle copy insn failures
    
    Fix arch_prepare_kprobe() to handle failures in copy instruction
    correctly. This fix is related to the previous fix: 8101376
    which made __copy_instruction return an error result if failed,
    but caller site was not updated to handle it. Thus, this is the
    other half of the bugfix.
    
    This fix is also related to the following bug-report:
    
       https://bugzilla.redhat.com/show_bug.cgi?id=910649
    
    Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Acked-by: Steven Rostedt <rostedt@goodmis.org>
    Tested-by: Jonathan Lebon <jlebon@redhat.com>
    Cc: Frank Ch. Eigler <fche@redhat.com>
    Cc: systemtap@sourceware.org
    Cc: yrl.pp-manager.tt@hitachi.com
    Link: http://lkml.kernel.org/r/20130605031216.15285.2001.stgit@mhiramat-M0-7522
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

+------------------------------------------------------------------------+------------+------------+--------------+
|                                                                        | f1a527899e | 003002e04e | v3.18_121022 |
+------------------------------------------------------------------------+------------+------------+--------------+
| boot_successes                                                         | 60         | 0          | 0            |
| boot_failures                                                          | 0          | 20         | 12           |
| WARNING:at_kernel/trace/trace_kprobe.c:#kprobe_trace_self_tests_init() | 0          | 20         | 12           |
| backtrace:kprobe_trace_self_tests_init                                 | 0          | 20         | 12           |
| backtrace:warn_slowpath_null                                           | 0          | 20         | 12           |
| backtrace:kernel_init_freeable                                         | 0          | 20         | 12           |
+------------------------------------------------------------------------+------------+------------+--------------+

[    9.302086] Testing kprobe tracing: 
[    9.304225] Could not insert probe at kprobe_trace_selftest_target+0: -22
[    9.305509] ------------[ cut here ]------------
[    9.306204] WARNING: at kernel/trace/trace_kprobe.c:1393 kprobe_trace_self_tests_init+0x69/0x7f0()
[    9.307812] Modules linked in:
[    9.308313] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc3-00005-g003002e #25
[    9.309436] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    9.311039]  0000000000000009 ffff880013445e78 ffffffff814c1621 ffff880013445eb0
[    9.312241]  ffffffff81078a3c ffffffff81c84624 0000000000000007 0000000000000000
[    9.313388]  0000000000000000 0000000000000000 ffff880013445ec0 ffffffff81078a95
[    9.314561] Call Trace:
[    9.314933]  [<ffffffff814c1621>] dump_stack+0x27/0x30
[    9.315799]  [<ffffffff81078a3c>] warn_slowpath_common+0x8c/0xc0
[    9.316793]  [<ffffffff81c84624>] ? init_kprobe_trace+0xe8/0xe8
[    9.317665]  [<ffffffff81078a95>] warn_slowpath_null+0x25/0x30
[    9.318480]  [<ffffffff81c8468d>] kprobe_trace_self_tests_init+0x69/0x7f0
[    9.319385]  [<ffffffff81c84624>] ? init_kprobe_trace+0xe8/0xe8
[    9.320256]  [<ffffffff810021aa>] do_one_initcall+0x1aa/0x260
[    9.321092]  [<ffffffff81c605e9>] kernel_init_freeable+0x23d/0x327
[    9.322026]  [<ffffffff814b2010>] ? rest_init+0x230/0x230
[    9.322845]  [<ffffffff814b2021>] kernel_init+0x11/0x240
[    9.323674]  [<ffffffff814d757a>] ret_from_fork+0x7a/0xb0
[    9.324509]  [<ffffffff814b2010>] ? rest_init+0x230/0x230
[    9.325230] ---[ end trace d5b21dab2503848a ]---
[    9.325955] error on probing function entry.

git bisect start v3.10 v3.9 --
git bisect good ff89acc563a0bd49965674f56552ad6620415fe2  # 06:44     20+     21  Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu
git bisect good e4327859341f2d3a93b4b6fef2ea483eac1c270c  # 06:56     20+      0  Merge branch 'for-3.10' of git://git.samba.org/sfrench/cifs-2.6
git bisect good 2601ded7fd8827ddbcc450cbfb153b3f3c59b443  # 07:08     20+      0  Merge tag 'sound-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good 9e895ace5d82df8929b16f58e9f515f6d54ab82d  # 07:12     20+      0  Linux 3.10-rc7
git bisect  bad 1a506e473576cdcb922d339aea76b67d0fe344f7  # 07:16      0-      3  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
git bisect good 78750f1908869c3bfcbf2a1f1f00f078f2948271  # 07:33     20+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
git bisect  bad 54faf77d065926adbcc2a49e6df3559094cc93ba  # 07:39      0-      7  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good de6e1317f746fbc527a73976c58b4119e506ff7c  # 07:59     20+      0  Merge tag 'critical_fix_for_3.9' of git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe
git bisect good e3ff91143eb2a6eaaab4831c85a2837a95fbbea3  # 08:11     20+      0  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm
git bisect  bad 8b4d801b2b123b6c09742f861fe44a8527b84d47  # 08:29      0-      1  hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
git bisect  bad 003002e04ed38618fc37b92ba128f5ca79d39f4f  # 08:38      0-     20  kprobes: Fix arch_prepare_kprobe to handle copy insn failures
# first bad commit: [003002e04ed38618fc37b92ba128f5ca79d39f4f] kprobes: Fix arch_prepare_kprobe to handle copy insn failures
git bisect good f1a527899ef0a8a241eb3bea619eb2e29d797f44  # 09:07     60+      0  perf/x86: Fix broken PEBS-LL support on SNB-EP/IVB-EP
# extra tests on HEAD of linux-devel/devel-hourly-2014121022
git bisect  bad 876ed1468bfdd84f401fb63a0e76a3619665fa28  # 09:07      0-     12  0day head guard for 'devel-hourly-2014121022'
# extra tests on tree/branch linus/master
git bisect  bad 3a5dc1fafb016560315fe45bb4ef8bde259dd1bc  # 09:07      0-     24  Merge branch 'x86-microcode-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
# extra tests on tree/branch linus/master
git bisect  bad 3a5dc1fafb016560315fe45bb4ef8bde259dd1bc  # 09:07      0-     24  Merge branch 'x86-microcode-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
# extra tests on tree/branch next/master
git bisect  bad 12fd07251e19050ca979d9ce5d4b6bcb41dc00e9  # 09:07      0-     24  Add linux-next specific files for 20141210


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

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-client9-40:20141211083739:x86_64-randconfig-ib0-12061218:3.10.0-rc3-00005-g003002e:25"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc3-00005-g003002e (kbuild@lkp-ib04) (g=
cc version 4.9.1 (Debian 4.9.1-19) ) #25 Thu Dec 11 08:33:00 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ib0-12061218/linux-devel:devel-hourly-2014121022:003002e04ed38618fc37b=
92ba128f5ca79d39f4f:bisect-linux-1/.vmlinuz-003002e04ed38618fc37b92ba128f5c=
a79d39f4f-20141211083609-15-client9 branch=3Dlinux-devel/devel-hourly-20141=
21022 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-12061218/003002e04ed38618f=
c37b92ba128f5ca79d39f4f/vmlinuz-3.10.0-rc3-00005-g003002e drbd.minor_count=
=3D8
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
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at =
[ffff8800000f0ed0]
[    0.000000]   mpc: f0ee0-f0fb0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0286f000, 0x0286ffff] PGTABLE
[    0.000000] BRK [0x02870000, 0x02870fff] PGTABLE
[    0.000000] BRK [0x02871000, 0x02871fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x02872000, 0x02872fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x02873000, 0x02873fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
[    0.000000]  [mem 0x13c00000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x13cce000-0x13fd7fff]
[    0.000000] ACPI: RSDP 00000000000f0cf0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013fe1854 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013fe0b37 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013fe0040 00AF7 (v01 BOCHS  BXPCDSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACS 0000000013fe0000 00040
[    0.000000] ACPI: SSDT 0000000013fe0bab 00BF9 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fe17a4 00078 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fe181c 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012c0000=
0-ffff8800131fffff] on node 0
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
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1a5eb80
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
-randconfig-ib0-12061218/linux-devel:devel-hourly-2014121022:003002e04ed386=
18fc37b92ba128f5ca79d39f4f:bisect-linux-1/.vmlinuz-003002e04ed38618fc37b92b=
a128f5ca79d39f4f-20141211083609-15-client9 branch=3Dlinux-devel/devel-hourl=
y-2014121022 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-12061218/003002e04e=
d38618fc37b92ba128f5ca79d39f4f/vmlinuz-3.10.0-rc3-00005-g003002e drbd.minor=
_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 290732k/327552k available (4964k kernel code, 392k a=
bsent, 36428k reserved, 7689k data, 848k init)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc3-00005-g003002e (kbuild@lkp-ib04) (g=
cc version 4.9.1 (Debian 4.9.1-19) ) #25 Thu Dec 11 08:33:00 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ib0-12061218/linux-devel:devel-hourly-2014121022:003002e04ed38618fc37b=
92ba128f5ca79d39f4f:bisect-linux-1/.vmlinuz-003002e04ed38618fc37b92ba128f5c=
a79d39f4f-20141211083609-15-client9 branch=3Dlinux-devel/devel-hourly-20141=
21022 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-12061218/003002e04ed38618f=
c37b92ba128f5ca79d39f4f/vmlinuz-3.10.0-rc3-00005-g003002e drbd.minor_count=
=3D8
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
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at =
[ffff8800000f0ed0]
[    0.000000]   mpc: f0ee0-f0fb0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0286f000, 0x0286ffff] PGTABLE
[    0.000000] BRK [0x02870000, 0x02870fff] PGTABLE
[    0.000000] BRK [0x02871000, 0x02871fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x02872000, 0x02872fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x02873000, 0x02873fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
[    0.000000]  [mem 0x13c00000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x13cce000-0x13fd7fff]
[    0.000000] ACPI: RSDP 00000000000f0cf0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013fe1854 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013fe0b37 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013fe0040 00AF7 (v01 BOCHS  BXPCDSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACS 0000000013fe0000 00040
[    0.000000] ACPI: SSDT 0000000013fe0bab 00BF9 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fe17a4 00078 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fe181c 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012c0000=
0-ffff8800131fffff] on node 0
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
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1a5eb80
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
-randconfig-ib0-12061218/linux-devel:devel-hourly-2014121022:003002e04ed386=
18fc37b92ba128f5ca79d39f4f:bisect-linux-1/.vmlinuz-003002e04ed38618fc37b92b=
a128f5ca79d39f4f-20141211083609-15-client9 branch=3Dlinux-devel/devel-hourl=
y-2014121022 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-12061218/003002e04e=
d38618fc37b92ba128f5ca79d39f4f/vmlinuz-3.10.0-rc3-00005-g003002e drbd.minor=
_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 290732k/327552k available (4964k kernel code, 392k a=
bsent, 36428k reserved, 7689k data, 848k init)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2925.996 MHz processor
[    0.000000] tsc: Detected 2925.996 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value..=20
[    0.008000] Calibrating delay loop (skipped) preset value.. 5851.99 Bogo=
MIPS (lpj=3D11703984)
5851.99 BogoMIPS (lpj=3D11703984)
[    0.012010] pid_max: default: 4096 minimum: 301
[    0.012010] pid_max: default: 4096 minimum: 301
[    0.016097] Mount-cache hash table entries: 256
[    0.016097] Mount-cache hash table entries: 256
[    0.018180] Initializing cgroup subsys devices
[    0.018180] Initializing cgroup subsys devices
[    0.020200] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020200] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020200] tlb_flushall_shift: 6
[    0.020200] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020200] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020200] tlb_flushall_shift: 6
[    0.024014] CPU:=20
[    0.024014] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.040587] ACPI: Core revision 20130328
[    0.040587] ACPI: Core revision 20130328
[    0.056524] ACPI:=20
[    0.056524] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.058155] Performance Events:=20
[    0.058155] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.064358] ftrace: Allocated trace_printk buffers
[    0.064358] ftrace: Allocated trace_printk buffers
[    0.072485] Testing tracer nop:=20
[    0.072485] Testing tracer nop: PASSED
PASSED
[    0.075053] Getting VERSION: 1050014
[    0.075053] Getting VERSION: 1050014
[    0.076020] Getting VERSION: 1050014
[    0.076020] Getting VERSION: 1050014
[    0.077030] Getting ID: 0
[    0.077030] Getting ID: 0
[    0.077662] Getting ID: ff000000
[    0.077662] Getting ID: ff000000
[    0.080021] Getting LVT0: 8700
[    0.080021] Getting LVT0: 8700
[    0.080795] Getting LVT1: 8400
[    0.080795] Getting LVT1: 8400
[    0.084076] enabled ExtINT on CPU#0
[    0.084076] enabled ExtINT on CPU#0
[    0.087340] ENABLING IO-APIC IRQs
[    0.087340] ENABLING IO-APIC IRQs
[    0.088013] init IO_APIC IRQs
[    0.088013] init IO_APIC IRQs
[    0.092012]  apic 0 pin 0 not connected
[    0.092012]  apic 0 pin 0 not connected
[    0.093876] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.093876] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.095632] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.095632] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.096047] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.096047] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.100043] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.100043] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.104044] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.104044] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.106321] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.106321] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.108041] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.108041] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.112034] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.112034] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.114039] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.114039] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.116042] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.116042] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.118322] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.118322] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.120000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.120000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.120000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.120000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.120038] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.120038] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.122184] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.122184] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.124035] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.124035] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.126521]  apic 0 pin 16 not connected
[    0.126521]  apic 0 pin 16 not connected
[    0.128012]  apic 0 pin 17 not connected
[    0.128012]  apic 0 pin 17 not connected
[    0.129063]  apic 0 pin 18 not connected
[    0.129063]  apic 0 pin 18 not connected
[    0.130061]  apic 0 pin 19 not connected
[    0.130061]  apic 0 pin 19 not connected
[    0.132006]  apic 0 pin 20 not connected
[    0.132006]  apic 0 pin 20 not connected
[    0.133165]  apic 0 pin 21 not connected
[    0.133165]  apic 0 pin 21 not connected
[    0.134366]  apic 0 pin 22 not connected
[    0.134366]  apic 0 pin 22 not connected
[    0.136006]  apic 0 pin 23 not connected
[    0.136006]  apic 0 pin 23 not connected
[    0.137267] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.137267] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.138929] Using local APIC timer interrupts.
[    0.138929] calibrating APIC timer ...
[    0.138929] Using local APIC timer interrupts.
[    0.138929] calibrating APIC timer ...
[    0.144000] ... lapic delta =3D 13497246
[    0.144000] ... lapic delta =3D 13497246
[    0.144000] ... PM-Timer delta =3D 773021
[    0.144000] ... PM-Timer delta =3D 773021
[    0.144000] APIC calibration not consistent with PM-Timer: 215ms instead=
 of 100ms
[    0.144000] APIC calibration not consistent with PM-Timer: 215ms instead=
 of 100ms
[    0.144000] APIC delta adjusted to PM-Timer: 6250015 (13497246)
[    0.144000] APIC delta adjusted to PM-Timer: 6250015 (13497246)
[    0.144000] TSC delta adjusted to PM-Timer: 292599391 (631884193)
[    0.144000] TSC delta adjusted to PM-Timer: 292599391 (631884193)
[    0.144000] ..... delta 6250015
[    0.144000] ..... delta 6250015
[    0.144000] ..... mult: 268436100
[    0.144000] ..... mult: 268436100
[    0.144000] ..... calibration result: 4000009
[    0.144000] ..... calibration result: 4000009
[    0.144000] ..... CPU clock speed is 2925.3975 MHz.
[    0.144000] ..... CPU clock speed is 2925.3975 MHz.
[    0.144000] ..... host bus clock speed is 1000.0009 MHz.
[    0.144000] ..... host bus clock speed is 1000.0009 MHz.
[    0.144950] devtmpfs: initialized
[    0.144950] devtmpfs: initialized
[    0.150135] Testing tracer branch:=20
[    0.150135] Testing tracer branch: PASSED
PASSED
[    0.260478] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.260478] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.262756] regulator-dummy: no parameters
[    0.262756] regulator-dummy: no parameters
[    0.264150] NET: Registered protocol family 16
[    0.264150] NET: Registered protocol family 16
[    0.268551] ACPI: bus type PCI registered
[    0.268551] ACPI: bus type PCI registered
[    0.269709] PCI: Using configuration type 1 for base access
[    0.269709] PCI: Using configuration type 1 for base access
[    0.282425] ACPI: Added _OSI(Module Device)
[    0.282425] ACPI: Added _OSI(Module Device)
[    0.283645] ACPI: Added _OSI(Processor Device)
[    0.283645] ACPI: Added _OSI(Processor Device)
[    0.284013] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.284013] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.288019] ACPI: Added _OSI(Processor Aggregator Device)
[    0.288019] ACPI: Added _OSI(Processor Aggregator Device)
[    0.294852] ACPI: EC: Look up EC in DSDT
[    0.294852] ACPI: EC: Look up EC in DSDT
[    0.307259] ACPI: Interpreter enabled
[    0.307259] ACPI: Interpreter enabled
[    0.308015] ACPI Exception: AE_NOT_FOUND,=20
[    0.308015] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
 (20130328/hwxface-568)
[    0.310528] ACPI Exception: AE_NOT_FOUND,=20
[    0.310528] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
 (20130328/hwxface-568)
[    0.313532] ACPI: (supports S0 S3 S5)
[    0.313532] ACPI: (supports S0 S3 S5)
[    0.314389] ACPI: Using IOAPIC for interrupt routing
[    0.314389] ACPI: Using IOAPIC for interrupt routing
[    0.315765] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.315765] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.343134] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.343134] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.344880] PCI host bridge to bus 0000:00
[    0.344880] PCI host bridge to bus 0000:00
[    0.345846] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.345846] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.348012] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.348012] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.349588] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.349588] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.351204] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.351204] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.352011] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.352011] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.353545] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.353545] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.356012] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.356012] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.357676] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.357676] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.360125] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.360125] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.362240] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.362240] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.364589] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.364589] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.369076] pci 0000:00:01.1: reg 20: [io  0xc040-0xc04f]
[    0.369076] pci 0000:00:01.1: reg 20: [io  0xc040-0xc04f]
[    0.372654] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.372654] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.374667] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.374667] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.376021] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.376021] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.378222] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.378222] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.381374] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.381374] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.384648] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.384648] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.392013] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.392013] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.396408] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.396408] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.401223] pci 0000:00:03.0: reg 10: [mem 0xfebc0000-0xfebdffff]
[    0.401223] pci 0000:00:03.0: reg 10: [mem 0xfebc0000-0xfebdffff]
[    0.404545] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.404545] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.416015] pci 0000:00:03.0: reg 30: [mem 0xfeb80000-0xfebbffff pref]
[    0.416015] pci 0000:00:03.0: reg 30: [mem 0xfeb80000-0xfebbffff pref]
[    0.417913] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.417913] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.420007] pci 0000:00:04.0: reg 10: [mem 0xfebf1000-0xfebf100f]
[    0.420007] pci 0000:00:04.0: reg 10: [mem 0xfebf1000-0xfebf100f]
[    0.430587] pci_bus 0000:00: on NUMA node 0
[    0.430587] pci_bus 0000:00: on NUMA node 0
[    0.431628] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.431628] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.436052] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.436052] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.437969] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.437969] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.439925] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.439925] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.440846] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.440846] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.442650] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.442650] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.444966] ACPI:=20
[    0.444966] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.448031] acpi root: \_SB_.PCI0 notify handler is installed
[    0.448031] acpi root: \_SB_.PCI0 notify handler is installed
[    0.449631] Found 1 acpi root devices
[    0.449631] Found 1 acpi root devices
[    0.451261] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.451261] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.452008] vgaarb: loaded
[    0.452008] vgaarb: loaded
[    0.452638] vgaarb: bridge control possible 0000:00:02.0
[    0.452638] vgaarb: bridge control possible 0000:00:02.0
[    0.456201] PCI: Using ACPI for IRQ routing
[    0.456201] PCI: Using ACPI for IRQ routing
[    0.457688] PCI: pci_cache_line_size set to 64 bytes
[    0.457688] PCI: pci_cache_line_size set to 64 bytes
[    0.459034] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.459034] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.460030] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.460030] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.462505] Switching to clocksource kvm-clock
[    0.462505] Switching to clocksource kvm-clock
[    0.464771] Warning: could not register annotated branches stats
[    0.464771] Warning: could not register annotated branches stats
[    0.531623] FS-Cache: Loaded
[    0.531623] FS-Cache: Loaded
[    0.532455] pnp: PnP ACPI init
[    0.532455] pnp: PnP ACPI init
[    0.533269] ACPI: bus type PNP registered
[    0.533269] ACPI: bus type PNP registered
[    0.534327] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.534327] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.536366] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.536366] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.538090] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.538090] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.558251] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.558251] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.559977] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.559977] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.562090] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.562090] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.563946] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.563946] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.565888] pnp 00:03: [dma 2]
[    0.565888] pnp 00:03: [dma 2]
[    0.583768] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.583768] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.585837] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.585837] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.587793] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.587793] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.589499] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.589499] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.591536] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.591536] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.594014] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.594014] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.596603] pnp 00:07: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.596603] pnp 00:07: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.611361] pnp: PnP ACPI: found 8 devices
[    0.611361] pnp: PnP ACPI: found 8 devices
[    0.612371] ACPI: bus type PNP unregistered
[    0.612371] ACPI: bus type PNP unregistered
[    0.619405] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.619405] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.620739] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.620739] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.622050] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.622050] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.636451] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.636451] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.637810] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.637810] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.639136] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.639136] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.640719] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.640719] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.642380] NET: Registered protocol family 1
[    0.642380] NET: Registered protocol family 1
[    0.643451] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.643451] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.644871] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.644871] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.646254] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.646254] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.647820] pci 0000:00:02.0: Boot video device
[    0.647820] pci 0000:00:02.0: Boot video device
[    0.662048] PCI: CLS 0 bytes, default 64
[    0.662048] PCI: CLS 0 bytes, default 64
[    0.663628] Unpacking initramfs...
[    0.663628] Unpacking initramfs...
[    0.935559] debug: unmapping init [mem 0xffff880013cce000-0xffff880013fd=
7fff]
[    0.935559] debug: unmapping init [mem 0xffff880013cce000-0xffff880013fd=
7fff]
[    0.937945] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.937945] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.939582] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.939582] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.951820] AVX instructions are not detected.
[    0.951820] AVX instructions are not detected.
[    0.953530] Initialise module verification
[    0.953530] Initialise module verification
[    1.051642] VFS: Disk quotas dquot_6.5.2
[    1.051642] VFS: Disk quotas dquot_6.5.2
[    1.052601] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.052601] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.054300] msgmni has been set to 567
[    1.054300] msgmni has been set to 567
[    1.076360] Key type asymmetric registered
[    1.076360] Key type asymmetric registered
[    1.077406] Asymmetric key parser 'x509' registered
[    1.077406] Asymmetric key parser 'x509' registered
[    1.095975] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.095975] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.097220] crc32: self tests passed, processed 225944 bytes in 192113 n=
sec
[    1.097220] crc32: self tests passed, processed 225944 bytes in 192113 n=
sec
[    1.099196] crc32c: CRC_LE_BITS =3D 64
[    1.099196] crc32c: CRC_LE_BITS =3D 64
[    1.100107] crc32c: self tests passed, processed 225944 bytes in 97480 n=
sec
[    1.100107] crc32c: self tests passed, processed 225944 bytes in 97480 n=
sec
[    1.102214] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.102214] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.104071] ACPI: Power Button [PWRF]
[    1.104071] ACPI: Power Button [PWRF]
[    1.217007] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.217007] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.276356] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.276356] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.279788] dummy-irq: no IRQ given.  Use irq=3DN
[    1.279788] dummy-irq: no IRQ given.  Use irq=3DN
[    1.281109] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.281109] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.284389] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.284389] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.285688] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.285688] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.289289] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.289289] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.304595] Driver for 1-wire Dallas network protocol.
[    1.304595] Driver for 1-wire Dallas network protocol.
[    1.306150] power_supply test_ac: uevent
[    1.306150] power_supply test_ac: uevent
[    1.307201] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    1.307201] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    1.308620] power_supply test_ac: prop ONLINE=3D1
[    1.308620] power_supply test_ac: prop ONLINE=3D1
[    1.309829] power_supply test_ac: power_supply_changed
[    1.309829] power_supply test_ac: power_supply_changed
[    1.311239] power_supply test_battery: uevent
[    1.311239] power_supply test_battery: uevent
[    1.312375] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    1.312375] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    1.338100] power_supply test_battery: prop STATUS=3DDischarging
[    1.338100] power_supply test_battery: prop STATUS=3DDischarging
[    1.339565] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    1.339565] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    1.340918] power_supply test_battery: prop HEALTH=3DGood
[    1.340918] power_supply test_battery: prop HEALTH=3DGood
[    1.342120] power_supply test_battery: prop PRESENT=3D1
[    1.342120] power_supply test_battery: prop PRESENT=3D1
[    1.343273] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    1.343273] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    1.344665] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    1.344665] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    1.357366] power_supply test_battery: prop CHARGE_FULL=3D100
[    1.357366] power_supply test_battery: prop CHARGE_FULL=3D100
[    1.358654] power_supply test_battery: prop CHARGE_NOW=3D50
[    1.358654] power_supply test_battery: prop CHARGE_NOW=3D50
[    1.359935] power_supply test_battery: prop CAPACITY=3D50
[    1.359935] power_supply test_battery: prop CAPACITY=3D50
[    1.361237] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    1.361237] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    1.362737] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    1.362737] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    1.364167] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    1.364167] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    1.365646] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    1.365646] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    1.372362] power_supply test_battery: prop MANUFACTURER=3DLinux
[    1.372362] power_supply test_battery: prop MANUFACTURER=3DLinux
[    1.373848] power_supply test_battery: prop SERIAL_NUMBER=3D3.10.0-rc3-0=
0005-g003002e
[    1.373848] power_supply test_battery: prop SERIAL_NUMBER=3D3.10.0-rc3-0=
0005-g003002e
[    1.375787] power_supply test_battery: prop TEMP=3D26
[    1.375787] power_supply test_battery: prop TEMP=3D26
[    1.387680] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    1.387680] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    1.389150] power_supply test_ac: power_supply_changed_work
[    1.389150] power_supply test_ac: power_supply_changed_work
[    1.390513] power_supply test_ac: power_supply_update_gen_leds 1
[    1.390513] power_supply test_ac: power_supply_update_gen_leds 1
[    1.392170] power_supply test_ac: uevent
[    1.392170] power_supply test_ac: uevent
[    1.393140] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    1.393140] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    1.394439] power_supply test_ac: prop ONLINE=3D1
[    1.394439] power_supply test_ac: prop ONLINE=3D1
[    1.410195] power_supply test_battery: power_supply_changed
[    1.410195] power_supply test_battery: power_supply_changed
[    1.411601] power_supply test_battery: power_supply_changed_work
[    1.411601] power_supply test_battery: power_supply_changed_work
[    1.413002] power_supply test_battery: power_supply_update_bat_leds 2
[    1.413002] power_supply test_battery: power_supply_update_bat_leds 2
[    1.414528] power_supply test_battery: uevent
[    1.414528] power_supply test_battery: uevent
[    1.415616] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    1.415616] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    1.417289] power_supply test_battery: prop STATUS=3DDischarging
[    1.417289] power_supply test_battery: prop STATUS=3DDischarging
[    1.418795] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    1.418795] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    1.420172] power_supply test_battery: prop HEALTH=3DGood
[    1.420172] power_supply test_battery: prop HEALTH=3DGood
[    1.421471] power_supply test_battery: prop PRESENT=3D1
[    1.421471] power_supply test_battery: prop PRESENT=3D1
[    1.431791] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    1.431791] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    1.433156] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    1.433156] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    1.434705] power_supply test_battery: prop CHARGE_FULL=3D100
[    1.434705] power_supply test_battery: prop CHARGE_FULL=3D100
[    1.436123] power_supply test_battery: prop CHARGE_NOW=3D50
[    1.436123] power_supply test_battery: prop CHARGE_NOW=3D50
[    1.437466] power_supply test_battery: prop CAPACITY=3D50
[    1.437466] power_supply test_battery: prop CAPACITY=3D50
[    1.450850] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    1.450850] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    1.452262] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    1.452262] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    1.453714] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    1.453714] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    1.455263] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    1.455263] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    1.456837] power_supply test_battery: prop MANUFACTURER=3DLinux
[    1.456837] power_supply test_battery: prop MANUFACTURER=3DLinux
[    1.458332] power_supply test_battery: prop SERIAL_NUMBER=3D3.10.0-rc3-0=
0005-g003002e
[    1.458332] power_supply test_battery: prop SERIAL_NUMBER=3D3.10.0-rc3-0=
0005-g003002e
[    1.460294] power_supply test_battery: prop TEMP=3D26
[    1.460294] power_supply test_battery: prop TEMP=3D26
[    1.461508] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    1.461508] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    1.463056] power_supply test_usb: uevent
[    1.463056] power_supply test_usb: uevent
[    1.477448] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    1.477448] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    1.478865] power_supply test_usb: prop ONLINE=3D1
[    1.478865] power_supply test_usb: prop ONLINE=3D1
[    1.480033] power_supply test_usb: power_supply_changed
[    1.480033] power_supply test_usb: power_supply_changed
[    1.481420] applesmc: supported laptop not found!
[    1.481420] applesmc: supported laptop not found!
[    1.482594] applesmc: driver init failed (ret=3D-19)!
[    1.482594] applesmc: driver init failed (ret=3D-19)!
[    1.483923] f71882fg: Not a Fintek device
[    1.483923] f71882fg: Not a Fintek device
[    1.485013] f71882fg: Not a Fintek device
[    1.485013] f71882fg: Not a Fintek device
[    1.486051] cpuidle: using governor ladder
[    1.486051] cpuidle: using governor ladder
[    1.486999] cpuidle: using governor menu
[    1.486999] cpuidle: using governor menu
[    1.487963] ledtrig-cpu: registered to indicate activity on CPUs
[    1.487963] ledtrig-cpu: registered to indicate activity on CPUs
[    1.509892] logger: created 256K log 'log_main'
[    1.509892] logger: created 256K log 'log_main'
[    1.511163] logger: created 256K log 'log_events'
[    1.511163] logger: created 256K log 'log_events'
[    1.512436] power_supply test_usb: power_supply_changed_work
[    1.512436] power_supply test_usb: power_supply_changed_work
[    1.513971] power_supply test_usb: power_supply_update_gen_leds 1
[    1.513971] power_supply test_usb: power_supply_update_gen_leds 1
[    1.515504] power_supply test_usb: uevent
[    1.515504] power_supply test_usb: uevent
[    1.516793] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    1.516793] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    1.518187] power_supply test_usb: prop ONLINE=3D1
[    1.518187] power_supply test_usb: prop ONLINE=3D1
[    1.519439] logger: created 256K log 'log_radio'
[    1.519439] logger: created 256K log 'log_radio'
[    1.520849] logger: created 256K log 'log_system'
[    1.520849] logger: created 256K log 'log_system'
[    1.532437]=20
[    1.532437] printing PIC contents
[    1.532437]=20
[    1.532437] printing PIC contents
[    1.533594] ... PIC  IMR: ffff
[    1.533594] ... PIC  IMR: ffff
[    1.534302] ... PIC  IRR: 1013
[    1.534302] ... PIC  IRR: 1013
[    1.535042] ... PIC  ISR: 0000
[    1.535042] ... PIC  ISR: 0000
[    1.535832] ... PIC ELCR: 0c00
[    1.535832] ... PIC ELCR: 0c00
[    1.536575] printing local APIC contents on CPU#0/0:
[    1.536575] printing local APIC contents on CPU#0/0:
[    1.537812] ... APIC ID:      00000000 (0)
[    1.537812] ... APIC ID:      00000000 (0)
[    1.538872] ... APIC VERSION: 01050014
[    1.538872] ... APIC VERSION: 01050014
[    1.539816] ... APIC TASKPRI: 00000000 (00)
[    1.539816] ... APIC TASKPRI: 00000000 (00)
[    1.539816] ... APIC PROCPRI: 00000000
[    1.539816] ... APIC PROCPRI: 00000000
[    1.539816] ... APIC LDR: 01000000
[    1.539816] ... APIC LDR: 01000000
[    1.539816] ... APIC DFR: ffffffff
[    1.539816] ... APIC DFR: ffffffff
[    1.539816] ... APIC SPIV: 000001ff
[    1.539816] ... APIC SPIV: 000001ff
[    1.539816] ... APIC ISR field:
[    1.539816] ... APIC ISR field:
[    1.539816] 00000000
[    1.539816] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    1.539816] ... APIC TMR field:
[    1.539816] ... APIC TMR field:
[    1.539816] 00000000
[    1.539816] 000000000e2000000e200000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    1.539816] ... APIC IRR field:
[    1.539816] ... APIC IRR field:
[    1.539816] 00000000
[    1.539816] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    1.539816] ... APIC ESR: 00000000
[    1.539816] ... APIC ESR: 00000000
[    1.539816] ... APIC ICR: 00000831
[    1.539816] ... APIC ICR: 00000831
[    1.539816] ... APIC ICR2: 01000000
[    1.539816] ... APIC ICR2: 01000000
[    1.539816] ... APIC LVTT: 000200ef
[    1.539816] ... APIC LVTT: 000200ef
[    1.539816] ... APIC LVTPC: 00010000
[    1.539816] ... APIC LVTPC: 00010000
[    1.539816] ... APIC LVT0: 00010700
[    1.539816] ... APIC LVT0: 00010700
[    1.539816] ... APIC LVT1: 00000400
[    1.539816] ... APIC LVT1: 00000400
[    1.539816] ... APIC LVTERR: 000000fe
[    1.539816] ... APIC LVTERR: 000000fe
[    1.539816] ... APIC TMICT: 0003d090
[    1.539816] ... APIC TMICT: 0003d090
[    1.539816] ... APIC TMCCT: 00004072
[    1.539816] ... APIC TMCCT: 00004072
[    1.539816] ... APIC TDCR: 00000003
[    1.539816] ... APIC TDCR: 00000003
[    1.539816]=20
[    1.539816]=20
[    1.605582] number of MP IRQ sources: 15.
[    1.605582] number of MP IRQ sources: 15.
[    1.606560] number of IO-APIC #0 registers: 24.
[    1.606560] number of IO-APIC #0 registers: 24.
[    1.607606] testing the IO APIC.......................
[    1.607606] testing the IO APIC.......................
[    1.608809] IO APIC #0......
[    1.608809] IO APIC #0......
[    1.609470] .... register #00: 00000000
[    1.609470] .... register #00: 00000000
[    1.610374] .......    : physical APIC id: 00
[    1.610374] .......    : physical APIC id: 00
[    1.611446] .......    : Delivery Type: 0
[    1.611446] .......    : Delivery Type: 0
[    1.613311] .......    : LTS          : 0
[    1.613311] .......    : LTS          : 0
[    1.614264] .... register #01: 00170011
[    1.614264] .... register #01: 00170011
[    1.615204] .......     : max redirection entries: 17
[    1.615204] .......     : max redirection entries: 17
[    1.616450] .......     : PRQ implemented: 0
[    1.616450] .......     : PRQ implemented: 0
[    1.617517] .......     : IO APIC version: 11
[    1.617517] .......     : IO APIC version: 11
[    1.618658] .... register #02: 00000000
[    1.618658] .... register #02: 00000000
[    1.619641] .......     : arbitration: 00
[    1.619641] .......     : arbitration: 00
[    1.620644] .... IRQ redirection table:
[    1.620644] .... IRQ redirection table:
[    1.621587] 1    0    0   0   0    0    0    00
[    1.621587] 1    0    0   0   0    0    0    00
[    1.622742] 0    0    0   0   0    1    1    31
[    1.622742] 0    0    0   0   0    1    1    31
[    1.637804] 0    0    0   0   0    1    1    30
[    1.637804] 0    0    0   0   0    1    1    30
[    1.638927] 0    0    0   0   0    1    1    33
[    1.638927] 0    0    0   0   0    1    1    33
[    1.640062] 1    0    0   0   0    1    1    34
[    1.640062] 1    0    0   0   0    1    1    34
[    1.641232] 1    1    0   0   0    1    1    35
[    1.641232] 1    1    0   0   0    1    1    35
[    1.642422] 0    0    0   0   0    1    1    36
[    1.642422] 0    0    0   0   0    1    1    36
[    1.643560] 0    0    0   0   0    1    1    37
[    1.643560] 0    0    0   0   0    1    1    37
[    1.644705] 0    0    0   0   0    1    1    38
[    1.644705] 0    0    0   0   0    1    1    38
[    1.654978] 0    1    0   0   0    1    1    39
[    1.654978] 0    1    0   0   0    1    1    39
[    1.656171] 1    1    0   0   0    1    1    3A
[    1.656171] 1    1    0   0   0    1    1    3A
[    1.657434] 1    1    0   0   0    1    1    3B
[    1.657434] 1    1    0   0   0    1    1    3B
[    1.658683] 0    0    0   0   0    1    1    3C
[    1.658683] 0    0    0   0   0    1    1    3C
[    1.659815] 0    0    0   0   0    1    1    3D
[    1.659815] 0    0    0   0   0    1    1    3D
[    1.660918] 0    0    0   0   0    1    1    3E
[    1.660918] 0    0    0   0   0    1    1    3E
[    1.662022] 0    0    0   0   0    1    1    3F
[    1.662022] 0    0    0   0   0    1    1    3F
[    1.663185] 1    0    0   0   0    0    0    00
[    1.663185] 1    0    0   0   0    0    0    00
[    1.664404] 1    0    0   0   0    0    0    00
[    1.664404] 1    0    0   0   0    0    0    00
[    1.665523] 1    0    0   0   0    0    0    00
[    1.665523] 1    0    0   0   0    0    0    00
[    1.666562] 1    0    0   0   0    0    0    00
[    1.666562] 1    0    0   0   0    0    0    00
[    1.667634] 1    0    0   0   0    0    0    00
[    1.667634] 1    0    0   0   0    0    0    00
[    1.681868] 1    0    0   0   0    0    0    00
[    1.681868] 1    0    0   0   0    0    0    00
[    1.682996] 1    0    0   0   0    0    0    00
[    1.682996] 1    0    0   0   0    0    0    00
[    1.684139] 1    0    0   0   0    0    0    00
[    1.684139] 1    0    0   0   0    0    0    00
[    1.685298] IRQ to pin mappings:
[    1.685298] IRQ to pin mappings:
[    1.686039] IRQ0=20
[    1.686039] IRQ0 -> 0:2-> 0:2

[    1.686662] IRQ1=20
[    1.686662] IRQ1 -> 0:1-> 0:1

[    1.687305] IRQ3=20
[    1.687305] IRQ3 -> 0:3-> 0:3

[    1.687984] IRQ4=20
[    1.687984] IRQ4 -> 0:4-> 0:4

[    1.688625] IRQ5=20
[    1.688625] IRQ5 -> 0:5-> 0:5

[    1.689251] IRQ6=20
[    1.689251] IRQ6 -> 0:6-> 0:6

[    1.689859] IRQ7=20
[    1.689859] IRQ7 -> 0:7-> 0:7

[    1.690456] IRQ8=20
[    1.690456] IRQ8 -> 0:8-> 0:8

[    1.691056] IRQ9=20
[    1.691056] IRQ9 -> 0:9-> 0:9

[    1.691662] IRQ10=20
[    1.691662] IRQ10 -> 0:10-> 0:10

[    1.692335] IRQ11=20
[    1.692335] IRQ11 -> 0:11-> 0:11

[    1.702077] IRQ12=20
[    1.702077] IRQ12 -> 0:12-> 0:12

[    1.702774] IRQ13=20
[    1.702774] IRQ13 -> 0:13-> 0:13

[    1.703448] IRQ14=20
[    1.703448] IRQ14 -> 0:14-> 0:14

[    1.704147] IRQ15=20
[    1.704147] IRQ15 -> 0:15-> 0:15

[    1.704854] .................................... done.
[    1.704854] .................................... done.
[    1.706125] turn off boot console earlyser0
[    1.706125] turn off boot console earlyser0
[    1.707624] Loading module verification certificates
[    1.710426] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 8c6d12=
65ebe3a319046b06f326296ccc3499f63b'
[    1.726533] Running tests on trace events:
[    1.727026] Testing event xen_cpu_set_ldt: OK
[    1.736023] Testing event xen_cpu_write_gdt_entry: OK
[    1.782978] Testing event xen_cpu_load_idt: OK
[    1.859956] Testing event xen_cpu_write_idt_entry: OK
[    1.900418] Testing event xen_cpu_write_ldt_entry: OK
[    1.931987] Testing event xen_mmu_write_cr3: OK
[    2.011297] Testing event xen_mmu_flush_tlb_others: OK
[    2.052970] Testing event xen_mmu_flush_tlb_single: OK
[    2.064014] Testing event xen_mmu_flush_tlb: OK
[    2.171045] Testing event xen_mmu_flush_tlb_all: OK
[    2.195987] Testing event xen_mmu_pgd_unpin: OK
[    2.207997] Testing event xen_mmu_pgd_pin: OK
[    2.361535] Testing event xen_mmu_release_ptpage: OK
[    2.380028] Testing event xen_mmu_alloc_ptpage: OK
[    2.408022] Testing event xen_mmu_ptep_modify_prot_commit: OK
[    2.497457] Testing event xen_mmu_ptep_modify_prot_start: OK
[    2.515983] Testing event xen_mmu_pgd_clear: OK
[    2.612761] Testing event xen_mmu_pud_clear: OK
[    2.626202] Testing event xen_mmu_set_pgd: OK
[    2.643983] Testing event xen_mmu_set_pud:=20
[    2.716496] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input2
[    2.717944] tsc: Refined TSC clocksource calibration: 2925.994 MHz
OK
[    2.734963] Testing event xen_mmu_pmd_clear: OK
[    2.756966] Testing event xen_mmu_set_pmd: OK
[    2.851898] Testing event xen_mmu_pte_clear: OK
[    2.904133] Testing event xen_mmu_set_pte_at: OK
[    2.930772] Testing event xen_mmu_set_domain_pte: OK
[    2.943895] Testing event xen_mmu_set_pte_atomic: OK
[    2.965946] Testing event xen_mmu_set_pte: OK
[    2.976015] Testing event xen_mc_extend_args: OK
[    3.026933] Testing event xen_mc_flush: OK
[    3.036509] Testing event xen_mc_flush_reason: OK
[    3.047994] Testing event xen_mc_callback: OK
[    3.158974] Testing event xen_mc_entry_alloc: OK
[    3.219887] Testing event xen_mc_entry: OK
[    3.241139] Testing event xen_mc_issue: OK
[    3.265535] Testing event xen_mc_batch: OK
[    3.335052] Testing event emulate_vsyscall: OK
[    3.371905] Testing event sys_exit: OK
[    3.391808] Testing event sys_enter: OK
[    3.424008] Testing event task_rename: OK
[    3.444013] Testing event task_newtask: OK
[    3.464039] Testing event console: OK
[    3.523916] Testing event softirq_raise: OK
[    3.542501] Testing event softirq_exit: OK
[    3.589290] Testing event softirq_entry: OK
[    3.633983] Testing event irq_handler_exit: OK
[    3.675892] Testing event irq_handler_entry: OK
[    3.695996] Testing event itimer_expire: OK
[    3.768023] Testing event itimer_state: OK
[    3.789017] Testing event hrtimer_cancel: OK
[    3.810327] Testing event hrtimer_expire_exit: OK
[    3.908016] Testing event hrtimer_expire_entry: OK
[    3.936393] Testing event hrtimer_start: OK
[    3.952030] Testing event hrtimer_init: OK
[    4.071981] Testing event timer_cancel: OK
[    4.100947] Testing event timer_expire_exit: OK
[    4.127917] Testing event timer_expire_entry: OK
[    4.183919] Testing event timer_start: OK
[    4.243911] Testing event timer_init: OK
[    4.304915] Testing event signal_deliver: OK
[    4.323911] Testing event signal_generate: OK
[    4.347903] Testing event workqueue_execute_end: OK
[    4.371911] Testing event workqueue_execute_start: OK
[    4.391906] Testing event workqueue_activate_work: OK
[    4.400018] Testing event workqueue_queue_work: OK
[    4.448003] Testing event rcu_barrier: OK
[    4.460029] Testing event rcu_torture_read: OK
[    4.471995] Testing event rcu_batch_end: OK
[    4.484020] Testing event rcu_invoke_kfree_callback: OK
[    4.547987] Testing event rcu_invoke_callback: OK
[    4.560605] Testing event rcu_batch_start: OK
[    4.572028] Testing event rcu_kfree_callback: OK
[    4.584043] Testing event rcu_callback: OK
[    4.596580] Testing event rcu_prep_idle: OK
[    4.701420] Testing event rcu_dyntick: OK
[    4.707983] Testing event rcu_utilization: OK
[    4.759914] Testing event sched_pi_setprio: OK
[    4.775917] Testing event sched_stat_runtime: OK
[    4.784010] Testing event sched_stat_blocked: OK
[    4.820015] Testing event sched_stat_iowait: OK
[    4.831988] Testing event sched_stat_sleep: OK
[    4.843999] Testing event sched_stat_wait: OK
[    4.927003] Testing event sched_process_exec: OK
[    4.936011] Testing event sched_process_fork: OK
[    4.947979] Testing event sched_process_wait: OK
[    5.028571] Testing event sched_wait_task: OK
[    5.040553] Testing event sched_process_exit: OK
[    5.051971] Testing event sched_process_free: OK
[    5.063982] Testing event sched_migrate_task: OK
[    5.076525] Testing event sched_switch: OK
[    5.180483] Testing event sched_wakeup_new: OK
[    5.193231] Testing event sched_wakeup: OK
[    5.208557] Testing event sched_kthread_stop_ret: OK
[    5.244470] Testing event sched_kthread_stop: OK
[    5.257247] Testing event lock_release: OK
[    5.281496] Testing event lock_acquire: OK
[    5.323249] Testing event module_request: OK
[    5.332000] Testing event module_free: OK
[    5.344583] Testing event module_load: OK
[    5.357584] Testing event ftrace_test_filter: OK
[    5.461669] Testing event power_domain_target: OK
[    5.489807] Testing event clock_set_rate: OK
[    5.496589] Testing event clock_disable: OK
[    5.508570] Testing event clock_enable: OK
[    5.576557] Testing event wakeup_source_deactivate: OK
[    5.588543] Testing event wakeup_source_activate: OK
[    5.663910] Testing event machine_suspend: OK
[    5.674294] Testing event cpu_frequency: OK
[    5.683986] Testing event cpu_idle: OK
[    5.740001] Testing event mm_filemap_add_to_page_cache: OK
[    5.752035] Testing event mm_filemap_delete_from_page_cache: OK
[    5.763970] Testing event oom_score_adj_update: OK
[    5.775977] Testing event mm_vmscan_lru_shrink_inactive: OK
[    5.836015] Testing event mm_vmscan_writepage: OK
[    5.848035] Testing event mm_vmscan_memcg_isolate: OK
[    5.860007] Testing event mm_vmscan_lru_isolate: OK
[    5.872002] Testing event mm_shrink_slab_end: OK
[    5.936005] Testing event mm_shrink_slab_start: OK
[    5.948007] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    5.959995] Testing event mm_vmscan_memcg_reclaim_end: OK
[    5.971992] Testing event mm_vmscan_direct_reclaim_end: OK
[    5.984022] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    6.084483] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    6.092559] Testing event mm_vmscan_direct_reclaim_begin: OK
[    6.172462] Testing event mm_vmscan_wakeup_kswapd: OK
[    6.189121] Testing event mm_vmscan_kswapd_wake: OK
[    6.216666] Testing event mm_vmscan_kswapd_sleep: OK
[    6.228578] Testing event mm_page_alloc_extfrag: OK
[    6.248727] Testing event mm_page_pcpu_drain: OK
[    6.260559] Testing event mm_page_alloc_zone_locked: OK
[    6.316500] Testing event mm_page_alloc: OK
[    6.332411] Testing event mm_page_free_batched: OK
[    6.368883] Testing event mm_page_free: OK
[    6.398936] Testing event kmem_cache_free: OK
[    6.411894] Testing event kfree: OK
[    6.435648] Testing event kmem_cache_alloc_node: OK
[    6.444004] Testing event kmalloc_node: OK
[    6.456019] Testing event kmem_cache_alloc: OK
[    6.532545] Testing event kmalloc: OK
[    6.544592] Testing event mm_compaction_migratepages: OK
[    6.655915] Testing event mm_compaction_isolate_freepages: OK
[    6.672098] Testing event mm_compaction_isolate_migratepages: OK
[    6.685619] Testing event mm_migrate_pages: OK
[    6.712818] Testing event writeback_single_inode: OK
[    6.730953] Testing event writeback_single_inode_start: OK
[    6.744026] Testing event writeback_wait_iff_congested: OK
[    6.768038] Testing event writeback_congestion_wait: OK
[    6.807573] Testing event writeback_sb_inodes_requeue: OK
[    6.843532] Testing event balance_dirty_pages: OK
[    6.863905] Testing event bdi_dirty_ratelimit: OK
[    6.883915] Testing event global_dirty_state: OK
[    6.892004] Testing event writeback_queue_io: OK
[    6.951901] Testing event wbc_writepage: OK
[    6.967900] Testing event writeback_bdi_unregister: OK
[    6.984489] Testing event writeback_bdi_register: OK
[    7.018847] Testing event writeback_wake_background: OK
[    7.037210] Testing event writeback_nowork: OK
[    7.064443] Testing event writeback_pages_written: OK
[    7.077188] Testing event writeback_wait: OK
[    7.106374] Testing event writeback_written: OK
[    7.130961] Testing event writeback_start: OK
[    7.149133] Testing event writeback_exec: OK
[    7.161554] Testing event writeback_queue: OK
[    7.205117] Testing event writeback_write_inode: OK
[    7.235482] Testing event writeback_write_inode_start: OK
[    7.305373] Testing event writeback_dirty_inode: OK
[    7.327905] Testing event writeback_dirty_inode_start: OK
[    7.339855] Testing event writeback_dirty_page: OK
[    7.401165] Testing event regulator_set_voltage_complete: OK
[    7.415504] Testing event regulator_set_voltage: OK
[    7.429720] Testing event regulator_disable_complete: OK
[    7.439998] Testing event regulator_disable: OK
[    7.452015] Testing event regulator_enable_complete: OK
[    7.564564] Testing event regulator_enable_delay: OK
[    7.576003] Testing event regulator_enable: OK
[    7.588000] Testing event extract_entropy_user: OK
[    7.600011] Testing event extract_entropy: OK
[    7.612025] Testing event get_random_bytes: OK
[    7.624017] Testing event credit_entropy_bits: OK
[    7.700543] Testing event mix_pool_bytes_nolock: OK
[    7.714132] Testing event mix_pool_bytes: OK
[    7.743913] Testing event regmap_async_complete_done: OK
[    7.775926] Testing event regmap_async_complete_start: OK
[    7.791908] Testing event regmap_async_io_complete: OK
[    7.800016] Testing event regmap_async_write_start: OK
[    7.840014] Testing event regmap_cache_bypass: OK
[    7.852031] Testing event regmap_cache_only: OK
[    7.864016] Testing event regcache_sync: OK
[    7.919908] Testing event regmap_hw_write_done: OK
[    7.928002] Testing event regmap_hw_write_start: OK
[    7.983918] Testing event regmap_hw_read_done: OK
[    7.992002] Testing event regmap_hw_read_start: OK
[    8.040493] Testing event regmap_reg_read_cache: OK
[    8.052581] Testing event regmap_reg_read: OK
[    8.064595] Testing event regmap_reg_write: OK
[    8.076593] Testing event udp_fail_queue_rcv_skb: OK
[    8.088026] Testing event sock_exceed_buf_limit: OK
[    8.163185] Testing event sock_rcvqueue_full: OK
[    8.207924] Testing event napi_poll: OK
[    8.236027] Testing event netif_rx: OK
[    8.299914] Testing event netif_receive_skb: OK
[    8.323913] Testing event net_dev_queue: OK
[    8.343922] Testing event net_dev_xmit: OK
[    8.351992] Testing event skb_copy_datagram_iovec: OK
[    8.392024] Testing event consume_skb: OK
[    8.404003] Testing event kfree_skb: OK
[    8.416014] Running tests on trace event systems:
[    8.416654] Testing event system skb: OK
[    8.428101] Testing event system net: OK
[    8.540738] Testing event system napi: OK
[    8.552605] Testing event system sock: OK
[    8.564611] Testing event system udp: OK
[    8.576595] Testing event system regmap: OK
[    8.588893] Testing event system random: OK
[    8.600779] Testing event system regulator: OK
[    8.724635] Testing event system writeback: OK
[    8.737224] Testing event system migrate: OK
[    8.763260] Testing event system compaction: OK
[    8.779212] Testing event system kmem: OK
[    8.816198] Testing event system vmscan: OK
[    8.836617] Testing event system oom: OK
[    8.849428] Testing event system filemap: OK
[    8.877879] Testing event system power: OK
[    8.901639] Testing event system test: OK
[    8.928016] Testing event system module: OK
[    8.942303] Testing event system lock: OK
[    8.986897] Testing event system sched: OK
[    9.002242] Testing event system rcu: OK
[    9.023206] Testing event system workqueue: OK
[    9.038874] Testing event system signal: OK
[    9.084225] Testing event system timer: OK
[    9.114678] Testing event system irq: OK
[    9.138625] Testing event system printk: OK
[    9.154434] Testing event system task: OK
[    9.183945] Testing event system raw_syscalls: OK
[    9.192925] Testing event system vsyscall: OK
[    9.204058] Testing event system xen: OK
[    9.260854] Running tests on all trace events:
[    9.261511] Testing all events: OK
[    9.297341] Testing ftrace filter: OK
[    9.302086] Testing kprobe tracing:=20
[    9.304225] Could not insert probe at kprobe_trace_selftest_target+0: -22
[    9.305509] ------------[ cut here ]------------
[    9.306204] WARNING: at kernel/trace/trace_kprobe.c:1393 kprobe_trace_se=
lf_tests_init+0x69/0x7f0()
[    9.307812] Modules linked in:
[    9.308313] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc3-00005-g00=
3002e #25
[    9.309436] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    9.311039]  0000000000000009 ffff880013445e78 ffffffff814c1621 ffff8800=
13445eb0
[    9.312241]  ffffffff81078a3c ffffffff81c84624 0000000000000007 00000000=
00000000
[    9.313388]  0000000000000000 0000000000000000 ffff880013445ec0 ffffffff=
81078a95
[    9.314561] Call Trace:
[    9.314933]  [<ffffffff814c1621>] dump_stack+0x27/0x30
[    9.315799]  [<ffffffff81078a3c>] warn_slowpath_common+0x8c/0xc0
[    9.316793]  [<ffffffff81c84624>] ? init_kprobe_trace+0xe8/0xe8
[    9.317665]  [<ffffffff81078a95>] warn_slowpath_null+0x25/0x30
[    9.318480]  [<ffffffff81c8468d>] kprobe_trace_self_tests_init+0x69/0x7f0
[    9.319385]  [<ffffffff81c84624>] ? init_kprobe_trace+0xe8/0xe8
[    9.320256]  [<ffffffff810021aa>] do_one_initcall+0x1aa/0x260
[    9.321092]  [<ffffffff81c605e9>] kernel_init_freeable+0x23d/0x327
[    9.322026]  [<ffffffff814b2010>] ? rest_init+0x230/0x230
[    9.322845]  [<ffffffff814b2021>] kernel_init+0x11/0x240
[    9.323674]  [<ffffffff814d757a>] ret_from_fork+0x7a/0xb0
[    9.324509]  [<ffffffff814b2010>] ? rest_init+0x230/0x230
[    9.325230] ---[ end trace d5b21dab2503848a ]---
[    9.325955] error on probing function entry.
[    9.328451] Could not insert probe at kprobe_trace_selftest_target+0: -22
[    9.329576] ------------[ cut here ]------------
[    9.330233] WARNING: at kernel/trace/trace_kprobe.c:1414 kprobe_trace_se=
lf_tests_init+0x24c/0x7f0()
[    9.331801] Modules linked in:
[    9.332229] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.10.0-rc=
3-00005-g003002e #25
[    9.333681] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    9.335068]  0000000000000009 ffff880013445e78 ffffffff814c1621 ffff8800=
13445eb0
[    9.336687]  ffffffff81078a3c 0000000000000001 0000000000000007 00000000=
00000000
[    9.337856]  0000000000000000 0000000000000000 ffff880013445ec0 ffffffff=
81078a95
[    9.338997] Call Trace:
[    9.339389]  [<ffffffff814c1621>] dump_stack+0x27/0x30
[    9.340117]  [<ffffffff81078a3c>] warn_slowpath_common+0x8c/0xc0
[    9.341017]  [<ffffffff81078a95>] warn_slowpath_null+0x25/0x30
[    9.341848]  [<ffffffff81c84870>] kprobe_trace_self_tests_init+0x24c/0x7=
f0
[    9.342758]  [<ffffffff81c84624>] ? init_kprobe_trace+0xe8/0xe8
[    9.343579]  [<ffffffff810021aa>] do_one_initcall+0x1aa/0x260
[    9.344532]  [<ffffffff81c605e9>] kernel_init_freeable+0x23d/0x327
[    9.345419]  [<ffffffff814b2010>] ? rest_init+0x230/0x230
[    9.346183]  [<ffffffff814b2021>] kernel_init+0x11/0x240
[    9.346953]  [<ffffffff814d757a>] ret_from_fork+0x7a/0xb0
[    9.347762]  [<ffffffff814b2010>] ? rest_init+0x230/0x230
[    9.348656] ---[ end trace d5b21dab2503848b ]---
[    9.349305] error on probing function return.
[    9.350052] NG: Some tests are failed. Please check them.
[    9.352168] Key type trusted registered
[    9.355553] debug: unmapping init [mem 0xffffffff81c5f000-0xffffffff81d3=
2fff]
[    9.356911] Write protecting the kernel read-only data: 10240k
[    9.358672] debug: unmapping init [mem 0xffff8800014e2000-0xffff8800015f=
ffff]
[    9.359909] debug: unmapping init [mem 0xffff8800018a9000-0xffff8800019f=
ffff]
mount: mounting proc on /proc failed: No such device
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
mount: can't read '/proc/mounts': No such file or directory
/etc/init.d/rc: /etc/rcS.d/S37populate-volatile.sh: line 172: can't open /p=
roc/cmdline: no such file
grep: /proc/filesystems: No such file or directory
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
ifup: can't open '/var/run/ifstate': No such file or directory
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
mount: no /proc/mounts
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
mount: mounting proc on /proc failed: No such device
/etc/rc5.d/S99-rc.local: line 19: can't create /proc/390/oom_score_adj: non=
existent directory
sed: /lib/modules/3.10.0-rc3-00005-g003002e/modules.dep: No such file or di=
rectory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
grep: /proc/cmdline: No such file or directory
grep: /proc/cmdline: No such file or directory
/etc/kernel-tests/90-trinity: line 18: /usr/sbin/chroot: not found
/etc/kernel-tests/90-trinity: line 17: /usr/sbin/chroot: not found
/etc/kernel-tests/90-trinity: line 16: /trinity: not found
/etc/kernel-tests/90-trinity: line 15: /trinity: not found
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123
shutdown: warning: cannot open /var/run/shutdown.pid
mount: no /proc/mounts
wfg: skip syslogd
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
Deconfiguring network interfaces... ifdown: interface lo not configured
done.
Sending all processes the TERM signal...
mount: mounting proc on /proc failed: No such device
Sending all processes the KILL signal...
mount: mounting proc on /proc failed: No such device
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
grep: /proc/mounts: No such file or directory
mount: can't read '/proc/mounts': No such file or directory
Rebooting...=20
[   78.039918] Unregister pv shared memory for cpu 0
[   78.042192] Restarting system.
[   78.042670] reboot: machine restart
Elapsed time: 80
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-ib0-12061218/003002e04ed38618fc37b92ba128f5ca79d39f4f/vmlinuz-3.10.0-rc3-0=
0005-g003002e -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug=
 apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pan=
ic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-i=
b0-12061218/linux-devel:devel-hourly-2014121022:003002e04ed38618fc37b92ba12=
8f5ca79d39f4f:bisect-linux-1/.vmlinuz-003002e04ed38618fc37b92ba128f5ca79d39=
f4f-20141211083609-15-client9 branch=3Dlinux-devel/devel-hourly-2014121022 =
BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-12061218/003002e04ed38618fc37b92=
ba128f5ca79d39f4f/vmlinuz-3.10.0-rc3-00005-g003002e drbd.minor_count=3D8'  =
-initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 -net ni=
c,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -wa=
tchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-cli=
ent9-40 -serial file:/dev/shm/kboot/serial-yocto-client9-40 -daemonize -dis=
play none -monitor null=20

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.10.0-rc3-00005-g003002e"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc3 Kernel Configuration
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
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
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
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
CONFIG_MODULE_SIG_SHA384=y
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha384"
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=m
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
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
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
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
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

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
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_VMWARE_VMCI is not set
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
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
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
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_PWM_BEEPER=m
CONFIG_INPUT_ADXL34X=m
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=m
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_MWAVE=m
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=m
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=m
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=m

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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
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
# CONFIG_MFD_CROS_EC is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_TPS6105X=m
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_ANATOP=m
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP8755=m
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_V4L2_INT_DEVICE=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set

#
# Supported MMC/SDIO adapters
#

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=m
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_TLV320AIC23B=m
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
# CONFIG_VIDEO_VP27SMPX is not set
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=m
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
CONFIG_VIDEO_SAA7191=m
CONFIG_VIDEO_TVP514X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_TVP7002=m
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
CONFIG_VIDEO_TW9906=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_ADV7343=m
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_AK881X=m

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
CONFIG_VIDEO_VS6624=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_TCM825X=m
CONFIG_VIDEO_SR030PC30=m

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
# CONFIG_VIDEO_UPD64083 is not set

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=m
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_AU8522_V4L is not set
# CONFIG_DVB_TUNER_DIB0070 is not set
CONFIG_DVB_TUNER_DIB0090=m

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
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_VX_LIB=m
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
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
# CONFIG_SND_HDA_INTEL is not set
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
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=m
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_KEYTOUCH=m
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=m
CONFIG_HID_LOGITECH=m
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_PS3REMOTE is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_WIIMOTE_EXT=y
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

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
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=m
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
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
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=m
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=m
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_ACPI_PROCESSOR=m
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
# CONFIG_COMEDI_KCOMEDILIB is not set
# CONFIG_COMEDI_TEST is not set
CONFIG_COMEDI_PARPORT=m
# CONFIG_COMEDI_SERIAL2002 is not set
# CONFIG_COMEDI_SKEL is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
CONFIG_COMEDI_PCMCIA_DRIVERS=y
CONFIG_COMEDI_CB_DAS16_CS=m
# CONFIG_COMEDI_DAS08_CS is not set
CONFIG_COMEDI_NI_DAQ_700_CS=m
CONFIG_COMEDI_NI_DAQ_DIO24_CS=m
# CONFIG_COMEDI_NI_LABPC_CS is not set
CONFIG_COMEDI_NI_MIO_CS=m
CONFIG_COMEDI_QUATECH_DAQP_CS=m
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_NI_TIO=m
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_TSL2583=m
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_SYSFS_TRIGGER=m
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
CONFIG_ZSMALLOC=y
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y
# CONFIG_FT1000_PCMCIA is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y
# CONFIG_VIDEO_DT3155 is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# CONFIG_ASHMEM is not set
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_SYNC is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_DGRP is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_MAX1363=m
CONFIG_TI_ADC081C=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5380=m
CONFIG_AD5446=m
# CONFIG_MAX517 is not set
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
# CONFIG_HID_SENSOR_GYRO_3D is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=m

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_SENSORS_LM3533=m
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_VCNL4000 is not set
CONFIG_HID_SENSOR_ALS=m

#
# Magnetometer sensors
#
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m
# CONFIG_RESET_CONTROLLER is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
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
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
CONFIG_KPROBE_EVENT=y
# CONFIG_UPROBE_EVENT is not set
CONFIG_PROBE_EVENTS=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_STRING_HELPERS=m
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=m
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
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=m
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=m
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_AVX2_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--huq684BweRXVnRxX--
