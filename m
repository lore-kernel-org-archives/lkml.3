Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab3BWBSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 20:18:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42371 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab3BWBSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 20:18:18 -0500
Date: Fri, 22 Feb 2013 20:18:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        xen-devel@lists.xensource.com
Subject: Regression introduced with 14e568e78f6f80ca1e27256641ddf524c7dbdc51
 (stop_machine: Use smpboot threads)
Message-ID: <20130223011800.GA2465@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

I don't know if this is b/c the Xen code is missing something or
expects something that never happend. I hadn't looked at your
patch in any detail (was going to do that on Monday).

Either way, if I boot a HVM guest with PV extensions (aka PVHVM)
this is I what get:


Loading initramf.gz....................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................ready.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0upstream-06472-g6661875-dirty (konrad@phenom.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Fri Feb 22 20:00:54 EST 2013
[    0.000000] Command line: initrd=initramf.gz  console=ttyS0,115200 test=netstatic nofb   sleep BOOT_IMAGE=vmlinuz 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003f7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] Hypervisor detected: Xen HVM
[    0.000000] Xen version 4.2.
[    0.000000] Netfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated NICs.
[    0.000000] Blkfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated disks.
[    0.000000] You might have to change the root device
[    0.000000] from /dev/hd[a-d] to /dev/xvd[a-d]
[    0.000000] in your root= kernel command line option
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x3f800 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000fbba0-0x000fbbaf] mapped at [ffff8800000fbba0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x3a000000-0x3a1c8fff]
[    0.000000] init_memory_mapping: [mem 0x38000000-0x39ffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x37ffffff]
[    0.000000] init_memory_mapping: [mem 0x3a1c9000-0x3f7fffff]
[    0.000000] RAMDISK: [mem 0x3a1c9000-0x3f7defff]
[    0.000000] ACPI: RSDP 00000000000ea020 00024 (v02    Xen)
[    0.000000] ACPI: XSDT 00000000fc010140 00054 (v01    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: FACP 00000000fc00fe00 000F4 (v04    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: DSDT 00000000fc004180 0BBF6 (v02    Xen      HVM 00000000 INTL 20100528)
[    0.000000] ACPI: FACS 00000000fc004140 00040
[    0.000000] ACPI: APIC 00000000fc00ff00 000D8 (v02    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: HPET 00000000fc010050 00038 (v01    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: WAET 00000000fc010090 00028 (v01    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: SSDT 00000000fc0100c0 00031 (v02    Xen      HVM 00000000 INTL 20100528)
[    0.000000] ACPI: SSDT 00000000fc010100 00031 (v02    Xen      HVM 00000000 INTL 20100528)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000003f7fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x3f7fffff]
[    0.000000]   NODE_DATA [mem 0x3f7fc000-0x3f7fffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x3f7fffff]
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x12] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x18] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x1a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x1c] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 15 CPUs, 13 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] e820: [mem 0x3f800000-0xfbffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen HVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:15 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880039e00000 s84928 r8192 d21568 u131072
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256420
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: initrd=initramf.gz  console=ttyS0,115200 test=netstatic nofb  acpi_sleep=tss sleep BOOT_IMAGE=vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 922436k/1040384k available (6617k kernel code, 396k absent, 117552k reserved, 4286k data, 1028k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=15.
[    0.000000] NR_IRQS:33024 nr_irqs:1208 16
[    0.000000] Xen HVM callback vector for event delivery is enabled
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] tsc: Detected 3901.188 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.008000] Calibrating delay loop (skipped), value calculated using timer frequency.. 7802.37 BogoMIPS (lpj=3901188)
[    0.014003] pid_max: default: 32768 minimum: 301
[    0.017037] Security Framework initialized
[    0.019004] SELinux:  Initializing.
[    0.022076] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.026231] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.032090] Mount-cache hash table entries: 256
[    0.035127] Initializing cgroup subsys cpuacct
[    0.037003] Initializing cgroup subsys freezer
[    0.041103] CPU: Physical Processor ID: 0
[    0.043003] CPU: Processor Core ID: 0
[    0.046004] mce: CPU supports 2 MCE banks
[    0.049023] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.049023] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.049023] tlb_flushall_shift: 5
[    0.059141] Freeing SMP alternatives: 24k freed
[    0.066206] ACPI: Core revision 20130117
[    0.073794] ACPI: All ACPI Tables successfully acquired
[    0.077280] Switched APIC routing to physical flat.
[    0.083403] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.097551] smpboot: CPU0: AMD FX(tm)-8150 Eight-Core Processor (fam: 15, model: 01, stepping: 02)
[    0.103014] installing Xen timer for CPU 0
[    0.106078] cpu 0 spinlock event irq 70
[    0.107023] Performance Events: 
[    0.108005] ------------[ cut here ]------------
[    0.109008] WARNING: at /home/konrad/linux/arch/x86/kernel/cpu/perf_event_amd.c:772 amd_pmu_init+0x191/0x24b()
[    0.110010] Hardware name: HVM domU
[    0.111005] Odd, counter constraints enabled but no core perfctrs detected!
[    0.112005] Modules linked in:
[    0.113186] Pid: 1, comm: swapper/0 Not tainted 3.8.0upstream-06472-g6661875-dirty #1
[    0.114004] Call Trace:
[    0.115010]  [<ffffffff8109228a>] warn_slowpath_common+0x7a/0xb0
[    0.116007]  [<ffffffff81ac65fa>] ? check_bugs+0x2d/0x2d
[    0.117007]  [<ffffffff81092361>] warn_slowpath_fmt+0x41/0x50
[    0.118005]  [<ffffffff81ac6bc3>] amd_pmu_init+0x191/0x24b
[    0.119005]  [<ffffffff81ac6639>] init_hw_perf_events+0x3f/0x438
[    0.120006]  [<ffffffff81ac1bb4>] ? set_real_mode_permissions+0x9d/0xab
[    0.121015]  [<ffffffff81ac65fa>] ? check_bugs+0x2d/0x2d
[    0.122007]  [<ffffffff8100203d>] do_one_initcall+0x3d/0x170
[    0.123008]  [<ffffffff81abc960>] kernel_init_freeable+0xb1/0x1e6
[    0.124008]  [<ffffffff81653140>] ? rest_init+0xa0/0xa0
[    0.125013]  [<ffffffff81653149>] kernel_init+0x9/0xf0
[    0.126008]  [<ffffffff81671ebc>] ret_from_fork+0x7c/0xb0
[    0.127013]  [<ffffffff81653140>] ? rest_init+0xa0/0xa0
[    0.128010] ---[ end trace 42ab141fb39a85a5 ]---
[    0.129011] Broken PMU hardware detected, using software events only.
[    0.130007] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.131193] MCE: In-kernel MCE decoding enabled.
[    0.132131] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.133081] cpu 1 spinlock event irq 71
[    0.134049] smpboot: Booting Node   0, Processors  #1[    0.008000] installing Xen timer for CPU 1
[    0.205154] Brought up 2 CPUs
[    0.205156] smpboot: Total of 2 processors activated (16021.74 BogoMIPS)

