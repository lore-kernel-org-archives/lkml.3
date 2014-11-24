Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaKXMhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:37:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:32372 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbaKXMhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:37:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,448,1413270000"; 
   d="scan'208";a="637144875"
Date: Mon, 24 Nov 2014 20:36:41 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [sched] INFO: suspicious RCU usage. ]
Message-ID: <20141124123641.GC7310@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KDt/GgjP6HVcx58l"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

commit eeb61e53ea19be0c4015b00b2e8b3b2185436f2b ("sched: Fix race between task_group and sched_task_group")


+---------------------------+------------+------------+
|                           | xfs-for-li | eeb61e53ea |
+---------------------------+------------+------------+
| boot_successes            | 0          | 0          |
| boot_failures             | 54         | 10         |
| BUG:kernel_boot_hang      | 54         | 10         |
| INFO:suspicious_RCU_usage | 0          | 10         |
| backtrace:do_fork         | 0          | 10         |
+---------------------------+------------+------------+


[    0.054010] ftrace: allocating 44163 entries in 87 pages
[    0.072399] 
[    0.073480] ===============================
[    0.074916] [ INFO: suspicious RCU usage. ]
[    0.076000] 3.18.0-rc2-g05da589 #861 Not tainted
[    0.076000] -------------------------------
[    0.076000] kernel/sched/core.c:7449 suspicious rcu_dereference_check() usage!
[    0.076000] 
[    0.076000] other info that might help us debug this:
[    0.076000] 
[    0.076000] 
[    0.076000] rcu_scheduler_active = 1, debug_locks = 0
[    0.076000] 2 locks held by swapper/0/0:
[    0.076000]  #0:  (&p->pi_lock){......}, at: [<c1069318>] task_rq_lock+0x28/0xba
[    0.076000]  #1:  (&rq->lock){-.....}, at: [<c1069336>] task_rq_lock+0x46/0xba
[    0.076000] 
[    0.076000] stack backtrace:
[    0.076000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc2-g05da589 #861
[    0.076000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.076000]  00000000 00000000 c209be98 c1b238b0 00000001 c209beb4 c108ba6a c1f54e96
[    0.076000]  c20a3550 d30c0000 d370c300 c20b28a0 c209bed4 c10731b6 00000000 00003550
[    0.076000]  00200246 d30c0000 00000000 00000000 c209bedc c1073285 c209bef0 c10cb273
[    0.076000] Call Trace:
[    0.076000]  [<c1b238b0>] dump_stack+0x48/0x60
[    0.076000]  [<c108ba6a>] lockdep_rcu_suspicious+0xd3/0xdc
[    0.076000]  [<c10731b6>] sched_move_task+0xd1/0x17c
[    0.076000]  [<c1073285>] cpu_cgroup_fork+0xd/0xf
[    0.076000]  [<c10cb273>] cgroup_post_fork+0xe1/0xec
[    0.076000]  [<c10464a4>] copy_process+0x1652/0x181f
[    0.076000]  [<c1b1c321>] ? rest_init+0x116/0x116
[    0.076000]  [<c1073f5b>] ? sched_clock_cpu+0x11b/0x136
[    0.076000]  [<c1b1c321>] ? rest_init+0x116/0x116
[    0.076000]  [<c10467c7>] do_fork+0x7d/0x632
[    0.076000]  [<c1088ad7>] ? trace_hardirqs_on_caller+0x160/0x17b
[    0.076000]  [<c1b1c321>] ? rest_init+0x116/0x116
[    0.076000]  [<c1088afd>] ? trace_hardirqs_on+0xb/0xd
[    0.076000]  [<c106ce9c>] ? nr_context_switches+0xb2/0xe4
[    0.076000]  [<c1b1c321>] ? rest_init+0x116/0x116
[    0.076000]  [<c1046d9b>] kernel_thread+0x1f/0x24
[    0.076000]  [<c1b1c22a>] rest_init+0x1f/0x116
[    0.076000]  [<c222db5b>] start_kernel+0x3fd/0x404
[    0.076000]  [<c222d2af>] i386_start_kernel+0x79/0x7d
[    0.076113] Getting VERSION: 50014
[    0.077525] Getting VERSION: 50014
[    0.080016] Getting ID: 0



	--yliu

--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-g05da589 (kbuild@lkp-hsx01) (gcc ve=
rsion 4.9.1 (Debian 4.9.1-19) ) #861 SMP Mon Nov 10 11:26:57 CST 2014
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
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x031fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x02d81000, 0x02d81fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x02d82000, 0x02d82fff] PGTABLE
[    0.000000] BRK [0x02d83000, 0x02d83fff] PGTABLE
[    0.000000] BRK [0x02d84000, 0x02d84fff] PGTABLE
[    0.000000] BRK [0x02d85000, 0x02d85fff] PGTABLE
[    0.000000] BRK [0x02d86000, 0x02d86fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13c0c000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
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
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffc001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c21951a0, node_mem_map d3=
85f028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 333 pages/cpu @d35c5000 s1342048 r0 d21920 =
u1363968
[    0.000000] pcpu-alloc: s1342048 r0 d21920 u1363968 alloc=3D333*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 135c75c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81020
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-i386-62/rand_boot-1-yocto-minimal-i386.cgz-i386-randconfig-ha2-110=
9-05da5898a96c05e32aa9850c9cd89eef29471b13-1.yaml ARCH=3Di386 BOOT_IMAGE=3D=
/kernel/i386-randconfig-ha2-1109/05da5898a96c05e32aa9850c9cd89eef29471b13/v=
mlinuz-3.18.0-rc2-g05da589 kconfig=3Di386-randconfig-ha2-1109 commit=3D05da=
5898a96c05e32aa9850c9cd89eef29471b13 branch=3Dpshelar-openvswitch/net_next_=
ovs root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm-kbuild-yoct=
o-i386/boot/1/yocto-minimal-i386.cgz/i386-randconfig-ha2-1109/05da5898a96c0=
5e32aa9850c9cd89eef29471b13/0 ip=3D::::vm-kbuild-yocto-i386-62::dhcp earlyp=
rintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_c=
pu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic=
 oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 co=
nsole=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 286168K/327280K available (11509K kernel code, 1609K=
 rwdata, 5480K rodata, 2316K init, 9152K bss, 41112K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffa00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc222d000 - 0xc2470000   (2316 kB)
[    0.000000]       .data : 0xc1b3d844 - 0xc222b400   (7094 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1b3d844   (11510 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D32, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:440 0
[    0.000000] CPU 0 irqstacks, hard=3Dd300a000 soft=3Dd300c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-g05da589 (kbuild@lkp-hsx01) (gcc ve=
rsion 4.9.1 (Debian 4.9.1-19) ) #861 SMP Mon Nov 10 11:26:57 CST 2014
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
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x031fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x02d81000, 0x02d81fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x02d82000, 0x02d82fff] PGTABLE
[    0.000000] BRK [0x02d83000, 0x02d83fff] PGTABLE
[    0.000000] BRK [0x02d84000, 0x02d84fff] PGTABLE
[    0.000000] BRK [0x02d85000, 0x02d85fff] PGTABLE
[    0.000000] BRK [0x02d86000, 0x02d86fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13c0c000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
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
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffc001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c21951a0, node_mem_map d3=
85f028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 333 pages/cpu @d35c5000 s1342048 r0 d21920 =
u1363968
[    0.000000] pcpu-alloc: s1342048 r0 d21920 u1363968 alloc=3D333*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 135c75c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81020
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-i386-62/rand_boot-1-yocto-minimal-i386.cgz-i386-randconfig-ha2-110=
9-05da5898a96c05e32aa9850c9cd89eef29471b13-1.yaml ARCH=3Di386 BOOT_IMAGE=3D=
/kernel/i386-randconfig-ha2-1109/05da5898a96c05e32aa9850c9cd89eef29471b13/v=
mlinuz-3.18.0-rc2-g05da589 kconfig=3Di386-randconfig-ha2-1109 commit=3D05da=
5898a96c05e32aa9850c9cd89eef29471b13 branch=3Dpshelar-openvswitch/net_next_=
ovs root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm-kbuild-yoct=
o-i386/boot/1/yocto-minimal-i386.cgz/i386-randconfig-ha2-1109/05da5898a96c0=
5e32aa9850c9cd89eef29471b13/0 ip=3D::::vm-kbuild-yocto-i386-62::dhcp earlyp=
rintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_c=
pu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic=
 oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 co=
nsole=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 286168K/327280K available (11509K kernel code, 1609K=
 rwdata, 5480K rodata, 2316K init, 9152K bss, 41112K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffa00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc222d000 - 0xc2470000   (2316 kB)
[    0.000000]       .data : 0xc1b3d844 - 0xc222b400   (7094 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1b3d844   (11510 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D32, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:440 0
[    0.000000] CPU 0 irqstacks, hard=3Dd300a000 soft=3Dd300c000
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
[    0.000000] tsc: Detected 2693.630 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.26 Bogo=
MIPS (lpj=3D10774520)
[    0.009935] pid_max: default: 32768 minimum: 301
[    0.010997] ACPI: Core revision 20140926
[    0.019674] ACPI: All ACPI Tables successfully acquired
[    0.021804] Security Framework initialized
[    0.023503] Yama: becoming mindful.
[    0.024099] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.026240] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.029137] Initializing cgroup subsys devices
[    0.032036] Initializing cgroup subsys freezer
[    0.033837] Initializing cgroup subsys blkio
[    0.036108] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.036108] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.041349] debug: unmapping init [mem 0xc2470000-0xc2476fff]
[    0.054010] ftrace: allocating 44163 entries in 87 pages
[    0.072399]=20
[    0.073480] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.074916] [ INFO: suspicious RCU usage. ]
[    0.076000] 3.18.0-rc2-g05da589 #861 Not tainted
[    0.076000] -------------------------------
[    0.076000] kernel/sched/core.c:7449 suspicious rcu_dereference_check() =
usage!
[    0.076000]=20
[    0.076000] other info that might help us debug this:
[    0.076000]=20
[    0.076000]=20
[    0.076000] rcu_scheduler_active =3D 1, debug_locks =3D 0
[    0.076000] 2 locks held by swapper/0/0:
[    0.076000]  #0:  (&p->pi_lock){......}, at: [<c1069318>] task_rq_lock+0=
x28/0xba
[    0.076000]  #1:  (&rq->lock){-.....}, at: [<c1069336>] task_rq_lock+0x4=
6/0xba
[    0.076000]=20
[    0.076000] stack backtrace:
[    0.076000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc2-g05da58=
9 #861
[    0.076000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.076000]  00000000 00000000 c209be98 c1b238b0 00000001 c209beb4 c108b=
a6a c1f54e96
[    0.076000]  c20a3550 d30c0000 d370c300 c20b28a0 c209bed4 c10731b6 00000=
000 00003550
[    0.076000]  00200246 d30c0000 00000000 00000000 c209bedc c1073285 c209b=
ef0 c10cb273
[    0.076000] Call Trace:
[    0.076000]  [<c1b238b0>] dump_stack+0x48/0x60
[    0.076000]  [<c108ba6a>] lockdep_rcu_suspicious+0xd3/0xdc
[    0.076000]  [<c10731b6>] sched_move_task+0xd1/0x17c
[    0.076000]  [<c1073285>] cpu_cgroup_fork+0xd/0xf
[    0.076000]  [<c10cb273>] cgroup_post_fork+0xe1/0xec
[    0.076000]  [<c10464a4>] copy_process+0x1652/0x181f
[    0.076000]  [<c1b1c321>] ? rest_init+0x116/0x116
[    0.076000]  [<c1073f5b>] ? sched_clock_cpu+0x11b/0x136
[    0.076000]  [<c1b1c321>] ? rest_init+0x116/0x116
[    0.076000]  [<c10467c7>] do_fork+0x7d/0x632
[    0.076000]  [<c1088ad7>] ? trace_hardirqs_on_caller+0x160/0x17b
[    0.076000]  [<c1b1c321>] ? rest_init+0x116/0x116
[    0.076000]  [<c1088afd>] ? trace_hardirqs_on+0xb/0xd
[    0.076000]  [<c106ce9c>] ? nr_context_switches+0xb2/0xe4
[    0.076000]  [<c1b1c321>] ? rest_init+0x116/0x116
[    0.076000]  [<c1046d9b>] kernel_thread+0x1f/0x24
[    0.076000]  [<c1b1c22a>] rest_init+0x1f/0x116
[    0.076000]  [<c222db5b>] start_kernel+0x3fd/0x404
[    0.076000]  [<c222d2af>] i386_start_kernel+0x79/0x7d
[    0.076113] Getting VERSION: 50014
[    0.077525] Getting VERSION: 50014
[    0.080016] Getting ID: 0
[    0.081304] Getting ID: f000000
[    0.082706] Getting LVT0: 8700
[    0.084012] Getting LVT1: 8400
[    0.085346] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.088108] enabled ExtINT on CPU#0
[    0.090958] ENABLING IO-APIC IRQs
[    0.092018] init IO_APIC IRQs
[    0.093426]  apic 0 pin 0 not connected
[    0.094907] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.096033] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.100030] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.104030] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.106909] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.108032] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.112030] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.114855] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.116030] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.120030] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.124029] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.126704] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.128030] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.132030] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.134773] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.136034] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.140029]  apic 0 pin 16 not connected
[    0.141526]  apic 0 pin 17 not connected
[    0.144006]  apic 0 pin 18 not connected
[    0.145500]  apic 0 pin 19 not connected
[    0.148006]  apic 0 pin 20 not connected
[    0.149504]  apic 0 pin 21 not connected
[    0.151015]  apic 0 pin 22 not connected
[    0.152006]  apic 0 pin 23 not connected
[    0.153660] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.156005] smpboot: CPU0: Intel QEMU Virtual CPU version 1.7.1 (fam: 06=
, model: 06, stepping: 03)
[    0.159580] Using local APIC timer interrupts.
[    0.159580] calibrating APIC timer ...
[    0.164000] ... lapic delta =3D 6250910
[    0.164000] ... PM-Timer delta =3D 358004
[    0.164000] ... PM-Timer result ok
[    0.164000] ..... delta 6250910
[    0.164000] ..... mult: 268474540
[    0.164000] ..... calibration result: 4000582
[    0.164000] ..... CPU clock speed is 2693.3523 MHz.
[    0.164000] ..... host bus clock speed is 1000.0582 MHz.
[    0.164117] Performance Events: Broken PMU hardware detected, using soft=
ware events only.
[    0.170586] Failed to access perfctr msr (MSR c1 is 0)
[    0.172984] Testing tracer nop: PASSED
[    0.177866] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.180544] CPU 1 irqstacks, hard=3Dd3168000 soft=3Dd316a000
[    0.182379] x86: Booting SMP configuration:
[    0.184008] .... node  #0, CPUs:      #1
[    0.004000] Initializing CPU#1
[    0.008000] kvm-clock: cpu 1, msr 0:13ffc021, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.200113] x86: Booted up 1 node, 2 CPUs
[    0.200069] KVM setup async PF for cpu 1
[    0.200069] kvm-stealtime: cpu 1, msr 137145c0
[    0.208008] ----------------
[    0.209126] | NMI testsuite:
[    0.210286] --------------------
[    0.212005]   remote IPI:  ok  |
[    0.217066]    local IPI:  ok  |
[    0.224022] --------------------
[    0.225332] Good, all   2 testcases passed! |
[    0.227023] ---------------------------------
[    0.228014] smpboot: Total of 2 processors activated (10774.52 BogoMIPS)
[    0.232620] evm: security.capability
[    0.244025] Testing tracer function: PASSED
[    0.755189] Testing dynamic ftrace: PASSED
[    1.000745] Testing dynamic ftrace ops #1: (1 0 1 0 0) (1 1 2 0 0) (2 1 =
3 0 204786) (2 2 4 0 205037) PASSED
[    1.582879] Testing dynamic ftrace ops #2: (1 0 1 203405 0) (1 1 2 20364=
4 0) (2 1 3 3 654) (2 2 4 239 890) PASSED
[    2.124005] Testing ftrace recursion: PASSED
[    2.163703] Testing ftrace recursion safe: PASSED
[    2.202408] Testing ftrace regs: PASSED
[    2.264025] Testing tracer wakeup:=20
[    2.696027] ftrace-test (24) used greatest stack depth: 7460 bytes left
[    2.712025] PASSED
[    2.724028] Testing tracer wakeup_rt: PASSED
[    3.160020] Testing tracer wakeup_dl: PASSED
[    3.621576] xor: measuring software checksum speed
[    3.656949]    pIII_sse  :   161.000 MB/sec
[    3.696928]    prefetch64-sse:   111.000 MB/sec
[    3.698537] xor: using function: pIII_sse (161.000 MB/sec)
[    3.700034] atomic64_test: passed for i586+ platform with CX8 and with S=
SE
[    3.702212] regulator-dummy: no parameters
[    3.703829] RTC time: 11:59:29, date: 11/10/14
[    3.708234] NET: Registered protocol family 16
[    3.708804] EISA bus registered
[    3.716031] cpuidle: using governor ladder
[    3.720017] cpuidle: using governor menu
[    3.720017] ACPI: bus type PCI registered
[    3.720080] PCI: Using configuration type 1 for base access
[    3.741820] Running resizable hashtable tests...
[    3.741820]   Adding 2048 keys
[    3.848028]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    3.848028]   Table expansion iteration 0...
[    3.868027]   Verifying lookups...
[    3.868027]   Table expansion iteration 1...
[    3.880030]   Verifying lookups...
[    3.880030]   Table expansion iteration 2...
[    3.892023]   Verifying lookups...
[    3.892023]   Table expansion iteration 3...
[    3.908018]   Verifying lookups...
[    3.908018]   Table shrinkage iteration 0...
[    3.916020]   Verifying lookups...
[    3.916020]   Table shrinkage iteration 1...
[    3.920017]   Verifying lookups...
[    3.920017]   Table shrinkage iteration 2...
[    3.928026]   Verifying lookups...
[    3.928026]   Table shrinkage iteration 3...
[    3.932021]   Verifying lookups...
[    3.932021]   Deleting 2048 keys
[    4.036925] raid6: mmxx1     3591 MB/s
[    4.104903] raid6: mmxx2     3312 MB/s
[    4.172916] raid6: sse1x1    2615 MB/s
[    4.241128] raid6: sse1x2    3481 MB/s
[    4.308906] raid6: sse2x1    6226 MB/s
[    4.376910] raid6: sse2x2    9661 MB/s
[    4.377840] raid6: using algorithm sse2x2 (9661 MB/s)
[    4.379122] raid6: using intx1 recovery algorithm
[    4.380337] ACPI: Added _OSI(Module Device)
[    4.381294] ACPI: Added _OSI(Processor Device)
[    4.382342] ACPI: Added _OSI(3.0 _SCP Extensions)
[    4.383348] ACPI: Added _OSI(Processor Aggregator Device)
[    4.384874] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:3)
[    4.391140] ACPI: Interpreter enabled
[    4.392020] ACPI: (supports S0 S4 S5)
[    4.393155] ACPI: Using IOAPIC for interrupt routing
[    4.394692] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    4.401801] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    4.403077] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    4.404014] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    4.405635] PCI host bridge to bus 0000:00
[    4.407070] pci_bus 0000:00: root bus resource [bus 00-ff]
[    4.408007] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    4.409164] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    4.410388] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    4.412006] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    4.413270] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    4.414881] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    4.416731] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    4.421234] pci 0000:00:01.1: reg 0x20: [io  0xc080-0xc08f]
[    4.423704] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    4.428006] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    4.429455] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    4.429455] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    4.429588] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    4.430987] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    4.436015] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    4.437554] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    4.450962] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    4.450962] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    4.457111] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    4.458834] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    4.460799] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    4.462740] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    4.467808] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    4.472280] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    4.474255] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    4.474255] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    4.478674] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    4.480223] pci 0000:00:05.0: reg 0x10: [mem 0xfebf2000-0xfebf200f]
[    4.484325] pci_bus 0000:00: on NUMA node 0
[    4.485880] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    4.487407] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    4.488889] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    4.490439] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    4.491913] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    4.493182] ACPI: Enabled 16 GPEs in block 00 to 0F
[    4.495115] vgaarb: setting as boot device: PCI:0000:00:02.0
[    4.496000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    4.500006] vgaarb: loaded
[    4.500766] vgaarb: bridge control possible 0000:00:02.0
[    4.503760] SCSI subsystem initialized
[    4.503760] libata version 3.00 loaded.
[    4.503760] Linux video capture interface: v2.00
[    4.504051] pps_core: LinuxPPS API ver. 1 registered
[    4.505342] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    4.512019] wmi: Mapper loaded
[    4.513796] PCI: Using ACPI for IRQ routing
[    4.513796] PCI: pci_cache_line_size set to 32 bytes
[    4.513826] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    4.516014] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    4.520006] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    4.524256] Switched to clocksource kvm-clock
[    4.526131] Warning: could not register annotated branches stats
[    4.559035] FS-Cache: Loaded
[    4.560427] CacheFiles: Loaded
[    4.562180] pnp: PnP ACPI init
[    4.563816] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    4.566909] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.568812] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    4.571609] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    4.573666] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    4.576818] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    4.579127] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    4.582124] pnp 00:03: [dma 2]
[    4.583358] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    4.585380] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    4.588289] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    4.590145] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    4.593038] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.594796] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    4.597599] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.599736] pnp: PnP ACPI: found 7 devices
[    4.601276] PnPBIOS: Disabled
[    4.917312] mdacon: MDA with 8K of memory detected.
[    4.917386] Console: switching consoles 13-16 to MDA-2
[    4.954225] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.955804] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.957612] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.959741] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    4.961113] NET: Registered protocol family 1
[    4.962863] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    4.964522] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    4.966146] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    4.967835] pci 0000:00:02.0: Video device with shadowed ROM
[    4.969488] PCI: CLS 0 bytes, default 32
[    4.971366] Unpacking initramfs...
[    5.210049] debug: unmapping init [mem 0xd3c0c000-0xd3feffff]
[    5.214017] microcode: CPU0 sig=3D0x663, pf=3D0x1, revision=3D0x1
[    5.215647] microcode: CPU1 sig=3D0x663, pf=3D0x1, revision=3D0x1
[    5.218526] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    5.221864] apm: BIOS not found.
[    5.223636] cryptomgr_test (34) used greatest stack depth: 7432 bytes le=
ft
[    5.226103] cryptomgr_test (35) used greatest stack depth: 7296 bytes le=
ft
[    5.228896] PCLMULQDQ-NI instructions are not detected.
[    5.230573] NatSemi SCx200 Driver
[    5.232277] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    5.241658] rcu-torture: Creating rcu_torture_writer task
[    5.243918] rcu-torture: Creating rcu_torture_fakewriter task
[    5.245667] rcu-torture: rcu_torture_writer task started
[    5.247958] rcu-torture: Creating rcu_torture_fakewriter task
[    5.248002] rcu-torture: rcu_torture_fakewriter task started
[    5.251828] rcu-torture: Creating rcu_torture_fakewriter task
[    5.251842] rcu-torture: rcu_torture_fakewriter task started
[    5.255646] rcu-torture: Creating rcu_torture_fakewriter task
[    5.257727] rcu-torture: rcu_torture_fakewriter task started
[    5.259552] rcu-torture: Creating rcu_torture_reader task
[    5.259568] rcu-torture: rcu_torture_fakewriter task started
[    5.263590] rcu-torture: Creating rcu_torture_stats task
[    5.265307] rcu-torture: rcu_torture_reader task started
[    5.267487] rcu-torture: Creating torture_shuffle task
[    5.267505] rcu-torture: rcu_torture_stats task started
[    5.270840] rcu-torture: Creating torture_stutter task
[    5.272700] rcu-torture: torture_shuffle task started
[    5.274441] rcu-torture: Creating rcu_torture_cbflood task
[    5.274459] rcu-torture: torture_stutter task started
[    5.278549] futex hash table entries: 512 (order: 3, 32768 bytes)
[    5.280523] Initialise system trusted keyring
[    5.282783] rcu-torture: rcu_torture_cbflood task started
[    5.290307] zbud: loaded
[    5.293817] JFS: nTxBlock =3D 2235, nTxLock =3D 17885
[    5.298046] SGI XFS with ACLs, security attributes, no debug enabled
[    5.301453] NILFS version 2 loaded
[    5.304259] gfs2: GFS2 installed
[    5.305547] msgmni has been set to 558
[    5.306924] Key type big_key registered
[    5.316663] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    5.319264] io scheduler noop registered
[    5.320711] io scheduler deadline registered (default)
[    5.322314] io scheduler cfq registered
[    5.323792] start plist test
[    5.330858] end plist test
[    5.333436] xz_dec_test: module loaded
[    5.334798] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    5.338384] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.340039] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    5.343014] cpcihp_generic: not configured, disabling.
[    5.344762] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.346837] Console: switching consoles 13-16 to MDA-2
[    5.348788] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    5.350581] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    5.352802] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    5.355111] vmlfb: initializing
[    5.356493] Could not find Carillo Ranch MCH device.
[    5.358330] hgafb: HGA card not detected.
[    5.359742] hgafb: probe of hgafb.0 failed with error -22
[    5.361820] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.364630] ACPI: Power Button [PWRF]
[    5.366882] isapnp: Scanning for PnP cards...
[    5.732135] isapnp: No Plug & Play device found
[    5.734480] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    5.736075] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    5.752833] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.777202] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    5.783747] Initializing Nozomi driver 2.1d
[    5.785527] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    5.786767] toshiba: not a supported Toshiba laptop
[    5.787842] scx200_gpio: no SCx200 gpio present
[    5.788845] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    5.790129] platform pc8736x_gpio.0: no device found
[    5.791405] nsc_gpio initializing
[    5.792347] Linux agpgart interface v0.103
[    5.793568] SyncLink PC Card driver $Revision: 4.34 $, tty major#246
[    5.795584] [drm] Initialized drm 1.1.0 20060810
[    5.796981] [drm] radeon kernel modesetting enabled.
[    5.798084] drm/i810 does not support SMP
[    5.799887] [TTM] Zone  kernel: Available graphics memory: 143084 kiB
[    5.801332] [TTM] Initializing pool allocator
[    5.804161] [drm] fb mappable at 0xFC000000
[    5.805267] [drm] vram aper at 0xFC000000
[    5.806461] [drm] size 4194304
[    5.807369] [drm] fb depth is 24
[    5.808574] [drm]    pitch is 3072
[    5.810055] fbcon: cirrusdrmfb (fb0) is primary device
[    5.851820] Console: switching to colour frame buffer device 128x48
[    5.867220] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    5.867836] cirrus 0000:00:02.0: registered panic notifier
[    5.872078] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    5.873637] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    5.874644] lkdtm: No crash points registered, enable through debugfs
[    5.875565] Phantom Linux Driver, version n0.9.8, init OK
[    5.876542] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    5.878402] osst :I: Tape driver with OnStream support version 0.99.4
[    5.878402] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    5.880311] SCSI Media Changer driver v0.25=20
[    5.881551] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    5.883042] I2O subsystem v1.325
[    5.883502] i2o: max drivers =3D 8
[    5.884614] I2O Block Device OSM v1.325
[    5.885526] I2O SCSI Peripheral OSM v1.316
[    5.886129] I2O ProcFS OSM v1.316
[    5.886624] Fusion MPT base driver 3.04.20
[    5.887196] Copyright (c) 1999-2008 LSI Corporation
[    5.887880] Fusion MPT SPI Host driver 3.04.20
[    5.888547] Fusion MPT misc device (ioctl) driver 3.04.20
[    5.889330] mptctl: Registered with Fusion MPT base driver
[    5.890115] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    5.894619] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.899323] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.903028] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.969867] mousedev: PS/2 mouse device common for all mice
[    5.973998] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    5.978320] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    5.982312] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    5.985224] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    5.985681] wistron_btns: System unknown
[    5.985713] ideapad_slidebar: DMI does not match
[    5.986007] rtc_cmos 00:00: RTC can wake from S4
[    5.986829] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    5.987127] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    5.988075] rtc (null): invalid alarm value: 1900-1-10 0:0:0
[    5.988125] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    5.988206] rtc (null): invalid alarm value: 1900-1-10 0:0:0
[    5.988240] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    5.988684] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    6.004473] i2c-parport-light: adapter type unspecified
[    6.004555] isa i2c-pca-isa.0: Please specify I/O base
[    6.005593] pps_ldisc: PPS line discipline registered
[    6.212087] tsc: Refined TSC clocksource calibration: 2693.505 MHz
[    6.850220] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    6.857676] evbug: Connected device: input3 (ImExPS/2 Generic Explorer M=
ouse at isa0060/serio1/input0)
[    7.148165] applesmc: supported laptop not found!
[    7.153100] applesmc: driver init failed (ret=3D-19)!
[    7.368111] kpnpbiosd (112) used greatest stack depth: 7144 bytes left
[   14.536419] intel_powerclamp: Intel powerclamp does not run on family 6 =
model 6
[   14.541104] lguest: switcher text too large (4384)
[   14.544751] cpufreq-nforce2: No nForce2 chipset.
[   14.548300] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   14.551966] wbsd: Copyright(c) Pierre Ossman
[   14.557754] leds_ss4200: no LED devices found
[   17.756083]  (null): enodev DEV ADDR =3D 0xFF
[   17.760090] ledtrig-cpu: registered to indicate activity on CPUs
[   17.764632] cs5535-clockevt: Could not allocate MFGPT timer
[   17.769936] hidraw: raw HID events driver (C) Jiri Kosina
[   17.775017] Initializing Realtek PCIE storage driver...
[   17.779387] input: Speakup as /devices/virtual/input/input4
[   17.783643] evbug: Connected device: input4 (Speakup at speakup/input0)
[   17.787766] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[   17.792042] speakup 3.1.6: initialized
[   17.797309] synth name on entry is: (null)
[   17.801540] ashmem: initialized
[   17.805561] logger: created 256K log 'log_main'
[   17.809829] logger: created 256K log 'log_events'
[   17.814150] logger: created 256K log 'log_radio'
[   17.818024] logger: created 256K log 'log_system'
[   17.821855] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[   17.825857] dgap: For the tools package please visit http://www.digi.com
[   17.829927] FPGA DOWNLOAD --->
[   17.833563] FPGA image file name: xlinx_fpga_firmware.bit
[   17.837578] GPIO INIT FAIL!!
[   17.842384] hdaps: supported laptop not found!
[   17.845907] hdaps: driver init failed (ret=3D-19)!
[   17.850671]  fake-fmc-carrier: mezzanine 0
[   17.854040]       Manufacturer: fake-vendor
[   17.857386]       Product name: fake-design-for-testing
[   17.861022] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   17.864877] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[   17.868781] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   17.872683] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   17.876976] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   17.881026] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   17.886357]=20
[   17.886357] printing PIC contents
[   17.893282] ... PIC  IMR: ffff
[   17.896651] ... PIC  IRR: 1113
[   17.900149] ... PIC  ISR: 0000
[   17.905390] ... PIC ELCR: 0c00
[   17.908742] printing local APIC contents on CPU#0/0:
[   17.912025] ... APIC ID:      00000000 (0)
[   17.912025] ... APIC VERSION: 00050014
[   17.912025] ... APIC TASKPRI: 00000000 (00)
[   17.912025] ... APIC PROCPRI: 00000000
[   17.912025] ... APIC LDR: 01000000
[   17.912025] ... APIC DFR: ffffffff
[   17.912025] ... APIC SPIV: 000001ff
[   17.912025] ... APIC ISR field:
[   17.912025] 000000000000000000000000000000000000000000000000000000000000=
0000
[   17.912025] ... APIC TMR field:
[   17.912025] 000000000200000000000000000000000000000000000000000000000000=
0000
[   17.912025] ... APIC IRR field:
[   17.912025] 000000000000000000000000000000000000000000000000000000000000=
8000
[   17.912025] ... APIC ESR: 00000000
[   17.912025] ... APIC ICR: 000008fd
[   17.912025] ... APIC ICR2: 02000000
[   17.912025] ... APIC LVTT: 000000ef
[   17.912025] ... APIC LVTPC: 00010000
[   17.912025] ... APIC LVT0: 00010700
[   17.912025] ... APIC LVT1: 00000400
[   17.912025] ... APIC LVTERR: 000000fe
[   17.912025] ... APIC TMICT: 0003c9b6
[   17.912025] ... APIC TMCCT: 00000000
[   17.912025] ... APIC TDCR: 00000003
[   17.912025]=20
[   17.990029] number of MP IRQ sources: 15.
[   17.992727] number of IO-APIC #0 registers: 24.
[   17.995311] testing the IO APIC.......................
[   17.998077] IO APIC #0......
[   18.000469] .... register #00: 00000000
[   18.002932] .......    : physical APIC id: 00
[   18.005568] .......    : Delivery Type: 0
[   18.008044] .......    : LTS          : 0
[   18.010506] .... register #01: 00170011
[   18.012939] .......     : max redirection entries: 17
[   18.015516] .......     : PRQ implemented: 0
[   18.017958] .......     : IO APIC version: 11
[   18.020480] .... register #02: 00000000
[   18.022708] .......     : arbitration: 00
[   18.024913] .... IRQ redirection table:
[   18.027063] 1    0    0   0   0    0    0    00
[   18.029235] 0    0    0   0   0    1    1    31
[   18.031378] 0    0    0   0   0    1    1    30
[   18.033513] 0    0    0   0   0    1    1    33
[   18.035650] 1    0    0   0   0    1    1    34
[   18.037780] 1    1    0   0   0    1    1    35
[   18.039855] 0    0    0   0   0    1    1    36
[   18.041921] 0    0    0   0   0    1    1    37
[   18.043924] 0    0    0   0   0    1    1    38
[   18.045955] 0    1    0   0   0    1    1    39
[   18.047917] 1    1    0   0   0    1    1    3A
[   18.050006] 1    1    0   0   0    1    1    3B
[   18.051945] 0    0    0   0   0    1    1    3C
[   18.053864] 0    0    0   0   0    1    1    3D
[   18.055738] 0    0    0   0   0    1    1    3E
[   18.057615] 0    0    0   0   0    1    1    3F
[   18.059411] 1    0    0   0   0    0    0    00
[   18.061192] 1    0    0   0   0    0    0    00
[   18.062875] 1    0    0   0   0    0    0    00
[   18.064531] 1    0    0   0   0    0    0    00
[   18.066101] 1    0    0   0   0    0    0    00
[   18.067678] 1    0    0   0   0    0    0    00
[   18.069302] 1    0    0   0   0    0    0    00
[   18.070903] 1    0    0   0   0    0    0    00
[   18.072509] IRQ to pin mappings:
[   18.073938] IRQ0 -> 0:2
[   18.075329] IRQ1 -> 0:1
[   18.076683] IRQ3 -> 0:3
[   18.077992] IRQ4 -> 0:4
[   18.079394] IRQ5 -> 0:5
[   18.080794] IRQ6 -> 0:6
[   18.082166] IRQ7 -> 0:7
[   18.083511] IRQ8 -> 0:8
[   18.084820] IRQ9 -> 0:9
[   18.086058] IRQ10 -> 0:10
[   18.087287] IRQ11 -> 0:11
[   18.088499] IRQ12 -> 0:12
[   18.089653] IRQ13 -> 0:13
[   18.090785] IRQ14 -> 0:14
[   18.091890] IRQ15 -> 0:15
[   18.093012] .................................... done.
[   18.094421] Using IPI No-Shortcut mode
[   18.095943] Loading compiled-in X.509 certificates
[   18.097541] Running ring buffer tests...
[   28.100143] finished
[   28.101234] CPU 0:
[   28.101992]               events:    459860
[   28.102969]        dropped bytes:    0
[   28.103860]        alloced bytes:    35804532
[   28.105260]        written bytes:    35125202
[   28.106844]        biggest event:    178
[   28.108286]       smallest event:    4
[   28.115678]          read events:   12448
[   28.117225]          lost events:   447412
[   28.118709]         total events:   459860
[   28.120217]   recorded len bytes:   970456
[   28.121746]  recorded size bytes:   951973
[   28.123283]  With dropped events, record len and size may not match
[   28.123283]  alloced and written from above
[   28.126859] CPU 1:
[   28.128255]               events:    61588
[   28.129957]        dropped bytes:    0
[   28.131607]        alloced bytes:    4794252
[   28.133373]        written bytes:    4703161
[   28.135114]        biggest event:    213
[   28.136807]       smallest event:    4
[   28.141969]          read events:   11744
[   28.143758]          lost events:   49844
[   28.145071]         total events:   61588
[   28.146394]   recorded len bytes:   975928
[   28.147764]  recorded size bytes:   958826
[   28.149071]  With dropped events, record len and size may not match
[   28.149071]  alloced and written from above
[   28.151867] Ring buffer PASSED!
[   28.154415] Running tests on trace events:
[   28.156180] Testing event thermal_apic_exit:=20
[   28.172111] test-events (130) used greatest stack depth: 6968 bytes left
[   28.175843] OK
[   28.177145] Testing event thermal_apic_entry: OK
[   28.193628] Testing event threshold_apic_exit: OK
[   28.209702] Testing event threshold_apic_entry: OK
[   28.226084] Testing event call_function_single_exit: OK
[   28.242447] Testing event call_function_single_entry: OK
[   28.262646] Testing event call_function_exit: OK
[   28.278226] Testing event call_function_entry: OK
[   28.293838] Testing event irq_work_exit: OK
[   28.309945] Testing event irq_work_entry: OK
[   28.326785] Testing event x86_platform_ipi_exit: OK
[   28.342200] Testing event x86_platform_ipi_entry: OK
[   28.358119] Testing event error_apic_exit: OK
[   28.374107] Testing event error_apic_entry: OK
[   28.390169] Testing event spurious_apic_exit: OK
[   28.410178] Testing event spurious_apic_entry: OK
[   28.427607] Testing event reschedule_exit: OK
[   28.450309] Testing event reschedule_entry: OK
[   28.470247] Testing event local_timer_exit: OK
[   28.491109] Testing event local_timer_entry: OK
[   28.511202] Testing event nmi_handler: OK
[   28.530229] Testing event sys_exit: OK
[   28.546335] Testing event sys_enter: OK
[   28.562129] Testing event tlb_flush: OK
[   28.578860] Testing event page_fault_kernel: OK
[   28.594083] Testing event page_fault_user: OK
[   28.610084] Testing event task_rename: OK
[   28.630064] Testing event task_newtask: OK
[   28.646779] Testing event softirq_raise: OK
[   28.666423] Testing event softirq_exit: OK
[   28.682057] Testing event softirq_entry: OK
[   28.698073] Testing event irq_handler_exit: OK
[   28.714244] Testing event irq_handler_entry: OK
[   28.734653] Testing event signal_deliver: OK
[   28.754259] Testing event signal_generate: OK
[   28.772062] Testing event workqueue_execute_end: OK
[   28.790397] Testing event workqueue_execute_start: OK
[   28.806350] Testing event workqueue_activate_work: OK
[   28.822359] Testing event workqueue_queue_work: OK
[   28.838257] Testing event sched_wake_idle_without_ipi: OK
[   28.854798] Testing event sched_swap_numa: OK
[   28.870330] Testing event sched_stick_numa: OK
[   28.890537] Testing event sched_move_numa: OK
[   28.906255] Testing event sched_pi_setprio: OK
[   28.922139] Testing event sched_stat_runtime:=20
[   28.936147] test-events (175) used greatest stack depth: 6952 bytes left
[   28.940505] OK
[   28.942208] Testing event sched_stat_blocked: OK
[   28.962082] Testing event sched_stat_iowait: OK
[   28.978200] Testing event sched_stat_sleep: OK
[   28.994522] Testing event sched_stat_wait: OK
[   29.010213] Testing event sched_process_exec: OK
[   29.026149] Testing event sched_process_fork: OK
[   29.042031] Testing event sched_process_wait: OK
[   29.058165] Testing event sched_wait_task: OK
[   29.073559] Testing event sched_process_exit: OK
[   29.089674] Testing event sched_process_free: OK
[   29.106927] Testing event sched_migrate_task: OK
[   29.125639] Testing event sched_switch: OK
[   29.141874] Testing event sched_wakeup_new: OK
[   29.161826] Testing event sched_wakeup: OK
[   29.181966] Testing event sched_kthread_stop_ret: OK
[   29.199482] Testing event sched_kthread_stop: OK
[   29.221588] Testing event lock_acquired: OK
[   29.243218] Testing event lock_contended: OK
[   29.261868] Testing event lock_release: OK
[   29.280083] Testing event lock_acquire:=20
[   29.281153] test-events (194) used greatest stack depth: 6940 bytes left
[   29.300152] test-events (195) used greatest stack depth: 6900 bytes left
[   29.304691] OK
[   29.306694] Testing event console: OK
[   29.321614] Testing event rcu_utilization: OK
[   29.338219] Testing event itimer_expire: OK
[   29.353888] Testing event itimer_state: OK
[   29.369945] Testing event hrtimer_cancel: OK
[   29.389923] Testing event hrtimer_expire_exit: OK
[   29.406269] Testing event hrtimer_expire_entry: OK
[   29.422844] Testing event hrtimer_start: OK
[   29.441763] Testing event hrtimer_init: OK
[   29.462460] Testing event timer_cancel: OK
[   29.478107] Testing event timer_expire_exit: OK
[   29.494136] Testing event timer_expire_entry: OK
[   29.510277] Testing event timer_start: OK
[   29.526726] Testing event timer_init: OK
[   29.542176] Testing event ftrace_test_filter: OK
[   29.557624] Testing event dev_pm_qos_remove_request: OK
[   29.574280] Testing event dev_pm_qos_update_request: OK
[   29.589725] Testing event dev_pm_qos_add_request: OK
[   29.606431] Testing event pm_qos_update_flags: OK
[   29.621795] Testing event pm_qos_update_target: OK
[   29.637593] Testing event pm_qos_update_request_timeout: OK
[   29.658227] Testing event pm_qos_remove_request: OK
[   29.674145] Testing event pm_qos_update_request: OK
[   29.690239] Testing event pm_qos_add_request: OK
[   29.706104] Testing event power_domain_target: OK
[   29.721956] Testing event clock_set_rate: OK
[   29.737628] Testing event clock_disable: OK
[   29.757798] Testing event clock_enable: OK
[   29.773507] Testing event wakeup_source_deactivate: OK
[   29.790063] Testing event wakeup_source_activate: OK
[   29.806835] Testing event suspend_resume: OK
[   29.828009] Testing event device_pm_callback_end: OK
[   29.846150] Testing event device_pm_callback_start: OK
[   29.861801] Testing event cpu_frequency: OK
[   29.878656] Testing event pstate_sample: OK
[   29.897991] Testing event cpu_idle: OK
[   29.914297] Testing event mm_filemap_add_to_page_cache: OK
[   29.937280] Testing event mm_filemap_delete_from_page_cache: OK
[   29.957421] Testing event oom_score_adj_update: OK
[   29.974315] Testing event mm_lru_activate: OK
[   29.997063] Testing event mm_lru_insertion: OK
[   30.020911] Testing event mm_vmscan_lru_shrink_inactive: OK
[   30.039704] Testing event mm_vmscan_writepage: OK
[   30.059666] Testing event mm_vmscan_memcg_isolate: OK
[   30.078261] Testing event mm_vmscan_lru_isolate: OK
[   30.098257] Testing event mm_shrink_slab_end: OK
[   30.120240] Testing event mm_shrink_slab_start: OK
[   30.137700] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   30.158781] Testing event mm_vmscan_memcg_reclaim_end: OK
[   30.174448] Testing event mm_vmscan_direct_reclaim_end: OK
[   30.190506] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   30.210135] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   30.230239] Testing event mm_vmscan_direct_reclaim_begin: OK
[   30.247679] Testing event mm_vmscan_wakeup_kswapd: OK
[   30.270490] Testing event mm_vmscan_kswapd_wake: OK
[   30.290355] Testing event mm_vmscan_kswapd_sleep: OK
[   30.306461] Testing event mm_page_alloc_extfrag: OK
[   30.322857] Testing event mm_page_pcpu_drain: OK
[   30.342540] Testing event mm_page_alloc_zone_locked: OK
[   30.362637] Testing event mm_page_alloc: OK
[   30.382420] Testing event mm_page_free_batched: OK
[   30.399057] Testing event mm_page_free: OK
[   30.422580] Testing event kmem_cache_free: OK
[   30.438398] Testing event kfree: OK
[   30.454937] Testing event kmem_cache_alloc_node: OK
[   30.478569] Testing event kmalloc_node: OK
[   30.498420] Testing event kmem_cache_alloc: OK
[   30.514213] Testing event kmalloc: OK
[   30.532148] Testing event writeback_single_inode: OK
[   30.550779] Testing event writeback_single_inode_start: OK
[   30.571187] Testing event writeback_wait_iff_congested: OK
[   30.590679] Testing event writeback_congestion_wait: OK
[   30.610582] Testing event writeback_sb_inodes_requeue: OK
[   30.630462] Testing event balance_dirty_pages: OK
[   30.646415] Testing event bdi_dirty_ratelimit: OK
[   30.662194] Testing event global_dirty_state: OK
[   30.677999] Testing event writeback_queue_io: OK
[   30.694071] Testing event wbc_writepage: OK
[   30.710044] Testing event writeback_bdi_unregister: OK
[   30.726437] Testing event writeback_bdi_register: OK
[   30.742445] Testing event writeback_wake_background: OK
[   30.757710] Testing event writeback_nowork: OK
[   30.774312] Testing event writeback_pages_written: OK
[   30.790896] Testing event writeback_wait: OK
[   30.810268] Testing event writeback_written: OK
[   30.827041] Testing event writeback_start: OK
[   30.841876] Testing event writeback_exec: OK
[   30.858173] Testing event writeback_queue: OK
[   30.874222] Testing event writeback_write_inode: OK
[   30.890437] Testing event writeback_write_inode_start: OK
[   30.905824] Testing event writeback_dirty_inode: OK
[   30.921723] Testing event writeback_dirty_inode_start: OK
[   30.937818] Testing event writeback_dirty_page: OK
[   30.954465] Testing event time_out_leases: OK
[   30.970084] Testing event generic_delete_lease: OK
[   30.986067] Testing event generic_add_lease: OK
[   31.006603] Testing event break_lease_unblock: OK
[   31.022575] Testing event break_lease_block: OK
[   31.042815] Testing event break_lease_noblock: OK
[   31.058328] Testing event ext3_load_inode: OK
[   31.074277] Testing event ext3_get_blocks_exit: OK
[   31.089917] Testing event ext3_get_blocks_enter: OK
[   31.106464] Testing event ext3_truncate_exit: OK
[   31.122379] Testing event ext3_truncate_enter: OK
[   31.138229] Testing event ext3_unlink_exit: OK
[   31.154266] Testing event ext3_unlink_enter: OK
[   31.170266] Testing event ext3_direct_IO_exit: OK
[   31.186114] Testing event ext3_direct_IO_enter: OK
[   31.202028] Testing event ext3_read_block_bitmap: OK
[   31.218207] Testing event ext3_forget: OK
[   31.234240] Testing event ext3_reserved: OK
[   31.250041] Testing event ext3_alloc_new_reservation: OK
[   31.266336] Testing event ext3_discard_reservation: OK
[   31.282195] Testing event ext3_rsv_window_add: OK
[   31.298243] Testing event ext3_sync_fs: OK
[   31.314090] Testing event ext3_sync_file_exit: OK
[   31.334212] Testing event ext3_sync_file_enter: OK
[   31.350129] Testing event ext3_free_blocks: OK
[   31.366371] Testing event ext3_allocate_blocks: OK
[   31.382234] Testing event ext3_request_blocks: OK
[   31.398727] Testing event ext3_discard_blocks: OK
[   31.418521] Testing event ext3_invalidatepage: OK
[   31.434915] Testing event ext3_releasepage: OK
[   31.450076] Testing event ext3_readpage: OK
[   31.466097] Testing event ext3_journalled_writepage: OK
[   31.482022] Testing event ext3_writeback_writepage: OK
[   31.497990] Testing event ext3_ordered_writepage: OK
[   31.514335] Testing event ext3_journalled_write_end: OK
[   31.530239] Testing event ext3_writeback_write_end: OK
[   31.546103] Testing event ext3_ordered_write_end: OK
[   31.562252] Testing event ext3_write_begin: OK
[   31.578270] Testing event ext3_mark_inode_dirty: OK
[   31.594027] Testing event ext3_drop_inode: OK
[   31.614320] Testing event ext3_evict_inode: OK
[   31.629850] Testing event ext3_allocate_inode: OK
[   31.646174] Testing event ext3_request_inode: OK
[   31.662273] Testing event ext3_free_inode: OK
[   31.678065] Testing event ext4_es_shrink: OK
[   31.698947] Testing event ext4_collapse_range: OK
[   31.718545] Testing event ext4_es_shrink_scan_exit: OK
[   31.733706] Testing event ext4_es_shrink_scan_enter: OK
[   31.750212] Testing event ext4_es_shrink_count: OK
[   31.766334] Testing event ext4_es_lookup_extent_exit: OK
[   31.782101] Testing event ext4_es_lookup_extent_enter: OK
[   31.797879] Testing event ext4_es_find_delayed_extent_range_exit: OK
[   31.813915] Testing event ext4_es_find_delayed_extent_range_enter: OK
[   31.830006] Testing event ext4_es_remove_extent: OK
[   31.846610] Testing event ext4_es_cache_extent: OK
[   31.862259] Testing event ext4_es_insert_extent: OK
[   31.878196] Testing event ext4_ext_remove_space_done: OK
[   31.900560] Testing event ext4_ext_remove_space: OK
[   31.918111] Testing event ext4_ext_rm_idx: OK
[   31.935547] Testing event ext4_ext_rm_leaf: OK
[   31.954410] Testing event ext4_remove_blocks: OK
[   31.970141] Testing event ext4_ext_show_extent: OK
[   31.986348] Testing event ext4_get_reserved_cluster_alloc: OK
[   32.002432] Testing event ext4_find_delalloc_range: OK
[   32.018001] Testing event ext4_ext_in_cache: OK
[   32.034249] Testing event ext4_ext_put_in_cache: OK
[   32.050210] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   32.066306] Testing event ext4_ext_handle_unwritten_extents: OK
[   32.082115] Testing event ext4_trim_all_free: OK
[   32.098427] Testing event ext4_trim_extent: OK
[   32.114241] Testing event ext4_journal_start_reserved: OK
[   32.130903] Testing event ext4_journal_start: OK
[   32.150755] Testing event ext4_load_inode: OK
[   32.166408] Testing event ext4_ext_load_extent: OK
[   32.182134] Testing event ext4_ind_map_blocks_exit: OK
[   32.198403] Testing event ext4_ext_map_blocks_exit: OK
[   32.213767] Testing event ext4_ind_map_blocks_enter: OK
[   32.229829] Testing event ext4_ext_map_blocks_enter: OK
[   32.246797] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   32.266297] Testing event ext4_ext_convert_to_initialized_enter: OK
[   32.281971] Testing event ext4_truncate_exit: OK
[   32.298248] Testing event ext4_truncate_enter: OK
[   32.314223] Testing event ext4_unlink_exit: OK
[   32.330658] Testing event ext4_unlink_enter: OK
[   32.346226] Testing event ext4_fallocate_exit: OK
[   32.362200] Testing event ext4_zero_range: OK
[   32.378284] Testing event ext4_punch_hole: OK
[   32.394313] Testing event ext4_fallocate_enter: OK
[   32.410252] Testing event ext4_direct_IO_exit: OK
[   32.426194] Testing event ext4_direct_IO_enter: OK
[   32.442294] Testing event ext4_load_inode_bitmap: OK
[   32.462129] Testing event ext4_read_block_bitmap_load: OK
[   32.482198] Testing event ext4_mb_buddy_bitmap_load: OK
[   32.497983] Testing event ext4_mb_bitmap_load: OK
[   32.514138] Testing event ext4_da_release_space: OK
[   32.530263] Testing event ext4_da_reserve_space: OK
[   32.546979] Testing event ext4_da_update_reserve_space: OK
[   32.567000] Testing event ext4_forget: OK
[   32.586217] Testing event ext4_mballoc_free: OK
[   32.602245] Testing event ext4_mballoc_discard: OK
[   32.622574] Testing event ext4_mballoc_prealloc: OK
[   32.639690] Testing event ext4_mballoc_alloc: OK
[   32.658213] Testing event ext4_alloc_da_blocks: OK
[   32.673922] Testing event ext4_sync_fs: OK
[   32.690224] Testing event ext4_sync_file_exit: OK
[   32.706293] Testing event ext4_sync_file_enter: OK
[   32.721897] Testing event ext4_free_blocks: OK
[   32.738124] Testing event ext4_allocate_blocks: OK
[   32.754213] Testing event ext4_request_blocks: OK
[   32.769871] Testing event ext4_mb_discard_preallocations: OK
[   32.785662] Testing event ext4_discard_preallocations: OK
[   32.801717] Testing event ext4_mb_release_group_pa: OK
[   32.820639] Testing event ext4_mb_release_inode_pa: OK
[   32.838315] Testing event ext4_mb_new_group_pa: OK
[   32.858614] Testing event ext4_mb_new_inode_pa: OK
[   32.874009] Testing event ext4_discard_blocks: OK
[   32.894616] Testing event ext4_journalled_invalidatepage: OK
[   32.913594] Testing event ext4_invalidatepage: OK
[   32.934321] Testing event ext4_releasepage: OK
[   32.949935] Testing event ext4_readpage: OK
[   32.966237] Testing event ext4_writepage: OK
[   32.982413] Testing event ext4_writepages_result: OK
[   32.997703] Testing event ext4_da_write_pages_extent: OK
[   33.013729] Testing event ext4_da_write_pages: OK
[   33.029975] Testing event ext4_writepages: OK
[   33.045782] Testing event ext4_da_write_end: OK
[   33.066423] Testing event ext4_journalled_write_end: OK
[   33.082508] Testing event ext4_write_end: OK
[   33.102156] Testing event ext4_da_write_begin: OK
[   33.117608] Testing event ext4_write_begin: OK
[   33.133894] Testing event ext4_begin_ordered_truncate: OK
[   33.150143] Testing event ext4_mark_inode_dirty: OK
[   33.165686] Testing event ext4_drop_inode: OK
[   33.181845] Testing event ext4_evict_inode: OK
[   33.197613] Testing event ext4_allocate_inode: OK
[   33.214119] Testing event ext4_request_inode: OK
[   33.229818] Testing event ext4_free_inode: OK
[   33.246198] Testing event journal_write_superblock: OK
[   33.262351] Testing event jbd_cleanup_journal_tail: OK
[   33.277727] Testing event jbd_do_submit_data: OK
[   33.293839] Testing event jbd_end_commit: OK
[   33.309790] Testing event jbd_drop_transaction: OK
[   33.325937] Testing event jbd_commit_logging: OK
[   33.342085] Testing event jbd_commit_flushing: OK
[   33.361986] Testing event jbd_commit_locking: OK
[   33.378031] Testing event jbd_start_commit: OK
[   33.393906] Testing event jbd_checkpoint: OK
[   33.409939] Testing event jbd2_lock_buffer_stall: OK
[   33.430163] Testing event jbd2_write_superblock: OK
[   33.446087] Testing event jbd2_update_log_tail: OK
[   33.462332] Testing event jbd2_checkpoint_stats: OK
[   33.481564] Testing event jbd2_run_stats: OK
[   33.497924] Testing event jbd2_handle_stats: OK
[   33.513801] Testing event jbd2_handle_extend: OK
[   33.531167] Testing event jbd2_handle_start: OK
[   33.554581] Testing event jbd2_submit_inode_data: OK
[   33.572178] Testing event jbd2_end_commit: OK
[   33.594887] Testing event jbd2_drop_transaction: OK
[   33.610043] Testing event jbd2_commit_logging: OK
[   33.629885] Testing event jbd2_commit_flushing: OK
[   33.650107] Testing event jbd2_commit_locking: OK
[   33.666195] Testing event jbd2_start_commit: OK
[   33.681900] Testing event jbd2_checkpoint: OK
[   33.698105] Testing event xfs_discard_busy: OK
[   33.714218] Testing event xfs_discard_exclude: OK
[   33.730092] Testing event xfs_discard_toosmall: OK
[   33.754329] Testing event xfs_discard_extent: OK
[   33.770106] Testing event xfs_log_recover_inode_skip: OK
[   33.786007] Testing event xfs_log_recover_inode_cancel: OK
[   33.802276] Testing event xfs_log_recover_inode_recover: OK
[   33.818418] Testing event xfs_log_recover_buf_dquot_buf: OK
[   33.834542] Testing event xfs_log_recover_buf_reg_buf: OK
[   33.850989] Testing event xfs_log_recover_buf_inode_buf: OK
[   33.870022] Testing event xfs_log_recover_buf_recover: OK
[   33.886031] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   33.902169] Testing event xfs_log_recover_buf_cancel_add: OK
[   33.918253] Testing event xfs_log_recover_buf_cancel: OK
[   33.933911] Testing event xfs_log_recover_buf_not_cancel: OK
[   33.949935] Testing event xfs_log_recover_item_recover: OK
[   33.966435] Testing event xfs_log_recover_item_reorder_tail: OK
[   33.982112] Testing event xfs_log_recover_item_reorder_head: OK
[   34.002212] Testing event xfs_log_recover_item_add_cont: OK
[   34.022234] Testing event xfs_log_recover_item_add: OK
[   34.042755] Testing event xfs_swap_extent_after: OK
[   34.057676] Testing event xfs_swap_extent_before: OK
[   34.073797] Testing event xfs_dir2_leafn_moveents: OK
[   34.090457] Testing event xfs_dir2_shrink_inode: OK
[   34.105935] Testing event xfs_dir2_grow_inode: OK
[   34.121837] Testing event xfs_dir2_leafn_remove: OK
[   34.139116] Testing event xfs_dir2_leafn_add: OK
[   34.157824] Testing event xfs_da_path_shift: OK
[   34.173846] Testing event xfs_da_fixhashpath: OK
[   34.190074] Testing event xfs_da_shrink_inode: OK
[   34.205971] Testing event xfs_da_grow_inode: OK
[   34.227686] Testing event xfs_da_swap_lastblock: OK
[   34.245823] Testing event xfs_da_node_toosmall: OK
[   34.269919] Testing event xfs_da_node_unbalance: OK
[   34.285644] Testing event xfs_da_node_rebalance: OK
[   34.301859] Testing event xfs_da_node_remove: OK
[   34.317694] Testing event xfs_da_node_split: OK
[   34.333715] Testing event xfs_da_node_create: OK
[   34.349853] Testing event xfs_da_node_add: OK
[   34.365726] Testing event xfs_da_root_join: OK
[   34.381683] Testing event xfs_da_root_split: OK
[   34.397758] Testing event xfs_da_unlink_forward: OK
[   34.413765] Testing event xfs_da_unlink_back: OK
[   34.433972] Testing event xfs_da_link_after: OK
[   34.449507] Testing event xfs_da_link_before: OK
[   34.465898] Testing event xfs_da_join: OK
[   34.482302] Testing event xfs_da_split: OK
[   34.501714] Testing event xfs_attr_rmtval_remove: OK
[   34.517858] Testing event xfs_attr_rmtval_set: OK
[   34.533702] Testing event xfs_attr_rmtval_get: OK
[   34.550821] Testing event xfs_attr_refillstate: OK
[   34.565999] Testing event xfs_attr_fillstate: OK
[   34.582511] Testing event xfs_attr_node_removename: OK
[   34.597863] Testing event xfs_attr_node_replace: OK
[   34.613781] Testing event xfs_attr_node_lookup: OK
[   34.629833] Testing event xfs_attr_node_get: OK
[   34.645782] Testing event xfs_attr_node_addname: OK
[   34.661725] Testing event xfs_attr_leaf_toosmall: OK
[   34.677316] Testing event xfs_attr_leaf_unbalance: OK
[   34.693774] Testing event xfs_attr_leaf_rebalance: OK
[   34.709985] Testing event xfs_attr_leaf_to_node: OK
[   34.726185] Testing event xfs_attr_leaf_to_sf: OK
[   34.745565] Testing event xfs_attr_leaf_flipflags: OK
[   34.761579] Testing event xfs_attr_leaf_setflag: OK
[   34.777879] Testing event xfs_attr_leaf_clearflag: OK
[   34.793702] Testing event xfs_attr_leaf_split_after: OK
[   34.809943] Testing event xfs_attr_leaf_split_before: OK
[   34.825637] Testing event xfs_attr_leaf_split: OK
[   34.841455] Testing event xfs_attr_leaf_removename: OK
[   34.857602] Testing event xfs_attr_leaf_remove: OK
[   34.873506] Testing event xfs_attr_leaf_replace: OK
[   34.889643] Testing event xfs_attr_leaf_lookup: OK
[   34.905720] Testing event xfs_attr_leaf_get: OK
[   34.921781] Testing event xfs_attr_leaf_compact: OK
[   34.937658] Testing event xfs_attr_leaf_create: OK
[   34.953813] Testing event xfs_attr_leaf_addname: OK
[   34.973610] Testing event xfs_attr_leaf_add_work: OK
[   34.990172] Testing event xfs_attr_leaf_add_new: OK
[   35.005801] Testing event xfs_attr_leaf_add_old: OK
[   35.021988] Testing event xfs_attr_leaf_add: OK
[   35.037680] Testing event xfs_attr_sf_to_leaf: OK
[   35.053569] Testing event xfs_attr_sf_removename: OK
[   35.069174] Testing event xfs_attr_sf_remove: OK
[   35.085878] Testing event xfs_attr_sf_lookup: OK
[   35.101715] Testing event xfs_attr_sf_create: OK
[   35.117296] Testing event xfs_attr_sf_addname: OK
[   35.137305] Testing event xfs_attr_sf_add: OK
[   35.157306] Testing event xfs_dir2_node_to_leaf: OK
[   35.174200] Testing event xfs_dir2_node_removename: OK
[   35.190211] Testing event xfs_dir2_node_replace: OK
[   35.205802] Testing event xfs_dir2_node_lookup: OK
[   35.221652] Testing event xfs_dir2_node_addname: OK
[   35.237555] Testing event xfs_dir2_leaf_to_node: OK
[   35.253930] Testing event xfs_dir2_leaf_to_block: OK
[   35.269566] Testing event xfs_dir2_leaf_removename: OK
[   35.285539] Testing event xfs_dir2_leaf_replace: OK
[   35.301616] Testing event xfs_dir2_leaf_lookup: OK
[   35.321673] Testing event xfs_dir2_leaf_addname: OK
[   35.337695] Testing event xfs_dir2_block_to_leaf: OK
[   35.353965] Testing event xfs_dir2_block_to_sf: OK
[   35.369702] Testing event xfs_dir2_block_removename: OK
[   35.385243] Testing event xfs_dir2_block_replace: OK
[   35.405262] Testing event xfs_dir2_block_lookup: OK
[   35.421278] Testing event xfs_dir2_block_addname: OK
[   35.437684] Testing event xfs_dir2_sf_to_block: OK
[   35.457932] Testing event xfs_dir2_sf_toino8: OK
[   35.477791] Testing event xfs_dir2_sf_toino4: OK
[   35.497643] Testing event xfs_dir2_sf_removename: OK
[   35.517194] Testing event xfs_dir2_sf_replace: OK
[   35.537148] Testing event xfs_dir2_sf_lookup: OK
[   35.557175] Testing event xfs_dir2_sf_create: OK
[   35.573427] Testing event xfs_dir2_sf_addname: OK
[   35.589239] Testing event xfs_alloc_vextent_allfailed: OK
[   35.605535] Testing event xfs_alloc_vextent_loopfailed: OK
[   35.621385] Testing event xfs_alloc_vextent_noagbp: OK
[   35.637197] Testing event xfs_alloc_vextent_nofix: OK
[   35.653291] Testing event xfs_alloc_vextent_badargs: OK
[   35.669161] Testing event xfs_alloc_small_error: OK
[   35.685183] Testing event xfs_alloc_small_done: OK
[   35.701218] Testing event xfs_alloc_small_notenough: OK
[   35.717165] Testing event xfs_alloc_small_freelist: OK
[   35.733100] Testing event xfs_alloc_size_busy: OK
[   35.749271] Testing event xfs_alloc_size_error: OK
[   35.765378] Testing event xfs_alloc_size_done: OK
[   35.781306] Testing event xfs_alloc_size_nominleft: OK
[   35.797317] Testing event xfs_alloc_size_noentry: OK
[   35.813342] Testing event xfs_alloc_size_neither: OK
[   35.829387] Testing event xfs_alloc_near_busy: OK
[   35.845472] Testing event xfs_alloc_near_noentry: OK
[   35.861266] Testing event xfs_alloc_near_error: OK
[   35.877373] Testing event xfs_alloc_near_lesser: OK
[   35.893697] Testing event xfs_alloc_near_greater: OK
[   35.913863] Testing event xfs_alloc_near_first: OK
[   35.929670] Testing event xfs_alloc_near_nominleft: OK
[   35.946341] Testing event xfs_alloc_exact_error: OK
[   35.961284] Testing event xfs_alloc_exact_notfound: OK
[   35.977636] Testing event xfs_alloc_exact_done: OK
[   35.993396] Testing event xfs_free_extent: OK
[   36.009708] Testing event xfs_agf: OK
[   36.025704] Testing event xfs_trans_commit_lsn: OK
[   36.041267] Testing event xfs_extent_busy_trim: OK
[   36.058099] Testing event xfs_extent_busy_clear: OK
[   36.074033] Testing event xfs_extent_busy_reuse: OK
[   36.089648] Testing event xfs_extent_busy_force: OK
[   36.105595] Testing event xfs_extent_busy_enomem: OK
[   36.121498] Testing event xfs_extent_busy: OK
[   36.137522] Testing event xfs_bunmap: OK
[   36.153508] Testing event xfs_pagecache_inval: OK
[   36.169483] Testing event xfs_itruncate_extents_end: OK
[   36.185522] Testing event xfs_itruncate_extents_start: OK
[   36.201981] Testing event xfs_setfilesize: OK
[   36.217969] Testing event xfs_get_blocks_notfound: OK
[   36.233899] Testing event xfs_unwritten_convert: OK
[   36.249669] Testing event xfs_delalloc_enospc: OK
[   36.266658] Testing event xfs_get_blocks_alloc: OK
[   36.285823] Testing event xfs_get_blocks_found: OK
[   36.301798] Testing event xfs_map_blocks_alloc: OK
[   36.317634] Testing event xfs_map_blocks_found: OK
[   36.333763] Testing event xfs_invalidatepage: OK
[   36.349659] Testing event xfs_releasepage: OK
[   36.365808] Testing event xfs_writepage: OK
[   36.381720] Testing event xfs_file_splice_read: OK
[   36.397731] Testing event xfs_file_direct_write: OK
[   36.413918] Testing event xfs_file_buffered_write: OK
[   36.429733] Testing event xfs_file_read: OK
[   36.446028] Testing event xfs_log_assign_tail_lsn: OK
[   36.466090] Testing event xfs_ail_delete: OK
[   36.481729] Testing event xfs_ail_move: OK
[   36.497706] Testing event xfs_ail_insert: OK
[   36.513824] Testing event xfs_ail_flushing: OK
[   36.529738] Testing event xfs_ail_locked: OK
[   36.545867] Testing event xfs_ail_pinned: OK
[   36.561694] Testing event xfs_ail_push: OK
[   36.577980] Testing event xfs_log_force: OK
[   36.594417] Testing event xfs_log_ungrant_sub: OK
[   36.609810] Testing event xfs_log_ungrant_exit: OK
[   36.625809] Testing event xfs_log_ungrant_enter: OK
[   36.641732] Testing event xfs_log_regrant_reserve_sub: OK
[   36.658031] Testing event xfs_log_regrant_reserve_exit: OK
[   36.674076] Testing event xfs_log_regrant_reserve_enter: OK
[   36.689849] Testing event xfs_log_regrant_exit: OK
[   36.705576] Testing event xfs_log_regrant: OK
[   36.721681] Testing event xfs_log_reserve_exit: OK
[   36.737388] Testing event xfs_log_reserve: OK
[   36.753820] Testing event xfs_log_grant_wake_up: OK
[   36.770081] Testing event xfs_log_grant_wake: OK
[   36.790826] Testing event xfs_log_grant_sleep: OK
[   36.810256] Testing event xfs_log_umount_write: OK
[   36.825719] Testing event xfs_log_done_perm: OK
[   36.841341] Testing event xfs_log_done_nonperm: OK
[   36.857374] Testing event xfs_dqflush_done: OK
[   36.873493] Testing event xfs_dqflush_force: OK
[   36.893458] Testing event xfs_dqflush: OK
[   36.909308] Testing event xfs_dqrele: OK
[   36.925792] Testing event xfs_dqput_free: OK
[   36.945673] Testing event xfs_dqput_wait: OK
[   36.961267] Testing event xfs_dqput: OK
[   36.977474] Testing event xfs_dqget_dup: OK
[   36.993388] Testing event xfs_dqget_freeing: OK
[   37.013453] Testing event xfs_dqget_miss: OK
[   37.029262] Testing event xfs_dqget_hit: OK
[   37.045177] Testing event xfs_dqread_fail: OK
[   37.061194] Testing event xfs_dqread: OK
[   37.081141] Testing event xfs_dqtobp_read: OK
[   37.101285] Testing event xfs_dqalloc: OK
[   37.117146] Testing event xfs_dqattach_get: OK
[   37.133239] Testing event xfs_dqattach_found: OK
[   37.149403] Testing event xfs_dqreclaim_done: OK
[   37.165339] Testing event xfs_dqreclaim_busy: OK
[   37.181364] Testing event xfs_dqreclaim_dirty: OK
[   37.197239] Testing event xfs_dqreclaim_want: OK
[   37.214034] Testing event xfs_dqadjust: OK
[   37.229655] Testing event xfs_rename: OK
[   37.245703] Testing event xfs_symlink: OK
[   37.261511] Testing event xfs_create: OK
[   37.277549] Testing event xfs_lookup: OK
[   37.293513] Testing event xfs_link: OK
[   37.309748] Testing event xfs_remove: OK
[   37.325752] Testing event xfs_inode_unpin_nowait: OK
[   37.341685] Testing event xfs_inode_unpin: OK
[   37.357705] Testing event xfs_inode_pin: OK
[   37.373769] Testing event xfs_irele: OK
[   37.390849] Testing event xfs_ihold: OK
[   37.405482] Testing event xfs_iomap_prealloc_size: OK
[   37.421600] Testing event xfs_inode_free_eofblocks_invalid: OK
[   37.438649] Testing event xfs_inode_clear_eofblocks_tag: OK
[   37.453639] Testing event xfs_inode_set_eofblocks_tag: OK
[   37.469875] Testing event xfs_dquot_dqdetach: OK
[   37.485726] Testing event xfs_dquot_dqalloc: OK
[   37.501547] Testing event xfs_update_time: OK
[   37.517603] Testing event xfs_evict_inode: OK
[   37.534496] Testing event xfs_destroy_inode: OK
[   37.549652] Testing event xfs_file_fsync: OK
[   37.565719] Testing event xfs_dir_fsync: OK
[   37.581650] Testing event xfs_ioctl_setattr: OK
[   37.597767] Testing event xfs_file_compat_ioctl: OK
[   37.613837] Testing event xfs_file_ioctl: OK
[   37.629712] Testing event xfs_vm_bmap: OK
[   37.645883] Testing event xfs_get_acl: OK
[   37.661855] Testing event xfs_readdir: OK
[   37.677539] Testing event xfs_collapse_file_space: OK
[   37.693786] Testing event xfs_zero_file_space: OK
[   37.709964] Testing event xfs_free_file_space: OK
[   37.725878] Testing event xfs_alloc_file_space: OK
[   37.741762] Testing event xfs_inactive_symlink: OK
[   37.757661] Testing event xfs_readlink: OK
[   37.773606] Testing event xfs_setattr: OK
[   37.789724] Testing event xfs_getattr: OK
[   37.805855] Testing event xfs_iget_miss: OK
[   37.821839] Testing event xfs_iget_hit: OK
[   37.837783] Testing event xfs_iget_reclaim_fail: OK
[   37.853834] Testing event xfs_iget_reclaim: OK
[   37.869945] Testing event xfs_iget_skip: OK
[   37.886049] Testing event xfs_iunlock: OK
[   37.901786] Testing event xfs_ilock_demote: OK
[   37.917839] Testing event xfs_ilock_nowait: OK
[   37.934842] Testing event xfs_ilock: OK
[   37.949763] Testing event xfs_filestream_pick: OK
[   37.966080] Testing event xfs_filestream_scan: OK
[   37.985738] Testing event xfs_filestream_lookup: OK
[   38.001986] Testing event xfs_filestream_free: OK
[   38.017808] Testing event xfs_trans_buf_ordered: OK
[   38.033780] Testing event xfs_trans_binval: OK
[   38.049786] Testing event xfs_trans_bhold_release: OK
[   38.065767] Testing event xfs_trans_bhold: OK
[   38.081814] Testing event xfs_trans_bjoin: OK
[   38.097804] Testing event xfs_trans_brelse: OK
[   38.117779] Testing event xfs_trans_log_buf: OK
[   38.133862] Testing event xfs_trans_read_buf_recur: OK
[   38.149904] Testing event xfs_trans_read_buf: OK
[   38.165863] Testing event xfs_trans_getsb_recur: OK
[   38.181778] Testing event xfs_trans_getsb: OK
[   38.197762] Testing event xfs_trans_get_buf_recur: OK
[   38.213684] Testing event xfs_trans_get_buf: OK
[   38.229669] Testing event xfs_buf_item_push: OK
[   38.245667] Testing event xfs_buf_item_committed: OK
[   38.262296] Testing event xfs_buf_item_unlock_stale: OK
[   38.277681] Testing event xfs_buf_item_unlock: OK
[   38.293763] Testing event xfs_buf_item_unpin_stale: OK
[   38.309720] Testing event xfs_buf_item_unpin: OK
[   38.325358] Testing event xfs_buf_item_pin: OK
[   38.341433] Testing event xfs_buf_item_ordered: OK
[   38.357340] Testing event xfs_buf_item_format_stale: OK
[   38.373231] Testing event xfs_buf_item_format_ordered: OK
[   38.389528] Testing event xfs_buf_item_format: OK
[   38.405740] Testing event xfs_buf_item_size_stale: OK
[   38.421517] Testing event xfs_buf_item_size_ordered: OK
[   38.438085] Testing event xfs_buf_item_size: OK
[   38.454094] Testing event xfs_buf_ioerror: OK
[   38.473986] Testing event xfs_buf_read: OK
[   38.489503] Testing event xfs_buf_get: OK
[   38.505620] Testing event xfs_buf_find: OK
[   38.521567] Testing event xfs_inode_item_push: OK
[   38.537313] Testing event xfs_reset_dqcounts: OK
[   38.553302] Testing event xfs_da_btree_corrupt: OK
[   38.569322] Testing event xfs_btree_corrupt: OK
[   38.585871] Testing event xfs_trans_read_buf_shut: OK
[   38.601581] Testing event xfs_trans_read_buf_io: OK
[   38.617396] Testing event xfs_buf_wait_buftarg: OK
[   38.633388] Testing event xfs_buf_error_relse: OK
[   38.649531] Testing event xfs_buf_item_iodone_async: OK
[   38.665398] Testing event xfs_buf_item_iodone: OK
[   38.681403] Testing event xfs_buf_item_relse: OK
[   38.697485] Testing event xfs_bdstrat_shut: OK
[   38.713535] Testing event xfs_buf_get_uncached: OK
[   38.729715] Testing event xfs_buf_delwri_split: OK
[   38.745410] Testing event xfs_buf_delwri_queued: OK
[   38.761332] Testing event xfs_buf_delwri_queue: OK
[   38.777310] Testing event xfs_buf_iowait_done: OK
[   38.793586] Testing event xfs_buf_iowait: OK
[   38.809460] Testing event xfs_buf_unlock: OK
[   38.825578] Testing event xfs_buf_trylock: OK
[   38.841336] Testing event xfs_buf_lock_done: OK
[   38.857308] Testing event xfs_buf_lock: OK
[   38.873426] Testing event xfs_buf_bawrite: OK
[   38.889395] Testing event xfs_buf_submit_wait: OK
[   38.905429] Testing event xfs_buf_submit: OK
[   38.922189] Testing event xfs_buf_iodone: OK
[   38.937634] Testing event xfs_buf_rele: OK
[   38.957411] Testing event xfs_buf_hold: OK
[   38.973827] Testing event xfs_buf_free: OK
[   38.989539] Testing event xfs_buf_init: OK
[   39.005592] Testing event xfs_extlist: OK
[   39.021561] Testing event xfs_bmap_post_update: OK
[   39.043997] Testing event xfs_bmap_pre_update: OK
[   39.063413] Testing event xfs_iext_remove: OK
[   39.081682] Testing event xfs_iext_insert: OK
[   39.097785] Testing event xfs_attr_list_node_descend: OK
[   39.117399] Testing event xfs_ialloc_read_agi: OK
[   39.133382] Testing event xfs_read_agi: OK
[   39.149438] Testing event xfs_alloc_read_agf: OK
[   39.165301] Testing event xfs_read_agf: OK
[   39.181648] Testing event xfs_perag_clear_eofblocks: OK
[   39.197885] Testing event xfs_perag_set_eofblocks: OK
[   39.213445] Testing event xfs_perag_clear_reclaim: OK
[   39.229775] Testing event xfs_perag_set_reclaim: OK
[   39.245644] Testing event xfs_perag_put: OK
[   39.261329] Testing event xfs_perag_get_tag: OK
[   39.277750] Testing event xfs_perag_get: OK
[   39.293450] Testing event xfs_attr_node_list: OK
[   39.310338] Testing event xfs_attr_leaf_list: OK
[   39.325673] Testing event xfs_attr_list_notfound: OK
[   39.341283] Testing event xfs_attr_list_wrong_blk: OK
[   39.357481] Testing event xfs_attr_list_add: OK
[   39.373420] Testing event xfs_attr_list_full: OK
[   39.389414] Testing event xfs_attr_list_leaf_end: OK
[   39.405569] Testing event xfs_attr_list_leaf: OK
[   39.421291] Testing event xfs_attr_list_sf_all: OK
[   39.437936] Testing event xfs_attr_list_sf: OK
[   39.453876] Testing event btrfs_qgroup_record_ref: OK
[   39.469616] Testing event btrfs_qgroup_account: OK
[   39.485701] Testing event btrfs_workqueue_destroy: OK
[   39.501563] Testing event btrfs_workqueue_alloc: OK
[   39.517659] Testing event btrfs_ordered_sched: OK
[   39.533382] Testing event btrfs_all_work_done: OK
[   39.549393] Testing event btrfs_work_sched: OK
[   39.565233] Testing event btrfs_work_queued: OK
[   39.582009] Testing event free_extent_state: OK
[   39.597714] Testing event alloc_extent_state: OK
[   39.613697] Testing event btrfs_setup_cluster: OK
[   39.629821] Testing event btrfs_failed_cluster_setup: OK
[   39.645692] Testing event btrfs_find_cluster: OK
[   39.661700] Testing event btrfs_reserve_extent_cluster: OK
[   39.677806] Testing event btrfs_reserve_extent: OK
[   39.694281] Testing event find_free_extent: OK
[   39.710042] Testing event btrfs_reserved_extent_free: OK
[   39.725920] Testing event btrfs_reserved_extent_alloc: OK
[   39.742010] Testing event btrfs_space_reservation: OK
[   39.763699] Testing event btrfs_cow_block: OK
[   39.781637] Testing event btrfs_chunk_free: OK
[   39.798062] Testing event btrfs_chunk_alloc: OK
[   39.817955] Testing event run_delayed_ref_head: OK
[   39.833944] Testing event add_delayed_ref_head: OK
[   39.849421] Testing event run_delayed_data_ref: OK
[   39.865359] Testing event add_delayed_data_ref: OK
[   39.881443] Testing event run_delayed_tree_ref: OK
[   39.897380] Testing event add_delayed_tree_ref: OK
[   39.913434] Testing event btrfs_sync_fs: OK
[   39.929969] Testing event btrfs_sync_file: OK
[   39.945644] Testing event btrfs_writepage_end_io_hook: OK
[   39.961938] Testing event __extent_writepage: OK
[   39.977712] Testing event btrfs_ordered_extent_put: OK
[   39.993364] Testing event btrfs_ordered_extent_start: OK
[   40.010136] Testing event btrfs_ordered_extent_remove: OK
[   40.025831] Testing event btrfs_ordered_extent_add: OK
[   40.042032] Testing event btrfs_get_extent: OK
[   40.057453] Testing event btrfs_inode_evict: OK
[   40.073435] Testing event btrfs_inode_request: OK
[   40.089420] Testing event btrfs_inode_new: OK
[   40.105389] Testing event btrfs_transaction_commit: OK
[   40.121616] Testing event gfs2_rs: OK
[   40.137563] Testing event gfs2_block_alloc: OK
[   40.153703] Testing event gfs2_bmap: OK
[   40.169511] Testing event gfs2_ail_flush: OK
[   40.185395] Testing event gfs2_log_blocks: OK
[   40.201802] Testing event gfs2_log_flush: OK
[   40.217933] Testing event gfs2_pin: OK
[   40.233897] Testing event gfs2_glock_lock_time: OK
[   40.249737] Testing event gfs2_glock_queue: OK
[   40.266435] Testing event gfs2_promote: OK
[   40.281834] Testing event gfs2_demote_rq: OK
[   40.297783] Testing event gfs2_glock_put: OK
[   40.313769] Testing event gfs2_glock_state_change: OK
[   40.329775] Testing event block_rq_remap: OK
[   40.345702] Testing event block_bio_remap: OK
[   40.362171] Testing event block_split: OK
[   40.377681] Testing event block_unplug: OK
[   40.393869] Testing event block_plug: OK
[   40.409981] Testing event block_sleeprq: OK
[   40.425945] Testing event block_getrq: OK
[   40.441789] Testing event block_bio_queue: OK
[   40.457824] Testing event block_bio_frontmerge: OK
[   40.473775] Testing event block_bio_backmerge: OK
[   40.489837] Testing event block_bio_complete: OK
[   40.505672] Testing event block_bio_bounce: OK
[   40.521637] Testing event block_rq_issue: OK
[   40.537728] Testing event block_rq_insert: OK
[   40.553763] Testing event block_rq_complete: OK
[   40.569789] Testing event block_rq_requeue: OK
[   40.585853] Testing event block_rq_abort: OK
[   40.601654] Testing event block_dirty_buffer: OK
[   40.617757] Testing event block_touch_buffer: OK
[   40.633804] Testing event gpio_value: OK
[   40.649929] Testing event gpio_direction: OK
[   40.665936] Testing event regulator_set_voltage_complete: OK
[   40.681710] Testing event regulator_set_voltage: OK
[   40.697707] Testing event regulator_disable_complete: OK
[   40.713771] Testing event regulator_disable: OK
[   40.729858] Testing event regulator_enable_complete: OK
[   40.745710] Testing event regulator_enable_delay: OK
[   40.761655] Testing event regulator_enable: OK
[   40.781788] Testing event urandom_read: OK
[   40.797641] Testing event random_read: OK
[   40.813719] Testing event extract_entropy_user: OK
[   40.829705] Testing event extract_entropy: OK
[   40.845625] Testing event get_random_bytes_arch: OK
[   40.861295] Testing event get_random_bytes: OK
[   40.877227] Testing event xfer_secondary_pool: OK
[   40.893779] Testing event add_disk_randomness: OK
[   40.909788] Testing event add_input_randomness: OK
[   40.929996] Testing event debit_entropy: OK
[   40.945864] Testing event push_to_pool: OK
[   40.961828] Testing event credit_entropy_bits: OK
[   40.977721] Testing event mix_pool_bytes_nolock: OK
[   40.993835] Testing event mix_pool_bytes: OK
[   41.015476] Testing event add_device_randomness: OK
[   41.033911] Testing event drm_vblank_event_delivered: OK
[   41.054095] Testing event drm_vblank_event_queued: OK
[   41.070186] Testing event drm_vblank_event: OK
[   41.086179] Testing event radeon_semaphore_wait: OK
[   41.101744] Testing event radeon_semaphore_signale: OK
[   41.117916] Testing event radeon_fence_wait_end: OK
[   41.133767] Testing event radeon_fence_wait_begin: OK
[   41.149780] Testing event radeon_fence_emit: OK
[   41.165735] Testing event radeon_vm_flush: OK
[   41.181761] Testing event radeon_vm_set_page: OK
[   41.197774] Testing event radeon_vm_bo_update: OK
[   41.213822] Testing event radeon_vm_grab_id: OK
[   41.229877] Testing event radeon_cs: OK
[   41.249806] Testing event radeon_bo_create: OK
[   41.265975] Testing event regcache_drop_region: OK
[   41.281891] Testing event regmap_async_complete_done: OK
[   41.297776] Testing event regmap_async_complete_start: OK
[   41.313821] Testing event regmap_async_io_complete: OK
[   41.329951] Testing event regmap_async_write_start: OK
[   41.345954] Testing event regmap_cache_bypass: OK
[   41.361856] Testing event regmap_cache_only: OK
[   41.377862] Testing event regcache_sync: OK
[   41.394105] Testing event regmap_hw_write_done: OK
[   41.410051] Testing event regmap_hw_write_start: OK
[   41.429964] Testing event regmap_hw_read_done: OK
[   41.445924] Testing event regmap_hw_read_start: OK
[   41.465940] Testing event regmap_reg_read_cache: OK
[   41.481820] Testing event regmap_reg_read: OK
[   41.497818] Testing event regmap_reg_write: OK
[   41.513822] Testing event fence_wait_end: OK
[   41.530792] Testing event fence_wait_start: OK
[   41.547232] Testing event fence_signaled: OK
[   41.565906] Testing event fence_enable_signal: OK
[   41.581905] Testing event fence_destroy: OK
[   41.597767] Testing event fence_init: OK
[   41.613758] Testing event fence_emit: OK
[   41.629760] Testing event fence_annotate_wait_on: OK
[   41.645709] Testing event scsi_eh_wakeup: OK
[   41.661813] Testing event scsi_dispatch_cmd_timeout: OK
[   41.677886] Testing event scsi_dispatch_cmd_done: OK
[   41.693864] Testing event scsi_dispatch_cmd_error: OK
[   41.709781] Testing event scsi_dispatch_cmd_start: OK
[   41.725830] Testing event target_cmd_complete: OK
[   41.742365] Testing event target_sequencer_start: OK
[   41.757865] Testing event smbus_result: OK
[   41.773717] Testing event smbus_reply: OK
[   41.789993] Testing event smbus_read: OK
[   41.805996] Testing event smbus_write: OK
[   41.821754] Testing event i2c_result: OK
[   41.837822] Testing event i2c_reply: OK
[   41.853828] Testing event i2c_read: OK
[   41.869996] Testing event i2c_write: OK
[   41.885858] Testing event v4l2_qbuf: OK
[   41.901751] Testing event v4l2_dqbuf: OK
[   41.917701] Testing event thermal_zone_trip: OK
[   41.934334] Testing event cdev_update: OK
[   41.950648] Testing event thermal_temperature: OK
[   41.965750] Testing event binder_return: OK
[   41.987157] Testing event binder_command: OK
[   42.005710] Testing event binder_update_page_range: OK
[   42.021716] Testing event binder_transaction_failed_buffer_release: OK
[   42.037538] Testing event binder_transaction_buffer_release: OK
[   42.054159] Testing event binder_transaction_alloc_buf: OK
[   42.069809] Testing event binder_transaction_fd: OK
[   42.085756] Testing event binder_transaction_ref_to_ref: OK
[   42.102527] Testing event binder_transaction_ref_to_node: OK
[   42.117451] Testing event binder_transaction_node_to_ref: OK
[   42.134102] Testing event binder_transaction_received: OK
[   42.153790] Testing event binder_transaction: OK
[   42.173783] Testing event binder_wait_for_work: OK
[   42.190607] Testing event binder_read_done: OK
[   42.205843] Testing event binder_write_done: OK
[   42.221341] Testing event binder_ioctl_done: OK
[   42.237193] Testing event binder_unlock: OK
[   42.255033] Testing event binder_locked: OK
[   42.274622] Testing event binder_lock: OK
[   42.289853] Testing event binder_ioctl: OK
[   42.306248] Testing event udp_fail_queue_rcv_skb: OK
[   42.322256] Testing event sock_exceed_buf_limit: OK
[   42.337966] Testing event sock_rcvqueue_full: OK
[   42.354008] Testing event napi_poll: OK
[   42.369772] Testing event netif_rx_ni_entry: OK
[   42.386516] Testing event netif_rx_entry: OK
[   42.401288] Testing event netif_receive_skb_entry: OK
[   42.418649] Testing event napi_gro_receive_entry: OK
[   42.433653] Testing event napi_gro_frags_entry: OK
[   42.449444] Testing event netif_rx: OK
[   42.465810] Testing event netif_receive_skb: OK
[   42.481393] Testing event net_dev_queue: OK
[   42.498219] Testing event net_dev_xmit: OK
[   42.513900] Testing event net_dev_start_xmit: OK
[   42.529849] Testing event skb_copy_datagram_iovec: OK
[   42.545868] Testing event consume_skb: OK
[   42.561767] Testing event kfree_skb: OK
[   42.577899] Running tests on trace event systems:
[   42.579685] Testing event system skb: OK
[   42.599049] Testing event system net: OK
[   42.619070] Testing event system napi: OK
[   42.633887] Testing event system sock: OK
[   42.649779] Testing event system udp: OK
[   42.666269] Testing event system binder: OK
[   42.689350] Testing event system thermal: OK
[   42.706566] Testing event system v4l2: OK
[   42.722569] Testing event system i2c: OK
[   42.746451] Testing event system target: OK
[   42.763363] Testing event system scsi: OK
[   42.783517] Testing event system fence: OK
[   42.803304] Testing event system regmap: OK
[   42.826239] Testing event system radeon: OK
[   42.847169] Testing event system drm: OK
[   42.866075] Testing event system random: OK
[   42.883576] Testing event system regulator: OK
[   42.902514] Testing event system gpio: OK
[   42.922341] Testing event system block: OK
[   42.944762] Testing event system gfs2: OK
[   42.968585] Testing event system btrfs: OK
[   42.995876] Testing event system xfs: OK
[   43.077215] Testing event system jbd2: OK
[   43.096492] Testing event system jbd: OK
[   43.115518] Testing event system ext4: OK
[   43.151111] Testing event system ext3: OK
[   43.173457] Testing event system filelock: OK
[   43.190486] Testing event system writeback: OK
[   43.211722] Testing event system kmem: OK
[   43.230313] Testing event system vmscan: OK
[   43.247545] Testing event system pagemap: OK
[   43.265841] Testing event system oom: OK
[   43.281788] Testing event system filemap: OK
[   43.297764] Testing event system power: OK
[   43.321934] Testing event system test: OK
[   43.337853] Testing event system timer: OK
[   43.360058] Testing event system rcu: OK
[   43.380143] Testing event system printk: OK
[   43.398835] Testing event system lock: OK
[   43.418908] Testing event system sched:=20
[   43.436154] test-events (1031) used greatest stack depth: 6712 bytes left
[   43.441347] OK
[   43.444090] Testing event system workqueue: OK
[   43.462841] Testing event system signal: OK
[   43.482160] Testing event system irq: OK
[   43.498014] Testing event system task: OK
[   43.514028] Testing event system exceptions: OK
[   43.530448] Testing event system tlb: OK
[   43.546923] Testing event system raw_syscalls: OK
[   43.566277] Testing event system nmi: OK
[   43.581993] Testing event system irq_vectors: OK
[   43.603099] Running tests on all trace events:
[   43.604758] Testing all events: OK
[   44.006129] Running tests again, along with the function tracer
[   44.010451] Running tests on trace events:
[   44.014327] Testing event thermal_apic_exit:=20
[   44.028678] test-events (1042) used greatest stack depth: 6680 bytes left
[   44.039967] OK
[   44.044796] Testing event thermal_apic_entry:=20
[   44.060706] test-events (1043) used greatest stack depth: 6640 bytes left
[   44.071902] OK
[   44.075512] Testing event threshold_apic_exit: OK
[   44.099112] Testing event threshold_apic_entry: OK
[   44.123325] Testing event call_function_single_exit: OK
[   44.146529] Testing event call_function_single_entry: OK
[   44.174872] Testing event call_function_exit: OK
[   44.203521] Testing event call_function_entry: OK
[   44.228695] Testing event irq_work_exit: OK
[   44.250316] Testing event irq_work_entry: OK
[   44.275191] Testing event x86_platform_ipi_exit: OK
[   44.299798] Testing event x86_platform_ipi_entry: OK
[   44.329080] Testing event error_apic_exit: OK
[   44.356582] Testing event error_apic_entry: OK
[   44.378650] Testing event spurious_apic_exit: OK
[   44.404742] Testing event spurious_apic_entry: OK
[   44.427199] Testing event reschedule_exit: OK
[   44.451108] Testing event reschedule_entry: OK
[   44.474540] Testing event local_timer_exit: OK
[   44.501192] Testing event local_timer_entry: OK
[   44.531426] Testing event nmi_handler: OK
[   44.555552] Testing event sys_exit: OK
[   44.578570] Testing event sys_enter: OK
[   44.606298] Testing event tlb_flush: OK
[   44.635529] Testing event page_fault_kernel: OK
[   44.659370] Testing event page_fault_user: OK
[   44.683357] Testing event task_rename: OK
[   44.707951] Testing event task_newtask: OK
[   44.732402] Testing event softirq_raise: OK
[   44.759468] Testing event softirq_exit: OK
[   44.782243] Testing event softirq_entry: OK
[   44.805282] Testing event irq_handler_exit: OK
[   44.828927] Testing event irq_handler_entry: OK
[   44.854563] Testing event signal_deliver: OK
[   44.878602] Testing event signal_generate: OK
[   44.904892] Testing event workqueue_execute_end: OK
[   44.927939] Testing event workqueue_execute_start: OK
[   44.950673] Testing event workqueue_activate_work: OK
[   44.980952] Testing event workqueue_queue_work: OK
[   45.009432] Testing event sched_wake_idle_without_ipi: OK
[   45.036231] Testing event sched_swap_numa: OK
[   45.059456] Testing event sched_stick_numa: OK
[   45.082970] Testing event sched_move_numa: OK
[   45.106859] Testing event sched_pi_setprio: OK
[   45.132467] Testing event sched_stat_runtime: OK
[   45.160936] Testing event sched_stat_blocked: OK
[   45.183686] Testing event sched_stat_iowait: OK
[   45.208874] Testing event sched_stat_sleep: OK
[   45.231929] Testing event sched_stat_wait: OK
[   45.255820] Testing event sched_process_exec: OK
[   45.285050] Testing event sched_process_fork: OK
[   45.306546] Testing event sched_process_wait: OK
[   45.329582] Testing event sched_wait_task: OK
[   45.350471] Testing event sched_process_exit: OK
[   45.375529] Testing event sched_process_free: OK
[   45.398308] Testing event sched_migrate_task: OK
[   45.423795] Testing event sched_switch: OK
[   45.445776] Testing event sched_wakeup_new: OK
[   45.469493] Testing event sched_wakeup: OK
[   45.491282] Testing event sched_kthread_stop_ret: OK
[   45.515386] Testing event sched_kthread_stop: OK
[   45.538038] Testing event lock_acquired: OK
[   45.562096] Testing event lock_contended: OK
[   45.590068] Testing event lock_release: OK
[   45.614689] Testing event lock_acquire: OK
[   45.639403] Testing event console: OK
[   45.663013] Testing event rcu_utilization: OK
[   45.692530] Testing event itimer_expire: OK
[   45.722719] Testing event itimer_state:=20
[   45.723709] test-events (1109) used greatest stack depth: 6636 bytes left
[   45.759424] OK
[   45.765544] Testing event hrtimer_cancel: OK
[   45.791954] Testing event hrtimer_expire_exit: OK
[   45.815621] Testing event hrtimer_expire_entry: OK
[   45.839289] Testing event hrtimer_start: OK
[   45.863212] Testing event hrtimer_init: OK
[   45.890652] Testing event timer_cancel: OK
[   45.915671] Testing event timer_expire_exit: OK
[   45.937674] Testing event timer_expire_entry: OK
[   45.958466] Testing event timer_start: OK
[   45.986696] Testing event timer_init: OK
[   46.010497] Testing event ftrace_test_filter: OK
[   46.034761] Testing event dev_pm_qos_remove_request: OK
[   46.059516] Testing event dev_pm_qos_update_request: OK
[   46.083284] Testing event dev_pm_qos_add_request: OK
[   46.104703] Testing event pm_qos_update_flags: OK
[   46.124457] Testing event pm_qos_update_target: OK
[   46.146407] Testing event pm_qos_update_request_timeout: OK
[   46.170391] Testing event pm_qos_remove_request: OK
[   46.194614] Testing event pm_qos_update_request: OK
[   46.220562] Testing event pm_qos_add_request: OK
[   46.246473] Testing event power_domain_target: OK
[   46.273741] Testing event clock_set_rate: OK
[   46.305829] Testing event clock_disable: OK
[   46.330892] Testing event clock_enable: OK
[   46.358148] Testing event wakeup_source_deactivate: OK
[   46.381574] Testing event wakeup_source_activate: OK
[   46.402127] Testing event suspend_resume: OK
[   46.434513] Testing event device_pm_callback_end: OK
[   46.458979] Testing event device_pm_callback_start: OK
[   46.483328] Testing event cpu_frequency: OK
[   46.506033] Testing event pstate_sample: OK
[   46.537636] Testing event cpu_idle: OK
[   46.565846] Testing event mm_filemap_add_to_page_cache: OK
[   46.590583] Testing event mm_filemap_delete_from_page_cache: OK
[   46.613783] Testing event oom_score_adj_update: OK
[   46.635465] Testing event mm_lru_activate: OK
[   46.658682] Testing event mm_lru_insertion: OK
[   46.684177] Testing event mm_vmscan_lru_shrink_inactive: OK
[   46.706881] Testing event mm_vmscan_writepage: OK
[   46.731465] Testing event mm_vmscan_memcg_isolate: OK
[   46.754810] Testing event mm_vmscan_lru_isolate: OK
[   46.784490] Testing event mm_shrink_slab_end: OK
[   46.807172] Testing event mm_shrink_slab_start: OK
[   46.833676] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   46.854744] Testing event mm_vmscan_memcg_reclaim_end: OK
[   46.878533] Testing event mm_vmscan_direct_reclaim_end: OK
[   46.902849] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   46.926545] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   46.951069] Testing event mm_vmscan_direct_reclaim_begin: OK
[   46.975758] Testing event mm_vmscan_wakeup_kswapd: OK
[   46.998965] Testing event mm_vmscan_kswapd_wake: OK
[   47.022508] Testing event mm_vmscan_kswapd_sleep: OK
[   47.046277] Testing event mm_page_alloc_extfrag: OK
[   47.072043] Testing event mm_page_pcpu_drain: OK
[   47.094960] Testing event mm_page_alloc_zone_locked: OK
[   47.117710] Testing event mm_page_alloc: OK
[   47.138921] Testing event mm_page_free_batched: OK
[   47.162527] Testing event mm_page_free: OK
[   47.188429] Testing event kmem_cache_free: OK
[   47.211308] Testing event kfree: OK
[   47.234938] Testing event kmem_cache_alloc_node: OK
[   47.259579] Testing event kmalloc_node: OK
[   47.287599] Testing event kmem_cache_alloc: OK
[   47.318269] Testing event kmalloc: OK
[   47.343331] Testing event writeback_single_inode: OK
[   47.367797] Testing event writeback_single_inode_start: OK
[   47.391426] Testing event writeback_wait_iff_congested: OK
[   47.415928] Testing event writeback_congestion_wait: OK
[   47.439172] Testing event writeback_sb_inodes_requeue: OK
[   47.463035] Testing event balance_dirty_pages: OK
[   47.491640] Testing event bdi_dirty_ratelimit: OK
[   47.514435] Testing event global_dirty_state: OK
[   47.540263] Testing event writeback_queue_io: OK
[   47.563420] Testing event wbc_writepage: OK
[   47.588188] Testing event writeback_bdi_unregister: OK
[   47.611375] Testing event writeback_bdi_register: OK
[   47.635112] Testing event writeback_wake_background: OK
[   47.660837] Testing event writeback_nowork: OK
[   47.684815] Testing event writeback_pages_written: OK
[   47.706905] Testing event writeback_wait: OK
[   47.731213] Testing event writeback_written: OK
[   47.756275] Testing event writeback_start: OK
[   47.779677] Testing event writeback_exec: OK
[   47.804324] Testing event writeback_queue: OK
[   47.827672] Testing event writeback_write_inode: OK
[   47.851359] Testing event writeback_write_inode_start: OK
[   47.875541] Testing event writeback_dirty_inode: OK
[   47.899948] Testing event writeback_dirty_inode_start: OK
[   47.924232] Testing event writeback_dirty_page: OK
[   47.947106] Testing event time_out_leases: OK
[   47.970787] Testing event generic_delete_lease: OK
[   47.994420] Testing event generic_add_lease: OK
[   48.018272] Testing event break_lease_unblock: OK
[   48.043313] Testing event break_lease_block: OK
[   48.066824] Testing event break_lease_noblock: OK
[   48.090187] Testing event ext3_load_inode: OK
[   48.114972] Testing event ext3_get_blocks_exit: OK
[   48.140812] Testing event ext3_get_blocks_enter: OK
[   48.167980] Testing event ext3_truncate_exit: OK
[   48.194898] Testing event ext3_truncate_enter: OK
[   48.220281] Testing event ext3_unlink_exit: OK
[   48.243729] Testing event ext3_unlink_enter: OK
[   48.267460] Testing event ext3_direct_IO_exit: OK
[   48.291705] Testing event ext3_direct_IO_enter: OK
[   48.314845] Testing event ext3_read_block_bitmap: OK
[   48.338386] Testing event ext3_forget: OK
[   48.363532] Testing event ext3_reserved: OK
[   48.391252] Testing event ext3_alloc_new_reservation: OK
[   48.413935] Testing event ext3_discard_reservation: OK
[   48.438604] Testing event ext3_rsv_window_add: OK
[   48.466895] Testing event ext3_sync_fs: OK
[   48.490584] Testing event ext3_sync_file_exit: OK
[   48.515070] Testing event ext3_sync_file_enter: OK
[   48.539560] Testing event ext3_free_blocks: OK
[   48.569214] Testing event ext3_allocate_blocks: OK
[   48.589753] Testing event ext3_request_blocks: OK
[   48.611809] Testing event ext3_discard_blocks: OK
[   48.639597] Testing event ext3_invalidatepage: OK
[   48.662664] Testing event ext3_releasepage: OK
[   48.687953] Testing event ext3_readpage: OK
[   48.711258] Testing event ext3_journalled_writepage: OK
[   48.736972] Testing event ext3_writeback_writepage: OK
[   48.761212] Testing event ext3_ordered_writepage: OK
[   48.787187] Testing event ext3_journalled_write_end: OK
[   48.810434] Testing event ext3_writeback_write_end: OK
[   48.839301] Testing event ext3_ordered_write_end: OK
[   48.862209] Testing event ext3_write_begin: OK
[   48.892264] Testing event ext3_mark_inode_dirty: OK
[   48.914651] Testing event ext3_drop_inode: OK
[   48.938512] Testing event ext3_evict_inode: OK
[   48.962285] Testing event ext3_allocate_inode: OK
[   48.986301] Testing event ext3_request_inode: OK
[   49.010747] Testing event ext3_free_inode: OK
[   49.035074] Testing event ext4_es_shrink: OK
[   49.060651] Testing event ext4_collapse_range: OK
[   49.084408] Testing event ext4_es_shrink_scan_exit: OK
[   49.113229] Testing event ext4_es_shrink_scan_enter: OK
[   49.134413] Testing event ext4_es_shrink_count: OK
[   49.158305] Testing event ext4_es_lookup_extent_exit: OK
[   49.184214] Testing event ext4_es_lookup_extent_enter: OK
[   49.207469] Testing event ext4_es_find_delayed_extent_range_exit: OK
[   49.230419] Testing event ext4_es_find_delayed_extent_range_enter: OK
[   49.254636] Testing event ext4_es_remove_extent: OK
[   49.286206] Testing event ext4_es_cache_extent: OK
[   49.314409] Testing event ext4_es_insert_extent: OK
[   49.340404] Testing event ext4_ext_remove_space_done: OK
[   49.362684] Testing event ext4_ext_remove_space: OK
[   49.385978] Testing event ext4_ext_rm_idx: OK
[   49.410945] Testing event ext4_ext_rm_leaf: OK
[   49.439621] Testing event ext4_remove_blocks: OK
[   49.465072] Testing event ext4_ext_show_extent: OK
[   49.485969] Testing event ext4_get_reserved_cluster_alloc: OK
[   49.509705] Testing event ext4_find_delalloc_range: OK
[   49.534485] Testing event ext4_ext_in_cache: OK
[   49.559880] Testing event ext4_ext_put_in_cache: OK
[   49.582767] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   49.611463] Testing event ext4_ext_handle_unwritten_extents: OK
[   49.634528] Testing event ext4_trim_all_free: OK
[   49.659933] Testing event ext4_trim_extent: OK
[   49.683928] Testing event ext4_journal_start_reserved: OK
[   49.707288] Testing event ext4_journal_start: OK
[   49.730897] Testing event ext4_load_inode: OK
[   49.758641] Testing event ext4_ext_load_extent: OK
[   49.786568] Testing event ext4_ind_map_blocks_exit: OK
[   49.811018] Testing event ext4_ext_map_blocks_exit: OK
[   49.835006] Testing event ext4_ind_map_blocks_enter: OK
[   49.859533] Testing event ext4_ext_map_blocks_enter: OK
[   49.880946] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   49.907678] Testing event ext4_ext_convert_to_initialized_enter: OK
[   49.931261] Testing event ext4_truncate_exit: OK
[   49.954417] Testing event ext4_truncate_enter: OK
[   49.983648] Testing event ext4_unlink_exit: OK
[   50.007933] Testing event ext4_unlink_enter: OK
[   50.031004] Testing event ext4_fallocate_exit: OK
[   50.054478] Testing event ext4_zero_range: OK
[   50.078687] Testing event ext4_punch_hole: OK
[   50.103112] Testing event ext4_fallocate_enter: OK
[   50.126334] Testing event ext4_direct_IO_exit: OK
[   50.150522] Testing event ext4_direct_IO_enter: OK
[   50.178485] Testing event ext4_load_inode_bitmap: OK
[   50.203988] Testing event ext4_read_block_bitmap_load: OK
[   50.228728] Testing event ext4_mb_buddy_bitmap_load: OK
[   50.251689] Testing event ext4_mb_bitmap_load: OK
[   50.275092] Testing event ext4_da_release_space: OK
[   50.298889] Testing event ext4_da_reserve_space: OK
[   50.322843] Testing event ext4_da_update_reserve_space: OK
[   50.346858] Testing event ext4_forget: OK
[   50.371060] Testing event ext4_mballoc_free: OK
[   50.394794] Testing event ext4_mballoc_discard: OK
[   50.422912] Testing event ext4_mballoc_prealloc: OK
[   50.447607] Testing event ext4_mballoc_alloc: OK
[   50.473019] Testing event ext4_alloc_da_blocks: OK
[   50.497560] Testing event ext4_sync_fs: OK
[   50.523368] Testing event ext4_sync_file_exit: OK
[   50.548590] Testing event ext4_sync_file_enter: OK
[   50.571225] Testing event ext4_free_blocks: OK
[   50.595289] Testing event ext4_allocate_blocks: OK
[   50.624362] Testing event ext4_request_blocks: OK
[   50.648894] Testing event ext4_mb_discard_preallocations: OK
[   50.670697] Testing event ext4_discard_preallocations: OK
[   50.695016] Testing event ext4_mb_release_group_pa: OK
[   50.719202] Testing event ext4_mb_release_inode_pa: OK
[   50.743117] Testing event ext4_mb_new_group_pa: OK
[   50.770760] Testing event ext4_mb_new_inode_pa: OK
[   50.797404] Testing event ext4_discard_blocks: OK
[   50.819162] Testing event ext4_journalled_invalidatepage: OK
[   50.843088] Testing event ext4_invalidatepage: OK
[   50.869847] Testing event ext4_releasepage: OK
[   50.895797] Testing event ext4_readpage: OK
[   50.918695] Testing event ext4_writepage: OK
[   50.946426] Testing event ext4_writepages_result: OK
[   50.971412] Testing event ext4_da_write_pages_extent: OK
[   50.995445] Testing event ext4_da_write_pages: OK
[   51.020814] Testing event ext4_writepages: OK
[   51.043851] Testing event ext4_da_write_end: OK
[   51.066626] Testing event ext4_journalled_write_end: OK
[   51.091271] Testing event ext4_write_end: OK
[   51.114750] Testing event ext4_da_write_begin: OK
[   51.141305] Testing event ext4_write_begin: OK
[   51.166652] Testing event ext4_begin_ordered_truncate: OK
[   51.189926] Testing event ext4_mark_inode_dirty: OK
[   51.217178] Testing event ext4_drop_inode: OK
[   51.245294] Testing event ext4_evict_inode: OK
[   51.269052] Testing event ext4_allocate_inode: OK
[   51.291548] Testing event ext4_request_inode: OK
[   51.317042] Testing event ext4_free_inode: OK
[   51.339398] Testing event journal_write_superblock: OK
[   51.368280] Testing event jbd_cleanup_journal_tail: OK
[   51.390976] Testing event jbd_do_submit_data: OK
[   51.418736] Testing event jbd_end_commit: OK
[   51.444643] Testing event jbd_drop_transaction: OK
[   51.469333] Testing event jbd_commit_logging: OK
[   51.491123] Testing event jbd_commit_flushing: OK
[   51.516621] Testing event jbd_commit_locking: OK
[   51.541072] Testing event jbd_start_commit: OK
[   51.563676] Testing event jbd_checkpoint: OK
[   51.586355] Testing event jbd2_lock_buffer_stall: OK
[   51.611836] Testing event jbd2_write_superblock: OK
[   51.639734] Testing event jbd2_update_log_tail: OK
[   51.663290] Testing event jbd2_checkpoint_stats: OK
[   51.687421] Testing event jbd2_run_stats: OK
[   51.710842] Testing event jbd2_handle_stats: OK
[   51.740241] Testing event jbd2_handle_extend: OK
[   51.767701] Testing event jbd2_handle_start: OK
[   51.792390] Testing event jbd2_submit_inode_data: OK
[   51.815365] Testing event jbd2_end_commit: OK
[   51.838997] Testing event jbd2_drop_transaction: OK
[   51.862574] Testing event jbd2_commit_logging: OK
[   51.886343] Testing event jbd2_commit_flushing: OK
[   51.910502] Testing event jbd2_commit_locking: OK
[   51.934549] Testing event jbd2_start_commit: OK
[   51.959130] Testing event jbd2_checkpoint: OK
[   51.981424] Testing event xfs_discard_busy: OK
[   52.000233] Testing event xfs_discard_exclude: OK
[   52.022483] Testing event xfs_discard_toosmall: OK
[   52.048124] Testing event xfs_discard_extent: OK
[   52.070022] Testing event xfs_log_recover_inode_skip: OK
[   52.095297] Testing event xfs_log_recover_inode_cancel: OK
[   52.118629] Testing event xfs_log_recover_inode_recover: OK
[   52.142988] Testing event xfs_log_recover_buf_dquot_buf: OK
[   52.166563] Testing event xfs_log_recover_buf_reg_buf: OK
[   52.192814] Testing event xfs_log_recover_buf_inode_buf: OK
[   52.217381] Testing event xfs_log_recover_buf_recover: OK
[   52.243147] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   52.268595] Testing event xfs_log_recover_buf_cancel_add: OK
[   52.297265] Testing event xfs_log_recover_buf_cancel: OK
[   52.324339] Testing event xfs_log_recover_buf_not_cancel: OK
[   52.351280] Testing event xfs_log_recover_item_recover: OK
[   52.382426] Testing event xfs_log_recover_item_reorder_tail: OK
[   52.409175] Testing event xfs_log_recover_item_reorder_head: OK
[   52.435665] Testing event xfs_log_recover_item_add_cont: OK
[   52.459789] Testing event xfs_log_recover_item_add: OK
[   52.484875] Testing event xfs_swap_extent_after: OK
[   52.509228] Testing event xfs_swap_extent_before: OK
[   52.534757] Testing event xfs_dir2_leafn_moveents: OK
[   52.559742] Testing event xfs_dir2_shrink_inode: OK
[   52.584861] Testing event xfs_dir2_grow_inode: OK
[   52.612981] Testing event xfs_dir2_leafn_remove: OK
[   52.633720] Testing event xfs_dir2_leafn_add: OK
[   52.657601] Testing event xfs_da_path_shift:=20
[   52.673264] test-events (1390) used greatest stack depth: 6588 bytes left
[   52.686949] OK
[   52.691396] Testing event xfs_da_fixhashpath: OK
[   52.714493] Testing event xfs_da_shrink_inode: OK
[   52.737243] Testing event xfs_da_grow_inode: OK
[   52.758300] Testing event xfs_da_swap_lastblock: OK
[   52.785857] Testing event xfs_da_node_toosmall: OK
[   52.810295] Testing event xfs_da_node_unbalance: OK
[   52.835419] Testing event xfs_da_node_rebalance: OK
[   52.859134] Testing event xfs_da_node_remove: OK
[   52.882367] Testing event xfs_da_node_split: OK
[   52.907344] Testing event xfs_da_node_create: OK
[   52.931338] Testing event xfs_da_node_add: OK
[   52.954681] Testing event xfs_da_root_join: OK
[   52.979132] Testing event xfs_da_root_split: OK
[   53.002251] Testing event xfs_da_unlink_forward: OK
[   53.026750] Testing event xfs_da_unlink_back: OK
[   53.050143] Testing event xfs_da_link_after: OK
[   53.081136] Testing event xfs_da_link_before: OK
[   53.102648] Testing event xfs_da_join: OK
[   53.126696] Testing event xfs_da_split: OK
[   53.150758] Testing event xfs_attr_rmtval_remove: OK
[   53.174609] Testing event xfs_attr_rmtval_set: OK
[   53.200511] Testing event xfs_attr_rmtval_get: OK
[   53.222529] Testing event xfs_attr_refillstate: OK
[   53.246525] Testing event xfs_attr_fillstate: OK
[   53.272866] Testing event xfs_attr_node_removename: OK
[   53.298477] Testing event xfs_attr_node_replace: OK
[   53.322733] Testing event xfs_attr_node_lookup: OK
[   53.347653] Testing event xfs_attr_node_get: OK
[   53.375157] Testing event xfs_attr_node_addname: OK
[   53.399482] Testing event xfs_attr_leaf_toosmall: OK
[   53.423247] Testing event xfs_attr_leaf_unbalance: OK
[   53.446133] Testing event xfs_attr_leaf_rebalance: OK
[   53.475525] Testing event xfs_attr_leaf_to_node: OK
[   53.503750] Testing event xfs_attr_leaf_to_sf: OK
[   53.530974] Testing event xfs_attr_leaf_flipflags: OK
[   53.556383] Testing event xfs_attr_leaf_setflag: OK
[   53.584365] Testing event xfs_attr_leaf_clearflag: OK
[   53.606895] Testing event xfs_attr_leaf_split_after: OK
[   53.632447] Testing event xfs_attr_leaf_split_before: OK
[   53.655423] Testing event xfs_attr_leaf_split: OK
[   53.679003] Testing event xfs_attr_leaf_removename: OK
[   53.702283] Testing event xfs_attr_leaf_remove: OK
[   53.726888] Testing event xfs_attr_leaf_replace: OK
[   53.751558] Testing event xfs_attr_leaf_lookup: OK
[   53.774949] Testing event xfs_attr_leaf_get: OK
[   53.799424] Testing event xfs_attr_leaf_compact: OK
[   53.822273] Testing event xfs_attr_leaf_create: OK
[   53.846987] Testing event xfs_attr_leaf_addname: OK
[   53.870482] Testing event xfs_attr_leaf_add_work: OK
[   53.896175] Testing event xfs_attr_leaf_add_new: OK
[   53.919615] Testing event xfs_attr_leaf_add_old: OK
[   53.942283] Testing event xfs_attr_leaf_add: OK
[   53.967339] Testing event xfs_attr_sf_to_leaf: OK
[   53.991285] Testing event xfs_attr_sf_removename: OK
[   54.015670] Testing event xfs_attr_sf_remove: OK
[   54.039767] Testing event xfs_attr_sf_lookup: OK
[   54.064662] Testing event xfs_attr_sf_create: OK
[   54.085658] Testing event xfs_attr_sf_addname: OK
[   54.105925] Testing event xfs_attr_sf_add: OK
[   54.130597] Testing event xfs_dir2_node_to_leaf: OK
[   54.156279] Testing event xfs_dir2_node_removename: OK
[   54.185761] Testing event xfs_dir2_node_replace: OK
[   54.210334] Testing event xfs_dir2_node_lookup: OK
[   54.235194] Testing event xfs_dir2_node_addname: OK
[   54.258378] Testing event xfs_dir2_leaf_to_node: OK
[   54.282109] Testing event xfs_dir2_leaf_to_block: OK
[   54.306464] Testing event xfs_dir2_leaf_removename: OK
[   54.330673] Testing event xfs_dir2_leaf_replace: OK
[   54.354732] Testing event xfs_dir2_leaf_lookup: OK
[   54.378537] Testing event xfs_dir2_leaf_addname: OK
[   54.402278] Testing event xfs_dir2_block_to_leaf: OK
[   54.426165] Testing event xfs_dir2_block_to_sf: OK
[   54.450134] Testing event xfs_dir2_block_removename: OK
[   54.474339] Testing event xfs_dir2_block_replace: OK
[   54.498889] Testing event xfs_dir2_block_lookup: OK
[   54.522783] Testing event xfs_dir2_block_addname: OK
[   54.546979] Testing event xfs_dir2_sf_to_block: OK
[   54.571432] Testing event xfs_dir2_sf_toino8: OK
[   54.594972] Testing event xfs_dir2_sf_toino4: OK
[   54.616973] Testing event xfs_dir2_sf_removename: OK
[   54.637215] Testing event xfs_dir2_sf_replace: OK
[   54.658297] Testing event xfs_dir2_sf_lookup: OK
[   54.682513] Testing event xfs_dir2_sf_create: OK
[   54.706145] Testing event xfs_dir2_sf_addname: OK
[   54.729624] Testing event xfs_alloc_vextent_allfailed: OK
[   54.753671] Testing event xfs_alloc_vextent_loopfailed: OK
[   54.781273] Testing event xfs_alloc_vextent_noagbp: OK
[   54.802775] Testing event xfs_alloc_vextent_nofix: OK
[   54.830775] Testing event xfs_alloc_vextent_badargs: OK
[   54.855877] Testing event xfs_alloc_small_error: OK
[   54.877605] Testing event xfs_alloc_small_done: OK
[   54.897412] Testing event xfs_alloc_small_notenough: OK
[   54.920170] Testing event xfs_alloc_small_freelist: OK
[   54.945530] Testing event xfs_alloc_size_busy: OK
[   54.970929] Testing event xfs_alloc_size_error: OK
[   54.993068] Testing event xfs_alloc_size_done: OK
[   55.014493] Testing event xfs_alloc_size_nominleft: OK
[   55.038140] Testing event xfs_alloc_size_noentry: OK
[   55.060688] Testing event xfs_alloc_size_neither: OK
[   55.081544] Testing event xfs_alloc_near_busy: OK
[   55.101199] Testing event xfs_alloc_near_noentry: OK
[   55.122066] Testing event xfs_alloc_near_error: OK
[   55.146238] Testing event xfs_alloc_near_lesser: OK
[   55.174369] Testing event xfs_alloc_near_greater: OK
[   55.198925] Testing event xfs_alloc_near_first: OK
[   55.223713] Testing event xfs_alloc_near_nominleft: OK
[   55.250795] Testing event xfs_alloc_exact_error: OK
[   55.275750] Testing event xfs_alloc_exact_notfound: OK
[   55.300640] Testing event xfs_alloc_exact_done: OK
[   55.322139] Testing event xfs_free_extent: OK
[   55.346396] Testing event xfs_agf: OK
[   55.376564] Testing event xfs_trans_commit_lsn: OK
[   55.401977] Testing event xfs_extent_busy_trim: OK
[   55.427665] Testing event xfs_extent_busy_clear: OK
[   55.450275] Testing event xfs_extent_busy_reuse: OK
[   55.474689] Testing event xfs_extent_busy_force: OK
[   55.496273] Testing event xfs_extent_busy_enomem: OK
[   55.516567] Testing event xfs_extent_busy: OK
[   55.537009] Testing event xfs_bunmap: OK
[   55.556901] Testing event xfs_pagecache_inval: OK
[   55.580264] Testing event xfs_itruncate_extents_end: OK
[   55.600390] Testing event xfs_itruncate_extents_start: OK
[   55.620084] Testing event xfs_setfilesize: OK
[   55.640968] Testing event xfs_get_blocks_notfound: OK
[   55.666966] Testing event xfs_unwritten_convert: OK
[   55.690141] Testing event xfs_delalloc_enospc: OK
[   55.714677] Testing event xfs_get_blocks_alloc: OK
[   55.742839] Testing event xfs_get_blocks_found: OK
[   55.766899] Testing event xfs_map_blocks_alloc: OK
[   55.794721] Testing event xfs_map_blocks_found: OK
[   55.818692] Testing event xfs_invalidatepage: OK
[   55.840277] Testing event xfs_releasepage: OK
[   55.861057] Testing event xfs_writepage: OK
[   55.883061] Testing event xfs_file_splice_read: OK
[   55.910291] Testing event xfs_file_direct_write: OK
[   55.933782] Testing event xfs_file_buffered_write: OK
[   55.963581] Testing event xfs_file_read: OK
[   55.986057] Testing event xfs_log_assign_tail_lsn: OK
[   56.010047] Testing event xfs_ail_delete: OK
[   56.034136] Testing event xfs_ail_move: OK
[   56.058624] Testing event xfs_ail_insert: OK
[   56.082226] Testing event xfs_ail_flushing: OK
[   56.105870] Testing event xfs_ail_locked: OK
[   56.126264] Testing event xfs_ail_pinned: OK
[   56.150140] Testing event xfs_ail_push: OK
[   56.174898] Testing event xfs_log_force: OK
[   56.199102] Testing event xfs_log_ungrant_sub: OK
[   56.222562] Testing event xfs_log_ungrant_exit: OK
[   56.247882] Testing event xfs_log_ungrant_enter: OK
[   56.272923] Testing event xfs_log_regrant_reserve_sub: OK
[   56.294346] Testing event xfs_log_regrant_reserve_exit: OK
[   56.317274] Testing event xfs_log_regrant_reserve_enter: OK
[   56.339001] Testing event xfs_log_regrant_exit: OK
[   56.362768] Testing event xfs_log_regrant: OK
[   56.384176] Testing event xfs_log_reserve_exit: OK
[   56.403871] Testing event xfs_log_reserve: OK
[   56.425566] Testing event xfs_log_grant_wake_up: OK
[   56.445384] Testing event xfs_log_grant_wake: OK
[   56.466044] Testing event xfs_log_grant_sleep: OK
[   56.490529] Testing event xfs_log_umount_write: OK
[   56.513313] Testing event xfs_log_done_perm: OK
[   56.534575] Testing event xfs_log_done_nonperm: OK
[   56.558847] Testing event xfs_dqflush_done: OK
[   56.580069] Testing event xfs_dqflush_force: OK
[   56.599939] Testing event xfs_dqflush: OK
[   56.620186] Testing event xfs_dqrele: OK
[   56.642142] Testing event xfs_dqput_free: OK
[   56.666636] Testing event xfs_dqput_wait: OK
[   56.690354] Testing event xfs_dqput: OK
[   56.714283] Testing event xfs_dqget_dup: OK
[   56.738522] Testing event xfs_dqget_freeing: OK
[   56.761913] Testing event xfs_dqget_miss: OK
[   56.782433] Testing event xfs_dqget_hit: OK
[   56.806244] Testing event xfs_dqread_fail: OK
[   56.829551] Testing event xfs_dqread: OK
[   56.854065] Testing event xfs_dqtobp_read: OK
[   56.877605] Testing event xfs_dqalloc: OK
[   56.902056] Testing event xfs_dqattach_get: OK
[   56.926992] Testing event xfs_dqattach_found: OK
[   56.950095] Testing event xfs_dqreclaim_done: OK
[   56.973829] Testing event xfs_dqreclaim_busy: OK
[   56.995090] Testing event xfs_dqreclaim_dirty: OK
[   57.016338] Testing event xfs_dqreclaim_want: OK
[   57.037782] Testing event xfs_dqadjust: OK
[   57.057918] Testing event xfs_rename: OK
[   57.080598] Testing event xfs_symlink: OK
[   57.105956] Testing event xfs_create: OK
[   57.128864] Testing event xfs_lookup: OK
[   57.148981] Testing event xfs_link: OK
[   57.168936] Testing event xfs_remove: OK
[   57.188734] Testing event xfs_inode_unpin_nowait: OK
[   57.209239] Testing event xfs_inode_unpin: OK
[   57.228495] Testing event xfs_inode_pin: OK
[   57.254355] Testing event xfs_irele: OK
[   57.279573] Testing event xfs_ihold: OK
[   57.301438] Testing event xfs_iomap_prealloc_size: OK
[   57.321328] Testing event xfs_inode_free_eofblocks_invalid: OK
[   57.341646] Testing event xfs_inode_clear_eofblocks_tag: OK
[   57.366149] Testing event xfs_inode_set_eofblocks_tag: OK
[   57.390012] Testing event xfs_dquot_dqdetach: OK
[   57.409765] Testing event xfs_dquot_dqalloc: OK
[   57.429633] Testing event xfs_update_time: OK
[   57.447946] Testing event xfs_evict_inode: OK
[   57.471162] Testing event xfs_destroy_inode: OK
[   57.493975] Testing event xfs_file_fsync: OK
[   57.513163] Testing event xfs_dir_fsync: OK
[   57.535918] Testing event xfs_ioctl_setattr: OK
[   57.557353] Testing event xfs_file_compat_ioctl: OK
[   57.582395] Testing event xfs_file_ioctl: OK
[   57.605355] Testing event xfs_vm_bmap: OK
[   57.625193] Testing event xfs_get_acl: OK
[   57.645313] Testing event xfs_readdir: OK
[   57.665467] Testing event xfs_collapse_file_space: OK
[   57.686553] Testing event xfs_zero_file_space: OK
[   57.714539] Testing event xfs_free_file_space: OK
[   57.741386] Testing event xfs_alloc_file_space: OK
[   57.765825] Testing event xfs_inactive_symlink: OK
[   57.794548] Testing event xfs_readlink: OK
[   57.819280] Testing event xfs_setattr: OK
[   57.841555] Testing event xfs_getattr: OK
[   57.860916] Testing event xfs_iget_miss: OK
[   57.880665] Testing event xfs_iget_hit: OK
[   57.900611] Testing event xfs_iget_reclaim_fail: OK
[   57.922412] Testing event xfs_iget_reclaim: OK
[   57.947763] Testing event xfs_iget_skip: OK
[   57.970351] Testing event xfs_iunlock: OK
[   57.990681] Testing event xfs_ilock_demote: OK
[   58.014065] Testing event xfs_ilock_nowait: OK
[   58.042861] Testing event xfs_ilock: OK
[   58.065858] Testing event xfs_filestream_pick: OK
[   58.090123] Testing event xfs_filestream_scan: OK
[   58.117410] Testing event xfs_filestream_lookup: OK
[   58.143460] Testing event xfs_filestream_free: OK
[   58.165047] Testing event xfs_trans_buf_ordered: OK
[   58.186040] Testing event xfs_trans_binval: OK
[   58.210325] Testing event xfs_trans_bhold_release: OK
[   58.234453] Testing event xfs_trans_bhold: OK
[   58.257353] Testing event xfs_trans_bjoin: OK
[   58.280418] Testing event xfs_trans_brelse: OK
[   58.303087] Testing event xfs_trans_log_buf: OK
[   58.327120] Testing event xfs_trans_read_buf_recur: OK
[   58.349993] Testing event xfs_trans_read_buf: OK
[   58.378080] Testing event xfs_trans_getsb_recur: OK
[   58.402119] Testing event xfs_trans_getsb: OK
[   58.427769] Testing event xfs_trans_get_buf_recur: OK
[   58.451129] Testing event xfs_trans_get_buf: OK
[   58.474730] Testing event xfs_buf_item_push: OK
[   58.498168] Testing event xfs_buf_item_committed: OK
[   58.526893] Testing event xfs_buf_item_unlock_stale: OK
[   58.550154] Testing event xfs_buf_item_unlock: OK
[   58.574292] Testing event xfs_buf_item_unpin_stale: OK
[   58.598216] Testing event xfs_buf_item_unpin: OK
[   58.622352] Testing event xfs_buf_item_pin: OK
[   58.644696] Testing event xfs_buf_item_ordered: OK
[   58.665720] Testing event xfs_buf_item_format_stale: OK
[   58.687931] Testing event xfs_buf_item_format_ordered: OK
[   58.710262] Testing event xfs_buf_item_format: OK
[   58.730426] Testing event xfs_buf_item_size_stale: OK
[   58.758923] Testing event xfs_buf_item_size_ordered: OK
[   58.779868] Testing event xfs_buf_item_size: OK
[   58.799508] Testing event xfs_buf_ioerror: OK
[   58.820161] Testing event xfs_buf_read: OK
[   58.839435] Testing event xfs_buf_get: OK
[   58.859534] Testing event xfs_buf_find: OK
[   58.880439] Testing event xfs_inode_item_push: OK
[   58.899868] Testing event xfs_reset_dqcounts: OK
[   58.920128] Testing event xfs_da_btree_corrupt: OK
[   58.940682] Testing event xfs_btree_corrupt: OK
[   58.961801] Testing event xfs_trans_read_buf_shut: OK
[   58.981988] Testing event xfs_trans_read_buf_io: OK
[   59.006119] Testing event xfs_buf_wait_buftarg: OK
[   59.029299] Testing event xfs_buf_error_relse: OK
[   59.049880] Testing event xfs_buf_item_iodone_async: OK
[   59.074370] Testing event xfs_buf_item_iodone: OK
[   59.106636] Testing event xfs_buf_item_relse: OK
[   59.130164] Testing event xfs_bdstrat_shut: OK
[   59.154025] Testing event xfs_buf_get_uncached: OK
[   59.177834] Testing event xfs_buf_delwri_split: OK
[   59.202012] Testing event xfs_buf_delwri_queued: OK
[   59.230676] Testing event xfs_buf_delwri_queue: OK
[   59.254460] Testing event xfs_buf_iowait_done: OK
[   59.278136] Testing event xfs_buf_iowait: OK
[   59.301978] Testing event xfs_buf_unlock: OK
[   59.326962] Testing event xfs_buf_trylock: OK
[   59.352518] Testing event xfs_buf_lock_done: OK
[   59.377997] Testing event xfs_buf_lock: OK
[   59.401986] Testing event xfs_buf_bawrite: OK
[   59.425656] Testing event xfs_buf_submit_wait: OK
[   59.446011] Testing event xfs_buf_submit: OK
[   59.471442] Testing event xfs_buf_iodone: OK
[   59.494138] Testing event xfs_buf_rele: OK
[   59.517637] Testing event xfs_buf_hold: OK
[   59.537975] Testing event xfs_buf_free: OK
[   59.556927] Testing event xfs_buf_init: OK
[   59.577721] Testing event xfs_extlist: OK
[   59.597349] Testing event xfs_bmap_post_update: OK
[   59.630757] Testing event xfs_bmap_pre_update: OK
[   59.666270] Testing event xfs_iext_remove: OK
[   59.689750] Testing event xfs_iext_insert: OK
[   59.709697] Testing event xfs_attr_list_node_descend: OK
[   59.735502] Testing event xfs_ialloc_read_agi: OK
[   59.758187] Testing event xfs_read_agi: OK
[   59.781646] Testing event xfs_alloc_read_agf: OK
[   59.801714] Testing event xfs_read_agf: OK
[   59.821582] Testing event xfs_perag_clear_eofblocks: OK
[   59.841674] Testing event xfs_perag_set_eofblocks: OK
[   59.861714] Testing event xfs_perag_clear_reclaim: OK
[   59.882258] Testing event xfs_perag_set_reclaim: OK
[   59.905941] Testing event xfs_perag_put: OK
[   59.925683] Testing event xfs_perag_get_tag: OK
[   59.945649] Testing event xfs_perag_get: OK
[   59.967971] Testing event xfs_attr_node_list: OK
[   59.990187] Testing event xfs_attr_leaf_list: OK
[   60.012977] Testing event xfs_attr_list_notfound: OK
[   60.032390] Testing event xfs_attr_list_wrong_blk: OK
[   60.052158] Testing event xfs_attr_list_add: OK
[   60.073933] Testing event xfs_attr_list_full: OK
[   60.094195] Testing event xfs_attr_list_leaf_end: OK
[   60.118319] Testing event xfs_attr_list_leaf: OK
[   60.141547] Testing event xfs_attr_list_sf_all: OK
[   60.161763] Testing event xfs_attr_list_sf: OK
[   60.190305] Testing event btrfs_qgroup_record_ref: OK
[   60.209760] Testing event btrfs_qgroup_account: OK
[   60.229395] Testing event btrfs_workqueue_destroy: OK
[   60.254599] Testing event btrfs_workqueue_alloc: OK
[   60.280592] Testing event btrfs_ordered_sched: OK
[   60.303081] Testing event btrfs_all_work_done: OK
[   60.332511] Testing event btrfs_work_sched: OK
[   60.354423] Testing event btrfs_work_queued: OK
[   60.378881] Testing event free_extent_state: OK
[   60.407088] Testing event alloc_extent_state: OK
[   60.430387] Testing event btrfs_setup_cluster: OK
[   60.454845] Testing event btrfs_failed_cluster_setup: OK
[   60.479044] Testing event btrfs_find_cluster: OK
[   60.502636] Testing event btrfs_reserve_extent_cluster: OK
[   60.527136] Testing event btrfs_reserve_extent: OK
[   60.549905] Testing event find_free_extent: OK
[   60.570177] Testing event btrfs_reserved_extent_free: OK
[   60.595951] Testing event btrfs_reserved_extent_alloc: OK
[   60.622040] Testing event btrfs_space_reservation: OK
[   60.653467] Testing event btrfs_cow_block: OK
[   60.676928] Testing event btrfs_chunk_free: OK
[   60.696697] Testing event btrfs_chunk_alloc: OK
[   60.718051] Testing event run_delayed_ref_head: OK
[   60.742763] Testing event add_delayed_ref_head: OK
[   60.768620] Testing event run_delayed_data_ref: OK
[   60.791411] Testing event add_delayed_data_ref: OK
[   60.814926] Testing event run_delayed_tree_ref: OK
[   60.838769] Testing event add_delayed_tree_ref: OK
[   60.862347] Testing event btrfs_sync_fs: OK
[   60.886412] Testing event btrfs_sync_file: OK
[   60.910856] Testing event btrfs_writepage_end_io_hook: OK
[   60.934096] Testing event __extent_writepage: OK
[   60.960606] Testing event btrfs_ordered_extent_put: OK
[   60.983256] Testing event btrfs_ordered_extent_start: OK
[   61.006648] Testing event btrfs_ordered_extent_remove: OK
[   61.031108] Testing event btrfs_ordered_extent_add: OK
[   61.055277] Testing event btrfs_get_extent: OK
[   61.079182] Testing event btrfs_inode_evict: OK
[   61.104576] Testing event btrfs_inode_request: OK
[   61.127675] Testing event btrfs_inode_new: OK
[   61.149279] Testing event btrfs_transaction_commit: OK
[   61.173834] Testing event gfs2_rs: OK
[   61.201474] Testing event gfs2_block_alloc: OK
[   61.221324] Testing event gfs2_bmap: OK
[   61.241104] Testing event gfs2_ail_flush: OK
[   61.261397] Testing event gfs2_log_blocks: OK
[   61.286646] Testing event gfs2_log_flush: OK
[   61.310149] Testing event gfs2_pin: OK
[   61.333362] Testing event gfs2_glock_lock_time: OK
[   61.353771] Testing event gfs2_glock_queue: OK
[   61.382667] Testing event gfs2_promote: OK
[   61.404266] Testing event gfs2_demote_rq: OK
[   61.424572] Testing event gfs2_glock_put: OK
[   61.446062] Testing event gfs2_glock_state_change: OK
[   61.470300] Testing event block_rq_remap: OK
[   61.493710] Testing event block_bio_remap: OK
[   61.513433] Testing event block_split: OK
[   61.532480] Testing event block_unplug: OK
[   61.552980] Testing event block_plug: OK
[   61.572324] Testing event block_sleeprq: OK
[   61.593481] Testing event block_getrq: OK
[   61.617218] Testing event block_bio_queue: OK
[   61.641963] Testing event block_bio_frontmerge: OK
[   61.666163] Testing event block_bio_backmerge: OK
[   61.690326] Testing event block_bio_complete: OK
[   61.714096] Testing event block_bio_bounce: OK
[   61.739189] Testing event block_rq_issue: OK
[   61.763533] Testing event block_rq_insert: OK
[   61.792735] Testing event block_rq_complete: OK
[   61.814737] Testing event block_rq_requeue: OK
[   61.838058] Testing event block_rq_abort: OK
[   61.862414] Testing event block_dirty_buffer: OK
[   61.887268] Testing event block_touch_buffer: OK
[   61.909778] Testing event gpio_value: OK
[   61.935267] Testing event gpio_direction: OK
[   61.960654] Testing event regulator_set_voltage_complete: OK
[   61.983933] Testing event regulator_set_voltage: OK
[   62.006768] Testing event regulator_disable_complete: OK
[   62.030515] Testing event regulator_disable: OK
[   62.054606] Testing event regulator_enable_complete: OK
[   62.079411] Testing event regulator_enable_delay: OK
[   62.102724] Testing event regulator_enable: OK
[   62.126235] Testing event urandom_read: OK
[   62.150669] Testing event random_read: OK
[   62.174156] Testing event extract_entropy_user: OK
[   62.200574] Testing event extract_entropy: OK
[   62.222806] Testing event get_random_bytes_arch: OK
[   62.246961] Testing event get_random_bytes: OK
[   62.270004] Testing event xfer_secondary_pool: OK
[   62.295886] Testing event add_disk_randomness: OK
[   62.321570] Testing event add_input_randomness: OK
[   62.349114] Testing event debit_entropy: OK
[   62.370304] Testing event push_to_pool: OK
[   62.398914] Testing event credit_entropy_bits: OK
[   62.422682] Testing event mix_pool_bytes_nolock: OK
[   62.447218] Testing event mix_pool_bytes: OK
[   62.470645] Testing event add_device_randomness: OK
[   62.494723] Testing event drm_vblank_event_delivered: OK
[   62.522540] Testing event drm_vblank_event_queued: OK
[   62.548520] Testing event drm_vblank_event: OK
[   62.571846] Testing event radeon_semaphore_wait: OK
[   62.594867] Testing event radeon_semaphore_signale: OK
[   62.620398] Testing event radeon_fence_wait_end: OK
[   62.644595] Testing event radeon_fence_wait_begin: OK
[   62.667216] Testing event radeon_fence_emit: OK
[   62.691230] Testing event radeon_vm_flush: OK
[   62.715827] Testing event radeon_vm_set_page: OK
[   62.739607] Testing event radeon_vm_bo_update: OK
[   62.762400] Testing event radeon_vm_grab_id: OK
[   62.787540] Testing event radeon_cs: OK
[   62.810458] Testing event radeon_bo_create: OK
[   62.834426] Testing event regcache_drop_region: OK
[   62.857876] Testing event regmap_async_complete_done: OK
[   62.881057] Testing event regmap_async_complete_start: OK
[   62.901347] Testing event regmap_async_io_complete: OK
[   62.921967] Testing event regmap_async_write_start: OK
[   62.951359] Testing event regmap_cache_bypass: OK
[   62.973441] Testing event regmap_cache_only: OK
[   62.994957] Testing event regcache_sync: OK
[   63.019222] Testing event regmap_hw_write_done: OK
[   63.041763] Testing event regmap_hw_write_start: OK
[   63.067773] Testing event regmap_hw_read_done: OK
[   63.091498] Testing event regmap_hw_read_start: OK
[   63.115162] Testing event regmap_reg_read_cache: OK
[   63.140839] Testing event regmap_reg_read: OK
[   63.168657] Testing event regmap_reg_write: OK
[   63.192589] Testing event fence_wait_end: OK
[   63.215594] Testing event fence_wait_start: OK
[   63.239356] Testing event fence_signaled: OK
[   63.264591] Testing event fence_enable_signal: OK
[   63.289795] Testing event fence_destroy: OK
[   63.310146] Testing event fence_init: OK
[   63.339125] Testing event fence_emit: OK
[   63.362919] Testing event fence_annotate_wait_on: OK
[   63.386158] Testing event scsi_eh_wakeup: OK
[   63.410170] Testing event scsi_dispatch_cmd_timeout: OK
[   63.435433] Testing event scsi_dispatch_cmd_done: OK
[   63.460740] Testing event scsi_dispatch_cmd_error: OK
[   63.487717] Testing event scsi_dispatch_cmd_start: OK
[   63.510303] Testing event target_cmd_complete: OK
[   63.542851] Testing event target_sequencer_start: OK
[   63.567631] Testing event smbus_result: OK
[   63.595572] Testing event smbus_reply: OK
[   63.617851] Testing event smbus_read: OK
[   63.643473] Testing event smbus_write: OK
[   63.671515] Testing event i2c_result: OK
[   63.695216] Testing event i2c_reply: OK
[   63.718352] Testing event i2c_read: OK
[   63.742449] Testing event i2c_write: OK
[   63.767424] Testing event v4l2_qbuf: OK
[   63.789124] Testing event v4l2_dqbuf: OK
[   63.808733] Testing event thermal_zone_trip: OK
[   63.829235] Testing event cdev_update: OK
[   63.850531] Testing event thermal_temperature: OK
[   63.873656] Testing event binder_return: OK
[   63.893945] Testing event binder_command: OK
[   63.922682] Testing event binder_update_page_range: OK
[   63.947147] Testing event binder_transaction_failed_buffer_release: OK
[   63.971367] Testing event binder_transaction_buffer_release: OK
[   63.996426] Testing event binder_transaction_alloc_buf: OK
[   64.019037] Testing event binder_transaction_fd: OK
[   64.043455] Testing event binder_transaction_ref_to_ref: OK
[   64.066577] Testing event binder_transaction_ref_to_node: OK
[   64.091249] Testing event binder_transaction_node_to_ref: OK
[   64.115319] Testing event binder_transaction_received: OK
[   64.139727] Testing event binder_transaction: OK
[   64.162515] Testing event binder_wait_for_work: OK
[   64.191674] Testing event binder_read_done: OK
[   64.214825] Testing event binder_write_done: OK
[   64.236768] Testing event binder_ioctl_done: OK
[   64.257137] Testing event binder_unlock: OK
[   64.282016] Testing event binder_locked: OK
[   64.309169] Testing event binder_lock: OK
[   64.334318] Testing event binder_ioctl: OK
[   64.358301] Testing event udp_fail_queue_rcv_skb: OK
[   64.388565] Testing event sock_exceed_buf_limit: OK
[   64.410308] Testing event sock_rcvqueue_full: OK
[   64.434811] Testing event napi_poll: OK
[   64.458570] Testing event netif_rx_ni_entry: OK
[   64.481699] Testing event netif_rx_entry: OK
[   64.506969] Testing event netif_receive_skb_entry: OK
[   64.530182] Testing event napi_gro_receive_entry: OK
[   64.553843] Testing event napi_gro_frags_entry: OK
[   64.573187] Testing event netif_rx: OK
[   64.595147] Testing event netif_receive_skb: OK
[   64.619635] Testing event net_dev_queue: OK
[   64.642648] Testing event net_dev_xmit: OK
[   64.666209] Testing event net_dev_start_xmit: OK
[   64.690102] Testing event skb_copy_datagram_iovec: OK
[   64.712565] Testing event consume_skb: OK
[   64.734152] Testing event kfree_skb: OK
[   64.758935] Running tests on trace event systems:
[   64.764987] Testing event system skb: OK
[   64.790022] Testing event system net: OK
[   64.819404] Testing event system napi: OK
[   64.842948] Testing event system sock: OK
[   64.868388] Testing event system udp: OK
[   64.892333] Testing event system binder: OK
[   64.932583] Testing event system thermal: OK
[   64.959656] Testing event system v4l2: OK
[   64.986193] Testing event system i2c: OK
[   65.013939] Testing event system target: OK
[   65.041087] Testing event system scsi: OK
[   65.067888] Testing event system fence: OK
[   65.100287] Testing event system regmap: OK
[   65.137831] Testing event system radeon: OK
[   65.168667] Testing event system drm: OK
[   65.193634] Testing event system random: OK
[   65.227205] Testing event system regulator: OK
[   65.253274] Testing event system gpio:=20
[   65.264935] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[   65.285062] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[   65.292829] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[   65.299948] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[   65.318983] OK
[   65.326374] Testing event system block: OK
[   65.360262] Testing event system gfs2: OK
[   65.397320] Testing event system btrfs: OK
[   65.455383] Testing event system xfs: OK
[   65.678477] Testing event system jbd2: OK
[   65.709781] Testing event system jbd: OK
[   65.737389] Testing event system ext4: OK
[   65.803731] Testing event system ext3: OK
[   65.849037] Testing event system filelock: OK
[   65.879102] Testing event system writeback: OK
[   65.919685] Testing event system kmem: OK
[   65.953211] Testing event system vmscan: OK
[   65.985984] Testing event system pagemap:=20
[   66.008763] Testing event system oom: OK
OK
[   66.040818] Testing event system filemap: OK
[   66.062919] Testing event system power: OK
[   66.113627] Testing event system test: OK
[   66.137050] Testing event system timer: OK
[   66.176430] Testing event system rcu: OK
[   66.204116] Testing event system printk: OK
[   66.227220] Testing event system lock: OK
[   66.254687] Testing event system sched: OK
[   66.287918] Testing event system workqueue: OK
[   66.315133] Testing event system signal: OK
[   66.342582] Testing event system irq: OK
[   66.371582] Testing event system task: OK
[   66.396742] Testing event system exceptions: OK
[   66.424716] Testing event system tlb: OK
[   66.454333] Testing event system raw_syscalls: OK
[   66.479138] Testing event system nmi: OK
[   66.503022] Testing event system irq_vectors: OK
[   66.536626] Running tests on all trace events:
[   66.543900] Testing all events: OK
[   67.208766] Testing ftrace filter: OK
[   67.214565] Btrfs loaded, debug=3Don, integrity-checker=3Don
[   67.217243] BTRFS: selftest: Running btrfs free space cache tests
[   67.219782] BTRFS: selftest: Running extent only tests
[   67.222296] BTRFS: selftest: Running bitmap only tests
[   67.225013] BTRFS: selftest: Running bitmap and extent tests
[   67.227513] BTRFS: selftest: Running space stealing from bitmap to extent
[   67.230515] BTRFS: selftest: Free space cache tests finished
[   67.233257] BTRFS: selftest: Running extent buffer operation tests
[   67.234207] BTRFS: selftest: Running btrfs_split_item tests
[   67.238390] BTRFS: selftest: Running find delalloc tests
[  125.304040] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  125.310278] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  125.313089] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  125.315892] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  125.318978] ??? Writer stall state 8 g4722 c4722 f0x0
[  125.320727] rcu_sched: wait state: 1 ->state: 0x1
[  125.322335] rcu_bh: wait state: 1 ->state: 0x1
[  125.323931] Dumping ftrace buffer:
[  125.324717] ---------------------------------
[  125.324717] CPU:1 [LOST 9422718 EVENTS]
[  125.324717]   <idle>-0       1d.s2 63426492us : _local_bh_enable <-irq_e=
nter
[  125.324717]   <idle>-0       1d.s2 63426492us : __local_bh_enable <-_loc=
al_bh_enable
[  125.324717]   <idle>-0       1d.h2 63426493us : generic_smp_call_functio=
n_single_interrupt <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426493us : flush_smp_call_function_=
queue <-generic_smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426494us : do_sync_core <-flush_smp=
_call_function_queue
[  125.324717]   <idle>-0       1d.h2 63426496us : irq_exit <-smp_call_func=
tion_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426497us : rcu_irq_exit <-irq_exit
[  125.324717]   <idle>-0       1d..2 63426497us : rcu_eqs_enter_common <-r=
cu_irq_exit
[  125.324717]   <idle>-0       1d..2 63426498us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426498us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1...2 63426499us : rcu_idle_exit <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426500us : rcu_eqs_exit_common <-rc=
u_idle_exit
[  125.324717]   <idle>-0       1...2 63426501us : arch_cpu_idle_exit <-cpu=
_idle_loop
[  125.324717]   <idle>-0       1d..2 63426501us : arch_cpu_idle_enter <-cp=
u_idle_loop
[  125.324717]   <idle>-0       1d..2 63426502us : local_touch_nmi <-arch_c=
pu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426503us : tick_check_broadcast_exp=
ired <-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426503us : cpuidle_get_cpu_driver <=
-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426504us : rcu_idle_enter <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426505us : rcu_eqs_enter_common <-r=
cu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426506us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426506us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426507us : cpuidle_select <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426508us : arch_cpu_idle <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426509us : default_idle <-arch_cpu_=
idle
[  125.324717]   <idle>-0       1d..2 63426531us : smp_call_function_single=
_interrupt <-call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426532us : kvm_guest_apic_eoi_write=
 <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426532us : irq_enter <-smp_call_fun=
