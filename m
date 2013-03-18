Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3CRNw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:52:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:41290 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab3CRNwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:52:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,865,1355126400"; 
   d="log'?scan'208";a="304486301"
Date: Mon, 18 Mar 2013 21:52:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Arnd Bergmann <arnd@arndb.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [rttest] WARNING: at drivers/base/core.c:569 device_create_file()
Message-ID: <20130318135234.GA31564@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 8f46baaa7ec6cd0851794020b31958e64679dd26
Author: Felipe Balbi <balbi@ti.com>
Date:   Wed Feb 20 10:31:42 2013 +0200

    base: core: WARN() about bogus permissions on device attributes
    
    Whenever a struct device_attribute is registered
    with mismatched permissions - read permission without
    a show routine or write permission without store
    routine - we will issue a big warning so we catch
    those early enough.
    
    Signed-off-by: Felipe Balbi <balbi@ti.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Judging from the dmesg, CC the rttest developers for possible fixes.

[   11.581068] bus: 'rttest': add device rttest0
[   11.581813] ------------[ cut here ]------------
[   11.582568] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:569 device_create_file+0x5a/0xa0()
[   11.584035] Write permission without 'store'
[   11.584793] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc2-next-20130318 #21
[   11.585902] Call Trace:
[   11.586318]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.587146]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.587982]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.588820]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.589618]  [<8151b77a>] device_create_file+0x5a/0xa0
[   11.590523]  [<81081faa>] init_rttest+0xaa/0x150
[   11.591255]  [<81082270>] ? handle_op+0x220/0x220
[   11.591994]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.592838]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.593642]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.594492]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.595291]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.596026]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.596990]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.597749] ---[ end trace 124d60cbc476f331 ]---

git bisect start 0e78c0989334e9c1d578ba25621de14e8441d8b4 08637024ab77f7defff1627cc8aedc2c6679ad8a --
git bisect good 5b4ab7cbdf1c0d93f5e7e14671c8b34ff081b928  #    10  2013-03-18 18:56:02  Merge remote-tracking branch 'slab/for-next'
git bisect  bad a9dd67e06c062671c880f62087a6fe6d4096ec39  #     0  2013-03-18 19:00:10  Revert "gpio/palmas: add in GPIO support for palmas charger"
git bisect good e8196b632b87f568668394fdc8b5053aa7918885  #    10  2013-03-18 19:05:59  Merge remote-tracking branch 'regmap/for-next'
git bisect good 157dfaac1f2922a3cbd90685339511cb97cad225  #    10  2013-03-18 19:12:52  staging: dwc2: fix compiler warnings
git bisect good a14592896023adcab12307774c89284ce0744ce2  #    10  2013-03-18 19:17:44  staging: comedi: ni_labpc: fix common detach
git bisect  bad 9b53d29f3c8d2b9bfe73eb1dfb78a53b8c0fa2d7  #     0  2013-03-18 19:21:54  Merge remote-tracking branch 'usb/usb-next'
git bisect  bad 50418d050eaa3998e4be2936f5f05718909122ee  #     0  2013-03-18 19:24:22  Merge remote-tracking branch 'tty/tty-next'
git bisect good d9a9770f7baea6171aa66e4070bdb9bf6f0402f3  #    10  2013-03-18 19:30:13  Merge remote-tracking branch 'leds/for-next'
git bisect good 20cc225bab6709408840e4400cd1a5c2b28c7a52  #    10  2013-03-18 19:37:15  tty: Fix spinlock flavor in non-atomic __tty_hangup()
git bisect good afa80ccb4c7d39702dfb0832ce02a054848191a8  #    10  2013-03-18 19:43:40  sysrq: fix inconstistent help message of sysrq key
git bisect  bad 8f46baaa7ec6cd0851794020b31958e64679dd26  #     0  2013-03-18 19:48:42  base: core: WARN() about bogus permissions on device attributes
git bisect good be871b7e54711479d3b9d3617d49898770830db2  #    10  2013-03-18 19:54:14  device: separate all subsys mutexes
git bisect good be871b7e54711479d3b9d3617d49898770830db2  #    30  2013-03-18 20:01:22  device: separate all subsys mutexes
git bisect  bad 0e78c0989334e9c1d578ba25621de14e8441d8b4  #     0  2013-03-18 20:06:35  Add linux-next specific files for 20130318
git bisect good 3154d2d99b2718f54136409fc3836a90e896eedc  #    30  2013-03-18 20:16:20  Revert "base: core: WARN() about bogus permissions on device attributes"
git bisect  bad 0e78c0989334e9c1d578ba25621de14e8441d8b4  #     0  2013-03-18 20:20:59  Add linux-next specific files for 20130318