[   28.134000] BUG: soft lockup - CPU#0 stuck for 23s! [migration/0:8]
[   28.134000] Modules linked in:
[   28.134000] CPU 0 
[   28.134000] Pid: 8, comm: migration/0 Tainted: G        W    3.8.0upstream-06472-g6661875-dirty #1 Xen HVM domU
[   28.134000] RIP: 0010:[<ffffffff8110711b>]  [<ffffffff8110711b>] stop_machine_cpu_stop+0x7b/0xf0
[   28.134000] RSP: 0000:ffff880039a4dd38  EFLAGS: 00000293
[   28.134000] RAX: 0000000000000001 RBX: ffffffff810c14c7 RCX: 0000000000000000
[   28.134000] RDX: 0000000000000000 RSI: 0000000000000286 RDI: ffff880039a37de8
[   28.134000] RBP: ffff880039a4dd68 R08: 0000000000000000 R09: 0000000000000001
[   28.134000] R10: 0000000000000000 R11: 0000000000000003 R12: ffff880039a4c000
[   28.134000] R13: 0000000000000000 R14: ffffffff810cac35 R15: ffff880039a4dcb8
[   28.134000] FS:  0000000000000000(0000) GS:ffff880039e00000(0000) knlGS:0000000000000000
[   28.134000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   28.134000] CR2: ffff880001cb7000 CR3: 0000000001a0c000 CR4: 00000000000406f0
[   28.134000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   28.134000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   28.134000] Process migration/0 (pid: 8, threadinfo ffff880039a4c000, task ffff880039a2b000)
[   28.134000] Stack:
[   28.134000]  ffff880039a4dd98 ffff880039a37d58 ffff880039a4c000 ffffffff811070a0
[   28.134000]  ffff880039a37de8 ffff880039e0e5e0 ffff880039a4de48 ffffffff81106df3
[   28.134000]  ffff880039a4dda8 ffff880039a4dfd8 ffff880039e0e5e8 ffff880039a4c000
[   28.134000] Call Trace:
[   28.134000]  [<ffffffff811070a0>] ? stop_one_cpu_nowait+0x30/0x30
[   28.134000]  [<ffffffff81106df3>] cpu_stopper_thread+0xb3/0x160
[   28.134000]  [<ffffffff81668b11>] ? __schedule+0x3d1/0x7e0
[   28.134000]  [<ffffffff81080069>] ? default_spin_lock_flags+0x9/0x10
[   28.134000]  [<ffffffff810c0127>] smpboot_thread_fn+0x157/0x1e0
[   28.134000]  [<ffffffff810bffd0>] ? smpboot_create_threads+0x80/0x80
[   28.134000]  [<ffffffff810b7446>] kthread+0xc6/0xd0
[   28.134000]  [<ffffffff810b7380>] ? kthread_freezable_should_stop+0x80/0x80
[   28.134000]  [<ffffffff81671ebc>] ret_from_fork+0x7c/0xb0
[   28.134000]  [<ffffffff810b7380>] ? kthread_freezable_should_stop+0x80/0x80
[   28.134000] Code: 41 83 fd 03 74 42 f0 41 ff 0e 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fd 04 74 3a 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c6 fa 66 66 90 66 66 
[   56.134000] BUG: soft lockup - CPU#0 stuck for 23s! [migration/0:8]
[   56.134000] Modules linked in:
[   56.134000] CPU 0 
[   56.134000] Pid: 8, comm: migration/0 Tainted: G        W    3.8.0upstream-06472-g6661875-dirty #1 Xen HVM domU
[   56.134000] RIP: 0010:[<ffffffff8110711b>]  [<ffffffff8110711b>] stop_machine_cpu_stop+0x7b/0xf0
[   56.134000] RSP: 0000:ffff880039a4dd38  EFLAGS: 00000293
[   56.134000] RAX: 0000000000000001 RBX: ffffffff810c14c7 RCX: 0000000000000000
[   56.134000] RDX: 0000000000000000 RSI: 0000000000000286 RDI: ffff880039a37de8
[   56.134000] RBP: ffff880039a4dd68 R08: 0000000000000000 R09: 0000000000000001
[   56.134000] R10: 0000000000000000 R11: 0000000000000003 R12: ffff880039a4c000
[   56.134000] R13: 0000000000000000 R14: ffffffff810cac35 R15: ffff880039a4dcb8
[   56.134000] FS:  0000000000000000(0000) GS:ffff880039e00000(0000) knlGS:0000000000000000
[   56.134000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   56.134000] CR2: ffff880001cb7000 CR3: 0000000001a0c000 CR4: 00000000000406f0
[   56.134000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   56.134000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   56.134000] Process migration/0 (pid: 8, threadinfo ffff880039a4c000, task ffff880039a2b000)
[   56.134000] Stack:
[   56.134000]  ffff880039a4dd98 ffff880039a37d58 ffff880039a4c000 ffffffff811070a0
[   56.134000]  ffff880039a37de8 ffff880039e0e5e0 ffff880039a4de48 ffffffff81106df3
[   56.134000]  ffff880039a4dda8 ffff880039a4dfd8 ffff880039e0e5e8 ffff880039a4c000
[   56.134000] Call Trace:
[   56.134000]  [<ffffffff811070a0>] ? stop_one_cpu_nowait+0x30/0x30
[   56.134000]  [<ffffffff81106df3>] cpu_stopper_thread+0xb3/0x160
[   56.134000]  [<ffffffff81668b11>] ? __schedule+0x3d1/0x7e0
[   56.134000]  [<ffffffff81080069>] ? default_spin_lock_flags+0x9/0x10
[   56.134000]  [<ffffffff810c0127>] smpboot_thread_fn+0x157/0x1e0
[   56.134000]  [<ffffffff810bffd0>] ? smpboot_create_threads+0x80/0x80
[   56.134000]  [<ffffffff810b7446>] kthread+0xc6/0xd0
[   56.134000]  [<ffffffff810b7380>] ? kthread_freezable_should_stop+0x80/0x80
[   56.134000]  [<ffffffff81671ebc>] ret_from_fork+0x7c/0xb0
[   56.134000]  [<ffffffff810b7380>] ? kthread_freezable_should_stop+0x80/0x80
[   56.134000] Code: 41 83 fd 03 74 42 f0 41 ff 0e 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fd 04 74 3a 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c6 fa 66 66 90 66 66 
[   84.134000] BUG: soft lockup - CPU#0 stuck for 22s! [migration/0:8]
[   84.134000] Modules linked in:
[   84.134000] CPU 0 
[   84.134000] Pid: 8, comm: migration/0 Tainted: G        W    3.8.0upstream-06472-g6661875-dirty #1 Xen HVM domU
[   84.134000] RIP: 0010:[<ffffffff8110711b>]  [<ffffffff8110711b>] stop_machine_cpu_stop+0x7b/0xf0
[   84.134000] RSP: 0000:ffff880039a4dd38  EFLAGS: 00000293
[   84.134000] RAX: 0000000000000001 RBX: ffffffff810c14c7 RCX: 0000000000000000
[   84.134000] RDX: 0000000000000000 RSI: 0000000000000286 RDI: ffff880039a37de8
[   84.134000] RBP: ffff880039a4dd68 R08: 0000000000000000 R09: 0000000000000001
[   84.134000] R10: 0000000000000000 R11: 0000000000000003 R12: ffff880039a4c000
[   84.134000] R13: 0000000000000000 R14: ffffffff810cac35 R15: ffff880039a4dcb8
[   84.134000] FS:  0000000000000000(0000) GS:ffff880039e00000(0000) knlGS:0000000000000000
[   84.134000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   84.134000] CR2: ffff880001cb7000 CR3: 0000000001a0c000 CR4: 00000000000406f0
[   84.134000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   84.134000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   84.134000] Process migration/0 (pid: 8, threadinfo ffff880039a4c000, task ffff880039a2b000)
[   84.134000] Stack:
[   84.134000]  ffff880039a4dd98 ffff880039a37d58 ffff880039a4c000 ffffffff811070a0
[   84.134000]  ffff880039a37de8 ffff880039e0e5e0 ffff880039a4de48 ffffffff81106df3
[   84.134000]  ffff880039a4dda8 ffff880039a4dfd8 ffff880039e0e5e8 ffff880039a4c000
[   84.134000] Call Trace:
[   84.134000]  [<ffffffff811070a0>] ? stop_one_cpu_nowait+0x30/0x30
[   84.134000]  [<ffffffff81106df3>] cpu_stopper_thread+0xb3/0x160
[   84.134000]  [<ffffffff81668b11>] ? __schedule+0x3d1/0x7e0
[   84.134000]  [<ffffffff81080069>] ? default_spin_lock_flags+0x9/0x10
[   84.134000]  [<ffffffff810c0127>] smpboot_thread_fn+0x157/0x1e0
[   84.134000]  [<ffffffff810bffd0>] ? smpboot_create_threads+0x80/0x80
[   84.134000]  [<ffffffff810b7446>] kthread+0xc6/0xd0
[   84.134000]  [<ffffffff810b7380>] ? kthread_freezable_should_stop+0x80/0x80
[   84.134000]  [<ffffffff81671ebc>] ret_from_fork+0x7c/0xb0
[   84.134000]  [<ffffffff810b7380>] ? kthread_freezable_should_stop+0x80/0x80
[   84.134000] Code: 41 83 fd 03 74 42 f0 41 ff 0e 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fd 04 74 3a 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c6 fa 66 66 90 66 66 
[  112.134000] BUG: soft lockup - CPU#0 stuck for 22s! [migration/0:8]
[  112.134000] Modules linked in:
[  112.134000] CPU 0 
[  112.134000] Pid: 8, comm: migration/0 Tainted: G        W    3.8.0upstream-06472-g6661875-dirty #1 Xen HVM domU
[  112.134000] RIP: 0010:[<ffffffff8110711b>]  [<ffffffff8110711b>] stop_machine_cpu_stop+0x7b/0xf0
[  112.134000] RSP: 0000:ffff880039a4dd38  EFLAGS: 00000293
[  112.134000] RAX: 0000000000000001 RBX: ffffffff810c14c7 RCX: 0000000000000000
[  112.134000] RDX: 0000000000000000 RSI: 0000000000000286 RDI: ffff880039a37de8
[  112.134000] RBP: ffff880039a4dd68 R08: 0000000000000000 R09: 0000000000000001
[  112.134000] R10: 0000000000000000 R11: 0000000000000003 R12: ffff880039a4c000
[  112.134000] R13: 0000000000000000 R14: ffffffff810cac35 R15: ffff880039a4dcb8
[  112.134000] FS:  0000000000000000(0000) GS:ffff880039e00000(0000) knlGS:0000000000000000
[  112.134000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  112.134000] CR2: ffff880001cb7000 CR3: 0000000001a0c000 CR4: 00000000000406f0
[  112.134000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  112.134000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  112.134000] Process migration/0 (pid: 8, threadinfo ffff880039a4c000, task ffff880039a2b000)
[  112.134000] Stack:
[  112.134000]  ffff880039a4dd98 ffff880039a37d58 ffff880039a4c000 ffffffff811070a0
[  112.134000]  ffff880039a37de8 ffff880039e0e5e0 ffff880039a4de48 ffffffff81106df3
[  112.134000]  ffff880039a4dda8 ffff880039a4dfd8 ffff880039e0e5e8 ffff880039a4c000
[  112.134000] Call Trace:
[  112.134000]  [<ffffffff811070a0>] ? stop_one_cpu_nowait+0x30/0x30
[  112.134000]  [<ffffffff81106df3>] cpu_stopper_thread+0xb3/0x160
[  112.134000]  [<ffffffff81668b11>] ? __schedule+0x3d1/0x7e0
[  112.134000]  [<ffffffff81080069>] ? default_spin_lock_flags+0x9/0x10
[  112.134000]  [<ffffffff810c0127>] smpboot_thread_fn+0x157/0x1e0
[  112.134000]  [<ffffffff810bffd0>] ? smpboot_create_threads+0x80/0x80
[  112.134000]  [<ffffffff810b7446>] kthread+0xc6/0xd0
[  112.134000]  [<ffffffff810b7380>] ? kthread_freezable_should_stop+0x80/0x80
[  112.134000]  [<ffffffff81671ebc>] ret_from_fork+0x7c/0xb0
[  112.134000]  [<ffffffff810b7380>] ? kthread_freezable_should_stop+0x80/0x80
[  112.134000] Code: 41 83 fd 03 74 42 f0 41 ff 0e 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fd 04 74 3a 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c6 fa 66 66 90 66 66 
[  140.134000] BUG: soft lockup - CPU#0 stuck for 22s! [migration/0:8]
[  140.134000] Modules linked in:
[  140.134000] CPU 0 
[  140.134000] Pid: 8, comm: migration/0 Tainted: G        W    3.8.0upstream-06472-g6661875-dirty #1 Xen HVM domU
[  140.134000] RIP: 0010:[<ffffffff8110711b>]  [<ffffffff8110711b>] stop_machine_cpu_stop+0x7b/0xf0
[  140.134000] RSP: 0000:ffff880039a4dd38  EFLAGS: 00000293
[  140.134000] RAX: 0000000000000001 RBX: ffffffff810c14c7 RCX: 0000000000000000
[  140.134000] RDX: 0000000000000000 RSI: 0000000000000286 RDI: ffff880039a37de8
[  140.134000] RBP: ffff880039a4dd68 R08: 0000000000000000 R09: 0000000000000001
[  140.134000] R10: 0000000000000000 R11: 0000000000000003 R12: ffff880039a4c000
[  140.134000] R13: 0000000000000000 R14: ffffffff810cac35 R15: ffff880039a4dcb8
[  140.134000] FS:  0000000000000000(0000) GS:ffff880039e00000(0000) knlGS:0000000000000000
[  140.134000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  140.134000] CR2: ffff880001cb7000 CR3: 0000000001a0c000 CR4: 00000000000406f0
[  140.134000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  140.134000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  140.134000] Process migration/0 (pid: 8, threadinfo ffff880039a4c000, task ffff880039a2b000)
[  140.134000] Stack:
[  140.134000]  ffff880039a4dd98 ffff880039a37d58 ffff880039a4c000 ffffffff811070a0
[  140.134000]  ffff880039a37de8 ffff880039e0e5e0 ffff880039a4de48 ffffffff81106df3
[  140.134000]  ffff880039a4dda8 ffff880039a4dfd8 ffff880039e0e5e8 ffff880039a4c000
[  140.134000] Call Trace:
[  140.134000]  [<ffffffff811070a0>] ? stop_one_cpu_nowait+0x30/0x30
[  140.134000]  [<ffffffff81106df3>] cpu_stopper_thread+0xb3/0x160
[  140.134000]  [<ffffffff81668b11>] ? __schedule+0x3d1/0x7e0
[  140.134000]  [<ffffffff81080069>] ? default_spin_lock_flags+0x9/0x10
[  140.134000]  [<ffffffff810c0127>] smpboot_thread_fn+0x157/0x1e0
[  140.134000]  [<ffffffff810bffd0>] ? smpboot_create_threads+0x80/0x80
[  140.134000]  [<ffffffff810b7446>] kthread+0xc6/0xd0
[  140.134000]  [<ffffffff810b7380>] ? kthread_freezable_should_stop+0x80/0x80
[  140.134000]  [<ffffffff81671ebc>] ret_from_fork+0x7c/0xb0
[  140.134000]  [<ffffffff810b7380>] ? kthread_freezable_should_stop+0x80/0x80
[  140.134000] Code: 41 83 fd 03 74 42 f0 41 ff 0e 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fd 04 74 3a 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c6 fa 66 66 90 66 66 