ction_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426533us : rcu_irq_enter <-irq_enter
[  125.324717]   <idle>-0       1d..2 63426533us : rcu_eqs_exit_common <-rc=
u_irq_enter
[  125.324717]   <idle>-0       1d..2 63426533us : __local_bh_disable_ip <-=
irq_enter
[  125.324717]   <idle>-0       1d.s2 63426534us : tick_irq_enter <-irq_ent=
er
[  125.324717]   <idle>-0       1d.s2 63426534us : tick_check_oneshot_broad=
cast_this_cpu <-tick_irq_enter
[  125.324717]   <idle>-0       1d.s2 63426534us : _local_bh_enable <-irq_e=
nter
[  125.324717]   <idle>-0       1d.s2 63426535us : __local_bh_enable <-_loc=
al_bh_enable
[  125.324717]   <idle>-0       1d.h2 63426535us : generic_smp_call_functio=
n_single_interrupt <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426536us : flush_smp_call_function_=
queue <-generic_smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426536us : do_sync_core <-flush_smp=
_call_function_queue
[  125.324717]   <idle>-0       1d.h2 63426538us : irq_exit <-smp_call_func=
tion_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426539us : rcu_irq_exit <-irq_exit
[  125.324717]   <idle>-0       1d..2 63426540us : rcu_eqs_enter_common <-r=
cu_irq_exit
[  125.324717]   <idle>-0       1d..2 63426540us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426540us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1...2 63426541us : rcu_idle_exit <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426542us : rcu_eqs_exit_common <-rc=
u_idle_exit
[  125.324717]   <idle>-0       1...2 63426543us : arch_cpu_idle_exit <-cpu=
_idle_loop
[  125.324717]   <idle>-0       1d..2 63426544us : arch_cpu_idle_enter <-cp=
u_idle_loop
[  125.324717]   <idle>-0       1d..2 63426544us : local_touch_nmi <-arch_c=
pu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426545us : tick_check_broadcast_exp=
ired <-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426546us : cpuidle_get_cpu_driver <=
-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426547us : rcu_idle_enter <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426548us : rcu_eqs_enter_common <-r=
cu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426548us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426549us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426550us : cpuidle_select <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426551us : arch_cpu_idle <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426551us : default_idle <-arch_cpu_=
idle
[  125.324717]   <idle>-0       1d..2 63426590us : smp_call_function_single=
_interrupt <-call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426591us : kvm_guest_apic_eoi_write=
 <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426591us : irq_enter <-smp_call_fun=
