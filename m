Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbaG3D5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:57:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:2273 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbaG3D5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:57:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="log'?scan'208";a="569235020"
Date: Wed, 30 Jul 2014 11:57:31 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [xhci] kernel BUG at include/linux/scatterlist.h:115!
Message-ID: <20140730035731.GE16537@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JSkcQAAxhB1h8DcT"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/djbw/usb.git td-fragments-v1
commit 61d9c2ad31b11b87c319bbc2a963040742bac77c
Author:     Dan Williams <dan.j.williams@intel.com>
AuthorDate: Tue Jul 22 00:08:51 2014 -0700
Commit:     Dan Williams <dan.j.williams@intel.com>
CommitDate: Thu Jul 24 18:12:38 2014 -0700

    xhci: unit test ring enqueue/dequeue routines
    
    Given the complexity of satisfying xhci 1.0+ host trb boundary
    constraints, provide a test case that exercises inserting mid-segment
    links into a ring.
    
    The linker --wrap= option is used to not pollute the global identifier
    space and to make it clear which standard xhci driver routines are being
    mocked-up.  The --wrap= option does not come into play when both
    xhci-hcd and xhci-test are built-in to the kernel, so namespace
    collisions are prevented by excluding xhci-test from the build when
    xhci-hcd is built-in.
    
    It's unfortunate that this is an in-kernel test rather than userspace
    and that the infrastructure is custom rather than generic.  That said,
    it serves its purpose of exercising the corner cases of the scatterlist
    parsing implementation in xhci.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

+-----------------------------------------------------------+------------+------------+------------------+
|                                                           | 5a87c68543 | 61d9c2ad31 | v3.16-rc6_072510 |
+-----------------------------------------------------------+------------+------------+------------------+
| boot_successes                                            | 60         | 0          | 0                |
| boot_failures                                             | 0          | 20         | 11               |
| kernel_BUG_at_include/linux/scatterlist.h                 | 0          | 20         | 11               |
| invalid_opcode                                            | 0          | 20         | 11               |
| RIP:setup_test_skip64                                     | 0          | 20         | 11               |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode= | 0          | 20         | 11               |
| backtrace:xhci_test_init                                  | 0          | 20         | 11               |
| backtrace:kernel_init_freeable                            | 0          | 20         | 11               |
+-----------------------------------------------------------+------------+------------+------------------+

[    0.661771] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    0.662899] usbcore: registered new interface driver rtsx_usb
[    0.669506] ------------[ cut here ]------------
[    0.670014] kernel BUG at include/linux/scatterlist.h:115!
[    0.670014] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.670014] Modules linked in:
[    0.670014] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc5-00226-g61d9c2a #1
[    0.670014] task: ffff8800116b8000 ti: ffff8800116c0000 task.ti: ffff8800116c0000
[    0.670014] RIP: 0010:[<ffffffff81571f12>]  [<ffffffff81571f12>] setup_test_skip64+0x152/0x2f0
[    0.670014] RSP: 0000:ffff8800116c3d08  EFLAGS: 00010202
[    0.670014] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000003
[    0.670014] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffffffff81c51928
[    0.670014] RBP: ffff8800116c3d68 R08: 0000000000000000 R09: 0000000000000000
[    0.670014] R10: ffff880011437000 R11: ffff880013cda4a8 R12: 000000000000ffe0
[    0.670014] R13: ffff8800116c3e18 R14: ffff8800116c3e0c R15: 0000000000001000
[    0.670014] FS:  0000000000000000(0000) GS:ffff880013800000(0000) knlGS:0000000000000000
[    0.670014] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.670014] CR2: 0000000000000000 CR3: 0000000001b21000 CR4: 00000000000006f0
[    0.670014] Stack:
[    0.670014]  ffffffffffffffff ffffffff81f74b97 0000000000000000 ffff8800116c3e40
[    0.670014]  000000000000ffe0 ffff880011437000 0000000000000000 0000000000000000
[    0.670014]  ffff88000f67d800 0000000000000000 ffffffff81f74b97 0000000000000000
[    0.670014] Call Trace:
[    0.670014]  [<ffffffff81f74b97>] ? mon_bin_init+0x107/0x107
[    0.670014]  [<ffffffff81f74b97>] ? mon_bin_init+0x107/0x107
[    0.670014]  [<ffffffff81f74dd5>] xhci_test_init+0x23e/0xc56
[    0.670014]  [<ffffffff81571dc0>] ? setup_test_32_248_8+0x370/0x370
[    0.670014]  [<ffffffff8127ffff>] ? migrate_vmas+0x2f/0xc0
[    0.670014]  [<ffffffff813bd246>] ? kvasprintf+0x86/0xa0
[    0.670014]  [<ffffffff81571dc0>] ? setup_test_32_248_8+0x370/0x370
[    0.670014]  [<ffffffff81571a50>] ? setup_test_wrap64+0x380/0x380
[    0.670014]  [<ffffffff815716d0>] ? setup_test_dont_trim+0x350/0x350
[    0.670014]  [<ffffffff81571380>] ? xhci_ring_free+0x1d0/0x1d0
[    0.670014]  [<ffffffff81f74b97>] ? mon_bin_init+0x107/0x107
[    0.670014]  [<ffffffff81002243>] do_one_initcall+0x1b3/0x300
[    0.670014]  [<ffffffff810f2bec>] ? parse_args+0x3fc/0x6d0
[    0.670014]  [<ffffffff81f20592>] kernel_init_freeable+0x118/0x1e1
[    0.670014]  [<ffffffff81f1f9f9>] ? do_early_param+0xc3/0xc3
[    0.670014]  [<ffffffff816bad30>] ? rest_init+0x160/0x160
[    0.670014]  [<ffffffff816bad3e>] kernel_init+0xe/0x160
[    0.670014]  [<ffffffff816d46fc>] ret_from_fork+0x7c/0xb0
[    0.670014]  [<ffffffff816bad30>] ? rest_init+0x160/0x160
[    0.670014] Code: e8 64 5a b1 ff 83 f0 01 31 d2 48 c7 c7 28 19 c5 81 0f b6 d8 89 de e8 3e 66 c5 ff 48 63 d3 48 83 04 d5 e0 dd e7 81 01 85 db 74 02 <0f> 0b 44 89 e0 48 8b 75 c8 48 ba 00 00 00 80 ff 77 00 00 25 ff 
[    0.670014] RIP  [<ffffffff81571f12>] setup_test_skip64+0x152/0x2f0
[    0.670014]  RSP <ffff8800116c3d08>
[    0.705046] ---[ end trace 15557dc49fd3f925 ]---
[    0.705639] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

git bisect start 98e9e9efbc6c4585c23b77550cb961da1b0b8c84 9a3c4145af32125c5ee39c0272662b47307a8323 --
git bisect good 28a8d131fa8d9d65ec6bc91356caa6de030f7b44  # 12:50     20+      0  Merge 'tty/tty-next' into devel-hourly-2014072510
git bisect good b939dd815bc66d1ec0b71ddd879e69c6f2cc5701  # 12:54     20+      0  Merge 'battery/master' into devel-hourly-2014072510
git bisect good 3b46ae4ef1bcd6f2cebb20dd967ca6398c0ae97c  # 12:57     20+      0  Merge 'hwmon/hwmon' into devel-hourly-2014072510
git bisect good 126cd14c70323d188924acce9e969e279e0612cf  # 13:05     20+      0  Merge 'hwmon/hwmon-staging' into devel-hourly-2014072510
git bisect  bad 9719ff8bbd9c4bd011d1fe4c68aeef90e61c4665  # 13:07      0-     20  Merge 'djbw-usb/td-fragments-v1' into devel-hourly-2014072510
git bisect good 8346b33fad01cfe93f0fd0e64cd32ff40bd4ba41  # 13:16     20+      0  Documentation: DocBook: elieminate doc build break
git bisect good 1c094728b68c28e52abb64f0686aace61495a4fa  # 13:19     20+      0  usb-core: Remove Fix mes in file hcd.c
git bisect good 7ebdb52e192c4d496a9b3a87d47eba3eba3e1fd4  # 13:25     20+      0  phy: miphy365x: Represent each PHY channel as a DT subnode
git bisect good 31033361d83c1b0e3b900c474d31374b63892a9e  # 13:34     20+      0  xhci: introduce xhci_to_dev
git bisect good ea22a95d88bc1381888cc41556d4a92783285221  # 13:38     20+      0  xhci: introduce struct xhci_ring_pointer
git bisect good 182711c160f9a102cde5ba7e38a8e9d5156b2945  # 13:48     20+      0  xhci: combine xhci_queue_bulk_tx() and queue_bulk_sg_tx()
git bisect good 5eec677ca7e5e5ae2ec2e262f099c2cf75888f1e  # 13:53     20+      0  xhci: fix xhci_queue_ctrl_tx() ring space reservation
git bisect  bad 61d9c2ad31b11b87c319bbc2a963040742bac77c  # 13:57      0-     20  xhci: unit test ring enqueue/dequeue routines
git bisect good 5a87c68543bfd6421f3cf59a44a49b97257d606a  # 14:01     20+      0  xhci: v1.0 scatterlist enqueue support (td-fragment rework)
# first bad commit: [61d9c2ad31b11b87c319bbc2a963040742bac77c] xhci: unit test ring enqueue/dequeue routines
git bisect good 5a87c68543bfd6421f3cf59a44a49b97257d606a  # 14:03     60+      0  xhci: v1.0 scatterlist enqueue support (td-fragment rework)
git bisect  bad 98e9e9efbc6c4585c23b77550cb961da1b0b8c84  # 14:03      0-     11  0day head guard for 'devel-hourly-2014072510'
git bisect good 82e13c71bc655b6dc7110da4e164079dadb44892  # 02:09     60+      0  Merge branch 'for-3.16' of git://linux-nfs.org/~bfields/linux
git bisect good 5a7439efd1c5c416f768fc550048ca130cf4bf99  # 02:41     60+      0  Add linux-next specific files for 20140725


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
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
	panic=10
	softlockup_panic=1
	nmi_watchdog=panic
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

--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-vp-14:20140725135700:x86_64-randconfig-s0-07251232:3.16.0-rc5-00226-g61d9c2a:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc5-00226-g61d9c2a (kbuild@snb) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-18) ) #1 SMP PREEMPT Fri Jul 25 13:55:57 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s0-07251232/linux-devel:=
devel-hourly-2014072510:61d9c2ad31b11b87c319bbc2a963040742bac77c:bisect-lin=
ux3/.vmlinuz-61d9c2ad31b11b87c319bbc2a963040742bac77c-20140725135618-20-vp =
branch=3Dlinux-devel/devel-hourly-2014072510 BOOT_IMAGE=3D/kernel/x86_64-ra=
ndconfig-s0-07251232/61d9c2ad31b11b87c319bbc2a963040742bac77c/vmlinuz-3.16.=
0-rc5-00226-g61d9c2a drbd.minor_count=3D8
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02e4d000, 0x02e4dfff] PGTABLE
[    0.000000] BRK [0x02e4e000, 0x02e4efff] PGTABLE
[    0.000000] BRK [0x02e4f000, 0x02e4ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x02e50000, 0x02e50fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x02e51000, 0x02e51fff] PGTABLE
[    0.000000] BRK [0x02e52000, 0x02e52fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 32 MiB at 11800000
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
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13cd7000-0x13ce5fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880010a0000=
0-ffff880010ffffff] on node 0
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
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880013800000 s90048 r8192=
 d20544 u2097152