if I revert the above mention git commit it boots just fine:

Loading vmlinuz........................................................................
Loading initramf.gz....................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................ready.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0upstream-06474-g23618fa (konrad@phenom.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Fri Feb 22 20:11:27 EST 2013
[    0.000000] Command line: initrd=initramf.gz  console=ttyS0,115200 test=netstatic nofb  acpi_sleep=tss sleep BOOT_IMAGE=vmlinuz 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003f7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] Hypervisor detected: Xen HVM
[    0.000000] Xen version 4.2.
[    0.000000] Netfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated NICs.
[    0.000000] Blkfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated disks.
[    0.000000] You might have to change the root device
[    0.000000] from /dev/hd[a-d] to /dev/xvd[a-d]
[    0.000000] in your root= kernel command line option
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x3f800 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000fbba0-0x000fbbaf] mapped at [ffff8800000fbba0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x3a000000-0x3a1c9fff]
[    0.000000] init_memory_mapping: [mem 0x38000000-0x39ffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x37ffffff]
[    0.000000] init_memory_mapping: [mem 0x3a1ca000-0x3f7fffff]
[    0.000000] RAMDISK: [mem 0x3a1ca000-0x3f7defff]
[    0.000000] ACPI: RSDP 00000000000ea020 00024 (v02    Xen)
[    0.000000] ACPI: XSDT 00000000fc010140 00054 (v01    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: FACP 00000000fc00fe00 000F4 (v04    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: DSDT 00000000fc004180 0BBF6 (v02    Xen      HVM 00000000 INTL 20100528)
[    0.000000] ACPI: FACS 00000000fc004140 00040
[    0.000000] ACPI: APIC 00000000fc00ff00 000D8 (v02    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: HPET 00000000fc010050 00038 (v01    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: WAET 00000000fc010090 00028 (v01    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: SSDT 00000000fc0100c0 00031 (v02    Xen      HVM 00000000 INTL 20100528)
[    0.000000] ACPI: SSDT 00000000fc010100 00031 (v02    Xen      HVM 00000000 INTL 20100528)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000003f7fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x3f7fffff]
[    0.000000]   NODE_DATA [mem 0x3f7fc000-0x3f7fffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x3f7fffff]
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x12] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x18] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x1a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x1c] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 15 CPUs, 13 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] e820: [mem 0x3f800000-0xfbffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen HVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:15 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880039e00000 s84928 r8192 d21568 u131072
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256420
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: initrd=initramf.gz  console=ttyS0,115200 test=netstatic nofb  acpi_sleep=tss sleep BOOT_IMAGE=vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 922440k/1040384k available (6617k kernel code, 396k absent, 117548k reserved, 4285k data, 1028k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=15.
[    0.000000] NR_IRQS:33024 nr_irqs:1208 16
[    0.000000] Xen HVM callback vector for event delivery is enabled
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] tsc: Detected 3901.188 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.008000] Calibrating delay loop (skipped), value calculated using timer frequency.. 7802.37 BogoMIPS (lpj=3901188)
[    0.014004] pid_max: default: 32768 minimum: 301
[    0.017038] Security Framework initialized
[    0.019003] SELinux:  Initializing.
[    0.022097] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.028113] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.033110] Mount-cache hash table entries: 256
[    0.036144] Initializing cgroup subsys cpuacct
[    0.039004] Initializing cgroup subsys freezer
[    0.042101] CPU: Physical Processor ID: 0
[    0.045004] CPU: Processor Core ID: 0
[    0.047005] mce: CPU supports 2 MCE banks
[    0.049025] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.049025] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.049025] tlb_flushall_shift: 5
[    0.060140] Freeing SMP alternatives: 24k freed
[    0.067402] ACPI: Core revision 20130117
[    0.075448] ACPI: All ACPI Tables successfully acquired
[    0.079303] Switched APIC routing to physical flat.
[    0.086337] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.100652] smpboot: CPU0: AMD FX(tm)-8150 Eight-Core Processor (fam: 15, model: 01, stepping: 02)
[    0.107016] installing Xen timer for CPU 0
[    0.109084] cpu 0 spinlock event irq 70
[    0.110026] Performance Events: 
[    0.111005] ------------[ cut here ]------------
[    0.112008] WARNING: at /home/konrad/linux/arch/x86/kernel/cpu/perf_event_amd.c:772 amd_pmu_init+0x191/0x24b()
[    0.113010] Hardware name: HVM domU
[    0.114005] Odd, counter constraints enabled but no core perfctrs detected!
[    0.115007] Modules linked in:
[    0.116190] Pid: 1, comm: swapper/0 Not tainted 3.8.0upstream-06474-g23618fa #1
[    0.117005] Call Trace:
[    0.118011]  [<ffffffff8109228a>] warn_slowpath_common+0x7a/0xb0
[    0.119007]  [<ffffffff81ac65fa>] ? check_bugs+0x2d/0x2d
[    0.120014]  [<ffffffff81092361>] warn_slowpath_fmt+0x41/0x50
[    0.121010]  [<ffffffff81ac6bc3>] amd_pmu_init+0x191/0x24b
[    0.122008]  [<ffffffff81ac6639>] init_hw_perf_events+0x3f/0x438
[    0.123008]  [<ffffffff81ac1bb4>] ? set_real_mode_permissions+0x9d/0xab
[    0.124011]  [<ffffffff81ac65fa>] ? check_bugs+0x2d/0x2d
[    0.125010]  [<ffffffff8100203d>] do_one_initcall+0x3d/0x170
[    0.126011]  [<ffffffff81abc960>] kernel_init_freeable+0xb1/0x1e6
[    0.127009]  [<ffffffff81653040>] ? rest_init+0xa0/0xa0
[    0.128008]  [<ffffffff81653049>] kernel_init+0x9/0xf0
[    0.129008]  [<ffffffff81671fbc>] ret_from_fork+0x7c/0xb0
[    0.130008]  [<ffffffff81653040>] ? rest_init+0xa0/0xa0
[    0.131009] ---[ end trace 7957b7a5e5b198bd ]---
[    0.132012] Broken PMU hardware detected, using software events only.
[    0.133009] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.134179] MCE: In-kernel MCE decoding enabled.
[    0.135132] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.136107] cpu 1 spinlock event irq 71
[    0.137063] smpboot: Booting Node   0, Processors  #1[    0.008000] installing Xen timer for CPU 1
[    0.209200] Brought up 2 CPUs
[    0.209202] smpboot: Total of 2 processors activated (16015.74 BogoMIPS)

