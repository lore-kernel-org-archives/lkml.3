Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422Ab3LHP6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:58:03 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:47108 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3LHP5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:57:54 -0500
MIME-Version: 1.0
In-Reply-To: <52A351A7.5050407@gmail.com>
References: <CABWXVkMdyDNxG3QFOvyx4=6EiJQ5ik9aJxa7jQvtO+UJKwc8Fw@mail.gmail.com>
	<CABWXVkMUFdRKNm76Vc3oJ+Ef9M_MS1xU2TKh=rdyv-t9Cq5V1w@mail.gmail.com>
	<CABWXVkNXzxrZJiYshhsWFRf4fDgUL3=tmFtv23w=sZtZM7Rxgg@mail.gmail.com>
	<20131207160246.GA11635@core.coreip.homeip.net>
	<52A351A7.5050407@gmail.com>
Date: Sun, 8 Dec 2013 19:57:53 +0400
Message-ID: <CABWXVkNknjn2e0nd+4xLFmMDXBevgg+9GorKf1O1QKtcm9ZdYg@mail.gmail.com>
Subject: Re: synaptics: PS/2 touchpad isn't detected if a keyboard key is held
 down on boot
From: Andrey Moiseev <o2g.org.ru@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With i8042.reset=1, it works properly. Maybe this should be made the
default option? AFAIK, 8042 chip is not guaranteed to be sane and
clean on boot, even provided there's no messing with keyboard on boot.
Though, I don't understand why it flushes one byte on flush() (isn't
it thorough enough?) and then scancodes come and come from time to
time.