ction_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426592us : rcu_irq_enter <-irq_enter
[  125.324717]   <idle>-0       1d..2 63426592us : rcu_eqs_exit_common <-rc=
u_irq_enter
[  125.324717]   <idle>-0       1d..2 63426592us : __local_bh_disable_ip <-=
irq_enter
[  125.324717]   <idle>-0       1d.s2 63426593us : tick_irq_enter <-irq_ent=
er
[  125.324717]   <idle>-0       1d.s2 63426593us : tick_check_oneshot_broad=
cast_this_cpu <-tick_irq_enter
[  125.324717]   <idle>-0       1d.s2 63426594us : _local_bh_enable <-irq_e=
nter
[  125.324717]   <idle>-0       1d.s2 63426594us : __local_bh_enable <-_loc=
al_bh_enable
[  125.324717]   <idle>-0       1d.h2 63426595us : generic_smp_call_functio=
n_single_interrupt <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426595us : flush_smp_call_function_=
queue <-generic_smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426596us : do_sync_core <-flush_smp=
_call_function_queue
[  125.324717]   <idle>-0       1d.h2 63426598us : irq_exit <-smp_call_func=
tion_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426598us : rcu_irq_exit <-irq_exit
[  125.324717]   <idle>-0       1d..2 63426599us : rcu_eqs_enter_common <-r=
cu_irq_exit
[  125.324717]   <idle>-0       1d..2 63426599us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426600us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1...2 63426601us : rcu_idle_exit <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426601us : rcu_eqs_exit_common <-rc=
u_idle_exit
[  125.324717]   <idle>-0       1...2 63426602us : arch_cpu_idle_exit <-cpu=
_idle_loop
[  125.324717]   <idle>-0       1d..2 63426603us : arch_cpu_idle_enter <-cp=
u_idle_loop
[  125.324717]   <idle>-0       1d..2 63426604us : local_touch_nmi <-arch_c=
pu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426604us : tick_check_broadcast_exp=
ired <-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426605us : cpuidle_get_cpu_driver <=
-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426606us : rcu_idle_enter <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426606us : rcu_eqs_enter_common <-r=
cu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426607us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426608us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426608us : cpuidle_select <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426609us : arch_cpu_idle <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426610us : default_idle <-arch_cpu_=
idle
[  125.324717]   <idle>-0       1d..2 63426632us : smp_call_function_single=
_interrupt <-call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426633us : kvm_guest_apic_eoi_write=
 <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426633us : irq_enter <-smp_call_fun=
