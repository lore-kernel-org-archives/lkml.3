Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3ANCbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:31:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:34713 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab3ANCbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:31:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,465,1355126400"; 
   d="log'?scan'208";a="273349509"
Date: Mon, 14 Jan 2013 10:31:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at x86/lib/debugobjects.c:908
 check_results.constprop.9+0x129/0x153()
Message-ID: <20130114023107.GA9061@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stephen,

I got this warning when testing kernels in kvm:

[    0.000000] --------------------------------------------------------
[    0.000000] 133 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ODEBUG: 8 of 8 active objects replaced
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /c/kernel-tests/src/x86/lib/debugobjects.c:908 check_results.constprop.9+0x129/0x153()
[    0.000000] Hardware name: Bochs
[    0.000000] ODEBUG: selftest warnings failed 4 != 5
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.2.0-06292-g59a5680 #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff810587ea>] warn_slowpath_common+0x7a/0xb0
[    0.000000]  [<ffffffff818ff01f>] ? check_results.constprop.9+0x35/0x153
[    0.000000]  [<ffffffff81058896>] warn_slowpath_fmt+0x46/0x50
[    0.000000]  [<ffffffff81435c81>] ? _raw_spin_lock_irqsave+0x61/0x70
[    0.000000]  [<ffffffff818ff01f>] ? check_results.constprop.9+0x35/0x153
[    0.000000]  [<ffffffff818ff113>] check_results.constprop.9+0x129/0x153
[    0.000000]  [<ffffffff818ff6d6>] debug_objects_mem_init+0x412/0x4a6
[    0.000000]  [<ffffffff818e0a15>] start_kernel+0x3c0/0x443
[    0.000000]  [<ffffffff818e0000>] ? __init_begin+0x14000/0x14000
[    0.000000]  [<ffffffff818e0156>] x86_64_start_reservations+0x131/0x135
[    0.000000]  [<ffffffff818e0259>] x86_64_start_kernel+0xff/0x10e
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3092.385 MHz processor.
[    0.008004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6184.77 BogoMIPS (lpj=12369540)

feac18dda25134005909e7770c77464e65608bd8 is the first bad commit

commit feac18dda25134005909e7770c77464e65608bd8
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Mon Nov 7 19:48:26 2011 -0800

    debugobjects: Be smarter about static objects

    Make debugobjects use the return code from the fixup function. That
    allows us better diagnostics in the activate check than relying on a
    WARN_ON() in the object specific code.

    [ tglx@linutronix.de: Split out the debugobjects vs. the timer change ]

    Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
    Cc: Christine Chan <cschan@codeaurora.org>
    Cc: John Stultz <john.stultz@linaro.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Link: http://lkml.kernel.org/r/1320724108-20788-2-git-send-email-sboyd@codeaurora.org
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Thanks,
Fengguang

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-xbm-3423-2013-01-09-14-27-30-3.2.0-06292-g59a5680-1"

[    0.000000] Linux version 3.2.0-06292-g59a5680 (kbuild@bee) (gcc version 4.7.2 (Debian 4.7.2-4) ) #1 SMP Wed Jan 9 14:23:21 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=char-misc/char-misc-next log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-01-09-14-23-33-char-misc:char-misc-next:627ca75-59a5680-x86_64-randconfig-x903-1-xbm BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-x903/59a5680/vmlinuz-3.2.0-06292-g59a5680
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000000fffe000 (usable)
[    0.000000]  BIOS-e820: 000000000fffe000 - 0000000010000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0xfffe max_arch_pfn = 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000fdae0] fdae0
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009d000] 9d000 size 8192
[    0.000000] init_memory_mapping: 0000000000000000-000000000fffe000
[    0.000000]  0000000000 - 000fe00000 page 2M
[    0.000000]  000fe00000 - 000fffe000 page 4k
[    0.000000] kernel direct mapping tables up to fffe000 @ fffb000-fffe000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127934(97%)
[    0.000000] RAMDISK: 0e8d6000 - 0fff0000
[    0.000000] ACPI: RSDP 00000000000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0000fffe
[    0.000000] On node 0 totalpages: 65421
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 2 pages reserved
[    0.000000]   DMA zone: 3917 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 60478 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at 10000000 (gap: 10000000:eeffc000)
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88000de00000 s80888 r0 d21512 u1048576
[    0.000000] pcpu-alloc: s80888 r0 d21512 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr de0df00
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64395
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=char-misc/char-misc-next log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-01-09-14-23-33-char-misc:char-misc-next:627ca75-59a5680-x86_64-randconfig-x903-1-xbm BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-x903/59a5680/vmlinuz-3.2.0-06292-g59a5680
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 206908k/262136k available (4323k kernel code, 452k absent, 54776k reserved, 4679k data, 660k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.000000]             mixed read-write-lock:             |failed|             |failed|
[    0.000000]             mixed write-read-lock:             |failed|             |failed|
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
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
[    0.000000] --------------------------------------------------------
[    0.000000] 133 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ODEBUG: 8 of 8 active objects replaced
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /c/kernel-tests/src/x86/lib/debugobjects.c:908 check_results.constprop.9+0x129/0x153()
[    0.000000] Hardware name: Bochs
[    0.000000] ODEBUG: selftest warnings failed 4 != 5
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.2.0-06292-g59a5680 #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff810587ea>] warn_slowpath_common+0x7a/0xb0
[    0.000000]  [<ffffffff818ff01f>] ? check_results.constprop.9+0x35/0x153
[    0.000000]  [<ffffffff81058896>] warn_slowpath_fmt+0x46/0x50
[    0.000000]  [<ffffffff81435c81>] ? _raw_spin_lock_irqsave+0x61/0x70
[    0.000000]  [<ffffffff818ff01f>] ? check_results.constprop.9+0x35/0x153
[    0.000000]  [<ffffffff818ff113>] check_results.constprop.9+0x129/0x153
[    0.000000]  [<ffffffff818ff6d6>] debug_objects_mem_init+0x412/0x4a6
[    0.000000]  [<ffffffff818e0a15>] start_kernel+0x3c0/0x443
[    0.000000]  [<ffffffff818e0000>] ? __init_begin+0x14000/0x14000
[    0.000000]  [<ffffffff818e0156>] x86_64_start_reservations+0x131/0x135
[    0.000000]  [<ffffffff818e0259>] x86_64_start_kernel+0xff/0x10e
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3092.385 MHz processor.
[    0.008004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6184.77 BogoMIPS (lpj=12369540)
[    0.009979] pid_max: default: 4096 minimum: 301
[    0.010941] Mount-cache hash table entries: 256
[    0.012244] Initializing cgroup subsys devices
[    0.013086] Initializing cgroup subsys freezer
[    0.014016] mce: CPU supports 10 MCE banks
[    0.019713] ACPI: Core revision 20110623
[    0.021682] ftrace: allocating 14451 entries in 57 pages
[    0.024213] Getting VERSION: 50014
[    0.028017] Getting VERSION: 50014
[    0.028655] Getting ID: 0
[    0.029163] Getting ID: ff000000
[    0.029766] Getting LVT0: 8700
[    0.030342] Getting LVT1: 8400
[    0.030995] enabled ExtINT on CPU#0
[    0.033018] ENABLING IO-APIC IRQs
[    0.033643] init IO_APIC IRQs
[    0.034204]  apic 2 pin 0 not connected
[    0.034917] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.036033] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.037493] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.038936] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.040029] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.041471] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.042899] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.044029] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.045473] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.048030] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.049502] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.050972] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.052029] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.053500] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.054974] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.056025]  apic 2 pin 16 not connected
[    0.056747]  apic 2 pin 17 not connected
[    0.057467]  apic 2 pin 18 not connected
[    0.058183]  apic 2 pin 19 not connected
[    0.058894]  apic 2 pin 20 not connected
[    0.060007]  apic 2 pin 21 not connected
[    0.060730]  apic 2 pin 22 not connected
[    0.061454]  apic 2 pin 23 not connected
[    0.062316] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.064007] CPU0: Intel Common KVM processor stepping 01
[    0.065302] Using local APIC timer interrupts.
[    0.065303] calibrating APIC timer ...
[    0.068003] ... lapic delta = 6249975
[    0.068003] ... PM-Timer delta = 357952
[    0.068003] ... PM-Timer result ok
[    0.068003] ..... delta 6249975
[    0.068003] ..... mult: 268417606
[    0.068003] ..... calibration result: 3999984
[    0.068003] ..... CPU clock speed is 3092.3766 MHz.
[    0.068003] ..... host bus clock speed is 999.3984 MHz.
[    0.068079] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.070616] lockdep: fixing up alternatives.
[    0.071718] Booting Node   0, Processors  #1 Ok.
[    0.072224] smpboot cpu 1: start_ip = 9d000
[    0.012000] masked ExtINT on CPU#1
[    0.172063] KVM setup async PF for cpu 1
[    0.172079] Brought up 2 CPUs
[    0.172082] Total of 2 processors activated (12370.69 BogoMIPS).
[    0.172383] kvm-stealtime: cpu 1, msr df0df00
[    0.176155] devtmpfs: initialized
[    0.176803] device: 'platform': device_add
[    0.177554] PM: Adding info for No Bus:platform
[    0.178397] bus: 'platform': registered
[    0.179104] bus: 'cpu': registered
[    0.179726] device: 'cpu': device_add
[    0.180016] PM: Adding info for No Bus:cpu
[    0.180946] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.182182] device class 'regulator': registering
[    0.183090] Registering platform device 'reg-dummy'. Parent at platform
[    0.184016] device: 'reg-dummy': device_add
[    0.184785] bus: 'platform': add device reg-dummy
[    0.185638] PM: Adding info for platform:reg-dummy
[    0.186529] bus: 'platform': add driver reg-dummy
[    0.188018] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.189570] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.191032] device: 'regulator.0': device_add
[    0.191829] PM: Adding info for No Bus:regulator.0
[    0.192036] print_constraints: dummy: 
[    0.192731] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.193961] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.196115] NET: Registered protocol family 16
[    0.196935] device class 'bdi': registering
[    0.197714] device class 'pci_bus': registering
[    0.198538] bus: 'pci': registered
[    0.199163] device class 'lcd': registering
[    0.200023] device class 'backlight': registering
[    0.200883] device class 'tty': registering
[    0.201687] bus: 'spi': registered
[    0.202310] device class 'spi_master': registering
[    0.203186] bus: 'i2c': registered
[    0.203814] bus: 'i2c': add driver dummy
[    0.204023] i2c-core: driver [dummy] registered
[    0.204926] ACPI: bus type pci registered
[    0.205666] device class 'dma': registering
[    0.206448] device class 'dmi': registering
[    0.207216] device: 'id': device_add
[    0.208019] PM: Adding info for No Bus:id
[    0.208765] dca service started, version 1.12.1
[    0.209587] device class 'dca': registering
[    0.210383] PCI: Using configuration type 1 for base access
[    0.211381] device: 'cpu0': device_add
[    0.212017] bus: 'cpu': add device cpu0
[    0.212711] PM: Adding info for cpu:cpu0
[    0.213445] device: 'cpu1': device_add
[    0.214121] bus: 'cpu': add device cpu1
[    0.214821] PM: Adding info for cpu:cpu1
[    0.216163] device: 'default': device_add
[    0.216905] PM: Adding info for No Bus:default
[    0.217933] bus: 'i2c': add driver max7300
[    0.218696] i2c-core: driver [max7300] registered
[    0.219545] bus: 'i2c': add driver max732x
[    0.220023] i2c-core: driver [max732x] registered
[    0.220874] bus: 'spi': add driver mc33880
[    0.221628] bus: 'i2c': add driver pcf857x
[    0.222368] i2c-core: driver [pcf857x] registered
[    0.223216] bus: 'i2c': add driver sx150x
[    0.224023] i2c-core: driver [sx150x] registered
[    0.224861] bus: 'platform': add driver tps65912-gpio
[    0.225772] bus: 'platform': add driver wm831x-gpio
[    0.226663] device class 'graphics': registering
[    0.227505] bus: 'platform': add driver aat2870-backlight
[    0.228038] ACPI: Added _OSI(Module Device)
[    0.228792] ACPI: Added _OSI(Processor Device)
[    0.229591] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.230438] ACPI: Added _OSI(Processor Aggregator Device)
[    0.233571] ACPI: EC: Look up EC in DSDT
[    0.237804] ACPI: Interpreter enabled
[    0.238483] ACPI: (supports S0 S5)
[    0.239177] ACPI: Using IOAPIC for interrupt routing
[    0.240031] bus: 'acpi': registered
[    0.240672] bus: 'acpi': add driver power
[    0.241425] device: 'LNXSYSTM:00': device_add
[    0.242220] bus: 'acpi': add device LNXSYSTM:00
[    0.243040] PM: Adding info for acpi:LNXSYSTM:00
[    0.244038] device: 'device:00': device_add
[    0.244807] bus: 'acpi': add device device:00
[    0.245585] PM: Adding info for acpi:device:00
[    0.246439] device: 'PNP0A03:00': device_add
[    0.247220] bus: 'acpi': add device PNP0A03:00
[    0.248019] PM: Adding info for acpi:PNP0A03:00
[    0.249357] device: 'device:01': device_add
[    0.250128] bus: 'acpi': add device device:01
[    0.250913] PM: Adding info for acpi:device:01
[    0.251802] device: 'device:02': device_add
[    0.252020] bus: 'acpi': add device device:02
[    0.252812] PM: Adding info for acpi:device:02
[    0.253661] device: 'PNP0B00:00': device_add
[    0.254446] bus: 'acpi': add device PNP0B00:00
[    0.255246] PM: Adding info for acpi:PNP0B00:00
[    0.256086] device: 'PNP0303:00': device_add
[    0.256868] bus: 'acpi': add device PNP0303:00
[    0.257672] PM: Adding info for acpi:PNP0303:00
[    0.258553] device: 'PNP0F13:00': device_add
[    0.259336] bus: 'acpi': add device PNP0F13:00
[    0.260020] PM: Adding info for acpi:PNP0F13:00
[    0.260897] device: 'PNP0700:00': device_add
[    0.261673] bus: 'acpi': add device PNP0700:00
[    0.262474] PM: Adding info for acpi:PNP0700:00
[    0.264178] device: 'PNP0400:00': device_add
[    0.264961] bus: 'acpi': add device PNP0400:00
[    0.265759] PM: Adding info for acpi:PNP0400:00
[    0.266708] device: 'PNP0501:00': device_add
[    0.267483] bus: 'acpi': add device PNP0501:00
[    0.268021] PM: Adding info for acpi:PNP0501:00
[    0.268941] device: 'device:03': device_add
[    0.269707] bus: 'acpi': add device device:03
[    0.270487] PM: Adding info for acpi:device:03
[    0.271343] device: 'device:04': device_add
[    0.272021] bus: 'acpi': add device device:04
[    0.272807] PM: Adding info for acpi:device:04
[    0.273652] device: 'device:05': device_add
[    0.274415] bus: 'acpi': add device device:05
[    0.275191] PM: Adding info for acpi:device:05
[    0.276074] device: 'device:06': device_add
[    0.276839] bus: 'acpi': add device device:06
[    0.277624] PM: Adding info for acpi:device:06
[    0.278475] device: 'device:07': device_add
[    0.279221] bus: 'acpi': add device device:07
[    0.280021] PM: Adding info for acpi:device:07
[    0.280875] device: 'device:08': device_add
[    0.281642] bus: 'acpi': add device device:08
[    0.282425] PM: Adding info for acpi:device:08
[    0.283269] device: 'device:09': device_add
[    0.284022] bus: 'acpi': add device device:09
[    0.284808] PM: Adding info for acpi:device:09
[    0.285665] device: 'device:0a': device_add
[    0.286428] bus: 'acpi': add device device:0a
[    0.287205] PM: Adding info for acpi:device:0a
[    0.288077] device: 'device:0b': device_add
[    0.288845] bus: 'acpi': add device device:0b
[    0.289637] PM: Adding info for acpi:device:0b
[    0.290525] device: 'device:0c': device_add
[    0.291286] bus: 'acpi': add device device:0c
[    0.292022] PM: Adding info for acpi:device:0c
[    0.292880] device: 'device:0d': device_add
[    0.293645] bus: 'acpi': add device device:0d
[    0.294436] PM: Adding info for acpi:device:0d
[    0.295291] device: 'device:0e': device_add
[    0.296023] bus: 'acpi': add device device:0e
[    0.296811] PM: Adding info for acpi:device:0e
[    0.297666] device: 'device:0f': device_add
[    0.298429] bus: 'acpi': add device device:0f
[    0.299214] PM: Adding info for acpi:device:0f
[    0.300076] device: 'device:10': device_add
[    0.300844] bus: 'acpi': add device device:10
[    0.301632] PM: Adding info for acpi:device:10
[    0.302487] device: 'device:11': device_add
[    0.303251] bus: 'acpi': add device device:11
[    0.304022] PM: Adding info for acpi:device:11
[    0.304877] device: 'device:12': device_add
[    0.305640] bus: 'acpi': add device device:12
[    0.306429] PM: Adding info for acpi:device:12
[    0.307284] device: 'device:13': device_add
[    0.308023] bus: 'acpi': add device device:13
[    0.308849] PM: Adding info for acpi:device:13
[    0.309708] device: 'device:14': device_add
[    0.310472] bus: 'acpi': add device device:14
[    0.311255] PM: Adding info for acpi:device:14
[    0.312077] device: 'device:15': device_add
[    0.312841] bus: 'acpi': add device device:15
[    0.313628] PM: Adding info for acpi:device:15
[    0.314481] device: 'device:16': device_add
[    0.315241] bus: 'acpi': add device device:16
[    0.316023] PM: Adding info for acpi:device:16
[    0.316878] device: 'device:17': device_add
[    0.317638] bus: 'acpi': add device device:17
[    0.318422] PM: Adding info for acpi:device:17
[    0.319270] device: 'device:18': device_add
[    0.320024] bus: 'acpi': add device device:18
[    0.320812] PM: Adding info for acpi:device:18
[    0.321666] device: 'device:19': device_add
[    0.322429] bus: 'acpi': add device device:19
[    0.323213] PM: Adding info for acpi:device:19
[    0.324077] device: 'device:1a': device_add
[    0.324839] bus: 'acpi': add device device:1a
[    0.325625] PM: Adding info for acpi:device:1a
[    0.326479] device: 'device:1b': device_add
[    0.327243] bus: 'acpi': add device device:1b
[    0.328024] PM: Adding info for acpi:device:1b
[    0.328922] device: 'device:1c': device_add
[    0.329691] bus: 'acpi': add device device:1c
[    0.330480] PM: Adding info for acpi:device:1c
[    0.331332] device: 'device:1d': device_add
[    0.332025] bus: 'acpi': add device device:1d
[    0.332800] PM: Adding info for acpi:device:1d
[    0.333656] device: 'device:1e': device_add
[    0.334420] bus: 'acpi': add device device:1e
[    0.335203] PM: Adding info for acpi:device:1e
[    0.336078] device: 'device:1f': device_add
[    0.336830] bus: 'acpi': add device device:1f
[    0.337614] PM: Adding info for acpi:device:1f
[    0.338467] device: 'device:20': device_add
[    0.339228] bus: 'acpi': add device device:20
[    0.340025] PM: Adding info for acpi:device:20
[    0.340872] device: 'device:21': device_add
[    0.341631] bus: 'acpi': add device device:21
[    0.342414] PM: Adding info for acpi:device:21
[    0.344031] device: 'device:22': device_add
[    0.344796] bus: 'acpi': add device device:22
[    0.345573] PM: Adding info for acpi:device:22
[    0.346586] device: 'PNP0103:00': device_add
[    0.347373] bus: 'acpi': add device PNP0103:00
[    0.348025] PM: Adding info for acpi:PNP0103:00
[    0.349026] device: 'PNP0C0F:00': device_add
[    0.349806] bus: 'acpi': add device PNP0C0F:00
[    0.350606] PM: Adding info for acpi:PNP0C0F:00
[    0.351551] device: 'PNP0C0F:01': device_add
[    0.352026] bus: 'acpi': add device PNP0C0F:01
[    0.352834] PM: Adding info for acpi:PNP0C0F:01
[    0.353785] device: 'PNP0C0F:02': device_add
[    0.354560] bus: 'acpi': add device PNP0C0F:02
[    0.355367] PM: Adding info for acpi:PNP0C0F:02
[    0.356173] device: 'PNP0C0F:03': device_add
[    0.356963] bus: 'acpi': add device PNP0C0F:03
[    0.357763] PM: Adding info for acpi:PNP0C0F:03
[    0.358715] device: 'PNP0C0F:04': device_add
[    0.360027] bus: 'acpi': add device PNP0C0F:04
[    0.360837] PM: Adding info for acpi:PNP0C0F:04
[    0.361731] device: 'LNXCPU:00': device_add
[    0.362489] bus: 'acpi': add device LNXCPU:00
[    0.363276] PM: Adding info for acpi:LNXCPU:00
[    0.364092] device: 'LNXCPU:01': device_add
[    0.364860] bus: 'acpi': add device LNXCPU:01
[    0.365647] PM: Adding info for acpi:LNXCPU:01
[    0.366489] device: 'device:23': device_add
[    0.367269] bus: 'acpi': add device device:23
[    0.368027] PM: Adding info for acpi:device:23
[    0.368896] device: 'LNXPWRBN:00': device_add
[    0.369688] bus: 'acpi': add device LNXPWRBN:00
[    0.370503] PM: Adding info for acpi:LNXPWRBN:00
[    0.371648] bus: 'acpi': add driver ec
[    0.372070] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.373778] bus: 'acpi': add driver pci_root
[    0.374554] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    0.376029] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    0.377438] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.378572] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.380028] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.381360] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.382795] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.384027] PCI: root bus 00: using default resources
[    0.384930] device: 'pci0000:00': device_add
[    0.385710] PM: Adding info for No Bus:pci0000:00
[    0.386560] device: '0000:00': device_add
[    0.387289] PM: Adding info for No Bus:0000:00
[    0.388043] PCI host bridge to bus 0000:00
[    0.388783] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.389884] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    0.391131] pci_bus 0000:00: scanning bus
[    0.392106] pci 0000:00:00.0: [8086:1237] type 0 class 0x000600
[    0.393168] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.394659] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x172
[    0.396040] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x26
[    0.397422] pci 0000:00:01.0: [8086:7000] type 0 class 0x000601
[    0.398494] pci 0000:00:01.0: calling quirk_mmio_always_on+0x0/0x17
[    0.400642] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x172
[    0.401843] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x26
[    0.403208] pci 0000:00:01.1: [8086:7010] type 0 class 0x000101
[    0.404046] pci 0000:00:01.1: calling quirk_mmio_always_on+0x0/0x17
[    0.408346] pci 0000:00:01.1: reg 20: [io  0xc040-0xc04f]
[    0.410563] pci 0000:00:01.1: calling quirk_resource_alignment+0x0/0x172
[    0.411759] pci 0000:00:01.1: calling pci_fixup_transparent_bridge+0x0/0x26
[    0.412183] pci 0000:00:01.3: [8086:7113] type 0 class 0x000680
[    0.413261] pci 0000:00:01.3: calling quirk_mmio_always_on+0x0/0x17
[    0.414381] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x38
[    0.416662] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x154
[    0.417753] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.419051] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.420100] pci 0000:00:01.3: calling quirk_resource_alignment+0x0/0x172
[    0.421294] pci 0000:00:01.3: calling pci_fixup_transparent_bridge+0x0/0x26
[    0.422528] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x10
[    0.424230] pci 0000:00:02.0: [1013:00b8] type 0 class 0x000300
[    0.425310] pci 0000:00:02.0: calling quirk_mmio_always_on+0x0/0x17
[    0.428721] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.432107] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.440078] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.441379] pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x172
[    0.442779] pci 0000:00:03.0: [8086:100e] type 0 class 0x000200
[    0.444054] pci 0000:00:03.0: calling quirk_mmio_always_on+0x0/0x17
[    0.446296] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.448602] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.455288] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.456066] pci 0000:00:03.0: calling quirk_resource_alignment+0x0/0x172
[    0.457261] pci 0000:00:03.0: calling pci_fixup_transparent_bridge+0x0/0x26
[    0.458640] pci 0000:00:04.0: [8086:25ab] type 0 class 0x000880
[    0.460050] pci 0000:00:04.0: calling quirk_mmio_always_on+0x0/0x17
[    0.461771] pci 0000:00:04.0: reg 10: [mem 0xfebf1000-0xfebf100f]
[    0.466398] pci 0000:00:04.0: calling quirk_resource_alignment+0x0/0x172
[    0.467598] pci 0000:00:04.0: calling pci_fixup_transparent_bridge+0x0/0x26
[    0.468484] pci_bus 0000:00: fixups for bus
[    0.469246] pci_bus 0000:00: bus scan returning with max=00
[    0.470241] pci_bus 0000:00: on NUMA node 0
[    0.471053] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.472987]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x18)
[    0.474340] device: '0000:00:00.0': device_add
[    0.476669] bus: 'pci': add device 0000:00:00.0
[    0.477494] PM: Adding info for pci:0000:00:00.0
[    0.478393] device: '0000:00:01.0': device_add
[    0.479764] bus: 'pci': add device 0000:00:01.0
[    0.480039] PM: Adding info for pci:0000:00:01.0
[    0.480878] device: '0000:00:01.1': device_add
[    0.482248] bus: 'pci': add device 0000:00:01.1
[    0.483075] PM: Adding info for pci:0000:00:01.1
[    0.484043] device: '0000:00:01.3': device_add
[    0.485411] bus: 'pci': add device 0000:00:01.3
[    0.486230] PM: Adding info for pci:0000:00:01.3
[    0.487065] device: '0000:00:02.0': device_add
[    0.488597] bus: 'pci': add device 0000:00:02.0
[    0.489428] PM: Adding info for pci:0000:00:02.0
[    0.490272] device: '0000:00:03.0': device_add
[    0.492143] bus: 'pci': add device 0000:00:03.0
[    0.492969] PM: Adding info for pci:0000:00:03.0
[    0.493808] device: '0000:00:04.0': device_add
[    0.495163] bus: 'pci': add device 0000:00:04.0
[    0.495988] PM: Adding info for pci:0000:00:04.0
[    0.496051] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    0.497273] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    0.498650] bus: 'acpi': add driver pci_link
[    0.500054] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    0.501553] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    0.503034] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.504422] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    0.505652] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    0.506980] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    0.508035] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    0.509483] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.510688] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    0.512036] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    0.513362] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    0.514847] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    0.516098] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.517319] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    0.518543] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    0.520038] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    0.521537] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    0.522979] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.524417] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    0.525648] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    0.526972] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    0.528036] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    0.529487] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.530594] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    0.532037] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    0.533414] bus: 'pnp': registered
[    0.534046] bus: 'xen-backend': registered
[    0.534806] bus: 'xen': registered
[    0.535439] bus: 'platform': add driver reg-fixed-voltage
[    0.536049] bus: 'platform': add driver gpio-regulator
[    0.537000] bus: 'i2c': add driver ad5398
[    0.537733] i2c-core: driver [ad5398] registered
[    0.538565] bus: 'i2c': add driver max8649
[    0.540042] i2c-core: driver [max8649] registered
[    0.540893] bus: 'i2c': add driver max8660
[    0.541628] i2c-core: driver [max8660] registered
[    0.542475] bus: 'i2c': add driver max8952
[    0.543219] i2c-core: driver [max8952] registered
[    0.544039] bus: 'platform': add driver max8997-pmic
[    0.544943] bus: 'platform': add driver wm831x-buckv
[    0.545842] bus: 'platform': add driver wm831x-buckp
[    0.546741] bus: 'platform': add driver wm831x-boostp
[    0.547655] bus: 'platform': add driver wm831x-epe
[    0.548044] bus: 'platform': add driver wm831x-isink
[    0.548944] bus: 'platform': add driver wm831x-ldo
[    0.549818] bus: 'platform': add driver wm831x-aldo
[    0.550705] bus: 'platform': add driver wm831x-alive-ldo
[    0.552045] bus: 'platform': add driver wm8400-regulator
[    0.553005] bus: 'platform': add driver wm8994-ldo
[    0.553876] bus: 'platform': add driver mc13783-regulator
[    0.554861] bus: 'platform': add driver mc13892-regulator
[    0.556049] bus: 'i2c': add driver tps65023
[    0.556813] i2c-core: driver [tps65023] registered
[    0.557673] bus: 'i2c': add driver isl6271a
[    0.558430] i2c-core: driver [isl6271a] registered
[    0.559296] device class 'misc': registering
[    0.560067] bus: 'i2c': add driver 88PM860x
[    0.560831] i2c-core: driver [88PM860x] registered
[    0.561696] bus: 'i2c': add driver tc3589x
[    0.562428] i2c-core: driver [tc3589x] registered
[    0.563275] bus: 'i2c': add driver WM8400
[    0.564044] i2c-core: driver [WM8400] registered
[    0.564886] bus: 'i2c': add driver wm831x
[    0.565611] i2c-core: driver [wm831x] registered
[    0.566450] bus: 'i2c': add driver tps6105x
[    0.567208] i2c-core: driver [tps6105x] registered
[    0.568040] tps65010: version 2 May 2005
[    0.568752] bus: 'i2c': add driver tps65010
[    0.569507] i2c-core: driver [tps65010] registered
[    0.570390] bus: 'i2c': remove driver tps65010
[    0.571196] driver: 'tps65010': driver_release
[    0.572039] i2c-core: driver [tps65010] unregistered
[    0.588064] bus: 'i2c': add driver tps65010
[    0.588842] i2c-core: driver [tps65010] registered
[    0.589694] bus: 'i2c': remove driver tps65010
[    0.590501] driver: 'tps65010': driver_release
[    0.591303] i2c-core: driver [tps65010] unregistered
[    0.608048] bus: 'i2c': add driver tps65010
[    0.608820] i2c-core: driver [tps65010] registered
[    0.609676] bus: 'i2c': remove driver tps65010
[    0.610482] driver: 'tps65010': driver_release
[    0.611289] i2c-core: driver [tps65010] unregistered
[    0.612041] tps65010: no chip?
[    0.612609] bus: 'i2c': add driver tps6507x
[    0.613365] i2c-core: driver [tps6507x] registered
[    0.614232] bus: 'i2c': add driver tps65910
[    0.614996] i2c-core: driver [tps65910] registered
[    0.616043] bus: 'i2c': add driver tps65912
[    0.616810] i2c-core: driver [tps65912] registered
[    0.617675] bus: 'spi': add driver mc13xxx
[    0.618428] bus: 'i2c': add driver da9052
[    0.619159] i2c-core: driver [da9052] registered
[    0.619999] bus: 'i2c': add driver max8925
[    0.620054] i2c-core: driver [max8925] registered
[    0.620900] bus: 'i2c': add driver max8997
[    0.621650] i2c-core: driver [max8997] registered
[    0.622500] bus: 'i2c': add driver tps6586x
[    0.623275] i2c-core: driver [tps6586x] registered
[    0.624044] bus: 'i2c': add driver aat2870
[    0.624787] i2c-core: driver [aat2870] using legacy suspend method
[    0.625882] i2c-core: driver [aat2870] using legacy resume method
[    0.626967] i2c-core: driver [aat2870] registered
[    0.628048] device class 'udc': registering
[    0.628846] bus: 'serio': registered
[    0.629516] bus: 'gameport': registered
[    0.630217] device class 'input': registering
[    0.631007] bus: 'platform': add driver i2c-gpio
[    0.632050] device class 'power_supply': registering
[    0.632953] device class 'hwmon': registering
[    0.633749] device class 'leds': registering
[    0.634537] device class 'devfreq': registering
[    0.635368] PCI: Using ACPI for IRQ routing
[    0.636049] PCI: pci_cache_line_size set to 64 bytes
[    0.636997] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    0.638460] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    0.640045] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    0.641494] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    0.642828] pci 0000:00:01.1: BAR 4: reserving [io  0xc040-0xc04f flags 0x40101] (d=0, p=0)
[    0.644078] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    0.645680] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf0000-0xfebf0fff flags 0x40200] (d=0, p=0)
[    0.647293] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbffff flags 0x40200] (d=0, p=0)
[    0.648045] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags 0x40101] (d=0, p=0)
[    0.649549] pci 0000:00:04.0: BAR 0: reserving [mem 0xfebf1000-0xfebf100f flags 0x40200] (d=0, p=0)
[    0.652166] reserve RAM buffer: 000000000009f400 - 000000000009ffff 
[    0.653270] reserve RAM buffer: 000000000fffe000 - 000000000fffffff 
[    0.654457] device class 'net': registering
[    0.655343] device: 'lo': device_add
[    0.656055] PM: Adding info for No Bus:lo
[    0.672320] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.676491] Switching to clocksource hpet
[    0.677618] Warning: could not register annotated branches stats
[    0.684848] bus: 'pnp': add driver system
[    0.685605] pnp: PnP ACPI init
[    0.686172] device: 'pnp0': device_add
[    0.686864] PM: Adding info for No Bus:pnp0
[    0.687660] ACPI: bus type pnp registered
[    0.688443] pnp 00:00: [bus 00-ff]
[    0.689066] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.689806] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.690647] pnp 00:00: [io  0x0d00-0xffff window]
[    0.691538] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.692506] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.693475] device: '00:00': device_add
[    0.694206] bus: 'pnp': add device 00:00
[    0.694922] PM: Adding info for pnp:00:00
[    0.695697] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.696889] pnp 00:01: [io  0x0070-0x0071]
[    0.697663] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.699126] pnp 00:01: [irq 8]
[    0.699701] pnp 00:01: [io  0x0072-0x0077]
[    0.700435] device: '00:01': device_add
[    0.701143] bus: 'pnp': add device 00:01
[    0.701855] PM: Adding info for pnp:00:01
[    0.702586] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.703866] pnp 00:02: [io  0x0060]
[    0.704512] pnp 00:02: [io  0x0064]
[    0.705149] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.706570] pnp 00:02: [irq 1]
[    0.707171] device: '00:02': device_add
[    0.707877] bus: 'pnp': add device 00:02
[    0.708586] PM: Adding info for pnp:00:02
[    0.709313] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.710516] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.712007] pnp 00:03: [irq 12]
[    0.712591] device: '00:03': device_add
[    0.713291] bus: 'pnp': add device 00:03
[    0.714000] PM: Adding info for pnp:00:03
[    0.714743] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.715974] pnp 00:04: [io  0x03f2-0x03f5]
[    0.716724] pnp 00:04: [io  0x03f7]
[    0.717357] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.718789] pnp 00:04: [irq 6]
[    0.719371] pnp 00:04: [dma 2]
[    0.719940] device: '00:04': device_add
[    0.720647] bus: 'pnp': add device 00:04
[    0.721352] PM: Adding info for pnp:00:04
[    0.722087] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.723355] pnp 00:05: [io  0x0378-0x037f]
[    0.724107] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.725522] pnp 00:05: [irq 7]
[    0.726077] device: '00:05': device_add
[    0.726795] bus: 'pnp': add device 00:05
[    0.727536] PM: Adding info for pnp:00:05
[    0.728267] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.729501] pnp 00:06: [io  0x03f8-0x03ff]
[    0.730247] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.731708] pnp 00:06: [irq 4]
[    0.732268] device: '00:06': device_add
[    0.732978] bus: 'pnp': add device 00:06
[    0.733689] PM: Adding info for pnp:00:06
[    0.734412] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.735849] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.736715] device: '00:07': device_add
[    0.737448] bus: 'pnp': add device 00:07
[    0.738150] PM: Adding info for pnp:00:07
[    0.738884] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.740293] pnp: PnP ACPI: found 8 devices
[    0.741038] ACPI: ACPI bus type pnp unregistered
[    0.741867] bus: 'pci': add driver pciback
[    0.742622] bus: 'pci': driver_probe_device: matched device 0000:00:00.0 with driver pciback
[    0.744122] bus: 'pci': really_probe: probing driver pciback with device 0000:00:00.0
[    0.745530] pciback: probe of 0000:00:00.0 rejects match -19
[    0.746541] bus: 'pci': driver_probe_device: matched device 0000:00:01.0 with driver pciback
[    0.748051] bus: 'pci': really_probe: probing driver pciback with device 0000:00:01.0
[    0.749433] pciback: probe of 0000:00:01.0 rejects match -19
[    0.750439] bus: 'pci': driver_probe_device: matched device 0000:00:01.1 with driver pciback
[    0.751945] bus: 'pci': really_probe: probing driver pciback with device 0000:00:01.1
[    0.753328] pciback: probe of 0000:00:01.1 rejects match -19
[    0.754333] bus: 'pci': driver_probe_device: matched device 0000:00:01.3 with driver pciback
[    0.755854] bus: 'pci': really_probe: probing driver pciback with device 0000:00:01.3
[    0.757229] pciback: probe of 0000:00:01.3 rejects match -19
[    0.758227] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver pciback
[    0.759740] bus: 'pci': really_probe: probing driver pciback with device 0000:00:02.0
[    0.761120] pciback: probe of 0000:00:02.0 rejects match -19
[    0.762121] bus: 'pci': driver_probe_device: matched device 0000:00:03.0 with driver pciback
[    0.763647] bus: 'pci': really_probe: probing driver pciback with device 0000:00:03.0
[    0.765030] pciback: probe of 0000:00:03.0 rejects match -19
[    0.766037] bus: 'pci': driver_probe_device: matched device 0000:00:04.0 with driver pciback
[    0.767548] bus: 'pci': really_probe: probing driver pciback with device 0000:00:04.0
[    0.768930] pciback: probe of 0000:00:04.0 rejects match -19
[    0.769971] device class 'mem': registering
[    0.770757] device: 'mem': device_add
[    0.771546] PM: Adding info for No Bus:mem
[    0.772314] device: 'kmem': device_add
[    0.773018] PM: Adding info for No Bus:kmem
[    0.773790] device: 'null': device_add
[    0.774490] PM: Adding info for No Bus:null
[    0.775289] device: 'port': device_add
[    0.775994] PM: Adding info for No Bus:port
[    0.776764] device: 'zero': device_add
[    0.777460] PM: Adding info for No Bus:zero
[    0.778221] device: 'full': device_add
[    0.778923] PM: Adding info for No Bus:full
[    0.779737] device: 'random': device_add
[    0.780475] PM: Adding info for No Bus:random
[    0.781271] device: 'urandom': device_add
[    0.782016] PM: Adding info for No Bus:urandom
[    0.782838] device: 'kmsg': device_add
[    0.783570] PM: Adding info for No Bus:kmsg
[    0.784338] device: 'oldmem': device_add
[    0.785068] PM: Adding info for No Bus:oldmem
[    0.785867] device: 'tty': device_add
[    0.786559] PM: Adding info for No Bus:tty
[    0.787345] device: 'console': device_add
[    0.788097] PM: Adding info for No Bus:console
[    0.788912] device class 'firmware': registering
[    0.789753] device class 'thermal': registering
[    0.795257] PCI: max bus depth: 0 pci_try_num: 1
[    0.796100] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.797099] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    0.798272] NET: Registered protocol family 1
[    0.799103] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x16f
[    0.800247] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.801358] pci 0000:00:00.0: calling quirk_natoma+0x0/0x2b
[    0.802350] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.803435] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x90
[    0.804587] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.805626] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x5bd
[    0.806806] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xac
[    0.807910] pci 0000:00:01.0: calling quirk_e100_interrupt+0x0/0x16f
[    0.809046] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.810158] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x2e
[    0.811277] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.812354] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x5bd
[    0.813531] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xac
[    0.814587] pci 0000:00:01.1: calling quirk_e100_interrupt+0x0/0x16f
[    0.815747] pci 0000:00:01.1: calling quirk_cardbus_legacy+0x0/0x30
[    0.816868] pci 0000:00:01.1: calling quirk_usb_early_handoff+0x0/0x5bd
[    0.818039] pci 0000:00:01.1: calling pci_fixup_video+0x0/0xac
[    0.819119] pci 0000:00:01.3: calling quirk_e100_interrupt+0x0/0x16f
[    0.820252] pci 0000:00:01.3: calling quirk_cardbus_legacy+0x0/0x30
[    0.821355] pci 0000:00:01.3: calling quirk_usb_early_handoff+0x0/0x5bd
[    0.822525] pci 0000:00:01.3: calling pci_fixup_video+0x0/0xac
[    0.823610] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.824724] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x5bd
[    0.825891] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xac
[    0.826947] pci 0000:00:02.0: Boot video device
[    0.827805] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x16f
[    0.828933] pci 0000:00:03.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.830045] pci 0000:00:03.0: calling quirk_usb_early_handoff+0x0/0x5bd
[    0.831253] pci 0000:00:03.0: calling pci_fixup_video+0x0/0xac
[    0.832308] pci 0000:00:04.0: calling quirk_e100_interrupt+0x0/0x16f
[    0.833436] pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.834549] pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0x5bd
[    0.835762] pci 0000:00:04.0: calling pci_fixup_video+0x0/0xac
[    0.836823] PCI: CLS 0 bytes, default 64
[    0.837678] Unpacking initramfs...
[    1.752572] Freeing initrd memory: 23656k freed
[    1.762360] DMA-API: preallocated 32768 debug entries
[    1.763349] DMA-API: debugging enabled by kernel config
[    1.764418] bus: 'machinecheck': registered
[    1.765184] device: 'machinecheck': device_add
[    1.765987] PM: Adding info for No Bus:machinecheck
[    1.766872] device: 'machinecheck0': device_add
[    1.767723] bus: 'machinecheck': add device machinecheck0
[    1.768689] PM: Adding info for machinecheck:machinecheck0
[    1.769679] device: 'machinecheck1': device_add
[    1.770493] bus: 'machinecheck': add device machinecheck1
[    1.771487] PM: Adding info for machinecheck:machinecheck1
[    1.772488] device: 'mcelog': device_add
[    1.773229] PM: Adding info for No Bus:mcelog
[    1.774047] Machine check injector initialized
[    1.774892] Registering platform device 'pcspkr'. Parent at platform
[    1.776057] device: 'pcspkr': device_add
[    1.776771] bus: 'platform': add device pcspkr
[    1.777568] PM: Adding info for platform:pcspkr
[    1.778388] microcode: no support for this CPU vendor
[    1.779628] cryptomgr_test used greatest stack depth: 6448 bytes left
[    1.783214] cryptomgr_test used greatest stack depth: 6168 bytes left
[    1.786024] cryptomgr_test used greatest stack depth: 5680 bytes left
[    1.787863] bus: 'platform': add driver alarmtimer
[    1.788749] Registering platform device 'alarmtimer'. Parent at platform
[    1.789947] device: 'alarmtimer': device_add
[    1.790730] bus: 'platform': add device alarmtimer
[    1.791628] PM: Adding info for platform:alarmtimer
[    1.792514] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    1.794089] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    1.795611] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    1.796870] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    1.798342] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0
[    1.804244] bus: 'event_source': registered
[    1.805022] device: 'breakpoint': device_add
[    1.805793] bus: 'event_source': add device breakpoint
[    1.806712] PM: Adding info for event_source:breakpoint
[    1.807712] device: 'tracepoint': device_add
[    1.808492] bus: 'event_source': add device tracepoint
[    1.809406] PM: Adding info for event_source:tracepoint
[    1.810355] device: 'software': device_add
[    1.811133] bus: 'event_source': add device software
[    1.812113] PM: Adding info for event_source:software
[    1.813709] VFS: Disk quotas dquot_6.5.2
[    1.814549] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.903037] alg: No test for cipher_null (cipher_null-generic)
[    1.967035] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    2.031035] alg: No test for digest_null (digest_null-generic)
[    2.095034] alg: No test for compress_null (compress_null-generic)
[    2.763064] Refined TSC clocksource calibration: 3092.966 MHz.
[    2.764124] Switching to clocksource tsc
[    3.630999] alg: No test for stdrng (krng)
[    3.695152] bus: 'platform': add driver basic-mmio-gpio
[    3.696121] bus: 'platform': add driver adp5520-gpio
[    3.697041] bus: 'i2c': add driver adp5588-gpio
[    3.697873] i2c-core: driver [adp5588-gpio] registered
[    3.698800] bus: 'pci': add driver bt8xxgpio
[    3.699721] bus: 'pci': add driver pch_gpio
[    3.700500] bus: 'spi': add driver lms283gf05
[    3.701293] bus: 'platform': add driver platform-lcd
[    3.702197] bus: 'spi': add driver VGG2432A4
[    3.703015] bus: 'spi': add driver ld9040
[    3.703765] bus: 'platform': add driver max8925-backlight
[    3.704735] bus: 'platform': add driver adp5520-backlight
[    3.705718] bus: 'pci': add driver pm2fb
[    3.706445] bus: 'pci': add driver matroxfb
[    3.707244] rivafb_setup START
[    3.707811] bus: 'pci': add driver rivafb
[    3.708558] bus: 'pci': add driver nvidiafb
[    3.709326] bus: 'pci': add driver aty128fb
[    3.710096] bus: 'pci': add driver radeonfb
[    3.710878] bus: 'pci': add driver sisfb
[    3.711633] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.712841] bus: 'platform': add driver viafb-i2c
[    3.713696] bus: 'platform': add driver viafb-gpio
[    3.714565] bus: 'pci': add driver viafb
[    3.715299] bus: 'pci': add driver kyrofb
[    3.716042] bus: 'pci': add driver tdfxfb
[    3.716785] bus: 'pci': add driver vt8623fb
[    3.717562] vmlfb: initializing
[    3.718135] bus: 'pci': add driver vmlfb
[    3.718863] bus: 'pci': add driver s3fb
[    3.719588] bus: 'platform': add driver hecubafb
[    3.720432] no IO addresses supplied
[    3.721084] bus: 'pci': add driver sstfb
[    3.721818] bus: 'pci': add driver cirrusfb
[    3.722583] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver cirrusfb
[    3.724097] bus: 'pci': really_probe: probing driver cirrusfb with device 0000:00:02.0
[    3.726556] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM (4096 kB) at 0xfc000000
[    3.728148] device: 'fb0': device_add
[    3.728848] PM: Adding info for No Bus:fb0
[    3.729639] driver: '0000:00:02.0': driver_bound: bound to device 'cirrusfb'
[    3.730893] bus: 'pci': really_probe: bound device 0000:00:02.0 to driver cirrusfb
[    3.732253] bus: 'pci': add driver asiliantfb
[    3.733060] bus: 'platform': add driver tmio-fb
[    3.733886] bus: 'platform': add driver metronomefb
[    3.734767] bus: 'platform': add driver s1d13xxxfb
[    3.735656] bus: 'pci': add driver carminefb
[    3.736443] Registering platform device 'vesafb.0'. Parent at platform
[    3.737598] device: 'vesafb.0': device_add
[    3.738329] bus: 'platform': add device vesafb.0
[    3.739176] PM: Adding info for platform:vesafb.0
[    3.740037] bus: 'platform': add driver vesafb
[    3.740835] bus: 'platform': driver_probe_device: matched device vesafb.0 with driver vesafb
[    3.742309] bus: 'platform': really_probe: probing driver vesafb with device vesafb.0
[    3.743744] vesafb: probe of vesafb.0 rejects match -19
[    3.744691] bus: 'platform': remove driver vesafb
[    3.745535] driver: 'vesafb': driver_release
[    3.746295] PM: Removing info for platform:vesafb.0
[    3.747201] bus: 'platform': remove device vesafb.0
[    3.748093] bus: 'acpi': add driver ac
[    3.748812] bus: 'acpi': add driver button
[    3.749582] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    3.751074] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    3.752458] device: 'input0': device_add
[    3.753175] PM: Adding info for No Bus:input0
[    3.754002] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.755342] ACPI: Power Button [PWRF]
[    3.756047] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    3.757244] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    3.758567] bus: 'acpi': add driver fan
[    3.759292] bus: 'acpi': add driver processor
[    3.760095] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[    3.761592] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[    3.763202] device: 'cooling_device0': device_add
[    3.764068] PM: Adding info for No Bus:cooling_device0
[    3.765015] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[    3.766239] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[    3.767622] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[    3.769111] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[    3.770584] device: 'cooling_device1': device_add
[    3.771456] PM: Adding info for No Bus:cooling_device1
[    3.772381] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[    3.773595] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[    3.774948] bus: 'acpi': add driver container
[    3.777487] bus: 'acpi': add driver thermal
[    3.778314] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.779375] bus: 'pci': add driver ioatdma
[    3.780126] bus: 'platform': add driver timb-dma
[    3.780960] bus: 'pci': add driver pch-dma
[    3.781713] bus: 'i2c': add driver LP3971
[    3.782445] i2c-core: driver [LP3971] registered
[    3.783300] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.784265] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.785413] Registering platform device 'serial8250'. Parent at platform
[    3.786612] device: 'serial8250': device_add
[    3.787394] bus: 'platform': add device serial8250
[    3.788257] PM: Adding info for platform:serial8250
[    3.811691] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.812778] device: 'ttyS0': device_add
[    3.813558] bus: 'acpi': add driver battery
[    3.813574] PM: Adding info for No Bus:ttyS0

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="59a5680-bisect.log"
Content-Transfer-Encoding: quoted-printable

