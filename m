Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3BRP4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:56:12 -0500
Received: from static.52.99.9.5.clients.your-server.de ([5.9.99.52]:48153 "EHLO
	mail1.project-insanity.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232Ab3BRP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:56:08 -0500
Date: Mon, 18 Feb 2013 15:54:40 +0000
From: Jonas Heinrich <onny@project-insanity.org>
To: hpa@zytor.com, len.brown@intel.com, pavel@ucw.cz, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [Bisected] 3.7-rc1 can't resume
Message-ID: <20130218155439.GA902@onny>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VywGB/WGlW4DM4P8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VywGB/WGlW4DM4P8
Content-Type: multipart/mixed; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02-17 21:40, Rafael J. Wysocki wrote:
> Does the commit immediately preceding this one behave correctly?
Strangely the preceding commit works well, so I bisected the kernel
again, this time more carefully and I've got a different result!
(see bisect_log attachement).
It seems to be commit 73201dbec64aebf6b0dca855b523f437972dc7bb=20
(https://patchwork.kernel.org/patch/1511921/).
Someone on LKML already reported an issue with this commit
(https://lkml.org/lkml/2012/10/18/228) , but Peter
Anvins patch got already applied in newer versions.
Reverting this patch with the recent git clone seems to be difficult
because it already has too much dependencies.

Additionally I've included dmesg dumps of the last good and the bad
kernel version.

On 02-17 12:52, H. Peter Anvin wrote:
> T43 is quite old... which might have exposed unique bugs.  How reliable i=
s the failure?  Even one misidentified commit results in git bisect giving =
garbage.
It affects really all versions after that commit and the failure happens
every time I try to resume my notebook.

Best regards,
Jonas

--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=bisect_log_new

git bisect start
# good: [49b8c695e331c9685e6ffdbf34872509d77c8459] Merge branch 'x86/fpu' into x86/smap
git bisect good 49b8c695e331c9685e6ffdbf34872509d77c8459
# good: [49b8c695e331c9685e6ffdbf34872509d77c8459] Merge branch 'x86/fpu' into x86/smap
git bisect good 49b8c695e331c9685e6ffdbf34872509d77c8459
# bad: [a20acf99f75e49271381d65db097c9763060a1e8] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next
git bisect bad a20acf99f75e49271381d65db097c9763060a1e8
# good: [06d2fe153b9b35e57221e35831a26918f462db68] Merge tag 'driver-core-3.6' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
git bisect good 06d2fe153b9b35e57221e35831a26918f462db68
# good: [3498d13b8090c0b0ef911409fbc503a7c4cca6ef] Merge tag 'tty-3.6' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect good 3498d13b8090c0b0ef911409fbc503a7c4cca6ef
# bad: [61464c8357c8f6b780e4c44f5c79471799c51ca7] Merge tag 'cleanup' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect bad 61464c8357c8f6b780e4c44f5c79471799c51ca7
# good: [cc150a2861e744d8f574d571762cc7e9f928abb3] Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
git bisect good cc150a2861e744d8f574d571762cc7e9f928abb3
# good: [60e59920152c7bafc8a2eb3031a62f22c2bc9e95] Merge branch 'board' of git://github.com/hzhuang1/linux into next/cleanup
git bisect good 60e59920152c7bafc8a2eb3031a62f22c2bc9e95
# bad: [797b9e5ae93270ec27a1f1ed48cd697d01b2269f] Merge branch 'for-linus' of git://git.samba.org/sfrench/cifs-2.6
git bisect bad 797b9e5ae93270ec27a1f1ed48cd697d01b2269f
# good: [71953fc6e4ce5ac05b594d8e5866accf531aa969] cifs: remove kmap lock and rsize limit
git bisect good 71953fc6e4ce5ac05b594d8e5866accf531aa969
# good: [c052e2b423f3eabe9f3f32e60744afa5cf26f6b9] cifs: obtain file access during backup intent lookup (resend)
git bisect good c052e2b423f3eabe9f3f32e60744afa5cf26f6b9
# good: [cdeb9b014331af4282be522824e36f3aa33f0671] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
git bisect good cdeb9b014331af4282be522824e36f3aa33f0671
# good: [a57d985e378ca69f430b85852e4187db3698a89e] Merge tag 'please-pull-ia64-for-3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux
git bisect good a57d985e378ca69f430b85852e4187db3698a89e
# bad: [b2cc2a074de75671bbed5e2dda67a9252ef353ea] x86, smep, smap: Make the switching functions one-way
git bisect bad b2cc2a074de75671bbed5e2dda67a9252ef353ea
# good: [5a5a51db78ef24aa61a4cb2ae36f07f6fa37356d] x86-32: Start out eflags and cr4 clean
git bisect good 5a5a51db78ef24aa61a4cb2ae36f07f6fa37356d
# bad: [73201dbec64aebf6b0dca855b523f437972dc7bb] x86, suspend: On wakeup always initialize cr4 and EFER
git bisect bad 73201dbec64aebf6b0dca855b523f437972dc7bb
# bad: [73201dbec64aebf6b0dca855b523f437972dc7bb] x86, suspend: On wakeup always initialize cr4 and EFER
git bisect bad 73201dbec64aebf6b0dca855b523f437972dc7bb
# bad: [73201dbec64aebf6b0dca855b523f437972dc7bb] x86, suspend: On wakeup always initialize cr4 and EFER
git bisect bad 73201dbec64aebf6b0dca855b523f437972dc7bb

--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg_bad_kernel
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-36-bisect (root@playground_32) (gcc vers=
ion 4.7.2 (GCC) ) #1 SMP PREEMPT Mon Feb 18 15:13:28 UTC 2013
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000005f6dffff] usable
[    0.000000] BIOS-e820: [mem 0x000000005f6e0000-0x000000005f6f4fff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x000000005f6f5000-0x000000005f6fffff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x000000005f700000-0x000000005fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000f0008000-0x00000000f000bfff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed20000-0x00000000fed8ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI present.
[    0.000000] DMI: IBM 1871F1G/1871F1G, BIOS 70ET69WW (1.29 ) 05/29/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x5f6e0 max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 base 05F700000 mask FFFF00000 uncachable
[    0.000000]   3 base 05F800000 mask FFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x377fdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x373fffff] page 2M
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x377fdfff @ [mem 0x01bfa=
000-0x01bfffff]
[    0.000000] RAMDISK: [mem 0x37a68000-0x37d2bfff]
[    0.000000] Allocated new RAMDISK: [mem 0x3753a000-0x377fd537]
[    0.000000] Move RAMDISK from [mem 0x37a68000-0x37d2b537] to [mem 0x3753=
a000-0x377fd537]
[    0.000000] ACPI: RSDP 000f6b90 00024 (v02 IBM   )
[    0.000000] ACPI: XSDT 5f6e71d4 00064 (v01 DELL    M09     00001290  LTP=
 00000000)
[    0.000000] ACPI: FACP 5f6e7300 000F4 (v03 DELL    M09     00001290 IBM =
 00000001)
[    0.000000] ACPI BIOS Bug: Warning: 32/64X length mismatch in FADT/Gpe1B=
lock: 0/32 (20120711/tbfadt-567)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Gpe1Block has ze=
ro address or length: 0x000000000000102C/0x0 (20120711/tbfadt-598)
[    0.000000] ACPI: DSDT 5f6e74e7 0D7A8 (v01 DELL    M09     00001290 MSFT=
 0100000E)
[    0.000000] ACPI: FACS 5f6f6000 00040
[    0.000000] ACPI: SSDT 5f6e74b4 00033 (v01 DELL    M09     00001290 MSFT=
 0100000E)
[    0.000000] ACPI: ECDT 5f6f4c8f 00052 (v01 DELL    M09     00001290 IBM =
 00000001)
[    0.000000] ACPI: TCPA 5f6f4ce1 00032 (v01 DELL    M09     00001290 PTL =
 00000001)
[    0.000000] ACPI: APIC 5f6f4d13 0005A (v01 DELL    M09     00001290 IBM =
 00000001)
[    0.000000] ACPI: MCFG 5f6f4d6d 0003E (v01 DELL    M09     00001290 IBM =
 00000001)
[    0.000000] ACPI: SLIC 5f6f4dab 00176 (v01 DELL    M09     00001290 ASL =
 00000061)
[    0.000000] ACPI: BOOT 5f6f4fd8 00028 (v01 DELL    M09     00001290  LTP=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 638MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x5f6dffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x5f6dffff]
[    0.000000] On node 0 totalpages: 390767
[    0.000000] free_area_init_node: node 0, pgdat c1574a40, node_mem_map f6=
949200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1278 pages used for memmap
[    0.000000]   HighMem zone: 162276 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 00000000001=
00000
[    0.000000] e820: [mem 0x60000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @f6933000 s32320 r0 d20928 u53=
248
[    0.000000] pcpu-alloc: s32320 r0 d20928 u53248 alloc=3D13*4096
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 387713
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-linux-bisect=
 root=3DUUID=3D89b7a62a-2ab6-4c47-8158-67f559a5bd97 ro init=3D/bin/systemd =
resume=3D/dev/sda1
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] allocated 3126912 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:0005f6e0)
[    0.000000] Memory: 1536908k/1563520k available (4028k kernel code, 2616=
0k reserved, 1615k data, 548k init, 654216k highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc1583000 - 0xc160c000   ( 548 kB)
      .data : 0xc13ef036 - 0xc1583000   (1615 kB)
      .text : 0xc1000000 - 0xc13ef036   (4028 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cpu_ids=3D1.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Df6008000 soft=3Df600a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1862.150 MHz processor
[    0.003335] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 3725.47 BogoMIPS (lpj=3D6207166)
[    0.003348] pid_max: default: 32768 minimum: 301
[    0.003389] Security Framework initialized
[    0.003405] AppArmor: AppArmor disabled by boot time parameter
[    0.003432] Mount-cache hash table entries: 512
[    0.003720] Initializing cgroup subsys cpuacct
[    0.003728] Initializing cgroup subsys memory
[    0.003742] Initializing cgroup subsys devices
[    0.003748] Initializing cgroup subsys freezer
[    0.003754] Initializing cgroup subsys net_cls
[    0.003760] Initializing cgroup subsys blkio
[    0.003795] Disabled fast string operations
[    0.003806] mce: CPU supports 5 MCE banks
[    0.003820] CPU0: Thermal monitoring enabled (TM2)
[    0.003838] Last level iTLB entries: 4KB 128, 2MB 0, 4MB 2
Last level dTLB entries: 4KB 128, 2MB 0, 4MB 8
tlb_flushall_shift is 0x6
[    0.003926] SMP alternatives: switching to UP code
[    0.010133] Freeing SMP alternatives: 16k freed
[    0.010144] ACPI: Core revision 20120711
[    0.020010] ftrace: allocating 17441 entries in 35 pages
[    0.030066] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.030522] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.065143] smpboot: CPU0: Intel(R) Pentium(R) M processor 1.86GHz stepp=
ing 08
[    0.066662] Performance Events: p6 PMU driver.
[    0.066662] ... version:                0
[    0.066662] ... bit width:              32
[    0.066662] ... generic registers:      2
[    0.066662] ... value mask:             00000000ffffffff
[    0.066662] ... max period:             000000007fffffff
[    0.066662] ... fixed-purpose events:   0
[    0.066662] ... event mask:             0000000000000003
[    0.090472] NMI watchdog: enabled on all CPUs, permanently consumes one =
hw-PMU counter.
[    0.090515] Brought up 1 CPUs
[    0.090521] smpboot: Total of 1 processors activated (3725.47 BogoMIPS)
[    0.091883] devtmpfs: initialized
[    0.092169] PM: Registering ACPI NVS region [mem 0x5f6f5000-0x5f6fffff] =
(45056 bytes)
[    0.093408] RTC time: 15:19:57, date: 02/18/13
[    0.093470] NET: Registered protocol family 16
[    0.093688] ACPI: bus type pci registered
[    0.093776] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    0.093788] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.093794] PCI: Using MMCONFIG for extended config space
[    0.093800] PCI: Using configuration type 1 for base access
[    0.094519] bio: create slab <bio-0> at 0
[    0.094596] ACPI: Added _OSI(Module Device)
[    0.094603] ACPI: Added _OSI(Processor Device)
[    0.094608] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.094614] ACPI: Added _OSI(Processor Aggregator Device)
[    0.096571] ACPI: EC: EC description table is found, configuring boot EC
[    0.107911] ACPI: Interpreter enabled
[    0.107922] ACPI: (supports S0 S3 S4 S5)
[    0.107946] ACPI: Using IOAPIC for interrupt routing
[    0.110690] ACPI: Power Resource [PUBS] (on)
[    0.113929] ACPI: EC: GPE =3D 0x1c, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.117164] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.117175] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.117209] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.117245] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.117249] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.117252] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.117255] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x00=
0d3fff] (ignored)
[    0.117259] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x00=
0d7fff] (ignored)
[    0.117262] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x00=
0dbfff] (ignored)
[    0.117265] pci_root PNP0A08:00: host bridge window [mem 0x60000000-0xfe=
bfffff] (ignored)
[    0.117268] PCI: root bus 00: using default resources
[    0.117311] PCI host bridge to bus 0000:00
[    0.117320] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    0.117323] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.117330] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.117337] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
f]
[    0.117354] pci 0000:00:00.0: [8086:2590] type 00 class 0x060000
[    0.117401] pci 0000:00:02.0: [8086:2592] type 00 class 0x030000
[    0.117412] pci 0000:00:02.0: reg 10: [mem 0x90080000-0x900fffff]
[    0.117418] pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
[    0.117425] pci 0000:00:02.0: reg 18: [mem 0xb0000000-0xbfffffff pref]
[    0.117431] pci 0000:00:02.0: reg 1c: [mem 0x90000000-0x9003ffff]
[    0.117465] pci 0000:00:02.1: [8086:2792] type 00 class 0x038000
[    0.117474] pci 0000:00:02.1: reg 10: [mem 0x00000000-0x0007ffff]
[    0.117567] pci 0000:00:1c.0: [8086:2660] type 01 class 0x060400
[    0.117669] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.117705] pci 0000:00:1c.2: [8086:2664] type 01 class 0x060400
[    0.117807] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.117843] pci 0000:00:1d.0: [8086:2658] type 00 class 0x0c0300
[    0.117895] pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
[    0.117938] pci 0000:00:1d.1: [8086:2659] type 00 class 0x0c0300
[    0.117989] pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
[    0.118032] pci 0000:00:1d.2: [8086:265a] type 00 class 0x0c0300
[    0.118083] pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
[    0.118126] pci 0000:00:1d.3: [8086:265b] type 00 class 0x0c0300
[    0.118177] pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
[    0.118230] pci 0000:00:1d.7: [8086:265c] type 00 class 0x0c0320
[    0.118254] pci 0000:00:1d.7: reg 10: [mem 0x90040000-0x900403ff]
[    0.118354] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.118380] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.118469] pci 0000:00:1e.2: [8086:266e] type 00 class 0x040100
[    0.118487] pci 0000:00:1e.2: reg 10: [io  0x1c00-0x1cff]
[    0.118500] pci 0000:00:1e.2: reg 14: [io  0x18c0-0x18ff]
[    0.118512] pci 0000:00:1e.2: reg 18: [mem 0x90040800-0x900409ff]
[    0.118524] pci 0000:00:1e.2: reg 1c: [mem 0x90040400-0x900404ff]
[    0.118586] pci 0000:00:1e.2: PME# supported from D0 D3hot D3cold
[    0.118613] pci 0000:00:1f.0: [8086:2641] type 00 class 0x060100
[    0.118721] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.118730] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6=
 ACPI/GPIO/TCO
