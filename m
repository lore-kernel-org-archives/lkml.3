Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaFWI0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:26:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:1258 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaFWI03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:26:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,528,1400050800"; 
   d="log'?scan'208";a="448723511"
Message-ID: <53A7E3F9.1020209@intel.com>
Date: Mon, 23 Jun 2014 16:23:21 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lan Tianyu <tianyu.lan@intel.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [Device/core] BUG: unable to handle kernel NULL pointer dereference
 at           (null)
Content-Type: multipart/mixed;
 boundary="------------060703080305070903040508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060703080305070903040508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Tianyu,

0day kernel testing robot got the below dmesg and the first bad commit is

git://bee.sh.intel.com/git/tianyu/usb.git dep_support
commit 6ce060a8738b36c60ad4b2567d393132b2620121
Author:     Lan Tianyu <tianyu.lan@intel.com>
AuthorDate: Thu Apr 10 13:18:43 2014 +0800
Commit:     Lan Tianyu <tianyu.lan@intel.com>
CommitDate: Wed Jun 18 10:40:29 2014 +0800

     Device/core: Add platform_dev_attach/detach_notify() callback
         For ACPI platform, ACPI table provides device probe dependency information
     and ACPI subsystem needs to check the driver probing status of dependent
     devices. This patch is to add two callbacks to notify platform when device
     is attached and detached from driver.
         Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

+------------------------------------------------------------+------------+------------+
|                                                            | 96e8c1a7c3 | 6ce060a873 |
+------------------------------------------------------------+------------+------------+
| boot_successes                                             | 60         | 0          |
| boot_failures                                              | 0          | 20         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference       | 0          | 20         |
| Oops                                                       | 0          | 20         |
| WARNING:CPU:PID:at_kernel/smp.c:smp_call_function_single() | 0          | 20         |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=  | 0          | 20         |
| backtrace:__platform_driver_register                       | 0          | 20         |
| backtrace:regulator_dummy_init                             | 0          | 20         |
| backtrace:regulator_init                                   | 0          | 20         |
| backtrace:kernel_init_freeable                             | 0          | 20         |
+------------------------------------------------------------+------------+------------+

[    0.180030]    prefetch64-sse:   137.000 MB/sec
[    0.220055]    generic_sse:   132.000 MB/sec
[    0.220691] xor: using function: prefetch64-sse (137.000 MB/sec)
[    0.222565] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    0.223565] IP: [<          (null)>]           (null)
[    0.224000] PGD 0 [    0.224000] Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.224000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc1-00011-g6ce060a #1
[    0.224000] task: ffff8800128c8000 ti: ffff8800128c4000 task.ti: ffff8800128c4000
[    0.224000] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[    0.224000] RSP: 0000:ffff8800128c7d68  EFLAGS: 00010246
[    0.224000] RAX: ffff8800128abbe8 RBX: ffff8800128ab7c0 RCX: 000000000000008f
[    0.224000] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8800128ab7c0
[    0.224000] RBP: ffff8800128c7d90 R08: 0000000000000002 R09: 000000000011e08f
[    0.224000] R10: 0000000000000000 R11: 00000000001d2f90 R12: ffffffff827fda98
[    0.224000] R13: ffffffff827fda98 R14: 0000000000000000 R15: 0000000000000000
[    0.224000] FS:  0000000000000000(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[    0.224000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.224000] CR2: 0000000000000000 CR3: 000000000260d000 CR4: 00000000000006f0
[    0.224000] Stack:
[    0.224000]  ffffffff816ee1a7 ffff8800128ab7c0 ffffffff827fda98 ffff8800128ab820
[    0.224000]  0000000000000000 ffff8800128c7db8 ffffffff816ee4c6 0000000000000000
[    0.224000]  ffffffff827fda98 ffffffff816ee431 ffff8800128c7df0 ffffffff816ec084
[    0.224000] Call Trace:
[    0.224000]  [<ffffffff816ee1a7>] ? driver_probe_device+0x8c/0x316
[    0.224000]  [<ffffffff816ee4c6>] __driver_attach+0x95/0xd3
[    0.224000]  [<ffffffff816ee431>] ? driver_probe_device+0x316/0x316
[    0.224000]  [<ffffffff816ec084>] bus_for_each_dev+0xbe/0xc9
[    0.224000]  [<ffffffff816ee65b>] driver_attach+0x20/0x29
[    0.224000]  [<ffffffff816ecc5d>] bus_add_driver+0x112/0x2ab
[    0.224000]  [<ffffffff816eefe3>] driver_register+0xec/0x152
[    0.224000]  [<ffffffff816f096f>] __platform_driver_register+0x61/0x6a
[    0.224000]  [<ffffffff82c81ca7>] regulator_dummy_init+0xa0/0xde
[    0.224000]  [<ffffffff82c81a2f>] regulator_init+0x90/0x9c
[    0.224000]  [<ffffffff82c8199f>] ? virtio_balloon_driver_init+0x20/0x20
[    0.224000]  [<ffffffff82c486e9>] do_one_initcall+0x171/0x248
[    0.224000]  [<ffffffff810e2f00>] ? parameq+0x6/0x2d
[    0.224000]  [<ffffffff810e31bd>] ? parse_args+0x296/0x3e8
[    0.224000]  [<ffffffff82c48aa9>] kernel_init_freeable+0x2e9/0x3e8
[    0.224000]  [<ffffffff82c47911>] ? do_early_param+0xd7/0xd7
[    0.224000]  [<ffffffff81caf6a1>] ? rest_init+0x115/0x115
[    0.224000]  [<ffffffff81caf6b1>] kernel_init+0x10/0x175
[    0.224000]  [<ffffffff81cd533c>] ret_from_fork+0x7c/0xb0
[    0.224000]  [<ffffffff81caf6a1>] ? rest_init+0x115/0x115
[    0.224000] Code:  Bad RIP value.
[    0.224000] RIP  [<          (null)>]           (null)
[    0.224000]  RSP <ffff8800128c7d68>
[    0.224000] CR2: 0000000000000000
[    0.224000] ---[ end trace d3295e197e7ac925 ]---
[    0.224000] ------------[ cut here ]------------

git bisect start aafca41bf8b2c093befa74e04c59580a4401b8e9 a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee --
git bisect good 5bb41e68bb216e78a850319a64b549c0ceaeddf8  # 15:15     20+      0  Merge 'ipvs-next/master' into devel-hourly-2014062314
git bisect good 8c804d4bb30cfef4a4af0f561d6ef31e84014ad5  # 15:23     20+      0  Merge 'asoc/topic/intel' into devel-hourly-2014062314
git bisect good b3b5fba3e162ab85c6b32b5425074cce21fbdfbc  # 15:28     20+      0  Merge 'block/for-linus' into devel-hourly-2014062314
git bisect  bad 07e8581d455a832a85e7917a9601aa1aa4b30965  # 15:29      0-     20  Merge 'tianyu/dep_support' into devel-hourly-2014062314
git bisect good 4033d5f4a151180ad86e6b0b45760f872b07f3e3  # 15:34     20+      0  Merge 'net-next/master' into devel-hourly-2014062314
git bisect good ca2bb6349593d783b7524e550d468d3ba259d62b  # 15:40     20+      0  I2C/ACPI: Add i2c ACPI operation region support
git bisect  bad f93d3e49ea1609fe7c7828a94b16619ff68c4f27  # 15:43      0-     20  ACPI: Resolve battery probe issue on the T100TA
git bisect  bad 6ce060a8738b36c60ad4b2567d393132b2620121  # 15:46      0-     20  Device/core: Add platform_dev_attach/detach_notify() callback
git bisect good 96e8c1a7c36ba7e14644aba544283ff4dfa2bff8  # 15:50     20+      0  I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI config
# first bad commit: [6ce060a8738b36c60ad4b2567d393132b2620121] Device/core: Add platform_dev_attach/detach_notify() callback
git bisect good 96e8c1a7c36ba7e14644aba544283ff4dfa2bff8  # 15:52     60+      0  I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI config
git bisect  bad aafca41bf8b2c093befa74e04c59580a4401b8e9  # 15:52      0-     13  0day head guard for 'devel-hourly-2014062314'
git bisect good a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee  # 15:56     60+      0  Linux 3.16-rc2
git bisect good 58ae500a03a6bf68eee323c342431bfdd3f460b6  # 16:03     60+      0  Add linux-next specific files for 20140623


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
Jet


--------------060703080305070903040508
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-yocto-ivb42-1:20140623154546:x86_64-randconfig-hsxa1-06231457:3.16.0-rc1-00011-g6ce060a:1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-yocto-ivb42-1:20140623154546:x86_64-randconfig-hsxa1-0";
 filename*1="6231457:3.16.0-rc1-00011-g6ce060a:1"

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.16.0-rc1-00011-g6ce060a (kbuild@lkp-hsx01)=
 (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP PREEMPT Mon Jun 23 15:45:0=
8 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ra=
m0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa1-06231457=
/linux-devel:devel-hourly-2014062314:6ce060a8738b36c60ad4b2567d393132b262=
0121:bisect-linux6/.vmlinuz-6ce060a8738b36c60ad4b2567d393132b2620121-2014=
0623154519-18-ivb42 branch=3Dlinux-devel/devel-hourly-2014062314 BOOT_IMA=
GE=3D/kernel/x86_64-randconfig-hsxa1-06231457/6ce060a8738b36c60ad4b2567d3=
93132b2620121/vmlinuz-3.16.0-rc1-00011-g6ce060a drbd.minor_count=3D8
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped a=
t [ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03de5000, 0x03de5fff] PGTABLE
[    0.000000] BRK [0x03de6000, 0x03de6fff] PGTABLE
[    0.000000] BRK [0x03de7000, 0x03de7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x03de8000, 0x03de8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x03de9000, 0x03de9fff] PGTABLE
[    0.000000] BRK [0x03dea000, 0x03deafff] PGTABLE
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 472 pages/cpu @ffff880013600000 s1910912 =
r0 d22400 u2097152
[    0.000000] pcpu-alloc: s1910912 r0 d22400 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1360cf80
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa1-0=
6231457/linux-devel:devel-hourly-2014062314:6ce060a8738b36c60ad4b2567d393=
132b2620121:bisect-linux6/.vmlinuz-6ce060a8738b36c60ad4b2567d393132b26201=
21-20140623154519-18-ivb42 branch=3Dlinux-devel/devel-hourly-2014062314 B=
OOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa1-06231457/6ce060a8738b36c60ad4=
b2567d393132b2620121/vmlinuz-3.16.0-rc1-00011-g6ce060a drbd.minor_count=3D=
8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 by=
tes)
[    0.000000] Memory: 265008K/327280K available (13154K kernel code, 455=
2K rwdata, 6852K rodata, 2744K init, 17132K bss, 62272K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2,=
 Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 8639 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.386 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.77 Bo=
goMIPS (lpj=3D10773544)
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008000] ACPI: Core revision 20140424
[    0.040404] ACPI: All ACPI Tables successfully acquired
[    0.041155] Security Framework initialized
[    0.041665] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes=
)
[    0.042267] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 =
bytes)
[    0.044517] Initializing cgroup subsys blkio
[    0.045101] Initializing cgroup subsys perf_event
[    0.045771] Initializing cgroup subsys net_prio
[    0.046452] Initializing cgroup subsys debug
[    0.047337] mce: CPU supports 10 MCE banks
[    0.048015] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.048015] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.048015] tlb_flushall_shift: 6
[    0.049896] debug: unmapping init [mem 0xffffffff82d22000-0xffffffff82=
d29fff]
[    0.054500] Getting VERSION: 50014
[    0.054955] Getting VERSION: 50014
[    0.055424] Getting ID: 0
[    0.055800] Getting ID: ff000000
[    0.056013] Getting LVT0: 8700
[    0.056389] Getting LVT1: 8400
[    0.056760] enabled ExtINT on CPU#0
[    0.057765] ENABLING IO-APIC IRQs
[    0.058065] init IO_APIC IRQs
[    0.058335]  apic 0 pin 0 not connected
[    0.058702] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.059406] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.060028] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.060736] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.061441] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.062141] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.062846] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.063568] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.064026] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.064740] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.065462] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.066177] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.066905] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.068027] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.068755] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.069471]  apic 0 pin 16 not connected
[    0.069817]  apic 0 pin 17 not connected
[    0.070161]  apic 0 pin 18 not connected
[    0.070511]  apic 0 pin 19 not connected
[    0.070854]  apic 0 pin 20 not connected
[    0.071200]  apic 0 pin 21 not connected
[    0.071553]  apic 0 pin 22 not connected
[    0.072006]  apic 0 pin 23 not connected
[    0.072502] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.073151] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model:=
 06, stepping: 01)
[    0.074061] Using local APIC timer interrupts.
[    0.074061] calibrating APIC timer ...
[    0.076000] ... lapic delta =3D 6249687
[    0.076000] ... PM-Timer delta =3D 358006
[    0.076000] ... PM-Timer result ok
[    0.076000] ..... delta 6249687
[    0.076000] ..... mult: 268422012
[    0.076000] ..... calibration result: 3999799
[    0.076000] ..... CPU clock speed is 2693.3452 MHz.
[    0.076000] ..... host bus clock speed is 999.3799 MHz.
[    0.076287] Performance Events: unsupported Netburst CPU model 6 no PM=
U driver, software events only.
[    0.100974] x86: Booting SMP configuration:
[    0.101727] .... node  #0, CPUs:      #1
[    0.008000] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.116166] x86: Booted up 1 node, 2 CPUs
[    0.116123] KVM setup async PF for cpu 1
[    0.116123] kvm-stealtime: cpu 1, msr 1380cf80
[    0.117618] smpboot: Total of 2 processors activated (10773.54 BogoMIP=
S)
[    0.124397] devtmpfs: initialized
[    0.135065] gcov: version magic: 0x3430382a
[    0.138087] evm: security.capability
[    0.140428] xor: measuring software checksum speed
[    0.180030]    prefetch64-sse:   137.000 MB/sec
[    0.220055]    generic_sse:   132.000 MB/sec
[    0.220691] xor: using function: prefetch64-sse (137.000 MB/sec)
[    0.222565] BUG: unable to handle kernel NULL pointer dereference at  =
         (null)
[    0.223565] IP: [<          (null)>]           (null)
[    0.224000] PGD 0=20
[    0.224000] Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.224000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc1-00011=
-g6ce060a #1
[    0.224000] task: ffff8800128c8000 ti: ffff8800128c4000 task.ti: ffff8=
800128c4000
[    0.224000] RIP: 0010:[<0000000000000000>]  [<          (null)>]      =
     (null)