Thanks,
Fengguang

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bens-3423-2013-03-18-15-18-58-3.9.0-rc2-next-20130318-21"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc2-next-20130318 (kbuild@inn) (gcc vers=
ion 4.7.1 (Debian 4.7.1-6) ) #21 SMP Mon Mar 18 15:09:37 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI:  , BIOS =20
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[800fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x031fffff]
[    0.000000] Base memory trampoline at [8008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0e5fffff]
[    0.000000]  [mem 0x0e400000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e3fffff]
[    0.000000]  [mem 0x0c000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0fffdfff]
[    0.000000]  [mem 0x0e600000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02831000, 0x02831fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128628(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL=
 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fffd000-0x0fffdfff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000] max_low_pfn =3D fffe, highstart_pfn =3D fffe
[    0.000000] Low memory ends at vaddr 8fffe000
[    0.000000] High memory starts at vaddr 8fffe000
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] BRK [0x02832000, 0x02832fff] PGTABLE
[    0.000000] Node: 0, start_pfn: 1, end_pfn: 93
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   1=20
[    0.000000] Node: 0, start_pfn: 100, end_pfn: fffe
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   100 4100 8100 c100=20
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000] free_area_init_node: node 0, pgdat 8fffd000, node_mem_map 8d=
d3f020
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65424 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @8dd29000 s32328 r0 d12728 u45=
056
[    0.000000] pcpu-alloc: s32328 r0 d12728 u45056 alloc=3D11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64912
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 branch=3Dnext/master log_buf_len=3D8M ignore_loglevel debu=
g sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10  =
prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3Dvmlinuz-2013-03-18-15-14-12-next:master:0e78c0989334=
e9c1d578ba25621de14e8441d8b4-0e78c0989334e9c1d578ba25621de14e8441d8b4-i386-=
randconfig-i000-0316-8-bens BOOT_IMAGE=3D/kernel/i386-randconfig-i000-0316/=
0e78c0989334e9c1d578ba25621de14e8441d8b4/vmlinuz-3.9.0-rc2-next-20130318
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 200996k/262136k available (12981k kernel code, 60700=
k reserved, 5413k data, 636k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff9fe000   (1778 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x821f7000 - 0x82296000   ( 636 kB)
[    0.000000]       .data : 0x81cad5aa - 0x821f69c0   (5413 kB)
[    0.000000]       .text : 0x81000000 - 0x81cad5aa   (12981 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D80088000 soft=3D8008a000
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 2666.615 MHz processor
[    0.050004] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5333.23 BogoMIPS (lpj=3D26666150)
[    0.060492] pid_max: default: 32768 minimum: 301
[    0.061394] Mount-cache hash table entries: 512
[    0.062782] Initializing cgroup subsys debug
[    0.063495] Initializing cgroup subsys devices
[    0.064225] Initializing cgroup subsys freezer
[    0.070060] Initializing cgroup subsys net_cls
[    0.070933] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.070933] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.070933] tlb_flushall_shift: 6
[    0.088891] Freeing SMP alternatives: 40k freed
[    0.089719] ACPI: Core revision 20130117
[    0.093914] ACPI: All ACPI Tables successfully acquired
[    0.095025] Getting VERSION: 50014
[    0.095617] Getting VERSION: 50014
[    0.096193] Getting ID: 0
[    0.096634] Getting ID: f000000
[    0.097165] Getting LVT0: 8700
[    0.097669] Getting LVT1: 8400
[    0.098177] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.100220] enabled ExtINT on CPU#0
[    0.102250] ENABLING IO-APIC IRQs
[    0.102895] init IO_APIC IRQs
[    0.103391]  apic 2 pin 0 not connected
[    0.104041] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.105483] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.106766] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.108164] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.110043] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.111346] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.112624] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.113895] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.120037] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.130005] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.131298] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.132597] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.140046] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.141349] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.142674] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.144006]  apic 2 pin 16 not connected
[    0.144641]  apic 2 pin 17 not connected
[    0.145273]  apic 2 pin 18 not connected
[    0.145911]  apic 2 pin 19 not connected
[    0.150014]  apic 2 pin 20 not connected
[    0.150657]  apic 2 pin 21 not connected
[    0.151296]  apic 2 pin 22 not connected
[    0.151928]  apic 2 pin 23 not connected
[    0.152740] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.322017] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.324889] Using local APIC timer interrupts.
[    0.324889] calibrating APIC timer ...
[    0.340000] ... lapic delta =3D 6173168
[    0.340000] ... PM-Timer delta =3D 353541
[    0.340000] APIC calibration not consistent with PM-Timer: 98ms instead =
of 100ms
[    0.340000] APIC delta adjusted to PM-Timer: 6250223 (6173168)
[    0.340000] TSC delta adjusted to PM-Timer: 266666167 (263378600)
[    0.340000] ..... delta 6250223
[    0.340000] ..... mult: 268445033
[    0.340000] ..... calibration result: 10000356
[    0.340000] ..... CPU clock speed is 2666.6616 MHz.
[    0.340000] ..... host bus clock speed is 1000.0356 MHz.
[    0.340181] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.350882] Testing tracer nop: PASSED
[    0.361297] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.363479] SMP alternatives: lockdep: fixing up alternatives
[    0.369220] CPU 1 irqstacks, hard=3D80074000 soft=3D80076000
[    0.370010] smpboot: Booting Node   0, Processors  #1 OK
[    0.060000] Initializing CPU#1
[    0.060000] masked ExtINT on CPU#1
[    0.060000] calibrate_delay_direct() failed to get a good estimate for l=
oops_per_jiffy.
[    0.060000] Probably due to long platform interrupts. Consider using "lp=
j=3D" boot option.
[    0.670186] Brought up 2 CPUs
[    0.670726] smpboot: Total of 2 processors activated (9693.83 BogoMIPS)
[    0.672452] device: 'platform': device_add
[    0.673635] bus: 'platform': registered
[    0.690143] bus: 'cpu': registered
[    0.690700] device: 'cpu': device_add
[    0.693701] bus: 'workqueue': registered
[    0.694343] device: 'workqueue': device_add
[    0.800030] Testing tracer irqsoff: PASSED
[    1.072660] NET: Registered protocol family 16
[    1.074384] device class 'bdi': registering
[    1.075225] device class 'gpio': registering
[    1.075957] device class 'pci_bus': registering
[    1.077199] bus: 'pci': registered
[    1.077764] device: 'rapidio': device_add
[    1.078443] bus: 'rapidio': registered
[    1.079046] device class 'backlight': registering
[    1.079813] device class 'video_output': registering
[    1.080051] device class 'tty': registering
[    1.080798] bus: 'node': registered
[    1.081357] device: 'node': device_add
[    1.086135] bus: 'spi': registered
[    1.086683] device class 'spi_master': registering
[    1.087488] bus: 'hsi': registered
[    1.088074] bus: 'i2c': registered
[    1.090026] bus: 'i2c': add driver dummy
[    1.091790] ACPI: bus type PCI registered
[    1.092447] device class 'dma': registering
[    1.100022] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    1.101181] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    1.102216] PCI: Using configuration type 1 for base access
[    1.110026] device: 'node0': device_add
[    1.110667] bus: 'node': add device node0
[    1.111398] device: 'cpu0': device_add
[    1.120027] bus: 'cpu': add device cpu0
[    1.120724] device: 'cpu1': device_add
[    1.121327] bus: 'cpu': add device cpu1
[    1.160766] device: 'default': device_add
[    1.170359] bio: create slab <bio-0> at 0
[    1.171118] device class 'block': registering
[    1.175750] bus: 'i2c': add driver max7300
[    1.176451] bus: 'i2c': add driver max732x
[    1.177129] bus: 'i2c': add driver pca953x
[    1.177799] bus: 'i2c': add driver pcf857x
[    1.178541] bus: 'platform': add driver rc5t583-gpio
[    1.179350] bus: 'i2c': add driver sx150x
[    1.180023] bus: 'platform': add driver tps6586x-gpio
[    1.180840] bus: 'platform': add driver tps65910-gpio
[    1.181677] bus: 'platform': add driver tps65912-gpio
[    1.190054] bus: 'platform': add driver wm831x-gpio
[    1.190858] bus: 'platform': add driver wm8994-gpio
[    1.191709] device class 'graphics': registering
[    1.192507] ACPI: Added _OSI(Module Device)
[    1.200010] ACPI: Added _OSI(Processor Device)
[    1.200725] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.201657] ACPI: Added _OSI(Processor Aggregator Device)
[    1.204534] ACPI: EC: Look up EC in DSDT
[    1.221666] ACPI: Interpreter enabled
[    1.222300] ACPI: (supports S0 S5)
[    1.222844] ACPI: Using IOAPIC for interrupt routing
[    1.230053] bus: 'acpi': registered
[    1.230638] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    1.232279] device: 'LNXSYSTM:00': device_add
[    1.233022] bus: 'acpi': add device LNXSYSTM:00
[    1.233999] device: 'LNXSYBUS:00': device_add
[    1.234706] bus: 'acpi': add device LNXSYBUS:00
[    1.250301] device: 'PNP0A03:00': device_add
[    1.251011] bus: 'acpi': add device PNP0A03:00
[    1.252816] device: 'device:00': device_add
[    1.253500] bus: 'acpi': add device device:00
[    1.254418] device: 'device:01': device_add
[    1.255110] bus: 'acpi': add device device:01
[    1.255975] device: 'PNP0B00:00': device_add
[    1.256673] bus: 'acpi': add device PNP0B00:00
[    1.257693] device: 'PNP0303:00': device_add
[    1.260030] bus: 'acpi': add device PNP0303:00
[    1.261164] device: 'PNP0F13:00': device_add
[    1.261860] bus: 'acpi': add device PNP0F13:00
[    1.262786] device: 'PNP0700:00': device_add
[    1.263468] bus: 'acpi': add device PNP0700:00
[    1.270465] device: 'PNP0400:00': device_add
[    1.271148] bus: 'acpi': add device PNP0400:00
[    1.272274] device: 'PNP0501:00': device_add
[    1.272967] bus: 'acpi': add device PNP0501:00
[    1.274150] device: 'device:02': device_add
[    1.278928] bus: 'acpi': add device device:02
[    1.279832] device: 'device:03': device_add
[    1.280012] bus: 'acpi': add device device:03
[    1.280873] device: 'device:04': device_add
[    1.281544] bus: 'acpi': add device device:04
[    1.290223] device: 'device:05': device_add
[    1.290906] bus: 'acpi': add device device:05
[    1.291790] device: 'device:06': device_add
[    1.292475] bus: 'acpi': add device device:06
[    1.293517] device: 'device:07': device_add
[    1.298274] bus: 'acpi': add device device:07
[    1.299156] device: 'device:08': device_add
[    1.300013] bus: 'acpi': add device device:08
[    1.300884] device: 'device:09': device_add
[    1.301566] bus: 'acpi': add device device:09
[    1.305874] device: 'device:0a': device_add
[    1.306561] bus: 'acpi': add device device:0a
[    1.307453] device: 'device:0b': device_add
[    1.308133] bus: 'acpi': add device device:0b
[    1.309099] device: 'device:0c': device_add
[    1.310014] bus: 'acpi': add device device:0c
[    1.310890] device: 'device:0d': device_add
[    1.311567] bus: 'acpi': add device device:0d
[    1.312444] device: 'device:0e': device_add
[    1.313115] bus: 'acpi': add device device:0e
[    1.313998] device: 'device:0f': device_add
[    1.320024] bus: 'acpi': add device device:0f
[    1.321155] device: 'device:10': device_add
[    1.321836] bus: 'acpi': add device device:10
[    1.322719] device: 'device:11': device_add
[    1.330026] bus: 'acpi': add device device:11
[    1.330931] device: 'device:12': device_add
[    1.331610] bus: 'acpi': add device device:12
[    1.332497] device: 'device:13': device_add
[    1.333177] bus: 'acpi': add device device:13
[    1.334064] device: 'device:14': device_add
[    1.334738] bus: 'acpi': add device device:14
[    1.335701] device: 'device:15': device_add
[    1.336381] bus: 'acpi': add device device:15
[    1.337251] device: 'device:16': device_add
[    1.340024] bus: 'acpi': add device device:16
[    1.340922] device: 'device:17': device_add
[    1.341594] bus: 'acpi': add device device:17
[    1.342476] device: 'device:18': device_add
[    1.343153] bus: 'acpi': add device device:18
[    1.350353] device: 'device:19': device_add
[    1.351041] bus: 'acpi': add device device:19
[    1.352061] device: 'device:1a': device_add
[    1.352733] bus: 'acpi': add device device:1a
[    1.353615] device: 'device:1b': device_add
[    1.354295] bus: 'acpi': add device device:1b
[    1.355178] device: 'device:1c': device_add
[    1.360012] bus: 'acpi': add device device:1c
[    1.360898] device: 'device:1d': device_add
[    1.361573] bus: 'acpi': add device device:1d
[    1.368798] device: 'device:1e': device_add
[    1.369487] bus: 'acpi': add device device:1e
[    1.370210] device: 'device:1f': device_add
[    1.370886] bus: 'acpi': add device device:1f
[    1.375837] device: 'device:20': device_add
[    1.376535] bus: 'acpi': add device device:20
[    1.377430] device: 'device:21': device_add
[    1.380015] bus: 'acpi': add device device:21
[    1.383310] device: 'PNP0103:00': device_add
[    1.384005] bus: 'acpi': add device PNP0103:00
[    1.385172] device: 'PNP0C0F:00': device_add
[    1.390020] bus: 'acpi': add device PNP0C0F:00
[    1.391253] device: 'PNP0C0F:01': device_add
[    1.391945] bus: 'acpi': add device PNP0C0F:01
[    1.393064] device: 'PNP0C0F:02': device_add
[    1.393753] bus: 'acpi': add device PNP0C0F:02
[    1.400624] device: 'PNP0C0F:03': device_add
[    1.401365] bus: 'acpi': add device PNP0C0F:03
[    1.402468] device: 'PNP0C0F:04': device_add
[    1.403162] bus: 'acpi': add device PNP0C0F:04
[    1.410067] device: 'LNXCPU:00': device_add
[    1.410764] bus: 'acpi': add device LNXCPU:00
[    1.411749] device: 'LNXCPU:01': device_add
[    1.412428] bus: 'acpi': add device LNXCPU:01
[    1.413299] device: 'LNXSYBUS:01': device_add
[    1.413996] bus: 'acpi': add device LNXSYBUS:01
[    1.414923] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.415921] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    1.417175] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    1.420114] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ign=
ored)
[    1.421237] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ign=
ored)
[    1.422363] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bff=
ff] (ignored)
[    1.430005] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfff=
ff] (ignored)
[    1.440019] PCI: root bus 00: using default resources
[    1.440895] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.442873] device: 'pci0000:00': device_add
[    1.443615] device: '0000:00': device_add
[    1.444399] PCI host bridge to bus 0000:00
[    1.445058] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.445931] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.446911] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
fff]
[    1.450018] pci_bus 0000:00: scanning bus
[    1.450829] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.451809] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x10
[    1.460409] device: '0000:00:00.0': device_add
[    1.461402] bus: 'pci': add device 0000:00:00.0
[    1.462394] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.463923] device: '0000:00:01.0': device_add
[    1.464662] bus: 'pci': add device 0000:00:01.0
[    1.465488] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.472145] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    1.473855] device: '0000:00:01.1': device_add
[    1.480302] bus: 'pci': add device 0000:00:01.1
[    1.481282] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.482252] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x40
[    1.483878] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x170
[    1.484847] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.485983] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.487160] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x10
[    1.490060] device: '0000:00:01.3': device_add
[    1.490822] bus: 'pci': add device 0000:00:01.3
[    1.491706] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.500834] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.510068] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    1.530078] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    1.531319] device: '0000:00:02.0': device_add
[    1.532222] bus: 'pci': add device 0000:00:02.0
[    1.533491] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.535180] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    1.536832] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    1.543194] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    1.550099] device: '0000:00:03.0': device_add
[    1.550904] bus: 'pci': add device 0000:00:03.0
[    1.551795] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.553810] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    1.560321] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    1.568982] device: '0000:00:04.0': device_add
[    1.569825] bus: 'pci': add device 0000:00:04.0
[    1.570365] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.572172] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    1.573717] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    1.590595] device: '0000:00:05.0': device_add
[    1.591432] bus: 'pci': add device 0000:00:05.0
[    1.592318] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.595159] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.596689] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    1.601569] device: '0000:00:06.0': device_add
[    1.610110] bus: 'pci': add device 0000:00:06.0
[    1.611130] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.612866] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    1.618478] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    1.630582] device: '0000:00:07.0': device_add
[    1.631413] bus: 'pci': add device 0000:00:07.0
[    1.632416] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.634108] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    1.639815] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    1.652309] device: '0000:00:08.0': device_add
[    1.653162] bus: 'pci': add device 0000:00:08.0
[    1.654170] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.655867] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    1.659437] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    1.667699] device: '0000:00:09.0': device_add
[    1.670139] bus: 'pci': add device 0000:00:09.0
[    1.671089] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.672459] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    1.686319] device: '0000:00:0a.0': device_add
[    1.687153] bus: 'pci': add device 0000:00:0a.0
[    1.688190] pci_bus 0000:00: fixups for bus
[    1.688960] pci_bus 0000:00: bus scan returning with max=3D00
[    1.689864] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.691450] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.698210] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.700449] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.701729] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.703001] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    1.704261] device: 'LNXPWRBN:00': device_add
[    1.704973] bus: 'acpi': add device LNXPWRBN:00
[    1.710332] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.711167] acpi root: \_SB_.PCI0 notify handler is installed
[    1.712188] Found 1 acpi root devices
[    1.712782] bus: 'acpi': add driver ec
[    1.720311] bus: 'pnp': registered
[    1.720885] device class 'misc': registering
[    1.723112] bus: 'tifm': registered
[    1.723675] device class 'tifm_adapter': registering
[    1.724495] bus: 'i2c': add driver 88PM860x
[    1.725193] bus: 'i2c': add driver WM8400
[    1.725873] bus: 'i2c': add driver wm831x
[    1.726560] bus: 'spi': add driver wm831x
[    1.727294] bus: 'i2c': add driver wm8350
[    1.730047] tps65010: version 2 May 2005
[    1.730689] bus: 'i2c': add driver tps65010
[    1.731467] bus: 'i2c': remove driver tps65010
[    1.732200] driver: 'tps65010': driver_release
[    1.750049] bus: 'i2c': add driver tps65010
[    1.750792] bus: 'i2c': remove driver tps65010
[    1.751513] driver: 'tps65010': driver_release
[    1.770030] bus: 'i2c': add driver tps65010
[    1.770792] bus: 'i2c': remove driver tps65010
[    1.771515] driver: 'tps65010': driver_release
[    1.772226] tps65010: no chip?
[    1.772723] bus: 'i2c': add driver tps65910
[    1.773407] bus: 'i2c': add driver tps65912
[    1.774100] bus: 'i2c': add driver tps80031
[    1.774784] bus: 'i2c': add driver twl
[    1.775533] bus: 'spi': add driver mc13xxx
[    1.776206] bus: 'i2c': add driver da903x
[    1.776865] bus: 'spi': add driver da9052
[    1.777524] bus: 'i2c': add driver lp8788
[    1.778290] bus: 'i2c': add driver max77686
[    1.779090] bus: 'i2c': add driver max8907
[    1.779765] bus: 'i2c': add driver max8998
[    1.780028] bus: 'i2c': add driver tps6586x
[    1.780709] bus: 'i2c': add driver tps65090
[    1.781393] bus: 'i2c': add driver aat2870
[    1.786302] bus: 'i2c': add driver rc5t583
[    1.786985] bus: 'i2c': add driver lm3533
[    1.787754] bus: 'i2c': add driver as3711
[    1.788690] device class 'scsi_host': registering
[    1.789486] bus: 'scsi': registered
[    1.790011] device class 'scsi_device': registering
[    1.790831] SCSI subsystem initialized
[    1.791464] ACPI: bus type ATA registered
[    1.800043] device class 'ata_link': registering
[    1.800813] device class 'ata_port': registering
[    1.801561] device class 'ata_device': registering
[    1.802534] libata version 3.00 loaded.
[    1.803223] device class 'mdio_bus': registering
[    1.804113] bus: 'mdio_bus': registered
[    1.804733] bus: 'mdio_bus': add driver Generic PHY
[    1.805552] bus: 'serio': registered
[    1.806152] bus: 'gameport': registered
[    1.810012] device class 'input': registering
[    1.810731] device class 'rtc': registering
[    1.811538] device class 'pps': registering
[    1.812248] pps_core: LinuxPPS API ver. 1 registered
[    1.813035] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.814470] device class 'ptp': registering
[    1.815163] PTP clock support registered
[    1.820006] device class 'power_supply': registering
[    1.820826] device class 'hwmon': registering
[    1.821534] device class 'watchdog': registering
[    1.830049] EDAC MC: Ver: 3.0.0
[    1.831087] bus: 'edac': registered
[    1.831649] device: 'edac': device_add
[    1.832274] device: 'mc': device_add
[    1.832858] bus: 'edac': add device mc
[    1.833510] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    1.846324] device class 'leds': registering
[    1.847049] device class 'wmi': registering
[    1.847734] bus: 'acpi': add driver wmi
[    1.848419] wmi: Mapper loaded
[    1.848921] device class 'devfreq': registering
[    1.849863] PCI: Using ACPI for IRQ routing
[    1.850012] PCI: pci_cache_line_size set to 64 bytes
[    1.850847] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags =
0x110] (d=3D0, p=3D0)
[    1.852347] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] =
(d=3D0, p=3D0)
[    1.853538] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags =
0x110] (d=3D0, p=3D0)
[    1.858947] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] =
(d=3D0, p=3D0)
[    1.860010] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags =
0x40101] (d=3D0, p=3D0)
[    1.861335] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdfffff=
f flags 0x42208] (d=3D0, p=3D0)
[    1.862803] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf0000-0xfebf0ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.870045] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbfff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.871493] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags =
0x40101] (d=3D0, p=3D0)
[    1.872815] pci 0000:00:04.0: BAR 0: reserving [io  0xc040-0xc07f flags =
0x40101] (d=3D0, p=3D0)
[    1.874122] pci 0000:00:04.0: BAR 1: reserving [mem 0xfebf1000-0xfebf1ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.880031] pci 0000:00:05.0: BAR 0: reserving [io  0xc080-0xc0bf flags =
0x40101] (d=3D0, p=3D0)
[    1.881334] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf2000-0xfebf2ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.882860] pci 0000:00:06.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags =
0x40101] (d=3D0, p=3D0)
[    1.886723] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf3000-0xfebf3ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.890026] pci 0000:00:07.0: BAR 0: reserving [io  0xc100-0xc13f flags =
0x40101] (d=3D0, p=3D0)
[    1.891342] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.892776] pci 0000:00:08.0: BAR 0: reserving [io  0xc140-0xc17f flags =
0x40101] (d=3D0, p=3D0)
[    1.900017] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.901510] pci 0000:00:09.0: BAR 0: reserving [io  0xc180-0xc1bf flags =
0x40101] (d=3D0, p=3D0)
[    1.902817] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.904239] pci 0000:00:0a.0: BAR 0: reserving [mem 0xfebf7000-0xfebf700=
f flags 0x40200] (d=3D0, p=3D0)
[    1.910182] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.911150] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.917210] device class 'net': registering
[    1.918014] device: 'lo': device_add
[    1.920637] Bluetooth: Core ver 2.16
[    1.921265] device class 'bluetooth': registering
[    1.922021] NET: Registered protocol family 31
[    1.922735] Bluetooth: HCI device and connection manager initialized
[    1.923749] Bluetooth: HCI socket layer initialized
[    1.924531] Bluetooth: L2CAP socket layer initialized
[    1.930046] Bluetooth: SCO socket layer initialized
[    1.930829] nfc: nfc_init: NFC Core ver 0.1
[    1.931502] device class 'nfc': registering
[    1.932268] NET: Registered protocol family 39
[    1.938933] Switching to clocksource hpet
[    2.043454] FS-Cache: Loaded
[    2.043978] bus: 'pnp': add driver system
[    2.044650] pnp: PnP ACPI init
[    2.045158] device: 'pnp0': device_add
[    2.050507] ACPI: bus type PNP registered
[    2.051244] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    2.052525] device: '00:00': device_add
[    2.053164] bus: 'pnp': add device 00:00
[    2.053847] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.055000] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    2.056287] device: '00:01': device_add
[    2.056923] bus: 'pnp': add device 00:01
[    2.064539] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.067807] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    2.069128] device: '00:02': device_add
[    2.069769] bus: 'pnp': add device 00:02
[    2.070484] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.071881] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    2.073150] pnp 00:03: [dma 2]
[    2.073657] device: '00:03': device_add
[    2.074323] bus: 'pnp': add device 00:03
[    2.074980] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.091313] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    2.092631] device: '00:04': device_add
[    2.093285] bus: 'pnp': add device 00:04
[    2.093990] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.095264] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    2.096588] device: '00:05': device_add
[    2.097215] bus: 'pnp': add device 00:05
[    2.097875] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.104440] device: '00:06': device_add
[    2.105087] bus: 'pnp': add device 00:06
[    2.105771] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.107186] pnp: PnP ACPI: found 7 devices
[    2.107841] ACPI: bus type PNP unregistered
[    2.108516] bus: 'pci': add driver Intel MID DMA
[    2.109332] device class 'mem': registering
[    2.110048] device: 'mem': device_add
[    2.110689] device: 'kmem': device_add
[    2.111562] device: 'null': device_add
[    2.112190] device: 'port': device_add
[    2.112824] device: 'zero': device_add
[    2.113455] device: 'full': device_add
[    2.114080] device: 'random': device_add
[    2.114739] device: 'urandom': device_add
[    2.125055] device: 'kmsg': device_add
[    2.127193] device: 'tty': device_add
[    2.127862] device: 'console': device_add
[    2.128548] device class 'thermal': registering
[    2.175104] PM-Timer running at invalid rate: 127% of normal - aborting.
[    2.176250] bus: 'ssb': registered
[    2.176852] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    2.177733] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    2.178806] NET: Registered protocol family 2
[    2.180432] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    2.181642] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    2.182930] TCP: Hash tables configured (established 2048 bind 2048)
[    2.184037] TCP: reno registered
[    2.194951] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    2.195965] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    2.197168] NET: Registered protocol family 1
[    2.197911] pci 0000:00:00.0: calling quirk_natoma+0x0/0x40
[    2.198792] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.199723] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x80
[    2.207185] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.208117] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x40
[    2.209083] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.210124] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xb0
[    2.211055] pci 0000:00:02.0: Boot video device
[    2.211788] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x1b0
[    2.212888] PCI: CLS 0 bytes, default 64
[    2.213791] Trying to unpack rootfs image as initramfs...
[    4.711282] Freeing initrd memory: 25284k freed
[   11.428063] DMA-API: preallocated 65536 debug entries
[   11.428912] DMA-API: debugging enabled by kernel config
[   11.434946] Registering platform device 'pcspkr'. Parent at platform
[   11.455359] device: 'pcspkr': device_add
[   11.456123] bus: 'platform': add device pcspkr
[   11.457336] Registering platform device 'microcode'. Parent at platform
[   11.459085] device: 'microcode': device_add
[   11.460265] bus: 'platform': add device microcode
[   11.463567] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   11.464512] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   11.465513] device: 'microcode': device_add
[   11.466385] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[   11.500111] PCLMULQDQ-NI instructions are not detected.
[   11.500967] NatSemi SCx200 Driver
[   11.501513] bus: 'pci': add driver scx200
[   11.502269] bus: 'clocksource': registered
[   11.507215] device: 'clocksource': device_add
[   11.526397] device: 'clocksource0': device_add
[   11.527150] bus: 'clocksource': add device clocksource0
[   11.528261] bus: 'platform': add driver alarmtimer
[   11.529136] Registering platform device 'alarmtimer'. Parent at platform
[   11.545454] device: 'alarmtimer': device_add
[   11.546178] bus: 'platform': add device alarmtimer
[   11.546975] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[   11.548371] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[   11.549703] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[   11.550900] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[   11.552250] bus: 'rttest': registered
[   11.552842] device: 'rttest': device_add
[   11.580402] device: 'rttest0': device_add
[   11.581068] bus: 'rttest': add device rttest0
[   11.581813] ------------[ cut here ]------------
[   11.582568] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:56=
9 device_create_file+0x5a/0xa0()
[   11.584035] Write permission without 'store'
[   11.584793] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc2-next-20130318 =
#21
[   11.585902] Call Trace:
[   11.586318]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.587146]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.587982]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.588820]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.589618]  [<8151b77a>] device_create_file+0x5a/0xa0
[   11.590523]  [<81081faa>] init_rttest+0xaa/0x150
[   11.591255]  [<81082270>] ? handle_op+0x220/0x220
[   11.591994]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.592838]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.593642]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.594492]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.595291]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.596026]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.596990]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.597749] ---[ end trace 124d60cbc476f331 ]---
[   11.598487] ------------[ cut here ]------------
[   11.599213] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:57=
1 device_create_file+0x8a/0xa0()
[   11.600736] Read permission without 'show'
[   11.601385] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.602607] Call Trace:
[   11.603002]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.603838]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.604675]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.605509]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.606331]  [<8151b7aa>] device_create_file+0x8a/0xa0
[   11.607137]  [<81081fc3>] init_rttest+0xc3/0x150
[   11.607870]  [<81082270>] ? handle_op+0x220/0x220
[   11.608617]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.609474]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.610361]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.611210]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.611994]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.612702]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.613568]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.614310] ---[ end trace 124d60cbc476f332 ]---
[   11.648479] device: 'rttest1': device_add
[   11.649177] bus: 'rttest': add device rttest1
[   11.649916] ------------[ cut here ]------------
[   11.650732] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:56=
9 device_create_file+0x5a/0xa0()
[   11.652197] Write permission without 'store'
[   11.652884] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.654109] Call Trace:
[   11.654511]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.655343]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.656200]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.657037]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.657851]  [<8151b77a>] device_create_file+0x5a/0xa0
[   11.658675]  [<81081faa>] init_rttest+0xaa/0x150
[   11.659413]  [<81082270>] ? handle_op+0x220/0x220
[   11.660298]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.661116]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.661904]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.662757]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.663549]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.664254]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.665110]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.665880] ---[ end trace 124d60cbc476f333 ]---
[   11.666615] ------------[ cut here ]------------
[   11.667346] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:57=
1 device_create_file+0x8a/0xa0()
[   11.668808] Read permission without 'show'
[   11.669457] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.671678] Call Trace:
[   11.672086]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.673009]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.673856]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.674699]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.675512]  [<8151b7aa>] device_create_file+0x8a/0xa0
[   11.676367]  [<81081fc3>] init_rttest+0xc3/0x150
[   11.677096]  [<81082270>] ? handle_op+0x220/0x220
[   11.677849]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.678678]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.679484]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.680401]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.681184]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.681891]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.682755]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.683498] ---[ end trace 124d60cbc476f334 ]---
[   11.705393] device: 'rttest2': device_add
[   11.706108] bus: 'rttest': add device rttest2
[   11.706834] ------------[ cut here ]------------
[   11.707578] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:56=
9 device_create_file+0x5a/0xa0()
[   11.709053] Write permission without 'store'
[   11.709734] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.711218] Call Trace:
[   11.711625]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.712463]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.713304]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.714141]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.714940]  [<8151b77a>] device_create_file+0x5a/0xa0
[   11.715755]  [<81081faa>] init_rttest+0xaa/0x150
[   11.716520]  [<81082270>] ? handle_op+0x220/0x220
[   11.717265]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.718083]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.718872]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.719858]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.720702]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.721413]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.722282]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.723076] ---[ end trace 124d60cbc476f335 ]---
[   11.724531] ------------[ cut here ]------------
[   11.725278] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:57=
1 device_create_file+0x8a/0xa0()
[   11.726790] Read permission without 'show'
[   11.727452] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.728686] Call Trace:
[   11.729086]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.729925]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.730834]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.731681]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.732479]  [<8151b7aa>] device_create_file+0x8a/0xa0
[   11.733297]  [<81081fc3>] init_rttest+0xc3/0x150
[   11.734020]  [<81082270>] ? handle_op+0x220/0x220
[   11.734766]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.737311]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.738095]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.738953]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.739753]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.740567]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.741449]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.742193] ---[ end trace 124d60cbc476f336 ]---
[   11.754595] device: 'rttest3': device_add
[   11.755268] bus: 'rttest': add device rttest3
[   11.756015] ------------[ cut here ]------------
[   11.756758] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:56=
9 device_create_file+0x5a/0xa0()
[   11.758225] Write permission without 'store'
[   11.758908] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.760282] Call Trace:
[   11.760708]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.761561]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.762403]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.763237]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.764039]  [<8151b77a>] device_create_file+0x5a/0xa0
[   11.764857]  [<81081faa>] init_rttest+0xaa/0x150
[   11.765595]  [<81082270>] ? handle_op+0x220/0x220
[   11.766377]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.767203]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.767991]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.768844]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.769631]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.770386]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.771269]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.772012] ---[ end trace 124d60cbc476f337 ]---
[   11.772822] ------------[ cut here ]------------
[   11.773561] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:57=
1 device_create_file+0x8a/0xa0()
[   11.775081] Read permission without 'show'
[   11.775740] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.777015] Call Trace:
[   11.777423]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.778269]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.779101]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.779937]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.780782]  [<8151b7aa>] device_create_file+0x8a/0xa0
[   11.781600]  [<81081fc3>] init_rttest+0xc3/0x150
[   11.782337]  [<81082270>] ? handle_op+0x220/0x220
[   11.783081]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.783910]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.784736]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.785632]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.786453]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.787154]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.788032]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.788781] ---[ end trace 124d60cbc476f338 ]---
[   11.820377] device: 'rttest4': device_add
[   11.821037] bus: 'rttest': add device rttest4
[   11.821763] ------------[ cut here ]------------
[   11.822505] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:56=
9 device_create_file+0x5a/0xa0()
[   11.825393] Write permission without 'store'
[   11.826100] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.827573] Call Trace:
[   11.827974]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.828813]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.829653]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.830640]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.831439]  [<8151b77a>] device_create_file+0x5a/0xa0
[   11.832248]  [<81081faa>] init_rttest+0xaa/0x150
[   11.832969]  [<81082270>] ? handle_op+0x220/0x220
[   11.833714]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.837304]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.838083]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.839011]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.839812]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.840583]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.841452]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.842266] ---[ end trace 124d60cbc476f339 ]---
[   11.843004] ------------[ cut here ]------------
[   11.843747] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:57=
1 device_create_file+0x8a/0xa0()
[   11.845219] Read permission without 'show'
[   11.845900] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.849671] Call Trace:
[   11.850073]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.851010]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.851852]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.852697]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.853501]  [<8151b7aa>] device_create_file+0x8a/0xa0
[   11.854419]  [<81081fc3>] init_rttest+0xc3/0x150
[   11.855143]  [<81082270>] ? handle_op+0x220/0x220
[   11.855925]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.856754]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.857544]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.858449]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.862071]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.862833]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.863700]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.864447] ---[ end trace 124d60cbc476f33a ]---
[   11.878451] device: 'rttest5': device_add
[   11.879136] bus: 'rttest': add device rttest5
[   11.879871] ------------[ cut here ]------------
[   11.880618] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:56=
9 device_create_file+0x5a/0xa0()
[   11.882099] Write permission without 'store'
[   11.882911] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.886987] Call Trace:
[   11.887399]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.888231]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.889070]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.889914]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.890769]  [<8151b77a>] device_create_file+0x5a/0xa0
[   11.891584]  [<81081faa>] init_rttest+0xaa/0x150
[   11.892323]  [<81082270>] ? handle_op+0x220/0x220
[   11.893066]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.893895]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.894782]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.895630]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.899016]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.899729]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.900652]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.901393] ---[ end trace 124d60cbc476f33b ]---
[   11.902137] ------------[ cut here ]------------
[   11.902974] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:57=
1 device_create_file+0x8a/0xa0()
[   11.904482] Read permission without 'show'
[   11.905134] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.906486] Call Trace:
[   11.906897]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.907744]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.908589]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.912406]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.913203]  [<8151b7aa>] device_create_file+0x8a/0xa0
[   11.914023]  [<81081fc3>] init_rttest+0xc3/0x150
[   11.914762]  [<81082270>] ? handle_op+0x220/0x220
[   11.915515]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.916387]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.917173]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.918026]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.918938]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.919643]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.920555]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.921296] ---[ end trace 124d60cbc476f33c ]---
[   11.938593] device: 'rttest6': device_add
[   11.939279] bus: 'rttest': add device rttest6
[   11.940004] ------------[ cut here ]------------
[   11.940748] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:56=
9 device_create_file+0x5a/0xa0()
[   11.942411] Write permission without 'store'
[   11.943084] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.944313] Call Trace:
[   11.944712]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.945557]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.948920]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   11.949760]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.950708]  [<8151b77a>] device_create_file+0x5a/0xa0
[   11.951522]  [<81081faa>] init_rttest+0xaa/0x150
[   11.952251]  [<81082270>] ? handle_op+0x220/0x220
[   11.952996]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.953836]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.954687]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.955545]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.956369]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.957071]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.957939]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.961568] ---[ end trace 124d60cbc476f33d ]---
[   11.962322] ------------[ cut here ]------------
[   11.963056] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:57=
1 device_create_file+0x8a/0xa0()
[   11.964543] Read permission without 'show'
[   11.965189] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   11.966574] Call Trace:
[   11.966975]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   11.967822]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.968672]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   11.969516]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   11.970534]  [<8151b7aa>] device_create_file+0x8a/0xa0
[   11.973908]  [<81081fc3>] init_rttest+0xc3/0x150
[   11.974733]  [<81082270>] ? handle_op+0x220/0x220
[   11.975486]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   11.976363]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   11.977150]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   11.978009]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   11.978884]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   11.979593]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   11.980524]  [<81c8ce20>] ? rest_init+0x130/0x130
[   11.981272] ---[ end trace 124d60cbc476f33e ]---
[   12.006946] device: 'rttest7': device_add
[   12.007661] bus: 'rttest': add device rttest7
[   12.008390] ------------[ cut here ]------------
[   12.012181] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:56=
9 device_create_file+0x5a/0xa0()
[   12.013676] Write permission without 'store'
[   12.014436] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   12.015674] Call Trace:
[   12.016117]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   12.016959]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   12.017800]  [<8151b77a>] ? device_create_file+0x5a/0xa0
[   12.018731]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   12.019532]  [<8151b77a>] device_create_file+0x5a/0xa0
[   12.020419]  [<81081faa>] init_rttest+0xaa/0x150
[   12.021148]  [<81082270>] ? handle_op+0x220/0x220
[   12.024528]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   12.025363]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   12.026414]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   12.027267]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   12.028047]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   12.028750]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   12.029612]  [<81c8ce20>] ? rest_init+0x130/0x130
[   12.030504] ---[ end trace 124d60cbc476f33f ]---
[   12.031248] ------------[ cut here ]------------
[   12.031973] WARNING: at /c/kernel-tests/src/linux/drivers/base/core.c:57=
1 device_create_file+0x8a/0xa0()
[   12.033432] Read permission without 'show'
[   12.034072] Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc2-nex=
t-20130318 #21
[   12.037714] Call Trace:
[   12.038118]  [<8102d888>] warn_slowpath_common+0x68/0xa0
[   12.039233]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   12.040079]  [<8151b7aa>] ? device_create_file+0x8a/0xa0
[   12.040984]  [<8102d91e>] warn_slowpath_fmt+0x2e/0x30
[   12.041783]  [<8151b7aa>] device_create_file+0x8a/0xa0
[   12.042667]  [<81081fc3>] init_rttest+0xc3/0x150
[   12.043410]  [<81082270>] ? handle_op+0x220/0x220
[   12.044143]  [<81081f00>] ? sysfs_test_status+0xf0/0xf0
[   12.044971]  [<821f7a92>] do_one_initcall+0x7f/0x128
[   12.045757]  [<821f7c1e>] kernel_init_freeable+0xe3/0x182
[   12.049116]  [<821f74d1>] ? do_early_param+0x7a/0x7a
[   12.049907]  [<81c8ce2b>] kernel_init+0xb/0xd0
[   12.050869]  [<81cac5f7>] ret_from_kernel_thread+0x1b/0x28
[   12.051733]  [<81c8ce20>] ? rest_init+0x130/0x130
[   12.052475] ---[ end trace 124d60cbc476f340 ]---
[   12.053206] Initializing RT-Tester: OK
[   12.054030] rcu-torture:--- Start of test: nreaders=3D4 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D0 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[   12.090283] bus: 'event_source': registered
[   12.090983] device: 'breakpoint': device_add
[   12.103067] bus: 'event_source': add device breakpoint
[   12.173647] device: 'tracepoint': device_add
[   12.175273] bus: 'event_source': add device tracepoint
[   12.176148] device: 'software': device_add
[   12.176814] bus: 'event_source': add device software
[   12.197367] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   12.215631] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   12.217074] FS-Cache: Netfs 'cifs' registered for caching
[   12.228165] NTFS driver 2.1.30 [Flags: R/W].
[   12.229111] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[   12.231433] QNX6 filesystem 1.0.0 registered.
[   12.236157] device: 'autofs': device_add
[   12.241572] JFS: nTxBlock =3D 1768, nTxLock =3D 14145
[   12.257869] NILFS version 2 loaded
[   12.258517] BeFS version: 0.9.3
[   12.259032] msgmni has been set to 442
[   12.333588] alg: No test for crc32 (crc32-table)
[   12.334740] alg: No test for stdrng (krng)
[   12.379287] NET: Registered protocol family 38
[   12.380071] device class 'bsg': registering
[   12.382271] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[   12.383467] io scheduler noop registered
[   12.388454] io scheduler cfq registered (default)
[   12.392470] xz_dec_test: module loaded
[   12.393078] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[   12.394666] bus: 'platform': add driver adp5520-gpio
[   12.395492] bus: 'pci': add driver bt8xxgpio
[   12.413491] bus: 'pci': add driver ml_ioh_gpio
[   12.414638] bus: 'pci': add driver pch_gpio
[   12.415360] bus: 'platform': add driver rdc321x-gpio
[   12.423292] bus: 'platform': add driver vx855_gpio
[   12.424121] bus: 'pci_express': registered
[   12.424786] bus: 'pci': add driver pcieport
[   12.425488] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   12.426401] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[   12.427498] bus: 'pci': add driver compaq_pci_hotplug
[   12.428353] ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
[   12.432037] bus: 'pci': add driver shpchp
[   12.432730] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   12.433922] bus: 'platform': add driver 88pm860x-backlight
[   12.438899] bus: 'platform': add driver adp5520-backlight
[   12.439811] bus: 'i2c': add driver adp8860_bl
[   12.440775] bus: 'i2c': add driver adp8870_bl
[   12.446076] bus: 'platform': add driver da903x-backlight
[   12.446984] bus: 'platform': add driver generic-bl
[   12.447759] bus: 'platform': add driver lm3533-backlight
[   12.448630] bus: 'platform': add driver pandora-backlight
[   12.449511] bus: 'pci': add driver CyberPro
[   12.452438] bus: 'pci': add driver pm2fb
[   12.453091] bus: 'pci': add driver matroxfb
[   12.453818] rivafb_setup START
[   12.454331] bus: 'pci': add driver rivafb
[   12.458860] bus: 'pci': add driver aty128fb
[   12.459601] bus: 'pci': add driver radeonfb
[   12.461723] bus: 'pci': add driver sisfb
[   12.462378] bus: 'pci': add driver savagefb
[   12.463071] bus: 'pci': add driver tdfxfb
[   12.463741] bus: 'pci': add driver tridentfb
[   12.464460] vmlfb: initializing
[   12.464970] bus: 'pci': add driver vmlfb
[   12.469349] Could not find Carillo Ranch MCH device.
[   12.470158] bus: 'pci': add driver s3fb
[   12.472713] bus: 'pci': add driver arkfb
[   12.473374] bus: 'platform': add driver hgafb
[   12.474088] Registering platform device 'hgafb.0'. Parent at platform
[   12.475097] device: 'hgafb.0': device_add
[   12.475748] bus: 'platform': add device hgafb.0
[   12.476530] bus: 'platform': driver_probe_device: matched device hgafb.0=
 with driver hgafb