ction_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426634us : rcu_irq_enter <-irq_enter
[  125.324717]   <idle>-0       1d..2 63426634us : rcu_eqs_exit_common <-rc=
u_irq_enter
[  125.324717]   <idle>-0       1d..2 63426634us : __local_bh_disable_ip <-=
irq_enter
[  125.324717]   <idle>-0       1d.s2 63426635us : tick_irq_enter <-irq_ent=
er
[  125.324717]   <idle>-0       1d.s2 63426635us : tick_check_oneshot_broad=
cast_this_cpu <-tick_irq_enter
[  125.324717]   <idle>-0       1d.s2 63426636us : _local_bh_enable <-irq_e=
nter
[  125.324717]   <idle>-0       1d.s2 63426636us : __local_bh_enable <-_loc=
al_bh_enable
[  125.324717]   <idle>-0       1d.h2 63426636us : generic_smp_call_functio=
n_single_interrupt <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426637us : flush_smp_call_function_=
queue <-generic_smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426637us : do_sync_core <-flush_smp=
_call_function_queue
[  125.324717]   <idle>-0       1d.h2 63426639us : irq_exit <-smp_call_func=
tion_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426640us : rcu_irq_exit <-irq_exit
[  125.324717]   <idle>-0       1d..2 63426641us : rcu_eqs_enter_common <-r=
cu_irq_exit
[  125.324717]   <idle>-0       1d..2 63426641us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426641us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1...2 63426642us : rcu_idle_exit <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426643us : rcu_eqs_exit_common <-rc=
u_idle_exit
[  125.324717]   <idle>-0       1...2 63426644us : arch_cpu_idle_exit <-cpu=
_idle_loop
[  125.324717]   <idle>-0       1d..2 63426644us : arch_cpu_idle_enter <-cp=
u_idle_loop
[  125.324717]   <idle>-0       1d..2 63426645us : local_touch_nmi <-arch_c=
pu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426646us : tick_check_broadcast_exp=
ired <-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426646us : cpuidle_get_cpu_driver <=
-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426647us : rcu_idle_enter <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426648us : rcu_eqs_enter_common <-r=
cu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426648us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426649us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426650us : cpuidle_select <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426651us : arch_cpu_idle <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426651us : default_idle <-arch_cpu_=
idle
[  125.324717]   <idle>-0       1d..2 63426674us : smp_call_function_single=
_interrupt <-call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426675us : kvm_guest_apic_eoi_write=
 <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426676us : irq_enter <-smp_call_fun=