[    0.224000] RSP: 0000:ffff8800128c7d68  EFLAGS: 00010246
[    0.224000] RAX: ffff8800128abbe8 RBX: ffff8800128ab7c0 RCX: 000000000=
000008f
[    0.224000] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88001=
28ab7c0
[    0.224000] RBP: ffff8800128c7d90 R08: 0000000000000002 R09: 000000000=
011e08f
[    0.224000] R10: 0000000000000000 R11: 00000000001d2f90 R12: ffffffff8=
27fda98
[    0.224000] R13: ffffffff827fda98 R14: 0000000000000000 R15: 000000000=
0000000
[    0.224000] FS:  0000000000000000(0000) GS:ffff880013600000(0000) knlG=
S:0000000000000000
[    0.224000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.224000] CR2: 0000000000000000 CR3: 000000000260d000 CR4: 000000000=
00006f0
[    0.224000] Stack:
[    0.224000]  ffffffff816ee1a7 ffff8800128ab7c0 ffffffff827fda98 ffff88=
00128ab820
[    0.224000]  0000000000000000 ffff8800128c7db8 ffffffff816ee4c6 000000=
0000000000
[    0.224000]  ffffffff827fda98 ffffffff816ee431 ffff8800128c7df0 ffffff=
ff816ec084
[    0.224000] Call Trace:
[    0.224000]  [<ffffffff816ee1a7>] ? driver_probe_device+0x8c/0x316
[    0.224000]  [<ffffffff816ee4c6>] __driver_attach+0x95/0xd3
[    0.224000]  [<ffffffff816ee431>] ? driver_probe_device+0x316/0x316
[    0.224000]  [<ffffffff816ec084>] bus_for_each_dev+0xbe/0xc9
[    0.224000]  [<ffffffff816ee65b>] driver_attach+0x20/0x29
[    0.224000]  [<ffffffff816ecc5d>] bus_add_driver+0x112/0x2ab
[    0.224000]  [<ffffffff816eefe3>] driver_register+0xec/0x152
[    0.224000]  [<ffffffff816f096f>] __platform_driver_register+0x61/0x6a=

[    0.224000]  [<ffffffff82c81ca7>] regulator_dummy_init+0xa0/0xde
[    0.224000]  [<ffffffff82c81a2f>] regulator_init+0x90/0x9c
[    0.224000]  [<ffffffff82c8199f>] ? virtio_balloon_driver_init+0x20/0x=
20
[    0.224000]  [<ffffffff82c486e9>] do_one_initcall+0x171/0x248
[    0.224000]  [<ffffffff810e2f00>] ? parameq+0x6/0x2d
[    0.224000]  [<ffffffff810e31bd>] ? parse_args+0x296/0x3e8
[    0.224000]  [<ffffffff82c48aa9>] kernel_init_freeable+0x2e9/0x3e8
[    0.224000]  [<ffffffff82c47911>] ? do_early_param+0xd7/0xd7
[    0.224000]  [<ffffffff81caf6a1>] ? rest_init+0x115/0x115
[    0.224000]  [<ffffffff81caf6b1>] kernel_init+0x10/0x175
[    0.224000]  [<ffffffff81cd533c>] ret_from_fork+0x7c/0xb0
[    0.224000]  [<ffffffff81caf6a1>] ? rest_init+0x115/0x115
[    0.224000] Code:  Bad RIP value.
[    0.224000] RIP  [<          (null)>]           (null)
[    0.224000]  RSP <ffff8800128c7d68>
[    0.224000] CR2: 0000000000000000
[    0.224000] ---[ end trace d3295e197e7ac925 ]---
[    0.224000] ------------[ cut here ]------------
[    0.224000] WARNING: CPU: 0 PID: 1 at kernel/smp.c:242 smp_call_functi=
on_single+0xeb/0x16e()
[    0.224000] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G      D       3.16=
=2E0-rc1-00011-g6ce060a #1
[    0.224000]  0000000000000000 ffff8800128c7928 ffffffff81cc6edd 000000=
0000000000
[    0.224000]  ffff8800128c7960 ffffffff810bfeea ffffffff8113fe08 000000=
00ffffffff
[    0.224000]  0000000000000000 ffffffff81155a0e ffff8800128c79b8 ffff88=
00128c7970
[    0.224000] Call Trace:
[    0.224000]  [<ffffffff81cc6edd>] dump_stack+0x85/0xe6
[    0.224000]  [<ffffffff810bfeea>] warn_slowpath_common+0x93/0xc1
[    0.224000]  [<ffffffff8113fe08>] ? smp_call_function_single+0xeb/0x16=
e
[    0.224000]  [<ffffffff81155a0e>] ? perf_event_disable+0xe2/0xe2
[    0.224000]  [<ffffffff810c0025>] warn_slowpath_null+0x23/0x2c
[    0.224000]  [<ffffffff8113fe08>] smp_call_function_single+0xeb/0x16e
[    0.224000]  [<ffffffff811557b8>] task_function_call+0x59/0x6a
[    0.224000]  [<ffffffff8115c774>] ? perf_cgroup_switch+0x263/0x263
[    0.224000]  [<ffffffff811557f0>] perf_cgroup_exit+0x27/0x30
[    0.224000]  [<ffffffff8114d621>] cgroup_exit+0xcd/0x10f
[    0.224000]  [<ffffffff810c3201>] do_exit+0x5c3/0xcf0
[    0.224000]  [<ffffffff815ed90e>] ? __delay+0x11/0x1a
[    0.224000]  [<ffffffff815ed942>] ? __const_udelay+0x2b/0x34
[    0.224000]  [<ffffffff81125df1>] ? __rcu_read_unlock+0x4c/0x8e
[    0.224000]  [<ffffffff8111dd5e>] ? kmsg_dump+0x147/0x155
[    0.224000]  [<ffffffff8111dc4c>] ? kmsg_dump+0x35/0x155
[    0.224000]  [<ffffffff81007b26>] oops_end+0xdb/0xe7
[    0.224000]  [<ffffffff81cb9444>] no_context+0x407/0x41b
[    0.224000]  [<ffffffff81cb96dd>] __bad_area_nosemaphore+0x285/0x299
[    0.224000]  [<ffffffff810f8f0f>] ? sched_clock_local+0x14/0xb8
[    0.224000]  [<ffffffff81cb97a4>] bad_area_nosemaphore+0x15/0x1e
[    0.224000]  [<ffffffff81047ac5>] __do_page_fault+0x117/0x67d
[    0.224000]  [<ffffffff8100d2ec>] ? sched_clock+0x10/0x1b
[    0.224000]  [<ffffffff810f8f0f>] ? sched_clock_local+0x14/0xb8
[    0.224000]  [<ffffffff810f9354>] ? sched_clock_cpu+0x102/0x155
[    0.224000]  [<ffffffff81044bd9>] ? kvm_clock_read+0x35/0x79
[    0.224000]  [<ffffffff8100d2ec>] ? sched_clock+0x10/0x1b
[    0.224000]  [<ffffffff810f8f0f>] ? sched_clock_local+0x14/0xb8
[    0.224000]  [<ffffffff81048088>] do_page_fault+0x30/0x3c
[    0.224000]  [<ffffffff810445da>] do_async_page_fault+0x3a/0xbd
[    0.224000]  [<ffffffff81cd6915>] async_page_fault+0x25/0x30
[    0.224000]  [<ffffffff816ee1a7>] ? driver_probe_device+0x8c/0x316
[    0.224000]  [<ffffffff816ee4c6>] __driver_attach+0x95/0xd3
[    0.224000]  [<ffffffff816ee431>] ? driver_probe_device+0x316/0x316
[    0.224000]  [<ffffffff816ec084>] bus_for_each_dev+0xbe/0xc9
[    0.224000]  [<ffffffff816ee65b>] driver_attach+0x20/0x29
[    0.224000]  [<ffffffff816ecc5d>] bus_add_driver+0x112/0x2ab
[    0.224000]  [<ffffffff816eefe3>] driver_register+0xec/0x152
[    0.224000]  [<ffffffff816f096f>] __platform_driver_register+0x61/0x6a=

[    0.224000]  [<ffffffff82c81ca7>] regulator_dummy_init+0xa0/0xde
[    0.224000]  [<ffffffff82c81a2f>] regulator_init+0x90/0x9c
[    0.224000]  [<ffffffff82c8199f>] ? virtio_balloon_driver_init+0x20/0x=
20
[    0.224000]  [<ffffffff82c486e9>] do_one_initcall+0x171/0x248
[    0.224000]  [<ffffffff810e2f00>] ? parameq+0x6/0x2d
[    0.224000]  [<ffffffff810e31bd>] ? parse_args+0x296/0x3e8
[    0.224000]  [<ffffffff82c48aa9>] kernel_init_freeable+0x2e9/0x3e8
[    0.224000]  [<ffffffff82c47911>] ? do_early_param+0xd7/0xd7
[    0.224000]  [<ffffffff81caf6a1>] ? rest_init+0x115/0x115
[    0.224000]  [<ffffffff81caf6b1>] kernel_init+0x10/0x175
[    0.224000]  [<ffffffff81cd533c>] ret_from_fork+0x7c/0xb0
[    0.224000]  [<ffffffff81caf6a1>] ? rest_init+0x115/0x115
[    0.224000] ---[ end trace d3295e197e7ac926 ]---
[    0.224020] Kernel panic - not syncing: Attempted to kill init! exitco=
de=3D0x00000009
[    0.224020]=20
[    0.225434] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconf=
ig-hsxa1-06231457/6ce060a8738b36c60ad4b2567d393132b2620121/vmlinuz-3.16.0=
-rc1-00011-g6ce060a -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ra=
m0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa1-06231457=
/linux-devel:devel-hourly-2014062314:6ce060a8738b36c60ad4b2567d393132b262=
0121:bisect-linux6/.vmlinuz-6ce060a8738b36c60ad4b2567d393132b2620121-2014=
0623154519-18-ivb42 branch=3Dlinux-devel/devel-hourly-2014062314 BOOT_IMA=
GE=3D/kernel/x86_64-randconfig-hsxa1-06231457/6ce060a8738b36c60ad4b2567d3=
93132b2620121/vmlinuz-3.16.0-rc1-00011-g6ce060a drbd.minor_count=3D8'  -i=
nitrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 2 -net ni=
c,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -=
watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto=
-ivb42-1 -serial file:/dev/shm/kboot/serial-yocto-ivb42-1 -daemonize -dis=
play none -monitor null=20


--------------060703080305070903040508
Content-Type: application/octet-stream;
 name="x86_64-randconfig-hsxa1-06231457-aafca41bf8b2c093befa74e04c59580a4401b8e9-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-117640.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="x86_64-randconfig-hsxa1-06231457-aafca41bf8b2c093befa74e04c5";
 filename*1="9580a4401b8e9-BUG:-unable-to-handle-kernel-NULL-pointer-dere";
 filename*2="ference-117640.log"