[    0.118743] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6=
 GPIO
[    0.118753] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 1600-167f
[    0.118763] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 15e0-15ef
[    0.118795] pci 0000:00:1f.2: [8086:2653] type 00 class 0x010180
[    0.118813] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.118825] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.118837] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.118849] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.118861] pci 0000:00:1f.2: reg 20: [io  0x1810-0x181f]
[    0.118915] pci 0000:00:1f.2: PME# supported from D3hot
[    0.118936] pci 0000:00:1f.3: [8086:266a] type 00 class 0x0c0500
[    0.119004] pci 0000:00:1f.3: reg 20: [io  0x18a0-0x18bf]
[    0.119107] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 0=
0-ff]
[    0.119140] pci 0000:02:00.0: [14e4:167d] type 00 class 0x020000
[    0.119170] pci 0000:02:00.0: reg 10: [mem 0x90100000-0x9010ffff 64bit]
[    0.119332] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.119357] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'
[    0.119379] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.119391] pci 0000:00:1c.0:   bridge window [mem 0x90100000-0x901fffff]
[    0.119451] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 0=
0-ff]
[    0.119456] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.119465] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.119470] pci 0000:00:1c.2:   bridge window [mem 0x90200000-0x902fffff]
[    0.119479] pci 0000:00:1c.2:   bridge window [mem 0xc0000000-0xc00fffff=
 64bit pref]
[    0.119510] pci_bus 0000:04: busn_res: [bus 04-07] is inserted under [bu=
s 00-ff]
[    0.119528] pci 0000:04:00.0: [104c:ac56] type 02 class 0x060700
[    0.119554] pci 0000:04:00.0: reg 10: [mem 0x90300000-0x90300fff]
[    0.119600] pci 0000:04:00.0: supports D1 D2
[    0.119603] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119635] pci 0000:04:02.0: [8086:1043] type 00 class 0x028000
[    0.119660] pci 0000:04:02.0: reg 10: [mem 0x90301000-0x90301fff]
[    0.119845] pci 0000:00:1e.0: PCI bridge to [bus 04-07] (subtractive dec=
ode)
[    0.119855] pci 0000:00:1e.0:   bridge window [io  0x3000-0x6fff]
[    0.119861] pci 0000:00:1e.0:   bridge window [mem 0x90300000-0x9fffffff]
[    0.119869] pci 0000:00:1e.0:   bridge window [mem 0xc8000000-0xcfffffff=
 64bit pref]
[    0.119872] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtr=
active decode)
[    0.119875] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff=
] (subtractive decode)
[    0.119925] pci_bus 0000:05: busn_res: can not insert [bus 05-ff] under =
[bus 04-07] (conflicts with (null) [bus 04-07])
[    0.119932] pci_bus 0000:05: busn_res: [bus 05-ff] end is updated to 06
[    0.119935] pci_bus 0000:05: busn_res: [bus 05-06] is inserted under [bu=
s 04-07]
[    0.119960] pci_bus 0000:00: on NUMA node 0
[    0.119964] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.120070] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.120112] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.120157] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.120244]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    0.120254]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.123912] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124008] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124102] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124195] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124288] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124381] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124474] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124567] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124670] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.124685] vgaarb: loaded
[    0.124689] vgaarb: bridge control possible 0000:00:02.0
[    0.124744] PCI: Using ACPI for IRQ routing
[    0.134584] PCI: pci_cache_line_size set to 64 bytes
[    0.134658] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.134660] e820: reserve RAM buffer [mem 0x5f6e0000-0x5fffffff]
[    0.134791] NetLabel: Initializing
[    0.134796] NetLabel:  domain hash size =3D 128
[    0.134801] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.134822] NetLabel:  unlabeled traffic allowed by default
[    0.134985] hpet clockevent registered
[    0.134989] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.135000] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.135010] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.146675] Switching to clocksource hpet
[    0.155078] pnp: PnP ACPI init
[    0.155121] ACPI: bus type pnp registered
[    0.155658] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.155662] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.155665] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.155668] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.155670] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.155673] pnp 00:00: [mem 0x000d0000-0x000cffff disabled]
[    0.155676] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.155679] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.155682] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.155685] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.155688] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.155690] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.155693] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.155696] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.155699] pnp 00:00: [mem 0x00100000-0x5fffffff]
[    0.155702] pnp 00:00: [mem 0xfec00000-0xffffffff]
[    0.155784] system 00:00: [mem 0x00000000-0x0009ffff] could not be reser=
ved
[    0.155794] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reser=
ved
[    0.155802] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reser=
ved
[    0.155810] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.155818] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.155826] system 00:00: [mem 0x000dc000-0x000dffff] could not be reser=
ved
[    0.155834] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reser=
ved
[    0.155842] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reser=
ved
[    0.155851] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reser=
ved
[    0.155859] system 00:00: [mem 0x000ec000-0x000effff] could not be reser=
ved
[    0.155867] system 00:00: [mem 0x000f0000-0x000fffff] could not be reser=
ved
[    0.155875] system 00:00: [mem 0x00100000-0x5fffffff] could not be reser=
ved
[    0.155883] system 00:00: [mem 0xfec00000-0xffffffff] could not be reser=
ved
[    0.155894] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.155925] pnp 00:01: [bus 00-ff]
[    0.155929] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.155932] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.155935] pnp 00:01: [io  0x0d00-0xffff window]
[    0.155938] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.155941] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.155944] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.155947] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.155950] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.155953] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.155956] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.155959] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.155962] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.155964] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.155967] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.155970] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.155973] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.155976] pnp 00:01: [mem 0x60000000-0xfebfffff window]
[    0.156040] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.156063] pnp 00:02: [io  0x0010-0x001f]
[    0.156066] pnp 00:02: [io  0x0090-0x009f]
[    0.156069] pnp 00:02: [io  0x0024-0x0025]
[    0.156071] pnp 00:02: [io  0x0028-0x0029]
[    0.156074] pnp 00:02: [io  0x002c-0x002d]
[    0.156077] pnp 00:02: [io  0x0030-0x0031]
[    0.156079] pnp 00:02: [io  0x0034-0x0035]
[    0.156082] pnp 00:02: [io  0x0038-0x0039]
[    0.156085] pnp 00:02: [io  0x003c-0x003d]
[    0.156087] pnp 00:02: [io  0x00a4-0x00a5]
[    0.156090] pnp 00:02: [io  0x00a8-0x00a9]
[    0.156093] pnp 00:02: [io  0x00ac-0x00ad]
[    0.156095] pnp 00:02: [io  0x00b0-0x00b5]
[    0.156098] pnp 00:02: [io  0x00b8-0x00b9]
[    0.156100] pnp 00:02: [io  0x00bc-0x00bd]
[    0.156103] pnp 00:02: [io  0x0050-0x0053]
[    0.156106] pnp 00:02: [io  0x0072-0x0077]
[    0.156108] pnp 00:02: [io  0x002e-0x002f]
[    0.156111] pnp 00:02: [io  0x1000-0x107f]
[    0.156114] pnp 00:02: [io  0x1180-0x11bf]
[    0.156117] pnp 00:02: [io  0x15e0-0x15ef]
[    0.156119] pnp 00:02: [io  0x1600-0x1641]
[    0.156122] pnp 00:02: [io  0x1644-0x167f]
[    0.156125] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    0.156128] pnp 00:02: [mem 0xf0008000-0xf000bfff]
[    0.156130] pnp 00:02: [mem 0xfed14000-0xfed17fff]
[    0.156133] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.156136] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.156215] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.156223] system 00:02: [io  0x1180-0x11bf] has been reserved
[    0.156231] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.156238] system 00:02: [io  0x1600-0x1641] has been reserved
[    0.156246] system 00:02: [io  0x1644-0x167f] has been reserved
[    0.156254] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    0.156262] system 00:02: [mem 0xf0008000-0xf000bfff] has been reserved
[    0.156270] system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.156278] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.156286] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.156295] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.156311] pnp 00:03: [io  0x0000-0x000f]
[    0.156314] pnp 00:03: [io  0x0080-0x008f]
[    0.156317] pnp 00:03: [io  0x00c0-0x00df]
[    0.156324] pnp 00:03: [dma 4]
[    0.156356] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.156369] pnp 00:04: [io  0x0061]
[    0.156401] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.156412] pnp 00:05: [io  0x00f0]
[    0.156429] pnp 00:05: [irq 13]
[    0.156463] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.156474] pnp 00:06: [io  0x0070-0x0071]
[    0.156481] pnp 00:06: [irq 8]
[    0.156519] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.156530] pnp 00:07: [io  0x0060]
[    0.156533] pnp 00:07: [io  0x0064]
[    0.156540] pnp 00:07: [irq 1]
[    0.156573] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.156587] pnp 00:08: [irq 12]
[    0.156622] pnp 00:08: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (a=
ctive)
[    0.156784] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (disabled)
[    0.156900] pnp 00:0a: [io  0x03bc-0x03be]
[    0.156908] pnp 00:0a: [irq 7]
[    0.156990] pnp 00:0a: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.157116] pnp 00:0b: Plug and Play ACPI device, IDs NSC1100 (disabled)
[    0.157663] pnp: PnP ACPI: found 12 devices
[    0.157670] ACPI: ACPI bus type pnp unregistered
[    0.194552] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus =
02] add_size 1000
[    0.194558] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 6=
4bit pref] to [bus 02] add_size 200000
[    0.194593] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x000fffff 64bit=
 pref] get_res_add_size add_size 200000
