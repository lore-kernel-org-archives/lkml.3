Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaI3H7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:59:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:38244 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaI3H7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:59:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393436135"
Date: Tue, 30 Sep 2014 15:59:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [x86, kvm] WARNING: at arch/x86/kernel/pvclock.c:182
 pvclock_init_vsyscall()
Message-ID: <20140930075927.GC9561@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qtZFehHsKgwS5rPz"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

commit 3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a
Author:     Marcelo Tosatti <mtosatti@redhat.com>
AuthorDate: Tue Nov 27 23:28:56 2012 -0200
Commit:     Marcelo Tosatti <mtosatti@redhat.com>
CommitDate: Tue Nov 27 23:29:10 2012 -0200

    x86: kvm guest: pvclock vsyscall support
    
    Hook into generic pvclock vsyscall code, with the aim to
    allow userspace to have visibility into pvclock data.
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

+--------------------------------------------------------------+------------+------------+------------+
|                                                              | 71056ae22d | 3dc4f7cfb7 | d778df51c0 |
+--------------------------------------------------------------+------------+------------+------------+
| boot_successes                                               | 141        | 0          | 0          |
| boot_failures                                                | 0          | 47         | 11         |
| WARNING:at_arch/x86/kernel/pvclock.c:pvclock_init_vsyscall() | 0          | 47         | 11         |
| backtrace:pvclock_init_vsyscall                              | 0          | 47         | 11         |
| backtrace:warn_slowpath_null                                 | 0          | 47         | 11         |
| backtrace:kvm_setup_vsyscall_timeinfo                        | 0          | 47         | 11         |
| backtrace:kvm_guest_init                                     | 0          | 47         | 11         |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=    | 0          | 0          | 7          |
| BUG:kernel_boot_hang                                         | 0          | 0          | 4          |
+--------------------------------------------------------------+------------+------------+------------+

