Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3KLPEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:04:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:53714 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545Ab3KLPEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:04:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,685,1378882800"; 
   d="scan'208";a="426258760"
Date: Tue, 12 Nov 2013 23:03:55 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [seqcount] INFO: trying to register non-static key.
Message-ID: <20131112150355.GA7054@localhost>
References: <20131111012927.GA404@localhost>
 <20131111154551.GJ19203@twins.programming.kicks-ass.net>
 <20131112094147.GA32441@localhost>
 <20131112100140.GM5056@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20131112100140.GM5056@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2013 at 11:01:40AM +0100, Peter Zijlstra wrote:
> On Tue, Nov 12, 2013 at 05:41:47PM +0800, Fengguang Wu wrote:
> > On Mon, Nov 11, 2013 at 04:45:51PM +0100, Peter Zijlstra wrote:
> > > On Mon, Nov 11, 2013 at 09:29:27AM +0800, Fengguang Wu wrote:
> > > > Greetings,
> > > > 
> > > > I got the below dmesg and the first bad commit is
> > > > 
> > > > commit 1ca7d67cf5d5a2aef26a8d9afd789006fa098347
> > > > Author: John Stultz <john.stultz@linaro.org>
> > > > Date:   Mon Oct 7 15:51:59 2013 -0700
> > > > 
> > > >     seqcount: Add lockdep functionality to seqcount/seqlock structures
> > > >
> > > 
> > > > [    4.124336] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
> > > > [    4.128027] Call Trace:
> > > > [    4.128027]  [<7908e744>] ? console_unlock+0x353/0x380
> > > > [    4.128027]  [<79dc7cf2>] dump_stack+0x48/0x60
> > > > [    4.128027]  [<7908953e>] __lock_acquire.isra.26+0x7e3/0xceb
> > > > [    4.128027]  [<7908a1c5>] lock_acquire+0x71/0x9a
> > > > [    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
> > > > [    4.128027]  [<7940658b>] throtl_update_dispatch_stats+0x7c/0x153
> > > 
> > > The below seems to compile with i386-defconfig + CONFIG_CFQ_GROUP_IOSCHED=y
> > > 
> > > No idea if it runs properly or not; I seem to have misplaced my i386
> > > root filesystem.
> > > 
> > > ---
> > > Subject: block: Employ u64_stats_init()
> > > 
> > > Now that seqcounts are lockdep tracked thingies, we need to properly
> > > initialize them, otherwise bad stuff happens.
> > 
> > FYI the warning is still there:
> > 
> > /kernel/i386-randconfig-j7-11082318/d3516a7318f8e22f5462888fdf9edc8f0f128024
> > 
> > +-------------------------------------------------+-------+--------------+--------------+
> > |                                                 | v3.12 | 838cc7b488f8 | d3516a7318f8 |
> > +-------------------------------------------------+-------+--------------+--------------+
> > | boot_successes                                  | 129   | 0            | 0            |
> > | boot_failures                                   | 1     | 100          | 100          |
> > | BUG:kernel_early_hang_without_any_printk_output | 1     |              |              |
> > | INFO:trying_to_register_non-static_key          | 0     | 100          | 100          |
> > +-------------------------------------------------+-------+--------------+--------------+
> 
> Is that from the exact same spot as before
> (throtl_update_dispatch_stats) or did we hit another one?

It's exact the same spot. Attached is one dmesg from d3516a7318f8,
which is the commit for patch "block: Employ u64_stats_init()" based
on 838cc7b488f8 ("lockdep/proc: Fix lock-time avg computation").

Thanks,
Fengguang

--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-athens-20:20131112165720:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-00186-gd3516a7 (kbuild@jaketown) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #2 SMP Tue Nov 12 15:33:51 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[780fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
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
[    0.000000] BRK [0x01e81000, 0x01e81fff] PGTABLE
[    0.000000] BRK [0x01e82000, 0x01e83fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128404(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
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
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x01e84000, 0x01e84fff] PGTABLE
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
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 331 pages/cpu @85aa9000 s1340296 r0 d15480 =
u1355776
[    0.000000] pcpu-alloc: s1340296 r0 d15480 u1355776 alloc=3D331*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr daab7c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-j7-11082318/wfg:fix-blkg_sta=
t_init/.vmlinuz-d3516a7318f8e22f5462888fdf9edc8f0f128024-20131112153423-22-=
athens branch=3Dwfg/fix-blkg_stat_init BOOT_IMAGE=3D/kernel/i386-randconfig=
-j7-11082318/d3516a7318f8e22f5462888fdf9edc8f0f128024/vmlinuz-3.12.0-00186-=
gd3516a7
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 194064K/261744K available (14067K kernel code, 1182K=
 rwdata, 5916K rodata, 1944K init, 5976K bss, 67680K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xff3fe000   (1900 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x796ae000 - 0x79894000   (1944 kB)
[    0.000000]       .data : 0x78fbd05b - 0x796adb00   (7106 kB)
[    0.000000]       .text : 0x78200000 - 0x78fbd05b   (14068 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D8540c000 soft=3D8540e000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 524288 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.018 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5786.03 Bogo=
MIPS (lpj=3D2893018)
[    0.003456] pid_max: default: 4096 minimum: 301
[    0.004214] Security Framework initialized
[    0.004958] AppArmor: AppArmor disabled by boot time parameter
[    0.005000] Mount-cache hash table entries: 512
[    0.005000] Initializing cgroup subsys memory
[    0.005000] Initializing cgroup subsys devices
[    0.005000] Initializing cgroup subsys blkio
[    0.005000] Initializing cgroup subsys net_prio
[    0.005000] mce: CPU supports 10 MCE banks
[    0.005000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.005000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.005000] tlb_flushall_shift: 6
[    0.010418] Freeing SMP alternatives memory: 52K (79894000 - 798a1000)
[    0.019234] ACPI: Core revision 20130725
[    0.025113] ACPI: All ACPI Tables successfully acquired
[    0.026406] Getting VERSION: 50014
[    0.027020] Getting VERSION: 50014
[    0.027624] Getting ID: 0
[    0.028021] Getting ID: f000000
[    0.028571] Getting LVT0: 8700
[    0.029014] Getting LVT1: 8400
[    0.029563] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.031082] enabled ExtINT on CPU#0
[    0.033533] ENABLING IO-APIC IRQs
[    0.034015] init IO_APIC IRQs
[    0.034539]  apic 0 pin 0 not connected
[    0.035026] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.036051] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.037154] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.038041] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.039041] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.040039] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.041036] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.042035] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.043035] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.044038] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.045039] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.046039] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.047039] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.048038] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.049039] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.050032]  apic 0 pin 16 not connected
[    0.051006]  apic 0 pin 17 not connected
[    0.051673]  apic 0 pin 18 not connected
[    0.052006]  apic 0 pin 19 not connected
[    0.053006]  apic 0 pin 20 not connected
[    0.053649]  apic 0 pin 21 not connected
[    0.054006]  apic 0 pin 22 not connected
[    0.055006]  apic 0 pin 23 not connected
[    0.056180] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.057005] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.059006] Using local APIC timer interrupts.
[    0.059006] calibrating APIC timer ...
[    0.061000] ... lapic delta =3D 6374906
[    0.061000] ... PM-Timer delta =3D 365166
[    0.061000] APIC calibration not consistent with PM-Timer: 102ms instead=
 of 100ms
