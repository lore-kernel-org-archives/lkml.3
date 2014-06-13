Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaFMIJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:09:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:63424 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaFMIIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:08:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,470,1400050800"; 
   d="log'?scan'208";a="547386495"
Message-ID: <539AB112.5030100@intel.com>
Date: Fri, 13 Jun 2014 16:06:42 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        lkp@01.org, kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [x86: kvm] WARNING: at arch/x86/kernel/pvclock.c:182 pvclock_init_vsyscall()
Content-Type: multipart/mixed;
 boundary="------------030807040400090905020506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030807040400090905020506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Marcelo,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
commit 3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a
Author:     Marcelo Tosatti <mtosatti@redhat.com>
AuthorDate: Tue Nov 27 23:28:56 2012 -0200
Commit:     Marcelo Tosatti <mtosatti@redhat.com>
CommitDate: Tue Nov 27 23:29:10 2012 -0200

    x86: kvm guest: pvclock vsyscall support
        Hook into generic pvclock vsyscall code, with the aim to
    allow userspace to have visibility into pvclock data.
        Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

+--------------------------------------------------------------+------------+------------+
|                                                              | 71056ae22d | 3dc4f7cfb7 |
+--------------------------------------------------------------+------------+------------+
| boot_successes                                               | 60         | 0          |
| boot_failures                                                | 0          | 20         |
| WARNING:at_arch/x86/kernel/pvclock.c:pvclock_init_vsyscall() | 0          | 20         |
| backtrace:pvclock_init_vsyscall                              | 0          | 20         |
| backtrace:warn_slowpath_null                                 | 0          | 20         |
| backtrace:kvm_setup_vsyscall_timeinfo                        | 0          | 20         |
| backtrace:kvm_guest_init                                     | 0          | 20         |
+--------------------------------------------------------------+------------+------------+

[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/pvclock.c:182 pvclock_init_vsyscall+0x21/0x59()
[    0.000000] Hardware name: Bochs
[    0.000000] Pid: 0, comm: swapper Not tainted 3.7.0-rc3-00112-g3dc4f7c #37
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81062255>] warn_slowpath_common+0x7c/0x94
[    0.000000]  [<ffffffff81062343>] warn_slowpath_null+0x1a/0x1c
[    0.000000]  [<ffffffff81cdd7c9>] pvclock_init_vsyscall+0x21/0x59
[    0.000000]  [<ffffffff81cdd75b>] kvm_setup_vsyscall_timeinfo+0x59/0x8b
[    0.000000]  [<ffffffff81cdd4cf>] kvm_guest_init+0xe4/0xfe
[    0.000000]  [<ffffffff81cd2f9e>] setup_arch+0xa64/0xad9
[    0.000000]  [<ffffffff81cd0893>] start_kernel+0xdc/0x430
[    0.000000]  [<ffffffff81cd0120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81cd02b4>] x86_64_start_reservations+0xb0/0xb3
[    0.000000]  [<ffffffff81cd03b9>] x86_64_start_kernel+0x102/0x10f
[    0.000000] ---[ end trace c4149eb8555303de ]---
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices

git bisect start 749387dc8d8270b279f27a0a794cdf4f4a4aa774 v3.7 --
git bisect  bad e32795503de02da4e7e74a5e039cc268f6a0ecfb  # 23:38      0-     13  Merge tags 'dt-for-linus', 'gpio-for-linus' and 'spi-for-linus' of git://git.secretlab.ca/git/linux-2.6
git bisect  bad e777d192ffb9f2929d547a2f8a5f65b7db7a9552  # 00:25      0-      4  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect good 50851c6248e1a13c45d97c41f6ebcf716093aa5e  # 00:43     20+      0  Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux
git bisect good 698d601224824bc1a5bf17f3d86be902e2aabff0  # 01:11     20+      0  Merge tag 'drivers' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good 8d9ea7172edd2e52da26b9485b4c97969a0d2648  # 01:34     20+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect  bad 66cdd0ceaf65a18996f561b770eedde1d123b019  # 01:57      0-      3  Merge tag 'kvm-3.8-1' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good 3127f23f013eabe9b58132c05061684c49146ba3  # 02:12     20+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
git bisect good c7708fac5a878d6e0f2de0aa19f9749cff4f707f  # 02:31     20+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect good 896ea17d3da5f44b2625c9cda9874d7dfe447393  # 02:42     20+      0  Merge tag 'stable/for-linus-3.8-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen
git bisect good 8455d79e2163997e479931b8d5b7e60a92cd2b86  # 02:49     20+      0  KVM: PPC: Book3S HV: Run virtual core whenever any vcpus in it can run
git bisect  bad 78c634402a1825f1f5bef13077f0985f3b8a3212  # 03:10      0-      6  kvm: deliver msi interrupts from irq handler
git bisect good 189e11731aa858597095fbe1e6d243bad26bd96b  # 03:44     20+      0  x86: pvclock: add note about rdtsc barriers
git bisect  bad b48aa97e38206a84bf8485e7c553412274708ce5  # 04:09      0-     11  KVM: x86: require matched TSC offsets for master clock
git bisect  bad 886b470cb14733a0286e365c77f1844c240c33a4  # 04:33      0-     13  KVM: x86: pass host_tsc to read_l1_tsc
git bisect good 71056ae22d43f58d7e0f793af18ace2eaf5b74eb  # 04:58     20+      0  x86: pvclock: generic pvclock vsyscall initialization
git bisect  bad 51c19b4f5927f5a646e93d69f73c7e89ea14e737  # 05:16      0-     15  x86: vdso: pvclock gettime support
git bisect  bad 3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a  # 05:40      0-      6  x86: kvm guest: pvclock vsyscall support
# first bad commit: [3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a] x86: kvm guest: pvclock vsyscall support
git bisect good 71056ae22d43f58d7e0f793af18ace2eaf5b74eb  # 05:42     60+      0  x86: pvclock: generic pvclock vsyscall initialization
git bisect good d67a0e110187abd560a1de63fa172894a52839d5  # 05:45     60+      0  morphologies: Enable CONFIG_FHANDLE
git bisect good 0e04c641b199435f3779454055f6a7de258ecdfc  # 06:06     60+      0  Merge tag 'dm-3.16-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
git bisect good b1cce620fd4b6864c92e7307be7839789f9c8be0  # 06:09     60+      0  Add linux-next specific files for 20140612


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


--------------030807040400090905020506
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-yocto-ivb42-10:20140613054112:x86_64-randconfig-j1-0612:3.7.0-rc3-00112-g3dc4f7c:37"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-yocto-ivb42-10:20140613054112:x86_64-randconfig-j1-061";
 filename*1="2:3.7.0-rc3-00112-g3dc4f7c:37"

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-rc3-00112-g3dc4f7c (kbuild@jaketown) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #37 SMP Fri Jun 13 05:38:51 CST 201=
4
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ra=
m0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-j1-0612/basero=
ck:baserock:morph:3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a:bisect-linux8/=
=2Evmlinuz-3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a-20140613053911-4-ivb4=
2 branch=3Dbaserock/baserock/morph BOOT_IMAGE=3D/kernel/x86_64-randconfig=
-j1-0612/3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a/vmlinuz-3.7.0-rc3-00112=
-g3dc4f7c drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped a=
t [ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x13ffdfff]
[    0.000000]  [mem 0x00000000-0x13ffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x13ffdfff @ [mem 0x13c=
44000-0x13ce5fff]
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: RSDP 00000000000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013ffe450 00034 (v01 BOCHS  BXPCRSDT 000=
00001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013ffff80 00074 (v01 BOCHS  BXPCFACP 000=
00001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013ffe490 011A9 (v01   BXPC   BXDSDT 000=
00001 INTL 20100528)
[    0.000000] ACPI: FACS 0000000013ffff40 00040
[    0.000000] ACPI: SSDT 0000000013fff7a0 00796 (v01 BOCHS  BXPCSSDT 000=
00001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fff680 00080 (v01 BOCHS  BXPCAPIC 000=
00001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fff640 00038 (v01 BOCHS  BXPCHPET 000=
00001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81805
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 76606 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/pvclock.c:182 pvclock_init_vsy=
scall+0x21/0x59()
[    0.000000] Hardware name: Bochs
[    0.000000] Pid: 0, comm: swapper Not tainted 3.7.0-rc3-00112-g3dc4f7c=
 #37
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81062255>] warn_slowpath_common+0x7c/0x94
[    0.000000]  [<ffffffff81062343>] warn_slowpath_null+0x1a/0x1c
[    0.000000]  [<ffffffff81cdd7c9>] pvclock_init_vsyscall+0x21/0x59
[    0.000000]  [<ffffffff81cdd75b>] kvm_setup_vsyscall_timeinfo+0x59/0x8=
b
[    0.000000]  [<ffffffff81cdd4cf>] kvm_guest_init+0xe4/0xfe
[    0.000000]  [<ffffffff81cd2f9e>] setup_arch+0xa64/0xad9
[    0.000000]  [<ffffffff81cd0893>] start_kernel+0xdc/0x430
[    0.000000]  [<ffffffff81cd0120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81cd02b4>] x86_64_start_reservations+0xb0/0xb3
[    0.000000]  [<ffffffff81cd03b9>] x86_64_start_kernel+0x102/0x10f
[    0.000000] ---[ end trace c4149eb8555303de ]---
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff880013600000 s1916032 =
r0 d21376 u2097152
[    0.000000] pcpu-alloc: s1916032 r0 d21376 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1360dc80
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-j1-0612=
/baserock:baserock:morph:3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a:bisect-=
linux8/.vmlinuz-3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a-20140613053911-4=
-ivb42 branch=3Dbaserock/baserock/morph BOOT_IMAGE=3D/kernel/x86_64-randc=
onfig-j1-0612/3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a/vmlinuz-3.7.0-rc3-=
00112-g3dc4f7c drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 by=
tes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 289064k/327672k available (4465k kernel code, 452k=
 absent, 38156k reserved, 6778k data, 2312k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-rc3-00112-g3dc4f7c (kbuild@jaketown) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #37 SMP Fri Jun 13 05:38:51 CST 201=
4
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ra=
m0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-j1-0612/basero=
ck:baserock:morph:3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a:bisect-linux8/=
=2Evmlinuz-3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a-20140613053911-4-ivb4=
2 branch=3Dbaserock/baserock/morph BOOT_IMAGE=3D/kernel/x86_64-randconfig=
-j1-0612/3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a/vmlinuz-3.7.0-rc3-00112=
-g3dc4f7c drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped a=
t [ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x13ffdfff]
[    0.000000]  [mem 0x00000000-0x13ffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x13ffdfff @ [mem 0x13c=
44000-0x13ce5fff]
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: RSDP 00000000000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013ffe450 00034 (v01 BOCHS  BXPCRSDT 000=
00001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013ffff80 00074 (v01 BOCHS  BXPCFACP 000=
00001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013ffe490 011A9 (v01   BXPC   BXDSDT 000=
00001 INTL 20100528)
[    0.000000] ACPI: FACS 0000000013ffff40 00040
[    0.000000] ACPI: SSDT 0000000013fff7a0 00796 (v01 BOCHS  BXPCSSDT 000=
00001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fff680 00080 (v01 BOCHS  BXPCAPIC 000=
00001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fff640 00038 (v01 BOCHS  BXPCHPET 000=
00001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81805
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 76606 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/pvclock.c:182 pvclock_init_vsy=
scall+0x21/0x59()
[    0.000000] Hardware name: Bochs
[    0.000000] Pid: 0, comm: swapper Not tainted 3.7.0-rc3-00112-g3dc4f7c=
 #37
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81062255>] warn_slowpath_common+0x7c/0x94
[    0.000000]  [<ffffffff81062343>] warn_slowpath_null+0x1a/0x1c
[    0.000000]  [<ffffffff81cdd7c9>] pvclock_init_vsyscall+0x21/0x59
[    0.000000]  [<ffffffff81cdd75b>] kvm_setup_vsyscall_timeinfo+0x59/0x8=
b
[    0.000000]  [<ffffffff81cdd4cf>] kvm_guest_init+0xe4/0xfe
[    0.000000]  [<ffffffff81cd2f9e>] setup_arch+0xa64/0xad9
[    0.000000]  [<ffffffff81cd0893>] start_kernel+0xdc/0x430
[    0.000000]  [<ffffffff81cd0120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81cd02b4>] x86_64_start_reservations+0xb0/0xb3
[    0.000000]  [<ffffffff81cd03b9>] x86_64_start_kernel+0x102/0x10f
[    0.000000] ---[ end trace c4149eb8555303de ]---
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff880013600000 s1916032 =
r0 d21376 u2097152
[    0.000000] pcpu-alloc: s1916032 r0 d21376 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1360dc80
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-j1-0612=
/baserock:baserock:morph:3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a:bisect-=
linux8/.vmlinuz-3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a-20140613053911-4=
-ivb42 branch=3Dbaserock/baserock/morph BOOT_IMAGE=3D/kernel/x86_64-randc=
onfig-j1-0612/3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a/vmlinuz-3.7.0-rc3-=
00112-g3dc4f7c drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 by=
tes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 289064k/327672k available (4465k kernel code, 452k=
 absent, 38156k reserved, 6778k data, 2312k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
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
[    0.000000] ----------------------------------------------------------=
------------------
[    0.000000] ----------------------------------------------------------=
------------------
[    0.000000]                                  | spin |wlock |rlock |mut=
ex | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mut=
ex | wsem | rsem |
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |          =
   |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |          =
   |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |          =
   |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |          =
   |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  | =
 ok  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  | =
 ok  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

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
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.556 MHz processor
[    0.000000] tsc: Detected 2693.556 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value..=20
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.57 Bo=
goMIPS (lpj=3D8978520)
5389.57 BogoMIPS (lpj=3D8978520)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006860] Security Framework initialized
[    0.006860] Security Framework initialized
[    0.007662] Mount-cache hash table entries: 256
[    0.007662] Mount-cache hash table entries: 256
[    0.009182] Initializing cgroup subsys devices
[    0.009182] Initializing cgroup subsys devices
[    0.010097] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010097] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010097] tlb_flushall_shift: 6
[    0.010097] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010097] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010097] tlb_flushall_shift: 6
[    0.012518] debug: unmapping init [mem 0xffffffff81d3e000-0xffffffff81=
d3ffff]
[    0.012518] debug: unmapping init [mem 0xffffffff81d3e000-0xffffffff81=
d3ffff]
[    0.014208] ACPI: Core revision 20120913
[    0.014208] ACPI: Core revision 20120913
[    0.018132] Getting VERSION: 50014
[    0.018132] Getting VERSION: 50014
[    0.018759] Getting VERSION: 50014
[    0.018759] Getting VERSION: 50014
[    0.019352] Getting ID: 0
[    0.019352] Getting ID: 0
[    0.019825] Getting ID: ff000000
[    0.019825] Getting ID: ff000000
[    0.020010] Getting LVT0: 8700
[    0.020010] Getting LVT0: 8700
[    0.020566] Getting LVT1: 8400
[    0.020566] Getting LVT1: 8400
[    0.021140] enabled ExtINT on CPU#0
[    0.021140] enabled ExtINT on CPU#0
[    0.022478] ENABLING IO-APIC IRQs
[    0.022478] ENABLING IO-APIC IRQs
[    0.023340] init IO_APIC IRQs
[    0.023340] init IO_APIC IRQs
[    0.023863]  apic 0 pin 0 not connected
[    0.023863]  apic 0 pin 0 not connected
[    0.024561] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.024561] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.026011] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.026011] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.026690] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.026690] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.028150] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.028150] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.030022] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.030022] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.031417] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.031417] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.033360] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.033360] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.034769] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.034769] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.036208] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.036208] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.036688] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.036688] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.038111] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.038111] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.040022] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.040022] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.041471] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.041471] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.043354] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.043354] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.044780] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.044780] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.046294]  apic 0 pin 16 not connected
[    0.046294]  apic 0 pin 16 not connected
[    0.046671]  apic 0 pin 17 not connected
[    0.046671]  apic 0 pin 17 not connected
[    0.047354]  apic 0 pin 18 not connected
[    0.047354]  apic 0 pin 18 not connected
[    0.048079]  apic 0 pin 19 not connected
[    0.048079]  apic 0 pin 19 not connected
[    0.048791]  apic 0 pin 20 not connected
[    0.048791]  apic 0 pin 20 not connected
[    0.050004]  apic 0 pin 21 not connected
[    0.050004]  apic 0 pin 21 not connected
[    0.050692]  apic 0 pin 22 not connected
[    0.050692]  apic 0 pin 22 not connected
[    0.051397]  apic 0 pin 23 not connected
[    0.051397]  apic 0 pin 23 not connected
[    0.052219] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.052219] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.053337] smpboot: CPU0:=20
[    0.053337] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM =
processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.055081] Using local APIC timer interrupts.
[    0.055081] calibrating APIC timer ...
[    0.055081] Using local APIC timer interrupts.
[    0.055081] calibrating APIC timer ...
[    0.059999] ... lapic delta =3D 6250126
[    0.059999] ... lapic delta =3D 6250126
[    0.059999] ... PM-Timer delta =3D 357928
[    0.059999] ... PM-Timer delta =3D 357928
[    0.059999] ... PM-Timer result ok
[    0.059999] ... PM-Timer result ok
[    0.059999] ..... delta 6250126
[    0.059999] ..... delta 6250126
[    0.059999] ..... mult: 268440894
[    0.059999] ..... mult: 268440894
[    0.059999] ..... calibration result: 3333400
[    0.059999] ..... calibration result: 3333400
[    0.059999] ..... CPU clock speed is 2693.1789 MHz.
[    0.059999] ..... CPU clock speed is 2693.1789 MHz.
[    0.059999] ..... host bus clock speed is 1000.0400 MHz.
[    0.059999] ..... host bus clock speed is 1000.0400 MHz.
[    0.060038] Performance Events:=20
[    0.060038] Performance Events: unsupported Netburst CPU model 6 unsup=
ported Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.062635] ftrace: Allocated trace_printk buffers
[    0.062635] ftrace: Allocated trace_printk buffers
[    0.064112] SMP alternatives: lockdep: fixing up alternatives
[    0.064112] SMP alternatives: lockdep: fixing up alternatives
[    0.065353] smpboot: Booting Node   0, Processors=20
[    0.065353] smpboot: Booting Node   0, Processors  #1 OK
 #1 OK
[    0.006666] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.080103] Brought up 2 CPUs
[    0.080103] Brought up 2 CPUs
[    0.080041] KVM setup async PF for cpu 1
[    0.080041] KVM setup async PF for cpu 1
[    0.080041] kvm-stealtime: cpu 1, msr 1380dc80
[    0.080041] kvm-stealtime: cpu 1, msr 1380dc80
[    0.083342] ----------------
[    0.083342] ----------------
[    0.083871] | NMI testsuite:
[    0.083871] | NMI testsuite:
[    0.084345] --------------------
[    0.084345] --------------------
[    0.084913]   remote IPI:
[    0.084913]   remote IPI:  ok  |  ok  |

[    0.100221]    local IPI:
[    0.100221]    local IPI:  ok  |  ok  |

