Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab3GSSrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:47:07 -0400
Received: from fep11.mx.upcmail.net ([62.179.121.31]:36519 "EHLO
	fep11.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3GSSrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:47:00 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <51E9899E.3080307@odi.ch>
Date: Fri, 19 Jul 2013 20:46:54 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
References: <51E4501D.3010001@odi.ch> <20130716065626.GA1587@redhat.com> <51E4F790.6090308@odi.ch> <51E51712.4020609@broadcom.com> <51E58FA5.4000804@odi.ch> <20130717122944.GA25894@redhat.com> <51E6E1AB.5010300@odi.ch> <20130718105550.GA4628@redhat.com> <51E83AB7.6020002@odi.ch> <20130719120842.GA1570@redhat.com>
In-Reply-To: <20130719120842.GA1570@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------050601040200080005070802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050601040200080005070802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/19/2013 02:08 PM, Stanislaw Gruszka wrote:
> I'm attaching patch, which should prevent crash (but not fix the issue,
> just workaround it), plese apply it. If it make suspend work, please then
> reload iwlwifi module with debug=0x3 option, suspend/resume machine and
> provide dmesg output after that.


Here the requested dmesg. Please note that two different WARN_ONs trigger here 
directly after each other.

To me it looks like iwlagn_mac_remove_interface() is called twice, but I am not 
familiar with the code.

Thanks,

Ortwin