ction_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426676us : rcu_irq_enter <-irq_enter
[  125.324717]   <idle>-0       1d..2 63426676us : rcu_eqs_exit_common <-rc=
u_irq_enter
[  125.324717]   <idle>-0       1d..2 63426677us : __local_bh_disable_ip <-=
irq_enter
[  125.324717]   <idle>-0       1d.s2 63426677us : tick_irq_enter <-irq_ent=
er
[  125.324717]   <idle>-0       1d.s2 63426677us : tick_check_oneshot_broad=
cast_this_cpu <-tick_irq_enter
[  125.324717]   <idle>-0       1d.s2 63426678us : _local_bh_enable <-irq_e=
nter
[  125.324717]   <idle>-0       1d.s2 63426678us : __local_bh_enable <-_loc=
al_bh_enable
[  125.324717]   <idle>-0       1d.h2 63426679us : generic_smp_call_functio=
n_single_interrupt <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426679us : flush_smp_call_function_=
queue <-generic_smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426680us : do_sync_core <-flush_smp=
_call_function_queue
[  125.324717]   <idle>-0       1d.h2 63426682us : irq_exit <-smp_call_func=
tion_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426682us : rcu_irq_exit <-irq_exit
[  125.324717]   <idle>-0       1d..2 63426683us : rcu_eqs_enter_common <-r=
cu_irq_exit
[  125.324717]   <idle>-0       1d..2 63426683us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426684us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1...2 63426685us : rcu_idle_exit <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426686us : rcu_eqs_exit_common <-rc=
u_idle_exit
[  125.324717]   <idle>-0       1...2 63426686us : arch_cpu_idle_exit <-cpu=
_idle_loop
[  125.324717]   <idle>-0       1d..2 63426687us : arch_cpu_idle_enter <-cp=
u_idle_loop
[  125.324717]   <idle>-0       1d..2 63426688us : local_touch_nmi <-arch_c=
pu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426688us : tick_check_broadcast_exp=
ired <-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426689us : cpuidle_get_cpu_driver <=
-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426690us : rcu_idle_enter <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426690us : rcu_eqs_enter_common <-r=
cu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426691us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426692us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426693us : cpuidle_select <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426693us : arch_cpu_idle <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426694us : default_idle <-arch_cpu_=
idle
[  125.324717]   <idle>-0       1d..2 63426724us : smp_call_function_single=
_interrupt <-call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426725us : kvm_guest_apic_eoi_write=
 <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426725us : irq_enter <-smp_call_fun=