On Sat, Dec 7, 2013 at 8:49 PM, Andrey Moiseev <o2g.org.ru@gmail.com> wrote:
> Here is my dmesg. At boot 'H' key was held down.
>
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.13.0-rc3-ARCH-dirty (o2genum@o2pc) (gcc version 4.8.2 (GCC) ) #10 SMP PREEMPT Sat Dec 7 20:25:41 MSK 2013
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-mainline i8042.debug=1 root=UUID=747f676b-e21a-443a-ac61-3f6c4aebb73d rw quiet
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007b680fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007b681000-0x000000007b6befff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007b6bf000-0x000000007b757fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007b758000-0x000000007b7befff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007b7bf000-0x000000007b7e2fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007b7e3000-0x000000007b7fefff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000007b7ff000-0x000000007b7fffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000007bffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feb00000-0x00000000feb03fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1b000-0x00000000fed1ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.6 present.
> [    0.000000] DMI: LENOVO 20035                           /Base Board Product Name, BIOS 1ECN33WW(V5.07) 03/17/2010
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x7b800 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-EFFFF write-through
> [    0.000000]   F0000-FFFFF write-combining
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask FC0000000 write-back
> [    0.000000]   1 base 0FFE00000 mask FFFE00000 write-protect
> [    0.000000]   2 base 040000000 mask FC0000000 write-back
> [    0.000000]   3 base 07C000000 mask FFC000000 uncachable
> [    0.000000]   4 base 07B800000 mask FFF800000 uncachable
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x01b3c000, 0x01b3cfff] PGTABLE
> [    0.000000] BRK [0x01b3d000, 0x01b3dfff] PGTABLE
> [    0.000000] BRK [0x01b3e000, 0x01b3efff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x7b400000-0x7b5fffff]
> [    0.000000]  [mem 0x7b400000-0x7b5fffff] page 2M
> [    0.000000] BRK [0x01b3f000, 0x01b3ffff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x78000000-0x7b3fffff]
> [    0.000000]  [mem 0x78000000-0x7b3fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x77ffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x77ffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x7b600000-0x7b680fff]
> [    0.000000]  [mem 0x7b600000-0x7b680fff] page 4k
> [    0.000000] BRK [0x01b40000, 0x01b40fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x7b6bf000-0x7b757fff]
> [    0.000000]  [mem 0x7b6bf000-0x7b757fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x7b7bf000-0x7b7e2fff]
> [    0.000000]  [mem 0x7b7bf000-0x7b7e2fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x7b7ff000-0x7b7fffff]
> [    0.000000]  [mem 0x7b7ff000-0x7b7fffff] page 4k
> [    0.000000] RAMDISK: [mem 0x378d4000-0x37c61fff]
> [    0.000000] ACPI: RSDP 00000000000fe020 000024 (v02 LENOVO)
> [    0.000000] ACPI: XSDT 000000007b7fe120 000084 (v01 LENOVO CB-01    00000001      01000013)
> [    0.000000] ACPI: FACP 000000007b7fc000 0000F4 (v04 LENOVO CB-01    00000001 MSFT 01000013)
> [    0.000000] ACPI: DSDT 000000007b7ef000 00992C (v02 LENOVO CB-01    00000001 MSFT 01000013)
> [    0.000000] ACPI: FACS 000000007b76a000 000040
> [    0.000000] ACPI: ASF! 000000007b7fd000 0000A5 (v32 INTEL  Calpella 00000001 MSFT 01000013)
> [    0.000000] ACPI: HPET 000000007b7fb000 000038 (v01 LENOVO CB-01    00000001 MSFT 01000013)
> [    0.000000] ACPI: APIC 000000007b7fa000 00008C (v02 INTEL  Calpella 00000001 MSFT 01000013)
> [    0.000000] ACPI: MCFG 000000007b7f9000 00003C (v01 LENOVO CB-01    00000001 MSFT 01000013)
> [    0.000000] ACPI: SLIX 000000007b7ee000 000176 (v01 LENOVO CB-01    00000001 MSFT 01000013)
> [    0.000000] ACPI: BOOT 000000007b7eb000 000028 (v01 INTEL  Calpella 00000001 MSFT 01000013)
> [    0.000000] ACPI: ASPT 000000007b7e7000 000034 (v04 INTEL  Calpella 00000001 MSFT 01000013)
> [    0.000000] ACPI: WDRT 000000007b7e6000 000047 (v01 INTEL  Calpella 00000000 MSFT 01000013)
> [    0.000000] ACPI: SSDT 000000007b7e5000 0009F1 (v01  PmRef    CpuPm 00003000 INTL 20051117)
> [    0.000000] ACPI: SSDT 000000007b7e4000 000259 (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
> [    0.000000] ACPI: SSDT 000000007b7e3000 00049F (v01  PmRef    ApTst 00003000 INTL 20051117)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000007b7fffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x7b7fffff]
> [    0.000000]   NODE_DATA [mem 0x7b7de000-0x7b7e2fff]
> [    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff880078e00000-ffff88007adfffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
> [    0.000000]   node   0: [mem 0x00100000-0x7b680fff]
> [    0.000000]   node   0: [mem 0x7b6bf000-0x7b757fff]
> [    0.000000]   node   0: [mem 0x7b7bf000-0x7b7e2fff]
> [    0.000000]   node   0: [mem 0x7b7ff000-0x7b7fffff]
> [    0.000000] On node 0 totalpages: 505563
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3996 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 7840 pages used for memmap
> [    0.000000]   DMA32 zone: 501567 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7b681000-0x7b6befff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7b758000-0x7b7befff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7b7e3000-0x7b7fefff]
> [    0.000000] e820: [mem 0x7c000000-0xdfffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:8 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88007b400000 s86272 r8192 d24320 u262144
> [    0.000000] pcpu-alloc: s86272 r8192 d24320 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 497638
> [    0.000000] Policy zone: DMA32
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-mainline i8042.debug=1 root=UUID=747f676b-e21a-443a-ac61-3f6c4aebb73d rw quiet
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 1973032K/2022252K available (5151K kernel code, 815K rwdata, 1728K rodata, 1160K init, 1304K bss, 49220K reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000]  Dump stacks of tasks blocking RCU-preempt GP.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=8.
> [    0.000000] NR_IRQS:8448 nr_irqs:744 16
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 8388608 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.003333] tsc: Detected 2127.841 MHz processor
> [    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4257.00 BogoMIPS (lpj=7092803)
> [    0.000007] pid_max: default: 32768 minimum: 301
> [    0.000040] Security Framework initialized
> [    0.000052] AppArmor: AppArmor disabled by boot time parameter
> [    0.000053] Yama: becoming mindful.
> [    0.000227] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.000932] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.001223] Mount-cache hash table entries: 256
> [    0.001448] Initializing cgroup subsys memory
> [    0.001456] Initializing cgroup subsys devices
> [    0.001459] Initializing cgroup subsys freezer
> [    0.001461] Initializing cgroup subsys net_cls
> [    0.001462] Initializing cgroup subsys blkio
> [    0.001486] CPU: Physical Processor ID: 0
> [    0.001488] CPU: Processor Core ID: 0
> [    0.001494] mce: CPU supports 9 MCE banks
> [    0.001505] CPU0: Thermal monitoring enabled (TM1)
> [    0.001516] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
> Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
> tlb_flushall_shift: 6
> [    0.001606] Freeing SMP alternatives memory: 20K (ffffffff819ef000 - ffffffff819f4000)
> [    0.002796] ACPI: Core revision 20131115
> [    0.012879] ACPI: All ACPI Tables successfully acquired
> [    0.179442] ftrace: allocating 20458 entries in 80 pages
> [    0.191816] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.224806] smpboot: CPU0: Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz (fam: 06, model: 25, stepping: 02)
> [    0.330332] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
> [    0.330340] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
> [    0.330343] ... version:                3
> [    0.330344] ... bit width:              48
> [    0.330345] ... generic registers:      4
> [    0.330346] ... value mask:             0000ffffffffffff
> [    0.330347] ... max period:             000000007fffffff
> [    0.330348] ... fixed-purpose events:   3
> [    0.330349] ... event mask:             000000070000000f
> [    0.357070] x86: Booting SMP configuration:
> [    0.370446] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.357072] .... node  #0, CPUs:      #1 #2 #3
> [    0.410323] x86: Booted up 1 node, 4 CPUs
> [    0.410328] smpboot: Total of 4 processors activated (17029.00 BogoMIPS)
> [    0.412942] devtmpfs: initialized
> [    0.416343] PM: Registering ACPI NVS region [mem 0x7b758000-0x7b7befff] (421888 bytes)
> [    0.417415] RTC time: 16:39:27, date: 12/07/13
> [    0.417460] NET: Registered protocol family 16
> [    0.417574] cpuidle: using governor ladder
> [    0.417576] cpuidle: using governor menu
> [    0.417592] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.417594] ACPI: bus type PCI registered
> [    0.417596] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.417675] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.417678] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
> [    0.438612] PCI: Using configuration type 1 for base access
> [    0.438752] mtrr: your CPUs had inconsistent variable MTRR settings
> [    0.438753] mtrr: probably your BIOS does not setup all CPUs.
> [    0.438754] mtrr: corrected configuration.
> [    0.439244] bio: create slab <bio-0> at 0
> [    0.439371] ACPI: Added _OSI(Module Device)
> [    0.439374] ACPI: Added _OSI(Processor Device)
> [    0.439375] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.439377] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.443160] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.470309] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.470733] ACPI: SSDT 000000007b691c18 0003A0 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
> [    0.471190] ACPI: Dynamic OEM Table Load:
> [    0.471192] ACPI: SSDT           (null) 0003A0 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
> [    0.471342] ACPI: SSDT 000000007b68f618 0005CD (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
> [    0.471783] ACPI: Dynamic OEM Table Load:
> [    0.471785] ACPI: SSDT           (null) 0005CD (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
> [    0.497221] ACPI: SSDT 000000007b690a98 000303 (v01  PmRef    ApIst 00003000 INTL 20051117)
> [    0.497727] ACPI: Dynamic OEM Table Load:
> [    0.497729] ACPI: SSDT           (null) 000303 (v01  PmRef    ApIst 00003000 INTL 20051117)
> [    0.510396] ACPI: SSDT 000000007b68ed98 000119 (v01  PmRef    ApCst 00003000 INTL 20051117)
> [    0.510866] ACPI: Dynamic OEM Table Load:
> [    0.510868] ACPI: SSDT           (null) 000119 (v01  PmRef    ApCst 00003000 INTL 20051117)
> [    0.535990] ACPI: Interpreter enabled
> [    0.536002] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
> [    0.536009] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
> [    0.536033] ACPI: (supports S0 S3 S4 S5)
> [    0.536035] ACPI: Using IOAPIC for interrupt routing
> [    0.536076] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.536263] ACPI: No dock devices found.
> [    0.621788] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
> [    0.621795] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.621831] \_SB_.PCI0:_OSC invalid UUID
> [    0.621833] _OSC request data:1 1f 0
> [    0.621837] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
> [    0.622688] ACPI: \_SB_.PCI0.PDRC: can't evaluate _ADR (0x5)
> [    0.622691] ACPI: \_SB_.PCI0.MIR_: can't evaluate _ADR (0x5)
> [    0.622703] PCI host bridge to bus 0000:00
> [    0.622705] pci_bus 0000:00: root bus resource [bus 00-fe]
> [    0.622708] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.622710] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.622712] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.622714] pci_bus 0000:00: root bus resource [mem 0x7c000000-0xfeafffff]
> [    0.622722] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
> [    0.622742] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
> [    0.622827] pci 0000:00:01.0: [8086:0045] type 01 class 0x060400
> [    0.622864] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.622916] pci 0000:00:01.0: System wakeup disabled by ACPI
> [    0.622993] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
> [    0.623376] pci 0000:00:1a.0: reg 0x10: [mem 0x99105c00-0x99105fff]
> [    0.625583] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    0.625668] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.625718] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
> [    0.625742] pci 0000:00:1b.0: reg 0x10: [mem 0x99100000-0x99103fff 64bit]
> [    0.625842] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.625905] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.625946] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
> [    0.626048] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.626112] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.626151] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
> [    0.626253] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.626351] pci 0000:00:1c.2: [8086:3b46] type 01 class 0x060400
> [    0.626454] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.626562] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
> [    0.626942] pci 0000:00:1d.0: reg 0x10: [mem 0x99105800-0x99105bff]
> [    0.629155] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.629238] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.629284] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
> [    0.629410] pci 0000:00:1e.0: System wakeup disabled by ACPI
> [    0.629448] pci 0000:00:1f.0: [8086:3b09] type 00 class 0x060100
> [    0.629647] pci 0000:00:1f.2: [8086:3b29] type 00 class 0x010601
> [    0.629675] pci 0000:00:1f.2: reg 0x10: [io  0x5048-0x504f]
> [    0.629687] pci 0000:00:1f.2: reg 0x14: [io  0x5054-0x5057]
> [    0.629699] pci 0000:00:1f.2: reg 0x18: [io  0x5040-0x5047]
> [    0.629710] pci 0000:00:1f.2: reg 0x1c: [io  0x5050-0x5053]
> [    0.629722] pci 0000:00:1f.2: reg 0x20: [io  0x5020-0x503f]
> [    0.629734] pci 0000:00:1f.2: reg 0x24: [mem 0x99105000-0x991057ff]
> [    0.629802] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.629893] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
> [    0.629915] pci 0000:00:1f.3: reg 0x10: [mem 0x99106000-0x991060ff 64bit]
> [    0.629946] pci 0000:00:1f.3: reg 0x20: [io  0x5000-0x501f]
> [    0.630105] pci 0000:01:00.0: [10de:0a34] type 00 class 0x030000
> [    0.630120] pci 0000:01:00.0: reg 0x10: [mem 0x92000000-0x92ffffff]
> [    0.630134] pci 0000:01:00.0: reg 0x14: [mem 0x80000000-0x8fffffff 64bit pref]
> [    0.630148] pci 0000:01:00.0: reg 0x1c: [mem 0x90000000-0x91ffffff 64bit pref]
> [    0.630158] pci 0000:01:00.0: reg 0x24: [io  0x4000-0x407f]
> [    0.630168] pci 0000:01:00.0: reg 0x30: [mem 0xfff80000-0xffffffff pref]
> [    0.630280] pci 0000:01:00.1: [10de:0be2] type 00 class 0x040300
> [    0.630294] pci 0000:01:00.1: reg 0x10: [mem 0x93000000-0x93003fff]
> [    0.630446] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.630449] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
> [    0.630452] pci 0000:00:01.0:   bridge window [mem 0x92000000-0x930fffff]
> [    0.630456] pci 0000:00:01.0:   bridge window [mem 0x80000000-0x91ffffff 64bit pref]
> [    0.630544] acpiphp: Slot [1] registered
> [    0.630551] pci 0000:00:1c.0: PCI bridge to [bus 02-05]
> [    0.630556] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
> [    0.630562] pci 0000:00:1c.0:   bridge window [mem 0x98100000-0x990fffff]
> [    0.630569] pci 0000:00:1c.0:   bridge window [mem 0x93100000-0x940fffff 64bit pref]
> [    0.630690] pci 0000:06:00.0: [168c:002b] type 00 class 0x028000
> [    0.630722] pci 0000:06:00.0: reg 0x10: [mem 0x97100000-0x9710ffff 64bit]
> [    0.630868] pci 0000:06:00.0: supports D1
> [    0.630870] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
> [    0.640219] pci 0000:00:1c.1: PCI bridge to [bus 06]
> [    0.640230] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
> [    0.640239] pci 0000:00:1c.1:   bridge window [mem 0x97100000-0x980fffff]
> [    0.640252] pci 0000:00:1c.1:   bridge window [mem 0x94100000-0x950fffff 64bit pref]
> [    0.640408] pci 0000:07:00.0: [14e4:1692] type 00 class 0x020000
> [    0.640452] pci 0000:07:00.0: reg 0x10: [mem 0x96100000-0x9610ffff 64bit]
> [    0.640680] pci 0000:07:00.0: PME# supported from D3hot D3cold
> [    0.640737] pci 0000:07:00.0: System wakeup disabled by ACPI
> [    0.650242] pci 0000:00:1c.2: PCI bridge to [bus 07]
> [    0.650254] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
> [    0.650259] pci 0000:00:1c.2:   bridge window [mem 0x96100000-0x970fffff]
> [    0.650267] pci 0000:00:1c.2:   bridge window [mem 0x95100000-0x960fffff 64bit pref]
> [    0.650353] pci 0000:00:1e.0: PCI bridge to [bus 08] (subtractive decode)
> [    0.650366] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> [    0.650369] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> [    0.650371] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    0.650373] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfeafffff] (subtractive decode)
> [    0.677353] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
> [    0.677413] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
> [    0.677471] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> [    0.677528] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
> [    0.677585] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
> [    0.677642] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> [    0.677699] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> [    0.677756] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 *5 6 7 11 12 14 15)
> [    0.677805] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
> [    0.677809] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.677814] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    0.677888] PCI host bridge to bus 0000:ff
> [    0.677891] pci_bus 0000:ff: root bus resource [bus ff]
> [    0.677897] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
> [    0.677943] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
> [    0.677991] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
> [    0.678037] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
> [    0.678080] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
> [    0.678122] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
> [    0.678493] ACPI: Enabled 6 GPEs in block 00 to 3F
> [    0.678501] ACPI: \_SB_.PCI0: notify handler is installed
> [    0.678560] ACPI: \_SB_.CPBG: notify handler is installed
> [    0.678571] Found 2 acpi root devices
> [    0.678604] ACPI : EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> [    0.678714] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.678717] vgaarb: loaded
> [    0.678718] vgaarb: bridge control possible 0000:01:00.0
> [    0.678760] PCI: Using ACPI for IRQ routing
> [    0.688654] PCI: pci_cache_line_size set to 64 bytes
> [    0.688788] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
> [    0.688790] e820: reserve RAM buffer [mem 0x7b681000-0x7bffffff]
> [    0.688792] e820: reserve RAM buffer [mem 0x7b758000-0x7bffffff]
> [    0.688794] e820: reserve RAM buffer [mem 0x7b7e3000-0x7bffffff]
> [    0.688795] e820: reserve RAM buffer [mem 0x7b800000-0x7bffffff]
> [    0.688898] NetLabel: Initializing
> [    0.688899] NetLabel:  domain hash size = 128
> [    0.688900] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.688919] NetLabel:  unlabeled traffic allowed by default
> [    0.688949] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.688954] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.690986] Switched to clocksource hpet
> [    0.695899] pnp: PnP ACPI init
> [    0.695917] ACPI: bus type PNP registered
> [    0.717714] pnp 00:00: [dma 4]
> [    0.717752] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.717778] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
> [    0.717900] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.717939] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.717963] pnp 00:04: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.2 BAR 13 [io  0x1000-0x1fff]
> [    0.718003] system 00:04: [io  0x0680-0x069f] has been reserved
> [    0.718006] system 00:04: [io  0x0800-0x080f] has been reserved
> [    0.718008] system 00:04: [io  0xffff] has been reserved
> [    0.718010] system 00:04: [io  0xffff] has been reserved
> [    0.718013] system 00:04: [io  0x0400-0x047f] could not be reserved
> [    0.718015] system 00:04: [io  0x0500-0x057f] has been reserved
> [    0.718019] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.718051] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.718083] pnp 00:06: Plug and Play ACPI device, IDs SYN0716 SYN0700 SYN0002 PNP0f13 (active)
> [    0.718113] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.718606] pnp 00:08: disabling [mem 0xfffff000-0xffffffff] because it overlaps 0000:01:00.0 BAR 6 [mem 0xfff80000-0xffffffff pref]
> [    0.718638] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.718641] system 00:08: [mem 0xfed10000-0xfed13fff] has been reserved
> [    0.718643] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.718645] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.718648] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.718650] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.718652] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    0.718654] system 00:08: [mem 0xff000000-0xffffffff] could not be reserved
> [    0.718657] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
> [    0.718660] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.718708] pnp 00:09: Plug and Play ACPI device, IDs ENE0201 (active)
> [    0.718831] pnp: PnP ACPI: found 10 devices
> [    0.718833] ACPI: bus type PNP unregistered
> [    0.725668] pci 0000:01:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]
> [    0.725719] pci 0000:01:00.0: BAR 6: assigned [mem 0x93080000-0x930fffff pref]
> [    0.725723] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.725725] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
> [    0.725729] pci 0000:00:01.0:   bridge window [mem 0x92000000-0x930fffff]
> [    0.725732] pci 0000:00:01.0:   bridge window [mem 0x80000000-0x91ffffff 64bit pref]
> [    0.725736] pci 0000:00:1c.0: PCI bridge to [bus 02-05]
> [    0.725739] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
> [    0.725746] pci 0000:00:1c.0:   bridge window [mem 0x98100000-0x990fffff]
> [    0.725751] pci 0000:00:1c.0:   bridge window [mem 0x93100000-0x940fffff 64bit pref]
> [    0.725759] pci 0000:00:1c.1: PCI bridge to [bus 06]
> [    0.725762] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
> [    0.725769] pci 0000:00:1c.1:   bridge window [mem 0x97100000-0x980fffff]
> [    0.725774] pci 0000:00:1c.1:   bridge window [mem 0x94100000-0x950fffff 64bit pref]
> [    0.725782] pci 0000:00:1c.2: PCI bridge to [bus 07]
> [    0.725785] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
> [    0.725792] pci 0000:00:1c.2:   bridge window [mem 0x96100000-0x970fffff]
> [    0.725797] pci 0000:00:1c.2:   bridge window [mem 0x95100000-0x960fffff 64bit pref]
> [    0.725805] pci 0000:00:1e.0: PCI bridge to [bus 08]
> [    0.725821] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.725823] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.725825] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.725827] pci_bus 0000:00: resource 7 [mem 0x7c000000-0xfeafffff]
> [    0.725829] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
> [    0.725831] pci_bus 0000:01: resource 1 [mem 0x92000000-0x930fffff]
> [    0.725833] pci_bus 0000:01: resource 2 [mem 0x80000000-0x91ffffff 64bit pref]
> [    0.725835] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
> [    0.725837] pci_bus 0000:02: resource 1 [mem 0x98100000-0x990fffff]
> [    0.725839] pci_bus 0000:02: resource 2 [mem 0x93100000-0x940fffff 64bit pref]
> [    0.725841] pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
> [    0.725843] pci_bus 0000:06: resource 1 [mem 0x97100000-0x980fffff]
> [    0.725845] pci_bus 0000:06: resource 2 [mem 0x94100000-0x950fffff 64bit pref]
> [    0.725847] pci_bus 0000:07: resource 0 [io  0x1000-0x1fff]
> [    0.725849] pci_bus 0000:07: resource 1 [mem 0x96100000-0x970fffff]
> [    0.725851] pci_bus 0000:07: resource 2 [mem 0x95100000-0x960fffff 64bit pref]
> [    0.725854] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
> [    0.725856] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
> [    0.725858] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.725860] pci_bus 0000:08: resource 7 [mem 0x7c000000-0xfeafffff]
> [    0.725898] NET: Registered protocol family 2
> [    0.726091] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
> [    0.726161] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
> [    0.726250] TCP: Hash tables configured (established 16384 bind 16384)
> [    0.726281] TCP: reno registered
> [    0.726287] UDP hash table entries: 1024 (order: 3, 32768 bytes)
> [    0.726307] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
> [    0.726387] NET: Registered protocol family 1
> [    0.751130] pci 0000:01:00.0: Boot video device
> [    0.751191] PCI: CLS 64 bytes, default 64
> [    0.751240] Unpacking initramfs...
> [    0.830311] Freeing initrd memory: 3640K (ffff8800378d4000 - ffff880037c62000)
> [    0.830354] Simple Boot Flag at 0x44 set to 0x1
> [    0.830570] Scanning for low memory corruption every 60 seconds
> [    0.830914] audit: initializing netlink socket (disabled)
> [    0.830954] type=2000 audit(1386434366.563:1): initialized
> [    0.844182] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.845481] zbud: loaded
> [    0.845672] VFS: Disk quotas dquot_6.5.2
> [    0.845718] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.845899] msgmni has been set to 3860
> [    0.846287] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.846349] io scheduler noop registered
> [    0.846351] io scheduler deadline registered
> [    0.846381] io scheduler cfq registered (default)
> [    0.846596] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
> [    0.847065] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.847080] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.847127] vesafb: mode is 640x480x32, linelength=2560, pages=0
> [    0.847128] vesafb: scrolling: redraw
> [    0.847130] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    0.847251] vesafb: framebuffer at 0x91000000, mapped to 0xffffc90010400000, using 1216k, total 1216k
> [    0.888867] Console: switching to colour frame buffer device 80x30
> [    0.929312] fb0: VESA VGA frame buffer device
> [    0.929324] intel_idle: MWAIT substates: 0x1120
> [    0.929326] intel_idle: v0.4 model 0x25
> [    0.929327] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    0.929481] GHES: HEST is not enabled!
> [    0.929543] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    0.930041] Linux agpgart interface v0.103
> [    0.930113] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:MSS0] at 0x60,0x64 irq 1,12
> [    0.930126] i8042: [0] d1 -> i8042 (command)
> [    0.930132] i8042: [0] df -> i8042 (parameter)
> [    0.930138] i8042: [0] ff -> i8042 (command)
> [    0.930198] i8042: [0] 23 <- i8042 (flush, kbd)
> [    0.930222] i8042: [0] 20 -> i8042 (command)
> [    0.930231] i8042: [0] 67 <- i8042 (return)
> [    0.930285] i8042: [0] 20 -> i8042 (command)
> [    0.930293] i8042: [0] 67 <- i8042 (return)
> [    0.930300] i8042: [0] 60 -> i8042 (command)
> [    0.932731] i8042: [0] 76 -> i8042 (parameter)
> [    0.935388] i8042: [1] d3 -> i8042 (command)
> [    0.938557] i8042: [1] 5a -> i8042 (parameter)
> [    0.938565] i8042: [1]      -- i8042 (auxerr)
> [    0.940211] i8042: [3] a9 -> i8042 (command)
> [    0.940219] i8042: [3] 23 <- i8042 (return)
> [    0.940239] i8042: [3] Interrupt 1, without any data
> [    0.943719] i8042: [4] 60 -> i8042 (command)
> [    0.946731] i8042: [4] 67 -> i8042 (parameter)
> [    0.946743] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.946867] mousedev: PS/2 mouse device common for all mice
> [    0.948785] i8042: [6] f2 -> i8042 (kbd-data)
> [    0.948796] i8042: [6] 00 <- i8042 (interrupt, 0, 1)
> [    0.948854] rtc_cmos 00:05: RTC can wake from S4
> [    0.949019] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [    0.949053] rtc_cmos 00:05: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
> [    0.949134] drop_monitor: Initializing network drop monitor service
> [    0.949204] TCP: cubic registered
> [    0.949326] NET: Registered protocol family 10
> [    0.949533] NET: Registered protocol family 17
> [    0.949546] Key type dns_resolver registered
> [    0.949901] registered taskstats version 1
> [    0.950565]   Magic number: 9:392:691
> [    0.957376] i8042: [7] 60 -> i8042 (command)
> [    0.960548] i8042: [9] 66 -> i8042 (parameter)
> [    0.960567] rtc_cmos 00:05: setting system clock to 2013-12-07 16:39:27 UTC (1386434367)
> [    0.960628] PM: Hibernation image not present or could not be loaded.
> [    0.962636] i8042: [9] 60 -> i8042 (command)
> [    0.965649] i8042: [11] 67 -> i8042 (parameter)
> [    0.965670] i8042: [11] 5a <- i8042 (interrupt, 1, 0)
> [    0.966669] Freeing unused kernel memory: 1160K (ffffffff818cd000 - ffffffff819ef000)
> [    0.966672] Write protecting the kernel read-only data: 8192k
> [    0.967662] i8042: [12] fa <- i8042 (interrupt, 0, 1)
> [    0.968027] i8042: [12] f2 -> i8042 (kbd-data)
> [    0.968249] i8042: [12] ab <- i8042 (interrupt, 0, 1)
> [    0.969630] Freeing unused kernel memory: 980K (ffff88000150b000 - ffff880001600000)
> [    0.970570] Freeing unused kernel memory: 320K (ffff8800017b0000 - ffff880001800000)
> [    0.976683] i8042: [14] fa <- i8042 (interrupt, 0, 1)
> [    0.978343] i8042: [15] ab <- i8042 (interrupt, 0, 1)
> [    0.978930] systemd-udevd[57]: starting version 208
> [    0.980041] i8042: [15] 41 <- i8042 (interrupt, 0, 1)
> [    0.980057] i8042: [15] f5 -> i8042 (kbd-data)
> [    0.981681] i8042: [16] 23 <- i8042 (interrupt, 0, 1)
> [    0.982631] [drm] Initialized drm 1.1.0 20060810
> [    0.983985] wmi: Mapper loaded
> [    0.984709] i8042: [17] fa <- i8042 (interrupt, 0, 1)
> [    0.984736] i8042: [17] ed -> i8042 (kbd-data)
> [    0.984739] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
> [    0.986132] i8042: [17] 23 <- i8042 (interrupt, 0, 1)
> [    0.989692] i8042: [18] fa <- i8042 (interrupt, 0, 1)
> [    0.989721] i8042: [18] 00 -> i8042 (kbd-data)
> [    0.994055] i8042: [19] fa <- i8042 (interrupt, 0, 1)
> [    0.994079] i8042: [19] f3 -> i8042 (kbd-data)
> [    1.000465] i8042: [21] fa <- i8042 (interrupt, 0, 1)
> [    1.000485] i8042: [21] 00 -> i8042 (kbd-data)
> [    1.006166] i8042: [23] fa <- i8042 (interrupt, 0, 1)
> [    1.006204] i8042: [23] f4 -> i8042 (kbd-data)
> [    1.012989] i8042: [25] fa <- i8042 (interrupt, 0, 1)
> [    1.013139] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    1.020504] i8042: [27] 23 <- i8042 (interrupt, 0, 1)
> [    1.026812] acpi device:0b: registered as cooling_device0
> [    1.026938] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:09/LNXVIDEO:01/input/input2
> [    1.028000] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0e/PNP0C0C:00/input/input3
> [    1.028005] ACPI: Power Button [PWRB]
> [    1.028046] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0e/PNP0C0E:00/input/input4
> [    1.028049] ACPI: Sleep Button [SLPB]
> [    1.028109] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0e/PNP0C0D:00/input/input5
> [    1.028143] ACPI: Lid Switch [LID0]
> [    1.028204] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
> [    1.028207] ACPI: Power Button [PWRF]
> [    1.032472] checking generic (91000000 130000) vs hw (80000000 10000000)
> [    1.032476] checking generic (91000000 130000) vs hw (90000000 2000000)
> [    1.032477] fb: conflicting fb hw usage nouveaufb vs VESA VGA - removing generic driver
> [    1.032495] Console: switching to colour dummy device 80x25
> [    1.033206] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0a5a00a2
> [    1.033210] nouveau  [  DEVICE][0000:01:00.0] Chipset: GT216 (NVA5)
> [    1.033212] nouveau  [  DEVICE][0000:01:00.0] Family : NV50
> [    1.034746] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
> [    1.090203] i8042: [48] a3 <- i8042 (interrupt, 0, 1)
> [    1.164871] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
> [    1.164874] nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
> [    1.165013] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
> [    1.165016] nouveau  [   VBIOS][0000:01:00.0] version 70.16.1c.00.21
> [    1.186752] nouveau 0000:01:00.0: irq 41 for MSI/MSI-X
> [    1.186768] nouveau  [     PMC][0000:01:00.0] MSI interrupts enabled
> [    1.186808] nouveau  [     PFB][0000:01:00.0] RAM type: DDR3
> [    1.186810] nouveau  [     PFB][0000:01:00.0] RAM size: 1024 MiB
> [    1.186812] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 1920 tags
> [    1.193268] nouveau  [    VOLT][0000:01:00.0] GPU voltage: 850000uv
> [    1.216778] nouveau  [  PTHERM][0000:01:00.0] FAN control: none / external
> [    1.216786] nouveau  [  PTHERM][0000:01:00.0] fan management: automatic
> [    1.216793] nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
> [    1.216865] nouveau  [     CLK][0000:01:00.0] 03: core 135 MHz shader 270 MHz memory 135 MHz
> [    1.216868] nouveau  [     CLK][0000:01:00.0] 07: core 405 MHz shader 810 MHz memory 324 MHz
> [    1.216872] nouveau  [     CLK][0000:01:00.0] 0f: core 550 MHz shader 1210 MHz memory 790 MHz
> [    1.216915] nouveau  [     CLK][0000:01:00.0] --: core 405 MHz shader 810 MHz memory 324 MHz
> [    1.217077] [TTM] Zone  kernel: Available graphics memory: 989576 kiB
> [    1.217079] [TTM] Initializing pool allocator
> [    1.217088] [TTM] Initializing DMA pool allocator
> [    1.217100] nouveau  [     DRM] VRAM: 1024 MiB
> [    1.217102] nouveau  [     DRM] GART: 1048576 MiB
> [    1.217105] nouveau  [     DRM] TMDS table version 2.0
> [    1.217107] nouveau  [     DRM] DCB version 4.0
> [    1.217110] nouveau  [     DRM] DCB outp 00: 01010323 00010034
> [    1.217112] nouveau  [     DRM] DCB outp 01: 02001300 00000000
> [    1.217114] nouveau  [     DRM] DCB outp 02: 02022362 00020010
> [    1.217115] nouveau  [     DRM] DCB conn 00: 00000040
> [    1.217117] nouveau  [     DRM] DCB conn 01: 00000100
> [    1.217119] nouveau  [     DRM] DCB conn 02: 00002261
> [    1.262069] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    1.262071] [drm] No driver support for vblank timestamp query.
> [    1.262074] nouveau  [     DRM] ACPI backlight interface available, not registering our own
> [    1.312004] nouveau  [     DRM] MM: using COPY for buffer copies
> [    1.378061] nouveau  [     DRM] allocated 1366x768 fb: 0x70000, bo ffff880076b12400
> [    1.378412] fbcon: nouveaufb (fb0) is primary device
> [    1.830558] tsc: Refined TSC clocksource calibration: 2128.004 MHz
> [    2.720296] Console: switching to colour frame buffer device 170x48
> [    2.720896] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
> [    2.720898] nouveau 0000:01:00.0: registered panic notifier
> [    2.720904] [drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00.0 on minor 0
> [    2.781027] SCSI subsystem initialized
> [    2.785979] ACPI: bus type USB registered
> [    2.786039] usbcore: registered new interface driver usbfs
> [    2.786061] usbcore: registered new interface driver hub
> [    2.786522] usbcore: registered new device driver usb
> [    2.787074] libata version 3.00 loaded.
> [    2.788578] ahci 0000:00:1f.2: version 3.0
> [    2.788891] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
> [    2.788948] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
> [    2.789000] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x13 impl SATA mode
> [    2.789007] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst
> [    2.789274] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    2.789510] ehci-pci: EHCI PCI platform driver
> [    2.803104] scsi0 : ahci
> [    2.803592] scsi1 : ahci
> [    2.803715] scsi2 : ahci
> [    2.804500] scsi3 : ahci
> [    2.805114] scsi4 : ahci
> [    2.805363] ata1: SATA max UDMA/133 abar m2048@0x99105000 port 0x99105100 irq 42
> [    2.805422] ata2: SATA max UDMA/133 abar m2048@0x99105000 port 0x99105180 irq 42
> [    2.805425] ata3: DUMMY
> [    2.805427] ata4: DUMMY
> [    2.805432] ata5: SATA max UDMA/133 abar m2048@0x99105000 port 0x99105300 irq 42
> [    2.805663] ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    2.805676] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    2.805696] ehci-pci 0000:00:1a.0: debug port 2
> [    2.809687] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
> [    2.809710] ehci-pci 0000:00:1a.0: irq 16, io mem 0x99105c00
> [    2.816769] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    2.816979] hub 1-0:1.0: USB hub found
> [    2.816988] hub 1-0:1.0: 3 ports detected
> [    2.817239] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    2.817246] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    2.817260] ehci-pci 0000:00:1d.0: debug port 2
> [    2.821197] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> [    2.821219] ehci-pci 0000:00:1d.0: irq 23, io mem 0x99105800
> [    2.830120] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    2.830223] Switched to clocksource tsc
> [    2.830611] hub 2-0:1.0: USB hub found
> [    2.830632] hub 2-0:1.0: 3 ports detected
> [    3.123413] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    3.126695] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    3.127390] ata1.00: ATA-9: OCZ-VERTEX4, 1.5, max UDMA/133
> [    3.127398] ata1.00: 250069680 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    3.128201] ata1.00: configured for UDMA/133
> [    3.128425] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX4      1.5  PQ: 0 ANSI: 5
> [    3.247461] hub 1-1:1.0: USB hub found
> [    3.247625] hub 1-1:1.0: 6 ports detected
> [    3.353282] usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    3.446596] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    3.459677] ata2.00: ATAPI: Optiarc DVD RW AD-7580S, F820, max UDMA/100
> [    3.474591] ata2.00: configured for UDMA/100
> [    3.477642] hub 2-1:1.0: USB hub found
> [    3.477746] hub 2-1:1.0: 8 ports detected
> [    3.477899] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7580S  F820 PQ: 0 ANSI: 5
> [    3.546651] usb 1-1.4: new full-speed USB device number 3 using ehci-pci
> [    3.743314] usb 2-1.3: new high-speed USB device number 3 using ehci-pci
> [    3.796436] ata5: SATA link down (SStatus 0 SControl 300)
> [    3.800088] sd 0:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
> [    3.800206] sd 0:0:0:0: [sda] Write Protect is off
> [    3.800215] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.800282] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.803451]  sda: sda1 sda2 sda3
> [    3.804130] sd 0:0:0:0: [sda] Attached SCSI disk
> [    3.804470] sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
> [    3.804474] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    3.804735] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    4.195399] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
> [    4.270424] systemd[1]: systemd 208 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
> [    4.271582] systemd[1]: Set hostname to <o2pc>.
> [    4.274329] random: systemd urandom read with 72 bits of entropy available
> [    4.341107] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory.
> [    4.341540] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
> [    4.341661] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
> [    4.341689] systemd[1]: Starting Remote File Systems.
> [    4.341713] systemd[1]: Reached target Remote File Systems.
> [    4.341732] systemd[1]: Starting Device-mapper event daemon FIFOs.
> [    4.341791] systemd[1]: Listening on Device-mapper event daemon FIFOs.
> [    4.341810] systemd[1]: Starting LVM2 metadata daemon socket.
> [    4.341863] systemd[1]: Listening on LVM2 metadata daemon socket.
> [    4.341882] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
> [    4.341918] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
> [    4.341936] systemd[1]: Starting Delayed Shutdown Socket.
> [    4.341976] systemd[1]: Listening on Delayed Shutdown Socket.
> [    4.342035] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
> [    4.342219] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
> [    4.342248] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
> [    4.342315] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
> [    4.342334] systemd[1]: Starting Paths.
> [    4.342355] systemd[1]: Reached target Paths.
> [    4.342372] systemd[1]: Starting Encrypted Volumes.
> [    4.342391] systemd[1]: Reached target Encrypted Volumes.
> [    4.342414] systemd[1]: Starting udev Kernel Socket.
> [    4.342454] systemd[1]: Listening on udev Kernel Socket.
> [    4.342476] systemd[1]: Starting udev Control Socket.
> [    4.342518] systemd[1]: Listening on udev Control Socket.
> [    4.342540] systemd[1]: Starting Journal Socket.
> [    4.342625] systemd[1]: Listening on Journal Socket.
> [    4.342666] systemd[1]: Mounting Huge Pages File System...
> [    4.344185] systemd[1]: Started Set Up Additional Binary Formats.
> [    4.344231] systemd[1]: Starting udev Coldplug all Devices...
> [    4.344940] systemd[1]: Mounting Debug File System...
> [    4.346524] systemd[1]: Starting Apply Kernel Variables...
> [    4.347091] systemd[1]: Starting Setup Virtual Console...
> [    4.353930] systemd[1]: Starting Create list of required static device nodes for the current kernel...
> [    4.354487] systemd[1]: Mounting POSIX Message Queue File System...
> [    4.357367] systemd[1]: Starting Load Kernel Modules...
> [    4.357702] systemd[1]: Starting Journal Service...
> [    4.358782] systemd[1]: Started Journal Service.
> [    4.371482] EXT4-fs (sda2): re-mounted. Opts: discard
> [    4.375670] i2c /dev entries driver
> [    4.376362] systemd-journald[132]: Vacuuming done, freed 0 bytes
> [    4.400629] ACPI Warning: 0x0000000000005000-0x000000000000501f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20131115/utaddress-251)
> [    4.400637] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    4.429366] systemd-udevd[157]: starting version 208
> [    4.434254] systemd-journald[132]: Received request to flush runtime journal from PID 1
> [    4.527006] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [    4.533311] ene_ir: chip is 0x3926 - kbver = 0x00, rev = 0xd2
> [    4.533313] ene_ir: PLL freq = 1000
> [    4.533315] ene_ir: KB3926D or higher detected
> [    4.533330] ene_ir: Firmware regs: cc 00
> [    4.533331] ene_ir: Hardware features:
> [    4.533332] ene_ir: * Uses GPIO 40 for IR demodulated input
> [    4.533333] ene_ir: * Uses new style input buffer
> [    4.533381] ene_ir: Hardware uses 2 extended buffers:
> [    4.533382] ene_ir:   0xfa48 - len : 15
> [    4.533384] ene_ir:   0xfa00 - len : 17
> [    4.533385] ene_ir: Total buffer len = 40
> [    4.538176] ACPI: AC Adapter [ACAD] (on-line)
> [    4.555652] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
> [    4.557643] ACPI : EC: GPE storm detected(9 GPEs), transactions will use polling mode
> [    4.559700] Registered IR keymap rc-rc6-mce
> [    4.560655] input: ENE eHome Infrared Remote Receiver as /devices/virtual/rc/rc0/input7
> [    4.560923] rc0: ENE eHome Infrared Remote Receiver as /devices/virtual/rc/rc0
> [    4.566518] IR RC6 protocol handler initialized
> [    4.566814] IR RC5(x) protocol handler initialized
> [    4.567212] IR JVC protocol handler initialized
> [    4.569200] IR NEC protocol handler initialized
> [    4.570794] pps_core: LinuxPPS API ver. 1 registered
> [    4.570798] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    4.571733] IR MCE Keyboard/mouse protocol handler initialized
> [    4.571838] IR SANYO protocol handler initialized
> [    4.571976] input: MCE IR Keyboard/Mouse (ene_ir) as /devices/virtual/input/input8
> [    4.572324] PTP clock support registered
> [    4.573220] ene_ir: driver has been successfully loaded
> [    4.574320] IR Sony protocol handler initialized
> [    4.576848] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
> [    4.578547] lirc_dev: IR Remote Control driver registered, major 249
> [    4.580568] tg3.c:v3.134 (Sep 16, 2013)
> [    4.582159] rc rc0: lirc_dev: driver ir-lirc-codec (ene_ir) registered at minor = 0
> [    4.582166] IR LIRC bridge handler initialized
> [    4.587881] cfg80211: Calling CRDA to update world regulatory domain
> [    4.589851] input: HDA Intel MID Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
> [    4.590134] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [    4.593140] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20131115/utaddress-251)
> [    4.593148] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    4.593154] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
> [    4.593158] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    4.593160] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
> [    4.593165] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    4.593167] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
> [    4.593171] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    4.593173] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [    4.593242] libphy: tg3 mdio bus: probed
> [    4.593957] hda_intel: Disabling MSI
> [    4.593964] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
> [    4.603384] tg3 0000:07:00.0 eth0: Tigon3 [partno(BCM57780) rev 57780001] (PCI Express) MAC address 70:5a:b6:5f:4c:c4
> [    4.603388] tg3 0000:07:00.0 eth0: attached PHY driver [Broadcom BCM57780] (mii_bus:phy_addr=700:01)
> [    4.603391] tg3 0000:07:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
> [    4.603393] tg3 0000:07:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-bit]
> [    4.618176] microcode: CPU0 sig=0x20652, pf=0x10, revision=0x9
> [    4.624032] platform microcode: Direct firmware load failed with error -2
> [    4.624038] platform microcode: Falling back to user helper
> [    4.631780] ideapad_slidebar: Laptop model 'Lenovo IdeaPad Y550P'
> [    4.672633] Adding 4190204k swap on /dev/sda3.  Priority:-1 extents:1 across:4190204k SSFS
> [    4.696164] ACPI: Invalid active0 threshold
> [    4.701631] ath: phy0: Enable LNA combining
> [    4.704418] ath: phy0: ASPM enabled: 0x43
> [    4.704422] ath: EEPROM regdomain: 0x6a
> [    4.704424] ath: EEPROM indicates we should expect a direct regpair map
> [    4.704427] ath: Country alpha2 being used: 00
> [    4.704428] ath: Regpair used: 0x6a
> [    4.709441] input: Ideapad extra buttons as /devices/platform/VPC2004:00/input/input12
> [    4.716028] random: nonblocking pool is initialized
> [    4.717198] Bluetooth: Core ver 2.17
> [    4.717218] NET: Registered protocol family 31
> [    4.717220] Bluetooth: HCI device and connection manager initialized
> [    4.717231] Bluetooth: HCI socket layer initialized
> [    4.717234] Bluetooth: L2CAP socket layer initialized
> [    4.717240] Bluetooth: SCO socket layer initialized
> [    4.719068] usbcore: registered new interface driver btusb
> [    4.719106] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [    4.719425] ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xffffc90015200000, irq=17
> [    4.727739] media: Linux media interface: v0.10
> [    4.731785] Linux video capture interface: v2.00
> [    4.740364] uvcvideo: Found UVC 1.00 device Lenovo EasyCamera (090c:7371)
> [    4.796054] thermal LNXTHERM:00: registered as thermal_zone0
> [    4.796059] ACPI: Thermal Zone [TZ00] (51 C)
> [    4.801246] iTCO_vendor_support: vendor-support=0
> [    4.803147] microcode: CPU1 sig=0x20652, pf=0x10, revision=0x9
> [    4.803165] platform microcode: Direct firmware load failed with error -2
> [    4.803168] platform microcode: Falling back to user helper
> [    4.803903] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
> [    4.804016] iTCO_wdt: Found a HM55 TCO device (Version=2, TCOBASE=0x0460)
> [    4.804188] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    4.816117] systemd-udevd[171]: renamed network interface eth0 to enp7s0
> [    4.827947] microcode: CPU2 sig=0x20652, pf=0x10, revision=0x9
> [    4.827967] platform microcode: Direct firmware load failed with error -2
> [    4.827969] platform microcode: Falling back to user helper
> [    4.832522] systemd-udevd[174]: renamed network interface wlan0 to wlp6s0
> [    4.833834] microcode: CPU3 sig=0x20652, pf=0x10, revision=0x9
> [    4.833865] platform microcode: Direct firmware load failed with error -2
> [    4.833871] platform microcode: Falling back to user helper
> [    4.836900] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    4.859130] kvm: disabled by bios
> [    4.919434] input: Lenovo EasyCamera as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input13
> [    4.919720] usbcore: registered new interface driver uvcvideo
> [    4.919725] USB Video Class driver (1.1.1)
> [    5.269471] ACPI: Battery Slot [BAT1] (battery present)
> [    5.275917] input: HDA NVidia HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
> [    5.276022] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
> [    5.276113] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
> [    5.276200] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
> [    5.336683] IPv6: ADDRCONF(NETDEV_UP): wlp6s0: link is not ready
> [    5.339221] tg3 0000:07:00.0: irq 44 for MSI/MSI-X
> [    5.360249] IPv6: ADDRCONF(NETDEV_UP): enp7s0: link is not ready
> [    5.405775] i8042: [1344] a8 -> i8042 (command)
> [    5.405928] input: PC Speaker as /devices/platform/pcspkr/input/input18
> [    5.406262] input: IdeaPad Slidebar as /devices/platform/ideapad_slidebar/input/input19
> [    5.603395] tg3 0000:07:00.0 enp7s0: Link is down
>
>
> On 12/07/2013 08:02 PM, Dmitry Torokhov wrote:
>> On Sat, Dec 07, 2013 at 05:47:09PM +0400, Andrey Moiseev wrote:
>>> I inserted a printk into ps2_handle_response(struct ps2dev *ps2dev,
>>> unsigned char data) in "drivers/input/serio/libps2.c" and other
>>> functions in the file.
>>> It really eats scancodes from the keyboard, as I see (0x23 is the 'H'
>>> press scancode). Seems like the scancodes are mixed with reasonable
>>> values. Is it a bug in the controller?
>>
>> Not necessarily... Can you boot with i8042.debug=1 and post full dmesg?
>>
>> Thanks.
>>
>
