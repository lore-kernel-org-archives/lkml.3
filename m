Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaJSJHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 05:07:30 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:38278 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaJSJHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 05:07:25 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Oct 2014 05:07:25 EDT
Date: Sun, 19 Oct 2014 11:00:43 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <18410272607.20141019110043@eikelenboom.it>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: xen-devel <xen-devel@lists.xenproject.org>, linux-kernel@vger.kernel.org
Subject: Kernel 3.18-mergewindow: Early boot panic under Xen  BUG: unable to handle kernel paging request at ....  xen_clocksource_read+0x4/0x20
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Tried to test a 3.18 mergewindow kernel today, but under Xen it panics very early on boot.
See below for the splat.
Kernel is based on Linus his tree, last commit is: 9272f2dc3956c6b6c4335de51bc897fa3b981584

--
Sander

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-mw-20141018-pcidebug-a+ (root@serveerstertje) (gcc version 4.7.2 (Debian 4.7.2-5) ) #1 SMP Sat Oct 18 23:35:48 CEST 2014
[    0.000000] Command line: root=/dev/mapper/serveerstertje-root ro verbose earlyprintk=xen mem=1536M console=hvc0 console=tty0 vga=794 video=vesafb r8169.use_dac=1 acpi_enforce_resources=lax max_loop=30 loop_max_part=10 debug loglevel=10 nomodeset xen-pciback.hide=(03:06.0)(04:00.*)(07:00.*)(08:00.*)(09:00.*)(0a:00.0)(0b:00.0)(0e:00.*) r8169.use_dac=1 acpi.debug_layer=0x400000 acpi.debug_level=0x4
[    0.000000] Set 128975063 page(s) to 1-1 mapping
[    0.000000] Remapped 103 page(s), last_pfn=393319
[    0.000000] Released 0 page(s)
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x0000000000098fff] usable
[    0.000000] Xen: [mem 0x0000000000099400-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x0000000060066fff] usable
[    0.000000] Xen: [mem 0x0000000060067000-0x000000009ff8ffff] unusable
[    0.000000] Xen: [mem 0x000000009ff90000-0x000000009ff9dfff] ACPI data
[    0.000000] Xen: [mem 0x000000009ff9e000-0x000000009ffdffff] ACPI NVS
[    0.000000] Xen: [mem 0x000000009ffe0000-0x000000009fffffff] reserved
[    0.000000] Xen: [mem 0x00000000f6000000-0x00000000f6003fff] reserved
[    0.000000] Xen: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] Xen: [mem 0x00000000fec20000-0x00000000fec20fff] reserved
[    0.000000] Xen: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] Xen: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] Xen: [mem 0x0000000100000000-0x000000055fffffff] unusable
[    0.000000] Xen: [mem 0x000000fd00000000-0x000000ffffffffff] reserved
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000000000-0x0000000000098fff] usable
[    0.000000] user: [mem 0x0000000000099400-0x00000000000fffff] reserved
[    0.000000] user: [mem 0x0000000000100000-0x000000005fffffff] usable
[    0.000000] user: [mem 0x0000000060067000-0x000000009ff8ffff] unusable
[    0.000000] user: [mem 0x000000009ff90000-0x000000009ff9dfff] ACPI data
[    0.000000] user: [mem 0x000000009ff9e000-0x000000009ffdffff] ACPI NVS
[    0.000000] user: [mem 0x000000009ffe0000-0x000000009fffffff] reserved
[    0.000000] user: [mem 0x00000000f6000000-0x00000000f6003fff] reserved
[    0.000000] user: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] user: [mem 0x00000000fec20000-0x00000000fec20fff] reserved
[    0.000000] user: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] user: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] user: [mem 0x0000000100000000-0x000000055fffffff] unusable
[    0.000000] user: [mem 0x000000fd00000000-0x000000ffffffffff] reserved
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS V1.8B1 09/13/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x60000 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000093000] 93000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x5fe00000-0x5fffffff]
[    0.000000]  [mem 0x5fe00000-0x5fffffff] page 4k
[    0.000000] BRK [0x0321c000, 0x0321cfff] PGTABLE
[    0.000000] BRK [0x0321d000, 0x0321dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x5c000000-0x5fdfffff]
[    0.000000]  [mem 0x5c000000-0x5fdfffff] page 4k
[    0.000000] BRK [0x0321e000, 0x0321efff] PGTABLE
[    0.000000] BRK [0x0321f000, 0x0321ffff] PGTABLE
[    0.000000] BRK [0x03220000, 0x03220fff] PGTABLE
[    0.000000] BRK [0x03221000, 0x03221fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x5bffffff]
[    0.000000]  [mem 0x00100000-0x5bffffff] page 4k
[    0.000000] RAMDISK: [mem 0x04000000-0x04f34fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FB100 000014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 0x000000009FF90000 000048 (v01 MSI    OEMSLIC  20100913 MSFT 00000097)
[    0.000000] ACPI: FACP 0x000000009FF90200 000084 (v01 7640MS A7640100 20100913 MSFT 00000097)
[    0.000000] ACPI: DSDT 0x000000009FF905E0 009427 (v01 A7640  A7640100 00000100 INTL 20051117)
[    0.000000] ACPI: FACS 0x000000009FF9E000 000040
[    0.000000] ACPI: APIC 0x000000009FF90390 000088 (v01 7640MS A7640100 20100913 MSFT 00000097)
[    0.000000] ACPI: MCFG 0x000000009FF90420 00003C (v01 7640MS OEMMCFG  20100913 MSFT 00000097)
[    0.000000] ACPI: SLIC 0x000000009FF90460 000176 (v01 MSI    OEMSLIC  20100913 MSFT 00000097)
[    0.000000] ACPI: OEMB 0x000000009FF9E040 000072 (v01 7640MS A7640100 20100913 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x000000009FF9A5E0 000108 (v03 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: HPET 0x000000009FF9A6F0 000038 (v01 7640MS OEMHPET  20100913 MSFT 00000097)
[    0.000000] ACPI: IVRS 0x000000009FF9A730 000110 (v01 AMD    RD890S   00202031 AMD  00000000)
[    0.000000] ACPI: SSDT 0x000000009FF9A840 000DA4 (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] NUMA turned off
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000005fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x5fd18000-0x5fd22fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00098fff]
[    0.000000]   node   0: [mem 0x00100000-0x5fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x5fffffff]
[    0.000000] On node 0 totalpages: 393112
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3992 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6080 pages used for memmap
[    0.000000]   DMA32 zone: 389120 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 6, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec20000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 7, version 33, address 0xfec20000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] smpboot: Allowing 6 CPUs, 0 hotplug CPUs
[    0.000000] e820: [mem 0xa0000000-0xf5ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.5-unstable (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:6 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff88005f600000 s82560 r8192 d32128 u262144
[    0.000000] pcpu-alloc: s82560 r8192 d32128 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - - 
[    0.000000] xen: PV spinlocks enabled
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 386947
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/mapper/serveerstertje-root ro verbose earlyprintk=xen mem=1536M console=hvc0 console=tty0 vga=794 video=vesafb r8169.use_dac=1 acpi_enforce_resources=lax max_loop=30 loop_max_part=10 debug loglevel=10 nomodeset xen-pciback.hide=(03:06.0)(04:00.*)(07:00.*)(08:00.*)(09:00.*)(0a:00.0)(0b:00.0)(0e:00.*) r8169.use_dac=1 acpi.debug_layer=0x400000 acpi.debug_level=0x4
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] software IO TLB [mem 0x59c00000-0x5dc00000] (64MB) mapped at [ffff880059c00000-ffff88005dbfffff]
[    0.000000] Memory: 1424148K/1572448K available (11951K kernel code, 1075K rwdata, 4512K rodata, 1108K init, 14176K bss, 148300K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] BUG: unable to handle kernel paging request at 000000000000b0c0
[    0.000000] IP: [<ffffffff81009044>] xen_clocksource_read+0x4/0x20
[    0.000000] PGD 0 
[    0.000000] Oops: 0000 [#1] SMP 
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-mw-20141018-pcidebug-a+ #1
[    0.000000] Hardware name: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS V1.8B1 09/13/2010
[    0.000000] task: ffffffff8221c520 ti: ffffffff82200000 task.ti: ffffffff82200000
[    0.000000] RIP: e030:[<ffffffff81009044>]  [<ffffffff81009044>] xen_clocksource_read+0x4/0x20
[    0.000000] RSP: e02b:ffffffff82203e38  EFLAGS: 00010082
[    0.000000] RAX: ffffffff8221c630 RBX: ffffffff8221c520 RCX: ffff88005f60e360
[    0.000000] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffffffff8221c708
[    0.000000] RBP: ffffffff82203e38 R08: 0000000000000000 R09: ffffffff8221c6c8
[    0.000000] R10: 0000000000000000 R11: ffffffff82910680 R12: ffff88005f613500
[    0.000000] R13: 0000000000000000 R14: 00000000ffff00ff R15: 0000000000000000
[    0.000000] FS:  0000000000000000(0000) GS:ffff88005f600000(0000) knlGS:0000000000000000
[    0.000000] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.000000] CR2: 000000000000b0c0 CR3: 0000000002215000 CR4: 0000000000000660
[    0.000000] Stack:
[    0.000000]  ffffffff82203e48 ffffffff81017b25 ffffffff82203e98 ffffffff810eaa73
[    0.000000]  ffffffff82203e98 ffffffff810e617f ffffffff82203e98 ffffffff8221c520
[    0.000000]  0000000000000008 0000000000013500 0000000000000008 ffff88005f7535a8
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81017b25>] sched_clock+0x15/0x20
[    0.000000]  [<ffffffff810eaa73>] init_idle+0x53/0x180
[    0.000000]  [<ffffffff810e617f>] ? rq_attach_root+0x8f/0x110
[    0.000000]  [<ffffffff82340293>] sched_init+0x3d4/0x423
[    0.000000]  [<ffffffff82323e63>] start_kernel+0x229/0x458
[    0.000000]  [<ffffffff82323a27>] ? set_init_arg+0x58/0x58
[    0.000000]  [<ffffffff82323608>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff823270c8>] xen_start_kernel+0x5a8/0x5aa
[    0.000000] Code: ff eb c2 be 7c 00 00 00 48 c7 c7 43 1a f1 81 e8 f3 be 0b 00 e9 4d ff ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 <48> 8b 3d 75 20 00 7f 48 83 c7 20 65 48 03 3c 25 30 dd 00 00 e8 
[    0.000000] RIP  [<ffffffff81009044>] xen_clocksource_read+0x4/0x20
[    0.000000]  RSP <ffffffff82203e38>
[    0.000000] CR2: 000000000000b0c0
[    0.000000] ---[ end trace 0cfdd17856aba683 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
(XEN) [2014-10-19 08:29:42.209] Domain 0 crashed: rebooting machine in 5 seconds.


RIP points to:
/usr/src/new/linux-tip/arch/x86/xen/time.c:161

which comes down to:
cycle_t xen_clocksource_read(void)
{
        struct pvclock_vcpu_time_info *src;
        cycle_t ret;

        preempt_disable_notrace();
        src = this_cpu_ptr(&xen_vcpu->time);   <--- RIP
        ret = pvclock_clocksource_read(src);
        preempt_enable_notrace();
        return ret;
}