[    0.000000] pcpu-alloc: s90048 r8192 d20544 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380edc0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s0-07251232/linux=
-devel:devel-hourly-2014072510:61d9c2ad31b11b87c319bbc2a963040742bac77c:bis=
ect-linux3/.vmlinuz-61d9c2ad31b11b87c319bbc2a963040742bac77c-20140725135618=
-20-vp branch=3Dlinux-devel/devel-hourly-2014072510 BOOT_IMAGE=3D/kernel/x8=
6_64-randconfig-s0-07251232/61d9c2ad31b11b87c319bbc2a963040742bac77c/vmlinu=
z-3.16.0-rc5-00226-g61d9c2a drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 253236K/327280K available (7004K kernel code, 4084K =
rwdata, 4296K rodata, 984K init, 14636K bss, 74044K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.486 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5386.97 Bogo=
MIPS (lpj=3D2693486)
[    0.003000] pid_max: default: 4096 minimum: 301
[    0.003028] ACPI: Core revision 20140424
[    0.006134] ACPI: All ACPI Tables successfully acquired
[    0.006803] Security Framework initialized
[    0.007249] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.008220] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.009063] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.009693] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.012579] Initializing cgroup subsys memory
[    0.013093] Initializing cgroup subsys perf_event
[    0.014111] mce: CPU supports 10 MCE banks
[    0.014740] numa_add_cpu cpu 0 node 0: mask now 0
[    0.015018] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015018] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.015018] tlb_flushall_shift: 6
[    0.027964] debug: unmapping init [mem 0xffffffff81fff000-0xffffffff8200=
1fff]
[    0.033887] Getting VERSION: 50014
[    0.034019] Getting VERSION: 50014
[    0.034490] Getting ID: 0
[    0.035021] Getting ID: ff000000
[    0.035467] Getting LVT0: 8700
[    0.036014] Getting LVT1: 8400
[    0.036509] enabled ExtINT on CPU#0
[    0.038374] ENABLING IO-APIC IRQs
[    0.038837] init IO_APIC IRQs
[    0.039011]  apic 0 pin 0 not connected
[    0.039579] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.040036] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.041035] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.042034] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.043032] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.044033] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.045033] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.046032] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.047033] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.048033] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.049034] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.050035] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.051033] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.052034] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.053034] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.054027]  apic 0 pin 16 not connected
[    0.055009]  apic 0 pin 17 not connected
[    0.055528]  apic 0 pin 18 not connected
[    0.056009]  apic 0 pin 19 not connected
[    0.056534]  apic 0 pin 20 not connected
[    0.057009]  apic 0 pin 21 not connected
[    0.058008]  apic 0 pin 22 not connected
[    0.058531]  apic 0 pin 23 not connected
[    0.059156] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.060009] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.061219] Using local APIC timer interrupts.
[    0.061219] calibrating APIC timer ...
[    0.063000] ... lapic delta =3D 6250268
[    0.063000] ... PM-Timer delta =3D 357989
[    0.063000] ... PM-Timer result ok
[    0.063000] ..... delta 6250268
[    0.063000] ..... mult: 268446966
[    0.063000] ..... calibration result: 1000042
[    0.063000] ..... CPU clock speed is 2693.0600 MHz.
[    0.063000] ..... host bus clock speed is 1000.0042 MHz.
[    0.063125] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.069072]=20
[    0.069072] **********************************************************
[    0.070006] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.070835] **                                                      **
[    0.071008] ** trace_printk() being used. Allocating extra memory.  **
[    0.072007] **                                                      **
[    0.073007] ** This means that this is a DEBUG kernel and it is     **
[    0.074006] ** unsafe for produciton use.                           **
[    0.075006] **                                                      **
[    0.076006] ** If you see this message and you are not debugging    **
[    0.076834] ** the kernel, report this immediately to your vendor!  **
[    0.077008] **                                                      **
[    0.078007] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.079007] **********************************************************
[    0.084310] x86: Booted up 1 node, 1 CPUs
[    0.084919] ----------------
[    0.085006] | NMI testsuite:
[    0.085384] --------------------
[    0.086007]   remote IPI:  ok  |
[    0.086466]    local IPI:  ok  |
[    0.092033] --------------------
[    0.092633] Good, all   2 testcases passed! |
[    0.093006] ---------------------------------
[    0.093718] smpboot: Total of 1 processors activated (5386.97 BogoMIPS)
[    0.099913] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.102097] regulator-dummy: no parameters
[    0.108688] NET: Registered protocol family 16
[    0.110264] cpuidle: using governor ladder
[    0.110814] cpuidle: using governor menu
[    0.111312] ACPI: bus type PCI registered
[    0.112268] PCI: Using configuration type 1 for base access
[    0.121303] ACPI: Added _OSI(Module Device)
[    0.121862] ACPI: Added _OSI(Processor Device)
[    0.122009] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.123022] ACPI: Added _OSI(Processor Aggregator Device)
[    0.133496] ACPI: Interpreter enabled
[    0.134010] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140424/hwxface-580)
[    0.135011] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140424/hwxface-580)
[    0.136372] ACPI: (supports S0 S3 S5)
[    0.137007] ACPI: Using IOAPIC for interrupt routing
[    0.137709] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.152934] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.153016] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.154123] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.156509] PCI host bridge to bus 0000:00
[    0.157011] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.157719] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.158009] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.159009] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.160009] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.161149] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.163045] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.164928] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.169363] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.171404] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.172009] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.173009] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.174009] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.175516] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.176499] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.177024] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.179332] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.182067] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.185064] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.196066] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.198155] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.200010] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.202010] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.209683] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.211370] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.213010] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.215666] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.224113] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.226010] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.228010] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.236763] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.239010] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.241010] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.249575] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.251706] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.253698] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.262325] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.264009] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.266010] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.274773] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.277010] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.279010] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.287638] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.289010] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.296620] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.297522] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.298519] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.299511] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.300390] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.302614] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.305254] ACPI: bus type USB registered
[    0.305925] usbcore: registered new interface driver usbfs
[    0.306120] usbcore: registered new interface driver hub
[    0.307391] usbcore: registered new device driver usb
[    0.308320] PCI: Using ACPI for IRQ routing
[    0.309013] PCI: pci_cache_line_size set to 64 bytes
[    0.310297] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.311099] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.313819] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.315745] Switched to clocksource kvm-clock
[    0.316767] Warning: could not register all branches stats
[    0.317553] Warning: could not register annotated branches stats
[    0.377607] FS-Cache: Loaded
[    0.378163] pnp: PnP ACPI init
[    0.378620] ACPI: bus type PNP registered
[    0.379242] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.380138] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.380783] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.382009] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.383120] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.384244] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.385158] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.386141] pnp 00:03: [dma 2]
[    0.386492] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.387216] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.387989] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.388684] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.389549] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.390381] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.391763] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.393356] pnp: PnP ACPI: found 7 devices
[    0.393738] ACPI: bus type PNP unregistered
[    0.399404] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.399910] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.400439] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.400996] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.401877] NET: Registered protocol family 1
[    0.402390] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.402936] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.403503] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.404158] pci 0000:00:02.0: Boot video device
[    0.404814] PCI: CLS 0 bytes, default 64
[    0.405777] Unpacking initramfs...
[    0.527736] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013fe=
ffff]
[    0.529340] Scanning for low memory corruption every 60 seconds
[    0.530107] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    0.531208] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    0.532131] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.532701] AVX instructions are not detected.
[    0.533129] AVX instructions are not detected.
[    0.534749] Initializing RT-Tester: OK
[    0.535176] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.536557] spin_lock-torture: Creating torture_shuffle task
[    0.537400] spin_lock-torture: Creating torture_stutter task
[    0.538222] spin_lock-torture: torture_shuffle task started
[    0.538748] spin_lock-torture: Creating lock_torture_writer task
[    0.539394] spin_lock-torture: torture_stutter task started
[    0.539920] spin_lock-torture: Creating lock_torture_writer task
[    0.540788] spin_lock-torture: lock_torture_writer task started
[    0.541493] spin_lock-torture: Creating lock_torture_stats task
[    0.542102] spin_lock-torture: lock_torture_writer task started
[    0.543105] futex hash table entries: 16 (order: -1, 2048 bytes)
[    0.543920] Kprobe smoke test started
[    0.547046] spin_lock-torture: lock_torture_stats task started
[    0.553359] Kprobe smoke test passed successfully
[    0.569366] VFS: Disk quotas dquot_6.5.2
[    0.569956] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.570828] fuse init (API version 7.23)
[    0.571851] msgmni has been set to 558
[    0.574839] Key type asymmetric registered
[    0.575349] list_sort_test: start testing list_sort()
[    0.576213] test_string_helpers: Running tests...
[    0.577455] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    0.578357] ACPI: Power Button [PWRF]
[    0.580403] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.580937] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.585874] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.586504] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.589909] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    0.594181] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.626192] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.656037] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    0.659073] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    0.659735] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    0.660862] Hangcheck: Using getrawmonotonic().
[    0.661771] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    0.662899] usbcore: registered new interface driver rtsx_usb
[    0.669506] ------------[ cut here ]------------
[    0.670014] kernel BUG at include/linux/scatterlist.h:115!
[    0.670014] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.670014] Modules linked in:
[    0.670014] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc5-00226-g=
61d9c2a #1
[    0.670014] task: ffff8800116b8000 ti: ffff8800116c0000 task.ti: ffff880=
0116c0000
[    0.670014] RIP: 0010:[<ffffffff81571f12>]  [<ffffffff81571f12>] setup_t=
est_skip64+0x152/0x2f0
[    0.670014] RSP: 0000:ffff8800116c3d08  EFLAGS: 00010202
[    0.670014] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 00000000000=
00003
[    0.670014] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffffffff81c=
51928
[    0.670014] RBP: ffff8800116c3d68 R08: 0000000000000000 R09: 00000000000=
00000
[    0.670014] R10: ffff880011437000 R11: ffff880013cda4a8 R12: 00000000000=
0ffe0
[    0.670014] R13: ffff8800116c3e18 R14: ffff8800116c3e0c R15: 00000000000=
01000
[    0.670014] FS:  0000000000000000(0000) GS:ffff880013800000(0000) knlGS:=
0000000000000000
[    0.670014] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.670014] CR2: 0000000000000000 CR3: 0000000001b21000 CR4: 00000000000=
006f0
[    0.670014] Stack:
[    0.670014]  ffffffffffffffff ffffffff81f74b97 0000000000000000 ffff8800=
116c3e40
[    0.670014]  000000000000ffe0 ffff880011437000 0000000000000000 00000000=
00000000
[    0.670014]  ffff88000f67d800 0000000000000000 ffffffff81f74b97 00000000=
00000000
[    0.670014] Call Trace:
[    0.670014]  [<ffffffff81f74b97>] ? mon_bin_init+0x107/0x107
[    0.670014]  [<ffffffff81f74b97>] ? mon_bin_init+0x107/0x107
[    0.670014]  [<ffffffff81f74dd5>] xhci_test_init+0x23e/0xc56
[    0.670014]  [<ffffffff81571dc0>] ? setup_test_32_248_8+0x370/0x370
[    0.670014]  [<ffffffff8127ffff>] ? migrate_vmas+0x2f/0xc0
[    0.670014]  [<ffffffff813bd246>] ? kvasprintf+0x86/0xa0
[    0.670014]  [<ffffffff81571dc0>] ? setup_test_32_248_8+0x370/0x370
[    0.670014]  [<ffffffff81571a50>] ? setup_test_wrap64+0x380/0x380
[    0.670014]  [<ffffffff815716d0>] ? setup_test_dont_trim+0x350/0x350
[    0.670014]  [<ffffffff81571380>] ? xhci_ring_free+0x1d0/0x1d0
[    0.670014]  [<ffffffff81f74b97>] ? mon_bin_init+0x107/0x107
[    0.670014]  [<ffffffff81002243>] do_one_initcall+0x1b3/0x300
[    0.670014]  [<ffffffff810f2bec>] ? parse_args+0x3fc/0x6d0
[    0.670014]  [<ffffffff81f20592>] kernel_init_freeable+0x118/0x1e1
[    0.670014]  [<ffffffff81f1f9f9>] ? do_early_param+0xc3/0xc3
[    0.670014]  [<ffffffff816bad30>] ? rest_init+0x160/0x160
[    0.670014]  [<ffffffff816bad3e>] kernel_init+0xe/0x160
[    0.670014]  [<ffffffff816d46fc>] ret_from_fork+0x7c/0xb0
[    0.670014]  [<ffffffff816bad30>] ? rest_init+0x160/0x160
[    0.670014] Code: e8 64 5a b1 ff 83 f0 01 31 d2 48 c7 c7 28 19 c5 81 0f =
b6 d8 89 de e8 3e 66 c5 ff 48 63 d3 48 83 04 d5 e0 dd e7 81 01 85 db 74 02 =
<0f> 0b 44 89 e0 48 8b 75 c8 48 ba 00 00 00 80 ff 77 00 00 25 ff=20
[    0.670014] RIP  [<ffffffff81571f12>] setup_test_skip64+0x152/0x2f0
[    0.670014]  RSP <ffff8800116c3d08>
[    0.705046] ---[ end trace 15557dc49fd3f925 ]---
[    0.705639] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x0000000b
[    0.705639]=20
[    0.706014] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[    0.706014] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s0-07251232/61d9c2ad31b11b87c319bbc2a963040742bac77c/vmlinuz-3.16.0-rc5-00=
226-g61d9c2a -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pani=
c=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 consol=
e=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/k=
build-tests/run-queue/kvm/x86_64-randconfig-s0-07251232/linux-devel:devel-h=
ourly-2014072510:61d9c2ad31b11b87c319bbc2a963040742bac77c:bisect-linux3/.vm=
linuz-61d9c2ad31b11b87c319bbc2a963040742bac77c-20140725135618-20-vp branch=
=3Dlinux-devel/devel-hourly-2014072510 BOOT_IMAGE=3D/kernel/x86_64-randconf=
ig-s0-07251232/61d9c2ad31b11b87c319bbc2a963040742bac77c/vmlinuz-3.16.0-rc5-=
00226-g61d9c2a drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-mi=
nimal-x86_64.cgz -m 320 -smp 1 -net nic,vlan=3D1,model=3De1000 -net user,vl=
an=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime=
 -drive file=3D/fs/LABEL=3DKVM/disk0-yocto-vp-14,media=3Ddisk,if=3Dvirtio -=
drive file=3D/fs/LABEL=3DKVM/disk1-yocto-vp-14,media=3Ddisk,if=3Dvirtio -dr=
ive file=3D/fs/LABEL=3DKVM/disk2-yocto-vp-14,media=3Ddisk,if=3Dvirtio -driv=
e file=3D/fs/LABEL=3DKVM/disk3-yocto-vp-14,media=3Ddisk,if=3Dvirtio -drive =
file=3D/fs/LABEL=3DKVM/disk4-yocto-vp-14,media=3Ddisk,if=3Dvirtio -drive fi=
le=3D/fs/LABEL=3DKVM/disk5-yocto-vp-14,media=3Ddisk,if=3Dvirtio -pidfile /d=
ev/shm/kboot/pid-yocto-vp-14 -serial file:/dev/shm/kboot/serial-yocto-vp-14=
 -daemonize -display none -monitor null=20

