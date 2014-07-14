Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbaGNR3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:29:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47211 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaGNR27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:28:59 -0400
Date: Mon, 14 Jul 2014 13:26:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 00/16] Enable support of IOAPIC hotplug on x86
 platforms
Message-ID: <20140714172642.GA12920@laptop.dumpdata.com>
References: <1403685648-10103-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1403685648-10103-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 25, 2014 at 04:40:31PM +0800, Jiang Liu wrote:
> This patch set enhances IOAPIC core and ACPI drivers to support IOAPIC
> hotplug on x86 platforms. It's based on tip/x86/apic.
> 
> You may pull it from 
> https://github.com/jiangliu/linux.git ioapic/hotplug_v3

With this patchset (on top of 3.16-rc5) my USB driver gets notified
it has interrupts but it thinks it does not have to acknowledge any.
I can only reproduce this under a 32-bit arch so far.

Please see the good.log and the bad.log 

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="good.log"
Content-Transfer-Encoding: quoted-printable

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-rc5upstream (konrad@build-external.du=
mpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP =
Mon Jul 14 12:56:47 EDT 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfeaffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000cfeb0000-0x00000000cfebdfff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000cfebe000-0x00000000cfedffff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000cfee0000-0x00000000cfefffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000ff700000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usa=
ble
[    0.000000] Malformed early option 'acpi'
[    0.000000] Early serial console at I/O port 0xe400 (options '115200n8=
')
[    0.000000] bootconsole [uart0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: ECS A780GM-A Ultra/A780GM-A Ultra, BIOS 080015  04/01=
/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000ffch_pfn =3D 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable =3D=3D> re=
served
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped a=
t [c00ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37800000-0x379fffff]
[    0.000000]  [mem 0x37800000-0x379fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x34000000-0x377fffff]
[    0.000000]  [mem 0x34000000-0x377fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37a00000-0x37bfdfff]
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] BRK [0x01a3a000, 0x01a3afff] PGTABLE
[    0.000000] RAMDISK: [mem 0x7aed7000-0x7fffefff]
[    0.000000] Allocated new RAMDISK: [mem 0x32ad6000-0x37bfd5f6]
[    0.000000] Move RAMDISK from [mem 0x7aed7000-0x7fffe5f6] to [mem 0x32=
ad6000-0x37bfd5f6]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FB100 000014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 0xCFEB0000 000040 (v01 040110 RSDT1316 20100401=
 MSFT 00000097)
[    0.000000] ACPI: FACP 0xCFEB0200 000084 (v01 040110 FACP1316 20100401=
 MSFT 00000097)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlo=
ck has zero address or length: 0x0000000000000000/0x1 (20140424/tbfadt-64=
9)
[    0.000000] ACPI: DSDT 0xCFEB0450 00A65F (v01 1AAAA  1AAAA000 00000000=
 INTL 20051117)
[    0.000000] ACPI: FACS 0xCFEBE000 000040
[    0.000000] ACPI: APIC 0xCFEB0390 00007C (v01 040110 APIC1316 20100401=
 MSFT 00000097)
[    0.000000] ACPI: MCFG 0xCFEB0410 00003C (v01 040110 OEMMCFG  20100401=
 MSFT 00000097)
[    0.000000] ACPI: OEMB 0xCFEBE040 000072 (v01 040110 OEMB1316 20100401=
 MSFT 00000097)
[    0.000000] ACPI: SRAT 0xCFEBAAB0 0000E8 (v03 AMD    FAM_F_10 00000002=
 AMD  00000001)
[    0.000000] ACPI: HPET 0xCFEBABA0 000038 (v01 040110 OEMHPET  20100401=
 MSFT 00000097)
[    0.000000] ACPI: SSDT 0xCFEBABE0 00088C (v01 A M I  POWERNOW 00000001=
 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 3716MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] BRK [0x01a3b000, 0x01a3bfff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x1fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xcfeaffff]
[    0.000000]   node   0: [mem 0x00000000-0x1fffffff]
[    0.000000] On node 0 totalpages: 982606
[    0.000000] free_area_init_node: node 0, pgdat c18471c0, node_mem_map =
f06d6020
[    0.000000]   DMA zone: 32 pages used for  0.000000]   DMA zone: 0 pag=
es reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 224254 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7433 pages used for memmap
[    0.000000]   HighMem zone: 754354 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] smpboot: Allowing 6 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e5fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e6000-0x000fffff]
[    0.000000] e820: [mem 0xcff00000-0xff6fffff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:6 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f0670000 s35072 r0 d22272 u=
57344
[    0.000000] pcpu-alloc: s35072 r0 d22272 u57344 alloc=3D14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 980822
[    0.000000] Kernel command line: initrd=3Dinitramfs.cpio.gz acpi=3Ddeb=
ug initcall_debug loglevel=3D10 nofb selinux=3D0 console=3Duart8250,io,0x=
e400,115200n8 BOOT_IMAGE=3Dvmlinuz=20
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 =
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 by=
tes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:00120000)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 3798696K/3930424K available (6259K kerwdata, 1852K=
 rodata, 944K init, 872K bss, 131728K reserved, 3017416K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc185c000 - 0xc1948000   ( 944 kB)
[    0.000000]       .data : 0xc161d1e7 - 0xc185ab40   (2294 kB)
[    0.000000]       .text : 0xc1000000 - 0xc161d1e7   (6260 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cpu_ids=3D6.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D6
[    0.000000] NR_IRQS:2304 nr_irqs:728 16
[    0.000000] CPU 0 irqstacks, hard=3Df0008000 soft=3Df000a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2999.912 MHz processor
[    0.000024] CalibratIPS (lpj=3D2999912)
[    0.011184] pid_max: default: 32768 minimum: 301
[    0.016080] ACPI: Core revision 20140424
[    0.095707] ACPI: All ACPI Tables successfully acquired
[    0.107537] Security Framework initialized
[    0.111842] SELinux:  Disabled at boot.
[    0.116061] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes=
)
[    0.123003] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 =
bytes)
[    0.131608] Initializing cgroup subsys freezer
[    0.136333] CPU: Physical Processor ID: 0
[    0.140542] CPU: Processor Core ID: 0
[    0.144391] mce: CPU supports 6 MCE banks
[    0.148607] LVT offset 0 assigned for vector 0xf9
[    0.153545] process: using AMD E400 aware idle routine
[    0.158942] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.158942] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
[    0.158942] tlb_flushall_shift: 6
[    0.175071] Freeing SMP alternatives memory: 28K (c1948000 - c194f000)
[    0.182933] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.188993] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.205285] smpboot: CPU0: AMD Phenom(tm) II X4 940 Processor (fam: 10=
, model: 04, stepping: 02)
[    0.315680] calling  xen_init_spinlocks_jump+0x0/0x23 @ 1
[    0.321350] initcall xen_init_spinlocks_jump+0x0/0x23 returned=20
[    0.328926] calling  set_real_mode_permissions+0x0/0x5d @ 1
[    0.334782] initcall set_real_mode_permissions+0x0/0x5d returned 0 aft=
er 0 usecs
[    0.342540] calling  trace_init_perf_perm_irq_work_exit+0x0/0x11 @ 1
[    0.349219] initcall trace_init_perf_perm_irq_work_exit+0x0/0x11 retur=
ned 0 after 0 usecs
[    0.357816] calling  trace_init_flags_sys_exit+0x0/0xe @ 1
[    0.363572] initcall trace_init_flags_sys_exit+0x0/0xe returned 0 afte=
r 0 usecs
[    0.371245] calling  trace_init_flags_sys_enter+0x0/0xe @ 1
[    0.377099] initcall trace_init_flags_sys_enter+0x0/0xe returned 0 aft=
er 0 usecs
[    0.384859] calling  init_hw_perf_events+0x0/0x52b @ 1
[    0.390250] Performance Events: AMD PMU driver.
[    0.395011] ... version:                0
[    0.399213] ... bit width:              48
[    0.403512] ... generic registers:      4
[    0.407714] ... value mask:             0000ffffffffffff
[    0.413290] ... max period:             00007fffffffffff
[    0.418866] ... fixed-purpose events:   0
[    0.423074] ... event mask:             000000000000000f
[    0.428692] initcall init_hw_perf_events+0x0/0x52b returned 0 after 87=
89 usecs
[    0.436276] calling  register_trigger_all_cpu_backtrace+0x0/0x13 @ 1
[    0.442946] initcall register_trigger_all_cpu_backtrace+0x0/0x13 retur=
ned 0 after 0 usecs
[    0.451538] calling  kvm_spinlock_init_jump+0x0/0x37 @ 1
[    0.457116] initcall kvm_spinlock_init_jump+0x0/0x37 returned 0 after =
0 usecs
[    0.464606] calling  spawn_ksoftirqd+0x0/0x23 @ 1
[    0.469570] initcall spawn_ksoftirqd+0x0/0x23 returned 0 after 0 usecs
[    0.476422] calling  init_workqueues+0x0/0x3e6 @ 1
[    0.481850] initcall init_workqueues+0x0/0x3e6 returned 0 after 976 us=
ecs
[    0.488983] calling  migration_init+0x0/0x5b @ 1
[    0.493818] initcall migration_init+0x0/0x5b returned 0 after 0 usecs
[    0.500586] calling  check_cpu_stall_init+0x0/0x16 @ 1
[    0.505981] initcall check_cpu_stall_init+0x0/0x16 returned 0 after 0 =
usecs
[    0.513294] calling  rcu_scheduler_really_started+0x0/0x11 @ 1
[    0.519412] initcall rcu_scheduler_really_started+0x0/0x11 returned 0 =
after 0 usecs
[    0.527453] calling  rcu_spawn_gp_kthread+0x0/0x87 @ 1
[    0.532899] initcall rcu_spawn_gp_kthread+0x0/0x87 returned 0 after 0 =
usecs
[    0.540212] calling  cpu_stop_init+0x0/0x5d @ 1
[    0.544999] initcall cpu_stop_init+0x0/0x5d returned 0 after 0 usecs
[    0.551671] calling  relay_init+0x0/0x11 @ 1
[    0.556154] initcall relay_init+0x0/0x11 returned 0 after 0 usecs
[    0.562545] calling  tracer_alloc_buffers+0x0/0x213 @ 1
[    0.568126] initcall tracer_alloc_buffers+0x0/0x213 returned 0 after 0=
 usecs
[    0.575524] calling  init_events+0x0/0x5f @ 1
[    0.580093] initcall init_events+0x0/0x5f returned 0 after 0 usecs
[    0.586577] calling  init_trace_printk+0x0/0xf @ 1
[    0.591605] initcall init_trace_printk+0x0/0xf returned 0 after 0 usec=
s
[    0.598555] calling  event_trace_memsetup+0x0/0x5a @ 1
[    0.603990] initcall event_trace_memsetup+0x0/0x5a returned 0 after 0 =
usecs
[    0.611308] calling  jump_label_init_module+0x0/0xf @ 1
[    0.616789] initcall jump_label_init_module+0x0/0xf returned 0 after 0=
 usecs
[    0.624187] calling  hashlib_init+0x0/0x11 @ 1
[    0.628849] initcall hashlib_init+0x0/0x11 returned 0 after 0 usecs
[    0.635434] calling  balloon_clear+0x0/0x3b @ 1
[    0.640184] initcall balloon_clear+0x0/0x3b returned 0 after 0 usecs
[    0.646861] calling  rand_initialize+0x0/0x30 @ 1
[    0.651824] initcall rand_initialize+0x0/0x30 returned 0 after 0 usecs
[    0.658690] calling  mce_amd_init+0x0/0x134 @ 1
[    0.663438] MCE: In-kernel MCE decoding enabled.
[    0.668279] initcall mce_amd_init+0x0/0x134 returned 0 after 976 usecs
[    0.675308] NMI watchdog: enabled on all CPUs, permanently consumes on=
e hw-PMU counter.
[    0.685492] CPU 1 irqstacks, hard=3Def820000 soft=3Def822000
[    0.691071] x86: Booting SMP configuration:
[    0.695457] .... node  #0, CPUs:      #1
[    0.710055] Initializing CPU#1
[    0.712568] process: System has AMD C1E enabled
[    0.713111] CPU 2 irqstacks, hard=3Df0   0.723662] Initializing CPU#2
[    0.726295] process: Switch to broadcast mode on CPU2
[    0.726838] CPU 3 irqstacks, hard=3Df02be000 soft=3Df0200000
[    0.737386]  #3
[    0.737386] Initializing CPU#3
[    0.739969] x86: Booted up 1 node, 4 CPUs
[    0.739970] smpboot: Total of 4 processors activated (23999.29 BogoMIP=
S)
[    0.740012] process: Switch to broadcast mode on CPU3
[    0.763735] process: Switch to broadcast mode on CPU1
[    0.774048] process: Switch to broadcast mode on CPU0
[    0.779677] devtmpfs: initialized
[    0.784095] calling  ipc_ns_i1] calling  init_cpufreq_transition_notif=
ier_list+0x0/0x18 @ 1
[    0.814461] initcall init_cpufreq_transition_notifier_list+0x0/0x18 re=
turned 0 after 0 usecs
[    0.823330] calling  net_ns_init+0x0/0x100 @ 1
[    0.828143] initcall net_ns_init+0x0/0x100 returned 0 after 0 usecs
[    0.834774] calling  e820_mark_nvs_memory+0x0/0x4e @ 1
[    0.840171] PM: Registering ACPI NVS region [mem 0xcfebe000-0xcfedffff=
] (139264 bytes)
[    0.848558] initcall e820_mark_nvs_memory+0x0/0x4e returned 0 after 97=
6 usecs
[    0.856042] calling  cpufreq_tsc+0x0/0x26 @ 1
[    0.860612] initcall cpufreq_tsc+0x0/0x26 returned 0 after 0 usecs
[    0.867102] calling  reboot_init+0x0/0x1a @ 1
[    0.871675] initcall reboot_init+0x0/0x1a returned 0 after 0 usecs
[    0.878178] calling  init_lapic_sysfs+0x0/0x1b @ 1
[    0.883211] initcall init_lapic_sysfs+0x0/0x1b returned 0 after 0 usec=
s
[    0.890167] calling  cpu_hotplug_pm_sync_init+0x0/0x29 @ 1
[    0.895919] initcall cpu_hotplug_pm_sync_init+0x0/0x29 returned 0 afte=
r 0 usecs
[    0.903593] calling  alloc_frozen_cpus+0x0/0x7 @ 1
[    0.908619] initcall alloc_frozen_cpus+0x0/0x7 returned 0 after 0 usec=
s
[    0.915558] calling  wq_sysfs_init+0x0/0x11 @ 1
[    0.920455] initcall wq_sysfs_init+0x0/0x11 returned 0 after 0 usecs
[    0.920565] kworker/u12:0 (30) used greatest stack depth: 6980 bytes l=
eft
[    0.934247] calling  ksysfs_init+0x0/0x74 @ 1
[    0.938892] initcall ksysfs_init+0x0/0x74 returned 0 after 0 usecs
[    0.945389] calling  pm_init+0x0/0x45 @ 1
[    0.949659] initcall pm_init+0x0/0x45 returned 0 after 0 usecs
[    0.955780] calling  pm_disk_init+0x0/0x14 @ 1
[    0.960472] initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs
[    0.967048] calling  swsusp_header_init+0x0/0x30 @ 1
[    0.972264] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 us=
ecs
[    0.979398] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.985075] initcall init_jiffies_clocksource+0x0/0xf returned 0 after=
 0 usecs
[    0.992667] calling  cgroup_wq_init+0x0/0x7c @ 1
[    0.997576] initcall cgroup_wq_init+0x0/0x7c returned 0 after 0 usecs
[    1.004341] calling  event_trace_enable+0x0/0x155 @ 1
[    1.010471] initcall event_trace_enable+0x0/0x155 returned 0 after 976=
 usecs
[    1.017870] calling  init_zero_pfn+0x0/0x14 @ 1
[    1.022618] initcall init_zero_pfn+0x0/0x14 returned 0 after 0 usecs
[    1.029290] calling  fsnotify_init+0x0/0x24 @ 1
[    1.034056] initcall fsnotify_init+0x0/0x24 returned 0 after 0 usecs
[    1.040734] calling  filelock_init+0x0/0x74 @ 1
[    1.045538] initcall filelock_init+0x0/0x74 returned 0 after 0 usecs
[    1.052204] calling  init_misc_binfmt+0x0/0x28 @ 1
[    1.057234] initcall init_misc_binfmt+0x0/0x28 returned 0 after 0 usec=
s
[    1.064178] calling  init_script_binfmt+0x0/0x13 @ 1
[    1.069386] initcall init_script_binfmt+0x0/0x13 returned 0 after 0 us=
ecs
[    1.076512] calling  init_elf_binfmt+0x0/0x13 @ 1
[    1.081442] initcall init_elf_binfmt+0x0/0x13 returned 0 after 0 usecs
[    1.088297] calling  debugfs_init+0x0/0x4a @ 1
[    1.092984] initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs
[    1.099563] calling  securityfs_init+0x0/0x41 @ 1
[    1.104514] initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs
[    1.111360] calling  prandom_init+0x0/0xaa @ 1
[    1.116021] initcall prandom_init+0x0/0xaa returned 0 after 0 usecs
[    1.122607] calling  virtio_init+0x0/0x30 @ 1
[    1.127259] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
[    1.133756] calling  early_resume_init+0x0/0x1a0 @ 1
[    1.138971] RTC time: 16:07:26, date: 07/14/14
[    1.143628] initcall early_resume_init+0x0/0x1a0 returned 0 after 976 =
usecs
[    1.150934] calling  cpufreq_core_init+0x0/0x29 @ 1
[    1.156050] initcall cpufreq_core_init+0x0/0x29 returned 0 after 0 use=
cs
[    1.163080] calling  cpuidle_init+0x0/0x36 @ 1
[    1.167769] initcall cpuidle_init+0x0/0x36 returned 0 after 0 usecs
[    1.174345] calling  bsp_pm_check_init+0x0/0x11 @ 1
[    1.179462] initcall bsp_pm_check_init+0x0/0x11 returned 0 after 0 use=
cs
[    1.186497] calling  sock_init+0x0/0x89 @ 1
[    1.191142] initcall sock_init+0x0/0x89 returned 0 after 0 usecs
[    1.197441] calling  net_inuse_init+0x0/0x24 @ 1
[    1.202308] initcall net_inuse_init+0x0/0x24 returned 0 after 0 usecs
[    1.209073] calling  netpoll_init+0x0/0x2e @ 1
[    1.213738] initcall netpoll_init+0x0/0x2e returned 0 after 0 usecs
[    1.220323] calling  netlink_proto_init+0x0/0x1a7 @ 1
[    1.225684] NET: Registered protocol family 16
[    1.230382] initcall netlink_proto_init+0x0/0x1a7 returned 0 after 976=
 usecs
[    1.237768] calling  __gnttab_init+0x0/0x30 @ 1
[    1.242516] initcall __gnttab_init+0x0/0x30 returned -19 after 0 usecs
[    1.249409] calling  bdi_class_init+0x0/0x40 @ 1
[    1.254419] initcall bdi_class_init+0x0/0x40 returned 0 after 0 usecs
[    1.261180] calling  mm_sysfs_init+0x0/0x22 @ 1
[    1.265947] initcall mm_sysfs_init+0x0/0x22 returned 0 after 0 usecs
[    1.272612] calling  kobject_uevent_init+0x0/0xf @ 1
[    1.277846] initcall kobject_uevent_init+0x0/0xf returned 0 after 0 us=
ecs
[    1.284970] calling  pcibus_class_init+0x0/0x14 @ 1
[    1.290122] initcall pcibus_class_init+0x0/0x14 returned 0 after 0 use=
cs
[    1.297162] calling  pci_driver_init+0x0/0xf @ 1
[    1.302088] initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
[    1.308850] calling  backlight_class_init+0x0/0x92 @ 1
[    1.314281] initcall backlight_class_init+0x0/0x92 returned 0 after 0 =
usecs
[    1.321586] calling  xenbus_init+0x0/0x24f @ 1
[    1.326248] initcall xenbus_init+0x0/0x24f returned -19 after 0 usecs
[    1.333008] calling  tty_class_init+0x0/0x2f @ 1
[    1.337884] initcall tty_class_init+0x0/0x2f returned 0 after 0 usecs
[    1.344645] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    1.350183] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 =
usecs
[    1.357493] calling  wakeup_sources_debugfs_init+0x0/0x2f @ 1
[    1.363532] initcall wakeup_sources_debugfs_init+0x0/0x2f returned 0 a=
fter 0 usecs
[    1.371480] calling  i2c_init+0x0/0x57 @ 1
[    1.375930] initcall i2c_init+0x0/0x57 returned 0 after 0 usecs
[    1.382138] calling  lguest_devices_init+0x0/0x13f @ 1
[    1.387527] initcall lguest_devices_init+0x0/0x13f returned 0 after 0 =
usecs
[    1.394846] calling  init_ladder+0x0/0xf @ 1
[    1.399326] cpuidle: using governor ladder
[    1.403623] initcall init_ladder+0x0/0xf returned 0 after 976 usecs
[    1.410195] calling  init_menu+0x0/0xf @ 1
[    1.414494] cpuidle: using governor menu
[    1.418611] initcall init_menu+0x0/0xf returned 0 after 976 usecs
[    1.425008] calling  amd_postcore_init+0x0/0x131 @ 1
[    1.430219] node 0 link 0: io port [1000, ffffff]
[    1.435161] TOM: 00000000d0000000 aka 3328M
[    1.439550] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    1.444939] node 0 link 0: mmio [a0000, bffff]
[    1.449611] node 0 link 0: mmio [d0000000, efffffff] =3D=3D> [d0000000=
, dfffffff]
[    1.457112] node 0 link 0: mmio [f0000000, fe6fffff]
[    1.462335] node 0 link 0: mmio [fe700000, fe8fffff]
[    1.467551] node 0 link 0: mmio [fe900000, ffefffff]
[    1.472760] TOM2: 0000000130000000 aka 4864M
[    1.477240] bus: [bus 00-07] on node 0 link 0
[    1.481810] bus: 00 [io  0x0000-0xffff]
[    1.485831] bus: 00 [mem 0x000a0000-0x000bffff]
[    1.490590] bus: 00 [mem 0xd0000000-0xdfffffff]
[    1.495350] bus: 00 [mem 0xf0000000-0xffffffff]
[    1.500102] bus: 00 [mem 0x130000000-0xfcffffffff]
[    1.505146] initcall amd_postcore_init+0x0/0x131 returned 0 after 1660=
1 usecs
[    1.512675] calling  boot_params_ksysfs_init+0x0/0x22f @ 1
[    1.518461] initcall boot_params_ksysfs_init+0x0/0x22f returned 0 afte=
r 0 usecs
[    1.526134] calling  arch_kdebugfs_init+0x0/0x2a6 @ 1
[    1.531466] initcall arch_kdebugfs_init+0x0/0x2a6 returned 0 after 0 u=
secs
[    1.538674] calling  init_pit_clocksource+0x0/0x36 @ 1
[    1.544063] initcall init_pit_clocksource+0x0/0x36 returned 0 after 0 =
usecs
[    1.551382] calling  mtrr_if_init+0x0/0x56 @ 1
[    1.556048] initcall mtrr_if_init+0x0/0x56 returned 0 after 0 usecs
[    1.562628] calling  ffh_cstate_init+0x0/0x27 @ 1
[    1.567559] initcall ffh_cstate_init+0x0/0x27 returned -1 after 0 usec=
s
[    1.574515] calling  kdump_buf_page_init+0x0/0x3a @ 1
[    1.579818] initcall kdump_buf_page_init+0x0/0x3a returned 0 after 0 u=
secs
[    1.587029] calling  activate_jump_labels+0x0/0x2d @ 1
[    1.592418] initcall activate_jump_labels+0x0/0x2d returned 0 after 0 =
usecs
[    1.599721] calling  acpi_pci_init+0x0/0x5b @ 1
[    1.604480] ACPI: bus type PCI registered
[    1.608683] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.615443] initcall acpi_pci_init+0x0/0x5b returned 0 after 1953 usec=
s
[    1.622395] calling  dma_bus_init+0x0/0xbb @ 1
[    1.627247] initcall dma_bus_init+0x0/0xbb returned 0 after 0 usecs
[    1.633830] calling  dma_channel_table_init+0x0/0xc4 @ 1
[    1.639523] initcall dma_channel_table_init+0x0/0xc4 returned 0 after =
976 usecs
[    1.647201] calling  setup_vcpu_hotplug_event+0x0/0x1f @ 1
[    1.652955] initcall setup_vcpu_hotplug_event+0x0/0x1f returned -19 af=
ter 0 usecs
[    1.660809] calling  register_xen_pci_notifier+0x0/0x30 @ 1
[    1.666655] initcall register_xen_pci_notifier+0x0/0x30 returned 0 aft=
er 0 usecs
[    1.674424] calling  xen_pcpu_init+0x0/0xc8 @ 1
[    1.679177] initcall xen_pcpu_init+0x0/0xc8 returned -19 after 0 usecs
[    1.686023] calling  dmi_id_init+0x0/0x2a2 @ 1
[    1.690977] initcall dmi_id_init+0x0/0x2a2 returned 0 after 0 usecs
[    1.697550] calling  dca_init+0x0/0x21 @ 1
[    1.701847] dca service started, version 1.12.1
[    1.706627] initcall dca_init+0x0/0x21 returned 0 after 976 usecs
[    1.713032] calling  pci_arch_init+0x0/0x65 @ 1
[    1.717797] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    1.727575] PCI: not using MMCONFIG
[    1.731892] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you w=
ant it NX.
[    1.739538] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D4
[    1.746202] PCI: Using configuration type 1 for base access
[    1.752058] PCI: Using configuration type 1 for extended access
[    1.758283] initcall pci_arch_init+0x0/0x65 returned 0 after 6835 usec=
s
[    1.765266] calling  topology_init+0x0/0x36 @ 1
[    1.770463] initcall topology_init+0x0/0x36 returned 0 after 976 usecs
[    1.777325] calling  mtrr_init_finialize+0x0/0x30 @ 1
[    1.782624] initcall mtrr_init_finialize+0x0/0x30 returned 0 after 0 u=
secs
[    1.789843] calling  uid_cache_init+0x0/0x7e @ 1
[    1.794716] initcall uid_cache_init+0x0/0x7e returned 0 after 0 usecs
[    1.801471] calling  param_sysfs_init+0x0/0x14c @ 1
[    1.819498] initcall param_sysfs_init+0x0/0x14c returned 0 after 12695=
 usecs
[    1.826902] calling  proc_schedstat_init+0x0[    1.848428] initcall pm=
_sysrq_init+0x0/0x16 returned 0 after 4882 usecs
[    1.855380] calling  create_proc_profile+0x0/0x1e0 @ 1
[    1.860771] initcall create_proc_profile+0x0/0x1e0 returned 0 after 0 =
usecs
[    1.868086] calling  crash_save_vmcoreinfo_init+0x0/0x5ad @ 1
[    1.874127] initcall crash_save_vmcoreinfo_init+0x0/0x5ad returned 0 a=
fter 0 usecs
[    1.882078] calling  crash_notes_memory_init+0x0/0x35 @ 1
[    1.887759] initcall crash_notes_memory_init+0x0/0x35 returned 0 after=
 0 usecs
[    1.895353] calling  hung_task_init+0x0/0x56 @ 1
[    1.900252] initcall hung_task_init+0x0/0x56 returned 0 after 0 usecs
[    1.907025] calling  default_bdi_init+0x0/0x78 @ 1
[    1.912552] initcall default_bdi_init+0x0/0x78 returned 0 after 976 us=
ecs
[    1.919682] calling  init_reserve_notifier+0x0/0x7 @ 1
[    1.925066] initcall init_reserve_notifier+0x0/0x7 returned 0 after 0 =
usecs
[    1.932375] calling  init_admin_reserve+0x0/0x30 @ 1
[    1.937573] initcall init_admin_reserve+0x0/0x30 returned 0 after 0 us=
ecs
[    1.944700] calling  init_user_reserve+0x0/0x30 @ 1
[    1.949825] initcall init_user_reserve+0x0/0x30 returned 0 after 0 use=
cs
[    1.956860] calling  mmu_notifier_init+0x0/0xf @ 1
[    1.961899] initcall mmu_notifier_init+0x0/0xf returned 0 after 0 usec=
s
[    1.968842] calling  hugepage_init+0x0/0x123 @ 1
[    1.973896] initcall hugepage_init+0x0/0x123 returned 0 after 0 usecs
[    1.980675] calling  crypto_wq_init+0x0/0x41 @ 1
[    1.985595] initcall crypto_wq_init+0x0/0x41 returned 0 after 0 usecs
[    1.992360] calling  cryptomgr_init+0x0/0xf @ 1
[    1.997121] initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
[    2.003801] calling  init_bio+0x0/0xc5 @ 1
[    2.008479] initcall init_bio+0x0/0xc5 returned 0 after 0 usecs
[    2.014707] calling  blk_settings_init+0x0/0x21 @ 1
[    2.019831] initcall blk_settings_init+0x0/0x21 returned 0 after 0 use=
cs
[    2.026863] calling  blk_ioc_init+0x0/0x2f @ 1
[    2.031576] initcall blk_ioc_init+0x0/0x2f returned 0 after 0 usecs
[    2.038160] calling  blk_softirq_init+0x0/0x54 @ 1
[    2.043188] initcall blk_softirq_init+0x0/0x54 returned 0 after 0 usec=
s
[    2.050133] calling  blk_iopoll_setup+0x0/0x54 @ 1
[    2.055159] initcall blk_iopoll_setup+0x0/0x54 returned 0 after 0 usec=
s
[    2.062106] calling  blk_mq_init+0x0/0x16 @ 1
[    2.066677] initcall blk_mq_init+0x0/0x16 returned 0 after 0 usecs
[    2.073169] calling  genhd_device_init+0x0/0x6a @ 1
[    2.078471] initcall genhd_device_init+0x0/0x6a returned 0 after 0 use=
cs
[    2.085512] calling  blk_dev_integrity_init+0x0/0x2f @ 1
[    2.091110] initcall blk_dev_integrity_init+0x0/0x2f returned 0 after =
0 usecs
[    2.098603] calling  pci_slot_init+0x0/0x40 @ 1
[    2.103365] initcall pci_slot_init+0x0/0x40 returned 0 after 0 usecs
[    2.110031] calling  fbmem_init+0x0/0x96 @ 1
[    2.114561] initcall fbmem_init+0x0/0x96 returned 0 after 0 usecs
[    2.120956] calling  acpi_init+0x0/0x26b @ 1
[    2.125536] ACPI: Added _OSI(Module Device)
[    2.129924] ACPI: Added _OSI(Processor Device)
[    2.134582] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.139522] ACPI: Added _OSI(Processor Aggregator Device)
[    2.159553] ACPI: Executed 4 blocks of module-level executable AML cod=
e
[    2.247057] ACPI: Interpreter enabled
[    2.250913] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S1_] (201_S2_] (20140424/hwxface-580)
[    2.270359] ACPI: (supports S0 S3 S4 S5)
[    2.274472] ACPI: Using IOAPIC for interrupt routing
[    2.279858] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    2.320569] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in A=
CPI motherboard resources
[    2.329693] PCI: Using MMCONFIG for extended config space
[    2.335460] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    2.475524] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.482027] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM Cl=
ockPM Segments MSI]
[    2.490666] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASP=
M
[    2.499704] acpi PNP0A03:00: ignoring host bridge window [mem 0x000d00=
00-0x000dffff] (conflicts with Adapter ROM [mem 0x000cf000-0x000d09ff])
[    2.514861] PCI host bridge to bus 0000:00
[    2.519166] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.524922] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.531413] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.537903] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    2.545118] pci_bus 0000:00: root bus resource [mem 0xcff00000-0xdffff=
fff]
[    2.552336] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebff=
fff]
[    2.559579] pci 0000:00:00.0: [1022:9600] type 00 class 0x060000
[    2.566768] pci 0000:00:01.0: [1022:9602] type 01 class 0x060400
[    2.573909] pci 0000:00:06.0: [1022:9606] type 01 class 0x060400
[    2.580251] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    2.587224] pci 0000:00:06.0: System wakeup disabled by ACPI
[    2.593552] pci 0000:00:07.0: [1022:9607] type 01 class 0x060400
[    2.599893] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    2.606879] pci 0000:00:07.0: System wakeup disabled by ACPI
[    2.613220] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    2.619536] pci 0000:00:11.0: reg 0x10: [io  0x7000-0x7007]
[    2.625384] pci 0000:00:11.0: reg 0x14: [io  0x6000-0x6003]
[    2.631241] pci 0000:00:11.0: reg 0x18: [io  0x5000-0x5007]
[    2.637092] pci 0000:00:11.0: reg 0x1c: [io  0x4000-0x4003]
[    2.642948] pci 0000:00:11.0: reg 0x20: [io  0x3000-0x300f]
[    2.648800] pci 0000:00:11.0: reg 0x24: [mem 0xfe6ffc00-0xfe6fffff]
[    2.656238] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    2.662546] pci 0000:00:12.0: reg 0x10: [mem 0xfe6fe000-0xfe6fefff]
[    2.669757] pci 0000:00:12.0: System wakeup disabled by ACPI
[    2.676081] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
[    2.682389] pci 0000:00:12.1: reg 0x10: [mem 0xfe6fd000-0xfe6fdfff]
[    2.689605] pci 0000:00:12.1: System wakeup disabled by ACPI
[    2.695928] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    2.702244] pci 0000:00:12.2: reg 0x10: [mem 0xfe6ff800-0xfe6ff8ff]
[    2.708910] pci 0000:00:12.2: supports D1 D2
[    2.713393] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    2.720280] pci 0000:00:12.2: System wakeup disabled by ACPI
[    2.726612] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    2.732921] pci 0000:00:13.0: reg 0x10: [mem 0xfe6fc000-0xfe6fcfff]
[    2.740131] pci 0000:00:13.0: System wakeup disabled by ACPI
[    2.746445] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
[    2.752756] pci 0000:00:13.1: reg 0x10: [mem 0xfe6f7000-0xfe6f7fff]
[    2.759974] pci 0000:00:13.1: System wakeup disabled by ACPI
[    2.766298] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    2.772623] pci 0000:00:13.2: reg 0x10: [mem 0xfe6ff400-0xfe6ff4ff]
[    2.779282] pci 0000:00:13.2: supports D1 D2
[    2.783761] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    2.790644] pci 0000:00:13.2: System wakeup disabled by ACPI
[    2.796972] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    2.804175] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    2.811349] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    2.818258] pci 0000:00:14.4: System wakeup disabled by ACPI
[    2.824567] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    2.830878] pci 0000:00:14.5: reg 0x10: [mem 0xfe6f6000-0xfe6f6fff]
[    2.838086] pci 0000:00:14.5: System wakeup disabled by ACPI
[    2.844397] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    2.851468] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    2.858545] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    2.865621] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    2.872700] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    2.880071] pci 0000:01:05.0: [1002:9610] type 00 class 0x030000
[    2.886374] pci 0000:01:05.0: reg 0x10: [mem 0xd0000000-0xdfffffff pre=
f]
[    2.893411] pci 0000:01:05.0: reg 0x14: [io  0x8000-0x80ff]
[    2.899256] pci 0000:01:05.0: reg 0x18: [mem 0xfe8f0000-0xfe8fffff]
[    2.905839] pci 0000:01:05.0: reg 0x24: [mem 0xfe700000-0xfe7fffff]
[    2.912432] pci 0000:01:05.0: supports D1 D2
[    2.917353] pci 0000:01:05.1: [1002:960f] type 00 class 0x040300
[    2.923664] pci 0000:01:05.1: reg 0x10: [mem 0xfe8e8000-0xfe8ebfff]
[    2.930271] pci 0000:01:05.1: supports D1 D2
[    2.935121] pci 0000:00:01.0: PCI bridge to [bus 01]
[    2.940330] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    2.946721] pci 0000:00:01.0:   bridge window [mem 0xfe700000-0xfe8fff=
ff]
[    2.953844] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffff=
ff 64bit pref]
[    2.962232] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    2.968549] pci 0000:02:00.0: reg 0x10: [io  0x9800-0x98ff]
[    2.974415] pci 0000:02:00.0: reg 0x18: [mem 0xfe9ff000-0xfe9fffff 64b=
it]
[    2.981554] pci 0000:02:00.0: reg 0x20: [mem 0xfdff0000-0xfdffffff 64b=
it pref]
[    2.989139] pci 0000:02:00.0: reg 0x30: [mem 0xfe9c0000-0xfe9dffff pre=
f]
[    2.996232] pci 0000:02:00.0: supports D1 D2
[    3.000709] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    3.009230] pci 0000:00:06.0: PCI bridge to [bus 02]
[    3.014459] pci 0000:00:06.0:   bridge window [io  0x9000-0x9fff]
[    3.020852] pci 0000:00:06.0:   bridge window [mem 0xfe900000-0xfe9fff=
ff]
[    3.027981] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffff=
ff 64bit pref]
[    3.036354] pci 0000:03:00.0: [197b:2361] type 00 class 0x010601
[    3.042725] pci 0000:03:00.0: reg 0x24: [mem 0xfeafe000-0xfeafffff]
[    3.049351] pci 0000:03:00.0: PME# supported from D3hot
[    3.055290] pci 0000:03:00.1: [197b:2361] type 00 class 0x010185
[    3.061615] pci 0000:03:00.1: reg 0x10: [io  0xb800-0xb807]
[    3.067473] pci 0000:03:00.1: reg 0x14: [io  0xb400-0xb403]
[    3.073322] pci 0000:03:00.1: reg 0x18: [io  0xb000-0xb007]
[    3.079184] pci 0000:03:00.1: reg 0x1c: [io  0xa800-0xa803]
[    3.085031] pci 0000:03:00.1: reg 0x20: [io  0xa400-0xa40f]
[    3.091248] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    3.101756] pci 0000:00:07.0: PCI bridge to [bus 03]
[    3.106964] pci 0000:00:07.0:   bridge window [io  0xa000-0xbfff]
[    3.113362] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafff=
ff]
[    3.120733] pci 0000:04:05.0: [10b7:1700] type 00 class 0x020000
[    3.127061] pci 0000:04:05.0: reg 0x10: [mem 0xfebfc000-0xfebfffff]
[    3.133650] pci 0000:04:05.0: reg 0x14: [io  0xe800-0xe8ff]
[    3.139545] pci 0000:04:05.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pre=
f]
[    3.146619] pci 0000:04:05.0: supports D1 D2
[    3.151097] pci 0000:04:05.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    3.158523] pci 0000:04:07.0: [9710:9835] type 00 class 0x070002
[    3.164843] pci 0000:04:07.0: reg 0x10: [io  0xe400-0xe407]
[    3.170696] pci 0000:04:07.0: reg 0x14: [io  0xe000-0xe007]
[    3.176557] pci 0000:04:07.0: reg 0x18: [io  0xd800-0xd807]
[    3.182414] pci 0000:04:07.0: reg 0x1c: [io  0xd400-0xd407]
[    3.188270] pci 0000:04:07.0: reg 0x20: [io  0xd000-0xd007]
[    3.194142] pci 0000:04:07.0: reg 0x24: [io  0xc800-0xc80f]
[    3.200380] pci 0000:00:14.4: PCI bridge to [bus 04] (subtractive deco=
de)
[    3.207512] pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]
[    3.213907] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfff=
ff]
[    3.221038] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (sub=
tractive decode)
[    3.229356] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
[    3.237674] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
[    3.246725] pci 0000:00:14.4:   bridge window [mem 0xcff00000-0xdfffff=
ff] (subtractive decode)
[    3.255772] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfff=
ff] (subtractive decode)
[    3.264832] pci_bus 0000:00: on NUMA node 0
[    3.296018] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 *14 15)
[    3.303461] ACPI: PCI Interrupt Link [LNKB] (IRQs  3.325779] ACPI: PCI=
 Interrupt Link [LNKE] (IRQs *4 10 11 12 14 15)