[    0.220139] kworker/u:0 (20) used greatest stack depth: 6168 bytes left
[    0.220139] RTC time:  1:16:41, date: 02/23/13
[    0.229069] NET: Registered protocol family 16
[    0.230054] kworker/u:0 (22) used greatest stack depth: 5704 bytes left
[    0.237060] ACPI: bus type pci registered
[    0.240049] dca service started, version 1.12.1
[    0.244256] PCI: Using configuration type 1 for base access
[    0.247015] PCI: Using configuration type 1 for extended access
[    0.264073] bio: create slab <bio-0> at 0
[    0.265073] ACPI: Added _OSI(Module Device)
[    0.268052] ACPI: Added _OSI(Processor Device)
[    0.270007] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.273006] ACPI: Added _OSI(Processor Aggregator Device)
[    0.282063] ACPI: Interpreter enabled
[    0.284007] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.291009] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.298018]  S3 S4 S5)
[    0.299770] ACPI: Using IOAPIC for interrupt routing
[    0.303054] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.358147] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.363225] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.368006] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.374173] PCI host bridge to bus 0000:00
[    0.377030] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.380007] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.384012] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.389013] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.394008] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfbffffff]
[    0.405302] * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
[    0.405302] * this clock source is slow. Consider trying other clock sources
[    0.415684] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.425458] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.430254] ACPI: PCI Interrupt Link [LNKA] (IRQs *5 10 11)
[    0.434187] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.438297] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.443247] ACPI: PCI Interrupt Link [LNKD] (IRQs *5 10 11)
[    0.468107] ACPI: Enabled 2 GPEs in block 00 to 0F
[    0.495342] ACPI: No dock devices found.
[    0.498051] xen/balloon: Initialising balloon driver.
[    0.503021] xen-balloon: Initialising balloon driver.
[    0.507315] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.513020] vgaarb: loaded
[    0.515008] vgaarb: bridge control possible 0000:00:02.0
[    0.519043] ACPI: bus type usb registered
[    0.521025] usbcore: registered new interface driver usbfs
[    0.525050] usbcore: registered new interface driver hub
[    0.529032] usbcore: registered new device driver usb
[    0.532030] pps_core: LinuxPPS API ver. 1 registered
[    0.535010] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.541034] PTP clock support registered
[    0.544021] PCI: Using ACPI for IRQ routing
[    0.547504] NetLabel: Initializing
[    0.550020] NetLabel:  domain hash size = 128
[    0.553005] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.556023] NetLabel:  unlabeled traffic allowed by default
[    0.560086] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.563850] hpet0: 3 comparators, 64-bit 62.500000 MHz counter
[    0.570000] Switching to clocksource xen
[    0.575292] pnp: PnP ACPI init
[    0.577723] ACPI: bus type pnp registered
[    0.580940] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.586188] system 00:02: [io  0x08a0-0x08a3] has been reserved
[    0.590258] system 00:02: [io  0x0cc0-0x0ccf] has been reserved
[    0.594253] system 00:02: [io  0x04d0-0x04d1] has been reserved
[    0.599358] system 00:0b: [io  0x10c0-0x1141] has been reserved
[    0.603955] system 00:0b: [io  0xb044-0xb047] has been reserved
[    0.628468] pnp: PnP ACPI: found 12 devices
[    0.631442] ACPI: ACPI bus type pnp unregistered
[    0.645562] NET: Registered protocol family 2
[    0.649044] TCP established hash table entries: 8192 (order: 5, 131072 bytes)
[    0.654286] TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
[    0.658984] TCP: Hash tables configured (established 8192 bind 8192)
[    0.663716] TCP: reno registered
[    0.666075] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.670360] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.675037] NET: Registered protocol family 1
[    0.678309] RPC: Registered named UNIX socket transport module.
[    0.682174] RPC: Registered udp transport module.
[    0.687129] RPC: Registered tcp transport module.
[    0.691254] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.696034] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.699773] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.703675] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.708489] Unpacking initramfs...
[    2.141533] Freeing initrd memory: 88148k freed
[    2.164129] Machine check injector initialized
[    2.168316] microcode: CPU0: patch_level=0x06000626
[    2.172993] microcode: CPU1: patch_level=0x06000626
[    2.176728] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.182905] Scanning for low memory corruption every 60 seconds
[    2.187817] audit: initializing netlink socket (disabled)
[    2.191843] type=2000 audit(1361582202.962:1): initialized
[    2.207210] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.211912] VFS: Disk quotas dquot_6.5.2
[    2.214690] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.219888] NFS: Registering the id_resolver key type
[    2.223132] Key type id_resolver registered
[    2.225832] Key type id_legacy registered
[    2.228426] NTFS driver 2.1.30 [Flags: R/W].
[    2.231310] msgmni has been set to 1973
[    2.234951] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    2.240338] io scheduler noop registered
[    2.243302] io scheduler deadline registered
[    2.246944] io scheduler cfq registered (default)
[    2.250838] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.254918] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM (4096 kB) at 0xf0000000
[    2.260761] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.265458] ACPI: Power Button [PWRF]
[    2.267894] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
[    2.272527] ACPI: Sleep Button [SLPF]
[    2.299201] GHES: HEST is not enabled!
[    2.301887] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.306244] Grant tables using version 1 layout.
[    2.309719] Grant table initialized
[    2.350043] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.384350] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.389781] Non-volatile memory driver v1.3
[    2.392982] Linux agpgart interface v0.103
[    2.396500] [drm] Initialized drm 1.1.0 20060810
[    2.401266] loop: module loaded
[    2.404010] libphy: Fixed MDIO Bus: probed
[    2.406982] tun: Universal TUN/TAP device driver, 1.6
[    2.410646] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.415328] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.7.12-k
[    2.421802] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    2.426813] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.431520] ehci-pci: EHCI PCI platform driver
[    2.434881] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.438958] uhci_hcd: USB Universal Host Controller Interface driver
[    2.443235] uhci_hcd 0000:00:01.2: UHCI Host Controller
[    2.446671] uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
[    2.451329] uhci_hcd 0000:00:01.2: detected 2 ports
[    2.454517] uhci_hcd 0000:00:01.2: irq 23, io base 0x0000c200
[    2.459396] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.464574] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.469834] usb usb1: Product: UHCI Host Controller
[    2.473420] usb usb1: Manufacturer: Linux 3.8.0upstream-06474-g23618fa uhci_hcd
[    2.478471] usb usb1: SerialNumber: 0000:00:01.2
[    2.482206] hub 1-0:1.0: USB hub found
[    2.484834] hub 1-0:1.0: 2 ports detected
[    2.488090] usbcore: registered new interface driver usblp
[    2.492447] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.500167] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.503714] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.507763] mousedev: PS/2 mouse device common for all mice
[    2.512933] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    2.524976] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    2.529542] rtc_cmos 00:04: alarms up to one day, 114 bytes nvram, hpet irqs
[    2.534889] cpuidle: using governor ladder
[    2.537830] cpuidle: using governor menu
[    2.540584] EFI Variables Facility v0.08 2004-May-17
[    2.544414] zram: Created 1 device(s) ...
[    2.547839] Netfilter messages via NETLINK v0.30.
[    2.551376] nf_conntrack version 0.5.0 (7895 buckets, 31580 max)
[    2.555360] ctnetlink v0.93: registering with nfnetlink.
[    2.558943] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.562389] TCP: cubic registered
[    2.564542] Initializing XFRM netlink socket
[    2.567367] NET: Registered protocol family 10
[    2.570381] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.575240] sit: IPv6 over IPv4 tunneling driver
[    2.578803] NET: Registered protocol family 17
[    2.582316] Key type dns_resolver registered
[    2.585987] registered taskstats version 1
[    2.589437] XENBUS: Device with no driver: device/vbd/5632
[    2.593412] XENBUS: Device with no driver: device/vbd/51712
[    2.597376] XENBUS: Device with no driver: device/vkbd/0
[    2.601142] XENBUS: Device with no driver: device/vif/0
[    2.606914]   Magic number: 1:525:256
[    2.610031] tty ttytf: hash matches
[    2.614105] Freeing unused kernel memory: 1028k freed
[    2.617578] Write protecting the kernel read-only data: 10240k
[    2.624349] Freeing unused kernel memory: 1564k freed
[    2.628174] Freeing unused kernel memory: 124k freed
init started: BusyBox v1.14.3 (2013-02-22 20:12:24 EST)
[    2.637307] consoletype (1105) used greatest stack depth: 5272 bytes left
Mounting directories  [  OK  ]
mount: mount point /proc/bus/usb does not exist
[    2.803957] modprobe (1135) used greatest stack depth: 5256 bytes left
mount: mount point /sys/kernel/config does not exist
[    2.815744] core_filesystem (1106) used greatest stack depth: 4968 bytes left
[    2.824824] input: Xen Virtual Keyboard as /devices/virtual/input/input3
[    2.830810] input: Xen Virtual Pointer as /devices/virtual/input/input4
FATAL: Error inserting xen_fbfront (/lib/modules/3.8.0upstream-06474-g23618fa/kernel/drivers/video/xen-fbfront.ko): No such device
[    2.952663] Initialising Xen virtual ethernet driver.
[    3.058902] vbd vbd-5632: 19 xenbus_dev_probe on device/vbd/5632
[    3.063787] vbd vbd-5632: failed to write error node for device/vbd/5632 (19 xenbus_dev_probe on device/vbd/5632)
[    3.078892] blkfront: xvda: barrier or flush: disabled using persistent grants
[    3.086048]  xvda: unknown partition table
[    3.130560] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input5
[    3.179037] udevd (1177): /proc/1177/oom_adj is deprecated, please use /proc/1177/oom_score_adj instead.
udevd-work[1460]: error opening ATTR{/sys/devices/system/cpu/cpu0/online} for writing: No such file or directory
Waiting for devices [  OK  ]