[    0.194596] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x0fff] get_res_add_=
size add_size 1000
[    0.194603] pci 0000:00:1c.0: BAR 15: assigned [mem 0x60000000-0x601ffff=
f 64bit pref]
[    0.194615] pci 0000:00:02.1: BAR 0: assigned [mem 0x60200000-0x6027ffff]
[    0.194626] pci 0000:00:1c.0: BAR 13: assigned [io  0x7000-0x7fff]
[    0.194634] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.194642] pci 0000:00:1c.0:   bridge window [io  0x7000-0x7fff]
[    0.194654] pci 0000:00:1c.0:   bridge window [mem 0x90100000-0x901fffff]
[    0.194664] pci 0000:00:1c.0:   bridge window [mem 0x60000000-0x601fffff=
 64bit pref]
[    0.194678] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.194686] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.194697] pci 0000:00:1c.2:   bridge window [mem 0x90200000-0x902fffff]
[    0.194708] pci 0000:00:1c.2:   bridge window [mem 0xc0000000-0xc00fffff=
 64bit pref]
[    0.194725] pci 0000:04:00.0: res[15]=3D[mem 0x04000000-0x03ffffff pref]=
 get_res_add_size add_size 4000000
[    0.194728] pci 0000:04:00.0: res[16]=3D[mem 0x04000000-0x03ffffff] get_=
res_add_size add_size 4000000
[    0.194731] pci 0000:04:00.0: res[13]=3D[io  0x0100-0x00ff] get_res_add_=
size add_size 100
[    0.194735] pci 0000:04:00.0: res[14]=3D[io  0x0100-0x00ff] get_res_add_=
size add_size 100
[    0.194738] pci 0000:04:00.0: BAR 15: assigned [mem 0xc8000000-0xcbfffff=
f pref]
[    0.194748] pci 0000:04:00.0: BAR 16: assigned [mem 0x94000000-0x97fffff=
f]
[    0.194756] pci 0000:04:00.0: BAR 13: assigned [io  0x3000-0x30ff]
[    0.194763] pci 0000:04:00.0: BAR 14: assigned [io  0x3400-0x34ff]
[    0.194771] pci 0000:04:00.0: CardBus bridge to [bus 05-06]
[    0.194778] pci 0000:04:00.0:   bridge window [io  0x3000-0x30ff]
[    0.194789] pci 0000:04:00.0:   bridge window [io  0x3400-0x34ff]
[    0.194800] pci 0000:04:00.0:   bridge window [mem 0xc8000000-0xcbffffff=
 pref]
[    0.194813] pci 0000:04:00.0:   bridge window [mem 0x94000000-0x97ffffff]
[    0.194824] pci 0000:00:1e.0: PCI bridge to [bus 04-07]
[    0.194832] pci 0000:00:1e.0:   bridge window [io  0x3000-0x6fff]
[    0.194843] pci 0000:00:1e.0:   bridge window [mem 0x90300000-0x9fffffff]
[    0.194853] pci 0000:00:1e.0:   bridge window [mem 0xc8000000-0xcfffffff=
 64bit pref]
[    0.194901] pci 0000:00:1e.0: setting latency timer to 64
[    0.194919] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.194923] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.194926] pci_bus 0000:02: resource 0 [io  0x7000-0x7fff]
[    0.194929] pci_bus 0000:02: resource 1 [mem 0x90100000-0x901fffff]
[    0.194932] pci_bus 0000:02: resource 2 [mem 0x60000000-0x601fffff 64bit=
 pref]
[    0.194935] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.194938] pci_bus 0000:03: resource 1 [mem 0x90200000-0x902fffff]
[    0.194942] pci_bus 0000:03: resource 2 [mem 0xc0000000-0xc00fffff 64bit=
 pref]
[    0.194945] pci_bus 0000:04: resource 0 [io  0x3000-0x6fff]
[    0.194948] pci_bus 0000:04: resource 1 [mem 0x90300000-0x9fffffff]
[    0.194951] pci_bus 0000:04: resource 2 [mem 0xc8000000-0xcfffffff 64bit=
 pref]
[    0.194954] pci_bus 0000:04: resource 4 [io  0x0000-0xffff]
[    0.194957] pci_bus 0000:04: resource 5 [mem 0x00000000-0xffffffff]
[    0.194960] pci_bus 0000:05: resource 0 [io  0x3000-0x30ff]
[    0.194963] pci_bus 0000:05: resource 1 [io  0x3400-0x34ff]
[    0.194966] pci_bus 0000:05: resource 2 [mem 0xc8000000-0xcbffffff pref]
[    0.194969] pci_bus 0000:05: resource 3 [mem 0x94000000-0x97ffffff]
[    0.195019] NET: Registered protocol family 2
[    0.195228] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.196209] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.196895] TCP: Hash tables configured (established 131072 bind 65536)
[    0.196964] TCP: reno registered
[    0.196974] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.197002] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.197152] NET: Registered protocol family 1
[    0.197186] pci 0000:00:02.0: Boot video device
[    0.197211] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.197250] pci 0000:00:1d.1: power state changed by ACPI to D0
[    0.197401] PCI: CLS 32 bytes, default 64
[    0.197484] Unpacking initramfs...
[    0.280539] Freeing initrd memory: 2832k freed
[    0.282775] Simple Boot Flag at 0x35 set to 0x1
[    0.282873] IBM machine detected. Enabling interrupts during APM calls.
[    0.282886] apm: BIOS not found.
[    0.283251] audit: initializing netlink socket (disabled)
[    0.283279] type=3D2000 audit(1361200797.279:1): initialized
[    0.296514] bounce pool size: 64 pages
[    0.296534] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.298942] VFS: Disk quotas dquot_6.5.2
[    0.299017] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.299213] msgmni has been set to 1729
[    0.299478] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    0.299514] io scheduler noop registered
[    0.299520] io scheduler deadline registered
[    0.299532] io scheduler cfq registered (default)
[    0.299703] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.299837] pcieport 0000:00:1c.2: irq 41 for MSI/MSI-X
[    0.300039] vesafb: mode is 1024x768x32, linelength=3D4096, pages=3D0
[    0.300046] vesafb: scrolling: redraw
[    0.300052] vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    0.300254] vesafb: framebuffer at 0xb0000000, mapped to 0xf8080000, usi=
ng 3072k, total 3072k
[    0.330264] Console: switching to colour frame buffer device 128x48
[    0.360485] fb0: VESA VGA frame buffer device
[    0.360750] intel_idle: does not run on family 6 model 13
[    0.360784] GHES: HEST is not enabled!
[    0.361012] isapnp: Scanning for PnP cards...
[    0.674378] isapnp: No Plug & Play device found
[    0.674686] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.675428] serial 00:09: [io  0x03f8-0x03ff]
[    0.675486] serial 00:09: [irq 4]
[    0.675887] serial 00:09: activated
[    0.676234] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a NS16550A
[    0.676866] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    0.684988] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.685313] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.685700] mousedev: PS/2 mouse device common for all mice
[    0.686102] rtc_cmos 00:06: RTC can wake from S4
[    0.686519] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.686923] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.687341] cpuidle: using governor ladder
[    0.687574] cpuidle: using governor menu
[    0.687934] drop_monitor: Initializing network drop monitor service
[    0.688436] TCP: cubic registered
[    0.688817] NET: Registered protocol family 10
[    0.689305] NET: Registered protocol family 17
[    0.689647] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    0.690538] Key type dns_resolver registered
[    0.690916] Using IPI No-Shortcut mode
[    0.702593] PM: Checking hibernation image partition /dev/sda1
[    0.705127] PM: Hibernation image not present or could not be loaded.
[    0.705141] registered taskstats version 1
[    0.717320]   Magic number: 1:190:336
[    0.728964] tty tty57: hash matches
[    0.740616] rtc_cmos 00:06: setting system clock to 2013-02-18 15:19:58 =
UTC (1361200798)
[    0.752732] Freeing unused kernel memory: 548k freed
[    0.764952] Write protecting the kernel text: 4032k
[    0.776824] Write protecting the kernel read-only data: 1232k
[    0.816790] systemd-udevd[36]: starting version 197
[    0.901068] ACPI: bus type usb registered
[    0.926822] SCSI subsystem initialized
[    0.964790] usbcore: registered new interface driver usbfs
[    0.979422] ACPI: bus type scsi registered
[    0.990839] usbcore: registered new interface driver hub
[    1.002382] usbcore: registered new device driver usb
[    1.013763] libata version 3.00 loaded.
[    1.014573] ahci 0000:00:1f.2: version 3.0
[    1.014601] ahci: probe of 0000:00:1f.2 failed with error -22
[    1.027106] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.039317] uhci_hcd: USB Universal Host Controller Interface driver
[    1.053569] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.053575] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.065731] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 1
[    1.081281] ehci_hcd 0000:00:1d.7: debug port 1
[    1.092611] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.092638] ehci_hcd 0000:00:1d.7: irq 19, io mem 0x90040000
[    1.113356] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.124771] hub 1-0:1.0: USB hub found
[    1.135841] hub 1-0:1.0: 8 ports detected
[    1.146965] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.146970] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.158936] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[    1.170181] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
[    1.182086] hub 2-0:1.0: USB hub found
[    1.193081] hub 2-0:1.0: 2 ports detected
[    1.203913] ata_piix 0000:00:1f.2: version 2.13
[    1.203926] ata_piix 0000:00:1f.2: MAP [
[    1.214479]  P0 P2 IDE IDE ]
[    1.283352] tsc: Refined TSC clocksource calibration: 1862.120 MHz
[    1.294184] Switching to clocksource tsc
[    1.376683] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.377327] scsi0 : ata_piix
[    1.388376] scsi1 : ata_piix
[    1.399085] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq=
 14
[    1.409910] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq=
 15
[    1.420696] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.420701] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.431585] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 3
[    1.442301] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
[    1.453744] hub 3-0:1.0: USB hub found
[    1.464541] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.475377] hub 3-0:1.0: 2 ports detected
[    1.486257] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.486262] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.497023] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 4
[    1.507997] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
[    1.520422] hub 4-0:1.0: USB hub found
[    1.531202] hub 4-0:1.0: 2 ports detected
[    1.542262] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.542267] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.552709] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus =
number 5
[    1.563245] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
[    1.574200] hub 5-0:1.0: USB hub found
[    1.585064] hub 5-0:1.0: 2 ports detected
[    1.595479] ata1.00: ATA-6: HTS548040M9AT00, MG2OA5BA, max UDMA/100
[    1.606638] ata1.00: 78140160 sectors, multi 16: LBA=20
[    1.617160] ata1.00: applying bridge limits
[    1.627790] ata2.00: ATAPI: HL-DT-STCD-RW/DVD DRIVE GCC-4242N, 0J05, max=
 UDMA/33