--------------050601040200080005070802
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.1 (root@bat) (gcc version 4.6.3 (Gentoo 4.6.3 p1.11, pie-0.5.2) ) #14 SMP PREEMPT Fri Jul 19 20:18:41 CEST 2013
[    0.000000] Command line: libahci.ignore_sss=1 root=/dev/sda1 rootfstype=ext4 video=1600x900 iwlwifi.debug=0x3 no_console_suspend
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000b9f29fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b9f2a000-0x00000000ba12bfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ba12c000-0x00000000c93eefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c93ef000-0x00000000daeeefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000daeef000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X4C/900X4D/NP900X3D-A03CH, BIOS P02ABK 09/19/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x11f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask FE0000000 write-back
[    0.000000]   7 base 11F800000 mask FFF800000 uncachable
[    0.000000]   8 base 11F600000 mask FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f0100-0x000f010f] mapped at [ffff8800000f0100]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01ee4000, 0x01ee4fff] PGTABLE
[    0.000000] BRK [0x01ee5000, 0x01ee5fff] PGTABLE
[    0.000000] BRK [0x01ee6000, 0x01ee6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11f400000-0x11f5fffff]
[    0.000000]  [mem 0x11f400000-0x11f5fffff] page 2M
[    0.000000] BRK [0x01ee7000, 0x01ee7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11f3fffff]
[    0.000000]  [mem 0x11c000000-0x11f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x01ee8000, 0x01ee8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0xb9f29fff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xb9dfffff] page 2M
[    0.000000]  [mem 0xb9e00000-0xb9f29fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xba12c000-0xc93eefff]
[    0.000000]  [mem 0xba12c000-0xba1fffff] page 4k
[    0.000000]  [mem 0xba200000-0xc91fffff] page 2M
[    0.000000]  [mem 0xc9200000-0xc93eefff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdafff000-0xdaffffff]
[    0.000000]  [mem 0xdafff000-0xdaffffff] page 4k
[    0.000000] ACPI: RSDP 00000000000f0120 00024 (v02 SECCSD)
[    0.000000] ACPI: XSDT 00000000daffe170 00094 (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: FACP 00000000dafee000 0010C (v05 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000daff1000 09538 (v02 SECCSD  IVB-CPT 00000000 INTL 20061109)
[    0.000000] ACPI: FACS 00000000daf7b000 00040
[    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 SECCSD LH43STAR 00000002 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000daffb000 01068 (v01 SECCSD PtidDevc 00001000 INTL 20061109)
[    0.000000] ACPI: ASF! 00000000daff0000 000A5 (v32 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: HPET 00000000dafed000 00038 (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: APIC 00000000dafec000 00098 (v03 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dafeb000 0003C (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: FPDT 00000000dafea000 00064 (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: SSDT 00000000dafe9000 008DF (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dafe8000 00B60 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 00000000dafe7000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: MSDM 00000000daf78000 00055 (v03 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafe6000 0003E (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafe5000 0022E (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011ae00000-ffff88011ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xb9f29fff]
[    0.000000]   node   0: [mem 0xba12c000-0xc93eefff]
[    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x11f5fffff]
[    0.000000] On node 0 totalpages: 951689
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12800 pages used for memmap
[    0.000000]   DMA32 zone: 819181 pages, LIFO batch:31
[    0.000000]   Normal zone: 2008 pages used for memmap
[    0.000000]   Normal zone: 128512 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88011f200000 s80000 r8192 d22400 u262144
[    0.000000] pcpu-alloc: s80000 r8192 d22400 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 936796
[    0.000000] Kernel command line: libahci.ignore_sss=1 root=/dev/sda1 rootfstype=ext4 video=1600x900 iwlwifi.debug=0x3 no_console_suspend
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3654756k/4708352k available (8080k kernel code, 901596k absent, 152000k reserved, 4934k data, 1228k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=8.
[    0.000000] 	Experimental no-CBs for all CPUs
[    0.000000] 	Experimental no-CBs CPUs: 0-15.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 1696.111 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3392.22 BogoMIPS (lpj=1696111)
[    0.000161] pid_max: default: 32768 minimum: 301
[    0.000274] Mount-cache hash table entries: 256
[    0.000581] CPU: Physical Processor ID: 0
[    0.000658] CPU: Processor Core ID: 0
[    0.000736] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.001417] mce: CPU supports 7 MCE banks
[    0.001504] CPU0: Thermal monitoring enabled (TM1)
[    0.001589] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 1
[    0.001945] Freeing SMP alternatives: 24k freed
[    0.002052] ACPI: Core revision 20130328
[    0.008781] ACPI: All ACPI Tables successfully acquired
[    0.010651] ftrace: allocating 28455 entries in 112 pages
[    0.030225] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.040336] smpboot: CPU0: Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz (fam: 06, model: 3a, stepping: 09)
[    0.040634] TSC deadline timer enabled
[    0.040647] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Intel PMU driver.
[    0.040931] ... version:                3
[    0.041029] ... bit width:              48
[    0.041127] ... generic registers:      4
[    0.041225] ... value mask:             0000ffffffffffff
[    0.041327] ... max period:             000000007fffffff
[    0.041428] ... fixed-purpose events:   3
[    0.041526] ... event mask:             000000070000000f
[    0.047742] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.093669] Brought up 4 CPUs
[    0.093865] smpboot: Total of 4 processors activated (13568.88 BogoMIPS)
[    0.097925] devtmpfs: initialized
[    0.098277] PM: Registering ACPI NVS region [mem 0xdaeef000-0xdaf9efff] (720896 bytes)
[    0.098685] NET: Registered protocol family 16
[    0.099224] ACPI: bus type PCI registered
[    0.099323] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.099550] dca service started, version 1.12.1
[    0.099708] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.099874] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.109089] PCI: Using configuration type 1 for base access
[    0.120144] bio: create slab <bio-0> at 0
[    0.120432] ACPI: Added _OSI(Module Device)
[    0.120533] ACPI: Added _OSI(Processor Device)
[    0.120633] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.120733] ACPI: Added _OSI(Processor Aggregator Device)
[    0.122584] ACPI: EC: Look up EC in DSDT
[    0.133876] ACPI: Executed 1 blocks of module-level executable AML code
[    0.140248] ACPI: SSDT 00000000dae8e818 00784 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.140926] ACPI: Dynamic OEM Table Load:
[    0.141113] ACPI: SSDT           (null) 00784 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.143146] ACPI: SSDT 00000000dae8fa98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.143856] ACPI: Dynamic OEM Table Load:
[    0.144041] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.146139] ACPI: SSDT 00000000dae8dd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.146799] ACPI: Dynamic OEM Table Load:
[    0.146987] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    1.053541] ACPI: Interpreter enabled
[    1.053649] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[    1.053901] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[    1.054159] ACPI: (supports S0 S3 S5)
[    1.054258] ACPI: Using IOAPIC for interrupt routing
[    1.054450] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.069332] ACPI: Power Resource [FN00] (off)
[    1.069612] ACPI: Power Resource [FN01] (off)
[    1.069882] ACPI: Power Resource [FN02] (off)
[    1.070143] ACPI: Power Resource [FN03] (off)
[    1.070401] ACPI: Power Resource [FN04] (off)
[    1.071396] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.071603] \_SB_.PCI0:_OSC invalid UUID
[    1.071604] _OSC request data:1 8 0 
[    1.072270] PCI host bridge to bus 0000:00
[    1.072372] pci_bus 0000:00: root bus resource [bus 00-3e]
[    1.073849] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.073955] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.074058] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.074164] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    1.074278] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    1.074425] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    1.074440] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    1.074448] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    1.074454] pci 0000:00:02.0: reg 20: [io  0x3000-0x303f]
[    1.074638] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    1.074673] pci 0000:00:16.0: reg 10: [mem 0xf0705000-0xf070500f 64bit]
[    1.074767] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.074924] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    1.074950] pci 0000:00:1b.0: reg 10: [mem 0xf0700000-0xf0703fff 64bit]
[    1.075038] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.075074] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    1.075244] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    1.075351] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.075391] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.075566] pci 0000:00:1c.3: [8086:1e16] type 01 class 0x060400
[    1.075670] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.075714] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    1.075887] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
[    1.076020] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.076142] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    1.076171] pci 0000:00:1d.0: reg 10: [mem 0xf0709000-0xf07093ff]
[    1.076282] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.076378] pci 0000:00:1f.0: [8086:1e5d] type 00 class 0x060100
[    1.076592] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    1.076619] pci 0000:00:1f.2: reg 10: [io  0x3088-0x308f]
[    1.076631] pci 0000:00:1f.2: reg 14: [io  0x3094-0x3097]
[    1.076644] pci 0000:00:1f.2: reg 18: [io  0x3080-0x3087]
[    1.076655] pci 0000:00:1f.2: reg 1c: [io  0x3090-0x3093]
[    1.076665] pci 0000:00:1f.2: reg 20: [io  0x3060-0x307f]
[    1.076678] pci 0000:00:1f.2: reg 24: [mem 0xf0708000-0xf07087ff]
[    1.076740] pci 0000:00:1f.2: PME# supported from D3hot
[    1.076851] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    1.076882] pci 0000:00:1f.3: reg 10: [mem 0xf0704000-0xf07040ff 64bit]
[    1.076913] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    1.077338] pci 0000:01:00.0: [8086:088e] type 00 class 0x028000
[    1.077631] pci 0000:01:00.0: reg 10: [mem 0xf0600000-0xf0601fff 64bit]
[    1.078638] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    1.078848] pci 0000:01:00.0: System wakeup disabled by ACPI
[    1.081103] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.081211] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
[    1.081408] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    1.081484] pci 0000:02:00.0: reg 10: [io  0x2000-0x20ff]
[    1.081615] pci 0000:02:00.0: reg 18: [mem 0xf0404000-0xf0404fff 64bit pref]
[    1.081697] pci 0000:02:00.0: reg 20: [mem 0xf0400000-0xf0403fff 64bit pref]
[    1.082060] pci 0000:02:00.0: supports D1 D2
[    1.082062] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.082170] pci 0000:02:00.0: System wakeup disabled by ACPI
[    1.084053] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    1.084159] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.084169] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
[    1.084386] pci 0000:03:00.0: [1912:0015] type 00 class 0x0c0330
[    1.084436] pci 0000:03:00.0: reg 10: [mem 0xf0500000-0xf0501fff 64bit]
[    1.084696] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.086080] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.086190] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
[    1.086221] pci_bus 0000:00: on NUMA node 0
[    1.086300] \_SB_.PCI0:_OSC invalid UUID
[    1.086301] _OSC request data:1 1f 0 
[    1.086306] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    1.086413] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    1.087243] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    1.087942] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.088725] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    1.089415] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    1.090109] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.090889] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.091667] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 11 12 14 15) *7
[    1.092400] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    1.093604] ACPI: Enabled 5 GPEs in block 00 to 3F
[    1.093801] acpi root: \_SB_.PCI0 notify handler is installed
[    1.093875] Found 1 acpi root devices
[    1.093928] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    1.094227] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.094337] vgaarb: loaded
[    1.094434] vgaarb: bridge control possible 0000:00:02.0
[    1.094682] SCSI subsystem initialized
[    1.094783] ACPI: bus type ATA registered
[    1.094969] libata version 3.00 loaded.
[    1.095070] ACPI: bus type USB registered
[    1.095242] usbcore: registered new interface driver usbfs
[    1.095381] usbcore: registered new interface driver hub
[    1.095534] usbcore: registered new device driver usb
[    1.095729] Linux video capture interface: v2.00
[    1.095948] EDAC MC: Ver: 3.0.0
[    1.096593] wmi: Mapper loaded
[    1.096734] Advanced Linux Sound Architecture Driver Initialized.
[    1.096837] PCI: Using ACPI for IRQ routing
[    1.098833] PCI: pci_cache_line_size set to 64 bytes
[    1.098992] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
[    1.098994] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    1.098995] e820: reserve RAM buffer [mem 0xb9f2a000-0xbbffffff]
[    1.098997] e820: reserve RAM buffer [mem 0xc93ef000-0xcbffffff]
[    1.098998] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    1.099000] e820: reserve RAM buffer [mem 0x11f600000-0x11fffffff]
[    1.099207] Bluetooth: Core ver 2.16
[    1.099339] NET: Registered protocol family 31
[    1.099440] Bluetooth: HCI device and connection manager initialized
[    1.099545] Bluetooth: HCI socket layer initialized
[    1.099647] Bluetooth: L2CAP socket layer initialized
[    1.099751] Bluetooth: SCO socket layer initialized
[    1.099992] cfg80211: Calling CRDA to update world regulatory domain
[    1.100399] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.100898] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.103020] Switching to clocksource hpet
[    1.106775] pnp: PnP ACPI init
[    1.106889] ACPI: bus type PNP registered
[    1.107375] pnp 00:00: [dma 4]
[    1.107447] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.107519] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    1.107678] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.107756] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.107847] system 00:04: [io  0x0680-0x069f] has been reserved
[    1.107952] system 00:04: [io  0x1000-0x100f] has been reserved
[    1.108055] system 00:04: [io  0x5000-0x5003] has been reserved
[    1.108175] system 00:04: [io  0xffff] has been reserved
[    1.108280] system 00:04: [io  0x0400-0x0453] has been reserved
[    1.108384] system 00:04: [io  0x0458-0x047f] has been reserved
[    1.108487] system 00:04: [io  0x0500-0x057f] has been reserved
[    1.108591] system 00:04: [io  0x0a00-0x0a0f] has been reserved
[    1.108693] system 00:04: [io  0x164e-0x164f] has been reserved
[    1.108797] system 00:04: [io  0x5000-0x500f] could not be reserved
[    1.108902] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.108982] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.109085] system 00:06: [io  0x0454-0x0457] has been reserved
[    1.109201] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    1.109296] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.109396] pnp 00:08: Plug and Play ACPI device, IDs ETD0b00 PNP0f13 (active)
[    1.109633] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.109739] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
[    1.109844] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.109948] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.110053] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.110167] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.110271] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
[    1.110377] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.110482] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
[    1.110588] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.110692] system 00:09: [mem 0xfffff000-0xffffffff] has been reserved
[    1.110798] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.111273] pnp: PnP ACPI: found 10 devices
[    1.111388] ACPI: bus type PNP unregistered
[    1.121618] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.121727] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
[    1.121842] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    1.121945] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.122056] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
[    1.122177] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.122285] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
[    1.122667] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.122669] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.122671] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.122673] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
[    1.122675] pci_bus 0000:01: resource 1 [mem 0xf0600000-0xf06fffff]
[    1.122678] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    1.122680] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf04fffff 64bit pref]
[    1.122682] pci_bus 0000:03: resource 1 [mem 0xf0500000-0xf05fffff]
[    1.122711] NET: Registered protocol family 2
[    1.122942] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
[    1.123158] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    1.123361] TCP: Hash tables configured (established 32768 bind 32768)
[    1.123483] TCP: reno registered
[    1.123583] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.123700] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.123868] NET: Registered protocol family 1
[    1.123979] pci 0000:00:02.0: Boot video device
[    1.124395] PCI: CLS 64 bytes, default 64
[    1.124413] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.124519] software IO TLB [mem 0xc53ef000-0xc93ef000] (64MB) mapped at [ffff8800c53ef000-ffff8800c93eefff]
[    1.125906] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x15
[    1.126016] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x15
[    1.126129] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x15
[    1.126242] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x15
[    1.126418] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.126626] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    1.127044] audit: initializing netlink socket (disabled)
[    1.127161] type=2000 audit(1374257980.103:1): initialized
[    1.127809] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.132933] msgmni has been set to 7138
[    1.133794] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.133902] io scheduler noop registered
[    1.134000] io scheduler deadline registered (default)
[    1.134176] io scheduler cfq registered
[    1.134682] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.134903] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.135113] intel_idle: MWAIT substates: 0x21120
[    1.135114] intel_idle: v0.4 model 0x3A
[    1.135115] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.135336] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.135746] ACPI: AC Adapter [ADP1] (off-line)
[    1.136051] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.136271] ACPI: Lid Switch [LID0]
[    1.136485] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.136595] ACPI: Power Button [PWRB]
[    1.136775] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.136883] ACPI: Power Button [PWRF]
[    1.137134] ACPI: Fan [FAN0] (off)
[    1.137316] ACPI: Fan [FAN1] (off)
[    1.137484] ACPI: Fan [FAN2] (off)
[    1.137653] ACPI: Fan [FAN3] (off)
[    1.137817] ACPI: Fan [FAN4] (off)
[    1.138036] ACPI: Requesting acpi_cpufreq
[    1.151095] thermal LNXTHERM:00: registered as thermal_zone0
[    1.151211] ACPI: Thermal Zone [TZ00] (44 C)
[    1.151708] thermal LNXTHERM:01: registered as thermal_zone1
[    1.151813] ACPI: Thermal Zone [TZ01] (30 C)
[    1.152300] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.152687] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.155456] Non-volatile memory driver v1.3
[    1.155700] Linux agpgart interface v0.103
[    1.155878] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.156177] Hangcheck: Using getrawmonotonic().
[    1.156441] [drm] Initialized drm 1.1.0 20060810
[    1.157765] [drm] Memory usable by graphics device = 2048M
[    1.157933] i915 0000:00:02.0: setting latency timer to 64
[    1.158177] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.158345] ACPI: Battery Slot [BAT1] (battery present)
[    1.197474] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    1.197483] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.197587] [drm] Driver supports precise vblank timestamp query.
[    1.197744] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.248866] fbcon: inteldrmfb (fb0) is primary device
[    2.126627] tsc: Refined TSC clocksource calibration: 1696.146 MHz
[    2.126630] Switching to clocksource tsc
[    2.731246] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    3.039606] Console: switching to colour frame buffer device 200x56
[    3.044187] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.044217] i915 0000:00:02.0: registered panic notifier
[    3.051300] acpi device:3a: registered as cooling_device9
[    3.051528] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    3.051639] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    3.051731] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.053985] brd: module loaded
[    3.055145] loop: module loaded
[    3.055346] mei_me 0000:00:16.0: setting latency timer to 64
[    3.055388] mei_me 0000:00:16.0: irq 41 for MSI/MSI-X
[    3.060410] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130328/utaddress-251)
[    3.060481] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.060534] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130328/utaddress-251)
[    3.060600] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.060650] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130328/utaddress-251)
[    3.060715] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.060765] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    3.061002] ahci 0000:00:1f.2: version 3.0
[    3.061144] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    3.061204] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1 impl SATA mode
[    3.061255] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    3.061298] ahci 0000:00:1f.2: setting latency timer to 64
[    3.062358] scsi0 : ahci
[    3.062496] scsi1 : ahci
[    3.062622] scsi2 : ahci
[    3.062763] scsi3 : ahci
[    3.062892] scsi4 : ahci
[    3.063963] scsi5 : ahci
[    3.065035] ata1: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708100 irq 42
[    3.066027] ata2: DUMMY
[    3.067029] ata3: DUMMY
[    3.068021] ata4: DUMMY
[    3.069017] ata5: DUMMY
[    3.070024] ata6: DUMMY
[    3.071308] tun: Universal TUN/TAP device driver, 1.6
[    3.072354] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.073519] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.074842] r8169 0000:02:00.0: irq 43 for MSI/MSI-X
[    3.075082] r8169 0000:02:00.0 eth0: RTL8168evl/8111evl at 0xffffc9000003c000, 50:b7:c3:81:93:81, XID 0c900800 IRQ 43
[    3.076236] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    3.077461] Intel(R) Wireless WiFi driver for Linux, in-tree:d
[    3.078666] Copyright(c) 2003-2013 Intel Corporation
[    3.080236] iwlwifi 0000:01:00.0: irq 44 for MSI/MSI-X
[    3.080478] iwlwifi 0000:01:00.0: U iwl_request_firmware attempting to load firmware 'iwlwifi-6000g2b-6.ucode'
[    3.080615] usbcore: registered new interface driver asix
[    3.081903] usbcore: registered new interface driver ax88179_178a
[    3.083189] usbcore: registered new interface driver cdc_ether
[    3.084487] usbcore: registered new interface driver rndis_host
[    3.085855] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.087151] ehci-pci: EHCI PCI platform driver
[    3.088557] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    3.088565] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    3.089928] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    3.091250] ehci-pci 0000:00:1d.0: debug port 2
[    3.096430] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    3.096446] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf0709000
[    3.103063] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.104338] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.105603] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.106864] usb usb1: Product: EHCI Host Controller
[    3.108113] usb usb1: Manufacturer: Linux 3.10.1 ehci_hcd
[    3.109352] usb usb1: SerialNumber: 0000:00:1d.0
[    3.110762] hub 1-0:1.0: USB hub found
[    3.111998] hub 1-0:1.0: 3 ports detected
[    3.113349] uhci_hcd: USB Universal Host Controller Interface driver
[    3.114731] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    3.116005] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 2
[    3.122607] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
[    3.122613] xhci_hcd 0000:03:00.0: irq 46 for MSI/MSI-X
[    3.122618] xhci_hcd 0000:03:00.0: irq 47 for MSI/MSI-X
[    3.122624] xhci_hcd 0000:03:00.0: irq 48 for MSI/MSI-X
[    3.122629] xhci_hcd 0000:03:00.0: irq 49 for MSI/MSI-X
[    3.122751] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.123965] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.125152] usb usb2: Product: xHCI Host Controller
[    3.126302] usb usb2: Manufacturer: Linux 3.10.1 xhci_hcd
[    3.127417] usb usb2: SerialNumber: 0000:03:00.0
[    3.128600] xHCI xhci_add_endpoint called for root hub
[    3.128602] xHCI xhci_check_bandwidth called for root hub
[    3.128656] hub 2-0:1.0: USB hub found
[    3.129753] hub 2-0:1.0: 2 ports detected
[    3.130886] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    3.131952] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
[    3.133039] usb usb3: New USB device found, idVendor=1d6b, idProduct=0003
[    3.134023] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.135001] usb usb3: Product: xHCI Host Controller
[    3.135980] usb usb3: Manufacturer: Linux 3.10.1 xhci_hcd
[    3.136972] usb usb3: SerialNumber: 0000:03:00.0
[    3.138079] xHCI xhci_add_endpoint called for root hub
[    3.138081] xHCI xhci_check_bandwidth called for root hub
[    3.138139] hub 3-0:1.0: USB hub found
[    3.139206] hub 3-0:1.0: 2 ports detected
[    3.146187] usbcore: registered new interface driver usb-storage
[    3.147307] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:EPAD] at 0x60,0x64 irq 1,12
[    3.154417] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.155492] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.156718] mousedev: PS/2 mouse device common for all mice
[    3.158325] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    3.159460] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    3.160618] i2c /dev entries driver
[    3.162390] ACPI Warning: 0x000000000000efa0-0x000000000000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20130328/utaddress-251)
[    3.163605] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.165104] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    3.166309] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    3.167655] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.168868] iTCO_vendor_support: vendor-support=0
[    3.169164] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    3.171330] usbcore: registered new interface driver btusb
[    3.172612] Intel P-state driver initializing.
[    3.173852] Intel pstate controlling: cpu 0
[    3.175021] Intel pstate controlling: cpu 1
[    3.176158] Intel pstate controlling: cpu 2
[    3.177292] Intel pstate controlling: cpu 3
[    3.178498] cpuidle: using governor ladder
[    3.179913] hidraw: raw HID events driver (C) Jiri Kosina
[    3.181720] usbcore: registered new interface driver usbhid
[    3.182861] usbhid: USB HID core driver
[    3.184572] samsung_laptop: detected SABI interface: SwSmi@
[    3.185693] samsung_laptop: Backlight controlled by ACPI video driver
[    3.197040] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
[    3.211789] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    3.213165] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    3.214535] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    3.216686] GACT probability NOT on
[    3.217867] u32 classifier
[    3.219027]     Actions configured
[    3.220190] Netfilter messages via NETLINK v0.30.
[    3.221370] nfnl_acct: registering with nfnetlink.
[    3.222522] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.223834] ctnetlink v0.93: registering with nfnetlink.
[    3.225063] IPv4 over IPSec tunneling driver
[    3.226783] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.227985] TCP: cubic registered
[    3.229134] Initializing XFRM netlink socket
[    3.230681] NET: Registered protocol family 10
[    3.232051] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.233265] NET: Registered protocol family 17
[    3.234422] NET: Registered protocol family 15
[    3.235560] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    3.236725] Bluetooth: HIDP socket layer initialized
[    3.237928] 8021q: 802.1Q VLAN Support v1.8
[    3.240213] registered taskstats version 1
[    3.242282] ALSA device list:
[    3.243424]   #0: HDA Intel PCH at 0xf0700000 irq 50
[    3.376278] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    3.377890] ata1.00: ATA-9: SanDisk SSD U100 SMG2, 10.56.04, max UDMA/133
[    3.379042] ata1.00: 246162672 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    3.380576] ata1.00: configured for UDMA/133
[    3.381952] scsi 0:0:0:0: Direct-Access     ATA      SanDisk SSD U100 10.5 PQ: 0 ANSI: 5
[    3.383781] sd 0:0:0:0: [sda] 246162672 512-byte logical blocks: (126 GB/117 GiB)
[    3.383997] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.386262] sd 0:0:0:0: [sda] Write Protect is off
[    3.387372] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.387391] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.391804]  sda: sda1
[    3.393487] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.415275] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    3.530769] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    3.531927] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.533620] hub 1-1:1.0: USB hub found
[    3.534847] hub 1-1:1.0: 6 ports detected
[    3.790927] psmouse serio1: elantech: assuming hardware version 4 (with firmware version 0x461f00)
[    3.807139] psmouse serio1: elantech: Synaptics capabilities query result 0x40, 0x14, 0x0d.
[    3.810654] usb 1-1.5: new full-speed USB device number 3 using ehci-pci
[    3.886009] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input8
[    3.899235] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.900438] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    3.901773] usb 1-1.5: New USB device found, idVendor=8087, idProduct=07da
[    3.903044] usb 1-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.916423] devtmpfs: mounted
[    3.918981] Freeing unused kernel memory: 1228k freed
[    3.920319] Write protecting the kernel read-only data: 12288k
[    3.921999] Freeing unused kernel memory: 100k freed
[    3.925588] Freeing unused kernel memory: 896k freed
[    3.978550] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
[    4.386477] usb 1-1.6: New USB device found, idVendor=2232, idProduct=1024
[    4.387889] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.389156] usb 1-1.6: Product: Webcam SC-13HDL11624N
[    4.390471] usb 1-1.6: Manufacturer: Namugaÿ 
[    4.571922] systemd-udevd[1291]: starting version 204
[    4.699824] uvcvideo: Found UVC 1.00 device Webcam SC-13HDL11624N (2232:1024)
[    4.782906] input: Webcam SC-13HDL11624N as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input9
[    4.783072] usbcore: registered new interface driver uvcvideo
[    4.783074] USB Video Class driver (1.1.1)
[    5.150747] iwlwifi 0000:01:00.0: U iwl_req_fw_callback Loaded firmware file 'iwlwifi-6000g2b-6.ucode' (679436 bytes).
[    5.150756] iwlwifi 0000:01:00.0: U validate_sec_sizes f/w package hdr runtime inst size = 159932
[    5.150759] iwlwifi 0000:01:00.0: U validate_sec_sizes f/w package hdr runtime data size = 81920
[    5.150762] iwlwifi 0000:01:00.0: U validate_sec_sizes f/w package hdr init inst size = 130228
[    5.150766] iwlwifi 0000:01:00.0: U validate_sec_sizes f/w package hdr init data size = 81920
[    5.151018] iwlwifi 0000:01:00.0: loaded firmware version 18.168.6.1 op_mode iwldvm
[    5.151034] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG enabled
[    5.151037] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    5.151039] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    5.151042] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    5.151044] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_P2P disabled
[    5.151047] iwlwifi 0000:01:00.0: U iwl_op_mode_dvm_start *** LOAD DRIVER ***
[    5.151050] iwlwifi 0000:01:00.0: U iwl_op_mode_dvm_start BT channel inhibition is On
[    5.151053] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Advanced-N 6235 AGN, REV=0xB0
[    5.151057] iwlwifi 0000:01:00.0: U iwl_pcie_prepare_card_hw iwl_trans_prepare_card_hw enter
[    5.151097] iwlwifi 0000:01:00.0: U iwl_pcie_set_hw_ready hardware ready
[    5.151100] iwlwifi 0000:01:00.0: U iwl_pcie_apm_init Init card's basic functions
[    5.151145] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[    5.167783] iwlwifi 0000:01:00.0: U iwl_pcie_apm_stop Stop card, put in low power state
[    5.167794] iwlwifi 0000:01:00.0: U iwl_pcie_apm_stop_master stop master
[    5.167872] iwlwifi 0000:01:00.0: U iwl_nvm_check_version device EEPROM VER=0x756, CALIB=0x6
[    5.167876] iwlwifi 0000:01:00.0: U iwl_eeprom_init_hw_params Device SKU: 24GHz  enabled, 52GHz  enabled, 11.n  enabled
[    5.167879] iwlwifi 0000:01:00.0: U iwl_eeprom_init_hw_params Valid Tx ant: 0x3, Valid Rx ant: 0x3
[    5.167883] iwlwifi 0000:01:00.0: U iwl_op_mode_dvm_start MAC address: c8:f7:33:4b:dd:db
[    5.167888] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[    5.168236] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    5.436830] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x15
[    5.437676] microcode: CPU0 updated to revision 0x17, date = 2013-01-09
[    5.437898] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x15
[    5.438368] microcode: CPU1 updated to revision 0x17, date = 2013-01-09
[    5.438619] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x15
[    5.439085] microcode: CPU2 updated to revision 0x17, date = 2013-01-09
[    5.439336] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x15
[    5.439802] microcode: CPU3 updated to revision 0x17, date = 2013-01-09
[    5.873302] EXT4-fs (sda1): warning: maximal mount count reached, running e2fsck is recommended
[    5.873418] EXT4-fs (sda1): re-mounted. Opts: discard
[    7.624997] iwlwifi 0000:01:00.0: U iwlagn_mac_start enter
[    7.625008] iwlwifi 0000:01:00.0: I iwl_prep_station Add STA to driver ID 15: ff:ff:ff:ff:ff:ff
[    7.625011] iwlwifi 0000:01:00.0: I iwl_prep_station Add STA to driver ID 14: ff:ff:ff:ff:ff:ff
[    7.625014] iwlwifi 0000:01:00.0: U iwl_pcie_prepare_card_hw iwl_trans_prepare_card_hw enter
[    7.625053] iwlwifi 0000:01:00.0: U iwl_pcie_set_hw_ready hardware ready
[    7.625080] iwlwifi 0000:01:00.0: U iwl_pcie_apm_init Init card's basic functions
[    7.625170] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[    7.632172] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
[    7.782194] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command COEX_PRIORITY_TABLE_CMD
[    7.782197] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command COEX_PRIORITY_TABLE_CMD
[    7.782281] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command COEX_PRIORITY_TABLE_CMD
[    7.782308] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[    7.782310] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    7.783076] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    7.783091] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_BT_COEX_PROT_ENV
[    7.783095] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_BT_COEX_PROT_ENV
[    7.783230] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_BT_COEX_PROT_ENV
[    7.783256] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command CALIBRATION_CFG_CMD
[    7.783259] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command CALIBRATION_CFG_CMD
[    7.783343] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command CALIBRATION_CFG_CMD
[    8.010826] iwlwifi 0000:01:00.0: U iwl_pcie_apm_stop Stop card, put in low power state
[    8.010866] iwlwifi 0000:01:00.0: U iwl_pcie_apm_stop_master stop master
[    8.010929] iwlwifi 0000:01:00.0: U iwl_pcie_prepare_card_hw iwl_trans_prepare_card_hw enter
[    8.010951] iwlwifi 0000:01:00.0: U iwl_pcie_set_hw_ready hardware ready
[    8.010977] iwlwifi 0000:01:00.0: U iwl_pcie_apm_init Init card's basic functions
[    8.011046] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[    8.018009] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
[    8.186360] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command COEX_PRIORITY_TABLE_CMD
[    8.186363] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command COEX_PRIORITY_TABLE_CMD
[    8.186476] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command COEX_PRIORITY_TABLE_CMD
[    8.186519] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[    8.186523] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.187234] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.187300] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[    8.187303] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.187493] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.187533] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[    8.187537] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.187639] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.187657] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[    8.187659] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.187745] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.187784] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[    8.187786] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.187905] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.187934] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[    8.187936] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.188042] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[    8.188051] iwlwifi 0000:01:00.0: U iwl_alive_start Runtime Alive received.
[    8.188056] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_BT_CONFIG
[    8.188059] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_BT_CONFIG
[    8.188120] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_BT_CONFIG
[    8.188159] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_BT_COEX_PRIO_TABLE
[    8.188163] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_BT_COEX_PRIO_TABLE
[    8.188225] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_BT_COEX_PRIO_TABLE
[    8.188248] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_BT_COEX_PROT_ENV
[    8.188250] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_BT_COEX_PROT_ENV
[    8.188444] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_BT_COEX_PROT_ENV
[    8.188459] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_BT_COEX_PROT_ENV
[    8.188463] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_BT_COEX_PROT_ENV
[    8.188524] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_BT_COEX_PROT_ENV
[    8.188551] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command CALIBRATION_CFG_CMD
[    8.188553] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command CALIBRATION_CFG_CMD
[    8.188683] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command CALIBRATION_CFG_CMD
[    8.188712] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command TX_ANT_CONFIGURATION_CMD
[    8.188714] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TX_ANT_CONFIGURATION_CMD
[    8.216571] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TX_ANT_CONFIGURATION_CMD
[    8.216614] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[    8.216620] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[    8.216623] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 1
  * bssid = 00:00:00:00:00:00
