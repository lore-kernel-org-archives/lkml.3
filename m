Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965968Ab3E2Mnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:43:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:61611 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965812Ab3E2Mnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:43:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,764,1363158000"; 
   d="log'?scan'208";a="341934682"
Date: Wed, 29 May 2013 19:10:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: WARNING: at drivers/media/v4l2-core/videobuf2-core.c:2065
 vb2_queue_init()
Message-ID: <20130529111035.GA18917@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 6aa69f99b2ecc7f9b387fcf22d30e6601b58819f
Author: Kamil Debski <k.debski@samsung.com>
Date:   Fri Jan 25 06:29:57 2013 -0300

    [media] vb2: Add support for non monotonic timestamps
    
    Not all drivers use monotonic timestamps. This patch adds a way to set the
    timestamp type per every queue.
    In addition, set proper timestamp type in drivers that I am sure that use
    either MONOTONIC or COPY timestamps. Other drivers will correctly report
    UNKNOWN timestamp type instead of assuming that all drivers use monotonic
    timestamps.
    
    Signed-off-by: Kamil Debski <k.debski@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

[   21.139201] Colour QuickCam for Video4Linux v0.06
[   21.662974] ------------[ cut here ]------------
[   21.664255] WARNING: at /c/kernel-tests/src/linux/drivers/media/v4l2-core/videobuf2-core.c:2065 vb2_queue_init+0xe5/0x1c0()
[   21.667066] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00088-g459e3a1 #11
[   21.668980] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007

git bisect start 459e3a152aa809827367f5486e179cbabebb6877 v3.9 --
git bisect  bad 73287a43cc79ca06629a88d1a199cd283f42456a  #     0  2013-05-29 16:45:09  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good 5d434fcb255dec99189f1c58a06e4f56e12bf77d  #    10  2013-05-29 16:49:30  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
git bisect good 91bc033c4d01656e3d8e45a13fd58924a3099693  #    10  2013-05-29 16:53:47  bridge: avoid OOPS if root port not found
git bisect  bad 165bc513f7ec54d3fa3660f5c851c4bbc533d577  #     0  2013-05-29 16:57:05  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
git bisect  bad b12f7dd51abf419b9279f3ff2fdc3c06fe50c10f  #     0  2013-05-29 16:59:52  [media] tw9906: Remove unneeded version.h header include
git bisect  bad 05f0ffbc487517a529c00119d0bfde33df509b52  #     0  2013-05-29 17:02:32  [media] siano: use USB endpoint descriptors for in/out endp
git bisect good 2aeb73e19dc3d17beebc1b9a678f4c60e1072e25  #    10  2013-05-29 17:14:08  [media] stk-webcam: add ASUS F3JC to upside-down list
git bisect  bad f1065c964869aecd5af04291476c358fd5ab9a8f  #     0  2013-05-29 17:19:27  [media] media: tuners: Remove redundant NULL check before kfree
git bisect  bad 39696009d0d4472606b7fb90fc635a0d0fecba60  #     0  2013-05-29 17:23:10  [media] s2255: add device_caps support to querycap
git bisect  bad 69b95a3a80b44ebb71bf153e79bcb8580e1d3de5  #     0  2013-05-29 17:26:27  [media] s3c-camif: Fail on insufficient number of allocated buffers
git bisect good 8407653f5e2b9805958e0a392c0411ce027a3934  #    10  2013-05-29 17:44:16  [media] stk-webcam: zero the priv field of v4l2_pix_format
git bisect good f81e372a5d11694b86fc35ded379a441c209b920  #    10  2013-05-29 18:02:13  [media] stk-webcam: s_fmt shouldn't grab ownership
git bisect good 53bf0f446bc387eabdd535dca080789cc74607f4  #    10  2013-05-29 18:19:30  [media] v4l: Define video buffer flag for the COPY timestamp type
git bisect  bad 6aa69f99b2ecc7f9b387fcf22d30e6601b58819f  #     0  2013-05-29 18:27:33  [media] vb2: Add support for non monotonic timestamps
git bisect good 53bf0f446bc387eabdd535dca080789cc74607f4  #    30  2013-05-29 18:39:26  [media] v4l: Define video buffer flag for the COPY timestamp type
git bisect  bad 459e3a152aa809827367f5486e179cbabebb6877  #     0  2013-05-29 18:40:46  Merge remote-tracking branch 'tip/x86/urgent' into devel-snb-i386-2013-05-29-07-09
git bisect  bad 1ca94a12e6c269b0dfc10424c27ff295b3420e9c  #     0  2013-05-29 18:53:54  Add linux-next specific files for 20130529

