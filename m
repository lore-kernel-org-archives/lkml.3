Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaJDN5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 09:57:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:43154 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaJDN5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 09:57:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,653,1406617200"; 
   d="log'?scan'208";a="600684613"
Date: Sat, 4 Oct 2014 21:56:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [x86] double fault: ffff [#1]
Message-ID: <20141004135651.GC5214@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

Here is another bisect result with much earlier oops.

commit b8a868e9ea876a1b40020397305533c095921d7a
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed Apr 23 13:26:20 2014 -0700
Commit:     Andi Kleen <ak@linux.intel.com>
CommitDate: Fri Oct 3 15:19:56 2014 -0700

    x86: Add support for rd/wr fs/gs base

    ...
   =20
    v2: Change to save/restore GS instead of using swapgs
    based on the value. Large scale changes.
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

Attached dmesg for the parent commit, too, to help confirm whether it is a =
noise error.

+-------------------------------------------------------+------------+-----=
-------+------------------+
|                                                       | 598d570a05 | b8a8=
68e9ea | v3.17-rc7_100409 |
+-------------------------------------------------------+------------+-----=
-------+------------------+
| boot_successes                                        | 207        | 24  =
       | 17               |
| boot_failures                                         | 3          | 46  =
       | 4                |
| BUG:kernel_boot_crashed                               | 3          |     =
       |                  |
| double_fault:ffff                                     | 0          | 39  =
       | 4                |
| RIP:trace_hardirqs_off_thunk                          | 0          | 22  =
       | 1                |
| BUG:unable_to_handle_kernel                           | 0          | 17  =
       | 1                |
| Oops                                                  | 0          | 15  =
       | 1                |
| RIP:show_stack_log_lvl                                | 0          | 14  =
       | 1                |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 0          | 20  =
       | 2                |
| RIP:trace_hardirqs_off_caller                         | 0          | 6   =
       | 1                |
| BUG:kernel_boot_hang                                  | 0          | 23  =
       | 2                |
| backtrace:rescuer_thread                              | 0          | 1   =
       |                  |
+-------------------------------------------------------+------------+-----=
-------+------------------+

[    0.212404] regulator-dummy: no parameters
[    0.215602] NET: Registered protocol family 16
[    0.215602] NET: Registered protocol family 16
[    0.232049] double fault: ffff [#1]=20
[    0.232049] double fault: ffff [#1] PREEMPT PREEMPT SMP SMP DEBUG_PAGEAL=
LOCDEBUG_PAGEALLOC

[    0.233000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.17.0-rc7-00004-g=
b8a868e #1
[    0.233000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.17.0-rc7-00004-g=
b8a868e #1
[    0.233000] task: ffff8800121ad500 ti: ffff88001234c000 task.ti: ffff880=
01234c000
[    0.233000] task: ffff8800121ad500 ti: ffff88001234c000 task.ti: ffff880=
01234c000
[    0.233000] RIP: 0010:[<ffffffff818273f5>]=20
[    0.233000] RIP: 0010:[<ffffffff818273f5>]  [<ffffffff818273f5>] trace_h=
ardirqs_off_thunk+0x35/0x3c
 [<ffffffff818273f5>] trace_hardirqs_off_thunk+0x35/0x3c
[    0.233000] RSP: 0000:ffff880012500000  EFLAGS: 00010086
[    0.233000] RSP: 0000:ffff880012500000  EFLAGS: 00010086
[    0.233000] RAX: 0000000082767ff0 RBX: 0000000000000001 RCX: ffffffff827=
67ff0
[    0.233000] RAX: 0000000082767ff0 RBX: 0000000000000001 RCX: ffffffff827=
67ff0
[    0.233000] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff827=
69326
[    0.233000] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff827=
69326
[    0.233000] RBP: ffff880012500110 R08: 0000000000000000 R09: 00000000000=
00001
[    0.233000] RBP: ffff880012500110 R08: 0000000000000000 R09: 00000000000=
00001
[    0.233000] R10: ffff880012503e98 R11: ffffffff838c7fb0 R12: 00000000000=
13ec0
[    0.233000] R10: ffff880012503e98 R11: ffffffff838c7fb0 R12: 00000000000=
13ec0
[    0.233000] R13: 0000000000013ec0 R14: 0000000000000000 R15: 00000000000=
00000
[    0.233000] R13: 0000000000013ec0 R14: 0000000000000000 R15: 00000000000=
00000

BUG: kernel boot hang
Elapsed time: 305
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsb0-10041007/b8a868e9ea876a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-=
00004-gb8a868e -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debu=
g apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pa=
nic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdis=
k=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal=
  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-=
hsb0-10041007/linux-devel:devel-hourly-2014100409:b8a868e9ea876a1b400203973=
05533c095921d7a:bisect-linux-3/.vmlinuz-b8a868e9ea876a1b40020397305533c0959=
21d7a-20141004114524-27-lkp-nex04 branch=3Dlinux-devel/devel-hourly-2014100=
409 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb0-10041007/b8a868e9ea876a1b40=
020397305533c095921d7a/vmlinuz-3.17.0-rc7-00004-gb8a868e drbd.minor_count=
=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -=
net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-rebo=
ot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-qua=
ntal-lkp-nex04-129 -serial file:/dev/shm/kboot/serial-quantal-lkp-nex04-129=
 -daemonize -display none -monitor null=20

git bisect start cd94c0185489f0cddcbfa80e86258bb4609b6e1d fe82dcec644244676=
d55a1384c958d5f67979adb --
git bisect good a3f8f887e2a36003026b5d3effdd418d507cf7c8  # 11:19     70+  =
    0  Merge 'spi/for-linus' into devel-hourly-2014100409
git bisect good 2e6b2ee6893da99e9a156087aee97f90b0c8429c  # 11:26     70+  =
    0  Merge 'trace/for-next' into devel-hourly-2014100409
git bisect good 7ea38a3061ab82dcfb705c3f36f55ddd8c351c83  # 11:31     70+  =
    1  Merge 'usb/usb-next' into devel-hourly-2014100409
git bisect  bad 6d3ac51e9688b5cc2d4a63ba5f2e9b057db75ac8  # 11:35      0-  =
   24  Merge 'driver-core/driver-core-next' into devel-hourly-2014100409
git bisect  bad a33db30bb2f4d53f325e1c465f594894f559843c  # 11:39      0-  =
    1  Merge 'ak/x86/fsgs-2' into devel-hourly-2014100409
git bisect  bad b8a868e9ea876a1b40020397305533c095921d7a  # 11:46      0-  =
   23  x86: Add support for rd/wr fs/gs base
git bisect good a0b0be64599f50dc2c9fa85734026701221f186a  # 11:53     70+  =
    1  x86: Naturally align the debug IST stack
git bisect good 598d570a05cd31500fb15a843a92f68ddb1b3618  # 11:59     70+  =
    0  x86: Add intrinsics/macros for new rd/wr fs/gs base instructions
# first bad commit: [b8a868e9ea876a1b40020397305533c095921d7a] x86: Add sup=
port for rd/wr fs/gs base
git bisect good 598d570a05cd31500fb15a843a92f68ddb1b3618  # 12:05    210+  =
    3  x86: Add intrinsics/macros for new rd/wr fs/gs base instructions
git bisect  bad cd94c0185489f0cddcbfa80e86258bb4609b6e1d  # 12:05      0-  =
    4  0day head guard for 'devel-hourly-2014100409'
git bisect good 126d4576cb73c8a440adc37c129589cd66051bcc  # 12:11    210+  =
    7  Merge branch 'i2c/for-current' of git://git.kernel.org/pub/scm/linux=
/kernel/git/wsa/linux
git bisect good 2e1d004b9645628c64a2db55ef6b81fadf5e6e91  # 12:19    210+  =
    2  Add linux-next specific files for 20141003


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
	-smp 2
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

--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-lkp-nex04-129:20141004115043:x86_64-randconfig-hsb0-10041007::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-00004-gb8a868e (kbuild@lkp-hsx02) (=
gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP PREEMPT Sat Oct 4 11:44:33 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hsb0-10041007/linux-devel:devel-hourly-2014100409:b8a868e9ea876a1b4002=
0397305533c095921d7a:bisect-linux-3/.vmlinuz-b8a868e9ea876a1b40020397305533=
c095921d7a-20141004114524-27-lkp-nex04 branch=3Dlinux-devel/devel-hourly-20=
14100409 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb0-10041007/b8a868e9ea876=
a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-00004-gb8a868e drbd.minor_co=
unt=3D8
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
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x06540000, 0x06540fff] PGTABLE
[    0.000000] BRK [0x06541000, 0x06541fff] PGTABLE
[    0.000000] BRK [0x06542000, 0x06542fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x06543000, 0x06543fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x06544000, 0x06544fff] PGTABLE
[    0.000000] BRK [0x06545000, 0x06545fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fdffff]
[    0.000000]   NODE_DATA [mem 0x128ff000-0x12924fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1287f001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff88001180000=
0-ffff880011dfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57c000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012400000 s85120 r0 d2=
1376 u1048576
[    0.000000] pcpu-alloc: s85120 r0 d21376 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240da40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hsb0-10041007/linux-devel:devel-hourly-2014100409:b8a868e9ea876=
a1b40020397305533c095921d7a:bisect-linux-3/.vmlinuz-b8a868e9ea876a1b4002039=
7305533c095921d7a-20141004114524-27-lkp-nex04 branch=3Dlinux-devel/devel-ho=
urly-2014100409 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb0-10041007/b8a868=
e9ea876a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-00004-gb8a868e drbd.m=
inor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 208788K/327160K available (23975K kernel code, 17422=
K rwdata, 16352K rodata, 2748K init, 26140K bss, 118372K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:56 0
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-00004-gb8a868e (kbuild@lkp-hsx02) (=
gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP PREEMPT Sat Oct 4 11:44:33 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hsb0-10041007/linux-devel:devel-hourly-2014100409:b8a868e9ea876a1b4002=
0397305533c095921d7a:bisect-linux-3/.vmlinuz-b8a868e9ea876a1b40020397305533=
c095921d7a-20141004114524-27-lkp-nex04 branch=3Dlinux-devel/devel-hourly-20=
14100409 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb0-10041007/b8a868e9ea876=
a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-00004-gb8a868e drbd.minor_co=
unt=3D8
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
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x06540000, 0x06540fff] PGTABLE
[    0.000000] BRK [0x06541000, 0x06541fff] PGTABLE
[    0.000000] BRK [0x06542000, 0x06542fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x06543000, 0x06543fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x06544000, 0x06544fff] PGTABLE
[    0.000000] BRK [0x06545000, 0x06545fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fdffff]
[    0.000000]   NODE_DATA [mem 0x128ff000-0x12924fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1287f001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff88001180000=
0-ffff880011dfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57c000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012400000 s85120 r0 d2=
1376 u1048576
[    0.000000] pcpu-alloc: s85120 r0 d21376 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240da40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hsb0-10041007/linux-devel:devel-hourly-2014100409:b8a868e9ea876=
a1b40020397305533c095921d7a:bisect-linux-3/.vmlinuz-b8a868e9ea876a1b4002039=
7305533c095921d7a-20141004114524-27-lkp-nex04 branch=3Dlinux-devel/devel-ho=
urly-2014100409 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb0-10041007/b8a868=
e9ea876a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-00004-gb8a868e drbd.m=
inor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 208788K/327160K available (23975K kernel code, 17422=
K rwdata, 16352K rodata, 2748K init, 26140K bss, 118372K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:56 0
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2260.998 MHz processor
[    0.000000] tsc: Detected 2260.998 MHz processor
[    0.005000] Calibrating delay loop (skipped) preset value..=20
[    0.005000] Calibrating delay loop (skipped) preset value.. 4521.99 Bogo=
MIPS (lpj=3D2260998)
4521.99 BogoMIPS (lpj=3D2260998)
[    0.006024] pid_max: default: 4096 minimum: 301
[    0.006024] pid_max: default: 4096 minimum: 301
[    0.007126] ACPI: Core revision 20140724
[    0.007126] ACPI: Core revision 20140724
[    0.027157] ACPI:=20
[    0.027157] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.031134] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.031134] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.032623] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.032623] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.033216] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.033216] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.034049] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.034049] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.039287] Initializing cgroup subsys freezer
[    0.039287] Initializing cgroup subsys freezer
[    0.040099] Initializing cgroup subsys net_cls
[    0.040099] Initializing cgroup subsys net_cls
[    0.041102] Initializing cgroup subsys perf_event
[    0.041102] Initializing cgroup subsys perf_event
[    0.042041] Initializing cgroup subsys net_prio
[    0.042041] Initializing cgroup subsys net_prio
[    0.043045] Initializing cgroup subsys debug
[    0.043045] Initializing cgroup subsys debug
[    0.044231] numa_add_cpu cpu 0 node 0: mask now 0
[    0.044231] numa_add_cpu cpu 0 node 0: mask now 0
[    0.047028] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.047028] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.047028] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.047028] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.050218] debug: unmapping init [mem 0xffffffff84bb4000-0xffffffff84bb=
8fff]
[    0.050218] debug: unmapping init [mem 0xffffffff84bb4000-0xffffffff84bb=
8fff]
[    0.059340] Getting VERSION: 1050014
[    0.059340] Getting VERSION: 1050014
[    0.060029] Getting VERSION: 1050014
[    0.060029] Getting VERSION: 1050014
[    0.061031] Getting ID: 0
[    0.061031] Getting ID: 0
[    0.062038] Getting ID: ff000000
[    0.062038] Getting ID: ff000000
[    0.063038] Getting LVT0: 8700
[    0.063038] Getting LVT0: 8700
[    0.064027] Getting LVT1: 8400
[    0.064027] Getting LVT1: 8400
[    0.065133] enabled ExtINT on CPU#0
[    0.065133] enabled ExtINT on CPU#0
[    0.070370] ENABLING IO-APIC IRQs
[    0.070370] ENABLING IO-APIC IRQs
[    0.071133] init IO_APIC IRQs
[    0.071133] init IO_APIC IRQs
[    0.072021]  apic 0 pin 0 not connected
[    0.072021]  apic 0 pin 0 not connected
[    0.073211] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.073211] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.074133] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.074133] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.075078] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.075078] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.076093] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.076093] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.077069] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.077069] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.078074] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.078074] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.079068] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.079068] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.080068] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.080068] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.081068] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.081068] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.082068] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.082068] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.083081] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.083081] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.084074] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.084074] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.085065] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.085065] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.086066] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.086066] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.088078] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.088078] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.090067] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.090067] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.091052]  apic 0 pin 16 not connected
[    0.091052]  apic 0 pin 16 not connected
[    0.092016]  apic 0 pin 17 not connected
[    0.092016]  apic 0 pin 17 not connected
[    0.093016]  apic 0 pin 18 not connected
[    0.093016]  apic 0 pin 18 not connected
[    0.094016]  apic 0 pin 19 not connected
[    0.094016]  apic 0 pin 19 not connected
[    0.095016]  apic 0 pin 20 not connected
[    0.095016]  apic 0 pin 20 not connected
[    0.096015]  apic 0 pin 21 not connected
[    0.096015]  apic 0 pin 21 not connected
[    0.097017]  apic 0 pin 22 not connected
[    0.097017]  apic 0 pin 22 not connected
[    0.098016]  apic 0 pin 23 not connected
[    0.098016]  apic 0 pin 23 not connected
[    0.099258] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.099258] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.100018] smpboot: CPU0:=20
[    0.100018] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.105021] Using local APIC timer interrupts.
[    0.105021] calibrating APIC timer ...
[    0.105021] Using local APIC timer interrupts.
[    0.105021] calibrating APIC timer ...
[    0.107000] ... lapic delta =3D 6878746
[    0.107000] ... lapic delta =3D 6878746
[    0.107000] ... PM-Timer delta =3D 393731
[    0.107000] ... PM-Timer delta =3D 393731
[    0.107000] APIC calibration not consistent with PM-Timer: 109ms instead=
 of 100ms
[    0.107000] APIC calibration not consistent with PM-Timer: 109ms instead=
 of 100ms
[    0.107000] APIC delta adjusted to PM-Timer: 6253697 (6878746)
[    0.107000] APIC delta adjusted to PM-Timer: 6253697 (6878746)
[    0.107000] TSC delta adjusted to PM-Timer: 226085015 (248681896)
[    0.107000] TSC delta adjusted to PM-Timer: 226085015 (248681896)
[    0.107000] ..... delta 6253697
[    0.107000] ..... delta 6253697
[    0.107000] ..... mult: 268594240
[    0.107000] ..... mult: 268594240
[    0.107000] ..... calibration result: 1000591
[    0.107000] ..... calibration result: 1000591
[    0.107000] ..... CPU clock speed is 2260.0850 MHz.
[    0.107000] ..... CPU clock speed is 2260.0850 MHz.
[    0.107000] ..... host bus clock speed is 1000.0591 MHz.
[    0.107000] ..... host bus clock speed is 1000.0591 MHz.
[    0.107280] Performance Events:=20
[    0.107280] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.121121]=20
[    0.121121] **********************************************************
[    0.121121]=20
[    0.121121] **********************************************************
[    0.122014] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.122014] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.123015] **                                                      **
[    0.123015] **                                                      **
[    0.124015] ** trace_printk() being used. Allocating extra memory.  **
[    0.124015] ** trace_printk() being used. Allocating extra memory.  **
[    0.126012] **                                                      **
[    0.126012] **                                                      **
[    0.127014] ** This means that this is a DEBUG kernel and it is     **
[    0.127014] ** This means that this is a DEBUG kernel and it is     **
[    0.128017] ** unsafe for produciton use.                           **
[    0.128017] ** unsafe for produciton use.                           **
[    0.129013] **                                                      **
[    0.129013] **                                                      **
[    0.131029] ** If you see this message and you are not debugging    **
[    0.131029] ** If you see this message and you are not debugging    **
[    0.132013] ** the kernel, report this immediately to your vendor!  **
[    0.132013] ** the kernel, report this immediately to your vendor!  **
[    0.133013] **                                                      **
[    0.133013] **                                                      **
[    0.134015] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.134015] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.135014] **********************************************************
[    0.135014] **********************************************************
[    0.141434] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.141434] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.148847] x86: Booting SMP configuration:
[    0.148847] x86: Booting SMP configuration:
[    0.149015] .... node  #0, CPUs: =20
[    0.149015] .... node  #0, CPUs:         #1 #1
[    0.005000] kvm-clock: cpu 1, msr 0:1287f041, secondary cpu clock
[    0.005000] masked ExtINT on CPU#1
[    0.005000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.170151] x86: Booted up 1 node, 2 CPUs
[    0.170151] x86: Booted up 1 node, 2 CPUs
[    0.171017] smpboot: Total of 2 processors activated (9043.99 BogoMIPS)
[    0.171017] smpboot: Total of 2 processors activated (9043.99 BogoMIPS)
[    0.176015] KVM setup async PF for cpu 1
[    0.176015] KVM setup async PF for cpu 1
[    0.177000] kvm-stealtime: cpu 1, msr 1250da40
[    0.177000] kvm-stealtime: cpu 1, msr 1250da40
[    0.181794] gcov: version magic: 0x3430392a
[    0.181794] gcov: version magic: 0x3430392a
[    0.212404] regulator-dummy: no parameters
[    0.212404] regulator-dummy: no parameters
[    0.215602] NET: Registered protocol family 16
[    0.215602] NET: Registered protocol family 16
[    0.232049] double fault: ffff [#1]=20
[    0.232049] double fault: ffff [#1] PREEMPT PREEMPT SMP SMP DEBUG_PAGEAL=
LOCDEBUG_PAGEALLOC

[    0.233000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.17.0-rc7-00004-g=
b8a868e #1
[    0.233000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.17.0-rc7-00004-g=
b8a868e #1
[    0.233000] task: ffff8800121ad500 ti: ffff88001234c000 task.ti: ffff880=
01234c000
[    0.233000] task: ffff8800121ad500 ti: ffff88001234c000 task.ti: ffff880=
01234c000
[    0.233000] RIP: 0010:[<ffffffff818273f5>]=20
[    0.233000] RIP: 0010:[<ffffffff818273f5>]  [<ffffffff818273f5>] trace_h=
ardirqs_off_thunk+0x35/0x3c
 [<ffffffff818273f5>] trace_hardirqs_off_thunk+0x35/0x3c
[    0.233000] RSP: 0000:ffff880012500000  EFLAGS: 00010086
[    0.233000] RSP: 0000:ffff880012500000  EFLAGS: 00010086
[    0.233000] RAX: 0000000082767ff0 RBX: 0000000000000001 RCX: ffffffff827=
67ff0
[    0.233000] RAX: 0000000082767ff0 RBX: 0000000000000001 RCX: ffffffff827=
67ff0
[    0.233000] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff827=
69326
[    0.233000] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff827=
69326
[    0.233000] RBP: ffff880012500110 R08: 0000000000000000 R09: 00000000000=
00001
[    0.233000] RBP: ffff880012500110 R08: 0000000000000000 R09: 00000000000=
00001
[    0.233000] R10: ffff880012503e98 R11: ffffffff838c7fb0 R12: 00000000000=
13ec0
[    0.233000] R10: ffff880012503e98 R11: ffffffff838c7fb0 R12: 00000000000=
13ec0
[    0.233000] R13: 0000000000013ec0 R14: 0000000000000000 R15: 00000000000=
00000
[    0.233000] R13: 0000000000013ec0 R14: 0000000000000000 R15: 00000000000=
00000

BUG: kernel boot hang
Elapsed time: 305
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsb0-10041007/b8a868e9ea876a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-=
00004-gb8a868e -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debu=
g apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pa=
nic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdis=
k=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal=
  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-=
hsb0-10041007/linux-devel:devel-hourly-2014100409:b8a868e9ea876a1b400203973=
05533c095921d7a:bisect-linux-3/.vmlinuz-b8a868e9ea876a1b40020397305533c0959=
21d7a-20141004114524-27-lkp-nex04 branch=3Dlinux-devel/devel-hourly-2014100=
409 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb0-10041007/b8a868e9ea876a1b40=
020397305533c095921d7a/vmlinuz-3.17.0-rc7-00004-gb8a868e drbd.minor_count=
=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -=
net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-rebo=
ot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-qua=
ntal-lkp-nex04-129 -serial file:/dev/shm/kboot/serial-quantal-lkp-nex04-129=
 -daemonize -display none -monitor null=20

--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-lkp-nex04-179:20141004120456:x86_64-randconfig-hsb0-10041007::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-00003-g598d570a (kbuild@lkp-hsx02) =
(gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP PREEMPT Sat Oct 4 11:55:11 CS=
T 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hsb0-10041007/linux-devel:devel-hourly-2014100409:598d570a05cd31500fb1=
5a843a92f68ddb1b3618:bisect-linux-3/.vmlinuz-598d570a05cd31500fb15a843a92f6=
8ddb1b3618-20141004115902-9-lkp-nex04 branch=3Dlinux-devel/devel-hourly-201=
4100409 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb0-10041007/598d570a05cd31=
500fb15a843a92f68ddb1b3618/vmlinuz-3.17.0-rc7-00003-g598d570a drbd.minor_co=
unt=3D8
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
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0653f000, 0x0653ffff] PGTABLE
[    0.000000] BRK [0x06540000, 0x06540fff] PGTABLE
[    0.000000] BRK [0x06541000, 0x06541fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x06542000, 0x06542fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x06543000, 0x06543fff] PGTABLE
[    0.000000] BRK [0x06544000, 0x06544fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fdffff]
[    0.000000]   NODE_DATA [mem 0x128ff000-0x12924fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1287f001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff88001180000=
0-ffff880011dfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57c000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012400000 s85120 r0 d2=
1376 u1048576
[    0.000000] pcpu-alloc: s85120 r0 d21376 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240da40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hsb0-10041007/linux-devel:devel-hourly-2014100409:598d570a05cd3=
1500fb15a843a92f68ddb1b3618:bisect-linux-3/.vmlinuz-598d570a05cd31500fb15a8=
43a92f68ddb1b3618-20141004115902-9-lkp-nex04 branch=3Dlinux-devel/devel-hou=
rly-2014100409 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb0-10041007/598d570=
a05cd31500fb15a843a92f68ddb1b3618/vmlinuz-3.17.0-rc7-00003-g598d570a drbd.m=
inor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 208792K/327160K available (23975K kernel code, 17422=
K rwdata, 16356K rodata, 2748K init, 26136K bss, 118368K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:56 0
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-00003-g598d570a (kbuild@lkp-hsx02) =
(gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP PREEMPT Sat Oct 4 11:55:11 CS=
T 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hsb0-10041007/linux-devel:devel-hourly-2014100409:598d570a05cd31500fb1=
5a843a92f68ddb1b3618:bisect-linux-3/.vmlinuz-598d570a05cd31500fb15a843a92f6=
8ddb1b3618-20141004115902-9-lkp-nex04 branch=3Dlinux-devel/devel-hourly-201=
4100409 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb0-10041007/598d570a05cd31=
500fb15a843a92f68ddb1b3618/vmlinuz-3.17.0-rc7-00003-g598d570a drbd.minor_co=
unt=3D8
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
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0653f000, 0x0653ffff] PGTABLE
[    0.000000] BRK [0x06540000, 0x06540fff] PGTABLE
[    0.000000] BRK [0x06541000, 0x06541fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x06542000, 0x06542fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x06543000, 0x06543fff] PGTABLE
[    0.000000] BRK [0x06544000, 0x06544fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fdffff]
[    0.000000]   NODE_DATA [mem 0x128ff000-0x12924fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1287f001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff88001180000=
0-ffff880011dfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57d000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57c000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012400000 s85120 r0 d2=
1376 u1048576
[    0.000000] pcpu-alloc: s85120 r0 d21376 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240da40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hsb0-10041007/linux-devel:devel-hourly-2014100409:598d570a05cd3=
1500fb15a843a92f68ddb1b3618:bisect-linux-3/.vmlinuz-598d570a05cd31500fb15a8=
43a92f68ddb1b3618-20141004115902-9-lkp-nex04 branch=3Dlinux-devel/devel-hou=
rly-2014100409 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb0-10041007/598d570=
a05cd31500fb15a843a92f68ddb1b3618/vmlinuz-3.17.0-rc7-00003-g598d570a drbd.m=
inor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 208792K/327160K available (23975K kernel code, 17422=
K rwdata, 16356K rodata, 2748K init, 26136K bss, 118368K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:56 0
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2260.998 MHz processor
[    0.000000] tsc: Detected 2260.998 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 4521.99 Bogo=
MIPS (lpj=3D2260998)
4521.99 BogoMIPS (lpj=3D2260998)
[    0.006023] pid_max: default: 4096 minimum: 301
[    0.006023] pid_max: default: 4096 minimum: 301
[    0.008109] ACPI: Core revision 20140724
[    0.008109] ACPI: Core revision 20140724
[    0.026086] ACPI:=20
[    0.026086] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.029847] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.029847] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.031739] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.031739] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.033295] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.033295] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.034119] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.034119] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.038450] Initializing cgroup subsys freezer
[    0.038450] Initializing cgroup subsys freezer
[    0.039172] Initializing cgroup subsys net_cls
[    0.039172] Initializing cgroup subsys net_cls
[    0.040116] Initializing cgroup subsys perf_event
[    0.040116] Initializing cgroup subsys perf_event
[    0.041050] Initializing cgroup subsys net_prio
[    0.041050] Initializing cgroup subsys net_prio
[    0.042086] Initializing cgroup subsys debug
[    0.042086] Initializing cgroup subsys debug
[    0.044229] numa_add_cpu cpu 0 node 0: mask now 0
[    0.044229] numa_add_cpu cpu 0 node 0: mask now 0
[    0.045028] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.045028] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.045028] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.045028] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.046231] debug: unmapping init [mem 0xffffffff84bb4000-0xffffffff84bb=
8fff]
[    0.046231] debug: unmapping init [mem 0xffffffff84bb4000-0xffffffff84bb=
8fff]
[    0.050749] Getting VERSION: 1050014
[    0.050749] Getting VERSION: 1050014
[    0.051061] Getting VERSION: 1050014
[    0.051061] Getting VERSION: 1050014
[    0.052026] Getting ID: 0
[    0.052026] Getting ID: 0
[    0.053045] Getting ID: ff000000
[    0.053045] Getting ID: ff000000
[    0.055042] Getting LVT0: 8700
[    0.055042] Getting LVT0: 8700
[    0.056022] Getting LVT1: 8400
[    0.056022] Getting LVT1: 8400
[    0.057120] enabled ExtINT on CPU#0
[    0.057120] enabled ExtINT on CPU#0
[    0.060418] ENABLING IO-APIC IRQs
[    0.060418] ENABLING IO-APIC IRQs
[    0.061166] init IO_APIC IRQs
[    0.061166] init IO_APIC IRQs
[    0.062044]  apic 0 pin 0 not connected
[    0.062044]  apic 0 pin 0 not connected
[    0.063238] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.063238] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.064118] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.064118] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.065133] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.065133] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.066142] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.066142] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.068024] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.068024] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.069127] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.069127] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.070089] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.070089] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.071134] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.071134] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.072061] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.072061] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.074024] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.074024] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.075109] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.075109] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.076132] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.076132] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.077136] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.077136] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.078143] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.078143] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.080065] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.080065] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.082022] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.082022] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.083095]  apic 0 pin 16 not connected
[    0.083095]  apic 0 pin 16 not connected
[    0.084015]  apic 0 pin 17 not connected
[    0.084015]  apic 0 pin 17 not connected
[    0.085014]  apic 0 pin 18 not connected
[    0.085014]  apic 0 pin 18 not connected
[    0.086015]  apic 0 pin 19 not connected
[    0.086015]  apic 0 pin 19 not connected
[    0.087046]  apic 0 pin 20 not connected
[    0.087046]  apic 0 pin 20 not connected
[    0.088029]  apic 0 pin 21 not connected
[    0.088029]  apic 0 pin 21 not connected
[    0.089017]  apic 0 pin 22 not connected
[    0.089017]  apic 0 pin 22 not connected
[    0.090015]  apic 0 pin 23 not connected
[    0.090015]  apic 0 pin 23 not connected
[    0.091248] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.091248] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.092035] smpboot: CPU0:=20
[    0.092035] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.096017] Using local APIC timer interrupts.
[    0.096017] calibrating APIC timer ...
[    0.096017] Using local APIC timer interrupts.
[    0.096017] calibrating APIC timer ...
[    0.098000] ... lapic delta =3D 23062386
[    0.098000] ... lapic delta =3D 23062386
[    0.098000] ... PM-Timer delta =3D 1320851
[    0.098000] ... PM-Timer delta =3D 1320851
[    0.098000] APIC calibration not consistent with PM-Timer: 368ms instead=
 of 100ms