[    3.242701] SCSI subsystem initialized
[    3.280922] ACPI: bus type scsi registered
[    3.291177] ip (2088) used greatest stack depth: 3928 bytes left
[    3.298854] libata version 3.00 loaded.
[    3.303746] ata_piix 0000:00:01.1: version 2.13
[    3.307420] ata_piix 0000:00:01.1: setting latency timer to 64
[    3.315495] scsi0 : ata_piix
[    3.318138] scsi1 : ata_piix
[    3.320673] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc220 irq 14
[    3.325880] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc228 irq 15
[    3.484370] ata2.01: NODEV after polling detection
[    3.489426] ata2.00: ATAPI: QEMU DVD-ROM, 0.10.2, max UDMA/100
[    3.495340] ata2.00: configured for MWDMA2
[    3.500231] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     0.10 PQ: 0 ANSI: 5
[    3.511465] sr0: scsi3-mmc drive: 4x/4x xa/form2 tray
[    3.516801] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.522597] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.528965] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    3.704201] usb usb1: suspend_rh (auto-stop)
Waiting for fb [  OK  ]
Waiting for network [  OK  ]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  poRTNETLINK answers: Network is unreachable
[  OK  ]
wWaiting for init.custom [  OK  ]

Starting SSHd ...
eroff

    SSH started [2385]