[    0.133346] --------------------
[    0.133346] --------------------
[    0.133919] Good, all   2 testcases passed! |
[    0.133919] Good, all   2 testcases passed! |
[    0.134668] ---------------------------------
[    0.134668] ---------------------------------
[    0.135413] smpboot: Total of 2 processors activated (10778.15 BogoMIP=
S)
[    0.135413] smpboot: Total of 2 processors activated (10778.15 BogoMIP=
S)
[    0.137638] devtmpfs: initialized
[    0.137638] devtmpfs: initialized
[    0.141453] EVM: security.capability
[    0.141453] EVM: security.capability
[    0.142976] NET: Registered protocol family 16
[    0.142976] NET: Registered protocol family 16
[    0.144324] ACPI: bus type pci registered
[    0.144324] ACPI: bus type pci registered
[    0.145177] dca service started, version 1.12.1
[    0.145177] dca service started, version 1.12.1
[    0.146005] PCI: Using configuration type 1 for base access
[    0.146005] PCI: Using configuration type 1 for base access
[    0.151232] ACPI: Added _OSI(Module Device)
[    0.151232] ACPI: Added _OSI(Module Device)
[    0.151957] ACPI: Added _OSI(Processor Device)
[    0.151957] ACPI: Added _OSI(Processor Device)
[    0.152716] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.152716] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.153339] ACPI: Added _OSI(Processor Aggregator Device)
[    0.153339] ACPI: Added _OSI(Processor Aggregator Device)
[    0.156283] ACPI: EC: Look up EC in DSDT
[    0.156283] ACPI: EC: Look up EC in DSDT
[    0.162261] ACPI: Interpreter enabled
[    0.162261] ACPI: Interpreter enabled
[    0.162903] ACPI: (supports S0
[    0.162903] ACPI: (supports S0 S3 S3 S5 S5)
)
[    0.163552] ACPI: Using IOAPIC for interrupt routing
[    0.163552] ACPI: Using IOAPIC for interrupt routing
[    0.172151] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.172151] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.173524] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.173524] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.175015] PCI host bridge to bus 0000:00
[    0.175015] PCI host bridge to bus 0000:00
[    0.175766] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.175766] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.176672] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.176672] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.177754] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.177754] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.178802] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.178802] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.180019] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebff=
fff]
[    0.180019] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebff=
fff]
[    0.181316] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.181316] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.182668] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.182668] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.183782] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.183782] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.187815] pci 0000:00:01.1: reg 20: [io  0xc040-0xc04f]
[    0.187815] pci 0000:00:01.1: reg 20: [io  0xc040-0xc04f]
[    0.189791] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.189791] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.190369] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PI=
IX4 ACPI
[    0.190369] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PI=
IX4 ACPI
[    0.191620] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PI=
IX4 SMB
[    0.191620] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PI=
IX4 SMB
[    0.193510] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.193510] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.197255] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]=

[    0.197255] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]=

[    0.200052] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.200052] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.207228] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]=

[    0.207228] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]=

[    0.208581] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.208581] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.210438] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.210438] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.212293] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.212293] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.217500] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]=

[    0.217500] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]=

[    0.218739] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.218739] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.220226] pci 0000:00:04.0: reg 10: [mem 0xfebf1000-0xfebf100f]
[    0.220226] pci 0000:00:04.0: reg 10: [mem 0xfebf1000-0xfebf100f]
[    0.224051] pci_bus 0000:00: on NUMA node 0
[    0.224051] pci_bus 0000:00: on NUMA node 0
[    0.224824] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.224824] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.227542]  pci0000:00: ACPI _OSC support notification failed, disabl=
ing PCIe ASPM
[    0.227542]  pci0000:00: ACPI _OSC support notification failed, disabl=
ing PCIe ASPM
[    0.228860]  pci0000:00: Unable to request _OSC control (_OSC support =
mask: 0x08)
[    0.228860]  pci0000:00: Unable to request _OSC control (_OSC support =
mask: 0x08)
[    0.237833] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.237833] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.239021] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.239021] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.240188] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.240188] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.241359] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.241359] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.242467] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.242467] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.243998] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.243998] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.245423] vgaarb: loaded
[    0.245423] vgaarb: loaded
[    0.245912] vgaarb: bridge control possible 0000:00:02.0
[    0.245912] vgaarb: bridge control possible 0000:00:02.0
[    0.247002] Error: Driver '88PM80X' is already registered, aborting...=

[    0.247002] Error: Driver '88PM80X' is already registered, aborting...=

[    0.248617] wmi: Mapper loaded
[    0.248617] wmi: Mapper loaded
[    0.249278] Advanced Linux Sound Architecture Driver Initialized.
[    0.249278] Advanced Linux Sound Architecture Driver Initialized.
[    0.250008] PCI: Using ACPI for IRQ routing
[    0.250008] PCI: Using ACPI for IRQ routing
[    0.250741] PCI: pci_cache_line_size set to 64 bytes
[    0.250741] PCI: pci_cache_line_size set to 64 bytes
[    0.251746] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.251746] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.252790] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.252790] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.254268] HPET: 3 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.254268] HPET: 3 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.257000] Switching to clocksource kvm-clock
[    0.257000] Switching to clocksource kvm-clock
[    0.267038] FS-Cache: Loaded
[    0.267038] FS-Cache: Loaded
[    0.267605] pnp: PnP ACPI init
[    0.267605] pnp: PnP ACPI init
[    0.268185] ACPI: bus type pnp registered
[    0.268185] ACPI: bus type pnp registered
[    0.269012] pnp 00:00: [bus 00-ff]
[    0.269012] pnp 00:00: [bus 00-ff]
[    0.269603] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.269603] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.270324] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.270324] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.271133] pnp 00:00: [io  0x0d00-0xffff window]
[    0.271133] pnp 00:00: [io  0x0d00-0xffff window]
[    0.271949] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.271949] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.272870] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.272870] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.273905] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)=

[    0.273905] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)=

[    0.275073] pnp 00:01: [io  0x0070-0x0071]
[    0.275073] pnp 00:01: [io  0x0070-0x0071]
[    0.275797] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:3)
[    0.275797] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:3)
[    0.277180] pnp 00:01: [irq 8]
[    0.277180] pnp 00:01: [irq 8]
[    0.277715] pnp 00:01: [io  0x0072-0x0077]
[    0.277715] pnp 00:01: [io  0x0072-0x0077]
[    0.278477] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.278477] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.279625] pnp 00:02: [io  0x0060]
[    0.279625] pnp 00:02: [io  0x0060]
[    0.280250] pnp 00:02: [io  0x0064]
[    0.280250] pnp 00:02: [io  0x0064]
[    0.280858] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:3)
[    0.280858] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:3)
[    0.282228] pnp 00:02: [irq 1]
[    0.282228] pnp 00:02: [irq 1]
[    0.282820] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)=

[    0.282820] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)=

[    0.283993] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:3)
[    0.283993] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:3)
[    0.285416] pnp 00:03: [irq 12]
[    0.285416] pnp 00:03: [irq 12]
[    0.286030] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)=

[    0.286030] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)=

[    0.287206] pnp 00:04: [io  0x03f2-0x03f5]
[    0.287206] pnp 00:04: [io  0x03f2-0x03f5]
[    0.287907] pnp 00:04: [io  0x03f7]
[    0.287907] pnp 00:04: [io  0x03f7]
[    0.288517] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:3)
[    0.288517] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:3)
[    0.289928] pnp 00:04: [irq 6]
[    0.289928] pnp 00:04: [irq 6]
[    0.290502] pnp 00:04: [dma 2]
[    0.290502] pnp 00:04: [dma 2]
[    0.291092] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)=

[    0.291092] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)=

[    0.292291] pnp 00:05: [io  0x0378-0x037f]
[    0.292291] pnp 00:05: [io  0x0378-0x037f]
[    0.293031] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:3)
[    0.293031] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:3)
[    0.294442] pnp 00:05: [irq 7]
[    0.294442] pnp 00:05: [irq 7]
[    0.295043] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)=

[    0.295043] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)=

[    0.296216] pnp 00:06: [io  0x03f8-0x03ff]
[    0.296216] pnp 00:06: [io  0x03f8-0x03ff]
[    0.296945] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:3)
[    0.296945] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:3)
[    0.298343] pnp 00:06: [irq 4]
[    0.298343] pnp 00:06: [irq 4]
[    0.298937] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.298937] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.300146] pnp 00:07: [io  0x02f8-0x02ff]
[    0.300146] pnp 00:07: [io  0x02f8-0x02ff]
[    0.300881] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:3)
[    0.300881] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:3)
[    0.302261] pnp 00:07: [irq 3]
[    0.302261] pnp 00:07: [irq 3]
[    0.302860] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.302860] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.304267] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[    0.304267] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[    0.305166] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)=

[    0.305166] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)=

[    0.306477] pnp: PnP ACPI: found 9 devices
[    0.306477] pnp: PnP ACPI: found 9 devices
[    0.307199] ACPI: ACPI bus type pnp unregistered
[    0.307199] ACPI: ACPI bus type pnp unregistered
[    0.307995] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.307995] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.314682] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.314682] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.315641] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.315641] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.316587] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.316587] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.317658] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.317658] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.318794] NET: Registered protocol family 1
[    0.318794] NET: Registered protocol family 1
[    0.319557] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.319557] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.320603] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.320603] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.321601] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.321601] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.322671] pci 0000:00:02.0: Boot video device
[    0.322671] pci 0000:00:02.0: Boot video device
[    0.323481] PCI: CLS 0 bytes, default 64
[    0.323481] PCI: CLS 0 bytes, default 64
[    0.324353] Unpacking initramfs...
[    0.324353] Unpacking initramfs...
[    0.407913] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013=
feffff]
[    0.407913] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013=
feffff]
[    0.410474] camellia-x86_64: performance on this CPU would be suboptim=
al: disabling camellia-x86_64.
[    0.410474] camellia-x86_64: performance on this CPU would be suboptim=
al: disabling camellia-x86_64.
[    0.410513] cryptomgr_test (23) used greatest stack depth: 6616 bytes =
left
[    0.410513] cryptomgr_test (23) used greatest stack depth: 6616 bytes =
left
[    0.413213] AVX instructions are not detected.
[    0.413213] AVX instructions are not detected.
[    0.413991] blowfish-x86_64: performance on this CPU would be suboptim=
al: disabling blowfish-x86_64.
[    0.413991] blowfish-x86_64: performance on this CPU would be suboptim=
al: disabling blowfish-x86_64.
[    0.415710] twofish-x86_64-3way: performance on this CPU would be subo=
ptimal: disabling twofish-x86_64-3way.
[    0.415710] twofish-x86_64-3way: performance on this CPU would be subo=
ptimal: disabling twofish-x86_64-3way.
[    0.417400] AVX instructions are not detected.
[    0.417400] AVX instructions are not detected.
[    0.419280] AVX instructions are not detected.
[    0.419280] AVX instructions are not detected.
[    0.421390] Initializing RT-Tester: OK
[    0.421390] Initializing RT-Tester: OK
[    0.427295] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.427295] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.428077] fuse init (API version 7.20)
[    0.428077] fuse init (API version 7.20)
[    0.429047] msgmni has been set to 564
[    0.429047] msgmni has been set to 564
[    0.433556] Key type asymmetric registered
[    0.433556] Key type asymmetric registered
[    0.434289] Asymmetric key parser 'x509' registered
[    0.434289] Asymmetric key parser 'x509' registered
[    0.436569] list_sort_test: start testing list_sort()
[    0.436569] list_sort_test: start testing list_sort()
[    0.438136] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    0.438136] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    0.438998] crc32: self tests passed, processed 225944 bytes in 148882=
 nsec
[    0.438998] crc32: self tests passed, processed 225944 bytes in 148882=
 nsec
[    0.440329] crc32c: CRC_LE_BITS =3D 64
[    0.440329] crc32c: CRC_LE_BITS =3D 64
[    0.440946] crc32c: self tests passed, processed 225944 bytes in 74372=
 nsec
[    0.440946] crc32c: self tests passed, processed 225944 bytes in 74372=
 nsec
[    0.442252] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.442252] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.443313] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    0.443313] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    0.444505] shpchp: Standard Hot Plug PCI Controller Driver version: 0=
=2E4
[    0.444505] shpchp: Standard Hot Plug PCI Controller Driver version: 0=
=2E4
[    0.445887] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
[    0.445887] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
[    0.447197] ACPI: Power Button [PWRF]
[    0.447197] ACPI: Power Button [PWRF]
[    0.451284] GHES: HEST is not enabled!
[    0.451284] GHES: HEST is not enabled!
[    0.451929] ERST DBG: ERST support is disabled.
[    0.451929] ERST DBG: ERST support is disabled.
[    0.452699] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.452699] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.497051] r3964: Philips r3964 Driver $Revision: 1.10 $
[    0.497051] r3964: Philips r3964 Driver $Revision: 1.10 $
[    0.498000] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.498000] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.524757] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.524757] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.527081] Non-volatile memory driver v1.3
[    0.527081] Non-volatile memory driver v1.3
[    0.527856] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    0.527856] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    0.528750] smapi::smapi_init, ERROR invalid usSmapiID
[    0.528750] smapi::smapi_init, ERROR invalid usSmapiID
[    0.529628] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI =
is not available on this machine
[    0.529628] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI =
is not available on this machine
[    0.531208] mwave: mwavedd::mwave_init: Error: Failed to initialize bo=
ard data
[    0.531208] mwave: mwavedd::mwave_init: Error: Failed to initialize bo=
ard data
[    0.532426] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    0.532426] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    0.533543] SyncLink PC Card driver $Revision: 4.34 $, tty major#251
[    0.533543] SyncLink PC Card driver $Revision: 4.34 $, tty major#251
[    0.534689] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 sec=
onds, margin is 60 seconds).
[    0.534689] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 sec=
onds, margin is 60 seconds).
[    0.536215] Hangcheck: Using getrawmonotonic().
[    0.536215] Hangcheck: Using getrawmonotonic().
[    0.537136] ibmasm: IBM ASM Service Processor Driver version 1.0 loade=
d
[    0.537136] ibmasm: IBM ASM Service Processor Driver version 1.0 loade=
d
[    0.538348] Phantom Linux Driver, version n0.9.8, init OK
[    0.538348] Phantom Linux Driver, version n0.9.8, init OK
[    0.539398] i2c-core: driver [apds9802als] using legacy suspend method=

[    0.539398] i2c-core: driver [apds9802als] using legacy suspend method=

[    0.540523] i2c-core: driver [apds9802als] using legacy resume method
[    0.540523] i2c-core: driver [apds9802als] using legacy resume method
[    0.541629] i2c-core: driver [isl29003] using legacy suspend method
[    0.541629] i2c-core: driver [isl29003] using legacy suspend method
[    0.542694] i2c-core: driver [isl29003] using legacy resume method
[    0.542694] i2c-core: driver [isl29003] using legacy resume method
[    0.543776] i2c-core: driver [tsl2550] using legacy suspend method
[    0.543776] i2c-core: driver [tsl2550] using legacy suspend method
[    0.544828] i2c-core: driver [tsl2550] using legacy resume method
[    0.544828] i2c-core: driver [tsl2550] using legacy resume method
[    0.545889] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo =
Giometti
[    0.545889] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo =
Giometti
[    0.547280] i2c-core: driver [fsa9480] using legacy suspend method
[    0.547280] i2c-core: driver [fsa9480] using legacy suspend method
[    0.548340] i2c-core: driver [fsa9480] using legacy resume method
[    0.548340] i2c-core: driver [fsa9480] using legacy resume method
[    0.549810] mtdoops: mtd device (mtddev=3Dname/number) must be supplie=
d
[    0.549810] mtdoops: mtd device (mtddev=3Dname/number) must be supplie=
d
[    0.550941] device id =3D 2440
[    0.550941] device id =3D 2440
[    0.551445] device id =3D 2480
[    0.551445] device id =3D 2480
[    0.551946] device id =3D 24c0
[    0.551946] device id =3D 24c0
[    0.552443] device id =3D 24d0
[    0.552443] device id =3D 24d0
[    0.552942] device id =3D 25a1
[    0.552942] device id =3D 25a1
[    0.553452] device id =3D 2670
[    0.553452] device id =3D 2670
[    0.554023] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    0.554023] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    0.555125] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Norte=
l Networks.
[    0.555125] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Norte=
l Networks.
[    0.556412] pmc551: not detected
[    0.556412] pmc551: not detected
[    0.561532] I2O subsystem v1.325
[    0.561532] I2O subsystem v1.325
[    0.562113] i2o: max drivers =3D 8
[    0.562113] i2o: max drivers =3D 8
[    0.563417] I2O Configuration OSM v1.323
[    0.563417] I2O Configuration OSM v1.323
[    0.564184] I2O Bus Adapter OSM v1.317
[    0.564184] I2O Bus Adapter OSM v1.317
[    0.564848] I2O ProcFS OSM v1.316
[    0.564848] I2O ProcFS OSM v1.316
[    0.696896] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[    0.696896] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[    0.698164] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0=
x60,0x64 irq 1,12
[    0.698164] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0=
x60,0x64 irq 1,12
[    0.700371] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.700371] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.701260] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.701260] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.748607] mousedev: PS/2 mouse device common for all mice
[    0.748607] mousedev: PS/2 mouse device common for all mice
[    0.750269] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input1
[    0.750269] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input1
[    0.827235] i2c /dev entries driver
[    0.827235] i2c /dev entries driver
[    0.828119] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100,=
 revision 0
[    0.828119] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100,=
 revision 0
