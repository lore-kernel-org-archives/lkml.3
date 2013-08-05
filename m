Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3HEQrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:47:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44219 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab3HEQru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:47:50 -0400
Date: Mon, 5 Aug 2013 18:47:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Laszlo Ersek <lersek@redhat.com>
Cc: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130805164731.GG31845@pd.tnic>
References: <20130801164927.GA7445@pd.tnic>
 <51FF8C14.2070405@redhat.com>
 <20130805130258.GB31845@pd.tnic>
 <51FFAB13.4090603@redhat.com>
 <20130805140306.GD31845@pd.tnic>
 <51FFB660.4060400@redhat.com>
 <20130805144010.GE31845@pd.tnic>
 <51FFC19A.1020204@redhat.com>
 <20130805161247.GF31845@pd.tnic>
 <51FFD5B0.9080000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51FFD5B0.9080000@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 06:41:20PM +0200, Laszlo Ersek wrote:
> I didn't realize the timestamps survive kexec. (As far as I remember
> the kernels I played with kexec on didn't have the automatic
> timestamps yet in dmesg, but I might have messed up just as well...)

No, no, no, kexec is not involved at all.

Here's the whole dmesg up until efi_enter_virtual_map. When we have entered
efi_enter_virtual_mode, the region has changed from

[    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)

to

[    0.023004] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0ad000) (0MB)


And yes, I still need to audit whether the kernel actually does that
change. I'm still looking...