bisect: skip d1c3ed669a2d452cacfb48c2d171a1f364dae2ed: not a good merge base
git checkout v3.2

2013-01-11-10:39:28 805a6af8dba5dfdd35ec35dc52ec0122400b2610 compiling
/home/wfg/linux

2013-01-11-10:40:57 detecting boot state 3.2.0-bisect #2 .1.23...4.56......=
=2E.......7...............................................OK .OK ..8OK 9OK =
=2EOK .10OK 111213OK .OK ..14OK .15OK .OK ..1617.......OK ..18.............=
=2E......................................OK 19OK 20...OK .OK 21OK .OK 22.OK=
 .23.OK .24...OK .25....OK 26..............................................=
=2E.OK .OK .OK .2728.OK ..OK 29..OK 30OK ..OK 31.3233.OK .34....OK .35.....=
=2E...............................................OK .OK 3637..OK .38.OK ..=
OK .394041.OK .42.OK ..43OK .44.45..OK .46.................................=
=2E..............47.48.49OK .OK 50.51.OK 52.535455OK .OK .OK 565758OK .59..=
OK ..OK 6061OK .62..OK .63...........................................OK .64=
OK .65OK .66OK .67.OK ..68OK .OK .OK .6970OK 71OK .OK 72..OK .73OK ..OK 74.=
75.OK 7677...............................................OK .78OK .79OK ..O=
K 80.81OK 82.83..OK .OK ..84OK 8586OK ..OK 87.88OK 89OK .90OK 91OK .OK 9293=
9495OK .96..........................................OK .97OK .98....OK .99O=
K .OK 100101.OK .102.OK .OK .103OK .104.105OK .OK .OK 106OK 107108109OK .OK=
 110.OK 111OK  SUCCESS
bisect: good commit v3.2
git bisect start 59a56802918100c1e39e68c30a2e5ae9f7d837f0 v3.2 --
Bisecting: 3108 revisions left to test after this (roughly 12 steps)
[972b2c719990f91eb3b2310d44ef8a2d38955a14] Merge branch 'for-linus2' of git=
://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-10:55:10 972b2c719990f91eb3b2310d44ef8a2d38955a14 compiling
2013-01-11-10:55:56 972b2c719990f91eb3b2310d44ef8a2d38955a14 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 3108 revisions left to test after this (roughly 12 steps)
[3d6acefc0a24bf90746c1f259e9d65d1ed7ea5e2] iwlwifi: move ucode_type from iw=
l_priv to iwl_shared
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-10:56:15 3d6acefc0a24bf90746c1f259e9d65d1ed7ea5e2 compiling
/home/wfg/linux

2013-01-11-10:57:48 detecting boot state 3.2.0-rc2-bisect-00698-g3d6acef #1=
 1..2345.6...7.8................................9..10...11.......12..1314.O=
K .15....OK .16OK .OK .17.OK .18..OK .OK 19OK .OK .20.21OK 2223OK .24OK .25=
=2E..........................OK 26..OK .27..OK .28.....OK .OK 2930..OK .31.=
OK 32....OK .33OK .34OK 35...OK .36.OK .37.OK .38OK .OK 39OK 4041OK .42OK .=
43......................OK .44..OK .45..OK .46.....OK .OK .4748.OK ..OK 49.=
50...OK .51OK .OK .52.53.OK ..54....OK .55.OK .56OK .OK .OK ...OK 5758OK 59=
6061....................OK .62..OK .63..OK .64.....OK .65OK .66..OK .OK 67.=
68......OK .OK 69OK .7071......OK .72......OK .73...OK .74OK .OK ..OK 75767=
7...............OK .78.OK .79...OK .80.....OK .OK 81.82..OK .83OK .84....OK=
 .OK .85OK .86OK .87......OK .88.....OK .89....OK .90OK .91OK 92OK 9394....=
=2E...........OK .95.OK .96...OK .97...OK ..OK 9899OK ..OK .100.....OK .OK =
101.OK 102OK ..103....OK .104......OK .105....OK .106...OK .107OK .OK .OK 1=
08OK  SUCCESS
Bisecting: 2805 revisions left to test after this (roughly 12 steps)
[48fa57ac2c30a8a0b770b7ad50b4b30c1d12f005] Merge tag 'infiniband-for-linus'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-11:08:13 48fa57ac2c30a8a0b770b7ad50b4b30c1d12f005 compiling
2013-01-11-11:08:57 48fa57ac2c30a8a0b770b7ad50b4b30c1d12f005 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 2805 revisions left to test after this (roughly 12 steps)
[63ec3c83e7ba6f23227d3ff69c5792911266bd75] niu: Remove redundant PHY ID tes=
t.
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-11:09:09 63ec3c83e7ba6f23227d3ff69c5792911266bd75 compiling
/home/wfg/linux

2013-01-11-11:10:41 detecting boot state 3.2.0-rc2-bisect-01144-g63ec3c8 #1=
 OK .1.OK .OK .23..OK .4......OK .5....OK .6......OK .7OK 8..OK .910.......=
=2E...OK .11...OK 12...OK 13.....OK .OK 1415.OK .16OK .17..OK .18OK ..19.OK=
 .OK .OK 20.2122....OK ..23.......OK ..24OK .25...OK .OK 26OK ...2728......=
=2E.OK .29......OK ..30.OK .31....OK ..OK 32.33.OK .OK 34.35.OK ..36OK .OK =
37.38..OK .OK .3940...OK ..41........OK .42OK ..43......OK .OK 4445.OK .46.=
=2E...OK .47.......OK .48.OK .49.....OK .50OK 51.......OK .OK 52.OK 5354...=
=2EOK .OK .OK 55.56..OK ..57.......OK .58..OK .59..OK .60..OK .OK .61OK 626=
3...........OK .64.....OK .65.OK 66....OK .67......OK .68OK .69OK .70.....O=
K .OK 71OK .72...OK .73.......OK .74..OK .75..OK .76OK .7778OK ..OK 798081.=
OK ..82........OK .83.....OK .OK 84.85........OK .OK 86OK ...87.OK .88....O=
K ..OK 89.90..OK .91.......OK ..92.OK .93..OK ..94OK ..95OK .OK 96OK .9798.=
OK .99........OK  SUCCESS
Bisecting: 2689 revisions left to test after this (roughly 11 steps)
[5983faf942f260023e547f3c5f38c1033c35cc9b] Merge branch 'tty-next' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-11:20:05 5983faf942f260023e547f3c5f38c1033c35cc9b compiling
2013-01-11-11:20:49 5983faf942f260023e547f3c5f38c1033c35cc9b SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 2689 revisions left to test after this (roughly 11 steps)
[71d8f162ac50679ce45b537c18adbf83113de36b] arm/tegra: Remove useless entrie=
s from ventana_pinmux[]
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-11:21:00 71d8f162ac50679ce45b537c18adbf83113de36b compiling
/home/wfg/linux

2013-01-11-11:22:32 detecting boot state 3.2.0-rc4-bisect-00007-g71d8f16 #1=
 OK ....OK .1..OK .2...OK .3..OK .OK 45.OK .67.OK .8....OK .9....OK .10....=
OK .11....OK 12...OK .OK 13OK ..14.......OK ..OK 1516...OK .17........OK ..=
18..OK .19..OK .20...OK ..2122OK ..23OK 24.25...OK ..26...OK ..27...OK ..28=
=2E.OK .29....OK 30.OK .31..OK .32.....OK .33OK .34OK .35.........OK .36...=
OK 37...OK 38.OK .39.OK .40OK 41...OK .OK 4243OK .44...OK .45...OK .46.....=
OK .47..OK .48..OK .OK 4950.OK .51..OK .52.OK 53.OK ..54OK .55........OK .5=
6..OK .57..OK .58.....OK 59..OK .OK 6061...OK .62OK .OK 63OK 6465.......OK =
=2E.66OK .67......OK .68..OK .69OK .70OK .71..OK .72OK .73..OK .74OK .75...=
=2EOK .76......OK .77OK .78OK .79........OK .80OK .81.OK .OK 8283OK .84OK .=
=2E85......OK ..86OK .87......OK .88..OK ..OK 89.OK 9091..OK .92.OK 93..OK =
=2E.OK 9495........OK .96....OK .97OK .98.......OK .99OK .100..OK  SUCCESS
Bisecting: 2682 revisions left to test after this (roughly 11 steps)
[a1910f9cad2b4b9cc0d5d326aa65632a23c16088] mac80211_hwsim: fix wmediumd_pid
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-11:31:16 a1910f9cad2b4b9cc0d5d326aa65632a23c16088 compiling
/home/wfg/linux

2013-01-11-11:32:44 detecting boot state 3.2.0-rc2-bisect-01068-ga1910f9 #2=
 1.23.................4.5.............67.8910......11..12....13...14.15.OK =
=2E16......OK .OK 17.18.OK .OK 19.OK .2021...............OK .OK 2223.......=
=2E....OK .OK .OK .OK 2425OK .OK .2627...OK ..28OK .29...OK .30..OK .31.OK =
=2E32OK ..33......OK .OK 3435.....OK .3637OK ..38........OK .39OK .40......=
=2E.........OK .OK 41..OK 4243.OK 44......OK .45..OK ..46.OK .47....OK .OK =
4849.OK .50...OK ..51...OK .OK ..52OK 5354.....OK 55OK .56................O=
K .OK 5758.OK .59..OK .OK 60.OK 6162......OK 63...OK ..64.OK .65OK .66...OK=
 .67.OK .68....OK .69......OK .OK .707172..OK ..OK 73.74...............OK .=
OK ..7576....OK .OK 77OK .7879....OK ..80..OK ..81OK .82.OK .83...OK .84.OK=
 .OK .85.86..........OK .OK ..8788OK .OK 8990................OK .91..OK .92=
=2EOK 93.....OK 94OK 9596....OK .97...OK .98.OK 99..OK .100......OK .OK 101=
OK .102.............OK .OK .103OK 104OK 105106.107..........OK ..108.OK ..O=
K 109.110...OK .OK 111OK .112....OK .113...OK .114.OK  SUCCESS
Bisecting: 2438 revisions left to test after this (roughly 11 steps)
[55b81e6f2795484ea8edf5805c95c007cacfa736] Merge branch 'usb-next' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-11:43:47 55b81e6f2795484ea8edf5805c95c007cacfa736 compiling
2013-01-11-11:44:32 55b81e6f2795484ea8edf5805c95c007cacfa736 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 2438 revisions left to test after this (roughly 11 steps)
[2d31597d37ec8842b9575005190fde2898764628] lttng: offset alignment header
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-11:44:44 2d31597d37ec8842b9575005190fde2898764628 compiling
/home/wfg/linux

2013-01-11-11:46:14 detecting boot state 3.2.0-rc3-bisect-00185-g2d31597 #1=
 .........1.23..4...5.6....78..910......11............1213.................=
OK 14OK .15OK .16OK .17.........OK .OK ..OK 181920OK .21..OK .OK 22.OK 23OK=
 .2425OK .OK .2627....OK .28...........OK ..OK 2930....................OK .=
OK 3132.OK .OK 33OK .3435.........OK ..OK 363738....OK .OK 3940.OK .41.OK .=
=2EOK 42.OK 4344................OK .OK .454647..................OK .OK .48O=
K ..49OK ..50........OK .51OK .52...OK .53OK .OK .5455....OK ..OK 56OK ..57=
5859..........OK .60...OK .6162...................OK 6364OK 65OK 6667.OK .6=
8........OK .69OK .70...OK .71.OK .OK .OK 7273OK .OK 7475.....OK .OK .7677.=
=2E...OK ..78...OK ..7980.................OK .81OK 82OK ..8384OK .85.......=
=2E....OK .86OK .OK .8788OK .89...OK .OK 9091OK .OK .92......OK .OK 93.94..=
=2E.OK ..95....OK ..96................OK ..OK 9798OK .OK ..99OK 100.101....=
=2E.....OK ..102OK .OK .103.OK .104...OK ..105OK 106OK .107108.....OK .OK 1=
09..110...OK .111.OK .112..OK .113.................OK .OK 114115.OK .OK 116=
117OK  SUCCESS
Bisecting: 2497 revisions left to test after this (roughly 11 steps)
[c9667bff9d191db5775d383d9b5efecc26eccae1] staging/mei: remove outdated com=
ment about setting iamthif_mtu
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-11:57:41 c9667bff9d191db5775d383d9b5efecc26eccae1 compiling
/home/wfg/linux

2013-01-11-11:59:19 detecting boot state 3.2.0-rc5-bisect-00393-gc9667bf #2=
 ......1...2.3.4.5..6..7.........8...910..11...12...13...........14.....OK =
=2E15.OK .OK .16OK 1718.19.......OK .20..OK .OK .21OK .OK 2223.....OK 24OK =
=2EOK .2526......OK ..27..OK .2829.....OK .30..OK .31.OK .32.............OK=
 .33..OK .34OK .OK .OK 353637......OK ..38..OK .OK .OK 3940OK 4142...OK .43=
=2EOK 44OK 45.......OK .46...OK 47OK 4849.....OK .50.OK .51......OK 52.....=
=2E....OK .53....OK .54OK ..5556.OK .57......OK .OK 58OK 59.60OK 61.62OK .O=
K 63.64......OK .65..OK .OK .OK ..6667...OK .68.OK ..69........OK .70......=
=2E...OK ..71...OK .72.OK ..73.OK .74......OK .75OK .OK 76.77OK .78OK .OK 7=
9OK 8081......OK ..82...OK .OK .OK 838485.OK .OK ..86...........OK .87.....=
=2E.....OK ..8889.OK ..90.OK ..91OK .92.....OK .OK .93OK .9495...OK .OK 96O=
K .979899.....OK .100.....OK 101OK 102..OK .103OK .104105..........OK 106..=
=2E..........OK .107...OK .108109OK .110.OK 111.......OK .OK 112113OK .114.=
=2EOK .115.OK .OK .116117OK .118..OK ..119....OK  SUCCESS
Bisecting: 2289 revisions left to test after this (roughly 11 steps)
[2fd149645eb46d26130d7070c6de037dddf34880] ARM: OMAP2+: UART: Remove omap_u=
art_can_sleep and add pm_qos
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-12:09:56 2fd149645eb46d26130d7070c6de037dddf34880 compiling
/home/wfg/linux

2013-01-11-12:11:28 detecting boot state 3.2.0-rc4-bisect-00108-g2fd1496 #3=
 ..12...3.........4..............5...6..7.....8....9....10..1112.......13OK=
 .OK ..141516..OK ..17OK .OK 1819..OK .OK .20.......OK .21..............OK =
22..OK 23..OK .24....OK .25...OK 26.....OK .27OK .OK 2829......OK .30..OK .=
31OK .OK 3233....OK .34OK .35...OK ..36................OK .37..OK .38.OK ..=
39...OK .40...OK .41....OK .42OK .OK 4344.OK ..45....OK ..46...OK .OK ..OK =
47..48...OK .OK 49.50...OK .OK ..5152..............OK .53.OK .5455.OK ..56.=
=2E.OK .57...OK .58...OK .59.OK .60..OK .61....OK .62.....OK .OK 63.64OK ..=
65..OK .66OK .67.....OK .OK .6869OK ..70..........OK .71.OK .OK .7273.OK .7=
4...OK .75...OK .76...OK .77.OK .78..OK .79....OK .80.....OK .81OK 82.OK .O=
K 8384....OK .85......OK .86.OK .87..........OK .OK .8889..OK .90.OK .91...=
OK .92...OK ..93.OK .OK 9495.OK .9697...OK ..98...OK .99...OK .OK .100101OK=
 .102.....OK .103.OK ..104.OK .OK .105106.............OK .OK 107.108OK .OK =