Waiting for SSHd [  OK  ]
WARNING: ssh currently running [2385] ignoring start request
FATAL: Module dump_dma not found.
ERROR: Module dump_dma does not exist in /proc/modules
[    9.388889] Loading iSCSI transport class v2.0-870.
[    9.394686] iscsi: registered transport (tcp)
hostname: Name or service not known
iscsistart: transport class version 2.0-870. iscsid version 2.0-872
Could not get list of targets from firmware.
Feb 23 01:16:50 (none) syslogd 1.5.0: restart.
Running in HVM context on Xen v4.2.
You might have to do kill -1 1 if you see 'can't open /dev/hvc0'
[1:0:0:0]    cd/dvd  QEMU     QEMU DVD-ROM     0.10  /dev/sr0 
00:00.0 Host bridge: Intel Corporation 440FX - 82441FX PMC [Natoma] (rev 02)
00:01.0 ISA bridge: Intel Corporation 82371SB PIIX3 ISA [Natoma/Triton II]
00:01.1 IDE interface: Intel Corporation 82371SB PIIX3 IDE [Natoma/Triton II]
00:01.2 USB Controller: Intel Corporation 82371SB PIIX3 USB [Natoma/Triton II] (rev 01)
00:01.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 01)
00:02.0 VGA compatible controller: Cirrus Logic GD 5446
00:03.0 Class ff80: XenSource, Inc. Xen Platform Device (rev 01)
            CPU0       CPU1       
   0:        109          0   IO-APIC-edge      timer
   1:          9          0  xen-pirq-ioapic-edge  i8042
   4:        201          0  xen-pirq-ioapic-edge  serial
   8:         59          0  xen-pirq-ioapic-edge  rtc0
   9:          0          0   IO-APIC-fasteoi   acpi
  12:        125          0  xen-pirq-ioapic-edge  i8042
  14:          0          0   IO-APIC-edge      ata_piix
  15:         96          0   IO-APIC-edge      ata_piix
  23:          0          0  xen-pirq-ioapic-level  uhci_hcd:usb1
  64:       3128          0  xen-percpu-virq      timer0
  65:       2815          0  xen-percpu-ipi       resched0
  66:          0          0  xen-percpu-ipi       callfunc0
  67:          0          0  xen-percpu-virq      debug0
  68:        214          0  xen-percpu-ipi       callfuncsingle0
  69:          0          0  xen-percpu-ipi       irqwork0
  70:          0          0  xen-percpu-ipi       spinlock0
  71:          0          0  xen-percpu-ipi       spinlock1
  72:          0       3338  xen-percpu-ipi       resched1
  73:          0          0  xen-percpu-ipi       callfunc1
  74:          0          0  xen-percpu-virq      debug1
  75:          0        243  xen-percpu-ipi       callfuncsingle1
  76:          0          0  xen-percpu-ipi       irqwork1
  77:          0       1802  xen-percpu-virq      timer1
  78:        344          0   xen-dyn-event     xenbus
  80:          0          0   xen-dyn-event     vkbd
  81:         14          0   xen-dyn-event     eth0
  82:          2          0   xen-dyn-event     blkif
 NMI:          0          0   Non-maskable interrupts
 LOC:          0          0   Local timer interrupts
 SPU:          0          0   Spurious interrupts
 PMI:          0          0   Performance monitoring interrupts
 IWI:          0          0   IRQ work interrupts
 RTR:          0          0   APIC ICR read retries
 RES:       2815       3338   Rescheduling interrupts
 CAL:        131        150   Function call interrupts
 TLB:         83         93   TLB shootdowns
 TRM:          0          0   Thermal event interrupts
 THR:          0          0   Threshold APIC interrupts
 MCE:          0          0   Machine check exceptions
 MCP:          1          1   Machine check polls
 ERR:          0
 MIS:          0