[   12.477820] bus: 'platform': really_probe: probing driver hgafb with dev=
ice hgafb.0
[   12.479098] hgafb: HGA card not detected.
[   12.479782] hgafb: probe of hgafb.0 failed with error -22
[   12.481529] bus: 'pci': add driver cirrusfb
[   12.482201] bus: 'pci': driver_probe_device: matched device 0000:00:02.0=
 with driver cirrusfb
[   12.483528] bus: 'pci': really_probe: probing driver cirrusfb with devic=
e 0000:00:02.0
[   12.485327] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[   12.486792] device: 'fb0': device_add
[   12.487624] driver: '0000:00:02.0': driver_bound: bound to device 'cirru=
sfb'
[   12.488750] bus: 'pci': really_probe: bound device 0000:00:02.0 to drive=
r cirrusfb
[   12.489977] bus: 'platform': add driver metronomefb
[   12.495549] bus: 'platform': add driver auo_k1900fb
[   12.496455] bus: 'platform': add driver s1d13xxxfb
[   12.497228] bus: 'pci': add driver carminefb
[   12.497950] Registering platform device 'vesafb.0'. Parent at platform
[   12.498974] device: 'vesafb.0': device_add
[   12.499636] bus: 'platform': add device vesafb.0
[   12.510895] tsc: Refined TSC clocksource calibration: 2666.662 MHz
[   12.511917] Switching to clocksource tsc
[   12.556459] bus: 'platform': add driver vesafb
[   12.557201] bus: 'platform': driver_probe_device: matched device vesafb.=
0 with driver vesafb
[   12.558521] bus: 'platform': really_probe: probing driver vesafb with de=
vice vesafb.0
[   12.559777] vesafb: probe of vesafb.0 rejects match -19
[   12.560668] bus: 'platform': remove driver vesafb
[   12.561430] driver: 'vesafb': driver_release
[   12.562164] bus: 'platform': remove device vesafb.0
[   12.562974] bus: 'acpi': add driver ac
[   12.563633] bus: 'acpi': add driver button
[   12.564318] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00=
 with driver button
