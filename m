Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbaFSGRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:17:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:6456 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbaFSGRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:17:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,505,1400050800"; 
   d="log'?scan'208";a="550197406"
Message-ID: <53A28073.3030109@intel.com>
Date: Thu, 19 Jun 2014 14:17:23 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [HZ] INFO: task kworker/0:1:16 blocked for more than 120 seconds.
Content-Type: multipart/mixed;
 boundary="------------010804010206090604060900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010804010206090604060900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Maarten,

0day kernel testing robot got the below dmesg and the first bad commit is

git://people.freedesktop.org/~mlankhorst/linux master
commit 52774d9273d6b8aff39822ccfe10e5a0d7c3a7f8
Author:     Maarten Lankhorst <m.b.lankhorst@gmail.com>
AuthorDate: Thu Jan 16 16:24:04 2014 +0100
Commit:     Maarten Lankhorst <maarten.lankhorst@canonical.com>
CommitDate: Wed Jun 18 14:19:52 2014 +0200

    There's some really badly broken software out there that is entirely
        dependant on HZ for its maximum performance. Raise the maximum HZ value
    to some higher and slightly unreasonable values up to some higher and
    completely obscene values.
        -ck

+--------------------------------------------------+------------+------------+
|                                                  | c03339ffa3 | 52774d9273 |
+--------------------------------------------------+------------+------------+
| boot_successes                                   | 60         | 0          |
| boot_failures                                    | 0          | 20         |
| INFO:task_blocked_for_more_than_seconds          | 0          | 20         |
| RIP:flat_send_IPI_mask                           | 0          | 20         |
| Kernel_panic-not_syncing:hung_task:blocked_tasks | 0          | 20         |
| backtrace:serio_handle_event                     | 0          | 20         |
| backtrace:watchdog                               | 0          | 20         |
+--------------------------------------------------+------------+------------+

[   69.176969] torture thread lock_torture_writer parking due to system shutdown
[  120.553588] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 [  120.554375] torture thread lock_torture_stats parking due to system shutdown
[  240.031059] INFO: task kworker/0:1:16 blocked for more than 120 seconds.
[  240.031837]       Not tainted 3.16.0-rc1-00045-g52774d9 #1
[  240.032443] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.033280] kworker/0:1     D ffff880013612580     0    16      2 0x00000000

git bisect start 91283063c4f74fb202ac7809a8df3cc00f22203e 7171511eaec5bf23fb06078f59784a3a0626b38f --
git bisect good bc106bf69fdfba649ad98b3c7cfd2b63e84431a8  # 01:57     20+      0  Merge 'dynticks/timers/missing-kick-v2' into devel-hourly-2014061900
git bisect  bad 25f92e043e7e4ca029592e03a2d77a09f226f395  # 02:15      0-      1  Merge 'at91/abe/at91_3.16-rc1_CCF' into devel-hourly-2014061900
git bisect good 6c815b36fd13fd40f3545c9e6e33eb7d4b396d8d  # 02:18     20+      0  Merge 'efi/next' into devel-hourly-2014061900
git bisect good a235b89e0b1332b44baff6277b5dbc711df34b3d  # 02:25     20+      0  Merge 'kvm-ppc/kvm-ppc-queue' into devel-hourly-2014061900
git bisect  bad 8b4870846e71960a223e729e3c18942edfe81f16  # 02:44      0-      4  Merge 'spi/for-next' into devel-hourly-2014061900
git bisect  bad 2115cd10081ea65213b45d9970aeebe88dabcfb3  # 02:55      0-      5  Merge 'mlankhorst/master' into devel-hourly-2014061900
git bisect  bad 52774d9273d6b8aff39822ccfe10e5a0d7c3a7f8  # 03:00      0-      4  There's some really badly broken software out there that is entirely
git bisect good 0da2b800ec8dfad78c888b33be2ad2aea3411796  # 03:06     20+      0  Merge branch 'for-nouveau'
git bisect good c03339ffa3d9d2330c8c14b8d73e9a4da38101ea  # 03:09     20+      0  drm/nouveau: add guard pages to vm
# first bad commit: [52774d9273d6b8aff39822ccfe10e5a0d7c3a7f8] There's some really badly broken software out there that is entirely
git bisect good c03339ffa3d9d2330c8c14b8d73e9a4da38101ea  # 03:12     60+      0  drm/nouveau: add guard pages to vm
git bisect  bad 91283063c4f74fb202ac7809a8df3cc00f22203e  # 03:12      0-     13  0day head guard for 'devel-hourly-2014061900'
git bisect good e99cfa2d0634881b8a41d56c48b5956b9a3ba162  # 03:50     60+      0  Merge tag 'dt-fixes-for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux
git bisect good 4ca1fbc122fcb09efa2bb1448bff8b71b46434c8  # 04:05     60+      0  Add linux-next specific files for 20140618


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm
 	-kernel $kernel
	-initrd $initrd
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
-----------------------------------------------------------------------------

Thanks,
Jet


--------------010804010206090604060900
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-yocto-ivb42-53:20140619030107:x86_64-randconfig-hsxa0-06190120:3.16.0-rc1-00045-g52774d9:1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-yocto-ivb42-53:20140619030107:x86_64-randconfig-hsxa0-";
 filename*1="06190120:3.16.0-rc1-00045-g52774d9:1"

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.16.0-rc1-00045-g52774d9 (kbuild@lkp-hsx01)=
 (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 Thu Jun 19 02:56:19 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ra=
m0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06190120=
/linux-devel:devel-hourly-2014061900:52774d9273d6b8aff39822ccfe10e5a0d7c3=
a7f8:bisect-linux3/.vmlinuz-52774d9273d6b8aff39822ccfe10e5a0d7c3a7f8-2014=
0619025632-6-ivb42 branch=3Dlinux-devel/devel-hourly-2014061900 BOOT_IMAG=
E=3D/kernel/x86_64-randconfig-hsxa0-06190120/52774d9273d6b8aff39822ccfe10=
e5a0d7c3a7f8/vmlinuz-3.16.0-rc1-00045-g52774d9 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x031fb000, 0x031fbfff] PGTABLE
[    0.000000] BRK [0x031fc000, 0x031fcfff] PGTABLE
[    0.000000] BRK [0x031fd000, 0x031fdfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x031fe000, 0x031fefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x031ff000, 0x031fffff] PGTABLE
[    0.000000] BRK [0x03200000, 0x03200fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP =
00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   =
00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC =
00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET =
00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor=
 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1c52600
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-0=
6190120/linux-devel:devel-hourly-2014061900:52774d9273d6b8aff39822ccfe10e=
5a0d7c3a7f8:bisect-linux3/.vmlinuz-52774d9273d6b8aff39822ccfe10e5a0d7c3a7=
f8-20140619025632-6-ivb42 branch=3Dlinux-devel/devel-hourly-2014061900 BO=
OT_IMAGE=3D/kernel/x86_64-randconfig-hsxa0-06190120/52774d9273d6b8aff3982=
2ccfe10e5a0d7c3a7f8/vmlinuz-3.16.0-rc1-00045-g52774d9 drbd.minor_count=3D=
8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 by=
tes)
[    0.000000] Memory: 280952K/327280K available (7231K kernel code, 4685=
K rwdata, 3844K rodata, 808K init, 17008K bss, 46328K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1,=
 Nodes=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.386 MHz processor
[    0.001250] Calibrating delay loop (skipped) preset value.. 5386.21 Bo=
goMIPS (lpj=3D673346)
[    0.001508] pid_max: default: 4096 minimum: 301
[    0.001789] ACPI: Core revision 20140424
[    0.004552] ACPI: All ACPI Tables successfully acquired
[    0.005274] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes=
)
[    0.005514] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 =
bytes)
[    0.006525] Initializing cgroup subsys memory
[    0.007065] Initializing cgroup subsys devices
[    0.007289] Initializing cgroup subsys freezer
[    0.007528] Initializing cgroup subsys perf_event
[    0.007764] Initializing cgroup subsys hugetlb
[    0.008075] mce: CPU supports 10 MCE banks
[    0.008312] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008312] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.008312] tlb_flushall_shift: 6
[    0.008508] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepp=
ing: 01)
[    0.012945] Performance Events: unsupported Netburst CPU model 6 no PM=
U driver, software events only.
[    0.014102] Getting VERSION: 50014
[    0.014262] Getting VERSION: 50014
[    0.014509] Getting ID: 0
[    0.014763] Getting ID: ff000000
[    0.015011] Getting LVT0: 8700
[    0.015258] Getting LVT1: 8400
[    0.015527] enabled ExtINT on CPU#0
[    0.016661] ENABLING IO-APIC IRQs
[    0.016758] init IO_APIC IRQs
[    0.017008]  apic 0 pin 0 not connected
[    0.017276] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.017527] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.017776] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.018024] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.018274] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.018524] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.018774] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.019024] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.019273] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.019524] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.019775] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.020280] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.020524] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.020774] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.021024] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.021271]  apic 0 pin 16 not connected
[    0.021506]  apic 0 pin 17 not connected
[    0.021756]  apic 0 pin 18 not connected
[    0.022256]  apic 0 pin 19 not connected
[    0.022506]  apic 0 pin 20 not connected
[    0.023005]  apic 0 pin 21 not connected
[    0.023256]  apic 0 pin 22 not connected
[    0.023506]  apic 0 pin 23 not connected
[    0.024149] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.024255] Using local APIC timer interrupts.
[    0.024255] calibrating APIC timer ...
[    0.024750] ... lapic delta =3D 6249992
[    0.024750] ... PM-Timer delta =3D 357967
[    0.024750] ... PM-Timer result ok
[    0.024750] ..... delta 6249992
[    0.024750] ..... mult: 268435112
[    0.024750] ..... calibration result: 249999
[    0.024750] ..... CPU clock speed is 2693.0139 MHz.
[    0.024750] ..... host bus clock speed is 999.0249 MHz.
[    0.025326] NMI watchdog: disabled (cpu0): hardware events not enabled=

[    0.025789] devtmpfs: initialized
[    0.027250] gcov: version magic: 0x3430382a
[    0.028728] atomic64_test: passed for x86-64 platform with CX8 and wit=
h SSE
[    0.029000] regulator-dummy: no parameters
[    0.029500] NET: Registered protocol family 16
[    0.030000] cpuidle: using governor menu
[    0.030500] ACPI: bus type PCI registered
[    0.030604] PCI: Using configuration type 1 for base access
[    0.031250] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.031315] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.031641] ACPI: Added _OSI(Module Device)
[    0.031757] ACPI: Added _OSI(Processor Device)
[    0.032007] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.032256] ACPI: Added _OSI(Processor Aggregator Device)
[    0.036500] ACPI: Interpreter enabled
[    0.036518] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S1_] (20140424/hwxface-580)
[    0.037258] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20140424/hwxface-580)
[    0.038000] ACPI: (supports S0 S3 S5)
[    0.038006] ACPI: Using IOAPIC for interrupt routing
[    0.038510] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.042750] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.042764] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.043040] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASP=
M
[    0.043673] acpi PNP0A03:00: fail to add MMCONFIG information, can't a=
ccess extended PCI configuration space under this bridge.
[    0.043829] PCI host bridge to bus 0000:00
[    0.044019] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.044267] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.044522] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.044757] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.045007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebff=
fff]
[    0.045330] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.045995] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.046681] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.048250] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.048781] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-=
0x01f7]
[    0.049007] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]=

[    0.049256] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-=
0x0177]
[    0.049506] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]=

