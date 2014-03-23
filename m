Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaCWHJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 03:09:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:35303 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaCWHJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 03:09:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,713,1389772800"; 
   d="log'?scan'208";a="497713389"
Date: Sun, 23 Mar 2014 15:09:05 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [x86,vdso32] Kernel panic - not syncing: Attempted to kill init!
 exitcode=0x0000000b
Message-ID: <20140323070905.GC14679@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
In-Reply-To: <20140322114700.GA14326@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi Stefani,

FYI, here is another bug message triggered by

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso

commit 4e40112c4ff6a577dd06d92b2a54cdf06265bf74
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Mon Mar 17 23:22:13 2014 +0100
Commit:     H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue Mar 18 12:52:54 2014 -0700

    x86, vdso32: handle 32 bit vDSO larger one page
    
    This patch enables 32 bit vDSO which are larger than a page.
    
    Signed-off-by: Stefani Seibold <stefani@seibold.net>
    Link: http://lkml.kernel.org/r/1395094933-14252-14-git-send-email-stefani@seibold.net
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

+------------------------------------------------------------+------------+------------+---------------+
|                                                            | 008cc907de | 4e40112c4f | next-20140321 |
+------------------------------------------------------------+------------+------------+---------------+
| boot_successes                                             | 113        | 0          | 0             |
| boot_failures                                              | 25         | 30         | 19            |
| WARNING:CPU:PID:at_kernel/events/core.c:perf_swevent_add() | 25         |            |               |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=  | 0          | 15         | 10            |
| kernel_BUG_at_mm/swap.c                                    | 0          | 15         | 9             |
| invalid_opcode:SMP_DEBUG_PAGEALLOC                         | 0          | 15         | 9             |
| EIP_is_at_put_compound_page                                | 0          | 15         | 9             |
| backtrace:do_group_exit                                    | 0          | 15         | 9             |
| backtrace:SyS_exit_group                                   | 0          | 15         | 9             |
+------------------------------------------------------------+------------+------------+---------------+

[    6.764330] EDD information not available.
[    6.766357] debug: unmapping init [mem 0xb1ea9000-0xb20b8fff]
[    6.771076] traps: init[1] general protection ip:a76b3b0d sp:affef7fd error:0
[    6.775516] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    6.775516] 
[    6.776114] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-rc7-next-20140321 #9
[    6.776114] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.776114]  00000000 00000000 b014bdf4 b19a5b91 b1da1401 b014be14 b19986f9 b1c6723c
[    6.776114]  b20d0540 00000001 b1da1401 b0150201 b0150000 b014be68 b1045c39 b1c67550
[    6.776114]  0000000b 0000000b b0150384 00000001 00000001 00000001 b0150000 b0150000
[    6.776114] Call Trace:
[    6.776114]  [<b19a5b91>] dump_stack+0x48/0x60
[    6.776114]  [<b19986f9>] panic+0x87/0x18e
[    6.776114]  [<b1045c39>] do_exit+0x7c9/0xaa0
[    6.776114]  [<b1045f9e>] do_group_exit+0x4e/0xb0
[    6.776114]  [<b10523b9>] get_signal_to_deliver+0x1b9/0x870
[    6.776114]  [<b1085dc0>] ? lock_release_holdtime.part.26+0xb0/0xf0
[    6.776114]  [<b1002c40>] ? do_alignment_check+0xa0/0xa0
[    6.776114]  [<b1001a6a>] do_signal+0x3a/0x9b0
[    6.776114]  [<b108ae5a>] ? do_raw_spin_unlock+0xaa/0xf0
[    6.776114]  [<b106c02f>] ? finish_task_switch+0xcf/0x120
[    6.776114]  [<b19ae1c0>] ? __schedule+0x410/0x8f0
[    6.776114]  [<b108ae5a>] ? do_raw_spin_unlock+0xaa/0xf0
[    6.776114]  [<b1050f07>] ? force_sig_info+0xa7/0xd0
[    6.776114]  [<b1051b64>] ? force_sig+0x14/0x20
[    6.776114]  [<b1002cb1>] ? do_general_protection+0x71/0x170
[    6.776114]  [<b1002c40>] ? do_alignment_check+0xa0/0xa0
[    6.776114]  [<b1002448>] do_notify_resume+0x68/0x70
[    6.776114]  [<b19b3e50>] work_notifysig+0x30/0x38
[    6.776114]  [<b1002c40>] ? do_alignment_check+0xa0/0xa0
[    6.776114] Kernel Offset: 0x0 from 0xb1000000 (relocation range: 0xb0000000-0xc47fdfff)

Elapsed time: 20

git bisect start 3b55c3c0ec2eb3f163f15559f3962df717f53ccb v3.13 --
git bisect good 3962dfbe22a8d65e4162354cc859440293d85524  # 08:08     29+      6  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect good dcb99fd9b08cfe1afe426af4d8d3cbc429190f15  # 08:28     29+      4  Linux 3.14-rc7
git bisect good 5a02b8848ab78148f442126c6c7e32553326c00d  # 08:47     29+      5  Merge remote-tracking branch 'thermal/next'
git bisect good 1b89b74cc212e138793d688321f8424a96a1c534  # 09:04     29+      5  Merge remote-tracking branch 'dt-rh/for-next'
git bisect  bad 6ecd774cc7ff8b15a950c827630b852c0dc48ab2  # 09:20      1-      2  Merge remote-tracking branch 'char-misc/char-misc-next'
git bisect  bad d8be03aa8bf754fa0ec3a20885a2387e43a418fe  # 09:40      7-     16  Merge remote-tracking branch 'percpu/for-next'
git bisect  bad 0e56c90c132b64427c8c55fd85003ec1f17dba6d  # 10:00      2-      4  Merge remote-tracking branch 'edac-amd/for-next'
git bisect  bad 67ae3b36794de69d58e66fb50be0fa0d68574c17  # 10:15     10-     30  Merge remote-tracking branch 'tip/auto-latest'
git bisect good e224ef010790d873c4672a408f442c08b901567f  # 10:27     30+      4  Merge remote-tracking branch 'spi/for-next'
git bisect good a49712343611eb2aca50b2034910e8873b453118  # 10:53     30+     10  Merge branch 'perf/core'
git bisect good 626bfe396b8bfe0c2c94fe44bc985103abfe4b6f  # 11:11     30+      9  Merge branch 'x86/apic'
git bisect good 72a500453a77e0980c0c2b4ed9fe8b521e7ac523  # 11:26     30+      9  Merge branch 'x86/debug'
git bisect good c519db7a10228d5f0d6baf3deaa2c869f8b57bb9  # 11:42     30+     10  Merge branch 'x86/kaslr'
git bisect good 653a5574e4dae78892f545820dc1a4bbbb841465  # 12:05     30+      7  Merge branch 'x86/threadinfo'
git bisect good ef721987aef0cc0abba08c88810f2155f76b0b1f  # 12:24     30+      4  x86, vdso: Introduce VVAR marco for vdso32
git bisect good 008cc907de327d83a0be609cd495fccb0e5dfa4c  # 13:06     30+      6  x86, vdso32: Disable stack protector, adjust optimizations
git bisect good dce44e03b0a3448ad11ac6c6e0cbe299e0400791  # 13:16     30+      5  compat: Fix sparse address space warnings
git bisect  bad 047f5b6a988ec6ade49dfb58c74fbc8733329969  # 13:36      2-     10  Merge branch 'x86/vdso'
git bisect  bad 4e40112c4ff6a577dd06d92b2a54cdf06265bf74  # 13:54      5-      8  x86, vdso32: handle 32 bit vDSO larger one page
# first bad commit: [4e40112c4ff6a577dd06d92b2a54cdf06265bf74] x86, vdso32: handle 32 bit vDSO larger one page
git bisect good 008cc907de327d83a0be609cd495fccb0e5dfa4c  # 14:02    108+     25  x86, vdso32: Disable stack protector, adjust optimizations
git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 14:02      0-     19  Add linux-next specific files for 20140321
git bisect good 774868c7094d35b4518be3d0e654de000a5d11fc  # 14:15    108+     18  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 14:15      0-     19  Add linux-next specific files for 20140321

Thanks,
Fengguang

--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivytown2-93:20140323053628:i386-randconfig-x4-03230530:3.14.0-rc7-next-20140321:9"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-next-20140321 (kbuild@xian) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-16) ) #9 SMP Sun Mar 23 05:34:53 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[b00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [b009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 4k
[    0.000000] BRK [0x0262e000, 0x0262efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
[    0.000000] BRK [0x0262f000, 0x0262ffff] PGTABLE
[    0.000000] BRK [0x02630000, 0x02630fff] PGTABLE
[    0.000000] BRK [0x02631000, 0x02631fff] PGTABLE
[    0.000000] BRK [0x02632000, 0x02632fff] PGTABLE
[    0.000000] BRK [0x02633000, 0x02633fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 32 MiB at 10000000
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
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
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat b1e4b260, node_mem_map c2=
48b028
[    0.000000]   Normal zone: 800 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
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
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 331 pages/cpu @c212b000 s1341856 r0 d13920 =
u1355776
[    0.000000] pcpu-alloc: s1341856 r0 d13920 u1355776 alloc=3D331*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1212d580
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81020
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-x4-03230530/next:ma=
ster/.vmlinuz-06ed26d1de59ce7cbbe68378b7e470be169750e5-20140323053552-7-ivy=
town2 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-x4-03230530=
/06ed26d1de59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next-20140321 =
drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 655336 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Memory: 239684K/327280K available (9940K kernel code, 1149K =
rwdata, 3908K rodata, 2112K init, 5512K bss, 87596K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     vmalloc : 0xc47fe000 - 0xffd34000   ( 949 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xc3ffe000   ( 319 MB)
[    0.000000]       .init : 0xb1ea9000 - 0xb20b9000   (2112 kB)
[    0.000000]       .data : 0xb19b5748 - 0xb1ea7460   (5063 kB)
[    0.000000]       .text : 0xb1000000 - 0xb19b5748   (9941 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Db0084000 soft=3Db0086000
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-next-20140321 (kbuild@xian) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-16) ) #9 SMP Sun Mar 23 05:34:53 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[b00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [b009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 4k
[    0.000000] BRK [0x0262e000, 0x0262efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
[    0.000000] BRK [0x0262f000, 0x0262ffff] PGTABLE
[    0.000000] BRK [0x02630000, 0x02630fff] PGTABLE
[    0.000000] BRK [0x02631000, 0x02631fff] PGTABLE
[    0.000000] BRK [0x02632000, 0x02632fff] PGTABLE
[    0.000000] BRK [0x02633000, 0x02633fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 32 MiB at 10000000
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
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
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat b1e4b260, node_mem_map c2=
48b028
[    0.000000]   Normal zone: 800 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
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
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 331 pages/cpu @c212b000 s1341856 r0 d13920 =
u1355776
[    0.000000] pcpu-alloc: s1341856 r0 d13920 u1355776 alloc=3D331*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1212d580
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81020
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-x4-03230530/next:ma=
ster/.vmlinuz-06ed26d1de59ce7cbbe68378b7e470be169750e5-20140323053552-7-ivy=
town2 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-x4-03230530=
/06ed26d1de59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next-20140321 =
drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 655336 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Memory: 239684K/327280K available (9940K kernel code, 1149K =
rwdata, 3908K rodata, 2112K init, 5512K bss, 87596K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     vmalloc : 0xc47fe000 - 0xffd34000   ( 949 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xc3ffe000   ( 319 MB)
[    0.000000]       .init : 0xb1ea9000 - 0xb20b9000   (2112 kB)
[    0.000000]       .data : 0xb19b5748 - 0xb1ea7460   (5063 kB)
[    0.000000]       .text : 0xb1000000 - 0xb19b5748   (9941 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Db0084000 soft=3Db0086000
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
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  memory used by lock dependency info: 3807 kB
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
[    0.000000]                      A-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

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
 |  ok  |  ok  |             |             |failed|failed|

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |failed|failed|

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |failed|failed|             |             |failed|failed|

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |failed|failed|             |             |failed|failed|

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|failed|fai=
led|  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|failed|fai=
led|  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:failed|failed|failed|faile=
d|  ok  |  ok  |

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
[    0.000000]                ww contexts mixing:failed|failed|  ok  |  ok =
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
[    0.000000]                           context:failed|failed|  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000]                             block:
[    0.000000]                             block:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000] --------------------------------------------------------
[    0.000000] --------------------------------------------------------
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ----------------------------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2493.982 MHz processor
[    0.000000] tsc: Detected 2493.982 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 4987.96 Bogo=
MIPS (lpj=3D2493982)
4987.96 BogoMIPS (lpj=3D2493982)
[    0.004011] pid_max: default: 32768 minimum: 301
[    0.004011] pid_max: default: 32768 minimum: 301
[    0.005115] ACPI: Core revision 20140214
[    0.005115] ACPI: Core revision 20140214
[    0.040371] ACPI:=20
[    0.040371] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.042347] Mount-cache hash table entries: 512
[    0.042347] Mount-cache hash table entries: 512
[    0.044825] Initializing cgroup subsys memory
[    0.044825] Initializing cgroup subsys memory
[    0.045034] Initializing cgroup subsys devices
[    0.045034] Initializing cgroup subsys devices
[    0.046026] Initializing cgroup subsys hugetlb
[    0.046026] Initializing cgroup subsys hugetlb
[    0.048146] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.048146] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.048146] tlb_flushall_shift: 6
[    0.048146] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.048146] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.048146] tlb_flushall_shift: 6
[    0.050228] debug: unmapping init [mem 0xb20b9000-0xb20bffff]
[    0.050228] debug: unmapping init [mem 0xb20b9000-0xb20bffff]
[    0.059075] ftrace: allocating 35890 entries in 71 pages
[    0.059075] ftrace: allocating 35890 entries in 71 pages
[    0.074281] Getting VERSION: 50014
[    0.074281] Getting VERSION: 50014
[    0.075015] Getting VERSION: 50014
[    0.075015] Getting VERSION: 50014
[    0.076011] Getting ID: 0
[    0.076011] Getting ID: 0
[    0.077016] Getting ID: f000000
[    0.077016] Getting ID: f000000
[    0.078016] Getting LVT0: 8700
[    0.078016] Getting LVT0: 8700
[    0.079010] Getting LVT1: 8400
[    0.079010] Getting LVT1: 8400
[    0.080012] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.080012] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.081034] enabled ExtINT on CPU#0
[    0.081034] enabled ExtINT on CPU#0
[    0.083601] ENABLING IO-APIC IRQs
[    0.083601] ENABLING IO-APIC IRQs
[    0.084010] init IO_APIC IRQs
[    0.084010] init IO_APIC IRQs
[    0.085010]  apic 0 pin 0 not connected
[    0.085010]  apic 0 pin 0 not connected
[    0.086037] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.086037] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.087046] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.087046] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.088044] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.088044] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.089055] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.089055] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.090042] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.090042] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.091042] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.091042] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.092044] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.092044] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.093041] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.093041] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.094044] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.094044] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.095042] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.095042] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.096041] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.096041] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.097042] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.097042] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.098042] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.098042] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.099044] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.099044] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.100043] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.100043] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.101031]  apic 0 pin 16 not connected
[    0.101031]  apic 0 pin 16 not connected
[    0.102006]  apic 0 pin 17 not connected
[    0.102006]  apic 0 pin 17 not connected
[    0.103007]  apic 0 pin 18 not connected
[    0.103007]  apic 0 pin 18 not connected
[    0.104007]  apic 0 pin 19 not connected
[    0.104007]  apic 0 pin 19 not connected
[    0.105007]  apic 0 pin 20 not connected
[    0.105007]  apic 0 pin 20 not connected
[    0.106007]  apic 0 pin 21 not connected
[    0.106007]  apic 0 pin 21 not connected
[    0.107007]  apic 0 pin 22 not connected
[    0.107007]  apic 0 pin 22 not connected
[    0.108006]  apic 0 pin 23 not connected
[    0.108006]  apic 0 pin 23 not connected
[    0.109181] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.109181] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.110007] smpboot: CPU0:=20
[    0.110007] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.114007] Using local APIC timer interrupts.
[    0.114007] calibrating APIC timer ...
[    0.114007] Using local APIC timer interrupts.
[    0.114007] calibrating APIC timer ...
[    0.116000] ... lapic delta =3D 9062587
[    0.116000] ... lapic delta =3D 9062587
[    0.116000] ... PM-Timer delta =3D 519039
[    0.116000] ... PM-Timer delta =3D 519039
[    0.116000] APIC calibration not consistent with PM-Timer: 145ms instead=
 of 100ms
[    0.116000] APIC calibration not consistent with PM-Timer: 145ms instead=
 of 100ms
[    0.116000] APIC delta adjusted to PM-Timer: 6249991 (9062587)
[    0.116000] APIC delta adjusted to PM-Timer: 6249991 (9062587)
[    0.116000] TSC delta adjusted to PM-Timer: 249394789 (361626416)
[    0.116000] TSC delta adjusted to PM-Timer: 249394789 (361626416)
[    0.116000] ..... delta 6249991
[    0.116000] ..... delta 6249991
[    0.116000] ..... mult: 268435069
[    0.116000] ..... mult: 268435069
[    0.116000] ..... calibration result: 999998
[    0.116000] ..... calibration result: 999998
[    0.116000] ..... CPU clock speed is 2493.0947 MHz.
[    0.116000] ..... CPU clock speed is 2493.0947 MHz.
[    0.116000] ..... host bus clock speed is 999.0998 MHz.
[    0.116000] ..... host bus clock speed is 999.0998 MHz.
[    0.116079] Performance Events:=20
[    0.116079] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.121205] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.121205] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.122525] CPU 1 irqstacks, hard=3Db01aa000 soft=3Db01ac000
[    0.122525] CPU 1 irqstacks, hard=3Db01aa000 soft=3Db01ac000
[    0.123007] x86: Booting SMP configuration:
[    0.123007] x86: Booting SMP configuration:
[    0.124006] .... node  #0, CPUs: =20
[    0.124006] .... node  #0, CPUs:         #1 #1
[    0.002000] Initializing CPU#1
[    0.003000] kvm-clock: cpu 1, msr 0:13ffd021, secondary cpu clock
[    0.003000] masked ExtINT on CPU#1
[    0.140090] x86: Booted up 1 node, 2 CPUs
[    0.140090] x86: Booted up 1 node, 2 CPUs
[    0.140053] KVM setup async PF for cpu 1
[    0.140053] KVM setup async PF for cpu 1
[    0.140053] kvm-stealtime: cpu 1, msr 12278580
[    0.140053] kvm-stealtime: cpu 1, msr 12278580
[    0.141015] ----------------
[    0.141015] ----------------
[    0.142005] | NMI testsuite:
[    0.142005] | NMI testsuite:
[    0.143004] --------------------
[    0.143004] --------------------
[    0.143841]   remote IPI:
[    0.143841]   remote IPI:  ok  |  ok  |

[    0.147318]    local IPI:
[    0.147318]    local IPI:  ok  |  ok  |