ction_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426726us : rcu_irq_enter <-irq_enter
[  125.324717]   <idle>-0       1d..2 63426726us : rcu_eqs_exit_common <-rc=
u_irq_enter
[  125.324717]   <idle>-0       1d..2 63426726us : __local_bh_disable_ip <-=
irq_enter
[  125.324717]   <idle>-0       1d.s2 63426727us : tick_irq_enter <-irq_ent=
er
[  125.324717]   <idle>-0       1d.s2 63426727us : tick_check_oneshot_broad=
cast_this_cpu <-tick_irq_enter
[  125.324717]   <idle>-0       1d.s2 63426728us : _local_bh_enable <-irq_e=
nter
[  125.324717]   <idle>-0       1d.s2 63426728us : __local_bh_enable <-_loc=
al_bh_enable
[  125.324717]   <idle>-0       1d.h2 63426729us : generic_smp_call_functio=
n_single_interrupt <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426729us : flush_smp_call_function_=
queue <-generic_smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426729us : do_sync_core <-flush_smp=
_call_function_queue
[  125.324717]   <idle>-0       1d.h2 63426731us : irq_exit <-smp_call_func=
tion_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426732us : rcu_irq_exit <-irq_exit
[  125.324717]   <idle>-0       1d..2 63426733us : rcu_eqs_enter_common <-r=
cu_irq_exit
[  125.324717]   <idle>-0       1d..2 63426733us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426734us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1...2 63426735us : rcu_idle_exit <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426735us : rcu_eqs_exit_common <-rc=
u_idle_exit
[  125.324717]   <idle>-0       1...2 63426736us : arch_cpu_idle_exit <-cpu=
_idle_loop
[  125.324717]   <idle>-0       1d..2 63426737us : arch_cpu_idle_enter <-cp=
u_idle_loop
[  125.324717]   <idle>-0       1d..2 63426737us : local_touch_nmi <-arch_c=
pu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426738us : tick_check_broadcast_exp=
ired <-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426739us : cpuidle_get_cpu_driver <=
-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426739us : rcu_idle_enter <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426740us : rcu_eqs_enter_common <-r=
cu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426741us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426742us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426742us : cpuidle_select <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426743us : arch_cpu_idle <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426744us : default_idle <-arch_cpu_=
idle
[  125.324717]   <idle>-0       1d..2 63426766us : smp_call_function_single=
_interrupt <-call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426767us : kvm_guest_apic_eoi_write=
 <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426767us : irq_enter <-smp_call_fun=