--JSkcQAAxhB1h8DcT
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-s0-07251232-98e9e9efbc6c4585c23b77550cb961da1b0b8c84-kernel-BUG-at-16196.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgOThlOWU5ZS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA3MjUxMCcKZ2l0IGNoZWNrb3V0IDlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMw
MjcyNjYyYjQ3MzA3YTgzMjMKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDcyNTEwOjlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcyNjYyYjQ3MzA3YTgzMjM6Ymlz
ZWN0LWxpbnV4MwoKMjAxNC0wNy0yNS0xMjo0MzoyNiA5YTNjNDE0NWFmMzIxMjVjNWVlMzlj
MDI3MjY2MmI0NzMwN2E4MzIzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLTlh
M2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcyNjYyYjQ3MzA3YTgzMjMKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzlhM2M0MTQ1YWYz
MjEyNWM1ZWUzOWMwMjcyNjYyYjQ3MzA3YTgzMjMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUx
MjMyLTlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcyNjYyYjQ3MzA3YTgzMjMKa2VybmVsOiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzlhM2M0MTQ1YWYzMjEyNWM1
ZWUzOWMwMjcyNjYyYjQ3MzA3YTgzMjMvdm1saW51ei0zLjE2LjAtcmM2CgoyMDE0LTA3LTI1
LTEyOjQ2OjI2IGRldGVjdGluZyBib290IHN0YXRlIAkxCTYJMjAgU1VDQ0VTUwoKYmlzZWN0
OiBnb29kIGNvbW1pdCA5YTNjNDE0NWFmMzIxMjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4MzIz
CmdpdCBiaXNlY3Qgc3RhcnQgOThlOWU5ZWZiYzZjNDU4NWMyM2I3NzU1MGNiOTYxZGExYjBi
OGM4NCA5YTNjNDE0NWFmMzIxMjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4MzIzIC0tCi9jL2tl
cm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgIjk4ZTllOWVmYmM2YzQ1ODVjMjNi
Nzc1NTBjYjk2MWRhMWIwYjhjODQiLCAiLWciLCAiOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAy
NzI2NjJiNDczMDdhODMyMyIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIiwgIi9jL2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlzZWN0Il0KQmlzZWN0
aW5nOiAyNTUzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAx
MiBzdGVwcykKWzI4YThkMTMxZmE4ZDlkNjVlYzZiYzkxMzU2Y2FhNmRlMDMwZjdiNDRdIE1l
cmdlICd0dHkvdHR5LW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzI1MTAKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDA3MjUxMDoyOGE4ZDEzMWZhOGQ5ZDY1ZWM2YmM5MTM1NmNhYTZkZTAzMGY3
YjQ0OmJpc2VjdC1saW51eDMKCjIwMTQtMDctMjUtMTI6NDc6NTggMjhhOGQxMzFmYThkOWQ2
NWVjNmJjOTEzNTZjYWE2ZGUwMzBmN2I0NCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1
MTIzMi0yOGE4ZDEzMWZhOGQ5ZDY1ZWM2YmM5MTM1NmNhYTZkZTAzMGY3YjQ0CkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi8yOGE4
ZDEzMWZhOGQ5ZDY1ZWM2YmM5MTM1NmNhYTZkZTAzMGY3YjQ0CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzI1MTIzMi0yOGE4ZDEzMWZhOGQ5ZDY1ZWM2YmM5MTM1NmNhYTZkZTAzMGY3YjQ0Cmtl
cm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi8yOGE4ZDEzMWZh
OGQ5ZDY1ZWM2YmM5MTM1NmNhYTZkZTAzMGY3YjQ0L3ZtbGludXotMy4xNi4wLXJjNi0wMTgz
NC1nMjhhOGQxMwoKMjAxNC0wNy0yNS0xMjo0OTo1OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAu
CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNzE5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKW2I5MzlkZDgxNWJjNjZkMWVjMGI3MWRkZDg3
OWU2OWM2ZjJjYzU3MDFdIE1lcmdlICdiYXR0ZXJ5L21hc3RlcicgaW50byBkZXZlbC1ob3Vy
bHktMjAxNDA3MjUxMApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgzL29iai1iaXNlY3QKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMy
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcyNTEwOmI5MzlkZDgxNWJjNjZkMWVj
MGI3MWRkZDg3OWU2OWM2ZjJjYzU3MDE6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNy0yNS0xMjo1
MDo1OSBiOTM5ZGQ4MTViYzY2ZDFlYzBiNzFkZGQ4NzllNjljNmYyY2M1NzAxIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLWI5MzlkZDgxNWJjNjZkMWVjMGI3MWRkZDg3OWU2
OWM2ZjJjYzU3MDEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTA3MjUxMjMyL2I5MzlkZDgxNWJjNjZkMWVjMGI3MWRkZDg3OWU2OWM2ZjJjYzU3
MDEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLWI5MzlkZDgxNWJjNjZkMWVjMGI3MWRk
ZDg3OWU2OWM2ZjJjYzU3MDEKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA3MjUxMjMyL2I5MzlkZDgxNWJjNjZkMWVjMGI3MWRkZDg3OWU2OWM2ZjJjYzU3MDEvdm1s
aW51ei0zLjE2LjAtcmM2LTAyMjAzLWdiOTM5ZGQ4CgoyMDE0LTA3LTI1LTEyOjUzOjAwIGRl
dGVjdGluZyBib290IHN0YXRlIAk2CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMzUwIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbM2I0NmFl
NGVmMWJjZDZmMmNlYmIyMGRkOTY3Y2E2Mzk4YzBhZTk3Y10gTWVyZ2UgJ2h3bW9uL2h3bW9u
JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDcyNTEwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDMvb2Jq
LWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctczAtMDcyNTEyMzIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzI1MTA6
M2I0NmFlNGVmMWJjZDZmMmNlYmIyMGRkOTY3Y2E2Mzk4YzBhZTk3YzpiaXNlY3QtbGludXgz
CgoyMDE0LTA3LTI1LTEyOjU0OjAwIDNiNDZhZTRlZjFiY2Q2ZjJjZWJiMjBkZDk2N2NhNjM5
OGMwYWU5N2MgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzItM2I0NmFlNGVmMWJj
ZDZmMmNlYmIyMGRkOTY3Y2E2Mzk4YzBhZTk3YwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvM2I0NmFlNGVmMWJjZDZmMmNlYmIy
MGRkOTY3Y2E2Mzk4YzBhZTk3Ywp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzItM2I0NmFl
NGVmMWJjZDZmMmNlYmIyMGRkOTY3Y2E2Mzk4YzBhZTk3YwprZXJuZWw6IC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvM2I0NmFlNGVmMWJjZDZmMmNlYmIyMGRkOTY3
Y2E2Mzk4YzBhZTk3Yy92bWxpbnV6LTMuMTYuMC1yYzYtMDIyNDQtZzNiNDZhZTRlCgoyMDE0
LTA3LTI1LTEyOjU2OjAwIGRldGVjdGluZyBib290IHN0YXRlIC4JMjAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAzMDkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDkgc3RlcHMpClsxMjZjZDE0YzcwMzIzZDE4ODkyNGFjY2U5ZTk2OWUyNzllMDYxMmNmXSBN
ZXJnZSAnaHdtb24vaHdtb24tc3RhZ2luZycgaW50byBkZXZlbC1ob3VybHktMjAxNDA3MjUx
MApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2MvYm9vdC1iaXNlY3QvbGludXgzL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyL2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDcyNTEwOjEyNmNkMTRjNzAzMjNkMTg4OTI0YWNjZTllOTY5
ZTI3OWUwNjEyY2Y6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNy0yNS0xMjo1NzowMSAxMjZjZDE0
YzcwMzIzZDE4ODkyNGFjY2U5ZTk2OWUyNzllMDYxMmNmIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXMwLTA3MjUxMjMyLTEyNmNkMTRjNzAzMjNkMTg4OTI0YWNjZTllOTY5ZTI3OWUwNjEyY2YK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUx
MjMyLzEyNmNkMTRjNzAzMjNkMTg4OTI0YWNjZTllOTY5ZTI3OWUwNjEyY2YKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLXMwLTA3MjUxMjMyLTEyNmNkMTRjNzAzMjNkMTg4OTI0YWNjZTllOTY5ZTI3OWUw
NjEyY2YKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2pha2V0b3duLWNvbnN1bWVyL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLTEy
NmNkMTRjNzAzMjNkMTg4OTI0YWNjZTllOTY5ZTI3OWUwNjEyY2YKa2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzEyNmNkMTRjNzAzMjNkMTg4OTI0YWNj
ZTllOTY5ZTI3OWUwNjEyY2Yvdm1saW51ei0zLjE2LjAtcmM2LTAyMzI1LWcxMjZjZDE0Cgoy
MDE0LTA3LTI1LTEzOjA0OjAxIGRldGVjdGluZyBib290IHN0YXRlIAk3CTIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMjI4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA4IHN0ZXBzKQpbOTcxOWZmOGJiZDljNGJkMDExZDFmZTRjNjhhZWVmOTBlNjFjNDY2
NV0gTWVyZ2UgJ2RqYnctdXNiL3RkLWZyYWdtZW50cy12MScgaW50byBkZXZlbC1ob3VybHkt
MjAxNDA3MjUxMApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgzL29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyL2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcyNTEwOjk3MTlmZjhiYmQ5YzRiZDAxMWQx
ZmU0YzY4YWVlZjkwZTYxYzQ2NjU6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNy0yNS0xMzowNTow
MiA5NzE5ZmY4YmJkOWM0YmQwMTFkMWZlNGM2OGFlZWY5MGU2MWM0NjY1IGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA3MjUxMjMyLTk3MTlmZjhiYmQ5YzRiZDAxMWQxZmU0YzY4YWVlZjkw
ZTYxYzQ2NjUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTA3MjUxMjMyLzk3MTlmZjhiYmQ5YzRiZDAxMWQxZmU0YzY4YWVlZjkwZTYxYzQ2NjUK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLTk3MTlmZjhiYmQ5YzRiZDAxMWQxZmU0YzY4
YWVlZjkwZTYxYzQ2NjUKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3
MjUxMjMyLzk3MTlmZjhiYmQ5YzRiZDAxMWQxZmU0YzY4YWVlZjkwZTYxYzQ2NjUvdm1saW51
ei0zLjE2LjAtcmM2LTAyNTUyLWc5NzE5ZmY4CgoyMDE0LTA3LTI1LTEzOjA3OjAyIGRldGVj
dGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgMS45Njk4MjZdIFNpbGljb24g
TGFicyBDMiBwb3J0IHN1cHBvcnQgdi4gMC41MS4wIC0gKEMpIDIwMDcgUm9kb2xmbyBHaW9t
ZXR0aQpbICAgIDEuOTcxMDc0XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2Ug
ZHJpdmVyIHJ0c3hfdXNiClsgICAgMS45ODAyNTFdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbICAgIDEuOTgwOTA2XSBrZXJuZWwgQlVHIGF0IC9rYnVpbGQvc3Jj
L2NvbnN1bWVyL2luY2x1ZGUvbGludXgvc2NhdHRlcmxpc3QuaDoxMTUhClsgICAgMS45ODEx
ODZdIGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gUFJFRU1QVCBTTVAgREVCVUdfUEFHRUFM
TE9DClsgICAgMS45ODQwNDFdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDEuOTg0MDQxXSBD
UFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM2LTAy
NTUyLWc5NzE5ZmY4ICM1ClsgICAgMS45ODQwNDFdIHRhc2s6IGZmZmY4ODAwMTAyYzAwMDAg
dGk6IGZmZmY4ODAwMTAyOGMwMDAgdGFzay50aTogZmZmZjg4MDAxMDI4YzAwMApbICAgIDEu
OTg0MDQxXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxNTc1MWQyPl0gIFs8ZmZmZmZmZmY4MTU3
NTFkMj5dIHNldHVwX3Rlc3Rfc2tpcDY0KzB4MTUyLzB4MmYwClsgICAgMS45ODQwNDFdIFJT
UDogMDAwMDpmZmZmODgwMDEwMjhmZDA4ICBFRkxBR1M6IDAwMDEwMjAyClsgICAgMS45ODQw
NDFdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IDAwMDAwMDAwMDAwMDAwMDEgUkNYOiAw
MDAwMDAwMDAwMDAwMDAzClsgICAgMS45ODQwNDFdIFJEWDogMDAwMDAwMDAwMDAwMDAwMSBS
U0k6IDAwMDAwMDAwMDAwMDAwMDEgUkRJOiBmZmZmZmZmZjgxYzU2MDUwClsgICAgMS45ODQw
NDFdIFJCUDogZmZmZjg4MDAxMDI4ZmQ2OCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAw
MDAwMDAwMDAwMDAwMDAwClsgICAgMS45ODQwNDFdIFIxMDogZmZmZjg4MDAwZWJmMTAwMCBS
MTE6IGZmZmY4ODAwMTI5MzE0YTggUjEyOiAwMDAwMDAwMDAwMDBmZmUwClsgICAgMS45ODQw
NDFdIFIxMzogZmZmZjg4MDAxMDI4ZmUxOCBSMTQ6IGZmZmY4ODAwMTAyOGZlMGMgUjE1OiAw
MDAwMDAwMDAwMDAxMDAwClsgICAgMS45ODQwNDFdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgw
MDAwKSBHUzpmZmZmODgwMDEyNTAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAK
WyAgICAxLjk4NDA0MV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAw
MDA4MDA1MDAzYgpbICAgIDEuOTg0MDQxXSBDUjI6IDAwMDAwMDAwZmZmZmZmZmYgQ1IzOiAw
MDAwMDAwMDAxYjI1MDAwIENSNDogMDAwMDAwMDAwMDAwMDZlMApbICAgIDEuOTg0MDQxXSBT
dGFjazoKWyAgICAxLjk4NDA0MV0gIGZmZmZmZmZmZmZmZmZmZmYgZmZmZmZmZmY4MWY3OWJh
ZiAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMTAyOGZlNDAKWyAgICAxLjk4NDA0MV0gIDAw
MDAwMDAwMDAwMGZmZTAgZmZmZjg4MDAwZWJmMTAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAw
MDAwMDAwMDAwMDAKWyAgICAxLjk4NDA0MV0gIGZmZmY4ODAwMDk2MGE4MDAgMDAwMDAwMDAw
MDAwMDAwMCBmZmZmZmZmZjgxZjc5YmFmIDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjk4NDA0
MV0gQ2FsbCBUcmFjZToKWyAgICAxLjk4NDA0MV0gIFs8ZmZmZmZmZmY4MWY3OWJhZj5dID8g
bW9uX2Jpbl9pbml0KzB4MTA3LzB4MTA3ClsgICAgMS45ODQwNDFdICBbPGZmZmZmZmZmODFm
NzliYWY+XSA/IG1vbl9iaW5faW5pdCsweDEwNy8weDEwNwpbICAgIDEuOTg0MDQxXSAgWzxm
ZmZmZmZmZjgxZjc5ZGVkPl0geGhjaV90ZXN0X2luaXQrMHgyM2UvMHhjNTYKWyAgICAxLjk4
NDA0MV0gIFs8ZmZmZmZmZmY4MTU3NTA4MD5dID8gc2V0dXBfdGVzdF8zMl8yNDhfOCsweDM3
MC8weDM3MApbICAgIDEuOTg0MDQxXSAgWzxmZmZmZmZmZjgxMjdmZmZmPl0gPyBtaWdyYXRl
X3BhZ2VfbW92ZV9tYXBwaW5nKzB4MmYvMHgzZTAKWyAgICAxLjk4NDA0MV0gIFs8ZmZmZmZm
ZmY4MTNiZmNiNj5dID8ga3Zhc3ByaW50ZisweDg2LzB4YTAKWyAgICAxLjk4NDA0MV0gIFs8
ZmZmZmZmZmY4MTU3NTA4MD5dID8gc2V0dXBfdGVzdF8zMl8yNDhfOCsweDM3MC8weDM3MApb
ICAgIDEuOTg0MDQxXSAgWzxmZmZmZmZmZjgxNTc0ZDEwPl0gPyBzZXR1cF90ZXN0X3dyYXA2
NCsweDM4MC8weDM4MApbICAgIDEuOTg0MDQxXSAgWzxmZmZmZmZmZjgxNTc0OTkwPl0gPyBz
ZXR1cF90ZXN0X2RvbnRfdHJpbSsweDM1MC8weDM1MApbICAgIDEuOTg0MDQxXSAgWzxmZmZm
ZmZmZjgxNTc0NjQwPl0gPyB4aGNpX3JpbmdfZnJlZSsweDFkMC8weDFkMApbICAgIDEuOTg0
MDQxXSAgWzxmZmZmZmZmZjgxZjc5YmFmPl0gPyBtb25fYmluX2luaXQrMHgxMDcvMHgxMDcK
WyAgICAxLjk4NDA0MV0gIFs8ZmZmZmZmZmY4MTAwMjI0Mz5dIGRvX29uZV9pbml0Y2FsbCsw
eDFiMy8weDMwMApbICAgIDEuOTg0MDQxXSAgWzxmZmZmZmZmZjgxMGYyZmRjPl0gPyBwYXJz
ZV9hcmdzKzB4M2ZjLzB4NmQwClsgICAgMS45ODQwNDFdICBbPGZmZmZmZmZmODFmMjU1OTI+
XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDExOC8weDFlMQpbICAgIDEuOTg0MDQxXSAgWzxm
ZmZmZmZmZjgxZjI0OWY5Pl0gPyBkb19lYXJseV9wYXJhbSsweGMzLzB4YzMKWyAgICAxLjk4
NDA0MV0gIFs8ZmZmZmZmZmY4MTZiZDA1MD5dID8gcmVzdF9pbml0KzB4MTYwLzB4MTYwClsg
ICAgMS45ODQwNDFdICBbPGZmZmZmZmZmODE2YmQwNWU+XSBrZXJuZWxfaW5pdCsweGUvMHgx
NjAKWyAgICAxLjk4NDA0MV0gIFs8ZmZmZmZmZmY4MTZkNmEzYz5dIHJldF9mcm9tX2Zvcmsr
MHg3Yy8weGIwClsgICAgMS45ODQwNDFdICBbPGZmZmZmZmZmODE2YmQwNTA+XSA/IHJlc3Rf
aW5pdCsweDE2MC8weDE2MApbICAgIDEuOTg0MDQxXSBDb2RlOiBlOCBlNCAyYSBiMSBmZiA4
MyBmMCAwMSAzMSBkMiA0OCBjNyBjNyA1MCA2MCBjNSA4MSAwZiBiNiBkOCA4OSBkZSBlOCBl
ZSA0MyBjNSBmZiA0OCA2MyBkMyA0OCA4MyAwNCBkNSA4MCAzNCBlOCA4MSAwMSA4NSBkYiA3
NCAwMiA8MGY+IDBiIDQ0IDg5IGUwIDQ4IDhiIDc1IGM4IDQ4IGJhIDAwIDAwIDAwIDgwIGZm
IDc3IDAwIDAwIDI1IGZmIApbICAgIDEuOTg0MDQxXSBSSVAgIFs8ZmZmZmZmZmY4MTU3NTFk
Mj5dIHNldHVwX3Rlc3Rfc2tpcDY0KzB4MTUyLzB4MmYwClsgICAgMS45ODQwNDFdICBSU1Ag
PGZmZmY4ODAwMTAyOGZkMDg+ClsgICAgMi4wMjI2NDVdIC0tLVsgZW5kIHRyYWNlIDljMDA3
MTEwMTA1YzIyYTUgXS0tLQpbICAgIDIuMDIzMzQ1XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3lu
Y2luZzogQXR0ZW1wdGVkIHRvIGtpbGwgaW5pdCEgZXhpdGNvZGU9MHgwMDAwMDAwYgova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzk3MTlmZjhiYmQ5YzRiZDAxMWQx
ZmU0YzY4YWVlZjkwZTYxYzQ2NjUvZG1lc2cteW9jdG8taXZiNDMtMTE4OjIwMTQwNzI1MTMx
MzM0Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyOjoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzI1MTIzMi85NzE5ZmY4YmJkOWM0YmQwMTFkMWZlNGM2OGFlZWY5MGU2
MWM0NjY1L2RtZXNnLXlvY3RvLWl2YjQzLTEyNToyMDE0MDcyNTEzMTMzNDp4ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzI1MTIzMjo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcy
NTEyMzIvOTcxOWZmOGJiZDljNGJkMDExZDFmZTRjNjhhZWVmOTBlNjFjNDY2NS9kbWVzZy15
b2N0by1pdmI0My01NjoyMDE0MDcyNTEzMTMzNDp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1
MTIzMjo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvOTcxOWZmOGJi
ZDljNGJkMDExZDFmZTRjNjhhZWVmOTBlNjFjNDY2NS9kbWVzZy15b2N0by1pdmI0My03Nzoy
MDE0MDcyNTEzMTMzNDp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvOTcxOWZmOGJiZDljNGJkMDExZDFmZTRj
NjhhZWVmOTBlNjFjNDY2NS9kbWVzZy1xdWFudGFsLWl2YjQzLTExMjoyMDE0MDcyNTEzMTMz
OTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczAtMDcyNTEyMzIvOTcxOWZmOGJiZDljNGJkMDExZDFmZTRjNjhhZWVmOTBlNjFj
NDY2NS9kbWVzZy1xdWFudGFsLWl2YjQzLTEyNjoyMDE0MDcyNTEzMTMzOTp4ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzI1MTIzMjo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcy
NTEyMzIvOTcxOWZmOGJiZDljNGJkMDExZDFmZTRjNjhhZWVmOTBlNjFjNDY2NS9kbWVzZy1x
dWFudGFsLWl2YjQzLTEyNzoyMDE0MDcyNTEzMTMzOTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzI1MTIzMjo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvOTcxOWZm
OGJiZDljNGJkMDExZDFmZTRjNjhhZWVmOTBlNjFjNDY2NS9kbWVzZy1xdWFudGFsLWl2YjQz
LTEyOjIwMTQwNzI1MTMxMzM5Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyOjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi85NzE5ZmY4YmJkOWM0YmQwMTFk
MWZlNGM2OGFlZWY5MGU2MWM0NjY1L2RtZXNnLXF1YW50YWwtaXZiNDMtMToyMDE0MDcyNTEz
MTMzOTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczAtMDcyNTEyMzIvOTcxOWZmOGJiZDljNGJkMDExZDFmZTRjNjhhZWVmOTBl
NjFjNDY2NS9kbWVzZy1xdWFudGFsLWl2YjQzLTI0OjIwMTQwNzI1MTMxMzM5Ong4Nl82NC1y
YW5kY29uZmlnLXMwLTA3MjUxMjMyOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzI1MTIzMi85NzE5ZmY4YmJkOWM0YmQwMTFkMWZlNGM2OGFlZWY5MGU2MWM0NjY1L2RtZXNn
LXF1YW50YWwtaXZiNDMtNDU6MjAxNDA3MjUxMzEzMzk6eDg2XzY0LXJhbmRjb25maWctczAt
MDcyNTEyMzI6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzk3MTlm
ZjhiYmQ5YzRiZDAxMWQxZmU0YzY4YWVlZjkwZTYxYzQ2NjUvZG1lc2ctcXVhbnRhbC1pdmI0
My01NjoyMDE0MDcyNTEzMTMzOTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvOTcxOWZmOGJiZDljNGJkMDEx
ZDFmZTRjNjhhZWVmOTBlNjFjNDY2NS9kbWVzZy1xdWFudGFsLWl2YjQzLTU6MjAxNDA3MjUx
MzEzNDA6eDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzI6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA3MjUxMjMyLzk3MTlmZjhiYmQ5YzRiZDAxMWQxZmU0YzY4YWVlZjkw
ZTYxYzQ2NjUvZG1lc2ctcXVhbnRhbC1pdmI0My02NjoyMDE0MDcyNTEzMTMzOTp4ODZfNjQt
cmFuZGNvbmZpZy1zMC0wNzI1MTIzMjo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAt
MDcyNTEyMzIvOTcxOWZmOGJiZDljNGJkMDExZDFmZTRjNjhhZWVmOTBlNjFjNDY2NS9kbWVz
Zy1xdWFudGFsLWl2YjQzLTc5OjIwMTQwNzI1MTMxMzM5Ong4Nl82NC1yYW5kY29uZmlnLXMw
LTA3MjUxMjMyOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi85NzE5
ZmY4YmJkOWM0YmQwMTFkMWZlNGM2OGFlZWY5MGU2MWM0NjY1L2RtZXNnLXF1YW50YWwtaXZi
NDMtODA6MjAxNDA3MjUxMzEzMzk6eDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzI6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzk3MTlmZjhiYmQ5YzRiZDAx
MWQxZmU0YzY4YWVlZjkwZTYxYzQ2NjUvZG1lc2ctcXVhbnRhbC1pdmI0My05OjIwMTQwNzI1
MTMxMzM5Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyOjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMC0wNzI1MTIzMi85NzE5ZmY4YmJkOWM0YmQwMTFkMWZlNGM2OGFlZWY5
MGU2MWM0NjY1L2RtZXNnLXF1YW50YWwta2J1aWxkLTE4OjIwMTQwNzI1MTMwNDUzOng4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyOjMuMTYuMC1yYzYtMDI1NTItZzk3MTlmZjg6NQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzk3MTlmZjhiYmQ5YzRiZDAx
MWQxZmU0YzY4YWVlZjkwZTYxYzQ2NjUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjE6MjAxNDA3
MjUxMzA0NTM6eDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzI6My4xNi4wLXJjNi0wMjU1
Mi1nOTcxOWZmODo1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvOTcx
OWZmOGJiZDljNGJkMDExZDFmZTRjNjhhZWVmOTBlNjFjNDY2NS9kbWVzZy1xdWFudGFsLWti
dWlsZC0yNDoyMDE0MDcyNTEzMDQ1Mzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjoz
LjE2LjAtcmM2LTAyNTUyLWc5NzE5ZmY4OjUKMDoyMDoyMCBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwobWzE7MzVtMjAxNC0wNy0yNSAxMzowNzozMyBSRVBFQVQgQ09VTlQ6IDIwICAj
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpsaW5lYXIt
YmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSBkamJ3LXVzYi90ZC1mcmFnbWVudHMtdjEKbGlu
ZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBn
aXQgYmlzZWN0IHN0YXJ0IDk3MTlmZjhiYmQ5YzRiZDAxMWQxZmU0YzY4YWVlZjkwZTYxYzQ2
NjUgMTI2Y2QxNGM3MDMyM2QxODg5MjRhY2NlOWU5NjllMjc5ZTA2MTJjZiAtLQpQcmV2aW91
cyBIRUFEIHBvc2l0aW9uIHdhcyA5NzE5ZmY4Li4uIE1lcmdlICdkamJ3LXVzYi90ZC1mcmFn
bWVudHMtdjEnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzI1MTAKSEVBRCBpcyBub3cgYXQg
NTRhZjYxZC4uLiBNZXJnZSBicmFuY2ggJ2FrcG0tY3VycmVudC9jdXJyZW50JwpCaXNlY3Rp
bmc6IDEyOSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBz
dGVwcykKWzgzNDZiMzNmYWQwMWNmZTkzZjBmZDBlNjRjZDMyZmY0MGJkNGJhNDFdIERvY3Vt
ZW50YXRpb246IERvY0Jvb2s6IGVsaWVtaW5hdGUgZG9jIGJ1aWxkIGJyZWFrCmxpbmVhci1i
aXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgzL29iai1iaXNlY3QKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDA3MjUxMDo4MzQ2YjMzZmFkMDFjZmU5M2YwZmQwZTY0Y2QzMmZmNDBiZDRiYTQx
OmJpc2VjdC1saW51eDMKCjIwMTQtMDctMjUtMTM6MDc6MzkgODM0NmIzM2ZhZDAxY2ZlOTNm
MGZkMGU2NGNkMzJmZjQwYmQ0YmE0MSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIz
Mi04MzQ2YjMzZmFkMDFjZmU5M2YwZmQwZTY0Y2QzMmZmNDBiZDRiYTQxCkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi84MzQ2YjMz
ZmFkMDFjZmU5M2YwZmQwZTY0Y2QzMmZmNDBiZDRiYTQxCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzI1MTIzMi04MzQ2YjMzZmFkMDFjZmU5M2YwZmQwZTY0Y2QzMmZmNDBiZDRiYTQxCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93
bi1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi04MzQ2YjMzZmFkMDFj
ZmU5M2YwZmQwZTY0Y2QzMmZmNDBiZDRiYTQxCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzI1MTIzMi84MzQ2YjMzZmFkMDFjZmU5M2YwZmQwZTY0Y2QzMmZmNDBi
ZDRiYTQxL3ZtbGludXotMy4xNi4wLXJjMy0wMDA5Ny1nODM0NmIzMwoKMjAxNC0wNy0yNS0x
MzoxNTo0NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzog
NjQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMp
ClsxYzA5NDcyOGI2OGMyOGU1MmFiYjY0ZjA2ODZhYWNlNjE0OTVhNGZhXSB1c2ItY29yZTog
UmVtb3ZlIEZpeCBtZXMgaW4gZmlsZSBoY2QuYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgzL29iai1i
aXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTA3MjUxMjMyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcyNTEwOjFj
MDk0NzI4YjY4YzI4ZTUyYWJiNjRmMDY4NmFhY2U2MTQ5NWE0ZmE6YmlzZWN0LWxpbnV4MwoK
MjAxNC0wNy0yNS0xMzoxNjo0NSAxYzA5NDcyOGI2OGMyOGU1MmFiYjY0ZjA2ODZhYWNlNjE0
OTVhNGZhIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLTFjMDk0NzI4YjY4YzI4
ZTUyYWJiNjRmMDY4NmFhY2U2MTQ5NWE0ZmEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzFjMDk0NzI4YjY4YzI4ZTUyYWJiNjRm
MDY4NmFhY2U2MTQ5NWE0ZmEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLTFjMDk0NzI4
YjY4YzI4ZTUyYWJiNjRmMDY4NmFhY2U2MTQ5NWE0ZmEKa2VybmVsOiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzFjMDk0NzI4YjY4YzI4ZTUyYWJiNjRmMDY4NmFh
Y2U2MTQ5NWE0ZmEvdm1saW51ei0zLjE2LjAtcmM1LTAwMDY1LWcxYzA5NDcyCgoyMDE0LTA3
LTI1LTEzOjE4OjQ1IGRldGVjdGluZyBib290IHN0YXRlIC4JMjAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAzNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBz
dGVwcykKWzdlYmRiNTJlMTkyYzRkNDk2YTliM2E4N2Q0N2ViYTNlYmEzZTFmZDRdIHBoeTog
bWlwaHkzNjV4OiBSZXByZXNlbnQgZWFjaCBQSFkgY2hhbm5lbCBhcyBhIERUIHN1Ym5vZGUK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi9saW51eC1kZXZlbDpk
ZXZlbC1ob3VybHktMjAxNDA3MjUxMDo3ZWJkYjUyZTE5MmM0ZDQ5NmE5YjNhODdkNDdlYmEz
ZWJhM2UxZmQ0OmJpc2VjdC1saW51eDMKCjIwMTQtMDctMjUtMTM6MTk6NDggN2ViZGI1MmUx
OTJjNGQ0OTZhOWIzYTg3ZDQ3ZWJhM2ViYTNlMWZkNCBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzI1MTIzMi03ZWJkYjUyZTE5MmM0ZDQ5NmE5YjNhODdkNDdlYmEzZWJhM2UxZmQ0CkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIz
Mi83ZWJkYjUyZTE5MmM0ZDQ5NmE5YjNhODdkNDdlYmEzZWJhM2UxZmQ0CndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzI1MTIzMi03ZWJkYjUyZTE5MmM0ZDQ5NmE5YjNhODdkNDdlYmEzZWJhM2Ux
ZmQ0Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi83ZWJk
YjUyZTE5MmM0ZDQ5NmE5YjNhODdkNDdlYmEzZWJhM2UxZmQ0L3ZtbGludXotMy4xNi4wLXJj
NS0wMDAyNy1nN2ViZGI1MgoKMjAxNC0wNy0yNS0xMzoyMzo0OCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTggcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpClszMTAzMzM2MWQ4M2MxYjBlM2I5MDBj
NDc0ZDMxMzc0YjYzODkyYTllXSB4aGNpOiBpbnRyb2R1Y2UgeGhjaV90b19kZXYKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDA3MjUxMDozMTAzMzM2MWQ4M2MxYjBlM2I5MDBjNDc0ZDMxMzc0YjYzODky
YTllOmJpc2VjdC1saW51eDMKCjIwMTQtMDctMjUtMTM6MjU6MDUgMzEwMzMzNjFkODNjMWIw
ZTNiOTAwYzQ3NGQzMTM3NGI2Mzg5MmE5ZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1
MTIzMi0zMTAzMzM2MWQ4M2MxYjBlM2I5MDBjNDc0ZDMxMzc0YjYzODkyYTllCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi8zMTAz
MzM2MWQ4M2MxYjBlM2I5MDBjNDc0ZDMxMzc0YjYzODkyYTllCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzI1MTIzMi0zMTAzMzM2MWQ4M2MxYjBlM2I5MDBjNDc0ZDMxMzc0YjYzODkyYTllCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtl
dG93bi1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi0zMTAzMzM2MWQ4
M2MxYjBlM2I5MDBjNDc0ZDMxMzc0YjYzODkyYTllCmtlcm5lbDogL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMC0wNzI1MTIzMi8zMTAzMzM2MWQ4M2MxYjBlM2I5MDBjNDc0ZDMxMzc0
YjYzODkyYTllL3ZtbGludXotMy4xNi4wLXJjNS0wMDIwOC1nMzEwMzMzNgoKMjAxNC0wNy0y
NS0xMzozMzowNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkyMCBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3Rl
cHMpCltlYTIyYTk1ZDg4YmMxMzgxODg4Y2M0MTU1NmQ0YTkyNzgzMjg1MjIxXSB4aGNpOiBp
bnRyb2R1Y2Ugc3RydWN0IHhoY2lfcmluZ19wb2ludGVyCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDMv
b2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctczAtMDcyNTEyMzIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzI1
MTA6ZWEyMmE5NWQ4OGJjMTM4MTg4OGNjNDE1NTZkNGE5Mjc4MzI4NTIyMTpiaXNlY3QtbGlu
dXgzCgoyMDE0LTA3LTI1LTEzOjM0OjM1IGVhMjJhOTVkODhiYzEzODE4ODhjYzQxNTU2ZDRh
OTI3ODMyODUyMjEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzItZWEyMmE5NWQ4
OGJjMTM4MTg4OGNjNDE1NTZkNGE5Mjc4MzI4NTIyMQpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvZWEyMmE5NWQ4OGJjMTM4MTg4
OGNjNDE1NTZkNGE5Mjc4MzI4NTIyMQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzItZWEy
MmE5NWQ4OGJjMTM4MTg4OGNjNDE1NTZkNGE5Mjc4MzI4NTIyMQprZXJuZWw6IC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvZWEyMmE5NWQ4OGJjMTM4MTg4OGNjNDE1
NTZkNGE5Mjc4MzI4NTIyMS92bWxpbnV6LTMuMTYuMC1yYzUtMDAyMTYtZ2VhMjJhOTUKCjIw
MTQtMDctMjUtMTM6MzY6MzUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxNAkyMCBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDIgc3RlcHMpClsxODI3MTFjMTYwZjlhMTAyY2RlNWJhN2UzOGE4ZTlkNTE1NmIyOTQ1
XSB4aGNpOiBjb21iaW5lIHhoY2lfcXVldWVfYnVsa190eCgpIGFuZCBxdWV1ZV9idWxrX3Nn
X3R4KCkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi9saW51eC1k
ZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MjUxMDoxODI3MTFjMTYwZjlhMTAyY2RlNWJhN2Uz
OGE4ZTlkNTE1NmIyOTQ1OmJpc2VjdC1saW51eDMKCjIwMTQtMDctMjUtMTM6Mzg6MDcgMTgy
NzExYzE2MGY5YTEwMmNkZTViYTdlMzhhOGU5ZDUxNTZiMjk0NSBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzI1MTIzMi0xODI3MTFjMTYwZjlhMTAyY2RlNWJhN2UzOGE4ZTlkNTE1NmIy
OTQ1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzI1MTIzMi8xODI3MTFjMTYwZjlhMTAyY2RlNWJhN2UzOGE4ZTlkNTE1NmIyOTQ1CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1zMC0wNzI1MTIzMi0xODI3MTFjMTYwZjlhMTAyY2RlNWJhN2UzOGE4ZTlk
NTE1NmIyOTQ1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIz
Mi0xODI3MTFjMTYwZjlhMTAyY2RlNWJhN2UzOGE4ZTlkNTE1NmIyOTQ1Cmtlcm5lbDogL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi8xODI3MTFjMTYwZjlhMTAyY2Rl
NWJhN2UzOGE4ZTlkNTE1NmIyOTQ1L3ZtbGludXotMy4xNi4wLXJjNS0wMDIyMi1nMTgyNzEx
YwoKMjAxNC0wNy0yNS0xMzo0NzoxMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNwkyMCBTVUND
RVNTCgpCaXNlY3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDEgc3RlcCkKWzVlZWM2NzdjYTdlNWU1YWUyZWMyZTI2MmYwOTljMmNmNzU4ODhm
MWVdIHhoY2k6IGZpeCB4aGNpX3F1ZXVlX2N0cmxfdHgoKSByaW5nIHNwYWNlIHJlc2VydmF0
aW9uCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvYy9ib290LWJpc2VjdC9saW51eDMvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzI1MTA6NWVlYzY3N2NhN2U1ZTVhZTJlYzJlMjYyZjA5
OWMyY2Y3NTg4OGYxZTpiaXNlY3QtbGludXgzCgoyMDE0LTA3LTI1LTEzOjQ4OjE2IDVlZWM2
NzdjYTdlNWU1YWUyZWMyZTI2MmYwOTljMmNmNzU4ODhmMWUgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctczAtMDcyNTEyMzItNWVlYzY3N2NhN2U1ZTVhZTJlYzJlMjYyZjA5OWMyY2Y3NTg4OGYx
ZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcy
NTEyMzIvNWVlYzY3N2NhN2U1ZTVhZTJlYzJlMjYyZjA5OWMyY2Y3NTg4OGYxZQp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctczAtMDcyNTEyMzItNWVlYzY3N2NhN2U1ZTVhZTJlYzJlMjYyZjA5OWMyY2Y3
NTg4OGYxZQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIv
NWVlYzY3N2NhN2U1ZTVhZTJlYzJlMjYyZjA5OWMyY2Y3NTg4OGYxZS92bWxpbnV6LTMuMTYu
MC1yYzUtMDAyMjMtZzVlZWM2NzcKCjIwMTQtMDctMjUtMTM6NTE6MzMgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLgkzCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbNjFkOWMyYWQzMWIxMWI4N2Mz
MTliYmMyYTk2MzA0MDc0MmJhYzc3Y10geGhjaTogdW5pdCB0ZXN0IHJpbmcgZW5xdWV1ZS9k
ZXF1ZXVlIHJvdXRpbmVzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDMvb2JqLWJpc2VjdApscyAtYSAv
a2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEy
MzIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzI1MTA6NjFkOWMyYWQzMWIxMWI4
N2MzMTliYmMyYTk2MzA0MDc0MmJhYzc3YzpiaXNlY3QtbGludXgzCgoyMDE0LTA3LTI1LTEz
OjUzOjE3IDYxZDljMmFkMzFiMTFiODdjMzE5YmJjMmE5NjMwNDA3NDJiYWM3N2MgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzItNjFkOWMyYWQzMWIxMWI4N2MzMTliYmMyYTk2
MzA0MDc0MmJhYzc3YwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczAtMDcyNTEyMzIvNjFkOWMyYWQzMWIxMWI4N2MzMTliYmMyYTk2MzA0MDc0MmJh
Yzc3Ywp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzItNjFkOWMyYWQzMWIxMWI4N2MzMTli
YmMyYTk2MzA0MDc0MmJhYzc3Ywp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvc25iLXNtb2tlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUx
MjMyLTYxZDljMmFkMzFiMTFiODdjMzE5YmJjMmE5NjMwNDA3NDJiYWM3N2MKa2VybmVsOiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzYxZDljMmFkMzFiMTFiODdj
MzE5YmJjMmE5NjMwNDA3NDJiYWM3N2Mvdm1saW51ei0zLjE2LjAtcmM1LTAwMjI2LWc2MWQ5
YzJhCgoyMDE0LTA3LTI1LTEzOjU3OjE3IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBG
QUlMVVJFClsgICAgMS4xNDg5NjNdIFNpbGljb24gTGFicyBDMiBwb3J0IHN1cHBvcnQgdi4g
MC41MS4wIC0gKEMpIDIwMDcgUm9kb2xmbyBHaW9tZXR0aQpbICAgIDEuMTQ5NzU0XSB1c2Jj
b3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIHJ0c3hfdXNiClsgICAgMS4x
NTQzMzldIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDEuMTU0
NzY5XSBrZXJuZWwgQlVHIGF0IC9rYnVpbGQvc3JjL3Ntb2tlL2luY2x1ZGUvbGludXgvc2Nh
dHRlcmxpc3QuaDoxMTUhClsgICAgMS4xNTUzMDBdIGludmFsaWQgb3Bjb2RlOiAwMDAwIFsj
MV0gUFJFRU1QVCBTTVAgREVCVUdfUEFHRUFMTE9DClsgICAgMS4xNTUzMDBdIE1vZHVsZXMg
bGlua2VkIGluOgpbICAgIDEuMTU1MzAwXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIv
MCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM1LTAwMjI2LWc2MWQ5YzJhICMxClsgICAgMS4xNTUz
MDBdIHRhc2s6IGZmZmY4ODAwMTAyYzAwMDAgdGk6IGZmZmY4ODAwMTAyOGMwMDAgdGFzay50
aTogZmZmZjg4MDAxMDI4YzAwMApbICAgIDEuMTU1MzAwXSBSSVA6IDAwMTA6WzxmZmZmZmZm
ZjgxNTcxZjEyPl0gIFs8ZmZmZmZmZmY4MTU3MWYxMj5dIHNldHVwX3Rlc3Rfc2tpcDY0KzB4
MTUyLzB4MmYwClsgICAgMS4xNTUzMDBdIFJTUDogMDAwMDpmZmZmODgwMDEwMjhmZDA4ICBF
RkxBR1M6IDAwMDEwMjAyClsgICAgMS4xNTUzMDBdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBS
Qlg6IDAwMDAwMDAwMDAwMDAwMDEgUkNYOiAwMDAwMDAwMDAwMDAwMDAzClsgICAgMS4xNTUz
MDBdIFJEWDogMDAwMDAwMDAwMDAwMDAwMSBSU0k6IDAwMDAwMDAwMDAwMDAwMDEgUkRJOiBm
ZmZmZmZmZjgxYzUxOTI4ClsgICAgMS4xNTUzMDBdIFJCUDogZmZmZjg4MDAxMDI4ZmQ2OCBS
MDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS4xNTUz
MDBdIFIxMDogZmZmZjg4MDAwZTg3MTAwMCBSMTE6IGZmZmY4ODAwMTI5MzE0YTggUjEyOiAw
MDAwMDAwMDAwMDBmZmUwClsgICAgMS4xNTUzMDBdIFIxMzogZmZmZjg4MDAxMDI4ZmUxOCBS
MTQ6IGZmZmY4ODAwMTAyOGZlMGMgUjE1OiAwMDAwMDAwMDAwMDAxMDAwClsgICAgMS4xNTUz
MDBdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDEyNDAwMDAwKDAw
MDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjE1NTMwMF0gQ1M6ICAwMDEwIERT
OiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDEuMTU1MzAwXSBD
UjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDAxYjIxMDAwIENSNDogMDAwMDAw
MDAwMDAwMDZmMApbICAgIDEuMTU1MzAwXSBTdGFjazoKWyAgICAxLjE1NTMwMF0gIGZmZmZm
ZmZmZmZmZmZmZmYgZmZmZmZmZmY4MWY3NGI5NyAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAw
MTAyOGZlNDAKWyAgICAxLjE1NTMwMF0gIDAwMDAwMDAwMDAwMGZmZTAgZmZmZjg4MDAwZTg3
MTAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjE1NTMwMF0g
IGZmZmY4ODAwMDk1ZTc4MDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgxZjc0Yjk3IDAw
MDAwMDAwMDAwMDAwMDAKWyAgICAxLjE1NTMwMF0gQ2FsbCBUcmFjZToKWyAgICAxLjE1NTMw
MF0gIFs8ZmZmZmZmZmY4MWY3NGI5Nz5dID8gbW9uX2Jpbl9pbml0KzB4MTA3LzB4MTA3Clsg
ICAgMS4xNTUzMDBdICBbPGZmZmZmZmZmODFmNzRiOTc+XSA/IG1vbl9iaW5faW5pdCsweDEw
Ny8weDEwNwpbICAgIDEuMTU1MzAwXSAgWzxmZmZmZmZmZjgxZjc0ZGQ1Pl0geGhjaV90ZXN0
X2luaXQrMHgyM2UvMHhjNTYKWyAgICAxLjE1NTMwMF0gIFs8ZmZmZmZmZmY4MTU3MWRjMD5d
ID8gc2V0dXBfdGVzdF8zMl8yNDhfOCsweDM3MC8weDM3MApbICAgIDEuMTU1MzAwXSAgWzxm
ZmZmZmZmZjgxMjdmZmZmPl0gPyBtaWdyYXRlX3ZtYXMrMHgyZi8weGMwClsgICAgMS4xNTUz
MDBdICBbPGZmZmZmZmZmODEzYmQyNDY+XSA/IGt2YXNwcmludGYrMHg4Ni8weGEwClsgICAg
MS4xNTUzMDBdICBbPGZmZmZmZmZmODE1NzFkYzA+XSA/IHNldHVwX3Rlc3RfMzJfMjQ4Xzgr
MHgzNzAvMHgzNzAKWyAgICAxLjE1NTMwMF0gIFs8ZmZmZmZmZmY4MTU3MWE1MD5dID8gc2V0
dXBfdGVzdF93cmFwNjQrMHgzODAvMHgzODAKWyAgICAxLjE1NTMwMF0gIFs8ZmZmZmZmZmY4
MTU3MTZkMD5dID8gc2V0dXBfdGVzdF9kb250X3RyaW0rMHgzNTAvMHgzNTAKWyAgICAxLjE1
NTMwMF0gIFs8ZmZmZmZmZmY4MTU3MTM4MD5dID8geGhjaV9yaW5nX2ZyZWUrMHgxZDAvMHgx
ZDAKWyAgICAxLjE1NTMwMF0gIFs8ZmZmZmZmZmY4MWY3NGI5Nz5dID8gbW9uX2Jpbl9pbml0
KzB4MTA3LzB4MTA3ClsgICAgMS4xNTUzMDBdICBbPGZmZmZmZmZmODEwMDIyNDM+XSBkb19v
bmVfaW5pdGNhbGwrMHgxYjMvMHgzMDAKWyAgICAxLjE1NTMwMF0gIFs8ZmZmZmZmZmY4MTBm
MmJlYz5dID8gcGFyc2VfYXJncysweDNmYy8weDZkMApbICAgIDEuMTU1MzAwXSAgWzxmZmZm
ZmZmZjgxZjIwNTkyPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMTgvMHgxZTEKWyAgICAx
LjE1NTMwMF0gIFs8ZmZmZmZmZmY4MWYxZjlmOT5dID8gZG9fZWFybHlfcGFyYW0rMHhjMy8w
eGMzClsgICAgMS4xNTUzMDBdICBbPGZmZmZmZmZmODE2YmFkMzA+XSA/IHJlc3RfaW5pdCsw
eDE2MC8weDE2MApbICAgIDEuMTU1MzAwXSAgWzxmZmZmZmZmZjgxNmJhZDNlPl0ga2VybmVs
X2luaXQrMHhlLzB4MTYwClsgICAgMS4xNTUzMDBdICBbPGZmZmZmZmZmODE2ZDQ2ZmM+XSBy
ZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDEuMTU1MzAwXSAgWzxmZmZmZmZmZjgxNmJh
ZDMwPl0gPyByZXN0X2luaXQrMHgxNjAvMHgxNjAKWyAgICAxLjE1NTMwMF0gQ29kZTogZTgg
NjQgNWEgYjEgZmYgODMgZjAgMDEgMzEgZDIgNDggYzcgYzcgMjggMTkgYzUgODEgMGYgYjYg
ZDggODkgZGUgZTggM2UgNjYgYzUgZmYgNDggNjMgZDMgNDggODMgMDQgZDUgZTAgZGQgZTcg
ODEgMDEgODUgZGIgNzQgMDIgPDBmPiAwYiA0NCA4OSBlMCA0OCA4YiA3NSBjOCA0OCBiYSAw
MCAwMCAwMCA4MCBmZiA3NyAwMCAwMCAyNSBmZiAKWyAgICAxLjE1NTMwMF0gUklQICBbPGZm
ZmZmZmZmODE1NzFmMTI+XSBzZXR1cF90ZXN0X3NraXA2NCsweDE1Mi8weDJmMApbICAgIDEu
MTU1MzAwXSAgUlNQIDxmZmZmODgwMDEwMjhmZDA4PgpbICAgIDEuMTgwMDQxXSAtLS1bIGVu
ZCB0cmFjZSA3ZTg4M2RmOTQxODc3YjYwIF0tLS0KWyAgICAxLjE4MDQ4OF0gS2VybmVsIHBh
bmljIC0gbm90IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIGluaXQhIGV4aXRjb2RlPTB4
MDAwMDAwMGIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi82MWQ5YzJh
ZDMxYjExYjg3YzMxOWJiYzJhOTYzMDQwNzQyYmFjNzdjL2RtZXNnLXF1YW50YWwtaXZiNDEt
MTE5OjIwMTQwNzI1MTM1NTU4Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyOjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi82MWQ5YzJhZDMxYjExYjg3YzMx
OWJiYzJhOTYzMDQwNzQyYmFjNzdjL2RtZXNnLXF1YW50YWwtaXZiNDItMTA6MjAxNDA3MjUx
NDAwMzg6eDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzI6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA3MjUxMjMyLzYxZDljMmFkMzFiMTFiODdjMzE5YmJjMmE5NjMwNDA3
NDJiYWM3N2MvZG1lc2ctcXVhbnRhbC1pdmI0Mi0xMTA6MjAxNDA3MjUxNDAwMzg6eDg2XzY0
LXJhbmRjb25maWctczAtMDcyNTEyMzI6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA3MjUxMjMyLzYxZDljMmFkMzFiMTFiODdjMzE5YmJjMmE5NjMwNDA3NDJiYWM3N2MvZG1l
c2ctcXVhbnRhbC1pdmI0Mi0xMjE6MjAxNDA3MjUxNDAwMzg6eDg2XzY0LXJhbmRjb25maWct
czAtMDcyNTEyMzI6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzYx
ZDljMmFkMzFiMTFiODdjMzE5YmJjMmE5NjMwNDA3NDJiYWM3N2MvZG1lc2ctcXVhbnRhbC1p
dmI0Mi0xNDoyMDE0MDcyNTE0MDAzODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvNjFkOWMyYWQzMWIxMWI4
N2MzMTliYmMyYTk2MzA0MDc0MmJhYzc3Yy9kbWVzZy1xdWFudGFsLWl2YjQyLTI0OjIwMTQw
NzI1MTQwMDM4Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyOjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi82MWQ5YzJhZDMxYjExYjg3YzMxOWJiYzJhOTYz
MDQwNzQyYmFjNzdjL2RtZXNnLXF1YW50YWwtaXZiNDItMzM6MjAxNDA3MjUxNDAwMzg6eDg2
XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzI6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTA3MjUxMjMyLzYxZDljMmFkMzFiMTFiODdjMzE5YmJjMmE5NjMwNDA3NDJiYWM3N2Mv
ZG1lc2ctcXVhbnRhbC1pdmI0Mi0zNjoyMDE0MDcyNTE0MDAzODp4ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNzI1MTIzMjo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIv
NjFkOWMyYWQzMWIxMWI4N2MzMTliYmMyYTk2MzA0MDc0MmJhYzc3Yy9kbWVzZy1xdWFudGFs
LWl2YjQyLTM5OjIwMTQwNzI1MTQwMDM4Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMy
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi82MWQ5YzJhZDMxYjEx
Yjg3YzMxOWJiYzJhOTYzMDQwNzQyYmFjNzdjL2RtZXNnLXF1YW50YWwtaXZiNDItNTM6MjAx
NDA3MjUxNDAwMzg6eDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzI6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzYxZDljMmFkMzFiMTFiODdjMzE5YmJjMmE5
NjMwNDA3NDJiYWM3N2MvZG1lc2ctcXVhbnRhbC1pdmI0Mi02MToyMDE0MDcyNTE0MDAzODp4
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczAtMDcyNTEyMzIvNjFkOWMyYWQzMWIxMWI4N2MzMTliYmMyYTk2MzA0MDc0MmJhYzc3
Yy9kbWVzZy1xdWFudGFsLWl2YjQyLTYzOjIwMTQwNzI1MTQwMDM4Ong4Nl82NC1yYW5kY29u
ZmlnLXMwLTA3MjUxMjMyOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIz
Mi82MWQ5YzJhZDMxYjExYjg3YzMxOWJiYzJhOTYzMDQwNzQyYmFjNzdjL2RtZXNnLXF1YW50
YWwtaXZiNDItNjg6MjAxNDA3MjUxNDAwMzg6eDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEy
MzI6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzYxZDljMmFkMzFi
MTFiODdjMzE5YmJjMmE5NjMwNDA3NDJiYWM3N2MvZG1lc2ctcXVhbnRhbC1pdmI0Mi03Njoy
MDE0MDcyNTE0MDAzODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvNjFkOWMyYWQzMWIxMWI4N2MzMTliYmMy
YTk2MzA0MDc0MmJhYzc3Yy9kbWVzZy1xdWFudGFsLWl2YjQyLTk5OjIwMTQwNzI1MTQwMDM4
Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzI1MTIzMi82MWQ5YzJhZDMxYjExYjg3YzMxOWJiYzJhOTYzMDQwNzQyYmFj
NzdjL2RtZXNnLXlvY3RvLXZwLTE0OjIwMTQwNzI1MTM1NzAwOng4Nl82NC1yYW5kY29uZmln
LXMwLTA3MjUxMjMyOjMuMTYuMC1yYzUtMDAyMjYtZzYxZDljMmE6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzYxZDljMmFkMzFiMTFiODdjMzE5YmJjMmE5NjMw
NDA3NDJiYWM3N2MvZG1lc2cteW9jdG8tdnAtNTA6MjAxNDA3MjUxMzU3MDA6eDg2XzY0LXJh
bmRjb25maWctczAtMDcyNTEyMzI6My4xNi4wLXJjNS0wMDIyNi1nNjFkOWMyYToxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvNjFkOWMyYWQzMWIxMWI4N2MzMTli
YmMyYTk2MzA0MDc0MmJhYzc3Yy9kbWVzZy15b2N0by12cC01NDoyMDE0MDcyNTEzNTcwMDp4
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjozLjE2LjAtcmM1LTAwMjI2LWc2MWQ5YzJh
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi82MWQ5YzJhZDMxYjEx
Yjg3YzMxOWJiYzJhOTYzMDQwNzQyYmFjNzdjL2RtZXNnLXlvY3RvLXZwLTYyOjIwMTQwNzI1
MTM1NzAwOng4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyOjMuMTYuMC1yYzUtMDAyMjYt
ZzYxZDljMmE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzYxZDlj
MmFkMzFiMTFiODdjMzE5YmJjMmE5NjMwNDA3NDJiYWM3N2MvZG1lc2cteW9jdG8tdnAtNjM6
MjAxNDA3MjUxMzU3MDA6eDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzI6My4xNi4wLXJj
NS0wMDIyNi1nNjFkOWMyYToxCjA6MjA6MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
G1sxOzM1bTIwMTQtMDctMjUgMTM6NTc6NDggUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290
LWJpc2VjdC9saW51eDMvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAwIHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbNWE4
N2M2ODU0M2JmZDY0MjFmM2NmNTlhNDRhNDliOTcyNTdkNjA2YV0geGhjaTogdjEuMCBzY2F0
dGVybGlzdCBlbnF1ZXVlIHN1cHBvcnQgKHRkLWZyYWdtZW50IHJld29yaykKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDA3MjUxMDo1YTg3YzY4NTQzYmZkNjQyMWYzY2Y1OWE0NGE0OWI5NzI1N2Q2MDZh
OmJpc2VjdC1saW51eDMKCjIwMTQtMDctMjUtMTM6NTc6NDggNWE4N2M2ODU0M2JmZDY0MjFm
M2NmNTlhNDRhNDliOTcyNTdkNjA2YSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIz
Mi01YTg3YzY4NTQzYmZkNjQyMWYzY2Y1OWE0NGE0OWI5NzI1N2Q2MDZhCkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi81YTg3YzY4
NTQzYmZkNjQyMWYzY2Y1OWE0NGE0OWI5NzI1N2Q2MDZhCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzI1MTIzMi01YTg3YzY4NTQzYmZkNjQyMWYzY2Y1OWE0NGE0OWI5NzI1N2Q2MDZhCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4
MDEtY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzItNWE4N2M2ODU0M2Jm
ZDY0MjFmM2NmNTlhNDRhNDliOTcyNTdkNjA2YQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczAtMDcyNTEyMzIvNWE4N2M2ODU0M2JmZDY0MjFmM2NmNTlhNDRhNDliOTcy
NTdkNjA2YS92bWxpbnV6LTMuMTYuMC1yYzUtMDAyMjQtZzVhODdjNjgKCjIwMTQtMDctMjUt
MTQ6MDA6NDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkyMCBTVUNDRVNTCgo2MWQ5YzJhZDMx
YjExYjg3YzMxOWJiYzJhOTYzMDQwNzQyYmFjNzdjIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0
CmNvbW1pdCA2MWQ5YzJhZDMxYjExYjg3YzMxOWJiYzJhOTYzMDQwNzQyYmFjNzdjCkF1dGhv
cjogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+CkRhdGU6ICAgVHVl
IEp1bCAyMiAwMDowODo1MSAyMDE0IC0wNzAwCgogICAgeGhjaTogdW5pdCB0ZXN0IHJpbmcg
ZW5xdWV1ZS9kZXF1ZXVlIHJvdXRpbmVzCiAgICAKICAgIEdpdmVuIHRoZSBjb21wbGV4aXR5
IG9mIHNhdGlzZnlpbmcgeGhjaSAxLjArIGhvc3QgdHJiIGJvdW5kYXJ5CiAgICBjb25zdHJh
aW50cywgcHJvdmlkZSBhIHRlc3QgY2FzZSB0aGF0IGV4ZXJjaXNlcyBpbnNlcnRpbmcgbWlk
LXNlZ21lbnQKICAgIGxpbmtzIGludG8gYSByaW5nLgogICAgCiAgICBUaGUgbGlua2VyIC0t
d3JhcD0gb3B0aW9uIGlzIHVzZWQgdG8gbm90IHBvbGx1dGUgdGhlIGdsb2JhbCBpZGVudGlm
aWVyCiAgICBzcGFjZSBhbmQgdG8gbWFrZSBpdCBjbGVhciB3aGljaCBzdGFuZGFyZCB4aGNp
IGRyaXZlciByb3V0aW5lcyBhcmUgYmVpbmcKICAgIG1vY2tlZC11cC4gIFRoZSAtLXdyYXA9
IG9wdGlvbiBkb2VzIG5vdCBjb21lIGludG8gcGxheSB3aGVuIGJvdGgKICAgIHhoY2ktaGNk
IGFuZCB4aGNpLXRlc3QgYXJlIGJ1aWx0LWluIHRvIHRoZSBrZXJuZWwsIHNvIG5hbWVzcGFj
ZQogICAgY29sbGlzaW9ucyBhcmUgcHJldmVudGVkIGJ5IGV4Y2x1ZGluZyB4aGNpLXRlc3Qg
ZnJvbSB0aGUgYnVpbGQgd2hlbgogICAgeGhjaS1oY2QgaXMgYnVpbHQtaW4uCiAgICAKICAg
IEl0J3MgdW5mb3J0dW5hdGUgdGhhdCB0aGlzIGlzIGFuIGluLWtlcm5lbCB0ZXN0IHJhdGhl
ciB0aGFuIHVzZXJzcGFjZQogICAgYW5kIHRoYXQgdGhlIGluZnJhc3RydWN0dXJlIGlzIGN1
c3RvbSByYXRoZXIgdGhhbiBnZW5lcmljLiAgVGhhdCBzYWlkLAogICAgaXQgc2VydmVzIGl0
cyBwdXJwb3NlIG9mIGV4ZXJjaXNpbmcgdGhlIGNvcm5lciBjYXNlcyBvZiB0aGUgc2NhdHRl
cmxpc3QKICAgIHBhcnNpbmcgaW1wbGVtZW50YXRpb24gaW4geGhjaS4KICAgIAogICAgU2ln
bmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+Cgo6
MDQwMDAwIDA0MDAwMCAwNTNlMmU4MGU1ODg4MmI5NTg2M2Q5MGFkNzU2OTY0YmU0Zjc0M2Nh
IDI0YzFlNWRhOTA0NmQ2MDBkNjc3NGIzYTNlZTQ1MTM4ZjZlOTA5YWUgTQlkcml2ZXJzCmJp
c2VjdCBydW4gc3VjY2VzcwpIRUFEIGlzIG5vdyBhdCA1YTg3YzY4Li4uIHhoY2k6IHYxLjAg
c2NhdHRlcmxpc3QgZW5xdWV1ZSBzdXBwb3J0ICh0ZC1mcmFnbWVudCByZXdvcmspCmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1
MTIzMi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MjUxMDo1YTg3YzY4NTQzYmZk
NjQyMWYzY2Y1OWE0NGE0OWI5NzI1N2Q2MDZhOmJpc2VjdC1saW51eDMKCjIwMTQtMDctMjUt
MTQ6MDE6NDkgNWE4N2M2ODU0M2JmZDY0MjFmM2NmNTlhNDRhNDliOTcyNTdkNjA2YSByZXVz
ZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzVhODdjNjg1NDNiZmQ2
NDIxZjNjZjU5YTQ0YTQ5Yjk3MjU3ZDYwNmEvdm1saW51ei0zLjE2LjAtcmM1LTAwMjI0LWc1
YTg3YzY4CgoyMDE0LTA3LTI1LTE0OjAxOjQ5IGRldGVjdGluZyBib290IHN0YXRlIC4uLgk2
MCBTVUNDRVNTCgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA1YTg3YzY4Li4uIHhoY2k6
IHYxLjAgc2NhdHRlcmxpc3QgZW5xdWV1ZSBzdXBwb3J0ICh0ZC1mcmFnbWVudCByZXdvcmsp
CkhFQUQgaXMgbm93IGF0IDk4ZTllOWUuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwt
aG91cmx5LTIwMTQwNzI1MTAnCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxNDA3MjUxMDo5OGU5ZTllZmJjNmM0NTg1YzIzYjc3NTUwY2I5NjFkYTFiMGI4Yzg0OmJp
c2VjdC1saW51eDMKIFRFU1QgRkFJTFVSRQpbICAgIDMuMTgwMjMzXSBTaWxpY29uIExhYnMg
QzIgcG9ydCBzdXBwb3J0IHYuIDAuNTEuMCAtIChDKSAyMDA3IFJvZG9sZm8gR2lvbWV0dGkK
WyAgICAzLjE4ODQ3Ml0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZl
ciBydHN4X3VzYgpbICAgIDMuMjAxNzUwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0t
LS0tLS0tLS0KWyAgICAzLjIwMjAwOV0ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9zbW9r
ZS9pbmNsdWRlL2xpbnV4L3NjYXR0ZXJsaXN0Lmg6MTE1IQpbICAgIDMuMjAyMDA5XSBpbnZh
bGlkIG9wY29kZTogMDAwMCBbIzFdIFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExPQwpbICAg
IDMuMjAyMDA5XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAzLjIwMjAwOV0gQ1BVOiAxIFBJ
RDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4wLXJjNi0wMjU1Mi1nOThl
OWU5ZSAjMgpbICAgIDMuMjAyMDA5XSB0YXNrOiBmZmZmODgwMDEwMmMwMDAwIHRpOiBmZmZm
ODgwMDEwMjhjMDAwIHRhc2sudGk6IGZmZmY4ODAwMTAyOGMwMDAKWyAgICAzLjIwMjAwOV0g
UklQOiAwMDEwOls8ZmZmZmZmZmY4MTU3NTFkMj5dICBbPGZmZmZmZmZmODE1NzUxZDI+XSBz
ZXR1cF90ZXN0X3NraXA2NCsweDE1Mi8weDJmMApbICAgIDMuMjAyMDA5XSBSU1A6IDAwMDA6
ZmZmZjg4MDAxMDI4ZmQwOCAgRUZMQUdTOiAwMDAxMDIwMgpbICAgIDMuMjAyMDA5XSBSQVg6
IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiAwMDAwMDAwMDAwMDAwMDAxIFJDWDogMDAwMDAwMDAw
MDAwMDAwMwpbICAgIDMuMjAyMDA5XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDEgUlNJOiAwMDAw
MDAwMDAwMDAwMDAxIFJESTogZmZmZmZmZmY4MWM1NjA1MApbICAgIDMuMjAyMDA5XSBSQlA6
IGZmZmY4ODAwMTAyOGZkNjggUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTogMDAwMDAwMDAw
MDAwMDAwMApbICAgIDMuMjAyMDA5XSBSMTA6IGZmZmY4ODAwMGU0ZTEwMDAgUjExOiBmZmZm
ODgwMDEyOTMxNGE4IFIxMjogMDAwMDAwMDAwMDAwZmZlMApbICAgIDMuMjAyMDA5XSBSMTM6
IGZmZmY4ODAwMTAyOGZlMTggUjE0OiBmZmZmODgwMDEwMjhmZTBjIFIxNTogMDAwMDAwMDAw
MDAwMTAwMApbICAgIDMuMjAyMDA5XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6
ZmZmZjg4MDAxMjUwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgMy4y
MDIwMDldIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAw
M2IKWyAgICAzLjIwMjAwOV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAw
MWIyNTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2ZTAKWyAgICAzLjIwMjAwOV0gU3RhY2s6Clsg
ICAgMy4yMDIwMDldICBmZmZmZmZmZmZmZmZmZmZmIGZmZmZmZmZmODFmNzliYWYgMDAwMDAw
MDAwMDAwMDAwMCBmZmZmODgwMDEwMjhmZTQwClsgICAgMy4yMDIwMDldICAwMDAwMDAwMDAw
MDBmZmUwIGZmZmY4ODAwMGU0ZTEwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAw
MDAwClsgICAgMy4yMDIwMDldICBmZmZmODgwMDA5NjE4YzAwIDAwMDAwMDAwMDAwMDAwMDAg
ZmZmZmZmZmY4MWY3OWJhZiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMy4yMDIwMDldIENhbGwg
VHJhY2U6ClsgICAgMy4yMDIwMDldICBbPGZmZmZmZmZmODFmNzliYWY+XSA/IG1vbl9iaW5f
aW5pdCsweDEwNy8weDEwNwpbICAgIDMuMjAyMDA5XSAgWzxmZmZmZmZmZjgxZjc5YmFmPl0g
PyBtb25fYmluX2luaXQrMHgxMDcvMHgxMDcKWyAgICAzLjIwMjAwOV0gIFs8ZmZmZmZmZmY4
MWY3OWRlZD5dIHhoY2lfdGVzdF9pbml0KzB4MjNlLzB4YzU2ClsgICAgMy4yMDIwMDldICBb
PGZmZmZmZmZmODE1NzUwODA+XSA/IHNldHVwX3Rlc3RfMzJfMjQ4XzgrMHgzNzAvMHgzNzAK
WyAgICAzLjIwMjAwOV0gIFs8ZmZmZmZmZmY4MTI3ZmZmZj5dID8gbWlncmF0ZV9wYWdlX21v
dmVfbWFwcGluZysweDJmLzB4M2UwClsgICAgMy4yMDIwMDldICBbPGZmZmZmZmZmODEzYmZj
YjY+XSA/IGt2YXNwcmludGYrMHg4Ni8weGEwClsgICAgMy4yMDIwMDldICBbPGZmZmZmZmZm
ODE1NzUwODA+XSA/IHNldHVwX3Rlc3RfMzJfMjQ4XzgrMHgzNzAvMHgzNzAKWyAgICAzLjIw
MjAwOV0gIFs8ZmZmZmZmZmY4MTU3NGQxMD5dID8gc2V0dXBfdGVzdF93cmFwNjQrMHgzODAv
MHgzODAKWyAgICAzLjIwMjAwOV0gIFs8ZmZmZmZmZmY4MTU3NDk5MD5dID8gc2V0dXBfdGVz
dF9kb250X3RyaW0rMHgzNTAvMHgzNTAKWyAgICAzLjIwMjAwOV0gIFs8ZmZmZmZmZmY4MTU3
NDY0MD5dID8geGhjaV9yaW5nX2ZyZWUrMHgxZDAvMHgxZDAKWyAgICAzLjIwMjAwOV0gIFs8
ZmZmZmZmZmY4MWY3OWJhZj5dID8gbW9uX2Jpbl9pbml0KzB4MTA3LzB4MTA3ClsgICAgMy4y
MDIwMDldICBbPGZmZmZmZmZmODEwMDIyNDM+XSBkb19vbmVfaW5pdGNhbGwrMHgxYjMvMHgz
MDAKWyAgICAzLjIwMjAwOV0gIFs8ZmZmZmZmZmY4MTBmMmZkYz5dID8gcGFyc2VfYXJncysw
eDNmYy8weDZkMApbICAgIDMuMjAyMDA5XSAgWzxmZmZmZmZmZjgxZjI1NTkyPl0ga2VybmVs
X2luaXRfZnJlZWFibGUrMHgxMTgvMHgxZTEKWyAgICAzLjIwMjAwOV0gIFs8ZmZmZmZmZmY4
MWYyNDlmOT5dID8gZG9fZWFybHlfcGFyYW0rMHhjMy8weGMzClsgICAgMy4yMDIwMDldICBb
PGZmZmZmZmZmODE2YmQwNTA+XSA/IHJlc3RfaW5pdCsweDE2MC8weDE2MApbICAgIDMuMjAy
MDA5XSAgWzxmZmZmZmZmZjgxNmJkMDVlPl0ga2VybmVsX2luaXQrMHhlLzB4MTYwClsgICAg
My4yNjAwMjddICBbPGZmZmZmZmZmODE2ZDZhM2M+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhi
MApbICAgIDMuMjYwMDI3XSAgWzxmZmZmZmZmZjgxNmJkMDUwPl0gPyByZXN0X2luaXQrMHgx
NjAvMHgxNjAKWyAgICAzLjI2MDAyN10gQ29kZTogZTggZTQgMmEgYjEgZmYgODMgZjAgMDEg
MzEgZDIgNDggYzcgYzcgNTAgNjAgYzUgODEgMGYgYjYgZDggODkgZGUgZTggZWUgNDMgYzUg
ZmYgNDggNjMgZDMgNDggODMgMDQgZDUgODAgMzQgZTggODEgMDEgODUgZGIgNzQgMDIgPDBm
PiAwYiA0NCA4OSBlMCA0OCA4YiA3NSBjOCA0OCBiYSAwMCAwMCAwMCA4MCBmZiA3NyAwMCAw
MCAyNSBmZiAKWyAgICAzLjI2MDAyN10gUklQICBbPGZmZmZmZmZmODE1NzUxZDI+XSBzZXR1
cF90ZXN0X3NraXA2NCsweDE1Mi8weDJmMApbICAgIDMuMjYwMDI3XSAgUlNQIDxmZmZmODgw
MDEwMjhmZDA4PgpbICAgIDMuMjgxODMzXSAtLS1bIGVuZCB0cmFjZSBkMTExMDRjMDliMWI1
OTZkIF0tLS0KWyAgICAzLjI4MjUyOF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0
dGVtcHRlZCB0byBraWxsIGluaXQhIGV4aXRjb2RlPTB4MDAwMDAwMGIKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi85OGU5ZTllZmJjNmM0NTg1YzIzYjc3NTUwY2I5
NjFkYTFiMGI4Yzg0L2RtZXNnLXF1YW50YWwtaXZiNDItMTIzOjIwMTQwNzI1MTI0NjE2Ong4
Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNzI1MTIzMi85OGU5ZTllZmJjNmM0NTg1YzIzYjc3NTUwY2I5NjFkYTFiMGI4Yzg0
L2RtZXNnLXlvY3RvLWtidWlsZC0yNToyMDE0MDcyNTEyNDAwODp4ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNzI1MTIzMjozLjE2LjAtcmM2LTAyNTUyLWc5OGU5ZTllOjIKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi85OGU5ZTllZmJjNmM0NTg1YzIzYjc3NTUwY2I5
NjFkYTFiMGI4Yzg0L2RtZXNnLXlvY3RvLWl2YjQyLTg0OjIwMTQwNzI1MTI0NjA5Ong4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzI1MTIzMi85OGU5ZTllZmJjNmM0NTg1YzIzYjc3NTUwY2I5NjFkYTFiMGI4Yzg0L2Rt
ZXNnLXF1YW50YWwtaXZiNDItMzoyMDE0MDcyNTEyNDYxNjp4ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzI1MTIzMjo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvOThl
OWU5ZWZiYzZjNDU4NWMyM2I3NzU1MGNiOTYxZGExYjBiOGM4NC9kbWVzZy1xdWFudGFsLWl2
YjQyLTk0OjIwMTQwNzI1MTI0NjIxOng4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyOjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi85OGU5ZTllZmJjNmM0NTg1
YzIzYjc3NTUwY2I5NjFkYTFiMGI4Yzg0L2RtZXNnLXlvY3RvLWtidWlsZC0xNjoyMDE0MDcy
NTEyNDAwOTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjozLjE2LjAtcmM2LTAyNTUy
LWc5OGU5ZTllOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi85OGU5
ZTllZmJjNmM0NTg1YzIzYjc3NTUwY2I5NjFkYTFiMGI4Yzg0L2RtZXNnLXF1YW50YWwtaXZi
NDItODc6MjAxNDA3MjUxMjQ2MTQ6eDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzI6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzk4ZTllOWVmYmM2YzQ1ODVj
MjNiNzc1NTBjYjk2MWRhMWIwYjhjODQvZG1lc2ctcXVhbnRhbC1pdmI0Mi05MToyMDE0MDcy
NTEyNDYxNjp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczAtMDcyNTEyMzIvOThlOWU5ZWZiYzZjNDU4NWMyM2I3NzU1MGNiOTYx
ZGExYjBiOGM4NC9kbWVzZy1xdWFudGFsLWl2YjQzLTEyMjoyMDE0MDcyNTEyNDUwMDp4ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMjo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czAtMDcyNTEyMzIvOThlOWU5ZWZiYzZjNDU4NWMyM2I3NzU1MGNiOTYxZGExYjBiOGM4NC9k
bWVzZy15b2N0by1rYnVpbGQtMTg6MjAxNDA3MjUxMjQwMDc6eDg2XzY0LXJhbmRjb25maWct
czAtMDcyNTEyMzI6My4xNi4wLXJjNi0wMjU1Mi1nOThlOWU5ZToyCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczAtMDcyNTEyMzIvOThlOWU5ZWZiYzZjNDU4NWMyM2I3NzU1MGNiOTYx
ZGExYjBiOGM4NC9kbWVzZy15b2N0by1rYnVpbGQtNToyMDE0MDcyNTEyNDAwODp4ODZfNjQt
cmFuZGNvbmZpZy1zMC0wNzI1MTIzMjozLjE2LjAtcmM2LTAyNTUyLWc5OGU5ZTllOjIKMDox
MToxMSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQgOThlOWU5
ZSAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA3MjUxMCcKCj09PT09
PT09PSBsaW51cy9tYXN0ZXIgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IDk4ZTllOWUuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQwNzI1
MTAnCkhFQUQgaXMgbm93IGF0IDgyZTEzYzcuLi4gTWVyZ2UgYnJhbmNoICdmb3ItMy4xNicg
b2YgZ2l0Oi8vbGludXgtbmZzLm9yZy9+YmZpZWxkcy9saW51eApscyAtYSAva2J1aWxkLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvbGludXM6
bWFzdGVyOjgyZTEzYzcxYmM2NTViNmRjNzExMGRhNGUxNjQwNzlkYWRiNDQ4OTI6YmlzZWN0
LWxpbnV4MwoKMjAxNC0wNy0yNS0xNDowMzo1MyA4MmUxM2M3MWJjNjU1YjZkYzcxMTBkYTRl
MTY0MDc5ZGFkYjQ0ODkyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLTgyZTEz
YzcxYmM2NTViNmRjNzExMGRhNGUxNjQwNzlkYWRiNDQ4OTIKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMyLzgyZTEzYzcxYmM2NTVi
NmRjNzExMGRhNGUxNjQwNzlkYWRiNDQ4OTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MjUxMjMy
LTgyZTEzYzcxYmM2NTViNmRjNzExMGRhNGUxNjQwNzlkYWRiNDQ4OTIKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi04MmUxM2M3MWJjNjU1YjZkYzcxMTBkYTRlMTY0
MDc5ZGFkYjQ0ODkyCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzI1
MTIzMi84MmUxM2M3MWJjNjU1YjZkYzcxMTBkYTRlMTY0MDc5ZGFkYjQ0ODkyL3ZtbGludXot
My4xNi4wLXJjNi0wMDExNy1nODJlMTNjNwoKMjAxNC0wNy0yNS0xNDoyOTo1MyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLgk1OS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk2MCBT
VUNDRVNTCgoKPT09PT09PT09IG5leHQvbWFzdGVyID09PT09PT09PQpGcm9tIGdpdDovL2dp
dG1pcnJvci9uZXh0CiArIGUwZTYzNmQuLi44MDA5ZGM5IGFrcG0gICAgICAgLT4gbmV4dC9h
a3BtICAoZm9yY2VkIHVwZGF0ZSkKICsgOWYyYzI2YS4uLjRkMTk1NDMgYWtwbS1iYXNlICAt
PiBuZXh0L2FrcG0tYmFzZSAgKGZvcmNlZCB1cGRhdGUpCiArIDU5NGE4YmIuLi41YTc0Mzll
IG1hc3RlciAgICAgLT4gbmV4dC9tYXN0ZXIgIChmb3JjZWQgdXBkYXRlKQogICBkMDU3MTkw
Li44MmUxM2M3ICBzdGFibGUgICAgIC0+IG5leHQvc3RhYmxlCkZyb20gZ2l0Oi8vZ2l0bWly
cm9yL25leHQKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDcyMyAtPiBuZXh0LTIw
MTQwNzIzCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA3MjQgLT4gbmV4dC0yMDE0
MDcyNAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNzI1IC0+IG5leHQtMjAxNDA3
MjUKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgODJlMTNjNy4uLiBNZXJnZSBicmFuY2gg
J2Zvci0zLjE2JyBvZiBnaXQ6Ly9saW51eC1uZnMub3JnL35iZmllbGRzL2xpbnV4CkhFQUQg
aXMgbm93IGF0IDVhNzQzOWUuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9y
IDIwMTQwNzI1CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzI1MTIzMi9uZXh0Om1hc3Rlcjo1YTc0MzllZmQxYzVjNDE2Zjc2OGZj
NTUwMDQ4Y2ExMzBjZjRiZjk5OmJpc2VjdC1saW51eDMKCjIwMTQtMDctMjYtMDI6MTM6MDEg
NWE3NDM5ZWZkMWM1YzQxNmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5OSBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzI1MTIzMi01YTc0MzllZmQxYzVjNDE2Zjc2OGZjNTUwMDQ4Y2ExMzBj
ZjRiZjk5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzI1MTIzMi81YTc0MzllZmQxYzVjNDE2Zjc2OGZjNTUwMDQ4Y2ExMzBjZjRiZjk5Cndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzI1MTIzMi01YTc0MzllZmQxYzVjNDE2Zjc2OGZjNTUwMDQ4
Y2ExMzBjZjRiZjk5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctczAtMDcy
NTEyMzItNWE3NDM5ZWZkMWM1YzQxNmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5OQprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcyNTEyMzIvNWE3NDM5ZWZkMWM1YzQx
NmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5OS92bWxpbnV6LTMuMTYuMC1yYzYtbmV4dC0yMDE0
MDcyNQoKMjAxNC0wNy0yNi0wMjozODowMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxNAky
Mgk0NAk2MCBTVUNDRVNTCgo=