=2E109110.....OK .111....OK .112.OK .OK  SUCCESS
Bisecting: 2263 revisions left to test after this (roughly 11 steps)
[2b246283277862c4866a005852af5c70fd581824] spi-topcliff-pch: Change company=
 name OKI SEMICONDUCTOR to LAPIS Semiconductor
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-12:22:32 2b246283277862c4866a005852af5c70fd581824 compiling
/home/wfg/linux

2013-01-11-12:24:06 detecting boot state 3.1.0-bisect-00017-g2b24628 #4 1..=
=2E.2...........34......5....6..7.8..............910...11......12....OK .13=
=2EOK .14OK .15..OK .OK 16.17..OK ..18.....OK ..OK 1920.OK .21.OK ..22..OK =
=2E23.OK .24OK .25..........OK .26.OK ..27.OK .OK .2829........OK ..30...OK=
 .31.OK .OK 32.33..OK ..OK 34.35..OK ..36.....OK .OK 37.38OK ..39.OK .40..O=
K .41.OK .42.OK 43...........OK .44.OK .45...OK ..46........OK .47..OK .48O=
K .49..OK ..50OK .51OK .OK ..52....OK ..53.OK .54.OK .55...OK ..56OK .57..O=
K 58OK .59OK .60.............OK 61..OK .OK 6263..OK .64.OK 65...........OK =
=2E66OK .67..OK .68.OK 69..OK .OK 7071....OK .7273.OK 74.OK .75....OK .76OK=
 ..77.OK .OK 78.OK 7980.........OK ..81OK ..OK 82.83.....OK .84OK .85......=
OK ..86...OK .87..OK .88.OK ...89OK .90.....OK ..91OK 92.93OK ..94...OK ..O=
K 95.96.OK .OK 97.OK 9899.........OK .100..OK .OK 101.102......OK .103OK .1=
04.....OK .105...OK .106..OK .OK 107108......OK .109.OK .110......OK ..OK 1=
11.112.OK  SUCCESS
Bisecting: 2263 revisions left to test after this (roughly 11 steps)
[a8a363ac3b0cc947c5153d5b2e46c07bb496958b] brcm80211: fmac: move common lay=
er bus interface context to dhd_bus.h
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-12:34:26 a8a363ac3b0cc947c5153d5b2e46c07bb496958b compiling
/home/wfg/linux

2013-01-11-12:36:13 detecting boot state 3.2.0-rc2-bisect-01230-ga8a363a #5=
 ........1...2.3......4..5......6.....7..8....9.....10.....11.1213....OK 14=
=2EOK 15.16OK .OK ..OK 17.18.....OK ..19.OK .OK .20.21........OK .22OK ..23=
=2E....OK .24....OK .25.OK .26.......OK .27OK .28.....OK .OK 29OK 3031....O=
K 32OK .33OK .34..OK .35..OK .OK 3637..OK ..38..OK .OK 3940.........OK ..41=
OK .42.OK .43....OK .44..OK .45.OK ..46....OK .47OK .48...OK 49....OK .OK 5=
0.51OK .52OK .53..OK .54..OK ..OK 5556......OK .57..OK .58OK .59.........OK=
 .OK 60OK 6162.......OK ..63.....OK .64....OK .65OK .66..OK ..67.OK 68.OK .=
=2E69.OK .70OK .71..OK .72....OK .OK .7374....OK ..OK 75.OK 76.77..........=
OK .OK 78.OK 7980.......OK ..81...OK ..82....OK .83OK .84...OK .85OK .86OK =
=2EOK .8788...OK .89.....OK .90..OK .OK 9192.OK .93..OK .94OK .95OK .96....=
=2E.....OK .97OK .98...OK .99....OK ..100..OK .OK 101102....OK .103OK .104.=
=2E.OK 105.OK ..106OK .OK 107108...OK .109.OK ..110..OK .111.OK .112....OK =
 SUCCESS
Bisecting: 2263 revisions left to test after this (roughly 11 steps)
[ae2eca724af2802739efe02b3fc56daa8b674eb9] m68k: add cache support for V4e =
ColdFire cores running with MMU enabled
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-12:46:09 ae2eca724af2802739efe02b3fc56daa8b674eb9 compiling
/home/wfg/linux

2013-01-11-12:47:35 detecting boot state 3.2.0-rc7-bisect-00034-gae2eca7 #6=
 12....3..4...5.......6.7............8.9..........1011.........121314...OK =
=2EOK .1516......OK .OK 17.18...OK .19OK .20..OK .21........OK .OK 2223....=
=2E......OK .24.OK 25.........OK .26OK .27........OK .OK 282930....OK .3132=
=2E.....OK 33OK .OK .34OK 35.36.OK .37........OK .OK 3839...........OK .40.=
OK .41..........OK .42.OK .4344.........OK 45OK 4647.....OK .4849.....OK .5=
0OK .OK .51OK 525354.OK .55.......OK .OK .5657.....OK .58...OK ..59........=
=2E..OK .OK .6061OK ..62........OK .OK .OK 636465OK .66...OK .67....OK ..68=
=2EOK .OK .OK .OK 69.707172........OK .OK ..73....OK .74....OK .75.........=
=2E..OK 76OK 77.OK .78........OK 79.OK 80.OK 81.OK .82OK 83....OK .84......=
=2E..OK .OK 85OK .OK 868788....OK ..8990...OK .91...OK ..92...........OK .O=
K 9394.OK .95...OK .96.......OK .OK 9798...OK 99OK .100....OK .101.........=
OK .102OK .OK 103OK 104105.....OK .OK .106...OK .107...OK .108.........OK .=
109.OK .110.OK .111....OK .112...OK .OK .113114.....OK .115OK .116OK .117..=
=2E.........OK .OK  SUCCESS
Bisecting: 2263 revisions left to test after this (roughly 11 steps)
[5c395ae7033099fc657114ea997858aa622f08b2] Merge branch 'linux-next' of git=
://git.infradead.org/ubifs-2.6
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-12:59:13 5c395ae7033099fc657114ea997858aa622f08b2 compiling
2013-01-11-12:59:55 5c395ae7033099fc657114ea997858aa622f08b2 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 2263 revisions left to test after this (roughly 11 steps)
[5b859b6ebb18b37244d44b5300bf765694b7303c] crypto: talitos - be less noisy =
on startup
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-13:00:03 5b859b6ebb18b37244d44b5300bf765694b7303c compiling
/home/wfg/linux

2013-01-11-13:01:31 detecting boot state 3.2.0-rc1-bisect-00031-g5b859b6 #1=
 .....1.2...3.4...5.6...7.............8.9..10...11...12....1314........15..=
=2E......OK .1617....OK .18OK .19..OK .20OK .21..OK .22OK .23..OK ..24.....=
=2E.....OK .25OK ..26OK .27.OK ..28..OK .29...OK .OK 30.31......OK .32.....=
=2E...OK .33....OK .34OK .35...OK .36OK .37..OK .38OK .39..OK .40..........=
=2E.OK .41.OK .42OK 43..OK .44...OK 45....OK .OK 4647...OK 48..........OK .=
49..OK .50..OK .51OK .52.....OK .53OK .54..OK .55OK ..56...........OK .57OK=
 ..OK 58.59OK ..60..OK .61....OK .OK 6263......OK .64..........OK .65..OK .=
66..OK .67OK .68.....OK ..OK 6970..OK .71.OK ..72.....OK .73...OK .74.OK .7=
5OK .76OK ..77..OK .78.....OK ..79.....OK .80......OK .81......OK .82OK ..O=
K 8384.OK .85.....OK .86...OK ..87.OK .88..OK .89.......OK .90OK .91OK .92.=
=2EOK .93..OK 94.......OK .95OK 96...........OK 97.......OK 9899OK .100...O=
K .101.....OK .OK 102103...OK .104105....OK ..106......OK .107OK .108OK .10=
9110OK .111......OK .OK .112OK 113114.........OK ..115.....OK .OK .116OK 11=
7118...OK  SUCCESS
Bisecting: 2232 revisions left to test after this (roughly 11 steps)
[7c4cab7f401a834bdf3878d417bf77d3290d4cfc] ARM: S5PC100: Modify platform da=
ta for pl330 driver
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-13:13:02 7c4cab7f401a834bdf3878d417bf77d3290d4cfc compiling
/home/wfg/linux

2013-01-11-13:14:27 detecting boot state 3.2.0-rc6-bisect-00022-g7c4cab7 #2=
 .123...........4.5......67...........8..910.11..............1213........OK=
 14.....OK .OK .15..OK .16........OK .17.OK .18.......OK .OK 1920......OK 2=
1..OK .22.OK .23OK ..OK 242526........OK .27..OK ..28...OK .29.....OK ...30=
31OK .32........OK .33OK ..34.......OK .OK 3536.....OK ..37.....OK .38.OK .=
39.OK .40OK ..4142.......OK .4344.OK .45....OK .46.....OK .47OK ..484950...=
=2E....OK .51.OK .52......OK .OK .53......OK ..54...OK .OK 5556....OK .OK 5=
758OK .59.....OK .60.OK ..61.......OK .62.....OK .OK .63OK 64OK .6566......=
=2E.OK .67.OK .68...OK .OK 69.......OK 70........OK .OK 71......OK .72OK .O=
K 7374....OK 7576..OK 77....OK .78.......OK 79...OK .80OK .OK .8182.....OK =
=2E83OK .84..OK ..8586....OK .87........OK ..8889......OK .OK .OK 90.91....=
=2EOK .OK .9293OK ..94...OK ..95......OK .96..OK .97.OK .OK 98OK .99100....=
OK 101......OK ..102...OK .103......OK ..104OK .105.....OK .106..OK .OK 107=
108.......OK .109110OK .111....OK .112......OK .113...OK .114.OK .OK 115OK =
=2E116117...OK  SUCCESS
Bisecting: 2210 revisions left to test after this (roughly 11 steps)
[649fc7b1b046eb98bf9e3fe20c9d11f629293140] should_remove_suid(): inode->i_m=
ode is umode_t
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-13:26:07 649fc7b1b046eb98bf9e3fe20c9d11f629293140 compiling
/home/wfg/linux

2013-01-11-13:27:34 detecting boot state 3.2.0-rc7-bisect-00173-g649fc7b #3=
 1..........2....3.......45......6...78.........9.1011....12......OK ..13..=
=2E...OK .OK 1415OK ..16OK ..17........OK ..18.OK .OK .19.....OK .20OK .21.=
=2E...OK .2223..OK .24.......OK .25.OK .26...OK 27OK .28......OK .29......O=
K .30OK .31.OK ..OK 32.33.........OK .34..OK ..35....OK .36OK ..37.....OK .=
3839.OK .40.......OK ..41OK .42...OK .43OK 44.......OK 45.......OK 46OK .47=
=2EOK 48OK 4950...........OK .51OK .52..OK .53...OK .54.OK ..55.....OK ..56=
OK .57....OK ..OK 5859...OK 60OK .61......OK ..62......OK .OK 6364OK .65...=
OK .OK .6667........OK .68OK .69....OK .70...OK .71..OK 72......OK .OK 73.O=
K 74..OK .75...OK .76....OK 77........OK 78...OK .79...OK 80..OK .81...OK .=
OK 8283....OK .84OK .85....OK .86...OK .87.OK ..88.....OK ..OK .8990OK ..91=
=2E.OK .OK .92...OK .93.......OK ..94......OK 9596..OK .97........OK .98...=
=2EOK 99.OK .100....OK .101...OK .102.OK .103........OK .OK 104.105OK .OK 1=
06OK .107.OK .108.............OK .109.OK .OK .110..OK  SUCCESS
Bisecting: 1966 revisions left to test after this (roughly 11 steps)
[1f2e124df90cfc1347fd301409570fa9b0aed2c9] drm/radeon/kms: add missing ring=
 ready check in sync tests
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-13:38:47 1f2e124df90cfc1347fd301409570fa9b0aed2c9 compiling
/home/wfg/linux

2013-01-11-13:40:13 detecting boot state 3.2.0-rc6-bisect-00344-g1f2e124 #4=
 ...1...2.....3...4....5......6.78.9....................1011.12..13........=
=2E....OK .OK .1415.OK .16..OK .17OK .18..OK .19.......OK .20OK .21.OK .22.=
OK .23OK ..24....................OK .OK 25OK .26..OK .2728.............OK .=
=2E29.OK .30.OK .31.OK .32..OK .33...OK .34...OK .OK 3536OK .37.OK .38.....=
=2E.................OK .OK 39OK ..OK 40.41OK .OK .4243.........OK ...44...O=
K .45.OK .46.OK .47...OK .48..OK .49...OK .50OK .OK 5152.OK .53............=
=2E...........OK 54.OK .55...OK .OK 565758..........OK ..59..OK .60.OK .61.=
OK .62...OK ..63......OK .64OK .OK 6566.OK .67......................OK 68OK=
 69OK .OK 70OK 7172..OK ..OK 7374............OK .7576....OK .77.OK .78....O=
K .7980.....OK .OK 8182OK .83.OK .84.............OK .85.......OK .OK 8687OK=
 .OK 88.89.OK ..OK 9091.......OK ..92..OK ..93..OK .OK .9495...OK .96..OK .=
97.....OK ..OK 98.OK 99100OK ..101.............OK .102.......OK .OK 103104.=
=2E.OK .105OK .OK 106OK 107108........OK .109...OK .110..OK .OK 111112....O=
K .113..OK .114....OK  SUCCESS
Bisecting: 1912 revisions left to test after this (roughly 11 steps)
[38e5781bbf8e82c1635ea845e0d07b2228a5ac7a] Merge git://git.kernel.org/pub/s=
cm/linux/kernel/git/davem/net
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-13:52:11 38e5781bbf8e82c1635ea845e0d07b2228a5ac7a compiling
2013-01-11-13:52:53 38e5781bbf8e82c1635ea845e0d07b2228a5ac7a SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1912 revisions left to test after this (roughly 11 steps)
[b12e2c12da5a35627063f38c51657af56c2162a3] leds: Kconfig: Fix typo 'D2NET_V=
2'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-13:53:04 b12e2c12da5a35627063f38c51657af56c2162a3 compiling
/home/wfg/linux

2013-01-11-13:54:36 detecting boot state 3.2.0-rc1-bisect-00320-gb12e2c1 #1=
 ......12......3....4...5....6.......7.8...910............11........1213..O=
K .OK .14OK 1516OK .17.......OK .OK .18.....OK .OK .19......OK .OK 2021..OK=
 .22......OK .23OK .24..OK 25OK .26...........OK ..27.....OK .28OK .OK 2930=
OK .31OK .32.OK .33........OK .OK .3435OK ..36..OK .37..OK .OK 3839..OK .40=
=2E.....OK .41OK .42...OK ..OK 4344..............OK .45.....OK .46OK .OK 47=
48OK .OK 49OK .5051...........OK .OK .52OK ..53..OK .54..OK .OK 55.56......=
=2E..OK .57OK ..58...OK .OK 59.60.............OK .61.OK .62...OK ..OK 63.OK=
 64.65OK ..6667..........OK .6869OK .70..OK .7172..OK .OK 7374...........OK=
 .75OK .76..OK .77OK 78..............OK .79.OK .80....OK 81.OK 82OK .83..OK=
 .8485.........OK .OK 86OK .8788...OK .OK 8990..OK .OK .9192......OK 93....=
OK .OK .OK 949596............OK .97.OK .98.....OK .99.OK .100..OK .101..OK =
=2E102103.........OK 104OK .105OK 106....OK .OK .OK 107108..OK .109......OK=
 110.....OK .OK .111OK 112113...........OK  SUCCESS
Bisecting: 1912 revisions left to test after this (roughly 11 steps)
[475f1b52645a29936b9df1d8fcd45f7e56bd4a9f] net: sk_update_clone is only use=
d in net/core/sock.c
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-14:05:35 475f1b52645a29936b9df1d8fcd45f7e56bd4a9f compiling
2013-01-11-14:06:23 475f1b52645a29936b9df1d8fcd45f7e56bd4a9f SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1912 revisions left to test after this (roughly 11 steps)
[d83b405383c965498923f3561c3321e2b5df5727] USB: serial: add support for mul=
tiple read urbs
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-14:06:33 d83b405383c965498923f3561c3321e2b5df5727 compiling
/home/wfg/linux

2013-01-11-14:08:07 detecting boot state 3.2.0-rc1-bisect-00038-gd83b405 #1=
 OK .1.OK .2.......OK .3OK .4...OK .5........OK ...6..OK .7..OK .8.OK ..OK =
9OK .1011..............OK .12OK ..13OK .14....OK .OK 1516..OK .17.OK .18...=
=2E...OK .19OK .20...OK .21......OK .22..OK .23..OK ..24.OK .25.OK .26.OK .=
OK .2728............OK .OK .2930..OK .31....OK .OK .3233.OK 34..OK .35...OK=
 .36....OK .OK .37.........OK .38..OK .39...OK .40..OK 41..OK .42..OK .OK 4=
344........OK .45...OK .46..OK .47.....OK .OK 4849.OK .50..OK .51..OK .52.O=
K .53...OK .54.........OK ..55.....OK .OK 56.57OK .58..OK .OK .5960.......O=
K .61...OK .62..OK .63......OK .64.OK .OK ..65....OK .66..OK .67..OK 68...O=
K .69..........OK 70OK .71....OK .72OK .73OK .74...OK .OK .7576......OK .77=
=2E..OK .78..OK .79......OK ..80..OK ..OK .81.82....OK .83.OK ..84..OK .85.=
=2E........OK .OK 8687....OK .OK 88.89OK 90....OK ..OK 91.92.....OK .93...O=
K .94..OK .95......OK .96.OK 97..OK  SUCCESS
Bisecting: 1874 revisions left to test after this (roughly 11 steps)
[4dbeccdf7b7573e90b442b6bd896c10c1608e72d] bf54x: get mem size: missing bre=
ak in switch
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-14:17:59 4dbeccdf7b7573e90b442b6bd896c10c1608e72d compiling
2013-01-11-14:18:43 4dbeccdf7b7573e90b442b6bd896c10c1608e72d SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1874 revisions left to test after this (roughly 11 steps)
[b17471f5d121a53be1ccf6e0b0599441e56b468c] net: macb: fix build break with =
!CONFIG_OF
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-14:18:54 b17471f5d121a53be1ccf6e0b0599441e56b468c compiling
/home/wfg/linux

2013-01-11-14:20:26 detecting boot state 3.2.0-rc4-bisect-00043-gb17471f #1=
 OK ...OK .OK 1.2....OK .OK .3.OK 45...OK .6.....OK .7..OK .8OK 9.10..OK .1=
1..OK .12...OK .13..............OK .14....OK .15OK 1617........OK .OK 1819.=
=2EOK .20...OK .OK .OK 21.22..OK .23....OK .24...OK ..OK 25OK .2627.....OK =
28....OK 29...............OK .30....OK .OK 31OK .32........OK 33OK .34.OK .=
35OK .OK .36...OK .37..OK .38.....OK .39....OK .OK 40OK ..41OK ..42..OK .43=
=2E..............OK .44OK .45.OK ..OK 46.47............OK .OK 4849.OK .50.O=
K .5152..OK .53...OK .54....OK ..OK 55.56..OK .OK 57OK .585960...OK .61....=
=2E........OK .62OK .63OK .64....OK .65.........OK .66OK ..67..OK .68.OK .O=
K .6970.OK .OK 71.72.......OK .73.OK .74..OK .OK .75OK 76OK .77...OK .78...=
=2E.....OK .79..OK .80OK .81......OK .82.........OK 83..OK .84..OK .85..OK =
=2EOK 8687..OK .88........OK .89.OK .90...OK 91.OK .OK 92OK 9394...OK .95..=
=2E.....OK .OK .OK  SUCCESS
Bisecting: 1897 revisions left to test after this (roughly 11 steps)
[b3a0aa3ae1c0889ffe8abb2e326d5c74c7c9c097] rtc-puv3: solve section mismatch=
 in rtc-puv3.c
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-14:29:52 b3a0aa3ae1c0889ffe8abb2e326d5c74c7c9c097 compiling
2013-01-11-14:30:36 b3a0aa3ae1c0889ffe8abb2e326d5c74c7c9c097 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1897 revisions left to test after this (roughly 11 steps)
[1a96571db0a80dbbb935dee26589dd528da0ed06] Enable 32 bit flash support for =
iMX21ADS board
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-14:30:46 1a96571db0a80dbbb935dee26589dd528da0ed06 compiling
/home/wfg/linux

2013-01-11-14:32:18 detecting boot state 3.2.0-rc6-bisect-00004-g1a96571 #1=
 ......OK .1OK .2.OK .3OK ..4OK .5OK .OK 6.7.............OK .OK .8OK 9.10..=
=2E..........OK .OK 11.12OK .13OK .14.....OK 15OK 1617..............OK .18O=
K 19.OK .OK 2021OK .22...OK .OK 2324...............OK .OK 25OK .2627.......=
=2E.OK .OK .2829..OK .30OK .31..OK .32OK .3334.............OK .OK 3536.OK .=
OK .37OK 38.39......OK .OK .4041............OK .42OK .43OK .OK .4445.....OK=
 .46...OK .47..OK .48OK .49....OK .OK 5051OK .52...........OK 53OK .54.OK .=
55OK .OK 5657.......OK .OK 5859.............OK .OK 60.61OK ..OK 6263....OK =
=2E64....OK .65..OK .OK 66.67...OK .OK 6869OK .70...OK .71........OK 72..OK=
 .73OK .OK 7475.......OK 76.OK 77............OK .78.OK .79.OK .OK 8081....O=
K .82....OK .83..OK .84OK 85....OK ..OK 8687OK .88..OK .89....OK 90..OK .91=
OK .OK .9293.....OK .94OK .95...........OK .OK 9697.OK .98.....OK .99.....O=
K .100....OK ..OK  SUCCESS
Bisecting: 1893 revisions left to test after this (roughly 11 steps)
[2dfff235918276638875a1d094f061083ccd6de8] input: ambakmi: Enable module al=
ias autogeneration for AMBA drivers
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-14:41:43 2dfff235918276638875a1d094f061083ccd6de8 compiling
/home/wfg/linux

2013-01-11-14:43:12 detecting boot state 3.2.0-rc2-bisect-00007-g2dfff23 #2=
 ..123....4...5..6....7....8...9.10..11....12.......13.14.......15..OK 16..=
=2E..........OK .17..OK .18OK 19...OK .20..OK .21.OK .22...OK .OK 23.24..OK=
 .25..OK .OK 26.27.....OK .28...OK .29OK .30.....OK .31.OK ..32............=
=2EOK .33..OK .OK 34.OK 3536.....OK .37.OK .38..OK .39...OK .40OK .41.OK ..=
42..OK .OK 43OK .4445....OK ..46..OK .47OK .48.OK ..49.....OK .50..........=
=2E..OK 51...OK .52OK .53OK 54.....OK .55.OK .56..OK .57...OK .58OK .59..OK=
 .60..OK .61OK .OK 6263.....OK 64.OK .65OK .66....OK .67.OK .68............=
OK .69...OK 70....OK 71.OK 72.....OK .73..OK 74..OK .75...OK .76OK .77..OK =
=2E78.OK .OK 7980OK .81.....OK .82.OK .83OK .84....OK .85.OK .86........OK =
=2E87...OK .88.....OK .89OK .90..OK .OK 9192.........OK .OK 9394OK 95..OK .=
96..OK ..97..OK ..OK 98.99OK ..100....OK 101.OK ..102...OK .103.OK .104....=
=2E....OK .105106........OK 107.OK .108..OK 109OK .110.........OK 111OK .11=
2OK 113..OK .114...OK 115...OK  SUCCESS
Bisecting: 1893 revisions left to test after this (roughly 11 steps)
[5f7b0569460b7d8d01ca776430a00505a68b7584] unix_diag: Unix inode info NLA
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-14:53:43 5f7b0569460b7d8d01ca776430a00505a68b7584 compiling
/home/wfg/linux

2013-01-11-14:55:11 detecting boot state 3.2.0-rc4-bisect-01587-g5f7b056 #3=
 .....1.2..3.....45.6...7...........8...9..10.11.....12..13....14.15....OK =
16......OK .17..OK .OK .1819OK .20.OK .21.......OK .OK .OK 22OK .2324......=
=2E..OK ..25..OK ..26OK .OK 2728........OK .OK 29.30.....OK .31OK .32...OK =
=2E33......OK .34...OK 35OK .36OK 37..OK .38..........OK 39OK .OK 4041.....=
=2E..OK .OK .OK 4243.....OK .44....OK .45OK .46.....OK .47OK .48...OK .49..=
=2E..OK .OK .5051......OK .52OK .5354..........OK .OK 55OK 565758....OK .59=
=2EOK .60..OK .61......OK .62....OK .63OK 64......OK 65OK .66....OK .67...O=
K 68..OK .69.....OK .70OK .71.OK .72........OK .73OK .OK 74.OK 7576OK .77.O=
K .78.OK .79...........OK .80.OK .81.OK .82OK ..OK 83.84........OK ..OK 858=
6.....OK .87.....OK .88OK .89.OK .90........OK .91OK .92OK .OK 9394OK 95..O=
K .96.OK .97...........OK .98.OK .99.OK .100.OK .101OK .102.........OK .OK =
103104.OK .105.....OK 106.OK .107OK .108.........OK .109OK .110OK .OK 111OK=
 .112113.OK .114.OK  SUCCESS
Bisecting: 1827 revisions left to test after this (roughly 11 steps)
[ecf00475f229fcf06362412ad2d15a3267e354a1] PM / Domains: Introduce "save/re=
store state" device callbacks
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-15:05:31 ecf00475f229fcf06362412ad2d15a3267e354a1 compiling
/home/wfg/linux

2013-01-11-15:07:18 detecting boot state 3.2.0-rc3-bisect-00200-gecf0047 #4=
 .....1..2.....3...........4.5....6..78...9............1011.12.1314OK .OK 1=
516..........OK .17...OK .18.OK 19....OK .OK 2021.........OK .22.OK .23..OK=
 .24..OK .25...OK .26.........OK .27OK .28OK 29OK 30.31..OK .32OK .33.....O=
K ..34..OK .35OK .36....OK .OK .37...........OK .OK 3839......OK 40..OK .41=
=2E..OK .42..........OK .43OK .44OK 45OK 4647...OK .48OK 49......OK .50...O=
K .51OK .52.OK ..53.OK 54.......OK ..OK 5556.........OK .OK .57.OK ..5859..=
=2E..........OK .60OK .OK 61OK 626364...OK .65OK .66......OK .67..OK .68OK =
=2E69.OK .OK 7071.....OK .72OK 73..........OK .74..OK 75...OK 7677.........=
=2E....OK ..78OK .79.OK .80...OK .81OK ..82..OK .83.OK .84..OK .85OK .OK .8=
6......OK .87OK .88..........OK .89.OK .90..OK .OK 91.92.............OK .93=
=2E..OK .OK 9495.OK .96....OK .97OK .98..OK .OK .99.....OK .100OK .OK 10110=
2......OK .103OK .104.........OK ..105.OK 106...OK .OK .107108.............=
OK .109...OK .OK .110111OK .112...OK ..113OK .114..OK  SUCCESS
Bisecting: 1827 revisions left to test after this (roughly 11 steps)
[d3bc1fef9389e409a772ea174a5e41a6f93d9b7b] writeback: fix dirtied pages acc=
ounting on sub-page writes
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-15:18:39 d3bc1fef9389e409a772ea174a5e41a6f93d9b7b compiling
/home/wfg/linux

2013-01-11-15:20:09 detecting boot state 3.2.0-rc6-bisect-00004-gd3bc1fe #5=
 .1...2.....3.......45...........6.7....8.9.............10.....OK 11OK .12.=
=2E...OK .13.OK .14...OK .OK 1516....OK .17.........OK .18OK .19..OK 20....=
=2E...OK .OK 2122....OK 23..............OK .24OK .25OK .26..OK .27....OK .O=
K .2829.....OK .OK .30OK .31..OK .32.........OK .33OK .34..OK 35....OK .36.=
=2E.OK .37....OK 38..............OK .39OK .40OK 41...OK .42.....OK .OK 4344=
=2E....OK .OK 4546OK .47..OK .48.........OK .OK 49OK .50...OK 51....OK .52.=
=2E.OK .53.............OK .54OK .55OK .56...OK 57.....OK ..OK 5859.....OK 6=
0..OK .61OK 62.OK .63............OK .64OK ..65..OK .66...OK .67...OK .68...=
=2E.......OK .69OK .OK 70OK .71.........OK .OK 7273...OK .OK .74.....OK .75=
=2E..........OK .OK 7677.OK .....OK 7879..OK .80..................OK .81..O=
K .82..........OK .83......OK 8485..OK .86..........OK .87OK 88....OK .OK 8=
990..OK .91.OK .92.............OK ..93OK .94.........OK ..95....OK .9697.OK=
 .98.........OK .99OK .100....OK .OK 101102103OK .104......................=
=2EOK .105OK .106........OK 107...OK 108.OK  SUCCESS
Bisecting: 1824 revisions left to test after this (roughly 11 steps)
[269a3eb1bf10a078ede74747a61603693a3f7853] mips: txx9_sram - convert sysdev=
_class to a regular subsystem
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-15:33:03 269a3eb1bf10a078ede74747a61603693a3f7853 compiling
/home/wfg/linux

2013-01-11-15:35:29 detecting boot state 3.2.0-rc1-bisect-00061-g269a3eb #6=
 ........12.34...........5...6..7.......8..9.....10...11...12.OK .13OK ..14=
=2E............OK ..OK 1516..........OK .17......OK .18.OK .19......OK .20.=
OK .21....OK .22..OK .23...OK .24....OK ..25...........OK .26..OK .27OK .28=
=2E.....OK .29.........OK .OK .30....OK .31.OK .32....OK .33.OK ..34..OK .3=
5..OK .36....OK .37......OK .38..OK 3940...OK .41...OK 42...........OK .43.=
=2EOK 44......OK 45.OK .46.....OK .47..OK .OK 4849..OK .50....OK ..51......=
=2EOK .52..OK .OK 5354...OK 55...OK .56...........OK .57.OK .58.........OK =
=2E59OK .60....OK .61..OK 6263..OK .64.OK .65..........OK .OK 6667OK .68OK =
69....OK .70...............OK .OK .71OK .72.....OK .73....OK .74.....OK .OK=
 7576.OK .77..OK .OK 7879...........OK .OK 8081OK .OK 82.83........OK 84...=
=2E.........OK .85OK .86OK 87.........OK 88.OK 89.........OK .OK 9091..OK 9=
2OK .93.OK .94...........OK .OK 95OK .9697......OK .98............OK .99.OK=
 .OK 100101........OK .102OK .103....OK ..104......OK .OK 105106.OK 107...O=
K 108...........OK .OK 109OK 110111......OK  SUCCESS
Bisecting: 1824 revisions left to test after this (roughly 11 steps)
[8e369672af8700299ab372bad9397f230b1d591a] Merge branch 'dma-buf-merge' of =
git://people.freedesktop.org/~airlied/linux
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-15:48:43 8e369672af8700299ab372bad9397f230b1d591a compiling
2013-01-11-15:49:58 8e369672af8700299ab372bad9397f230b1d591a SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1824 revisions left to test after this (roughly 11 steps)
[23edb6e71696a5da9c5f3987d22221e12370dbce] [SCSI] mpt2sas: Do not set sas_d=
evice->starget to NULL from the slave_destroy callback when all the LUNS ha=
ve been deleted
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-15:50:22 23edb6e71696a5da9c5f3987d22221e12370dbce compiling
/home/wfg/linux

2013-01-11-15:51:57 detecting boot state 3.2.0-rc5-bisect-00056-g23edb6e #1=
 1....2..3.....4.....56...........7..8...........9.........10..1112....OK .=
13........OK .14..OK .OK 1516.......OK .17OK .18...OK .19.....OK .OK 20....=
=2E.OK .21..........OK .22........OK .23OK 24OK .OK 252627.........OK .28..=
OK .2930......OK .31OK .32...OK .33......OK .34..OK .35.OK .36...........OK=
 37.............OK .38.OK .OK 394041.........OK .OK 4243.OK .44......OK .45=