[    1.639451] hub 1-1:1.0: USB hub found
[    1.650634] ata1.00: configured for UDMA/100
[    1.661539] hub 1-1:1.0: 4 ports detected
[    1.672418] ata2.00: configured for UDMA/33
[    1.683137] scsi 0:0:0:0: Direct-Access     ATA      HTS548040M9AT00  MG=
2O PQ: 0 ANSI: 5
[    1.710674] scsi 1:0:0:0: CD-ROM            HL-DT-ST RW/DVD GCC-4242N 0J=
05 PQ: 0 ANSI: 5
[    1.694525] ACPI: Invalid Power Resource to register!
[    1.733155] ACPI: Invalid Power Resource to register!
[    1.748928] sd 0:0:0:0: [sda] 78140160 512-byte logical blocks: (40.0 GB=
/37.2 GiB)
[    1.772323] sd 0:0:0:0: [sda] Write Protect is off
[    1.784020] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.784045] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.798273] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.810445] usb 1-4: new high-speed USB device number 3 using ehci_hcd
[    1.823021] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.835809] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.846487]  sda: sda1 sda2
[    1.859101] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.964092] Initializing USB Mass Storage driver...
[    1.976772] scsi2 : usb-storage 1-4:1.0
[    1.989454] usbcore: registered new interface driver usb-storage
[    2.002087] USB Mass Storage support registered.
[    2.413349] usb 4-2: new full-speed USB device number 2 using uhci_hcd
[    2.994061] scsi 2:0:0:0: Direct-Access     ST925031 5AS              02=
00 PQ: 0 ANSI: 4
[    3.009300] sd 2:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB=
/232 GiB)
[    3.029796] sd 2:0:0:0: [sdb] Write Protect is off
[    3.043068] sd 2:0:0:0: [sdb] Mode Sense: 38 00 00 00
[    3.050047] sd 2:0:0:0: [sdb] No Caching mode page present
[    3.063221] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    3.091296] sd 2:0:0:0: [sdb] No Caching mode page present
[    3.104427] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    4.877529]  sdb: sdb1 sdb3
[    4.942054] sd 2:0:0:0: [sdb] No Caching mode page present
[    4.955191] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    4.968339] sd 2:0:0:0: [sdb] Attached SCSI disk
[    4.994201] EXT4-fs (sda1): mounted filesystem with ordered data mode. O=
pts: (null)
[    6.403394] systemd[1]: systemd 197 running in system mode. (+PAM -LIBWR=
AP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    6.559879] systemd[1]: Set hostname to <onny>.
[    7.781534] systemd[1]: Cannot add dependency job for unit display-manag=
er.service, ignoring: Unit display-manager.service failed to load: No such =
file or directory. See system logs and 'systemctl status display-manager.se=
rvice' for details.
[    7.810561] systemd[1]: Starting Forward Password Requests to Wall Direc=
tory Watch.
[    7.825168] systemd[1]: Started Forward Password Requests to Wall Direct=
ory Watch.
[    7.839819] systemd[1]: Starting Remote File Systems.
[    7.869191] systemd[1]: Reached target Remote File Systems.
[    7.883859] systemd[1]: Starting Device-mapper event daemon FIFOs.
[    7.912608] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    7.927149] systemd[1]: Starting Delayed Shutdown Socket.
[    7.955345] systemd[1]: Listening on Delayed Shutdown Socket.
[    7.969374] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    7.997424] systemd[1]: Listening on /dev/initctl Compatibility Named Pi=
pe.
[    8.011422] systemd[1]: Starting LVM2 metadata daemon socket.
[    8.039372] systemd[1]: Listening on LVM2 metadata daemon socket.
[    8.053499] systemd[1]: Starting Dispatch Password Requests to Console D=
irectory Watch.
[    8.067845] systemd[1]: Started Dispatch Password Requests to Console Di=
rectory Watch.
[    8.082320] systemd[1]: Starting udev Kernel Socket.
[    8.110917] systemd[1]: Listening on udev Kernel Socket.
[    8.125252] systemd[1]: Starting udev Control Socket.
[    8.153873] systemd[1]: Listening on udev Control Socket.
[    8.168020] systemd[1]: Starting Encrypted Volumes.
[    8.195998] systemd[1]: Reached target Encrypted Volumes.
[    8.210134] systemd[1]: Starting Arbitrary Executable File Formats File =
System Automount Point.
[    8.239469] systemd[1]: Set up automount Arbitrary Executable File Forma=
ts File System Automount Point.
[    8.254476] systemd[1]: Expecting device dev-sda2.device...
[    8.284134] systemd[1]: Starting Journal Socket.
[    8.313921] systemd[1]: Listening on Journal Socket.
[    8.328852] systemd[1]: Started File System Check on Root Device.
[    8.343873] systemd[1]: Starting Remount Root and Kernel File Systems...
[    8.399956] systemd[1]: Mounting POSIX Message Queue File System...
[    8.525714] systemd[1]: Starting Apply Kernel Variables...
[    8.652768] systemd[1]: Starting Set Up Additional Binary Formats...
[    8.835624] EXT4-fs (sda1): re-mounted. Opts: data=3Dordered
[    8.923132] systemd[1]: Mounting Huge Pages File System...
[    8.956692] systemd[1]: Mounting Debug File System...
[    8.991177] systemd[1]: Starting udev Kernel Device Manager...
[    9.043008] systemd[1]: Starting udev Coldplug all Devices...
[    9.142117] systemd[1]: Starting Setup Virtual Console...
[    9.211935] systemd-udevd[111]: starting version 197
[    9.300417] systemd[1]: Started Load Kernel Modules.
[    9.314485] systemd[1]: Mounted FUSE Control File System.
[    9.328485] systemd[1]: Mounted Configuration File System.
[    9.342239] systemd[1]: Starting Journal Service...
[    9.655196] systemd[1]: Started Journal Service.
[    9.682276] systemd[1]: Started udev Kernel Device Manager.
[    9.709548] systemd[1]: Started Remount Root and Kernel File Systems.
[    9.736631] systemd[1]: Mounted POSIX Message Queue File System.
[    9.766972] systemd[1]: Started Apply Kernel Variables.
[    9.795701] systemd[1]: Mounted Huge Pages File System.
[    9.823933] systemd[1]: Mounted Debug File System.
[    9.843475] systemd[1]: Starting Local File Systems (Pre).
[    9.877624] systemd[1]: Reached target Local File Systems (Pre).
[    9.890716] systemd[1]: Mounting /tmp...
[   10.005983] systemd[1]: Starting Load Random Seed...
[   10.087604] systemd[1]: Mounted /tmp.
[   10.100412] systemd[1]: Starting Local File Systems.
[   10.125874] systemd[1]: Reached target Local File Systems.
[   10.138536] systemd[1]: Starting Trigger Flushing of Journal to Persiste=
nt Storage...
[   10.257142] systemd[1]: Starting Recreate Volatile Files and Directories=
=2E..
[   10.890333] systemd-journald[117]: Received SIGUSR1
[   12.922087] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input1
[   12.936807] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   12.951574] ACPI: AC Adapter [AC] (on-line)
[   12.967876] thermal LNXTHERM:00: registered as thermal_zone0
[   12.982991] ACPI: Thermal Zone [THM0] (62 C)
[   12.996527] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/LNXVIDEO:00/input/input2
[   13.010837] ACPI: Lid Switch [LID]
[   13.024566] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input3
[   13.040438] ACPI: Sleep Button [SLPB]
[   13.055110] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input4
[   13.076717] ACPI: Power Button [PWRF]
[   13.091784] ACPI: Battery Slot [BAT0] (battery present)
[   13.160746] ACPI: Requesting acpi_cpufreq
[   13.193595] intel_rng: FWH not detected
[   13.244600] tsc: Marking TSC unstable due to TSC halts in idle
[   13.259408] ACPI: acpi_idle registered with cpuidle
[   13.261232] Switching to clocksource hpet
[   13.311635] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   13.472965] P-state transition latency capped at 20 uS
[   13.487858] yenta_cardbus 0000:04:00.0: CardBus bridge found [1014:0528]
[   13.502280] yenta_cardbus 0000:04:00.0: Using INTVAL to route CSC interr=
upts to PCI
[   13.516710] yenta_cardbus 0000:04:00.0: Routing CardBus interrupts to PCI
[   13.530624] yenta_cardbus 0000:04:00.0: TI: mfunc 0x01d21002, devctl 0x64
[   13.672509] microcode: CPU0 sig=3D0x6d8, pf=3D0x20, revision=3D0x20
[   13.705075] tg3.c:v3.124 (March 21, 2012)
[   13.722637] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[   13.748998] Linux agpgart interface v0.103
[   13.776474] Non-volatile memory driver v1.3
[   13.791387] yenta_cardbus 0000:04:00.0: ISA IRQ mask 0x0cf8, PCI irq 16
[   13.807001] gpio_ich: ACPI BAR is busy, GPI 0 - 15 unavailable
[   13.824513] parport_pc 00:0a: reported by Plug and Play ACPI
[   13.846695] yenta_cardbus 0000:04:00.0: Socket status: 30000007
[   13.862067] parport0: PC-style at 0x3bc, irq 7 [PCSPP,TRISTATE]
[   13.877952] gpio_ich: GPIO from 206 to 255 on gpio_ich
[   13.893883] ppdev: user-space parallel port driver
[   13.909551] iTCO_vendor_support: vendor-support=3D0
[   13.928233] cfg80211: Calling CRDA to update world regulatory domain
[   13.946223] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge window=
: [io  0x3000-0x6fff]
[   13.967569] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   13.982019] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   13.997792] lib80211: common routines for IEEE802.11 drivers
[   14.015573] lib80211_crypt: registered algorithm 'NULL'
[   14.016775] thinkpad_acpi: http://ibm-acpi.sf.net/
[   14.031773] [drm] Initialized drm 1.1.0 20060810
[   14.050113] thinkpad_acpi: ThinkPad BIOS 70ET69WW (1.29 ), EC 70HT28WW-1=
=2E05
[   14.072317] thinkpad_acpi: IBM ThinkPad T43, model 1871F1G
[   14.094661] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   14.109454] iTCO_wdt: Found a ICH6-M TCO device (Version=3D2, TCOBASE=3D=
0x1060)
[   14.131789] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3000-0x6ff=
f:
[   14.148209] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[   14.164030] libipw: 802.11 data/management/control stack, git-1.1.13
[   14.180241] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total=
, 262144K mappable
[   14.196111] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is b=
locked
[   14.211077] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM95751M) rev 4101] =
(PCI Express) MAC address 00:16:41:10:c2:72
[   14.226345] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@=
linux.intel.com>
[   14.244891] Registered led device: tpacpi::thinklight
[   14.245213] Registered led device: tpacpi::power
[   14.245519] Registered led device: tpacpi::standby
[   14.248009] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[   14.263481] tg3 0000:02:00.0: eth0: attached PHY is 5750 (10/100/1000Bas=
e-T Ethernet) (WireSpeed[1], EEE[0])
[   14.290874] thinkpad_acpi: Console audio control enabled, mode: monitor =
(read only)
[   14.303439] thinkpad_acpi: fan_init: initial fan status is unknown, assu=
ming it is in auto mode
[   14.304438] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_=
acpi/input/input6
[   14.328808] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xb0000000
[   14.333431] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] AS=
F[0] TSOcap[1]
[   14.333434] tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[   14.336759] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[   14.336760] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[   14.341076] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   14.366959] checking generic (b0000000 300000) vs hw (b0000000 10000000)
[   14.366960] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removin=
g generic driver
[   14.246551]  excluding 0x3000-0x30ff 0x3400-0x34ff
[   14.376256] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge window=
: [mem 0x90300000-0x9fffffff]
[   14.376260] pcmcia_socket pcmcia_socket0: cs: memory probe 0x90300000-0x=
9fffffff:
[   14.376262]  excluding
[   14.376263]  0x90300000-0x90afffff
[   14.376270]  0x93b00000-0x982fffff
[   14.376280]  0x9fb00000-0xa02fffff

[   14.376283] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge window=
: [mem 0xc8000000-0xcfffffff 64bit pref]
[   14.376286] pcmcia_socket pcmcia_socket0: cs: memory probe 0xc8000000-0x=
cfffffff:
[   14.376296]  excluding
[   14.376296]  0xc8000000-0xcfffffff