--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-rc5-00226-g61d9c2a"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.16.0-rc5 Kernel Configuration
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
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_KMEM is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
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
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLUB_CPU_PARTIAL is not set
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
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
CONFIG_SECCOMP_FILTER=y
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

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_ASN1=m
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
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
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=12
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
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
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
CONFIG_MEMORY_ISOLATION=y
CONFIG_MOVABLE_NODE=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSMALLOC=m
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
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
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
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
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=m
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_ENUM_BASIC is not set

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=m
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=m
CONFIG_RAPIDIO_CPS_GEN2=m
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=m
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
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

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
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
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
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=m
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_CS5535_MFGPT=m
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=m
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=m
CONFIG_DS1682=m
# CONFIG_TI_DAC7512 is not set
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=m
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=m
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_VMWARE_VMCI=m

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=m

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=m
# CONFIG_GENWQE is not set
CONFIG_ECHO=m
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
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=m
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_TC3589X=m
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=m
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=m
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=m
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=m
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=m
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=m
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_SUR40=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
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
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=m
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

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
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_XEN=m
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_DS1WM is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=m
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=m
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=m
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=m
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=m
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SHTC1=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_WM8350=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
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
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=m
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=m
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65218=m
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=m
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
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
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_ARIZONA=m
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_BCM590XX=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_MAX14577=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8907=m
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_PALMAS is not set
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65090=m
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS6586X is not set
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8350=m
CONFIG_REGULATOR_WM8994=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_DVB_CORE=m
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
# CONFIG_VIDEO_ZORAN_LML33 is not set
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_MXB=m

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX25821 is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_SAA7164 is not set

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
# CONFIG_DVB_BUDGET_CORE is not set
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
CONFIG_DVB_PLUTO2=m
# CONFIG_DVB_PT1 is not set
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
# CONFIG_VIDEO_TDA7432 is not set
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_TLV320AIC23B=m
CONFIG_VIDEO_UDA1342=m
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
CONFIG_VIDEO_ADV7183=m
CONFIG_VIDEO_ADV7604=m
# CONFIG_VIDEO_ADV7842 is not set
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
# CONFIG_VIDEO_BT866 is not set
CONFIG_VIDEO_KS0127=m
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
CONFIG_VIDEO_SAA7191=m
CONFIG_VIDEO_TVP514X=m
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=m
CONFIG_VIDEO_TW9903=m
CONFIG_VIDEO_TW9906=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=m
CONFIG_VIDEO_ADV7393=m
# CONFIG_VIDEO_ADV7511 is not set
CONFIG_VIDEO_AD9389B=m
CONFIG_VIDEO_AK881X=m
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#
CONFIG_VIDEO_APTINA_PLL=m
CONFIG_VIDEO_OV7640=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_OV9650=m
CONFIG_VIDEO_VS6624=m
# CONFIG_VIDEO_MT9M032 is not set
CONFIG_VIDEO_MT9P031=m
CONFIG_VIDEO_MT9T001=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_MT9V032=m
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_NOON010PC30 is not set
CONFIG_VIDEO_M5MOLS=m
# CONFIG_VIDEO_S5K6AA is not set
# CONFIG_VIDEO_S5K6A3 is not set
CONFIG_VIDEO_S5K4ECGX=m
CONFIG_VIDEO_S5K5BAF=m
CONFIG_VIDEO_S5C73M3=m