ction_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426768us : rcu_irq_enter <-irq_enter
[  125.324717]   <idle>-0       1d..2 63426768us : rcu_eqs_exit_common <-rc=
u_irq_enter
[  125.324717]   <idle>-0       1d..2 63426769us : __local_bh_disable_ip <-=
irq_enter
[  125.324717]   <idle>-0       1d.s2 63426769us : tick_irq_enter <-irq_ent=
er
[  125.324717]   <idle>-0       1d.s2 63426770us : tick_check_oneshot_broad=
cast_this_cpu <-tick_irq_enter
[  125.324717]   <idle>-0       1d.s2 63426770us : _local_bh_enable <-irq_e=
nter
[  125.324717]   <idle>-0       1d.s2 63426770us : __local_bh_enable <-_loc=
al_bh_enable
[  125.324717]   <idle>-0       1d.h2 63426771us : generic_smp_call_functio=
n_single_interrupt <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426771us : flush_smp_call_function_=
queue <-generic_smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426772us : do_sync_core <-flush_smp=
_call_function_queue
[  125.324717]   <idle>-0       1d.h2 63426774us : irq_exit <-smp_call_func=
tion_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426774us : rcu_irq_exit <-irq_exit
[  125.324717]   <idle>-0       1d..2 63426775us : rcu_eqs_enter_common <-r=
cu_irq_exit
[  125.324717]   <idle>-0       1d..2 63426776us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426776us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1...2 63426777us : rcu_idle_exit <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426778us : rcu_eqs_exit_common <-rc=
u_idle_exit
[  125.324717]   <idle>-0       1...2 63426779us : arch_cpu_idle_exit <-cpu=
_idle_loop
[  125.324717]   <idle>-0       1d..2 63426780us : arch_cpu_idle_enter <-cp=
u_idle_loop
[  125.324717]   <idle>-0       1d..2 63426780us : local_touch_nmi <-arch_c=
pu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426781us : tick_check_broadcast_exp=
ired <-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426782us : cpuidle_get_cpu_driver <=
-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426782us : rcu_idle_enter <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426783us : rcu_eqs_enter_common <-r=
cu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426784us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426785us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426785us : cpuidle_select <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426786us : arch_cpu_idle <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426787us : default_idle <-arch_cpu_=
idle
[  125.324717]   <idle>-0       1d..2 63426809us : smp_call_function_single=
_interrupt <-call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426810us : kvm_guest_apic_eoi_write=
 <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426810us : irq_enter <-smp_call_fun=
ction_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426811us : rcu_irq_enter <-irq_enter
[  125.324717]   <idle>-0       1d..2 63426811us : rcu_eqs_exit_common <-rc=
u_irq_enter
[  125.324717]   <idle>-0       1d..2 63426811us : __local_bh_disable_ip <-=
irq_enter
[  125.324717]   <idle>-0       1d.s2 63426812us : tick_irq_enter <-irq_ent=
er
[  125.324717]   <idle>-0       1d.s2 63426812us : tick_check_oneshot_broad=
cast_this_cpu <-tick_irq_enter
[  125.324717]   <idle>-0       1d.s2 63426813us : _local_bh_enable <-irq_e=
nter
[  125.324717]   <idle>-0       1d.s2 63426813us : __local_bh_enable <-_loc=
al_bh_enable
[  125.324717]   <idle>-0       1d.h2 63426813us : generic_smp_call_functio=
n_single_interrupt <-smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426814us : flush_smp_call_function_=
queue <-generic_smp_call_function_single_interrupt
[  125.324717]   <idle>-0       1d.h2 63426814us : do_sync_core <-flush_smp=
_call_function_queue
[  125.324717]   <idle>-0       1d.h2 63426816us : irq_exit <-smp_call_func=
tion_single_interrupt
[  125.324717]   <idle>-0       1d..2 63426817us : rcu_irq_exit <-irq_exit
[  125.324717]   <idle>-0       1d..2 63426818us : rcu_eqs_enter_common <-r=
cu_irq_exit
[  125.324717]   <idle>-0       1d..2 63426818us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426818us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1...2 63426819us : rcu_idle_exit <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426820us : rcu_eqs_exit_common <-rc=
u_idle_exit
[  125.324717]   <idle>-0       1...2 63426821us : arch_cpu_idle_exit <-cpu=
_idle_loop
[  125.324717]   <idle>-0       1d..2 63426821us : arch_cpu_idle_enter <-cp=
u_idle_loop
[  125.324717]   <idle>-0       1d..2 63426822us : local_touch_nmi <-arch_c=
pu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426823us : tick_check_broadcast_exp=
ired <-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426824us : cpuidle_get_cpu_driver <=
-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63426824us : rcu_idle_enter <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426825us : rcu_eqs_enter_common <-r=
cu_idle_enter
[  125.324717]   <idle>-0       1d..2 63426826us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426826us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63426827us : cpuidle_select <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63426828us : arch_cpu_idle <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63426828us : default_idle <-arch_cpu_=
idle
[  125.324717]   <idle>-0       1d..2 63430503us : smp_apic_timer_interrupt=
 <-apic_timer_interrupt
[  125.324717]   <idle>-0       1d..2 63430509us : kvm_guest_apic_eoi_write=
 <-smp_apic_timer_interrupt
[  125.324717]   <idle>-0       1d..2 63430511us : irq_enter <-smp_apic_tim=
er_interrupt
[  125.324717]   <idle>-0       1d..2 63430512us : rcu_irq_enter <-irq_enter
[  125.324717]   <idle>-0       1d..2 63430515us : rcu_eqs_exit_common <-rc=
u_irq_enter
[  125.324717]   <idle>-0       1d..2 63430516us : __local_bh_disable_ip <-=
irq_enter
[  125.324717]   <idle>-0       1d.s2 63430518us : tick_irq_enter <-irq_ent=
er
[  125.324717]   <idle>-0       1d.s2 63430520us : tick_check_oneshot_broad=
cast_this_cpu <-tick_irq_enter
[  125.324717]   <idle>-0       1d.s2 63430522us : _local_bh_enable <-irq_e=
nter
[  125.324717]   <idle>-0       1d.s2 63430523us : __local_bh_enable <-_loc=
al_bh_enable
[  125.324717]   <idle>-0       1d.h2 63430525us : local_apic_timer_interru=
pt <-smp_apic_timer_interrupt
[  125.324717]   <idle>-0       1d.h2 63430527us : hrtimer_interrupt <-loca=
l_apic_timer_interrupt
[  125.324717]   <idle>-0       1d.h2 63430529us : _raw_spin_lock <-hrtimer=
_interrupt
[  125.324717]   <idle>-0       1d.h3 63430532us : do_raw_spin_trylock <-_r=
aw_spin_lock
[  125.324717]   <idle>-0       1d.h3 63430535us : ktime_get_update_offsets=
_now <-hrtimer_interrupt
[  125.324717]   <idle>-0       1d.h3 63430538us : __run_hrtimer <-hrtimer_=
interrupt
[  125.324717]   <idle>-0       1d.h3 63430539us : __remove_hrtimer <-__run=
_hrtimer
[  125.324717]   <idle>-0       1d.h3 63430542us : _raw_spin_unlock <-__run=
_hrtimer
[  125.324717]   <idle>-0       1d.h3 63430543us : do_raw_spin_unlock <-_ra=
w_spin_unlock
[  125.324717]   <idle>-0       1d.h2 63430546us : tick_sched_timer <-__run=
_hrtimer
[  125.324717]   <idle>-0       1d.h2 63430547us : ktime_get <-tick_sched_t=
imer
[  125.324717]   <idle>-0       1d.h2 63430550us : update_process_times <-t=
ick_sched_timer
[  125.324717]   <idle>-0       1d.h2 63430552us : account_process_tick <-u=
pdate_process_times
[  125.324717]   <idle>-0       1d.h2 63430553us : kvm_steal_clock <-accoun=
t_process_tick
[  125.324717]   <idle>-0       1d.h2 63430554us : nsecs_to_jiffies <-accou=
nt_process_tick
[  125.324717]   <idle>-0       1d.h2 63430555us : nsecs_to_jiffies64 <-nse=
cs_to_jiffies
[  125.324717]   <idle>-0       1d.h2 63430557us : jiffies_to_usecs <-accou=
nt_process_tick
[  125.324717]   <idle>-0       1d.h2 63430558us : account_steal_time <-acc=
ount_process_tick
[  125.324717]   <idle>-0       1d.h2 63430561us : account_idle_time <-acco=
unt_process_tick
[  125.324717]   <idle>-0       1d.h2 63430562us : run_local_timers <-updat=
e_process_times
[  125.324717]   <idle>-0       1d.h2 63430564us : hrtimer_run_queues <-run=
_local_timers
[  125.324717]   <idle>-0       1d.h2 63430566us : raise_softirq <-run_loca=
l_timers
[  125.324717]   <idle>-0       1d.h2 63430567us : __raise_softirq_irqoff <=
-raise_softirq
[  125.324717]   <idle>-0       1d.h2 63430569us : rcu_check_callbacks <-up=
date_process_times
[  125.324717]   <idle>-0       1d.h2 63430570us : rcu_sched_qs <-rcu_check=
_callbacks
[  125.324717]   <idle>-0       1d.h2 63430572us : rcu_bh_qs <-rcu_check_ca=
llbacks
[  125.324717]   <idle>-0       1d.h2 63430574us : cpu_needs_another_gp <-r=
cu_check_callbacks
[  125.324717]   <idle>-0       1d.h2 63430575us : cpu_needs_another_gp <-r=
cu_check_callbacks
[  125.324717]   <idle>-0       1d.h2 63430577us : scheduler_tick <-update_=
process_times
[  125.324717]   <idle>-0       1d.h2 63430578us : ktime_get <-sched_clock_=
tick
[  125.324717]   <idle>-0       1d.h2 63430578us : _raw_spin_lock <-schedul=
er_tick
[  125.324717]   <idle>-0       1d.h3 63430579us : do_raw_spin_trylock <-_r=
aw_spin_lock
[  125.324717]   <idle>-0       1d.h3 63430580us : update_rq_clock <-schedu=
ler_tick
[  125.324717]   <idle>-0       1d.h3 63430581us : task_tick_idle <-schedul=
er_tick
[  125.324717]   <idle>-0       1d.h3 63430581us : update_cpu_load_active <=
-scheduler_tick
[  125.324717]   <idle>-0       1d.h3 63430581us : sched_avg_update <-updat=
e_cpu_load_active
[  125.324717]   <idle>-0       1d.h3 63430582us : _raw_spin_unlock <-sched=
uler_tick
[  125.324717]   <idle>-0       1d.h3 63430582us : do_raw_spin_unlock <-_ra=
w_spin_unlock
[  125.324717]   <idle>-0       1d.h2 63430583us : idle_cpu <-scheduler_tick
[  125.324717]   <idle>-0       1d.h2 63430584us : trigger_load_balance <-s=
cheduler_tick
[  125.324717]   <idle>-0       1d.h2 63430586us : run_posix_cpu_timers <-u=
pdate_process_times
[  125.324717]   <idle>-0       1d.h2 63430588us : profile_tick <-tick_sche=
d_timer
[  125.324717]   <idle>-0       1d.h2 63430591us : hrtimer_forward <-tick_s=
ched_timer
[  125.324717]   <idle>-0       1d.h2 63430591us : ktime_add_safe <-hrtimer=
_forward
[  125.324717]   <idle>-0       1d.h2 63430592us : ktime_add_safe <-hrtimer=
_forward
[  125.324717]   <idle>-0       1d.h2 63430592us : _raw_spin_lock <-__run_h=
rtimer
[  125.324717]   <idle>-0       1d.h3 63430593us : do_raw_spin_trylock <-_r=
aw_spin_lock
[  125.324717]   <idle>-0       1d.h3 63430593us : enqueue_hrtimer <-__run_=
hrtimer
[  125.324717]   <idle>-0       1d.h3 63430594us : _raw_spin_unlock <-hrtim=
er_interrupt
[  125.324717]   <idle>-0       1d.h3 63430595us : do_raw_spin_unlock <-_ra=
w_spin_unlock
[  125.324717]   <idle>-0       1d.h2 63430595us : tick_program_event <-hrt=
imer_interrupt
[  125.324717]   <idle>-0       1d.h2 63430596us : clockevents_program_even=
t <-tick_program_event
[  125.324717]   <idle>-0       1d.h2 63430596us : ktime_get <-clockevents_=
program_event
[  125.324717]   <idle>-0       1d.h2 63430597us : lapic_next_event <-clock=
events_program_event
[  125.324717]   <idle>-0       1d.h2 63430607us : irq_exit <-smp_apic_time=
r_interrupt
[  125.324717]   <idle>-0       1d..2 63430608us : do_softirq_own_stack <-i=
rq_exit
[  125.324717]   <idle>-0       1d..2 63430609us : __do_softirq <-do_softir=
q_own_stack
[  125.324717]   <idle>-0       1d..2 63430609us : msecs_to_jiffies <-__do_=
softirq
[  125.324717]   <idle>-0       1d..2 63430610us : __local_bh_disable_ip <-=
__do_softirq
[  125.324717]   <idle>-0       1..s2 63430611us : run_timer_softirq <-__do=
_softirq
[  125.324717]   <idle>-0       1..s2 63430611us : hrtimer_run_pending <-ru=
n_timer_softirq
[  125.324717]   <idle>-0       1..s2 63430612us : rcu_bh_qs <-__do_softirq
[  125.324717]   <idle>-0       1d.s2 63430612us : __local_bh_enable <-__do=
_softirq
[  125.324717]   <idle>-0       1d..2 63430613us : rcu_irq_exit <-irq_exit
[  125.324717]   <idle>-0       1d..2 63430613us : rcu_eqs_enter_common <-r=
cu_irq_exit
[  125.324717]   <idle>-0       1d..2 63430614us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63430615us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1...2 63430617us : rcu_idle_exit <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63430618us : rcu_eqs_exit_common <-rc=
u_idle_exit
[  125.324717]   <idle>-0       1...2 63430618us : arch_cpu_idle_exit <-cpu=
_idle_loop
[  125.324717]   <idle>-0       1d..2 63430619us : arch_cpu_idle_enter <-cp=
u_idle_loop
[  125.324717]   <idle>-0       1d..2 63430619us : local_touch_nmi <-arch_c=
pu_idle_enter
[  125.324717]   <idle>-0       1d..2 63430620us : tick_check_broadcast_exp=
ired <-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63430620us : cpuidle_get_cpu_driver <=
-cpu_idle_loop
[  125.324717]   <idle>-0       1d..2 63430621us : rcu_idle_enter <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63430621us : rcu_eqs_enter_common <-r=
cu_idle_enter
[  125.324717]   <idle>-0       1d..2 63430622us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63430622us : do_nocb_deferred_wakeup =
<-rcu_eqs_enter_common
[  125.324717]   <idle>-0       1d..2 63430623us : cpuidle_select <-cpu_idl=
e_loop
[  125.324717]   <idle>-0       1d..2 63430623us : arch_cpu_idle <-cpu_idle=
_loop
[  125.324717]   <idle>-0       1d..2 63430626us : default_idle <-arch_cpu_=
idle
[  125.324717] CPU:0 [LOST 9092864 EVENTS]
[  125.324717] swapper/-1       0d..3 63431861us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431861us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431861us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431862us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431862us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431862us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431863us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431863us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431863us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431864us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431864us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431864us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431865us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431865us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431865us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431866us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431866us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431866us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431866us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431867us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431867us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431867us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431868us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431868us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431868us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431869us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431869us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431869us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431870us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431870us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431870us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431871us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431871us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431871us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431872us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431872us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431872us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431873us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431873us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431873us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431873us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431874us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431874us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431874us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431875us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431875us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431875us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431876us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431876us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431876us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431877us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431877us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431877us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431878us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431878us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431878us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431879us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431879us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431879us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431879us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431880us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431880us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431880us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431881us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431881us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431881us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431882us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431882us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431882us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431883us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431883us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431883us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431884us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431884us : console_conditional_sche=
dule <-fbcon_redraw
[  125.324717] swapper/-1       0d..3 63431885us : fbcon_clear <-fbcon_scro=
ll
[  125.324717] swapper/-1       0d..3 63431885us : bit_clear <-fbcon_clear
[  125.324717] swapper/-1       0d..3 63431886us : cirrus_fillrect <-bit_cl=
ear
[  125.324717] swapper/-1       0d..3 63431886us : sys_fillrect <-cirrus_fi=
llrect
[  125.324717] swapper/-1       0d..3 63431887us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431890us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431893us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431896us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431898us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431901us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431904us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431907us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431909us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431912us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431915us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431918us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431920us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431923us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431926us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431929us : bitfill_unaligned <-sys_=
fillrect
[  125.324717] swapper/-1       0d..3 63431931us : cirrus_dirty_update <-ci=
rrus_fillrect
[  125.324717] swapper/-1       0d..3 63431932us : _raw_spin_lock_irqsave <=
-cirrus_dirty_update
[  125.324717] swapper/-1       0d..4 63431932us : do_raw_spin_trylock <-_r=
aw_spin_lock_irqsave
[  125.324717] swapper/-1       0d..4 63431933us : _raw_spin_unlock_irqrest=
ore <-cirrus_dirty_update
[  125.324717] swapper/-1       0d..4 63431933us : do_raw_spin_unlock <-_ra=
w_spin_unlock_irqrestore
[  125.324717] swapper/-1       0d..3 63431934us : notify_write <-lf
[  125.324717] swapper/-1       0d..3 63431934us : atomic_notifier_call_cha=
in <-notify_write
[  125.324717] swapper/-1       0d..3 63431934us : __atomic_notifier_call_c=
hain <-atomic_notifier_call_chain
[  125.324717] swapper/-1       0d..4 63431935us : notifier_call_chain <-__=
atomic_notifier_call_chain
[  125.324717] swapper/-1       0d..4 63431935us : vt_notifier_call <-notif=
ier_call_chain
[  125.324717] swapper/-1       0d..3 63431936us : notify_write <-vt_consol=
e_print
[  125.324717] swapper/-1       0d..3 63431936us : atomic_notifier_call_cha=
in <-notify_write
[  125.324717] swapper/-1       0d..3 63431936us : __atomic_notifier_call_c=
hain <-atomic_notifier_call_chain
[  125.324717] swapper/-1       0d..4 63431937us : notifier_call_chain <-__=
atomic_notifier_call_chain
[  125.324717] swapper/-1       0d..4 63431937us : vt_notifier_call <-notif=
ier_call_chain
[  125.324717] swapper/-1       0d..3 63431938us : set_cursor <-vt_console_=
print
[  125.324717] swapper/-1       0d..3 63431938us : add_softcursor <-set_cur=
sor
[  125.324717] swapper/-1       0d..3 63431938us : fbcon_cursor <-set_cursor
[  125.324717] swapper/-1       0d..3 63431939us : fbcon_add_cursor_timer <=
-fbcon_cursor
[  125.324717] swapper/-1       0d..3 63431939us : get_color <-fbcon_cursor
[  125.324717] swapper/-1       0d..3 63431940us : fb_get_color_depth <-get=
_color
[  125.324717] swapper/-1       0d..3 63431940us : get_color <-fbcon_cursor
[  125.324717] swapper/-1       0d..3 63431940us : fb_get_color_depth <-get=
_color
[  125.324717] swapper/-1       0d..3 63431940us : bit_cursor <-fbcon_cursor
[  125.324717] swapper/-1       0d..3 63431941us : fb_get_color_depth <-bit=
_cursor
[  125.324717] swapper/-1       0d..3 63431941us : soft_cursor <-bit_cursor
[  125.324717] swapper/-1       0d..3 63431942us : fb_get_buffer_offset <-s=
oft_cursor
[  125.324717] swapper/-1       0d..3 63431942us : fb_pad_aligned_buffer <-=
soft_cursor
[  125.324717] swapper/-1       0d..3 63431943us : cirrus_imageblit <-soft_=
cursor
[  125.324717] swapper/-1       0d..3 63431943us : sys_imageblit <-cirrus_i=
mageblit
[  125.324717] swapper/-1       0d..3 63431944us : cirrus_dirty_update <-ci=
rrus_imageblit
[  125.324717] swapper/-1       0d..3 63431945us : _raw_spin_lock_irqsave <=
-cirrus_dirty_update
[  125.324717] swapper/-1       0d..4 63431945us : do_raw_spin_trylock <-_r=
aw_spin_lock_irqsave
[  125.324717] swapper/-1       0d..4 63431945us : _raw_spin_unlock_irqrest=
ore <-cirrus_dirty_update
[  125.324717] swapper/-1       0d..4 63431946us : do_raw_spin_unlock <-_ra=
w_spin_unlock_irqrestore
[  125.324717] swapper/-1       0d..3 63431946us : notify_update <-vt_conso=
le_print
[  125.324717] swapper/-1       0d..3 63431947us : atomic_notifier_call_cha=
in <-notify_update
[  125.324717] swapper/-1       0d..3 63431947us : __atomic_notifier_call_c=
hain <-atomic_notifier_call_chain
[  125.324717] swapper/-1       0d..4 63431947us : notifier_call_chain <-__=
atomic_notifier_call_chain
[  125.324717] swapper/-1       0d..4 63431947us : vt_notifier_call <-notif=
ier_call_chain
[  125.324717] swapper/-1       0d..4 63431948us : _raw_spin_trylock <-vt_n=
otifier_call
[  125.324717] swapper/-1       0d..5 63431948us : do_raw_spin_trylock <-_r=
aw_spin_trylock
[  125.324717] swapper/-1       0d..5 63431949us : speakup_date <-vt_notifi=
er_call
[  125.324717] swapper/-1       0d..5 63431949us : _raw_spin_unlock_irqrest=
ore <-vt_notifier_call
[  125.324717] swapper/-1       0d..5 63431949us : do_raw_spin_unlock <-_ra=
w_spin_unlock_irqrestore
[  125.324717] swapper/-1       0d..3 63431950us : _raw_spin_unlock <-vt_co=
nsole_print
[  125.324717] swapper/-1       0d..3 63431950us : do_raw_spin_unlock <-_ra=
w_spin_unlock
[  125.324717] swapper/-1       0d..2 63431951us : serial8250_console_write=
 <-call_console_drivers
