Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaICHnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:43:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:30456 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaICHnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:43:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,455,1406617200"; 
   d="scan'208";a="585501313"
Date: Wed, 3 Sep 2014 15:43:10 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [LSM] Kernel panic - not syncing: Could not register security module
Message-ID: <20140903074310.GA25770@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kees,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git lsm/mnt-restri=
ct
commit d9df832e0cc059bc6f94ee6ea5286fdd1efac503
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Sat Sep 21 15:52:51 2013 -0700
Commit:     Kees Cook <keescook@chromium.org>
CommitDate: Tue Sep 2 14:23:48 2014 -0700

    LSM: MntRestrict blocks mounts on symlink targets
   =20
    On systems where certain filesystem contents cannot be entirely trusted,
    it is beneficial to block mounts on symlinks. This makes sure that
    malicious filesystem contents cannot trigger the over-mounting of trust=
ed
    filesystems. (For example, a bind-mounted subdirectory of /var cannot be
    redirected to mount on /etc via a symlink: a daemon cannot elevate privs
    to uid-0.)
   =20
    Signed-off-by: Kees Cook <keescook@chromium.org>

+-------------------------------------------------------------+------------=
+------------+------------------+
|                                                             | 7505ceaf86 =
| d9df832e0c | v3.17-rc3_090307 |
+-------------------------------------------------------------+------------=
+------------+------------------+
| boot_successes                                              | 183        =
| 0          | 0                |
| boot_failures                                               | 57         =
| 20         | 21               |
| BUG:kernel_boot_hang                                        | 57         =
|            |                  |
| Kernel_panic-not_syncing:Could_not_register_security_module | 0          =
| 20         | 21               |
| backtrace:panic                                             | 0          =
| 20         | 21               |
| backtrace:mntrestrict_init                                  | 0          =
| 20         | 21               |
| backtrace:security_init                                     | 0          =
| 20         | 21               |
+-------------------------------------------------------------+------------=
+------------+------------------+

[    0.008000] ACPI: Core revision 20140724
[    0.009549] ACPI: All ACPI Tables successfully acquired
[    0.010749] Security Framework initialized
[    0.012012] Kernel panic - not syncing: Could not register security modu=
le
[    0.013779] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-rc3-00003-g=
d9df832 #6
[    0.016000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.016000]  0000000000000000 ffffffff81a03eb0 ffffffff81563273 ffffffff=
817aad75
[    0.016000]  ffffffff81a03f28 ffffffff8155e113 ffffffff00000008 ffffffff=
81a03f38
[    0.016000]  ffffffff81a03ed8 00000000000143c0 ffffffff81b4d998 00000000=
80000000
[    0.016000] Call Trace:
[    0.016000]  [<ffffffff81563273>] dump_stack+0x4e/0x7a
[    0.016000]  [<ffffffff8155e113>] panic+0xc6/0x1d8
[    0.016000]  [<ffffffff81ae197b>] mntrestrict_init+0x37/0x49
[    0.016000]  [<ffffffff81adf754>] security_init+0x3c/0x47
[    0.016000]  [<ffffffff81ac0e30>] start_kernel+0x38d/0x3c7
[    0.016000]  [<ffffffff81ac08a0>] ? set_init_arg+0x53/0x53
[    0.016000]  [<ffffffff81ac0120>] ? early_idt_handlers+0x120/0x120
[    0.016000]  [<ffffffff81ac04a2>] x86_64_start_reservations+0x2a/0x2c
[    0.016000]  [<ffffffff81ac0592>] x86_64_start_kernel+0xee/0xfb

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsxa1-09030805/d9df832e0cc059bc6f94ee6ea5286fdd1efac503/vmlinuz-3.17.0-rc3=
-00003-gd9df832 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 deb=
ug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdi=
sk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnorma=
l  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig=
-hsxa1-09030805/linux-devel:devel-hourly-2014090307:d9df832e0cc059bc6f94ee6=
ea5286fdd1efac503:bisect-linux-6/.vmlinuz-d9df832e0cc059bc6f94ee6ea5286fdd1=
efac503-20140903092602-20-vp branch=3Dlinux-devel/devel-hourly-2014090307 B=
OOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa1-09030805/d9df832e0cc059bc6f94ee=
6ea5286fdd1efac503/vmlinuz-3.17.0-rc3-00003-gd9df832 drbd.minor_count=3D8' =
 -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 -net n=
ic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -w=
atchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-=
yocto-vp-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yo=
cto-vp-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yoct=
o-vp-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-=
vp-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-vp=
-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-vp-2=
5,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-vp-25 -serial =
file:/dev/shm/kboot/serial-yocto-vp-25 -daemonize -display none -monitor nu=
ll=20

git bisect start 548c845e0c12d446fbcd0cfc042b14075b7e8ca8 69e273c0b0a3c337a=
521d083374c918dc52c666f --
git bisect good eade7959972091def889e2e9b3f01ef254e20ac0  # 14:39     20+  =
    0  Merge 'spi/topic/of-guard' into devel-hourly-2014090307