[    0.098000] APIC calibration not consistent with PM-Timer: 368ms instead=
 of 100ms
[    0.098000] APIC delta adjusted to PM-Timer: 6249965 (23062386)
[    0.098000] APIC delta adjusted to PM-Timer: 6249965 (23062386)
[    0.098000] TSC delta adjusted to PM-Timer: 226100273 (834310477)
[    0.098000] TSC delta adjusted to PM-Timer: 226100273 (834310477)
[    0.098000] ..... delta 6249965
[    0.098000] ..... delta 6249965
[    0.098000] ..... mult: 268433952
[    0.098000] ..... mult: 268433952
[    0.098000] ..... calibration result: 999994
[    0.098000] ..... calibration result: 999994
[    0.098000] ..... CPU clock speed is 2261.0002 MHz.
[    0.098000] ..... CPU clock speed is 2261.0002 MHz.
[    0.098000] ..... host bus clock speed is 999.0994 MHz.
[    0.098000] ..... host bus clock speed is 999.0994 MHz.
[    0.098251] Performance Events:=20
[    0.098251] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.110119]=20
[    0.110119] **********************************************************
[    0.110119]=20
[    0.110119] **********************************************************
[    0.111015] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.111015] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.112031] **                                                      **
[    0.112031] **                                                      **
[    0.113034] ** trace_printk() being used. Allocating extra memory.  **
[    0.113034] ** trace_printk() being used. Allocating extra memory.  **
[    0.114027] **                                                      **
[    0.114027] **                                                      **
[    0.115031] ** This means that this is a DEBUG kernel and it is     **
[    0.115031] ** This means that this is a DEBUG kernel and it is     **
[    0.117022] ** unsafe for produciton use.                           **
[    0.117022] ** unsafe for produciton use.                           **
[    0.118026] **                                                      **
[    0.118026] **                                                      **
[    0.119027] ** If you see this message and you are not debugging    **
[    0.119027] ** If you see this message and you are not debugging    **
[    0.120039] ** the kernel, report this immediately to your vendor!  **
[    0.120039] ** the kernel, report this immediately to your vendor!  **
[    0.121027] **                                                      **
[    0.121027] **                                                      **
[    0.122034] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.122034] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.123035] **********************************************************
[    0.123035] **********************************************************
[    0.130542] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.130542] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.137619] x86: Booting SMP configuration:
[    0.137619] x86: Booting SMP configuration:
[    0.138044] .... node  #0, CPUs: =20
[    0.138044] .... node  #0, CPUs:         #1 #1
[    0.003000] kvm-clock: cpu 1, msr 0:1287f041, secondary cpu clock
[    0.003000] masked ExtINT on CPU#1
[    0.003000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.157451] x86: Booted up 1 node, 2 CPUs
[    0.157451] x86: Booted up 1 node, 2 CPUs
[    0.159012] smpboot: Total of 2 processors activated (9043.99 BogoMIPS)
[    0.159012] smpboot: Total of 2 processors activated (9043.99 BogoMIPS)
[    0.159017] KVM setup async PF for cpu 1
[    0.159017] KVM setup async PF for cpu 1
[    0.159028] kvm-stealtime: cpu 1, msr 1250da40
[    0.159028] kvm-stealtime: cpu 1, msr 1250da40
[    0.171423] gcov: version magic: 0x3430392a
[    0.171423] gcov: version magic: 0x3430392a
[    0.201603] regulator-dummy: no parameters
[    0.201603] regulator-dummy: no parameters
[    0.203688] NET: Registered protocol family 16
[    0.203688] NET: Registered protocol family 16
[    0.223102] ACPI: bus type PCI registered
[    0.223102] ACPI: bus type PCI registered
[    0.226061] dca service started, version 1.12.1
[    0.226061] dca service started, version 1.12.1
[    0.229192] PCI: Using configuration type 1 for base access
[    0.229192] PCI: Using configuration type 1 for base access
[    0.410654] ACPI: Added _OSI(Module Device)
[    0.410654] ACPI: Added _OSI(Module Device)
[    0.411017] ACPI: Added _OSI(Processor Device)
[    0.411017] ACPI: Added _OSI(Processor Device)
[    0.412022] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.412022] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.413029] ACPI: Added _OSI(Processor Aggregator Device)
[    0.413029] ACPI: Added _OSI(Processor Aggregator Device)
[    0.453485] ACPI: Interpreter enabled
[    0.453485] ACPI: Interpreter enabled
[    0.454078] ACPI: (supports S0 S5)
[    0.454078] ACPI: (supports S0 S5)
[    0.455019] ACPI: Using IOAPIC for interrupt routing
[    0.455019] ACPI: Using IOAPIC for interrupt routing
[    0.456190] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.456190] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.502724] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.502724] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.503080] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.503080] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.505285] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.505285] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.510036] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.510036] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.512827] PCI host bridge to bus 0000:00
[    0.512827] PCI host bridge to bus 0000:00
[    0.513031] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.513031] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.514021] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.514021] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.515056] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.515056] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.516027] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.516027] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.518045] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.518045] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.519077] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.519077] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.520026] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.520026] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.521025] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.521025] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.523232] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.523232] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.526720] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.526720] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.531179] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.531179] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.537039] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.537039] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.541046] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.541046] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.542022] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.542022] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.543022] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.543022] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.544026] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.544026] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.547470] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.547470] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.549348] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.549348] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.550092] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.550092] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.552911] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.552911] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.557048] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.557048] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.560035] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.560035] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.571920] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.571920] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.573949] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.573949] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.576051] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.576051] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.578904] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.578904] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.588038] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.588038] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.593091] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.593091] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.595025] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.595025] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.608868] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.608868] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.610909] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.610909] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.612786] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.612786] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.614635] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.614635] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.616579] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.616579] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.629058] SCSI subsystem initialized
[    0.629058] SCSI subsystem initialized
[    0.630411] ACPI: bus type USB registered
[    0.630411] ACPI: bus type USB registered
[    0.631229] usbcore: registered new interface driver usbfs
[    0.631229] usbcore: registered new interface driver usbfs
[    0.633236] usbcore: registered new interface driver hub
[    0.633236] usbcore: registered new interface driver hub
[    0.634340] usbcore: registered new device driver usb
[    0.634340] usbcore: registered new device driver usb
[    0.635749] pps_core: LinuxPPS API ver. 1 registered
[    0.635749] pps_core: LinuxPPS API ver. 1 registered
[    0.637021] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.637021] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.638106] PTP clock support registered
[    0.638106] PTP clock support registered
[    0.640859] wmi: Mapper loaded
[    0.640859] wmi: Mapper loaded
[    0.644374] PCI: Using ACPI for IRQ routing
[    0.644374] PCI: Using ACPI for IRQ routing
[    0.645024] PCI: pci_cache_line_size set to 64 bytes
[    0.645024] PCI: pci_cache_line_size set to 64 bytes
[    0.647128] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.647128] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.648082] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.648082] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.651896] NET: Registered protocol family 23
[    0.651896] NET: Registered protocol family 23
[    0.652209] Bluetooth: Core ver 2.19
[    0.652209] Bluetooth: Core ver 2.19
[    0.653153] NET: Registered protocol family 31
[    0.653153] NET: Registered protocol family 31
[    0.654045] Bluetooth: HCI device and connection manager initialized
[    0.654045] Bluetooth: HCI device and connection manager initialized
[    0.655136] Bluetooth: HCI socket layer initialized
[    0.655136] Bluetooth: HCI socket layer initialized
[    0.656026] Bluetooth: L2CAP socket layer initialized
[    0.656026] Bluetooth: L2CAP socket layer initialized
[    0.657267] Bluetooth: SCO socket layer initialized
[    0.657267] Bluetooth: SCO socket layer initialized
[    0.660086] NET: Registered protocol family 8
[    0.660086] NET: Registered protocol family 8
[    0.661021] NET: Registered protocol family 20
[    0.661021] NET: Registered protocol family 20
[    0.665365] hpet0: at MMIO 0xfed00000, IRQs
[    0.665365] hpet0: at MMIO 0xfed00000, IRQs 2 2, 8, 8, 0, 0

[    0.667489] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.667489] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.675485] Switched to clocksource kvm-clock
[    0.675485] Switched to clocksource kvm-clock
[    0.678588] Warning: could not register all branches stats
[    0.678588] Warning: could not register all branches stats
[    0.680611] Warning: could not register annotated branches stats
[    0.680611] Warning: could not register annotated branches stats
[    1.519728] FS-Cache: Loaded
[    1.519728] FS-Cache: Loaded
[    1.520977] pnp: PnP ACPI init
[    1.520977] pnp: PnP ACPI init
[    1.522419] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.522419] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.548981] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.548981] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.551438] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.551438] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.568891] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.568891] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.571340] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.571340] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.588681] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.588681] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.591176] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.591176] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.613886] pnp 00:03: [dma 2]
[    1.613886] pnp 00:03: [dma 2]
[    1.615216] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.615216] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.628012] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.628012] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.630966] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.630966] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.653794] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.653794] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.679738] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.679738] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.702683] pnp: PnP ACPI: found 6 devices
[    1.702683] pnp: PnP ACPI: found 6 devices
[    1.750440] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.750440] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.763443] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.763443] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.765337] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.765337] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.774055] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.774055] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.786142] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.786142] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.788032] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.788032] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.790131] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.790131] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.792421] NET: Registered protocol family 1
[    1.792421] NET: Registered protocol family 1
[    1.833153] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.833153] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.835188] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.835188] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.839213] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.839213] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.841338] pci 0000:00:02.0: Video device with shadowed ROM
[    1.841338] pci 0000:00:02.0: Video device with shadowed ROM
[    1.847638] PCI: CLS 0 bytes, default 64
[    1.847638] PCI: CLS 0 bytes, default 64
[    1.850211] Trying to unpack rootfs image as initramfs...
[    1.850211] Trying to unpack rootfs image as initramfs...
[   11.841103] debug: unmapping init [mem 0xffff880012925000-0xffff880013fd=
7fff]
[   11.841103] debug: unmapping init [mem 0xffff880012925000-0xffff880013fd=
7fff]
[   11.899116] Scanning for low memory corruption every 60 seconds
[   11.899116] Scanning for low memory corruption every 60 seconds
[   11.923927] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[   11.923927] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[   11.928364] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[   11.928364] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[   11.969086] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[   11.969086] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[   11.989427] PCLMULQDQ-NI instructions are not detected.
[   11.989427] PCLMULQDQ-NI instructions are not detected.
[   11.991141] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[   11.991141] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[   12.003089] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[   12.003089] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[   12.005404] AVX or AES-NI instructions are not detected.
[   12.005404] AVX or AES-NI instructions are not detected.
[   12.012444] AVX instructions are not detected.
[   12.012444] AVX instructions are not detected.
[   12.014062] AVX instructions are not detected.
[   12.014062] AVX instructions are not detected.
[   12.053860] AVX instructions are not detected.
[   12.053860] AVX instructions are not detected.
[   12.055368] AVX2 instructions are not detected.
[   12.055368] AVX2 instructions are not detected.
[   12.057020] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[   12.057020] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[   12.102135] rcu-torture: Creating rcu_torture_writer task
[   12.102135] rcu-torture: Creating rcu_torture_writer task
[   12.136326] rcu-torture: Creating rcu_torture_fakewriter task
[   12.136326] rcu-torture: Creating rcu_torture_fakewriter task
[   12.138316] rcu-torture: rcu_torture_writer task started
[   12.138316] rcu-torture: rcu_torture_writer task started
[   12.144437] rcu-torture: Creating rcu_torture_fakewriter task
[   12.144437] rcu-torture: Creating rcu_torture_fakewriter task
[   12.162481] rcu-torture: rcu_torture_fakewriter task started
[   12.162481] rcu-torture: rcu_torture_fakewriter task started
[   12.164992] rcu-torture: rcu_torture_fakewriter task started
[   12.164992] rcu-torture: rcu_torture_fakewriter task started
[   12.174689] rcu-torture: Creating rcu_torture_fakewriter task
[   12.174689] rcu-torture: Creating rcu_torture_fakewriter task
[   12.187173] rcu-torture: Creating rcu_torture_fakewriter task
[   12.187173] rcu-torture: Creating rcu_torture_fakewriter task
[   12.189267] rcu-torture: rcu_torture_fakewriter task started
[   12.189267] rcu-torture: rcu_torture_fakewriter task started
[   12.195965] rcu-torture: Creating rcu_torture_reader task
[   12.195965] rcu-torture: Creating rcu_torture_reader task
[   12.197820] rcu-torture: rcu_torture_fakewriter task started
[   12.197820] rcu-torture: rcu_torture_fakewriter task started
[   12.226810] rcu-torture: Creating rcu_torture_stats task
[   12.226810] rcu-torture: Creating rcu_torture_stats task
[   12.241095] rcu-torture: rcu_torture_reader task started
[   12.241095] rcu-torture: rcu_torture_reader task started
[   12.243257] rcu-torture: Creating torture_shuffle task
[   12.243257] rcu-torture: Creating torture_shuffle task
[   12.245155] rcu-torture: rcu_torture_stats task started
[   12.245155] rcu-torture: rcu_torture_stats task started
[   12.259429] rcu-torture: Creating torture_stutter task
[   12.259429] rcu-torture: Creating torture_stutter task
[   12.261437] rcu-torture: torture_shuffle task started
[   12.261437] rcu-torture: torture_shuffle task started
[   12.276895] futex hash table entries: 16 (order: -1, 2048 bytes)
[   12.276895] futex hash table entries: 16 (order: -1, 2048 bytes)
[   12.278728] rcu-torture: torture_stutter task started
[   12.278728] rcu-torture: torture_stutter task started
[   12.285728] audit: initializing netlink subsys (disabled)
[   12.285728] audit: initializing netlink subsys (disabled)
[   12.293740] audit: type=3D2000 audit(1412395372.198:1): initialized
[   12.293740] audit: type=3D2000 audit(1412395372.198:1): initialized
[   12.910267] tsc: Refined TSC clocksource calibration: 2260.999 MHz
[   12.910267] tsc: Refined TSC clocksource calibration: 2260.999 MHz
[   27.048150] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   27.048150] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   27.290141] zpool: loaded
[   27.290141] zpool: loaded
[   27.293320] zbud: loaded
[   27.293320] zbud: loaded
[   27.299117] VFS: Disk quotas dquot_6.5.2
[   27.299117] VFS: Disk quotas dquot_6.5.2
[   27.308800] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   27.308800] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   27.323129] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   27.323129] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   27.378484] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[   27.378484] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[   27.389864] QNX4 filesystem 0.2.3 registered.
[   27.389864] QNX4 filesystem 0.2.3 registered.
[   27.404331] SGI XFS with ACLs, security attributes, realtime, debug enab=
led
[   27.404331] SGI XFS with ACLs, security attributes, realtime, debug enab=
led
[   27.452349] befs: version: 0.9.3
[   27.452349] befs: version: 0.9.3
[   27.475855] ocfs2 stack glue: unable to register sysctl
[   27.475855] ocfs2 stack glue: unable to register sysctl
[   27.477692] ocfs2: Registered cluster interface o2cb
[   27.477692] ocfs2: Registered cluster interface o2cb
[   27.495703] OCFS2 User DLM kernel interface loaded
[   27.495703] OCFS2 User DLM kernel interface loaded
[   27.541314] gfs2: GFS2 installed
[   27.541314] gfs2: GFS2 installed
[   28.138183] NET: Registered protocol family 38
[   28.138183] NET: Registered protocol family 38
[   28.152648] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[   28.152648] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[   28.161957] io scheduler noop registered (default)
[   28.161957] io scheduler noop registered (default)
[   28.165901] io scheduler cfq registered
[   28.165901] io scheduler cfq registered
[   28.167258] start plist test
[   28.167258] start plist test
[   28.244513] end plist test
[   28.244513] end plist test
[   28.247626] test_string_helpers: Running tests...
[   28.247626] test_string_helpers: Running tests...
[   28.249908] rbtree testing
[   28.249908] rbtree testing -> 192357 cycles
 -> 192357 cycles
[   37.606451] augmented rbtree testing
[   37.606451] augmented rbtree testing -> 191732 cycles
 -> 191732 cycles
[   46.962787] rivafb_setup START
[   46.962787] rivafb_setup START
[   46.964830] vmlfb: initializing
[   46.964830] vmlfb: initializing
[   46.966159] Could not find Carillo Ranch MCH device.
[   46.966159] Could not find Carillo Ranch MCH device.
[   46.968214] no IO addresses supplied
[   46.968214] no IO addresses supplied
[   46.969891] hgafb: HGA card not detected.
[   46.969891] hgafb: HGA card not detected.
[   46.971333] hgafb: probe of hgafb.0 failed with error -22
[   46.971333] hgafb: probe of hgafb.0 failed with error -22
[   46.973829] usbcore: registered new interface driver udlfb
[   46.973829] usbcore: registered new interface driver udlfb
[   46.975825] usbcore: registered new interface driver smscufx
[   46.975825] usbcore: registered new interface driver smscufx
[   46.994737] uvesafb: failed to execute /sbin/v86d
[   46.994737] uvesafb: failed to execute /sbin/v86d
[   46.996750] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[   46.996750] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[   47.003853] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[   47.003853] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[   47.006623] uvesafb: vbe_init() failed with -22
[   47.006623] uvesafb: vbe_init() failed with -22
[   47.016157] uvesafb: probe of uvesafb.0 failed with error -22
[   47.016157] uvesafb: probe of uvesafb.0 failed with error -22
[   47.032199] ipmi message handler version 39.2
[   47.032199] ipmi message handler version 39.2
[   47.034152] IPMI System Interface driver.
[   47.034152] IPMI System Interface driver.
[   47.036245] ipmi_si: Adding default-specified kcs state machine
[   47.036245] ipmi_si: Adding default-specified kcs state machine

[   47.038749] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   47.038749] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   47.055309] ipmi_si: Interface detection failed
[   47.055309] ipmi_si: Interface detection failed
[   47.091910] ipmi_si: Adding default-specified smic state machine
[   47.091910] ipmi_si: Adding default-specified smic state machine

[   47.094447] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   47.094447] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   47.098674] ipmi_si: Interface detection failed
[   47.098674] ipmi_si: Interface detection failed
[   47.103254] ipmi_si: Adding default-specified bt state machine
[   47.103254] ipmi_si: Adding default-specified bt state machine

[   47.105745] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   47.105745] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   47.109893] ipmi_si: Interface detection failed
[   47.109893] ipmi_si: Interface detection failed
[   47.119831] ipmi_si: Unable to find any System Interface(s)
[   47.119831] ipmi_si: Unable to find any System Interface(s)
[   47.122510] IPMI Watchdog: driver initialized
[   47.122510] IPMI Watchdog: driver initialized
[   47.124368] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[   47.124368] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[   47.144922] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   47.144922] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   47.147954] ACPI: Power Button [PWRF]
[   47.147954] ACPI: Power Button [PWRF]
[   47.151855] button: probe of LNXPWRBN:00 failed with error -22
[   47.151855] button: probe of LNXPWRBN:00 failed with error -22
[   47.172953] GHES: HEST is not enabled!
[   47.172953] GHES: HEST is not enabled!
[   47.174547] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   47.174547] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   47.179323] xenfs: not registering filesystem on non-xen platform
[   47.179323] xenfs: not registering filesystem on non-xen platform
[   47.386715] HDLC line discipline maxframe=3D4096
[   47.386715] HDLC line discipline maxframe=3D4096
[   47.392716] N_HDLC line discipline registered.
[   47.392716] N_HDLC line discipline registered.
[   47.394615] r3964: Philips r3964 Driver $Revision: 1.10 $
[   47.394615] r3964: Philips r3964 Driver $Revision: 1.10 $
[   47.400935] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   47.400935] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   47.479737] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   47.479737] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   47.492594] Cyclades driver 2.6
[   47.492594] Cyclades driver 2.6
[   47.494662] MOXA Intellio family driver version 6.0k
[   47.494662] MOXA Intellio family driver version 6.0k
[   47.500296] Initializing Nozomi driver 2.1d
[   47.500296] Initializing Nozomi driver 2.1d
[   47.504354] RocketPort device driver module, version 2.09, 12-June-2003
[   47.504354] RocketPort device driver module, version 2.09, 12-June-2003
[   47.512409] No rocketport ports found; unloading driver
[   47.512409] No rocketport ports found; unloading driver
[   47.516722] SyncLink GT
[   47.516722] SyncLink GT
[   47.518920] SyncLink GT, tty major#247
[   47.518920] SyncLink GT, tty major#247
[   47.523903] SyncLink GT no devices found
[   47.523903] SyncLink GT no devices found
[   47.529329] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[   47.529329] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[   47.535641] ac.o: No PCI boards found.
[   47.535641] ac.o: No PCI boards found.
[   47.538421] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[   47.538421] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[   47.547626] Non-volatile memory driver v1.3
[   47.547626] Non-volatile memory driver v1.3
[   47.553819] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   47.553819] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   47.559336] smapi::smapi_init, ERROR invalid usSmapiID
[   47.559336] smapi::smapi_init, ERROR invalid usSmapiID
[   47.563789] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[   47.563789] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[   47.572112] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[   47.572112] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[   47.578350] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   47.578350] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   47.585274] Linux agpgart interface v0.103
[   47.585274] Linux agpgart interface v0.103
[   47.591197] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   47.591197] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   47.598799] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855=
GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[   47.598799] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855=
GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[   47.611114] intelfb: Version 0.9.6
[   47.611114] intelfb: Version 0.9.6
[   47.704207] brd: module loaded
[   47.704207] brd: module loaded
[   47.734975] loop: module loaded
[   47.734975] loop: module loaded
[   47.741005] skd:  v2.2.1-b0260 loaded
[   47.741005] skd:  v2.2.1-b0260 loaded
[   47.742708] MM: desc_per_page =3D 128
[   47.742708] MM: desc_per_page =3D 128
[   47.751326] nbd: registered device at major 43
[   47.751326] nbd: registered device at major 43
[   47.789395] mtip32xx Version 1.3.1
[   47.789395] mtip32xx Version 1.3.1
[   47.797732]  nullb0: unknown partition table
[   47.797732]  nullb0: unknown partition table
[   47.809530]  nullb1: unknown partition table
[   47.809530]  nullb1: unknown partition table
[   47.812113] null: module loaded
[   47.812113] null: module loaded
[   47.813388] dummy-irq: no IRQ given.  Use irq=3DN
[   47.813388] dummy-irq: no IRQ given.  Use irq=3DN
[   47.819971] Phantom Linux Driver, version n0.9.8, init OK
[   47.819971] Phantom Linux Driver, version n0.9.8, init OK
[   47.828184] Guest personality initialized and is inactive
[   47.828184] Guest personality initialized and is inactive
[   47.830738] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D61)
[   47.830738] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D61)
[   47.837622] Initialized host personality
[   47.837622] Initialized host personality
[   47.843675] usbcore: registered new interface driver rtsx_usb
[   47.843675] usbcore: registered new interface driver rtsx_usb
[   47.847219] usbcore: registered new interface driver viperboard
[   47.847219] usbcore: registered new interface driver viperboard
[   47.853820] Uniform Multi-Platform E-IDE driver
[   47.853820] Uniform Multi-Platform E-IDE driver
[   47.860190] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[   47.860190] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[   47.868130] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[   47.868130] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[   47.876109]     ide0: BM-DMA at 0xc040-0xc047
[   47.876109]     ide0: BM-DMA at 0xc040-0xc047
[   47.877921]     ide1: BM-DMA at 0xc048-0xc04f
[   47.877921]     ide1: BM-DMA at 0xc048-0xc04f
[   47.883804] Probing IDE interface ide0...
[   47.883804] Probing IDE interface ide0...
[   48.425806] Probing IDE interface ide1...
[   48.425806] Probing IDE interface ide1...
[   49.124241] hdc: QEMU DVD-ROM, ATAPI=20
[   49.124241] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROMCD/DVD-ROM drive
 drive
[   49.743467] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[   49.743467] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[   49.746414] hdc: MWDMA2 mode selected
[   49.746414] hdc: MWDMA2 mode selected
[   49.748377] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   49.748377] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

[   49.750501] ide1 at 0x170-0x177,0x376 on irq 15
[   49.750501] ide1 at 0x170-0x177,0x376 on irq 15