[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/pvclock.c:182 pvclock_init_vsyscall+0x41/0x8e()
[    0.000000] Hardware name: Standard PC (i440FX + PIIX, 1996)
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.7.0-rc3-00112-g3dc4f7c #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8104f750>] warn_slowpath_common+0x70/0xa0
[    0.000000]  [<ffffffff8104f83a>] warn_slowpath_null+0x1a/0x20
[    0.000000]  [<ffffffff8219a6af>] pvclock_init_vsyscall+0x41/0x8e
[    0.000000]  [<ffffffff8219a623>] kvm_setup_vsyscall_timeinfo+0x48/0x78
[    0.000000]  [<ffffffff8219a397>] kvm_guest_init+0x98/0xe1
[    0.000000]  [<ffffffff82190eb8>] setup_arch+0xa9b/0xb10
[    0.000000]  [<ffffffff818eeae8>] ? printk+0x4f/0x57
[    0.000000]  [<ffffffff8218e856>] start_kernel+0x93/0x388
[    0.000000]  [<ffffffff8218e120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff8218e2b4>] x86_64_start_reservations+0xb0/0xb3
[    0.000000]  [<ffffffff8218e3b9>] x86_64_start_kernel+0x102/0x10f
[    0.000000] ---[ end trace c9f7d63dd24af7e7 ]---
[    0.000000] KVM setup async PF for cpu 0

git bisect start v3.8 v3.7 --
git bisect  bad 8d91a42e54eebc43f4d8f6064751ccba73528275  # 21:30      0-      5  Merge tag 'omap-late-cleanups' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect  bad 770b6cb4d21fb3e3df2a7a51e186a3c14db1ec30  # 21:35      0-      1  ARM: OMAP: Fix drivers to depend on omap for internal devices
git bisect good 9977d9b379cb77e0f67bd6f4563618106e58e11d  # 21:40     30+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal
git bisect  bad e777d192ffb9f2929d547a2f8a5f65b7db7a9552  # 21:44      4-     26  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect good 8b0cab14951fbf8126795ab301835a8f8126a988  # 22:00     30+      0  Merge tag 'regulator-3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
git bisect good c7708fac5a878d6e0f2de0aa19f9749cff4f707f  # 22:11     30+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect  bad e05a1c6397a73d09389e033b6b2c25c954d2177c  # 22:17      0-      1  Merge tag 'ktest-v3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest
git bisect good 896ea17d3da5f44b2625c9cda9874d7dfe447393  # 22:36     30+      0  Merge tag 'stable/for-linus-3.8-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen
git bisect  bad 66cdd0ceaf65a18996f561b770eedde1d123b019  # 22:41      3-      3  Merge tag 'kvm-3.8-1' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good 8455d79e2163997e479931b8d5b7e60a92cd2b86  # 23:04     30+      0  KVM: PPC: Book3S HV: Run virtual core whenever any vcpus in it can run
git bisect  bad 78c634402a1825f1f5bef13077f0985f3b8a3212  # 23:11      3-     23  kvm: deliver msi interrupts from irq handler
git bisect good 189e11731aa858597095fbe1e6d243bad26bd96b  # 23:19     30+      0  x86: pvclock: add note about rdtsc barriers
git bisect  bad b48aa97e38206a84bf8485e7c553412274708ce5  # 23:42     22-      8  KVM: x86: require matched TSC offsets for master clock
git bisect  bad 886b470cb14733a0286e365c77f1844c240c33a4  # 00:28      2-      5  KVM: x86: pass host_tsc to read_l1_tsc
git bisect good 71056ae22d43f58d7e0f793af18ace2eaf5b74eb  # 01:09     47+      0  x86: pvclock: generic pvclock vsyscall initialization
git bisect  bad 51c19b4f5927f5a646e93d69f73c7e89ea14e737  # 02:16      0-      1  x86: vdso: pvclock gettime support
git bisect  bad 3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a  # 02:45      0-     24  x86: kvm guest: pvclock vsyscall support
# first bad commit: [3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a] x86: kvm guest: pvclock vsyscall support
git bisect good 71056ae22d43f58d7e0f793af18ace2eaf5b74eb  # 04:11    141+      0  x86: pvclock: generic pvclock vsyscall initialization


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 2
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-lkp-nex04-26:20140927024444:x86_64-randconfig-iv1-09252200::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.7.0-rc3-00112-g3dc4f7c (kbuild@ivytown2) (gc=
c version 4.9.1 (Debian 4.9.1-11) ) #1 Sat Sep 27 02:42:56 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-iv1-09252200/next:master:3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a:bise=
ct-linux-5/.vmlinuz-3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a-20140927024319=
-5-lkp-nex04 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv=
1-09252200/3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a/vmlinuz-3.7.0-rc3-00112=
-g3dc4f7c drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x13fdffff]
[    0.000000]  [mem 0x00000000-0x13fdffff] page 4k
[    0.000000] kernel direct mapping tables up to 0x13fdffff @ [mem 0x1288b=
000-0x1292cfff]
[    0.000000] RAMDISK: [mem 0x1292d000-0x13fdffff]
[    0.000000] ACPI: RSDP 00000000000f0c90 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013fe18bd 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013fe0b37 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013fe0040 00AF7 (v01 BOCHS  BXPCDSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACS 0000000013fe0000 00040
[    0.000000] ACPI: SSDT 0000000013fe0bab 00C5A (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fe1805 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fe1885 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1292c001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81775
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 76576 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/pvclock.c:182 pvclock_init_vsysc=
all+0x41/0x8e()
[    0.000000] Hardware name: Standard PC (i440FX + PIIX, 1996)
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.7.0-rc3-00112-g3dc4f7c #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8104f750>] warn_slowpath_common+0x70/0xa0
[    0.000000]  [<ffffffff8104f83a>] warn_slowpath_null+0x1a/0x20
[    0.000000]  [<ffffffff8219a6af>] pvclock_init_vsyscall+0x41/0x8e
[    0.000000]  [<ffffffff8219a623>] kvm_setup_vsyscall_timeinfo+0x48/0x78
[    0.000000]  [<ffffffff8219a397>] kvm_guest_init+0x98/0xe1
[    0.000000]  [<ffffffff82190eb8>] setup_arch+0xa9b/0xb10
[    0.000000]  [<ffffffff818eeae8>] ? printk+0x4f/0x57
[    0.000000]  [<ffffffff8218e856>] start_kernel+0x93/0x388
[    0.000000]  [<ffffffff8218e120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff8218e2b4>] x86_64_start_reservations+0xb0/0xb3
[    0.000000]  [<ffffffff8218e3b9>] x86_64_start_kernel+0x102/0x10f
[    0.000000] ---[ end trace c9f7d63dd24af7e7 ]---
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1e29bc0
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-iv1-09252200/next:master:3dc4f7cfb7441e5e0fed3a02fc81cdaabd2830=
0a:bisect-linux-5/.vmlinuz-3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a-2014092=
7024319-5-lkp-nex04 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randco=
nfig-iv1-09252200/3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a/vmlinuz-3.7.0-rc=
3-00112-g3dc4f7c drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 266556k/327552k available (9237k kernel code, 452k a=
bsent, 60544k reserved, 8732k data, 780k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.7.0-rc3-00112-g3dc4f7c (kbuild@ivytown2) (gc=
c version 4.9.1 (Debian 4.9.1-11) ) #1 Sat Sep 27 02:42:56 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-iv1-09252200/next:master:3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a:bise=
ct-linux-5/.vmlinuz-3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a-20140927024319=
-5-lkp-nex04 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv=
1-09252200/3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a/vmlinuz-3.7.0-rc3-00112=
-g3dc4f7c drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x13fdffff]
[    0.000000]  [mem 0x00000000-0x13fdffff] page 4k
[    0.000000] kernel direct mapping tables up to 0x13fdffff @ [mem 0x1288b=
000-0x1292cfff]
[    0.000000] RAMDISK: [mem 0x1292d000-0x13fdffff]
[    0.000000] ACPI: RSDP 00000000000f0c90 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013fe18bd 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013fe0b37 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013fe0040 00AF7 (v01 BOCHS  BXPCDSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACS 0000000013fe0000 00040
[    0.000000] ACPI: SSDT 0000000013fe0bab 00C5A (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fe1805 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fe1885 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1292c001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81775
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 76576 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/pvclock.c:182 pvclock_init_vsysc=
all+0x41/0x8e()
[    0.000000] Hardware name: Standard PC (i440FX + PIIX, 1996)
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.7.0-rc3-00112-g3dc4f7c #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8104f750>] warn_slowpath_common+0x70/0xa0
[    0.000000]  [<ffffffff8104f83a>] warn_slowpath_null+0x1a/0x20
[    0.000000]  [<ffffffff8219a6af>] pvclock_init_vsyscall+0x41/0x8e
[    0.000000]  [<ffffffff8219a623>] kvm_setup_vsyscall_timeinfo+0x48/0x78
[    0.000000]  [<ffffffff8219a397>] kvm_guest_init+0x98/0xe1
[    0.000000]  [<ffffffff82190eb8>] setup_arch+0xa9b/0xb10
[    0.000000]  [<ffffffff818eeae8>] ? printk+0x4f/0x57
[    0.000000]  [<ffffffff8218e856>] start_kernel+0x93/0x388
[    0.000000]  [<ffffffff8218e120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff8218e2b4>] x86_64_start_reservations+0xb0/0xb3
[    0.000000]  [<ffffffff8218e3b9>] x86_64_start_kernel+0x102/0x10f
[    0.000000] ---[ end trace c9f7d63dd24af7e7 ]---
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1e29bc0
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-iv1-09252200/next:master:3dc4f7cfb7441e5e0fed3a02fc81cdaabd2830=
0a:bisect-linux-5/.vmlinuz-3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a-2014092=
7024319-5-lkp-nex04 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randco=
nfig-iv1-09252200/3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a/vmlinuz-3.7.0-rc=
3-00112-g3dc4f7c drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 266556k/327552k available (9237k kernel code, 452k a=
bsent, 60544k reserved, 8732k data, 780k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: 10 of 10 active objects replaced
[    0.000000] ODEBUG: 10 of 10 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2260.998 MHz processor
[    0.000000] tsc: Detected 2260.998 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 4521.99 Bogo=
MIPS (lpj=3D2260998)
4521.99 BogoMIPS (lpj=3D2260998)
[    0.004014] pid_max: default: 4096 minimum: 301
[    0.004014] pid_max: default: 4096 minimum: 301
[    0.005181] Security Framework initialized
[    0.005181] Security Framework initialized
[    0.006025] Yama: becoming mindful.
[    0.006025] Yama: becoming mindful.
[    0.007060] Mount-cache hash table entries: 256
[    0.007060] Mount-cache hash table entries: 256
[    0.009355] Initializing cgroup subsys debug
[    0.009355] Initializing cgroup subsys debug
[    0.010017] Initializing cgroup subsys memory
[    0.010017] Initializing cgroup subsys memory
[    0.011117] Initializing cgroup subsys freezer
[    0.011117] Initializing cgroup subsys freezer
[    0.012151] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012151] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012151] tlb_flushall_shift: 6
[    0.012151] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012151] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012151] tlb_flushall_shift: 6
[    0.013024] CPU:=20
[    0.013024] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.022686] ACPI: Core revision 20120913
[    0.022686] ACPI: Core revision 20120913
[    0.027516] ftrace: allocating 27800 entries in 109 pages
[    0.027516] ftrace: allocating 27800 entries in 109 pages
[    0.043270] Performance Events:=20
[    0.043270] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.047070] ftrace: Allocated trace_printk buffers
[    0.047070] ftrace: Allocated trace_printk buffers
[    0.050569] Getting VERSION: 1050014
[    0.050569] Getting VERSION: 1050014
[    0.052016] Getting VERSION: 1050014
[    0.052016] Getting VERSION: 1050014
[    0.053018] Getting ID: 0
[    0.053018] Getting ID: 0
[    0.053630] Getting ID: ff000000
[    0.053630] Getting ID: ff000000
[    0.054019] Getting LVT0: 8700
[    0.054019] Getting LVT0: 8700
[    0.055011] Getting LVT1: 8400
[    0.055011] Getting LVT1: 8400
[    0.056101] enabled ExtINT on CPU#0
[    0.056101] enabled ExtINT on CPU#0
[    0.058092] ENABLING IO-APIC IRQs
[    0.058092] ENABLING IO-APIC IRQs
[    0.058853] init IO_APIC IRQs
[    0.058853] init IO_APIC IRQs
[    0.059008]  apic 0 pin 0 not connected
[    0.059008]  apic 0 pin 0 not connected
[    0.060065] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.060065] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.061038] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.061038] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.062033] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.062033] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.063034] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.063034] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.064034] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.064034] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.065034] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.065034] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.066032] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.066032] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.068011] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.068011] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.069032] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.069032] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.070032] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.070032] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.071034] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.071034] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.072032] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.072032] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.073032] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.073032] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.074032] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.074032] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.075032] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.075032] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.076028]  apic 0 pin 16 not connected
[    0.076028]  apic 0 pin 16 not connected
[    0.077005]  apic 0 pin 17 not connected
[    0.077005]  apic 0 pin 17 not connected
[    0.078006]  apic 0 pin 18 not connected
[    0.078006]  apic 0 pin 18 not connected
[    0.079005]  apic 0 pin 19 not connected
[    0.079005]  apic 0 pin 19 not connected
[    0.080005]  apic 0 pin 20 not connected
[    0.080005]  apic 0 pin 20 not connected
[    0.081006]  apic 0 pin 21 not connected
[    0.081006]  apic 0 pin 21 not connected
[    0.082005]  apic 0 pin 22 not connected
[    0.082005]  apic 0 pin 22 not connected
[    0.083006]  apic 0 pin 23 not connected
[    0.083006]  apic 0 pin 23 not connected
[    0.084161] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.084161] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.085009] Using local APIC timer interrupts.
[    0.085009] calibrating APIC timer ...
[    0.085009] Using local APIC timer interrupts.
[    0.085009] calibrating APIC timer ...
[    0.087000] ... lapic delta =3D 6247416
[    0.087000] ... lapic delta =3D 6247416
[    0.087000] ... PM-Timer delta =3D 357801
[    0.087000] ... PM-Timer delta =3D 357801
[    0.087000] ... PM-Timer result ok
[    0.087000] ... PM-Timer result ok
[    0.087000] ..... delta 6247416
[    0.087000] ..... delta 6247416
[    0.087000] ..... mult: 268324474
[    0.087000] ..... mult: 268324474
[    0.087000] ..... calibration result: 999586
[    0.087000] ..... calibration result: 999586
[    0.087000] ..... CPU clock speed is 2260.0072 MHz.
[    0.087000] ..... CPU clock speed is 2260.0072 MHz.
[    0.087000] ..... host bus clock speed is 999.0586 MHz.
[    0.087000] ..... host bus clock speed is 999.0586 MHz.
[    0.089025] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.089025] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.091484] regulator-dummy: no parameters
[    0.091484] regulator-dummy: no parameters
[    0.093154] RTC time:  2:43:30, date: 09/27/14
[    0.093154] RTC time:  2:43:30, date: 09/27/14
[    0.094544] NET: Registered protocol family 16
[    0.094544] NET: Registered protocol family 16
[    0.096623] ACPI: bus type pci registered
[    0.096623] ACPI: bus type pci registered
[    0.097069] dca service started, version 1.12.1
[    0.097069] dca service started, version 1.12.1
[    0.098128] PCI: Using configuration type 1 for base access
[    0.098128] PCI: Using configuration type 1 for base access
[    0.119757] bio: create slab <bio-0> at 0
[    0.119757] bio: create slab <bio-0> at 0
[    0.121227] ACPI: Added _OSI(Module Device)
[    0.121227] ACPI: Added _OSI(Module Device)
[    0.122010] ACPI: Added _OSI(Processor Device)
[    0.122010] ACPI: Added _OSI(Processor Device)
[    0.123010] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.123010] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.124013] ACPI: Added _OSI(Processor Aggregator Device)
[    0.124013] ACPI: Added _OSI(Processor Aggregator Device)
[    0.131471] ACPI: EC: Look up EC in DSDT
[    0.131471] ACPI: EC: Look up EC in DSDT
[    0.140395] ACPI: Interpreter enabled
[    0.140395] ACPI: Interpreter enabled
[    0.141012] ACPI: (supports S0
[    0.141012] ACPI: (supports S0 S3 S3 S4 S4 S5 S5)
)
[    0.143321] ACPI: Using IOAPIC for interrupt routing
[    0.143321] ACPI: Using IOAPIC for interrupt routing
[    0.159122] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.159122] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.160217] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.160217] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.162450] PCI host bridge to bus 0000:00
[    0.162450] PCI host bridge to bus 0000:00
[    0.163013] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.163013] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.164010] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.164010] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.165012] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.165012] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.166010] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.166010] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.167036] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.167036] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.168011] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.168011] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.169010] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.169010] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.170010] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.170010] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.171196] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.171196] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.173318] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.173318] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.175253] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.175253] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.182015] pci 0000:00:01.1: reg 20: [io  0xc040-0xc04f]
[    0.182015] pci 0000:00:01.1: reg 20: [io  0xc040-0xc04f]
[    0.185154] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.185154] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.187052] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.187052] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.188035] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.188035] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.189274] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.189274] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.192018] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.192018] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.195017] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.195017] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.206022] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.206022] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.207209] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.207209] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.210009] pci 0000:00:03.0: reg 10: [mem 0xfebc0000-0xfebdffff]
[    0.210009] pci 0000:00:03.0: reg 10: [mem 0xfebc0000-0xfebdffff]
[    0.212820] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.212820] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.222016] pci 0000:00:03.0: reg 30: [mem 0xfeb80000-0xfebbffff pref]
[    0.222016] pci 0000:00:03.0: reg 30: [mem 0xfeb80000-0xfebbffff pref]
[    0.223209] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.223209] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.225010] pci 0000:00:04.0: reg 10: [mem 0xfebf1000-0xfebf100f]
[    0.225010] pci 0000:00:04.0: reg 10: [mem 0xfebf1000-0xfebf100f]
[    0.232107] pci_bus 0000:00: on NUMA node 0
[    0.232107] pci_bus 0000:00: on NUMA node 0
[    0.233039] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.233039] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.292521]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    0.292521]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    0.293009]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.293009]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.303248] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.303248] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.305298] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.305298] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.307861] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.307861] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.309351] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.309351] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.311919] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.311919] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.313434] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.313434] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.314011] vgaarb: loaded
[    0.314011] vgaarb: loaded
[    0.315005] vgaarb: bridge control possible 0000:00:02.0
[    0.315005] vgaarb: bridge control possible 0000:00:02.0
[    0.317015] SCSI subsystem initialized
[    0.317015] SCSI subsystem initialized
[    0.318100] libata version 3.00 loaded.
[    0.318100] libata version 3.00 loaded.
[    0.319054] ACPI: bus type usb registered
[    0.319054] ACPI: bus type usb registered
[    0.320105] usbcore: registered new interface driver usbfs
[    0.320105] usbcore: registered new interface driver usbfs
[    0.321049] usbcore: registered new interface driver hub
[    0.321049] usbcore: registered new interface driver hub
[    0.322122] usbcore: registered new device driver usb
[    0.322122] usbcore: registered new device driver usb
[    0.323140] Linux video capture interface: v2.00
[    0.323140] Linux video capture interface: v2.00
[    0.324201] PCI: Using ACPI for IRQ routing
[    0.324201] PCI: Using ACPI for IRQ routing
[    0.325009] PCI: pci_cache_line_size set to 64 bytes
[    0.325009] PCI: pci_cache_line_size set to 64 bytes
[    0.326329] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.326329] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.327010] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.327010] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.329958] NET: Registered protocol family 23
[    0.329958] NET: Registered protocol family 23
[    0.330039] Bluetooth: Core ver 2.16
[    0.330039] Bluetooth: Core ver 2.16
[    0.331070] NET: Registered protocol family 31
[    0.331070] NET: Registered protocol family 31
[    0.332005] Bluetooth: HCI device and connection manager initialized
[    0.332005] Bluetooth: HCI device and connection manager initialized
[    0.333034] Bluetooth: HCI socket layer initialized
[    0.333034] Bluetooth: HCI socket layer initialized
[    0.334009] Bluetooth: L2CAP socket layer initialized
[    0.334009] Bluetooth: L2CAP socket layer initialized
[    0.335044] Bluetooth: SCO socket layer initialized
[    0.335044] Bluetooth: SCO socket layer initialized
[    0.337263] cfg80211: Calling CRDA to update world regulatory domain
[    0.337263] cfg80211: Calling CRDA to update world regulatory domain
[    0.339138] Switching to clocksource kvm-clock
[    0.339138] Switching to clocksource kvm-clock
[    0.341177] Warning: could not register annotated branches stats
[    0.341177] Warning: could not register annotated branches stats
[    0.378002] FS-Cache: Loaded
[    0.378002] FS-Cache: Loaded
[    0.379788] pnp: PnP ACPI init
[    0.379788] pnp: PnP ACPI init
[    0.381524] ACPI: bus type pnp registered
[    0.381524] ACPI: bus type pnp registered
[    0.383969] pnp 00:00: [bus 00-ff]
[    0.383969] pnp 00:00: [bus 00-ff]
[    0.385870] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.385870] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.388173] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.388173] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.390778] pnp 00:00: [io  0x0d00-0xadff window]
[    0.390778] pnp 00:00: [io  0x0d00-0xadff window]
[    0.393370] pnp 00:00: [io  0xae0f-0xaeff window]
[    0.393370] pnp 00:00: [io  0xae0f-0xaeff window]
[    0.395956] pnp 00:00: [io  0xaf20-0xafdf window]
[    0.395956] pnp 00:00: [io  0xaf20-0xafdf window]
[    0.398085] pnp 00:00: [io  0xafe4-0xffff window]
[    0.398085] pnp 00:00: [io  0xafe4-0xffff window]
[    0.400208] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.400208] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.403023] pnp 00:00: [mem 0x14000000-0xfebfffff window]
[    0.403023] pnp 00:00: [mem 0x14000000-0xfebfffff window]
[    0.405939] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.405939] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.408941] pnp 00:01: [io  0x0070-0x0071]
[    0.408941] pnp 00:01: [io  0x0070-0x0071]
[    0.410819] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.410819] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.415082] pnp 00:01: [irq 8]
[    0.415082] pnp 00:01: [irq 8]
[    0.416798] pnp 00:01: [io  0x0072-0x0077]
[    0.416798] pnp 00:01: [io  0x0072-0x0077]
[    0.419181] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.419181] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.422192] pnp 00:02: [io  0x0060]
[    0.422192] pnp 00:02: [io  0x0060]
[    0.423773] pnp 00:02: [io  0x0064]
[    0.423773] pnp 00:02: [io  0x0064]
[    0.425361] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.425361] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.429366] pnp 00:02: [irq 1]
[    0.429366] pnp 00:02: [irq 1]
[    0.431180] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.431180] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.434382] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.434382] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.438565] pnp 00:03: [irq 12]
[    0.438565] pnp 00:03: [irq 12]
[    0.440144] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.440144] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.443130] pnp 00:04: [io  0x03f2-0x03f5]
[    0.443130] pnp 00:04: [io  0x03f2-0x03f5]
[    0.445359] pnp 00:04: [io  0x03f7]
[    0.445359] pnp 00:04: [io  0x03f7]
[    0.447384] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.447384] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.450976] pnp 00:04: [irq 6]
[    0.450976] pnp 00:04: [irq 6]
[    0.452384] pnp 00:04: [dma 2]
[    0.452384] pnp 00:04: [dma 2]
[    0.453926] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.453926] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.456976] pnp 00:05: [io  0x0378-0x037f]
[    0.456976] pnp 00:05: [io  0x0378-0x037f]
[    0.458830] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.458830] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.462431] pnp 00:05: [irq 7]
[    0.462431] pnp 00:05: [irq 7]
[    0.463915] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.463915] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.466949] pnp 00:06: [io  0x03f8-0x03ff]
[    0.466949] pnp 00:06: [io  0x03f8-0x03ff]
[    0.468800] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.468800] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.472381] pnp 00:06: [irq 4]
[    0.472381] pnp 00:06: [irq 4]
[    0.473853] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.473853] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.477253] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.477253] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.479501] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.479501] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.482677] pnp 00:08: [io  0xaf00-0xaf1f]
[    0.482677] pnp 00:08: [io  0xaf00-0xaf1f]
[    0.484608] pnp 00:08: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.484608] pnp 00:08: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.487541] pnp: PnP ACPI: found 9 devices
[    0.487541] pnp: PnP ACPI: found 9 devices
[    0.489409] ACPI: ACPI bus type pnp unregistered
[    0.489409] ACPI: ACPI bus type pnp unregistered
[    0.496719] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.496719] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.499286] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.499286] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.501657] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.501657] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.503919] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.503919] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.506434] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.506434] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.508967] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.508967] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.511720] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.511720] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.514879] NET: Registered protocol family 2
[    0.514879] NET: Registered protocol family 2
[    0.517439] TCP established hash table entries: 16384 (order: 6, 262144 =
bytes)
[    0.517439] TCP established hash table entries: 16384 (order: 6, 262144 =
bytes)
[    0.521439] TCP bind hash table entries: 16384 (order: 8, 1310720 bytes)
[    0.521439] TCP bind hash table entries: 16384 (order: 8, 1310720 bytes)
[    0.527591] TCP: Hash tables configured (established 16384 bind 16384)
[    0.527591] TCP: Hash tables configured (established 16384 bind 16384)
[    0.530936] TCP: reno registered
[    0.530936] TCP: reno registered
[    0.532549] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.532549] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.535365] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.535365] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.538840] NET: Registered protocol family 1
[    0.538840] NET: Registered protocol family 1
[    0.541029] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.541029] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.543683] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.543683] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.546584] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.546584] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.549610] pci 0000:00:02.0: Boot video device
[    0.549610] pci 0000:00:02.0: Boot video device
[    0.551868] PCI: CLS 0 bytes, default 64
[    0.551868] PCI: CLS 0 bytes, default 64
[    0.554210] Unpacking initramfs...
[    0.554210] Unpacking initramfs...
[    1.848364] debug: unmapping init [mem 0xffff88001292d000-0xffff880013fd=
ffff]
[    1.848364] debug: unmapping init [mem 0xffff88001292d000-0xffff880013fd=
ffff]
[    1.853534] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.853534] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.858820] AVX instructions are not detected.
[    1.858820] AVX instructions are not detected.
[    1.861313] audit: initializing netlink socket (disabled)
[    1.861313] audit: initializing netlink socket (disabled)
[    1.863691] type=3D2000 audit(1411757011.863:1): initialized
[    1.863691] type=3D2000 audit(1411757011.863:1): initialized
[    1.866462] rcu-torture:--- Start of test: nreaders=3D2 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D0 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.866462] rcu-torture:--- Start of test: nreaders=3D2 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D0 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.885872] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.885872] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.895879] VFS: Disk quotas dquot_6.5.2
[    1.895879] VFS: Disk quotas dquot_6.5.2
[    1.897834] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.897834] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.906808] Key type cifs.spnego registered
[    1.906808] Key type cifs.spnego registered
[    1.909058] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    1.909058] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    1.914943] JFS: nTxBlock =3D 2082, nTxLock =3D 16659
[    1.914943] JFS: nTxBlock =3D 2082, nTxLock =3D 16659
[    1.923157] SGI XFS with security attributes, realtime, large block/inod=
e numbers, no debug enabled
[    1.923157] SGI XFS with security attributes, realtime, large block/inod=
e numbers, no debug enabled
[    1.927853] GFS2 installed
[    1.927853] GFS2 installed
[    1.928625] msgmni has been set to 520
[    1.928625] msgmni has been set to 520
[    1.937176] NET: Registered protocol family 38
[    1.937176] NET: Registered protocol family 38
[    1.939323] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    1.939323] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    1.942530] io scheduler noop registered (default)
[    1.942530] io scheduler noop registered (default)
[    1.946259] list_sort_test: start testing list_sort()
[    1.946259] list_sort_test: start testing list_sort()
[    1.950149] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.950149] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.952656] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.952656] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.956269] acpiphp: Slot [3] registered
[    1.956269] acpiphp: Slot [3] registered
[    1.958289] acpiphp: Slot [4] registered
[    1.958289] acpiphp: Slot [4] registered
[    1.961339] acpiphp: Slot [5] registered
[    1.961339] acpiphp: Slot [5] registered
[    1.963317] acpiphp: Slot [6] registered
[    1.963317] acpiphp: Slot [6] registered
[    1.965224] acpiphp: Slot [7] registered
[    1.965224] acpiphp: Slot [7] registered
[    1.966966] acpiphp: Slot [8] registered
[    1.966966] acpiphp: Slot [8] registered
[    1.968546] acpiphp: Slot [9] registered
[    1.968546] acpiphp: Slot [9] registered
[    1.970558] acpiphp: Slot [10] registered
[    1.970558] acpiphp: Slot [10] registered
[    1.972388] acpiphp: Slot [11] registered
[    1.972388] acpiphp: Slot [11] registered
[    1.974072] acpiphp: Slot [12] registered
[    1.974072] acpiphp: Slot [12] registered
[    1.975697] acpiphp: Slot [13] registered
[    1.975697] acpiphp: Slot [13] registered
[    1.978160] acpiphp: Slot [14] registered
[    1.978160] acpiphp: Slot [14] registered
[    1.980308] acpiphp: Slot [15] registered
[    1.980308] acpiphp: Slot [15] registered
[    1.982952] acpiphp: Slot [16] registered
[    1.982952] acpiphp: Slot [16] registered
[    1.985530] acpiphp: Slot [17] registered
[    1.985530] acpiphp: Slot [17] registered
[    1.988626] acpiphp: Slot [18] registered
[    1.988626] acpiphp: Slot [18] registered
[    1.991158] acpiphp: Slot [19] registered
[    1.991158] acpiphp: Slot [19] registered
[    1.993756] acpiphp: Slot [20] registered
[    1.993756] acpiphp: Slot [20] registered
[    1.996143] acpiphp: Slot [21] registered
[    1.996143] acpiphp: Slot [21] registered
[    1.998263] acpiphp: Slot [22] registered
[    1.998263] acpiphp: Slot [22] registered
[    2.001266] acpiphp: Slot [23] registered
[    2.001266] acpiphp: Slot [23] registered
[    2.003400] acpiphp: Slot [24] registered
[    2.003400] acpiphp: Slot [24] registered
[    2.005494] acpiphp: Slot [25] registered
[    2.005494] acpiphp: Slot [25] registered
[    2.007593] acpiphp: Slot [26] registered
[    2.007593] acpiphp: Slot [26] registered
[    2.011475] acpiphp: Slot [27] registered
[    2.011475] acpiphp: Slot [27] registered
[    2.013606] acpiphp: Slot [28] registered
[    2.013606] acpiphp: Slot [28] registered
[    2.015649] acpiphp: Slot [29] registered
[    2.015649] acpiphp: Slot [29] registered
[    2.017755] acpiphp: Slot [30] registered
[    2.017755] acpiphp: Slot [30] registered
[    2.019874] acpiphp: Slot [31] registered
[    2.019874] acpiphp: Slot [31] registered
[    2.027667] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    2.027667] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    2.031987] ipmi message handler version 39.2
[    2.031987] ipmi message handler version 39.2
[    2.034460] IPMI System Interface driver.
[    2.034460] IPMI System Interface driver.
[    2.036849] ipmi_si: Adding default-specified kcs state machine
[    2.036849] ipmi_si: Adding default-specified kcs state machine

