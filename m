Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbaFYJSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:18:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:48837 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbaFYJSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:18:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="552989473"
Date: Wed, 25 Jun 2014 17:17:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mark Brown <broonie@linaro.org>
Cc: Jet Chen <jet.chen@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        "Su, Tao" <tao.su@intel.com>
Subject: [regulator] BUG: kernel early hang without any printk output
Message-ID: <20140625091744.GA27280@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mark,

It seems this merge commit makes the kernel not 100% bootable.
5 out of 53 boots block w/o any dmesg output.

git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-next
commit a920677c35627d1baac9776dfba0286e7a1e1f0f
Merge: 3b9f3f3 ce44beb 03187c7 c969faa 53ddddc
Author:     Mark Brown <broonie@linaro.org>
AuthorDate: Sun Jun 22 11:58:45 2014 +0100

    Merge remote-tracking branches 'regulator/topic/88pm800', 'regulator/topic/ab8500', 'regulator/topic/bcm590xx' and 'regulator/topic/ltc3589' into regulator-next

Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+------------------------------------------------------------+------------+------------+------------+------------+------------+------------+------------------+
|                                                            | 3b9f3f33ad | ce44beb7c0 | 03187c72db | c969faadf0 | 53ddddcad5 | a920677c35 | v3.16-rc2_062302 |
+------------------------------------------------------------+------------+------------+------------+------------+------------+------------+------------------+
| boot_successes                                             | 0          | 306        | 0          | 391        | 0          | 0          | 0                |
| boot_failures                                              | 408        | 0          | 306        | 17         | 408        | 102        | 53               |
| genirq:Flags_mismatch_irq.(serial)vs.(goldfish_pdev_bus)   | 408        | 0          | 306        | 0          | 408        | 96         | 48               |
| WARNING:CPU:PID:at_kernel/events/core.c:perf_swevent_add() | 0          | 0          | 0          | 16         |            |            |                  |
| WARNING:CPU:PID:at_mm/slab_common.c:kmalloc_slab()         | 0          | 0          | 0          | 1          |            |            |                  |
| backtrace:netlink_setsockopt                               | 0          | 0          | 0          | 1          |            |            |                  |
| backtrace:SyS_setsockopt                                   | 0          | 0          | 0          | 1          |            |            |                  |
| backtrace:SyS_socketcall                                   | 0          | 0          | 0          | 1          |            |            |                  |
| BUG:kernel_early_hang_without_any_printk_output            | 0          | 0          | 0          | 0          | 0          | 6          | 5                |
+------------------------------------------------------------+------------+------------+------------+------------+------------+------------+------------------+

BUG: kernel early hang without any printk output
Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-c1-06230242/linux-devel:devel-hourly-2014062302:a920677c35627d1baac9776dfba0286e7a1e1f0f:bisect-linux4/.vmlinuz-a920677c35627d1baac9776dfba0286e7a1e1f0f-20140623053514-40-ivb42 branch=linux-devel/devel-hourly-2014062302 BOOT_IMAGE=/kernel/i386-randconfig-c1-06230242/a920677c35627d1baac9776dfba0286e7a1e1f0f/vmlinuz-3.16.0-rc1-00017-ga920677 drbd.minor_count=8
Early hang kernel: vmlinuz-3.16.0-rc1-00017-ga920677 3.16.0-rc1-00017-ga920677 #6
Elapsed time: 35

