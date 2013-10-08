Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3JHEgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 00:36:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:29191 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab3JHEf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 00:35:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1054,1371106800"; 
   d="bad4'?scan'208";a="406999951"
Date: Tue, 8 Oct 2013 12:35:48 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [DRM_CURRUS_QEMU/timer] WARNING: CPU: 0 PID: 1 at
 debug_print_object()
Message-ID: <20131008043548.GA11079@localhost>
References: <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
 <20131007083505.GA22585@localhost>
 <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
 <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
 <20131008020918.GA1220@localhost>
 <20131008021452.GA6456@localhost>
 <CA+55aFwrovZf-LYa=_SyMNvqQkTfxREm0YuzDk8wJy+Krs0xzw@mail.gmail.com>
 <20131008031152.GA8218@localhost>
 <CA+55aFwBVx0D=7b4+-PgnZ+uEBW9suNF8e-QCegme375N5yyYw@mail.gmail.com>
 <20131008033518.GA9401@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20131008033518.GA9401@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

It's this one config that triggers the oops:

        CONFIG_DRM_CIRRUS_QEMU

Full kconfig is attached. CONFIG_DEBUG_LIST has been enabled. What's
interesting is that parport_pc is showing up in the call traces.

dmesg log for two kernel boots:

% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #21 SMP PREEMPT Tue Oct 8 12:13:02 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug ignore_loglevel apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f1840-0x000f184f] mapped at [ffff8800000f1840]
[    0.000000]   mpc: f1850-f193c
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02870000, 0x02870fff] PGTABLE
[    0.000000] BRK [0x02871000, 0x02871fff] PGTABLE
[    0.000000] BRK [0x02872000, 0x02872fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x02873000, 0x02873fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x02874000, 0x02874fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128344(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000f16b0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe3f0 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe430 01137 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff6a0 00899 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff5b0 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff570 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:e896001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5ba000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88000dc00000 s77904 r0 d24496 u1048576
[    0.000000] pcpu-alloc: s77904 r0 d24496 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] kvm-clock: cpu 0, msr 0:e896001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dc0ccc0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64391
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug ignore_loglevel apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 199288K/261744K available (8414K kernel code, 1769K rwdata, 3912K rodata, 840K init, 10060K bss, 62456K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000]  Additional per-CPU info printed with stalls.
[    0.000000]  RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.008900] pid_max: default: 32768 minimum: 301
[    0.010404] Mount-cache hash table entries: 256
[    0.012563] Initializing cgroup subsys devices
[    0.013988] Initializing cgroup subsys perf_event
[    0.016029] Initializing cgroup subsys net_prio
[    0.017509] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017509] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017509] tlb_flushall_shift: 6
[    0.020044] debug: unmapping init [mem 0xffffffff81e99000-0xffffffff81e9cfff]
[    0.025205] ACPI: Core revision 20130517
[    0.029922] ACPI: All ACPI Tables successfully acquired
[    0.031603] Getting VERSION: 50014
[    0.032020] Getting VERSION: 50014
[    0.032810] Getting ID: 0
[    0.033414] Getting ID: ff000000
[    0.034171] Getting LVT0: 8700
[    0.034854] Getting LVT1: 8400
[    0.036080] enabled ExtINT on CPU#0
[    0.037876] ENABLING IO-APIC IRQs
[    0.038574] init IO_APIC IRQs
[    0.039266]  apic 0 pin 0 not connected
[    0.040043] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.041645] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.043277] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.044036] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.045680] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.048044] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.049811] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.052032] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.053623] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.055202] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.056036] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.057707] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.060032] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.061660] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.063253] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.064034]  apic 0 pin 16 not connected
[    0.064800]  apic 0 pin 17 not connected
[    0.065586]  apic 0 pin 18 not connected
[    0.068007]  apic 0 pin 19 not connected
[    0.068949]  apic 0 pin 20 not connected
[    0.069814]  apic 0 pin 21 not connected
[    0.070588]  apic 0 pin 22 not connected
[    0.071363]  apic 0 pin 23 not connected
[    0.072161] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.073514] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.076010] Using local APIC timer interrupts.
[    0.076010] calibrating APIC timer ...
[    0.080000] ... lapic delta = 6251588
[    0.080000] ... PM-Timer delta = 358050
[    0.080000] ... PM-Timer result ok
[    0.080000] ..... delta 6251588
[    0.080000] ..... mult: 268503660
[    0.080000] ..... calibration result: 4001016
[    0.080000] ..... CPU clock speed is 2694.0774 MHz.
[    0.080000] ..... host bus clock speed is 1000.1016 MHz.
[    0.080103] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.104619] SMP alternatives: lockdep: fixing up alternatives
[    0.105760] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.124228] Brought up 2 CPUs
[    0.128008] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.128018] KVM setup async PF for cpu 1
[    0.128024] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.132339] devtmpfs: initialized
[    0.134316] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.137823] regulator-dummy: no parameters
[    0.140475] NET: Registered protocol family 16
[    0.144020] ACPI: bus type PCI registered
[    0.145070] PCI: Using configuration type 1 for base access
[    0.156835] ACPI: Added _OSI(Module Device)
[    0.157753] ACPI: Added _OSI(Processor Device)
[    0.158814] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.159940] ACPI: Added _OSI(Processor Aggregator Device)
[    0.162585] ACPI: EC: Look up EC in DSDT
[    0.172295] ACPI: Interpreter enabled
[    0.173216] ACPI: (supports S0 S5)
[    0.174334] ACPI: Using IOAPIC for interrupt routing
[    0.175518] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.193772] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.195674] PCI host bridge to bus 0000:00
[    0.196012] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.197193] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.200014] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.201243] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.203313] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.204119] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.206212] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.208825] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.215270] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.217885] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.220556] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.222046] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.224490] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.232075] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.238502] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.256119] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.258218] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.260615] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.262307] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.269203] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.271496] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.273304] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.277257] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.285998] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.288470] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.291123] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.298719] pci_bus 0000:00: on NUMA node 0
[    0.300032] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.301846] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.306340] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.309000] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.311763] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.312767] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.314684] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.320745] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.323663] ACPI: \_SB_.PCI0: notify handler is installed
[    0.324130] Found 1 acpi root devices
[    0.326173] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.328018] vgaarb: loaded
[    0.328796] vgaarb: bridge control possible 0000:00:02.0
[    0.336847] ACPI: bus type USB registered
[    0.338330] usbcore: registered new interface driver usbfs
[    0.340085] usbcore: registered new interface driver hub
[    0.344095] usbcore: registered new device driver usb
[    0.345695] pps_core: LinuxPPS API ver. 1 registered
[    0.346883] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.348083] PTP clock support registered
[    0.349337] wmi: Mapper loaded
[    0.350176] PCI: Using ACPI for IRQ routing
[    0.352020] PCI: pci_cache_line_size set to 64 bytes
[    0.353327] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.356035] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.359535] NET: Registered protocol family 23
[    0.361321] cfg80211: Calling CRDA to update world regulatory domain
[    0.364174] nfc: nfc_init: NFC Core ver 0.1
[    0.365366] NET: Registered protocol family 39
[    0.369362] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.372289] Switched to clocksource kvm-clock
[    0.373511] pnp: PnP ACPI init
[    0.374570] ACPI: bus type PNP registered
[    0.376463] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.378102] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.379645] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.381943] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.383861] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.387140] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.389417] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.391966] pnp 00:03: [dma 2]
[    0.393255] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.395441] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.397583] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.400259] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.402347] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.404997] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.407836] pnp: PnP ACPI: found 7 devices
[    0.409200] ACPI: bus type PNP unregistered
[    0.420246] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.421857] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.423395] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.425178] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.427513] NET: Registered protocol family 2
[    0.429791] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.431941] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.434214] TCP: Hash tables configured (established 2048 bind 2048)
[    0.435995] TCP: reno registered
[    0.437022] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.439350] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.442179] NET: Registered protocol family 1
[    0.444923] RPC: Registered named UNIX socket transport module.
[    0.446230] RPC: Registered udp transport module.
[    0.447351] RPC: Registered tcp transport module.
[    0.448555] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.450301] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.452328] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.453773] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.455331] pci 0000:00:02.0: Boot video device
[    0.456502] PCI: CLS 0 bytes, default 64
[    0.457881] Unpacking initramfs...
[    2.676108] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    2.679721] has_svm: not amd
[    2.680505] kvm: no hardware support
[    2.681829] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    2.684176] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    2.686848] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    2.689322] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.689403] cryptomgr_test (24) used greatest stack depth: 6376 bytes left
[    2.692789] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.694258] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.695822] AVX or AES-NI instructions are not detected.
[    2.697224] AVX instructions are not detected.
[    2.699223] AVX instructions are not detected.
[    2.700535] AVX instructions are not detected.
[    2.706217] Initializing RT-Tester: OK
[    2.706703] audit: initializing netlink socket (disabled)
[    2.707412] type=2000 audit(1378709047.165:1): initialized
[    2.711701] DLM installed
[    2.713609] NFS: Registering the id_resolver key type
[    2.714985] Key type id_resolver registered
[    2.715991] Key type id_legacy registered
[    2.717078] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.719526] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.720989] fuse init (API version 7.22)
[    2.723115] ceph: loaded (mds proto 32)
[    2.726574] cryptomgr_test (43) used greatest stack depth: 5752 bytes left
[    2.729298] cryptomgr_test (44) used greatest stack depth: 5680 bytes left
[    2.744376] cryptomgr_test (72) used greatest stack depth: 5264 bytes left
[    2.748934] alg: No test for crc32 (crc32-table)
[    2.750206] alg: No test for lz4hc (lz4hc-generic)
[    2.751680] alg: No test for stdrng (krng)
[    2.752602] NET: Registered protocol family 38
[    2.753198] Key type asymmetric registered
[    2.753723] Asymmetric key parser 'x509' registered
[    2.754274] test_string_helpers: Running tests...
[    2.756524] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    2.757198] crc32: self tests passed, processed 225944 bytes in 519468 nsec
[    2.758467] crc32c: CRC_LE_BITS = 32
[    2.759216] crc32c: self tests passed, processed 225944 bytes in 141849 nsec
[    2.761588] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.763198] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.765729] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.768095] vmlfb: initializing
[    2.768651] Could not find Carillo Ranch MCH device.
[    2.770930] no IO addresses supplied
[    2.772165] hgafb: HGA card not detected.
[    2.773134] hgafb: probe of hgafb.0 failed with error -22
[    2.775144] usbcore: registered new interface driver udlfb
[    2.776974] usbcore: registered new interface driver smscufx
[    2.780665] uvesafb: failed to execute /sbin/v86d
[    2.782074] uvesafb: make sure that the v86d helper is installed and executable
[    2.783894] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    2.785935] uvesafb: vbe_init() failed with -22
[    2.787031] uvesafb: probe of uvesafb.0 failed with error -22
[    2.789001] ipmi message handler version 39.2
[    2.790143] ipmi device interface
[    2.791138] IPMI System Interface driver.
[    2.792413] ipmi_si: Adding default-specified kcs state machine
[    2.794055] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    2.796746] ipmi_si: Interface detection failed
[    2.808161] ipmi_si: Adding default-specified smic state machine
[    2.809838] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    2.812967] ipmi_si: Interface detection failed
[    2.824150] ipmi_si: Adding default-specified bt state machine
[    2.826234] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    2.829592] ipmi_si: Interface detection failed
[    2.840339] kobject: 'ipmi_si' (ffff8800077a2600): kobject_release, parent ffff8800001b7648 (delayed)
[    2.842528] kobject: 'ipmi_si' (ffff8800077a2400): kobject_release, parent ffff880000221448 (delayed)
[    2.844867] kobject: 'ipmi_si' (ffff8800077a2800): kobject_release, parent ffff880000189248 (delayed)
[    2.847617] ipmi_si: Unable to find any System Interface(s)
[    2.849859] IPMI Watchdog: driver initialized
[    2.851416] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.854553] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.857101] ACPI: Power Button [PWRF]
[    2.977343] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.000940] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.006511] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    3.008608] ac.o: No PCI boards found.
[    3.009721] ac.o: For an ISA board you must supply memory and irq parameters.
[    3.012508] Non-volatile memory driver v1.3
[    3.013350] Linux agpgart interface v0.103
[    3.015283] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    3.016918] kobject: 'drm' (ffff880006dd6048): kobject_release, parent ffff880000189648 (delayed)
[    3.019223] kobject: 'drm' (ffff880006dd7c00): kobject_release, parent           (null) (delayed)
[    3.022075] [drm] radeon kernel modesetting enabled.
[    3.024718] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    3.025883] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    3.027772] kobject: 'controlD64' (ffff880006de9820): kobject_release, parent           (null) (delayed)
[    3.030311] cirrus: probe of 0000:00:02.0 failed with error -1
[    3.031237] usbcore: registered new interface driver udl
[    3.033268] parport_pc 00:04: reported by Plug and Play ACPI
[    3.034204] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    3.036189] kobject: 'parport_pc.956' (ffff880006de9820): kobject_release, parent           (null) (delayed)
[    3.037736] ------------[ cut here ]------------
[    3.038499] WARNING: CPU: 0 PID: 1 at /c/wfg/linux/lib/debugobjects.c:260 debug_print_object+0x7c/0x8d()
[    3.040020] ODEBUG: init active (active state 0) object type: timer_list hint:           (null)
[    3.040020] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc2-00010-gc817a67-dirty #21
[    3.040020]  0000000000000104 ffff88000010db78 ffffffff8182ae08 0000000000000000
[    3.040020]  ffff88000010dbc8 ffff88000010dbb8 ffffffff8108f040 0000000000000046
[    3.040020]  ffffffff81220eaa ffffffff81beef1e ffff880006dc5510 ffffffff81c2e2d0
[    3.040020] Call Trace:
[    3.040020]  [<ffffffff8182ae08>] dump_stack+0x4f/0x84
[    3.040020]  [<ffffffff8108f040>] warn_slowpath_common+0x72/0x8c
[    3.040020]  [<ffffffff81220eaa>] ? debug_print_object+0x7c/0x8d
[    3.040020]  [<ffffffff8108f0be>] warn_slowpath_fmt+0x41/0x43
[    3.040020]  [<ffffffff81220eaa>] debug_print_object+0x7c/0x8d
[    3.040020]  [<ffffffff81221209>] __debug_object_init+0x27c/0x2c6
[    3.040020]  [<ffffffff81221244>] ? __debug_object_init+0x2b7/0x2c6
[    3.040020]  [<ffffffff81221267>] debug_object_init+0x14/0x16
[    3.040020]  [<ffffffff81098f20>] init_timer_key+0x23/0x65
[    3.040020]  [<ffffffff81210bbe>] kobject_release+0x90/0xba
[    3.040020]  [<ffffffff81210e3b>] kobject_put+0x4d/0x51
[    3.040020]  [<ffffffff81462ce4>] put_device+0x12/0x14
[    3.040020]  [<ffffffff814672f6>] platform_device_put+0x12/0x14
[    3.040020]  [<ffffffff8146767b>] platform_device_unregister+0x16/0x1a
[    3.040020]  [<ffffffff814610e7>] parport_pc_probe_port+0x7b7/0x7cc
[    3.040020]  [<ffffffff81e00a15>] parport_pc_init+0x2b0/0x317
[    3.040020]  [<ffffffff81e00765>] ? parport_setup+0x147/0x147
[    3.040020]  [<ffffffff81ddbe0c>] do_one_initcall+0x8e/0x132
[    3.040020]  [<ffffffff810a6c00>] ? param_array_set+0xa7/0xf2
[    3.040020]  [<ffffffff810a6e4d>] ? parse_args+0x1ad/0x26c
[    3.040020]  [<ffffffff81215c82>] ? strcpy+0x9/0x18
[    3.040020]  [<ffffffff81ddbfe2>] kernel_init_freeable+0x132/0x1bc
[    3.040020]  [<ffffffff81ddb6e3>] ? do_early_param+0x86/0x86
[    3.040020]  [<ffffffff81824c6f>] ? rest_init+0xc3/0xc3
[    3.040020]  [<ffffffff81824c78>] kernel_init+0x9/0xcc
[    3.040020]  [<ffffffff81835f7c>] ret_from_fork+0x7c/0xb0
[    3.040020]  [<ffffffff81824c6f>] ? rest_init+0xc3/0xc3
[    3.040020] ---[ end trace eb7906735b7816b7 ]---
[    3.096136] INFO: trying to register non-static key.
[    3.097385] the code is fine but needs lockdep annotation.
[    3.098753] turning off the locking correctness validator.
[    3.099835] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-rc2-00010-gc817a67-dirty #21
[    3.100075]  0000000000000046 ffff88000010da28 ffffffff8182ae08 0000000000000000
[    3.100075]  0000000000000000 ffff88000010daa8 ffffffff810c56de ffff88000010da88
[    3.100075]  ffffffff81090497 0000000000007adc 0000000000000046 ffff88000010da78
[    3.100075] Call Trace:
[    3.100075]  [<ffffffff8182ae08>] dump_stack+0x4f/0x84
[    3.100075]  [<ffffffff810c56de>] register_lock_class+0x104/0x2b2
[    3.100075]  [<ffffffff81090497>] ? console_unlock+0x35b/0x36a
[    3.100075]  [<ffffffff810c798e>] __lock_acquire+0xf6/0xe3c
[    3.100075]  [<ffffffff818357b7>] ? retint_restore_args+0x13/0x13
[    3.100075]  [<ffffffff810c6c25>] ? trace_hardirqs_on_caller+0x154/0x18b
[    3.100075]  [<ffffffff810c8afd>] lock_acquire+0x7e/0x99
[    3.100075]  [<ffffffff81099263>] ? try_to_del_timer_sync+0x5f/0x5f
[    3.100075]  [<ffffffff810992ac>] del_timer_sync+0x49/0xcb
[    3.100075]  [<ffffffff81099263>] ? try_to_del_timer_sync+0x5f/0x5f
[    3.100075]  [<ffffffff810cd647>] ? arch_local_irq_restore+0x6/0xd
[    3.100075]  [<ffffffff81099372>] timer_fixup_init+0x16/0x2f
[    3.100075]  [<ffffffff81220ce3>] debug_object_fixup+0x15/0x1d
[    3.100075]  [<ffffffff81221228>] __debug_object_init+0x29b/0x2c6
[    3.100075]  [<ffffffff81221244>] ? __debug_object_init+0x2b7/0x2c6
[    3.100075]  [<ffffffff81221267>] debug_object_init+0x14/0x16
[    3.100075]  [<ffffffff81098f20>] init_timer_key+0x23/0x65
[    3.100075]  [<ffffffff81210bbe>] kobject_release+0x90/0xba
[    3.100075]  [<ffffffff81210e3b>] kobject_put+0x4d/0x51
[    3.100075]  [<ffffffff81462ce4>] put_device+0x12/0x14
[    3.100075]  [<ffffffff814672f6>] platform_device_put+0x12/0x14
[    3.100075]  [<ffffffff8146767b>] platform_device_unregister+0x16/0x1a
[    3.100075]  [<ffffffff814610e7>] parport_pc_probe_port+0x7b7/0x7cc
[    3.100075]  [<ffffffff81e00a15>] parport_pc_init+0x2b0/0x317
[    3.100075]  [<ffffffff81e00765>] ? parport_setup+0x147/0x147
[    3.100075]  [<ffffffff81ddbe0c>] do_one_initcall+0x8e/0x132
[    3.100075]  [<ffffffff810a6c00>] ? param_array_set+0xa7/0xf2
[    3.100075]  [<ffffffff810a6e4d>] ? parse_args+0x1ad/0x26c
[    3.100075]  [<ffffffff81215c82>] ? strcpy+0x9/0x18
[    3.100075]  [<ffffffff81ddbfe2>] kernel_init_freeable+0x132/0x1bc
[    3.100075]  [<ffffffff81ddb6e3>] ? do_early_param+0x86/0x86
[    3.100075]  [<ffffffff81824c6f>] ? rest_init+0xc3/0xc3
[    3.100075]  [<ffffffff81824c78>] kernel_init+0x9/0xcc
[    3.100075]  [<ffffffff81835f7c>] ret_from_fork+0x7c/0xb0
[    3.100075]  [<ffffffff81824c6f>] ? rest_init+0xc3/0xc3
[    3.680292] tsc: Refined TSC clocksource calibration: 2693.463 MHz
[    4.028085] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    4.030278] IP: [<          (null)>]           (null)
[    4.031880] PGD 0
[    4.032045] Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    4.032045] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-rc2-00010-gc817a67-dirty #21
[    4.032045] task: ffff88000010a040 ti: ffff88000010c000 task.ti: ffff88000010c000
[    4.032045] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[    4.032045] RSP: 0000:ffff88000dc03e40  EFLAGS: 00010286
[    4.032045] RAX: 0000000000000000 RBX: 0000000000000100 RCX: 0000000000000000
[    4.032045] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    4.032045] RBP: ffff88000dc03e98 R08: 0000000000000002 R09: 0000000000000000
[    4.032045] R10: ffff88000dc03e58 R11: ffffffff81f08780 R12: ffff88000010dfd8
[    4.032045] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff81f097d8
[    4.032045] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[    4.032045] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.032045] CR2: 0000000000000000 CR3: 0000000001c15000 CR4: 00000000000006b0
[    4.032045] Stack:
[    4.032045]  ffffffff8109861e ffffffff810985b3 ffffffff81f08780 ffff880006de98d8
[    4.032045]  0000000000000000 0000000000000000 0000000000000000 ffffffff81f08780
[    4.032045]  ffff88000dc03ec8 ffffffff81f09fd8 ffffffff81f09bd8 ffff88000dc03f08
[    4.032045] Call Trace:
[    4.032045]  <IRQ>
[    4.032045]  [<ffffffff8109861e>] ? call_timer_fn+0x6b/0xde
[    4.032045]  [<ffffffff810985b3>] ? __internal_add_timer+0xc4/0xc4
[    4.032045]  [<ffffffff81098c49>] run_timer_softirq+0x187/0x1cf
[    4.032045]  [<ffffffff810951c4>] __do_softirq+0xc6/0x18f
[    4.032045]  [<ffffffff810953aa>] irq_exit+0x58/0x9e
[    4.032045]  [<ffffffff81044bab>] smp_apic_timer_interrupt+0x31/0x3e
[    4.032045]  [<ffffffff81836cb2>] apic_timer_interrupt+0x72/0x80
[    4.032045]  <EOI>
[    4.032045]  [<ffffffff818357b7>] ? retint_restore_args+0x13/0x13
[    4.032045]  [<ffffffff81098cda>] ? lock_timer_base.isra.17+0x49/0x4b
[    4.032045]  [<ffffffff8109922b>] try_to_del_timer_sync+0x27/0x5f
[    4.032045]  [<ffffffff81098435>] ? arch_local_irq_restore+0x6/0xd
[    4.032045]  [<ffffffff8109931b>] del_timer_sync+0xb8/0xcb
[    4.032045]  [<ffffffff81099263>] ? try_to_del_timer_sync+0x5f/0x5f
[    4.032045]  [<ffffffff810cd647>] ? arch_local_irq_restore+0x6/0xd
[    4.032045]  [<ffffffff81099372>] timer_fixup_init+0x16/0x2f
[    4.032045]  [<ffffffff81220ce3>] debug_object_fixup+0x15/0x1d
[    4.032045]  [<ffffffff81221228>] __debug_object_init+0x29b/0x2c6
[    4.032045]  [<ffffffff81221244>] ? __debug_object_init+0x2b7/0x2c6
[    4.032045]  [<ffffffff81221267>] debug_object_init+0x14/0x16
[    4.032045]  [<ffffffff81098f20>] init_timer_key+0x23/0x65
[    4.032045]  [<ffffffff81210bbe>] kobject_release+0x90/0xba
[    4.032045]  [<ffffffff81210e3b>] kobject_put+0x4d/0x51
[    4.032045]  [<ffffffff81462ce4>] put_device+0x12/0x14
[    4.032045]  [<ffffffff814672f6>] platform_device_put+0x12/0x14
[    4.032045]  [<ffffffff8146767b>] platform_device_unregister+0x16/0x1a
[    4.032045]  [<ffffffff814610e7>] parport_pc_probe_port+0x7b7/0x7cc
[    4.032045]  [<ffffffff81e00a15>] parport_pc_init+0x2b0/0x317
[    4.032045]  [<ffffffff81e00765>] ? parport_setup+0x147/0x147
[    4.032045]  [<ffffffff81ddbe0c>] do_one_initcall+0x8e/0x132
[    4.032045]  [<ffffffff810a6c00>] ? param_array_set+0xa7/0xf2
[    4.032045]  [<ffffffff810a6e4d>] ? parse_args+0x1ad/0x26c
[    4.032045]  [<ffffffff81215c82>] ? strcpy+0x9/0x18
[    4.032045]  [<ffffffff81ddbfe2>] kernel_init_freeable+0x132/0x1bc
[    4.032045]  [<ffffffff81ddb6e3>] ? do_early_param+0x86/0x86
[    4.032045]  [<ffffffff81824c6f>] ? rest_init+0xc3/0xc3
[    4.032045]  [<ffffffff81824c78>] kernel_init+0x9/0xcc
[    4.032045]  [<ffffffff81835f7c>] ret_from_fork+0x7c/0xb0
[    4.032045]  [<ffffffff81824c6f>] ? rest_init+0xc3/0xc3
[    4.032045] Code:  Bad RIP value.
[    4.032045] RIP  [<          (null)>]           (null)
[    4.032045]  RSP <ffff88000dc03e40>
[    4.032045] CR2: 0000000000000000
[    4.142753] ---[ end trace eb7906735b7816b8 ]---
[    4.144312] Kernel panic - not syncing: Fatal exception in interrupt
[    4.146076] Rebooting in 10 seconds..%                                                                                                  wfg@bee ~/linux/obj-compiletest%
wfg@bee ~/linux/obj-compiletest%
wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #22 SMP PREEMPT Tue Oct 8 12:14:43 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug ignore_loglevel apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f1840-0x000f184f] mapped at [ffff8800000f1840]
[    0.000000]   mpc: f1850-f193c
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x027c1000, 0x027c1fff] PGTABLE
[    0.000000] BRK [0x027c2000, 0x027c2fff] PGTABLE
[    0.000000] BRK [0x027c3000, 0x027c3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x027c4000, 0x027c4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x027c5000, 0x027c5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128344(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000f16b0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe3f0 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe430 01137 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff6a0 00899 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff5b0 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff570 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:e896001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5ba000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88000dc00000 s77904 r0 d24496 u1048576
[    0.000000] pcpu-alloc: s77904 r0 d24496 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] kvm-clock: cpu 0, msr 0:e896001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dc0ccc0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64391
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug ignore_loglevel apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 199988K/261744K available (7955K kernel code, 1639K rwdata, 3804K rodata, 840K init, 10060K bss, 61756K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000]  Additional per-CPU info printed with stalls.
[    0.000000]  RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.012000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.013698] pid_max: default: 32768 minimum: 301
[    0.016308] Mount-cache hash table entries: 256
[    0.018249] Initializing cgroup subsys devices
[    0.020047] Initializing cgroup subsys perf_event
[    0.021577] Initializing cgroup subsys net_prio
[    0.023240] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023240] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023240] tlb_flushall_shift: 6
[    0.024053] debug: unmapping init [mem 0xffffffff81dea000-0xffffffff81dedfff]
[    0.028875] ACPI: Core revision 20130517
[    0.032939] ACPI: All ACPI Tables successfully acquired
[    0.034610] Getting VERSION: 50014
[    0.035430] Getting VERSION: 50014
[    0.036029] Getting ID: 0
[    0.036760] Getting ID: ff000000
[    0.037568] Getting LVT0: 8700
[    0.040017] Getting LVT1: 8400
[    0.040856] enabled ExtINT on CPU#0
[    0.042986] ENABLING IO-APIC IRQs
[    0.044020] init IO_APIC IRQs
[    0.044936]  apic 0 pin 0 not connected
[    0.045895] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.048038] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.050552] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.052032] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.053939] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.056047] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.057972] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.060050] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.061986] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.064031] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.065976] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.068028] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.069970] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.072031] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.074026] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.076037]  apic 0 pin 16 not connected
[    0.076966]  apic 0 pin 17 not connected
[    0.078161]  apic 0 pin 18 not connected
[    0.080010]  apic 0 pin 19 not connected
[    0.080961]  apic 0 pin 20 not connected
[    0.081918]  apic 0 pin 21 not connected
[    0.082870]  apic 0 pin 22 not connected
[    0.084009]  apic 0 pin 23 not connected
[    0.085113] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.086678] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.088893] Using local APIC timer interrupts.
[    0.088893] calibrating APIC timer ...
[    0.092000] ... lapic delta = 6250087
[    0.092000] ... PM-Timer delta = 357976
[    0.092000] ... PM-Timer result ok
[    0.092000] ..... delta 6250087
[    0.092000] ..... mult: 268439192
[    0.092000] ..... calibration result: 4000055
[    0.092000] ..... CPU clock speed is 2693.2496 MHz.
[    0.092000] ..... host bus clock speed is 1000.0055 MHz.
[    0.092124] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.116605] SMP alternatives: lockdep: fixing up alternatives
[    0.117947] smpboot: Booting Node   0, Processors  #1 OK
[    0.012000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.012000] masked ExtINT on CPU#1
[    0.140240] Brought up 2 CPUs
[    0.140157] KVM setup async PF for cpu 1
[    0.140157] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.143049] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.144847] devtmpfs: initialized
[    0.148858] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.151078] regulator-dummy: no parameters
[    0.152508] NET: Registered protocol family 16
[    0.155023] ACPI: bus type PCI registered
[    0.156136] PCI: Using configuration type 1 for base access
[    0.172142] ACPI: Added _OSI(Module Device)
[    0.176012] ACPI: Added _OSI(Processor Device)
[    0.179101] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.184042] ACPI: Added _OSI(Processor Aggregator Device)
[    0.196346] ACPI: EC: Look up EC in DSDT
[    0.208740] ACPI: Interpreter enabled
[    0.212051] ACPI: (supports S0 S5)
[    0.220033] ACPI: Using IOAPIC for interrupt routing
[    0.228118] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.251759] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.260270] PCI host bridge to bus 0000:00
[    0.264033] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.272053] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.280043] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.288041] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.296045] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.304165] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.313051] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.324650] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.335536] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.345036] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.352757] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.360075] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.368363] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.376977] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.384098] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.398050] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.400326] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.402106] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.403586] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.409798] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.411648] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.413737] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.421470] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.433221] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.436502] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.440779] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.446977] pci_bus 0000:00: on NUMA node 0
[    0.448042] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.450299] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.454151] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.456104] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.457892] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.460051] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.461660] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.464000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.464028] ACPI: \_SB_.PCI0: notify handler is installed
[    0.465457] Found 1 acpi root devices
[    0.468795] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.470217] vgaarb: loaded
[    0.470718] vgaarb: bridge control possible 0000:00:02.0
[    0.472759] ACPI: bus type USB registered
[    0.476267] usbcore: registered new interface driver usbfs
[    0.484139] usbcore: registered new interface driver hub
[    0.492170] usbcore: registered new device driver usb
[    0.493545] pps_core: LinuxPPS API ver. 1 registered
[    0.496013] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.500095] PTP clock support registered
[    0.502250] wmi: Mapper loaded
[    0.504125] PCI: Using ACPI for IRQ routing
[    0.505850] PCI: pci_cache_line_size set to 64 bytes
[    0.508395] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.509797] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.513378] NET: Registered protocol family 23
[    0.516151] cfg80211: Calling CRDA to update world regulatory domain
[    0.518134] nfc: nfc_init: NFC Core ver 0.1
[    0.519239] NET: Registered protocol family 39
[    0.520634] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.522382] Switched to clocksource kvm-clock
[    0.522382] pnp: PnP ACPI init
[    0.522382] ACPI: bus type PNP registered
[    0.523305] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.527932] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.531607] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.533928] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.535528] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.538544] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.541921] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.544325] pnp 00:03: [dma 2]
[    0.545142] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.546788] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.548817] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.550737] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.553113] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.555434] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.557211] pnp: PnP ACPI: found 7 devices
[    0.558190] ACPI: bus type PNP unregistered
[    0.565457] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.567761] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.569919] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.571599] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.573782] NET: Registered protocol family 2
[    0.579228] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.581168] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.583208] TCP: Hash tables configured (established 2048 bind 2048)
[    0.584549] TCP: reno registered
[    0.585229] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.586719] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.588795] NET: Registered protocol family 1
[    0.591149] RPC: Registered named UNIX socket transport module.
[    0.593955] RPC: Registered udp transport module.
[    0.595475] RPC: Registered tcp transport module.
[    0.596559] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.597777] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.598660] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.599507] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.600625] pci 0000:00:02.0: Boot video device
[    0.601888] PCI: CLS 0 bytes, default 64
[    0.610928] Unpacking initramfs...
[   10.140528] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[   10.144248] has_svm: not amd
[   10.144993] kvm: no hardware support
[   10.146393] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[   10.169508] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[   10.173099] cryptomgr_test (24) used greatest stack depth: 6376 bytes left
[   10.174958] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[   10.177600] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[   10.179081] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[   10.180727] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[   10.182370] AVX or AES-NI instructions are not detected.
[   10.183684] AVX instructions are not detected.
[   10.187223] AVX instructions are not detected.
[   10.197195] AVX instructions are not detected.
[   10.217252] Initializing RT-Tester: OK
[   10.218174] audit: initializing netlink socket (disabled)
[   10.219489] type=2000 audit(1378709066.434:1): initialized
[   10.227569] DLM installed
[   10.236103] NFS: Registering the id_resolver key type
[   10.237595] Key type id_resolver registered
[   10.238589] Key type id_legacy registered
[   10.239538] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   10.241989] ROMFS MTD (C) 2007 Red Hat, Inc.
[   10.243137] fuse init (API version 7.22)
[   10.245592] ceph: loaded (mds proto 32)
[   10.265890] cryptomgr_test (43) used greatest stack depth: 5752 bytes left
[   10.269355] cryptomgr_test (44) used greatest stack depth: 5680 bytes left
[   10.286967] cryptomgr_test (72) used greatest stack depth: 5264 bytes left
[   10.302112] alg: No test for crc32 (crc32-table)
[   10.304543] alg: No test for lz4hc (lz4hc-generic)
[   10.311259] alg: No test for stdrng (krng)
[   10.312372] NET: Registered protocol family 38
[   10.313410] Key type asymmetric registered
[   10.314414] Asymmetric key parser 'x509' registered
[   10.315390] test_string_helpers: Running tests...
[   10.317249] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[   10.318032] crc32: self tests passed, processed 225944 bytes in 301563 nsec
[   10.319879] crc32c: CRC_LE_BITS = 32
[   10.320906] crc32c: self tests passed, processed 225944 bytes in 151224 nsec
[   10.324227] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[   10.325645] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[   10.327802] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[   10.329904] vmlfb: initializing
[   10.330825] Could not find Carillo Ranch MCH device.
[   10.332257] no IO addresses supplied
[   10.333471] hgafb: HGA card not detected.
[   10.334388] hgafb: probe of hgafb.0 failed with error -22
[   10.336873] usbcore: registered new interface driver udlfb
[   10.338233] usbcore: registered new interface driver smscufx
[   10.353036] uvesafb: failed to execute /sbin/v86d
[   10.355344] uvesafb: make sure that the v86d helper is installed and executable
[   10.361011] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[   10.365492] uvesafb: vbe_init() failed with -22
[   10.368418] uvesafb: probe of uvesafb.0 failed with error -22
[   10.372332] ipmi message handler version 39.2
[   10.375073] ipmi device interface
[   10.377364] IPMI System Interface driver.
[   10.379988] ipmi_si: Adding default-specified kcs state machine
[   10.383827] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   10.391212] ipmi_si: Interface detection failed
[   10.404239] ipmi_si: Adding default-specified smic state machine
[   10.405307] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[   10.406943] ipmi_si: Interface detection failed
[   10.416538] ipmi_si: Adding default-specified bt state machine
[   10.417504] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[   10.418985] ipmi_si: Interface detection failed
[   10.428333] kobject: 'ipmi_si' (ffff880007762a00): kobject_release, parent ffff8800001b7648 (delayed)
[   10.429911] kobject: 'ipmi_si' (ffff880007762800): kobject_release, parent ffff880000283648 (delayed)
[   10.431438] kobject: 'ipmi_si' (ffff880007762c00): kobject_release, parent ffff880000189248 (delayed)
[   10.432991] ipmi_si: Unable to find any System Interface(s)
[   10.433817] IPMI Watchdog: driver initialized
[   10.434544] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   10.436091] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   10.437181] ACPI: Power Button [PWRF]
[   10.479088] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   10.503653] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   10.507240] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[   10.511083] ac.o: No PCI boards found.
[   10.513021] ac.o: For an ISA board you must supply memory and irq parameters.
[   10.517090] Non-volatile memory driver v1.3
[   10.521879] Linux agpgart interface v0.103
[   10.524628] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[   10.527719] kobject: 'drm' (ffff880006dd9048): kobject_release, parent ffff880000189648 (delayed)
[   10.532338] kobject: 'drm' (ffff880006dd6000): kobject_release, parent           (null) (delayed)
[   10.537837] [drm] radeon kernel modesetting enabled.
[   10.541277] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[   10.544482] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[   10.548758] kobject: 'controlD64' (ffff880006dee820): kobject_release, parent           (null) (delayed)
[   10.559167] cirrus: probe of 0000:00:02.0 failed with error -1
[   10.560675] usbcore: registered new interface driver udl
[   10.564477] parport_pc 00:04: reported by Plug and Play ACPI
[   10.566322] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[   10.568845] kobject: 'parport_pc.956' (ffff880006dee820): kobject_release, parent           (null) (delayed)
[   10.573899] ------------[ cut here ]------------
[   10.576040] WARNING: CPU: 1 PID: 1 at /c/wfg/linux/lib/debugobjects.c:260 debug_print_object+0x7c/0x8d()
[   10.577824] ODEBUG: init active (active state 0) object type: timer_list hint:           (null)
[   10.577824] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc2-00010-gc817a67-dirty #22
[   10.577824]  0000000000000104 ffff88000010db78 ffffffff817b80f8 0000000000000000
[   10.577824]  ffff88000010dbc8 ffff88000010dbb8 ffffffff8108f040 0000000000000046
[   10.577824]  ffffffff81220eaa ffffffff81b60506 ffff880006ddb768 ffffffff81ba02d0
[   10.577824] Call Trace:
[   10.577824]  [<ffffffff817b80f8>] dump_stack+0x4f/0x84
[   10.577824]  [<ffffffff8108f040>] warn_slowpath_common+0x72/0x8c
[   10.577824]  [<ffffffff81220eaa>] ? debug_print_object+0x7c/0x8d
[   10.577824]  [<ffffffff8108f0be>] warn_slowpath_fmt+0x41/0x43
[   10.577824]  [<ffffffff81220eaa>] debug_print_object+0x7c/0x8d
[   10.577824]  [<ffffffff81221209>] __debug_object_init+0x27c/0x2c6
[   10.577824]  [<ffffffff81221244>] ? __debug_object_init+0x2b7/0x2c6
[   10.577824]  [<ffffffff81221267>] debug_object_init+0x14/0x16
[   10.577824]  [<ffffffff81098f20>] init_timer_key+0x23/0x65
[   10.577824]  [<ffffffff81210bbe>] kobject_release+0x90/0xba
[   10.577824]  [<ffffffff81210e3b>] kobject_put+0x4d/0x51
[   10.577824]  [<ffffffff813effd3>] put_device+0x12/0x14
[   10.577824]  [<ffffffff813f45e5>] platform_device_put+0x12/0x14
[   10.577824]  [<ffffffff813f496a>] platform_device_unregister+0x16/0x1a
[   10.577824]  [<ffffffff813ee3d6>] parport_pc_probe_port+0x7b7/0x7cc
[   10.577824]  [<ffffffff81d519e2>] parport_pc_init+0x2b0/0x317
[   10.577824]  [<ffffffff81d51732>] ? parport_setup+0x147/0x147
[   10.577824]  [<ffffffff81d2ce0c>] do_one_initcall+0x8e/0x132
[   10.577824]  [<ffffffff810a6c00>] ? param_array_set+0xa7/0xf2
[   10.577824]  [<ffffffff810a6e4d>] ? parse_args+0x1ad/0x26c
[   10.577824]  [<ffffffff81d2cfe2>] kernel_init_freeable+0x132/0x1bc
[   10.577824]  [<ffffffff81d2c6e3>] ? do_early_param+0x86/0x86
[   10.577824]  [<ffffffff817b1f5f>] ? rest_init+0xc3/0xc3
[   10.577824]  [<ffffffff817b1f68>] kernel_init+0x9/0xcc
[   10.577824]  [<ffffffff817c31bc>] ret_from_fork+0x7c/0xb0
[   10.577824]  [<ffffffff817b1f5f>] ? rest_init+0xc3/0xc3
[   10.577824] ---[ end trace 5ba675dcca8b802b ]---
[   10.663168] INFO: trying to register non-static key.
[   10.665566] the code is fine but needs lockdep annotation.
[   10.667133] turning off the locking correctness validator.
[   10.667133] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-rc2-00010-gc817a67-dirty #22
[   10.667133]  0000000000000046 ffff88000010da28 ffffffff817b80f8 0000000000000000
[   10.667133]  0000000000000000 ffff88000010daa8 ffffffff810c56de ffff88000010da88
[   10.667133]  ffffffff81090497 0000000000007aa4 0000000000000046 ffff88000010da78
[   10.667133] Call Trace:
[   10.667133]  [<ffffffff817b80f8>] dump_stack+0x4f/0x84
[   10.667133]  [<ffffffff810c56de>] register_lock_class+0x104/0x2b2
[   10.667133]  [<ffffffff81090497>] ? console_unlock+0x35b/0x36a
[   10.667133]  [<ffffffff810c798e>] __lock_acquire+0xf6/0xe3c
[   10.667133]  [<ffffffff817c29f7>] ? retint_restore_args+0x13/0x13
[   10.667133]  [<ffffffff810c6c25>] ? trace_hardirqs_on_caller+0x154/0x18b
[   10.667133]  [<ffffffff810c8afd>] lock_acquire+0x7e/0x99
[   10.667133]  [<ffffffff81099263>] ? try_to_del_timer_sync+0x5f/0x5f
[   10.667133]  [<ffffffff810992ac>] del_timer_sync+0x49/0xcb
[   10.667133]  [<ffffffff81099263>] ? try_to_del_timer_sync+0x5f/0x5f
[   10.667133]  [<ffffffff810cd647>] ? arch_local_irq_restore+0x6/0xd
[   10.667133]  [<ffffffff81099372>] timer_fixup_init+0x16/0x2f
[   10.667133]  [<ffffffff81220ce3>] debug_object_fixup+0x15/0x1d
[   10.667133]  [<ffffffff81221228>] __debug_object_init+0x29b/0x2c6
[   10.667133]  [<ffffffff81221244>] ? __debug_object_init+0x2b7/0x2c6
[   10.667133]  [<ffffffff81221267>] debug_object_init+0x14/0x16
[   10.667133]  [<ffffffff81098f20>] init_timer_key+0x23/0x65
[   10.667133]  [<ffffffff81210bbe>] kobject_release+0x90/0xba
[   10.667133]  [<ffffffff81210e3b>] kobject_put+0x4d/0x51
[   10.667133]  [<ffffffff813effd3>] put_device+0x12/0x14
[   10.667133]  [<ffffffff813f45e5>] platform_device_put+0x12/0x14
[   10.667133]  [<ffffffff813f496a>] platform_device_unregister+0x16/0x1a
[   10.667133]  [<ffffffff813ee3d6>] parport_pc_probe_port+0x7b7/0x7cc
[   10.667133]  [<ffffffff81d519e2>] parport_pc_init+0x2b0/0x317
[   10.667133]  [<ffffffff81d51732>] ? parport_setup+0x147/0x147
[   10.667133]  [<ffffffff81d2ce0c>] do_one_initcall+0x8e/0x132
[   10.667133]  [<ffffffff810a6c00>] ? param_array_set+0xa7/0xf2
[   10.667133]  [<ffffffff810a6e4d>] ? parse_args+0x1ad/0x26c
[   10.667133]  [<ffffffff81d2cfe2>] kernel_init_freeable+0x132/0x1bc
[   10.667133]  [<ffffffff81d2c6e3>] ? do_early_param+0x86/0x86
[   10.667133]  [<ffffffff817b1f5f>] ? rest_init+0xc3/0xc3
[   10.667133]  [<ffffffff817b1f68>] kernel_init+0x9/0xcc
[   10.667133]  [<ffffffff817c31bc>] ret_from_fork+0x7c/0xb0
[   10.667133]  [<ffffffff817b1f5f>] ? rest_init+0xc3/0xc3
[   11.144157] tsc: Refined TSC clocksource calibration: 2693.465 MHz
[   11.556083] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   11.557559] IP: [<          (null)>]           (null)
[   11.558515] PGD 0
[   11.558942] Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   11.559992] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.11.0-rc2-00010-gc817a67-dirty #22
[   11.560059] task: ffff8800001422c0 ti: ffff880000144000 task.ti: ffff880000144000
[   11.560059] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   11.560059] RSP: 0000:ffff88000dd03e40  EFLAGS: 00010286
[   11.560059] RAX: 0000000000000000 RBX: 0000000000000101 RCX: 0000000000000000
[   11.560059] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   11.560059] RBP: ffff88000dd03e98 R08: 0000000000000002 R09: 0000000000000000
[   11.560059] R10: ffff88000dd03e58 R11: ffff88000015c000 R12: ffff880000145fd8
[   11.560059] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88000015d058
[   11.560059] FS:  0000000000000000(0000) GS:ffff88000dd00000(0000) knlGS:0000000000000000
[   11.560059] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   11.560059] CR2: 0000000000000000 CR3: 0000000001b87000 CR4: 00000000000006a0
[   11.560059] Stack:
[   11.560059]  ffffffff8109861e ffffffff810985b3 ffff88000015c000 ffff880006dee8d8
[   11.560059]  0000000000000000 0000000000000000 0000000000000000 ffff88000015c000
[   11.560059]  ffff88000dd03ec8 ffff88000015d858 ffff88000015d458 ffff88000dd03f08
[   11.560059] Call Trace:
[   11.560059]  <IRQ>
[   11.560059]  [<ffffffff8109861e>] ? call_timer_fn+0x6b/0xde
[   11.560059]  [<ffffffff810985b3>] ? __internal_add_timer+0xc4/0xc4
[   11.560059]  [<ffffffff81098c49>] run_timer_softirq+0x187/0x1cf
[   11.560059]  [<ffffffff810951c4>] __do_softirq+0xc6/0x18f
[   11.560059]  [<ffffffff810953aa>] irq_exit+0x58/0x9e
[   11.560059]  [<ffffffff81044bab>] smp_apic_timer_interrupt+0x31/0x3e
[   11.560059]  [<ffffffff817c3ef2>] apic_timer_interrupt+0x72/0x80
[   11.560059]  <EOI>
[   11.560059]  [<ffffffff810c8a73>] ? lock_release+0x16e/0x17a
[   11.560059]  [<ffffffff810304be>] ? default_idle+0xe/0x1c
[   11.560059]  [<ffffffff81049eda>] ? native_safe_halt+0x6/0x8
[   11.560059]  [<ffffffff810c6c69>] ? trace_hardirqs_on+0xd/0xf
[   11.560059]  [<ffffffff810304c3>] default_idle+0x13/0x1c
[   11.560059]  [<ffffffff81030c33>] arch_cpu_idle+0x13/0x21
[   11.560059]  [<ffffffff810bd035>] cpu_startup_entry+0xfc/0x164
[   11.560059]  [<ffffffff810434c5>] start_secondary+0x1f0/0x1f7
[   11.560059] Code:  Bad RIP value.
[   11.560059] RIP  [<          (null)>]           (null)
[   11.560059]  RSP <ffff88000dd03e40>
[   11.560059] CR2: 0000000000000000
[   11.634717] ---[ end trace 5ba675dcca8b802c ]---
[   11.635882] Kernel panic - not syncing: Fatal exception in interrupt
[   11.637620] Rebooting in 10 seconds..

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config.bad4"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.11.0-rc2 Kernel Configuration
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
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
CONFIG_COMPILE_TEST=y
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
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
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
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
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
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
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
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
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
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
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
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
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
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
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
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
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
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
# CONFIG_RDS_TCP is not set
CONFIG_RDS_DEBUG=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_LL_RX_POLL=y
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
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

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
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_NCI_SPI=y
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
# CONFIG_NFC_SIM is not set
CONFIG_NFC_PN544=y
CONFIG_NFC_PN544_I2C=y
CONFIG_NFC_MICROREAD=y
# CONFIG_NFC_MICROREAD_I2C is not set
CONFIG_HAVE_BPF_JIT=y

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

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
CONFIG_MTD_CFI_INTELEXT=y
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
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_PCMCIA is not set
CONFIG_MTD_GPIO_ADDR=y
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
# CONFIG_M25PXX_USE_FAST_READ is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

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
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ALAUDA is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
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
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_VMWARE_VMCI=y
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
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

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
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

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
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_PCAP=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
# CONFIG_INPUT_AD714X_SPI is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_PCAP=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_ADXL34X_SPI is not set
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=y
# CONFIG_INPUT_CMA3000_I2C is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

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
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MRST_MAX3110 is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
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
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
CONFIG_GPIO_MC33880=y
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

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
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
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
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_RC5T583 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
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
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
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
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_LP8788 is not set
# CONFIG_BACKLIGHT_OT200 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_APPLEIR=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
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
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX8997=y
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TPS6586X=y
CONFIG_RTC_DRV_TPS65910=y
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
CONFIG_RTC_DRV_MC13XXX=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
# CONFIG_VIRT_DRIVERS is not set
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
CONFIG_STAGING=y
CONFIG_SLICOSS=y
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
CONFIG_USBIP_HOST=y
CONFIG_USBIP_DEBUG=y
CONFIG_ECHO=y
# CONFIG_ASUS_OLED is not set
# CONFIG_PANEL is not set
CONFIG_TRANZPORT=y
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16203 is not set
CONFIG_ADIS16204=y
CONFIG_ADIS16209=y
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=y
CONFIG_LIS3L02DQ=y
CONFIG_SCA3000=y

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y
# CONFIG_AD7780 is not set
# CONFIG_AD7816 is not set
# CONFIG_AD7192 is not set
CONFIG_AD7280=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=y
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#
CONFIG_AD5930=y
CONFIG_AD9832=y
CONFIG_AD9834=y
# CONFIG_AD9850 is not set
CONFIG_AD9852=y
CONFIG_AD9910=y
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y
CONFIG_ADIS16260=y

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
CONFIG_ADE7754=y
# CONFIG_ADE7758 is not set
CONFIG_ADE7759=y
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
CONFIG_ADE7854_SPI=y

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
CONFIG_AD2S1200=y
CONFIG_AD2S1210=y

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_ZSMALLOC=y
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
CONFIG_FT1000=y
CONFIG_FT1000_USB=y
CONFIG_FT1000_PCMCIA=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
CONFIG_WIMAX_GDM72XX=y
# CONFIG_WIMAX_GDM72XX_QOS is not set
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
CONFIG_WIMAX_GDM72XX_USB_PM=y
CONFIG_CED1401=y
# CONFIG_DGRP is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
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
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

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
# CONFIG_EXTCON_MAX8997 is not set
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
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_KXSD9=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
# CONFIG_AD7298 is not set
CONFIG_AD7923=y
CONFIG_AD7791=y
# CONFIG_AD7793 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7887 is not set
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
CONFIG_MCP320X=y
CONFIG_TI_ADC081C=y
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5360=y
CONFIG_AD5380=y
CONFIG_AD5421=y
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5446=y
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
CONFIG_AD5755=y
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
# CONFIG_AD5686 is not set
CONFIG_AD7303=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
CONFIG_ADIS16136=y
CONFIG_ADXRS450=y
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_SENSORS_LM3533=y
CONFIG_SENSORS_TSL2563=y
CONFIG_VCNL4000=y
CONFIG_HID_SENSOR_ALS=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure Sensors
#
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_VME_USER=y
# CONFIG_VME_PIO2 is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
# CONFIG_FMC_WRITE_EEPROM is not set
# CONFIG_FMC_CHARDEV is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
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
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_LOGFS=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
# CONFIG_NFSD_V3 is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_RPCSEC_GSS_KRB5 is not set
CONFIG_CEPH_FS=y
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

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
CONFIG_ENABLE_WARN_DEPRECATED=y
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
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
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
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
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
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
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
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
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
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=y
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--TB36FDmn/VVEgNH/--