[    0.050000] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.050349] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PI=
IX4 ACPI
[    0.050518] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PI=
IX4 SMB
[    0.051231] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.052309] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pre=
f]
[    0.053045] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.056546] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pre=
f]
[    0.057331] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.058009] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.058759] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.061250] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pre=
f]
[    0.061624] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.062250] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.064000] pci_bus 0000:00: on NUMA node 0
[    0.064656] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.065185] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.065686] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.066250] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.066745] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.067492] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.068250] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.068256] vgaarb: loaded
[    0.068505] vgaarb: bridge control possible 0000:00:02.0
[    0.069250] pps_core: LinuxPPS API ver. 1 registered
[    0.069256] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    0.069681] wmi: Mapper loaded
[    0.069862] Advanced Linux Sound Architecture Driver Initialized.
[    0.070022] PCI: Using ACPI for IRQ routing
[    0.070268] PCI: pci_cache_line_size set to 64 bytes
[    0.070647] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.070765] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.071555] HPET: 3 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.072205] Switched to clocksource kvm-clock
[    0.072985] FS-Cache: Loaded
[    0.073480] pnp: PnP ACPI init
[    0.073912] ACPI: bus type PNP registered
[    0.074574] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.075604] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.076419] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.077471] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)=

[    0.078367] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.079380] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)=

[    0.080274] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.081340] pnp 00:03: [dma 2]
[    0.081768] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)=

[    0.082708] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.083716] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)=

[    0.084627] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.085715] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.086656] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.087789] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.089104] pnp: PnP ACPI: found 7 devices
[    0.089694] ACPI: bus type PNP unregistered
[    0.095681] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.096471] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.097160] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.097975] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.098847] NET: Registered protocol family 1
[    0.099456] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.100204] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.101029] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.101951] pci 0000:00:02.0: Boot video device
[    0.102583] PCI: CLS 0 bytes, default 64
[    0.103443] Unpacking initramfs...
[    0.215487] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013=
feffff]
[    0.217330] Scanning for low memory corruption every 60 seconds
[    0.218834] camellia-x86_64: performance on this CPU would be suboptim=
al: disabling camellia-x86_64.
[    0.220212] twofish-x86_64-3way: performance on this CPU would be subo=
ptimal: disabling twofish-x86_64-3way.
[    0.222982] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/us=
able.
[    0.223789] PCLMULQDQ-NI instructions are not detected.
[    0.224459] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.225217] AVX or AES-NI instructions are not detected.
[    0.225842] AVX instructions are not detected.
[    0.226356] AVX instructions are not detected.
[    0.226876] AVX instructions are not detected.
[    0.227390] AVX2 instructions are not detected.
[    0.228037] spin_lock-torture:--- Start of test: nwriters_stress=3D2 s=
tat_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_s=
ecs=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.229818] spin_lock-torture: Creating torture_shuffle task
[    0.230580] spin_lock-torture: Creating torture_stutter task
[    0.231283] spin_lock-torture: torture_shuffle task started
[    0.231968] spin_lock-torture: Creating lock_torture_writer task
[    0.232792] spin_lock-torture: torture_stutter task started
[    0.233479] spin_lock-torture: Creating lock_torture_writer task
[    0.234200] spin_lock-torture: lock_torture_writer task started
[    0.234918] spin_lock-torture: Creating lock_torture_stats task
[    0.235674] spin_lock-torture: lock_torture_writer task started
[    0.236548] futex hash table entries: 16 (order: -2, 1536 bytes)
[    0.552072] spin_lock-torture: lock_torture_stats task started
[    0.553027] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.555750] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.563675] alg: No test for crc32 (crc32-table)
[    0.564723] alg: No test for lz4 (lz4-generic)
[    0.565375] alg: No test for lz4hc (lz4hc-generic)
[    0.566075] alg: No test for stdrng (krng)
[    0.574568] start plist test
[    0.576312] end plist test
[    0.576653] list_sort_test: start testing list_sort()
[    0.577478] test_string_helpers: Running tests...
[    0.579158] VIA Graphics Integration Chipset framebuffer 2.4 initializ=
ing
[    0.580415] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
[    0.581295] ACPI: Power Button [PWRF]
[    0.603737] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.630800] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200=
) is a 16550A
[    0.632282] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw=
2 Exp $
[    0.633103] ac.o: No PCI boards found.
[    0.633550] ac.o: For an ISA board you must supply memory and irq para=
meters.
[    0.634448] Non-volatile memory driver v1.3
[    0.634959] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    0.635561] Linux agpgart interface v0.103
[    0.636241] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 sec=
onds, margin is 60 seconds).
[    0.637237] Hangcheck: Using getrawmonotonic().
[    0.637797] intelfb: intelfb_init
[    0.638190] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/8=
55GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[    0.639460] intelfb: Version 0.9.6
[    0.639863] intelfb: intelfb_setup
[    0.640272] intelfb: no options
[    0.640802] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo =
Giometti
[    0.641694] c2port c2port0: C2 port uc added
[    0.642221] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 =
bytes total)
[    0.643181] Guest personality initialized and is inactive
[    0.643877] VMCI host device registered (name=3Dvmci, major=3D10, mino=
r=3D62)
[    0.644636] Initialized host personality
[    0.645188] mic_init not running on X100 ret -19
[    0.646227] mtdoops: mtd device (mtddev=3Dname/number) must be supplie=
d
[    0.647025] L440GX flash mapping: failed to find PIIX4 ISA bridge, can=
not continue
[    0.647971] slram: not enough parameters.
[    0.655112] HSI/SSI char device loaded
[    0.655886] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0=
x60,0x64 irq 1,12
[    0.657670] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.658288] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.659344] mousedev: PS/2 mouse device common for all mice
[    0.660596] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input1
[    0.661956] i2c /dev entries driver
[    0.662663] i2c-parport-light: adapter type unspecified
[    0.663304] Driver for 1-wire Dallas network protocol.
[    0.663980] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    0.664788] 1-Wire driver for the DS2760 battery monitor  chip  - (c) =
2004-2005, Szabolcs Gyurko
[    0.665903] power_supply test_ac: power_supply_changed
[    0.666740] power_supply test_battery: power_supply_changed
[    0.667440] power_supply test_usb: power_supply_changed
[    0.668706] f71882fg: Not a Fintek device
[    0.669195] f71882fg: Not a Fintek device
[    0.670183] sch56xx_common: Unsupported device id: 0xff
[    0.670856] sch56xx_common: Unsupported device id: 0xff
[    0.671868] intel_powerclamp: Intel powerclamp does not run on family =
15 model 6
[    0.672786] acquirewdt: WDT driver for Acquire single board computer i=
nitialising
[    0.673740] acquirewdt: I/O address 0x0043 already in use
[    0.674396] acquirewdt: probe of acquirewdt failed with error -5
[    0.675202] advantechwdt: WDT driver for Advantech single board comput=
er initialising
[    0.678203] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)=

[    0.678943] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    0.679603] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    0.680324] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[    0.681250] geodewdt: No timers were available
[    0.681864] ib700wdt: WDT driver for IB700 single board computer initi=
alising
[    0.682830] ib700wdt: START method I/O 443 is not available
[    0.683479] ib700wdt: probe of ib700wdt failed with error -5
[    0.684147] wafer5823wdt: WDT driver for Wafer 5823 single board compu=
ter initialising
[    0.685045] wafer5823wdt: I/O address 0x0443 already in use
[    0.685746] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    0.686617] i6300esb: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    0.687383] i6300ESB timer: probe of 0000:00:04.0 failed with error -1=
6
[    0.688185] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    0.688910] sc1200wdt: build 20020303
[    0.689438] sc1200wdt: io parameter must be specified
[    0.690084] sbc60xxwdt: I/O address 0x0443 already in use
[    0.690729] cpu5wdt: misc_register failed
[    0.691316] w83877f_wdt: I/O address 0x0443 already in use
[    0.691950] w83977f_wdt: driver v1.00
[    0.692410] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    0.693185] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    0.693874] machzwd: no ZF-Logic found
[    0.694329] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    0.695373] power_supply test_ac: power_supply_changed_work
[    0.696103] power_supply test_battery: power_supply_changed_work
[    0.696833] power_supply test_usb: power_supply_changed_work
[    0.698069] alienware_wmi: alienware-wmi: No known WMI GUID found
[    0.698915]  fake-fmc-carrier: mezzanine 0
[    0.699403]       Manufacturer: fake-vendor
[    0.699895]       Product name: fake-design-for-testing
[    0.700587] fmc fake-design-for-testing-f001: Driver has no ID: matche=
s all
[    0.701406] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_e=
eprom: no busid passed, refusing all cards
[    0.702624] intel_rapl: driver does not support CPU family 15 model 6
[    0.706824] no UART detected at 0x1
[    0.708825] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[    0.710125]=20
[    0.710125] printing PIC contents
[    0.710728] ... PIC  IMR: ffff
[    0.710961] ... PIC  IRR: 1013
[    0.711508] ... PIC  ISR: 0000
[    0.711908] ... PIC ELCR: 0c00
[    0.712267] printing local APIC contents on CPU#0/0:
[    0.712508] ... APIC ID:      00000000 (0)
[    0.712508] ... APIC VERSION: 00050014
[    0.712508] ... APIC TASKPRI: 00000000 (00)
[    0.712508] ... APIC PROCPRI: 00000000
[    0.712508] ... APIC LDR: 01000000
[    0.712508] ... APIC DFR: ffffffff
[    0.712508] ... APIC SPIV: 000001ff
[    0.712508] ... APIC ISR field:
[    0.712508] 0000000000000000000000000000000000000000000000000000000000=
000000
[    0.712508] ... APIC TMR field:
[    0.712508] 0000000002000000000000000000000000000000000000000000000000=
000000
[    0.712508] ... APIC IRR field:
[    0.712508] 0000000000000000000000000000000000000000000000000000000000=
008000
[    0.712508] ... APIC ESR: 00000000
[    0.712508] ... APIC ICR: 00000831
[    0.712508] ... APIC ICR2: 01000000
[    0.712508] ... APIC LVTT: 000000ef
[    0.712508] ... APIC LVTPC: 00010000
[    0.712508] ... APIC LVT0: 00010700
[    0.712508] ... APIC LVT1: 00000400
[    0.712508] ... APIC LVTERR: 000000fe
[    0.712508] ... APIC TMICT: 00003a97
[    0.712508] ... APIC TMCCT: 00000000
[    0.712508] ... APIC TDCR: 00000003
[    0.712508]=20
[    0.724611] number of MP IRQ sources: 15.
[    0.725073] number of IO-APIC #0 registers: 24.
[    0.725625] testing the IO APIC.......................
[    0.726250] IO APIC #0......
[    0.726614] .... register #00: 00000000
[    0.727089] .......    : physical APIC id: 00
[    0.727637] .......    : Delivery Type: 0
[    0.728112] .......    : LTS          : 0
[    0.728595] .... register #01: 00170011
[    0.729038] .......     : max redirection entries: 17
[    0.729615] .......     : PRQ implemented: 0
[    0.730101] .......     : IO APIC version: 11
[    0.730655] .... register #02: 00000000
[    0.731098] .......     : arbitration: 00
[    0.731595] .... IRQ redirection table:
[    0.732086] 1    0    0   0   0    0    0    00
[    0.732621] 0    0    0   0   0    1    1    31
[    0.733148] 0    0    0   0   0    1    1    30
[    0.733712] 0    0    0   0   0    1    1    33
[    0.734269] 1    0    0   0   0    1    1    34
[    0.734812] 1    1    0   0   0    1    1    35
[    0.735396] 0    0    0   0   0    1    1    36
[    0.735933] 0    0    0   0   0    1    1    37
[    0.736471] 0    0    0   0   0    1    1    38
[    0.737003] 0    1    0   0   0    1    1    39
[    0.737577] 1    1    0   0   0    1    1    3A
[    0.738157] 1    1    0   0   0    1    1    3B
[    0.738695] 0    0    0   0   0    1    1    3C
[    0.739225] 0    0    0   0   0    1    1    3D
[    0.739797] 0    0    0   0   0    1    1    3E
[    0.740357] 0    0    0   0   0    1    1    3F
[    0.740905] 1    0    0   0   0    0    0    00
[    0.741454] 1    0    0   0   0    0    0    00
[    0.742027] 1    0    0   0   0    0    0    00
[    0.742620] 1    0    0   0   0    0    0    00
[    0.743162] 1    0    0   0   0    0    0    00
[    0.743703] 1    0    0   0   0    0    0    00
[    0.744237] 1    0    0   0   0    0    0    00
[    0.744775] 1    0    0   0   0    0    0    00
[    0.745310] IRQ to pin mappings:
[    0.745713] IRQ0 -> 0:2
[    0.746070] IRQ1 -> 0:1
[    0.746443] IRQ3 -> 0:3
[    0.746794] IRQ4 -> 0:4
[    0.747169] IRQ5 -> 0:5
[    0.747540] IRQ6 -> 0:6
[    0.747931] IRQ7 -> 0:7
[    0.748281] IRQ8 -> 0:8
[    0.748625] IRQ9 -> 0:9
[    0.748962] IRQ10 -> 0:10
[    0.749390] IRQ11 -> 0:11
[    0.749766] IRQ12 -> 0:12
[    0.750207] IRQ13 -> 0:13
[    0.750588] IRQ14 -> 0:14
[    0.750962] IRQ15 -> 0:15
[    0.751349] .................................... done.
[    0.752939] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.753684] EDD information not available.
[    0.754182] ALSA device list:
[    0.754583]   #0: Loopback 1
[    0.754929]   #1: MTPAV on parallel port at 0x378
[    0.756402] debug: unmapping init [mem 0xffffffff82095000-0xffffffff82=
15efff]
[    0.757351] Write protecting the kernel read-only data: 12288k
[    0.758450] debug: unmapping init [mem 0xffff88000171a000-0xffff880001=
7fffff]
[    0.759377] debug: unmapping init [mem 0xffff880001bc1000-0xffff880001=
bfffff]
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such fi=
le or directory
bootlogd.
/etc/init.d/rc: eval: line 1: can't create /dev/tty0: No such device or a=
ddress
Configuring network interfaces... ifconfig: socket: Address family not su=
pported by protocol
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
sed: /lib/modules/3.16.0-rc1-00045-g52774d9/modules.dep: No such file or =
directory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
/etc/kernel-tests/90-trinity: /etc/kernel-tests/90-trinity: line 18: /usr=
/sbin/chroot: not foundline 17: /usr/sbin/chroot: not found/etc/kernel-te=
sts/90-trinity: line 16: /trinity: not found