git bisect  bad 0b58f7b34051d9685dbce8e967014ca9e7057c76  # 14:39      0-  =
   20  Merge 'kees/arm/ro-nx' into devel-hourly-2014090307
git bisect  bad 424e081d63cbcab953f96eb9a06a7458e6eb0645  # 14:39      0-  =
   20  Merge 'kees/lsm/mnt-restrict' into devel-hourly-2014090307
git bisect good 241aae727b8fd58a9f4bdf4919817957f4f64152  # 14:39     20+  =
    0  Merge 'renesas/devel' into devel-hourly-2014090307
git bisect good 4caa05c6584e62f376c5153c12d5f6de10a7571a  # 14:39     20+  =
    0  Merge 'kvm/nsvm-fixes' into devel-hourly-2014090307
git bisect good 44a883de40cd921a99bf5e60b9fcce20b5b4c194  # 14:39     20+  =
    0  Merge 'kees/typos' into devel-hourly-2014090307
git bisect good ea9c715254f99adc3b8a52bbc71bfcb3f329a16c  # 14:39     20+  =
    0  Merge 'staging/staging-next' into devel-hourly-2014090307
git bisect  bad d9df832e0cc059bc6f94ee6ea5286fdd1efac503  # 14:41      0-  =
   20  LSM: MntRestrict blocks mounts on symlink targets
# first bad commit: [d9df832e0cc059bc6f94ee6ea5286fdd1efac503] LSM: MntRest=
rict blocks mounts on symlink targets
git bisect good 7505ceaf863590b24a4c0c83b64817d26e0d51e3  # 14:45     60+  =
   30  Merge branch 'irq-urgent-for-linus' of git://git.kernel.org/pub/scm/=
linux/kernel/git/tip/tip
git bisect  bad 548c845e0c12d446fbcd0cfc042b14075b7e8ca8  # 14:45      0-  =
   21  0day head guard for 'devel-hourly-2014090307'
git bisect good 7505ceaf863590b24a4c0c83b64817d26e0d51e3  # 15:00     60+  =
   57  Merge branch 'irq-urgent-for-linus' of git://git.kernel.org/pub/scm/=
linux/kernel/git/tip/tip
git bisect good 40e569af89a97a775e918713e2f08fa5ce5f1bb4  # 15:01     60+  =
    0  Add linux-next specific files for 20140902


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=3D$1

kvm=3D(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-m 320
	-smp 1
	-net nic,vlan=3D1,model=3De1000
	-net user,vlan=3D1
	-boot order=3Dnc
	-no-reboot
	-watchdog i6300esb
	-rtc base=3Dlocaltime
	-serial stdio
	-display none
	-monitor null=20
)