[   14.392842] ipw2100: Detected Intel PRO/Wireless 2100 Network Connection
[   14.658946] Console: switching to colour dummy device 80x25
[   14.659522] i915 0000:00:02.0: setting latency timer to 64
[   14.661128] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   14.661140] [drm] Driver supports precise vblank timestamp query.
[   14.686729] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[   14.696969] i915: fixme: max PWM is zero
[   14.912219] psmouse serio1: synaptics: Touchpad model: 1, fw: 5.9, id: 0=
x2c6ab1, caps: 0x884793/0x0/0x0, board id: 71, fw id: 4797594
[   14.912264] psmouse serio1: synaptics: serio: Synaptics pass-through por=
t at isa0060/serio1/input0
[   14.956847] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input7
[   14.985491] [drm] initialized overlay support
[   15.215511] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af:
[   15.217188]  excluding 0x170-0x177 0x1f0-0x1f7 0x370-0x377
[   15.218013] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff:
[   15.218412]  excluding 0x3f0-0x3ff 0x4d0-0x4d7
[   15.218810] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff:
[   15.219558]  clean.
[   15.219618] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7:
[   15.221552]  clean.
[   15.221625] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0f=
ffff:
[   15.221650]  excluding 0xc0000-0xcffff 0xdc000-0xfffff
[   15.221731] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0x=
a0ffffff:
[   15.221781]  clean.
[   15.221836] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x=
60ffffff:
[   15.221860]  excluding 0x60000000-0x602fffff
[   15.221941] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff:
[   15.222829]  clean.
[   15.260560] fbcon: inteldrmfb (fb0) is primary device
[   15.306715] Console: switching to colour frame buffer device 128x48
[   15.318861] fb0: inteldrmfb frame buffer device
[   15.318948] drm: registered panic notifier
[   15.319038] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   15.319279] snd_intel8x0 0000:00:1e.2: setting latency timer to 64
[   16.243455] intel8x0_measure_ac97_clock: measured 52708 usecs (2540 samp=
les)
[   16.243727] intel8x0: clocking to 48000
[   16.317856] Adding 2048380k swap on /dev/sda2.  Priority:-1 extents:1 ac=
ross:2048380k=20
[   17.475032] psmouse serio2: hgpk: ID: 10 00 64
[   20.944810] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, b=
uttons: 3/3
[   21.178704] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/serio2/input/input8
[   25.826156] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   31.412353] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   34.556219] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   34.947150] pcieport 0000:00:1c.0: wake-up capability enabled by ACPI
[   35.132573] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   35.184249] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   38.533400] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   39.472900] lib80211_crypt: registered algorithm 'CCMP'

--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg_good_kernel
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-35-bisect (root@playground_32) (gcc vers=
ion 4.7.2 (GCC) ) #1 SMP PREEMPT Mon Feb 18 14:43:05 UTC 2013
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000005f6dffff] usable
[    0.000000] BIOS-e820: [mem 0x000000005f6e0000-0x000000005f6f4fff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x000000005f6f5000-0x000000005f6fffff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x000000005f700000-0x000000005fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000f0008000-0x00000000f000bfff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed20000-0x00000000fed8ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI present.
[    0.000000] DMI: IBM 1871F1G/1871F1G, BIOS 70ET69WW (1.29 ) 05/29/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x5f6e0 max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 base 05F700000 mask FFFF00000 uncachable
[    0.000000]   3 base 05F800000 mask FFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x377fdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x373fffff] page 2M
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x377fdfff @ [mem 0x01bfa=
000-0x01bfffff]
[    0.000000] RAMDISK: [mem 0x37a68000-0x37d2bfff]
[    0.000000] Allocated new RAMDISK: [mem 0x3753a000-0x377fd447]
[    0.000000] Move RAMDISK from [mem 0x37a68000-0x37d2b447] to [mem 0x3753=
a000-0x377fd447]
[    0.000000] ACPI: RSDP 000f6b90 00024 (v02 IBM   )
[    0.000000] ACPI: XSDT 5f6e71d4 00064 (v01 DELL    M09     00001290  LTP=
 00000000)
[    0.000000] ACPI: FACP 5f6e7300 000F4 (v03 DELL    M09     00001290 IBM =
 00000001)
[    0.000000] ACPI BIOS Bug: Warning: 32/64X length mismatch in FADT/Gpe1B=
lock: 0/32 (20120711/tbfadt-567)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Gpe1Block has ze=
ro address or length: 0x000000000000102C/0x0 (20120711/tbfadt-598)
[    0.000000] ACPI: DSDT 5f6e74e7 0D7A8 (v01 DELL    M09     00001290 MSFT=
 0100000E)
[    0.000000] ACPI: FACS 5f6f6000 00040
[    0.000000] ACPI: SSDT 5f6e74b4 00033 (v01 DELL    M09     00001290 MSFT=
 0100000E)
[    0.000000] ACPI: ECDT 5f6f4c8f 00052 (v01 DELL    M09     00001290 IBM =
 00000001)
[    0.000000] ACPI: TCPA 5f6f4ce1 00032 (v01 DELL    M09     00001290 PTL =
 00000001)
[    0.000000] ACPI: APIC 5f6f4d13 0005A (v01 DELL    M09     00001290 IBM =
 00000001)
[    0.000000] ACPI: MCFG 5f6f4d6d 0003E (v01 DELL    M09     00001290 IBM =
 00000001)
[    0.000000] ACPI: SLIC 5f6f4dab 00176 (v01 DELL    M09     00001290 ASL =
 00000061)
[    0.000000] ACPI: BOOT 5f6f4fd8 00028 (v01 DELL    M09     00001290  LTP=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 638MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x5f6dffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x5f6dffff]
[    0.000000] On node 0 totalpages: 390767
[    0.000000] free_area_init_node: node 0, pgdat c1574a40, node_mem_map f6=
949200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1278 pages used for memmap
[    0.000000]   HighMem zone: 162276 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 00000000001=
00000
[    0.000000] e820: [mem 0x60000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @f6933000 s32320 r0 d20928 u53=
248
[    0.000000] pcpu-alloc: s32320 r0 d20928 u53248 alloc=3D13*4096
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 387713
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-linux-bisect=
 root=3DUUID=3D89b7a62a-2ab6-4c47-8158-67f559a5bd97 ro init=3D/bin/systemd =
resume=3D/dev/sda1
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] allocated 3126912 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:0005f6e0)
[    0.000000] Memory: 1536908k/1563520k available (4028k kernel code, 2616=
0k reserved, 1615k data, 548k init, 654216k highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc1583000 - 0xc160c000   ( 548 kB)
      .data : 0xc13ef036 - 0xc1583000   (1615 kB)
      .text : 0xc1000000 - 0xc13ef036   (4028 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cpu_ids=3D1.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Df6008000 soft=3Df600a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1862.199 MHz processor
[    0.003335] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 3725.58 BogoMIPS (lpj=3D6207330)
[    0.003348] pid_max: default: 32768 minimum: 301
[    0.003389] Security Framework initialized
[    0.003405] AppArmor: AppArmor disabled by boot time parameter
[    0.003431] Mount-cache hash table entries: 512
[    0.003721] Initializing cgroup subsys cpuacct
[    0.003728] Initializing cgroup subsys memory
[    0.003743] Initializing cgroup subsys devices
[    0.003749] Initializing cgroup subsys freezer
[    0.003755] Initializing cgroup subsys net_cls
[    0.003761] Initializing cgroup subsys blkio
[    0.003796] Disabled fast string operations
[    0.003807] mce: CPU supports 5 MCE banks
[    0.003820] CPU0: Thermal monitoring enabled (TM2)
[    0.003838] Last level iTLB entries: 4KB 128, 2MB 0, 4MB 2
Last level dTLB entries: 4KB 128, 2MB 0, 4MB 8
tlb_flushall_shift is 0x6
[    0.003926] SMP alternatives: switching to UP code
[    0.010714] Freeing SMP alternatives: 16k freed
[    0.010725] ACPI: Core revision 20120711
[    0.020011] ftrace: allocating 17441 entries in 35 pages
[    0.030067] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.030523] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.065863] smpboot: CPU0: Intel(R) Pentium(R) M processor 1.86GHz stepp=
ing 08
[    0.066662] Performance Events: p6 PMU driver.
[    0.066662] ... version:                0
[    0.066662] ... bit width:              32
[    0.066662] ... generic registers:      2
[    0.066662] ... value mask:             00000000ffffffff
[    0.066662] ... max period:             000000007fffffff
[    0.066662] ... fixed-purpose events:   0
[    0.066662] ... event mask:             0000000000000003
[    0.090472] NMI watchdog: enabled on all CPUs, permanently consumes one =
hw-PMU counter.
[    0.090516] Brought up 1 CPUs
[    0.090522] smpboot: Total of 1 processors activated (3725.58 BogoMIPS)
[    0.091881] devtmpfs: initialized
[    0.092168] PM: Registering ACPI NVS region [mem 0x5f6f5000-0x5f6fffff] =
(45056 bytes)
[    0.093406] RTC time: 15:50:10, date: 02/18/13
[    0.093469] NET: Registered protocol family 16
[    0.093687] ACPI: bus type pci registered
[    0.093776] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    0.093787] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.093794] PCI: Using MMCONFIG for extended config space
[    0.093799] PCI: Using configuration type 1 for base access
[    0.094517] bio: create slab <bio-0> at 0
[    0.094595] ACPI: Added _OSI(Module Device)
[    0.094601] ACPI: Added _OSI(Processor Device)
[    0.094607] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.094613] ACPI: Added _OSI(Processor Aggregator Device)
[    0.096569] ACPI: EC: EC description table is found, configuring boot EC
[    0.107911] ACPI: Interpreter enabled
[    0.107922] ACPI: (supports S0 S3 S4 S5)
[    0.107946] ACPI: Using IOAPIC for interrupt routing
[    0.110690] ACPI: Power Resource [PUBS] (on)
[    0.113929] ACPI: EC: GPE =3D 0x1c, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.117336] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.117347] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.117381] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.117417] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.117420] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.117423] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.117427] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x00=
0d3fff] (ignored)
[    0.117430] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x00=
0d7fff] (ignored)
[    0.117433] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x00=
0dbfff] (ignored)
[    0.117437] pci_root PNP0A08:00: host bridge window [mem 0x60000000-0xfe=
bfffff] (ignored)
[    0.117439] PCI: root bus 00: using default resources
[    0.117482] PCI host bridge to bus 0000:00
[    0.117491] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    0.117494] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.117502] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.117509] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
f]
[    0.117526] pci 0000:00:00.0: [8086:2590] type 00 class 0x060000
[    0.117573] pci 0000:00:02.0: [8086:2592] type 00 class 0x030000
[    0.117583] pci 0000:00:02.0: reg 10: [mem 0x90080000-0x900fffff]
[    0.117590] pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
[    0.117596] pci 0000:00:02.0: reg 18: [mem 0xb0000000-0xbfffffff pref]
[    0.117603] pci 0000:00:02.0: reg 1c: [mem 0x90000000-0x9003ffff]
[    0.117637] pci 0000:00:02.1: [8086:2792] type 00 class 0x038000
[    0.117646] pci 0000:00:02.1: reg 10: [mem 0x00000000-0x0007ffff]
[    0.117737] pci 0000:00:1c.0: [8086:2660] type 01 class 0x060400
[    0.117840] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.117875] pci 0000:00:1c.2: [8086:2664] type 01 class 0x060400
[    0.117978] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.118014] pci 0000:00:1d.0: [8086:2658] type 00 class 0x0c0300
[    0.118066] pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
[    0.118108] pci 0000:00:1d.1: [8086:2659] type 00 class 0x0c0300
[    0.118160] pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
[    0.118202] pci 0000:00:1d.2: [8086:265a] type 00 class 0x0c0300
[    0.118256] pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
[    0.118298] pci 0000:00:1d.3: [8086:265b] type 00 class 0x0c0300
[    0.118350] pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
[    0.118402] pci 0000:00:1d.7: [8086:265c] type 00 class 0x0c0320
[    0.118424] pci 0000:00:1d.7: reg 10: [mem 0x90040000-0x900403ff]
[    0.118526] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.118551] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.118640] pci 0000:00:1e.2: [8086:266e] type 00 class 0x040100
[    0.118658] pci 0000:00:1e.2: reg 10: [io  0x1c00-0x1cff]
[    0.118671] pci 0000:00:1e.2: reg 14: [io  0x18c0-0x18ff]
[    0.118683] pci 0000:00:1e.2: reg 18: [mem 0x90040800-0x900409ff]
[    0.118695] pci 0000:00:1e.2: reg 1c: [mem 0x90040400-0x900404ff]
[    0.118756] pci 0000:00:1e.2: PME# supported from D0 D3hot D3cold
[    0.118783] pci 0000:00:1f.0: [8086:2641] type 00 class 0x060100
[    0.118891] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.118900] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6=
 ACPI/GPIO/TCO