git bisect start 375e99ffd57ef530588f58288bc5fe39cf94cbae a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee --
git bisect good b3aa7a29807dac2dd7355ac97eb1462e97acf9e0  # 03:43    102+    102  Merge 'rcu/dev.2014.06.19c' into devel-hourly-2014062302
git bisect  bad 9e6424f1b56fc78818b92a5954fe8e37da497f32  # 04:05      0-      1  Merge 'regulator/for-next' into devel-hourly-2014062302
git bisect good e9ffadad61b2af6372be2e06802c0faeb5550250  # 04:26    102+    102  Merge 'arm-jcooper/irqchip/urgent' into devel-hourly-2014062302
git bisect good 12318f8cc77eab9ca20188257664a2fc9f63a8a9  # 04:48    102+    102  Merge 'arm-soc/for-next' into devel-hourly-2014062302
git bisect good 222980021ed94fe1201ad129ac7672cb7275ecec  # 05:05    102+    102  Merge 'spi/for-next' into devel-hourly-2014062302
git bisect good 3b9f3f33ad71b863673388f88cd2ba7df803e730  # 05:20    102+    102  Merge remote-tracking branch 'regulator/topic/core' into regulator-next
git bisect  bad a920677c35627d1baac9776dfba0286e7a1e1f0f  # 05:48      0-      1  Merge remote-tracking branches 'regulator/topic/88pm800', 'regulator/topic/ab8500', 'regulator/topic/bcm590xx' and 'regulator/topic/ltc3589' into regulator-next
git bisect good c969faadf02076641a81197f2e8641c40d232edd  # 06:07    102+      3  regulator: bcm590xx: remove unnecessary OOM messages
git bisect good ce44beb7c0b12d33ce88b396aeaea0ba4ca1bbfc  # 06:29    102+      0  regulator: 88pm800: remove duplicate PM800_BUCK3 define
git bisect good 53ddddcad5a4fc41db3e2f16c22344d8da58cf74  # 06:44    102+    102  regulator: ltc3589: Staticize ltc3589_reg_defaults
# first bad commit: [a920677c35627d1baac9776dfba0286e7a1e1f0f] Merge remote-tracking branches 'regulator/topic/88pm800', 'regulator/topic/ab8500', 'regulator/topic/bcm590xx' and 'regulator/topic/ltc3589' into regulator-next
git bisect good 3b9f3f33ad71b863673388f88cd2ba7df803e730  # 06:52    306+    408  Merge remote-tracking branch 'regulator/topic/core' into regulator-next
git bisect good ce44beb7c0b12d33ce88b396aeaea0ba4ca1bbfc  # 06:57    306+      0  regulator: 88pm800: remove duplicate PM800_BUCK3 define
git bisect good 03187c72db60e20354aca6802bc5cc3e42c1d6e1  # 07:10    306+    306  regulator: ab8500: Remove ab8500_regulator_debug_init/exit()
git bisect good c969faadf02076641a81197f2e8641c40d232edd  # 07:16    306+     17  regulator: bcm590xx: remove unnecessary OOM messages
git bisect good 53ddddcad5a4fc41db3e2f16c22344d8da58cf74  # 07:23    306+    408  regulator: ltc3589: Staticize ltc3589_reg_defaults
git bisect  bad 375e99ffd57ef530588f58288bc5fe39cf94cbae  # 07:23      0-     53  0day head guard for 'devel-hourly-2014062302'
git bisect good a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee  # 07:41    306+    408  Linux 3.16-rc2
git bisect good 633594bb2d3890711a887897f2003f41735f0dfa  # 08:08    306+    306  Add linux-next specific files for 20140620


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm 
	-kernel $kernel
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
Fengguang

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb42-110:20140623054910:i386-randconfig-c1-06230242:3.16.0-rc1-00017-ga920677:6"
Content-Transfer-Encoding: quoted-printable

