Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaELQcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:32:15 -0400
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:43963
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaELQcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:32:11 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=TM7LSjVa c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=EBe6uRzgOt0A:10
 a=uObrxnre4hsA:10 a=NLZqzBF-AAAA:8 a=RszPvMDyn-lisQlVvJsA:9 a=QEXdDO2ut3YA:10
 a=pSDxxfrZAAAA:8 a=8yhHj9xqSikg5UXHXVYA:9 a=Szrbvnva-0tNrXJo:21
 a=QHBgFwD-YqCclW8W:21 a=BNmsW9_eUzpZUaiZ:21 a=CjuIK1q_8ugA:10
 a=57ZKFFc7odEA:10 a=qqlwiqL-QEIA:10 a=h71UUtTGq9UA:10 a=m7jhuX_RuCIA:10
 a=JXQJvpueyLIA:10 a=4MV12Pj9_AoA:10 a=mwllne9av5XzT20hiMwA:9
 a=u7MbWol10lqYAoOc:21 a=hZIO6tDpuuEH191T:21
Date: Mon, 12 May 2014 17:32:07 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: More breakage on HD7480D [ Aruba ]
Message-ID: <20140512163207.GA23680@milliways>
References: <20140512003405.GA3386@milliways>
 <20140512010310.GA4370@milliways>
 <53707926.5090609@amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53707926.5090609@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, May 12, 2014 at 09:32:54AM +0200, Christian König wrote:
> Hi Ken,
> 
> *sigh* did I already mentioned that I hate PLLs? As soon as you fix
> something another use case immediately starts to break.
> 
> Please provide dmesg output created with drm.debug=0xe with and without the
> patch breaking it.
> 
> Thanks in advance,
> Christian.
> 

 The reverted version is from linus's tree after -rc5 with the patch
reverted, I assume the version -00010-gc9a25d0fc393 will NOT match
any public tree because I used git revert in a local branch.  That
one works fine.

 The bad version is from a random kernel which showed the problem