OK ..46...OK .47.....OK .OK .48.OK .49..........OK .50.............OK .51..=
OK ...OK 52.53......OK .54..OK .OK 5556.........OK 57.OK ..OK 5859.....OK .=
60.OK .61OK .62........OK .63.............OK .64.....OK .65..OK .OK .6667..=
=2E...OK ..OK 6869.......OK .70.OK .71OK .72.....OK 73..OK .OK 7475........=
OK .76.................OK .77.....OK .78....OK .OK 7980......OK .OK 81OK 82=
83...OK .84.....OK .85OK 86.....OK .OK 8788OK .89..........OK .90..........=
=2E..OK .91....OK .92....OK .OK .9394.OK .95OK ..96OK ..97.OK .98....OK .OK=
 .99100...OK .101...OK .OK 102103OK .104.............OK .105..........OK 10=
6.........OK 107......OK .108..OK .109OK .110.OK 111.112........OK .OK  SUC=
CESS
Bisecting: 1789 revisions left to test after this (roughly 11 steps)
[c0fdbe149c9d1cab9057c39a10cd609751541cf2] staging:iio: iio_trigger contain=
s defunct owner field. Remove it.
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-16:05:07 c0fdbe149c9d1cab9057c39a10cd609751541cf2 compiling
/home/wfg/linux

2013-01-11-16:06:07 detecting boot state 3.2.0-rc5-bisect-00426-gc0fdbe1 #2=
 ..1...2...3.4.5.6...........789..10...11.............12..........13....OK =
=2E14......OK .15..OK .16..OK .17.OK .18OK ..19.OK ..20..........OK .OK .OK=
 21222324..OK .25........OK ..26............OK .27.....OK 28...OK 29......O=
K .OK 3031...OK .32OK 33..OK 34............OK .35OK .36OK .OK 37OK 38.39..O=
K .40........OK .41.........OK .42....OK .43..OK ..44.....OK ..45..OK .46OK=
 47..OK 48................OK .49OK .OK 5051OK .OK 5253...OK .54.........OK =
55.........OK .56.....OK 5758......OK .59..OK .OK .60...OK .61.OK .62......=
=2E.....OK .63....OK .OK 6465OK .OK 66.67..OK .68....OK .69.........OK .70.=
=2E...OK .71.OK ..72..OK 73....OK .74......OK .OK 7576...............OK 77.=
=2E...OK .OK 7879OK .80OK 81...OK .82....OK .83........OK .84..OK 85......O=
K .86..OK .87OK .88..OK 89..OK .OK ..90.............OK ..91.....OK .92.OK .=
93.OK .94OK .95...OK .OK 9697.........OK .98.....OK .99.....OK .OK 100101..=
=2EOK .102..OK .103...OK .OK 104105.............OK .106.....OK 107108OK .10=
9OK .110........OK .OK 111112.....OK .113....OK  SUCCESS
Bisecting: 1756 revisions left to test after this (roughly 11 steps)
[c378ddd53f9b8832a46fd4fec050a97fc2269858] memblock, x86: Make ARCH_DISCARD=
_MEMBLOCK a config option
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-16:18:53 c378ddd53f9b8832a46fd4fec050a97fc2269858 compiling
/home/wfg/linux

2013-01-11-16:20:36 detecting boot state 3.0.0-rc7-bisect-00029-gc378ddd #3=
 1..2................3.45..6..7.............89........10...11......OK .12..=
=2EOK .13.OK .OK 1415OK .16....................OK 17OK 18.OK 19.OK .20..OK =
21........OK .OK 2223............OK .24.OK .25.......OK .26..OK .OK 27.28..=
=2EOK .29...............OK .OK 3031OK .32OK ..33..........OK .34....OK .35.=
=2E.........OK .36..OK 37........OK 3839..OK .OK 40OK 4142..OK .43.........=
=2E..OK .44.OK .45OK .OK 4647.........OK .48....OK .49...........OK .50..OK=
 .51.......OK ..OK 525354OK .55...OK ..56............OK 57.OK .58OK .59..OK=
 ..OK 6061.........OK 62.....OK .63...........OK 64...OK .65.......OK .66OK=
 .67OK .68....OK .OK 6970...........OK .71.OK .72OK .OK .OK 737475.......OK=
 .76....OK .77...........OK .7879.............OK .80OK .81OK .82OK .83....O=
K .OK 8485.......OK .86.....OK 8788.OK .89OK .90...OK .91OK .92............=
=2E...OK 93..OK .94..........OK .95OK .96OK .OK 97.98....OK .OK 99100......=
OK ..101....OK .102103OK ..OK 104105...OK .106.OK 107....................OK=
 .108..OK .109..........OK 110OK 111112...OK 113.....OK .OK 114115.......OK=
 .116.....OK  SUCCESS
Bisecting: 1756 revisions left to test after this (roughly 11 steps)
[c607b2ed84929e143d9fb5653c4b5d0109147cde] net: fix compilation with !CONFI=
G_NET
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-16:34:00 c607b2ed84929e143d9fb5653c4b5d0109147cde compiling
/home/wfg/linux

2013-01-11-16:35:33 detecting boot state 3.2.0-rc4-bisect-01602-gc607b2e #4=
 1.....2................3....4........5.6.7...8..9....10...11........OK .12=
=2EOK ..13OK .OK ..1415..OK .16...............OK .17.......OK .18.......OK =
=2E19OK .20OK .21..OK .22.OK .23....OK 24...OK 25........OK .26..OK .27..OK=
 .OK 2829..OK .30...............OK .31.......OK .32...OK .33OK .34OK .35..O=
K .36.OK 37.....OK .38.OK .39........OK .40.OK ..41...OK 4243.OK .4445.....=
=2E.........OK 46............OK 47..OK 48.OK 49...OK 5051....OK .52....OK .=
53..OK .54....OK .55..OK .56......OK .OK ..57OK .58...........OK ..59......=
=2E...OK 60..OK .61OK .62..OK .63..OK .64.....OK .65OK .66.....OK .67....OK=
 .68...OK 69........OK .7071OK 72............OK .73......OK 74...OK .75...O=
K .OK .76..OK 77....OK 78....OK .79....OK .80....OK .81..OK .82........OK .=
83OK 84OK 8586..........OK .87.....OK .88..OK .89.....OK .90..OK .91..OK .9=
2....OK .93.......OK .94.....OK 95.......OK 96......OK .97OK .98OK .99.....=
=2E...OK .100.....OK .OK .101.....OK .102.OK .OK 103.104.....OK .OK 105106.=
=2E.....OK ..107...OK .108109.....OK .110.........OK .111.OK 112.......OK .=
113..........OK  SUCCESS
Bisecting: 1756 revisions left to test after this (roughly 11 steps)
[7037bd803e24d4fdaa87f27456e686aafb061277] unicore32: Use set_current_block=
ed()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-16:48:59 7037bd803e24d4fdaa87f27456e686aafb061277 compiling
2013-01-11-16:49:43 7037bd803e24d4fdaa87f27456e686aafb061277 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1756 revisions left to test after this (roughly 11 steps)
[a398eaa23e42b73216efbe03dc1d754b2e5d603c] regulator: Export regulator_is_s=
upported_voltage()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-16:49:53 a398eaa23e42b73216efbe03dc1d754b2e5d603c compiling
/home/wfg/linux

2013-01-11-16:51:29 detecting boot state 3.2.0-rc3-bisect-00042-ga398eaa #1=
 ............12.......3.......45....6....7......89.....10.....OK .11..OK 12=
=2E.........OK .13............OK .OK 141516.OK .17.......OK .18..OK .OK 192=
0..OK .21...OK .22.....OK .OK 2324OK .25........OK .26..OK .27..........OK =
=2E28.............OK 29OK 3031.OK .32.......OK .33..OK ..OK 34.35.OK ..36..=
=2E..OK .OK .OK 373839........OK .40..OK .41..........OK 42.............OK =
=2E43..OK .OK 4445...........OK 46...OK .47OK .48..OK .49.......OK .OK 5051=
=2E.......OK .52..OK .53.....OK .54.............OK .55..OK .OK 5657.OK .58.=
=2E.........OK .OK .59...OK .OK ..6061OK .62...OK .OK 6364...........OK .OK=
 .65.........OK 66..............OK 67...OK 68OK 6970...........OK .71..OK .=
72.....OK 73OK 7475OK 76..OK .77OK .78.........OK .7980.......OK .81.......=
=2E.....OK .82..OK .OK 83OK .84...........OK .85.OK .86..........OK 8788OK =
=2E89..OK .90OK .91.........OK .OK 9293.......OK 94......OK .95.......OK .9=
6.OK .97OK .98..........OK .99..OK .100.....OK .OK .101OK 102103OK .104OK .=
105....OK .106.....OK .OK 107.108.....OK .109.....OK .110........OK .111...=
OK .112OK  SUCCESS
Bisecting: 1717 revisions left to test after this (roughly 11 steps)
[65c64ce8ee642eb330a4c4d94b664725f2902b44] Partial revert "Basic kernel mem=
ory functionality for the Memory Controller"
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-17:04:41 65c64ce8ee642eb330a4c4d94b664725f2902b44 compiling
/home/wfg/linux

2013-01-11-17:06:07 detecting boot state 3.2.0-rc4-bisect-01826-g65c64ce #2=
 1.2.............3...4..5..6..78.9..........10....11....12.....13..........=
=2EOK .14....OK 15.OK 16.........OK .17..OK .18.....OK .19.OK .20OK .OK 21O=
K ..22..........OK .2324..OK .25....OK .OK 2627..........OK .28....OK 29.OK=
 30.........OK .31..OK .32.........OK .33.OK .34.OK .35OK .OK 3637.........=
=2EOK .OK 3839........OK .OK 4041......OK .42...OK .43OK .44........OK .45.=
=2E.OK .46........OK .47.OK .48.OK .49OK .OK .50...........OK ..51OK .52.OK=
 .53...OK .54......OK 55........OK 56.OK 57.........OK 58...OK .59.........=
OK .60.OK .61.OK 62..OK 6364.....OK 65..OK .66.....OK .67OK .OK .6869.....O=
K .70.......OK .71OK .72........OK .73...OK .74........OK .75.OK .76.....OK=
 .77.OK .78.OK .79.....OK .80......OK 81..OK .OK 82.....OK .83........OK .8=
4OK 85.........OK .86...OK .87........OK .88.OK .89.....OK .90OK 91OK .9293=
=2E..OK .94.....OK .95..OK ..96.OK .97.OK .98........OK .99...OK .100......=
=2E..OK .OK 101102...........OK 103OK .104.......OK .105OK .106OK .OK 107..=
=2E.OK .108.OK 109........OK 110..OK 111..OK  SUCCESS
Bisecting: 1717 revisions left to test after this (roughly 11 steps)
[77e81365e0b7d7479fc444a21cea0cd4def70b45] sched: Clean up domain traversal=
 in select_idle_sibling()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-17:18:41 77e81365e0b7d7479fc444a21cea0cd4def70b45 compiling
/home/wfg/linux

2013-01-11-17:20:09 detecting boot state 3.2.0-rc1-bisect-00321-g77e8136 #3=
 .............1....23.......4...........56........789.10.....11.....OK .OK =
=2E12....OK 13OK .14...........OK .15...OK .OK 1617......OK .18.........OK =
=2E19OK .20.......OK 21OK .22.OK 23.OK 24.......OK .25..OK .26..OK .OK 2728=
=2E...OK .29.......OK 30........OK 31OK 32.......OK .33.........OK .34OK .3=
5..OK .OK 3637.OK 38.....OK .39..OK .40..OK .41..OK .OK .4243.......OK .44.=
=2E.OK .45.......OK .46...OK .47......OK .48..........OK .OK 49OK 50OK .51.=
=2E..OK .52.OK 53...OK .54..OK 55........OK .OK 5657........OK .58.........=
=2E.OK .OK .59......OK .60......OK 61.....OK .62.OK ..63....OK .OK 6465OK .=
=2E66.OK .67.....OK .68.OK .69........OK .70..OK .71.........OK 72...OK .73=
=2E.....OK .74....OK .75OK 76.OK .77.....OK .OK 7879OK ..80.....OK .81..OK =
=2E82OK .83.OK ..84.......OK .85..OK .86........OK .87..OK .88......OK .89.=
=2E...OK .OK 9091.OK .92........OK ..OK 9394........OK 95..OK .96.OK 97...O=
K 98....OK 99.......OK .100........OK 101...OK .102..OK .103......OK .104.O=
K .105..OK .106.....OK .OK  SUCCESS
Bisecting: 1717 revisions left to test after this (roughly 11 steps)
[77271ce4b2c0df0a76ad1cbb6a95b07e1f88c1ea] tracing: Add irq, preempt-count =
and need resched info to default trace output
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-17:32:19 77271ce4b2c0df0a76ad1cbb6a95b07e1f88c1ea compiling
/home/wfg/linux

2013-01-11-17:33:46 detecting boot state 3.2.0-rc1-bisect-00105-g77271ce #4=
 .....12....3...4.5........6....7...........8.........9........OK .OK 1011.=
=2E...OK .12.....OK .13OK .14..OK .15..OK .16OK 17OK 1819......OK ..20..OK =
=2E21...........OK .22...OK .23......OK 24.....OK .25...OK .26....OK .27...=
OK .28.OK 29....OK .OK 3031.OK ..OK 32OK 3334..OK .35...OK .36..........OK =
=2E37...OK .38......OK .39.....OK .40...OK .41.OK 42....OK .43........OK .4=
4....OK 45OK .46..OK .OK 4748....OK .49...OK 50.......OK 51........OK 52...=
OK .53.........OK .OK 5455....OK .56OK .57........OK .58...OK .OK 59OK .60.=
OK .61OK .62....OK .63..OK .64......OK .65.......OK .66...OK .67..........O=
K .68.OK 69......OK 70.OK .71.......OK .72.OK .73OK .74OK .OK 75...OK .76..=
=2E.OK .77...OK 78..OK .79........OK .80..OK .81..........OK .82OK .83.....=
OK .84.OK .85.......OK .86.OK .87..OK .88OK .89.OK ..90.......OK .91..OK .O=
K 9293.......OK .94..OK .95.............OK 96.OK 9798..........OK .99......=
=2EOK .100.OK .101OK 102103104OK ..105......OK .106...OK .OK .107108.....OK=
 .109...OK .110............OK  SUCCESS
Bisecting: 1717 revisions left to test after this (roughly 11 steps)
[21a2cb565a74bf794d343ce22300c5f6c1568ae1] Merge branch 'char-misc-next' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-17:46:08 21a2cb565a74bf794d343ce22300c5f6c1568ae1 compiling
2013-01-11-17:46:54 21a2cb565a74bf794d343ce22300c5f6c1568ae1 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1717 revisions left to test after this (roughly 11 steps)
[53466710202900ce49e471f480cac11275e1d0c4] jffs2: fix up error handling for=
 insert_inode_locked
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-17:47:04 53466710202900ce49e471f480cac11275e1d0c4 compiling
/home/wfg/linux

2013-01-11-17:48:35 detecting boot state 3.2.0-rc7-bisect-00040-g5346671 #1=
 .1......2..3..................4..5....6...........7...8......9..1011.OK .1=
2OK .13OK .14.....OK .15..OK .16OK .17.................OK .18.OK .19....OK =
20..........OK .21..OK 22..........OK .23.OK .24..OK 25.OK 26.OK .27.....OK=
 .28....OK 29.............OK 3031.......OK .32.............OK .OK .33......=
=2E.OK .OK .34OK 3536....OK .37OK .OK .38.....OK .3940..OK .41............O=
K .OK .4243......OK .44..................OK .45..OK .46..OK 47..OK .48.OK 4=
9OK .50.....OK .OK 51..OK 52....OK .53............OK .54...OK 55...OK .56..=
=2E...............OK .5758OK .59..OK .60..OK .61OK .62....OK .63.OK .64..OK=
 65OK ..66...........OK .67.......OK 68.......OK .69...............OK .70..=
OK .71.OK 72...OK .OK 7374....OK .75...OK .76OK .77OK .7879..........OK .80=
=2E.OK ..81..........OK .82...............OK .8384.......OK .85...OK .OK 86=
87....OK 88....OK 89OK 90OK 9192.OK 93...........OK .OK 9495..........OK .9=
6...............OK .97...OK .98...OK 99....OK .OK .100101..OK .102...OK .OK=
 .103OK 104105OK 106.107.......OK .108.OK .109.......OK .110...............=
OK 111....OK 112...........OK .113.....OK 114OK  SUCCESS
Bisecting: 1677 revisions left to test after this (roughly 11 steps)
[ddf536d0d7e1f0b63a681c970888730a4437414d] ARM: OMAP: AM3517/3505: fix cras=
h on boot due to incorrect voltagedomain data
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-18:02:41 ddf536d0d7e1f0b63a681c970888730a4437414d compiling
/home/wfg/linux

2013-01-11-18:04:07 detecting boot state 3.2.0-rc5-bisect-00006-gddf536d #2=
 .1..234......5.67.........8.....9....10................11...12............=
OK 13...OK .14.OK .1516OK .17.OK .1819.OK .20OK ..21......OK .22.....OK 23.=
=2E.OK .24...........OK .25......OK .26...........OK .27..OK .28..OK .29...=
=2EOK 30OK 31.OK .OK 3233....OK .34.......OK .35....OK .OK 36.......OK .37.=
=2E.........OK 38...........OK ..39..OK .40..OK .41...OK .OK .42.OK .OK 434=
4....OK .4546......OK .47....OK .48........OK 49..............OK .50....OK =
51.......OK 52...OK .53....OK .54.OK .OK 55...OK .56OK .57...OK 58...OK .59=
=2E..OK .OK .60.......OK .61..............OK .62...OK .63......OK .64..OK .=
OK .65....OK .66.OK 6768...OK .69OK .70......OK 71....OK 72.OK 7374........=
=2E..OK .75..........OK 76........OK .77..OK 78....OK .79..OK .80..OK .OK 8=
182.OK .83..OK 84.OK .85...OK .86.OK .87OK .88.OK .89..........OK .90......=
=2E...OK .91........OK 92..OK .93........OK .94......OK 95OK 9697....OK .98=
=2EOK .99..OK 100.....OK .101.OK 102.......OK .103..........OK 104.........=
=2E..OK .105..OK 106....OK .OK .107108....OK .OK .109110OK .111....OK .112O=
K  SUCCESS
Bisecting: 1674 revisions left to test after this (roughly 11 steps)
[64c4e9f8988e6974ee7cae569fa500e7e673837b] arm/tegra: add support for tegra=
30 based board cardhu
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-18:17:09 64c4e9f8988e6974ee7cae569fa500e7e673837b compiling
/home/wfg/linux

2013-01-11-18:18:37 detecting boot state 3.2.0-rc4-bisect-00140-g64c4e9f #3=
 1....23....4............5..........6.............7..8...9..10....11..OK .1=
2..OK ..OK 1314..OK .15OK .16.OK 17.....OK .18...........OK .19..........OK=
 20.......OK .21..OK .22......OK .23.OK .24...OK .25..OK ..26..OK .27.OK .O=
K 28OK .29.....OK .30...........OK .31.....OK .32.......OK .33......OK .34.=
=2E.......OK .35..OK .36OK .37OK .38OK 39.......OK .40.OK .41OK .42.....OK =
43....OK 44.............OK .45...OK .46......47OK .48.........OK 49..OK .50=
OK .51.OK .OK 5253.......OK .54OK ..55OK .56....OK .57...OK .58............=
=2E.OK 59....OK 60.....OK .61....OK 62.........OK .63..OK 64.OK .65.OK .OK =
66....OK .67....OK .68.OK ..OK 69.70..OK .71.............OK .72...OK .73...=
=2E.OK .74....OK 75.........OK .76..OK .77....OK .78.OK 79OK 80....OK 81...=
=2E.OK .82..OK 8384OK 8586.............OK .87.......OK .88OK .89....OK .90.=
=2E.......OK .91..OK .92....OK .93OK .OK 94.95...OK .96....OK .97..OK .OK 9=
8OK 99.100............OK .101.......OK .102.OK .103...OK .104.............O=
K .105....OK 106.....OK .107OK 108OK .109.......OK 110OK .111..OK  SUCCESS
Bisecting: 1644 revisions left to test after this (roughly 11 steps)
[9ad1aefc8ae8d2e482b4cc4b7199e2354148bbdc] md/raid10:  Handle replacement d=
evices during resync.
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-18:31:36 9ad1aefc8ae8d2e482b4cc4b7199e2354148bbdc compiling
/home/wfg/linux

2013-01-11-18:33:03 detecting boot state 3.2.0-rc1-bisect-00038-g9ad1aefc #=
4 12.3..4............5..67...........8..........910....11....12.....OK .OK =
1314......OK .OK 15OK .OK 161718.OK .19...........OK ..20OK .OK .21........=
=2E.OK .22.........OK 23....OK .24...OK .OK 2526.........OK .OK 2728......O=
K .OK 29OK 30OK 3132..OK .33.......OK .34..OK ..35.........OK .36..........=
=2E.OK .OK 3738...OK .39OK .40.........OK .OK 4142......OK 43..OK .44OK .OK=
 4546........OK .47...OK .48.............OK .49...........OK .50OK 51..OK 5=
2.OK .53...OK 54........OK 55.....OK .OK 56...OK .OK 5758OK 59........OK .6=
0OK .61............OK .62............OK 63OK .64.OK .65.....OK .66.......OK=
 .67.....OK .68..OK .69...OK 70OK .OK 7172OK .73........OK .74........OK .7=
5.............OK 76.OK .OK 7778.....OK .79.......OK .80.....OK .81..OK .82.=
=2E..OK .OK 83OK 84OK .85........OK ..86.......OK 87.............OK .88....=
=2EOK 8990.OK .OK 9192.......OK 93.........OK .94..OK .95.....OK 96OK 97OK =
=2EOK 9899.....OK 100...OK 101...OK .102.............OK 103.....OK .OK 1041=
05.OK .OK 106107......OK ..108........OK .109......OK  SUCCESS
Bisecting: 1644 revisions left to test after this (roughly 11 steps)
[845501213033d0058945776349f15502823359d8] tile: switch to GENERIC_PCI_IOMAP
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-18:45:51 845501213033d0058945776349f15502823359d8 compiling
/home/wfg/linux

2013-01-11-18:47:14 detecting boot state 3.2.0-rc3-bisect-00012-g84550121 #=
5 .......12.3...45......6...7............8.......9.....10.11......OK .12...=
=2E........OK .13..OK .14..OK 15..OK 16...OK .OK 17.....OK .OK 1819..OK .20=
=2E......OK .21......OK .22OK .23...OK .24.......OK 25............OK .26..O=
K .27..OK .28.OK .29..OK .OK .3031....OK ..32.OK .3334......OK .35....OK .3=
6OK .37..OK ..38.....OK 39...OK .40................OK .41..OK 4243.OK 44...=
=2E....OK .OK 4546....OK .47.OK .OK 4849......OK .50.OK 51.OK 52...OK .53..=
=2E..OK .54...OK 55.................OK .56.OK 57OK 58.....OK .59....OK .OK =
60.....OK .61...OK 62..OK 63.......OK .64OK .65OK .OK 66........OK .OK 67..=
=2E.............OK .68.OK .OK 6970.....OK 71.....OK .72....OK ..73..OK .74.=
OK .75.......OK .76..OK ..OK 7778.......OK .79....................OK .80..O=
K 8182.....OK .83......OK .84...OK .OK 85......OK .86...OK .87.......OK .OK=
 8889...OK .9091...................OK .92.OK .OK 9394.....OK .95......OK .9=
6OK 9798..OK 99......OK .100...OK .101........OK 102.OK 103OK .104OK .105..=
=2E....................OK .OK 106107........OK .108...OK .109OK 110..OK  SU=
CCESS
Bisecting: 1632 revisions left to test after this (roughly 11 steps)
[4145fa7fbee3ec1e61c52825b146192885d9759f] rcu: Deconfuse dynticks entry-ex=
it tracing
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-19:00:22 4145fa7fbee3ec1e61c52825b146192885d9759f compiling
/home/wfg/linux

2013-01-11-19:01:47 detecting boot state 3.2.0-rc5-bisect-00026-g4145fa7 #6=
 ...1...2...3........45...6.....7.89..................OK .10.11..12..OK .13=
=2E...OK .14.....OK .15............OK .16...OK .17...OK .18OK .OK 19OK 2021=
=2E................OK .22OK .OK 23.OK .24...OK 25....OK .26......OK 2728...=
=2E........OK 29...OK .30....OK 31.OK 32OK .OK 3334............OK .35OK .OK=
 .36OK 3738.......OK .39OK 40..........OK 4142........OK .43..OK .44...OK 4=
5....OK 46.OK 47OK .48OK 49.............OK 50.OK .OK 5152OK 53.......OK .54=
OK .55.........OK .56........OK .57..OK .58...OK .59...OK .60OK .61OK .OK 6=
263...........OK .OK 6465...OK .66..OK .67.OK 68.............OK .OK 69.....=
=2E...OK 70...OK 71....OK 72....OK .OK 7374OK .75OK 76............OK 77OK .=
78...OK 79...OK .80OK .81.............OK .82....OK .83..OK 84....OK .85...O=
K .86OK .87....OK 88OK .89...........OK 90.OK 91...OK 92....OK .OK 9394....=
=2E........OK .95....OK .96..OK .97....OK 98....OK 99OK .100.OK .101.OK .10=
2............OK .103OK 104...OK .105...OK .106OK .107.............OK .108OK=
 109110.OK ..111.......OK  SUCCESS
Bisecting: 1632 revisions left to test after this (roughly 11 steps)
[e7c8e8605d0bafc705ff27f9da98a1668427cc0f] drivers/usb/class/cdc-acm.c: cle=
ar dangling pointer
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-19:13:57 e7c8e8605d0bafc705ff27f9da98a1668427cc0f compiling
/home/wfg/linux

2013-01-11-19:15:19 detecting boot state 3.2.0-rc5-bisect-00237-ge7c8e86 #7=
 ..1....23..4..5........6......78...9.10...................11....OK .12.OK =
=2E13........OK .14...OK 15OK .16....OK 17OK .18......OK 19.OK .OK 2021.OK =
=2E22....OK 23....OK .24.............OK .25..OK .26OK 27.....OK .28....OK .=
29..OK .30OK .31..OK ..32OK 33......OK .34OK .OK 3536.OK .37...OK .38....OK=
 .39.............OK 40....OK .41OK .42.......OK .43.OK .44..OK .45.OK 46.OK=
 .47..OK 48..........OK .49.OK 50OK 51...OK .52....OK .53..............OK .=
54...OK .55OK .56........OK .57OK .58..OK .59.OK 60..OK .61.OK .62.........=
=2E..OK .OK 6364.......OK 65....OK .66..............OK .OK 67....OK .68....=
=2E...OK .OK 6970.OK .71....OK .72..OK 73..OK .74........OK .OK 757677.....=
OK .78....OK .79..............OK 8081....OK .82........OK .OK 8384.........=
=2E.OK 85..OK .86..OK 87.....OK 88....OK .OK 8990.....OK 91OK .92..........=
=2E...OK .OK 93....OK .94.........OK .OK 95.96.........OK .97..OK .98..OK .=
99....OK .100...OK .OK .OK 101102...OK .103OK .104..........OK .105...OK 10=
6.....OK 107..........OK .OK 108109.OK  SUCCESS
Bisecting: 1433 revisions left to test after this (roughly 11 steps)
[c3e0ef9a298e028a82ada28101ccd5cf64d209ee] [S390] fix cputime overflow in u=
ptime_proc_show
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-19:27:53 c3e0ef9a298e028a82ada28101ccd5cf64d209ee compiling
/home/wfg/linux

2013-01-11-19:29:23 detecting boot state 3.2.0-rc5-bisect-00054-gc3e0ef9 #8=
 .......1...2....3..4........56..78........9.......10..........11.....OK .O=
K 1213OK .14........OK .15..OK .16...OK .17OK .18.......OK .OK 1920..OK .21=
22.......OK .23.....OK .OK 2425.........OK .26....OK .27...OK .28OK .29....=
OK .30......OK .31.OK .32.OK 33.......OK 34.OK .35....OK .36...OK .37......=
OK .38.........OK .39.....OK .40...OK .41OK .42....OK .43......OK .44...OK =
=2E45OK .46........OK .47.OK .48....OK .OK 4950.....OK .OK 5152.........OK =
53.....OK .54.....OK .55OK .56......OK .57.......OK .OK 58OK 5960........OK=
 .61.....OK .62OK .OK .6364.....OK .OK ..65.......OK .66....OK ..67....OK .=
68OK .69.......OK 70.........OK 71.OK .72.OK .73....OK 74......OK .75.....O=
K .OK 76.......OK .OK 77........OK .78....OK .79OK .80.OK 81.......OK .82..=
=2E.....OK .83OK .84.OK .85....OK .86.....OK .87......OK .888990.....OK .91=
=2E......OK .92.....OK 93.OK 94.....OK .95...OK 96.......OK .OK 9798.......=
=2EOK .99OK .100.....OK .101...OK .102..OK .OK 103104.........OK .OK 105106=
=2E.OK .107....OK .108OK .109.....OK .110..OK  SUCCESS
Bisecting: 1433 revisions left to test after this (roughly 11 steps)
[cf8e019b523a8caa95b56ff0ce62a4856b14395f] hvc_xen: introduce HVC_XEN_FRONT=
END
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-19:42:03 cf8e019b523a8caa95b56ff0ce62a4856b14395f compiling
/home/wfg/linux

2013-01-11-19:43:35 detecting boot state 3.2.0-bisect-06289-gcf8e019 #9 ...=
 TEST FAILURE
Bisecting: 1430 revisions left to test after this (roughly 11 steps)
[fe76daea9ede24f9f53cb847563c2fa7a50cedf2] ARM: restart: w90x900: use new r=
estart hook
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-19:43:46 fe76daea9ede24f9f53cb847563c2fa7a50cedf2 compiling
/home/wfg/linux

2013-01-11-19:45:11 detecting boot state 3.2.0-rc7-bisect-00073-gfe76dae #1=
0 12.................................................................OK .3.=
OK .4OK 5.OK 67OK 8OK .OK 910.1112.........................................=
=2E............OK .13........OK .OK 14OK 15.OK 16OK 17OK 18.OK 1920.OK .OK =
2122.................................................OK 23.........OK .OK 2=
425OK .OK .26OK 27....OK .OK 28..OK .OK 2930...............................=
=2E.............OK 31.........OK .32OK .33..OK .34....OK .35..OK .OK .36373=
8...............................................OK .39....OK .40...OK 41.OK=
 ..4243OK ..44..OK .45....OK .OK 464748....................................=
=2E....OK .49.......OK .5051.OK .52..OK .OK 53.5455..OK .56OK .OK .OK .OK 5=
7585960.......................................OK .61.............OK 6263..O=
K 6465OK .OK 6667.OK .OK .68...OK .69.OK .70OK .OK 71OK .72................=
=2E.................OK .73............OK .OK .74.OK .OK 75.....OK 76OK .77.=
=2EOK .78...OK .79.OK 80.OK .81OK 82..................................OK .8=
3..........OK .84.OK .85....OK .OK 8687...OK ..88OK .89OK .90..OK .91OK .92=
=2E.................................OK .93.....OK .94...OK .95....OK .OK 96=
=2E...OK 9798OK 99.....OK 100.OK 101OK .OK 102.....OK .103.................=
=2E...............OK .104..OK  SUCCESS
Bisecting: 1423 revisions left to test after this (roughly 11 steps)
[8ded9709a171a52199c5ac64912c52f7290870a0] blackfin: bf537: change num_chip=
select for spi-sport
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-20:02:21 8ded9709a171a52199c5ac64912c52f7290870a0 compiling
2013-01-11-20:03:14 8ded9709a171a52199c5ac64912c52f7290870a0 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1423 revisions left to test after this (roughly 11 steps)
[bb74041b1367b4935b8284a2b541f5e4365d3f50] TTY: Remove redundant spi driver=
 bus initialization
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-20:03:26 bb74041b1367b4935b8284a2b541f5e4365d3f50 compiling
/home/wfg/linux