[   12.566269] bus: 'acpi': really_probe: probing driver button with device=
 LNXPWRBN:00
[   12.567542] device: 'input0': device_add
[   12.569002] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   12.570298] ACPI: Power Button [PWRF]
[   12.570937] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[   12.572017] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to drive=
r button
[   12.573213] bus: 'acpi': add driver fan
[   12.578164] bus: 'acpi': add driver video
[   12.579612] bus: 'acpi': add driver processor
[   12.584109] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 w=
ith driver processor
[   12.585519] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:00
[   12.588496] device: 'cooling_device0': device_add
[   12.589345] driver: 'LNXCPU:00': driver_bound: bound to device 'processo=
r'
[   12.590458] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver =
processor
[   12.591648] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 w=
ith driver processor
[   12.592962] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:01
[   12.594843] device: 'cooling_device1': device_add
[   12.595633] driver: 'LNXCPU:01': driver_bound: bound to device 'processo=
r'
[   12.597315] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver =
processor
[   12.628555] bus: 'acpi': add driver thermal
[   12.632975] bus: 'platform': add driver timb-dma
[   12.647334] bus: 'acpi': add driver battery
[   12.648112] bus: 'pci': add driver pch-dma
[   12.648834] device: 'ptyp0': device_add
[   12.649502] device: 'ptyp1': device_add
[   12.650159] device: 'ptyp2': device_add
[   12.654387] device: 'ptyp3': device_add
[   12.655123] device: 'ptyp4': device_add
[   12.655885] device: 'ptyp5': device_add
[   12.656526] device: 'ptyp6': device_add
[   12.657162] device: 'ptyp7': device_add
[   12.658305] device: 'ptyp8': device_add
[   12.662569] device: 'ptyp9': device_add
[   12.663300] device: 'ptypa': device_add
[   12.663932] device: 'ptypb': device_add
[   12.664572] device: 'ptypc': device_add
[   12.665227] device: 'ptypd': device_add
[   12.666655] device: 'ptype': device_add
[   12.670494] device: 'ptypf': device_add
[   12.675409] device: 'ptyq0': device_add
[   12.677839] device: 'ptyq1': device_add
[   12.678481] device: 'ptyq2': device_add
[   12.679115] device: 'ptyq3': device_add
[   12.679869] device: 'ptyq4': device_add
[   12.680537] device: 'ptyq5': device_add
[   12.684890] device: 'ptyq6': device_add
[   12.685623] device: 'ptyq7': device_add
[   12.687144] device: 'ptyq8': device_add
[   12.687789] device: 'ptyq9': device_add
[   12.688435] device: 'ptyqa': device_add
[   12.689076] device: 'ptyqb': device_add
[   12.693396] device: 'ptyqc': device_add
[   12.694111] device: 'ptyqd': device_add
[   12.694763] device: 'ptyqe': device_add
[   12.695408] device: 'ptyqf': device_add
[   12.696817] device: 'ptyr0': device_add
[   12.697477] device: 'ptyr1': device_add
[   12.701974] device: 'ptyr2': device_add
[   12.702710] device: 'ptyr3': device_add
[   12.703356] device: 'ptyr4': device_add
[   12.703995] device: 'ptyr5': device_add
[   12.704637] device: 'ptyr6': device_add
[   12.705278] device: 'ptyr7': device_add
[   12.710677] device: 'ptyr8': device_add
[   12.711404] device: 'ptyr9': device_add
[   12.712036] device: 'ptyra': device_add
[   12.808467] device: 'ptyrb': device_add
[   12.809247] device: 'ptyrc': device_add
[   12.809887] device: 'ptyrd': device_add
[   12.814301] device: 'ptyre': device_add
[   12.815037] device: 'ptyrf': device_add
[   12.815696] device: 'ptys0': device_add
[   12.816398] device: 'ptys1': device_add
[   12.817033] device: 'ptys2': device_add
[   12.817676] device: 'ptys3': device_add
[   12.822630] device: 'ptys4': device_add
[   12.823365] device: 'ptys5': device_add
[   12.824010] device: 'ptys6': device_add
[   12.824656] device: 'ptys7': device_add
[   12.825430] device: 'ptys8': device_add
[   12.826079] device: 'ptys9': device_add
[   12.831190] device: 'ptysa': device_add
[   12.831937] device: 'ptysb': device_add
[   12.832587] device: 'ptysc': device_add
[   12.833350] device: 'ptysd': device_add
[   12.833990] device: 'ptyse': device_add
[   12.834646] device: 'ptysf': device_add
[   12.839305] device: 'ptyt0': device_add
[   12.840043] device: 'ptyt1': device_add
[   12.840732] device: 'ptyt2': device_add
[   12.841376] device: 'ptyt3': device_add
[   12.842143] device: 'ptyt4': device_add
[   12.842793] device: 'ptyt5': device_add
[   12.847717] device: 'ptyt6': device_add
[   12.848463] device: 'ptyt7': device_add
[   12.849105] device: 'ptyt8': device_add
[   12.849758] device: 'ptyt9': device_add
[   12.850456] device: 'ptyta': device_add
[   12.851103] device: 'ptytb': device_add
[   12.855670] device: 'ptytc': device_add
[   12.856411] device: 'ptytd': device_add
[   12.857054] device: 'ptyte': device_add
[   12.857703] device: 'ptytf': device_add
[   12.858482] device: 'ptyu0': device_add
[   12.859232] device: 'ptyu1': device_add
[   12.864022] device: 'ptyu2': device_add
[   12.864761] device: 'ptyu3': device_add
[   12.865404] device: 'ptyu4': device_add
[   12.866047] device: 'ptyu5': device_add
[   12.866700] device: 'ptyu6': device_add
[   12.867347] device: 'ptyu7': device_add
[   12.872557] device: 'ptyu8': device_add
[   12.873292] device: 'ptyu9': device_add
[   12.873931] device: 'ptyua': device_add
[   12.874587] device: 'ptyub': device_add
[   12.875361] device: 'ptyuc': device_add
[   12.876009] device: 'ptyud': device_add
[   12.880604] device: 'ptyue': device_add
[   12.881333] device: 'ptyuf': device_add
[   12.881968] device: 'ptyv0': device_add
[   12.882612] device: 'ptyv1': device_add
[   12.883260] device: 'ptyv2': device_add
[   12.883903] device: 'ptyv3': device_add
[   12.889693] device: 'ptyv4': device_add
[   12.890483] device: 'ptyv5': device_add
[   12.891122] device: 'ptyv6': device_add
[   12.891767] device: 'ptyv7': device_add
[   12.892529] device: 'ptyv8': device_add
[   12.893168] device: 'ptyv9': device_add
[   12.898669] device: 'ptyva': device_add
[   12.899399] device: 'ptyvb': device_add
[   12.900054] device: 'ptyvc': device_add
[   12.900743] device: 'ptyvd': device_add
[   12.901399] device: 'ptyve': device_add
[   12.902043] device: 'ptyvf': device_add
[   12.907711] device: 'ptyw0': device_add
[   12.908447] device: 'ptyw1': device_add
[   12.909092] device: 'ptyw2': device_add
[   12.909746] device: 'ptyw3': device_add
[   12.913012] device: 'ptyw4': device_add
[   12.913665] device: 'ptyw5': device_add
[   12.918351] device: 'ptyw6': device_add
[   12.919071] device: 'ptyw7': device_add
[   12.919717] device: 'ptyw8': device_add
[   12.920403] device: 'ptyw9': device_add
[   12.921043] device: 'ptywa': device_add
[   12.921695] device: 'ptywb': device_add
[   12.932623] device: 'ptywc': device_add
[   12.933372] device: 'ptywd': device_add
[   12.934017] device: 'ptywe': device_add
[   12.934669] device: 'ptywf': device_add
[   12.938280] device: 'ptyx0': device_add
[   12.939478] device: 'ptyx1': device_add
[   12.944384] device: 'ptyx2': device_add
[   12.945112] device: 'ptyx3': device_add
[   12.945766] device: 'ptyx4': device_add
[   12.946999] device: 'ptyx5': device_add
[   12.947647] device: 'ptyx6': device_add
[   12.948298] device: 'ptyx7': device_add
[   12.955571] device: 'ptyx8': device_add
[   12.956943] device: 'ptyx9': device_add
[   12.957596] device: 'ptyxa': device_add
[   12.958303] device: 'ptyxb': device_add
[   12.959108] device: 'ptyxc': device_add
[   12.959764] device: 'ptyxd': device_add
[   12.964825] device: 'ptyxe': device_add
[   12.965577] device: 'ptyxf': device_add
[   12.967018] device: 'ptyy0': device_add
[   12.967662] device: 'ptyy1': device_add
[   12.968309] device: 'ptyy2': device_add
[   12.968947] device: 'ptyy3': device_add
[   12.973518] device: 'ptyy4': device_add
[   12.976695] device: 'ptyy5': device_add
[   12.977365] device: 'ptyy6': device_add
[   12.978007] device: 'ptyy7': device_add
[   12.978855] device: 'ptyy8': device_add
[   12.979504] device: 'ptyy9': device_add
[   12.984414] device: 'ptyya': device_add
[   12.989072] device: 'ptyyb': device_add
[   12.989755] device: 'ptyyc': device_add
[   12.990521] device: 'ptyyd': device_add
[   12.991161] device: 'ptyye': device_add
[   12.991806] device: 'ptyyf': device_add
[   12.997209] device: 'ptyz0': device_add
[   12.997944] device: 'ptyz1': device_add
[   12.998724] device: 'ptyz2': device_add
[   13.002604] device: 'ptyz3': device_add
[   13.003384] device: 'ptyz4': device_add
[   13.004040] device: 'ptyz5': device_add
[   13.009649] device: 'ptyz6': device_add
[   13.010621] device: 'ptyz7': device_add
[   13.011275] device: 'ptyz8': device_add
[   13.015049] device: 'ptyz9': device_add
[   13.015699] device: 'ptyza': device_add
[   13.016447] device: 'ptyzb': device_add
[   13.021025] device: 'ptyzc': device_add
[   13.021761] device: 'ptyzd': device_add
[   13.022549] device: 'ptyze': device_add
[   13.023189] device: 'ptyzf': device_add
[   13.023962] device: 'ptya0': device_add
[   13.028397] device: 'ptya1': device_add
[   13.033254] device: 'ptya2': device_add
[   13.033980] device: 'ptya3': device_add
[   13.034746] device: 'ptya4': device_add
[   13.035394] device: 'ptya5': device_add
[   13.036225] device: 'ptya6': device_add
[   13.036868] device: 'ptya7': device_add
[   13.044552] device: 'ptya8': device_add
[   13.045294] device: 'ptya9': device_add
[   13.046806] device: 'ptyaa': device_add
[   13.047459] device: 'ptyab': device_add
[   13.048217] device: 'ptyac': device_add
[   13.048865] device: 'ptyad': device_add
[   13.056503] device: 'ptyae': device_add
[   13.057232] device: 'ptyaf': device_add
[   13.057882] device: 'ptyb0': device_add
[   13.058697] device: 'ptyb1': device_add
[   13.059349] device: 'ptyb2': device_add
[   13.059992] device: 'ptyb3': device_add
[   13.068234] device: 'ptyb4': device_add
[   13.068959] device: 'ptyb5': device_add
[   13.069603] device: 'ptyb6': device_add
[   13.070548] device: 'ptyb7': device_add
[   13.071341] device: 'ptyb8': device_add
[   13.071983] device: 'ptyb9': device_add
[   13.078011] device: 'ptyba': device_add
[   13.082096] device: 'ptybb': device_add
[   13.083014] device: 'ptybc': device_add
[   13.083776] device: 'ptybd': device_add
[   13.084442] device: 'ptybe': device_add
[   13.085086] device: 'ptybf': device_add
[   13.090593] device: 'ptyc0': device_add
[   13.095482] device: 'ptyc1': device_add
[   13.096732] device: 'ptyc2': device_add
[   13.097384] device: 'ptyc3': device_add
[   13.098150] device: 'ptyc4': device_add
[   13.099088] device: 'ptyc5': device_add
[   13.115426] device: 'ptyc6': device_add
[   13.116947] device: 'ptyc7': device_add
[   13.117954] device: 'ptyc8': device_add
[   13.118684] device: 'ptyc9': device_add
[   13.119330] device: 'ptyca': device_add
[   13.147561] device: 'ptycb': device_add
[   13.153630] device: 'ptycc': device_add
[   13.155964] device: 'ptycd': device_add
[   13.156621] device: 'ptyce': device_add
[   13.160639] device: 'ptycf': device_add
[   13.161434] device: 'ptyd0': device_add
[   13.162082] device: 'ptyd1': device_add
[   13.167619] device: 'ptyd2': device_add
[   13.168361] device: 'ptyd3': device_add
[   13.169002] device: 'ptyd4': device_add
[   13.169651] device: 'ptyd5': device_add
[   13.173092] device: 'ptyd6': device_add
[   13.173749] device: 'ptyd7': device_add
[   13.179779] device: 'ptyd8': device_add
[   13.180558] device: 'ptyd9': device_add
[   13.181201] device: 'ptyda': device_add
[   13.181844] device: 'ptydb': device_add
[   13.185438] device: 'ptydc': device_add
[   13.186910] device: 'ptydd': device_add
[   13.191632] device: 'ptyde': device_add
[   13.192366] device: 'ptydf': device_add
[   13.193008] device: 'ptye0': device_add
[   13.193653] device: 'ptye1': device_add
[   13.194409] device: 'ptye2': device_add
[   13.198072] device: 'ptye3': device_add
[   13.203287] device: 'ptye4': device_add
[   13.204014] device: 'ptye5': device_add
[   13.204659] device: 'ptye6': device_add
[   13.205309] device: 'ptye7': device_add
[   13.207284] device: 'ptye8': device_add
[   13.210832] device: 'ptye9': device_add
[   13.215507] device: 'ptyea': device_add
[   13.230677] device: 'ptyeb': device_add
[   13.231327] device: 'ptyec': device_add
[   13.231975] device: 'ptyed': device_add
[   13.232626] device: 'ptyee': device_add
[   13.238725] device: 'ptyef': device_add
[   13.249514] device: 'ttyp0': device_add
[   13.254319] device: 'ttyp1': device_add
[   13.254969] device: 'ttyp2': device_add
[   13.255619] device: 'ttyp3': device_add
[   13.256394] device: 'ttyp4': device_add
[   13.257040] device: 'ttyp5': device_add
[   13.265766] device: 'ttyp6': device_add
[   13.270607] device: 'ttyp7': device_add
[   13.274006] device: 'ttyp8': device_add
[   13.278744] device: 'ttyp9': device_add
[   13.279395] device: 'ttypa': device_add
[   13.280052] device: 'ttypb': device_add
[   13.292462] device: 'ttypc': device_add
[   13.293188] device: 'ttypd': device_add
[   13.293841] device: 'ttype': device_add
[   13.298906] device: 'ttypf': device_add
[   13.299675] device: 'ttyq0': device_add
[   13.300352] device: 'ttyq1': device_add
[   13.315034] device: 'ttyq2': device_add
[   13.315783] device: 'ttyq3': device_add
[   13.316430] device: 'ttyq4': device_add
[   13.317069] device: 'ttyq5': device_add
[   13.317723] device: 'ttyq6': device_add
[   13.323682] device: 'ttyq7': device_add
[   13.332368] device: 'ttyq8': device_add
[   13.333093] device: 'ttyq9': device_add
[   13.338981] device: 'ttyqa': device_add
[   13.339638] device: 'ttyqb': device_add
[   13.340446] device: 'ttyqc': device_add
[   13.341106] device: 'ttyqd': device_add
[   13.356227] device: 'ttyqe': device_add
[   13.356972] device: 'ttyqf': device_add
[   13.357613] device: 'ttyr0': device_add
[   13.366416] device: 'ttyr1': device_add
[   13.367062] device: 'ttyr2': device_add
[   13.367713] device: 'ttyr3': device_add
[   13.376722] device: 'ttyr4': device_add
[   13.377446] device: 'ttyr5': device_add
[   13.378081] device: 'ttyr6': device_add
[   13.382837] device: 'ttyr7': device_add
[   13.390347] device: 'ttyr8': device_add
[   13.391029] device: 'ttyr9': device_add
[   13.400613] device: 'ttyra': device_add
[   13.401342] device: 'ttyrb': device_add
[   13.401981] device: 'ttyrc': device_add
[   13.406748] device: 'ttyrd': device_add
[   13.407394] device: 'ttyre': device_add
[   13.408041] device: 'ttyrf': device_add
[   13.423245] device: 'ttys0': device_add
[   13.424927] device: 'ttys1': device_add
[   13.425582] device: 'ttys2': device_add
[   13.430333] device: 'ttys3': device_add
[   13.431106] device: 'ttys4': device_add
[   13.431751] device: 'ttys5': device_add
[   13.444579] device: 'ttys6': device_add
[   13.445320] device: 'ttys7': device_add
[   13.445969] device: 'ttys8': device_add
[   13.451232] device: 'ttys9': device_add
[   13.451886] device: 'ttysa': device_add
[   13.452540] device: 'ttysb': device_add
[   13.464553] device: 'ttysc': device_add
[   13.465293] device: 'ttysd': device_add
[   13.465939] device: 'ttyse': device_add
[   13.470834] device: 'ttysf': device_add
[   13.471603] device: 'ttyt0': device_add
[   13.472248] device: 'ttyt1': device_add
[   13.488332] device: 'ttyt2': device_add
[   13.490066] device: 'ttyt3': device_add
[   13.494875] device: 'ttyt4': device_add
[   13.495526] device: 'ttyt5': device_add
[   13.496168] device: 'ttyt6': device_add
[   13.496812] device: 'ttyt7': device_add
[   13.505692] device: 'ttyt8': device_add
[   13.510610] device: 'ttyt9': device_add
[   13.511259] device: 'ttyta': device_add
[   13.518478] device: 'ttytb': device_add
[   13.519269] device: 'ttytc': device_add
[   13.519913] device: 'ttytd': device_add
[   13.529504] device: 'ttyte': device_add
[   13.534331] device: 'ttytf': device_add
[   13.534968] device: 'ttyu0': device_add
[   13.535617] device: 'ttyu1': device_add
[   13.536283] device: 'ttyu2': device_add
[   13.542278] device: 'ttyu3': device_add
[   13.553177] device: 'ttyu4': device_add
[   13.553903] device: 'ttyu5': device_add
[   13.554788] device: 'ttyu6': device_add
[   13.555432] device: 'ttyu7': device_add
[   13.556185] device: 'ttyu8': device_add
[   13.556833] device: 'ttyu9': device_add
[   13.561383] device: 'ttyua': device_add
[   13.564727] device: 'ttyub': device_add
[   13.565392] device: 'ttyuc': device_add
[   13.566032] device: 'ttyud': device_add
[   13.567041] device: 'ttyue': device_add
[   13.567691] device: 'ttyuf': device_add
[   13.572576] device: 'ttyv0': device_add
[   13.573309] device: 'ttyv1': device_add
[   13.573950] device: 'ttyv2': device_add
[   13.577457] device: 'ttyv3': device_add
[   13.578215] device: 'ttyv4': device_add
[   13.578864] device: 'ttyv5': device_add
[   13.583502] device: 'ttyv6': device_add
[   13.584217] device: 'ttyv7': device_add
[   13.584874] device: 'ttyv8': device_add
[   13.585520] device: 'ttyv9': device_add
[   13.586155] device: 'ttyva': device_add
[   13.586799] device: 'ttyvb': device_add
[   13.594110] device: 'ttyvc': device_add
[   13.594847] device: 'ttyvd': device_add
[   13.595491] device: 'ttyve': device_add
[   13.596130] device: 'ttyvf': device_add
[   13.596883] device: 'ttyw0': device_add
[   13.597540] device: 'ttyw1': device_add
[   13.604768] device: 'ttyw2': device_add
[   13.605505] device: 'ttyw3': device_add
[   13.606656] device: 'ttyw4': device_add
[   13.607314] device: 'ttyw5': device_add
[   13.607953] device: 'ttyw6': device_add
[   13.608596] device: 'ttyw7': device_add
[   13.616368] device: 'ttyw8': device_add
[   13.617082] device: 'ttyw9': device_add
[   13.617736] device: 'ttywa': device_add
[   13.618383] device: 'ttywb': device_add
[   13.619142] device: 'ttywc': device_add
[   13.619786] device: 'ttywd': device_add
[   13.624399] device: 'ttywe': device_add
[   13.625128] device: 'ttywf': device_add
[   13.625777] device: 'ttyx0': device_add
[   13.629203] device: 'ttyx1': device_add
[   13.629857] device: 'ttyx2': device_add
[   13.630622] device: 'ttyx3': device_add
[   13.635280] device: 'ttyx4': device_add
[   13.636015] device: 'ttyx5': device_add
[   13.636662] device: 'ttyx6': device_add
[   13.637309] device: 'ttyx7': device_add
[   13.638078] device: 'ttyx8': device_add
[   13.641726] device: 'ttyx9': device_add
[   13.646344] device: 'ttyxa': device_add
[   13.647061] device: 'ttyxb': device_add
[   13.647730] device: 'ttyxc': device_add
[   13.648375] device: 'ttyxd': device_add
[   13.649016] device: 'ttyxe': device_add
[   13.649659] device: 'ttyxf': device_add
[   13.656828] device: 'ttyy0': device_add
[   13.657584] device: 'ttyy1': device_add
[   13.658221] device: 'ttyy2': device_add
[   13.658873] device: 'ttyy3': device_add
[   13.659629] device: 'ttyy4': device_add
[   13.660310] device: 'ttyy5': device_add
[   13.667511] device: 'ttyy6': device_add
[   13.668249] device: 'ttyy7': device_add
[   13.668904] device: 'ttyy8': device_add
[   13.669565] device: 'ttyy9': device_add
[   13.670601] device: 'ttyya': device_add
[   13.671254] device: 'ttyyb': device_add
[   13.675860] device: 'ttyyc': device_add
[   13.679473] device: 'ttyyd': device_add
[   13.680111] device: 'ttyye': device_add
[   13.680796] device: 'ttyyf': device_add
[   13.681562] device: 'ttyz0': device_add
[   13.682200] device: 'ttyz1': device_add
[   13.686798] device: 'ttyz2': device_add
[   13.687533] device: 'ttyz3': device_add
[   13.688177] device: 'ttyz4': device_add
[   13.691659] device: 'ttyz5': device_add
[   13.692313] device: 'ttyz6': device_add
[   13.692952] device: 'ttyz7': device_add
[   13.697811] device: 'ttyz8': device_add
[   13.698560] device: 'ttyz9': device_add
[   13.699199] device: 'ttyza': device_add
[   13.699842] device: 'ttyzb': device_add
[   13.700639] device: 'ttyzc': device_add
[   13.704194] device: 'ttyzd': device_add
[   13.708682] device: 'ttyze': device_add
[   13.709423] device: 'ttyzf': device_add
[   13.710065] device: 'ttya0': device_add
[   13.710881] device: 'ttya1': device_add
[   13.711532] device: 'ttya2': device_add
[   13.712176] device: 'ttya3': device_add
[   13.719750] device: 'ttya4': device_add
[   13.720537] device: 'ttya5': device_add
[   13.721177] device: 'ttya6': device_add
[   13.721823] device: 'ttya7': device_add
[   13.722586] device: 'ttya8': device_add
[   13.723226] device: 'ttya9': device_add
[   13.730755] device: 'ttyaa': device_add
[   13.731488] device: 'ttyab': device_add
[   13.732136] device: 'ttyac': device_add
[   13.732796] device: 'ttyad': device_add
[   13.733455] device: 'ttyae': device_add
[   13.734209] device: 'ttyaf': device_add
[   13.738881] device: 'ttyb0': device_add
[   13.742470] device: 'ttyb1': device_add
[   13.743109] device: 'ttyb2': device_add
[   13.743755] device: 'ttyb3': device_add
[   13.744517] device: 'ttyb4': device_add
[   13.745156] device: 'ttyb5': device_add
[   13.749650] device: 'ttyb6': device_add
[   13.750573] device: 'ttyb7': device_add
[   13.751222] device: 'ttyb8': device_add
[   13.754729] device: 'ttyb9': device_add
[   13.755380] device: 'ttyba': device_add
[   13.756023] device: 'ttybb': device_add
[   13.760938] device: 'ttybc': device_add
[   13.761680] device: 'ttybd': device_add
[   13.762340] device: 'ttybe': device_add
[   13.762977] device: 'ttybf': device_add
[   13.763740] device: 'ttyc0': device_add
[   13.767132] device: 'ttyc1': device_add
[   13.771907] device: 'ttyc2': device_add
[   13.772641] device: 'ttyc3': device_add
[   13.773296] device: 'ttyc4': device_add
[   13.773939] device: 'ttyc5': device_add
[   13.774701] device: 'ttyc6': device_add
[   13.775358] device: 'ttyc7': device_add
[   13.782782] device: 'ttyc8': device_add
[   13.783513] device: 'ttyc9': device_add
[   13.784155] device: 'ttyca': device_add
[   13.784801] device: 'ttycb': device_add
[   13.785577] device: 'ttycc': device_add
[   13.786253] device: 'ttycd': device_add
[   13.793834] device: 'ttyce': device_add
[   13.794571] device: 'ttycf': device_add
[   13.795211] device: 'ttyd0': device_add
[   13.795859] device: 'ttyd1': device_add
[   13.796505] device: 'ttyd2': device_add
[   13.797147] device: 'ttyd3': device_add
[   13.804719] device: 'ttyd4': device_add
[   13.805450] device: 'ttyd5': device_add
[   13.806233] device: 'ttyd6': device_add
[   13.806883] device: 'ttyd7': device_add
[   13.807658] device: 'ttyd8': device_add
[   13.808319] device: 'ttyd9': device_add
[   13.813136] device: 'ttyda': device_add
[   13.813876] device: 'ttydb': device_add
[   13.817434] device: 'ttydc': device_add
[   13.818073] device: 'ttydd': device_add
[   13.818719] device: 'ttyde': device_add
[   13.819364] device: 'ttydf': device_add
[   13.824071] device: 'ttye0': device_add
[   13.824798] device: 'ttye1': device_add
[   13.825466] device: 'ttye2': device_add
[   13.826109] device: 'ttye3': device_add
[   13.829551] device: 'ttye4': device_add
[   13.830301] device: 'ttye5': device_add
[   13.834766] device: 'ttye6': device_add
[   13.835525] device: 'ttye7': device_add
[   13.836165] device: 'ttye8': device_add
[   13.836809] device: 'ttye9': device_add
[   13.837451] device: 'ttyea': device_add
[   13.838198] device: 'ttyeb': device_add
[   13.845513] device: 'ttyec': device_add
[   13.846383] device: 'ttyed': device_add
[   13.847022] device: 'ttyee': device_add
[   13.847671] device: 'ttyef': device_add
[   13.848334] r3964: Philips r3964 Driver $Revision: 1.10 $
[   13.849199] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   13.850218] bus: 'pnp': add driver serial
[   13.850942] bus: 'pnp': driver_probe_device: matched device 00:05 with d=
river serial
[   13.854908] bus: 'pnp': really_probe: probing driver serial with device =
00:05
[   13.882538] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   13.883665] device: 'ttyS0': device_add
[   13.884487] driver: '00:05': driver_bound: bound to device 'serial'
[   13.885486] bus: 'pnp': really_probe: bound device 00:05 to driver serial
[   13.886670] Registering platform device 'serial8250'. Parent at platform
[   13.894870] device: 'serial8250': device_add
[   13.895632] bus: 'platform': add device serial8250
[   13.896512] device: 'ttyS1': device_add
[   13.897264] device: 'ttyS2': device_add
[   13.904990] device: 'ttyS3': device_add
[   13.905755] bus: 'platform': add driver serial8250
[   13.906536] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[   13.907932] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[   13.909261] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[   13.910514] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[   13.911897] bus: 'platform': add driver dw-apb-uart
[   13.912703] bus: 'spi': add driver max310x
[   13.913381] bus: 'platform': add driver uart-sccnxp
[   13.920810] bus: 'pci': add driver jsm
[   13.921542] bus: 'platform': add driver altera_jtaguart
[   13.922435] bus: 'pci': add driver rp2
[   13.923108] bus: 'pci': add driver isicom
[   13.930837] MOXA Smartio/Industio family driver version 2.0.5
[   13.931816] bus: 'pci': add driver mxser
[   13.932500] RocketPort device driver module, version 2.09, 12-June-2003
[   13.933576] No rocketport ports found; unloading driver
[   13.934523] SyncLink GT
[   13.934933] SyncLink GT, tty major#247
[   13.935548] bus: 'pci': add driver synclink_gt
[   13.936412] SyncLink GT no devices found
[   13.937042] SyncLink MultiPort driver $Revision: 4.38 $
[   13.937874] bus: 'pci': add driver synclinkmp
[   13.938730] device: 'ttySLM0': device_add
[   13.946294] device: 'ttySLM1': device_add
[   13.947063] device: 'ttySLM2': device_add
[   13.947743] device: 'ttySLM3': device_add
[   13.948422] device: 'ttySLM4': device_add
[   13.949089] device: 'ttySLM5': device_add
[   13.949759] device: 'ttySLM6': device_add
[   13.957261] device: 'ttySLM7': device_add
[   13.958037] device: 'ttySLM8': device_add
[   13.959058] device: 'ttySLM9': device_add
[   13.959732] device: 'ttySLM10': device_add
[   13.960592] device: 'ttySLM11': device_add
[   13.961287] device: 'ttySLM12': device_add
[   13.968895] device: 'ttySLM13': device_add
[   13.969688] device: 'ttySLM14': device_add
[   13.970776] device: 'ttySLM15': device_add
[   13.971481] device: 'ttySLM16': device_add
[   13.972161] device: 'ttySLM17': device_add
[   13.972851] device: 'ttySLM18': device_add
[   13.980374] device: 'ttySLM19': device_add
[   13.981130] device: 'ttySLM20': device_add
[   13.981816] device: 'ttySLM21': device_add
[   13.982794] device: 'ttySLM22': device_add
[   13.983651] device: 'ttySLM23': device_add
[   13.984347] device: 'ttySLM24': device_add
[   13.989117] device: 'ttySLM25': device_add
[   13.992957] device: 'ttySLM26': device_add
[   13.993656] device: 'ttySLM27': device_add
[   13.994353] device: 'ttySLM28': device_add
[   13.995035] device: 'ttySLM29': device_add
[   13.995724] device: 'ttySLM30': device_add
[   14.000992] device: 'ttySLM31': device_add
[   1
--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0e78c0989334e9c1d578ba25621de14e8441d8b4-bisect.log"

git checkout 08637024ab77f7defff1627cc8aedc2c6679ad8a
Previous HEAD position was 0e78c09... Add linux-next specific files for 20130318
HEAD is now at 0863702... Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs

2013-03-18-18:40:30 08637024ab77f7defff1627cc8aedc2c6679ad8a compiling
/home/wfg/mm

2013-03-18-18:44:03 detecting boot state 3.9.0-rc2-bisect3-00336-g0863702 #161 	7...	13 SUCCESS
bisect: good commit 08637024ab77f7defff1627cc8aedc2c6679ad8a
git bisect start 0e78c0989334e9c1d578ba25621de14e8441d8b4 08637024ab77f7defff1627cc8aedc2c6679ad8a --
Previous HEAD position was 0863702... Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
HEAD is now at 3c0eee3... Linux 2.6.37
Bisecting: 1551 revisions left to test after this (roughly 11 steps)
[5b4ab7cbdf1c0d93f5e7e14671c8b34ff081b928] Merge remote-tracking branch 'slab/for-next'
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-18:47:47 5b4ab7cbdf1c0d93f5e7e14671c8b34ff081b928 compiling
/home/wfg/mm

2013-03-18-18:51:31 detecting boot state 3.9.0-rc2-bisect3-01898-g5b4ab7c #162 ..	2	9	10..	13 SUCCESS
Bisecting: 820 revisions left to test after this (roughly 10 steps)
[a9dd67e06c062671c880f62087a6fe6d4096ec39] Revert "gpio/palmas: add in GPIO support for palmas charger"
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-18:56:04 a9dd67e06c062671c880f62087a6fe6d4096ec39 compiling
/home/wfg/mm

2013-03-18-18:59:40 detecting boot state 3.9.0-rc2-bisect3-02629-ga9dd67e #163  TEST FAILURE
Bisecting: 366 revisions left to test after this (roughly 9 steps)
[e8196b632b87f568668394fdc8b5053aa7918885] Merge remote-tracking branch 'regmap/for-next'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-19:00:13 e8196b632b87f568668394fdc8b5053aa7918885 compiling
/home/wfg/mm

2013-03-18-19:03:29 detecting boot state 3.9.0-rc2-bisect3-02262-ge8196b6 #164 	6... SUCCESS
Bisecting: 183 revisions left to test after this (roughly 8 steps)
[157dfaac1f2922a3cbd90685339511cb97cad225] staging: dwc2: fix compiler warnings
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-19:06:01 157dfaac1f2922a3cbd90685339511cb97cad225 compiling
/home/wfg/mm

2013-03-18-19:09:22 detecting boot state 3.9.0-rc1-bisect3-00183-g157dfaa #165 .	6	10..	11 SUCCESS
Bisecting: 110 revisions left to test after this (roughly 7 steps)
[a14592896023adcab12307774c89284ce0744ce2] staging: comedi: ni_labpc: fix common detach
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-19:12:54 a14592896023adcab12307774c89284ce0744ce2 compiling
/home/wfg/mm

2013-03-18-19:14:44 detecting boot state 3.9.0-rc1-bisect3-00256-ga145928 #166 	8...	12 SUCCESS
Bisecting: 51 revisions left to test after this (roughly 6 steps)
[9b53d29f3c8d2b9bfe73eb1dfb78a53b8c0fa2d7] Merge remote-tracking branch 'usb/usb-next'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-19:17:47 9b53d29f3c8d2b9bfe73eb1dfb78a53b8c0fa2d7 compiling
/home/wfg/mm

2013-03-18-19:21:24 detecting boot state 3.9.0-rc2-bisect3-02321-g9b53d29 #167  TEST FAILURE
Bisecting: 27 revisions left to test after this (roughly 5 steps)
[50418d050eaa3998e4be2936f5f05718909122ee] Merge remote-tracking branch 'tty/tty-next'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-19:21:56 50418d050eaa3998e4be2936f5f05718909122ee compiling
/home/wfg/mm

2013-03-18-19:23:52 detecting boot state 3.9.0-rc2-bisect3-02293-g50418d0 #168  TEST FAILURE
Bisecting: 15 revisions left to test after this (roughly 4 steps)
[d9a9770f7baea6171aa66e4070bdb9bf6f0402f3] Merge remote-tracking branch 'leds/for-next'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-19:24:23 d9a9770f7baea6171aa66e4070bdb9bf6f0402f3 compiling
/home/wfg/mm

2013-03-18-19:27:43 detecting boot state 3.9.0-rc2-bisect3-02277-gd9a9770 #169 	7... SUCCESS
Bisecting: 7 revisions left to test after this (roughly 3 steps)
[20cc225bab6709408840e4400cd1a5c2b28c7a52] tty: Fix spinlock flavor in non-atomic __tty_hangup()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-19:30:15 20cc225bab6709408840e4400cd1a5c2b28c7a52 compiling
/home/wfg/mm

2013-03-18-19:33:45 detecting boot state 3.9.0-rc2-bisect3-00008-g20cc225 #170 .	5	10..	12 SUCCESS
Bisecting: 3 revisions left to test after this (roughly 2 steps)
[afa80ccb4c7d39702dfb0832ce02a054848191a8] sysrq: fix inconstistent help message of sysrq key
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-19:37:17 afa80ccb4c7d39702dfb0832ce02a054848191a8 compiling
/home/wfg/mm

2013-03-18-19:39:10 detecting boot state 3.9.0-rc2-bisect3-00012-gafa80cc #171 	7..	8	12	17.. SUCCESS
Bisecting: 1 revision left to test after this (roughly 1 step)
[8f46baaa7ec6cd0851794020b31958e64679dd26] base: core: WARN() about bogus permissions on device attributes
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-19:43:41 8f46baaa7ec6cd0851794020b31958e64679dd26 compiling
/home/wfg/mm

2013-03-18-19:48:12 detecting boot state 3.9.0-rc2-bisect3-00002-g8f46baa #172  TEST FAILURE
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[be871b7e54711479d3b9d3617d49898770830db2] device: separate all subsys mutexes
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-03-18-19:48:43 be871b7e54711479d3b9d3617d49898770830db2 compiling
/home/wfg/mm

2013-03-18-19:51:44 detecting boot state 3.9.0-rc2-bisect3-00001-gbe871b7 #173 	8... SUCCESS
8f46baaa7ec6cd0851794020b31958e64679dd26 is the first bad commit
commit 8f46baaa7ec6cd0851794020b31958e64679dd26
Author: Felipe Balbi <balbi@ti.com>
Date:   Wed Feb 20 10:31:42 2013 +0200

    base: core: WARN() about bogus permissions on device attributes
    
    Whenever a struct device_attribute is registered
    with mismatched permissions - read permission without
    a show routine or write permission without store
    routine - we will issue a big warning so we catch
    those early enough.
    
    Signed-off-by: Felipe Balbi <balbi@ti.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 36f38f0cd03d98e064749d4e2d15c8a2a2462182 d0a082e6e07c736d43fb1e0cc4d4d9b8b4ecc17c M	drivers
bisect run success

2013-03-18-19:54:16 be871b7e54711479d3b9d3617d49898770830db2 compiling
/home/wfg/mm

2013-03-18-19:55:21 detecting boot state 3.9.0-rc2-bisect3-00001-gbe871b7 #173 .	2	10..	11	16	20..	22 SUCCESS

2013-03-18-20:01:29 0e78c0989334e9c1d578ba25621de14e8441d8b4 compiling
/home/wfg/mm

2013-03-18-20:06:05 detecting boot state 3.9.0-rc2-bisect3-next-20130318 #174  TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:58: main: $BISECT_TEST $KBUILD_OUTPUT
[detached HEAD 3154d2d] Revert "base: core: WARN() about bogus permissions on device attributes"
 1 file changed, 1 insertion(+), 8 deletions(-)

2013-03-18-20:06:38 3154d2d99b2718f54136409fc3836a90e896eedc compiling
/home/wfg/mm

2013-03-18-20:08:49 detecting boot state 3.9.0-rc2-bisect3-next-20130318-00001-g3154d2d #175 	5...	11	15...	25...	30 SUCCESS

========= linux-next =========
Fetching next

2013-03-18-20:16:34 0e78c0989334e9c1d578ba25621de14e8441d8b4 compiling
/home/wfg/mm

2013-03-18-20:18:58 detecting boot state 3.9.0-rc2-bisect3-next-20130318 #176 ..	1 TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:72: main: $BISECT_TEST $KBUILD_OUTPUT

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.9.0-rc2 Kernel Configuration
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
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
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
# CONFIG_SWAP is not set
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
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ALWAYS_USE_PERSISTENT_CLOCK=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
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
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_HAVE_UID16=y
CONFIG_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_WANT_INTEL_MID=y
# CONFIG_X86_MDFLD is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
CONFIG_X86_32_NON_STANDARD=y
CONFIG_X86_NUMAQ=y
# CONFIG_STA2X11 is not set
CONFIG_X86_SUMMIT=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
CONFIG_X86_SUMMIT_NUMA=y
CONFIG_X86_CYCLONE_TIMER=y
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
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_HIGHMEM64G=y
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_NUMA=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=4
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_NUMA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
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
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_GEOS=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
CONFIG_HOTPLUG_PCI_IBM=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IPGRE=y
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
CONFIG_IP_VS=y
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
# CONFIG_IP_VS_PROTO_UDP is not set
# CONFIG_IP_VS_PROTO_AH_ESP is not set
# CONFIG_IP_VS_PROTO_ESP is not set
# CONFIG_IP_VS_PROTO_AH is not set
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
# CONFIG_IP_VS_WRR is not set
# CONFIG_IP_VS_LC is not set
# CONFIG_IP_VS_WLC is not set
CONFIG_IP_VS_LBLC=y
CONFIG_IP_VS_LBLCR=y
# CONFIG_IP_VS_DH is not set
# CONFIG_IP_VS_SH is not set
CONFIG_IP_VS_SED=y
# CONFIG_IP_VS_NQ is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_FILTER is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
CONFIG_IP6_NF_IPTABLES=y
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
CONFIG_IP6_NF_FILTER=y
# CONFIG_IP6_NF_TARGET_REJECT is not set
# CONFIG_IP6_NF_MANGLE is not set
# CONFIG_IP6_NF_RAW is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=y
# CONFIG_RDS_RDMA is not set
CONFIG_RDS_TCP=y
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
# CONFIG_L2TP_IP is not set
# CONFIG_L2TP_ETH is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DAT is not set
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
# CONFIG_BAYCOM_SER_FDX is not set
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_YAM is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
CONFIG_CAN_MCP251X=y
CONFIG_CAN_JANZ_ICAN3=y
CONFIG_PCH_CAN=y
CONFIG_CAN_SJA1000=y
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=y
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=y
CONFIG_CAN_C_CAN_PCI=y
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=y
# CONFIG_CAN_CC770_PLATFORM is not set
CONFIG_CAN_SOFTING=y
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
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
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set
CONFIG_NFC_LLCP=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN544=y
CONFIG_NFC_MICROREAD=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=y
# CONFIG_BLOCKCONSOLE is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

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
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

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
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=y
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_HPSA is not set
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_MVSAS_TASKLET is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_IPS=y
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=y
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_NSP32=y
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_PMCRAID=y
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=y
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_CHELSIO_FCOE=y
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=y
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_MPIIX=y
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=y
CONFIG_PATA_PLATFORM=y
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_MII=y
CONFIG_IFB=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_RIONET is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y

#
# CAIF transport drivers
#

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
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
CONFIG_IGBVF=y
CONFIG_IXGB=y
# CONFIG_IXGBE is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_IP1000=y
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=y
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
CONFIG_KS8851=y
# CONFIG_KS8851_MLL is not set
CONFIG_KSZ884X_PCI=y
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_SFC=y
CONFIG_SFC_MCDI_MON=y
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
# CONFIG_WIZNET_W5300 is not set
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MICREL_KS8995MA=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOE=y
CONFIG_PPTP=y
CONFIG_PPPOL2TP=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_WLAN=y
CONFIG_AIRO=y
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_HOSTAP is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
# CONFIG_HDLC_RAW_ETH is not set
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y
# CONFIG_HDLC_X25 is not set
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=y
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300TOO=y
CONFIG_FARSYNC=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_LAPBETHER=y
CONFIG_X25_ASY=y
# CONFIG_SBNI is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
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
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_88PM860X is not set
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DA9034=y
# CONFIG_TOUCHSCREEN_DA9052 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=y
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
# CONFIG_NOZOMI is not set
CONFIG_ISI=y
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_TTY_PRINTK=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
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
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_INTEL_MID=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=y
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
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_GPIO=y

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
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_GPIO_TPS6586X=y
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_BATTERY_RX51=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7310 is not set
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_MC13783_ADC is not set

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
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_WM831X_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
# CONFIG_TWL4030_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
CONFIG_SCx200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_RDC321X_WDT=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

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
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_MFD_LM3533=y
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
# CONFIG_MFD_TWL4030_AUDIO is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_SMSC=y
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_TIMBERDALE=y
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_VX855=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_PALMAS is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_AS3711=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_TTM is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
# CONFIG_FB_MATROX_MAVEN is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_AAT2870 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_LP8788 is not set
CONFIG_BACKLIGHT_PANDORA=y
# CONFIG_BACKLIGHT_AS3711 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

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
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

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
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_HCD_SSB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_WM8350 is not set
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
CONFIG_INFINIBAND_AMSO1100=y
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_CXGB3=y
CONFIG_INFINIBAND_CXGB3_DEBUG=y
CONFIG_INFINIBAND_CXGB4=y
CONFIG_MLX4_INFINIBAND=y
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_OCRDMA=y
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
# CONFIG_INFINIBAND_IPOIB_DEBUG is not set
CONFIG_INFINIBAND_SRP=y
CONFIG_INFINIBAND_ISER=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
CONFIG_EDAC_E7XXX=y
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
CONFIG_EDAC_X38=y
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I82860=y
CONFIG_EDAC_R82600=y
CONFIG_EDAC_I5000=y
# CONFIG_EDAC_I5100 is not set
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
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
# CONFIG_RTC_DRV_88PM860X is not set
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8998=y
# CONFIG_RTC_DRV_MAX77686 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_TPS6586X is not set
# CONFIG_RTC_DRV_TPS65910 is not set
# CONFIG_RTC_DRV_TPS80031 is not set
# CONFIG_RTC_DRV_RC5T583 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1390=y
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_RX4581 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y
# CONFIG_RTC_DRV_WM8350 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC is not set
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
# CONFIG_DX_SEP is not set
CONFIG_ZRAM=y
# CONFIG_ZRAM_DEBUG is not set
CONFIG_ZSMALLOC=y
CONFIG_FB_SM7XX=y
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_DGRP is not set
CONFIG_FIREWIRE_SERIAL=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_VIRT_DRIVERS is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
# CONFIG_VME_USER is not set
# CONFIG_VME_PIO2 is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

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
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
# CONFIG_CIFS_DEBUG is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_SMB2=y
CONFIG_CIFS_FSCACHE=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
CONFIG_AFS_FSCACHE=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
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
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
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
# CONFIG_FUNCTION_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
CONFIG_MMIOTRACE=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y

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
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
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
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
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
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
CONFIG_DDR=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ISDN_DRV_LOOP is not set

--5mCyUwZo2JvN/JJP--
