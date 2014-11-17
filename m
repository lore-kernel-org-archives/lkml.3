Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaKQGIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:08:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:52207 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaKQGIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:08:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="417452101"
Date: Mon, 17 Nov 2014 14:08:36 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [LSM] Kernel panic - not syncing: No working init found.
Message-ID: <20141117060836.GB3938@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on(TBH, I don't know the bisect is
correct or not; sorry for the noise if not)

git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git lsm/stacking
commit 58c4f9e3be81a85839ea229b1dd36bf55232d440 ("LSM: Refactor existing LSM stacking")


+------------------------------------------------+------------+------------+
|                                                | c9979f3c6e | 58c4f9e3be |
+------------------------------------------------+------------+------------+
| boot_successes                                 | 15         | 0          |
| early-boot-hang                                | 1          |            |
| boot_failures                                  | 0          | 15         |
| Kernel_panic-not_syncing:No_working_init_found | 0          | 15         |
| backtrace:panic                                | 0          | 15         |
+------------------------------------------------+------------+------------+


[    3.437279] Starting init: /sbin/init exists but couldn't execute it (error -12)
[    3.438655] Starting init: /etc/init exists but couldn't execute it (error -13)
[    3.440136] Starting init: /bin/sh exists but couldn't execute it (error -12)
[    3.441487] Kernel panic - not syncing: No working init found.  Try passing init= option to kernel. See Linux Documentation/init.txt for guidance.
[    3.443352] CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc4-g49aba53 #1949
[    3.443352]  00000000 f783d540 80017f88 8138c3bd 80017fa0 8138b30b 815e1f40 f783d540
[    3.443352]  815e1f40 00000000 80017fac 81389523 8152ab4d 80016000 813918e0 81389474
[    3.443352]  00000000 00000000 00000000 00000000 00000000 00000000 0000007b 0000007b
[    3.443352] Call Trace:
[    3.443352]  [<8138c3bd>] dump_stack+0x16/0x18
[    3.443352]  [<8138b30b>] panic+0x86/0x19e
[    3.443352]  [<81389523>] kernel_init+0xaf/0xb3
[    3.443352]  [<813918e0>] ret_from_kernel_thread+0x20/0x30
[    3.443352]  [<81389474>] ? rest_init+0xa2/0xa2
[    3.443352] Kernel Offset: 0x0 from 0x81000000 (relocation range: 0x80000000-0x947fdfff)

Elapsed time: 10



	--yliu