append=3D(
	hung_task_panic=3D1
	earlyprintk=3DttyS0,115200
	debug
	apic=3Ddebug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=3D100
	panic=3D-1
	softlockup_panic=3D1
	nmi_watchdog=3Dpanic
	oops=3Dpanic
	load_ramdisk=3D2
	prompt_ramdisk=3D0
	console=3DttyS0,115200
	console=3Dtty0
	vga=3Dnormal
	root=3D/dev/ram0
	rw
	drbd.minor_count=3D8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-vp-25:20140903092640:x86_64-randconfig-hsxa1-09030805:3.17.0-rc3-00003-gd9df832:6"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.17.0-rc3-00003-gd9df832 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #6 SMP PREEMPT Wed Sep 3 09:25:45 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hsxa1-09030805/linux-devel:devel-hourly-2014090307:d9df832e0cc059bc6f9=
4ee6ea5286fdd1efac503:bisect-linux-6/.vmlinuz-d9df832e0cc059bc6f94ee6ea5286=
fdd1efac503-20140903092602-20-vp branch=3Dlinux-devel/devel-hourly-20140903=
07 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa1-09030805/d9df832e0cc059bc6f=
94ee6ea5286fdd1efac503/vmlinuz-3.17.0-rc3-00003-gd9df832 drbd.minor_count=
=3D8
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdad0-0x000fdadf] mapped at =
[ffff8800000fdad0]
[    0.000000]   mpc: fdae0-fdbe8
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01c4c000, 0x01c4cfff] PGTABLE
[    0.000000] BRK [0x01c4d000, 0x01c4dfff] PGTABLE
[    0.000000] BRK [0x01c4e000, 0x01c4efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x01c4f000, 0x01c4ffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ff9000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff8001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880013a00000 s75072 r8192=
 d23232 u2097152
[    0.000000] pcpu-alloc: s75072 r8192 d23232 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13a0ce80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hsxa1-09030805/linux-devel:devel-hourly-2014090307:d9df832e0cc0=
59bc6f94ee6ea5286fdd1efac503:bisect-linux-6/.vmlinuz-d9df832e0cc059bc6f94ee=
6ea5286fdd1efac503-20140903092602-20-vp branch=3Dlinux-devel/devel-hourly-2=
014090307 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa1-09030805/d9df832e0cc=
059bc6f94ee6ea5286fdd1efac503/vmlinuz-3.17.0-rc3-00003-gd9df832 drbd.minor_=
count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 304964K/327280K available (5549K kernel code, 685K r=
wdata, 2368K rodata, 812K init, 828K bss, 22316K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.17.0-rc3-00003-gd9df832 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #6 SMP PREEMPT Wed Sep 3 09:25:45 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hsxa1-09030805/linux-devel:devel-hourly-2014090307:d9df832e0cc059bc6f9=
4ee6ea5286fdd1efac503:bisect-linux-6/.vmlinuz-d9df832e0cc059bc6f94ee6ea5286=
fdd1efac503-20140903092602-20-vp branch=3Dlinux-devel/devel-hourly-20140903=
07 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa1-09030805/d9df832e0cc059bc6f=
94ee6ea5286fdd1efac503/vmlinuz-3.17.0-rc3-00003-gd9df832 drbd.minor_count=
=3D8
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdad0-0x000fdadf] mapped at =
[ffff8800000fdad0]
[    0.000000]   mpc: fdae0-fdbe8
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01c4c000, 0x01c4cfff] PGTABLE
[    0.000000] BRK [0x01c4d000, 0x01c4dfff] PGTABLE
[    0.000000] BRK [0x01c4e000, 0x01c4efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x01c4f000, 0x01c4ffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ff9000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff8001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880013a00000 s75072 r8192=
 d23232 u2097152
[    0.000000] pcpu-alloc: s75072 r8192 d23232 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13a0ce80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hsxa1-09030805/linux-devel:devel-hourly-2014090307:d9df832e0cc0=
59bc6f94ee6ea5286fdd1efac503:bisect-linux-6/.vmlinuz-d9df832e0cc059bc6f94ee=
6ea5286fdd1efac503-20140903092602-20-vp branch=3Dlinux-devel/devel-hourly-2=
014090307 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa1-09030805/d9df832e0cc=
059bc6f94ee6ea5286fdd1efac503/vmlinuz-3.17.0-rc3-00003-gd9df832 drbd.minor_=
count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 304964K/327280K available (5549K kernel code, 685K r=
wdata, 2368K rodata, 812K init, 828K bss, 22316K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.468 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.93 Bogo=
MIPS (lpj=3D10773872)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] ACPI: Core revision 20140724
[    0.009549] ACPI: All ACPI Tables successfully acquired
[    0.010749] Security Framework initialized
[    0.012012] Kernel panic - not syncing: Could not register security modu=
le
[    0.013779] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-rc3-00003-g=
d9df832 #6
[    0.016000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.016000]  0000000000000000 ffffffff81a03eb0 ffffffff81563273 ffffffff=
817aad75
[    0.016000]  ffffffff81a03f28 ffffffff8155e113 ffffffff00000008 ffffffff=
81a03f38
[    0.016000]  ffffffff81a03ed8 00000000000143c0 ffffffff81b4d998 00000000=
80000000
[    0.016000] Call Trace:
[    0.016000]  [<ffffffff81563273>] dump_stack+0x4e/0x7a
[    0.016000]  [<ffffffff8155e113>] panic+0xc6/0x1d8
[    0.016000]  [<ffffffff81ae197b>] mntrestrict_init+0x37/0x49
[    0.016000]  [<ffffffff81adf754>] security_init+0x3c/0x47
[    0.016000]  [<ffffffff81ac0e30>] start_kernel+0x38d/0x3c7
[    0.016000]  [<ffffffff81ac08a0>] ? set_init_arg+0x53/0x53
[    0.016000]  [<ffffffff81ac0120>] ? early_idt_handlers+0x120/0x120
[    0.016000]  [<ffffffff81ac04a2>] x86_64_start_reservations+0x2a/0x2c
[    0.016000]  [<ffffffff81ac0592>] x86_64_start_kernel+0xee/0xfb

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsxa1-09030805/d9df832e0cc059bc6f94ee6ea5286fdd1efac503/vmlinuz-3.17.0-rc3=
-00003-gd9df832 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 deb=
ug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdi=
sk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnorma=
l  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig=
-hsxa1-09030805/linux-devel:devel-hourly-2014090307:d9df832e0cc059bc6f94ee6=
ea5286fdd1efac503:bisect-linux-6/.vmlinuz-d9df832e0cc059bc6f94ee6ea5286fdd1=
efac503-20140903092602-20-vp branch=3Dlinux-devel/devel-hourly-2014090307 B=
OOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa1-09030805/d9df832e0cc059bc6f94ee=
6ea5286fdd1efac503/vmlinuz-3.17.0-rc3-00003-gd9df832 drbd.minor_count=3D8' =
 -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 -net n=
ic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -w=
atchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-=
yocto-vp-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yo=
cto-vp-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yoct=
o-vp-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-=
vp-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-vp=
-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-vp-2=
5,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-vp-25 -serial =
file:/dev/shm/kboot/serial-yocto-vp-25 -daemonize -display none -monitor nu=
ll=20

--AhhlLboLdkugWU4S--