[    8.216626] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[    8.216628] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[    8.217890] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[    8.217932] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[    8.217936] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations No active stations found to be cleared
[    8.217939] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[    8.217941] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[    8.217945] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[    8.217947] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[    8.217949] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[    8.218097] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[    8.218100] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[    8.218102] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[    8.218104] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[    8.218106] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[    8.218109] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[    8.218148] iwlwifi 0000:01:00.0: U is_lq_table_valid Channel 0 is not an HT channel
[    8.218152] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[    8.218154] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[    8.218279] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[    8.218316] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[    8.218319] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[    8.218323] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_CT_KILL_CONFIG_CMD
[    8.218325] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_CT_KILL_CONFIG_CMD
[    8.218405] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_CT_KILL_CONFIG_CMD
[    8.218425] iwlwifi 0000:01:00.0: U iwl_rf_kill_ct_config REPLY_CT_KILL_CONFIG_CMD succeeded, critical temperature enter is 114,exit is 95
[    8.218428] iwlwifi 0000:01:00.0: U iwl_alive_start ALIVE processing complete.
[    8.218431] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[    8.218434] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[    8.218526] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[    8.218539] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[    8.218542] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[    8.218550] iwlwifi 0000:01:00.0: U iwlagn_mac_start Start UP work done.
[    8.218555] iwlwifi 0000:01:00.0: U iwlagn_mac_start leave
[    8.218582] iwlwifi 0000:01:00.0: U iwlagn_mac_add_interface enter: type 2, addr c8:f7:33:4b:dd:db
[    8.218587] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[    8.218591] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[    8.218595] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 1
  * bssid = 00:00:00:00:00:00