[    0.923547] i2c-parport-light: adapter type unspecified
[    0.923547] i2c-parport-light: adapter type unspecified
[    0.924448] Driver for 1-wire Dallas network protocol.
[    0.924448] Driver for 1-wire Dallas network protocol.
[    0.925428] 1-Wire driver for the DS2760 battery monitor  chip  - (c) =
2004-2005, Szabolcs Gyurko
[    0.925428] 1-Wire driver for the DS2760 battery monitor  chip  - (c) =
2004-2005, Szabolcs Gyurko
[    0.927062] i2c-core: driver [max17040] using legacy suspend method
[    0.927062] i2c-core: driver [max17040] using legacy suspend method
[    0.928141] i2c-core: driver [max17040] using legacy resume method
[    0.928141] i2c-core: driver [max17040] using legacy resume method
[    1.261425] input: ImExPS/2 Generic Explorer Mouse as /devices/platfor=
m/i8042/serio1/input/input2
[    1.261425] input: ImExPS/2 Generic Explorer Mouse as /devices/platfor=
m/i8042/serio1/input/input2
[    1.410072] tsc: Refined TSC clocksource calibration: 2693.472 MHz
[    1.410072] tsc: Refined TSC clocksource calibration: 2693.472 MHz
[    1.656715] i2c i2c-0: detect fail: address match, 0x2c
[    1.656715] i2c i2c-0: detect fail: address match, 0x2c
[    1.670054] i2c i2c-0: detect fail: address match, 0x2d
[    1.670054] i2c i2c-0: detect fail: address match, 0x2d
[    1.683379] i2c i2c-0: detect fail: address match, 0x2e
[    1.683379] i2c i2c-0: detect fail: address match, 0x2e
[    1.696711] i2c i2c-0: detect fail: address match, 0x2f
[    1.696711] i2c i2c-0: detect fail: address match, 0x2f
[    1.796719] applesmc: supported laptop not found!
[    1.796719] applesmc: supported laptop not found!
[    1.797533] applesmc: driver init failed (ret=3D-19)!
[    1.797533] applesmc: driver init failed (ret=3D-19)!
[    8.613471] pc87360: PC8736x not detected, module not inserted
[    8.613471] pc87360: PC8736x not detected, module not inserted
[    8.840308] acquirewdt: WDT driver for Acquire single board computer i=
nitialising
[    8.840308] acquirewdt: WDT driver for Acquire single board computer i=
nitialising
[    8.841726] acquirewdt: I/O address 0x0043 already in use
[    8.841726] acquirewdt: I/O address 0x0043 already in use
[    8.842657] acquirewdt: probe of acquirewdt failed with error -5
[    8.842657] acquirewdt: probe of acquirewdt failed with error -5
[    8.843716] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    8.843716] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    8.844639] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    8.844639] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    8.845679] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    8.845679] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    8.850125] ib700wdt: WDT driver for IB700 single board computer initi=
alising
[    8.850125] ib700wdt: WDT driver for IB700 single board computer initi=
alising
[    8.851639] wafer5823wdt: WDT driver for Wafer 5823 single board compu=
ter initialising
[    8.851639] wafer5823wdt: WDT driver for Wafer 5823 single board compu=
ter initialising
[    8.853006] wafer5823wdt: I/O address 0x0443 already in use
[    8.853006] wafer5823wdt: I/O address 0x0443 already in use
[    8.853974] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    8.853974] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    8.855022] sc1200wdt: build 20020303
[    8.855022] sc1200wdt: build 20020303
[    8.855689] sc1200wdt: io parameter must be specified
[    8.855689] sc1200wdt: io parameter must be specified
[    8.856574] pc87413_wdt: Version 1.1 at io 0x2E
[    8.856574] pc87413_wdt: Version 1.1 at io 0x2E
[    8.857391] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    8.857391] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    8.858529] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    8.858529] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    8.859486] sbc60xxwdt: I/O address 0x0443 already in use
[    8.859486] sbc60xxwdt: I/O address 0x0443 already in use
[    8.860429] sbc8360: failed to register misc device
[    8.860429] sbc8360: failed to register misc device
[    8.861311] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 =
initialising...
[    8.861311] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 =
initialising...
[    8.863717] smsc37b787_wdt: Unable to register miscdev on minor 130
[    8.863717] smsc37b787_wdt: Unable to register miscdev on minor 130
[    8.864824] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/=
HG/DHG Super I/O chip initialising
[    8.864824] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/=
HG/DHG Super I/O chip initialising
[    8.866484] w83627hf_wdt: Watchdog already running. Resetting timeout =
to 60 sec
[    8.866484] w83627hf_wdt: Watchdog already running. Resetting timeout =
to 60 sec
[    8.867781] w83627hf_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    8.867781] w83627hf_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    8.868931] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    8.868931] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    8.869989] w83697hf_wdt: watchdog not found at address 0x2e
[    8.869989] w83697hf_wdt: watchdog not found at address 0x2e
[    8.870965] w83697hf_wdt: No W83697HF/HG could be found
[    8.870965] w83697hf_wdt: No W83697HF/HG could be found
[    8.871873] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF S=
uper I/O chip initialising
[    8.871873] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF S=
uper I/O chip initialising
[    8.873394] w83697ug_wdt: No W83697UG/UF could be found
[    8.873394] w83697ug_wdt: No W83697UG/UF could be found
[    8.874289] w83977f_wdt: driver v1.00
[    8.874289] w83977f_wdt: driver v1.00
[    8.874927] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    8.874927] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    8.876106] watchdog: Software Watchdog: cannot register miscdev on mi=
nor=3D130 (err=3D-16).
[    8.876106] watchdog: Software Watchdog: cannot register miscdev on mi=
nor=3D130 (err=3D-16).
[    8.877508] watchdog: Software Watchdog: a legacy watchdog module is p=
robably present.
[    8.877508] watchdog: Software Watchdog: a legacy watchdog module is p=
robably present.
[    8.878975] softdog: Software Watchdog Timer: 0.08 initialized. soft_n=
oboot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    8.878975] softdog: Software Watchdog Timer: 0.08 initialized. soft_n=
oboot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    8.880919] cpuidle: using governor ladder
[    8.880919] cpuidle: using governor ladder
[    8.881663] sdhci: Secure Digital Host Controller Interface driver
[    8.881663] sdhci: Secure Digital Host Controller Interface driver
[    8.882720] sdhci: Copyright(c) Pierre Ossman
[    8.882720] sdhci: Copyright(c) Pierre Ossman
[    8.883497] sdhci-pltfm: SDHCI platform and OF driver helper
[    8.883497] sdhci-pltfm: SDHCI platform and OF driver helper
[    8.950270] leds_ss4200: no LED devices found
[    8.950270] leds_ss4200: no LED devices found
[   12.300077]  (null): enodev DEV ADDR =3D 0xFF
[   12.300077]  (null): enodev DEV ADDR =3D 0xFF
[   12.301440] hv_vmbus: registering driver hid_hyperv
[   12.301440] hv_vmbus: registering driver hid_hyperv
[   12.302413] asus_wmi: Asus Management GUID not found
[   12.302413] asus_wmi: Asus Management GUID not found

[   12.303396] asus_wmi: Management GUID not found
[   12.303396] asus_wmi: Management GUID not found
[   12.304579] dell_wmi: No known WMI GUID found
[   12.304579] dell_wmi: No known WMI GUID found
[   12.305336] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   12.305336] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   12.306283] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Bo=
chs, please report, aborting!
[   12.306283] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Bo=
chs, please report, aborting!
[   12.308119] FUJ02B1: call_fext_func: FUNC interface is not present
[   12.308119] FUJ02B1: call_fext_func: FUNC interface is not present
[   12.309186] fujitsu_laptop: driver 0.6.0 successfully loaded
[   12.309186] fujitsu_laptop: driver 0.6.0 successfully loaded
[   12.310170] fujitsu_tablet: Unknown (using defaults)
[   12.310170] fujitsu_tablet: Unknown (using defaults)
[   12.312126]=20
[   12.312126] printing PIC contents
[   12.312126]=20
[   12.312126] printing PIC contents
[   12.312972] ... PIC  IMR: ffff
[   12.312972] ... PIC  IMR: ffff
[   12.313491] ... PIC  IRR: 1013
[   12.313491] ... PIC  IRR: 1013
[   12.314060] ... PIC  ISR: 0000
[   12.314060] ... PIC  ISR: 0000
[   12.314594] ... PIC ELCR: 0c00
[   12.314594] ... PIC ELCR: 0c00
[   12.315122] printing local APIC contents on CPU#0/0:
[   12.315122] printing local APIC contents on CPU#0/0:
[   12.315987] ... APIC ID:      00000000 (0)
[   12.315987] ... APIC ID:      00000000 (0)
[   12.316696] ... APIC VERSION: 00050014
[   12.316696] ... APIC VERSION: 00050014
[   12.317333] ... APIC TASKPRI: 00000000 (00)
[   12.317333] ... APIC TASKPRI: 00000000 (00)
[   12.317375] ... APIC PROCPRI: 00000000
[   12.317375] ... APIC PROCPRI: 00000000
[   12.317375] ... APIC LDR: 01000000
[   12.317375] ... APIC LDR: 01000000
[   12.317375] ... APIC DFR: ffffffff
[   12.317375] ... APIC DFR: ffffffff
[   12.317375] ... APIC SPIV: 000001ff
[   12.317375] ... APIC SPIV: 000001ff
[   12.317375] ... APIC ISR field:
[   12.317375] ... APIC ISR field:
[   12.317375] 00000000
[   12.317375] 0000000000000000000000000000000000000000000000000000000000=
00000000000000000000000000000000000000000000000000000000000000

[   12.317375] ... APIC TMR field:
[   12.317375] ... APIC TMR field:
[   12.317375] 00000000
[   12.317375] 0000000002000000020000000000000000000000000000000000000000=
00000000000000000000000000000000000000000000000000000000000000

[   12.317375] ... APIC IRR field:
[   12.317375] ... APIC IRR field:
[   12.317375] 00000000
[   12.317375] 0000000000000000000000000000000000000000000000000000000000=
00000000000000000000000000000000000000000000000000800000008000

[   12.317375] ... APIC ESR: 00000000
[   12.317375] ... APIC ESR: 00000000
[   12.317375] ... APIC ICR: 000008fd
[   12.317375] ... APIC ICR: 000008fd
[   12.317375] ... APIC ICR2: 02000000
[   12.317375] ... APIC ICR2: 02000000
[   12.317375] ... APIC LVTT: 000000ef
[   12.317375] ... APIC LVTT: 000000ef
[   12.317375] ... APIC LVTPC: 00010000
[   12.317375] ... APIC LVTPC: 00010000
[   12.317375] ... APIC LVT0: 00010700
[   12.317375] ... APIC LVT0: 00010700
[   12.317375] ... APIC LVT1: 00000400
[   12.317375] ... APIC LVT1: 00000400
[   12.317375] ... APIC LVTERR: 000000fe
[   12.317375] ... APIC LVTERR: 000000fe
[   12.317375] ... APIC TMICT: 00027fe7
[   12.317375] ... APIC TMICT: 00027fe7
[   12.317375] ... APIC TMCCT: 00000000
[   12.317375] ... APIC TMCCT: 00000000
[   12.317375] ... APIC TDCR: 00000003
[   12.317375] ... APIC TDCR: 00000003
[   12.317375]=20
[   12.317375]=20
[   12.332861] number of MP IRQ sources: 15.
[   12.332861] number of MP IRQ sources: 15.
[   12.333556] number of IO-APIC #0 registers: 24.
[   12.333556] number of IO-APIC #0 registers: 24.
[   12.334332] testing the IO APIC.......................
[   12.334332] testing the IO APIC.......................
[   12.335220] IO APIC #0......
[   12.335220] IO APIC #0......
[   12.335722] .... register #00: 00000000
[   12.335722] .... register #00: 00000000
[   12.336382] .......    : physical APIC id: 00
[   12.336382] .......    : physical APIC id: 00
[   12.337141] .......    : Delivery Type: 0
[   12.337141] .......    : Delivery Type: 0
[   12.337834] .......    : LTS          : 0
[   12.337834] .......    : LTS          : 0
[   12.338525] .... register #01: 00170011
[   12.338525] .... register #01: 00170011
[   12.339190] .......     : max redirection entries: 17
[   12.339190] .......     : max redirection entries: 17
[   12.340068] .......     : PRQ implemented: 0
[   12.340068] .......     : PRQ implemented: 0
[   12.340810] .......     : IO APIC version: 11
[   12.340810] .......     : IO APIC version: 11
[   12.341554] .... register #02: 00000000
[   12.341554] .... register #02: 00000000
[   12.342217] .......     : arbitration: 00
[   12.342217] .......     : arbitration: 00
[   12.342907] .... IRQ redirection table:
[   12.342907] .... IRQ redirection table:
[   12.343577]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   12.343577]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   12.344521]  00 00 =20
[   12.344521]  00 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[   12.345438]  01 03 =20
[   12.345438]  01 03  0    0    0   0   0    1    1    31
0    0    0   0   0    1    1    31
[   12.346361]  02 03 =20
[   12.346361]  02 03  0    0    0   0   0    1    1    30
0    0    0   0   0    1    1    30
[   12.347296]  03 03 =20
[   12.347296]  03 03  0    0    0   0   0    1    1    33
0    0    0   0   0    1    1    33
[   12.348221]  04 03 =20
[   12.348221]  04 03  1    0    0   0   0    1    1    34
1    0    0   0   0    1    1    34
[   12.349142]  05 03 =20
[   12.349142]  05 03  1    1    0   0   0    1    1    35
1    1    0   0   0    1    1    35
[   12.350082]  06 03 =20
[   12.350082]  06 03  0    0    0   0   0    1    1    36
0    0    0   0   0    1    1    36
[   12.351001]  07 03 =20
[   12.351001]  07 03  0    0    0   0   0    1    1    37
0    0    0   0   0    1    1    37
[   12.351919]  08 03 =20
[   12.351919]  08 03  0    0    0   0   0    1    1    38
0    0    0   0   0    1    1    38
[   12.352842]  09 03 =20
[   12.352842]  09 03  0    1    0   0   0    1    1    39
0    1    0   0   0    1    1    39
[   12.353771]  0a 03 =20
[   12.353771]  0a 03  1    1    0   0   0    1    1    3A
1    1    0   0   0    1    1    3A
[   12.354696]  0b 03 =20
[   12.354696]  0b 03  1    1    0   0   0    1    1    3B
1    1    0   0   0    1    1    3B
[   12.355614]  0c 03 =20
[   12.355614]  0c 03  0    0    0   0   0    1    1    3C
0    0    0   0   0    1    1    3C
[   12.356524]  0d 03 =20
[   12.356524]  0d 03  0    0    0   0   0    1    1    3D
0    0    0   0   0    1    1    3D
[   12.357458]  0e 03 =20
[   12.357458]  0e 03  0    0    0   0   0    1    1    3E
0    0    0   0   0    1    1    3E
[   12.358375]  0f 03 =20
[   12.358375]  0f 03  0    0    0   0   0    1    1    3F
0    0    0   0   0    1    1    3F
[   12.359293]  10 00 =20
[   12.359293]  10 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[   12.360228]  11 00 =20
[   12.360228]  11 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[   12.361155]  12 00 =20
[   12.361155]  12 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[   12.362077]  13 00 =20
[   12.362077]  13 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[   12.363004]  14 00 =20
[   12.363004]  14 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[   12.363942]  15 00 =20
[   12.363942]  15 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[   12.364867]  16 00 =20
[   12.364867]  16 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[   12.365792]  17 00 =20
[   12.365792]  17 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
[   12.366719] IRQ to pin mappings:
[   12.366719] IRQ to pin mappings:
[   12.367286] IRQ0=20
[   12.367286] IRQ0 -> 0:2-> 0:2

[   12.367748] IRQ1=20
[   12.367748] IRQ1 -> 0:1-> 0:1

[   12.368206] IRQ3=20
[   12.368206] IRQ3 -> 0:3-> 0:3

[   12.368666] IRQ4=20
[   12.368666] IRQ4 -> 0:4-> 0:4

[   12.369122] IRQ5=20
[   12.369122] IRQ5 -> 0:5-> 0:5

[   12.369580] IRQ6=20
[   12.369580] IRQ6 -> 0:6-> 0:6

[   12.370049] IRQ7=20
[   12.370049] IRQ7 -> 0:7-> 0:7

[   12.370509] IRQ8=20
[   12.370509] IRQ8 -> 0:8-> 0:8

[   12.370971] IRQ9=20
[   12.370971] IRQ9 -> 0:9-> 0:9

[   12.371429] IRQ10=20
[   12.371429] IRQ10 -> 0:10-> 0:10

[   12.371919] IRQ11=20
[   12.371919] IRQ11 -> 0:11-> 0:11

[   12.372403] IRQ12=20
[   12.372403] IRQ12 -> 0:12-> 0:12

[   12.372894] IRQ13=20
[   12.372894] IRQ13 -> 0:13-> 0:13

[   12.373392] IRQ14=20
[   12.373392] IRQ14 -> 0:14-> 0:14

[   12.373884] IRQ15=20
[   12.373884] IRQ15 -> 0:15-> 0:15

[   12.374368] .................................... done.
[   12.374368] .................................... done.
[   12.375345] turn off boot console earlyser0
[   12.375345] turn off boot console earlyser0
[   12.377371] cryptomgr_probe (88) used greatest stack depth: 5808 bytes=
 left
[   12.378042] Key type encrypted registered
[   12.379028] dmaengine: __dma_request_channel: fail ((null))
[   12.380075] ALSA device list:
[   12.380361]   No soundcards found.
[   12.381769] debug: unmapping init [mem 0xffffffff81afc000-0xffffffff81=
d3dfff]
[   12.382576] Write protecting the kernel read-only data: 10240k
[   12.383392] debug: unmapping init [mem 0xffff88000145d000-0xffff880001=
5fffff]
[   12.384188] debug: unmapping init [mem 0xffff880001859000-0xffff880001=
9fffff]
[   12.394775] mount (97) used greatest stack depth: 5656 bytes left
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found
[   12.401434] S00fbsetup (99) used greatest stack depth: 5400 bytes left=


Please wait: booting...
Starting udev
/etc/rcS.d/S03udev: line 72: can't create /proc/sys/kernel/hotplug: nonex=
istent directory
error initializing inotify
error sending message: Connection refused
error sending message: Connection refused
Starting Bootlog daemon: bootlogd: cannot find console device 4:64 under =
/dev
bootlogd.
Configuring network interfaces... ifconfig: socket: Address family not su=
pported by protocol
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
[   81.154531] Unregister pv shared memory for cpu 0
[   81.154991] Unregister pv shared memory for cpu 1
[   81.157282] Disabling non-boot CPUs ...
[   81.301735] Restarting system.
[   81.302024] reboot: machine restart
Elapsed time: 85
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconf=
ig-j1-0612/3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a/vmlinuz-3.7.0-rc3-001=
12-g3dc4f7c -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug=
 apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 c=
onsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-j1-0612/baserock:baser=
ock:morph:3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a:bisect-linux8/.vmlinuz=
-3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a-20140613053911-4-ivb42 branch=3D=
baserock/baserock/morph BOOT_IMAGE=3D/kernel/x86_64-randconfig-j1-0612/3d=
c4f7cfb7441e5e0fed3a02fc81cdaabd28300a/vmlinuz-3.7.0-rc3-00112-g3dc4f7c d=
rbd.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.c=
gz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot=
 order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile =
/dev/shm/kboot/pid-yocto-ivb42-10 -serial file:/dev/shm/kboot/serial-yoct=
o-ivb42-10 -daemonize -display none -monitor null=20


--------------030807040400090905020506
Content-Type: application/octet-stream;
 name="x86_64-randconfig-j1-0612-749387dc8d8270b279f27a0a794cdf4f4a4aa774-WARNING:---at----pvclock_init_vsyscall+-x-43485.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="x86_64-randconfig-j1-0612-749387dc8d8270b279f27a0a794cdf4f4a";
 filename*1="4aa774-WARNING:---at----pvclock_init_vsyscall+-x-43485.log"