Thanks,
Fengguang

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-athens-31396-2013-05-29-07-27-53-3.10.0-rc3-00088-g459e3a1-11"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc3-00088-g459e3a1 (kbuild@snb) (gcc version 4.7.2 (Debian 4.7.2-4) ) #11 SMP Wed May 29 07:28:31 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [b00fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [b008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x0227b000, 0x0227bfff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128028(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x0227c000, 0x0227cfff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000] free_area_init_node: node 0, pgdat b1bcbac0, node_mem_map bdd3f020
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65424 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @bdd2b000 s27936 r0 d13024 u40960
[    0.000000] pcpu-alloc: s27936 r0 d13024 u40960 alloc=10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dd2d5c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64912
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=linux-devel/devel-snb-i386-2013-05-29-07-09 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-s10-0529/459e3a152aa809827367f5486e179cbabebb6877/.vmlinuz-2013-05-29-07-29-30-devel-snb-i386-2013-05-29-07-09:459e3a152aa809827367f5486e179cbabebb6877-459e3a152aa809827367f5486e179cbabebb6877-i386-randconfig-s10-0529-4-athens  BOOT_IMAGE=/kernel/i386-randconfig-s10-0529/459e3a152aa809827367f5486e179cbabebb6877/vmlinuz-3.10.0-rc3-00088-g459e3a1
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 206852k/262136k available (8774k kernel code, 54844k reserved, 3332k data, 584k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6c000 - 0xfffff000   (1612 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xc07fe000 - 0xff7fe000   (1008 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xbfffe000   ( 255 MB)
[    0.000000]       .init : 0xb1bd3000 - 0xb1c65000   ( 584 kB)
[    0.000000]       .data : 0xb1891935 - 0xb1bd2960   (3332 kB)
[    0.000000]       .text : 0xb1000000 - 0xb1891935   (8774 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=b0016000 soft=b0018000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ODEBUG: 6 of 6 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.988 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5788.05 BogoMIPS (lpj=9643293)
[    0.007689] pid_max: default: 32768 minimum: 301
[    0.010334] Security Framework initialized
[    0.011924] Mount-cache hash table entries: 512
[    0.014881] Initializing cgroup subsys debug
[    0.016698] Initializing cgroup subsys devices
[    0.018316] Initializing cgroup subsys blkio
[    0.020206] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020206] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020206] tlb_flushall_shift: 6
[    0.027074] Freeing SMP alternatives: 28k freed
[    0.034150] ACPI: Core revision 20130328
[    0.057523] ACPI: All ACPI Tables successfully acquired
[    0.060168] Getting VERSION: 50014
[    0.061355] Getting VERSION: 50014
[    0.062607] Getting ID: 0
[    0.063361] Getting ID: f000000
[    0.064518] Getting LVT0: 8700
[    0.065601] Getting LVT1: 8400
[    0.066680] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.068691] enabled ExtINT on CPU#0
[    0.071888] ENABLING IO-APIC IRQs
[    0.073353] init IO_APIC IRQs
[    0.074350]  apic 2 pin 0 not connected
[    0.075671] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.076740] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.080069] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.083391] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.086727] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.090063] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.093398] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.096215] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.096728] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.100060] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.103395] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.106739] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.110066] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.113392] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.116739] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.119285]  apic 2 pin 16 not connected
[    0.120008]  apic 2 pin 17 not connected
[    0.121348]  apic 2 pin 18 not connected
[    0.123341]  apic 2 pin 19 not connected
[    0.124703]  apic 2 pin 20 not connected
[    0.126061]  apic 2 pin 21 not connected
[    0.126676]  apic 2 pin 22 not connected
[    0.128100]  apic 2 pin 23 not connected
[    0.130214] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.133342] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.137412] Using local APIC timer interrupts.
[    0.137412] calibrating APIC timer ...
[    0.143333] ... lapic delta = 6248953
[    0.143333] ... PM-Timer delta = 357890
[    0.143333] ... PM-Timer result ok
[    0.143333] ..... delta 6248953
[    0.143333] ..... mult: 268390514
[    0.143333] ..... calibration result: 3332774
[    0.143333] ..... CPU clock speed is 2892.2715 MHz.
[    0.143333] ..... host bus clock speed is 999.3107 MHz.
[    0.143484] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.150413] SMP alternatives: lockdep: fixing up alternatives
[    0.153377] CPU 1 irqstacks, hard=b015e000 soft=b0168000
[    0.156680] smpboot: Booting Node   0, Processors  #1 OK
[    0.003333] Initializing CPU#1
[    0.006666] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.180263] Brought up 2 CPUs
[    0.180175] KVM setup async PF for cpu 1
[    0.180175] kvm-stealtime: cpu 1, msr dd375c0
[    0.183341] smpboot: Total of 2 processors activated (11576.11 BogoMIPS)
[    0.188002] CPU0 attaching sched-domain:
[    0.190008]  domain 0: span 0-1 level CPU
[    0.191405]   groups: 0 1
[    0.193354] CPU1 attaching sched-domain:
[    0.194711]  domain 0: span 0-1 level CPU
[    0.196104]   groups: 1 0
[    0.198493] devtmpfs: initialized
[    0.200036] device: 'platform': device_add
[    0.201475] PM: Adding info for No Bus:platform
[    0.202958] bus: 'platform': registered
[    0.203449] bus: 'cpu': registered
[    0.204559] device: 'cpu': device_add
[    0.206801] PM: Adding info for No Bus:cpu
[    0.209977] EVM: security.capability
[    0.210663] bus: 'workqueue': registered
[    0.212064] device: 'workqueue': device_add
[    0.213403] PM: Adding info for No Bus:workqueue
[    0.220208] xor: measuring software checksum speed
[    0.253344]    pIII_sse  :  8413.200 MB/sec
[    0.286677]    prefetch64-sse:  9212.400 MB/sec
[    0.288214] xor: using function: prefetch64-sse (9212.400 MB/sec)
[    0.290145] bus: 'virtio': registered
[    0.291337] device class 'regulator': registering
[    0.293346] Registering platform device 'reg-dummy'. Parent at platform
[    0.295481] device: 'reg-dummy': device_add
[    0.296698] bus: 'platform': add device reg-dummy
[    0.298329] PM: Adding info for platform:reg-dummy
[    0.300139] bus: 'platform': add driver reg-dummy
[    0.301668] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.303343] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.306817] device: 'regulator.0': device_add
[    0.308394] PM: Adding info for No Bus:regulator.0
[    0.310108] regulator-dummy: no parameters
[    0.311582] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.313364] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.316896] NET: Registered protocol family 16
[    0.318811] device class 'bdi': registering
[    0.320120] device class 'gpio': registering
[    0.321507] device class 'pci_bus': registering
[    0.323097] bus: 'pci': registered
[    0.323345] device class 'lcd': registering
[    0.324700] device class 'backlight': registering
[    0.326725] device class 'video_output': registering
[    0.328813] device class 'tty': registering
[    0.330606] ACPI: bus type PCI registered
[    0.332176] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.333340] PCI: Using configuration type 1 for base access
[    0.337104] device: 'cpu0': device_add
[    0.338379] bus: 'cpu': add device cpu0
[    0.339709] PM: Adding info for cpu:cpu0
[    0.340108] device: 'cpu1': device_add
[    0.341397] bus: 'cpu': add device cpu1
[    0.343405] PM: Adding info for cpu:cpu1
[    0.366126] device: 'writeback': device_add
[    0.366698] bus: 'workqueue': add device writeback
[    0.368366] PM: Adding info for workqueue:writeback
[    0.370168] device: 'default': device_add
[    0.371657] PM: Adding info for No Bus:default
[    0.373624] bio: create slab <bio-0> at 0
[    0.376860] device class 'block': registering
[    0.436693] raid6: mmxx1     2487 MB/s
[    0.493355] raid6: mmxx2     2773 MB/s
[    0.550017] raid6: sse1x1    2063 MB/s
[    0.606678] raid6: sse1x2    2728 MB/s
[    0.663354] raid6: sse2x1    4095 MB/s
[    0.720019] raid6: sse2x2    5133 MB/s
[    0.721381] raid6: using algorithm sse2x2 (5133 MB/s)
[    0.722993] raid6: using intx1 recovery algorithm
[    0.723496] device class 'graphics': registering
[    0.725264] ACPI: Added _OSI(Module Device)
[    0.726692] ACPI: Added _OSI(Processor Device)
[    0.728180] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.730020] ACPI: Added _OSI(Processor Aggregator Device)
[    0.735507] ACPI: EC: Look up EC in DSDT
[    0.775615] ACPI: Interpreter enabled
[    0.776695] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[    0.780030] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[    0.783092] ACPI: (supports S0 S3 S5)
[    0.783339] ACPI: Using IOAPIC for interrupt routing
[    0.784992] bus: 'acpi': registered
[    0.786676] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.790369] device: 'LNXSYSTM:00': device_add
[    0.791896] bus: 'acpi': add device LNXSYSTM:00
[    0.793430] PM: Adding info for acpi:LNXSYSTM:00
[    0.795955] device: 'device:00': device_add
[    0.796703] bus: 'acpi': add device device:00
[    0.798223] PM: Adding info for acpi:device:00
[    0.801143] device: 'PNP0A03:00': device_add
[    0.803381] bus: 'acpi': add device PNP0A03:00
[    0.804991] PM: Adding info for acpi:PNP0A03:00
[    0.812651] device: 'device:01': device_add
[    0.813372] bus: 'acpi': add device device:01
[    0.816710] PM: Adding info for acpi:device:01
[    0.820100] device: 'device:02': device_add
[    0.823371] bus: 'acpi': add device device:02
[    0.824917] PM: Adding info for acpi:device:02
[    0.827668] device: 'PNP0B00:00': device_add
[    0.829191] bus: 'acpi': add device PNP0B00:00
[    0.830102] PM: Adding info for acpi:PNP0B00:00
[    0.834715] device: 'PNP0303:00': device_add
[    0.836706] bus: 'acpi': add device PNP0303:00
[    0.838362] PM: Adding info for acpi:PNP0303:00
[    0.844294] device: 'PNP0F13:00': device_add
[    0.845797] bus: 'acpi': add device PNP0F13:00
[    0.846756] PM: Adding info for acpi:PNP0F13:00
[    0.851146] device: 'PNP0700:00': device_add
[    0.852627] bus: 'acpi': add device PNP0700:00
[    0.853432] PM: Adding info for acpi:PNP0700:00
[    0.862853] device: 'PNP0400:00': device_add
[    0.863380] bus: 'acpi': add device PNP0400:00
[    0.864936] PM: Adding info for acpi:PNP0400:00
[    0.870255] device: 'PNP0501:00': device_add
[    0.871739] bus: 'acpi': add device PNP0501:00
[    0.873362] PM: Adding info for acpi:PNP0501:00
[    0.877323] device: 'device:03': device_add
[    0.878733] bus: 'acpi': add device device:03
[    0.880087] PM: Adding info for acpi:device:03
[    0.882572] device: 'device:04': device_add
[    0.883371] bus: 'acpi': add device device:04
[    0.884970] PM: Adding info for acpi:device:04
[    0.887701] device: 'device:05': device_add
[    0.890036] bus: 'acpi': add device device:05
[    0.891682] PM: Adding info for acpi:device:05
[    0.894505] device: 'device:06': device_add
[    0.896004] bus: 'acpi': add device device:06
[    0.896760] PM: Adding info for acpi:device:06
[    0.900347] device: 'device:07': device_add
[    0.901765] bus: 'acpi': add device device:07
[    0.903367] PM: Adding info for acpi:device:07
[    0.905906] device: 'device:08': device_add
[    0.906700] bus: 'acpi': add device device:08
[    0.908232] PM: Adding info for acpi:device:08
[    0.911177] device: 'device:09': device_add
[    0.912691] bus: 'acpi': add device device:09
[    0.913425] PM: Adding info for acpi:device:09
[    0.917489] device: 'device:0a': device_add
[    0.919007] bus: 'acpi': add device device:0a
[    0.920095] PM: Adding info for acpi:device:0a
[    0.922732] device: 'device:0b': device_add
[    0.923368] bus: 'acpi': add device device:0b
[    0.924933] PM: Adding info for acpi:device:0b
[    0.927805] device: 'device:0c': device_add
[    0.930043] bus: 'acpi': add device device:0c
[    0.931619] PM: Adding info for acpi:device:0c
[    0.934430] device: 'device:0d': device_add
[    0.935954] bus: 'acpi': add device device:0d
[    0.936800] PM: Adding info for acpi:device:0d
[    0.941100] device: 'device:0e': device_add
[    0.942542] bus: 'acpi': add device device:0e
[    0.943426] PM: Adding info for acpi:device:0e
[    0.947126] device: 'device:0f': device_add
[    0.948572] bus: 'acpi': add device device:0f
[    0.950111] PM: Adding info for acpi:device:0f
[    0.953728] device: 'device:10': device_add
[    0.955138] bus: 'acpi': add device device:10
[    0.956715] PM: Adding info for acpi:device:10
[    0.959224] device: 'device:11': device_add
[    0.960037] bus: 'acpi': add device device:11
[    0.961603] PM: Adding info for acpi:device:11
[    0.964459] device: 'device:12': device_add
[    0.965909] bus: 'acpi': add device device:12
[    0.966756] PM: Adding info for acpi:device:12
[    0.972516] device: 'device:13': device_add
[    0.973372] bus: 'acpi': add device device:13
[    0.974955] PM: Adding info for acpi:device:13
[    0.977835] device: 'device:14': device_add
[    0.979266] bus: 'acpi': add device device:14
[    0.980101] PM: Adding info for acpi:device:14
[    0.983924] device: 'device:15': device_add
[    0.985371] bus: 'acpi': add device device:15
[    0.986763] PM: Adding info for acpi:device:15
[    0.989400] device: 'device:16': device_add
[    0.990036] bus: 'acpi': add device device:16
[    0.991610] PM: Adding info for acpi:device:16
[    0.994520] device: 'device:17': device_add
[    0.996703] bus: 'acpi': add device device:17
[    0.998354] PM: Adding info for acpi:device:17
[    1.001231] device: 'device:18': device_add
[    1.002746] bus: 'acpi': add device device:18
[    1.003429] PM: Adding info for acpi:device:18
[    1.007199] device: 'device:19': device_add
[    1.010045] bus: 'acpi': add device device:19
[    1.011642] PM: Adding info for acpi:device:19
[    1.014559] device: 'device:1a': device_add
[    1.016036] bus: 'acpi': add device device:1a
[    1.016754] PM: Adding info for acpi:device:1a
[    1.021040] device: 'device:1b': device_add
[    1.022554] bus: 'acpi': add device device:1b
[    1.023443] PM: Adding info for acpi:device:1b
[    1.027410] device: 'device:1c': device_add
[    1.030042] bus: 'acpi': add device device:1c
[    1.031574] PM: Adding info for acpi:device:1c
[    1.034305] device: 'device:1d': device_add
[    1.035730] bus: 'acpi': add device device:1d
[    1.036762] PM: Adding info for acpi:device:1d
[    1.039412] device: 'device:1e': device_add
[    1.040037] bus: 'acpi': add device device:1e
[    1.041533] PM: Adding info for acpi:device:1e
[    1.044436] device: 'device:1f': device_add
[    1.046703] bus: 'acpi': add device device:1f
[    1.048047] PM: Adding info for acpi:device:1f
[    1.050829] device: 'device:20': device_add
[    1.052207] bus: 'acpi': add device device:20
[    1.053430] PM: Adding info for acpi:device:20
[    1.055735] device: 'device:21': device_add
[    1.056704] bus: 'acpi': add device device:21
[    1.058229] PM: Adding info for acpi:device:21
[    1.061141] device: 'device:22': device_add
[    1.062593] bus: 'acpi': add device device:22
[    1.063424] PM: Adding info for acpi:device:22
[    1.070533] device: 'PNP0103:00': device_add
[    1.071959] bus: 'acpi': add device PNP0103:00
[    1.073426] PM: Adding info for acpi:PNP0103:00
[    1.077735] device: 'PNP0C0F:00': device_add
[    1.079263] bus: 'acpi': add device PNP0C0F:00
[    1.080087] PM: Adding info for acpi:PNP0C0F:00
[    1.084848] device: 'PNP0C0F:01': device_add
[    1.086230] bus: 'acpi': add device PNP0C0F:01
[    1.086763] PM: Adding info for acpi:PNP0C0F:01
[    1.091711] device: 'PNP0C0F:02': device_add
[    1.093196] bus: 'acpi': add device PNP0C0F:02
[    1.093431] PM: Adding info for acpi:PNP0C0F:02
[    1.098652] device: 'PNP0C0F:03': device_add
[    1.100038] bus: 'acpi': add device PNP0C0F:03
[    1.101649] PM: Adding info for acpi:PNP0C0F:03
[    1.105701] device: 'PNP0C0F:04': device_add
[    1.106718] bus: 'acpi': add device PNP0C0F:04
[    1.108262] PM: Adding info for acpi:PNP0C0F:04
[    1.110885] device: 'LNXCPU:00': device_add
[    1.112259] bus: 'acpi': add device LNXCPU:00
[    1.113417] PM: Adding info for acpi:LNXCPU:00
[    1.115778] device: 'LNXCPU:01': device_add
[    1.116705] bus: 'acpi': add device LNXCPU:01
[    1.118256] PM: Adding info for acpi:LNXCPU:01
[    1.120939] device: 'device:23': device_add
[    1.122382] bus: 'acpi': add device device:23
[    1.123423] PM: Adding info for acpi:device:23
[    1.125297] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.126876] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.130011] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.133342] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.135842] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    1.136702] PCI: root bus 00: using default resources
[    1.140055] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.143380] device: 'pci0000:00': device_add
[    1.144923] PM: Adding info for No Bus:pci0000:00
[    1.146699] device: '0000:00': device_add
[    1.148248] PM: Adding info for No Bus:0000:00
[    1.150076] PCI host bridge to bus 0000:00
[    1.151446] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.153158] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.153359] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    1.156806] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.160305] device: '0000:00:00.0': device_add
[    1.163502] bus: 'pci': add device 0000:00:00.0
[    1.165245] PM: Adding info for pci:0000:00:00.0
[    1.166860] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.169558] device: '0000:00:01.0': device_add
[    1.170206] bus: 'pci': add device 0000:00:01.0
[    1.173356] PM: Adding info for pci:0000:00:01.0
[    1.175175] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.180358] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    1.183205] device: '0000:00:01.1': device_add
[    1.185064] bus: 'pci': add device 0000:00:01.1
[    1.186929] PM: Adding info for pci:0000:00:01.1
[    1.190081] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.193033] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    1.193369] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    1.196839] device: '0000:00:01.3': device_add
[    1.198484] bus: 'pci': add device 0000:00:01.3
[    1.200231] PM: Adding info for pci:0000:00:01.3
[    1.203465] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.207393] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.211564] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    1.220759] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    1.223684] device: '0000:00:02.0': device_add
[    1.225504] bus: 'pci': add device 0000:00:02.0
[    1.226984] PM: Adding info for pci:0000:00:02.0
[    1.228964] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    1.231161] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    1.234339] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    1.242375] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    1.243701] device: '0000:00:03.0': device_add
[    1.247078] bus: 'pci': add device 0000:00:03.0
[    1.248804] PM: Adding info for pci:0000:00:03.0
[    1.250148] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    1.253343] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    1.256291] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    1.262923] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    1.263502] device: '0000:00:04.0': device_add
[    1.267116] bus: 'pci': add device 0000:00:04.0
[    1.268880] PM: Adding info for pci:0000:00:04.0
[    1.270208] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.273878] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    1.276679] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    1.284688] device: '0000:00:05.0': device_add
[    1.286740] bus: 'pci': add device 0000:00:05.0
[    1.288455] PM: Adding info for pci:0000:00:05.0
[    1.290294] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.293345] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    1.296152] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    1.303687] device: '0000:00:06.0': device_add
[    1.305674] bus: 'pci': add device 0000:00:06.0
[    1.306900] PM: Adding info for pci:0000:00:06.0
[    1.308577] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.311207] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.314375] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    1.322981] device: '0000:00:07.0': device_add
[    1.323942] bus: 'pci': add device 0000:00:07.0
[    1.326904] PM: Adding info for pci:0000:00:07.0
[    1.328714] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.331181] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    1.334386] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    1.342460] device: '0000:00:08.0': device_add
[    1.344000] bus: 'pci': add device 0000:00:08.0
[    1.346684] PM: Adding info for pci:0000:00:08.0
[    1.348509] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.351191] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    1.354375] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    1.362419] device: '0000:00:09.0': device_add
[    1.364015] bus: 'pci': add device 0000:00:09.0
[    1.365748] PM: Adding info for pci:0000:00:09.0
[    1.366877] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    1.371166] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    1.373886] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    1.383701] device: '0000:00:0a.0': device_add
[    1.386026] bus: 'pci': add device 0000:00:0a.0
[    1.386929] PM: Adding info for pci:0000:00:0a.0
[    1.388624] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    1.390620] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    1.397935] device: '0000:00:0b.0': device_add
[    1.400774] bus: 'pci': add device 0000:00:0b.0
[    1.403582] PM: Adding info for pci:0000:00:0b.0
[    1.405637] pci_bus 0000:00: on NUMA node 0
[    1.406696] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    1.416460] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.420112] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.423613] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.426937] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.430527] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    1.436724] device: 'LNXPWRBN:00': device_add
[    1.438149] bus: 'acpi': add device LNXPWRBN:00
[    1.439726] PM: Adding info for acpi:LNXPWRBN:00
[    1.443984] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.445674] acpi root: \_SB_.PCI0 notify handler is installed
[    1.446840] Found 1 acpi root devices
[    1.448118] bus: 'acpi': add driver ec
[    1.450599] bus: 'pnp': registered
[    1.451745] bus: 'platform': add driver reg-fixed-voltage
[    1.453436] bus: 'platform': add driver gpio-regulator
[    1.456817] device class 'misc': registering
[    1.458487] device: 'vga_arbiter': device_add
[    1.463420] PM: Adding info for No Bus:vga_arbiter
[    1.465161] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.466683] vgaarb: loaded
[    1.467614] vgaarb: bridge control possible 0000:00:02.0
[    1.471336] device class 'scsi_host': registering
[    1.476861] bus: 'scsi': registered
[    1.478108] device class 'scsi_device': registering
[    1.480032] SCSI subsystem initialized
[    1.481406] ACPI: bus type ATA registered
[    1.483384] device class 'ata_link': registering
[    1.486736] device class 'ata_port': registering
[    1.488361] device class 'ata_device': registering
[    1.490125] libata version 3.00 loaded.
[    1.491489] device class 'mdio_bus': registering
[    1.493512] bus: 'mdio_bus': registered
[    1.494932] bus: 'mdio_bus': add driver Generic PHY
[    1.496762] device class 'pcmcia_socket': registering
[    1.500077] bus: 'platform': add driver nop_usb_xceiv
[    1.501715] device class 'udc': registering
[    1.503512] bus: 'serio': registered
[    1.504712] device class 'input': registering
[    1.506785] media: Linux media interface: v0.10
[    1.508390] bus: 'media': registered
[    1.510009] Linux video capture interface: v2.00
[    1.513368] device class 'video4linux': registering
[    1.515178] device class 'pps': registering
[    1.516761] pps_core: LinuxPPS API ver. 1 registered
[    1.518497] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.520022] device class 'ptp': registering
[    1.523402] PTP clock support registered
[    1.526682] device class 'power_supply': registering
[    1.528455] device class 'hwmon': registering
[    1.530368] bus: 'mmc': registered
[    1.533346] device class 'mmc_host': registering
[    1.534918] bus: 'sdio': registered
[    1.536686] device class 'leds': registering
[    1.538047] device class 'devfreq': registering
[    1.543444] PCI: Using ACPI for IRQ routing
[    1.544813] PCI: pci_cache_line_size set to 64 bytes
[    1.547195] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.550039] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.552180] device class 'net': registering
[    1.553582] device: 'lo': device_add
[    1.555418] PM: Adding info for No Bus:lo
[    1.557582] NET: Registered protocol family 23
[    1.559337] device class 'ieee80211': registering
[    1.560433] Registering platform device 'regulatory.0'. Parent at platform
[    1.563348] device: 'regulatory.0': device_add
[    1.564808] bus: 'platform': add device regulatory.0
[    1.566778] PM: Adding info for platform:regulatory.0
[    1.570641] device class 'rfkill': registering
[    1.572174] device: 'rfkill': device_add
[    1.573769] cfg80211: Calling CRDA to update world regulatory domain
[    1.576858] PM: Adding info for No Bus:rfkill
[    1.578401] nfc: nfc_init: NFC Core ver 0.1
[    1.580008] device class 'nfc': registering
[    1.581642] NET: Registered protocol family 39
[    1.583872] Switching to clocksource kvm-clock
[    1.587287] bus: 'pnp': add driver system
[    1.588723] pnp: PnP ACPI init
[    1.589727] device: 'pnp0': device_add
[    1.590989] PM: Adding info for No Bus:pnp0
[    1.592316] ACPI: bus type PNP registered
[    1.593963] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    1.596656] device: '00:00': device_add
[    1.598056] bus: 'pnp': add device 00:00
[    1.599425] PM: Adding info for pnp:00:00
[    1.600818] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.603380] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    1.606052] device: '00:01': device_add
[    1.607451] bus: 'pnp': add device 00:01
[    1.608862] PM: Adding info for pnp:00:01
[    1.610216] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.612922] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    1.615686] device: '00:02': device_add
[    1.617100] bus: 'pnp': add device 00:02
[    1.618559] PM: Adding info for pnp:00:02
[    1.619982] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.622677] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    1.625331] pnp 00:03: [dma 2]
[    1.626337] device: '00:03': device_add
[    1.627721] bus: 'pnp': add device 00:03
[    1.629096] PM: Adding info for pnp:00:03
[    1.630389] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.633276] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    1.635894] device: '00:04': device_add
[    1.637300] bus: 'pnp': add device 00:04
[    1.638748] PM: Adding info for pnp:00:04
[    1.640256] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.643322] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    1.646212] device: '00:05': device_add
[    1.647666] bus: 'pnp': add device 00:05
[    1.649083] PM: Adding info for pnp:00:05
[    1.650477] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.654847] device: '00:06': device_add
[    1.656236] bus: 'pnp': add device 00:06
[    1.657803] PM: Adding info for pnp:00:06
[    1.659271] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.663799] pnp: PnP ACPI: found 7 devices
[    1.665246] ACPI: bus type PNP unregistered
[    1.666871] device class 'mem': registering
[    1.668274] device: 'mem': device_add
[    1.671630] PM: Adding info for No Bus:mem
[    1.673019] device: 'null': device_add
[    1.676622] PM: Adding info for No Bus:null
[    1.678153] device: 'port': device_add
[    1.681661] PM: Adding info for No Bus:port
[    1.683140] device: 'zero': device_add
[    1.686637] PM: Adding info for No Bus:zero
[    1.688127] device: 'full': device_add
[    1.691634] PM: Adding info for No Bus:full
[    1.693094] device: 'random': device_add
[    1.696609] PM: Adding info for No Bus:random
[    1.698090] device: 'urandom': device_add
[    1.700824] PM: Adding info for No Bus:urandom
[    1.702219] device: 'kmsg': device_add
[    1.705633] PM: Adding info for No Bus:kmsg
[    1.707113] device: 'tty': device_add
[    1.710636] PM: Adding info for No Bus:tty
[    1.712077] device: 'console': device_add
[    1.715609] PM: Adding info for No Bus:console
[    1.717259] device class 'thermal': registering
[    1.753797] bus: 'ssb': registered
[    1.755081] bus: 'bcma': registered
[    1.756244] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.758069] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    1.760183] NET: Registered protocol family 1
[    1.761682] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.763619] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.765522] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.767630] pci 0000:00:02.0: Boot video device
[    1.769319] PCI: CLS 0 bytes, default 64
[    1.771280] Trying to unpack rootfs image as initramfs...
[    3.646260] Freeing initrd memory: 25284k freed
[    3.880057] DMA-API: preallocated 65536 debug entries
[    3.881797] DMA-API: debugging enabled by kernel config
[    3.884758] device class 'msr': registering
[    3.886270] device: 'msr0': device_add
[    3.889661] PM: Adding info for No Bus:msr0
[    3.891226] device: 'msr1': device_add
[    3.894704] PM: Adding info for No Bus:msr1
[    3.896143] device class 'cpuid': registering
[    3.897744] device: 'cpu0': device_add
[    3.901705] PM: Adding info for No Bus:cpu0
[    3.903130] device: 'cpu1': device_add
[    3.906653] PM: Adding info for No Bus:cpu1
[    3.908152] apm: BIOS not found.
[    3.909248] Registering platform device 'pcspkr'. Parent at platform
[    3.911343] device: 'pcspkr': device_add
[    3.912670] bus: 'platform': add device pcspkr
[    3.914263] PM: Adding info for platform:pcspkr
[    3.931654] Registering platform device 'goldfish_pdev_bus'. Parent at platform
[    3.934233] device: 'goldfish_pdev_bus': device_add
[    3.936329] bus: 'platform': add device goldfish_pdev_bus
[    3.938289] PM: Adding info for platform:goldfish_pdev_bus
[    3.944941] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
[    3.947738] NatSemi SCx200 Driver
[    3.948686] bus: 'pci': add driver scx200
[    3.950372] bus: 'clocksource': registered
[    3.951807] device: 'clocksource': device_add
[    3.953427] PM: Adding info for No Bus:clocksource
[    3.954930] device: 'clocksource0': device_add
[    3.956226] bus: 'clocksource': add device clocksource0
[    3.957755] PM: Adding info for clocksource:clocksource0
[    3.959275] bus: 'platform': add driver alarmtimer
[    3.960695] Registering platform device 'alarmtimer'. Parent at platform
[    3.962583] device: 'alarmtimer': device_add
[    3.963796] bus: 'platform': add device alarmtimer
[    3.965120] PM: Adding info for platform:alarmtimer
[    3.966597] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    3.969466] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    3.971845] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    3.973853] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    3.976309] audit: initializing netlink socket (disabled)
[    3.978391] type=2000 audit(1369783648.976:1): initialized
[    3.980741] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
[    4.005142] bus: 'event_source': registered
[    4.006391] device: 'breakpoint': device_add
[    4.007602] bus: 'event_source': add device breakpoint
[    4.008867] PM: Adding info for event_source:breakpoint
[    4.010294] device: 'software': device_add
[    4.011398] bus: 'event_source': add device software
[    4.012822] PM: Adding info for event_source:software
[    4.015704] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    4.036612] VFS: Disk quotas dquot_6.5.2
[    4.038080] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.051789] device: 'ecryptfs': device_add
[    4.055699] PM: Adding info for No Bus:ecryptfs
[    4.058264] QNX4 filesystem 0.2.3 registered.
[    4.059690] QNX6 filesystem 1.0.0 registered.
[    4.061157] fuse init (API version 7.22)
[    4.062690] device: 'fuse': device_add
[    4.066716] PM: Adding info for No Bus:fuse
[    4.067981] device class 'cuse': registering
[    4.069218] device: 'cuse': device_add
[    4.072647] PM: Adding info for No Bus:cuse
[    4.074455] JFS: nTxBlock = 1813, nTxLock = 14510
[    4.097408] SGI XFS with ACLs, security attributes, large block/inode numbers, debug enabled
[    4.119880] NILFS version 2 loaded
[    4.120822] BeFS version: 0.9.3
[    4.121869] OCFS2 1.5.0
[    4.126821] ocfs2: Registered cluster interface o2cb
[    4.128168] OCFS2 DLMFS 1.5.0
[    4.131636] OCFS2 User DLM kernel interface loaded
[    4.132858] OCFS2 Node Manager 1.5.0
[    4.137827] OCFS2 DLM 1.5.0
[    4.141503] bio: create slab <bio-1> at 1
[    4.147441] device: 'btrfs-control': device_add
[    4.151666] PM: Adding info for No Bus:btrfs-control
[    4.153137] Btrfs loaded
[    4.155204] msgmni has been set to 453
[    4.207002] alg: No test for crc32 (crc32-table)
[    4.208956] alg: No test for stdrng (krng)
[    4.236792] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    4.238836] Key type asymmetric registered
[    4.239959] Asymmetric key parser 'x509' registered
[    4.241599] device class 'bsg': registering
[    4.242804] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    4.244898] io scheduler noop registered (default)
[    4.246208] io scheduler deadline registered
[    4.247971] io scheduler cfq registered
[    4.250688] list_sort_test: start testing list_sort()
[    4.255367] test_string_helpers: Running tests...
[    4.257359] xz_dec_test: module loaded
[    4.258381] xz_dec_test: Create a device node with 'mknod xz_dec_test c 250 0' and write .xz files to it.
[    4.261717] bus: 'platform': add driver platform-lcd
[    4.263051] bus: 'platform': add driver generic-bl
[    4.264413] bus: 'platform': add driver pwm-backlight
[    4.265820] bus: 'platform': add driver hecubafb
[    4.267230] no IO addresses supplied
[    4.268230] bus: 'platform': add driver hgafb
[    4.269483] Registering platform device 'hgafb.0'. Parent at platform
[    4.271272] device: 'hgafb.0': device_add
[    4.272378] bus: 'platform': add device hgafb.0
[    4.273735] PM: Adding info for platform:hgafb.0
[    4.275015] bus: 'platform': driver_probe_device: matched device hgafb.0 with driver hgafb
[    4.277229] bus: 'platform': really_probe: probing driver hgafb with device hgafb.0
[    4.279398] hgafb: HGA card not detected.
[    4.280571] hgafb: probe of hgafb.0 failed with error -22
[    4.282049] bus: 'platform': add driver goldfish_fb
[    4.283499] bus: 'platform': add driver metronomefb
[    4.284893] bus: 'platform': add driver broadsheetfb
[    4.286255] bus: 'platform': add driver auo_k1900fb
[    4.287810] Registering platform device 'vesafb.0'. Parent at platform
[    4.289562] device: 'vesafb.0': device_add
[    4.290718] bus: 'platform': add device vesafb.0
[    4.292028] PM: Adding info for platform:vesafb.0
[    4.293370] bus: 'platform': add driver vesafb
[    4.294641] bus: 'platform': driver_probe_device: matched device vesafb.0 with driver vesafb
[    4.296833] bus: 'platform': really_probe: probing driver vesafb with device vesafb.0
[    4.298975] vesafb: probe of vesafb.0 rejects match -19
[    4.300524] bus: 'platform': remove driver vesafb
[    4.301852] driver: 'vesafb': driver_release
[    4.303228] bus: 'platform': remove device vesafb.0
[    4.304588] PM: Removing info for platform:vesafb.0
[    4.306029] bus: 'acpi': add driver ac
[    4.307192] bus: 'acpi': add driver button
[    4.308347] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    4.310601] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    4.312860] device: 'input0': device_add
[    4.314286] PM: Adding info for No Bus:input0
[    4.315612] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    4.317664] ACPI: Power Button [PWRF]
[    4.318726] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    4.320627] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    4.322737] bus: 'acpi': add driver fan
[    4.323978] bus: 'cpu': add driver processor
[    4.325195] bus: 'cpu': driver_probe_device: matched device cpu0 with driver processor
[    4.327375] bus: 'cpu': really_probe: probing driver processor with device cpu0
[    4.329585] device: 'cooling_device0': device_add
[    4.331024] PM: Adding info for No Bus:cooling_device0
[    4.332600] driver: 'cpu0': driver_bound: bound to device 'processor'
[    4.334332] bus: 'cpu': really_probe: bound device cpu0 to driver processor
[    4.336200] bus: 'cpu': driver_probe_device: matched device cpu1 with driver processor
[    4.338322] bus: 'cpu': really_probe: probing driver processor with device cpu1
[    4.340468] device: 'cooling_device1': device_add
[    4.341801] PM: Adding info for No Bus:cooling_device1
[    4.343261] driver: 'cpu1': driver_bound: bound to device 'processor'
[    4.344996] bus: 'cpu': really_probe: bound device cpu1 to driver processor
[    4.347038] bus: 'acpi': add driver thermal
[    4.348582] device: 'pnp1': device_add
[    4.349707] bus: 'acpi': add driver battery
[    4.349729] PM: Adding info for No Bus:pnp1
[    4.349732] isapnp: Scanning for PnP cards...
[    4.760865] isapnp: No Plug & Play device found
[    4.762323] bus: 'platform': add driver virtio-mmio
[    4.763982] bus: 'platform': add driver reg-virt-consumer
[    4.765731] bus: 'platform': add driver reg-userspace-consumer
[    4.767807] device: 'ptyp0': device_add
[    4.775935] PM: Adding info for No Bus:ptyp0
[    4.777529] device: 'ptyp1': device_add
[    4.786904] PM: Adding info for No Bus:ptyp1
[    4.788177] device: 'ptyp2': device_add
[    4.789496] PM: Adding info for No Bus:ptyp2
[    4.790844] device: 'ptyp3': device_add
[    4.792122] PM: Adding info for No Bus:ptyp3
[    4.793302] device: 'ptyp4': device_add
[    4.794627] PM: Adding info for No Bus:ptyp4
[    4.795860] device: 'ptyp5': device_add
[    4.797202] PM: Adding info for No Bus:ptyp5
[    4.798478] device: 'ptyp6': device_add
[    4.799754] PM: Adding info for No Bus:ptyp6
[    4.801014] device: 'ptyp7': device_add
[    4.802181] PM: Adding info for No Bus:ptyp7
[    4.803446] device: 'ptyp8': device_add
[    4.804664] PM: Adding info for No Bus:ptyp8
[    4.805850] device: 'ptyp9': device_add
[    4.807190] PM: Adding info for No Bus:ptyp9
[    4.808400] device: 'ptypa': device_add
[    4.809666] PM: Adding info for No Bus:ptypa
[    4.810978] device: 'ptypb': device_add
[    4.812287] PM: Adding info for No Bus:ptypb
[    4.813600] device: 'ptypc': device_add
[    4.814823] PM: Adding info for No Bus:ptypc
[    4.816064] device: 'ptypd': device_add
[    4.817468] PM: Adding info for No Bus:ptypd
[    4.818691] device: 'ptype': device_add
[    4.819952] PM: Adding info for No Bus:ptype
[    4.821274] device: 'ptypf': device_add
[    4.822582] PM: Adding info for No Bus:ptypf
[    4.823904] device: 'ptyq0': device_add
[    4.825133] PM: Adding info for No Bus:ptyq0
[    4.826359] device: 'ptyq1': device_add
[    4.827751] PM: Adding info for No Bus:ptyq1
[    4.828965] device: 'ptyq2': device_add
[    4.830394] PM: Adding info for No Bus:ptyq2
[    4.831651] device: 'ptyq3': device_add
[    4.832953] PM: Adding info for No Bus:ptyq3
[    4.834284] device: 'ptyq4': device_add
[    4.835524] PM: Adding info for No Bus:ptyq4
[    4.836856] device: 'ptyq5': device_add
[    4.838155] PM: Adding info for No Bus:ptyq5
[    4.839330] device: 'ptyq6': device_add
[    4.840636] PM: Adding info for No Bus:ptyq6
[    4.841887] device: 'ptyq7': device_add
[    4.843172] PM: Adding info for No Bus:ptyq7
[    4.844499] device: 'ptyq8': device_add
[    4.845796] PM: Adding info for No Bus:ptyq8
[    4.847139] device: 'ptyq9': device_add
[    4.848448] PM: Adding info for No Bus:ptyq9
[    4.849684] device: 'ptyqa': device_add
[    4.851036] PM: Adding info for No Bus:ptyqa
[    4.852272] device: 'ptyqb': device_add
[    4.853642] PM: Adding info for No Bus:ptyqb
[    4.854861] device: 'ptyqc': device_add
[    4.856159] PM: Adding info for No Bus:ptyqc
[    4.857583] device: 'ptyqd': device_add
[    4.858862] PM: Adding info for No Bus:ptyqd
[    4.860197] device: 'ptyqe': device_add
[    4.861496] PM: Adding info for No Bus:ptyqe
[    4.862734] device: 'ptyqf': device_add
[    4.864082] PM: Adding info for No Bus:ptyqf
[    4.865318] device: 'ptyr0': device_add
[    4.866627] PM: Adding info for No Bus:ptyr0
[    4.867904] device: 'ptyr1': device_add
[    4.869161] PM: Adding info for No Bus:ptyr1
[    4.870490] device: 'ptyr2': device_add
[    4.871822] PM: Adding info for No Bus:ptyr2
[    4.873066] device: 'ptyr3': device_add
[    4.874354] PM: Adding info for No Bus:ptyr3
[    4.875606] device: 'ptyr4': device_add
[    4.876993] PM: Adding info for No Bus:ptyr4
[    4.878273] device: 'ptyr5': device_add
[    4.879583] PM: Adding info for No Bus:ptyr5
[    4.880877] device: 'ptyr6': device_add
[    4.882140] PM: Adding info for No Bus:ptyr6
[    4.883452] device: 'ptyr7': device_add
[    4.884713] PM: Adding info for No Bus:ptyr7
[    4.885918] device: 'ptyr8': device_add
[    4.887254] tsc: Refined TSC clocksource calibration: 2893.027 MHz
[    4.889173] PM: Adding info for No Bus:ptyr8
[    4.890447] device: 'ptyr9': device_add
[    4.891702] PM: Adding info for No Bus:ptyr9
[    4.892976] device: 'ptyra': device_add
[    4.894370] PM: Adding info for No Bus:ptyra
[    4.895614] device: 'ptyrb': device_add
[    4.896992] PM: Adding info for No Bus:ptyrb
[    4.898240] device: 'ptyrc': device_add
[    4.899429] PM: Adding info for No Bus:ptyrc
[    4.900719] device: 'ptyrd': device_add
[    4.901966] PM: Adding info for No Bus:ptyrd
[    4.903205] device: 'ptyre': device_add
[    4.904543] PM: Adding info for No Bus:ptyre
[    4.905782] device: 'ptyrf': device_add
[    4.907133] PM: Adding info for No Bus:ptyrf
[    4.908354] device: 'ptys0': device_add
[    4.909598] PM: Adding info for No Bus:ptys0
[    4.910840] device: 'ptys1': device_add
[    4.912086] PM: Adding info for No Bus:ptys1
[    4.913333] device: 'ptys2': device_add
[    4.914678] PM: Adding info for No Bus:ptys2
[    4.915906] device: 'ptys3': device_add
[    4.917268] PM: Adding info for No Bus:ptys3
[    4.918499] device: 'ptys4': device_add
[    4.919710] PM: Adding info for No Bus:ptys4
[    4.920981] device: 'ptys5': device_add
[    4.922242] PM: Adding info for No Bus:ptys5
[    4.923516] device: 'ptys6': device_add
[    4.924742] PM: Adding info for No Bus:ptys6
[    4.926267] device: 'ptys7': device_add
[    4.927747] PM: Adding info for No Bus:ptys7
[    4.928979] device: 'ptys8': device_add
[    4.930296] PM: Adding info for No Bus:ptys8
[    4.931508] device: 'ptys9': device_add
[    4.932778] PM: Adding info for No Bus:ptys9
[    4.934073] device: 'ptysa': device_add
[    4.935357] PM: Adding info for No Bus:ptysa
[    4.936647] device: 'ptysb': device_add
[    4.937964] PM: Adding info for No Bus:ptysb
[    4.939165] device: 'ptysc': device_add
[    4.940462] PM: Adding info for No Bus:ptysc
[    4.941670] device: 'ptysd': device_add
[    4.942920] PM: Adding info for No Bus:ptysd
[    4.944224] device: 'ptyse': device_add
[    4.945482] PM: Adding info for No Bus:ptyse
[    4.946786] device: 'ptysf': device_add
[    4.948041] PM: Adding info for No Bus:ptysf
[    4.949215] device: 'ptyt0': device_add
[    4.950498] PM: Adding info for No Bus:ptyt0
[    4.951751] device: 'ptyt1': device_add
[    4.953064] PM: Adding info for No Bus:ptyt1
[    4.954372] device: 'ptyt2': device_add
[    4.955621] PM: Adding info for No Bus:ptyt2
[    4.956943] device: 'ptyt3': device_add
[    4.958155] PM: Adding info for No Bus:ptyt3
[    4.959404] device: 'ptyt4': device_add
[    4.960727] PM: Adding info for No Bus:ptyt4
[    4.961957] device: 'ptyt5': device_add
[    4.963234] PM: Adding info for No Bus:ptyt5
[    4.964529] device: 'ptyt6': device_add
[    4.965823] PM: Adding info for No Bus:ptyt6
[    4.967137] device: 'ptyt7': device_add
[    4.968396] PM: Adding info for No Bus:ptyt7
[    4.969627] device: 'ptyt8': device_add
[    4.970926] PM: Adding info for No Bus:ptyt8
[    4.972143] device: 'ptyt9': device_add
[    4.973452] PM: Adding info for No Bus:ptyt9
[    4.974656] device: 'ptyta': device_add
[    4.975913] PM: Adding info for No Bus:ptyta
[    4.977251] device: 'ptytb': device_add
[    4.978523] PM: Adding info for No Bus:ptytb
[    4.979789] device: 'ptytc': device_add
[    4.981157] PM: Adding info for No Bus:ptytc
[    4.982347] device: 'ptytd': device_add
[    4.983658] PM: Adding info for No Bus:ptytd
[    4.984842] device: 'ptyte': device_add
[    4.986075] PM: Adding info for No Bus:ptyte
[    4.987427] device: 'ptytf': device_add
[    4.988692] PM: Adding info for No Bus:ptytf
[    4.989911] device: 'ptyu0': device_add
[    4.991194] PM: Adding info for No Bus:ptyu0
[    4.992431] device: 'ptyu1': device_add
[    4.993767] PM: Adding info for No Bus:ptyu1
[    4.994985] device: 'ptyu2': device_add
[    4.996248] PM: Adding info for No Bus:ptyu2
[    4.997600] device: 'ptyu3': device_add
[    4.998893] PM: Adding info for No Bus:ptyu3
[    5.000186] device: 'ptyu4': device_add
[    5.001426] PM: Adding info for No Bus:ptyu4
[    5.002690] device: 'ptyu5': device_add
[    5.004043] PM: Adding info for No Bus:ptyu5
[    5.005267] device: 'ptyu6': device_add
[    5.006504] PM: Adding info for No Bus:ptyu6
[    5.007862] device: 'ptyu7': device_add
[    5.009135] PM: Adding info for No Bus:ptyu7
[    5.010449] device: 'ptyu8': device_add
[    5.011750] PM: Adding info for No Bus:ptyu8
[    5.012991] device: 'ptyu9': device_add
[    5.014357] PM: Adding info for No Bus:ptyu9
[    5.015620] device: 'ptyua': device_add
[    5.017047] PM: Adding info for No Bus:ptyua
[    5.018262] device: 'ptyub': device_add
[    5.019509] PM: Adding info for No Bus:ptyub
[    5.020827] device: 'ptyuc': device_add
[    5.022065] PM: Adding info for No Bus:ptyuc
[    5.023286] device: 'ptyud': device_add
[    5.024565] PM: Adding info for No Bus:ptyud
[    5.025830] device: 'ptyue': device_add
[    5.027205] PM: Adding info for No Bus:ptyue
[    5.028440] device: 'ptyuf': device_add
[    5.029720] PM: Adding info for No Bus:ptyuf
[    5.031050] device: 'ptyv0': device_add
[    5.032309] PM: Adding info for No Bus:ptyv0
[    5.033623] device: 'ptyv1': device_add
[    5.034945] PM: Adding info for No Bus:ptyv1
[    5.036163] device: 'ptyv2': device_add
[    5.037607] PM: Adding info for No Bus:ptyv2
[    5.038840] device: 'ptyv3': device_add
[    5.040172] PM: Adding info for No Bus:ptyv3
[    5.041362] device: 'ptyv4': device_add
[    5.042666] PM: Adding info for No Bus:ptyv4
[    5.043984] device: 'ptyv5': device_add
[    5.045268] PM: Adding info for No Bus:ptyv5
[    5.046536] device: 'ptyv6': device_add
[    5.048020] PM: Adding info for No Bus:ptyv6
[    5.049236] device: 'ptyv7': device_add
[    5.050571] PM: Adding info for No Bus:ptyv7
[    5.051778] device: 'ptyv8': device_add
[    5.053021] PM: Adding info for No Bus:ptyv8
[    5.054327] device: 'ptyv9': device_add
[    5.055589] PM: Adding info for No Bus:ptyv9
[    5.056530] device: 'ptyva': device_add
[    5.057882] PM: Adding info for No Bus:ptyva
[    5.059160] device: 'ptyvb': device_add
[    5.060489] PM: Adding info for No Bus:ptyvb
[    5.061791] device: 'ptyvc': device_add
[    5.063027] PM: Adding info for No Bus:ptyvc
[    5.064320] device: 'ptyvd': device_add
[    5.065606] PM: Adding info for No Bus:ptyvd
[    5.067008] device: 'ptyve': device_add
[    5.068344] PM: Adding info for No Bus:ptyve
[    5.069435] device: 'ptyvf': device_add
[    5.070814] PM: Adding info for No Bus:ptyvf
[    5.072056] device: 'ptyw0': device_add
[    5.073278] PM: Adding info for No Bus:ptyw0
[    5.074510] device: 'ptyw1': device_add
[    5.075733] PM: Adding info for No Bus:ptyw1
[    5.077042] device: 'ptyw2': device_add
[    5.078359] PM: Adding info for No Bus:ptyw2
[    5.079561] device: 'ptyw3': device_add
[    5.080872] PM: Adding info for No Bus:ptyw3
[    5.082040] device: 'ptyw4': device_add
[    5.083328] PM: Adding info for No Bus:ptyw4
[    5.084681] device: 'ptyw5': device_add
[    5.085977] PM: Adding info for No Bus:ptyw5
[    5.087259] device: 'ptyw6': device_add
[    5.088536] PM: Adding info for No Bus:ptyw6
[    5.089723] device: 'ptyw7': device_add
[    5.091007] PM: Adding info for No Bus:ptyw7
[    5.092181] device: 'ptyw8': device_add
[    5.093315] PM: Adding info for No Bus:ptyw8
[    5.094606] device: 'ptyw9': device_add
[    5.095855] PM: Adding info for No Bus:ptyw9
[    5.097165] device: 'ptywa': device_add
[    5.098427] PM: Adding info for No Bus:ptywa
[    5.099659] device: 'ptywb': device_add
[    5.100912] PM: Adding info for No Bus:ptywb
[    5.102112] device: 'ptywc': device_add
[    5.103313] PM: Adding info for No Bus:ptywc
[    5.104543] device: 'ptywd': device_add
[    5.105958] PM: Adding info for No Bus:ptywd
[    5.107298] device: 'ptywe': device_add
[    5.108566] PM: Adding info for No Bus:ptywe
[    5.109764] device: 'ptywf': device_add
[    5.111099] PM: Adding info for No Bus:ptywf
[    5.112331] device: 'ptyx0': device_add
[    5.113616] PM: Adding info for No Bus:ptyx0
[    5.114861] device: 'ptyx1': device_add
[    5.116102] PM: Adding info for No Bus:ptyx1
[    5.117522] device: 'ptyx2': device_add
[    5.118837] PM: Adding info for No Bus:ptyx2
[    5.120142] device: 'ptyx3': device_add
[    5.121443] PM: Adding info for No Bus:ptyx3
[    5.122668] device: 'ptyx4': device_add
[    5.124005] PM: Adding info for No Bus:ptyx4
[    5.125286] device: 'ptyx5': device_add
[    5.126637] PM: Adding info for No Bus:ptyx5
[    5.127910] device: 'ptyx6': device_add
[    5.129217] PM: Adding info for No Bus:ptyx6
[    5.130570] device: 'ptyx7': device_add
[    5.131922] PM: Adding info for No Bus:ptyx7
[    5.133159] device: 'ptyx8': device_add
[    5.134464] PM: Adding info for No Bus:ptyx8
[    5.135706] device: 'ptyx9': device_add
[    5.137142] PM: Adding info for No Bus:ptyx9
[    5.138343] device: 'ptyxa': device_add
[    5.139626] PM: Adding info for No Bus:ptyxa
[    5.140993] device: 'ptyxb': device_add
[    5.142237] PM: Adding info for No Bus:ptyxb
[    5.143397] device: 'ptyxc': device_add
[    5.144583] PM: Adding info for No Bus:ptyxc
[    5.145836] device: 'ptyxd': device_add
[    5.147214] PM: Adding info for No Bus:ptyxd
[    5.148384] device: 'ptyxe': device_add
[    5.149638] PM: Adding info for No Bus:ptyxe
[    5.150898] device: 'ptyxf': device_add
[    5.152131] PM: Adding info for No Bus:ptyxf
[    5.153298] device: 'ptyy0': device_add
[    5.154663] PM: Adding info for No Bus:ptyy0
[    5.155846] device: 'ptyy1': device_add
[    5.157244] PM: Adding info for No Bus:ptyy1
[    5.158473] device: 'ptyy2': device_add
[    5.159681] PM: Adding info for No Bus:ptyy2
[    5.161027] device: 'ptyy3': device_add
[    5.162272] PM: Adding info for No Bus:ptyy3
[    5.163520] device: 'ptyy4': device_add
[    5.164706] PM: Adding info for No Bus:ptyy4
[    5.165867] device: 'ptyy5': device_add
[    5.167282] PM: Adding info for No Bus:ptyy5
[    5.168475] device: 'ptyy6': device_add
[    5.169708] PM: Adding info for No Bus:ptyy6
[    5.170943] device: 'ptyy7': device_add
[    5.172204] PM: Adding info for No Bus:ptyy7
[    5.173418] device: 'ptyy8': device_add
[    5.174566] PM: Adding info for No Bus:ptyy8
[    5.175682] device: 'ptyy9': device_add
[    5.177014] PM: Adding info for No Bus:ptyy9
[    5.178239] device: 'ptyya': device_add
[    5.179451] PM: Adding info for No Bus:ptyya
[    5.180692] device: 'ptyyb': device_add
[    5.181913] PM: Adding info for No Bus:ptyyb
[    5.183119] device: 'ptyyc': device_add
[    5.184440] PM: Adding info for No Bus:ptyyc
[    5.185589] device: 'ptyyd': device_add
[    5.187013] PM: Adding info for No Bus:ptyyd
[    5.188200] device: 'ptyye': device_add
[    5.189438] PM: Adding info for No Bus:ptyye
[    5.190688] device: 'ptyyf': device_add
[    5.191941] PM: Adding info for No Bus:ptyyf
[    5.193150] device: 'ptyz0': device_add
[    5.194546] PM: Adding info for No Bus:ptyz0
[    5.195789] device: 'ptyz1': device_add
[    5.197184] PM: Adding info for No Bus:ptyz1
[    5.198410] device: 'ptyz2': device_add
[    5.199709] PM: Adding info for No Bus:ptyz2
[    5.201036] device: 'ptyz3': device_add
[    5.202303] PM: Adding info for No Bus:ptyz3
[    5.203586] device: 'ptyz4': device_add
[    5.204840] PM: Adding info for No Bus:ptyz4
[    5.206056] device: 'ptyz5': device_add
[    5.207432] PM: Adding info for No Bus:ptyz5
[    5.208729] device: 'ptyz6': device_add
[    5.210092] PM: Adding info for No Bus:ptyz6
[    5.211304] device: 'ptyz7': device_add
[    5.212503] PM: Adding info for No Bus:ptyz7
[    5.213733] device: 'ptyz8': device_add
[    5.214928] PM: Adding info for No Bus:ptyz8
[    5.216128] device: 'ptyz9': device_add
[    5.217522] PM: Adding info for No Bus:ptyz9
[    5.218762] device: 'ptyza': device_add
[    5.220105] PM: Adding info for No Bus:ptyza
[    5.221328] device: 'ptyzb': device_add
[    5.222574] PM: Adding info for No Bus:ptyzb
[    5.223961] device: 'ptyzc': device_add
[    5.225267] PM: Adding info for No Bus:ptyzc
[    5.226476] device: 'ptyzd': device_add
[    5.227763] PM: Adding info for No Bus:ptyzd
[    5.228896] device: 'ptyze': device_add
[    5.230312] PM: Adding info for No Bus:ptyze
[    5.231568] device: 'ptyzf': device_add
[    5.232767] PM: Adding info for No Bus:ptyzf
[    5.234016] device: 'ptya0': device_add
[    5.235192] PM: Adding info for No Bus:ptya0
[    5.236343] device: 'ptya1': device_add
[    5.237677] PM: Adding info for No Bus:ptya1
[    5.238849] device: 'ptya2': device_add
[    5.240169] PM: Adding info for No Bus:ptya2
[    5.241410] device: 'ptya3': device_add
[    5.242616] PM: Adding info for No Bus:ptya3
[    5.243867] device: 'ptya4': device_add
[    5.245102] PM: Adding info for No Bus:ptya4
[    5.246264] device: 'ptya5': device_add
[    5.247681] PM: Adding info for No Bus:ptya5
[    5.248962] device: 'ptya6': device_add
[    5.250254] PM: Adding info for No Bus:ptya6
[    5.251420] device: 'ptya7': device_add
[    5.252730] PM: Adding info for No Bus:ptya7
[    5.253964] device: 'ptya8': device_add
[    5.255243] PM: Adding info for No Bus:ptya8
[    5.256536] device: 'ptya9': device_add
[    5.257964] PM: Adding info for No Bus:ptya9
[    5.259117] device: 'ptyaa': device_add
[    5.260413] PM: Adding info for No Bus:ptyaa
[    5.261591] device: 'ptyab': device_add
[    5.262822] PM: Adding info for No Bus:ptyab
[    5.264020] device: 'ptyac': device_add
[    5.265169] PM: Adding info for No Bus:ptyac
[    5.266263] device: 'ptyad': device_add
[    5.267562] PM: Adding info for No Bus:ptyad
[    5.268800] device: 'ptyae': device_add
[    5.270001] PM: Adding info for No Bus:ptyae
[    5.271225] device: 'ptyaf': device_add
[    5.272505] PM: Adding info for No Bus:ptyaf
[    5.273781] device: 'ptyb0': device_add
[    5.274983] PM: Adding info for No Bus:ptyb0
[    5.276125] device: 'ptyb1': device_add
[    5.277476] PM: Adding info for No Bus:ptyb1
[    5.278683] device: 'ptyb2': device_add
[    5.279893] PM: Adding info for No Bus:ptyb2
[    5.281130] device: 'ptyb3': device_add
[    5.282398] PM: Adding info for No Bus:ptyb3
[    5.283714] device: 'ptyb4': device_add
[    5.284943] PM: Adding info for No Bus:ptyb4
[    5.286095] device: 'ptyb5': device_add
[    5.287295] PM: Adding info for No Bus:ptyb5
[    5.288294] device: 'ptyb6': device_add
[    5.289476] PM: Adding info for No Bus:ptyb6
[    5.290707] device: 'ptyb7': device_add
[    5.291968] PM: Adding info for No Bus:ptyb7
[    5.293214] device: 'ptyb8': device_add
[    5.294545] PM: Adding info for No Bus:ptyb8
[    5.295766] device: 'ptyb9': device_add
[    5.297134] PM: Adding info for No Bus:ptyb9
[    5.298351] device: 'ptyba': device_add
[    5.299595] PM: Adding info for No Bus:ptyba
[    5.300896] device: 'ptybb': device_add
[    5.302193] PM: Adding info for No Bus:ptybb
[    5.303523] device: 'ptybc': device_add
[    5.304829] PM: Adding info for No Bus:ptybc
[    5.306076] device: 'ptybd': device_add
[    5.307506] PM: Adding info for No Bus:ptybd
[    5.308825] device: 'ptybe': device_add
[    5.310222] PM: Adding info for No Bus:ptybe
[    5.311494] device: 'ptybf': device_add
[    5.312850] PM: Adding info for No Bus:ptybf
[    5.314258] device: 'ptyc0': device_add
[    5.315613] PM: Adding info for No Bus:ptyc0
[    5.317029] device: 'ptyc1': device_add
[    5.318353] PM: Adding info for No Bus:ptyc1
[    5.319628] device: 'ptyc2': device_add
[    5.320951] PM: Adding info for No Bus:ptyc2
[    5.322238] device: 'ptyc3': device_add
[    5.323580] PM: Adding info for No Bus:ptyc3
[    5.324828] device: 'ptyc4': device_add
[    5.326124] PM: Adding info for No Bus:ptyc4
[    5.327567] device: 'ptyc5': device_add
[    5.328956] PM: Adding info for No Bus:ptyc5
[    5.330286] device: 'ptyc6': device_add
[    5.331627] PM: Adding info for No Bus:ptyc6
[    5.332877] device: 'ptyc7': device_add
[    5.334272] PM: Adding info for No Bus:ptyc7
[    5.335501] device: 'ptyc8': device_add
[    5.336934] PM: Adding info for No Bus:ptyc8
[    5.338181] device: 'ptyc9': device_add
[    5.339502] PM: Adding info for No Bus:ptyc9
[    5.348837] device: 'ptyca': device_add
[    5.352701] PM: Adding info for No Bus:ptyca
[    5.354085] device: 'ptycb': device_add
[    5.356728] PM: Adding info for No Bus:ptycb
[    5.358055] device: 'ptycc': device_add
[    5.361678] PM: Adding info for No Bus:ptycc
[    5.362984] device: 'ptycd': device_add
[    5.366711] PM: Adding info for No Bus:ptycd
[    5.368021] device: 'ptyce': device_add
[    5.371704] PM: Adding info for No Bus:ptyce
[    5.373026] device: 'ptycf': device_add
[    5.376723] PM: Adding info for No Bus:ptycf
[    5.378098] device: 'ptyd0': device_add
[    5.381687] PM: Adding info for No Bus:ptyd0
[    5.383007] device: 'ptyd1': device_add
[    5.386659] PM: Adding info for No Bus:ptyd1
[    5.388082] device: 'ptyd2': device_add
[    5.391714] PM: Adding info for No Bus:ptyd2
[    5.393027] device: 'ptyd3': device_add
[    5.396718] PM: Adding info for No Bus:ptyd3
[    5.398014] device: 'ptyd4': device_add
[    5.399408] PM: Adding info for No Bus:ptyd4
[    5.400714] device: 'ptyd5': device_add
[    5.402085] PM: Adding info for No Bus:ptyd5
[    5.403453] device: 'ptyd6': device_add
[    5.404777] PM: Adding info for No Bus:ptyd6
[    5.406082] device: 'ptyd7': device_add
[    5.407574] PM: Adding info for No Bus:ptyd7
[    5.408887] device: 'ptyd8': device_add
[    5.410241] PM: Adding info for No Bus:ptyd8
[    5.411528] device: 'ptyd9': device_add
[    5.412902] PM: Adding info for No Bus:ptyd9
[    5.414281] device: 'ptyda': device_add
[    5.415642] PM: Adding info for No Bus:ptyda
[    5.417046] device: 'ptydb': device_add
[    5.418399] PM: Adding info for No Bus:ptydb
[    5.419673] device: 'ptydc': device_add
[    5.421048] PM: Adding info for No Bus:ptydc
[    5.422367] device: 'ptydd': device_add
[    5.423780] PM: Adding info for No Bus:ptydd
[    5.425041] device: 'ptyde': device_add
[    5.426379] PM: Adding info for No Bus:ptyde
[    5.427769] device: 'ptydf': device_add
[    5.429090] PM: Adding info for No Bus:ptydf
[    5.430427] device: 'ptye0': device_add
[    5.431723] PM: Adding info for No Bus:ptye0
[    5.432975] device: 'ptye1': device_add
[    5.434352] PM: Adding info for No Bus:ptye1
[    5.435636] device: 'ptye2': device_add
[    5.437116] PM: Adding info for No Bus:ptye2
[    5.438413] device: 'ptye3': device_add
[    5.439786] PM: Adding info for No Bus:ptye3
[    5.441172] device: 'ptye4': device_add
[    5.442462] PM: Adding info for No Bus:ptye4
[    5.443821] device: 'ptye5': device_add
[    5.445119] PM: Adding info for No Bus:ptye5
[    5.446405] device: 'ptye6': device_add
[    5.447863] PM: Adding info for No Bus:ptye6
[    5.449052] device: 'ptye7': device_add
[    5.450491] PM: Adding info for No Bus:ptye7
[    5.451761] device: 'ptye8': device_add
[    5.453083] PM: Adding info for No Bus:ptye8
[    5.454415] device: 'ptye9': device_add
[    5.455804] PM: Adding info for No Bus:ptye9
[    5.457237] device: 'ptyea': device_add
[    5.458614] PM: Adding info for No Bus:ptyea
[    5.459892] device: 'ptyeb': device_add
[    5.461306] PM: Adding info for No Bus:ptyeb
[    5.462602] device: 'ptyec': device_add
[    5.463974] PM: Adding info for No Bus:ptyec
[    5.465260] device: 'ptyed': device_add
[    5.466625] PM: Adding info for No Bus:ptyed
[    5.467955] device: 'ptyee': device_add
[    5.469271] PM: Adding info for No Bus:ptyee
[    5.470631] device: 'ptyef': device_add
[    5.471936] PM: Adding info for No Bus:ptyef
[    5.473231] device: 'ttyp0': device_add
[    5.474652] PM: Adding info for No Bus:ttyp0
[    5.475927] device: 'ttyp1': device_add
[    5.477353] PM: Adding info for No Bus:ttyp1
[    5.478654] device: 'ttyp2': device_add
[    5.479978] PM: Adding info for No Bus:ttyp2
[    5.481363] device: 'ttyp3': device_add
[    5.482693] PM: Adding info for No Bus:ttyp3
[    5.484059] device: 'ttyp4': device_add
[    5.485330] PM: Adding info for No Bus:ttyp4
[    5.486603] device: 'ttyp5': device_add
[    5.488026] PM: Adding info for No Bus:ttyp5
[    5.489326] device: 'ttyp6': device_add
[    5.490738] PM: Adding info for No Bus:ttyp6
[    5.492053] device: 'ttyp7': device_add
[    5.493329] PM: Adding info for No Bus:ttyp7
[    5.494702] device: 'ttyp8': device_add
[    5.495989] PM: Adding info for No Bus:ttyp8
[    5.497408] device: 'ttyp9': device_add
[    5.498745] PM: Adding info for No Bus:ttyp9
[    5.499988] device: 'ttypa': device_add
[    5.501481] PM: Adding info for No Bus:ttypa
[    5.502808] device: 'ttypb': device_add
[    5.504161] PM: Adding info for No Bus:ttypb
[    5.505460] device: 'ttypc': device_add
[    5.506923] PM: Adding info for No Bus:ttypc
[    5.508221] device: 'ttypd': device_add
[    5.509553] PM: Adding info for No Bus:ttypd
[    5.510956] device: 'ttype': device_add
[    5.512224] PM: Adding info for No Bus:ttype
[    5.513578] device: 'ttypf': device_add
[    5.514869] PM: Adding info for No Bus:ttypf
[    5.516182] device: 'ttyq0': device_add
[    5.517680] PM: Adding info for No Bus:ttyq0
[    5.519012] device: 'ttyq1': device_add
[    5.520435] PM: Adding info for No Bus:ttyq1
[    5.521754] device: 'ttyq2': device_add
[    5.523081] PM: Adding info for No Bus:ttyq2
[    5.524311] device: 'ttyq3': device_add
[    5.525574] PM: Adding info for No Bus:ttyq3
[    5.526949] device: 'ttyq4': device_add
[    5.528245] PM: Adding info for No Bus:ttyq4
[    5.529535] device: 'ttyq5': device_add
[    5.530926] PM: Adding info for No Bus:ttyq5
[    5.532194] device: 'ttyq6': device_add
[    5.533534] PM: Adding info for No Bus:ttyq6
[    5.534840] device: 'ttyq7': device_add
[    5.536207] PM: Adding info for No Bus:ttyq7
[    5.537656] device: 'ttyq8': device_add
[    5.538974] PM: Adding info for No Bus:ttyq8
[    5.540354] device: 'ttyq9': device_add
[    5.541683] PM: Adding info for No Bus:ttyq9
[    5.542979] device: 'ttyqa': device_add
[    5.544350] PM: Adding info for No Bus:ttyqa
[    5.545639] device: 'ttyqb': device_add
[    5.547090] PM: Adding info for No Bus:ttyqb
[    5.548366] device: 'ttyqc': device_add
[    5.549692] PM: Adding info for No Bus:ttyqc
[    5.551049] device: 'ttyqd': device_add
[    5.552392] PM: Adding info for No Bus:ttyqd
[    5.553748] device: 'ttyqe': device_add
[    5.555145] PM: Adding info for No Bus:ttyqe
[    5.556420] device: 'ttyqf': device_add
[    5.557838] PM: Adding info for No Bus:ttyqf
[    5.559111] device: 'ttyr0': device_add
[    5.560479] PM: Adding info for No Bus:ttyr0
[    5.561568] device: 'ttyr1': device_add
[    5.562775] PM: Adding info for No Bus:ttyr1
[    5.564084] device: 'ttyr2': device_add
[    5.565378] PM: Adding info for No Bus:ttyr2
[    5.566654] device: 'ttyr3': device_add
[    5.567992] PM: Adding info for No Bus:ttyr3
[    5.569219] device: 'ttyr4': device_add
[    5.570543] PM: Adding info for No Bus:ttyr4
[    5.571804] device: 'ttyr5': device_add
[    5.573087] PM: Adding info for No Bus:ttyr5
[    5.574374] device: 'ttyr6': device_add
[    5.575659] PM: Adding info for No Bus:ttyr6
[    5.576955] device: 'ttyr7': device_add
[    5.578190] PM: Adding info for No Bus:ttyr7
[    5.579383] device: 'ttyr8': device_add
[    5.580676] PM: Adding info for No Bus:ttyr8
[    5.581932] device: 'ttyr9': device_add
[    5.583194] PM: Adding info for No Bus:ttyr9
[    5.584463] device: 'ttyra': device_add
[    5.585739] PM: Adding info for No Bus:ttyra
[    5.587060] device: 'ttyrb': device_add
[    5.588310] PM: Adding info for No Bus:ttyrb
[    5.589503] device: 'ttyrc': device_add
[    5.590743] PM: Adding info for No Bus:ttyrc
[    5.591923] device: 'ttyrd': device_add
[    5.593161] PM: Adding info for No Bus:ttyrd
[    5.594480] device: 'ttyre': device_add
[    5.595737] PM: Adding info for No Bus:ttyre
[    5.597061] device: 'ttyrf': device_add
[    5.598278] PM: Adding info for No Bus:ttyrf
[    5.599471] device: 'ttys0': device_add
[    5.600602] PM: Adding info for No Bus:ttys0
[    5.601823] device: 'ttys1': device_add
[    5.603119] PM: Adding info for No Bus:ttys1
[    5.604413] device: 'ttys2': device_add
[    5.605715] PM: Adding info for No Bus:ttys2
[    5.607128] device: 'ttys3': device_add
[    5.608368] PM: Adding info for No Bus:ttys3
[    5.609693] device: 'ttys4': device_add
[    5.611054] PM: Adding info for No Bus:ttys4
[    5.612333] device: 'ttys5': device_add
[    5.613714] PM: Adding info for No Bus:ttys5
[    5.615023] device: 'ttys6': device_add
[    5.616281] PM: Adding info for No Bus:ttys6
[    5.617698] device: 'ttys7': device_add
[    5.619053] PM: Adding info for No Bus:ttys7
[    5.620389] device: 'ttys8': device_add
[    5.621684] PM: Adding info for No Bus:ttys8
[    5.622926] device: 'ttys9': device_add
[    5.624212] PM: Adding info for No Bus:ttys9
[    5.625484] device: 'ttysa': device_add
[    5.626839] PM: Adding info for No Bus:ttysa
[    5.628153] device: 'ttysb': device_add
[    5.629436] PM: Adding info for No Bus:ttysb
[    5.630816] device: 'ttysc': device_add
[    5.632089] PM: Adding info for No Bus:ttysc
[    5.633384] device: 'ttysd': device_add
[    5.634722] PM: Adding info for No Bus:ttysd
[    5.635990] device: 'ttyse': device_add
[    5.637448] PM: Adding info for No Bus:ttyse
[    5.638678] device: 'ttysf': device_add
[    5.640103] PM: Adding info for No Bus:ttysf
[    5.641442] device: 'ttyt0': device_add
[    5.642756] PM: Adding info for No Bus:ttyt0
[    5.644134] device: 'ttyt1': device_add
[    5.645454] PM: Adding info for No Bus:ttyt1
[    5.646895] device: 'ttyt2': device_add
[    5.648256] PM: Adding info for No Bus:ttyt2
[    5.649536] device: 'ttyt3': device_add
[    5.650947] PM: Adding info for No Bus:ttyt3
[    5.652244] device: 'ttyt4': device_add
[    5.653607] PM: Adding info for No Bus:ttyt4
[    5.654882] device: 'ttyt5': device_add
[    5.656226] PM: Adding info for No Bus:ttyt5
[    5.657618] device: 'ttyt6': device_add
[    5.658929] PM: Adding info for No Bus:ttyt6
[    5.660294] device: 'ttyt7': device_add
[    5.661621] PM: Adding info for No Bus:ttyt7
[    5.662967] device: 'ttyt8': device_add
[    5.664333] PM: Adding info for No Bus:ttyt8
[    5.665632] device: 'ttyt9': device_add
[    5.667038] PM: Adding info for No Bus:ttyt9
[    5.668371] device: 'ttyta': device_add
[    5.669734] PM: Adding info for No Bus:ttyta
[    5.671120] device: 'ttytb': device_add
[    5.672456] PM: Adding info for No Bus:ttytb
[    5.673838] device: 'ttytc': device_add
[    5.675159] PM: Adding info for No Bus:ttytc
[    5.676458] device: 'ttytd': device_add
[    5.677934] PM: Adding info for No Bus:ttytd
[    5.679194] device: 'ttyte': device_add
[    5.680626] PM: Adding info for No Bus:ttyte
[    5.681922] device: 'ttytf': device_add
[    5.683255] PM: Adding info for No Bus:ttytf
[    5.684632] device: 'ttyu0': device_add
[    5.686006] PM: Adding info for No Bus:ttyu0
[    5.687438] device: 'ttyu1': device_add
[    5.688760] PM: Adding info for No Bus:ttyu1
[    5.690111] device: 'ttyu2': device_add
[    5.691425] PM: Adding info for No Bus:ttyu2
[    5.692710] device: 'ttyu3': device_add
[    5.694119] PM: Adding info for No Bus:ttyu3
[    5.695415] device: 'ttyu4': device_add
[    5.696801] PM: Adding info for No Bus:ttyu4
[    5.698141] device: 'ttyu5': device_add
[    5.699402] PM: Adding info for No Bus:ttyu5
[    5.700673] device: 'ttyu6': device_add
[    5.701945] PM: Adding info for No Bus:ttyu6
[    5.703143] device: 'ttyu7': device_add
[    5.704428] PM: Adding info for No Bus:ttyu7
[    5.705679] device: 'ttyu8': device_add
[    5.707027] PM: Adding info for No Bus:ttyu8
[    5.708280] device: 'ttyu9': device_add
[    5.709554] PM: Adding info for No Bus:ttyu9
[    5.710888] device: 'ttyua': device_add
[    5.712090] PM: Adding info for No Bus:ttyua
[    5.713300] device: 'ttyub': device_add
[    5.714613] PM: Adding info for No Bus:ttyub
[    5.715829] device: 'ttyuc': device_add
[    5.717193] PM: Adding info for No Bus:ttyuc
[    5.718424] device: 'ttyud': device_add
[    5.719734] PM: Adding info for No Bus:ttyud
[    5.721064] device: 'ttyue': device_add
[    5.722342] PM: Adding info for No Bus:ttyue
[    5.723614] device: 'ttyuf': device_add
[    5.724826] PM: Adding info for No Bus:ttyuf
[    5.725957] device: 'ttyv0': device_add
[    5.727290] PM: Adding info for No Bus:ttyv0
[    5.728502] device: 'ttyv1': device_add
[    5.729725] PM: Adding info for No Bus:ttyv1
[    5.731062] device: 'ttyv2': device_add
[    5.732292] PM: Adding info for No Bus:ttyv2
[    5.733468] device: 'ttyv3': device_add
[    5.734694] PM: Adding info for No Bus:ttyv3
[    5.735879] device: 'ttyv4': device_add
[    5.737190] PM: Adding info for No Bus:ttyv4
[    5.738366] device: 'ttyv5': device_add
[    5.739610] PM: Adding info for No Bus:ttyv5
[    5.740920] device: 'ttyv6': device_add
[    5.742245] PM: Adding info for No Bus:ttyv6
[    5.743547] device: 'ttyv7': device_add
[    5.744787] PM: Adding info for No Bus:ttyv7
[    5.745998] device: 'ttyv8': device_add
[    5.747328] PM: Adding info for No Bus:ttyv8
[    5.748514] device: 'ttyv9': device_add
[    5.749770] PM: Adding info for No Bus:ttyv9
[    5.751072] device: 'ttyva': device_add
[    5.752341] PM: Adding info for No Bus:ttyva
[    5.753660] device: 'ttyvb': device_add
[    5.755020] PM: Adding info for No Bus:ttyvb
[    5.756272] device: 'ttyvc': device_add
[    5.757738] PM: Adding info for No Bus:ttyvc
[    5.758889] device: 'ttyvd': device_add
[    5.760117] PM: Adding info for No Bus:ttyvd
[    5.761295] device: 'ttyve': device_add
[    5.762587] PM: Adding info for No Bus:ttyve
[    5.763927] device: 'ttyvf': device_add
[    5.765169] PM: Adding info for No Bus:ttyvf
[    5.766402] device: 'ttyw0': device_add
[    5.767811] PM: Adding info for No Bus:ttyw0
[    5.769001] device: 'ttyw1': device_add
[    5.770318] PM: Adding info for No Bus:ttyw1
[    5.771490] device: 'ttyw2': device_add
[    5.772757] PM: Adding info for No Bus:ttyw2
[    5.774055] device: 'ttyw3': device_add
[    5.775328] PM: Adding info for No Bus:ttyw3
[    5.776629] device: 'ttyw4': device_add
[    5.777961] PM: Adding info for No Bus:ttyw4
[    5.779150] device: 'ttyw5': device_add
[    5.780445] PM: Adding info for No Bus:ttyw5
[    5.781667] device: 'ttyw6': device_add
[    5.782902] PM: Adding info for No Bus:ttyw6
[    5.784165] device: 'ttyw7': device_add
[    5.785399] PM: Adding info for No Bus:ttyw7
[    5.786635] device: 'ttyw8': device_add
[    5.787886] PM: Adding info for No Bus:ttyw8
[    5.789076] device: 'ttyw9': device_add
[    5.790371] PM: Adding info for No Bus:ttyw9
[    5.791410] device: 'ttywa': device_add
[    5.792536] PM: Adding info for No Bus:ttywa
[    5.793829] device: 'ttywb': device_add
[    5.795122] PM: Adding info for No Bus:ttywb
[    5.796417] device: 'ttywc': device_add
[    5.797750] PM: Adding info for No Bus:ttywc
[    5.799000] device: 'ttywd': device_add
[    5.800361] PM: Adding info for No Bus:ttywd
[    5.801677] device: 'ttywe': device_add
[    5.802936] PM: Adding info for No Bus:ttywe
[    5.804180] device: 'ttywf': device_add
[    5.805455] PM: Adding info for No Bus:ttywf
[    5.806752] device: 'ttyx0': device_add
[    5.808099] PM: Adding info for No Bus:ttyx0
[    5.809381] device: 'ttyx1': device_add
[    5.810857] PM: Adding info for No Bus:ttyx1
[    5.812130] device: 'ttyx2': device_add
[    5.813488] PM: Adding info for No Bus:ttyx2
[    5.814717] device: 'ttyx3': device_add
[    5.816053] PM: Adding info for No Bus:ttyx3
[    5.817332] device: 'ttyx4': device_add
[    5.818533] PM: Adding info for No Bus:ttyx4
[    5.819727] device: 'ttyx5': device_add
[    5.821054] PM: Adding info for No Bus:ttyx5
[    5.822287] device: 'ttyx6': device_add
[    5.823594] PM: Adding info for No Bus:ttyx6
[    5.824836] device: 'ttyx7': device_add
[    5.826068] PM: Adding info for No Bus:ttyx7
[    5.827372] device: 'ttyx8': device_add
[    5.828521] PM: Adding info for No Bus:ttyx8
[    5.829748] device: 'ttyx9': device_add
[    5.831016] PM: Adding info for No Bus:ttyx9
[    5.832213] device: 'ttyxa': device_add
[    5.833586] PM: Adding info for No Bus:ttyxa
[    5.834843] device: 'ttyxb': device_add
[    5.836140] PM: Adding info for No Bus:ttyxb
[    5.837486] device: 'ttyxc': device_add
[    5.838731] PM: Adding info for No Bus:ttyxc
[    5.839979] device: 'ttyxd': device_add
[    5.841254] PM: Adding info for No Bus:ttyxd
[    5.842436] device: 'ttyxe': device_add
[    5.843772] PM: Adding info for No Bus:ttyxe
[    5.844969] device: 'ttyxf': device_add
[    5.846230] PM: Adding info for No Bus:ttyxf
[    5.847546] device: 'ttyy0': device_add
[    5.848785] PM: Adding info for No Bus:ttyy0
[    5.849940] device: 'ttyy1': device_add
[    5.851243] PM: Adding info for No Bus:ttyy1
[    5.852408] device: 'ttyy2': device_add
[    5.853713] PM: Adding info for No Bus:ttyy2
[    5.854879] device: 'ttyy3': device_add
[    5.856125] PM: Adding info for No Bus:ttyy3
[    5.857447] device: 'ttyy4': device_add
[    5.858716] PM: Adding info for No Bus:ttyy4
[    5.859945] device: 'ttyy5': device_add
[    5.861309] PM: Adding info for No Bus:ttyy5
[    5.862582] device: 'ttyy6': device_add
[    5.863920] PM: Adding info for No Bus:ttyy6
[    5.865137] device: 'ttyy7': device_add
[    5.866409] PM: Adding info for No Bus:ttyy7
[    5.867751] device: 'ttyy8': device_add
[    5.868973] PM: Adding info for No Bus:ttyy8
[    5.870267] device: 'ttyy9': device_add
[    5.871508] PM: Adding info for No Bus:ttyy9
[    5.872799] device: 'ttyya': device_add
[    5.874194] PM: Adding info for No Bus:ttyya
[    5.875335] device: 'ttyyb': device_add
[    5.876653] PM: Adding info for No Bus:ttyyb
[    5.877942] device: 'ttyyc': device_add
[    5.879158] PM: Adding info for No Bus:ttyyc
[    5.880423] device: 'ttyyd': device_add
[    5.881677] PM: Adding info for No Bus:ttyyd
[    5.882895] device: 'ttyye': device_add
[    5.884217] PM: Adding info for No Bus:ttyye
[    5.885435] device: 'ttyyf': device_add
[    5.886778] PM: Adding info for No Bus:ttyyf
[    5.888004] device: 'ttyz0': device_add
[    5.889224] PM: Adding info for No Bus:ttyz0
[    5.890524] device: 'ttyz1': device_add
[    5.891811] PM: Adding info for No Bus:ttyz1
[    5.892940] device: 'ttyz2': device_add
[    5.894255] PM: Adding info for No Bus:ttyz2
[    5.895477] device: 'ttyz3': device_add
[    5.896803] PM: Adding info for No Bus:ttyz3
[    5.897890] device: 'ttyz4': device_add
[    5.899094] PM: Adding info for No Bus:ttyz4
[    5.900422] device: 'ttyz5': device_add
[    5.901742] PM: Adding info for No Bus:ttyz5
[    5.902954] device: 'ttyz6': device_add
[    5.904284] PM: Adding info for No Bus:ttyz6
[    5.905487] device: 'ttyz7': device_add
[    5.906810] PM: Adding info for No Bus:ttyz7
[    5.908087] device: 'ttyz8': device_add
[    5.909366] PM: Adding info for No Bus:ttyz8
[    5.910765] device: 'ttyz9': device_add
[    5.912062] PM: Adding info for No Bus:ttyz9
[    5.913411] device: 'ttyza': device_add
[    5.914751] PM: Adding info for No Bus:ttyza
[    5.916047] device: 'ttyzb': device_add
[    5.917495] PM: Adding info for No Bus:ttyzb
[    5.918787] device: 'ttyzc': device_add
[    5.920129] PM: Adding info for No Bus:ttyzc
[    5.921401] device: 'ttyzd': device_add
[    5.922736] PM: Adding info for No Bus:ttyzd
[    5.924117] device: 'ttyze': device_add
[    5.925442] PM: Adding info for No Bus:ttyze
[    5.928892] device: 'ttyzf': device_add
[    5.930376] PM: Adding info for No Bus:ttyzf
[    5.931720] device: 'ttya0': device_add
[    5.933047] PM: Adding info for No Bus:ttya0
[    5.934417] device: 'ttya1': device_add
[    5.935832] PM: Adding info for No Bus:ttya1
[    5.937208] device: 'ttya2': device_add
[    5.938531] PM: Adding info for No Bus:ttya2
[    5.939838] device: 'ttya3': device_add
[    5.941227] PM: Adding info for No Bus:ttya3
[    5.942504] device: 'ttya4': device_add
[    5.943904] PM: Adding info for No Bus:ttya4
[    5.945173] device: 'ttya5': device_add
[    5.946493] PM: Adding info for No Bus:ttya5
[    5.947913] device: 'ttya6': device_add
[    5.949232] PM: Adding info for No Bus:ttya6
[    5.950591] device: 'ttya7': device_add
[    5.951906] PM: Adding info for No Bus:ttya7
[    5.953205] device: 'ttya8': device_add
[    5.954593] PM: Adding info for No Bus:ttya8
[    5.955887] device: 'ttya9': device_add
[    5.957292] PM: Adding info for No Bus:ttya9
[    5.958577] device: 'ttyaa': device_add
[    5.959949] PM: Adding info for No Bus:ttyaa
[    5.961294] device: 'ttyab': device_add
[    5.962623] PM: Adding info for No Bus:ttyab
[    5.963966] device: 'ttyac': device_add
[    5.965251] PM: Adding info for No Bus:ttyac
[    5.966613] device: 'ttyad': device_add
[    5.967982] PM: Adding info for No Bus:ttyad
[    5.969261] device: 'ttyae': device_add
[    5.970657] PM: Adding info for No Bus:ttyae
[    5.971935] device: 'ttyaf': device_add
[    5.973265] PM: Adding info for No Bus:ttyaf
[    5.974647] device: 'ttyb0': device_add
[    5.975940] PM: Adding info for No Bus:ttyb0
[    5.977263] device: 'ttyb1': device_add
[    5.978575] PM: Adding info for No Bus:ttyb1
[    5.979854] device: 'ttyb2': device_add
[    5.981222] PM: Adding info for No Bus:ttyb2
[    5.982482] device: 'ttyb3': device_add
[    5.983874] PM: Adding info for No Bus:ttyb3
[    5.985142] device: 'ttyb4': device_add
[    5.986419] PM: Adding info for No Bus:ttyb4
[    5.987827] device: 'ttyb5': device_add
[    5.989123] PM: Adding info for No Bus:ttyb5
[    5.990465] device: 'ttyb6': device_add
[    5.991783] PM: Adding info for No Bus:ttyb6
[    5.993045] device: 'ttyb7': device_add
[    5.994404] PM: Adding info for No Bus:ttyb7
[    5.995677] device: 'ttyb8': device_add
[    5.997179] PM: Adding info for No Bus:ttyb8
[    5.998395] device: 'ttyb9': device_add
[    5.999744] PM: Adding info for No Bus:ttyb9
[    6.001166] device: 'ttyba': device_add
[    6.002462] PM: Adding info for No Bus:ttyba
[    6.003822] device: 'ttybb': device_add
[    6.005088] PM: Adding info for No Bus:ttybb
[    6.006374] device: 'ttybc': device_add
[    6.007756] PM: Adding info for No Bus:ttybc
[    6.009055] device: 'ttybd': device_add
[    6.010417] PM: Adding info for No Bus:ttybd
[    6.011705] device: 'ttybe': device_add
[    6.013009] PM: Adding info for No Bus:ttybe
[    6.014358] device: 'ttybf': device_add
[    6.015701] PM: Adding info for No Bus:ttybf
[    6.017088] device: 'ttyc0': device_add
[    6.018408] PM: Adding info for No Bus:ttyc0
[    6.019708] device: 'ttyc1': device_add
[    6.021109] PM: Adding info for No Bus:ttyc1
[    6.022382] device: 'ttyc2': device_add
[    6.023787] PM: Adding info for No Bus:ttyc2
[    6.025031] device: 'ttyc3': device_add
[    6.026339] PM: Adding info for No Bus:ttyc3
[    6.027692] device: 'ttyc4': device_add
[    6.029023] PM: Adding info for No Bus:ttyc4
[    6.030366] device: 'ttyc5': device_add
[    6.031687] PM: Adding info for No Bus:ttyc5
[    6.032976] device: 'ttyc6': device_add
[    6.034292] PM: Adding info for No Bus:ttyc6
[    6.035616] device: 'ttyc7': device_add
[    6.037023] PM: Adding info for No Bus:ttyc7
[    6.038268] device: 'ttyc8': device_add
[    6.039548] PM: Adding info for No Bus:ttyc8
[    6.040937] device: 'ttyc9': device_add
[    6.042296] PM: Adding info for No Bus:ttyc9
[    6.043671] device: 'ttyca': device_add
[    6.044998] PM: Adding info for No Bus:ttyca
[    6.046278] device: 'ttycb': device_add
[    6.047701] PM: Adding info for No Bus:ttycb
[    6.048982] device: 'ttycc': device_add
[    6.050361] PM: Adding info for No Bus:ttycc
[    6.051658] device: 'ttycd': device_add
[    6.053012] PM: Adding info for No Bus:ttycd
[    6.054381] device: 'ttyce': device_add
[    6.055668] PM: Adding info for No Bus:ttyce
[    6.057023] device: 'ttycf': device_add
[    6.058341] PM: Adding info for No Bus:ttycf
[    6.059621] device: 'ttyd0': device_add
[    6.060996] PM: Adding info for No Bus:ttyd0
[    6.062246] device: 'ttyd1': device_add
[    6.063623] PM: Adding info for No Bus:ttyd1
[    6.064835] device: 'ttyd2': device_add
[    6.066143] PM: Adding info for No Bus:ttyd2
[    6.067550] device: 'ttyd3': device_add
[    6.068865] PM: Adding info for No Bus:ttyd3
[    6.070239] device: 'ttyd4': device_add
[    6.071507] PM: Adding info for No Bus:ttyd4
[    6.072734] device: 'ttyd5': device_add
[    6.074112] PM: Adding info for No Bus:ttyd5
[    6.075385] device: 'ttyd6': device_add
[    6.076811] PM: Adding info for No Bus:ttyd6
[    6.078107] device: 'ttyd7': device_add
[    6.079431] PM: Adding info for No Bus:ttyd7
[    6.080808] device: 'ttyd8': device_add
[    6.082093] PM: Adding info for No Bus:ttyd8
[    6.083409] device: 'ttyd9': device_add
[    6.084729] PM: Adding info for No Bus:ttyd9
[    6.086006] device: 'ttyda': device_add
[    6.087424] PM: Adding info for No Bus:ttyda
[    6.088701] device: 'ttydb': device_add
[    6.090080] PM: Adding info for No Bus:ttydb
[    6.091365] device: 'ttydc': device_add
[    6.092645] PM: Adding info for No Bus:ttydc
[    6.093983] device: 'ttydd': device_add
[    6.095273] PM: Adding info for No Bus:ttydd
[    6.096544] device: 'ttyde': device_add
[    6.097908] PM: Adding info for No Bus:ttyde
[    6.099175] device: 'ttydf': device_add
[    6.100560] PM: Adding info for No Bus:ttydf
[    6.101829] device: 'ttye0': device_add
[    6.103129] PM: Adding info for No Bus:ttye0
[    6.104508] device: 'ttye1': device_add
[    6.105844] PM: Adding info for No Bus:ttye1
[    6.107194] device: 'ttye2': device_add
[    6.108500] PM: Adding info for No Bus:ttye2
[    6.109769] device: 'ttye3': device_add
[    6.111163] PM: Adding info for No Bus:ttye3
[    6.112427] device: 'ttye4': device_add
[    6.113786] PM: Adding info for No Bus:ttye4
[    6.115042] device: 'ttye5': device_add
[    6.116360] PM: Adding info for No Bus:ttye5
[    6.117755] device: 'ttye6': device_add
[    6.119176] PM: Adding info for No Bus:ttye6
[    6.120562] device: 'ttye7': device_add
[    6.121897] PM: Adding info for No Bus:ttye7
[    6.123136] device: 'ttye8': device_add
[    6.124519] PM: Adding info for No Bus:ttye8
[    6.125784] device: 'ttye9': device_add
[    6.127219] PM: Adding info for No Bus:ttye9
[    6.128460] device: 'ttyea': device_add
[    6.129803] PM: Adding info for No Bus:ttyea
[    6.131174] device: 'ttyeb': device_add
[    6.132501] PM: Adding info for No Bus:ttyeb
[    6.133854] device: 'ttyec': device_add
[    6.135128] PM: Adding info for No Bus:ttyec
[    6.136345] device: 'ttyed': device_add
[    6.137738] PM: Adding info for No Bus:ttyed
[    6.139057] device: 'ttyee': device_add
[    6.140442] PM: Adding info for No Bus:ttyee
[    6.141706] device: 'ttyef': device_add
[    6.142976] PM: Adding info for No Bus:ttyef
[    6.144299] r3964: Philips r3964 Driver $Revision: 1.10 $
[    6.145810] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.147841] Registering platform device 'serial8250'. Parent at platform
[    6.149749] device: 'serial8250': device_add
[    6.151064] bus: 'platform': add device serial8250
[    6.152476] PM: Adding info for platform:serial8250
[    6.180200] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    6.184532] device: 'ttyS0': device_add
[    6.186268] PM: Adding info for No Bus:ttyS0
[    6.187891] device: 'ttyS1': device_add
[    6.189195] PM: Adding info for No Bus:ttyS1
[    6.190592] device: 'ttyS2': device_add
[    6.191986] PM: Adding info for No Bus:ttyS2
[    6.193435] device: 'ttyS3': device_add
[    6.194860] PM: Adding info for No Bus:ttyS3
[    6.196147] bus: 'platform': add driver serial8250
[    6.197551] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    6.199987] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    6.202420] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    6.204386] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    6.206527] bus: 'pci': add driver serial
[    6.207855] bus: 'platform': add driver uart-sccnxp
[    6.209303] bus: 'platform': add driver altera_uart
[    6.210791] bus: 'platform': add driver goldfish_tty
[    6.212350] device: 'ttyprintk': device_add
[    6.213806] PM: Adding info for No Bus:ttyprintk
[    6.215165] device class 'virtio-ports': registering
[    6.216562] bus: 'virtio': add driver virtio_console
[    6.220141] bus: 'virtio': add driver virtio_rproc_serial
[    6.221798] device class 'raw': registering
[    6.222989] device: 'rawctl': device_add
[    6.224438] PM: Adding info for No Bus:rawctl
[    6.225729] device class 'printer': registering
[    6.227235] lp: driver loaded but no devices found
[    6.228523] bus: 'platform': add driver timeriomem_rng
[    6.230158] bus: 'virtio': add driver virtio_rng
[    6.231512] device class 'ppdev': registering
[    6.232780] ppdev: user-space parallel port driver
[    6.234154] scx200_gpio: no SCx200 gpio present
[    6.235417] Registering platform device 'pc8736x_gpio.0'. Parent at platform
[    6.237544] device: 'pc8736x_gpio.0': device_add
[    6.238854] bus: 'platform': add device pc8736x_gpio.0
[    6.240363] PM: Adding info for platform:pc8736x_gpio.0
[    6.241817] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    6.243838] platform pc8736x_gpio.0: no device found
[    6.245313] bus: 'platform': remove device pc8736x_gpio.0
[    6.248860] PM: Removing info for platform:pc8736x_gpio.0
[    6.250452] nsc_gpio initializing
[    6.251431] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    6.252894] smapi::smapi_init, ERROR invalid usSmapiID
[    6.254327] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    6.256999] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    6.258941] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    6.260668] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    6.263044] Hangcheck: Using getrawmonotonic().
[    6.264382] bus: 'platform': add driver parport_pc
[    6.265791] bus: 'pnp': add driver parport_pc
[    6.269117] bus: 'pnp': driver_probe_device: matched device 00:04 with driver parport_pc
[    6.271206] bus: 'pnp': really_probe: probing driver parport_pc with device 00:04
[    6.273187] parport_pc 00:04: reported by Plug and Play ACPI
[    6.275093] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    6.360907] device: 'parport0': device_add
[    6.363316] PM: Adding info for No Bus:parport0
[    6.364915] device: 'lp0': device_add
[    6.367385] PM: Adding info for No Bus:lp0
[    6.368607] lp0: using parport0 (interrupt-driven).
[    6.369904] driver: '00:04': driver_bound: bound to device 'parport_pc'
[    6.372883] bus: 'pnp': really_probe: bound device 00:04 to driver parport_pc
[    6.374886] Registering platform device 'parport_pc.956'. Parent at platform
[    6.378551] device: 'parport_pc.956': device_add
[    6.379853] bus: 'platform': add device parport_pc.956
[    6.381317] PM: Adding info for platform:parport_pc.956
[    6.384804] bus: 'platform': driver_probe_device: matched device parport_pc.956 with driver parport_pc
[    6.389066] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.956
[    6.393723] driver: 'parport_pc.956': driver_bound: bound to device 'parport_pc'
[    6.395706] bus: 'platform': really_probe: bound device parport_pc.956 to driver parport_pc
[    6.399683] bus: 'platform': remove device parport_pc.956
[    6.401251] PM: Removing info for platform:parport_pc.956
[    6.404275] Registering platform device 'parport_pc.888'. Parent at platform
[    6.406180] device: 'parport_pc.888': device_add
[    6.407496] bus: 'platform': add device parport_pc.888
[    6.408939] PM: Adding info for platform:parport_pc.888
[    6.410424] bus: 'platform': driver_probe_device: matched device parport_pc.888 with driver parport_pc
[    6.412921] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.888
[    6.415341] driver: 'parport_pc.888': driver_bound: bound to device 'parport_pc'
[    6.417379] bus: 'platform': really_probe: bound device parport_pc.888 to driver parport_pc
[    6.419719] bus: 'platform': remove device parport_pc.888
[    6.421151] PM: Removing info for platform:parport_pc.888
[    6.422665] Registering platform device 'parport_pc.632'. Parent at platform
[    6.424558] device: 'parport_pc.632': device_add
[    6.425820] bus: 'platform': add device parport_pc.632
[    6.427339] PM: Adding info for platform:parport_pc.632
[    6.428843] bus: 'platform': driver_probe_device: matched device parport_pc.632 with driver parport_pc
[    6.431323] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.632
[    6.433717] driver: 'parport_pc.632': driver_bound: bound to device 'parport_pc'
[    6.435729] bus: 'platform': really_probe: bound device parport_pc.632 to driver parport_pc
[    6.438341] bus: 'platform': remove device parport_pc.632
[    6.439868] PM: Removing info for platform:parport_pc.632
[    6.441474] bus: 'pci': add driver parport_pc
[    6.442972] bus: 'isa': registered
[    6.443961] device: 'isa': device_add
[    6.445024] PM: Adding info for No Bus:isa
[    6.448088] bus: 'platform': add driver floppy
[    6.449878] Floppy drive(s):[    6.450387] device: '1:0': device_add
[    6.450519] PM: Adding info for No Bus:1:0
[    6.450628] device: 'ram0': device_add
 fd0 is 1.44M