[    0.155014] --------------------
[    0.155014] --------------------
[    0.155879] Good, all   2 testcases passed! |
[    0.155879] Good, all   2 testcases passed! |
[    0.156005] ---------------------------------
[    0.156005] ---------------------------------
[    0.157008] smpboot: Total of 2 processors activated (9975.92 BogoMIPS)
[    0.157008] smpboot: Total of 2 processors activated (9975.92 BogoMIPS)
[    0.160488] devtmpfs: initialized
[    0.160488] devtmpfs: initialized
[    0.170832] regulator-dummy: no parameters
[    0.170832] regulator-dummy: no parameters
[    0.174865] NET: Registered protocol family 16
[    0.174865] NET: Registered protocol family 16
[    0.176912] cpuidle: using governor ladder
[    0.176912] cpuidle: using governor ladder
[    0.177007] cpuidle: using governor menu
[    0.177007] cpuidle: using governor menu
[    0.178598] ACPI: bus type PCI registered
[    0.178598] ACPI: bus type PCI registered
[    0.180579] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.180579] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.181005] PCI: Using configuration type 1 for base access
[    0.181005] PCI: Using configuration type 1 for base access
[    0.253141] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.253141] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.254053] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.254053] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.256364] ACPI: Added _OSI(Module Device)
[    0.256364] ACPI: Added _OSI(Module Device)
[    0.257007] ACPI: Added _OSI(Processor Device)
[    0.257007] ACPI: Added _OSI(Processor Device)
[    0.258006] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.258006] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.259006] ACPI: Added _OSI(Processor Aggregator Device)
[    0.259006] ACPI: Added _OSI(Processor Aggregator Device)
[    0.324094] ACPI: Interpreter enabled
[    0.324094] ACPI: Interpreter enabled
[    0.325104] ACPI: (supports S0 S4 S5)
[    0.325104] ACPI: (supports S0 S4 S5)
[    0.326005] ACPI: Using IOAPIC for interrupt routing
[    0.326005] ACPI: Using IOAPIC for interrupt routing
[    0.327239] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.327239] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.407702] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.407702] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.408034] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.408034] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.409130] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.409130] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.415152] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.415152] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.416576] PCI host bridge to bus 0000:00
[    0.416576] PCI host bridge to bus 0000:00
[    0.417017] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.417017] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.418015] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.418015] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.419015] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.419015] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.420015] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.420015] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.421015] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.421015] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.422091] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.422091] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.425567] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.425567] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.432546] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.432546] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.436330] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.436330] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.439043] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.439043] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.440007] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.440007] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.441006] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.441006] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.442013] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.442013] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.446007] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.446007] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.448123] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.448123] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.449021] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.449021] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.455039] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.455039] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.458052] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.458052] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.461051] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.461051] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.471054] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.471054] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.477719] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.477719] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.479570] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.479570] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.481012] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.481012] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.488582] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.488582] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.492171] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.492171] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.494329] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.494329] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.501426] pci_bus 0000:00: on NUMA node 0
[    0.501426] pci_bus 0000:00: on NUMA node 0
[    0.509928] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.509928] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.512413] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.512413] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.516020] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.516020] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.519518] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.519518] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.521840] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.521840] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.528648] ACPI:=20
[    0.528648] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.533659] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.533659] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.534000] vgaarb: loaded
[    0.534000] vgaarb: loaded
[    0.534007] vgaarb: bridge control possible 0000:00:02.0
[    0.534007] vgaarb: bridge control possible 0000:00:02.0
[    0.539235] SCSI subsystem initialized
[    0.539235] SCSI subsystem initialized
[    0.541247] libata version 3.00 loaded.
[    0.541247] libata version 3.00 loaded.
[    0.543744] pps_core: LinuxPPS API ver. 1 registered
[    0.543744] pps_core: LinuxPPS API ver. 1 registered
[    0.546007] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.546007] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.552085] PTP clock support registered
[    0.552085] PTP clock support registered
[    0.556409] PCI: Using ACPI for IRQ routing
[    0.556409] PCI: Using ACPI for IRQ routing
[    0.557012] PCI: pci_cache_line_size set to 64 bytes
[    0.557012] PCI: pci_cache_line_size set to 64 bytes
[    0.559164] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.559164] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.564045] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.564045] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.571430] irda_init()
[    0.571430] irda_init()
[    0.572226] NET: Registered protocol family 23
[    0.572226] NET: Registered protocol family 23
[    0.577090] Bluetooth: Core ver 2.19
[    0.577090] Bluetooth: Core ver 2.19
[    0.579142] NET: Registered protocol family 31
[    0.579142] NET: Registered protocol family 31
[    0.581010] Bluetooth: HCI device and connection manager initialized
[    0.581010] Bluetooth: HCI device and connection manager initialized
[    0.584026] Bluetooth: HCI socket layer initialized
[    0.584026] Bluetooth: HCI socket layer initialized
[    0.589014] Bluetooth: L2CAP socket layer initialized
[    0.589014] Bluetooth: L2CAP socket layer initialized
[    0.590133] Bluetooth: SCO socket layer initialized
[    0.590133] Bluetooth: SCO socket layer initialized
[    0.592044] NET: Registered protocol family 8
[    0.592044] NET: Registered protocol family 8
[    0.596007] NET: Registered protocol family 20
[    0.596007] NET: Registered protocol family 20
[    0.598227] nfc: nfc_init: NFC Core ver 0.1
[    0.598227] nfc: nfc_init: NFC Core ver 0.1
[    0.602214] NET: Registered protocol family 39
[    0.602214] NET: Registered protocol family 39
[    0.607036] Switched to clocksource kvm-clock
[    0.607036] Switched to clocksource kvm-clock
[    0.608766] Could not create debugfs 'set_ftrace_filter' entry
[    0.608766] Could not create debugfs 'set_ftrace_filter' entry
[    0.610362] Could not create debugfs 'set_ftrace_notrace' entry
[    0.610362] Could not create debugfs 'set_ftrace_notrace' entry
[    0.613324] Warning: could not register annotated branches stats
[    0.613324] Warning: could not register annotated branches stats
[    0.943053] pnp: PnP ACPI init
[    0.943053] pnp: PnP ACPI init
[    0.944859] ACPI: bus type PNP registered
[    0.944859] ACPI: bus type PNP registered
[    0.947748] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.947748] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.954279] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.954279] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.959062] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.959062] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.964127] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.964127] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.968148] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.968148] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.973653] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.973653] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.978529] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.978529] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.983674] pnp 00:03: [dma 2]
[    0.983674] pnp 00:03: [dma 2]
[    0.985940] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.985940] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.991133] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.991133] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.995706] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.995706] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.001229] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.001229] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.006514] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.006514] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.016849] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.016849] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.025871] pnp: PnP ACPI: found 7 devices
[    1.025871] pnp: PnP ACPI: found 7 devices
[    1.028055] ACPI: bus type PNP unregistered
[    1.028055] ACPI: bus type PNP unregistered
[    1.074645] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.074645] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.076157] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.076157] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.077657] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.077657] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.079326] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.079326] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.081088] NET: Registered protocol family 1
[    1.081088] NET: Registered protocol family 1
[    1.082288] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.082288] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.096909] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.096909] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.098478] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.098478] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.100172] pci 0000:00:02.0: Boot video device
[    1.100172] pci 0000:00:02.0: Boot video device
[    1.101430] PCI: CLS 0 bytes, default 64
[    1.101430] PCI: CLS 0 bytes, default 64
[    1.103221] Trying to unpack rootfs image as initramfs...
[    1.103221] Trying to unpack rootfs image as initramfs...
[    4.673520] debug: unmapping init [mem 0xc27ab000-0xc3feffff]
[    4.673520] debug: unmapping init [mem 0xc27ab000-0xc3feffff]
[    4.690982] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    4.690982] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    4.692613] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    4.692613] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    4.706257] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    4.706257] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    4.709682] apm: BIOS not found.
[    4.709682] apm: BIOS not found.
[    4.711556] cryptomgr_test (26) used greatest stack depth: 7052 bytes le=
ft
[    4.711556] cryptomgr_test (26) used greatest stack depth: 7052 bytes le=
ft
[    4.715761] cryptomgr_probe (35) used greatest stack depth: 6876 bytes l=
eft
[    4.715761] cryptomgr_probe (35) used greatest stack depth: 6876 bytes l=
eft
[    4.718367] cryptomgr_test (34) used greatest stack depth: 6244 bytes le=
ft
[    4.718367] cryptomgr_test (34) used greatest stack depth: 6244 bytes le=
ft
[    4.733811] NatSemi SCx200 Driver
[    4.733811] NatSemi SCx200 Driver
[    4.738125] Initializing RT-Tester: OK
[    4.738125] Initializing RT-Tester: OK
[    4.739297] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    4.739297] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    4.743454] spin_lock-torture: Creating torture_shuffle task
[    4.743454] spin_lock-torture: Creating torture_shuffle task
[    4.756150] spin_lock-torture: Creating torture_stutter task
[    4.756150] spin_lock-torture: Creating torture_stutter task
[    4.757752] spin_lock-torture: torture_shuffle task started
[    4.757752] spin_lock-torture: torture_shuffle task started
[    4.759283] spin_lock-torture: torture_stutter task started
[    4.759283] spin_lock-torture: torture_stutter task started
[    4.759290] spin_lock-torture: Creating lock_torture_writer task
[    4.759290] spin_lock-torture: Creating lock_torture_writer task
[    4.762623] spin_lock-torture: Creating lock_torture_writer task
[    4.762623] spin_lock-torture: Creating lock_torture_writer task
[    4.764381] spin_lock-torture: lock_torture_writer task started
[    4.764381] spin_lock-torture: lock_torture_writer task started
[    4.766000] spin_lock-torture: Creating lock_torture_writer task
[    4.766000] spin_lock-torture: Creating lock_torture_writer task
[    4.766028] spin_lock-torture: lock_torture_writer task started
[    4.766028] spin_lock-torture: lock_torture_writer task started
[    4.769396] spin_lock-torture: Creating lock_torture_writer task
[    4.769396] spin_lock-torture: Creating lock_torture_writer task
[    4.771156] spin_lock-torture: lock_torture_writer task started
[    4.771156] spin_lock-torture: lock_torture_writer task started
[    4.772830] spin_lock-torture: Creating lock_torture_stats task
[    4.772830] spin_lock-torture: Creating lock_torture_stats task
[    4.772837] spin_lock-torture: lock_torture_writer task started
[    4.772837] spin_lock-torture: lock_torture_writer task started
[    4.789317] spin_lock-torture: lock_torture_stats task started
[    4.789317] spin_lock-torture: lock_torture_stats task started
[    4.791662] futex hash table entries: 512 (order: 3, 32768 bytes)
[    4.791662] futex hash table entries: 512 (order: 3, 32768 bytes)
[    4.793452] Initialise system trusted keyring
[    4.793452] Initialise system trusted keyring
[    4.796162] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    4.796162] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    4.918733] VFS: Disk quotas dquot_6.5.2
[    4.918733] VFS: Disk quotas dquot_6.5.2
[    4.920749] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.920749] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.976809] NTFS driver 2.1.30 [Flags: R/W].
[    4.976809] NTFS driver 2.1.30 [Flags: R/W].
[    4.983936] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.983936] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.986798] QNX4 filesystem 0.2.3 registered.
[    4.986798] QNX4 filesystem 0.2.3 registered.
[    5.001861] QNX6 filesystem 1.0.0 registered.
[    5.001861] QNX6 filesystem 1.0.0 registered.
[    5.004313] fuse init (API version 7.22)
[    5.004313] fuse init (API version 7.22)
[    5.008772] SGI XFS with security attributes, realtime, large block/inod=
e numbers, no debug enabled
[    5.008772] SGI XFS with security attributes, realtime, large block/inod=
e numbers, no debug enabled
[    5.057113] NILFS version 2 loaded
[    5.057113] NILFS version 2 loaded
[    5.074224] ocfs2 stack glue: unable to register sysctl
[    5.074224] ocfs2 stack glue: unable to register sysctl
[    5.076809] OCFS2 User DLM kernel interface loaded
[    5.076809] OCFS2 User DLM kernel interface loaded
[    5.085289] msgmni has been set to 532
[    5.085289] msgmni has been set to 532
[    5.086473] Key type big_key registered
[    5.086473] Key type big_key registered
[    5.105143] cryptomgr_test (77) used greatest stack depth: 6092 bytes le=
ft
[    5.105143] cryptomgr_test (77) used greatest stack depth: 6092 bytes le=
ft
[    5.118287] cryptomgr_test (79) used greatest stack depth: 6012 bytes le=
ft
[    5.118287] cryptomgr_test (79) used greatest stack depth: 6012 bytes le=
ft
[    5.138446] alg: No test for lz4 (lz4-generic)
[    5.138446] alg: No test for lz4 (lz4-generic)
[    5.139911] alg: No test for lz4hc (lz4hc-generic)
[    5.139911] alg: No test for lz4hc (lz4hc-generic)
[    5.141528] alg: No test for stdrng (krng)
[    5.141528] alg: No test for stdrng (krng)
[    5.167505] NET: Registered protocol family 38
[    5.167505] NET: Registered protocol family 38
[    5.169666] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    5.169666] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    5.171659] io scheduler noop registered
[    5.171659] io scheduler noop registered
[    5.172725] io scheduler deadline registered (default)
[    5.172725] io scheduler deadline registered (default)
[    5.175614] io scheduler cfq registered
[    5.175614] io scheduler cfq registered
[    5.176662] test_string_helpers: Running tests...
[    5.176662] test_string_helpers: Running tests...
[    5.181151] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.181151] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.183143] ACPI: Power Button [PWRF]
[    5.183143] ACPI: Power Button [PWRF]
[    5.218296] HDLC line discipline maxframe=3D4096
[    5.218296] HDLC line discipline maxframe=3D4096
[    5.219572] N_HDLC line discipline registered.
[    5.219572] N_HDLC line discipline registered.
[    5.220883] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.220883] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.258462] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.258462] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.277082] Non-volatile memory driver v1.3
[    5.277082] Non-volatile memory driver v1.3
[    5.285621] toshiba: not a supported Toshiba laptop
[    5.285621] toshiba: not a supported Toshiba laptop
[    5.287229] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    5.287229] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    5.296543] platform pc8736x_gpio.0: no device found
[    5.296543] platform pc8736x_gpio.0: no device found
[    5.298091] nsc_gpio initializing
[    5.298091] nsc_gpio initializing
[    5.299052] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    5.299052] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    5.307825] smapi::smapi_init, ERROR invalid usSmapiID
[    5.307825] smapi::smapi_init, ERROR invalid usSmapiID
[    5.309220] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    5.309220] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    5.319069] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    5.319069] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    5.320961] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    5.320961] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    5.330030] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    5.330030] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    5.332398] Hangcheck: Using getrawmonotonic().
[    5.332398] Hangcheck: Using getrawmonotonic().
[    5.341971] [drm] Initialized drm 1.1.0 20060810
[    5.341971] [drm] Initialized drm 1.1.0 20060810
[    5.345079] Floppy drive(s):
[    5.345079] Floppy drive(s): fd0 is 1.44M fd0 is 1.44M

[    5.357692] FDC 0 is a S82078B
[    5.357692] FDC 0 is a S82078B
[    5.412696] brd: module loaded
[    5.412696] brd: module loaded
[    5.441680] loop: module loaded
[    5.441680] loop: module loaded
[    5.451305] nbd: registered device at major 43
[    5.451305] nbd: registered device at major 43
[    5.533368] dummy-irq: no IRQ given.  Use irq=3DN
[    5.533368] dummy-irq: no IRQ given.  Use irq=3DN
[    5.534805] lkdtm: No crash points registered, enable through debugfs
[    5.534805] lkdtm: No crash points registered, enable through debugfs
[    5.537057] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    5.537057] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    5.539659] c2port c2port0: C2 port uc added
[    5.539659] c2port c2port0: C2 port uc added
[    5.540810] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    5.540810] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    5.545386] Uniform Multi-Platform E-IDE driver
[    5.545386] Uniform Multi-Platform E-IDE driver
[    5.560060] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    5.560060] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    5.562646] ide-gd driver 1.18
[    5.562646] ide-gd driver 1.18
[    5.563592] ide-cd driver 5.00
[    5.563592] ide-cd driver 5.00
[    5.577709] Loading iSCSI transport class v2.0-870.
[    5.577709] Loading iSCSI transport class v2.0-870.
[    5.581264] rdac: device handler registered
[    5.581264] rdac: device handler registered
[    5.582667] hp_sw: device handler registered
[    5.582667] hp_sw: device handler registered
[    5.583824] alua: device handler registered
[    5.583824] alua: device handler registered
[    5.599327] SCSI Media Changer driver v0.25=20
[    5.599327] SCSI Media Changer driver v0.25=20
[    5.601061] osd: LOADED open-osd 0.2.1
[    5.601061] osd: LOADED open-osd 0.2.1
[    5.630357] scsi_debug: host protection
[    5.630357] scsi_debug: host protection
[    5.631490] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    5.631490] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    5.637045] Error: Driver 'pata_platform' is already registered, abortin=
g...
[    5.637045] Error: Driver 'pata_platform' is already registered, abortin=
g...
[    5.637347] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    5.637347] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    5.640605] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.640605] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.643219] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    5.643219] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    5.657145] sd 0:0:0:0: [sda] Write Protect is off
[    5.657145] sd 0:0:0:0: [sda] Write Protect is off
[    5.658560] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    5.658560] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    5.662110] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    5.662110] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    5.675555] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    5.675555] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    5.684103]  sda: unknown partition table
[    5.684103]  sda: unknown partition table
[    5.688766] SSFDC read-only Flash Translation layer
[    5.688766] SSFDC read-only Flash Translation layer
[    5.690606] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[    5.690606] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[    5.692470] slram: not enough parameters.
[    5.692470] slram: not enough parameters.
[    5.693349] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.693349] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.708179] tsc: Refined TSC clocksource calibration: 2493.967 MHz
[    5.708179] tsc: Refined TSC clocksource calibration: 2493.967 MHz
[    5.796093] No valid DiskOnChip devices found
[    5.796093] No valid DiskOnChip devices found
[    5.797347] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.797347] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.799845] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.799845] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.802446] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.802446] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.804914] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.804914] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.807407] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.807407] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.822992] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.822992] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.825554] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    5.825554] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    5.827218] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    5.827218] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    5.828438] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    5.828438] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    5.830155] flash size: 128 MiB
[    5.830155] flash size: 128 MiB
[    5.831067] page size: 512 bytes
[    5.831067] page size: 512 bytes
[    5.831963] OOB area size: 16 bytes
[    5.831963] OOB area size: 16 bytes
[    5.832919] sector size: 16 KiB
[    5.832919] sector size: 16 KiB
[    5.833771] pages number: 262144
[    5.833771] pages number: 262144
[    5.843677] pages per sector: 32
[    5.843677] pages per sector: 32
[    5.844549] bus width: 8
[    5.844549] bus width: 8
[    5.845242] bits in sector size: 14
[    5.845242] bits in sector size: 14
[    5.846172] bits in page size: 9
[    5.846172] bits in page size: 9
[    5.847057] bits in OOB size: 4
[    5.847057] bits in OOB size: 4
[    5.847877] flash size with OOB: 135168 KiB
[    5.847877] flash size with OOB: 135168 KiB
[    5.852395] page address bytes: 4
[    5.852395] page address bytes: 4
[    5.853290] sector address bytes: 3
[    5.853290] sector address bytes: 3
[    5.854238] options: 0x42
[    5.854238] options: 0x42
[    5.861140] Scanning device for bad blocks
[    5.861140] Scanning device for bad blocks
[    5.944879] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    5.944879] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    5.946566] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    5.946566] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    5.957858] libphy: Fixed MDIO Bus: probed
[    5.957858] libphy: Fixed MDIO Bus: probed
[    5.969113] w83977af_init()
[    5.969113] w83977af_init()
[    5.969981] w83977af_open()
[    5.969981] w83977af_open()
[    5.970810] w83977af_probe()
[    5.970810] w83977af_probe()
[    5.976172] w83977af_probe(), Wrong chip version
[    5.976172] w83977af_probe(), Wrong chip version

[    5.977479] w83977af_probe()
[    5.977479] w83977af_probe()
[    5.982910] w83977af_probe(), Wrong chip version
[    5.982910] w83977af_probe(), Wrong chip version

