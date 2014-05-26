Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaEZCe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 22:34:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:4344 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaEZCeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 22:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,909,1392192000"; 
   d="log'?scan'208";a="544820009"
Message-ID: <5382A829.1060905@intel.com>
Date: Mon, 26 May 2014 10:34:17 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [LSM] Kernel panic - not syncing: Yama: kernel registration failed.
Content-Type: multipart/mixed;
 boundary="------------070607040101050806000303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070607040101050806000303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Kees,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git lsm-mod-pin
commit 15e961b72496a2302914a66575f8f4b25463d65c
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Fri Sep 20 10:06:46 2013 -0700
Commit:     Kees Cook <keescook@chromium.org>
CommitDate: Wed May 21 17:23:01 2014 -0700

    LSM: ModPin LSM for module loading restrictions
        This LSM enforces that modules must all come from the same filesystem,
    with the expectation that such a filesystem is backed by a read-only
    device such as dm-verity or CDROM. This allows systems that have a
    verified or unchanging filesystem to enforce module loading restrictions
    without needing to sign the modules individually.
        Signed-off-by: Kees Cook <keescook@chromium.org>

+----------------------------------------------------------+-----------+------------+
|                                                          | v3.15-rc6 | 15e961b724 |
+----------------------------------------------------------+-----------+------------+
| boot_successes                                           | 60        | 0          |
| boot_failures                                            | 0         | 20         |
| Kernel_panic-not_syncing:Yama:kernel_registration_failed | 0         | 20         |
| backtrace:panic                                          | 0         | 20         |
| backtrace:yama_init                                      | 0         | 20         |
| backtrace:security_init                                  | 0         | 20         |
+----------------------------------------------------------+-----------+------------+