BUG: kernel early hang without any printk output
Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=3Dd=
ebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D10 s=
oftlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS=
0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-te=
sts/run-queue/kvm/i386-randconfig-c1-06230242/linux-devel:devel-hourly-2014=
062302:a920677c35627d1baac9776dfba0286e7a1e1f0f:bisect-linux4/.vmlinuz-a920=
677c35627d1baac9776dfba0286e7a1e1f0f-20140623053514-40-ivb42 branch=3Dlinux=
-devel/devel-hourly-2014062302 BOOT_IMAGE=3D/kernel/i386-randconfig-c1-0623=
0242/a920677c35627d1baac9776dfba0286e7a1e1f0f/vmlinuz-3.16.0-rc1-00017-ga92=
0677 drbd.minor_count=3D8
Early hang kernel: vmlinuz-3.16.0-rc1-00017-ga920677 3.16.0-rc1-00017-ga920=
677 #6
Elapsed time: 35
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
1-06230242/a920677c35627d1baac9776dfba0286e7a1e1f0f/vmlinuz-3.16.0-rc1-0001=
7-ga920677 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug ap=
ic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kb=
uild-tests/run-queue/kvm/i386-randconfig-c1-06230242/linux-devel:devel-hour=
ly-2014062302:a920677c35627d1baac9776dfba0286e7a1e1f0f:bisect-linux4/.vmlin=
uz-a920677c35627d1baac9776dfba0286e7a1e1f0f-20140623053514-40-ivb42 branch=
=3Dlinux-devel/devel-hourly-2014062302 BOOT_IMAGE=3D/kernel/i386-randconfig=
-c1-06230242/a920677c35627d1baac9776dfba0286e7a1e1f0f/vmlinuz-3.16.0-rc1-00=
017-ga920677 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-co=
re-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D=
1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pid=
file /dev/shm/kboot/pid-quantal-ivb42-110 -serial file:/dev/shm/kboot/seria=
l-quantal-ivb42-110 -daemonize -display none -monitor null=20

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-100:20140623064903:i386-randconfig-c1-06230242:3.16.0-rc1-00011-g3b9f3f3:5"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Linux version 3.16.0-rc1-00011-g3b9f3f3 (kbuild@jaketown) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #5 Mon Jun 23 05:15:42 CST 2014
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[800fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x037fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13bfffff] page 2M
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x0326b000, 0x0326bfff] PGTABLE
[    0.000000] cma: CMA: reserved 32 MiB at 10400000
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
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
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] BRK [0x0326c000, 0x0326cfff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
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
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 23b65c0
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c1-06230242/linux-d=
evel:devel-hourly-2014062302:3b9f3f33ad71b863673388f88cd2ba7df803e730:bisec=
t-linux4/.vmlinuz-3b9f3f33ad71b863673388f88cd2ba7df803e730-20140623064406-1=
02-ivb41 branch=3Dlinux-devel/devel-hourly-2014062302 BOOT_IMAGE=3D/kernel/=
i386-randconfig-c1-06230242/3b9f3f33ad71b863673388f88cd2ba7df803e730/vmlinu=
z-3.16.0-rc1-00011-g3b9f3f3 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 231300K/327280K available (13531K kernel code, 3900K=
 rwdata, 6468K rodata, 964K init, 10284K bss, 95980K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8d000 - 0xfffff000   ( 456 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff7fe000   (1712 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x82761000 - 0x82852000   ( 964 kB)
[    0.000000]       .data : 0x81d36f81 - 0x8275f200   (10400 kB)
[    0.000000]       .text : 0x81000000 - 0x81d36f81   (13531 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3D80096000 soft=3D80080000
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
[    0.000000]  memory used by lock dependency info: 4895 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.482 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5386.96 Bogo=
MIPS (lpj=3D26934820)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.020078] ACPI: All ACPI Tables successfully acquired
[    0.020670] Security Framework initialized
[    0.021082] Yama: becoming mindful.
[    0.021428] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.022062] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.023456] mce: CPU supports 10 MCE banks
[    0.023858] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023858] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.023858] tlb_flushall_shift: 6
[    0.025056] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.028951] ftrace: allocating 24159 entries in 48 pages
[    0.040314] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.050655]=20
[    0.050655] **********************************************************
[    0.051391] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.051976] **                                                      **
[    0.052533] ** trace_printk() being used. Allocating extra memory.  **
[    0.053095] **                                                      **
[    0.053683] ** This means that this is a DEBUG kernel and it is     **
[    0.054288] ** unsafe for produciton use.                           **
[    0.054805] **                                                      **
[    0.055333] ** If you see this message and you are not debugging    **
[    0.055917] ** the kernel, report this immediately to your vendor!  **
[    0.056525] **                                                      **
[    0.057144] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.057695] **********************************************************
[    0.062966] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.063418] Getting VERSION: 50014
[    0.063702] Getting VERSION: 50014
[    0.063988] Getting ID: 0
[    0.064212] Getting ID: f000000
[    0.064479] Getting LVT0: 8700
[    0.064779] Getting LVT1: 8400
[    0.065058] enabled ExtINT on CPU#0
[    0.066217] ENABLING IO-APIC IRQs
[    0.066498] init IO_APIC IRQs
[    0.066776]  apic 0 pin 0 not connected
[    0.067120] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.067821] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.068518] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.069249] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.069896] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.070051] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.070810] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.071541] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.072186] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.072868] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.073643] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.074417] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.075089] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.075854] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.076552] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.077288]  apic 0 pin 16 not connected
[    0.077641]  apic 0 pin 17 not connected
[    0.077984]  apic 0 pin 18 not connected
[    0.078312]  apic 0 pin 19 not connected
[    0.078673]  apic 0 pin 20 not connected
[    0.079030]  apic 0 pin 21 not connected
[    0.080008]  apic 0 pin 22 not connected
[    0.080399]  apic 0 pin 23 not connected
[    0.080918] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.081453] Using local APIC timer interrupts.
[    0.081453] calibrating APIC timer ...
[    0.090000] ... lapic delta =3D 6249897
[    0.090000] ... PM-Timer delta =3D 357960
[    0.090000] ... PM-Timer result ok
[    0.090000] ..... delta 6249897
[    0.090000] ..... mult: 268431032
[    0.090000] ..... calibration result: 9999835
[    0.090000] ..... CPU clock speed is 2693.5749 MHz.
[    0.090000] ..... host bus clock speed is 999.9835 MHz.
[    0.090000] devtmpfs: initialized
[    0.090000] gcov: version magic: 0x3430382a
[    0.090000] atomic64_test: passed for i386+ platform with CX8 and with S=
SE
[    0.090935] regulator-dummy: no parameters
[    0.092497] RTC time:  6:47:40, date: 06/23/14
[    0.093488] NET: Registered protocol family 16
[    0.095452] cpuidle: using governor ladder
[    0.096546] ACPI: bus type PCI registered
[    0.097305] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.098084] PCI: Using configuration type 1 for base access
[    0.117786] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.118543] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.119902] ACPI: Added _OSI(Module Device)
[    0.120014] ACPI: Added _OSI(Processor Device)
[    0.120562] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.121044] ACPI: Added _OSI(Processor Aggregator Device)
[    0.134686] ACPI: Interpreter enabled
[    0.135190] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140424/hwxface-580)
[    0.136336] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140424/hwxface-580)
[    0.137559] ACPI: (supports S0 S3 S4 S5)
[    0.138055] ACPI: Using IOAPIC for interrupt routing
[    0.138819] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.165464] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.166166] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.166776] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.168214] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.169913] PCI host bridge to bus 0000:00
[    0.170014] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.170620] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.171246] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.171844] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.172697] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.173671] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.175794] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.178114] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.181963] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.183641] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.184405] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.185169] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.185940] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.187574] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.188399] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.189023] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.190684] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.194769] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.196797] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.203642] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.206412] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.208216] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.210588] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.215718] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.217311] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.218380] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.222780] pci_bus 0000:00: on NUMA node 0
[    0.225163] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.226260] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.227262] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.228340] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.229158] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.231234] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.234229] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.235129] vgaarb: loaded
[    0.235413] vgaarb: bridge control possible 0000:00:02.0
[    0.238299] SCSI subsystem initialized
[    0.238884] libata version 3.00 loaded.
[    0.239721] ACPI: bus type USB registered
[    0.240338] usbcore: registered new interface driver usbfs
[    0.241047] usbcore: registered new interface driver hub
[    0.241843] usbcore: registered new device driver usb
[    0.242910] pps_core: LinuxPPS API ver. 1 registered
[    0.243481] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.244408] PTP clock support registered
[    0.245029] EDAC MC: Ver: 3.0.0
[    0.246661] PCI: Using ACPI for IRQ routing
[    0.247102] PCI: pci_cache_line_size set to 64 bytes
[    0.247728] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.248396] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.250937] Switched to clocksource kvm-clock
[    0.252271] Warning: could not register all branches stats
[    0.252843] Warning: could not register annotated branches stats
[    0.335631] FS-Cache: Loaded
[    0.336227] pnp: PnP ACPI init
[    0.336730] ACPI: bus type PNP registered
[    0.337317] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.338445] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.339140] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.340274] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.340932] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.342065] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.342813] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.343599] pnp 00:03: [dma 2]
[    0.344162] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.344969] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.345991] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.346748] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.347816] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.348563] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.349642] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.351237] pnp: PnP ACPI: found 7 devices
[    0.351639] ACPI: bus type PNP unregistered
[    0.390298] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.390869] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.391441] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.392027] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.392738] NET: Registered protocol family 1
[    0.393185] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.393733] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.394320] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.394865] pci 0000:00:02.0: Boot video device
[    0.395449] PCI: CLS 0 bytes, default 64
[    0.397334] Unpacking initramfs...
[    2.222825] Freeing initrd memory: 24852K (927ab000 - 93ff0000)
[    2.224874] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    2.225766] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    2.229052] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.232624] futex hash table entries: 256 (order: 1, 11264 bytes)
[    2.233295] Initialise system trusted keyring
[    2.233884] audit: initializing netlink subsys (disabled)
[    2.234617] audit: type=3D2000 audit(1403477263.126:1): initialized
[    2.520156] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.521244] VFS: Disk quotas dquot_6.5.2
[    2.521764] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.523543] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.523986] QNX4 filesystem 0.2.3 registered.
[    2.524836] befs: version: 0.9.3
[    2.525369] msgmni has been set to 564
[    2.528586] Key type asymmetric registered
[    2.529026] Asymmetric key parser 'x509' registered
[    2.529622] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    2.530386] io scheduler noop registered (default)
[    2.531002] io scheduler cfq registered
[    2.531378] start plist test
[    2.541010] end plist test
[    2.541377] list_sort_test: start testing list_sort()
[    2.543620] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    2.544120] crc32: self tests passed, processed 225944 bytes in 243001 n=
sec
[    2.544991] crc32c: CRC_LE_BITS =3D 32
[    2.545375] crc32c: self tests passed, processed 225944 bytes in 109435 =
nsec
[    2.941284] crc32_combine: 8373 self tests passed
[    3.220167] tsc: Refined TSC clocksource calibration: 2693.447 MHz
[    3.333343] crc32c_combine: 8373 self tests passed
[    3.335870] usbcore: registered new interface driver smscufx
[    3.337230] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.337971] ACPI: Power Button [PWRF]
[    3.474741] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.501101] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.506212] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    3.506950] platform pc8736x_gpio.0: no device found
[    3.508202] nsc_gpio initializing
[    3.508559] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.509076] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    3.509919] Hangcheck: Using getrawmonotonic().
[    3.510536] [drm] Initialized drm 1.1.0 20060810
[    3.511111] usbcore: registered new interface driver udl
[    3.512317] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.513808] Uniform Multi-Platform E-IDE driver
[    3.514377] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    3.521526] scsi: <fdomain> Detection failed (no card)
[    3.572886] Failed initialization of WD-7000 SCSI card!
[    3.573742] osst :I: Tape driver with OnStream support version 0.99.4
[    3.573742] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    3.576456] HSI/SSI char device loaded
[    3.579707] usbcore: registered new interface driver catc
[    3.590258] usbcore: registered new interface driver kaweth
[    3.591218] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    3.592610] usbcore: registered new interface driver pegasus
[    3.593858] usbcore: registered new interface driver rtl8150
[    3.594925] usbcore: registered new interface driver ax88179_178a
[    3.596112] usbcore: registered new interface driver cdc_ether
[    3.597225] usbcore: registered new interface driver sr9700
[    3.598363] usbcore: registered new interface driver CoreChips
[    3.599625] usbcore: registered new interface driver plusb
[    3.600684] usbcore: registered new interface driver cdc_subset
[    3.601886] usbcore: registered new interface driver kalmia
[    3.603057] usbcore: registered new interface driver sierra_net
[    3.604142] usbcore: registered new interface driver cx82310_eth
[    3.605378] usbcore: registered new interface driver cdc_ncm
[    3.606461] usbcore: registered new interface driver huawei_cdc_ncm
[    3.607713] usbcore: registered new interface driver qmi_wwan
[    3.609949] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.611148] ehci-pci: EHCI PCI platform driver
[    3.612608] usbcore: registered new interface driver cdc_wdm
[    3.613908] usbcore: registered new interface driver appledisplay
[    3.615086] usbcore: registered new interface driver cypress_cy7c63
[    3.616230] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    3.617697] usbcore: registered new interface driver idmouse
[    3.618743] usbcore: registered new interface driver iowarrior
[    3.619941] usbcore: registered new interface driver rio500
[    3.621154] usbcore: registered new interface driver usbtest
[    3.622201] usbcore: registered new interface driver yurex
[    3.624692] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.627373] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.628210] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.632589] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.635219] usbcore: registered new interface driver appletouch
[    3.636346] inport.c: Didn't find InPort mouse at 0x23c
[    3.640633] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    3.642069] usbcore: registered new interface driver i2c-tiny-usb
[    3.643017] Driver for 1-wire Dallas network protocol.
[    3.650886] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    3.652248] mixcomwd: No card detected, or port not available
[    3.653354] usbcore: registered new interface driver pcwd_usb
[    3.654414] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    3.656179] acquirewdt: I/O address 0x0043 already in use
[    3.657014] acquirewdt: probe of acquirewdt failed with error -5
[    3.658279] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    3.660050] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    3.661108] it87_wdt: no device
[    3.661638] pc87413_wdt: Version 1.1 at io 0x2E
[    3.662366] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    3.663573] cpu5wdt: misc_register failed
[    3.664236] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    3.666556] smsc37b787_wdt: Unable to register miscdev on minor 130
[    3.667562] w83977f_wdt: driver v1.00
[    3.668170] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    3.669516] sdhci: Secure Digital Host Controller Interface driver
[    3.670579] sdhci: Copyright(c) Pierre Ossman
[    3.671291] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    3.672193] wbsd: Copyright(c) Pierre Ossman
[    3.673747] usbip_core: usbip_core_init:761: USB/IP Core v1.0.0
[    3.675324] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    3.676332] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    3.677315] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 1
[    3.678425] vhci_hcd: vhci_start:883: enter vhci_start
[    3.680733] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.681777] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.682876] usb usb1: Product: USB/IP Virtual Host Controller
[    3.683760] usb usb1: Manufacturer: Linux 3.16.0-rc1-00011-g3b9f3f3 vhci=
_hcd
[    3.684898] usb usb1: SerialNumber: vhci_hcd
[    3.687902] hub 1-0:1.0: USB hub found
[    3.688552] vhci_hcd: vhci_hub_control:244: typeReq a006 wValue 2900 wIn=
dex 0
[    3.689722] vhci_hcd: vhci_hub_control:302:  GetHubDescriptor
[    3.690659] vhci_hcd: vhci_hub_control:396: port -1
[    3.691406] vhci_hcd: vhci_hub_control:403:  bye
[    3.692121] hub 1-0:1.0: 8 ports detected
[    3.692807] vhci_hcd: vhci_hub_control:244: typeReq a000 wValue 0 wIndex=
 0