[    5.989872] irda_register_dongle : registering dongle "JetEye PC ESI-968=
0 PC" (1).
[    5.989872] irda_register_dongle : registering dongle "JetEye PC ESI-968=
0 PC" (1).
[    5.995533] irda_register_dongle : registering dongle "Parallax LiteLink=
" (5).
[    5.995533] irda_register_dongle : registering dongle "Parallax LiteLink=
" (5).
[    6.003451] irda_register_dongle : registering dongle "Old Belkin SmartB=
eam" (7).
[    6.003451] irda_register_dongle : registering dongle "Old Belkin SmartB=
eam" (7).
[    6.008946] irda_register_dongle : registering dongle "Microchip MCP2120=
" (9).
[    6.008946] irda_register_dongle : registering dongle "Microchip MCP2120=
" (9).
[    6.014127] irda_register_dongle : registering dongle "MA600" (11).
[    6.014127] irda_register_dongle : registering dongle "MA600" (11).
[    6.017697] irda_register_dongle : registering dongle "Vishay TOIM3232" =
(12).
[    6.017697] irda_register_dongle : registering dongle "Vishay TOIM3232" =
(12).
[    6.022601] PPP generic driver version 2.4.2
[    6.022601] PPP generic driver version 2.4.2
[    6.026922] PPP BSD Compression module registered
[    6.026922] PPP BSD Compression module registered
[    6.029370] PPP Deflate Compression module registered
[    6.029370] PPP Deflate Compression module registered
[    6.033252] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    6.033252] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    6.036352] SLIP linefill/keepalive option.
[    6.036352] SLIP linefill/keepalive option.
[    6.040755] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.040755] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.048829] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.048829] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.051086] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.051086] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.060191] mousedev: PS/2 mouse device common for all mice
[    6.060191] mousedev: PS/2 mouse device common for all mice
[    6.067236] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.067236] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.073683] rtc_cmos 00:00: RTC can wake from S4
[    6.073683] rtc_cmos 00:00: RTC can wake from S4
[    6.076068] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    6.076068] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    6.077887] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    6.077887] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    6.084938] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    6.084938] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    6.092952] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    6.092952] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    6.097160] i2c-parport-light: adapter type unspecified
[    6.097160] i2c-parport-light: adapter type unspecified
[    6.100274] pps pps0: new PPS source ktimer
[    6.100274] pps pps0: new PPS source ktimer
[    6.101329] pps pps0: ktimer PPS source registered
[    6.101329] pps pps0: ktimer PPS source registered
[    6.102520] pps_ldisc: PPS line discipline registered
[    6.102520] pps_ldisc: PPS line discipline registered
[    6.107691] Driver for 1-wire Dallas network protocol.
[    6.107691] Driver for 1-wire Dallas network protocol.
[    6.110084] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    6.110084] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    6.137117] pc87360: PC8736x not detected, module not inserted
[    6.137117] pc87360: PC8736x not detected, module not inserted
[    6.144465] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    6.144465] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    6.166331] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    6.166331] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    6.168542] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    6.168542] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    6.174222] wafer5823wdt: I/O address 0x0443 already in use
[    6.174222] wafer5823wdt: I/O address 0x0443 already in use
[    6.175709] it87_wdt: no device
[    6.175709] it87_wdt: no device
[    6.176553] pc87413_wdt: Version 1.1 at io 0x2E
[    6.176553] pc87413_wdt: Version 1.1 at io 0x2E
[    6.185171] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    6.185171] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    6.187137] sbc60xxwdt: I/O address 0x0443 already in use
[    6.187137] sbc60xxwdt: I/O address 0x0443 already in use
[    6.205691] sbc7240_wdt: I/O address 0x0443 already in use
[    6.205691] sbc7240_wdt: I/O address 0x0443 already in use
[    6.207270] cpu5wdt: misc_register failed
[    6.207270] cpu5wdt: misc_register failed
[    6.208562] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    6.208562] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    6.211103] w83697ug_wdt: No W83697UG/UF could be found
[    6.211103] w83697ug_wdt: No W83697UG/UF could be found
[    6.212571] w83877f_wdt: I/O address 0x0443 already in use
[    6.212571] w83877f_wdt: I/O address 0x0443 already in use
[    6.232150] w83977f_wdt: driver v1.00
[    6.232150] w83977f_wdt: driver v1.00
[    6.233210] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    6.233210] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    6.235738] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    6.235738] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    6.238019] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    6.238019] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    6.240816] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    6.240816] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    6.243926] md: linear personality registered for level -1
[    6.243926] md: linear personality registered for level -1
[    6.245614] md: raid0 personality registered for level 0
[    6.245614] md: raid0 personality registered for level 0
[    6.247194] md: raid1 personality registered for level 1
[    6.247194] md: raid1 personality registered for level 1
[    6.248707] md: faulty personality registered for level -5
[    6.248707] md: faulty personality registered for level -5
[    6.261557] device-mapper: uevent: version 1.0.3
[    6.261557] device-mapper: uevent: version 1.0.3
[    6.273246] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    6.273246] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    6.296008] device-mapper: multipath: version 1.7.0 loaded
[    6.296008] device-mapper: multipath: version 1.7.0 loaded
[    6.297598] device-mapper: multipath round-robin: version 1.0.0 loaded
[    6.297598] device-mapper: multipath round-robin: version 1.0.0 loaded
[    6.301580] device-mapper: dm-log-userspace: version 1.3.0 loaded
[    6.301580] device-mapper: dm-log-userspace: version 1.3.0 loaded
[    6.317137] Bluetooth: Virtual HCI driver ver 1.4
[    6.317137] Bluetooth: Virtual HCI driver ver 1.4
[    6.331678] cpufreq-nforce2: No nForce2 chipset.
[    6.331678] cpufreq-nforce2: No nForce2 chipset.
[    6.334653] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    6.334653] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    6.351255] ashmem: initialized
[    6.351255] ashmem: initialized
[    6.352830] dgap-1.3-16, Digi International Part Number 40002347_C
[    6.352830] dgap-1.3-16, Digi International Part Number 40002347_C
[    6.354581] For the tools package please visit http://www.digi.com
[    6.354581] For the tools package please visit http://www.digi.com
[    6.357282] FPGA DOWNLOAD --->
[    6.357282] FPGA DOWNLOAD --->
[    6.358233] built at Sun Mar 23 05:30:37 2014 UTC
[    6.358233] built at Sun Mar 23 05:30:37 2014 UTC
[    6.359587] FPGA image file name: xlinx_fpga_firmware.bit
[    6.359587] FPGA image file name: xlinx_fpga_firmware.bit
[    6.361491] GPIO INIT FAIL!!
[    6.361491] GPIO INIT FAIL!!
[    6.374761] oprofile: using NMI interrupt.
[    6.374761] oprofile: using NMI interrupt.
[    6.379158] NET: Registered protocol family 17
[    6.379158] NET: Registered protocol family 17
[    6.384304] NET: Registered protocol family 4
[    6.384304] NET: Registered protocol family 4
[    6.387431] NET: Registered protocol family 9
[    6.387431] NET: Registered protocol family 9
[    6.390849] X25: Linux Version 0.2
[    6.390849] X25: Linux Version 0.2
[    6.396358] IrCOMM protocol (Dag Brattli)
[    6.396358] IrCOMM protocol (Dag Brattli)
[    6.431374] Bluetooth: RFCOMM socket layer initialized
[    6.431374] Bluetooth: RFCOMM socket layer initialized
[    6.435255] Bluetooth: RFCOMM ver 1.11
[    6.435255] Bluetooth: RFCOMM ver 1.11
[    6.436397] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.436397] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.439510] Bluetooth: BNEP socket layer initialized
[    6.439510] Bluetooth: BNEP socket layer initialized
[    6.443850] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    6.443850] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    6.458635] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    6.458635] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    6.463738] NET: Registered protocol family 12
[    6.463738] NET: Registered protocol family 12
[    6.469077] 9pnet: Installing 9P2000 support
[    6.469077] 9pnet: Installing 9P2000 support
[    6.474150] NET: Registered protocol family 37
[    6.474150] NET: Registered protocol family 37
[    6.483762] NET: Registered protocol family 36
[    6.483762] NET: Registered protocol family 36
[    6.487041] Key type dns_resolver registered
[    6.487041] Key type dns_resolver registered
[    6.489360] mpls_gso: MPLS GSO support
[    6.489360] mpls_gso: MPLS GSO support
[    6.493478]=20
[    6.493478] printing PIC contents
[    6.493478]=20
[    6.493478] printing PIC contents
[    6.498618] ... PIC  IMR: ffff
[    6.498618] ... PIC  IMR: ffff
[    6.499585] ... PIC  IRR: 1153
[    6.499585] ... PIC  IRR: 1153
[    6.506204] ... PIC  ISR: 0000
[    6.506204] ... PIC  ISR: 0000
[    6.508343] ... PIC ELCR: 0c00
[    6.508343] ... PIC ELCR: 0c00
[    6.511543] printing local APIC contents on CPU#0/0:
[    6.511543] printing local APIC contents on CPU#0/0:
[    6.512023] ... APIC ID:      00000000 (0)
[    6.512023] ... APIC ID:      00000000 (0)
[    6.512023] ... APIC VERSION: 00050014
[    6.512023] ... APIC VERSION: 00050014
[    6.512023] ... APIC TASKPRI: 00000000 (00)
[    6.512023] ... APIC TASKPRI: 00000000 (00)
[    6.512023] ... APIC PROCPRI: 00000000
[    6.512023] ... APIC PROCPRI: 00000000
[    6.512023] ... APIC LDR: 01000000
[    6.512023] ... APIC LDR: 01000000
[    6.512023] ... APIC DFR: ffffffff
[    6.512023] ... APIC DFR: ffffffff
[    6.512023] ... APIC SPIV: 000001ff
[    6.512023] ... APIC SPIV: 000001ff
[    6.512023] ... APIC ISR field:
[    6.512023] ... APIC ISR field:
[    6.512023] 00000000
[    6.512023] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    6.512023] ... APIC TMR field:
[    6.512023] ... APIC TMR field:
[    6.512023] 00000000
[    6.512023] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    6.512023] ... APIC IRR field:
[    6.512023] ... APIC IRR field:
[    6.512023] 00000000
[    6.512023] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    6.512023] ... APIC ESR: 00000000
[    6.512023] ... APIC ESR: 00000000
[    6.512023] ... APIC ICR: 000008fd
[    6.512023] ... APIC ICR: 000008fd
[    6.512023] ... APIC ICR2: 02000000
[    6.512023] ... APIC ICR2: 02000000
[    6.512023] ... APIC LVTT: 000000ef
[    6.512023] ... APIC LVTT: 000000ef
[    6.512023] ... APIC LVTPC: 00010000
[    6.512023] ... APIC LVTPC: 00010000
[    6.512023] ... APIC LVT0: 00010700
[    6.512023] ... APIC LVT0: 00010700
[    6.512023] ... APIC LVT1: 00000400
[    6.512023] ... APIC LVT1: 00000400
[    6.512023] ... APIC LVTERR: 000000fe
[    6.512023] ... APIC LVTERR: 000000fe
[    6.512023] ... APIC TMICT: 0000ebd3
[    6.512023] ... APIC TMICT: 0000ebd3
[    6.512023] ... APIC TMCCT: 00000000
[    6.512023] ... APIC TMCCT: 00000000
[    6.512023] ... APIC TDCR: 00000003
[    6.512023] ... APIC TDCR: 00000003
[    6.512023]=20
[    6.512023]=20
[    6.565578] number of MP IRQ sources: 15.
[    6.565578] number of MP IRQ sources: 15.
[    6.567496] number of IO-APIC #0 registers: 24.
[    6.567496] number of IO-APIC #0 registers: 24.
[    6.571453] testing the IO APIC.......................
[    6.571453] testing the IO APIC.......................
[    6.575562] IO APIC #0......
[    6.575562] IO APIC #0......
[    6.578290] .... register #00: 00000000
[    6.578290] .... register #00: 00000000
[    6.583497] .......    : physical APIC id: 00
[    6.583497] .......    : physical APIC id: 00
[    6.586774] .......    : Delivery Type: 0
[    6.586774] .......    : Delivery Type: 0
[    6.587913] .......    : LTS          : 0
[    6.587913] .......    : LTS          : 0
[    6.590889] .... register #01: 00170011
[    6.590889] .... register #01: 00170011
[    6.593822] .......     : max redirection entries: 17
[    6.593822] .......     : max redirection entries: 17
[    6.596364] .......     : PRQ implemented: 0
[    6.596364] .......     : PRQ implemented: 0
[    6.600412] .......     : IO APIC version: 11
[    6.600412] .......     : IO APIC version: 11
[    6.606104] .... register #02: 00000000
[    6.606104] .... register #02: 00000000
[    6.610082] .......     : arbitration: 00
[    6.610082] .......     : arbitration: 00
[    6.613386] .... IRQ redirection table:
[    6.613386] .... IRQ redirection table:
[    6.614463] 1    0    0   0   0    0    0    00
[    6.614463] 1    0    0   0   0    0    0    00
[    6.617758] 0    0    0   0   0    1    1    31
[    6.617758] 0    0    0   0   0    1    1    31
[    6.619016] 0    0    0   0   0    1    1    30
[    6.619016] 0    0    0   0   0    1    1    30
[    6.623228] 0    0    0   0   0    1    1    33
[    6.623228] 0    0    0   0   0    1    1    33
[    6.624510] 1    0    0   0   0    1    1    34
[    6.624510] 1    0    0   0   0    1    1    34
[    6.625744] 1    1    0   0   0    1    1    35
[    6.625744] 1    1    0   0   0    1    1    35
[    6.630455] 0    0    0   0   0    1    1    36
[    6.630455] 0    0    0   0   0    1    1    36
[    6.631714] 0    0    0   0   0    1    1    37
[    6.631714] 0    0    0   0   0    1    1    37
[    6.636044] 0    0    0   0   0    1    1    38
[    6.636044] 0    0    0   0   0    1    1    38
[    6.638845] 0    1    0   0   0    1    1    39
[    6.638845] 0    1    0   0   0    1    1    39
[    6.640121] 1    1    0   0   0    1    1    3A
[    6.640121] 1    1    0   0   0    1    1    3A
[    6.645509] 1    1    0   0   0    1    1    3B
[    6.645509] 1    1    0   0   0    1    1    3B
[    6.646882] 0    0    0   0   0    1    1    3C
[    6.646882] 0    0    0   0   0    1    1    3C
[    6.659988] 0    0    0   0   0    1    1    3D
[    6.659988] 0    0    0   0   0    1    1    3D
[    6.664322] 0    0    0   0   0    1    1    3E
[    6.664322] 0    0    0   0   0    1    1    3E
[    6.665572] 0    0    0   0   0    1    1    3F
[    6.665572] 0    0    0   0   0    1    1    3F
[    6.669926] 1    0    0   0   0    0    0    00
[    6.669926] 1    0    0   0   0    0    0    00
[    6.678398] 1    0    0   0   0    0    0    00
[    6.678398] 1    0    0   0   0    0    0    00
[    6.679664] 1    0    0   0   0    0    0    00
[    6.679664] 1    0    0   0   0    0    0    00
[    6.680913] 1    0    0   0   0    0    0    00
[    6.680913] 1    0    0   0   0    0    0    00
[    6.688464] 1    0    0   0   0    0    0    00
[    6.688464] 1    0    0   0   0    0    0    00
[    6.689947] 1    0    0   0   0    0    0    00
[    6.689947] 1    0    0   0   0    0    0    00
[    6.697421] 1    0    0   0   0    0    0    00
[    6.697421] 1    0    0   0   0    0    0    00
[    6.698675] 1    0    0   0   0    0    0    00
[    6.698675] 1    0    0   0   0    0    0    00
[    6.706692] IRQ to pin mappings:
[    6.706692] IRQ to pin mappings:
[    6.707625] IRQ0=20
[    6.707625] IRQ0 -> 0:2-> 0:2

[    6.708379] IRQ1=20
[    6.708379] IRQ1 -> 0:1-> 0:1

[    6.709150] IRQ3=20
[    6.709150] IRQ3 -> 0:3-> 0:3

[    6.713284] IRQ4=20
[    6.713284] IRQ4 -> 0:4-> 0:4

[    6.713976] IRQ5=20
[    6.713976] IRQ5 -> 0:5-> 0:5

[    6.714725] IRQ6=20
[    6.714725] IRQ6 -> 0:6-> 0:6

[    6.715521] IRQ7=20
[    6.715521] IRQ7 -> 0:7-> 0:7

[    6.719719] IRQ8=20
[    6.719719] IRQ8 -> 0:8-> 0:8

[    6.720619] IRQ9=20
[    6.720619] IRQ9 -> 0:9-> 0:9

[    6.721510] IRQ10=20
[    6.721510] IRQ10 -> 0:10-> 0:10

[    6.722413] IRQ11=20
[    6.722413] IRQ11 -> 0:11-> 0:11

[    6.726593] IRQ12=20
[    6.726593] IRQ12 -> 0:12-> 0:12

[    6.727411] IRQ13=20
[    6.727411] IRQ13 -> 0:13-> 0:13

[    6.728201] IRQ14=20
[    6.728201] IRQ14 -> 0:14-> 0:14

[    6.728964] IRQ15=20
[    6.728964] IRQ15 -> 0:15-> 0:15

[    6.733233] .................................... done.
[    6.733233] .................................... done.
[    6.734779] Using IPI No-Shortcut mode
[    6.734779] Using IPI No-Shortcut mode
[    6.745207] bootconsole [earlyser0] disabled
[    6.745207] bootconsole [earlyser0] disabled
[    6.746572] Loading compiled-in X.509 certificates
[    6.754699] Key type trusted registered
[    6.756188] Key type encrypted registered
[    6.760546] hd: no drives specified - use hd=3Dcyl,head,sectors on kerne=
l command line
[    6.763440] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.764330] EDD information not available.
[    6.766357] debug: unmapping init [mem 0xb1ea9000-0xb20b8fff]
[    6.771076] traps: init[1] general protection ip:a76b3b0d sp:affef7fd er=
ror:0
[    6.775516] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x0000000b
[    6.775516]=20
[    6.776114] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-rc7-next-2014032=
1 #9
[    6.776114] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.776114]  00000000 00000000 b014bdf4 b19a5b91 b1da1401 b014be14 b1998=
6f9 b1c6723c
[    6.776114]  b20d0540 00000001 b1da1401 b0150201 b0150000 b014be68 b1045=
c39 b1c67550
[    6.776114]  0000000b 0000000b b0150384 00000001 00000001 00000001 b0150=
000 b0150000
[    6.776114] Call Trace:
[    6.776114]  [<b19a5b91>] dump_stack+0x48/0x60
[    6.776114]  [<b19986f9>] panic+0x87/0x18e
[    6.776114]  [<b1045c39>] do_exit+0x7c9/0xaa0
[    6.776114]  [<b1045f9e>] do_group_exit+0x4e/0xb0
[    6.776114]  [<b10523b9>] get_signal_to_deliver+0x1b9/0x870
[    6.776114]  [<b1085dc0>] ? lock_release_holdtime.part.26+0xb0/0xf0
[    6.776114]  [<b1002c40>] ? do_alignment_check+0xa0/0xa0
[    6.776114]  [<b1001a6a>] do_signal+0x3a/0x9b0
[    6.776114]  [<b108ae5a>] ? do_raw_spin_unlock+0xaa/0xf0
[    6.776114]  [<b106c02f>] ? finish_task_switch+0xcf/0x120
[    6.776114]  [<b19ae1c0>] ? __schedule+0x410/0x8f0
[    6.776114]  [<b108ae5a>] ? do_raw_spin_unlock+0xaa/0xf0
[    6.776114]  [<b1050f07>] ? force_sig_info+0xa7/0xd0
[    6.776114]  [<b1051b64>] ? force_sig+0x14/0x20
[    6.776114]  [<b1002cb1>] ? do_general_protection+0x71/0x170
[    6.776114]  [<b1002c40>] ? do_alignment_check+0xa0/0xa0
[    6.776114]  [<b1002448>] do_notify_resume+0x68/0x70
[    6.776114]  [<b19b3e50>] work_notifysig+0x30/0x38
[    6.776114]  [<b1002c40>] ? do_alignment_check+0xa0/0xa0
[    6.776114] Kernel Offset: 0x0 from 0xb1000000 (relocation range: 0xb000=
0000-0xc47fdfff)

Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-x=
4-03230530/06ed26d1de59ce7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next=
-20140321 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug api=
c=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/i386-randconfig-x4-03230530/next:master/.vmlinuz-0=
6ed26d1de59ce7cbbe68378b7e470be169750e5-20140323053552-7-ivytown2 branch=3D=
next/master BOOT_IMAGE=3D/kernel/i386-randconfig-x4-03230530/06ed26d1de59ce=
7cbbe68378b7e470be169750e5/vmlinuz-3.14.0-rc7-next-20140321 drbd.minor_coun=
t=3D8'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -n=
et nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::42338-:22 -=
boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfil=
e /dev/shm/kboot/pid-quantal-ivytown2-93 -serial file:/dev/shm/kboot/serial=
-quantal-ivytown2-93 -daemonize -display none -monitor null=20