/etc/kernel-tests/90-trinity:=20
line 15: /trinity: not found
[    1.220115] tsc: Refined TSC clocksource calibration: 2693.464 MHz
[   60.552825] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail:=
 0=20
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123
wfg: skip syslogd
Deconfiguring network interfaces... ifconfig: socket: Address family not =
supported by protocol
done.
Sending all processes the TERM signal...
Sending all processes the KILL signal...
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
Rebooting...=20
[   68.309400] Unregister pv shared memory for cpu 0
[   68.310153] spin_lock-torture: Unscheduled system shutdown detected
[   68.311058] torture thread torture_stutter parking due to system shutd=
own
[   68.311895] torture thread torture_shuffle parking due to system shutd=
own
[   69.176073] torture thread lock_torture_writer parking due to system s=
hutdown
[   69.176969] torture thread lock_torture_writer parking due to system s=
hutdown
[  120.553588] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail:=
 0=20
[  120.554375] torture thread lock_torture_stats parking due to system sh=
utdown
[  240.031059] INFO: task kworker/0:1:16 blocked for more than 120 second=
s.
[  240.031837]       Not tainted 3.16.0-rc1-00045-g52774d9 #1
[  240.032443] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[  240.033280] kworker/0:1     D ffff880013612580     0    16      2 0x00=
000000
[  240.034195] Workqueue: events_long serio_handle_event
[  240.034788]  ffff8800136b3a48 0000000000000016 ffff8800136b3fd8 ffff88=
0013643840
[  240.035711]  0000000000000000 ffff880013644058 ffff8800136b3998 ffffff=
ff81034a47
[  240.036628]  ffff8800136b39a8 ffffffff8100bfc3 ffff8800136b39b8 000000=
0000000008
[  240.037563] Call Trace:
[  240.037863]  [<ffffffff81034a47>] ? kvm_clock_read+0x25/0x3c
[  240.038496]  [<ffffffff8100bfc3>] ? sched_clock+0x10/0x1b
[  240.039100]  [<ffffffff810f39db>] ? mark_held_locks+0x7d/0xa9
[  240.039742]  [<ffffffff8170b80d>] ? _raw_spin_unlock_irqrestore+0x73/0=
x9e
[  240.040480]  [<ffffffff817063f4>] schedule+0x1b/0x24
[  240.041026]  [<ffffffff81705728>] schedule_timeout+0x180/0x1b6
[  240.041673]  [<ffffffff810beb1d>] ? internal_add_timer+0x7f/0x7f
[  240.042333]  [<ffffffff810ec511>] ? prepare_to_wait_event+0xce/0x12c
[  240.043032]  [<ffffffff8156d487>] cypress_send_ext_cmd+0x204/0x37d
[  240.043732]  [<ffffffff810ebfa0>] ? __wake_up_common+0xa8/0xa8
[  240.044379]  [<ffffffff8156d67c>] cypress_detect+0x20/0x7b
[  240.044983]  [<ffffffff81563917>] psmouse_extensions+0x16c/0x4e8
[  240.045643]  [<ffffffff815641a4>] psmouse_connect+0x262/0x49a
[  240.046277]  [<ffffffff8155246d>] serio_connect_driver+0x3a/0x5e
[  240.046929]  [<ffffffff815524b3>] serio_driver_probe+0x22/0x2b
[  240.047567]  [<ffffffff81476f87>] driver_probe_device+0xde/0x2af
[  240.048228]  [<ffffffff814771ed>] __driver_attach+0x95/0xd3
[  240.048846]  [<ffffffff81477158>] ? driver_probe_device+0x2af/0x2af
[  240.049537]  [<ffffffff81475011>] bus_for_each_dev+0x85/0xcd
[  240.050160]  [<ffffffff8147736a>] driver_attach+0x20/0x29
[  240.050770]  [<ffffffff81552e16>] serio_handle_event+0x1c1/0x2ae
[  240.051451]  [<ffffffff810d12f2>] process_one_work+0x2f2/0x555
[  240.052092]  [<ffffffff810d1270>] ? process_one_work+0x270/0x555
[  240.052772]  [<ffffffff810d1d25>] worker_thread+0x481/0x657
[  240.053391]  [<ffffffff810f3d4a>] ? trace_hardirqs_on+0x1b/0x24
[  240.054036]  [<ffffffff810d18a4>] ? rescuer_thread+0x310/0x310
[  240.054674]  [<ffffffff810da85e>] kthread+0x147/0x156
[  240.055239]  [<ffffffff810e2c2b>] ? finish_task_switch.constprop.51+0x=
44/0x15e
[  240.056018]  [<ffffffff810da717>] ? __kthread_unpark+0x64/0x64
[  240.056661]  [<ffffffff8170cb7a>] ret_from_fork+0x7a/0xb0
[  240.057239]  [<ffffffff810da717>] ? __kthread_unpark+0x64/0x64
[  240.057871] 9 locks held by kworker/0:1/16:
[  240.058343]  #0:  ("events_long"){.+.+.+}, at: [<ffffffff810d1270>] pr=
ocess_one_work+0x270/0x555
[  240.059427]  #1:  (serio_event_work){+.+.+.}, at: [<ffffffff810d1270>]=
 process_one_work+0x270/0x555
[  240.060558]  #2:  (serio_mutex){+.+.+.}, at: [<ffffffff81552c75>] seri=
o_handle_event+0x20/0x2ae
[  240.061634]  #3:  (&dev->mutex){......}, at: [<ffffffff814771b5>] __dr=
iver_attach+0x5d/0xd3
[  240.062670]  #4:  (&dev->mutex){......}, at: [<ffffffff814771ca>] __dr=
iver_attach+0x72/0xd3
[  240.063725]  #5:  (&serio->drv_mutex){+.+.+.}, at: [<ffffffff8155245b>=
] serio_connect_driver+0x28/0x5e
[  240.064871]  #6:  (psmouse_mutex){+.+...}, at: [<ffffffff81563f6e>] ps=
mouse_connect+0x2c/0x49a
[  240.065930]  #7:  (&ps2dev->cmd_mutex){+.+...}, at: [<ffffffff815563a2=
>] ps2_begin_command+0x1a/0x4a
[  240.067061]  #8:  (i8042_mutex){+.+...}, at: [<ffffffff81554d33>] i804=
2_lock_chip+0x19/0x22
[  240.068091] sending NMI to all CPUs:
[  240.068512] NMI backtrace for cpu 0
[  240.068743] CPU: 0 PID: 11 Comm: khungtaskd Not tainted 3.16.0-rc1-000=
45-g52774d9 #1
[  240.068743] task: ffff880013614b00 ti: ffff880013634000 task.ti: ffff8=
80013634000
[  240.068743] RIP: 0010:[<ffffffff8103283f>]  [<ffffffff8103283f>] flat_=
send_IPI_mask+0xc0/0x118
[  240.068743] RSP: 0018:ffff880013637d98  EFLAGS: 00000006
[  240.068743] RAX: 0000000001000000 RBX: 0000000000000206 RCX: 000000000=
0000018
[  240.068743] RDX: ffffffff81c50a60 RSI: 0000000000000002 RDI: 000000000=
0000300
[  240.068743] RBP: ffff880013637db8 R08: 0000000000000001 R09: 000000000=
0000018
[  240.068743] R10: 0000000000000000 R11: 0000000000000002 R12: 000000000=
0000c00
[  240.068743] R13: 0000000000000c00 R14: 0000000000000001 R15: ffff88001=
3643840
[  240.068743] FS:  0000000000000000(0000) GS:ffffffff81c30000(0000) knlG=
S:0000000000000000
[  240.068743] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  240.068743] CR2: ffffffffff600400 CR3: 00000000115dd000 CR4: 000000000=
00006f0
[  240.068743] Stack:
[  240.068743]  0000000000002710 ffff880013643840 0000000000000078 000000=
00000003f0
[  240.068743]  ffff880013637dc8 ffffffff810328b8 ffff880013637de0 ffffff=
ff8102edc0
[  240.068743]  ffff880013643840 ffff880013637e40 ffffffff811369fe ffffff=
ff811365be
[  240.068743] Call Trace:
[  240.068743]  [<ffffffff810328b8>] flat_send_IPI_all+0x21/0x71
[  240.068743]  [<ffffffff8102edc0>] arch_trigger_all_cpu_backtrace+0x6c/=
0xc3
[  240.068743]  [<ffffffff811369fe>] watchdog+0x515/0x739
[  240.068743]  [<ffffffff811365be>] ? watchdog+0xd5/0x739
[  240.068743]  [<ffffffff811364e9>] ? hung_task_panic+0x19/0x19
[  240.068743]  [<ffffffff810da85e>] kthread+0x147/0x156
[  240.068743]  [<ffffffff810e2c2b>] ? finish_task_switch.constprop.51+0x=
44/0x15e
[  240.068743]  [<ffffffff810da717>] ? __kthread_unpark+0x64/0x64
[  240.068743]  [<ffffffff8170cb7a>] ret_from_fork+0x7a/0xb0
[  240.068743]  [<ffffffff810da717>] ? __kthread_unpark+0x64/0x64
[  240.068743] Code: 41 83 fc 02 74 0c 45 09 ec 48 ff 05 3c 45 17 01 eb 1=
1 48 ff 05 3b 45 17 01 41 81 cd 00 04 00 00 45 89 ec 44 89 24 25 00 c3 5f=
 ff <f6> c7 02 75 26 48 ff 05 25 45 17 01 48 89 df 57 9d 0f 1f 44 00=20