[    0.061000] APIC delta adjusted to PM-Timer: 6249002 (6374906)
[    0.061000] TSC delta adjusted to PM-Timer: 289294920 (295123588)
[    0.061000] ..... delta 6249002
[    0.061000] ..... mult: 268392592
[    0.061000] ..... calibration result: 999840
[    0.061000] ..... CPU clock speed is 2892.0949 MHz.
[    0.061000] ..... host bus clock speed is 999.0840 MHz.
[    0.061109] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.067629] CPU 1 irqstacks, hard=3D85526000 soft=3D85528000
[    0.068005] smpboot: Booting Node   0, Processors  #   1 OK
[    0.002000] Initializing CPU#1
[    0.003000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.003000] masked ExtINT on CPU#1
[    0.085171] Brought up 2 CPUs
[    0.086006] smpboot: Total of 2 processors activated (11572.07 BogoMIPS)
[    0.085081] KVM setup async PF for cpu 1
[    0.085081] kvm-stealtime: cpu 1, msr dbf67c0
[    0.091373] devtmpfs: initialized
[    0.094134] EVM: security.selinux
[    0.094717] EVM: security.SMACK64
[    0.095004] EVM: security.ima
[    0.095516] EVM: security.capability
[    0.097890] xor: measuring software checksum speed
[    0.108007]    pIII_sse  :  8044.000 MB/sec
[    0.118007]    prefetch64-sse:  8896.000 MB/sec
[    0.118792] xor: using function: prefetch64-sse (8896.000 MB/sec)
[    0.120250] regulator-dummy: no parameters
[    0.121344] NET: Registered protocol family 16
[    0.123767] cpuidle: using governor ladder
[    0.124006] cpuidle: using governor menu
[    0.126398] ACPI: bus type PCI registered
[    0.127056] dca service started, version 1.12.1
[    0.127890] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.160179] bio: create slab <bio-0> at 0
[    0.178011] raid6: mmxx1     2515 MB/s
[    0.195018] raid6: mmxx2     2828 MB/s
[    0.212014] raid6: sse1x1    2187 MB/s
[    0.229014] raid6: sse1x2    2792 MB/s
[    0.246015] raid6: sse2x1    4382 MB/s
[    0.263011] raid6: sse2x2    5523 MB/s
[    0.263673] raid6: using algorithm sse2x2 (5523 MB/s)
[    0.264005] raid6: using intx1 recovery algorithm
[    0.265545] ACPI: Added _OSI(Module Device)
[    0.266006] ACPI: Added _OSI(Processor Device)
[    0.267006] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.268005] ACPI: Added _OSI(Processor Aggregator Device)
[    0.272055] ACPI: EC: Look up EC in DSDT
[    0.282403] ACPI: Interpreter enabled
[    0.283020] ACPI: (supports S0 S5)
[    0.283585] ACPI: Using IOAPIC for interrupt routing
[    0.284068] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.304359] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.305014] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.307525] PCI host bridge to bus 0000:00
[    0.308008] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.309007] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.310007] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.311006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.312007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.313097] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.315510] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.317667] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.323008] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.326627] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.328350] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.329023] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.331438] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.334019] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.337019] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.349023] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.351517] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.354008] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.357007] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.366012] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.368584] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.371008] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.374008] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.384808] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.387007] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.390007] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.401008] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.403886] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.406008] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.417275] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.420008] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.422008] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.433444] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.436007] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.439007] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.449595] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.452008] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.455007] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.465771] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.467486] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.475045] pci_bus 0000:00: on NUMA node 0
[    0.477503] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.478617] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.480328] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.481638] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.483033] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.485000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.485017] ACPI: \_SB_.PCI0: notify handler is installed
[    0.486000] Found 1 acpi root devices
[    0.491184] SCSI subsystem initialized
[    0.491910] libata version 3.00 loaded.
[    0.492206] ACPI: bus type USB registered
[    0.493084] usbcore: registered new interface driver usbfs
[    0.494049] usbcore: registered new interface driver hub
[    0.496080] usbcore: registered new device driver usb
[    0.498018] pps_core: LinuxPPS API ver. 1 registered
[    0.498880] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.499039] PTP clock support registered
[    0.500243] wmi: Mapper loaded
[    0.501067] PCI: Using ACPI for IRQ routing
[    0.501789] PCI: pci_cache_line_size set to 64 bytes
[    0.503083] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.504011] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.505683] NET: Registered protocol family 23
[    0.506122] Bluetooth: Core ver 2.16
[    0.507047] NET: Registered protocol family 31
[    0.508005] Bluetooth: HCI device and connection manager initialized
[    0.509024] Bluetooth: HCI socket layer initialized
[    0.510016] Bluetooth: L2CAP socket layer initialized
[    0.511043] Bluetooth: SCO socket layer initialized
[    0.511852] NET: Registered protocol family 8
[    0.512005] NET: Registered protocol family 20
[    0.513073] NetLabel: Initializing
[    0.514004] NetLabel:  domain hash size =3D 128
[    0.514757] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.515133] NetLabel:  unlabeled traffic allowed by default
[    0.516006] nfc: nfc_init: NFC Core ver 0.1
[    0.517112] NET: Registered protocol family 39
[    0.520012] Switched to clocksource kvm-clock
[    0.521286] FS-Cache: Loaded
[    0.522050] CacheFiles: Loaded
[    0.522725] pnp: PnP ACPI init
[    0.523312] ACPI: bus type PNP registered
[    0.524134] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.525617] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.526852] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.528310] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.529533] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.531061] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.532294] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.533667] pnp 00:03: [dma 2]
[    0.534304] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.535542] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.537047] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.538272] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.539767] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.541581] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.543136] pnp: PnP ACPI: found 7 devices
[    0.543818] ACPI: bus type PNP unregistered
[    0.580791] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.581749] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.582708] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.583784] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.585207] NET: Registered protocol family 2
[    0.586731] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.588034] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.589280] TCP: Hash tables configured (established 2048 bind 2048)
[    0.590514] TCP: reno registered
[    0.591108] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    0.592127] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    0.593573] NET: Registered protocol family 1
[    0.596613] RPC: Registered named UNIX socket transport module.
[    0.597652] RPC: Registered udp transport module.
[    0.598476] RPC: Registered tcp transport module.
[    0.599322] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.600420] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.601579] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.602606] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.603718] pci 0000:00:02.0: Boot video device
[    0.604629] PCI: CLS 0 bytes, default 64
[    0.605786] Unpacking initramfs...
[    2.110209] Freeing initrd memory: 25284K (8673f000 - 87ff0000)
[    2.112355] kvm: no hardware support
[    2.113187] Machine check injector initialized
[    2.114891] cryptomgr_test (24) used greatest stack depth: 7364 bytes le=
ft
[    2.116420] PCLMULQDQ-NI instructions are not detected.
[    2.117209] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.120506] Initializing RT-Tester: OK
[    2.121679] audit: initializing netlink socket (disabled)
[    2.122584] type=3D2000 audit(1384246635.442:1): initialized
[    2.124164] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.125821] VFS: Disk quotas dquot_6.5.2
[    2.126607] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.128650] DLM installed
[    2.131203] FS-Cache: Netfs 'nfs' registered for caching
[    2.133372] Key type cifs.spnego registered
[    2.134091] Key type cifs.idmap registered
[    2.134915] JFS: nTxBlock =3D 1714, nTxLock =3D 13712
[    2.137105] 9p: Installing v9fs 9p2000 file system support
[    2.137984] FS-Cache: Netfs '9p' registered for caching
[    2.138965] NILFS version 2 loaded
[    2.139497] OCFS2 1.5.0
[    2.140315] ocfs2: Registered cluster interface o2cb
[    2.141073] OCFS2 DLMFS 1.5.0
[    2.141749] OCFS2 User DLM kernel interface loaded
[    2.142495] OCFS2 Node Manager 1.5.0
[    2.143405] OCFS2 DLM 1.5.0
[    2.144397] bio: create slab <bio-1> at 1
[    2.145831] Btrfs loaded, debug=3Don, assert=3Don
[    2.146515] btrfs: selftest: Running btrfs free space cache tests
[    2.147429] btrfs: selftest: Running extent only tests
[    2.148275] btrfs: selftest: Running bitmap only tests
[    2.149175] btrfs: selftest: Running bitmap and extent tests
[    2.150110] btrfs: selftest: Free space cache tests finished
[    2.151935] GFS2 installed
[    2.160641] NET: Registered protocol family 38
[    2.161438] Key type asymmetric registered
[    2.162243] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    2.163507] io scheduler noop registered (default)
[    2.164289] io scheduler deadline registered
[    2.165126] io scheduler cfq registered
[    2.165700] list_sort_test: start testing list_sort()
[    2.167163] test_string_helpers: Running tests...
[    2.174242] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    2.174982] crc32: self tests passed, processed 225944 bytes in 3048885 =
nsec
[    2.179299] crc32c: CRC_LE_BITS =3D 1
[    2.179828] crc32c: self tests passed, processed 225944 bytes in 1682319=
 nsec