--IiVenqGWf+H9Y6IX
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-x4-03230530-06ed26d1de59ce7cbbe68378b7e470be169750e5-Kernel-panic---not-syncing:-Attempted-to-kill----exitcode--101813.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0w
MzIzMDUzMC9uZXh0Om1hc3RlcjozYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3
ZjUzY2NiOmJpc2VjdC1saW51eAoKMjAxNC0wMy0yMy0wNzozNDoyOCAzYjU1YzNjMGVjMmVi
M2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0wMzIz
MDUzMC0zYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvM2I1NWMz
YzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYgp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAz
MjMwNTMwLTNiNTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJh
bmRjb25maWcteDQtMDMyMzA1MzAtM2I1NWMzYzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcx
N2Y1M2NjYgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzNi
NTVjM2MwZWMyZWIzZjE2M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2Ivdm1saW51ei0zLjE0LjAt
cmM3LTEwNzEzLWczYjU1YzNjCgoyMDE0LTAzLTIzLTA3OjQzOjI4IGRldGVjdGluZyBib290
IHN0YXRlIAkxNCBURVNUIEZBSUxVUkUKWyAgICA3LjM5MjU5OF0gdHJhcHM6IGluaXRbMV0g
Z2VuZXJhbCBwcm90ZWN0aW9uIGlwOmE3NzViYjBkIHNwOmFmZDBkYTRkIGVycm9yOjAKWyAg
ICA3LjQwNTY1MF0gaW5wdXQ6IEltRXhQUy8yIEdlbmVyaWMgRXhwbG9yZXIgTW91c2UgYXMg
L2RldmljZXMvcGxhdGZvcm0vaTgwNDIvc2VyaW8xL2lucHV0L2lucHV0MwpbICAgIDcuNDEw
MzQyXSBpbml0ICgxKSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA1NDkyIGJ5dGVzIGxl
ZnQKWyAgICA3LjQxMTI4OV0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0dGVtcHRl
ZCB0byBraWxsIGluaXQhIGV4aXRjb2RlPTB4MDAwMDAwMGIKWyAgICA3LjQxMTI4OV0gClsg
ICAgNy40MTIyNTFdIENQVTogMCBQSUQ6IDEgQ29tbTogaW5pdCBOb3QgdGFpbnRlZCAzLjE0
LjAtcmM3LTEwNzEzLWczYjU1YzNjICMxClsgICAgNy40MTIyNTFdIEhhcmR3YXJlIG5hbWU6
IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICA3LjQxMjI1MV0gIDAw
MDAwMDAwIDAwMDAwMDAwIGIwMTRiZGY0IGIxOWExZjVjIGIxZDlkNDAxIGIwMTRiZTE0IGIx
OTk0ZDQ5IGIxYzYyMDAwClsgICAgNy40MTIyNTFdICBiMjBjYjU0MCAwMDAwMDAwMSBiMWQ5
ZDQwMSBiMDE1MDIwMSBiMDE1MDAwMCBiMDE0YmU2OCBiMTA0NWY2MiBiMWM2MjMyOApbICAg
IDcuNDEyMjUxXSAgMDAwMDAwMGIgMDAwMDAwMDEgMDAwMDE1NzQgMDAwMDAwMDEgMDAwMDAw
MDEgMDAwMDAwMDEgYjAxNTAwMDAgYjAxNTAwMDAKWyAgICA3LjQxMjI1MV0gQ2FsbCBUcmFj
ZToKWyAgICA3LjQxMjI1MV0gIFs8YjE5YTFmNWM+XSBkdW1wX3N0YWNrKzB4NDgvMHg2MApb
ICAgIDcuNDEyMjUxXSAgWzxiMTk5NGQ0OT5dIHBhbmljKzB4ODcvMHgxN2EKWyAgICA3LjQx
MjI1MV0gIFs8YjEwNDVmNjI+XSBkb19leGl0KzB4YWIyLzB4YWMwClsgICAgNy40MTIyNTFd
ICBbPGIxMDQ1ZmZlPl0gZG9fZ3JvdXBfZXhpdCsweDRlLzB4YjAKWyAgICA3LjQxMjI1MV0g
IFs8YjEwNTI0NDk+XSBnZXRfc2lnbmFsX3RvX2RlbGl2ZXIrMHgxYjkvMHg4NzAKWyAgICA3
LjQxMjI1MV0gIFs8YjEwNzQxNjM+XSA/IHNjaGVkX2Nsb2NrX2xvY2FsKzB4NzMvMHgxNjAK
WyAgICA3LjQxMjI1MV0gIFs8YjEwMDJjNDA+XSA/IGRvX2FsaWdubWVudF9jaGVjaysweGEw
LzB4YTAKWyAgICA3LjQxMjI1MV0gIFs8YjEwMDFhNmE+XSBkb19zaWduYWwrMHgzYS8weDli
MApbICAgIDcuNDEyMjUxXSAgWzxiMTA4NjBhMD5dID8gbG9ja19yZWxlYXNlX2hvbGR0aW1l
LnBhcnQuMjYrMHhiMC8weGYwClsgICAgNy40MTIyNTFdICBbPGIxMDRmZGI4Pl0gPyBzaWdu
YWxfd2FrZV91cF9zdGF0ZSsweDI4LzB4MzAKWyAgICA3LjQxMjI1MV0gIFs8YjE5OTUxNjg+
XSA/IGNvbXBsZXRlX3NpZ25hbCsweDEyZi8weDEzNgpbICAgIDcuNDEyMjUxXSAgWzxiMTA4
YWUyYT5dID8gZG9fcmF3X3NwaW5fdW5sb2NrKzB4YWEvMHhmMApbICAgIDcuNDEyMjUxXSAg
WzxiMTA1MGY5Nz5dID8gZm9yY2Vfc2lnX2luZm8rMHhhNy8weGQwClsgICAgNy40MTIyNTFd
ICBbPGIxMDUxYmY0Pl0gPyBmb3JjZV9zaWcrMHgxNC8weDIwClsgICAgNy40MTIyNTFdICBb
PGIxMDAyY2IxPl0gPyBkb19nZW5lcmFsX3Byb3RlY3Rpb24rMHg3MS8weDE3MApbICAgIDcu
NDEyMjUxXSAgWzxiMTAwMmM0MD5dID8gZG9fYWxpZ25tZW50X2NoZWNrKzB4YTAvMHhhMApb
ICAgIDcuNDEyMjUxXSAgWzxiMTAwMjQ0OD5dIGRvX25vdGlmeV9yZXN1bWUrMHg2OC8weDcw
ClsgICAgNy40MTIyNTFdICBbPGIxOWIwMjkwPl0gd29ya19ub3RpZnlzaWcrMHgzMC8weDM4
ClsgICAgNy40MTIyNTFdICBbPGIxMDAyYzQwPl0gPyBkb19hbGlnbm1lbnRfY2hlY2srMHhh
MC8weGEwClsgICAgNy40MTIyNTFdIEtlcm5lbCBPZmZzZXQ6IDB4MCBmcm9tIDB4YjEwMDAw
MDAgKHJlbG9jYXRpb24gcmFuZ2U6IDB4YjAwMDAwMDAtMHhjNDdmZGZmZikKCkVsYXBzZWQg
dGltZTogMzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvM2I1NWMzYzBl
YzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYi9kbWVzZy1xdWFudGFsLWl2eXRvd24y
LTI2OjIwMTQwMzIzMDc0MjU4OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAt
cmM3LTEwNzEzLWczYjU1YzNjOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1
MzAvM2I1NWMzYzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYi9kbWVzZy1xdWFu
dGFsLWl2eXRvd24yLTI4OjIwMTQwMzIzMDc0MjU4OmkzODYtcmFuZGNvbmZpZy14NC0wMzIz
MDUzMDozLjE0LjAtcmM3LTEwNzEzLWczYjU1YzNjOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDQtMDMyMzA1MzAvM2I1NWMzYzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2Nj
Yi9kbWVzZy1xdWFudGFsLWxrcC1zYjA0LTEwOjIwMTQwMzIzMTU0MjUzOmkzODYtcmFuZGNv
bmZpZy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LTEwNzEzLWczYjU1YzNjOjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvM2I1NWMzYzBlYzJlYjNmMTYzZjE1NTU5ZjM5
NjJkZjcxN2Y1M2NjYi9kbWVzZy15b2N0by1pdnl0b3duMi0zMzoyMDE0MDMyMzA3NDI1MDpp
Mzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy0xMDcxMy1nM2I1NWMzYzox
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzNiNTVjM2MwZWMyZWIzZjE2
M2YxNTU1OWYzOTYyZGY3MTdmNTNjY2IvZG1lc2cteW9jdG8taXZ5dG93bjItNjc6MjAxNDAz
MjMwNzQyNTI6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMTA3MTMt
ZzNiNTVjM2M6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8zYjU1YzNj
MGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNnLXlvY3RvLWl2eXRvd24y
LTkwOjIwMTQwMzIzMDc0MjUxOmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAt
cmM3LTEwNzEzLWczYjU1YzNjOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1
MzAvM2I1NWMzYzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYi9kbWVzZy1xdWFu
dGFsLWl2eXRvd24yLTU0OjIwMTQwMzIzMDc0MjU4OmkzODYtcmFuZGNvbmZpZy14NC0wMzIz
MDUzMDozLjE0LjAtcmM3LTEwNzEzLWczYjU1YzNjOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDQtMDMyMzA1MzAvM2I1NWMzYzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2Nj
Yi9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTc6MjAxNDAzMjMwNzQzMDE6aTM4Ni1yYW5kY29u
ZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMTA3MTMtZzNiNTVjM2M6MQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8zYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2
MmRmNzE3ZjUzY2NiL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItODc6MjAxNDAzMjMwNzQzMDI6
aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMTA3MTMtZzNiNTVjM2M6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8zYjU1YzNjMGVjMmViM2Yx
NjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItOTA6MjAx
NDAzMjMwNzQzMDA6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMTA3
MTMtZzNiNTVjM2M6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8zYjU1
YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNnLXF1YW50YWwtbGtw
LXNiMDQtMjA6MjAxNDAzMjMxNTQzMDI6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMu
MTQuMC1yYzctMTA3MTMtZzNiNTVjM2M6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0w
MzIzMDUzMC8zYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNn
LXF1YW50YWwtbGtwLXNiMDQtMzY6MjAxNDAzMjMxNTQzMDI6aTM4Ni1yYW5kY29uZmlnLXg0
LTAzMjMwNTMwOjMuMTQuMC1yYzctMTA3MTMtZzNiNTVjM2M6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14NC0wMzIzMDUzMC8zYjU1YzNjMGVjMmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3
ZjUzY2NiL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMTU6MjAxNDAzMjMwNzQzMDU6aTM4Ni1y
YW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMTA3MTMtZzNiNTVjM2M6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8zYjU1YzNjMGVjMmViM2YxNjNmMTU1
NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNnLXF1YW50YWwtbGtwLXNiMDQtMzk6MjAxNDAzMjMx
NTQzMTE6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMTA3MTMtZzNi
NTVjM2M6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8zYjU1YzNjMGVj
MmViM2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiL2RtZXNnLXF1YW50YWwtaXZ5dG93bjIt
MzI6MjAxNDAzMjMwNzQzMjI6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1y
YzctMTA3MTMtZzNiNTVjM2M6MQowOjE1OjI5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
ChtbMTszNW0yMDE0LTAzLTIzIDA3OjQ0OjA3IFJFUEVBVCBDT1VOVDogMjkgICMgL2tlcm5l
bC10ZXN0cy9saW51eC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21t
aXQgM2I1NWMzYzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYgpnaXQgY2hlY2tv
dXQgdjMuMTMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy14NC0wMzIzMDUzMC9uZXh0Om1hc3RlcjpkOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2
ZTg4MTQyMTBmMGU2NGJlOmJpc2VjdC1saW51eAoKMjAxNC0wMy0yMy0wNzo0NDo0MiBkOGVj
MjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy14NC0wMzIzMDUzMC1kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJl
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1
MzAvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLXg0LTAzMjMwNTMwLWQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0
YmUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
Ly5pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1
NmU4ODE0MjEwZjBlNjRiZQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAz
MjMwNTMwL2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvdm1saW51
ei0zLjEzLjAKCjIwMTQtMDMtMjMtMDc6NTI6NDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4J
MQkyNwkyOSBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IHYzLjEzCmdpdCBiaXNlY3Qg
c3RhcnQgM2I1NWMzYzBlYzJlYjNmMTYzZjE1NTU5ZjM5NjJkZjcxN2Y1M2NjYiB2My4xMyAt
LQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICIzYjU1YzNjMGVjMmVi
M2YxNjNmMTU1NTlmMzk2MmRmNzE3ZjUzY2NiIiwgIi1nIiwgInYzLjEzIiwgIi9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2tlcm5lbC10ZXN0cy9s
aW51eC9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAyMzkzMiByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTUgc3RlcHMpClszOTYyZGZiZTIyYThkNjVlNDE2
MjM1NGNjODU5NDQwMjkzZDg1NTI0XSBNZXJnZSBicmFuY2ggJ2Zvci1saW51cycgb2YgZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21hc29uL2xpbnV4
LWJ0cmZzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9uZXh0Om1hc3Rl
cjozOTYyZGZiZTIyYThkNjVlNDE2MjM1NGNjODU5NDQwMjkzZDg1NTI0OmJpc2VjdC1saW51
eAoKMjAxNC0wMy0yMy0wNzo1NjoyMCAzOTYyZGZiZTIyYThkNjVlNDE2MjM1NGNjODU5NDQw
MjkzZDg1NTI0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC0zOTYyZGZiZTIyYThk
NjVlNDE2MjM1NGNjODU5NDQwMjkzZDg1NTI0CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvMzk2MmRmYmUyMmE4ZDY1ZTQxNjIzNTRj
Yzg1OTQ0MDI5M2Q4NTUyNAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLTM5NjJkZmJlMjJh
OGQ2NWU0MTYyMzU0Y2M4NTk0NDAyOTNkODU1MjQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1
MzAtMzk2MmRmYmUyMmE4ZDY1ZTQxNjIzNTRjYzg1OTQ0MDI5M2Q4NTUyNAprZXJuZWw6IC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzM5NjJkZmJlMjJhOGQ2NWU0MTYy
MzU0Y2M4NTk0NDAyOTNkODU1MjQvdm1saW51ei0zLjE0LjAtcmMyLTAwNTQwLWczOTYyZGZi
CgoyMDE0LTAzLTIzLTA4OjA2OjIxIGRldGVjdGluZyBib290IHN0YXRlIC4uCTI1CTI5IFNV
Q0NFU1MKCkJpc2VjdGluZzogMTE4MDUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDE0IHN0ZXBzKQpbZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2Ni
YzQyOTE5MGYxNV0gTGludXggMy4xNC1yYzcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0
LTAzMjMwNTMwL25leHQ6bWFzdGVyOmRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0
MjkxOTBmMTU6YmlzZWN0LWxpbnV4CgoyMDE0LTAzLTIzLTA4OjA5OjE1IGRjYjk5ZmQ5YjA4
Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAz
MjMwNTMwLWRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9kY2I5
OWZkOWIwOGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDQt
MDMyMzA1MzAtZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNQp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYt
cmFuZGNvbmZpZy14NC0wMzIzMDUzMC1kY2I5OWZkOWIwOGNmZTFhZmU0MjZhZjRkOGQzY2Jj
NDI5MTkwZjE1Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAv
ZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNS92bWxpbnV6LTMuMTQu
MC1yYzcKCjIwMTQtMDMtMjMtMDg6MjU6MTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkyCTEw
LgkyMgkyNwkyOSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEwNzEzIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxNCBzdGVwcykKWzVhMDJiODg0OGFiNzgxNDhm
NDQyMTI2YzZjN2UzMjU1MzMyNmMwMGRdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J3RoZXJtYWwvbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL25l
eHQ6bWFzdGVyOjVhMDJiODg0OGFiNzgxNDhmNDQyMTI2YzZjN2UzMjU1MzMyNmMwMGQ6Ymlz
ZWN0LWxpbnV4CgoyMDE0LTAzLTIzLTA4OjI4OjU1IDVhMDJiODg0OGFiNzgxNDhmNDQyMTI2
YzZjN2UzMjU1MzMyNmMwMGQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLTVhMDJi
ODg0OGFiNzgxNDhmNDQyMTI2YzZjN2UzMjU1MzMyNmMwMGQKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC81YTAyYjg4NDhhYjc4MTQ4
ZjQ0MjEyNmM2YzdlMzI1NTMzMjZjMDBkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtNWEw
MmI4ODQ4YWI3ODE0OGY0NDIxMjZjNmM3ZTMyNTUzMzI2YzAwZAp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy14
NC0wMzIzMDUzMC01YTAyYjg4NDhhYjc4MTQ4ZjQ0MjEyNmM2YzdlMzI1NTMzMjZjMDBkCmtl
cm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvNWEwMmI4ODQ4YWI3
ODE0OGY0NDIxMjZjNmM3ZTMyNTUzMzI2YzAwZC92bWxpbnV6LTMuMTQuMC1yYzctMDMyNTQt
ZzVhMDJiODgKCjIwMTQtMDMtMjMtMDg6NDM6NTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4J
MS4uCTEyCTIxCTI5IFNVQ0NFU1MKCkJpc2VjdGluZzogNzQ1OSByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMgc3RlcHMpClsxYjg5Yjc0Y2MyMTJlMTM4
NzkzZDY4ODMyMWY4NDI0YTk2YTFjNTM0XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICdkdC1yaC9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMw
L25leHQ6bWFzdGVyOjFiODliNzRjYzIxMmUxMzg3OTNkNjg4MzIxZjg0MjRhOTZhMWM1MzQ6
YmlzZWN0LWxpbnV4CgoyMDE0LTAzLTIzLTA4OjQ4OjA5IDFiODliNzRjYzIxMmUxMzg3OTNk
Njg4MzIxZjg0MjRhOTZhMWM1MzQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLTFi
ODliNzRjYzIxMmUxMzg3OTNkNjg4MzIxZjg0MjRhOTZhMWM1MzQKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8xYjg5Yjc0Y2MyMTJl
MTM4NzkzZDY4ODMyMWY4NDI0YTk2YTFjNTM0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAt
MWI4OWI3NGNjMjEyZTEzODc5M2Q2ODgzMjFmODQyNGE5NmExYzUzNAp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZp
Zy14NC0wMzIzMDUzMC0xYjg5Yjc0Y2MyMTJlMTM4NzkzZDY4ODMyMWY4NDI0YTk2YTFjNTM0
Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvMWI4OWI3NGNj
MjEyZTEzODc5M2Q2ODgzMjFmODQyNGE5NmExYzUzNC92bWxpbnV6LTMuMTQuMC1yYzctMDcy
ODQtZzFiODliNzQKCjIwMTQtMDMtMjMtMDk6MDA6MTAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4uLi4JNQk5CTI5IFNVQ0NFU1MKCkJpc2VjdGluZzogMzQyOSByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCls2ZWNkNzc0Y2M3ZmY4YjE1
YTk1MGM4Mjc2MzBiODUyYzBkYzQ4YWIyXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICdjaGFyLW1pc2MvY2hhci1taXNjLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14
NC0wMzIzMDUzMC9uZXh0Om1hc3Rlcjo2ZWNkNzc0Y2M3ZmY4YjE1YTk1MGM4Mjc2MzBiODUy
YzBkYzQ4YWIyOmJpc2VjdC1saW51eAoKMjAxNC0wMy0yMy0wOTowNDozNCA2ZWNkNzc0Y2M3
ZmY4YjE1YTk1MGM4Mjc2MzBiODUyYzBkYzQ4YWIyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0w
MzIzMDUzMC02ZWNkNzc0Y2M3ZmY4YjE1YTk1MGM4Mjc2MzBiODUyYzBkYzQ4YWIyCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvNmVj
ZDc3NGNjN2ZmOGIxNWE5NTBjODI3NjMwYjg1MmMwZGM0OGFiMgp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0
LTAzMjMwNTMwLTZlY2Q3NzRjYzdmZjhiMTVhOTUwYzgyNzYzMGI4NTJjMGRjNDhhYjIKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2
LXJhbmRjb25maWcteDQtMDMyMzA1MzAtNmVjZDc3NGNjN2ZmOGIxNWE5NTBjODI3NjMwYjg1
MmMwZGM0OGFiMgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMw
LzZlY2Q3NzRjYzdmZjhiMTVhOTUwYzgyNzYzMGI4NTJjMGRjNDhhYjIvdm1saW51ei0zLjE0
LjAtcmM3LTEwMTM2LWc2ZWNkNzc0CgoyMDE0LTAzLTIzLTA5OjE5OjM1IGRldGVjdGluZyBi
b290IHN0YXRlIAkxLiBURVNUIEZBSUxVUkUKWyAgICAxLjk5MDM0OV0gZGVidWc6IHVubWFw
cGluZyBpbml0IFttZW0gMHhiMWVhMjAwMC0weGIyMGIxZmZmXQpbICAgIDEuOTkzMDI4XSB0
cmFwczogaW5pdFsxXSBnZW5lcmFsIHByb3RlY3Rpb24gaXA6YTc3YTliMGQgc3A6YWZmMGRk
MmQgZXJyb3I6MApbICAgIDEuOTk0MTkzXSBpbml0ICgxKSB1c2VkIGdyZWF0ZXN0IHN0YWNr
IGRlcHRoOiA1NTA4IGJ5dGVzIGxlZnQKWyAgICAxLjk5NDY4NV0gS2VybmVsIHBhbmljIC0g
bm90IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIGluaXQhIGV4aXRjb2RlPTB4MDAwMDAw
MGIKWyAgICAxLjk5NDY4NV0gClsgICAgMS45OTUwMjRdIENQVTogMCBQSUQ6IDEgQ29tbTog
aW5pdCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM3LTEwMTM2LWc2ZWNkNzc0ICMxClsgICAgMS45
OTUwMjRdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIw
MTEKWyAgICAxLjk5NTAyNF0gIDAwMDAwMDAwIDAwMDAwMDAwIGIwMTRiZGY0IGIxOWExZmNj
IGIxZDliNDAxIGIwMTRiZTE0IGIxOTk0ZGI5IGIxYzYxZDA0ClsgICAgMS45OTUwMjRdICBi
MjBjOTU0MCAwMDAwMDAwMSBiMWQ5YjQwMSBiMDE1MDIwMSBiMDE1MDAwMCBiMDE0YmU2OCBi
MTA0NWY2MiBiMWM2MjAyNApbICAgIDEuOTk1MDI0XSAgMDAwMDAwMGIgMDAwMDAwMDEgMDAw
MDE1ODQgMDAwMDAwMDEgMDAwMDAwMDEgMDAwMDAwMDEgYjAxNTAwMDAgYjAxNTAwMDAKWyAg
ICAxLjk5NTAyNF0gQ2FsbCBUcmFjZToKWyAgICAxLjk5NTAyNF0gIFs8YjE5YTFmY2M+XSBk
dW1wX3N0YWNrKzB4NDgvMHg2MApbICAgIDEuOTk1MDI0XSAgWzxiMTk5NGRiOT5dIHBhbmlj
KzB4ODcvMHgxN2EKWyAgICAxLjk5NTAyNF0gIFs8YjEwNDVmNjI+XSBkb19leGl0KzB4YWIy
LzB4YWMwClsgICAgMS45OTUwMjRdICBbPGIxMDQ1ZmZlPl0gZG9fZ3JvdXBfZXhpdCsweDRl
LzB4YjAKWyAgICAxLjk5NTAyNF0gIFs8YjEwNTI0NDk+XSBnZXRfc2lnbmFsX3RvX2RlbGl2
ZXIrMHgxYjkvMHg4NzAKWyAgICAxLjk5NTAyNF0gIFs8YjEwNzQxZTM+XSA/IHNjaGVkX2Ns
b2NrX2xvY2FsKzB4NzMvMHgxNjAKWyAgICAxLjk5NTAyNF0gIFs8YjEwMDJjNDA+XSA/IGRv
X2FsaWdubWVudF9jaGVjaysweGEwLzB4YTAKWyAgICAxLjk5NTAyNF0gIFs8YjEwMDFhNmE+
XSBkb19zaWduYWwrMHgzYS8weDliMApbICAgIDEuOTk1MDI0XSAgWzxiMTA4NjEyMD5dID8g
bG9ja19yZWxlYXNlX2hvbGR0aW1lLnBhcnQuMjYrMHhiMC8weGYwClsgICAgMS45OTUwMjRd
ICBbPGIxMDRmZGI4Pl0gPyBzaWduYWxfd2FrZV91cF9zdGF0ZSsweDI4LzB4MzAKWyAgICAx
Ljk5NTAyNF0gIFs8YjE5OTUxZDg+XSA/IGNvbXBsZXRlX3NpZ25hbCsweDEyZi8weDEzNgpb
ICAgIDEuOTk1MDI0XSAgWzxiMTA4YWVhYT5dID8gZG9fcmF3X3NwaW5fdW5sb2NrKzB4YWEv
MHhmMApbICAgIDEuOTk1MDI0XSAgWzxiMTA1MGY5Nz5dID8gZm9yY2Vfc2lnX2luZm8rMHhh
Ny8weGQwClsgICAgMS45OTUwMjRdICBbPGIxMDUxYmY0Pl0gPyBmb3JjZV9zaWcrMHgxNC8w
eDIwClsgICAgMS45OTUwMjRdICBbPGIxMDAyY2IxPl0gPyBkb19nZW5lcmFsX3Byb3RlY3Rp
b24rMHg3MS8weDE3MApbICAgIDEuOTk1MDI0XSAgWzxiMTAwMmM0MD5dID8gZG9fYWxpZ25t
ZW50X2NoZWNrKzB4YTAvMHhhMApbICAgIDEuOTk1MDI0XSAgWzxiMTAwMjQ0OD5dIGRvX25v
dGlmeV9yZXN1bWUrMHg2OC8weDcwClsgICAgMS45OTUwMjRdICBbPGIxOWIwMzAwPl0gd29y
a19ub3RpZnlzaWcrMHgzMC8weDM4ClsgICAgMS45OTUwMjRdICBbPGIxMDAyYzQwPl0gPyBk
b19hbGlnbm1lbnRfY2hlY2srMHhhMC8weGEwClsgICAgMS45OTUwMjRdIEtlcm5lbCBPZmZz
ZXQ6IDB4MCBmcm9tIDB4YjEwMDAwMDAgKHJlbG9jYXRpb24gcmFuZ2U6IDB4YjAwMDAwMDAt
MHhjNDdmZGZmZikKCkVsYXBzZWQgdGltZTogMTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDQtMDMyMzA1MzAvNmVjZDc3NGNjN2ZmOGIxNWE5NTBjODI3NjMwYjg1MmMwZGM0OGFiMi9k
bWVzZy1xdWFudGFsLWxrcC1zYjA0LTI4OjIwMTQwMzIzMTcxOTQ1OmkzODYtcmFuZGNvbmZp
Zy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LTEwMTM2LWc2ZWNkNzc0OjEKMDoxOjIgYWxsX2dv
b2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMjMgMDk6MjA6MzcgUkVQRUFU
IENPVU5UOiAzMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QvLnJlcGVhdBtb
MG0KCkJpc2VjdGluZzogMjg1MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMTIgc3RlcHMpCltkOGJlMDNhYThiZjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQz
YTQxOGZlXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdwZXJjcHUvZm9yLW5leHQn
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
a2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9uZXh0Om1hc3RlcjpkOGJl
MDNhYThiZjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQzYTQxOGZlOmJpc2VjdC1saW51eAoKMjAx
NC0wMy0yMy0wOToyMDozOSBkOGJlMDNhYThiZjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQzYTQx
OGZlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC1kOGJlMDNhYThiZjc1NGZhMGVj
M2EyMDg4NWEyMzg3ZTQzYTQxOGZlCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDQtMDMyMzA1MzAvZDhiZTAzYWE4YmY3NTRmYTBlYzNhMjA4ODVhMjM4
N2U0M2E0MThmZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLWQ4YmUwM2FhOGJmNzU0ZmEw
ZWMzYTIwODg1YTIzODdlNDNhNDE4ZmUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtZDhi
ZTAzYWE4YmY3NTRmYTBlYzNhMjA4ODVhMjM4N2U0M2E0MThmZQprZXJuZWw6IC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL2Q4YmUwM2FhOGJmNzU0ZmEwZWMzYTIwODg1
YTIzODdlNDNhNDE4ZmUvdm1saW51ei0zLjE0LjAtcmM3LTA4MTkzLWdkOGJlMDNhCgoyMDE0
LTAzLTIzLTA5OjM5OjQwIGRldGVjdGluZyBib290IHN0YXRlIAk3IFRFU1QgRkFJTFVSRQpb
ICAgIDIuNjUxMjYwXSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAweGIxZWEyMDAwLTB4
YjIwYjFmZmZdClsgICAgMi42NTQ2MzJdIHRyYXBzOiBpbml0WzFdIGdlbmVyYWwgcHJvdGVj
dGlvbiBpcDphNzc5NGIwZCBzcDphZmY2OTAzZCBlcnJvcjowClsgICAgMi42NTYyMDldIGlu
aXQgKDEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDU1MDggYnl0ZXMgbGVmdApbICAg
IDIuNjU2ODU3XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQXR0ZW1wdGVkIHRvIGtp
bGwgaW5pdCEgZXhpdGNvZGU9MHgwMDAwMDAwYgpbICAgIDIuNjU2ODU3XSAKWyAgICAyLjY1
NzAxNl0gQ1BVOiAxIFBJRDogMSBDb21tOiBpbml0IE5vdCB0YWludGVkIDMuMTQuMC1yYzct
MDgxOTMtZ2Q4YmUwM2EgIzEKWyAgICAyLjY1NzAxNl0gSGFyZHdhcmUgbmFtZTogQm9jaHMg
Qm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuNjU3MDE2XSAgMDAwMDAwMDAg
MDAwMDAwMDAgYjAwN2JkZjQgYjE5YTBlNmMgYjFkOWI0MDEgYjAwN2JlMTQgYjE5OTNjNTkg
YjFjNjAyNTgKWyAgICAyLjY1NzAxNl0gIGIyMGM5NTQwIDAwMDAwMDAxIGIxZDliNDAxIGIw
MTQwMjAxIGIwMTQwMDAwIGIwMDdiZTY4IGIxMDQ2MGEyIGIxYzYwNTgwClsgICAgMi42NjAw
NDldICAwMDAwMDAwYiAwMDAwMDAwMSAwMDAwMTU4NCAwMDAwMDAwMSAwMDAwMDAwMSAwMDAw
MDAwMSBiMDE0MDAwMCBiMDE0MDAwMApbICAgIDIuNjYwMDQ5XSBDYWxsIFRyYWNlOgpbICAg
IDIuNjYwMDQ5XSAgWzxiMTlhMGU2Yz5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAgMi42
NjAwNDldICBbPGIxOTkzYzU5Pl0gcGFuaWMrMHg4Ny8weDE3YQpbICAgIDIuNjYwMDQ5XSAg
WzxiMTA0NjBhMj5dIGRvX2V4aXQrMHhhYjIvMHhhYzAKWyAgICAyLjY2MDA0OV0gIFs8YjEw
NDYxM2U+XSBkb19ncm91cF9leGl0KzB4NGUvMHhiMApbICAgIDIuNjYwMDQ5XSAgWzxiMTA1
MjU4OT5dIGdldF9zaWduYWxfdG9fZGVsaXZlcisweDFiOS8weDg3MApbICAgIDIuNjYwMDQ5
XSAgWzxiMTA3NDMyMz5dID8gc2NoZWRfY2xvY2tfbG9jYWwrMHg3My8weDE2MApbICAgIDIu
NjYwMDQ5XSAgWzxiMTAwMmM0MD5dID8gZG9fYWxpZ25tZW50X2NoZWNrKzB4YTAvMHhhMApb
ICAgIDIuNjYwMDQ5XSAgWzxiMTAwMWE2YT5dIGRvX3NpZ25hbCsweDNhLzB4OWIwClsgICAg
Mi42NjAwNDldICBbPGIxMDg2MjYwPl0gPyBsb2NrX3JlbGVhc2VfaG9sZHRpbWUucGFydC4y
NisweGIwLzB4ZjAKWyAgICAyLjY2MDA0OV0gIFs8YjEwNGZlZjg+XSA/IHNpZ25hbF93YWtl
X3VwX3N0YXRlKzB4MjgvMHgzMApbICAgIDIuNjYwMDQ5XSAgWzxiMTk5NDA3OD5dID8gY29t
cGxldGVfc2lnbmFsKzB4MTJmLzB4MTM2ClsgICAgMi42NjAwNDldICBbPGIxMDhhZmVhPl0g
PyBkb19yYXdfc3Bpbl91bmxvY2srMHhhYS8weGYwClsgICAgMi42NjAwNDldICBbPGIxMDUx
MGQ3Pl0gPyBmb3JjZV9zaWdfaW5mbysweGE3LzB4ZDAKWyAgICAyLjY2MDA0OV0gIFs8YjEw
NTFkMzQ+XSA/IGZvcmNlX3NpZysweDE0LzB4MjAKWyAgICAyLjY2MDA0OV0gIFs8YjEwMDJj
YjE+XSA/IGRvX2dlbmVyYWxfcHJvdGVjdGlvbisweDcxLzB4MTcwClsgICAgMi42NjAwNDld
ICBbPGIxMDAyYzQwPl0gPyBkb19hbGlnbm1lbnRfY2hlY2srMHhhMC8weGEwClsgICAgMi42
NjAwNDldICBbPGIxMDAyNDQ4Pl0gZG9fbm90aWZ5X3Jlc3VtZSsweDY4LzB4NzAKWyAgICAy
LjY2MDA0OV0gIFs8YjE5YWVmZjA+XSB3b3JrX25vdGlmeXNpZysweDMwLzB4MzgKWyAgICAy
LjY2MDA0OV0gIFs8YjEwMDJjNDA+XSA/IGRvX2FsaWdubWVudF9jaGVjaysweGEwLzB4YTAK
WyAgICAyLjY2MDA0OV0gS2VybmVsIE9mZnNldDogMHgwIGZyb20gMHhiMTAwMDAwMCAocmVs
b2NhdGlvbiByYW5nZTogMHhiMDAwMDAwMC0weGM0N2ZkZmZmKQoKRWxhcHNlZCB0aW1lOiAx
MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9kOGJlMDNhYThiZjc1NGZh
MGVjM2EyMDg4NWEyMzg3ZTQzYTQxOGZlL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItNjY6MjAx
NDAzMjMwOTM5MTQ6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMDgx
OTMtZ2Q4YmUwM2E6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9kOGJl
MDNhYThiZjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQzYTQxOGZlL2RtZXNnLXF1YW50YWwtbGtw
LXNiMDQtMzM6MjAxNDAzMjMxNzM5MjM6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMu
MTQuMC1yYzctMDgxOTMtZ2Q4YmUwM2E6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0w
MzIzMDUzMC9kOGJlMDNhYThiZjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQzYTQxOGZlL2RtZXNn
LXF1YW50YWwtaXZ5dG93bjItMTY6MjAxNDAzMjMwOTM5MjQ6aTM4Ni1yYW5kY29uZmlnLXg0
LTAzMjMwNTMwOjMuMTQuMC1yYzctMDgxOTMtZ2Q4YmUwM2E6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14NC0wMzIzMDUzMC9kOGJlMDNhYThiZjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQz
YTQxOGZlL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItNTA6MjAxNDAzMjMwOTM5MzY6aTM4Ni1y
YW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMDgxOTMtZ2Q4YmUwM2E6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9kOGJlMDNhYThiZjc1NGZhMGVjM2Ey
MDg4NWEyMzg3ZTQzYTQxOGZlL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItNTQ6MjAxNDAzMjMw
OTM5Mzg6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMDgxOTMtZ2Q4
YmUwM2E6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9kOGJlMDNhYThi
Zjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQzYTQxOGZlL2RtZXNnLXF1YW50YWwtbGtwLXNiMDQt
Mjg6MjAxNDAzMjMxNzM5Mzg6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1y
YzctMDgxOTMtZ2Q4YmUwM2E6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUz
MC9kOGJlMDNhYThiZjc1NGZhMGVjM2EyMDg4NWEyMzg3ZTQzYTQxOGZlL2RtZXNnLXlvY3Rv
LWl2eXRvd24yLTQ2OjIwMTQwMzIzMDkzOTM1OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUz
MDozLjE0LjAtcmM3LTA4MTkzLWdkOGJlMDNhOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDQtMDMyMzA1MzAvZDhiZTAzYWE4YmY3NTRmYTBlYzNhMjA4ODVhMjM4N2U0M2E0MThmZS9k
bWVzZy1xdWFudGFsLWl2eXRvd24yLTY2OjIwMTQwMzIzMDkzOTQwOmkzODYtcmFuZGNvbmZp
Zy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LTA4MTkzLWdkOGJlMDNhOjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDQtMDMyMzA1MzAvZDhiZTAzYWE4YmY3NTRmYTBlYzNhMjA4ODVhMjM4
N2U0M2E0MThmZS9kbWVzZy15b2N0by1pdnl0b3duMi01OToyMDE0MDMyMzA5MzkzOTppMzg2
LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy0wODE5My1nZDhiZTAzYToxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL2Q4YmUwM2FhOGJmNzU0ZmEwZWMz
YTIwODg1YTIzODdlNDNhNDE4ZmUvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xNjoyMDE0MDMy
MzA5Mzk1MDppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy0wODE5My1n
ZDhiZTAzYToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL2Q4YmUwM2Fh
OGJmNzU0ZmEwZWMzYTIwODg1YTIzODdlNDNhNDE4ZmUvZG1lc2ctcXVhbnRhbC1pdnl0b3du
Mi01NDoyMDE0MDMyMzA5Mzk1MzppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4w
LXJjNy0wODE5My1nZDhiZTAzYToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMw
NTMwL2Q4YmUwM2FhOGJmNzU0ZmEwZWMzYTIwODg1YTIzODdlNDNhNDE4ZmUvZG1lc2ctcXVh
bnRhbC1sa3Atc2IwNC0zMToyMDE0MDMyMzE3Mzk0OTppMzg2LXJhbmRjb25maWcteDQtMDMy
MzA1MzA6My4xNC4wLXJjNy0wODE5My1nZDhiZTAzYToxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXg0LTAzMjMwNTMwL2Q4YmUwM2FhOGJmNzU0ZmEwZWMzYTIwODg1YTIzODdlNDNhNDE4
ZmUvZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC0zNDoyMDE0MDMyMzE3Mzk1NTppMzg2LXJhbmRj
b25maWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy0wODE5My1nZDhiZTAzYToxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL2Q4YmUwM2FhOGJmNzU0ZmEwZWMzYTIwODg1
YTIzODdlNDNhNDE4ZmUvZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC03OjIwMTQwMzIzMTczOTUz
OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LTA4MTkzLWdkOGJlMDNh
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvZDhiZTAzYWE4YmY3NTRm
YTBlYzNhMjA4ODVhMjM4N2U0M2E0MThmZS9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTIwOjIw
MTQwMzIzMDkzOTU2OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LTA4
MTkzLWdkOGJlMDNhOjEKMDoxNToxNiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlz
ZWN0aW5nOiA5MDkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDEwIHN0ZXBzKQpbMGU1NmM5MGMxMzJiNjQ0MjdjOGM1NWZkODUwMDNlYzFmMTdkYmE2ZF0g
TWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnZWRhYy1hbWQvZm9yLW5leHQnCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVs
LXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9uZXh0Om1hc3RlcjowZTU2YzkwYzEz
MmI2NDQyN2M4YzU1ZmQ4NTAwM2VjMWYxN2RiYTZkOmJpc2VjdC1saW51eAoKMjAxNC0wMy0y
My0wOTo0MDozNCAwZTU2YzkwYzEzMmI2NDQyN2M4YzU1ZmQ4NTAwM2VjMWYxN2RiYTZkIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC0wZTU2YzkwYzEzMmI2NDQyN2M4YzU1ZmQ4
NTAwM2VjMWYxN2RiYTZkCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDMyMzA1MzAvMGU1NmM5MGMxMzJiNjQ0MjdjOGM1NWZkODUwMDNlYzFmMTdk
YmE2ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLTBlNTZjOTBjMTMyYjY0NDI3YzhjNTVm
ZDg1MDAzZWMxZjE3ZGJhNmQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtMGU1NmM5MGMx
MzJiNjQ0MjdjOGM1NWZkODUwMDNlYzFmMTdkYmE2ZAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXg0LTAzMjMwNTMwLzBlNTZjOTBjMTMyYjY0NDI3YzhjNTVmZDg1MDAzZWMx
ZjE3ZGJhNmQvdm1saW51ei0zLjE0LjAtcmM3LTA4MDQ4LWcwZTU2YzkwCgoyMDE0LTAzLTIz
LTA5OjU5OjM1IGRldGVjdGluZyBib290IHN0YXRlIAkyIFRFU1QgRkFJTFVSRQpbICAgIDIu
NjM0ODY4XSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAweGIxZWI0MDAwLTB4YjIwYzRm
ZmZdClsgICAgMi42MzgxODJdIHRyYXBzOiBpbml0WzFdIGdlbmVyYWwgcHJvdGVjdGlvbiBp
cDphNzc1ZmIwZCBzcDphZmYxYjE4ZCBlcnJvcjowClsgICAgMi42Mzk3MDJdIGluaXQgKDEp
IHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDU1MDggYnl0ZXMgbGVmdApbICAgIDIuNjQw
MzMzXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQXR0ZW1wdGVkIHRvIGtpbGwgaW5p
dCEgZXhpdGNvZGU9MHgwMDAwMDAwYgpbICAgIDIuNjQwMzMzXSAKWyAgICAyLjY0MTIxM10g
Q1BVOiAwIFBJRDogMSBDb21tOiBpbml0IE5vdCB0YWludGVkIDMuMTQuMC1yYzctMDgwNDgt
ZzBlNTZjOTAgIzEKWyAgICAyLjY0MTI4OV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMs
IEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuNjQxMjg5XSAgMDAwMDAwMDAgMDAwMDAw
MDAgYjAwN2JkZjQgYjE5YjM4MjggYjFkYWQ0MDEgYjAwN2JlMTQgYjE5YTY2MjkgYjFjNzIw
YjgKWyAgICAyLjY0MTI4OV0gIGIyMGRjNTQwIDAwMDAwMDAxIGIxZGFkNDAxIGIwMTQwMjAx
IGIwMTQwMDAwIGIwMDdiZTY4IGIxMDQ2NWIyIGIxYzcyM2UwClsgICAgMi42NDEyODldICAw
MDAwMDAwYiAwMDAwMDAwMSAwMDAwMTU4NCAwMDAwMDAwMSAwMDAwMDAwMSAwMDAwMDAwMSBi
MDE0MDAwMCBiMDE0MDAwMApbICAgIDIuNjQxMjg5XSBDYWxsIFRyYWNlOgpbICAgIDIuNjQx
Mjg5XSAgWzxiMTliMzgyOD5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAgMi42NDEyODld
ICBbPGIxOWE2NjI5Pl0gcGFuaWMrMHg4Ny8weDE3YQpbICAgIDIuNjQxMjg5XSAgWzxiMTA0
NjViMj5dIGRvX2V4aXQrMHhhYjIvMHhhYzAKWyAgICAyLjY0MTI4OV0gIFs8YjEwNDY2NGU+
XSBkb19ncm91cF9leGl0KzB4NGUvMHhiMApbICAgIDIuNjQxMjg5XSAgWzxiMTA1MzQ4OT5d
IGdldF9zaWduYWxfdG9fZGVsaXZlcisweDFiOS8weDg3MApbICAgIDIuNjQxMjg5XSAgWzxi
MTA3NWU3Mz5dID8gc2NoZWRfY2xvY2tfbG9jYWwrMHg3My8weDE2MApbICAgIDIuNjQxMjg5
XSAgWzxiMTAwMmM0MD5dID8gZG9fYWxpZ25tZW50X2NoZWNrKzB4YTAvMHhhMApbICAgIDIu
NjQxMjg5XSAgWzxiMTAwMWE2YT5dIGRvX3NpZ25hbCsweDNhLzB4OWIwClsgICAgMi42NDEy
ODldICBbPGIxMDg3ZjYwPl0gPyBsb2NrX3JlbGVhc2VfaG9sZHRpbWUucGFydC4yNisweGIw
LzB4ZjAKWyAgICAyLjY0MTI4OV0gIFs8YjEwNTBkZjg+XSA/IHNpZ25hbF93YWtlX3VwX3N0
YXRlKzB4MjgvMHgzMApbICAgIDIuNjQxMjg5XSAgWzxiMTlhNmE0OD5dID8gY29tcGxldGVf
c2lnbmFsKzB4MTJmLzB4MTM2ClsgICAgMi42NDEyODldICBbPGIxMDhjY2VhPl0gPyBkb19y
YXdfc3Bpbl91bmxvY2srMHhhYS8weGYwClsgICAgMi42NDEyODldICBbPGIxMDUxZmQ3Pl0g
PyBmb3JjZV9zaWdfaW5mbysweGE3LzB4ZDAKWyAgICAyLjY0MTI4OV0gIFs8YjEwNTJjMzQ+
XSA/IGZvcmNlX3NpZysweDE0LzB4MjAKWyAgICAyLjY0MTI4OV0gIFs8YjEwMDJjYjE+XSA/
IGRvX2dlbmVyYWxfcHJvdGVjdGlvbisweDcxLzB4MTcwClsgICAgMi42NDEyODldICBbPGIx
MDAyYzQwPl0gPyBkb19hbGlnbm1lbnRfY2hlY2srMHhhMC8weGEwClsgICAgMi42NDEyODld
ICBbPGIxMDAyNDQ4Pl0gZG9fbm90aWZ5X3Jlc3VtZSsweDY4LzB4NzAKWyAgICAyLjY0MTI4
OV0gIFs8YjE5YzE5YjA+XSB3b3JrX25vdGlmeXNpZysweDMwLzB4MzgKWyAgICAyLjY0MTI4
OV0gIFs8YjEwMDJjNDA+XSA/IGRvX2FsaWdubWVudF9jaGVjaysweGEwLzB4YTAKWyAgICAy
LjY0MTI4OV0gS2VybmVsIE9mZnNldDogMHgwIGZyb20gMHhiMTAwMDAwMCAocmVsb2NhdGlv
biByYW5nZTogMHhiMDAwMDAwMC0weGM0N2ZkZmZmKQoKRWxhcHNlZCB0aW1lOiAxMAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8wZTU2YzkwYzEzMmI2NDQyN2M4YzU1
ZmQ4NTAwM2VjMWYxN2RiYTZkL2RtZXNnLXlvY3RvLXhpYW4tMjY6MjAxNDAzMjMwOTU5MjU6
aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMDgwNDgtZzBlNTZjOTA6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8wZTU2YzkwYzEzMmI2NDQy
N2M4YzU1ZmQ4NTAwM2VjMWYxN2RiYTZkL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItNjI6MjAx
NDAzMjMwOTU5MzY6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMDgw
NDgtZzBlNTZjOTA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8wZTU2
YzkwYzEzMmI2NDQyN2M4YzU1ZmQ4NTAwM2VjMWYxN2RiYTZkL2RtZXNnLXF1YW50YWwtaXZ5
dG93bjItNjI6MjAxNDAzMjMwOTU5NTA6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMu
MTQuMC1yYzctMDgwNDgtZzBlNTZjOTA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0w
MzIzMDUzMC8wZTU2YzkwYzEzMmI2NDQyN2M4YzU1ZmQ4NTAwM2VjMWYxN2RiYTZkL2RtZXNn
LXF1YW50YWwtbGtwLXNiMDQtMTY6MjAxNDAzMjMxNzU5NTE6aTM4Ni1yYW5kY29uZmlnLXg0
LTAzMjMwNTMwOjMuMTQuMC1yYzctMDgwNDgtZzBlNTZjOTA6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14NC0wMzIzMDUzMC8wZTU2YzkwYzEzMmI2NDQyN2M4YzU1ZmQ4NTAwM2VjMWYx
N2RiYTZkL2RtZXNnLXF1YW50YWwtbGtwLXNiMDQtMjY6MjAxNDAzMjMxNzU5NDc6aTM4Ni1y
YW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMDgwNDgtZzBlNTZjOTA6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8wZTU2YzkwYzEzMmI2NDQyN2M4YzU1
ZmQ4NTAwM2VjMWYxN2RiYTZkL2RtZXNnLXF1YW50YWwtamFrZXRvd24tMzI6MjAxNDAzMjMw
OTU5NTI6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjoKMDo2OjQgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogNzY0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKWzY3YWUzYjM2Nzk0ZGU2OWQ1OGU2NmZi
NTBiZTBmYTBkNjg1NzRjMTddIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3RpcC9h
dXRvLWxhdGVzdCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL25leHQ6
bWFzdGVyOjY3YWUzYjM2Nzk0ZGU2OWQ1OGU2NmZiNTBiZTBmYTBkNjg1NzRjMTc6YmlzZWN0
LWxpbnV4CgoyMDE0LTAzLTIzLTEwOjAwOjI4IDY3YWUzYjM2Nzk0ZGU2OWQ1OGU2NmZiNTBi
ZTBmYTBkNjg1NzRjMTcgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLTY3YWUzYjM2
Nzk0ZGU2OWQ1OGU2NmZiNTBiZTBmYTBkNjg1NzRjMTcKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC82N2FlM2IzNjc5NGRlNjlkNThl
NjZmYjUwYmUwZmEwZDY4NTc0YzE3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtNjdhZTNi
MzY3OTRkZTY5ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNwp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy14NC0w
MzIzMDUzMC02N2FlM2IzNjc5NGRlNjlkNThlNjZmYjUwYmUwZmEwZDY4NTc0YzE3Cmtlcm5l
bDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvNjdhZTNiMzY3OTRkZTY5
ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNy92bWxpbnV6LTMuMTQuMC1yYzctMDgwMzAtZzY3
YWUzYjMKCjIwMTQtMDMtMjMtMTA6MTQ6MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEwIFRF
U1QgRkFJTFVSRQpbICAgIDIuNzYzOTQ2XSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAw
eGIxZWI0MDAwLTB4YjIwYzRmZmZdClsgICAgMi43Njc1MjddIHRyYXBzOiBpbml0WzFdIGdl
bmVyYWwgcHJvdGVjdGlvbiBpcDphNzZjOWIwZCBzcDphZmJiYzIyZCBlcnJvcjowClsgICAg
Mi43NjkxMTFdIGluaXQgKDEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDU1MDggYnl0
ZXMgbGVmdApbICAgIDIuNzY5NzQ5XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQXR0
ZW1wdGVkIHRvIGtpbGwgaW5pdCEgZXhpdGNvZGU9MHgwMDAwMDAwYgpbICAgIDIuNzY5NzQ5
XSAKWyAgICAyLjc3MDAxNF0gQ1BVOiAwIFBJRDogMSBDb21tOiBpbml0IE5vdCB0YWludGVk
IDMuMTQuMC1yYzctMDgwMzAtZzY3YWUzYjMgIzEKWyAgICAyLjc3MDAxNF0gSGFyZHdhcmUg
bmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuNzcwMDE0
XSAgMDAwMDAwMDAgMDAwMDAwMDAgYjAwN2JkZjQgYjE5YjM4MjggYjFkYWQ0MDEgYjAwN2Jl
MTQgYjE5YTY2MjkgYjFjNzIwYjgKWyAgICAyLjc3MDAxNF0gIGIyMGRjNTQwIDAwMDAwMDAx
IGIxZGFkNDAxIGIwMTQwMjAxIGIwMTQwMDAwIGIwMDdiZTY4IGIxMDQ2NWIyIGIxYzcyM2Uw
ClsgICAgMi43NzAwMTRdICAwMDAwMDAwYiAwMDAwMDAwMSAwMDAwMTU4NCAwMDAwMDAwMSAw
MDAwMDAwMSAwMDAwMDAwMSBiMDE0MDAwMCBiMDE0MDAwMApbICAgIDIuNzcwMDE0XSBDYWxs
IFRyYWNlOgpbICAgIDIuNzcwMDE0XSAgWzxiMTliMzgyOD5dIGR1bXBfc3RhY2srMHg0OC8w
eDYwClsgICAgMi43NzAwMTRdICBbPGIxOWE2NjI5Pl0gcGFuaWMrMHg4Ny8weDE3YQpbICAg
IDIuNzcwMDE0XSAgWzxiMTA0NjViMj5dIGRvX2V4aXQrMHhhYjIvMHhhYzAKWyAgICAyLjc3
MDAxNF0gIFs8YjEwNDY2NGU+XSBkb19ncm91cF9leGl0KzB4NGUvMHhiMApbICAgIDIuNzcw
MDE0XSAgWzxiMTA1MzQ4OT5dIGdldF9zaWduYWxfdG9fZGVsaXZlcisweDFiOS8weDg3MApb
ICAgIDIuNzcwMDE0XSAgWzxiMTA3NWU3Mz5dID8gc2NoZWRfY2xvY2tfbG9jYWwrMHg3My8w
eDE2MApbICAgIDIuNzcwMDE0XSAgWzxiMTAwMmM0MD5dID8gZG9fYWxpZ25tZW50X2NoZWNr
KzB4YTAvMHhhMApbICAgIDIuNzcwMDE0XSAgWzxiMTAwMWE2YT5dIGRvX3NpZ25hbCsweDNh
LzB4OWIwClsgICAgMi43NzAwMTRdICBbPGIxMDg3ZjYwPl0gPyBsb2NrX3JlbGVhc2VfaG9s
ZHRpbWUucGFydC4yNisweGIwLzB4ZjAKWyAgICAyLjc3MDAxNF0gIFs8YjEwNTBkZjg+XSA/
IHNpZ25hbF93YWtlX3VwX3N0YXRlKzB4MjgvMHgzMApbICAgIDIuNzcwMDE0XSAgWzxiMTlh
NmE0OD5dID8gY29tcGxldGVfc2lnbmFsKzB4MTJmLzB4MTM2ClsgICAgMi43NzAwMTRdICBb
PGIxMDhjY2VhPl0gPyBkb19yYXdfc3Bpbl91bmxvY2srMHhhYS8weGYwClsgICAgMi43NzAw
MTRdICBbPGIxMDUxZmQ3Pl0gPyBmb3JjZV9zaWdfaW5mbysweGE3LzB4ZDAKWyAgICAyLjc3
MDAxNF0gIFs8YjEwNTJjMzQ+XSA/IGZvcmNlX3NpZysweDE0LzB4MjAKWyAgICAyLjc3MDAx
NF0gIFs8YjEwMDJjYjE+XSA/IGRvX2dlbmVyYWxfcHJvdGVjdGlvbisweDcxLzB4MTcwClsg
ICAgMi43NzAwMTRdICBbPGIxMDAyYzQwPl0gPyBkb19hbGlnbm1lbnRfY2hlY2srMHhhMC8w
eGEwClsgICAgMi43NzAwMTRdICBbPGIxMDAyNDQ4Pl0gZG9fbm90aWZ5X3Jlc3VtZSsweDY4
LzB4NzAKWyAgICAyLjc3MDAxNF0gIFs8YjE5YzE5YjA+XSB3b3JrX25vdGlmeXNpZysweDMw
LzB4MzgKWyAgICAyLjc3MDAxNF0gIFs8YjEwMDJjNDA+XSA/IGRvX2FsaWdubWVudF9jaGVj
aysweGEwLzB4YTAKWyAgICAyLjc3MDAxNF0gS2VybmVsIE9mZnNldDogMHgwIGZyb20gMHhi
MTAwMDAwMCAocmVsb2NhdGlvbiByYW5nZTogMHhiMDAwMDAwMC0weGM0N2ZkZmZmKQoKRWxh
cHNlZCB0aW1lOiAxMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC82N2Fl
M2IzNjc5NGRlNjlkNThlNjZmYjUwYmUwZmEwZDY4NTc0YzE3L2RtZXNnLXF1YW50YWwtaXZ5
dG93bjItMTk6MjAxNDAzMjMxMDEzNTk6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMu
MTQuMC1yYzctMDgwMzAtZzY3YWUzYjM6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0w
MzIzMDUzMC82N2FlM2IzNjc5NGRlNjlkNThlNjZmYjUwYmUwZmEwZDY4NTc0YzE3L2RtZXNn
LXF1YW50YWwtaXZ5dG93bjItMjk6MjAxNDAzMjMxMDE0MDE6aTM4Ni1yYW5kY29uZmlnLXg0
LTAzMjMwNTMwOjMuMTQuMC1yYzctMDgwMzAtZzY3YWUzYjM6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14NC0wMzIzMDUzMC82N2FlM2IzNjc5NGRlNjlkNThlNjZmYjUwYmUwZmEwZDY4
NTc0YzE3L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItNDM6MjAxNDAzMjMxMDE0MDA6aTM4Ni1y
YW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMDgwMzAtZzY3YWUzYjM6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC82N2FlM2IzNjc5NGRlNjlkNThlNjZm
YjUwYmUwZmEwZDY4NTc0YzE3L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItNToyMDE0MDMyMzEw
MTM1NjppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy0wODAzMC1nNjdh
ZTNiMzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzY3YWUzYjM2Nzk0
ZGU2OWQ1OGU2NmZiNTBiZTBmYTBkNjg1NzRjMTcvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi04
MToyMDE0MDMyMzEwMTM1MDppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4wLXJj
Ny0wODAzMC1nNjdhZTNiMzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMw
LzY3YWUzYjM2Nzk0ZGU2OWQ1OGU2NmZiNTBiZTBmYTBkNjg1NzRjMTcvZG1lc2ctcXVhbnRh
bC1sa3Atc2IwNC0yMjoyMDE0MDMyMzE4MTQwMTppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1
MzA6My4xNC4wLXJjNy0wODAzMC1nNjdhZTNiMzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXg0LTAzMjMwNTMwLzY3YWUzYjM2Nzk0ZGU2OWQ1OGU2NmZiNTBiZTBmYTBkNjg1NzRjMTcv
ZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC0zMjoyMDE0MDMyMzE4MTM1NTppMzg2LXJhbmRjb25m
aWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy0wODAzMC1nNjdhZTNiMzoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzY3YWUzYjM2Nzk0ZGU2OWQ1OGU2NmZiNTBiZTBm
YTBkNjg1NzRjMTcvZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC0zOjIwMTQwMzIzMTgxMzU5Omkz
ODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LTA4MDMwLWc2N2FlM2IzOjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvNjdhZTNiMzY3OTRkZTY5ZDU4
ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNy9kbWVzZy1xdWFudGFsLWxrcC1zYjA0LTQyOjIwMTQw
MzIzMTgxMzU5OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LTA4MDMw
LWc2N2FlM2IzOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvNjdhZTNi
MzY3OTRkZTY5ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNy9kbWVzZy1xdWFudGFsLWxrcC1z
YjA0LTQ0OjIwMTQwMzIzMTgxMzU4OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0
LjAtcmM3LTA4MDMwLWc2N2FlM2IzOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMy
MzA1MzAvNjdhZTNiMzY3OTRkZTY5ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNy9kbWVzZy1x
dWFudGFsLWxrcC1zYjA0LTQ1OjIwMTQwMzIzMTgxNDA0OmkzODYtcmFuZGNvbmZpZy14NC0w
MzIzMDUzMDozLjE0LjAtcmM3LTA4MDMwLWc2N2FlM2IzOjEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDMyMzA1MzAvNjdhZTNiMzY3OTRkZTY5ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3
NGMxNy9kbWVzZy1xdWFudGFsLWxrcC1zYjA0LTQ4OjIwMTQwMzIzMTgxNDAwOmkzODYtcmFu
ZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LTA4MDMwLWc2N2FlM2IzOjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvNjdhZTNiMzY3OTRkZTY5ZDU4ZTY2ZmI1
MGJlMGZhMGQ2ODU3NGMxNy9kbWVzZy1xdWFudGFsLWxrcC1zYjA0LTU1OjIwMTQwMzIzMTgx
MzU0OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LTA4MDMwLWc2N2Fl
M2IzOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvNjdhZTNiMzY3OTRk
ZTY5ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNy9kbWVzZy1xdWFudGFsLWxrcC1zYjA0LTU4
OjIwMTQwMzIzMTgxMzU4OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAtcmM3
LTA4MDMwLWc2N2FlM2IzOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAv
NjdhZTNiMzY3OTRkZTY5ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNy9kbWVzZy1xdWFudGFs
LXNuYi0xMjoyMDE0MDMyMzEwMTM1NzppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6Ogov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC82N2FlM2IzNjc5NGRlNjlkNThl
NjZmYjUwYmUwZmEwZDY4NTc0YzE3L2RtZXNnLXF1YW50YWwtc25iLTE1OjIwMTQwMzIzMTAx
NDAxOmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXg0LTAzMjMwNTMwLzY3YWUzYjM2Nzk0ZGU2OWQ1OGU2NmZiNTBiZTBmYTBkNjg1NzRj
MTcvZG1lc2ctcXVhbnRhbC1zbmItMTY6MjAxNDAzMjMxMDEzNTg6aTM4Ni1yYW5kY29uZmln
LXg0LTAzMjMwNTMwOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvNjdh
ZTNiMzY3OTRkZTY5ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNy9kbWVzZy1xdWFudGFsLXNu
Yi0yMjoyMDE0MDMyMzEwMTM1MzppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6Ogova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC82N2FlM2IzNjc5NGRlNjlkNThlNjZm
YjUwYmUwZmEwZDY4NTc0YzE3L2RtZXNnLXF1YW50YWwtc25iLTI2OjIwMTQwMzIzMTAxMzU3
OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXg0LTAzMjMwNTMwLzY3YWUzYjM2Nzk0ZGU2OWQ1OGU2NmZiNTBiZTBmYTBkNjg1NzRjMTcv
ZG1lc2cteW9jdG8tbGtwLXNiMDQtMTY6MjAxNDAzMjMxODEzNTQ6aTM4Ni1yYW5kY29uZmln
LXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMDgwMzAtZzY3YWUzYjM6MQowOjIwOjMwIGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDc0NiByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCltlMjI0ZWYwMTA3OTBkODcz
YzQ2NzJhNDA4ZjQ0MmMwOGI5MDE1NjdmXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICdzcGkvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9u
ZXh0Om1hc3RlcjplMjI0ZWYwMTA3OTBkODczYzQ2NzJhNDA4ZjQ0MmMwOGI5MDE1NjdmOmJp
c2VjdC1saW51eAoKMjAxNC0wMy0yMy0xMDoxNTozMiBlMjI0ZWYwMTA3OTBkODczYzQ2NzJh
NDA4ZjQ0MmMwOGI5MDE1NjdmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC1lMjI0
ZWYwMTA3OTBkODczYzQ2NzJhNDA4ZjQ0MmMwOGI5MDE1NjdmCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvZTIyNGVmMDEwNzkwZDg3
M2M0NjcyYTQwOGY0NDJjMDhiOTAxNTY3Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLWUy
MjRlZjAxMDc5MGQ4NzNjNDY3MmE0MDhmNDQyYzA4YjkwMTU2N2YKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWct
eDQtMDMyMzA1MzAtZTIyNGVmMDEwNzkwZDg3M2M0NjcyYTQwOGY0NDJjMDhiOTAxNTY3Zgpr
ZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL2UyMjRlZjAxMDc5
MGQ4NzNjNDY3MmE0MDhmNDQyYzA4YjkwMTU2N2Yvdm1saW51ei0zLjE0LjAtcmM3LTA3NDcy
LWdlMjI0ZWYwCgoyMDE0LTAzLTIzLTEwOjI0OjM0IGRldGVjdGluZyBib290IHN0YXRlIC4u
CTUJMTgJMzAgU1VDQ0VTUwoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgcmVt
b3RlLXRyYWNraW5nIGJyYW5jaCAndGlwL2F1dG8tbGF0ZXN0JwpsaW5lYXItYmlzZWN0OiBo
YW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3Rh
cnQgNjdhZTNiMzY3OTRkZTY5ZDU4ZTY2ZmI1MGJlMGZhMGQ2ODU3NGMxNyBlMjI0ZWYwMTA3
OTBkODczYzQ2NzJhNDA4ZjQ0MmMwOGI5MDE1NjdmIC0tCkJpc2VjdGluZzogMjgwIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbYTQ5NzEy
MzQzNjExZWIyYWNhNTBiMjAzNDkxMGU4ODczYjQ1MzExOF0gTWVyZ2UgYnJhbmNoICdwZXJm
L2NvcmUnCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlz
ZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9uZXh0Om1hc3Rlcjph
NDk3MTIzNDM2MTFlYjJhY2E1MGIyMDM0OTEwZTg4NzNiNDUzMTE4OmJpc2VjdC1saW51eAoK
MjAxNC0wMy0yMy0xMDoyNzoxMCBhNDk3MTIzNDM2MTFlYjJhY2E1MGIyMDM0OTEwZTg4NzNi
NDUzMTE4IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC1hNDk3MTIzNDM2MTFlYjJh
Y2E1MGIyMDM0OTEwZTg4NzNiNDUzMTE4CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvYTQ5NzEyMzQzNjExZWIyYWNhNTBiMjAzNDkx
MGU4ODczYjQ1MzExOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLWE0OTcxMjM0MzYxMWVi
MmFjYTUwYjIwMzQ5MTBlODg3M2I0NTMxMTgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAt
YTQ5NzEyMzQzNjExZWIyYWNhNTBiMjAzNDkxMGU4ODczYjQ1MzExOAprZXJuZWw6IC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL2E0OTcxMjM0MzYxMWViMmFjYTUwYjIw
MzQ5MTBlODg3M2I0NTMxMTgvdm1saW51ei0zLjE0LjAtcmM3LTAwMzA2LWdhNDk3MTIzCgoy
MDE0LTAzLTIzLTEwOjQzOjEwIGRldGVjdGluZyBib290IHN0YXRlIC4uCTIJMTAJMTMJMTQJ
MjgJMjkuLi4uLi4uLi4uLi4JMzAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMzkgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCls2MjZiZmUzOTZi
OGJmZTBjMmM5NGZlNDRiYzk4NTEwM2FiZmU0YjZmXSBNZXJnZSBicmFuY2ggJ3g4Ni9hcGlj
JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvbmV4dDptYXN0ZXI6NjI2
YmZlMzk2YjhiZmUwYzJjOTRmZTQ0YmM5ODUxMDNhYmZlNGI2ZjpiaXNlY3QtbGludXgKCjIw
MTQtMDMtMjMtMTA6NTM6NDUgNjI2YmZlMzk2YjhiZmUwYzJjOTRmZTQ0YmM5ODUxMDNhYmZl
NGI2ZiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtNjI2YmZlMzk2YjhiZmUwYzJj
OTRmZTQ0YmM5ODUxMDNhYmZlNGI2ZgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzYyNmJmZTM5NmI4YmZlMGMyYzk0ZmU0NGJjOTg1
MTAzYWJmZTRiNmYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC02MjZiZmUzOTZiOGJmZTBj
MmM5NGZlNDRiYzk4NTEwM2FiZmU0YjZmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLTYy
NmJmZTM5NmI4YmZlMGMyYzk0ZmU0NGJjOTg1MTAzYWJmZTRiNmYKa2VybmVsOiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC82MjZiZmUzOTZiOGJmZTBjMmM5NGZlNDRi
Yzk4NTEwM2FiZmU0YjZmL3ZtbGludXotMy4xNC4wLXJjNy0wMDQ0OC1nNjI2YmZlMwoKMjAx
NC0wMy0yMy0xMTowNTo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLgkzCTUJMTEJMTIJ
MTkJMjcJMzAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA4NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzcyYTUwMDQ1M2E3N2UwOTgwYzBjMmI0
ZWQ5ZmU4YjUyMWU3YWM1MjNdIE1lcmdlIGJyYW5jaCAneDg2L2RlYnVnJwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0
cy9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvbmV4dDptYXN0ZXI6NzJhNTAwNDUzYTc3ZTA5
ODBjMGMyYjRlZDlmZThiNTIxZTdhYzUyMzpiaXNlY3QtbGludXgKCjIwMTQtMDMtMjMtMTE6
MTE6NDggNzJhNTAwNDUzYTc3ZTA5ODBjMGMyYjRlZDlmZThiNTIxZTdhYzUyMyBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWcteDQtMDMyMzA1MzAtNzJhNTAwNDUzYTc3ZTA5ODBjMGMyYjRlZDlmZThi
NTIxZTdhYzUyMwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXg0LTAzMjMwNTMwLzcyYTUwMDQ1M2E3N2UwOTgwYzBjMmI0ZWQ5ZmU4YjUyMWU3YWM1MjMK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kz
ODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC03MmE1MDA0NTNhNzdlMDk4MGMwYzJiNGVkOWZl
OGI1MjFlN2FjNTIzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9i
dWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLTcyYTUwMDQ1M2E3N2Uw
OTgwYzBjMmI0ZWQ5ZmU4YjUyMWU3YWM1MjMKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy14NC0wMzIzMDUzMC83MmE1MDA0NTNhNzdlMDk4MGMwYzJiNGVkOWZlOGI1MjFlN2Fj
NTIzL3ZtbGludXotMy4xNC4wLXJjNy0wMDUwMi1nNzJhNTAwNAoKMjAxNC0wMy0yMy0xMToy
Mzo0OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JNAkyMwkzMCBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDQzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0
ZXBzKQpbYzUxOWRiN2ExMDIyOGQ1ZjBkNmJhZjNkZWFhMmM4NjlmOGI1N2JiOV0gTWVyZ2Ug
YnJhbmNoICd4ODYva2FzbHInCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUz
MC9uZXh0Om1hc3RlcjpjNTE5ZGI3YTEwMjI4ZDVmMGQ2YmFmM2RlYWEyYzg2OWY4YjU3YmI5
OmJpc2VjdC1saW51eAoKMjAxNC0wMy0yMy0xMToyNjo1MCBjNTE5ZGI3YTEwMjI4ZDVmMGQ2
YmFmM2RlYWEyYzg2OWY4YjU3YmI5IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC1j
NTE5ZGI3YTEwMjI4ZDVmMGQ2YmFmM2RlYWEyYzg2OWY4YjU3YmI5CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvYzUxOWRiN2ExMDIy
OGQ1ZjBkNmJhZjNkZWFhMmM4NjlmOGI1N2JiOQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMw
LWM1MTlkYjdhMTAyMjhkNWYwZDZiYWYzZGVhYTJjODY5ZjhiNTdiYjkKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25m
aWcteDQtMDMyMzA1MzAtYzUxOWRiN2ExMDIyOGQ1ZjBkNmJhZjNkZWFhMmM4NjlmOGI1N2Ji
OQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL2M1MTlkYjdh
MTAyMjhkNWYwZDZiYWYzZGVhYTJjODY5ZjhiNTdiYjkvdm1saW51ei0zLjE0LjAtcmM3LTAw
NTQ0LWdjNTE5ZGI3CgoyMDE0LTAzLTIzLTExOjQwOjUxIGRldGVjdGluZyBib290IHN0YXRl
IAkxCTMJMTkJMzAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMCByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzY1M2E1NTc0ZTRkYWU3ODg5MmY1
NDU4MjBkYzFhNGJiYmI4NDE0NjVdIE1lcmdlIGJyYW5jaCAneDg2L3RocmVhZGluZm8nCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2Vy
bmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9uZXh0Om1hc3Rlcjo2NTNhNTU3
NGU0ZGFlNzg4OTJmNTQ1ODIwZGMxYTRiYmJiODQxNDY1OmJpc2VjdC1saW51eAoKMjAxNC0w
My0yMy0xMTo0Mjo1NCA2NTNhNTU3NGU0ZGFlNzg4OTJmNTQ1ODIwZGMxYTRiYmJiODQxNDY1
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC02NTNhNTU3NGU0ZGFlNzg4OTJmNTQ1
ODIwZGMxYTRiYmJiODQxNDY1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDQtMDMyMzA1MzAvNjUzYTU1NzRlNGRhZTc4ODkyZjU0NTgyMGRjMWE0YmJi
Yjg0MTQ2NQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLTY1M2E1NTc0ZTRkYWU3ODg5MmY1
NDU4MjBkYzFhNGJiYmI4NDE0NjUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtNjUzYTU1
NzRlNGRhZTc4ODkyZjU0NTgyMGRjMWE0YmJiYjg0MTQ2NQprZXJuZWw6IC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzY1M2E1NTc0ZTRkYWU3ODg5MmY1NDU4MjBkYzFh
NGJiYmI4NDE0NjUvdm1saW51ei0zLjE0LjAtcmM3LTAwNTY3LWc2NTNhNTU3CgoyMDE0LTAz
LTIzLTExOjU5OjU1IGRldGVjdGluZyBib290IHN0YXRlIC4JMTkJMjEuCTI5Li4uLi4uCTMw
IFNVQ0NFU1MKCkJpc2VjdGluZzogMTAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDMgc3RlcHMpCltlZjcyMTk4N2FlZjBjYzBhYmJhMDhjODg4MTBmMjE1
NWY3NmIwYjFmXSB4ODYsIHZkc286IEludHJvZHVjZSBWVkFSIG1hcmNvIGZvciB2ZHNvMzIK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9r
ZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL25leHQ6bWFzdGVyOmVmNzIx
OTg3YWVmMGNjMGFiYmEwOGM4ODgxMGYyMTU1Zjc2YjBiMWY6YmlzZWN0LWxpbnV4CgoyMDE0
LTAzLTIzLTEyOjA2OjA3IGVmNzIxOTg3YWVmMGNjMGFiYmEwOGM4ODgxMGYyMTU1Zjc2YjBi
MWYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLWVmNzIxOTg3YWVmMGNjMGFiYmEw
OGM4ODgxMGYyMTU1Zjc2YjBiMWYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy14NC0wMzIzMDUzMC9lZjcyMTk4N2FlZjBjYzBhYmJhMDhjODg4MTBmMjE1
NWY3NmIwYjFmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtZWY3MjE5ODdhZWYwY2MwYWJi
YTA4Yzg4ODEwZjIxNTVmNzZiMGIxZgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC1lZjcy
MTk4N2FlZjBjYzBhYmJhMDhjODg4MTBmMjE1NWY3NmIwYjFmCmtlcm5lbDogL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvZWY3MjE5ODdhZWYwY2MwYWJiYTA4Yzg4ODEw
ZjIxNTVmNzZiMGIxZi92bWxpbnV6LTMuMTQuMC1yYzYtMDAwMTAtZ2VmNzIxOTg3CgoyMDE0
LTAzLTIzLTEyOjIwOjA5IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4JMQk3CTE4CTI0CTMw
IFNVQ0NFU1MKCkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMyBzdGVwcykKWzAwOGNjOTA3ZGUzMjdkODNhMGJlNjA5Y2Q0OTVmY2Ni
MGU1ZGZhNGNdIHg4NiwgdmRzbzMyOiBEaXNhYmxlIHN0YWNrIHByb3RlY3RvciwgYWRqdXN0
IG9wdGltaXphdGlvbnMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL25l
eHQ6bWFzdGVyOjAwOGNjOTA3ZGUzMjdkODNhMGJlNjA5Y2Q0OTVmY2NiMGU1ZGZhNGM6Ymlz
ZWN0LWxpbnV4CgoyMDE0LTAzLTIzLTEyOjI0OjQxIDAwOGNjOTA3ZGUzMjdkODNhMGJlNjA5
Y2Q0OTVmY2NiMGU1ZGZhNGMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLTAwOGNj
OTA3ZGUzMjdkODNhMGJlNjA5Y2Q0OTVmY2NiMGU1ZGZhNGMKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8wMDhjYzkwN2RlMzI3ZDgz
YTBiZTYwOWNkNDk1ZmNjYjBlNWRmYTRjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtMDA4
Y2M5MDdkZTMyN2Q4M2EwYmU2MDljZDQ5NWZjY2IwZTVkZmE0Ywp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy14
NC0wMzIzMDUzMC0wMDhjYzkwN2RlMzI3ZDgzYTBiZTYwOWNkNDk1ZmNjYjBlNWRmYTRjCmtl
cm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvMDA4Y2M5MDdkZTMy
N2Q4M2EwYmU2MDljZDQ5NWZjY2IwZTVkZmE0Yy92bWxpbnV6LTMuMTQuMC1yYzYtMDAwMTUt
ZzAwOGNjOTAKCjIwMTQtMDMtMjMtMTM6MDQ6NDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgky
OAkzMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCltkY2U0NGUwM2IwYTM0NDhhZDExYWM2YzZlMGNi
ZTI5OWUwNDAwNzkxXSBjb21wYXQ6IEZpeCBzcGFyc2UgYWRkcmVzcyBzcGFjZSB3YXJuaW5n
cwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvbmV4dDptYXN0ZXI6ZGNl
NDRlMDNiMGEzNDQ4YWQxMWFjNmM2ZTBjYmUyOTllMDQwMDc5MTpiaXNlY3QtbGludXgKCjIw
MTQtMDMtMjMtMTM6MDY6MjQgZGNlNDRlMDNiMGEzNDQ4YWQxMWFjNmM2ZTBjYmUyOTllMDQw
MDc5MSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtZGNlNDRlMDNiMGEzNDQ4YWQx
MWFjNmM2ZTBjYmUyOTllMDQwMDc5MQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL2RjZTQ0ZTAzYjBhMzQ0OGFkMTFhYzZjNmUwY2Jl
Mjk5ZTA0MDA3OTEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC1kY2U0NGUwM2IwYTM0NDhh
ZDExYWM2YzZlMGNiZTI5OWUwNDAwNzkxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLWRj
ZTQ0ZTAzYjBhMzQ0OGFkMTFhYzZjNmUwY2JlMjk5ZTA0MDA3OTEKa2VybmVsOiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9kY2U0NGUwM2IwYTM0NDhhZDExYWM2YzZl
MGNiZTI5OWUwNDAwNzkxL3ZtbGludXotMy4xMy4wLTExMzA5LWdkY2U0NGUwCgoyMDE0LTAz
LTIzLTEzOjE1OjI2IGRldGVjdGluZyBib290IHN0YXRlIC4JMjcJMzAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEg
c3RlcCkKWzA0N2Y1YjZhOTg4ZWM2YWRlNDlkZmI1OGM3NGZiYzg3MzMzMjk5NjldIE1lcmdl
IGJyYW5jaCAneDg2L3Zkc28nCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUz
MC9uZXh0Om1hc3RlcjowNDdmNWI2YTk4OGVjNmFkZTQ5ZGZiNThjNzRmYmM4NzMzMzI5OTY5
OmJpc2VjdC1saW51eAoKMjAxNC0wMy0yMy0xMzoxNjo1NyAwNDdmNWI2YTk4OGVjNmFkZTQ5
ZGZiNThjNzRmYmM4NzMzMzI5OTY5IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC0w
NDdmNWI2YTk4OGVjNmFkZTQ5ZGZiNThjNzRmYmM4NzMzMzI5OTY5CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvMDQ3ZjViNmE5ODhl
YzZhZGU0OWRmYjU4Yzc0ZmJjODczMzMyOTk2OQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMw
LTA0N2Y1YjZhOTg4ZWM2YWRlNDlkZmI1OGM3NGZiYzg3MzMzMjk5NjkKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25m
aWcteDQtMDMyMzA1MzAtMDQ3ZjViNmE5ODhlYzZhZGU0OWRmYjU4Yzc0ZmJjODczMzMyOTk2
OQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzA0N2Y1YjZh
OTg4ZWM2YWRlNDlkZmI1OGM3NGZiYzg3MzMzMjk5Njkvdm1saW51ei0zLjE0LjAtcmM3LTAw
NTg0LWcwNDdmNWI2CgoyMDE0LTAzLTIzLTEzOjM1OjU4IGRldGVjdGluZyBib290IHN0YXRl
IAkyIFRFU1QgRkFJTFVSRQpbICAgIDIuNjAxMDUwXSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQg
W21lbSAweGIxZTlmMDAwLTB4YjIwYWVmZmZdClsgICAgMi42MDQ0NzVdIHRyYXBzOiBpbml0
WzFdIGdlbmVyYWwgcHJvdGVjdGlvbiBpcDphNzZmM2IwZCBzcDphZmM2MTQ0ZCBlcnJvcjow
ClsgICAgMi42MDU5NTldIGluaXQgKDEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDU1
NDAgYnl0ZXMgbGVmdApbICAgIDIuNjA2NjA4XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2lu
ZzogQXR0ZW1wdGVkIHRvIGtpbGwgaW5pdCEgZXhpdGNvZGU9MHgwMDAwMDAwYgpbICAgIDIu
NjA2NjA4XSAKWyAgICAyLjYwNzUwOF0gQ1BVOiAwIFBJRDogMSBDb21tOiBpbml0IE5vdCB0
YWludGVkIDMuMTQuMC1yYzctMDA1ODQtZzA0N2Y1YjYgIzEKWyAgICAyLjYwNzU3MV0gSGFy
ZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDIu
NjA3NTcxXSAgMDAwMDAwMDAgMDAwMDAwMDAgYjAwN2JkZjQgYjE5YTZkMGEgYjFkOWI0MDEg
YjAwN2JlMTQgYjE5OTliMTkgYjFjNjFlZWMKWyAgICAyLjYwNzU3MV0gIGIyMGM2NTQwIDAw
MDAwMDAxIGIxZDliNDAxIGIwMTQwMjAxIGIwMTQwMDAwIGIwMDdiZTY4IGIxMDQ2NGUyIGIx
YzYyMjE0ClsgICAgMi42MDc1NzFdICAwMDAwMDAwYiAwMDAwMDAwMSAwMDAwMTVhNCAwMDAw
MDAwMSAwMDAwMDAwMSAwMDAwMDAwMSBiMDE0MDAwMCBiMDE0MDAwMApbICAgIDIuNjA3NTcx
XSBDYWxsIFRyYWNlOgpbICAgIDIuNjA3NTcxXSAgWzxiMTlhNmQwYT5dIGR1bXBfc3RhY2sr
MHg0OC8weDYwClsgICAgMi42MDc1NzFdICBbPGIxOTk5YjE5Pl0gcGFuaWMrMHg4Ny8weDE3
YQpbICAgIDIuNjA3NTcxXSAgWzxiMTA0NjRlMj5dIGRvX2V4aXQrMHhhYjIvMHhhYzAKWyAg
ICAyLjYwNzU3MV0gIFs8YjEwNDY1N2U+XSBkb19ncm91cF9leGl0KzB4NGUvMHhiMApbICAg
IDIuNjA3NTcxXSAgWzxiMTA1MzM4OT5dIGdldF9zaWduYWxfdG9fZGVsaXZlcisweDFiOS8w
eDg3MApbICAgIDIuNjA3NTcxXSAgWzxiMTA3NWQ3Mz5dID8gc2NoZWRfY2xvY2tfbG9jYWwr
MHg3My8weDE2MApbICAgIDIuNjA3NTcxXSAgWzxiMTAwMmM0MD5dID8gZG9fYWxpZ25tZW50
X2NoZWNrKzB4YTAvMHhhMApbICAgIDIuNjA3NTcxXSAgWzxiMTAwMWE2YT5dIGRvX3NpZ25h
bCsweDNhLzB4OWIwClsgICAgMi42MDc1NzFdICBbPGIxMDg3ZTYwPl0gPyBsb2NrX3JlbGVh
c2VfaG9sZHRpbWUucGFydC4yNisweGIwLzB4ZjAKWyAgICAyLjYwNzU3MV0gIFs8YjEwNTBj
Zjg+XSA/IHNpZ25hbF93YWtlX3VwX3N0YXRlKzB4MjgvMHgzMApbICAgIDIuNjA3NTcxXSAg
WzxiMTk5OWYzOD5dID8gY29tcGxldGVfc2lnbmFsKzB4MTJmLzB4MTM2ClsgICAgMi42MDc1
NzFdICBbPGIxMDhjYmVhPl0gPyBkb19yYXdfc3Bpbl91bmxvY2srMHhhYS8weGYwClsgICAg
Mi42MDc1NzFdICBbPGIxMDUxZWQ3Pl0gPyBmb3JjZV9zaWdfaW5mbysweGE3LzB4ZDAKWyAg
ICAyLjYwNzU3MV0gIFs8YjEwNTJiMzQ+XSA/IGZvcmNlX3NpZysweDE0LzB4MjAKWyAgICAy
LjYwNzU3MV0gIFs8YjEwMDJjYjE+XSA/IGRvX2dlbmVyYWxfcHJvdGVjdGlvbisweDcxLzB4
MTcwClsgICAgMi42MDc1NzFdICBbPGIxMDAyYzQwPl0gPyBkb19hbGlnbm1lbnRfY2hlY2sr
MHhhMC8weGEwClsgICAgMi42MDc1NzFdICBbPGIxMDAyNDQ4Pl0gZG9fbm90aWZ5X3Jlc3Vt
ZSsweDY4LzB4NzAKWyAgICAyLjYwNzU3MV0gIFs8YjE5YjRkZjA+XSB3b3JrX25vdGlmeXNp
ZysweDMwLzB4MzgKWyAgICAyLjYwNzU3MV0gIFs8YjEwMDJjNDA+XSA/IGRvX2FsaWdubWVu
dF9jaGVjaysweGEwLzB4YTAKWyAgICAyLjYwNzU3MV0gS2VybmVsIE9mZnNldDogMHgwIGZy
b20gMHhiMTAwMDAwMCAocmVsb2NhdGlvbiByYW5nZTogMHhiMDAwMDAwMC0weGM0N2ZkZmZm
KQoKRWxhcHNlZCB0aW1lOiAxMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUz
MC8wNDdmNWI2YTk4OGVjNmFkZTQ5ZGZiNThjNzRmYmM4NzMzMzI5OTY5L2RtZXNnLXF1YW50
YWwtbGtwLXNiMDQtMzoyMDE0MDMyMzIxMzUzNzppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1
MzA6My4xNC4wLXJjNy0wMDU4NC1nMDQ3ZjViNjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXg0LTAzMjMwNTMwLzA0N2Y1YjZhOTg4ZWM2YWRlNDlkZmI1OGM3NGZiYzg3MzMzMjk5Njkv
ZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xNDoyMDE0MDMyMzEzMzU0NjppMzg2LXJhbmRjb25m
aWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy0wMDU4NC1nMDQ3ZjViNjoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzA0N2Y1YjZhOTg4ZWM2YWRlNDlkZmI1OGM3NGZi
Yzg3MzMzMjk5NjkvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xODoyMDE0MDMyMzEzMzUzOTpp
Mzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy0wMDU4NC1nMDQ3ZjViNjox
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzA0N2Y1YjZhOTg4ZWM2YWRl
NDlkZmI1OGM3NGZiYzg3MzMzMjk5NjkvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yMDoyMDE0
MDMyMzEzMzU0NjppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy0wMDU4
NC1nMDQ3ZjViNjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzA0N2Y1
YjZhOTg4ZWM2YWRlNDlkZmI1OGM3NGZiYzg3MzMzMjk5NjkvZG1lc2ctcXVhbnRhbC1pdnl0
b3duMi0yODoyMDE0MDMyMzEzMzU0NzppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4x
NC4wLXJjNy0wMDU4NC1nMDQ3ZjViNjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAz
MjMwNTMwLzA0N2Y1YjZhOTg4ZWM2YWRlNDlkZmI1OGM3NGZiYzg3MzMzMjk5NjkvZG1lc2ct
cXVhbnRhbC1sa3Atc2IwNC02OjIwMTQwMzIzMjEzNTQ0OmkzODYtcmFuZGNvbmZpZy14NC0w
MzIzMDUzMDozLjE0LjAtcmM3LTAwNTg0LWcwNDdmNWI2OjEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDMyMzA1MzAvMDQ3ZjViNmE5ODhlYzZhZGU0OWRmYjU4Yzc0ZmJjODczMzMy
OTk2OS9kbWVzZy1xdWFudGFsLWxrcC1zYjA0LTMwOjIwMTQwMzIzMjEzNjAwOmkzODYtcmFu
ZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LTAwNTg0LWcwNDdmNWI2OjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvMDQ3ZjViNmE5ODhlYzZhZGU0OWRmYjU4
Yzc0ZmJjODczMzMyOTk2OS9kbWVzZy1xdWFudGFsLWxrcC1zYjA0LTc6MjAxNDAzMjMyMTM2
MDA6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctMDA1ODQtZzA0N2Y1
YjY6MQowOjg6MTAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMCBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKWzRl
NDAxMTJjNGZmNmE1NzdkZDA2ZDkyYjJhNTRjZGYwNjI2NWJmNzRdIHg4NiwgdmRzbzMyOiBo
YW5kbGUgMzIgYml0IHZEU08gbGFyZ2VyIG9uZSBwYWdlCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy14NC0wMzIzMDUzMC9uZXh0Om1hc3Rlcjo0ZTQwMTEyYzRmZjZhNTc3ZGQwNmQ5MmIy
YTU0Y2RmMDYyNjViZjc0OmJpc2VjdC1saW51eAoKMjAxNC0wMy0yMy0xMzozNjo0MCA0ZTQw
MTEyYzRmZjZhNTc3ZGQwNmQ5MmIyYTU0Y2RmMDYyNjViZjc0IGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy14NC0wMzIzMDUzMC00ZTQwMTEyYzRmZjZhNTc3ZGQwNmQ5MmIyYTU0Y2RmMDYyNjViZjc0
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1
MzAvNGU0MDExMmM0ZmY2YTU3N2RkMDZkOTJiMmE1NGNkZjA2MjY1YmY3NAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLXg0LTAzMjMwNTMwLTRlNDAxMTJjNGZmNmE1NzdkZDA2ZDkyYjJhNTRjZGYwNjI2NWJm
NzQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
Ly5pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtNGU0MDExMmM0ZmY2YTU3N2RkMDZkOTJi
MmE1NGNkZjA2MjY1YmY3NAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAz
MjMwNTMwLzRlNDAxMTJjNGZmNmE1NzdkZDA2ZDkyYjJhNTRjZGYwNjI2NWJmNzQvdm1saW51
ei0zLjE0LjAtcmM2LTAwMDE2LWc0ZTQwMTEyCgoyMDE0LTAzLTIzLTEzOjUzOjQxIGRldGVj
dGluZyBib290IHN0YXRlIAk1IFRFU1QgRkFJTFVSRQpbICAgIDIuNDUzMDYyXSBkZWJ1Zzog
dW5tYXBwaW5nIGluaXQgW21lbSAweGIxZTk3MDAwLTB4YjIwYTZmZmZdClsgICAgMi40NTYz
OThdIHRyYXBzOiBpbml0WzFdIGdlbmVyYWwgcHJvdGVjdGlvbiBpcDphNzc4YWIwZCBzcDph
ZjgzZmUwZCBlcnJvcjowClsgICAgMi40NTc4OTBdIGluaXQgKDEpIHVzZWQgZ3JlYXRlc3Qg
c3RhY2sgZGVwdGg6IDU1MzYgYnl0ZXMgbGVmdApbICAgIDIuNDU4NTY2XSBLZXJuZWwgcGFu
aWMgLSBub3Qgc3luY2luZzogQXR0ZW1wdGVkIHRvIGtpbGwgaW5pdCEgZXhpdGNvZGU9MHgw
MDAwMDAwYgpbICAgIDIuNDU4NTY2XSAKWyAgICAyLjQ1OTQ5Nl0gQ1BVOiAwIFBJRDogMSBD
b21tOiBpbml0IE5vdCB0YWludGVkIDMuMTQuMC1yYzYtMDAwMTYtZzRlNDAxMTIgIzEKWyAg
ICAyLjQ1OTUyNF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEv
MDEvMjAxMQpbICAgIDIuNDU5NTI0XSAgMDAwMDAwMDAgMDAwMDAwMDAgYjAxNDlkZjQgYjE5
YTJmMzggYjFkOTRlMDEgYjAxNDllMTQgYjE5OTVlOWMgYjFjNWM4ZTAKWyAgICAyLjQ1OTUy
NF0gIGIyMGJlNTQwIDAwMDAwMDAxIGIxZDk0ZTAxIGIwMTQwMjAxIGIwMTQwMDAwIGIwMTQ5
ZTY4IGIxMDQ1ODIyIGIxYzVjYzA4ClsgICAgMi40NTk1MjRdICAwMDAwMDAwYiAwMDAwMDAw
MSAwMDAwMTVhMCAwMDAwMDAwMSAwMDAwMDAwMSAwMDAwMDAwMSBiMDE0MDAwMCBiMDE0MDAw
MApbICAgIDIuNDU5NTI0XSBDYWxsIFRyYWNlOgpbICAgIDIuNDU5NTI0XSAgWzxiMTlhMmYz
OD5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAgMi40NTk1MjRdICBbPGIxOTk1ZTljPl0g
cGFuaWMrMHg4Ny8weDE3YQpbICAgIDIuNDU5NTI0XSAgWzxiMTA0NTgyMj5dIGRvX2V4aXQr
MHhhYjIvMHhhYzAKWyAgICAyLjQ1OTUyNF0gIFs8YjEwNDU4YmU+XSBkb19ncm91cF9leGl0
KzB4NGUvMHhiMApbICAgIDIuNDU5NTI0XSAgWzxiMTA1MjVmOT5dIGdldF9zaWduYWxfdG9f
ZGVsaXZlcisweDFiOS8weDg3MApbICAgIDIuNDU5NTI0XSAgWzxiMTA3NGZlMz5dID8gc2No
ZWRfY2xvY2tfbG9jYWwrMHg3My8weDE2MApbICAgIDIuNDU5NTI0XSAgWzxiMTAwMmMzMD5d
ID8gZG9fYWxpZ25tZW50X2NoZWNrKzB4YTAvMHhhMApbICAgIDIuNDU5NTI0XSAgWzxiMTAw
MWE2YT5dIGRvX3NpZ25hbCsweDNhLzB4OWEwClsgICAgMi40NTk1MjRdICBbPGIxMDg2MzEw
Pl0gPyBsb2NrX3JlbGVhc2VfaG9sZHRpbWUucGFydC4yNisweGIwLzB4ZjAKWyAgICAyLjQ1
OTUyNF0gIFs8YjEwNGZmNjg+XSA/IHNpZ25hbF93YWtlX3VwX3N0YXRlKzB4MjgvMHgzMApb
ICAgIDIuNDU5NTI0XSAgWzxiMTk5NjJiYj5dID8gY29tcGxldGVfc2lnbmFsKzB4MTJmLzB4
MTM2ClsgICAgMi40NTk1MjRdICBbPGIxMDhiMDZhPl0gPyBkb19yYXdfc3Bpbl91bmxvY2sr
MHhhYS8weGYwClsgICAgMi40NTk1MjRdICBbPGIxMDUxMTQ3Pl0gPyBmb3JjZV9zaWdfaW5m
bysweGE3LzB4ZDAKWyAgICAyLjQ1OTUyNF0gIFs8YjEwNTFkYTQ+XSA/IGZvcmNlX3NpZysw
eDE0LzB4MjAKWyAgICAyLjQ1OTUyNF0gIFs8YjEwMDJjYTE+XSA/IGRvX2dlbmVyYWxfcHJv
dGVjdGlvbisweDcxLzB4MTcwClsgICAgMi40NTk1MjRdICBbPGIxMDAyYzMwPl0gPyBkb19h
bGlnbm1lbnRfY2hlY2srMHhhMC8weGEwClsgICAgMi40NTk1MjRdICBbPGIxMDAyNDM4Pl0g
ZG9fbm90aWZ5X3Jlc3VtZSsweDY4LzB4NzAKWyAgICAyLjQ1OTUyNF0gIFs8YjE5YjEwODg+
XSB3b3JrX25vdGlmeXNpZysweDMwLzB4MzgKWyAgICAyLjQ1OTUyNF0gIFs8YjEwMDJjMzA+
XSA/IGRvX2FsaWdubWVudF9jaGVjaysweGEwLzB4YTAKWyAgICAyLjQ1OTUyNF0gS2VybmVs
IE9mZnNldDogMHgwIGZyb20gMHhiMTAwMDAwMCAocmVsb2NhdGlvbiByYW5nZTogMHhiMDAw
MDAwMC0weGM0N2ZkZmZmKQoKRWxhcHNlZCB0aW1lOiAxMAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14NC0wMzIzMDUzMC80ZTQwMTEyYzRmZjZhNTc3ZGQwNmQ5MmIyYTU0Y2RmMDYyNjVi
Zjc0L2RtZXNnLXF1YW50YWwtbGtwLXNiMDQtMjg6MjAxNDAzMjMyMTUzMTQ6aTM4Ni1yYW5k
Y29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzYtMDAwMTYtZzRlNDAxMTI6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC80ZTQwMTEyYzRmZjZhNTc3ZGQwNmQ5MmIy
YTU0Y2RmMDYyNjViZjc0L2RtZXNnLXF1YW50YWwtbGtwLXNiMDQtNDY6MjAxNDAzMjMyMTUz
MTg6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzYtMDAwMTYtZzRlNDAx
MTI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC80ZTQwMTEyYzRmZjZh
NTc3ZGQwNmQ5MmIyYTU0Y2RmMDYyNjViZjc0L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItNzM6
MjAxNDAzMjMxMzUzMTk6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzYt
MDAwMTYtZzRlNDAxMTI6MQowOjM6OCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7
MzVtMjAxNC0wMy0yMyAxMzo1NDozOSBSRVBFQVQgQ09VTlQ6IDM2ICAjIC9rZXJuZWwtdGVz
dHMvbGludXgvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKNGU0MDExMmM0ZmY2YTU3N2RkMDZk
OTJiMmE1NGNkZjA2MjY1YmY3NCBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgNGU0
MDExMmM0ZmY2YTU3N2RkMDZkOTJiMmE1NGNkZjA2MjY1YmY3NApBdXRob3I6IFN0ZWZhbmkg
U2VpYm9sZCA8c3RlZmFuaUBzZWlib2xkLm5ldD4KRGF0ZTogICBNb24gTWFyIDE3IDIzOjIy
OjEzIDIwMTQgKzAxMDAKCiAgICB4ODYsIHZkc28zMjogaGFuZGxlIDMyIGJpdCB2RFNPIGxh
cmdlciBvbmUgcGFnZQogICAgCiAgICBUaGlzIHBhdGNoIGVuYWJsZXMgMzIgYml0IHZEU08g
d2hpY2ggYXJlIGxhcmdlciB0aGFuIGEgcGFnZS4KICAgIAogICAgU2lnbmVkLW9mZi1ieTog
U3RlZmFuaSBTZWlib2xkIDxzdGVmYW5pQHNlaWJvbGQubmV0PgogICAgTGluazogaHR0cDov
L2xrbWwua2VybmVsLm9yZy9yLzEzOTUwOTQ5MzMtMTQyNTItMTQtZ2l0LXNlbmQtZW1haWwt
c3RlZmFuaUBzZWlib2xkLm5ldAogICAgU2lnbmVkLW9mZi1ieTogSC4gUGV0ZXIgQW52aW4g
PGhwYUBsaW51eC5pbnRlbC5jb20+Cgo6MDQwMDAwIDA0MDAwMCAyMTVhNDNiZjk3YjY3N2Uz
MTkwNTQ1Yzg4ZjE0YzZiZmQ0YjQ2ODEyIDFlODQ5NDVjY2M0ZjhjZmRmYzViMGE4M2Q4ZmEy
YTE2MWU4MjEwNDggTQlhcmNoCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL25leHQ6bWFz
dGVyOjAwOGNjOTA3ZGUzMjdkODNhMGJlNjA5Y2Q0OTVmY2NiMGU1ZGZhNGM6YmlzZWN0LWxp
bnV4CgoyMDE0LTAzLTIzLTEzOjU0OjQyIDAwOGNjOTA3ZGUzMjdkODNhMGJlNjA5Y2Q0OTVm
Y2NiMGU1ZGZhNGMgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAv
MDA4Y2M5MDdkZTMyN2Q4M2EwYmU2MDljZDQ5NWZjY2IwZTVkZmE0Yy92bWxpbnV6LTMuMTQu
MC1yYzYtMDAwMTUtZzAwOGNjOTAKCjIwMTQtMDMtMjMtMTM6NTQ6NDMgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4uCTUJOAkxMQkyMgkzNgk0Ngk1NAk3NAk4Mwk5NAkxMDMJMTA4IFNVQ0NF
U1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
eDQtMDMyMzA1MzAvbmV4dDptYXN0ZXI6MDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcw
YmUxNjk3NTBlNTpiaXNlY3QtbGludXgKIFRFU1QgRkFJTFVSRQpbICAgIDMuMDM0NzQ2XSBC
SU9TIEVERCBmYWNpbGl0eSB2MC4xNiAyMDA0LUp1bi0yNSwgNiBkZXZpY2VzIGZvdW5kClsg
ICAgMy4wMzg3ODldIGRlYnVnOiB1bm1hcHBpbmcgaW5pdCBbbWVtIDB4YjFlYTkwMDAtMHhi
MjBiOGZmZl0KWyAgICAzLjA0MzE2NV0gdHJhcHM6IGluaXRbMV0gZ2VuZXJhbCBwcm90ZWN0
aW9uIGlwOmE3NzQ5YjBkIHNwOmFmYWI4MzhkIGVycm9yOjAKWyAgICAzLjA0NTI4OF0gS2Vy
bmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIGluaXQhIGV4aXRj
b2RlPTB4MDAwMDAwMGIKWyAgICAzLjA0NTI4OF0gClsgICAgMy4wNDYwMjZdIENQVTogMCBQ
SUQ6IDEgQ29tbTogaW5pdCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM3LW5leHQtMjAxNDAzMjEg
IzkKWyAgICAzLjA0NjAyNl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9j
aHMgMDEvMDEvMjAxMQpbICAgIDMuMDQ2MDI2XSAgMDAwMDAwMDAgMDAwMDAwMDAgYjAwN2Zk
ZjQgYjE5YTViOTEgYjFkYTE0MDEgYjAwN2ZlMTQgYjE5OTg2ZjkgYjFjNjcyM2MKWyAgICAz
LjA0NjAyNl0gIGIyMGQwNTQwIDAwMDAwMDAxIGIxZGExNDAxIGIwMTQwMjAxIGIwMTQwMDAw
IGIwMDdmZTY4IGIxMDQ1YzM5IGIxYzY3NTUwClsgICAgMy4wNDYwMjZdICAwMDAwMDAwYiAw
MDAwMDAwYiBiMDE0MDM4NCAwMDAwMDAwMSAwMDAwMDAwMSAwMDAwMDAwMSBiMDE0MDAwMCBi
MDE0MDAwMApbICAgIDMuMDQ2MDI2XSBDYWxsIFRyYWNlOgpbICAgIDMuMDQ2MDI2XSAgWzxi
MTlhNWI5MT5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAgMy4wNDYwMjZdICBbPGIxOTk4
NmY5Pl0gcGFuaWMrMHg4Ny8weDE4ZQpbICAgIDMuMDQ2MDI2XSAgWzxiMTA0NWMzOT5dIGRv
X2V4aXQrMHg3YzkvMHhhYTAKWyAgICAzLjA0NjAyNl0gIFs8YjEwNDVmOWU+XSBkb19ncm91
cF9leGl0KzB4NGUvMHhiMApbICAgIDMuMDQ2MDI2XSAgWzxiMTA1MjNiOT5dIGdldF9zaWdu
YWxfdG9fZGVsaXZlcisweDFiOS8weDg3MApbICAgIDMuMDQ2MDI2XSAgWzxiMTA3NDE5Mz5d
ID8gc2NoZWRfY2xvY2tfbG9jYWwrMHg3My8weDE2MApbICAgIDMuMDQ2MDI2XSAgWzxiMTAw
MmM0MD5dID8gZG9fYWxpZ25tZW50X2NoZWNrKzB4YTAvMHhhMApbICAgIDMuMDQ2MDI2XSAg
WzxiMTAwMWE2YT5dIGRvX3NpZ25hbCsweDNhLzB4OWIwClsgICAgMy4wNDYwMjZdICBbPGIx
MDg1ZGMwPl0gPyBsb2NrX3JlbGVhc2VfaG9sZHRpbWUucGFydC4yNisweGIwLzB4ZjAKWyAg
ICAzLjA0NjAyNl0gIFs8YjEwNGZkMjg+XSA/IHNpZ25hbF93YWtlX3VwX3N0YXRlKzB4Mjgv
MHgzMApbICAgIDMuMDQ2MDI2XSAgWzxiMTk5OGIyYz5dID8gY29tcGxldGVfc2lnbmFsKzB4
MTJmLzB4MTM2ClsgICAgMy4wNDYwMjZdICBbPGIxMDhhZTVhPl0gPyBkb19yYXdfc3Bpbl91
bmxvY2srMHhhYS8weGYwClsgICAgMy4wNDYwMjZdICBbPGIxMDUwZjA3Pl0gPyBmb3JjZV9z
aWdfaW5mbysweGE3LzB4ZDAKWyAgICAzLjA0NjAyNl0gIFs8YjEwNTFiNjQ+XSA/IGZvcmNl
X3NpZysweDE0LzB4MjAKWyAgICAzLjA0NjAyNl0gIFs8YjEwMDJjYjE+XSA/IGRvX2dlbmVy
YWxfcHJvdGVjdGlvbisweDcxLzB4MTcwClsgICAgMy4wNDYwMjZdICBbPGIxMDAyYzQwPl0g
PyBkb19hbGlnbm1lbnRfY2hlY2srMHhhMC8weGEwClsgICAgMy4wNDYwMjZdICBbPGIxMDAy
NDQ4Pl0gZG9fbm90aWZ5X3Jlc3VtZSsweDY4LzB4NzAKWyAgICAzLjA0NjAyNl0gIFs8YjE5
YjNlNTA+XSB3b3JrX25vdGlmeXNpZysweDMwLzB4MzgKWyAgICAzLjA0NjAyNl0gIFs8YjEw
MDJjNDA+XSA/IGRvX2FsaWdubWVudF9jaGVjaysweGEwLzB4YTAKWyAgICAzLjA0NjAyNl0g
S2VybmVsIE9mZnNldDogMHgwIGZyb20gMHhiMTAwMDAwMCAocmVsb2NhdGlvbiByYW5nZTog
MHhiMDAwMDAwMC0weGMwN2ZkZmZmKQoKRWxhcHNlZCB0aW1lOiAxMAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14NC0wMzIzMDUzMC8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBi
ZTE2OTc1MGU1L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItOTM6MjAxNDAzMjMwNTM2Mjg6aTM4
Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMTo5Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzA2ZWQyNmQxZGU1OWNlN2NiYmU2
ODM3OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0zNzoyMDE0MDMy
MzA1MzYzMjppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy1uZXh0LTIw
MTQwMzIxOjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvMDZlZDI2ZDFk
ZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy1xdWFudGFsLXNuYi0yNToy
MDE0MDMyMzA3MzMxMTppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0
NzBiZTE2OTc1MGU1L2RtZXNnLXF1YW50YWwtc25iLTMwOjIwMTQwMzIzMDczMzE4OmkzODYt
cmFuZGNvbmZpZy14NC0wMzIzMDUzMDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAz
MjMwNTMwLzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2ct
cXVhbnRhbC1sa3Atc2IwNC00NDoyMDE0MDMyMzA1MzYyNzppMzg2LXJhbmRjb25maWcteDQt
MDMyMzA1MzA6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxOjkKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDMyMzA1MzAvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3
NTBlNS9kbWVzZy1xdWFudGFsLWxrcC1zYjA0LTY6MjAxNDAzMjMxNTMzMTI6aTM4Ni1yYW5k
Y29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMTo5Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3
ZTQ3MGJlMTY5NzUwZTUvZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC01OjIwMTQwMzIzMDUzNjI5
OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjE6
OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8wNmVkMjZkMWRlNTljZTdj
YmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXF1YW50YWwtbGtwLXNiMDQtNDoyMDE0
MDMyMzE1MzMwODppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy1uZXh0
LTIwMTQwMzIxOjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvMDZlZDI2
ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy1xdWFudGFsLWNhaXJv
LTI1OjIwMTQwMzIzMDczMzE0OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAt
cmM3LW5leHQtMjAxNDAzMjE6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUz
MC8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXF1YW50
YWwtbGtwLXNiMDQtNjA6MjAxNDAzMjMwNTM2Mjg6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMw
NTMwOjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMTo5CjA6MTA6MTkgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKCltkZXRhY2hlZCBIRUFEIGI4MWM4MjldIFJldmVydCAieDg2LCB2ZHNv
MzI6IGhhbmRsZSAzMiBiaXQgdkRTTyBsYXJnZXIgb25lIHBhZ2UiCiAxIGZpbGUgY2hhbmdl
ZCwgNyBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC9uZXh0Om1hc3Rl
cjpiODFjODI5ODAwMWUyMjBkNjliYzgxOTcyYzZhMzdjZTYxYzU5NzgwOmJpc2VjdC1saW51
eAoKMjAxNC0wMy0yMy0xNDowMzoxNyBiODFjODI5ODAwMWUyMjBkNjliYzgxOTcyYzZhMzdj
ZTYxYzU5NzgwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC1iODFjODI5ODAwMWUy
MjBkNjliYzgxOTcyYzZhMzdjZTYxYzU5NzgwCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvYjgxYzgyOTgwMDFlMjIwZDY5YmM4MTk3
MmM2YTM3Y2U2MWM1OTc4MAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLWI4MWM4Mjk4MDAx
ZTIyMGQ2OWJjODE5NzJjNmEzN2NlNjFjNTk3ODAKc3RhdHVzOiBGQUlMOiBubyBjb21taXQg
YjgxYzgyOTgwMDFlMjIwZDY5YmM4MTk3MmM2YTM3Y2U2MWM1OTc4MCBmb3IgYnVpbGQgdGFz
ayBpMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtYjgxYzgyOTgwMDFlMjIwZDY5YmM4MTk3
MmM2YTM3Y2U2MWM1OTc4MAoyMDE0LTAzLTIzLTE0OjA4OjE5IGI4MWM4Mjk4MDAxZTIyMGQ2
OWJjODE5NzJjNmEzN2NlNjFjNTk3ODAgU0tJUCBCUk9LRU4gQlVJTEQKTm8ga2VybmVsIGlu
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL2I4MWM4Mjk4MDAxZTIyMGQ2
OWJjODE5NzJjNmEzN2NlNjFjNTk3ODAKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0K
V2FybmluZzogeW91IGFyZSBsZWF2aW5nIDEgY29tbWl0IGJlaGluZCwgbm90IGNvbm5lY3Rl
ZCB0bwphbnkgb2YgeW91ciBicmFuY2hlczoKCiAgYjgxYzgyOSBSZXZlcnQgIng4NiwgdmRz
bzMyOiBoYW5kbGUgMzIgYml0IHZEU08gbGFyZ2VyIG9uZSBwYWdlIgoKSWYgeW91IHdhbnQg
dG8ga2VlcCB0aGVtIGJ5IGNyZWF0aW5nIGEgbmV3IGJyYW5jaCwgdGhpcyBtYXkgYmUgYSBn
b29kIHRpbWUKdG8gZG8gc28gd2l0aDoKCiBnaXQgYnJhbmNoIG5ld19icmFuY2hfbmFtZSBi
ODFjODI5CgpIRUFEIGlzIG5vdyBhdCA3NzQ4NjhjLi4uIE1lcmdlIGJyYW5jaCAncGVyZi11
cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvdGlwL3RpcApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwL25leHQ6bWFzdGVyOjc3NDg2OGM3MDk0ZDM1
YjQ1MThiZTNkMGU2NTRkZTAwMGE1ZDExZmM6YmlzZWN0LWxpbnV4CgoyMDE0LTAzLTIzLTE0
OjA4OjUxIDc3NDg2OGM3MDk0ZDM1YjQ1MThiZTNkMGU2NTRkZTAwMGE1ZDExZmMgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLTc3NDg2OGM3MDk0ZDM1YjQ1MThiZTNkMGU2NTRk
ZTAwMGE1ZDExZmMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14NC0wMzIzMDUzMC83NzQ4NjhjNzA5NGQzNWI0NTE4YmUzZDBlNjU0ZGUwMDBhNWQxMWZj
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAtNzc0ODY4YzcwOTRkMzViNDUxOGJlM2QwZTY1
NGRlMDAwYTVkMTFmYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC03NzQ4NjhjNzA5NGQz
NWI0NTE4YmUzZDBlNjU0ZGUwMDBhNWQxMWZjCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDMyMzA1MzAvNzc0ODY4YzcwOTRkMzViNDUxOGJlM2QwZTY1NGRlMDAwYTVk
MTFmYy92bWxpbnV6LTMuMTQuMC1yYzctMDAwNjYtZzc3NDg2OGMKCjIwMTQtMDMtMjMtMTQ6
MTI6NTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEzCTI1CTUzCTk1CTEwOCBTVUNDRVNTCgoK
PT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIDc3NDg2OGMuLi4gTWVyZ2UgYnJhbmNoICdwZXJmLXVyZ2VudC1mb3ItbGludXMnIG9m
IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90aXAvdGlw
CkhFQUQgaXMgbm93IGF0IDA2ZWQyNmQuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmls
ZXMgZm9yIDIwMTQwMzIxCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWcteDQtMDMyMzA1MzAvbmV4dDptYXN0ZXI6MDZlZDI2ZDFkZTU5Y2U3Y2Ji
ZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNTpiaXNlY3QtbGludXgKIFRFU1QgRkFJTFVSRQpbICAg
IDMuMDM0NzQ2XSBCSU9TIEVERCBmYWNpbGl0eSB2MC4xNiAyMDA0LUp1bi0yNSwgNiBkZXZp
Y2VzIGZvdW5kClsgICAgMy4wMzg3ODldIGRlYnVnOiB1bm1hcHBpbmcgaW5pdCBbbWVtIDB4
YjFlYTkwMDAtMHhiMjBiOGZmZl0KWyAgICAzLjA0MzE2NV0gdHJhcHM6IGluaXRbMV0gZ2Vu
ZXJhbCBwcm90ZWN0aW9uIGlwOmE3NzQ5YjBkIHNwOmFmYWI4MzhkIGVycm9yOjAKWyAgICAz
LjA0NTI4OF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBraWxs
IGluaXQhIGV4aXRjb2RlPTB4MDAwMDAwMGIKWyAgICAzLjA0NTI4OF0gClsgICAgMy4wNDYw
MjZdIENQVTogMCBQSUQ6IDEgQ29tbTogaW5pdCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM3LW5l
eHQtMjAxNDAzMjEgIzkKWyAgICAzLjA0NjAyNl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9j
aHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDMuMDQ2MDI2XSAgMDAwMDAwMDAgMDAw
MDAwMDAgYjAwN2ZkZjQgYjE5YTViOTEgYjFkYTE0MDEgYjAwN2ZlMTQgYjE5OTg2ZjkgYjFj
NjcyM2MKWyAgICAzLjA0NjAyNl0gIGIyMGQwNTQwIDAwMDAwMDAxIGIxZGExNDAxIGIwMTQw
MjAxIGIwMTQwMDAwIGIwMDdmZTY4IGIxMDQ1YzM5IGIxYzY3NTUwClsgICAgMy4wNDYwMjZd
ICAwMDAwMDAwYiAwMDAwMDAwYiBiMDE0MDM4NCAwMDAwMDAwMSAwMDAwMDAwMSAwMDAwMDAw
MSBiMDE0MDAwMCBiMDE0MDAwMApbICAgIDMuMDQ2MDI2XSBDYWxsIFRyYWNlOgpbICAgIDMu
MDQ2MDI2XSAgWzxiMTlhNWI5MT5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAgMy4wNDYw
MjZdICBbPGIxOTk4NmY5Pl0gcGFuaWMrMHg4Ny8weDE4ZQpbICAgIDMuMDQ2MDI2XSAgWzxi
MTA0NWMzOT5dIGRvX2V4aXQrMHg3YzkvMHhhYTAKWyAgICAzLjA0NjAyNl0gIFs8YjEwNDVm
OWU+XSBkb19ncm91cF9leGl0KzB4NGUvMHhiMApbICAgIDMuMDQ2MDI2XSAgWzxiMTA1MjNi
OT5dIGdldF9zaWduYWxfdG9fZGVsaXZlcisweDFiOS8weDg3MApbICAgIDMuMDQ2MDI2XSAg
WzxiMTA3NDE5Mz5dID8gc2NoZWRfY2xvY2tfbG9jYWwrMHg3My8weDE2MApbICAgIDMuMDQ2
MDI2XSAgWzxiMTAwMmM0MD5dID8gZG9fYWxpZ25tZW50X2NoZWNrKzB4YTAvMHhhMApbICAg
IDMuMDQ2MDI2XSAgWzxiMTAwMWE2YT5dIGRvX3NpZ25hbCsweDNhLzB4OWIwClsgICAgMy4w
NDYwMjZdICBbPGIxMDg1ZGMwPl0gPyBsb2NrX3JlbGVhc2VfaG9sZHRpbWUucGFydC4yNisw
eGIwLzB4ZjAKWyAgICAzLjA0NjAyNl0gIFs8YjEwNGZkMjg+XSA/IHNpZ25hbF93YWtlX3Vw
X3N0YXRlKzB4MjgvMHgzMApbICAgIDMuMDQ2MDI2XSAgWzxiMTk5OGIyYz5dID8gY29tcGxl
dGVfc2lnbmFsKzB4MTJmLzB4MTM2ClsgICAgMy4wNDYwMjZdICBbPGIxMDhhZTVhPl0gPyBk
b19yYXdfc3Bpbl91bmxvY2srMHhhYS8weGYwClsgICAgMy4wNDYwMjZdICBbPGIxMDUwZjA3
Pl0gPyBmb3JjZV9zaWdfaW5mbysweGE3LzB4ZDAKWyAgICAzLjA0NjAyNl0gIFs8YjEwNTFi
NjQ+XSA/IGZvcmNlX3NpZysweDE0LzB4MjAKWyAgICAzLjA0NjAyNl0gIFs8YjEwMDJjYjE+
XSA/IGRvX2dlbmVyYWxfcHJvdGVjdGlvbisweDcxLzB4MTcwClsgICAgMy4wNDYwMjZdICBb
PGIxMDAyYzQwPl0gPyBkb19hbGlnbm1lbnRfY2hlY2srMHhhMC8weGEwClsgICAgMy4wNDYw
MjZdICBbPGIxMDAyNDQ4Pl0gZG9fbm90aWZ5X3Jlc3VtZSsweDY4LzB4NzAKWyAgICAzLjA0
NjAyNl0gIFs8YjE5YjNlNTA+XSB3b3JrX25vdGlmeXNpZysweDMwLzB4MzgKWyAgICAzLjA0
NjAyNl0gIFs8YjEwMDJjNDA+XSA/IGRvX2FsaWdubWVudF9jaGVjaysweGEwLzB4YTAKWyAg
ICAzLjA0NjAyNl0gS2VybmVsIE9mZnNldDogMHgwIGZyb20gMHhiMTAwMDAwMCAocmVsb2Nh
dGlvbiByYW5nZTogMHhiMDAwMDAwMC0weGMwN2ZkZmZmKQoKRWxhcHNlZCB0aW1lOiAxMAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8wNmVkMjZkMWRlNTljZTdjYmJl
NjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItOTM6MjAxNDAz
MjMwNTM2Mjg6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctbmV4dC0y
MDE0MDMyMTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzA2ZWQyNmQx
ZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2ctcXVhbnRhbC1pdnl0b3du
Mi0zNzoyMDE0MDMyMzA1MzYzMjppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4w
LXJjNy1uZXh0LTIwMTQwMzIxOjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1
MzAvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy1xdWFu
dGFsLXNuYi0yNToyMDE0MDMyMzA3MzMxMTppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8wNmVkMjZkMWRlNTljZTdj
YmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXF1YW50YWwtc25iLTMwOjIwMTQwMzIz
MDczMzE4OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXg0LTAzMjMwNTMwLzA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5
NzUwZTUvZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC00NDoyMDE0MDMyMzA1MzYyNzppMzg2LXJh
bmRjb25maWcteDQtMDMyMzA1MzA6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIxOjkKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzAvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4
YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy1xdWFudGFsLWxrcC1zYjA0LTY6MjAxNDAzMjMxNTMz
MTI6aTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctbmV4dC0yMDE0MDMy
MTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAzMjMwNTMwLzA2ZWQyNmQxZGU1OWNl
N2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTUvZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC01OjIw
MTQwMzIzMDUzNjI5OmkzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMDozLjE0LjAtcmM3LW5l
eHQtMjAxNDAzMjE6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMzIzMDUzMC8wNmVk
MjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L2RtZXNnLXF1YW50YWwtbGtw
LXNiMDQtNDoyMDE0MDMyMzE1MzMwODppMzg2LXJhbmRjb25maWcteDQtMDMyMzA1MzA6My4x
NC4wLXJjNy1uZXh0LTIwMTQwMzIxOjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDMy
MzA1MzAvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy1x
dWFudGFsLWNhaXJvLTI1OjIwMTQwMzIzMDczMzE0OmkzODYtcmFuZGNvbmZpZy14NC0wMzIz
MDUzMDozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjE6OQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14NC0wMzIzMDUzMC8wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1
L2RtZXNnLXF1YW50YWwtbGtwLXNiMDQtNjA6MjAxNDAzMjMwNTM2Mjg6aTM4Ni1yYW5kY29u
ZmlnLXg0LTAzMjMwNTMwOjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMTo5CjA6MTA6MTkgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==