2013-01-11-20:05:00 detecting boot state 3.2.0-rc3-bisect-00031-gbb74041 #1=
 ..................1...2......3.....4.5....678.9...10.11....12...13........=
=2E....................OK .14.....OK .15......OK .16OK .17OK .18...OK .19OK=
 .20OK ...21OK .22OK .23...OK .24..OK .25.............................OK .O=
K 26..OK 27..............OK .28OK .29OK .30....OK 31OK 32...OK .33OK .34OK =
=2E35...OK 3637.............................OK .38.OK .39..............OK .=
40OK .41OK .42...OK .OK 43OK 4445..OK ..OK 4647.OK .48.OK ..49..OK .50.....=
=2E...................OK 5152.OK .53..............OK .54..OK 55.OK .56..OK =
=2E57OK .OK 5859OK ..60..OK .OK 6162.OK .63..OK ..64...................OK .=
65..OK .66.OK ...67.............OK .68.OK .69.....OK 70...OK .71OK 72OK .73=
OK .74..OK .OK 75...OK .76...OK .77..............OK .78...OK 79...OK .80...=
=2E.........OK .81.OK .82.....OK .83...OK 84OK 85OK ..86OK .87.OK .OK 8889.=
=2E.OK .90...OK .91..........OK .92......OK .93.......OK 94.........OK 95OK=
 .96............OK 97...OK 98OK 99100......OK .OK 101102..OK .103...OK .104=