SEVBRCBpcyBub3cgYXQgNzQ5Mzg3ZC4uLiBkcm0vZ21hNTAwOiBGaXggaGliZXJuYXRpb24g
cHJvYmxlbXMgb24gc2R2byBlbmNvZGVycwpiaXNlY3Q6IHNraXAgMzE2ZGY0YzNlYjY2NzYz
NmVhZGY0YjY2M2Y0MDg3ZjFmOWNjM2NmZTogbm90IGEgZ29vZCBtZXJnZSBiYXNlCmdpdCBj
aGVja291dCA3NDkzODdkYzhkODI3MGIyNzlmMjdhMGE3OTRjZGY0ZjRhNGFhNzc0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEy
L2Jhc2Vyb2NrOmJhc2Vyb2NrOm1vcnBoOjc0OTM4N2RjOGQ4MjcwYjI3OWYyN2EwYTc5NGNk
ZjRmNGE0YWE3NzQ6YmlzZWN0LWxpbnV4OAogVEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBd
IG1hcHBlZCBJT0FQSUMgdG8gZmZmZmZmZmZmZjVmODAwMCAoZmVjMDAwMDApClsgICAgMC4w
MDAwMDBdIG5yX2lycXNfZ3NpOiA0MApbICAgIDAuMDAwMDAwXSAtLS0tLS0tLS0tLS1bIGN1
dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjAwMDAwMF0gV0FSTklORzogYXQgL2tidWls
ZC9zcmMveDg2XzY0L2FyY2gveDg2L2tlcm5lbC9wdmNsb2NrLmM6MTgyIHB2Y2xvY2tfaW5p
dF92c3lzY2FsbCsweDIxLzB4NTkoKQpbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBC
b2NocwpbICAgIDAuMDAwMDAwXSBQaWQ6IDAsIGNvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQg
My44LjAtcmM2LTAwNjQwLWc3NDkzODdkICMxClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6
ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwNjc4MWI+XSB3YXJuX3Nsb3dwYXRoX2Nv
bW1vbisweDdjLzB4OTQKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA2NzkwOT5dIHdh
cm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4MWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MWNlNWI2Mj5dIHB2Y2xvY2tfaW5pdF92c3lzY2FsbCsweDIxLzB4NTkKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MWNlNWFmND5dIGt2bV9zZXR1cF92c3lzY2FsbF90aW1laW5mbysw
eDU5LzB4OGIKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNlNTg2OD5dIGt2bV9ndWVz
dF9pbml0KzB4ZTQvMHhmZQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2RiMjEzPl0g
c2V0dXBfYXJjaCsweGFmYy8weGI2ZQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2Q4
ODkzPl0gc3RhcnRfa2VybmVsKzB4ZGMvMHg0M2EKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MWNkODEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODFjZDgyYjQ+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25z
KzB4YjAvMHhiMwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2Q4M2I5Pl0geDg2XzY0
X3N0YXJ0X2tlcm5lbCsweDEwMi8weDEwZgpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFj
ZSBkNGEyY2JlNDIxYmU1MzM1IF0tLS0KWyAgICAwLjAwMDAwMF0gZTgyMDogW21lbSAweDE0
MDAwMDAwLTB4ZmVmZmJmZmZdIGF2YWlsYWJsZSBmb3IgUENJIGRldmljZXMKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzc0OTM4N2RjOGQ4MjcwYjI3OWYyN2EwYTc5NGNk
ZjRmNGE0YWE3NzQvZG1lc2cteW9jdG8taXZiNDEtOTg6MjAxNDA2MTIyMzA0MzE6eDg2XzY0
LXJhbmRjb25maWctajEtMDYxMjozLjguMC1yYzYtMDA2NDAtZzc0OTM4N2Q6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvNzQ5Mzg3ZGM4ZDgyNzBiMjc5ZjI3YTBhNzk0
Y2RmNGY0YTRhYTc3NC9kbWVzZy15b2N0by1pdmI0NC04NDoyMDE0MDYxMjIzMDQyMDp4ODZf
NjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuOC4wLXJjNi0wMDY0MC1nNzQ5Mzg3ZDoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi83NDkzODdkYzhkODI3MGIyNzlmMjdhMGE3
OTRjZGY0ZjRhNGFhNzc0L2RtZXNnLXlvY3RvLWl2YjQxLTg4OjIwMTQwNjEyMjMwNDMxOng4
Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My44LjAtcmM2LTAwNjQwLWc3NDkzODdkOjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzc0OTM4N2RjOGQ4MjcwYjI3OWYyN2Ew
YTc5NGNkZjRmNGE0YWE3NzQvZG1lc2ctcXVhbnRhbC1pdmI0Mi03MDoyMDE0MDYxMjIzMTIw
OTp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuOC4wLXJjNi0wMDY0MC1nNzQ5Mzg3ZDox
CjA6NDo0IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA2LTEyIDIz
OjEyOjIzIFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXg4L29iai1i
aXNlY3QvLnJlcGVhdBtbMG0KCmJpc2VjdDogYmFkIGNvbW1pdCA3NDkzODdkYzhkODI3MGIy
NzlmMjdhMGE3OTRjZGY0ZjRhNGFhNzc0CmdpdCBjaGVja291dCB2My43CmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2Jhc2Vy
b2NrOmJhc2Vyb2NrOm1vcnBoOjI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3
MGM2MGU6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNi0xMi0yMzoxMjozNSAyOTU5NDQwNGQ3ZmU3
M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBjNjBlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2
MTItMjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZQpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi8yOTU5NDQwNGQ3
ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBjNjBlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEy
LTI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGUKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNv
bmZpZy1qMS0wNjEyLTI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGUK
a2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvMjk1OTQ0MDRkN2Zl
NzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZS92bWxpbnV6LTMuNy4wCgoyMDE0LTA2LTEy
LTIzOjE5OjM1IGRldGVjdGluZyBib290IHN0YXRlIAkxMQkxNQkxOQkyMCBTVUNDRVNTCgpi
aXNlY3Q6IGdvb2QgY29tbWl0IHYzLjcKZ2l0IGJpc2VjdCBzdGFydCA3NDkzODdkYzhkODI3
MGIyNzlmMjdhMGE3OTRjZGY0ZjRhNGFhNzc0IHYzLjcgLS0KL2Mva2VybmVsLXRlc3RzL2xp
bmVhci1iaXNlY3Q6IFsiLWIiLCAiNzQ5Mzg3ZGM4ZDgyNzBiMjc5ZjI3YTBhNzk0Y2RmNGY0
YTRhYTc3NCIsICItZyIsICJ2My43IiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1iaXNlY3QvbGludXg4L29iai1iaXNlY3QiXQpC
aXNlY3Rpbmc6IDEzODM3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxNCBzdGVwcykKW2UzMjc5NTUwM2RlMDJkYTRlN2U3NGE1ZTAzOWNjMjY4ZjZhMGVj
ZmJdIE1lcmdlIHRhZ3MgJ2R0LWZvci1saW51cycsICdncGlvLWZvci1saW51cycgYW5kICdz
cGktZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQuc2VjcmV0bGFiLmNhL2dpdC9saW51eC0yLjYK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4OC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2Jhc2Vyb2NrOmJhc2Vyb2Nr
Om1vcnBoOmUzMjc5NTUwM2RlMDJkYTRlN2U3NGE1ZTAzOWNjMjY4ZjZhMGVjZmI6YmlzZWN0
LWxpbnV4OAoKMjAxNC0wNi0xMi0yMzoyMTo0MCBlMzI3OTU1MDNkZTAyZGE0ZTdlNzRhNWUw
MzljYzI2OGY2YTBlY2ZiIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTItZTMyNzk1NTAz
ZGUwMmRhNGU3ZTc0YTVlMDM5Y2MyNjhmNmEwZWNmYgpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi9lMzI3OTU1MDNkZTAyZGE0ZTdlNzRh
NWUwMzljYzI2OGY2YTBlY2ZiCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLWUzMjc5NTUwM2Rl
MDJkYTRlN2U3NGE1ZTAzOWNjMjY4ZjZhMGVjZmIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEy
LWUzMjc5NTUwM2RlMDJkYTRlN2U3NGE1ZTAzOWNjMjY4ZjZhMGVjZmIKa2VybmVsOiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVl
MDM5Y2MyNjhmNmEwZWNmYi92bWxpbnV6LTMuNy4wLTAyOTQwLWdlMzI3OTU1CgoyMDE0LTA2
LTEyLTIzOjM3OjQwIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAg
MC4wMDAwMDBdIG1hcHBlZCBJT0FQSUMgdG8gZmZmZmZmZmZmZjVmODAwMCAoZmVjMDAwMDAp
ClsgICAgMC4wMDAwMDBdIG5yX2lycXNfZ3NpOiA0MApbICAgIDAuMDAwMDAwXSAtLS0tLS0t
LS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjAwMDAwMF0gV0FSTklORzog
YXQgL2tidWlsZC9zcmMveDg2XzY0L2FyY2gveDg2L2tlcm5lbC9wdmNsb2NrLmM6MTgyIHB2
Y2xvY2tfaW5pdF92c3lzY2FsbCsweDIxLzB4NTkoKQpbICAgIDAuMDAwMDAwXSBIYXJkd2Fy
ZSBuYW1lOiBCb2NocwpbICAgIDAuMDAwMDAwXSBQaWQ6IDAsIGNvbW06IHN3YXBwZXIgTm90
IHRhaW50ZWQgMy43LjAtMDI5NDAtZ2UzMjc5NTUgIzkKWyAgICAwLjAwMDAwMF0gQ2FsbCBU
cmFjZToKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA2Nzc5Yz5dIHdhcm5fc2xvd3Bh
dGhfY29tbW9uKzB4N2MvMHg5NApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDY3ODhh
Pl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MWEvMHgxYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZm
ZmZmZjgxY2U1OGYwPl0gcHZjbG9ja19pbml0X3ZzeXNjYWxsKzB4MjEvMHg1OQpbICAgIDAu
MDAwMDAwXSAgWzxmZmZmZmZmZjgxY2U1ODgyPl0ga3ZtX3NldHVwX3ZzeXNjYWxsX3RpbWVp
bmZvKzB4NTkvMHg4YgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2U1NWY2Pl0ga3Zt
X2d1ZXN0X2luaXQrMHhlNC8weGZlClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZGFm
OWU+XSBzZXR1cF9hcmNoKzB4YTY0LzB4YWQ5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODFjZDg4OTM+XSBzdGFydF9rZXJuZWwrMHhkYy8weDQzMApbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgxY2Q4MTIwPl0gPyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAg
ICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkODJiND5dIHg4Nl82NF9zdGFydF9yZXNlcnZh
dGlvbnMrMHhiMC8weGIzClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZDgzYjk+XSB4
ODZfNjRfc3RhcnRfa2VybmVsKzB4MTAyLzB4MTBmClsgICAgMC4wMDAwMDBdIC0tLVsgZW5k
IHRyYWNlIDE1MzI5MjJmNjRmZmNhN2EgXS0tLQpbICAgIDAuMDAwMDAwXSBlODIwOiBbbWVt
IDB4MTQwMDAwMDAtMHhmZWZmYmZmZl0gYXZhaWxhYmxlIGZvciBQQ0kgZGV2aWNlcwova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVl
MDM5Y2MyNjhmNmEwZWNmYi9kbWVzZy1xdWFudGFsLWl2YjQyLTUwOjIwMTQwNjEyMjMzNzE3
Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtMDI5NDAtZ2UzMjc5NTU6OQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVl
MDM5Y2MyNjhmNmEwZWNmYi9kbWVzZy1xdWFudGFsLWl2YjQyLTkyOjIwMTQwNjEyMjMzNzIy
Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtMDI5NDAtZ2UzMjc5NTU6OQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVl
MDM5Y2MyNjhmNmEwZWNmYi9kbWVzZy1xdWFudGFsLWl2YjQ0LTMyOjIwMTQwNjEyMjMzNzI3
Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtMDI5NDAtZ2UzMjc5NTU6OQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVl
MDM5Y2MyNjhmNmEwZWNmYi9kbWVzZy1xdWFudGFsLWl2YjQ0LTc0OjIwMTQwNjEyMjMzNzMx
Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtMDI5NDAtZ2UzMjc5NTU6OQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVl
MDM5Y2MyNjhmNmEwZWNmYi9kbWVzZy1xdWFudGFsLWl2YjQxLTExNjoyMDE0MDYxMjIzMzcz
OTp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLTAyOTQwLWdlMzI3OTU1OjkKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2UzMjc5NTUwM2RlMDJkYTRlN2U3NGE1
ZTAzOWNjMjY4ZjZhMGVjZmIvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMToyMDE0MDYxMjIzMzcz
Nzp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLTAyOTQwLWdlMzI3OTU1OjkKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2UzMjc5NTUwM2RlMDJkYTRlN2U3NGE1
ZTAzOWNjMjY4ZjZhMGVjZmIvZG1lc2ctcXVhbnRhbC1pdmI0MS0zNToyMDE0MDYxMjIzMzcz
Mjp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLTAyOTQwLWdlMzI3OTU1OjkKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2UzMjc5NTUwM2RlMDJkYTRlN2U3NGE1
ZTAzOWNjMjY4ZjZhMGVjZmIvZG1lc2ctcXVhbnRhbC1pdmI0MS01OjIwMTQwNjEyMjMzNzM0
Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtMDI5NDAtZ2UzMjc5NTU6OQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVl
MDM5Y2MyNjhmNmEwZWNmYi9kbWVzZy1xdWFudGFsLWl2YjQyLTUwOjIwMTQwNjEyMjMzNzM5
Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtMDI5NDAtZ2UzMjc5NTU6OQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvZTMyNzk1NTAzZGUwMmRhNGU3ZTc0YTVl
MDM5Y2MyNjhmNmEwZWNmYi9kbWVzZy1xdWFudGFsLWl2YjQ0LTEwOToyMDE0MDYxMjIzMzcz
Mjp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLTAyOTQwLWdlMzI3OTU1OjkKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2UzMjc5NTUwM2RlMDJkYTRlN2U3NGE1
ZTAzOWNjMjY4ZjZhMGVjZmIvZG1lc2ctcXVhbnRhbC1pdmI0NC0yOToyMDE0MDYxMjIzMzcz
NTp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLTAyOTQwLWdlMzI3OTU1OjkKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2UzMjc5NTUwM2RlMDJkYTRlN2U3NGE1
ZTAzOWNjMjY4ZjZhMGVjZmIvZG1lc2ctcXVhbnRhbC1pdmI0NC03NjoyMDE0MDYxMjIzMzcz
Mjp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLTAyOTQwLWdlMzI3OTU1OjkKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2UzMjc5NTUwM2RlMDJkYTRlN2U3NGE1
ZTAzOWNjMjY4ZjZhMGVjZmIvZG1lc2ctcXVhbnRhbC1pdmI0NC04OToyMDE0MDYxMjIzMzcz
OTp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLTAyOTQwLWdlMzI3OTU1OjkKMDox
MzoxMyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNi0xMiAyMzoz
ODoxMCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4OC9vYmotYmlz
ZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDExMDIyIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxNCBzdGVwcykKW2U3NzdkMTkyZmZiOWYyOTI5ZDU0
N2EyZjhhNWY2NWI3ZGI3YTk1NTJdIE1lcmdlIHRhZyAnc2NzaS1taXNjJyBvZiBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvamVqYi9zY3NpCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eDgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctajEtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3Jw
aDplNzc3ZDE5MmZmYjlmMjkyOWQ1NDdhMmY4YTVmNjViN2RiN2E5NTUyOmJpc2VjdC1saW51
eDgKCjIwMTQtMDYtMTItMjM6Mzg6MTMgZTc3N2QxOTJmZmI5ZjI5MjlkNTQ3YTJmOGE1ZjY1
YjdkYjdhOTU1MiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLWU3NzdkMTkyZmZiOWYy
OTI5ZDU0N2EyZjhhNWY2NWI3ZGI3YTk1NTIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvZTc3N2QxOTJmZmI5ZjI5MjlkNTQ3YTJmOGE1
ZjY1YjdkYjdhOTU1Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi1lNzc3ZDE5MmZmYjlmMjky
OWQ1NDdhMmY4YTVmNjViN2RiN2E5NTUyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctajEtMDYxMi1lNzc3
ZDE5MmZmYjlmMjkyOWQ1NDdhMmY4YTVmNjViN2RiN2E5NTUyCmtlcm5lbDogL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2U3NzdkMTkyZmZiOWYyOTI5ZDU0N2EyZjhhNWY2
NWI3ZGI3YTk1NTIvdm1saW51ei0zLjcuMC0wNzQ3Ny1nZTc3N2QxOQoKMjAxNC0wNi0xMy0w
MDoyNToxMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAuMDAw
MDAwXSBtYXBwZWQgSU9BUElDIHRvIGZmZmZmZmZmZmY1ZjgwMDAgKGZlYzAwMDAwKQpbICAg
IDAuMDAwMDAwXSBucl9pcnFzX2dzaTogNDAKWyAgICAwLjAwMDAwMF0gLS0tLS0tLS0tLS0t
WyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4wMDAwMDBdIFdBUk5JTkc6IGF0IC9r
YnVpbGQvc3JjL3g4Nl82NC9hcmNoL3g4Ni9rZXJuZWwvcHZjbG9jay5jOjE4MiBwdmNsb2Nr
X2luaXRfdnN5c2NhbGwrMHgyMS8weDU5KCkKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFt
ZTogQm9jaHMKWyAgICAwLjAwMDAwMF0gUGlkOiAwLCBjb21tOiBzd2FwcGVyIE5vdCB0YWlu
dGVkIDMuNy4wLTA3NDc3LWdlNzc3ZDE5ICMxClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6
ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwNjMzYTI+XSB3YXJuX3Nsb3dwYXRoX2Nv
bW1vbisweDdjLzB4OTQKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA2MzQ5MD5dIHdh
cm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4MWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MWNlMDhkYj5dIHB2Y2xvY2tfaW5pdF92c3lzY2FsbCsweDIxLzB4NTkKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MWNlMDg2ZD5dIGt2bV9zZXR1cF92c3lzY2FsbF90aW1laW5mbysw
eDU5LzB4OGIKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNlMDVlMT5dIGt2bV9ndWVz
dF9pbml0KzB4ZTQvMHhmZQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2Q1ZjllPl0g
c2V0dXBfYXJjaCsweGE2NC8weGFkOQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2Qz
ODkzPl0gc3RhcnRfa2VybmVsKzB4ZGMvMHg0MzAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MWNkMzEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODFjZDMyYjQ+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25z
KzB4YjAvMHhiMwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2QzM2I5Pl0geDg2XzY0
X3N0YXJ0X2tlcm5lbCsweDEwMi8weDEwZgpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFj
ZSAwMTIzZjU3MWZiZTY5Yzg3IF0tLS0KWyAgICAwLjAwMDAwMF0gZTgyMDogW21lbSAweDE0
MDAwMDAwLTB4ZmVmZmJmZmZdIGF2YWlsYWJsZSBmb3IgUENJIGRldmljZXMKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2U3NzdkMTkyZmZiOWYyOTI5ZDU0N2EyZjhhNWY2
NWI3ZGI3YTk1NTIvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDY6MjAxNDA2MTMwMDI1Mzc6eDg2
XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC0wNzQ3Ny1nZTc3N2QxOToxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctajEtMDYxMi9lNzc3ZDE5MmZmYjlmMjkyOWQ1NDdhMmY4YTVm
NjViN2RiN2E5NTUyL2RtZXNnLXF1YW50YWwtaXZiNDEtODI6MjAxNDA2MTMwMDI1NDA6eDg2
XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC0wNzQ3Ny1nZTc3N2QxOToxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctajEtMDYxMi9lNzc3ZDE5MmZmYjlmMjkyOWQ1NDdhMmY4YTVm
NjViN2RiN2E5NTUyL2RtZXNnLXF1YW50YWwtaXZiNDItMzM6MjAxNDA2MTMwMDI1MzU6eDg2
XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC0wNzQ3Ny1nZTc3N2QxOToxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctajEtMDYxMi9lNzc3ZDE5MmZmYjlmMjkyOWQ1NDdhMmY4YTVm
NjViN2RiN2E5NTUyL2RtZXNnLXF1YW50YWwtaXZiNDQtMTE4OjIwMTQwNjEzMDAyNTQwOng4
Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtMDc0NzctZ2U3NzdkMTk6MQowOjQ6NCBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNi0xMyAwMDoyNTo0MyBS
RVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4OC9vYmotYmlzZWN0Ly5y
ZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDc1MDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbNTA4NTFjNjI0OGUxYTEzYzQ1ZDk3YzQxZjZl
YmNmNzE2MDkzYWE1ZV0gTWVyZ2UgYnJhbmNoICdyZWxlYXNlJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcnpoYW5nL2xpbnV4CnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJp
c2VjdC9saW51eDgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctajEtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDo1
MDg1MWM2MjQ4ZTFhMTNjNDVkOTdjNDFmNmViY2Y3MTYwOTNhYTVlOmJpc2VjdC1saW51eDgK
CjIwMTQtMDYtMTMtMDA6MjU6NDUgNTA4NTFjNjI0OGUxYTEzYzQ1ZDk3YzQxZjZlYmNmNzE2
MDkzYWE1ZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLTUwODUxYzYyNDhlMWExM2M0
NWQ5N2M0MWY2ZWJjZjcxNjA5M2FhNWUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvNTA4NTFjNjI0OGUxYTEzYzQ1ZDk3YzQxZjZlYmNm
NzE2MDkzYWE1ZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi01MDg1MWM2MjQ4ZTFhMTNjNDVk
OTdjNDFmNmViY2Y3MTYwOTNhYTVlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctajEtMDYxMi01MDg1MWM2
MjQ4ZTFhMTNjNDVkOTdjNDFmNmViY2Y3MTYwOTNhYTVlCmtlcm5lbDogL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1qMS0wNjEyLzUwODUxYzYyNDhlMWExM2M0NWQ5N2M0MWY2ZWJjZjcx
NjA5M2FhNWUvdm1saW51ei0zLjcuMC0wMzAzMS1nNTA4NTFjNjIKCjIwMTQtMDYtMTMtMDA6
NDA6NDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTMJMTQuCTE5CTIwIFNVQ0NFU1MKCkJpc2Vj
dGluZzogNDQ3NCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MTMgc3RlcHMpCls2OThkNjAxMjI0ODI0YmMxYTViZjE3ZjNkODZiZTkwMmUyYWFiZmYwXSBN
ZXJnZSB0YWcgJ2RyaXZlcnMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9hcm0vYXJtLXNvYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg4L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LWoxLTA2MTIvYmFzZXJvY2s6YmFzZXJvY2s6bW9ycGg6Njk4ZDYwMTIyNDgyNGJjMWE1YmYx
N2YzZDg2YmU5MDJlMmFhYmZmMDpiaXNlY3QtbGludXg4CgoyMDE0LTA2LTEzLTAwOjQzOjE2
IDY5OGQ2MDEyMjQ4MjRiYzFhNWJmMTdmM2Q4NmJlOTAyZTJhYWJmZjAgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctajEtMDYxMi02OThkNjAxMjI0ODI0YmMxYTViZjE3ZjNkODZiZTkwMmUyYWFi
ZmYwCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0w
NjEyLzY5OGQ2MDEyMjQ4MjRiYzFhNWJmMTdmM2Q4NmJlOTAyZTJhYWJmZjAKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLWoxLTA2MTItNjk4ZDYwMTIyNDgyNGJjMWE1YmYxN2YzZDg2YmU5MDJlMmFhYmZm
MAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
Lng4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTItNjk4ZDYwMTIyNDgyNGJjMWE1YmYxN2YzZDg2
YmU5MDJlMmFhYmZmMAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYx
Mi82OThkNjAxMjI0ODI0YmMxYTViZjE3ZjNkODZiZTkwMmUyYWFiZmYwL3ZtbGludXotMy43
LjAtMDYyNjktZzY5OGQ2MDEKCjIwMTQtMDYtMTMtMDE6MDk6MTYgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgCTcuCTkJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMjQ0IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzhkOWVhNzE3MmVkZDJl
NTJkYTI2Yjk0ODViNGM5Nzk2OWEwZDI2NDhdIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kYXZlbS9uZXQKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
OC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1qMS0wNjEyL2Jhc2Vyb2NrOmJhc2Vyb2NrOm1vcnBoOjhkOWVhNzE3MmVk
ZDJlNTJkYTI2Yjk0ODViNGM5Nzk2OWEwZDI2NDg6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNi0x
My0wMToxMToxNyA4ZDllYTcxNzJlZGQyZTUyZGEyNmI5NDg1YjRjOTc5NjlhMGQyNjQ4IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTItOGQ5ZWE3MTcyZWRkMmU1MmRhMjZiOTQ4NWI0
Yzk3OTY5YTBkMjY0OApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctajEtMDYxMi84ZDllYTcxNzJlZGQyZTUyZGEyNmI5NDg1YjRjOTc5NjlhMGQyNjQ4
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLThkOWVhNzE3MmVkZDJlNTJkYTI2Yjk0ODViNGM5
Nzk2OWEwZDI2NDgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLThkOWVhNzE3MmVkZDJlNTJk
YTI2Yjk0ODViNGM5Nzk2OWEwZDI2NDgKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWoxLTA2MTIvOGQ5ZWE3MTcyZWRkMmU1MmRhMjZiOTQ4NWI0Yzk3OTY5YTBkMjY0OC92
bWxpbnV6LTMuNy4wLTA3MDY4LWc4ZDllYTcxCgoyMDE0LTA2LTEzLTAxOjMyOjE3IGRldGVj
dGluZyBib290IHN0YXRlIAkxNC4JMTcJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0MDkgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCls2NmNk
ZDBjZWFmNjVhMTg5OTZmNTYxYjc3MGVlZGRlMWQxMjNiMDE5XSBNZXJnZSB0YWcgJ2t2bS0z
LjgtMScgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS92aXJ0L2t2bS9rdm0KcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4OC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2Jhc2Vyb2NrOmJhc2Vyb2NrOm1v
cnBoOjY2Y2RkMGNlYWY2NWExODk5NmY1NjFiNzcwZWVkZGUxZDEyM2IwMTk6YmlzZWN0LWxp
bnV4OAoKMjAxNC0wNi0xMy0wMTozNDoxOCA2NmNkZDBjZWFmNjVhMTg5OTZmNTYxYjc3MGVl
ZGRlMWQxMjNiMDE5IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTItNjZjZGQwY2VhZjY1
YTE4OTk2ZjU2MWI3NzBlZWRkZTFkMTIzYjAxOQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi82NmNkZDBjZWFmNjVhMTg5OTZmNTYxYjc3
MGVlZGRlMWQxMjNiMDE5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLTY2Y2RkMGNlYWY2NWEx
ODk5NmY1NjFiNzcwZWVkZGUxZDEyM2IwMTkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLTY2
Y2RkMGNlYWY2NWExODk5NmY1NjFiNzcwZWVkZGUxZDEyM2IwMTkKa2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvNjZjZGQwY2VhZjY1YTE4OTk2ZjU2MWI3NzBl
ZWRkZTFkMTIzYjAxOS92bWxpbnV6LTMuNy4wLTA3MzA4LWc2NmNkZDBjCgoyMDE0LTA2LTEz
LTAxOjUzOjE4IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uIFRFU1QgRkFJTFVSRQpb
ICAgIDAuMDAwMDAwXSBtYXBwZWQgSU9BUElDIHRvIGZmZmZmZmZmZmY1ZjgwMDAgKGZlYzAw
MDAwKQpbICAgIDAuMDAwMDAwXSBucl9pcnFzX2dzaTogNDAKWyAgICAwLjAwMDAwMF0gLS0t
LS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4wMDAwMDBdIFdBUk5J
Tkc6IGF0IC9rYnVpbGQvc3JjL3g4Nl82NC9hcmNoL3g4Ni9rZXJuZWwvcHZjbG9jay5jOjE4
MiBwdmNsb2NrX2luaXRfdnN5c2NhbGwrMHgyMS8weDU5KCkKWyAgICAwLjAwMDAwMF0gSGFy
ZHdhcmUgbmFtZTogQm9jaHMKWyAgICAwLjAwMDAwMF0gUGlkOiAwLCBjb21tOiBzd2FwcGVy
IE5vdCB0YWludGVkIDMuNy4wLTA3MzA4LWc2NmNkZDBjICM5ClsgICAgMC4wMDAwMDBdIENh
bGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwNjMzYTI+XSB3YXJuX3Ns
b3dwYXRoX2NvbW1vbisweDdjLzB4OTQKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA2
MzQ5MD5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4MWMKWyAgICAwLjAwMDAwMF0gIFs8
ZmZmZmZmZmY4MWNlMDhkYj5dIHB2Y2xvY2tfaW5pdF92c3lzY2FsbCsweDIxLzB4NTkKWyAg
ICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNlMDg2ZD5dIGt2bV9zZXR1cF92c3lzY2FsbF90
aW1laW5mbysweDU5LzB4OGIKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNlMDVlMT5d
IGt2bV9ndWVzdF9pbml0KzB4ZTQvMHhmZQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgx
Y2Q1ZjllPl0gc2V0dXBfYXJjaCsweGE2NC8weGFkOQpbICAgIDAuMDAwMDAwXSAgWzxmZmZm
ZmZmZjgxY2QzODkzPl0gc3RhcnRfa2VybmVsKzB4ZGMvMHg0MzAKWyAgICAwLjAwMDAwMF0g
IFs8ZmZmZmZmZmY4MWNkMzEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIw
ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZDMyYjQ+XSB4ODZfNjRfc3RhcnRfcmVz
ZXJ2YXRpb25zKzB4YjAvMHhiMwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2QzM2I5
Pl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweDEwMi8weDEwZgpbICAgIDAuMDAwMDAwXSAtLS1b
IGVuZCB0cmFjZSA3YmZlYmUzMGRkOTE4ODc0IF0tLS0KWyAgICAwLjAwMDAwMF0gZTgyMDog
W21lbSAweDE0MDAwMDAwLTB4ZmVmZmJmZmZdIGF2YWlsYWJsZSBmb3IgUENJIGRldmljZXMK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzY2Y2RkMGNlYWY2NWExODk5NmY1
NjFiNzcwZWVkZGUxZDEyM2IwMTkvZG1lc2ctcXVhbnRhbC1pdmI0MS04ODoyMDE0MDYxMzAx
NTY1NDp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLTA3MzA4LWc2NmNkZDBjOjkK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzY2Y2RkMGNlYWY2NWExODk5NmY1
NjFiNzcwZWVkZGUxZDEyM2IwMTkvZG1lc2ctcXVhbnRhbC1pdmI0NC03OToyMDE0MDYxMzAx
NTY1Mzp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLTA3MzA4LWc2NmNkZDBjOjkK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzY2Y2RkMGNlYWY2NWExODk5NmY1
NjFiNzcwZWVkZGUxZDEyM2IwMTkvZG1lc2ctcXVhbnRhbC1pdmI0MS0yOToyMDE0MDYxMzAx
NTcwNTp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLTA3MzA4LWc2NmNkZDBjOjkK
MDozOjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDYtMTMgMDE6
NTc6MTkgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eDgvb2JqLWJp
c2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAyNDAgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpClszMTI3ZjIzZjAxM2VhYmU5YjU4MTMy
YzA1MDYxNjg0YzQ5MTQ2YmEzXSBNZXJnZSBicmFuY2ggJ2Zvci1saW51cycgb2YgZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dlZXJ0L2xpbnV4LW02
OGsKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4OC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2Jhc2Vyb2NrOmJhc2Vy
b2NrOm1vcnBoOjMxMjdmMjNmMDEzZWFiZTliNTgxMzJjMDUwNjE2ODRjNDkxNDZiYTM6Ymlz
ZWN0LWxpbnV4OAoKMjAxNC0wNi0xMy0wMTo1NzoyMCAzMTI3ZjIzZjAxM2VhYmU5YjU4MTMy
YzA1MDYxNjg0YzQ5MTQ2YmEzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTItMzEyN2Yy
M2YwMTNlYWJlOWI1ODEzMmMwNTA2MTY4NGM0OTE0NmJhMwpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi8zMTI3ZjIzZjAxM2VhYmU5YjU4
MTMyYzA1MDYxNjg0YzQ5MTQ2YmEzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLTMxMjdmMjNm
MDEzZWFiZTliNTgxMzJjMDUwNjE2ODRjNDkxNDZiYTMKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1qMS0w
NjEyLTMxMjdmMjNmMDEzZWFiZTliNTgxMzJjMDUwNjE2ODRjNDkxNDZiYTMKa2VybmVsOiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvMzEyN2YyM2YwMTNlYWJlOWI1ODEz
MmMwNTA2MTY4NGM0OTE0NmJhMy92bWxpbnV6LTMuNy4wLTA3MDg3LWczMTI3ZjIzCgoyMDE0
LTA2LTEzLTAyOjEwOjIwIGRldGVjdGluZyBib290IHN0YXRlIAk2CTEwCTEzCTIwIFNVQ0NF
U1MKCkJpc2VjdGluZzogMjIxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSA4IHN0ZXBzKQpbYzc3MDhmYWM1YTg3OGQ2ZTBmMmRlMGFhMTlmOTc0OWNmZjRm
NzA3Zl0gTWVyZ2UgYnJhbmNoICdmb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zMzkwL2xpbnV4CnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eDgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctajEtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDpjNzcwOGZhYzVh
ODc4ZDZlMGYyZGUwYWExOWY5NzQ5Y2ZmNGY3MDdmOmJpc2VjdC1saW51eDgKCjIwMTQtMDYt
MTMtMDI6MTI6MjAgYzc3MDhmYWM1YTg3OGQ2ZTBmMmRlMGFhMTlmOTc0OWNmZjRmNzA3ZiBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLWM3NzA4ZmFjNWE4NzhkNmUwZjJkZTBhYTE5
Zjk3NDljZmY0ZjcwN2YKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWoxLTA2MTIvYzc3MDhmYWM1YTg3OGQ2ZTBmMmRlMGFhMTlmOTc0OWNmZjRmNzA3
Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctajEtMDYxMi1jNzcwOGZhYzVhODc4ZDZlMGYyZGUwYWExOWY5
NzQ5Y2ZmNGY3MDdmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctajEtMDYxMi1jNzcwOGZhYzVhODc4ZDZl
MGYyZGUwYWExOWY5NzQ5Y2ZmNGY3MDdmCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1qMS0wNjEyL2M3NzA4ZmFjNWE4NzhkNmUwZjJkZTBhYTE5Zjk3NDljZmY0ZjcwN2Yv
dm1saW51ei0zLjcuMC0wNzEyOS1nYzc3MDhmYQoKMjAxNC0wNi0xMy0wMjoyODoyMCBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuCTEJNQk4CTE2CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTc5
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpb
ODk2ZWExN2QzZGE1ZjQ0YjI2MjVjOWNkYTk4NzRkN2RmZTQ0NzM5M10gTWVyZ2UgdGFnICdz
dGFibGUvZm9yLWxpbnVzLTMuOC1yYzAtdGFnJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQva29ucmFkL3hlbgpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg4
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLWoxLTA2MTIvYmFzZXJvY2s6YmFzZXJvY2s6bW9ycGg6ODk2ZWExN2QzZGE1
ZjQ0YjI2MjVjOWNkYTk4NzRkN2RmZTQ0NzM5MzpiaXNlY3QtbGludXg4CgoyMDE0LTA2LTEz
LTAyOjMxOjIxIDg5NmVhMTdkM2RhNWY0NGIyNjI1YzljZGE5ODc0ZDdkZmU0NDczOTMgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctajEtMDYxMi04OTZlYTE3ZDNkYTVmNDRiMjYyNWM5Y2RhOTg3
NGQ3ZGZlNDQ3MzkzCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1qMS0wNjEyLzg5NmVhMTdkM2RhNWY0NGIyNjI1YzljZGE5ODc0ZDdkZmU0NDczOTMK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLWoxLTA2MTItODk2ZWExN2QzZGE1ZjQ0YjI2MjVjOWNkYTk4NzRk
N2RmZTQ0NzM5Mwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTItODk2ZWExN2QzZGE1ZjQ0YjI2
MjVjOWNkYTk4NzRkN2RmZTQ0NzM5MwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctajEtMDYxMi84OTZlYTE3ZDNkYTVmNDRiMjYyNWM5Y2RhOTg3NGQ3ZGZlNDQ3MzkzL3Zt
bGludXotMy43LjAtMDcxNDYtZzg5NmVhMTcKCjIwMTQtMDYtMTMtMDI6NDA6MjEgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgCTIJNgkxMgkyMCBTVUNDRVNTCgpsaW5lYXItYmlzZWN0OiBiYWQg
YnJhbmNoIG1heSBiZSB0YWcgJ2t2bS0zLjgtMScgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS92aXJ0L2t2bS9rdm0KbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0
IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDY2Y2RkMGNlYWY2NWEx
ODk5NmY1NjFiNzcwZWVkZGUxZDEyM2IwMTkgODk2ZWExN2QzZGE1ZjQ0YjI2MjVjOWNkYTk4
NzRkN2RmZTQ0NzM5MyAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA4OTZlYTE3Li4u
IE1lcmdlIHRhZyAnc3RhYmxlL2Zvci1saW51cy0zLjgtcmMwLXRhZycgb2YgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2tvbnJhZC94ZW4KSEVBRCBp
cyBub3cgYXQgOGU1MDk2Ni4uLiBNZXJnZSB0YWcgJ2dwaW8tdjMuMTQtMScgb2YgZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2xpbnVzdy9saW51eC1n
cGlvCkJpc2VjdGluZzogODAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDYgc3RlcHMpCls4NDU1ZDc5ZTIxNjM5OTdlNDc5OTMxYjhkNWI3ZTYwYTkyY2Qy
Yjg2XSBLVk06IFBQQzogQm9vazNTIEhWOiBSdW4gdmlydHVhbCBjb3JlIHdoZW5ldmVyIGFu
eSB2Y3B1cyBpbiBpdCBjYW4gcnVuCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXg4L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4OC9vYmotYmlzZWN0Cmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1qMS0w
NjEyL2Jhc2Vyb2NrOmJhc2Vyb2NrOm1vcnBoOjg0NTVkNzllMjE2Mzk5N2U0Nzk5MzFiOGQ1
YjdlNjBhOTJjZDJiODY6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNi0xMy0wMjo0NDoxMyA4NDU1
ZDc5ZTIxNjM5OTdlNDc5OTMxYjhkNWI3ZTYwYTkyY2QyYjg2IGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLWoxLTA2MTItODQ1NWQ3OWUyMTYzOTk3ZTQ3OTkzMWI4ZDViN2U2MGE5MmNkMmI4NgpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi84
NDU1ZDc5ZTIxNjM5OTdlNDc5OTMxYjhkNWI3ZTYwYTkyY2QyYjg2CndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1qMS0wNjEyLTg0NTVkNzllMjE2Mzk5N2U0Nzk5MzFiOGQ1YjdlNjBhOTJjZDJiODYKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZf
NjQtcmFuZGNvbmZpZy1qMS0wNjEyLTg0NTVkNzllMjE2Mzk5N2U0Nzk5MzFiOGQ1YjdlNjBh
OTJjZDJiODYKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvODQ1
NWQ3OWUyMTYzOTk3ZTQ3OTkzMWI4ZDViN2U2MGE5MmNkMmI4Ni92bWxpbnV6LTMuNi4wLTA2
NzUxLWc4NDU1ZDc5CgoyMDE0LTA2LTEzLTAyOjQ3OjEzIGRldGVjdGluZyBib290IHN0YXRl
IAkxMQkxMi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0MCByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzc4YzYzNDQwMmExODI1ZjFmNWJl
ZjEzMDc3ZjA5ODVmM2I4YTMyMTJdIGt2bTogZGVsaXZlciBtc2kgaW50ZXJydXB0cyBmcm9t
IGlycSBoYW5kbGVyCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDgvb2JqLWJpc2VjdApscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctajEtMDYxMi9iYXNl
cm9jazpiYXNlcm9jazptb3JwaDo3OGM2MzQ0MDJhMTgyNWYxZjViZWYxMzA3N2YwOTg1ZjNi
OGEzMjEyOmJpc2VjdC1saW51eDgKCjIwMTQtMDYtMTMtMDI6NDk6MTUgNzhjNjM0NDAyYTE4
MjVmMWY1YmVmMTMwNzdmMDk4NWYzYjhhMzIxMiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1qMS0w
NjEyLTc4YzYzNDQwMmExODI1ZjFmNWJlZjEzMDc3ZjA5ODVmM2I4YTMyMTIKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvNzhjNjM0NDAy
YTE4MjVmMWY1YmVmMTMwNzdmMDk4NWYzYjhhMzIxMgp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctajEtMDYx
Mi03OGM2MzQ0MDJhMTgyNWYxZjViZWYxMzA3N2YwOTg1ZjNiOGEzMjEyCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRj
b25maWctajEtMDYxMi03OGM2MzQ0MDJhMTgyNWYxZjViZWYxMzA3N2YwOTg1ZjNiOGEzMjEy
Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzc4YzYzNDQwMmEx
ODI1ZjFmNWJlZjEzMDc3ZjA5ODVmM2I4YTMyMTIvdm1saW51ei0zLjcuMC1yYzMtMDAxMjkt
Zzc4YzYzNDQKCjIwMTQtMDYtMTMtMDM6MTA6MTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBU
RVNUIEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gbWFwcGVkIElPQVBJQyB0byBmZmZmZmZmZmZm
NWY4MDAwIChmZWMwMDAwMCkKWyAgICAwLjAwMDAwMF0gbnJfaXJxc19nc2k6IDQwClsgICAg
MC4wMDAwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAu
MDAwMDAwXSBXQVJOSU5HOiBhdCAva2J1aWxkL3NyYy94ODZfNjQvYXJjaC94ODYva2VybmVs
L3B2Y2xvY2suYzoxODIgcHZjbG9ja19pbml0X3ZzeXNjYWxsKzB4MjEvMHg1OSgpClsgICAg
MC4wMDAwMDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzClsgICAgMC4wMDAwMDBdIFBpZDogMCwg
Y29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjcuMC1yYzMtMDAxMjktZzc4YzYzNDQgIzIx
ClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODEwNjIyMjU+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDdjLzB4OTQKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MTA2MjMxMz5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4MWMK
WyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkZTdjOT5dIHB2Y2xvY2tfaW5pdF92c3lz
Y2FsbCsweDIxLzB4NTkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkZTc1Yj5dIGt2
bV9zZXR1cF92c3lzY2FsbF90aW1laW5mbysweDU5LzB4OGIKWyAgICAwLjAwMDAwMF0gIFs8
ZmZmZmZmZmY4MWNkZTRjZj5dIGt2bV9ndWVzdF9pbml0KzB4ZTQvMHhmZQpbICAgIDAuMDAw
MDAwXSAgWzxmZmZmZmZmZjgxY2QzZjllPl0gc2V0dXBfYXJjaCsweGE2NC8weGFkOQpbICAg
IDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2QxODkzPl0gc3RhcnRfa2VybmVsKzB4ZGMvMHg0
MzAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkMTEyMD5dID8gZWFybHlfaWR0X2hh
bmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZDEyYjQ+
XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4YjAvMHhiMwpbICAgIDAuMDAwMDAwXSAg
WzxmZmZmZmZmZjgxY2QxM2I5Pl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweDEwMi8weDEwZgpb
ICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSA2MDg5OGY0YjdkMDFhMWI1IF0tLS0KWyAg
ICAwLjAwMDAwMF0gZTgyMDogW21lbSAweDE0MDAwMDAwLTB4ZmVmZmJmZmZdIGF2YWlsYWJs
ZSBmb3IgUENJIGRldmljZXMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzc4
YzYzNDQwMmExODI1ZjFmNWJlZjEzMDc3ZjA5ODVmM2I4YTMyMTIvZG1lc2ctcXVhbnRhbC1p
dmI0MS0zOToyMDE0MDYxMzAzMDk0Nzp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4w
LXJjMy0wMDEyOS1nNzhjNjM0NDoyMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2
MTIvNzhjNjM0NDAyYTE4MjVmMWY1YmVmMTMwNzdmMDk4NWYzYjhhMzIxMi9kbWVzZy1xdWFu
dGFsLWl2YjQxLTUyOjIwMTQwNjEzMDMwOTM5Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6
My43LjAtcmMzLTAwMTI5LWc3OGM2MzQ0OjIxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
ajEtMDYxMi83OGM2MzQ0MDJhMTgyNWYxZjViZWYxMzA3N2YwOTg1ZjNiOGEzMjEyL2RtZXNn
LXF1YW50YWwtaXZiNDItNzg6MjAxNDA2MTMwMzA5NDU6eDg2XzY0LXJhbmRjb25maWctajEt
MDYxMjozLjcuMC1yYzMtMDAxMjktZzc4YzYzNDQ6MjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1qMS0wNjEyLzc4YzYzNDQwMmExODI1ZjFmNWJlZjEzMDc3ZjA5ODVmM2I4YTMyMTIv
ZG1lc2ctcXVhbnRhbC1pdmI0NC0xMDU6MjAxNDA2MTMwMzA5NDc6eDg2XzY0LXJhbmRjb25m
aWctajEtMDYxMjozLjcuMC1yYzMtMDAxMjktZzc4YzYzNDQ6MjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1qMS0wNjEyLzc4YzYzNDQwMmExODI1ZjFmNWJlZjEzMDc3ZjA5ODVmM2I4
YTMyMTIvZG1lc2ctcXVhbnRhbC1pdmI0NC0xMDk6MjAxNDA2MTMwMzA5Mzk6eDg2XzY0LXJh
bmRjb25maWctajEtMDYxMjozLjcuMC1yYzMtMDAxMjktZzc4YzYzNDQ6MjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzc4YzYzNDQwMmExODI1ZjFmNWJlZjEzMDc3ZjA5
ODVmM2I4YTMyMTIvZG1lc2ctcXVhbnRhbC1pdmI0NC0yOToyMDE0MDYxMzAzMDkzOTp4ODZf
NjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLXJjMy0wMDEyOS1nNzhjNjM0NDoyMQowOjY6
NiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNi0xMyAwMzoxMDo0
NiBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4OC9vYmotYmlzZWN0
Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDE5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbMTg5ZTExNzMxYWE4NTg1OTcwOTVmYmUxZTZk
MjQzYmFkMjZiZDk2Yl0geDg2OiBwdmNsb2NrOiBhZGQgbm90ZSBhYm91dCByZHRzYyBiYXJy
aWVycwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2MvYm9vdC1iaXNlY3QvbGludXg4L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvYmFzZXJvY2s6YmFz
ZXJvY2s6bW9ycGg6MTg5ZTExNzMxYWE4NTg1OTcwOTVmYmUxZTZkMjQzYmFkMjZiZDk2Yjpi
aXNlY3QtbGludXg4CgoyMDE0LTA2LTEzLTAzOjEzOjE0IDE4OWUxMTczMWFhODU4NTk3MDk1
ZmJlMWU2ZDI0M2JhZDI2YmQ5NmIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi0xODll
MTE3MzFhYTg1ODU5NzA5NWZiZTFlNmQyNDNiYWQyNmJkOTZiCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzE4OWUxMTczMWFhODU4NTk3
MDk1ZmJlMWU2ZDI0M2JhZDI2YmQ5NmIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTItMTg5ZTEx
NzMxYWE4NTg1OTcwOTVmYmUxZTZkMjQzYmFkMjZiZDk2Ygp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWox
LTA2MTItMTg5ZTExNzMxYWE4NTg1OTcwOTVmYmUxZTZkMjQzYmFkMjZiZDk2YgprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi8xODllMTE3MzFhYTg1ODU5NzA5
NWZiZTFlNmQyNDNiYWQyNmJkOTZiL3ZtbGludXotMy43LjAtcmMzLTAwMTA5LWcxODllMTE3
CgoyMDE0LTA2LTEzLTAzOjQyOjE0IGRldGVjdGluZyBib290IHN0YXRlIAkxMQkxNQkxOQky
MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDMgc3RlcHMpCltiNDhhYTk3ZTM4MjA2YTg0YmY4NDg1ZTdjNTUzNDEy
Mjc0NzA4Y2U1XSBLVk06IHg4NjogcmVxdWlyZSBtYXRjaGVkIFRTQyBvZmZzZXRzIGZvciBt
YXN0ZXIgY2xvY2sKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4OC9vYmotYmlzZWN0CmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2Jhc2Vy
b2NrOmJhc2Vyb2NrOm1vcnBoOmI0OGFhOTdlMzgyMDZhODRiZjg0ODVlN2M1NTM0MTIyNzQ3
MDhjZTU6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNi0xMy0wMzo0NDoxNSBiNDhhYTk3ZTM4MjA2
YTg0YmY4NDg1ZTdjNTUzNDEyMjc0NzA4Y2U1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2
MTItYjQ4YWE5N2UzODIwNmE4NGJmODQ4NWU3YzU1MzQxMjI3NDcwOGNlNQpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi9iNDhhYTk3ZTM4
MjA2YTg0YmY4NDg1ZTdjNTUzNDEyMjc0NzA4Y2U1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEy
LWI0OGFhOTdlMzgyMDZhODRiZjg0ODVlN2M1NTM0MTIyNzQ3MDhjZTUKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNv
bmZpZy1qMS0wNjEyLWI0OGFhOTdlMzgyMDZhODRiZjg0ODVlN2M1NTM0MTIyNzQ3MDhjZTUK
a2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvYjQ4YWE5N2UzODIw
NmE4NGJmODQ4NWU3YzU1MzQxMjI3NDcwOGNlNS92bWxpbnV6LTMuNy4wLXJjMy0wMDExOS1n
YjQ4YWE5NwoKMjAxNC0wNi0xMy0wNDowOToxNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRF
U1QgRkFJTFVSRQpbICAgIDAuMDAwMDAwXSBtYXBwZWQgSU9BUElDIHRvIGZmZmZmZmZmZmY1
ZjgwMDAgKGZlYzAwMDAwKQpbICAgIDAuMDAwMDAwXSBucl9pcnFzX2dzaTogNDAKWyAgICAw
LjAwMDAwMF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4w
MDAwMDBdIFdBUk5JTkc6IGF0IC9rYnVpbGQvc3JjL3g4Nl82NC9hcmNoL3g4Ni9rZXJuZWwv
cHZjbG9jay5jOjE4MiBwdmNsb2NrX2luaXRfdnN5c2NhbGwrMHgyMS8weDU5KCkKWyAgICAw
LjAwMDAwMF0gSGFyZHdhcmUgbmFtZTogQm9jaHMKWyAgICAwLjAwMDAwMF0gUGlkOiAwLCBj
b21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuNy4wLXJjMy0wMDExOS1nYjQ4YWE5NyAjMjgK
WyAgICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MTA2MjI1NT5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4N2MvMHg5NApbICAgIDAuMDAwMDAw
XSAgWzxmZmZmZmZmZjgxMDYyMzQzPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MWEvMHgxYwpb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2RlN2M5Pl0gcHZjbG9ja19pbml0X3ZzeXNj
YWxsKzB4MjEvMHg1OQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2RlNzViPl0ga3Zt
X3NldHVwX3ZzeXNjYWxsX3RpbWVpbmZvKzB4NTkvMHg4YgpbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgxY2RlNGNmPl0ga3ZtX2d1ZXN0X2luaXQrMHhlNC8weGZlClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODFjZDNmOWU+XSBzZXR1cF9hcmNoKzB4YTY0LzB4YWQ5ClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZDE4OTM+XSBzdGFydF9rZXJuZWwrMHhkYy8weDQz
MApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2QxMTIwPl0gPyBlYXJseV9pZHRfaGFu
ZGxlcnMrMHgxMjAvMHgxMjAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkMTJiND5d
IHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMrMHhiMC8weGIzClsgICAgMC4wMDAwMDBdICBb
PGZmZmZmZmZmODFjZDEzYjk+XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4MTAyLzB4MTBmClsg
ICAgMC4wMDAwMDBdIC0tLVsgZW5kIHRyYWNlIGYwZjRjN2I0ZTg3NGYwMzAgXS0tLQpbICAg
IDAuMDAwMDAwXSBlODIwOiBbbWVtIDB4MTQwMDAwMDAtMHhmZWZmYmZmZl0gYXZhaWxhYmxl
IGZvciBQQ0kgZGV2aWNlcwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvYjQ4
YWE5N2UzODIwNmE4NGJmODQ4NWU3YzU1MzQxMjI3NDcwOGNlNS9kbWVzZy1xdWFudGFsLWl2
YjQyLTExODoyMDE0MDYxMzA0MDg0ODp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4w
LXJjMy0wMDExOS1nYjQ4YWE5NzoyOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2
MTIvYjQ4YWE5N2UzODIwNmE4NGJmODQ4NWU3YzU1MzQxMjI3NDcwOGNlNS9kbWVzZy1xdWFu
dGFsLWl2YjQyLTg0OjIwMTQwNjEzMDQwODUwOng4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6
My43LjAtcmMzLTAwMTE5LWdiNDhhYTk3OjI4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
ajEtMDYxMi9iNDhhYTk3ZTM4MjA2YTg0YmY4NDg1ZTdjNTUzNDEyMjc0NzA4Y2U1L2RtZXNn
LXF1YW50YWwtaXZiNDEtNTQ6MjAxNDA2MTMwNDA4NTQ6eDg2XzY0LXJhbmRjb25maWctajEt
MDYxMjozLjcuMC1yYzMtMDAxMTktZ2I0OGFhOTc6MjgKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1qMS0wNjEyL2I0OGFhOTdlMzgyMDZhODRiZjg0ODVlN2M1NTM0MTIyNzQ3MDhjZTUv
ZG1lc2ctcXVhbnRhbC1pdmI0NC04MjoyMDE0MDYxMzA0MDg1NTp4ODZfNjQtcmFuZGNvbmZp
Zy1qMS0wNjEyOjMuNy4wLXJjMy0wMDExOS1nYjQ4YWE5NzoyOAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWoxLTA2MTIvYjQ4YWE5N2UzODIwNmE4NGJmODQ4NWU3YzU1MzQxMjI3NDcw
OGNlNS9kbWVzZy1xdWFudGFsLWl2YjQ0LTkyOjIwMTQwNjEzMDQwODUyOng4Nl82NC1yYW5k
Y29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTE5LWdiNDhhYTk3OjI4Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctajEtMDYxMi9iNDhhYTk3ZTM4MjA2YTg0YmY4NDg1ZTdjNTUzNDEy
Mjc0NzA4Y2U1L2RtZXNnLXF1YW50YWwtaXZiNDQtMTE1OjIwMTQwNjEzMDQwOTAzOng4Nl82
NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTE5LWdiNDhhYTk3OjI4Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi9iNDhhYTk3ZTM4MjA2YTg0YmY4NDg1ZTdj
NTUzNDEyMjc0NzA4Y2U1L2RtZXNnLXF1YW50YWwtaXZiNDEtMjk6MjAxNDA2MTMwNDA5MTQ6
eDg2XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC1yYzMtMDAxMTktZ2I0OGFhOTc6MjgK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2I0OGFhOTdlMzgyMDZhODRiZjg0
ODVlN2M1NTM0MTIyNzQ3MDhjZTUvZG1lc2ctcXVhbnRhbC1pdmI0Mi0xMTg6MjAxNDA2MTMw
NDA5MTE6eDg2XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC1yYzMtMDAxMTktZ2I0OGFh
OTc6MjgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2I0OGFhOTdlMzgyMDZh
ODRiZjg0ODVlN2M1NTM0MTIyNzQ3MDhjZTUvZG1lc2ctcXVhbnRhbC1pdmI0Mi04NDoyMDE0
MDYxMzA0MDkxMjp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLXJjMy0wMDExOS1n
YjQ4YWE5NzoyOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvYjQ4YWE5N2Uz
ODIwNmE4NGJmODQ4NWU3YzU1MzQxMjI3NDcwOGNlNS9kbWVzZy1xdWFudGFsLWl2YjQ0LTEy
NjoyMDE0MDYxMzA0MDkxNDp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLXJjMy0w
MDExOS1nYjQ4YWE5NzoyOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvYjQ4
YWE5N2UzODIwNmE4NGJmODQ4NWU3YzU1MzQxMjI3NDcwOGNlNS9kbWVzZy1xdWFudGFsLWl2
YjQ0LTU0OjIwMTQwNjEzMDQwOTA5Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAt
cmMzLTAwMTE5LWdiNDhhYTk3OjI4CjA6MTE6MTEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKG1sxOzM1bTIwMTQtMDYtMTMgMDQ6MDk6NTQgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9i
b290LWJpc2VjdC9saW51eDgvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA0
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpb
ODg2YjQ3MGNiMTQ3MzNhMDI4NmUzNjVjNzdmMTg0NGMyNDBjMzNhNF0gS1ZNOiB4ODY6IHBh
c3MgaG9zdF90c2MgdG8gcmVhZF9sMV90c2MKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4OC9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1qMS0wNjEyL2Jhc2Vyb2NrOmJhc2Vyb2NrOm1vcnBoOjg4NmI0NzBjYjE0NzMzYTAyODZl
MzY1Yzc3ZjE4NDRjMjQwYzMzYTQ6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNi0xMy0wNDoxMDow
MyA4ODZiNDcwY2IxNDczM2EwMjg2ZTM2NWM3N2YxODQ0YzI0MGMzM2E0IGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLWoxLTA2MTItODg2YjQ3MGNiMTQ3MzNhMDI4NmUzNjVjNzdmMTg0NGMyNDBj
MzNhNApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEt
MDYxMi84ODZiNDcwY2IxNDczM2EwMjg2ZTM2NWM3N2YxODQ0YzI0MGMzM2E0CndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFu
ZGNvbmZpZy1qMS0wNjEyLTg4NmI0NzBjYjE0NzMzYTAyODZlMzY1Yzc3ZjE4NDRjMjQwYzMz
YTQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
Ly54ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLTg4NmI0NzBjYjE0NzMzYTAyODZlMzY1Yzc3
ZjE4NDRjMjQwYzMzYTQKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2
MTIvODg2YjQ3MGNiMTQ3MzNhMDI4NmUzNjVjNzdmMTg0NGMyNDBjMzNhNC92bWxpbnV6LTMu
Ny4wLXJjMy0wMDExNC1nODg2YjQ3MAoKMjAxNC0wNi0xMy0wNDozMzowNiBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAuMDAwMDAwXSBtYXBwZWQgSU9BUElD
IHRvIGZmZmZmZmZmZmY1ZjgwMDAgKGZlYzAwMDAwKQpbICAgIDAuMDAwMDAwXSBucl9pcnFz
X2dzaTogNDAKWyAgICAwLjAwMDAwMF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0t
LS0tLS0tClsgICAgMC4wMDAwMDBdIFdBUk5JTkc6IGF0IC9rYnVpbGQvc3JjL3g4Nl82NC9h
cmNoL3g4Ni9rZXJuZWwvcHZjbG9jay5jOjE4MiBwdmNsb2NrX2luaXRfdnN5c2NhbGwrMHgy
MS8weDU5KCkKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFtZTogQm9jaHMKWyAgICAwLjAw
MDAwMF0gUGlkOiAwLCBjb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuNy4wLXJjMy0wMDEx
NC1nODg2YjQ3MCAjMzAKWyAgICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MTA2MjI1NT5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4N2MvMHg5
NApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDYyMzQzPl0gd2Fybl9zbG93cGF0aF9u
dWxsKzB4MWEvMHgxYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2RlN2M5Pl0gcHZj
bG9ja19pbml0X3ZzeXNjYWxsKzB4MjEvMHg1OQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZm
ZjgxY2RlNzViPl0ga3ZtX3NldHVwX3ZzeXNjYWxsX3RpbWVpbmZvKzB4NTkvMHg4YgpbICAg
IDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2RlNGNmPl0ga3ZtX2d1ZXN0X2luaXQrMHhlNC8w
eGZlClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZDNmOWU+XSBzZXR1cF9hcmNoKzB4
YTY0LzB4YWQ5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZDE4OTM+XSBzdGFydF9r
ZXJuZWwrMHhkYy8weDQzMApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2QxMTIwPl0g
PyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAgICAwLjAwMDAwMF0gIFs8ZmZm
ZmZmZmY4MWNkMTJiND5dIHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMrMHhiMC8weGIzClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZDEzYjk+XSB4ODZfNjRfc3RhcnRfa2VybmVs
KzB4MTAyLzB4MTBmClsgICAgMC4wMDAwMDBdIC0tLVsgZW5kIHRyYWNlIDI5NGRmZDAwZTY4
ZWRkM2QgXS0tLQpbICAgIDAuMDAwMDAwXSBlODIwOiBbbWVtIDB4MTQwMDAwMDAtMHhmZWZm
YmZmZl0gYXZhaWxhYmxlIGZvciBQQ0kgZGV2aWNlcwova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWoxLTA2MTIvODg2YjQ3MGNiMTQ3MzNhMDI4NmUzNjVjNzdmMTg0NGMyNDBjMzNhNC9k
bWVzZy1xdWFudGFsLWl2YjQyLTM0OjIwMTQwNjEzMDQzMjQ0Ong4Nl82NC1yYW5kY29uZmln
LWoxLTA2MTI6My43LjAtcmMzLTAwMTE0LWc4ODZiNDcwOjMwCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctajEtMDYxMi84ODZiNDcwY2IxNDczM2EwMjg2ZTM2NWM3N2YxODQ0YzI0MGMz
M2E0L2RtZXNnLXF1YW50YWwtaXZiNDQtMjc6MjAxNDA2MTMwNDMyNDM6eDg2XzY0LXJhbmRj
b25maWctajEtMDYxMjozLjcuMC1yYzMtMDAxMTQtZzg4NmI0NzA6MzAKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1qMS0wNjEyLzg4NmI0NzBjYjE0NzMzYTAyODZlMzY1Yzc3ZjE4NDRj
MjQwYzMzYTQvZG1lc2ctcXVhbnRhbC1pdmI0MS0zNToyMDE0MDYxMzA0MzI0NTp4ODZfNjQt
cmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLXJjMy0wMDExNC1nODg2YjQ3MDozMAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvODg2YjQ3MGNiMTQ3MzNhMDI4NmUzNjVjNzdm
MTg0NGMyNDBjMzNhNC9kbWVzZy1xdWFudGFsLWl2YjQyLTE5OjIwMTQwNjEzMDQzMjUyOng4
Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTE0LWc4ODZiNDcwOjMwCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi84ODZiNDcwY2IxNDczM2EwMjg2ZTM2
NWM3N2YxODQ0YzI0MGMzM2E0L2RtZXNnLXF1YW50YWwtaXZiNDItMjI6MjAxNDA2MTMwNDMy
NDc6eDg2XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC1yYzMtMDAxMTQtZzg4NmI0NzA6
MzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzg4NmI0NzBjYjE0NzMzYTAy
ODZlMzY1Yzc3ZjE4NDRjMjQwYzMzYTQvZG1lc2ctcXVhbnRhbC1pdmI0NC0yNDoyMDE0MDYx
MzA0MzI1NDp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLXJjMy0wMDExNC1nODg2
YjQ3MDozMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvODg2YjQ3MGNiMTQ3
MzNhMDI4NmUzNjVjNzdmMTg0NGMyNDBjMzNhNC9kbWVzZy1xdWFudGFsLWl2YjQ0LTUzOjIw
MTQwNjEzMDQzMjQ3Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTE0
LWc4ODZiNDcwOjMwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi84ODZiNDcw
Y2IxNDczM2EwMjg2ZTM2NWM3N2YxODQ0YzI0MGMzM2E0L2RtZXNnLXF1YW50YWwtaXZiNDQt
Njc6MjAxNDA2MTMwNDMyNDY6eDg2XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC1yYzMt
MDAxMTQtZzg4NmI0NzA6MzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzg4
NmI0NzBjYjE0NzMzYTAyODZlMzY1Yzc3ZjE4NDRjMjQwYzMzYTQvZG1lc2ctcXVhbnRhbC1p
dmI0MS0yMToyMDE0MDYxMzA0MzI1ODp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4w
LXJjMy0wMDExNC1nODg2YjQ3MDozMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2
MTIvODg2YjQ3MGNiMTQ3MzNhMDI4NmUzNjVjNzdmMTg0NGMyNDBjMzNhNC9kbWVzZy1xdWFu
dGFsLWl2YjQyLTEwMjoyMDE0MDYxMzA0MzI1ODp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEy
OjMuNy4wLXJjMy0wMDExNC1nODg2YjQ3MDozMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWoxLTA2MTIvODg2YjQ3MGNiMTQ3MzNhMDI4NmUzNjVjNzdmMTg0NGMyNDBjMzNhNC9kbWVz
Zy1xdWFudGFsLWl2YjQyLTc3OjIwMTQwNjEzMDQzMjU3Ong4Nl82NC1yYW5kY29uZmlnLWox
LTA2MTI6My43LjAtcmMzLTAwMTE0LWc4ODZiNDcwOjMwCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctajEtMDYxMi84ODZiNDcwY2IxNDczM2EwMjg2ZTM2NWM3N2YxODQ0YzI0MGMzM2E0
L2RtZXNnLXF1YW50YWwtaXZiNDQtMTAxOjIwMTQwNjEzMDQzMjU3Ong4Nl82NC1yYW5kY29u
ZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTE0LWc4ODZiNDcwOjMwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctajEtMDYxMi84ODZiNDcwY2IxNDczM2EwMjg2ZTM2NWM3N2YxODQ0YzI0
MGMzM2E0L2RtZXNnLXF1YW50YWwtaXZiNDQtMTEzOjIwMTQwNjEzMDQzMjU4Ong4Nl82NC1y
YW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTE0LWc4ODZiNDcwOjMwCjA6MTM6MTMg
YWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDYtMTMgMDQ6MzM6Mzcg
UkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eDgvb2JqLWJpc2VjdC8u
cmVwZWF0G1swbQoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAxIHN0ZXApCls3MTA1NmFlMjJkNDNmNThkN2UwZjc5M2FmMThhY2Uy
ZWFmNWI3NGViXSB4ODY6IHB2Y2xvY2s6IGdlbmVyaWMgcHZjbG9jayB2c3lzY2FsbCBpbml0
aWFsaXphdGlvbgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg4L29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvYmFzZXJv
Y2s6YmFzZXJvY2s6bW9ycGg6NzEwNTZhZTIyZDQzZjU4ZDdlMGY3OTNhZjE4YWNlMmVhZjVi
NzRlYjpiaXNlY3QtbGludXg4CgoyMDE0LTA2LTEzLTA0OjMzOjM4IDcxMDU2YWUyMmQ0M2Y1
OGQ3ZTBmNzkzYWYxOGFjZTJlYWY1Yjc0ZWIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctajEtMDYx
Mi03MTA1NmFlMjJkNDNmNThkN2UwZjc5M2FmMThhY2UyZWFmNWI3NGViCkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzcxMDU2YWUyMmQ0
M2Y1OGQ3ZTBmNzkzYWYxOGFjZTJlYWY1Yjc0ZWIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIt
NzEwNTZhZTIyZDQzZjU4ZDdlMGY3OTNhZjE4YWNlMmVhZjViNzRlYgp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29u
ZmlnLWoxLTA2MTItNzEwNTZhZTIyZDQzZjU4ZDdlMGY3OTNhZjE4YWNlMmVhZjViNzRlYgpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi83MTA1NmFlMjJkNDNm
NThkN2UwZjc5M2FmMThhY2UyZWFmNWI3NGViL3ZtbGludXotMy43LjAtcmMzLTAwMTExLWc3
MTA1NmFlCgoyMDE0LTA2LTEzLTA0OjU2OjM5IGRldGVjdGluZyBib290IHN0YXRlIAkxMwkx
NQkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzUxYzE5YjRmNTkyN2Y1YTY0NmU5M2Q2OWY3M2M3
ZTg5ZWExNGU3MzddIHg4NjogdmRzbzogcHZjbG9jayBnZXR0aW1lIHN1cHBvcnQKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4OC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2Jhc2Vyb2NrOmJhc2Vyb2NrOm1vcnBo
OjUxYzE5YjRmNTkyN2Y1YTY0NmU5M2Q2OWY3M2M3ZTg5ZWExNGU3Mzc6YmlzZWN0LWxpbnV4
OAoKMjAxNC0wNi0xMy0wNDo1ODoxMCA1MWMxOWI0ZjU5MjdmNWE2NDZlOTNkNjlmNzNjN2U4
OWVhMTRlNzM3IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTItNTFjMTliNGY1OTI3ZjVh
NjQ2ZTkzZDY5ZjczYzdlODllYTE0ZTczNwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctajEtMDYxMi81MWMxOWI0ZjU5MjdmNWE2NDZlOTNkNjlmNzNj
N2U4OWVhMTRlNzM3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLTUxYzE5YjRmNTkyN2Y1YTY0
NmU5M2Q2OWY3M2M3ZTg5ZWExNGU3MzcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLTUxYzE5
YjRmNTkyN2Y1YTY0NmU5M2Q2OWY3M2M3ZTg5ZWExNGU3MzcKa2VybmVsOiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvNTFjMTliNGY1OTI3ZjVhNjQ2ZTkzZDY5ZjczYzdl
ODllYTE0ZTczNy92bWxpbnV6LTMuNy4wLXJjMy0wMDExMy1nNTFjMTliNAoKMjAxNC0wNi0x
My0wNToxNjoxMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAu
MDAwMDAwXSBtYXBwZWQgSU9BUElDIHRvIGZmZmZmZmZmZmY1ZjgwMDAgKGZlYzAwMDAwKQpb
ICAgIDAuMDAwMDAwXSBucl9pcnFzX2dzaTogNDAKWyAgICAwLjAwMDAwMF0gLS0tLS0tLS0t
LS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4wMDAwMDBdIFdBUk5JTkc6IGF0
IC9rYnVpbGQvc3JjL3g4Nl82NC9hcmNoL3g4Ni9rZXJuZWwvcHZjbG9jay5jOjE4MiBwdmNs
b2NrX2luaXRfdnN5c2NhbGwrMHgyMS8weDU5KCkKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUg
bmFtZTogQm9jaHMKWyAgICAwLjAwMDAwMF0gUGlkOiAwLCBjb21tOiBzd2FwcGVyIE5vdCB0
YWludGVkIDMuNy4wLXJjMy0wMDExMy1nNTFjMTliNCAjMzUKWyAgICAwLjAwMDAwMF0gQ2Fs
bCBUcmFjZToKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA2MjI1NT5dIHdhcm5fc2xv
d3BhdGhfY29tbW9uKzB4N2MvMHg5NApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDYy
MzQzPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MWEvMHgxYwpbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgxY2RlN2M5Pl0gcHZjbG9ja19pbml0X3ZzeXNjYWxsKzB4MjEvMHg1OQpbICAg
IDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2RlNzViPl0ga3ZtX3NldHVwX3ZzeXNjYWxsX3Rp
bWVpbmZvKzB4NTkvMHg4YgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2RlNGNmPl0g
a3ZtX2d1ZXN0X2luaXQrMHhlNC8weGZlClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFj
ZDNmOWU+XSBzZXR1cF9hcmNoKzB4YTY0LzB4YWQ5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZm
ZmZmODFjZDE4OTM+XSBzdGFydF9rZXJuZWwrMHhkYy8weDQzMApbICAgIDAuMDAwMDAwXSAg
WzxmZmZmZmZmZjgxY2QxMTIwPl0gPyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAK
WyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkMTJiND5dIHg4Nl82NF9zdGFydF9yZXNl
cnZhdGlvbnMrMHhiMC8weGIzClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjZDEzYjk+
XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4MTAyLzB4MTBmClsgICAgMC4wMDAwMDBdIC0tLVsg
ZW5kIHRyYWNlIGU3MWRjMjdiM2RmZTcwNGMgXS0tLQpbICAgIDAuMDAwMDAwXSBlODIwOiBb
bWVtIDB4MTQwMDAwMDAtMHhmZWZmYmZmZl0gYXZhaWxhYmxlIGZvciBQQ0kgZGV2aWNlcwov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvNTFjMTliNGY1OTI3ZjVhNjQ2ZTkz
ZDY5ZjczYzdlODllYTE0ZTczNy9kbWVzZy1xdWFudGFsLWl2YjQxLTUzOjIwMTQwNjEzMDUx
NTM5Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTEzLWc1MWMxOWI0
OjM1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi81MWMxOWI0ZjU5MjdmNWE2
NDZlOTNkNjlmNzNjN2U4OWVhMTRlNzM3L2RtZXNnLXF1YW50YWwtaXZiNDItMTEwOjIwMTQw
NjEzMDUxNTM5Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTEzLWc1
MWMxOWI0OjM1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi81MWMxOWI0ZjU5
MjdmNWE2NDZlOTNkNjlmNzNjN2U4OWVhMTRlNzM3L2RtZXNnLXF1YW50YWwtaXZiNDItMTk6
MjAxNDA2MTMwNTE1Mzk6eDg2XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC1yYzMtMDAx
MTMtZzUxYzE5YjQ6MzUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzUxYzE5
YjRmNTkyN2Y1YTY0NmU5M2Q2OWY3M2M3ZTg5ZWExNGU3MzcvZG1lc2ctcXVhbnRhbC1pdmI0
Mi00NToyMDE0MDYxMzA1MTUzOTp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLXJj
My0wMDExMy1nNTFjMTliNDozNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIv
NTFjMTliNGY1OTI3ZjVhNjQ2ZTkzZDY5ZjczYzdlODllYTE0ZTczNy9kbWVzZy1xdWFudGFs
LWl2YjQyLTUyOjIwMTQwNjEzMDUxNTM5Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43
LjAtcmMzLTAwMTEzLWc1MWMxOWI0OjM1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEt
MDYxMi81MWMxOWI0ZjU5MjdmNWE2NDZlOTNkNjlmNzNjN2U4OWVhMTRlNzM3L2RtZXNnLXF1
YW50YWwtaXZiNDItNTU6MjAxNDA2MTMwNTE1Mzk6eDg2XzY0LXJhbmRjb25maWctajEtMDYx
MjozLjcuMC1yYzMtMDAxMTMtZzUxYzE5YjQ6MzUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1qMS0wNjEyLzUxYzE5YjRmNTkyN2Y1YTY0NmU5M2Q2OWY3M2M3ZTg5ZWExNGU3MzcvZG1l
c2ctcXVhbnRhbC1pdmI0Mi02OToyMDE0MDYxMzA1MTUzOTp4ODZfNjQtcmFuZGNvbmZpZy1q
MS0wNjEyOjMuNy4wLXJjMy0wMDExMy1nNTFjMTliNDozNQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWoxLTA2MTIvNTFjMTliNGY1OTI3ZjVhNjQ2ZTkzZDY5ZjczYzdlODllYTE0ZTcz
Ny9kbWVzZy1xdWFudGFsLWl2YjQyLTcxOjIwMTQwNjEzMDUxNTM5Ong4Nl82NC1yYW5kY29u
ZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTEzLWc1MWMxOWI0OjM1Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctajEtMDYxMi81MWMxOWI0ZjU5MjdmNWE2NDZlOTNkNjlmNzNjN2U4OWVh
MTRlNzM3L2RtZXNnLXF1YW50YWwtaXZiNDItOTE6MjAxNDA2MTMwNTE1Mzk6eDg2XzY0LXJh
bmRjb25maWctajEtMDYxMjozLjcuMC1yYzMtMDAxMTMtZzUxYzE5YjQ6MzUKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzUxYzE5YjRmNTkyN2Y1YTY0NmU5M2Q2OWY3M2M3
ZTg5ZWExNGU3MzcvZG1lc2ctcXVhbnRhbC1pdmI0Mi05OjIwMTQwNjEzMDUxNTM5Ong4Nl82
NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTEzLWc1MWMxOWI0OjM1Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi81MWMxOWI0ZjU5MjdmNWE2NDZlOTNkNjlm
NzNjN2U4OWVhMTRlNzM3L2RtZXNnLXF1YW50YWwtaXZiNDQtMTA5OjIwMTQwNjEzMDUxNTM5
Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTEzLWc1MWMxOWI0OjM1
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi81MWMxOWI0ZjU5MjdmNWE2NDZl
OTNkNjlmNzNjN2U4OWVhMTRlNzM3L2RtZXNnLXF1YW50YWwtaXZiNDQtMTU6MjAxNDA2MTMw
NTE1Mzg6eDg2XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC1yYzMtMDAxMTMtZzUxYzE5
YjQ6MzUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzUxYzE5YjRmNTkyN2Y1
YTY0NmU5M2Q2OWY3M2M3ZTg5ZWExNGU3MzcvZG1lc2ctcXVhbnRhbC1pdmI0NC00NjoyMDE0
MDYxMzA1MTUzOTp4ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLXJjMy0wMDExMy1n
NTFjMTliNDozNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvNTFjMTliNGY1
OTI3ZjVhNjQ2ZTkzZDY5ZjczYzdlODllYTE0ZTczNy9kbWVzZy1xdWFudGFsLWl2YjQ0LTcz
OjIwMTQwNjEzMDUxNTM5Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAw
MTEzLWc1MWMxOWI0OjM1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi81MWMx
OWI0ZjU5MjdmNWE2NDZlOTNkNjlmNzNjN2U4OWVhMTRlNzM3L2RtZXNnLXF1YW50YWwtaXZi
NDQtODg6MjAxNDA2MTMwNTE1Mzk6eDg2XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC1y
YzMtMDAxMTMtZzUxYzE5YjQ6MzUKMDoxNToxNSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwobWzE7MzVtMjAxNC0wNi0xMyAwNToxNjo0MSBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4OC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDAg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpClsz
ZGM0ZjdjZmI3NDQxZTVlMGZlZDNhMDJmYzgxY2RhYWJkMjgzMDBhXSB4ODY6IGt2bSBndWVz
dDogcHZjbG9jayB2c3lzY2FsbCBzdXBwb3J0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDgvb2JqLWJp
c2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctajEtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDozZGM0ZjdjZmI3NDQxZTVlMGZl
ZDNhMDJmYzgxY2RhYWJkMjgzMDBhOmJpc2VjdC1saW51eDgKCjIwMTQtMDYtMTMtMDU6MTY6
NDEgM2RjNGY3Y2ZiNzQ0MWU1ZTBmZWQzYTAyZmM4MWNkYWFiZDI4MzAwYSBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1qMS0wNjEyLTNkYzRmN2NmYjc0NDFlNWUwZmVkM2EwMmZjODFjZGFhYmQy
ODMwMGEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWox
LTA2MTIvM2RjNGY3Y2ZiNzQ0MWU1ZTBmZWQzYTAyZmM4MWNkYWFiZDI4MzAwYQp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctajEtMDYxMi0zZGM0ZjdjZmI3NDQxZTVlMGZlZDNhMDJmYzgxY2RhYWJkMjgz
MDBhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS8ueDg2XzY0LXJhbmRjb25maWctajEtMDYxMi0zZGM0ZjdjZmI3NDQxZTVlMGZlZDNhMDJm
YzgxY2RhYWJkMjgzMDBhCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0w
NjEyLzNkYzRmN2NmYjc0NDFlNWUwZmVkM2EwMmZjODFjZGFhYmQyODMwMGEvdm1saW51ei0z
LjcuMC1yYzMtMDAxMTItZzNkYzRmN2MKCjIwMTQtMDYtMTMtMDU6Mzk6NDEgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gbWFwcGVkIElPQVBJ
QyB0byBmZmZmZmZmZmZmNWY4MDAwIChmZWMwMDAwMCkKWyAgICAwLjAwMDAwMF0gbnJfaXJx
c19nc2k6IDQwClsgICAgMC4wMDAwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0t
LS0tLS0tLQpbICAgIDAuMDAwMDAwXSBXQVJOSU5HOiBhdCAva2J1aWxkL3NyYy94ODZfNjQv
YXJjaC94ODYva2VybmVsL3B2Y2xvY2suYzoxODIgcHZjbG9ja19pbml0X3ZzeXNjYWxsKzB4
MjEvMHg1OSgpClsgICAgMC4wMDAwMDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzClsgICAgMC4w
MDAwMDBdIFBpZDogMCwgY29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjcuMC1yYzMtMDAx
MTItZzNkYzRmN2MgIzM3ClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODEwNjIyNTU+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDdjLzB4
OTQKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA2MjM0Mz5dIHdhcm5fc2xvd3BhdGhf
bnVsbCsweDFhLzB4MWMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkZDdjOT5dIHB2
Y2xvY2tfaW5pdF92c3lzY2FsbCsweDIxLzB4NTkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MWNkZDc1Yj5dIGt2bV9zZXR1cF92c3lzY2FsbF90aW1laW5mbysweDU5LzB4OGIKWyAg
ICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkZDRjZj5dIGt2bV9ndWVzdF9pbml0KzB4ZTQv
MHhmZQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2QyZjllPl0gc2V0dXBfYXJjaCsw
eGE2NC8weGFkOQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2QwODkzPl0gc3RhcnRf
a2VybmVsKzB4ZGMvMHg0MzAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNkMDEyMD5d
ID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wMDAwMDBdICBbPGZm
ZmZmZmZmODFjZDAyYjQ+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4YjAvMHhiMwpb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2QwM2I5Pl0geDg2XzY0X3N0YXJ0X2tlcm5l
bCsweDEwMi8weDEwZgpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSA2ZTkxZGU0ZDk3
NjM0OTMzIF0tLS0KWyAgICAwLjAwMDAwMF0gZTgyMDogW21lbSAweDE0MDAwMDAwLTB4ZmVm
ZmJmZmZdIGF2YWlsYWJsZSBmb3IgUENJIGRldmljZXMKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1qMS0wNjEyLzNkYzRmN2NmYjc0NDFlNWUwZmVkM2EwMmZjODFjZGFhYmQyODMwMGEv
ZG1lc2ctcXVhbnRhbC1pdmI0Mi03MzoyMDE0MDYxMzA1MzkzNTp4ODZfNjQtcmFuZGNvbmZp
Zy1qMS0wNjEyOjMuNy4wLXJjMy0wMDExMi1nM2RjNGY3YzozNwova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWoxLTA2MTIvM2RjNGY3Y2ZiNzQ0MWU1ZTBmZWQzYTAyZmM4MWNkYWFiZDI4
MzAwYS9kbWVzZy1xdWFudGFsLWl2YjQxLTEyMjoyMDE0MDYxMzA1Mzk0MTp4ODZfNjQtcmFu
ZGNvbmZpZy1qMS0wNjEyOjMuNy4wLXJjMy0wMDExMi1nM2RjNGY3YzozNwova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvM2RjNGY3Y2ZiNzQ0MWU1ZTBmZWQzYTAyZmM4MWNk
YWFiZDI4MzAwYS9kbWVzZy1xdWFudGFsLWl2YjQxLTY5OjIwMTQwNjEzMDUzOTQ1Ong4Nl82
NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTEyLWczZGM0ZjdjOjM3Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi8zZGM0ZjdjZmI3NDQxZTVlMGZlZDNhMDJm
YzgxY2RhYWJkMjgzMDBhL2RtZXNnLXF1YW50YWwtaXZiNDItNDoyMDE0MDYxMzA1Mzk0Njp4
ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyOjMuNy4wLXJjMy0wMDExMi1nM2RjNGY3YzozNwov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTIvM2RjNGY3Y2ZiNzQ0MWU1ZTBmZWQz
YTAyZmM4MWNkYWFiZDI4MzAwYS9kbWVzZy1xdWFudGFsLWl2YjQxLTI4OjIwMTQwNjEzMDUz
OTUxOng4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMzLTAwMTEyLWczZGM0Zjdj
OjM3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi8zZGM0ZjdjZmI3NDQxZTVl
MGZlZDNhMDJmYzgxY2RhYWJkMjgzMDBhL2RtZXNnLXF1YW50YWwtaXZiNDEtNDk6MjAxNDA2
MTMwNTM5NTQ6eDg2XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC1yYzMtMDAxMTItZzNk
YzRmN2M6MzcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzNkYzRmN2NmYjc0
NDFlNWUwZmVkM2EwMmZjODFjZGFhYmQyODMwMGEvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMTQ6
MjAxNDA2MTMwNTQwMTA6eDg2XzY0LXJhbmRjb25maWctajEtMDYxMjozLjcuMC1yYzMtMDAx
MTItZzNkYzRmN2M6MzcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzNkYzRm
N2NmYjc0NDFlNWUwZmVkM2EwMmZjODFjZGFhYmQyODMwMGEvZG1lc2ctcXVhbnRhbC1pdmI0
Mi00OjIwMTQwNjEzMDU0MDA5Ong4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTI6My43LjAtcmMz
LTAwMTEyLWczZGM0ZjdjOjM3CjA6ODo2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgoz
ZGM0ZjdjZmI3NDQxZTVlMGZlZDNhMDJmYzgxY2RhYWJkMjgzMDBhIGlzIHRoZSBmaXJzdCBi
YWQgY29tbWl0CmNvbW1pdCAzZGM0ZjdjZmI3NDQxZTVlMGZlZDNhMDJmYzgxY2RhYWJkMjgz
MDBhCkF1dGhvcjogTWFyY2VsbyBUb3NhdHRpIDxtdG9zYXR0aUByZWRoYXQuY29tPgpEYXRl
OiAgIFR1ZSBOb3YgMjcgMjM6Mjg6NTYgMjAxMiAtMDIwMAoKICAgIHg4Njoga3ZtIGd1ZXN0
OiBwdmNsb2NrIHZzeXNjYWxsIHN1cHBvcnQKICAgIAogICAgSG9vayBpbnRvIGdlbmVyaWMg
cHZjbG9jayB2c3lzY2FsbCBjb2RlLCB3aXRoIHRoZSBhaW0gdG8KICAgIGFsbG93IHVzZXJz
cGFjZSB0byBoYXZlIHZpc2liaWxpdHkgaW50byBwdmNsb2NrIGRhdGEuCiAgICAKICAgIFNp
Z25lZC1vZmYtYnk6IE1hcmNlbG8gVG9zYXR0aSA8bXRvc2F0dGlAcmVkaGF0LmNvbT4KCjow
NDAwMDAgMDQwMDAwIDZmODczNDQ4OTU5YjQxZmUxNWRlOGM3ZDY4NmI0ZGE0ZjI5MjFhZjUg
ODEyMTQ5NDc2ZWI4YmYyYWI5NzI1ZTI0MjY3NWE0ZmYwNWNlN2QyOCBNCWFyY2gKYmlzZWN0
IHJ1biBzdWNjZXNzClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDNkYzRmN2MuLi4geDg2
OiBrdm0gZ3Vlc3Q6IHB2Y2xvY2sgdnN5c2NhbGwgc3VwcG9ydApIRUFEIGlzIG5vdyBhdCA3
MTA1NmFlLi4uIHg4NjogcHZjbG9jazogZ2VuZXJpYyBwdmNsb2NrIHZzeXNjYWxsIGluaXRp
YWxpemF0aW9uCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1qMS0wNjEyL2Jhc2Vyb2NrOmJhc2Vyb2NrOm1vcnBoOjcxMDU2YWUyMmQ0M2Y1
OGQ3ZTBmNzkzYWYxOGFjZTJlYWY1Yjc0ZWI6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNi0xMy0w
NTo0MDoxMyA3MTA1NmFlMjJkNDNmNThkN2UwZjc5M2FmMThhY2UyZWFmNWI3NGViIHJldXNl
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi83MTA1NmFlMjJkNDNmNThkN2Uw
Zjc5M2FmMThhY2UyZWFmNWI3NGViL3ZtbGludXotMy43LjAtcmMzLTAwMTExLWc3MTA1NmFl
CgoyMDE0LTA2LTEzLTA1OjQwOjEzIGRldGVjdGluZyBib290IHN0YXRlIAkyMwkzNQk0Mwk1
MQk2MCBTVUNDRVNTCgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA3MTA1NmFlLi4uIHg4
NjogcHZjbG9jazogZ2VuZXJpYyBwdmNsb2NrIHZzeXNjYWxsIGluaXRpYWxpemF0aW9uCkhF
QUQgaXMgbm93IGF0IGQ2N2EwZTEuLi4gbW9ycGhvbG9naWVzOiBFbmFibGUgQ09ORklHX0ZI
QU5ETEUKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLWoxLTA2MTIvYmFzZXJvY2s6YmFzZXJvY2s6bW9ycGg6ZDY3YTBlMTEwMTg3YWJkNTYw
YTFkZTYzZmExNzI4OTRhNTI4MzlkNTpiaXNlY3QtbGludXg4CgoyMDE0LTA2LTEzLTA1OjQz
OjI0IGQ2N2EwZTExMDE4N2FiZDU2MGExZGU2M2ZhMTcyODk0YTUyODM5ZDUgcmV1c2UgL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyL2Q2N2EwZTExMDE4N2FiZDU2MGExZGU2
M2ZhMTcyODk0YTUyODM5ZDUvdm1saW51ei0zLjE1LjAtMDQ3OTUtZ2Q2N2EwZTEKCjIwMTQt
MDYtMTMtMDU6NDM6MjQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTYJMzQuCTQ0CTYwIFNVQ0NF
U1MKCkhFQUQgaXMgbm93IGF0IGQ2N2EwZTEgbW9ycGhvbG9naWVzOiBFbmFibGUgQ09ORklH
X0ZIQU5ETEUKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRnJvbSBnaXQ6Ly9naXRt
aXJyb3IvbGludXMKICAgNWMwMmMzOS4uMGUwNGM2NCAgbWFzdGVyICAgICAtPiBsaW51cy9t
YXN0ZXIKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZDY3YTBlMS4uLiBtb3JwaG9sb2dp
ZXM6IEVuYWJsZSBDT05GSUdfRkhBTkRMRQpIRUFEIGlzIG5vdyBhdCAwZTA0YzY0Li4uIE1l
cmdlIHRhZyAnZG0tMy4xNi1jaGFuZ2VzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvZGV2aWNlLW1hcHBlci9saW51eC1kbQpscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctajEtMDYxMi9saW51
czptYXN0ZXI6MGUwNGM2NDFiMTk5NDM1ZjM3Nzk0NTQwNTVmNmE3ZGUyNThlY2RmYzpiaXNl
Y3QtbGludXg4CgoyMDE0LTA2LTEzLTA1OjQ2OjA4IDBlMDRjNjQxYjE5OTQzNWYzNzc5NDU0
MDU1ZjZhN2RlMjU4ZWNkZmMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi0wZTA0YzY0
MWIxOTk0MzVmMzc3OTQ1NDA1NWY2YTdkZTI1OGVjZGZjCkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1qMS0wNjEyLzBlMDRjNjQxYjE5OTQzNWYzNzc5
NDU0MDU1ZjZhN2RlMjU4ZWNkZmMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2MTItMGUwNGM2NDFi
MTk5NDM1ZjM3Nzk0NTQwNTVmNmE3ZGUyNThlY2RmYwp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWoxLTA2
MTItMGUwNGM2NDFiMTk5NDM1ZjM3Nzk0NTQwNTVmNmE3ZGUyNThlY2RmYwprZXJuZWw6IC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctajEtMDYxMi8wZTA0YzY0MWIxOTk0MzVmMzc3OTQ1
NDA1NWY2YTdkZTI1OGVjZGZjL3ZtbGludXotMy4xNS4wLTA5OTMwLWcwZTA0YzY0CgoyMDE0
LTA2LTEzLTA2OjAzOjA4IGRldGVjdGluZyBib290IHN0YXRlIC4JNAkyMgkzNAk1NQk2MCBT
VUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09CkZyb20gZ2l0Oi8vZ2l0
bWlycm9yL25leHQKICsgMmJhYzc1Yy4uLmY2MGJmMzUgYWtwbSAgICAgICAtPiBuZXh0L2Fr
cG0gIChmb3JjZWQgdXBkYXRlKQogKyA0ZGY5ZTg5Li4uZGFkYTkxNSBha3BtLWJhc2UgIC0+
IG5leHQvYWtwbS1iYXNlICAoZm9yY2VkIHVwZGF0ZSkKICsgMTZiMGU2NS4uLmIxY2NlNjIg
bWFzdGVyICAgICAtPiBuZXh0L21hc3RlciAgKGZvcmNlZCB1cGRhdGUpCiAgIDI5MzdmNWUu
LjQyNTFjMmE2IHN0YWJsZSAgICAgLT4gbmV4dC9zdGFibGUKRnJvbSBnaXQ6Ly9naXRtaXJy
b3IvbmV4dAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNjEyIC0+IG5leHQtMjAx
NDA2MTIKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMGUwNGM2NC4uLiBNZXJnZSB0YWcg
J2RtLTMuMTYtY2hhbmdlcycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2RldmljZS1tYXBwZXIvbGludXgtZG0KSEVBRCBpcyBub3cgYXQgYjFj
Y2U2Mi4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA2MTIKbHMg
LWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWoxLTA2
MTIvbmV4dDptYXN0ZXI6YjFjY2U2MjBmZDRiNjg2NGM5MmU3MzA3YmU3ODM5Nzg5ZjljOGJl
MDpiaXNlY3QtbGludXg4CgoyMDE0LTA2LTEzLTA2OjA2OjMwIGIxY2NlNjIwZmQ0YjY4NjRj
OTJlNzMwN2JlNzgzOTc4OWY5YzhiZTAgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1qMS0wNjEyL2IxY2NlNjIwZmQ0YjY4NjRjOTJlNzMwN2JlNzgzOTc4OWY5YzhiZTAvdm1s
aW51ei0zLjE1LjAtbmV4dC0yMDE0MDYxMgoKMjAxNC0wNi0xMy0wNjowNjozMCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAJNQkxOAkyNQk1MQk2MCBTVUNDRVNTCgo=
--------------030807040400090905020506
Content-Type: text/plain; charset=UTF-8;
 name="config-3.7.0-rc3-00112-g3dc4f7c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.7.0-rc3-00112-g3dc4f7c"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.7.0-rc3 Kernel Configuration
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
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_USER_QS=y
# CONFIG_RCU_USER_QS_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_GENERIC_KERNEL_THREAD=y
CONFIG_GENERIC_KERNEL_EXECVE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_RCU_USER_QS=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=12
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_PCC_CPUFREQ=y
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
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
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_PHONET is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
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
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_IRQ=y