SEVBRCBpcyBub3cgYXQgYWFmY2E0MS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA2MjMxNCcKZ2l0IGNoZWNrb3V0IGE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3
Yjk2NDM1YmE4YzJjYjQyZWUKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDYyMzE0OmE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWU6
YmlzZWN0LWxpbnV4NgoKMjAxNC0wNi0yMy0xNTowNzo0MyBhNDk3YzNiYTFkOTdmYzY5YzFl
NzhlN2I5NjQzNWJhOGMyY2I0MmVlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMx
NDU3LWE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWUKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2E0
OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWUKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LWhzeGExLTA2MjMxNDU3LWE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQy
ZWUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
Ly54ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny1hNDk3YzNiYTFkOTdmYzY5YzFl
NzhlN2I5NjQzNWJhOGMyY2I0MmVlCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMS0wNjIzMTQ1Ny9hNDk3YzNiYTFkOTdmYzY5YzFlNzhlN2I5NjQzNWJhOGMyY2I0
MmVlL3ZtbGludXotMy4xNi4wLXJjMgoKMjAxNC0wNi0yMy0xNToxMDo0MyBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAJMTAJMTgJMjAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCBhNDk3
YzNiYTFkOTdmYzY5YzFlNzhlN2I5NjQzNWJhOGMyY2I0MmVlCmdpdCBiaXNlY3Qgc3RhcnQg
YWFmY2E0MWJmOGIyYzA5M2JlZmE3NGUwNGM1OTU4MGE0NDAxYjhlOSBhNDk3YzNiYTFkOTdm
YzY5YzFlNzhlN2I5NjQzNWJhOGMyY2I0MmVlIC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXIt
YmlzZWN0OiBbIi1iIiwgImFhZmNhNDFiZjhiMmMwOTNiZWZhNzRlMDRjNTk1ODBhNDQwMWI4
ZTkiLCAiLWciLCAiYTQ5N2MzYmExZDk3ZmM2OWMxZTc4ZTdiOTY0MzViYThjMmNiNDJlZSIs
ICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9jL2Jv
b3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiA1NTMgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbNWJiNDFlNjhi
YjIxNmU3OGE4NTAzMTlhNjRiNTQ5YzBjZWFlZGRmOF0gTWVyZ2UgJ2lwdnMtbmV4dC9tYXN0
ZXInIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNjIzMTQKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ni9v
YmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2
MjMxNDo1YmI0MWU2OGJiMjE2ZTc4YTg1MDMxOWE2NGI1NDljMGNlYWVkZGY4OmJpc2VjdC1s
aW51eDYKCjIwMTQtMDYtMjMtMTU6MTI6MTUgNWJiNDFlNjhiYjIxNmU3OGE4NTAzMTlhNjRi
NTQ5YzBjZWFlZGRmOCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny01YmI0
MWU2OGJiMjE2ZTc4YTg1MDMxOWE2NGI1NDljMGNlYWVkZGY4CkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny81YmI0MWU2OGJi
MjE2ZTc4YTg1MDMxOWE2NGI1NDljMGNlYWVkZGY4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0w
NjIzMTQ1Ny01YmI0MWU2OGJiMjE2ZTc4YTg1MDMxOWE2NGI1NDljMGNlYWVkZGY4CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0
LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTctNWJiNDFlNjhiYjIxNmU3OGE4NTAzMTlhNjRi
NTQ5YzBjZWFlZGRmOAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEt
MDYyMzE0NTcvNWJiNDFlNjhiYjIxNmU3OGE4NTAzMTlhNjRiNTQ5YzBjZWFlZGRmOC92bWxp
bnV6LTMuMTYuMC1yYzItMDAzMDktZzViYjQxZTYKCjIwMTQtMDYtMjMtMTU6MTQ6MTUgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgCTcuCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjQ0IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbOGM4MDRk
NGJiMzBjZmVmNGE0YWYwZjU2MWQ2ZWYzMWU4NDAxNGFkNV0gTWVyZ2UgJ2Fzb2MvdG9waWMv
aW50ZWwnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNjIzMTQKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
Ni9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDA2MjMxNDo4YzgwNGQ0YmIzMGNmZWY0YTRhZjBmNTYxZDZlZjMxZTg0MDE0YWQ1OmJpc2Vj
dC1saW51eDYKCjIwMTQtMDYtMjMtMTU6MTU6NDUgOGM4MDRkNGJiMzBjZmVmNGE0YWYwZjU2
MWQ2ZWYzMWU4NDAxNGFkNSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny04
YzgwNGQ0YmIzMGNmZWY0YTRhZjBmNTYxZDZlZjMxZTg0MDE0YWQ1CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny84YzgwNGQ0
YmIzMGNmZWY0YTRhZjBmNTYxZDZlZjMxZTg0MDE0YWQ1CndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MS0wNjIzMTQ1Ny04YzgwNGQ0YmIzMGNmZWY0YTRhZjBmNTYxZDZlZjMxZTg0MDE0YWQ1Cmtl
cm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny84YzgwNGQ0
YmIzMGNmZWY0YTRhZjBmNTYxZDZlZjMxZTg0MDE0YWQ1L3ZtbGludXotMy4xNi4wLXJjMi0w
MDM3OS1nOGM4MDRkNAoKMjAxNC0wNi0yMy0xNToyMTo0NSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAJOC4JMTgJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNzQgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCltiM2I1ZmJhM2UxNjJhYjg1YzZi
MzJiNTQyNTA3NGNjZTIxZmJkZmJjXSBNZXJnZSAnYmxvY2svZm9yLWxpbnVzJyBpbnRvIGRl
dmVsLWhvdXJseS0yMDE0MDYyMzE0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4
YTEtMDYyMzE0NTcvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNjIzMTQ6YjNiNWZi
YTNlMTYyYWI4NWM2YjMyYjU0MjUwNzRjY2UyMWZiZGZiYzpiaXNlY3QtbGludXg2CgoyMDE0
LTA2LTIzLTE1OjIzOjQ2IGIzYjVmYmEzZTE2MmFiODVjNmIzMmI1NDI1MDc0Y2NlMjFmYmRm
YmMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTctYjNiNWZiYTNlMTYyYWI4
NWM2YjMyYjU0MjUwNzRjY2UyMWZiZGZiYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvYjNiNWZiYTNlMTYyYWI4NWM2YjMy
YjU0MjUwNzRjY2UyMWZiZGZiYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTctYjNi
NWZiYTNlMTYyYWI4NWM2YjMyYjU0MjUwNzRjY2UyMWZiZGZiYwp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmln
LWhzeGExLTA2MjMxNDU3LWIzYjVmYmEzZTE2MmFiODVjNmIzMmI1NDI1MDc0Y2NlMjFmYmRm
YmMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2Iz
YjVmYmEzZTE2MmFiODVjNmIzMmI1NDI1MDc0Y2NlMjFmYmRmYmMvdm1saW51ei0zLjE2LjAt
cmMyLTAwNTEwLWdiM2I1ZmJhCgoyMDE0LTA2LTIzLTE1OjI2OjQ2IGRldGVjdGluZyBib290
IHN0YXRlIAkxMi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0MyByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzA3ZTg1ODFkNDU1YTgzMmE4
NWU3OTE3YTk2MDFhYTFhYTRiMzA5NjVdIE1lcmdlICd0aWFueXUvZGVwX3N1cHBvcnQnIGlu
dG8gZGV2ZWwtaG91cmx5LTIwMTQwNjIzMTQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMS0wNjIzMTQ1Ny9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2MjMxNDow
N2U4NTgxZDQ1NWE4MzJhODVlNzkxN2E5NjAxYWExYWE0YjMwOTY1OmJpc2VjdC1saW51eDYK
CjIwMTQtMDYtMjMtMTU6Mjg6MTYgMDdlODU4MWQ0NTVhODMyYTg1ZTc5MTdhOTYwMWFhMWFh
NGIzMDk2NSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny0wN2U4NTgxZDQ1
NWE4MzJhODVlNzkxN2E5NjAxYWExYWE0YjMwOTY1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny8wN2U4NTgxZDQ1NWE4MzJh
ODVlNzkxN2E5NjAxYWExYWE0YjMwOTY1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1
Ny0wN2U4NTgxZDQ1NWE4MzJhODVlNzkxN2E5NjAxYWExYWE0YjMwOTY1Cmtlcm5lbDogL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny8wN2U4NTgxZDQ1NWE4MzJh
ODVlNzkxN2E5NjAxYWExYWE0YjMwOTY1L3ZtbGludXotMy4xNi4wLXJjMi0wMDU0OS1nMDdl
ODU4MQoKMjAxNC0wNi0yMy0xNToyOToxNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1Qg
RkFJTFVSRQpbICAgIDAuMTU2MDI1XSAgICBwcmVmZXRjaDY0LXNzZTogICAxMDkuMDAwIE1C
L3NlYwpbICAgIDAuMTk2MDMzXSAgICBnZW5lcmljX3NzZTogICAxMDguMDAwIE1CL3NlYwpb
ICAgIDAuMTk2NDQ5XSB4b3I6IHVzaW5nIGZ1bmN0aW9uOiBwcmVmZXRjaDY0LXNzZSAoMTA5
LjAwMCBNQi9zZWMpClsgICAgMC4xOTc3NDJdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJu
ZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgICAgICAgICAobnVsbCkKWyAgICAw
LjE5ODUxOF0gSVA6IFs8ICAgICAgICAgIChudWxsKT5dICAgICAgICAgICAobnVsbCkKWyAg
ICAwLjE5OTAwOF0gUEdEIDAgClsgICAgMC4xOTkyMjNdIE9vcHM6IDAwMTAgWyMxXSBQUkVF
TVBUIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgICAwLjE5OTc1Ml0gQ1BVOiAwIFBJRDogMSBD
b21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4wLXJjMi0wMDU0OS1nMDdlODU4MSAj
MQpbICAgIDAuMjAwMDAwXSB0YXNrOiBmZmZmODgwMDExNGM4MDAwIHRpOiBmZmZmODgwMDEx
NGM0MDAwIHRhc2sudGk6IGZmZmY4ODAwMTE0YzQwMDAKWyAgICAwLjIwMDAwMF0gUklQOiAw
MDEwOls8MDAwMDAwMDAwMDAwMDAwMD5dICBbPCAgICAgICAgICAobnVsbCk+XSAgICAgICAg
ICAgKG51bGwpClsgICAgMC4yMDAwMDBdIFJTUDogMDAwMDpmZmZmODgwMDExNGM3ZDY4ICBF
RkxBR1M6IDAwMDEwMjQ2ClsgICAgMC4yMDAwMDBdIFJBWDogZmZmZjg4MDAxMTRhYmJlOCBS
Qlg6IGZmZmY4ODAwMTE0YWI3YzAgUkNYOiAwMDAwMDAwMDAwMDAwMDhmClsgICAgMC4yMDAw
MDBdIFJEWDogMDAwMDAwMDAwMDAwMDAwMSBSU0k6IDAwMDAwMDAwMDAwMDAwMDAgUkRJOiBm
ZmZmODgwMDExNGFiN2MwClsgICAgMC4yMDAwMDBdIFJCUDogZmZmZjg4MDAxMTRjN2Q5MCBS
MDg6IDAwMDAwMDAwMDAwMDAwMDIgUjA5OiAwMDAwMDAwMDAwMTFlMDhmClsgICAgMC4yMDAw
MDBdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAxZDJmOTAgUjEyOiBm
ZmZmZmZmZjgyN2ZkZTU4ClsgICAgMC4yMDAwMDBdIFIxMzogZmZmZmZmZmY4MjdmZGU1OCBS
MTQ6IDAwMDAwMDAwMDAwMDAwMDAgUjE1OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC4yMDAw
MDBdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDEyMjAwMDAwKDAw
MDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjIwMDAwMF0gQ1M6ICAwMDEwIERT
OiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDAuMjAwMDAwXSBD
UjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDAyNjBkMDAwIENSNDogMDAwMDAw
MDAwMDAwMDZmMApbICAgIDAuMjAwMDAwXSBTdGFjazoKWyAgICAwLjIwMDAwMF0gIGZmZmZm
ZmZmODE2ZWYzZWUgZmZmZjg4MDAxMTRhYjdjMCBmZmZmZmZmZjgyN2ZkZTU4IGZmZmY4ODAw
MTE0YWI4MjAKWyAgICAwLjIwMDAwMF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMTRj
N2RiOCBmZmZmZmZmZjgxNmVmNzBkIDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjIwMDAwMF0g
IGZmZmZmZmZmODI3ZmRlNTggZmZmZmZmZmY4MTZlZjY3OCBmZmZmODgwMDExNGM3ZGYwIGZm
ZmZmZmZmODE2ZWQyY2IKWyAgICAwLjIwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjIwMDAw
MF0gIFs8ZmZmZmZmZmY4MTZlZjNlZT5dID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDhjLzB4
MzE2ClsgICAgMC4yMDAwMDBdICBbPGZmZmZmZmZmODE2ZWY3MGQ+XSBfX2RyaXZlcl9hdHRh
Y2grMHg5NS8weGQzClsgICAgMC4yMDAwMDBdICBbPGZmZmZmZmZmODE2ZWY2Nzg+XSA/IGRy
aXZlcl9wcm9iZV9kZXZpY2UrMHgzMTYvMHgzMTYKWyAgICAwLjIwMDAwMF0gIFs8ZmZmZmZm
ZmY4MTZlZDJjYj5dIGJ1c19mb3JfZWFjaF9kZXYrMHhiZS8weGM5ClsgICAgMC4yMDAwMDBd
ICBbPGZmZmZmZmZmODE2ZWY4YTI+XSBkcml2ZXJfYXR0YWNoKzB4MjAvMHgyOQpbICAgIDAu
MjAwMDAwXSAgWzxmZmZmZmZmZjgxNmVkZWE0Pl0gYnVzX2FkZF9kcml2ZXIrMHgxMTIvMHgy
YWIKWyAgICAwLjIwMDAwMF0gIFs8ZmZmZmZmZmY4MTZmMDIyYT5dIGRyaXZlcl9yZWdpc3Rl
cisweGVjLzB4MTUyClsgICAgMC4yMDAwMDBdICBbPGZmZmZmZmZmODE2ZjFiYjY+XSBfX3Bs
YXRmb3JtX2RyaXZlcl9yZWdpc3RlcisweDYxLzB4NmEKWyAgICAwLjIwMDAwMF0gIFs8ZmZm
ZmZmZmY4MmM4MTlhND5dIHJlZ3VsYXRvcl9kdW1teV9pbml0KzB4YTAvMHhkZQpbICAgIDAu
MjAwMDAwXSAgWzxmZmZmZmZmZjgyYzgxNzJjPl0gcmVndWxhdG9yX2luaXQrMHg5MC8weDlj
ClsgICAgMC4yMDAwMDBdICBbPGZmZmZmZmZmODJjODE2OWM+XSA/IHZpcnRpb19iYWxsb29u
X2RyaXZlcl9pbml0KzB4MjAvMHgyMApbICAgIDAuMjAwMDAwXSAgWzxmZmZmZmZmZjgyYzQ4
NmU5Pl0gZG9fb25lX2luaXRjYWxsKzB4MTcxLzB4MjQ4ClsgICAgMC4yMDAwMDBdICBbPGZm
ZmZmZmZmODEwZTJmMDA+XSA/IHBhcmFtX2FycmF5X3NldCsweDE0My8weDE1YwpbICAgIDAu
MjAwMDAwXSAgWzxmZmZmZmZmZjgxMGUzMjM3Pl0gPyBwYXJzZV9hcmdzKzB4Mjk2LzB4M2U4
ClsgICAgMC4yMDAwMDBdICBbPGZmZmZmZmZmODJjNDhhYTk+XSBrZXJuZWxfaW5pdF9mcmVl
YWJsZSsweDJlOS8weDNlOApbICAgIDAuMjAwMDAwXSAgWzxmZmZmZmZmZjgyYzQ3OTExPl0g
PyBkb19lYXJseV9wYXJhbSsweGQ3LzB4ZDcKWyAgICAwLjIwMDAwMF0gIFs8ZmZmZmZmZmY4
MWNiMGM3MT5dID8gcmVzdF9pbml0KzB4MTE1LzB4MTE1ClsgICAgMC4yMDAwMDBdICBbPGZm
ZmZmZmZmODFjYjBjODE+XSBrZXJuZWxfaW5pdCsweDEwLzB4MTc1ClsgICAgMC4yMDAwMDBd
ICBbPGZmZmZmZmZmODFjZDY5M2M+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDAu
MjAwMDAwXSAgWzxmZmZmZmZmZjgxY2IwYzcxPl0gPyByZXN0X2luaXQrMHgxMTUvMHgxMTUK
WyAgICAwLjIwMDAwMF0gQ29kZTogIEJhZCBSSVAgdmFsdWUuClsgICAgMC4yMDAwMDBdIFJJ
UCAgWzwgICAgICAgICAgKG51bGwpPl0gICAgICAgICAgIChudWxsKQpbICAgIDAuMjAwMDAw
XSAgUlNQIDxmZmZmODgwMDExNGM3ZDY4PgpbICAgIDAuMjAwMDAwXSBDUjI6IDAwMDAwMDAw
MDAwMDAwMDAKWyAgICAwLjIwMDAwMF0gLS0tWyBlbmQgdHJhY2UgOTVhZmRlMTU4Mjc2ZmI3
YSBdLS0tClsgICAgMC4yMDAwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0t
LS0tLQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LzA3ZTg1ODFk
NDU1YTgzMmE4NWU3OTE3YTk2MDFhYTFhYTRiMzA5NjUvZG1lc2ctcXVhbnRhbC1pdmI0Mi01
ODoyMDE0MDYyMzE1MjkyMzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2
LjAtcmMyLTAwNTQ5LWcwN2U4NTgxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MS0wNjIzMTQ1Ny8wN2U4NTgxZDQ1NWE4MzJhODVlNzkxN2E5NjAxYWExYWE0YjMwOTY1L2Rt
ZXNnLXF1YW50YWwtaXZiNDItNzQ6MjAxNDA2MjMxNTI5MTk6eDg2XzY0LXJhbmRjb25maWct
aHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMi0wMDU0OS1nMDdlODU4MToxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvMDdlODU4MWQ0NTVhODMyYTg1ZTc5MTdh
OTYwMWFhMWFhNGIzMDk2NS9kbWVzZy1xdWFudGFsLWl2YjQyLTc0OjIwMTQwNjIzMTUyOTI5
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYuMC1yYzItMDA1NDktZzA3
ZTg1ODE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LzA3ZTg1
ODFkNDU1YTgzMmE4NWU3OTE3YTk2MDFhYTFhYTRiMzA5NjUvZG1lc2cteW9jdG8taXZiNDEt
MzU6MjAxNDA2MjMxNTI5MjQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4x
Ni4wLXJjMi0wMDU0OS1nMDdlODU4MToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTEtMDYyMzE0NTcvMDdlODU4MWQ0NTVhODMyYTg1ZTc5MTdhOTYwMWFhMWFhNGIzMDk2NS9k
bWVzZy15b2N0by1pdmI0MS0zOToyMDE0MDYyMzE1MjkyMzp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMyLTAwNTQ5LWcwN2U4NTgxOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny8wN2U4NTgxZDQ1NWE4MzJhODVlNzkxN2E5
NjAxYWExYWE0YjMwOTY1L2RtZXNnLXlvY3RvLWl2YjQyLTEwODoyMDE0MDYyMzE1MjkyMTp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMyLTAwNTQ5LWcwN2U4
NTgxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny8wN2U4NTgx
ZDQ1NWE4MzJhODVlNzkxN2E5NjAxYWExYWE0YjMwOTY1L2RtZXNnLXlvY3RvLWl2YjQyLTEz
OjIwMTQwNjIzMTUyOTI1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYu
MC1yYzItMDA1NDktZzA3ZTg1ODE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEx
LTA2MjMxNDU3LzA3ZTg1ODFkNDU1YTgzMmE4NWU3OTE3YTk2MDFhYTFhYTRiMzA5NjUvZG1l
c2cteW9jdG8taXZiNDItMTA4OjIwMTQwNjIzMTUyOTMxOng4Nl82NC1yYW5kY29uZmlnLWhz
eGExLTA2MjMxNDU3OjMuMTYuMC1yYzItMDA1NDktZzA3ZTg1ODE6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LzA3ZTg1ODFkNDU1YTgzMmE4NWU3OTE3YTk2
MDFhYTFhYTRiMzA5NjUvZG1lc2ctcXVhbnRhbC1pdmI0MS05OjIwMTQwNjIzMTUyOTMyOng4
Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYuMC1yYzItMDA1NDktZzA3ZTg1
ODE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LzA3ZTg1ODFk
NDU1YTgzMmE4NWU3OTE3YTk2MDFhYTFhYTRiMzA5NjUvZG1lc2ctcXVhbnRhbC1pdmI0Mi0y
MzoyMDE0MDYyMzE1MjkzMzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2
LjAtcmMyLTAwNTQ5LWcwN2U4NTgxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MS0wNjIzMTQ1Ny8wN2U4NTgxZDQ1NWE4MzJhODVlNzkxN2E5NjAxYWExYWE0YjMwOTY1L2Rt
ZXNnLXF1YW50YWwtaXZiNDItNTg6MjAxNDA2MjMxNTI5MzM6eDg2XzY0LXJhbmRjb25maWct
aHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMi0wMDU0OS1nMDdlODU4MToxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvMDdlODU4MWQ0NTVhODMyYTg1ZTc5MTdh
OTYwMWFhMWFhNGIzMDk2NS9kbWVzZy1xdWFudGFsLWl2YjQyLTc0OjIwMTQwNjIzMTUyOTM5
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYuMC1yYzItMDA1NDktZzA3
ZTg1ODE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LzA3ZTg1
ODFkNDU1YTgzMmE4NWU3OTE3YTk2MDFhYTFhYTRiMzA5NjUvZG1lc2cteW9jdG8taXZiNDEt
MzU6MjAxNDA2MjMxNTI5MzQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4x
Ni4wLXJjMi0wMDU0OS1nMDdlODU4MToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTEtMDYyMzE0NTcvMDdlODU4MWQ0NTVhODMyYTg1ZTc5MTdhOTYwMWFhMWFhNGIzMDk2NS9k
bWVzZy15b2N0by1pdmI0MS0zOToyMDE0MDYyMzE1MjkzMzp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMyLTAwNTQ5LWcwN2U4NTgxOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny8wN2U4NTgxZDQ1NWE4MzJhODVlNzkxN2E5
NjAxYWExYWE0YjMwOTY1L2RtZXNnLXlvY3RvLWl2YjQyLTEwODoyMDE0MDYyMzE1Mjk0MTp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMyLTAwNTQ5LWcwN2U4
NTgxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny8wN2U4NTgx
ZDQ1NWE4MzJhODVlNzkxN2E5NjAxYWExYWE0YjMwOTY1L2RtZXNnLXlvY3RvLWl2YjQyLTEz
OjIwMTQwNjIzMTUyOTM1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYu
MC1yYzItMDA1NDktZzA3ZTg1ODE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEx
LTA2MjMxNDU3LzA3ZTg1ODFkNDU1YTgzMmE4NWU3OTE3YTk2MDFhYTFhYTRiMzA5NjUvZG1l
c2ctcXVhbnRhbC1pdmI0Mi0yMzoyMDE0MDYyMzE1Mjk0Mzp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMyLTAwNTQ5LWcwN2U4NTgxOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny8wN2U4NTgxZDQ1NWE4MzJhODVlNzkxN2E5
NjAxYWExYWE0YjMwOTY1L2RtZXNnLXF1YW50YWwtaXZiNDItMjQ6MjAxNDA2MjMxNTI5NDI6
eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMi0wMDU0OS1nMDdl
ODU4MToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvMDdlODU4
MWQ0NTVhODMyYTg1ZTc5MTdhOTYwMWFhMWFhNGIzMDk2NS9kbWVzZy1xdWFudGFsLWl2YjQy
LTM5OjIwMTQwNjIzMTUyOTQzOng4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMu
MTYuMC1yYzItMDA1NDktZzA3ZTg1ODE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGExLTA2MjMxNDU3LzA3ZTg1ODFkNDU1YTgzMmE4NWU3OTE3YTk2MDFhYTFhYTRiMzA5NjUv
ZG1lc2ctcXVhbnRhbC1pdmI0Mi01ODoyMDE0MDYyMzE1Mjk0Mzp4ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMyLTAwNTQ5LWcwN2U4NTgxOjEKMDoyMDoyMCBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNi0yMyAxNToyOTo0NyBS
RVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0Ly5y
ZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDM5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbNDAzM2Q1ZjRhMTUxMTgwYWQ4NmU2YjBiNDU3NjBm
ODcyYjA3ZjNlM10gTWVyZ2UgJ25ldC1uZXh0L21hc3RlcicgaW50byBkZXZlbC1ob3VybHkt
MjAxNDA2MjMxNApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYyMzE0OjQwMzNkNWY0YTE1MTE4MGFk
ODZlNmIwYjQ1NzYwZjg3MmIwN2YzZTM6YmlzZWN0LWxpbnV4NgoKMjAxNC0wNi0yMy0xNToy
OTo0NyA0MDMzZDVmNGExNTExODBhZDg2ZTZiMGI0NTc2MGY4NzJiMDdmM2UzIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LTQwMzNkNWY0YTE1MTE4MGFkODZlNmIwYjQ1
NzYwZjg3MmIwN2YzZTMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGExLTA2MjMxNDU3LzQwMzNkNWY0YTE1MTE4MGFkODZlNmIwYjQ1NzYwZjg3
MmIwN2YzZTMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LTQwMzNkNWY0YTE1MTE4
MGFkODZlNmIwYjQ1NzYwZjg3MmIwN2YzZTMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIz
MTQ1Ny00MDMzZDVmNGExNTExODBhZDg2ZTZiMGI0NTc2MGY4NzJiMDdmM2UzCmtlcm5lbDog
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny80MDMzZDVmNGExNTEx
ODBhZDg2ZTZiMGI0NTc2MGY4NzJiMDdmM2UzL3ZtbGludXotMy4xNi4wLXJjMi0wMDUzNC1n
NDAzM2Q1ZgoKMjAxNC0wNi0yMy0xNTozMjo0NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMTIJ
MTgJMjAgU1VDQ0VTUwoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgdGlhbnl1
L2RlcF9zdXBwb3J0CmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QK
bGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCAwN2U4NTgxZDQ1NWE4MzJhODVlNzkx
N2E5NjAxYWExYWE0YjMwOTY1IDQwMzNkNWY0YTE1MTE4MGFkODZlNmIwYjQ1NzYwZjg3MmIw
N2YzZTMgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNDAzM2Q1Zi4uLiBNZXJnZSAn
bmV0LW5leHQvbWFzdGVyJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDYyMzE0CkhFQUQgaXMg
bm93IGF0IDFlYTUyYTkuLi4gTWVyZ2UgJ2piYXJuZXMvYXN5bmMtZmItcHJvYmUnIGludG8g
ZGV2ZWwtaG91cmx5LTIwMTQwNjAyMTAKQmlzZWN0aW5nOiA3IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbY2EyYmI2MzQ5NTkzZDc4M2I3
NTI0ZTU1MGQ0NjhkM2JhMjU5ZDYyYl0gSTJDL0FDUEk6IEFkZCBpMmMgQUNQSSBvcGVyYXRp
b24gcmVnaW9uIHN1cHBvcnQKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9s
aW51eDYvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2
MjMxNDU3L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYyMzE0OmNhMmJiNjM0OTU5
M2Q3ODNiNzUyNGU1NTBkNDY4ZDNiYTI1OWQ2MmI6YmlzZWN0LWxpbnV4NgoKMjAxNC0wNi0y
My0xNTozNDozMiBjYTJiYjYzNDk1OTNkNzgzYjc1MjRlNTUwZDQ2OGQzYmEyNTlkNjJiIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LWNhMmJiNjM0OTU5M2Q3ODNiNzUy
NGU1NTBkNDY4ZDNiYTI1OWQ2MmIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2NhMmJiNjM0OTU5M2Q3ODNiNzUyNGU1NTBk
NDY4ZDNiYTI1OWQ2MmIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LWNhMmJiNjM0
OTU5M2Q3ODNiNzUyNGU1NTBkNDY4ZDNiYTI1OWQ2MmIKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MS0wNjIzMTQ1Ny1jYTJiYjYzNDk1OTNkNzgzYjc1MjRlNTUwZDQ2OGQzYmEyNTlkNjJiCmtl
cm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny9jYTJiYjYz
NDk1OTNkNzgzYjc1MjRlNTUwZDQ2OGQzYmEyNTlkNjJiL3ZtbGludXotMy4xNi4wLXJjMS0w
MDAwOS1nY2EyYmI2MwoKMjAxNC0wNi0yMy0xNTozODozMiBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAJMTIJMTQuCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKW2Y5M2QzZTQ5ZWExNjA5ZmU3Yzc4
MjhhOTRiMTY2MTlmZjY4YzRmMjddIEFDUEk6IFJlc29sdmUgYmF0dGVyeSBwcm9iZSBpc3N1
ZSBvbiB0aGUgVDEwMFRBCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdApscyAtYSAv
a2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYy
MzE0NTcvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNjIzMTQ6ZjkzZDNlNDllYTE2
MDlmZTdjNzgyOGE5NGIxNjYxOWZmNjhjNGYyNzpiaXNlY3QtbGludXg2CgoyMDE0LTA2LTIz
LTE1OjQwOjMzIGY5M2QzZTQ5ZWExNjA5ZmU3Yzc4MjhhOTRiMTY2MTlmZjY4YzRmMjcgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTctZjkzZDNlNDllYTE2MDlmZTdjNzgy
OGE5NGIxNjYxOWZmNjhjNGYyNwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvZjkzZDNlNDllYTE2MDlmZTdjNzgyOGE5NGIx
NjYxOWZmNjhjNGYyNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTctZjkzZDNlNDll
YTE2MDlmZTdjNzgyOGE5NGIxNjYxOWZmNjhjNGYyNwp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWhzeGEx
LTA2MjMxNDU3LWY5M2QzZTQ5ZWExNjA5ZmU3Yzc4MjhhOTRiMTY2MTlmZjY4YzRmMjcKa2Vy
bmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2Y5M2QzZTQ5
ZWExNjA5ZmU3Yzc4MjhhOTRiMTY2MTlmZjY4YzRmMjcvdm1saW51ei0zLjE2LjAtcmMxLTAw
MDEzLWdmOTNkM2U0CgoyMDE0LTA2LTIzLTE1OjQyOjMzIGRldGVjdGluZyBib290IHN0YXRl
IC4gVEVTVCBGQUlMVVJFClsgICAgMC4xNjQwMjFdICAgIHByZWZldGNoNjQtc3NlOiAgIDE0
MC4wMDAgTUIvc2VjClsgICAgMC4yMDQwMzNdICAgIGdlbmVyaWNfc3NlOiAgIDE0MS4wMDAg
TUIvc2VjClsgICAgMC4yMDQ0MzldIHhvcjogdXNpbmcgZnVuY3Rpb246IGdlbmVyaWNfc3Nl
ICgxNDEuMDAwIE1CL3NlYykKWyAgICAwLjIwNTcxNV0gQlVHOiB1bmFibGUgdG8gaGFuZGxl
IGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgICAgICAgICAgIChudWxsKQpb
ICAgIDAuMjA2NDc3XSBJUDogWzwgICAgICAgICAgKG51bGwpPl0gICAgICAgICAgIChudWxs
KQpbICAgIDAuMjA2OTkyXSBQR0QgMCAKWyAgICAwLjIwNzIwM10gT29wczogMDAxMCBbIzFd
IFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExPQwpbICAgIDAuMjA3NzYxXSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmMxLTAwMDEzLWdmOTNk
M2U0ICMxClsgICAgMC4yMDgwMDBdIHRhc2s6IGZmZmY4ODAwMTE0YzgwMDAgdGk6IGZmZmY4
ODAwMTE0YzQwMDAgdGFzay50aTogZmZmZjg4MDAxMTRjNDAwMApbICAgIDAuMjA4MDAwXSBS
SVA6IDAwMTA6WzwwMDAwMDAwMDAwMDAwMDAwPl0gIFs8ICAgICAgICAgIChudWxsKT5dICAg
ICAgICAgICAobnVsbCkKWyAgICAwLjIwODAwMF0gUlNQOiAwMDAwOmZmZmY4ODAwMTE0Yzdk
NjggIEVGTEFHUzogMDAwMTAyNDYKWyAgICAwLjIwODAwMF0gUkFYOiBmZmZmODgwMDExNGFi
YmU4IFJCWDogZmZmZjg4MDAxMTRhYjdjMCBSQ1g6IDAwMDAwMDAwMDAwMDAwOGYKWyAgICAw
LjIwODAwMF0gUkRYOiAwMDAwMDAwMDAwMDAwMDAxIFJTSTogMDAwMDAwMDAwMDAwMDAwMCBS
REk6IGZmZmY4ODAwMTE0YWI3YzAKWyAgICAwLjIwODAwMF0gUkJQOiBmZmZmODgwMDExNGM3
ZDkwIFIwODogMDAwMDAwMDAwMDAwMDAwMiBSMDk6IDAwMDAwMDAwMDAxMWUwOGYKWyAgICAw
LjIwODAwMF0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDFkMmY5MCBS
MTI6IGZmZmZmZmZmODI3ZmRjYTgKWyAgICAwLjIwODAwMF0gUjEzOiBmZmZmZmZmZjgyN2Zk
Y2E4IFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAw
LjIwODAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMTIyMDAw
MDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMjA4MDAwXSBDUzogIDAw
MTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMC4yMDgw
MDBdIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMDI2MGQwMDAgQ1I0OiAw
MDAwMDAwMDAwMDAwNmYwClsgICAgMC4yMDgwMDBdIFN0YWNrOgpbICAgIDAuMjA4MDAwXSAg
ZmZmZmZmZmY4MTZlZTc2YSBmZmZmODgwMDExNGFiN2MwIGZmZmZmZmZmODI3ZmRjYTggZmZm
Zjg4MDAxMTRhYjgyMApbICAgIDAuMjA4MDAwXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgw
MDExNGM3ZGI4IGZmZmZmZmZmODE2ZWVhODkgMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMjA4
MDAwXSAgZmZmZmZmZmY4MjdmZGNhOCBmZmZmZmZmZjgxNmVlOWY0IGZmZmY4ODAwMTE0Yzdk
ZjAgZmZmZmZmZmY4MTZlYzY0NwpbICAgIDAuMjA4MDAwXSBDYWxsIFRyYWNlOgpbICAgIDAu
MjA4MDAwXSAgWzxmZmZmZmZmZjgxNmVlNzZhPl0gPyBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4
OGMvMHgzMTYKWyAgICAwLjIwODAwMF0gIFs8ZmZmZmZmZmY4MTZlZWE4OT5dIF9fZHJpdmVy
X2F0dGFjaCsweDk1LzB4ZDMKWyAgICAwLjIwODAwMF0gIFs8ZmZmZmZmZmY4MTZlZTlmND5d
ID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDMxNi8weDMxNgpbICAgIDAuMjA4MDAwXSAgWzxm
ZmZmZmZmZjgxNmVjNjQ3Pl0gYnVzX2Zvcl9lYWNoX2RldisweGJlLzB4YzkKWyAgICAwLjIw
ODAwMF0gIFs8ZmZmZmZmZmY4MTZlZWMxZT5dIGRyaXZlcl9hdHRhY2grMHgyMC8weDI5Clsg
ICAgMC4yMDgwMDBdICBbPGZmZmZmZmZmODE2ZWQyMjA+XSBidXNfYWRkX2RyaXZlcisweDEx
Mi8weDJhYgpbICAgIDAuMjA4MDAwXSAgWzxmZmZmZmZmZjgxNmVmNWE2Pl0gZHJpdmVyX3Jl
Z2lzdGVyKzB4ZWMvMHgxNTIKWyAgICAwLjIwODAwMF0gIFs8ZmZmZmZmZmY4MTZmMGYzMj5d
IF9fcGxhdGZvcm1fZHJpdmVyX3JlZ2lzdGVyKzB4NjEvMHg2YQpbICAgIDAuMjA4MDAwXSAg
WzxmZmZmZmZmZjgyYzgxY2JkPl0gcmVndWxhdG9yX2R1bW15X2luaXQrMHhhMC8weGRlClsg
ICAgMC4yMDgwMDBdICBbPGZmZmZmZmZmODJjODFhNDU+XSByZWd1bGF0b3JfaW5pdCsweDkw
LzB4OWMKWyAgICAwLjIwODAwMF0gIFs8ZmZmZmZmZmY4MmM4MTliNT5dID8gdmlydGlvX2Jh
bGxvb25fZHJpdmVyX2luaXQrMHgyMC8weDIwClsgICAgMC4yMDgwMDBdICBbPGZmZmZmZmZm
ODJjNDg2ZTk+XSBkb19vbmVfaW5pdGNhbGwrMHgxNzEvMHgyNDgKWyAgICAwLjIwODAwMF0g
IFs8ZmZmZmZmZmY4MTBlMmYwMD5dID8gcGFyYW1lcSsweDYvMHgyZApbICAgIDAuMjA4MDAw
XSAgWzxmZmZmZmZmZjgxMGUzMWJkPl0gPyBwYXJzZV9hcmdzKzB4Mjk2LzB4M2U4ClsgICAg
MC4yMDgwMDBdICBbPGZmZmZmZmZmODJjNDhhYTk+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsw
eDJlOS8weDNlOApbICAgIDAuMjA4MDAwXSAgWzxmZmZmZmZmZjgyYzQ3OTExPl0gPyBkb19l
YXJseV9wYXJhbSsweGQ3LzB4ZDcKWyAgICAwLjIwODAwMF0gIFs8ZmZmZmZmZmY4MWNhZmM3
MT5dID8gcmVzdF9pbml0KzB4MTE1LzB4MTE1ClsgICAgMC4yMDgwMDBdICBbPGZmZmZmZmZm
ODFjYWZjODE+XSBrZXJuZWxfaW5pdCsweDEwLzB4MTc1ClsgICAgMC4yMDgwMDBdICBbPGZm
ZmZmZmZmODFjZDU4ZmM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDAuMjA4MDAw
XSAgWzxmZmZmZmZmZjgxY2FmYzcxPl0gPyByZXN0X2luaXQrMHgxMTUvMHgxMTUKWyAgICAw
LjIwODAwMF0gQ29kZTogIEJhZCBSSVAgdmFsdWUuClsgICAgMC4yMDgwMDBdIFJJUCAgWzwg
ICAgICAgICAgKG51bGwpPl0gICAgICAgICAgIChudWxsKQpbICAgIDAuMjA4MDAwXSAgUlNQ
IDxmZmZmODgwMDExNGM3ZDY4PgpbICAgIDAuMjA4MDAwXSBDUjI6IDAwMDAwMDAwMDAwMDAw
MDAKWyAgICAwLjIwODAwMF0gLS0tWyBlbmQgdHJhY2UgMDMwNzE3NWI5Y2MxZDdlNSBdLS0t
ClsgICAgMC4yMDgwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2Y5M2QzZTQ5ZWExNjA5
ZmU3Yzc4MjhhOTRiMTY2MTlmZjY4YzRmMjcvZG1lc2ctcXVhbnRhbC1pdmI0MS0xOToyMDE0
MDYyMzE1NDIwODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMx
LTAwMDEzLWdmOTNkM2U0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIz
MTQ1Ny9mOTNkM2U0OWVhMTYwOWZlN2M3ODI4YTk0YjE2NjE5ZmY2OGM0ZjI3L2RtZXNnLXF1
YW50YWwtaXZiNDEtMjM6MjAxNDA2MjMxNTQyMTU6eDg2XzY0LXJhbmRjb25maWctaHN4YTEt
MDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMy1nZjkzZDNlNDoxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTEtMDYyMzE0NTcvZjkzZDNlNDllYTE2MDlmZTdjNzgyOGE5NGIxNjYx
OWZmNjhjNGYyNy9kbWVzZy1xdWFudGFsLWl2YjQxLTU6MjAxNDA2MjMxNTQyMTA6eDg2XzY0
LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMy1nZjkzZDNlNDox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvZjkzZDNlNDllYTE2
MDlmZTdjNzgyOGE5NGIxNjYxOWZmNjhjNGYyNy9kbWVzZy1xdWFudGFsLWl2YjQxLTY6MjAx
NDA2MjMxNTQyMTQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4xNi4wLXJj
MS0wMDAxMy1nZjkzZDNlNDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYy
MzE0NTcvZjkzZDNlNDllYTE2MDlmZTdjNzgyOGE5NGIxNjYxOWZmNjhjNGYyNy9kbWVzZy1x
dWFudGFsLWl2YjQxLTgxOjIwMTQwNjIzMTU0MjA4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEx
LTA2MjMxNDU3OjMuMTYuMC1yYzEtMDAwMTMtZ2Y5M2QzZTQ6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2Y5M2QzZTQ5ZWExNjA5ZmU3Yzc4MjhhOTRiMTY2
MTlmZjY4YzRmMjcvZG1lc2ctcXVhbnRhbC1pdmI0Mi0xMTY6MjAxNDA2MjMxNTQyMTc6eDg2
XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMy1nZjkzZDNl
NDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvZjkzZDNlNDll
YTE2MDlmZTdjNzgyOGE5NGIxNjYxOWZmNjhjNGYyNy9kbWVzZy1xdWFudGFsLWl2YjQyLTEy
NDoyMDE0MDYyMzE1NDIxOTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2
LjAtcmMxLTAwMDEzLWdmOTNkM2U0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MS0wNjIzMTQ1Ny9mOTNkM2U0OWVhMTYwOWZlN2M3ODI4YTk0YjE2NjE5ZmY2OGM0ZjI3L2Rt
ZXNnLXF1YW50YWwtaXZiNDItNTc6MjAxNDA2MjMxNTQyMTg6eDg2XzY0LXJhbmRjb25maWct
aHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMy1nZjkzZDNlNDoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvZjkzZDNlNDllYTE2MDlmZTdjNzgyOGE5
NGIxNjYxOWZmNjhjNGYyNy9kbWVzZy1xdWFudGFsLWl2YjQyLTc1OjIwMTQwNjIzMTU0MjEy
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYuMC1yYzEtMDAwMTMtZ2Y5
M2QzZTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2Y5M2Qz
ZTQ5ZWExNjA5ZmU3Yzc4MjhhOTRiMTY2MTlmZjY4YzRmMjcvZG1lc2cteW9jdG8taXZiNDEt
MTE2OjIwMTQwNjIzMTU0MjA3Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMu
MTYuMC1yYzEtMDAwMTMtZ2Y5M2QzZTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGExLTA2MjMxNDU3L2Y5M2QzZTQ5ZWExNjA5ZmU3Yzc4MjhhOTRiMTY2MTlmZjY4YzRmMjcv
ZG1lc2cteW9jdG8taXZiNDItNDI6MjAxNDA2MjMxNTQyMTk6eDg2XzY0LXJhbmRjb25maWct
aHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMy1nZjkzZDNlNDoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvZjkzZDNlNDllYTE2MDlmZTdjNzgyOGE5
NGIxNjYxOWZmNjhjNGYyNy9kbWVzZy1xdWFudGFsLWl2YjQxLTE5OjIwMTQwNjIzMTU0MjE4
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYuMC1yYzEtMDAwMTMtZ2Y5
M2QzZTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2Y5M2Qz
ZTQ5ZWExNjA5ZmU3Yzc4MjhhOTRiMTY2MTlmZjY4YzRmMjcvZG1lc2ctcXVhbnRhbC1pdmI0
MS04MToyMDE0MDYyMzE1NDIxOTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Nzoz
LjE2LjAtcmMxLTAwMDEzLWdmOTNkM2U0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMS0wNjIzMTQ1Ny9mOTNkM2U0OWVhMTYwOWZlN2M3ODI4YTk0YjE2NjE5ZmY2OGM0ZjI3
L2RtZXNnLXF1YW50YWwtaXZiNDItNzU6MjAxNDA2MjMxNTQyMjI6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMy1nZjkzZDNlNDoxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvZjkzZDNlNDllYTE2MDlmZTdjNzgy
OGE5NGIxNjYxOWZmNjhjNGYyNy9kbWVzZy15b2N0by1pdmI0MS0xMTY6MjAxNDA2MjMxNTQy
MTc6eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMy1n
ZjkzZDNlNDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvZjkz
ZDNlNDllYTE2MDlmZTdjNzgyOGE5NGIxNjYxOWZmNjhjNGYyNy9kbWVzZy15b2N0by1pdmI0
Mi0xNDoyMDE0MDYyMzE1NDIyMTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Nzoz
LjE2LjAtcmMxLTAwMDEzLWdmOTNkM2U0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMS0wNjIzMTQ1Ny9mOTNkM2U0OWVhMTYwOWZlN2M3ODI4YTk0YjE2NjE5ZmY2OGM0ZjI3
L2RtZXNnLXF1YW50YWwtaXZiNDEtNToyMDE0MDYyMzE1NDIyMDp4ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMxLTAwMDEzLWdmOTNkM2U0OjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny9mOTNkM2U0OWVhMTYwOWZlN2M3ODI4
YTk0YjE2NjE5ZmY2OGM0ZjI3L2RtZXNnLXF1YW50YWwtaXZiNDItMTU6MjAxNDA2MjMxNTQy
Mjc6eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMy1n
ZjkzZDNlNDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvZjkz
ZDNlNDllYTE2MDlmZTdjNzgyOGE5NGIxNjYxOWZmNjhjNGYyNy9kbWVzZy15b2N0by1pdmI0
MS0xMDk6MjAxNDA2MjMxNTQyMjM6eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6
My4xNi4wLXJjMS0wMDAxMy1nZjkzZDNlNDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHN4YTEtMDYyMzE0NTcvZjkzZDNlNDllYTE2MDlmZTdjNzgyOGE5NGIxNjYxOWZmNjhjNGYy
Ny9kbWVzZy15b2N0by1pdmI0Mi0xMDQ6MjAxNDA2MjMxNTQyMjQ6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMy1nZjkzZDNlNDoxCjA6MjA6MjAg
YWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDYtMjMgMTU6NDM6MDMg
UkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdC8u
cmVwZWF0G1swbQoKQmlzZWN0aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDEgc3RlcCkKWzZjZTA2MGE4NzM4YjM2YzYwYWQ0YjI1NjdkMzkzMTMy
YjI2MjAxMjFdIERldmljZS9jb3JlOiBBZGQgcGxhdGZvcm1fZGV2X2F0dGFjaC9kZXRhY2hf
bm90aWZ5KCkgY2FsbGJhY2sKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0w
NjIzMTQ1Ny9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2MjMxNDo2Y2UwNjBhODcz
OGIzNmM2MGFkNGIyNTY3ZDM5MzEzMmIyNjIwMTIxOmJpc2VjdC1saW51eDYKCjIwMTQtMDYt
MjMtMTU6NDM6MDQgNmNlMDYwYTg3MzhiMzZjNjBhZDRiMjU2N2QzOTMxMzJiMjYyMDEyMSBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny02Y2UwNjBhODczOGIzNmM2MGFk
NGIyNTY3ZDM5MzEzMmIyNjIwMTIxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny82Y2UwNjBhODczOGIzNmM2MGFkNGIyNTY3
ZDM5MzEzMmIyNjIwMTIxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny02Y2UwNjBh
ODczOGIzNmM2MGFkNGIyNTY3ZDM5MzEzMmIyNjIwMTIxCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaHN4
YTEtMDYyMzE0NTctNmNlMDYwYTg3MzhiMzZjNjBhZDRiMjU2N2QzOTMxMzJiMjYyMDEyMQpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvNmNlMDYw
YTg3MzhiMzZjNjBhZDRiMjU2N2QzOTMxMzJiMjYyMDEyMS92bWxpbnV6LTMuMTYuMC1yYzEt
MDAwMTEtZzZjZTA2MGEKCjIwMTQtMDYtMjMtMTU6NDY6MDQgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjE2NDAzNl0gICAgcHJlZmV0Y2g2NC1zc2U6ICAg
MTQ3LjAwMCBNQi9zZWMKWyAgICAwLjIwNDAyNV0gICAgZ2VuZXJpY19zc2U6ICAgMTQ2LjAw
MCBNQi9zZWMKWyAgICAwLjIwNDQwMl0geG9yOiB1c2luZyBmdW5jdGlvbjogcHJlZmV0Y2g2
NC1zc2UgKDE0Ny4wMDAgTUIvc2VjKQpbICAgIDAuMjA1NTkxXSBCVUc6IHVuYWJsZSB0byBo
YW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgICAgICAgICAgKG51
bGwpClsgICAgMC4yMDYzMDJdIElQOiBbPCAgICAgICAgICAobnVsbCk+XSAgICAgICAgICAg
KG51bGwpClsgICAgMC4yMDY3NTddIFBHRCAwIApbICAgIDAuMjA2OTU0XSBPb3BzOiAwMDEw
IFsjMV0gUFJFRU1QVCBTTVAgREVCVUdfUEFHRUFMTE9DClsgICAgMC4yMDc0NzJdIENQVTog
MCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTYuMC1yYzEtMDAwMTEt
ZzZjZTA2MGEgIzEKWyAgICAwLjIwODAwMF0gdGFzazogZmZmZjg4MDAxMTRjODAwMCB0aTog
ZmZmZjg4MDAxMTRjNDAwMCB0YXNrLnRpOiBmZmZmODgwMDExNGM0MDAwClsgICAgMC4yMDgw
MDBdIFJJUDogMDAxMDpbPDAwMDAwMDAwMDAwMDAwMDA+XSAgWzwgICAgICAgICAgKG51bGwp
Pl0gICAgICAgICAgIChudWxsKQpbICAgIDAuMjA4MDAwXSBSU1A6IDAwMDA6ZmZmZjg4MDAx
MTRjN2Q2OCAgRUZMQUdTOiAwMDAxMDI0NgpbICAgIDAuMjA4MDAwXSBSQVg6IGZmZmY4ODAw
MTE0YWJiZTggUkJYOiBmZmZmODgwMDExNGFiN2MwIFJDWDogMDAwMDAwMDAwMDAwMDA4Zgpb
ICAgIDAuMjA4MDAwXSBSRFg6IDAwMDAwMDAwMDAwMDAwMDEgUlNJOiAwMDAwMDAwMDAwMDAw
MDAwIFJESTogZmZmZjg4MDAxMTRhYjdjMApbICAgIDAuMjA4MDAwXSBSQlA6IGZmZmY4ODAw
MTE0YzdkOTAgUjA4OiAwMDAwMDAwMDAwMDAwMDAyIFIwOTogMDAwMDAwMDAwMDExZTA4Zgpb
ICAgIDAuMjA4MDAwXSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMWQy
ZjkwIFIxMjogZmZmZmZmZmY4MjdmZGE5OApbICAgIDAuMjA4MDAwXSBSMTM6IGZmZmZmZmZm
ODI3ZmRhOTggUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMDAwMDAwMApb
ICAgIDAuMjA4MDAwXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4MDAx
MjIwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgMC4yMDgwMDBdIENT
OiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICAw
LjIwODAwMF0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAwMjYwZDAwMCBD
UjQ6IDAwMDAwMDAwMDAwMDA2ZjAKWyAgICAwLjIwODAwMF0gU3RhY2s6ClsgICAgMC4yMDgw
MDBdICBmZmZmZmZmZjgxNmVlMWE3IGZmZmY4ODAwMTE0YWI3YzAgZmZmZmZmZmY4MjdmZGE5
OCBmZmZmODgwMDExNGFiODIwClsgICAgMC4yMDgwMDBdICAwMDAwMDAwMDAwMDAwMDAwIGZm
ZmY4ODAwMTE0YzdkYjggZmZmZmZmZmY4MTZlZTRjNiAwMDAwMDAwMDAwMDAwMDAwClsgICAg
MC4yMDgwMDBdICBmZmZmZmZmZjgyN2ZkYTk4IGZmZmZmZmZmODE2ZWU0MzEgZmZmZjg4MDAx
MTRjN2RmMCBmZmZmZmZmZjgxNmVjMDg0ClsgICAgMC4yMDgwMDBdIENhbGwgVHJhY2U6Clsg
ICAgMC4yMDgwMDBdICBbPGZmZmZmZmZmODE2ZWUxYTc+XSA/IGRyaXZlcl9wcm9iZV9kZXZp
Y2UrMHg4Yy8weDMxNgpbICAgIDAuMjA4MDAwXSAgWzxmZmZmZmZmZjgxNmVlNGM2Pl0gX19k
cml2ZXJfYXR0YWNoKzB4OTUvMHhkMwpbICAgIDAuMjA4MDAwXSAgWzxmZmZmZmZmZjgxNmVl
NDMxPl0gPyBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4MzE2LzB4MzE2ClsgICAgMC4yMDgwMDBd
ICBbPGZmZmZmZmZmODE2ZWMwODQ+XSBidXNfZm9yX2VhY2hfZGV2KzB4YmUvMHhjOQpbICAg
IDAuMjA4MDAwXSAgWzxmZmZmZmZmZjgxNmVlNjViPl0gZHJpdmVyX2F0dGFjaCsweDIwLzB4
MjkKWyAgICAwLjIwODAwMF0gIFs8ZmZmZmZmZmY4MTZlY2M1ZD5dIGJ1c19hZGRfZHJpdmVy
KzB4MTEyLzB4MmFiClsgICAgMC4yMDgwMDBdICBbPGZmZmZmZmZmODE2ZWVmZTM+XSBkcml2
ZXJfcmVnaXN0ZXIrMHhlYy8weDE1MgpbICAgIDAuMjA4MDAwXSAgWzxmZmZmZmZmZjgxNmYw
OTZmPl0gX19wbGF0Zm9ybV9kcml2ZXJfcmVnaXN0ZXIrMHg2MS8weDZhClsgICAgMC4yMDgw
MDBdICBbPGZmZmZmZmZmODJjODFjYTc+XSByZWd1bGF0b3JfZHVtbXlfaW5pdCsweGEwLzB4
ZGUKWyAgICAwLjIwODAwMF0gIFs8ZmZmZmZmZmY4MmM4MWEyZj5dIHJlZ3VsYXRvcl9pbml0
KzB4OTAvMHg5YwpbICAgIDAuMjA4MDAwXSAgWzxmZmZmZmZmZjgyYzgxOTlmPl0gPyB2aXJ0
aW9fYmFsbG9vbl9kcml2ZXJfaW5pdCsweDIwLzB4MjAKWyAgICAwLjIwODAwMF0gIFs8ZmZm
ZmZmZmY4MmM0ODZlOT5dIGRvX29uZV9pbml0Y2FsbCsweDE3MS8weDI0OApbICAgIDAuMjA4
MDAwXSAgWzxmZmZmZmZmZjgxMGUyZjAwPl0gPyBwYXJhbWVxKzB4Ni8weDJkClsgICAgMC4y
MDgwMDBdICBbPGZmZmZmZmZmODEwZTMxYmQ+XSA/IHBhcnNlX2FyZ3MrMHgyOTYvMHgzZTgK
WyAgICAwLjIwODAwMF0gIFs8ZmZmZmZmZmY4MmM0OGFhOT5dIGtlcm5lbF9pbml0X2ZyZWVh
YmxlKzB4MmU5LzB4M2U4ClsgICAgMC4yMDgwMDBdICBbPGZmZmZmZmZmODJjNDc5MTE+XSA/
IGRvX2Vhcmx5X3BhcmFtKzB4ZDcvMHhkNwpbICAgIDAuMjA4MDAwXSAgWzxmZmZmZmZmZjgx
Y2FmNmExPl0gPyByZXN0X2luaXQrMHgxMTUvMHgxMTUKWyAgICAwLjIwODAwMF0gIFs8ZmZm
ZmZmZmY4MWNhZjZiMT5dIGtlcm5lbF9pbml0KzB4MTAvMHgxNzUKWyAgICAwLjIwODAwMF0g
IFs8ZmZmZmZmZmY4MWNkNTMzYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMC4y
MDgwMDBdICBbPGZmZmZmZmZmODFjYWY2YTE+XSA/IHJlc3RfaW5pdCsweDExNS8weDExNQpb
ICAgIDAuMjA4MDAwXSBDb2RlOiAgQmFkIFJJUCB2YWx1ZS4KWyAgICAwLjIwODAwMF0gUklQ
ICBbPCAgICAgICAgICAobnVsbCk+XSAgICAgICAgICAgKG51bGwpClsgICAgMC4yMDgwMDBd
ICBSU1AgPGZmZmY4ODAwMTE0YzdkNjg+ClsgICAgMC4yMDgwMDBdIENSMjogMDAwMDAwMDAw
MDAwMDAwMApbICAgIDAuMjA4MDAwXSAtLS1bIGVuZCB0cmFjZSAzODdlMGI1YTU0NGYyM2Vm
IF0tLS0KWyAgICAwLjIwODAwMF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0t
LS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvNmNlMDYwYTg3
MzhiMzZjNjBhZDRiMjU2N2QzOTMxMzJiMjYyMDEyMS9kbWVzZy1xdWFudGFsLWl2YjQxLTU2
OjIwMTQwNjIzMTU0NTM0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYu
MC1yYzEtMDAwMTEtZzZjZTA2MGE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEx
LTA2MjMxNDU3LzZjZTA2MGE4NzM4YjM2YzYwYWQ0YjI1NjdkMzkzMTMyYjI2MjAxMjEvZG1l
c2ctcXVhbnRhbC1pdmI0MS05MzoyMDE0MDYyMzE1NDUzNDp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMxLTAwMDExLWc2Y2UwNjBhOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny82Y2UwNjBhODczOGIzNmM2MGFkNGIyNTY3
ZDM5MzEzMmIyNjIwMTIxL2RtZXNnLXF1YW50YWwtaXZiNDItMTA1OjIwMTQwNjIzMTU0NTQx
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYuMC1yYzEtMDAwMTEtZzZj
ZTA2MGE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LzZjZTA2
MGE4NzM4YjM2YzYwYWQ0YjI1NjdkMzkzMTMyYjI2MjAxMjEvZG1lc2cteW9jdG8taXZiNDEt
MTE3OjIwMTQwNjIzMTU0NTM0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMu
MTYuMC1yYzEtMDAwMTEtZzZjZTA2MGE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGExLTA2MjMxNDU3LzZjZTA2MGE4NzM4YjM2YzYwYWQ0YjI1NjdkMzkzMTMyYjI2MjAxMjEv
ZG1lc2cteW9jdG8taXZiNDEtMjY6MjAxNDA2MjMxNTQ1MzQ6eDg2XzY0LXJhbmRjb25maWct
aHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMS1nNmNlMDYwYToxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvNmNlMDYwYTg3MzhiMzZjNjBhZDRiMjU2
N2QzOTMxMzJiMjYyMDEyMS9kbWVzZy15b2N0by1pdmI0MS02NDoyMDE0MDYyMzE1NDUzNDp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMxLTAwMDExLWc2Y2Uw
NjBhOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny82Y2UwNjBh
ODczOGIzNmM2MGFkNGIyNTY3ZDM5MzEzMmIyNjIwMTIxL2RtZXNnLXlvY3RvLWl2YjQyLTEy
ODoyMDE0MDYyMzE1NDUzODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2
LjAtcmMxLTAwMDExLWc2Y2UwNjBhOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MS0wNjIzMTQ1Ny82Y2UwNjBhODczOGIzNmM2MGFkNGIyNTY3ZDM5MzEzMmIyNjIwMTIxL2Rt
ZXNnLXlvY3RvLWl2YjQyLTE6MjAxNDA2MjMxNTQ1NDY6eDg2XzY0LXJhbmRjb25maWctaHN4
YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMS1nNmNlMDYwYToxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvNmNlMDYwYTg3MzhiMzZjNjBhZDRiMjU2N2Qz
OTMxMzJiMjYyMDEyMS9kbWVzZy15b2N0by1pdmI0Mi03MToyMDE0MDYyMzE1NDU0Njp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMxLTAwMDExLWc2Y2UwNjBh
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny82Y2UwNjBhODcz
OGIzNmM2MGFkNGIyNTY3ZDM5MzEzMmIyNjIwMTIxL2RtZXNnLXlvY3RvLWl2YjQyLTk4OjIw
MTQwNjIzMTU0NTM4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYuMC1y
YzEtMDAwMTEtZzZjZTA2MGE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2
MjMxNDU3LzZjZTA2MGE4NzM4YjM2YzYwYWQ0YjI1NjdkMzkzMTMyYjI2MjAxMjEvZG1lc2ct
eW9jdG8taXZiNDItOTk6MjAxNDA2MjMxNTQ1Mzg6eDg2XzY0LXJhbmRjb25maWctaHN4YTEt
MDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMS1nNmNlMDYwYToxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTEtMDYyMzE0NTcvNmNlMDYwYTg3MzhiMzZjNjBhZDRiMjU2N2QzOTMx
MzJiMjYyMDEyMS9kbWVzZy1xdWFudGFsLWl2YjQxLTY6MjAxNDA2MjMxNTQ1NDQ6eDg2XzY0
LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMS1nNmNlMDYwYTox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvNmNlMDYwYTg3Mzhi
MzZjNjBhZDRiMjU2N2QzOTMxMzJiMjYyMDEyMS9kbWVzZy1xdWFudGFsLWl2YjQyLTEyMjoy
MDE0MDYyMzE1NDU1Mjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAt
cmMxLTAwMDExLWc2Y2UwNjBhOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0w
NjIzMTQ1Ny82Y2UwNjBhODczOGIzNmM2MGFkNGIyNTY3ZDM5MzEzMmIyNjIwMTIxL2RtZXNn
LXlvY3RvLWl2YjQxLTEwNDoyMDE0MDYyMzE1NDU0NDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MS0wNjIzMTQ1NzozLjE2LjAtcmMxLTAwMDExLWc2Y2UwNjBhOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny82Y2UwNjBhODczOGIzNmM2MGFkNGIyNTY3ZDM5
MzEzMmIyNjIwMTIxL2RtZXNnLXlvY3RvLWl2YjQxLTExNzoyMDE0MDYyMzE1NDU0NDp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMxLTAwMDExLWc2Y2UwNjBh
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny82Y2UwNjBhODcz
OGIzNmM2MGFkNGIyNTY3ZDM5MzEzMmIyNjIwMTIxL2RtZXNnLXlvY3RvLWl2YjQxLTEyMjoy
MDE0MDYyMzE1NDU0NDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAt
cmMxLTAwMDExLWc2Y2UwNjBhOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0w
NjIzMTQ1Ny82Y2UwNjBhODczOGIzNmM2MGFkNGIyNTY3ZDM5MzEzMmIyNjIwMTIxL2RtZXNn
LXlvY3RvLWl2YjQxLTI2OjIwMTQwNjIzMTU0NTQ0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEx
LTA2MjMxNDU3OjMuMTYuMC1yYzEtMDAwMTEtZzZjZTA2MGE6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LzZjZTA2MGE4NzM4YjM2YzYwYWQ0YjI1NjdkMzkz
MTMyYjI2MjAxMjEvZG1lc2cteW9jdG8taXZiNDEtMzg6MjAxNDA2MjMxNTQ1NDQ6eDg2XzY0
LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4xNi4wLXJjMS0wMDAxMS1nNmNlMDYwYTox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvNmNlMDYwYTg3Mzhi
MzZjNjBhZDRiMjU2N2QzOTMxMzJiMjYyMDEyMS9kbWVzZy15b2N0by1pdmI0Mi0zNToyMDE0
MDYyMzE1NDU0ODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMx
LTAwMDExLWc2Y2UwNjBhOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIz
MTQ1Ny82Y2UwNjBhODczOGIzNmM2MGFkNGIyNTY3ZDM5MzEzMmIyNjIwMTIxL2RtZXNnLXlv
Y3RvLWl2YjQyLTY1OjIwMTQwNjIzMTU0NTQ4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2
MjMxNDU3OjMuMTYuMC1yYzEtMDAwMTEtZzZjZTA2MGE6MQowOjIwOjIwIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA2LTIzIDE1OjQ2OjM1IFJFUEVBVCBDT1VO
VDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QvLnJlcGVhdBtbMG0K
CkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMCBzdGVwcykKWzk2ZThjMWE3YzM2YmE3ZTE0NjQ0YWJhNTQ0MjgzZmY0ZGZhMmJmZjhd
IEkyQy9BQ1BJOiBDbGVhbiB1cCBJMkMgQUNQSSBjb2RlIGFuZCBBZGQgQ09ORklHX0kyQ19B
Q1BJIGNvbmZpZwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYyMzE0Ojk2ZThjMWE3YzM2YmE3ZTE0
NjQ0YWJhNTQ0MjgzZmY0ZGZhMmJmZjg6YmlzZWN0LWxpbnV4NgoKMjAxNC0wNi0yMy0xNTo0
NjozNSA5NmU4YzFhN2MzNmJhN2UxNDY0NGFiYTU0NDI4M2ZmNGRmYTJiZmY4IGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LTk2ZThjMWE3YzM2YmE3ZTE0NjQ0YWJhNTQ0
MjgzZmY0ZGZhMmJmZjgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGExLTA2MjMxNDU3Lzk2ZThjMWE3YzM2YmE3ZTE0NjQ0YWJhNTQ0MjgzZmY0
ZGZhMmJmZjgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3LTk2ZThjMWE3YzM2YmE3
ZTE0NjQ0YWJhNTQ0MjgzZmY0ZGZhMmJmZjgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIz
MTQ1Ny05NmU4YzFhN2MzNmJhN2UxNDY0NGFiYTU0NDI4M2ZmNGRmYTJiZmY4Cmtlcm5lbDog
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny85NmU4YzFhN2MzNmJh
N2UxNDY0NGFiYTU0NDI4M2ZmNGRmYTJiZmY4L3ZtbGludXotMy4xNi4wLXJjMS0wMDAxMC1n
OTZlOGMxYQoKMjAxNC0wNi0yMy0xNTo0ODozNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMTQJ
MTkJMjAgU1VDQ0VTUwoKNmNlMDYwYTg3MzhiMzZjNjBhZDRiMjU2N2QzOTMxMzJiMjYyMDEy
MSBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgNmNlMDYwYTg3MzhiMzZjNjBhZDRi
MjU2N2QzOTMxMzJiMjYyMDEyMQpBdXRob3I6IExhbiBUaWFueXUgPHRpYW55dS5sYW5AaW50
ZWwuY29tPgpEYXRlOiAgIFRodSBBcHIgMTAgMTM6MTg6NDMgMjAxNCArMDgwMAoKICAgIERl
dmljZS9jb3JlOiBBZGQgcGxhdGZvcm1fZGV2X2F0dGFjaC9kZXRhY2hfbm90aWZ5KCkgY2Fs
bGJhY2sKICAgIAogICAgRm9yIEFDUEkgcGxhdGZvcm0sIEFDUEkgdGFibGUgcHJvdmlkZXMg
ZGV2aWNlIHByb2JlIGRlcGVuZGVuY3kgaW5mb3JtYXRpb24KICAgIGFuZCBBQ1BJIHN1YnN5
c3RlbSBuZWVkcyB0byBjaGVjayB0aGUgZHJpdmVyIHByb2Jpbmcgc3RhdHVzIG9mIGRlcGVu
ZGVudAogICAgZGV2aWNlcy4gVGhpcyBwYXRjaCBpcyB0byBhZGQgdHdvIGNhbGxiYWNrcyB0
byBub3RpZnkgcGxhdGZvcm0gd2hlbiBkZXZpY2UKICAgIGlzIGF0dGFjaGVkIGFuZCBkZXRh
Y2hlZCBmcm9tIGRyaXZlci4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogTGFuIFRpYW55dSA8
dGlhbnl1LmxhbkBpbnRlbC5jb20+Cgo6MDQwMDAwIDA0MDAwMCA3ZDYzM2JiODkzODUzN2Rh
MGRjZjYwNDQ5ZjFhZjEwMjI2ZTA1MWVlIGFmZDQ4Yzk4YjVlOWExNWYzZDA0NTRhM2Q5YTdl
NWVjYWFmZWUzM2QgTQlkcml2ZXJzCjowNDAwMDAgMDQwMDAwIGM1MjhhMjJlYThiMzJkZmVi
ZGU3ZThjNzAxMjQ3ODMxNDNhYTRkMzkgNzcxYmM2NjI1ZGFiMGRjOGYzZjMwNThhZTFlZmUw
MWU2ZTIyYzlkNiBNCWluY2x1ZGUKYmlzZWN0IHJ1biBzdWNjZXNzCkhFQUQgaXMgbm93IGF0
IDk2ZThjMWEuLi4gSTJDL0FDUEk6IENsZWFuIHVwIEkyQyBBQ1BJIGNvZGUgYW5kIEFkZCBD
T05GSUdfSTJDX0FDUEkgY29uZmlnCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDA2MjMxNDo5NmU4YzFhN2MzNmJhN2UxNDY0NGFiYTU0NDI4M2ZmNGRmYTJi
ZmY4OmJpc2VjdC1saW51eDYKCjIwMTQtMDYtMjMtMTU6NTA6MDYgOTZlOGMxYTdjMzZiYTdl
MTQ2NDRhYmE1NDQyODNmZjRkZmEyYmZmOCByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGExLTA2MjMxNDU3Lzk2ZThjMWE3YzM2YmE3ZTE0NjQ0YWJhNTQ0MjgzZmY0ZGZh
MmJmZjgvdm1saW51ei0zLjE2LjAtcmMxLTAwMDEwLWc5NmU4YzFhCgoyMDE0LTA2LTIzLTE1
OjUwOjA2IGRldGVjdGluZyBib290IHN0YXRlIC4JMjYJNDkJNTYJNjAgU1VDQ0VTUwoKUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgOTZlOGMxYS4uLiBJMkMvQUNQSTogQ2xlYW4gdXAg
STJDIEFDUEkgY29kZSBhbmQgQWRkIENPTkZJR19JMkNfQUNQSSBjb25maWcKSEVBRCBpcyBu
b3cgYXQgYWFmY2E0MS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAx
NDA2MjMxNCcKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGExLTA2MjMxNDU3L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYy
MzE0OmFhZmNhNDFiZjhiMmMwOTNiZWZhNzRlMDRjNTk1ODBhNDQwMWI4ZTk6YmlzZWN0LWxp
bnV4NgogVEVTVCBGQUlMVVJFClsgICAgMC4yNDQwMjJdICAgIHByZWZldGNoNjQtc3NlOiAg
IDEzNC4wMDAgTUIvc2VjClsgICAgMC4yODQwMzldICAgIGdlbmVyaWNfc3NlOiAgIDEzNC4w
MDAgTUIvc2VjClsgICAgMC4yODQ1OTFdIHhvcjogdXNpbmcgZnVuY3Rpb246IGdlbmVyaWNf
c3NlICgxMzQuMDAwIE1CL3NlYykKWyAgICAwLjI4NjM3NF0gQlVHOiB1bmFibGUgdG8gaGFu
ZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgICAgICAgICAgIChudWxs
KQpbICAgIDAuMjg3Mzk4XSBJUDogWzwgICAgICAgICAgKG51bGwpPl0gICAgICAgICAgIChu
dWxsKQpbICAgIDAuMjg4MDAwXSBQR0QgMCAKWyAgICAwLjI4ODAwMF0gT29wczogMDAxMCBb
IzFdIFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExPQwpbICAgIDAuMjg4MDAwXSBDUFU6IDAg
UElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmMyLTAwNTUzLWdh
YWZjYTQxICMxClsgICAgMC4yODgwMDBdIHRhc2s6IGZmZmY4ODAwMTE0YzgwMDAgdGk6IGZm
ZmY4ODAwMTE0YzQwMDAgdGFzay50aTogZmZmZjg4MDAxMTRjNDAwMApbICAgIDAuMjg4MDAw
XSBSSVA6IDAwMTA6WzwwMDAwMDAwMDAwMDAwMDAwPl0gIFs8ICAgICAgICAgIChudWxsKT5d
ICAgICAgICAgICAobnVsbCkKWyAgICAwLjI4ODAwMF0gUlNQOiAwMDAwOmZmZmY4ODAwMTE0
YzdkNjggIEVGTEFHUzogMDAwMTAyNDYKWyAgICAwLjI4ODAwMF0gUkFYOiBmZmZmODgwMDEx
NGFiYmU4IFJCWDogZmZmZjg4MDAxMTRhYjdjMCBSQ1g6IDAwMDAwMDAwMDAwMDAwOGYKWyAg
ICAwLjI4ODAwMF0gUkRYOiAwMDAwMDAwMDAwMDAwMDAxIFJTSTogMDAwMDAwMDAwMDAwMDAw
MCBSREk6IGZmZmY4ODAwMTE0YWI3YzAKWyAgICAwLjI4ODAwMF0gUkJQOiBmZmZmODgwMDEx
NGM3ZDkwIFIwODogMDAwMDAwMDAwMDAwMDAwMiBSMDk6IDAwMDAwMDAwMDAxMWUwOGYKWyAg
ICAwLjI4ODAwMF0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDFkMmY5
MCBSMTI6IGZmZmZmZmZmODI3ZmRlNTgKWyAgICAwLjI4ODAwMF0gUjEzOiBmZmZmZmZmZjgy
N2ZkZTU4IFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
ICAwLjI4ODAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMTIy
MDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMjg4MDAwXSBDUzog
IDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMC4y
ODgwMDBdIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMDI2MGQwMDAgQ1I0
OiAwMDAwMDAwMDAwMDAwNmYwClsgICAgMC4yODgwMDBdIFN0YWNrOgpbICAgIDAuMjg4MDAw
XSAgZmZmZmZmZmY4MTZlZjNlZSBmZmZmODgwMDExNGFiN2MwIGZmZmZmZmZmODI3ZmRlNTgg
ZmZmZjg4MDAxMTRhYjgyMApbICAgIDAuMjg4MDAwXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZm
ODgwMDExNGM3ZGI4IGZmZmZmZmZmODE2ZWY3MGQgMDAwMDAwMDAwMDAwMDAwMApbICAgIDAu
Mjg4MDAwXSAgZmZmZmZmZmY4MjdmZGU1OCBmZmZmZmZmZjgxNmVmNjc4IGZmZmY4ODAwMTE0
YzdkZjAgZmZmZmZmZmY4MTZlZDJjYgpbICAgIDAuMjg4MDAwXSBDYWxsIFRyYWNlOgpbICAg
IDAuMjg4MDAwXSAgWzxmZmZmZmZmZjgxNmVmM2VlPl0gPyBkcml2ZXJfcHJvYmVfZGV2aWNl
KzB4OGMvMHgzMTYKWyAgICAwLjI4ODAwMF0gIFs8ZmZmZmZmZmY4MTZlZjcwZD5dIF9fZHJp
dmVyX2F0dGFjaCsweDk1LzB4ZDMKWyAgICAwLjI4ODAwMF0gIFs8ZmZmZmZmZmY4MTZlZjY3
OD5dID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDMxNi8weDMxNgpbICAgIDAuMjg4MDAwXSAg
WzxmZmZmZmZmZjgxNmVkMmNiPl0gYnVzX2Zvcl9lYWNoX2RldisweGJlLzB4YzkKWyAgICAw
LjI4ODAwMF0gIFs8ZmZmZmZmZmY4MTZlZjhhMj5dIGRyaXZlcl9hdHRhY2grMHgyMC8weDI5
ClsgICAgMC4yODgwMDBdICBbPGZmZmZmZmZmODE2ZWRlYTQ+XSBidXNfYWRkX2RyaXZlcisw
eDExMi8weDJhYgpbICAgIDAuMjg4MDAwXSAgWzxmZmZmZmZmZjgxNmYwMjJhPl0gZHJpdmVy
X3JlZ2lzdGVyKzB4ZWMvMHgxNTIKWyAgICAwLjI4ODAwMF0gIFs8ZmZmZmZmZmY4MTZmMWJi
Nj5dIF9fcGxhdGZvcm1fZHJpdmVyX3JlZ2lzdGVyKzB4NjEvMHg2YQpbICAgIDAuMjg4MDAw
XSAgWzxmZmZmZmZmZjgyYzgxOWE0Pl0gcmVndWxhdG9yX2R1bW15X2luaXQrMHhhMC8weGRl
ClsgICAgMC4yODgwMDBdICBbPGZmZmZmZmZmODJjODE3MmM+XSByZWd1bGF0b3JfaW5pdCsw
eDkwLzB4OWMKWyAgICAwLjI4ODAwMF0gIFs8ZmZmZmZmZmY4MmM4MTY5Yz5dID8gdmlydGlv
X2JhbGxvb25fZHJpdmVyX2luaXQrMHgyMC8weDIwClsgICAgMC4yODgwMDBdICBbPGZmZmZm
ZmZmODJjNDg2ZTk+XSBkb19vbmVfaW5pdGNhbGwrMHgxNzEvMHgyNDgKWyAgICAwLjI4ODAw
MF0gIFs8ZmZmZmZmZmY4MTBlMmYwMD5dID8gcGFyYW1fYXJyYXlfc2V0KzB4MTQzLzB4MTVj
ClsgICAgMC4yODgwMDBdICBbPGZmZmZmZmZmODEwZTMyMzc+XSA/IHBhcnNlX2FyZ3MrMHgy
OTYvMHgzZTgKWyAgICAwLjI4ODAwMF0gIFs8ZmZmZmZmZmY4MmM0OGFhOT5dIGtlcm5lbF9p
bml0X2ZyZWVhYmxlKzB4MmU5LzB4M2U4ClsgICAgMC4yODgwMDBdICBbPGZmZmZmZmZmODJj
NDc5MTE+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ZDcvMHhkNwpbICAgIDAuMjg4MDAwXSAgWzxm
ZmZmZmZmZjgxY2IwYzcxPl0gPyByZXN0X2luaXQrMHgxMTUvMHgxMTUKWyAgICAwLjI4ODAw
MF0gIFs8ZmZmZmZmZmY4MWNiMGM4MT5dIGtlcm5lbF9pbml0KzB4MTAvMHgxNzUKWyAgICAw
LjI4ODAwMF0gIFs8ZmZmZmZmZmY4MWNkNjkzYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIw
ClsgICAgMC4yODgwMDBdICBbPGZmZmZmZmZmODFjYjBjNzE+XSA/IHJlc3RfaW5pdCsweDEx
NS8weDExNQpbICAgIDAuMjg4MDAwXSBDb2RlOiAgQmFkIFJJUCB2YWx1ZS4KWyAgICAwLjI4
ODAwMF0gUklQICBbPCAgICAgICAgICAobnVsbCk+XSAgICAgICAgICAgKG51bGwpClsgICAg
MC4yODgwMDBdICBSU1AgPGZmZmY4ODAwMTE0YzdkNjg+ClsgICAgMC4yODgwMDBdIENSMjog
MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMjg4MDAwXSAtLS1bIGVuZCB0cmFjZSBkYTczNmVh
YzRmMmZiOWU3IF0tLS0KWyAgICAwLjI4ODAwMF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBd
LS0tLS0tLS0tLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcv
YWFmY2E0MWJmOGIyYzA5M2JlZmE3NGUwNGM1OTU4MGE0NDAxYjhlOS9kbWVzZy15b2N0by1p
dmI0MS01NjoyMDE0MDYyMzE1MDcxNzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1
NzozLjE2LjAtcmMyLTAwNTUzLWdhYWZjYTQxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMS0wNjIzMTQ1Ny9hYWZjYTQxYmY4YjJjMDkzYmVmYTc0ZTA0YzU5NTgwYTQ0MDFi
OGU5L2RtZXNnLXF1YW50YWwtaXZiNDItMTIzOjIwMTQwNjIzMTUwNzIzOng4Nl82NC1yYW5k
Y29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYuMC1yYzItMDA1NTMtZ2FhZmNhNDE6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2FhZmNhNDFiZjhiMmMwOTNi
ZWZhNzRlMDRjNTk1ODBhNDQwMWI4ZTkvZG1lc2ctcXVhbnRhbC1pdmI0Mi01NToyMDE0MDYy
MzE1MDcyMjp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMyLTAw
NTUzLWdhYWZjYTQxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1
Ny9hYWZjYTQxYmY4YjJjMDkzYmVmYTc0ZTA0YzU5NTgwYTQ0MDFiOGU5L2RtZXNnLXF1YW50
YWwtaXZiNDItMTAwOjIwMTQwNjIzMTUwNzIwOng4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2
MjMxNDU3OjMuMTYuMC1yYzItMDA1NTMtZ2FhZmNhNDE6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGExLTA2MjMxNDU3L2FhZmNhNDFiZjhiMmMwOTNiZWZhNzRlMDRjNTk1ODBh
NDQwMWI4ZTkvZG1lc2ctcXVhbnRhbC1pdmI0Mi0xOToyMDE0MDYyMzE1MDcxOTp4ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMyLTAwNTUzLWdhYWZjYTQxOjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny9hYWZjYTQxYmY4YjJj
MDkzYmVmYTc0ZTA0YzU5NTgwYTQ0MDFiOGU5L2RtZXNnLXF1YW50YWwtaXZiNDEtNTc6MjAx
NDA2MjMxNTAwMDk6eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4xNi4wLXJj
Mi0wMDU1My1nYWFmY2E0MToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYy
MzE0NTcvYWFmY2E0MWJmOGIyYzA5M2JlZmE3NGUwNGM1OTU4MGE0NDAxYjhlOS9kbWVzZy1x
dWFudGFsLWl2YjQxLTY3OjIwMTQwNjIzMTUwNzI1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEx
LTA2MjMxNDU3OjMuMTYuMC1yYzItMDA1NTMtZ2FhZmNhNDE6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2FhZmNhNDFiZjhiMmMwOTNiZWZhNzRlMDRjNTk1
ODBhNDQwMWI4ZTkvZG1lc2ctcXVhbnRhbC1pdmI0MS03MDoyMDE0MDYyMzE1MDcxOTp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMyLTAwNTUzLWdhYWZjYTQx
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny9hYWZjYTQxYmY4
YjJjMDkzYmVmYTc0ZTA0YzU5NTgwYTQ0MDFiOGU5L2RtZXNnLXF1YW50YWwtaXZiNDItNjI6
MjAxNDA2MjMxNTAwMTY6eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4xNi4w
LXJjMi0wMDU1My1nYWFmY2E0MToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEt
MDYyMzE0NTcvYWFmY2E0MWJmOGIyYzA5M2JlZmE3NGUwNGM1OTU4MGE0NDAxYjhlOS9kbWVz
Zy1xdWFudGFsLWl2YjQxLTEyMjoyMDE0MDYyMzE1MDcyNDp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMyLTAwNTUzLWdhYWZjYTQxOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1Ny9hYWZjYTQxYmY4YjJjMDkzYmVmYTc0ZTA0
YzU5NTgwYTQ0MDFiOGU5L2RtZXNnLXF1YW50YWwtaXZiNDEtMTE0OjIwMTQwNjIzMTUwNzI1
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3OjMuMTYuMC1yYzItMDA1NTMtZ2Fh
ZmNhNDE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGExLTA2MjMxNDU3L2FhZmNh
NDFiZjhiMmMwOTNiZWZhNzRlMDRjNTk1ODBhNDQwMWI4ZTkvZG1lc2cteW9jdG8taXZiNDIt
Mzk6MjAxNDA2MjMxNTA3MjI6eDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTc6My4x
Ni4wLXJjMi0wMDU1My1nYWFmY2E0MToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTEtMDYyMzE0NTcvYWFmY2E0MWJmOGIyYzA5M2JlZmE3NGUwNGM1OTU4MGE0NDAxYjhlOS9k
bWVzZy15b2N0by1pdmI0MS0yMzoyMDE0MDYyMzE1MDAwNTp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMS0wNjIzMTQ1NzozLjE2LjAtcmMyLTAwNTUzLWdhYWZjYTQxOjEKMDoxMzoxMyBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQgYWFmY2E0MSAwZGF5IGhl
YWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA2MjMxNCcKCj09PT09PT09PSB1cHN0
cmVhbSA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYWFmY2E0MS4uLiAw
ZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA2MjMxNCcKSEVBRCBpcyBu
b3cgYXQgYTQ5N2MzYi4uLiBMaW51eCAzLjE2LXJjMgpscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYyMzE0NTcvbGludXM6bWFz
dGVyOmE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWU6YmlzZWN0LWxp
bnV4NgoKMjAxNC0wNi0yMy0xNTo1MjozOSBhNDk3YzNiYTFkOTdmYzY5YzFlNzhlN2I5NjQz
NWJhOGMyY2I0MmVlIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTEtMDYy
MzE0NTcvYTQ5N2MzYmExZDk3ZmM2OWMxZTc4ZTdiOTY0MzViYThjMmNiNDJlZS92bWxpbnV6
LTMuMTYuMC1yYzIKCjIwMTQtMDYtMjMtMTU6NTI6MzkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
CTIyCTI4CTMyCTQ3CTU0CTU4CTU5CTYwIFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgtbmV4
dCA9PT09PT09PT0KRnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4dAogKyAyNGYyNDQzLi4uNDIy
NGM1MSBha3BtICAgICAgIC0+IG5leHQvYWtwbSAgKGZvcmNlZCB1cGRhdGUpCiArIDcxZDI3
M2YuLi5mMDhhZjZmIGFrcG0tYmFzZSAgLT4gbmV4dC9ha3BtLWJhc2UgIChmb3JjZWQgdXBk
YXRlKQogKyA2MzM1OTRiLi4uNThhZTUwMCBtYXN0ZXIgICAgIC0+IG5leHQvbWFzdGVyICAo
Zm9yY2VkIHVwZGF0ZSkKICAgODk0ZTU1Mi4uYTQ5N2MzYiAgc3RhYmxlICAgICAtPiBuZXh0
L3N0YWJsZQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxNDA2MjMgLT4gbmV4dC0yMDE0MDYyMwpQcmV2aW91cyBIRUFEIHBvc2l0aW9u
IHdhcyBhNDk3YzNiLi4uIExpbnV4IDMuMTYtcmMyCkhFQUQgaXMgbm93IGF0IDU4YWU1MDAu
Li4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNjIzCmxzIC1hIC9r
YnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIz
MTQ1Ny9uZXh0Om1hc3Rlcjo1OGFlNTAwYTAzYTZiZjY4ZWVlMzIzYzM0MjQzMWJmZGQzZjQ2
MGI2OmJpc2VjdC1saW51eDYKCjIwMTQtMDYtMjMtMTU6NTc6MDUgNThhZTUwMGEwM2E2YmY2
OGVlZTMyM2MzNDI0MzFiZmRkM2Y0NjBiNiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0w
NjIzMTQ1Ny01OGFlNTAwYTAzYTZiZjY4ZWVlMzIzYzM0MjQzMWJmZGQzZjQ2MGI2CkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1
Ny81OGFlNTAwYTAzYTZiZjY4ZWVlMzIzYzM0MjQzMWJmZGQzZjQ2MGI2CndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMS0wNjIzMTQ1Ny01OGFlNTAwYTAzYTZiZjY4ZWVlMzIzYzM0MjQzMWJmZGQz
ZjQ2MGI2Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMS0wNjIzMTQ1
Ny81OGFlNTAwYTAzYTZiZjY4ZWVlMzIzYzM0MjQzMWJmZGQzZjQ2MGI2L3ZtbGludXotMy4x
Ni4wLXJjMi1uZXh0LTIwMTQwNjIzCgoyMDE0LTA2LTIzLTE2OjAxOjA1IGRldGVjdGluZyBi
b290IHN0YXRlIAk0CTExCTQ1CTU2CTYwIFNVQ0NFU1MKCg==
--------------060703080305070903040508
Content-Type: text/plain; charset=UTF-8;
 name="config-3.16.0-rc1-00011-g6ce060a"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.16.0-rc1-00011-g6ce060a"

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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
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
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
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
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
# CONFIG_ACORN_PARTITION_ICS is not set
# CONFIG_ACORN_PARTITION_ADFS is not set
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_CMDLINE_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
# CONFIG_X86_16BIT is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
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
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set

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
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_MCAST is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

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
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=y
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRCOMM=y
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
# CONFIG_DONGLE is not set
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_SH_IRDA=y
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=y
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_ATH3K is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_MINSTREL_HT is not set
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_MLME_DEBUG is not set
# CONFIG_MAC80211_STA_DEBUG is not set
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_PS_DEBUG=y
CONFIG_MAC80211_MPL_DEBUG=y
# CONFIG_MAC80211_MPATH_DEBUG is not set
CONFIG_MAC80211_MHWMP_DEBUG=y
CONFIG_MAC80211_MESH_SYNC_DEBUG=y
CONFIG_MAC80211_MESH_CSA_DEBUG=y
# CONFIG_MAC80211_MESH_PS_DEBUG is not set
# CONFIG_MAC80211_TDLS_DEBUG is not set
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
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
# CONFIG_PROC_EVENTS is not set
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
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
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
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_PCMCIA is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
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
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
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
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
# CONFIG_GENWQE is not set
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
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
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
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
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
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
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
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_AHCI_IMX=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_TCM_FC=y
CONFIG_ISCSI_TARGET=y
CONFIG_SBP_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=y
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

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
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
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
# CONFIG_KEYBOARD_QT2160 is not set
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
# CONFIG_KEYBOARD_ST_KEYSCAN is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_OLPC_APSP=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_SH_SCI=y
CONFIG_SERIAL_SH_SCI_NR_UARTS=2
CONFIG_SERIAL_SH_SCI_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_SC16IS7XX is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_SERIAL_ST_ASC is not set
CONFIG_SERIAL_MEN_Z135=y
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=y
CONFIG_I2C_ACPI=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
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
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EFM32=y
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RIIC is not set
CONFIG_I2C_SH_MOBILE=y
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT_LIGHT=y
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
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_MXC=y
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_88PM860X is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX14577=y
# CONFIG_CHARGER_MAX8998 is not set
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_RCAR_THERMAL is not set
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# Texas Instruments thermal drivers
#
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
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_AXP20X=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LTC3589=y
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PBIAS=y
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS6586X=y
# CONFIG_REGULATOR_TPS80031 is not set
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_AS3711 is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_VGASTATE is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
# CONFIG_HID_APPLE is not set
CONFIG_HID_APPLEIR=y
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_HUION=y
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
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
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_OTG_FSM is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_XHCI_MVEBU=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y
# CONFIG_USB_DWC3_GADGET is not set
# CONFIG_USB_DWC3_DUAL_ROLE is not set

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
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_HOST=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_SIMPLE=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_F81232=y
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QW is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
# CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_METRO=y
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MXUPORT=y
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=y
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_XSENS_MT=y
CONFIG_USB_SERIAL_WISHBONE=y
# CONFIG_USB_SERIAL_ZTE is not set
CONFIG_USB_SERIAL_SSU100=y
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_KEYSTONE_USB_PHY is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_TAHVO_USB=y
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
CONFIG_USB_ISP1301=y
# CONFIG_USB_MSM_OTG is not set
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_RCAR_GEN2_PHY=y
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
CONFIG_USB_GR_UDC=y
CONFIG_USB_R8A66597=y
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
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_F_ECM=y
CONFIG_USB_F_SUBSET=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
# CONFIG_USB_ETH_RNDIS is not set
# CONFIG_USB_ETH_EEM is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_MEMSTICK_REALTEK_USB is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MCE_INJ=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM860X is not set
# CONFIG_RTC_DRV_88PM80X is not set
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX8998=y
# CONFIG_RTC_DRV_MAX77686 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TPS6586X=y
# CONFIG_RTC_DRV_TPS80031 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9055 is not set
# CONFIG_RTC_DRV_DA9063 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MOXART=y
CONFIG_RTC_DRV_XGENE=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
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
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=y

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_SH_TIMER_CMT=y
# CONFIG_SH_TIMER_MTU2 is not set
CONFIG_SH_TIMER_TMU=y
CONFIG_EM_TIMER_STI=y
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
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_EXTCON_MAX14577 is not set
CONFIG_EXTCON_MAX77693=y
# CONFIG_EXTCON_PALMAS is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
# CONFIG_MMA8452 is not set