[  240.068743] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler)=
 took too long to run: 22.142 msecs
[  240.091726] Kernel panic - not syncing: hung_task: blocked tasks
[  240.091958] CPU: 0 PID: 11 Comm: khungtaskd Not tainted 3.16.0-rc1-000=
45-g52774d9 #1
[  240.091958]  0000000000000000 ffff880013637d68 ffffffff816f498b ffff88=
0013637de0
[  240.091958]  ffffffff816f056b 0000000000000008 ffff880013637df0 ffff88=
0013637d90
[  240.091958]  0000000000000206 ffff880013615120 0000000000000007 000000=
0000000018
[  240.091958] Call Trace:
[  240.091958]  [<ffffffff816f498b>] dump_stack+0x2e/0x3e
[  240.091958]  [<ffffffff816f056b>] panic+0x121/0x2df
[  240.091958]  [<ffffffff81136a13>] watchdog+0x52a/0x739
[  240.091958]  [<ffffffff811365be>] ? watchdog+0xd5/0x739
[  240.091958]  [<ffffffff811364e9>] ? hung_task_panic+0x19/0x19
[  240.091958]  [<ffffffff810da85e>] kthread+0x147/0x156
[  240.091958]  [<ffffffff810e2c2b>] ? finish_task_switch.constprop.51+0x=
44/0x15e
[  240.091958]  [<ffffffff810da717>] ? __kthread_unpark+0x64/0x64
[  240.091958]  [<ffffffff8170cb7a>] ret_from_fork+0x7a/0xb0
[  240.091958]  [<ffffffff810da717>] ? __kthread_unpark+0x64/0x64
[  240.091958] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation ran=
ge: 0xffffffff80000000-0xffffffff9fffffff)
[  240.091958] Rebooting in 10 seconds..
Elapsed time: 245
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconf=
ig-hsxa0-06190120/52774d9273d6b8aff39822ccfe10e5a0d7c3a7f8/vmlinuz-3.16.0=
-rc1-00045-g52774d9 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ra=
m0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06190120=
/linux-devel:devel-hourly-2014061900:52774d9273d6b8aff39822ccfe10e5a0d7c3=
a7f8:bisect-linux3/.vmlinuz-52774d9273d6b8aff39822ccfe10e5a0d7c3a7f8-2014=
0619025632-6-ivb42 branch=3Dlinux-devel/devel-hourly-2014061900 BOOT_IMAG=
E=3D/kernel/x86_64-randconfig-hsxa0-06190120/52774d9273d6b8aff39822ccfe10=
e5a0d7c3a7f8/vmlinuz-3.16.0-rc1-00045-g52774d9 drbd.minor_count=3D8'  -in=
itrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 2 -net nic=
,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -w=
atchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-=
ivb42-53 -serial file:/dev/shm/kboot/serial-yocto-ivb42-53 -daemonize -di=
splay none -monitor null=20


--------------010804010206090604060900
Content-Type: application/octet-stream;
 name="x86_64-randconfig-hsxa0-06190120-91283063c4f74fb202ac7809a8df3cc00f22203e-blocked-for-more-than-----seconds-23032.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="x86_64-randconfig-hsxa0-06190120-91283063c4f74fb202ac7809a8d";
 filename*1="f3cc00f22203e-blocked-for-more-than-----seconds-23032.log"