[    3.333037] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 10 11 12 14 15) *0=
, disabled.
[    3.341493] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 10 11 12 14 *15)
[    3.348751] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 10 11 12 14 15) *0=
, disabled.
[    3.357175] ACPI: Enabled 1 GPEs in block 00 to 1F
[    3.362323] initcall acpi_init+0x0/0x26b returned 0 after 476562 usecs
[    3.369176] calling  pnp_init+0x0/0xf @ 1
[    3.373473] initcall pnp_init+0x0/0xf returned 0 after 0 usecs
[    3.379606] calling  balloon_init+0x0/0x1fa @ 1
[    3.384360] initcall balloon_init+0x0/0x1fa returned -19 after 0 usecs
[    3.391209] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
[    3.396967] initcall xen_setup_shutdown_event+0x0/0x30 returned -19 af=
ter 0 usecs
[    3.404814] calling  xenbus_probe_backend_init+0x0/0x23 @ 1
[    3.410750] initcall xenbus_probe_backend_init+0x0/0x23 returned 0 aft=
er 976 usecs
[    3.418700] calling  xenbus_probe_frontend_init+0x0/0x7b @ 1
[    3.424738] initcall xenbus_probe_frontend_init+0x0/0x7b returned 0 af=
ter 976 usecs
[    3.432784] calling  xen_acpi_pad_init+0x0/0x41 @ 1
[    3.437907] initcall xen_acpi_pad_init+0x0/0x41 returned -19 after 0 u=
secs
[    3.445124] calling  balloon_init+0x0/0xdd @ 1
[    3.449776] initcall balloon_init+0x0/0xdd returned -19 after 0 usecs
[    3.456545] calling  misc_init+0x0/0xad @ 1
[    3.460971] initcall misc_init+0x0/0xad returned 0 after 0 usecs
[    3.467281] calling  vga_arb_device_init+0x0/0xcc @ 1
[    3.472776] vgaarb: device added: PCI:0000:01:05.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    3.481273] vgaarb: loaded
[    3.484104] vgaarb: bridge control possible 0000:01:05.0
[    3.489674] initcall vga_arb_device_init+0x0/0xcc returned 0 after 166=
01 usecs
[    3.497263] calling  cn_init+0x0/0xb0 @ 1
[    3.501493] initcall cn_init+0x0/0xb0 returned 0 after 0 usecs
[    3.507622] calling  dma_buf_init+0x0/0x62 @ 1
[    3.512296] initcall dma_buf_init+0x0/0x62 returned 0 after 0 usecs
[    3.518884] calling  phy_init+0x0/0x2f @ 1
[    3.523417] initcall phy_init+0x0/0x2f returned 0 after 0 usecs
[    3.529645] calling  init_pcmcia_cs+0x0/0x32 @ 1
[    3.534517] initcall init_pcmcia_cs+0x0/0x32 returned 0 after 0 usecs
[    3.541276] calling  usb_init+0x0/0x14c @ 1
[    3.545685] ACPI: bus type USB registered
[    3.550087] usbcore: registered new interface driver usbfs
[    3.555935] usbcore: registered new interface driver hub
[    3.561622] usbcore: registered new device driver usb
[    3.566932] initcall usb_init+0x0/0x14c returned 0 after 20507 usecs
[    3.573606] calling  serio_init+0x0/0x2e @ 1
[    3.578158] initcall serio_init+0x0/0x2e returned 0 after 0 usecs
[    3.584554] calling  input_init+0x0/0xf1 @ 1
[    3.589079] initcall input_init+0x0/0xf1 returned 0 after 0 usecs
[    3.595480] calling  rtc_init+0x0/0x50 @ 1
[    3.599801] initcall rtc_init+0x0/0x50 returned 0 after 0 usecs
[    3.606016] calling  pps_init+0x0/0xa6 @ 1
[    3.610352] pps_core: LinuxPPS API ver. 1 registered
[    3.615565] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    3.625147] initcall pps_init+0x0/0xa6 returned 0 after 14648 usecs
[    3.631728] calling  ptp_init+0x0/0x8e @ 1
[    3.636061] PTP clock support registered
[    3.640176] initcall ptp_init+0x0/0x8e returned 0 after 3906 usecs
[    3.646665] calling  power_supply_class_init+0x0/0x39 @ 1
[    3.652362] initcall power_supply_class_init+0x0/0x39 returned 0 after=
 0 usecs
[    3.659945] calling  hwmon_init+0x0/0xda @ 1
[    3.664457] initcall hwmon_init+0x0/0xda returned 0 after 0 usecs
[    3.670859] calling  leds_init+0x0/0x36 @ 1
[    3.675281] initcall leds_init+0x0/0x36 returned 0 after 0 usecs
[    3.681596] calling  efisubsys_init+0x0/0x115 @ 1
[    3.686529] initcall efisubsys_init+0x0/0x115 returned 0 after 0 usecs
[    3.693373] calling  pci_subsys_init+0x0/0x48 @ 1
[    3.698307] PCI: Using ACPI for IRQ routing
[    3.702699] PCI: pci_cache_line_size set to 64 bytes
[    3.707960] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    3.714263] e820: reserve RAM buffer [mem 0xcfeb0000-0xcfffffff]
[    3.720572] initcall pci_subsys_init+0x0/0x48 returned 0 after 22460 u=
secs
[    3.727796] calling  proto_init+0x0/0xf @ 1
[    3.732192] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    3.738502] calling  net_dev_init+0x0/0x15d @ 1
[    3.744107] initcall net_dev_init+0x0/0x15d returned 0 after 976 usecs
[    3.750963] calling  neigh_init+0x0/0xa4 @ 1
[    3.755447] initcall neigh_init+0x0/0xa4 returned 0 after 0 usecs
[    3.761851] calling  fib_rules_init+0x0/0xbd @ 1
[    3.766689] initcall fib_rules_init+0x0/0xbd returned 0 after 0 usecs
[    3.773448] calling  pktsched_init+0x0/0x121 @ 1
[    3.778303] initcall pktsched_init+0x0/0x121 returned 0 after 0 usecs
[    3.785066] calling  tc_filter_init+0x0/0x6a @ 1
[    3.789902] initcall tc_filter_init+0x0/0x6a returned 0 after 0 usecs
[    3.796660] calling  tc_action_init+0x0/0x6a @ 1
[    3.801502] initcall tc_action_init+0x0/0x6a returned 0 after 0 usecs
[    3.808275] calling  genl_init+0x0/0x7a @ 1
[    3.812681] initcall genl_init+0x0/0x7a returned 0 after 0 usecs
[    3.818987] calling  cipso_v4_init+0x0/0x5a @ 1
[    3.823740] initcall cipso_v4_init+0x0/0x5a returned 0 after 0 usecs
[    3.830412] calling  netlbl_init+0x0/0x7d @ 1
[    3.834985] NetLabel: Initializing
[    3.838554] NetLabel:  domain hash size =3D 128
[    3.843116] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    3.848392] NetLabel:  unlabeled traffic allowed by default
[    3.854241] initcall netlbl_init+0x0/0x7d returned 0 after 18554 usecs
[    3.861089] calling  rfkill_init+0x0/0x68 @ 1
[    3.865806] initcall rfkill_init+0x0/0x68 returned 0 after 0 usecs
[    3.872313] calling  xen_mcfg_late+0x0/0xa6 @ 1
[    3.877068] initcall xen_mcfg_late+0x0/0xa6 returned 0 after 0 usecs
[    3.883793] calling  xen_p2m_debugfs+0x0/0x49 @ 1
[    3.888745] initcall xen_p2m_debugfs+0x0/0x49 returned 0 after 0 usecs
[    3.895602] calling  xen_spinlock_debugfs+0x0/0x120 @ 1
[    3.901135] initcall xen_spinlock_debugfs+0x0/0x120 returned 0 after 0=
 usecs
[    3.908531] calling  nmi_warning_debugfs+0x0/0x26 @ 1
[    3.913838] initcall nmi_warning_debugfs+0x0/0x26 returned 0 after 0 u=
secs
[    3.921052] calling  hpet_late_init+0x0/0xe6 @ 1
[    3.925905] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    3.931326] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    3.939454] initcall hpet_late_init+0x0/0xe6 returned 0 after 13671 us=
ecs
[    3.946581] calling  init_amd_nbs+0x0/0xb6 @ 1
[    3.951267] initcall init_amd_nbs+0x0/0xb6 returned 0 after 0 usecs
[    3.957846] calling  clocksource_done_booting+0x0/0x3b @ 1
[    3.963614] Switched to clocksource hpet
[    3.967776] initcall clocksource_done_booting+0x0/0x3b returned 0 afte=
r 4074 usecs
[    3.975779] calling  tracer_init_debugfs+0x0/0x165 @ 1
[    3.981675] initcall tracer_init_debugfs+0x0/0x165 returned 0 after 48=
4 usecs
[    3.989181] calling  init_trace_printk_function_export+0x0/0x33 @ 1
[    3.995772] initcall init_trace_printk_function_export+0x0/0x33 return=
ed 0 after 7 usecs
[    4.004271] calling  event_trace_init+0x0/0x1ee @ 1
[    4.029653] initcall event_trace_init+0x0/0x1ee returned 0 after 19803=
 usecs
[    4.037063] calling  init_kprobe_trace+0x0/0_trace+0x0/0x92 returned 0=
 after 12 usecs
[    4.049331] calling  init_pipe_fs+0x0/0x3d @ 1
[    4.054111] initcall init_pipe_fs+0x0/0x3d returned 0 after 109 usecs
[    4.060881] calling  eventpoll_init+0x0/0xd0 @ 1
[    4.065829] initcall eventpoll_init+0x0/0xd0 returned 0 after 88 usecs
[    4.072687] calling  anon_inode_init+0x0/0x56 @ 1
[    4.077737] initcall anon_inode_init+0x0/0x56 returned 0 after 99 usec=
s
[    4.084688] calling  proc_cmdline_init+0x0/0x27 @ 1
[    4.089822] initcall proc_cmdline_init+0x0/0x27 returned 0 after 8 use=
cs
[    4.096864] calling  proc_consoles_init+0x0/0x27 @ 1
[    4.102089] initcall proc_consoles_init+0x0/0x27 returned 0 after 6 us=
ecs
[    4.109223] calling  proc_cpuinfo_init+0x0/0x27 @ 1
[    4.114357] initcall proc_cpuinfo_init+0x0/0x27 returned 0 after 6 use=
cs
[    4.121392] calling  proc_devices_init+0x0/0x27 @ 1
[    4.126525] initcall proc_devices_init+0x0/0x27 returned 0 after 6 use=
cs
[    4.133565] calling  proc_interrupts_init+0x0/0x27 @ 1
[    4.138969] initcall proc_interrupts_init+0x0/0x27 returned 0 after 6 =
usecs
[    4.146288] calling  proc_loadavg_init+0x0/0x27 @ 1
[    4.151414] initcall proc_loadavg_init+0x0/0x27 returned 0 after 5 use=
cs
[    4.158474] calling  proc_meminfo_init+0x0/0x27 @ 1
[    4.163613] initcall proc_meminfo_init+0x0/0x27 returned 0 after 6 use=
cs
[    4.170673] calling  proc_stat_init+0x0/0x27 @ 1
[    4.175549] initcall proc_stat_init+0x0/0x27 returned 0 after 6 usecs
[    4.182321] calling  proc_uptime_init+0x0/0x27 @ 1
[    4.187369] initcall proc_uptime_init+0x0/0x27 returned 0 after 6 usec=
s
[    4.194321] calling  proc_version_init+0x0/0x27 @ 1
[    4.199459] initcall proc_version_init+0x0/0x27 returned 0 after 6 use=
cs
[    4.206505] calling  proc_softirqs_init+0x0/0x27 @ 1
[    4.211735] initcall proc_softirqs_init+0x0/0x27 returned 0 after 6 us=
ecs
[    4.218878] calling  proc_kcore_init+0x0/0xae @ 1
[    4.223831] initcall proc_kcore_init+0x0/0xae returned 0 after 9 usecs
[    4.230692] calling  vmcore_init+0x0/0x68b @ 1
[    4.235376] initcall vmcore_init+0x0/0x68b returned 0 after 5 usecs
[    4.241974] calling  proc_kmsg_init+0x0/0x2a @ 1
[    4.246830] initcall proc_kmsg_init+0x0/0x2a returned 0 after 6 usecs
[    4.253608] calling  proc_page_init+0x0/0x4a @ 1
[    4.258476] initcall proc_page_init+0x0/0x4a returned 0 after 11 usecs
[    4.265338] calling  init_ramfs_fs+0x0/0x44 @ 1
[    4.270187] initcall init_ramfs_fs+0x0/0x44 returned 0 after 71 usecs
[    4.276958] calling  blk_scsi_ioctl_init+0x0/0x288 @ 1
[    4.282367] initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 1 =
usecs
[    4.289688] calling  acpi_event_init+0x0/0x37 @ 1
[    4.294663] initcall acpi_event_init+0x0/0x37 returned 0 after 29 usec=
s
[    4.301622] calling  pnp_system_init+0x0/0xf @ 1
[    4.306528] initcall pnp_system_init+0x0/0xf returned 0 after 51 usecs
[    4.313379] calling  pnpacpi_init+0x0/0x88 @ 1
[    4.318049] pnp: PnP ACPI init
[    4.321310] ACPI: bus type PNP registered
[    4.326770] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    4.334509] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.362724] system 00:02: [mem 0xfec00000-0xfec00fff] could not be res=
erved
[    4.370065] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserve=
d
[    4.377023] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    4.386519] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    4.392754] system 00:03: [io  0x040b] has been reserved
[    4.398338] system 00:03: [io  0x04d6] has been reserved
[    4.403919] system 00:03: [io  0x0c00-0x0c01] has been reserved
[    4.410151] system 00:03: [io  0x0c14] has been reserved
[    4.415748] system 00:03: [io  0x0c50-0x0c51] has been reserved
[    4.421992] system 00:03: [io  0x0c52] has been reserved
[    4.427582] system 00:03: [io  0x0c6c] has been reserved
[    4.433183] system 00:03: [io  0x0c6f] has been reserved
[    4.438798] system 00:03: [io  0x0cd0-0x0cd1] has been reserved
[    4.445024] system 00:03: [io  0x0cd2-0x0cd3] has been reserved
[    4.451241] system 00:03: [io  0x0cd4-0x0cd5] has been reserved
[    4.457459] system 00:03: [io  0x0cd6-0x0cd7] has been reserved
[    4.463698] system 00:03: [io  0x0cd8-0x0cdf] has been reserved
[    4.469935] system 00:03: [io  0x0800-0x089f] could not be reserved
[    4.476533] system 00:03: [io  0x0b00-0x0b0f] has been reserved
[    4.482770] system 00:03: [io  0x0b20-0x0b3f] has been reserved
[    4.489005] system 00:03: [io  0x0900-0x090f] has been reserved
[    4.495232] system 00:03: [io  0x0910-0x091f] has been reserved
[    4.501466] system 00:03: [io  0xfe00-0xfefe] has been reserved
[    4.507701] system 00:03: [mem 0xffb80000-0xffbfffff] has been reserve=
d
[    4.514659] system 00:03: [mem 0xfec10000-0xfec1001f] has been reserve=
d
[    4.521619] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    4.531389] system 00:04: [io  0x0e00-0x0e0f] has been reserved
[    4.537624] system 00:04: [io  0x0e80-0x0e8f] has been re039] system 0=
0:05: [mem 0xe0000000-0xefffffff] has been reserved
[    4.570990] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    4.579926] system 00:06: [mem 0x00000000-0x0009ffff] could not be res=
erved
[    4.587247] system 00:06: [mem 0x000c0000-0x000cffff] could not be res=
erved
[    4.594570] system 00:06: [mem 0x000e0000-0x000fffff] could not be res=
erved
[    4.601890] system 00:06: [mem 0x00100000-0xcfefffff] could not be res=
erved
[    4.609208] system 00:06: [mem 0xfec00000-0xffffffff] could not be res=
erved
[    4.616531] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    4.624598] pnp: PnP ACPI: found 7 devices
[    4.628904] ACPI: bus type PNP unregistered
[    4.633304] initcall pnpacpi_init+0x0/0x88 returned 0 after 308153 use=
cs
[    4.640345] calling  pcistub_init+0x0/0x280 @ 1
[    4.645902] initcall pcistub_init+0x0/0x280 returned 0 after 779 usecs
[    4.652770] calling  chr_dev_init+0x0/0xc9 @ 1
[    4.668867] initcall chr_dev_init+0x0/0xc9 returned 0 after 11178 usec=
s
[    4.675843] calling  firmware_class_init+0x0/0xd7_init+0x0/0xd7 return=
ed 0 after 34 usecs
[    4.688499] calling  init_pcmcia_bus+0x0/0x5e @ 1
[    4.693530] initcall init_pcmcia_bus+0x0/0x5e returned 0 after 84 usec=
s
[    4.700480] calling  thermal_init+0x0/0x78 @ 1
[    4.705211] initcall thermal_init+0x0/0x78 returned 0 after 52 usecs
[    4.711899] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    4.717943] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 a=
fter 3 usecs
[    4.725913] calling  init_acpi_pm_clocksource+0x0/0x18d @ 1
[    4.766299] initcall init_acpi_pm_clocksource+0x0/0x18d returned 0 aft=
er 33738 usecs
[    4.774432] calling  pcibios_assign_0-0xdfffffff 64bit pref]
[    4.807132] pci 0000:00:06.0: PCI bridge to [bus 02]
[    4.812347] pci 0000:00:06.0:   bridge window [io  0x9000-0x9fff]
[    4.818740] pci 0000:00:06.0:   bridge window [mem 0xfe900000-0xfe9fff=
ff]
[    4.825890] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffff=
ff 64bit pref]
[    4.834032] pci 0000:00:07.0: PCI bridge to [bus 03]
[    4.839246] pci 0000:00:07.0:   bridge window [io  0xa000-0xbfff]
[    4.845648] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafff=
ff]
[    4.852778] pci 0000:00:14.4: PCI bridge to [bus 04]
[    4.857989] pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]
[    4.864398] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfff=
ff]
[    4.871555] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.877402] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.883269] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.889851] pci_bus 0000:00: resource 7 [mem 0xcff00000-0xdfffffff]
[    4.896441] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfebfffff]
[    4.903031] pci_bus 0000:01: resource 0 [io  0x8000-0x8fff]
[    4.908882] pci_bus 0000:01: resource 1 [mem 0xfe700000-0xfe8fffff]
[    4.915463] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64b=
it pref]
[    4.923054] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
[    4.928906] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
[    4.935503] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64b=
it pref]
[    4.943089] pci_bus 0000:03: resource 0 [io  0xa000-0xbfff]
[    4.948954] pci_bus 0000:03: resource 1 [mem 0xfea00000-0xfeafffff]
[    4.955545] pci_bus 0000:04: resource 0 [io  0xc000-0xefff]
[    4.961395] pci_bus 0000:04: resource 1 [mem 0xfeb00000-0xfebfffff]
[    4.967971] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    4.973836] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    4.979696] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    4.986286] pci_bus 0000:04: resource 7 [mem 0xcff00000-0xdfffffff]
[    4.992885] pci_bus 0000:04: resource 8 [mem 0xf0000000-0xfebfffff]
[    4.999462] initcall pcibios_assign_resources+0x0/0x8f returned 0 afte=
r 214329 usecs
[    5.007605] calling  sysctl_core_init+0x0/0x23 @ 1
[    5.012666] initcall sysctl_core_init+0x0/0x23 returned 0 after 28 use=
cs
[    5.019710] calling  inet_init+0x0/0x25b @ 1
[    5.024420] NET: Registered protocol family 2
[    5.029775] TCP established hash table entries: 8192 (order: 3, 32768 =
bytes)
[    5.037196] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    5.043981] TCP: Hash tables configured (established 8192 bind 8192)
[    5.050700] TCP: reno registered
[    5.054103] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    5.060324] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    5.067358] initcall inet_init+0x0/0x25b returned 0 after 42191 usecs
[    5.074118] calling  ipv4_offload_init+0x0/0x5d @ 1
[    5.079247] initcall ipv4_offload_init+0x0/0x5d returned 0 after 1 use=
cs
[    5.086283] calling  af_unix_init+0x0/0x4d @ 1
[    5.090990] NET: Registered protocol family 1
[    5.095595] initcall af_unix_init+0x0/0x4d returned 0 after 4533 usecs
[    5.102453] calling  ipv6_offload_init+0x0/0x7a @ 1
[    5.107591] initcall ipv6_offload_init+0x0/0x7a returned 0 after 1 use=
cs
[    5.114634] calling  init_sunrpc+0x0/0x5f @ 1
[    5.119599] RPC: Registered named UNIX socket transport module.
[    5.125815] RPC: Registered udp transport module.
[    5.130766] RPC: Registered tcp transport module.
[    5.135699] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    5.142477] initcall init_sunrpc+0x0/0x5f returned 0 after 22736 usecs
[    5.149336] calling  pci_apply_final_quirks+0x0/0x112 @ 1
[    5.155024] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disa=
bled
[    5.532617] pci 0000:01:05.0: Boot video device
[    5.537386] PCI: CLS 64 bytes, default 64
[    5.541600] initcall pci_ap[    7.414618] microcode: updated early to =
new patch_level=3D0x010000db
[    7.448847] Freeing initrd memory: 83104K (f2ad6000 - f7bfe000)
[    7.455076] initcall populate_rootfs+0x0/0xf9 returned 0=20
[    7.462500] calling  pci_iommu_init+0x0/0x34 @ 1
[    7.467359] initcall pci_iommu_init+0x0/0x34 returned 0 after 2 usecs
[    7.474181] calling  register_kernel_offset_dumper+0x0/0x16 @ 1
[    7.480411] initcall register_kernel_offset_dumper+0x0/0x16 returned 0=
 after 2 usecs
[    7.488548] calling  i8259A_init_ops+0x0/0x1d @ 1
[    7.493486] initcall i8259A_init_ops+0x0/0x1d returned 0 after 1 usecs
[    7.500350] calling  sbf_init+0x0/0xf1 @ 1
[    7.504661] initcall sbf_init+0x0/0xf1 returned 0 after 0 usecs
[    7.510897] calling  init_tsc_clocksource+0x0/0xa7 @ 1
[    7.516307] initcall init_tsc_clocksource+0x0/0xa7 returned 0 after 2 =
usecs
[    7.523635] calling  add_rtc_cmos+0x0/0x99 @ 1
[    7.528306] initcall add_rtc_cmos+0x0/0x99 returned 0 after 2 usecs
[    7.534902] calling  i8237A_init_ops+0x0/0x11 @ 1
[    7.539849] initcall i8237A_init_ops+0x0/0x11 returned 0 after 0 usecs
[    7.546713] calling  cache_sysfs_init+0x0/0x69 @ 1
[    7.553084] initcall cache_sysfs_init+0x0/0x69 returned 0 after 1304 u=
secs
[    7.560310] calling  amd_uncore_init+0x0/0x111 @ 1
[    7.565354] initcall amd_uncore_init+0x0/0x111 returned -19 after 1 us=
ecs
[    7.572490] calling  intel_uncore_init+0x0/0x3ea @ 1
[    7.577714] initcall intel_uncore_init+0x0/0x3ea returned -19 after 1 =
usecs
[    7.585022] calling  rapl_pmu_init+0x0/0x194 @ 1
[    7.589878] initcall rapl_pmu_init+0x0/0x194 returned 0 after 1 usecs
[    7.596657] calling  inject_init+0x0/0x30 @ 1
[    7.601240] Machine check injector initialized
[    7.605914] initcall inject_init+0x0/0x30 returned 0 after 4568 usecs
[    7.612682] calling  thermal_throttle_init_device+0x0/0x6d @ 1
[    7.618807] initcall thermal_throttle_init_device+0x0/0x6d returned 0 =
after 0 usecs
[    7.626862] calling  microcode_init+0x0/0x18c @ 1
[    7.631945] microcode: CPU0: patch_level=3D0x010000db
[    7.637098] microcode: CPU1: patch_level=3D0x01000086
[    7.642250] microcode: CPU2: patch_level=3D0x01000086
[    7.647409] microcode: CPU3: patch_level=3D0x01000086
[    7.652739] microcode: Microcode Update Driver: v2.00 <tigran@aivazian=
.fsnet.co.uk>, Peter Oruba
[    7.661984] initcall microcode_init+0x0/0x18c returned 0 after 29494 u=
secs
[    7.669223] calling  amd_ibs_init+0x0/0x21f @ 1
[    7.673992] LVT offset 1 assigned for vector 0x400
[    7.679033] IBS: LVT offset 1 assigned
[    7.683111] perf: AMD IBS detected (0x0000001f)
[    7.687880] initcall amd_ibs_init+0x0/0x21f returned 0 after 13575 use=
cs
[    7.694920] calling  msr_init+0x0/0x153 @ 1
[    7.699947] initcall msr_init+0x0/0x153 returned 0 after 622 usecs
[    7.706471] calling  cpuid_init+0x0/0x153 @ 1
[    7.711735] initcall cpuid_init+0x0/0x153 returned 0 after 654 usecs
[    7.718436] calling  ioapic_init_ops+0x0/0x11 @ 1
[    7.723402] initcall ioapic_init_ops+0x0/0x11 returned 0 after 1 usecs
[    7.730260] calling  add_pcspkr+0x0/0x3b @ 1
[    7.734842] initcall add_pcspkr+0x0/0x3b returned 0 after 88 usecs
[    7.741336] calling  start_periodic_check_for_corruption+0x0/0x60 @ 1
[    7.748121] Scanning for low memory corruption every 60 seconds
[    7.754339] initcall start_periodic_check_for_corruption+0x0/0x60 retu=
rned 0 after 6077 usecs
[    7.763304] calling  sysfb_init+0x0/0x80 @ 1
[    7.767882] initcall sysfb_init+0x0/0x80 returned 0 after 96 usecs
[    7.774371] calling  pt_dump_init+0x0/0x70 @ 1
[    7.779069] initcall pt_dump_init+0x0/0x70 returned 0 after 12 usecs
[    7.785749] calling  aes_init+0x0/0xf @ 1
[    7.790084] initcall aes_init+0x0/0xf returned 0 after 108 usecs
[    7.796408] calling  proc_execdomains_init+0x0/0x27 @ 1
[    7.801908] initcall proc_execdomains_init+0x0/0x27 returned 0 after 9=
 usecs
[    7.809328] calling  ioresources_init+0x0/0x44 @ 1
[    7.814368] initcall ioresources_init+0x0/0x44 returned 0 after 11 use=
cs
[    7.821425] calling  init_posix_timers+0x0/0x22b @ 1
[    7.826713] initcall init_posix_timers+0x0/0x22b returned 0 after 71 u=
secs
[    7.833956] calling  init_posix_cpu_timers+0x0/0x9b @ 1
[    7.839447] initcall init_posix_cpu_timers+0x0/0x9b returned 0 after 1=
 usecs
[    7.846865] calling  snapshot_device_init+0x0/0xf @ 1
[    7.852318] initcall snapshot_device_init+0x0/0xf returned 0 after 129=
 usecs
[    7.859732] calling  irq_pm_init_ops+0x0/0x11 @ 1
[    7.864680] initcall irq_pm_init_ops+0x0/0x11 returned 0 after 0 usecs
[    7.871551] calling  timekeeping_init_ops+0x0/0x11 @ 1
[    7.876968] initcall timekeeping_init_ops+0x0/0x11 returned 0 after 2 =
usecs
[    7.884280] calling  init_clocksource_sysfs+0x0/0x58 @ 1
[    7.890085] initcall init_clocksource_sysfs+0x0/0x58 returned 0 after =
221 usecs
[    7.897764] calling  init_timer_list_procfs+0x0/0x30 @ 1
[    7.903354] initcall init_timer_list_procfs+0x0/0x30 returned 0 after =
6 usecs
[    7.910854] calling  alarmtimer_init+0x0/0x151 @ 1
[    7.916076] initcall alarmtimer_init+0x0/0x151 returned 0 after 189 us=
ecs
[    7.923231] calling  clockevents_init_sysfs+0x0/0xa3 @ 1
[    7.929525] initcall clockevents_init_sysfs+0x0/0xa3 returned 0 after =
698 usecs
[    7.937219] calling  init_tstats_procfs+0x0/0x30 @ 1
[    7.942440] initcall init_tstats_procfs+0x0/0x30 returned 0 after 7 us=
ecs
[    7.949586] calling  futex_init+0x0/0xe6 @ 1
[    7.954073] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    7.960684] initcall futex_init+0x0/0xe6 returned 0 after 6464 usecs
[    7.967371] calling  proc_dma_init+0x0/0x27 @ 1
[    7.972136] initcall proc_dma_init+0x0/0x27 returned 0 after 6 usecs
[    7.978831] calling  proc_modules_init+0x0/0x27 @ 1
[    7.983961] initcall proc_modules_init+0x0/0x27 returned 0 after 6 use=
cs
[    7.991001] calling  kallsyms_init+0x0/0x2a @ 1
[    7.995765] initcall kallsyms_init+0x0/0x2a returned 0 after 6 usecs
[    8.002441] calling  pid_namespaces_init+0x0/0x32 @ 1
[    8.007813] initcall pid_namespaces_init+0x0/0x32 returned 0 after 59 =
usecs
[    8.015136] calling  ikconfig_init+0x0/0x41 @ 1
[    8.019912] initcall ikconfig_init+0x0/0x41 returned 0 after 7 usecs
[    8.026602] calling  audit_init+0x0/0xed @ 1
[    8.031093] audit: initializing netlink subsys (disabled)
[    8.036819] audit: type=3D2000 audit(1405354050.578:1): initialized
[    8.043220] initcall audit_init+0x0/0xed returned 0 after 11852 usecs
[    8.050003] calling  audit_watch_init+0x0/0x31 @ 1
[    8.055037] initcall audit_watch_init+0x0/0x31 returned 0 after 4 usec=
s
[    8.061996] calling  audit_tree_init+0x0/0x3b @ 1
[    8.066959] initcall audit_tree_init+0x0/0x3b returned 0 after 3 usecs
[    8.073822] calling  init_kprobes+0x0/0x177 @ 1
[    8.079042] initcall init_kprobes+0x0/0x177 returned 0 after 435 usecs
[    8.085898] calling  utsname_sysctl_init+0x0/0x11 @ 1
[    8.091230] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 12 =
usecs
[    8.098539] calling  init_tracepoints+0x0/0x29 @ 1
[    8.103582] initcall init_tracepoints+0x0/0x29 returned 0 after 0 usec=
s
[    8.110546] calling  init_blk_tracer+0x0/0x56 @ 1
[    8.115490] initcall init_blk_tracer+0x0/0x56 returned 0 after 2 usecs
[    8.122350] calling  irq_work_init_cpu_notifier+0x0/0x25 @ 1
[    8.128293] initcall irq_work_init_cpu_notifier+0x0/0x25 returned 0 af=
ter 2 usecs
[    8.136166] calling  perf_event_sysfs_init+0x0/0x8f @ 1
[    8.142439] initcall perf_event_sysfs_init+0x0/0x8f returned 0 after 7=
61 usecs
[    8.150038] calling  init_per_zone_wmark_min+0x0/0x9d @ 1
[    8.155726] initcall init_per_zone_wmark_min+0x0/0x9d returned 0 after=
 4 usecs
[    8.163313] calling  kswapd_init+0x0/0x1d @ 1
[    8.168035] initcall kswapd_init+0x0/0x1d returned 0 after 133 usecs
[    8.174719] calling  extfrag_debug_init+0x0/0x7b @ 1
[    8.179958] initcall extfrag_debug_init+0x0/0x7b returned 0 after 26 u=
secs
[    8.187182] calling  setup_vmstat+0x0/0xcf @ 1
[    8.191879] initcall setup_vmstat+0x0/0xcf returned 0 after 24 usecs
[    8.198558] calling  mm_compute_batch_init+0x0/0x51 @ 1
[    8.204055] initcall mm_compute_batch_init+0x0/0x51 returned 0 after 0=
 usecs