#
# Flash devices
#
CONFIG_VIDEO_ADP1653=m
# CONFIG_VIDEO_AS3645A is not set
# CONFIG_VIDEO_LM3560 is not set
CONFIG_VIDEO_LM3646=m

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=m
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=m
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=m
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88TS2022=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
# CONFIG_MEDIA_TUNER_IT913X is not set
CONFIG_MEDIA_TUNER_R820T=m

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
# CONFIG_DVB_STV6110x is not set
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
CONFIG_DVB_TDA18271C2DD=m

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
# CONFIG_DVB_ZL10036 is not set
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
# CONFIG_DVB_STV0288 is not set
CONFIG_DVB_STB6000=m
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TUNER_CX24113 is not set
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
# CONFIG_DVB_SI21XX is not set
# CONFIG_DVB_TS2020 is not set
CONFIG_DVB_DS3000=m
# CONFIG_DVB_MB86A16 is not set
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
# CONFIG_DVB_CX22700 is not set
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
# CONFIG_DVB_DRXD is not set
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
# CONFIG_DVB_ZL10353 is not set
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
# CONFIG_DVB_DIB7000P is not set
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
# CONFIG_DVB_AF9013 is not set
# CONFIG_DVB_EC100 is not set
CONFIG_DVB_HD29L2=m
# CONFIG_DVB_STV0367 is not set
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_RTL2830=m
# CONFIG_DVB_RTL2832 is not set
CONFIG_DVB_SI2168=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=m
# CONFIG_DVB_LGDT3305 is not set
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
# CONFIG_DVB_DIB8000 is not set
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
# CONFIG_DVB_TUNER_DIB0070 is not set
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_DRX39XYJ is not set
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
# CONFIG_DVB_ISL6423 is not set
CONFIG_DVB_A8293=m
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
# CONFIG_DVB_M88RS2000 is not set
# CONFIG_DVB_AF9033 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=m
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=m
# CONFIG_DRM_PTN3460 is not set
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_VIA=m
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
# CONFIG_DRM_GMA3600 is not set
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_QXL is not set
CONFIG_DRM_BOCHS=m