[   49.760929] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[   49.760929] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[   49.769238] ide-gd driver 1.18
[   49.769238] ide-gd driver 1.18
[   49.770717] ide-cd driver 5.00
[   49.770717] ide-cd driver 5.00
[   49.781291] ide-cd: hdc: ATAPI
[   49.781291] ide-cd: hdc: ATAPI 4X 4X DVD-ROM DVD-ROM drive drive, 512kB =
Cache
, 512kB Cache
[   49.792962] cdrom: Uniform CD-ROM driver Revision: 3.20
[   49.792962] cdrom: Uniform CD-ROM driver Revision: 3.20
[   49.817447] Loading iSCSI transport class v2.0-870.
[   49.817447] Loading iSCSI transport class v2.0-870.
[   49.829407] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[   49.829407] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[   49.841993] Detecting Adaptec I2O RAID controllers...
[   49.841993] Detecting Adaptec I2O RAID controllers...
[   49.844489] Adaptec aacraid driver 1.2-0[30300]-ms
[   49.844489] Adaptec aacraid driver 1.2-0[30300]-ms
[   49.846816] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[   49.846816] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[   49.850094] scsi: <fdomain> Detection failed (no card)
[   49.850094] scsi: <fdomain> Detection failed (no card)
[   49.852838] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
[   49.852838] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
[   49.868512] mpt2sas version 16.100.00.00 loaded
[   49.868512] mpt2sas version 16.100.00.00 loaded
[   49.870777] mpt3sas version 02.100.00.00 loaded
[   49.870777] mpt3sas version 02.100.00.00 loaded
[   49.873626] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[   49.873626] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[   49.876733] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[   49.876733] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[   49.897091] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[   49.897091] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[   49.900336] QLogic NetXtreme II iSCSI Driver bnx2i v2.7.10.1 (Jul 16, 20=
14)
[   49.900336] QLogic NetXtreme II iSCSI Driver bnx2i v2.7.10.1 (Jul 16, 20=
14)
[   49.903459] iscsi: registered transport (bnx2i)
[   49.903459] iscsi: registered transport (bnx2i)
[   49.923948] iscsi: registered transport (be2iscsi)
[   49.923948] iscsi: registered transport (be2iscsi)
[   49.925970] In beiscsi_module_init, tt=3Dffffffff83d4f180
[   49.925970] In beiscsi_module_init, tt=3Dffffffff83d4f180
[   49.928531] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[   49.928531] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[   49.932403] VMware PVSCSI driver - version 1.0.5.0-k
[   49.932403] VMware PVSCSI driver - version 1.0.5.0-k
[   49.952709] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[   49.952709] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[   49.955853] SCSI Media Changer driver v0.25=20
[   49.955853] SCSI Media Changer driver v0.25=20
[   50.008246] scsi_debug: host protection
[   50.008246] scsi_debug: host protection
[   50.009925] scsi host0: scsi_debug, version 1.84 [20140706], dev_size_mb=
=3D8, opts=3D0x0
[   50.009925] scsi host0: scsi_debug, version 1.84 [20140706], dev_size_mb=
=3D8, opts=3D0x0
[   50.023851] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       01=
84 PQ: 0 ANSI: 5
[   50.023851] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       01=
84 PQ: 0 ANSI: 5
[   50.038119] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[   50.038119] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[   50.040975] SSFDC read-only Flash Translation layer
[   50.040975] SSFDC read-only Flash Translation layer
[   50.041438] device id =3D 2440
[   50.041438] device id =3D 2440
[   50.041451] device id =3D 2480
[   50.041451] device id =3D 2480
[   50.041464] device id =3D 24c0
[   50.041464] device id =3D 24c0
[   50.041476] device id =3D 24d0
[   50.041476] device id =3D 24d0
[   50.041488] device id =3D 25a1
[   50.041488] device id =3D 25a1
[   50.041500] device id =3D 2670
[   50.041500] device id =3D 2670
[   50.042141] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[   50.042141] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[   50.042155] pmc551: not detected
[   50.042155] pmc551: not detected
[   50.071112] sd 0:0:0:0: [sda] Write Protect is off
[   50.071112] sd 0:0:0:0: [sda] Write Protect is off
[   50.081198] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[   50.081198] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[   50.086093] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[   50.086093] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[   50.108116]  sda: unknown partition table
[   50.108116]  sda: unknown partition table
[   50.123298] sd 0:0:0:0: [sda] Attached SCSI disk
[   50.123298] sd 0:0:0:0: [sda] Attached SCSI disk
[   50.175547] No valid DiskOnChip devices found
[   50.175547] No valid DiskOnChip devices found
[   50.177849] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.177849] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.181775] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.181775] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.189798] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.189798] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.197816] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.197816] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.205809] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.205809] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.213790] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.213790] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   50.221846] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[   50.221846] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[   50.228635] nand: Toshiba NAND 128MiB 1,8V 8-bit
[   50.228635] nand: Toshiba NAND 128MiB 1,8V 8-bit
[   50.230537] nand: 128MiB, SLC, page size: 512, OOB size: 16
[   50.230537] nand: 128MiB, SLC, page size: 512, OOB size: 16
[   50.237197] flash size: 128 MiB
[   50.237197] flash size: 128 MiB
[   50.238532] page size: 512 bytes
[   50.238532] page size: 512 bytes
[   50.244141] OOB area size: 16 bytes
[   50.244141] OOB area size: 16 bytes
[   50.245627] sector size: 16 KiB
[   50.245627] sector size: 16 KiB
[   50.246964] pages number: 262144
[   50.246964] pages number: 262144
[   50.252492] pages per sector: 32
[   50.252492] pages per sector: 32
[   50.253870] bus width: 8
[   50.253870] bus width: 8
[   50.254957] bits in sector size: 14
[   50.254957] bits in sector size: 14
[   50.260615] bits in page size: 9
[   50.260615] bits in page size: 9
[   50.261977] bits in OOB size: 4
[   50.261977] bits in OOB size: 4
[   50.263296] flash size with OOB: 135168 KiB
[   50.263296] flash size with OOB: 135168 KiB
[   50.269219] page address bytes: 4
[   50.269219] page address bytes: 4
[   50.270648] sector address bytes: 3
[   50.270648] sector address bytes: 3
[   50.276298] options: 0x42
[   50.276298] options: 0x42
[   50.290758] Scanning device for bad blocks
[   50.290758] Scanning device for bad blocks
[   50.642696] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[   50.642696] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[   50.649153] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[   50.649153] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[   50.659275] ftl_cs: FTL header not found.
[   50.659275] ftl_cs: FTL header not found.
[   50.673133] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[   50.673133] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[   50.689356] tun: Universal TUN/TAP device driver, 1.6
[   50.689356] tun: Universal TUN/TAP device driver, 1.6
[   50.691426] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   50.691426] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   50.698370] arcnet loaded.
[   50.698370] arcnet loaded.
[   50.703790] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[   50.703790] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[   50.706850] arcnet: raw mode (`r') encapsulation support loaded.
[   50.706850] arcnet: raw mode (`r') encapsulation support loaded.
[   50.716739] arcnet: COM90xx chipset support
[   50.716739] arcnet: COM90xx chipset support
[   51.322797] S3: No ARCnet cards found.
[   51.322797] S3: No ARCnet cards found.
[   51.328657] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[   51.328657] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[   51.335797] E-mail me if you actually test this driver, please!
[   51.335797] E-mail me if you actually test this driver, please!
[   51.338370]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[   51.338370]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[   51.345919] arcnet: RIM I (entirely mem-mapped) support
[   51.345919] arcnet: RIM I (entirely mem-mapped) support
[   51.352288] E-mail me if you actually test the RIM I driver, please!
[   51.352288] E-mail me if you actually test the RIM I driver, please!
[   51.354827] Given: node 00h, shmem 0h, irq 0
[   51.354827] Given: node 00h, shmem 0h, irq 0
[   51.360879] No autoprobe for RIM I; you must specify the shmem and irq!
[   51.360879] No autoprobe for RIM I; you must specify the shmem and irq!
[   51.367837] arcnet: COM20020 PCI support
[   51.367837] arcnet: COM20020 PCI support
[   51.369716] vcan: Virtual CAN interface driver
[   51.369716] vcan: Virtual CAN interface driver
[   51.375769] slcan: serial line CAN interface driver
[   51.375769] slcan: serial line CAN interface driver
[   51.377975] slcan: 10 dynamic interface channels.
[   51.377975] slcan: 10 dynamic interface channels.
[   51.384368] CAN device driver interface
[   51.384368] CAN device driver interface
[   51.386310] usbcore: registered new interface driver ems_usb
[   51.386310] usbcore: registered new interface driver ems_usb
[   51.393187] usbcore: registered new interface driver esd_usb2
[   51.393187] usbcore: registered new interface driver esd_usb2
[   51.399858] usbcore: registered new interface driver gs_usb
[   51.399858] usbcore: registered new interface driver gs_usb
[   51.402400] usbcore: registered new interface driver kvaser_usb
[   51.402400] usbcore: registered new interface driver kvaser_usb
[   51.409496] usbcore: registered new interface driver peak_usb
[   51.409496] usbcore: registered new interface driver peak_usb
[   51.416154] usbcore: registered new interface driver usb_8dev
[   51.416154] usbcore: registered new interface driver usb_8dev
[   51.418542] sja1000 CAN netdevice driver
[   51.418542] sja1000 CAN netdevice driver
[   51.424375] sja1000_isa: insufficient parameters supplied
[   51.424375] sja1000_isa: insufficient parameters supplied
[   51.432992] cnic: QLogic NetXtreme II CNIC Driver cnic v2.5.20 (March 14=
, 2014)
[   51.432992] cnic: QLogic NetXtreme II CNIC Driver cnic v2.5.20 (March 14=
, 2014)
[   51.440845] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[   51.440845] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[   51.450221] vxge: Copyright(c) 2002-2010 Exar Corp.
[   51.450221] vxge: Copyright(c) 2002-2010 Exar Corp.
[   51.456550] vxge: Driver version: 2.5.3.22640-k
[   51.456550] vxge: Driver version: 2.5.3.22640-k
[   51.458783] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   51.458783] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   51.466120] Solarflare NET driver v4.0
[   51.466120] Solarflare NET driver v4.0
[   51.474361] usbcore: registered new interface driver kingsun-sir
[   51.474361] usbcore: registered new interface driver kingsun-sir
[   51.479452] usbcore: registered new interface driver ksdazzle-sir
[   51.479452] usbcore: registered new interface driver ksdazzle-sir
[   51.486321] usbcore: registered new interface driver ks959-sir
[   51.486321] usbcore: registered new interface driver ks959-sir
[   51.492970] PPP generic driver version 2.4.2
[   51.492970] PPP generic driver version 2.4.2
[   51.495354] PPP MPPE Compression module registered
[   51.495354] PPP MPPE Compression module registered
[   51.501551] NET: Registered protocol family 24
[   51.501551] NET: Registered protocol family 24
[   51.507837] usbcore: registered new interface driver catc
[   51.507837] usbcore: registered new interface driver catc
[   51.510188] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[   51.510188] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[   51.517523] usbcore: registered new interface driver pegasus
[   51.517523] usbcore: registered new interface driver pegasus
[   51.524093] hso: drivers/net/usb/hso.c: Option Wireless
[   51.524093] hso: drivers/net/usb/hso.c: Option Wireless
[   51.532921] usbcore: registered new interface driver hso
[   51.532921] usbcore: registered new interface driver hso
[   51.548662] usbcore: registered new interface driver cdc_phonet
[   51.548662] usbcore: registered new interface driver cdc_phonet
[   51.551213] usbcore: registered new interface driver ipheth
[   51.551213] usbcore: registered new interface driver ipheth
[   51.555590] Madge ATM Ambassador driver version 1.2.4
[   51.555590] Madge ATM Ambassador driver version 1.2.4
[   51.557669] amb: debug bitmap is 0
[   51.557669] amb: debug bitmap is 0
[   51.559366] idt77252_init: at ffffffff849c0e8b
[   51.559366] idt77252_init: at ffffffff849c0e8b
[   51.574509] Solos PCI Driver Version 1.04
[   51.574509] Solos PCI Driver Version 1.04
[   51.576773] adummy: version 1.0
[   51.576773] adummy: version 1.0
[   51.579382] I2O subsystem v1.325
[   51.579382] I2O subsystem v1.325
[   51.581404] i2o: max drivers =3D 8
[   51.581404] i2o: max drivers =3D 8
[   51.584354] I2O Block Device OSM v1.325
[   51.584354] I2O Block Device OSM v1.325
[   51.600262] I2O ProcFS OSM v1.316
[   51.600262] I2O ProcFS OSM v1.316
[   51.601848] Fusion MPT base driver 3.04.20
[   51.601848] Fusion MPT base driver 3.04.20
[   51.603539] Copyright (c) 1999-2008 LSI Corporation
[   51.603539] Copyright (c) 1999-2008 LSI Corporation
[   51.606693] Fusion MPT SPI Host driver 3.04.20
[   51.606693] Fusion MPT SPI Host driver 3.04.20
[   51.608809] Fusion MPT SAS Host driver 3.04.20
[   51.608809] Fusion MPT SAS Host driver 3.04.20
[   51.626497] usbcore: registered new interface driver hwa-rc
[   51.626497] usbcore: registered new interface driver hwa-rc
[   51.629870] usbcore: registered new interface driver i1480-dfu-usb
[   51.629870] usbcore: registered new interface driver i1480-dfu-usb
[   51.633249] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   51.633249] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   51.636348] ehci-pci: EHCI PCI platform driver
[   51.636348] ehci-pci: EHCI PCI platform driver
[   51.651921] ehci-platform: EHCI generic platform driver
[   51.651921] ehci-platform: EHCI generic platform driver
[   51.654341] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   51.654341] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   51.657611] ohci-platform: OHCI generic platform driver
[   51.657611] ohci-platform: OHCI generic platform driver
[   51.659958] uhci_hcd: USB Universal Host Controller Interface driver
[   51.659958] uhci_hcd: USB Universal Host Controller Interface driver
[   51.680788] usbcore: registered new interface driver hwa-hc
[   51.680788] usbcore: registered new interface driver hwa-hc
[   51.683529] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[   51.683529] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[   51.685966] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[   51.685966] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[   51.692431] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[   51.692431] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[   51.711941] usbcore: registered new interface driver cdc_acm
[   51.711941] usbcore: registered new interface driver cdc_acm
[   51.731297] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[   51.731297] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[   51.734817] usbcore: registered new interface driver usblp
[   51.734817] usbcore: registered new interface driver usblp
[   51.737219] usbcore: registered new interface driver cdc_wdm
[   51.737219] usbcore: registered new interface driver cdc_wdm
[   51.739508] usbcore: registered new interface driver usbtmc
[   51.739508] usbcore: registered new interface driver usbtmc
[   51.742267] usbcore: registered new interface driver usb-storage
[   51.742267] usbcore: registered new interface driver usb-storage
[   51.752829] usbcore: registered new interface driver ums-alauda
[   51.752829] usbcore: registered new interface driver ums-alauda
[   51.755207] usbcore: registered new interface driver ums-datafab
[   51.755207] usbcore: registered new interface driver ums-datafab
[   51.757821] usbcore: registered new interface driver ums-isd200
[   51.757821] usbcore: registered new interface driver ums-isd200
[   51.760331] usbcore: registered new interface driver ums-jumpshot
[   51.760331] usbcore: registered new interface driver ums-jumpshot
[   51.762786] usbcore: registered new interface driver ums-karma
[   51.762786] usbcore: registered new interface driver ums-karma
[   51.775298] usbcore: registered new interface driver ums-onetouch
[   51.775298] usbcore: registered new interface driver ums-onetouch
[   51.777954] usbcore: registered new interface driver ums-realtek
[   51.777954] usbcore: registered new interface driver ums-realtek
[   51.780444] usbcore: registered new interface driver ums-sddr55
[   51.780444] usbcore: registered new interface driver ums-sddr55
[   51.782800] usbcore: registered new interface driver ums-usbat
[   51.782800] usbcore: registered new interface driver ums-usbat
[   51.785433] usbcore: registered new interface driver mdc800
[   51.785433] usbcore: registered new interface driver mdc800
[   51.802941] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[   51.802941] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[   51.806495] usbcore: registered new interface driver microtekX6
[   51.806495] usbcore: registered new interface driver microtekX6
[   51.809694] usbcore: registered new interface driver usbserial
[   51.809694] usbcore: registered new interface driver usbserial
[   51.812407] usbcore: registered new interface driver aircable
[   51.812407] usbcore: registered new interface driver aircable
[   51.829968] usbserial: USB Serial support registered for aircable
[   51.829968] usbserial: USB Serial support registered for aircable
[   51.832473] usbcore: registered new interface driver belkin_sa
[   51.832473] usbcore: registered new interface driver belkin_sa
[   51.835362] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[   51.835362] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[   51.839434] usbcore: registered new interface driver cp210x
[   51.839434] usbcore: registered new interface driver cp210x
[   51.852322] usbserial: USB Serial support registered for cp210x
[   51.852322] usbserial: USB Serial support registered for cp210x
[   51.855053] usbcore: registered new interface driver cypress_m8
[   51.855053] usbcore: registered new interface driver cypress_m8
[   51.864426] usbserial: USB Serial support registered for DeLorme Earthma=
te USB
[   51.864426] usbserial: USB Serial support registered for DeLorme Earthma=
te USB
[   51.867754] usbserial: USB Serial support registered for HID->COM RS232 =
Adapter
[   51.867754] usbserial: USB Serial support registered for HID->COM RS232 =
Adapter
[   51.871002] usbserial: USB Serial support registered for Nokia CA-42 V2 =
Adapter
[   51.871002] usbserial: USB Serial support registered for Nokia CA-42 V2 =
Adapter
[   51.874270] usbcore: registered new interface driver digi_acceleport
[   51.874270] usbcore: registered new interface driver digi_acceleport
[   51.889386] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[   51.889386] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[   51.892805] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[   51.892805] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[   51.896326] usbcore: registered new interface driver empeg
[   51.896326] usbcore: registered new interface driver empeg
[   51.899307] usbserial: USB Serial support registered for empeg
[   51.899307] usbserial: USB Serial support registered for empeg
[   51.901971] usbcore: registered new interface driver f81232
[   51.901971] usbcore: registered new interface driver f81232
[   51.904700] usbserial: USB Serial support registered for f81232
[   51.904700] usbserial: USB Serial support registered for f81232
[   51.907418] usbcore: registered new interface driver ftdi_sio
[   51.907418] usbcore: registered new interface driver ftdi_sio
[   51.910090] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[   51.910090] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[   51.913667] usbcore: registered new interface driver garmin_gps
[   51.913667] usbcore: registered new interface driver garmin_gps
[   51.916511] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[   51.916511] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[   51.919706] usbcore: registered new interface driver ipw
[   51.919706] usbcore: registered new interface driver ipw
[   51.922114] usbserial: USB Serial support registered for IPWireless conv=
erter
[   51.922114] usbserial: USB Serial support registered for IPWireless conv=
erter
[   51.925434] usbcore: registered new interface driver ir_usb
[   51.925434] usbcore: registered new interface driver ir_usb
[   51.927732] usbserial: USB Serial support registered for IR Dongle
[   51.927732] usbserial: USB Serial support registered for IR Dongle
[   51.929893] usbcore: registered new interface driver iuu_phoenix
[   51.929893] usbcore: registered new interface driver iuu_phoenix
[   51.932441] usbserial: USB Serial support registered for iuu_phoenix
[   51.932441] usbserial: USB Serial support registered for iuu_phoenix
[   51.935324] usbcore: registered new interface driver keyspan
[   51.935324] usbcore: registered new interface driver keyspan
[   51.937926] usbserial: USB Serial support registered for Keyspan - (with=
out firmware)
[   51.937926] usbserial: USB Serial support registered for Keyspan - (with=
out firmware)
[   51.941785] usbserial: USB Serial support registered for Keyspan 1 port =
adapter
[   51.941785] usbserial: USB Serial support registered for Keyspan 1 port =
adapter
[   51.945132] usbserial: USB Serial support registered for Keyspan 2 port =
adapter
[   51.945132] usbserial: USB Serial support registered for Keyspan 2 port =
adapter
[   51.948509] usbserial: USB Serial support registered for Keyspan 4 port =
adapter
[   51.948509] usbserial: USB Serial support registered for Keyspan 4 port =
adapter
[   51.951857] usbcore: registered new interface driver keyspan_pda
[   51.951857] usbcore: registered new interface driver keyspan_pda
[   51.954503] usbserial: USB Serial support registered for Keyspan PDA
[   51.954503] usbserial: USB Serial support registered for Keyspan PDA
[   51.957515] usbserial: USB Serial support registered for Keyspan PDA - (=
prerenumeration)
[   51.957515] usbserial: USB Serial support registered for Keyspan PDA - (=
prerenumeration)
[   51.960418] usbcore: registered new interface driver kl5kusb105
[   51.960418] usbcore: registered new interface driver kl5kusb105
[   51.962711] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[   51.962711] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[   51.966012] usbcore: registered new interface driver kobil_sct
[   51.966012] usbcore: registered new interface driver kobil_sct
[   51.968616] usbserial: USB Serial support registered for KOBIL USB smart=
 card terminal
[   51.968616] usbserial: USB Serial support registered for KOBIL USB smart=
 card terminal
[   51.971369] usbcore: registered new interface driver mct_u232
[   51.971369] usbcore: registered new interface driver mct_u232
[   51.973791] usbserial: USB Serial support registered for MCT U232
[   51.973791] usbserial: USB Serial support registered for MCT U232
[   51.976177] usbcore: registered new interface driver metro_usb
[   51.976177] usbcore: registered new interface driver metro_usb
[   51.978496] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[   51.978496] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[   51.981692] usbcore: registered new interface driver mos7720
[   51.981692] usbcore: registered new interface driver mos7720
[   51.984097] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[   51.984097] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[   51.987337] usbcore: registered new interface driver mxuport
[   51.987337] usbcore: registered new interface driver mxuport
[   51.998379] usbserial: USB Serial support registered for MOXA UPort
[   51.998379] usbserial: USB Serial support registered for MOXA UPort
[   52.000732] usbcore: registered new interface driver navman
[   52.000732] usbcore: registered new interface driver navman
[   52.003357] usbserial: USB Serial support registered for navman
[   52.003357] usbserial: USB Serial support registered for navman
[   52.006490] usbcore: registered new interface driver omninet
[   52.006490] usbcore: registered new interface driver omninet
[   52.009617] usbserial: USB Serial support registered for ZyXEL - omni.ne=
t lcd plus usb
[   52.009617] usbserial: USB Serial support registered for ZyXEL - omni.ne=
t lcd plus usb
[   52.013365] usbcore: registered new interface driver opticon
[   52.013365] usbcore: registered new interface driver opticon
[   52.025115] usbserial: USB Serial support registered for opticon
[   52.025115] usbserial: USB Serial support registered for opticon
[   52.030483] usbcore: registered new interface driver oti6858
[   52.030483] usbcore: registered new interface driver oti6858
[   52.033428] usbserial: USB Serial support registered for oti6858
[   52.033428] usbserial: USB Serial support registered for oti6858
[   52.036468] usbcore: registered new interface driver qcaux
[   52.036468] usbcore: registered new interface driver qcaux
[   52.039396] usbserial: USB Serial support registered for qcaux
[   52.039396] usbserial: USB Serial support registered for qcaux
[   52.045524] usbcore: registered new interface driver safe_serial
[   52.045524] usbcore: registered new interface driver safe_serial
[   52.048371] usbserial: USB Serial support registered for safe_serial
[   52.048371] usbserial: USB Serial support registered for safe_serial
[   52.051237] usbcore: registered new interface driver sierra
[   52.051237] usbcore: registered new interface driver sierra
[   52.054316] usbserial: USB Serial support registered for Sierra USB modem
[   52.054316] usbserial: USB Serial support registered for Sierra USB modem
[   52.056833] usbcore: registered new interface driver ssu100
[   52.056833] usbcore: registered new interface driver ssu100
[   52.058852] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[   52.058852] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[   52.075086] usbcore: registered new interface driver symbolserial
[   52.075086] usbcore: registered new interface driver symbolserial
[   52.077463] usbserial: USB Serial support registered for symbol
[   52.077463] usbserial: USB Serial support registered for symbol
[   52.079686] usbcore: registered new interface driver whiteheat
[   52.079686] usbcore: registered new interface driver whiteheat
[   52.082094] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[   52.082094] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[   52.085762] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[   52.085762] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[   52.088870] usbcore: registered new interface driver xsens_mt
[   52.088870] usbcore: registered new interface driver xsens_mt
[   52.091482] usbserial: USB Serial support registered for xsens_mt
[   52.091482] usbserial: USB Serial support registered for xsens_mt
[   52.094639] usbcore: registered new interface driver zte_ev
[   52.094639] usbcore: registered new interface driver zte_ev
[   52.097219] usbserial: USB Serial support registered for zte_ev
[   52.097219] usbserial: USB Serial support registered for zte_ev
[   52.100259] usbcore: registered new interface driver adutux
[   52.100259] usbcore: registered new interface driver adutux
[   52.102648] usbcore: registered new interface driver cypress_cy7c63
[   52.102648] usbcore: registered new interface driver cypress_cy7c63
[   52.105070] usbcore: registered new interface driver cytherm
[   52.105070] usbcore: registered new interface driver cytherm
[   52.107153] usbcore: registered new interface driver emi26 - firmware lo=
ader
[   52.107153] usbcore: registered new interface driver emi26 - firmware lo=
ader
[   52.109910] usbcore: registered new interface driver emi62 - firmware lo=
ader
[   52.109910] usbcore: registered new interface driver emi62 - firmware lo=
ader
[   52.112498] usbcore: registered new interface driver idmouse
[   52.112498] usbcore: registered new interface driver idmouse
[   52.121921] usbcore: registered new interface driver iowarrior
[   52.121921] usbcore: registered new interface driver iowarrior
[   52.124874] usbcore: registered new interface driver usblcd
[   52.124874] usbcore: registered new interface driver usblcd
[   52.127623] usbcore: registered new interface driver ldusb
[   52.127623] usbcore: registered new interface driver ldusb
[   52.130448] usbcore: registered new interface driver usbled
[   52.130448] usbcore: registered new interface driver usbled
[   52.133145] usbcore: registered new interface driver legousbtower
[   52.133145] usbcore: registered new interface driver legousbtower
[   52.153139] usbcore: registered new interface driver rio500
[   52.153139] usbcore: registered new interface driver rio500
[   52.155925] usbcore: registered new interface driver usbtest
[   52.155925] usbcore: registered new interface driver usbtest
[   52.158751] usbcore: registered new interface driver usb_ehset_test
[   52.158751] usbcore: registered new interface driver usb_ehset_test
[   52.161890] usbcore: registered new interface driver trancevibrator
[   52.161890] usbcore: registered new interface driver trancevibrator
[   52.177923] usbcore: registered new interface driver usbsevseg
[   52.177923] usbcore: registered new interface driver usbsevseg
[   52.180852] usbcore: registered new interface driver sisusb
[   52.180852] usbcore: registered new interface driver sisusb
[   52.183850] usbcore: registered new interface driver lvs
[   52.183850] usbcore: registered new interface driver lvs
[   52.187500] usbcore: registered new interface driver ueagle-atm
[   52.187500] usbcore: registered new interface driver ueagle-atm
[   52.190277] xusbatm: malformed module parameters
[   52.190277] xusbatm: malformed module parameters
[   52.204086] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[   52.204086] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[   52.207382] dummy_hcd dummy_hcd.0: Dummy host controller
[   52.207382] dummy_hcd dummy_hcd.0: Dummy host controller
[   52.211786] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[   52.211786] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[   52.217491] hub 1-0:1.0: USB hub found
[   52.217491] hub 1-0:1.0: USB hub found
[   52.219242] hub 1-0:1.0: 1 port detected
[   52.219242] hub 1-0:1.0: 1 port detected
[   52.226623] userial_init: registered 4 ttyGS* devices
[   52.226623] userial_init: registered 4 ttyGS* devices
[   52.228405] udc dummy_udc.0: registering UDC driver [g_cdc]
[   52.228405] udc dummy_udc.0: registering UDC driver [g_cdc]
[   52.230511] using random self ethernet address
[   52.230511] using random self ethernet address
[   52.232281] using random host ethernet address
[   52.232281] using random host ethernet address
[   52.234728] g_cdc gadget: adding config #1 'CDC Composite (ECM + ACM)'/f=
fffffff83ed3500
[   52.234728] g_cdc gadget: adding config #1 'CDC Composite (ECM + ACM)'/f=
fffffff83ed3500
[   52.238318] g_cdc gadget: adding 'cdc_ethernet'/ffff88000a155800 to conf=
ig 'CDC Composite (ECM + ACM)'/ffffffff83ed3500
[   52.238318] g_cdc gadget: adding 'cdc_ethernet'/ffff88000a155800 to conf=
ig 'CDC Composite (ECM + ACM)'/ffffffff83ed3500
[   52.243594] usb0: HOST MAC b2:dc:87:ac:41:95
[   52.243594] usb0: HOST MAC b2:dc:87:ac:41:95
[   52.245588] usb0: MAC ba:37:2d:f5:aa:33
[   52.245588] usb0: MAC ba:37:2d:f5:aa:33
[   52.247171] g_cdc gadget: CDC Ethernet: super speed IN/ep1in-bulk OUT/ep=
2out-bulk NOTIFY/ep5in-int
[   52.247171] g_cdc gadget: CDC Ethernet: super speed IN/ep1in-bulk OUT/ep=
2out-bulk NOTIFY/ep5in-int
[   52.251213] g_cdc gadget: adding 'acm'/ffff88000a155a00 to config 'CDC C=
omposite (ECM + ACM)'/ffffffff83ed3500
[   52.251213] g_cdc gadget: adding 'acm'/ffff88000a155a00 to config 'CDC C=
omposite (ECM + ACM)'/ffffffff83ed3500
[   52.255455] g_cdc gadget: acm ttyGS0: super speed IN/ep6in-bulk OUT/ep7o=
ut-bulk NOTIFY/ep10in-int
[   52.255455] g_cdc gadget: acm ttyGS0: super speed IN/ep6in-bulk OUT/ep7o=
ut-bulk NOTIFY/ep10in-int
[   52.259172] g_cdc gadget: cfg 1/ffffffff83ed3500 speeds: super high full
[   52.259172] g_cdc gadget: cfg 1/ffffffff83ed3500 speeds: super high full
[   52.262224] g_cdc gadget:   interface 0 =3D cdc_ethernet/ffff88000a155800
[   52.262224] g_cdc gadget:   interface 0 =3D cdc_ethernet/ffff88000a155800
[   52.265139] g_cdc gadget:   interface 1 =3D cdc_ethernet/ffff88000a155800
[   52.265139] g_cdc gadget:   interface 1 =3D cdc_ethernet/ffff88000a155800
[   52.267971] g_cdc gadget:   interface 2 =3D acm/ffff88000a155a00
[   52.267971] g_cdc gadget:   interface 2 =3D acm/ffff88000a155a00
[   52.270084] g_cdc gadget:   interface 3 =3D acm/ffff88000a155a00
[   52.270084] g_cdc gadget:   interface 3 =3D acm/ffff88000a155a00
[   52.272497] g_cdc gadget: CDC Composite Gadget, version: King Kamehameha=
 Day 2008
[   52.272497] g_cdc gadget: CDC Composite Gadget, version: King Kamehameha=
 Day 2008