SEVBRCBpcyBub3cgYXQgOTEyODMwNi4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA2MTkwMCcKZ2l0IGNoZWNrb3V0IDcxNzE1MTFlYWVjNWJmMjNmYjA2MDc4
ZjU5Nzg0YTNhMDYyNmIzOGYKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDYxOTAwOjcxNzE1MTFlYWVjNWJmMjNmYjA2MDc4ZjU5Nzg0YTNhMDYyNmIzOGY6
YmlzZWN0LWxpbnV4MwoKMjAxNC0wNi0xOS0wMTozNjoxNSA3MTcxNTExZWFlYzViZjIzZmIw
NjA3OGY1OTc4NGEzYTA2MjZiMzhmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkw
MTIwLTcxNzE1MTFlYWVjNWJmMjNmYjA2MDc4ZjU5Nzg0YTNhMDYyNmIzOGYKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLzcx
NzE1MTFlYWVjNWJmMjNmYjA2MDc4ZjU5Nzg0YTNhMDYyNmIzOGYKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA2MTkwMTIwLTcxNzE1MTFlYWVjNWJmMjNmYjA2MDc4ZjU5Nzg0YTNhMDYyNmIz
OGYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
Ly54ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC03MTcxNTExZWFlYzViZjIzZmIw
NjA3OGY1OTc4NGEzYTA2MjZiMzhmCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNjE5MDEyMC83MTcxNTExZWFlYzViZjIzZmIwNjA3OGY1OTc4NGEzYTA2MjZi
MzhmL3ZtbGludXotMy4xNi4wLXJjMQoKMjAxNC0wNi0xOS0wMTozOToxNSBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuCTExCTIwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgNzE3MTUx
MWVhZWM1YmYyM2ZiMDYwNzhmNTk3ODRhM2EwNjI2YjM4ZgpnaXQgYmlzZWN0IHN0YXJ0IDkx
MjgzMDYzYzRmNzRmYjIwMmFjNzgwOWE4ZGYzY2MwMGYyMjIwM2UgNzE3MTUxMWVhZWM1YmYy
M2ZiMDYwNzhmNTk3ODRhM2EwNjI2YjM4ZiAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJp
c2VjdDogWyItYiIsICI5MTI4MzA2M2M0Zjc0ZmIyMDJhYzc4MDlhOGRmM2NjMDBmMjIyMDNl
IiwgIi1nIiwgIjcxNzE1MTFlYWVjNWJmMjNmYjA2MDc4ZjU5Nzg0YTNhMDYyNmIzOGYiLCAi
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIvYy9ib290
LWJpc2VjdC9saW51eDMvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogODgzIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKW2JjMTA2YmY2OWZk
ZmJhNjQ5YWQ5OGIzYzdjZmQyYjYzZTg0NDMxYThdIE1lcmdlICdkeW50aWNrcy90aW1lcnMv
bWlzc2luZy1raWNrLXYyJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDYxOTAwCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJp
c2VjdC9saW51eDMvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvbGludXgtZGV2ZWw6ZGV2ZWwt
aG91cmx5LTIwMTQwNjE5MDA6YmMxMDZiZjY5ZmRmYmE2NDlhZDk4YjNjN2NmZDJiNjNlODQ0
MzFhODpiaXNlY3QtbGludXgzCgoyMDE0LTA2LTE5LTAxOjQwOjQ3IGJjMTA2YmY2OWZkZmJh
NjQ5YWQ5OGIzYzdjZmQyYjYzZTg0NDMxYTggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDYxOTAxMjAtYmMxMDZiZjY5ZmRmYmE2NDlhZDk4YjNjN2NmZDJiNjNlODQ0MzFhOApDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAx
MjAvYmMxMDZiZjY5ZmRmYmE2NDlhZDk4YjNjN2NmZDJiNjNlODQ0MzFhOAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDYxOTAxMjAtYmMxMDZiZjY5ZmRmYmE2NDlhZDk4YjNjN2NmZDJiNjNl
ODQ0MzFhOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLWJjMTA2YmY2OWZkZmJh
NjQ5YWQ5OGIzYzdjZmQyYjYzZTg0NDMxYTgKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA2MTkwMTIwL2JjMTA2YmY2OWZkZmJhNjQ5YWQ5OGIzYzdjZmQyYjYz
ZTg0NDMxYTgvdm1saW51ei0zLjE2LjAtcmMxLTAwNTUzLWdiYzEwNmJmCgoyMDE0LTA2LTE5
LTAxOjU1OjQ3IGRldGVjdGluZyBib290IHN0YXRlIC4uCTIwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMzMwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0
ZXBzKQpbMjVmOTJlMDQzZTdlNGNhMDI5NTkyZTAzYTJkNzdhMDlmMjI2ZjM5NV0gTWVyZ2Ug
J2F0OTEvYWJlL2F0OTFfMy4xNi1yYzFfQ0NGJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDYx
OTAwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvYy9ib290LWJpc2VjdC9saW51eDMvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvbGludXgt
ZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNjE5MDA6MjVmOTJlMDQzZTdlNGNhMDI5NTkyZTAz
YTJkNzdhMDlmMjI2ZjM5NTpiaXNlY3QtbGludXgzCgoyMDE0LTA2LTE5LTAxOjU3OjE4IDI1
ZjkyZTA0M2U3ZTRjYTAyOTU5MmUwM2EyZDc3YTA5ZjIyNmYzOTUgY29tcGlsaW5nClF1ZXVl
ZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDYxOTAxMjAtMjVmOTJlMDQzZTdlNGNhMDI5NTkyZTAzYTJkNzdhMDlm
MjI2ZjM5NQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDYxOTAxMjAvMjVmOTJlMDQzZTdlNGNhMDI5NTkyZTAzYTJkNzdhMDlmMjI2ZjM5
NQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAtMjVmOTJlMDQzZTdlNGNhMDI5NTky
ZTAzYTJkNzdhMDlmMjI2ZjM5NQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLTI1
ZjkyZTA0M2U3ZTRjYTAyOTU5MmUwM2EyZDc3YTA5ZjIyNmYzOTUKa2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLzI1ZjkyZTA0M2U3ZTRjYTAyOTU5
MmUwM2EyZDc3YTA5ZjIyNmYzOTUvdm1saW51ei0zLjE2LjAtcmMxLTAwNzA4LWcyNWY5MmUw
CgoyMDE0LTA2LTE5LTAyOjExOjE4IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uIFRF
U1QgRkFJTFVSRQpbICAgNjguMTc2OTA0XSB0b3J0dXJlIHRocmVhZCBsb2NrX3RvcnR1cmVf
d3JpdGVyIHBhcmtpbmcgZHVlIHRvIHN5c3RlbSBzaHV0ZG93bgpbICAxMjAuNDU5MTAxXSBz
cGluX2xvY2stdG9ydHVyZTogV3JpdGVzOiAgVG90YWw6IDIgIE1heC9NaW46IDAvMCAgIEZh
aWw6IDAgClsgIDEyMC40NjAxMTFdIHRvcnR1cmUgdGhyZWFkIGxvY2tfdG9ydHVyZV9zdGF0
cyBwYXJraW5nIGR1ZSB0byBzeXN0ZW0gc2h1dGRvd24KWyAgMjQwLjAyODM1N10gSU5GTzog
dGFzayBrd29ya2VyLzA6MToxNiBibG9ja2VkIGZvciBtb3JlIHRoYW4gMTIwIHNlY29uZHMu
ClsgIDI0MC4wMjkxOTVdICAgICAgIE5vdCB0YWludGVkIDMuMTYuMC1yYzEtMDA3MDgtZzI1
ZjkyZTAgIzEKWyAgMjQwLjAyOTc3MF0gImVjaG8gMCA+IC9wcm9jL3N5cy9rZXJuZWwvaHVu
Z190YXNrX3RpbWVvdXRfc2VjcyIgZGlzYWJsZXMgdGhpcyBtZXNzYWdlLgpbICAyNDAuMDMw
NTg3XSBrd29ya2VyLzA6MSAgICAgRCBmZmZmODgwMDEzNmM5MmMwICAgICAwICAgIDE2ICAg
ICAgMiAweDAwMDAwMDAwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAx
MjAvMjVmOTJlMDQzZTdlNGNhMDI5NTkyZTAzYTJkNzdhMDlmMjI2ZjM5NS9kbWVzZy15b2N0
by1pdmI0MS03NToyMDE0MDYxOTAyMTUxMzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5
MDEyMDozLjE2LjAtcmMxLTAwNzA4LWcyNWY5MmUwOjEKMDoxOjEgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDYtMTkgMDI6MTU6MTkgUkVQRUFUIENPVU5UOiAy
MCAgIyAvYy9ib290LWJpc2VjdC9saW51eDMvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlz
ZWN0aW5nOiAxNTUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDggc3RlcHMpCls2YzgxNWIzNmZkMTNmZDQwZjM1NDVjOWU2ZTMzZWI3ZDRiMzk2ZDhkXSBN
ZXJnZSAnZWZpL25leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNjE5MDAKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDA2MTkwMDo2YzgxNWIzNmZkMTNmZDQwZjM1NDVjOWU2ZTMzZWI3ZDRiMzk2
ZDhkOmJpc2VjdC1saW51eDMKCjIwMTQtMDYtMTktMDI6MTU6MTkgNmM4MTViMzZmZDEzZmQ0
MGYzNTQ1YzllNmUzM2ViN2Q0YjM5NmQ4ZCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NjE5MDEyMC02YzgxNWIzNmZkMTNmZDQwZjM1NDVjOWU2ZTMzZWI3ZDRiMzk2ZDhkCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEy
MC82YzgxNWIzNmZkMTNmZDQwZjM1NDVjOWU2ZTMzZWI3ZDRiMzk2ZDhkCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNjE5MDEyMC02YzgxNWIzNmZkMTNmZDQwZjM1NDVjOWU2ZTMzZWI3ZDRi
Mzk2ZDhkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAtNmM4MTViMzZmZDEzZmQ0
MGYzNTQ1YzllNmUzM2ViN2Q0YjM5NmQ4ZAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDYxOTAxMjAvNmM4MTViMzZmZDEzZmQ0MGYzNTQ1YzllNmUzM2ViN2Q0
YjM5NmQ4ZC92bWxpbnV6LTMuMTYuMC1yYzEtMDA2MjYtZzZjODE1YjMKCjIwMTQtMDYtMTkt
MDI6MTc6MTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6
IDgyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBz
KQpbYTIzNWI4OWUwYjEzMzJiNDRiYWZmNjI3N2I1ZGJjNzExZGYzNGIzZF0gTWVyZ2UgJ2t2
bS1wcGMva3ZtLXBwYy1xdWV1ZScgaW50byBkZXZlbC1ob3VybHktMjAxNDA2MTkwMApydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXgzL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwL2xpbnV4LWRldmVsOmRl
dmVsLWhvdXJseS0yMDE0MDYxOTAwOmEyMzViODllMGIxMzMyYjQ0YmFmZjYyNzdiNWRiYzcx
MWRmMzRiM2Q6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNi0xOS0wMjoxODoyMCBhMjM1Yjg5ZTBi
MTMzMmI0NGJhZmY2Mjc3YjVkYmM3MTFkZjM0YjNkIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA2MTkwMTIwLWEyMzViODllMGIxMzMyYjQ0YmFmZjYyNzdiNWRiYzcxMWRmMzRiM2QK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2
MTkwMTIwL2EyMzViODllMGIxMzMyYjQ0YmFmZjYyNzdiNWRiYzcxMWRmMzRiM2QKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLWEyMzViODllMGIxMzMyYjQ0YmFmZjYyNzdiNWRi
YzcxMWRmMzRiM2QKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC1hMjM1Yjg5ZTBi
MTMzMmI0NGJhZmY2Mjc3YjVkYmM3MTFkZjM0YjNkCmtlcm5lbDogL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC9hMjM1Yjg5ZTBiMTMzMmI0NGJhZmY2Mjc3YjVk
YmM3MTFkZjM0YjNkL3ZtbGludXotMy4xNi4wLXJjMS0wMDY1OS1nYTIzNWI4OQoKMjAxNC0w
Ni0xOS0wMjoyNDoyMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTgJMjAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiA0OSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
NiBzdGVwcykKWzhiNDg3MDg0NmU3MTk2MGEyMjNlNzI5ZTNjMTg5NDJlZGZlODFmMTZdIE1l
cmdlICdzcGkvZm9yLW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNjE5MDAKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC9saW51eC1kZXZlbDpkZXZl
bC1ob3VybHktMjAxNDA2MTkwMDo4YjQ4NzA4NDZlNzE5NjBhMjIzZTcyOWUzYzE4OTQyZWRm
ZTgxZjE2OmJpc2VjdC1saW51eDMKCjIwMTQtMDYtMTktMDI6MjU6NTEgOGI0ODcwODQ2ZTcx
OTYwYTIyM2U3MjllM2MxODk0MmVkZmU4MWYxNiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjE5MDEyMC04YjQ4NzA4NDZlNzE5NjBhMjIzZTcyOWUzYzE4OTQyZWRmZTgxZjE2CkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5
MDEyMC84YjQ4NzA4NDZlNzE5NjBhMjIzZTcyOWUzYzE4OTQyZWRmZTgxZjE2CndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC04YjQ4NzA4NDZlNzE5NjBhMjIzZTcyOWUzYzE4OTQy
ZWRmZTgxZjE2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAtOGI0ODcwODQ2ZTcx
OTYwYTIyM2U3MjllM2MxODk0MmVkZmU4MWYxNgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDYxOTAxMjAvOGI0ODcwODQ2ZTcxOTYwYTIyM2U3MjllM2MxODk0
MmVkZmU4MWYxNi92bWxpbnV6LTMuMTYuMC1yYzEtMDA1ODQtZzhiNDg3MDgKCjIwMTQtMDYt
MTktMDI6NDA6NTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4gVEVTVCBGQUlMVVJF
ClsgICA2Mi4xNzY5NzFdIHRvcnR1cmUgdGhyZWFkIGxvY2tfdG9ydHVyZV93cml0ZXIgcGFy
a2luZyBkdWUgdG8gc3lzdGVtIHNodXRkb3duClsgIDEyMS4yNTYxMjNdIHNwaW5fbG9jay10
b3J0dXJlOiBXcml0ZXM6ICBUb3RhbDogMiAgTWF4L01pbjogMC8wICAgRmFpbDogMCAKWyAg
MTIxLjI1NjkyMl0gdG9ydHVyZSB0aHJlYWQgbG9ja190b3J0dXJlX3N0YXRzIHBhcmtpbmcg
ZHVlIHRvIHN5c3RlbSBzaHV0ZG93bgpbICAyNDAuMDI5MzAzXSBJTkZPOiB0YXNrIGt3b3Jr
ZXIvMDoxOjE2IGJsb2NrZWQgZm9yIG1vcmUgdGhhbiAxMjAgc2Vjb25kcy4KWyAgMjQwLjAz
MDA4MV0gICAgICAgTm90IHRhaW50ZWQgMy4xNi4wLXJjMS0wMDU4NC1nOGI0ODcwOCAjMQpb
ICAyNDAuMDMwNjYxXSAiZWNobyAwID4gL3Byb2Mvc3lzL2tlcm5lbC9odW5nX3Rhc2tfdGlt
ZW91dF9zZWNzIiBkaXNhYmxlcyB0aGlzIG1lc3NhZ2UuClsgIDI0MC4wMzE0ODZdIGt3b3Jr
ZXIvMDoxICAgICBEIGZmZmY4ODAwMTIyZDAwMDAgICAgIDAgICAgMTYgICAgICAyIDB4MDAw
MDAwMDAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC84YjQ4NzA4
NDZlNzE5NjBhMjIzZTcyOWUzYzE4OTQyZWRmZTgxZjE2L2RtZXNnLXF1YW50YWwtaXZiNDEt
ODg6MjAxNDA2MTkwMjQ0NDQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjA6My4x
Ni4wLXJjMS0wMDU4NC1nOGI0ODcwODoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYxOTAxMjAvOGI0ODcwODQ2ZTcxOTYwYTIyM2U3MjllM2MxODk0MmVkZmU4MWYxNi9k
bWVzZy1xdWFudGFsLWl2YjQ0LTExMToyMDE0MDYxOTAyNDQ0Mjp4ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNjE5MDEyMDozLjE2LjAtcmMxLTAwNTg0LWc4YjQ4NzA4OjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC84YjQ4NzA4NDZlNzE5NjBhMjIzZTcy
OWUzYzE4OTQyZWRmZTgxZjE2L2RtZXNnLXF1YW50YWwtaXZiNDQtNzY6MjAxNDA2MTkwMjQ0
NDU6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjA6My4xNi4wLXJjMS0wMDU4NC1n
OGI0ODcwODoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvOGI0
ODcwODQ2ZTcxOTYwYTIyM2U3MjllM2MxODk0MmVkZmU4MWYxNi9kbWVzZy15b2N0by1pdmI0
Mi0xMTA6MjAxNDA2MTkwMjQ0NDg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjA6
My4xNi4wLXJjMS0wMDU4NC1nOGI0ODcwODoxCjA6NDo0IGFsbF9nb29kOmJhZDphbGxfYmFk
IGJvb3RzChtbMTszNW0yMDE0LTA2LTE5IDAyOjQ0OjUyIFJFUEVBVCBDT1VOVDogMjAgICMg
L2MvYm9vdC1iaXNlY3QvbGludXgzL29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGlu
ZzogMjggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3Rl
cHMpClsyMTE1Y2QxMDA4MWVhNjUyMTNiNDVkOTk3MGFlZWJlODhkYWJjZmIzXSBNZXJnZSAn
bWxhbmtob3JzdC9tYXN0ZXInIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNjE5MDAKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC9saW51eC1kZXZlbDpkZXZl
bC1ob3VybHktMjAxNDA2MTkwMDoyMTE1Y2QxMDA4MWVhNjUyMTNiNDVkOTk3MGFlZWJlODhk
YWJjZmIzOmJpc2VjdC1saW51eDMKCjIwMTQtMDYtMTktMDI6NDQ6NTIgMjExNWNkMTAwODFl
YTY1MjEzYjQ1ZDk5NzBhZWViZTg4ZGFiY2ZiMyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjE5MDEyMC0yMTE1Y2QxMDA4MWVhNjUyMTNiNDVkOTk3MGFlZWJlODhkYWJjZmIzCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5
MDEyMC8yMTE1Y2QxMDA4MWVhNjUyMTNiNDVkOTk3MGFlZWJlODhkYWJjZmIzCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC0yMTE1Y2QxMDA4MWVhNjUyMTNiNDVkOTk3MGFlZWJl
ODhkYWJjZmIzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAtMjExNWNkMTAwODFl
YTY1MjEzYjQ1ZDk5NzBhZWViZTg4ZGFiY2ZiMwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDYxOTAxMjAvMjExNWNkMTAwODFlYTY1MjEzYjQ1ZDk5NzBhZWVi
ZTg4ZGFiY2ZiMy92bWxpbnV6LTMuMTYuMC1yYzEtMDA2NzItZzIxMTVjZDEKCjIwMTQtMDYt
MTktMDI6NTE6NTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLiBURVNUIEZBSUxVUkUK
WyAgIDYyLjE3Njk1Ml0gdG9ydHVyZSB0aHJlYWQgbG9ja190b3J0dXJlX3dyaXRlciBwYXJr
aW5nIGR1ZSB0byBzeXN0ZW0gc2h1dGRvd24KWyAgMTIxLjI5NTgxNl0gc3Bpbl9sb2NrLXRv
cnR1cmU6IFdyaXRlczogIFRvdGFsOiAyICBNYXgvTWluOiAwLzAgICBGYWlsOiAwIApbICAx
MjEuMjk2NjI5XSB0b3J0dXJlIHRocmVhZCBsb2NrX3RvcnR1cmVfc3RhdHMgcGFya2luZyBk
dWUgdG8gc3lzdGVtIHNodXRkb3duClsgIDI0MC4wMjkxMDZdIElORk86IHRhc2sga3dvcmtl
ci8wOjE6MTYgYmxvY2tlZCBmb3IgbW9yZSB0aGFuIDEyMCBzZWNvbmRzLgpbICAyNDAuMDI5
ODI0XSAgICAgICBOb3QgdGFpbnRlZCAzLjE2LjAtcmMxLTAwNjcyLWcyMTE1Y2QxICMxClsg
IDI0MC4wMzAzODhdICJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFza190aW1l
b3V0X3NlY3MiIGRpc2FibGVzIHRoaXMgbWVzc2FnZS4KWyAgMjQwLjAzMTE0MF0ga3dvcmtl
ci8wOjEgICAgIEQgZmZmZjg4MDAxMjJkMTJjMCAgICAgMCAgICAxNiAgICAgIDIgMHgwMDAw
MDAwMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLzIxMTVjZDEw
MDgxZWE2NTIxM2I0NWQ5OTcwYWVlYmU4OGRhYmNmYjMvZG1lc2cteW9jdG8taXZiNDEtMTIx
OjIwMTQwNjE5MDI1NTAzOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwOjMuMTYu
MC1yYzEtMDA2NzItZzIxMTVjZDE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA2MTkwMTIwLzIxMTVjZDEwMDgxZWE2NTIxM2I0NWQ5OTcwYWVlYmU4OGRhYmNmYjMvZG1l
c2cteW9jdG8taXZiNDQtOTk6MjAxNDA2MTkwMjU1MDI6eDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYxOTAxMjA6My4xNi4wLXJjMS0wMDY3Mi1nMjExNWNkMToxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvMjExNWNkMTAwODFlYTY1MjEzYjQ1ZDk5NzBh
ZWViZTg4ZGFiY2ZiMy9kbWVzZy1xdWFudGFsLWl2YjQxLTkzOjIwMTQwNjE5MDI1NTAzOng4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwOjMuMTYuMC1yYzEtMDA2NzItZzIxMTVj
ZDE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLzIxMTVjZDEw
MDgxZWE2NTIxM2I0NWQ5OTcwYWVlYmU4OGRhYmNmYjMvZG1lc2cteW9jdG8taXZiNDItMTAw
OjIwMTQwNjE5MDI1NTA3Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwOjMuMTYu
MC1yYzEtMDA2NzItZzIxMTVjZDE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA2MTkwMTIwLzIxMTVjZDEwMDgxZWE2NTIxM2I0NWQ5OTcwYWVlYmU4OGRhYmNmYjMvZG1l
c2cteW9jdG8taXZiNDQtMTEzOjIwMTQwNjE5MDI1NTA0Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA2MTkwMTIwOjMuMTYuMC1yYzEtMDA2NzItZzIxMTVjZDE6MQowOjU6NSBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNi0xOSAwMjo1NToyMyBSRVBFQVQg
Q09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlzZWN0Ly5yZXBlYXQb
WzBtCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSBtbGFua2hvcnN0L21hc3Rl
cgpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNl
Y3Q6IGdpdCBiaXNlY3Qgc3RhcnQgMjExNWNkMTAwODFlYTY1MjEzYjQ1ZDk5NzBhZWViZTg4
ZGFiY2ZiMyBhMjM1Yjg5ZTBiMTMzMmI0NGJhZmY2Mjc3YjVkYmM3MTFkZjM0YjNkIC0tClBy
ZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDIxMTVjZDEuLi4gTWVyZ2UgJ21sYW5raG9yc3Qv
bWFzdGVyJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDYxOTAwCkhFQUQgaXMgbm93IGF0IDU0
YWY2MWQuLi4gTWVyZ2UgYnJhbmNoICdha3BtLWN1cnJlbnQvY3VycmVudCcKQmlzZWN0aW5n
OiA2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBz
KQpbNTI3NzRkOTI3M2Q2YjhhZmYzOTgyMmNjZmUxMGU1YTBkN2MzYTdmOF0gVGhlcmUncyBz
b21lIHJlYWxseSBiYWRseSBicm9rZW4gc29mdHdhcmUgb3V0IHRoZXJlIHRoYXQgaXMgZW50
aXJlbHkKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDMvb2JqLWJp
c2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2MvYm9vdC1iaXNlY3QvbGludXgzL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwL2xpbnV4
LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYxOTAwOjUyNzc0ZDkyNzNkNmI4YWZmMzk4MjJj
Y2ZlMTBlNWEwZDdjM2E3Zjg6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNi0xOS0wMjo1NToyOSA1
Mjc3NGQ5MjczZDZiOGFmZjM5ODIyY2NmZTEwZTVhMGQ3YzNhN2Y4IGNvbXBpbGluZwpRdWV1
ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA2MTkwMTIwLTUyNzc0ZDkyNzNkNmI4YWZmMzk4MjJjY2ZlMTBlNWEw
ZDdjM2E3ZjgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA2MTkwMTIwLzUyNzc0ZDkyNzNkNmI4YWZmMzk4MjJjY2ZlMTBlNWEwZDdjM2E3
ZjgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLTUyNzc0ZDkyNzNkNmI4YWZmMzk4
MjJjY2ZlMTBlNWEwZDdjM2E3ZjgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC01
Mjc3NGQ5MjczZDZiOGFmZjM5ODIyY2NmZTEwZTVhMGQ3YzNhN2Y4Cmtlcm5lbDogL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC81Mjc3NGQ5MjczZDZiOGFmZjM5
ODIyY2NmZTEwZTVhMGQ3YzNhN2Y4L3ZtbGludXotMy4xNi4wLXJjMS0wMDA0NS1nNTI3NzRk
OQoKMjAxNC0wNi0xOS0wMjo1NzoyOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uIFRF
U1QgRkFJTFVSRQpbICAgNjIuMTc2ODQ1XSB0b3J0dXJlIHRocmVhZCBsb2NrX3RvcnR1cmVf
d3JpdGVyIHBhcmtpbmcgZHVlIHRvIHN5c3RlbSBzaHV0ZG93bgpbICAxMjEuMjM1MzU1XSBz
cGluX2xvY2stdG9ydHVyZTogV3JpdGVzOiAgVG90YWw6IDIgIE1heC9NaW46IDAvMCAgIEZh
aWw6IDAgClsgIDEyMS4yMzYxOTZdIHRvcnR1cmUgdGhyZWFkIGxvY2tfdG9ydHVyZV9zdGF0
cyBwYXJraW5nIGR1ZSB0byBzeXN0ZW0gc2h1dGRvd24KWyAgMjQwLjAyOTU2MV0gSU5GTzog
dGFzayBrd29ya2VyLzA6MToxNiBibG9ja2VkIGZvciBtb3JlIHRoYW4gMTIwIHNlY29uZHMu
ClsgIDI0MC4wMzAzNjJdICAgICAgIE5vdCB0YWludGVkIDMuMTYuMC1yYzEtMDAwNDUtZzUy
Nzc0ZDkgIzEKWyAgMjQwLjAzMDk3MV0gImVjaG8gMCA+IC9wcm9jL3N5cy9rZXJuZWwvaHVu
Z190YXNrX3RpbWVvdXRfc2VjcyIgZGlzYWJsZXMgdGhpcyBtZXNzYWdlLgpbICAyNDAuMDMx
ODIyXSBrd29ya2VyLzA6MSAgICAgRCBmZmZmODgwMDEyMDYzODQwICAgICAwICAgIDE2ICAg
ICAgMiAweDAwMDAwMDAwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAx
MjAvNTI3NzRkOTI3M2Q2YjhhZmYzOTgyMmNjZmUxMGU1YTBkN2MzYTdmOC9kbWVzZy1xdWFu
dGFsLWl2YjQxLTQ1OjIwMTQwNjE5MDMwMDQ4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2
MTkwMTIwOjMuMTYuMC1yYzEtMDAwNDUtZzUyNzc0ZDk6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA2MTkwMTIwLzUyNzc0ZDkyNzNkNmI4YWZmMzk4MjJjY2ZlMTBlNWEw
ZDdjM2E3ZjgvZG1lc2ctcXVhbnRhbC1pdmI0NC01NjoyMDE0MDYxOTAzMDA0NTp4ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMDozLjE2LjAtcmMxLTAwMDQ1LWc1Mjc3NGQ5OjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC81Mjc3NGQ5MjczZDZi
OGFmZjM5ODIyY2NmZTEwZTVhMGQ3YzNhN2Y4L2RtZXNnLXlvY3RvLWl2YjQyLTE1OjIwMTQw
NjE5MDMwMDQ5Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwOjMuMTYuMC1yYzEt
MDAwNDUtZzUyNzc0ZDk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkw
MTIwLzUyNzc0ZDkyNzNkNmI4YWZmMzk4MjJjY2ZlMTBlNWEwZDdjM2E3ZjgvZG1lc2cteW9j
dG8taXZiNDItNTU6MjAxNDA2MTkwMzAwNDg6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYx
OTAxMjA6My4xNi4wLXJjMS0wMDA0NS1nNTI3NzRkOToxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDYxOTAxMjAvNTI3NzRkOTI3M2Q2YjhhZmYzOTgyMmNjZmUxMGU1YTBk
N2MzYTdmOC9kbWVzZy1xdWFudGFsLWl2YjQxLTc1OjIwMTQwNjE5MDMwMDQ5Ong4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwOjMuMTYuMC1yYzEtMDAwNDUtZzUyNzc0ZDk6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLzUyNzc0ZDkyNzNkNmI4
YWZmMzk4MjJjY2ZlMTBlNWEwZDdjM2E3ZjgvZG1lc2ctcXVhbnRhbC1pdmI0Mi0xMjU6MjAx
NDA2MTkwMzAxMDA6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjA6My4xNi4wLXJj
MS0wMDA0NS1nNTI3NzRkOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYx
OTAxMjAvNTI3NzRkOTI3M2Q2YjhhZmYzOTgyMmNjZmUxMGU1YTBkN2MzYTdmOC9kbWVzZy1x
dWFudGFsLWl2YjQ0LTEwODoyMDE0MDYxOTAzMDA1MDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjE5MDEyMDozLjE2LjAtcmMxLTAwMDQ1LWc1Mjc3NGQ5OjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC81Mjc3NGQ5MjczZDZiOGFmZjM5ODIyY2NmZTEw
ZTVhMGQ3YzNhN2Y4L2RtZXNnLXF1YW50YWwtaXZiNDQtNTg6MjAxNDA2MTkwMzAwNTA6eDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjA6My4xNi4wLXJjMS0wMDA0NS1nNTI3NzRk
OToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvNTI3NzRkOTI3
M2Q2YjhhZmYzOTgyMmNjZmUxMGU1YTBkN2MzYTdmOC9kbWVzZy15b2N0by1pdmI0MS05Nzoy
MDE0MDYxOTAzMDA1ODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMDozLjE2LjAt
cmMxLTAwMDQ1LWc1Mjc3NGQ5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NjE5MDEyMC81Mjc3NGQ5MjczZDZiOGFmZjM5ODIyY2NmZTEwZTVhMGQ3YzNhN2Y4L2RtZXNn
LXlvY3RvLWl2YjQyLTU4OjIwMTQwNjE5MDMwMDU2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA2MTkwMTIwOjMuMTYuMC1yYzEtMDAwNDUtZzUyNzc0ZDk6MQowOjEwOjQgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzBkYTJiODAwZWM4ZGZhZDc4Yzg4OGIz
M2JlMmFkMmFlYTM0MTE3OTZdIE1lcmdlIGJyYW5jaCAnZm9yLW5vdXZlYXUnCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJp
c2VjdC9saW51eDMvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvbGludXgtZGV2ZWw6ZGV2ZWwt
aG91cmx5LTIwMTQwNjE5MDA6MGRhMmI4MDBlYzhkZmFkNzhjODg4YjMzYmUyYWQyYWVhMzQx
MTc5NjpiaXNlY3QtbGludXgzCgoyMDE0LTA2LTE5LTAzOjAxOjAwIDBkYTJiODAwZWM4ZGZh
ZDc4Yzg4OGIzM2JlMmFkMmFlYTM0MTE3OTYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDYxOTAxMjAtMGRhMmI4MDBlYzhkZmFkNzhjODg4YjMzYmUyYWQyYWVhMzQxMTc5NgpDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAx
MjAvMGRhMmI4MDBlYzhkZmFkNzhjODg4YjMzYmUyYWQyYWVhMzQxMTc5Ngp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDYxOTAxMjAtMGRhMmI4MDBlYzhkZmFkNzhjODg4YjMzYmUyYWQyYWVh
MzQxMTc5Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLTBkYTJiODAwZWM4ZGZh
ZDc4Yzg4OGIzM2JlMmFkMmFlYTM0MTE3OTYKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA2MTkwMTIwLzBkYTJiODAwZWM4ZGZhZDc4Yzg4OGIzM2JlMmFkMmFl
YTM0MTE3OTYvdm1saW51ei0zLjE2LjAtcmMxLTAwMDAzLWcwZGEyYjgwCgoyMDE0LTA2LTE5
LTAzOjA1OjAwIGRldGVjdGluZyBib290IHN0YXRlIC4JMTcJMjAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0
ZXApCltjMDMzMzlmZmEzZDlkMjMzMGM4YzE0YjhkNzNlOWE0ZGEzODEwMWVhXSBkcm0vbm91
dmVhdTogYWRkIGd1YXJkIHBhZ2VzIHRvIHZtCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDMvb2JqLWJp
c2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDYxOTAxMjAvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNjE5MDA6
YzAzMzM5ZmZhM2Q5ZDIzMzBjOGMxNGI4ZDczZTlhNGRhMzgxMDFlYTpiaXNlY3QtbGludXgz
CgoyMDE0LTA2LTE5LTAzOjA2OjMxIGMwMzMzOWZmYTNkOWQyMzMwYzhjMTRiOGQ3M2U5YTRk
YTM4MTAxZWEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAtYzAzMzM5ZmZh
M2Q5ZDIzMzBjOGMxNGI4ZDczZTlhNGRhMzgxMDFlYQpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvYzAzMzM5ZmZhM2Q5ZDIz
MzBjOGMxNGI4ZDczZTlhNGRhMzgxMDFlYQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAx
MjAtYzAzMzM5ZmZhM2Q5ZDIzMzBjOGMxNGI4ZDczZTlhNGRhMzgxMDFlYQprZXJuZWw6IC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvYzAzMzM5ZmZhM2Q5ZDIz
MzBjOGMxNGI4ZDczZTlhNGRhMzgxMDFlYS92bWxpbnV6LTMuMTYuMC1yYzEtMDAwNDQtZ2Mw
MzMzOWYKCjIwMTQtMDYtMTktMDM6MDc6MzEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JOQky
MCBTVUNDRVNTCgo1Mjc3NGQ5MjczZDZiOGFmZjM5ODIyY2NmZTEwZTVhMGQ3YzNhN2Y4IGlz
IHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCA1Mjc3NGQ5MjczZDZiOGFmZjM5ODIyY2Nm
ZTEwZTVhMGQ3YzNhN2Y4CkF1dGhvcjogTWFhcnRlbiBMYW5raG9yc3QgPG0uYi5sYW5raG9y
c3RAZ21haWwuY29tPgpEYXRlOiAgIFRodSBKYW4gMTYgMTY6MjQ6MDQgMjAxNCArMDEwMAoK
ICAgIFRoZXJlJ3Mgc29tZSByZWFsbHkgYmFkbHkgYnJva2VuIHNvZnR3YXJlIG91dCB0aGVy
ZSB0aGF0IGlzIGVudGlyZWx5CiAgICAKICAgIGRlcGVuZGFudCBvbiBIWiBmb3IgaXRzIG1h
eGltdW0gcGVyZm9ybWFuY2UuIFJhaXNlIHRoZSBtYXhpbXVtIEhaIHZhbHVlCiAgICB0byBz
b21lIGhpZ2hlciBhbmQgc2xpZ2h0bHkgdW5yZWFzb25hYmxlIHZhbHVlcyB1cCB0byBzb21l
IGhpZ2hlciBhbmQKICAgIGNvbXBsZXRlbHkgb2JzY2VuZSB2YWx1ZXMuCiAgICAKICAgIC1j
awoKOjA0MDAwMCAwNDAwMDAgYzI4NTkyYWU3ZGUyNTMwOWQ2MmIzYjU3MjkzMGI0YzIzMzNk
ODFiMSA5YmNiZDU1ZTg5NjE3ZWZiZDk4ZGI0NjVjYWY0NDUwNTEyYTE0Mzk4IE0JYXJjaAo6
MDQwMDAwIDA0MDAwMCAxMTU0ZjBjNDRiMDFjZGM2Nzc0Yzg5MDhjYmI5OTZiYzZiMmZiMjlj
IDY5YWIwYWFmZTA2NTA3OWUwMzA4ODI0NmEyNjE0YjYwY2YxM2IzYzkgTQlkcml2ZXJzCjow
NDAwMDAgMDQwMDAwIDgyZGE3ODFlYzA2NGVkY2UzNmMyZjk1N2EwMmUyNjEyNzFlZWQ3OTgg
ZmNhMjZjM2RkNzNkNzg1ZmI1Mjg0MmZhZmZmMGMwYWU4Y2FlMjRmZiBNCWluY2x1ZGUKOjA0
MDAwMCAwNDAwMDAgOGZlOTVjMDY1ZTZlOWExMjIxZTc4ZWMwNDNmZTc2MTgzYzNjZDZkNiA5
ZDFiYTIwMzRhMTA4MzlhZmQxNzVkOGJhNDRlM2E0NDYzOTYzYjEwIE0JaW5pdAo6MDQwMDAw
IDA0MDAwMCA1ZDg0ODdlOGY1MDlkZmY5NGZjYzdiNzkxNzY1ZGU2YzhkYzkzNWM1IDE1NGM0
ZGRmM2ZmM2JlYjQwYjJmNDA1MGQ3ZDI4NTQxYmNmYzFlNWEgTQlrZXJuZWwKYmlzZWN0IHJ1
biBzdWNjZXNzCkhFQUQgaXMgbm93IGF0IGMwMzMzOWYuLi4gZHJtL25vdXZlYXU6IGFkZCBn
dWFyZCBwYWdlcyB0byB2bQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5
LTIwMTQwNjE5MDA6YzAzMzM5ZmZhM2Q5ZDIzMzBjOGMxNGI4ZDczZTlhNGRhMzgxMDFlYTpi
aXNlY3QtbGludXgzCgoyMDE0LTA2LTE5LTAzOjA5OjMxIGMwMzMzOWZmYTNkOWQyMzMwYzhj
MTRiOGQ3M2U5YTRkYTM4MTAxZWEgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNjE5MDEyMC9jMDMzMzlmZmEzZDlkMjMzMGM4YzE0YjhkNzNlOWE0ZGEzODEwMWVh
L3ZtbGludXotMy4xNi4wLXJjMS0wMDA0NC1nYzAzMzM5ZgoKMjAxNC0wNi0xOS0wMzowOToz
MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkyMwk1Nwk2MCBTVUNDRVNTCgpQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyBjMDMzMzlmLi4uIGRybS9ub3V2ZWF1OiBhZGQgZ3VhcmQgcGFn
ZXMgdG8gdm0KSEVBRCBpcyBub3cgYXQgOTEyODMwNi4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9y
ICdkZXZlbC1ob3VybHktMjAxNDA2MTkwMCcKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwL2xpbnV4LWRldmVsOmRl
dmVsLWhvdXJseS0yMDE0MDYxOTAwOjkxMjgzMDYzYzRmNzRmYjIwMmFjNzgwOWE4ZGYzY2Mw
MGYyMjIwM2U6YmlzZWN0LWxpbnV4MwogVEVTVCBGQUlMVVJFClsgICA2My4xNzY5ODhdIHRv
cnR1cmUgdGhyZWFkIGxvY2tfdG9ydHVyZV93cml0ZXIgcGFya2luZyBkdWUgdG8gc3lzdGVt
IHNodXRkb3duClsgIDEyMS40NDgzMTldIHNwaW5fbG9jay10b3J0dXJlOiBXcml0ZXM6ICBU
b3RhbDogMiAgTWF4L01pbjogMC8wICAgRmFpbDogMCAKWyAgMTIxLjQ0OTA2OF0gdG9ydHVy
ZSB0aHJlYWQgbG9ja190b3J0dXJlX3N0YXRzIHBhcmtpbmcgZHVlIHRvIHN5c3RlbSBzaHV0
ZG93bgpbICAyNDAuMDMxNTU5XSBJTkZPOiB0YXNrIGt3b3JrZXIvMDoxOjE2IGJsb2NrZWQg
Zm9yIG1vcmUgdGhhbiAxMjAgc2Vjb25kcy4KWyAgMjQwLjAzMjM3NV0gICAgICAgTm90IHRh
aW50ZWQgMy4xNi4wLXJjMS13bC0wMDg4My1nOTEyODMwNiAjNApbICAyNDAuMDMzMDM3XSAi
ZWNobyAwID4gL3Byb2Mvc3lzL2tlcm5lbC9odW5nX3Rhc2tfdGltZW91dF9zZWNzIiBkaXNh
YmxlcyB0aGlzIG1lc3NhZ2UuClsgIDI0MC4wMzM5MzFdIGt3b3JrZXIvMDoxICAgICBEIGZm
ZmY4ODAwMTIyZDAwMDAgICAgIDAgICAgMTYgICAgICAyIDB4MDAwMDAwMDAKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC85MTI4MzA2M2M0Zjc0ZmIyMDJhYzc4
MDlhOGRmM2NjMDBmMjIyMDNlL2RtZXNnLXlvY3RvLWl2YjQxLTgzOjIwMTQwNjE5MDEzNjA1
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwOjMuMTYuMC1yYzEtd2wtMDA4ODMt
ZzkxMjgzMDY6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLzkx
MjgzMDYzYzRmNzRmYjIwMmFjNzgwOWE4ZGYzY2MwMGYyMjIwM2UvZG1lc2cteW9jdG8taXZi
NDEtNTM6MjAxNDA2MTkwMTM2MDA6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjA6
My4xNi4wLXJjMS13bC0wMDg4My1nOTEyODMwNjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDYxOTAxMjAvOTEyODMwNjNjNGY3NGZiMjAyYWM3ODA5YThkZjNjYzAwZjIy
MjAzZS9kbWVzZy1xdWFudGFsLWl2YjQxLTI2OjIwMTQwNjE5MDEzNjA1Ong4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA2MTkwMTIwOjMuMTYuMC1yYzEtd2wtMDA4ODMtZzkxMjgzMDY6NAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLzkxMjgzMDYzYzRmNzRm
YjIwMmFjNzgwOWE4ZGYzY2MwMGYyMjIwM2UvZG1lc2cteW9jdG8taXZiNDItNjk6MjAxNDA2
MTkwMTI3MTY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjA6My4xNi4wLXJjMS13
bC0wMDg4My1nOTEyODMwNjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYx
OTAxMjAvOTEyODMwNjNjNGY3NGZiMjAyYWM3ODA5YThkZjNjYzAwZjIyMjAzZS9kbWVzZy15
b2N0by1pdmI0NC0xMjI6MjAxNDA2MTkwMTM2MDQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDYxOTAxMjA6My4xNi4wLXJjMS13bC0wMDg4My1nOTEyODMwNjo0Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvOTEyODMwNjNjNGY3NGZiMjAyYWM3ODA5YThk
ZjNjYzAwZjIyMjAzZS9kbWVzZy15b2N0by1pdmI0MS0xMzoyMDE0MDYxOTAxMzYwNTp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMDozLjE2LjAtcmMxLXdsLTAwODgzLWc5MTI4
MzA2OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC85MTI4MzA2
M2M0Zjc0ZmIyMDJhYzc4MDlhOGRmM2NjMDBmMjIyMDNlL2RtZXNnLXlvY3RvLWl2YjQxLTc6
MjAxNDA2MTkwMTM2MDA6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjA6My4xNi4w
LXJjMS13bC0wMDg4My1nOTEyODMwNjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYxOTAxMjAvOTEyODMwNjNjNGY3NGZiMjAyYWM3ODA5YThkZjNjYzAwZjIyMjAzZS9k
bWVzZy1xdWFudGFsLWl2YjQ0LTQ6MjAxNDA2MTkwMTM2MDQ6eDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDYxOTAxMjA6My4xNi4wLXJjMS13bC0wMDg4My1nOTEyODMwNjo0Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvOTEyODMwNjNjNGY3NGZiMjAyYWM3
ODA5YThkZjNjYzAwZjIyMjAzZS9kbWVzZy15b2N0by1pdmI0Mi0xMDg6MjAxNDA2MTkwMTM2
MDc6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjA6My4xNi4wLXJjMS13bC0wMDg4
My1nOTEyODMwNjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAv
OTEyODMwNjNjNGY3NGZiMjAyYWM3ODA5YThkZjNjYzAwZjIyMjAzZS9kbWVzZy15b2N0by1p
dmI0MS03MToyMDE0MDYxOTAxMjcxNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEy
MDozLjE2LjAtcmMxLXdsLTAwODgzLWc5MTI4MzA2OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNjE5MDEyMC85MTI4MzA2M2M0Zjc0ZmIyMDJhYzc4MDlhOGRmM2NjMDBm
MjIyMDNlL2RtZXNnLXlvY3RvLWl2YjQ0LTk0OjIwMTQwNjE5MDEzNjA0Ong4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA2MTkwMTIwOjMuMTYuMC1yYzEtd2wtMDA4ODMtZzkxMjgzMDY6NAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLzkxMjgzMDYzYzRmNzRm
YjIwMmFjNzgwOWE4ZGYzY2MwMGYyMjIwM2UvZG1lc2ctcXVhbnRhbC1pdmI0Mi0xNDoyMDE0
MDYxOTAxMjcxNTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMDozLjE2LjAtcmMx
LXdsLTAwODgzLWc5MTI4MzA2OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NjE5MDEyMC85MTI4MzA2M2M0Zjc0ZmIyMDJhYzc4MDlhOGRmM2NjMDBmMjIyMDNlL2RtZXNn
LXF1YW50YWwtaXZiNDQtNzQ6MjAxNDA2MTkwMTM2MDQ6eDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYxOTAxMjA6My4xNi4wLXJjMS13bC0wMDg4My1nOTEyODMwNjo0CjA6MTM6MTMgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkhFQUQgaXMgbm93IGF0IDkxMjgzMDYgMGRheSBo
ZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQwNjE5MDAnCgo9PT09PT09PT0gdXBz
dHJlYW0gPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDkxMjgzMDYuLi4g
MGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQwNjE5MDAnCkhFQUQgaXMg
bm93IGF0IGU5OWNmYTIuLi4gTWVyZ2UgdGFnICdkdC1maXhlcy1mb3ItMy4xNicgb2YgZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3JvYmgvbGludXgK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA2MTkwMTIwL2xpbnVzOm1hc3RlcjplOTljZmEyZDA2MzQ4ODFiOGE0MWQ1NmM0OGI1
OTU2YjlhM2JhMTYyOmJpc2VjdC1saW51eDMKCjIwMTQtMDYtMTktMDM6MTI6MDQgZTk5Y2Zh
MmQwNjM0ODgxYjhhNDFkNTZjNDhiNTk1NmI5YTNiYTE2MiBjb21waWxpbmcKUXVldWVkIGJ1
aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNjE5MDEyMC1lOTljZmEyZDA2MzQ4ODFiOGE0MWQ1NmM0OGI1OTU2YjlhM2Jh
MTYyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjE5MDEyMC9lOTljZmEyZDA2MzQ4ODFiOGE0MWQ1NmM0OGI1OTU2YjlhM2JhMTYyCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjE5MDEyMC1lOTljZmEyZDA2MzQ4ODFiOGE0MWQ1NmM0
OGI1OTU2YjlhM2JhMTYyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAtZTk5Y2Zh
MmQwNjM0ODgxYjhhNDFkNTZjNDhiNTk1NmI5YTNiYTE2MgprZXJuZWw6IC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvZTk5Y2ZhMmQwNjM0ODgxYjhhNDFkNTZj
NDhiNTk1NmI5YTNiYTE2Mi92bWxpbnV6LTMuMTYuMC1yYzEtMDAwMTctZ2U5OWNmYTIKCjIw
MTQtMDYtMTktMDM6NDg6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxNAkyNgk0NQk2MCBT
VUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09CkZyb20gZ2l0Oi8vZ2l0
bWlycm9yL25leHQKICsgOGNmYTIxZC4uLjUyMjQ3NGEgYWtwbSAgICAgICAtPiBuZXh0L2Fr
cG0gIChmb3JjZWQgdXBkYXRlKQogKyBmYTdlNzkwLi4uMGE5ZDJmYSBha3BtLWJhc2UgIC0+
IG5leHQvYWtwbS1iYXNlICAoZm9yY2VkIHVwZGF0ZSkKICsgNWYyOTVjZC4uLjRjYTFmYmMg
bWFzdGVyICAgICAtPiBuZXh0L21hc3RlciAgKGZvcmNlZCB1cGRhdGUpCiAgIDcxNzE1MTEu
LmViZTA2MTggIHN0YWJsZSAgICAgLT4gbmV4dC9zdGFibGUKRnJvbSBnaXQ6Ly9naXRtaXJy
b3IvbmV4dAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNjE4IC0+IG5leHQtMjAx
NDA2MTgKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZTk5Y2ZhMi4uLiBNZXJnZSB0YWcg
J2R0LWZpeGVzLWZvci0zLjE2JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvcm9iaC9saW51eApIRUFEIGlzIG5vdyBhdCA0Y2ExZmJjLi4uIEFk
ZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDYxOApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAv
bmV4dDptYXN0ZXI6NGNhMWZiYzEyMmZjYjA5ZWZhMmJiMTQ0OGJmZjhiNzFiNDY0MzRjODpi
aXNlY3QtbGludXgzCgoyMDE0LTA2LTE5LTAzOjUwOjUyIDRjYTFmYmMxMjJmY2IwOWVmYTJi
YjE0NDhiZmY4YjcxYjQ2NDM0YzggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAx
MjAtNGNhMWZiYzEyMmZjYjA5ZWZhMmJiMTQ0OGJmZjhiNzFiNDY0MzRjOApDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYxOTAxMjAvNGNh
MWZiYzEyMmZjYjA5ZWZhMmJiMTQ0OGJmZjhiNzFiNDY0MzRjOAp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWct
aHN4YTAtMDYxOTAxMjAtNGNhMWZiYzEyMmZjYjA5ZWZhMmJiMTQ0OGJmZjhiNzFiNDY0MzRj
OAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
Lng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MTkwMTIwLTRjYTFmYmMxMjJmY2IwOWVmYTJi
YjE0NDhiZmY4YjcxYjQ2NDM0YzgKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA2MTkwMTIwLzRjYTFmYmMxMjJmY2IwOWVmYTJiYjE0NDhiZmY4YjcxYjQ2NDM0
Yzgvdm1saW51ei0zLjE2LjAtcmMxLW5leHQtMjAxNDA2MTgKCjIwMTQtMDYtMTktMDQ6MDM6
NTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMTkJNjAgU1VDQ0VTUwoK
--------------010804010206090604060900
Content-Type: text/plain; charset=UTF-8;
 name="config-3.16.0-rc1-00045-g52774d9"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.16.0-rc1-00045-g52774d9"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.16.0-rc1 Kernel Configuration
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
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
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
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
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
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
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_USER_NS=y
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
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_UPROBES is not set
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_X2APIC=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_X86_16BIT is not set
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
# CONFIG_HZ_1500 is not set
# CONFIG_HZ_2000 is not set
# CONFIG_HZ_3000 is not set
CONFIG_HZ_4000=y
# CONFIG_HZ_5000 is not set
# CONFIG_HZ_7500 is not set
# CONFIG_HZ_10000 is not set
CONFIG_HZ=4000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_HOTPLUG_MEMORY=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
# CONFIG_CPU_IDLE_GOV_LADDER is not set
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
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
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
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y

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
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
# CONFIG_MTD_CFI_GEOMETRY is not set
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
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=y
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_SPI_NOR=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29020=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=y

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
CONFIG_GENWQE=y
CONFIG_ECHO=y
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
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=y

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

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
# CONFIG_KEYBOARD_ST_KEYSCAN is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
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
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
# CONFIG_SERIO_OLPC_APSP is not set
# CONFIG_GAMEPORT is not set

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
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
# CONFIG_SERIAL_SH_SCI is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EFM32=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RIIC is not set
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
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
CONFIG_SPI_ATMEL=y
CONFIG_SPI_BCM2835=y
CONFIG_SPI_BCM63XX_HSSPI=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_CLPS711X=y
CONFIG_SPI_EP93XX=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_IMX=y
CONFIG_SPI_FSL_DSPI=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_TI_QSPI is not set
CONFIG_SPI_OMAP_100K=y
CONFIG_SPI_ORION=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_SH=y
# CONFIG_SPI_SH_HSPI is not set
# CONFIG_SPI_SUN4I is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_TXX9=y
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_XTENSA_XTFPGA=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MC33880 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_JANZ_TTL is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_MXC=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
# CONFIG_RCAR_THERMAL is not set
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_XILINX_WATCHDOG=y
# CONFIG_DW_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=y
# CONFIG_TEGRA_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=y
CONFIG_GEODE_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=y
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LTC3589=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PBIAS is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_S2MPA01=y
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS80031 is not set
CONFIG_REGULATOR_WM831X=y
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
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
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
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
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
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=y
CONFIG_FB_INTEL_DEBUG=y
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
# CONFIG_LCD_LD9040 is not set
CONFIG_LCD_AMS369FG06=y
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_OT200=y
CONFIG_BACKLIGHT_TPS65217=y
# CONFIG_BACKLIGHT_AS3711 is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
# CONFIG_SND_PCM_XRUN_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
CONFIG_SND_ALOOP=y
CONFIG_SND_MTPAV=y
CONFIG_SND_SERIAL_U16550=y
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PCI is not set

#
# HD-Audio
#
CONFIG_SND_SPI=y
CONFIG_SND_AT73C213=y
CONFIG_SND_AT73C213_TARGET_BITRATE=48000
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_KEYSTONE_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_OMAP_HS is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_USDHI6ROL0=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

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
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_DELL_NETBOOKS=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VFIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
CONFIG_ALIENWARE_WMI=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
CONFIG_DELL_SMO8800=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=y
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
# CONFIG_INTEL_RST is not set
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
CONFIG_SH_TIMER_MTU2=y
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_DMAR_TABLE=y
# CONFIG_INTEL_IOMMU is not set
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_MAX77693 is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_OMAP_CONTROL_PHY is not set
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=y
CONFIG_MCB_PCI=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
# CONFIG_SYSFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
# CONFIG_UBIFS_FS_ZLIB is not set
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
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
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
CONFIG_CRYPTO_ABLK_HELPER=y
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
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
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
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set


--------------010804010206090604060900
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

_______________________________________________
LKP mailing list
LKP@linux.intel.com


--------------010804010206090604060900--