--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Linux version 3.18.0-rc4-g49aba53 (kbuild@lkp-hsx01) (gcc ve=
rsion 4.9.1 (Debian 4.9.1-19) ) #1949 Sat Nov 15 06:21:52 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13200000-0x133fffff]
[    0.000000]  [mem 0x13200000-0x133fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x131fffff]
[    0.000000]  [mem 0x10000000-0x131fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13400000-0x13ffdfff]
[    0.000000]  [mem 0x13400000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x01f22000, 0x01f22fff] PGTABLE
[    0.000000] BRK [0x01f23000, 0x01f23fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x135e9000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] cma: dma_contiguous_reserve(limit 13ffe000)
[    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
[    0.000000] cma: cma_declare_contiguous(size 0x0000000001000000, base 0x=
0000000000000000, limit 0x0000000013ffe000 alignment 0x0000000000000000)
[    0.000000] cma: Reserved 16 MiB at 0x0000000012400000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] BRK [0x01f24000, 0x01f24fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 8161de20, node_mem_map 92=
180020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 15dafc0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-i386-6/rand_boot-1-yocto-minimal-i386.cgz-i386-randconfig-ha3-1109=
-49aba53037eb271723dda0be3d2a826e579aa9a4-1.yaml ARCH=3Di386 BOOT_IMAGE=3D/=
kernel/i386-randconfig-ha3-1109/49aba53037eb271723dda0be3d2a826e579aa9a4/vm=
linuz-3.18.0-rc4-g49aba53 kconfig=3Di386-randconfig-ha3-1109 commit=3D49aba=
53037eb271723dda0be3d2a826e579aa9a4 branch=3Dlinux-devel/devel-lkp-hsx01-i3=
86-201411150616 root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm=
-kbuild-yocto-i386/boot/1/yocto-minimal-i386.cgz/i386-randconfig-ha3-1109/4=
9aba53037eb271723dda0be3d2a826e579aa9a4/0 ip=3D::::vm-kbuild-yocto-i386-6::=
dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcu=
pdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watch=
dog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS=
0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 282016K/327280K available (3659K kernel code, 381K r=
wdata, 2244K rodata, 420K init, 8696K bss, 45264K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffa00000   (2048 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff7fe000   (1712 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x81627000 - 0x81690000   ( 420 kB)
[    0.000000]       .data : 0x81392fe2 - 0x81625560   (2633 kB)
[    0.000000]       .text : 0x81000000 - 0x81392fe2   (3659 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D32, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 0
[    0.000000] CPU 0 irqstacks, hard=3D80094000 soft=3D80096000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 4911 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.528 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.51 Bogo=
MIPS (lpj=3D8978426)
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006666] ACPI: Core revision 20140926
[    0.011384] ACPI: All ACPI Tables successfully acquired
[    0.012275] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.013345] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.014739] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014739] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.016328] CPU: Intel QEMU Virtual CPU version 1.7.1 (fam: 06, model: 0=
6, stepping: 03)
[    0.019536] Performance Events: Broken PMU hardware detected, using soft=
ware events only.
[    0.024105] Failed to access perfctr msr (MSR c1 is 0)
[    0.027302] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.028093] Getting VERSION: 50014
[    0.028600] Getting VERSION: 50014
[    0.029121] Getting ID: 0
[    0.029515] Getting ID: f000000
[    0.030022] Getting LVT0: 8700
[    0.030473] Getting LVT1: 8400
[    0.031033] enabled ExtINT on CPU#0
[    0.032887] ENABLING IO-APIC IRQs
[    0.033352] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.034373] init IO_APIC IRQs
[    0.034813]  apic 0 pin 0 not connected
[    0.035412] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.036721] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.037868] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.038987] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.040032] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.041139] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.042224] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.043365] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.044464] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.045543] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.046699] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.047838] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.048987] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.050035] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.051162] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.052285] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.053362]  apic 0 pin 16 not connected
[    0.053932]  apic 0 pin 17 not connected
[    0.054495]  apic 0 pin 18 not connected
[    0.055064]  apic 0 pin 19 not connected
[    0.055625]  apic 0 pin 20 not connected
[    0.056672]  apic 0 pin 21 not connected
[    0.057210]  apic 0 pin 22 not connected
[    0.057751]  apic 0 pin 23 not connected
[    0.058477] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.059558] Using local APIC timer interrupts.
[    0.059558] calibrating APIC timer ...
[    0.063333] ... lapic delta =3D 6250902
[    0.063333] ... PM-Timer delta =3D 358008
[    0.063333] ... PM-Timer result ok
[    0.063333] ..... delta 6250902
[    0.063333] ..... mult: 268474223
[    0.063333] ..... calibration result: 3333814
[    0.063333] ..... CPU clock speed is 2694.0593 MHz.
[    0.063333] ..... host bus clock speed is 1000.0814 MHz.
[    0.066659] prandom: seed boundary self test passed
[    0.067389] prandom: 100 self tests passed
[    0.068898] regulator-dummy: no parameters
[    0.070231] RTC time:  6:23:17, date: 11/15/14
[    0.071551] NET: Registered protocol family 16
[    0.073965] EISA bus registered
[    0.074703] cpuidle: using governor ladder
[    0.076047] ACPI: bus type PCI registered
[    0.076865] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.078244] PCI: Using configuration type 1 for base access
[    0.088828] Running resizable hashtable tests...
[    0.089937]   Adding 2048 keys
[    0.090724]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    0.092417]   Table expansion iteration 0...
[    0.093649]   Verifying lookups...
[    0.094562]   Table expansion iteration 1...
[    0.096675]   Verifying lookups...
[    0.097576]   Table expansion iteration 2...
[    0.099076]   Verifying lookups...
[    0.100029]   Table expansion iteration 3...
[    0.102256]   Verifying lookups...
[    0.103213]   Table shrinkage iteration 0...
[    0.103607]   Verifying lookups...
[    0.104504]   Table shrinkage iteration 1...
[    0.105613]   Verifying lookups...
[    0.106790]   Table shrinkage iteration 2...
[    0.107901]   Verifying lookups...
[    0.108812]   Table shrinkage iteration 3...
[    0.110044]   Verifying lookups...
[    0.110952]   Deleting 2048 keys
[    0.113524] ACPI: Added _OSI(Module Device)
[    0.114470] ACPI: Added _OSI(Processor Device)
[    0.115467] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.116552] ACPI: Added _OSI(Processor Aggregator Device)
[    0.118543] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.127311] ACPI: Interpreter enabled
[    0.128190] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140926/hwxface-580)
[    0.130009] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140926/hwxface-580)
[    0.132137] ACPI: (supports S0 S3 S5)
[    0.132950] ACPI: Using IOAPIC for interrupt routing
[    0.133391] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.147232] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.148756] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.150046] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.152112] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.153553] PCI host bridge to bus 0000:00
[    0.154498] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.156674] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.158145] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.160006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.161670] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.163435] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.165568] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.167674] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.172114] pci 0000:00:01.1: reg 0x20: [io  0xc080-0xc08f]
[    0.174447] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.176304] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.178246] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.179950] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.180479] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.183851] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.185458] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.187182] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.190718] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.194022] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.202638] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.204302] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.207717] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.210008] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.216223] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.217275] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.221069] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.223341] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.230538] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.232493] pci 0000:00:05.0: reg 0x10: [mem 0xfebf2000-0xfebf200f]
[    0.238013] pci_bus 0000:00: on NUMA node 0
[    0.240572] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.242384] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.244057] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.245762] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.247233] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.249734] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.250718] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.252062] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.253346] vgaarb: loaded
[    0.253985] vgaarb: bridge control possible 0000:00:02.0
[    0.256962] ACPI: bus type USB registered
[    0.258067] usbcore: registered new interface driver usbfs
[    0.259481] usbcore: registered new interface driver hub
[    0.260113] usbcore: registered new device driver usb
[    0.261445] pps_core: LinuxPPS API ver. 1 registered
[    0.263342] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.265444] PTP clock support registered
[    0.266836] PCI: Using ACPI for IRQ routing
[    0.267830] PCI: pci_cache_line_size set to 32 bytes
[    0.269187] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.270026] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.272168] NET: Registered protocol family 8
[    0.273339] NET: Registered protocol family 20
[    0.274906] Switched to clocksource kvm-clock
[    0.274906] FS-Cache: Loaded
[    0.275508] pnp: PnP ACPI init
[    0.276373] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.278353] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.279907] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.281805] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.284322] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.286261] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.287895] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.289711] pnp 00:03: [dma 2]
[    0.290505] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.292064] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.293929] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.295532] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.297472] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.299139] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.301038] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.303155] pnp: PnP ACPI: found 7 devices
[    0.339550] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.340868] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.342101] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.343527] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.345008] NET: Registered protocol family 2
[    0.346551] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    0.348405] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    0.350398] TCP: Hash tables configured (established 4096 bind 4096)
[    0.352107] TCP: reno registered
[    0.352893] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.354360] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.356131] NET: Registered protocol family 1
[    0.358422] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.359802] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.361207] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.362672] pci 0000:00:02.0: Video device with shadowed ROM
[    0.364072] PCI: CLS 0 bytes, default 32
[    0.365477] Unpacking initramfs...
[    0.935579] Freeing initrd memory: 10268K (935e9000 - 93ff0000)
[    0.937599] apm: BIOS not found.
[    0.938854] cryptomgr_test (14) used greatest stack depth: 7180 bytes le=
ft
[    0.941089] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    0.948064] rcu-torture: Creating rcu_torture_writer task
[    0.949510] rcu-torture: Creating rcu_torture_fakewriter task
[    0.950895] rcu-torture: rcu_torture_writer task started
[    0.952099] rcu-torture: Creating rcu_torture_fakewriter task
[    0.954221] rcu-torture: rcu_torture_fakewriter task started
[    0.955364] rcu-torture: Creating rcu_torture_fakewriter task
[    0.956546] rcu-torture: rcu_torture_fakewriter task started
[    0.957712] rcu-torture: Creating rcu_torture_fakewriter task
[    0.958888] rcu-torture: rcu_torture_fakewriter task started
[    0.960043] rcu-torture: Creating rcu_torture_reader task
[    0.961145] rcu-torture: rcu_torture_fakewriter task started
[    0.962356] rcu-torture: Creating rcu_torture_stats task
[    0.964508] rcu-torture: rcu_torture_reader task started
[    0.965728] rcu-torture: Creating torture_shuffle task
[    0.966989] rcu-torture: rcu_torture_stats task started
[    0.968213] rcu-torture: Creating torture_stutter task
[    0.969437] rcu-torture: torture_shuffle task started
[    0.970649] rcu-torture: Creating rcu_torture_cbflood task
[    0.971974] rcu-torture: torture_stutter task started
[    0.973647] futex hash table entries: 16 (order: -3, 704 bytes)
[    0.975017] Initialise system trusted keyring
[    0.976163] audit: initializing netlink subsys (disabled)
[    0.978370] rcu-torture: rcu_torture_cbflood task started
[    0.979686] audit: type=3D2000 audit(1416003799.172:1): initialized
[    0.981630] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.991906] zbud: loaded
[    0.992865] VFS: Disk quotas dquot_6.5.2
[    0.994008] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.996967] ceph: loaded (mds proto 32)
[    0.999735] Key type asymmetric registered
[    1.000747] Asymmetric key parser 'x509' registered
[    1.003837] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    1.004973] crc32: self tests passed, processed 225944 bytes in 670157 n=
sec
[    1.007234] crc32c: CRC_LE_BITS =3D 8
[    1.008052] crc32c: self tests passed, processed 225944 bytes in 314686 =
nsec
[    1.045077] crc32_combine: 8373 self tests passed
[    1.083157] crc32c_combine: 8373 self tests passed
[    1.084505] rbtree testing -> 13732 cycles
[    1.631812] augmented rbtree testing -> 20496 cycles
[    2.442926] tsc: Refined TSC clocksource calibration: 2693.505 MHz
[    2.536081] intel_idle: does not run on family 6 model 6
[    2.537744] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.539511] ACPI: Power Button [PWRF]
[    2.540975] isapnp: Scanning for PnP cards...
[    3.093858] isapnp: No Plug & Play device found
[    3.094972] xenfs: not registering filesystem on non-xen platform
[    3.096657] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.128743] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    3.131570] Non-volatile memory driver v1.3
[    3.132409] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    3.133757] platform pc8736x_gpio.0: no device found
[    3.134865] nsc_gpio initializing
[    3.135508] smapi::smapi_init, ERROR invalid usSmapiID
[    3.136460] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    3.138221] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    3.139530] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    3.140837] dummy-irq: no IRQ given.  Use irq=3DN
[    3.141715] usbcore: registered new interface driver viperboard
[    3.143080] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    3.144340] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    3.178194] No valid DiskOnChip devices found
[    3.179196] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.180941] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.182643] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.184401] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.186128] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.187868] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.189574] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    3.190763] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    3.191623] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    3.192742] flash size: 128 MiB
[    3.193363] page size: 512 bytes
[    3.193968] OOB area size: 16 bytes
[    3.194612] sector size: 16 KiB
[    3.195199] pages number: 262144
[    3.195817] pages per sector: 32
[    3.196453] bus width: 8
[    3.196961] bits in sector size: 14
[    3.197611] bits in page size: 9
[    3.198214] bits in OOB size: 4
[    3.198803] flash size with OOB: 135168 KiB
[    3.199569] page address bytes: 4
[    3.200212] sector address bytes: 3
[    3.200860] options: 0x42
[    3.202888] Scanning device for bad blocks
[    3.249451] kworker/u2:1 (66) used greatest stack depth: 7048 bytes left
[    3.250826] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.251968] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.254839] tlan: ThunderLAN driver v1.17
[    3.255883] tlan: 0 devices installed, PCI: 0  EISA: 0
[    3.256991] adummy: version 1.0
[    3.258076] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.259283] ehci-pci: EHCI PCI platform driver
[    3.260715] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.261879] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    3.263043] usbcore: registered new interface driver cdc_acm
[    3.264114] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    3.265621] usbcore: registered new interface driver usblp
[    3.266882] usbcore: registered new interface driver mdc800
[    3.267920] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    3.269375] usbcore: registered new interface driver adutux
[    3.270485] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    3.271830] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    3.273181] usbcore: registered new interface driver ldusb
[    3.274277] usbcore: registered new interface driver rio500
[    3.275366] usbcore: registered new interface driver usbtest
[    3.277695] usbcore: registered new interface driver usb_ehset_test
[    3.278886] usbcore: registered new interface driver usbsevseg
[    3.279999] usbcore: registered new interface driver yurex
[    3.282219] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.284760] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.285731] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.288173] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.290180] usbcore: registered new interface driver hanwang
[    3.291402] usbcore: registered new interface driver sur40
[    3.293489] Driver for 1-wire Dallas network protocol.
[    3.294702] applesmc: supported laptop not found!
[    3.295571] applesmc: driver init failed (ret=3D-19)!
[    3.296881] Modular ISDN core version 1.1.29
[    3.297800] NET: Registered protocol family 34
[    3.299309] DSP module 2.0
[    3.299832] mISDN_dsp: DSP clocks every 80 samples. This equals 3 jiffie=
s.
[    3.303804] gigaset: Driver for Gigaset 307x
[    3.304605] gigaset: no ISDN subsystem interface
[    3.305537] usbcore: registered new interface driver bas_gigaset
[    3.306920] bas_gigaset: USB Driver for Gigaset 307x
[    3.308067] platform eisa.0: Probing EISA bus 0
[    3.308918] platform eisa.0: EISA: Cannot allocate resource for mainboard
[    3.310336] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    3.311491] Copyright 2010. Beceem Communications Inc
[    3.312505] usbcore: registered new interface driver usbbcm
[    3.313920] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[    3.315052] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    3.316487] ad1848: No ISAPnP cards found, trying standard ones...
[    3.318688] MediaTrix audio driver Copyright (C) by Hannu Savolainen 199=
3-1996
[    3.320028] I/O, IRQ, DMA and type are mandatory
[    3.320884] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[    3.322479] Netfilter messages via NETLINK v0.30.
[    3.323396] nf_conntrack version 0.5.0 (4822 buckets, 19288 max)
[    3.325019] ctnetlink v0.93: registering with nfnetlink.
[    3.326127] gre: GRE over IPv4 demultiplexor driver
[    3.327435] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.328499] TCP: highspeed registered
[    3.329190] TCP: vegas registered
[    3.329818] TCP: illinois registered
[    3.330509] Initializing XFRM netlink socket
[    3.331468] NET: Registered protocol family 4
[    3.332314] can: controller area network core (rev 20120528 abi 9)
[    3.333517] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[    3.334773] NET: Registered protocol family 29
[    3.335692] NET: Registered protocol family 33
[    3.336569] Key type rxrpc registered
[    3.337277] Key type rxrpc_s registered
[    3.338504] RxRPC: Registered security type 2 'rxkad'
[    3.339472] mpoa:atm_mpoa_init: mpc.c: initialized
[    3.340376] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    3.342085] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
[    3.343531] NET: Registered protocol family 12
[    3.344384] 8021q: 802.1Q VLAN Support v1.8
[    3.346444] DCCP: Activated CCID 2 (TCP-like)
[    3.347354] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    3.348980] 9pnet: Installing 9P2000 support
[    3.350518] Key type ceph registered
[    3.351527] libceph: loaded (mon/osd proto 15/24)
[    3.352421] mpls_gso: MPLS GSO support
[    3.353177] mce: Unable to init device /dev/mcelog (rc: -5)
[    3.354733]=20
[    3.354733] printing PIC contents
[    3.355646] ... PIC  IMR: ffff
[    3.356239] ... PIC  IRR: 1013
[    3.356851] ... PIC  ISR: 0000
[    3.357426] ... PIC ELCR: 0c00
[    3.359131] printing local APIC contents on CPU#0/0:
[    3.360060] ... APIC ID:      00000000 (0)
[    3.360172] ... APIC VERSION: 00050014
[    3.360172] ... APIC TASKPRI: 00000000 (00)
[    3.360172] ... APIC PROCPRI: 00000000
[    3.360172] ... APIC LDR: 01000000
[    3.360172] ... APIC DFR: ffffffff
[    3.360172] ... APIC SPIV: 000001ff
[    3.360172] ... APIC ISR field:
[    3.360172] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.360172] ... APIC TMR field:
[    3.360172] 000000000200000000000000000000000000000000000000000000000000=
0000
[    3.360172] ... APIC IRR field:
[    3.360172] 000000000000000000000000000000000000000000000000000000000000=
8000
[    3.360172] ... APIC ESR: 00000000
[    3.360172] ... APIC ICR: 00000831
[    3.360172] ... APIC ICR2: 01000000
[    3.360172] ... APIC LVTT: 000000ef
[    3.360172] ... APIC LVTPC: 00000400
[    3.360172] ... APIC LVT0: 00010700
[    3.360172] ... APIC LVT1: 00000400
[    3.360172] ... APIC LVTERR: 000000fe
[    3.360172] ... APIC TMICT: 000302af
[    3.360172] ... APIC TMCCT: 00000000
[    3.360172] ... APIC TDCR: 00000003
[    3.360172]=20
[    3.379256] number of MP IRQ sources: 15.
[    3.380024] number of IO-APIC #0 registers: 24.
[    3.380863] testing the IO APIC.......................
[    3.381877] IO APIC #0......
[    3.382409] .... register #00: 00000000
[    3.383117] .......    : physical APIC id: 00
[    3.383945] .......    : Delivery Type: 0
[    3.384674] .......    : LTS          : 0
[    3.385452] .... register #01: 00170011
[    3.386176] .......     : max redirection entries: 17
[    3.388133] .......     : PRQ implemented: 0
[    3.388949] .......     : IO APIC version: 11
[    3.389749] .... register #02: 00000000
[    3.390491] .......     : arbitration: 00
[    3.391244] .... IRQ redirection table:
[    3.391972] 1    0    0   0   0    0    0    00
[    3.392817] 0    0    0   0   0    1    1    31
[    3.393686] 0    0    0   0   0    1    1    30
[    3.394541] 0    0    0   0   0    1    1    33
[    3.395397] 1    0    0   0   0    1    1    34
[    3.396407] 1    1    0   0   0    1    1    35
[    3.397377] 0    0    0   0   0    1    1    36
[    3.398227] 0    0    0   0   0    1    1    37
[    3.399072] 0    0    0   0   0    1    1    38
[    3.399920] 0    1    0   0   0    1    1    39
[    3.400778] 1    1    0   0   0    1    1    3A
[    3.401640] 1    1    0   0   0    1    1    3B
[    3.402482] 0    0    0   0   0    1    1    3C
[    3.403331] 0    0    0   0   0    1    1    3D
[    3.404204] 0    0    0   0   0    1    1    3E
[    3.405080] 0    0    0   0   0    1    1    3F
[    3.405936] 1    0    0   0   0    0    0    00
[    3.406805] 1    0    0   0   0    0    0    00
[    3.407644] 1    0    0   0   0    0    0    00
[    3.408500] 1    0    0   0   0    0    0    00
[    3.409350] 1    0    0   0   0    0    0    00
[    3.410223] 1    0    0   0   0    0    0    00
[    3.411076] 1    0    0   0   0    0    0    00
[    3.411917] 1    0    0   0   0    0    0    00
[    3.412744] IRQ to pin mappings:
[    3.413383] IRQ0 -> 0:2
[    3.413896] IRQ1 -> 0:1
[    3.414401] IRQ3 -> 0:3
[    3.414910] IRQ4 -> 0:4
[    3.415414] IRQ5 -> 0:5
[    3.415971] IRQ6 -> 0:6
[    3.416617] IRQ7 -> 0:7
[    3.417365] IRQ8 -> 0:8
[    3.418577] IRQ9 -> 0:9
[    3.419091] IRQ10 -> 0:10
[    3.419630] IRQ11 -> 0:11
[    3.420214] IRQ12 -> 0:12
[    3.420749] IRQ13 -> 0:13
[    3.421312] IRQ14 -> 0:14
[    3.421854] IRQ15 -> 0:15
[    3.422388] .................................... done.
[    3.423391] Using IPI Shortcut mode
[    3.424305] Loading compiled-in X.509 certificates
[    3.429368] Loaded X.509 cert 'Magrathea: Glacier signing key: 2924c86ca=
20732dc33fa7b70146c30e3143dfe26'
[    3.431910]   Magic number: 6:614:367
[    3.432637] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    3.434987] Freeing unused kernel memory: 420K (81627000 - 81690000)
[    3.436338] Failed to execute /init (error -12)
[    3.437279] Starting init: /sbin/init exists but couldn't execute it (er=
ror -12)
[    3.438655] Starting init: /etc/init exists but couldn't execute it (err=
or -13)
[    3.440136] Starting init: /bin/sh exists but couldn't execute it (error=
 -12)