[    0.020000] Security Framework initialized
[    0.020000] ModPin LSM: ready to pin.
[    0.020000] Yama: becoming mindful.
[    0.020000] Kernel panic - not syncing: Yama: kernel registration failed.
[    0.020000] [    0.020000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.15.0-rc6-00001-g15e961b #1
[    0.020000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.020000]  0000000000000000 ffffffff82801eb0 ffffffff81ebc563 ffffffff82801f28
[    0.020000]  ffffffff81eb665d ffffffff00000008 ffffffff82801f38 ffffffff82801ed8
[    0.020000]  ffffffff81eb762c 0000000000000001 ffffffff8281b480 0000000000000000
[    0.020000] Call Trace:
[    0.020000]  [<ffffffff81ebc563>] dump_stack+0x19/0x1b
[    0.020000]  [<ffffffff81eb665d>] panic+0xcb/0x1e4
[    0.020000]  [<ffffffff81eb762c>] ? printk+0x4f/0x51
[    0.020000]  [<ffffffff829e1232>] yama_init+0x61/0x65
[    0.020000]  [<ffffffff829e0289>] security_init+0x35/0x47
[    0.020000]  [<ffffffff829c5d54>] start_kernel+0x45c/0x4ba
[    0.020000]  [<ffffffff829c5706>] ? repair_env_string+0x5a/0x5a
[    0.020000]  [<ffffffff829c5120>] ? early_idt_handlers+0x120/0x120
[    0.020000]  [<ffffffff829c5421>] x86_64_start_reservations+0x2a/0x2c
[    0.020000]  [<ffffffff829c54fa>] x86_64_start_kernel+0xd7/0xe4

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig-s0-05250024/15e961b72496a2302914a66575f8f4b25463d65c/vmlinuz-3.15.0-rc6-00001-g15e961b -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s0-05250024/linux-devel:devel-hourly-2014052422:15e961b72496a2302914a66575f8f4b25463d65c:bisect-linux2/.vmlinuz-15e961b72496a2302914a66575f8f4b25463d65c-20140525020645-18-ivb44 branch=linux-devel/devel-hourly-2014052422 BOOT_IMAGE=/kernel/x86_64-randconfig-s0-05250024/15e961b72496a2302914a66575f8f4b25463d65c/vmlinuz-3.15.0-rc6-00001-g15e961b drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc
base=localtime -pidfile /dev/shm/kboot/pid-quantal-ivb44-37 -serial file:/dev/shm/kboot/serial-quantal-ivb44-37 -daemonize -display none -monitor null
git bisect start 2a70639cc4ea08bd40712cb010cabbb24b8ec939 4b660a7f5c8099d88d1a43d8ae138965112592c7 --
git bisect  bad 3e7094f8f4479ad5c2dae652779385c6a5860963  # 01:10      0-     20  Merge 'arm-soc/sti/dt' into devel-hourly-2014052422
git bisect  bad c758b8624c09283de327df15ba363ad6e19d9cbb  # 01:21      0-     20  Merge 'driver-core/driver-core-next' into devel-hourly-2014052422
git bisect good 45eeb88abd75477c8f2edbaaf193c834e4472f9b  # 01:31     20+      0  Merge 'arm-soc/qcom/dt' into devel-hourly-2014052422
git bisect good bd58b5faa0113b5306697b510f48ae4d684aa4b2  # 01:41     20+      0  Merge 'arm-soc/qcom/defconfig' into devel-hourly-2014052422
git bisect good 6d89122f9b4106872ff4cb08b912ced4418a3611  # 01:47     20+      0  Merge 'pci/next' into devel-hourly-2014052422
git bisect  bad 3fb6f99039f45799a98cd6c9967396b20b7dafcf  # 01:58      0-     20  Merge 'kees/lsm-mod-pin' into devel-hourly-2014052422
git bisect  bad 15e961b72496a2302914a66575f8f4b25463d65c  # 02:07      0-     20  LSM: ModPin LSM for module loading restrictions
# first bad commit: [15e961b72496a2302914a66575f8f4b25463d65c] LSM: ModPin LSM for module loading restrictions
git bisect good 4b660a7f5c8099d88d1a43d8ae138965112592c7  # 02:10     60+      0  Linux 3.15-rc6
git bisect  bad 2a70639cc4ea08bd40712cb010cabbb24b8ec939  # 02:10      0-     13  0day head guard for 'devel-hourly-2014052422'
git bisect good 1ee1ceafb572f1a925809168267a7962a4289de8  # 02:41     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
git bisect good f13c6d93ae8ebdfb1301e43051bcec78eb92995f  # 02:47     60+      0  Add linux-next specific files for 20140523


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm 	-kernel $kernel
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


--------------070607040101050806000303
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-quantal-ivb44-37:20140525020656:x86_64-randconfig-s0-05250024:3.15.0-rc6-00001-g15e961b:1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-quantal-ivb44-37:20140525020656:x86_64-randconfig-s0-0";
 filename*1="5250024:3.15.0-rc6-00001-g15e961b:1"

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc6-00001-g15e961b (kbuild@snb) (gcc =
version 4.8.2 (Debian 4.8.2-18) ) #1 Sun May 25 02:03:47 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ra=
m0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s0-05250024/li=
nux-devel:devel-hourly-2014052422:15e961b72496a2302914a66575f8f4b25463d65=
c:bisect-linux2/.vmlinuz-15e961b72496a2302914a66575f8f4b25463d65c-2014052=
5020645-18-ivb44 branch=3Dlinux-devel/devel-hourly-2014052422 BOOT_IMAGE=3D=
/kernel/x86_64-randconfig-s0-05250024/15e961b72496a2302914a66575f8f4b2546=
3d65c/vmlinuz-3.15.0-rc6-00001-g15e961b drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.=

[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped a=
t [ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x033fe000, 0x033fefff] PGTABLE
[    0.000000] BRK [0x033ff000, 0x033fffff] PGTABLE
[    0.000000] BRK [0x03400000, 0x03400fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x03401000, 0x03401fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
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
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 282c380
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
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s0-0525=
0024/linux-devel:devel-hourly-2014052422:15e961b72496a2302914a66575f8f4b2=
5463d65c:bisect-linux2/.vmlinuz-15e961b72496a2302914a66575f8f4b25463d65c-=
20140525020645-18-ivb44 branch=3Dlinux-devel/devel-hourly-2014052422 BOOT=
_IMAGE=3D/kernel/x86_64-randconfig-s0-05250024/15e961b72496a2302914a66575=
f8f4b25463d65c/vmlinuz-3.15.0-rc6-00001-g15e961b drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 by=
tes)
[    0.000000] Memory: 260052K/327280K available (15203K kernel code, 180=
5K rwdata, 6328K rodata, 976K init, 9488K bss, 67228K reserved)
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------=
------------------
[    0.000000]                                  | spin |wlock |rlock |mut=
ex | wsem | rsem |
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]               recursive read-lock:             |  ok  |   =
          |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |   =
          |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |   =
          |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |   =
          |  ok  |
[    0.000000]   --------------------------------------------------------=
------------------
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
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  o=
k  |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
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
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.556 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.11 Bo=
goMIPS (lpj=3D26935560)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140214
[    0.020000] ACPI: All ACPI Tables successfully acquired
[    0.020000] Security Framework initialized
[    0.020000] ModPin LSM: ready to pin.
[    0.020000] Yama: becoming mindful.
[    0.020000] Kernel panic - not syncing: Yama: kernel registration fail=
ed.
[    0.020000]=20
[    0.020000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.15.0-rc6-00001-g=
15e961b #1
[    0.020000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.020000]  0000000000000000 ffffffff82801eb0 ffffffff81ebc563 ffffff=
ff82801f28
[    0.020000]  ffffffff81eb665d ffffffff00000008 ffffffff82801f38 ffffff=
ff82801ed8
[    0.020000]  ffffffff81eb762c 0000000000000001 ffffffff8281b480 000000=
0000000000
[    0.020000] Call Trace:
[    0.020000]  [<ffffffff81ebc563>] dump_stack+0x19/0x1b
[    0.020000]  [<ffffffff81eb665d>] panic+0xcb/0x1e4
[    0.020000]  [<ffffffff81eb762c>] ? printk+0x4f/0x51
[    0.020000]  [<ffffffff829e1232>] yama_init+0x61/0x65
[    0.020000]  [<ffffffff829e0289>] security_init+0x35/0x47
[    0.020000]  [<ffffffff829c5d54>] start_kernel+0x45c/0x4ba
[    0.020000]  [<ffffffff829c5706>] ? repair_env_string+0x5a/0x5a
[    0.020000]  [<ffffffff829c5120>] ? early_idt_handlers+0x120/0x120
[    0.020000]  [<ffffffff829c5421>] x86_64_start_reservations+0x2a/0x2c
[    0.020000]  [<ffffffff829c54fa>] x86_64_start_kernel+0xd7/0xe4

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconf=
ig-s0-05250024/15e961b72496a2302914a66575f8f4b25463d65c/vmlinuz-3.15.0-rc=
6-00001-g15e961b -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 =
debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D=
100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw=
 link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s0-05250024/linux-d=
evel:devel-hourly-2014052422:15e961b72496a2302914a66575f8f4b25463d65c:bis=
ect-linux2/.vmlinuz-15e961b72496a2302914a66575f8f4b25463d65c-201405250206=
45-18-ivb44 branch=3Dlinux-devel/devel-hourly-2014052422 BOOT_IMAGE=3D/ke=
rnel/x86_64-randconfig-s0-05250024/15e961b72496a2302914a66575f8f4b25463d6=
5c/vmlinuz-3.15.0-rc6-00001-g15e961b drbd.minor_count=3D8'  -initrd /kern=
el-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,m=
odel=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i63=
00esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-ivb44-37 =
-serial file:/dev/shm/kboot/serial-quantal-ivb44-37 -daemonize -display n=
one -monitor null=20


--------------070607040101050806000303
Content-Type: application/octet-stream;
 name="x86_64-randconfig-s0-05250024-2a70639cc4ea08bd40712cb010cabbb24b8ec939-Kernel-panic---not-syncing:-Yama:-kernel-registration-failed--122975.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="x86_64-randconfig-s0-05250024-2a70639cc4ea08bd40712cb010cabb";
 filename*1="b24b8ec939-Kernel-panic---not-syncing:-Yama:-kernel-registra";
 filename*2="tion-failed--122975.log"

SEVBRCBpcyBub3cgYXQgMmE3MDYzOS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA1MjQyMicKZ2l0IGNoZWNrb3V0IDRiNjYwYTdmNWM4MDk5ZDg4ZDFhNDNk
OGFlMTM4OTY1MTEyNTkyYzcKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDUyNDIyOjRiNjYwYTdmNWM4MDk5ZDg4ZDFhNDNkOGFlMTM4OTY1MTEyNTkyYzc6Ymlz
ZWN0LWxpbnV4MgoKMjAxNC0wNS0yNS0wMDozNzowMSA0YjY2MGE3ZjVjODA5OWQ4OGQxYTQz
ZDhhZTEzODk2NTExMjU5MmM3IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LTRi
NjYwYTdmNWM4MDk5ZDg4ZDFhNDNkOGFlMTM4OTY1MTEyNTkyYzcKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzRiNjYwYTdmNWM4
MDk5ZDg4ZDFhNDNkOGFlMTM4OTY1MTEyNTkyYzcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUw
MDI0LTRiNjYwYTdmNWM4MDk5ZDg4ZDFhNDNkOGFlMTM4OTY1MTEyNTkyYzcKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNTI1MDAyNC00YjY2MGE3ZjVjODA5OWQ4OGQxYTQzZDhhZTEzODk2NTEx
MjU5MmM3Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC80
YjY2MGE3ZjVjODA5OWQ4OGQxYTQzZDhhZTEzODk2NTExMjU5MmM3L3ZtbGludXotMy4xNS4w
LXJjNgoKMjAxNC0wNS0yNS0wMDo0NDowMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkzCTIw
IFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgNGI2NjBhN2Y1YzgwOTlkODhkMWE0M2Q4
YWUxMzg5NjUxMTI1OTJjNwpnaXQgYmlzZWN0IHN0YXJ0IDJhNzA2MzljYzRlYTA4YmQ0MDcx
MmNiMDEwY2FiYmIyNGI4ZWM5MzkgNGI2NjBhN2Y1YzgwOTlkODhkMWE0M2Q4YWUxMzg5NjUx
MTI1OTJjNyAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICIyYTcw
NjM5Y2M0ZWEwOGJkNDA3MTJjYjAxMGNhYmJiMjRiOGVjOTM5IiwgIi1nIiwgIjRiNjYwYTdm
NWM4MDk5ZDg4ZDFhNDNkOGFlMTM4OTY1MTEyNTkyYzciLCAiL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIva2VybmVsLXRlc3RzL2xpbnV4Mi9vYmot
YmlzZWN0Il0KQmlzZWN0aW5nOiAzMDg1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAxMiBzdGVwcykKWzNlNzA5NGY4ZjQ0NzlhZDVjMmRhZTY1Mjc3OTM4
NWM2YTU4NjA5NjNdIE1lcmdlICdhcm0tc29jL3N0aS9kdCcgaW50byBkZXZlbC1ob3VybHkt
MjAxNDA1MjQyMgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNTI0MjI6M2U3MDk0ZjhmNDQ3OWFkNWMyZGFl
NjUyNzc5Mzg1YzZhNTg2MDk2MzpiaXNlY3QtbGludXgyCgoyMDE0LTA1LTI1LTAwOjQ2OjA3
IDNlNzA5NGY4ZjQ0NzlhZDVjMmRhZTY1Mjc3OTM4NWM2YTU4NjA5NjMgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctczAtMDUyNTAwMjQtM2U3MDk0ZjhmNDQ3OWFkNWMyZGFlNjUyNzc5Mzg1YzZh
NTg2MDk2MwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czAtMDUyNTAwMjQvM2U3MDk0ZjhmNDQ3OWFkNWMyZGFlNjUyNzc5Mzg1YzZhNTg2MDk2Mwp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQtM2U3MDk0ZjhmNDQ3OWFkNWMyZGFlNjUyNzc5
Mzg1YzZhNTg2MDk2Mwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LTNlNzA5NGY4ZjQ0
NzlhZDVjMmRhZTY1Mjc3OTM4NWM2YTU4NjA5NjMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA1MjUwMDI0LzNlNzA5NGY4ZjQ0NzlhZDVjMmRhZTY1Mjc3OTM4NWM2
YTU4NjA5NjMvdm1saW51ei0zLjE1LjAtcmM2LTAwODI2LWczZTcwOTRmCgoyMDE0LTA1LTI1
LTAxOjEwOjA3IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgMC4w
MjAwMDBdIFNlY3VyaXR5IEZyYW1ld29yayBpbml0aWFsaXplZApbICAgIDAuMDIwMDAwXSBN
b2RQaW4gTFNNOiByZWFkeSB0byBwaW4uClsgICAgMC4wMjAwMDBdIFlhbWE6IGJlY29taW5n
IG1pbmRmdWwuClsgICAgMC4wMjAwMDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBZ
YW1hOiBrZXJuZWwgcmVnaXN0cmF0aW9uIGZhaWxlZC4KWyAgICAwLjAyMDAwMF0gClsgICAg
MC4wMjAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE1
LjAtcmM2LTAwODI2LWczZTcwOTRmICMxClsgICAgMC4wMjAwMDBdIEhhcmR3YXJlIG5hbWU6
IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjAyMDAwMF0gIDAw
MDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MjgwMWViMCBmZmZmZmZmZjgxZWJkOWY4IGZmZmZm
ZmZmODI4MDFmMjgKWyAgICAwLjAyMDAwMF0gIGZmZmZmZmZmODFlYjdhZjIgZmZmZmZmZmYw
MDAwMDAwOCBmZmZmZmZmZjgyODAxZjM4IGZmZmZmZmZmODI4MDFlZDgKWyAgICAwLjAyMDAw
MF0gIGZmZmZmZmZmODFlYjhhYzEgMDAwMDAwMDAwMDAwMDAwMSBmZmZmZmZmZjgyODFiNDgw
IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAyMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAy
MDAwMF0gIFs8ZmZmZmZmZmY4MWViZDlmOD5dIGR1bXBfc3RhY2srMHgxOS8weDFiClsgICAg
MC4wMjAwMDBdICBbPGZmZmZmZmZmODFlYjdhZjI+XSBwYW5pYysweGNiLzB4MWU0ClsgICAg
MC4wMjAwMDBdICBbPGZmZmZmZmZmODFlYjhhYzE+XSA/IHByaW50aysweDRmLzB4NTEKWyAg
ICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MjllMTIzMj5dIHlhbWFfaW5pdCsweDYxLzB4NjUK
WyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MjllMDI4OT5dIHNlY3VyaXR5X2luaXQrMHgz
NS8weDQ3ClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI5YzVkNTQ+XSBzdGFydF9rZXJu
ZWwrMHg0NWMvMHg0YmEKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MjljNTcwNj5dID8g
cmVwYWlyX2Vudl9zdHJpbmcrMHg1YS8weDVhClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZm
ODI5YzUxMjA+XSA/IGVhcmx5X2lkdF9oYW5kbGVycysweDEyMC8weDEyMApbICAgIDAuMDIw
MDAwXSAgWzxmZmZmZmZmZjgyOWM1NDIxPl0geDg2XzY0X3N0YXJ0X3Jlc2VydmF0aW9ucysw
eDJhLzB4MmMKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MjljNTRmYT5dIHg4Nl82NF9z
dGFydF9rZXJuZWwrMHhkNy8weGU0CgpFbGFwc2VkIHRpbWU6IDUKcWVtdS1zeXN0ZW0teDg2
XzY0IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0gLWtlcm5lbCAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMwLTA1MjUwMDI0LzNlNzA5NGY4ZjQ0NzlhZDVjMmRhZTY1Mjc3OTM4NWM2YTU4
NjA5NjMvdm1saW51ei0zLjE1LjAtcmM2LTAwODI2LWczZTcwOTRmIC1hcHBlbmQgJ2h1bmdf
dGFza19wYW5pYz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVn
IHN5c3JxX2Fsd2F5c19lbmFibGVkIHJjdXBkYXRlLnJjdV9jcHVfc3RhbGxfdGltZW91dD0x
MDAgcGFuaWM9MTAgc29mdGxvY2t1cF9wYW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyAgcHJv
bXB0X3JhbWRpc2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5v
cm1hbCAgcm9vdD0vZGV2L3JhbTAgcncgbGluaz0va2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQwNTI0MjI6M2U3MDk0ZjhmNDQ3OWFkNWMyZGFlNjUyNzc5Mzg1YzZhNTg2MDk2
MzpiaXNlY3QtbGludXgyLy52bWxpbnV6LTNlNzA5NGY4ZjQ0NzlhZDVjMmRhZTY1Mjc3OTM4
NWM2YTU4NjA5NjMtMjAxNDA1MjUwMTA5NTMtMTktaXZiNDEgYnJhbmNoPWxpbnV4LWRldmVs
L2RldmVsLWhvdXJseS0yMDE0MDUyNDIyIEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNTI1MDAyNC8zZTcwOTRmOGY0NDc5YWQ1YzJkYWU2NTI3NzkzODVjNmE1
ODYwOTYzL3ZtbGludXotMy4xNS4wLXJjNi0wMDgyNi1nM2U3MDk0ZiBkcmJkLm1pbm9yX2Nv
dW50PTgnICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3F1YW50YWwtY29yZS14ODZf
NjQuY2d6IC1tIDMyMCAtc21wIDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQg
dXNlcix2bGFuPTEgLWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBl
c2IgLXJ0YyBiYXNlPWxvY2FsdGltZSAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVh
bnRhbC1pdmI0MS0xMDcgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFu
dGFsLWl2YjQxLTEwNyAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8zZTcwOTRmOGY0NDc5YWQ1
YzJkYWU2NTI3NzkzODVjNmE1ODYwOTYzL2RtZXNnLXF1YW50YWwtaXZiNDEtMTA3OjIwMTQw
NTI1MDExMDEwOng4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDA4
MjYtZzNlNzA5NGY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzNl
NzA5NGY4ZjQ0NzlhZDVjMmRhZTY1Mjc3OTM4NWM2YTU4NjA5NjMvZG1lc2ctcXVhbnRhbC1p
dmI0MS04MjoyMDE0MDUyNTAxMTAwMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDoz
LjE1LjAtcmM2LTAwODI2LWczZTcwOTRmOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNTI1MDAyNC8zZTcwOTRmOGY0NDc5YWQ1YzJkYWU2NTI3NzkzODVjNmE1ODYwOTYzL2Rt
ZXNnLXF1YW50YWwtaXZiNDItNzU6MjAxNDA1MjUwMTEwMDc6eDg2XzY0LXJhbmRjb25maWct
czAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDgyNi1nM2U3MDk0ZjoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczAtMDUyNTAwMjQvM2U3MDk0ZjhmNDQ3OWFkNWMyZGFlNjUyNzc5Mzg1
YzZhNTg2MDk2My9kbWVzZy1xdWFudGFsLWl2YjQyLTgzOjIwMTQwNTI1MDExMDA2Ong4Nl82
NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDA4MjYtZzNlNzA5NGY6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzNlNzA5NGY4ZjQ0NzlhZDVj
MmRhZTY1Mjc3OTM4NWM2YTU4NjA5NjMvZG1lc2ctcXVhbnRhbC1pdmI0Mi04MzoyMDE0MDUy
NTAxMTAxNjp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwODI2
LWczZTcwOTRmOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8zZTcw
OTRmOGY0NDc5YWQ1YzJkYWU2NTI3NzkzODVjNmE1ODYwOTYzL2RtZXNnLXF1YW50YWwtaXZi
NDItODY6MjAxNDA1MjUwMTEwMDg6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4x
NS4wLXJjNi0wMDgyNi1nM2U3MDk0ZjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAt
MDUyNTAwMjQvM2U3MDk0ZjhmNDQ3OWFkNWMyZGFlNjUyNzc5Mzg1YzZhNTg2MDk2My9kbWVz
Zy1xdWFudGFsLWl2YjQzLTY3OjIwMTQwNTI1MDExMDAzOng4Nl82NC1yYW5kY29uZmlnLXMw
LTA1MjUwMDI0OjMuMTUuMC1yYzYtMDA4MjYtZzNlNzA5NGY6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA1MjUwMDI0LzNlNzA5NGY4ZjQ0NzlhZDVjMmRhZTY1Mjc3OTM4NWM2
YTU4NjA5NjMvZG1lc2ctcXVhbnRhbC1pdmI0My02NzoyMDE0MDUyNTAxMTAxMzp4ODZfNjQt
cmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwODI2LWczZTcwOTRmOjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8zZTcwOTRmOGY0NDc5YWQ1YzJk
YWU2NTI3NzkzODVjNmE1ODYwOTYzL2RtZXNnLXF1YW50YWwtaXZiNDMtOTI6MjAxNDA1MjUw
MTEwMDY6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDgyNi1n
M2U3MDk0ZjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvM2U3MDk0
ZjhmNDQ3OWFkNWMyZGFlNjUyNzc5Mzg1YzZhNTg2MDk2My9kbWVzZy1xdWFudGFsLWl2YjQz
LTk4OjIwMTQwNTI1MDExMDA0Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUu
MC1yYzYtMDA4MjYtZzNlNzA5NGY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1
MjUwMDI0LzNlNzA5NGY4ZjQ0NzlhZDVjMmRhZTY1Mjc3OTM4NWM2YTU4NjA5NjMvZG1lc2ct
cXVhbnRhbC1pdmI0NC01MjoyMDE0MDUyNTAxMTAwOTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NTI1MDAyNDozLjE1LjAtcmM2LTAwODI2LWczZTcwOTRmOjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNTI1MDAyNC8zZTcwOTRmOGY0NDc5YWQ1YzJkYWU2NTI3NzkzODVjNmE1
ODYwOTYzL2RtZXNnLXlvY3RvLWl2YjQxLTEyMjoyMDE0MDUyNTAxMTAwNTp4ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwODI2LWczZTcwOTRmOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8zZTcwOTRmOGY0NDc5YWQ1YzJkYWU2
NTI3NzkzODVjNmE1ODYwOTYzL2RtZXNnLXlvY3RvLWl2YjQxLTI4OjIwMTQwNTI1MDExMDA3
Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDA4MjYtZzNlNzA5
NGY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzNlNzA5NGY4ZjQ0
NzlhZDVjMmRhZTY1Mjc3OTM4NWM2YTU4NjA5NjMvZG1lc2ctcXVhbnRhbC1pdmI0My01MDoy
MDE0MDUyNTAxMTAxMzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2
LTAwODI2LWczZTcwOTRmOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAy
NC8zZTcwOTRmOGY0NDc5YWQ1YzJkYWU2NTI3NzkzODVjNmE1ODYwOTYzL2RtZXNnLXF1YW50
YWwtaXZiNDEtODI6MjAxNDA1MjUwMTEwMTY6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAw
MjQ6My4xNS4wLXJjNi0wMDgyNi1nM2U3MDk0ZjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczAtMDUyNTAwMjQvM2U3MDk0ZjhmNDQ3OWFkNWMyZGFlNjUyNzc5Mzg1YzZhNTg2MDk2
My9kbWVzZy1xdWFudGFsLWl2YjQyLTUyOjIwMTQwNTI1MDExMDE4Ong4Nl82NC1yYW5kY29u
ZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDA4MjYtZzNlNzA5NGY6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzNlNzA5NGY4ZjQ0NzlhZDVjMmRhZTY1Mjc3
OTM4NWM2YTU4NjA5NjMvZG1lc2ctcXVhbnRhbC1pdmI0Mi02MDoyMDE0MDUyNTAxMTAxODp4
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwODI2LWczZTcwOTRm
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8zZTcwOTRmOGY0NDc5
YWQ1YzJkYWU2NTI3NzkzODVjNmE1ODYwOTYzL2RtZXNnLXF1YW50YWwtaXZiNDItNzU6MjAx
NDA1MjUwMTEwMTg6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0w
MDgyNi1nM2U3MDk0ZjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQv
M2U3MDk0ZjhmNDQ3OWFkNWMyZGFlNjUyNzc5Mzg1YzZhNTg2MDk2My9kbWVzZy1xdWFudGFs
LWl2YjQzLTk4OjIwMTQwNTI1MDExMDE0Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0
OjMuMTUuMC1yYzYtMDA4MjYtZzNlNzA5NGY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTA1MjUwMDI0LzNlNzA5NGY4ZjQ0NzlhZDVjMmRhZTY1Mjc3OTM4NWM2YTU4NjA5NjMv
ZG1lc2cteW9jdG8taXZiNDEtMTIyOjIwMTQwNTI1MDExMDE2Ong4Nl82NC1yYW5kY29uZmln
LXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDA4MjYtZzNlNzA5NGY6MQowOjIwOjIwIGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA1LTI1IDAxOjEwOjM5IFJFUEVB
VCBDT1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdC8ucmVwZWF0
G1swbQoKQmlzZWN0aW5nOiA4MjYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDEwIHN0ZXBzKQpbYzc1OGI4NjI0YzA5MjgzZGUzMjdkZjE1YmEzNjNhZDZl
MTlkOWNiYl0gTWVyZ2UgJ2RyaXZlci1jb3JlL2RyaXZlci1jb3JlLW5leHQnIGludG8gZGV2
ZWwtaG91cmx5LTIwMTQwNTI0MjIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QKbHMg
LWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1
MjUwMDI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDUyNDIyOmM3NThiODYyNGMw
OTI4M2RlMzI3ZGYxNWJhMzYzYWQ2ZTE5ZDljYmI6YmlzZWN0LWxpbnV4MgoKMjAxNC0wNS0y
NS0wMToxMDo0MiBjNzU4Yjg2MjRjMDkyODNkZTMyN2RmMTViYTM2M2FkNmUxOWQ5Y2JiIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LWM3NThiODYyNGMwOTI4M2RlMzI3ZGYx
NWJhMzYzYWQ2ZTE5ZDljYmIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA1MjUwMDI0L2M3NThiODYyNGMwOTI4M2RlMzI3ZGYxNWJhMzYzYWQ2
ZTE5ZDljYmIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LWM3NThiODYyNGMwOTI4M2Rl
MzI3ZGYxNWJhMzYzYWQ2ZTE5ZDljYmIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC1j
NzU4Yjg2MjRjMDkyODNkZTMyN2RmMTViYTM2M2FkNmUxOWQ5Y2JiCmtlcm5lbDogL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC9jNzU4Yjg2MjRjMDkyODNkZTMyN2Rm
MTViYTM2M2FkNmUxOWQ5Y2JiL3ZtbGludXotMy4xNS4wLXJjNi0wMDI0NC1nYzc1OGI4NgoK
MjAxNC0wNS0yNS0wMToyMDo0MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVS
RQpbICAgIDAuMDIwMDAwXSBTZWN1cml0eSBGcmFtZXdvcmsgaW5pdGlhbGl6ZWQKWyAgICAw
LjAyMDAwMF0gTW9kUGluIExTTTogcmVhZHkgdG8gcGluLgpbICAgIDAuMDIwMDAwXSBZYW1h
OiBiZWNvbWluZyBtaW5kZnVsLgpbICAgIDAuMDIwMDAwXSBLZXJuZWwgcGFuaWMgLSBub3Qg
c3luY2luZzogWWFtYToga2VybmVsIHJlZ2lzdHJhdGlvbiBmYWlsZWQuClsgICAgMC4wMjAw
MDBdIApbICAgIDAuMDIwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRh
aW50ZWQgMy4xNS4wLXJjNi0wMDI0NC1nYzc1OGI4NiAjMgpbICAgIDAuMDIwMDAwXSBIYXJk
d2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4w
MjAwMDBdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODI4MDFlYjAgZmZmZmZmZmY4MWVi
Y2JmOCBmZmZmZmZmZjgyODAxZjI4ClsgICAgMC4wMjAwMDBdICBmZmZmZmZmZjgxZWI2Y2Yy
IGZmZmZmZmZmMDAwMDAwMDggZmZmZmZmZmY4MjgwMWYzOCBmZmZmZmZmZjgyODAxZWQ4Clsg
ICAgMC4wMjAwMDBdICBmZmZmZmZmZjgxZWI3Y2MxIDAwMDAwMDAwMDAwMDAwMDEgZmZmZmZm
ZmY4MjgxYjQ4MCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMjAwMDBdIENhbGwgVHJhY2U6
ClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODFlYmNiZjg+XSBkdW1wX3N0YWNrKzB4MTkv
MHgxYgpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgxZWI2Y2YyPl0gcGFuaWMrMHhjYi8w
eDFlNApbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgxZWI3Y2MxPl0gPyBwcmludGsrMHg0
Zi8weDUxClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI5ZTEyMzI+XSB5YW1hX2luaXQr
MHg2MS8weDY1ClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI5ZTAyODk+XSBzZWN1cml0
eV9pbml0KzB4MzUvMHg0NwpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgyOWM1ZDU0Pl0g
c3RhcnRfa2VybmVsKzB4NDVjLzB4NGJhClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI5
YzU3MDY+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4NWEvMHg1YQpbICAgIDAuMDIwMDAwXSAg
WzxmZmZmZmZmZjgyOWM1MTIwPl0gPyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAK
WyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MjljNTQyMT5dIHg4Nl82NF9zdGFydF9yZXNl
cnZhdGlvbnMrMHgyYS8weDJjClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI5YzU0ZmE+
XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4ZDcvMHhlNAoKRWxhcHNlZCB0aW1lOiA1CnFlbXUt
c3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC9jNzU4Yjg2MjRjMDkyODNkZTMyN2RmMTVi
YTM2M2FkNmUxOWQ5Y2JiL3ZtbGludXotMy4xNS4wLXJjNi0wMDI0NC1nYzc1OGI4NiAtYXBw
ZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcg
YXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxs
X3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9
cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10
dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDUyNDIyOmM3NThiODYyNGMwOTI4M2RlMzI3ZGYxNWJhMzYz
YWQ2ZTE5ZDljYmI6YmlzZWN0LWxpbnV4Mi8udm1saW51ei1jNzU4Yjg2MjRjMDkyODNkZTMy
N2RmMTViYTM2M2FkNmUxOWQ5Y2JiLTIwMTQwNTI1MDEyMDM0LTEwLWl2YjQxIGJyYW5jaD1s
aW51eC1kZXZlbC9kZXZlbC1ob3VybHktMjAxNDA1MjQyMiBCT09UX0lNQUdFPS9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvYzc1OGI4NjI0YzA5MjgzZGUzMjdkZjE1
YmEzNjNhZDZlMTlkOWNiYi92bWxpbnV6LTMuMTUuMC1yYzYtMDAyNDQtZ2M3NThiODYgZHJi
ZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFs
LWNvcmUteDg2XzY0LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1l
MTAwMCAtbmV0IHVzZXIsdmxhbj0xIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNo
ZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jv
b3QvcGlkLXF1YW50YWwtaXZiNDEtNDggLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3Nl
cmlhbC1xdWFudGFsLWl2YjQxLTQ4IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRv
ciBudWxsIAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2M3NThiODYy
NGMwOTI4M2RlMzI3ZGYxNWJhMzYzYWQ2ZTE5ZDljYmIvZG1lc2ctcXVhbnRhbC1pdmI0MS00
ODoyMDE0MDUyNTAxMjA0Nzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAt
cmM2LTAwMjQ0LWdjNzU4Yjg2OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1
MDAyNC9jNzU4Yjg2MjRjMDkyODNkZTMyN2RmMTViYTM2M2FkNmUxOWQ5Y2JiL2RtZXNnLXF1
YW50YWwtaXZiNDItNjY6MjAxNDA1MjUwMTIwNTA6eDg2XzY0LXJhbmRjb25maWctczAtMDUy
NTAwMjQ6My4xNS4wLXJjNi0wMDI0NC1nYzc1OGI4NjoyCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczAtMDUyNTAwMjQvYzc1OGI4NjI0YzA5MjgzZGUzMjdkZjE1YmEzNjNhZDZlMTlk
OWNiYi9kbWVzZy1xdWFudGFsLWl2YjQyLTkyOjIwMTQwNTI1MDEyMDUxOng4Nl82NC1yYW5k
Y29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDAyNDQtZ2M3NThiODY6Mgova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2M3NThiODYyNGMwOTI4M2RlMzI3ZGYx
NWJhMzYzYWQ2ZTE5ZDljYmIvZG1lc2ctcXVhbnRhbC1pdmI0My0xMDA6MjAxNDA1MjUwMTIw
NTA6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDI0NC1nYzc1
OGI4NjoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvYzc1OGI4NjI0
YzA5MjgzZGUzMjdkZjE1YmEzNjNhZDZlMTlkOWNiYi9kbWVzZy15b2N0by1pdmI0Mi0yOjIw
MTQwNTI1MDEyMDUxOng4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYt
MDAyNDQtZ2M3NThiODY6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0
L2M3NThiODYyNGMwOTI4M2RlMzI3ZGYxNWJhMzYzYWQ2ZTE5ZDljYmIvZG1lc2cteW9jdG8t
aXZiNDItNzg6MjAxNDA1MjUwMTIwNTc6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6
My4xNS4wLXJjNi0wMDI0NC1nYzc1OGI4NjoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czAtMDUyNTAwMjQvYzc1OGI4NjI0YzA5MjgzZGUzMjdkZjE1YmEzNjNhZDZlMTlkOWNiYi9k
bWVzZy15b2N0by1pdmI0NC04ODoyMDE0MDUyNTAxMjA0NDp4ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMjQ0LWdjNzU4Yjg2OjIKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMC0wNTI1MDAyNC9jNzU4Yjg2MjRjMDkyODNkZTMyN2RmMTViYTM2M2Fk
NmUxOWQ5Y2JiL2RtZXNnLXF1YW50YWwtaXZiNDEtNDg6MjAxNDA1MjUwMTIwNTc6eDg2XzY0
LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDI0NC1nYzc1OGI4NjoyCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvYzc1OGI4NjI0YzA5MjgzZGUz
MjdkZjE1YmEzNjNhZDZlMTlkOWNiYi9kbWVzZy1xdWFudGFsLWl2YjQyLTI4OjIwMTQwNTI1
MDEyMTAwOng4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDAyNDQt
Z2M3NThiODY6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2M3NThi
ODYyNGMwOTI4M2RlMzI3ZGYxNWJhMzYzYWQ2ZTE5ZDljYmIvZG1lc2ctcXVhbnRhbC1pdmI0
Mi02NjoyMDE0MDUyNTAxMjEwMDp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1
LjAtcmM2LTAwMjQ0LWdjNzU4Yjg2OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NTI1MDAyNC9jNzU4Yjg2MjRjMDkyODNkZTMyN2RmMTViYTM2M2FkNmUxOWQ5Y2JiL2RtZXNn
LXF1YW50YWwtaXZiNDItOTI6MjAxNDA1MjUwMTIxMDE6eDg2XzY0LXJhbmRjb25maWctczAt
MDUyNTAwMjQ6My4xNS4wLXJjNi0wMDI0NC1nYzc1OGI4NjoyCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczAtMDUyNTAwMjQvYzc1OGI4NjI0YzA5MjgzZGUzMjdkZjE1YmEzNjNhZDZl
MTlkOWNiYi9kbWVzZy1xdWFudGFsLWl2YjQzLTI3OjIwMTQwNTI1MDEyMDU2Ong4Nl82NC1y
YW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDAyNDQtZ2M3NThiODY6Mgova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2M3NThiODYyNGMwOTI4M2RlMzI3
ZGYxNWJhMzYzYWQ2ZTE5ZDljYmIvZG1lc2ctcXVhbnRhbC1pdmI0My05MDoyMDE0MDUyNTAx
MjA1Njp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMjQ0LWdj
NzU4Yjg2OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC9jNzU4Yjg2
MjRjMDkyODNkZTMyN2RmMTViYTM2M2FkNmUxOWQ5Y2JiL2RtZXNnLXF1YW50YWwtaXZiNDQt
NjM6MjAxNDA1MjUwMTIwNTg6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4w
LXJjNi0wMDI0NC1nYzc1OGI4NjoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUy
NTAwMjQvYzc1OGI4NjI0YzA5MjgzZGUzMjdkZjE1YmEzNjNhZDZlMTlkOWNiYi9kbWVzZy15
b2N0by1pdmI0MS01OToyMDE0MDUyNTAxMjA1Nzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1
MDAyNDozLjE1LjAtcmM2LTAwMjQ0LWdjNzU4Yjg2OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNTI1MDAyNC9jNzU4Yjg2MjRjMDkyODNkZTMyN2RmMTViYTM2M2FkNmUxOWQ5
Y2JiL2RtZXNnLXlvY3RvLWl2YjQyLTExMDoyMDE0MDUyNTAxMjEwMTp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMjQ0LWdjNzU4Yjg2OjIKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC9jNzU4Yjg2MjRjMDkyODNkZTMyN2RmMTVi
YTM2M2FkNmUxOWQ5Y2JiL2RtZXNnLXlvY3RvLWl2YjQyLTExNzoyMDE0MDUyNTAxMjA1ODp4
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMjQ0LWdjNzU4Yjg2
OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC9jNzU4Yjg2MjRjMDky
ODNkZTMyN2RmMTViYTM2M2FkNmUxOWQ5Y2JiL2RtZXNnLXlvY3RvLWl2YjQyLTI6MjAxNDA1
MjUwMTIxMDE6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDI0
NC1nYzc1OGI4NjoyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvYzc1
OGI4NjI0YzA5MjgzZGUzMjdkZjE1YmEzNjNhZDZlMTlkOWNiYi9kbWVzZy15b2N0by1pdmI0
My04NToyMDE0MDUyNTAxMjEwMTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1
LjAtcmM2LTAwMjQ0LWdjNzU4Yjg2OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NTI1MDAyNC9jNzU4Yjg2MjRjMDkyODNkZTMyN2RmMTViYTM2M2FkNmUxOWQ5Y2JiL2RtZXNn
LXlvY3RvLWl2YjQ0LTg4OjIwMTQwNTI1MDEyMDU1Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA1
MjUwMDI0OjMuMTUuMC1yYzYtMDAyNDQtZ2M3NThiODY6MgowOjIwOjIwIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA1LTI1IDAxOjIxOjEzIFJFUEVBVCBDT1VO
VDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoK
QmlzZWN0aW5nOiAyNDQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDggc3RlcHMpCls0NWVlYjg4YWJkNzU0NzdjOGYyZWRiYWFmMTkzYzgzNGU0NDcyZjli
XSBNZXJnZSAnYXJtLXNvYy9xY29tL2R0JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDUyNDIy
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
a2VybmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC9saW51eC1kZXZlbDpk
ZXZlbC1ob3VybHktMjAxNDA1MjQyMjo0NWVlYjg4YWJkNzU0NzdjOGYyZWRiYWFmMTkzYzgz
NGU0NDcyZjliOmJpc2VjdC1saW51eDIKCjIwMTQtMDUtMjUtMDE6MjE6MTcgNDVlZWI4OGFi
ZDc1NDc3YzhmMmVkYmFhZjE5M2M4MzRlNDQ3MmY5YiBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNTI1MDAyNC00NWVlYjg4YWJkNzU0NzdjOGYyZWRiYWFmMTkzYzgzNGU0NDcyZjliCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAy
NC80NWVlYjg4YWJkNzU0NzdjOGYyZWRiYWFmMTkzYzgzNGU0NDcyZjliCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNTI1MDAyNC00NWVlYjg4YWJkNzU0NzdjOGYyZWRiYWFmMTkzYzgzNGU0NDcy
ZjliCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS8ueDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQtNDVlZWI4OGFiZDc1NDc3YzhmMmVk
YmFhZjE5M2M4MzRlNDQ3MmY5YgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czAtMDUyNTAwMjQvNDVlZWI4OGFiZDc1NDc3YzhmMmVkYmFhZjE5M2M4MzRlNDQ3MmY5Yi92
bWxpbnV6LTMuMTUuMC1yYzYtMDAwMTYtZzQ1ZWViODgKCjIwMTQtMDUtMjUtMDE6Mjk6MTcg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTEzCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjI4
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpb
YmQ1OGI1ZmFhMDExM2I1MzA2Njk3YjUxMGY0OGFlNGQ2ODRhYTRiMl0gTWVyZ2UgJ2FybS1z
b2MvcWNvbS9kZWZjb25maWcnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNTI0MjIKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwt
dGVzdHMvbGludXgyL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDUyNDIyOmJkNThiNWZhYTAxMTNiNTMwNjY5N2I1MTBmNDhhZTRkNjg0YWE0
YjI6YmlzZWN0LWxpbnV4MgoKMjAxNC0wNS0yNS0wMTozMTo1MCBiZDU4YjVmYWEwMTEzYjUz
MDY2OTdiNTEwZjQ4YWU0ZDY4NGFhNGIyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUw
MDI0LWJkNThiNWZhYTAxMTNiNTMwNjY5N2I1MTBmNDhhZTRkNjg0YWE0YjIKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2JkNThi
NWZhYTAxMTNiNTMwNjY5N2I1MTBmNDhhZTRkNjg0YWE0YjIKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA1MjUwMDI0LWJkNThiNWZhYTAxMTNiNTMwNjY5N2I1MTBmNDhhZTRkNjg0YWE0YjIKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC1iZDU4YjVmYWEwMTEzYjUzMDY2OTdiNTEwZjQ4
YWU0ZDY4NGFhNGIyCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1
MDAyNC9iZDU4YjVmYWEwMTEzYjUzMDY2OTdiNTEwZjQ4YWU0ZDY4NGFhNGIyL3ZtbGludXot
My4xNS4wLXJjNi0wMDE2MC1nYmQ1OGI1ZgoKMjAxNC0wNS0yNS0wMTozOTo1MCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA4NCByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzZkODkxMjJmOWI0
MTA2ODcyZmY0Y2IwOGI5MTJjZWQ0NDE4YTM2MTFdIE1lcmdlICdwY2kvbmV4dCcgaW50byBk
ZXZlbC1ob3VybHktMjAxNDA1MjQyMgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAt
MDUyNTAwMjQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNTI0MjI6NmQ4OTEyMmY5
YjQxMDY4NzJmZjRjYjA4YjkxMmNlZDQ0MThhMzYxMTpiaXNlY3QtbGludXgyCgoyMDE0LTA1
LTI1LTAxOjQxOjU0IDZkODkxMjJmOWI0MTA2ODcyZmY0Y2IwOGI5MTJjZWQ0NDE4YTM2MTEg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQtNmQ4OTEyMmY5YjQxMDY4NzJmZjRj
YjA4YjkxMmNlZDQ0MThhMzYxMQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczAtMDUyNTAwMjQvNmQ4OTEyMmY5YjQxMDY4NzJmZjRjYjA4YjkxMmNl
ZDQ0MThhMzYxMQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQtNmQ4OTEyMmY5YjQxMDY4
NzJmZjRjYjA4YjkxMmNlZDQ0MThhMzYxMQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0
LTZkODkxMjJmOWI0MTA2ODcyZmY0Y2IwOGI5MTJjZWQ0NDE4YTM2MTEKa2VybmVsOiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzZkODkxMjJmOWI0MTA2ODcyZmY0
Y2IwOGI5MTJjZWQ0NDE4YTM2MTEvdm1saW51ei0zLjE1LjAtcmM2LTAwMjM0LWc2ZDg5MTIy
CgoyMDE0LTA1LTI1LTAxOjQ1OjU0IGRldGVjdGluZyBib290IHN0YXRlIC4JMgkyMCBTVUND
RVNTCgpCaXNlY3Rpbmc6IDEwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSA0IHN0ZXBzKQpbM2ZiNmY5OTAzOWY0NTc5OWE5OGNkNmM5OTY3Mzk2YjIwYjdk
YWZjZl0gTWVyZ2UgJ2tlZXMvbHNtLW1vZC1waW4nIGludG8gZGV2ZWwtaG91cmx5LTIwMTQw
NTI0MjIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDUyNDIyOjNmYjZmOTkwMzlmNDU3OTlhOThjZDZjOTk2
NzM5NmIyMGI3ZGFmY2Y6YmlzZWN0LWxpbnV4MgoKMjAxNC0wNS0yNS0wMTo0NzoyOCAzZmI2
Zjk5MDM5ZjQ1Nzk5YTk4Y2Q2Yzk5NjczOTZiMjBiN2RhZmNmIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTA1MjUwMDI0LTNmYjZmOTkwMzlmNDU3OTlhOThjZDZjOTk2NzM5NmIyMGI3ZGFm
Y2YKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1
MjUwMDI0LzNmYjZmOTkwMzlmNDU3OTlhOThjZDZjOTk2NzM5NmIyMGI3ZGFmY2YKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA1MjUwMDI0LTNmYjZmOTkwMzlmNDU3OTlhOThjZDZjOTk2NzM5NmIy
MGI3ZGFmY2YKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC0zZmI2Zjk5MDM5ZjQ1Nzk5
YTk4Y2Q2Yzk5NjczOTZiMjBiN2RhZmNmCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNTI1MDAyNC8zZmI2Zjk5MDM5ZjQ1Nzk5YTk4Y2Q2Yzk5NjczOTZiMjBiN2Rh
ZmNmL3ZtbGludXotMy4xNS4wLXJjNi0wMDIzNi1nM2ZiNmY5OQoKMjAxNC0wNS0yNS0wMTo1
ODoyOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAuMDIwMDAw
XSBTZWN1cml0eSBGcmFtZXdvcmsgaW5pdGlhbGl6ZWQKWyAgICAwLjAyMDAwMF0gTW9kUGlu
IExTTTogcmVhZHkgdG8gcGluLgpbICAgIDAuMDIwMDAwXSBZYW1hOiBiZWNvbWluZyBtaW5k
ZnVsLgpbICAgIDAuMDIwMDAwXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogWWFtYTog
a2VybmVsIHJlZ2lzdHJhdGlvbiBmYWlsZWQuClsgICAgMC4wMjAwMDBdIApbICAgIDAuMDIw
MDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNS4wLXJj
Ni0wMDIzNi1nM2ZiNmY5OSAjNQpbICAgIDAuMDIwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2No
cyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMjAwMDBdICAwMDAwMDAw
MDAwMDAwMDAwIGZmZmZmZmZmODI4MDFlYjAgZmZmZmZmZmY4MWViY2E1OCBmZmZmZmZmZjgy
ODAxZjI4ClsgICAgMC4wMjAwMDBdICBmZmZmZmZmZjgxZWI2YjUyIGZmZmZmZmZmMDAwMDAw
MDggZmZmZmZmZmY4MjgwMWYzOCBmZmZmZmZmZjgyODAxZWQ4ClsgICAgMC4wMjAwMDBdICBm
ZmZmZmZmZjgxZWI3YjIxIDAwMDAwMDAwMDAwMDAwMDEgZmZmZmZmZmY4MjgxYjQ4MCAwMDAw
MDAwMDAwMDAwMDAwClsgICAgMC4wMjAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMjAwMDBd
ICBbPGZmZmZmZmZmODFlYmNhNTg+XSBkdW1wX3N0YWNrKzB4MTkvMHgxYgpbICAgIDAuMDIw
MDAwXSAgWzxmZmZmZmZmZjgxZWI2YjUyPl0gcGFuaWMrMHhjYi8weDFlNApbICAgIDAuMDIw
MDAwXSAgWzxmZmZmZmZmZjgxZWI3YjIxPl0gPyBwcmludGsrMHg0Zi8weDUxClsgICAgMC4w
MjAwMDBdICBbPGZmZmZmZmZmODI5ZTEyMzI+XSB5YW1hX2luaXQrMHg2MS8weDY1ClsgICAg
MC4wMjAwMDBdICBbPGZmZmZmZmZmODI5ZTAyODk+XSBzZWN1cml0eV9pbml0KzB4MzUvMHg0
NwpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgyOWM1ZDU0Pl0gc3RhcnRfa2VybmVsKzB4
NDVjLzB4NGJhClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI5YzU3MDY+XSA/IHJlcGFp
cl9lbnZfc3RyaW5nKzB4NWEvMHg1YQpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgyOWM1
MTIwPl0gPyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAgICAwLjAyMDAwMF0g
IFs8ZmZmZmZmZmY4MjljNTQyMT5dIHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMrMHgyYS8w
eDJjClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI5YzU0ZmE+XSB4ODZfNjRfc3RhcnRf
a2VybmVsKzB4ZDcvMHhlNAoKRWxhcHNlZCB0aW1lOiA1CnFlbXUtc3lzdGVtLXg4Nl82NCAt
Y3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNTI1MDAyNC8zZmI2Zjk5MDM5ZjQ1Nzk5YTk4Y2Q2Yzk5NjczOTZiMjBiN2RhZmNm
L3ZtbGludXotMy4xNS4wLXJjNi0wMDIzNi1nM2ZiNmY5OSAtYXBwZW5kICdodW5nX3Rhc2tf
cGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNy
cV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBh
bmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9y
YW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwg
IHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDUyNDIyOjNmYjZmOTkwMzlmNDU3OTlhOThjZDZjOTk2NzM5NmIyMGI3ZGFmY2Y6Ymlz
ZWN0LWxpbnV4Mi8udm1saW51ei0zZmI2Zjk5MDM5ZjQ1Nzk5YTk4Y2Q2Yzk5NjczOTZiMjBi
N2RhZmNmLTIwMTQwNTI1MDE1NzQ1LTE2LWl2YjQxIGJyYW5jaD1saW51eC1kZXZlbC9kZXZl
bC1ob3VybHktMjAxNDA1MjQyMiBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczAtMDUyNTAwMjQvM2ZiNmY5OTAzOWY0NTc5OWE5OGNkNmM5OTY3Mzk2YjIwYjdkYWZj
Zi92bWxpbnV6LTMuMTUuMC1yYzYtMDAyMzYtZzNmYjZmOTkgZHJiZC5taW5vcl9jb3VudD04
JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUteDg2XzY0LmNn
eiAtbSAzMjAgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIs
dmxhbj0xIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1y
dGMgYmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwt
aXZiNDEtMTI4IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1p
dmI0MS0xMjggLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvM2ZiNmY5OTAzOWY0NTc5OWE5OGNk
NmM5OTY3Mzk2YjIwYjdkYWZjZi9kbWVzZy1xdWFudGFsLWl2YjQxLTEyODoyMDE0MDUyNTAx
NTgwMjp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMjM2LWcz
ZmI2Zjk5OjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8zZmI2Zjk5
MDM5ZjQ1Nzk5YTk4Y2Q2Yzk5NjczOTZiMjBiN2RhZmNmL2RtZXNnLXF1YW50YWwtaXZiNDIt
NjU6MjAxNDA1MjUwMTU4MDA6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4w
LXJjNi0wMDIzNi1nM2ZiNmY5OTo1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUy
NTAwMjQvM2ZiNmY5OTAzOWY0NTc5OWE5OGNkNmM5OTY3Mzk2YjIwYjdkYWZjZi9kbWVzZy1x
dWFudGFsLWl2YjQzLTk1OjIwMTQwNTI1MDE1ODAwOng4Nl82NC1yYW5kY29uZmlnLXMwLTA1
MjUwMDI0OjMuMTUuMC1yYzYtMDAyMzYtZzNmYjZmOTk6NQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMwLTA1MjUwMDI0LzNmYjZmOTkwMzlmNDU3OTlhOThjZDZjOTk2NzM5NmIyMGI3
ZGFmY2YvZG1lc2ctcXVhbnRhbC1pdmI0NC0xMDk6MjAxNDA1MjUwMTU4MDE6eDg2XzY0LXJh
bmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDIzNi1nM2ZiNmY5OTo1Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvM2ZiNmY5OTAzOWY0NTc5OWE5OGNk
NmM5OTY3Mzk2YjIwYjdkYWZjZi9kbWVzZy15b2N0by1pdmI0NC0xMDU6MjAxNDA1MjUwMTU3
NTY6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDIzNi1nM2Zi
NmY5OTo1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvM2ZiNmY5OTAz
OWY0NTc5OWE5OGNkNmM5OTY3Mzk2YjIwYjdkYWZjZi9kbWVzZy15b2N0by1pdmI0NC0xMjU6
MjAxNDA1MjUwMTU4MDE6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJj
Ni0wMDIzNi1nM2ZiNmY5OTo1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAw
MjQvM2ZiNmY5OTAzOWY0NTc5OWE5OGNkNmM5OTY3Mzk2YjIwYjdkYWZjZi9kbWVzZy15b2N0
by1pdmI0NC02MDoyMDE0MDUyNTAxNTc1OTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAy
NDozLjE1LjAtcmM2LTAwMjM2LWczZmI2Zjk5OjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNTI1MDAyNC8zZmI2Zjk5MDM5ZjQ1Nzk5YTk4Y2Q2Yzk5NjczOTZiMjBiN2RhZmNm
L2RtZXNnLXF1YW50YWwtaXZiNDMtMzc6MjAxNDA1MjUwMTU4MDM6eDg2XzY0LXJhbmRjb25m
aWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDIzNi1nM2ZiNmY5OTo1Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvM2ZiNmY5OTAzOWY0NTc5OWE5OGNkNmM5OTY3
Mzk2YjIwYjdkYWZjZi9kbWVzZy15b2N0by1pdmI0Mi0yMToyMDE0MDUyNTAxNTgwNjp4ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMjM2LWczZmI2Zjk5OjUK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8zZmI2Zjk5MDM5ZjQ1Nzk5
YTk4Y2Q2Yzk5NjczOTZiMjBiN2RhZmNmL2RtZXNnLXF1YW50YWwtaXZiNDQtODg6MjAxNDA1
MjUwMTU4MDQ6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDIz
Ni1nM2ZiNmY5OTo1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvM2Zi
NmY5OTAzOWY0NTc5OWE5OGNkNmM5OTY3Mzk2YjIwYjdkYWZjZi9kbWVzZy1xdWFudGFsLWl2
YjQyLTY1OjIwMTQwNTI1MDE1ODA5Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMu
MTUuMC1yYzYtMDAyMzYtZzNmYjZmOTk6NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA1MjUwMDI0LzNmYjZmOTkwMzlmNDU3OTlhOThjZDZjOTk2NzM5NmIyMGI3ZGFmY2YvZG1l
c2ctcXVhbnRhbC1pdmI0My05NToyMDE0MDUyNTAxNTgxMTp4ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMjM2LWczZmI2Zjk5OjUKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8zZmI2Zjk5MDM5ZjQ1Nzk5YTk4Y2Q2Yzk5NjczOTZi
MjBiN2RhZmNmL2RtZXNnLXF1YW50YWwtaXZiNDQtMTA5OjIwMTQwNTI1MDE1ODExOng4Nl82
NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDAyMzYtZzNmYjZmOTk6NQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzNmYjZmOTkwMzlmNDU3OTlh
OThjZDZjOTk2NzM5NmIyMGI3ZGFmY2YvZG1lc2ctcXVhbnRhbC1pdmI0NC0xOjIwMTQwNTI1
MDE1ODA0Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDAyMzYt
ZzNmYjZmOTk6NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzNmYjZm
OTkwMzlmNDU3OTlhOThjZDZjOTk2NzM5NmIyMGI3ZGFmY2YvZG1lc2cteW9jdG8taXZiNDEt
MTI3OjIwMTQwNTI1MDE1ODA1Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUu
MC1yYzYtMDAyMzYtZzNmYjZmOTk6NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1
MjUwMDI0LzNmYjZmOTkwMzlmNDU3OTlhOThjZDZjOTk2NzM5NmIyMGI3ZGFmY2YvZG1lc2ct
eW9jdG8taXZiNDMtMjU6MjAxNDA1MjUwMTU4MDc6eDg2XzY0LXJhbmRjb25maWctczAtMDUy
NTAwMjQ6My4xNS4wLXJjNi0wMDIzNi1nM2ZiNmY5OTo1Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczAtMDUyNTAwMjQvM2ZiNmY5OTAzOWY0NTc5OWE5OGNkNmM5OTY3Mzk2YjIwYjdk
YWZjZi9kbWVzZy15b2N0by1pdmI0My01OToyMDE0MDUyNTAxNTgxMTp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMjM2LWczZmI2Zjk5OjUKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8zZmI2Zjk5MDM5ZjQ1Nzk5YTk4Y2Q2Yzk5
NjczOTZiMjBiN2RhZmNmL2RtZXNnLXlvY3RvLWl2YjQ0LTEwMjoyMDE0MDUyNTAxNTgxMTp4
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMjM2LWczZmI2Zjk5
OjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8zZmI2Zjk5MDM5ZjQ1
Nzk5YTk4Y2Q2Yzk5NjczOTZiMjBiN2RhZmNmL2RtZXNnLXlvY3RvLWl2YjQ0LTEwNToyMDE0
MDUyNTAxNTgwNjp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAw
MjM2LWczZmI2Zjk5OjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8z
ZmI2Zjk5MDM5ZjQ1Nzk5YTk4Y2Q2Yzk5NjczOTZiMjBiN2RhZmNmL2RtZXNnLXlvY3RvLWl2
YjQ0LTYwOjIwMTQwNTI1MDE1ODEwOng4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMu
MTUuMC1yYzYtMDAyMzYtZzNmYjZmOTk6NQowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFk
IGJvb3RzChtbMTszNW0yMDE0LTA1LTI1IDAxOjU5OjAwIFJFUEVBVCBDT1VOVDogMjAgICMg
L2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKbGluZWFyLWJp
c2VjdDogYmFkIGJyYW5jaCBtYXkgYmUga2Vlcy9sc20tbW9kLXBpbgpsaW5lYXItYmlzZWN0
OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qg
c3RhcnQgM2ZiNmY5OTAzOWY0NTc5OWE5OGNkNmM5OTY3Mzk2YjIwYjdkYWZjZiA2ZDg5MTIy
ZjliNDEwNjg3MmZmNGNiMDhiOTEyY2VkNDQxOGEzNjExIC0tClByZXZpb3VzIEhFQUQgcG9z
aXRpb24gd2FzIDNmYjZmOTkuLi4gTWVyZ2UgJ2tlZXMvbHNtLW1vZC1waW4nIGludG8gZGV2
ZWwtaG91cmx5LTIwMTQwNTI0MjIKSEVBRCBpcyBub3cgYXQgODljYTNiOC4uLiBMaW51eCAz
LjE1LXJjNApCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDAgc3RlcHMpClsxNWU5NjFiNzI0OTZhMjMwMjkxNGE2NjU3NWY4ZjRiMjU0
NjNkNjVjXSBMU006IE1vZFBpbiBMU00gZm9yIG1vZHVsZSBsb2FkaW5nIHJlc3RyaWN0aW9u
cwpsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9r
ZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2xpbnV4LWRldmVsOmRl
dmVsLWhvdXJseS0yMDE0MDUyNDIyOjE1ZTk2MWI3MjQ5NmEyMzAyOTE0YTY2NTc1ZjhmNGIy
NTQ2M2Q2NWM6YmlzZWN0LWxpbnV4MgoKMjAxNC0wNS0yNS0wMTo1OToxOCAxNWU5NjFiNzI0
OTZhMjMwMjkxNGE2NjU3NWY4ZjRiMjU0NjNkNjVjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA1MjUwMDI0LTE1ZTk2MWI3MjQ5NmEyMzAyOTE0YTY2NTc1ZjhmNGIyNTQ2M2Q2NWMKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0
LzE1ZTk2MWI3MjQ5NmEyMzAyOTE0YTY2NTc1ZjhmNGIyNTQ2M2Q2NWMKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTA1MjUwMDI0LTE1ZTk2MWI3MjQ5NmEyMzAyOTE0YTY2NTc1ZjhmNGIyNTQ2M2Q2
NWMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
Ly54ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC0xNWU5NjFiNzI0OTZhMjMwMjkxNGE2
NjU3NWY4ZjRiMjU0NjNkNjVjCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNTI1MDAyNC8xNWU5NjFiNzI0OTZhMjMwMjkxNGE2NjU3NWY4ZjRiMjU0NjNkNjVjL3Zt
bGludXotMy4xNS4wLXJjNi0wMDAwMS1nMTVlOTYxYgoKMjAxNC0wNS0yNS0wMjowNzoxOCBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAuMDIwMDAwXSBTZWN1
cml0eSBGcmFtZXdvcmsgaW5pdGlhbGl6ZWQKWyAgICAwLjAyMDAwMF0gTW9kUGluIExTTTog
cmVhZHkgdG8gcGluLgpbICAgIDAuMDIwMDAwXSBZYW1hOiBiZWNvbWluZyBtaW5kZnVsLgpb
ICAgIDAuMDIwMDAwXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogWWFtYToga2VybmVs
IHJlZ2lzdHJhdGlvbiBmYWlsZWQuClsgICAgMC4wMjAwMDBdIApbICAgIDAuMDIwMDAwXSBD
UFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNS4wLXJjNi0wMDAw
MS1nMTVlOTYxYiAjMQpbICAgIDAuMDIwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2No
cywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMjAwMDBdICAwMDAwMDAwMDAwMDAw
MDAwIGZmZmZmZmZmODI4MDFlYjAgZmZmZmZmZmY4MWViYzU2MyBmZmZmZmZmZjgyODAxZjI4
ClsgICAgMC4wMjAwMDBdICBmZmZmZmZmZjgxZWI2NjVkIGZmZmZmZmZmMDAwMDAwMDggZmZm
ZmZmZmY4MjgwMWYzOCBmZmZmZmZmZjgyODAxZWQ4ClsgICAgMC4wMjAwMDBdICBmZmZmZmZm
ZjgxZWI3NjJjIDAwMDAwMDAwMDAwMDAwMDEgZmZmZmZmZmY4MjgxYjQ4MCAwMDAwMDAwMDAw
MDAwMDAwClsgICAgMC4wMjAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMjAwMDBdICBbPGZm
ZmZmZmZmODFlYmM1NjM+XSBkdW1wX3N0YWNrKzB4MTkvMHgxYgpbICAgIDAuMDIwMDAwXSAg
WzxmZmZmZmZmZjgxZWI2NjVkPl0gcGFuaWMrMHhjYi8weDFlNApbICAgIDAuMDIwMDAwXSAg
WzxmZmZmZmZmZjgxZWI3NjJjPl0gPyBwcmludGsrMHg0Zi8weDUxClsgICAgMC4wMjAwMDBd
ICBbPGZmZmZmZmZmODI5ZTEyMzI+XSB5YW1hX2luaXQrMHg2MS8weDY1ClsgICAgMC4wMjAw
MDBdICBbPGZmZmZmZmZmODI5ZTAyODk+XSBzZWN1cml0eV9pbml0KzB4MzUvMHg0NwpbICAg
IDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgyOWM1ZDU0Pl0gc3RhcnRfa2VybmVsKzB4NDVjLzB4
NGJhClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI5YzU3MDY+XSA/IHJlcGFpcl9lbnZf
c3RyaW5nKzB4NWEvMHg1YQpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgyOWM1MTIwPl0g
PyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAgICAwLjAyMDAwMF0gIFs8ZmZm
ZmZmZmY4MjljNTQyMT5dIHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMrMHgyYS8weDJjClsg
ICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI5YzU0ZmE+XSB4ODZfNjRfc3RhcnRfa2VybmVs
KzB4ZDcvMHhlNAoKRWxhcHNlZCB0aW1lOiA1CnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2
bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NTI1MDAyNC8xNWU5NjFiNzI0OTZhMjMwMjkxNGE2NjU3NWY4ZjRiMjU0NjNkNjVjL3ZtbGlu
dXotMy4xNS4wLXJjNi0wMDAwMS1nMTVlOTYxYiAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9
MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdh
eXNfZW5hYmxlZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEw
IHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNr
PTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9
L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA1MjUwMDI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDUy
NDIyOjE1ZTk2MWI3MjQ5NmEyMzAyOTE0YTY2NTc1ZjhmNGIyNTQ2M2Q2NWM6YmlzZWN0LWxp
bnV4Mi8udm1saW51ei0xNWU5NjFiNzI0OTZhMjMwMjkxNGE2NjU3NWY4ZjRiMjU0NjNkNjVj
LTIwMTQwNTI1MDIwNjQ1LTEyLWl2YjQyIGJyYW5jaD1saW51eC1kZXZlbC9kZXZlbC1ob3Vy
bHktMjAxNDA1MjQyMiBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAt
MDUyNTAwMjQvMTVlOTYxYjcyNDk2YTIzMDI5MTRhNjY1NzVmOGY0YjI1NDYzZDY1Yy92bWxp
bnV6LTMuMTUuMC1yYzYtMDAwMDEtZzE1ZTk2MWIgZHJiZC5taW5vcl9jb3VudD04JyAgLWlu
aXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUteDg2XzY0LmNneiAtbSAz
MjAgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0x
IC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFz
ZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwtaXZiNDIt
MTI1IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1pdmI0Mi0x
MjUgLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvMTVlOTYxYjcyNDk2YTIzMDI5MTRhNjY1NzVm
OGY0YjI1NDYzZDY1Yy9kbWVzZy1xdWFudGFsLWl2YjQyLTEyNToyMDE0MDUyNTAyMDY1OTp4
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMDAxLWcxNWU5NjFi
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8xNWU5NjFiNzI0OTZh
MjMwMjkxNGE2NjU3NWY4ZjRiMjU0NjNkNjVjL2RtZXNnLXF1YW50YWwtaXZiNDItMjk6MjAx
NDA1MjUwMjA3MDI6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0w
MDAwMS1nMTVlOTYxYjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQv
MTVlOTYxYjcyNDk2YTIzMDI5MTRhNjY1NzVmOGY0YjI1NDYzZDY1Yy9kbWVzZy1xdWFudGFs
LWl2YjQyLTY3OjIwMTQwNTI1MDIwNzAyOng4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0
OjMuMTUuMC1yYzYtMDAwMDEtZzE1ZTk2MWI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTA1MjUwMDI0LzE1ZTk2MWI3MjQ5NmEyMzAyOTE0YTY2NTc1ZjhmNGIyNTQ2M2Q2NWMv
ZG1lc2ctcXVhbnRhbC1pdmI0My02MzoyMDE0MDUyNTAyMDcwMTp4ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMDAxLWcxNWU5NjFiOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8xNWU5NjFiNzI0OTZhMjMwMjkxNGE2NjU3NWY4
ZjRiMjU0NjNkNjVjL2RtZXNnLXF1YW50YWwtaXZiNDQtMTI4OjIwMTQwNTI1MDIwNjU2Ong4
Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDAwMDEtZzE1ZTk2MWI6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzE1ZTk2MWI3MjQ5NmEy
MzAyOTE0YTY2NTc1ZjhmNGIyNTQ2M2Q2NWMvZG1lc2ctcXVhbnRhbC1pdmI0NC0zNzoyMDE0
MDUyNTAyMDY1Njp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAw
MDAxLWcxNWU5NjFiOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8x
NWU5NjFiNzI0OTZhMjMwMjkxNGE2NjU3NWY4ZjRiMjU0NjNkNjVjL2RtZXNnLXF1YW50YWwt
aXZiNDQtNDU6MjAxNDA1MjUwMjA2NTU6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6
My4xNS4wLXJjNi0wMDAwMS1nMTVlOTYxYjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czAtMDUyNTAwMjQvMTVlOTYxYjcyNDk2YTIzMDI5MTRhNjY1NzVmOGY0YjI1NDYzZDY1Yy9k
bWVzZy15b2N0by1pdmI0MS0xMDA6MjAxNDA1MjUwMjA2NTU6eDg2XzY0LXJhbmRjb25maWct
czAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDAwMS1nMTVlOTYxYjoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczAtMDUyNTAwMjQvMTVlOTYxYjcyNDk2YTIzMDI5MTRhNjY1NzVmOGY0
YjI1NDYzZDY1Yy9kbWVzZy15b2N0by1pdmI0MS0xMjM6MjAxNDA1MjUwMjA2NTY6eDg2XzY0
LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDAwMS1nMTVlOTYxYjoxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvMTVlOTYxYjcyNDk2YTIzMDI5
MTRhNjY1NzVmOGY0YjI1NDYzZDY1Yy9kbWVzZy15b2N0by1pdmI0Mi00MDoyMDE0MDUyNTAy
MDY1OTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMDAxLWcx
NWU5NjFiOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8xNWU5NjFi
NzI0OTZhMjMwMjkxNGE2NjU3NWY4ZjRiMjU0NjNkNjVjL2RtZXNnLXlvY3RvLWl2YjQyLTU5
OjIwMTQwNTI1MDIwNjU5Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1y
YzYtMDAwMDEtZzE1ZTk2MWI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUw
MDI0LzE1ZTk2MWI3MjQ5NmEyMzAyOTE0YTY2NTc1ZjhmNGIyNTQ2M2Q2NWMvZG1lc2cteW9j
dG8taXZiNDMtNTg6MjAxNDA1MjUwMjA2NTY6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAw
MjQ6My4xNS4wLXJjNi0wMDAwMS1nMTVlOTYxYjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczAtMDUyNTAwMjQvMTVlOTYxYjcyNDk2YTIzMDI5MTRhNjY1NzVmOGY0YjI1NDYzZDY1
Yy9kbWVzZy15b2N0by1pdmI0NC00ODoyMDE0MDUyNTAyMDY1ODp4ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMDAxLWcxNWU5NjFiOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8xNWU5NjFiNzI0OTZhMjMwMjkxNGE2NjU3NWY4
ZjRiMjU0NjNkNjVjL2RtZXNnLXlvY3RvLWl2YjQ0LTc3OjIwMTQwNTI1MDIwNjU1Ong4Nl82
NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDAwMDEtZzE1ZTk2MWI6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzE1ZTk2MWI3MjQ5NmEyMzAy
OTE0YTY2NTc1ZjhmNGIyNTQ2M2Q2NWMvZG1lc2ctcXVhbnRhbC1pdmI0My0xMDY6MjAxNDA1
MjUwMjA3MDM6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDAw
MS1nMTVlOTYxYjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvMTVl
OTYxYjcyNDk2YTIzMDI5MTRhNjY1NzVmOGY0YjI1NDYzZDY1Yy9kbWVzZy1xdWFudGFsLWl2
YjQ0LTQ1OjIwMTQwNTI1MDIwNzA1Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMu
MTUuMC1yYzYtMDAwMDEtZzE1ZTk2MWI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA1MjUwMDI0LzE1ZTk2MWI3MjQ5NmEyMzAyOTE0YTY2NTc1ZjhmNGIyNTQ2M2Q2NWMvZG1l
c2cteW9jdG8taXZiNDEtMTAwOjIwMTQwNTI1MDIwNzA1Ong4Nl82NC1yYW5kY29uZmlnLXMw
LTA1MjUwMDI0OjMuMTUuMC1yYzYtMDAwMDEtZzE1ZTk2MWI6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA1MjUwMDI0LzE1ZTk2MWI3MjQ5NmEyMzAyOTE0YTY2NTc1ZjhmNGIy
NTQ2M2Q2NWMvZG1lc2cteW9jdG8taXZiNDEtMjI6MjAxNDA1MjUwMjA3MDM6eDg2XzY0LXJh
bmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMDAwMS1nMTVlOTYxYjoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvMTVlOTYxYjcyNDk2YTIzMDI5MTRh
NjY1NzVmOGY0YjI1NDYzZDY1Yy9kbWVzZy15b2N0by1pdmI0NC00NzoyMDE0MDUyNTAyMDcw
Mjp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAwMDAxLWcxNWU5
NjFiOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8xNWU5NjFiNzI0
OTZhMjMwMjkxNGE2NjU3NWY4ZjRiMjU0NjNkNjVjL2RtZXNnLXlvY3RvLWl2YjQ0LTY3OjIw
MTQwNTI1MDIwNzAyOng4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYt
MDAwMDEtZzE1ZTk2MWI6MQowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtb
MTszNW0yMDE0LTA1LTI1IDAyOjA3OjUwIFJFUEVBVCBDT1VOVDogMjAgICMgL2tlcm5lbC10
ZXN0cy9saW51eDIvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKMTVlOTYxYjcyNDk2YTIzMDI5
MTRhNjY1NzVmOGY0YjI1NDYzZDY1YyBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQg
MTVlOTYxYjcyNDk2YTIzMDI5MTRhNjY1NzVmOGY0YjI1NDYzZDY1YwpBdXRob3I6IEtlZXMg
Q29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPgpEYXRlOiAgIEZyaSBTZXAgMjAgMTA6MDY6
NDYgMjAxMyAtMDcwMAoKICAgIExTTTogTW9kUGluIExTTSBmb3IgbW9kdWxlIGxvYWRpbmcg
cmVzdHJpY3Rpb25zCiAgICAKICAgIFRoaXMgTFNNIGVuZm9yY2VzIHRoYXQgbW9kdWxlcyBt
dXN0IGFsbCBjb21lIGZyb20gdGhlIHNhbWUgZmlsZXN5c3RlbSwKICAgIHdpdGggdGhlIGV4
cGVjdGF0aW9uIHRoYXQgc3VjaCBhIGZpbGVzeXN0ZW0gaXMgYmFja2VkIGJ5IGEgcmVhZC1v
bmx5CiAgICBkZXZpY2Ugc3VjaCBhcyBkbS12ZXJpdHkgb3IgQ0RST00uIFRoaXMgYWxsb3dz
IHN5c3RlbXMgdGhhdCBoYXZlIGEKICAgIHZlcmlmaWVkIG9yIHVuY2hhbmdpbmcgZmlsZXN5
c3RlbSB0byBlbmZvcmNlIG1vZHVsZSBsb2FkaW5nIHJlc3RyaWN0aW9ucwogICAgd2l0aG91
dCBuZWVkaW5nIHRvIHNpZ24gdGhlIG1vZHVsZXMgaW5kaXZpZHVhbGx5LgogICAgCiAgICBT
aWduZWQtb2ZmLWJ5OiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz4KCjowNDAw
MDAgMDQwMDAwIDlhM2JjYmJiYzZjNmQ4MGZhNmRlMTFkMzdlNmRiYzUwOWI2OWYxNDUgNDE1
YmZmNWIzNDg4ODU2YzVlMWNhNGY3NzU0NDc2NjE4NmI5MGJmZCBNCXNlY3VyaXR5CmJpc2Vj
dCBydW4gc3VjY2VzcwpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAxNWU5NjFiLi4uIExT
TTogTW9kUGluIExTTSBmb3IgbW9kdWxlIGxvYWRpbmcgcmVzdHJpY3Rpb25zCkhFQUQgaXMg
bm93IGF0IDRiNjYwYTcuLi4gTGludXggMy4xNS1yYzYKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDUyNDIyOjRiNjYwYTdmNWM4MDk5ZDg4ZDFhNDNkOGFlMTM4
OTY1MTEyNTkyYzc6YmlzZWN0LWxpbnV4MgoKMjAxNC0wNS0yNS0wMjowODowMCA0YjY2MGE3
ZjVjODA5OWQ4OGQxYTQzZDhhZTEzODk2NTExMjU5MmM3IHJldXNlIC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczAtMDUyNTAwMjQvNGI2NjBhN2Y1YzgwOTlkODhkMWE0M2Q4YWUxMzg5
NjUxMTI1OTJjNy92bWxpbnV6LTMuMTUuMC1yYzYKCjIwMTQtMDUtMjUtMDI6MDg6MDAgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTIzCTYwIFNVQ0NFU1MKClByZXZpb3VzIEhFQUQgcG9z
aXRpb24gd2FzIDRiNjYwYTcuLi4gTGludXggMy4xNS1yYzYKSEVBRCBpcyBub3cgYXQgMmE3
MDYzOS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA1MjQyMicK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA1MjUwMDI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDUyNDIyOjJhNzA2Mzlj
YzRlYTA4YmQ0MDcxMmNiMDEwY2FiYmIyNGI4ZWM5Mzk6YmlzZWN0LWxpbnV4MgogVEVTVCBG
QUlMVVJFClsgICAgMC4wMjAwMDBdIFNlY3VyaXR5IEZyYW1ld29yayBpbml0aWFsaXplZApb
ICAgIDAuMDIwMDAwXSBNb2RQaW4gTFNNOiByZWFkeSB0byBwaW4uClsgICAgMC4wMjAwMDBd
IFlhbWE6IGJlY29taW5nIG1pbmRmdWwuClsgICAgMC4wMjAwMDBdIEtlcm5lbCBwYW5pYyAt
IG5vdCBzeW5jaW5nOiBZYW1hOiBrZXJuZWwgcmVnaXN0cmF0aW9uIGZhaWxlZC4KWyAgICAw
LjAyMDAwMF0gClsgICAgMC4wMjAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBO
b3QgdGFpbnRlZCAzLjE1LjAtcmM2LTAzMDg1LWcyYTcwNjM5ICMyClsgICAgMC4wMjAwMDBd
IEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAg
ICAwLjAyMDAwMF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MjgwMWViMCBmZmZmZmZm
ZjgxZWM0NGU4IGZmZmZmZmZmODI4MDFmMjgKWyAgICAwLjAyMDAwMF0gIGZmZmZmZmZmODFl
YmU1ZTIgZmZmZmZmZmYwMDAwMDAwOCBmZmZmZmZmZjgyODAxZjM4IGZmZmZmZmZmODI4MDFl
ZDgKWyAgICAwLjAyMDAwMF0gIGZmZmZmZmZmODFlYmY1YjEgMDAwMDAwMDAwMDAwMDAwMSBm
ZmZmZmZmZjgyODFiNDgwIDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAyMDAwMF0gQ2FsbCBU
cmFjZToKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MWVjNDRlOD5dIGR1bXBfc3RhY2sr
MHgxOS8weDFiClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODFlYmU1ZTI+XSBwYW5pYysw
eGNiLzB4MWU0ClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODFlYmY1YjE+XSA/IHByaW50
aysweDRmLzB4NTEKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MjllMTEwNz5dIHlhbWFf
aW5pdCsweDYxLzB4NjUKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MjllMDE1ZT5dIHNl
Y3VyaXR5X2luaXQrMHgzNS8weDQ3ClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI5YzVk
NTQ+XSBzdGFydF9rZXJuZWwrMHg0NWMvMHg0YmEKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZm
ZmY4MjljNTcwNj5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHg1YS8weDVhClsgICAgMC4wMjAw
MDBdICBbPGZmZmZmZmZmODI5YzUxMjA+XSA/IGVhcmx5X2lkdF9oYW5kbGVycysweDEyMC8w
eDEyMApbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgyOWM1NDIxPl0geDg2XzY0X3N0YXJ0
X3Jlc2VydmF0aW9ucysweDJhLzB4MmMKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4Mjlj
NTRmYT5dIHg4Nl82NF9zdGFydF9rZXJuZWwrMHhkNy8weGU0CgpFbGFwc2VkIHRpbWU6IDUK
cWVtdS1zeXN0ZW0teDg2XzY0IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0gLWtlcm5lbCAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzJhNzA2MzljYzRlYTA4YmQ0MDcx
MmNiMDEwY2FiYmIyNGI4ZWM5Mzkvdm1saW51ei0zLjE1LjAtcmM2LTAzMDg1LWcyYTcwNjM5
IC1hcHBlbmQgJ2h1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIwMCBk
ZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHJjdXBkYXRlLnJjdV9jcHVf
c3RhbGxfdGltZW91dD0xMDAgcGFuaWM9MTAgc29mdGxvY2t1cF9wYW5pYz0xIG5taV93YXRj
aGRvZz1wYW5pYyAgcHJvbXB0X3JhbWRpc2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25z
b2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0vZGV2L3JhbTAgcncgbGluaz0va2J1aWxkLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvbGludXgt
ZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNTI0MjI6MmE3MDYzOWNjNGVhMDhiZDQwNzEyY2Iw
MTBjYWJiYjI0YjhlYzkzOTpiaXNlY3QtbGludXgyLy52bWxpbnV6LTJhNzA2MzljYzRlYTA4
YmQ0MDcxMmNiMDEwY2FiYmIyNGI4ZWM5MzktMjAxNDA1MjUwMDM2MjUtNi1pdmI0MSBicmFu
Y2g9bGludXgtZGV2ZWwvZGV2ZWwtaG91cmx5LTIwMTQwNTI0MjIgQk9PVF9JTUFHRT0va2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzJhNzA2MzljYzRlYTA4YmQ0MDcx
MmNiMDEwY2FiYmIyNGI4ZWM5Mzkvdm1saW51ei0zLjE1LjAtcmM2LTAzMDg1LWcyYTcwNjM5
IGRyYmQubWlub3JfY291bnQ9OCcgIC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQvcXVh
bnRhbC1jb3JlLXg4Nl82NC5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9k
ZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13
YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRmaWxlIC9kZXYvc2ht
L2tib290L3BpZC1xdWFudGFsLWl2YjQxLTEwIC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9v
dC9zZXJpYWwtcXVhbnRhbC1pdmI0MS0xMCAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1v
bml0b3IgbnVsbCAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8yYTcw
NjM5Y2M0ZWEwOGJkNDA3MTJjYjAxMGNhYmJiMjRiOGVjOTM5L2RtZXNnLXF1YW50YWwtaXZi
NDEtNDY6MjAxNDA1MjUwMDM2Mzg6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4x
NS4wLXJjNi0wMzA4NS1nMmE3MDYzOToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAt
MDUyNTAwMjQvMmE3MDYzOWNjNGVhMDhiZDQwNzEyY2IwMTBjYWJiYjI0YjhlYzkzOS9kbWVz
Zy1xdWFudGFsLWl2YjQyLTc1OjIwMTQwNTI1MDAzNjM5Ong4Nl82NC1yYW5kY29uZmlnLXMw
LTA1MjUwMDI0OjMuMTUuMC1yYzYtMDMwODUtZzJhNzA2Mzk6Mgova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA1MjUwMDI0LzJhNzA2MzljYzRlYTA4YmQ0MDcxMmNiMDEwY2FiYmIy
NGI4ZWM5MzkvZG1lc2ctcXVhbnRhbC1pdmI0My0zNzoyMDE0MDUyNTAwMzYzNzp4ODZfNjQt
cmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAzMDg1LWcyYTcwNjM5OjIKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8yYTcwNjM5Y2M0ZWEwOGJkNDA3
MTJjYjAxMGNhYmJiMjRiOGVjOTM5L2RtZXNnLXF1YW50YWwtaXZiNDQtNTU6MjAxNDA1MjUw
MDM2Mzc6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMzA4NS1n
MmE3MDYzOToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvMmE3MDYz
OWNjNGVhMDhiZDQwNzEyY2IwMTBjYWJiYjI0YjhlYzkzOS9kbWVzZy1xdWFudGFsLWl2YjQz
LTE0OjIwMTQwNTI1MDAzNjM3Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUu
MC1yYzYtMDMwODUtZzJhNzA2Mzk6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1
MjUwMDI0LzJhNzA2MzljYzRlYTA4YmQ0MDcxMmNiMDEwY2FiYmIyNGI4ZWM5MzkvZG1lc2ct
eW9jdG8taXZiNDQtMTI6MjAxNDA1MjUwMDMxMTg6eDg2XzY0LXJhbmRjb25maWctczAtMDUy
NTAwMjQ6My4xNS4wLXJjNi0wMzA4NS1nMmE3MDYzOToyCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczAtMDUyNTAwMjQvMmE3MDYzOWNjNGVhMDhiZDQwNzEyY2IwMTBjYWJiYjI0Yjhl
YzkzOS9kbWVzZy15b2N0by1pdmI0My05MzoyMDE0MDUyNTAwMzYzNzp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2LTAzMDg1LWcyYTcwNjM5OjIKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNC8yYTcwNjM5Y2M0ZWEwOGJkNDA3MTJjYjAx
MGNhYmJiMjRiOGVjOTM5L2RtZXNnLXF1YW50YWwtaXZiNDEtMTA6MjAxNDA1MjUwMDM2Mzg6
eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMzA4NS1nMmE3MDYz
OToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvMmE3MDYzOWNjNGVh
MDhiZDQwNzEyY2IwMTBjYWJiYjI0YjhlYzkzOS9kbWVzZy1xdWFudGFsLWl2YjQzLTEyMToy
MDE0MDUyNTAwMzYzNzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAyNDozLjE1LjAtcmM2
LTAzMDg1LWcyYTcwNjM5OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNTI1MDAy
NC8yYTcwNjM5Y2M0ZWEwOGJkNDA3MTJjYjAxMGNhYmJiMjRiOGVjOTM5L2RtZXNnLXF1YW50
YWwtaXZiNDQtMTEzOjIwMTQwNTI1MDAzNjM1Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUw
MDI0OjMuMTUuMC1yYzYtMDMwODUtZzJhNzA2Mzk6Mgova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTA1MjUwMDI0LzJhNzA2MzljYzRlYTA4YmQ0MDcxMmNiMDEwY2FiYmIyNGI4ZWM5
MzkvZG1lc2cteW9jdG8taXZiNDMtMzU6MjAxNDA1MjUwMDMxMTg6eDg2XzY0LXJhbmRjb25m
aWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMzA4NS1nMmE3MDYzOToyCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvMmE3MDYzOWNjNGVhMDhiZDQwNzEyY2IwMTBj
YWJiYjI0YjhlYzkzOS9kbWVzZy1xdWFudGFsLWl2YjQyLTg0OjIwMTQwNTI1MDAzMTIxOng4
Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0OjMuMTUuMC1yYzYtMDMwODUtZzJhNzA2Mzk6
Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LzJhNzA2MzljYzRlYTA4
YmQ0MDcxMmNiMDEwY2FiYmIyNGI4ZWM5MzkvZG1lc2cteW9jdG8taXZiNDItNDQ6MjAxNDA1
MjUwMDM2Mzk6eDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQ6My4xNS4wLXJjNi0wMzA4
NS1nMmE3MDYzOToyCjA6MTM6MTMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkhFQUQg
aXMgbm93IGF0IDJhNzA2MzkgMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIw
MTQwNTI0MjInCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09ClByZXZpb3VzIEhFQUQg
cG9zaXRpb24gd2FzIDJhNzA2MzkuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91
cmx5LTIwMTQwNTI0MjInCkhFQUQgaXMgbm93IGF0IDFlZTFjZWEuLi4gTWVyZ2UgZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL3NwYXJjCmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NTI1MDAyNC9saW51czptYXN0ZXI6MWVlMWNlYWZiNTcyZjFhOTI1ODA5MTY4MjY3YTc5NjJh
NDI4OWRlODpiaXNlY3QtbGludXgyCgoyMDE0LTA1LTI1LTAyOjEwOjQyIDFlZTFjZWFmYjU3
MmYxYTkyNTgwOTE2ODI2N2E3OTYyYTQyODlkZTggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAt
MDUyNTAwMjQtMWVlMWNlYWZiNTcyZjFhOTI1ODA5MTY4MjY3YTc5NjJhNDI4OWRlOApDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQv
MWVlMWNlYWZiNTcyZjFhOTI1ODA5MTY4MjY3YTc5NjJhNDI4OWRlOAp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctczAtMDUyNTAwMjQtMWVlMWNlYWZiNTcyZjFhOTI1ODA5MTY4MjY3YTc5NjJhNDI4OWRl
OAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
Lng4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0LTFlZTFjZWFmYjU3MmYxYTkyNTgwOTE2
ODI2N2E3OTYyYTQyODlkZTgKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA1MjUwMDI0LzFlZTFjZWFmYjU3MmYxYTkyNTgwOTE2ODI2N2E3OTYyYTQyODlkZTgvdm1s
aW51ei0zLjE1LjAtcmM2LTAwMTkwLWcxZWUxY2VhCgoyMDE0LTA1LTI1LTAyOjM3OjQyIGRl
dGVjdGluZyBib290IHN0YXRlIC4uCTgJMTYJMTkJMjIJNTcJNjAgU1VDQ0VTUwoKCj09PT09
PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAx
ZWUxY2VhLi4uIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9kYXZlbS9zcGFyYwpIRUFEIGlzIG5vdyBhdCBmMTNjNmQ5Li4uIEFkZCBsaW51
eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDUyMwpscyAtYSAva2J1aWxkLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvbmV4dDptYXN0
ZXI6ZjEzYzZkOTNhZThlYmRmYjEzMDFlNDMwNTFiY2VjNzhlYjkyOTk1ZjpiaXNlY3QtbGlu
dXgyCgoyMDE0LTA1LTI1LTAyOjQxOjQ3IGYxM2M2ZDkzYWU4ZWJkZmIxMzAxZTQzMDUxYmNl
Yzc4ZWI5Mjk5NWYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQtZjEzYzZkOTNh
ZThlYmRmYjEzMDFlNDMwNTFiY2VjNzhlYjkyOTk1ZgpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQvZjEzYzZkOTNhZThlYmRmYjEz
MDFlNDMwNTFiY2VjNzhlYjkyOTk1Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDUyNTAwMjQtZjEz
YzZkOTNhZThlYmRmYjEzMDFlNDMwNTFiY2VjNzhlYjkyOTk1Zgp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmln
LXMwLTA1MjUwMDI0LWYxM2M2ZDkzYWU4ZWJkZmIxMzAxZTQzMDUxYmNlYzc4ZWI5Mjk5NWYK
a2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA1MjUwMDI0L2YxM2M2ZDkz
YWU4ZWJkZmIxMzAxZTQzMDUxYmNlYzc4ZWI5Mjk5NWYvdm1saW51ei0zLjE1LjAtcmM2LW5l
eHQtMjAxNDA1MjMKCjIwMTQtMDUtMjUtMDI6NDQ6NDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4JOAk0MQk1Mwk2MCBTVUNDRVNTCgo=
--------------070607040101050806000303
Content-Type: text/plain; charset=UTF-8;
 name="config-3.15.0-rc6-00001-g15e961b"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.15.0-rc6-00001-g15e961b"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.15.0-rc6 Kernel Configuration
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
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
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
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_KMEM is not set
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
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
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
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
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
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
CONFIG_MEMTEST=y
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
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

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
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
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
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
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
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_KEYS_COMPAT=y
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
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_HHF=y
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_CLS_BPF=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_EMATCH_CANID=y
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_MCAST is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
CONFIG_KINGSUN_DONGLE=y
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_MINSTREL_HT is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_PS_DEBUG=y
CONFIG_MAC80211_TDLS_DEBUG=y
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_RFKILL_GPIO=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
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
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set

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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SBC_GXX is not set
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_PCI=y
CONFIG_MTD_PCMCIA=y
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_M25P80=y
CONFIG_MTD_SST25L=y
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
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
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
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_MTD_UBI_BLOCK=y
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
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
# CONFIG_BLK_DEV_SKD is not set
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
# CONFIG_AD525X_DPOT is not set
CONFIG_ATMEL_PWM=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=y
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
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
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5520=y
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_BNX2_ISCSI=y
# CONFIG_SCSI_BNX2X_FCOE is not set
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_HPSA is not set
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_SCSI_ESAS2R=y
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
CONFIG_SCSI_UFSHCD_PLATFORM=y
CONFIG_SCSI_HPTIOP=y
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_TCM_QLA2XXX=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=y
# CONFIG_SCSI_VIRTIO is not set
CONFIG_SCSI_CHELSIO_FCOE=y
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
# CONFIG_ATA_ACPI is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
CONFIG_BCACHE_CLOSURES_DEBUG=y
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
# CONFIG_TCM_FC is not set
# CONFIG_ISCSI_TARGET is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=y
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
# CONFIG_NET_TEAM_MODE_RANDOM is not set
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
# CONFIG_TUN is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_NLMON=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
# CONFIG_ARCNET_COM20020_CS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=y
# CONFIG_CAIF_SPI_SYNC is not set
CONFIG_CAIF_HSI=y
# CONFIG_CAIF_VIRTIO is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_VORTEX is not set
CONFIG_TYPHOON=y
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
# CONFIG_ATL1E is not set
CONFIG_ATL1C=y
CONFIG_ALX=y
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
CONFIG_BNX2X=y
CONFIG_BNX2X_SRIOV=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
CONFIG_VXGE=y
CONFIG_VXGE_DEBUG_TRACE_ALL=y
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
CONFIG_KSZ884X_PCI=y
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_FEALNX=y
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=y
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
CONFIG_NET_VENDOR_SAMSUNG=y
CONFIG_SXGBE_ETH=y
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=y
# CONFIG_SFC_MTD is not set
# CONFIG_SFC_MCDI_MON is not set
CONFIG_SFC_SRIOV=y
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
CONFIG_SMSC9420=y
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
CONFIG_STMMAC_PLATFORM=y
# CONFIG_STMMAC_PCI is not set
CONFIG_STMMAC_DEBUG_FS=y
CONFIG_STMMAC_DA=y
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NIU=y
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
# CONFIG_FDDI is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MICREL_KS8995MA=y
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_HUAWEI_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SR9800=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
# CONFIG_USB_ARMLINUX is not set
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=y
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300TOO=y
CONFIG_FARSYNC=y
# CONFIG_DLCI is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_IEEE802154_FAKELB=y
CONFIG_IEEE802154_AT86RF230=y
CONFIG_IEEE802154_MRF24J40=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_CAPI20=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
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
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
# CONFIG_TOUCHSCREEN_USB_E2I is not set
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
CONFIG_TOUCHSCREEN_USB_NEXIO=y
# CONFIG_TOUCHSCREEN_USB_EASYTOUCH is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_W90X900=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_SUR40=y
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_AD714X_SPI=y
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_ATI_REMOTE2=y
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL4030_PWRBUTTON=y
# CONFIG_INPUT_TWL4030_VIBRA is not set
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_PCF8574=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_DA9055_ONKEY=y
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_ADXL34X_SPI is not set
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_OLPC_APSP=y
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
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
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
# CONFIG_SERIAL_MRST_MAX3110 is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
# CONFIG_SERIAL_SH_SCI is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_ATMEL=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_EXYNOS is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

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
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EFM32=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=y
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
# CONFIG_SPI_ATMEL is not set
# CONFIG_SPI_BCM2835 is not set
# CONFIG_SPI_BCM63XX_HSSPI is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_CLPS711X=y
# CONFIG_SPI_EP93XX is not set
CONFIG_SPI_GPIO=y
CONFIG_SPI_IMX=y
CONFIG_SPI_FSL_DSPI=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_TI_QSPI=y
# CONFIG_SPI_OMAP_100K is not set
CONFIG_SPI_ORION=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_SH_MSIOF=y
CONFIG_SPI_SH=y
# CONFIG_SPI_SH_HSPI is not set
# CONFIG_SPI_SUN4I is not set
CONFIG_SPI_SUN6I=y
CONFIG_SPI_TEGRA114=y
CONFIG_SPI_TEGRA20_SFLASH=y
CONFIG_SPI_TEGRA20_SLINK=y
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_TXX9 is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_XTENSA_XTFPGA=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

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
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_PINMUX=y
# CONFIG_PINCONF is not set
CONFIG_DEBUG_PINCTRL=y
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_CLPS711X is not set
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_LP3943 is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_TWL6040 is not set
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set

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
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_PALMAS is not set

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_MXC=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_WM8350=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_RCAR_THERMAL=y
CONFIG_ACPI_INT3403_THERMAL=y

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
# CONFIG_DA9055_WATCHDOG is not set
CONFIG_WM831X_WATCHDOG=y
# CONFIG_WM8350_WATCHDOG is not set
# CONFIG_XILINX_WATCHDOG is not set
CONFIG_DW_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
CONFIG_TEGRA_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
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
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
# CONFIG_LPC_SCH is not set
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RTSX_USB=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_STMPE_SPI=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PM800 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AAT2870=y
# CONFIG_REGULATOR_BCM590XX is not set
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
# CONFIG_REGULATOR_S5M8767 is not set
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y
CONFIG_DRM_PTN3460=y

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
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
# CONFIG_FB_GEODE_GX is not set
CONFIG_FB_GEODE_GX1=y
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_ATMEL_PWM=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=y
CONFIG_HDMI=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
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
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CP2112=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
CONFIG_HOLTEK_FF=y
# CONFIG_HID_HUION is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=y
# CONFIG_SONY_FF is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
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
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_STORAGE_ENE_UB6250=y
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_KEYSTONE=y

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
# CONFIG_USB_CHIPIDEA is not set

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
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
CONFIG_KEYSTONE_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_TAHVO_USB=y
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_RCAR_GEN2_PHY=y
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_CLKGATE=y

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
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_SDHCI_PXAV3=y
CONFIG_MMC_SDHCI_PXAV2=y
CONFIG_MMC_OMAP_HS=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=y
CONFIG_MMC_SDRICOH_CS=y
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_SH_MMCIF=y
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
CONFIG_MMC_REALTEK_PCI=y
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
CONFIG_MEMSTICK_JMICRON_38X=y
# CONFIG_MEMSTICK_R592 is not set
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ATMEL_PWM is not set
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I3200=y
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_ISL12057 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PALMAS is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS80031=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set
# CONFIG_RTC_DRV_S5M is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1347=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
# CONFIG_RTC_DRV_PCF2123 is not set
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=y
# CONFIG_RTC_DRV_WM8350 is not set
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=y
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
CONFIG_ASUS_LAPTOP=y
# CONFIG_DELL_LAPTOP is not set
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_AMILO_RFKILL is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WIRELESS=y
CONFIG_HP_WMI=y
# CONFIG_MSI_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
# CONFIG_IDEAPAD_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
CONFIG_XO15_EBOOK=y
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=y
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_WM831X=y
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_S2MPS11 is not set
CONFIG_CLK_TWL6040=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_SH_TIMER_CMT=y
CONFIG_SH_TIMER_MTU2=y
CONFIG_SH_TIMER_TMU=y
CONFIG_EM_TIMER_STI=y
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_PALMAS=y
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_OMAP_CONTROL_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_SAMSUNG_USB2 is not set
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
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
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set

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
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

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
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
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
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_MODPIN=y
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_TEMPLATE=y
# CONFIG_IMA_NG_TEMPLATE is not set
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_APPRAISE is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_MODPIN is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_XOR_BLOCKS=y
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
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
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=y
# CONFIG_CRYPTO_DEV_CCP_CRYPTO is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_AMD is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
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
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_UCS2_STRING=y


--------------070607040101050806000303
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

_______________________________________________
LKP mailing list
LKP@linux.intel.com


--------------070607040101050806000303--