[  125.324717] swapper/-1       0d..2 63431951us : touch_nmi_watchdog <-ser=
ial8250_console_write
[  125.324717] swapper/-1       0d..2 63431952us : _raw_spin_lock_irqsave <=
-serial8250_console_write
[  125.324717] swapper/-1       0d..3 63431952us : do_raw_spin_trylock <-_r=
aw_spin_lock_irqsave
[  125.324717] swapper/-1       0d..3 63431953us : io_serial_in <-serial825=
0_console_write
[  125.324717] swapper/-1       0d..3 63431974us : io_serial_out <-serial82=
50_console_write
[  125.324717] swapper/-1       0d..3 63431983us : uart_console_write <-ser=
ial8250_console_write
[  125.324717] swapper/-1       0d..3 63431983us : serial8250_console_putch=
ar <-uart_console_write
[  125.324717] swapper/-1       0d..3 63431984us : wait_for_xmitr <-serial8=
250_console_putchar
[  125.324717] swapper/-1       0d..3 63431984us : io_serial_in <-wait_for_=
xmitr
[  125.324717] swapper/-1       0d..3 63431990us : io_serial_out <-serial82=
50_console_putchar
[  125.324717] swapper/-1       0d..3 63432009us : serial8250_console_putch=
ar <-uart_console_write
[  125.324717] swapper/-1       0d..3 63432010us : wait_for_xmitr <-serial8=
250_console_putchar
[  125.324717] swapper/-1       0d..3 63432010us : io_serial_in <-wait_for_=
xmitr
[  125.324717] swapper/-1       0d..3 63432016us : io_serial_out <-serial82=
50_console_putchar
[  125.324717] swapper/-1       0d..3 63432022us : serial8250_console_putch=
ar <-uart_console_write
[  125.324717] swapper/-1       0d..3 63432023us : wait_for_xmitr <-serial8=
250_console_putchar
[  125.324717] swapper/-1       0d..3 63432023us : io_serial_in <-wait_for_=
xmitr
[  125.324717] swapper/-1       0d..3 63432028us : io_serial_out <-serial82=
50_console_putchar
[  125.324717] swapper/-1       0d..3 63432035us : serial8250_console_putch=
ar <-uart_console_write
[  125.324717] swapper/-1       0d..3 63432035us : wait_for_xmitr <-serial8=
250_console_putchar
[  125.324717] swapper/-1       0d..3 63432035us : io_serial_in <-wait_for_=
xmitr
[  125.324717] swapper/-1       0d..3 63432041us : io_serial_out <-serial82=
50_console_putchar
[  125.324717] swapper/-1       0d..3 63432047us : wait_for_xmitr <-serial8=
250_console_write
[  125.324717] swapper/-1       0d..3 63432048us : io_serial_in <-wait_for_=
xmitr
[  125.324717] swapper/-1       0d..3 63432053us : io_serial_out <-serial82=
50_console_write
[  125.324717] swapper/-1       0d..3 63432057us : _raw_spin_unlock_irqrest=
ore <-serial8250_console_write
[  125.324717] swapper/-1       0d..3 63432058us : do_raw_spin_unlock <-_ra=
w_spin_unlock_irqrestore
[  125.324717] swapper/-1       0d..2 63432060us : smp_apic_timer_interrupt=
 <-apic_timer_interrupt
[  125.324717] swapper/-1       0d..2 63432061us : kvm_guest_apic_eoi_write=
 <-smp_apic_timer_interrupt
[  125.324717] swapper/-1       0d..2 63432061us : irq_enter <-smp_apic_tim=
er_interrupt
[  125.324717] swapper/-1       0d..2 63432062us : rcu_irq_enter <-irq_enter
[  125.324717] swapper/-1       0d.h2 63432062us : local_apic_timer_interru=
pt <-smp_apic_timer_interrupt
[  125.324717] swapper/-1       0d.h2 63432063us : hrtimer_interrupt <-loca=
l_apic_timer_interrupt
[  125.324717] swapper/-1       0d.h2 63432063us : _raw_spin_lock <-hrtimer=
_interrupt
[  125.324717] swapper/-1       0d.h3 63432064us : do_raw_spin_trylock <-_r=
aw_spin_lock
[  125.324717] swapper/-1       0d.h3 63432064us : ktime_get_update_offsets=
_now <-hrtimer_interrupt
[  125.324717] swapper/-1       0d.h3 63432065us : __run_hrtimer <-hrtimer_=
interrupt
[  125.324717] swapper/-1       0d.h3 63432065us : __remove_hrtimer <-__run=
_hrtimer
[  125.324717] swapper/-1       0d.h3 63432066us : _raw_spin_unlock <-__run=
_hrtimer
[  125.324717] swapper/-1       0d.h3 63432066us : do_raw_spin_unlock <-_ra=
w_spin_unlock
[  125.324717] swapper/-1       0d.h2 63432067us : tick_sched_timer <-__run=
_hrtimer
[  125.324717] swapper/-1       0d.h2 63432067us : ktime_get <-tick_sched_t=
imer
[  125.324717] swapper/-1       0d.h2 63432083us : _raw_spin_lock <-tick_sc=
hed_timer
[  125.324717] swapper/-1       0d.h3 63432083us : do_raw_spin_trylock <-_r=
aw_spin_lock
[  125.324717] swapper/-1       0d.h3 63432084us : do_timer <-tick_sched_ti=
mer
[  125.324717] swapper/-1       0d.h3 63432084us : calc_global_load <-do_ti=
mer
[  125.324717] swapper/-1       0d.h3 63432085us : _raw_spin_unlock <-tick_=
sched_timer
[  125.324717] swapper/-1       0d.h3 63432085us : do_raw_spin_unlock <-_ra=
w_spin_unlock
[  125.324717] swapper/-1       0d.h2 63432086us : update_wall_time <-tick_=
sched_timer
[  125.324717] swapper/-1       0d.h2 63432086us : _raw_spin_lock_irqsave <=
-update_wall_time
[  125.324717] swapper/-1       0d.h3 63432086us : do_raw_spin_trylock <-_r=
aw_spin_lock_irqsave
[  125.324717] swapper/-1       0d.h3 63432087us : ntp_tick_length <-update=
_wall_time
[  125.324717] swapper/-1       0d.h3 63432088us : ntp_tick_length <-update=
_wall_time
[  125.324717] swapper/-1       0d.h3 63432088us : ntp_tick_length <-update=
_wall_time
[  125.324717] swapper/-1       0d.h3 63432089us : timekeeping_update <-upd=
ate_wall_time
[  125.324717] swapper/-1       0d.h3 63432089us : update_vsyscall <-timeke=
eping_update
[  125.324717] swapper/-1       0d.h3 63432090us : raw_notifier_call_chain =
<-timekeeping_update
[  125.324717] swapper/-1       0d.h3 63432090us : notifier_call_chain <-ra=
w_notifier_call_chain
[  125.324717] swapper/-1       0d.h3 63432090us : _raw_spin_unlock_irqrest=
ore <-update_wall_time
[  125.324717] swapper/-1       0d.h3 63432091us : do_raw_spin_unlock <-_ra=
w_spin_unlock_irqrestore
[  125.324717] swapper/-1       0d.h2 63432091us : update_process_times <-t=
ick_sched_timer
[  125.324717] swapper/-1       0d.h2 63432092us : account_process_tick <-u=
pdate_process_times
[  125.324717] swapper/-1       0d.h2 63432092us : kvm_steal_clock <-accoun=
t_process_tick
[  125.324717] swapper/-1       0d.h2 63432093us : nsecs_to_jiffies <-accou=
nt_process_tick
[  125.324717] swapper/-1       0d.h2 63432093us : nsecs_to_jiffies64 <-nse=
cs_to_jiffies
[  125.324717] swapper/-1       0d.h2 63432094us : jiffies_to_usecs <-accou=
nt_process_tick
[  125.324717] swapper/-1       0d.h2 63432094us : account_steal_time <-acc=
ount_process_tick
[  125.324717] swapper/-1       0d.h2 63432095us : account_system_time <-ac=
count_process_tick
[  125.324717] swapper/-1       0d.h2 63432095us : run_local_timers <-updat=
e_process_times
[  125.324717] swapper/-1       0d.h2 63432095us : hrtimer_run_queues <-run=
_local_timers
[  125.324717] swapper/-1       0d.h2 63432096us : raise_softirq <-run_loca=
l_timers
[  125.324717] swapper/-1       0d.h2 63432096us : __raise_softirq_irqoff <=
-raise_softirq
[  125.324717] swapper/-1       0d.h2 63432097us : rcu_check_callbacks <-up=
date_process_times
[  125.324717] swapper/-1       0d.h2 63432097us : rcu_bh_qs <-rcu_check_ca=
llbacks
[  125.324717] swapper/-1       0d.h2 63432098us : cpu_needs_another_gp <-r=
cu_check_callbacks
[  125.324717] swapper/-1       0d.h2 63432098us : cpu_needs_another_gp <-r=
cu_check_callbacks
[  125.324717] swapper/-1       0d.h2 63432099us : scheduler_tick <-update_=
process_times
[  125.324717] swapper/-1       0d.h2 63432099us : ktime_get <-sched_clock_=
tick
[  125.324717] swapper/-1       0d.h2 63432100us : _raw_spin_lock <-schedul=
er_tick
[  125.324717] swapper/-1       0d.h3 63432101us : do_raw_spin_trylock <-_r=
aw_spin_lock
[  125.324717] swapper/-1       0d.h3 63432101us : update_rq_clock <-schedu=
ler_tick
[  125.324717] swapper/-1       0d.h3 63432102us : task_tick_fair <-schedul=
er_tick
[  125.324717] swapper/-1       0d.h3 63432102us : update_curr <-task_tick_=
fair
[  125.324717] swapper/-1       0d.h3 63432103us : update_min_vruntime <-up=
date_curr
[  125.324717] swapper/-1       0d.h3 63432103us : __compute_runnable_contr=
ib <-task_tick_fair
[  125.324717] swapper/-1       0d.h3 63432104us : __update_entity_load_avg=
_contrib <-task_tick_fair
[  125.324717] swapper/-1       0d.h3 63432104us : update_cfs_rq_blocked_lo=
ad <-task_tick_fair
[  125.324717] swapper/-1       0d.h3 63432105us : update_cfs_shares <-task=
_tick_fair
[  125.324717] swapper/-1       0d.h3 63432105us : __compute_runnable_contr=
ib <-task_tick_fair
[  125.324717] swapper/-1       0d.h3 63432105us : update_cpu_load_active <=
-scheduler_tick
[  125.324717] swapper/-1       0d.h3 63432106us : sched_avg_update <-updat=
e_cpu_load_active
[  125.324717] swapper/-1       0d.h3 63432106us : _raw_spin_unlock <-sched=
uler_tick
[  125.324717] swapper/-1       0d.h3 63432107us : do_raw_spin_unlock <-_ra=
w_spin_unlock
[  125.324717] swapper/-1       0d.h2 63432107us : idle_cpu <-scheduler_tick
[  125.324717] swapper/-1       0d.h2 63432108us : trigger_load_balance <-s=
cheduler_tick
[  125.324717] swapper/-1       0d.h2 63432108us : run_posix_cpu_timers <-u=
pdate_process_times
[  125.324717] swapper/-1       0d.h2 63432109us : profile_tick <-tick_sche=
d_timer
[  125.324717] swapper/-1       0d.h2 63432109us : hrtimer_forward <-tick_s=
ched_timer
[  125.324717] swapper/-1       0d.h2 63432110us : ktime_add_safe <-hrtimer=
_forward
[  125.324717] swapper/-1       0d.h2 63432110us : ktime_add_safe <-hrtimer=
_forward
[  125.324717] swapper/-1       0d.h2 63432110us : _raw_spin_lock <-__run_h=
rtimer
[  125.324717] swapper/-1       0d.h3 63432111us : do_raw_spin_trylock <-_r=
aw_spin_lock
[  125.324717] swapper/-1       0d.h3 63432111us : enqueue_hrtimer <-__run_=
hrtimer
[  125.324717] swapper/-1       0d.h3 63432112us : _raw_spin_unlock <-hrtim=
er_interrupt
[  125.324717] swapper/-1       0d.h3 63432112us : do_raw_spin_unlock <-_ra=
w_spin_unlock
[  125.324717] swapper/-1       0d.h2 63432113us : tick_program_event <-hrt=
imer_interrupt
[  125.324717] swapper/-1       0d.h2 63432113us : clockevents_program_even=
t <-tick_program_event
[  125.324717] swapper/-1       0d.h2 63432114us : ktime_get <-clockevents_=
program_event
[  125.324717] swapper/-1       0d.h2 63432114us : lapic_next_event <-clock=
events_program_event
[  125.324717] swapper/-1       0d.h2 63432120us : irq_exit <-smp_apic_time=
r_interrupt
[  125.324717] swapper/-1       0d..2 63432121us : do_softirq_own_stack <-i=
rq_exit
[  125.324717] swapper/-1       0d..2 63432121us : __do_softirq <-do_softir=
q_own_stack
[  125.324717] swapper/-1       0d..2 63432122us : msecs_to_jiffies <-__do_=
softirq
[  125.324717] swapper/-1       0d..2 63432122us : __local_bh_disable_ip <-=
__do_softirq
[  125.324717] swapper/-1       0..s2 63432123us : run_timer_softirq <-__do=
_softirq
[  125.324717] swapper/-1       0..s2 63432123us : hrtimer_run_pending <-ru=
n_timer_softirq
[  125.324717] swapper/-1       0..s2 63432124us : _raw_spin_lock_irq <-run=
_timer_softirq
[  125.324717] swapper/-1       0d.s3 63432124us : do_raw_spin_trylock <-_r=
aw_spin_lock_irq
[  125.324717] swapper/-1       0d.s3 63432124us : _raw_spin_unlock_irq <-r=
un_timer_softirq
[  125.324717] swapper/-1       0d.s3 63432125us : do_raw_spin_unlock <-_ra=
w_spin_unlock_irq
[  125.324717] swapper/-1       0..s2 63432125us : rcu_bh_qs <-__do_softirq
[  125.324717] swapper/-1       0d.s2 63432126us : __local_bh_enable <-__do=
_softirq
[  125.324717] swapper/-1       0d..2 63432126us : rcu_irq_exit <-irq_exit
[  125.324717] swapper/-1       0...2 63432127us : _raw_spin_lock_irqsave <=
-console_unlock
[  125.324717] swapper/-1       0d..3 63432127us : do_raw_spin_trylock <-_r=
aw_spin_lock_irqsave
[  125.324717] swapper/-1       0d..3 63432128us : log_from_idx <-console_u=
nlock
[  125.324717] swapper/-1       0d..3 63432128us : log_next <-console_unlock
[  125.324717] swapper/-1       0d..3 63432129us : _raw_spin_unlock <-conso=
le_unlock
[  125.324717] swapper/-1       0d..3 63432129us : do_raw_spin_unlock <-_ra=
w_spin_unlock
[  125.324717] swapper/-1       0d..2 63432130us : up <-console_unlock
[  125.324717] swapper/-1       0d..2 63432130us : _raw_spin_lock_irqsave <=
-up
[  125.324717] swapper/-1       0d..3 63432130us : do_raw_spin_trylock <-_r=
aw_spin_lock_irqsave
[  125.324717] swapper/-1       0d..3 63432131us : _raw_spin_unlock_irqrest=
ore <-up
[  125.324717] swapper/-1       0d..3 63432131us : do_raw_spin_unlock <-_ra=
w_spin_unlock_irqrestore
[  125.324717] swapper/-1       0d..2 63432132us : _raw_spin_lock <-console=
_unlock
[  125.324717] swapper/-1       0d..3 63432132us : do_raw_spin_trylock <-_r=
aw_spin_lock
[  125.324717] swapper/-1       0d..3 63432132us : _raw_spin_unlock_irqrest=
ore <-console_unlock
[  125.324717] swapper/-1       0d..3 63432133us : do_raw_spin_unlock <-_ra=
w_spin_unlock_irqrestore
[  125.324717] swapper/-1       0...2 63432133us : wake_up_klogd <-console_=
unlock
[  125.324717] swapper/-1       0...1 63432134us : mutex_lock_nested <-unre=
gister_ftrace_function
[  125.324717] swapper/-1       0...1 63432134us : __might_sleep <-mutex_lo=
ck_nested
[  125.324717] swapper/-1       0...1 63432135us : _cond_resched <-mutex_lo=
ck_nested
[  125.324717] ---------------------------------
[  187.060106] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  187.068476] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  187.072041] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  187.075717] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  187.079654] ??? Writer stall state 8 g4722 c4722 f0x0
[  187.082797] rcu_sched: wait state: 1 ->state: 0x1
[  187.086045] rcu_bh: wait state: 1 ->state: 0x1
[  247.088054] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  247.095358] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  247.097933] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  247.100823] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  247.104652] ??? Writer stall state 8 g4722 c4722 f0x0
[  247.107894] rcu_sched: wait state: 1 ->state: 0x1
[  247.111131] rcu_bh: wait state: 1 ->state: 0x1
[  307.112081] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  307.118333] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  307.121226] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  307.123908] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  307.126903] ??? Writer stall state 8 g4722 c4722 f0x0
[  307.129564] rcu_sched: wait state: 1 ->state: 0x1
[  307.132169] rcu_bh: wait state: 1 ->state: 0x1
[  367.136055] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  367.146491] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  367.150962] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  367.157202] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  367.162692] ??? Writer stall state 8 g4726 c4726 f0x0
[  367.166644] rcu_sched: wait state: 1 ->state: 0x1
[  367.172189] rcu_bh: wait state: 1 ->state: 0x1
[  427.176110] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  427.185423] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  427.190218] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  427.196403] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  427.200948] ??? Writer stall state 8 g4726 c4726 f0x0
[  427.204845] rcu_sched: wait state: 1 ->state: 0x1
[  427.208730] rcu_bh: wait state: 1 ->state: 0x1
[  487.212085] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  487.222200] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  487.226971] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  487.231682] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  487.236502] ??? Writer stall state 8 g4726 c4726 f0x0
[  487.240752] rcu_sched: wait state: 1 ->state: 0x1
[  487.244977] rcu_bh: wait state: 1 ->state: 0x1
[  547.252045] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  547.261827] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  547.266499] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  547.271123] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  547.275879] ??? Writer stall state 8 g4726 c4726 f0x0
[  547.280033] rcu_sched: wait state: 1 ->state: 0x1
[  547.284205] rcu_bh: wait state: 1 ->state: 0x1
[  607.284918] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  607.295088] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  607.299847] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  607.304487] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  607.309282] ??? Writer stall state 8 g4726 c4726 f0x0
[  607.313460] rcu_sched: wait state: 1 ->state: 0x1
[  607.317667] rcu_bh: wait state: 1 ->state: 0x1
[  667.320068] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  667.329475] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  667.333852] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  667.338232] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  667.342662] ??? Writer stall state 8 g4726 c4726 f0x0
[  667.346614] rcu_sched: wait state: 1 ->state: 0x1
[  667.350504] rcu_bh: wait state: 1 ->state: 0x1
[  727.352049] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  727.361559] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  727.365918] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  727.370278] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  727.374717] ??? Writer stall state 8 g4726 c4726 f0x0
[  727.378665] rcu_sched: wait state: 1 ->state: 0x1
[  727.382552] rcu_bh: wait state: 1 ->state: 0x1
[  787.384049] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  787.392540] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  787.397114] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  787.401630] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  787.406235] ??? Writer stall state 8 g4726 c4726 f0x0
[  787.410326] rcu_sched: wait state: 1 ->state: 0x1
[  787.413386] rcu_bh: wait state: 1 ->state: 0x1
[  847.416068] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  847.422370] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  847.425378] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  847.428571] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  847.431963] ??? Writer stall state 8 g4726 c4726 f0x0
[  847.435005] rcu_sched: wait state: 1 ->state: 0x1
[  847.437707] rcu_bh: wait state: 1 ->state: 0x1
[  907.440040] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  907.446532] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  907.449418] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  907.452380] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  907.455333] ??? Writer stall state 8 g4726 c4726 f0x0
[  907.457946] rcu_sched: wait state: 1 ->state: 0x1
[  907.460533] rcu_bh: wait state: 1 ->state: 0x1
[  967.460073] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[  967.470975] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[  967.477720] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[  967.482706] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  967.487414] ??? Writer stall state 8 g4726 c4726 f0x0
[  967.491582] rcu_sched: wait state: 1 ->state: 0x1
[  967.495460] rcu_bh: wait state: 1 ->state: 0x1
[ 1027.496080] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1027.506706] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1027.511718] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1027.516531] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1027.521526] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1027.525830] rcu_sched: wait state: 1 ->state: 0x1
[ 1027.530151] rcu_bh: wait state: 1 ->state: 0x1
[ 1087.532066] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1087.542253] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1087.547062] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1087.551764] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1087.556631] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1087.560942] rcu_sched: wait state: 1 ->state: 0x1
[ 1087.565209] rcu_bh: wait state: 1 ->state: 0x1
[ 1147.568045] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1147.577601] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1147.582030] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1147.586439] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1147.590948] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1147.594940] rcu_sched: wait state: 1 ->state: 0x1
[ 1147.598901] rcu_bh: wait state: 1 ->state: 0x1
[ 1207.600071] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1207.607759] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1207.610906] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1207.613920] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1207.617302] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1207.620383] rcu_sched: wait state: 1 ->state: 0x1
[ 1207.623586] rcu_bh: wait state: 1 ->state: 0x1
[ 1267.624044] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1267.631902] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1267.635240] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1267.640162] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1267.645480] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1267.649256] rcu_sched: wait state: 1 ->state: 0x1
[ 1267.652699] rcu_bh: wait state: 1 ->state: 0x1
[ 1327.652070] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1327.659862] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1327.664299] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1327.668771] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1327.673290] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1327.677327] rcu_sched: wait state: 1 ->state: 0x1
[ 1327.681337] rcu_bh: wait state: 1 ->state: 0x1
[ 1387.684076] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1387.690869] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1387.693788] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1387.698084] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1387.701230] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1387.703849] rcu_sched: wait state: 1 ->state: 0x1
[ 1387.706548] rcu_bh: wait state: 1 ->state: 0x1
[ 1447.712036] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1447.721897] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1447.726465] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1447.731086] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1447.735870] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1447.740138] rcu_sched: wait state: 1 ->state: 0x1
[ 1447.744334] rcu_bh: wait state: 1 ->state: 0x1
[ 1507.748075] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1507.754227] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1507.758388] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1507.761510] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1507.765405] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1507.769042] rcu_sched: wait state: 1 ->state: 0x1
[ 1507.772717] rcu_bh: wait state: 1 ->state: 0x1
[ 1567.772077] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1567.782368] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1567.787010] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1567.791491] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1567.797769] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1567.803318] rcu_sched: wait state: 1 ->state: 0x1
[ 1567.808331] rcu_bh: wait state: 1 ->state: 0x1
[ 1627.812066] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1627.822956] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1627.828712] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1627.835089] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1627.841095] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1627.845634] rcu_sched: wait state: 1 ->state: 0x1
[ 1627.850029] rcu_bh: wait state: 1 ->state: 0x1
[ 1687.852046] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1687.860990] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1687.865168] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1687.869354] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1687.873739] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1687.877628] rcu_sched: wait state: 1 ->state: 0x1
[ 1687.881390] rcu_bh: wait state: 1 ->state: 0x1
[ 1747.884083] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1747.893152] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1747.897533] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1747.901854] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1747.906280] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1747.910218] rcu_sched: wait state: 1 ->state: 0x1
[ 1747.914188] rcu_bh: wait state: 1 ->state: 0x1
[ 1807.920044] rcu-torture: rtc: c2c58b30 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,=
0 0:0 (HZ=3D250) barrier: 0/0:0 cbflood: 1
[ 1807.929306] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[ 1807.933765] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[ 1807.938189] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1807.942772] ??? Writer stall state 8 g4726 c4726 f0x0
[ 1807.946864] rcu_sched: wait state: 1 ->state: 0x1
[ 1807.950864] rcu_bh: wait state: 1 ->state: 0x1

BUG: kernel boot hang
Elapsed time: 1810
qemu-system-i386 -enable-kvm -kernel /kernel/i386-randconfig-ha2-1109/05da5=
898a96c05e32aa9850c9cd89eef29471b13/vmlinuz-3.18.0-rc2-g05da589 -append 'us=
er=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yocto-i386-62/rand_boot-1-yocto-min=
imal-i386.cgz-i386-randconfig-ha2-1109-05da5898a96c05e32aa9850c9cd89eef2947=
1b13-1.yaml ARCH=3Di386 BOOT_IMAGE=3D/kernel/i386-randconfig-ha2-1109/05da5=
898a96c05e32aa9850c9cd89eef29471b13/vmlinuz-3.18.0-rc2-g05da589 kconfig=3Di=
386-randconfig-ha2-1109 commit=3D05da5898a96c05e32aa9850c9cd89eef29471b13 b=
ranch=3Dpshelar-openvswitch/net_next_ovs root=3D/dev/ram0 max_uptime=3D3600=
 RESULT_ROOT=3D/result/vm-kbuild-yocto-i386/boot/1/yocto-minimal-i386.cgz/i=
386-randconfig-ha2-1109/05da5898a96c05e32aa9850c9cd89eef29471b13/0 ip=3D:::=
:vm-kbuild-yocto-i386-62::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebu=
g sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 soft=
lockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_=
ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.mino=
r_count=3D8'  -initrd /fs/sde1/initrd-vm-kbuild-yocto-i386-62 -m 320 -smp 2=
 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-re=
boot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/sde1/disk0-=
vm-kbuild-yocto-i386-62,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pi=
d-vm-kbuild-yocto-i386-62 -serial file:/dev/shm/kboot/serial-vm-kbuild-yoct=
o-i386-62 -daemonize -display none -monitor null=20

--KDt/GgjP6HVcx58l--