[   52.275236] g_cdc gadget: g_cdc ready
[   52.275236] g_cdc gadget: g_cdc ready
[   52.276525] dummy_udc dummy_udc.0: binding gadget driver 'g_cdc'
[   52.276525] dummy_udc dummy_udc.0: binding gadget driver 'g_cdc'
[   52.278689] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[   52.278689] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[   52.281252] usbip_core: USB/IP Core v1.0.0
[   52.281252] usbip_core: USB/IP Core v1.0.0
[   52.283764] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[   52.283764] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[   52.286094] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 2
[   52.286094] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 2
[   52.293328] hub 2-0:1.0: USB hub found
[   52.293328] hub 2-0:1.0: USB hub found
[   52.295000] hub 2-0:1.0: 8 ports detected
[   52.295000] hub 2-0:1.0: 8 ports detected
[   52.299943] vhci_hcd: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.=
0.0
[   52.299943] vhci_hcd: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.=
0.0
[   52.317178] usbcore: registered new device driver usbip-host
[   52.317178] usbcore: registered new device driver usbip-host
[   52.319348] usbip_host: USB/IP Host Driver v1.0.0
[   52.319348] usbip_host: USB/IP Host Driver v1.0.0
[   52.321693] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   52.321693] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   52.336735] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[   52.336735] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[   52.346643] serio: i8042 KBD port at 0x60,0x64 irq 1
[   52.346643] serio: i8042 KBD port at 0x60,0x64 irq 1
[   52.358222] serio: i8042 AUX port at 0x60,0x64 irq 12
[   52.358222] serio: i8042 AUX port at 0x60,0x64 irq 12
[   52.504204] g_cdc gadget: resume
[   52.504204] g_cdc gadget: resume
[   52.505702] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[   52.505702] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[   52.546430] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   52.546430] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   52.552347] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[   52.552347] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[   52.555303] cm109: Keymap for Komunikate KIP1000 phone loaded
[   52.555303] cm109: Keymap for Komunikate KIP1000 phone loaded
[   52.557873] usbcore: registered new interface driver cm109
[   52.557873] usbcore: registered new interface driver cm109
[   52.560173] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[   52.560173] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[   52.563213] usbcore: registered new interface driver ims_pcu
[   52.563213] usbcore: registered new interface driver ims_pcu
[   52.565253] usbcore: registered new interface driver keyspan_remote
[   52.565253] usbcore: registered new interface driver keyspan_remote
[   52.565965] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[   52.565965] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[   52.584137] usbcore: registered new interface driver powermate
[   52.584137] usbcore: registered new interface driver powermate
[   52.587210] usbcore: registered new interface driver yealink
[   52.587210] usbcore: registered new interface driver yealink
[   52.589609] i2c /dev entries driver
[   52.589609] i2c /dev entries driver
[   52.606236] usbcore: registered new interface driver i2c-diolan-u2c
[   52.606236] usbcore: registered new interface driver i2c-diolan-u2c
[   52.608772] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[   52.608772] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[   52.612351] usbcore: registered new interface driver i2c-tiny-usb
[   52.612351] usbcore: registered new interface driver i2c-tiny-usb
[   52.615309] pps_ldisc: PPS line discipline registered
[   52.615309] pps_ldisc: PPS line discipline registered
[   52.617472] Driver for 1-wire Dallas network protocol.
[   52.617472] Driver for 1-wire Dallas network protocol.
[   52.633154] usbcore: registered new interface driver DS9490R
[   52.633154] usbcore: registered new interface driver DS9490R
[   52.635543] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   52.635543] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   52.638582] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[   52.638582] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[   52.644085] g_cdc gadget: resume
[   52.644085] g_cdc gadget: resume
[   52.645227] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[   52.645227] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[   52.660289] applesmc: supported laptop not found!
[   52.660289] applesmc: supported laptop not found!
[   52.662181] applesmc: driver init failed (ret=3D-19)!
[   52.662181] applesmc: driver init failed (ret=3D-19)!
[   52.682811] f71882fg: Not a Fintek device
[   52.682811] f71882fg: Not a Fintek device
[   52.684485] f71882fg: Not a Fintek device
[   52.684485] f71882fg: Not a Fintek device
[   52.690795] pc87360: PC8736x not detected, module not inserted
[   52.690795] pc87360: PC8736x not detected, module not inserted
[   52.694311] Bluetooth: Virtual HCI driver ver 1.5
[   52.694311] Bluetooth: Virtual HCI driver ver 1.5
[   52.723918] usbcore: registered new interface driver bcm203x
[   52.723918] usbcore: registered new interface driver bcm203x
[   52.725659] dummy_udc dummy_udc.0: set_address =3D 2
[   52.725659] dummy_udc dummy_udc.0: set_address =3D 2
[   52.739859] usbcore: registered new interface driver bpa10x
[   52.739859] usbcore: registered new interface driver bpa10x
[   52.752223] usbcore: registered new interface driver bfusb
[   52.752223] usbcore: registered new interface driver bfusb
[   52.754797] usbcore: registered new interface driver btusb
[   52.754797] usbcore: registered new interface driver btusb
[   52.758657] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[   52.758657] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[   52.767884] usbcore: registered new interface driver ath3k
[   52.767884] usbcore: registered new interface driver ath3k
[   52.770612] sdhci: Secure Digital Host Controller Interface driver
[   52.770612] sdhci: Secure Digital Host Controller Interface driver
[   52.773499] sdhci: Copyright(c) Pierre Ossman
[   52.773499] sdhci: Copyright(c) Pierre Ossman
[   52.776415] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[   52.776415] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400

[   52.790740] usb 1-1: Dual-Role OTG device on HNP port
[   52.790740] usb 1-1: Dual-Role OTG device on HNP port
[   52.791466] usbcore: registered new interface driver vub300
[   52.791466] usbcore: registered new interface driver vub300
[   52.791759] sdhci-pltfm: SDHCI platform and OF driver helper
[   52.791759] sdhci-pltfm: SDHCI platform and OF driver helper
[   52.793526] ledtrig-cpu: registered to indicate activity on CPUs
[   52.793526] ledtrig-cpu: registered to indicate activity on CPUs
[   52.794734] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   52.794734] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   52.799605] usbcore: registered new interface driver usbkbd
[   52.799605] usbcore: registered new interface driver usbkbd
[   52.799890] dell_wmi: No known WMI GUID found
[   52.799890] dell_wmi: No known WMI GUID found
[   52.799903] dell_wmi_aio: No known WMI GUID found
[   52.799903] dell_wmi_aio: No known WMI GUID found
[   52.800132] Initializing HPQ6001 module
[   52.800132] Initializing HPQ6001 module
[   52.801761] FUJ02B1: call_fext_func: FUNC interface is not present
[   52.801761] FUJ02B1: call_fext_func: FUNC interface is not present
[   52.801765] fujitsu_laptop: driver 0.6.0 successfully loaded
[   52.801765] fujitsu_laptop: driver 0.6.0 successfully loaded
[   52.801924] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[   52.801924] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[   52.802918] intel_oaktrail: Platform not recognized (You could try the m=
odule's force-parameter)
[   52.802918] intel_oaktrail: Platform not recognized (You could try the m=
odule's force-parameter)
[   52.802919] hv_vmbus: registering driver hv_balloon
[   52.802919] hv_vmbus: registering driver hv_balloon
[   52.806498] intel_rapl: driver does not support CPU family 15 model 6
[   52.806498] intel_rapl: driver does not support CPU family 15 model 6
[   52.806518] oprofile: using NMI interrupt.
[   52.806518] oprofile: using NMI interrupt.
[   52.806662] NET: Registered protocol family 26
[   52.806662] NET: Registered protocol family 26
[   52.806822] NET: Registered protocol family 17
[   52.806822] NET: Registered protocol family 17
[   52.820482] NET: Registered protocol family 15
[   52.820482] NET: Registered protocol family 15
[   52.822285] NET: Registered protocol family 5
[   52.822285] NET: Registered protocol family 5
[   52.822374] can: controller area network core (rev 20120528 abi 9)
[   52.822374] can: controller area network core (rev 20120528 abi 9)
[   52.822451] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   52.822451] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   52.822457] NET: Registered protocol family 29
[   52.822457] NET: Registered protocol family 29
[   52.822476] can: raw protocol (rev 20120528)
[   52.822476] can: raw protocol (rev 20120528)
[   52.822583] can: netlink gateway (rev 20130117) max_hops=3D1
[   52.822583] can: netlink gateway (rev 20130117) max_hops=3D1
[   52.824781] IrCOMM protocol (Dag Brattli)
[   52.824781] IrCOMM protocol (Dag Brattli)
[   52.842312] Bluetooth: RFCOMM socket layer initialized
[   52.842312] Bluetooth: RFCOMM socket layer initialized
[   52.842372] Bluetooth: RFCOMM ver 1.11
[   52.842372] Bluetooth: RFCOMM ver 1.11
[   52.842411] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   52.842411] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   52.842415] Bluetooth: BNEP filters: protocol multicast
[   52.842415] Bluetooth: BNEP filters: protocol multicast
[   52.842423] Bluetooth: BNEP socket layer initialized
[   52.842423] Bluetooth: BNEP socket layer initialized
[   52.842433] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   52.842433] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   52.842440] Bluetooth: HIDP socket layer initialized
[   52.842440] Bluetooth: HIDP socket layer initialized
[   52.842517] lec:lane_module_init: lec.c: initialized
[   52.842517] lec:lane_module_init: lec.c: initialized
[   52.842530] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   52.842530] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   52.844708] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[   52.844708] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[   52.844800] NET: Registered protocol family 12
[   52.844800] NET: Registered protocol family 12
[   52.852523] NET: Registered protocol family 36
[   52.852523] NET: Registered protocol family 36
[   52.854504] batman_adv: B.A.T.M.A.N. advanced 2014.4.0 (compatibility ve=
rsion 15) loaded
[   52.854504] batman_adv: B.A.T.M.A.N. advanced 2014.4.0 (compatibility ve=
rsion 15) loaded
[   52.854517] openvswitch: Open vSwitch switching datapath
[   52.854517] openvswitch: Open vSwitch switching datapath
[   52.854836] mpls_gso: MPLS GSO support
[   52.854836] mpls_gso: MPLS GSO support
[   52.860369]=20
[   52.860369] printing PIC contents
[   52.860369]=20
[   52.860369] printing PIC contents
[   52.860384] ... PIC  IMR: ffff
[   52.860384] ... PIC  IMR: ffff
[   52.860394] ... PIC  IRR: 9013
[   52.860394] ... PIC  IRR: 9013
[   52.860410] ... PIC  ISR: 0000
[   52.860410] ... PIC  ISR: 0000
[   52.860421] ... PIC ELCR: 0c00
[   52.860421] ... PIC ELCR: 0c00
[   52.860434] printing local APIC contents on CPU#0/0:
[   52.860434] printing local APIC contents on CPU#0/0:
[   52.860446] ... APIC ID:      00000000 (0)
[   52.860446] ... APIC ID:      00000000 (0)
[   52.860453] ... APIC VERSION: 01050014
[   52.860453] ... APIC VERSION: 01050014
[   52.860461] ... APIC TASKPRI: 00000000 (00)
[   52.860461] ... APIC TASKPRI: 00000000 (00)
[   52.860468] ... APIC PROCPRI: 00000000
[   52.860468] ... APIC PROCPRI: 00000000
[   52.860475] ... APIC LDR: 01000000
[   52.860475] ... APIC LDR: 01000000
[   52.860482] ... APIC DFR: ffffffff
[   52.860482] ... APIC DFR: ffffffff
[   52.860489] ... APIC SPIV: 000001ff
[   52.860489] ... APIC SPIV: 000001ff
[   52.860491] ... APIC ISR field:
[   52.860491] ... APIC ISR field:
[   52.860545] 000000000000000000000000000000000000000000000000000000000000=
0000
[   52.860545] 000000000000000000000000000000000000000000000000000000000000=
0000
[   52.860547] ... APIC TMR field:
[   52.860547] ... APIC TMR field:
[   52.860623] 000000000e20000000000000000000000000000000000000000000000000=
0000
[   52.860623] 000000000e20000000000000000000000000000000000000000000000000=
0000
[   52.860625] ... APIC IRR field:
[   52.860625] ... APIC IRR field:
[   52.860678] 000000000000000000000000000000000000000000000000000000000000=
0000
[   52.860678] 000000000000000000000000000000000000000000000000000000000000=
0000
[   52.860689] ... APIC ESR: 00000000
[   52.860689] ... APIC ESR: 00000000
[   52.860700] ... APIC ICR: 000008fd
[   52.860700] ... APIC ICR: 000008fd
[   52.860703] ... APIC ICR2: 02000000
[   52.860703] ... APIC ICR2: 02000000
[   52.860710] ... APIC LVTT: 000000ef
[   52.860710] ... APIC LVTT: 000000ef
[   52.860717] ... APIC LVTPC: 00010000
[   52.860717] ... APIC LVTPC: 00010000
[   52.860724] ... APIC LVT0: 00010700
[   52.860724] ... APIC LVT0: 00010700
[   52.860731] ... APIC LVT1: 00000400
[   52.860731] ... APIC LVT1: 00000400
[   52.860738] ... APIC LVTERR: 000000fe
[   52.860738] ... APIC LVTERR: 000000fe
[   52.860745] ... APIC TMICT: 0000b89b
[   52.860745] ... APIC TMICT: 0000b89b
[   52.860752] ... APIC TMCCT: 00003e96
[   52.860752] ... APIC TMCCT: 00003e96
[   52.860759] ... APIC TDCR: 00000003
[   52.860759] ... APIC TDCR: 00000003
[   52.860761]=20
[   52.860761]=20
[   52.860766] number of MP IRQ sources: 15.
[   52.860766] number of MP IRQ sources: 15.
[   52.860770] number of IO-APIC #0 registers: 24.
[   52.860770] number of IO-APIC #0 registers: 24.
[   52.860773] testing the IO APIC.......................
[   52.860773] testing the IO APIC.......................
[   52.860804] IO APIC #0......
[   52.860804] IO APIC #0......
[   52.860807] .... register #00: 00000000
[   52.860807] .... register #00: 00000000
[   52.860810] .......    : physical APIC id: 00
[   52.860810] .......    : physical APIC id: 00
[   52.860813] .......    : Delivery Type: 0
[   52.860813] .......    : Delivery Type: 0
[   52.860816] .......    : LTS          : 0
[   52.860816] .......    : LTS          : 0
[   52.860819] .... register #01: 00170011
[   52.860819] .... register #01: 00170011
[   52.860822] .......     : max redirection entries: 17
[   52.860822] .......     : max redirection entries: 17
[   52.860825] .......     : PRQ implemented: 0
[   52.860825] .......     : PRQ implemented: 0
[   52.860828] .......     : IO APIC version: 11
[   52.860828] .......     : IO APIC version: 11
[   52.860831] .... register #02: 00000000
[   52.860831] .... register #02: 00000000
[   52.860834] .......     : arbitration: 00
[   52.860834] .......     : arbitration: 00
[   52.860837] .... IRQ redirection table:
[   52.860837] .... IRQ redirection table:
[   52.860860] 1    0    0   0   0    0    0    00
[   52.860860] 1    0    0   0   0    0    0    00
[   52.860881] 0    0    0   0   0    1    1    31
[   52.860881] 0    0    0   0   0    1    1    31
[   52.860902] 0    0    0   0   0    1    1    30
[   52.860902] 0    0    0   0   0    1    1    30
[   52.860925] 0    0    0   0   0    1    1    33
[   52.860925] 0    0    0   0   0    1    1    33
[   52.860946] 1    0    0   0   0    1    1    34
[   52.860946] 1    0    0   0   0    1    1    34
[   52.860968] 1    1    0   0   0    1    1    35
[   52.860968] 1    1    0   0   0    1    1    35
[   52.860988] 0    0    0   0   0    1    1    36
[   52.860988] 0    0    0   0   0    1    1    36
[   52.862248] 0    0    0   0   0    1    1    37
[   52.862248] 0    0    0   0   0    1    1    37
[   52.862274] 0    0    0   0   0    1    1    38
[   52.862274] 0    0    0   0   0    1    1    38
[   52.862297] 1    1    0   0   0    1    1    39
[   52.862297] 1    1    0   0   0    1    1    39
[   52.862319] 1    1    0   0   0    1    1    3A
[   52.862319] 1    1    0   0   0    1    1    3A
[   52.862343] 1    1    0   0   0    1    1    3B
[   52.862343] 1    1    0   0   0    1    1    3B
[   52.862367] 0    0    0   0   0    1    1    3C
[   52.862367] 0    0    0   0   0    1    1    3C
[   52.862390] 0    0    0   0   0    1    1    3D
[   52.862390] 0    0    0   0   0    1    1    3D
[   52.862414] 0    0    0   0   0    1    1    3E
[   52.862414] 0    0    0   0   0    1    1    3E
[   52.862436] 0    0    0   0   0    1    1    3F
[   52.862436] 0    0    0   0   0    1    1    3F
[   52.862457] 1    0    0   0   0    0    0    00
[   52.862457] 1    0    0   0   0    0    0    00
[   52.862480] 1    0    0   0   0    0    0    00
[   52.862480] 1    0    0   0   0    0    0    00
[   52.862501] 1    0    0   0   0    0    0    00
[   52.862501] 1    0    0   0   0    0    0    00
[   52.862522] 1    0    0   0   0    0    0    00
[   52.862522] 1    0    0   0   0    0    0    00
[   52.862543] 1    0    0   0   0    0    0    00
[   52.862543] 1    0    0   0   0    0    0    00
[   52.862586] 1    0    0   0   0    0    0    00
[   52.862586] 1    0    0   0   0    0    0    00
[   52.862608] 1    0    0   0   0    0    0    00
[   52.862608] 1    0    0   0   0    0    0    00
[   52.862630] 1    0    0   0   0    0    0    00
[   52.862630] 1    0    0   0   0    0    0    00
[   52.862633] IRQ to pin mappings:
[   52.862633] IRQ to pin mappings:
[   52.862644] IRQ0 -> 0:2
[   52.862644] IRQ0 -> 0:2
[   52.862651] IRQ1 -> 0:1
[   52.862651] IRQ1 -> 0:1
[   52.862659] IRQ3 -> 0:3
[   52.862659] IRQ3 -> 0:3
[   52.862667] IRQ4 -> 0:4
[   52.862667] IRQ4 -> 0:4
[   52.862675] IRQ5 -> 0:5
[   52.862675] IRQ5 -> 0:5
[   52.862682] IRQ6 -> 0:6
[   52.862682] IRQ6 -> 0:6
[   52.862690] IRQ7 -> 0:7
[   52.862690] IRQ7 -> 0:7
[   52.862697] IRQ8 -> 0:8
[   52.862697] IRQ8 -> 0:8
[   52.862705] IRQ9 -> 0:9
[   52.862705] IRQ9 -> 0:9
[   52.862713] IRQ10 -> 0:10
[   52.862713] IRQ10 -> 0:10
[   52.862722] IRQ11 -> 0:11
[   52.862722] IRQ11 -> 0:11
[   52.862731] IRQ12 -> 0:12
[   52.862731] IRQ12 -> 0:12
[   52.862739] IRQ13 -> 0:13
[   52.862739] IRQ13 -> 0:13
[   52.862746] IRQ14 -> 0:14
[   52.862746] IRQ14 -> 0:14
[   52.862754] IRQ15 -> 0:15
[   52.862754] IRQ15 -> 0:15
[   52.862757] .................................... done.
[   52.862757] .................................... done.
[   52.864660] bootconsole [earlyser0] disabled
[   52.864660] bootconsole [earlyser0] disabled
[   53.218713] Running ring buffer tests...
[   53.230363] usb 1-1: device v0525 pa4aa is not supported
[   53.231428] g_cdc gadget: suspend
[   53.232376] usb usb1-port1: unable to enumerate USB device
[   54.291991] hrtimer: interrupt took 2983858 ns
[   63.256702] finished
[   63.257990] CPU 0:
[   63.258649]               events:    88257
[   63.259976]        dropped bytes:    0
[   63.260949]        alloced bytes:    6787088
[   63.262479]        written bytes:    6656472
[   63.263553]        biggest event:    242
[   63.264591]       smallest event:    4
[   63.302799]          read events:   12726
[   63.303858]          lost events:   75531
[   63.304877]         total events:   88257
[   63.305901]   recorded len bytes:   974184
[   63.306937]  recorded size bytes:   955245
[   63.307976]  With dropped events, record len and size may not match
[   63.307976]  alloced and written from above
[   63.310624] CPU 1:
[   63.311272]               events:    52679
[   63.312344]        dropped bytes:    0
[   63.313318]        alloced bytes:    4112348
[   63.314380]        written bytes:    4034068
[   63.315447]        biggest event:    203
[   63.316465]       smallest event:    4
[   63.352936]          read events:   12405
[   63.353968]          lost events:   40274
[   63.354997]         total events:   52679
[   63.356002]   recorded len bytes:   975000
[   63.357245]  recorded size bytes:   956525
[   63.358296]  With dropped events, record len and size may not match
[   63.358296]  alloced and written from above
[   63.360707] Ring buffer PASSED!
[   63.366898] RIO: rio_register_scan for mport_id=3D-1
[   63.383953] register_blkdev: cannot get major 3 for hd
[   63.385739] console [netcon0] enabled
[   63.386718] netconsole: network logging started
[   63.387946] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   63.389544] EDD information not available.
[   63.404769] debug: unmapping init [mem 0xffffffff84905000-0xffffffff84bb=
3fff]
[   63.409279] Write protecting the kernel read-only data: 40960k
[   63.421670] debug: unmapping init [mem 0xffff880002779000-0xffff8800027f=
ffff]
[   63.423901] debug: unmapping init [mem 0xffff8800037f9000-0xffff8800037f=
ffff]
[   63.482962] random: init urandom read with 49 bits of entropy available
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   72.261776] rcu-torture: rtc: ffffffff8599d240 ver: 1 tfle: 0 rta: 1 rta=
f: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 =
-1,0:-1,0 0:0 (HZ=3D1000) barrier: 0/0:0
[   72.261776] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[   72.261776] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[   72.261776] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
mount: proc has wrong device number or fs type proc not supported
/etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
umount: /var/run: not mounted
umount: /var/lock: not mounted
umount: /dev/shm: not mounted
mount: / is busy
 * Will now restart
[  130.625037] Unregister pv shared memory for cpu 1
[  130.632993] Unregister pv shared memory for cpu 0
[  130.634409] rcu-torture: Unscheduled system shutdown detected
[  130.636175] torture thread rcu_torture_writer parking due to system shut=
down
[  130.637819] torture thread rcu_torture_fakewriter parking due to system =
shutdown
[  130.639599] torture thread rcu_torture_reader parking due to system shut=
down
[  130.640955] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  130.642393] torture thread rcu_torture_fakewriter parking due to system =
shutdown

BUG: kernel boot crashed
Elapsed time: 185
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsb0-10041007/598d570a05cd31500fb15a843a92f68ddb1b3618/vmlinuz-3.17.0-rc7-=
00003-g598d570a -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 deb=
ug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdi=
sk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnorma=
l  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig=
-hsb0-10041007/linux-devel:devel-hourly-2014100409:598d570a05cd31500fb15a84=
3a92f68ddb1b3618:bisect-linux-3/.vmlinuz-598d570a05cd31500fb15a843a92f68ddb=
1b3618-20141004115902-9-lkp-nex04 branch=3Dlinux-devel/devel-hourly-2014100=
409 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb0-10041007/598d570a05cd31500f=
b15a843a92f68ddb1b3618/vmlinuz-3.17.0-rc7-00003-g598d570a drbd.minor_count=
=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -=
net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-rebo=
ot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-qua=
ntal-lkp-nex04-179 -serial file:/dev/shm/kboot/serial-quantal-lkp-nex04-179=
 -daemonize -display none -monitor null=20