[    8.211476] calling  slab_proc_init+0x0/0x2a @ 1
[    8.216336] initcall slab_proc_init+0x0/0x2a returned 0 after 8 usecs
[    8.223119] calling  workingset_init+0x0/0x38 @ 1
[    8.228064] initcall workingset_init+0x0/0x38 returned 0 after 5 usecs
[    8.234929] calling  proc_vmalloc_init+0x0/0x2a @ 1
[    8.240052] initcall proc_vmalloc_init+0x0/0x2a returned 0 after 6 use=
cs
[    8.247104] calling  procswaps_init+0x0/0x27 @ 1
[    8.251965] initcall procswaps_init+0x0/0x27 returned 0 after 6 usecs
[    8.258736] calling  init_frontswap+0x0/0x84 @ 1
[    8.263634] initcall init_frontswap+0x0/0x84 returned 0 after 31 usecs
[    8.270498] calling  hugetlb_init+0x0/0x3d8 @ 1
[    8.275259] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.281998] initcall hugetlb_init+0x0/0x3d8 returned 0 after 6586 usec=
s
[    8.288966] calling  slab_proc_init+0x0/0x7 @ 1
[    8.293725] initcall slab_proc_init+0x0/0x7 returned 0 after 0 usecs
[    8.300413] calling  cpucache_init+0x0/0x40 @ 1
[    8.305170] initcall cpucache_init+0x0/0x40 returned 0 after 1 usecs
[    8.311859] calling  init_cleancache+0x0/0xa8 @ 1
[    8.316838] initcall init_cleancache+0x0/0xa8 returned 0 after 30 usec=
s
[    8.323795] calling  zs_init+0x0/0x90 @ 1
[    8.328019] initcall zs_init+0x0/0x90 returned 0 after 3 usecs
[    8.334149] calling  fcntl_init+0x0/0x2f @ 1
[    8.338683] initcall fcntl_init+0x0/0x2f returned 0 after 33 usecs
[    8.345190] calling  proc_filesystems_init+0x0/0x27 @ 1
[    8.350687] initcall proc_filesystems_init+0x0/0x27 returned 0 after 6=
 usecs
[    8.358102] calling  dio_init+0x0/0x32 @ 1
[    8.362456] initcall dio_init+0x0/0x32 returned 0 after 51 usecs
[    8.368775] calling  fsnotify_mark_init+0x0/0x46 @ 1
[    8.374065] initcall fsnotify_mark_init+0x0/0x46 returned 0 after 71 u=
secs
[    8.381286] calling  dnotify_init+0x0/0x7c @ 1
[    8.386055] initcall dnotify_init+0x0/0x7c returned 0 after 88 usecs
[    8.392732] calling  inotify_user_setup+0x0/0x50 @ 1
[    8.398006] initcall inotify_user_setup+0x0/0x50 returned 0 after 48 u=
secs
[    8.405238] calling  aio_setup+0x0/0x7e @ 1
[    8.409815] initcall aio_setup+0x0/0x7e returned 0 after 174 usecs
[    8.416313] calling  proc_locks_init+0x0/0x27 @ 1
[    8.421264] initcall proc_locks_init+0x0/0x27 returned 0 after 6 usecs
[    8.428128] calling  dquot_init+0x0/0x116 @ 1
[    8.432708] VFS: Disk quotas dquot_6.5.2
[    8.436993] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    8.443856] initcall dquot_init+0x0/0x116 returned 0 after 10895 usecs
[    8.450731] calling  init_v2_quota_format+0x0/0x1d @ 1
[    8.456126] initcall init_v2_quota_format+0x0/0x1d returned 0 after 0 =
usecs
[    8.463454] calling  quota_init+0x0/0x2e @ 1
[    8.467972] initcall quota_init+0x0/0x2e returned 0 after 26 usecs
[    8.474464] calling  init_devpts_fs+0x0/0x52 @ 1
[    8.479443] initcall init_devpts_fs+0x0/0x52 returned 0 after 122 usec=
s
[    8.486405] calling  init_hugetlbfs_fs+0x0/0x145 @ 1
[    8.491861] initcall init_hugetlbfs_fs+0x0/0x145 returned 0 after 239 =
usecs
[    8.499172] calling  init_fat_fs+0x0/0x4c @ 1
[    8.503835] initcall init_fat_fs+0x0/0x4c returned 0 after 75 usecs
[    8.510420] calling  init_vfat_fs+0x0/0xf @ 1
[    8.514999] initcall init_vfat_fs+0x0/0xf returned 0 after 1 usecs
[    8.521503] calling  init_msdos_fs+0x0/0xf @ 1
[    8.526170] initcall init_msdos_fs+0x0/0xf returned 0 after 1 usecs
[    8.532758] calling  init_iso9660_fs+0x0/0x69 @ 1
[    8.537754] initcall init_iso9660_fs+0x0/0x69 returned 0 after 46 usec=
s
[    8.544712] calling  init_nfs_fs+0x0/0x142 @ 1
[    8.549803] initcall init_nfs_fs+0x0/0x142 returned 0 after 420 usecs
[    8.556576] calling  init_nfs_v2+0x0/0x11 @ 1
[    8.561160] initcall init_nfs_v2+0x0/0x11 returned 0 after 1 usecs
[    8.567654] calling  init_nfs_v3+0x0/0x11 @ 1
[    8.572246] initcall init_nfs_v3+0x0/0x11 returned 0 after 1 usecs
[    8.578749] calling  init_nfs_v4+0x0/0x30 @ 1
[    8.583328] NFS: Registering the id_resolver key type
[    8.588653] Key type id_resolver registered
[    8.593049] Key type id_legacy registered
[    8.597279] initcall init_nfs_v4+0x0/0x30 returned 0 after 13635 usecs
[    8.604145] calling  init_nlm+0x0/0x3b @ 1
[    8.608478] initcall init_nlm+0x0/0x3b returned 0 after 12 usecs
[    8.614788] calling  init_nls_cp437+0x0/0x11 @ 1
[    8.619655] initcall init_nls_cp437+0x0/0x11 returned 0 after 1 usecs
[    8.626434] calling  init_nls_ascii+0x0/0x11 @ 1
[    8.631286] initcall init_nls_ascii+0x0/0x11 returned 0 after 0 usecs
[    8.638058] calling  init_nls_iso8859_1+0x0/0x11 @ 1
[    8.643281] initcall init_nls_iso8859_1+0x0/0x11 returned 0 after 0 us=
ecs
[    8.650430] calling  init_nls_utf8+0x0/0x23 @ 1
[    8.655202] initcall init_nls_utf8+0x0/0x23 returned 0 after 2 usecs
[    8.661889] calling  init_ntfs_fs+0x0/0x1c9 @ 1
[    8.666646] ntfs: driver 2.1.30 [Flags: R/W].
[    8.671406] initcall init_ntfs_fs+0x0/0x1c9 returned 0 after 4652 usec=
s
[    8.678366] calling  init_autofs4_fs+0x0/0x26 @ 1
[    8.683381] tsc: Refined TSC clocksource calibration: 3000.105 MHz
[    8.683479] initcall init_autofs4_fs+0x0/0x26 returned 0 after 155 use=
cs
[    8.683485] calling  init_pstore_fs+0x0/0x41 @ 1
[    8.683509] initcall init_pstore_fs+0x0/0x41 returned 0 after 19 usecs
[    8.683513] calling  ipc_init+0x0/0x20 @ 1
[    8.683530] msgmni has been set to 1688
[    8.683551] initcall ipc_init+0x0/0x20 returned 0 after 34 usecs
[    8.683556] calling  ipc_sysctl_init+0x0/0x11 @ 1
[    8.683573] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 14 usec=
s
[    8.683577] calling  init_mqueue_fs+0x0/0x91 @ 1
[    8.740095] initcall init_mqueue_fs+0x0/0x91 returned 0 after 55240 us=
ecs
[    8.747242] calling  key_proc_init+0x0/0x64 @ 1
[    8.752019] initcall key_proc_init+0x0/0x64 returned 0 after 13 usecs
[    8.758802] calling  selinux_nf_ip_init+0x0/0x65 @ 1
[    8.764021] initcall selinux_nf_ip_init+0x0/0x65 returned 0 after 1 us=
ecs
[    8.771168] calling  init_sel_fs+0x0/0x8b @ 1
[    8.775751] initcall init_sel_fs+0x0/0x8b returned 0 after 1 usecs
[    8.782250] calling  selnl_init+0x0/0x53 @ 1
[    8.786756] initcall selnl_init+0x0/0x53 returned 0 after 13 usecs
[    8.793249] calling  sel_netif_init+0x0/0x54 @ 1
[    8.798112] initcall sel_netif_init+0x0/0x54 returned 0 after 2 usecs
[    8.804880] calling  sel_netnode_init+0x0/0x5f @ 1
[    8.809938] initcall sel_netnode_init+0x0/0x5f returned 0 after 0 usec=
s
[    8.816901] calling  sel_netport_init+0x0/0x5f @ 1
[    8.821938] initcall sel_netport_init+0x0/0x5f returned 0 after 0 usec=
s
[    8.828905] calling  aurule_init+0x0/0x2d @ 1
[    8.833486] initcall aurule_init+0x0/0x2d returned 0 after 3 usecs
[    8.839999] calling  crypto_algapi_init+0x0/0xc @ 1
[    8.845133] initcall crypto_algapi_init+0x0/0xc returned 0 after 7 use=
cs
[    8.852183] calling  chainiv_module_init+0x0/0xf @ 1
[    8.857399] initcall chainiv_module_init+0x0/0xf returned 0 after 0 us=
ecs
[    8.864547] calling  eseqiv_module_init+0x0/0xf @ 1
[    8.869687] initcall eseqiv_module_init+0x0/0xf returned 0 after 1 use=
cs
[    8.876743] calling  hmac_module_init+0x0/0xf @ 1
[    8.881697] initcall hmac_module_init+0x0/0xf returned 0 after 0 usecs
[    8.888561] calling  md5_mod_init+0x0/0xf @ 1
[    8.893227] initcall md5_mod_init+0x0/0xf returned 0 after 76 usecs
[    8.899823] calling  sha1_generic_mod_init+0x0/0xf @ 1
[    8.905294] initcall sha1_generic_mod_init+0x0/0xf returned 0 after 74=
 usecs
[    8.912710] calling  crypto_cbc_module_init+0x0/0xf @ 1
[    8.918194] initcall crypto_cbc_module_init+0x0/0xf returned 0 after 1=
 usecs
[    8.925598] calling  des_generic_mod_init+0x0/0x14 @ 1
[    8.931139] initcall des_generic_mod_init+0x0/0x14 returned 0 after 13=
5 usecs
[    8.938643] calling  aes_init+0x0/0xf @ 1
[    8.942965] initcall aes_init+0x0/0xf returned 0 after 106 usecs
[    8.949277] calling  zlib_mod_init+0x0/0xf @ 1
[    8.954032] initcall zlib_mod_init+0x0/0xf returned 0 after 74 usecs
[    8.960709] calling  crypto_authenc_module_init+0x0/0xf @ 1
[    8.966576] initcall crypto_authenc_module_init+0x0/0xf returned 0 aft=
er 0 usecs
[    8.974346] calling  crypto_authenc_esn_module_init+0x0/0xf @ 1
[    8.980575] initcall crypto_authenc_esn_module_init+0x0/0xf returned 0=
 after 1 usecs
[    8.988710] calling  krng_mod_init+0x0/0xf @ 1
[    8.993486] initcall krng_mod_init+0x0/0xf returned 0 after 91 usecs
[    9.000169] calling  proc_genhd_init+0x0/0x44 @ 1
[    9.005127] initcall proc_genhd_init+0x0/0x44 returned 0 after 12 usec=
s
[    9.012086] calling  init_emergency_pool+0x0/0x53 @ 1
[    9.017404] bounce: pool size: 64 pages
[    9.021436] initcall init_emergency_pool+0x0/0x53 returned 0 after 395=
5 usecs
[    9.028933] calling  bsg_init+0x0/0x119 @ 1
[    9.033424] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 251)
[    9.041183] initcall bsg_init+0x0/0x119 returned 0 after 7672 usecs
[    9.047781] calling  noop_init+0x0/0xf @ 1
[    9.052085] io scheduler noop registered
[    9.056209] initcall noop_init+0x0/0xf returned 0 after 4030 usecs
[    9.062707] calling  deadline_init+0x0/0xf @ 1
[    9.067380] io scheduler deadline registered
[    9.071869] initcall deadline_init+0x0/0xf returned 0 after 4386 usecs
[    9.078726] calling  cfq_init+0x0/0x89 @ 1
[    9.083116] io scheduler cfq registered (default)
[    9.088058] initcall cfq_init+0x0/0x89 returned 0 after 4900 usecs
[    9.094560] calling  percpu_counter_startup+0x0/0x35 @ 1
[    9.100142] initcall percpu_counter_startup+0x0/0x35 returned 0 after =
1 usecs
[    9.107654] calling  audit_classes_init+0x0/0x4f @ 1
[    9.112887] initcall audit_classes_init+0x0/0x4f returned 0 after 15 u=
secs
[    9.120117] calling  phy_core_init+0x0/0x45 @ 1
[    9.124918] initcall phy_core_init+0x0/0x45 returned 0 after 30 usecs
[    9.131693] calling  pci_proc_init+0x0/0x64 @ 1
[    9.136674] initcall pci_proc_init+0x0/0x64 returned 0 after 209 usecs
[    9.143533] calling  pcie_portdrv_init+0x0/0x6f @ 1
[    9.150669] pcieport 0000:00:06.0: irq 40 for MSI/MSI-X
[    9.158152] pcieport 0000:00:07.0: irq 41 for MSI/MSI-X
[    9.163897] initcall pcie_portdrv_init+0x0/0x6f returned 0 after 14902=
 usecs
[    9.171320] calling  aer_service_init+0x0/0x28 @ 1
[    9.176411] initcall aer_service_init+0x0/0x28 returned 0 after 53 use=
cs
[    9.183458] calling  pci_hotplug_init+0x0/0x1e @ 1
[    9.188495] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    9.194348] initcall pci_hotplug_init+0x0/0x1e returned 0 after 5720 u=
secs
[    9.201586] calling  pcied_init+0x0/0x76 @ 1
[    9.206194] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    9.213151] initcall pcied_init+0x0/0x76 returned 0 after 6919 usecs
[    9.219835] calling  pcifront_init+0x0/0x41 @ 1
[    9.224602] initcall pcifront_init+0x0/0x41 returned -19 after 1 usecs
[    9.231476] calling  genericbl_driver_init+0x0/0x11 @ 1
[    9.237037] initcall genericbl_driver_init+0x0/0x11 returned 0 after 5=
0 usecs
[    9.244545] calling  cirrusfb_init+0x0/0xaa @ 1
[    9.249396] initcall cirrusfb_init+0x0/0xaa returned 0 after 73 usecs
[    9.256169] calling  efifb_driver_init+0x0/0x11 @ 1
[    9.261354] initcall efifb_driver_init+0x0/0x11 returned 0 after 53 us=
ecs
[    9.268503] calling  intel_idle_init+0x0/0x2ec @ 1
[    9.273549] initcall intel_idle_init+0x0/0x2ec returned -19 after 2 us=
ecs
[    9.280687] calling  acpi_reserve_resources+0x0/0xc8 @ 1
[    9.286286] initcall acpi_reserve_resources+0x0/0xc8 returned 0 after =
13 usecs
[    9.293874] calling  acpi_ac_init+0x0/0x25 @ 1
[    9.298639] initcall acpi_ac_init+0x0/0x25 returned 0 after 88 usecs
[    9.305317] calling  acpi_button_driver_init+0x0/0xf @ 1
[    9.311279] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0C0C:00/input/input0
[    9.320057] ACPI: Power Button [PWRB]
[    9.324271] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
[    9.332045] ACPI: Power Button [PWRF]
[    9.335946] initcall acpi_button_driver_init+0x0/0xf returned 0 after =
24478 usecs
[    9.343818] calling  acpi_fan_driver_init+0x0/0xf @ 1
[    9.349200] initcall acpi_fan_driver_init+0x0/0xf returned 0 after 57 =
usecs
[    9.356547] calling  acpi_processor_driver_init+0x0/0x3e @ 1
[    9.362592] ACPI: processor limited to max C-state 1
[    9.368609] initcall acpi_processor_driver_init+0x0/0x3e returned 0 af=
ter 5958 usecs
[    9.376751] calling  acpi_thermal_init+0x0/0x8c @ 1
[    9.384768] thermal LNXTHERM:00: registered as thermal_zone0
[    9.390712] ACPI: Thermal Zone [THRM] (30 C)
[    9.395247]d 0 after 13071 usecs
[    9.402658] calling  acpi_battery_init+0x0/0x13 @ 1
[    9.407790] initcall acpi_battery_init+0x0/0x13 returned 0 after 5 use=
cs
[    9.407799] calling  1_acpi_battery_init_async+0x0/0x22 @ 6
[    9.407881] initcall 1_acpi_battery_init_async+0x0/0x22 returned 0 aft=
er 76 usecs
[    9.428543] calling  acpi_hed_driver_init+0x0/0xf @ 1
[    9.433905] initcall acpi_hed_driver_init+0x0/0xf returned 0 after 53 =
usecs
[    9.441224] calling  erst_init+0x0/0x2fa @ 1
[    9.445709] initcall erst_init+0x0/0x2fa returned 0 after 1 usecs
[    9.452122] calling  ghes_init+0x0/0x165 @ 1
[    9.456611] GHES: HEST is not enabled!
[    9.460550] initcall ghes_init+0x0/0x165 returned -22 after 3850 usecs
[    9.467415] calling  einj_init+0x0/0x4ef @ 1
[    9.471895] initcall einj_init+0x0/0x4ef returned -19 after 1 usecs
[    9.478483] calling  ioat_init_module+0x0/0xb0 @ 1
[    9.483522] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    9.489849] initcall ioat_init_module+0x0/0xb0 returned 0 after 6184 u=
secs
[    9.497069] calling  virtio_mmio_init+0x0/0x11 @ 1
[    9.502159] initcall virtio_mmio_init+0x0/0x11 returned 0 after 52 use=
cs
[    9.509204] calling  virtio_balloon_driver_init+0x0/0xf @ 1
[    9.515118] initcall virtio_balloon_driver_init+0x0/0xf returned 0 aft=
er 52 usecs
[    9.522999] calling  xenbus_probe_initcall+0x0/0x35 @ 1
[    9.528485] initcall xenbus_probe_initcall+0x0/0x35 returned -19 after=
 0 usecs
[    9.536085] calling  xenbus_init+0x0/0x37 @ 1
[    9.540672] initcall xenbus_init+0x0/0x37 returned -19 after 0 usecs
[    9.547343] calling  xenbus_backend_init+0x0/0x48 @ 1
[    9.552651] initcall xenbus_backend_init+0x0/0x48 returned -19 after 0=
 usecs
[    9.560062] calling  gntdev_init+0x0/0x48 @ 1
[    9.564639] initcall gntdev_init+0x0/0x48 returned -19 after 0 usecs
[    9.571332] calling  gntalloc_init+0x0/0x37 @ 1
[    9.576090] initcall gntalloc_init+0x0/0x37 returned -19 after 0 usecs
[    9.582946] calling  hypervisor_subsys_init+0x0/0x21 @ 1
[    9.588533] initcall hypervisor_subsys_init+0x0/0x21 returned -19 afte=
r 0 usecs
[    9.596216] calling  hyper_sysfs_init+0x0/0xcc @ 1
[    9.601241] initcall hyper_sysfs_init+0x0/0xcc returned -19 after 0 us=
ecs
[    9.608384] calling  platform_pci_module_init+0x0/0x16 @ 1
[    9.614224] initcall platform_pci_module_init+0x0/0x16 returned 0 afte=
r 68 usecs
[    9.622009] calling  xen_pcibk_init+0x0/0x110 @ 1
[    9.626948] initcall xen_pcibk_init+0x0/0x110 returned -19 after 0 use=
cs
[    9.633985] calling  xen_acpi_processor_init+0x0/0x1f7 @ 1
[    9.639752] initcall xen_acpi_processor_init+0x0/0x1f7 returned -19 af=
ter 0 usecs
[    9.647615] calling  pty_init+0x0/0x3d9 @ 1
[    9.654541] kworker/u12:0 (638) used greatest stack depth: 6928 bytes =
left
[    9.673247] kworker/u12:0 (777) used greatest stack depth: 6712 bytes =
left
[    9.720948] initcall pty_init+0x0/0x3d9 returned 0 after 67380 usecs
[    9.727637] calling  sysrq_init+0x0/0xbe @ 1
[    9aring enabled
[    9.762191] Switched to ?[   11.104611] console [ttyS0] enabled
[   11.104611] console [ttyS0] enabled
[   11.111860] bootconsole [uart0] disabled
[  disabled
[   11.120626] initcall serial_pci_driver_init+0x0/0x16 returned 0 after =
1326369 usecs
[   11.128527] calling  init_kgdboc+0x0/0x15 @ 1
[   11.133018] initcall init_kgdboc+0x0/0x15 returned 0 after 0 usecs
[   11.139383] calling  init+0x0/0xf3 @ 1
[   11.143394] initcall init+0x0/0xf3 returned 0 after 149 usecs
[   11.149311] calling  hpet_init+0x0/0x57 @ 1
[   11.154131] initcall hpet_init+0x0/0x57 returned 0 after 499 usecs
[   11.160501] calling  nvram_init+0x0/0x7e @ 1
[   11.165022] Non-volatile memory driver v1.3
[   11.169331] initcall nvram_init+0x0/0x7e returned 0 after 4336 usecs
[   11.175876] calling  mod_init+0x0/0x1b6 @ 1
[   11.180213] initcall mod_init+0x0/0x1b6 returned -19 after 31 usecs
[   11.186668] calling  mod_init+0x0/0x12d @ 1
[   11.190978] initcall mod_init+0x0/0x12d returned -19 after 5 usecs
[   11.197342] calling  mod_init+0x0/0x99 @ 1
[   11.201561] initcall mod_init+0x0/0x99 returned -19 after 3 usecs
[   11.207836] calling  mod_init+0x0/0x48 @ 1
[   11.212051] initcall mod_init+0x0/0x48 returned -19 after 0 usecs
[   11.218325] calling  rng_init+0x0/0xf @ 1
[   11.222608] initcall rng_init+0x0/0xf returned 0 after 153 usecs
[   11.228798] calling  agp_init+0x0/0x2f @ 1
[   11.233012] Linux agpgart interface v0.103
[   11.237228] initcall agp_init+0x0/0x2f returned 0 after 4120 usecs
[   11.243593] calling  agp_ali_init+0x0/0x24 @ 1
[   11.248237] initcall agp_ali_init+0x0/0x24 returned 0 after 68 usecs
[   11.254780] calling  agp_ati_init+0x0/0x24 @ 1
[   11.259420] initcall agp_ati_init+0x0/0x24 returned 0 after 65 usecs
[   11.265965] calling  agp_amdk7_init+0x0/0x24 @ 1
[   11.270789] initcall agp_amdk7_init+0x0/0x24 returned 0 after 71 usecs
[   11.277511] calling  agp_amd64_mod_init+0x0/0xa @ 1
[   11.283236] initcall agp_amd64_mod_init+0x0/0xa returned -19 after 688=
 usecs
[   11.290497] calling  agp_efficeon_init+0x0/0x39 @ 1
[   11.295586] initcall agp_efficeon_init+0x0/0x39 returned 0 after 66 us=
ecs
[   11.302577] calling  agp_intel_init+0x0/0x24 @ 1
[   11.307399] initcall agp_intel_init+0x0/0x24 returned 0 after 68 usecs
[   11.314123] calling  agp_nvidia_init+0x0/0x24 @ 1
[   11.319027] initcall agp_nvidia_init+0x0/0x24 returned 0 after 61 usec=
s
[   11.325840] calling  agp_sis_init+0x0/0x24 @ 1
[   11.330481] initcall agp_sis_init+0x0/0x24 returned 0 after 67 usecs
[   11.337026] calling  agp_serverworks_init+0x0/0x24 @ 1
[   11.342382] initcall agp_serverworks_init+0x0/0x24 returned 0 after 66=
 usecs
[   11.349641] calling  agp_via_init+0x0/0x24 @ 1
[   11.354283] initcall agp_via_init+0x0/0x24 returned 0 after 67 usecs
[   11.360829] calling  drm_core_init+0x0/0x107 @ 1
[   11.365654] [drm] Initialized drm 1.1.0 20060810
[   11.370406] initcall drm_core_init+0x0/0x107 returned 0 after 4716 use=
cs
[   11.377309] calling  cn_proc_init+0x0/0x33 @ 1
[   11.381884] initcall cn_proc_init+0x0/0x33 returned 0 after 3 usecs
[   11.388337] calling  topology_sysfs_init+0x0/0x60 @ 1
[   11.393738] initcall topology_sysfs_init+0x0/0x60 returned 0 after 197=
 usecs
[   11.400999] calling  loop_init+0x0/0x12b @ 1
[   11.411602] loop: module loaded
[   11.414838] initcall loop_init+0x0/0x12b returned 0 after 9231 usecs
[   11.421387] call1.438176] zram: Created 1 device(s) ...
[   11.442308] initcall zram_init+0x0/0x2e9 returned 0 after 4841 usecs
[   11.448854] calling  mac_hid_init+0x0/0x1c @ 1
[   11.453443] initcall mac_hid_init+0x0/0x1c returned 0 after 10 usecs
[   11.459989] calling  macvlan_init_module+0x0/0x31 @ 1
[   11.465196] initcall macvlan_init_module+0x0/0x31 returned 0 after 2 u=
secs
[   11.472282] calling  macvtap_init+0x0/0xd0 @ 1
[   11.476891] initcall macvtap_init+0x0/0xd0 returned 0 after 34 usecs
[   11.483441] calling  net_olddevs_init+0x0/0x88 @ 1
[   11.488378] initcall net_olddevs_init+0x0/0x88 returned 0 after 2 usec=
s
[   11.495195] calling  fixed_mdio_bus_init+0x0/0xe3 @ 1
[   11.500602] libphy: Fixed MDIO Bus: probed
[   11.504818] initcall fixed_mdio_bus_init+0x0/0xe3 returned 0 after 432=
0 usecs
[   11.512173] calling  tun_init+0x0/0x8b @ 1
[   11.516391] tun: Universal TUN/TAP device driver, 1.6
[   11.521589] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   11.528109] initcall tun_init+0x0/0x8b returned 0 after 11452 usecs
[   11.534570] calling  tg3_driver_init+0x0/0x16 @ 1
[   11.539529] initcall tg3_driver_init+0x0/0x16 returned 0 after 110 use=
cs
[   11.546435] calling  ixgbevf_init_module+0x0/0x49 @ 1
[   11.551633] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function =
Network Driver - version 2.12.1-k
[   11.561306] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[   11.567683] initcall ixgbevf_init_module+0x0/0x49 returned 0 after 156=
87 usecs
[   11.575126] calling  forcedeth_pci_driver_init+0x0/0x16 @ 1
[   11.580936] initcall forcedeth_pci_driver_init+0x0/0x16 returned 0 aft=
er 69 usecs
[   11.588642] calling  netback_init+0x0/0x81 @ 1
[   11.593219] initcall netback_init+0x0/0x81 returned -19 after 0 usecs
[   11.599851] calling  fw_core_init+0x0/0xf1 @ 1
[   11.604596] initcall fw_core_init+0x0/0xf1 returned 0 after 161 usecs
[   11.611234] calling  nonstatic_sysfs_init+0x0/0xf @ 1
[   11.616433] initcall nonstatic_sysfs_init+0x0/0xf returned 0 after 0 u=
secs
[   11.623513] calling  yenta_cardbus_driver_init+0x0/0x16 @ 1
[   11.629359] initcall yenta_cardbus_driver_init+0x0/0x16 returned 0 aft=
er 106 usecs
[   11.637155] calling  mon_init+0x0/0xe1 @ 1
[   11.641571] initcall mon_init+0x0/0xe1 returned 0 after 196 usecs
[   11.647851] calling  ehci_hcd_init+0x0/0x58 @ 1
[   11.652513] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   11.659233] initcall ehci_hcd_init+0x0/0x58 returned 0 after 6567 usec=
s
[   11.666046] calling  ehci_pci_init+0x0/0x60 @ 1
[   11.670708] ehci-pci: EHCI PCI platform driver
[   11.676980] QUIRK: Enable AMD PLL fix
[   11.680777] ehci-pci 0000:00:12.2: EHCI Host Controller
[   11.686454] ehci-pci 0000:00:12.2: new USB bus registered, assigned bu=
s number 1
[   11.694080] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3=
 EHCI dummy qh workaround
[   11.703035] ehci-pci 0000:00:12.2: applying AMD SB600/SB700 USB freeze=
 workaround
[   11.710749] ehci-pci 0000:00:12.2: debug port 1
[   11.715545] ehci-pci 0000:00:12.2: irq 17, io mem 0xfe6ff800
[   11.727390] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   11.733603] usb usb1: New USB device found, idVendor=3D1d6b, usb usb1:=
 SerialNumber: 0000:00:12.2
[   11.765418] hub 1-0:1.0: USB hub found
[   11.769346] hub 1-0:1.0: 6 ports detected
[   11.776629] ehci-pci 0000:00:13.2: EHCI Host Controller
[   11.782308] ehci-pci 0000:00:13.2: new USB bus registered, assigned bu=
s number 2
[   11.789933] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3=
 EHCI dummy qh workaround
[   11.798887] ehci-pci 0000:00:13.2: applying AMD SB600/SB700 USB freeze=
 workaround
[   11.806600] ehci-pci 0000:00:13.2: debug port 1
[   11.811396] ehci-pci 0000:00:13.2: irq 19, io mem 0xfe6ff400
[   11.823301] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   11.829506] usb usb2: New USB device found, idVendor=3D1d6b, sb2: New =
USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
[   11.843935] usb usb2: Product: EHCI Host Controller
[   11.848956] usb usb2: Manufacturer: Linux 3.16.0-rc5upstream ehci_hcd
[   11.855586] usb usb2: SerialNumber: 0000:00:13.2
[   11.861298] hub 2-0:1.0: USB hub found
[   11.865218] hub 2-0:1.0: 6 ports detected
[   11.870843] initcall ehci_pci_init+0x0/0x60 returned 0 after 195625 us=
ecs
[   11.877844] calling  ohci_hcd_mod_init+0x0/0x5e @ 1
[   11.882865] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   11.889235] initcall ohci_hcd_mod_init+0x0/0x5e returned 0 after 6224 =
usecs
[   11.896405] calling  ohci_pci_init+0x0/0x60 @ 1
[   11.901065] ohci-pci: OHCI PCI platform driver
[   11.907374] ohci-pci 0000:00:12.0: OHCI PCI host controller
[   11.913397] ohci-pci 0000:00:12.0: new USB bus registered, assigned bu=
s number 3
[   11.921160] ohci-pci 0000:00:12.0: irq 16, io mem 0xfe6fe000
[   11.981410] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   11.988404] usb usb3: New USB device strings: M: Product: OHCI PCI hos=
t controller
[   12.001214] usb usb3: Manufacturer: Linux 3.16.0-rc5upstream ohci_hcd
[   12.007842] usb usb3: SerialNumber: 0000:00:12.0
[   12.013546] hub 3-0:1.0: USB hub found
[   12.017474] hub 3-0:1.0: 3 ports detected
[   12.024244] ohci-pci 0000:00:12.1: OHCI PCI host controller
[   12.030276] ohci-pci 0000:00:12.1: new USB bus registered, assigned bu=
s number 4
[   12.037969] ohci-pci 0000:00:12.1: irq 16, io mem 0xfe6fd000
[   12.098367] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   12.105360] usb usb4: New USB device strings: M
[   12.118171] usb usb4: Manufacturer: Linux 3.16.0-rc5upstream ohci_hcd
[   12.124800] usb usb4: SerialNumber: 0000:00:12.1
[   12.130522] hub 4-0:1.0: USB hub found
[   12.134457] hub 4-0:1.0: 3 ports detected
[   12.141285] ohci-pci 0000:00:13.0: OHCI PCI host controller
[   12.147305] ohci-pci 0000:00:13.0: new USB bus registered, assigned bu=
s number 5
[   12.155063] ohci-pci 0000:00:13.0: irq 18, io mem 0xfe6fc000
[   12.216173] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   12.223165] usb usb5: New USB device strings: Musb5: Manufacturer: Lin=
ux 3.16.0-rc5upstream ohci_hcd
[   12.242606] usb usb5: SerialNumber: 0000:00:13.0
[   12.248318] hub 5-0:1.0: USB hub found
[   12.252249] hub 5-0:1.0: 3 ports detected
[   12.259142] ohci-pci 0000:00:13.1: OHCI PCI host controller
[   12.265159] ohci-pci 0000:00:13.1: new USB bus registered, assigned bu=
s number 6
[   12.272858] ohci-pci 0000:00:13.1: irq 18, io mem 0xfe6f7000
[   12.333074] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   12.340065] usb usb6: New USB device strings: Mupstream ohci_hcd
[   12.359506] usb usb6: SerialNumber: 0000:00:13.1
[   12.365225] hub 6-0:1.0: USB hub found
[   12.369153] hub 6-0:1.0: 3 ports detected
[   12.375999] ohci-pci 0000:00:14.5: OHCI PCI host controller
[   12.382021] ohci-pci 0000:00:14.5: new USB bus registered, assigned bu=
s number 7
[   12.389720] ohci-pci 0000:00:14.5: irq 18, io mem 0xfe6f6000
[   12.450036] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   12.457028] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[   12.464460] usb usb7: Product: OHCI PCI host controller
[   12.469837] usb usb7: Manufacturer: Linux 3.16.0-rc5upstream ohci_hcd
[   12.476465] usb usb7: SerialNumber: 0000:00:14.5
[   12.482180] hub 7-0:1.0: USB hub found
[   12.486109] hub 7-0:1.0: 2 ports detected
[   12.491102] initcall ohci_pci_init+0x0/0x60 returned 0 after 576748 us=
ecs
[   12.498103] calling  uhci_hcd_init+0x0/0xa4 @ 1
[   12.502766] uhci_hcd: USB Universal Host Controller Interface driver
[   12.509468] initcall uhci_hcd_init+0x0/0xa4 returned 0 after 6550 usec=
s
[   12.516280] calling  usblp_driver_init+0x0/0x16 @ 1
[   12.521414] usbcore: registered new interface driver usblp
[   12.527062] initcall usblp_driver_init+0x0/0x16 returned 0 after 5632 =
usecs
[   12.534233] calling  kgdbdbgp_start_thread+0x0/0x57 @ 1
[   12.539612] initcall kgdbdbgp_start_thread+0x0/0x57 returned 0 after 0=
 usecs
[   12.546870] calling  i8042_init+0x0/0x3b7 @ 1
[   12.551518] i8042: PNP: No PS/2 controller found. Probing ports direct=
ly.
[   12.559039] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.564163] serio: i8042 AUX port at 0x60,0x64 irq 12
[   12.569401] initcall i8042_init+0x0/0x3b7 returned 0 after 17641 usecs
[   12.576127] calling  serport_init+0x0/0x2e @ 1
[   12.580700] initcall serport_init+0x0/0x2e returned 0 after 0 usecs
[   12.587159] calling  mousedev_init+0x0/0x54 @ 1
[   12.592025] mousedev: PS/2 mouse device common for all mice
[   12.597768] initcall mousedev_init+0x0/0x54 returned 0 after 5812 usec=
s
[   12.604581] calling  evdev_init+0x0/0xf @ 1
[   12.609210] initcall evdev_init+0x0/0xf returned 0 after 316 usecs
[   12.615583] calling  atkbd_init+0x0/0x20 @ 1
[   12.620053] initcall atkbd_init+0x0/0x20 returned 0 after 75 usecs
[   12.626423] calling  psmouse_init+0x0/0x8a @ 1
[   12.631213] initcall psmouse_init+0x0/0x8a returned 0 after 205 usecs
[   12.637858] calling  cmos_init+0x0/0x66 @ 1
[   12.642214] rtc_cmos 00:01: RTC can wake from S4
[   12.647441] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[   12.653759] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvr=
am, hpet irqs
[   12.661676] initcall cmos_init+0x0/0x66 returned 0 after 19073 usecs
[   12.668219] calling  i2c_i801_init+0x0/0x92 @ 1
[   12.672997] initcall i2c_i801_init+0x0/0x92 returned 0 after 112 usecs
[   12.679718] calling  cpufreq_gov_dbs_init+0x0/0xf @ 1
[   12.684917] initcall cpufreq_gov_dbs_init+0x0/0xf returned 0 after 0 u=
secs
[   12.691997] calling  efivars_sysfs_init+0x0/0x1d0 @ 1
[   12.697196] initcall efivars_sysfs_init+0x0/0x1d0 returned -19 after 0=
 usecs
[   12.704456] calling  efivars_pstore_init+0x0/0x89 @ 1
[   12.709654] initcall efivars_pstore_init+0x0/0x89 returned 0 after 0 u=
secs
[   12.716736] calling  vhost_net_init+0x0/0x20 @ 1
[   12.721606] initcall vhost_net_init+0x0/0x20 returned 0 after 115 usec=
s
[   12.728428] calling  vhost_init+0x0/0x7 @ 1
[   12.732738] initcall vhost_init+0x0/0x7 returned 0 after 0 usecs
[   12.738928] calling  staging_init+0x0/0x7 @ 1
[   12.743416] initcall staging_init+0x0/0x7 returned 0 after 0 usecs
[   12.749787] calling  eeepc_laptop_init+0x0/0x4f @ 1
[   12.754963] initcall eeepc_laptop_init+0x0/0x4f returned -19 after 148=
 usecs