#
# Analog to digital converters
#
# CONFIG_AD799X is not set
CONFIG_MAX1363=y
CONFIG_MCP3422=y
# CONFIG_MEN_Z188_ADC is not set
# CONFIG_NAU7802 is not set
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=y
# CONFIG_VIPERBOARD_ADC is not set
CONFIG_XILINX_XADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_ITG3200=y

#
# Humidity sensors
#
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_APDS9300 is not set
CONFIG_CM32181=y
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
CONFIG_HID_SENSOR_ALS=y
CONFIG_HID_SENSOR_PROX=y
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_MAG3110=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
# CONFIG_HID_SENSOR_DEVICE_ROTATION is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=y
CONFIG_MPL115=y
# CONFIG_MPL3115 is not set
# CONFIG_IIO_ST_PRESS is not set

#
# Lightning sensors
#

#
# Temperature sensors
#
CONFIG_MLX90614=y
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_OMAP_CONTROL_PHY is not set
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=y
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

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
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
CONFIG_JFFS2_CMODE_SIZE=y
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
CONFIG_NCPFS_EXTRAS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
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
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_VMACACHE=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU_DELAY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
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
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
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
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
# CONFIG_IMA is not set
CONFIG_EVM=y

#
# EVM options
#
CONFIG_EVM_ATTR_FSUUID=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
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
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
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
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
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
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
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
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y


--------------060703080305070903040508
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

_______________________________________________
LKP mailing list
LKP@linux.intel.com


--------------060703080305070903040508--
