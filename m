Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3JIH0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:26:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:49739 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab3JIHZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:25:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1061,1371106800"; 
   d="log'?scan'208";a="408101143"
Date: Wed, 9 Oct 2013 15:25:45 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: linux-mtd@lists.infradead.org
Cc: fengguang.wu@intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: [init_netsc520] WARNING: CPU: 0 PID: 1 at arch/x86/mm/ioremap.c:102
 __ioremap_caller()
Message-ID: <20131009072545.GA32231@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

FYI, here is an old warning tat dates back at least to linux v3.0:

[    1.216507] NetSc520 flash device: 0x100000 at 0x200000
[    1.218335] ------------[ cut here ]------------
[    1.219996] WARNING: CPU: 0 PID: 1 at arch/x86/mm/ioremap.c:102 __ioremap_caller+0x13f/0x3f0()
[    1.223587] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc4-01587-g97d3ab9 #357
[    1.226402] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.228361]  00000000 00000000 cecd9e34 c0e00466 cecd9e64 c023c755 c1215818 00000000
[    1.232404]  00000001 c12147a0 00000066 c022f29f c022f29f 00000200 00000001 00000001
[    1.236439]  cecd9e74 c023c842 00000009 00000000 cecd9ec8 c022f29f 00000060 00000246
[    1.240473] Call Trace:
[    1.241633]  [<c0e00466>] dump_stack+0x16/0x18
[    1.243255]  [<c023c755>] warn_slowpath_common+0x75/0x90
[    1.245096]  [<c022f29f>] ? __ioremap_caller+0x13f/0x3f0
[    1.246915]  [<c022f29f>] ? __ioremap_caller+0x13f/0x3f0
[    1.248771]  [<c023c842>] warn_slowpath_null+0x22/0x30
[    1.250552]  [<c022f29f>] __ioremap_caller+0x13f/0x3f0
[    1.252361]  [<c0de99db>] ? printk+0x3d/0x3f
[    1.253936]  [<c15af4cd>] ? init_sc520cdp+0x216/0x216
[    1.255730]  [<c022f599>] ioremap_nocache+0x19/0x20
[    1.257456]  [<c15af511>] ? init_netsc520+0x44/0xf6
[    1.259217]  [<c15af511>] init_netsc520+0x44/0xf6
[    1.260891]  [<c156abc6>] do_one_initcall+0x108/0x1ce
[    1.262689]  [<c0713822>] ? strlen+0x12/0x20
[    1.264270]  [<c156a500>] ? repair_env_string+0x3/0x51
[    1.266085]  [<c0258646>] ? parse_args+0x296/0x4b0
[    1.267785]  [<c156adb4>] kernel_init_freeable+0x128/0x1ba
[    1.269653]  [<c156a4fd>] ? do_early_param+0x78/0x78
[    1.271413]  [<c0de4310>] kernel_init+0x10/0x140
[    1.273077]  [<c0e0c0db>] ret_from_kernel_thread+0x1b/0x30
[    1.274948]  [<c0de4300>] ? rest_init+0x70/0x70
[    1.276596] ---[ end trace e29a2c8115f76b14 ]---
[    1.279410] Creating 4 MTD partitions on "netsc520 Flash Bank":

git bisect  bad 97d3ab9b2207d72eb0f72347969c284562c374bd  # 21:47      0-     32  Merge branch 'perf/urgent'
git bisect  bad d0e639c9e06d44e713170031fe05fb60ebe680af  # 21:48      0-     80  Linux 3.12-rc4
git bisect  bad 6e4664525b1db28f8c4e1130957f70a94c19213e  # 21:53      0-      2  Linux 3.11
git bisect  bad 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376  # 21:58      0-     11  Linux 3.10
git bisect  bad c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1  # 22:03      0-      9  Linux 3.9
git bisect  bad 19f949f52599ba7c3f67a5897ac6be14bfcb1200  # 22:08      0-      1  Linux 3.8
git bisect  bad 29594404d7fe73cd80eaa4ee8c43dcc53970c60e  # 22:13      0-     10  Linux 3.7
git bisect  bad a0d271cbfed1dd50278c6b06bead3d00ba0a88f9  # 22:19      0-     12  Linux 3.6
git bisect  bad 28a33cbc24e4256c143dce96c7d93bf423229f92  # 22:23      0-      2  Linux 3.5
git bisect  bad 76e10d158efb6d4516018846f60c2ab5501900bc  # 22:28      0-     11  Linux 3.4
git bisect  bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7  # 22:32      0-      3  Linux 3.3
git bisect  bad 805a6af8dba5dfdd35ec35dc52ec0122400b2610  # 22:37      0-      8  Linux 3.2
git bisect  bad c3b92c8787367a8bb53d57d9789b558f1295cc96  # 22:41      0-     13  Linux 3.1
git bisect  bad 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe  # 22:45      0-     15  Linux 3.0
git bisect  bad 8b5ede69d24db939f52b47effff2f6fe1e83e08b  # 23:56      0-     32  powerpc/irq: Don't switch to irq stack from softirq stack
git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 23:56      0-     23  Add linux-next specific files for 20130927
git bisect  bad 97d3ab9b2207d72eb0f72347969c284562c374bd  # 23:56      0-     39  Merge branch 'perf/urgent'

Thanks,
Fengguang

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-tt02-20:20131008092925:i386-randconfig-i009-1008:3.12.0-rc4-01587-g97d3ab9:357"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc4-01587-g97d3ab9 (kbuild@inn) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #357 Tue Oct 8 18:46:06 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
[    0.000000]  [mem 0x0f800000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
[    0.000000]  [mem 0x08000000-0x0f7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x01713000, 0x01713fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128256(97%)
[    0.000000] RAMDISK: [mem 0x0fce4000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x01714000, 0x01714fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13c5d00
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-i009-1008/tip:master:97d3ab9=
b2207d72eb0f72347969c284562c374bd:bisect-usb/.vmlinuz-97d3ab9b2207d72eb0f72=
347969c284562c374bd-20131008185655-7-lkp-tt02 branch=3Dtip/master BOOT_IMAG=
E=3D/kernel/i386-randconfig-i009-1008/97d3ab9b2207d72eb0f72347969c284562c37=
4bd/vmlinuz-3.12.0-rc4-01587-g97d3ab9
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 226400K/261744K available (12340K kernel code, 1761K=
 rwdata, 5768K rodata, 940K init, 728K bss, 35344K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc156a000 - 0xc1655000   ( 940 kB)
[    0.000000]       .data : 0xc0e0d56f - 0xc15694b0   (7535 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0e0d56f   (12341 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1, =
Nodes=3D1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dcec10000 soft=3Dcec12000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2393.914 MHz processor
[    0.009999] Calibrating delay loop (skipped) preset value.. 4789.32 Bogo=
MIPS (lpj=3D7979713)
[    0.010028] pid_max: default: 32768 minimum: 301
[    0.011986] Mount-cache hash table entries: 512
[    0.014314] Initializing cgroup subsys freezer
[    0.016696] Initializing cgroup subsys blkio
[    0.018386] Initializing cgroup subsys perf_event
[    0.020012] Initializing cgroup subsys net_prio
[    0.021828] mce: CPU supports 10 MCE banks
[    0.023428] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023428] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023428] tlb_flushall_shift: 6
[    0.026673] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.053970] ACPI: Core revision 20130725
[    0.078123] ACPI: All ACPI Tables successfully acquired
[    0.080013] ACPI: setting ELCR to 0200 (from 0c00)
[    0.081778] ftrace: allocating 42611 entries in 84 pages
[    0.097072] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.103769] ftrace: Allocated trace_printk buffers
[    0.115026] Getting VERSION: 50014
[    0.116496] Getting VERSION: 50014
[    0.116681] Getting ID: 0
[    0.117897] Getting ID: f000000
[    0.120019] Getting LVT0: 8700
[    0.121322] Getting LVT1: 8400
[    0.123400] enabled ExtINT on CPU#0
[    0.124854] Using local APIC timer interrupts.
[    0.124854] calibrating APIC timer ...
[    0.129999] ... lapic delta =3D 6249968
[    0.129999] ... PM-Timer delta =3D 357956
[    0.129999] ... PM-Timer result ok
[    0.129999] ..... delta 6249968
[    0.129999] ..... mult: 268434108
[    0.129999] ..... calibration result: 3333316
[    0.129999] ..... CPU clock speed is 2394.0492 MHz.
[    0.129999] ..... host bus clock speed is 1000.0316 MHz.
[    0.130513] devtmpfs: initialized
[    0.143045] regulator-dummy: no parameters
[    0.146810] NET: Registered protocol family 16
[    0.150981] cpuidle: using governor ladder
[    0.153134] ACPI: bus type PCI registered
[    0.153575] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.156669] PCI: Using configuration type 1 for base access
[    0.159166] Missing cpus node, bailing out
[    0.181509] bio: create slab <bio-0> at 0
[    0.184146] ACPI: Added _OSI(Module Device)
[    0.185726] ACPI: Added _OSI(Processor Device)
[    0.186670] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.188341] ACPI: Added _OSI(Processor Aggregator Device)
[    0.191064] ACPI: EC: Look up EC in DSDT
[    0.234947] ACPI: Interpreter enabled
[    0.236563] ACPI: (supports S0 S4 S5)
[    0.236670] ACPI: Using PIC for interrupt routing
[    0.238520] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.319093] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.320035] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.328237] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.330303] PCI host bridge to bus 0000:00
[    0.333345] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.335233] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.336676] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.338740] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.340010] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.343413] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.348556] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.352313] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.357761] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.362567] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.363985] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.366688] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.371782] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.375402] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.378014] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.388560] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.391883] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.394415] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.397671] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.405824] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.408492] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.411066] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.414357] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.423023] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.426897] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.429478] pci 0000:00:05.0: reg 0x10: [mem 0xfebe2000-0xfebe200f]
[    0.436912] pci_bus 0000:00: on NUMA node 0
[    0.443790] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.448061] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.452210] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.456344] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.458697] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.466666] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.466684] ACPI: \_SB_.PCI0: notify handler is installed
[    0.470031] Found 1 acpi root devices
[    0.473815] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.476670] vgaarb: loaded
[    0.477859] vgaarb: bridge control possible 0000:00:02.0
[    0.481741] SCSI subsystem initialized
[    0.483311] libata version 3.00 loaded.
[    0.483473] ACPI: bus type USB registered
[    0.485133] usbcore: registered new interface driver usbfs
[    0.486737] usbcore: registered new interface driver hub
[    0.490133] usbcore: registered new device driver usb
[    0.492352] pps_core: LinuxPPS API ver. 1 registered
[    0.493336] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.496724] PTP clock support registered
[    0.498883] Advanced Linux Sound Architecture Driver Initialized.
[    0.500003] PCI: Using ACPI for IRQ routing
[    0.503337] PCI: pci_cache_line_size set to 64 bytes
[    0.505277] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.506678] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.510179] NET: Registered protocol family 23
[    0.511916] Bluetooth: Core ver 2.16
[    0.513406] NET: Registered protocol family 31
[    0.515007] Bluetooth: HCI device and connection manager initialized
[    0.516682] Bluetooth: HCI socket layer initialized
[    0.518423] Bluetooth: L2CAP socket layer initialized
[    0.520033] Bluetooth: SCO socket layer initialized
[    0.521782] NET: Registered protocol family 8
[    0.523336] NET: Registered protocol family 20
[    0.525494] cfg80211: Calling CRDA to update world regulatory domain
[    0.527380] Switched to clocksource kvm-clock
[    0.529009] Warning: could not register annotated branches stats
[    0.627037] FS-Cache: Loaded
[    0.628627] CacheFiles: Loaded
[    0.630058] pnp: PnP ACPI init
[    0.631410] ACPI: bus type PNP registered
[    0.633316] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.635826] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.638305] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.640863] pnp 00:03: [dma 2]
[    0.642352] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.645106] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.647834] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.652293] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.656226] pnp: PnP ACPI: found 7 devices
[    0.657765] ACPI: bus type PNP unregistered
[    0.706532] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.708479] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.710364] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.712428] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.714551] NET: Registered protocol family 1
[    0.716200] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.718200] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.720143] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.722222] pci 0000:00:02.0: Boot video device
[    0.723893] PCI: CLS 0 bytes, default 64
[    0.725718] Unpacking initramfs...
[    0.866597] Freeing initrd memory: 3120K (cfce4000 - cfff0000)
[    0.869630] Machine check injector initialized
[    0.871865] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.873917] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.877031] Scanning for low memory corruption every 60 seconds
[    0.885878] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.914602] VFS: Disk quotas dquot_6.5.2
[    0.916502] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.925754] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.933447] NTFS driver 2.1.30 [Flags: R/W DEBUG].
[    0.936952] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    0.939020] jffs2: version 2.2. (NAND)=20
[    0.945347] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.947677] QNX4 filesystem 0.2.3 registered.
[    0.949566] QNX6 filesystem 1.0.0 registered.
[    0.951176] fuse init (API version 7.22)
[    0.953910] SGI XFS with security attributes, large block/inode numbers,=
 debug enabled
[    0.962694] BeFS version: 0.9.3
[    0.964323] OCFS2 1.5.0
[    0.966767] ocfs2: Registered cluster interface o2cb
[    0.968526] OCFS2 DLMFS 1.5.0
[    0.970146] OCFS2 User DLM kernel interface loaded
[    0.971852] OCFS2 Node Manager 1.5.0
[    0.974739] OCFS2 DLM 1.5.0
[    0.979882] GFS2 installed
[    0.981146] msgmni has been set to 448
[    0.991310] alg: No test for crc32 (crc32-table)
[    0.993277] alg: No test for lz4hc (lz4hc-generic)
[    0.995056] alg: No test for stdrng (krng)
[    1.001198] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    1.003347] NET: Registered protocol family 38
[    1.004984] Key type asymmetric registered
[    1.006514] Asymmetric key parser 'x509' registered
[    1.008600] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    1.011395] io scheduler noop registered (default)
[    1.013090] test_string_helpers: Running tests...
[    1.016137] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    1.017851] crc32: self tests passed, processed 225944 bytes in 665351 n=
sec
[    1.020668] crc32c: CRC_LE_BITS =3D 8
[    1.022092] crc32c: self tests passed, processed 225944 bytes in 303477 =
nsec
[    1.026255] usbcore: registered new interface driver udlfb
[    1.028187] usbcore: registered new interface driver smscufx
[    1.033287] uvesafb: VGABIOS Cirrus extension, VGABIOS Cirrus extension,=
 1.0, OEM: VGABIOS Cirrus extension, VBE v2.0
[    1.040267] uvesafb: no monitor limits have been set, default refresh ra=
te will be used
[    1.043494] uvesafb: VBE state buffer size cannot be determined (eax=3D0=
x14f, err=3D0)
[    1.046406] uvesafb: scrolling: redraw
[    1.048105] VESA VGA: enable CONFIG_FB_LITTLE_ENDIAN to support this fra=
mebuffer
[    1.050817] uvesafb: failed to register framebuffer device
[    1.052861] uvesafb: probe of uvesafb.0 failed with error -22
[    1.055386] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.058143] ACPI: Power Button [PWRF]
[    1.061350] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.063196] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.089745] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.123852] STMicroelectronics ASC driver initialized
[    1.126312] Non-volatile memory driver v1.3
[    1.130781] toshiba: not a supported Toshiba laptop
[    1.132762] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    1.135077] platform pc8736x_gpio.0: no device found
[    1.136891] nsc_gpio initializing
[    1.138297] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.140085] smapi::smapi_init, ERROR invalid usSmapiID
[    1.141887] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    1.145093] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    1.147791] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.150046] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.153186] Hangcheck: Using getrawmonotonic().
[    1.154897] [drm] Initialized drm 1.1.0 20060810
[    1.156777] dummy-irq: no IRQ given.  Use irq=3DN
[    1.158507] lkdtm: No crash points registered, enable through debugfs
[    1.160810] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    1.163795] c2port c2port0: C2 port uc added
[    1.165403] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    1.169077] usbcore: registered new interface driver viperboard
[    1.171116] Uniform Multi-Platform E-IDE driver
[    1.172891] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    1.176227] ide-gd driver 1.18
[    1.177556] ide-cd driver 5.00
[    1.179295] Loading iSCSI transport class v2.0-870.
[    1.181655] hp_sw: device handler registered
[    1.183250] emc: device handler registered
[    1.184791] alua: device handler registered
[    1.186350] osst :I: Tape driver with OnStream support version 0.99.4
[    1.186350] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    1.190746] SCSI Media Changer driver v0.25=20
[    1.194900] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    1.200500] SSFDC read-only Flash Translation layer
[    1.202342] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    1.204457] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    1.207300] platform physmap-flash.0: failed to claim resource 0
[    1.209517] Could not find PAR responsible for SC520CDP Flash Bank #1
[    1.211620] Trying default address 0x8c00000
[    1.213221] SC520 CDP flash device: 0x800000 at 0x8800000
[    1.215082] Failed to ioremap_nocache
[    1.216507] NetSc520 flash device: 0x100000 at 0x200000
[    1.218335] ------------[ cut here ]------------
[    1.219996] WARNING: CPU: 0 PID: 1 at arch/x86/mm/ioremap.c:102 __iorema=
p_caller+0x13f/0x3f0()
[    1.223587] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc4-01587-g97=
d3ab9 #357
[    1.226402] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.228361]  00000000 00000000 cecd9e34 c0e00466 cecd9e64 c023c755 c1215=
818 00000000
[    1.232404]  00000001 c12147a0 00000066 c022f29f c022f29f 00000200 00000=
001 00000001
[    1.236439]  cecd9e74 c023c842 00000009 00000000 cecd9ec8 c022f29f 00000=
060 00000246
[    1.240473] Call Trace:
[    1.241633]  [<c0e00466>] dump_stack+0x16/0x18
[    1.243255]  [<c023c755>] warn_slowpath_common+0x75/0x90
[    1.245096]  [<c022f29f>] ? __ioremap_caller+0x13f/0x3f0
[    1.246915]  [<c022f29f>] ? __ioremap_caller+0x13f/0x3f0
[    1.248771]  [<c023c842>] warn_slowpath_null+0x22/0x30
[    1.250552]  [<c022f29f>] __ioremap_caller+0x13f/0x3f0
[    1.252361]  [<c0de99db>] ? printk+0x3d/0x3f
[    1.253936]  [<c15af4cd>] ? init_sc520cdp+0x216/0x216
[    1.255730]  [<c022f599>] ioremap_nocache+0x19/0x20
[    1.257456]  [<c15af511>] ? init_netsc520+0x44/0xf6
[    1.259217]  [<c15af511>] init_netsc520+0x44/0xf6
[    1.260891]  [<c156abc6>] do_one_initcall+0x108/0x1ce
[    1.262689]  [<c0713822>] ? strlen+0x12/0x20
[    1.264270]  [<c156a500>] ? repair_env_string+0x3/0x51
[    1.266085]  [<c0258646>] ? parse_args+0x296/0x4b0
[    1.267785]  [<c156adb4>] kernel_init_freeable+0x128/0x1ba
[    1.269653]  [<c156a4fd>] ? do_early_param+0x78/0x78
[    1.271413]  [<c0de4310>] kernel_init+0x10/0x140
[    1.273077]  [<c0e0c0db>] ret_from_kernel_thread+0x1b/0x30
[    1.274948]  [<c0de4300>] ? rest_init+0x70/0x70
[    1.276596] ---[ end trace e29a2c8115f76b14 ]---
[    1.279410] Creating 4 MTD partitions on "netsc520 Flash Bank":
[    1.281430] 0x000000000000-0x0000000c0000 : "NetSc520 boot kernel"
[    1.284618] 0x0000000c0000-0x000000100000 : "NetSc520 Low BIOS"
[    1.287569] 0x000000100000-0x000000f80000 : "NetSc520 file system"
[    1.289651] mtd: partition "NetSc520 file system" is out of reach -- dis=
abled
[    1.292884] 0x000000f80000-0x000001000000 : "NetSc520 High BIOS"
[    1.294898] mtd: partition "NetSc520 High BIOS" is out of reach -- disab=
led
[    1.298092] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.300226] slram: not enough parameters.
[    1.307768] HSI/SSI char device loaded
[    1.309353] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    1.312591] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[    1.315684] vcan: Virtual CAN interface driver
[    1.317303] CAN device driver interface
[    1.318853] usbcore: registered new interface driver ems_usb
[    1.320807] usbcore: registered new interface driver kvaser_usb
[    1.322915] sja1000 CAN netdevice driver
[    1.324543] usbcore: registered new interface driver irda-usb
[    1.326524] usbcore: registered new interface driver stir4200
[    1.330167] usbcore: registered new interface driver ks959-sir
[    1.332524] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.334680] ehci-pci: EHCI PCI platform driver
[    1.336447] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.338543] ohci-pci: OHCI PCI platform driver
[    1.340225] ohci-platform: OHCI generic platform driver
[    1.344239] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    1.346378] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    1.349556] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    1.351514]=20
[    1.354810] usbcore: registered new interface driver cdc_acm
[    1.356714] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    1.359670] usbcore: registered new interface driver usblp
[    1.361603] usbcore: registered new interface driver cdc_wdm
[    1.363607] usbcore: registered new interface driver usb-storage
[    1.365686] usbcore: registered new interface driver ums-alauda
[    1.367718] usbcore: registered new interface driver ums-cypress
[    1.369749] usbcore: registered new interface driver ums_eneub6250
[    1.371846] usbcore: registered new interface driver ums-freecom
[    1.373879] usbcore: registered new interface driver ums-isd200
[    1.375924] usbcore: registered new interface driver ums-jumpshot
[    1.377990] usbcore: registered new interface driver ums-realtek
[    1.380058] usbcore: registered new interface driver ums-sddr09
[    1.382093] usbcore: registered new interface driver ums-sddr55
[    1.384101] usbcore: registered new interface driver ums-usbat
[    1.386161] usbcore: registered new interface driver mdc800
[    1.388062] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    1.390917] usbcore: registered new interface driver microtekX6
[    1.392978] usbcore: registered new interface driver adutux
[    1.395052] usbcore: registered new interface driver appledisplay
[    1.397114] usbcore: registered new interface driver cytherm
[    1.399100] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    1.401397] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    1.403677] usbcore: registered new interface driver iowarrior
[    1.405697] usbcore: registered new interface driver isight_firmware
[    1.407849] usbcore: registered new interface driver usblcd
[    1.409784] usbcore: registered new interface driver usbtest
[    1.411746] usbcore: registered new interface driver usbsevseg
[    1.413740] usbcore: registered new interface driver yurex
[    1.416741] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.420806] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.422601] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.526801] mousedev: PS/2 mouse device common for all mice
[    1.528927] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    1.533353] usbcore: registered new interface driver xpad
[    1.535339] usbcore: registered new interface driver usb_acecad
[    1.537367] usbcore: registered new interface driver aiptek
[    1.539342] usbcore: registered new interface driver gtco
[    1.541264] usbcore: registered new interface driver hanwang
[    1.543231] usbcore: registered new interface driver kbtab
[    1.545167] usbcore: registered new interface driver wacom
[    1.547992] usbcore: registered new interface driver usbtouchscreen
[    1.550697] usbcore: registered new interface driver ati_remote2
[    1.552763] cm109: Keymap for Komunikate KIP1000 phone loaded
[    1.554758] usbcore: registered new interface driver cm109
[    1.556626] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    1.558975] usbcore: registered new interface driver keyspan_remote
[    1.561486] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    1.564443] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input2
[    1.567665] evbug: Connected device: input1 (PC Speaker at isa0061/input=
0)
[    1.569967] wistron_btns: System unknown
[    1.571545] usbcore: registered new interface driver yealink
[    1.573690] usbcore: registered new interface driver i2c-diolan-u2c
[    1.576041] pps pps0: new PPS source ktimer
[    1.577596] pps pps0: ktimer PPS source registered
[    1.579329] pps_ldisc: PPS line discipline registered
[    1.581158] Driver for 1-wire Dallas network protocol.
[    1.583200] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    1.592084] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    1.594895] usbcore: registered new interface driver pcwd_usb
[    1.599808] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    1.602806] acquirewdt: I/O address 0x0043 already in use
[    1.604692] acquirewdt: probe of acquirewdt failed with error -5
[    1.606674] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    1.610013] evbug: Connected device: input2 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    1.613797] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    1.615956] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    1.618847] wafer5823wdt: I/O address 0x0443 already in use
[    1.620868] it87_wdt: no device
[    1.622257] pc87413_wdt: Version 1.1 at io 0x2E
[    1.623890] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    1.626077] sbc60xxwdt: I/O address 0x0443 already in use
[    1.627936] sbc8360: failed to register misc device
[    1.629685] cpu5wdt: misc_register failed
[    1.631309] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    1.633351] w83697hf_wdt: watchdog not found at address 0x2e
[    1.635279] w83697hf_wdt: No W83697HF/HG could be found
[    1.637095] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    1.640237] w83697ug_wdt: No W83697UG/UF could be found
[    1.642069] w83977f_wdt: driver v1.00
[    1.643503] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    1.645662] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    1.647673] machzwd: no ZF-Logic found
[    1.649212] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    1.652137] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    1.657713] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    1.663226] device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised:=
 dm-devel@redhat.com
[    1.667181] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    1.669280] usbcore: registered new interface driver bpa10x
[    1.671336] usbcore: registered new interface driver btusb
[    1.673276] usbcore: registered new interface driver ath3k
[    1.675215] lguest: switcher text too large (4384)
[    1.676964] sdhci: Secure Digital Host Controller Interface driver
[    1.679027] sdhci: Copyright(c) Pierre Ossman
[    1.680617] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    1.682612] wbsd: Copyright(c) Pierre Ossman
[    1.684313] usbcore: registered new interface driver ushc
[    1.687132] ledtrig-cpu: registered to indicate activity on CPUs
[    1.690078] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.695925] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facche=
tti 1995-98
[    1.698765] aedsp16: I/O, IRQ and DMA are mandatory
[    1.700507] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[    1.702551] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    1.705374] ad1848: No ISAPnP cards found, trying standard ones...
[    1.707425] MediaTrix audio driver Copyright (C) by Hannu Savolainen 199=
3-1996
[    1.710178] I/O, IRQ, DMA and type are mandatory
[    1.711846] sb: Init: Starting Probe...
[    1.713384] sb: Init: Done
[    1.714653] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red=
 Hat Inc
[    1.719436] Error: Driver 'da9055' is already registered, aborting...
[    1.726908] NET: Registered protocol family 26
[    1.728584] NET: Registered protocol family 17
[    1.730280] NET: Registered protocol family 15
[    1.732232] Ebtables v2.0 registered
[    1.733760] NET: Registered protocol family 5
[    1.735479] NET: Registered protocol family 9
[    1.737096] X.25 for Linux Version 0.2
[    1.738627] can: controller area network core (rev 20120528 abi 9)
[    1.741078] NET: Registered protocol family 29
[    1.742695] can: raw protocol (rev 20120528)
[    1.744281] can: netlink gateway (rev 20130117) max_hops=3D1
[    1.747120] Bluetooth: RFCOMM TTY layer initialized
[    1.748895] Bluetooth: RFCOMM socket layer initialized
[    1.750701] Bluetooth: RFCOMM ver 1.11
[    1.752190] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.754027] Bluetooth: BNEP filters: protocol multicast
[    1.755868] Bluetooth: BNEP socket layer initialized
[    1.757623] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    1.759646] Bluetooth: HIDP socket layer initialized
[    1.761429] lec:lane_module_init: lec.c: initialized
[    1.763184] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    1.766787] DECnet: Routing cache hash table of 1024 buckets, 4Kbytes
[    1.769232] NET: Registered protocol family 12
[    1.770915] NET: Registered protocol family 35
[    1.773186] 8021q: 802.1Q VLAN Support v1.8
[    1.774799] 9pnet: Installing 9P2000 support
[    1.776453] NET: Registered protocol family 37
[    1.778338] batman_adv: B.A.T.M.A.N. advanced 2013.4.0 (compatibility ve=
rsion 14) loaded
[    1.781274] openvswitch: Open vSwitch switching datapath
[    1.783587] mpls_gso: MPLS GSO support
[    1.786157] Using IPI Shortcut mode
[    1.787963] PM: Hibernation image not present or could not be loaded.
[    1.791038] Key type encrypted registered
[    1.794262] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.796305] EDD information not available.
[    1.798050] ### dt-test ### No testcase data in device tree; not running=
 tests