[    8.218598] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[    8.218601] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[    8.218842] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[    8.218855] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[    8.218858] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[    8.218862] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[    8.218865] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[    8.218869] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[    8.218871] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[    8.218873] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[    8.218970] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[    8.218971] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[    8.218973] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[    8.218983] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[    8.218985] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[    8.218987] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[    8.219002] iwlwifi 0000:01:00.0: U is_lq_table_valid Channel 1 is not an HT channel
[    8.219006] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[    8.219009] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[    8.219098] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[    8.219107] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[    8.219109] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[    8.219114] iwlwifi 0000:01:00.0: U iwlagn_mac_add_interface leave
[    8.219119] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[    8.219122] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[    8.219126] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 1
  * bssid = 00:00:00:00:00:00
[    8.219128] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[    8.219131] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[    8.219396] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[    8.219405] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[    8.219407] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[    8.219410] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[    8.219419] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[    8.219423] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[    8.219426] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[    8.219428] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[    8.219537] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[    8.219539] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[    8.219542] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[    8.219545] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[    8.219547] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[    8.219550] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[    8.219561] iwlwifi 0000:01:00.0: U is_lq_table_valid Channel 1 is not an HT channel
[    8.219563] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[    8.219566] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[    8.219677] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[    8.219686] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[    8.219689] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[    8.219699] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[    8.219702] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[    8.219704] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[    8.219706] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[    8.219709] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[    8.219711] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[    8.219713] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[    8.219715] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[    8.219718] iwlwifi 0000:01:00.0: U iwlagn_update_qos send QoS cmd with Qos active=0 FLAGS=0x0
[    8.219720] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_QOS_PARAM
[    8.219723] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_QOS_PARAM
[    8.219804] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_QOS_PARAM
[    8.219814] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[    8.219818] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0xffffffff
[    8.219820] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[    8.219822] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[    8.219826] iwlwifi 0000:01:00.0: U iwlagn_mac_config TX Power old=0 new=15
[    8.219828] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_POWER_DBM_CMD
[    8.219830] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_POWER_DBM_CMD
[    8.220266] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_POWER_DBM_CMD
[    8.220278] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[    8.220293] iwlwifi 0000:01:00.0: U iwlagn_configure_filter Enter: changed: 0x0, total: 0x80000000
[    8.220297] iwlwifi 0000:01:00.0: U iwlagn_configure_filter Enter: changed: 0x0, total: 0x80000000
[    8.220321] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    8.220325] iwlwifi 0000:01:00.0: U iwlagn_configure_filter Enter: changed: 0x0, total: 0x80000000
[    8.323609] r8169 0000:02:00.0 eth0: link down
[    8.323654] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    8.355555] iwlwifi 0000:01:00.0: U iwlagn_mac_flush enter
[    8.355558] iwlwifi 0000:01:00.0: U iwlagn_mac_flush wait transmit/flush all frames
[    8.355561] iwlwifi 0000:01:00.0: U iwlagn_mac_flush leave
[    8.355572] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x100
[    8.355578] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[    8.355582] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[    8.355715] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[    8.355729] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[    8.355734] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[    8.355738] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[    8.355742] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 1
  * bssid = 00:00:00:00:00:00
[    8.355747] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[    8.355750] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[    8.357512] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[    8.357540] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[    8.357545] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[    8.357549] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[    8.357553] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[    8.357558] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[    8.357561] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[    8.357565] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[    8.359141] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[    8.359144] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[    8.359147] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[    8.359149] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[    8.359151] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[    8.359154] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[    8.359180] iwlwifi 0000:01:00.0: U is_lq_table_valid Channel 1 is not an HT channel
[    8.359183] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[    8.359185] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[    8.360790] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[    8.360818] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[    8.360822] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[    8.360828] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[    8.360833] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan enter
[    8.360841] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_SCAN_CMD
[    8.360844] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
[    8.362630] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
[    8.362657] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan leave
[    9.979085] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan enter
[    9.979092] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_SCAN_CMD
[    9.979095] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
[    9.981974] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
[    9.982008] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan leave
[   10.655330] iwlwifi 0000:01:00.0: U iwlagn_configure_filter Enter: changed: 0xf0, total: 0x800000f0
[   10.655337] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x100
[   10.655340] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave - scanning
[   10.655343] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   10.655346] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x8
[   10.655349] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave - scanning
[   10.655352] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   10.655398] iwlwifi 0000:01:00.0: U iwlagn_configure_filter Enter: changed: 0x80, total: 0x800000f0
[   10.703317] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x10
[   10.703321] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave - scanning
[   10.703323] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   12.716882] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[   12.716886] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 1
  * bssid = 00:00:00:00:00:00