[    0.118913] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6=
 GPIO
[    0.118923] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 1600-167f
[    0.118933] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 15e0-15ef
[    0.118965] pci 0000:00:1f.2: [8086:2653] type 00 class 0x010180
[    0.118983] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.118995] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.119007] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.119019] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.119031] pci 0000:00:1f.2: reg 20: [io  0x1810-0x181f]
[    0.119084] pci 0000:00:1f.2: PME# supported from D3hot
[    0.119104] pci 0000:00:1f.3: [8086:266a] type 00 class 0x0c0500
[    0.119173] pci 0000:00:1f.3: reg 20: [io  0x18a0-0x18bf]
[    0.119275] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 0=
0-ff]
[    0.119308] pci 0000:02:00.0: [14e4:167d] type 00 class 0x020000
[    0.119337] pci 0000:02:00.0: reg 10: [mem 0x90100000-0x9010ffff 64bit]
[    0.119498] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.119524] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'
[    0.119545] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.119558] pci 0000:00:1c.0:   bridge window [mem 0x90100000-0x901fffff]
[    0.119618] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 0=
0-ff]
[    0.119623] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.119632] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.119638] pci 0000:00:1c.2:   bridge window [mem 0x90200000-0x902fffff]
[    0.119646] pci 0000:00:1c.2:   bridge window [mem 0xc0000000-0xc00fffff=
 64bit pref]
[    0.119677] pci_bus 0000:04: busn_res: [bus 04-07] is inserted under [bu=
s 00-ff]
[    0.119695] pci 0000:04:00.0: [104c:ac56] type 02 class 0x060700
[    0.119721] pci 0000:04:00.0: reg 10: [mem 0x90300000-0x90300fff]
[    0.119767] pci 0000:04:00.0: supports D1 D2
[    0.119770] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119801] pci 0000:04:02.0: [8086:1043] type 00 class 0x028000
[    0.119826] pci 0000:04:02.0: reg 10: [mem 0x90301000-0x90301fff]
[    0.120044] pci 0000:00:1e.0: PCI bridge to [bus 04-07] (subtractive dec=
ode)
[    0.120055] pci 0000:00:1e.0:   bridge window [io  0x3000-0x6fff]
[    0.120060] pci 0000:00:1e.0:   bridge window [mem 0x90300000-0x9fffffff]
[    0.120068] pci 0000:00:1e.0:   bridge window [mem 0xc8000000-0xcfffffff=
 64bit pref]
[    0.120072] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtr=
active decode)
[    0.120075] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff=
] (subtractive decode)
[    0.120125] pci_bus 0000:05: busn_res: can not insert [bus 05-ff] under =
[bus 04-07] (conflicts with (null) [bus 04-07])
[    0.120131] pci_bus 0000:05: busn_res: [bus 05-ff] end is updated to 06
[    0.120134] pci_bus 0000:05: busn_res: [bus 05-06] is inserted under [bu=
s 04-07]
[    0.120159] pci_bus 0000:00: on NUMA node 0
[    0.120163] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.120260] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.120301] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.120346] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.120433]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    0.120443]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.124107] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124203] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124297] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124390] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124483] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124576] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124669] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124762] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.124865] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.124880] vgaarb: loaded
[    0.124885] vgaarb: bridge control possible 0000:00:02.0
[    0.124939] PCI: Using ACPI for IRQ routing
[    0.134749] PCI: pci_cache_line_size set to 64 bytes
[    0.134822] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.134825] e820: reserve RAM buffer [mem 0x5f6e0000-0x5fffffff]
[    0.134955] NetLabel: Initializing
[    0.134961] NetLabel:  domain hash size =3D 128
[    0.134966] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.134986] NetLabel:  unlabeled traffic allowed by default
[    0.135149] hpet clockevent registered
[    0.135153] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.135164] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.135174] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.146675] Switching to clocksource hpet
[    0.155077] pnp: PnP ACPI init
[    0.155122] ACPI: bus type pnp registered
[    0.155658] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.155662] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.155665] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.155668] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.155671] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.155674] pnp 00:00: [mem 0x000d0000-0x000cffff disabled]
[    0.155677] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.155680] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.155683] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.155685] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.155688] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.155691] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.155694] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.155696] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.155699] pnp 00:00: [mem 0x00100000-0x5fffffff]
[    0.155702] pnp 00:00: [mem 0xfec00000-0xffffffff]
[    0.155784] system 00:00: [mem 0x00000000-0x0009ffff] could not be reser=
ved
[    0.155794] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reser=
ved
[    0.155802] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reser=
ved
[    0.155811] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.155818] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.155827] system 00:00: [mem 0x000dc000-0x000dffff] could not be reser=
ved
[    0.155835] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reser=
ved
[    0.155843] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reser=
ved
[    0.155851] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reser=
ved
[    0.155859] system 00:00: [mem 0x000ec000-0x000effff] could not be reser=
ved
[    0.155867] system 00:00: [mem 0x000f0000-0x000fffff] could not be reser=
ved
[    0.155875] system 00:00: [mem 0x00100000-0x5fffffff] could not be reser=
ved
[    0.155884] system 00:00: [mem 0xfec00000-0xffffffff] could not be reser=
ved
[    0.155894] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.155926] pnp 00:01: [bus 00-ff]
[    0.155930] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.155933] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.155936] pnp 00:01: [io  0x0d00-0xffff window]
[    0.155939] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.155942] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.155945] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.155948] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.155951] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.155954] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.155957] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.155960] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.155962] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.155965] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.155968] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.155971] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.155974] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.155977] pnp 00:01: [mem 0x60000000-0xfebfffff window]
[    0.156042] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.156065] pnp 00:02: [io  0x0010-0x001f]
[    0.156068] pnp 00:02: [io  0x0090-0x009f]
[    0.156071] pnp 00:02: [io  0x0024-0x0025]
[    0.156074] pnp 00:02: [io  0x0028-0x0029]
[    0.156076] pnp 00:02: [io  0x002c-0x002d]
[    0.156079] pnp 00:02: [io  0x0030-0x0031]
[    0.156082] pnp 00:02: [io  0x0034-0x0035]
[    0.156084] pnp 00:02: [io  0x0038-0x0039]
[    0.156087] pnp 00:02: [io  0x003c-0x003d]
[    0.156089] pnp 00:02: [io  0x00a4-0x00a5]
[    0.156092] pnp 00:02: [io  0x00a8-0x00a9]
[    0.156095] pnp 00:02: [io  0x00ac-0x00ad]
[    0.156097] pnp 00:02: [io  0x00b0-0x00b5]
[    0.156100] pnp 00:02: [io  0x00b8-0x00b9]
[    0.156103] pnp 00:02: [io  0x00bc-0x00bd]
[    0.156105] pnp 00:02: [io  0x0050-0x0053]
[    0.156108] pnp 00:02: [io  0x0072-0x0077]
[    0.156111] pnp 00:02: [io  0x002e-0x002f]
[    0.156113] pnp 00:02: [io  0x1000-0x107f]
[    0.156116] pnp 00:02: [io  0x1180-0x11bf]
[    0.156119] pnp 00:02: [io  0x15e0-0x15ef]
[    0.156121] pnp 00:02: [io  0x1600-0x1641]
[    0.156124] pnp 00:02: [io  0x1644-0x167f]
[    0.156127] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    0.156130] pnp 00:02: [mem 0xf0008000-0xf000bfff]
[    0.156133] pnp 00:02: [mem 0xfed14000-0xfed17fff]
[    0.156135] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.156138] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.156217] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.156226] system 00:02: [io  0x1180-0x11bf] has been reserved
[    0.156233] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.156241] system 00:02: [io  0x1600-0x1641] has been reserved
[    0.156248] system 00:02: [io  0x1644-0x167f] has been reserved
[    0.156256] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    0.156264] system 00:02: [mem 0xf0008000-0xf000bfff] has been reserved
[    0.156272] system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.156280] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.156289] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.156297] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.156313] pnp 00:03: [io  0x0000-0x000f]
[    0.156316] pnp 00:03: [io  0x0080-0x008f]
[    0.156319] pnp 00:03: [io  0x00c0-0x00df]
[    0.156326] pnp 00:03: [dma 4]
[    0.156359] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.156371] pnp 00:04: [io  0x0061]
[    0.156404] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.156415] pnp 00:05: [io  0x00f0]
[    0.156431] pnp 00:05: [irq 13]
[    0.156465] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.156476] pnp 00:06: [io  0x0070-0x0071]
[    0.156483] pnp 00:06: [irq 8]
[    0.156521] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.156532] pnp 00:07: [io  0x0060]
[    0.156535] pnp 00:07: [io  0x0064]
[    0.156541] pnp 00:07: [irq 1]
[    0.156575] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.156589] pnp 00:08: [irq 12]
[    0.156624] pnp 00:08: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (a=
ctive)
[    0.156786] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (disabled)
[    0.156901] pnp 00:0a: [io  0x03bc-0x03be]
[    0.156909] pnp 00:0a: [irq 7]
[    0.156991] pnp 00:0a: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.157117] pnp 00:0b: Plug and Play ACPI device, IDs NSC1100 (disabled)
[    0.157678] pnp: PnP ACPI: found 12 devices
[    0.157685] ACPI: ACPI bus type pnp unregistered
[    0.194558] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus =
02] add_size 1000
[    0.194564] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 6=
4bit pref] to [bus 02] add_size 200000
[    0.194599] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x000fffff 64bit=
 pref] get_res_add_size add_size 200000
[    0.194603] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x0fff] get_res_add_=
size add_size 1000
[    0.194610] pci 0000:00:1c.0: BAR 15: assigned [mem 0x60000000-0x601ffff=
f 64bit pref]
[    0.194622] pci 0000:00:02.1: BAR 0: assigned [mem 0x60200000-0x6027ffff]
[    0.194633] pci 0000:00:1c.0: BAR 13: assigned [io  0x7000-0x7fff]
[    0.194642] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.194650] pci 0000:00:1c.0:   bridge window [io  0x7000-0x7fff]
[    0.194661] pci 0000:00:1c.0:   bridge window [mem 0x90100000-0x901fffff]
[    0.194671] pci 0000:00:1c.0:   bridge window [mem 0x60000000-0x601fffff=
 64bit pref]
[    0.194686] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.194693] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.194705] pci 0000:00:1c.2:   bridge window [mem 0x90200000-0x902fffff]
[    0.194715] pci 0000:00:1c.2:   bridge window [mem 0xc0000000-0xc00fffff=
 64bit pref]
[    0.194732] pci 0000:04:00.0: res[15]=3D[mem 0x04000000-0x03ffffff pref]=
 get_res_add_size add_size 4000000
[    0.194735] pci 0000:04:00.0: res[16]=3D[mem 0x04000000-0x03ffffff] get_=
res_add_size add_size 4000000
[    0.194739] pci 0000:04:00.0: res[13]=3D[io  0x0100-0x00ff] get_res_add_=
size add_size 100
[    0.194742] pci 0000:04:00.0: res[14]=3D[io  0x0100-0x00ff] get_res_add_=
size add_size 100
[    0.194746] pci 0000:04:00.0: BAR 15: assigned [mem 0xc8000000-0xcbfffff=
f pref]
[    0.194755] pci 0000:04:00.0: BAR 16: assigned [mem 0x94000000-0x97fffff=
f]
[    0.194763] pci 0000:04:00.0: BAR 13: assigned [io  0x3000-0x30ff]
[    0.194771] pci 0000:04:00.0: BAR 14: assigned [io  0x3400-0x34ff]
[    0.194779] pci 0000:04:00.0: CardBus bridge to [bus 05-06]
[    0.194786] pci 0000:04:00.0:   bridge window [io  0x3000-0x30ff]
[    0.194797] pci 0000:04:00.0:   bridge window [io  0x3400-0x34ff]
[    0.194808] pci 0000:04:00.0:   bridge window [mem 0xc8000000-0xcbffffff=
 pref]