[    3.693865] vhci_hcd: vhci_hub_control:306:  GetHubStatus
[    3.694750] vhci_hcd: vhci_hub_control:396: port -1
[    3.695466] vhci_hcd: vhci_hub_control:403:  bye
[    3.698936] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 1
[    3.700040] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    3.701090] vhci_hcd: vhci_hub_control:396: port 0
[    3.701775] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.702997] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.703861] vhci_hcd: dump_port_status_diff:119:=20
[    3.704564] vhci_hcd: vhci_hub_control:403:  bye
[    3.705324] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 2
[    3.706433] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    3.707412] vhci_hcd: vhci_hub_control:396: port 1
[    3.708164] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.709440] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.710280] vhci_hcd: dump_port_status_diff:119:=20
[    3.710955] vhci_hcd: vhci_hub_control:403:  bye
[    3.711682] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 3
[    3.712750] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    3.713711] vhci_hcd: vhci_hub_control:396: port 2
[    3.714450] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.715679] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.716512] vhci_hcd: dump_port_status_diff:119:=20
[    3.717227] vhci_hcd: vhci_hub_control:403:  bye
[    3.717967] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 4
[    3.719046] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    3.720126] vhci_hcd: vhci_hub_control:396: port 3
[    3.720895] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.722152] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.722925] vhci_hcd: dump_port_status_diff:119:=20
[    3.723651] vhci_hcd: vhci_hub_control:403:  bye
[    3.724461] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 5
[    3.725554] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    3.726588] vhci_hcd: vhci_hub_control:396: port 4
[    3.727335] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.728574] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.729441] vhci_hcd: dump_port_status_diff:119:=20
[    3.730242] vhci_hcd: vhci_hub_control:403:  bye
[    3.731009] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 6
[    3.732048] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    3.733082] vhci_hcd: vhci_hub_control:396: port 5
[    3.733874] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.735171] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.736071] vhci_hcd: dump_port_status_diff:119:=20
[    3.736813] vhci_hcd: vhci_hub_control:403:  bye
[    3.737545] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 7
[    3.738646] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    3.739690] vhci_hcd: vhci_hub_control:396: port 6
[    3.740455] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.741704] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.742580] vhci_hcd: dump_port_status_diff:119:=20
[    3.743359] vhci_hcd: vhci_hub_control:403:  bye
[    3.744127] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 8
[    3.745230] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    3.746294] vhci_hcd: vhci_hub_control:396: port 7
[    3.746992] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.748298] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.749146] vhci_hcd: dump_port_status_diff:119:=20
[    3.749838] vhci_hcd: vhci_hub_control:403:  bye
[    3.751613] vhci_hcd: vhci_hcd_probe:1028: bye
[    3.752345] vhci_hcd: vhci_hcd_init:1151: USB/IP 'Virtual' Host Controll=
er (VHCI) Driver v1.0.0
[    3.753630] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    3.754606] Copyright 2010. Beceem Communications Inc
[    3.755739] usbcore: registered new interface driver usbbcm
[    3.757370] logger: created 256K log 'log_main'
[    3.758658] logger: created 256K log 'log_events'
[    3.759966] logger: created 256K log 'log_radio'
[    3.761307] logger: created 256K log 'log_system'
[    3.762385] usbcore: registered new interface driver gdm_wimax
[    3.763496] usbcore: registered new interface driver cedusb
[    3.764394] FPGA DOWNLOAD --->
[    3.764861] FPGA image file name: xlinx_fpga_firmware.bit
[    3.766160] GPIO INIT FAIL!!
[    3.767617] NET: Registered protocol family 17
[    3.768627] NET: Registered protocol family 4
[    3.769439] 8021q: 802.1Q VLAN Support v1.8
[    3.770269] mpls_gso: MPLS GSO support
[    3.773326]=20
[    3.773326] printing PIC contents
[    3.774066] ... PIC  IMR: ffff
[    3.774556] ... PIC  IRR: 1013
[    3.775063] ... PIC  ISR: 0000
[    3.775552] ... PIC ELCR: 0c00
[    3.776031] printing local APIC contents on CPU#0/0:
[    3.776749] ... APIC ID:      00000000 (0)
[    3.777377] ... APIC VERSION: 00050014
[    3.777935] ... APIC TASKPRI: 00000000 (00)
[    3.778581] ... APIC PROCPRI: 00000000
[    3.779161] ... APIC LDR: 01000000
[    3.779673] ... APIC DFR: ffffffff
[    3.780143] ... APIC SPIV: 000001ff
[    3.780143] ... APIC ISR field:
[    3.780143] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.780143] ... APIC TMR field:
[    3.780143] 000000000200000000000000000000000000000000000000000000000000=
0000
[    3.780143] ... APIC IRR field:
[    3.780143] 000000000000000000000000000000000000000000000000000000000000=
8000
[    3.780143] ... APIC ESR: 00000000
[    3.780143] ... APIC ICR: 00000834
[    3.780143] ... APIC ICR2: 01000000
[    3.780143] ... APIC LVTT: 000000ef
[    3.780143] ... APIC LVTPC: 00010000
[    3.780143] ... APIC LVT0: 00010700
[    3.780143] ... APIC LVT1: 00000400
[    3.780143] ... APIC LVTERR: 000000fe
[    3.780143] ... APIC TMICT: 0009650a
[    3.780143] ... APIC TMCCT: 00000000
[    3.780143] ... APIC TDCR: 00000003
[    3.780143]=20
[    3.792236] number of MP IRQ sources: 15.
[    3.792822] number of IO-APIC #0 registers: 24.
[    3.793548] testing the IO APIC.......................
[    3.794396] IO APIC #0......
[    3.794820] .... register #00: 00000000
[    3.795407] .......    : physical APIC id: 00
[    3.796110] .......    : Delivery Type: 0
[    3.796732] .......    : LTS          : 0
[    3.797360] .... register #01: 00170011
[    3.797913] .......     : max redirection entries: 17
[    3.798680] .......     : PRQ implemented: 0
[    3.799364] .......     : IO APIC version: 11
[    3.800072] .... register #02: 00000000
[    3.800635] .......     : arbitration: 00
[    3.801252] .... IRQ redirection table:
[    3.801856] 1    0    0   0   0    0    0    00
[    3.802544] 0    0    0   0   0    1    1    31
[    3.803259] 0    0    0   0   0    1    1    30
[    3.803959] 0    0    0   0   0    1    1    33
[    3.804706] 0    0    0   0   0    1    1    34
[    3.805454] 1    1    0   0   0    1    1    35
[    3.806211] 0    0    0   0   0    1    1    36
[    3.806933] 0    0    0   0   0    1    1    37
[    3.807682] 0    0    0   0   0    1    1    38
[    3.808384] 0    1    0   0   0    1    1    39
[    3.809109] 1    1    0   0   0    1    1    3A
[    3.809776] 1    1    0   0   0    1    1    3B
[    3.810517] 0    0    0   0   0    1    1    3C
[    3.811230] 0    0    0   0   0    1    1    3D
[    3.811946] 0    0    0   0   0    1    1    3E
[    3.812670] 0    0    0   0   0    1    1    3F
[    3.813394] 1    0    0   0   0    0    0    00
[    3.814118] 1    0    0   0   0    0    0    00
[    3.814887] 1    0    0   0   0    0    0    00
[    3.815582] 1    0    0   0   0    0    0    00
[    3.816292] 1    0    0   0   0    0    0    00
[    3.816987] 1    0    0   0   0    0    0    00
[    3.817698] 1    0    0   0   0    0    0    00
[    3.818415] 1    0    0   0   0    0    0    00
[    3.819139] IRQ to pin mappings:
[    3.819636] IRQ0 -> 0:2
[    3.820127] IRQ1 -> 0:1
[    3.820566] IRQ3 -> 0:3
[    3.821006] IRQ4 -> 0:4
[    3.821439] IRQ5 -> 0:5
[    3.821862] IRQ6 -> 0:6
[    3.822321] IRQ7 -> 0:7
[    3.822725] IRQ8 -> 0:8
[    3.823158] IRQ9 -> 0:9
[    3.823608] IRQ10 -> 0:10
[    3.824084] IRQ11 -> 0:11
[    3.824534] IRQ12 -> 0:12
[    3.824987] IRQ13 -> 0:13
[    3.825440] IRQ14 -> 0:14
[    3.825884] IRQ15 -> 0:15
[    3.826336] .................................... done.
[    3.827127] Using IPI Shortcut mode
[    3.829238] Loading compiled-in X.509 certificates
[    3.835932] Loaded X.509 cert 'Magrathea: Glacier signing key: 82b545993=
de96d1d544e1edf008aafeb6b50785c'
[    3.837453] registered taskstats version 1
[    3.839401]   Magic number: 2:598:772
[    3.840113] tty ptyp8: hash matches
[    3.840734] console [netcon0] enabled
[    3.841290] netconsole: network logging started
[    3.842140] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    3.843930] PM: Hibernation image not present or could not be loaded
--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--VS++wcV0S1rZb1Fb--