[   12.716890] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   12.716892] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   12.718595] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   12.718610] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   12.718615] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   12.718621] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   12.718624] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   12.718629] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   12.718632] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   12.718635] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   12.718799] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   12.718802] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   12.718805] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   12.718807] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   12.718809] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   12.718812] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   12.718830] iwlwifi 0000:01:00.0: U is_lq_table_valid Channel 1 is not an HT channel
[   12.718833] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   12.718835] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   12.720364] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   12.720375] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   12.720377] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   12.740016] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan enter
[   12.740023] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_SCAN_CMD
[   12.740025] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
[   12.742089] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
[   12.742129] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan leave
[   13.264679] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan enter
[   13.264689] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_SCAN_CMD
[   13.264691] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
[   13.267846] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
[   13.267869] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan leave
[   16.007769] wlan0: authenticate with d8:30:62:54:b9:56
[   16.007785] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x42
[   16.007790] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2806 active=2 idle=2
[   16.007793] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2806 active=2 idle=2
[   16.007796] iwlwifi 0000:01:00.0: U iwl_set_rxon_channel Staging channel set to 9 [0]
[   16.007799] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2806 active=2 idle=2
[   16.007802] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x1 operation mode :0x0 extension channel offset 0x0
[   16.007805] iwlwifi 0000:01:00.0: U iwl_set_rxon_channel Staging channel set to 9 [0]
[   16.007807] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2806 active=2 idle=2
[   16.007809] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   16.007811] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2806 active=2 idle=2
[   16.007814] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x1 operation mode :0x0 extension channel offset 0x0
[   16.007821] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[   16.007824] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 9
  * bssid = 00:00:00:00:00:00
[   16.007828] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   16.007831] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   16.010764] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   16.010779] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   16.010784] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   16.010788] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   16.010790] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   16.010793] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   16.010796] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   16.010798] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   16.012484] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   16.012487] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   16.012490] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   16.012492] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   16.012494] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   16.012497] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   16.012509] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   16.012512] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.014405] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.014431] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   16.014434] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   16.014440] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   16.014445] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2806 active=2 idle=2
[   16.014447] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8005 operation mode :0x0 extension channel offset 0x0
[   16.014449] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2806 active=2 idle=2
[   16.014452] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   16.014454] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2806 active=2 idle=2
[   16.014456] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2806 active=2 idle=2
[   16.014458] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8005 operation mode :0x0 extension channel offset 0x0
[   16.014460] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2806 active=2 idle=2
[   16.014462] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   16.014464] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2806 active=2 idle=2
[   16.014469] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x2
[   16.014471] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.014473] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.014476] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[   16.014478] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 9
  * bssid = 00:00:00:00:00:00
[   16.014481] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   16.014483] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   16.016534] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   16.016600] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   16.016604] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   16.016607] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   16.016609] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   16.016612] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   16.016615] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   16.016617] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   16.018433] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   16.018436] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   16.018438] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   16.018441] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   16.018443] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   16.018445] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   16.018482] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   16.018485] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.020330] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.020341] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   16.020345] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   16.020349] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   16.020354] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.020357] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8005 operation mode :0x0 extension channel offset 0x0
[   16.020359] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.020361] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   16.020363] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.020366] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[   16.020368] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 9
  * bssid = d8:30:62:54:b9:56
[   16.020371] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   16.020373] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   16.022378] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   16.022403] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   16.022406] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   16.022409] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   16.022411] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   16.022414] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   16.022416] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   16.022418] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   16.022625] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   16.022628] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   16.022630] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   16.022633] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   16.022635] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   16.022637] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   16.022662] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   16.022665] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.024491] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.024516] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   16.024519] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   16.024525] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 0->1
[   16.024527] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_add proceeding to add station d8:30:62:54:b9:56
[   16.024530] iwlwifi 0000:01:00.0: I iwl_prep_station Add STA to driver ID 0: d8:30:62:54:b9:56
[   16.024532] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   16.024534] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   16.024536] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   16.026337] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   16.026339] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   16.026342] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 0 addr d8:30:62:54:b9:56 to uCode
[   16.026344] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 0 addr d8:30:62:54:b9:56
[   16.026346] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer d8:30:62:54:b9:56
[   16.026348] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   16.026378] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   16.026388] wlan0: send auth to d8:30:62:54:b9:56 (try 1/3)
[   16.030218] wlan0: authenticated
[   16.030225] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 1->2
[   16.030227] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   16.030940] wlan0: associate with d8:30:62:54:b9:56 (try 1/3)
[   16.034571] wlan0: RX AssocResp from d8:30:62:54:b9:56 (capab=0x411 status=0 aid=3)
[   16.034578] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 2->3
[   16.034581] iwlwifi 0000:01:00.0: U iwl_sta_calc_ht_flags STA d8:30:62:54:b9:56 SM PS mode: disabled
[   16.034584] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (00:00:00:00:00:00) synchronously
[   16.034586] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   16.034588] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   16.034773] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   16.034777] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   16.034779] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   16.034782] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 0 addr d8:30:62:54:b9:56
[   16.034784] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer 00:00:00:00:00:00
[   16.034786] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   16.034812] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state Initializing rate scaling for station d8:30:62:54:b9:56
[   16.034819] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   16.034821] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.034977] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.034987] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 0
[   16.034990] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   16.034992] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   16.034994] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   16.034996] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   16.034997] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   16.034999] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   16.035000] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   16.035002] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   16.035004] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   16.035007] iwlwifi 0000:01:00.0: U iwlagn_update_qos send QoS cmd with Qos active=1 FLAGS=0x3
[   16.035009] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_QOS_PARAM
[   16.035011] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_QOS_PARAM
[   16.035118] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_QOS_PARAM
[   16.035127] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.035129] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8005 operation mode :0x0 extension channel offset 0x0
[   16.035131] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.035133] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   16.035135] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.035138] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[   16.035140] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * with RXON_FILTER_ASSOC_MSK
  * channel = 9
  * bssid = d8:30:62:54:b9:56
[   16.035143] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   16.035144] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   16.035992] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   16.036001] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   16.036003] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 0
[   16.036004] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   16.036007] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   16.036009] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta d8:30:62:54:b9:56
[   16.036011] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   16.036042] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   16.036044] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   16.036045] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   16.037598] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   16.037601] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   16.037603] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 0 addr d8:30:62:54:b9:56 to uCode
[   16.037606] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 0 addr d8:30:62:54:b9:56
[   16.037608] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer d8:30:62:54:b9:56
[   16.037610] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   16.037645] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   16.037648] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.041104] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.041113] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 0
[   16.041116] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   16.041118] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   16.041120] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   16.042946] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   16.042948] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   16.042951] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   16.042953] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   16.042955] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   16.042957] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   16.042967] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   16.042969] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.044796] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   16.044805] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   16.044808] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   16.044811] iwlwifi 0000:01:00.0: U iwl_send_rxon_timing beacon interval 100 beacon timer 102016 beacon tim 0
[   16.044813] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON_TIMING
[   16.044815] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON_TIMING
[   16.046619] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON_TIMING
[   16.046629] iwlwifi 0000:01:00.0: U iwlagn_update_qos send QoS cmd with Qos active=1 FLAGS=0x3
[   16.046631] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_QOS_PARAM
[   16.046633] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_QOS_PARAM
[   16.048422] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_QOS_PARAM
[   16.048509] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   16.048513] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   16.050393] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   16.050488] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_POWER_DBM_CMD
[   16.050492] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_POWER_DBM_CMD
[   16.051190] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_POWER_DBM_CMD
[   16.051216] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[   16.051218] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   16.051375] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   16.051400] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x2
[   16.051403] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.051405] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.051408] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   16.051414] wlan0: associated
[   16.051441] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   16.051528] iwlwifi 0000:01:00.0: U iwlagn_configure_filter Enter: changed: 0x80, total: 0x800000f0
[   16.055127] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key enter
[   16.055132] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   16.055135] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   16.055137] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   16.056816] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   16.056819] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   16.056821] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   16.056824] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 0 addr d8:30:62:54:b9:56
[   16.056826] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer d8:30:62:54:b9:56
[   16.056828] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   16.056837] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key enable hwcrypto key
[   16.056839] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key leave
[   16.056927] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key enter
[   16.056936] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   16.056948] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   16.056951] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   16.057089] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   16.057093] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   16.057096] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   16.057100] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 0 addr d8:30:62:54:b9:56
[   16.057103] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer d8:30:62:54:b9:56
[   16.057107] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   16.057119] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key enable hwcrypto key
[   16.057125] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key leave
[   16.057288] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 3->4
[   16.057291] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   16.057295] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x10
[   16.057300] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[   16.057302] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[   16.057429] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[   16.057484] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[   16.057485] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[   16.074282] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[   16.074308] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   16.074313] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.074315] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8015 operation mode :0x0 extension channel offset 0x0
[   16.074317] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.074319] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   16.074321] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   16.074381] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[   16.074383] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[   16.074544] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[   16.123209] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action enter
[   16.123215] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   16.123218] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   16.123220] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   16.123393] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   16.123396] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   16.123399] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   16.123401] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station id 0 addr d8:30:62:54:b9:56
[   16.123403] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station according to cmd buffer d8:30:62:54:b9:56
[   16.123407] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   16.123442] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action leave
[   17.353725] iwlwifi 0000:01:00.0: U iwlagn_configure_filter Enter: changed: 0x80, total: 0x800000f0
[   18.397890] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   18.397895] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   19.288646] iwlwifi 0000:01:00.0: U iwlagn_configure_filter Enter: changed: 0x80, total: 0x800000f0
[   19.288711] iwlwifi 0000:01:00.0: U iwlagn_configure_filter Enter: changed: 0x80, total: 0x800000f0
[   21.196486] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   21.196492] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8015 operation mode :0x0 extension channel offset 0x0
[   21.196496] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   21.196500] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   21.196504] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   21.196534] iwlwifi 0000:01:00.0: U iwlagn_configure_filter Enter: changed: 0x80, total: 0x800000f0
[   41.038150] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action enter
[   41.038155] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   41.038158] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   41.038161] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   41.038279] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   41.038285] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   41.038291] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   41.038296] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station id 0 addr d8:30:62:54:b9:56
[   41.038299] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station according to cmd buffer d8:30:62:54:b9:56
[   41.038303] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   41.038341] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action leave
[   85.809383] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action enter
[   85.809389] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   85.809392] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   85.809394] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   85.809587] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   85.809591] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   85.809593] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   85.809596] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station id 0 addr d8:30:62:54:b9:56
[   85.809598] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station according to cmd buffer d8:30:62:54:b9:56
[   85.809601] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   85.809637] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action leave
[   91.380695] PM: Syncing filesystems ... done.
[   91.386906] PM: Preparing system for mem sleep
[   91.388960] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   91.399590] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   91.410646] PM: Entering mem sleep
[   91.410855] wlan0: deauthenticating from d8:30:62:54:b9:56 by local choice (reason=3)
[   91.410870] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x10
[   91.410876] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[   91.410879] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[   91.412973] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[   91.413000] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x6406 active=2 idle=1
[   91.413013] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[   91.413015] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[   91.413706] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[   91.413732] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x6406 active=2 idle=1
[   91.413736] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x6406 active=2 idle=1
[   91.413738] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x6406 active=2 idle=1
[   91.413741] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   91.413746] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x6406 active=2 idle=1
[   91.413749] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8015 operation mode :0x0 extension channel offset 0x0
[   91.413751] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x6406 active=2 idle=1
[   91.413753] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   91.413755] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x6406 active=2 idle=1
[   91.413764] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[   91.413766] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[   91.414045] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[   91.414097] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x6406 active=2 idle=1
[   91.414106] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x6406 active=2 idle=1
[   91.414113] iwlwifi 0000:01:00.0: U iwlagn_mac_flush enter
[   91.414115] iwlwifi 0000:01:00.0: U iwlagn_mac_flush wait transmit/flush all frames
[   91.414118] iwlwifi 0000:01:00.0: U iwlagn_mac_flush leave
[   91.414206] iwlwifi 0000:01:00.0: U iwlagn_mac_flush enter
[   91.414208] iwlwifi 0000:01:00.0: U iwlagn_mac_flush wait transmit/flush all frames
[   91.417614] iwlwifi 0000:01:00.0: U iwlagn_mac_flush leave
[   91.417642] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action enter
[   91.417649] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   91.417652] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   91.417655] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   91.417836] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   91.417841] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   91.417843] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   91.417846] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station id 0 addr d8:30:62:54:b9:56
[   91.417848] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station according to cmd buffer d8:30:62:54:b9:56
[   91.417852] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   91.417873] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action leave
[   91.417942] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key enter
[   91.417950] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   91.417953] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   91.417956] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   91.418137] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   91.418141] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   91.418143] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   91.418146] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station id 0 addr d8:30:62:54:b9:56
[   91.418148] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station according to cmd buffer d8:30:62:54:b9:56
[   91.418151] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   91.418194] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key disable hwcrypto key
[   91.418197] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key leave
[   91.418204] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 4->3
[   91.418206] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   91.418209] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 3->2
[   91.418210] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   91.418213] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 2->1
[   91.418214] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   91.418217] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 1->0
[   91.418219] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_remove proceeding to remove station d8:30:62:54:b9:56
[   91.418221] iwlwifi 0000:01:00.0: U iwl_deactivate_station Deactivating STA: d8:30:62:54:b9:56 (0)
[   91.418223] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   91.418241] iwlwifi 0000:01:00.0: U iwlagn_update_qos send QoS cmd with Qos active=0 FLAGS=0x2
[   91.418244] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_QOS_PARAM
[   91.418246] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_QOS_PARAM
[   91.418359] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_QOS_PARAM
[   91.418426] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   91.418429] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8015 operation mode :0x0 extension channel offset 0x0
[   91.418432] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   91.418434] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   91.418436] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   91.418440] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !ether_addr_equal(staging->bssid_addr, active->bssid_addr)
[   91.418442] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 9
  * bssid = 00:00:00:00:00:00