[    6.459143] PM: Adding info for No Bus:ram0
[    6.461031] device: '1:1': device_add
[    6.462439] PM: Adding info for No Bus:1:1
[    6.464024] device: 'ram1': device_add
[    6.465761] PM: Adding info for No Bus:ram1
[    6.467702] device: '1:2': device_add
[    6.469136] PM: Adding info for No Bus:1:2
[    6.470754] device: 'ram2': device_add
[    6.472365] PM: Adding info for No Bus:ram2
[    6.484470] device: '1:3': device_add
[    6.485796] PM: Adding info for No Bus:1:3
[    6.487045] FDC 0 is a S82078B
[    6.487608] Registering platform device 'floppy.0'. Parent at platform
[    6.487617] device: 'floppy.0': device_add
[    6.487667] bus: 'platform': add device floppy.0
[    6.487761] PM: Adding info for platform:floppy.0
[    6.487827] bus: 'platform': driver_probe_device: matched device floppy.0 with driver floppy
[    6.487832] bus: 'platform': really_probe: probing driver floppy with device floppy.0
[    6.487869] driver: 'floppy.0': driver_bound: bound to device 'floppy'
[    6.487874] bus: 'platform': really_probe: bound device floppy.0 to driver floppy
[    6.487944] device: '2:0': device_add
[    6.488105] PM: Adding info for No Bus:2:0
[    6.488232] device: 'fd0': device_add
[    6.488568] PM: Adding info for No Bus:fd0
[    6.513655] device: 'ram3': device_add
[    6.517267] PM: Adding info for No Bus:ram3
[    6.518788] device: '1:4': device_add
[    6.519726] PM: Adding info for No Bus:1:4
[    6.521027] device: 'ram4': device_add
[    6.524657] PM: Adding info for No Bus:ram4
[    6.526237] device: '1:5': device_add
[    6.528414] PM: Adding info for No Bus:1:5
[    6.529814] device: 'ram5': device_add
[    6.533794] PM: Adding info for No Bus:ram5
[    6.535403] device: '1:6': device_add
[    6.536619] PM: Adding info for No Bus:1:6
[    6.538232] device: 'ram6': device_add
[    6.541216] PM: Adding info for No Bus:ram6
[    6.542757] device: '1:7': device_add
[    6.543964] PM: Adding info for No Bus:1:7
[    6.545259] device: 'ram7': device_add
[    6.547205] PM: Adding info for No Bus:ram7
[    6.548766] device: '1:8': device_add
[    6.549944] PM: Adding info for No Bus:1:8
[    6.551249] device: 'ram8': device_add
[    6.554797] PM: Adding info for No Bus:ram8
[    6.557062] device: '1:9': device_add
[    6.558273] PM: Adding info for No Bus:1:9
[    6.559589] device: 'ram9': device_add
[    6.562776] PM: Adding info for No Bus:ram9
[    6.564399] device: '1:10': device_add
[    6.565533] PM: Adding info for No Bus:1:10
[    6.567234] device: 'ram10': device_add
[    6.568764] PM: Adding info for No Bus:ram10
[    6.570283] device: '1:11': device_add
[    6.571509] PM: Adding info for No Bus:1:11
[    6.572841] device: 'ram11': device_add
[    6.574358] PM: Adding info for No Bus:ram11
[    6.575869] device: '1:12': device_add
[    6.577181] PM: Adding info for No Bus:1:12
[    6.578478] device: 'ram12': device_add
[    6.579903] PM: Adding info for No Bus:ram12
[    6.581469] device: '1:13': device_add
[    6.582678] PM: Adding info for No Bus:1:13
[    6.584039] device: 'ram13': device_add
[    6.585450] PM: Adding info for No Bus:ram13
[    6.587132] device: '1:14': device_add
[    6.588280] PM: Adding info for No Bus:1:14
[    6.589516] device: 'ram14': device_add
[    6.591005] PM: Adding info for No Bus:ram14
[    6.592465] device: '1:15': device_add
[    6.593744] PM: Adding info for No Bus:1:15
[    6.594961] device: 'ram15': device_add
[    6.596391] PM: Adding info for No Bus:ram15
[    6.598013] brd: module loaded
[    6.598949] device: 'loop-control': device_add
[    6.600569] PM: Adding info for No Bus:loop-control
[    6.602282] device: '7:0': device_add
[    6.603597] PM: Adding info for No Bus:7:0
[    6.604931] device: 'loop0': device_add
[    6.606356] PM: Adding info for No Bus:loop0
[    6.608072] device: '7:1': device_add
[    6.609264] PM: Adding info for No Bus:7:1
[    6.610545] device: 'loop1': device_add
[    6.611962] PM: Adding info for No Bus:loop1
[    6.613613] device: '7:2': device_add
[    6.614810] PM: Adding info for No Bus:7:2
[    6.616088] device: 'loop2': device_add
[    6.617629] PM: Adding info for No Bus:loop2
[    6.619220] device: '7:3': device_add
[    6.620474] PM: Adding info for No Bus:7:3
[    6.621748] device: 'loop3': device_add
[    6.623221] PM: Adding info for No Bus:loop3
[    6.624858] device: '7:4': device_add
[    6.626039] PM: Adding info for No Bus:7:4
[    6.627432] device: 'loop4': device_add
[    6.628873] PM: Adding info for No Bus:loop4
[    6.630611] device: '7:5': device_add
[    6.631800] PM: Adding info for No Bus:7:5
[    6.633097] device: 'loop5': device_add
[    6.634549] PM: Adding info for No Bus:loop5
[    6.636136] device: '7:6': device_add
[    6.637421] PM: Adding info for No Bus:7:6
[    6.638724] device: 'loop6': device_add
[    6.640234] PM: Adding info for No Bus:loop6
[    6.641823] device: '7:7': device_add
[    6.642999] PM: Adding info for No Bus:7:7
[    6.644398] device: 'loop7': device_add
[    6.645779] PM: Adding info for No Bus:loop7
[    6.647341] loop: module loaded
[    6.648460] device class 'pktcdvd': registering
[    6.649876] device: 'pktcdvd': device_add
[    6.651393] PM: Adding info for No Bus:pktcdvd
[    6.666737] bus: 'virtio': add driver virtio_blk
[    6.668222] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    6.670282] device class 'c2port': registering
[    6.671680] device: 'c2port0': device_add
[    6.673018] PM: Adding info for No Bus:c2port0
[    6.674418] c2port c2port0: C2 port uc added
[    6.675581] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    6.677930] bus: 'platform': add driver kim
[    6.679227] bus: 'platform': add driver ti_tscadc
[    6.680732] bus: 'platform': add driver nfcwilink
[    6.682154] device class 'spi_transport': registering
[    6.683815] device class 'spi_host': registering
[    6.685181] Loading iSCSI transport class v2.0-870.
[    6.686544] device class 'iscsi_transport': registering
[    6.688253] device class 'iscsi_endpoint': registering
[    6.689770] device class 'iscsi_iface': registering
[    6.691274] device class 'iscsi_host': registering
[    6.692719] device class 'iscsi_connection': registering
[    6.694344] device class 'iscsi_session': registering
[    6.695979] bus: 'iscsi_flashnode': registered
[    6.716755] device class 'sas_host': registering
[    6.718780] device class 'sas_phy': registering
[    6.720403] device class 'sas_port': registering
[    6.722032] device class 'sas_device': registering
[    6.726980] device class 'sas_end_device': registering
[    6.739388] device class 'sas_expander': registering
[    6.741199] hp_sw: device handler registered
[    6.742622] emc: device handler registered
[    6.744010] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    6.746889] device class 'scsi_tape': registering
[    6.748789] bus: 'scsi': add driver st
[    6.750109] osst :I: Tape driver with OnStream support version 0.99.4
[    6.750109] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    6.754400] device class 'onstream_tape': registering
[    6.756168] bus: 'scsi': add driver osst
[    6.759240] device class 'scsi_disk': registering
[    6.763734] bus: 'scsi': add driver sd
[    6.765082] device class 'scsi_generic': registering
[    6.766948] SCSI Media Changer driver v0.25 
[    6.768284] device class 'scsi_changer': registering
[    6.769918] bus: 'scsi': add driver ch
[    6.771328] bus: 'platform': add driver highbank-ahci
[    6.773027] bus: 'pci': add driver sata_mv
[    6.774512] bus: 'platform': add driver sata_mv
[    6.778243] bus: 'pnp': add driver pata_isapnp
[    6.779800] bus: 'platform': add driver pata_platform
[    6.781541] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    6.784567] device: 'eql': device_add
[    6.786234] PM: Adding info for No Bus:eql
[    6.789537] bus: 'mdio_bus': add driver Marvell 88E1101
[    6.791386] bus: 'mdio_bus': add driver Marvell 88E1112
[    6.793193] bus: 'mdio_bus': add driver Marvell 88E1111
[    6.797159] bus: 'mdio_bus': add driver Marvell 88E1118
[    6.798993] bus: 'mdio_bus': add driver Marvell 88E1121R
[    6.800882] bus: 'mdio_bus': add driver Marvell 88E1318S
[    6.802710] bus: 'mdio_bus': add driver Marvell 88E1145
[    6.804523] bus: 'mdio_bus': add driver Marvell 88E1149R
[    6.806342] bus: 'mdio_bus': add driver Marvell 88E1240
[    6.808231] bus: 'mdio_bus': add driver LXT970
[    6.809793] bus: 'mdio_bus': add driver LXT971
[    6.811324] bus: 'mdio_bus': add driver LXT973-A2
[    6.812962] bus: 'mdio_bus': add driver LXT973
[    6.814517] bus: 'mdio_bus': add driver SMSC LAN83C185
[    6.816281] bus: 'mdio_bus': add driver SMSC LAN8187
[    6.818094] bus: 'mdio_bus': add driver SMSC LAN8700
[    6.819819] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[    6.821923] bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720
[    6.823892] bus: 'mdio_bus': add driver Vitesse VSC8244
[    6.825657] bus: 'mdio_bus': add driver Vitesse VSC8221
[    6.827494] bus: 'mdio_bus': add driver Broadcom BCM8706
[    6.829288] bus: 'mdio_bus': add driver Broadcom BCM8727
[    6.831142] bus: 'mdio_bus': add driver ICPlus IP175C
[    6.832862] bus: 'mdio_bus': add driver ICPlus IP1001
[    6.834631] bus: 'mdio_bus': add driver ICPlus IP101A/G
[    6.836452] bus: 'mdio_bus': add driver RTL8211B Gigabit Ethernet
[    6.838674] bus: 'mdio_bus': add driver RTL8211E Gigabit Ethernet
[    6.840838] bus: 'mdio_bus': add driver STe101p
[    6.842513] bus: 'mdio_bus': add driver STe100p
[    6.844139] bus: 'mdio_bus': add driver Atheros 8035 ethernet
[    6.846179] bus: 'mdio_bus': add driver Atheros 8030 ethernet
[    6.848511] tun: Universal TUN/TAP device driver, 1.6
[    6.850255] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    6.852413] device: 'tun': device_add
[    6.856770] PM: Adding info for No Bus:tun
[    6.858257] arcnet loaded.
[    6.859235] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[    6.861743] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[    6.864387] arcnet: raw mode (`r') encapsulation support loaded.
[    6.866516] arcnet: COM90xx chipset support
[    7.177707] S3: No ARCnet cards found.
[    7.179080] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
[    7.181524] E-mail me if you actually test this driver, please!
[    7.183469]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
[    7.188238] arcnet: RIM I (entirely mem-mapped) support
[    7.195067] E-mail me if you actually test the RIM I driver, please!
[    7.197322] Given: node 00h, shmem 0h, irq 0
[    7.198719] No autoprobe for RIM I; you must specify the shmem and irq!
[    7.200935] bus: 'platform': add driver calxedaxgmac
[    7.202715] bus: 'platform': add driver dnet
[    7.204282] bus: 'pci': add driver hp100
[    7.205713] bus: 'platform': add driver ethoc
[    7.207325] atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
[    7.209839] bus: 'platform': add driver nsc-ircc
[    7.211554] bus: 'pnp': add driver nsc-ircc
[    7.213318] bus: 'platform': remove driver nsc-ircc
[    7.215074] driver: 'nsc-ircc': driver_release
[    7.216661] bus: 'pnp': remove driver nsc-ircc
[    7.218205] driver: 'nsc-ircc': driver_release
[    7.220098] bus: 'platform': add driver ali-ircc
[    7.222037] bus: 'platform': remove driver ali-ircc
[    7.223717] driver: 'ali-ircc': driver_release
[    7.229853] device: 'plip0': device_add
[    7.231677] PM: Adding info for No Bus:plip0
[    7.233425] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    7.235207] plip0: Parallel port at 0x378, using IRQ 7.
[    7.236986] PPP generic driver version 2.4.2
[    7.238496] device class 'ppp': registering
[    7.239964] device: 'ppp': device_add
[    7.241462] PM: Adding info for No Bus:ppp
[    7.242939] PPP BSD Compression module registered
[    7.244553] PPP Deflate Compression module registered
[    7.246252] PPP MPPE Compression module registered
[    7.247989] bus: 'pnp': add driver sb1000
[    7.249389] hdlc: HDLC support module revision 1.22
[    7.251129] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    7.253147] SDLA driver v0.30, 12 Sep 1996, mike.mclagan@linux.org.
[    7.255329] device: 'sdla0': device_add
[    7.257104] PM: Adding info for No Bus:sdla0
[    7.258904] libertas_sdio: Libertas SDIO driver
[    7.260490] libertas_sdio: Copyright Pierre Ossman
[    7.262147] bus: 'sdio': add driver libertas_sdio
[    7.263934] parport0: cannot grant exclusive access for device ks0108
[    7.266144] ks0108: ERROR: parport didn't register new device
[    7.268240] device class 'aoe': registering
[    7.269791] device: 'err': device_add
[    7.271308] PM: Adding info for No Bus:err
[    7.272769] device: 'discover': device_add
[    7.274378] PM: Adding info for No Bus:discover
[    7.276039] device: 'interfaces': device_add
[    7.277710] PM: Adding info for No Bus:interfaces
[    7.279344] device: 'revalidate': device_add
[    7.281083] PM: Adding info for No Bus:revalidate
[    7.282708] device: 'flush': device_add
[    7.284232] PM: Adding info for No Bus:flush
[    7.295715] aoe: AoE v81 initialised.
[    7.297194] paride: aten registered as protocol 0
[    7.298760] paride: bpck registered as protocol 1
[    7.300296] paride: comm registered as protocol 2
[    7.301854] paride: dstr registered as protocol 3
[    7.303370] paride: k951 registered as protocol 4
[    7.304894] paride: k971 registered as protocol 5
[    7.306343] paride: epat registered as protocol 6
[    7.307970] paride: epia registered as protocol 7
[    7.309465] paride: friq registered as protocol 8
[    7.311029] paride: on20 registered as protocol 9
[    7.312510] paride: ktti registered as protocol 10
[    7.314035] bpck6: BACKPACK Protocol Driver V2.0.2
[    7.315555] bpck6: Copyright 2001 by Micro Solutions, Inc., DeKalb IL. USA
[    7.317675] paride: bpck6 registered as protocol 11
[    7.319282] pcd: pcd version 1.07, major 46, nice 0
[   14.172838] pcd0: Autoprobe failed
[   14.174080] pcd: No CD-ROM drive found
[   14.175424] pg: pg version 1.02, major 97
[   20.978409] pga: Autoprobe failed
[   20.979293] pg: No ATAPI device detected
[   20.980292] bus: 'platform': add driver dwc3
[   20.981439] bus: 'platform': add driver omap-dwc3
[   20.982649] bus: 'platform': add driver exynos-dwc3
[   20.984017] bus: 'pci': add driver dwc3-pci
[   20.985184] bus: 'platform': add driver rcar_usb_phy
[   20.986483] bus: 'platform': add driver ci_hdrc
[   20.989756] bus: 'platform': add driver msm_hsusb
[   20.991034] bus: 'pci': add driver ci13xxx_pci
[   20.992282] bus: 'pci': add driver net2272
[   20.993387] bus: 'platform': add driver net2272
[   20.994554] bus: 'platform': add driver m66592_udc
[   20.995845] bus: 'platform': remove driver m66592_udc
[   20.997243] driver: 'm66592_udc': driver_release
[   20.998442] bus: 'platform': add driver r8a66597_udc
[   20.999721] bus: 'platform': remove driver r8a66597_udc
[   21.001097] driver: 'r8a66597_udc': driver_release
[   21.002430] bus: 'platform': add driver mv-udc
[   21.003688] bus: 'platform': add driver fusb300_udc
[   21.004948] bus: 'platform': remove driver fusb300_udc
[   21.006282] driver: 'fusb300_udc': driver_release
[   21.007537] bus: 'platform': add driver mv-u3d
[   21.008798] bus: 'pnp': add driver i8042 kbd
[   21.009879] bus: 'pnp': driver_probe_device: matched device 00:01 with driver i8042 kbd
[   21.011878] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:01
[   21.013763] driver: '00:01': driver_bound: bound to device 'i8042 kbd'
[   21.015432] bus: 'pnp': really_probe: bound device 00:01 to driver i8042 kbd
[   21.017377] bus: 'pnp': add driver i8042 aux
[   21.018476] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 aux
[   21.020494] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:02
[   21.022375] driver: '00:02': driver_bound: bound to device 'i8042 aux'
[   21.024030] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 aux
[   21.025885] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   21.028124] Registering platform device 'i8042'. Parent at platform
[   21.029699] device: 'i8042': device_add
[   21.030733] bus: 'platform': add device i8042
[   21.031935] PM: Adding info for platform:i8042
[   21.033123] bus: 'platform': add driver i8042
[   21.034274] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   21.036261] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   21.041546] serio: i8042 KBD port at 0x60,0x64 irq 1
[   21.042957] serio: i8042 AUX port at 0x60,0x64 irq 12
[   21.044325] device: 'serio0': device_add
[   21.045386] bus: 'serio': add device serio0
[   21.046704] PM: Adding info for serio:serio0
[   21.048036] driver: 'i8042': driver_bound: bound to device 'i8042'
[   21.049698] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   21.051727] bus: 'serio': add driver ps2mult
[   21.054863] device: 'serio1': device_add
[   21.056078] bus: 'serio': add device serio1
[   21.057404] PM: Adding info for serio:serio1
[   21.058748] bus: 'serio': add driver serio_raw
[   21.060272] device: 'mice': device_add
[   21.061473] PM: Adding info for No Bus:mice
[   21.064796] device: 'psaux': device_add
[   21.066059] PM: Adding info for No Bus:psaux
[   21.067319] mousedev: PS/2 mouse device common for all mice
[   21.068940] device: 'event0': device_add
[   21.070233] PM: Adding info for No Bus:event0
[   21.073519] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[   21.075678] bus: 'serio': add driver atkbd
[   21.079030] bus: 'platform': add driver cros-ec-keyb
[   21.080452] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   21.082520] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   21.085335] device: 'input1': device_add
[   21.088829] PM: Adding info for No Bus:input1
[   21.090265] bus: 'platform': add driver goldfish_events
[   21.091789] bus: 'serio': add driver lkkbd
[   21.092875] bus: 'platform': add driver matrix-keypad
[   21.094178] bus: 'serio': add driver newtonkbd
[   21.095425] bus: 'serio': add driver stowaway
[   21.098820] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   21.101283] device: 'event1': device_add
[   21.102581] PM: Adding info for No Bus:event1
[   21.103771] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[   21.106001] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   21.110886] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   21.112905] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[   21.115256] bus: 'serio': really_probe: probing driver atkbd with device serio1
[   21.117529] bus: 'serio': add driver dynapro
[   21.118903] bus: 'serio': add driver inexio
[   21.120228] bus: 'serio': add driver mtouch
[   21.123590] mk712: device not present
[   21.124656] bus: 'serio': add driver serio-penmount
[   21.126200] bus: 'platform': add driver tsc
[   21.131633] bus: 'serio': add driver touchit213
[   21.133055] bus: 'serio': add driver touchright
[   21.134484] bus: 'serio': add driver touchwin
[   21.135828] bus: 'serio': add driver w8001
[   21.137520] atkbd: probe of serio1 rejects match -19
[   21.139201] Colour QuickCam for Video4Linux v0.06
[   21.662974] ------------[ cut here ]------------
[   21.664255] WARNING: at /c/kernel-tests/src/linux/drivers/media/v4l2-core/videobuf2-core.c:2065 vb2_queue_init+0xe5/0x1c0()
[   21.667066] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00088-g459e3a1 #11
[   21.668980] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   21.670412]  00000000 00000000 b011beb8 b18885c1 b011bee0 b1034d2a b1a88345 b1b0fe2c
[   21.672545]  00000811 b16d6545 b16d6545 bea75290 bea75438 bea74e30 b011bef0 b1034ded
[   21.674742]  00000009 00000000 b011befc b16d6545 be8675c0 b011bf30 b16d9c4d 00000000
[   21.676946] Call Trace:
[   21.677616]  [<b18885c1>] dump_stack+0x16/0x18
[   21.678762]  [<b1034d2a>] warn_slowpath_common+0x5a/0x80
[   21.680162]  [<b16d6545>] ? vb2_queue_init+0xe5/0x1c0
[   21.681412]  [<b16d6545>] ? vb2_queue_init+0xe5/0x1c0
[   21.682686]  [<b1034ded>] warn_slowpath_null+0x1d/0x20
[   21.683997]  [<b16d6545>] vb2_queue_init+0xe5/0x1c0
[   21.685202]  [<b16d9c4d>] bwqcam_attach+0x1ed/0x580
[   21.686420]  [<b1572b5d>] parport_register_driver+0x2d/0x70
[   21.687935]  [<b1c0cf89>] ? cqcam_init+0x1c/0x1c
[   21.689094]  [<b1c0cf96>] init_bw_qcams+0xd/0xf
[   21.690266]  [<b1bd3b01>] do_one_initcall+0x7f/0x117
[   21.691538]  [<b1bd3cad>] kernel_init_freeable+0x114/0x1b3
[   21.692937]  [<b1bd3470>] ? loglevel+0x2b/0x2b
[   21.694109]  [<b18733db>] kernel_init+0xb/0xd0
[   21.695248]  [<b1890937>] ret_from_kernel_thread+0x1b/0x28
[   21.696651]  [<b18733d0>] ? rest_init+0x130/0x130
[   21.699987] ---[ end trace 9a47d6e6562435f6 ]---
[   22.715405] No Quickcam found on port parport0
[   22.716731] Quickcam detection counter: 0
[   22.764112] device: 'pps0': device_add
[   22.765471] PM: Adding info for No Bus:pps0
[   22.766669] pps pps0: new PPS source ktimer
[   22.767932] pps pps0: ktimer PPS source registered
[   22.769236] pps_ldisc: PPS line discipline registered
[   22.770624] bus: 'platform': add driver pps-gpio
[   22.771919] bus: 'pci': add driver ptp_pch
[   22.776196] Driver for 1-wire Dallas network protocol.
[   22.777696] bus: 'w1': registered
[   22.778577] bus: 'w1': add driver w1_master_driver
[   22.779941] bus: 'w1': add driver w1_slave_driver
[   22.781375] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   22.783052] bus: 'platform': add driver ds1wm
[   22.784415] bus: 'platform': add driver ds2781-battery
[   22.785844] bus: 'platform': add driver goldfish-battery
[   22.787468] bus: 'platform': add driver bq27000-battery
[   22.789010] bus: 'platform': add driver isp1704_charger
[   22.790531] bus: 'platform': add driver max8903-charger
[   22.792009] bus: 'platform': add driver gpio-charger
[   22.793441] applesmc: supported laptop not found!
[   22.794698] applesmc: driver init failed (ret=-19)!
[   22.796136] f71882fg: Not a Fintek device
[   22.797380] f71882fg: Not a Fintek device
[   22.798430] bus: 'platform': add driver gpio-fan
[   22.799796] bus: 'platform': add driver max197
[   22.801239] bus: 'platform': add driver sht15
[   22.802685] lguest: mapped switcher at ffe66000
[   22.803991] device: 'lguest': device_add
[   22.805270] PM: Adding info for No Bus:lguest
[   22.806621] cpufreq-nforce2: No nForce2 chipset.
[   22.807978] cpuidle: using governor ladder
[   22.809058] bus: 'mmc': add driver mmcblk
[   22.810304] bus: 'sdio': add driver sdio_uart
[   22.811519] sdhci: Secure Digital Host Controller Interface driver
[   22.813187] sdhci: Copyright(c) Pierre Ossman
[   22.814353] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   22.815961] wbsd: Copyright(c) Pierre Ossman
[   22.817233] bus: 'pnp': add driver wbsd
[   22.818501] bus: 'platform': add driver leds-gpio
[   22.819810] bus: 'platform': add driver leds-ot200
[   22.821229] bus: 'platform': add driver leds-regulator
[   22.822668] bus: 'platform': add driver leds-lt3593
[   22.823873] ledtrig-cpu: registered to indicate activity on CPUs
[   22.825971] Registering platform device 'dell_rbu'. Parent at platform
[   22.827774] device: 'dell_rbu': device_add
[   22.828932] bus: 'platform': add device dell_rbu
[   22.830243] PM: Adding info for platform:dell_rbu
[   22.831630] bus: 'platform': add driver ssbi
[   22.832990] bus: 'hid': registered
[   22.834053] device: 'uhid': device_add
[   22.835214] PM: Adding info for No Bus:uhid
[   22.836346] bus: 'hid': add driver hid-generic
[   22.837601] bus: 'hid': add driver a4tech
[   22.838818] bus: 'hid': add driver acrux
[   22.839566] bus: 'hid': add driver belkin
[   22.840310] bus: 'hid': add driver chicony
[   22.841055] bus: 'hid': add driver hkems
[   22.841749] bus: 'hid': add driver elecom
[   22.842461] bus: 'hid': add driver ezkey
[   22.843159] bus: 'hid': add driver gyration
[   22.843931] bus: 'hid': add driver kensington
[   22.844686] bus: 'hid': add driver keytouch
[   22.845422] bus: 'hid': add driver kye
[   22.846111] bus: 'hid': add driver LC RC1000MCE
[   22.847021] bus: 'hid': add driver logitech
[   22.848258] bus: 'hid': add driver magicmouse
[   22.849530] bus: 'hid': add driver microsoft
[   22.850793] bus: 'hid': add driver monterey
[   22.852020] bus: 'hid': add driver hid-multitouch
[   22.853327] bus: 'hid': add driver pantherlord
[   22.854615] bus: 'hid': add driver petalynx
[   22.855821] bus: 'hid': add driver hid-picolcd
[   22.857161] bus: 'hid': add driver primax
[   22.858382] bus: 'hid': add driver saitek
[   22.859568] bus: 'hid': add driver samsung
[   22.860793] bus: 'hid': add driver speedlink
[   22.862058] bus: 'hid': add driver steelseries_srws1
[   22.863510] bus: 'hid': add driver sunplus
[   22.864615] bus: 'hid': add driver greenasia
[   22.865850] bus: 'hid': add driver thrustmaster
[   22.867193] bus: 'hid': add driver tivo_slide
[   22.868433] bus: 'hid': add driver twinhan
[   22.869618] bus: 'hid': add driver zeroplus
[   22.870887] bus: 'hid': add driver wacom
[   22.872043] bus: 'hid': add driver waltop
[   22.873251] device: 'vhost-net': device_add
[   22.874625] PM: Adding info for No Bus:vhost-net
[   22.981345] device: 'lcd': device_add
[   22.982630] PM: Adding info for No Bus:lcd
[   22.984035] device: 'keypad': device_add
[   22.985422] PM: Adding info for No Bus:keypad
[   22.986897] panel: driver version 0.9.5 registered on parport0 (io=0x378).
[   22.989063] device: '252:0': device_add
[   22.990436] PM: Adding info for No Bus:252:0
[   22.991826] device: 'zram0': device_add
[   22.993194] PM: Adding info for No Bus:zram0
[   22.994864] zram: Created 1 device(s) ...
[   22.996602] device: 'ashmem': device_add
[   22.998114] PM: Adding info for No Bus:ashmem
[   22.999449] ashmem: initialized
[   23.000569] device: 'log_main': device_add
[   23.001983] PM: Adding info for No Bus:log_main
[   23.003321] logger: created 256K log 'log_main'
[   23.004921] device: 'log_events': device_add
[   23.006344] PM: Adding info for No Bus:log_events
[   23.007889] logger: created 256K log 'log_events'
[   23.009346] device: 'log_radio': device_add
[   23.010879] PM: Adding info for No Bus:log_radio
[   23.012242] logger: created 256K log 'log_radio'
[   23.013775] device: 'log_system': device_add
[   23.015226] PM: Adding info for No Bus:log_system
[   23.016606] logger: created 256K log 'log_system'
[   23.018080] device class 'timed_output': registering
[   23.019618] bus: 'platform': add driver timed-gpio
[   23.021203] bus: 'sdio': add driver sdio_wimax
[   23.022622] device class 'digi_realport': registering
[   23.024375] device: 'driver_settings': device_add
[   23.025852] PM: Adding info for No Bus:driver_settings
[   23.027618] device: 'nodes': device_add
[   23.028831] PM: Adding info for No Bus:nodes
[   23.030338] hdaps: supported laptop not found!
[   23.031619] hdaps: driver init failed (ret=-19)!
[   23.032974] bus: 'platform': add driver goldfish_pdev_bus
[   23.034655] bus: 'platform': driver_probe_device: matched device goldfish_pdev_bus with driver goldfish_pdev_bus
[   23.037693] bus: 'platform': really_probe: probing driver goldfish_pdev_bus with device goldfish_pdev_bus
[   23.040588] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldfish MMIO.
[   23.042752] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with error -16
[   23.045109] bus: 'platform': add driver ste-modem
[   23.046566] device class 'extcon': registering
[   23.048058] bus: 'platform': add driver extcon-gpio
[   23.049528] oprofile: using NMI interrupt.
[   23.050924] pktgen: Packet Generator for packet performance testing. Version: 2.74
[   23.053926] NET: Registered protocol family 26
[   23.055290] GACT probability on
[   23.056223] Mirror/redirect action on
[   23.057422] Simple TC action Loaded
[   23.058542] device: 'teql0': device_add
[   23.060123] PM: Adding info for No Bus:teql0
[   23.061582] netem: version 1.3
[   23.062485] u32 classifier
[   23.063287]     Actions configured
[   23.064516] NET: Registered protocol family 17
[   23.066252] bus: 'platform': add driver dsa
[   23.067887] NET: Registered protocol family 4
[   23.069465] device: 'irnet': device_add
[   23.070923] PM: Adding info for No Bus:irnet
[   23.072284] IrCOMM protocol (Dag Brattli)
[   23.073618] device: 'ircomm0': device_add
[   23.075059] PM: Adding info for No Bus:ircomm0
[   23.076455] device: 'ircomm1': device_add
[   23.077967] PM: Adding info for No Bus:ircomm1
[   23.079321] device: 'ircomm2': device_add
[   23.080775] PM: Adding info for No Bus:ircomm2
[   23.082154] device: 'ircomm3': device_add
[   23.083684] PM: Adding info for No Bus:ircomm3
[   23.085104] device: 'ircomm4': device_add
[   23.086506] PM: Adding info for No Bus:ircomm4
[   23.088045] device: 'ircomm5': device_add
[   23.089409] PM: Adding info for No Bus:ircomm5
[   23.090879] device: 'ircomm6': device_add
[   23.092277] PM: Adding info for No Bus:ircomm6
[   23.093702] device: 'ircomm7': device_add
[   23.095047] PM: Adding info for No Bus:ircomm7
[   23.096433] device: 'ircomm8': device_add
[   23.097950] PM: Adding info for No Bus:ircomm8
[   23.099305] device: 'ircomm9': device_add
[   23.100777] PM: Adding info for No Bus:ircomm9
[   23.102170] device: 'ircomm10': device_add
[   23.103684] PM: Adding info for No Bus:ircomm10
[   23.105068] device: 'ircomm11': device_add
[   23.106473] PM: Adding info for No Bus:ircomm11
[   23.107998] device: 'ircomm12': device_add
[   23.109347] PM: Adding info for No Bus:ircomm12
[   23.110855] device: 'ircomm13': device_add
[   23.112214] PM: Adding info for No Bus:ircomm13
[   23.113696] device: 'ircomm14': device_add
[   23.115088] PM: Adding info for No Bus:ircomm14
[   23.116471] device: 'ircomm15': device_add
[   23.117880] PM: Adding info for No Bus:ircomm15
[   23.119177] device: 'ircomm16': device_add
[   23.120549] PM: Adding info for No Bus:ircomm16
[   23.121933] device: 'ircomm17': device_add
[   23.123291] PM: Adding info for No Bus:ircomm17
[   23.124852] device: 'ircomm18': device_add
[   23.126247] PM: Adding info for No Bus:ircomm18
[   23.127792] device: 'ircomm19': device_add
[   23.129169] PM: Adding info for No Bus:ircomm19
[   23.130666] device: 'ircomm20': device_add
[   23.132009] PM: Adding info for No Bus:ircomm20
[   23.133437] device: 'ircomm21': device_add
[   23.134817] PM: Adding info for No Bus:ircomm21
[   23.136249] device: 'ircomm22': device_add
[   23.137723] PM: Adding info for No Bus:ircomm22
[   23.139114] device: 'ircomm23': device_add
[   23.140602] PM: Adding info for No Bus:ircomm23
[   23.141989] device: 'ircomm24': device_add
[   23.143515] PM: Adding info for No Bus:ircomm24
[   23.144899] device: 'ircomm25': device_add
[   23.146228] PM: Adding info for No Bus:ircomm25
[   23.147735] device: 'ircomm26': device_add
[   23.149103] PM: Adding info for No Bus:ircomm26
[   23.150564] device: 'ircomm27': device_add
[   23.151950] PM: Adding info for No Bus:ircomm27
[   23.153426] device: 'ircomm28': device_add
[   23.154835] PM: Adding info for No Bus:ircomm28
[   23.156195] device: 'ircomm29': device_add
[   23.157766] PM: Adding info for No Bus:ircomm29
[   23.159156] device: 'ircomm30': device_add
[   23.160644] PM: Adding info for No Bus:ircomm30
[   23.162002] device: 'ircomm31': device_add
[   23.163471] PM: Adding info for No Bus:ircomm31
[   23.164857] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   23.168046] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
[   23.169939] NET: Registered protocol family 12
[   23.171404] 8021q: 802.1Q VLAN Support v1.8
[   23.172718] lib80211: common routines for IEEE802.11 drivers
[   23.174486] lib80211_crypt: registered algorithm 'NULL'
[   23.176069] lib80211_crypt: registered algorithm 'WEP'
[   23.177693] lib80211_crypt: registered algorithm 'CCMP'
[   23.179257] lib80211_crypt: registered algorithm 'TKIP'
[   23.180883] bus: 'platform': add driver rfkill-regulator
[   23.182522] 9pnet: Installing 9P2000 support
[   23.183973] bus: 'virtio': add driver 9pnet_virtio
[   23.185595] NET: Registered protocol family 37
[   23.194760] batman_adv: B.A.T.M.A.N. advanced 2013.2.0 (compatibility version 14) loaded
[   23.197618] 
[   23.197618] printing PIC contents
[   23.199033] ... PIC  IMR: ffff
[   23.199920] ... PIC  IRR: 1053
[   23.200701] ... PIC  ISR: 0000
[   23.201424] ... PIC ELCR: 0c00
[   23.202244] printing local APIC contents on CPU#0/0:
[   23.203375] ... APIC ID:      00000000 (0)
[   23.203375] ... APIC VERSION: 00050014
[   23.203375] ... APIC TASKPRI: 00000000 (00)
[   23.203375] ... APIC PROCPRI: 00000000
[   23.203375] ... APIC LDR: 01000000
[   23.203375] ... APIC DFR: ffffffff
[   23.203375] ... APIC SPIV: 000001ff
[   23.203375] ... APIC ISR field:
[   23.203375] 0000000000000000000000000000000000000000000000000000000000000000
[   23.203375] ... APIC TMR field:
[   23.203375] 0000000000000000000000000000000000000000000000000000000000000000
[   23.203375] ... APIC IRR field:
[   23.203375] 0000000000000000000000000000000000000000000000000000000000008000
[   23.203375] ... APIC ESR: 00000000
[   23.203375] ... APIC ICR: 000008fd
[   23.203375] ... APIC ICR2: 02000000
[   23.203375] ... APIC LVTT: 000000ef
[   23.203375] ... APIC LVTPC: 00010000
[   23.203375] ... APIC LVT0: 00010700
[   23.203375] ... APIC LVT1: 00000400
[   23.203375] ... APIC LVTERR: 000000fe
[   23.203375] ... APIC TMICT: 000321e8
[   23.203375] ... APIC TMCCT: 00000000
[   23.203375] ... APIC TDCR: 00000003
[   23.203375] 
[   23.232104] number of MP IRQ sources: 15.
[   23.233257] number of IO-APIC #2 registers: 24.
[   23.234575] testing the IO APIC.......................
[   23.236036] IO APIC #2......
[   23.236920] .... register #00: 00000000
[   23.237981] .......    : physical APIC id: 00
[   23.239161] .......    : Delivery Type: 0
[   23.240277] .......    : LTS          : 0
[   23.241379] .... register #01: 00170011
[   23.242439] .......     : max redirection entries: 17
[   23.243848] .......     : PRQ implemented: 0
[   23.244982] .......     : IO APIC version: 11
[   23.246125] .... register #02: 00000000
[   23.247268] .......     : arbitration: 00
[   23.248420] .... IRQ redirection table:
[   23.249482] 1    0    0   0   0    0    0    00
[   23.250763] 0    0    0   0   0    1    1    31
[   23.252072] 0    0    0   0   0    1    1    30
[   23.253316] 0    0    0   0   0    1    1    33
[   23.254651] 1    0    0   0   0    1    1    34
[   23.255871] 1    1    0   0   0    1    1    35
[   23.257183] 0    0    0   0   0    1    1    36
[   23.258397] 0    0    0   0   0    1    1    37
[   23.259676] 0    0    0   0   0    1    1    38
[   23.260975] 0    1    0   0   0    1    1    39
[   23.262219] 1    1    0   0   0    1    1    3A
[   23.263496] 1    1    0   0   0    1    1    3B
[   23.264766] 0    0    0   0   0    1    1    3C
[   23.266104] 0    0    0   0   0    1    1    3D
[   23.267359] 0    0    0   0   0    1    1    3E
[   23.268649] 0    0    0   0   0    1    1    3F
[   23.269908] 1    0    0   0   0    0    0    00
[   23.271168] 1    0    0   0   0    0    0    00
[   23.272433] 1    0    0   0   0    0    0    00
[   23.273686] 1    0    0   0   0    0    0    00
[   23.274979] 1    0    0   0   0    0    0    00
[   23.276221] 1    0    0   0   0    0    0    00
[   23.277612] 1    0    0   0   0    0    0    00
[   23.278909] 1    0    0   0   0    0    0    00
[   23.280146] IRQ to pin mappings:
[   23.281008] IRQ0 -> 0:2
[   23.281690] IRQ1 -> 0:1
[   23.282385] IRQ3 -> 0:3
[   23.283093] IRQ4 -> 0:4
[   23.283867] IRQ5 -> 0:5
[   23.284603] IRQ6 -> 0:6
[   23.285312] IRQ7 -> 0:7
[   23.286068] IRQ8 -> 0:8
[   23.286874] IRQ9 -> 0:9
[   23.287621] IRQ10 -> 0:10
[   23.288560] IRQ11 -> 0:11
[   23.289374] IRQ12 -> 0:12
[   23.290155] IRQ13 -> 0:13
[   23.290953] IRQ14 -> 0:14
[   23.291739] IRQ15 -> 0:15
[   23.292533] .................................... done.
[   23.293937] Using IPI No-Shortcut mode
[   23.295130] device: 'cpu_dma_latency': device_add
[   23.296653] PM: Adding info for No Bus:cpu_dma_latency
[   23.298412] device: 'network_latency': device_add
[   23.299906] PM: Adding info for No Bus:network_latency
[   23.301380] device: 'network_throughput': device_add
[   23.302919] PM: Adding info for No Bus:network_throughput
[   23.312226] Key type encrypted registered
[   23.326139] console [netcon0] enabled
[   23.327064] netconsole: network logging started
[   23.329716] Freeing unused kernel memory: 584k freed
[   23.604392] init: Failed to create pty - disabling logging for job
[   23.605594] init: Temporary process spawn error: No such file or directory
mount: unknown filesystem type 'devpts'
mountall: mount /dev/pts [142] terminated with status 32
mountall: Filesystem could not be mounted: /dev/pts
mountall: Skipping mounting /dev/pts since Plymouth is not available
[   23.651441] init: Failed to create pty - disabling logging for job
[   23.653781] init: Temporary process spawn error: No such file or directory
[   23.706383] init: mounted-tmp main process (143) terminated with status 32
mountall: Event failed
mount: wrong fs type, bad option, bad superblock on none,
       missing codepage or helper program, or other error
       (for several filesystems (e.g. nfs, cifs) you might
       need a /sbin/mount.<type> helper program)
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

mountall: mount /run [151] terminated with status 32
mountall: Filesystem could not be mounted: /run
mountall: Skipping mounting /run since Plymouth is not available
[   23.734272] init: Failed to create pty - disabling logging for job
[   23.736466] init: Temporary process spawn error: No such file or directory
[   23.750334] init: Failed to create pty - disabling logging for job
[   23.752507] init: Temporary process spawn error: No such file or directory
[   23.762048] init: Failed to create pty - disabling logging for job
[   23.764023] init: Temporary process spawn error: No such file or directory
[   23.772004] init: Failed to create pty - disabling logging for job
[   23.773969] init: Temporary process spawn error: No such file or directory
[   23.794121] init: plymouth-log main process (157) terminated with status 1
[   23.806037] init: Failed to create pty - disabling logging for job
[   23.808642] init: Temporary process spawn error: No such file or directory
udevd[162]: error: runtime directory '/run/udev' not writable, for now falling back to '/dev/.udev'
[   23.831125] init: Failed to create pty - disabling logging for job
[   23.832642] udevd[163]: starting version 175
[   23.835084] init: Temporary process spawn error: No such file or directory

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="459e3a152aa809827367f5486e179cbabebb6877-bisect.log"

bisect: skip 58f8bbd2e39c3732c55698494338ee19a92c53a0: not a good merge base
git checkout v3.9
Previous HEAD position was 459e3a1... Merge remote-tracking branch 'tip/x86/urgent' into devel-snb-i386-2013-05-29-07-09
HEAD is now at c1be5a5... Linux 3.9

2013-05-29-16:29:45 c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1 reuse /kernel/i386-randconfig-s10-0529/c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1/vmlinuz-3.9.0

2013-05-29-16:29:55 detecting boot state  #6 	0.	9	10 SUCCESS
bisect: good commit v3.9
git bisect start 459e3a152aa809827367f5486e179cbabebb6877 v3.9 --
Previous HEAD position was c1be5a5... Linux 3.9
HEAD is now at 1e51120... userns: Convert 9p's uid/gid handling
Bisecting: 6512 revisions left to test after this (roughly 13 steps)
[73287a43cc79ca06629a88d1a199cd283f42456a] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-16:32:24 73287a43cc79ca06629a88d1a199cd283f42456a compiling
110 real  1266 user  99 sys  1231.86% cpu 	i386-randconfig-s10-0529

2013-05-29-16:34:39 detecting boot state 3.9.0-07168-g73287a4 #7 	0.................... TEST FAILURE
Bisecting: 3600 revisions left to test after this (roughly 12 steps)
[5d434fcb255dec99189f1c58a06e4f56e12bf77d] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-16:45:12 5d434fcb255dec99189f1c58a06e4f56e12bf77d compiling
115 real  1253 user  97 sys  1172.56% cpu 	i386-randconfig-s10-0529

2013-05-29-16:47:30 detecting boot state 3.9.0-03567-g5d434fc #8 	0.	2	10 SUCCESS
Bisecting: 1800 revisions left to test after this (roughly 11 steps)
[91bc033c4d01656e3d8e45a13fd58924a3099693] bridge: avoid OOPS if root port not found
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-16:49:34 91bc033c4d01656e3d8e45a13fd58924a3099693 compiling
111 real  1242 user  99 sys  1209.25% cpu 	i386-randconfig-s10-0529

2013-05-29-16:51:47 detecting boot state 3.9.0-rc8-01800-g91bc033 #9 	0..	10 SUCCESS
Bisecting: 898 revisions left to test after this (roughly 10 steps)
[165bc513f7ec54d3fa3660f5c851c4bbc533d577] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-16:53:49 165bc513f7ec54d3fa3660f5c851c4bbc533d577 compiling
113 real  1269 user  98 sys  1208.37% cpu 	i386-randconfig-s10-0529

2013-05-29-16:56:05 detecting boot state 3.9.0-04469-g165bc51 #10 	0. TEST FAILURE
Bisecting: 450 revisions left to test after this (roughly 9 steps)
[b12f7dd51abf419b9279f3ff2fdc3c06fe50c10f] [media] tw9906: Remove unneeded version.h header include
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-16:57:08 b12f7dd51abf419b9279f3ff2fdc3c06fe50c10f compiling
110 real  1241 user  97 sys  1211.82% cpu 	i386-randconfig-s10-0529

2013-05-29-16:59:22 detecting boot state 3.9.0-rc1-00451-gb12f7dd #11 	0 TEST FAILURE
Bisecting: 225 revisions left to test after this (roughly 8 steps)
[05f0ffbc487517a529c00119d0bfde33df509b52] [media] siano: use USB endpoint descriptors for in/out endp
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-16:59:54 05f0ffbc487517a529c00119d0bfde33df509b52 compiling
106 real  1240 user  98 sys  1254.81% cpu 	i386-randconfig-s10-0529

2013-05-29-17:02:02 detecting boot state 3.9.0-rc1-00225-g05f0ffb #12 	0 TEST FAILURE
Bisecting: 112 revisions left to test after this (roughly 7 steps)
[2aeb73e19dc3d17beebc1b9a678f4c60e1072e25] [media] stk-webcam: add ASUS F3JC to upside-down list
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-17:02:33 2aeb73e19dc3d17beebc1b9a678f4c60e1072e25 compiling
104 real  1231 user  95 sys  1269.39% cpu 	i386-randconfig-s10-0529

2013-05-29-17:04:37 detecting boot state 3.9.0-rc1-00112-g2aeb73e #13 	0..	7...	8	9.........	10 SUCCESS
Bisecting: 56 revisions left to test after this (roughly 6 steps)
[f1065c964869aecd5af04291476c358fd5ab9a8f] [media] media: tuners: Remove redundant NULL check before kfree
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-17:14:09 f1065c964869aecd5af04291476c358fd5ab9a8f compiling
260 real  1227 user  96 sys  508.76% cpu 	i386-randconfig-s10-0529

2013-05-29-17:18:57 detecting boot state 3.9.0-rc1-00168-gf1065c9 #14 	0 TEST FAILURE
Bisecting: 27 revisions left to test after this (roughly 5 steps)
[39696009d0d4472606b7fb90fc635a0d0fecba60] [media] s2255: add device_caps support to querycap
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-17:19:29 39696009d0d4472606b7fb90fc635a0d0fecba60 compiling
125 real  1228 user  95 sys  1052.44% cpu 	i386-randconfig-s10-0529

2013-05-29-17:22:40 detecting boot state 3.9.0-rc1-00140-g3969600 #15 	0 TEST FAILURE
Bisecting: 13 revisions left to test after this (roughly 4 steps)
[69b95a3a80b44ebb71bf153e79bcb8580e1d3de5] [media] s3c-camif: Fail on insufficient number of allocated buffers
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-17:23:12 69b95a3a80b44ebb71bf153e79bcb8580e1d3de5 compiling
112 real  1210 user  93 sys  1161.86% cpu 	i386-randconfig-s10-0529

2013-05-29-17:25:27 detecting boot state 3.9.0-rc1-00126-g69b95a3 #16 	0. TEST FAILURE
Bisecting: 6 revisions left to test after this (roughly 3 steps)
[8407653f5e2b9805958e0a392c0411ce027a3934] [media] stk-webcam: zero the priv field of v4l2_pix_format
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-17:26:29 8407653f5e2b9805958e0a392c0411ce027a3934 compiling
187 real  1246 user  98 sys  717.81% cpu 	i386-randconfig-s10-0529

2013-05-29-17:31:40 detecting boot state 3.9.0-rc1-00119-g8407653 #17 	0...	1	4.	5..............	9.	10 SUCCESS
Bisecting: 3 revisions left to test after this (roughly 2 steps)
[f81e372a5d11694b86fc35ded379a441c209b920] [media] stk-webcam: s_fmt shouldn't grab ownership
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-17:44:17 f81e372a5d11694b86fc35ded379a441c209b920 compiling
210 real  1240 user  97 sys  634.96% cpu 	i386-randconfig-s10-0529

2013-05-29-17:51:12 detecting boot state 3.9.0-rc1-00122-gf81e372 #18 	0..	8....	9............	10 SUCCESS
Bisecting: 1 revision left to test after this (roughly 1 step)
[53bf0f446bc387eabdd535dca080789cc74607f4] [media] v4l: Define video buffer flag for the COPY timestamp type
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-18:02:20 53bf0f446bc387eabdd535dca080789cc74607f4 compiling
201 real  1227 user  100 sys  660.27% cpu 	i386-randconfig-s10-0529

2013-05-29-18:08:57 detecting boot state 3.9.0-rc1-00124-g53bf0f4 #19 	0.	1	9................	10 SUCCESS
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[6aa69f99b2ecc7f9b387fcf22d30e6601b58819f] [media] vb2: Add support for non monotonic timestamps
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-05-29-18:19:31 6aa69f99b2ecc7f9b387fcf22d30e6601b58819f compiling
362 real  1243 user  100 sys  370.82% cpu 	i386-randconfig-s10-0529

2013-05-29-18:27:03 detecting boot state 3.9.0-rc1-00125-g6aa69f9 #20 	0 TEST FAILURE
6aa69f99b2ecc7f9b387fcf22d30e6601b58819f is the first bad commit
commit 6aa69f99b2ecc7f9b387fcf22d30e6601b58819f
Author: Kamil Debski <k.debski@samsung.com>
Date:   Fri Jan 25 06:29:57 2013 -0300

    [media] vb2: Add support for non monotonic timestamps
    
    Not all drivers use monotonic timestamps. This patch adds a way to set the
    timestamp type per every queue.
    In addition, set proper timestamp type in drivers that I am sure that use
    either MONOTONIC or COPY timestamps. Other drivers will correctly report
    UNKNOWN timestamp type instead of assuming that all drivers use monotonic
    timestamps.
    
    Signed-off-by: Kamil Debski <k.debski@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

:040000 040000 5b65d383e3c8c13665e5041187ba335e558ce952 39b11ce91beeebbd33e6e67616b1a6284500e4ab M	drivers
:040000 040000 98e1e59a9981a10a853f04459669fa950b023041 6a87d73391d925e453babd36f27655f8477bc895 M	include
bisect run success

2013-05-29-18:27:40 53bf0f446bc387eabdd535dca080789cc74607f4 reuse /kernel/i386-randconfig-s10-0529/53bf0f446bc387eabdd535dca080789cc74607f4/vmlinuz-3.9.0-rc1-00124-g53bf0f4

2013-05-29-18:27:50 detecting boot state  #20 	0.	1	17	22	25..............	28	29	30 SUCCESS

2013-05-29-18:39:36 459e3a152aa809827367f5486e179cbabebb6877 reuse /kernel/i386-randconfig-s10-0529/459e3a152aa809827367f5486e179cbabebb6877/vmlinuz-3.10.0-rc3-00088-g459e3a1

2013-05-29-18:39:46 detecting boot state  #20 	0. TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:59: main: $BISECT_TEST $KBUILD_OUTPUT
HEAD is now at 459e3a1 Merge remote-tracking branch 'tip/x86/urgent' into devel-snb-i386-2013-05-29-07-09

========= linux-next =========
Fetching next

2013-05-29-18:41:05 1ca94a12e6c269b0dfc10424c27ff295b3420e9c compiling

2013-05-29-18:51:53 detecting boot state 3.10.0-rc3-next-20130529 #21 	0... TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:73: main: $BISECT_TEST $KBUILD_OUTPUT

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.10.0-rc3 Kernel Configuration
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
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
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
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

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
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
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
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
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
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
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
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_GOLDFISH=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_3G_OPT=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xB0000000
CONFIG_HIGHMEM=y
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
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
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
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
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
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
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

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
CONFIG_HAVE_TEXT_POKE_SMP=y
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
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
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
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

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
# CONFIG_DONGLE is not set

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
CONFIG_NFC=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_WILINK=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_MMIO=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_PARIDE=y

#
# Parallel IDE high-level drivers
#
# CONFIG_PARIDE_PD is not set
CONFIG_PARIDE_PCD=y
# CONFIG_PARIDE_PF is not set
# CONFIG_PARIDE_PT is not set
CONFIG_PARIDE_PG=y

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=y
CONFIG_PARIDE_BPCK=y
CONFIG_PARIDE_BPCK6=y
CONFIG_PARIDE_COMM=y
CONFIG_PARIDE_DSTR=y
# CONFIG_PARIDE_FIT2 is not set
# CONFIG_PARIDE_FIT3 is not set
CONFIG_PARIDE_EPAT=y
CONFIG_PARIDE_EPATC8=y
CONFIG_PARIDE_EPIA=y
CONFIG_PARIDE_FRIQ=y
# CONFIG_PARIDE_FRPW is not set
CONFIG_PARIDE_KBIC=y
CONFIG_PARIDE_KTTI=y
CONFIG_PARIDE_ON20=y
# CONFIG_PARIDE_ON26 is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y

#
# Altera FPGA firmware download module
#
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set

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
CONFIG_PATA_ISAPNP=y
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PLATFORM=y
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_WINBOND_VLB is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_LEGACY=y
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_MII=y
# CONFIG_IFB is not set
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
CONFIG_NET_TEAM_MODE_RANDOM=y
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
# CONFIG_MACVTAP is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_ISA is not set
# CONFIG_ARCNET_COM20020_PCI is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
# CONFIG_CAIF_SPI_SLAVE is not set
CONFIG_CAIF_HSI=y
# CONFIG_CAIF_VIRTIO is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_NET_CADENCE is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
# CONFIG_NET_VENDOR_CIRRUS is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=y
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
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
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
CONFIG_SMC9194=y
# CONFIG_EPIC100 is not set
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
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
# CONFIG_PPPOE is not set
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_ATH_CARDS=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH6KL=y
# CONFIG_ATH6KL_SDIO is not set
CONFIG_ATH6KL_DEBUG=y
# CONFIG_WIL6210 is not set
# CONFIG_BRCMFMAC is not set
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_IPW2100 is not set
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_SDIO=y
CONFIG_LIBERTAS_DEBUG=y
CONFIG_LIBERTAS_MESH=y
CONFIG_WL_TI=y
# CONFIG_MWIFIEX is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
# CONFIG_HDLC_FR is not set
CONFIG_HDLC_PPP=y

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
CONFIG_N2=y
CONFIG_C101=y
# CONFIG_FARSYNC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SDLA=y
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_CROS_EC=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_GOLDFISH_TTY=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_NVRAM is not set
# CONFIG_DTLK is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
CONFIG_SSBI=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_PARPORT is not set
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
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
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
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_GPIO=y
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
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
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_SM501 is not set
CONFIG_ABX500_CORE=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_GPIO=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEO_V4L2_INT_DEVICE=y

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_BWQCAM=y
CONFIG_VIDEO_CQCAM=y
# CONFIG_VIDEO_PMS is not set
CONFIG_VIDEO_W9966=y
# CONFIG_RADIO_ADAPTERS is not set

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
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#

#
# Customize TV tuners
#

#
# Customise DVB Frontends
#

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
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
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

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
# CONFIG_FB_S1D13XXX is not set
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
# CONFIG_FB_TMIO is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=y
# CONFIG_HID_PS3REMOTE is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=y
CONFIG_USB_R8A66597=y
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_GOLDFISH is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_OT200=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_CFAG12864B is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_DX_SEP is not set
CONFIG_ZSMALLOC=y
CONFIG_ZRAM=y
# CONFIG_ZRAM_DEBUG is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_STAGING_MEDIA=y
# CONFIG_VIDEO_DT3155 is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=y
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=y
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_SYNC=y
# CONFIG_SW_SYNC is not set
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_K_MODE=y
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_SDIO=y
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=y
# CONFIG_GOLDFISH_AUDIO is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=y
# CONFIG_HP_ACCEL is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_INTEL_OAKTRAIL is not set
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set
# CONFIG_PVPANIC is not set
# CONFIG_GOLDFISH_PIPE is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y

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
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
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
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
# CONFIG_F2FS_FS_XATTR is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
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
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
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
CONFIG_DEBUG_HIGHMEM=y
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_LKDTM is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
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
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
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
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
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
CONFIG_CRYPTO_ABLK_HELPER_X86=y

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
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
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
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_LGUEST=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
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
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--jRHKVT23PllUwdXP--