00000000-00000fff : reserved
00001000-0009dfff : System RAM
0009e000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c8bff : Video ROM
000c9000-000c99ff : Adapter ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3f7fffff : System RAM
  01000000-01676677 : Kernel code
  01676678-01aa5dbf : Kernel data
  01baf000-01cb4fff : Kernel bss
3f800000-3fffffff : RAM buffer
f0000000-fbffffff : PCI Bus 0000:00
  f0000000-f1ffffff : 0000:00:02.0
    f0000000-f1ffffff : cirrusfb
  f2000000-f2ffffff : 0000:00:03.0
    f2000000-f2ffffff : xen-platform-pci
  f3000000-f3000fff : 0000:00:02.0
    f3000000-f3000fff : cirrusfb
fc000000-ffffffff : reserved
  fec00000-fec003ff : IOAPIC 0
  fed00000-fed003ff : HPET 0
  fee00000-fee00fff : Local APIC
MemTotal:        1013328 kB
MemFree:          624868 kB
Buffers:               0 kB
Cached:           350448 kB
SwapCached:            0 kB
Active:            15968 kB
Inactive:         334816 kB
Active(anon):      10204 kB
Inactive(anon):   163096 kB
Active(file):       5764 kB
Inactive(file):   171720 kB
Unevictable:        4896 kB
Mlocked:            4896 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          5180 kB
Mapped:             4948 kB
Shmem:            169428 kB
Slab:              22776 kB
SReclaimable:      11768 kB
SUnreclaim:        11008 kB
KernelStack:         648 kB
PageTables:          868 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      506664 kB
Committed_AS:     181212 kB
VmallocTotal:   34359738367 kB
VmallocUsed:        6324 kB
VmallocChunk:   34359731835 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       32768 kB
DirectMap2M:     1009664 kB
Waiting for init.late [  OK  ]