[    2.181547] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.182434] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    2.183520] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.184989] rivafb_setup START
[    2.185672] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.187050] no IO addresses supplied
[    2.188459] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    2.190554] usbcore: registered new interface driver smscufx
[    2.191908] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.193055] ACPI: Power Button [PWRF]
[    2.194229] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.195676] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.221285] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.224406] Cyclades driver 2.6
[    2.225088] MOXA Intellio family driver version 6.0k
[    2.225946] Initializing Nozomi driver 2.1d
[    2.226706] RocketPort device driver module, version 2.09, 12-June-2003
[    2.227705] No rocketport ports found; unloading driver
[    2.228554] SyncLink GT
[    2.229041] SyncLink GT, tty major#247
[    2.229695] SyncLink GT no devices found
[    2.230269] SyncLink MultiPort driver $Revision: 4.38 $
[    2.257285] SyncLink MultiPort driver $Revision: 4.38 $, tty major#246
[    2.258411] SyncLink serial driver $Revision: 4.38 $
[    2.281202] SyncLink serial driver $Revision: 4.38 $, tty major#245
[    2.282911] lp: driver loaded but no devices found
[    2.283651] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    2.284707] ac.o: No PCI boards found.
[    2.285284] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    2.286304] toshiba: not a supported Toshiba laptop
[    2.287048] ppdev: user-space parallel port driver
[    2.287853] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    2.288969] platform pc8736x_gpio.0: no device found
[    2.289851] nsc_gpio initializing
[    2.290413] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    2.291679] Hangcheck: Using getrawmonotonic().
[    2.292572] [drm] Initialized drm 1.1.0 20060810
[    2.293630] [drm] radeon kernel modesetting enabled.
[    2.295134] parport_pc 00:04: reported by Plug and Play ACPI
[    2.296130] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.298231] lp0: using parport0 (interrupt-driven).
[    2.299824] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.300967] dummy-irq: no IRQ given.  Use irq=3DN
[    2.301761] lkdtm: No crash points registered, enable through debugfs
[    2.302843] Phantom Linux Driver, version n0.9.8, init OK
[    2.303966] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.305300] c2port c2port0: C2 port uc added
[    2.305960] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    2.307445] Guest personality initialized and is inactive
[    2.308527] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D59)
[    2.309556] Initialized host personality
[    2.310694] usbcore: registered new interface driver viperboard
[    2.313177] Loading iSCSI transport class v2.0-870.
[    2.315497] iscsi: registered transport (tcp)
[    2.316587] Adaptec aacraid driver 1.2-0[30200]-ms
[    2.318288] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    2.319589] scsi: <fdomain> Detection failed (no card)
[    2.322185] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    2.323121] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    2.325804] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    2.326740] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    2.330506] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    2.332899] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    2.737972] DC390: clustering now enabled by default. If you get problem=
s load
[    2.739204]        with "disable_clustering=3D1" and report to maintaine=
rs
[    2.740340] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    2.741476] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    2.742540] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    2.743661] imm: Version 2.05 (for Linux 2.4.0)
[    2.745050] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    2.746342] RocketRAID 3xxx/4xxx Controller driver v1.8
[    2.747230] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    2.748236] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    2.749461] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    2.750518] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    2.751499] iscsi: registered transport (cxgb3i)
[    2.752279] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    2.753149] iscsi: registered transport (cxgb4i)
[    2.753937] iscsi: registered transport (be2iscsi)
[    2.754718] In beiscsi_module_init, tt=3D7960ed3c
[    2.755614] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    2.757341] SCSI Media Changer driver v0.25=20
[    2.761959] scsi_debug: host protection
[    2.762606] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    2.764662] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    2.766716] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.767650] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    2.769191] sd 0:0:0:0: [sda] Write Protect is off
[    2.769888] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    2.771498] SSFDC read-only Flash Translation layer
[    2.779112] device id =3D 2440
[    2.779608] device id =3D 2480
[    2.780101] device id =3D 24c0
[    2.780560] device id =3D 24d0
[    2.781050] device id =3D 25a1
[    2.781507] device id =3D 2670
[    2.782121] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.783202] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    2.783984] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    2.785659] pmc551: not detected
[    2.789491] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.792237] INFO: trying to register non-static key.
[    2.793025] the code is fine but needs lockdep annotation.
[    2.793025] turning off the locking correctness validator.
[    2.793025] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-g=
d3516a7 #2
[    2.793025] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.793025] Workqueue: events_unbound async_run_entry_fn
[    2.793025]  7828d55b 00000000 7f3a7968 78fa76a8 799d624c 7f3a79a0 78288=
323 7938b281
[    2.793025]  7938b2db 7938b2b1 87817708 00000000 00000011 40352011 0000a=
785 87817220
[    2.793025]  87817220 85d3e540 00000000 7f3a79cc 78288faa 00000000 00000=
001 00000000
[    2.793025] Call Trace:
[    2.793025]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.793025]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.793025]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.793025]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.793025]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.793025]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.793025]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.793025]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.793025]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.793025]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.793025]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.793025]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.793025]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.793025]  [<785ec292>] submit_bio+0x65/0xd2
[    2.793025]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.793025]  [<78313fb4>] submit_bh+0xa/0xc
[    2.793025]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.793025]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.793025]  [<782c78b6>] ? __pagevec_lru_add+0xf/0x11
[    2.793025]  [<782c78fd>] ? __lru_cache_add+0x45/0x5b
[    2.793025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.793025]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.793025]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.793025]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.793025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.793025]  [<782bf256>] read_cache_page+0xb/0x12
[    2.793025]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.793025]  [<785f6c00>] read_lba+0xae/0xf9
[    2.793025]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.793025]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.828652] No valid DiskOnChip devices found
[    2.828684] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.828686] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.828687] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.828688] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.828689] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.828691] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.828696] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba N=
AND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    2.828853] flash size: 128 MiB
[    2.828854] page size: 512 bytes
[    2.828855] OOB area size: 16 bytes
[    2.828856] sector size: 16 KiB
[    2.828896] pages number: 262144
[    2.828897] pages per sector: 32
[    2.828898] bus width: 8
[    2.828899] bits in sector size: 14
[    2.828899] bits in page size: 9
[    2.828900] bits in OOB size: 4
[    2.828901] flash size with OOB: 135168 KiB
[    2.828902] page address bytes: 4
[    2.828902] sector address bytes: 3
[    2.828903] options: 0x42
[    2.793025]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.793025]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.793025]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.793025]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.793025]  [<7860b627>] ? snprintf+0x15/0x17
[    2.793025]  [<785f62e9>] check_partition+0xe4/0x178
[    2.793025]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.793025]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.793025]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.793025]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.793025]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.793025]  [<78318658>] ? bdget+0xf8/0x105
[    2.793025]  [<788acee0>] ? put_device+0xf/0x11
[    2.793025]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.793025]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.793025]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.793025]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.793025]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.793025]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.793025]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.793025]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.793025]  [<78270649>] kthread+0x8a/0x8f
[    2.793025]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.793025]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.793025]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.870591] Scanning device for bad blocks
[    2.873054]  sda: unknown partition table
[    2.877127] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.893720] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    2.894754] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    2.896925] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    2.898033] spi-lm70llp: spi_lm70llp probe fail, status -12
[    2.900171] libphy: Fixed MDIO Bus: probed
[    2.901613] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    2.902781] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.18 (Sept 0=
1, 2013)
[    2.905293] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50
[    2.906239] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    2.907415] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    2.908560] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    2.909673] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.912307] e1000 0000:00:03.0: setting latency timer to 64
[    3.116103] tsc: Refined TSC clocksource calibration: 2892.951 MHz
[    3.271235] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    3.272378] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    3.273475] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[    3.274701] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    3.275651] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[    3.276821] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    3.277789] i40e: Intel(R) Ethernet Connection XL710 Network Driver - ve=
rsion 0.3.9-k
[    3.279002] i40e: Copyright (c) 2013 Intel Corporation.
[    3.279862] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    3.280976] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    3.281869] sky2: driver version 1.30
[    3.282558] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    3.283661] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    3.284901] Solarflare NET driver v4.0
[    3.287163] usbcore: registered new interface driver stir4200
[    3.288949] usbcore: registered new interface driver mcs7780
[    3.290042] usbcore: registered new interface driver ksdazzle-sir
[    3.290979] usbcore: registered new interface driver ks959-sir
[    3.291900] PPP generic driver version 2.4.2
[    3.292681] PPP Deflate Compression module registered
[    3.293490] PPP MPPE Compression module registered
[    3.294256] NET: Registered protocol family 24
[    3.294929] PPTP driver version 0.8.5
[    3.295624] usbcore: registered new interface driver i2400m_usb
[    3.296555] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    3.297645] usbcore: registered new interface driver catc
[    3.298512] usbcore: registered new interface driver r8152
[    3.299442] usbcore: registered new interface driver ipheth
[    3.300385] Madge ATM Ambassador driver version 1.2.4
[    3.301153] amb: debug bitmap is 0
[    3.301721] Madge ATM Horizon [Ultra] driver version 1.2.1
[    3.302614] hrz: debug bitmap is 0
[    3.303236] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
[    3.304340] idt77252_init: at 796e7dce
[    3.304969] Solos PCI Driver Version 1.04
[    3.305648] adummy: version 1.0
[    3.307257] parport0: cannot grant exclusive access for device ks0108
[    3.308275] ks0108: ERROR: parport didn't register new device
[    3.310194] cfag12864b: ERROR: ks0108 is not initialized
[    3.310991] cfag12864bfb: ERROR: cfag12864b is not initialized
[    3.312320] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.313322] ehci-pci: EHCI PCI platform driver
[    3.314150] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.315102] uhci_hcd: USB Universal Host Controller Interface driver
[    3.316220] driver u132_hcd
[    3.317936] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.318942] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    3.320308] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    3.321215]=20
[    3.322669] usbcore: registered new interface driver cdc_acm
[    3.323566] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    3.324835] usbcore: registered new interface driver usblp
[    3.325745] usbcore: registered new interface driver cdc_wdm
[    3.326669] usbcore: registered new interface driver usbtmc
[    3.327554] usbcore: registered new interface driver mdc800
[    3.328417] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    3.330722] usbcore: registered new interface driver usbserial
[    3.331525] usbcore: registered new interface driver usbserial_generic
[    3.332436] usbserial: USB Serial support registered for generic
[    3.333414] usbcore: registered new interface driver aircable
[    3.334356] usbserial: USB Serial support registered for aircable
[    3.335334] usbcore: registered new interface driver ark3116
[    3.336235] usbserial: USB Serial support registered for ark3116
[    3.337181] usbcore: registered new interface driver belkin_sa
[    3.338127] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[    3.339566] usbcore: registered new interface driver ch341
[    3.340487] usbserial: USB Serial support registered for ch341-uart
[    3.341497] usbcore: registered new interface driver cp210x
[    3.342419] usbserial: USB Serial support registered for cp210x
[    3.343367] usbcore: registered new interface driver cyberjack
[    3.344311] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    3.345646] usbcore: registered new interface driver cypress_m8
[    3.346616] usbserial: USB Serial support registered for DeLorme Earthma=
te USB
[    3.347774] usbserial: USB Serial support registered for HID->COM RS232 =
Adapter
[    3.349966] usbserial: USB Serial support registered for Nokia CA-42 V2 =
Adapter
[    3.351130] usbcore: registered new interface driver usb_debug
[    3.352074] usbserial: USB Serial support registered for debug
[    3.352993] usbcore: registered new interface driver f81232
[    3.353909] usbserial: USB Serial support registered for f81232
[    3.354866] usbcore: registered new interface driver ftdi_sio
[    3.355787] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    3.356967] usbcore: registered new interface driver garmin_gps
[    3.357902] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[    3.359051] usbcore: registered new interface driver kl5kusb105
[    3.359997] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[    3.361188] usbcore: registered new interface driver metro_usb
[    3.362131] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[    3.363323] usbcore: registered new interface driver mos7720
[    3.364223] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    3.365398] usbcore: registered new interface driver mos7840
[    3.366317] usbserial: USB Serial support registered for Moschip 7840/78=
20 USB Serial Driver
[    3.367611] usbcore: registered new interface driver navman
[    3.368518] usbserial: USB Serial support registered for navman
[    3.369512] usbcore: registered new interface driver opticon
[    3.370436] usbserial: USB Serial support registered for opticon
[    3.371402] usbcore: registered new interface driver oti6858
[    3.372326] usbserial: USB Serial support registered for oti6858
[    3.373284] usbcore: registered new interface driver qcaux
[    3.374181] usbserial: USB Serial support registered for qcaux
[    3.375124] usbcore: registered new interface driver quatech2
[    3.376079] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[    3.377418] usbcore: registered new interface driver usb_serial_simple
[    3.378457] usbserial: USB Serial support registered for zio
[    3.379410] usbserial: USB Serial support registered for funsoft
[    3.380365] usbserial: USB Serial support registered for flashloader
[    3.381381] usbserial: USB Serial support registered for vivopay
[    3.382376] usbserial: USB Serial support registered for moto_modem
[    3.383317] usbserial: USB Serial support registered for hp4x
[    3.384245] usbserial: USB Serial support registered for suunto
[    3.385218] usbserial: USB Serial support registered for siemens_mpi
[    3.386217] usbcore: registered new interface driver spcp8x5
[    3.387115] usbserial: USB Serial support registered for SPCP8x5
[    3.388123] usbcore: registered new interface driver ssu100
[    3.388948] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[    3.390282] usbcore: registered new interface driver symbolserial
[    3.391259] usbserial: USB Serial support registered for symbol
[    3.392214] usbcore: registered new interface driver ti_usb_3410_5052
[    3.393252] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[    3.394481] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[    3.395714] usbcore: registered new interface driver visor
[    3.396612] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[    3.397804] usbserial: USB Serial support registered for Sony Clie 5.0
[    3.398883] usbserial: USB Serial support registered for Sony Clie 3.5
[    3.399943] usbcore: registered new interface driver wishbone_serial
[    3.400972] usbserial: USB Serial support registered for wishbone_serial
[    3.402069] usbcore: registered new interface driver whiteheat
[    3.402982] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[    3.404426] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[    3.405623] usbcore: registered new interface driver xsens_mt
[    3.406554] usbserial: USB Serial support registered for xsens_mt
[    3.407526] usbcore: registered new interface driver zte_ev
[    3.408438] usbserial: USB Serial support registered for zte_ev
[    3.409429] usbcore: registered new interface driver adutux
[    3.410336] usbcore: registered new interface driver cypress_cy7c63
[    3.411352] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    3.412417] driver ftdi-elan
[    3.413265] usbcore: registered new interface driver ftdi-elan
[    3.414211] usbcore: registered new interface driver idmouse
[    3.415128] usbcore: registered new interface driver iowarrior
[    3.416068] usbcore: registered new interface driver isight_firmware
[    3.417075] usbcore: registered new interface driver usblcd
[    3.417939] usbcore: registered new interface driver ldusb
[    3.418871] usbcore: registered new interface driver usbled
[    3.419769] usbcore: registered new interface driver legousbtower
[    3.420759] usbcore: registered new interface driver rio500
[    3.421674] usbcore: registered new interface driver uss720
[    3.422552] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    3.424023] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    3.425160] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    3.426283] uss720: If you just want to connect to a printer, use usblp =
instead
[    3.427511] usbcore: registered new interface driver sisusb
[    3.430000] couldn't find an available UDC
[    3.430767] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.432980] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.433869] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.434761] parport0: cannot grant exclusive access for device parkbd
[    3.523632] mousedev: PS/2 mouse device common for all mice
[    3.524608] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    3.526210] usbcore: registered new interface driver bcm5974
[    3.527234] usbcore: registered new interface driver synaptics_usb
[    3.528646] usbcore: registered new interface driver xpad
[    3.529653] parport0: cannot grant exclusive access for device walkera07=
01
[    3.530794] walkera0701: failed to register parport device
[    3.531775] usbcore: registered new interface driver aiptek
[    3.532771] usbcore: registered new interface driver gtco
[    3.533755] usbcore: registered new interface driver hanwang
[    3.534741] usbcore: registered new interface driver wacom
[    3.535865] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    3.537269] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    3.538370] evbug: Connected device: input1 (PC Speaker at isa0061/input=
0)
[    3.540624] usbcore: registered new interface driver powermate
[    3.542126] i2c /dev entries driver
[    3.542294] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input2
[    3.542303] evbug: Connected device: input2 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    3.545835] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    3.547530] i2c-parport: adapter type unspecified
[    3.548420] pps pps0: new PPS source ktimer
[    3.549052] pps pps0: ktimer PPS source registered
[    3.549682] pps_ldisc: PPS line discipline registered
[    3.550444] pps_parport: parallel port PPS client
[    3.551183] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    3.552219] pps_parport: couldn't register with parport0
[    3.553173] Driver for 1-wire Dallas network protocol.
[    3.554119] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.555112] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    3.733081] applesmc: supported laptop not found!
[    3.733803] applesmc: driver init failed (ret=3D-19)!
[    4.117231] kwatchdog (114) used greatest stack depth: 7316 bytes left
[    5.590362] pc87360: PC8736x not detected, module not inserted
[    5.713149] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    5.714345] usbcore: registered new interface driver bcm203x
[    5.715263] usbcore: registered new interface driver bfusb
[    5.716236] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    5.717427] CAPI 2.0 started up with major 68 (no middleware)
[    5.718389] b1pci: revision 1.1.2.2
[    5.718972] b1: revision 1.1.2.2
[    5.719468] b1dma: revision 1.1.2.3
[    5.720067] t1pci: revision 1.1.2.2
[    5.720596] gigaset: Driver for Gigaset 307x
[    5.721259] gigaset: Kernel CAPI interface
[    5.721949] lguest: switcher text too large (4384)
[    5.722760] sdhci: Secure Digital Host Controller Interface driver
[    5.723706] sdhci: Copyright(c) Pierre Ossman
[    5.724570] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    5.727106] usbcore: registered new interface driver vub300
[    5.727984] usbcore: registered new interface driver ushc
[    5.728830] sdhci-pltfm: SDHCI platform and OF driver helper
[    5.730535] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    5.731799] hidraw: raw HID events driver (C) Jiri Kosina
[    5.733483] usbcore: registered new interface driver usbkbd
[    5.836504] panel: driver version 0.9.5 registered on parport0 (io=3D0x3=
78).
[    5.837593] usbcore: registered new interface driver serqt_usb2
[    5.838552] usbserial: USB Serial support registered for Quatech USB to =
Serial Driver
[    5.839775] vme_user: VME User Space Access Driver
[    5.840537] vme_user: No cards, skipping registration
[    5.841335] vme_pio2: No cards, skipping registration
[    5.843510] zram: Created 1 device(s) ...
[    5.844237] Loading crystalhd 0.9.27
[    5.844919] usbcore: registered new interface driver ft1000usb
[    5.846093] ashmem: initialized
[    5.846687] logger: created 256K log 'log_main'
[    5.847563] logger: created 256K log 'log_events'
[    5.848411] logger: created 256K log 'log_radio'
[    5.850271] logger: created 256K log 'log_system'
[    5.851323] ozwpan ozwpan: Ozmo Devices WPAN
[    5.852129] ozwpan ozwpan: new USB bus registered, assigned bus number 1
[    5.853525] hub 1-0:1.0: USB hub found
[    5.854196] hub 1-0:1.0: 8 ports detected
[    5.855465] usbcore: registered new interface driver gdm_wimax
[    5.856838] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[    5.857908] dgap: For the tools package or updated drivers please visit =
http://www.digi.com
[    5.860846] oprofile: using NMI interrupt.
[    5.861630] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    5.863216] NET: Registered protocol family 26
[    5.864232] u32 classifier
[    5.864723] gre: GRE over IPv4 demultiplexor driver
[    5.865498] ip_gre: GRE over IPv4 tunneling driver
[    5.866779] IPv4 over IPSec tunneling driver
[    5.867721] TCP: bic registered
[    5.868222] TCP: cubic registered
[    5.868736] TCP: hybla registered
[    5.869273] TCP: vegas registered
[    5.869726] TCP: veno registered
[    5.870195] TCP: scalable registered
[    5.870724] TCP: lp registered
[    5.871220] TCP: illinois registered
[    5.872041] NET: Registered protocol family 10
[    5.873777] mip6: Mobile IPv6
[    5.874282] sit: IPv6 over IPv4 tunneling driver
[    5.875705] ip6_gre: GRE over IPv6 tunneling driver
[    5.876890] NET: Registered protocol family 15
[    5.877717] NET: Registered protocol family 4
[    5.878460] NET: Registered protocol family 5
[    5.880236] NET: Registered protocol family 9
[    5.880909] X.25 for Linux Version 0.2
[    5.881544] can: controller area network core (rev 20120528 abi 9)
[    5.882602] NET: Registered protocol family 29
[    5.883309] can: broadcast manager protocol (rev 20120528 t)
[    5.884200] can: netlink gateway (rev 20130117) max_hops=3D1
[    5.885879] Bluetooth: RFCOMM TTY layer initialized
[    5.886683] Bluetooth: RFCOMM socket layer initialized
[    5.887466] Bluetooth: RFCOMM ver 1.11
[    5.888196] NET: Registered protocol family 33
[    5.888889] Key type rxrpc registered
[    5.889469] Key type rxrpc_s registered
[    5.890412] cryptomgr_probe (122) used greatest stack depth: 7112 bytes =
left
[    5.891575] RxRPC: Registered security type 2 'rxkad'
[    5.892392] lec:lane_module_init: lec.c: initialized
[    5.893186] mpoa:atm_mpoa_init: mpc.c: initialized
[    5.893957] l2tp_core: L2TP core driver, V2.0
[    5.894662] l2tp_ppp: PPPoL2TP kernel driver, V2.0
[    5.895419] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    5.896854] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    5.897906] NET: Registered protocol family 12
[    5.898628] 8021q: 802.1Q VLAN Support v1.8
[    5.899861] DCCP: Activated CCID 2 (TCP-like)
[    5.900622] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    5.901985] sctp: Hash tables configured (established 1365 bind 1489)
[    5.903874] NET: Registered protocol family 21
[    5.904604] Registered RDS/tcp transport
[    5.905275] tipc: Activated (version 2.0.0)
[    5.906148] NET: Registered protocol family 30
[    5.907090] tipc: Started in single node mode
[    5.907750] 9pnet: Installing 9P2000 support
[    5.908491] NET: Registered protocol family 37
[    5.909293] Key type dns_resolver registered
[    5.909978] Key type ceph registered
[    5.910706] libceph: loaded (mon/osd proto 15/24)
[    5.912948] batman_adv: B.A.T.M.A.N. advanced 2013.4.0 (compatibility ve=
rsion 14) loaded
[    5.914368] NET: Registered protocol family 40
[    5.915108] mpls_gso: MPLS GSO support
[    5.917260]=20
[    5.917260] printing PIC contents
[    5.918044] ... PIC  IMR: ffff
[    5.918524] ... PIC  IRR: 1013
[    5.919068] ... PIC  ISR: 0000
[    5.919549] ... PIC ELCR: 0c00
[    5.920049] printing local APIC contents on CPU#0/0:
[    5.920821] ... APIC ID:      00000000 (0)
[    5.921026] ... APIC VERSION: 00050014
[    5.921026] ... APIC TASKPRI: 00000000 (00)
[    5.921026] ... APIC PROCPRI: 00000000
[    5.921026] ... APIC LDR: 01000000
[    5.921026] ... APIC DFR: ffffffff
[    5.921026] ... APIC SPIV: 000001ff
[    5.921026] ... APIC ISR field:
[    5.921026] 000000000000000000000000000000000000000000000000000000000000=
0000
[    5.921026] ... APIC TMR field:
[    5.921026] 000000000200000000000000000000000000000000000000000000000000=
0000
[    5.921026] ... APIC IRR field:
[    5.921026] 000000000000000000000000000000000000000000000000000000000000=
8000
[    5.921026] ... APIC ESR: 00000000
[    5.921026] ... APIC ICR: 000008fd
[    5.921026] ... APIC ICR2: 02000000
[    5.921026] ... APIC LVTT: 000000ef
[    5.921026] ... APIC LVTPC: 00010000
[    5.921026] ... APIC LVT0: 00010700
[    5.921026] ... APIC LVT1: 00000400
[    5.921026] ... APIC LVTERR: 000000fe
[    5.921026] ... APIC TMICT: 0000ecdd
[    5.921026] ... APIC TMCCT: 00000000
[    5.921026] ... APIC TDCR: 00000003
[    5.921026]=20
[    5.936473] number of MP IRQ sources: 15.
[    5.937101] number of IO-APIC #0 registers: 24.
[    5.937770] testing the IO APIC.......................
[    5.938595] IO APIC #0......
[    5.940108] .... register #00: 00000000
[    5.940704] .......    : physical APIC id: 00
[    5.941394] .......    : Delivery Type: 0
[    5.941956] .......    : LTS          : 0
[    5.942553] .... register #01: 00170011
[    5.943164] .......     : max redirection entries: 17
[    5.943914] .......     : PRQ implemented: 0
[    5.944582] .......     : IO APIC version: 11
[    5.945275] .... register #02: 00000000
[    5.945864] .......     : arbitration: 00
[    5.946494] .... IRQ redirection table:
[    5.947113] 1    0    0   0   0    0    0    00
[    5.947815] 0    0    0   0   0    1    1    31
[    5.948543] 0    0    0   0   0    1    1    30
[    5.950299] 0    0    0   0   0    1    1    33
[    5.951032] 1    0    0   0   0    1    1    34
[    5.951734] 1    1    0   0   0    1    1    35
[    5.952471] 0    0    0   0   0    1    1    36
[    5.953190] 0    0    0   0   0    1    1    37
[    5.953894] 0    0    0   0   0    1    1    38
[    5.954613] 0    1    0   0   0    1    1    39
[    5.955356] 1    1    0   0   0    1    1    3A
[    5.956124] 1    1    0   0   0    1    1    3B
[    5.956837] 0    0    0   0   0    1    1    3C
[    5.957556] 0    0    0   0   0    1    1    3D
[    5.958295] 0    0    0   0   0    1    1    3E
[    5.960058] 0    0    0   0   0    1    1    3F
[    5.960756] 1    0    0   0   0    0    0    00
[    5.961494] 1    0    0   0   0    0    0    00
[    5.962232] 1    0    0   0   0    0    0    00
[    5.962939] 1    0    0   0   0    0    0    00
[    5.963663] 1    0    0   0   0    0    0    00
[    5.964390] 1    0    0   0   0    0    0    00
[    5.965119] 1    0    0   0   0    0    0    00
[    5.965841] 1    0    0   0   0    0    0    00
[    5.966551] IRQ to pin mappings:
[    5.967075] IRQ0 -> 0:2
[    5.967483] IRQ1 -> 0:1
[    5.967925] IRQ3 -> 0:3
[    5.968381] IRQ4 -> 0:4
[    5.968828] IRQ5 -> 0:5
[    5.969269] IRQ6 -> 0:6
[    5.969685] IRQ7 -> 0:7
[    5.970145] IRQ8 -> 0:8
[    5.970577] IRQ9 -> 0:9
[    5.970938] IRQ10 -> 0:10
[    5.971377] IRQ11 -> 0:11
[    5.971832] IRQ12 -> 0:12
[    5.972320] IRQ13 -> 0:13
[    5.972773] IRQ14 -> 0:14
[    5.973252] IRQ15 -> 0:15
[    5.973699] .................................... done.
[    5.974501] Using IPI No-Shortcut mode
[    5.976947] registered taskstats version 1
[    5.977619] kAFS: Red Hat AFS client v0.1 registering.
[    5.978499] FS-Cache: Netfs 'afs' registered for caching
[    5.980247] cryptomgr_probe (129) used greatest stack depth: 7056 bytes =
left
[    5.980263] Key type encrypted registered
[    5.980408] IMA: No TPM chip found, activating TPM-bypass!
[    5.983346] Unregister pv shared memory for cpu 0
[    5.990828] CPU 0 is now offline
[    5.992824] Freeing unused kernel memory: 1944K (796ae000 - 79894000)
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_=
fd >=3D 0' failed.
[    6.037445] mountall (142) used greatest stack depth: 6928 bytes left
General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[    6.064991] Unregister pv shared memory for cpu 1
[    6.065895] no ifx modem active;
[    6.090600] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    6.103543] reboot: Restarting system
[    6.104194] reboot: machine restart
Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-j=
7-11082318/d3516a7318f8e22f5462888fdf9edc8f0f128024/vmlinuz-3.12.0-00186-gd=
3516a7 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log=
_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk=
 sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200=
 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-=
queue/kvm/i386-randconfig-j7-11082318/wfg:fix-blkg_stat_init/.vmlinuz-d3516=
a7318f8e22f5462888fdf9edc8f0f128024-20131112153423-22-athens branch=3Dwfg/f=
ix-blkg_stat_init BOOT_IMAGE=3D/kernel/i386-randconfig-j7-11082318/d3516a73=
18f8e22f5462888fdf9edc8f0f128024/vmlinuz-3.12.0-00186-gd3516a7'  -initrd /k=
ernel-tests/initrd/quantal-core-i386.cgz -m 256M -smp 2 -net nic,vlan=3D1,m=
odel=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300=
esb -drive file=3D/fs/LABEL=3DKVM/disk0-quantal-athens-20,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-athens-20,media=3Ddis=
k,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-athens-20,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-quantal-athens-20,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-quantal-athens-=
20,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-quantal-ath=
ens-20,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-athens-=
20 -serial file:/dev/shm/kboot/serial-quantal-athens-20 -daemonize -display=
 none -monitor null=20

--AqsLC8rIMeq19msA--