[    2.041549] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    2.041549] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    2.046928] ipmi_si: Interface detection failed
[    2.046928] ipmi_si: Interface detection failed
[    2.049399] ipmi_si: Adding default-specified smic state machine
[    2.049399] ipmi_si: Adding default-specified smic state machine

[    2.052658] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    2.052658] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    2.057519] ipmi_si: Interface detection failed
[    2.057519] ipmi_si: Interface detection failed
[    2.060925] ipmi_si: Adding default-specified bt state machine
[    2.060925] ipmi_si: Adding default-specified bt state machine

[    2.064137] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    2.064137] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    2.069310] ipmi_si: Interface detection failed
[    2.069310] ipmi_si: Interface detection failed
[    2.076305] ipmi_si: Unable to find any System Interface(s)
[    2.076305] ipmi_si: Unable to find any System Interface(s)
[    2.079160] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.079160] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.082586] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.082586] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.117956] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.117956] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.155967] SyncLink MultiPort driver $Revision: 4.38 $
[    2.155967] SyncLink MultiPort driver $Revision: 4.38 $
[    2.165935] SyncLink MultiPort driver $Revision: 4.38 $, tty major#251
[    2.165935] SyncLink MultiPort driver $Revision: 4.38 $, tty major#251
[    2.169119] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    2.169119] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    2.171456] smapi::smapi_init, ERROR invalid usSmapiID
[    2.171456] smapi::smapi_init, ERROR invalid usSmapiID
[    2.173815] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    2.173815] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    2.177694] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    2.177694] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    2.181125] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    2.181125] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    2.184697] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.184697] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.187927] i2c-core: driver [fsa9480] using legacy suspend method
[    2.187927] i2c-core: driver [fsa9480] using legacy suspend method
[    2.190674] i2c-core: driver [fsa9480] using legacy resume method
[    2.190674] i2c-core: driver [fsa9480] using legacy resume method
[    2.193930] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    2.193930] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    2.197165] usbcore: registered new interface driver irda-usb
[    2.197165] usbcore: registered new interface driver irda-usb
[    2.200654] I2O subsystem v1.325
[    2.200654] I2O subsystem v1.325
[    2.202527] i2o: max drivers =3D 8
[    2.202527] i2o: max drivers =3D 8
[    2.204596] I2O SCSI Peripheral OSM v1.316
[    2.204596] I2O SCSI Peripheral OSM v1.316
[    2.207046] Fusion MPT base driver 3.04.20
[    2.207046] Fusion MPT base driver 3.04.20
[    2.209132] Copyright (c) 1999-2008 LSI Corporation
[    2.209132] Copyright (c) 1999-2008 LSI Corporation
[    2.211682] Fusion MPT SAS Host driver 3.04.20
[    2.211682] Fusion MPT SAS Host driver 3.04.20
[    2.215433] uhci_hcd: USB Universal Host Controller Interface driver
[    2.215433] uhci_hcd: USB Universal Host Controller Interface driver
[    2.218472] usbcore: registered new interface driver cdc_wdm
[    2.218472] usbcore: registered new interface driver cdc_wdm
[    2.222179] usbcore: registered new interface driver appledisplay
[    2.222179] usbcore: registered new interface driver appledisplay
[    2.224784] driver ftdi-elan
[    2.224784] driver ftdi-elan
[    2.228143] usbcore: registered new interface driver ftdi-elan
[    2.228143] usbcore: registered new interface driver ftdi-elan
[    2.230687] usbcore: registered new interface driver iowarrior
[    2.230687] usbcore: registered new interface driver iowarrior
[    2.233198] usbcore: registered new interface driver isight_firmware
[    2.233198] usbcore: registered new interface driver isight_firmware
[    2.235863] usbcore: registered new interface driver legousbtower
[    2.235863] usbcore: registered new interface driver legousbtower
[    2.238465] usbcore: registered new interface driver rio500
[    2.238465] usbcore: registered new interface driver rio500
[    2.240820] usbcore: registered new interface driver usbsevseg
[    2.240820] usbcore: registered new interface driver usbsevseg
[    2.243583] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.243583] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.248435] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.248435] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.250608] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.250608] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.253883] mousedev: PS/2 mouse device common for all mice
[    2.253883] mousedev: PS/2 mouse device common for all mice
[    2.257197] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    2.257197] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    2.261511] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.261511] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.265839] usbcore: registered new interface driver bcm5974
[    2.265839] usbcore: registered new interface driver bcm5974
[    2.268256] usbcore: registered new interface driver synaptics_usb
[    2.268256] usbcore: registered new interface driver synaptics_usb
[    2.271521] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    2.271521] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    2.276288] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    2.276288] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    2.279467] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[    2.279467] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[    2.390967] usbcore: registered new interface driver i2c-diolan-u2c
[    2.390967] usbcore: registered new interface driver i2c-diolan-u2c
[    2.397093] usbcore: registered new interface driver i2c-tiny-usb
[    2.397093] usbcore: registered new interface driver i2c-tiny-usb
[    2.400097] i2c-core: driver [adv7180] using legacy suspend method
[    2.400097] i2c-core: driver [adv7180] using legacy suspend method
[    2.402735] i2c-core: driver [adv7180] using legacy resume method
[    2.402735] i2c-core: driver [adv7180] using legacy resume method
[    2.405678] lirc_dev: IR Remote Control driver registered, major 248=20
[    2.405678] lirc_dev: IR Remote Control driver registered, major 248=20
[    2.409982] IR RC6 protocol handler initialized
[    2.409982] IR RC6 protocol handler initialized
[    2.412354] IR RC5 (streamzap) protocol handler initialized
[    2.412354] IR RC5 (streamzap) protocol handler initialized
[    2.415629] IR MCE Keyboard/mouse protocol handler initialized
[    2.415629] IR MCE Keyboard/mouse protocol handler initialized
[    2.419065] IR LIRC bridge handler initialized
[    2.419065] IR LIRC bridge handler initialized
[    2.421849] usbcore: registered new interface driver streamzap
[    2.421849] usbcore: registered new interface driver streamzap
[    2.424921] Registered IR keymap rc-empty
[    2.424921] Registered IR keymap rc-empty
[    2.428203] input: rc-core loopback device as /devices/virtual/rc/rc0/in=
put1
[    2.428203] input: rc-core loopback device as /devices/virtual/rc/rc0/in=
put1
[    2.431162] evbug: Connected device: input1 (rc-core loopback device at =
rc-core/virtual)
[    2.431162] evbug: Connected device: input1 (rc-core loopback device at =
rc-core/virtual)
[    2.434572] rc0: rc-core loopback device as /devices/virtual/rc/rc0
[    2.434572] rc0: rc-core loopback device as /devices/virtual/rc/rc0
[    2.438494] input: MCE IR Keyboard/Mouse (rc-loopback) as /devices/virtu=
al/input/input2
[    2.438494] input: MCE IR Keyboard/Mouse (rc-loopback) as /devices/virtu=
al/input/input2
[    2.442079] evbug: Connected device: input2 (MCE IR Keyboard/Mouse (rc-l=
oopback) at /input0)
[    2.442079] evbug: Connected device: input2 (MCE IR Keyboard/Mouse (rc-l=
oopback) at /input0)
[    2.445916] rc rc0: lirc_dev: driver ir-lirc-codec (rc-loopback) registe=
red at minor =3D 0
[    2.445916] rc rc0: lirc_dev: driver ir-lirc-codec (rc-loopback) registe=
red at minor =3D 0
[    2.449603] usbcore: registered new interface driver iguanair
[    2.449603] usbcore: registered new interface driver iguanair
[    2.452054] usbcore: registered new interface driver ttusbir
[    2.452054] usbcore: registered new interface driver ttusbir
[    2.454410] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver c=
hip loaded successfully
[    2.454410] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver c=
hip loaded successfully
[    2.459842] saa7146: register extension 'av7110'
[    2.459842] saa7146: register extension 'av7110'
[    2.461949] saa7146: register extension 'hexium gemini'
[    2.461949] saa7146: register extension 'hexium gemini'
[    2.464794] cx18:  Start initialization, version 1.5.1
[    2.464794] cx18:  Start initialization, version 1.5.1
[    2.467078] cx18:  End initialization
[    2.467078] cx18:  End initialization
[    2.468648] usbcore: registered new interface driver dvb_usb_dibusb_mb
[    2.468648] usbcore: registered new interface driver dvb_usb_dibusb_mb
[    2.473789] usbcore: registered new interface driver dvb_usb_umt_010
[    2.473789] usbcore: registered new interface driver dvb_usb_umt_010
[    2.476266] usbcore: registered new interface driver dvb_usb_m920x
[    2.476266] usbcore: registered new interface driver dvb_usb_m920x
[    2.478288] usbcore: registered new interface driver dvb_usb_digitv
[    2.478288] usbcore: registered new interface driver dvb_usb_digitv
[    2.480166] usbcore: registered new interface driver dvb_usb_ttusb2
[    2.480166] usbcore: registered new interface driver dvb_usb_ttusb2
[    2.481869] usbcore: registered new interface driver dvb_usb_dib0700
[    2.481869] usbcore: registered new interface driver dvb_usb_dib0700
[    2.485089] usbcore: registered new interface driver dvb_usb_af9005
[    2.485089] usbcore: registered new interface driver dvb_usb_af9005
[    2.490089] af9005: af9005_rc_decode function not found, disabling remote
[    2.490089] af9005: af9005_rc_decode function not found, disabling remote
[    2.492856] usbcore: registered new interface driver dvb_usb_dtv5100
[    2.492856] usbcore: registered new interface driver dvb_usb_dtv5100
[    2.495826] usbcore: registered new interface driver hdpvr
[    2.495826] usbcore: registered new interface driver hdpvr
[    2.498472] usbcore: registered new interface driver usbvision
[    2.498472] usbcore: registered new interface driver usbvision
[    2.501188] USBVision USB Video Device Driver for Linux : 0.9.11
[    2.501188] USBVision USB Video Device Driver for Linux : 0.9.11
[    2.504543] usbcore: registered new interface driver stk1160
[    2.504543] usbcore: registered new interface driver stk1160
[    2.507056] smssdio: Siano SMS1xxx SDIO driver
[    2.507056] smssdio: Siano SMS1xxx SDIO driver
[    2.509079] smssdio: Copyright Pierre Ossman
[    2.509079] smssdio: Copyright Pierre Ossman
[    2.510470] Driver for 1-wire Dallas network protocol.
[    2.510470] Driver for 1-wire Dallas network protocol.
[    2.512186] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.512186] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.515424] i2c-core: driver [max17040] using legacy suspend method
[    2.515424] i2c-core: driver [max17040] using legacy suspend method
[    2.517408] i2c-core: driver [max17040] using legacy resume method
[    2.517408] i2c-core: driver [max17040] using legacy resume method
[    2.574170] applesmc: supported laptop not found!
[    2.574170] applesmc: supported laptop not found!
[    2.575488] applesmc: driver init failed (ret=3D-19)!
[    2.575488] applesmc: driver init failed (ret=3D-19)!
[    2.859995] tsc: Refined TSC clocksource calibration: 2260.991 MHz
[    2.859995] tsc: Refined TSC clocksource calibration: 2260.991 MHz
[    2.937162] usbcore: registered new interface driver pcwd_usb
[    2.937162] usbcore: registered new interface driver pcwd_usb
[    2.939601] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    2.939601] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    2.942823] acquirewdt: I/O address 0x0043 already in use
[    2.942823] acquirewdt: I/O address 0x0043 already in use
[    2.945105] acquirewdt: probe of acquirewdt failed with error -5
[    2.945105] acquirewdt: probe of acquirewdt failed with error -5
[    2.947592] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    2.947592] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    2.950156] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    2.950156] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    2.956287] sc1200wdt: build 20020303
[    2.956287] sc1200wdt: build 20020303
[    2.957878] sc1200wdt: io parameter must be specified
[    2.957878] sc1200wdt: io parameter must be specified
[    2.960037] sbc60xxwdt: I/O address 0x0443 already in use
[    2.960037] sbc60xxwdt: I/O address 0x0443 already in use
[    2.962313] cpu5wdt: misc_register failed
[    2.962313] cpu5wdt: misc_register failed
[    2.964068] w83877f_wdt: I/O address 0x0443 already in use
[    2.964068] w83877f_wdt: I/O address 0x0443 already in use
[    2.966335] w83977f_wdt: driver v1.00
[    2.966335] w83977f_wdt: driver v1.00
[    2.968718] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    2.968718] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    2.971585] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    2.971585] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    2.975129] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    2.975129] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    2.981440] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    2.981440] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    2.986387] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    2.986387] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    2.994580] cpuidle: using governor ladder
[    2.994580] cpuidle: using governor ladder
[    2.996523] cpuidle: using governor menu
[    2.996523] cpuidle: using governor menu
[    2.998701] EFI Variables Facility v0.08 2004-May-17
[    2.998701] EFI Variables Facility v0.08 2004-May-17
[    3.001583] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[    3.001583] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[    3.003631] acerhdf: unknown (unsupported) BIOS version QEMU/Standard PC=
 (i440FX + PIIX, 1996)/1.7.5-20140531_083030-gandalf, please report, aborti=