--uh9ZiVrAOUUm9fzH
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-hsb0-10041007-cd94c0185489f0cddcbfa80e86258bb4609b6e1d-double-fault:-ffff-34661.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgY2Q5NGMwMS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDEwMDQwOScKZ2l0IGNoZWNrb3V0IGZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEz
ODRjOTU4ZDVmNjc5NzlhZGIKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5
LTIwMTQxMDA0MDk6ZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3OWFkYjpi
aXNlY3QtbGludXgtMwoKMjAxNC0xMC0wNCAxMDoxOToxNCBmZTgyZGNlYzY0NDI0NDY3NmQ1
NWExMzg0Yzk1OGQ1ZjY3OTc5YWRiIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHNiMC0xMDA0MTAwNy9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5YWRi
L3ZtbGludXotMy4xNy4wLXJjNwoKMjAxNC0xMC0wNCAxMDoxOToxNCBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLi4JNDQJNzAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCBmZTgyZGNl
YzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5YWRiCmdpdCBiaXNlY3Qgc3RhcnQgY2Q5
NGMwMTg1NDg5ZjBjZGRjYmZhODBlODYyNThiYjQ2MDliNmUxZCBmZTgyZGNlYzY0NDI0NDY3
NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5YWRiIC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlz
ZWN0OiBbIi1iIiwgImNkOTRjMDE4NTQ4OWYwY2RkY2JmYTgwZTg2MjU4YmI0NjA5YjZlMWQi
LCAiLWciLCAiZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3OWFkYiIsICIv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9jL2Jvb3Qt
YmlzZWN0L2xpbnV4LTMvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogMzgzMyByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpClthM2Y4Zjg4N2Uy
YTM2MDAzMDI2YjVkM2VmZmRkNDE4ZDUwN2NmN2M4XSBNZXJnZSAnc3BpL2Zvci1saW51cycg
aW50byBkZXZlbC1ob3VybHktMjAxNDEwMDQwOQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMy9vYmot
YmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy1oc2IwLTEwMDQxMDA3L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MTAwNDA5
OmEzZjhmODg3ZTJhMzYwMDMwMjZiNWQzZWZmZGQ0MThkNTA3Y2Y3Yzg6YmlzZWN0LWxpbnV4
LTMKCjIwMTQtMTAtMDQgMTA6MjE6NDYgYTNmOGY4ODdlMmEzNjAwMzAyNmI1ZDNlZmZkZDQx
OGQ1MDdjZjdjOCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAw
Ny1hM2Y4Zjg4N2UyYTM2MDAzMDI2YjVkM2VmZmRkNDE4ZDUwN2NmN2M4CkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2EzZjhm
ODg3ZTJhMzYwMDMwMjZiNWQzZWZmZGQ0MThkNTA3Y2Y3YzgKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFu
ZGNvbmZpZy1oc2IwLTEwMDQxMDA3LWEzZjhmODg3ZTJhMzYwMDMwMjZiNWQzZWZmZGQ0MThk
NTA3Y2Y3YzgKG1sxOzM1bTIwMTQtMTAtMDQgMTE6MTI6NDYgTm8gYnVpbGQgc2VydmVkIGZp
bGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2XzY0LXJhbmRjb25maWctaHNiMC0x
MDA0MTAwNy1hM2Y4Zjg4N2UyYTM2MDAzMDI2YjVkM2VmZmRkNDE4ZDUwN2NmN2M4G1swbQpS
ZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvbGtwLWhzeDAyLXNtb2tlL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAw
NDEwMDctYTNmOGY4ODdlMmEzNjAwMzAyNmI1ZDNlZmZkZDQxOGQ1MDdjZjdjOAprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9hM2Y4Zjg4N2UyYTM2
MDAzMDI2YjVkM2VmZmRkNDE4ZDUwN2NmN2M4L3ZtbGludXotMy4xNy4wLXJjNy0wMjg4MC1n
YTNmOGY4OAoKMjAxNC0xMC0wNCAxMToxNzo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgk0
MAk3MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDk1MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpClsyZTZiMmVlNjg5M2RhOTllOWExNTYwODdh
ZWU5N2Y5MGIwYzg0MjljXSBNZXJnZSAndHJhY2UvZm9yLW5leHQnIGludG8gZGV2ZWwtaG91
cmx5LTIwMTQxMDA0MDkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTMvb2JqLWJpc2VjdApscyAtYSAv
a2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0
MTAwNy9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDEwMDQwOToyZTZiMmVlNjg5M2Rh
OTllOWExNTYwODdhZWU5N2Y5MGIwYzg0MjljOmJpc2VjdC1saW51eC0zCgoyMDE0LTEwLTA0
IDExOjE5OjQ3IDJlNmIyZWU2ODkzZGE5OWU5YTE1NjA4N2FlZTk3ZjkwYjBjODQyOWMgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
bGtwLWhzeDAyL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDctMmU2YjJlZTY4OTNk
YTk5ZTlhMTU2MDg3YWVlOTdmOTBiMGM4NDI5YwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy8yZTZiMmVlNjg5M2RhOTllOWEx
NTYwODdhZWU5N2Y5MGIwYzg0MjljCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDItc21va2UveDg2XzY0LXJhbmRjb25maWct
aHNiMC0xMDA0MTAwNy0yZTZiMmVlNjg5M2RhOTllOWExNTYwODdhZWU5N2Y5MGIwYzg0Mjlj
Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3LzJlNmIy
ZWU2ODkzZGE5OWU5YTE1NjA4N2FlZTk3ZjkwYjBjODQyOWMvdm1saW51ei0zLjE3LjAtcmM3
LTAzMjk4LWcyZTZiMmVlCgoyMDE0LTEwLTA0IDExOjIyOjQ3IGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4JMgkxMgk3MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDUzNSByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCls3ZWEzOGEzMDYxYWI4
MmRjZmI3MDVjM2YzNmY1NWRkZDhjMzUxYzgzXSBNZXJnZSAndXNiL3VzYi1uZXh0JyBpbnRv
IGRldmVsLWhvdXJseS0yMDE0MTAwNDA5CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0zL29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LWhzYjAtMTAwNDEwMDcvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQxMDA0MDk6N2Vh
MzhhMzA2MWFiODJkY2ZiNzA1YzNmMzZmNTVkZGQ4YzM1MWM4MzpiaXNlY3QtbGludXgtMwoK
MjAxNC0xMC0wNCAxMToyNjoxOCA3ZWEzOGEzMDYxYWI4MmRjZmI3MDVjM2YzNmY1NWRkZDhj
MzUxYzgzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3LTdl
YTM4YTMwNjFhYjgyZGNmYjcwNWMzZjM2ZjU1ZGRkOGMzNTFjODMKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvN2VhMzhhMzA2
MWFiODJkY2ZiNzA1YzNmMzZmNTVkZGQ4YzM1MWM4Mwp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyLXNtb2tlL3g4Nl82NC1y
YW5kY29uZmlnLWhzYjAtMTAwNDEwMDctN2VhMzhhMzA2MWFiODJkY2ZiNzA1YzNmMzZmNTVk
ZGQ4YzM1MWM4MwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0
MTAwNy83ZWEzOGEzMDYxYWI4MmRjZmI3MDVjM2YzNmY1NWRkZDhjMzUxYzgzL3ZtbGludXot
My4xNy4wLXJjNy0wMzc5MS1nN2VhMzhhMwoKMjAxNC0xMC0wNCAxMToyODoxOCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLi4uCTguCTcwIFNVQ0NFU1MKCkJpc2VjdGluZzogNDIgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpCls2ZDNhYzUx
ZTk2ODhiNWNjMmQ0YTYzYmE1ZjJlOWIwNTdkYjc1YWM4XSBNZXJnZSAnZHJpdmVyLWNvcmUv
ZHJpdmVyLWNvcmUtbmV4dCcgaW50byBkZXZlbC1ob3VybHktMjAxNDEwMDQwOQpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1i
aXNlY3QvbGludXgtMy9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2xpbnV4LWRldmVsOmRldmVs
LWhvdXJseS0yMDE0MTAwNDA5OjZkM2FjNTFlOTY4OGI1Y2MyZDRhNjNiYTVmMmU5YjA1N2Ri
NzVhYzg6YmlzZWN0LWxpbnV4LTMKCjIwMTQtMTAtMDQgMTE6MzE6NDggNmQzYWM1MWU5Njg4
YjVjYzJkNGE2M2JhNWYyZTliMDU3ZGI3NWFjOCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIveDg2XzY0LXJhbmRj
b25maWctaHNiMC0xMDA0MTAwNy02ZDNhYzUxZTk2ODhiNWNjMmQ0YTYzYmE1ZjJlOWIwNTdk
Yjc1YWM4CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c2IwLTEwMDQxMDA3LzZkM2FjNTFlOTY4OGI1Y2MyZDRhNjNiYTVmMmU5YjA1N2RiNzVhYzgK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xr
cC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3LTZkM2FjNTFlOTY4OGI1
Y2MyZDRhNjNiYTVmMmU5YjA1N2RiNzVhYzgKG1sxOzM1bTIwMTQtMTAtMDQgMTE6MzM6NDgg
Tm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2XzY0
LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy02ZDNhYzUxZTk2ODhiNWNjMmQ0YTYzYmE1ZjJl
OWIwNTdkYjc1YWM4G1swbQpSZXRyeSBidWlsZCAuLgprZXJuZWw6IC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy82ZDNhYzUxZTk2ODhiNWNjMmQ0YTYzYmE1ZjJl
OWIwNTdkYjc1YWM4L3ZtbGludXotMy4xNy4wLXJjNy0wMzgxMi1nNmQzYWM1MQoKMjAxNC0x
MC0wNCAxMTozNDo0OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAg
IDAuMTcwMDAwXSBrdm0tc3RlYWx0aW1lOiBjcHUgMSwgbXNyIDEyNTBkYTQwClsgICAgMC4x
Nzg4NjFdIGdjb3Y6IHZlcnNpb24gbWFnaWM6IDB4MzQzMDM5MmEKWyAgICAwLjE3ODg2MV0g
Z2NvdjogdmVyc2lvbiBtYWdpYzogMHgzNDMwMzkyYQpbICAgIDAuMTk4MDU3XSBkb3VibGUg
ZmF1bHQ6IGZmZmYgWyMxXSAKWyAgICAwLjE5ODA1N10gZG91YmxlIGZhdWx0OiBmZmZmIFsj
MV0gUFJFRU1QVCBQUkVFTVBUIFNNUCBTTVAgREVCVUdfUEFHRUFMTE9DREVCVUdfUEFHRUFM
TE9DCgpbICAgIDAuMTk5MDAwXSBDUFU6IDEgUElEOiAwIENvbW06IHN3YXBwZXIvMSBOb3Qg
dGFpbnRlZCAzLjE3LjAtcmM3LTAzODEyLWc2ZDNhYzUxICMxClsgICAgMC4xOTkwMDBdIENQ
VTogMSBQSUQ6IDAgQ29tbTogc3dhcHBlci8xIE5vdCB0YWludGVkIDMuMTcuMC1yYzctMDM4
MTItZzZkM2FjNTEgIzEKWyAgICAwLjE5OTAwMF0gdGFzazogZmZmZjg4MDAxMjFhZDUwMCB0
aTogZmZmZjg4MDAxMjM0YzAwMCB0YXNrLnRpOiBmZmZmODgwMDEyMzRjMDAwClsgICAgMC4x
OTkwMDBdIHRhc2s6IGZmZmY4ODAwMTIxYWQ1MDAgdGk6IGZmZmY4ODAwMTIzNGMwMDAgdGFz
ay50aTogZmZmZjg4MDAxMjM0YzAwMApbICAgIDAuMTk5MDAwXSBSSVA6IDAwMTA6WzxmZmZm
ZmZmZjgxMTcxOGU0Pl0gClsgICAgMC4xOTkwMDBdIFJJUDogMDAxMDpbPGZmZmZmZmZmODEx
NzE4ZTQ+XSAgWzxmZmZmZmZmZjgxMTcxOGU0Pl0gdHJhY2VfaGFyZGlycXNfb2ZmX2NhbGxl
cisweDE1LzB4MTBjCiBbPGZmZmZmZmZmODExNzE4ZTQ+XSB0cmFjZV9oYXJkaXJxc19vZmZf
Y2FsbGVyKzB4MTUvMHgxMGMKWyAgICAwLjE5OTAwMF0gUlNQOiAwMDAwOmZmZmY4ODAwMTI1
MDAwMDAgIEVGTEFHUzogMDAwMTAwMDYKWyAgICAwLjE5OTAwMF0gUlNQOiAwMDAwOmZmZmY4
ODAwMTI1MDAwMDAgIEVGTEFHUzogMDAwMTAwMDYKWyAgICAwLjE5OTAwMF0gUkFYOiAwMDAw
MDAwMDgyNzcwYjMwIFJCWDogMDAwMDAwMDAwMDAwMDAwMSBSQ1g6IGZmZmZmZmZmODI3NzBi
MzAKWyAgICAwLjE5OTAwMF0gUkFYOiAwMDAwMDAwMDgyNzcwYjMwIFJCWDogMDAwMDAwMDAw
MDAwMDAwMSBSQ1g6IGZmZmZmZmZmODI3NzBiMzAKWyAgICAwLjE5OTAwMF0gUkRYOiAwMDAw
MDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAwMSBSREk6IGZmZmZmZmZmODI3NzFl
NjYKWyAgICAwLjE5OTAwMF0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAw
MDAwMDAwMSBSREk6IGZmZmZmZmZmODI3NzFlNjYKWyAgICAwLjE5OTAwMF0gUkJQOiBmZmZm
ODgwMDEyNTAwMDEwIFIwODogMDAwMDAwMDAwMDAwMDA0YSBSMDk6IGZmZmZmZmZmODI4Mzg0
ODAKWyAgICAwLjE5OTAwMF0gUkJQOiBmZmZmODgwMDEyNTAwMDEwIFIwODogMDAwMDAwMDAw
MDAwMDA0YSBSMDk6IGZmZmZmZmZmODI4Mzg0ODAKWyAgICAwLjE5OTAwMF0gUjEwOiBmZmZm
ZmZmZjgyODM5YjAwIFIxMTogMDAwMDAwMDAwMDAwMDAzNSBSMTI6IGZmZmY4ODAwMTIzNWJm
YzAKWyAgICAwLjE5OTAwMF0gUjEwOiBmZmZmZmZmZjgyODM5YjAwIFIxMTogMDAwMDAwMDAw
MDAwMDAzNSBSMTI6IGZmZmY4ODAwMTIzNWJmYzAKWyAgICAwLjE5OTAwMF0gUjEzOiBmZmZm
ODgwMDEyMzViZmMwIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDAwMDAwMDAwMDAw
MDAKWyAgICAwLjE5OTAwMF0gUjEzOiBmZmZmODgwMDEyMzViZmMwIFIxNDogMDAwMDAwMDAw
MDAwMDAwMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjE5OTAwMF0gRlM6ICAwMDAw
MDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMTI1MDAwMDAoMDAwMCkga25sR1M6MDAw
MDAwMDAwMDAwMDAwMApbICAgIDAuMTk5MDAwXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAw
MCkgR1M6ZmZmZjg4MDAxMjUwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsg
ICAgMC4xOTkwMDBdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAw
ODAwNTAwM2IKWyAgICAwLjE5OTAwMF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENS
MDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDAuMTk5MDAwXSBDUjI6IGZmZmY4ODAwMTI0ZmZm
ZjggQ1IzOiAwMDAwMDAwMDAzODBiMDAwIENSNDogMDAwMDAwMDAwMDAwMDZhMApbICAgIDAu
MTk5MDAwXSBDUjI6IGZmZmY4ODAwMTI0ZmZmZjggQ1IzOiAwMDAwMDAwMDAzODBiMDAwIENS
NDogMDAwMDAwMDAwMDAwMDZhMApbICAgIDAuMTk5MDAwXSBTdGFjazoKWyAgICAwLjE5OTAw
MF0gU3RhY2s6ClsgICAgMC4xOTkwMDBdICAwMDAwMDAwMDAwMDAwMDAxClsgICAgMC4xOTkw
MDBdICAwMDAwMDAwMDAwMDAwMDAxIGZmZmY4ODAwMTIzNWJmYzAgZmZmZjg4MDAxMjM1YmZj
MCBmZmZmODgwMDEyNTAwMTMwIGZmZmY4ODAwMTI1MDAxMzAgZmZmZmZmZmY4MTgzNDkyYSBm
ZmZmZmZmZjgxODM0OTJhCgpbICAgIDAuMTk5MDAwXSAgMDAwMDAwMDAwMDAwMDAzNQpbICAg
IDAuMTk5MDAwXSAgMDAwMDAwMDAwMDAwMDAzNSBmZmZmZmZmZjgyODM5YjAwIGZmZmZmZmZm
ODI4MzliMDAgZmZmZmZmZmY4MjgzODQ4MCBmZmZmZmZmZjgyODM4NDgwIDAwMDAwMDAwMDAw
MDAwNGEgMDAwMDAwMDAwMDAwMDA0YQoKWyAgICAwLjE5OTAwMF0gIDAwMDAwMDAwODI3NzBi
MzAKWyAgICAwLjE5OTAwMF0gIDAwMDAwMDAwODI3NzBiMzAgZmZmZmZmZmY4Mjc3MGIzMCBm
ZmZmZmZmZjgyNzcwYjMwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAw
MDAwMDAwMDAwMDAxIDAwMDAwMDAwMDAwMDAwMDEKClsgICAgMC4xOTkwMDBdIENhbGwgVHJh
Y2U6ClsgICAgMC4xOTkwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4xOTkwMDBdICA8SVJRPiAK
WyAgICAwLjE5OTAwMF0gIDxJUlE+IAoKWyAgICAwLjE5OTAwMF0gClsgICAgMC4xOTkwMDBd
ICBbPGZmZmZmZmZmODE4MzQ5MmE+XSB0cmFjZV9oYXJkaXJxc19vZmZfdGh1bmsrMHgzYS8w
eDNjCiBbPGZmZmZmZmZmODE4MzQ5MmE+XSB0cmFjZV9oYXJkaXJxc19vZmZfdGh1bmsrMHgz
YS8weDNjClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzBiMzA+XSA/IGlycV9yZXR1
cm4rMHhjLzB4YwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcwYjMwPl0gPyBpcnFf
cmV0dXJuKzB4Yy8weGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8g
ZXJyb3Jfc3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5d
ID8gZXJyb3Jfc3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2
Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3
MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4
Mjc3MWJkZj5dID8gYXN5bmNfcGFnZV9mYXVsdCsweGYvMHgzMApbICAgIDAuMTk5MDAwXSAg
WzxmZmZmZmZmZjgyNzcxYmRmPl0gPyBhc3luY19wYWdlX2ZhdWx0KzB4Zi8weDMwClsgICAg
MC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzBiMzA+XSA/IGlycV9yZXR1cm4rMHhjLzB4Ywpb
ICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcwYjMwPl0gPyBpcnFfcmV0dXJuKzB4Yy8w
eGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4
NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3Rp
KzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4MTE3MThlND5dID8gdHJhY2Vf
aGFyZGlycXNfb2ZmX2NhbGxlcisweDE1LzB4MTBjClsgICAgMC4xOTkwMDBdICBbPGZmZmZm
ZmZmODExNzE4ZTQ+XSA/IHRyYWNlX2hhcmRpcnFzX29mZl9jYWxsZXIrMHgxNS8weDEwYwpb
ICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgxODM0OTJhPl0gdHJhY2VfaGFyZGlycXNfb2Zm
X3RodW5rKzB4M2EvMHgzYwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgxODM0OTJhPl0g
dHJhY2VfaGFyZGlycXNfb2ZmX3RodW5rKzB4M2EvMHgzYwpbICAgIDAuMTk5MDAwXSAgWzxm
ZmZmZmZmZjgyNzcwYjMwPl0gPyBpcnFfcmV0dXJuKzB4Yy8weGMKWyAgICAwLjE5OTAwMF0g
IFs8ZmZmZmZmZmY4Mjc3MGIzMD5dID8gaXJxX3JldHVybisweGMvMHhjClsgICAgMC4xOTkw
MDBdICBbPGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAgMC4x
OTkwMDBdICBbPGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAg
MC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2Clsg
ICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2
ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFiZGY+XSA/IGFzeW5jX3BhZ2VfZmF1
bHQrMHhmLzB4MzAKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWJkZj5dID8gYXN5
bmNfcGFnZV9mYXVsdCsweGYvMHgzMApbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcw
YjMwPl0gPyBpcnFfcmV0dXJuKzB4Yy8weGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4
Mjc3MGIzMD5dID8gaXJxX3JldHVybisweGMvMHhjClsgICAgMC4xOTkwMDBdICBbPGZmZmZm
ZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAgMC4xOTkwMDBdICBbPGZm
ZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAgMC4xOTkwMDBdICBb
PGZmZmZmZmZmODExNzE4ZTQ+XSA/IHRyYWNlX2hhcmRpcnFzX29mZl9jYWxsZXIrMHgxNS8w
eDEwYwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgxMTcxOGU0Pl0gPyB0cmFjZV9oYXJk
aXJxc19vZmZfY2FsbGVyKzB4MTUvMHgxMGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4
MTgzNDkyYT5dIHRyYWNlX2hhcmRpcnFzX29mZl90aHVuaysweDNhLzB4M2MKWyAgICAwLjE5
OTAwMF0gIFs8ZmZmZmZmZmY4MTgzNDkyYT5dIHRyYWNlX2hhcmRpcnFzX29mZl90aHVuaysw
eDNhLzB4M2MKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MGIzMD5dID8gaXJxX3Jl
dHVybisweGMvMHhjClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzBiMzA+XSA/IGly
cV9yZXR1cm4rMHhjLzB4YwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxZTY2Pl0g
PyBlcnJvcl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxZTY2
Pl0gPyBlcnJvcl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcx
ZTY2Pl0gPyBlcnJvcl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgy
NzcxZTY2Pl0gPyBlcnJvcl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZm
ZjgyNzcxYmRmPl0gPyBhc3luY19wYWdlX2ZhdWx0KzB4Zi8weDMwClsgICAgMC4xOTkwMDBd
ICBbPGZmZmZmZmZmODI3NzFiZGY+XSA/IGFzeW5jX3BhZ2VfZmF1bHQrMHhmLzB4MzAKWyAg
ICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MGIzMD5dID8gaXJxX3JldHVybisweGMvMHhj
ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzBiMzA+XSA/IGlycV9yZXR1cm4rMHhj
LzB4YwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxZTY2Pl0gPyBlcnJvcl9zdGkr
MHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxZTY2Pl0gPyBlcnJvcl9z
dGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgxMTcxOGU0Pl0gPyB0cmFj
ZV9oYXJkaXJxc19vZmZfY2FsbGVyKzB4MTUvMHgxMGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZm
ZmZmZmY4MTE3MThlND5dID8gdHJhY2VfaGFyZGlycXNfb2ZmX2NhbGxlcisweDE1LzB4MTBj
ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODE4MzQ5MmE+XSB0cmFjZV9oYXJkaXJxc19v
ZmZfdGh1bmsrMHgzYS8weDNjClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODE4MzQ5MmE+
XSB0cmFjZV9oYXJkaXJxc19vZmZfdGh1bmsrMHgzYS8weDNjClsgICAgMC4xOTkwMDBdICBb
PGZmZmZmZmZmODI3NzBiMzA+XSA/IGlycV9yZXR1cm4rMHhjLzB4YwpbICAgIDAuMTk5MDAw
XSAgWzxmZmZmZmZmZjgyNzcwYjMwPl0gPyBpcnFfcmV0dXJuKzB4Yy8weGMKWyAgICAwLjE5
OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYKWyAgICAw
LjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYKWyAg
ICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYK
WyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8w
eDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWJkZj5dID8gYXN5bmNfcGFnZV9m
YXVsdCsweGYvMHgzMApbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxYmRmPl0gPyBh
c3luY19wYWdlX2ZhdWx0KzB4Zi8weDMwClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3
NzBiMzA+XSA/IGlycV9yZXR1cm4rMHhjLzB4YwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZm
ZjgyNzcwYjMwPl0gPyBpcnFfcmV0dXJuKzB4Yy8weGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZm
ZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8
ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0g
IFs8ZmZmZmZmZmY4MTE3MThlND5dID8gdHJhY2VfaGFyZGlycXNfb2ZmX2NhbGxlcisweDE1
LzB4MTBjClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODExNzE4ZTQ+XSA/IHRyYWNlX2hh
cmRpcnFzX29mZl9jYWxsZXIrMHgxNS8weDEwYwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZm
ZjgxODM0OTJhPl0gdHJhY2VfaGFyZGlycXNfb2ZmX3RodW5rKzB4M2EvMHgzYwpbICAgIDAu
MTk5MDAwXSAgWzxmZmZmZmZmZjgxODM0OTJhPl0gdHJhY2VfaGFyZGlycXNfb2ZmX3RodW5r
KzB4M2EvMHgzYwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcwYjMwPl0gPyBpcnFf
cmV0dXJuKzB4Yy8weGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MGIzMD5dID8g
aXJxX3JldHVybisweGMvMHhjClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFlNjY+
XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFl
NjY+XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3
NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZm
ODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAgMC4xOTkwMDBdICBbPGZmZmZm
ZmZmODI3NzFiZGY+XSA/IGFzeW5jX3BhZ2VfZmF1bHQrMHhmLzB4MzAKWyAgICAwLjE5OTAw
MF0gIFs8ZmZmZmZmZmY4Mjc3MWJkZj5dID8gYXN5bmNfcGFnZV9mYXVsdCsweGYvMHgzMApb
ICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcwYjMwPl0gPyBpcnFfcmV0dXJuKzB4Yy8w
eGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MGIzMD5dID8gaXJxX3JldHVybisw
eGMvMHhjClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0
aSsweDUvMHg2ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9y
X3N0aSsweDUvMHg2ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODExNzE4ZTQ+XSA/IHRy
YWNlX2hhcmRpcnFzX29mZl9jYWxsZXIrMHgxNS8weDEwYwpbICAgIDAuMTk5MDAwXSAgWzxm
ZmZmZmZmZjgxMTcxOGU0Pl0gPyB0cmFjZV9oYXJkaXJxc19vZmZfY2FsbGVyKzB4MTUvMHgx
MGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4MTgzNDkyYT5dIHRyYWNlX2hhcmRpcnFz
X29mZl90aHVuaysweDNhLzB4M2MKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4MTgzNDky
YT5dIHRyYWNlX2hhcmRpcnFzX29mZl90aHVuaysweDNhLzB4M2MKWyAgICAwLjE5OTAwMF0g
IFs8ZmZmZmZmZmY4Mjc3MGIzMD5dID8gaXJxX3JldHVybisweGMvMHhjClsgICAgMC4xOTkw
MDBdICBbPGZmZmZmZmZmODI3NzBiMzA+XSA/IGlycV9yZXR1cm4rMHhjLzB4YwpbICAgIDAu
MTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxZTY2Pl0gPyBlcnJvcl9zdGkrMHg1LzB4NgpbICAg
IDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxZTY2Pl0gPyBlcnJvcl9zdGkrMHg1LzB4Ngpb
ICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxZTY2Pl0gPyBlcnJvcl9zdGkrMHg1LzB4
NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxZTY2Pl0gPyBlcnJvcl9zdGkrMHg1
LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxYmRmPl0gPyBhc3luY19wYWdl
X2ZhdWx0KzB4Zi8weDMwClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFiZGY+XSA/
IGFzeW5jX3BhZ2VfZmF1bHQrMHhmLzB4MzAKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4
Mjc3MGIzMD5dID8gaXJxX3JldHVybisweGMvMHhjClsgICAgMC4xOTkwMDBdICBbPGZmZmZm
ZmZmODI3NzBiMzA+XSA/IGlycV9yZXR1cm4rMHhjLzB4YwpbICAgIDAuMTk5MDAwXSAgWzxm
ZmZmZmZmZjgyNzcxZTY2Pl0gPyBlcnJvcl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAg
WzxmZmZmZmZmZjgyNzcxZTY2Pl0gPyBlcnJvcl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAw
XSAgWzxmZmZmZmZmZjgxMTcxOGU0Pl0gPyB0cmFjZV9oYXJkaXJxc19vZmZfY2FsbGVyKzB4
MTUvMHgxMGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4MTE3MThlND5dID8gdHJhY2Vf
aGFyZGlycXNfb2ZmX2NhbGxlcisweDE1LzB4MTBjClsgICAgMC4xOTkwMDBdICBbPGZmZmZm
ZmZmODE4MzQ5MmE+XSB0cmFjZV9oYXJkaXJxc19vZmZfdGh1bmsrMHgzYS8weDNjClsgICAg
MC4xOTkwMDBdICBbPGZmZmZmZmZmODE4MzQ5MmE+XSB0cmFjZV9oYXJkaXJxc19vZmZfdGh1
bmsrMHgzYS8weDNjClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzBiMzA+XSA/IGly
cV9yZXR1cm4rMHhjLzB4YwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcwYjMwPl0g
PyBpcnFfcmV0dXJuKzB4Yy8weGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2
Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3
MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4
Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZm
ZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZm
ZmZmZmY4Mjc3MWJkZj5dID8gYXN5bmNfcGFnZV9mYXVsdCsweGYvMHgzMApbICAgIDAuMTk5
MDAwXSAgWzxmZmZmZmZmZjgyNzcxYmRmPl0gPyBhc3luY19wYWdlX2ZhdWx0KzB4Zi8weDMw
ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzBiMzA+XSA/IGlycV9yZXR1cm4rMHhj
LzB4YwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcwYjMwPl0gPyBpcnFfcmV0dXJu
KzB4Yy8weGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jf
c3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJy
b3Jfc3RpKzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4MTE3MThlND5dID8g
dHJhY2VfaGFyZGlycXNfb2ZmX2NhbGxlcisweDE1LzB4MTBjClsgICAgMC4xOTkwMDBdICBb
PGZmZmZmZmZmODExNzE4ZTQ+XSA/IHRyYWNlX2hhcmRpcnFzX29mZl9jYWxsZXIrMHgxNS8w
eDEwYwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgxODM0OTJhPl0gdHJhY2VfaGFyZGly
cXNfb2ZmX3RodW5rKzB4M2EvMHgzYwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgxODM0
OTJhPl0gdHJhY2VfaGFyZGlycXNfb2ZmX3RodW5rKzB4M2EvMHgzYwpbICAgIDAuMTk5MDAw
XSAgWzxmZmZmZmZmZjgyNzcwYjMwPl0gPyBpcnFfcmV0dXJuKzB4Yy8weGMKWyAgICAwLjE5
OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MGIzMD5dID8gaXJxX3JldHVybisweGMvMHhjClsgICAg
MC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2Clsg
ICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2
ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUv
MHg2ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsw
eDUvMHg2ClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzFiZGY+XSA/IGFzeW5jX3Bh
Z2VfZmF1bHQrMHhmLzB4MzAKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWJkZj5d
ID8gYXN5bmNfcGFnZV9mYXVsdCsweGYvMHgzMApbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZm
ZjgyNzcwYjMwPl0gPyBpcnFfcmV0dXJuKzB4Yy8weGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZm
ZmZmZmY4Mjc3MGIzMD5dID8gaXJxX3JldHVybisweGMvMHhjClsgICAgMC4xOTkwMDBdICBb
PGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAgMC4xOTkwMDBd
ICBbPGZmZmZmZmZmODI3NzFlNjY+XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAgMC4xOTkw
MDBdICBbPGZmZmZmZmZmODExNzE4ZTQ+XSA/IHRyYWNlX2hhcmRpcnFzX29mZl9jYWxsZXIr
MHgxNS8weDEwYwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgxMTcxOGU0Pl0gPyB0cmFj
ZV9oYXJkaXJxc19vZmZfY2FsbGVyKzB4MTUvMHgxMGMKWyAgICAwLjE5OTAwMF0gIFs8ZmZm
ZmZmZmY4MTgzNDkyYT5dIHRyYWNlX2hhcmRpcnFzX29mZl90aHVuaysweDNhLzB4M2MKWyAg
ICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4MTgzNDkyYT5dIHRyYWNlX2hhcmRpcnFzX29mZl90
aHVuaysweDNhLzB4M2MKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MGIzMD5dID8g
aXJxX3JldHVybisweGMvMHhjClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzBiMzA+
XSA/IGlycV9yZXR1cm4rMHhjLzB4YwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcx
ZTY2Pl0gPyBlcnJvcl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgy
NzcxZTY2Pl0gPyBlcnJvcl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZm
ZjgyNzcxZTY2Pl0gPyBlcnJvcl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZm
ZmZmZjgyNzcxZTY2Pl0gPyBlcnJvcl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxm
ZmZmZmZmZjgyNzcxYmRmPl0gPyBhc3luY19wYWdlX2ZhdWx0KzB4Zi8weDMwClsgICAgMC4x
OTkwMDBdICBbPGZmZmZmZmZmODI3NzFiZGY+XSA/IGFzeW5jX3BhZ2VfZmF1bHQrMHhmLzB4
MzAKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MGIzMD5dID8gaXJxX3JldHVybisw
eGMvMHhjClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODI3NzBiMzA+XSA/IGlycV9yZXR1
cm4rMHhjLzB4YwpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxZTY2Pl0gPyBlcnJv
cl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcxZTY2Pl0gPyBl
cnJvcl9zdGkrMHg1LzB4NgpbICAgIDAuMTk5MDAwXSAgWzxmZmZmZmZmZjgxMTcxOGU0Pl0g
PyB0cmFjZV9oYXJkaXJxc19vZmZfY2FsbGVyKzB4MTUvMHgxMGMKWyAgICAwLjE5OTAwMF0g
IFs8ZmZmZmZmZmY4MTE3MThlND5dID8gdHJhY2VfaGFyZGlycXNfb2ZmX2NhbGxlcisweDE1
LzB4MTBjClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODE4MzQ5MmE+XSB0cmFjZV9oYXJk
aXJxc19vZmZfdGh1bmsrMHgzYS8weDNjClsgICAgMC4xOTkwMDBdICBbPGZmZmZmZmZmODE4
MzQ5MmE+XSB0cmFjZV9oYXJkaXJxc19vZmZfdGh1bmsrMHgzYS8weDNjClsgICAgMC4xOTkw
MDBdICBbPGZmZmZmZmZmODI3NzBiMzA+XSA/IGlycV9yZXR1cm4rMHhjLzB4YwpbICAgIDAu
MTk5MDAwXSAgWzxmZmZmZmZmZjgyNzcwYjMwPl0gPyBpcnFfcmV0dXJuKzB4Yy8weGMKWyAg
ICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8weDYK
WyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4NS8w
eDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3RpKzB4
NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWU2Nj5dID8gZXJyb3Jfc3Rp
KzB4NS8weDYKWyAgICAwLjE5OTAwMF0gIFs8ZmZmZmZmZmY4Mjc3MWJkZj5dID8gYXN5bmNf
cGFnZV9mYXVsdCsweGYvMHgzMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAw
NDEwMDcvNmQzYWM1MWU5Njg4YjVjYzJkNGE2M2JhNWYyZTliMDU3ZGI3NWFjOC9kbWVzZy1x
dWFudGFsLWxrcC1uZXgwNC0xOTI6MjAxNDEwMDQxMTM0NDg6eDg2XzY0LXJhbmRjb25maWct
aHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAw
Ny82ZDNhYzUxZTk2ODhiNWNjMmQ0YTYzYmE1ZjJlOWIwNTdkYjc1YWM4L2RtZXNnLXF1YW50
YWwtbGtwLW5leDA0LTU2OjIwMTQxMDA0MTEzNDQ4Ong4Nl82NC1yYW5kY29uZmlnLWhzYjAt
MTAwNDEwMDc6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvNmQz
YWM1MWU5Njg4YjVjYzJkNGE2M2JhNWYyZTliMDU3ZGI3NWFjOC9kbWVzZy1xdWFudGFsLWxr
cC1uZXgwNC0xMTI6MjAxNDEwMDQxMTM1MDA6eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0
MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy82ZDNhYzUx
ZTk2ODhiNWNjMmQ0YTYzYmE1ZjJlOWIwNTdkYjc1YWM4L2RtZXNnLXF1YW50YWwtbGtwLW5l
eDA0LTExNzoyMDE0MTAwNDExMzQ1ODp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3LzZkM2FjNTFlOTY4
OGI1Y2MyZDRhNjNiYTVmMmU5YjA1N2RiNzVhYzgvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQt
MTQ3OjIwMTQxMDA0MTEzNDUzOng4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvNmQzYWM1MWU5Njg4YjVj
YzJkNGE2M2JhNWYyZTliMDU3ZGI3NWFjOC9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0xNTY6
MjAxNDEwMDQxMTM0NTI6eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy82ZDNhYzUxZTk2ODhiNWNjMmQ0
YTYzYmE1ZjJlOWIwNTdkYjc1YWM4L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTE1NzoyMDE0
MTAwNDExMzQ1Nzp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3LzZkM2FjNTFlOTY4OGI1Y2MyZDRhNjNi
YTVmMmU5YjA1N2RiNzVhYzgvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTYzOjIwMTQxMDA0
MTEzNDU0Ong4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvNmQzYWM1MWU5Njg4YjVjYzJkNGE2M2JhNWYy
ZTliMDU3ZGI3NWFjOC9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0xNzA6MjAxNDEwMDQxMTM0
NTk6eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHNiMC0xMDA0MTAwNy82ZDNhYzUxZTk2ODhiNWNjMmQ0YTYzYmE1ZjJlOWIw
NTdkYjc1YWM4L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTIyOjIwMTQxMDA0MTEzNDU3Ong4
Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzYjAtMTAwNDEwMDcvNmQzYWM1MWU5Njg4YjVjYzJkNGE2M2JhNWYyZTliMDU3ZGI3
NWFjOC9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0yOjIwMTQxMDA0MTEzNDU4Ong4Nl82NC1y
YW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjAtMTAwNDEwMDcvNmQzYWM1MWU5Njg4YjVjYzJkNGE2M2JhNWYyZTliMDU3ZGI3NWFjOC9k
bWVzZy1xdWFudGFsLWxrcC1uZXgwNC0zMToyMDE0MTAwNDExMzQ1ODp4ODZfNjQtcmFuZGNv
bmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEw
MDQxMDA3LzZkM2FjNTFlOTY4OGI1Y2MyZDRhNjNiYTVmMmU5YjA1N2RiNzVhYzgvZG1lc2ct
cXVhbnRhbC1sa3AtbmV4MDQtMzg6MjAxNDEwMDQxMTM0NTM6eDg2XzY0LXJhbmRjb25maWct
aHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAw
Ny82ZDNhYzUxZTk2ODhiNWNjMmQ0YTYzYmE1ZjJlOWIwNTdkYjc1YWM4L2RtZXNnLXF1YW50
YWwtbGtwLW5leDA0LTY0OjIwMTQxMDA0MTEzNDUzOng4Nl82NC1yYW5kY29uZmlnLWhzYjAt
MTAwNDEwMDc6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvNmQz
YWM1MWU5Njg4YjVjYzJkNGE2M2JhNWYyZTliMDU3ZGI3NWFjOC9kbWVzZy1xdWFudGFsLWxr
cC1uZXgwNC04MDoyMDE0MTAwNDExMzQ1OTp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQx
MDA3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3LzZkM2FjNTFl
OTY4OGI1Y2MyZDRhNjNiYTVmMmU5YjA1N2RiNzVhYzgvZG1lc2ctcXVhbnRhbC1sa3AtbmV4
MDQtOTQ6MjAxNDEwMDQxMTM0NTk6eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy82ZDNhYzUxZTk2ODhi
NWNjMmQ0YTYzYmE1ZjJlOWIwNTdkYjc1YWM4L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTEw
MToyMDE0MTAwNDExMzUwMDp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3LzZkM2FjNTFlOTY4OGI1Y2My
ZDRhNjNiYTVmMmU5YjA1N2RiNzVhYzgvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTQ2OjIw
MTQxMDA0MTEzNTAxOng4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvNmQzYWM1MWU5Njg4YjVjYzJkNGE2
M2JhNWYyZTliMDU3ZGI3NWFjOC9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0xOTE6MjAxNDEw
MDQxMTM1MDE6eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy82ZDNhYzUxZTk2ODhiNWNjMmQ0YTYzYmE1
ZjJlOWIwNTdkYjc1YWM4L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTEwNDoyMDE0MTAwNDEx
MzUwNTp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3LzZkM2FjNTFlOTY4OGI1Y2MyZDRhNjNiYTVmMmU5
YjA1N2RiNzVhYzgvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTE2OjIwMTQxMDA0MTEzNTA2
Ong4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6Ogova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzYjAtMTAwNDEwMDcvNmQzYWM1MWU5Njg4YjVjYzJkNGE2M2JhNWYyZTliMDU3
ZGI3NWFjOC9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC02ODoyMDE0MTAwNDExMzUwNDp4ODZf
NjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc2IwLTEwMDQxMDA3LzZkM2FjNTFlOTY4OGI1Y2MyZDRhNjNiYTVmMmU5YjA1N2RiNzVh
YzgvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtNzY6MjAxNDEwMDQxMTM1MDQ6eDg2XzY0LXJh
bmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNi
MC0xMDA0MTAwNy82ZDNhYzUxZTk2ODhiNWNjMmQ0YTYzYmE1ZjJlOWIwNTdkYjc1YWM4L2Rt
ZXNnLXF1YW50YWwtbGtwLW5leDA0LTk1OjIwMTQxMDA0MTEzNTA2Ong4Nl82NC1yYW5kY29u
ZmlnLWhzYjAtMTAwNDEwMDc6OgowOjI0OjI0IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
CgpCaXNlY3Rpbmc6IDIxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA1IHN0ZXBzKQpbYTMzZGIzMGJiMmY0ZDUzZjMyNWUxYzQ2NWY1OTQ4OTRmNTU5ODQz
Y10gTWVyZ2UgJ2FrL3g4Ni9mc2dzLTInIGludG8gZGV2ZWwtaG91cmx5LTIwMTQxMDA0MDkK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4LTMvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9saW51eC1kZXZl
bDpkZXZlbC1ob3VybHktMjAxNDEwMDQwOTphMzNkYjMwYmIyZjRkNTNmMzI1ZTFjNDY1ZjU5
NDg5NGY1NTk4NDNjOmJpc2VjdC1saW51eC0zCgoyMDE0LTEwLTA0IDExOjM1OjQzIGEzM2Ri
MzBiYjJmNGQ1M2YzMjVlMWM0NjVmNTk0ODk0ZjU1OTg0M2MgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82
NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDctYTMzZGIzMGJiMmY0ZDUzZjMyNWUxYzQ2NWY1
OTQ4OTRmNTU5ODQzYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHNiMC0xMDA0MTAwNy9hMzNkYjMwYmIyZjRkNTNmMzI1ZTFjNDY1ZjU5NDg5NGY1
NTk4NDNjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9sa3AtaHN4MDIveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy1hMzNkYjMw
YmIyZjRkNTNmMzI1ZTFjNDY1ZjU5NDg5NGY1NTk4NDNjChtbMTszNW0yMDE0LTEwLTA0IDEx
OjM3OjQ0IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVk
L3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDctYTMzZGIzMGJiMmY0ZDUzZjMyNWUx
YzQ2NWY1OTQ4OTRmNTU5ODQzYxtbMG0KUmV0cnkgYnVpbGQgLi4Ka2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvYTMzZGIzMGJiMmY0ZDUzZjMyNWUx
YzQ2NWY1OTQ4OTRmNTU5ODQzYy92bWxpbnV6LTMuMTcuMC1yYzctMDM3OTktZ2EzM2RiMzAK
CjIwMTQtMTAtMDQgMTE6Mzk6MDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxV
UkUKWyAgICAwLjE5MzI2NF0gcmVndWxhdG9yLWR1bW15OiBubyBwYXJhbWV0ZXJzClsgICAg
MC4xOTY0MDFdIE5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMTYKWyAgICAwLjE5
NjQwMV0gTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxNgpbICAgIDAuMjA5MDUw
XSBkb3VibGUgZmF1bHQ6IGZmZmYgWyMxXSAKWyAgICAwLjIwOTA1MF0gZG91YmxlIGZhdWx0
OiBmZmZmIFsjMV0gUFJFRU1QVCBQUkVFTVBUIFNNUCBTTVAgREVCVUdfUEFHRUFMTE9DREVC
VUdfUEFHRUFMTE9DCgpbICAgIDAuMjEwMDAwXSBDUFU6IDEgUElEOiAwIENvbW06IHN3YXBw
ZXIvMSBOb3QgdGFpbnRlZCAzLjE3LjAtcmM3LTAzNzk5LWdhMzNkYjMwICMxClsgICAgMC4y
MTAwMDBdIENQVTogMSBQSUQ6IDAgQ29tbTogc3dhcHBlci8xIE5vdCB0YWludGVkIDMuMTcu
MC1yYzctMDM3OTktZ2EzM2RiMzAgIzEKWyAgICAwLjIxMDAwMF0gdGFzazogZmZmZjg4MDAx
MjFhZDUwMCB0aTogZmZmZjg4MDAxMjM0YzAwMCB0YXNrLnRpOiBmZmZmODgwMDEyMzRjMDAw
ClsgICAgMC4yMTAwMDBdIHRhc2s6IGZmZmY4ODAwMTIxYWQ1MDAgdGk6IGZmZmY4ODAwMTIz
NGMwMDAgdGFzay50aTogZmZmZjg4MDAxMjM0YzAwMApbICAgIDAuMjEwMDAwXSBSSVA6IDAw
MTA6WzxmZmZmZmZmZjgxODM0OTI1Pl0gClsgICAgMC4yMTAwMDBdIFJJUDogMDAxMDpbPGZm
ZmZmZmZmODE4MzQ5MjU+XSAgWzxmZmZmZmZmZjgxODM0OTI1Pl0gdHJhY2VfaGFyZGlycXNf
b2ZmX3RodW5rKzB4MzUvMHgzYwogWzxmZmZmZmZmZjgxODM0OTI1Pl0gdHJhY2VfaGFyZGly
cXNfb2ZmX3RodW5rKzB4MzUvMHgzYwpbICAgIDAuMjEwMDAwXSBSU1A6IDAwMDA6ZmZmZjg4
MDAxMjUwMDAwMCAgRUZMQUdTOiAwMDAxMDA4NgpbICAgIDAuMjEwMDAwXSBSU1A6IDAwMDA6
ZmZmZjg4MDAxMjUwMDAwMCAgRUZMQUdTOiAwMDAxMDA4NgpbICAgIDAuMjEwMDAwXSBSQVg6
IDAwMDAwMDAwODI3NzBhNzAgUkJYOiAwMDAwMDAwMDAwMDAwMDAxIFJDWDogZmZmZmZmZmY4
Mjc3MGE3MApbICAgIDAuMjEwMDAwXSBSQVg6IDAwMDAwMDAwODI3NzBhNzAgUkJYOiAwMDAw
MDAwMDAwMDAwMDAxIFJDWDogZmZmZmZmZmY4Mjc3MGE3MApbICAgIDAuMjEwMDAwXSBSRFg6
IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAwMDAxIFJESTogZmZmZmZmZmY4
Mjc3MWRhNgpbICAgIDAuMjEwMDAwXSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAwMDAw
MDAwMDAwMDAwMDAxIFJESTogZmZmZmZmZmY4Mjc3MWRhNgpbICAgIDAuMjEwMDAwXSBSQlA6
IGZmZmY4ODAwMTI1MDAxMTAgUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTogMDAwMDAwMDAw
MDAwMDAwMQpbICAgIDAuMjEwMDAwXSBSQlA6IGZmZmY4ODAwMTI1MDAxMTAgUjA4OiAwMDAw
MDAwMDAwMDAwMDAwIFIwOTogMDAwMDAwMDAwMDAwMDAwMQpbICAgIDAuMjEwMDAwXSBSMTA6
IGZmZmY4ODAwMTI1MDNlOTggUjExOiBmZmZmZmZmZjgzOGM3ZmYwIFIxMjogMDAwMDAwMDAw
MDAxM2VjMApbICAgIDAuMjEwMDAwXSBSMTA6IGZmZmY4ODAwMTI1MDNlOTggUjExOiBmZmZm
ZmZmZjgzOGM3ZmYwIFIxMjogMDAwMDAwMDAwMDAxM2VjMApbICAgIDAuMjEwMDAwXSBSMTM6
IDAwMDAwMDAwMDAwMTNlYzAgUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAw
MDAwMDAwMApbICAgIDAuMjEwMDAwXSBSMTM6IDAwMDAwMDAwMDAwMTNlYzAgUjE0OiAwMDAw
MDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMjEwMDAwXSBCVUc6
IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIApbICAgIDAuMjEwMDAwXSBCVUc6IHVuYWJsZSB0
byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0cGFnaW5nIHJlcXVlc3QgYXQgZmZmZmZm
ZmY4NGJkYjE0MAogYXQgZmZmZmZmZmY4NGJkYjE0MApbICAgIDAuMjEwMDAwXSBJUDoKWyAg
ICAwLjIxMDAwMF0gSVA6IFs8ZmZmZmZmZmY4MTAyM2ViMD5dIG9vcHNfYmVnaW4rMHgxLzB4
MjU2CiBbPGZmZmZmZmZmODEwMjNlYjA+XSBvb3BzX2JlZ2luKzB4MS8weDI1NgpbICAgIDAu
MjEwMDAwXSBQR0QgMzgwZTA2NyAKWyAgICAwLjIxMDAwMF0gUEdEIDM4MGUwNjcgUFVEIDM4
MGYwNjMgUFVEIDM4MGYwNjMgUE1EIDEyMTIxMDYzIFBNRCAxMjEyMTA2MyBQVEUgNmJQVEUg
NmIKClsgICAgMC4yMTAwMDBdIFRocmVhZCBvdmVycmFuIHN0YWNrLCBvciBzdGFjayBjb3Jy
dXB0ZWQKWyAgICAwLjIxMDAwMF0gVGhyZWFkIG92ZXJyYW4gc3RhY2ssIG9yIHN0YWNrIGNv
cnJ1cHRlZApbICAgIDAuMjEwMDAwXSBPb3BzOiAwMDAzIFsjODg5XSAKWyAgICAwLjIxMDAw
MF0gT29wczogMDAwMyBbIzg4OV0gUFJFRU1QVCBQUkVFTVBUIFNNUCBTTVAgREVCVUdfUEFH
RUFMTE9DREVCVUdfUEFHRUFMTE9DCgpbICAgIDAuMjEwMDAwXSB0YXNrOiBmZmZmODgwMDEy
MWFkNTAwIHRpOiBmZmZmODgwMDEyMzRjMDAwIHRhc2sudGk6IGZmZmY4ODAwMTIxYWQ2MTgK
WyAgICAwLjIxMDAwMF0gdGFzazogZmZmZjg4MDAxMjFhZDUwMCB0aTogZmZmZjg4MDAxMjM0
YzAwMCB0YXNrLnRpOiBmZmZmODgwMDEyMWFkNjE4ClsgICAgMC4yMTAwMDBdIEJVRzogdW5h
YmxlIHRvIGhhbmRsZSBrZXJuZWwgClsgICAgMC4yMTAwMDBdIEJVRzogdW5hYmxlIHRvIGhh
bmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3RwYWdpbmcgcmVxdWVzdCBhdCBmZmZmZmZmZjg0
YmQ2M2MwCiBhdCBmZmZmZmZmZjg0YmQ2M2MwClsgICAgMC4yMTAwMDBdIElQOgpbICAgIDAu
MjEwMDAwXSBJUDogWzxmZmZmZmZmZjgxMDFhYTc1Pl0gX19zaG93X3JlZ3MrMHgzMS8weDNj
MAogWzxmZmZmZmZmZjgxMDFhYTc1Pl0gX19zaG93X3JlZ3MrMHgzMS8weDNjMApbICAgIDAu
MjEwMDAwXSBQR0QgMzgwZTA2NyAKWyAgICAwLjIxMDAwMF0gUEdEIDM4MGUwNjcgUFVEIDM4
MGYwNjMgUFVEIDM4MGYwNjMgUE1EIDEyMTIxMDYzIFBNRCAxMjEyMTA2MyBQVEUgZmZmZmZm
ZmY4MTA3MmM1ZFBURSBmZmZmZmZmZjgxMDcyYzVkCgpbICAgIDAuMjEwMDAwXSBUaHJlYWQg
b3ZlcnJhbiBzdGFjaywgb3Igc3RhY2sgY29ycnVwdGVkClsgICAgMC4yMTAwMDBdIFRocmVh
ZCBvdmVycmFuIHN0YWNrLCBvciBzdGFjayBjb3JydXB0ZWQKWyAgICAwLjIxMDAwMF0gT29w
czogMDAwYiBbIzg5MF0gClsgICAgMC4yMTAwMDBdIE9vcHM6IDAwMGIgWyM4OTBdIFBSRUVN
UFQgUFJFRU1QVCBTTVAgU01QIERFQlVHX1BBR0VBTExPQ0RFQlVHX1BBR0VBTExPQwoKWyAg
ICAwLjIxMDAwMF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCAKWyAgICAwLjIxMDAw
MF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdHBhZ2luZyBy
ZXF1ZXN0IGF0IGZmZmZmZmZmODRiZGIxNDAKIGF0IGZmZmZmZmZmODRiZGIxNDAKWyAgICAw
LjIxMDAwMF0gSVA6ClsgICAgMC4yMTAwMDBdIElQOiBbPGZmZmZmZmZmODEwMjNlYjA+XSBv
b3BzX2JlZ2luKzB4MS8weDI1NgogWzxmZmZmZmZmZjgxMDIzZWIwPl0gb29wc19iZWdpbisw
eDEvMHgyNTYKWyAgICAwLjIxMDAwMF0gUEdEIDM4MGUwNjcgClsgICAgMC4yMTAwMDBdIFBH
RCAzODBlMDY3IFBVRCAzODBmMDYzIFBVRCAzODBmMDYzIFBNRCAxMjEyMTA2MyBQTUQgMTIx
MjEwNjMgUFRFIDFQVEUgMQoKWyAgICAwLjIxMDAwMF0gVGhyZWFkIG92ZXJyYW4gc3RhY2ss
IG9yIHN0YWNrIGNvcnJ1cHRlZApbICAgIDAuMjEwMDAwXSBUaHJlYWQgb3ZlcnJhbiBzdGFj
aywgb3Igc3RhY2sgY29ycnVwdGVkClsgICAgMC4yMTAwMDBdIE9vcHM6IDAwMDMgWyM4OTFd
IApbICAgIDAuMjEwMDAwXSBPb3BzOiAwMDAzIFsjODkxXSBQUkVFTVBUIFBSRUVNUFQgU01Q
IFNNUCBERUJVR19QQUdFQUxMT0NERUJVR19QQUdFQUxMT0MKClsgICAgMC4yMTAwMDBdIHRh
c2s6IGZmZmY4ODAwMTIxYWQ1MDAgdGk6IGZmZmY4ODAwMTIzNGMwMDAgdGFzay50aTogZmZm
Zjg4MDAxMjFhZDYxOApbICAgIDAuMjEwMDAwXSB0YXNrOiBmZmZmODgwMDEyMWFkNTAwIHRp
OiBmZmZmODgwMDEyMzRjMDAwIHRhc2sudGk6IGZmZmY4ODAwMTIxYWQ2MTgKWyAgICAwLjIx
MDAwMF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCAKWyAgICAwLjIxMDAwMF0gQlVH
OiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdHBhZ2luZyByZXF1ZXN0
IGF0IGZmZmZmZmZmODRiZDYzYzAKIGF0IGZmZmZmZmZmODRiZDYzYzAKWyAgICAwLjIxMDAw
MF0gSVA6ClsgICAgMC4yMTAwMDBdIElQOiBbPGZmZmZmZmZmODEwMWFhNzU+XSBfX3Nob3df
cmVncysweDMxLzB4M2MwCiBbPGZmZmZmZmZmODEwMWFhNzU+XSBfX3Nob3dfcmVncysweDMx
LzB4M2MwClsgICAgMC4yMTAwMDBdIFBHRCAzODBlMDY3IApbICAgIDAuMjEwMDAwXSBQR0Qg
MzgwZTA2NyBQVUQgMzgwZjA2MyBQVUQgMzgwZjA2MyBQTUQgMTIxMjEwNjMgUE1EIDEyMTIx
MDYzIFBURSAwUFRFIDAKClsgICAgMC4yMTAwMDBdIFRocmVhZCBvdmVycmFuIHN0YWNrLCBv
ciBzdGFjayBjb3JydXB0ZWQKWyAgICAwLjIxMDAwMF0gVGhyZWFkIG92ZXJyYW4gc3RhY2ss
IG9yIHN0YWNrIGNvcnJ1cHRlZApbICAgIDAuMjEwMDAwXSBPb3BzOiAwMDBiIFsjODkyXSAK
WyAgICAwLjIxMDAwMF0gT29wczogMDAwYiBbIzg5Ml0gUFJFRU1QVCBQUkVFTVBUIFNNUCBT
TVAgREVCVUdfUEFHRUFMTE9DREVCVUdfUEFHRUFMTE9DCgoKRWxhcHNlZCB0aW1lOiAzMAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvYTMzZGIzMGJiMmY0ZDUz
ZjMyNWUxYzQ2NWY1OTQ4OTRmNTU5ODQzYy9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC02NToy
MDE0MTAwNDExMzkxNDp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2EzM2RiMzBiYjJmNGQ1M2YzMjVl
MWM0NjVmNTk0ODk0ZjU1OTg0M2MvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTA6MjAxNDEw
MDQxMTM5MjE6eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9hMzNkYjMwYmIyZjRkNTNmMzI1ZTFjNDY1
ZjU5NDg5NGY1NTk4NDNjL2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTEyMDoyMDE0MTAwNDEx
MzkyMDp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2EzM2RiMzBiYjJmNGQ1M2YzMjVlMWM0NjVmNTk0
ODk0ZjU1OTg0M2MvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTI6MjAxNDEwMDQxMTM5MjU6
eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHNiMC0xMDA0MTAwNy9hMzNkYjMwYmIyZjRkNTNmMzI1ZTFjNDY1ZjU5NDg5NGY1
NTk4NDNjL2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTE0MjoyMDE0MTAwNDExMzkxODp4ODZf
NjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc2IwLTEwMDQxMDA3L2EzM2RiMzBiYjJmNGQ1M2YzMjVlMWM0NjVmNTk0ODk0ZjU1OTg0
M2MvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTQ4OjIwMTQxMDA0MTEzOTI4Ong4Nl82NC1y
YW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjAtMTAwNDEwMDcvYTMzZGIzMGJiMmY0ZDUzZjMyNWUxYzQ2NWY1OTQ4OTRmNTU5ODQzYy9k
bWVzZy1xdWFudGFsLWxrcC1uZXgwNC0xNDk6MjAxNDEwMDQxMTM5MTk6eDg2XzY0LXJhbmRj
b25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0x
MDA0MTAwNy9hMzNkYjMwYmIyZjRkNTNmMzI1ZTFjNDY1ZjU5NDg5NGY1NTk4NDNjL2RtZXNn
LXF1YW50YWwtbGtwLW5leDA0LTE1MzoyMDE0MTAwNDExMzkyMDp4ODZfNjQtcmFuZGNvbmZp
Zy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQx
MDA3L2EzM2RiMzBiYjJmNGQ1M2YzMjVlMWM0NjVmNTk0ODk0ZjU1OTg0M2MvZG1lc2ctcXVh
bnRhbC1sa3AtbmV4MDQtMTgyOjIwMTQxMDA0MTEzOTI1Ong4Nl82NC1yYW5kY29uZmlnLWhz
YjAtMTAwNDEwMDc6OgowOjk6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKbGluZWFy
LWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgYWsveDg2L2ZzZ3MtMgpsaW5lYXItYmlzZWN0
OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qg
c3RhcnQgYTMzZGIzMGJiMmY0ZDUzZjMyNWUxYzQ2NWY1OTQ4OTRmNTU5ODQzYyA3ZWEzOGEz
MDYxYWI4MmRjZmI3MDVjM2YzNmY1NWRkZDhjMzUxYzgzIC0tClByZXZpb3VzIEhFQUQgcG9z
aXRpb24gd2FzIGEzM2RiMzAuLi4gTWVyZ2UgJ2FrL3g4Ni9mc2dzLTInIGludG8gZGV2ZWwt
aG91cmx5LTIwMTQxMDA0MDkKSEVBRCBpcyBub3cgYXQgYjRkMzMxOC4uLiBNZXJnZSByZW1v
dGUtdHJhY2tpbmcgYnJhbmNoICdjcnlwdG8vbWFzdGVyJwpCaXNlY3Rpbmc6IDMgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCltiOGE4Njhl
OWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1OTIxZDdhXSB4ODY6IEFkZCBzdXBwb3J0IGZv
ciByZC93ciBmcy9ncyBiYXNlCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3Qv
bGludXgtMy9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0zL29iai1iaXNlY3QKbHMg
LWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAt
MTAwNDEwMDcvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQxMDA0MDk6YjhhODY4ZTll
YTg3NmExYjQwMDIwMzk3MzA1NTMzYzA5NTkyMWQ3YTpiaXNlY3QtbGludXgtMwoKMjAxNC0x
MC0wNCAxMTo0Mjo1OSBiOGE4NjhlOWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1OTIxZDdh
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3LWI4YTg2OGU5
ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFkN2EKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvYjhhODY4ZTllYTg3NmEx
YjQwMDIwMzk3MzA1NTMzYzA5NTkyMWQ3YQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyLXNtb2tlL3g4Nl82NC1yYW5kY29u
ZmlnLWhzYjAtMTAwNDEwMDctYjhhODY4ZTllYTg3NmExYjQwMDIwMzk3MzA1NTMzYzA5NTky
MWQ3YQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9i
OGE4NjhlOWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1OTIxZDdhL3ZtbGludXotMy4xNy4w
LXJjNy0wMDAwNC1nYjhhODY4ZQoKMjAxNC0xMC0wNCAxMTo0NTo1OSBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAuMTcwMDAwXSBrdm0tc3RlYWx0aW1lOiBj
cHUgMSwgbXNyIDEyNTBkYTQwClsgICAgMC4xNzc1ODRdIGdjb3Y6IHZlcnNpb24gbWFnaWM6
IDB4MzQzMDM5MmEKWyAgICAwLjE3NzU4NF0gZ2NvdjogdmVyc2lvbiBtYWdpYzogMHgzNDMw
MzkyYQpbICAgIDAuMjAxMDU1XSBkb3VibGUgZmF1bHQ6IGZmZmYgWyMxXSAKWyAgICAwLjIw
MTA1NV0gZG91YmxlIGZhdWx0OiBmZmZmIFsjMV0gUFJFRU1QVCBQUkVFTVBUIFNNUCBTTVAg
REVCVUdfUEFHRUFMTE9DREVCVUdfUEFHRUFMTE9DCgpbICAgIDAuMjAyMDAwXSBDUFU6IDEg
UElEOiAwIENvbW06IHN3YXBwZXIvMSBOb3QgdGFpbnRlZCAzLjE3LjAtcmM3LTAwMDA0LWdi
OGE4NjhlICMxClsgICAgMC4yMDIwMDBdIENQVTogMSBQSUQ6IDAgQ29tbTogc3dhcHBlci8x
IE5vdCB0YWludGVkIDMuMTcuMC1yYzctMDAwMDQtZ2I4YTg2OGUgIzEKWyAgICAwLjIwMjAw
MF0gdGFzazogZmZmZjg4MDAxMjFhZDUwMCB0aTogZmZmZjg4MDAxMjM0YzAwMCB0YXNrLnRp
OiBmZmZmODgwMDEyMzRjMDAwClsgICAgMC4yMDIwMDBdIHRhc2s6IGZmZmY4ODAwMTIxYWQ1
MDAgdGk6IGZmZmY4ODAwMTIzNGMwMDAgdGFzay50aTogZmZmZjg4MDAxMjM0YzAwMApbICAg
IDAuMjAyMDAwXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxODI3M2M5Pl0gClsgICAgMC4yMDIw
MDBdIFJJUDogMDAxMDpbPGZmZmZmZmZmODE4MjczYzk+XSAgWzxmZmZmZmZmZjgxODI3M2M5
Pl0gdHJhY2VfaGFyZGlycXNfb2ZmX3RodW5rKzB4OS8weDNjCiBbPGZmZmZmZmZmODE4Mjcz
Yzk+XSB0cmFjZV9oYXJkaXJxc19vZmZfdGh1bmsrMHg5LzB4M2MKWyAgICAwLjIwMjAwMF0g
UlNQOiAwMDAwOmZmZmY4ODAwMTI0ZmZmYzAgIEVGTEFHUzogMDAwMTAwODYKWyAgICAwLjIw
MjAwMF0gUlNQOiAwMDAwOmZmZmY4ODAwMTI0ZmZmYzAgIEVGTEFHUzogMDAwMTAwODYKWyAg
ICAwLjIwMjAwMF0gUkFYOiAwMDAwMDAwMDgyNzY3ZmYwIFJCWDogMDAwMDAwMDAwMDAwMDAw
MSBSQ1g6IGZmZmZmZmZmODI3NjdmZjAKWyAgICAwLjIwMjAwMF0gUkFYOiAwMDAwMDAwMDgy
NzY3ZmYwIFJCWDogMDAwMDAwMDAwMDAwMDAwMSBSQ1g6IGZmZmZmZmZmODI3NjdmZjAKWyAg
ICAwLjIwMjAwMF0gUkRYOiAwMDAwMDAwMDAwMDAwMDRlIFJTSTogZmZmZmZmZmY4MjgzOWE4
MCBSREk6IGZmZmZmZmZmODI3NjkzMjYKWyAgICAwLjIwMjAwMF0gUkRYOiAwMDAwMDAwMDAw
MDAwMDRlIFJTSTogZmZmZmZmZmY4MjgzOWE4MCBSREk6IGZmZmZmZmZmODI3NjkzMjYKWyAg
ICAwLjIwMjAwMF0gUkJQOiBmZmZmODgwMDEyNTAwMGQwIFIwODogMDAwMDAwMDAwMDAwMDA0
ZSBSMDk6IGZmZmZmZmZmODI4Mzg0MDAKWyAgICAwLjIwMjAwMF0gUkJQOiBmZmZmODgwMDEy
NTAwMGQwIFIwODogMDAwMDAwMDAwMDAwMDA0ZSBSMDk6IGZmZmZmZmZmODI4Mzg0MDAKWyAg
ICAwLjIwMjAwMF0gUjEwOiBmZmZmZmZmZjgyODM5YTgwIFIxMTogMDAwMDAwMDAwMDAwMDAz
OCBSMTI6IGZmZmY4ODAwMTIxYWQ1MDAKWyAgICAwLjIwMjAwMF0gUjEwOiBmZmZmZmZmZjgy
ODM5YTgwIFIxMTogMDAwMDAwMDAwMDAwMDAzOCBSMTI6IGZmZmY4ODAwMTIxYWQ1MDAKWyAg
ICAwLjIwMjAwMF0gUjEzOiBmZmZmODgwMDEyNTEzZWMwIFIxNDogMDAwMDAwMDAwMDAwMDAw
MCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjIwMjAwMF0gUjEzOiBmZmZmODgwMDEy
NTEzZWMwIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
ICAwLjIwMjAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMTI1
MDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMjAyMDAwXSBGUzog
IDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4MDAxMjUwMDAwMCgwMDAwKSBrbmxH
UzowMDAwMDAwMDAwMDAwMDAwClsgICAgMC4yMDIwMDBdIENTOiAgMDAxMCBEUzogMDAwMCBF
UzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICAwLjIwMjAwMF0gQ1M6ICAwMDEw
IERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDAuMjAyMDAw
XSBDUjI6IGZmZmY4ODAwMTI0ZmZmYjggQ1IzOiAwMDAwMDAwMDAzODBiMDAwIENSNDogMDAw
MDAwMDAwMDAwMDZhMApbICAgIDAuMjAyMDAwXSBDUjI6IGZmZmY4ODAwMTI0ZmZmYjggQ1Iz
OiAwMDAwMDAwMDAzODBiMDAwIENSNDogMDAwMDAwMDAwMDAwMDZhMApbICAgIDAuMjAyMDAw
XSBTdGFjazoKWyAgICAwLjIwMjAwMF0gU3RhY2s6ClsgICAgMC4yMDIwMDBdIEJVRzogdW5h
YmxlIHRvIGhhbmRsZSBrZXJuZWwgClsgICAgMC4yMDIwMDBdIEJVRzogdW5hYmxlIHRvIGhh
bmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3RwYWdpbmcgcmVxdWVzdCBhdCBmZmZmODgwMDEy
NGZmZmMwCiBhdCBmZmZmODgwMDEyNGZmZmMwClsgICAgMC4yMDIwMDBdIElQOgpbICAgIDAu
MjAyMDAwXSBJUDogWzxmZmZmZmZmZjgxMDIxMTk2Pl0gc2hvd19zdGFja19sb2dfbHZsKzB4
MmEzLzB4MzE5CiBbPGZmZmZmZmZmODEwMjExOTY+XSBzaG93X3N0YWNrX2xvZ19sdmwrMHgy
YTMvMHgzMTkKWyAgICAwLjIwMjAwMF0gUEdEIDY1NDAwNjcgClsgICAgMC4yMDIwMDBdIFBH
RCA2NTQwMDY3IFBVRCA2NTQxMDY3IFBVRCA2NTQxMDY3IFBNRCAxMjdlZjA2NyBQTUQgMTI3
ZWYwNjcgUFRFIDgwMDAwMDAwMTI0ZmYwNjBQVEUgODAwMDAwMDAxMjRmZjA2MAoKWyAgICAw
LjIwMjAwMF0gT29wczogMDAwMCBbIzJdIApbICAgIDAuMjAyMDAwXSBPb3BzOiAwMDAwIFsj
Ml0gUFJFRU1QVCBQUkVFTVBUIFNNUCBTTVAgREVCVUdfUEFHRUFMTE9DREVCVUdfUEFHRUFM
TE9DCgpbICAgIDAuMjAyMDAwXSBDUFU6IDEgUElEOiAwIENvbW06IHN3YXBwZXIvMSBOb3Qg
dGFpbnRlZCAzLjE3LjAtcmM3LTAwMDA0LWdiOGE4NjhlICMxClsgICAgMC4yMDIwMDBdIENQ
VTogMSBQSUQ6IDAgQ29tbTogc3dhcHBlci8xIE5vdCB0YWludGVkIDMuMTcuMC1yYzctMDAw
MDQtZ2I4YTg2OGUgIzEKWyAgICAwLjIwMjAwMF0gdGFzazogZmZmZjg4MDAxMjFhZDUwMCB0
aTogZmZmZjg4MDAxMjM0YzAwMCB0YXNrLnRpOiBmZmZmODgwMDEyMzRjMDAwClsgICAgMC4y
MDIwMDBdIHRhc2s6IGZmZmY4ODAwMTIxYWQ1MDAgdGk6IGZmZmY4ODAwMTIzNGMwMDAgdGFz
ay50aTogZmZmZjg4MDAxMjM0YzAwMApbICAgIDAuMjAyMDAwXSBSSVA6IDAwMTA6WzxmZmZm
ZmZmZjgxMDIxMTk2Pl0gClsgICAgMC4yMDIwMDBdIFJJUDogMDAxMDpbPGZmZmZmZmZmODEw
MjExOTY+XSAgWzxmZmZmZmZmZjgxMDIxMTk2Pl0gc2hvd19zdGFja19sb2dfbHZsKzB4MmEz
LzB4MzE5CiBbPGZmZmZmZmZmODEwMjExOTY+XSBzaG93X3N0YWNrX2xvZ19sdmwrMHgyYTMv
MHgzMTkKWyAgICAwLjIwMjAwMF0gUlNQOiAwMDAwOmZmZmY4ODAwMTI1MDdlMTggIEVGTEFH
UzogMDAwMTAwNDYKWyAgICAwLjIwMjAwMF0gUlNQOiAwMDAwOmZmZmY4ODAwMTI1MDdlMTgg
IEVGTEFHUzogMDAwMTAwNDYKWyAgICAwLjIwMjAwMF0gUkFYOiAwMDAwMDAwMDAwMDAwMDAy
IFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6IDAwMDAwMDAwMDAwMGM3OTgKWyAgICAwLjIw
MjAwMF0gUkFYOiAwMDAwMDAwMDAwMDAwMDAyIFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6
IDAwMDAwMDAwMDAwMGM3OTgKWyAgICAwLjIwMjAwMF0gUkRYOiAwMDAwMDAwMDAwMDBjNzAw
IFJTSTogMDAwMDAwMDAwMDAwMDAwMCBSREk6IGZmZmZmZmZmODQxMGY5MDAKWyAgICAwLjIw
MjAwMF0gUkRYOiAwMDAwMDAwMDAwMDBjNzAwIFJTSTogMDAwMDAwMDAwMDAwMDAwMCBSREk6
IGZmZmZmZmZmODQxMGY5MDAKWyAgICAwLjIwMjAwMF0gUkJQOiBmZmZmODgwMDEyNTA3ZTY4
IFIwODogZmZmZmZmZmY4MzYyM2U3MyBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjIw
MjAwMF0gUkJQOiBmZmZmODgwMDEyNTA3ZTY4IFIwODogZmZmZmZmZmY4MzYyM2U3MyBSMDk6
IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjIwMjAwMF0gUjEwOiAwMDAwMDAwMDAwMDAwMDAx
IFIxMTogMDAwMDAwMDAwMDAwNGZiYSBSMTI6IGZmZmY4ODAwMTI1MDNmYzAKWyAgICAwLjIw
MjAwMF0gUjEwOiAwMDAwMDAwMDAwMDAwMDAxIFIxMTogMDAwMDAwMDAwMDAwNGZiYSBSMTI6
IGZmZmY4ODAwMTI1MDNmYzAKWyAgICAwLjIwMjAwMF0gUjEzOiAwMDAwMDAwMDAwMDAwMDAw
IFIxNDogZmZmZjg4MDAxMjRmZmZjMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjIw
MjAwMF0gUjEzOiAwMDAwMDAwMDAwMDAwMDAwIFIxNDogZmZmZjg4MDAxMjRmZmZjMCBSMTU6
IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjIwMjAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAw
KDAwMDApIEdTOmZmZmY4ODAwMTI1MDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAw
MApbICAgIDAuMjAyMDAwXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4
MDAxMjUwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgMC4yMDIwMDBd
IENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAg
ICAwLjIwMjAwMF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4
MDA1MDAzYgpbICAgIDAuMjAyMDAwXSBDUjI6IGZmZmY4ODAwMTI0ZmZmYzAgQ1IzOiAwMDAw
MDAwMDAzODBiMDAwIENSNDogMDAwMDAwMDAwMDAwMDZhMApbICAgIDAuMjAyMDAwXSBDUjI6
IGZmZmY4ODAwMTI0ZmZmYzAgQ1IzOiAwMDAwMDAwMDAzODBiMDAwIENSNDogMDAwMDAwMDAw
MDAwMDZhMApbICAgIDAuMjAyMDAwXSBTdGFjazoKWyAgICAwLjIwMjAwMF0gU3RhY2s6Clsg
ICAgMC4yMDIwMDBdICBmZmZmZmZmZjgzNjIzZTczClsgICAgMC4yMDIwMDBdICBmZmZmZmZm
ZjgzNjIzZTczIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDEy
NTA3ZjU4IGZmZmY4ODAwMTI1MDdmNTggZmZmZjg4MDAxMjRmZmZjMCBmZmZmODgwMDEyNGZm
ZmMwCgpbICAgIDAuMjAyMDAwXSAgZmZmZjg4MDAxMjRmZmZjMApbICAgIDAuMjAyMDAwXSAg
ZmZmZjg4MDAxMjRmZmZjMCBmZmZmODgwMDEyNGZmZmMwIGZmZmY4ODAwMTI0ZmZmYzAgMDAw
MDAwMDAwMDAwMDAyYiAwMDAwMDAwMDAwMDAwMDJiIGZmZmY4ODAwMTI1MDdmNTggZmZmZjg4
MDAxMjUwN2Y1OAoKWyAgICAwLjIwMjAwMF0gIDAwMDAwMDAwMDAwMDAwNDAKWyAgICAwLjIw
MjAwMF0gIDAwMDAwMDAwMDAwMDAwNDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAw
MDAwIGZmZmY4ODAwMTI1MDdlYzggZmZmZjg4MDAxMjUwN2VjOCBmZmZmZmZmZjgxMDIxMmJm
IGZmZmZmZmZmODEwMjEyYmYKClsgICAgMC4yMDIwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4y
MDIwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4yMDIwMDBdICA8I0RGPiAKWyAgICAwLjIwMjAw
MF0gIDwjREY+IAoKWyAgICAwLjIwMjAwMF0gClsgICAgMC4yMDIwMDBdICBbPGZmZmZmZmZm
ODEwMjEyYmY+XSBzaG93X3JlZ3MrMHhiMy8weDMwZgogWzxmZmZmZmZmZjgxMDIxMmJmPl0g
c2hvd19yZWdzKzB4YjMvMHgzMGYKWyAgICAwLjIwMjAwMF0gIFs8ZmZmZmZmZmY4MTEzNTBl
OT5dID8gYXRvbWljX25vdGlmaWVyX2NhbGxfY2hhaW4rMHgxNi8weDFmClsgICAgMC4yMDIw
MDBdICBbPGZmZmZmZmZmODExMzUwZTk+XSA/IGF0b21pY19ub3RpZmllcl9jYWxsX2NoYWlu
KzB4MTYvMHgxZgpbICAgIDAuMjAyMDAwXSAgWzxmZmZmZmZmZjgxMDIzMzdlPl0gX19kaWUr
MHhmOS8weDE0ZApbICAgIDAuMjAyMDAwXSAgWzxmZmZmZmZmZjgxMDIzMzdlPl0gX19kaWUr
MHhmOS8weDE0ZApbICAgIDAuMjAyMDAwXSAgWzxmZmZmZmZmZjgxMDIzNDQ3Pl0gZGllKzB4
NzUvMHhjMApbICAgIDAuMjAyMDAwXSAgWzxmZmZmZmZmZjgxMDIzNDQ3Pl0gZGllKzB4NzUv
MHhjMApbICAgIDAuMjAyMDAwXSAgWzxmZmZmZmZmZjgxMDFkYWVhPl0gZG9fZG91YmxlX2Zh
dWx0KzB4NmQvMHg3NgpbICAgIDAuMjAyMDAwXSAgWzxmZmZmZmZmZjgxMDFkYWVhPl0gZG9f
ZG91YmxlX2ZhdWx0KzB4NmQvMHg3NgpbICAgIDAuMjAyMDAwXSAgWzxmZmZmZmZmZjgyNzY4
YjQwPl0gZG91YmxlX2ZhdWx0KzB4MzAvMHg0MApbICAgIDAuMjAyMDAwXSAgWzxmZmZmZmZm
ZjgyNzY4YjQwPl0gZG91YmxlX2ZhdWx0KzB4MzAvMHg0MApbICAgIDAuMjAyMDAwXSAgWzxm
ZmZmZmZmZjgyNzY3ZmYwPl0gPyBpcnFfcmV0dXJuKzB4Yy8weGMKWyAgICAwLjIwMjAwMF0g
IFs8ZmZmZmZmZmY4Mjc2N2ZmMD5dID8gaXJxX3JldHVybisweGMvMHhjClsgICAgMC4yMDIw
MDBdICBbPGZmZmZmZmZmODI3NjkzMjY+XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAgMC4y
MDIwMDBdICBbPGZmZmZmZmZmODI3NjkzMjY+XSA/IGVycm9yX3N0aSsweDUvMHg2ClsgICAg
MC4yMDIwMDBdICBbPGZmZmZmZmZmODE4MjczYzk+XSA/IHRyYWNlX2hhcmRpcnFzX29mZl90
aHVuaysweDkvMHgzYwpbICAgIDAuMjAyMDAwXSAgWzxmZmZmZmZmZjgxODI3M2M5Pl0gPyB0
cmFjZV9oYXJkaXJxc19vZmZfdGh1bmsrMHg5LzB4M2MKWyAgICAwLjIwMjAwMF0gIDw8RU9F
Pj4gClsgICAgMC4yMDIwMDBdICA8PEVPRT4+IAoKWyAgICAwLjIwMjAwMF0gIDxVTks+IApb
ICAgIDAuMjAyMDAwXSAgPFVOSz4gQ29kZTogQ29kZTogODMgODMgYzAgYzAgMDIgMDIgNDgg
NDggZmYgZmYgMDQgMDQgYzUgYzUgNTggNTggNWMgNWMgMTcgMTcgODQgODQgODUgODUgZjYg
ZjYgNzQgNzQgMWMgMWMgNDggNDggYzcgYzcgYzcgYzcgYWQgYWQgY2EgY2EgNzkgNzkgODMg
ODMgMzEgMzEgYzAgYzAgNDggNDggZmYgZmYgMDUgMDUgZGUgZGUgNzEgNzEgYmIgYmIgMDMg
MDMgZTggZTggMDYgMDYgNWIgNWIgNzEgNzEgMDEgMDEgNDggNDggZmYgZmYgMDUgMDUgZGEg
ZGEgNzEgNzEgYmIgYmIgMDMgMDMgPDQ5PiA8NDk+IDhiIDhiIDM2IDM2IDRkIDRkIDhkIDhk
IDdlIDdlIDA4IDA4IDQ4IDQ4IGM3IGM3IGM3IGM3IDZiIDZiIDNlIDNlIDYyIDYyIDgzIDgz
IDMxIDMxIGMwIGMwIDQxIDQxIGZmIGZmIGM1IGM1IDRkIDRkIDg5IDg5IAoKWyAgICAwLjIw
MjAwMF0gUklQIApbICAgIDAuMjAyMDAwXSBSSVAgIFs8ZmZmZmZmZmY4MTAyMTE5Nj5dIHNo
b3dfc3RhY2tfbG9nX2x2bCsweDJhMy8weDMxOQogWzxmZmZmZmZmZjgxMDIxMTk2Pl0gc2hv
d19zdGFja19sb2dfbHZsKzB4MmEzLzB4MzE5ClsgICAgMC4yMDIwMDBdICBSU1AgPGZmZmY4
ODAwMTI1MDdlMTg+ClsgICAgMC4yMDIwMDBdICBSU1AgPGZmZmY4ODAwMTI1MDdlMTg+Clsg
ICAgMC4yMDIwMDBdIENSMjogZmZmZjg4MDAxMjRmZmZjMApbICAgIDAuMjAyMDAwXSBDUjI6
IGZmZmY4ODAwMTI0ZmZmYzAKWyAgICAwLjIwMjAwMF0gLS0tWyBlbmQgdHJhY2UgZTQzNDY0
MzNkZWI2MWNmMyBdLS0tClsgICAgMC4yMDIwMDBdIC0tLVsgZW5kIHRyYWNlIGU0MzQ2NDMz
ZGViNjFjZjMgXS0tLQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcv
YjhhODY4ZTllYTg3NmExYjQwMDIwMzk3MzA1NTMzYzA5NTkyMWQ3YS9kbWVzZy1xdWFudGFs
LWxrcC1uZXgwNC0xNzc6MjAxNDEwMDQxMTQ1NDY6eDg2XzY0LXJhbmRjb25maWctaHNiMC0x
MDA0MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9iOGE4
NjhlOWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1OTIxZDdhL2RtZXNnLXF1YW50YWwtbGtw
LW5leDA0LTExMzoyMDE0MTAwNDExNDU0OTp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQx
MDA3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2I4YTg2OGU5
ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFkN2EvZG1lc2ctcXVhbnRhbC1sa3AtbmV4
MDQtMTAwOjIwMTQxMDA0MTE0NTUwOng4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvYjhhODY4ZTllYTg3
NmExYjQwMDIwMzk3MzA1NTMzYzA5NTkyMWQ3YS9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0x
Mjc6MjAxNDEwMDQxMTQ1NTY6eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9iOGE4NjhlOWVhODc2YTFi
NDAwMjAzOTczMDU1MzNjMDk1OTIxZDdhL2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTE0MToy
MDE0MTAwNDExNDU1Nzp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2I4YTg2OGU5ZWE4NzZhMWI0MDAy
MDM5NzMwNTUzM2MwOTU5MjFkN2EvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTQ6MjAxNDEw
MDQxMTQ1NTU6eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9iOGE4NjhlOWVhODc2YTFiNDAwMjAzOTcz
MDU1MzNjMDk1OTIxZDdhL2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTE3NjoyMDE0MTAwNDEx
NDU1MDp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2I4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUz
M2MwOTU5MjFkN2EvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTg4OjIwMTQxMDA0MTE0NTU4
Ong4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6Ogova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzYjAtMTAwNDEwMDcvYjhhODY4ZTllYTg3NmExYjQwMDIwMzk3MzA1NTMzYzA5
NTkyMWQ3YS9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC00MToyMDE0MTAwNDExNDU1Njp4ODZf
NjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc2IwLTEwMDQxMDA3L2I4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFk
N2EvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtNDI6MjAxNDEwMDQxMTQ1NTI6eDg2XzY0LXJh
bmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNi
MC0xMDA0MTAwNy9iOGE4NjhlOWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1OTIxZDdhL2Rt
ZXNnLXF1YW50YWwtbGtwLW5leDA0LTUzOjIwMTQxMDA0MTE0NTUzOng4Nl82NC1yYW5kY29u
ZmlnLWhzYjAtMTAwNDEwMDc6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAw
NDEwMDcvYjhhODY4ZTllYTg3NmExYjQwMDIwMzk3MzA1NTMzYzA5NTkyMWQ3YS9kbWVzZy1x
dWFudGFsLWxrcC1uZXgwNC03NToyMDE0MTAwNDExNDU1MDp4ODZfNjQtcmFuZGNvbmZpZy1o
c2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3
L2I4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFkN2EvZG1lc2ctcXVhbnRh
bC1sa3AtbmV4MDQtOTE6MjAxNDEwMDQxMTQ1NTc6eDg2XzY0LXJhbmRjb25maWctaHNiMC0x
MDA0MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9iOGE4
NjhlOWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1OTIxZDdhL2RtZXNnLXF1YW50YWwtbGtw
LW5leDA0LTk2OjIwMTQxMDA0MTE0NTU3Ong4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEw
MDc6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvYjhhODY4ZTll
YTg3NmExYjQwMDIwMzk3MzA1NTMzYzA5NTkyMWQ3YS9kbWVzZy1xdWFudGFsLWxrcC1uZXgw
NC05ODoyMDE0MTAwNDExNDU1NTp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2I4YTg2OGU5ZWE4NzZh
MWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFkN2EvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTA0
OjIwMTQxMDA0MTE0NTU5Ong4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvYjhhODY4ZTllYTg3NmExYjQw
MDIwMzk3MzA1NTMzYzA5NTkyMWQ3YS9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0xMTk6MjAx
NDEwMDQxMTQ1NTg6eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9iOGE4NjhlOWVhODc2YTFiNDAwMjAz
OTczMDU1MzNjMDk1OTIxZDdhL2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTEzODoyMDE0MTAw
NDExNDU1OTp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2I4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMw
NTUzM2MwOTU5MjFkN2EvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTY4OjIwMTQxMDA0MTE0
NTU5Ong4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvYjhhODY4ZTllYTg3NmExYjQwMDIwMzk3MzA1NTMz
YzA5NTkyMWQ3YS9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0xODQ6MjAxNDEwMDQxMTQ2MDI6
eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHNiMC0xMDA0MTAwNy9iOGE4NjhlOWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1
OTIxZDdhL2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTE4NzoyMDE0MTAwNDExNDU1ODp4ODZf
NjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc2IwLTEwMDQxMDA3L2I4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFk
N2EvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtNzY6MjAxNDEwMDQxMTQ1NTg6eDg2XzY0LXJh
bmRjb25maWctaHNiMC0xMDA0MTAwNzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNi
MC0xMDA0MTAwNy9iOGE4NjhlOWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1OTIxZDdhL2Rt
ZXNnLXF1YW50YWwtbGtwLW5leDA0LTEyNDoyMDE0MTAwNDExNDYwMzp4ODZfNjQtcmFuZGNv
bmZpZy1oc2IwLTEwMDQxMDA3OjoKMDoyMzoyMyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwoKQmlzZWN0aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDEgc3RlcCkKW2EwYjBiZTY0NTk5ZjUwZGMyYzlmYTg1NzM0MDI2NzAxMjIxZjE4NmFd
IHg4NjogTmF0dXJhbGx5IGFsaWduIHRoZSBkZWJ1ZyBJU1Qgc3RhY2sKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4LTMvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDEwMDQwOTphMGIwYmU2NDU5OWY1MGRjMmM5ZmE4NTczNDAyNjcwMTIyMWYxODZh
OmJpc2VjdC1saW51eC0zCgoyMDE0LTEwLTA0IDExOjQ2OjMwIGEwYjBiZTY0NTk5ZjUwZGMy
YzlmYTg1NzM0MDI2NzAxMjIxZjE4NmEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82NC1yYW5kY29uZmln
LWhzYjAtMTAwNDEwMDctYTBiMGJlNjQ1OTlmNTBkYzJjOWZhODU3MzQwMjY3MDEyMjFmMTg2
YQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0x
MDA0MTAwNy9hMGIwYmU2NDU5OWY1MGRjMmM5ZmE4NTczNDAyNjcwMTIyMWYxODZhCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4
MDIveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy1hMGIwYmU2NDU5OWY1MGRjMmM5
ZmE4NTczNDAyNjcwMTIyMWYxODZhChtbMTszNW0yMDE0LTEwLTA0IDExOjQ4OjMxIE5vIGJ1
aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1yYW5k
Y29uZmlnLWhzYjAtMTAwNDEwMDctYTBiMGJlNjQ1OTlmNTBkYzJjOWZhODU3MzQwMjY3MDEy
MjFmMTg2YRtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi1zbW9rZS94ODZfNjQtcmFuZGNv
bmZpZy1oc2IwLTEwMDQxMDA3LWEwYjBiZTY0NTk5ZjUwZGMyYzlmYTg1NzM0MDI2NzAxMjIx
ZjE4NmEKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcv
YTBiMGJlNjQ1OTlmNTBkYzJjOWZhODU3MzQwMjY3MDEyMjFmMTg2YS92bWxpbnV6LTMuMTcu
MC1yYzctMDAwMDItZ2EwYjBiZTYKCjIwMTQtMTAtMDQgMTE6NTA6MzEgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4JMwk2CTY3CTcwIFNVQ0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKWzU5OGQ1NzBhMDVj
ZDMxNTAwZmIxNWE4NDNhOTJmNjhkZGIxYjM2MThdIHg4NjogQWRkIGludHJpbnNpY3MvbWFj
cm9zIGZvciBuZXcgcmQvd3IgZnMvZ3MgYmFzZSBpbnN0cnVjdGlvbnMKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4LTMvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDEwMDQwOTo1OThkNTcwYTA1Y2QzMTUwMGZiMTVhODQzYTkyZjY4ZGRiMWIzNjE4
OmJpc2VjdC1saW51eC0zCgoyMDE0LTEwLTA0IDExOjUzOjMxIDU5OGQ1NzBhMDVjZDMxNTAw
ZmIxNWE4NDNhOTJmNjhkZGIxYjM2MTggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82NC1yYW5kY29uZmln
LWhzYjAtMTAwNDEwMDctNTk4ZDU3MGEwNWNkMzE1MDBmYjE1YTg0M2E5MmY2OGRkYjFiMzYx
OApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0x
MDA0MTAwNy81OThkNTcwYTA1Y2QzMTUwMGZiMTVhODQzYTkyZjY4ZGRiMWIzNjE4CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4
MDIveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy01OThkNTcwYTA1Y2QzMTUwMGZi
MTVhODQzYTkyZjY4ZGRiMWIzNjE4ChtbMTszNW0yMDE0LTEwLTA0IDExOjU1OjMxIE5vIGJ1
aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1yYW5k
Y29uZmlnLWhzYjAtMTAwNDEwMDctNTk4ZDU3MGEwNWNkMzE1MDBmYjE1YTg0M2E5MmY2OGRk
YjFiMzYxOBtbMG0KUmV0cnkgYnVpbGQgLi4Ka2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzYjAtMTAwNDEwMDcvNTk4ZDU3MGEwNWNkMzE1MDBmYjE1YTg0M2E5MmY2OGRk
YjFiMzYxOC92bWxpbnV6LTMuMTcuMC1yYzctMDAwMDMtZzU5OGQ1NzBhCgoyMDE0LTEwLTA0
IDExOjU2OjMxIGRldGVjdGluZyBib290IHN0YXRlIC4uLgk0OAk3MCBTVUNDRVNTCgpiOGE4
NjhlOWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1OTIxZDdhIGlzIHRoZSBmaXJzdCBiYWQg
Y29tbWl0CmNvbW1pdCBiOGE4NjhlOWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1OTIxZDdh
CkF1dGhvcjogQW5kaSBLbGVlbiA8YWtAbGludXguaW50ZWwuY29tPgpEYXRlOiAgIFdlZCBB
cHIgMjMgMTM6MjY6MjAgMjAxNCAtMDcwMAoKICAgIHg4NjogQWRkIHN1cHBvcnQgZm9yIHJk
L3dyIGZzL2dzIGJhc2UKICAgIAogICAgSXZ5QnJpZGdlIGFkZGVkIG5ldyBpbnN0cnVjdGlv
bnMgdG8gZGlyZWN0bHkgd3JpdGUgdGhlIGZzIGFuZCBncwogICAgNjRiaXQgYmFzZSByZWdp
c3RlcnMuIFByZXZpb3VzbHkgdGhpcyBoYWQgdG8gYmUgZG9uZSB3aXRoIGEgc3lzdGVtCiAg
ICBjYWxsIHRvIHdyaXRlIHRvIE1TUnMuIFRoZSBtYWluIHVzZSBjYXNlIGlzIGZhc3QgdXNl
ciBzcGFjZSB0aHJlYWRpbmcKICAgIGFuZCBzd2l0Y2hpbmcgdGhlIGZzL2dzIHJlZ2lzdGVy
cyBxdWlja2x5IHRoZXJlLiBBbm90aGVyIHVzZQogICAgY2FzZSBpcyBoYXZpbmcgKHJlbGF0
aXZlbHkpIGNoZWFwIGFjY2VzcyB0byBhIG5ldyBhZGRyZXNzCiAgICByZWdpc3RlciBwZXIg
dGhyZWFkLgogICAgCiAgICBUaGUgaW5zdHJ1Y3Rpb25zIGFyZSBvcHQtaW4gYW5kIGhhdmUg
dG8gYmUgZXhwbGljaXRlbHkgZW5hYmxlZAogICAgYnkgdGhlIE9TLgogICAgCiAgICBQcmV2
aW91c2x5IExpbnV4IGNvdWxkbid0IHN1cHBvcnQgdGhpcyBiZWNhdXNlIHRoZSBwYXJhbm9p
ZAogICAgZW50cnkgY29kZSByZWxpZWQgb24gdGhlIGdzIGJhc2UgbmV2ZXIgYmVpbmcgbmVn
YXRpdmUgb3V0c2lkZQogICAgdGhlIGtlcm5lbCB0byBkZWNpZGUgd2hlbiB0byB1c2Ugc3dh
cHMuIEl0IHdvdWxkIGNoZWNrIHRoZSBncyBNU1IKICAgIHZhbHVlIGFuZCBhc3N1bWUgaXQg
d2FzIGFscmVhZHkgcnVubmluZyBpbiBrZXJuZWwgaWYgdGhlIHZhbHVlCiAgICB3YXMgYWxy
ZWFkeSBuZWdhdGl2ZS4KICAgIAogICAgVG8gbWFrZSB0aGlzIHdvcmsgd2UgaGF2ZSB0byBy
ZXZhbXAgdGhlIHBhcmFub2lkIGV4Y2VwdGlvbgogICAgcGF0aCB0byBub3QgcmVseSBvbiB0
aGlzLiBXZSBjYW4gdXNlIHRoZSBuZXcgaW5zdHJ1Y3Rpb25zCiAgICB0byBnZXQgKHJlbGF0
aXZlbHkpIHF1aWNrIGFjY2VzcyB0byB0aGUgdmFsdWVzLgogICAgCiAgICBUaGlzIGlzIGFs
c28gc2lnbmlmaWNhbnRseSBmYXN0ZXIgdGhhbiBhIE1TUiByZWFkLCBzbyB3aWxsIHNwZWVk
CiAgICBOTUlzIChjcml0aWNhbCBmb3IgcHJvZmlsaW5nKQogICAgCiAgICBUaGUgb3JpZ2lu
YWwgcGF0Y2ggY29tcGFyZWQgdGhlIGdzIHdpdGggdGhlIGtlcm5lbCBncyBhbmQKICAgIGFz
c3VtZWQgdGhhdCBpZiBpdCB3YXMgdGhlIHNhbWUgc3dhcGdzIGlzIG5vdCBuZWVkZWQKICAg
IChhbmQgbm8gdXNlciBzcGFjZSBwcm9jZXNzaW5nIHdhcyBuZWVkZWQpLiBUaGlzCiAgICB3
YXMgbmljZSBhbmQgc2ltcGxlIGFuZCBkaWRuJ3QgbmVlZCBhIGxvdCBvZiBjaGFuZ2VzLgog
ICAgCiAgICBCdXQgdGhpcyBoYWQgdGhlIHNpZGUgZWZmZWN0IHRoYXQgaWYgYSB1c2VyIHBy
b2Nlc3Mgc2V0IGl0cwogICAgR1MgdG8gdGhlIHNhbWUgYXMgdGhlIGtlcm5lbCBpdCBtYXkg
bG9zZSByZXNjaGVkdWxpbmcKICAgIGNoZWNrcyAoc28gYSByYWNpbmcgcmVzY2hlZHVsZSBJ
UEkgd291bGQgaGF2ZSBiZWVuCiAgICBvbmx5IGFjdGVkIHVwb24gdGhlIG5leHQgbm9uIHBh
cmFub2lkIGludGVycnVwdCkKICAgIAogICAgVGhpcyB2ZXJzaW9uIG5vdyBzd2l0Y2hlcyB0
byBmdWxsIHNhdmUvcmVzdG9yZSBvZiB0aGUgR1MuCiAgICBUaGlzIHJlcXVpcmVzIHF1aXRl
IHNvbWUgY2hhbmdlcyBpbiB0aGUgcGFyYW5vaWQgcGF0aC4KICAgIFVuZm9ydHVuYXRlbHkg
ZGlkbid0IGNvbWUgdXAgd2l0aCBhIHNpbXBsZXIgc2NoZW1lOgogICAgCiAgICBUaGUga2Vy
bmVsIGdzIGZvciB0aGUgcGFyYW5vaWQgcGF0aCBpcyBub3cgc3RvcmVkIGF0IHRoZQogICAg
Ym90dG9tIG9mIHRoZSBJU1Qgc3RhY2sgKHNvIHRoYXQgaXQgY2FuIGJlIGRlcml2ZWQgZnJv
bSBSU1ApLgogICAgRm9yIHRoaXMgd2UgbmVlZCB0byBrbm93IHRoZSBzaXplIG9mIHRoZSBJ
U1Qgc3RhY2sKICAgICg0SyBvciA4SyksIHdoaWNoIGlzIG5vdyBwYXNzZWQgaW4gYXMgYSBz
dGFjayBwYXJhbWV0ZXIKICAgIHRvIHNhdmVfcGFyYW5vaWQuCiAgICAKICAgIFByZXZpb3Vz
bHkgd2UgaGFkIGEgZmxhZyBpbiBFQlggdGhhdCBpbmRpY2F0ZWQgd2hldGhlcgogICAgU1dB
UEdTIG5lZWRzIHRvIGJlIGNhbGxlZCBsYXRlciBvciBub3QuIEluIHRoZSBuZXcgc2NoZW1l
CiAgICB0aGlzIHR1cm5zIGludG8gYSB0cmlzdGF0ZSwgd2l0aCBhIG5ldyAicmVzdG9yZSBm
cm9tIFIxNSIKICAgIG1vZGUuIFRoZSBleGl0IHBhdGhzIGFyZSBhbGwgYWRqdXN0ZWQgdG8g
aGFuZGxlIHRoaXMgY29ycmVjdGx5LgogICAgCiAgICBUaGVyZSBpcyBvbmUgY29tcGxpY2F0
aW9uOiB0byBhbGxvdyBkZWJ1Z2dlcnMgKGVzcGVjaWFsbHkKICAgIGZyb20gdGhlIGludDMg
b3IgZGVidWcgdmVjdG9ycykgYWNjZXNzIHRvIHRoZSB1c2VyIEdTCiAgICB3ZSBuZWVkIHRv
IHNhdmUgaXQgaW4gdGhlIHRhc2sgc3RydWN0LiBOb3JtYWxseQogICAgdGhlIG5leHQgY29u
dGV4dCBzd2l0Y2ggd291bGQgb3ZlcndyaXRlIGl0IHdpdGggdGhlIHdyb25nCiAgICB2YWx1
ZSBmcm9tIGtlcm5lbF9ncywgc28gd2Ugc2V0IG5ldyBmbGFnIGFsc28gaW4gdGFza19zdHJ1
Y3QKICAgIHRoYXQgcHJldmVudHMgaXQuCiAgICAKICAgIEFsc28gdG8gcHJldmVudCByZWN1
cnNpdmUgaW50ZXJydXB0cyBjbG9iYmVyaW5nIHRoaXMKICAgIHN0YXRlIGluIHRoZSB0YXNr
X3N0cnVjdCB0aGlzIGlzIG9ubHkgZG9uZSBmb3IgaW50ZXJydXB0cwogICAgY29taW5nIGZy
b20gcmluZyAzLgogICAgCiAgICBBZnRlciBhIHNjaGVkdWxlIGNvbWVzIGJhY2sgd2UgY2hl
Y2sgaWYgdGhlIGZsYWcgaXMgc3RpbGwKICAgIHNldC4gSWYgaXQgd2Fzbid0IHNldCB0aGUg
R1MgaXMgYmFjayBpbiB0aGUgKHN3YXBwZWQpIGtlcm5lbAogICAgZ3Mgc28gd2UgcmV2ZXJ0
IHRvIHRoZSBTV0FQR1MgbW9kZSwgaW5zdGVhZCBvZiByZXN0b3JpbmcgR1MuCiAgICAKICAg
IFRoZW4gYWZ0ZXIgdGhlc2UgY2hhbmdlcyB3ZSBuZWVkIHRvIGFsc28gdXNlIHRoZSBuZXcg
aW5zdHJ1Y3Rpb25zCiAgICB0byBzYXZlL3Jlc3RvcmUgZnMgYW5kIGdzLCBzbyB0aGF0IHRo
ZSBuZXcgdmFsdWVzIHNldCBieSB0aGUKICAgIHVzZXJzIHdvbid0IGRpc2FwcGVhci4gIFRo
aXMgaXMgYWxzbyBzaWduaWZpY2FudGx5CiAgICBmYXN0ZXIgZm9yIHRoZSBjYXNlIHdoZW4g
dGhlIDY0Yml0IGJhc2UgaGFzIHRvIGJlIHN3aXRjaGVkCiAgICAodGhhdCBpcyB3aGVuIEdT
IGlzIGxhcmdlciB0aGFuIDRHQiksIGFzIHdlIGNhbiByZXBsYWNlCiAgICB0aGUgc2xvdyBN
U1Igd3JpdGUgd2l0aCBhIGZhc3RlciB3cltmZ11zYmFzZSBleGVjdXRpb24uCiAgICAKICAg
IFRoZSBpbnN0cnVjdGlvbnMgZG8gbm90IGNvbnRleHQgc3dpdGNoCiAgICB0aGUgc2VnbWVu
dCBpbmRleCwgc28gdGhlIG9sZCBpbnZhcmlhbnQgdGhhdCBmcyBvciBncyBpbmRleAogICAg
aGF2ZSB0byBiZSAwIGZvciBhIGRpZmZlcmVudCA2NGJpdCB2YWx1ZSB0byBzdGljayBpcyBz
dGlsbAogICAgdHJ1ZS4gUHJldmlvdXNseSBpdCB3YXMgZW5mb3JjZWQgYnkgYXJjaF9wcmN0
bCwgbm93IHRoZSB1c2VyCiAgICBwcm9ncmFtIGhhcyB0byBtYWtlIHN1cmUgaXQga2VlcHMg
dGhlIHNlZ21lbnQgaW5kZXhlcyB6ZXJvLgogICAgSWYgaXQgZG9lc24ndCB0aGUgY2hhbmdl
cyBtYXkgbm90IHN0aWNrLgogICAgCiAgICBUaGlzIGlzIGluIHRlcm0gZW5hYmxlcyBmYXN0
IHN3aXRjaGluZyB3aGVuIHRoZXJlIGFyZQogICAgZW5vdWdoIHRocmVhZHMgdGhhdCB0aGVp
ciBUTFMgc2VnbWVudCBkb2VzIG5vdCBmaXQgYmVsb3cgNEdCLAogICAgb3IgYWx0ZXJuYXRp
dmVseSBwcm9ncmFtcyB0aGF0IHVzZSBmcyBhcyBhbiBhZGRpdGlvbmFsIGJhc2UKICAgIHJl
Z2lzdGVyIHdpbGwgbm90IGdldCBhIHNpZ2lmaWNhbnQgY29udGV4dCBzd2l0Y2ggcGVuYWx0
eS4KICAgIAogICAgSXQgaXMgYWxsIGRvbmUgaW4gYSBzaW5nbGUgcGF0Y2ggdG8gYXZvaWQg
YmlzZWN0IGNyYXNoCiAgICBob2xlcy4KICAgIAogICAgdjI6IENoYW5nZSB0byBzYXZlL3Jl
c3RvcmUgR1MgaW5zdGVhZCBvZiB1c2luZyBzd2FwZ3MKICAgIGJhc2VkIG9uIHRoZSB2YWx1
ZS4gTGFyZ2Ugc2NhbGUgY2hhbmdlcy4KICAgIFNpZ25lZC1vZmYtYnk6IEFuZGkgS2xlZW4g
PGFrQGxpbnV4LmludGVsLmNvbT4KCjowNDAwMDAgMDQwMDAwIDcyYmU1ZWM0NDlmMjcyMjZl
MTlmYTc1NzgzOWNhM2YzMmNjOWNiNTMgNDA4NDlhZmNhOTg2N2I2YmIzNTM4ZmU4MTU2N2Fm
YTUyZGUzNjIzOCBNCWFyY2gKYmlzZWN0IHJ1biBzdWNjZXNzCkhFQUQgaXMgbm93IGF0IDU5
OGQ1NzBhLi4uIHg4NjogQWRkIGludHJpbnNpY3MvbWFjcm9zIGZvciBuZXcgcmQvd3IgZnMv
Z3MgYmFzZSBpbnN0cnVjdGlvbnMKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQxMDA0MDk6NTk4ZDU3MGEwNWNkMzE1MDBmYjE1YTg0M2E5MmY2OGRkYjFiMzYx
ODpiaXNlY3QtbGludXgtMwoKMjAxNC0xMC0wNCAxMTo1OTowMiA1OThkNTcwYTA1Y2QzMTUw
MGZiMTVhODQzYTkyZjY4ZGRiMWIzNjE4IHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHNiMC0xMDA0MTAwNy81OThkNTcwYTA1Y2QzMTUwMGZiMTVhODQzYTkyZjY4ZGRiMWIz
NjE4L3ZtbGludXotMy4xNy4wLXJjNy0wMDAwMy1nNTk4ZDU3MGEKCjIwMTQtMTAtMDQgMTE6
NTk6MDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4JMTA2CTExNgkxMTcJMjAyCTIx
MCBTVUNDRVNTCgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA1OThkNTcwYS4uLiB4ODY6
IEFkZCBpbnRyaW5zaWNzL21hY3JvcyBmb3IgbmV3IHJkL3dyIGZzL2dzIGJhc2UgaW5zdHJ1
Y3Rpb25zCkhFQUQgaXMgbm93IGF0IGNkOTRjMDEuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAn
ZGV2ZWwtaG91cmx5LTIwMTQxMDA0MDknCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2xpbnV4LWRldmVsOmRldmVs
LWhvdXJseS0yMDE0MTAwNDA5OmNkOTRjMDE4NTQ4OWYwY2RkY2JmYTgwZTg2MjU4YmI0NjA5
YjZlMWQ6YmlzZWN0LWxpbnV4LTMKIFRFU1QgRkFJTFVSRQpbICAgIDAuMjQ2NDA2XSByZWd1
bGF0b3ItZHVtbXk6IG5vIHBhcmFtZXRlcnMKWyAgICAwLjI1MTIyNl0gTkVUOiBSZWdpc3Rl
cmVkIHByb3RvY29sIGZhbWlseSAxNgpbICAgIDAuMjUxMjI2XSBORVQ6IFJlZ2lzdGVyZWQg
cHJvdG9jb2wgZmFtaWx5IDE2ClsgICAgMC4yNzUwNDVdIGRvdWJsZSBmYXVsdDogZmZmZiBb
IzFdIApbICAgIDAuMjc1MDQ1XSBkb3VibGUgZmF1bHQ6IGZmZmYgWyMxXSBQUkVFTVBUIFBS
RUVNUFQgU01QIFNNUCBERUJVR19QQUdFQUxMT0NERUJVR19QQUdFQUxMT0MKClsgICAgMC4y
NzYwMDBdIENQVTogMSBQSUQ6IDAgQ29tbTogc3dhcHBlci8xIE5vdCB0YWludGVkIDMuMTcu
MC1yYzctMDM4MzMtZ2NkOTRjMDEgIzEzOApbICAgIDAuMjc2MDAwXSBDUFU6IDEgUElEOiAw
IENvbW06IHN3YXBwZXIvMSBOb3QgdGFpbnRlZCAzLjE3LjAtcmM3LTAzODMzLWdjZDk0YzAx
ICMxMzgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2NkOTRjMDE4
NTQ4OWYwY2RkY2JmYTgwZTg2MjU4YmI0NjA5YjZlMWQvZG1lc2ctcXVhbnRhbC1sa3AtbmV4
MDQtODA6MjAxNDEwMDQxMDE5MDM6eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9jZDk0YzAxODU0ODlm
MGNkZGNiZmE4MGU4NjI1OGJiNDYwOWI2ZTFkL2RtZXNnLXlvY3RvLWxrcC1uZXgwNC00NToy
MDE0MTAwNDEwMTMwODp4ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3L2NkOTRjMDE4NTQ4OWYwY2RkY2Jm
YTgwZTg2MjU4YmI0NjA5YjZlMWQvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTkyOjIwMTQx
MDA0MTAyMzU0Ong4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDc6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvY2Q5NGMwMTg1NDg5ZjBjZGRjYmZhODBl
ODYyNThiYjQ2MDliNmUxZC9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0xMzc6MjAxNDEwMDQx
MDIzNTQ6eDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNzo6CjE3OjQ6NCBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQgY2Q5NGMwMSAwZGF5IGhlYWQg
Z3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDEwMDQwOScKCj09PT09PT09PSBsaW51cy9t
YXN0ZXIgPT09PT09PT09Ck5vdGU6IGNoZWNraW5nIG91dCAnbGludXMvbWFzdGVyJy4KCllv
dSBhcmUgaW4gJ2RldGFjaGVkIEhFQUQnIHN0YXRlLiBZb3UgY2FuIGxvb2sgYXJvdW5kLCBt
YWtlIGV4cGVyaW1lbnRhbApjaGFuZ2VzIGFuZCBjb21taXQgdGhlbSwgYW5kIHlvdSBjYW4g
ZGlzY2FyZCBhbnkgY29tbWl0cyB5b3UgbWFrZSBpbiB0aGlzCnN0YXRlIHdpdGhvdXQgaW1w
YWN0aW5nIGFueSBicmFuY2hlcyBieSBwZXJmb3JtaW5nIGFub3RoZXIgY2hlY2tvdXQuCgpJ
ZiB5b3Ugd2FudCB0byBjcmVhdGUgYSBuZXcgYnJhbmNoIHRvIHJldGFpbiBjb21taXRzIHlv
dSBjcmVhdGUsIHlvdSBtYXkKZG8gc28gKG5vdyBvciBsYXRlcikgYnkgdXNpbmcgLWIgd2l0
aCB0aGUgY2hlY2tvdXQgY29tbWFuZCBhZ2Fpbi4gRXhhbXBsZToKCiAgZ2l0IGNoZWNrb3V0
IC1iIG5ld19icmFuY2hfbmFtZQoKSEVBRCBpcyBub3cgYXQgMTI2ZDQ1Ny4uLiBNZXJnZSBi
cmFuY2ggJ2kyYy9mb3ItY3VycmVudCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L3dzYS9saW51eApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy9saW51czptYXN0ZXI6
MTI2ZDQ1NzZjYjczYzhhNDQwYWRjMzdjMTI5NTg5Y2Q2NjA1MWJjYzpiaXNlY3QtbGludXgt
MwoKMjAxNC0xMC0wNCAxMjowNTozNyAxMjZkNDU3NmNiNzNjOGE0NDBhZGMzN2MxMjk1ODlj
ZDY2MDUxYmNjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3
LTEyNmQ0NTc2Y2I3M2M4YTQ0MGFkYzM3YzEyOTU4OWNkNjYwNTFiY2MKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvMTI2ZDQ1
NzZjYjczYzhhNDQwYWRjMzdjMTI5NTg5Y2Q2NjA1MWJjYwp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyLXNtb2tlL3g4Nl82
NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDctMTI2ZDQ1NzZjYjczYzhhNDQwYWRjMzdjMTI5
NTg5Y2Q2NjA1MWJjYwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0x
MDA0MTAwNy8xMjZkNDU3NmNiNzNjOGE0NDBhZGMzN2MxMjk1ODljZDY2MDUxYmNjL3ZtbGlu
dXotMy4xNy4wLXJjNy0wMDA5NC1nMTI2ZDQ1NwoKMjAxNC0xMC0wNCAxMjowNzozOCBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4uLgk1MQkxODQJMjEwIFNVQ0NFU1MKCgo9PT09PT09PT0g
bmV4dC9tYXN0ZXIgPT09PT09PT09CkZyb20gZ2l0Oi8vZ2l0bWlycm9yL25leHQKICsgNDJm
Y2Q0Mi4uLmRkZjY3OGIgYWtwbSAgICAgICAtPiBuZXh0L2FrcG0gIChmb3JjZWQgdXBkYXRl
KQogKyAyNDlhNTQxLi4uNzA4NmU3OCBha3BtLWJhc2UgIC0+IG5leHQvYWtwbS1iYXNlICAo
Zm9yY2VkIHVwZGF0ZSkKICsgODk1MzMzOC4uLjJlMWQwMDQgbWFzdGVyICAgICAtPiBuZXh0
L21hc3RlciAgKGZvcmNlZCB1cGRhdGUpCiAgIGZlODJkY2UuLmI2MDFjZTAgIHN0YWJsZSAg
ICAgLT4gbmV4dC9zdGFibGUKRnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4dAogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTQxMDAyIC0+IG5leHQtMjAxNDEwMDIKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDE0MTAwMyAtPiBuZXh0LTIwMTQxMDAzClByZXZpb3VzIEhFQUQg
cG9zaXRpb24gd2FzIDEyNmQ0NTcuLi4gTWVyZ2UgYnJhbmNoICdpMmMvZm9yLWN1cnJlbnQn
IG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC93c2Ev
bGludXgKSEVBRCBpcyBub3cgYXQgMmUxZDAwNC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZp
YyBmaWxlcyBmb3IgMjAxNDEwMDMKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvbmV4dDptYXN0ZXI6MmUxZDAwNGI5
NjQ1NjI4YzY0YTJkYjU1ZWY2YjgxZmFkZjVlNmU5MTpiaXNlY3QtbGludXgtMwoKMjAxNC0x
MC0wNCAxMjoxMjoyMSAyZTFkMDA0Yjk2NDU2MjhjNjRhMmRiNTVlZjZiODFmYWRmNWU2ZTkx
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2IwLTEwMDQxMDA3LTJlMWQwMDRi
OTY0NTYyOGM2NGEyZGI1NWVmNmI4MWZhZGY1ZTZlOTEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjAtMTAwNDEwMDcvMmUxZDAwNGI5NjQ1NjI4
YzY0YTJkYjU1ZWY2YjgxZmFkZjVlNmU5MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyLXNtb2tlL3g4Nl82NC1yYW5kY29u
ZmlnLWhzYjAtMTAwNDEwMDctMmUxZDAwNGI5NjQ1NjI4YzY0YTJkYjU1ZWY2YjgxZmFkZjVl
NmU5MQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMC0xMDA0MTAwNy8y
ZTFkMDA0Yjk2NDU2MjhjNjRhMmRiNTVlZjZiODFmYWRmNWU2ZTkxL3ZtbGludXotMy4xNy4w
LXJjNy1uZXh0LTIwMTQxMDAzCgoyMDE0LTEwLTA0IDEyOjE1OjIxIGRldGVjdGluZyBib290
IHN0YXRlIC4uLgk1OQk5MgkxMzgJMjA0CTIxMCBTVUNDRVNTCgo=