=2E.....OK .105.......OK 106.......OK ..107.......OK .108OK 109...........O=
K .110...OK 111OK 112OK .113.........OK  SUCCESS
Bisecting: 1379 revisions left to test after this (roughly 11 steps)
[12e55508921865aefdd80fd17afe70c191afbd1b] Merge branch 'staging-next' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-20:18:51 12e55508921865aefdd80fd17afe70c191afbd1b compiling
2013-01-11-20:19:35 12e55508921865aefdd80fd17afe70c191afbd1b SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1379 revisions left to test after this (roughly 11 steps)
[c909e99364c8b6ca07864d752950b6b4ecf6bef4] vmscan: activate executable page=
s after first usage
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-20:19:43 c909e99364c8b6ca07864d752950b6b4ecf6bef4 compiling
2013-01-11-20:20:26 c909e99364c8b6ca07864d752950b6b4ecf6bef4 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version include/linux/version.h
make: Leaving directory `/c/wfg/linux'
Bisecting: 1379 revisions left to test after this (roughly 11 steps)
[b890f4c363ebdc9c38d7f1ec91e9ec0976c4fb6a] wl12xx: stop device role on remo=
ve_interface
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-20:20:35 b890f4c363ebdc9c38d7f1ec91e9ec0976c4fb6a compiling
/home/wfg/linux

2013-01-11-20:22:02 detecting boot state 3.2.0-rc2-bisect-01255-gb890f4c #1=
 OK ....OK 12...........OK 3.....OK .4............OK .OK 56..........OK .OK=
 7OK 8OK 9OK .1011.OK 12......OK .13.OK .OK 1415......OK .OK 1617..........=
OK .18.....OK 19............OK .20OK 21...........OK 22OK .23.OK 2425OK 26O=
K .27.....OK .28..OK .29...OK .30......OK ..31......OK 32.....OK .33.......=
=2E...OK .34OK 35...........OK 36OK .37.OK .OK 38OK .OK 3940..........OK .4=
1......OK .42....OK .43.OK .44......OK .45....OK ..46.......OK 47OK .48....=
=2E.....OK .49OK .50OK .OK .51OK 52OK 5354.........OK ..55.....OK .56....OK=
 .57..OK .58..........OK 59.OK .60...........OK .61OK 62...........OK 63OK =
64OK 65OK 66OK 67...........OK 6869.....OK 70........OK .OK .71........OK .=
=2E72OK ..73..........OK .74OK 75..........OK .OK 76OK 77OK 78OK 79OK 8081.=
=2E........OK .OK .82.......OK .83.....OK .OK .84........OK .85.OK .86.....=
=2E.........OK 87OK .88......OK .89OK 9091.OK .92..OK .9394......OK ..95...=
=2E..OK .96......OK ..97.......OK .98.OK .99..............OK  SUCCESS
Bisecting: 1379 revisions left to test after this (roughly 11 steps)
[b5b4f2881f619460fdb165111bac10a3dd8eebee] ARM: OMAP4: PM: Program CPU1 to =
hit OFF when off-lined
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-20:33:51 b5b4f2881f619460fdb165111bac10a3dd8eebee compiling
/home/wfg/linux

2013-01-11-20:35:15 detecting boot state 3.2.0-rc4-bisect-00094-gb5b4f28 #2=
 ....12......3.......4.....56........78..........910.......11.12...........=
=2E........OK .OK 1314..OK .15.........OK .OK 1617OK .18...OK 19........OK =
=2EOK 2021......OK .22..OK 23.......OK .24.OK 25................OK .OK 2627=
=2E.OK .28.........OK .OK 2930OK .31..OK .32........OK .OK 33OK .34........=
=2EOK 35...OK 36...OK .37OK .38.................OK 39..OK 40OK .41......OK =
=2E42.OK .43...OK .44OK .45..OK .46.....OK 47OK .4849.......OK .50..OK .51.=
=2EOK .52OK .53.................OK .54.OK .55....OK .56..OK .57.....OK 58..=
OK 59.OK 60.....OK 61....OK 62OK .63OK .64OK .65..........OK .66OK .67.....=
=2E...............OK .68.OK .69OK .70..OK .71....OK .72.OK .73OK .74....OK =
=2E75...OK .OK 7677OK .78OK .79...........OK .OK .8081....................O=
K 82...OK 83....OK .84..OK 85OK .86OK 87....OK 88........OK .OK 8990OK 91..=
=2EOK .92OK .93..........OK .OK 9495...................OK .96...OK 97....OK=
 .98.OK .OK 99OK 100101.....OK .102.......OK .OK 103104...OK .105.OK 106.OK=
 .107.........OK 108OK 109...................OK 110...OK .111........OK  SU=
CCESS
Bisecting: 1367 revisions left to test after this (roughly 11 steps)
[743eb868657bdb1b26c7b24077ca21c67c82c777] perf tools: Resolve machine earl=
ier and pass it to perf_event_ops
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-20:48:11 743eb868657bdb1b26c7b24077ca21c67c82c777 compiling
/home/wfg/linux

2013-01-11-20:49:37 detecting boot state 3.2.0-rc1-bisect-00131-g743eb86 #3=
 .1.2.3..45.............6....78.9...10....11..12................13...OK .14=
=2E......OK .15OK .16OK .17.OK .18OK .19...........OK ..20...OK .OK 21.OK 2=
2...OK .23...OK .24.OK .25...................OK 26OK 27........OK 28...OK 2=
9OK .OK 3031OK .32............OK .OK 3334..OK .35...OK .36OK ..37...OK .38.=
OK 39...................OK .OK 4041.......OK .42..OK .43OK .OK 4445OK .46..=
=2E......OK 47...OK .48..OK .49......OK .OK 5051.OK .52.OK 53.OK 54........=
=2E........OK .OK 5556........OK .57..OK .58.OK .59OK .60..OK .61....OK .62=
=2E..OK .63..OK .64......OK .OK 6566.OK .67OK .68OK .69.................OK =
=2EOK 7071........OK 72..OK .OK 73....OK 74...OK .75........OK 76...OK .77.=
=2EOK .78......OK .OK 7980.OK .81.OK .82OK .83.............OK .OK 8485.....=
=2E.OK .86.OK .OK .87...OK .88..OK .89........OK .90..OK .91...OK 92.......=
OK .OK 9394.OK 95.OK .96.OK .97............OK .OK 9899........OK 100101..OK=
 .102..OK .103..OK .104........OK .105..OK .106...OK .107......OK .OK 10810=
9.OK 110.OK  SUCCESS
Bisecting: 1367 revisions left to test after this (roughly 11 steps)
[00e929808a1cb410f45a620c0fc79d8d0a2506b1] Merge branch 'highbank/devel' in=
to next/devel
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-21:01:27 00e929808a1cb410f45a620c0fc79d8d0a2506b1 compiling
/home/wfg/linux

2013-01-11-21:03:02 detecting boot state 3.2.0-rc4-bisect-00016-g00e9298 #4=
 .............12.........3...4..5....6............7....8.......OK .910OK .1=
1..OK .12OK .13............OK .14OK .15...........OK .OK .16.OK 17.......OK=
 .18............OK 19....OK 20OK 2122...OK .OK 2324...OK 25.OK .26.........=
=2E..OK .OK 27.28...........OK .OK .29OK 3031......OK .32............OK .33=
=2E..OK .OK 34OK 3536..OK .37OK .38..OK .39.OK .40............OK .OK 4142..=
=2E...........OK .OK 4344OK .45........OK .46............OK .47.OK .48OK .O=
K 4950OK 5152...OK .53.OK ..54...........OK 55OK .56.............OK .OK 575=
859OK 60.........OK 61............OK .62......OK 63.OK .OK 64OK 6566...OK .=
67..OK .68........OK .69.OK .70..............OK .OK 71OK 72OK .73.....OK ..=
74..........OK .75......OK .76OK .OK 77OK 787980......OK .OK 8182........OK=
 83.....OK .84...........OK 85.OK .OK 8687.OK 88...............OK .89......=
OK 90.OK .OK 91OK 92OK 9394......OK .95...OK .96....OK .97....OK .98.......=
=2E...OK .99OK .OK .100101OK .102...............OK 103......OK .104..OK 105=
=2EOK .OK 106107OK .108.......OK .OK 109110.......OK  SUCCESS
Bisecting: 1355 revisions left to test after this (roughly 10 steps)
[25b48ff852e2e71b0d44d8ee6f69c9b704bd5070] C6X: fix timer64 initialization
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-21:15:57 25b48ff852e2e71b0d44d8ee6f69c9b704bd5070 compiling
/home/wfg/linux

2013-01-11-21:17:41 detecting boot state 3.1.0-rc9-bisect-00046-g25b48ff #5=
 1..2...............3.........4..56.............7..8.........OK .9.........=
=2EOK 10OK 1112OK .13OK .14.........OK .15............OK .16OK .OK 17OK .18=
=2E.......OK .19..OK .20.OK .21.............OK ..22........OK .OK 23OK 2425=
OK 2627......OK .28.............OK 29OK .30.OK .31..OK .32.......OK .OK .33=
34OK .35.............OK .36.........OK .37OK 3839OK 4041......OK 42........=
=2E....OK 43.OK 44.OK 45OK 46..OK .47.........OK 48.OK .49OK .50...........=
=2EOK .51.........OK 52.OK .OK 53OK 545556........OK .57........OK .58OK .5=
9OK .OK 6061..OK .62........OK .63.OK .64OK .65........OK .66............OK=
 .67..OK 68.OK 69OK .70OK .71.....OK .72........OK .73OK 74.OK .75...OK .76=
=2E..........OK 77OK 78...OK .79........OK .80.........OK .81.OK .82OK .OK =
8384.OK 85.....OK .86........OK .OK 8788.OK 89....OK .90............OK .91.=
OK .92OK .93........OK 94............OK .95OK 96.OK .97OK .OK 9899....OK 10=
0.........OK 101OK .102OK .103...OK .OK .104............OK 105..OK .106OK .=
107.......OK .108.........OK .109.OK .110..OK  SUCCESS
Bisecting: 1329 revisions left to test after this (roughly 10 steps)
[9b467e6ebebbe75288aeb7e816ffbb5d35d6eaa3] reiserfs: don't lock root inode =
searching
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-21:30:23 9b467e6ebebbe75288aeb7e816ffbb5d35d6eaa3 compiling
2013-01-11-21:31:17 9b467e6ebebbe75288aeb7e816ffbb5d35d6eaa3 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1329 revisions left to test after this (roughly 10 steps)
[79f1ddd06471b094ae30eb17b33beb9f1234ca93] x86: Use the same node_distance =
for 32 and 64-bit
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-21:31:48 79f1ddd06471b094ae30eb17b33beb9f1234ca93 compiling
/home/wfg/linux

2013-01-11-21:33:30 detecting boot state 3.2.0-rc4-bisect-00169-g79f1ddd #1=
 ....12.....3.........4..5....6..........789....10.............11OK .12..OK=
 .OK .1314OK .15....OK .16OK .17....OK .18........OK .19.OK .20...OK 21....=
=2E.....OK 22....OK .OK 23OK 24..........OK .25.....OK 26....OK .27OK .OK 2=
829......OK .30OK .31OK .32.......OK .33.OK .34..OK ..35........OK .36....O=
K .OK 373839.........OK .40.....OK .41OK .OK 4243....OK .44......OK 45....O=
K .46.OK 47....OK 48..OK 49....OK .50.............OK 51.OK .52..OK 53OK .54=
=2E....OK .55....OK .56...OK .57OK .58.OK .59.....OK .60....OK .61OK .62...=
OK .63.OK .OK .6465................OK .66.OK .67.OK 68....OK .69......OK .O=
K 7071.....OK .72OK 73....OK .74......OK 75..OK .76OK .77......OK 78..OK .O=
K 7980.............OK .OK 8182....OK 83...OK 84.......OK 85OK .86.....OK .O=
K 87.88...OK .89.....OK .90..OK .91OK .92.....OK .93..OK .OK 9495..........=
=2E..OK 96OK 97....OK 98...OK .99.......OK .100.OK .101......OK .102OK .103=
=2E..OK .104.....OK ..105.OK .106OK .107.OK .108..OK .OK 109110............=
=2EOK  SUCCESS
Bisecting: 1329 revisions left to test after this (roughly 10 steps)
[f95a34c66554235b70a681fcd9feebc195f7ec0e] dlm: move recovery barrier calls
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-21:45:25 f95a34c66554235b70a681fcd9feebc195f7ec0e compiling
/home/wfg/linux

2013-01-11-21:47:04 detecting boot state 3.1.0-bisect-00002-gf95a34c #2 ...=
=2E....1..2.......3......45......67..8.....9............1011.12......OK .13=
=2E...........OK 14......OK 15....OK 16.....OK .17..OK .OK 18......OK .OK 1=
920.......OK .21.......OK .22OK .OK 2324......OK .25...........OK .26......=
OK 27....OK .28....OK .29...OK ..30.OK .31..OK .3233...OK .34..OK 35.......=
=2E.OK .OK 36OK 3738.....OK .39............OK 40......OK 41OK 42...........=
=2E.OK .43OK .44..OK .45.OK .46..OK .OK 4748...OK .49..OK ..50...OK .OK 51O=
K 5253.....OK .54............OK .55....OK .56OK 57..............OK 58OK .59=
=2E.....OK .60.OK .61...OK .OK 62OK 63...OK .64.......OK .65OK .6667OK .68.=
=2E..........OK .69....OK .70OK 71.............OK .72OK .73......OK .74.OK =
=2E75...OK .OK 7677.OK .OK 7879........OK .80OK 8182.OK 83.............OK 8=
4.....OK 85OK 86..............OK 87.OK 88......OK .89.OK .90...OK .91OK 92.=
=2EOK .OK 9394.......OK .95OK .OK 9697OK .98........OK .99........OK 100OK =
=2E101.............OK .102OK .103......OK .104.....OK 105....OK 106OK .107.=
=2EOK 108OK 109........OK .OK 110OK 111OK  SUCCESS
Bisecting: 1327 revisions left to test after this (roughly 10 steps)
[2174f6df7891fa331800beb72634c969f017900b] pstore: gracefully handle NULL p=
store_info functions
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-21:59:29 2174f6df7891fa331800beb72634c969f017900b compiling
/home/wfg/linux

2013-01-11-22:01:20 detecting boot state 3.2.0-rc2-bisect-00003-g2174f6d #3=
 ............1..2..........3......4.5..6.7..8..........910....11......OK .O=
K 1213OK 14..............OK .15OK .16..........OK .17....OK .18.OK 19.OK .2=
0.OK .21OK .22.......OK 23.OK ..24..OK 25.....OK 26....OK 27....OK .28.....=
=2E...OK .29.....OK 30...........OK 31.....OK .OK 32OK 3334OK 35.OK .36....=
=2E......OK .37.OK 38...OK .39OK .40...OK .41...OK .42.........OK .43....OK=
 .44..........OK .45......OK 46OK 47OK .OK 48.OK .49..............OK .50.OK=
 .51.....OK .52..OK .53....OK .54.....OK .55...OK .56...........OK 57......=
OK .OK 5859OK .60.OK .61..............OK .62.OK .63....OK .OK 6465..OK .66.=
=2E..OK .67....OK .68....OK .69..........OK .70.....OK .OK 7172OK .73...OK =
=2E74.OK 75..........OK .76..OK 77.....OK .78..OK .OK .79........OK .80OK .=
81....OK .82..........OK .83.....OK .OK 8485OK .86..OK .87.OK .88..........=
OK .89..OK 90.OK .OK 9192..OK .93..OK .94........OK 95OK .96.....OK .97....=
=2E.....OK .98....OK 99OK 100OK .101....OK .102.OK .103..........OK .104.OK=
 .105OK .106OK .107..OK 108...OK  SUCCESS
Bisecting: 1327 revisions left to test after this (roughly 10 steps)
[3c8276c6bc912025db50ff7e93af6bc7c3de0c8c] arm/imx6: add imx6q sabrelite bo=
ard support
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-22:13:46 3c8276c6bc912025db50ff7e93af6bc7c3de0c8c compiling
/home/wfg/linux

2013-01-11-22:15:26 detecting boot state 3.2.0-rc5-bisect-00003-g3c8276c #4=
 1....2......3...........4..56.7.....89..............10.11.12..13..OK .14..=
=2E.OK 15....OK .16...OK .17.........OK 18.......OK 19...OK 20OK .21OK 22..=
=2E..OK .23.OK 24...........OK 25OK .26OK .27..OK .28.OK .29........OK .OK =
3031...OK .32.........OK .33......OK .34..OK .35OK .OK 3637....OK .38.OK .3=
9..............OK .40OK 41OK .42......OK 43.....OK .44...OK .OK 4546.......=
=2E....OK .47.......OK .48OK .49...OK .50OK .51.....OK .52..........OK 53OK=
 .54OK .55.....OK .56....OK .57...OK .OK 5859............OK .60.......OK .6=
1...OK .62OK .63OK 64.....OK 65..........OK .66OK .67OK 68...OK .69.OK .70.=
=2E...OK 71....OK .72.............OK ..73......OK .7475...OK .OK 76OK 7778.=
=2E...OK .79..........OK 80OK .81OK .82...OK 83..OK .84.....OK .85....OK 86=
=2E.OK .87..........OK 88........OK 89...OK 90..OK .OK 9192OK 93.......OK .=
94.....OK .95OK .96OK .97......OK .98..OK .99OK .100....OK .101..OK .102...=
=2E.....OK .103.......OK .104......OK 105OK 106OK 107108......OK .109......=
OK 110.OK 111OK .112.......OK 113...OK 114.OK  SUCCESS
Bisecting: 1324 revisions left to test after this (roughly 10 steps)
[381345652fca688aeaa967c231e5075cf68d05b6] mtd: do not use mtd->lock, unloc=
k and is_locked directly
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-22:27:50 381345652fca688aeaa967c231e5075cf68d05b6 compiling
/home/wfg/linux

2013-01-11-22:29:43 detecting boot state 3.2.0-rc7-bisect-00108-g3813456 #5=
 .1.........2........3.4.5.......6..7.8.9.......10....11.12.13.........OK .=
14.....OK .15.........OK .16.......OK 17.OK .OK 181920......OK .21.OK .22OK=
 23OK ..24......OK 25....OK .26OK .27...........OK .28.OK .29............OK=
 .30..........OK .OK 3132...OK 33.OK .34....OK 35.OK .36OK .37....OK .38...=
=2EOK .39OK 4041..........OK .42.OK .43.............OK .44..........OK 45OK=
 .46..OK .47.OK .48...OK .49.OK .50OK .51...OK .52.....OK .53..OK .54OK .55=
=2E.....OK .56.....OK .57.........OK .58.........OK .OK 5960...OK .61OK 626=
3....OK 64.OK .65OK .66....OK .67....OK .68...OK 69OK .70......OK .71.OK .7=
2.................OK .73...OK 74.....OK .75..OK .OK 7677OK .78...OK .79OK 8=
0....OK 81....OK .82.....OK .83....OK .84.OK .85..OK .86................OK =
=2E87...OK 88.....OK .89..OK .OK 9091OK .92...OK .93OK 94....OK .95...OK .9=
6.....OK .97...OK 98OK .99..OK .100.OK .101.................OK 102...OK .10=
3.........OK .104...OK .OK 105106.OK .107.OK .108.OK .109...OK .110.....OK =
111...OK .112OK .113.OK .114.OK ..115................OK  SUCCESS
Bisecting: 1300 revisions left to test after this (roughly 10 steps)
[1fc3eb81100c3f3cd44e706e54390151b0f1ce74] Merge branch 'imx/board' into ne=
xt/boards
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-22:42:26 1fc3eb81100c3f3cd44e706e54390151b0f1ce74 compiling
/home/wfg/linux

2013-01-11-22:44:08 detecting boot state 3.2.0-rc6-bisect-00178-g1fc3eb8 #6=
 .........1234...5.......67............8..9.10.11.12.............OK .13..OK=
 .14..............OK .OK 1516...OK .OK 17OK 18..OK .19......OK .OK 2021....=
=2E......OK .OK 2223.OK .24.OK .25.OK .26........OK .27..OK .28...........O=
K .29.OK .30.....OK .OK 3132..OK .33..........OK .OK 3435.......OK .36...OK=
 .37OK .OK 3839OK 40.........OK .41..OK .42.......OK .43.....OK .44.....OK =
4546..OK 47OK .48..........OK .OK 4950.......OK .51..OK .52.OK .OK 53OK .54=
55........OK .56..OK .57......OK .58......OK 59.....OK .60..OK 61.OK 62.OK =
=2E63........OK .64.OK .65........OK .OK 6667.OK .OK 6869...OK .70...OK .71=
=2E.OK ..72.....OK .73.....OK .74.....OK 75..OK .76OK .77OK .78............=
OK 79OK .80.......OK .81..OK .OK 8283...OK .84..OK ..85...OK 86...OK ..87.O=
K 88..OK .89.............OK .90..OK 91.OK .92OK .93............OK .OK 9495.=
=2E.....OK 96...OK .OK 9798...OK .99...OK .100...OK 101OK .102....OK ..103.=
=2EOK .104............OK .105.OK .106.OK .107OK .108.........OK .109.OK 110=
=2E........OK 111...OK  SUCCESS
Bisecting: 1294 revisions left to test after this (roughly 10 steps)
[c196adf87514560f867492978ae350d4bbced0bd] HID: usbkbd: synchronize LED URB=
 submission
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-22:56:17 c196adf87514560f867492978ae350d4bbced0bd compiling
/home/wfg/linux

2013-01-11-22:57:59 detecting boot state 3.1.0-bisect-08913-gc196adf #7 ..1=
2.....345.......6.............7...89.10...........11..12........OK 13...OK =
=2E14OK .15.......OK .OK .16....OK .OK 17OK ..18.....OK .19............OK .=
OK .2021...OK .22..........OK .23OK .24........OK .25.OK 26.OK 27..........=
=2EOK .28....OK .29.OK .3031...OK .32.........OK .33..OK .34OK 35....OK .36=
=2E.OK .37....OK ..38...........OK .39OK .40OK .41...........OK ..42..OK .O=
K .4344OK .45....OK .46.........OK .47..OK 48OK .49....OK .50..OK .51....OK=
 ..52...........OK .53OK .54OK .55............OK .56...OK .OK 5758OK .59...=
=2EOK ..60........OK .OK 6162OK .63.....OK .64......OK .65.OK ..66......OK =
=2EOK 6768....OK .69..............OK .OK 707172OK .73..OK .74....OK ..75...=
=2E....OK .OK 7677OK .78.....OK .79......OK .80..OK .81......OK .OK 8283...=
OK .84............OK .85.OK .8687.OK .88.OK .89......OK .90........OK .OK 9=
1OK 92.93.OK .94......OK .95......OK 96.......OK .9798...OK .99............=
OK .100OK .OK .101102OK .103.OK .104......OK .105........OK .OK 106OK 107OK=
 108109.OK .110..............OK .111...OK .112..OK .OK  SUCCESS
Bisecting: 1284 revisions left to test after this (roughly 10 steps)
[55ba70c40661b61f98c4188c428f265009af1aa5] drm/radeon: use after free in ra=
deon_vm_bo_add()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-23:10:47 55ba70c40661b61f98c4188c428f265009af1aa5 compiling
/home/wfg/linux

2013-01-11-23:12:23 detecting boot state 3.2.0-rc6-bisect-00363-g55ba70c #8=
 ......1....2..3..4......5.......6.....7...8.9.1011................12...OK =
=2E13....OK ..14.....OK .15...OK .16.OK 17..OK .18......OK .19.....OK .20..=
=2E.OK .21OK .22OK 23...OK .OK 2425..............OK .26....OK 27.....OK ..2=
8.....OK .29.OK .30OK .31....OK .32.OK ..33.........OK .34...OK .35.OK .OK =
3637...OK .OK 3839..............OK ..OK 4041.........OK .OK .42.....OK 43..=
OK .44OK .45....OK 46..OK ..47.........OK 48OK 49.....OK .50OK 51...OK .OK =
=2E5253..............OK .OK 54.55.........OK .OK .5657..OK .OK .5859...OK .=
60...OK .6162............OK .OK 63.OK 64.65...OK .66....OK .6768..........O=
K .69....OK 70...........OK .OK 71OK 7273.OK .74....OK .75....OK .OK .76...=
=2E........OK .77OK 78OK ..79..OK .80.....OK ..81..........OK .82...OK .83.=
=2E......OK .84OK .OK .85OK 86.87......OK .88....OK .OK .8990.......OK 91..=
=2E.OK .92OK .93...OK .94.....OK .95..........OK .96....OK 97........OK .98=
=2EOK .OK 99100OK .101......OK .102.....OK .OK .103104......OK .105..OK .10=
6OK .107.OK .108.....OK .109..OK ..110........OK .111....OK  SUCCESS
Bisecting: 1265 revisions left to test after this (roughly 10 steps)
[7239f65cf364180cdb100a4ed211b2a9f9a72119] clockevents: remove sysdev.h
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-23:25:15 7239f65cf364180cdb100a4ed211b2a9f9a72119 compiling
/home/wfg/linux

2013-01-11-23:26:59 detecting boot state 3.2.0-rc1-bisect-00066-g7239f65 #9=
 .1..2.3.4..5............678..........91011.....12..13..........14......15.=
=2E.........OK .16.OK .OK 1718.OK 19..OK .20...........OK .OK 21.22......OK=
 .23.OK .OK .2425...OK ..26OK .27..........OK .28....OK .29...........OK .3=
0.OK .OK 31.32OK .33..OK .34...........OK 35OK .OK .36......OK .37..OK .OK =
3839...OK .40.OK .41........OK .42OK .43.............OK .44.....OK .OK 4546=
=2EOK .47..OK .48..........OK .49OK .OK .50.....OK ..51OK .OK 52OK .5354...=
=2E.OK .55OK .56.....OK .57.................OK 58.OK .59....OK .60.OK .61.O=
K .62...........OK .63OK .OK .64....OK .65OK 66..OK .OK .6768...OK .69OK .7=
0.......OK .71...............OK .OK 7273.OK .74..OK .OK 7576...............=
=2E..OK .77OK .OK 78.79..OK .80OK .81...OK .OK 8283...OK .84OK .85.......OK=
 .86........OK .87.....OK 88...OK .89..OK .OK 9091..................OK .92O=
K .OK 9394...OK .95OK .96..OK .97OK .OK 98OK 99.100...........OK .101......=
=2E.OK .102OK .103...OK .104.....OK .105OK .106.................OK .107.OK =
108OK .109...OK .110OK .111..OK  SUCCESS
Bisecting: 1265 revisions left to test after this (roughly 10 steps)
[176f950d310c81b7fafd96aabe53704f778ce269] ixgbe: add write flush in ixgbe_=
clock_out_i2c_byte()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-23:39:18 176f950d310c81b7fafd96aabe53704f778ce269 compiling
/home/wfg/linux

2013-01-11-23:41:00 detecting boot state 3.2.0-rc7-bisect-01749-g176f950 #1=
0 ...........1.........2.3.....45....6...........7.......8..9......OK 1011.=
=2EOK .OK 1213OK .14OK .15............OK .16........OK ..OK 1718....OK .19.=
=2E..OK .20..........OK .21......OK .22OK .23.....OK .24OK .2526..OK .27OK =
=2E28OK .29...........OK .30..........OK .OK 3132....OK .33...OK .34.......=
=2E...OK 35......OK .36.OK .OK 3738....OK .39OK ..40OK .41OK .42..OK 43....=
=2E.......OK .44......OK 45...OK .OK 4647...OK .48OK .49..............OK .5=
0.......OK .51OK .OK 5253...OK .54..OK .OK 5556OK .57..OK .58...........OK =
=2E59......OK .6061..OK .62....OK .63OK .64.............OK ..65......OK .66=
OK .67.....OK .68.OK .69OK 7071...OK ..72...........OK ..73.....OK .OK 7475=
=2E.OK .76..OK 77.OK .78................OK .79......OK .80OK 8182OK .83...O=
K .84OK .85OK .86OK .87.................OK .88.....OK .OK .8990.OK .91.OK .=
=2E92OK .93...............OK .94.......OK .OK 95OK .96OK .97..OK .98.OK .99=
OK 100101..................OK .102......OK .OK 103104..OK .105.OK .106OK .1=
07................OK .108.....OK .109OK .OK 110.111OK .112.OK .OK  SUCCESS
Bisecting: 1223 revisions left to test after this (roughly 10 steps)
[681d0378a9057a92b9e6e51c2112e53d920a092d] drivers/rtc/rtc-jz4740.c: make j=
z4740_rtc_driver static
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-23:53:50 681d0378a9057a92b9e6e51c2112e53d920a092d compiling
2013-01-11-23:54:40 681d0378a9057a92b9e6e51c2112e53d920a092d SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1223 revisions left to test after this (roughly 10 steps)
[97607d157c133ab18dfcd77fa836e37fa950a44a] pinctrl: make a copy of pinmux m=
ap
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-11-23:55:05 97607d157c133ab18dfcd77fa836e37fa950a44a compiling
/home/wfg/linux

2013-01-11-23:56:44 detecting boot state 3.2.0-rc3-bisect-00014-g97607d1 #1=
 ......1..2..3.4..56...................7....8..9....1011...12............OK=
 .13..OK .14.OK .15.....OK .16.OK .17.OK .18OK .19.OK 20OK .21.............=
=2E....OK .22...OK .23.OK .24OK .25.OK .26...OK .27............OK 28...OK .=
29.OK 30.....OK .OK 3132....OK .33OK ..OK 3435....................OK .36...=
OK .37.OK .38OK .39.OK .40...OK .41...........OK ..42....OK .43.....OK .OK =
44.45..OK .46..OK .OK .4748...................OK .49..OK .50OK .OK 5152OK .=
53...OK .54...............OK .55....OK .56......OK .OK 57OK 5859..OK .60..O=
K .OK 6162...................OK .63...OK .OK 6465OK 66OK .67...OK .68......=
=2E....OK ..69..OK 70.....OK .71.....OK .72OK .7374..OK ..75..OK .76.......=
=2E..........OK .77...OK .78OK .OK 7980OK .81...OK .82............OK .83.OK=
 .84.....OK .85.....OK .OK 8687OK .88...OK .89.OK ..90..................OK =
=2E91...OK .OK .OK 92939495....OK .96.......OK .97......OK .98....OK .99...=
OK .100OK .101.OK .102...OK ..103.OK .104..................OK .105.....OK .=
OK .OK 106.107...OK .108.......OK .109......OK .110....OK .111...OK .OK  SU=
CCESS
Bisecting: 1209 revisions left to test after this (roughly 10 steps)
[0ad5a81472a9d6a0e826e0c6ebe66d3792932a93] imx: Add save/restore functions =
for UART control regs
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-00:09:56 0ad5a81472a9d6a0e826e0c6ebe66d3792932a93 compiling
/home/wfg/linux

2013-01-12-00:10:59 detecting boot state 3.2.0-rc3-bisect-00064-g0ad5a81 #2=
 .....1.......2....3...4.5.6........7..8..................9......OK .OK .OK=
 10OK 1112...OK .13....OK .14......OK .15.......OK .16..OK .17OK .18OK .19.=
=2E.....OK ..20OK .21.................OK .22.......OK 23OK .OK 2425...OK .2=
6....OK .27......OK .28.....OK .OK 2930...OK .31..OK .32.......OK .OK .OK 3=
334..................OK .35......OK .OK 3637OK ..38.OK ..39...OK .40..OK .4=
1.....OK ..OK 4243......OK ..44.......OK .45...OK .OK 4647.................=
OK .48......OK .49OK .50OK .5152.OK .53...OK ..54..OK .55......OK .5657....=
=2E.OK ..58.......OK 59...OK .OK ..60.........OK .61......OK .62.......OK .=
63.OK .6465.OK .66...OK .67...OK .68......OK .69....OK .7071.........OK .72=
=2E...OK .OK 7374........OK .75......OK .76......OK .77OK .78.OK .79.OK .80=
=2E...OK .81..OK .82......OK .OK .83OK .84..OK .85.........OK .86..OK .87.O=
K .88.OK .89..............OK .90......OK .OK 9192..OK .93OK .94....OK .95..=
=2EOK .96.......OK .97OK 9899..OK .100.....OK ..101.....OK .102.OK .103.OK =
=2E104.............OK .105......OK .106OK ..107.OK 108.OK .109OK  SUCCESS
Bisecting: 1165 revisions left to test after this (roughly 10 steps)
[cb69f7decc3777822b240c46890a209df288c7bb] [SCSI] lpfc 8.3.28: Add support =
for ABTS failure handling
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-00:24:03 cb69f7decc3777822b240c46890a209df288c7bb compiling
/home/wfg/linux

2013-01-12-00:25:31 detecting boot state 3.2.0-rc5-bisect-00084-gcb69f7d #3=
 1.2.3.........4.....5...6...7....89.......10..11.................12.OK .13=
=2E..OK .14...OK .15.OK .16OK .17........OK .18....OK .19..OK .20..OK .21..=
=2EOK .OK 22.23.OK .24.....OK .25.............OK .26.....OK .27...OK .OK .2=
8.....OK .29OK .30.......OK .31.....OK .32..OK ..33.....OK .34OK .35..OK .3=
6.....OK .37.........OK .38........OK .39....OK .4041....OK .42.OK .43..OK =
=2E44.........OK .45...OK .OK .4647.OK ..OK 4849OK .50.....OK .51..........=
=2E..OK .52.....OK .53........OK .5455....OK 56.OK .57...OK .58.........OK =
=2E59....OK .6061.OK .62OK .63OK .64....OK .65..............OK 66..OK .67..=
=2E.....OK .68..OK .69....OK .70OK ..71..OK .72.........OK .73.OK .74...OK =
=2E7576OK .OK 7778.OK .79OK .80.............OK .81.....OK .82........OK .83=
=2E..OK .84...OK .85.OK .86...OK .87.....OK .88.OK .89.......OK .90OK 9192O=
K .93..OK ..OK 9495............OK .96.....OK .97........OK .98...OK .99...O=
K .100.OK .101...OK .102.....OK .103.OK .104......OK .OK 105.OK 106107.....=
OK 108OK .109............OK .110.....OK .111.........OK .112113.......OK ..=
OK 114115...OK .116.....OK  SUCCESS
Bisecting: 1181 revisions left to test after this (roughly 10 steps)
[ea5768c74b8e0d6a866508fc6399d5ff958da5e3] mm/hugetlb.c: avoid bogus counte=
r of surplus huge page
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-00:38:59 ea5768c74b8e0d6a866508fc6399d5ff958da5e3 compiling
2013-01-12-00:39:44 ea5768c74b8e0d6a866508fc6399d5ff958da5e3 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1181 revisions left to test after this (roughly 10 steps)
[1a2d9156b5fc92b40aa2ffbc2fdf6d88bbf74f3a] ARM: at91: gpio make struct at91=
_gpio_bank an initdata
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-00:40:01 1a2d9156b5fc92b40aa2ffbc2fdf6d88bbf74f3a compiling
/home/wfg/linux

2013-01-12-00:41:28 detecting boot state 3.2.0-rc3-bisect-00021-g1a2d915 #1=
 ......1..2.........34.5..6......7..........8910...1112................OK .=
13.OK .14..........OK .15..OK 16........OK .OK 17OK 1819..OK .20......OK .2=
1......OK .22OK .23OK .OK 2425..OK 26OK .27................OK 28..OK .29...=
=2E......OK 30..OK .31........OK .OK 32OK .33..OK .34......OK .35..........=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E............OK ..3637...................................................=
=2E.................OK .38.OK .OK .OK 394041OK 42.4344.....................=
=2E......................................OK 45.OK 46.......................=
=2E....................................OK .47...........OK 48.4950.........=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E...OK .51...............................................................=
=2E........................................................................=
=2EOK ..52.................................................................=
=2E........OK .OK .5354OK 55..56...........................................=
=2E........................OK .57OK .OK .OK 585960OK .OK 616263.OK 64......=
=2E.........................................................OK .65.OK .OK .=
OK 66OK 6768OK .OK 69OK 7071OK .72.........................................=
=2E..............OK 73......OK .74OK .OK 7576OK .OK 77OK 7879OK .OK 8081OK =
8283........................................................OK .8485...OK .=
86OK .OK 87OK .88OK 89OK 90OK .OK 91OK 9293OK .94OK .9596..................=
=2E....................................OK .OK 9798..OK .99OK .OK 100OK 101O=
K 102103OK .104OK 105OK .OK 106107OK .OK 108.OK 109110.....................=
=2E.............................OK 111...OK .OK 112113OK .OK 114OK 115116OK=
 117118OK .OK  SUCCESS
Bisecting: 1164 revisions left to test after this (roughly 10 steps)
[f812f0f53e5643c06b929ce3299cbaffb307c488] pinctrl: u300-pinmux: register p=
roper GPIO ranges
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-01:21:10 f812f0f53e5643c06b929ce3299cbaffb307c488 compiling
/home/wfg/linux

2013-01-12-01:22:00 detecting boot state 3.2.0-rc3-bisect-00018-gf812f0f #2=
 ............1...2....3.4.5..678..9..10.11.1213..14........................=
=2E..................OK .15...OK .16..OK ..OK 1718OK .19.OK .OK .20OK .21.O=
K .22OK .OK 23OK .24OK 2526............................................OK .=
27.OK ..28.......OK .29OK .30OK .31.OK .OK .OK .3233OK .34.OK .OK 35OK .OK =
36OK .373839..........................................OK .40.OK .41........=
OK .42OK .43OK .44...OK .OK .45OK 4647.OK .OK 48OK 49.OK 50.OK .5152.......=
=2E................................OK .53..OK .54........OK 55OK .56OK .57.=
=2E..OK .OK .OK 585960OK .OK 6162OK .63.OK .OK .6465.......................=
=2E................OK 66..OK .67........OK .68OK .69OK .70..OK .71OK .72OK =
=2EOK .73OK 74OK .75OK 76.77OK ..OK 78.79..................................=
=2E...OK .80..OK .81........OK .82OK .83....OK .84OK .85.OK .OK 86OK 8788OK=
 .89OK .OK .90OK 9192........................................OK 93...OK .94=
OK .95...OK .96.OK .97......OK .98OK .99.OK .OK .OK 100101OK 102103.OK .OK =
=2EOK .104105106.....................................OK .107...OK .OK 10810=
9....OK .110OK .111.......OK  SUCCESS
Bisecting: 1160 revisions left to test after this (roughly 10 steps)
[1415dd8705394399d59a3df1ab48d149e1e41e77] ext3: Fix error handling on inod=
e bitmap corruption
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-01:35:47 1415dd8705394399d59a3df1ab48d149e1e41e77 compiling
/home/wfg/linux

2013-01-12-01:37:16 detecting boot state 3.2.0-rc1-bisect-00095-g1415dd8 #3=
 ...1......23.45.67.8.910...............................11....12...13....OK=
 .14OK ..15......OK .16......OK ..OK 17.OK 18OK 19OK .2021OK .22OK ..23....=
=2E........................OK .24....OK .25.OK .26.....OK .27.OK .28......O=
K .29......OK .OK 3031OK .OK 3233.OK .34OK .OK 3536...OK .OK ..37..........=
=2E........OK ..38.......OK ..39...OK .40.....OK .41......OK .42...OK 43...=
OK .44OK .45OK 46....OK .OK 4748...........................................=
=2E..................................................................OK .49=
50.........................................................................=
=2E......OK .OK ..515253...................................................=
=2E.....................OK .OK 54OK 5556OK .57OK 5859......................=
=2E....................................OK .60OK 61OK 62OK 63.OK 64OK .OK 65=
OK .66OK .OK 6768..........................................................=
=2E..............................OK ....6970...............................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E.........................................................OK .OK ....71..=
=2E........................................................................=
=2EOK .OK .72.OK .OK ....737475............................................=
=2E...................OK .7677.OK 78..OK .OK ..79OK 80OK 81..8283..........=
=2E.................................................OK .OK .84OK 8586OK .87=
=2E.OK .88OK .89OK .OK 90OK .OK .9192OK .OK .93............................=
=2E....................OK .94.OK .95....OK .9697...OK .98OK .99OK .100OK .O=
K .OK 101102103OK .104................................................OK .1=
05106.OK .107OK .108..OK .109....OK ..OK 110111...OK .OK .OK .112OK 113.114=
115..............................................OK  SUCCESS
Bisecting: 1155 revisions left to test after this (roughly 10 steps)
[8e609d5e7bc032ab220d47c841c992bd8544d0e1] powerpc/pmac: Simplify old pmac =
PIC interrupt handling
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-02:13:25 8e609d5e7bc032ab220d47c841c992bd8544d0e1 compiling
/home/wfg/linux

2013-01-12-02:14:54 detecting boot state 3.2.0-rc3-bisect-00153-g8e609d5 #4=
 .1....234.........................................5.......................=
=2E........................................................................=
=2E..............................................................OK .67....=
=2E.................................................................OK .OK =
89OK .OK ..10OK .OK ......11.121314........................................=
=2E...............OK .OK 1516......OK ..17.....OK 1819.OK .OK .2021........=
=2E.............................................OK .OK 2223..OK .24.....OK =
=2E25..OK .OK 26OK 27........................OK 28.........................=
=2E..............................................OK .2930..................=
=2E.....................................................OK .OK ..3132......=
=2E........................................................................=
=2EOK ...333435............................................................=
=2E.........OK .36.OK .OK .OK 373839.......................................=
=2E...........................OK .40..OK .OK ...41.424344..................=
=2E.............................................OK .45....OK .46OK 47......=
=2E........................................................................=
=2E...............................OK 484950................................=
=2E........................................OK .OK 51OK 52.5354.............=
=2E..........................................................OK 5556OK .OK =
=2EOK 57585960.............................................................=
=2E.OK ..61.OK ..62.OK ..63.OK .OK .6465...................................=
=2E......................OK .66..OK .OK 6768.OK .69OK 70.OK .OK 71OK 72..OK=
 .73...........................................................OK .74..OK .=
75...OK .76OK .77OK ..7879OK ..80..........................................=
=2E...............OK .8182.OK ..8384OK 85OK .OK 86.87.OK .OK .88.OK .8990..=
=2E..................................................OK .91..OK 92OK 93...O=
K 9495OK .96OK .OK 97OK 9899.OK .100.......................................=
=2E..........OK 101......OK .OK 102103...OK .OK 104105OK .106OK .OK 107.OK =
=2EOK 108109..OK ..110................................................OK .1=
11...OK .112OK .113....OK .114OK 115.OK 116.OK .117OK .OK  SUCCESS
Bisecting: 1070 revisions left to test after this (roughly 10 steps)
[db0c2bf69aa095d4a6de7b1145f29fe9a7c0f6a3] Merge branch 'for-3.3' of git://=
git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-02:52:21 db0c2bf69aa095d4a6de7b1145f29fe9a7c0f6a3 compiling
2013-01-12-02:53:07 db0c2bf69aa095d4a6de7b1145f29fe9a7c0f6a3 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1070 revisions left to test after this (roughly 10 steps)
[1ba37268cd19e5a2a80924bfe8618bf1ba3e8249] jbd2: clear revoked flag on buff=
ers before a new transaction started
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-02:53:28 1ba37268cd19e5a2a80924bfe8618bf1ba3e8249 compiling
/home/wfg/linux

2013-01-12-02:55:00 detecting boot state 3.2.0-rc6-bisect-00009-g1ba3726 #1=
 ..1.....2....3.4.5.6.7.....8..............................................=
=2E....OK .9...OK ..10...OK .OK 11OK 1213OK .OK 1415.OK 16.OK .17..OK 18...=
=2E................................................OK .19....OK .OK .2021OK=
 2223OK .OK .24OK 2526..OK .27OK .28..OK .29...............................=
=2E...................OK .30OK .31.OK .32OK .OK 33OK 34OK 3536.OK .37OK .38=
OK .39......OK .40...................................................OK .OK=
 41OK 4243..OK .OK 44OK .OK .OK 45.46OK 47OK 484950.......OK .51...........=
=2E.......................................OK .52OK .OK 5354.OK .55....OK .O=
K .OK 56OK 57OK 585960..OK .61.............................................=
=2E........OK .OK 6263OK .64..OK .65...OK .66OK 67OK 6869OK .OK 707172.....=
=2E..................................................OK .OK 73OK .74OK 7576=
=2EOK .77..OK .OK 78OK .OK 798081.OK .OK 82OK ..83.........................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E.....................OK .OK ............................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E...........8485.........................................................=
=2E..............OK .86.OK .OK 87OK 8889.OK .9091..........................=
=2E......................................OK .OK 92.93OK .OK .OK .9495OK .OK=
 .9697.................................................................OK .=
98OK .OK 99100OK .OK .OK 101102OK .OK .103104..............................=
=2E............................OK .OK 105106.OK .107.OK .OK  SUCCESS
Bisecting: 1083 revisions left to test after this (roughly 10 steps)
[ac69e0928054ff29a5049902fb477f9c7605c773] Merge branch 'for_linus' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-03:28:05 ac69e0928054ff29a5049902fb477f9c7605c773 compiling
2013-01-12-03:28:49 ac69e0928054ff29a5049902fb477f9c7605c773 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1083 revisions left to test after this (roughly 10 steps)
[0f5a2601284237e2ba089389fd75d67f77626cef] perf: Avoid a useless pmu_disabl=
e() in the perf-tick
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-03:28:59 0f5a2601284237e2ba089389fd75d67f77626cef compiling
/home/wfg/linux

2013-01-12-03:30:29 detecting boot state 3.2.0-rc1-bisect-00384-g0f5a260 #1=
 .........................OK 1OK .2........OK .OK 3OK 45.OK .6.OK 7OK .OK 8=
OK 910.................................................OK .11OK 12.........=
=2EOK .13OK .14OK .OK .15OK .16.OK .OK 1718OK .OK 1920.....................=
=2E..........................OK .21OK ..22.......OK .23OK .OK 2425..OK .26O=
K .27OK ..OK 28OK .29OK .30................................................=
OK .31.OK .32.......OK 33.OK 34OK .35.OK .36OK 37OK 38..OK .39OK .40OK 41..=
=2E..........................................OK 42..OK .43..OK .44.....OK .=
OK 45OK 46OK 47OK .48...OK .OK 4950....OK 51OK .52.........................=
=2E..................OK .53.OK .5455.........OK .OK 56OK .57OK 58OK ..5960O=
K .61....OK .62OK .63...........................................OK .OK .64.=
OK .65..........OK .66OK 67OK .68OK .OK .OK 69OK 7071....OK .72.OK 73......=
=2E.....................................OK .7475.OK 76..........OK .77OK .O=
K 78OK 79OK 80OK 81OK 8283....OK .84OK 85..................................=
=2E........OK .86.OK .87..OK .88.........OK .89OK .OK 90OK .OK 9192OK .93..=
OK .94OK .95............................................OK  SUCCESS
Bisecting: 1061 revisions left to test after this (roughly 10 steps)
[75072323a2968c1bd1b74a48ebf5a5d7e5e10183] Input: ucb1400_ts - drop inline =
annotations
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-03:45:28 75072323a2968c1bd1b74a48ebf5a5d7e5e10183 compiling
/home/wfg/linux

2013-01-12-03:46:53 detecting boot state 3.2.0-rc3-bisect-00062-g7507232 #2=
 ......1.2................34.5.6789..10..11................................=
=2E......OK .OK 12OK 1314...............OK 15..OK .16OK .17...OK 18OK 19OK =
2021....OK .22...................................OK .23.OK .24OK .25.......=
=2E..OK .26......OK 27.OK .28..OK .OK 29OK 30OK .3132...OK .33.............=
=2E......................OK .34OK .35.....OK 36.......OK .37.....OK .38OK .=
39...OK .OK 4041OK .OK 4243....................................OK .44.OK 45=
=2E....OK .46..........OK .47.....OK .48OK .49OK 50...OK .OK 5152OK .5354..=
=2E.........................OK .55........OK .56....OK ..57..........OK .58=
=2E....OK .59OK 60OK .6162..OK .OK .63OK 64.65............................O=
K .66........OK 67.....OK .68..........OK .69......OK .OK 7071OK .72....OK =
=2EOK 7374OK 7576.......................OK .77........OK .78.OK 79.........=
=2E........OK 80..OK .8182OK .83OK .84..OK .85.OK .86OK .87OK 88...........=
=2E...........OK .89....OK 90.....OK .91...................OK .OK .92.OK .O=
K .93..OK .9495OK .96..OK .97OK .98.......................OK .OK 99100.....=
=2E..........................................OK ...........................=
=2E..............................................................OK 101102.=
=2E................................................................OK .103.=
=2E........................................................................=
=2E.....................................................OK .OK ............=
=2E..................104...................................................=
=2E........................................................................=
=2E........................................................................=
=2E.........OK .105........................................................=
=2E............OK ..106107OK 108OK ..109...................................=
=2E........................................................OK ..110........=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E...................OK .111..............................................=
=2E.........................OK .112.OK .OK .OK  SUCCESS
Bisecting: 1038 revisions left to test after this (roughly 10 steps)
[993ecff81aa6d50d694704de2647a5529ff2f166] Merge branch 'for-linus' of git:=
//oss.sgi.com/xfs/xfs
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-04:30:11 993ecff81aa6d50d694704de2647a5529ff2f166 compiling
2013-01-12-04:30:54 993ecff81aa6d50d694704de2647a5529ff2f166 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1038 revisions left to test after this (roughly 10 steps)
[272f01bf9b6da93f49fcca2656c24da8d2cfcc09] [S390] irq: fix accounting of ex=
ternal call/emergency signal
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-04:31:04 272f01bf9b6da93f49fcca2656c24da8d2cfcc09 compiling
/home/wfg/linux

2013-01-12-04:32:34 detecting boot state 3.2.0-rc7-bisect-00018-g272f01b #1=
 .........................1.........2....345.6789..........................=
=2E...........................OK .10OK .11........OK .12.OK .OK 13OK 14OK 1=
516OK 17OK .1819.....................................................OK .20=
=2EOK .21........OK .22..OK .OK 23OK 24OK 2526OK .OK ..2728................=
=2E................................OK .29OK .30..........OK .31.OK .OK 32OK=
 33OK 34OK 35OK .OK 363738OK .3940.........................................=
=2E......OK ..OK 4142..........OK .43.OK .OK 44OK 45OK 46OK 47OK .OK 4849OK=
 .OK 5051..................................................OK 52OK .53.....=
=2EOK .54.....OK .55OK .OK 56OK 5758OK .OK 5960OK .OK .61..................=
=2E..............................OK .OK 6263.......OK 64..OK .65....OK 66OK=
 .OK 67OK 6869OK .70OK .OK 7172............................................=
=2E...OK .73OK .74......OK .75..OK .76...OK .77OK .OK 78OK .79OK 8081OK 82O=
K .83................................................OK .84OK 85.......OK .=
86.......OK .87OK .88OK .OK 89OK .OK 90.OK 9192..OK .93....................=
=2E...................OK .94....OK 95OK .96..............OK .97OK .98OK .99=
OK 100.OK .OK 101102..OK .103...................................OK .104....=
=2E.OK .105OK .106OK .107.......OK  SUCCESS
Bisecting: 1038 revisions left to test after this (roughly 10 steps)
[134d33737f9015761c3832f6b268fae6274aac7f] cgroup: improve old cgroup handl=
ing in cgroup_attach_proc()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-04:49:40 134d33737f9015761c3832f6b268fae6274aac7f compiling
/home/wfg/linux

2013-01-12-04:51:06 detecting boot state 3.2.0-rc2-bisect-00481-g134d337 #2=
 ..1.........2..3.4.5.6.7..................................8..........OK .O=
K 910OK .11.OK .12............OK 1314.OK .15OK .OK 16OK 1718..OK .19.......=
=2E.........................OK .20......OK .OK 2122OK .23.....OK .24.......=
=2E.OK .25OK .OK 2627.OK .28OK .29OK .30.OK .31............................=
=2E.....OK .32......OK .OK 33OK 3435.OK .36.............OK .OK 37.OK .38...=
=2EOK .39OK .40.OK .41..........................OK .42......OK .43......OK =
=2E44OK .45.OK .46.........OK .47OK .OK 4849.OK .50OK .51OK .52.OK .53.....=
=2E....................OK .54...........OK .55......OK .OK 5657.OK ..58....=
=2E....OK 59.OK .OK 6061OK .OK 6263OK .64OK .65............................=
=2EOK .66..........OK .67....OK .68.OK 69....OK .70........OK .71.OK .OK 72=
73OK .74.OK 75.OK .76.............................OK 77...........OK .78...=
=2EOK 79.OK .80....OK .81..........................................OK .....=
=2E...........................................................82OK 83OK .84=
85.......................................................................OK=
 .OK 86OK 87OK 888990......................................................=
=2E.........OK 91.OK .OK 92OK 93OK .94OK 95OK 96OK 979899..................=
=2E...................................................................OK ..=
100........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E......................OK .101...........................................=
=2E.....................................................OK ................=
=2E........................................................................=
=2E........................................................................=
=2E.................................................102103.................=
=2E......................................................OK .104..OK .OK 10=
5106.......................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E..................................................................OK ...=
107108.....................................................................=
=2E........................................................................=
=2E.........................................................OK ....109.....=
=2E...................................................................OK .1=
10.OK .OK .111112113OK  SUCCESS
Bisecting: 1016 revisions left to test after this (roughly 10 steps)
[fe5d3e887e3f9d0a97e5b8df968ab84a12128495] Merge branch 'prcm' of git://git=
=2Ekernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into omap/prcm
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-05:38:56 fe5d3e887e3f9d0a97e5b8df968ab84a12128495 compiling
/home/wfg/linux

2013-01-12-05:40:25 detecting boot state 3.2.0-rc4-bisect-00120-gfe5d3e8 #3=
 1234............................................................OK .5OK .6=
=2E....OK .OK 78OK .9OK ..OK 101112........................................=
=2E..............OK .OK 1314......OK .15.OK .16OK .17OK .18.OK .OK 19OK 202=
1......................................................OK .22OK .23......OK=
 24.OK .OK 25OK 2627OK .OK ..28OK .OK .2930................................=
=2E.................OK .31OK .32......OK .33OK 34....OK 35OK .3637.OK .OK .=
38OK .OK .3940................................................OK .41OK .42.=
=2E.OK 43OK .44...OK .45.OK 46..OK .47..OK .OK 4849OK .50OK 51.............=
=2E...................................OK .52OK .OK 5354OK .OK 5556.......OK=
 ..57.OK .OK 5859OK .OK .606162OK 63.......................................=
=2E......OK .64OK .65....OK 66OK .67OK .68.......OK .69.OK .OK 7071.OK .OK =
72OK .73OK 74..........................................OK .75OK .76....OK .=
77.OK .78.OK .79........OK .80.OK .OK 8182OK .83OK .OK .OK 8485............=
=2E............................OK .86OK .87....OK .OK 88.OK 89............O=
K .OK .9091.OK .92OK .93OK 9495..........................................OK=
 .96.OK .97....OK 9899OK .100.........OK .101..OK .102..OK .103OK  SUCCESS
Bisecting: 1007 revisions left to test after this (roughly 10 steps)
[e3a41a5ba9c2ab988b9f1442925109dca2382fd9] btrfs: pass __GFP_WRITE for buff=
ered write page allocations
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-05:56:51 e3a41a5ba9c2ab988b9f1442925109dca2382fd9 compiling
2013-01-12-05:57:36 e3a41a5ba9c2ab988b9f1442925109dca2382fd9 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 1007 revisions left to test after this (roughly 10 steps)
[19c5246d251640ac76daa4d34165af78c64b1454] ext4: add new online resize inte=
rface
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-05:57:48 19c5246d251640ac76daa4d34165af78c64b1454 compiling
/home/wfg/linux

2013-01-12-05:59:19 detecting boot state 3.2.0-rc6-bisect-00023-g19c5246 #1=
 ...1.2.3..4.........5.......6.789...10....................................=
=2EOK 1112OK 13...OK .14.....OK .15.......OK .16......OK 17OK .18OK .OK 192=
0..OK .21.................................OK .22OK .23OK .24OK .25.....OK .=
26...........OK .27...OK ..28OK 29OK .30OK 3132...OK ..33..................=
=2E.............OK .34OK .35OK .36OK .37.....OK .38............OK 39....OK =
=2EOK 4041OK .42.OK 43....OK .44............................OK .45OK .46OK =
=2E47OK .48.OK .49....................OK .50.OK .51.OK .OK 5253OK .54.....O=
K .55..........................OK .56OK .57OK .58.....OK .59...............=
=2E....OK .60.OK .61OK .OK .OK 626364.......OK .65......................OK =
=2E66OK .67OK .68.........OK .69....................OK 70..OK 71.OK .OK 72O=
K 73OK .74.......OK 75..................OK .76OK .OK 77OK 7879..........OK =
=2E80......................OK .OK 8182.OK .OK 8384OK .OK 8586........OK .87=
=2E.............OK .88OK .89...OK 90OK .91.....OK .92......................=
=2E.OK .93.OK .OK 9495OK 96OK .97..OK .98.......OK .99..............OK .100=
=2EOK .OK .101102.........OK 103........................OK .OK 104OK 105OK =
106107..OK .OK .108...........OK .109..........OK  SUCCESS
Bisecting: 995 revisions left to test after this (roughly 10 steps)
[4f89b336fd1edf0c88875d0b7fcdc288c7de903d] rcu: Apply ACCESS_ONCE() to rcu_=
boost() return value
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-06:15:02 4f89b336fd1edf0c88875d0b7fcdc288c7de903d compiling
/home/wfg/linux

2013-01-12-06:16:28 detecting boot state 3.2.0-rc5-bisect-00063-g4f89b33 #2=
 ..........................................................................=
=2E..........................1..................23.........................=
=2E.............................................OK .OK 45OK 6OK .OK 78.....=
=2E........................................................................=
=2E........................................................................=
=2E............................................OK 910......................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E.........................OK ............................................=
=2E..............................11........................................=
=2E............................OK ..12.OK .1314............................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E....................OK ..15.............................................=
=2E........................................................OK ......161718.=
=2E.......................................................................O=
K .1920....................................................................=
=2E.....................OK .2122...........................................=
=2E..........................OK 23..OK .24..OK .OK ....252627..............=
=2E...........................................OK .28......OK .2930.....OK .=
OK 31OK 3233....................................................OK .34.....=
=2EOK .35..OK .36..OK .37..OK .OK .3839....................................=
=2E.............OK .40......OK .41..OK .42..OK .43..OK .44..OK .454647.....=
=2E.......................................OK .48..........OK .49...OK .5051=
=2EOK .52..OK 53...OK .OK .OK 545556.......................................=
=2E....OK .57......OK .58...OK .59..OK .60.OK .61...OK .62...OK .OK ..6364.=
=2E.....................................OK .65......OK .66.OK .67.......OK =
68OK 6970......OK .71.....OK .OK 727374.................................OK =
=2E75...........OK .76.OK 77.......OK 78OK .7980.....OK .81...OK .82OK .83O=
K .8485.............................OK 86..........OK .87...OK .88.....OK .=
OK 8990...OK .91..OK .92...OK .93....OK .94OK .OK ..95.....................=
=2E.OK .96.............OK .97OK 98.........OK .99OK .100...OK .101.OK .OK 1=
02103........OK .104..OK .105106......................OK .107.............O=
K .OK 108109.......OK .110OK .111.....OK .112.OK .OK 113114........OK .115.=
=2EOK .OK ..116.................OK  SUCCESS
Bisecting: 976 revisions left to test after this (roughly 10 steps)
[2b5e97e1fadf1ade87558f2a2003616879f9e228] KVM: x86 emulator: Use opcode::e=
xecute for INS/OUTS from/to port in DX
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-07:09:12 2b5e97e1fadf1ade87558f2a2003616879f9e228 compiling
/home/wfg/linux

2013-01-12-07:10:39 detecting boot state 3.2.0-rc7-bisect-00057-g2b5e97e #3=
 .1..............2.3..........45............6...7.8.....9....10............=
=2E....OK .11..............OK .OK 1213.........OK .14OK 15...........OK ..1=
6..OK .OK 1718.....OK .19..OK .2021.........22..OK .23..............OK 24OK=
 .25........OK .26OK .27........OK 28..........OK .29OK .30.....OK .OK 3132=
=2E...........OK .33.............OK .OK 3435.....OK .36.......OK .37....OK =
38...............OK 39OK 4041...OK 42..OK .43.............OK ..44.......OK =
=2E45..OK .OK .4647..............OK .48...OK .49..............OK .OK 50OK 5=
152..OK .53..OK .54..........OK 55...OK 56....OK .57......OK .OK .5859.....=
=2E...OK .60.......OK .61...............OK 62OK .63..OK .64..OK .65........=
=2E.OK .66..OK 67.....OK 68.......OK .OK 6970......OK .71.......OK 72......=
=2E............OK .73OK ..7475............OK .76.OK .77........OK .78....OK=
 .79.OK .80..OK ..81..........OK .82...................OK .83.OK .84.85....=
=2E.....OK .86..OK .87........OK .88....OK .89.OK 90...OK .91.......OK .92.=
=2E................OK .93...OK .94.OK 95OK .96..........OK .97..OK .98.....=
=2E..OK .99....OK .100............................................OK ..1011=
02103104..OK .105......OK .106......OK .107.OK ..108.......................=
=2E.........................OK .OK 109OK .OK 110111112OK .113......OK ..114=
=2E.....OK .115.OK .116....................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E..................................OK ..117..............................=
=2E........................................OK  SUCCESS
Bisecting: 955 revisions left to test after this (roughly 10 steps)
[b7044d41b5a09ce9082699f74c8f10e0fe59f704] md/raid10: If there is a spare a=
nd a want_replacement device, start replacement.
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-08:00:30 b7044d41b5a09ce9082699f74c8f10e0fe59f704 compiling
/home/wfg/linux

2013-01-12-08:01:57 detecting boot state 3.2.0-rc1-bisect-00042-gb7044d4 #4=
 .....12...3......4.5.6....................................................=
=2E...OK .7OK .OK .89..OK 10....OK .OK 11OK 1213..OK ..14..................=
=2E................................OK .15...OK .16.OK .17......OK .18OK 19O=
K .OK .OK 20.21.OK .22...................................................OK=
 23...OK .24.OK .OK 2526.....OK ..OK 2728OK .OK ..OK .2930OK 313233........=
=2E........................................OK .34..OK .35..OK .OK 3637.....=
OK .OK 3839OK .OK 4041OK .OK .42OK 43.44...................................=
=2E.............OK 45...OK .46..OK .OK 4748.....OK .49OK .OK 5051OK 52.OK .=
53OK .OK 5455................................................OK .56....OK 5=
7..OK .OK .5859....OK .60OK .OK 61.OK 6263OK .64OK .OK .OK 656667..........=
=2E................................OK .68.......OK .69..OK .OK 7071.....OK =
=2E72OK 73OK .OK 7475OK .76.OK ..77...OK .78...............................=
=2E.......OK .79....OK .80.OK .81.........OK .OK .82OK .83.OK .84OK .85.OK =
=2EOK 8687...OK 88...................................OK .89........OK .OK 9=
091OK .92..........OK .OK .93OK 94OK 9596OK .97..OK .98OK .99..OK .100.....=
=2E........................OK .101............OK 102OK .OK 103104..........=
=2E.OK  SUCCESS
Bisecting: 955 revisions left to test after this (roughly 10 steps)
[0561ceabd0f13871900d116278fe9268aeb714d1] ARM: dts: Add intial dts file fo=
r EXYNOS4210 SoC, SMDKV310 and ORIGEN
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-08:18:37 0561ceabd0f13871900d116278fe9268aeb714d1 compiling
/home/wfg/linux

2013-01-12-08:20:10 detecting boot state 3.2.0-rc6-bisect-00027-g0561cea #5=
 .1...2.3....4......................5................6......7............OK=
 ..OK 8OK 910OK .OK .1112...OK .13...OK 14.....................OK ..15.....=
=2E.....OK 16.....OK .17...OK .18............OK .OK 1920OK 21.OK .OK 2223..=
=2EOK .24...OK 25.....................OK .26.......OK .27.....OK .28...OK .=
29............OK .30OK .31.OK 32.OK .33OK .OK .3435...OK .36...............=
=2E........OK .37.......OK .38.....OK .OK 3940................OK .OK 41OK 4=
243...OK .OK 4445OK .46OK .47..OK .48.........................OK .49...OK .=
50..OK .51.OK 52..................OK .53..OK 54OK .55....OK .OK 56.OK 57OK =
=2EOK 5859..........................OK .60.OK .61.....OK .OK 6263..........=
=2E......OK 64....OK .65OK .66..OK .67..OK .68OK .69OK .OK 7071............=
=2E.......OK .OK 7273............OK .74OK .75...............OK .76..OK 77.O=
K 78.....OK .79..OK 8081OK 82.OK .83....................OK .84OK .85.......=
=2E...OK .86OK .87................OK .OK 8889OK .90......OK .OK .OK 9192...=
=2E.OK .93...................OK .94OK .95..........OK .96OK 97.............=
OK .OK 9899.....OK .100....OK .101..OK 102OK .103....OK .104...............=
=2E...OK 105OK  SUCCESS
Bisecting: 950 revisions left to test after this (roughly 10 steps)
[6c15d74defd38e7e7f8805392578b7a1d508097e] asix: fix infinite loop in rx_fi=
xup()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-08:35:26 6c15d74defd38e7e7f8805392578b7a1d508097e compiling
2013-01-12-08:35:52 6c15d74defd38e7e7f8805392578b7a1d508097e SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 950 revisions left to test after this (roughly 10 steps)
[141168c36cdee3ff23d9c7700b0edc47cb65479f] x86: Simplify code by removing a=
 !SMP #ifdefs from 'struct cpuinfo_x86'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-08:36:03 141168c36cdee3ff23d9c7700b0edc47cb65479f compiling
/home/wfg/linux

2013-01-12-08:37:31 detecting boot state 3.2.0-rc4-bisect-00162-g141168c #1=
 ..1....2.3...4.56..7...........8...............9.10................OK .11O=
K 12.......OK .13...OK .14OK 15...OK 16OK .17OK 18.OK .19.........OK .20...=
=2E........OK .21OK .22................OK 23OK .24.......OK .OK 2526OK .27.=
=2E...OK .28OK 29OK .30.OK .31.........OK 32............OK .33.OK 34.......=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E...OK .3536.............................................................=
=2E..........OK .3738.OK ...3940...........................................=
=2E.................OK .41..OK 42..OK .OK .OK 434445.OK .OK .464748........=
=2E............................................OK .49......OK .50OK .51OK .=
OK 5253...OK .OK ..545556..................................................=
OK .57.......OK .58OK .59..OK .OK 60OK .61.....OK .OK 62OK 6364............=
=2E....................................OK .65.........OK .OK 6667...OK ..OK=
 68.6970..OK .OK 7172OK .OK .7374..........................................=
=2EOK .75..........OK .OK 7677.OK .78..OK .OK .7980OK ..81.OK .OK .8283OK .=
84.......................................OK .85...............OK .86.OK .87=
=2E..OK .OK .88.OK .89..OK .OK 9091OK .92..................................=
=2E....OK .93...........OK .94.OK .95..OK .96..OK .OK .OK .9798OK .99.OK ..=
OK 100101OK .102.......................................OK .103............O=
K .104.OK 105..OK .106.....OK .OK .107OK 108109..OK .110.OK .111OK .112....=
=2E...........................OK  SUCCESS
Bisecting: 950 revisions left to test after this (roughly 10 steps)
[1d3452c63d4b62329d34d7634f67a3dbec21ca87] HID: wiimote: Allow direct eepro=
m access
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-09:12:06 1d3452c63d4b62329d34d7634f67a3dbec21ca87 compiling
/home/wfg/linux

2013-01-12-09:13:42 detecting boot state 3.1.0-bisect-08917-g1d3452c #2 ...=
=2E..........1...2.......3....456.78..9............................OK ..10.=
=2E..................OK 11...OK 1213.....OK .14....OK 15OK 1617.OK 18OK 19O=
K 20.OK .21........................OK .22....................OK .23..OK .24=
=2E.OK 25.....OK .26.OK .OK 2728OK ..OK 29OK 3031OK .32....................=
=2E...OK .33....................OK .34..OK 3536.OK .37....OK .38..OK .39..O=
K .40..OK .OK 41OK .42OK 4344....................OK .45....................=
OK .46.....OK .OK .47.OK 48.....OK .49..OK .50..OK .51..OK .52OK .OK 53OK 5=
455................OK .56....................OK 57.......OK ..58OK 59......=
=2E..OK .60..OK .61..OK .6263OK .64.OK .65OK .66............OK .67.........=
=2E......OK .68.............OK 69.OK .70..........OK .71..OK .OK .72..OK .7=
3OK .74.OK .75.OK 76............OK ..77...............OK .78...........OK .=
OK 7980.OK .81.......OK 82.......OK ..83...OK .84OK 85OK .86...............=
OK .87...............OK .88.........OK 89.OK .OK 9091......OK 92........OK =
=2E93..OK .9495...OK .OK 9697OK .98..............OK .99............OK .100.=
=2E.........OK .OK 101102.OK .103......OK .104........OK .105..OK 106....OK=
 .OK 107108OK .109..............OK ..110...........OK .111.......OK  SUCCESS
Bisecting: 936 revisions left to test after this (roughly 10 steps)
[6c254de16a1d14c1ac931d3aa08dc88ac9fc582b] xen/pciback: Expand the warning =
message to include domain id.
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-09:29:58 6c254de16a1d14c1ac931d3aa08dc88ac9fc582b compiling
/home/wfg/linux

2013-01-12-09:31:34 detecting boot state 3.2.0-rc3-bisect-00039-g6c254de #3=
 .1.2.3..............4..5....6..7....8...........9............OK .10...OK .=
11......OK .12....OK 13.OK .14............OK .OK 1516......OK .17OK .18....=
OK .19..........OK 20........OK .21........OK .22.....OK .OK .23...OK .24..=
=2E....OK .25.....OK .OK 2627....OK .28OK .29..OK .30.............OK .31...=
=2E....OK .32........OK 33...OK 34..OK .OK 3536........OK 37..........OK .O=
K 3839OK .40....OK .41.............OK .42........OK .43.......OK .44...OK .=
45.OK .46OK .47.......OK .48..........OK .49..OK 50.OK .51.OK 52..OK .53...=
=2E......OK .54............OK .55.......OK .56.OK .OK .57...OK .58...OK .59=
=2E..............OK 60OK .61OK .OK 6263............OK .64..................=
OK .65......OK .66..OK .67..OK .6869....................................OK =
=2E70..................OK .71......OK .72..OK .73..OK ..74.................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E.......................................................OK ..............=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E..................................................75....................=
=2E..............................................................OK ....OK =
76777879..OK .80..OK ...81.................................................=
=2E.............OK .OK .OK 828384.OK .85.OK 86..OK .8788...................=
=2E............................................OK .OK .8990OK 91.92OK .9394=
=2EOK 95..................................................................O=
K .OK .OK 96OK 979899OK .100.OK .101.......................................=
=2E...........................OK .OK .OK .OK .OK 102OK .OK 103104OK 1051061=
07.................................................................OK .108.=
OK .109110OK .OK  SUCCESS
Bisecting: 941 revisions left to test after this (roughly 10 steps)
[4723b984b227f3fd466cd56cd18bc0110fff5987] microblaze/PCI: use pci_scan_roo=
t_bus()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-10:08:44 4723b984b227f3fd466cd56cd18bc0110fff5987 compiling
/home/wfg/linux

2013-01-12-10:10:15 detecting boot state 3.2.0-rc7-bisect-00140-g4723b98 #4=
 1....234..............................................................OK .=
5.OK .OK 67OK .OK 89..OK .OK 10OK ..111213.................................=
=2E.....................OK .14..OK .OK 1516.OK .17OK .OK .18..OK .OK 1920.O=
K .OK 21.2223.....................................................OK .OK 24=
25..OK .26.OK ..27.OK .28..OK 29OK .30OK .31OK .OK 3233....................=
=2E.................................OK .OK 3435.OK .OK .36.OK .37.OK .38..O=
K 39OK .OK 40OK .41OK 4243.................................................=
=2E..OK 44..OK .OK 4546..OK .47OK 48.OK 49.OK .50.OK .51OK .OK 5253OK .54..=
=2E..............................................OK 55..OK .OK 565758..OK .=
=2E59OK .60..OK .61OK .62.OK .OK 63OK .64..................................=
=2E..............OK .65..OK .OK 66.OK 6768OK .69.OK ..70...OK .71OK .72OK .=
73................................................OK 74.OK .75OK .OK 76OK 7=
7OK 78....OK .79OK 8081OK 82.OK .83........................................=
=2E......OK 84.OK .85OK .OK 86OK 87OK 8889....OK .OK 90OK .91OK 9293OK .94.=
=2E................................................OK 95.OK .96OK 97OK .OK =
98OK .99100...OK .101OK .OK .OK  SUCCESS
Bisecting: 899 revisions left to test after this (roughly 10 steps)
[abbb18fb4ad7472ee2e1351f0ca12bce64cac143] regmap: return ERR_PTR instead o=
f NULL in regmap_init
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-10:26:37 abbb18fb4ad7472ee2e1351f0ca12bce64cac143 compiling
/home/wfg/linux

2013-01-12-10:28:26 detecting boot state 3.2.0-rc1-bisect-00011-gabbb18f #5=
 .............................1......2..34..5..6.7...8.910.................=
=2E..........................OK .11........OK 12OK 13.OK .OK 1415.OK .16.OK=
 .OK 1718OK .OK 1920.........................................OK .21.......O=
K 22OK .23.OK 24OK .25OK .OK 2627.OK 28OK 29....OK .30OK 31................=
=2E....................OK .32.......OK .33OK 34.OK .OK 3536OK .OK .OK 3738O=
K .OK 3940....OK .OK 4142......................................OK 43.......=
=2EOK 44OK 45..OK 46OK .47OK 4849..OK .OK 5051....OK 52OK 53...............=
=2E........................................................................=
=2E........................................................................=
=2E..............OK .......................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E...............................................54.55....................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E....................................................OK .................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E..........5657..........................................................=
=2E..............OK 58..OK .OK 5960........................................=
=2E.........................OK 61OK 62..OK .OK 6364.OK .65.................=
=2E............................................OK .OK .OK 66..OK .OK .6768O=
K .69...............................................................OK .70.=
=2EOK 71OK 72OK 73.OK 74OK .OK 75..........................................=
=2E...............OK 7677.OK .OK 78OK 798081....OK 82OK .OK .83............=
=2E...........................................OK .OK 8485.OK 86OK .OK .8788=
=2EOK .89OK .90OK .OK .9192................................................=
=2E......OK .93..OK 94OK 9596OK 97...OK .OK 9899OK .100OK .101..OK .102....=
=2E..............................................OK .103.OK .OK 104OK 105OK=
 106107...OK 108OK 109110OK .111OK  SUCCESS
Bisecting: 896 revisions left to test after this (roughly 10 steps)
[e8524b2f43ab6747518aef81c709d104c478b1cd] x86, apic: Add probe() for apic_=
flat
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-11:27:00 e8524b2f43ab6747518aef81c709d104c478b1cd compiling
/home/wfg/linux

2013-01-12-11:28:36 detecting boot state 3.2.0-rc4-bisect-00163-ge8524b2 #6=
 ..................................................1.2..3........OK 4OK 56.=
=2E..OK 7..OK 8...............................................OK .OK 9OK 10=
11.OK .12........OK .13OK 14OK 151617....OK 18.............................=
=2E.....................OK .OK 19OK 2021........OK 22..OK .OK 23OK 242526.O=
K 27...................................................OK .OK 28OK .29.....=
=2E..OK 30..OK .OK 3132OK .33OK .34OK .35.OK 36............................=
=2E....................OK .37.OK .38OK .39...OK .40.OK .41OK 42.OK .43OK .O=
K 4445.OK .46................................................OK .47..OK 48O=
K .49.OK 50.OK 51..OK .52OK 5354OK .55..OK .56OK 57........................=
=2E........................OK 58..OK .59OK .60OK .OK 61OK 6263..OK .64OK .6=
5OK .OK 6667.OK .OK 6869.................................................OK=
 70..OK 71.OK .72OK .OK 73OK .74.OK .75.OK 76OK .77OK .78.OK 79OK .80......=
=2E.........................................OK .81OK 82.OK 83...OK .84OK .8=
5.....OK .86OK .OK 87.OK 88................................................=
=2E.OK .89OK 90OK .91....OK .92OK .93....OK ..94OK .95.OK .OK 96.OK .97....=
=2E........................................OK .98OK 99OK .100....OK .OK 101=
OK .102.....OK  SUCCESS
Bisecting: 896 revisions left to test after this (roughly 10 steps)
[301b195db179241da8be25f345f3c4e64960f1d5] perf evlist: Fix errno value rep=
orting on failed mmap
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-11:45:36 301b195db179241da8be25f345f3c4e64960f1d5 compiling
/home/wfg/linux

2013-01-12-11:47:10 detecting boot state 3.2.0-rc1-bisect-00408-g301b195 #7=
 .123......................................4........5.6..........OK 78.OK .=
9.OK .OK 1011OK .12..OK .13OK ..14................................OK 15....=
=2E...OK .16OK .17.............OK .OK 18OK 1920OK .21.OK 22OK 23....OK .OK =
2425...............................OK .26............OK 27OK .28.........OK=
 .OK 2930OK .31OK .32.OK .OK 3334OK .35....OK .36OK .37....................=
=2E.....OK .38............OK 39....OK .40......OK 4142....OK .43.OK 44..OK =
4546OK .47.OK .OK 4849..........................OK .50........OK 51....OK .=
=2E.......OK .52......OK .53...............................................=
=2E.......................OK .54...........................................=
=2E...........................OK .OK 5556.OK .OK .5758.....................=
=2E............................................OK .OK 5960OK .OK 61OK 6263.=
=2EOK ...6465..............................................................=
=2E.OK .OK 66OK .OK 67OK 6869.OK .70.OK .OK 71.72..........................=
=2E................................OK 73OK 74OK 75OK .OK 7677.....OK .OK 78=
79OK .80OK .81...................................................OK .82..OK=
 .OK 83OK 84OK 85OK ..86OK .87...OK .88...OK .OK 8990OK .91................=
=2E..............................OK .92......OK .OK 93OK .OK 94.OK .OK 95OK=
 9697....OK 98...OK .OK 99100OK .101.......................................=
=2E....OK .102.....OK .103OK .OK  SUCCESS
Bisecting: 889 revisions left to test after this (roughly 10 steps)
[9f9df00accb343f61a5782904af10366a18ebb5a] ARM: 7236/1: vic: always use sim=
ple ops
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-12:07:32 9f9df00accb343f61a5782904af10366a18ebb5a compiling
/home/wfg/linux

2013-01-12-12:09:05 detecting boot state 3.2.0-rc4-bisect-00120-g9f9df00 #8=
 ..12..34...5.6.7...............................................OK .8......=
=2E..OK .OK 910.OK .OK .OK 1112.OK .13..OK .14OK .15.OK 16.................=
=2E..............................OK .17.....OK .18..OK .19OK 2021.OK .22.OK=
 .23OK .24.OK .25...............................................OK .26.....=
=2E....OK .OK 272829.OK .OK .30OK 31OK .32...OK .33.OK .34.................=
=2E.........................OK .35.....................OK .3637.OK 38...OK =
39..........................................................OK .40..OK .41.=
=2EOK 4243.OK .OK 4445.OK .46..............................................=
=2E........OK .47..OK .48..OK .49..OK .OK 50..OK .5152.OK .53..............=
=2E....................................OK .54..OK .55...OK 56......OK .OK .=
57..OK .OK 5859.OK .60...............................................OK .61=
=2E.OK 62.......OK 6364...OK .OK .6566OK .OK 6768OK .69OK .70..............=
=2E..............................OK .71..OK .72......OK .73.OK .74OK .75...=
=2E.OK 7677OK .OK 7879OK .80OK .81.........................................=
OK 82.......OK .83..OK .84.....OK .OK 8586......OK .OK 87OK 88.89OK .OK 909=
1.....................................OK .92......OK .93.......OK 94..OK .O=
K 9596..........OK 97OK .OK .9899OK .100..................................O=
K 101.......OK .102......OK .103.OK .OK 104105106.....OK .107....OK .OK 108=
OK .109...OK  SUCCESS
Bisecting: 889 revisions left to test after this (roughly 10 steps)
[2d5503b624736abfe0e0bad281f9b8d8a705b930] iommu/amd: Add routines to bind/=
unbind a pasid
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-12:28:46 2d5503b624736abfe0e0bad281f9b8d8a705b930 compiling
/home/wfg/linux

2013-01-12-12:30:17 detecting boot state 3.2.0-rc5-bisect-00018-g2d5503b #9=
 ..............................1...........2.......3.4.5...6...OK .7OK .OK =
8..OK .OK .9.............................OK .10.......OK 11..........OK 12O=
K .13..OK 1415......OK .16OK 17.OK .18...OK .19............................=
=2E.OK .20......OK .21.......OK .22OK 23....OK .OK 2425.......OK .26.OK ..2=
7.OK ..28.................................OK .29..OK .30...OK .31........OK=
 .32OK .33.OK .34.........OK .3536.OK 37..OK .OK 3839......................=
=2E.........OK .OK 40...OK .41........OK .42.OK .43OK .44.........OK .45..O=
K .OK 4647OK .OK 4849................................OK 5051...OK .52......=
=2E.OK .53.OK .54OK .55.........OK .56..OK .OK 5758OK .OK 5960..OK .61.....=
=2E..........................OK .62...OK .63OK .64.........OK .65OK .66....=
=2E....OK 67...OK .OK 6869OK .70..OK .71............................OK .72.=
=2EOK .OK 7374OK .75..............OK 76OK .77..........OK 78OK .79OK .OK 80=
81.OK .82................................OK .83.OK .84OK 85............OK .=
86....OK .87.....OK 88OK .8990OK .OK 9192.OK 93............................=
=2E...OK .OK 9495.OK 96OK .97................OK .98....OK .99...OK 100.OK .=
OK 101102.OK .OK 103104.OK 105.............................OK .106...OK  SU=
CCESS
Bisecting: 871 revisions left to test after this (roughly 10 steps)
[813abbbaa3750c561f8ed7560664e652997be3dc] xen-netback: make ops structs co=
nst
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-12:46:50 813abbbaa3750c561f8ed7560664e652997be3dc compiling
/home/wfg/linux

2013-01-12-12:48:21 detecting boot state 3.2.0-bisect-01997-g813abbb #10 .1=
=2E2...............3.4..........5.678......9......................OK .10OK =
=2E11...OK .12OK .13..............OK .14.....OK 15.....OK 16.OK .OK 17OK 18=
19OK .20OK 21..........................OK 22.OK .23...OK .24OK 25..........=
=2E....OK .26.....OK 27.....OK .28OK .29...OK .30OK 31.OK 32OK .33.........=
=2E..............OK .OK 3435...OK .36..................OK 37......OK 38.OK =
3940.....OK .OK 4142OK .43OK .44........................OK .OK 4546...OK 47=
=2E..OK .48.............OK .49.....OK .50...OK 51OK .52.....OK 53OK 5455OK =
=2E56....................OK .OK 5758...OK .59..OK .60..............OK .61..=
=2E..OK .62...OK .OK 6364.....OK .OK 6566.OK .67....................OK .68.=
=2E..OK 6970..OK .71...............OK .72.....OK 73.....OK .7475........OK =
=2E76OK .77OK .78................OK .79...OK .OK 8081..................OK .=
82.OK 83..........OK .84.OK .85.........OK .OK 8687.OK 88..................=
=2EOK 89..OK 90.OK .91OK 92.................OK .93OK 94........OK .95.OK .9=
6..........OK .97OK .OK .98.................OK .99.OK 100...OK .101.OK 102.=
=2E.........OK 103....OK .104.......OK .105......OK .106..OK 107...OK .108.=
=2E..OK .OK 109110.............OK 111.OK  SUCCESS
Bisecting: 791 revisions left to test after this (roughly 10 steps)
[66655760bf38861299e3c8196f5303f886b0eef9] backlight: use kstrtoul()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-13:03:54 66655760bf38861299e3c8196f5303f886b0eef9 compiling
2013-01-12-13:04:41 66655760bf38861299e3c8196f5303f886b0eef9 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 791 revisions left to test after this (roughly 10 steps)
[63e496340f07b58925f690451c93171d9b04fe1e] clocksource: parisc: Convert to =
clocksource_register_hz/khz
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-13:05:08 63e496340f07b58925f690451c93171d9b04fe1e compiling
/home/wfg/linux

2013-01-12-13:06:40 detecting boot state 3.1.0-rc1-bisect-00037-g63e4963 #1=
 ...1...........2.....3.4..5.............6..7..............8.......OK 910..=
=2EOK .11OK .12.....OK 13..........OK 14......OK .OK 1516.OK .17.........OK=
 .18OK .19.............OK .20.......OK 21OK 2223....OK .24.....OK .25......=
=2E..OK 26..OK .OK 2728.OK .29.............OK .30.OK 31..............OK .32=
=2E.....OK .OK 333435....OK 36.....OK .37.........OK .38..OK 39OK .40.OK .4=
1............OK .42.OK 43..............OK .44.......OK .OK 4546........OK .=
47.OK .48........OK .49..OK 50...OK .OK 5152...........OK .53.OK .54.......=
=2E.....OK .55....OK .56.OK .57OK .58.......OK .59.OK .60.........OK .61.OK=
 .62...OK 63OK 64............OK 65.OK .66.............OK .67........OK .68.=
OK .69OK 70...OK .71.OK .72........OK .73.OK .74..OK .75OK .76..........OK =
=2E77.OK 78.............OK .79........OK .80...OK .81OK .82.OK .83.OK .84..=
=2E.....OK .85..OK 86...OK .OK 8788........OK 89.....OK .90.............OK =
=2E91........OK .92...OK .OK 93OK 9495....OK .96.........OK 97..OK 98...OK =
99OK .100.......OK .101.....OK 102..............OK .103........OK .104OK .1=
05.OK .106.OK 107.....OK 108.........OK .109.OK 110...OK  SUCCESS
Bisecting: 789 revisions left to test after this (roughly 10 steps)
[6b3da11b3c36fdafce3a72e0e90d6c4e99e9aad5] Merge branch 'for-3.3' of git://=
git.kernel.org/pub/scm/linux/kernel/git/tj/percpu
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-13:21:14 6b3da11b3c36fdafce3a72e0e90d6c4e99e9aad5 compiling
2013-01-12-13:22:06 6b3da11b3c36fdafce3a72e0e90d6c4e99e9aad5 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 789 revisions left to test after this (roughly 10 steps)
[e6171bbe4d5683960221d42c87195cbd366de4bf] blackfin: time-ts: rm unused fun=
c broadcast_timer_setup()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-13:22:14 e6171bbe4d5683960221d42c87195cbd366de4bf compiling
2013-01-12-13:23:01 e6171bbe4d5683960221d42c87195cbd366de4bf SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version include/linux/version.h
make: Leaving directory `/c/wfg/linux'
Bisecting: 789 revisions left to test after this (roughly 10 steps)
[be726ffd1ef291c04c4d6632ac277afa1c281712] sched/accounting: Fix parameter =
passing in task_group_account_field
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-13:23:10 be726ffd1ef291c04c4d6632ac277afa1c281712 compiling
/home/wfg/linux