[   12.762226] calling  sock_diag_init+0x0/0xf @ 1
[   12.766911] initcall sock_diag_init+0x0/0xf returned 0 after 16 usecs
[   12.773548] calling  llc_init+0x0/0x1b @ 1
[   12.777768] initcall llc_init+0x0/0x1b returned 0 after 0 usecs
[   12.783868] calling  snap_init+0x0/0x35 @ 1
[   12.788179] initcall snap_init+0x0/0x35 returned 0 after 3 usecs
[   12.794369] calling  blackhole_module_init+0x0/0xf @ 1
[   12.799663] initcall blackhole_module_init+0x0/0xf returned 0 after 0 =
usecs
[   12.806837] calling  nfnetlink_init+0x0/0x4b @ 1
[   12.811593] Netfilter messages via NETLINK v0.30.
[   12.816454] initcall nfnetlink_init+0x0/0x4b returned 0 after 4750 use=
cs
[   12.823359] calling  nfnetlink_log_init+0x0/0x8f @ 1
[   12.828485] initcall nfnetlink_log_init+0x0/0x8f returned 0 after 10 u=
secs
[   12.835569] calling  nf_conntrack_standalone_init+0x0/0x70 @ 1
[   12.841580] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   12.848087] initcall nf_conntrack_standalone_init+0x0/0x70 returned 0 =
after 6360 usecs
[   12.856245] calling  ctnetlink_init+0x0/0x92 @ 1
[   12.861001] ctnetlink v0.93: registering with nfnetlink.
[   12.866472] initcall ctnetlink_init+0x0/0x92 returned 0 after 5347 use=
cs
[   12.873379] calling  nf_conntrack_ftp_init+0x0/0x195 @ 1
[   12.878855] initcall nf_conntrack_ftp_init+0x0/0x195 returned 0 after =
3 usecs
[   12.886213] calling  nf_conntrack_irc_init+0x0/0x148 @ 1
[   12.891694] initcall nf_conntrack_irc_init+0x0/0x148 returned 0 after =
5 usecs
[   12.899046] calling  nf_conntrack_sip_init+0x0/0x1e4 @ 1
[   12.904519] initcall nf_conntrack_sip_init+0x0/0x1e4 returned 0 after =
0 usecs
[   12.911872] calling  xt_init+0x0/0xb5 @ 1
[   12.916010] initcall xt_init+0x0/0xb5 returned 0 after 7 usecs
[   12.922022] calling  tcpudp_mt_init+0x0/0x14 @ 1
[   12.926778] initcall tcpudp_mt_init+0x0/0x14 returned 0 after 0 usecs
[   12.933415] calling  connsecmark_tg_init+0x0/0xf @ 1
[   12.938529] initcall connsecmark_tg_init+0x0/0xf returned 0 after 0 us=
ecs
[   12.945526] calling  nflog_tg_init+0x0/0xf @ 1
[   12.950105] initcall nflog_tg_init+0x0/0xf returned 0 after 0 usecs
[   12.956563] calling  secmark_tg_init+0x0/0xf @ 1
[   12.961319] initcall secmark_tg_init+0x0/0xf returned 0 after 0 usecs
[   12.967956] calling  tcpmss_tg_init+0x0/0x14 @ 1
[   12.972712] initcall tcpmss_tg_init+0x0/0x14 returned 0 after 0 usecs
[   12.979351] calling  conntrack_mt_init+0x0/0x14 @ 1
[   12.984376] initcall conntrack_mt_init+0x0/0x14 returned 0 after 0 use=
cs
[   12.991283] calling  policy_mt_init+0x0/0x14 @ 1
[   12.996038] initcall policy_mt_init+0x0/0x14 returned 0 after 0 usecs
[   13.002675] calling  state_mt_init+0x0/0xf @ 1
[   13.007252] initcall state_mt_init+0x0/0xf returned 0 after 0 usecs
[   13.013712] calling  gre_offload_init+0x0/0x14 @ 1
[   13.018649] initcall gre_offload_init+0x0/0x14 returned 0 after 0 usec=
s
[   13.025466] calling  sysctl_ipv4_init+0x0/0x44 @ 1
[   13.030443] initcall sysctl_ipv4_init+0x0/0x44 returned 0 after 39 use=
cs
[   13.037349] calling  tunnel4_init+0x0/0x6d @ 1
[   13.041927] initcall tunnel4_init+0x0/0x6d returned 0 after 0 usecs
[   13.048388] calling  ipv4_netfilter_init+0x0/0xf @ 1
[   13.053501] initcall ipv4_netfilter_init+0x0/0xf returned 0 after 0 us=
ecs
[   13.060496] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x150 @ 1
[   13.066970] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x150 returned=
 0 after 191 usecs
[   13.075307] calling  nf_defrag_init+0x0/0x14 @ 1
[   13.080064] initcall nf_defrag_init+0x0/0x14 returned 0 after 0 usecs
[   13.086703] calling  ip_tables_init+0x0/0x8f @ 1
[   13.091482] ip_tables: (C) 2000-2006 Netfilter Core Team
[   13.096954] initcall ip_tables_init+0x0/0x8f returned 0 after 5369 use=
cs
[   13.103861] calling  iptable_filter_init+0x0/0x40 @ 1
[   13.109172] initcall iptable_filter_init+0x0/0x40 returned 0 after 103=
 usecs
[   13.116438] calling  iptable_mangle_init+0x0/0x40 @ 1
[   13.121721] initcall iptable_mangle_init+0x0/0x40 returned 0 after 79 =
usecs
[   13.128896] calling  reject_tg_init+0x0/0xf @ 1
[   13.133561] initcall reject_tg_init+0x0/0xf returned 0 after 0 usecs
[   13.140111] calling  ulog_tg_init+0x0/0x74 @ 1
[   13.144708] initcall ulog_tg_init+0x0/0x74 returned 0 after 17 usecs
[   13.151259] calling  cubictcp_register+0x0/0x72 @ 1
[   13.156283] TCP: cubic registered
[   13.159700] initcall cubictcp_register+0x0/0x72 returned 0 after 3339 =
usecs
[   13.166875] calling  xfrm_user_init+0x0/0x43 @ 1
[   13.171629] Initializing XFRM netlink socket
[   13.176043] initcall xfrm_user_init+0x0/0x43 returned 0 after 4313 use=
cs
[   13.182949] calling  inet6_init+0x0/0x2c3 @ 1
[   13.187696] NET: Registered protocol family 10
[   13.193092] initcall inet6_init+0x0/0x2c3 returned 0 after 5525 usecs
[   13.199734] calling  ah6_init+0x0/0x75 @ 1
[   13.203956] initcall ah6_init+0x0/0x75 returned 0 after 0 usecs
[   13.210051] calling  esp6_init+0x0/0x75 @ 1
[   13.214360] initcall esp6_init+0x0/0x75 returned 0 after 4 usecs
[   13.220546] calling  xfrm6_transport_init+0x0/0x14 @ 1
[   13.225839] initcall xfrm6_transport_init+0x0/0x14 returned 0 after 4 =
usecs
[   13.233013] calling  xfrm6_mode_tunnel_init+0x0/0x14 @ 1
[   13.238479] initcall xfrm6_mode_tunnel_init+0x0/0x14 returned 0 after =
0 usecs
[   13.245829] calling  xfrm6_beet_init+0x0/0x14 @ 1
[   13.250669] initcall xfrm6_beet_init+0x0/0x14 returned 0 after 0 usecs
[   13.257391] calling  ip6_tables_init+0x0/0x8f @ 1
[   13.262255] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   13.267815] initcall ip6_tables_init+0x0/0x8f returned 0 after 5453 us=
ecs
[   13.274805] calling  ip6table_filter_init+0x0/0x40 @ 1
[   13.280251] initcall ip6table_filter_init+0x0/0x40 returned 0 after 15=
0 usecs
[   13.287599] calling  ip6table_mangle_init+0x0/0x40 @ 1
[   13.293033] initcall ip6table_mangle_init+0x0/0x40 returned 0 after 13=
7 usecs
[   13.300380] calling  nf_conntrack_l3proto_ipv6_init+0x0/0x129 @ 1
[   13.306668] initcall nf_conntrack_l3proto_ipv6_init+0x0/0x129 returned=
 0 after 16 usecs
[   13.314914] calling  nf_defrag_init+0x0/0x4c @ 1
[   13.319690] initcall nf_defrag_init+0x0/0x4c returned 0 after 24 usecs
[   13.326418] calling  ipv6header_mt6_init+0x0/0xf @ 1
[   13.331528] initcall ipv6header_mt6_init+0x0/0xf returned 0 after 0 us=
ecs
[   13.338523] calling  reject_tg6_init+0x0/0xf @ 1
[   13.343275] initcall reject_tg6_init+0x0/0xf returned 0 after 0 usecs
[   13.349912] calling  sit_init+0x0/0xbc @ 1
[   13.354126] sit: IPv6 over IPv4 tunneling driver
[   13.359859] initcall sit_init+0x0/0xbc returned 0 after 5602 usecs
[   13.366224] calling  packet_init+0x0/0x39 @ 1
[   13.370710] NET: Registered protocol family 17
[   13.375293] initcall packet_init+0x0/0x39 returned 0 after 4484 usecs
[   13.381926] calling  br_init+0x0/0x90 @ 1
[   13.386096] initcall br_init+0x0/0x90 returned 0 after 44 usecs
[   13.392197] calling  init_rpcsec_gss+0x0/0x54 @ 1
[   13.397096] initcall init_rpcsec_gss+0x0/0x54 returned 0 after 58 usec=
s
[   13.403908] calling  dcbnl_init+0x0/0x5e @ 1
[   13.408308] initcall dcbnl_init+0x0/0x5e returned 0 after 4 usecs
[   13.414583] calling  init_dns_resolver+0x0/0xcd @ 1
[   13.419619] Key type dns_resolver registered
[   13.424014] initcall init_dns_resolver+0x0/0xcd returned 0 after 4310 =
usecs
[   13.431187] calling  mcheck_init_device+0x0/0x177 @ 1
[   13.437316] initcall mcheck_init_device+0x0/0x177 returned 0 after 909=
 usecs
[   13.444623] calling  mcheck_debugfs_init+0x0/0x3e @ 1
[   13.449838] initcall mcheck_debugfs_init+0x0/0x3e returned 0 after 14 =
usecs
[   13.457008] calling  severities_debugfs_init+0x0/0x3e @ 1
[   13.462570] initcall severities_debugfs_init+0x0/0x3e returned 0 after=
 5 usecs
[   13.470007] calling  threshold_init_device+0x0/0x44 @ 1
[   13.475894] initcall threshold_init_device+0x0/0x44 returned 0 after 4=
99 usecs
[   13.483331] calling  hpet_insert_resource+0x0/0x1e @ 1
[   13.488619] initcall hpet_insert_resource+0x0/0x1e returned 0 after 0 =
usecs
[   13.495789] calling  update_mp_table+0x0/0x527 @ 1
[   13.500720] initcall update_mp_table+0x0/0x527 returned 0 after 0 usec=
s
[   13.507532] calling  lapic_insert_resource+0x0/0x46 @ 1
[   13.512910] initcall lapic_insert_resource+0x0/0x46 returned 0 after 0=
 usecs
[   13.520169] calling  io_apic_bug_finalize+0x0/0x1a @ 1
[   13.525459] initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 0 =
usecs
[   13.532628] calling  print_ICs+0x0/0x437 @ 1
[   13.537021] initcall print_ICs+0x0/0x437 returned 0 after 0 usecs
[   13.543296] calling  print_ipi_mode+0x0/0x2e @ 1
[   13.548047] Using IPI No-Shortcut mode
[   13.551905] initcall print_ipi_mode+0x0/0x2e returned 0 after 3770 use=
cs
[   13.558806] calling  pat_memtype_list_init+0x0/0x37 @ 1
[   13.564189] initcall pat_memtype_list_init+0x0/0x37 returned 0 after 6=
 usecs
[   13.571450] calling  init_oops_id+0x0/0x50 @ 1
[   13.576024] initcall init_oops_id+0x0/0x50 returned 0 after 1 usecs
[   13.582481] calling  pm_qos_power_init+0x0/0x5d @ 1
[   13.587890] initcall pm_qos_power_init+0x0/0x5d returned 0 after 381 u=
secs
[   13.594972] calling  pm_debugfs_init+0x0/0x2a @ 1
[   13.599821] initcall pm_debugfs_init+0x0/0x2a returned 0 after 6 usecs
[   13.606548] calling  printk_late_init+0x0/0x38 @ 1
[   13.611479] initcall printk_late_init+0x0/0x38 returned 0 after 0 usec=
s
[   13.618292] calling  tk_debug_sleep_time_init+0x0/0x41 @ 1
[   13.623945] initcall tk_debug_sleep_time_init+0x0/0x41 returned 0 afte=
r 6 usecs
[   13.631472] calling  debugfs_kprobe_init+0x0/0xa6 @ 1
[   13.636699] initcall debugfs_kprobe_init+0x0/0xa6 returned 0 after 25 =
usecs
[   13.643868] calling  taskstats_init+0x0/0x6e @ 1
[   13.648637] registered taskstats version 1
[   13.652851] initcall taskstats_init+0x0/0x6e returned 0 after 4134 use=
cs
[   13.659751] calling  clear_boot_tracer+0x0/0x2d @ 1
[   13.664772] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 use=
cs
[   13.671671] calling  kdb_ftrace_register+0x0/0x35 @ 1
[   13.676873] initcall kdb_ftrace_register+0x0/0x35 returned 0 after 2 u=
secs
[   13.683952] calling  fault_around_debugfs+0x0/0x3a @ 1
[   13.689245] initcall fault_around_debugfs+0x0/0x3a returned 0 after 6 =
usecs
[   13.696414] calling  max_swapfiles_check+0x0/0x7 @ 1
[   13.701523] initcall max_swapfiles_check+0x0/0x7 returned 0 after 0 us=
ecs
[   13.708515] calling  set_recommended_min_free_kbytes+0x0/0xb0 @ 1
[   13.714788] initcall set_recommended_min_free_kbytes+0x0/0xb0 returned=
 0 after 1 usecs
[   13.722941] calling  kmemleak_late_init+0x0/0x8e @ 1
[   13.728117] kmemleak: Kernel memory leak detector initialized
[   13.728120] kmemleak: Automatic memory scanning thread started
[   13.740039] initcall kmemleak_late_init+0x0/0x8e returned 0 after 1171=
7 usecs
[   13.747398] calling  check_early_ioremap_leak+0x0/0x5d @ 1
[   13.753048] initcall check_early_ioremap_leak+0x0/0x5d returned 0 afte=
r 0 usecs
[   13.760581] calling  init_root_keyring+0x0/0xa @ 1
[   13.765541] initcall init_root_keyring+0x0/0xa returned 0 after 23 use=
cs
[   13.772450] calling  fail_make_request_debugfs+0x0/0x23 @ 1
[   13.778230] initcall fail_make_request_debugfs+0x0/0x23 returned 0 aft=
er 40 usecs
[   13.785941] calling  prandom_reseed+0x0/0x3e @ 1
[   13.790698] initcall prandom_reseed+0x0/0x3e returned 0 after 0 usecs
[   13.797336] calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
[   13.803798] initcall pci_resource_alignment_sysfs_init+0x0/0x14 return=
ed 0 after 6 usecs
[   13.812133] calling  pci_sysfs_init+0x0/0x44 @ 1
[   13.818219] initcall pci_sysfs_init+0x0/0x44 returned 0 after 1300 use=
cs
[   13.825127] calling  boot_wait_for_devices+0x0/0x28 @ 1
[   13.830510] initcall boot_wait_for_devices+0x0/0x28 returned -19 after=
 0 usecs
[   13.837954] calling  deferred_probe_initcall+0x0/0x80 @ 1
[   13.843594] initcall deferred_probe_initcall+0x0/0x80 returned 0 after=
 75 usecs
[   13.851126] calling  late_resume_init+0x0/0x190 @ 1
[   13.856151]   Magic number: 6:818:135
[   13.860039] initcall late_resume_init+0x0/0x190 returned 0 after 3799 =
usecs
[   13.867213] calling  firmware_memmap_init+0x0/0x29 @ 1
[   13.872811] initcall firmware_memmap_init+0x0/0x29 returned 0 after 29=
8 usecs
[   13.880164] calling  pci_mmcfg_late_insert_resources+0x0/0x43 @ 1
[   13.886442] initcall pci_mmcfg_late_insert_resources+0x0/0x43 returned=
 0 after 0 usecs
[   13.894600] calling  tcp_congestion_default+0x0/0xf @ 1
[   13.899982] initcall tcp_congestion_default+0x0/0xf returned 0 after 0=
 usecs
[   13.907252] calling  ip_auto_config+0x0/0xeb7 @ 1
[   13.912107] initcall ip_auto_config+0x0/0xeb7 returned 0 after 8 usecs
[   13.918834] calling  software_resume+0x0/0x280 @ 1
[   13.923768] PM: Hibernation image not present or could not be loaded.
[   13.930401] initcall software_resume+0x0/0x280 returned -2 after 6484 =
usecs
[   13.937856] async_waiting @ 1
[   13.940915] async_continuing @ 1 after 0 usec
[   13.945680] Freeing unused kernel memory: 944K (c185c000 - c1948000)
[   13.952262] Write protecting the kernel text: 6264k
[   13.957327] Write protecting the kernel read-only data: 1856k
[   13.963245] NX-protecting the kernel data: 3976k
=0Dinit started: BusyBox v1.14.3 ([   13.971446] consoletype (1260) used =
greatest stack depth: 6648 bytes left
2014-07-14 12:59:56 EDT)
Mounting directories  [  OK  ]
mount: mount point /proc/bus/usb does not exist
mount: mount point /proc/xen does not exist
mount: mount point /sys/kernel/config does not exist
cat: /sys/hypervisor/type: N[   14.123882] udevd (1296): /proc/1296/oom_a=
dj is deprecated, please use /proc/1296/oom_score_adj instead.
o such file or directory
/usr/bin/load_xen_modules: line 3: [: =3D=3D: unary operator expected
[   14.160244] calling  acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] @ 134=
2
[   14.167535] acpi-cpufreq: overriding BIOS providet
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[   14.200041] calling  d=
rm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] @ 1413
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^Gudevd-work[1343]: e=
rror op[   14.214597] SCSI subsystem initialized
ening ATTR{/sys/[   14.219218] initcall init_scsi+0x0/0x90 [scsi_mod] ret=
urned 0 after 38053 usecs
devices/system/cpu/cpu0/online} [   14.230740] calling  rtl8169_pci_drive=
r_init+0x0/0x1000 [r8169] @ 1426
for writing: Per[   14.237820] r8169 Gigabit Ethernet driver 2.3LK-NAPI l=
oaded
mission denied
[   14.244998] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have AS=
PM control

[   14.254310] calling  skge_init_module+0x0/0x1000 [skge] @ 1478
[   14.254635] calling  ata_init+0x0/0x295 [libata] @ 1365
[   14.256315] r8169 0000:02:00.0: irq 42 for MSI/MSI-X
[   14.257795] r8169 0000:02:00.0 eth0: RTL8168c/8111c at 0xf8412000, 00:=
25:11:18:a1:2e, XID 1c4000c0 IRQ 42
[   14.257796] r8169 0000:02:00.0 eth0: jumbo features [frames: 6128 byte=
s, tx checksumming: ko]
[   14.262138] initcall rtl8169_pci_driver_init+0x0/0x1000 [r8169] return=
ed 0 after 23845 usecs
[   14.298557] modprobe (1426) used greatest stack depth: 5492 bytes left
[   14.298991] skge: 1.14 addr 0xfebfc000 irq 20 chip Yukon rev 1
[   14.304150] libata version 3.00 loaded.
[   14.304161] initcall ata_init+0x0/0x295 [libata] returned 0 after 4839=
9 usecs
[   14.305014] skge 0000:04:05.0 eth1: addr 00:0a:5e:5c:f5:72
[   14.305154] initcall skge_init_module+0x0/0x1000 [skge] returned 0 aft=
er 6886 usecs
[   14.305395] calling  acpi_wmi_init+0x0/0x1000 [wmi] @ 1456
Waiting for devi[   14.306018] wmi: Mapper loaded
[   14.306021] initcall acpi_wmi_init+0x0/0x1000 [wmi] returned 0 after 6=
09 usecs
ces [[   14.354905] calling  ata_generic_pci_driver_init+0x0/0x1000 [ata_=
generic] @ 1485
[   14.362743] initcall ata_generic_pci_driver_init+0x0/0x1000 [ata_gener=
ic] returned 0 after 213 usecs
[   14.376037] calling  ahci_pci_driver_init+0x0/0x1000 [ahci] @ 1442
[   14.382479] ahci 0000:00:11.0: version 3.0
[   14.389 0x3f impl SATA mode
[   14.397825] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo p=
mp pio slum part ccc=20
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G  OK  ]
[   14.418454] scsi0 : ahci
[   14.422328] scsi1 : ahci
[   14.426323] scsi2 : ahci
[   14.430491] scsi3 : ahci
[ 8] initcall drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] returned =
0 after 221480 usecs
^G^G^G[   14.444644] scsi4 : ahci
[   14.448332] calling  ttm_init+0x0/0x1000 [ttm] @ 1413
[   14.448745] scsi5 : ahci
[   14.449633] ata1: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
d00 irq 22
[   14.449636] ata2: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
d80 irq 22
[   14.449638] ata3: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
e00 irq 22
[   14.449641] ata4: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
e80 irq 22
[   14.449643] ata5: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
f00 irq 22
[   14.449646] ata6: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
f80 irq 22
[   14.451991] ahci 0000:03:00.0: JMB361 has only one port
[   14.452005] ahci 0000:03:00.0: forcing port_map 0x3 -> 0x1
[   14.452107] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps =
0x1 impl SATA mode
[   14.452109] ahci 0000:03:00.0: flags: 64bit ncq led clo pmp pio=20
[   14.454796] scsi6 : ahci
[   14.455872] scsi7 : ahci
[   14.456723] ata7: SATA max UDMA/133 abar m8192@0xfeafe000 port 0xfeafe=
100 irq 19
[   14.456724] ata8: DUMMY
[   14.456896] initcall ahci_pci_driver_init+0x0/0x1000 [ahci] returned 0=
 after 72807 usecs
[   14.551138] initcall ttm_init+0x0/0x1000 [ttm] returned 0 after 154 us=
ecs
[   14.558538] calling  fb_console_init+0x0/0x1000 [fbcon] @ 2017
[   14.564846] initcall fb_console_init+0x0/0x1000 [fbcon] returned 0 aft=
er 194 usecs
[   14.574610] calling  radeon_init+0x0/0xb0 [radeon] @ 1413
[   14.580172] [drm] radeon kernel modesetting enabled.
[   14.586993] [drm] initializing kernel modesetting (RS780 0x1002:0x9610=
 0x1019:0x2119).
[   14.595191] [drm] register mmio base: 0xFE8F0000
[   14.599944] [drm] register mmio size: 65536
[   14.605495] ATOM BIOS: 113
[   14.608391] radeon 0000:01:05.0: VRAM: 256M 0x00000000C0000000 - 0x000=
00000CFFFFFFF (256M used)
[   14.617348] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x0000=
0000BFFFFFFF
[   14.625143] [drm] Detected VRAM RAM=3D256M, BAR=3D256M
[   14.630073] [drm] RAM width 32bits DDR
[   14.634333] [TTM] Zone  kernel: Available graphics memory: 432678 kiB
[   14.640982] [TTM] Zone highmem: Available graphics memory: 1941386 kiB
[   14.647702] [TTM] Initializing pool allocator
[   14.652282] [TTM] Initializing DMA pool allocator
[   14.657322] [drm] radeon: 256M of VRAM memory ready
[   14.662347] [drm] radeon: 512M of GTT memory ready.
[   14.667525] [drm] Loading RS780 Microcode
[   14.672121] [drm] radeon: power management initialized
[   14.677411] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   14.697095] [drm] PCIE GART of 512M enabled (table at 0x00000000C00400=
00).
[   14.704283] radeon 0000:01:05.0: WB enabled
[00000a0000c00 and cpu addr 0xffc9fc00
[   14.718987] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013)=
.
[   14.725844] [drm] Driver supports precise vblank timestamp query.
^G^G^G^G^G^G^G^G[   14.732162] [drm] radeon: irq initialized.
^G^G^G^G^G^G^G^G[   14.762480] ata6: SATA link down (SStatus 0 SControl 3=
00)
[   14.768095] ata3: SATA link down (SStatus 0 SControl 300)
[   [drm] Connector 0:
[   14.773497] [drm]   VGA-1
[   14.773498] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7=
e4c 0x7e4c
[   14.773498] [drm]   Encoders:
[   14.773499] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   14.773499] [drm] Connector 1:
[   14.773500] [drm]   HDMI-A-1
[   14.773500] [drm]   HPD3
[   14.773501] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7=
e5c 0x7e5c
[   14.773501] [drm]   Encoders:
[   14.773502] [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[   14.781836] radeon 0000:01:05.0: No connectors reported connected with=
 modes
[   14.781862] [drm] Cannot find any crtc or sizes - going 1024x768
[   14.795918] [drm] fb mappable at 0xD0141000
[   14.795918] [drm] vram apper at 0xD0000000
[   14.795919] [drm] size 3145728
[   14.795919] [drm] fb depth is 24
[   14.795919] [drm]    pitch is 4096
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[   14.871571] fbcon: radeondrmfb (fb0) i=
s primary device
[   14.871626] ata4: SATA link down (SStatus 0 SControl 300)
[   14.ffer device
[   14.916682] radeon 0000:01:05.0: registered panic notifier
[   14.922397] ata1: softreset failed (device not ready)
^G^G^G^G^G^G^G^G[   14.927637] ata1: applying PMP SRST workaround and ret=
rying
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[   14.938721] [drm] Init=
ialized radeon 2.39.0 20080528 for 0000:01:05.0 on minor 0
[   14.946883] initcall radeon_init+0x0/0xb0 [radeon] returned 0 after 35=
8429 usecs
[   14.954872] modprobe (1413) used greatest stack depth: 5436 bytes left
[   15.024215] ata2: softreset failed (device not ready)
[   15.029420] ata2: applying PMP SRST workaround and retrying
[   15.089233] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   15.097889] ata1.00: ATA-7: Maxtor 6L080M0, BACE1G10,   15.114278] ata=
1.00: configured for UDMA/133
[   15.114710] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L080M0   =
1G10 PQ: 0 ANSI: 5
^G^G^G^G^G^G^G^G[   15.128693] calling  crc_t10dif_mod_init+0x0/0x1000 [c=
rc_t10dif] @ 2539
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[   15.137418] calling  crct10dif_mod_ini=
t+0x0/0x1000 [crct10dif_generic] @ 2547
^G^G^G^G[   15.146281] initcall crct10dif_mod_init+0x0/0x1000 [crct10dif_=
generic] returned 0 after 67 usecs
[   15.156890] initcall crc_t10dif_mod_init+0x0/0x1000 [crc_t10dif] retur=
ned 0 after 20412 usecs
[   15.166793] calling  init_sd+0x0/0x1000 [sd_mod] @ 2539
[   15.173065] initcall init_sd+0x0/0x1000 [sd_mod] returned 0 after 868 =
usecs
[   15.173123] sd 0:0:0:0: [sda] 156250000 512-byte logical blocks: (80.0=
 GB/74.5 GiB)
[   15.173384] sd 0:0:0:0: [sda] Write Protect is off
[   15.173386] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   15.173486] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[   15.195448]  sda: sda1 sda2 < sda5 >
[   15.197416] sd 0:0:0:0: [sda] Attached SCSI disk
[   15.216206] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   15.224755] ata2.00: ATA-7: Maxtor 6L080M0, BACE1G10, max UDMA/133
[   15.231136] ata2.00: 156250000 sectors, multi 0: LBA48 NCQ (depth 31/3=
2)
[   15.241135] ata2.00: configured for UDMA/133
[   15.245946] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6L080M0   =
1G10 P
[   15.255829] sd 1:0:0:0: [sdb] 156250000 512-byte logical blocks: (80.0=
 GB/74.5 GiB)
^G^G^G[   15.264010] sd 1:0:0:0: [sdb] Write Protect is off
[   15.264339] calling  init_sg+0x0/0x1000 [sg] @ 2563
[   15.264742] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   15.265058] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   15.265132] initcall init_sg+0x0/0x1000 [sg] returned 0 after 773 usec=
s
[   15.291956] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   15.297291] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[   15.325565]  sdb: sdb1
[   15.329356] sd 1:0:0:0: [sdb] Attached SCSI disk
[   15.334527] modprobe (1442) used greatest sta^GWaiting for init.pre_cu=
stom [  OK  ]
Waiting for fb [  OK  ]
Waiting for network [  OK  ]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [   15.539188] r8169 0000:02:00.0 eth0: link=
 down
[   15.539207] r8169 0000:02:00.0 eth0: link down
[   15.548367] IPv6: ADDRCG^G^G^G^G^G^G^G^G^G[   15.556321] device eth0 e=
ntered promiscuous mode
[  OK  ]
Bringing up interface eth1: =20
Determining IP information for e[   15.593146] skge 0000:04:05.0 eth1: en=
abling interface
th1...[   15.606331] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   17.937285] r8169 0000:02:00.0 eth0: link up
[   17.941689] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   18.845366] skge 0000:04:05.0 eth1: Link is up at 1000 Mbps, full dupl=
ex, flow control both
[   18.853970] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
 done.