[    0.194820] pci 0000:04:00.0:   bridge window [mem 0x94000000-0x97ffffff]
[    0.194831] pci 0000:00:1e.0: PCI bridge to [bus 04-07]
[    0.194839] pci 0000:00:1e.0:   bridge window [io  0x3000-0x6fff]
[    0.194850] pci 0000:00:1e.0:   bridge window [mem 0x90300000-0x9fffffff]
[    0.194861] pci 0000:00:1e.0:   bridge window [mem 0xc8000000-0xcfffffff=
 64bit pref]
[    0.194909] pci 0000:00:1e.0: setting latency timer to 64
[    0.194927] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.194930] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.194933] pci_bus 0000:02: resource 0 [io  0x7000-0x7fff]
[    0.194936] pci_bus 0000:02: resource 1 [mem 0x90100000-0x901fffff]
[    0.194940] pci_bus 0000:02: resource 2 [mem 0x60000000-0x601fffff 64bit=
 pref]
[    0.194943] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.194946] pci_bus 0000:03: resource 1 [mem 0x90200000-0x902fffff]
[    0.194949] pci_bus 0000:03: resource 2 [mem 0xc0000000-0xc00fffff 64bit=
 pref]
[    0.194952] pci_bus 0000:04: resource 0 [io  0x3000-0x6fff]
[    0.194955] pci_bus 0000:04: resource 1 [mem 0x90300000-0x9fffffff]
[    0.194958] pci_bus 0000:04: resource 2 [mem 0xc8000000-0xcfffffff 64bit=
 pref]
[    0.194961] pci_bus 0000:04: resource 4 [io  0x0000-0xffff]
[    0.194964] pci_bus 0000:04: resource 5 [mem 0x00000000-0xffffffff]
[    0.194967] pci_bus 0000:05: resource 0 [io  0x3000-0x30ff]
[    0.194970] pci_bus 0000:05: resource 1 [io  0x3400-0x34ff]
[    0.194973] pci_bus 0000:05: resource 2 [mem 0xc8000000-0xcbffffff pref]
[    0.194976] pci_bus 0000:05: resource 3 [mem 0x94000000-0x97ffffff]
[    0.195027] NET: Registered protocol family 2
[    0.195236] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.196219] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.196908] TCP: Hash tables configured (established 131072 bind 65536)
[    0.196976] TCP: reno registered
[    0.196986] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.197014] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.197169] NET: Registered protocol family 1
[    0.197203] pci 0000:00:02.0: Boot video device
[    0.197228] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.197267] pci 0000:00:1d.1: power state changed by ACPI to D0
[    0.197417] PCI: CLS 32 bytes, default 64
[    0.197501] Unpacking initramfs...
[    0.280566] Freeing initrd memory: 2832k freed
[    0.282813] Simple Boot Flag at 0x35 set to 0x1
[    0.282909] IBM machine detected. Enabling interrupts during APM calls.
[    0.282922] apm: BIOS not found.
[    0.283287] audit: initializing netlink socket (disabled)
[    0.283314] type=3D2000 audit(1361202610.279:1): initialized
[    0.296554] bounce pool size: 64 pages
[    0.296574] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.298978] VFS: Disk quotas dquot_6.5.2
[    0.299054] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.299252] msgmni has been set to 1729
[    0.299517] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    0.299553] io scheduler noop registered
[    0.299559] io scheduler deadline registered
[    0.299571] io scheduler cfq registered (default)
[    0.299742] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.299875] pcieport 0000:00:1c.2: irq 41 for MSI/MSI-X
[    0.300078] vesafb: mode is 1024x768x32, linelength=3D4096, pages=3D0
[    0.300085] vesafb: scrolling: redraw
[    0.300091] vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    0.300294] vesafb: framebuffer at 0xb0000000, mapped to 0xf8080000, usi=
ng 3072k, total 3072k
[    0.330303] Console: switching to colour frame buffer device 128x48
[    0.360524] fb0: VESA VGA frame buffer device
[    0.360788] intel_idle: does not run on family 6 model 13
[    0.360821] GHES: HEST is not enabled!
[    0.361049] isapnp: Scanning for PnP cards...
[    0.674419] isapnp: No Plug & Play device found
[    0.674728] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.675469] serial 00:09: [io  0x03f8-0x03ff]
[    0.675527] serial 00:09: [irq 4]
[    0.675927] serial 00:09: activated
[    0.676273] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a NS16550A
[    0.676904] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    0.683522] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.683848] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.684235] mousedev: PS/2 mouse device common for all mice
[    0.684637] rtc_cmos 00:06: RTC can wake from S4
[    0.685054] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.685444] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.685861] cpuidle: using governor ladder
[    0.686094] cpuidle: using governor menu
[    0.686452] drop_monitor: Initializing network drop monitor service
[    0.686970] TCP: cubic registered
[    0.687337] NET: Registered protocol family 10
[    0.687823] NET: Registered protocol family 17
[    0.688103] Key type dns_resolver registered
[    0.688481] Using IPI No-Shortcut mode
[    0.688773] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    0.700458] PM: Checking hibernation image partition /dev/sda1
[    0.700474] PM: Hibernation image not present or could not be loaded.
[    0.700488] registered taskstats version 1
[    0.712729]   Magic number: 1:705:841
[    0.724446] rtc_cmos 00:06: setting system clock to 2013-02-18 15:50:11 =
UTC (1361202611)
[    0.738259] Freeing unused kernel memory: 548k freed
[    0.750614] Write protecting the kernel text: 4032k
[    0.762617] Write protecting the kernel read-only data: 1232k
[    0.800130] systemd-udevd[36]: starting version 197
[    0.886365] ACPI: bus type usb registered
[    0.912279] SCSI subsystem initialized
[    0.950736] usbcore: registered new interface driver usbfs
[    0.965341] ACPI: bus type scsi registered
[    0.976931] usbcore: registered new interface driver hub
[    0.988499] usbcore: registered new device driver usb
[    0.999826] libata version 3.00 loaded.
[    1.000646] ahci 0000:00:1f.2: version 3.0
[    1.000673] ahci: probe of 0000:00:1f.2 failed with error -22
[    1.013138] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.025485] uhci_hcd: USB Universal Host Controller Interface driver
[    1.039785] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.039792] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.052007] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 1
[    1.067672] ehci_hcd 0000:00:1d.7: debug port 1
[    1.079215] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.079241] ehci_hcd 0000:00:1d.7: irq 19, io mem 0x90040000
[    1.100038] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.111595] hub 1-0:1.0: USB hub found
[    1.122690] hub 1-0:1.0: 8 ports detected
[    1.133851] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.133856] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.145858] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[    1.157235] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
[    1.169246] hub 2-0:1.0: USB hub found
[    1.180334] hub 2-0:1.0: 2 ports detected
[    1.191392] ata_piix 0000:00:1f.2: version 2.13
[    1.191405] ata_piix 0000:00:1f.2: MAP [
[    1.202183]  P0 P2 IDE IDE ]
[    1.283352] tsc: Refined TSC clocksource calibration: 1862.120 MHz
[    1.294301] Switching to clocksource tsc
[    1.363350] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.363988] scsi0 : ata_piix
[    1.375085] scsi1 : ata_piix
[    1.385953] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq=
 14
[    1.397036] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq=
 15
[    1.407743] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.407747] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.418781] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 3
[    1.429617] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
[    1.441084] hub 3-0:1.0: USB hub found
[    1.451733] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.462765] hub 3-0:1.0: 2 ports detected
[    1.473860] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.473865] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.485028] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 4
[    1.496129] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
[    1.507685] hub 4-0:1.0: USB hub found
[    1.518436] hub 4-0:1.0: 2 ports detected
[    1.529254] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.529259] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.539644] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus =
number 5
[    1.550169] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
[    1.561120] hub 5-0:1.0: USB hub found
[    1.571969] hub 5-0:1.0: 2 ports detected
[    1.582380] ata1.00: ATA-6: HTS548040M9AT00, MG2OA5BA, max UDMA/100
[    1.593534] ata1.00: 78140160 sectors, multi 16: LBA=20
[    1.604082] ata1.00: applying bridge limits
[    1.614729] ata2.00: ATAPI: HL-DT-STCD-RW/DVD DRIVE GCC-4242N, 0J05, max=
 UDMA/33