[    3.441487] Kernel panic - not syncing: No working init found.  Try pass=
ing init=3D option to kernel. See Linux Documentation/init.txt for guidance.
[    3.443352] CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc4-g49aba53 =
#1949
[    3.443352]  00000000 f783d540 80017f88 8138c3bd 80017fa0 8138b30b 815e1=
f40 f783d540
[    3.443352]  815e1f40 00000000 80017fac 81389523 8152ab4d 80016000 81391=
8e0 81389474
[    3.443352]  00000000 00000000 00000000 00000000 00000000 00000000 00000=
07b 0000007b
[    3.443352] Call Trace:
[    3.443352]  [<8138c3bd>] dump_stack+0x16/0x18
[    3.443352]  [<8138b30b>] panic+0x86/0x19e
[    3.443352]  [<81389523>] kernel_init+0xaf/0xb3
[    3.443352]  [<813918e0>] ret_from_kernel_thread+0x20/0x30
[    3.443352]  [<81389474>] ? rest_init+0xa2/0xa2
[    3.443352] Kernel Offset: 0x0 from 0x81000000 (relocation range: 0x8000=
0000-0x947fdfff)

Elapsed time: 10
qemu-system-i386 -enable-kvm -kernel /kernel/i386-randconfig-ha3-1109/49aba=
53037eb271723dda0be3d2a826e579aa9a4/vmlinuz-3.18.0-rc4-g49aba53 -append 'us=
er=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yocto-i386-6/rand_boot-1-yocto-mini=
mal-i386.cgz-i386-randconfig-ha3-1109-49aba53037eb271723dda0be3d2a826e579aa=
9a4-1.yaml ARCH=3Di386 BOOT_IMAGE=3D/kernel/i386-randconfig-ha3-1109/49aba5=
3037eb271723dda0be3d2a826e579aa9a4/vmlinuz-3.18.0-rc4-g49aba53 kconfig=3Di3=
86-randconfig-ha3-1109 commit=3D49aba53037eb271723dda0be3d2a826e579aa9a4 br=
anch=3Dlinux-devel/devel-lkp-hsx01-i386-201411150616 root=3D/dev/ram0 max_u=
ptime=3D3600 RESULT_ROOT=3D/result/vm-kbuild-yocto-i386/boot/1/yocto-minima=
l-i386.cgz/i386-randconfig-ha3-1109/49aba53037eb271723dda0be3d2a826e579aa9a=
4/0 ip=3D::::vm-kbuild-yocto-i386-6::dhcp earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pani=
c=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
rw drbd.minor_count=3D8'  -initrd /fs/sde1/initrd-vm-kbuild-yocto-i386-6 -m=
 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs=
/sde1/disk0-vm-kbuild-yocto-i386-6,media=3Ddisk,if=3Dvirtio -pidfile /dev/s=
hm/kboot/pid-vm-kbuild-yocto-i386-6 -serial file:/dev/shm/kboot/serial-vm-k=
build-yocto-i386-6 -daemonize -display none -monitor null=20

--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--nVMJ2NtxeReIH9PS--