[  OK  ]
Bringing up interface switch: =20
Determining IP information for s[   19.525883] switch: port 1(eth0) enter=
ed forwarding state
witch...[   19.531732] switch: p^G done.
[  OK  ]
touch: cannot touch `/var/lock/subsys/network': No such file or directory
Waiting for init.custom [  OK  ]

Starting SSHd ...

    SSH started [2995]


Waiting for SSHd [  OK  ]
WARNING: ssh currently running [2995] ignoring start request
[   25.708682] calling  crc32c_intel_mod_init+0x0/0x1000 [crc32c_intel] @=
 3031
[   25.715881] initcall crc32c_intel_mod_init+0xed 0 after 79 usecs
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[   25.749501] calling  libcrc32c_mod_ini=
t+0x0/0x1000 [libcrc32c] @ 3036
^G^G^G^G^G^G^G^G[   25.757186] initcall libcrc32c_mod_init+0x0/0x1000 [li=
bcrc32c] returned 0 after 6 usecs
^G^G^G^G^G^G^G^G[   25.769473] calling  iscsi_transport_init+0x0/0x1000 [=
scsi_transport_iscsi] @ 3038
[   25.777269] Loading iSCSI transport class v2.0-870.
[   25.782948] initcall iscsi_transport_init+0x0/0x1000 [scsi_transport_i=
scsi] returned 0 after 5542 usecs
[   25.795469] calling  iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] @ 3038
[   25.802209] iscsi: registered transport (tcp)
[   25.806693] initcall iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] returned=
 0 after 4575 usecs
Could not read fw values.
Jul 14 16:07:51 tst034 syslogd 1.5.0: restart.
[0:0:0:0]    disk    ATA      Maxtor 6L080M0   1G10 ^G^G^G^G^G^G^G^G^G^G^=
G^G^G^G^G^G00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host B=
ridge
00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI ridge (int gfx=
)
00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge =
(PCIE port 2)
00:07.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge =
(PCIE port 3)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller=
 [AHCI mode]
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Contro=
ller
00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Control=
ler
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Contro=
ller
00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Control=
ler
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Contro=
ller
00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,=
 Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,=
 Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,=
 Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,=
 Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,=
 Sempron] Link Control
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200 Gr=
aphics
01:05.1 Audio device: ATI Technologies Inc RS780 Azalia controller
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168=
B PCI Express Gigabit Ethernet controller (rev 02)
03:00.0 SATA controller: JMicron Technology Corp. JMB361 AHCI/IDE (rev 02=
)
03:00.1 IDE interface: JMicron Technology Corp. JMB361 AHCI/IDE (rev 02)
04:05.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T [Ma=
rvell] (rev 10)
04:07.0 Serial controller: NetMos Technology PCI 9835 Multi-I/O Controlle=
r (rev 01)
           CPU0       CPU1       CPU2       CPU3      =20
  0:        230         40       1930      11590   IO-APIC-edge      time=
r
  1:          0          0          0          2   IO-APIC-edge      i804=
2
  8:          0          1          1         11   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          0          0          0          4   IO-APIC-edge      i804=
2
 16:          0          0          0          2   IO-APIC-fasteoi   ohci=
_hcd:usb3, ohci_hcd:usb4
 17:          0          0          0          0   IO-APIC-fasteoi   ehci=
_hcd:usb1
 18:          0          0          0          5   IO-APIC-fasteoi   ohci=
_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7, radeon
 19:          0          0          0          0   IO-APIC-fasteoi   ehci=
_hcd:usb2, ahci
 20:          0          2          4         19   IO-APIC-fasteoi   eth1
 22:          0          1         10        210   IO-APIC-fasteoi   seri=
al, ahci
 42:          1          1          3         35   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupt=
s
LOC:      10549      10418       8083       1211   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring=
 interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:       1816       2211       2535       1968   Rescheduling interrupt=
s
CAL:        331        300        291        363   Function call interrup=
ts
TLB:         80         96         55         74   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrup=
ts
THR:          0          0          0^G^G          0   Threshold APIC int=
errupts
MCE:          0          0          0          0   Machine check exceptio=
ns
MCP:          1          1          1          1   Machine check polls
THR:          0          0          0          0   Hypervisor callback in=
terrupts
ERR:          0
MIS:          0
00000000-00000fff : reserved
00001000-0009f3ff : System RAM
0009f400-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000cebff : Video ROM
000cf000-000d09ff : Adapter ROM
000d1000-000d1fff : Adapter ROM
000d5000-000d57ff : Adapter ROM
000e6000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-cfeaffff : System RAM
  01000000-0161d1e6 : Kernel code
  0161d1e7-0185ab3f : Kernel data
  0194f000-01a28fff : Kernel bss
cfeb0000-cfebdfff : ACPI Tables
cfebe000-cfedffff : ACPI Non-volatile Storage
cfee0000-cfefffff : reserved
cff00000-dfffffff : PCI Bus 0000:00
  d0000000-dfffffff : PCI Bus 0000:01
    d0000000-dfffffff : 0000:01:05.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : pnp 00:05
f0000000-febfffff : PCI Bus 0000:00
  fdf00000-fdffffff : PCI Bus 0000:02
    fdff0000-fdffffff : 0000:02:00.0
      fdff0000-fdffffff : r8169
  fe6f6000-fe6f6fff : 0000:00:14.5
    fe6f6000-fe6f6fff : ohci_hcd
  fe6f7000-fe6f7fff : 0000:00:13.1
    fe6f7000-fe6f7fff : ohci_hcd
  fe6fc000-fe6fcfff : 0000:00:13.0
    fe6fc000-fe6fcfff : ohci_hcd
  fe6fd000-fe6fdfff : 0000:00:12.1
    fe6fd000-fe6fdfff : ohci_hcd
  fe6fe000-fe6fefff : 0000:00:12.0
    fe6fe000-fe6fefff : ohci_hcd
  fe6ff400-fe6ff4ff : 0000:00:13.2
    fe6ff400-fe6ff4ff : ehci_hcd
  fe6ff800-fe6ff8ff : 0000:00:12.2
    fe6ff800-fe6ff8ff : ehci_hcd
  fe6ffc00-fe6fffff : 0000:00:11.0
    fe6ffc00-fe6fffff : ahci
  fe700000-fe8fffff : PCI Bus 0000:01
    fe700000-fe7fffff : 0000:01:05.0
    fe8e8000-fe8ebfff : 0000:01:05.1
    fe8f0000-fe8fffff : 0000:01:05.0
  fe900000-fe9fffff : PCI Bus 0000:02
    fe9c0000-fe9dffff : 0000:02:00.0
    fe9ff000-fe9fffff : 0000:02:00.0
      fe9ff000-fe9fffff : r8169
  fea00000-feafffff : PCI Bus 0000:03
    feafe000-feafffff : 0000:03:00.0
      feafe000-feafffff : ahci
  feb00000-febfffff : PCI Bus 0000:04
    febc0000-febdffff : 0000:04:05.0
    febfc000-febfffff : 0000:04:05.0
      febfc000-febfffff : skge
fec00000-fec003ff : IOAPIC 0
fec10000-fec1001f : pnp 00:03
fed00000-fed003ff : HPET 2
  fed00000-fed003ff : PNP0103:00
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:02
ff700000-ffffffff : reserved
  ffb80000-ffbfffff : pnp 00:03
100000000-11fffffff : System RAM
MemTotal:        3882772 kB
MemFree:         3583412 kB
MemAvailable:    3494640 kB
Buffers:               0 kB
Cached:           241972 kB
SwapCached:            0 kB
Active:            41668 kB
Inactive:         201392 kB
Active(anon):      41668 kB
Inactive(anon):   201392 kB
Active(file):          0 kB
Inactive(file):        0 kB
Unevictable:        2664 kB
Mlocked:            2664 kB
HighTotal:       3017416 kB
HighFree:        2795900 kB
LowTotal:         865356 kB
LowFree:          787512 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          3632 kB
Mapped:             5764 kB
Shmem:            241972 kB
Slab:              40596 kB
SReclaimable:       6040 kB
SUnreclaim:        34556 kB
KernelStack:         840 kB
PageTables:          132 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1941384 kB
Committed_AS:     247852 kB
VmallocTotal:     122880 kB
VmallocUsed:       10576 kB
VmallocChunk:     105972 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepages[   26.614161] mount.nfs (3083) used greatest stack depth: 5156 =
bytes left
ize:       2048 kB
DirectMap4k:       14328 kB
DirectMap2M:      899072 kB
Waiting for init.late [  OK  ]
+ . /etc/init.d/functions
++ TEXTDOMAIN=3Dinitscripts
++ umask 022
++ PATH=3D/sbin:/usr/sbin:/bin:/usr/bin
++ export PATH
++ '[' -z '' ']'
++ COLUMNS=3D80
++ '[' -z '' ']'
+++ /sbin/consoletype
++ CONSOLETYPE=3Dserial
++ '[' -f /etc/sysconfig/i18n -a -z '' -a -z '' ']'
++ '[' -z '' ']'
++ '[' -f /etc/sysconfig/init ']'
++ . /etc/sysconfig/init
+++ BOOTUP=3Dcolor
+++ RES_COL=3D60
+++ MOVE_TO_COL=3D'echo -en \033[60G'
+++ SETCOLOR_SUCCESS=3D'echo -en \033[0;32m'
+++ SETCOLOR_FAILURE=3D'echo -en \033[0;31m'
+++ SETCOLOR_WARNING=3D'echo -en \033[0;33m'
+++ SETCOLOR_NORMAL=3D'echo -en \033[0;39m'
+++ LOGLEVEL=3D3
+++ PROMPT=3Dyes
+++ AUTOSWAP=3Dno
+++ ACTIVE_CONSOLES=3D'/dev/tty[1-6]'
++ '[' serial =3D serial ']'
++ BOOTUP=3Dserial
++ MOVE_TO_COL=3D
++ SETCOLOR_SUCCESS=3D
++ SETCOLOR_FAILURE=3D
++ SETCOLOR_WARNING=3D
++ SETCOLOR_NORMAL=3D
++ __sed_discard_ignored_files=3D'/\(~\|\.bak\|\.orig\|\.rpmnew\|\.rpmori=
g\|\.rpmsave\)$/d'
+ mkdir -p /mnt/lab
+ echo '192.168.102.1  build'
+ ping -q -c 1 build
PING build.dumpdata.com (192.168.102.1) 56(84) bytes of data.

--- build.dumpdata.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev =3D 0.197/0.197/0.197/0.000 ms
+ '[' 0 -eq 0 ']'
+ mount build:/srv/tftpboot/lab /mnt/lab -o vers=3D3
+ iscsiadm -m discovery -t st -p build
192.168.102.1:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.bd5777dc54e541=
e0bd772761999275e6
+ iscsiadm -m node -L all
Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.target=
:sn.bd5777dc54e541e0bd772761999275e6, portal: 192.168.102.1,3260]
Jul 14 16:07:52 tst034 iscsid: transport class version 2.0-870. iscsid ve=
rsion 2.0-870
Jul 14 16:07:52 tst034 iscsid: iSCSI daemon with pid=3D3066 started!
[   26.881967] scsi8 : iSCSI Initiator over TCP/IP
[   27.145207] scsi 8:0:0:0: Direct-Access     LIO-ORG  IBLOCK           =
4.0  PQ: 0 ANSI: 5
[   27.156485] sd 8:0:0:0: Attached [sdc] Mode Sense: 2f 00 00 00
: iqn.2003-01.or[   27.187790] calling  dm_init+0x0/0x3f [dm_mod] @ 3105
g.linux-iscsi.ta[   27.193840] sd 8:0:0:0: [sdc] Write cache: disabled, r=
ead cache: enabled, doesn't support DPO or FUA
rget:sn.bd5777dc[   27.204612] device-mapper: ioctl: 4.27.0-ioctl (2013-1=
0-30) initialised: dm-devel@redhat.com
54e541e0bd772761[   27.214475] initcall dm_init+0x0/0x3f [dm_mod] returne=
d 0 after 20506 usecs
999275e6, portal[   27.224076] calling  dm_multipath_init+0x0/0x1000 [dm_=
multipath] @ 3105
: 192.168.102.1,[   27.231599] device-mapper: multipath: version 1.7.0 lo=
aded
3260]: successfu[   27.238393] initcall dm_multipath_init+0x0/0x1000 [dm_=
multipath] returned 0 after 6887 usecs
l
^G+ modprobe dm-multipath
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[   27.253818]  sdc: unknown partition =
table
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^=
G+ sleep 5
[   27.279174] sd 8:0:0:0: [sdc] Attached SCSI disk
Jul 14 16:07:53 tst034 iscsid: connection1:0 is operational now
+ pvscan
  PV /dev/sdc   VG guests   lvm2 [931.44 GiB / 113.44 GiB free]
  Total: 1 [931.44 GiB] / in use: 1 [931.44 GiB] / in no VG: 0 G^G^G^G  3=
1 logical volume(s) in volume group "guests" now active
+ echo 'NFS done'
NFS done
+ xl info
xc: error: Could not obtain n libxc handle: No such file or directory
cannot init xl context
+ '[' -e /sys/kernel/debug/xen/mmu/p2m ']'
+ cat /sys/kernel/debug/xen/mmu/p2m
++ boot_parameter cpuplug
++ local param
++ local value
+++ cat /proc/cmdline
+++ tr -s ' \t' '\n'
+++ egrep '^cpuplug=3D|^cpuplug$'
+++ tail -1
++ param=3D
++ '[' -z '' ']'
++ return 1
+ HOTPLUG=3D
+ '[' 1 -eq 0 ']'
+ TMEM_LOADED=3D0
+ swapon /dev/xvda
swapon: /dev/xvda: stat failed: No such file or directory
+ '[' 255 -eq 0 ']'
++ boot_parameter run
++ local param
++ local value
+++ cat /proc/cmdline
+++ tr -s ' \t' '\n'
+++ egrep '^run=3D|^run$'
+++ tail -1
++ param=3D
++ '[' -z '' ']'
++ return 1
+ HOTPLUG=3D
+ '[' 1 -eq 0 ']'
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^GJul 14 16:07:58 tst034 init: starti=
ng pid 3302, tty '/dev/tty1': '/bin/sh'
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[   34.528898] switch: port 1(eth0) enter=
ed forwarding state
Jul 14 16:08:00 tst034 init: reloading /etc/inittab
Jul 14 16:08:00 tst034 init: starting pid 3306, tty '/dev/ttyS0': '/bin/s=
h'


BusyBox v1.14.3 (2014-07-14 12:59:56 EDT) built-in shell (ash)
Enter 'help' for a list of built-in commands.

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="bad.log"
Content-Transfer-Encoding: quoted-printable

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.0000Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-rc5upstream-00060-g8e655983b (konrad@=
build-external.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2=
) (GCC) ) #1 SMP Mon Jul 14 13:41:37 EDT 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfeaffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000cfeb0000-0x00000000cfebdfff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000cfebe000-0x00000000cfedffff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000cfee0000-0x00000000cfefffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000ff700000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usa=
ble
[    0.000000] Malformed early option 'acpi'
[    0.000000] Early serial console at I/O port 0xe400 (options '115200n8=
')
[    0.000000] bootconsole [uart0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: ECS A780GM-A Ultra/A780GM-A Ultra, BIOS 080015  04/01=
/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable =3D=3D> re=
served
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped a=
t [c00ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37800000-0x379fffff]
[    0.000000]  [mem 0x37800000-0x379fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x34000000-0x377fffff]
[    0.000000]  [mem 0x34000000-0x377fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37a00000-0x37bfdfff]
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] BRK [0x01a3b000, 0x01a3bfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x7aed3000-0x7fffefff]
[    0.000000] Allocated new RAMDISK: [mem 0x32ad2000-0x37bfd89e]
[    0.000000] Move RAMDISK from [mem 0x7aed3000-0x7fffe89e] to [mem 0x32=
ad2000-0x37bfd89e]
[    0.000000] ACPI: Early table ch0xCFEB0200 000084 (v01 040110 FACP1316=
 20100401 MSFT 00000097)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlo=
ck has zero address or length: 0x0000000000000000/0x1 (20140424/tbfadt-64=
9)
[    0.000000] ACPI: DSDT 0xCFEB0450 00A65F (v01 1AAAA  1AAAA000 00000000=
 INTL 20051117)
[    0.000000] ACPI: FACS 0xCFEBE000 000040
[    0.000000] ACPI: APIC 0xCFEB0390 00007C (v01 040110 APIC1316 20100401=
 MSFT 00000097)
[    0.000000] ACPI: MCFG 0xCFEB0410 00003C (v01 040110 OEMMCFG  20100401=
 MSFT 00000097)
[    0.000000] ACPI: OEMB 0xCFEBE040 000072 (v01 040110 OEMB1316 20100401=
 MSFT 00000097)
[    0.000000] ACPI: SRAT 0xCFEBAAB0 0000E8 (v03 AMD    FAM_F_10 00000002=
 AMD  00000001)
[    0.000000] ACPI: HPET 0xCFEBABA0 000038 (v01 040110 OEMHPET  20100401=
 MSFT 00000097)
[    0.000000] ACPI: SSDT 0xCFEBABE0 00088C (v01 A M I  POWERNOW 00000001=
 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 3716MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] BRK [0x01a3c000, 0x01a3cfff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x1fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xcfeaffff]
[    0.000000]   node   0: [mem 0x00000000-0x1fffffff]
[    0.000000] On node 0 totalpages: 982606
[    0.000000] free_area_init_node: node 0, pgdat c1849240, node_mem_map =
f06d2020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 224254 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7433 pages used for memmap
[    0.000000]   HighMem zone: 754354 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] smpboot: Allowing 6 CPUs, 2 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e5fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e6000-0x000fffff]
[    0.000000] e820: [mem 0xcff00000-0xff6fffff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:6 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f066c000 s35072 r0 d22272 u=
57344
[    0.000000] pcpu-alloc: s35072 r0 d22272 u57344 alloc=3D14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 980822
[    0.000000] Kernel command line: initrd=3Dinitramfs.cpio.gz acpi=3Ddeb=
ug initcall_debug loglevel=3D10 nofb selinux=3D0 console=3Duart8250,io,0x=
e400,115200n8 BOOT_IMAGE=3Dvmlinuz=20
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 =
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 by=
tes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:00120000)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 3798676K/3930424K available (6267K kernel code, 43=
4K rwdata, 1852K rodata, 940K init, 872K bss, 131748K reserved, 3017416K =
highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc185e000 - 0xc1949000   ( 940 kB)
[    0.000000]       .data : 0xc161f0a7 - 0xc185cbc0   (2294 kB)
[    0.000000]       .text : 0xc1000000 - 0xc161f0a7   (6268 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cpu_ids=3D6.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D6
[    0.000000] NR_IRQS:2304 nr_irqs:472 0
[    0.000000] CPU 0 irqstacks, hard=3Df0008000 soft=3Df000a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3000.174 MHz processor
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000024] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 6000.34 BogoMIPS (lpj=3D3000174)
[    0.011162] pid_max: default: 32768 minimum: 301
[    0.016049] ACPI: Core revision 20140424
[    0.093345] ACPI: All ACPI Tables successfully acquired
[    0.105159] Security Framework initialized
[    0.109460] SELinux:  Disabled at boot.
[    0.113665] Mount-cache hash tabler ID: 0
[    0.138084] CPU: Processor Core ID: 0
[    0.141929] mce: CPU supports 6 MCE banks
[    0.146142] LVT offset 0 assigned for vector 0xf9
[    0.151078] process: using AMD E400 aware idle routine
[    0.156467] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.156467] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
[    0.156467] tlb_flushall_shift: 6
[    0.172571] Freeing SMP alternatives memory: 28K (c1949000 - c1950000)
[    0.180408] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.186468] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.202753] smpboot: CPU0: AMD Phenom(tm) II X4 940 Processor (fam: 10=
, model: 04, stepping: 02)
[    0.313318] calling  xen_init_spinlocks_jump+0x0/0x23 @ 1
[    0.318982] initcall xen_init_spinlocks_jump+0x0/0x23 returned 0 after=
 0 usecs
[    0.326562] calling  set_real_mode_permissions+0x0/0x5d @ 1
[    0.332414] initcall set_real_mode_permissions+0x0/0x5d returned 0 aft=
er 0 usecs
[    0.340164] calling  trace_init_perf_perm_irq_work_exit+0x0/0x11 @ 1
[    0.346820] initcall trace_init_perf_perm_irq_work_exit+0x0/0x11 retur=
ned 0 after 0 usecs
[    0.355398] calling  trace_init_flags_sys_exit+0x0/0xe @ 1
[    0.361150] initcall trace_init_flags_sys_exit+0x0/0xe returned 0 afte=
r 0 usecs
[    0.368813] calling  trace_init_flags_sys_enter+0x0/0xe @ 1
[    0.374656] initcall trace_init_flags_sys_enter+0x0/0xe returned 0 aft=
er 0 usecs
[    0.382408] calling  init_hw_perf_events+0x0/0x52b @ 1
[    0.387797] Performance Events: AMD PMU driver.
[    0.392554] ... version:                0
[    0.396749] ... bit width:              48
[    0.401040] ... generic registers:      4
[    0.405244] ... value mask:             0000ffffffffffff
[    0.410803] ... max period:             00007fffffffffff
[    0.416371] ... fixed-purpose events:   0
[    0.420567] ... event mask:             000000000000000f
[    0.426173] initcall init_hw_perf_events+0x0/0x52b returned 0 after 87=
89 usecs
[    0.433749] calling  register_trigger_all_cpu_backtrace+0x0/0x13 @ 1
[    0.440411] initcall register_trigger_all_cpu_backtrace+0x0/0x13 retur=
ned 0 after 0 usecs
[    0.448984] calling  kvm_spinlock_init_jump+0x0/0x37 @ 1
[    0.454557] initcall kvm_spinlock_init_jump+0x0/0x37 returned 0 after =
0 usecs
[    0.462038] calling  spawn_ksoftirqd+0x0/0x23 @ 1
[    0.466997] initcall spawn_ksoftirqd+0x0/0x23 returned 0 after 0 usecs
[    0.473845] calling  init_workqueues+0x0/0x3e6 @ 1
[    0.479281] initcall init_workqueues+0x0/0x3e6 returned 0 after 976 us=
ecs
[    0.486401] calling  migration_init+0x0/0x5b @ 1
[    0.491232] initcall migration_init+0x0/0x5b returned 0 after 0 usecs
[    0.497986] calling  check_cpu_stall_init+0x0/0x16 @ 1
[    0.503367] initcall check_cpu_stall_init+0x0/0x16 returned 0 after 0 =
usecs
[    0.510671] calling  rcu_scheduler_really_started+0x0/0x11 @ 1
[    0.516788] initcall rcu_scheduler_really_started+0x0/0x11 returned 0 =
after 0 usecs
[    0.524814] calling  rcu_spawn_gp_kthread+0x0/0x87 @ 1
[    0.530253] initcall rcu_spawn_gp_kthread+0x0/0x87 returned 0 after 0 =
usecs
[    0.537553] calling  cpu_stop_init+0x0/0x5d @ 1
[    0.542331] initcall cpu_stop_init+0x0/0x5d returned 0 after 0 usecs
[    0.548991] calling  relay_init+0x0/0x11 @ 1
[    0.553458] initcall relay_init+0x0/0x11 returned 0 after 0 usecs
[    0.559848] calling  tracer_alloc_buffers+0x0/0x213 @ 1
[    0.565426] initcall tracer_alloc_buffers+0x0/0x213 returned 0 after 0=
 usecs
[    0.572812] calling  init_events+0x0/0x5f @ 1
[    0.577374] initcall init_events+0x0/0x5f returned 0 after 0 usecs
[    0.583852] calling  init_trace_printk+0x0/0xf @ 1
[    0.588873] initcall init_trace_printk+0x0/0xf returned 0 after 0 usec=
s
[    0.595814] calling  event_trace_memsetup+0x0/0x5a @ 1
[    0.601240] initcall event_trace_memsetup+0x0/0x5a returned 0 after 0 =
usecs
[    0.608544] calling  jump_label_init_module+0x0/0xf @ 1
[    0.614016] initcall jump_label_init_module+0x0/0xf returned 0 after 0=
 usecs
[    0.621407] calling  hashlib_init+0x0/0x11 @ 1
[    0.626067] initcall hashlib_init+0x0/0x11 returned 0 after 0 usecs
[    0.632640] calling  balloon_clear+0x0/0x3b @ 1
[    0.637383] initcall balloon_clear+0x0/0x3b returned 0 after 0 usecs
[    0.644055] calling  rand_initialize+0x0/0x30 @ 1
[    0.649016] initcall rand_initialize+0x0/0x30 returned 0 after 976 use=
cs
[    0.656043] calling  mce_amd_init+0x0/0x134 @ 1
[    0.660795] MCE: In-kernel MCE decoding enabled.
[    0.665629] initcall mce_amd_init+0x0/0x134 returned 0 after 976 usecs
[    0.672659] NMI watchdog: enabled on all CPUs, permanently consumes on=
e hw-PMU counter.
[    0.682833] CPU 1 irqstacks, hard=3Df02c2000 soft=3Def820000
[    0.688397] x86: Booting SMP configuration:
[    0.692775] .... node  #0, CPUs:      #1
[    0.707352] Initializing CPU#1
[    0.709881] process: System has AMD C1E enabled
[    0.710447] CPU 2 irqstacks, hard=3Df000
[    0.734742]  #3
[    0.734742] Initializing CPU#3
[    0.737326] x86: Booted up 1 node, 4 CPUs
[    0.737327] smpboot: Total of 4 processors activated (24001.39 BogoMIP=
S)
[    0.737368] process: Switch to broadcast mode on CPU3
[    0.760982] process: Switch to broadcast mode on CPU1
[    0.771287] process: Switch to broadcast mode on CPU0
[    0.776911] devtmpfs: initialized
[    0.781314] calling  ipc_ns_init+0x0/0x11 @ 1
[    0.785895] initcall ipc_ns_init+0x0/0x11 returned 0 after 0 usecs
[    0.792385] calling  init_mmap_min_addr+0x0/0x20 @ 1
[    0.797596] initcall init_mmap_min_addr+0x0/0x20 returned 0 after 0 us=
ecs
[    0.804742] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ =
1
[    0.811701] initcall init_cpufreq_transition_notifier_list+0x0/0x18 re=
turned 0 after 0 usecs
[    0.820568] calling  net_ns_init+0x0/0x100 @ 1
[    0.825378] initcall net_ns_init+0x0/0x100 returned 0 after 0 usecs
[    0.832012] calling  e820_mark_nvs_memory+0x0/0x4e @ 1
[    0.837409] PM: Registering ACPI NVS region [mem 0xcfebe000-0xcfedffff=
] (139264 bytes)
[    0.845797] initcall e820_mark_nvs_memory+0x0/0x4e returned 0 after 97=
6 usecs
[    0.853277] calling  cpufreq_tsc+0x0/0x26 @ 1
[    0.857854] initcall cpufreq_tsc+0x0/0x26 returned 0 after 0 usecs
[    0.864340] calling  reboot_init+0x0/0x1a @ 1
[    0.868925] initcall reboot_init+0x0/0x1a returned 0 after 0 usecs
[    0.875415] calling  init_lapic_sysfs+0x0/0x1b @ 1
[    0.880444] initcall init_lapic_sysfs+0x0/0x1b returned 0 after 0 usec=
s
[    0.887386] calling  cpu_hotplug_pm_sync_init+0x0/0x29 @ 1
[    0.893140] initcall cpu_hotplug_pm_sync_init+0x0/0x29 returned 0 afte=
r 0 usecs
[    0.900814] calling  alloc_frozen_cpus+0x0/0x7 @ 1
[    0.905833] initcall alloc_frozen_cpus+0x0/0x7 returned 0 after 0 usec=
s
[    0.912779] calling  wq_sysfs_init+0x0/0x11 @ 1
[    0.917666] initcall wq_sysfs_init+0x0/0x11 returned 0 after 0 usecs
[    0.917792] kworker/u12:0 (30) used greatest stack depth: 6980 bytes l=
eft
[    0.931463] calling  ksysfs_init+0x0/0x74 @ 1
[    0.936119] initcall ksysfs_init+0x0/0x74 returned 0 after 0 usecs
[    0.942610] calling  pm_init+0x0/0x45 @ 1
[    0.946889] initcall pm_init+0x0/0x45 returned 0 after 0 usecs
[    0.953010] calling  pm_disk_init+0x0/0x14 @ 1
[    0.957708] initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs
[    0.964292] calling  swsusp_header_init+0x0/0x30 @ 1
[    0.969498] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 us=
ecs
[    0.976628] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.982303] initcall init_jiffies_clocksource+0x0/0xf returned 0 after=
 0 usecs
[    0.989891] calling  cgroup_wq_init+0x0/0x7c @ 1
[    0.994794] initcall cgroup_wq_init+0x0/0x7c returned 0 after 0 usecs
[    1.001556] calling  event_trace_enable+0x0/0x155 @ 1
[    1.007827] initcall event_trace_enable+0x0/0x155 returned 0 after 976=
 usecs
[    1.015240] calling  init_zero_pfn+0x0/0x14 @ 1
[    1.019999] initcall init_zero_pfn+0x0/0x14 returned 0 after 0 usecs
[    1.026666] calling  fsnotify_init+0x0/0x24 @ 1
[    1.031436] initcall fsnotify_init+0x0/0x24 returned 0 after 0 usecs
[    1.038102] calling  filelock_init+0x0/0x74 @ 1
[    1.042887] initcall filelock_init+0x0/0x74 returned 0 after 0 usecs
[    1.049559] calling  init_misc_binfmt+0x0/0x28 @ 1
[    1.054594] initcall init_misc_binfmt+0x0/0x28 returned 0 after 0 usec=
s
[    1.061539] calling  init_script_binfmt+0x0/0x13 @ 1
[    1.066750] initcall init_script_binfmt+0x0/0x13 returned 0 after 0 us=
ecs
[    1.073886] calling  init_elf_binfmt+0x0/0x13 @ 1
[    1.078820] initcall init_elf_binfmt+0x0/0x13 returned 0 after 0 usecs
[    1.085667] calling  debugfs_init+0x0/0x4a @ 1
[    1.090356] initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs
[    1.096940] calling  securityfs_init+0x0/0x41 @ 1
[    1.101895] initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs
[    1.108755] calling  prandom_init+0x0/0xaa @ 1
[    1.113427] initcall prandom_init+0x0/0xaa returned 0 after 0 usecs
[    1.120013] calling  virtio_init+0x0/0x30 @ 1
[    1.124675] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
[    1.131178] calling  early_resume_init+0x0/0x1a0 @ 1
[    1.136395] RTC time: 16:45:17, date: 07/14/14
[    1.141053] initcall early_resume_init+0x0/0x1a0 returned 0 after 976 =
usecs
[    1.148363] calling  cpufreq_core_init+0x0/0x29 @ 1
[    1.153493] initcall cpufreq_core_init+0x0/0x29 returned 0 after 0 use=
cs
[    1.160525] calling  cpuidle_init+0x0/0x36 @ 1
[    1.165214] initcall cpuidle_init+0x0/0x36 returned 0 after 0 usecs
[    1.171796] calling  bsp_pm_check_init+0x0/0x11 @ 1
[    1.176909] initcall bsp_pm_check_init+0x0/0x11 returned 0 after 0 use=
cs
[    1.183944] calling  sock_init+0x0/0x89 @ 1
[    1.188614] initcall sock_init+0x0/0x89 returned 0 after 0 usecs
[    1.194917] calling  net_inuse_init+0x0/0x24 @ 1
[    1.199788] initcall net_inuse_init+0x0/0x24 returned 0 after 0 usecs
[    1.206549] calling  netpoll_init+0x0/0x2e @ 1
[    1.211218] initcall netpoll_init+0x0/0x2e returned 0 after 0 usecs
[    1.217797] calling  netlink_proto_init+0x0/0x1a7 @ 1
[    1.223189] NET: Registered protocol family 16
[    1.227884] initcall netlink_proto_init+0x0/0x1a7 returned 0 after 195=
3 usecs
[    1.235383] calling  __gnttab_init+0x0/0x30 @ 1
[    1.240139] initcall __gnttab_init+0x0/0x30 returned -19 after 0 usecs
[    1.247027] calling  bdi_class_init+0x0/0x40 @ 1
[    1.252027] initcall bdi_class_init+0x0/0x40 returned 0 after 0 usecs
[    1.258791] calling  mm_sysfs_init+0x0/0x22 @ 1
[    1.263565] initcall mm_sysfs_init+0x0/0x22 returned 0 after 0 usecs
[    1.270234] calling  kobject_uevent_init+0x0/0xf @ 1
[    1.275465] initcall kobject_uevent_init+0x0/0xf returned 0 after 0 us=
ecs
[    1.282595] calling  pcibus_class_init+0x0/0x14 @ 1
[    1.287748] initcall pcibus_class_init+0x0/0x14 returned 0 after 0 use=
cs
[    1.294794] calling  pci_driver_init+0x0/0xf @ 1
[    1.299727] initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
[    1.306500] calling  backlight_class_init+0x0/0x92 @ 1
[    1.311925] initcall backlight_class_init+0x0/0x92 returned 0 after 0 =
usecs
[    1.319241] calling  xenbus_init+0x0/0x24f @ 1
[    1.323902] initcall xenbus_init+0x0/0x24f returned -19 after 0 usecs
[    1.330670] calling  tty_class_init+0x0/0x2f @ 1
[    1.335548] initcall tty_class_init+0x0/0x2f returned 0 after 0 usecs
[    1.342317] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    1.347864] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 =
usecs
[    1.355186] calling  wakeup_sources_debugfs_init+0x0/0x2f @ 1
[    1.361230] initcall wakeup_sources_debugfs_init+0x0/0x2f returned 0 a=
fter 0 usecs
[    1.369167] calling  i2c_init+0x0/0x57 @ 1
[    1.373617] initcall i2c_init+0x0/0x57 returned 0 after 0 usecs
[    1.379826] calling  lguest_devices_init+0x0/0x13f @ 1
[    1.385209] initcall lguest_devices_init+0x0/0x13f returned 0 after 0 =
usecs
[    1.392505] calling  init_ladder+0x0/0xf @ 1
[    1.396989] cpuidle: using governor ladder
[    1.401287] initcall init_ladder+0x0/0xf returned 0 after 976 usecs
[    1.407868] calling  init_menu+0x0/0xf @ 1
[    1.412159] cpuidle: using governor menu
[    1.416279] initcall init_menu+0x0/0xf returned 0 after 976 usecs
[    1.422677] calling  amd_postcore_init+0x0/0x131 @ 1
[    1.427896] node 0 link 0: io port [1000, ffffff]
[    1.432841] TOM: 00000000d0000000 aka 3328M
[    1.437241] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    1.442631] node 0 link 0: mmio [a0000, bffff]
[    1.447305] node 0 link 0: mmio [d0000000, efffffff] =3D=3D> [d0000000=
, dfffffff]
[    1.454816] node 0 link 0: mmio [f0000000, fe6fffff]
[    1.460039] node 0 link 0: mmio [fe700000, fe8fffff]
[    1.465260] node 0 link 0: mmio [fe900000, ffefffff]
[    1.470479] TOM2: 0000000130000000 aka 4864M
[    1.474960] bus: [bus 00-07] on node 0 link 0
[    1.479523] bus: 00 [io  0x0000-0xffff]
[    1.483544] bus: 00 [mem 0x000a0000-0x000bffff]
[    1.488298] bus: 00 [mem 0xd0000000-0xdfffffff]
[    1.493048] bus: 00 [mem 0xf0000000-0xffffffff]
[    1.497806] bus: 00 [mem 0x130000000-0xfcffffffff]
[    1.502848] initcall amd_postcore_init+0x0/0x131 returned 0 after 1660=
1 usecs
[    1.510372] calling  boot_params_ksysfs_init+0x0/0x22f @ 1
[    1.516164] initcall boot_params_ksysfs_init+0x0/0x22f returned 0 afte=
r 0 usecs
[    1.523843] calling  arch_kdebugfs_init+0x0/0x2a6 @ 1
[    1.529183] initcall arch_kdebugfs_init+0x0/0x2a6 returned 0 after 0 u=
secs
[    1.536395] calling  init_pit_clocksource+0x0/0x36 @ 1
[    1.541791] initcall init_pit_clocksource+0x0/0x36 returned 0 after 0 =
usecs
[    1.549103] calling  mtrr_if_init+0x0/0x56 @ 1
[    1.553772] initcall mtrr_if_init+0x0/0x56 returned 0 after 0 usecs
[    1.560355] calling  ffh_cstate_init+0x0/0x27 @ 1
[    1.565297] initcall ffh_cstate_init+0x0/0x27 returned -1 after 0 usec=
s
[    1.572235] calling  kdump_buf_page_init+0x0/0x3a @ 1
[    1.577551] initcall kdump_buf_page_init+0x0/0x3a returned 0 after 0 u=
secs
[    1.584778] calling  activate_jump_labels+0x0/0x2d @ 1
[    1.590173] initcall activate_jump_labels+0x0/0x2d returned 0 after 0 =
usecs
[    1.597477] calling  acpi_pci_init+0x0/0x5b @ 1
[    1.602230] ACPI: bus type PCI registered
[    1.606444] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.613193] initcall acpi_pci_init+0x0/0x5b returned 0 after 1953 usec=
s
[    1.620138] calling  dma_bus_init+0x0/0xbb @ 1
[    1.624998] initcall dma_bus_init+0x0/0xbb returned 0 after 0 usecs
[    1.631576] calling  dma_channel_table_init+0x0/0xc4 @ 1
[    1.637293] initcall dma_channel_table_init+0x0/0xc4 returned 0 after =
0 usecs
[    1.644787] calling  setup_vcpu_hotplug_event+0x0/0x1f @ 1
[    1.650541] initcall setup_vcpu_hotplug_event+0x0/0x1f returned -19 af=
ter 0 usecs
[    1.658394] calling  register_xen_pci_notifier+0x0/0x30 @ 1
[    1.664249] initcall register_xen_pci_notifier+0x0/0x30 returned 0 aft=
er 0 usecs
[    1.672008] calling  xen_pcpu_init+0x0/0xc8 @ 1
[    1.676767] initcall xen_pcpu_init+0x0/0xc8 returned -19 after 0 usecs
[    1.683629] calling  dmi_id_init+0x0/0x2a2 @ 1
[    1.688582] initcall dmi_id_init+0x0/0x2a2 returned 0 after 0 usecs
[    1.695171] calling  dca_init+0x0/0x21 @ 1
[    1.699465] dca service started, version 1.12.1
[    1.704265] initcall dca_init+0x0/0x21 returned 0 after 976 usecs
[    1.710665] calling  pci_arch_init+0x0/0x65 @ 1
[    1.715441] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    1.725208] PCI: not using MMCONFIG
[    1.729525] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you w=
ant it NX.
[    1.737170] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D4
[    1.743826] PCI: Using configuration type 1 for base access
[    1.749676] PCI: Using configuration type 1 for extended access
[    1.755901] initcall pci_arch_init+0x0/0x65 returned 0 after 5859 usec=
s
[    1.762876] calling  topology_init+0x0/0x36 @ 1
[    1.768048] initcall topology_init+0x0/0x36 returned 0 after 976 usecs
[    1.774904] calling  mtrr_init_finialize+0x0/0x30 @ 1
[    1.780206] initcall mtrr_init_finialize+0x0/0x30 returned 0 after 0 u=
secs
[    1.787436] calling  uid_cache_init+0x0/0x7e @ 1
[    1.792322] initcall uid_cache_init+0x0/0x7e returned 0 after 0 usecs
[    1.799074] calling  param_sysfs_init+0x0/0x14c @ 1
[    1.805625] kworker/u12:0 (71) used greatest stack depth: 6876 bytes l=
eft
[    1.816383] initcall param_sysfs_init+0x0/0x14c returned 0 after 11718=
 usecs
[    1.823782] calling  proc_schedstat_init+0x0/0x27 @ 1
[    1.829085] initcall proc_schedstat_init+0x0/0x27 returned 0 after 0 u=
secs
[    1.836306] calling  pm_sysrq_init+0x0/0x16 @ 1
[    1.845766] initcall pm_sysrq_init+0x0/0x16 returned 0 after 4882 usec=
s
[    1.852726] calling  create_proc_profile+0x0/0x1e0 @ 1
[    1.858131] initcall create_proc_profile+0x0/0x1e0 returned 0 after 0 =
usecs
[    1.865443] calling  crash_save_vmcoreinfo_init+0x0/0x5ad @ 1
[    1.871496] initcall crash_save_vmcoreinfo_init+0x0/0x5ad returned 0 a=
fter 0 usecs
[    1.879448] calling  crash_notes_memory_init+0x0/0x35 @ 1
[    1.885134] initcall crash_notes_memory_init+0x0/0x35 returned 0 after=
 0 usecs
[    1.892724] calling  hung_task_init+0x0/0x56 @ 1
[    1.897627] initcall hung_task_init+0x0/0x56 returned 0 after 0 usecs
[    1.904390] calling  default_bdi_init+0x0/0x78 @ 1
[    1.909888] initcall default_bdi_init+0x0/0x78 returned 0 after 976 us=
ecs
[    1.917030] calling  init_reserve_notifier+0x0/0x7 @ 1
[    1.922423] initcall init_reserve_notifier+0x0/0x7 returned 0 after 0 =
usecs
[    1.929744] calling  init_admin_reserve+0x0/0x30 @ 1
[    1.934952] initcall init_admin_reserve+0x0/0x30 returned 0 after 0 us=
ecs
[    1.942093] calling  init_user_reserve+0x0/0x30 @ 1
[    1.947203] initcall init_user_reserve+0x0/0x30 returned 0 after 0 use=
cs
[    1.954236] calling  mmu_notifier_init+0x0/0xf @ 1
[    1.959273] initcall mmu_notifier_init+0x0/0xf returned 0 after 0 usec=
s
[    1.966217] calling  hugepage_init+0x0/0x123 @ 1
[    1.971250] initcall hugepage_init+0x0/0x123 returned 0 after 0 usecs
[    1.978024] calling  crypto_wq_init+0x0/0x41 @ 1
[    1.982950] initcall crypto_wq_init+0x0/0x41 returned 0 after 0 usecs
[    1.989717] calling  cryptomgr_init+0x0/0xf @ 1
[    1.994472] initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
[    2.001149] calling  init_bio+0x0/0xc5 @ 1
[    2.005843] initcall init_bio+0x0/0xc5 returned 0 after 0 usecs
[    2.012065] calling  blk_settings_init+0x0/0x21 @ 1
[    2.017184] initcall blk_settings_init+0x0/0x21 returned 0 after 0 use=
cs
[    2.024219] calling  blk_ioc_init+0x0/0x2f @ 1
[    2.028919] initcall blk_ioc_init+0x0/0x2f returned 0 after 0 usecs
[    2.035506] calling  blk_softirq_init+0x0/0x54 @ 1
[    2.040535] initcall blk_softirq_init+0x0/0x54 returned 0 after 0 usec=
s
[    2.047482] calling  blk_iopoll_setup+0x0/0x54 @ 1
[    2.052510] initcall blk_iopoll_setup+0x0/0x54 returned 0 after 0 usec=
s
[    2.059446] calling  blk_mq_init+0x0/0x16 @ 1
[    2.064020] initcall blk_mq_init+0x0/0x16 returned 0 after 0 usecs
[    2.070506] calling  genhd_device_init+0x0/0x6a @ 1
[    2.075815] initcall genhd_device_init+0x0/0x6a returned 0 after 0 use=
cs
[    2.082866] calling  blk_dev_integrity_init+0x0/0x2f @ 1
[    2.088469] initcall blk_dev_integrity_init+0x0/0x2f returned 0 after =
0 usecs
[    2.095970] calling  pci_slot_init+0x0/0x40 @ 1
[    2.100743] initcall pci_slot_init+0x0/0x40 returned 0 after 0 usecs
[    2.107420] calling  fbmem_init+0x0/0x96 @ 1
[    2.111949] initcall fbmem_init+0x0/0x96 returned 0 after 0 usecs
[    2.118358] calling  acpi_init+0x0/0x26b @ 1
[    2.122931] ACPI: Added _OSI(Module Device)
[    2.127322] ACPI: Added _OSI(Processor Device)
[    2.131985] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.136929] ACPI: Added _OSI(Processor Aggregator Device)
[    2.156817] ACPI: Executed 4 blocks of module-level executable AML cod=
e
[    2.240859] ACPI: Interpreter enabled
[    2.244725] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S1_] (2014] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep Stat=
e [\_S2_] (20140424/hwxface-580)
[    2.264161] ACPI: (supports S0 S3 S4 S5)
[    2.268273] ACPI: Using IOAPIC for interrupt routing
[    2.273629] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    2.313391] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in A=
CPI motherboard resources
[    2.322510] PCI: Using MMi=3Dnocrs" and report a bug
[    2.461540] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.468044] acpi PNP0A03:00: _OSC: OS supports [Extendter ROM [mem 0x0=
00cf000-0x000d09ff])
[    2.500655] PCI host bridge to bus 0000:00
[    2.504963] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.510720] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.517210] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.523702] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    2.530925] pci_bus 0000:00: root bus resource [mem 0xcff00000-0xdffff=
fff]
[    2.538148] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebff=
fff]
[    2.545387] pci 0000:00:00.0: [1022:9600] type 00 class 0x060000
[    2.552491] pci 0000:00:01.0: [1022:9602] type 01 class 0x060400
[    2.559593] pci 0000:00:06.0: [1022:9606] type 01 class 0x060400
[    2.565939] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    2.572872] pci 0000:00:06.0: System wakeup disabled by ACPI
[    2.579171] pci 0000:00:07.0: [1022:9607] type 01 class 0x060400
[    2.585513] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    2.592457] pci 0000:00:07.0: System wakeup disabled by ACPI
[    2.598759] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    2.605079] pci 0000:00:11.0: reg 0x10: [io  0x7000-0x7007]
[    2.610931] pci 0000:00:11.0: reg 0x14: [io  0x6000-0x6003]
[    2.616781] pci 0000:00:11.0: reg 0x18: [io  0x5000-0x5007]
[    2.622630] pci 0000:00:11.0: reg 0x1c: [io  0x4000-0x4003]
[    2.628479] pci 0000:00:11.0: reg 0x20: [io  0x3000-0x300f]
[    2.634328] pci 0000:00:11.0: reg 0x24: [mem 0xfe6ffc00-0xfe6fffff]
[    2.641698] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    2.648010] pci 0000:00:12.0: reg 0x10: [mem 0xfe6fe000-0xfe6fefff]
[    2.655172] pci 0000:00:12.0: System wakeup disabled by ACPI
[    2.661473] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
[    2.667782] pci 0000:00:12.1: reg 0x10: [mem 0xfe6fd000-0xfe6fdfff]
[    2.674937] pci 0000:00:12.1: System wakeup disabled by ACPI
[    2.681233] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    2.687551] pci 0000:00:12.2: reg 0x10: [mem 0xfe6ff800-0xfe6ff8ff]
[    2.694201] pci 0000:00:12.2: supports D1 D2
[    2.698681] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    2.705534] pci 0000:00:12.2: System wakeup disabled by ACPI
[    2.711834] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    2.718140] pci 0000:00:13.0: reg 0x10: [mem 0xfe6fc000-0xfe6fcfff]
[    2.725311] pci 0000:00:13.0: System wakeup disabled by ACPI
[    2.731607] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
[    2.737919] pci 0000:00:13.1: reg 0x10: [mem 0xfe6f7000-0xfe6f7fff]
[    2.745088] pci 0000:00:13.1: System wakeup disabled by ACPI
[    2.751390] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    2.757706] pci 0000:00:13.2: reg 0x10: [mem 0xfe6ff400-0xfe6ff4ff]
[    2.764361] pci 0000:00:13.2: supports D1 D2
[    2.768848] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    2.775699] pci 0000:00:13.2: System wakeup disabled by ACPI
[    2.782008] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    2.789146] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    2.796267] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    2.803135] pci 0000:00:14.4: System wakeup disabled by ACPI
[    2.809433] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    2.815744] pci 0000:00:14.5: reg 0x10: [mem 0xfe6f6000-0xfe6f6fff]
[    2.822908] pci 0000:00:14.5: System wakeup disabled by ACPI
[    2.829210] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    2.836289] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    2.843318] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    2.850394] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    2.857462] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    2.864820] pci 0000:01:05.0: [1002:9610] type 00 class 0x030000
[    2.871120] pci 0000:01:05.0: reg 0x10: [mem 0xd0000000-0xdfffffff pre=
f]
[    2.878151] pci 0000:01:05.0: reg 0x14: [io  0x8000-0x80ff]
[    2.883990] pci 0000:01:05.0: reg 0x18: [mem 0xfe8f0000-0xfe8fffff]
[    2.890567] pci 0000:01:05.0: reg 0x24: [mem 0xfe700000-0xfe7fffff]
[    2.897148] pci 0000:01:05.0: supports D1 D2
[    2.902046] pci 0000:01:05.1: [1002:960f] type 00 class 0x040300
[    2.908353] pci 0000:01:05.1: reg 0x10: [mem 0xfe8e8000-0xfe8ebfff]
[    2.914957] pci 0000:01:05.1: supports D1 D2
[    2.919796] pci 0000:00:01.0: PCI bridge to [bus 01]
[    2.925007] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    2.931407] pci 0000:00:01.0:   bridge window [mem 0xfe700000-0xfe8fff=
ff]
[    2.938527] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffff=
ff 64bit pref]
[    2.946881] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    2.953194] pci 0000:02:00.0: reg 0x10: [io  0x9800-0x98ff]
[    2.959060] pci 0000:02:00.0: reg 0x18: [mem 0xfe9ff000-0xfe9fffff 64b=
it]
[    2.966181] pci 0000:02:00.0: reg 0x20: [mem 0xfdff0000-0xfdffffff 64b=
it pref]
[    2.973761] pci 0000:02:00.0: reg 0x30: [mem 0xfe9c0000-0xfe9dffff pre=
f]
[    2.980851] pci 0000:02:00.0: supports D1 D2
[    2.985328] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    2.994584] pci 0000:00:06.0: PCI bridge to [bus 02]
[    2.999786] pci 0000:00:06.0:   bridge window [io  0x9000-0x9fff]
[    3.006190] pci 0000:00:06.0:   bridge window [mem 0xfe900000-0xfe9fff=
ff]
[    3.013330] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffff=
ff 64bit pref]
[    3.021672] pci 0000:03:00.0: [197b:2361] type 00 class 0x010601
[    3.028051] pci 0000:03:00.0: reg 0x24: [mem 0xfeafe000-0xfeafffff]
[    3.034681] pci 0000:03:00.0: PME# supported from D3hot
[    3.040609] pci 0000:03:00.1: [197b:2361] type 00 class 0x010185
[    3.046936] pci 0000:03:00.1: reg 0x10: [io  0xb800-0xb807]
[    3.052787] pci 0000:03:00.1: reg 0x14: [io  0xb400-0xb403]
[    3.058646] pci 0000:03:00.1: reg 0x18: [io  0xb000-0xb007]
[    3.064498] pci 0000:03:00.1: reg 0x1c: [io  0xa800-0xa803]
[    3.070350] pci 0000:03:00.1: reg 0x20: [io  0xa400-0xa40f]
[    3.076596] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    3.087119] pci 0000:00:07.0: PCI bridge to [bus 03]
[    3.092334] pci 0000:00:07.0:   bridge window [io  0xa000-0xbfff]
[    3.098732] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafff=
ff]
[    3.106094] pci 0000:04:05.0: [10b7:1700] type 00 class 0x020000
[    3.112427] pci 0000:04:05.0: reg 0x10: [mem 0xfebfc000-0xfebfffff]
[    3.119016] pci 0000:04:05.0: reg 0x14: [io  0xe800-0xe8ff]
[    3.124914] pci 0000:04:05.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pre=
f]
[    3.132004] pci 0000:04:05.0: supports D1 D2
[    3.136491] pci 0000:04:05.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    3.143871] pci 0000:04:07.0: [9710:9835] type 00 class 0x070002
[    3.150193] pci 0000:04:07.0: reg 0x10: [io  0xe400-0xe407]
[    3.156051] pci 0000:04:07.0: reg 0x14: [io  0xe000-0xe007]
[    3.161903] pci 0000:04:07.0: reg 0x18: [io  0xd800-0xd807]
[    3.167753] pci 0000:04:07.0: reg 0x1c: [io  0xd400-0xd407]
[    3.173607] pci 0000:04:07.0: reg 0x20: [io  0xd000-0xd007]
[    3.179457] pci 0000:04:07.0: reg 0x24: [io  0xc800-0xc80f]
[    3.185717] pci 0000:00:14.4: PCI bridge to [bus 04] (subtractive deco=
de)
[    3.192846] pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]
[    3.199245] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfff=
ff]
[    3.206383] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (sub=
tractive decode)
[    3.214709] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
[    3.223030] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
[    3.232070] pci 0000:00:14.4:   bridge window [mem 0xcff00000-0xdfffff=
ff] (subtractive decode)
[    3.241120] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfff=
ff] (subtractive decode)
[    3.250165] pci_bus 0000:00: on NUMA node 0
[    3.280652] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 *14 15)
[    3.288153] ACPI: PCI Interrupt Link [LNKB] (IRQs  15)
[    3.295669] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    3.303165] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 12 14 15)
[    3.310664] ACPI: PCI Interrupt Link [LNKE] (IRQs *4 10 11 12 14 15)
[    3.317960] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 10 11 12 14 15) *0=
, disabled.
[    3.326463] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 10 11 12 14 *15)
[    3.333767] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 10 11 12 14 15) *0=
, disabled.
[    3.342206] ACPI: Enabled 1 GPEs in block 00 to 1F
[    3.347353] initcall acpi_init+0x0/0x26b returned 0 after 458007 usecs
[    3.354211] calling  pnp_init+0x0/0xf @ 1
[    3.358499] initcall pnp_init+0x0/0xf returned 0 after 0 usecs
[    3.364628] calling  balloon_init+0x0/0x1fa @ 1
[    3.369386] initcall balloon_init+0x0/0x1fa returned -19 after 0 usecs
[    3.376261] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
[    3.382023] initcall xen_setup_shutdown_event+0x0/0x30 returned -19 af=
ter 0 usecs
[    3.389886] calling  xenbus_probe_backend_init+0x0/0x23 @ 1
[    3.395813] initcall xenbus_probe_backend_init+0x0/0x23 returned 0 aft=
er 0 usecs
[    3.403579] calling  xenbus_probe_frontend_init+0x0/0x7b @ 1
[    3.409593] initcall xenbus_probe_frontend_init+0x0/0x7b returned 0 af=
ter 0 usecs
[    3.417448] calling  xen_acpi_pad_init+0x0/0x41 @ 1
[    3.422573] initcall xen_acpi_pad_init+0x0/0x41 returned -19 after 0 u=
secs
[    3.429788] calling  balloon_init+0x0/0xdd @ 1
[    3.434457] initcall balloon_init+0x0/0xdd returned -19 after 0 usecs
[    3.441228] calling  misc_init+0x0/0xad @ 1
[    3.445662] initcall misc_init+0x0/0xad returned 0 after 0 usecs
[    3.451975] calling  vga_arb_device_init+0x0/0xcc @ 1
[    3.457463] vgaarb: device added: PCI:0000:01:05.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    3.465969] vgaarb: loaded
[    3.468810] vgaarb: bridge control possible 0000:01:05.0
[    3.474378] initcall vga_arb_device_init+0x0/0xcc returned 0 after 166=
01 usecs
[    3.481960] calling  cn_init+0x0/0xb0 @ 1
[    3.486188] initcall cn_init+0x0/0xb0 returned 0 after 0 usecs
[    3.492309] calling  dma_buf_init+0x0/0x62 @ 1
[    3.496980] initcall dma_buf_init+0x0/0x62 returned 0 after 0 usecs
[    3.503559] calling  phy_init+0x0/0x2f @ 1
[    3.508073] initcall phy_init+0x0/0x2f returned 0 after 976 usecs
[    3.514467] calling  init_pcmcia_cs+0x0/0x32 @ 1
[    3.519335] initcall init_pcmcia_cs+0x0/0x32 returned 0 after 0 usecs
[    3.526091] calling  usb_init+0x0/0x14c @ 1
[    3.530481] ACPI: bus type USB registered
[    3.534891] usbcore: registered new interface driver usbfs
[    3.540741] usbcore: registered new interface driver hub
[    3.546411] usbcore: registered new device driver usb
[    3.551702] initcall usb_init+0x0/0x14c returned 0 after 20507 usecs
[    3.558360] calling  serio_init+0x0/0x2e @ 1
[    3.562923] initcall serio_init+0x0/0x2e returned 0 after 0 usecs
[    3.569308] calling  input_init+0x0/0xf1 @ 1
[    3.573837] initcall input_init+0x0/0xf1 returned 0 after 0 usecs
[    3.580235] calling  rtc_init+0x0/0x50 @ 1
[    3.584563] initcall rtc_init+0x0/0x50 returned 0 after 0 usecs
[    3.590775] calling  pps_init+0x0/0xa6 @ 1
[    3.595106] pps_core: LinuxPPS API ver. 1 registered
[    3.600307] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    3.609890] initcall pps_init+0x0/0xa6 returned 0 after 13671 usecs
[    3.616456] calling  ptp_init+0x0/0x8e @ 1
[    3.620795] PTP clock support registered
[    3.624905] initcall ptp_init+0x0/0x8e returned 0 after 4882 usecs
[    3.631386] calling  power_supply_class_init+0x0/0x39 @ 1
[    3.637074] initcall power_supply_class_init+0x0/0x39 returned 0 after=
 0 usecs
[    3.644651] calling  hwmon_init+0x0/0xda @ 1
[    3.649157] initcall hwmon_init+0x0/0xda returned 0 after 0 usecs
[    3.655542] calling  leds_init+0x0/0x36 @ 1
[    3.659958] initcall leds_init+0x0/0x36 returned 0 after 0 usecs
[    3.666262] calling  efisubsys_init+0x0/0x115 @ 1
[    3.671191] initcall efisubsys_init+0x0/0x115 returned 0 after 0 usecs
[    3.678029] calling  pci_subsys_init+0x0/0x48 @ 1
[    3.682961] PCI: Using ACPI for IRQ routing
[    3.687350] PCI: pci_cache_line_size set to 64 bytes
[    3.692598] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    3.698901] e820: reserve RAM buffer [mem 0xcfeb0000-0xcfffffff]
[    3.705201] initcall pci_subsys_init+0x0/0x48 returned 0 after 21484 u=
secs
[    3.712409] calling  proto_init+0x0/0xf @ 1
[    3.716805] initcall proto_init+0x0/0xf returned 0 after 976 usecs
[    3.723288] calling  net_dev_init+0x0/0x15d @ 1
[    3.728887] initcall net_dev_init+0x0/0x15d returned 0 after 976 usecs
[    3.735730] calling  neigh_init+0x0/0xa4 @ 1
[    3.740206] initcall neigh_init+0x0/0xa4 returned 0 after 0 usecs
[    3.746592] calling  fib_rules_init+0x0/0xbd @ 1
[    3.751434] initcall fib_rules_init+0x0/0xbd returned 0 after 0 usecs
[    3.758191] calling  pktsched_init+0x0/0x121 @ 1
[    3.763042] initcall pktsched_init+0x0/0x121 returned 0 after 0 usecs
[    3.769790] calling  tc_filter_init+0x0/0x6a @ 1
[    3.774631] initcall tc_filter_init+0x0/0x6a returned 0 after 0 usecs
[    3.781384] calling  tc_action_init+0x0/0x6a @ 1
[    3.786226] initcall tc_action_init+0x0/0x6a returned 0 after 0 usecs
[    3.792979] calling  genl_init+0x0/0x7a @ 1
[    3.797376] initcall genl_init+0x0/0x7a returned 0 after 0 usecs
[    3.803669] calling  cipso_v4_init+0x0/0x5a @ 1
[    3.808418] initcall cipso_v4_init+0x0/0x5a returned 0 after 0 usecs
[    3.815086] calling  netlbl_init+0x0/0x7d @ 1
[    3.819651] NetLabel: Initializing
[    3.823212] NetLabel:  domain hash size =3D 128
[    3.827774] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    3.833030] NetLabel:  unlabeled traffic allowed by default
[    3.838868] initcall netlbl_init+0x0/0x7d returned 0 after 19531 usecs
[    3.845708] calling  rfkill_init+0x0/0x68 @ 1
[    3.850430] initcall rfkill_init+0x0/0x68 returned 0 after 0 usecs
[    3.856917] calling  xen_mcfg_late+0x0/0xa6 @ 1
[    3.861668] initcall xen_mcfg_late+0x0/0xa6 returned 0 after 0 usecs
[    3.868378] calling  xen_p2m_debugfs+0x0/0x49 @ 1
[    3.873328] initcall xen_p2m_debugfs+0x0/0x49 returned 0 after 0 usecs
[    3.880175] calling  xen_spinlock_debugfs+0x0/0x120 @ 1
[    3.885715] initcall xen_spinlock_debugfs+0x0/0x120 returned 0 after 0=
 usecs
[    3.893104] calling  nmi_warning_debugfs+0x0/0x26 @ 1
[    3.898411] initcall nmi_warning_debugfs+0x0/0x26 returned 0 after 0 u=
secs
[    3.905628] calling  hpet_late_init+0x0/0xe6 @ 1
[    3.910485] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    3.915901] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    3.924017] initcall hpet_late_init+0x0/0xe6 returned 0 after 13671 us=
ecs
[    3.931143] calling  init_amd_nbs+0x0/0xb6 @ 1
[    3.935818] initcall init_amd_nbs+0x0/0xb6 returned 0 after 0 usecs
[    3.942386] calling  clocksource_done_booting+0x0/0x3b @ 1
[    3.948167] Switched to clocksource hpet
[    3.952335] initcall clocksource_done_booting+0x0/0x3b returned 0 afte=
r 4082 usecs
[    3.960301] calling  tracer_init_debugfs+0x0/0x165 @ 1
[    3.966224] initcall tracer_init_debugfs+0x0/0x165 returned 0 after 51=
5 usecs
[    3.973710] calling  init_trace_printk_function_export+0x0/0x33 @ 1
[    3.980312] initcall init_trace_printk_function_export+0x0/0x33 return=
ed 0 after 6 usecs
[    3.988819] calling  event_trace_init+0x0/0x1ee @ 1
[    4.014979] initcall event_trace_init+0x0/0x1ee returned 0 after 20554=
 usecs
[    4.022376] calling  init_kprobe_trace+0x0/0 12 usecs
[    4.034647] calling  init_pipe_fs+0x0/0x3d @ 1
[    4.039434] initcall init_pipe_fs+0x0/0x3d returned 0 after 109 usecs
[    4.046202] calling  eventpoll_init+0x0/0xd0 @ 1
[    4.051155] initcall eventpoll_init+0x0/0xd0 returned 0 after 99 usecs
[    4.058015] calling  anon_inode_init+0x0/0x56 @ 1
[    4.063073] initcall anon_inode_init+0x0/0x56 returned 0 after 119 use=
cs
[    4.070122] calling  proc_cmdline_init+0x0/0x27 @ 1
[    4.075249] initcall proc_cmdline_init+0x0/0x27 returned 0 after 9 use=
cs
[    4.082293] calling  proc_consoles_init+0x0/0x27 @ 1
[    4.087501] initcall proc_consoles_init+0x0/0x27 returned 0 after 7 us=
ecs
[    4.094637] calling  proc_cpuinfo_init+0x0/0x27 @ 1
[    4.099760] initcall proc_cpuinfo_init+0x0/0x27 returned 0 after 6 use=
cs
[    4.106816] calling  proc_devices_init+0x0/0x27 @ 1
[    4.111939] initcall proc_devices_init+0x0/0x27 returned 0 after 6 use=
cs
[    4.118985] calling  proc_interrupts_init+0x0/0x27 @ 1
[    4.124385] initcall proc_interrupts_init+0x0/0x27 returned 0 after 6 =
usecs
[    4.131700] calling  proc_loadavg_init+0x0/0x27 @ 1
[    4.136828] initcall proc_loadavg_init+0x0/0x27 returned 0 after 6 use=
cs
[    4.143874] calling  proc_meminfo_init+0x0/0x27 @ 1
[    4.149015] initcall proc_meminfo_init+0x0/0x27 returned 0 after 6 use=
cs
[    4.156053] calling  proc_stat_init+0x0/0x27 @ 1
[    4.160909] initcall proc_stat_init+0x0/0x27 returned 0 after 6 usecs
[    4.167681] calling  proc_uptime_init+0x0/0x27 @ 1
[    4.172727] initcall proc_uptime_init+0x0/0x27 returned 0 after 7 usec=
s
[    4.179670] calling  proc_version_init+0x0/0x27 @ 1
[    4.184808] initcall proc_version_init+0x0/0x27 returned 0 after 6 use=
cs
[    4.191851] calling  proc_softirqs_init+0x0/0x27 @ 1
[    4.197082] initcall proc_softirqs_init+0x0/0x27 returned 0 after 7 us=
ecs
[    4.204205] calling  proc_kcore_init+0x0/0xae @ 1
[    4.209163] initcall proc_kcore_init+0x0/0xae returned 0 after 9 usecs
[    4.216007] calling  vmcore_init+0x0/0x68b @ 1
[    4.220696] initcall vmcore_init+0x0/0x68b returned 0 after 1 usecs
[    4.227274] calling  proc_kmsg_init+0x0/0x2a @ 1
[    4.232140] initcall proc_kmsg_init+0x0/0x2a returned 0 after 7 usecs
[    4.238909] calling  proc_page_init+0x0/0x4a @ 1
[    4.243782] initcall proc_page_init+0x0/0x4a returned 0 after 12 usecs
[    4.250632] calling  init_ramfs_fs+0x0/0x44 @ 1
[    4.255471] initcall init_ramfs_fs+0x0/0x44 returned 0 after 78 usecs
[    4.262231] calling  blk_scsi_ioctl_init+0x0/0x288 @ 1
[    4.267642] initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 1 =
usecs
[    4.274953] calling  acpi_event_init+0x0/0x37 @ 1
[    4.279941] initcall acpi_event_init+0x0/0x37 returned 0 after 31 usec=
s
[    4.286888] calling  pnp_system_init+0x0/0xf @ 1
[    4.291793] initcall pnp_system_init+0x0/0xf returned 0 after 55 usecs
[    4.298650] calling  pnpacpi_init+0x0/0x88 @ 1
[    4.303323] pnp: PnP ACPI init
[    4.306565] ACPI: bus type PNP registered
[    4.312022] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    4.319743] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.347056] system 00:02: [mem 0xfec00000-0xfec00fff] could not be res=
erved
[    4.354378] system 00:02: [mem 0xfee00000-0xf  0x04d0-0x04d1] has been=
 reserved
[    4.376931] system 00:03: [io  0x040b] has been reserved
[    4.382516] system 00:03: [io  0x04d6] has been reserved
[    4.388105] system 00:03: [io  0x0c00-0x0c01] has been reserved
[    4.394324] system 00:03: [io  0x0c14] has been reserved
[    4.399910] system 00:03: [io  0x0c50-0x0c51] has been reserved
[    4.406135] system 00:03: [io  0x0c52] has been reserved
[    4.411729] system 00:03: [io  0x0c6c] has been reserved
[    4.417312] system 00:03: [io  0x0c6f] has been reserved
[    4.422894] system 00:03: [io  0x0cd0-0x0cd1] has been reserved
[    4.429112] system 00:03: [io  0x0cd2-0x0cd3] has been reserved
[    4.435336] system 00:03: [io  0x0cd4-0x0cd5] has been reserved
[    4.441560] system 00:03: [io  0x0cd6-0x0cd7] has been reserved
[    4.447784] system 00:03: [io  0x0cd8-0x0cdf] has been reserved
[    4.454002] system 00:03: [io  0x0800-0x089f] could not be reserved
[    4.460594] system 00:03: [io  0x0b00-0x0b0f] has been reserved
[    4.466829] system 00:03: [io  0x0b20-0x0b3f] has been reserved
[    4.473043] system 00:03: [io  0x0900-0x090f] has been reserved
[    4.479264] system 00:03: [io  0x0910-0x091f] has been reserved
[    4.485486] system 00:03: [io  0xfe00-0xfefe] has been reserved
[    4.491721] system 00:03: [mem 0xffb80000-0xffbfffff] has been reserve=
d
[    4.498674] system 00:03: [mem 0xfec10000-0xfec1001f] has been reserve=
d
[    4.505629] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    4.515289] system 00:04: [io  0x0e00-0x0e0f] has been reserved
[    4.521520] system 00:04: [io  0x0e80-0x0e8f] has been reed
[    4.533970] system 00:04: [io  0x0a30-0x0a3f] has been reserved
[    4.540175] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    4.547865] system 00:05: [mem 0xe0000000-0xefffffff] has been reserve=
d
[    4.554800] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    4.563708] system 00:06: [mem 0x00000000-0x0009ffff] could not be res=
erved
[    4.571029] system 00:06: [mem 0x000c0000-0x000cffff] could not be res=
erved
[    4.578342] system 00:06: [mem 0x000e0000-0x000fffff] could not be res=
erved
[    4.585672] system 00:06: [mem 0x00100000-0xcfefffff] could not be res=
erved
[    4.592998] system 00:06: [mem 0xfec00000-0xffffffff] could not be res=
erved
[    4.600304] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    4.608338] pnp: PnP ACPI: found 7 devices
[    4.612629] ACPI: bus type PNP unregistered
[    4.617019] initcall pnpacpi_init+0x0/0x88 returned 0 after 306630 use=
cs
[    4.624063] calling  pcistub_init+0x0/0x280 @ 1
[    4.629607] initcall pcistub_init+0x0/0x280 returned 0 after 778 usecs
[    4.636466] calling  chr_dev_init+0x0/0xc9 @ 1
[    4.644584] kworker/u12:0 (480) used greatest stack depth: 6712 bytes =
left
[    4.652333] initcall chr_dev_init+0x0/0xc9 returned 0 after 10938 usec=
s
[    4.659301] calling  firmware_class_init+0x0/0xd7 @ 1
[    4.664648] initcall firmware_class_init+0x0/0xd7 returned 0 after 37 =
usecs
[    4.671948] calling  init_pcmcia_bus+0x0/0x5e @ 1
[    4.676980] initcall init_pcmcia_bus+0x0/0x5e returned 0 after 84 usec=
s
[    4.683926] calling  thermal_init+0x0/0x78 @ 1
[    4.688643] initcall thermal_init+0x0/0x78 returned 0 after 54 usecs
[    4.695312] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    4.701353] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 a=
fter 0 usecs
[    4.709294] calling  init_acpi_pm_clocksource+0x0/0x18d @ 1
[    4.749661] initcall init_acpi_pm_clocksource+0x0/0x18d returned 0 aft=
er 33734 usecs
[    4.757782] calling  pcibios_assign_o  0x8000-0x8fff]
[    4.775191] pci 0000:00:01.0:   bridge window [mem 0xfe700000-0xfe8fff=
ff]
[    4.782312] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffff=
ff 64bit pref]
[    4.790450] pci 0000:00:06.0: PCI bridge to [bus 02]
[    4.795657] pci 0000:00:06.0:   bridge window [io  0x9000-0x9fff]
[    4.802066] pci 0000:00:06.0:   bridge window [mem 0xfe900000-0xfe9fff=
ff]
[    4.809189] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffff=
ff 64bit pref]
[    4.817331] pci 0000:00:07.0: PCI bridge to [bus 03]
[    4.822536] pci 0000:00:07.0:   bridge window [io  0xa000-0xbfff]
[    4.828926] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafff=
ff]
[    4.836053] pci 0000:00:14.4: PCI bridge to [bus 04]
[    4.841263] pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]
[    4.847672] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfff=
ff]
[    4.854807] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.860655] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.866507] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.873089] pci_bus 0000:00: resource 7 [mem 0xcff00000-0xdfffffff]
[    4.879652] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfebfffff]
[    4.886243] pci_bus 0000:01: resource 0 [io  0x8000-0x8fff]
[    4.892085] pci_bus 0000:01: resource 1 [mem 0xfe700000-0xfe8fffff]
[    4.898665] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64b=
it pref]
[    4.906263] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
[    4.912125] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
[    4.918701] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64b=
it pref]
[    4.926297] pci_bus 0000:03: resource 0 [io  0xa000-0xbfff]
[    4.932139] pci_bus 0000:03: resource 1 [mem 0xfea00000-0xfeafffff]
[    4.938713] pci_bus 0000:04: resource 0 [io  0xc000-0xefff]
[    4.944567] pci_bus 0000:04: resource 1 [mem 0xfeb00000-0xfebfffff]
[    4.951132] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    4.956978] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    4.962829] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    4.969404] pci_bus 0000:04: resource 7 [mem 0xcff00000-0xdfffffff]
[    4.975989] pci_bus 0000:04: resource 8 [mem 0xf0000000-0xfebfffff]
[    4.982564] initcall pcibios_assign_resources+0x0/0x8f returned 0 afte=
r 214079 usecs
[    4.990702] calling  sysctl_core_init+0x0/0x23 @ 1
[    4.995749] initcall sysctl_core_init+0x0/0x23 returned 0 after 20 use=
cs
[    5.002793] calling  inet_init+0x0/0x25b @ 1
[    5.007492] NET: Registered protocol family 2
[    5.012854] TCP established hash table entries: 8192 (order: 3, 32768 =
bytes)
[    5.020254] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    5.027052] TCP: Hash tables configured (established 8192 bind 8192)
[    5.033767] TCP: reno registered
[    5.037164] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    5.043397] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    5.050437] initcall inet_init+0x0/0x25b returned 0 after 42198 usecs
[    5.057196] calling  ipv4_offload_init+0x0/0x5d @ 1
[    5.062316] initcall ipv4_offload_init+0x0/0x5d returned 0 after 1 use=
cs
[    5.069359] calling  af_unix_init+0x0/0x4d @ 1
[    5.074065] NET: Registered protocol family 1
[    5.078655] initcall af_unix_init+0x0/0x4d returned 0 after 4536 usecs
[    5.085522] calling  ipv6_offload_init+0x0/0x7a @ 1
[    5.090638] initcall ipv6_offload_init+0x0/0x7a returned 0 after 1 use=
cs
[    5.097685] calling  init_sunrpc+0x0/0x5f @ 1
[    5.102639] RPC: Registered named UNIX socket transport module.
[    5.108862] RPC: Registered udp transport module.
[    5.113794] RPC: Registered tcp transport module.
[    5.118727] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    5.125497] initcall init_sunrpc+0x0/0x5f returned 0 after 22723 usecs
[    5.132357] calling  pci_apply_final_quirks+0x0/0x112 @ 1
[    5.138030] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disa=
bled
[    5.506241] pci 0000:01:05.0: Boot video device
[    5.511014] PCI: CLS 64 bytes, default 64
[    5.515218] initcall pci_ap.
[    7.397169] microcode: updated early to new patch_level=3D0x010000db
[    7.430973] Freeing initrd memory: 83120K (f2ad2000 - f7bfe000)
[    7.437192] initcall populate_rootfs+0x0/0xf9 returned 0  initcall pci=
_iommu_init+0x0/0x34 returned 0 after 1 usecs
[    7.456281] calling  register_kernel_offset_dumper+0x0/0x16 @ 1
[    7.462496] initcall register_kernel_offset_dumper+0x0/0x16 returned 0=
 after 1 usecs
[    7.470633] calling  i8259A_init_ops+0x0/0x1d @ 1
[    7.475582] initcall i8259A_init_ops+0x0/0x1d returned 0 after 1 usecs
[    7.482439] calling  sbf_init+0x0/0xf1 @ 1
[    7.486741] initcall sbf_init+0x0/0xf1 returned 0 after 0 usecs
[    7.492963] calling  init_tsc_clocksource+0x0/0xa7 @ 1
[    7.498363] initcall init_tsc_clocksource+0x0/0xa7 returned 0 after 2 =
usecs
[    7.505690] calling  add_rtc_cmos+0x0/0x99 @ 1
[    7.510361] initcall add_rtc_cmos+0x0/0x99 returned 0 after 2 usecs
[    7.516951] calling  i8237A_init_ops+0x0/0x11 @ 1
[    7.521897] initcall i8237A_init_ops+0x0/0x11 returned 0 after 0 usecs
[    7.528753] calling  cache_sysfs_init+0x0/0x69 @ 1
[    7.535150] initcall cache_sysfs_init+0x0/0x69 returned 0 after 1329 u=
secs
[    7.542375] calling  amd_uncore_init+0x0/0x111 @ 1
[    7.547409] initcall amd_uncore_init+0x0/0x111 returned -19 after 0 us=
ecs
[    7.554543] calling  intel_uncore_init+0x0/0x3ea @ 1
[    7.559765] initcall intel_uncore_init+0x0/0x3ea returned -19 after 1 =
usecs
[    7.567075] calling  rapl_pmu_init+0x0/0x194 @ 1
[    7.571927] initcall rapl_pmu_init+0x0/0x194 returned 0 after 0 usecs
[    7.578689] calling  inject_init+0x0/0x30 @ 1
[    7.583267] Machine check injector initialized
[    7.587934] initcall inject_init+0x0/0x30 returned 0 after 4560 usecs
[    7.594695] calling  thermal_throttle_init_device+0x0/0x6d @ 1
[    7.600824] initcall thermal_throttle_init_device+0x0/0x6d returned 0 =
after 0 usecs
[    7.608874] calling  microcode_init+0x0/0x18c @ 1
[    7.613940] microcode: CPU0: patch_level=3D0x010000db
[    7.619099] microcode: CPU1: patch_level=3D0x01000086
[    7.624251] microcode: CPU2: patch_level=3D0x01000086
[    7.629403] microcode: CPU3: patch_level=3D0x01000086
[    7.634735] microcode: Microcode Update Driver: v2.00 <tigran@aivazian=
.fsnet.co.uk>, Peter Oruba
[    7.643985] initcall microcode_init+0x0/0x18c returned 0 after 29492 u=
secs
[    7.651217] calling  amd_ibs_init+0x0/0x21f @ 1
[    7.655975] LVT offset 1 assigned for vector 0x400
[    7.661019] IBS: LVT offset 1 assigned
[    7.665089] perf: AMD IBS detected (0x0000001f)
[    7.669844] initcall amd_ibs_init+0x0/0x21f returned 0 after 13556 use=
cs
[    7.676885] calling  msr_init+0x0/0x153 @ 1
[    7.681944] initcall msr_init+0x0/0x153 returned 0 after 656 usecs
[    7.688462] calling  cpuid_init+0x0/0x153 @ 1
[    7.693675] initcall cpuid_init+0x0/0x153 returned 0 after 608 usecs
[    7.700358] calling  ioapic_init_ops+0x0/0x11 @ 1
[    7.705307] initcall ioapic_init_ops+0x0/0x11 returned 0 after 0 usecs
[    7.712171] calling  add_pcspkr+0x0/0x3b @ 1
[    7.716753] initcall add_pcspkr+0x0/0x3b returned 0 after 80 usecs
[    7.723241] calling  start_periodic_check_for_corruption+0x0/0x60 @ 1
[    7.729996] Scanning for low memory corruption every 60 seconds
[    7.736226] initcall start_periodic_check_for_corruption+0x0/0x60 retu=
rned 0 after 6088 usecs
[    7.745189] calling  sysfb_init+0x0/0x80 @ 1
[    7.749776] initcall sysfb_init+0x0/0x80 returned 0 after 96 usecs
[    7.756289] calling  pt_dump_init+0x0/0x70 @ 1
[    7.760963] initcall pt_dump_init+0x0/0x70 returned 0 after 11 usecs
[    7.767640] calling  aes_init+0x0/0xf @ 1
[    7.771936] initcall aes_init+0x0/0xf returned 0 after 82 usecs
[    7.778168] calling  proc_execdomains_init+0x0/0x27 @ 1
[    7.783657] initcall proc_execdomains_init+0x0/0x27 returned 0 after 9=
 usecs
[    7.791077] calling  ioresources_init+0x0/0x44 @ 1
[    7.796120] initcall ioresources_init+0x0/0x44 returned 0 after 12 use=
cs
[    7.803165] calling  init_posix_timers+0x0/0x22b @ 1
[    7.808447] initcall init_posix_timers+0x0/0x22b returned 0 after 66 u=
secs
[    7.815677] calling  init_posix_cpu_timers+0x0/0x9b @ 1
[    7.821168] initcall init_posix_cpu_timers+0x0/0x9b returned 0 after 0=
 usecs
[    7.828584] calling  snapshot_device_init+0x0/0xf @ 1
[    7.834031] initcall snapshot_device_init+0x0/0xf returned 0 after 139=
 usecs
[    7.841441] calling  irq_pm_init_ops+0x0/0x11 @ 1
[    7.846385] initcall irq_pm_init_ops+0x0/0x11 returned 0 after 0 usecs
[    7.853241] calling  timekeeping_init_ops+0x0/0x11 @ 1
[    7.858647] initcall timekeeping_init_ops+0x0/0x11 returned 0 after 0 =
usecs
[    7.865965] calling  init_clocksource_sysfs+0x0/0x58 @ 1
[    7.871749] initcall init_clocksource_sysfs+0x0/0x58 returned 0 after =
205 usecs
[    7.879443] calling  init_timer_list_procfs+0x0/0x30 @ 1
[    7.885034] initcall init_timer_list_procfs+0x0/0x30 returned 0 after =
7 usecs
[    7.892535] calling  alarmtimer_init+0x0/0x151 @ 1
[    7.897747] initcall alarmtimer_init+0x0/0x151 returned 0 after 173 us=
ecs
[    7.904891] calling  clockevents_init_sysfs+0x0/0xa3 @ 1
[    7.911126] initcall clockevents_init_sysfs+0x0/0xa3 returned 0 after =
628 usecs
[    7.918795] calling  init_tstats_procfs+0x0/0x30 @ 1
[    7.924026] initcall init_tstats_procfs+0x0/0x30 returned 0 after 7 us=
ecs
[    7.931155] calling  futex_init+0x0/0xe6 @ 1
[    7.935659] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    7.942275] initcall futex_init+0x0/0xe6 returned 0 after 6471 usecs
[    7.948945] calling  proc_dma_init+0x0/0x27 @ 1
[    7.953714] initcall proc_dma_init+0x0/0x27 returned 0 after 7 usecs
[    7.960390] calling  proc_modules_init+0x0/0x27 @ 1
[    7.965526] initcall proc_modules_init+0x0/0x27 returned 0 after 6 use=
cs
[    7.972562] calling  kallsyms_init+0x0/0x2a @ 1
[    7.977323] initcall kallsyms_init+0x0/0x2a returned 0 after 6 usecs
[    7.983993] calling  pid_namespaces_init+0x0/0x32 @ 1
[    7.989364] initcall pid_namespaces_init+0x0/0x32 returned 0 after 65 =
usecs
[    7.996683] calling  ikconfig_init+0x0/0x41 @ 1
[    8.001445] initcall ikconfig_init+0x0/0x41 returned 0 after 6 usecs
[    8.008125] calling  audit_init+0x0/0xed @ 1
[    8.012603] audit: initializing netlink subsys (disabled)
[    8.018321] audit: type=3D2000 audit(1405356321.551:1): initialized
[    8.024726] initcall audit_init+0x0/0xed returned 0 after 11849 usecs
[    8.031483] calling  audit_watch_init+0x0/0x31 @ 1
[    8.036522] initcall audit_watch_init+0x0/0x31 returned 0 after 3 usec=
s
[    8.043468] calling  audit_tree_init+0x0/0x3b @ 1
[    8.048409] initcall audit_tree_init+0x0/0x3b returned 0 after 3 usecs
[    8.055272] calling  init_kprobes+0x0/0x177 @ 1
[    8.060505] initcall init_kprobes+0x0/0x177 returned 0 after 466 usecs
[    8.067364] calling  utsname_sysctl_init+0x0/0x11 @ 1
[    8.072689] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 15 =
usecs
[    8.080003] calling  init_tracepoints+0x0/0x29 @ 1
[    8.085030] initcall init_tracepoints+0x0/0x29 returned 0 after 1 usec=
s
[    8.091984] calling  init_blk_tracer+0x0/0x56 @ 1
[    8.096937] initcall init_blk_tracer+0x0/0x56 returned 0 after 2 usecs
[    8.103787] calling  irq_work_init_cpu_notifier+0x0/0x25 @ 1
[    8.109749] initcall irq_work_init_cpu_notifier+0x0/0x25 returned 0 af=
ter 1 usecs
[    8.117603] calling  perf_event_sysfs_init+0x0/0x8f @ 1
[    8.123866] initcall perf_event_sysfs_init+0x0/0x8f returned 0 after 7=
44 usecs
[    8.131473] calling  init_per_zone_wmark_min+0x0/0x9d @ 1
[    8.137142] initcall init_per_zone_wmark_min+0x0/0x9d returned 0 after=
 4 usecs
[    8.144738] calling  kswapd_init+0x0/0x1d @ 1
[    8.149445] initcall kswapd_init+0x0/0x1d returned 0 after 137 usecs
[    8.156115] calling  extfrag_debug_init+0x0/0x7b @ 1
[    8.161368] initcall extfrag_debug_init+0x0/0x7b returned 0 after 27 u=
secs
[    8.168578] calling  setup_vmstat+0x0/0xcf @ 1
[    8.173283] initcall setup_vmstat+0x0/0xcf returned 0 after 27 usecs
[    8.179973] calling  mm_compute_batch_init+0x0/0x51 @ 1
[    8.185457] initcall mm_compute_batch_init+0x0/0x51 returned 0 after 0=
 usecs
[    8.192863] calling  slab_proc_init+0x0/0x2a @ 1
[    8.197713] initcall slab_proc_init+0x0/0x2a returned 0 after 7 usecs
[    8.204492] calling  workingset_init+0x0/0x38 @ 1
[    8.209430] initcall workingset_init+0x0/0x38 returned 0 after 5 usecs
[    8.216300] calling  proc_vmalloc_init+0x0/0x2a @ 1
[    8.221434] initcall proc_vmalloc_init+0x0/0x2a returned 0 after 7 use=
cs
[    8.228481] calling  procswaps_init+0x0/0x27 @ 1
[    8.233330] initcall procswaps_init+0x0/0x27 returned 0 after 6 usecs
[    8.240104] calling  init_frontswap+0x0/0x84 @ 1
[    8.244991] initcall init_frontswap+0x0/0x84 returned 0 after 33 usecs
[    8.251841] calling  hugetlb_init+0x0/0x3d8 @ 1
[    8.256597] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.263350] initcall hugetlb_init+0x0/0x3d8 returned 0 after 6601 usec=
s
[    8.270303] calling  slab_proc_init+0x0/0x7 @ 1
[    8.275073] initcall slab_proc_init+0x0/0x7 returned 0 after 0 usecs
[    8.281747] calling  cpucache_init+0x0/0x40 @ 1
[    8.286512] initcall cpucache_init+0x0/0x40 returned 0 after 1 usecs
[    8.293189] calling  init_cleancache+0x0/0xa8 @ 1
[    8.298169] initcall init_cleancache+0x0/0xa8 returned 0 after 32 usec=
s
[    8.305137] calling  zs_init+0x0/0x90 @ 1
[    8.309350] initcall zs_init+0x0/0x90 returned 0 after 2 usecs
[    8.315486] calling  fcntl_init+0x0/0x2f @ 1
[    8.320020] initcall fcntl_init+0x0/0x2f returned 0 after 52 usecs
[    8.326509] calling  proc_filesystems_init+0x0/0x27 @ 1
[    8.332005] initcall proc_filesystems_init+0x0/0x27 returned 0 after 7=
 usecs
[    8.339400] calling  dio_init+0x0/0x32 @ 1
[    8.343750] initcall dio_init+0x0/0x32 returned 0 after 51 usecs
[    8.350077] calling  fsnotify_mark_init+0x0/0x46 @ 1
[    8.355343] initcall fsnotify_mark_init+0x0/0x46 returned 0 after 57 u=
secs
[    8.362560] calling  dnotify_init+0x0/0x7c @ 1
[    8.367303] initcall dnotify_init+0x0/0x7c returned 0 after 77 usecs
[    8.373984] calling  inotify_user_setup+0x0/0x50 @ 1
[    8.379244] initcall inotify_user_setup+0x0/0x50 returned 0 after 43 u=
secs
[    8.386468] calling  aio_setup+0x0/0x7e @ 1
[    8.391059] initcall aio_setup+0x0/0x7e returned 0 after 189 usecs
[    8.397565] calling  proc_locks_init+0x0/0x27 @ 1
[    8.402507] initcall proc_locks_init+0x0/0x27 returned 0 after 7 usecs
[    8.409367] calling  dquot_init+0x0/0x116 @ 1
[    8.413939] VFS: Disk quotas dquot_6.5.2
[    8.418232] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    8.425103] initcall dquot_init+0x0/0x116 returned 0 after 10912 usecs
[    8.431956] calling  init_v2_quota_format+0x0/0x1d @ 1
[    8.437364] initcall init_v2_quota_format+0x0/0x1d returned 0 after 1 =
usecs
[    8.444675] calling  quota_init+0x0/0x2e @ 1
[    8.449198] initcall quota_init+0x0/0x2e returned 0 after 28 usecs
[    8.455694] calling  init_devpts_fs+0x0/0x52 @ 1
[    8.460678] initcall init_devpts_fs+0x0/0x52 returned 0 after 131 usec=
s
[    8.467619] calling  init_hugetlbfs_fs+0x0/0x145 @ 1
[    8.473116] initcall init_hugetlbfs_fs+0x0/0x145 returned 0 after 278 =
usecs
[    8.480428] calling  init_fat_fs+0x0/0x4c @ 1
[    8.485074] initcall init_fat_fs+0x0/0x4c returned 0 after 68 usecs
[    8.491670] calling  init_vfat_fs+0x0/0xf @ 1
[    8.496248] initcall init_vfat_fs+0x0/0xf returned 0 after 1 usecs
[    8.502755] calling  init_msdos_fs+0x0/0xf @ 1
[    8.507422] initcall init_msdos_fs+0x0/0xf returned 0 after 1 usecs
[    8.514014] calling  init_iso9660_fs+0x0/0x69 @ 1
[    8.519003] initcall init_iso9660_fs+0x0/0x69 returned 0 after 52 usec=
s
[    8.525949] calling  init_nfs_fs+0x0/0x142 @ 1
[    8.531094] initcall init_nfs_fs+0x0/0x142 returned 0 after 472 usecs
[    8.537873] calling  init_nfs_v2+0x0/0x11 @ 1
[    8.542456] initcall init_nfs_v2+0x0/0x11 returned 0 after 1 usecs
[    8.548958] calling  init_nfs_v3+0x0/0x11 @ 1
[    8.553542] initcall init_nfs_v3+0x0/0x11 returned 0 after 1 usecs
[    8.560048] calling  init_nfs_v4+0x0/0x30 @ 1
[    8.564634] NFS: Registering the id_resolver key type
[    8.569965] Key type id_resolver registered
[    8.574365] Key type id_legacy registered
[    8.578583] initcall init_nfs_v4+0x0/0x30 returned 0 after 13633 usecs
[    8.585437] calling  init_nlm+0x0/0x3b @ 1
[    8.589754] initcall init_nlm+0x0/0x3b returned 0 after 11 usecs
[    8.596066] calling  init_nls_cp437+0x0/0x11 @ 1
[    8.600918] initcall init_nls_cp437+0x0/0x11 returned 0 after 1 usecs
[    8.607687] calling  init_nls_ascii+0x0/0x11 @ 1
[    8.612542] initcall init_nls_ascii+0x0/0x11 returned 0 after 0 usecs
[    8.619304] calling  init_nls_iso8859_1+0x0/0x11 @ 1
[    8.624532] initcall init_nls_iso8859_1+0x0/0x11 returned 0 after 0 us=
ecs
[    8.631669] calling  init_nls_utf8+0x0/0x23 @ 1
[    8.636444] initcall init_nls_utf8+0x0/0x23 returned 0 after 1 usecs
[    8.643125] calling  init_ntfs_fs+0x0/0x1c9 @ 1
[    8.647879] ntfs: driver 2.1.30 [Flags: R/W].
[    8.652651] initcall init_ntfs_fs+0x0/0x1c9 returned 0 after 4663 usec=
s
[    8.659607] calling  init_autofs4_fs+0x0/0x26 @ 1
[    8.664616] tsc: Refined TSC clocksource calibration: 3000.105 MHz
[    8.664715] initcall init_autofs4_fs+0x0/0x26 returned 0 after 149 use=
cs
[    8.664733] calling  init_pstore_fs+0x0/0x41 @ 1
[    8.664758] initcall init_pstore_fs+0x0/0x41 returned 0 after 19 usecs
[    8.664763] calling  ipc_init+0x0/0x20 @ 1
[    8.664781] msgmni has been set to 1688
[    8.664805] initcall ipc_init+0x0/0x20 returned 0 after 37 usecs
[    8.664809] calling  ipc_sysctl_init+0x0/0x11 @ 1
[    8.664826] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 13 usec=
s
[    8.664831] calling  init_mqueue_fs+0x0/0x91 @ 1
[    8.721290] initcall init_mqueue_fs+0x0/0x91 returned 0 after 55185 us=
ecs
[    8.728419] calling  key_proc_init+0x0/0x64 @ 1
[    8.733193] initcall key_proc_init+0x0/0x64 returned 0 after 12 usecs
[    8.739955] calling  selinux_nf_ip_init+0x0/0x65 @ 1
[    8.745176] initcall selinux_nf_ip_init+0x0/0x65 returned 0 after 0 us=
ecs
[    8.752305] calling  init_sel_fs+0x0/0x8b @ 1
[    8.756884] initcall init_sel_fs+0x0/0x8b returned 0 after 1 usecs
[    8.763378] calling  selnl_init+0x0/0x53 @ 1
[    8.767890] initcall selnl_init+0x0/0x53 returned 0 after 18 usecs
[    8.774380] calling  sel_netif_init+0x0/0x54 @ 1
[    8.779235] initcall sel_netif_init+0x0/0x54 returned 0 after 0 usecs
[    8.785996] calling  sel_netnode_init+0x0/0x5f @ 1
[    8.791040] initcall sel_netnode_init+0x0/0x5f returned 0 after 0 usec=
s
[    8.797976] calling  sel_netport_init+0x0/0x5f @ 1
[    8.803020] initcall sel_netport_init+0x0/0x5f returned 0 after 0 usec=
s
[    8.809958] calling  aurule_init+0x0/0x2d @ 1
[    8.814536] initcall aurule_init+0x0/0x2d returned 0 after 3 usecs
[    8.821034] calling  crypto_algapi_init+0x0/0xc @ 1
[    8.826159] initcall crypto_algapi_init+0x0/0xc returned 0 after 7 use=
cs
[    8.833200] calling  chainiv_module_init+0x0/0xf @ 1
[    8.838413] initcall chainiv_module_init+0x0/0xf returned 0 after 1 us=
ecs
[    8.845549] calling  eseqiv_module_init+0x0/0xf @ 1
[    8.850693] initcall eseqiv_module_init+0x0/0xf returned 0 after 0 use=
cs
[    8.857727] calling  hmac_module_init+0x0/0xf @ 1
[    8.862670] initcall hmac_module_init+0x0/0xf returned 0 after 0 usecs
[    8.869519] calling  md5_mod_init+0x0/0xf @ 1
[    8.874186] initcall md5_mod_init+0x0/0xf returned 0 after 93 usecs
[    8.880781] calling  sha1_generic_mod_init+0x0/0xf @ 1
[    8.886271] initcall sha1_generic_mod_init+0x0/0xf returned 0 after 90=
 usecs
[    8.893669] calling  crypto_cbc_module_init+0x0/0xf @ 1
[    8.899151] initcall crypto_cbc_module_init+0x0/0xf returned 0 after 1=
 usecs
[    8.906558] calling  des_generic_mod_init+0x0/0x14 @ 1
[    8.912104] initcall des_generic_mod_init+0x0/0x14 returned 0 after 15=
1 usecs
[    8.919611] calling  aes_init+0x0/0xf @ 1
[    8.923898] initcall aes_init+0x0/0xf returned 0 after 78 usecs
[    8.930112] calling  zlib_mod_init+0x0/0xf @ 1
[    8.934863] initcall zlib_mod_init+0x0/0xf returned 0 after 74 usecs
[    8.941546] calling  crypto_authenc_module_init+0x0/0xf @ 1
[    8.947402] initcall crypto_authenc_module_init+0x0/0xf returned 0 aft=
er 1 usecs
[    8.955172] calling  crypto_authenc_esn_module_init+0x0/0xf @ 1
[    8.961398] initcall crypto_authenc_esn_module_init+0x0/0xf returned 0=
 after 0 usecs
[    8.969535] calling  krng_mod_init+0x0/0xf @ 1
[    8.974304] initcall krng_mod_init+0x0/0xf returned 0 after 93 usecs
[    8.980966] calling  proc_genhd_init+0x0/0x44 @ 1
[    8.985931] initcall proc_genhd_init+0x0/0x44 returned 0 after 14 usec=
s
[    8.992883] calling  init_emergency_pool+0x0/0x53 @ 1
[    8.998204] bounce: pool size: 64 pages
[    9.002227] initcall init_emergency_pool+0x0/0x53 returned 0 after 394=
7 usecs
[    9.009733] calling  bsg_init+0x0/0x119 @ 1
[    9.014212] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 251)
[    9.021995] initcall bsg_init+0x0/0x119 returned 0 after 7696 usecs
[    9.028579] calling  noop_init+0x0/0xf @ 1
[    9.032890] io scheduler noop registered
[    9.037006] initcall noop_init+0x0/0xf returned 0 after 4022 usecs
[    9.043505] calling  deadline_init+0x0/0xf @ 1
[    9.048163] io scheduler deadline registered
[    9.052647] initcall deadline_init+0x0/0xf returned 0 after 4382 usecs
[    9.059507] calling  cfq_init+0x0/0x89 @ 1
[    9.063906] io scheduler cfq registered (default)
[    9.068856] initcall cfq_init+0x0/0x89 returned 0 after 4932 usecs
[    9.075346] calling  percpu_counter_startup+0x0/0x35 @ 1
[    9.080938] initcall percpu_counter_startup+0x0/0x35 returned 0 after =
1 usecs
[    9.088431] calling  audit_classes_init+0x0/0x4f @ 1
[    9.093662] initcall audit_classes_init+0x0/0x4f returned 0 after 12 u=
secs
[    9.100887] calling  phy_core_init+0x0/0x45 @ 1
[    9.105679] initcall phy_core_init+0x0/0x45 returned 0 after 31 usecs
[    9.112458] calling  pci_proc_init+0x0/0x64 @ 1
[    9.117444] initcall pci_proc_init+0x0/0x64 returned 0 after 232 usecs
[    9.124292] calling  pcie_portdrv_init+0x0/0x6f @ 1
[    9.129641] pcieport 0000:00:06.0: irq 24 for MSI/MSI-X
[    9.135382] pcieport 0000:00:07.0: irq 25 for MSI/MSI-X
[    9.141104] initcall pcie_portdrv_init+0x0/0x6f returned 0 after 11413=
 usecs
[    9.148513] calling  aer_service_init+0x0/0x28 @ 1
[    9.153596] initcall aer_service_init+0x0/0x28 returned 0 after 45 use=
cs
[    9.160634] calling  pci_hotplug_init+0x0/0x1e @ 1
[    9.165672] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    9.171529] initcall pci_hotplug_init+0x0/0x1e returned 0 after 5723 u=
secs
[    9.178768] calling  pcied_init+0x0/0x76 @ 1
[    9.183372] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    9.190317] initcall pcied_init+0x0/0x76 returned 0 after 6899 usecs
[    9.196994] calling  pcifront_init+0x0/0x41 @ 1
[    9.201759] initcall pcifront_init+0x0/0x41 returned -19 after 0 usecs
[    9.208636] calling  genericbl_driver_init+0x0/0x11 @ 1
[    9.214166] initcall genericbl_driver_init+0x0/0x11 returned 0 after 5=
3 usecs
[    9.221670] calling  cirrusfb_init+0x0/0xaa @ 1
[    9.226506] initcall cirrusfb_init+0x0/0xaa returned 0 after 67 usecs
[    9.233270] calling  efifb_driver_init+0x0/0x11 @ 1
[    9.238448] initcall efifb_driver_init+0x0/0x11 returned 0 after 48 us=
ecs
[    9.245594] calling  intel_idle_init+0x0/0x2ec @ 1
[    9.250632] initcall intel_idle_init+0x0/0x2ec returned -19 after 1 us=
ecs
[    9.257772] calling  acpi_reserve_resources+0x0/0xc8 @ 1
[    9.263368] initcall acpi_reserve_resources+0x0/0xc8 returned 0 after =
14 usecs
[    9.270954] calling  acpi_ac_init+0x0/0x25 @ 1
[    9.275697] initcall acpi_ac_init+0x0/0x25 returned 0 after 73 usecs
[    9.282387] calling  acpi_button_driver_init+0x0/0xf @ 1
[    9.288358] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0C0C:00/input/input0
[    9.297135] ACPI: Power Button [PWRB]
[    9.301344] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
[    9.309103] ACPI: Power Button [PWRF]
[    9.312996] initcall acpi_button_driver_init+0x0/0xf returned 0 after =
24465 usecs
[    9.320863] calling  acpi_fan_driver_init+0x0/0xf @ 1
[    9.326227] initcall acpi_fan_driver_init+0x0/0xf returned 0 after 52 =
usecs
[    9.333549] calling  acpi_processor_driver_init+0x0/0x3e @ 1
[    9.339582] ACPI: processor limited to max C-state 1
[    9.345595] initcall acpi_processor_driver_init+0x0/0x3e returned 0 af=
ter 5953 usecs
[    9.353732] calling  acpi_thermal_init+0x0/0x8c @ 1
[    9.361763] thermal LNXTHERM:00: registered as thermal_zone0
[    9.367704] ACPI: Thermal Zone [THRM] (30 C)
[    9.372232] initcall acpi_thermal_init+0x0/0x8c returned 0 after 13075=
 usecs
[    9.379645] calling  acpi_battery_init+0x0/0x13 @ 1
[    9.384777] initcall acpi_battery_init+0x0/0x13 returned 0 after 8 use=
cs
[    9.384806] calling  1_acpi_battery_init_async+0x0/0x22 @ 6
[    9.384890] initcall 1_acpi_battery_init_async+0x0/0x22 returned 0 aft=
er 78 usecs
[    9.405521] calling  acpi_hed_driver_init+0x0/0xf @ 1
[    9.410888] initcall acpi_hed_driver_init+0x0/0xf returned 0 after 56 =
usecs
[    9.418196] calling  erst_init+0x0/0x2fa @ 1
[    9.422691] initcall erst_init+0x0/0x2fa returned 0 after 1 usecs
[    9.429098] calling  ghes_init+0x0/0x165 @ 1
[    9.433590] GHES: HEST is not enabled!
[    9.437537] initcall ghes_init+0x0/0x165 returned -22 after 3852 usecs
[    9.444395] calling  einj_init+0x0/0x4ef @ 1
[    9.448884] initcall einj_init+0x0/0x4ef returned -19 after 1 usecs
[    9.455473] calling  ioat_init_module+0x0/0xb0 @ 1
[    9.460505] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    9.466830] initcall ioat_init_module+0x0/0xb0 returned 0 after 6181 u=
secs
[    9.474059] calling  virtio_mmio_init+0x0/0x11 @ 1
[    9.479157] initcall virtio_mmio_init+0x0/0x11 returned 0 after 55 use=
cs
[    9.486195] calling  virtio_balloon_driver_init+0x0/0xf @ 1
[    9.492105] initcall virtio_balloon_driver_init+0x0/0xf returned 0 aft=
er 54 usecs
[    9.499976] calling  xenbus_probe_initcall+0x0/0x35 @ 1
[    9.505474] initcall xenbus_probe_initcall+0x0/0x35 returned -19 after=
 0 usecs
[    9.513068] calling  xenbus_init+0x0/0x37 @ 1
[    9.517662] initcall xenbus_init+0x0/0x37 returned -19 after 0 usecs
[    9.524339] calling  xenbus_backend_init+0x0/0x48 @ 1
[    9.529649] initcall xenbus_backend_init+0x0/0x48 returned -19 after 0=
 usecs
[    9.537053] calling  gntdev_init+0x0/0x48 @ 1
[    9.541644] initcall gntdev_init+0x0/0x48 returned -19 after 1 usecs
[    9.548325] calling  gntalloc_init+0x0/0x37 @ 1
[    9.553097] initcall gntalloc_init+0x0/0x37 returned -19 after 0 usecs
[    9.559963] calling  hypervisor_subsys_init+0x0/0x21 @ 1
[    9.565544] initcall hypervisor_subsys_init+0x0/0x21 returned -19 afte=
r 0 usecs
[    9.573225] calling  hyper_sysfs_init+0x0/0xcc @ 1
[    9.578265] initcall hyper_sysfs_init+0x0/0xcc returned -19 after 0 us=
ecs
[    9.585410] calling  platform_pci_module_init+0x0/0x16 @ 1
[    9.591256] initcall platform_pci_module_init+0x0/0x16 returned 0 afte=
r 74 usecs
[    9.599032] calling  xen_pcibk_init+0x0/0x110 @ 1
[    9.603988] initcall xen_pcibk_init+0x0/0x110 returned -19 after 1 use=
cs
[    9.611037] calling  xen_acpi_processor_init+0x0/0x1f7 @ 1
[    9.616809] initcall xen_acpi_processor_init+0x0/0x1f7 returned -19 af=
ter 0 usecs
[    9.624682] calling  pty_init+0x0/0x3d9 @ 1
[    9.697163] initcall pty_init+0x0/0x3d9 returned 0 after 66546 usecs
[    9.703842] calling  sysrq_init+0x0/0xbe @ 1
[    950_init+0x0/0x16d @ 1
[    9.731511] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    9.738419] Switc?[   10.626069] console [ttyS0] enabled
[   10.626069] console [ttyS0] enabled
[   10.633329] bootconsole [uart0] disabled
[   10.633329] bootconsole [uart0] disabled
[   10.642113] initcall serial_pci_driver_init+0x0/0x16 returned 0 after =
881868 usecs
[   10.649927] calling  init_kgdboc+0x0/0x15 @ 1
[   10.654421] initcall init_kgdboc+0x0/0x15 returned 0 after 4 usecs
[   10.660792] calling  init+0x0/0xf3 @ 1
[   10.664803] initcall init+0x0/0xf3 returned 0 after 146 usecs
[   10.670725] calling  hpet_init+0x0/0x57 @ 1
[   10.675523] initcall hpet_init+0x0/0x57 returned 0 after 479 usecs
[   10.681905] calling  nvram_init+0x0/0x7e @ 1
[   10.686443] Non-volatile memory driver v1.3
[   10.690763] initcall nvram_init+0x0/0x7e returned 0 after 4346 usecs
[   10.697327] calling  mod_init+0x0/0x1b6 @ 1
[   10.701679] initcall mod_init+0x0/0x1b6 returned -19 after 40 usecs
[   10.708151] calling  mod_init+0x0/0x12d @ 1
[   10.712476] initcall mod_init+0x0/0x12d returned -19 after 19 usecs
[   10.718937] calling  mod_init+0x0/0x99 @ 1
[   10.723169] initcall mod_init+0x0/0x99 returned -19 after 3 usecs
[   10.729444] calling  mod_init+0x0/0x48 @ 1
[   10.733663] initcall mod_init+0x0/0x48 returned -19 after 0 usecs
[   10.739944] calling  rng_init+0x0/0xf @ 1
[   10.744232] initcall rng_init+0x0/0xf returned 0 after 159 usecs
[   10.750434] calling  agp_init+0x0/0x2f @ 1
[   10.754661] Linux agpgart interface v0.103
[   10.758880] initcall agp_init+0x0/0x2f returned 0 after 4124 usecs
[   10.765251] calling  agp_ali_init+0x0/0x24 @ 1
[   10.769903] initcall agp_ali_init+0x0/0x24 returned 0 after 74 usecs
[   10.776454] calling  agp_ati_init+0x0/0x24 @ 1
[   10.781106] initcall agp_ati_init+0x0/0x24 returned 0 after 75 usecs
[   10.787659] calling  agp_amdk7_init+0x0/0x24 @ 1
[   10.792487] initcall agp_amdk7_init+0x0/0x24 returned 0 after 73 usecs
[   10.799217] calling  agp_amd64_mod_init+0x0/0xa @ 1
[   10.804927] initcall agp_amd64_mod_init+0x0/0xa returned -19 after 672=
 usecs
[   10.812194] calling  agp_efficeon_init+0x0/0x39 @ 1
[   10.817281] initcall agp_efficeon_init+0x0/0x39 returned 0 after 65 us=
ecs
[   10.824286] calling  agp_intel_init+0x0/0x24 @ 1
[   10.829112] initcall agp_intel_init+0x0/0x24 returned 0 after 71 usecs
[   10.835846] calling  agp_nvidia_init+0x0/0x24 @ 1
[   10.840761] initcall agp_nvidia_init+0x0/0x24 returned 0 after 69 usec=
s
[   10.847581] calling  agp_sis_init+0x0/0x24 @ 1
[   10.852226] initcall agp_sis_init+0x0/0x24 returned 0 after 70 usecs
[   10.858778] calling  agp_serverworks_init+0x0/0x24 @ 1
[   10.864139] initcall agp_serverworks_init+0x0/0x24 returned 0 after 69=
 usecs
[   10.871408] calling  agp_via_init+0x0/0x24 @ 1
[   10.876055] initcall agp_via_init+0x0/0x24 returned 0 after 70 usecs
[   10.882606] calling  drm_core_init+0x0/0x107 @ 1
[   10.887429] [drm] Initialized drm 1.1.0 20060810
[   10.892184] initcall drm_core_init+0x0/0x107 returned 0 after 4711 use=
cs
[   10.899098] calling  cn_proc_init+0x0/0x33 @ 1
[   10.903681] initcall cn_proc_init+0x0/0x33 returned 0 after 10 usecs
[   10.910236] calling  topology_sysfs_init+0x0/0x60 @ 1
[   10.915632] initcall topology_sysfs_init+0x0/0x60 returned 0 after 190=
 usecs
[   10.922902] calling  loop_init+0x0/0x12b @ 1
[   10.933527] loop: module loaded
[   10.936762] initcall loop_init+0x0/0x12b returned 0 after 9250 usecs
[   10.943317] callx0/0x2e9 returned 0 after 4844 usecs
[   10.970801] calling  mac_hid_init+0x0/0x1c @ 1
[   10.975402] initcall mac_hid_init+0x0/0x1c returned 0 after 14 usecs
[   10.981954] calling  macvlan_init_module+0x0/0x31 @ 1
[   10.987169] initcall macvlan_init_module+0x0/0x31 returned 0 after 7 u=
secs
[   10.994261] calling  macvtap_init+0x0/0xd0 @ 1
[   10.998884] initcall macvtap_init+0x0/0xd0 returned 0 after 38 usecs
[   11.005435] calling  net_olddevs_init+0x0/0x88 @ 1
[   11.010382] initcall net_olddevs_init+0x0/0x88 returned 0 after 7 usec=
s
[   11.017203] calling  fixed_mdio_bus_init+0x0/0xe3 @ 1
[   11.022610] libphy: Fixed MDIO Bus: probed
[   11.026833] initcall fixed_mdio_bus_init+0x0/0xe3 returned 0 after 431=
8 usecs
[   11.034193] calling  tun_init+0x0/0x8b @ 1
[   11.038413] tun: Universal TUN/TAP device driver, 1.6
[   11.043621] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   11.050143] initcall tun_init+0x0/0x8b returned 0 after 11466 usecs
[   11.056614] calling  tg3_driver_init+0x0/0x16 @ 1
[   11.061595] initcall tg3_driver_init+0x0/0x16 returned 0 after 117 use=
cs
[   11.068510] calling  ixgbevf_init_module+0x0/0x49 @ 1
[   11.073719] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function =
Network Driver - version 2.12.1-k
[   11.083397] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[   11.089780] initcall ixgbevf_init_module+0x0/0x49 returned 0 after 157=
03 usecs
[   11.097229] calling  forcedeth_pci_driver_init+0x0/0x16 @ 1
[   11.103047] initcall forcedeth_pci_driver_init+0x0/0x16 returned 0 aft=
er 78 usecs
[   11.110764] calling  netback_init+0x0/0x81 @ 1
[   11.115345] initcall netback_init+0x0/0x81 returned -19 after 0 usecs
[   11.121982] calling  fw_core_init+0x0/0xf1 @ 1
[   11.126732] initcall fw_core_init+0x0/0xf1 returned 0 after 172 usecs
[   11.133380] calling  nonstatic_sysfs_init+0x0/0xf @ 1
[   11.138595] initcall nonstatic_sysfs_init+0x0/0xf returned 0 after 0 u=
secs
[   11.145678] calling  yenta_cardbus_driver_init+0x0/0x16 @ 1
[   11.151531] initcall yenta_cardbus_driver_init+0x0/0x16 returned 0 aft=
er 113 usecs
[   11.159338] calling  mon_init+0x0/0xe1 @ 1
[   11.163765] initcall mon_init+0x0/0xe1 returned 0 after 207 usecs
[   11.170057] calling  ehci_hcd_init+0x0/0x58 @ 1
[   11.174737] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   11.181461] initcall ehci_hcd_init+0x0/0x58 returned 0 after 6572 usec=
s
[   11.188283] calling  ehci_pci_init+0x0/0x60 @ 1
[   11.192950] ehci-pci: EHCI PCI platform driver
[   11.199371] QUIRK: Enable AMD PLL fix
[   11.203174] ehci-pci 0000:00:12.2: EHCI Host Controller
[   11.208846] ehci-pci 0000:00:12.2: new USB bus registered, assigned bu=
s number 1
[   11.216479] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3=
 EHCI dummy qh workaround
[   11.225434] ehci-pci 0000:00:12.2: applying AMD SB600/SB700 USB freeze=
 workaround
[   11.233148] ehci-pci 0000:00:12.2: debug port 1
[   11.237946] ehci-pci 0000:00:12.2: irq 17, io mem 0xfe6ff800
[   11.249375] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   11.255603] usb usb1: New USB device found, idVendor=3D1d6b, :12.2
[   11.288959] hub 1-0:1.0: USB hub found
[   11.292889] hub 1-0:1.0: 6 ports detected
[   11.300351] ehci-pci 0000:00:13.2: EHCI Host Controller
[   11.306030] ehci-pci 0000:00:13.2: new USB bus registered, assignSB600=
/SB700 USB freeze workaround
[   11.330359] ehci-pci 0000:00:13.2: debug port 1
[   11.335164] ehci-pci 0000:00:13.2: irq 19, io mem 0xfe6ff400
[   11.341293] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   11.347512] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   11.354502] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[   11.361935] usb usb2: Product: EHCI Host Controller
[   11.366953] usb usb2: Manufacturer: Linux 3.16.0-rc5upstream-00060-g8e=
655983b ehci_hcd
[   11.375103] usb usb2: SerialNumber: 0000:00:13.2
[   11.380829] hub 2-0:1.0: USB hub found
[   11.384761] hub 2-0:1.0: 6 ports detected
[   11.390402] initcall ehci_pci_init+0x0/0x60 returned 0 after 193007 us=
ecs
[   11.397396] calling  ohci_hcd_mod_init+0x0/0x5e @ 1
[   11.402415] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   11.408786] initcall ohci_hcd_mod_init+0x0/0x5e returned 0 after 6226 =
usecs
[   11.415956] calling  ohci_pci_init+0x0/0x60 @ 1
[   11.420617] ohci-pci: OHCI PCI platform driver
[   11.426981] ohci-pci 0000:00:12.0: OHCI PCI host controller
[   11.433012] ohci-pci 0000:00:12.0: new USB bus registered, assigned bu=
s number 3
[   11.440768] ohci-pci 0000:00:12.0: irq 16, io mem 0xfe6fe000
[   11.501472] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   11.508481] usb usb3: New USB device strings: M-00060-g8e655983b ohci_=
hcd
[   11.529458] usb usb3: SerialNumber: 0000:00:12.0
[   11.535180] hub 3-0:1.0: USB hub found
[   11.539102] hub 3-0:1.0: 3 ports detected
[   11.545877] ohci-pci 0000:00:12.1: OHCI PCI host controller
[   11.551903] ohci-pci 0000:00:12.1: new USB bus registered, as[   11.62=
0388] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
[   11.627380] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[   11.634815] usb usb4: Product: OHCI PCI host controller
[   11.640192] usb usb4: Manufacturer: Linux 3.16.0-rc5upstream-00060-g8e=
655983b ohci_hcd
[   11.648340] usb usb4: SerialNumber: 0000:00:12.1
[   11.654070] hub 4-0:1.0: USB hub found
[   11.657994] hub 4-0:1.0: 3 ports detected
[   11.664774] ohci-pci 0000:00:13.0: OHCI PCI host controller
[   11.670796] ohci-pci 0000:00:13.0: new USB bus registered, assigned bu=
s number 5
[   11.678551] ohci-pci 0000:00:13.0: irq 18, io mem 0xfe6fc000
[   11.739256] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   11.746265] usb usb5: New USB device strings: Mci_hcd
[   11.767239] usb usb5: SerialNumber: 0000:00:13.0
[   11.772971] hub 5-0:1.0: USB hub found
[   11.776892] hub 5-0:1.0: 3 ports detected
[   11.783636] ohci-pci 0000:00:13.1: OHCI PCI host controller
[   11.789666] ohci-pci 0000:00:13.1: new USB bus registered, assigned bu=
s number 6
[   11.797360] ohci-pci 0000:00:13.1: irq 18, io mem 0xfe6f7000
[   11.858166] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   11.865158] usb usb6: New USB device strings: M11.886116] usb usb6: Se=
rialNumber: 0000:00:13.1
[   11.891875] hub 6-0:1.0: USB hub found
[   11.895794] hub 6-0:1.0: 3 ports detected
[   11.902536] ohci-pci 0000:00:14.5: OHCI PCI host controller
[   11.908564] ohci-pci 0000:00:14.5: new USB bus registered, assigned bu=
s number 7
[   11.916263] ohci-pci 0000:00:14.5: irq 18, io mem 0xfe6f6000
[   11.977045] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   11.984038] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[   11.991472] usb usb7: Product: OHCI PCI host controller
[   11.996850] usb usb7: Manufacturer: Linux 3.16.0-rc5upstream-00060-g8e=
655983b ohci_hcd
[   12.005000] usb usb7: SerialNumber: 0000:00:14.5
[   12.010741] hub 7-0:1.0: USB hub found
[   12.014664] hub 7-0:1.0: 2 ports detected
[   12.019624] initcall ohci_pci_init+0x0/0x60 returned 0 after 585516 us=
ecs
[   12.026627] calling  uhci_hcd_init+0x0/0xa4 @ 1
[   12.031292] uhci_hcd: USB Universal Host Controller Interface driver
[   12.037998] initcall uhci_hcd_init+0x0/0xa4 returned 0 after 6557 usec=
s
[   12.044819] calling  usblp_driver_init+0x0/0x16 @ 1
[   12.049957] usbcore: registered new interface driver usblp
[   12.055603] initcall usblp_driver_init+0x0/0x16 returned 0 after 5634 =
usecs
[   12.062774] calling  kgdbdbgp_start_thread+0x0/0x57 @ 1
[   12.068158] initcall kgdbdbgp_start_thread+0x0/0x57 returned 0 after 0=
 usecs
[   12.075421] calling  i8042_init+0x0/0x3b7 @ 1
[   12.080073] i8042: PNP: No PS/2 controller found. Probing ports direct=
ly.
[   12.087606] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.092728] serio: i8042 AUX port at 0x60,0x64 irq 12
[   12.097962] initcall i8042_init+0x0/0x3b7 returned 0 after 17649 usecs
[   12.104685] calling  serport_init+0x0/0x2e @ 1
[   12.109262] initcall serport_init+0x0/0x2e returned 0 after 0 usecs
[   12.115716] calling  mousedev_init+0x0/0x54 @ 1
[   12.120593] mousedev: PS/2 mouse device common for all mice
[   12.126333] initcall mousedev_init+0x0/0x54 returned 0 after 5814 usec=
s
[   12.133146] calling  evdev_init+0x0/0xf @ 1
[   12.137755] initcall evdev_init+0x0/0xf returned 0 after 296 usecs
[   12.144123] calling  atkbd_init+0x0/0x20 @ 1
[   12.148593] initcall atkbd_init+0x0/0x20 returned 0 after 72 usecs
[   12.154963] calling  psmouse_init+0x0/0x8a @ 1
[   12.159739] initcall psmouse_init+0x0/0x8a returned 0 after 192 usecs
[   12.166394] calling  cmos_init+0x0/0x66 @ 1
[   12.170754] rtc_cmos 00:01: RTC can wake from S4
[   12.175954] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[   12.182287] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvr=
am, hpet irqs
[   12.190209] initcall cmos_init+0x0/0x66 returned 0 after 19067 usecs
[   12.196752] calling  i2c_i801_init+0x0/0x92 @ 1
[   12.201522] initcall i2c_i801_init+0x0/0x92 returned 0 after 105 usecs
[   12.208243] calling  cpufreq_gov_dbs_init+0x0/0xf @ 1
[   12.213441] initcall cpufreq_gov_dbs_init+0x0/0xf returned 0 after 0 u=
secs
[   12.220524] calling  efivars_sysfs_init+0x0/0x1d0 @ 1
[   12.225724] initcall efivars_sysfs_init+0x0/0x1d0 returned -19 after 0=
 usecs
[   12.232983] calling  efivars_pstore_init+0x0/0x89 @ 1
[   12.238182] initcall efivars_pstore_init+0x0/0x89 returned 0 after 0 u=
secs
[   12.245261] calling  vhost_net_init+0x0/0x20 @ 1
[   12.250142] initcall vhost_net_init+0x0/0x20 returned 0 after 125 usec=
s
[   12.256961] calling  vhost_init+0x0/0x7 @ 1
[   12.261265] initcall vhost_init+0x0/0x7 returned 0 after 0 usecs
[   12.267449] calling  staging_init+0x0/0x7 @ 1
[   12.271933] initcall staging_init+0x0/0x7 returned 0 after 0 usecs
[   12.278297] calling  eeepc_laptop_init+0x0/0x4f @ 1
[   12.283472] initcall eeepc_laptop_init+0x0/0x4f returned -19 after 151=
 usecs
[   12.290731] calling  sock_diag_init+0x0/0xf @ 1
[   12.295410] initcall sock_diag_init+0x0/0xf returned 0 after 16 usecs
[   12.302042] calling  llc_init+0x0/0x1b @ 1
[   12.306258] initcall llc_init+0x0/0x1b returned 0 after 0 usecs
[   12.312355] calling  snap_init+0x0/0x35 @ 1
[   12.316662] initcall snap_init+0x0/0x35 returned 0 after 2 usecs
[   12.322848] calling  blackhole_module_init+0x0/0xf @ 1
[   12.328135] initcall blackhole_module_init+0x0/0xf returned 0 after 0 =
usecs
[   12.335306] calling  nfnetlink_init+0x0/0x4b @ 1
[   12.340056] Netfilter messages via NETLINK v0.30.
[   12.344909] initcall nfnetlink_init+0x0/0x4b returned 0 after 4743 use=
cs
[   12.351811] calling  nfnetlink_log_init+0x0/0x8f @ 1
[   12.356934] initcall nfnetlink_log_init+0x0/0x8f returned 0 after 11 u=
secs
[   12.364013] calling  nf_conntrack_standalone_init+0x0/0x70 @ 1
[   12.370017] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   12.376513] initcall nf_conntrack_standalone_init+0x0/0x70 returned 0 =
after 6349 usecs
[   12.384668] calling  ctnetlink_init+0x0/0x92 @ 1
[   12.389418] ctnetlink v0.93: registering with nfnetlink.
[   12.394887] initcall ctnetlink_init+0x0/0x92 returned 0 after 5344 use=
cs
[   12.401789] calling  nf_conntrack_ftp_init+0x0/0x195 @ 1
[   12.407261] initcall nf_conntrack_ftp_init+0x0/0x195 returned 0 after =
3 usecs
[   12.414612] calling  nf_conntrack_irc_init+0x0/0x148 @ 1
[   12.420085] initcall nf_conntrack_irc_init+0x0/0x148 returned 0 after =
5 usecs
[   12.427434] calling  nf_conntrack_sip_init+0x0/0x1e4 @ 1
[   12.432901] initcall nf_conntrack_sip_init+0x0/0x1e4 returned 0 after =
1 usecs
[   12.440250] calling  xt_init+0x0/0xb5 @ 1
[   12.444381] initcall xt_init+0x0/0xb5 returned 0 after 7 usecs
[   12.450388] calling  tcpudp_mt_init+0x0/0x14 @ 1
[   12.455141] initcall tcpudp_mt_init+0x0/0x14 returned 0 after 0 usecs
[   12.461774] calling  connsecmark_tg_init+0x0/0xf @ 1
[   12.466883] initcall connsecmark_tg_init+0x0/0xf returned 0 after 0 us=
ecs
[   12.473872] calling  nflog_tg_init+0x0/0xf @ 1
[   12.478446] initcall nflog_tg_init+0x0/0xf returned 0 after 0 usecs
[   12.484900] calling  secmark_tg_init+0x0/0xf @ 1
[   12.489653] initcall secmark_tg_init+0x0/0xf returned 0 after 0 usecs
[   12.496286] calling  tcpmss_tg_init+0x0/0x14 @ 1
[   12.501038] initcall tcpmss_tg_init+0x0/0x14 returned 0 after 0 usecs
[   12.507672] calling  conntrack_mt_init+0x0/0x14 @ 1
[   12.512692] initcall conntrack_mt_init+0x0/0x14 returned 0 after 0 use=
cs
[   12.519595] calling  policy_mt_init+0x0/0x14 @ 1
[   12.524348] initcall policy_mt_init+0x0/0x14 returned 0 after 0 usecs
[   12.530980] calling  state_mt_init+0x0/0xf @ 1
[   12.535552] initcall state_mt_init+0x0/0xf returned 0 after 0 usecs
[   12.542006] calling  gre_offload_init+0x0/0x14 @ 1
[   12.546937] initcall gre_offload_init+0x0/0x14 returned 0 after 0 usec=
s
[   12.553748] calling  sysctl_ipv4_init+0x0/0x44 @ 1
[   12.558721] initcall sysctl_ipv4_init+0x0/0x44 returned 0 after 42 use=
cs
[   12.565622] calling  tunnel4_init+0x0/0x6d @ 1
[   12.570195] initcall tunnel4_init+0x0/0x6d returned 0 after 0 usecs
[   12.576647] calling  ipv4_netfilter_init+0x0/0xf @ 1
[   12.581756] initcall ipv4_netfilter_init+0x0/0xf returned 0 after 0 us=
ecs
[   12.588748] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x150 @ 1
[   12.595214] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x150 returned=
 0 after 188 usecs
[   12.603545] calling  nf_defrag_init+0x0/0x14 @ 1
[   12.608297] initcall nf_defrag_init+0x0/0x14 returned 0 after 0 usecs
[   12.614930] calling  ip_tables_init+0x0/0x8f @ 1
[   12.619702] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.625169] initcall ip_tables_init+0x0/0x8f returned 0 after 5364 use=
cs
[   12.632068] calling  iptable_filter_init+0x0/0x40 @ 1
[   12.637371] initcall iptable_filter_init+0x0/0x40 returned 0 after 102=
 usecs
[   12.644629] calling  iptable_mangle_init+0x0/0x40 @ 1
[   12.649906] initcall iptable_mangle_init+0x0/0x40 returned 0 after 78 =
usecs
[   12.657075] calling  reject_tg_init+0x0/0xf @ 1
[   12.661737] initcall reject_tg_init+0x0/0xf returned 0 after 0 usecs
[   12.668280] calling  ulog_tg_init+0x0/0x74 @ 1
[   12.672872] initcall ulog_tg_init+0x0/0x74 returned 0 after 18 usecs
[   12.679414] calling  cubictcp_register+0x0/0x72 @ 1
[   12.684433] TCP: cubic registered
[   12.687843] initcall cubictcp_register+0x0/0x72 returned 0 after 3332 =
usecs
[   12.695012] calling  xfrm_user_init+0x0/0x43 @ 1
[   12.699763] Initializing XFRM netlink socket
[   12.704171] initcall xfrm_user_init+0x0/0x43 returned 0 after 4308 use=
cs
[   12.711072] calling  inet6_init+0x0/0x2c3 @ 1
[   12.715823] NET: Registered protocol family 10
[   12.721205] initcall inet6_init+0x0/0x2c3 returned 0 after 5522 usecs
[   12.727846] calling  ah6_init+0x0/0x75 @ 1
[   12.732070] initcall ah6_init+0x0/0x75 returned 0 after 1 usecs
[   12.738171] calling  esp6_init+0x0/0x75 @ 1
[   12.742481] initcall esp6_init+0x0/0x75 returned 0 after 0 usecs
[   12.748671] calling  xfrm6_transport_init+0x0/0x14 @ 1
[   12.753961] initcall xfrm6_transport_init+0x0/0x14 returned 0 after 0 =
usecs
[   12.761136] calling  xfrm6_mode_tunnel_init+0x0/0x14 @ 1
[   12.766608] initcall xfrm6_mode_tunnel_init+0x0/0x14 returned 0 after =
0 usecs
[   12.773960] calling  xfrm6_beet_init+0x0/0x14 @ 1
[   12.778804] initcall xfrm6_beet_init+0x0/0x14 returned 0 after 0 usecs
[   12.785529] calling  ip6_tables_init+0x0/0x8f @ 1
[   12.790397] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   12.795955] initcall ip6_tables_init+0x0/0x8f returned 0 after 5454 us=
ecs
[   12.802951] calling  ip6table_filter_init+0x0/0x40 @ 1
[   12.808413] initcall ip6table_filter_init+0x0/0x40 returned 0 after 17=
0 usecs
[   12.815764] calling  ip6table_mangle_init+0x0/0x40 @ 1
[   12.821193] initcall ip6table_mangle_init+0x0/0x40 returned 0 after 13=
3 usecs
[   12.828546] calling  nf_conntrack_l3proto_ipv6_init+0x0/0x129 @ 1
[   12.834832] initcall nf_conntrack_l3proto_ipv6_init+0x0/0x129 returned=
 0 after 11 usecs
[   12.843079] calling  nf_defrag_init+0x0/0x4c @ 1
[   12.847860] initcall nf_defrag_init+0x0/0x4c returned 0 after 24 usecs
[   12.854586] calling  ipv6header_mt6_init+0x0/0xf @ 1
[   12.859698] initcall ipv6header_mt6_init+0x0/0xf returned 0 after 0 us=
ecs
[   12.866693] calling  reject_tg6_init+0x0/0xf @ 1
[   12.871448] initcall reject_tg6_init+0x0/0xf returned 0 after 0 usecs
[   12.878086] calling  sit_init+0x0/0xbc @ 1
[   12.882305] sit: IPv6 over IPv4 tunneling driver
[   12.888009] initcall sit_init+0x0/0xbc returned 0 after 5573 usecs
[   12.894378] calling  packet_init+0x0/0x39 @ 1
[   12.898865] NET: Registered protocol family 17
[   12.903449] initcall packet_init+0x0/0x39 returned 0 after 4480 usecs
[   12.910081] calling  br_init+0x0/0x90 @ 1
[   12.914268] initcall br_init+0x0/0x90 returned 0 after 54 usecs
[   12.920370] calling  init_rpcsec_gss+0x0/0x54 @ 1
[   12.925277] initcall init_rpcsec_gss+0x0/0x54 returned 0 after 60 usec=
s
[   12.932097] calling  dcbnl_init+0x0/0x5e @ 1
[   12.936496] initcall dcbnl_init+0x0/0x5e returned 0 after 0 usecs
[   12.942772] calling  init_dns_resolver+0x0/0xcd @ 1
[   12.947808] Key type dns_resolver registered
[   12.952207] initcall init_dns_resolver+0x0/0xcd returned 0 after 4311 =
usecs
[   12.959381] calling  mcheck_init_device+0x0/0x177 @ 1
[   12.965474] initcall mcheck_init_device+0x0/0x177 returned 0 after 868=
 usecs
[   12.972786] calling  mcheck_debugfs_init+0x0/0x3e @ 1
[   12.978002] initcall mcheck_debugfs_init+0x0/0x3e returned 0 after 16 =
usecs
[   12.985171] calling  severities_debugfs_init+0x0/0x3e @ 1
[   12.990735] initcall severities_debugfs_init+0x0/0x3e returned 0 after=
 5 usecs
[   12.998173] calling  threshold_init_device+0x0/0x44 @ 1
[   13.004081] initcall threshold_init_device+0x0/0x44 returned 0 after 5=
18 usecs
[   13.011519] calling  hpet_insert_resource+0x0/0x1e @ 1
[   13.016810] initcall hpet_insert_resource+0x0/0x1e returned 0 after 0 =
usecs
[   13.023981] calling  update_mp_table+0x0/0x527 @ 1
[   13.028912] initcall update_mp_table+0x0/0x527 returned 0 after 0 usec=
s
[   13.035725] calling  lapic_insert_resource+0x0/0x46 @ 1
[   13.041101] initcall lapic_insert_resource+0x0/0x46 returned 0 after 0=
 usecs
[   13.048360] calling  io_apic_bug_finalize+0x0/0x1a @ 1
[   13.053648] initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 0 =
usecs
[   13.060819] calling  print_ICs+0x0/0x437 @ 1
[   13.065213] initcall print_ICs+0x0/0x437 returned 0 after 0 usecs
[   13.071489] calling  print_ipi_mode+0x0/0x2e @ 1
[   13.076240] Using IPI No-Shortcut mode
[   13.080098] initcall print_ipi_mode+0x0/0x2e returned 0 after 3769 use=
cs
[   13.087000] calling  pat_memtype_list_init+0x0/0x37 @ 1
[   13.092384] initcall pat_memtype_list_init+0x0/0x37 returned 0 after 6=
 usecs
[   13.099644] calling  init_oops_id+0x0/0x50 @ 1
[   13.104219] initcall init_oops_id+0x0/0x50 returned 0 after 1 usecs
[   13.110674] calling  pm_qos_power_init+0x0/0x5d @ 1
[   13.116048] initcall pm_qos_power_init+0x0/0x5d returned 0 after 345 u=
secs
[   13.123136] calling  pm_debugfs_init+0x0/0x2a @ 1
[   13.127991] initcall pm_debugfs_init+0x0/0x2a returned 0 after 6 usecs
[   13.134715] calling  printk_late_init+0x0/0x38 @ 1
[   13.139651] initcall printk_late_init+0x0/0x38 returned 0 after 0 usec=
s
[   13.146468] calling  tk_debug_sleep_time_init+0x0/0x41 @ 1
[   13.152125] initcall tk_debug_sleep_time_init+0x0/0x41 returned 0 afte=
r 6 usecs
[   13.159656] calling  debugfs_kprobe_init+0x0/0xa6 @ 1
[   13.164884] initcall debugfs_kprobe_init+0x0/0xa6 returned 0 after 23 =
usecs
[   13.172058] calling  taskstats_init+0x0/0x6e @ 1
[   13.176832] registered taskstats version 1
[   13.181051] initcall taskstats_init+0x0/0x6e returned 0 after 4139 use=
cs
[   13.187957] calling  clear_boot_tracer+0x0/0x2d @ 1
[   13.192981] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 use=
cs
[   13.199887] calling  kdb_ftrace_register+0x0/0x35 @ 1
[   13.205093] initcall kdb_ftrace_register+0x0/0x35 returned 0 after 3 u=
secs
[   13.212179] calling  fault_around_debugfs+0x0/0x3a @ 1
[   13.217478] initcall fault_around_debugfs+0x0/0x3a returned 0 after 6 =
usecs
[   13.224653] calling  max_swapfiles_check+0x0/0x7 @ 1
[   13.229767] initcall max_swapfiles_check+0x0/0x7 returned 0 after 0 us=
ecs
[   13.236762] calling  set_recommended_min_free_kbytes+0x0/0xb0 @ 1
[   13.243039] initcall set_recommended_min_free_kbytes+0x0/0xb0 returned=
 0 after 1 usecs
[   13.251195] calling  kmemleak_late_init+0x0/0x8e @ 1
[   13.256371] kmemleak: Kernel memory leak detector initialized
[   13.256373] kmemleak: Automatic memory scanning thread started
[   13.268292] initcall kmemleak_late_init+0x0/0x8e returned 0 after 1171=
3 usecs
[   13.275646] calling  check_early_ioremap_leak+0x0/0x5d @ 1
[   13.281298] initcall check_early_ioremap_leak+0x0/0x5d returned 0 afte=
r 0 usecs
[   13.288830] calling  init_root_keyring+0x0/0xa @ 1
[   13.293788] initcall init_root_keyring+0x0/0xa returned 0 after 23 use=
cs
[   13.300697] calling  fail_make_request_debugfs+0x0/0x23 @ 1
[   13.306480] initcall fail_make_request_debugfs+0x0/0x23 returned 0 aft=
er 42 usecs
[   13.314191] calling  prandom_reseed+0x0/0x3e @ 1
[   13.318960] initcall prandom_reseed+0x0/0x3e returned 0 after 12 usecs
[   13.325690] calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
[   13.332154] initcall pci_resource_alignment_sysfs_init+0x0/0x14 return=
ed 0 after 7 usecs
[   13.340492] calling  pci_sysfs_init+0x0/0x44 @ 1
[   13.346570] initcall pci_sysfs_init+0x0/0x44 returned 0 after 1293 use=
cs
[   13.353477] calling  boot_wait_for_devices+0x0/0x28 @ 1
[   13.358860] initcall boot_wait_for_devices+0x0/0x28 returned -19 after=
 0 usecs
[   13.366302] calling  deferred_probe_initcall+0x0/0x80 @ 1
[   13.371954] initcall deferred_probe_initcall+0x0/0x80 returned 0 after=
 87 usecs
[   13.379487] calling  late_resume_init+0x0/0x190 @ 1
[   13.384507]   Magic number: 6:989:792
[   13.388341] tty ptyr0: hash matches
[   13.391984] initcall late_resume_init+0x0/0x190 returned 0 after 7307 =
usecs
[   13.399158] calling  firmware_memmap_init+0x0/0x29 @ 1
[   13.404763] initcall firmware_memmap_init+0x0/0x29 returned 0 after 30=
8 usecs
[   13.412116] calling  pci_mmcfg_late_insert_resources+0x0/0x43 @ 1
[   13.418389] initcall pci_mmcfg_late_insert_resources+0x0/0x43 returned=
 0 after 0 usecs
[   13.426545] calling  tcp_congestion_default+0x0/0xf @ 1
[   13.431927] initcall tcp_congestion_default+0x0/0xf returned 0 after 0=
 usecs
[   13.439189] calling  ip_auto_config+0x0/0xeb7 @ 1
[   13.444045] initcall ip_auto_config+0x0/0xeb7 returned 0 after 8 usecs
[   13.450770] calling  software_resume+0x0/0x280 @ 1
[   13.455705] PM: Hibernation image not present or could not be loaded.
[   13.462335] initcall software_resume+0x0/0x280 returned -2 after 6480 =
usecs
[   13.469732] async_waiting @ 1
[   13.472800] async_continuing @ 1 after 0 usec
[   13.477560] Freeing unused kernel memory: 940K (c185e000 - c1949000)
[   13.484151] Write protecting the kernel text: 6272k
[   13.489222] Write protecting the kernel read-only data: 1856k
[   13.495139] NX-protecting the kernel data: 3968k
[   13.621399] mv (1274) used greatest stack depth: 6668 bytes left
[   13.646077] load_xen_module (1292) used greatest stack depth: 6272 byt=
es left
[   13.656401] udevd (1296): /proc/1296/oom_adj is deprecated, please use=
 /proc/1296/oom_score_adj instead.
[   13.692556] calling  acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] @ 133=
5
[   13.699827] calling  acpi_wmi_init+0x0/0x1000 [wm715042] initcall acpi=
_wmi_init+0x0/0x1000 [wmi] returned 0 after 3656 usecs
[   13.738183] calling  skge_init_module+0x0/0x1000 [skge] @ 1421
[   13.744378] skge: 1.14 addr 0xfebfc000 irq 4 chip Yukon reubsystem ini=
tialized
[   13.760892] initcall init_scsi+0x0/0x90 [scsi_mod] returned 0 after 15=
127 usecs
[   13.774737] initcall skge_init_module+0x0/0x1000 [skge] returned 0 aft=
er 29852 usecs
[   13.775097] calling  rtl8169_pci_driver_init+0x0/0x1000 [r8169] @ 1444
[   13.775162] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   13.775221] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have AS=
PM control
[   13.775467] r8169 0000:02:00.0: irq 26 for MSI/MSI-X
[   13.776823] r8169 0000:02:00.0 eth1: RTL8168c/8111c at 0xf8412000, 00:=
25:11:18:a1:2e, XID 1c4000c0 IRQ 26
[   13.776825] r8169 0000:02:00.0 eth1: jumbo features [frames: 6128 byte=
s, tx checksumming: ko]
[   13.776971] initcall rtl8169_pci_driver_init+0x0/0x1000 [r8169] return=
ed 0 after 1828 usecs
[   13.836808] calling  drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper]=
 @ 1409
[   13.844331] modprobe (1444) used greatest stack depth: 6132 bytes left
[   13.852630] calling  ata_init+0x0/0x295 [libata] @ 1412
[   13.861497] libata version 3.00 loaded.
[   13.865457] initcall ata_init+0x0/0x295 [libata] returned 0 after 7264=
 usecs
[  _generic_pci_driver_init+0x0/0x1000 [ata_generic] returned 0 after 231=
 usecs
[   13.892300] calling  ahci_pci_driver_init+0x0/0x1000 [ahci] @ 1412
[   13.898739] ahci 0000:00:11.0: version 3.0
[   13.903245] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps =
0x3f impl SATA mode
[   13.911671] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo p=
mp pio slum part ccc=20
[   13.924310] ip (1881) used greatest stack depth: 6092 bytes left
[   13.928177] scsi0 : ahci
[   13.934167] scsi1 : ahci
[   13.939830] scsi2 : ahci
[   13.943867] scsi3 : ahci
[   13.947777] scsi4 : ahci
[   13.949087] initcall drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper]=
 returned 0 after 102550 usecs
[   13.961787] calling  ttm_init+0x0/0x1000 [ttm] @ 1409
[   13.962756] scsi5 : ahci
[   13.963616] ata1: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
d00 irq 15
[   13.963618] ata2: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
d80 irq 15
[   13.963621] ata3: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
e00 irq 15
[   13.963623] ata4: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
e80 irq 15
[   13.963626] ata5: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
f00 irq 15
[   13.963629] ata6: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ff=
f80 irq 15
[   13.963867] ahci 0000:03:00.0: JMB361 has only one port
[   13.963881] ahci 0000:03:00.0: forcing port_map 0x3 -> 0x1
[   13.963985] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps =
0x1 impl SATA mode
[   13.963987] ahci 0000:03:00.0: flags: 64bit ncq led clo pmp pio=20
[   13.974866] scsi6 : ahci
[   13.975894] scsi7 : ahci
[   13.976737] ata7: SATA max UDMA/133 abar m8192@0xfeafe000 port 0xfeafe=
100 irq 11
[   13.976738] ata8: DUMMY
[   13.976897] initcall ahci_pci_driver_init+0x0/0x1000 [ahci] returned 0=
 after 76466 usecs
[   14.064619] initcall ttm_init+0x0/0x1000 [ttm] returned 0 after 178 us=
ecs
[   14.072073] calling  fb_console_init+0x0/0x1000 [fbcon] @ 2176
[   14.078404] initcall fb_console_init+0x0/0x1000 [fbcon] returned 0 aft=
er 234 usecs
[   14.088771] calling  radeon_init+0x0/0xb0 [radeon] @ 1409
[   14.094329] [drm] radeon kernel modesetting enabled.
[   14.100716] [drm] initializing kernel modesetting (RS780 0x1002:0x9610=
 0x1019:0x2119).
[   14.108898] [drm] register mmio base: 0xFE8F0000
[   14.113651] [drm] register mmio size: 65536
[   14.119203] ATOM BIOS: 113
[   14.122106] radeon 0000:01:05.0: VRAM: 256M 0x00000000C0000000 - 0x000=
00000CFFFFFFF (256M used)
[   14.131060] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x0000=
0000BFFFFFFF
[   14.138853] [drm] Detected VRAM RAM=3D256M, BAR=3D256M
[   14.143783] [drm] RAM width 32bits DDR
[   14.148030] [TTM] Zone  kernel: Available graphics memory: 432674 kiB
[   14.154765] [TTM] Zone highmem: Available graphics memory: 1941382 kiB
[   14.161485] [TTM] Initializing pool allocator
[   14.166069] [TTM] Initializing DMA pool allocator
[   14.171125] [drm] radeon: 256M of VRAM memory ready
[   14.176158] [drm] radeon: 512M of GTT memory ready.
[   14.181370] [drm] Loading RS780 Microcode
[   14.186023] [drm] radeon: power management initialized
[   14.191320] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   14.208700] [drm] PCIE GART of 512M enabled (table at 0x00000000C00400=
00).
[   14.215892] radeon 0000:01:05.0: WB enabled
[ver on ring 0 use gpu addr 0x00000000a0000c00 and cpu addr 0xffc89c00
[   14.230590] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013)=
.
[   14.237397] [drm] Driver supports precise vblank timestamp query.
[   14.243710] [drm] radeon: irq initialized.
[   14.253092] random: nonblocking pool is initialized
[   14.276550] ata6: SATA link down (SStatus 0 SControl 300)
[   14.282ATA link down (SStatus 0 SControl 300)
[   14.282309] ata5: SATA link down (SStatus 0 SControl 300)
[   14.282549] [drm] ring test on 0 succeeded in 0 usecs
[   14.282832] [drm] ib test on ring 0 succeeded in 0 usecs
[   14.285971] [drm] Radeon Display Connectors
[   14.285972] [drm] Connector 0:
[   14.285972] [drm]   VGA-1
[   14.285973] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7=
e4c 0x7e4c
[   14.285973] [drm]   Encoders:
[   14.285974] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   14.285974] [drm] Connector 1:
[   14.285975] [drm]   HDMI-A-1
[   14.285975] [drm]   HPD3
[   14.285976] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7=
e5c 0x7e5c
[   14.285976] [drm]   Encoders:
[   14.285976] [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[   14.353838] ata3: SATA link down (SStatus 0 SControl 300)
[   14.356123] radeon 0000:01:05.0: No connectors reported connected with=
 modes
[   14.356149] [drm] Cannot find any crtc or sizes - going 1024x768
[   14.373053] ata4: SATA link down (SStatus 0 SControl 300)
[   14.381061] [drm] fb mappable at 0xD0141000
[   14.385371] [drm] vram apper at 0xD0000000
[   14.389591] [drm] size 3145728
[   14.392736] [drm] fb depth is 24
[   14.396062] [drm]    pitch is 4096
[   14.400196] fbcon: radeondrmfb (fb0) is primary device
[   14.418905] Console: switching to colour frame buffer device 128x48
[   14.427344] ata1: softreset failed (device not ready)
[   14.427369] ata1: applying PMP SRST workaround and retrying
[   14.458455] radeon 0000:01:05.0: fb0: radeondrmfb frame buffer device
[   14.465089] radeon 0000:01:05.0: registered panic notifier
[   14.475699] [drm] Initialized radeon 2.39.0 20080528 for 0000:01:05.0 =
on minor 0
[   14.483508] initcall radeon_init+0x0/0xb0 [radeon] returned 0 after 38=
0392 usecs
[   14.491524] modprobe (1409) used greatest stack depth: 5436 bytes left
[   14.531261] ata2: softreset failed (device not ready)
[   14.536467] ata2: applying PMP SRST workaround and retrying
[   14.582259] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   14.697252] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   19.583468] ata1.00: qc timeout (cmd 0xec)
[   19.587699] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[   19.698344] ata2.00: qc timeout (cmd 0xec)
[   19.702581] ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[   20.053188] ata1: softreset failed (device not ready)
[   20.058397] ata1: applying PMP SRST workaround and retrying
[   20.167911] ata2: softreset failed (device not ready)
[   20.173127] ata2: applying PMP SRST workaround and retrying
[   20.218913] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   20.333943] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   21.132511] irq 18: nobody cared (try booting with the "irqpoll" optio=
n)
[   21.139409] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.16.0-rc5upstre=
am-00060-g8e655983b #1
[   21.148094] Hardware name: ECS A780GM-A Ultra/A780GM-A Ultra, BIOS 080=
015  04/01/2010
[   21.156152]  ef29fe1c f02bff50 c1618506 ef29fdc0 f02bff70 c10e1627 c17=
41d0c 00000012
[   21.164190]  c18345e0 00000001 ef29fdc0 00000000 f02bff94 c10e18a2 000=
00012 d5d864e1
[   21.172226]  00000033 f02cfe40 ef29fdc0 00000000 f74573c0 f02bffd0 c10=
df42e c10df42e
[   21.180261] Call Trace:
[   21.182777]  [<c1618506>] dump_stack+0x48/0x60
[   21.187350]  [<c10e1627>] __report_bad_irq+0x27/0xc0
[   21.192459]  [<c10e18a2>] note_interrupt+0x1e2/0x230
[   21.197568]  [<c10df42e>] handle_irq_event_percpu+0x9e/0x1c0
[   21.203391]  [<c10df42e>] ? handle_irq_event_percpu+0x9e/0x1c0
[   21.209393]  [<c10df587>] handle_irq_event+0x37/0x60
[   21.214500]  [<c10e2028>] handle_fasteoi_irq+0x58/0xf0
[   21.219788]  [<c10e1fd0>] ? handle_percpu_irq+0x50/0x50
[   21.225165]  [<c1046cfa>] handle_irq+0x9a/0xd0
[   21.229734]  <IRQ>  [<c104618d>] do_IRQ+0x3d/0xd0
[   21.234590]  [<c1074b56>] ? lapic_next_event+0x16/0x20
[   21.239881]  [<c10f107a>] ? clockevents_program_event+0xca/0x190
[   21.246062]  [<c161d96c>] common_interrupt+0x2c/0x34
[   21.251171]  [<c1081a65>] ? native_safe_halt+0x5/0x10
[   21.256369]  [<c104e457>] default_idle+0x17/0xb0
[   21.261119]  [<c104e55f>] amd_e400_idle+0x6f/0xf0
[   21.265958]  [<c104dd79>] arch_cpu_idle+0x9/0x10
[   21.270710]  [<c10cf957>] cpu_startup_entry+0x247/0x3a0
[   21.276087]  [<c1073c7c>] start_secondary+0x18c/0x200
[   21.281284] handlers:
[   21.283619] [<c1471340>] usb_hcd_irq
[   21.287302] [<c1471340>] usb_hcd_irq
[   21.290986] [<c1471340>] usb_hcd_irq
[   21.294668] Disabling IRQ #18
[   30.215459] ata1.00: qc timeout (cmd 0xec)
[   30.219685] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[   30.2259 speed to 1.5 Gbps
[   30.330480] ata2.00: qc timeout (cmd 0xec)
[   30.334706] ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[   30.3409[   30.689984] ata1: softreset failed (device not ready)
[   30.695184] ata1: applying PMP SRST workaround and retrying
[   30.805876] ata2: softreset failed (device not ready)
[   30.811079] ata2: applying PMP SRST workaround and retrying
[   30.855004] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   30.970916] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)

--cNdxnHkX5QqsyA0e--