--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.17.0-rc7-00004-gb8a868e"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.17.0-rc7 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
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
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
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
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
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
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

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
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
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
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
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
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
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
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_X86_16BIT is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MOVABLE_NODE=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
# CONFIG_CPU_IDLE is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
CONFIG_XEN_PCIDEV_FRONTEND=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_MCAST is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_VMWARE_VMCI_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

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
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
CONFIG_CAN_EMS_PCI=y
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
CONFIG_CAN_PLX_PCI=y
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
CONFIG_CAN_C_CAN_PCI=y
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
CONFIG_CAN_ESD_USB2=y
CONFIG_CAN_GS_USB=y
CONFIG_CAN_KVASER_USB=y
CONFIG_CAN_PEAK_USB=y
CONFIG_CAN_8DEV_USB=y
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRNET=y
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
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
# CONFIG_DONGLE is not set
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
CONFIG_VLSI_FIR=y
# CONFIG_MCS_FIR is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=y
CONFIG_BT_ATH3K=y
# CONFIG_BT_WILINK is not set
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
# CONFIG_RFKILL_GPIO is not set
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
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
CONFIG_FTL=y
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
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
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SBC_GXX is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=y
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=y
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_SPI_NOR=y
# CONFIG_MTD_UBI is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SKD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Bus Driver
#
CONFIG_INTEL_MIC_BUS=y

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
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
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=y
# CONFIG_BLK_DEV_SIS5513 is not set
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_SCSI_ESAS2R=y
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
CONFIG_SCSI_UFSHCD_PLATFORM=y
# CONFIG_SCSI_HPTIOP is not set
CONFIG_VMWARE_PVSCSI=y
# CONFIG_HYPERV_STORAGE is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_STEX=y
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
# CONFIG_I2O_CONFIG is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=y
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
# CONFIG_NET_TEAM_MODE_RANDOM is not set
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_NLMON is not set
CONFIG_SUNGEM_PHY=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_LANAI=y
CONFIG_ATM_ENI=y
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=y
# CONFIG_ATM_ZATM is not set
CONFIG_ATM_NICSTAR=y
# CONFIG_ATM_NICSTAR_USE_SUNI is not set
# CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=y
CONFIG_ATM_AMBASSADOR_DEBUG=y
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
CONFIG_TYPHOON=y
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_NET_VENDOR_ALTEON is not set
CONFIG_ALTERA_TSE=y
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_XGENE=y
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_ALX=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
CONFIG_VXGE=y
CONFIG_VXGE_DEBUG_TRACE_ALL=y
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
CONFIG_KS8851_MLL=y
# CONFIG_KSZ884X_PCI is not set
CONFIG_FEALNX=y
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
CONFIG_SFC=y
# CONFIG_SFC_MTD is not set
# CONFIG_SFC_MCDI_MON is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=y
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
# CONFIG_STMMAC_PLATFORM is not set
CONFIG_STMMAC_PCI=y
# CONFIG_STMMAC_DEBUG_FS is not set
# CONFIG_STMMAC_DA is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NIU=y
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
CONFIG_WIZNET_BUS_DIRECT=y
# CONFIG_WIZNET_BUS_INDIRECT is not set
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOATM is not set
CONFIG_PPPOE=y
CONFIG_PPP_ASYNC=y
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_USBNET is not set
CONFIG_USB_HSO=y
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_HYPERV_NET is not set
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
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
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
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_MAX8925_ONKEY=y
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=y
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_BEEPER=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=y
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_IMS_PCU=y
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
# CONFIG_HYPERV_KEYBOARD is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

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
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
# CONFIG_HVC_XEN is not set
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
CONFIG_TCG_ST33_I2C=y
CONFIG_TCG_XEN=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=y
# CONFIG_ACPI_I2C_OPREGION is not set
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

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
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_LP3943 is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

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
# CONFIG_GPIO_TPS6586X is not set

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2406=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
# CONFIG_THERMAL is not set
# CONFIG_WATCHDOG is not set
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
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65218 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LTC3589=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
# CONFIG_REGULATOR_MAX8925 is not set
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8998=y
# CONFIG_REGULATOR_MAX77686 is not set
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_RC5T583 is not set
# CONFIG_REGULATOR_S2MPA01 is not set
CONFIG_REGULATOR_S2MPS11=y
# CONFIG_REGULATOR_S5M8767 is not set
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_WM8994 is not set
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
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_INTEL=y
# CONFIG_FB_INTEL_DEBUG is not set
# CONFIG_FB_INTEL_I2C is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_VIRTUAL=y
CONFIG_XEN_FBDEV_FRONTEND=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_HYPERV is not set
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=y
# CONFIG_LOGO is not set
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
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO=y
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_HYPERV_MOUSE is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_OTG_FSM=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PCI is not set
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=y
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
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
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
CONFIG_USBIP_HOST=y
# CONFIG_USBIP_DEBUG is not set
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
# CONFIG_DWC3_HOST_USB3_LPM_ENABLE is not set
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=y
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=y
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QW is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
# CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MXUPORT=y
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=y
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_XSENS_MT=y
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_ZTE=y
CONFIG_USB_SERIAL_SSU100=y
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set
CONFIG_USB_LINK_LAYER_TEST=y
CONFIG_USB_ATM=y
# CONFIG_USB_SPEEDTOUCH is not set
# CONFIG_USB_CXACRU is not set
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_TAHVO_USB=y
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_VERBOSE is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
# CONFIG_USB_GR_UDC is not set
CONFIG_USB_R8A66597=y
CONFIG_USB_RENESAS_USBHS_UDC=y
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_ACM=y
CONFIG_USB_U_SERIAL=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_F_ECM=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
CONFIG_USB_CDC_COMPOSITE=y
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MMC_REALTEK_USB=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MIC_X100_DMA=y
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
# CONFIG_HYPERV_UTILS is not set
CONFIG_HYPERV_BALLOON=y

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=y
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_EFI=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
# CONFIG_DELL_SMO8800 is not set
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WIRELESS=y
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_COMPAL_LAPTOP is not set
CONFIG_SONY_LAPTOP=y
# CONFIG_SONYPI_COMPAT is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_TOSHIBA_HAPS=y
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=y
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=y

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_SM5502=y
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LP3943 is not set
CONFIG_PWM_LPSS=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
# CONFIG_MCB is not set
CONFIG_THUNDERBOLT=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set
CONFIG_EFI_RUNTIME_MAP=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
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
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
# CONFIG_JFFS2_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
CONFIG_SQUASHFS_DECOMP_MULTI=y
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_EFIVAR_FS=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
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
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
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
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_TRACEPOINT_BENCHMARK=y
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_RING_BUFFER_STARTUP_TEST=y

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_EFI is not set
CONFIG_X86_PTDUMP=y
# CONFIG_EFI_PGT_DUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
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
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
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
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

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
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
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
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_CRYPTO_DEV_CCP=y
# CONFIG_CRYPTO_DEV_CCP_DD is not set
CONFIG_CRYPTO_DEV_QAT=y
CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
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
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
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
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_UCS2_STRING=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--uh9ZiVrAOUUm9fzH--