while I was bisecting, in this case rc2-00086.  I first tried
booting vanilla rc5, but for some reason my blind attempt to login
and run 'dmesg >dmesg.bad' failed.

 Thanks.  Sorry you are having to deal with PLLs.

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.reverted"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc5-00010-gc9a25d0fc393 (ken@bluesbreaker) (gcc version 4.8.1 (GCC) ) #17 SMP PREEMPT Mon May 12 01:12:02 BST 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.15.0-rc5-00010-gc9a25d0fc393-sda10 root=/dev/sda10 drm.debug=0xe ro
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009e2b8fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009e2b9000-0x000000009e2ecfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009e2ed000-0x000000009e2f4fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009e2f5000-0x000000009e642fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009e643000-0x000000009edd5fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009edd6000-0x000000009edd6fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009edd7000-0x000000009efdcfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009efdd000-0x000000009f44bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000009f44c000-0x000000009f7dcfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009f7dd000-0x000000009f7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000013effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A55M-DS2, BIOS F3 09/28/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x13f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFE0000000 write-back
[    0.000000]   2 base 00009F800000 mask FFFFFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000013f000000 aka 5104M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0x9f800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x9f800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd750-0x000fd75f] mapped at [ffff8800000fd750]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01e65000, 0x01e65fff] PGTABLE
[    0.000000] BRK [0x01e66000, 0x01e66fff] PGTABLE
[    0.000000] BRK [0x01e67000, 0x01e67fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13ee00000-0x13effffff]
[    0.000000]  [mem 0x13ee00000-0x13effffff] page 2M
[    0.000000] BRK [0x01e68000, 0x01e68fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13c000000-0x13edfffff]
[    0.000000]  [mem 0x13c000000-0x13edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100001000-0x13bffffff]
[    0.000000]  [mem 0x100001000-0x1001fffff] page 4k
[    0.000000]  [mem 0x100200000-0x13bffffff] page 2M
[    0.000000] BRK [0x01e69000, 0x01e69fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x9e2b8fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0x9e1fffff] page 2M
[    0.000000]  [mem 0x9e200000-0x9e2b8fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9edd6000-0x9edd6fff]
[    0.000000]  [mem 0x9edd6000-0x9edd6fff] page 4k
[    0.000000] BRK [0x01e6a000, 0x01e6afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x9efdd000-0x9f44bfff]
[    0.000000]  [mem 0x9efdd000-0x9effffff] page 4k
[    0.000000]  [mem 0x9f000000-0x9f3fffff] page 2M
[    0.000000]  [mem 0x9f400000-0x9f44bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9f7dd000-0x9f7fffff]
[    0.000000]  [mem 0x9f7dd000-0x9f7fffff] page 4k
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x000000009E2EE088 00008C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x000000009E2F3850 0000F4 (v04 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20140214/tbfadt-634)
[    0.000000] ACPI: DSDT 0x000000009E2EE1A0 0056AC (v02 ALASKA A M I    00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0x000000009E63BD80 000040
[    0.000000] ACPI: APIC 0x000000009E2F3948 000072 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x000000009E2F39C0 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x000000009E2F3A08 00003C (v01 ALASKA A M I    01072009 MSFT 00010013)
[    0.000000] ACPI: MSDM 0x000000009E2F3A48 000055 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: HPET 0x000000009E2F3AA0 000038 (v01 ALASKA A M I    01072009 AMI  00000005)
[    0.000000] ACPI: MSDM 0x000000009E2F3AD8 000055 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: IFEU 0x000000009E2F3B30 000042 (v01 ALASKA A M I    01072009      00000000)
[    0.000000] ACPI: SSDT 0x000000009E2F3B78 0006B2 (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 0x000000009E2F4230 0004B7 (v02 AMD    ALIB     00000001 MSFT 04000000)
[    0.000000] ACPI: IVRS 0x000000009E2F46E8 000070 (v02 AMD    AMDIOMMU 00000001 AMD  00000000)
[    0.000000] ACPI: CRAT 0x000000009E2F4758 0001F8 (v01 AMD    AGESA    00000001 AMD  00000001)
[    0.000000] ACPI: BGRT 0x000000009E2F4950 000038 (v00 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013ae00000-ffff88013e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x9e2b8fff]
[    0.000000]   node   0: [mem 0x9edd6000-0x9edd6fff]
[    0.000000]   node   0: [mem 0x9efdd000-0x9f44bfff]
[    0.000000]   node   0: [mem 0x9f7dd000-0x9f7fffff]
[    0.000000]   node   0: [mem 0x100001000-0x13effffff]
[    0.000000] On node 0 totalpages: 906984
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10078 pages used for memmap
[    0.000000]   DMA32 zone: 644940 pages, LIFO batch:31
[    0.000000]   Normal zone: 4032 pages used for memmap
[    0.000000]   Normal zone: 258047 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x15] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 3, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10228210 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9e2b9000-0x9e2ecfff]
[    0.000000] PM: Registered nosave memory: [mem 0x9e2ed000-0x9e2f4fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9e2f5000-0x9e642fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9e643000-0x9edd5fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9edd7000-0x9efdcfff]
[    0.000000] PM: Registered nosave memory: [mem 0x9f44c000-0x9f7dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0x9f800000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed80000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x100000000-0x100000fff]
[    0.000000] e820: [mem 0x9f800000-0xfebfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013ec00000 s80768 r8192 d21632 u524288
[    0.000000] pcpu-alloc: s80768 r8192 d21632 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 892789
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.15.0-rc5-00010-gc9a25d0fc393-sda10 root=/dev/sda10 drm.debug=0xe ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 0 size 32 MB
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 94000000
[    0.000000] PM: Registered nosave memory: [mem 0x94000000-0x97ffffff]
[    0.000000] Memory: 3417476K/3627936K available (8162K kernel code, 756K rwdata, 3676K rodata, 1160K init, 932K bss, 210460K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NO_HZ: Full dynticks CPUs: 1-7.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3394.056 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6788.11 BogoMIPS (lpj=13576224)
[    0.000068] pid_max: default: 32768 minimum: 301
[    0.000103] ACPI: Core revision 20140214
[    0.004891] ACPI: All ACPI Tables successfully acquired
[    0.005150] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.005183] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.005380] Initializing cgroup subsys debug
[    0.005425] tseg: 009f800000
[    0.005427] CPU: Physical Processor ID: 0
[    0.005458] CPU: Processor Core ID: 0
[    0.005490] mce: CPU supports 7 MCE banks
[    0.005530] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
tlb_flushall_shift: 6
[    0.005655] Freeing SMP alternatives memory: 24K (ffffffff81d74000 - ffffffff81d7a000)
[    0.005691] ftrace: allocating 29309 entries in 115 pages
[    0.015881] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.055642] smpboot: CPU0: AMD A4-5300 APU with Radeon(tm) HD Graphics (fam: 15, model: 10, stepping: 01)
[    0.163124] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    0.163242] ... version:                0
[    0.163273] ... bit width:              48
[    0.163304] ... generic registers:      6
[    0.163336] ... value mask:             0000ffffffffffff
[    0.163368] ... max period:             00007fffffffffff
[    0.163400] ... fixed-purpose events:   0
[    0.163431] ... event mask:             000000000000003f
[    0.195301] x86: Booting SMP configuration:
[    0.195338] .... node  #0, CPUs:      #1
[    0.208509] x86: Booted up 1 node, 2 CPUs
[    0.208574] smpboot: Total of 2 processors activated (13576.22 BogoMIPS)
[    0.208968] devtmpfs: initialized
[    0.209214] PM: Registering ACPI NVS region [mem 0x9e2f5000-0x9e642fff] (3465216 bytes)
[    0.209308] PM: Registering ACPI NVS region [mem 0x9edd7000-0x9efdcfff] (2121728 bytes)
[    0.210812] NET: Registered protocol family 16
[    0.210988] cpuidle: using governor ladder
[    0.211022] cpuidle: using governor menu
[    0.211096] ACPI: bus type PCI registered
[    0.211199] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.211239] PCI: not using MMCONFIG
[    0.211272] PCI: Using configuration type 1 for base access
[    0.211305] PCI: Using configuration type 1 for extended access
[    0.215779] ACPI: Added _OSI(Module Device)
[    0.215816] ACPI: Added _OSI(Processor Device)
[    0.215850] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.215882] ACPI: Added _OSI(Processor Aggregator Device)
[    0.219565] ACPI: Executed 1 blocks of module-level executable AML code
[    0.224675] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.225333] ACPI: Interpreter enabled
[    0.225371] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.225465] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.225574] ACPI: (supports S0 S3 S4 S5)
[    0.225606] ACPI: Using IOAPIC for interrupt routing
[    0.225877] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.225979] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.243239] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.331631] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.331672] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.332194] acpi PNP0A03:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.332760] PCI host bridge to bus 0000:00
[    0.332795] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.332831] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.332866] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.332899] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.332932] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.332965] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.332998] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.333030] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
[    0.333069] pci 0000:00:00.0: [1022:1410] type 00 class 0x060000
[    0.333200] pci 0000:00:00.2: [1022:1419] type 00 class 0x080600
[    0.333352] pci 0000:00:01.0: [1002:9993] type 00 class 0x030000
[    0.333362] pci 0000:00:01.0: reg 0x10: [mem 0xc0000000-0xcfffffff pref]
[    0.333369] pci 0000:00:01.0: reg 0x14: [io  0xf000-0xf0ff]
[    0.333375] pci 0000:00:01.0: reg 0x18: [mem 0xfef00000-0xfef3ffff]
[    0.333412] pci 0000:00:01.0: supports D1 D2
[    0.333515] pci 0000:00:01.1: [1002:9902] type 00 class 0x040300
[    0.333524] pci 0000:00:01.1: reg 0x10: [mem 0xfef44000-0xfef47fff]
[    0.333569] pci 0000:00:01.1: supports D1 D2
[    0.333678] pci 0000:00:04.0: [1022:1414] type 01 class 0x060400
[    0.333724] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.333799] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.333898] pci 0000:00:11.0: [1022:7801] type 00 class 0x010601
[    0.333917] pci 0000:00:11.0: reg 0x10: [io  0xf190-0xf197]
[    0.333926] pci 0000:00:11.0: reg 0x14: [io  0xf180-0xf183]
[    0.333935] pci 0000:00:11.0: reg 0x18: [io  0xf170-0xf177]
[    0.333943] pci 0000:00:11.0: reg 0x1c: [io  0xf160-0xf163]
[    0.333952] pci 0000:00:11.0: reg 0x20: [io  0xf150-0xf15f]
[    0.333960] pci 0000:00:11.0: reg 0x24: [mem 0xfef4f000-0xfef4f7ff]
[    0.334106] pci 0000:00:12.0: [1022:7807] type 00 class 0x0c0310
[    0.334119] pci 0000:00:12.0: reg 0x10: [mem 0xfef4e000-0xfef4efff]
[    0.334238] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.334324] pci 0000:00:12.2: [1022:7808] type 00 class 0x0c0320
[    0.334343] pci 0000:00:12.2: reg 0x10: [mem 0xfef4d000-0xfef4d0ff]
[    0.334415] pci 0000:00:12.2: supports D1 D2
[    0.334417] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.334497] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.334582] pci 0000:00:13.0: [1022:7807] type 00 class 0x0c0310
[    0.334595] pci 0000:00:13.0: reg 0x10: [mem 0xfef4c000-0xfef4cfff]
[    0.334713] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.334801] pci 0000:00:13.2: [1022:7808] type 00 class 0x0c0320
[    0.334819] pci 0000:00:13.2: reg 0x10: [mem 0xfef4b000-0xfef4b0ff]
[    0.334892] pci 0000:00:13.2: supports D1 D2
[    0.334894] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.334969] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.335054] pci 0000:00:14.0: [1022:780b] type 00 class 0x0c0500
[    0.335210] pci 0000:00:14.1: [1022:780c] type 00 class 0x01018a
[    0.335223] pci 0000:00:14.1: reg 0x10: [io  0xf140-0xf147]
[    0.335233] pci 0000:00:14.1: reg 0x14: [io  0xf130-0xf133]
[    0.335242] pci 0000:00:14.1: reg 0x18: [io  0xf120-0xf127]
[    0.335252] pci 0000:00:14.1: reg 0x1c: [io  0xf110-0xf113]
[    0.335260] pci 0000:00:14.1: reg 0x20: [io  0xf100-0xf10f]
[    0.335283] pci 0000:00:14.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.335317] pci 0000:00:14.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.335350] pci 0000:00:14.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.335383] pci 0000:00:14.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.335527] pci 0000:00:14.2: [1022:780d] type 00 class 0x040300
[    0.335547] pci 0000:00:14.2: reg 0x10: [mem 0xfef40000-0xfef43fff 64bit]
[    0.335607] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.335680] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.335760] pci 0000:00:14.3: [1022:780e] type 00 class 0x060100
[    0.335922] pci 0000:00:14.4: [1022:780f] type 01 class 0x060401
[    0.336023] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.336102] pci 0000:00:14.5: [1022:7809] type 00 class 0x0c0310
[    0.336115] pci 0000:00:14.5: reg 0x10: [mem 0xfef4a000-0xfef4afff]
[    0.336233] pci 0000:00:14.5: System wakeup disabled by ACPI
[    0.336317] pci 0000:00:16.0: [1022:7807] type 00 class 0x0c0310
[    0.336330] pci 0000:00:16.0: reg 0x10: [mem 0xfef49000-0xfef49fff]
[    0.336447] pci 0000:00:16.0: System wakeup disabled by ACPI
[    0.336533] pci 0000:00:16.2: [1022:7808] type 00 class 0x0c0320
[    0.336551] pci 0000:00:16.2: reg 0x10: [mem 0xfef48000-0xfef480ff]
[    0.336627] pci 0000:00:16.2: supports D1 D2
[    0.336630] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.336706] pci 0000:00:16.2: System wakeup disabled by ACPI
[    0.336792] pci 0000:00:18.0: [1022:1400] type 00 class 0x060000
[    0.336905] pci 0000:00:18.1: [1022:1401] type 00 class 0x060000
[    0.337017] pci 0000:00:18.2: [1022:1402] type 00 class 0x060000
[    0.337132] pci 0000:00:18.3: [1022:1403] type 00 class 0x060000
[    0.337248] pci 0000:00:18.4: [1022:1404] type 00 class 0x060000
[    0.337360] pci 0000:00:18.5: [1022:1405] type 00 class 0x060000
[    0.337540] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    0.337556] pci 0000:01:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.337579] pci 0000:01:00.0: reg 0x18: [mem 0xd0004000-0xd0004fff 64bit pref]
[    0.337593] pci 0000:01:00.0: reg 0x20: [mem 0xd0000000-0xd0003fff 64bit pref]
[    0.337660] pci 0000:01:00.0: supports D1 D2
[    0.337662] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.337692] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.343357] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.343398] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
[    0.343404] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.343502] pci 0000:00:14.4: PCI bridge to [bus 02] (subtractive decode)
[    0.343544] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.343546] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.343549] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.343552] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.343554] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.343556] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.343558] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    0.343571] pci_bus 0000:00: on NUMA node 0
[    0.344080] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 11 14 15) *0
[    0.344495] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 10 11 14 15) *0
[    0.344945] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 11 14 15) *0
[    0.345368] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 10 11 14 15) *0
[    0.345768] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *0
[    0.346149] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *0
[    0.346528] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *0
[    0.346909] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *0
[    0.347403] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.347448] vgaarb: loaded
[    0.347481] vgaarb: bridge control possible 0000:00:01.0
[    0.347589] SCSI subsystem initialized
[    0.347666] libata version 3.00 loaded.
[    0.347671] ACPI: bus type USB registered
[    0.347730] usbcore: registered new interface driver usbfs
[    0.347776] usbcore: registered new interface driver hub
[    0.347836] usbcore: registered new device driver usb
[    0.347933] Advanced Linux Sound Architecture Driver Initialized.
[    0.347980] PCI: Using ACPI for IRQ routing
[    0.355147] PCI: pci_cache_line_size set to 64 bytes
[    0.355196] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
[    0.355198] e820: reserve RAM buffer [mem 0x9e2b9000-0x9fffffff]
[    0.355200] e820: reserve RAM buffer [mem 0x9edd7000-0x9fffffff]
[    0.355201] e820: reserve RAM buffer [mem 0x9f44c000-0x9fffffff]
[    0.355203] e820: reserve RAM buffer [mem 0x9f800000-0x9fffffff]
[    0.355204] e820: reserve RAM buffer [mem 0x13f000000-0x13fffffff]
[    0.355418] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.355562] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.357634] Switched to clocksource hpet
[    0.362060] pnp: PnP ACPI init
[    0.362117] ACPI: bus type PNP registered
[    0.362311] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.362350] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.362865] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.362901] system 00:01: [io  0x040b] has been reserved
[    0.362937] system 00:01: [io  0x04d6] has been reserved
[    0.362973] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.363006] system 00:01: [io  0x0c14] has been reserved
[    0.363040] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    0.363072] system 00:01: [io  0x0c52] has been reserved
[    0.363105] system 00:01: [io  0x0c6c] has been reserved
[    0.363137] system 00:01: [io  0x0c6f] has been reserved
[    0.363170] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.363204] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.363237] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    0.363270] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    0.363303] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    0.363336] system 00:01: [io  0x0800-0x089f] could not be reserved
[    0.363370] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    0.363403] system 00:01: [io  0x0900-0x090f] has been reserved
[    0.363436] system 00:01: [io  0x0910-0x091f] has been reserved
[    0.363469] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    0.363502] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.363536] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.363569] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.363603] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.363637] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.363670] system 00:01: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.363704] system 00:01: [mem 0xff000000-0xffffffff] has been reserved
[    0.363738] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.364005] system 00:02: [io  0x0220-0x0227] has been reserved
[    0.364039] system 00:02: [io  0x0228-0x0237] has been reserved
[    0.364075] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    0.364111] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.364192] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.364290] pnp 00:04: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.364713] pnp 00:05: [dma 0 disabled]
[    0.364772] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.364794] pnp 00:06: [dma 4]
[    0.364823] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.364874] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.364917] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.365009] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.365046] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.365089] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.365155] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.365372] system 00:0c: [mem 0xa0000000-0xbfffffff] has been reserved
[    0.365409] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.365548] system 00:0d: [mem 0xfeb80000-0xfebfffff] has been reserved
[    0.365584] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.365847] pnp 00:0e: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.365853] pnp: PnP ACPI: found 15 devices
[    0.365886] ACPI: bus type PNP unregistered
[    0.373322] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.373360] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
[    0.373395] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.373433] pci 0000:00:14.4: PCI bridge to [bus 02]
[    0.373474] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.373476] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.373478] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.373480] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.373482] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.373483] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.373485] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xffffffff]
[    0.373487] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.373489] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.373491] pci_bus 0000:02: resource 4 [io  0x0000-0x03af]
[    0.373493] pci_bus 0000:02: resource 5 [io  0x03e0-0x0cf7]
[    0.373494] pci_bus 0000:02: resource 6 [io  0x03b0-0x03df]
[    0.373496] pci_bus 0000:02: resource 7 [io  0x0d00-0xffff]
[    0.373498] pci_bus 0000:02: resource 8 [mem 0x000a0000-0x000bffff]
[    0.373499] pci_bus 0000:02: resource 9 [mem 0x000c0000-0x000dffff]
[    0.373501] pci_bus 0000:02: resource 10 [mem 0xc0000000-0xffffffff]
[    0.373528] NET: Registered protocol family 2
[    0.373661] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.373762] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.373894] TCP: Hash tables configured (established 32768 bind 32768)
[    0.373958] TCP: reno registered
[    0.373992] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.374038] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.374128] NET: Registered protocol family 1
[    0.374267] RPC: Registered named UNIX socket transport module.
[    0.374301] RPC: Registered udp transport module.
[    0.374333] RPC: Registered tcp transport module.
[    0.374365] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.374406] pci 0000:00:01.0: Boot video device
[    0.698468] PCI: CLS 64 bytes, default 64
[    0.698527] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.698563] software IO TLB [mem 0x9a2b9000-0x9e2b9000] (64MB) mapped at [ffff88009a2b9000-ffff88009e2b8fff]
[    0.698719] perf: AMD NB counters detected
[    0.698792] microcode: CPU0: patch_level=0x06001116
[    0.698832] microcode: CPU1: patch_level=0x06001116
[    0.698917] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.698956] LVT offset 0 assigned for vector 0x400
[    0.698999] perf: AMD IBS detected (0x000000ff)
[    0.699212] Scanning for low memory corruption every 60 seconds
[    0.699567] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.723001] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.726621] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.726683] fuse init (API version 7.23)
[    0.726850] msgmni has been set to 6674
[    0.727095] io scheduler noop registered
[    0.727127] io scheduler deadline registered
[    0.727201] io scheduler cfq registered (default)
[    0.727503] pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
[    0.727608] pcieport 0000:00:04.0: Signaling PME through PCIe PME interrupt
[    0.727643] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.727677] pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme loaded
[    0.727816] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.727857] ACPI: Power Button [PWRB]
[    0.727938] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.727975] ACPI: Power Button [PWRF]
[    0.728100] ACPI: acpi_idle registered with cpuidle
[    0.743936] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.764341] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.764954] Linux agpgart interface v0.103
[    0.765011] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    0.765049] Hangcheck: Using getrawmonotonic().
[    0.765100] [drm] Initialized drm 1.1.0 20060810
[    0.765153] [drm] radeon kernel modesetting enabled.
[    0.765510] [drm] initializing kernel modesetting (ARUBA 0x1002:0x9993 0x1002:0x9993).
[    0.765573] [drm] register mmio base: 0xFEF00000
[    0.765605] [drm] register mmio size: 262144
[    0.765692] ATOM BIOS: 113
[    0.765808] radeon 0000:00:01.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
[    0.765845] radeon 0000:00:01.0: GTT: 1024M 0x0000000020000000 - 0x000000005FFFFFFF
[    0.767089] [drm] Detected VRAM RAM=512M, BAR=256M
[    0.767121] [drm] RAM width 64bits DDR
[    0.767196] [TTM] Zone  kernel: Available graphics memory: 1708750 kiB
[    0.767229] [TTM] Initializing pool allocator
[    0.767265] [TTM] Initializing DMA pool allocator
[    0.767313] [drm] radeon: 512M of VRAM memory ready
[    0.767345] [drm] radeon: 1024M of GTT memory ready.
[    0.767391] [drm] Loading ARUBA Microcode
[    0.767426] [drm] Internal thermal controller without fan control
[    0.767627] [drm] radeon: dpm initialized
[    0.767831] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    0.782912] [drm] PCIE GART of 1024M enabled (table at 0x0000000000276000).
[    0.783076] radeon 0000:00:01.0: WB enabled
[    0.783112] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff880099542c00
[    0.783881] radeon 0000:00:01.0: fence driver on ring 5 use gpu addr 0x0000000000075a18 and cpu addr 0xffffc90010235a18
[    0.783922] radeon 0000:00:01.0: fence driver on ring 1 use gpu addr 0x0000000020000c04 and cpu addr 0xffff880099542c04
[    0.783963] radeon 0000:00:01.0: fence driver on ring 2 use gpu addr 0x0000000020000c08 and cpu addr 0xffff880099542c08
[    0.784004] radeon 0000:00:01.0: fence driver on ring 3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff880099542c0c
[    0.784044] radeon 0000:00:01.0: fence driver on ring 4 use gpu addr 0x0000000020000c10 and cpu addr 0xffff880099542c10
[    0.784085] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.784119] [drm] Driver supports precise vblank timestamp query.
[    0.784169] radeon 0000:00:01.0: irq 41 for MSI/MSI-X
[    0.784180] radeon 0000:00:01.0: radeon: using MSI.
[    0.784482] [drm] radeon: irq initialized.
[    0.803623] [drm] ring test on 0 succeeded in 2 usecs
[    0.803718] [drm] ring test on 3 succeeded in 2 usecs
[    0.803757] [drm] ring test on 4 succeeded in 1 usecs
[    0.859451] [drm] ring test on 5 succeeded in 1 usecs
[    0.879358] [drm] UVD initialized successfully.
[    0.880262] [drm] ib test on ring 0 succeeded in 0 usecs
[    0.880827] [drm] ib test on ring 3 succeeded in 0 usecs
[    0.881391] [drm] ib test on ring 4 succeeded in 1 usecs
[    0.902391] [drm] ib test on ring 5 succeeded
[    0.922706] [drm] Radeon Display Connectors
[    0.922741] [drm] Connector 0:
[    0.922775] [drm]   HDMI-A-1
[    0.922808] [drm]   HPD1
[    0.922842] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x653c 0x653c
[    0.922877] [drm]   Encoders:
[    0.922908] [drm]     DFP1: INTERNAL_UNIPHY2
[    0.922939] [drm] Connector 1:
[    0.922970] [drm]   VGA-1
[    0.923001] [drm]   HPD2
[    0.923033] [drm]   DDC: 0x6540 0x6540 0x6544 0x6544 0x6548 0x6548 0x654c 0x654c
[    0.923076] [drm]   Encoders:
[    0.923107] [drm]     CRT1: INTERNAL_UNIPHY2
[    0.923140] [drm]     CRT1: NUTMEG
[    0.923173] [drm] Connector 2:
[    0.923205] [drm]   DVI-D-1
[    0.923237] [drm]   HPD3
[    0.923269] [drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558 0x655c 0x655c
[    0.923304] [drm]   Encoders:
[    0.923337] [drm]     DFP2: INTERNAL_UNIPHY
[    0.975640] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    0.975645] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000001, active_devices 00000000
[    0.986223] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    0.987207] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:22:HDMI-A-1]
[    1.050285] [drm:radeon_atombios_connected_scratch_regs] DFP1 disconnected
[    1.050288] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:22:HDMI-A-1] disconnected
[    1.050290] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:25:VGA-1]
[    1.050585] [drm:radeon_dp_getdpcd] DPCD: 
[    1.050587] [drm:radeon_dp_getdpcd] 11 
[    1.050588] [drm:radeon_dp_getdpcd] 0a 
[    1.050589] [drm:radeon_dp_getdpcd] 84 
[    1.050590] [drm:radeon_dp_getdpcd] 01 
[    1.050591] [drm:radeon_dp_getdpcd] 00 
[    1.050592] [drm:radeon_dp_getdpcd] 0b 
[    1.050593] [drm:radeon_dp_getdpcd] 01 
[    1.050594] [drm:radeon_dp_getdpcd] 01 
[    1.050595] [drm:radeon_dp_getdpcd] 02 
[    1.050596] [drm:radeon_dp_getdpcd] 00 
[    1.050597] [drm:radeon_dp_getdpcd] 00 
[    1.050598] [drm:radeon_dp_getdpcd] 00 
[    1.050598] [drm:radeon_dp_getdpcd] 00 
[    1.050600] [drm:radeon_dp_getdpcd] 00 
[    1.050600] [drm:radeon_dp_getdpcd] 00 
[    1.050601] [drm:radeon_dp_getdpcd] 
[    1.094684] [drm:radeon_atombios_connected_scratch_regs] CRT1 connected
[    1.094690] [drm:radeon_atombios_connected_scratch_regs] CRT1 disconnected
[    1.182878] [drm:drm_edid_to_eld] ELD: no CEA Extension found
[    1.182896] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:25:VGA-1] probed modes :
[    1.182899] [drm:drm_mode_debug_printmodeline] Modeline 29:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[    1.182902] [drm:drm_mode_debug_printmodeline] Modeline 33:"1280x1024" 76 141813 1280 1376 1512 1744 1024 1025 1028 1070 0x0 0x6
[    1.182904] [drm:drm_mode_debug_printmodeline] Modeline 43:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    1.182907] [drm:drm_mode_debug_printmodeline] Modeline 32:"1280x1024" 67 123228 1280 1368 1504 1728 1024 1025 1028 1064 0x0 0x6
[    1.182909] [drm:drm_mode_debug_printmodeline] Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    1.182911] [drm:drm_mode_debug_printmodeline] Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[    1.182913] [drm:drm_mode_debug_printmodeline] Modeline 34:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    1.182916] [drm:drm_mode_debug_printmodeline] Modeline 44:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    1.182918] [drm:drm_mode_debug_printmodeline] Modeline 45:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    1.182920] [drm:drm_mode_debug_printmodeline] Modeline 35:"1024x768" 66 71639 1024 1080 1192 1360 768 769 772 798 0x0 0x6
[    1.182922] [drm:drm_mode_debug_printmodeline] Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    1.182924] [drm:drm_mode_debug_printmodeline] Modeline 47:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[    1.182926] [drm:drm_mode_debug_printmodeline] Modeline 48:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    1.182928] [drm:drm_mode_debug_printmodeline] Modeline 49:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    1.182930] [drm:drm_mode_debug_printmodeline] Modeline 36:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    1.182933] [drm:drm_mode_debug_printmodeline] Modeline 37:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    1.182935] [drm:drm_mode_debug_printmodeline] Modeline 38:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    1.182937] [drm:drm_mode_debug_printmodeline] Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[    1.182939] [drm:drm_mode_debug_printmodeline] Modeline 40:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[    1.182941] [drm:drm_mode_debug_printmodeline] Modeline 41:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    1.182943] [drm:drm_mode_debug_printmodeline] Modeline 42:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    1.182945] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:27:DVI-D-1]
[    1.183992] [drm:radeon_atombios_connected_scratch_regs] DFP2 disconnected
[    1.183994] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:27:DVI-D-1] disconnected
[    1.183996] [drm:drm_setup_crtcs] 
[    1.183998] [drm:drm_enable_connectors] connector 22 enabled? no
[    1.183999] [drm:drm_enable_connectors] connector 25 enabled? yes
[    1.184000] [drm:drm_enable_connectors] connector 27 enabled? no
[    1.184002] [drm:drm_target_preferred] looking for cmdline mode on connector 25
[    1.184004] [drm:drm_target_preferred] looking for preferred mode on connector 25
[    1.184005] [drm:drm_target_preferred] found mode 1600x1200
[    1.184006] [drm:drm_setup_crtcs] picking CRTCs for 16384x16384 config
[    1.184008] [drm:drm_setup_crtcs] desired mode 1600x1200 set on crtc 14
[    1.186147] [drm] fb mappable at 0xC047A000
[    1.186179] [drm] vram apper at 0xC0000000
[    1.186209] [drm] size 7680000
[    1.186237] [drm] fb depth is 24
[    1.186267] [drm]    pitch is 6400
[    1.186396] fbcon: radeondrmfb (fb0) is primary device
[    1.186964] [drm:drm_crtc_helper_set_config] 
[    1.186966] [drm:drm_crtc_helper_set_config] [CRTC:14] [FB:51] #connectors=1 (x y) (0 0)
[    1.186968] [drm:drm_crtc_helper_set_config] crtc has no fb, full mode set
[    1.186969] [drm:drm_crtc_helper_set_config] modes are different, full mode set
[    1.186970] [drm:drm_mode_debug_printmodeline] Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.186972] [drm:drm_mode_debug_printmodeline] Modeline 50:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[    1.186973] [drm:drm_crtc_helper_set_config] encoder changed, full mode switch
[    1.186973] [drm:drm_crtc_helper_set_config] crtc changed, full mode switch
[    1.186974] [drm:drm_crtc_helper_set_config] [CONNECTOR:25:VGA-1] to [CRTC:14]
[    1.186975] [drm:drm_crtc_helper_set_config] attempting to set mode from userspace
[    1.186977] [drm:drm_mode_debug_printmodeline] Modeline 50:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[    1.186979] [drm:radeon_encoder_set_active_device] setting active device to 00000001 from 00000001 00000001 for encoder 1
[    1.186986] [drm:drm_crtc_helper_set_mode] [CRTC:14]
[    1.186996] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    1.186999] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    1.187031] [drm:radeon_compute_pll_avivo] 1350000 - 1350000, pll dividers - fb: 13.5 ref: 1, post 1
[    1.187098] [drm:drm_crtc_helper_set_mode] [ENCODER:23:DAC-23] set [MODE:50:1600x1200]
[    1.187099] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000001, active_devices 00000001
[    1.207096] [drm:dce5_crtc_load_lut] 0
[    1.223773] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 0, devices 00000001, active_devices 00000001
[    1.312540] [drm:radeon_dp_link_train_cr] clock recovery at voltage 0 pre-emphasis 0
[    1.313317] [drm:radeon_dp_link_train_ce] channel eq at voltage 0 pre-emphasis 0
[    1.331288] [drm:drm_crtc_helper_set_config] Setting connector DPMS state to on
[    1.331291] [drm:drm_crtc_helper_set_config] 	[CONNECTOR:25:VGA-1] set DPMS on
[    1.331293] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    1.331297] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    1.331324] [drm:drm_crtc_helper_set_config] 
[    1.331325] [drm:drm_crtc_helper_set_config] [CRTC:16] [NOFB]
[    1.331326] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    1.331328] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    1.331348] [drm:drm_crtc_helper_set_config] 
[    1.331348] [drm:drm_crtc_helper_set_config] [CRTC:18] [NOFB]
[    1.331349] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    1.331351] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    1.331371] [drm:drm_crtc_helper_set_config] 
[    1.331371] [drm:drm_crtc_helper_set_config] [CRTC:20] [NOFB]
[    1.331372] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    1.331374] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    1.331411] [drm:drm_crtc_helper_set_config] 
[    1.331412] [drm:drm_crtc_helper_set_config] [CRTC:14] [FB:51] #connectors=1 (x y) (0 0)
[    1.331416] [drm:drm_crtc_helper_set_config] [CONNECTOR:25:VGA-1] to [CRTC:14]
[    1.331418] [drm:dce5_crtc_load_lut] 0
[    1.331484] [drm:dce5_crtc_load_lut] 0
[    1.335884] [drm:drm_crtc_helper_set_config] 
[    1.335885] [drm:drm_crtc_helper_set_config] [CRTC:14] [FB:51] #connectors=1 (x y) (0 0)
[    1.335887] [drm:drm_crtc_helper_set_config] [CONNECTOR:25:VGA-1] to [CRTC:14]
[    1.335889] [drm:dce5_crtc_load_lut] 0
[    1.335949] [drm:dce5_crtc_load_lut] 0
[    1.340283] Console: switching to colour frame buffer device 133x54
[    1.340286] [drm:drm_crtc_helper_set_config] 
[    1.340287] [drm:drm_crtc_helper_set_config] [CRTC:14] [FB:51] #connectors=1 (x y) (0 0)
[    1.340289] [drm:drm_crtc_helper_set_config] [CONNECTOR:25:VGA-1] to [CRTC:14]
[    1.340290] [drm:dce5_crtc_load_lut] 0
[    1.344416] [drm:dce5_crtc_load_lut] 0
[    1.344542] radeon 0000:00:01.0: fb0: radeondrmfb frame buffer device
[    1.344591] radeon 0000:00:01.0: registered panic notifier
[    1.344735] [drm] Initialized radeon 2.38.0 20080528 for 0000:00:01.0 on minor 0
[    1.345256] Uniform Multi-Platform E-IDE driver
[    1.345382] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    1.345458] ide-gd driver 1.18
[    1.345492] ide-cd driver 5.00
[    1.345579] 3ware Storage Controller device driver for Linux v1.26.02.003.
[    1.345704] SCSI Media Changer driver v0.25 
[    1.345771] ahci 0000:00:11.0: version 3.0
[    1.345996] ahci 0000:00:11.0: irq 42 for MSI/MSI-X
[    1.346047] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0x5 impl SATA mode
[    1.346112] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    1.346699] scsi0 : ahci
[    1.346919] scsi1 : ahci
[    1.347072] scsi2 : ahci
[    1.347161] ata1: SATA max UDMA/133 abar m2048@0xfef4f000 port 0xfef4f100 irq 42
[    1.347219] ata2: DUMMY
[    1.347240] ata3: SATA max UDMA/133 abar m2048@0xfef4f000 port 0xfef4f200 irq 42
[    1.347770] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.348044] r8169 0000:01:00.0: irq 43 for MSI/MSI-X
[    1.348206] r8169 0000:01:00.0 eth0: RTL8168evl/8111evl at 0xffffc90010082000, 94:de:80:0a:3b:43, XID 0c900800 IRQ 43
[    1.348288] r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    1.348457] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.348518] ehci-pci: EHCI PCI platform driver
[    1.348790] QUIRK: Enable AMD PLL fix
[    1.348814] ehci-pci 0000:00:12.2: EHCI Host Controller
[    1.348924] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.350563] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.352167] ehci-pci 0000:00:12.2: debug port 1
[    1.353796] ehci-pci 0000:00:12.2: irq 17, io mem 0xfef4d000
[    1.366733] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.368524] hub 1-0:1.0: USB hub found
[    1.370088] hub 1-0:1.0: 5 ports detected
[    1.372001] ehci-pci 0000:00:13.2: EHCI Host Controller
[    1.373640] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.375251] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.376863] ehci-pci 0000:00:13.2: debug port 1
[    1.378487] ehci-pci 0000:00:13.2: irq 17, io mem 0xfef4b000
[    1.390738] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.392606] hub 2-0:1.0: USB hub found
[    1.394258] hub 2-0:1.0: 5 ports detected
[    1.396225] ehci-pci 0000:00:16.2: EHCI Host Controller
[    1.397891] ehci-pci 0000:00:16.2: new USB bus registered, assigned bus number 3
[    1.399537] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.401204] ehci-pci 0000:00:16.2: debug port 1
[    1.402889] ehci-pci 0000:00:16.2: irq 17, io mem 0xfef48000
[    1.414774] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    1.416689] hub 3-0:1.0: USB hub found
[    1.418380] hub 3-0:1.0: 4 ports detected
[    1.420221] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.421951] ohci-pci: OHCI PCI platform driver
[    1.423885] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    1.425652] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 4
[    1.427403] ohci-pci 0000:00:12.0: irq 18, io mem 0xfef4e000
[    1.487062] hub 4-0:1.0: USB hub found
[    1.488788] hub 4-0:1.0: 5 ports detected
[    1.490825] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    1.492551] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 5
[    1.494215] ohci-pci 0000:00:13.0: irq 18, io mem 0xfef4c000
[    1.555126] hub 5-0:1.0: USB hub found
[    1.556772] hub 5-0:1.0: 5 ports detected
[    1.558725] ohci-pci 0000:00:14.5: OHCI PCI host controller
[    1.560389] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 6
[    1.562012] ohci-pci 0000:00:14.5: irq 18, io mem 0xfef4a000
[    1.623211] hub 6-0:1.0: USB hub found
[    1.624846] hub 6-0:1.0: 2 ports detected
[    1.626756] ohci-pci 0000:00:16.0: OHCI PCI host controller
[    1.628427] ohci-pci 0000:00:16.0: new USB bus registered, assigned bus number 7
[    1.630047] ohci-pci 0000:00:16.0: irq 18, io mem 0xfef49000
[    1.691247] hub 7-0:1.0: USB hub found
[    1.692829] hub 7-0:1.0: 4 ports detected
[    1.694488] uhci_hcd: USB Universal Host Controller Interface driver
[    1.696067] usbcore: registered new interface driver usblp
[    1.697611] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.699148] tsc: Refined TSC clocksource calibration: 3393.827 MHz
[    1.701079] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.702659] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.704318] mousedev: PS/2 mouse device common for all mice
[    1.706046] rtc_cmos 00:07: RTC can wake from S4
[    1.707699] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.709250] rtc_cmos 00:07: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.710843] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    1.712472] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0xb20
[    1.714150] it87: Found IT8728F chip at 0x228, revision 1
[    1.715749] it87: Beeping is supported
[    1.718128] usbcore: registered new interface driver usbhid
[    1.719719] usbhid: USB HID core driver
[    1.721763] snd_hda_intel 0000:00:01.1: Force to non-snoop mode
[    1.723398] snd_hda_intel 0000:00:01.1: irq 44 for MSI/MSI-X
[    1.723878] oprofile: AMD IBS detected (0x000000ff)
[    1.725476] oprofile: using NMI interrupt.
[    1.727068] Netfilter messages via NETLINK v0.30.
[    1.728666] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.730377] ctnetlink v0.93: registering with nfnetlink.
[    1.732093] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.733705] TCP: cubic registered
[    1.735362] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    1.737259] NET: Registered protocol family 10
[    1.739107] NET: Registered protocol family 17
[    1.741448] console [netcon0] enabled
[    1.743141] netconsole: network logging started
[    1.745028] rtc_cmos 00:07: setting system clock to 2014-05-12 16:02:52 UTC (1399910572)
[    1.747073] acpi-cpufreq: overriding BIOS provided _PSD data
[    1.749242] ALSA device list:
[    1.751148]   No soundcards found.
[    1.759987] sound hdaudioC1D0: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[    1.761700] sound hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    1.763396] sound hdaudioC1D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    1.765087] sound hdaudioC1D0:    mono: mono_out=0x0
[    1.766746] sound hdaudioC1D0:    dig-out=0x11/0x0
[    1.768396] sound hdaudioC1D0:    inputs:
[    1.770029] sound hdaudioC1D0:      Rear Mic=0x18
[    1.771660] sound hdaudioC1D0:      Front Mic=0x19
[    1.773262] sound hdaudioC1D0:      Line=0x1a
[    1.774853] sound hdaudioC1D0:      CD=0x1c
[    1.843169] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.846268] ata1.00: ATA-8: ST500DM002-1BD142, KC45, max UDMA/133
[    1.847884] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.849503] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.852639] ata1.00: configured for UDMA/133
[    1.854347] ata3.00: ATAPI: TSSTcorp CDDVDW SH-224BB, SB00, max UDMA/100
[    1.854368] scsi 0:0:0:0: Direct-Access     ATA      ST500DM002-1BD14 KC45 PQ: 0 ANSI: 5
[    1.854631] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.854633] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.854677] sd 0:0:0:0: [sda] Write Protect is off
[    1.854679] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.854697] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.854933] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.868419] ata3.00: configured for UDMA/100
[    1.871633] scsi 2:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-224BB  SB00 PQ: 0 ANSI: 5
[    1.891646] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.893349] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.895216] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.895301] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    1.997951]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 sda14 sda15 >
[    2.000578] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.135173] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[    2.657191] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input4
[    2.672557] EXT3-fs (sda10): error: couldn't mount because of unsupported optional features (240)
[    2.680886] EXT2-fs (sda10): error: couldn't mount because of unsupported optional features (240)
[    2.699849] Switched to clocksource tsc
[    2.712142] EXT4-fs (sda10): mounted filesystem with ordered data mode. Opts: (null)
[    2.713952] VFS: Mounted root (ext4 filesystem) readonly on device 8:10.
[    2.748013] devtmpfs: mounted
[    2.750713] Freeing unused kernel memory: 1160K (ffffffff81c52000 - ffffffff81d74000)
[    3.253160] random: nonblocking pool is initialized
[    3.910767] udevd[1676]: starting version 1.2
[    7.873642] Adding 4194300k swap on /dev/sda5.  Priority:-1 extents:1 across:4194300k 
[    7.907094] EXT4-fs (sda10): re-mounted. Opts: (null)
[    8.574504] EXT4-fs (sda10): re-mounted. Opts: (null)
[    8.757523] EXT4-fs (sda13): mounted filesystem with ordered data mode. Opts: (null)
[    9.077463] [drm:drm_crtc_helper_set_config] 
[    9.077467] [drm:drm_crtc_helper_set_config] [CRTC:14] [FB:51] #connectors=1 (x y) (0 0)
[    9.077476] [drm:drm_crtc_helper_set_config] [CONNECTOR:25:VGA-1] to [CRTC:14]
[    9.077483] [drm:dce5_crtc_load_lut] 0
[    9.077587] [drm:dce5_crtc_load_lut] 0
[   10.156748] r8169 0000:01:00.0 eth0: link down
[   10.156756] r8169 0000:01:00.0 eth0: link down
[   10.156791] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   11.694475] r8169 0000:01:00.0 eth0: link up
[   11.694491] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   15.548541] IPTABLES Packet Dropped: IN=eth0 OUT= MAC=94:de:80:0a:3b:43:2c:b0:5d:04:33:bb:08:00 SRC=192.168.7.254 DST=192.168.7.148 LEN=328 TOS=0x00 PREC=0x00 TTL=128 ID=57005 PROTO=UDP SPT=67 DPT=68 LEN=308 
[   15.549200] IPTABLES Packet Dropped: IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:2c:b0:5d:04:33:bb:08:00 SRC=192.168.7.254 DST=255.255.255.255 LEN=328 TOS=0x00 PREC=0x00 TTL=128 ID=57005 PROTO=UDP SPT=67 DPT=68 LEN=308 

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.bad"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc2-00086-g47f5c7461660 (ken@bluesbreaker) (gcc version 4.8.1 (GCC) ) #13 SMP PREEMPT Sun May 11 22:24:05 BST 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.15.0-rc2-00086-g47f5c7461660-sda10 root=/dev/sda10 drm.debug=0xe ro
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009e2b8fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009e2b9000-0x000000009e2ecfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009e2ed000-0x000000009e2f4fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009e2f5000-0x000000009e642fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009e643000-0x000000009edd5fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009edd6000-0x000000009edd6fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009edd7000-0x000000009efdcfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009efdd000-0x000000009f44bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000009f44c000-0x000000009f7dcfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009f7dd000-0x000000009f7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000013effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A55M-DS2, BIOS F3 09/28/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x13f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFE0000000 write-back
[    0.000000]   2 base 00009F800000 mask FFFFFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000013f000000 aka 5104M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0x9f800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x9f800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd750-0x000fd75f] mapped at [ffff8800000fd750]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01e61000, 0x01e61fff] PGTABLE
[    0.000000] BRK [0x01e62000, 0x01e62fff] PGTABLE
[    0.000000] BRK [0x01e63000, 0x01e63fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13ee00000-0x13effffff]
[    0.000000]  [mem 0x13ee00000-0x13effffff] page 2M
[    0.000000] BRK [0x01e64000, 0x01e64fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13c000000-0x13edfffff]
[    0.000000]  [mem 0x13c000000-0x13edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100001000-0x13bffffff]
[    0.000000]  [mem 0x100001000-0x1001fffff] page 4k
[    0.000000]  [mem 0x100200000-0x13bffffff] page 2M
[    0.000000] BRK [0x01e65000, 0x01e65fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x9e2b8fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0x9e1fffff] page 2M
[    0.000000]  [mem 0x9e200000-0x9e2b8fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9edd6000-0x9edd6fff]
[    0.000000]  [mem 0x9edd6000-0x9edd6fff] page 4k
[    0.000000] BRK [0x01e66000, 0x01e66fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x9efdd000-0x9f44bfff]
[    0.000000]  [mem 0x9efdd000-0x9effffff] page 4k
[    0.000000]  [mem 0x9f000000-0x9f3fffff] page 2M
[    0.000000]  [mem 0x9f400000-0x9f44bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9f7dd000-0x9f7fffff]
[    0.000000]  [mem 0x9f7dd000-0x9f7fffff] page 4k
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x000000009E2EE088 00008C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x000000009E2F3850 0000F4 (v04 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20140214/tbfadt-634)
[    0.000000] ACPI: DSDT 0x000000009E2EE1A0 0056AC (v02 ALASKA A M I    00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0x000000009E63BD80 000040
[    0.000000] ACPI: APIC 0x000000009E2F3948 000072 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x000000009E2F39C0 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x000000009E2F3A08 00003C (v01 ALASKA A M I    01072009 MSFT 00010013)
[    0.000000] ACPI: MSDM 0x000000009E2F3A48 000055 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: HPET 0x000000009E2F3AA0 000038 (v01 ALASKA A M I    01072009 AMI  00000005)
[    0.000000] ACPI: MSDM 0x000000009E2F3AD8 000055 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: IFEU 0x000000009E2F3B30 000042 (v01 ALASKA A M I    01072009      00000000)
[    0.000000] ACPI: SSDT 0x000000009E2F3B78 0006B2 (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 0x000000009E2F4230 0004B7 (v02 AMD    ALIB     00000001 MSFT 04000000)
[    0.000000] ACPI: IVRS 0x000000009E2F46E8 000070 (v02 AMD    AMDIOMMU 00000001 AMD  00000000)
[    0.000000] ACPI: CRAT 0x000000009E2F4758 0001F8 (v01 AMD    AGESA    00000001 AMD  00000001)
[    0.000000] ACPI: BGRT 0x000000009E2F4950 000038 (v00 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013ae00000-ffff88013e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x9e2b8fff]
[    0.000000]   node   0: [mem 0x9edd6000-0x9edd6fff]
[    0.000000]   node   0: [mem 0x9efdd000-0x9f44bfff]
[    0.000000]   node   0: [mem 0x9f7dd000-0x9f7fffff]
[    0.000000]   node   0: [mem 0x100001000-0x13effffff]
[    0.000000] On node 0 totalpages: 906984
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10078 pages used for memmap
[    0.000000]   DMA32 zone: 644940 pages, LIFO batch:31
[    0.000000]   Normal zone: 4032 pages used for memmap
[    0.000000]   Normal zone: 258047 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x15] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 3, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10228210 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9e2b9000-0x9e2ecfff]
[    0.000000] PM: Registered nosave memory: [mem 0x9e2ed000-0x9e2f4fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9e2f5000-0x9e642fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9e643000-0x9edd5fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9edd7000-0x9efdcfff]
[    0.000000] PM: Registered nosave memory: [mem 0x9f44c000-0x9f7dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0x9f800000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed80000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x100000000-0x100000fff]
[    0.000000] e820: [mem 0x9f800000-0xfebfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013ec00000 s80768 r8192 d21632 u524288
[    0.000000] pcpu-alloc: s80768 r8192 d21632 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 892789
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.15.0-rc2-00086-g47f5c7461660-sda10 root=/dev/sda10 drm.debug=0xe ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 0 size 32 MB
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 94000000
[    0.000000] PM: Registered nosave memory: [mem 0x94000000-0x97ffffff]
[    0.000000] Memory: 3417492K/3627936K available (8159K kernel code, 755K rwdata, 3672K rodata, 1156K init, 932K bss, 210444K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NO_HZ: Full dynticks CPUs: 1-7.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3393.806 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6787.61 BogoMIPS (lpj=13575224)
[    0.000068] pid_max: default: 32768 minimum: 301
[    0.000103] ACPI: Core revision 20140214
[    0.005054] ACPI: All ACPI Tables successfully acquired
[    0.005313] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.005346] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.005543] Initializing cgroup subsys debug
[    0.005588] tseg: 009f800000
[    0.005590] CPU: Physical Processor ID: 0
[    0.005621] CPU: Processor Core ID: 0
[    0.005653] mce: CPU supports 7 MCE banks
[    0.005693] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
tlb_flushall_shift: 6
[    0.005816] Freeing SMP alternatives memory: 24K (ffffffff81d70000 - ffffffff81d76000)
[    0.005852] ftrace: allocating 29291 entries in 115 pages
[    0.015977] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.055734] smpboot: CPU0: AMD A4-5300 APU with Radeon(tm) HD Graphics (fam: 15, model: 10, stepping: 01)
[    0.163125] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    0.163242] ... version:                0
[    0.163274] ... bit width:              48
[    0.163305] ... generic registers:      6
[    0.163336] ... value mask:             0000ffffffffffff
[    0.163368] ... max period:             00007fffffffffff
[    0.163400] ... fixed-purpose events:   0
[    0.163431] ... event mask:             000000000000003f
[    0.195302] x86: Booting SMP configuration:
[    0.195339] .... node  #0, CPUs:      #1
[    0.208508] x86: Booted up 1 node, 2 CPUs
[    0.208572] smpboot: Total of 2 processors activated (13575.22 BogoMIPS)
[    0.208964] devtmpfs: initialized
[    0.209208] PM: Registering ACPI NVS region [mem 0x9e2f5000-0x9e642fff] (3465216 bytes)
[    0.209300] PM: Registering ACPI NVS region [mem 0x9edd7000-0x9efdcfff] (2121728 bytes)
[    0.209611] NET: Registered protocol family 16
[    0.209789] cpuidle: using governor ladder
[    0.210951] cpuidle: using governor menu
[    0.211022] ACPI: bus type PCI registered
[    0.211115] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.211154] PCI: not using MMCONFIG
[    0.211187] PCI: Using configuration type 1 for base access
[    0.211220] PCI: Using configuration type 1 for extended access
[    0.215666] ACPI: Added _OSI(Module Device)
[    0.215704] ACPI: Added _OSI(Processor Device)
[    0.215738] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.215772] ACPI: Added _OSI(Processor Aggregator Device)
[    0.219612] ACPI: Executed 1 blocks of module-level executable AML code
[    0.224813] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.225468] ACPI: Interpreter enabled
[    0.225505] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.225600] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.225709] ACPI: (supports S0 S3 S4 S5)
[    0.225741] ACPI: Using IOAPIC for interrupt routing
[    0.226012] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.226114] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.243304] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.331627] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.331667] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.332189] acpi PNP0A03:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.332748] PCI host bridge to bus 0000:00
[    0.332784] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.332819] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.332854] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.332887] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.332920] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.332954] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.332987] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.333020] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
[    0.333059] pci 0000:00:00.0: [1022:1410] type 00 class 0x060000
[    0.333188] pci 0000:00:00.2: [1022:1419] type 00 class 0x080600
[    0.333339] pci 0000:00:01.0: [1002:9993] type 00 class 0x030000
[    0.333349] pci 0000:00:01.0: reg 0x10: [mem 0xc0000000-0xcfffffff pref]
[    0.333355] pci 0000:00:01.0: reg 0x14: [io  0xf000-0xf0ff]
[    0.333361] pci 0000:00:01.0: reg 0x18: [mem 0xfef00000-0xfef3ffff]
[    0.333398] pci 0000:00:01.0: supports D1 D2
[    0.333500] pci 0000:00:01.1: [1002:9902] type 00 class 0x040300
[    0.333508] pci 0000:00:01.1: reg 0x10: [mem 0xfef44000-0xfef47fff]
[    0.333553] pci 0000:00:01.1: supports D1 D2
[    0.333660] pci 0000:00:04.0: [1022:1414] type 01 class 0x060400
[    0.333706] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.333780] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.333880] pci 0000:00:11.0: [1022:7801] type 00 class 0x010601
[    0.333898] pci 0000:00:11.0: reg 0x10: [io  0xf190-0xf197]
[    0.333908] pci 0000:00:11.0: reg 0x14: [io  0xf180-0xf183]
[    0.333916] pci 0000:00:11.0: reg 0x18: [io  0xf170-0xf177]
[    0.333925] pci 0000:00:11.0: reg 0x1c: [io  0xf160-0xf163]
[    0.333933] pci 0000:00:11.0: reg 0x20: [io  0xf150-0xf15f]
[    0.333941] pci 0000:00:11.0: reg 0x24: [mem 0xfef4f000-0xfef4f7ff]
[    0.334086] pci 0000:00:12.0: [1022:7807] type 00 class 0x0c0310
[    0.334099] pci 0000:00:12.0: reg 0x10: [mem 0xfef4e000-0xfef4efff]
[    0.334217] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.334302] pci 0000:00:12.2: [1022:7808] type 00 class 0x0c0320
[    0.334320] pci 0000:00:12.2: reg 0x10: [mem 0xfef4d000-0xfef4d0ff]
[    0.334393] pci 0000:00:12.2: supports D1 D2
[    0.334395] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.334474] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.334558] pci 0000:00:13.0: [1022:7807] type 00 class 0x0c0310
[    0.334571] pci 0000:00:13.0: reg 0x10: [mem 0xfef4c000-0xfef4cfff]
[    0.334688] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.334776] pci 0000:00:13.2: [1022:7808] type 00 class 0x0c0320
[    0.334794] pci 0000:00:13.2: reg 0x10: [mem 0xfef4b000-0xfef4b0ff]
[    0.334867] pci 0000:00:13.2: supports D1 D2
[    0.334868] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.334943] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.335027] pci 0000:00:14.0: [1022:780b] type 00 class 0x0c0500
[    0.335181] pci 0000:00:14.1: [1022:780c] type 00 class 0x01018a
[    0.335195] pci 0000:00:14.1: reg 0x10: [io  0xf140-0xf147]
[    0.335204] pci 0000:00:14.1: reg 0x14: [io  0xf130-0xf133]
[    0.335213] pci 0000:00:14.1: reg 0x18: [io  0xf120-0xf127]
[    0.335223] pci 0000:00:14.1: reg 0x1c: [io  0xf110-0xf113]
[    0.335231] pci 0000:00:14.1: reg 0x20: [io  0xf100-0xf10f]
[    0.335249] pci 0000:00:14.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.335287] pci 0000:00:14.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.335320] pci 0000:00:14.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.335354] pci 0000:00:14.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.335495] pci 0000:00:14.2: [1022:780d] type 00 class 0x040300
[    0.335515] pci 0000:00:14.2: reg 0x10: [mem 0xfef40000-0xfef43fff 64bit]
[    0.335574] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.335647] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.335725] pci 0000:00:14.3: [1022:780e] type 00 class 0x060100
[    0.335885] pci 0000:00:14.4: [1022:780f] type 01 class 0x060401
[    0.335986] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.336064] pci 0000:00:14.5: [1022:7809] type 00 class 0x0c0310
[    0.336077] pci 0000:00:14.5: reg 0x10: [mem 0xfef4a000-0xfef4afff]
[    0.336195] pci 0000:00:14.5: System wakeup disabled by ACPI
[    0.336276] pci 0000:00:16.0: [1022:7807] type 00 class 0x0c0310
[    0.336289] pci 0000:00:16.0: reg 0x10: [mem 0xfef49000-0xfef49fff]
[    0.336406] pci 0000:00:16.0: System wakeup disabled by ACPI
[    0.336490] pci 0000:00:16.2: [1022:7808] type 00 class 0x0c0320
[    0.336508] pci 0000:00:16.2: reg 0x10: [mem 0xfef48000-0xfef480ff]
[    0.336580] pci 0000:00:16.2: supports D1 D2
[    0.336583] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.336663] pci 0000:00:16.2: System wakeup disabled by ACPI
[    0.336747] pci 0000:00:18.0: [1022:1400] type 00 class 0x060000
[    0.336859] pci 0000:00:18.1: [1022:1401] type 00 class 0x060000
[    0.336970] pci 0000:00:18.2: [1022:1402] type 00 class 0x060000
[    0.337084] pci 0000:00:18.3: [1022:1403] type 00 class 0x060000
[    0.337200] pci 0000:00:18.4: [1022:1404] type 00 class 0x060000
[    0.337311] pci 0000:00:18.5: [1022:1405] type 00 class 0x060000
[    0.337490] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    0.337504] pci 0000:01:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.337527] pci 0000:01:00.0: reg 0x18: [mem 0xd0004000-0xd0004fff 64bit pref]
[    0.337542] pci 0000:01:00.0: reg 0x20: [mem 0xd0000000-0xd0003fff 64bit pref]
[    0.337610] pci 0000:01:00.0: supports D1 D2
[    0.337611] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.337641] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.343358] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.343398] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
[    0.343404] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.343502] pci 0000:00:14.4: PCI bridge to [bus 02] (subtractive decode)
[    0.343543] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.343546] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.343549] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.343551] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.343553] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.343555] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.343557] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    0.343570] pci_bus 0000:00: on NUMA node 0
[    0.344084] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 11 14 15) *0
[    0.344500] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 10 11 14 15) *0
[    0.344942] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 11 14 15) *0
[    0.345363] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 10 11 14 15) *0
[    0.345762] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *0
[    0.346142] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *0
[    0.346522] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *0
[    0.346901] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *0
[    0.347405] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.347449] vgaarb: loaded
[    0.347480] vgaarb: bridge control possible 0000:00:01.0
[    0.347585] SCSI subsystem initialized
[    0.347658] libata version 3.00 loaded.
[    0.347664] ACPI: bus type USB registered
[    0.347733] usbcore: registered new interface driver usbfs
[    0.347785] usbcore: registered new interface driver hub
[    0.347843] usbcore: registered new device driver usb
[    0.347937] Advanced Linux Sound Architecture Driver Initialized.
[    0.347985] PCI: Using ACPI for IRQ routing
[    0.355133] PCI: pci_cache_line_size set to 64 bytes
[    0.355182] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
[    0.355184] e820: reserve RAM buffer [mem 0x9e2b9000-0x9fffffff]
[    0.355186] e820: reserve RAM buffer [mem 0x9edd7000-0x9fffffff]
[    0.355188] e820: reserve RAM buffer [mem 0x9f44c000-0x9fffffff]
[    0.355189] e820: reserve RAM buffer [mem 0x9f800000-0x9fffffff]
[    0.355191] e820: reserve RAM buffer [mem 0x13f000000-0x13fffffff]
[    0.355405] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.355549] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.357621] Switched to clocksource hpet
[    0.362030] pnp: PnP ACPI init
[    0.362088] ACPI: bus type PNP registered
[    0.362281] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.362319] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.362829] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.362864] system 00:01: [io  0x040b] has been reserved
[    0.362899] system 00:01: [io  0x04d6] has been reserved
[    0.362933] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.362967] system 00:01: [io  0x0c14] has been reserved
[    0.363000] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    0.363033] system 00:01: [io  0x0c52] has been reserved
[    0.363066] system 00:01: [io  0x0c6c] has been reserved
[    0.363099] system 00:01: [io  0x0c6f] has been reserved
[    0.363132] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.363165] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.363198] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    0.363231] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    0.363264] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    0.363297] system 00:01: [io  0x0800-0x089f] could not be reserved
[    0.363331] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    0.363364] system 00:01: [io  0x0900-0x090f] has been reserved
[    0.363397] system 00:01: [io  0x0910-0x091f] has been reserved
[    0.363430] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    0.363463] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.363498] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.363531] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.363565] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.363599] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.363632] system 00:01: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.363666] system 00:01: [mem 0xff000000-0xffffffff] has been reserved
[    0.363700] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.363963] system 00:02: [io  0x0220-0x0227] has been reserved
[    0.363999] system 00:02: [io  0x0228-0x0237] has been reserved
[    0.364034] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    0.364070] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.364151] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.364248] pnp 00:04: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.364663] pnp 00:05: [dma 0 disabled]
[    0.364724] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.364745] pnp 00:06: [dma 4]
[    0.364775] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.364825] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.364866] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.364955] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.364993] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.365035] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.365097] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.365311] system 00:0c: [mem 0xa0000000-0xbfffffff] has been reserved
[    0.365348] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.365483] system 00:0d: [mem 0xfeb80000-0xfebfffff] has been reserved
[    0.365520] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.365782] pnp 00:0e: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.365789] pnp: PnP ACPI: found 15 devices
[    0.365823] ACPI: bus type PNP unregistered
[    0.372765] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.372803] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
[    0.372839] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.372877] pci 0000:00:14.4: PCI bridge to [bus 02]
[    0.372919] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.372921] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.372923] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.372924] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.372926] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.372928] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.372930] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xffffffff]
[    0.372932] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.372934] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.372936] pci_bus 0000:02: resource 4 [io  0x0000-0x03af]
[    0.372938] pci_bus 0000:02: resource 5 [io  0x03e0-0x0cf7]
[    0.372939] pci_bus 0000:02: resource 6 [io  0x03b0-0x03df]
[    0.372941] pci_bus 0000:02: resource 7 [io  0x0d00-0xffff]
[    0.372943] pci_bus 0000:02: resource 8 [mem 0x000a0000-0x000bffff]
[    0.372944] pci_bus 0000:02: resource 9 [mem 0x000c0000-0x000dffff]
[    0.372946] pci_bus 0000:02: resource 10 [mem 0xc0000000-0xffffffff]
[    0.372972] NET: Registered protocol family 2
[    0.373099] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.373198] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.373331] TCP: Hash tables configured (established 32768 bind 32768)
[    0.373396] TCP: reno registered
[    0.373429] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.373477] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.373567] NET: Registered protocol family 1
[    0.373726] RPC: Registered named UNIX socket transport module.
[    0.373759] RPC: Registered udp transport module.
[    0.373791] RPC: Registered tcp transport module.
[    0.373822] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.373864] pci 0000:00:01.0: Boot video device
[    0.698454] PCI: CLS 64 bytes, default 64
[    0.698513] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.698550] software IO TLB [mem 0x9a2b9000-0x9e2b9000] (64MB) mapped at [ffff88009a2b9000-ffff88009e2b8fff]
[    0.698703] perf: AMD NB counters detected
[    0.698774] microcode: CPU0: patch_level=0x06001116
[    0.698814] microcode: CPU1: patch_level=0x06001116
[    0.698899] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.698938] LVT offset 0 assigned for vector 0x400
[    0.698980] perf: AMD IBS detected (0x000000ff)
[    0.699201] Scanning for low memory corruption every 60 seconds
[    0.699524] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.723188] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.726866] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.726928] fuse init (API version 7.23)
[    0.727089] msgmni has been set to 6674
[    0.727339] io scheduler noop registered
[    0.727371] io scheduler deadline registered
[    0.727446] io scheduler cfq registered (default)
[    0.727743] pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
[    0.727842] pcieport 0000:00:04.0: Signaling PME through PCIe PME interrupt
[    0.727877] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.727910] pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme loaded
[    0.728056] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.728096] ACPI: Power Button [PWRB]
[    0.728178] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.728218] ACPI: Power Button [PWRF]
[    0.728333] ACPI: acpi_idle registered with cpuidle
[    0.747600] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.768013] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.768621] Linux agpgart interface v0.103
[    0.768678] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    0.768717] Hangcheck: Using getrawmonotonic().
[    0.768767] [drm] Initialized drm 1.1.0 20060810
[    0.768823] [drm] radeon kernel modesetting enabled.
[    0.769172] [drm] initializing kernel modesetting (ARUBA 0x1002:0x9993 0x1002:0x9993).
[    0.769236] [drm] register mmio base: 0xFEF00000
[    0.769267] [drm] register mmio size: 262144
[    0.769348] ATOM BIOS: 113
[    0.769464] radeon 0000:00:01.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
[    0.769501] radeon 0000:00:01.0: GTT: 1024M 0x0000000020000000 - 0x000000005FFFFFFF
[    0.769538] [drm] Detected VRAM RAM=512M, BAR=256M
[    0.770774] [drm] RAM width 64bits DDR
[    0.770860] [TTM] Zone  kernel: Available graphics memory: 1708758 kiB
[    0.770892] [TTM] Initializing pool allocator
[    0.770929] [TTM] Initializing DMA pool allocator
[    0.770977] [drm] radeon: 512M of VRAM memory ready
[    0.771010] [drm] radeon: 1024M of GTT memory ready.
[    0.771057] [drm] Loading ARUBA Microcode
[    0.771090] [drm] Internal thermal controller without fan control
[    0.771386] [drm] radeon: dpm initialized
[    0.771589] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    0.790890] [drm] PCIE GART of 1024M enabled (table at 0x0000000000276000).
[    0.791041] radeon 0000:00:01.0: WB enabled
[    0.791077] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff8800994fdc00
[    0.791843] radeon 0000:00:01.0: fence driver on ring 5 use gpu addr 0x0000000000075a18 and cpu addr 0xffffc90010235a18
[    0.791882] radeon 0000:00:01.0: fence driver on ring 1 use gpu addr 0x0000000020000c04 and cpu addr 0xffff8800994fdc04
[    0.791920] radeon 0000:00:01.0: fence driver on ring 2 use gpu addr 0x0000000020000c08 and cpu addr 0xffff8800994fdc08
[    0.791958] radeon 0000:00:01.0: fence driver on ring 3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff8800994fdc0c
[    0.791996] radeon 0000:00:01.0: fence driver on ring 4 use gpu addr 0x0000000020000c10 and cpu addr 0xffff8800994fdc10
[    0.792034] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.792067] [drm] Driver supports precise vblank timestamp query.
[    0.792114] radeon 0000:00:01.0: irq 41 for MSI/MSI-X
[    0.792124] radeon 0000:00:01.0: radeon: using MSI.
[    0.792426] [drm] radeon: irq initialized.
[    0.811577] [drm] ring test on 0 succeeded in 2 usecs
[    0.811671] [drm] ring test on 3 succeeded in 2 usecs
[    0.811709] [drm] ring test on 4 succeeded in 1 usecs
[    0.867403] [drm] ring test on 5 succeeded in 1 usecs
[    0.887307] [drm] UVD initialized successfully.
[    0.888220] [drm] ib test on ring 0 succeeded in 0 usecs
[    0.888786] [drm] ib test on ring 3 succeeded in 0 usecs
[    0.889351] [drm] ib test on ring 4 succeeded in 1 usecs
[    0.910347] [drm] ib test on ring 5 succeeded
[    0.930662] [drm] Radeon Display Connectors
[    0.930715] [drm] Connector 0:
[    0.930748] [drm]   HDMI-A-1
[    0.930793] [drm]   HPD1
[    0.930828] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x653c 0x653c
[    0.930878] [drm]   Encoders:
[    0.930912] [drm]     DFP1: INTERNAL_UNIPHY2
[    0.930957] [drm] Connector 1:
[    0.930992] [drm]   VGA-1
[    0.931037] [drm]   HPD2
[    0.931072] [drm]   DDC: 0x6540 0x6540 0x6544 0x6544 0x6548 0x6548 0x654c 0x654c
[    0.931121] [drm]   Encoders:
[    0.931155] [drm]     CRT1: INTERNAL_UNIPHY2
[    0.931200] [drm]     CRT1: NUTMEG
[    0.931234] [drm] Connector 2:
[    0.931280] [drm]   DVI-D-1
[    0.931313] [drm]   HPD3
[    0.931359] [drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558 0x655c 0x655c
[    0.931407] [drm]   Encoders:
[    0.931441] [drm]     DFP2: INTERNAL_UNIPHY
[    0.983639] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    0.983645] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000001, active_devices 00000000
[    0.994246] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    0.995217] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:22:HDMI-A-1]
[    1.058277] [drm:radeon_atombios_connected_scratch_regs] DFP1 disconnected
[    1.058280] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:22:HDMI-A-1] disconnected
[    1.058282] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:25:VGA-1]
[    1.058579] [drm:radeon_dp_getdpcd] DPCD: 
[    1.058580] [drm:radeon_dp_getdpcd] 11 
[    1.058581] [drm:radeon_dp_getdpcd] 0a 
[    1.058582] [drm:radeon_dp_getdpcd] 84 
[    1.058583] [drm:radeon_dp_getdpcd] 01 
[    1.058584] [drm:radeon_dp_getdpcd] 00 
[    1.058585] [drm:radeon_dp_getdpcd] 0b 
[    1.058586] [drm:radeon_dp_getdpcd] 01 
[    1.058587] [drm:radeon_dp_getdpcd] 01 
[    1.058588] [drm:radeon_dp_getdpcd] 02 
[    1.058589] [drm:radeon_dp_getdpcd] 00 
[    1.058590] [drm:radeon_dp_getdpcd] 00 
[    1.058591] [drm:radeon_dp_getdpcd] 00 
[    1.058592] [drm:radeon_dp_getdpcd] 00 
[    1.058593] [drm:radeon_dp_getdpcd] 00 
[    1.058593] [drm:radeon_dp_getdpcd] 00 
[    1.058595] [drm:radeon_dp_getdpcd] 
[    1.102714] [drm:radeon_atombios_connected_scratch_regs] CRT1 connected
[    1.102720] [drm:radeon_atombios_connected_scratch_regs] CRT1 disconnected
[    1.190813] [drm:drm_edid_to_eld] ELD: no CEA Extension found
[    1.190831] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:25:VGA-1] probed modes :
[    1.190834] [drm:drm_mode_debug_printmodeline] Modeline 29:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[    1.190837] [drm:drm_mode_debug_printmodeline] Modeline 33:"1280x1024" 76 141813 1280 1376 1512 1744 1024 1025 1028 1070 0x0 0x6
[    1.190839] [drm:drm_mode_debug_printmodeline] Modeline 43:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    1.190842] [drm:drm_mode_debug_printmodeline] Modeline 32:"1280x1024" 67 123228 1280 1368 1504 1728 1024 1025 1028 1064 0x0 0x6
[    1.190844] [drm:drm_mode_debug_printmodeline] Modeline 30:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    1.190846] [drm:drm_mode_debug_printmodeline] Modeline 31:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[    1.190848] [drm:drm_mode_debug_printmodeline] Modeline 34:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    1.190851] [drm:drm_mode_debug_printmodeline] Modeline 44:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    1.190853] [drm:drm_mode_debug_printmodeline] Modeline 45:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    1.190855] [drm:drm_mode_debug_printmodeline] Modeline 35:"1024x768" 66 71639 1024 1080 1192 1360 768 769 772 798 0x0 0x6
[    1.190857] [drm:drm_mode_debug_printmodeline] Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    1.190860] [drm:drm_mode_debug_printmodeline] Modeline 47:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[    1.190862] [drm:drm_mode_debug_printmodeline] Modeline 48:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    1.190864] [drm:drm_mode_debug_printmodeline] Modeline 49:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    1.190866] [drm:drm_mode_debug_printmodeline] Modeline 36:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    1.190868] [drm:drm_mode_debug_printmodeline] Modeline 37:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    1.190870] [drm:drm_mode_debug_printmodeline] Modeline 38:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    1.190873] [drm:drm_mode_debug_printmodeline] Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[    1.190875] [drm:drm_mode_debug_printmodeline] Modeline 40:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[    1.190877] [drm:drm_mode_debug_printmodeline] Modeline 41:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    1.190879] [drm:drm_mode_debug_printmodeline] Modeline 42:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    1.190882] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:27:DVI-D-1]
[    1.191934] [drm:radeon_atombios_connected_scratch_regs] DFP2 disconnected
[    1.191936] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:27:DVI-D-1] disconnected
[    1.191937] [drm:drm_setup_crtcs] 
[    1.191940] [drm:drm_enable_connectors] connector 22 enabled? no
[    1.191941] [drm:drm_enable_connectors] connector 25 enabled? yes
[    1.191942] [drm:drm_enable_connectors] connector 27 enabled? no
[    1.191944] [drm:drm_target_preferred] looking for cmdline mode on connector 25
[    1.191945] [drm:drm_target_preferred] looking for preferred mode on connector 25
[    1.191947] [drm:drm_target_preferred] found mode 1600x1200
[    1.191948] [drm:drm_setup_crtcs] picking CRTCs for 16384x16384 config
[    1.191950] [drm:drm_setup_crtcs] desired mode 1600x1200 set on crtc 14
[    1.194094] [drm] fb mappable at 0xC047A000
[    1.194126] [drm] vram apper at 0xC0000000
[    1.194155] [drm] size 7680000
[    1.194185] [drm] fb depth is 24
[    1.194214] [drm]    pitch is 6400
[    1.194336] fbcon: radeondrmfb (fb0) is primary device
[    1.194903] [drm:drm_crtc_helper_set_config] 
[    1.194904] [drm:drm_crtc_helper_set_config] [CRTC:14] [FB:51] #connectors=1 (x y) (0 0)
[    1.194907] [drm:drm_crtc_helper_set_config] crtc has no fb, full mode set
[    1.194907] [drm:drm_crtc_helper_set_config] modes are different, full mode set
[    1.194909] [drm:drm_mode_debug_printmodeline] Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.194910] [drm:drm_mode_debug_printmodeline] Modeline 50:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[    1.194911] [drm:drm_crtc_helper_set_config] encoder changed, full mode switch
[    1.194912] [drm:drm_crtc_helper_set_config] crtc changed, full mode switch
[    1.194913] [drm:drm_crtc_helper_set_config] [CONNECTOR:25:VGA-1] to [CRTC:14]
[    1.194914] [drm:drm_crtc_helper_set_config] attempting to set mode from userspace
[    1.194915] [drm:drm_mode_debug_printmodeline] Modeline 50:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[    1.194918] [drm:radeon_encoder_set_active_device] setting active device to 00000001 from 00000001 00000001 for encoder 1
[    1.194925] [drm:drm_crtc_helper_set_mode] [CRTC:14]
[    1.194936] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    1.194939] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    1.194971] [drm:radeon_compute_pll_avivo] 1350000 - 1350000, pll dividers - fb: 27.0 ref: 2, post 1
[    1.202677] [drm:drm_crtc_helper_set_mode] [ENCODER:23:DAC-23] set [MODE:50:1600x1200]
[    1.202679] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000001, active_devices 00000001
[    1.698854] tsc: Refined TSC clocksource calibration: 3393.827 MHz
[    2.699819] Switched to clocksource tsc
[    6.226980] [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs aborting
[    6.226982] [drm:atom_execute_table_locked] *ERROR* atombios stuck executing EC64 (len 2642, WS 0, PS 8) @ 0xF26C
[    6.226993] [drm:dce5_crtc_load_lut] 0
[    6.243673] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 0, devices 00000001, active_devices 00000001
[    6.333115] [drm:dp_get_adjust_train] requested signal parameters: lane 0 voltage 0.4V pre_emph 3.5dB
[    6.333116] [drm:dp_get_adjust_train] requested signal parameters: lane 1 voltage 0.4V pre_emph 3.5dB
[    6.333117] [drm:dp_get_adjust_train] using signal parameters: voltage 0.4V pre_emph 3.5dB
[    6.333749] [drm:dp_get_adjust_train] requested signal parameters: lane 0 voltage 0.4V pre_emph 6dB
[    6.333750] [drm:dp_get_adjust_train] requested signal parameters: lane 1 voltage 0.4V pre_emph 6dB
[    6.333750] [drm:dp_get_adjust_train] using signal parameters: voltage 0.4V pre_emph 6dB
[    6.334382] [drm:dp_get_adjust_train] requested signal parameters: lane 0 voltage 0.4V pre_emph 9.5dB
[    6.334383] [drm:dp_get_adjust_train] requested signal parameters: lane 1 voltage 0.4V pre_emph 9.5dB
[    6.334383] [drm:dp_get_adjust_train] using signal parameters: voltage 0.4V pre_emph 9.5dB
[    6.335015] [drm:dp_get_adjust_train] requested signal parameters: lane 0 voltage 0.6V pre_emph 0dB
[    6.335016] [drm:dp_get_adjust_train] requested signal parameters: lane 1 voltage 0.6V pre_emph 0dB
[    6.335017] [drm:dp_get_adjust_train] using signal parameters: voltage 0.6V pre_emph 0dB
[    6.335649] [drm:dp_get_adjust_train] requested signal parameters: lane 0 voltage 0.6V pre_emph 3.5dB
[    6.335649] [drm:dp_get_adjust_train] requested signal parameters: lane 1 voltage 0.6V pre_emph 3.5dB
[    6.335650] [drm:dp_get_adjust_train] using signal parameters: voltage 0.6V pre_emph 3.5dB
[    6.336282] [drm:dp_get_adjust_train] requested signal parameters: lane 0 voltage 0.6V pre_emph 6dB
[    6.336283] [drm:dp_get_adjust_train] requested signal parameters: lane 1 voltage 0.6V pre_emph 6dB
[    6.336283] [drm:dp_get_adjust_train] using signal parameters: voltage 0.6V pre_emph 6dB
[    6.336915] [drm:dp_get_adjust_train] requested signal parameters: lane 0 voltage 0.8V pre_emph 0dB
[    6.336915] [drm:dp_get_adjust_train] requested signal parameters: lane 1 voltage 0.8V pre_emph 0dB
[    6.336916] [drm:dp_get_adjust_train] using signal parameters: voltage 0.8V pre_emph 0dB
[    6.337548] [drm:dp_get_adjust_train] requested signal parameters: lane 0 voltage 0.8V pre_emph 3.5dB
[    6.337548] [drm:dp_get_adjust_train] requested signal parameters: lane 1 voltage 0.8V pre_emph 3.5dB
[    6.337549] [drm:dp_get_adjust_train] using signal parameters: voltage 0.8V pre_emph 3.5dB
[    6.338180] [drm:dp_get_adjust_train] requested signal parameters: lane 0 voltage 1.2V pre_emph 0dB
[    6.338181] [drm:dp_get_adjust_train] requested signal parameters: lane 1 voltage 1.2V pre_emph 0dB
[    6.338182] [drm:dp_get_adjust_train] using signal parameters: voltage 1.2V pre_emph 0dB
[    6.338813] [drm:radeon_dp_link_train_cr] *ERROR* clock recovery reached max voltage
[    6.338814] [drm:radeon_dp_link_train_cr] *ERROR* clock recovery failed
[    6.355864] [drm:drm_crtc_helper_set_config] Setting connector DPMS state to on
[    6.355867] [drm:drm_crtc_helper_set_config] 	[CONNECTOR:25:VGA-1] set DPMS on
[    6.355870] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    6.355873] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    6.355901] [drm:drm_crtc_helper_set_config] 
[    6.355902] [drm:drm_crtc_helper_set_config] [CRTC:16] [NOFB]
[    6.355903] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    6.355905] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    6.355926] [drm:drm_crtc_helper_set_config] 
[    6.355927] [drm:drm_crtc_helper_set_config] [CRTC:18] [NOFB]
[    6.355928] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    6.355930] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    6.355951] [drm:drm_crtc_helper_set_config] 
[    6.355951] [drm:drm_crtc_helper_set_config] [CRTC:20] [NOFB]
[    6.355952] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000008, active_devices 00000000
[    6.355954] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000080, active_devices 00000000
[    6.355992] [drm:drm_crtc_helper_set_config] 
[    6.355993] [drm:drm_crtc_helper_set_config] [CRTC:14] [FB:51] #connectors=1 (x y) (0 0)
[    6.355997] [drm:drm_crtc_helper_set_config] [CONNECTOR:25:VGA-1] to [CRTC:14]
[    6.355999] [drm:dce5_crtc_load_lut] 0
[    6.356065] [drm:dce5_crtc_load_lut] 0
[    6.360486] [drm:drm_crtc_helper_set_config] 
[    6.360487] [drm:drm_crtc_helper_set_config] [CRTC:14] [FB:51] #connectors=1 (x y) (0 0)
[    6.360489] [drm:drm_crtc_helper_set_config] [CONNECTOR:25:VGA-1] to [CRTC:14]
[    6.360491] [drm:dce5_crtc_load_lut] 0
[    6.360551] [drm:dce5_crtc_load_lut] 0
[    6.364916] Console: switching to colour frame buffer device 133x54
[    6.364919] [drm:drm_crtc_helper_set_config] 
[    6.364920] [drm:drm_crtc_helper_set_config] [CRTC:14] [FB:51] #connectors=1 (x y) (0 0)
[    6.364922] [drm:drm_crtc_helper_set_config] [CONNECTOR:25:VGA-1] to [CRTC:14]
[    6.364923] [drm:dce5_crtc_load_lut] 0
[    6.369055] [drm:dce5_crtc_load_lut] 0
[    6.369514] radeon 0000:00:01.0: fb0: radeondrmfb frame buffer device
[    6.369564] radeon 0000:00:01.0: registered panic notifier
[    6.369708] [drm] Initialized radeon 2.38.0 20080528 for 0000:00:01.0 on minor 0
[    6.370202] Uniform Multi-Platform E-IDE driver
[    6.370322] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    6.370401] ide-gd driver 1.18
[    6.370439] ide-cd driver 5.00
[    6.370528] 3ware Storage Controller device driver for Linux v1.26.02.003.
[    6.370662] SCSI Media Changer driver v0.25 
[    6.370730] ahci 0000:00:11.0: version 3.0
[    6.370953] ahci 0000:00:11.0: irq 42 for MSI/MSI-X
[    6.371000] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0x5 impl SATA mode
[    6.371065] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    6.371632] scsi0 : ahci
[    6.371853] scsi1 : ahci
[    6.371977] scsi2 : ahci
[    6.372083] ata1: SATA max UDMA/133 abar m2048@0xfef4f000 port 0xfef4f100 irq 42
[    6.372151] ata2: DUMMY
[    6.372173] ata3: SATA max UDMA/133 abar m2048@0xfef4f000 port 0xfef4f200 irq 42
[    6.372619] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    6.374396] r8169 0000:01:00.0: irq 43 for MSI/MSI-X
[    6.374545] r8169 0000:01:00.0 eth0: RTL8168evl/8111evl at 0xffffc90010082000, 94:de:80:0a:3b:43, XID 0c900800 IRQ 43
[    6.376197] r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    6.378032] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.379709] ehci-pci: EHCI PCI platform driver
[    6.381531] QUIRK: Enable AMD PLL fix
[    6.381552] ehci-pci 0000:00:12.2: EHCI Host Controller
[    6.383259] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[    6.384947] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    6.386670] ehci-pci 0000:00:12.2: debug port 1
[    6.388396] ehci-pci 0000:00:12.2: irq 17, io mem 0xfef4d000
[    6.399299] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    6.401239] hub 1-0:1.0: USB hub found
[    6.402940] hub 1-0:1.0: 5 ports detected
[    6.405001] ehci-pci 0000:00:13.2: EHCI Host Controller
[    6.406760] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[    6.408490] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    6.410230] ehci-pci 0000:00:13.2: debug port 1
[    6.411979] ehci-pci 0000:00:13.2: irq 17, io mem 0xfef4b000
[    6.423321] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    6.425306] hub 2-0:1.0: USB hub found
[    6.427053] hub 2-0:1.0: 5 ports detected
[    6.429172] ehci-pci 0000:00:16.2: EHCI Host Controller
[    6.430994] ehci-pci 0000:00:16.2: new USB bus registered, assigned bus number 3
[    6.432798] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    6.434639] ehci-pci 0000:00:16.2: debug port 1
[    6.436474] ehci-pci 0000:00:16.2: irq 17, io mem 0xfef48000
[    6.447343] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    6.449381] hub 3-0:1.0: USB hub found
[    6.451146] hub 3-0:1.0: 4 ports detected
[    6.453027] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.454741] ohci-pci: OHCI PCI platform driver
[    6.456654] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    6.458419] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 4
[    6.460177] ohci-pci 0000:00:12.0: irq 18, io mem 0xfef4e000
[    6.519657] hub 4-0:1.0: USB hub found
[    6.521369] hub 4-0:1.0: 5 ports detected
[    6.523372] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    6.525070] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 5
[    6.526737] ohci-pci 0000:00:13.0: irq 18, io mem 0xfef4c000
[    6.587704] hub 5-0:1.0: USB hub found
[    6.589352] hub 5-0:1.0: 5 ports detected
[    6.591290] ohci-pci 0000:00:14.5: OHCI PCI host controller
[    6.592949] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 6
[    6.594584] ohci-pci 0000:00:14.5: irq 18, io mem 0xfef4a000
[    6.655787] hub 6-0:1.0: USB hub found
[    6.657404] hub 6-0:1.0: 2 ports detected
[    6.659292] ohci-pci 0000:00:16.0: OHCI PCI host controller
[    6.660959] ohci-pci 0000:00:16.0: new USB bus registered, assigned bus number 7
[    6.662584] ohci-pci 0000:00:16.0: irq 18, io mem 0xfef49000
[    6.723854] hub 7-0:1.0: USB hub found
[    6.725441] hub 7-0:1.0: 4 ports detected
[    6.727104] uhci_hcd: USB Universal Host Controller Interface driver
[    6.728697] usbcore: registered new interface driver usblp
[    6.730244] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    6.732158] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.733730] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.735381] mousedev: PS/2 mouse device common for all mice
[    6.737112] rtc_cmos 00:07: RTC can wake from S4
[    6.738747] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    6.740314] rtc_cmos 00:07: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    6.741920] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    6.743542] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0xb20
[    6.745213] it87: Found IT8728F chip at 0x228, revision 1
[    6.746808] it87: Beeping is supported
[    6.749105] usbcore: registered new interface driver usbhid
[    6.750712] usbhid: USB HID core driver
[    6.752703] snd_hda_intel 0000:00:01.1: Force to non-snoop mode
[    6.754324] snd_hda_intel 0000:00:01.1: irq 44 for MSI/MSI-X
[    6.754680] oprofile: AMD IBS detected (0x000000ff)
[    6.756351] oprofile: using NMI interrupt.
[    6.757930] Netfilter messages via NETLINK v0.30.
[    6.759539] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    6.761262] ctnetlink v0.93: registering with nfnetlink.
[    6.762972] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.764583] TCP: cubic registered
[    6.765179] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    6.769023] NET: Registered protocol family 10
[    6.770869] NET: Registered protocol family 17
[    6.773247] console [netcon0] enabled
[    6.774873] netconsole: network logging started
[    6.776524] rtc_cmos 00:07: setting system clock to 2014-05-12 16:14:48 UTC (1399911288)
[    6.778272] acpi-cpufreq: overriding BIOS provided _PSD data
[    6.780122] ALSA device list:
[    6.781761]   #0: HDA ATI HDMI at 0xfef44000 irq 44
[    6.796564] sound hdaudioC1D0: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[    6.798267] sound hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    6.799973] sound hdaudioC1D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    6.801638] sound hdaudioC1D0:    mono: mono_out=0x0
[    6.803312] sound hdaudioC1D0:    dig-out=0x11/0x0
[    6.804960] sound hdaudioC1D0:    inputs:
[    6.806591] sound hdaudioC1D0:      Rear Mic=0x18
[    6.808222] sound hdaudioC1D0:      Front Mic=0x19
[    6.809842] sound hdaudioC1D0:      Line=0x1a
[    6.811440] sound hdaudioC1D0:      CD=0x1c
[    6.863740] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.866830] ata1.00: ATA-8: ST500DM002-1BD142, KC45, max UDMA/133
[    6.868444] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    6.870065] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.873014] ata1.00: configured for UDMA/133
[    6.874640] ata3.00: ATAPI: TSSTcorp CDDVDW SH-224BB, SB00, max UDMA/100
[    6.874724] scsi 0:0:0:0: Direct-Access     ATA      ST500DM002-1BD14 KC45 PQ: 0 ANSI: 5
[    6.874992] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.875025] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    6.875026] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    6.875071] sd 0:0:0:0: [sda] Write Protect is off
[    6.875073] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.875091] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.888599] ata3.00: configured for UDMA/100
[    6.891721] scsi 2:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-224BB  SB00 PQ: 0 ANSI: 5
[    6.911745] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    6.913460] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.915308] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    6.915385] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    7.018737]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 sda14 sda15 >
[    7.021291] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.171738] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[    7.693892] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input4
[    7.710014] EXT3-fs (sda10): error: couldn't mount because of unsupported optional features (240)
[    7.718345] EXT2-fs (sda10): error: couldn't mount because of unsupported optional features (240)
[    7.749774] EXT4-fs (sda10): mounted filesystem with ordered data mode. Opts: (null)
[    7.751594] VFS: Mounted root (ext4 filesystem) readonly on device 8:10.
[    7.785525] devtmpfs: mounted
[    7.788135] Freeing unused kernel memory: 1156K (ffffffff81c4f000 - ffffffff81d70000)
[    8.108876] random: nonblocking pool is initialized
[    8.965119] udevd[1675]: starting version 1.2
[   12.927763] Adding 4194300k swap on /dev/sda5.  Priority:-1 extents:1 across:4194300k 
[   12.950100] EXT4-fs (sda10): re-mounted. Opts: (null)
[   13.446318] EXT4-fs (sda10): re-mounted. Opts: (null)
[   13.606268] EXT4-fs (sda13): mounted filesystem with ordered data mode. Opts: (null)
[   13.922822] [drm:drm_crtc_helper_set_config] 
[   13.922825] [drm:drm_crtc_helper_set_config] [CRTC:14] [FB:51] #connectors=1 (x y) (0 0)
[   13.922833] [drm:drm_crtc_helper_set_config] [CONNECTOR:25:VGA-1] to [CRTC:14]
[   13.922838] [drm:dce5_crtc_load_lut] 0
[   13.922917] [drm:dce5_crtc_load_lut] 0
[   15.045242] r8169 0000:01:00.0 eth0: link down
[   15.045249] r8169 0000:01:00.0 eth0: link down
[   15.045284] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   16.561220] r8169 0000:01:00.0 eth0: link up
[   16.561235] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   30.930834] IPTABLES Packet Dropped: IN=eth0 OUT= MAC=94:de:80:0a:3b:43:2c:b0:5d:04:33:bb:08:00 SRC=192.168.7.254 DST=192.168.7.148 LEN=328 TOS=0x00 PREC=0x00 TTL=128 ID=57005 PROTO=UDP SPT=67 DPT=68 LEN=308 

--wac7ysb48OaltWcw--