#
# Frame buffer Devices
#
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=m
CONFIG_FB_LE80578=m
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_RADEON=m
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=m
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=m
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=m
CONFIG_FB_VIRTUAL=m
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_DA9052=m
CONFIG_BACKLIGHT_MAX8925=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=m
CONFIG_BACKLIGHT_ADP8860=m
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_PANDORA=m
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=m
CONFIG_VGASTATE=m
CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_DMAENGINE_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_HRTIMER=m
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
# CONFIG_SND_PCM_XRUN_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_MTPAV is not set
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
# CONFIG_SND_PCI is not set

#
# HD-Audio
#
CONFIG_SND_SPI=y
# CONFIG_SND_USB is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
CONFIG_SND_DICE=m
CONFIG_SND_FIREWIRE_SPEAKERS=m
CONFIG_SND_ISIGHT=m
# CONFIG_SND_SCS1X is not set
CONFIG_SND_FIREWORKS=m
# CONFIG_SND_BEBOB is not set
CONFIG_SND_SOC=m
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
# CONFIG_SND_ATMEL_SOC is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
CONFIG_SND_SOC_FSL_SAI=m
# CONFIG_SND_SOC_FSL_SSI is not set
CONFIG_SND_SOC_FSL_SPDIF=m
CONFIG_SND_SOC_FSL_ESAI=m
CONFIG_SND_SOC_FSL_UTILS=m
# CONFIG_SND_SOC_IMX_AUDMUX is not set
CONFIG_SND_SOC_INTEL_SST=m
CONFIG_SND_SOC_INTEL_SST_ACPI=m
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
CONFIG_SND_SOC_ADAU1701=m
CONFIG_SND_SOC_AK4104=m
CONFIG_SND_SOC_AK4554=m
# CONFIG_SND_SOC_AK4642 is not set
CONFIG_SND_SOC_AK5386=m
CONFIG_SND_SOC_ALC5623=m
CONFIG_SND_SOC_CS42L52=m
CONFIG_SND_SOC_CS42L56=m
# CONFIG_SND_SOC_CS42L73 is not set
CONFIG_SND_SOC_CS4270=m
# CONFIG_SND_SOC_CS4271 is not set
CONFIG_SND_SOC_CS42XX8=m
CONFIG_SND_SOC_CS42XX8_I2C=m
CONFIG_SND_SOC_HDMI_CODEC=m
CONFIG_SND_SOC_PCM1681=m
# CONFIG_SND_SOC_PCM1792A is not set
CONFIG_SND_SOC_PCM512x=m
CONFIG_SND_SOC_PCM512x_I2C=m
# CONFIG_SND_SOC_PCM512x_SPI is not set
# CONFIG_SND_SOC_SGTL5000 is not set
CONFIG_SND_SOC_SIGMADSP=m
CONFIG_SND_SOC_SIGMADSP_I2C=m
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_STA350=m
CONFIG_SND_SOC_TAS5086=m
CONFIG_SND_SOC_TLV320AIC3X=m
# CONFIG_SND_SOC_WM8510 is not set
CONFIG_SND_SOC_WM8523=m
CONFIG_SND_SOC_WM8580=m
CONFIG_SND_SOC_WM8711=m
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8737=m
CONFIG_SND_SOC_WM8741=m
CONFIG_SND_SOC_WM8750=m
# CONFIG_SND_SOC_WM8753 is not set
CONFIG_SND_SOC_WM8770=m
CONFIG_SND_SOC_WM8776=m
# CONFIG_SND_SOC_WM8804 is not set
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8962=m
CONFIG_SND_SOC_TPA6130A2=m
CONFIG_SND_SIMPLE_CARD=m
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
CONFIG_HID_APPLEIR=m
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=m
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
CONFIG_USB_MOUSE=m

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
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_OTG_FSM is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_XHCI_TEST=y
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_MAX3421_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_HCD_BCMA=m
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_HOST=m
CONFIG_USB_DWC2_PLATFORM=y
CONFIG_USB_DWC2_PCI=y