[   91.418445] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   91.418447] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   91.419325] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   91.419367] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   91.419371] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 0
[   91.419374] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   91.419378] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   91.419381] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   91.419384] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   91.419386] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   91.419388] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   91.436032] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   91.436036] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   91.436038] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   91.436041] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   91.436043] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   91.436046] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   91.436081] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   91.436084] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   91.436221] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   91.436235] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   91.436238] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   91.436246] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   91.436250] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   91.436252] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   91.436254] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   91.436256] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   91.436258] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   91.436260] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   91.436262] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   91.436268] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   91.436271] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8005 operation mode :0x0 extension channel offset 0x0
[   91.436273] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   91.436275] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   91.436277] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   91.436281] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x40
[   91.436284] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   91.436286] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   91.436288] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   91.436290] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   91.436295] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   91.436360] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key enter
[   91.436363] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key disable hwcrypto key
[   91.436365] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key leave
[   91.436476] cfg80211: Calling CRDA to update world regulatory domain
[   91.444576] iwlwifi 0000:01:00.0: U iwlagn_mac_flush enter
[   91.444580] iwlwifi 0000:01:00.0: U iwlagn_mac_flush wait transmit/flush all frames
[   91.444583] iwlwifi 0000:01:00.0: U iwlagn_mac_flush leave
[   91.444589] iwlwifi 0000:01:00.0: U iwlagn_mac_remove_interface enter
[   91.444593] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   91.444595] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[   91.444598] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 9
  * bssid = 00:00:00:00:00:00