2013-01-12-13:24:45 detecting boot state 3.2.0-rc1-bisect-00336-gbe726ff #1=
 ..OK .1..OK 2........OK .3........OK 4OK 56........OK .7...OK .8OK .9.....=
=2E..OK .10.OK 11..................OK .12.....OK 13.....OK .14.......OK .OK=
 15OK .16........OK .17...OK 18.OK .OK .19.......OK .20.OK .21.............=
=2E...OK 22......OK 23.OK .24...........OK .25OK .26........OK .27...OK .28=
=2EOK .29..OK 30....OK .31OK .32................OK .33.....OK 34..OK 35....=
=2E......OK .36.OK .37...........OK .OK 3839..OK .40.OK 41....OK .42.OK 43.=
=2E...............OK .44.....OK 45..OK 46...........OK .47.OK .48..OK .49..=
=2E.....OK .50..OK .51.OK 52.....OK 53.OK .54.................OK 55......OK=
 56..OK 57............OK 58.OK .59.....OK .60.OK 61...OK .62.OK .63.OK .64.=
=2E..OK .65.OK .66...............OK .67.....OK .68.OK 69...........OK .70.O=
K .71......OK .72OK .73..OK .OK 7475.....OK 76...OK 77OK 78................=
=2E..OK 79....OK .OK 8081..............OK .82.OK 83........OK .84OK .85OK .=
OK 8687....OK 88....OK .89.OK .90...........OK .91.......OK .OK 9293.......=
=2E......OK .94.OK 95........OK .96OK .97....OK .98OK  SUCCESS
Bisecting: 776 revisions left to test after this (roughly 10 steps)
[57e964e1ae9bd4f699ae1074430bcf81a9a11377] Merge tag 'fixes-non-critical' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-13:38:09 57e964e1ae9bd4f699ae1074430bcf81a9a11377 compiling
2013-01-12-13:38:56 57e964e1ae9bd4f699ae1074430bcf81a9a11377 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 776 revisions left to test after this (roughly 10 steps)
[2c1c7430390ec2148499a3b8f72e37ff5483056e] powerpc: fix compile error with =
85xx/p1023_rds.c
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-13:39:06 2c1c7430390ec2148499a3b8f72e37ff5483056e compiling
/home/wfg/linux

2013-01-12-13:40:38 detecting boot state 3.2.0-rc3-bisect-00198-g2c1c743 #1=
 ....OK 1OK .2.......OK 3....OK .4OK .5OK 6....OK .7OK 8...OK 9...........O=
K .10........OK .OK 1112..................OK 13OK .14.......OK 15.....OK 16=
OK .17OK 18....OK .19OK .20..OK 21...........OK .22........OK 2324.........=
=2E.......OK .25OK .26......OK .27....OK .28OK .29OK 30....OK 31.....OK 32.=
=2E.........OK 33.........OK 3435..................OK .36OK .37......OK .38=
OK .39.....OK 40OK 41........OK 42.OK 4344..........OK .45........OK 4647..=
=2E................OK 48OK .49......OK .50.OK .51....OK .OK 5253.......OK .=
54OK .55...........OK 56.........OK 57...................OK .58OK 59.......=
=2E.OK .60OK 61....OK 62OK 63........OK 64.OK .65..........OK 66........OK =
=2EOK 67...................OK .68OK .69.........OK 70OK 71OK .72...OK .73..=
=2E....OK .74OK .OK 75..........OK .76.......OK .77...OK .78...............=
OK 79.OK 80.........OK 81OK .OK 8283.......OK .84...OK .85OK .OK .86.......=
=2E.OK .87.......OK .88...OK 89................OK 90.OK 91.........OK 92OK =
=2E93OK 94.......OK .95...OK .OK 9697OK .98..........OK 99........OK 100...=
OK  SUCCESS
Bisecting: 743 revisions left to test after this (roughly 10 steps)
[acc952c1f373bf3f66cc7a10680eee1762bed40b] Merge tag 'cleanup' of git://git=
=2Ekernel.org/pub/scm/linux/kernel/git/arm/arm-soc
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-13:54:19 acc952c1f373bf3f66cc7a10680eee1762bed40b compiling
2013-01-12-13:55:06 acc952c1f373bf3f66cc7a10680eee1762bed40b SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 743 revisions left to test after this (roughly 10 steps)
[c84cdf75ccb2845f690579e838f13f7e744e3d23] cgroup: Remove unnecessary task_=
lock before fetching css_set on migration
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-13:55:17 c84cdf75ccb2845f690579e838f13f7e744e3d23 compiling
/home/wfg/linux

2013-01-12-13:56:51 detecting boot state 3.2.0-rc2-bisect-00489-gc84cdf7 #1=
 OK ........OK .1..OK .2.......OK .3...............OK 4..OK .5...........OK=
 .6.....OK .7....OK .8.OK .9...OK 10.....OK .11..OK .12.......OK .13.......=
=2E......OK .14...OK .15..........OK .OK 1617....OK .18....OK .19..OK .20..=
OK .21OK .22.......OK .23.......OK 24...............OK 2526...........OK .2=
7...OK 2829....OK .30.......OK .31..OK .32OK .33.OK 34.....OK .35......OK .=
36..........................OK .37......OK 3839..OK 40......OK .OK 41......=
OK .42..OK .43..OK .44......OK .45........................OK .46..OK .47...=
=2E..OK .48..OK 49.......OK .50.....OK .51..OK .52..OK .53..OK .54.........=
=2E..................OK .55..OK .56.....OK .57.OK .58......OK .59.OK .60...=
=2E..OK 61...OK 62...OK 63..............................OK .64.OK .65......=
OK .66OK .67.......OK .68.OK .69......OK .70...OK 71..OK .72...............=
=2E..............OK 7374.OK .75.....OK .OK 7677.OK .78......OK 79..OK .80..=
=2E........................................................................=
=2E..OK .OK ................................81.............................=
=2E.....................................OK .82.OK .OK 8384.OK 85OK .86.....=
=2E........................................................OK .OK 8788OK .8=
9OK 90.OK .91OK .OK 929394.................................................=
=2E.....................................................OK .95.............=
=2E.......................................................OK 96..OK .OK ...=
97OK 98.99..............................................................OK =
100......OK .OK  SUCCESS
Bisecting: 743 revisions left to test after this (roughly 10 steps)
[3b7f993394db7c446c251fb8eb32ec501a330acc] [S390] make arch/s390 subdirecto=
ries depend on config option
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-14:20:18 3b7f993394db7c446c251fb8eb32ec501a330acc compiling
/home/wfg/linux

2013-01-12-14:21:47 detecting boot state 3.2.0-rc7-bisect-00030-g3b7f993 #2=
 .1.2..3........................................................OK .4OK .OK=
 56..OK 7....OK .8.OK .OK .91011...........................................=
=2E.........OK .12.OK 13OK 14..OK .15....OK .16.OK .17....OK .18...........=
=2E.....................................OK .19.OK 2021..OK 22.........OK 23=
=2E.OK .24OK .25..OK .26.............................................OK 27.=
OK .OK 2829.OK .30........OK .OK 31OK .32..OK .33..........................=
=2E......................OK 34.OK .OK 3536..OK .37......OK .OK .OK 38OK .39=
4041OK ..42...............................................OK 4344.OK 45OK 4=
6...OK 47...........OK .OK 48OK 4950OK .51.OK .52..........................=
=2E...........OK ..53.OK .54OK .55OK .56...............OK .OK 57.OK .58..OK=
 59OK .60.OK .61......................................OK 62OK 63OK 6465...O=