[    1.626346] hub 1-1:1.0: USB hub found
[    1.637516] ata1.00: configured for UDMA/100
[    1.648420] hub 1-1:1.0: 4 ports detected
[    1.659301] ata2.00: configured for UDMA/33
[    1.670036] scsi 0:0:0:0: Direct-Access     ATA      HTS548040M9AT00  MG=
2O PQ: 0 ANSI: 5
[    1.697532] scsi 1:0:0:0: CD-ROM            HL-DT-ST RW/DVD GCC-4242N 0J=
05 PQ: 0 ANSI: 5
[    1.681439] ACPI: Invalid Power Resource to register!
[    1.720037] ACPI: Invalid Power Resource to register!
[    1.735900] sd 0:0:0:0: [sda] 78140160 512-byte logical blocks: (40.0 GB=
/37.2 GiB)
[    1.759284] sd 0:0:0:0: [sda] Write Protect is off
[    1.770974] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.770999] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.785334] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.797495] usb 1-4: new high-speed USB device number 3 using ehci_hcd
[    1.810062] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.822840] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.831856]  sda: sda1 sda2
[    1.844424] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.951963] Initializing USB Mass Storage driver...
[    1.964540] scsi2 : usb-storage 1-4:1.0
[    1.977157] usbcore: registered new interface driver usb-storage
[    1.989775] USB Mass Storage support registered.
[    2.308228] EXT4-fs (sda1): mounted filesystem with ordered data mode. O=
pts: (null)
[    2.400016] usb 4-2: new full-speed USB device number 2 using uhci_hcd
[    2.984069] scsi 2:0:0:0: Direct-Access     ST925031 5AS              02=
00 PQ: 0 ANSI: 4
[    2.998933] sd 2:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB=
/232 GiB)
[    3.020052] sd 2:0:0:0: [sdb] Write Protect is off
[    3.033843] sd 2:0:0:0: [sdb] Mode Sense: 38 00 00 00
[    3.040677] sd 2:0:0:0: [sdb] No Caching mode page present
[    3.054381] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    3.082802] sd 2:0:0:0: [sdb] No Caching mode page present
[    3.096452] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    3.570063] systemd[1]: systemd 197 running in system mode. (+PAM -LIBWR=
AP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    3.715499] systemd[1]: Set hostname to <onny>.
[    4.862908]  sdb: sdb1 sdb3
[    4.891805] sd 2:0:0:0: [sdb] No Caching mode page present
[    4.905604] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    4.919529] sd 2:0:0:0: [sdb] Attached SCSI disk
[    4.959306] systemd[1]: Cannot add dependency job for unit display-manag=
er.service, ignoring: Unit display-manager.service failed to load: No such =
file or directory. See system logs and 'systemctl status display-manager.se=
rvice' for details.
[    4.988462] systemd[1]: Starting Forward Password Requests to Wall Direc=
tory Watch.
[    5.003239] systemd[1]: Started Forward Password Requests to Wall Direct=
ory Watch.
[    5.017925] systemd[1]: Starting Remote File Systems.
[    5.047365] systemd[1]: Reached target Remote File Systems.
[    5.062207] systemd[1]: Starting Device-mapper event daemon FIFOs.
[    5.091659] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    5.106131] systemd[1]: Starting Delayed Shutdown Socket.
[    5.135119] systemd[1]: Listening on Delayed Shutdown Socket.
[    5.149237] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    5.177735] systemd[1]: Listening on /dev/initctl Compatibility Named Pi=
pe.
[    5.191923] systemd[1]: Starting LVM2 metadata daemon socket.
[    5.220139] systemd[1]: Listening on LVM2 metadata daemon socket.
[    5.234318] systemd[1]: Starting Dispatch Password Requests to Console D=
irectory Watch.
[    5.248756] systemd[1]: Started Dispatch Password Requests to Console Di=
rectory Watch.
[    5.263308] systemd[1]: Starting udev Kernel Socket.
[    5.292145] systemd[1]: Listening on udev Kernel Socket.
[    5.306597] systemd[1]: Starting udev Control Socket.
[    5.335313] systemd[1]: Listening on udev Control Socket.
[    5.349620] systemd[1]: Starting Encrypted Volumes.
[    5.377726] systemd[1]: Reached target Encrypted Volumes.
[    5.391701] systemd[1]: Starting Arbitrary Executable File Formats File =
System Automount Point.
[    5.420193] systemd[1]: Set up automount Arbitrary Executable File Forma=
ts File System Automount Point.
[    5.434626] systemd[1]: Expecting device dev-sda2.device...
[    5.463599] systemd[1]: Starting Journal Socket.
[    5.492780] systemd[1]: Listening on Journal Socket.
[    5.507097] systemd[1]: Started File System Check on Root Device.
[    5.521124] systemd[1]: Starting Remount Root and Kernel File Systems...
[    5.566621] systemd[1]: Mounting POSIX Message Queue File System...
[    5.692367] systemd[1]: Starting Apply Kernel Variables...
[    5.819415] systemd[1]: Starting Set Up Additional Binary Formats...
[    5.994278] EXT4-fs (sda1): re-mounted. Opts: data=3Dordered
[    6.090456] systemd[1]: Mounting Huge Pages File System...
[    6.123418] systemd[1]: Mounting Debug File System...
[    6.157846] systemd[1]: Starting udev Kernel Device Manager...
[    6.209651] systemd[1]: Starting udev Coldplug all Devices...
[    6.297718] systemd[1]: Starting Setup Virtual Console...
[    6.367536] systemd-udevd[109]: starting version 197
[    6.456006] systemd[1]: Started Load Kernel Modules.
[    6.470087] systemd[1]: Mounted FUSE Control File System.
[    6.484092] systemd[1]: Mounted Configuration File System.
[    6.497860] systemd[1]: Starting Journal Service...
[    6.766720] systemd[1]: Started Journal Service.
[    6.793952] systemd[1]: Started udev Kernel Device Manager.
[    6.821122] systemd[1]: Started Remount Root and Kernel File Systems.
[    6.848370] systemd[1]: Mounted POSIX Message Queue File System.
[    6.876973] systemd[1]: Started Apply Kernel Variables.
[    6.905717] systemd[1]: Mounted Huge Pages File System.
[    6.933591] systemd[1]: Mounted Debug File System.
[    6.953474] systemd[1]: Starting Local File Systems (Pre).
[    6.987200] systemd[1]: Reached target Local File Systems (Pre).
[    7.000406] systemd[1]: Mounting /tmp...
[    7.182607] systemd[1]: Starting Load Random Seed...
[    7.254264] systemd[1]: Mounted /tmp.
[    7.267068] systemd[1]: Starting Local File Systems.
[    7.292696] systemd[1]: Reached target Local File Systems.
[    7.305572] systemd[1]: Starting Trigger Flushing of Journal to Persiste=
nt Storage...
[    7.456932] systemd[1]: Starting Recreate Volatile Files and Directories=
=2E..
[    8.010634] systemd-journald[115]: Received SIGUSR1
[    9.880342] microcode: CPU0 sig=3D0x6d8, pf=3D0x20, revision=3D0x20
[    9.922876] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[   10.171403] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input1
[   10.186546] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   10.201650] ACPI: Requesting acpi_cpufreq
[   10.216841] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/LNXVIDEO:00/input/input2
[   10.239820] ACPI: Battery Slot [BAT0] (battery present)
[   10.257649] thermal LNXTHERM:00: registered as thermal_zone0
[   10.272202] ACPI: Lid Switch [LID]
[   10.286260] ACPI: AC Adapter [AC] (on-line)
[   10.301651] parport_pc 00:0a: reported by Plug and Play ACPI
[   10.317021] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input3
[   10.331361] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   10.349858] parport0: PC-style at 0x3bc, irq 7 [PCSPP,TRISTATE]
[   10.365118] tsc: Marking TSC unstable due to TSC halts in idle
[   10.379024] ACPI: acpi_idle registered with cpuidle
[   10.379101] ACPI: Sleep Button [SLPB]
[   10.397536] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input5
[   10.411485] Switching to clocksource hpet
[   10.425690] ACPI: Power Button [PWRF]
[   10.442324] ACPI: Thermal Zone [THM0] (63 C)
[   10.588611] ppdev: user-space parallel port driver
[   10.602897] intel_rng: FWH not detected
[   10.645430] Non-volatile memory driver v1.3
[   10.687044] Linux agpgart interface v0.103
[   10.797966] gpio_ich: ACPI BAR is busy, GPI 0 - 15 unavailable
[   10.816906] gpio_ich: GPIO from 206 to 255 on gpio_ich
[   10.833071] [drm] Initialized drm 1.1.0 20060810
[   10.867806] P-state transition latency capped at 20 uS
[   10.935106] cfg80211: Calling CRDA to update world regulatory domain
[   11.020726] iTCO_vendor_support: vendor-support=3D0
[   11.064189] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   11.080844] iTCO_wdt: Found a ICH6-M TCO device (Version=3D2, TCOBASE=3D=
0x1060)
[   11.103657] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   11.123609] tg3.c:v3.124 (March 21, 2012)
[   11.137769] lib80211: common routines for IEEE802.11 drivers
[   11.152114] lib80211_crypt: registered algorithm 'NULL'
[   11.203602] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM95751M) rev 4101] =
(PCI Express) MAC address 00:16:41:10:c2:72
[   11.218091] tg3 0000:02:00.0: eth0: attached PHY is 5750 (10/100/1000Bas=
e-T Ethernet) (WireSpeed[1], EEE[0])
[   11.232807] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] AS=
F[0] TSOcap[1]
[   11.247281] tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[   11.263069] libipw: 802.11 data/management/control stack, git-1.1.13
[   11.277344] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@=
linux.intel.com>
[   11.418922] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[   11.436875] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[   11.453580] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   11.469808] ipw2100: Detected Intel PRO/Wireless 2100 Network Connection
[   11.485541] thinkpad_acpi: http://ibm-acpi.sf.net/
[   11.501342] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[   11.520430] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total=
, 262144K mappable
[   11.535474] thinkpad_acpi: ThinkPad BIOS 70ET69WW (1.29 ), EC 70HT28WW-1=
=2E05
[   11.550091] thinkpad_acpi: IBM ThinkPad T43, model 1871F1G
[   11.570892] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[   11.590583] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xb0000000
[   11.609951] checking generic (b0000000 300000) vs hw (b0000000 10000000)
[   11.609956] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removin=
g generic driver
[   11.624201] Console: switching to colour dummy device 80x25
[   11.624760] i915 0000:00:02.0: setting latency timer to 64
[   11.626080] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   11.626093] [drm] Driver supports precise vblank timestamp query.
[   11.628376] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   11.633030] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is b=
locked
[   11.633686] Registered led device: tpacpi::thinklight
[   11.634000] Registered led device: tpacpi::power
[   11.634305] Registered led device: tpacpi::standby
[   11.645339] thinkpad_acpi: Console audio control enabled, mode: monitor =
(read only)
[   11.647143] thinkpad_acpi: fan_init: initial fan status is unknown, assu=
ming it is in auto mode
[   11.650867] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_=
acpi/input/input6
[   11.657425] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[   11.670360] i915: fixme: max PWM is zero
[   11.694764] psmouse serio1: synaptics: Touchpad model: 1, fw: 5.9, id: 0=
x2c6ab1, caps: 0x884793/0x0/0x0, board id: 71, fw id: 4797594
[   11.694803] psmouse serio1: synaptics: serio: Synaptics pass-through por=
t at isa0060/serio1/input0
[   11.736297] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input7
[   11.953629] [drm] initialized overlay support
[   12.234504] fbcon: inteldrmfb (fb0) is primary device
[   12.280089] Console: switching to colour frame buffer device 128x48
[   12.289698] fb0: inteldrmfb frame buffer device
[   12.289784] drm: registered panic notifier
[   12.289873] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   12.290537] snd_intel8x0 0000:00:1e.2: setting latency timer to 64
[   12.294328] yenta_cardbus 0000:04:00.0: CardBus bridge found [1014:0528]
[   12.294492] yenta_cardbus 0000:04:00.0: Using INTVAL to route CSC interr=
upts to PCI
[   12.296647] yenta_cardbus 0000:04:00.0: Routing CardBus interrupts to PCI
[   12.297980] yenta_cardbus 0000:04:00.0: TI: mfunc 0x01d21002, devctl 0x64
[   12.527401] yenta_cardbus 0000:04:00.0: ISA IRQ mask 0x0c78, PCI irq 16
[   12.527541] yenta_cardbus 0000:04:00.0: Socket status: 30000007
[   12.527750] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge window=
: [io  0x3000-0x6fff]
[   12.527913] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3000-0x6ff=
f:
[   12.529387]  excluding 0x3000-0x30ff 0x3400-0x34ff
[   12.553320] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge window=
: [mem 0x90300000-0x9fffffff]
[   12.553792] pcmcia_socket pcmcia_socket0: cs: memory probe 0x90300000-0x=
9fffffff:
[   12.553857]  excluding 0x90300000-0x90afffff 0x93b00000-0x982fffff 0x9fb=
00000-0xa02fffff
[   12.555535] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge window=
: [mem 0xc8000000-0xcfffffff 64bit pref]
[   12.555622] pcmcia_socket pcmcia_socket0: cs: memory probe 0xc8000000-0x=
cfffffff:
[   12.555692]  excluding 0xc8000000-0xcfffffff
[   12.724728] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af:
[   12.726100]  excluding 0x170-0x177 0x1f0-0x1f7 0x370-0x377
[   12.727443] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff:
[   12.727951]  excluding 0x3f0-0x3ff 0x4d0-0x4d7
[   12.728443] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff:
[   12.735306]  clean.
[   12.740596] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7:
[   12.746627]  clean.
[   12.753623] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0f=
ffff:
[   12.759460]  excluding 0xc0000-0xcffff 0xdc000-0xfffff
[   12.764624] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0x=
a0ffffff:
[   12.767675]  clean.
[   12.771136] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x=
60ffffff:
[   12.774081]  excluding 0x60000000-0x602fffff
[   12.776408] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff:
[   12.780326]  clean.
[   12.976879] Adding 2048380k swap on /dev/sda2.  Priority:-1 extents:1 ac=
ross:2048380k=20
[   13.243374] intel8x0_measure_ac97_clock: measured 52622 usecs (2536 samp=
les)
[   13.248053] intel8x0: clocking to 48000
[   14.286737] psmouse serio2: hgpk: ID: 10 00 64
[   17.760059] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, b=
uttons: 3/3
[   17.998209] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/serio2/input/input8
[   23.036882] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   29.220721] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   32.486918] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   33.000487] pcieport 0000:00:1c.0: wake-up capability enabled by ACPI
[   33.189179] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   33.290980] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   36.556744] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   37.490705] lib80211_crypt: registered algorithm 'CCMP'
[   54.060470] tun: Universal TUN/TAP device driver, 1.6
[   54.060557] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>

--dTy3Mrz/UPE2dbVg--

--VywGB/WGlW4DM4P8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJRIk6/AAoJEPFqEBdQ3ykkVQ8H/jnIxDqPbbFogtsbmqaMROhb
bImQ0AzyXaylLpgTe7JqkeDNuHaZ8h5IjHn7d0YKs2bjJkaPAoTQAfRJsA/gapud
sRRBKKLvsKEVlcRAhT5lTMtkVTCLmNcnkc508z4ZgWg382+60YBA3kd4k3opB5BZ
XIF7rndXijDxSVVa0LiyCm/rsjLz2JpTuj8T7R+JKwaJh3qzymdCTjCG8GgdVsfB
P63YvwOLgZlFSVoEgYyWirAku1cNB+HHmh30VVNjD+RP0TVUKEkKj+HKG2SBGstF
+ssXz+35C+NZ/tz8E6Y3skzttWgiEqKLDOPX10Uqkw9cvHCEvuB/Q9ZUdyC2ctg=
=2s4B
-----END PGP SIGNATURE-----

--VywGB/WGlW4DM4P8--