ng!
[    3.003631] acerhdf: unknown (unsupported) BIOS version QEMU/Standard PC=
 (i440FX + PIIX, 1996)/1.7.5-20140531_083030-gandalf, please report, aborti=
ng!
[    3.060984] hdaps: supported laptop not found!
[    3.060984] hdaps: supported laptop not found!
[    3.063059] hdaps: driver init failed (ret=3D-19)!
[    3.063059] hdaps: driver init failed (ret=3D-19)!
[    3.066132] FUJ02B1: call_fext_func: FUNC interface is not present
[    3.066132] FUJ02B1: call_fext_func: FUNC interface is not present
[    3.069039] fujitsu_laptop: driver 0.6.0 successfully loaded
[    3.069039] fujitsu_laptop: driver 0.6.0 successfully loaded
[    3.072129] IPv4 over IPv4 tunneling driver
[    3.072129] IPv4 over IPv4 tunneling driver
[    3.074715] TCP: cubic registered
[    3.074715] TCP: cubic registered
[    3.078104] NET: Registered protocol family 10
[    3.078104] NET: Registered protocol family 10
[    3.081416] NET: Registered protocol family 4
[    3.081416] NET: Registered protocol family 4
[    3.083491] NET: Registered protocol family 5
[    3.083491] NET: Registered protocol family 5
[    3.086042] IrCOMM protocol (Dag Brattli)
[    3.086042] IrCOMM protocol (Dag Brattli)
[    3.089713] Bluetooth: RFCOMM TTY layer initialized
[    3.089713] Bluetooth: RFCOMM TTY layer initialized
[    3.091833] Bluetooth: RFCOMM socket layer initialized
[    3.091833] Bluetooth: RFCOMM socket layer initialized
[    3.094269] Bluetooth: RFCOMM ver 1.11
[    3.094269] Bluetooth: RFCOMM ver 1.11
[    3.096055] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.096055] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.098488] Bluetooth: BNEP filters: protocol multicast
[    3.098488] Bluetooth: BNEP filters: protocol multicast
[    3.101148] Bluetooth: BNEP socket layer initialized
[    3.101148] Bluetooth: BNEP socket layer initialized
[    3.103785] 9pnet: Installing 9P2000 support
[    3.103785] 9pnet: Installing 9P2000 support
[    3.105937] Key type dns_resolver registered
[    3.105937] Key type dns_resolver registered
[    3.109194] batman_adv: B.A.T.M.A.N. advanced 2012.4.0 (compatibility ve=
rsion 14) loaded
[    3.109194] batman_adv: B.A.T.M.A.N. advanced 2012.4.0 (compatibility ve=
rsion 14) loaded
[    3.113431]=20
[    3.113431] printing PIC contents
[    3.113431]=20
[    3.113431] printing PIC contents
[    3.115737] ... PIC  IMR: ffff
[    3.115737] ... PIC  IMR: ffff
[    3.116714] ... PIC  IRR: 1013
[    3.116714] ... PIC  IRR: 1013
[    3.118678] ... PIC  ISR: 0000
[    3.118678] ... PIC  ISR: 0000
[    3.119969] ... PIC ELCR: 0c00
[    3.119969] ... PIC ELCR: 0c00
[    3.121118] printing local APIC contents on CPU#0/0:
[    3.121118] printing local APIC contents on CPU#0/0:
[    3.122097] ... APIC ID:      00000000 (0)
[    3.122097] ... APIC ID:      00000000 (0)
[    3.122097] ... APIC VERSION: 01050014
[    3.122097] ... APIC VERSION: 01050014
[    3.122097] ... APIC TASKPRI: 00000000 (00)
[    3.122097] ... APIC TASKPRI: 00000000 (00)
[    3.122097] ... APIC PROCPRI: 00000000
[    3.122097] ... APIC PROCPRI: 00000000
[    3.122097] ... APIC LDR: 01000000
[    3.122097] ... APIC LDR: 01000000
[    3.122097] ... APIC DFR: ffffffff
[    3.122097] ... APIC DFR: ffffffff
[    3.122097] ... APIC SPIV: 000001ff
[    3.122097] ... APIC SPIV: 000001ff
[    3.122097] ... APIC ISR field:
[    3.122097] ... APIC ISR field:
[    3.122097] 00000000
[    3.122097] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    3.122097] ... APIC TMR field:
[    3.122097] ... APIC TMR field:
[    3.122097] 00000000
[    3.122097] 000000000e2000000e200000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    3.122097] ... APIC IRR field:
[    3.122097] ... APIC IRR field:
[    3.122097] 00000000
[    3.122097] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    3.122097] ... APIC ESR: 00000000
[    3.122097] ... APIC ESR: 00000000
[    3.122097] ... APIC ICR: 00000831
[    3.122097] ... APIC ICR: 00000831
[    3.122097] ... APIC ICR2: 01000000
[    3.122097] ... APIC ICR2: 01000000
[    3.122097] ... APIC LVTT: 000000ef
[    3.122097] ... APIC LVTT: 000000ef
[    3.122097] ... APIC LVTPC: 00010000
[    3.122097] ... APIC LVTPC: 00010000
[    3.122097] ... APIC LVT0: 00010700
[    3.122097] ... APIC LVT0: 00010700
[    3.122097] ... APIC LVT1: 00000400
[    3.122097] ... APIC LVT1: 00000400
[    3.122097] ... APIC LVTERR: 000000fe
[    3.122097] ... APIC LVTERR: 000000fe
[    3.122097] ... APIC TMICT: 0000dbc2
[    3.122097] ... APIC TMICT: 0000dbc2
[    3.122097] ... APIC TMCCT: 00000000
[    3.122097] ... APIC TMCCT: 00000000
[    3.122097] ... APIC TDCR: 00000003
[    3.122097] ... APIC TDCR: 00000003
[    3.122097]=20
[    3.122097]=20
[    3.165399] number of MP IRQ sources: 15.
[    3.165399] number of MP IRQ sources: 15.
[    3.167323] number of IO-APIC #0 registers: 24.
[    3.167323] number of IO-APIC #0 registers: 24.
[    3.169466] testing the IO APIC.......................
[    3.169466] testing the IO APIC.......................
[    3.171800] IO APIC #0......
[    3.171800] IO APIC #0......
[    3.173053] .... register #00: 00000000
[    3.173053] .... register #00: 00000000
[    3.174808] .......    : physical APIC id: 00
[    3.174808] .......    : physical APIC id: 00
[    3.176868] .......    : Delivery Type: 0
[    3.176868] .......    : Delivery Type: 0
[    3.178771] .......    : LTS          : 0
[    3.178771] .......    : LTS          : 0
[    3.180680] .... register #01: 00170011
[    3.180680] .... register #01: 00170011
[    3.182484] .......     : max redirection entries: 17
[    3.182484] .......     : max redirection entries: 17
[    3.184404] .......     : PRQ implemented: 0
[    3.184404] .......     : PRQ implemented: 0
[    3.186322] .......     : IO APIC version: 11
[    3.186322] .......     : IO APIC version: 11
[    3.188278] .... register #02: 00000000
[    3.188278] .... register #02: 00000000
[    3.190138] .......     : arbitration: 00
[    3.190138] .......     : arbitration: 00
[    3.191918] .... IRQ redirection table:
[    3.191918] .... IRQ redirection table:
[    3.193341]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    3.193341]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    3.195842]  00 00 =20
[    3.195842]  00 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[    3.198252]  01 01 =20
[    3.198252]  01 01  0    0    0   0   0    1    1    31
0    0    0   0   0    1    1    31
[    3.200626]  02 01 =20
[    3.200626]  02 01  0    0    0   0   0    1    1    30
0    0    0   0   0    1    1    30
[    3.203109]  03 01 =20
[    3.203109]  03 01  0    0    0   0   0    1    1    33
0    0    0   0   0    1    1    33
[    3.205517]  04 01 =20
[    3.205517]  04 01  1    0    0   0   0    1    1    34
1    0    0   0   0    1    1    34
[    3.208088]  05 01 =20
[    3.208088]  05 01  1    1    0   0   0    1    1    35
1    1    0   0   0    1    1    35
[    3.210366]  06 01 =20
[    3.210366]  06 01  0    0    0   0   0    1    1    36
0    0    0   0   0    1    1    36
[    3.212154]  07 01 =20
[    3.212154]  07 01  0    0    0   0   0    1    1    37
0    0    0   0   0    1    1    37
[    3.214023]  08 01 =20
[    3.214023]  08 01  0    0    0   0   0    1    1    38
0    0    0   0   0    1    1    38
[    3.216271]  09 01 =20
[    3.216271]  09 01  0    1    0   0   0    1    1    39
0    1    0   0   0    1    1    39
[    3.218312]  0a 01 =20
[    3.218312]  0a 01  1    1    0   0   0    1    1    3A
1    1    0   0   0    1    1    3A
[    3.220024]  0b 01 =20
[    3.220024]  0b 01  1    1    0   0   0    1    1    3B
1    1    0   0   0    1    1    3B
[    3.221711]  0c 01 =20
[    3.221711]  0c 01  0    0    0   0   0    1    1    3C
0    0    0   0   0    1    1    3C
[    3.223995]  0d 01 =20
[    3.223995]  0d 01  0    0    0   0   0    1    1    3D
0    0    0   0   0    1    1    3D
[    3.226141]  0e 01 =20
[    3.226141]  0e 01  0    0    0   0   0    1    1    3E
0    0    0   0   0    1    1    3E
[    3.228171]  0f 01 =20
[    3.228171]  0f 01  0    0    0   0   0    1    1    3F
0    0    0   0   0    1    1    3F
[    3.230342]  10 00 =20
[    3.230342]  10 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[    3.232568]  11 00 =20
[    3.232568]  11 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[    3.234604]  12 00 =20
[    3.234604]  12 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[    3.236727]  13 00 =20
[    3.236727]  13 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[    3.238886]  14 00 =20
[    3.238886]  14 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[    3.240979]  15 00 =20
[    3.240979]  15 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[    3.243069]  16 00 =20
[    3.243069]  16 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[    3.245333]  17 00 =20
[    3.245333]  17 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[    3.247404] IRQ to pin mappings:
[    3.247404] IRQ to pin mappings:
[    3.248724] IRQ0=20
[    3.248724] IRQ0 -> 0:2-> 0:2