K .66............OK .67...OK .68.OK 69..OK .70OK .71.OK .72................=
=2E..................OK 73OK .OK 74OK 7576....OK .77.......OK .78.......OK =
79.OK .80..OK 81.OK .82.OK 83..................................OK 84.OK .85=
=2EOK 8687.....OK 88.......OK .89...OK .90OK .91....OK .OK 9293OK .94......=
=2E...........................OK .95OK .96.OK .97.....OK .98............OK =
99OK 100.OK .101.OK .102.....OK .103OK 104105..............................=
=2EOK .OK  SUCCESS
Bisecting: 743 revisions left to test after this (roughly 10 steps)
[f5132b01386b5a67f1ff673bb2b96a507a3f7e41] KVM: Expose a version 2 architec=
tural PMU to a guests
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-14:40:13 f5132b01386b5a67f1ff673bb2b96a507a3f7e41 compiling
/home/wfg/linux

2013-01-12-14:41:42 detecting boot state 3.2.0-rc7-bisect-00154-gf5132b0 #3=
 1.2.3.....4................5.6.7.89.10......11...........................O=
K .OK 1213..OK .14....OK .15............OK .16...OK .17....OK .18.OK .1920O=
K 21.....OK .22...................OK .23..OK .OK 24.25.OK .26....OK .27....=
=2E...........OK .OK 2829........OK 30..OK .OK 31OK 3233...................=
=2E......OK .34..OK .35OK .36..OK 37.....OK .38................OK 39OK .40.=
=2E.....OK .OK .4142..OK .43.....................OK .44..OK .45OK .46.OK .4=
7.....OK 48.................OK .49...OK .50.....OK 51..OK .OK 5253..OK .54.=
=2E...................OK .55..OK .56OK .5758...OK .59................OK .60=
=2E......OK .61.....OK .62...OK .6364................OK 65.........OK .OK 6=
667.OK .68....OK 69.................OK 70....OK 71.........OK .72OK 7374..O=
K ..75...........OK .76.........OK 77...OK .OK 7879......OK .80............=
OK .81...OK .82.............OK .OK 83OK .OK 8485..OK .86.......OK 87.......=
=2EOK .88....OK .89.OK .90.......OK .91........OK .92....OK 93.............=
=2E.OK .94.OK .95OK 96.97.OK .98.......OK 99.........OK 100....OK .101..OK =
=2E102............OK .103........OK 104...........OK 105....OK .106OK .OK 1=
07....OK .108......OK .109....OK .110...OK .111...OK .112..OK .113.........=
=2E.OK  SUCCESS
Bisecting: 750 revisions left to test after this (roughly 10 steps)
[8c939402e43b21ea8ac031b7f751fa0c6b0faf00] unicore32: standardize /proc/iom=
em "Kernel code" name
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-14:58:03 8c939402e43b21ea8ac031b7f751fa0c6b0faf00 compiling
2013-01-12-14:58:45 8c939402e43b21ea8ac031b7f751fa0c6b0faf00 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 750 revisions left to test after this (roughly 10 steps)
[8c3b2296f1aa13d7504d2c09bc819cef3759562a] Merge branch 'imx/clk' into next=
/clk
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-14:58:54 8c3b2296f1aa13d7504d2c09bc819cef3759562a compiling
/home/wfg/linux

2013-01-12-15:00:20 detecting boot state 3.2.0-rc7-bisect #1 .1.....2......=
=2E......34...5................6..........7..8.9...........OK 10.OK .11OK 1=
2.......OK .13..........OK 14.OK .15....OK .16..........OK .17..OK .18.....=
=2EOK 19....OK .OK 2021...........OK .22OK .23..........OK .24..........OK =
=2E25OK .26....OK .27..........OK .28...OK .29.....OK .30...OK .OK .3132...=
=2E.......OK 33OK .OK .34......OK 35..............OK .36OK .37....OK .38...=
=2E...OK .39..OK .40.....OK .41........OK .OK 4243.....OK .44...OK 45OK 46.=
=2E..OK .47................OK .48OK .49...OK 50........OK .51..OK .52......=
=2E.OK .53....OK .OK 5455......OK 56...OK .OK 5758....OK .59...............=
=2E....OK .OK 6061...OK .62.......OK .63...OK .64....OK .65....OK .66...OK =
=2E67.....OK .68...OK .OK 6970OK 71....................OK .72....OK .73...O=
K .74.......OK .75...OK 76....OK .77.OK .78......OK .79.OK .80....OK .81OK =
82....................OK .83........OK .OK 8485...........OK .OK 86...OK 87=
=2E...OK .88......OK 89.OK .90....OK .OK .91...OK .92................OK 93.=
=2E.......OK 94OK .95..........OK .OK .9697.OK .98...OK .99......OK .100.OK=
 101.....OK .102..OK .103OK 104................OK 105.............OK  SUCCE=
SS
Bisecting: 736 revisions left to test after this (roughly 10 steps)
[4d447c9a6ebc0142d320f075c5bac6d202a79fd4] net/hyperv: Add support for jumb=
o frame up to 64KB
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-15:15:20 4d447c9a6ebc0142d320f075c5bac6d202a79fd4 compiling
/home/wfg/linux

2013-01-12-15:16:49 detecting boot state 3.2.0-rc5-bisect-00469-g4d447c9 #2=
 1..2......3....4..5....6........7.8.....9...10.....11....12...............=
=2E.....OK .13.OK 14..OK .15.......OK .16.OK .17...OK .18.........OK .19...=
=2EOK .20...OK .21...OK .22.........................OK .23.OK .24.OK 25....=
=2E..OK .OK 2627...OK .28........OK .29....OK .30...OK .31.......OK .32....=
=2E................OK .33....OK .OK 3435......OK .36..OK .37....OK .38.....=
=2E.OK .39.OK .40.OK .41...OK .42...OK .43.........................OK .44.O=
K .45.OK .46.......OK .47...OK .48....OK .49.OK .50...OK .51.....OK .52..OK=
 .53...OK .54.........................OK .55..OK .56.OK 57.......OK .58...O=
K 59.OK .60.OK .61OK 62.......OK 63.....OK 64....OK 65....OK .66...........=
=2E........OK .67..OK .68.OK .69......OK .70...OK 71..OK 72..OK .OK 7374...=
=2E..OK .75........OK .OK 7677.......OK .78.................OK 79..OK .80..=
=2E..OK .81......OK .82..OK 83OK .84OK .85...OK .86..OK .87........OK .88..=
=2EOK .89...OK ..90................OK 91..OK .92..........OK .93.....OK .OK=
 9495..OK .OK 9697OK .98.......OK .99....OK .100.......OK 101....OK .102...=
=2E.......OK .103...OK .104.........OK .105.........OK .OK 106107...OK .108=
OK 109110.......OK .111....OK .112.......OK  SUCCESS
Bisecting: 703 revisions left to test after this (roughly 10 steps)
[7287be1d0ac8c82999b67c2a33517c6ec9cfdbe7] drivers/rtc/rtc-mxc.c: fix setti=
ng time for MX1 SoC
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-15:32:19 7287be1d0ac8c82999b67c2a33517c6ec9cfdbe7 compiling
2013-01-12-15:33:07 7287be1d0ac8c82999b67c2a33517c6ec9cfdbe7 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 703 revisions left to test after this (roughly 10 steps)
[986b0c256b3b7920502969641a1cb6d2c525b750] Merge branch 'hwmod_data_devel_3=
=2E3' of git://git.pwsan.com/linux-2.6 into hwmod
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-15:33:19 986b0c256b3b7920502969641a1cb6d2c525b750 compiling
/home/wfg/linux

2013-01-12-15:34:56 detecting boot state 3.2.0-rc5-bisect-00011-g986b0c2 #1=
 123....4.....5........67........8........9.................10.......OK .11=
=2EOK .1213...OK .14OK .15....OK .16OK .17..........OK .18OK 19....OK .20..=
=2E....OK .21................OK .22...........OK 23..OK .OK 2425....OK 26OK=
 27.....OK .28OK 29.......OK .30.OK .31.OK .32............OK .33...........=
=2EOK .34..........OK .35..OK .36....OK 37......OK .38.OK 39......OK .40...=
=2E.OK .41.OK .42............OK .43............OK .44..........OK .45..OK .=
OK 4647...OK 48..OK .49.....OK 50......OK .51.....OK .OK 5253..............=
=2EOK .54....OK .55..........OK .56..OK 57...OK .58...OK .OK 5960..........=
=2EOK .61......OK .62.....OK .OK 6364.......OK 65........OK .66............=
=2E..OK .67.OK .68...OK 69.OK 70..OK .7172.......OK .73.....OK .74.........=
OK .75OK 76.......OK .77....OK .78..............OK .79.....OK .80...OK 81OK=
 .OK .82...........OK 83..OK .84........OK .85OK .86......OK .87....OK 88..=
=2E.......OK .89.....OK .90.........OK .OK 9192.OK .93..OK .94..........OK =
95........OK .96OK 97.......OK 98....OK .99.........OK .OK 100101..........=
=2E......OK .OK 102103OK .OK 104105..............OK .106....OK .107....OK .=
108.......OK 109....OK .110......OK  SUCCESS
Bisecting: 697 revisions left to test after this (roughly 10 steps)
[2a5ac6f7a9c0a24adcf68e0dd634afbe083191c1] isl29020: Remove a redundant sem=
i-colon from return statement
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-15:50:29 2a5ac6f7a9c0a24adcf68e0dd634afbe083191c1 compiling
/home/wfg/linux

2013-01-12-15:51:56 detecting boot state 3.2.0-rc2-bisect-00008-g2a5ac6f #2=
 .........1...........2...34...............5.6...........7...........OK 8.O=
K 9...OK .10......OK .11..............OK .OK 1213.OK 14OK .15..............=
OK .OK 1617...........OK 18.....OK .19....OK .20.OK .21.........OK .22.....=
=2E....OK .OK 2324.....OK 25OK .OK 2627...........OK 28.OK .29...........OK=
 .30.OK .31........OK .32.OK .33.....OK .34..............OK .35OK 36...OK .=
37OK .38OK .39.......OK .40.OK 41............OK .42.....OK .43...OK .44....=
=2E.OK .45.OK .46.............OK .47..OK .48OK .49...OK 50...OK .51..OK .52=
=2EOK 53.................OK .54.....OK .55...OK .56..OK 57..OK .58.........=
OK 59.......OK 60OK .61...OK .62..OK .63...OK .64OK .65................OK .=
66.........OK .67OK 68......OK 6970........OK .71......OK 72OK .73...OK .74=
=2E..OK 75...OK .76OK .77................OK .78..........OK .OK 7980.....OK=
 .81........OK .82......OK 83....OK .84...OK .OK 85....OK 86.....OK 87.....=
=2E.......OK 88..........OK .89...OK .90.OK .91..OK .92.....OK .93.....OK .=
94...OK ..95..OK .OK 96OK 9798........OK .99............OK 100...........OK=
 .101..OK .OK 102103.........OK 104.....OK .105..OK 106....OK  SUCCESS
Bisecting: 697 revisions left to test after this (roughly 10 steps)
[d7a83c0f7f0f7a04710f31701f195018a4f5fdd3] fat: Spelling s/obsolate/obsolet=
e/g
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-16:06:38 d7a83c0f7f0f7a04710f31701f195018a4f5fdd3 compiling
/home/wfg/linux

2013-01-12-16:08:06 detecting boot state 3.2.0-rc1-bisect-00334-gd7a83c0 #3=
 1...2.34.........5.................6......7....89........10.....OK .11.OK =
=2E12....OK .13..OK .14OK 15OK .16.........OK .17...............OK .18.....=
OK .19....OK .20.......OK .21.......OK 22.OK .23...OK .24...OK 25OK 26OK .2=
7.........OK 28................OK .29.....OK .30....OK .3132......OK .33...=
=2E...OK .34OK 35....OK .36..OK .37OK .OK 3839.........OK 40...............=
=2EOK .41.....OK .42.....OK 4344.......OK 45.....OK 46.OK .47.........OK .O=
K 48OK .OK 4950.........OK 51.................OK .52.....OK 53.....OK .54OK=
 55...OK 56......OK .57OK .58...........OK .OK 59OK 6061OK 62.........OK .6=
3................OK 64.....OK .65.....OK .66OK .67..OK 68......OK .69OK .70=
=2E..........OK .OK 71OK 72.OK 7374........OK .75................OK 76.....=
OK .77.....OK .OK 78OK .79......OK .80OK .81.............OK 82OK .83OK 84OK=
 85........OK .86...............OK .87.....OK 88......OK .89OK .OK .90.....=
=2EOK 91OK .92.........OK .OK 9394....OK 95OK .96........OK .97............=
=2E...OK .98....OK .99.....OK .100...OK 101......OK 102.OK .103........OK .=
104OK 105....OK .OK 106107........OK .108................OK  SUCCESS
Bisecting: 697 revisions left to test after this (roughly 10 steps)
[d7bd1b8a6104bcdc53611689fec8715a236a22c8] Merge branch 'drivers/pxa-gpio' =
into next/drivers
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-16:22:47 d7bd1b8a6104bcdc53611689fec8715a236a22c8 compiling
/home/wfg/linux

2013-01-12-16:24:13 detecting boot state 3.2.0-rc6-bisect-00128-gd7bd1b8 #4=
 1.....2.......3...4...5..6..7........8.910........11.....12...............=
=2EOK .13....OK .14.....OK .15...OK 16...OK 17..OK .18OK .19........OK 20.O=
K 21OK 22........OK .23....OK 24.............OK 25.....OK .26..........OK .=
27..OK .28..OK 29..OK .30OK .31.......OK .32OK .OK 3334........OK 35....OK =
=2E36........OK .37........OK 38...............OK .OK 39......OK .40.OK 41O=
K 42......OK .43OK .44OK 45........OK .46....OK .47.......OK .48........OK =
=2E49...............OK .5051.....OK .52OK .OK 5354......OK 55.OK 56OK .57..=
=2E....OK 58.....OK 59....OK 60.............OK .61................OK 62..OK=
 .63..OK .64OK .OK 6566......OK 67OK .68OK .69.......OK 70.OK .71.......OK =
72.............OK 73................OK .74..OK 75.....OK .OK 76OK 77.....OK=
 .78....OK .79OK 80.....OK 81OK .82.....OK 83............OK .84............=
=2E..OK .85.OK .86....OK .OK 87OK .88....OK .89.....OK .OK 9091.....OK 92OK=
 .93.....OK .94.............OK 95................OK .96......OK .97.....OK =
=2EOK 9899100OK .101....OK .102OK .103....OK .104OK .105.....OK 106........=
=2E....OK .107................OK 108..........OK 109110...OK .111OK  SUCCESS
Bisecting: 681 revisions left to test after this (roughly 9 steps)
[ab8fabd46f811d5153d8a0cd2fac9a0d41fb593d] mm: exclude reserved pages from =
dirtyable memory
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-16:38:57 ab8fabd46f811d5153d8a0cd2fac9a0d41fb593d compiling
2013-01-12-16:39:42 ab8fabd46f811d5153d8a0cd2fac9a0d41fb593d SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 681 revisions left to test after this (roughly 9 steps)
[2f2e3f6d7a24e7fceb0fef514767025cddb64dc2] hid-input/battery: make the batt=
ery setup common for INPUTs and FEATUREs
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-16:39:54 2f2e3f6d7a24e7fceb0fef514767025cddb64dc2 compiling
/home/wfg/linux

2013-01-12-16:41:28 detecting boot state 3.1.0-bisect-08921-g2f2e3f6 #1 ...=
1............2.....3.4......5.6...78......9............10................OK=
 .11...........OK .12.....OK 13OK .14.....OK .15.OK 16..OK 17.OK .18.....OK=
 .19...........OK .20...............OK .21...........OK .2223....OK .OK 24O=
K .25........OK .26.OK .27.OK .28OK .29.OK .30...........OK .31............=
=2E.......OK 32........OK .33..OK 34.....OK .35OK .OK 3637........OK .38OK =
39OK .40......OK .41.......OK .42...................OK .43...........OK .OK=
 4445...OK .46..OK .47.OK .48....OK .OK .49OK .50.OK 51....OK .52.......OK =
53........................OK 54........OK .55..OK 56OK .57..OK .58.....OK .=
59.OK .60...OK .OK 6162......OK .63..OK .64..........................OK .65=
=2E.......OK .OK 66....OK .67.....OK 68...OK .69..OK .70...OK .71.......OK =
=2E7273.........................OK .74.......OK 75...OK .OK 76OK 7778....OK=
 .79..OK 80...OK .81...OK .82.......OK .83...OK .84......................OK=
 85.......OK .86OK .87......OK 88OK .89....OK .90.OK .91...OK 9293...OK 94.=
=2E..OK .95......OK .96.....................OK .97......OK 98OK .99....OK 1=
00OK .101........OK .OK 102103......OK .OK 104105..OK .OK 106107.......OK .=
108........................OK .109..OK  SUCCESS
Bisecting: 673 revisions left to test after this (roughly 9 steps)
[a2ecb155a30fea933cc539fc2064fef825fd9511] crypto: caam - fix polarity of "=
propagate error" logic
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-16:57:31 a2ecb155a30fea933cc539fc2064fef825fd9511 compiling
/home/wfg/linux

2013-01-12-16:59:03 detecting boot state 3.2.0-rc1-bisect-00045-ga2ecb15 #2=
 ..1..2.............3....4...5.6.78.....9............................OK .10=
OK 1112.OK .13.OK .14...........OK .15..OK .16..OK 17.OK .18.OK .OK .19...O=
K .20.............................OK .21..OK 22OK 2324OK .25..............O=
K .OK 26OK 2728.......OK .29..OK .OK 30.31..............................OK =
=2EOK .32.OK .33...OK 3435..............OK .OK 3637..OK .38....OK .39..OK .=
OK 4041............................OK 42OK .43.OK .44..OK .45...OK 46......=
=2E........OK .OK 4748.......OK .OK 4950..OK .51...................OK .52..=
=2E.....OK 53..OK .54..OK .55...............OK .OK 5657..OK 58......OK .59.=
OK .60....OK .61.................OK .62......OK .63.....OK .6465...........=
=2E.OK 66OK .67.OK .68......OK .69.OK .70...OK .OK 7172....................=
=2EOK .73...OK .74..OK .75......OK .76........OK 77..OK 78...OK 79.......OK=
 80......OK 81.OK .82.OK .83..................OK .84.......OK .85..OK 86...=
=2E...OK .8788......OK .89.OK .9091.........OK .92.....OK 93.OK .94..OK .95=
=2E.................OK 96.......OK ..97.OK .98...OK .99..OK .100......OK .1=
01102.OK .103.........OK .104.OK .105....OK .OK 106107.................OK 1=
08...........OK .OK 109110......OK .111..OK 112.......OK 113114.OK  SUCCESS
Bisecting: 659 revisions left to test after this (roughly 9 steps)
[d8c9584ea2a92879f471fd3a2be3af6c534fb035] vfs: prefer ->dentry->d_sb to ->=
mnt->mnt_sb
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-17:15:25 d8c9584ea2a92879f471fd3a2be3af6c534fb035 compiling
2013-01-12-17:16:52 d8c9584ea2a92879f471fd3a2be3af6c534fb035 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsym=
s2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/linux/version.h Module.symve=
rs
make: Leaving directory `/c/wfg/linux'
Bisecting: 659 revisions left to test after this (roughly 9 steps)
[1b51197d0fd0c06877c6df1bba84ac4008a7fc60] [SCSI] lpfc 8.3.28: Add Loopback=
 support for SLI4 adapters
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-17:17:08 1b51197d0fd0c06877c6df1bba84ac4008a7fc60 compiling
/home/wfg/linux

2013-01-12-17:21:32 detecting boot state 3.2.0-rc5-bisect-00087-g1b51197 #1=
 1..2.....3..45..6...........7.............8...........9..10......OK .11...=
=2E..OK .12......OK 13.....OK 14.OK .15OK 16..OK 17.......OK .18........OK =
=2E19.............OK .20.OK .21.......OK .22......OK .23.....OK 24.....OK 2=
5.OK .OK .OK 262728........OK .29............OK .30.....OK .31.....OK .32..=
=2E........OK .3334......OK .35....OK .36.OK .37.OK .3839.OK .40.....OK ..4=
1........OK .42.............OK .43.OK .44...............OK ..45....OK 46.OK=
 47....OK .48..OK 49..OK .50..OK .51.OK .52........OK .53.............OK .5=
4.....OK .55........OK .56......OK .57....OK 58.OK 59....OK .60.OK .OK 6162=
=2E....OK .63.OK .64....OK .65................OK .66.OK .67........OK .68..=
=2E.......OK 69OK .70....OK .71...OK .72..OK 73OK 74.....OK .75.OK .76.OK 7=
7.............OK .78.....OK 79.........OK .80.........OK .OK .OK 81.82.....=
=2E...OK .83.OK .84...OK .85.OK 86..OK .87OK .88................OK .89OK .9=
0......OK .91..............OK .92..OK .OK 9394.........OK .95..OK .9697...O=
K .98OK .99OK .100................OK .101OK .102........OK 103.............=
=2E.OK 104105...OK .106.........OK .OK 107108.....OK .109.OK 110..OK .111..=
=2E...........OK 112....OK  SUCCESS
Bisecting: 656 revisions left to test after this (roughly 9 steps)
[2d51daaa615e4724f24e43fa01e705c40551080a] Merge tag 'spi-for-linus' of git=
://git.secretlab.ca/git/linux-2.6
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-17:36:52 2d51daaa615e4724f24e43fa01e705c40551080a compiling
/home/wfg/linux

2013-01-12-17:38:36 detecting boot state 3.2.0-bisect-03012-g2d51daa #2 1..=
=2E..2....... TEST FAILURE
Bisecting: 149 revisions left to test after this (roughly 7 steps)
[edf7c8148ec40c0fd27c0ef3f688defcc65e3913] Merge branch 'x86-mce-for-linus'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-17:39:00 edf7c8148ec40c0fd27c0ef3f688defcc65e3913 compiling
/home/wfg/linux

2013-01-12-17:40:38 detecting boot state 3.2.0-bisect-00379-gedf7c81 #3 .. =
TEST FAILURE
Bisecting: 64 revisions left to test after this (roughly 6 steps)
[35b740e4662ef386f0c60e1b60aaf5b44db9914c] Merge branch 'perf-core-for-linu=
s' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-17:40:45 35b740e4662ef386f0c60e1b60aaf5b44db9914c compiling
/home/wfg/linux

2013-01-12-17:42:27 detecting boot state 3.2.0-bisect-00257-g35b740e #4 12 =
TEST FAILURE
Bisecting: 40 revisions left to test after this (roughly 6 steps)
[4a2164a7dbf0d3b6a1c2ef6f20c0d54350491a12] Merge branch 'core-memblock-for-=
linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-17:42:34 4a2164a7dbf0d3b6a1c2ef6f20c0d54350491a12 compiling
/home/wfg/linux

2013-01-12-17:44:11 detecting boot state 3.2.0-bisect-00072-g4a2164a #5 .1.=
=2E.. TEST FAILURE
Bisecting: 22 revisions left to test after this (roughly 5 steps)
[9d15ffc824a90842b16592f3a960836841bd6c58] mips: Use HAVE_MEMBLOCK_NODE_MAP
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-17:44:23 9d15ffc824a90842b16592f3a960836841bd6c58 compiling
/home/wfg/linux

2013-01-12-17:46:15 detecting boot state 3.2.0-rc3-bisect-00072-g9d15ffc #6=
 1.2.........................................................OK .OK 34.OK .=
OK 56.OK .OK 78...OK ..OK 9OK .1011........................................=
=2E................OK .OK 1213.OK 14OK .15.OK .OK .OK 1617...OK .18OK .OK .=
1920.....................................................OK 21.OK .22OK 232=
4.OK .OK 25.26.OK .OK 2728..OK .OK ..29OK .30..............................=
=2E.....................OK .OK 3132.OK .33OK .34.OK .35OK .36.OK 37....OK .=
38OK .39..................................................OK .OK 40.OK .41O=
K .OK 4243OK .44...OK 45..OK .46OK .47OK .48..OK .49.......................=
=2E..........................OK .OK 50.OK .51OK .OK 5253OK 5455...OK .56..O=
K .OK 5758OK .OK .5960.....................................................=
OK .61OK .62.OK .OK 63OK 64OK 6566...OK .67.OK .68OK 6970.OK .71...........=
=2E.......................................OK 72...OK 73OK .OK 74OK 7576OK .=
=2E77OK .78.OK .79OK .OK 8081OK ..82.......................................=
=2E.........OK .83......OK .84OK .OK 8586OK 87OK .88OK 8990OK .91OK .92.OK =
=2E93OK .94.................................................OK .95......OK =
=2E96OK .OK 9798OK 99.OK .100OK .OK  SUCCESS
Bisecting: 12 revisions left to test after this (roughly 4 steps)
[f07fdec50a13f134ea9608c8fb3f6408c58ef55e] lockdep/waitqueues: Add better a=
nnotation
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-18:02:18 f07fdec50a13f134ea9608c8fb3f6408c58ef55e compiling
/home/wfg/linux

2013-01-12-18:03:48 detecting boot state 3.2.0-rc6-bisect-00010-gf07fdec #7=
 ..1..23...4.5.................................................6.....OK .7O=
K 89OK .10OK .11.OK .1213OK .14OK .15OK .OK 1617...........................=
=2E...................OK .18...OK 19.OK .20OK 2122......OK .2324.OK .25OK .=
26OK .27OK .28................................................OK .29...OK 3=
031OK .32....OK .OK 3334.....OK .35OK .36OK 37OK .38.......................=
=2E.....................OK .OK 3940..OK .41OK 4243.....OK 44...OK .45......=
OK 46.OK .47OK .OK 4849.....................................OK .50..OK .51.=
=2E..OK .52.OK .5354......OK .55.....OK .56.OK .57..OK 58.OK .OK .59.......=
=2E........................OK .60...OK 61OK .62.....OK .OK 6364..OK .65....=
=2E.OK .66....OK .OK 6768....OK .OK 69...OK 70.............................=
OK 71.......OK 72.OK 73..OK .OK 7475..OK .76......OK 77....OK .78OK 79....O=
K .OK 8081..OK .82...........................OK .83......OK .84OK .85..OK .=
86..OK .87......OK .88...OK ..OK 8990...OK .91...OK ..92...................=
=2E...........OK 93...OK .94....OK 9596......OK .97......OK .98....OK .OK 9=
9100...OK .101OK .102..OK .103..........................OK 104...OK .105...=
=2EOK .106..OK .OK .107.OK 108..........OK .109OK .110OK  SUCCESS
Bisecting: 5 revisions left to test after this (roughly 3 steps)
[15f043a65f655eb8a3aeb831a85da66de520c80f] Merge branch 'core-locking-for-l=
inus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-18:19:49 15f043a65f655eb8a3aeb831a85da66de520c80f compiling
/home/wfg/linux

2013-01-12-18:21:43 detecting boot state 3.2.0-bisect-00017-g15f043a #8 .. =
TEST FAILURE
Bisecting: 2 revisions left to test after this (roughly 2 steps)
[dc4218bd0fe499fce2896f88101ea42dac1f60fc] timer: Use debugobjects to catch=
 deletion of uninitialized timers
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-18:21:48 dc4218bd0fe499fce2896f88101ea42dac1f60fc compiling
/home/wfg/linux

2013-01-12-18:23:27 detecting boot state 3.2.0-rc2-bisect-00136-gdc4218b #9=
 1.. TEST FAILURE
Bisecting: 1 revision left to test after this (roughly 1 step)
[b84d435cc228e87951f3bbabf6cc4a5f25d5fb16] debugobjects: Extend to assert t=
hat an object is initialized
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-18:23:34 b84d435cc228e87951f3bbabf6cc4a5f25d5fb16 compiling
/home/wfg/linux

2013-01-12-18:24:28 detecting boot state 3.2.0-rc2-bisect-00134-gb84d435 #1=
0 .1 TEST FAILURE
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[feac18dda25134005909e7770c77464e65608bd8] debugobjects: Be smarter about s=
tatic objects
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-12-18:24:33 feac18dda25134005909e7770c77464e65608bd8 compiling
/home/wfg/linux

2013-01-12-18:25:53 detecting boot state 3.2.0-rc2-bisect-00133-gfeac18d #1=
1 ..1 TEST FAILURE
feac18dda25134005909e7770c77464e65608bd8 is the first bad commit
commit feac18dda25134005909e7770c77464e65608bd8
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Mon Nov 7 19:48:26 2011 -0800

    debugobjects: Be smarter about static objects
   =20
    Make debugobjects use the return code from the fixup function. That
    allows us better diagnostics in the activate check than relying on a
    WARN_ON() in the object specific code.
   =20
    [ tglx@linutronix.de: Split out the debugobjects vs. the timer change ]
   =20
    Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
    Cc: Christine Chan <cschan@codeaurora.org>
    Cc: John Stultz <john.stultz@linaro.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Link: http://lkml.kernel.org/r/1320724108-20788-2-git-send-email-sboyd@=
codeaurora.org
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

:040000 040000 28ecd5f0279d9bb4b898fe34121ded280cf8829e 4fe33cf928f216e28be=
46f85b1315d9cd9ae42eb M	lib
bisect run success

=3D=3D=3D=3D=3D=3D=3D=3D=3D linux-next =3D=3D=3D=3D=3D=3D=3D=3D=3D

2013-01-12-18:26:19 21841151fca8b548a79b1f72d978da26d5eb1169 compiling
2013-01-12-18:27:13 21841151fca8b548a79b1f72d978da26d5eb1169 SKIP BROKEN BU=
ILD
/usr/bin/make -C source O=3D/cc/wfg/linux-bisect-x86_64 ARCH=3Dx86_64 distc=
lean
make: Entering directory `/c/wfg/linux'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/gen=
erated
  CLEAN   .config .config.old .version include/generated/uapi/linux/version=
=2Eh Module.symvers
make: Leaving directory `/c/wfg/linux'
ERROR# 125: /c/kernel-tests/bisect:29: main: $BISECT_TEST $KBUILD_OUTPUT

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.2.0 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
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
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_FHANDLE=y
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_CMPXCHG_DOUBLE=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
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
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CLEANCACHE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
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
CONFIG_HOTPLUG_CPU=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
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
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_STUB is not set
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
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
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_PHONET is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_HAVE_BPF_JIT=y

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

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_IRQ=y
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

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
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
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
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX3107 is not set
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
# CONFIG_HVC_XEN_FRONTEND is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
CONFIG_R3964=y
CONFIG_APPLICOM=y
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_INTEL_MID=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#

#
# PPS support
#

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=y
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_TPS65910=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MAX8997 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
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
CONFIG_MFD_88PM860X=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_TPS6105X=y
CONFIG_TPS65010=y
CONFIG_TPS6507X=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_TIMBERDALE=y
CONFIG_LPC_SCH=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_BQ24022 is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_TPS6586X is not set
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS65910 is not set
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_MGA=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
# CONFIG_DRM_VMWGFX is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=y
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
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
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
# CONFIG_FB_MATROX_MAVEN is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
CONFIG_FB_VIRTUAL=y
CONFIG_XEN_FBDEV_FRONTEND=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_AAT2870=y

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_HID_PID is not set

#
# Special HID drivers
#
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_CI13XXX_PCI is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
CONFIG_USB_EG20T=y
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=y
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_DECODE_MCE is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=y
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=y
# CONFIG_EDAC_I7300 is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_BALLOON is not set

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
# CONFIG_XENFS is not set
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PCIDEV_BACKEND=y
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_ACPI_PROCESSOR=y
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_ECHO is not set
# CONFIG_POHMELFS is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_VME_BUS is not set
CONFIG_DX_SEP=y
# CONFIG_IIO is not set
# CONFIG_XVMALLOC is not set
# CONFIG_ZCACHE is not set
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y

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
# CONFIG_ANDROID_LOGGER is not set
# CONFIG_ANDROID_RAM_CONSOLE is not set
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_ANDROID_SWITCH is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_SIGMA is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
# CONFIG_SYSFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_PSTORE=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
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
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
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

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
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
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y

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
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
CONFIG_MPILIB=y
# CONFIG_MPILIB_EXTRA is not set
# CONFIG_DIGSIG is not set
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set

--4Ckj6UjgE2iN1+kY--