--IiVenqGWf+H9Y6IX
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
CONFIG_X86_32_LAZY_GS=y
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
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
CONFIG_IRQ_DOMAIN_DEBUG=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
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
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLUB_CPU_PARTIAL is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
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
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_STA2X11 is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_3G_OPT=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xB0000000
# CONFIG_X86_PAE is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
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
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
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
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
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
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
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
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRNET=y
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=y
# CONFIG_ACTISYS_DONGLE is not set
# CONFIG_TEKRAM_DONGLE is not set
CONFIG_TOIM3232_DONGLE=y
CONFIG_LITELINK_DONGLE=y
CONFIG_MA600_DONGLE=y
# CONFIG_GIRBIL_DONGLE is not set
CONFIG_MCP2120_DONGLE=y
CONFIG_OLD_BELKIN_DONGLE=y
# CONFIG_ACT200L_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_SIM=y
CONFIG_NFC_MRVL=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
CONFIG_MTD_MAP_BANK_WIDTH_2=y
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
CONFIG_MTD_MAP_BANK_WIDTH_16=y
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
CONFIG_MTD_CFI_I8=y
# CONFIG_MTD_OTP is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_SCx200_DOCFLASH=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_OSD=y
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
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
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
CONFIG_SATA_HIGHBANK=y
CONFIG_SATA_MV=y
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_RCAR is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PLATFORM=y
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
CONFIG_BCACHE_CLOSURES_DEBUG=y
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
# CONFIG_DM_CACHE is not set
CONFIG_DM_ERA=y
CONFIG_DM_MIRROR=y
CONFIG_DM_LOG_USERSPACE=y
# CONFIG_DM_RAID is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
# CONFIG_DM_SWITCH is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
# CONFIG_TCM_FC is not set
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
# CONFIG_CAIF_SPI_SLAVE is not set
# CONFIG_CAIF_HSI is not set
CONFIG_CAIF_VIRTIO=y
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_ALTERA_TSE=y
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=y
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
CONFIG_KS8851_MLL=y
# CONFIG_KSZ884X_PCI is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
CONFIG_WIZNET_BUS_DIRECT=y
# CONFIG_WIZNET_BUS_INDIRECT is not set
# CONFIG_WIZNET_BUS_ANY is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
# CONFIG_PPPOE is not set
CONFIG_PPP_ASYNC=y
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
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
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
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
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
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
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y

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
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

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
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
# CONFIG_GPIO_WM8994 is not set
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

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set
CONFIG_GPIO_TPS6586X=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
# CONFIG_DA9055_WATCHDOG is not set
CONFIG_WM831X_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
# CONFIG_XILINX_WATCHDOG is not set
CONFIG_DW_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_RDC321X_WDT=y
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8997 is not set
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

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
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
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
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_NEW_LEDS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_MAX77686=y
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_ISL12057=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PALMAS=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TPS6586X=y
CONFIG_RTC_DRV_TPS80031=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
# CONFIG_RTC_DRV_DA9055 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_RTS5208 is not set
# CONFIG_IDE_PHISON is not set
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
CONFIG_AD7291=y
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
# CONFIG_AD799X is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
# CONFIG_AD7152 is not set
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2583 is not set
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7854=y
# CONFIG_ADE7854_I2C is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDER_IPC_32BIT=y
CONFIG_ASHMEM=y
# CONFIG_ANDROID_LOGGER is not set
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
# CONFIG_SYNC is not set
CONFIG_ION=y
# CONFIG_ION_TEST is not set
# CONFIG_ION_DUMMY is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=y
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
CONFIG_GS_FPGABOOT=y
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_PALMAS=y
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_MAX1363=y
CONFIG_MCP3422=y
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
CONFIG_MAX517=y
CONFIG_MCP4725=y

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
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_ITG3200=y

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=y

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
CONFIG_CM32181=y
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
CONFIG_LTR501=y
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_MAG3110=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_MPL3115=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y

#
# Temperature sensors
#
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_OMAP_CONTROL_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=y
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_LOGFS=y
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
# CONFIG_EXOFS_FS is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_F2FS_CHECK_FS=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
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
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
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
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
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
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_CRC64_ECMA=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
CONFIG_DDR=y

--IiVenqGWf+H9Y6IX--