[    1.800759] ALSA device list:
[    1.802066]   No soundcards found.
[    1.804146] Freeing unused kernel memory: 940K (c156a000 - c1655000)
[    1.806781] Write protecting the kernel text: 12344k
[    1.808837] Write protecting the kernel read-only data: 5772k
[    1.891197] tsc: Refined TSC clocksource calibration: 2393.911 MHz
[    1.915861] udev[128]: starting version 164
[    2.640527] GFS2: path_lookup on rootfs returned error -2
Kernel tests: Boot OK!
[    3.406734] trinity uses obsolete (PF_INET,SOCK_PACKET)
[    6.136554] Bits 55-60 of /proc/PID/pagemap entries are about to stop be=
ing page-shift some time soon. See the linux/Documentation/vm/pagemap.txt f=
or details.
[   48.819765] VFS: Warning: trinity-child0 using old stat() call. Recompil=
e your binary.
[   48.825376] VFS: Warning: trinity-child0 using old stat() call. Recompil=
e your binary.
[   48.828422] VFS: Warning: trinity-child0 using old stat() call. Recompil=
e your binary.
[   48.832110] VFS: Warning: trinity-child0 using old stat() call. Recompil=
e your binary.
[   54.845101] VFS: Warning: trinity-child0 using old stat() call. Recompil=
e your binary.
[   71.740195] Unregister pv shared memory for cpu 0
[   71.742083] no ifx modem active;
[   71.743773] reboot: Restarting system
[   71.745322] reboot: machine restart
Elapsed time: 80
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-i=
009-1008/97d3ab9b2207d72eb0f72347969c284562c374bd/vmlinuz-3.12.0-rc4-01587-=
g97d3ab9 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 l=
og_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_prin=
tk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1152=
00 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/ru=
n-queue/kvm/i386-randconfig-i009-1008/tip:master:97d3ab9b2207d72eb0f7234796=
9c284562c374bd:bisect-usb/.vmlinuz-97d3ab9b2207d72eb0f72347969c284562c374bd=
-20131008185655-7-lkp-tt02 branch=3Dtip/master BOOT_IMAGE=3D/kernel/i386-ra=
ndconfig-i009-1008/97d3ab9b2207d72eb0f72347969c284562c374bd/vmlinuz-3.12.0-=
rc4-01587-g97d3ab9'  -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m=
 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio -=
net user,vlan=3D0,hostfwd=3Dtcp::5365-:22 -net nic,vlan=3D1,model=3De1000 -=
net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -pidfile /=
dev/shm/kboot/pid-yocto-lkp-tt02-20 -serial file:/dev/shm/kboot/serial-yoct=
o-lkp-tt02-20 -daemonize -display none -monitor null=20