[2J[01;01H[=3h[2J[01;01H[2J[01;01H[=3h[2J[01;01H[2J[01;01H[=3h[2J[01;01H[2J[01;01H[=3h[2J[01;01H[2J[01;01H[=3h[2J[01;01H[2J[01;01H[=3h[2J[01;01H[0m[35m[40m[2J[01;01H[=3h[2J[01;01H[0m[37m[40m[2J[01;01Hearly console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc7+ (boris@nazgul) (gcc version 4.7.3 (Debian 4.7.3-4) ) #9 SMP PREEMPT Mon Aug 5 16:27:00 CEST 2013
[    0.000000] Command line: root=/dev/sda1 debug ignore_loglevel log_buf_len=10M earlyprintk=ttyS0,115200 console=ttyS0,115200 console=tty0
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007e667fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007e668000-0x000000007e691fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007e692000-0x000000007fb11fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fb12000-0x000000007fb69fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007fb6a000-0x000000007fb71fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007fb72000-0x000000007fb75fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007fb76000-0x000000007ffdffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ffe0000-0x000000007fffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by EDK II
[    0.000000] efi:  ACPI=0x7fb71000  ACPI 2.0=0x7fb71014 
[    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000009f000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x000000000009f000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000100000-0x0000000000800000) (7MB)
[    0.000000] efi: mem03: type=4, attr=0xf, range=[0x0000000000800000-0x0000000001000000) (8MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000001000000-0x0000000002000000) (16MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000002000000-0x00000000036e3000) (22MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x00000000036e3000-0x000000003fffb000) (969MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x000000003fffb000-0x0000000040000000) (0MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000040000000-0x000000007c000000) (960MB)
[    0.000000] efi: mem09: type=4, attr=0xf, range=[0x000000007c000000-0x000000007c020000) (0MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
[    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)
[    0.000000] efi: mem13: type=4, attr=0xf, range=[0x000000007e0cd000-0x000000007e55d000) (4MB)
[    0.000000] efi: mem14: type=3, attr=0xf, range=[0x000000007e55d000-0x000000007e59c000) (0MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x000000007e59c000-0x000000007e5a0000) (0MB)
[    0.000000] efi: mem16: type=3, attr=0xf, range=[0x000000007e5a0000-0x000000007e668000) (0MB)
[    0.000000] efi: mem17: type=5, attr=0x800000000000000f, range=[0x000000007e668000-0x000000007e67d000) (0MB)
[    0.000000] efi: mem18: type=6, attr=0x800000000000000f, range=[0x000000007e67d000-0x000000007e692000) (0MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x000000007e692000-0x000000007f992000) (19MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x000000007f992000-0x000000007f994000) (0MB)
[    0.000000] efi: mem21: type=3, attr=0xf, range=[0x000000007f994000-0x000000007fb12000) (1MB)
[    0.000000] efi: mem22: type=5, attr=0x800000000000000f, range=[0x000000007fb12000-0x000000007fb42000) (0MB)
[    0.000000] efi: mem23: type=6, attr=0x800000000000000f, range=[0x000000007fb42000-0x000000007fb66000) (0MB)
[    0.000000] efi: mem24: type=0, attr=0xf, range=[0x000000007fb66000-0x000000007fb6a000) (0MB)
[    0.000000] efi: mem25: type=9, attr=0xf, range=[0x000000007fb6a000-0x000000007fb72000) (0MB)
[    0.000000] efi: mem26: type=10, attr=0xf, range=[0x000000007fb72000-0x000000007fb76000) (0MB)
[    0.000000] efi: mem27: type=4, attr=0xf, range=[0x000000007fb76000-0x000000007ffe0000) (4MB)
[    0.000000] efi: mem28: type=6, attr=0x800000000000000f, range=[0x000000007ffe0000-0x0000000080000000) (0MB)
[    0.000000] DMI not present or invalid.
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x7ffe0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] efi: efi_reserve_boot_services: start: 0x800000, size: 0x800000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7c000000, size: 0x20000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7e0cd000, size: 0x490000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7e55d000, size: 0x3f000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7e59c000, size: 0x4000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7e5a0000, size: 0xc8000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7e692000, size: 0x1300000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7f994000, size: 0x17e000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7fb76000, size: 0x46a000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x036be000, 0x036befff] PGTABLE
[    0.000000] BRK [0x036bf000, 0x036bffff] PGTABLE
[    0.000000] BRK [0x036c0000, 0x036c0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7de00000-0x7dffffff]
[    0.000000]  [mem 0x7de00000-0x7dffffff] page 2M
[    0.000000] BRK [0x036c1000, 0x036c1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7c000000-0x7ddfffff]
[    0.000000]  [mem 0x7c000000-0x7ddfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x7e000000-0x7e667fff]
[    0.000000]  [mem 0x7e000000-0x7e5fffff] page 2M
[    0.000000]  [mem 0x7e600000-0x7e667fff] page 4k
[    0.000000] BRK [0x036c2000, 0x036c2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7e692000-0x7fb11fff]
[    0.000000]  [mem 0x7e692000-0x7e7fffff] page 4k
[    0.000000]  [mem 0x7e800000-0x7f9fffff] page 2M
[    0.000000]  [mem 0x7fa00000-0x7fb11fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7fb76000-0x7ffdffff]
[    0.000000]  [mem 0x7fb76000-0x7fbfffff] page 4k
[    0.000000]  [mem 0x7fc00000-0x7fdfffff] page 2M
[    0.000000]  [mem 0x7fe00000-0x7ffdffff] page 4k
[    0.000000] log_buf_len: 16777216
[    0.000000] early log buf free: 2089788(99%)
[    0.000000] ACPI: RSDP 000000007fb71014 00024 (v02 OVMF  )
[    0.000000] ACPI: XSDT 000000007fb700e8 0003C (v01 OVMF   OVMFEDK2 20130221      01000013)
[    0.000000] ACPI: FACP 000000007fb6f000 000F4 (v03 OVMF   OVMFEDK2 20130221 OVMF 00000099)
[    0.000000] ACPI: DSDT 000000007fb6d000 00D57 (v01 INTEL  OVMF     00000004 INTL 20100528)
[    0.000000] ACPI: FACS 000000007fb75000 00040
[    0.000000] ACPI: APIC 000000007fb6e000 00078 (v01 OVMF   OVMFEDK2 20130221 OVMF 00000099)
[    0.000000] ACPI: SSDT 000000007fb6c000 00057 (v01 REDHAT OVMF     00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000007ffdffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x7ffdffff]
[    0.000000]   NODE_DATA [mem 0x7e0ca000-0x7e0cbfff]
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007a000000-ffff88007bffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x7e667fff]
[    0.000000]   node   0: [mem 0x7e692000-0x7fb11fff]
[    0.000000]   node   0: [mem 0x7fb76000-0x7ffdffff]
[    0.000000] On node 0 totalpages: 524017
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 2070 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8128 pages used for memmap
[    0.000000]   DMA32 zone: 520018 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007e668000 - 000000007e692000
[    0.000000] PM: Registered nosave memory: 000000007fb12000 - 000000007fb6a000
[    0.000000] PM: Registered nosave memory: 000000007fb6a000 - 000000007fb72000
[    0.000000] PM: Registered nosave memory: 000000007fb72000 - 000000007fb76000
[    0.000000] e820: [mem 0x80000000-0xffffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007ce00000 s84736 r8192 d21760 u2097152
[    0.000000] pcpu-alloc: s84736 r8192 d21760 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 513755
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda1 debug ignore_loglevel log_buf_len=10M earlyprintk=ttyS0,115200 console=ttyS0,115200 console=tty0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1983624k/2097024k available (5838k kernel code, 956k absent, 112444k reserved, 5274k data, 1080k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=1.
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc7+ (boris@nazgul) (gcc version 4.7.3 (Debian 4.7.3-4) ) #9 SMP PREEMPT Mon Aug 5 16:27:00 CEST 2013
[    0.000000] Command line: root=/dev/sda1 debug ignore_loglevel log_buf_len=10M earlyprintk=ttyS0,115200 console=ttyS0,115200 console=tty0
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007e667fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007e668000-0x000000007e691fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007e692000-0x000000007fb11fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fb12000-0x000000007fb69fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007fb6a000-0x000000007fb71fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007fb72000-0x000000007fb75fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007fb76000-0x000000007ffdffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ffe0000-0x000000007fffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by EDK II
[    0.000000] efi:  ACPI=0x7fb71000  ACPI 2.0=0x7fb71014 
[    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000009f000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x000000000009f000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000100000-0x0000000000800000) (7MB)
[    0.000000] efi: mem03: type=4, attr=0xf, range=[0x0000000000800000-0x0000000001000000) (8MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000001000000-0x0000000002000000) (16MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000002000000-0x00000000036e3000) (22MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x00000000036e3000-0x000000003fffb000) (969MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x000000003fffb000-0x0000000040000000) (0MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000040000000-0x000000007c000000) (960MB)
[    0.000000] efi: mem09: type=4, attr=0xf, range=[0x000000007c000000-0x000000007c020000) (0MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
[    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)
[    0.000000] efi: mem13: type=4, attr=0xf, range=[0x000000007e0cd000-0x000000007e55d000) (4MB)
[    0.000000] efi: mem14: type=3, attr=0xf, range=[0x000000007e55d000-0x000000007e59c000) (0MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x000000007e59c000-0x000000007e5a0000) (0MB)
[    0.000000] efi: mem16: type=3, attr=0xf, range=[0x000000007e5a0000-0x000000007e668000) (0MB)
[    0.000000] efi: mem17: type=5, attr=0x800000000000000f, range=[0x000000007e668000-0x000000007e67d000) (0MB)
[    0.000000] efi: mem18: type=6, attr=0x800000000000000f, range=[0x000000007e67d000-0x000000007e692000) (0MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x000000007e692000-0x000000007f992000) (19MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x000000007f992000-0x000000007f994000) (0MB)
[    0.000000] efi: mem21: type=3, attr=0xf, range=[0x000000007f994000-0x000000007fb12000) (1MB)
[    0.000000] efi: mem22: type=5, attr=0x800000000000000f, range=[0x000000007fb12000-0x000000007fb42000) (0MB)
[    0.000000] efi: mem23: type=6, attr=0x800000000000000f, range=[0x000000007fb42000-0x000000007fb66000) (0MB)
[    0.000000] efi: mem24: type=0, attr=0xf, range=[0x000000007fb66000-0x000000007fb6a000) (0MB)
[    0.000000] efi: mem25: type=9, attr=0xf, range=[0x000000007fb6a000-0x000000007fb72000) (0MB)
[    0.000000] efi: mem26: type=10, attr=0xf, range=[0x000000007fb72000-0x000000007fb76000) (0MB)
[    0.000000] efi: mem27: type=4, attr=0xf, range=[0x000000007fb76000-0x000000007ffe0000) (4MB)
[    0.000000] efi: mem28: type=6, attr=0x800000000000000f, range=[0x000000007ffe0000-0x0000000080000000) (0MB)
[    0.000000] DMI not present or invalid.
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x7ffe0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] efi: efi_reserve_boot_services: start: 0x800000, size: 0x800000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7c000000, size: 0x20000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7e0cd000, size: 0x490000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7e55d000, size: 0x3f000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7e59c000, size: 0x4000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7e5a0000, size: 0xc8000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7e692000, size: 0x1300000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7f994000, size: 0x17e000
[    0.000000] efi: efi_reserve_boot_services: start: 0x7fb76000, size: 0x46a000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x036be000, 0x036befff] PGTABLE
[    0.000000] BRK [0x036bf000, 0x036bffff] PGTABLE
[    0.000000] BRK [0x036c0000, 0x036c0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7de00000-0x7dffffff]
[    0.000000]  [mem 0x7de00000-0x7dffffff] page 2M
[    0.000000] BRK [0x036c1000, 0x036c1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7c000000-0x7ddfffff]
[    0.000000]  [mem 0x7c000000-0x7ddfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x7e000000-0x7e667fff]
[    0.000000]  [mem 0x7e000000-0x7e5fffff] page 2M
[    0.000000]  [mem 0x7e600000-0x7e667fff] page 4k
[    0.000000] BRK [0x036c2000, 0x036c2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7e692000-0x7fb11fff]
[    0.000000]  [mem 0x7e692000-0x7e7fffff] page 4k
[    0.000000]  [mem 0x7e800000-0x7f9fffff] page 2M
[    0.000000]  [mem 0x7fa00000-0x7fb11fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7fb76000-0x7ffdffff]
[    0.000000]  [mem 0x7fb76000-0x7fbfffff] page 4k
[    0.000000]  [mem 0x7fc00000-0x7fdfffff] page 2M
[    0.000000]  [mem 0x7fe00000-0x7ffdffff] page 4k
[    0.000000] log_buf_len: 16777216
[    0.000000] early log buf free: 2089788(99%)
[    0.000000] ACPI: RSDP 000000007fb71014 00024 (v02 OVMF  )
[    0.000000] ACPI: XSDT 000000007fb700e8 0003C (v01 OVMF   OVMFEDK2 20130221      01000013)
[    0.000000] ACPI: FACP 000000007fb6f000 000F4 (v03 OVMF   OVMFEDK2 20130221 OVMF 00000099)
[    0.000000] ACPI: DSDT 000000007fb6d000 00D57 (v01 INTEL  OVMF     00000004 INTL 20100528)
[    0.000000] ACPI: FACS 000000007fb75000 00040
[    0.000000] ACPI: APIC 000000007fb6e000 00078 (v01 OVMF   OVMFEDK2 20130221 OVMF 00000099)
[    0.000000] ACPI: SSDT 000000007fb6c000 00057 (v01 REDHAT OVMF     00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000007ffdffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x7ffdffff]
[    0.000000]   NODE_DATA [mem 0x7e0ca000-0x7e0cbfff]
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007a000000-ffff88007bffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x7e667fff]
[    0.000000]   node   0: [mem 0x7e692000-0x7fb11fff]
[    0.000000]   node   0: [mem 0x7fb76000-0x7ffdffff]
[    0.000000] On node 0 totalpages: 524017
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 2070 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8128 pages used for memmap
[    0.000000]   DMA32 zone: 520018 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007e668000 - 000000007e692000
[    0.000000] PM: Registered nosave memory: 000000007fb12000 - 000000007fb6a000
[    0.000000] PM: Registered nosave memory: 000000007fb6a000 - 000000007fb72000
[    0.000000] PM: Registered nosave memory: 000000007fb72000 - 000000007fb76000
[    0.000000] e820: [mem 0x80000000-0xffffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007ce00000 s84736 r8192 d21760 u2097152
[    0.000000] pcpu-alloc: s84736 r8192 d21760 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 513755
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda1 debug ignore_loglevel log_buf_len=10M earlyprintk=ttyS0,115200 console=ttyS0,115200 console=tty0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1983624k/2097024k available (5838k kernel code, 956k absent, 112444k reserved, 5274k data, 1080k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=1.
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
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
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2893.477 MHz processor
[    0.004001] Calibrating delay loop (skipped), value calculated using timer frequency.. 5786.95 BogoMIPS (lpj=2893477)
[    0.006004] pid_max: default: 32768 minimum: 301
[    0.006776] efi: efi_enter_virtual_mode: enter
[    0.007004] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000009f000) (0MB)
[    0.009004] efi: mem01: type=2, attr=0xf, range=[0x000000000009f000-0x00000000000a0000) (0MB)
[    0.010004] efi: mem02: type=7, attr=0xf, range=[0x0000000000100000-0x0000000000800000) (7MB)
[    0.011004] efi: mem03: type=4, attr=0xf, range=[0x0000000000800000-0x0000000001000000) (8MB)
[    0.013004] efi: mem04: type=7, attr=0xf, range=[0x0000000001000000-0x0000000002000000) (16MB)
[    0.014004] efi: mem05: type=2, attr=0xf, range=[0x0000000002000000-0x00000000036e3000) (22MB)
[    0.016004] efi: mem06: type=7, attr=0xf, range=[0x00000000036e3000-0x000000003fffb000) (969MB)
[    0.017004] efi: mem07: type=2, attr=0xf, range=[0x000000003fffb000-0x0000000040000000) (0MB)
[    0.019004] efi: mem08: type=7, attr=0xf, range=[0x0000000040000000-0x000000007c000000) (960MB)
[    0.020004] efi: mem09: type=4, attr=0xf, range=[0x000000007c000000-0x000000007c020000) (0MB)
[    0.021004] efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
[    0.023004] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0ad000) (0MB)
[    0.024004] efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)
[    0.026004] efi: mem13: type=4, attr=0xf, range=[0x000000007e0cd000-0x000000007e55d000) (4MB)
[    0.027004] efi: mem14: type=3, attr=0xf, range=[0x000000007e55d000-0x000000007e59c000) (0MB)
[    0.028004] efi: mem15: type=4, attr=0xf, range=[0x000000007e59c000-0x000000007e5a0000) (0MB)
[    0.030004] efi: mem16: type=3, attr=0xf, range=[0x000000007e5a0000-0x000000007e668000) (0MB)
[    0.031004] efi: mem17: type=5, attr=0x800000000000000f, range=[0x000000007e668000-0x000000007e67d000) (0MB)
[    0.033004] efi: mem18: type=6, attr=0x800000000000000f, range=[0x000000007e67d000-0x000000007e692000) (0MB)
[    0.035004] efi: mem19: type=4, attr=0xf, range=[0x000000007e692000-0x000000007f992000) (19MB)
[    0.036004] efi: mem20: type=7, attr=0xf, range=[0x000000007f992000-0x000000007f994000) (0MB)
[    0.037004] efi: mem21: type=3, attr=0xf, range=[0x000000007f994000-0x000000007fb12000) (1MB)
[    0.039004] efi: mem22: type=5, attr=0x800000000000000f, range=[0x000000007fb12000-0x000000007fb42000) (0MB)
[    0.040004] efi: mem23: type=6, attr=0x800000000000000f, range=[0x000000007fb42000-0x000000007fb66000) (0MB)
[    0.042004] efi: mem24: type=0, attr=0xf, range=[0x000000007fb66000-0x000000007fb6a000) (0MB)
[    0.043004] efi: mem25: type=9, attr=0xf, range=[0x000000007fb6a000-0x000000007fb72000) (0MB)
[    0.045004] efi: mem26: type=10, attr=0xf, range=[0x000000007fb72000-0x000000007fb76000) (0MB)
[    0.046004] efi: mem27: type=4, attr=0xf, range=[0x000000007fb76000-0x000000007ffe0000) (4MB)
[    0.048004] efi: mem28: type=6, attr=0x800000000000000f, range=[0x000000007ffe0000-0x0000000080000000) (0MB)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