[    3.249947] IRQ1=20
[    3.249947] IRQ1 -> 0:1-> 0:1

[    3.251180] IRQ3=20
[    3.251180] IRQ3 -> 0:3-> 0:3

[    3.252393] IRQ4=20
[    3.252393] IRQ4 -> 0:4-> 0:4

[    3.253651] IRQ5=20
[    3.253651] IRQ5 -> 0:5-> 0:5

[    3.254936] IRQ6=20
[    3.254936] IRQ6 -> 0:6-> 0:6

[    3.256216] IRQ7=20
[    3.256216] IRQ7 -> 0:7-> 0:7

[    3.257464] IRQ8=20
[    3.257464] IRQ8 -> 0:8-> 0:8

[    3.258715] IRQ9=20
[    3.258715] IRQ9 -> 0:9-> 0:9

[    3.259976] IRQ10=20
[    3.259976] IRQ10 -> 0:10-> 0:10

[    3.261332] IRQ11=20
[    3.261332] IRQ11 -> 0:11-> 0:11

[    3.262657] IRQ12=20
[    3.262657] IRQ12 -> 0:12-> 0:12

[    3.264062] IRQ13=20
[    3.264062] IRQ13 -> 0:13-> 0:13

[    3.265391] IRQ14=20
[    3.265391] IRQ14 -> 0:14-> 0:14

[    3.266770] IRQ15=20
[    3.266770] IRQ15 -> 0:15-> 0:15

[    3.268211] .................................... done.
[    3.268211] .................................... done.
[    3.270705] turn off boot console earlyser0
[    3.270705] turn off boot console earlyser0
[    3.272877] PM: Hibernation image not present or could not be loaded
--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--qtZFehHsKgwS5rPz--