[   91.444601] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   91.444604] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   91.444875] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   91.444897] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   91.444904] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   91.444915] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   91.444917] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   91.444921] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   91.444923] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   91.444925] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   91.445063] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   91.445066] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   91.445069] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   91.445071] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   91.445073] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   91.445076] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   91.445092] iwlwifi 0000:01:00.0: U is_lq_table_valid Channel 9 is not an HT channel
[   91.445096] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   91.445098] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   91.445280] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   91.445295] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   91.445299] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   91.445305] iwlwifi 0000:01:00.0: U iwlagn_mac_remove_interface leave
[   91.445306] ------------[ cut here ]------------
[   91.445314] WARNING: at net/mac80211/driver-ops.h:12 __ieee80211_suspend+0x91e/0xb30()
[   91.445315] wlan0.mon:  Failed check-sdata-in-driver check, flags: 0x0
[   91.445316] Modules linked in: uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core
[   91.445324] CPU: 0 PID: 2323 Comm: bash Not tainted 3.10.1 #14
[   91.445326] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X4C/900X4D/NP900X3D-A03CH, BIOS P02ABK 09/19/2012
[   91.445327]  ffffffff81ac1e57 ffff880113bc7b38 ffffffff817d6650 ffff880113bc7b78
[   91.445330]  ffffffff81084590 ffff880113bc7b68 ffff880118750640 ffff8801198fe800
[   91.445333]  ffff880118751310 ffff880113bc7fd8 ffff880118750860 ffff880113bc7bd8
[   91.445335] Call Trace:
[   91.445341]  [<ffffffff817d6650>] dump_stack+0x19/0x1b
[   91.445346]  [<ffffffff81084590>] warn_slowpath_common+0x70/0xa0
[   91.445349]  [<ffffffff81084676>] warn_slowpath_fmt+0x46/0x50
[   91.445353]  [<ffffffff817bfc6e>] __ieee80211_suspend+0x91e/0xb30
[   91.445357]  [<ffffffff817971ca>] ieee80211_suspend+0x1a/0x20
[   91.445361]  [<ffffffff8173750c>] wiphy_suspend+0x8c/0x300
[   91.445364]  [<ffffffff81737480>] ? cfg80211_leave_all+0x60/0x60
[   91.445367]  [<ffffffff817d76b5>] legacy_suspend+0x2a/0x58
[   91.445371]  [<ffffffff8140f7d8>] __device_suspend+0x218/0x220
[   91.445374]  [<ffffffff81410890>] dpm_suspend+0x50/0x230
[   91.445377]  [<ffffffff81410cc7>] dpm_suspend_start+0x57/0x60
[   91.445382]  [<ffffffff810c6289>] suspend_devices_and_enter+0xa9/0x420
[   91.445385]  [<ffffffff817d344f>] ? printk+0x4d/0x4f
[   91.445388]  [<ffffffff810c67d0>] pm_suspend+0x1d0/0x230
[   91.445392]  [<ffffffff810c547a>] state_store+0x8a/0x100
[   91.445395]  [<ffffffff812b1e1f>] kobj_attr_store+0xf/0x30
[   91.445399]  [<ffffffff811f0b12>] sysfs_write_file+0xe2/0x170
[   91.445402]  [<ffffffff81185a0e>] vfs_write+0xce/0x1f0
[   91.445405]  [<ffffffff81185f02>] SyS_write+0x52/0xa0
[   91.445408]  [<ffffffff817de9bb>] tracesys+0xdd/0xe2
[   91.445410] ---[ end trace 21aefb9d54b011f4 ]---
[   91.445412] iwlwifi 0000:01:00.0: U iwlagn_mac_remove_interface enter
[   91.445413] ------------[ cut here ]------------
[   91.445417] WARNING: at drivers/net/wireless/iwlwifi/dvm/mac80211.c:1539 iwlagn_mac_remove_interface+0xd4/0x170()
[   91.445417] remove interface with NULL ctx
[   91.445418] Modules linked in: uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core
[   91.445423] CPU: 0 PID: 2323 Comm: bash Tainted: G        W    3.10.1 #14
[   91.445424] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X4C/900X4D/NP900X3D-A03CH, BIOS P02ABK 09/19/2012
[   91.445425]  ffffffff81aa4408 ffff880113bc7ad8 ffffffff817d6650 ffff880113bc7b18
[   91.445427]  ffffffff81084590 ffff880113bc7b78 ffff8801187517e0 0000000000000000
[   91.445430]  ffff8801198ff1d0 ffff880113bc7fd8 ffff880118750860 ffff880113bc7b78
[   91.445433] Call Trace:
[   91.445435]  [<ffffffff817d6650>] dump_stack+0x19/0x1b
[   91.445439]  [<ffffffff81084590>] warn_slowpath_common+0x70/0xa0
[   91.445442]  [<ffffffff81084676>] warn_slowpath_fmt+0x46/0x50
[   91.445444]  [<ffffffff814851f4>] iwlagn_mac_remove_interface+0xd4/0x170
[   91.445448]  [<ffffffff817bf7f1>] __ieee80211_suspend+0x4a1/0xb30
[   91.445451]  [<ffffffff817971ca>] ieee80211_suspend+0x1a/0x20
[   91.445454]  [<ffffffff8173750c>] wiphy_suspend+0x8c/0x300
[   91.445457]  [<ffffffff81737480>] ? cfg80211_leave_all+0x60/0x60
[   91.445459]  [<ffffffff817d76b5>] legacy_suspend+0x2a/0x58
[   91.445462]  [<ffffffff8140f7d8>] __device_suspend+0x218/0x220
[   91.445465]  [<ffffffff81410890>] dpm_suspend+0x50/0x230
[   91.445468]  [<ffffffff81410cc7>] dpm_suspend_start+0x57/0x60
[   91.445471]  [<ffffffff810c6289>] suspend_devices_and_enter+0xa9/0x420
[   91.445474]  [<ffffffff817d344f>] ? printk+0x4d/0x4f
[   91.445477]  [<ffffffff810c67d0>] pm_suspend+0x1d0/0x230
[   91.445479]  [<ffffffff810c547a>] state_store+0x8a/0x100
[   91.445482]  [<ffffffff812b1e1f>] kobj_attr_store+0xf/0x30
[   91.445485]  [<ffffffff811f0b12>] sysfs_write_file+0xe2/0x170
[   91.445487]  [<ffffffff81185a0e>] vfs_write+0xce/0x1f0
[   91.445490]  [<ffffffff81185f02>] SyS_write+0x52/0xa0
[   91.445493]  [<ffffffff817de9bb>] tracesys+0xdd/0xe2
[   91.445494] ---[ end trace 21aefb9d54b011f5 ]---
[   91.445541] iwlwifi 0000:01:00.0: U iwlagn_mac_stop enter
[   91.445543] iwlwifi 0000:01:00.0: U iwl_down iwlwifi is going down
[   91.445548] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   91.445550] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   91.446243] iwlwifi 0000:01:00.0: U iwl_pcie_apm_stop Stop card, put in low power state
[   91.446278] iwlwifi 0000:01:00.0: U iwl_pcie_apm_stop_master stop master
[   91.446344] iwlwifi 0000:01:00.0: U iwl_pcie_apm_stop Stop card, put in low power state
[   91.446366] iwlwifi 0000:01:00.0: U iwl_pcie_apm_stop_master stop master
[   91.446441] iwlwifi 0000:01:00.0: U iwlagn_mac_stop leave
[   91.446549] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   91.446900] sd 0:0:0:0: [sda] Stopping disk
[   91.459917] mei_me 0000:00:16.0: suspend
[   92.607064] PM: suspend of devices complete after 1195.697 msecs
[   92.607186] PM: late suspend of devices complete after 0.118 msecs
[   92.662106] PM: noirq suspend of devices complete after 54.893 msecs
[   92.662419] ACPI: Preparing to enter system sleep state S3
[   92.663254] PM: Saving platform NVS memory
[   92.663864] Disabling non-boot CPUs ...
[   92.665772] smpboot: CPU 1 is now offline
[   92.667555] smpboot: CPU 2 is now offline
[   92.669434] smpboot: CPU 3 is now offline
[   92.670929] ACPI: Low-level resume complete
[   92.670978] PM: Restoring platform NVS memory
[   92.671351] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x17
[   92.671438] Enabling non-boot CPUs ...
[   92.671476] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   92.685496] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x15
[   92.686421] microcode: CPU1 updated to revision 0x17, date = 2013-01-09
[   92.686475] CPU1 is up
[   92.686496] smpboot: Booting Node 0 Processor 2 APIC 0x2
[   92.700464] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x15
[   92.700978] microcode: CPU2 updated to revision 0x17, date = 2013-01-09
[   92.701016] CPU2 is up
[   92.701036] smpboot: Booting Node 0 Processor 3 APIC 0x3
[   92.715004] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x17
[   92.715043] CPU3 is up
[   92.719037] ACPI: Waking up from system sleep state S3
[   92.809146] PM: noirq resume of devices complete after 87.676 msecs
[   92.809299] PM: early resume of devices complete after 0.106 msecs
[   92.809328] i915 0000:00:02.0: setting latency timer to 64
[   92.809360] mei_me 0000:00:16.0: irq 41 for MSI/MSI-X
[   92.809408] ahci 0000:00:1f.2: setting latency timer to 64
[   92.809605] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
[   92.810924] ehci-pci 0000:00:1d.0: setting latency timer to 64
[   92.820046] dpm_run_callback(): pnp_bus_resume+0x0/0x70 returns -19
[   92.820050] PM: Device 00:07 failed to resume: error -19
[   92.915575] r8169 0000:02:00.0 eth0: link down
[   93.116029] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   93.118324] ata1.00: configured for UDMA/133
[   93.129201] sd 0:0:0:0: [sda] Starting disk
[   93.526366] iwlwifi 0000:01:00.0: U iwlagn_mac_start enter
[   93.526372] iwlwifi 0000:01:00.0: I iwl_prep_station Add STA to driver ID 15: ff:ff:ff:ff:ff:ff
[   93.526377] iwlwifi 0000:01:00.0: I iwl_prep_station Add STA to driver ID 14: ff:ff:ff:ff:ff:ff
[   93.526381] iwlwifi 0000:01:00.0: U iwl_pcie_prepare_card_hw iwl_trans_prepare_card_hw enter
[   93.526421] iwlwifi 0000:01:00.0: U iwl_pcie_set_hw_ready hardware ready
[   93.526449] iwlwifi 0000:01:00.0: U iwl_pcie_apm_init Init card's basic functions
[   93.526539] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   93.533503] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
[   93.695177] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command COEX_PRIORITY_TABLE_CMD
[   93.695182] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command COEX_PRIORITY_TABLE_CMD
[   93.695324] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command COEX_PRIORITY_TABLE_CMD
[   93.695364] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[   93.695368] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.696014] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.696054] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[   93.696057] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.696205] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.696255] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[   93.696258] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.696428] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.696501] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[   93.696505] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.696651] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.696688] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[   93.696691] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.696844] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.696881] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[   93.696885] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.697023] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   93.697060] iwlwifi 0000:01:00.0: U iwl_alive_start Runtime Alive received.
[   93.697064] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_BT_CONFIG
[   93.697067] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_BT_CONFIG
[   93.697197] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_BT_CONFIG
[   93.697222] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_BT_COEX_PRIO_TABLE
[   93.697224] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_BT_COEX_PRIO_TABLE
[   93.697299] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_BT_COEX_PRIO_TABLE
[   93.697312] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_BT_COEX_PROT_ENV
[   93.697314] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_BT_COEX_PROT_ENV
[   93.697402] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_BT_COEX_PROT_ENV
[   93.697425] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_BT_COEX_PROT_ENV
[   93.697427] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_BT_COEX_PROT_ENV
[   93.697515] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_BT_COEX_PROT_ENV
[   93.697522] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command CALIBRATION_CFG_CMD
[   93.697524] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command CALIBRATION_CFG_CMD
[   93.697623] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command CALIBRATION_CFG_CMD
[   93.697630] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command TX_ANT_CONFIGURATION_CMD
[   93.697632] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TX_ANT_CONFIGURATION_CMD
[   93.725478] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TX_ANT_CONFIGURATION_CMD
[   93.725489] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   93.725494] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[   93.725497] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 9
  * bssid = 00:00:00:00:00:00
[   93.725499] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   93.725501] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   93.727017] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   93.727041] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   93.727044] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations No active stations found to be cleared
[   93.727048] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   93.727050] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   93.727054] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   93.727056] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   93.727058] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   93.727157] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   93.727159] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   93.727162] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   93.727164] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   93.727167] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   93.727170] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   93.727192] iwlwifi 0000:01:00.0: U is_lq_table_valid Channel 9 is not an HT channel
[   93.727194] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   93.727196] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   93.727362] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   93.727370] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   93.727373] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   93.727376] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_CT_KILL_CONFIG_CMD
[   93.727378] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_CT_KILL_CONFIG_CMD
[   93.727465] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_CT_KILL_CONFIG_CMD
[   93.727472] iwlwifi 0000:01:00.0: U iwl_rf_kill_ct_config REPLY_CT_KILL_CONFIG_CMD succeeded, critical temperature enter is 114,exit is 95
[   93.727474] iwlwifi 0000:01:00.0: U iwl_alive_start ALIVE processing complete.
[   93.727477] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[   93.727479] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[   93.727568] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[   93.727575] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   93.727577] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   93.727583] iwlwifi 0000:01:00.0: U iwlagn_mac_start Start UP work done.
[   93.727585] iwlwifi 0000:01:00.0: U iwlagn_mac_start leave
[   93.727589] iwlwifi 0000:01:00.0: U iwlagn_mac_add_interface enter: type 2, addr c8:f7:33:4b:dd:db
[   93.727593] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   93.727595] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[   93.727598] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 9
  * bssid = 00:00:00:00:00:00
[   93.727600] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   93.727602] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   93.727880] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   93.727902] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   93.727905] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   93.727907] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   93.727909] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   93.727912] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   93.727914] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   93.727916] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   93.728037] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   93.728039] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   93.728041] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   93.728043] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   93.728046] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   93.728048] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   93.728070] iwlwifi 0000:01:00.0: U is_lq_table_valid Channel 9 is not an HT channel
[   93.728072] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   93.728074] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   93.728219] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   93.728240] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   93.728243] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   93.728248] iwlwifi 0000:01:00.0: U iwlagn_mac_add_interface leave
[   93.728250] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   93.728252] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   93.728254] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   93.728255] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   93.728263] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   93.728266] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   93.728268] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   93.728271] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   93.728276] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0xffffffff
[   93.728281] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   93.728283] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   93.728288] iwlwifi 0000:01:00.0: U iwlagn_mac_config TX Power old=15 new=15
[   93.728291] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   93.728294] iwlwifi 0000:01:00.0: U iwlagn_configure_filter Enter: changed: 0x80, total: 0x800000f0
[   93.728297] iwlwifi 0000:01:00.0: U iwlagn_update_qos send QoS cmd with Qos active=0 FLAGS=0x0
[   93.728299] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_QOS_PARAM
[   93.728301] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_QOS_PARAM
[   93.728412] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_QOS_PARAM
[   93.728435] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   93.728438] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[   93.728440] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 9
  * bssid = 00:00:00:00:00:00