#
# Gadget mode requires USB Gadget support to be enabled
#
# CONFIG_USB_DWC2_DEBUG is not set
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_HOST=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=y
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_LINK_LAYER_TEST=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=m
CONFIG_TAHVO_USB=m
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
CONFIG_USB_ISP1301=m
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=m
CONFIG_MMC_CB710=m
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
CONFIG_MMC_USDHI6ROL0=m
CONFIG_MMC_REALTEK_USB=m
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_USB=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=m
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_ADP5520=m
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=m
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
CONFIG_UIO_MF624=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_SCRUB_PAGES is not set
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=y
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=m
# CONFIG_XEN_MCE_LOG is not set
CONFIG_XEN_HAVE_PVMMU=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=m
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=y

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

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
CONFIG_EXTCON_MAX14577=m
# CONFIG_EXTCON_ARIZONA is not set
# CONFIG_EXTCON_PALMAS is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=m
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m

#
# VME Device Drivers
#
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=m
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_SAMSUNG_USB2 is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=m
CONFIG_MCB_PCI=m

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=m
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m

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
CONFIG_DYNAMIC_DEBUG=y

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
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
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
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
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
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
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
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
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
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
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
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# CONFIG_CRYPTO_CRCT10DIF is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=m
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
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=m
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=m

--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--JSkcQAAxhB1h8DcT--