--0F1p//8PRICkK4MW
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-97d3ab9b2207d72eb0f72347969c284562c374bd-i386-randconfig-i009-1008-arch-x---mm-ioremap-c-7748.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGQwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgOTdkM2FiOS4uLiBNZXJnZSBicmFuY2ggJ3Bl
cmYvdXJnZW50JwpIRUFEIGlzIG5vdyBhdCBkMGU2MzljLi4uIExpbnV4IDMuMTItcmM0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwOS0x
MDA4L3RpcDptYXN0ZXI6ZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBh
ZjpiaXNlY3QtdXNiCiBURVNUIEZBSUxVUkUKQlVHOiBrZXJuZWwgZWFybHkgaGFuZyB3aXRo
b3V0IGFueSBwcmludGsgb3V0cHV0CkNvbW1hbmQgbGluZTogaHVuZ190YXNrX3BhbmljPTEg
cmN1dHJlZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIGxvZ19idWZfbGVuPThNIGlnbm9y
ZV9sb2dsZXZlbCBkZWJ1ZyBzY2hlZF9kZWJ1ZyBhcGljPWRlYnVnIGR5bmFtaWNfcHJpbnRr
IHN5c3JxX2Fsd2F5c19lbmFibGVkIHBhbmljPTEwICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNv
bGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFt
MCBydyBsaW5rPS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4L2xpbnV4LWRldmVsOmRldmVsLWlubi1pMzg2LTIwMTMxMDA4MDU0Ni8udm1s
aW51ei1kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmLTIwMTMxMDA4
MDU1MzU2LTEzLWFudCBicmFuY2g9bGludXgtZGV2ZWwvZGV2ZWwtaW5uLWkzODYtMjAxMzEw
MDgwNTQ2IEJPT1RfSU1BR0U9L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2Qw
ZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvdm1saW51ei0zLjEyLjAt
cmM0IG5vYXBpYyBub2xhcGljIG5vaHo9b2ZmCkVhcmx5IGhhbmcga2VybmVsOiB2bWxpbnV6
LTMuMTIuMC1yYzQgMy4xMi4wLXJjNCAjMjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNn
LXlvY3RvLWlubi03OjIwMTMxMDA4MDU1NTE0OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6
My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYz
OWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2cteW9jdG8tbGtwLXN0
MDEtODoyMDEzMTAwODA2MDA1MzppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1y
YzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0
NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXF1YW50YWwtc3RvYWtsZXktNjoy
MDEzMTAwODE4NTkyNTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMx
NzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXF1YW50YWwtd2FpbWVhLTEwOjIwMTMxMDA4
MTM1NzU4OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZl
MDVmYjYwZWJlNjgwYWYvZG1lc2ctcXVhbnRhbC1jYWlyby0xNjoyMDEzMTAwODA2MDA0NDpp
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGVi
ZTY4MGFmL2RtZXNnLXF1YW50YWwtY2Fpcm8tMjE6MjAxMzEwMDgwNTU1MjA6aTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9k
bWVzZy15b2N0by1zdG9ha2xleS00OjIwMTMxMDA4MDYwMTI3OmkzODYtcmFuZGNvbmZpZy1p
MDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0x
MDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2cteW9j
dG8tc3RvYWtsZXktNToyMDEzMTAwODE4NTkxOTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2
MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXlvY3RvLWJlbnMt
MToyMDEzMTAwODA2MDEyMTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6
Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3
MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXF1YW50YWwtbGtwLXR0MDItMTQ6MjAx
MzEwMDgwOTMwMDc6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcw
MDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTE0OjIwMTMxMDA3
MjAyNjMwOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZl
MDVmYjYwZWJlNjgwYWYvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0yMzoyMDEzMTAwNzIwMzEz
NTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2
MGViZTY4MGFmL2RtZXNnLXF1YW50YWwtYmVucy00OjIwMTMxMDA4MDU1NTQxOmkzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYv
ZG1lc2cteW9jdG8teHBzLTM6MjAxMzEwMDgxMzU3NTI6aTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
ZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy15b2N0by1s
a3AtdHQwMi0xNjoyMDEzMTAwNzIwMjYyODppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMu
MTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2Mzlj
OWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXlvY3RvLXdhaW1lYS02
OjIwMTMxMDA4MTM1MjUyOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoy
OTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcx
MzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2ctcXVhbnRhbC1zdG9ha2xleS03OjIwMTMx
MDA4MDYwMTIzOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAz
MWZlMDVmYjYwZWJlNjgwYWYvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0xNDoyMDEzMTAwNzIw
MzIwOTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1
ZmI2MGViZTY4MGFmL2RtZXNnLXlvY3RvLXN0b2FrbGV5LTE6MjAxMzEwMDgwNjAxMjc6aTM4
Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2
ODBhZi9kbWVzZy15b2N0by14aWFuLTMwOjIwMTMxMDA4MTg1OTEwOmkzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2ct
cXVhbnRhbC1sa3AtdHQwMi0xMzoyMDEzMTAwNzIwMzEzMTppMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXF1YW50
YWwtbGtwLXR0MDItMTU6MjAxMzEwMDcyMDI2MDU6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
ODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBl
NjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy1xdWFudGFsLWxr
cC1zdDAxLTY6MjAxMzEwMDgxODU5MTM6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEy
LjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5Yzll
MDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy15b2N0by1sa3AtdHQwMi0x
OjIwMTMxMDA3MjAzMjI1OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoy
OTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcx
MzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2cteW9jdG8teHBzLTM6MjAxMzEwMDkwMjU1
NDM6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZi
NjBlYmU2ODBhZi9kbWVzZy15b2N0by13YWltZWEtMTQ6MjAxMzEwMDgxMzUyNTY6aTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBh
Zi9kbWVzZy15b2N0by1sa3AtdHQwMi0xMjoyMDEzMTAwNzIwMjYyNTppMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNn
LXlvY3RvLXN0b2FrbGV5LTU6MjAxMzEwMDgwNjAxMzc6aTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
ZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy1xdWFudGFs
LWFudC05OjIwMTMxMDA4MTkwMDI2OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4w
LXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2
ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2cteW9jdG8tY2Fpcm8tOToyMDEz
MTAwODE4NTkxODppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAw
MzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXF1YW50YWwtaW5uLTg6MjAxMzEwMDgwNjAxMzM6
aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBl
YmU2ODBhZi9kbWVzZy15b2N0by1pbm4tNjoyMDEzMTAwODA1NTUyMzppMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNn
LXlvY3RvLW5obTQtNDoyMDEzMTAwNzIyMDAyMDppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2
MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXlvY3RvLWFudC01
OjIwMTMxMDA4MTkwMDA5OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoy
OTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcx
MzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2cteW9jdG8tYmVucy0xOjIwMTMxMDA4MDU1
NTQ1OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVm
YjYwZWJlNjgwYWYvZG1lc2cteW9jdG8td2FpbWVhLTU6MjAxMzEwMDgxMzU4NDk6aTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBh
Zi9kbWVzZy15b2N0by1sa3AtdHQwMi0xMzoyMDEzMTAwNzIwMjYzMDppMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNn
LXF1YW50YWwtbGtwLXR0MDItMToyMDEzMTAwNzIwMjYyMjppMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXF1YW50
YWwtaW5uLTM6MjAxMzEwMDgxODU5MDg6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEy
LjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5Yzll
MDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy1xdWFudGFsLXhpYW4tMTg6
MjAxMzEwMDgxODU5MDU6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5
NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEz
MTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTk6MjAxMzEw
MDcyMDI2MjI6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMx
ZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy1xdWFudGFsLXNuYi04OjIwMTMxMDA4MDU1NTIwOmkz
ODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJl
NjgwYWYvZG1lc2cteW9jdG8tbGtwLXR0MDItNDoyMDEzMTAwNzIwMjYxMTppMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2Rt
ZXNnLXF1YW50YWwtYmF5LTI6MjAxMzEwMDgwNTU1MzM6aTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
ZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy15b2N0by1s
a3AtdHQwMi0yNDoyMDEzMTAwODA5MzAyNTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMu
MTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2Mzlj
OWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXlvY3RvLWxrcC1zdDAx
LTE6MjAxMzEwMDgwNjAxNDU6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0
OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRl
NzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy15b2N0by1zdG9ha2xleS01OjIwMTMx
MDA4MDU1NTUxOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAz
MWZlMDVmYjYwZWJlNjgwYWYvZG1lc2cteW9jdG8td2FpbWVhLTExOjIwMTMxMDA4MTM1ODA1
OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYw
ZWJlNjgwYWYvZG1lc2ctcXVhbnRhbC1iZW5zLTE6MjAxMzEwMDgwNTU1Mzk6aTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9k
bWVzZy1xdWFudGFsLWxrcC10dDAyLTE4OjIwMTMxMDA3MjAzMTUzOmkzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2ct
cXVhbnRhbC1sa3AtdHQwMi0xMjoyMDEzMTAwODA5MzAyMjppMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXlvY3Rv
LXdhaW1lYS0xNDoyMDEzMTAwODEzNTgxMTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMu
MTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2Mzlj
OWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXlvY3RvLWlubi0yNToy
MDEzMTAwODE4NTkyNjppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMx
NzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXlvY3RvLWlubi0yMToyMDEzMTAwODE4NTkx
MDppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2
MGViZTY4MGFmL2RtZXNnLXF1YW50YWwtY2Fpcm8tMzM6MjAxMzEwMDgwNTU1MzU6aTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBh
Zi9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTI0OjIwMTMxMDA4MDkzMDIzOmkzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1l
c2ctcXVhbnRhbC1yb2FtLTMyOjIwMTMxMDA4MDYwMTEzOmkzODYtcmFuZGNvbmZpZy1pMDA5
LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2cteW9jdG8t
amFrZXRvd24tMTg6MjAxMzEwMDgwNTU1NDM6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODoz
LjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5
YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy15b2N0by1jYWlyby00
MDoyMDEzMTAwODE4NTkyNzppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6
Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3
MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXF1YW50YWwtaW5uLTE3OjIwMTMxMDA4
MDU1NTM3OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZl
MDVmYjYwZWJlNjgwYWYvZG1lc2ctcXVhbnRhbC13YWltZWEtMjoyMDEzMTAwODEzNTgyMzpp
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGVi
ZTY4MGFmL2RtZXNnLXlvY3RvLWxrcC10dDAyLTY6MjAxMzEwMDcyMDMxNDI6aTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9k
bWVzZy15b2N0by1pbm4tMjg6MjAxMzEwMDgwNjAxMjU6aTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
ZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy15b2N0by13
YWltZWEtMzoyMDEzMTAwODEzNTgzOTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIu
MC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUw
NmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXlvY3RvLWxrcC10dDAyLTIx
OjIwMTMxMDA4MDkzMDMxOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNDoy
OTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcx
MzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2ctcXVhbnRhbC1zbmItMjA6MjAxMzEwMDgw
NTU1MzU6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUw
NWZiNjBlYmU2ODBhZi9kbWVzZy15b2N0by1zbmItMzI6MjAxMzEwMDgxODU5MTk6aTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBh
Zi9kbWVzZy15b2N0by1zdG9ha2xleS03OjIwMTMxMDA4MDYwMTI5OmkzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2ct
cXVhbnRhbC13YWltZWEtMTE6MjAxMzEwMDgxMzU4MTM6aTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
ZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVzZy15b2N0by14
cHMtMToyMDEzMTAwODEzNTc0MTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1y
YzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0
NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXF1YW50YWwtbGtwLXN0MDEtMjoy
MDEzMTAwODA1NTUzOTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMx
NzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTc6MjAxMzEwMDgw
NTU1NDI6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUw
NWZiNjBlYmU2ODBhZi9kbWVzZy15b2N0by1sa3Atc3QwMS0xMToyMDEzMTAwODA2MDAzNjpp
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGVi
ZTY4MGFmL2RtZXNnLXF1YW50YWwtc25iLTc6MjAxMzEwMDgwNTU1NDQ6aTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
MDA5LTEwMDgvZDBlNjM5YzllMDZkNDRlNzEzMTcwMDMxZmUwNWZiNjBlYmU2ODBhZi9kbWVz
Zy1xdWFudGFsLWpha2V0b3duLTQwOjIwMTMxMDA4MDU1NTQ2OmkzODYtcmFuZGNvbmZpZy1p
MDA5LTEwMDg6My4xMi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0x
MDA4L2QwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2ctcXVh
bnRhbC1sa3AtdHQwMi0yMDoyMDEzMTAwNzIwMjYyNzppMzg2LXJhbmRjb25maWctaTAwOS0x
MDA4OjMuMTIuMC1yYzQ6Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9k
MGU2MzljOWUwNmQ0NGU3MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXlvY3RvLWxr
cC10dDAyLTExOjIwMTMxMDA3MjAzMjM0OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4x
Mi4wLXJjNDoyOTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2QwZTYzOWM5
ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYvZG1lc2cteW9jdG8tbGtwLXR0MDIt
OToyMDEzMTAwNzIwMzEzMzppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQ6
Mjk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9kMGU2MzljOWUwNmQ0NGU3
MTMxNzAwMzFmZTA1ZmI2MGViZTY4MGFmL2RtZXNnLXF1YW50YWwtY2Fpcm8tMjc6MjAxMzEw
MDgxODU5MTk6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0OjI5NQowOjc5
OjgwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIw
ICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0
IGQwZTYzOWM5ZTA2ZDQ0ZTcxMzE3MDAzMWZlMDVmYjYwZWJlNjgwYWYKZ2l0IGNoZWNrb3V0
IHYzLjExClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGQwZTYzOWMuLi4gTGludXggMy4x
Mi1yYzQKSEVBRCBpcyBub3cgYXQgNmU0NjY0NS4uLiBMaW51eCAzLjExCmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L3RpcDpt
YXN0ZXI6NmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZTpiaXNlY3Qt
dXNiCgoyMDEzLTEwLTA4LTIxOjQ4OjIyIDZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3
MGE5NGMxOTIxM2UgY29tcGlsaW5nCjI2MCByZWFsICAxNzY1IHVzZXIgIDE1MiBzeXMgIDcz
NS4yMyUgY3B1IAlpMzg2LXJhbmRjb25maWctaTAwOS0xMDA4CgoyMDEzLTEwLTA4LTIxOjUy
OjU0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC4gVEVTVCBGQUlMVVJFClsgICAgMS44
MTc1NjBdIE5ldFNjNTIwIGZsYXNoIGRldmljZTogMHgxMDAwMDAgYXQgMHgyMDAwMDAKWyAg
ICAxLjgxODU5NV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAg
MS44MTk1NzFdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgYXJjaC94ODYvbW0vaW9yZW1h
cC5jOjEwMiBfX2lvcmVtYXBfY2FsbGVyKzB4MTNmLzB4M2YwKCkKWyAgICAxLjgyMTQ2Ml0g
Q1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTEuMCAjNTcyClsg
ICAgMS44MjI2MDFdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAx
LzAxLzIwMTEKWyAgICAxLjgyMzcyN10gIDAwMDAwMDAwIDAwMDAwMDAwIGNkOGQzZTM0IGMw
ZGVjMzljIGNkOGQzZTY0IGMwMjNjODg1IGMxMWMzYzM4IDAwMDAwMDAwClsgICAgMS44MjYw
MDRdICAwMDAwMDAwMSBjMTFjMmQyYyAwMDAwMDA2NiBjMDIyZjBjZiBjMDIyZjBjZiAwMDAw
MDIwMCAwMDAwMDAwMSAwMDAwMDAwMQpbICAgIDEuODI4MjQ5XSAgY2Q4ZDNlNzQgYzAyM2M5
NzIgMDAwMDAwMDkgMDAwMDAwMDAgY2Q4ZDNlYzggYzAyMmYwY2YgY2Q4ZDNlYjQgMDAwMDAy
NDYKWyAgICAxLjgzMDUwOV0gQ2FsbCBUcmFjZToKWyAgICAxLjgzMTE4Ml0gIFs8YzBkZWMz
OWM+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAgIDEuODMyMTE5XSAgWzxjMDIzYzg4NT5d
IHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NzUvMHg5MApbICAgIDEuODMzMTg0XSAgWzxjMDIy
ZjBjZj5dID8gX19pb3JlbWFwX2NhbGxlcisweDEzZi8weDNmMApbICAgIDEuODM0MjQxXSAg
WzxjMDIyZjBjZj5dID8gX19pb3JlbWFwX2NhbGxlcisweDEzZi8weDNmMApbICAgIDEuODM1
MzAwXSAgWzxjMDIzYzk3Mj5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDIyLzB4MzAKWyAgICAx
LjgzNjM0M10gIFs8YzAyMmYwY2Y+XSBfX2lvcmVtYXBfY2FsbGVyKzB4MTNmLzB4M2YwClsg
ICAgMS44MzczNzJdICBbPGMwZGQ0YWU0Pl0gPyBwcmludGsrMHgzZC8weDNmClsgICAgMS44
MzgyODddICBbPGMxNTNjNjk5Pl0gPyBpbml0X3NjNTIwY2RwKzB4MjE2LzB4MjE2ClsgICAg
MS44MzkzMTNdICBbPGMwMjJmM2M5Pl0gaW9yZW1hcF9ub2NhY2hlKzB4MTkvMHgyMApbICAg
IDEuODQwMzA4XSAgWzxjMTUzYzZkZD5dID8gaW5pdF9uZXRzYzUyMCsweDQ0LzB4ZjYKWyAg
ICAxLjg0MTMwM10gIFs8YzE1M2M2ZGQ+XSBpbml0X25ldHNjNTIwKzB4NDQvMHhmNgpbICAg
IDEuODQyMjc0XSAgWzxjMTRmN2JjOD5dIGRvX29uZV9pbml0Y2FsbCsweDEwNi8weDFjZQpb
ICAgIDEuODQzMzEwXSAgWzxjMDM2MzFjMD5dID8gcHJvY19yZWdpc3RlcisweDYwLzB4MTUw
ClsgICAgMS44NDQzMjJdICBbPGMwMzYzMDZiPl0gPyBfX3Byb2NfY3JlYXRlKzB4OWIvMHhk
MApbICAgIDEuODQ1MzMxXSAgWzxjMTRmNzUwMD5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgz
LzB4NTEKWyAgICAxLjg0NjM3N10gIFs8YzAyNThmYjY+XSA/IHBhcnNlX2FyZ3MrMHgyOTYv
MHg0YjAKWyAgICAxLjg0NzM3MF0gIFs8YzE0ZjdkYzA+XSBrZXJuZWxfaW5pdF9mcmVlYWJs
ZSsweDEzMC8weDFjMgpbICAgIDEuODQ4NDQ5XSAgWzxjMTRmNzRmZD5dID8gZG9fZWFybHlf
cGFyYW0rMHg3OC8weDc4ClsgICAgMS44NDk0NjBdICBbPGMwZGNmNGEwPl0ga2VybmVsX2lu
aXQrMHgxMC8weDE0MApbICAgIDEuODUwNDI3XSAgWzxjMGRmN2IzYj5dIHJldF9mcm9tX2tl
cm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAgMS44NTE1MDhdICBbPGMwZGNmNDkwPl0gPyBy
ZXN0X2luaXQrMHg4MC8weDgwClsgICAgMS44NTI0NTVdIC0tLVsgZW5kIHRyYWNlIDgzZGNi
ZmQ3ZmZlNTA2MWMgXS0tLQpbICAgIDEuODU1MjA0XSBDcmVhdGluZyA0IE1URCBwYXJ0aXRp
b25zIG9uICJuZXRzYzUyMCBGbGFzaCBCYW5rIjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1l
c2ctcXVhbnRhbC1zbmItMjc6MjAxMzEwMDgyMTUzMDg6aTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwODozLjExLjA6NTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC82ZTQ2
NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwtc25i
LTQyOjIwMTMxMDA4MjE1MzExOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMS4wOjU3
MgowOjI6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtUkVQRUFUIENPVU5U
OiAyMCAgIyAvY2Mvd2ZnL3VzYi1iaXNlY3QvLnJlcGVhdBtbMG0KCmJpc2VjdDogYmFkIGNv
bW1pdCB2My4xMQpnaXQgY2hlY2tvdXQgdjMuMTAKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3
YXMgNmU0NjY0NS4uLiBMaW51eCAzLjExCkhFQUQgaXMgbm93IGF0IDhiYjQ5NWUuLi4gTGlu
dXggMy4xMApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwOC90aXA6bWFzdGVyOjhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2Yz
YWM5ZjA3OWUzNzY6YmlzZWN0LXVzYgoKMjAxMy0xMC0wOC0yMTo1MzozMCA4YmI0OTVlM2Yw
MjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2IGNvbXBpbGluZwoyNTQgcmVhbCAgMTc1
OSB1c2VyICAxNTYgc3lzICA3NTIuMjUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OAoKMjAxMy0xMC0wOC0yMTo1Nzo1OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAuIFRF
U1QgRkFJTFVSRQpbICAgIDIuMTgwNDMyXSBOZXRTYzUyMCBmbGFzaCBkZXZpY2U6IDB4MTAw
MDAwIGF0IDB4MjAwMDAwClsgICAgMi4xODIwMTFdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbICAgIDIuMTgzNDcwXSBXQVJOSU5HOiBhdCBhcmNoL3g4Ni9tbS9p
b3JlbWFwLmM6MTAyIF9faW9yZW1hcF9jYWxsZXIrMHgxM2YvMHgzZjAoKQpbICAgIDIuMTg2
MDc4XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMC4wICM1
NzMKWyAgICAyLjE4Nzc5MF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9j
aHMgMDEvMDEvMjAxMQpbICAgIDIuMTg5NDY1XSAgMDAwMDAwMDAgMDAwMDAwMDAgY2Q4ZDVl
ODAgYzBkYzIzN2MgY2Q4ZDVlYTggYzAyMzY0MzkgYzExNzUwNzcgYzExNmRkMGMKWyAgICAy
LjE5Mjg4N10gIDAwMDAwMDY2IGMwMjI4YjNmIGMwMjI4YjNmIDAwMDAwMjAwIDAwMDAwMDAx
IDAwMDAwMDAxIGNkOGQ1ZWI4IGMwMjM2NTIyClsgICAgMi4xOTYzMzJdICAwMDAwMDAwOSAw
MDAwMDAwMCBjZDhkNWYwYyBjMDIyOGIzZiBjZDhkNWVmOCAwMDAwMDI0NiAwMDAwMDAwMCAw
MDAwMDAwMApbICAgIDIuMTk5NzYxXSBDYWxsIFRyYWNlOgpbICAgIDIuMjAwODI5XSAgWzxj
MGRjMjM3Yz5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICAgMi4yMDIyNjhdICBbPGMwMjM2
NDM5Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg1OS8weDcwClsgICAgMi4yMDM5MTBdICBb
PGMwMjI4YjNmPl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTNmLzB4M2YwClsgICAgMi4yMDU1
MDldICBbPGMwMjI4YjNmPl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTNmLzB4M2YwClsgICAg
Mi4yMDcxNzZdICBbPGMwMjM2NTIyPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MjIvMHgzMApb
ICAgIDIuMjA4NzI1XSAgWzxjMDIyOGIzZj5dIF9faW9yZW1hcF9jYWxsZXIrMHgxM2YvMHgz
ZjAKWyAgICAyLjIxMDMyMV0gIFs8YzBkYWFjMGU+XSA/IHByaW50aysweDNkLzB4M2YKWyAg
ICAyLjIxMTY4NV0gIFs8YzE0ZGIwYjk+XSA/IGluaXRfc2M1MjBjZHArMHgyMTYvMHgyMTYK
WyAgICAyLjIxMzIyNF0gIFs8YzAyMjhlMzk+XSBpb3JlbWFwX25vY2FjaGUrMHgxOS8weDIw
ClsgICAgMi4yMTQ3MjldICBbPGMxNGRiMGZkPl0gPyBpbml0X25ldHNjNTIwKzB4NDQvMHhm
NgpbICAgIDIuMjE2MjIxXSAgWzxjMTRkYjBmZD5dIGluaXRfbmV0c2M1MjArMHg0NC8weGY2
ClsgICAgMi4yMTc3MjRdICBbPGMxNDk3YmI1Pl0gZG9fb25lX2luaXRjYWxsKzB4ZmEvMHgx
YjUKWyAgICAyLjIxOTI0Ml0gIFs8YzE0OTdkYTA+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsw
eDEzMC8weDFjMgpbICAgIDIuMjIwODY5XSAgWzxjMTQ5NzRmYj5dID8gZG9fZWFybHlfcGFy
YW0rMHg3OC8weDc4ClsgICAgMi4yMjIzMzNdICBbPGMwZGE1OGMwPl0ga2VybmVsX2luaXQr
MHgxMC8weDE0MApbICAgIDIuMjIzNTYzXSAgWzxjMGRjYzU3Yj5dIHJldF9mcm9tX2tlcm5l
bF90aHJlYWQrMHgxYi8weDMwClsgICAgMi4yMjQ5NDZdICBbPGMwZGE1OGIwPl0gPyByZXN0
X2luaXQrMHg4MC8weDgwClsgICAgMi4yMjYzMzZdIC0tLVsgZW5kIHRyYWNlIGExZTlmNTBj
YmY5MzQ1NmIgXS0tLQpbICAgIDIuMjI5MzM1XSBDcmVhdGluZyA0IE1URCBwYXJ0aXRpb25z
IG9uICJuZXRzYzUyMCBGbGFzaCBCYW5rIjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ct
cXVhbnRhbC1sa3Atc3QwMS04OjIwMTMxMDA4MjE1ODEwOmkzODYtcmFuZGNvbmZpZy1pMDA5
LTEwMDg6My4xMC4wOjU3Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOGJi
NDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1hdGhl
bnMtMzM6MjAxMzEwMDgyMTU4MDg6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEwLjA6
NTczCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC84YmI0OTVlM2YwMjQwMWVl
NmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLXdhaW1lYS0xMzoyMDEzMTAw
OTA1NTQ1NjppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTAuMDo1NzMKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2Yz
YWM5ZjA3OWUzNzYvZG1lc2ctcXVhbnRhbC1jYWlyby02OjIwMTMxMDA4MjE1ODE3OmkzODYt
cmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMC4wOjU3Mwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDgvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9k
bWVzZy1xdWFudGFsLWpha2V0b3duLTQ2OjIwMTMxMDA4MjE1ODE4OmkzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDg6My4xMC4wOjU3Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDgvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy1xdWFu
dGFsLXhwcy01OjIwMTMxMDA5MDU1NDI2OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4x
MC4wOjU3Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOGJiNDk1ZTNmMDI0
MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1hdGhlbnMtMjQ6MjAx
MzEwMDgyMTU4MTc6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEwLjA6NTczCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFk
NzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLWpha2V0b3duLTM0OjIwMTMxMDA4MjE1ODEz
OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMC4wOjU3Mwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDgvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5
ZTM3Ni9kbWVzZy15b2N0by1sa3AtdHQwMi0xMToyMDEzMTAwODEyMjkxODppMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4OjMuMTAuMDo1NzMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ct
eW9jdG8td2FpbWVhLTEzOjIwMTMxMDA5MDU1NTA2OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDg6My4xMC4wOjU3Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOGJiNDk1
ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1hdGhlbnMt
NDg6MjAxMzEwMDgyMTU4MjE6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEwLjA6NTcz
CjA6MTE6MTEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VO
VDogMjAgICMgL2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBj
b21taXQgdjMuMTAKZ2l0IGNoZWNrb3V0IHYzLjkKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3
YXMgOGJiNDk1ZS4uLiBMaW51eCAzLjEwCkhFQUQgaXMgbm93IGF0IGMxYmU1YTUuLi4gTGlu
dXggMy45CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4L3RpcDptYXN0ZXI6YzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2
NmRhZmEyNGFkMTpiaXNlY3QtdXNiCgoyMDEzLTEwLTA4LTIxOjU4OjM0IGMxYmU1YTViMWIz
NTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEgY29tcGlsaW5nCjIzNyByZWFsICAxNzA5
IHVzZXIgIDE1MyBzeXMgIDc4NC4wOSUgY3B1IAlpMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
CgoyMDEzLTEwLTA4LTIyOjAyOjQ0IGRldGVjdGluZyBib290IHN0YXRlIDMuOS4wLiBURVNU
IEZBSUxVUkUKWyAgICAyLjExMDk5Nl0gTmV0U2M1MjAgZmxhc2ggZGV2aWNlOiAweDEwMDAw
MCBhdCAweDIwMDAwMApbICAgIDIuMTEyNTkxXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KWyAgICAyLjExNDA5Ml0gV0FSTklORzogYXQgYXJjaC94ODYvbW0vaW9y
ZW1hcC5jOjEwMiBfX2lvcmVtYXBfY2FsbGVyKzB4MTNmLzB4M2YwKCkKWyAgICAyLjExNjc3
M10gSGFyZHdhcmUgbmFtZTogQm9jaHMKWyAgICAyLjExODAwOV0gUGlkOiAxLCBjb21tOiBz
d2FwcGVyIE5vdCB0YWludGVkIDMuOS4wICM1NzQKWyAgICAyLjExOTYxOF0gQ2FsbCBUcmFj
ZToKWyAgICAyLjEyMDY5Ml0gIFs8YzAyMzczNjc+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisw
eDY3LzB4OTAKWyAgICAyLjEyMjI5NF0gIFs8YzAyMjk1NmY+XSA/IF9faW9yZW1hcF9jYWxs
ZXIrMHgxM2YvMHgzZjAKWyAgICAyLjEyMzkzM10gIFs8YzAyMjk1NmY+XSA/IF9faW9yZW1h
cF9jYWxsZXIrMHgxM2YvMHgzZjAKWyAgICAyLjEyNTU0N10gIFs8YzAyMzc0NjI+XSB3YXJu
X3Nsb3dwYXRoX251bGwrMHgyMi8weDMwClsgICAgMi4xMjcxNDNdICBbPGMwMjI5NTZmPl0g
X19pb3JlbWFwX2NhbGxlcisweDEzZi8weDNmMApbICAgIDIuMTI4NzM4XSAgWzxjMGQ4M2Uy
Mz5dID8gcHJpbnRrKzB4M2QvMHgzZgpbICAgIDIuMTMwMTYzXSAgWzxjMTQ4MmU4Zj5dID8g
aW5pdF9zYzUyMGNkcCsweDIxNi8weDIxNgpbICAgIDIuMTMxNzI4XSAgWzxjMDIyOTg2OT5d
IGlvcmVtYXBfbm9jYWNoZSsweDE5LzB4MjAKWyAgICAyLjEzMzI2NV0gIFs8YzE0ODJlZDM+
XSA/IGluaXRfbmV0c2M1MjArMHg0NC8weGY2ClsgICAgMi4xMzQ3OTNdICBbPGMxNDgyZWQz
Pl0gaW5pdF9uZXRzYzUyMCsweDQ0LzB4ZjYKWyAgICAyLjEzNjI3Nl0gIFs8YzE0NTlhYzM+
XSBkb19vbmVfaW5pdGNhbGwrMHg3ZS8weDEyYgpbICAgIDIuMTM3ODkyXSAgWzxjMTQ1OWNh
MD5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTMwLzB4MWMyClsgICAgMi4xMzk1MzldICBb
PGMxNDU5NGZiPl0gPyBkb19lYXJseV9wYXJhbSsweDc4LzB4NzgKWyAgICAyLjE0MTEwMV0g
IFs8YzBkN2ViZTA+XSBrZXJuZWxfaW5pdCsweDEwLzB4MTQwClsgICAgMi4xNDI1NDJdICBb
PGMwZGE2MmZiPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAgICAyLjE0
NDE5N10gIFs8YzBkN2ViZDA+XSA/IHJlc3RfaW5pdCsweDcwLzB4NzAKWyAgICAyLjE0NTY1
N10gLS0tWyBlbmQgdHJhY2UgMzA2MzQwY2VlOTQ4NDNiNiBdLS0tClsgICAgMi4xNDg3OTJd
IENyZWF0aW5nIDQgTVREIHBhcnRpdGlvbnMgb24gIm5ldHNjNTIwIEZsYXNoIEJhbmsiOgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3
OWNjOTc5ZWI2NmRhZmEyNGFkMS9kbWVzZy1xdWFudGFsLWNhaXJvLTIwOjIwMTMxMDA4MjIw
MjU2OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My45LjA6NTc0Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwOC9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFm
YTI0YWQxL2RtZXNnLXlvY3RvLWF0aGVucy04OjIwMTMxMDA4MjIwMjU2OmkzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDg6My45LjA6NTc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwOC9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxL2RtZXNnLXlv
Y3RvLXdhaW1lYS0zOjIwMTMxMDA5MDU1OTQ2OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6
My45LjA6NTc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9jMWJlNWE1YjFi
MzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxL2RtZXNnLXlvY3RvLXhpYW4tMzQ6MjAx
MzEwMDgyMjAyNTQ6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjkuMDo1NzQKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2MxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3
OWViNjZkYWZhMjRhZDEvZG1lc2ctcXVhbnRhbC14aWFuLTIzOjIwMTMxMDA4MjIwMzEwOmkz
ODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My45LjA6NTc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwOC9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQx
L2RtZXNnLXlvY3RvLWxrcC10dDAyLTI0OjIwMTMxMDA4MTIzNDEzOmkzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDg6My45LjA6NTc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxL2RtZXNnLXlvY3Rv
LXdhaW1lYS0zOjIwMTMxMDA5MDU1OTU3OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My45
LjA6NTc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9jMWJlNWE1YjFiMzU1
ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxL2RtZXNnLXF1YW50YWwtYXRoZW5zLTQzOjIw
MTMxMDA4MjIwMzEwOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My45LjA6NTc0Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5
NzllYjY2ZGFmYTI0YWQxL2RtZXNnLXlvY3RvLWpha2V0b3duLTI1OjIwMTMxMDA4MjIwMzA5
OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My45LjA6NTc0CjA6OTo5IGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvdXNi
LWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjkKZ2l0IGNoZWNr
b3V0IHYzLjgKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYzFiZTVhNS4uLiBMaW51eCAz
LjkKSEVBRCBpcyBub3cgYXQgMTlmOTQ5Zi4uLiBMaW51eCAzLjgKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvdGlwOm1hc3Rl
cjoxOWY5NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwOmJpc2VjdC11c2IK
CjIwMTMtMTAtMDgtMjI6MDM6MTkgMTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2FjNmJlMTRi
ZmNiMTIwMCBjb21waWxpbmcKMjI0IHJlYWwgIDE1ODQgdXNlciAgMTQ0IHN5cyAgNzcwLjc0
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgKCjIwMTMtMTAtMDgtMjI6MDc6MTYg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy44LjAuLi4gVEVTVCBGQUlMVVJFClsgICAgMS45Mjgx
MzhdIE5ldFNjNTIwIGZsYXNoIGRldmljZTogMHgxMDAwMDAgYXQgMHgyMDAwMDAKWyAgICAx
LjkyOTcxMF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMS45
MzExNjFdIFdBUk5JTkc6IGF0IGFyY2gveDg2L21tL2lvcmVtYXAuYzoxMDIgX19pb3JlbWFw
X2NhbGxlcisweDEyNy8weDNlMCgpClsgICAgMS45MzM3OTZdIEhhcmR3YXJlIG5hbWU6IEJv
Y2hzClsgICAgMS45MzQ5NTRdIFBpZDogMSwgY29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAz
LjguMCAjNTc1ClsgICAgMS45MzY1OTVdIENhbGwgVHJhY2U6ClsgICAgMS45Mzc2MDldICBb
PGMwMjM2MzE3Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg2Ny8weDkwClsgICAgMS45Mzky
MDBdICBbPGMwMjI5MzQ3Pl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3LzB4M2UwClsgICAg
MS45NDA4MzldICBbPGMwMjI5MzQ3Pl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3LzB4M2Uw
ClsgICAgMS45NDI0MTFdICBbPGMwMjM2NDEyPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MjIv
MHgzMApbICAgIDEuOTQzOTk2XSAgWzxjMDIyOTM0Nz5dIF9faW9yZW1hcF9jYWxsZXIrMHgx
MjcvMHgzZTAKWyAgICAxLjk0NTU1M10gIFs8YzBjZGM0ZmI+XSA/IHByaW50aysweDNkLzB4
M2YKWyAgICAxLjk0NzAxMF0gIFs8YzEzN2Y1NTc+XSA/IGluaXRfc2M1MjBjZHArMHgyMTIv
MHgyMTIKWyAgICAxLjk0ODU1Ml0gIFs8YzAyMjk2NDk+XSBpb3JlbWFwX25vY2FjaGUrMHgx
OS8weDIwClsgICAgMS45NTAwNjNdICBbPGMxMzdmNTliPl0gPyBpbml0X25ldHNjNTIwKzB4
NDQvMHhmNgpbICAgIDEuOTUxNTYzXSAgWzxjMTM3ZjU5Yj5dIGluaXRfbmV0c2M1MjArMHg0
NC8weGY2ClsgICAgMS45NTMwNDddICBbPGMxMzU3OWVjPl0gZG9fb25lX2luaXRjYWxsKzB4
N2UvMHgxMmIKWyAgICAxLjk1NDU1NF0gIFs8YzEzNTdiYzk+XSBrZXJuZWxfaW5pdF9mcmVl
YWJsZSsweDEzMC8weDFiZApbICAgIDEuOTU2MjE0XSAgWzxjMTM1NzQ0Yz5dID8gZG9fZWFy
bHlfcGFyYW0rMHg3OC8weDc4ClsgICAgMS45NTc3NTVdICBbPGMwY2Q5YWEwPl0ga2VybmVs
X2luaXQrMHgxMC8weDE0MApbICAgIDEuOTU5MjE1XSAgWzxjMGNmZTAzYj5dIHJldF9mcm9t
X2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAgMS45NjA4ODNdICBbPGMwY2Q5YTkwPl0g
PyByZXN0X2luaXQrMHg3MC8weDcwClsgICAgMS45NjIzMTldIC0tLVsgZW5kIHRyYWNlIGE0
YzQ0YzhkZTI4NzAxMWIgXS0tLQpbICAgIDEuOTY1MzQwXSBDcmVhdGluZyA0IE1URCBwYXJ0
aXRpb25zIG9uICJuZXRzYzUyMCBGbGFzaCBCYW5rIjoKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4LzE5Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAv
ZG1lc2ctcXVhbnRhbC1hdGhlbnMtNDE6MjAxMzEwMDgyMjA4Mjk6aTM4Ni1yYW5kY29uZmln
LWkwMDktMTAwODozLjguMDo1NzUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
LzE5Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAvZG1lc2ctcXVhbnRh
bC1jYWlyby00NzoyMDEzMTAwODIyMDg0MTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMu
OC4wOjU3NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvMTlmOTQ5ZjUyNTk5
YmE3YzNmNjdhNTg5N2FjNmJlMTRiZmNiMTIwMC9kbWVzZy1xdWFudGFsLWlubi0zNzoyMDEz
MTAwODIyMDgzOTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuOC4wOjU3NQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvMTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2Fj
NmJlMTRiZmNiMTIwMC9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTIyOjIwMTMxMDA4MTIzOTQ1
OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My44LjA6NTc1CjA6NDoxIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuOApnaXQgY2hlY2tvdXQg
djMuNwpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAxOWY5NDlmLi4uIExpbnV4IDMuOApI
RUFEIGlzIG5vdyBhdCAyOTU5NDQwLi4uIExpbnV4IDMuNwpscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC90aXA6bWFzdGVyOjI5
NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGU6YmlzZWN0LXVzYgoKMjAx
My0xMC0wOC0yMjowODo1MyAyOTU5NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBj
NjBlIGNvbXBpbGluZwoyMTcgcmVhbCAgMTU0OSB1c2VyICAxNDggc3lzICA3ODEuODAlIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOAoKMjAxMy0xMC0wOC0yMjoxMjo0MSBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjcuMC4gVEVTVCBGQUlMVVJFClsgICAgMS44MzU2NjJdIE5l
dFNjNTIwIGZsYXNoIGRldmljZTogMHgxMDAwMDAgYXQgMHgyMDAwMDAKWyAgICAxLjgzNjk1
Nl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMS44MzgxNzJd
IFdBUk5JTkc6IGF0IGFyY2gveDg2L21tL2lvcmVtYXAuYzoxMDIgX19pb3JlbWFwX2NhbGxl
cisweDEyNy8weDNlMCgpClsgICAgMS44NDAzMjVdIEhhcmR3YXJlIG5hbWU6IEJvY2hzClsg
ICAgMS44NDEzMDJdIFBpZDogMSwgY29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjcuMCAj
NTc2ClsgICAgMS44NDI2MTJdIENhbGwgVHJhY2U6ClsgICAgMS44NDM0NTRdICBbPGMwMjM2
MWI3Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg2Ny8weDkwClsgICAgMS44NDQ3NzZdICBb
PGMwMjI5MDA3Pl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3LzB4M2UwClsgICAgMS44NDYw
ODNdICBbPGMwMjI5MDA3Pl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3LzB4M2UwClsgICAg
MS44NDc0MDBdICBbPGMwMjM2MmIyPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MjIvMHgzMApb
ICAgIDEuODQ4NzA3XSAgWzxjMDIyOTAwNz5dIF9faW9yZW1hcF9jYWxsZXIrMHgxMjcvMHgz
ZTAKWyAgICAxLjg0OTk5MV0gIFs8YzBjN2ZmMzM+XSA/IHByaW50aysweDNkLzB4M2YKWyAg
ICAxLjg1MTEyOV0gIFs8YzEyZjEzNGY+XSA/IGluaXRfc2M1MjBjZHArMHgyMTIvMHgyMTIK
WyAgICAxLjg1MjQyNl0gIFs8YzAyMjkzMDk+XSBpb3JlbWFwX25vY2FjaGUrMHgxOS8weDIw
ClsgICAgMS44NTM2NjZdICBbPGMxMmYxMzkzPl0gPyBpbml0X25ldHNjNTIwKzB4NDQvMHhm
NgpbICAgIDEuODU0OTIxXSAgWzxjMTJmMTM5Mz5dIGluaXRfbmV0c2M1MjArMHg0NC8weGY2
ClsgICAgMS44NTYxMjldICBbPGMxMmM5OWVjPl0gZG9fb25lX2luaXRjYWxsKzB4N2UvMHgx
MmIKWyAgICAxLjg1NzM4N10gIFs8YzBjNDQ3N2U+XSBrZXJuZWxfaW5pdCsweDI5ZS8weDJl
MApbICAgIDEuODU4NjE2XSAgWzxjMTJjOTQ0Yz5dID8gZG9fZWFybHlfcGFyYW0rMHg3OC8w
eDc4ClsgICAgMS44NTk4NjldICBbPGMwY2EyYzliPl0gcmV0X2Zyb21fa2VybmVsX3RocmVh
ZCsweDFiLzB4MzAKWyAgICAxLjg2MTIxMV0gIFs8YzBjNDQ0ZTA+XSA/IHJlc3RfaW5pdCsw
eDcwLzB4NzAKWyAgICAxLjg2MjQyOV0gLS0tWyBlbmQgdHJhY2UgOTY3YjlhOTNlNTdkMDhi
MCBdLS0tClsgICAgMS44NjQ0NThdIENyZWF0aW5nIDQgTVREIHBhcnRpdGlvbnMgb24gIm5l
dHNjNTIwIEZsYXNoIEJhbmsiOgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
Mjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZS9kbWVzZy15b2N0by1y
b2FtLTY6MjAxMzEwMDgyMjEyNDk6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjcuMDo1
NzYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzI5NTk0NDA0ZDdmZTczY2Q4
MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGUvZG1lc2ctcXVhbnRhbC1iYXktMzoyMDEzMTAwODIy
MTMwMDppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuNy4wOjU3Ngova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pMDA5LTEwMDgvMjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUz
OTcwYzYwZS9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTIzOjIwMTMxMDA4MTI0MzU3OmkzODYt
cmFuZGNvbmZpZy1pMDA5LTEwMDg6My43LjA6NTc2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWkwMDktMTAwOC8yOTU5NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBjNjBlL2Rt
ZXNnLXlvY3RvLWJlbnMtMzoyMDEzMTAwODIyMTI1ODppMzg2LXJhbmRjb25maWctaTAwOS0x
MDA4OjMuNy4wOjU3Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvMjk1OTQ0
MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZS9kbWVzZy15b2N0by1yb2FtLTMy
OjIwMTMxMDA4MjIxMjU0OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My43LjA6NTc2Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC8yOTU5NDQwNGQ3ZmU3M2NkODBlYWE0
ZWU4YzQzZGNjNTM5NzBjNjBlL2RtZXNnLXlvY3RvLXNuYi0yMjoyMDEzMTAwODIyMTI1MTpp
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuNy4wOjU3Ngova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDgvMjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYw
ZS9kbWVzZy15b2N0by1zbmItMjoyMDEzMTAwODIyMTI1NzppMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4OjMuNy4wOjU3Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvMjk1
OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZS9kbWVzZy15b2N0by1zbmIt
Mzg6MjAxMzEwMDgyMjEyNTg6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjcuMDo1NzYK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzI5NTk0NDA0ZDdmZTczY2Q4MGVh
YTRlZThjNDNkY2M1Mzk3MGM2MGUvZG1lc2cteW9jdG8tc25iLTQyOjIwMTMxMDA4MjIxMjUy
OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My43LjA6NTc2Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwOC8yOTU5NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBj
NjBlL2RtZXNnLXlvY3RvLWxrcC10dDAyLTY6MjAxMzEwMDgxMjQ0MDU6aTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwODozLjcuMDo1NzYKMDoxMDoxMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBi
b290cwobWzE7MzVtUkVQRUFUIENPVU5UOiAyMCAgIyAvY2Mvd2ZnL3VzYi1iaXNlY3QvLnJl
cGVhdBtbMG0KCmJpc2VjdDogYmFkIGNvbW1pdCB2My43CmdpdCBjaGVja291dCB2My42ClBy
ZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDI5NTk0NDAuLi4gTGludXggMy43CkhFQUQgaXMg
bm93IGF0IGEwZDI3MWMuLi4gTGludXggMy42CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L3RpcDptYXN0ZXI6YTBkMjcxY2Jm
ZWQxZGQ1MDI3OGM2YjA2YmVhZDNkMDBiYTBhODhmOTpiaXNlY3QtdXNiCgoyMDEzLTEwLTA4
LTIyOjEzOjE2IGEwZDI3MWNiZmVkMWRkNTAyNzhjNmIwNmJlYWQzZDAwYmEwYTg4ZjkgY29t
cGlsaW5nCjIxOSByZWFsICAxNDU5IHVzZXIgIDE0MyBzeXMgIDczMS42MyUgY3B1IAlpMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4CgoyMDEzLTEwLTA4LTIyOjE3OjA2IGRldGVjdGluZyBi
b290IHN0YXRlIDMuNi4wLi4uLi4gVEVTVCBGQUlMVVJFClsgICAgMi41MjIzNzldIE5ldFNj
NTIwIGZsYXNoIGRldmljZTogMHgxMDAwMDAgYXQgMHgyMDAwMDAKWyAgICAyLjUyMzk0Nl0g
LS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMi41MjU1MDhdIFdB
Uk5JTkc6IGF0IGFyY2gveDg2L21tL2lvcmVtYXAuYzoxMDIgX19pb3JlbWFwX2NhbGxlcisw
eDEyNy8weDNlMCgpClsgICAgMi41Mjc4NDFdIEhhcmR3YXJlIG5hbWU6IEJvY2hzClsgICAg
Mi41Mjg5NDddIFBpZDogMSwgY29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjYuMCAjNTc3
ClsgICAgMi41MzAzODldIENhbGwgVHJhY2U6ClsgICAgMi41MzEzNDddICBbPGMwMjMzZjU3
Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg2Ny8weDkwClsgICAgMi41MzI4NDJdICBbPGMw
MjI3ZjA3Pl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3LzB4M2UwClsgICAgMi41MzQzMDRd
ICBbPGMwMjI3ZjA3Pl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3LzB4M2UwClsgICAgMi41
MzUyNjddICBbPGMwMjM0MDUyPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MjIvMHgzMApbICAg
IDIuNTM2MTU3XSAgWzxjMDIyN2YwNz5dIF9faW9yZW1hcF9jYWxsZXIrMHgxMjcvMHgzZTAK
WyAgICAyLjUzNzAzNl0gIFs8YzBjMWViZjE+XSA/IHByaW50aysweDNkLzB4M2YKWyAgICAy
LjUzNzgyN10gIFs8YzEyNjE5YjU+XSA/IGluaXRfc2M1MjBjZHArMHgyMTIvMHgyMTIKWyAg
ICAyLjUzODcxNV0gIFs8YzAyMjgyMDk+XSBpb3JlbWFwX25vY2FjaGUrMHgxOS8weDIwClsg
ICAgMi41Mzk1NjBdICBbPGMxMjYxOWY5Pl0gPyBpbml0X25ldHNjNTIwKzB4NDQvMHhmNgpb
ICAgIDIuNTQwNDEwXSAgWzxjMTI2MTlmOT5dIGluaXRfbmV0c2M1MjArMHg0NC8weGY2Clsg
ICAgMi41NDEyNDhdICBbPGMxMjNhOWYxPl0gZG9fb25lX2luaXRjYWxsKzB4N2UvMHgxMmIK
WyAgICAyLjU0MjExNl0gIFs8YzEyM2FiY2U+XSBrZXJuZWxfaW5pdCsweDEzMC8weDFiYQpb
ICAgIDIuNTQyOTQ1XSAgWzxjMTIzYTQ0Yz5dID8gZG9fZWFybHlfcGFyYW0rMHg3OC8weDc4
ClsgICAgMi41NDM5MTNdICBbPGMxMjNhYTllPl0gPyBkb19vbmVfaW5pdGNhbGwrMHgxMmIv
MHgxMmIKWyAgICAyLjU0NDk3NV0gIFs8YzBjNDE5ODY+XSBrZXJuZWxfdGhyZWFkX2hlbHBl
cisweDYvMHgxMApbICAgIDIuNTQ2NTM5XSAtLS1bIGVuZCB0cmFjZSA0ODQwNTJkZjFmYmYx
OTA2IF0tLS0KWyAgICAyLjU0OTYxMl0gQ3JlYXRpbmcgNCBNVEQgcGFydGl0aW9ucyBvbiAi
bmV0c2M1MjAgRmxhc2ggQmFuayI6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC9hMGQyNzFjYmZlZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5L2RtZXNnLXF1YW50
YWwtY2Fpcm8tMTk6MjAxMzEwMDgyMjE4MjM6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODoz
LjYuMDo1NzcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2EwZDI3MWNiZmVk
MWRkNTAyNzhjNmIwNmJlYWQzZDAwYmEwYTg4ZjkvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi04
OjIwMTMxMDA4MTI0OTI1OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My42LjA6NTc3Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9hMGQyNzFjYmZlZDFkZDUwMjc4YzZi
MDZiZWFkM2QwMGJhMGE4OGY5L2RtZXNnLXF1YW50YWwtcm9hbS0xOToyMDEzMTAwODIyMTgx
NjppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuNi4wOjU3Nwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDgvYTBkMjcxY2JmZWQxZGQ1MDI3OGM2YjA2YmVhZDNkMDBiYTBh
ODhmOS9kbWVzZy1xdWFudGFsLXJvYW0tMzoyMDEzMTAwODIyMTgyMDppMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4OjMuNi4wOjU3Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDgvYTBkMjcxY2JmZWQxZGQ1MDI3OGM2YjA2YmVhZDNkMDBiYTBhODhmOS9kbWVzZy1xdWFu
dGFsLXNuYi00ODoyMDEzMTAwODIyMTgyMDppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMu
Ni4wOjU3Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvYTBkMjcxY2JmZWQx
ZGQ1MDI3OGM2YjA2YmVhZDNkMDBiYTBhODhmOS9kbWVzZy1xdWFudGFsLXhwcy03OjIwMTMx
MDA5MDYxNDI5OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My42LjA6NTc3Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9hMGQyNzFjYmZlZDFkZDUwMjc4YzZiMDZiZWFk
M2QwMGJhMGE4OGY5L2RtZXNnLXlvY3RvLWlubi0xNDoyMDEzMTAwODIyMTgyODppMzg2LXJh
bmRjb25maWctaTAwOS0xMDA4OjMuNi4wOjU3Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
MDA5LTEwMDgvYTBkMjcxY2JmZWQxZGQ1MDI3OGM2YjA2YmVhZDNkMDBiYTBhODhmOS9kbWVz
Zy15b2N0by1pbm4tNDg6MjAxMzEwMDgyMjE4Mjg6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
ODozLjYuMDo1NzcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2EwZDI3MWNi
ZmVkMWRkNTAyNzhjNmIwNmJlYWQzZDAwYmEwYTg4ZjkvZG1lc2cteW9jdG8td2FpbWVhLTE0
OjIwMTMxMDA5MDYxNTA5OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My42LjA6NTc3Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9hMGQyNzFjYmZlZDFkZDUwMjc4YzZi
MDZiZWFkM2QwMGJhMGE4OGY5L2RtZXNnLXlvY3RvLXhpYW4tMjk6MjAxMzEwMDgyMjE4Mjc6
aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjYuMDo1NzcKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4L2EwZDI3MWNiZmVkMWRkNTAyNzhjNmIwNmJlYWQzZDAwYmEwYTg4
ZjkvZG1lc2cteW9jdG8teGlhbi00MDoyMDEzMTAwODIyMTgyMjppMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4OjMuNi4wOjU3Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
YTBkMjcxY2JmZWQxZGQ1MDI3OGM2YjA2YmVhZDNkMDBiYTBhODhmOS9kbWVzZy15b2N0by14
aWFuLTU6MjAxMzEwMDgyMjE4MjY6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjYuMDo1
NzcKMDoxMjoxMiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtUkVQRUFUIENP
VU5UOiAyMCAgIyAvY2Mvd2ZnL3VzYi1iaXNlY3QvLnJlcGVhdBtbMG0KCmJpc2VjdDogYmFk
IGNvbW1pdCB2My42CmdpdCBjaGVja291dCB2My41ClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIGEwZDI3MWMuLi4gTGludXggMy42CkhFQUQgaXMgbm93IGF0IDI4YTMzY2IuLi4gTGlu
dXggMy41CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4L3RpcDptYXN0ZXI6MjhhMzNjYmMyNGU0MjU2YzE0M2RjZTk2YzdkOTNi
ZjQyMzIyOWY5MjpiaXNlY3QtdXNiCgoyMDEzLTEwLTA4LTIyOjE5OjQyIDI4YTMzY2JjMjRl
NDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMyMjlmOTIgY29tcGlsaW5nCjE5MSByZWFsICAxNDM2
IHVzZXIgIDEzNyBzeXMgIDgyMy4yMSUgY3B1IAlpMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
CgoyMDEzLTEwLTA4LTIyOjIzOjA3IGRldGVjdGluZyBib290IHN0YXRlIDMuNS4wLiBURVNU
IEZBSUxVUkUKWyAgICAxLjQ4MDY5NV0gTmV0U2M1MjAgZmxhc2ggZGV2aWNlOiAweDEwMDAw
MCBhdCAweDIwMDAwMApbICAgIDEuNDgyNDgxXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KWyAgICAxLjQ4NDE1Nl0gV0FSTklORzogYXQgYXJjaC94ODYvbW0vaW9y
ZW1hcC5jOjEwMiBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3LzB4M2UwKCkKWyAgICAxLjQ4NzEy
MV0gSGFyZHdhcmUgbmFtZTogQm9jaHMKWyAgICAxLjQ4ODQ0NF0gUGlkOiAxLCBjb21tOiBz
d2FwcGVyIE5vdCB0YWludGVkIDMuNS4wICM1NzgKWyAgICAxLjQ5MDI3MF0gQ2FsbCBUcmFj
ZToKWyAgICAxLjQ5MTQwMl0gIFs8YzAyMzA1Yzc+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisw
eDY3LzB4OTAKWyAgICAxLjQ5MzIyMV0gIFs8YzAyMjQ0ZTc+XSA/IF9faW9yZW1hcF9jYWxs
ZXIrMHgxMjcvMHgzZTAKWyAgICAxLjQ5NTAyMl0gIFs8YzAyMjQ0ZTc+XSA/IF9faW9yZW1h
cF9jYWxsZXIrMHgxMjcvMHgzZTAKWyAgICAxLjQ5NjgzM10gIFs8YzAyMzA2YzI+XSB3YXJu
X3Nsb3dwYXRoX251bGwrMHgyMi8weDMwClsgICAgMS40OTg1OTddICBbPGMwMjI0NGU3Pl0g
X19pb3JlbWFwX2NhbGxlcisweDEyNy8weDNlMApbICAgIDEuNTAwMzg1XSAgWzxjMGJmZWY3
Mz5dID8gcHJpbnRrKzB4M2QvMHgzZgpbICAgIDEuNTAxOTQ3XSAgWzxjMTFlNjQ2Yz5dID8g
aW5pdF9zYzUyMGNkcCsweDIxMi8weDIxMgpbICAgIDEuNTAzNzA0XSAgWzxjMDIyNDdlOT5d
IGlvcmVtYXBfbm9jYWNoZSsweDE5LzB4MjAKWyAgICAxLjUwNTQwOF0gIFs8YzExZTY0YjA+
XSA/IGluaXRfbmV0c2M1MjArMHg0NC8weGY2ClsgICAgMS41MDcxMzVdICBbPGMxMWU2NGIw
Pl0gaW5pdF9uZXRzYzUyMCsweDQ0LzB4ZjYKWyAgICAxLjUwODc5MF0gIFs8YzExYmY5ZWY+
XSBkb19vbmVfaW5pdGNhbGwrMHg3ZS8weDEyYgpbICAgIDEuNTEwNTM2XSAgWzxjMTFiZmJj
Yz5dIGtlcm5lbF9pbml0KzB4MTMwLzB4MWJhClsgICAgMS41MTIxOTVdICBbPGMxMWJmNDRj
Pl0gPyBkb19lYXJseV9wYXJhbSsweDc4LzB4NzgKWyAgICAxLjUxMzk0NF0gIFs8YzExYmZh
OWM+XSA/IGRvX29uZV9pbml0Y2FsbCsweDEyYi8weDEyYgpbICAgIDEuNTE1NzE3XSAgWzxj
MGMyMjRlNj5dIGtlcm5lbF90aHJlYWRfaGVscGVyKzB4Ni8weDEwClsgICAgMS41MTc1MzNd
IC0tLVsgZW5kIHRyYWNlIGY4YmNhMGZlNWQ0NjNlYzIgXS0tLQpbICAgIDEuNTIwMTAwXSBD
cmVhdGluZyA0IE1URCBwYXJ0aXRpb25zIG9uICJuZXRzYzUyMCBGbGFzaCBCYW5rIjoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5
NmM3ZDkzYmY0MjMyMjlmOTIvZG1lc2cteW9jdG8tbGtwLXR0MDItMTY6MjAxMzEwMDgxMjU0
Mjc6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjUuMDo1NzgKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaTAwOS0xMDA4LzI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMy
MjlmOTIvZG1lc2cteW9jdG8tcm9hbS0xNjoyMDEzMTAwODIyMjMxODppMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4OjMuNS4wOjU3OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDgvMjhhMzNjYmMyNGU0MjU2YzE0M2RjZTk2YzdkOTNiZjQyMzIyOWY5Mi9kbWVzZy1xdWFu
dGFsLWxrcC10dDAyLTExOjIwMTMxMDA4MTI1NDM2OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDg6My41LjA6NTc4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC8yOGEzM2Ni
YzI0ZTQyNTZjMTQzZGNlOTZjN2Q5M2JmNDIzMjI5ZjkyL2RtZXNnLXF1YW50YWwtcm9hbS02
OjIwMTMxMDA4MjIyMzMyOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My41LjA6NTc4Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC8yOGEzM2NiYzI0ZTQyNTZjMTQzZGNl
OTZjN2Q5M2JmNDIzMjI5ZjkyL2RtZXNnLXlvY3RvLW5obTQtMzoyMDEzMTAwODE0MjgzNTpp
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuNS4wOjU3OAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDgvMjhhMzNjYmMyNGU0MjU2YzE0M2RjZTk2YzdkOTNiZjQyMzIyOWY5
Mi9kbWVzZy15b2N0by1yb2FtLTMxOjIwMTMxMDA4MjIyMzMxOmkzODYtcmFuZGNvbmZpZy1p
MDA5LTEwMDg6My41LjA6NTc4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC8y
OGEzM2NiYzI0ZTQyNTZjMTQzZGNlOTZjN2Q5M2JmNDIzMjI5ZjkyL2RtZXNnLXF1YW50YWwt
cm9hbS0yNToyMDEzMTAwODIyMjMzNzppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuNS4w
OjU3OAowOjc6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29t
bWl0IHYzLjUKZ2l0IGNoZWNrb3V0IHYzLjQKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMg
MjhhMzNjYi4uLiBMaW51eCAzLjUKSEVBRCBpcyBub3cgYXQgNzZlMTBkMS4uLiBMaW51eCAz
LjQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1p
MDA5LTEwMDgvdGlwOm1hc3Rlcjo3NmUxMGQxNThlZmI2ZDQ1MTYwMTg4NDZmNjBjMmFiNTUw
MTkwMGJjOmJpc2VjdC11c2IKCjIwMTMtMTAtMDgtMjI6MjM6NDIgNzZlMTBkMTU4ZWZiNmQ0
NTE2MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiYyBjb21waWxpbmcKMjA4IHJlYWwgIDEzNzUgdXNl
ciAgMTMxIHN5cyAgNzIyLjMxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgKCjIw
MTMtMTAtMDgtMjI6Mjc6MTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy40LjAuLi4gVEVTVCBG
QUlMVVJFClsgICAgMi41MDAxMzddIE5ldFNjNTIwIGZsYXNoIGRldmljZTogMHgxMDAwMDAg
YXQgMHgyMDAwMDAKWyAgICAyLjUwMTY4Ml0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0t
LS0tLS0tLS0tClsgICAgMi41MDMwNjNdIFdBUk5JTkc6IGF0IGFyY2gveDg2L21tL2lvcmVt
YXAuYzoxMDIgX19pb3JlbWFwX2NhbGxlcisweDEyNy8weDNlMCgpClsgICAgMi41MDU1NThd
IEhhcmR3YXJlIG5hbWU6IEJvY2hzClsgICAgMi41MDY2NzhdIFBpZDogMSwgY29tbTogc3dh
cHBlciBOb3QgdGFpbnRlZCAzLjQuMCAjNTc5ClsgICAgMi41MDgyMDJdIENhbGwgVHJhY2U6
ClsgICAgMi41MDkxNjddICBbPGMwYmIxMDRlPl0gPyBwcmludGsrMHgxZC8weDFmClsgICAg
Mi41MTA0NDhdICBbPGMwMjJlZGM3Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg2Ny8weDkw
ClsgICAgMi41MTIwMjldICBbPGMwMjIyZTU3Pl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3
LzB4M2UwClsgICAgMi41MTM1NTVdICBbPGMwMjIyZTU3Pl0gPyBfX2lvcmVtYXBfY2FsbGVy
KzB4MTI3LzB4M2UwClsgICAgMi41MTUwNDldICBbPGMwMjJlZWMyPl0gd2Fybl9zbG93cGF0
aF9udWxsKzB4MjIvMHgzMApbICAgIDIuNTE2NDYzXSAgWzxjMDIyMmU1Nz5dIF9faW9yZW1h
cF9jYWxsZXIrMHgxMjcvMHgzZTAKWyAgICAyLjUxNzk4N10gIFs8YzExNThkNjI+XSA/IGlu
aXRfc2M1MjBjZHArMHgyMTIvMHgyMTIKWyAgICAyLjUxOTQ4NV0gIFs8YzAyMjMxNTk+XSBp
b3JlbWFwX25vY2FjaGUrMHgxOS8weDIwClsgICAgMi41MjA5MTRdICBbPGMxMTU4ZGE2Pl0g
PyBpbml0X25ldHNjNTIwKzB4NDQvMHhmNgpbICAgIDIuNTIyMzI0XSAgWzxjMTE1OGRhNj5d
IGluaXRfbmV0c2M1MjArMHg0NC8weGY2ClsgICAgMi41MjM3MDVdICBbPGMxMTMyN2EzPl0g
ZG9fb25lX2luaXRjYWxsKzB4N2UvMHgxMmIKWyAgICAyLjUyNTE3M10gIFs8YzExMzI5NzY+
XSBrZXJuZWxfaW5pdCsweDEyNi8weDFiMApbICAgIDIuNTI2NTkxXSAgWzxjMTEzMjFmNj5d
ID8gZG9fZWFybHlfcGFyYW0rMHg3OC8weDc4ClsgICAgMi41MjgwMTBdICBbPGMxMTMyODUw
Pl0gPyBkb19vbmVfaW5pdGNhbGwrMHgxMmIvMHgxMmIKWyAgICAyLjUyOTQ2Ml0gIFs8YzBi
ZDQ0NDY+XSBrZXJuZWxfdGhyZWFkX2hlbHBlcisweDYvMHgxMApbICAgIDIuNTMwOTc5XSAt
LS1bIGVuZCB0cmFjZSA0OGY4ZjRkNDVkYzA5OWU4IF0tLS0KWyAgICAyLjUzMzk0NV0gQ3Jl
YXRpbmcgNCBNVEQgcGFydGl0aW9ucyBvbiAibmV0c2M1MjAgRmxhc2ggQmFuayI6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC83NmUxMGQxNThlZmI2ZDQ1MTYwMTg4NDZm
NjBjMmFiNTUwMTkwMGJjL2RtZXNnLXF1YW50YWwtYXRoZW5zLTI0OjIwMTMxMDA4MjIyODMx
OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My40LjA6NTc5Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwOC83NmUxMGQxNThlZmI2ZDQ1MTYwMTg4NDZmNjBjMmFiNTUwMTkw
MGJjL2RtZXNnLXF1YW50YWwtc25iLTU6MjAxMzEwMDgyMjI4MzE6aTM4Ni1yYW5kY29uZmln
LWkwMDktMTAwODozLjQuMDo1NzkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
Lzc2ZTEwZDE1OGVmYjZkNDUxNjAxODg0NmY2MGMyYWI1NTAxOTAwYmMvZG1lc2ctcXVhbnRh
bC1sa3AtdHQwMi0xMzoyMDEzMTAwODEyNTkzOTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
OjMuNC4wOjU3OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvNzZlMTBkMTU4
ZWZiNmQ0NTE2MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiYy9kbWVzZy1xdWFudGFsLXN0b2FrbGV5
LTM6MjAxMzEwMDgyMjI4MzU6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjQuMDo1NzkK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4Lzc2ZTEwZDE1OGVmYjZkNDUxNjAx
ODg0NmY2MGMyYWI1NTAxOTAwYmMvZG1lc2ctcXVhbnRhbC1hdGhlbnMtNDI6MjAxMzEwMDgy
MjI4MzU6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjQuMDo1NzkKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4Lzc2ZTEwZDE1OGVmYjZkNDUxNjAxODg0NmY2MGMyYWI1
NTAxOTAwYmMvZG1lc2ctcXVhbnRhbC1iYXktNDoyMDEzMTAwODIyMjg0NTppMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4OjMuNC4wOjU3OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5
LTEwMDgvNzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiYy9kbWVzZy1x
dWFudGFsLXhwcy00OjIwMTMxMDA5MDYyNDQ4OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6
My40LjA6NTc5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC83NmUxMGQxNThl
ZmI2ZDQ1MTYwMTg4NDZmNjBjMmFiNTUwMTkwMGJjL2RtZXNnLXlvY3RvLWNhaXJvLTQ2OjIw
MTMxMDA4MjIyODM5OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My40LjA6NTc5Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC83NmUxMGQxNThlZmI2ZDQ1MTYwMTg4NDZm
NjBjMmFiNTUwMTkwMGJjL2RtZXNnLXlvY3RvLWxrcC10dDAyLTE3OjIwMTMxMDA4MTI1OTUw
OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My40LjA6NTc5Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwOC83NmUxMGQxNThlZmI2ZDQ1MTYwMTg4NDZmNjBjMmFiNTUwMTkw
MGJjL2RtZXNnLXlvY3RvLXNuYi0xOToyMDEzMTAwODIyMjg0NDppMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4OjMuNC4wOjU3OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
NzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiYy9kbWVzZy15b2N0by1z
bmItNToyMDEzMTAwODIyMjgzOTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuNC4wOjU3
OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvNzZlMTBkMTU4ZWZiNmQ0NTE2
MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiYy9kbWVzZy15b2N0by14cHMtMToyMDEzMTAwOTA2MjQ1
NTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuNC4wOjU3OQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDgvNzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYwYzJhYjU1MDE5
MDBiYy9kbWVzZy1xdWFudGFsLWNhaXJvLTEwOjIwMTMxMDA4MjIyODQ3OmkzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDg6My40LjA6NTc5CjA6MTM6MTEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My40CmdpdCBjaGVja291dCB2My4zClByZXZp
b3VzIEhFQUQgcG9zaXRpb24gd2FzIDc2ZTEwZDEuLi4gTGludXggMy40CkhFQUQgaXMgbm93
IGF0IGMxNmZhNGYuLi4gTGludXggMy4zCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L3RpcDptYXN0ZXI6YzE2ZmE0ZjJhZDE5
OTA4YTQ3YzYzZDhmYTQzNmExMTc4NDM4YzdlNzpiaXNlY3QtdXNiCgoyMDEzLTEwLTA4LTIy
OjI4OjU1IGMxNmZhNGYyYWQxOTkwOGE0N2M2M2Q4ZmE0MzZhMTE3ODQzOGM3ZTcgY29tcGls
aW5nCjE5NiByZWFsICAxNDEyIHVzZXIgIDEzNiBzeXMgIDc4Ni43NyUgY3B1IAlpMzg2LXJh
bmRjb25maWctaTAwOS0xMDA4CgoyMDEzLTEwLTA4LTIyOjMyOjIzIGRldGVjdGluZyBib290
IHN0YXRlIDMuMy4wLiBURVNUIEZBSUxVUkUKWyAgICAxLjg4Njc1MF0gTmV0U2M1MjAgZmxh
c2ggZGV2aWNlOiAweDEwMDAwMCBhdCAweDIwMDAwMApbICAgIDEuODg3NTUyXSAtLS0tLS0t
LS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAxLjg4ODI5OF0gV0FSTklORzog
YXQgYXJjaC94ODYvbW0vaW9yZW1hcC5jOjEwMiBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3LzB4
M2UwKCkKWyAgICAxLjg4OTY3MF0gSGFyZHdhcmUgbmFtZTogQm9jaHMKWyAgICAxLjg5MDM4
OV0gUGlkOiAxLCBjb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMy4wICM1ODAKWyAgICAx
Ljg5MTIyM10gQ2FsbCBUcmFjZToKWyAgICAxLjg5MTc2Nl0gIFs8YzBiOGUxYWY+XSA/IHBy
aW50aysweDFkLzB4MWYKWyAgICAxLjg5MjQ3NV0gIFs8YzAyMmViYTc+XSB3YXJuX3Nsb3dw
YXRoX2NvbW1vbisweDY3LzB4OTAKWyAgICAxLjg5MzMwOV0gIFs8YzAyMjFjYTc+XSA/IF9f
aW9yZW1hcF9jYWxsZXIrMHgxMjcvMHgzZTAKWyAgICAxLjg5NDEyNl0gIFs8YzAyMjFjYTc+
XSA/IF9faW9yZW1hcF9jYWxsZXIrMHgxMjcvMHgzZTAKWyAgICAxLjg5NDkzOV0gIFs8YzAy
MmVjYTI+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyMi8weDMwClsgICAgMS44OTU3NDhdICBb
PGMwMjIxY2E3Pl0gX19pb3JlbWFwX2NhbGxlcisweDEyNy8weDNlMApbICAgIDEuODk2NTYw
XSAgWzxjMTEyODcxNz5dID8gaW5pdF9zYzUyMGNkcCsweDIxMi8weDIxMgpbICAgIDEuODk3
MzU1XSAgWzxjMDIyMWZhOT5dIGlvcmVtYXBfbm9jYWNoZSsweDE5LzB4MjAKWyAgICAxLjg5
ODE0NF0gIFs8YzExMjg3NWI+XSA/IGluaXRfbmV0c2M1MjArMHg0NC8weGY2ClsgICAgMS44
OTg5MTZdICBbPGMxMTI4NzViPl0gaW5pdF9uZXRzYzUyMCsweDQ0LzB4ZjYKWyAgICAxLjg5
OTY5NV0gIFs8YzExMDI3N2Q+XSBkb19vbmVfaW5pdGNhbGwrMHg3ZS8weDEyYgpbICAgIDEu
OTAwNDc2XSAgWzxjMTEwMjgyYT5dID8gZG9fb25lX2luaXRjYWxsKzB4MTJiLzB4MTJiClsg
ICAgMS45MDEyOTZdICBbPGMxMTAyODJhPl0gPyBkb19vbmVfaW5pdGNhbGwrMHgxMmIvMHgx
MmIKWyAgICAxLjkwMjEyNV0gIFs8YzBiYWU3OWM+XSA/IGRvd25fd3JpdGUrMHgxYy8weDQw
ClsgICAgMS45MDI4NzVdICBbPGMxMTAyODJhPl0gPyBkb19vbmVfaW5pdGNhbGwrMHgxMmIv
MHgxMmIKWyAgICAxLjkwMzcyNF0gIFs8YzExMDI4ZTY+XSBrZXJuZWxfaW5pdCsweGJjLzB4
MTQyClsgICAgMS45MDQ0NzNdICBbPGMwYmIwYTI2Pl0ga2VybmVsX3RocmVhZF9oZWxwZXIr
MHg2LzB4MTAKWyAgICAxLjkwNTI4OV0gLS0tWyBlbmQgdHJhY2UgNzJmODRiNmY1NzQzYzJm
MCBdLS0tClsgICAgMS45MDY4NTldIENyZWF0aW5nIDQgTVREIHBhcnRpdGlvbnMgb24gIm5l
dHNjNTIwIEZsYXNoIEJhbmsiOgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
YzE2ZmE0ZjJhZDE5OTA4YTQ3YzYzZDhmYTQzNmExMTc4NDM4YzdlNy9kbWVzZy1xdWFudGFs
LXhwcy01OjIwMTMxMDA5MDYyOTAxOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4zLjA6
NTgwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9jMTZmYTRmMmFkMTk5MDhh
NDdjNjNkOGZhNDM2YTExNzg0MzhjN2U3L2RtZXNnLXlvY3RvLXdhaW1lYS0yOjIwMTMxMDA5
MDYyOTMzOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4zLjA6NTgwCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9jMTZmYTRmMmFkMTk5MDhhNDdjNjNkOGZhNDM2YTEx
Nzg0MzhjN2U3L2RtZXNnLXlvY3RvLXhwcy0yOjIwMTMxMDA5MDYyOTAwOmkzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDg6My4zLjA6NTgwCjA6MzozIGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVw
ZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjMKZ2l0IGNoZWNrb3V0IHYzLjIKUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYzE2ZmE0Zi4uLiBMaW51eCAzLjMKSEVBRCBpcyBu
b3cgYXQgODA1YTZhZi4uLiBMaW51eCAzLjIKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvdGlwOm1hc3Rlcjo4MDVhNmFmOGRi
YTVkZmRkMzVlYzM1ZGM1MmVjMDEyMjQwMGIyNjEwOmJpc2VjdC11c2IKCjIwMTMtMTAtMDgt
MjI6MzI6NTkgODA1YTZhZjhkYmE1ZGZkZDM1ZWMzNWRjNTJlYzAxMjI0MDBiMjYxMCBjb21w
aWxpbmcKMTg0IHJlYWwgIDEzMjggdXNlciAgMTI3IHN5cyAgNzg5Ljg5JSBjcHUgCWkzODYt
cmFuZGNvbmZpZy1pMDA5LTEwMDgKCjIwMTMtMTAtMDgtMjI6MzY6MTQgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4yLjAuLiBURVNUIEZBSUxVUkUKWyAgICAxLjgxNDExOF0gTmV0U2M1MjAg
Zmxhc2ggZGV2aWNlOiAweDEwMDAwMCBhdCAweDIwMDAwMApbICAgIDEuODE1MDQzXSAtLS0t
LS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAxLjgxNTkwNF0gV0FSTklO
RzogYXQgYXJjaC94ODYvbW0vaW9yZW1hcC5jOjEwMiBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3
LzB4M2UwKCkKWyAgICAxLjgxNzQ1OF0gSGFyZHdhcmUgbmFtZTogQm9jaHMKWyAgICAxLjgx
ODE0OF0gUGlkOiAxLCBjb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMi4wICM1ODEKWyAg
ICAxLjgxOTA3OF0gQ2FsbCBUcmFjZToKWyAgICAxLjgxOTY5MF0gIFs8YzBiMjhjZWU+XSA/
IHByaW50aysweDFkLzB4MWYKWyAgICAxLjgyMDUwMl0gIFs8YzAyMzhiZjc+XSB3YXJuX3Ns
b3dwYXRoX2NvbW1vbisweDY3LzB4OTAKWyAgICAxLjgyMTQzOV0gIFs8YzAyMjE4NDc+XSA/
IF9faW9yZW1hcF9jYWxsZXIrMHgxMjcvMHgzZTAKWyAgICAxLjgyMjM3MF0gIFs8YzAyMjE4
NDc+XSA/IF9faW9yZW1hcF9jYWxsZXIrMHgxMjcvMHgzZTAKWyAgICAxLjgyMzMxMV0gIFs8
YzAyMzhjZjI+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyMi8weDMwClsgICAgMS44MjQyMjBd
ICBbPGMwMjIxODQ3Pl0gX19pb3JlbWFwX2NhbGxlcisweDEyNy8weDNlMApbICAgIDEuODI1
MTMyXSAgWzxjMTBiNGJlOT5dID8gaW5pdF9zYzUyMGNkcCsweDIxNi8weDIxNgpbICAgIDEu
ODI2MDQ5XSAgWzxjMDIyMWI0OT5dIGlvcmVtYXBfbm9jYWNoZSsweDE5LzB4MjAKWyAgICAx
LjgyNjk1Ml0gIFs8YzEwYjRjMmQ+XSA/IGluaXRfbmV0c2M1MjArMHg0NC8weGY2ClsgICAg
MS44Mjc4MjZdICBbPGMxMGI0YzJkPl0gaW5pdF9uZXRzYzUyMCsweDQ0LzB4ZjYKWyAgICAx
LjgyODY5M10gIFs8YzEwOGQ3Yzg+XSBkb19vbmVfaW5pdGNhbGwrMHg3ZS8weDEyYgpbICAg
IDEuODI5NTk0XSAgWzxjMTA4ZDg3NT5dID8gZG9fb25lX2luaXRjYWxsKzB4MTJiLzB4MTJi
ClsgICAgMS44MzA1MTVdICBbPGMwNjZiZjZhPl0gPyByYWRpeF90cmVlX2xvb2t1cCsweGEv
MHgxMApbICAgIDEuODMxNDMwXSAgWzxjMDI3YmVmND5dID8gaXJxX3RvX2Rlc2MrMHgxNC8w
eDIwClsgICAgMS44MzIyOThdICBbPGMxMDhkODc1Pl0gPyBkb19vbmVfaW5pdGNhbGwrMHgx
MmIvMHgxMmIKWyAgICAxLjgzMzIzOF0gIFs8YzEwOGQ5MzE+XSBrZXJuZWxfaW5pdCsweGJj
LzB4MTQyClsgICAgMS44MzQwOTNdICBbPGMwYjRhYmM2Pl0ga2VybmVsX3RocmVhZF9oZWxw
ZXIrMHg2LzB4MTAKWyAgICAxLjgzNTAxMl0gLS0tWyBlbmQgdHJhY2UgZjkwNjYzNjE1Njhj
NTI3YyBdLS0tClsgICAgMS44MzczNTBdIENyZWF0aW5nIDQgTVREIHBhcnRpdGlvbnMgb24g
Im5ldHNjNTIwIEZsYXNoIEJhbmsiOgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDgvODA1YTZhZjhkYmE1ZGZkZDM1ZWMzNWRjNTJlYzAxMjI0MDBiMjYxMC9kbWVzZy1xdWFu
dGFsLWlubi0zMzoyMDEzMTAwODIyMzY0ODppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMu
Mi4wOjU4MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvODA1YTZhZjhkYmE1
ZGZkZDM1ZWMzNWRjNTJlYzAxMjI0MDBiMjYxMC9kbWVzZy1xdWFudGFsLWpha2V0b3duLTE1
OjIwMTMxMDA4MjIzNjQ5OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4yLjA6NTgxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC84MDVhNmFmOGRiYTVkZmRkMzVlYzM1
ZGM1MmVjMDEyMjQwMGIyNjEwL2RtZXNnLXlvY3RvLWlubi0xNzoyMDEzMTAwODIyMzY0NDpp
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMi4wOjU4MQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDgvODA1YTZhZjhkYmE1ZGZkZDM1ZWMzNWRjNTJlYzAxMjI0MDBiMjYx
MC9kbWVzZy15b2N0by1pbm4tMjY6MjAxMzEwMDgyMjM2NTE6aTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwODozLjIuMDo1ODEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4Lzgw
NWE2YWY4ZGJhNWRmZGQzNWVjMzVkYzUyZWMwMTIyNDAwYjI2MTAvZG1lc2ctcXVhbnRhbC1j
YWlyby0zMDoyMDEzMTAwODIyMzY1ODppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMi4w
OjU4MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvODA1YTZhZjhkYmE1ZGZk
ZDM1ZWMzNWRjNTJlYzAxMjI0MDBiMjYxMC9kbWVzZy1xdWFudGFsLWNhaXJvLTg6MjAxMzEw
MDgyMjM3MDE6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjIuMDo1ODEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzgwNWE2YWY4ZGJhNWRmZGQzNWVjMzVkYzUyZWMw
MTIyNDAwYjI2MTAvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi03OjIwMTMxMDA4MTMwODA1Omkz
ODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4yLjA6NTgxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwOC84MDVhNmFmOGRiYTVkZmRkMzVlYzM1ZGM1MmVjMDEyMjQwMGIyNjEw
L2RtZXNnLXlvY3RvLW5obTQtMjoyMDEzMTAwODE0NDIwOTppMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4OjMuMi4wOjU4MQowOjg6OCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7
MzVtUkVQRUFUIENPVU5UOiAyMCAgIyAvY2Mvd2ZnL3VzYi1iaXNlY3QvLnJlcGVhdBtbMG0K
CmJpc2VjdDogYmFkIGNvbW1pdCB2My4yCmdpdCBjaGVja291dCB2My4xClByZXZpb3VzIEhF
QUQgcG9zaXRpb24gd2FzIDgwNWE2YWYuLi4gTGludXggMy4yCkhFQUQgaXMgbm93IGF0IGMz
YjkyYzguLi4gTGludXggMy4xCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4L3RpcDptYXN0ZXI6YzNiOTJjODc4NzM2N2E4YmI1
M2Q1N2Q5Nzg5YjU1OGYxMjk1Y2M5NjpiaXNlY3QtdXNiCgoyMDEzLTEwLTA4LTIyOjM3OjIx
IGMzYjkyYzg3ODczNjdhOGJiNTNkNTdkOTc4OWI1NThmMTI5NWNjOTYgY29tcGlsaW5nCjE5
NSByZWFsICAxMjYxIHVzZXIgIDEwOSBzeXMgIDcwMi41OSUgY3B1IAlpMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4CgoyMDEzLTEwLTA4LTIyOjQwOjUwIGRldGVjdGluZyBib290IHN0YXRl
IDMuMS4wLiBURVNUIEZBSUxVUkUKWyAgICAyLjA0Mzg3MV0gTmV0U2M1MjAgZmxhc2ggZGV2
aWNlOiAweDEwMDAwMCBhdCAweDIwMDAwMApbICAgIDIuMDQ1MTY3XSAtLS0tLS0tLS0tLS1b
IGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAyLjA0NjM2Nl0gV0FSTklORzogYXQgYXJj
aC94ODYvbW0vaW9yZW1hcC5jOjEwMiBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3LzB4M2UwKCkK
WyAgICAyLjA0ODU0Nl0gSGFyZHdhcmUgbmFtZTogQm9jaHMKWyAgICAyLjA0OTUxMl0gUGlk
OiAxLCBjb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMS4wICM1ODIKWyAgICAyLjA1MDgz
NV0gQ2FsbCBUcmFjZToKWyAgICAyLjA1MTY4Ml0gIFs8YzBhZjJlMGQ+XSA/IHByaW50aysw
eDFkLzB4MWYKWyAgICAyLjA1MjgxN10gIFs8YzAyMzdmNjc+XSB3YXJuX3Nsb3dwYXRoX2Nv
bW1vbisweDY3LzB4OTAKWyAgICAyLjA1NDE0NF0gIFs8YzAyMjBjMDc+XSA/IF9faW9yZW1h
cF9jYWxsZXIrMHgxMjcvMHgzZTAKWyAgICAyLjA1NTQ1OV0gIFs8YzAyMjBjMDc+XSA/IF9f
aW9yZW1hcF9jYWxsZXIrMHgxMjcvMHgzZTAKWyAgICAyLjA1Njc2OV0gIFs8YzAyMzgwNjI+
XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyMi8weDMwClsgICAgMi4wNTgwNzZdICBbPGMwMjIw
YzA3Pl0gX19pb3JlbWFwX2NhbGxlcisweDEyNy8weDNlMApbICAgIDIuMDU5MzYyXSAgWzxj
MTAxNDNlNz5dID8gaW5pdF9zYzUyMGNkcCsweDFmOC8weDFmOApbICAgIDIuMDYwNjQwXSAg
WzxjMDIyMGYwOT5dIGlvcmVtYXBfbm9jYWNoZSsweDE5LzB4MjAKWyAgICAyLjA2MTg3N10g
IFs8YzEwMTQ0MmI+XSA/IGluaXRfbmV0c2M1MjArMHg0NC8weGVkClsgICAgMi4wNjMxMTdd
ICBbPGMxMDE0NDJiPl0gaW5pdF9uZXRzYzUyMCsweDQ0LzB4ZWQKWyAgICAyLjA2NDM0N10g
IFs8YzBmZWQ3YzM+XSBkb19vbmVfaW5pdGNhbGwrMHg3ZS8weDEyYgpbICAgIDIuMDY1NTk3
XSAgWzxjMGZlZDg3MD5dID8gZG9fb25lX2luaXRjYWxsKzB4MTJiLzB4MTJiClsgICAgMi4w
NjY4OTNdICBbPGMwNjVjNGFhPl0gPyByYWRpeF90cmVlX2xvb2t1cCsweGEvMHgxMApbICAg
IDIuMDY4MjE1XSAgWzxjMDI3YTY1ND5dID8gaXJxX3RvX2Rlc2MrMHgxNC8weDIwClsgICAg
Mi4wNjk0MjRdICBbPGMwZmVkODcwPl0gPyBkb19vbmVfaW5pdGNhbGwrMHgxMmIvMHgxMmIK
WyAgICAyLjA3MDczMV0gIFs8YzBmZWQ5MmM+XSBrZXJuZWxfaW5pdCsweGJjLzB4MTQyClsg
ICAgMi4wNzE5MjNdICBbPGMwYjEzZTI2Pl0ga2VybmVsX3RocmVhZF9oZWxwZXIrMHg2LzB4
MTAKWyAgICAyLjA3MzIyN10gLS0tWyBlbmQgdHJhY2UgMmRkMWEwOGUyZDJmNmE2ZSBdLS0t
ClsgICAgMi4wNzUyNjVdIENyZWF0aW5nIDQgTVREIHBhcnRpdGlvbnMgb24gIm5ldHNjNTIw
IEZsYXNoIEJhbmsiOgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvYzNiOTJj
ODc4NzM2N2E4YmI1M2Q1N2Q5Nzg5YjU1OGYxMjk1Y2M5Ni9kbWVzZy1xdWFudGFsLXdhaW1l
YS0zOjIwMTMxMDA5MDYzNzQ4OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xLjA6NTgy
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9jM2I5MmM4Nzg3MzY3YThiYjUz
ZDU3ZDk3ODliNTU4ZjEyOTVjYzk2L2RtZXNnLXF1YW50YWwtYmF5LTM6MjAxMzEwMDgyMjQx
MDI6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEuMDo1ODIKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaTAwOS0xMDA4L2MzYjkyYzg3ODczNjdhOGJiNTNkNTdkOTc4OWI1NThmMTI5
NWNjOTYvZG1lc2ctcXVhbnRhbC1iYXktNDoyMDEzMTAwODIyNDEwODppMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4OjMuMS4wOjU4Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDgvYzNiOTJjODc4NzM2N2E4YmI1M2Q1N2Q5Nzg5YjU1OGYxMjk1Y2M5Ni9kbWVzZy1xdWFu
dGFsLWJlbnMtMzoyMDEzMTAwODIyNDEwMjppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMu
MS4wOjU4Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvYzNiOTJjODc4NzM2
N2E4YmI1M2Q1N2Q5Nzg5YjU1OGYxMjk1Y2M5Ni9kbWVzZy1xdWFudGFsLWlubi0yOToyMDEz
MTAwODIyNDEwNjppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMS4wOjU4Mgova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvYzNiOTJjODc4NzM2N2E4YmI1M2Q1N2Q5Nzg5
YjU1OGYxMjk1Y2M5Ni9kbWVzZy1xdWFudGFsLWlubi00MjoyMDEzMTAwODIyNDEwNzppMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMS4wOjU4Mgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDgvYzNiOTJjODc4NzM2N2E4YmI1M2Q1N2Q5Nzg5YjU1OGYxMjk1Y2M5Ni9k
bWVzZy1xdWFudGFsLWxrcC10dDAyLTEyOjIwMTMxMDA4MTMxMjEzOmkzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDg6My4xLjA6NTgyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC9jM2I5MmM4Nzg3MzY3YThiYjUzZDU3ZDk3ODliNTU4ZjEyOTVjYzk2L2RtZXNnLXF1YW50
YWwtbGtwLXR0MDItNToyMDEzMTAwODEzMTIwOTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
OjMuMS4wOjU4Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvYzNiOTJjODc4
NzM2N2E4YmI1M2Q1N2Q5Nzg5YjU1OGYxMjk1Y2M5Ni9kbWVzZy1xdWFudGFsLXJvYW0tMTE6
MjAxMzEwMDgyMjQxMDM6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEuMDo1ODIKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2MzYjkyYzg3ODczNjdhOGJiNTNkNTdk
OTc4OWI1NThmMTI5NWNjOTYvZG1lc2ctcXVhbnRhbC1yb2FtLTI3OjIwMTMxMDA4MjI0MTA3
OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xLjA6NTgyCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwOC9jM2I5MmM4Nzg3MzY3YThiYjUzZDU3ZDk3ODliNTU4ZjEyOTVj
Yzk2L2RtZXNnLXlvY3RvLWlubi0yODoyMDEzMTAwODIyNDEwMTppMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4OjMuMS4wOjU4Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
YzNiOTJjODc4NzM2N2E4YmI1M2Q1N2Q5Nzg5YjU1OGYxMjk1Y2M5Ni9kbWVzZy15b2N0by1s
a3AtdHQwMi0xOToyMDEzMTAwODEzMTIxMDppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMu
MS4wOjU4Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvYzNiOTJjODc4NzM2
N2E4YmI1M2Q1N2Q5Nzg5YjU1OGYxMjk1Y2M5Ni9kbWVzZy15b2N0by1yb2FtLTI3OjIwMTMx
MDA4MjI0MTAzOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xLjA6NTgyCjA6MTM6MTMg
YWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDogMjAgICMg
L2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMu
MQpnaXQgY2hlY2tvdXQgdjMuMApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBjM2I5MmM4
Li4uIExpbnV4IDMuMQpIRUFEIGlzIG5vdyBhdCAwMmY4YzZhLi4uIExpbnV4IDMuMApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC90aXA6bWFzdGVyOjAyZjhjNmFlZThkZjNjZGM5MzVlOWJkZDRmMmQwMjAzMDYwMzVkYmU6
YmlzZWN0LXVzYgoKMjAxMy0xMC0wOC0yMjo0MToyNSAwMmY4YzZhZWU4ZGYzY2RjOTM1ZTli
ZGQ0ZjJkMDIwMzA2MDM1ZGJlIGNvbXBpbGluZwoxNzkgcmVhbCAgMTE3NiB1c2VyICAxMTUg
c3lzICA3MTguMTElIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOAoKMjAxMy0xMC0w
OC0yMjo0NDozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjAuMC4gVEVTVCBGQUlMVVJFClsg
ICAgMy4wMTI2MDldIE5ldFNjNTIwIGZsYXNoIGRldmljZTogMHgxMDAwMDAgYXQgMHgyMDAw
MDAKWyAgICAzLjAxNDIwMF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0t
ClsgICAgMy4wMTU2NzJdIFdBUk5JTkc6IGF0IGFyY2gveDg2L21tL2lvcmVtYXAuYzoxMDIg
X19pb3JlbWFwX2NhbGxlcisweDEyNy8weDNlMCgpClsgICAgMy4wMTgzMzRdIEhhcmR3YXJl
IG5hbWU6IEJvY2hzClsgICAgMy4wMTk1MjBdIFBpZDogMSwgY29tbTogc3dhcHBlciBOb3Qg
dGFpbnRlZCAzLjAuMCAjNTgzClsgICAgMy4wMjExNTFdIENhbGwgVHJhY2U6ClsgICAgMy4w
MjIxODZdICBbPGMwYTVmNDM3Pl0gPyBwcmludGsrMHgxZC8weDFmClsgICAgMy4wMjM1Njhd
ICBbPGMwMjM2NTA3Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg2Ny8weDkwClsgICAgMy4w
MjUxMzldICBbPGMwMjIwMmM3Pl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3LzB4M2UwClsg
ICAgMy4wMjY1NzZdICBbPGMwMjIwMmM3Pl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTI3LzB4
M2UwClsgICAgMy4wMjgxMjVdICBbPGMwMjM2NjAyPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4
MjIvMHgzMApbICAgIDMuMDI5NjIzXSAgWzxjMDIyMDJjNz5dIF9faW9yZW1hcF9jYWxsZXIr
MHgxMjcvMHgzZTAKWyAgICAzLjAzMTE2NF0gIFs8YzBmNGZiZmQ+XSA/IGluaXRfc2M1MjBj
ZHArMHgxZjgvMHgxZjgKWyAgICAzLjAzMjY2Nl0gIFs8YzAyMjA1Yzk+XSBpb3JlbWFwX25v
Y2FjaGUrMHgxOS8weDIwClsgICAgMy4wMzQyMTddICBbPGMwZjRmYzQxPl0gPyBpbml0X25l
dHNjNTIwKzB4NDQvMHhlZApbICAgIDMuMDM1NzAxXSAgWzxjMGY0ZmM0MT5dIGluaXRfbmV0
c2M1MjArMHg0NC8weGVkClsgICAgMy4wMzcxNDldICBbPGMwZjI5N2E2Pl0gZG9fb25lX2lu
aXRjYWxsKzB4N2UvMHgxMmIKWyAgICAzLjAzODY3NV0gIFs8YzBmMjk4NTM+XSA/IGRvX29u
ZV9pbml0Y2FsbCsweDEyYi8weDEyYgpbICAgIDMuMDQwMjkzXSAgWzxjMDYyNDVhYT5dID8g
cmFkaXhfdHJlZV9sb29rdXArMHhhLzB4MTAKWyAgICAzLjA0MTg4NF0gIFs8YzAyNzQ5ZTQ+
XSA/IGlycV90b19kZXNjKzB4MTQvMHgyMApbICAgIDMuMDQzMjY0XSAgWzxjMGYyOTg1Mz5d
ID8gZG9fb25lX2luaXRjYWxsKzB4MTJiLzB4MTJiClsgICAgMy4wNDQ3NThdICBbPGMwZjI5
OGY2Pl0ga2VybmVsX2luaXQrMHhhMy8weDEyOQpbICAgIDMuMDQ2MTk0XSAgWzxjMGE3ZTgw
Nj5dIGtlcm5lbF90aHJlYWRfaGVscGVyKzB4Ni8weDEwClsgICAgMy4wNDc3MjZdIC0tLVsg
ZW5kIHRyYWNlIDZmNmM1ZDRhOGEyZGUwMTcgXS0tLQpbICAgIDMuMDUwNzI3XSBDcmVhdGlu
ZyA0IE1URCBwYXJ0aXRpb25zIG9uICJuZXRzYzUyMCBGbGFzaCBCYW5rIjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzAyZjhjNmFlZThkZjNjZGM5MzVlOWJkZDRmMmQw
MjAzMDYwMzVkYmUvZG1lc2cteW9jdG8tcm9hbS0yMDoyMDEzMTAwODIyNDQ0NzppMzg2LXJh
bmRjb25maWctaTAwOS0xMDA4OjMuMC4wOjU4Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
MDA5LTEwMDgvMDJmOGM2YWVlOGRmM2NkYzkzNWU5YmRkNGYyZDAyMDMwNjAzNWRiZS9kbWVz
Zy15b2N0by1yb2FtLTI6MjAxMzEwMDgyMjQ0NDc6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
ODozLjAuMDo1ODMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzAyZjhjNmFl
ZThkZjNjZGM5MzVlOWJkZDRmMmQwMjAzMDYwMzVkYmUvZG1lc2cteW9jdG8tc25iLTQ0OjIw
MTMxMDA4MjI0NDQ2OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4wLjA6NTgzCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC8wMmY4YzZhZWU4ZGYzY2RjOTM1ZTliZGQ0
ZjJkMDIwMzA2MDM1ZGJlL2RtZXNnLXlvY3RvLXN0b2FrbGV5LTI6MjAxMzEwMDgyMjQ0NTE6
aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjAuMDo1ODMKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4LzAyZjhjNmFlZThkZjNjZGM5MzVlOWJkZDRmMmQwMjAzMDYwMzVk
YmUvZG1lc2cteW9jdG8td2FpbWVhLTEzOjIwMTMxMDA5MDY0MTM3OmkzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDg6My4wLjA6NTgzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC8wMmY4YzZhZWU4ZGYzY2RjOTM1ZTliZGQ0ZjJkMDIwMzA2MDM1ZGJlL2RtZXNnLXF1YW50
YWwtY2Fpcm8tNDM6MjAxMzEwMDgyMjQ0NTg6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODoz
LjAuMDo1ODMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzAyZjhjNmFlZThk
ZjNjZGM5MzVlOWJkZDRmMmQwMjAzMDYwMzVkYmUvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0y
MzoyMDEzMTAwODEzMTYwMDppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMC4wOjU4Mwov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvMDJmOGM2YWVlOGRmM2NkYzkzNWU5
YmRkNGYyZDAyMDMwNjAzNWRiZS9kbWVzZy1xdWFudGFsLXJvYW0tOToyMDEzMTAwODIyNDQ1
NzppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMC4wOjU4Mwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDgvMDJmOGM2YWVlOGRmM2NkYzkzNWU5YmRkNGYyZDAyMDMwNjAz
NWRiZS9kbWVzZy1xdWFudGFsLXNuYi0xODoyMDEzMTAwODIyNDUwMjppMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4OjMuMC4wOjU4Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDgvMDJmOGM2YWVlOGRmM2NkYzkzNWU5YmRkNGYyZDAyMDMwNjAzNWRiZS9kbWVzZy1xdWFu
dGFsLXhwcy01OjIwMTMxMDA5MDY0MTExOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4w
LjA6NTgzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC8wMmY4YzZhZWU4ZGYz
Y2RjOTM1ZTliZGQ0ZjJkMDIwMzA2MDM1ZGJlL2RtZXNnLXF1YW50YWwteHBzLTc6MjAxMzEw
MDkwNjQxMTE6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjAuMDo1ODMKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzAyZjhjNmFlZThkZjNjZGM5MzVlOWJkZDRmMmQw
MjAzMDYwMzVkYmUvZG1lc2cteW9jdG8tYmVucy0zOjIwMTMxMDA4MjI0NTAyOmkzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDg6My4wLjA6NTgzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwOC8wMmY4YzZhZWU4ZGYzY2RjOTM1ZTliZGQ0ZjJkMDIwMzA2MDM1ZGJlL2RtZXNn
LXlvY3RvLWJlbnMtNDoyMDEzMTAwODIyNDQ1ODppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
OjMuMC4wOjU4Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvMDJmOGM2YWVl
OGRmM2NkYzkzNWU5YmRkNGYyZDAyMDMwNjAzNWRiZS9kbWVzZy15b2N0by1qYWtldG93bi0x
OjIwMTMxMDA4MjI0NTAwOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4wLjA6NTgzCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC8wMmY4YzZhZWU4ZGYzY2RjOTM1ZTli
ZGQ0ZjJkMDIwMzA2MDM1ZGJlL2RtZXNnLXlvY3RvLWxrcC10dDAyLTI0OjIwMTMxMDA4MTMx
NjA1OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4wLjA6NTgzCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwOC8wMmY4YzZhZWU4ZGYzY2RjOTM1ZTliZGQ0ZjJkMDIwMzA2
MDM1ZGJlL2RtZXNnLXlvY3RvLXdhaW1lYS0xMjoyMDEzMTAwOTA2NDE0NTppMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4OjMuMC4wOjU4Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5
LTEwMDgvMDJmOGM2YWVlOGRmM2NkYzkzNWU5YmRkNGYyZDAyMDMwNjAzNWRiZS9kbWVzZy15
b2N0by14aWFuLTI0OjIwMTMxMDA4MjI0NDU5OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6
My4wLjA6NTgzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC8wMmY4YzZhZWU4
ZGYzY2RjOTM1ZTliZGQ0ZjJkMDIwMzA2MDM1ZGJlL2RtZXNnLXF1YW50YWwtamFrZXRvd24t
MjA6MjAxMzEwMDgyMjQ1MDQ6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjAuMDo1ODMK
MDoxODoxNSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29tbWl0
IHYzLjAKZ2l0IGNoZWNrb3V0IHYyLjYuMzkKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMg
MDJmOGM2YS4uLiBMaW51eCAzLjAKSEVBRCBpcyBub3cgYXQgNjFjNGYyYy4uLiBMaW51eCAy
LjYuMzkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDgvdGlwOm1hc3Rlcjo2MWM0ZjJjODFjNjFmNzM1NDk5MjhkZmQ5ZjNlOGYy
NmFhMzZhOGNmOmJpc2VjdC11c2IKCjIwMTMtMTAtMDgtMjI6NDU6MTQgNjFjNGYyYzgxYzYx
ZjczNTQ5OTI4ZGZkOWYzZThmMjZhYTM2YThjZiBjb21waWxpbmcKMTQ1IHJlYWwgIDExMzEg
dXNlciAgMTAzIHN5cyAgODQ4LjUwJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgK
MjAxMy0xMC0wOC0yMjo0Nzo1MSA2MWM0ZjJjODFjNjFmNzM1NDk5MjhkZmQ5ZjNlOGYyNmFh
MzZhOGNmIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93ZmcvdXNiLWJp
c2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC82MWM0ZjJj
ODFjNjFmNzM1NDk5MjhkZmQ5ZjNlOGYyNmFhMzZhOGNmCmJpc2VjdDogc2tpcCBicm9rZW4g
YnVpbGQgZm9yIHYyLjYuMzkKZ2l0IGNoZWNrb3V0IHYyLjYuMzgKUHJldmlvdXMgSEVBRCBw
b3NpdGlvbiB3YXMgNjFjNGYyYy4uLiBMaW51eCAyLjYuMzkKSEVBRCBpcyBub3cgYXQgNTIx
Y2I0MC4uLiBMaW51eCAyLjYuMzgKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvdGlwOm1hc3Rlcjo1MjFjYjQwYjBjNDQ0MThh
NGZkMzZkYzYzM2Y1NzU4MTNkNTlhNDNkOmJpc2VjdC11c2IKCjIwMTMtMTAtMDgtMjI6NDc6
NTkgNTIxY2I0MGIwYzQ0NDE4YTRmZDM2ZGM2MzNmNTc1ODEzZDU5YTQzZCBjb21waWxpbmcK
MTQ0IHJlYWwgIDEwNzYgdXNlciAgMTAxIHN5cyAgODE1LjE4JSBjcHUgCWkzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDgKMjAxMy0xMC0wOC0yMjo1MDozMyA1MjFjYjQwYjBjNDQ0MThhNGZk
MzZkYzYzM2Y1NzU4MTNkNTlhNDNkIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGlu
IC9jYy93ZmcvdXNiLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwOC81MjFjYjQwYjBjNDQ0MThhNGZkMzZkYzYzM2Y1NzU4MTNkNTlhNDNkCmJpc2Vj
dDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMzgKZ2l0IGNoZWNrb3V0IHYyLjYuMzcK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNTIxY2I0MC4uLiBMaW51eCAyLjYuMzgKSEVB
RCBpcyBub3cgYXQgM2MwZWVlMy4uLiBMaW51eCAyLjYuMzcKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvdGlwOm1hc3Rlcjoz
YzBlZWUzZmU2YTNhMWM3NDUzNzk1NDdjN2U3YzkwNGFhNjRmNmQ1OmJpc2VjdC11c2IKCjIw
MTMtMTAtMDgtMjI6NTA6MzcgM2MwZWVlM2ZlNmEzYTFjNzQ1Mzc5NTQ3YzdlN2M5MDRhYTY0
ZjZkNSBjb21waWxpbmcKMTM0IHJlYWwgIDEwNDIgdXNlciAgOTAgc3lzICA4NDMuNTglIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOAoyMDEzLTEwLTA4LTIyOjUzOjA0IDNjMGVl
ZTNmZTZhM2ExYzc0NTM3OTU0N2M3ZTdjOTA0YWE2NGY2ZDUgU0tJUCBCUk9LRU4gQlVJTEQK
Q2hlY2sgZXJyb3MgaW4gL2NjL3dmZy91c2ItYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4LzNjMGVlZTNmZTZhM2ExYzc0NTM3OTU0N2M3ZTdjOTA0
YWE2NGY2ZDUKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zNwpnaXQgY2hl
Y2tvdXQgdjIuNi4zNgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAzYzBlZWUzLi4uIExp
bnV4IDIuNi4zNwpIRUFEIGlzIG5vdyBhdCBmNmY5NGUyLi4uIExpbnV4IDIuNi4zNgpscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC90aXA6bWFzdGVyOmY2Zjk0ZTJhYjFiMzNmMDA4MmFjMjJkNzFmNjYzODVhNjBkODE1N2Y6
YmlzZWN0LXVzYgoKMjAxMy0xMC0wOC0yMjo1MzowOSBmNmY5NGUyYWIxYjMzZjAwODJhYzIy
ZDcxZjY2Mzg1YTYwZDgxNTdmIGNvbXBpbGluZwoxNDIgcmVhbCAgMTAyNSB1c2VyICAxMDQg
c3lzICA3OTEuOTglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOAoyMDEzLTEwLTA4
LTIyOjU1OjQ4IGY2Zjk0ZTJhYjFiMzNmMDA4MmFjMjJkNzFmNjYzODVhNjBkODE1N2YgU0tJ
UCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy91c2ItYmlzZWN0IGFuZCAv
dG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2Y2Zjk0ZTJhYjFiMzNmMDA4
MmFjMjJkNzFmNjYzODVhNjBkODE1N2YKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3Ig
djIuNi4zNgpnaXQgY2hlY2tvdXQgdjIuNi4zNQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdh
cyBmNmY5NGUyLi4uIExpbnV4IDIuNi4zNgpIRUFEIGlzIG5vdyBhdCA5ZmU2MjA2Li4uIExp
bnV4IDIuNi4zNQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwOC90aXA6bWFzdGVyOjlmZTYyMDZmNDAwNjQ2YTIzMjIwOTZiNTZj
NTk4OTFkNTMwZThkNTE6YmlzZWN0LXVzYgoKMjAxMy0xMC0wOC0yMjo1NTo1MyA5ZmU2MjA2
ZjQwMDY0NmEyMzIyMDk2YjU2YzU5ODkxZDUzMGU4ZDUxIGNvbXBpbGluZwobWzE7MzVtaTM4
Ni1yYW5kY29uZmlnLWkwMDktMTAwODogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtb
MTszNW1pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVk
ZWQbWzBtCjEzMiByZWFsICAxMDE3IHVzZXIgIDEwNCBzeXMgIDg1MC4xMiUgY3B1IAlpMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4CjIwMTMtMTAtMDgtMjI6NTg6MjEgOWZlNjIwNmY0MDA2
NDZhMjMyMjA5NmI1NmM1OTg5MWQ1MzBlOGQ1MSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBl
cnJvcyBpbiAvY2Mvd2ZnL3VzYi1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDgvOWZlNjIwNmY0MDA2NDZhMjMyMjA5NmI1NmM1OTg5MWQ1MzBlOGQ1
MQpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjM1CmdpdCBjaGVja291dCB2
Mi42LjM0ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDlmZTYyMDYuLi4gTGludXggMi42
LjM1CkhFQUQgaXMgbm93IGF0IGU0MDE1MmUuLi4gTGludXMgMi42LjM0CmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L3RpcDpt
YXN0ZXI6ZTQwMTUyZWUxZTFjN2E2M2Y0Nzc3NzkxODYzMjE1ZTNmYWEzN2E4NjpiaXNlY3Qt
dXNiCgoyMDEzLTEwLTA4LTIyOjU4OjI1IGU0MDE1MmVlMWUxYzdhNjNmNDc3Nzc5MTg2MzIx
NWUzZmFhMzdhODYgY29tcGlsaW5nChtbMTszNW1pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1p
MDA5LTEwMDg6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KMTM5IHJlYWwgIDk4NSB1
c2VyICAxMDAgc3lzICA3ODAuMDclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOAoy
MDEzLTEwLTA4LTIzOjAxOjE0IGU0MDE1MmVlMWUxYzdhNjNmNDc3Nzc5MTg2MzIxNWUzZmFh
MzdhODYgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy91c2ItYmlz
ZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2U0MDE1MmVl
MWUxYzdhNjNmNDc3Nzc5MTg2MzIxNWUzZmFhMzdhODYKYmlzZWN0OiBza2lwIGJyb2tlbiBi
dWlsZCBmb3IgdjIuNi4zNApnaXQgY2hlY2tvdXQgdjIuNi4zMwpQcmV2aW91cyBIRUFEIHBv
c2l0aW9uIHdhcyBlNDAxNTJlLi4uIExpbnVzIDIuNi4zNApIRUFEIGlzIG5vdyBhdCA2MGIz
NDFiLi4uIExpbnV4IDIuNi4zMwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC90aXA6bWFzdGVyOjYwYjM0MWI3NzhjYzI5Mjlk
ZjE2YzBhNTA0YzkxNjIxYjNjNmE0YWQ6YmlzZWN0LXVzYgoKMjAxMy0xMC0wOC0yMzowMToy
MSA2MGIzNDFiNzc4Y2MyOTI5ZGYxNmMwYTUwNGM5MTYyMWIzYzZhNGFkIGNvbXBpbGluZwob
WzE7MzVtaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODogbWFrZSBvbGRub2NvbmZpZyBmYWls
ZWQbWzBtChtbMTszNW1pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OiBtYWtlIG9sZGNvbmZp
ZyBzdWNjZWVkZWQbWzBtCjQ3MiByZWFsICA5NjIgdXNlciAgOTggc3lzICAyMjQuNTklIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOAoyMDEzLTEwLTA4LTIzOjE0OjA4IDYwYjM0
MWI3NzhjYzI5MjlkZjE2YzBhNTA0YzkxNjIxYjNjNmE0YWQgU0tJUCBCUk9LRU4gQlVJTEQK
Q2hlY2sgZXJyb3MgaW4gL2NjL3dmZy91c2ItYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4LzYwYjM0MWI3NzhjYzI5MjlkZjE2YzBhNTA0YzkxNjIx
YjNjNmE0YWQKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zMwpnaXQgY2hl
Y2tvdXQgdjIuNi4zMgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA2MGIzNDFiLi4uIExp
bnV4IDIuNi4zMwpIRUFEIGlzIG5vdyBhdCAyMjc2M2M1Li4uIExpbnV4IDIuNi4zMgpscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC90aXA6bWFzdGVyOjIyNzYzYzVjZjM2OTBhNjgxNTUxMTYyYzE1ZDM0ZDkzNTMwOGM4ZDc6
YmlzZWN0LXVzYgoKMjAxMy0xMC0wOC0yMzoxNDoxNSAyMjc2M2M1Y2YzNjkwYTY4MTU1MTE2
MmMxNWQzNGQ5MzUzMDhjOGQ3IGNvbXBpbGluZwobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwODogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW1pMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjM2OCByZWFs
ICA5MjAgdXNlciAgOTAgc3lzICAyNzQuNjElIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwOAoyMDEzLTEwLTA4LTIzOjI1OjA5IDIyNzYzYzVjZjM2OTBhNjgxNTUxMTYyYzE1ZDM0
ZDkzNTMwOGM4ZDcgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy91
c2ItYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzIy
NzYzYzVjZjM2OTBhNjgxNTUxMTYyYzE1ZDM0ZDkzNTMwOGM4ZDcKYmlzZWN0OiBza2lwIGJy
b2tlbiBidWlsZCBmb3IgdjIuNi4zMgpnaXQgY2hlY2tvdXQgdjIuNi4zMQpQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyAyMjc2M2M1Li4uIExpbnV4IDIuNi4zMgpIRUFEIGlzIG5vdyBh
dCA3NGZjYTZhLi4uIExpbnV4IDIuNi4zMQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC90aXA6bWFzdGVyOjc0ZmNhNmE0Mjg2
M2ZmYWNhZjdiYTZmMTkzNmE5ZjIyODk1MGY2NTc6YmlzZWN0LXVzYgoKMjAxMy0xMC0wOC0y
MzoyNToxNSA3NGZjYTZhNDI4NjNmZmFjYWY3YmE2ZjE5MzZhOWYyMjg5NTBmNjU3IGNvbXBp
bGluZwobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODogbWFrZSBvbGRub2NvbmZp
ZyBmYWlsZWQbWzBtChtbMTszNW1pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OiBtYWtlIG9s
ZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjEzMCByZWFsICA4NzMgdXNlciAgOTAgc3lzICA3Mzcu
MTUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOAoyMDEzLTEwLTA4LTIzOjI3OjUx
IDc0ZmNhNmE0Mjg2M2ZmYWNhZjdiYTZmMTkzNmE5ZjIyODk1MGY2NTcgU0tJUCBCUk9LRU4g
QlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy91c2ItYmlzZWN0IGFuZCAvdG1wL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4Lzc0ZmNhNmE0Mjg2M2ZmYWNhZjdiYTZmMTkz
NmE5ZjIyODk1MGY2NTcKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zMQpn
aXQgY2hlY2tvdXQgdjIuNi4zMApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA3NGZjYTZh
Li4uIExpbnV4IDIuNi4zMQpIRUFEIGlzIG5vdyBhdCAwN2EyMDM5Li4uIExpbnV4IDIuNi4z
MApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwOC90aXA6bWFzdGVyOjA3YTIwMzliOGViMGFmNGZmNDY0ZWZkM2RmZDk1ZGU1YzAy
NjQ4YzY6YmlzZWN0LXVzYgoKMjAxMy0xMC0wOC0yMzoyNzo1NSAwN2EyMDM5YjhlYjBhZjRm
ZjQ2NGVmZDNkZmQ5NWRlNWMwMjY0OGM2IGNvbXBpbGluZwobWzE7MzVtaTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwODogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW1pMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjEy
OCByZWFsICA3ODEgdXNlciAgODYgc3lzICA2NzMuNjUlIGNwdSAJaTM4Ni1yYW5kY29uZmln
LWkwMDktMTAwOAoyMDEzLTEwLTA4LTIzOjMwOjI0IDA3YTIwMzliOGViMGFmNGZmNDY0ZWZk
M2RmZDk1ZGU1YzAyNjQ4YzYgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2Nj
L3dmZy91c2ItYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0x
MDA4LzA3YTIwMzliOGViMGFmNGZmNDY0ZWZkM2RmZDk1ZGU1YzAyNjQ4YzYKYmlzZWN0OiBz
a2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zMApnaXQgY2hlY2tvdXQgdjIuNi4yOQpQcmV2
aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAwN2EyMDM5Li4uIExpbnV4IDIuNi4zMApIRUFEIGlz
IG5vdyBhdCA4ZTBlZTQzLi4uIExpbnV4IDIuNi4yOQpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC90aXA6bWFzdGVyOjhlMGVl
NDNiYzJjM2UxOWRiNTZhNGFkYWE5YTliMDRjZTg4NWNkODQ6YmlzZWN0LXVzYgoKMjAxMy0x
MC0wOC0yMzozMDoyOSA4ZTBlZTQzYmMyYzNlMTlkYjU2YTRhZGFhOWE5YjA0Y2U4ODVjZDg0
IGNvbXBpbGluZwobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODogbWFrZSBvbGRu
b2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW1pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OiBt
YWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjE4MyByZWFsICA3MjQgdXNlciAgNzUgc3lz
ICA0MzYuNjclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOAoyMDEzLTEwLTA4LTIz
OjM0OjUzIDhlMGVlNDNiYzJjM2UxOWRiNTZhNGFkYWE5YTliMDRjZTg4NWNkODQgU0tJUCBC
Uk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy91c2ItYmlzZWN0IGFuZCAvdG1w
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzhlMGVlNDNiYzJjM2UxOWRiNTZh
NGFkYWE5YTliMDRjZTg4NWNkODQKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIu
Ni4yOQpnaXQgY2hlY2tvdXQgdjIuNi4yOApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA4
ZTBlZTQzLi4uIExpbnV4IDIuNi4yOQpIRUFEIGlzIG5vdyBhdCA0YTY5MDhhLi4uIExpbnV4
IDIuNi4yOApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwOC90aXA6bWFzdGVyOjRhNjkwOGEzYTA1MGFhY2M5YzNhMmYzNmIyNzZi
NDZjMDYyOWFkOTE6YmlzZWN0LXVzYgoKMjAxMy0xMC0wOC0yMzozNDo1NyA0YTY5MDhhM2Ew
NTBhYWNjOWMzYTJmMzZiMjc2YjQ2YzA2MjlhZDkxIGNvbXBpbGluZwobWzE7MzVtaTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwODogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTsz
NW1pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQb
WzBtCjExNCByZWFsICA3MTMgdXNlciAgNzIgc3lzICA2ODQuNTclIGNwdSAJaTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwOAoyMDEzLTEwLTA4LTIzOjM3OjE0IDRhNjkwOGEzYTA1MGFhY2M5
YzNhMmYzNmIyNzZiNDZjMDYyOWFkOTEgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3Mg
aW4gL2NjL3dmZy91c2ItYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4LzRhNjkwOGEzYTA1MGFhY2M5YzNhMmYzNmIyNzZiNDZjMDYyOWFkOTEKYmlz
ZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yOApnaXQgY2hlY2tvdXQgdjIuNi4y
NwpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA0YTY5MDhhLi4uIExpbnV4IDIuNi4yOApI
RUFEIGlzIG5vdyBhdCAzZmE4NzQ5Li4uIExpbnV4IDIuNi4yNwpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC90aXA6bWFzdGVy
OjNmYTg3NDllNTg0YjU1ZjExODA0MTFhYjFiNTExMTcxOTBiYWMxZTU6YmlzZWN0LXVzYgoK
MjAxMy0xMC0wOC0yMzozNzoxOCAzZmE4NzQ5ZTU4NGI1NWYxMTgwNDExYWIxYjUxMTE3MTkw
YmFjMWU1IGNvbXBpbGluZwobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODogbWFr
ZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW1pMzg2LXJhbmRjb25maWctaTAwOS0x
MDA4OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtChtbMTszNW1pMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4OiBtYWtlIHByZXBhcmUgZmFpbGVkG1swbQoyMDEzLTEwLTA4LTIzOjM3
OjMxIDNmYTg3NDllNTg0YjU1ZjExODA0MTFhYjFiNTExMTcxOTBiYWMxZTUgU0tJUCBCUk9L
RU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy91c2ItYmlzZWN0IGFuZCAvdG1wL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzNmYTg3NDllNTg0YjU1ZjExODA0MTFh
YjFiNTExMTcxOTBiYWMxZTUKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4y
NwpnaXQgY2hlY2tvdXQgdjIuNi4yNgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAzZmE4
NzQ5Li4uIExpbnV4IDIuNi4yNwpIRUFEIGlzIG5vdyBhdCBiY2U3Zjc5Li4uIExpbnV4IDIu
Ni4yNgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWkwMDktMTAwOC90aXA6bWFzdGVyOmJjZTdmNzkzZGFlYzNlNjVlYzVjNTcwNWQyNDU3Yjgx
ZmU3YjU3MjU6YmlzZWN0LXVzYgoKMjAxMy0xMC0wOC0yMzozNzo0MyBiY2U3Zjc5M2RhZWMz
ZTY1ZWM1YzU3MDVkMjQ1N2I4MWZlN2I1NzI1IGNvbXBpbGluZwobWzE7MzVtaTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwODogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW1p
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBt
CjExMyByZWFsICA1OTkgdXNlciAgNTQgc3lzICA1NzYuMDYlIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwOAoyMDEzLTEwLTA4LTIzOjQxOjE4IGJjZTdmNzkzZGFlYzNlNjVlYzVj
NTcwNWQyNDU3YjgxZmU3YjU3MjUgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4g
L2NjL3dmZy91c2ItYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4L2JjZTdmNzkzZGFlYzNlNjVlYzVjNTcwNWQyNDU3YjgxZmU3YjU3MjUKYmlzZWN0
OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yNgpnaXQgY2hlY2tvdXQgdjIuNi4yNQpQ
cmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBiY2U3Zjc5Li4uIExpbnV4IDIuNi4yNgpIRUFE
IGlzIG5vdyBhdCA0YjExOWUyLi4uIExpbnV4IDIuNi4yNQpscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC90aXA6bWFzdGVyOjRi
MTE5ZTIxZDBjNjZjMjJlOGNhMDNkZjA1ZDlkZTYyM2QwZWI1MGY6YmlzZWN0LXVzYgoKMjAx
My0xMC0wOC0yMzo0MToyMyA0YjExOWUyMWQwYzY2YzIyZThjYTAzZGYwNWQ5ZGU2MjNkMGVi
NTBmIGNvbXBpbGluZwobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODogbWFrZSBv
bGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW1pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjgxIHJlYWwgIDU1MyB1c2VyICA0OSBz
eXMgIDczOS43NiUgY3B1IAlpMzg2LXJhbmRjb25maWctaTAwOS0xMDA4CjIwMTMtMTAtMDgt
MjM6NDM6MDggNGIxMTllMjFkMGM2NmMyMmU4Y2EwM2RmMDVkOWRlNjIzZDBlYjUwZiBTS0lQ
IEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3VzYi1iaXNlY3QgYW5kIC90
bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvNGIxMTllMjFkMGM2NmMyMmU4
Y2EwM2RmMDVkOWRlNjIzZDBlYjUwZgpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2
Mi42LjI1CmdpdCBjaGVja291dCB2Mi42LjI0ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IDRiMTE5ZTIuLi4gTGludXggMi42LjI1CkhFQUQgaXMgbm93IGF0IDQ5OTE0MDguLi4gTGlu
dXggMi42LjI0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4L3RpcDptYXN0ZXI6NDk5MTQwODRlNzk3NTMwZDliYWFmNTFkZjll
ZGE3N2JhYmM5OGZhODpiaXNlY3QtdXNiCgoyMDEzLTEwLTA4LTIzOjQzOjEzIDQ5OTE0MDg0
ZTc5NzUzMGQ5YmFhZjUxZGY5ZWRhNzdiYWJjOThmYTggY29tcGlsaW5nChtbMTszNW1pMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sx
OzM1bWkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRl
ZBtbMG0KMTk0IHJlYWwgIDUwNiB1c2VyICA0OCBzeXMgIDI4NS40OSUgY3B1IAlpMzg2LXJh
bmRjb25maWctaTAwOS0xMDA4CjIwMTMtMTAtMDgtMjM6NDY6NTIgNDk5MTQwODRlNzk3NTMw
ZDliYWFmNTFkZjllZGE3N2JhYmM5OGZhOCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJv
cyBpbiAvY2Mvd2ZnL3VzYi1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDgvNDk5MTQwODRlNzk3NTMwZDliYWFmNTFkZjllZGE3N2JhYmM5OGZhOApi
aXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjI0CmdpdCBjaGVja291dCB2Mi42
LjIzClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDQ5OTE0MDguLi4gTGludXggMi42LjI0
CkhFQUQgaXMgbm93IGF0IGJiZjI1MDEwZi4uLiBMaW51eCAyLjYuMjMKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvdGlwOm1h
c3RlcjpiYmYyNTAxMGYxYTZiNzYxOTE0NDMwZjVmY2EwODFlYzhjN2FjY2QxOmJpc2VjdC11
c2IKCjIwMTMtMTAtMDgtMjM6NDY6NTcgYmJmMjUwMTBmMWE2Yjc2MTkxNDQzMGY1ZmNhMDgx
ZWM4YzdhY2NkMSBjb21waWxpbmcKG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6
IG1ha2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwODogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQo2OCByZWFsICA0ODEgdXNl
ciAgNDIgc3lzICA3NjIuMjYlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOAoyMDEz
LTEwLTA4LTIzOjQ4OjM1IGJiZjI1MDEwZjFhNmI3NjE5MTQ0MzBmNWZjYTA4MWVjOGM3YWNj
ZDEgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy91c2ItYmlzZWN0
IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2JiZjI1MDEwZjFh
NmI3NjE5MTQ0MzBmNWZjYTA4MWVjOGM3YWNjZDEKYmlzZWN0OiBza2lwIGJyb2tlbiBidWls
ZCBmb3IgdjIuNi4yMwpnaXQgY2hlY2tvdXQgdjIuNi4yMgpQcmV2aW91cyBIRUFEIHBvc2l0
aW9uIHdhcyBiYmYyNTAxMGYuLi4gTGludXggMi42LjIzCkhFQUQgaXMgbm93IGF0IDdkY2Nh
MzAuLi4gTGludXggMi42LjIyCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4L3RpcDptYXN0ZXI6N2RjY2EzMGEzMmFhZGIwNTIw
NDE3NTIxYjBjNDRmNDJkMDlmZTA1YzpiaXNlY3QtdXNiCgoyMDEzLTEwLTA4LTIzOjQ4OjM3
IDdkY2NhMzBhMzJhYWRiMDUyMDQxNzUyMWIwYzQ0ZjQyZDA5ZmUwNWMgY29tcGlsaW5nChtb
MTszNW1pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxl
ZBtbMG0KG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6IG1ha2Ugb2xkY29uZmln
IHN1Y2NlZWRlZBtbMG0KODIgcmVhbCAgNDczIHVzZXIgIDQwIHN5cyAgNjI0LjE2JSBjcHUg
CWkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgKMjAxMy0xMC0wOC0yMzo1MDozMiA3ZGNjYTMw
YTMyYWFkYjA1MjA0MTc1MjFiMGM0NGY0MmQwOWZlMDVjIFNLSVAgQlJPS0VOIEJVSUxECkNo
ZWNrIGVycm9zIGluIC9jYy93ZmcvdXNiLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwOC83ZGNjYTMwYTMyYWFkYjA1MjA0MTc1MjFiMGM0NGY0MmQw
OWZlMDVjCmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjIKZ2l0IGNoZWNr
b3V0IHYyLjYuMjEKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgN2RjY2EzMC4uLiBMaW51
eCAyLjYuMjIKSEVBRCBpcyBub3cgYXQgZGU0NmMzMy4uLiBMaW51eCAyLjYuMjEKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
dGlwOm1hc3RlcjpkZTQ2YzMzNzQ1ZjVlMmFkNTk0YzcyZjJjZjVmNDkwODYxYjE2Y2UxOmJp
c2VjdC11c2IKCjIwMTMtMTAtMDgtMjM6NTA6MzYgZGU0NmMzMzc0NWY1ZTJhZDU5NGM3MmYy
Y2Y1ZjQ5MDg2MWIxNmNlMSBjb21waWxpbmcKG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1pMDA5
LTEwMDg6IG1ha2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtaTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwODogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQoyMSByZWFsICA3
IHVzZXIgIDAgc3lzICA0MC41NyUgY3B1IAlpMzg2LXJhbmRjb25maWctaTAwOS0xMDA4CjIw
MTMtMTAtMDgtMjM6NTE6MTcgZGU0NmMzMzc0NWY1ZTJhZDU5NGM3MmYyY2Y1ZjQ5MDg2MWIx
NmNlMSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3VzYi1iaXNl
Y3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZGU0NmMzMzc0
NWY1ZTJhZDU5NGM3MmYyY2Y1ZjQ5MDg2MWIxNmNlMQpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1
aWxkIGZvciB2Mi42LjIxCmdpdCBjaGVja291dCB2Mi42LjIwClByZXZpb3VzIEhFQUQgcG9z
aXRpb24gd2FzIGRlNDZjMzMuLi4gTGludXggMi42LjIxCkhFQUQgaXMgbm93IGF0IDYyZDBj
ZmMuLi4gTGludXggMi42LjIwCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4L3RpcDptYXN0ZXI6NjJkMGNmY2IyN2NmNzU1Y2Vi
ZGM5M2NhOTVkYWJjODM2MDgwMDdjZDpiaXNlY3QtdXNiCgoyMDEzLTEwLTA4LTIzOjUxOjIw
IDYyZDBjZmNiMjdjZjc1NWNlYmRjOTNjYTk1ZGFiYzgzNjA4MDA3Y2QgY29tcGlsaW5nChtb
MTszNW1pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxl
ZBtbMG0KG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6IG1ha2Ugb2xkY29uZmln
IHN1Y2NlZWRlZBtbMG0KMTMgcmVhbCAgOSB1c2VyICAwIHN5cyAgNzQuMDUlIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLWkwMDktMTAwOAoyMDEzLTEwLTA4LTIzOjUyOjMzIDYyZDBjZmNiMjdj
Zjc1NWNlYmRjOTNjYTk1ZGFiYzgzNjA4MDA3Y2QgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sg
ZXJyb3MgaW4gL2NjL3dmZy91c2ItYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4LzYyZDBjZmNiMjdjZjc1NWNlYmRjOTNjYTk1ZGFiYzgzNjA4MDA3
Y2QKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yMApnaXQgY2hlY2tvdXQg
djIuNi4xOQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA2MmQwY2ZjLi4uIExpbnV4IDIu
Ni4yMApIRUFEIGlzIG5vdyBhdCAwMjE1ZmZiLi4uIExpbnV4IDIuNi4xOQpscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC90aXA6
bWFzdGVyOjAyMTVmZmIwOGNlOTllMmJiNTllY2ExMTRhOTk0OTlhNGQwNmU3MDQ6YmlzZWN0
LXVzYgoKMjAxMy0xMC0wOC0yMzo1MjozOCAwMjE1ZmZiMDhjZTk5ZTJiYjU5ZWNhMTE0YTk5
NDk5YTRkMDZlNzA0IGNvbXBpbGluZwobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
ODogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW1pMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjggcmVhbCAgNyB1c2Vy
ICAwIHN5cyAgMTA4LjU2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgKMjAxMy0x
MC0wOC0yMzo1Mjo1OSAwMjE1ZmZiMDhjZTk5ZTJiYjU5ZWNhMTE0YTk5NDk5YTRkMDZlNzA0
IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93ZmcvdXNiLWJpc2VjdCBh
bmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC8wMjE1ZmZiMDhjZTk5
ZTJiYjU5ZWNhMTE0YTk5NDk5YTRkMDZlNzA0CmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQg
Zm9yIHYyLjYuMTkKZ2l0IGNoZWNrb3V0IHYyLjYuMTgKUHJldmlvdXMgSEVBRCBwb3NpdGlv
biB3YXMgMDIxNWZmYi4uLiBMaW51eCAyLjYuMTkKSEVBRCBpcyBub3cgYXQgZTQ3OGJlYy4u
LiBMaW51eCB2Mi42LjE4LiBBcnJyIQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC90aXA6bWFzdGVyOmU0NzhiZWMwYmEwYTgz
YTQ4YTBmNjk4MjkzNGI2ZGUwNzllN2U2YjM6YmlzZWN0LXVzYgoKMjAxMy0xMC0wOC0yMzo1
MzowMyBlNDc4YmVjMGJhMGE4M2E0OGEwZjY5ODI5MzRiNmRlMDc5ZTdlNmIzIGNvbXBpbGlu
ZwobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODogbWFrZSBvbGRub2NvbmZpZyBm
YWlsZWQbWzBtChtbMTszNW1pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OiBtYWtlIG9sZGNv
bmZpZyBzdWNjZWVkZWQbWzBtCjUzIHJlYWwgIDM5NCB1c2VyICAzNCBzeXMgIDgwNC40MSUg
Y3B1IAlpMzg2LXJhbmRjb25maWctaTAwOS0xMDA4CjIwMTMtMTAtMDgtMjM6NTQ6MTIgZTQ3
OGJlYzBiYTBhODNhNDhhMGY2OTgyOTM0YjZkZTA3OWU3ZTZiMyBTS0lQIEJST0tFTiBCVUlM
RApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3VzYi1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvZTQ3OGJlYzBiYTBhODNhNDhhMGY2OTgyOTM0YjZk
ZTA3OWU3ZTZiMwpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjE4CmdpdCBj
aGVja291dCB2Mi42LjE3ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGU0NzhiZWMuLi4g
TGludXggdjIuNi4xOC4gQXJyciEKSEVBRCBpcyBub3cgYXQgNDI3YWJmYS4uLiBMaW51eCB2
Mi42LjE3CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4L3RpcDptYXN0ZXI6NDI3YWJmYTI4YWZlZGZmYWRmY2E5ZGQ4YjA2N2Vi
NmQzNmJhYzUzZjpiaXNlY3QtdXNiCgoyMDEzLTEwLTA4LTIzOjU0OjE2IDQyN2FiZmEyOGFm
ZWRmZmFkZmNhOWRkOGIwNjdlYjZkMzZiYWM1M2YgY29tcGlsaW5nChtbMTszNW1pMzg2LXJh
bmRjb25maWctaTAwOS0xMDA4OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1
bWkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtb
MG0KNzAgcmVhbCAgMzkyIHVzZXIgIDM3IHN5cyAgNjA5Ljk4JSBjcHUgCWkzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDgKMjAxMy0xMC0wOC0yMzo1NjoxNiA0MjdhYmZhMjhhZmVkZmZhZGZj
YTlkZDhiMDY3ZWI2ZDM2YmFjNTNmIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGlu
IC9jYy93ZmcvdXNiLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwOC80MjdhYmZhMjhhZmVkZmZhZGZjYTlkZDhiMDY3ZWI2ZDM2YmFjNTNmCmJpc2Vj
dDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMTcKG1sxOzM1bUNhbm5vdCBmaW5kIHRo
ZSBmaXJzdCBnb29kIGNvbW1pdC4bWzBtChtbMTszNW1jYW5ub3QgZmluZCB0aGUgZmlyc3Qg
YmFkIGNvbW1pdBtbMG0KCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcg
bGludXMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDgvdGlwOm1hc3Rlcjo4YjVlZGU2OWQyNGRiOTM5ZjUyYjQ3ZWZmZmYyZjZm
ZTFlODNlMDhiOmJpc2VjdC11c2IKIFRFU1QgRkFJTFVSRQpbICAgIDIuMjgyODkxXSBOZXRT
YzUyMCBmbGFzaCBkZXZpY2U6IDB4MTAwMDAwIGF0IDB4MjAwMDAwClsgICAgMi4yODQ2MTVd
IC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDIuMjg2MDk2XSBX
QVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGFyY2gveDg2L21tL2lvcmVtYXAuYzoxMDIgX19p
b3JlbWFwX2NhbGxlcisweDEzZi8weDNmMCgpClsgICAgMi4yODkxNDNdIENQVTogMCBQSUQ6
IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEyLjAtcmM0LTAwMDE5LWc4YjVlZGU2
ICMyOTYKWyAgICAyLjI5MTYyNF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1Mg
Qm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuMjkzMjgxXSAgMDAwMDAwMDAgMDAwMDAwMDAgY2Q4
ZDllMzQgYzBlMmM0MjAgY2Q4ZDllNjQgYzAyM2QwODUgYzEyNDFiZjggMDAwMDAwMDAKWyAg
ICAyLjI5NjcxNF0gIDAwMDAwMDAxIGMxMjQwYjgwIDAwMDAwMDY2IGMwMjJmODZmIGMwMjJm
ODZmIDAwMDAwMjAwIDAwMDAwMDAxIDAwMDAwMDAxClsgICAgMi4zMDAwNzddICBjZDhkOWU3
NCBjMDIzZDE3MiAwMDAwMDAwOSAwMDAwMDAwMCBjZDhkOWVjOCBjMDIyZjg2ZiBjZDhkOWVi
NCAwMDAwMDI0NgpbICAgIDIuMzAzNTI4XSBDYWxsIFRyYWNlOgpbICAgIDIuMzA0NTY4XSAg
WzxjMGUyYzQyMD5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICAgMi4zMDU5MzBdICBbPGMw
MjNkMDg1Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3NS8weDkwClsgICAgMi4zMDc1NTVd
ICBbPGMwMjJmODZmPl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTNmLzB4M2YwClsgICAgMi4z
MDkxODNdICBbPGMwMjJmODZmPl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4MTNmLzB4M2YwClsg
ICAgMi4zMTA3MjNdICBbPGMwMjNkMTcyPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MjIvMHgz
MApbICAgIDIuMzEyMjMyXSAgWzxjMDIyZjg2Zj5dIF9faW9yZW1hcF9jYWxsZXIrMHgxM2Yv
MHgzZjAKWyAgICAyLjMxMzczNV0gIFs8YzBlMTM5YjQ+XSA/IHByaW50aysweDNkLzB4M2YK
WyAgICAyLjMxNTA0N10gIFs8YzE1ZGI0ZTI+XSA/IGluaXRfc2M1MjBjZHArMHgyMTYvMHgy
MTYKWyAgICAyLjMxNjU1Nl0gIFs8YzAyMmZiNjk+XSBpb3JlbWFwX25vY2FjaGUrMHgxOS8w
eDIwClsgICAgMi4zMTgwNjJdICBbPGMxNWRiNTI2Pl0gPyBpbml0X25ldHNjNTIwKzB4NDQv
MHhmNgpbICAgIDIuMzE5NjAwXSAgWzxjMTVkYjUyNj5dIGluaXRfbmV0c2M1MjArMHg0NC8w
eGY2ClsgICAgMi4zMjEwNDhdICBbPGMxNTk2YmM4Pl0gZG9fb25lX2luaXRjYWxsKzB4MTA2
LzB4MWNlClsgICAgMi4zMjI1ODNdICBbPGMwNzI5YWIyPl0gPyBzdHJsZW4rMHgxMi8weDIw
ClsgICAgMi4zMjM5MzJdICBbPGMxNTk2NTAwPl0gPyByZXBhaXJfZW52X3N0cmluZysweDMv
MHg1MQpbICAgIDIuMzI1NTAzXSAgWzxjMDI1OWI2Nj5dID8gcGFyc2VfYXJncysweDI5Ni8w
eDRiMApbICAgIDIuMzI3MDIxXSAgWzxjMTU5NmRjMD5dIGtlcm5lbF9pbml0X2ZyZWVhYmxl
KzB4MTMwLzB4MWMyClsgICAgMi4zMjg2MTFdICBbPGMxNTk2NGZkPl0gPyBkb19lYXJseV9w
YXJhbSsweDc4LzB4NzgKWyAgICAyLjMyOTk2OF0gIFs8YzBlMGUzNjA+XSBrZXJuZWxfaW5p
dCsweDEwLzB4MTQwClsgICAgMi4zMzE0MjBdICBbPGMwZTM4M2ZiPl0gcmV0X2Zyb21fa2Vy
bmVsX3RocmVhZCsweDFiLzB4MzAKWyAgICAyLjMzMzExNF0gIFs8YzBlMGUzNTA+XSA/IHJl
c3RfaW5pdCsweDgwLzB4ODAKWyAgICAyLjMzNDU4MF0gLS0tWyBlbmQgdHJhY2UgYTJlMWFi
NDM4NjU4ZjFhZCBdLS0tClsgICAgMi4zMzc2NzVdIENyZWF0aW5nIDQgTVREIHBhcnRpdGlv
bnMgb24gIm5ldHNjNTIwIEZsYXNoIEJhbmsiOgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
MDA5LTEwMDgvOGI1ZWRlNjlkMjRkYjkzOWY1MmI0N2VmZmZmMmY2ZmUxZTgzZTA4Yi9kbWVz
Zy15b2N0by1jYWlyby0xODoyMDEzMTAwODIwMzM0NTppMzg2LXJhbmRjb25maWctaTAwOS0x
MDA4OjMuMTIuMC1yYzQtMDAwMTktZzhiNWVkZTY6Mjk2Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwOC84YjVlZGU2OWQyNGRiOTM5ZjUyYjQ3ZWZmZmYyZjZmZTFlODNlMDhi
L2RtZXNnLXlvY3RvLWpha2V0b3duLTMwOjIwMTMxMDA4MjAzMzQ5OmkzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMDAxOS1nOGI1ZWRlNjoyOTYKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4LzhiNWVkZTY5ZDI0ZGI5MzlmNTJiNDdlZmZmZjJmNmZl
MWU4M2UwOGIvZG1lc2ctcXVhbnRhbC1yb2FtLTE1OjIwMTMxMDA4MjAzMzQyOmkzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMDAxOS1nOGI1ZWRlNjoyOTYKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzhiNWVkZTY5ZDI0ZGI5MzlmNTJiNDdlZmZm
ZjJmNmZlMWU4M2UwOGIvZG1lc2cteW9jdG8tc25iLTE0OjIwMTMxMDA4MjAzMzQ3OmkzODYt
cmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMDAxOS1nOGI1ZWRlNjoyOTYKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzhiNWVkZTY5ZDI0ZGI5MzlmNTJiNDdl
ZmZmZjJmNmZlMWU4M2UwOGIvZG1lc2ctcXVhbnRhbC14cHMtMToyMDEzMTAwOTA0Mjk1MTpp
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDAwMTktZzhiNWVkZTY6Mjk2
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC84YjVlZGU2OWQyNGRiOTM5ZjUy
YjQ3ZWZmZmYyZjZmZTFlODNlMDhiL2RtZXNnLXlvY3RvLXhwcy0zOjIwMTMxMDA5MDQyOTU2
OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMDAxOS1nOGI1ZWRlNjoy
OTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzhiNWVkZTY5ZDI0ZGI5Mzlm
NTJiNDdlZmZmZjJmNmZlMWU4M2UwOGIvZG1lc2cteW9jdG8tcm9hbS0xNjoyMDEzMTAwODIw
MzM0NzppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDAwMTktZzhiNWVk
ZTY6Mjk2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC84YjVlZGU2OWQyNGRi
OTM5ZjUyYjQ3ZWZmZmYyZjZmZTFlODNlMDhiL2RtZXNnLXlvY3RvLXhpYW4tNjoyMDEzMTAw
ODIwMzM0MjppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDAwMTktZzhi
NWVkZTY6Mjk2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC84YjVlZGU2OWQy
NGRiOTM5ZjUyYjQ3ZWZmZmYyZjZmZTFlODNlMDhiL2RtZXNnLXlvY3RvLXNuYi00MDoyMDEz
MTAwODA1NTkyOTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDAwMTkt
ZzhiNWVkZTY6Mjk2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC84YjVlZGU2
OWQyNGRiOTM5ZjUyYjQ3ZWZmZmYyZjZmZTFlODNlMDhiL2RtZXNnLXF1YW50YWwtY2Fpcm8t
NjoyMDEzMTAwODA1NTkwMzppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQt
MDAwMTktZzhiNWVkZTY6Mjk2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC84
YjVlZGU2OWQyNGRiOTM5ZjUyYjQ3ZWZmZmYyZjZmZTFlODNlMDhiL2RtZXNnLXF1YW50YWwt
d2FpbWVhLTEzOjIwMTMxMDA4MTM1NjU0OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4x
Mi4wLXJjNC0wMDAxOS1nOGI1ZWRlNjoyOTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4LzhiNWVkZTY5ZDI0ZGI5MzlmNTJiNDdlZmZmZjJmNmZlMWU4M2UwOGIvZG1lc2ct
eW9jdG8td2FpbWVhLTE1OjIwMTMxMDA4MTM1NjU2OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDg6My4xMi4wLXJjNC0wMDAxOS1nOGI1ZWRlNjoyOTYKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4LzhiNWVkZTY5ZDI0ZGI5MzlmNTJiNDdlZmZmZjJmNmZlMWU4M2UwOGIv
ZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0xMjoyMDEzMTAwNzIwMzAwOTppMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDAwMTktZzhiNWVkZTY6Mjk2Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWkwMDktMTAwOC84YjVlZGU2OWQyNGRiOTM5ZjUyYjQ3ZWZmZmYyZjZm
ZTFlODNlMDhiL2RtZXNnLXlvY3RvLXdhaW1lYS04OjIwMTMxMDA4MTM1NjQ2OmkzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMDAxOS1nOGI1ZWRlNjoyOTYKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzhiNWVkZTY5ZDI0ZGI5MzlmNTJiNDdlZmZm
ZjJmNmZlMWU4M2UwOGIvZG1lc2cteW9jdG8tYmF5LTQ6MjAxMzEwMDgyMDMzNDY6aTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAwMDE5LWc4YjVlZGU2OjI5Ngova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOGI1ZWRlNjlkMjRkYjkzOWY1MmI0N2Vm
ZmZmMmY2ZmUxZTgzZTA4Yi9kbWVzZy15b2N0by1uaG00LTE6MjAxMzEwMDgxMjM4NTQ6aTM4
Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAwMDE5LWc4YjVlZGU2OjI5Ngov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOGI1ZWRlNjlkMjRkYjkzOWY1MmI0
N2VmZmZmMmY2ZmUxZTgzZTA4Yi9kbWVzZy1xdWFudGFsLXhwcy03OjIwMTMxMDA5MDQzMDAz
OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMDAxOS1nOGI1ZWRlNjoy
OTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzhiNWVkZTY5ZDI0ZGI5Mzlm
NTJiNDdlZmZmZjJmNmZlMWU4M2UwOGIvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0xMToyMDEz
MTAwNzIwMjk1MTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDAwMTkt
ZzhiNWVkZTY6Mjk2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC84YjVlZGU2
OWQyNGRiOTM5ZjUyYjQ3ZWZmZmYyZjZmZTFlODNlMDhiL2RtZXNnLXF1YW50YWwtbGtwLXR0
MDItMTg6MjAxMzEwMDcyMDMwMTg6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAt
cmM0LTAwMDE5LWc4YjVlZGU2OjI5Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDgvOGI1ZWRlNjlkMjRkYjkzOWY1MmI0N2VmZmZmMmY2ZmUxZTgzZTA4Yi9kbWVzZy1xdWFu
dGFsLXhpYW4tMTE6MjAxMzEwMDgyMDMzMzY6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODoz
LjEyLjAtcmM0LTAwMDE5LWc4YjVlZGU2OjI5Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
MDA5LTEwMDgvOGI1ZWRlNjlkMjRkYjkzOWY1MmI0N2VmZmZmMmY2ZmUxZTgzZTA4Yi9kbWVz
Zy1xdWFudGFsLXN0b2FrbGV5LTE6MjAxMzEwMDgyMDMzNTQ6aTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwODozLjEyLjAtcmM0LTAwMDE5LWc4YjVlZGU2OjI5Ngova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDgvOGI1ZWRlNjlkMjRkYjkzOWY1MmI0N2VmZmZmMmY2ZmUxZTgz
ZTA4Yi9kbWVzZy15b2N0by1yb2FtLTIwOjIwMTMxMDA4MjAzMzQxOmkzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMDAxOS1nOGI1ZWRlNjoyOTYKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4LzhiNWVkZTY5ZDI0ZGI5MzlmNTJiNDdlZmZmZjJmNmZl
MWU4M2UwOGIvZG1lc2cteW9jdG8tYXRoZW5zLTU6MjAxMzEwMDgyMDMzNTE6aTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAwMDE5LWc4YjVlZGU2OjI5Ngova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOGI1ZWRlNjlkMjRkYjkzOWY1MmI0N2VmZmZm
MmY2ZmUxZTgzZTA4Yi9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTE4OjIwMTMxMDA4MTEwNDUx
OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMDAxOS1nOGI1ZWRlNjoy
OTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzhiNWVkZTY5ZDI0ZGI5Mzlm
NTJiNDdlZmZmZjJmNmZlMWU4M2UwOGIvZG1lc2cteW9jdG8tYXRoZW5zLTQ2OjIwMTMxMDA4
MjAzMzU2OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMDAxOS1nOGI1
ZWRlNjoyOTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4LzhiNWVkZTY5ZDI0
ZGI5MzlmNTJiNDdlZmZmZjJmNmZlMWU4M2UwOGIvZG1lc2ctcXVhbnRhbC1zbmItMTA6MjAx
MzEwMDgyMDMzMzk6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAwMDE5
LWc4YjVlZGU2OjI5Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOGI1ZWRl
NjlkMjRkYjkzOWY1MmI0N2VmZmZmMmY2ZmUxZTgzZTA4Yi9kbWVzZy1xdWFudGFsLXJvYW0t
MzA6MjAxMzEwMDgyMDMzNTI6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0
LTAwMDE5LWc4YjVlZGU2OjI5Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
OGI1ZWRlNjlkMjRkYjkzOWY1MmI0N2VmZmZmMmY2ZmUxZTgzZTA4Yi9kbWVzZy15b2N0by14
aWFuLTI2OjIwMTMxMDA4MjAzMzU4OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4w
LXJjNC0wMDAxOS1nOGI1ZWRlNjoyOTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0x
MDA4LzhiNWVkZTY5ZDI0ZGI5MzlmNTJiNDdlZmZmZjJmNmZlMWU4M2UwOGIvZG1lc2cteW9j
dG8tbGtwLXR0MDItMTE6MjAxMzEwMDgxMTA1MDM6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
ODozLjEyLjAtcmM0LTAwMDE5LWc4YjVlZGU2OjI5Ngova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDgvOGI1ZWRlNjlkMjRkYjkzOWY1MmI0N2VmZmZmMmY2ZmUxZTgzZTA4Yi9k
bWVzZy1xdWFudGFsLWxrcC10dDAyLTIyOjIwMTMxMDA4MTEwNDQ5OmkzODYtcmFuZGNvbmZp
Zy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMDAxOS1nOGI1ZWRlNjoyOTYKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4LzhiNWVkZTY5ZDI0ZGI5MzlmNTJiNDdlZmZmZjJmNmZl
MWU4M2UwOGIvZG1lc2cteW9jdG8td2FpbWVhLTc6MjAxMzEwMDkwNDMwNDA6aTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAwMDE5LWc4YjVlZGU2OjI5Ngova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOGI1ZWRlNjlkMjRkYjkzOWY1MmI0N2VmZmZm
MmY2ZmUxZTgzZTA4Yi9kbWVzZy1xdWFudGFsLXNuYi0xMDoyMDEzMTAwODA1NTkyOTppMzg2
LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDAwMTktZzhiNWVkZTY6Mjk2CjA6
MzI6MzIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDog
MjAgICMgL2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgoKPT09PT09PT09IGxpbnV4
LW5leHQgPT09PT09PT09CkZldGNoaW5nIG5leHQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvdGlwOm1hc3RlcjphMGNmMWFi
YzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmOmJpc2VjdC11c2IKIFRFU1QgRkFJ
TFVSRQpbICAgIDEuNzU1MDUzXSBOZXRTYzUyMCBmbGFzaCBkZXZpY2U6IDB4MTAwMDAwIGF0
IDB4MjAwMDAwClsgICAgMS43NTYzNDNdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0t
LS0tLS0tLQpbICAgIDEuNzU3NTMxXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGFyY2gv
eDg2L21tL2lvcmVtYXAuYzoxMDIgX19pb3JlbWFwX2NhbGxlcisweDEzZi8weDNmMCgpClsg
ICAgMS43NTk5MTBdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAz
LjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWIgIzU3MQpbICAgIDEuNzYy
MTI5XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDEx
ClsgICAgMS43NjM1MDVdICAwMDAwMDAwMCAwMDAwMDAwMCBjZDhkOWUzNCBjMGUwNDE2OCBj
ZDhkOWU2NCBjMDIzYzNlNSBjMTIxYzJlYyAwMDAwMDAwMApbICAgIDEuNzY2MzM5XSAgMDAw
MDAwMDEgYzEyMWIzZTAgMDAwMDAwNjYgYzAyMmYyN2YgYzAyMmYyN2YgMDAwMDAyMDAgMDAw
MDAwMDEgMDAwMDAwMDEKWyAgICAxLjc2OTE3NF0gIGNkOGQ5ZTc0IGMwMjNjNGQyIDAwMDAw
MDA5IDAwMDAwMDAwIGNkOGQ5ZWM4IGMwMjJmMjdmIGNkOGQ5ZWI0IDAwMDAwMjQ2ClsgICAg
MS43NzIwMDRdIENhbGwgVHJhY2U6ClsgICAgMS43NzI4MzVdICBbPGMwZTA0MTY4Pl0gZHVt
cF9zdGFjaysweDE2LzB4MTgKWyAgICAxLjc3NDAwMF0gIFs8YzAyM2MzZTU+XSB3YXJuX3Ns
b3dwYXRoX2NvbW1vbisweDc1LzB4OTAKWyAgICAxLjc3NTMxNl0gIFs8YzAyMmYyN2Y+XSA/
IF9faW9yZW1hcF9jYWxsZXIrMHgxM2YvMHgzZjAKWyAgICAxLjc3NjYxNV0gIFs8YzAyMmYy
N2Y+XSA/IF9faW9yZW1hcF9jYWxsZXIrMHgxM2YvMHgzZjAKWyAgICAxLjc3NzkxN10gIFs8
YzAyM2M0ZDI+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyMi8weDMwClsgICAgMS43NzkyMThd
ICBbPGMwMjJmMjdmPl0gX19pb3JlbWFwX2NhbGxlcisweDEzZi8weDNmMApbICAgIDEuNzgw
NDg5XSAgWzxjMGRlYjE4NT5dID8gcHJpbnRrKzB4M2QvMHgzZgpbICAgIDEuNzgxNjIxXSAg
WzxjMTVhZjNhNT5dID8gaW5pdF9zYzUyMGNkcCsweDIxNi8weDIxNgpbICAgIDEuNzgyODk5
XSAgWzxjMDIyZjU3OT5dIGlvcmVtYXBfbm9jYWNoZSsweDE5LzB4MjAKWyAgICAxLjc4NDEz
MF0gIFs8YzE1YWYzZTk+XSA/IGluaXRfbmV0c2M1MjArMHg0NC8weGY2ClsgICAgMS43ODUz
NzZdICBbPGMxNWFmM2U5Pl0gaW5pdF9uZXRzYzUyMCsweDQ0LzB4ZjYKWyAgICAxLjc4NjU3
OF0gIFs8YzE1NmFiYzY+XSBkb19vbmVfaW5pdGNhbGwrMHgxMDgvMHgxY2UKWyAgICAxLjc4
NzgzN10gIFs8YzAzNWYxZDA+XSA/IHByb2NfcmVnaXN0ZXIrMHg2MC8weDE0MApbICAgIDEu
Nzg5MDk5XSAgWzxjMDM1ZjA4Yj5dID8gX19wcm9jX2NyZWF0ZSsweDhiLzB4YzAKWyAgICAx
Ljc5MDMzN10gIFs8YzE1NmE1MDA+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4My8weDUxClsg
ICAgMS43OTE2MDhdICBbPGMwMjU4MmE2Pl0gPyBwYXJzZV9hcmdzKzB4Mjk2LzB4NGIwClsg
ICAgMS43OTI4NTJdICBbPGMxNTZhZGI0Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMjgv
MHgxYmYKWyAgICAxLjc5NDE5MF0gIFs8YzE1NmE0ZmQ+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4
NzgvMHg3OApbICAgIDEuNzk1NDUwXSAgWzxjMGRlNWFiMD5dIGtlcm5lbF9pbml0KzB4MTAv
MHgxNDAKWyAgICAxLjc5NjYzNl0gIFs8YzBlMTAwM2I+XSByZXRfZnJvbV9rZXJuZWxfdGhy
ZWFkKzB4MWIvMHgzMApbICAgIDEuNzk3OTYyXSAgWzxjMGRlNWFhMD5dID8gcmVzdF9pbml0
KzB4NzAvMHg3MApbICAgIDEuNzk5MTU3XSAtLS1bIGVuZCB0cmFjZSBhZThhNmYyNjYyZjJm
M2MyIF0tLS0KWyAgICAxLjgwMTIwMl0gQ3JlYXRpbmcgNCBNVEQgcGFydGl0aW9ucyBvbiAi
bmV0c2M1MjAgRmxhc2ggQmFuayI6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3Rv
LWNhaXJvLTc6MjAxMzEwMDgyMDQxMzQ6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEy
LjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NTcxCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZh
OGNiMWNmL2RtZXNnLXF1YW50YWwteGlhbi0zNjoyMDEzMTAwODIwNDEzMTppMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFh
Yjo1NzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2EwY2YxYWJjMjVhYzE5
N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8tbGtwLXN0MDEtNToyMDEz
MTAwODIwNDEzMzppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzItbmV4dC0y
MDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1NzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ct
eW9jdG8taW5uLTEwOjIwMTMxMDA4MjA0MTMwOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6
My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjU3MQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQx
MDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLWJheS00OjIwMTMxMDA4MjA0MTI5OmkzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNm
MWFiOjU3MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvYTBjZjFhYmMyNWFj
MTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1jYWlyby0yMToyMDEz
MTAwODIwNDEzMzppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzItbmV4dC0y
MDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1NzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ct
eW9jdG8tbGtwLXR0MDItMTI6MjAxMzEwMDgxMTEyMzg6aTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NTcxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2Mw
ZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXdhaW1lYS0xMjoyMDEzMTAwOTA0MzgxOTpp
Mzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEw
MC1nYTBjZjFhYjo1NzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2EwY2Yx
YWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8tYW50LTI6
MjAxMzEwMDgyMDQyMzE6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmMyLW5l
eHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWkwMDktMTAwOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2Rt
ZXNnLXF1YW50YWwtbGtwLXR0MDItNToyMDEzMTAwODExMTI0NzppMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1NzEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2EwY2YxYWJjMjVhYzE5N2RkOTdi
ODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8tamFrZXRvd24tMzY6MjAxMzEwMDgy
MDQxMzY6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmMyLW5leHQtMjAxMzA5
MjctMDMxMDAtZ2EwY2YxYWI6NTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAw
OC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3Rv
LWpha2V0b3duLTIyOjIwMTMxMDA4MjA0MTQzOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6
My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjU3MQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQx
MDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTI0OjIwMTMxMDA4MTExMjQ1Omkz
ODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAw
LWdhMGNmMWFiOjU3MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvYTBjZjFh
YmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1jYWlyby00
NjoyMDEzMTAwODIwNDEzMzppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzIt
bmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1NzEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2Yv
ZG1lc2ctcXVhbnRhbC1zbmItNDU6MjAxMzEwMDgyMDQxNDI6aTM4Ni1yYW5kY29uZmlnLWkw
MDktMTAwODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NTcxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1
N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50YWwteHBzLTc6MjAxMzEwMDkwNDM3Mzg6
aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMx
MDAtZ2EwY2YxYWI6NTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9hMGNm
MWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50YWwtc25i
LTE6MjAxMzEwMDgyMDQxMzA6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmMy
LW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNm
L2RtZXNnLXF1YW50YWwtbGtwLXR0MDItMjE6MjAxMzEwMDgxMTEyMzg6aTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6
NTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9hMGNmMWFiYzI1YWMxOTdk
ZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTg6MjAxMzEw
MDgyMDQxNDY6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmMyLW5leHQtMjAx
MzA5MjctMDMxMDAtZ2EwY2YxYWI6NTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlv
Y3RvLXhpYW4tMzI6MjAxMzEwMDgyMDQxMzQ6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODoz
LjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NTcxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWkwMDktMTAwOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEw
NjZhOGNiMWNmL2RtZXNnLXlvY3RvLXNuYi00NDoyMDEzMTAwODIwNDEyOTppMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFh
Yjo1NzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4L2EwY2YxYWJjMjVhYzE5
N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0yMDoy
MDEzMTAwODExMTIzNjppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzItbmV4
dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1NzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1l
c2cteW9jdG8tc25iLTI4OjIwMTMxMDA4MjA0MTQ5OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDg6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjU3MQowOjIzOjIz
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAj
IC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKCj09PT09PT09PSB0aXAvbWFzdGVy
ID09PT09PT09PQpGZXRjaGluZyB0aXAKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvdGlwOm1hc3Rlcjo5N2QzYWI5YjIyMDdk
NzJlYjBmNzIzNDc5NjljMjg0NTYyYzM3NGJkOmJpc2VjdC11c2IKIFRFU1QgRkFJTFVSRQpb
ICAgMzcuMTUyNjYwXSBOZXRTYzUyMCBmbGFzaCBkZXZpY2U6IDB4MTAwMDAwIGF0IDB4MjAw
MDAwClsgICAzNy4xNTQxMTZdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0t
LQpbICAgMzcuMTU1NjY2XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGFyY2gveDg2L21t
L2lvcmVtYXAuYzoxMDIgX19pb3JlbWFwX2NhbGxlcisweDEzZi8weDNmMCgpClsgICAzNy4x
NTgzNTldIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEyLjAt
cmM0LTAxNTg3LWc5N2QzYWI5ICMzNTcKWyAgIDM3LjE1OTU0MV0gSGFyZHdhcmUgbmFtZTog
Qm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMzcuMTYxMzM0XSAgMDAw
MDAwMDAgMDAwMDAwMDAgY2Q4ZDllMzQgYzBlMDA0NjYgY2Q4ZDllNjQgYzAyM2M3NTUgYzEy
MTU4MTggMDAwMDAwMDAKWyAgIDM3LjE2MzYxNF0gIDAwMDAwMDAxIGMxMjE0N2EwIDAwMDAw
MDY2IGMwMjJmMjlmIGMwMjJmMjlmIDAwMDAwMjAwIDAwMDAwMDAxIDAwMDAwMDAxClsgICAz
Ny4xNjUzNzNdICBjZDhkOWU3NCBjMDIzYzg0MiAwMDAwMDAwOSAwMDAwMDAwMCBjZDhkOWVj
OCBjMDIyZjI5ZiAwMDAwMDA2MCAwMDAwMDI0NgpbICAgMzcuMTY3NTY1XSBDYWxsIFRyYWNl
OgpbICAgMzcuMTY4NDA3XSAgWzxjMGUwMDQ2Nj5dIGR1bXBfc3RhY2srMHgxNi8weDE4Clsg
ICAzNy4xNjkzMzZdICBbPGMwMjNjNzU1Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3NS8w
eDkwClsgICAzNy4xNzA2MDJdICBbPGMwMjJmMjlmPl0gPyBfX2lvcmVtYXBfY2FsbGVyKzB4
MTNmLzB4M2YwClsgICAzNy4xNzE1MDRdICBbPGMwMjJmMjlmPl0gPyBfX2lvcmVtYXBfY2Fs
bGVyKzB4MTNmLzB4M2YwClsgICAzNy4xNzIzNzFdICBbPGMwMjNjODQyPl0gd2Fybl9zbG93
cGF0aF9udWxsKzB4MjIvMHgzMApbICAgMzcuMTczMjIzXSAgWzxjMDIyZjI5Zj5dIF9faW9y
ZW1hcF9jYWxsZXIrMHgxM2YvMHgzZjAKWyAgIDM3LjE3NDQ2NV0gIFs8YzBkZTk5ZGI+XSA/
IHByaW50aysweDNkLzB4M2YKWyAgIDM3LjE3NTM3MV0gIFs8YzE1YWY0Y2Q+XSA/IGluaXRf
c2M1MjBjZHArMHgyMTYvMHgyMTYKWyAgIDM3LjE3NjIxN10gIFs8YzAyMmY1OTk+XSBpb3Jl
bWFwX25vY2FjaGUrMHgxOS8weDIwClsgICAzNy4xNzc0MDRdICBbPGMxNWFmNTExPl0gPyBp
bml0X25ldHNjNTIwKzB4NDQvMHhmNgpbICAgMzcuMTc4MjM3XSAgWzxjMTVhZjUxMT5dIGlu
aXRfbmV0c2M1MjArMHg0NC8weGY2ClsgICAzNy4xNzkwMTldICBbPGMxNTZhYmM2Pl0gZG9f
b25lX2luaXRjYWxsKzB4MTA4LzB4MWNlClsgICAzNy4xNzk4MDVdICBbPGMwNzEzODIyPl0g
PyBzdHJsZW4rMHgxMi8weDIwClsgICAzNy4xODA5OTVdICBbPGMxNTZhNTAwPl0gPyByZXBh
aXJfZW52X3N0cmluZysweDMvMHg1MQpbICAgMzcuMTgxODA4XSAgWzxjMDI1ODY0Nj5dID8g
cGFyc2VfYXJncysweDI5Ni8weDRiMApbICAgMzcuMTgyNjAwXSAgWzxjMGUwYzVmMz5dID8g
Y29tbW9uX2ludGVycnVwdCsweDMzLzB4NDAKWyAgIDM3LjE4MzgwM10gIFs8YzE1NmFkYjQ+
XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEyOC8weDFiYQpbICAgMzcuMTg0Njg5XSAgWzxj
MTU2YTRmZD5dID8gZG9fZWFybHlfcGFyYW0rMHg3OC8weDc4ClsgICAzNy4xODU1MTJdICBb
PGMwZGU0MzEwPl0ga2VybmVsX2luaXQrMHgxMC8weDE0MApbICAgMzcuMTg2Mjk3XSAgWzxj
MGUwYzBkYj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAzNy4xODc1
NjFdICBbPGMwZGU0MzAwPl0gPyByZXN0X2luaXQrMHg3MC8weDcwClsgICAzNy4xOTc2NTdd
IC0tLVsgZW5kIHRyYWNlIGY3N2FmYTg2OWVhZDZhNTUgXS0tLQpbICAgMzcuMjE0MTgwXSBD
cmVhdGluZyA0IE1URCBwYXJ0aXRpb25zIG9uICJuZXRzYzUyMCBGbGFzaCBCYW5rIjoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4Lzk3ZDNhYjliMjIwN2Q3MmViMGY3MjM0
Nzk2OWMyODQ1NjJjMzc0YmQvZG1lc2cteW9jdG8td2FpbWVhLTg6MjAxMzEwMDkwNTQzNDE6
aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAxNTg3LWc5N2QzYWI5OjM1
Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdkM2FiOWIyMjA3ZDcyZWIw
ZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0by1sa3AtdHQwMi0yMDoyMDEzMTAw
ODA5MjkyNTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDE1ODctZzk3
ZDNhYjk6MzU3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC85N2QzYWI5YjIy
MDdkNzJlYjBmNzIzNDc5NjljMjg0NTYyYzM3NGJkL2RtZXNnLXF1YW50YWwtaW5uLTg6MjAx
MzEwMDgxODU3MzA6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAxNTg3
LWc5N2QzYWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdkM2Fi
OWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0by1hbnQtMTA6
MjAxMzEwMDgyMTQ4Mjk6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAx
NTg3LWc5N2QzYWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdk
M2FiOWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0by1yb2Ft
LTI3OjIwMTMxMDA4MjE0NjM5OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJj
NC0wMTU4Ny1nOTdkM2FiOTozNTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4
Lzk3ZDNhYjliMjIwN2Q3MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0YmQvZG1lc2ctcXVhbnRh
bC1iYXktMzoyMDEzMTAwODE4NTcyNzppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIu
MC1yYzQtMDE1ODctZzk3ZDNhYjk6MzU3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwOC85N2QzYWI5YjIyMDdkNzJlYjBmNzIzNDc5NjljMjg0NTYyYzM3NGJkL2RtZXNnLXF1
YW50YWwtc25iLTM2OjIwMTMxMDA4MjE0NjQ4OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6
My4xMi4wLXJjNC0wMTU4Ny1nOTdkM2FiOTozNTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4Lzk3ZDNhYjliMjIwN2Q3MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0YmQvZG1l
c2ctcXVhbnRhbC14aWFuLTE1OjIwMTMxMDA4MjE0NjM3OmkzODYtcmFuZGNvbmZpZy1pMDA5
LTEwMDg6My4xMi4wLXJjNC0wMTU4Ny1nOTdkM2FiOTozNTcKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4Lzk3ZDNhYjliMjIwN2Q3MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0
YmQvZG1lc2ctcXVhbnRhbC1pbm4tMjU6MjAxMzEwMDgxODQ3MTM6aTM4Ni1yYW5kY29uZmln
LWkwMDktMTAwODozLjEyLjAtcmM0LTAxNTg3LWc5N2QzYWI5OjM1Nwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdkM2FiOWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2
MmMzNzRiZC9kbWVzZy15b2N0by13YWltZWEtMTU6MjAxMzEwMDkwMjQ0MTk6aTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAxNTg3LWc5N2QzYWI5OjM1Nwova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdkM2FiOWIyMjA3ZDcyZWIwZjcyMzQ3OTY5
YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0by1zbmItMToyMDEzMTAwODIxNDY1ODppMzg2LXJh
bmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDE1ODctZzk3ZDNhYjk6MzU3Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC85N2QzYWI5YjIyMDdkNzJlYjBmNzIzNDc5
NjljMjg0NTYyYzM3NGJkL2RtZXNnLXF1YW50YWwtc3RvYWtsZXktMjoyMDEzMTAwODE4NDcx
OTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDE1ODctZzk3ZDNhYjk6
MzU3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC85N2QzYWI5YjIyMDdkNzJl
YjBmNzIzNDc5NjljMjg0NTYyYzM3NGJkL2RtZXNnLXF1YW50YWwtY2Fpcm8tODoyMDEzMTAw
ODE4NTcyNTppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDE1ODctZzk3
ZDNhYjk6MzU3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC85N2QzYWI5YjIy
MDdkNzJlYjBmNzIzNDc5NjljMjg0NTYyYzM3NGJkL2RtZXNnLXlvY3RvLXJvYW0tMjc6MjAx
MzEwMDgyMTQ2NTU6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAxNTg3
LWc5N2QzYWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdkM2Fi
OWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy1xdWFudGFsLWxrcC1z
dDAxLTM6MjAxMzEwMDgyMTQ2NTQ6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAt
cmM0LTAxNTg3LWc5N2QzYWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDgvOTdkM2FiOWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0
by1zbmItMTQ6MjAxMzEwMDgyMTQ2NDI6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEy
LjAtcmM0LTAxNTg3LWc5N2QzYWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5
LTEwMDgvOTdkM2FiOWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15
b2N0by1sa3AtdHQwMi04OjIwMTMxMDA4MTIxODM1OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEw
MDg6My4xMi4wLXJjNC0wMTU4Ny1nOTdkM2FiOTozNTcKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4Lzk3ZDNhYjliMjIwN2Q3MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0YmQv
ZG1lc2cteW9jdG8tc25iLTIzOjIwMTMxMDA4MjE0NjM4OmkzODYtcmFuZGNvbmZpZy1pMDA5
LTEwMDg6My4xMi4wLXJjNC0wMTU4Ny1nOTdkM2FiOTozNTcKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaTAwOS0xMDA4Lzk3ZDNhYjliMjIwN2Q3MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0
YmQvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMTY6MjAxMzEwMDgxODU3MTk6aTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAxNTg3LWc5N2QzYWI5OjM1Nwova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdkM2FiOWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4
NDU2MmMzNzRiZC9kbWVzZy1xdWFudGFsLWFudC01OjIwMTMxMDA4MTg0ODEyOmkzODYtcmFu
ZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMTU4Ny1nOTdkM2FiOTozNTcKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4Lzk3ZDNhYjliMjIwN2Q3MmViMGY3MjM0Nzk2
OWMyODQ1NjJjMzc0YmQvZG1lc2cteW9jdG8tY2Fpcm8tMzE6MjAxMzEwMDgyMTQ3MTM6aTM4
Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAxNTg3LWc5N2QzYWI5OjM1Nwov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdkM2FiOWIyMjA3ZDcyZWIwZjcy
MzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0by1zdG9ha2xleS0xOjIwMTMxMDA4MjE0
NjU2OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMTU4Ny1nOTdkM2Fi
OTozNTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4Lzk3ZDNhYjliMjIwN2Q3
MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0YmQvZG1lc2cteW9jdG8tc25iLTEyOjIwMTMxMDA4
MjE0NzIzOmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6My4xMi4wLXJjNC0wMTU4Ny1nOTdk
M2FiOTozNTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwOS0xMDA4Lzk3ZDNhYjliMjIw
N2Q3MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0YmQvZG1lc2cteW9jdG8taW5uLTg6MjAxMzEw
MDgxODU3MzM6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAxNTg3LWc5
N2QzYWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdkM2FiOWIy
MjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy1xdWFudGFsLXN0b2FrbGV5
LTI6MjAxMzEwMDgyMTQ2MzY6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0
LTAxNTg3LWc5N2QzYWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgv
OTdkM2FiOWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy1xdWFudGFs
LXJvYW0tMTU6MjAxMzEwMDgyMTQ2NTA6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEy
LjAtcmM0LTAxNTg3LWc5N2QzYWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5
LTEwMDgvOTdkM2FiOWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15
b2N0by1sa3AtdHQwMi0xNDoyMDEzMTAwODA5MTgzMzppMzg2LXJhbmRjb25maWctaTAwOS0x
MDA4OjMuMTIuMC1yYzQtMDE1ODctZzk3ZDNhYjk6MzU3Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwOC85N2QzYWI5YjIyMDdkNzJlYjBmNzIzNDc5NjljMjg0NTYyYzM3NGJk
L2RtZXNnLXlvY3RvLXNuYi0yNDoyMDEzMTAwODIxNDY1ODppMzg2LXJhbmRjb25maWctaTAw
OS0xMDA4OjMuMTIuMC1yYzQtMDE1ODctZzk3ZDNhYjk6MzU3Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWkwMDktMTAwOC85N2QzYWI5YjIyMDdkNzJlYjBmNzIzNDc5NjljMjg0NTYyYzM3
NGJkL2RtZXNnLXlvY3RvLXNuYi0yMjoyMDEzMTAwODIxNDcwMTppMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4OjMuMTIuMC1yYzQtMDE1ODctZzk3ZDNhYjk6MzU3Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWkwMDktMTAwOC85N2QzYWI5YjIyMDdkNzJlYjBmNzIzNDc5NjljMjg0NTYy
YzM3NGJkL2RtZXNnLXF1YW50YWwtaW5uLTI6MjAxMzEwMDgxODU3MTc6aTM4Ni1yYW5kY29u
ZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAxNTg3LWc5N2QzYWI5OjM1Nwova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdkM2FiOWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4
NDU2MmMzNzRiZC9kbWVzZy15b2N0by13YWltZWEtNzoyMDEzMTAwOTA1NDMzMzppMzg2LXJh
bmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDE1ODctZzk3ZDNhYjk6MzU3Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC85N2QzYWI5YjIyMDdkNzJlYjBmNzIzNDc5
NjljMjg0NTYyYzM3NGJkL2RtZXNnLXF1YW50YWwtbGtwLXN0MDEtNToyMDEzMTAwODE4NDcx
ODppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDE1ODctZzk3ZDNhYjk6
MzU3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC85N2QzYWI5YjIyMDdkNzJl
YjBmNzIzNDc5NjljMjg0NTYyYzM3NGJkL2RtZXNnLXlvY3RvLXhpYW4tNDE6MjAxMzEwMDgx
ODU3MzQ6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAxNTg3LWc5N2Qz
YWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdkM2FiOWIyMjA3
ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0by1zbmItMTA6MjAxMzEw
MDgyMTQ2NDA6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEyLjAtcmM0LTAxNTg3LWc5
N2QzYWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDgvOTdkM2FiOWIy
MjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0by1qYWtldG93bi0z
ODoyMDEzMTAwODE4NDgxMjppMzg2LXJhbmRjb25maWctaTAwOS0xMDA4OjMuMTIuMC1yYzQt
MDE1ODctZzk3ZDNhYjk6MzU3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwOC85
N2QzYWI5YjIyMDdkNzJlYjBmNzIzNDc5NjljMjg0NTYyYzM3NGJkL2RtZXNnLXlvY3RvLWxr
cC10dDAyLTg6MjAxMzEwMDgwOTE4MjY6aTM4Ni1yYW5kY29uZmlnLWkwMDktMTAwODozLjEy
LjAtcmM0LTAxNTg3LWc5N2QzYWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDA5
LTEwMDgvOTdkM2FiOWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15
b2N0by1yb2FtLTEyOjIwMTMxMDA4MTg1NzU5OmkzODYtcmFuZGNvbmZpZy1pMDA5LTEwMDg6
My4xMi4wLXJjNC0wMTU4Ny1nOTdkM2FiOTozNTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aTAwOS0xMDA4Lzk3ZDNhYjliMjIwN2Q3MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0YmQvZG1l
c2cteW9jdG8tY2Fpcm8tMTI6MjAxMzEwMDgxODU3MzY6aTM4Ni1yYW5kY29uZmlnLWkwMDkt
MTAwODozLjEyLjAtcmM0LTAxNTg3LWc5N2QzYWI5OjM1Nwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pMDA5LTEwMDgvOTdkM2FiOWIyMjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRi
ZC9kbWVzZy15b2N0by1sa3AtdHQwMi0yNDoyMDEzMTAwODA5MTgyNjppMzg2LXJhbmRjb25m
aWctaTAwOS0xMDA4OjMuMTIuMC1yYzQtMDE1ODctZzk3ZDNhYjk6MzU3CjA6Mzk6MzkgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDogMjAgICMgL2Nj
L3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgo=

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc4-01587-g97d3ab9"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0-rc4 Kernel Configuration
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
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
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
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
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
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_KVMTOOL_TEST_ENABLE is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
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
CONFIG_MGEODEGX1=y
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=4
CONFIG_X86_L1_CACHE_SHIFT=4
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
# CONFIG_X86_UP_IOAPIC is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_INJECT=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_MIGRATION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NETFILTER_XTABLES=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
# CONFIG_BRIDGE_EBT_T_FILTER is not set
CONFIG_BRIDGE_EBT_T_NAT=y
# CONFIG_BRIDGE_EBT_802_3 is not set
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_LIMIT=y
# CONFIG_BRIDGE_EBT_MARK is not set
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
CONFIG_BRIDGE_EBT_STP=y
# CONFIG_BRIDGE_EBT_VLAN is not set
# CONFIG_BRIDGE_EBT_DNAT is not set
# CONFIG_BRIDGE_EBT_MARK_T is not set
# CONFIG_BRIDGE_EBT_REDIRECT is not set
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_PCH_CAN is not set
# CONFIG_CAN_GRCAN is not set
CONFIG_CAN_SJA1000=y
# CONFIG_CAN_SJA1000_ISA is not set
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_SJA1000_OF_PLATFORM=y
# CONFIG_CAN_EMS_PCMCIA is not set
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCMCIA is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
# CONFIG_CAN_ESD_USB2 is not set
CONFIG_CAN_KVASER_USB=y
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_8DEV_USB is not set
CONFIG_CAN_SOFTING=y
CONFIG_CAN_SOFTING_CS=y
# CONFIG_CAN_DEBUG_DEVICES is not set
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
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=y
# CONFIG_ACTISYS_DONGLE is not set
CONFIG_TEKRAM_DONGLE=y
# CONFIG_TOIM3232_DONGLE is not set
CONFIG_LITELINK_DONGLE=y
CONFIG_MA600_DONGLE=y
CONFIG_GIRBIL_DONGLE=y
# CONFIG_MCP2120_DONGLE is not set
CONFIG_OLD_BELKIN_DONGLE=y
# CONFIG_ACT200L_DONGLE is not set
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
# CONFIG_MCS_FIR is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=y
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_BT_ATH3K=y
CONFIG_BT_WILINK=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
# CONFIG_NFC is not set

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
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
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
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_OF_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

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
# CONFIG_MTD_CFI_INTELEXT is not set
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_PHYSMAP_OF is not set
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=y
CONFIG_MTD_PCMCIA_ANONYMOUS=y
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
CONFIG_BCACHE_EDEBUG=y
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
CONFIG_DM_SWITCH=y
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

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
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_STMPE is not set
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_EGALAX=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_STMPE=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_ARIZONA_HAPTICS is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_RETU_PWRBUTTON is not set
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
# CONFIG_INPUT_TWL4030_VIBRA is not set
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF50633_PMU=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
# CONFIG_INPUT_DA9055_ONKEY is not set
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
CONFIG_INPUT_ADXL34X_SPI=y
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
# CONFIG_SERIO_OLPC_APSP is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_OF_PLATFORM=y
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=y
CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_SERIAL_ST_ASC=y
CONFIG_SERIAL_ST_ASC_CONSOLE=y
CONFIG_HVC_DRIVER=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
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
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
# CONFIG_SPI_ATMEL is not set
CONFIG_SPI_BCM2835=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_EP93XX is not set
CONFIG_SPI_GPIO=y
CONFIG_SPI_IMX=y
# CONFIG_SPI_FSL_SPI is not set
# CONFIG_SPI_FSL_DSPI is not set
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_OMAP24XX=y
CONFIG_SPI_TI_QSPI=y
CONFIG_SPI_OMAP_100K=y
CONFIG_SPI_ORION=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SH is not set
# CONFIG_SPI_SH_HSPI is not set
CONFIG_SPI_TEGRA114=y
CONFIG_SPI_TEGRA20_SFLASH=y
CONFIG_SPI_TEGRA20_SLINK=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_TXX9=y
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
CONFIG_GPIO_ADNP=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_RDC321X is not set

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
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_BATTERY_TWL4030_MADC=y
# CONFIG_CHARGER_88PM860X is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_BATTERY_RX51=y
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MAX8997 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_GPIO is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_TWL4030_MADC is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_DA9052_WATCHDOG is not set
# CONFIG_DA9055_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=y
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
# CONFIG_RDC321X_WDT is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
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
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_MFD_CROS_EC_SPI is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_STMPE_SPI=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM8607 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_ARIZONA=y
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=y
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM8400=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
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
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

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
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
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
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_TPS65217=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_FB_SSD1307=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
# CONFIG_SND_PCM_XRUN_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_SPI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_ATMEL_SOC=y
# CONFIG_SND_IMX_SOC is not set
CONFIG_SND_KIRKWOOD_SOC=y
# CONFIG_SND_KIRKWOOD_SOC_OPENRD is not set
# CONFIG_SND_KIRKWOOD_SOC_T5325 is not set
CONFIG_SND_SOC_TEGRA=y
CONFIG_SND_SOC_TEGRA_RT5640=y
# CONFIG_SND_SOC_TEGRA_WM8753 is not set
CONFIG_SND_SOC_TEGRA_WM8903=y
CONFIG_SND_SOC_TEGRA_TRIMSLICE=y
CONFIG_SND_SOC_TEGRA_ALC5632=y
CONFIG_SND_SOC_I2C_AND_SPI=y
CONFIG_SND_SOC_ALL_CODECS=y
CONFIG_SND_SOC_88PM860X=y
CONFIG_SND_SOC_ARIZONA=y
CONFIG_SND_SOC_WM_HUBS=y
CONFIG_SND_SOC_WM_ADSP=y
CONFIG_SND_SOC_AB8500_CODEC=y
CONFIG_SND_SOC_AD1836=y
CONFIG_SND_SOC_AD193X=y
CONFIG_SND_SOC_AD73311=y
CONFIG_SND_SOC_ADAU1701=y
CONFIG_SND_SOC_ADAU1373=y
CONFIG_SND_SOC_ADAV80X=y
CONFIG_SND_SOC_ADS117X=y
CONFIG_SND_SOC_AK4104=y
CONFIG_SND_SOC_AK4535=y
CONFIG_SND_SOC_AK4641=y
CONFIG_SND_SOC_AK4642=y
CONFIG_SND_SOC_AK4671=y
CONFIG_SND_SOC_AK5386=y
CONFIG_SND_SOC_ALC5623=y
CONFIG_SND_SOC_ALC5632=y
CONFIG_SND_SOC_CS42L51=y
CONFIG_SND_SOC_CS42L52=y
CONFIG_SND_SOC_CS42L73=y
CONFIG_SND_SOC_CS4270=y
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CX20442=y
CONFIG_SND_SOC_JZ4740_CODEC=y
CONFIG_SND_SOC_L3=y
CONFIG_SND_SOC_DA7210=y
CONFIG_SND_SOC_DA7213=y
CONFIG_SND_SOC_DA732X=y
CONFIG_SND_SOC_DA9055=y
CONFIG_SND_SOC_BT_SCO=y
CONFIG_SND_SOC_ISABELLE=y
CONFIG_SND_SOC_LM49453=y
CONFIG_SND_SOC_MAX98088=y
CONFIG_SND_SOC_MAX98090=y
CONFIG_SND_SOC_MAX98095=y
CONFIG_SND_SOC_MAX9850=y
CONFIG_SND_SOC_HDMI_CODEC=y
CONFIG_SND_SOC_PCM1681=y
CONFIG_SND_SOC_PCM1792A=y
CONFIG_SND_SOC_PCM3008=y
CONFIG_SND_SOC_RT5631=y
CONFIG_SND_SOC_RT5640=y
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SI476X=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_SSM2518=y
CONFIG_SND_SOC_SSM2602=y
CONFIG_SND_SOC_STA32X=y
CONFIG_SND_SOC_STA529=y
CONFIG_SND_SOC_TAS5086=y
CONFIG_SND_SOC_TLV320AIC23=y
CONFIG_SND_SOC_TLV320AIC26=y
CONFIG_SND_SOC_TLV320AIC32X4=y
CONFIG_SND_SOC_TLV320AIC3X=y
CONFIG_SND_SOC_TLV320DAC33=y
CONFIG_SND_SOC_TWL4030=y
CONFIG_SND_SOC_UDA134X=y
CONFIG_SND_SOC_UDA1380=y
CONFIG_SND_SOC_WL1273=y
CONFIG_SND_SOC_WM0010=y
CONFIG_SND_SOC_WM1250_EV1=y
CONFIG_SND_SOC_WM2000=y
CONFIG_SND_SOC_WM2200=y
CONFIG_SND_SOC_WM5100=y
CONFIG_SND_SOC_WM5102=y
CONFIG_SND_SOC_WM8400=y
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8727=y
CONFIG_SND_SOC_WM8728=y
CONFIG_SND_SOC_WM8731=y
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SOC_WM8770=y
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8782=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8900=y
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8904=y
CONFIG_SND_SOC_WM8940=y
CONFIG_SND_SOC_WM8955=y
CONFIG_SND_SOC_WM8960=y
CONFIG_SND_SOC_WM8961=y
CONFIG_SND_SOC_WM8962=y
CONFIG_SND_SOC_WM8971=y
CONFIG_SND_SOC_WM8974=y
CONFIG_SND_SOC_WM8978=y
CONFIG_SND_SOC_WM8983=y
CONFIG_SND_SOC_WM8985=y
CONFIG_SND_SOC_WM8988=y
CONFIG_SND_SOC_WM8990=y
CONFIG_SND_SOC_WM8991=y
CONFIG_SND_SOC_WM8993=y
CONFIG_SND_SOC_WM8995=y
CONFIG_SND_SOC_WM8996=y
CONFIG_SND_SOC_WM8997=y
CONFIG_SND_SOC_WM9081=y
CONFIG_SND_SOC_WM9090=y
CONFIG_SND_SOC_LM4857=y
CONFIG_SND_SOC_MAX9768=y
CONFIG_SND_SOC_MAX9877=y
CONFIG_SND_SOC_MC13783=y
CONFIG_SND_SOC_ML26124=y
CONFIG_SND_SOC_TPA6130A2=y
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
# CONFIG_SOUND_VMIDI is not set
CONFIG_SOUND_TRIX=y
# CONFIG_TRIX_HAVE_BOOT is not set
CONFIG_SOUND_MSS=y
CONFIG_SOUND_MPU401=y
# CONFIG_SOUND_PAS is not set
CONFIG_SOUND_PSS=y
# CONFIG_PSS_MIXER is not set
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=y
# CONFIG_SOUND_YM3812 is not set
# CONFIG_SOUND_UART6850 is not set
CONFIG_SOUND_AEDSP16=y
# CONFIG_SC6600 is not set
CONFIG_SOUND_KAHLUA=y

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_RENESAS_USBHS_HCD=y
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_DSPS is not set
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=y
# CONFIG_REALTEK_AUTOPM is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
# CONFIG_USB_DWC3 is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_ISP1301=y
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
CONFIG_USB_FOTG210_UDC=y
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_RENESAS_USBHS_UDC=y
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
CONFIG_USB_MIDI_GADGET=y
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_OMAP_HS is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
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
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
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
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

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
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_OF_EXTCON=y
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_ARIZONA=y
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_PCA9685=y
# CONFIG_PWM_TWL is not set
# CONFIG_PWM_TWL_LED is not set
CONFIG_IRQCHIP=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
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
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
# CONFIG_JFFS2_RTIME is not set
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
CONFIG_ROMFS_BACKED_BY_MTD=y
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

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
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCOMP=y
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
CONFIG_CRYPTO_ABLK_HELPER_X86=y

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
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
# CONFIG_CRYPTO_SHA1 is not set
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
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=y
CONFIG_BINARY_PRINTF=y

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
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--0F1p//8PRICkK4MW--