[   93.728443] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   93.728445] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   93.728724] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   93.728760] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   93.728764] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   93.728767] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   93.728770] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   93.728773] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   93.728775] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   93.728777] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   93.728900] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   93.728902] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   93.728905] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   93.728907] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   93.728909] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   93.728911] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   93.728947] iwlwifi 0000:01:00.0: U is_lq_table_valid Channel 9 is not an HT channel
[   93.728951] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   93.728954] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   93.729074] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   93.729097] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   93.729099] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   93.729131] PM: resume of devices complete after 919.418 msecs
[   93.729370] PM: Finishing wakeup.
[   93.730005] usb 1-1.5: USB disconnect, device number 3
[   93.729372] Restarting tasks ... done.
[   93.734448] video LNXVIDEO:00: Restoring backlight state
[   93.803483] usb 1-1.5: new full-speed USB device number 5 using ehci-pci
[   93.830658] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan enter
[   93.830666] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_SCAN_CMD
[   93.830668] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
[   93.831833] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
[   93.831844] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan leave
[   93.893008] usb 1-1.5: New USB device found, idVendor=8087, idProduct=07da
[   93.893011] usb 1-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   93.894292] usb 1-1.6: USB disconnect, device number 4
[   93.984586] usb 1-1.6: new high-speed USB device number 6 using ehci-pci
[   94.394822] usb 1-1.6: New USB device found, idVendor=2232, idProduct=1024
[   94.394827] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   94.394829] usb 1-1.6: Product: Webcam SC-13HDL11624N
[   94.394832] usb 1-1.6: Manufacturer: Namugaÿ 
[   94.407886] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan enter
[   94.407893] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_SCAN_CMD
[   94.407895] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
[   94.409232] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
[   94.409245] iwlwifi 0000:01:00.0: U iwlagn_mac_hw_scan leave
[   94.618431] uvcvideo: Found UVC 1.00 device Webcam SC-13HDL11624N (2232:1024)
[   94.700986] input: Webcam SC-13HDL11624N as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input10
[   94.774118] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[   97.145344] wlan0: authenticate with d8:30:62:54:b9:56
[   97.145359] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x42
[   97.145365] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145369] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145373] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145377] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8005 operation mode :0x0 extension channel offset 0x0
[   97.145381] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145385] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8005 operation mode :0x0 extension channel offset 0x0
[   97.145388] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145392] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   97.145397] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   97.145402] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145406] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8005 operation mode :0x0 extension channel offset 0x0
[   97.145410] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145413] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   97.145417] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145422] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x2
[   97.145425] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145429] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145432] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   97.145438] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145442] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8005 operation mode :0x0 extension channel offset 0x0
[   97.145445] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145449] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   97.145453] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.145457] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[   97.145462] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * without RXON_FILTER_ASSOC_MSK
  * channel = 9
  * bssid = d8:30:62:54:b9:56
[   97.145466] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   97.145470] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   97.145775] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   97.145797] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   97.145800] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   97.145803] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   97.145805] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   97.145809] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   97.145813] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   97.145816] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   97.145920] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   97.145924] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   97.145927] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   97.145930] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   97.145933] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   97.145937] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   97.145961] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   97.145964] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   97.146075] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   97.146099] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   97.146101] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   97.146110] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 0->1
[   97.146114] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_add proceeding to add station d8:30:62:54:b9:56
[   97.146118] iwlwifi 0000:01:00.0: I iwl_prep_station Add STA to driver ID 0: d8:30:62:54:b9:56
[   97.146122] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   97.146125] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   97.146127] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   97.146239] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   97.146243] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   97.146247] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 0 addr d8:30:62:54:b9:56 to uCode
[   97.146251] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 0 addr d8:30:62:54:b9:56
[   97.146254] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer d8:30:62:54:b9:56
[   97.146259] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   97.146274] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   97.146281] wlan0: send auth to d8:30:62:54:b9:56 (try 1/3)
[   97.148428] wlan0: authenticated
[   97.148433] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 1->2
[   97.148435] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   97.148815] wlan0: associate with d8:30:62:54:b9:56 (try 1/3)
[   97.152515] wlan0: RX AssocResp from d8:30:62:54:b9:56 (capab=0x411 status=0 aid=3)
[   97.152522] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 2->3
[   97.152525] iwlwifi 0000:01:00.0: U iwl_sta_calc_ht_flags STA d8:30:62:54:b9:56 SM PS mode: disabled
[   97.152528] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (00:00:00:00:00:00) synchronously
[   97.152530] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   97.152532] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   97.152654] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   97.152658] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   97.152660] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   97.152663] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 0 addr d8:30:62:54:b9:56
[   97.152665] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer 00:00:00:00:00:00
[   97.152668] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   97.152729] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state Initializing rate scaling for station d8:30:62:54:b9:56
[   97.152737] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   97.152739] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   97.152856] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   97.152868] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 0
[   97.152874] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   97.152880] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   97.152882] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   97.152885] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   97.152888] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   97.152890] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   97.152893] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   97.152895] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx enter
[   97.152898] iwlwifi 0000:01:00.0: U iwlagn_mac_conf_tx leave
[   97.152904] iwlwifi 0000:01:00.0: U iwlagn_update_qos send QoS cmd with Qos active=1 FLAGS=0x3
[   97.152908] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_QOS_PARAM
[   97.152911] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_QOS_PARAM
[   97.152990] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_QOS_PARAM
[   97.153003] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.153006] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8005 operation mode :0x0 extension channel offset 0x0
[   97.153008] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.153011] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   97.153013] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.153016] iwlwifi 0000:01:00.0: U iwl_full_rxon_required need full RXON - !iwl_is_associated_ctx(ctx)
[   97.153019] iwlwifi 0000:01:00.0: U iwlagn_commit_rxon Going to commit RXON
  * with RXON_FILTER_ASSOC_MSK
  * channel = 9
  * bssid = d8:30:62:54:b9:56
[   97.153021] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   97.153023] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   97.153704] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   97.153713] iwlwifi 0000:01:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[   97.153716] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 0
[   97.153719] iwlwifi 0000:01:00.0: I iwl_clear_ucode_stations Clearing ucode active for station 15
[   97.153722] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations ... start.
[   97.153725] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta d8:30:62:54:b9:56
[   97.153728] iwlwifi 0000:01:00.0: I iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[   97.153732] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   97.153735] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   97.153737] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   97.153828] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   97.153830] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   97.153832] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 0 addr d8:30:62:54:b9:56 to uCode
[   97.153834] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 0 addr d8:30:62:54:b9:56
[   97.153836] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer d8:30:62:54:b9:56
[   97.153838] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   97.153856] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   97.153863] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   97.153963] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   97.153973] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 0
[   97.153977] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[   97.153980] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   97.153983] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   97.154970] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 15
[   97.154972] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   97.154975] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[   97.154977] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[   97.154979] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[   97.154982] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   97.154993] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[   97.154995] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   97.155226] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[   97.155233] iwlwifi 0000:01:00.0: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[   97.155236] iwlwifi 0000:01:00.0: U iwl_restore_stations Restoring all known stations .... complete.
[   97.155239] iwlwifi 0000:01:00.0: U iwl_send_rxon_timing beacon interval 100 beacon timer 102016 beacon tim 0
[   97.155241] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON_TIMING
[   97.155243] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON_TIMING
[   97.155744] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON_TIMING
[   97.155751] iwlwifi 0000:01:00.0: U iwlagn_update_qos send QoS cmd with Qos active=1 FLAGS=0x3
[   97.155753] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_QOS_PARAM
[   97.155755] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_QOS_PARAM
[   97.155853] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_QOS_PARAM
[   97.155862] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_RXON
[   97.155866] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[   97.156089] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[   97.156102] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_TX_POWER_DBM_CMD
[   97.156105] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_TX_POWER_DBM_CMD
[   97.156808] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_POWER_DBM_CMD
[   97.156819] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[   97.156821] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   97.156899] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[   97.156913] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x2
[   97.156918] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x6406 active=2 idle=1
[   97.156921] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x6406 active=2 idle=1
[   97.156926] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[   97.156928] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[   97.173811] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[   97.173824] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   97.173831] wlan0: associated
[   97.177572] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key enter
[   97.177577] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   97.177580] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   97.177582] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   97.179260] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   97.179263] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   97.179265] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   97.179268] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 0 addr d8:30:62:54:b9:56
[   97.179270] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer d8:30:62:54:b9:56
[   97.179273] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   97.179284] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key enable hwcrypto key
[   97.179286] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key leave
[   97.179379] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key enter
[   97.179387] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   97.179390] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   97.179394] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   97.179563] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   97.179566] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   97.179569] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   97.179571] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station id 0 addr d8:30:62:54:b9:56
[   97.179574] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer d8:30:62:54:b9:56
[   97.179577] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   97.179586] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key enable hwcrypto key
[   97.179588] iwlwifi 0000:01:00.0: U iwlagn_mac_set_key leave
[   97.179707] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state station d8:30:62:54:b9:56 state change 3->4
[   97.179711] iwlwifi 0000:01:00.0: U iwlagn_mac_sta_state leave
[   97.179717] iwlwifi 0000:01:00.0: U iwlagn_mac_config enter: changed 0x10
[   97.179723] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[   97.179725] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[   97.179857] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[   97.179868] iwlwifi 0000:01:00.0: U iwlagn_mac_config leave
[   97.179873] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.179879] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x8015 operation mode :0x0 extension channel offset 0x0
[   97.179884] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.179889] iwlwifi 0000:01:00.0: U _iwl_set_rxon_ht rxon flags 0x5 operation mode :0x0 extension channel offset 0x0
[   97.179894] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   97.179958] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command POWER_TABLE_CMD
[   97.179960] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[   97.180117] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[   97.834734] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action enter
[   97.834741] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[   97.834744] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[   97.834746] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[   97.834955] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[   97.834958] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[   97.834961] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[   97.834963] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station id 0 addr d8:30:62:54:b9:56
[   97.834966] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station according to cmd buffer d8:30:62:54:b9:56
[   97.834969] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[   97.835010] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action leave
[   99.574786] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[   99.574788] iwlwifi 0000:01:00.0: U iwlagn_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[  108.175828] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action enter
[  108.175835] iwlwifi 0000:01:00.0: U iwl_send_add_sta Adding sta 0 (d8:30:62:54:b9:56) synchronously
[  108.175839] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Attempting to send sync command REPLY_ADD_STA
[  108.175842] iwlwifi 0000:01:00.0: U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  108.177972] iwlwifi 0000:01:00.0: U iwl_process_add_sta_resp Processing response for adding station 0
[  108.177977] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  108.177980] iwlwifi 0000:01:00.0: I iwl_sta_ucode_activate STA id 0 addr d8:30:62:54:b9:56 already present in uCode (according to driver)
[  108.177982] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station id 0 addr d8:30:62:54:b9:56
[  108.177984] iwlwifi 0000:01:00.0: I iwl_process_add_sta_resp Modified station according to cmd buffer d8:30:62:54:b9:56
[  108.177989] iwlwifi 0000:01:00.0: I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  108.178011] iwlwifi 0000:01:00.0: U iwlagn_mac_ampdu_action leave

--------------050601040200080005070802--