#
# Bus devices
#
# CONFIG_OMAP_OCP2SCP is not set
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_OOPS=y

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
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=y
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_CAFE=y
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set
# CONFIG_MTD_ONENAND_SIM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
# CONFIG_ISDN is not set

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_88PM860X is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_TTY_PRINTK=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
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
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_HDQ_MASTER_OMAP is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_88PM860X is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_CPU_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_TWL4030_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_SP5100_TCO=y
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

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
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=y
CONFIG_MFD_LM3533=y
# CONFIG_TPS6105X is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65217=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_PALMAS=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_VX_LIB=y
# CONFIG_SND_DRIVERS is not set
# CONFIG_SND_PCI is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
# CONFIG_SND_FIREWIRE_SPEAKERS is not set
CONFIG_SND_ISIGHT=y
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

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
CONFIG_HID_HYPERV_MOUSE=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_OMAP_USB2 is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y

#
# Virtio drivers
#

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_WMI=y
# CONFIG_DELL_WMI_AIO is not set
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_FUJITSU_TABLET=y
CONFIG_HP_ACCEL=y
CONFIG_HP_WMI=y
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
# CONFIG_ASUS_NB_WMI is not set
CONFIG_EEEPC_WMI=y
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_MXM_WMI is not set
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_MAX8997=y
# CONFIG_EXTCON_ARIZONA is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
# CONFIG_PWM_TWL6030 is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_EFI_VARS is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
# CONFIG_JFFS2_ZLIB is not set
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_FTRACE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_MEMORY_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
# CONFIG_DEFAULT_SECURITY_YAMA is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
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
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
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
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y


--------------030807040400090905020506
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

_______________________________________________
LKP mailing list
LKP@linux.intel.com


--------------030807040400090905020506--
