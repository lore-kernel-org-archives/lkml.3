Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbaH0RLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:11:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:30240 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaH0RLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:11:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,412,1406617200"; 
   d="log'?scan'208";a="582469120"
Date: Thu, 28 Aug 2014 01:09:31 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [xhci] BUG: unable to handle kernel NULL pointer dereference at
           (null)
Message-ID: <20140827170931.GA27641@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/djbw/usb.git td-fragments-v1

commit e65e21a542cab81d794db4e5fe919c4e1d624ea7
Author:     Dan Williams <dan.j.williams@intel.com>
AuthorDate: Tue Jul 22 00:08:51 2014 -0700
Commit:     Dan Williams <dan.j.williams@intel.com>
CommitDate: Fri Aug 22 10:06:50 2014 -0700

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
    
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

+------------------------------------------------------+------------+------------+
|                                                      | fb6fa3e625 | e65e21a542 |
+------------------------------------------------------+------------+------------+
| boot_successes                                       | 60         | 0          |
| boot_failures                                        | 0          | 20         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference | 0          | 20         |
| Oops                                                 | 0          | 20         |
| RIP:setup_test_skip64                                | 0          | 20         |
| Kernel_panic-not_syncing:Fatal_exception             | 0          | 20         |
| backtrace:do_test                                    | 0          | 20         |
| backtrace:xhci_test_init                             | 0          | 20         |
| backtrace:kernel_init_freeable                       | 0          | 20         |
+------------------------------------------------------+------------+------------+

[   12.405859] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   12.406471] ohci-pci: OHCI PCI platform driver
[   12.406906] ohci-platform: OHCI generic platform driver
[   12.407510] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   12.408218] IP: [<ffffffff81968843>] setup_test_skip64+0x183/0x270
[   12.408781] PGD 0 
[   12.409010] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   12.409450] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc5-00225-ge65e21a #6
[   12.410102] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   12.410599] task: ffff880012128000 ti: ffff880012130000 task.ti: ffff880012130000
[   12.410950] RIP: 0010:[<ffffffff81968843>]  [<ffffffff81968843>] setup_test_skip64+0x183/0x270
[   12.410950] RSP: 0000:ffff880012133d08  EFLAGS: 00010202
[   12.410950] RAX: ffff880012117000 RBX: 0000000000000000 RCX: 000000078000000f
[   12.410950] RDX: 0000000000000040 RSI: 0000000000000f01 RDI: 0000000000000000
[   12.410950] RBP: ffff880012133d48 R08: 0000000000000fe0 R09: 0000000000000000
[   12.410950] R10: 00000000000f0000 R11: 0000000000000001 R12: 0000000080000000
[   12.410950] R13: 0000000000000000 R14: 000000000000ffe0 R15: 000000000000ffe0
[   12.410950] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:0000000000000000
[   12.410950] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   12.410950] CR2: 0000000000000000 CR3: 0000000002568000 CR4: 00000000000006b0
[   12.410950] Stack:
[   12.410950]  ffff880012133ddc ffff880012133de8 ffff880012133e10 0000000000000000
[   12.410950]  0000000000000000 ffff88000b1a2400 0000000000000000 0000000000000000
[   12.410950]  ffff880012133e48 ffffffff81d71168 0000000000000000 0000303a35343200
[   12.410950] Call Trace:
[   12.410950]  [<ffffffff81d71168>] do_test.constprop.70+0x47/0x894
[   12.410950]  [<ffffffff819686c0>] ? setup_test_32_248_8+0x340/0x340
[   12.410950]  [<ffffffff81826630>] ? device_create_groups_vargs+0xe0/0x1a0
[   12.410950]  [<ffffffff82d3a394>] ? ohci_platform_init+0x60/0x60
[   12.410950]  [<ffffffff82d3a585>] xhci_test_init+0x1f1/0x2a5
[   12.410950]  [<ffffffff819686c0>] ? setup_test_32_248_8+0x340/0x340
[   12.410950]  [<ffffffff81968380>] ? setup_test_wrap64+0x320/0x320
[   12.410950]  [<ffffffff81968060>] ? setup_test_dont_trim+0x2f0/0x2f0
[   12.410950]  [<ffffffff81967d70>] ? xhci_ring_free+0x1d0/0x1d0
[   12.410950]  [<ffffffff82d3a394>] ? ohci_platform_init+0x60/0x60
[   12.410950]  [<ffffffff82ce2695>] do_one_initcall+0x143/0x24d
[   12.410950]  [<ffffffff810dab7b>] ? parse_args+0x2fb/0x530
[   12.410950]  [<ffffffff82ce297b>] kernel_init_freeable+0x1dc/0x2aa
[   12.410950]  [<ffffffff82ce19d5>] ? do_early_param+0xc3/0xc3
[   12.410950]  [<ffffffff81d4b250>] ? rest_init+0xd0/0xd0
[   12.410950]  [<ffffffff81d4b25e>] kernel_init+0xe/0x160
[   12.410950]  [<ffffffff81d88d3c>] ret_from_fork+0x7c/0xb0
[   12.410950]  [<ffffffff81d4b250>] ? rest_init+0xd0/0xd0
[   12.410950] Code: 48 85 ff 40 0f 94 c6 44 0f b6 ce 49 83 c1 02 4a 83 04 cd a0 e9 b3 82 01 45 31 c9 40 84 f6 75 0b 45 0f b6 ca 49 c1 e1 04 49 01 f9 <49> 8b 39 48 8b 30 48 c1 e1 06 4c 89 78 10 44 89 40 08 01 d3 89 
[   12.410950] RIP  [<ffffffff81968843>] setup_test_skip64+0x183/0x270
[   12.410950]  RSP <ffff880012133d08>
[   12.410950] CR2: 0000000000000000
[   12.410950] ---[ end trace 3157077290b0c2c1 ]---
[   12.410950] Kernel panic - not syncing: Fatal exception

git bisect start 66e8dfa4e0d9600dedc08adcaac83c378b65351b 52addcf9d6669fa439387610bc65c92fa0980cef --
git bisect good 511b6daa3a596ab5c54bee5dab56ed4f77337a40  # 22:39     20+      0  Merge 'ipvs-next/master' into devel-hourly-2014082722
git bisect  bad 73e9ac542728ea03b8796cf9818950dc9e05d534  # 22:49      0-     20  Merge 'hid/for-3.18/upstream' into devel-hourly-2014082722
git bisect good 513dd18bd1b397935660c01daa14e53e819b9270  # 23:00     20+      0  Merge 'netdev-next/master' into devel-hourly-2014082722
git bisect good a617416625136eec767df79308544cbb46fe0311  # 23:03     20+      0  Merge 'kvm-ppc/kvm-ppc-queue' into devel-hourly-2014082722
git bisect good 858bf88bf6175c80920daa8c9210b0209443b7e1  # 23:06     20+      0  Merge 'spi/for-next' into devel-hourly-2014082722
git bisect good cdb03bc488490bb364fa29ec292ecd3291ca5770  # 23:10     20+      0  Merge 'regulator/for-next' into devel-hourly-2014082722
git bisect  bad 8f5a71eb299401d62562e7ab634665ff98850e8f  # 23:13      0-     20  Merge 'djbw-usb/td-fragments-v1' into devel-hourly-2014082722
git bisect good a75ef911cf100b8cf7d25baf6dac8052328a96e7  # 23:22     20+      0  xhci: clarify "ring valid" checks
git bisect good 652b7ee36207f186f3d701675483df43b4845c5c  # 23:26     20+      0  xhci: kill ->num_trbs_free_temp in struct xhci_ring
git bisect good 1c11eb8545a3321e7ca27fc7ba8c56b6e6df2b57  # 23:31     20+      0  xhci: add xhci_ring_reap_td() helper
git bisect  bad e65e21a542cab81d794db4e5fe919c4e1d624ea7  # 23:54      0-     20  xhci: unit test ring enqueue/dequeue routines
git bisect good fb6fa3e625e1e453aea9eeb97d58bee30e1c0781  # 23:58     20+      0  xhci: v1.0 scatterlist enqueue support (td-fragment rework)
# first bad commit: [e65e21a542cab81d794db4e5fe919c4e1d624ea7] xhci: unit test ring enqueue/dequeue routines
git bisect good fb6fa3e625e1e453aea9eeb97d58bee30e1c0781  # 00:00     60+      0  xhci: v1.0 scatterlist enqueue support (td-fragment rework)
git bisect  bad 66e8dfa4e0d9600dedc08adcaac83c378b65351b  # 00:00      0-     11  0day head guard for 'devel-hourly-2014082722'
git bisect good 68e370289c29e3beac99d59c6d840d470af9dfcf  # 00:19     60+      2  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect good d05446ae2128064a4bb8f74c84f6901ffb5c94bc  # 00:33     60+      1  Add linux-next specific files for 20140827


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

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-vp-32:20140827235402:x86_64-randconfig-hsxa2-08280622:3.16.0-rc5-00225-ge65e21a:6"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc5-00225-ge65e21a (kbuild@jaketown) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #6 SMP Wed Aug 27 23:49:02 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hsxa2-08280622/linux-devel:devel-hourly-2014082722:e65e21a542cab81d794=
db4e5fe919c4e1d624ea7:bisect-linux-5/.vmlinuz-e65e21a542cab81d794db4e5fe919=
c4e1d624ea7-20140827235015-9-vp branch=3Dlinux-devel/devel-hourly-201408272=
2 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa2-08280622/e65e21a542cab81d794=
db4e5fe919c4e1d624ea7/vmlinuz-3.16.0-rc5-00225-ge65e21a drbd.minor_count=3D8
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03c27000, 0x03c27fff] PGTABLE
[    0.000000] BRK [0x03c28000, 0x03c28fff] PGTABLE
[    0.000000] BRK [0x03c29000, 0x03c29fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x03c2a000, 0x03c2afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x03c2b000, 0x03c2bfff] PGTABLE
[    0.000000] BRK [0x03c2c000, 0x03c2cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ff9000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff8001, primary cpu clock
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880012400000 s78336 r0 d2=
4064 u1048576
[    0.000000] pcpu-alloc: s78336 r0 d24064 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240cb40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hsxa2-08280622/linux-devel:devel-hourly-2014082722:e65e21a542ca=
b81d794db4e5fe919c4e1d624ea7:bisect-linux-5/.vmlinuz-e65e21a542cab81d794db4=
e5fe919c4e1d624ea7-20140827235015-9-vp branch=3Dlinux-devel/devel-hourly-20=
14082722 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa2-08280622/e65e21a542ca=
b81d794db4e5fe919c4e1d624ea7/vmlinuz-3.16.0-rc5-00225-ge65e21a drbd.minor_c=
ount=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 251116K/327280K available (13870K kernel code, 7608K=
 rwdata, 8000K rodata, 1160K init, 14528K bss, 76164K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.468 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5386.93 Bogo=
MIPS (lpj=3D26934680)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.020000] ACPI: All ACPI Tables successfully acquired
[    0.020000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.020000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.020000] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.020000] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.020000] Initializing cgroup subsys devices
[    0.020057] Initializing cgroup subsys blkio
[    0.020490] Initializing cgroup subsys perf_event
[    0.021085] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.021085] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.021085] tlb_flushall_shift: 6
[    0.022576] debug: unmapping init [mem 0xffffffff82def000-0xffffffff82df=
4fff]
[    0.026658] Getting VERSION: 50014
[    0.026988] Getting VERSION: 50014
[    0.027324] Getting ID: 0
[    0.027580] Getting ID: ff000000
[    0.027887] Getting LVT0: 8700
[    0.028174] Getting LVT1: 8400
[    0.028521] enabled ExtINT on CPU#0
[    0.029882] ENABLING IO-APIC IRQs
[    0.030035] init IO_APIC IRQs
[    0.030320]  apic 0 pin 0 not connected
[    0.030700] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.031450] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.032193] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.032930] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.033681] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.034427] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.035174] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.035908] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.036772] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.037749] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.038633] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.039394] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.040027] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.040766] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.041515] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.042261]  apic 0 pin 16 not connected
[    0.042618]  apic 0 pin 17 not connected
[    0.042992]  apic 0 pin 18 not connected
[    0.043351]  apic 0 pin 19 not connected
[    0.043708]  apic 0 pin 20 not connected
[    0.044087]  apic 0 pin 21 not connected
[    0.044444]  apic 0 pin 22 not connected
[    0.044810]  apic 0 pin 23 not connected
[    0.045312] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.045969] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.046922] Using local APIC timer interrupts.
[    0.046922] calibrating APIC timer ...
[    0.050000] ... lapic delta =3D 6250296
[    0.050000] ... PM-Timer delta =3D 357981
[    0.050000] ... PM-Timer result ok
[    0.050000] ..... delta 6250296
[    0.050000] ..... mult: 268448169
[    0.050000] ..... calibration result: 10000473
[    0.050000] ..... CPU clock speed is 2695.0743 MHz.
[    0.050000] ..... host bus clock speed is 1000.0473 MHz.
[    0.050000] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.050000]=20
[    0.050000] **********************************************************
[    0.050000] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.050000] **                                                      **
[    0.050000] ** trace_printk() being used. Allocating extra memory.  **
[    0.050000] **                                                      **
[    0.050000] ** This means that this is a DEBUG kernel and it is     **
[    0.050000] ** unsafe for produciton use.                           **
[    0.050000] **                                                      **
[    0.050016] ** If you see this message and you are not debugging    **
[    0.051084] ** the kernel, report this immediately to your vendor!  **
[    0.052142] **                                                      **
[    0.053201] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.054261] **********************************************************
[    0.060751] x86: Booting SMP configuration:
[    0.061467] .... node  #0, CPUs:      #1
[    0.057666] kvm-clock: cpu 1, msr 0:13ff8041, secondary cpu clock
[    0.057666] masked ExtINT on CPU#1
[    0.080272] x86: Booted up 1 node, 2 CPUs
[    0.080206] KVM setup async PF for cpu 1
[    0.080206] kvm-stealtime: cpu 1, msr 1250cb40
[    0.081463] ----------------
[    0.081729] | NMI testsuite:
[    0.082008] --------------------
[    0.082300]   remote IPI:  ok  |
[    0.090214]    local IPI:  ok  |
[    0.110110] --------------------
[    0.110564] Good, all   2 testcases passed! |
[    0.111128] ---------------------------------
[    0.111685] smpboot: Total of 2 processors activated (10773.87 BogoMIPS)
[    0.130672] xor: measuring software checksum speed
[    0.230038]    prefetch64-sse:   176.800 MB/sec
[    0.330023]    generic_sse:   173.600 MB/sec
[    0.330609] xor: using function: prefetch64-sse (176.800 MB/sec)
[    0.331421] prandom: seed boundary self test passed
[    0.332088] prandom: 100 self tests passed
[    0.332411] regulator-dummy: no parameters
[    0.333469] NET: Registered protocol family 16
[    0.335045] cpuidle: using governor ladder
[    0.335594] cpuidle: using governor menu
[    0.336656] ACPI: bus type PCI registered
[    0.337496] PCI: Using configuration type 1 for base access
[    0.516059] raid6: sse2x1    4689 MB/s
[    0.686054] raid6: sse2x2    6189 MB/s
[    0.856053] raid6: sse2x4    6463 MB/s
[    0.856648] raid6: using algorithm sse2x4 (6463 MB/s)
[    0.857367] raid6: using intx1 recovery algorithm
[    0.860014] ACPI: Added _OSI(Module Device)
[    0.860014] ACPI: Added _OSI(Processor Device)
[    0.860014] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.860017] ACPI: Added _OSI(Processor Aggregator Device)
[    0.872189] ACPI: Interpreter enabled
[    0.872717] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140424/hwxface-580)
[    0.874007] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140424/hwxface-580)
[    0.875341] ACPI: (supports S0 S3 S4 S5)
[    0.875991] ACPI: Using IOAPIC for interrupt routing
[    0.876724] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.892716] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.893632] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.894468] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.900019] PCI host bridge to bus 0000:00
[    0.900019] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.900019] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.900019] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.900019] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.900019] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.901091] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.902918] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.904905] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.910018] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.912288] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.913299] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.914218] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.915217] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.916722] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.918113] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.919135] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.920670] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.925442] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.928396] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.938999] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.941345] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.943603] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.945848] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.954043] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.955680] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.957980] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.960736] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.969395] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.971518] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.973734] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.982124] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.984388] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.986548] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.994885] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.997160] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.999294] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.007836] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.010739] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.012957] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.021479] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.023811] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.025944] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.035445] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.037123] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.044649] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.045877] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.047218] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.048424] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.049494] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.051458] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.054446] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.055619] vgaarb: loaded
[    1.056015] vgaarb: bridge control possible 0000:00:02.0
[    1.058448] ACPI: bus type USB registered
[    1.059208] usbcore: registered new interface driver usbfs
[    1.060073] usbcore: registered new interface driver hub
[    1.061059] usbcore: registered new device driver usb
[    1.061065] Linux video capture interface: v2.00
[    1.062388] PCI: Using ACPI for IRQ routing
[    1.063017] PCI: pci_cache_line_size set to 64 bytes
[    1.064069] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.064944] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.070848] Switched to clocksource kvm-clock
[    1.072655] Warning: could not register all branches stats
[    1.073482] Warning: could not register annotated branches stats
[    1.170562] pnp: PnP ACPI init
[    1.171154] ACPI: bus type PNP registered
[    1.171920] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.173280] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.174309] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.175561] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.176559] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.177852] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.178897] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.180104] pnp 00:03: [dma 2]
[    1.180645] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.181699] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.182965] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.184050] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.185303] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.186347] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    1.187591] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.189266] pnp: PnP ACPI: found 7 devices
[    1.189870] ACPI: bus type PNP unregistered
[    1.196504] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.197323] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.198123] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.199013] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.199974] NET: Registered protocol family 1
[    1.200672] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.201541] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.202399] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.203329] pci 0000:00:02.0: Boot video device
[    1.204111] PCI: CLS 0 bytes, default 64
[    1.205560] Trying to unpack rootfs image as initramfs...
[    2.801022] debug: unmapping init [mem 0xffff88001293d000-0xffff880013fe=
ffff]
[    2.826910] cryptomgr_test (28) used greatest stack depth: 14336 bytes l=
eft
[    2.827835] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    2.828972] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    2.830528] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    2.831973] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    2.832850] PCLMULQDQ-NI instructions are not detected.
[    2.833521] AVX instructions are not detected.
[    2.834089] AVX instructions are not detected.
[    2.834650] AVX2 instructions are not detected.
[    2.846482] futex hash table entries: 512 (order: 4, 65536 bytes)
[    2.847359] Initialise system trusted keyring
[    2.869822] VFS: Disk quotas dquot_6.5.2
[    2.870752] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.872308] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.875767] ntfs: driver 2.1.30 [Flags: R/O DEBUG].
[    2.877310] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.880733] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.881661] fuse init (API version 7.23)
[    2.883203] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, debug enabled
[    2.888421] NILFS version 2 loaded
[    2.888866] befs: version: 0.9.3
[    2.889577] msgmni has been set to 490
[    2.898267] Key type asymmetric registered
[    2.899133] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    2.900527] io scheduler noop registered (default)
[    2.901146] start plist test
[    2.907966] end plist test
[    2.908328] list_sort_test: start testing list_sort()
[    2.911006] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    2.911623] crc32: self tests passed, processed 225944 bytes in 652844 n=
sec
[    2.913107] crc32c: CRC_LE_BITS =3D 8
[    2.913547] crc32c: self tests passed, processed 225944 bytes in 313282 =
nsec
[    3.706000] crc32_combine: 8373 self tests passed
[    3.800238] tsc: Refined TSC clocksource calibration: 2694.844 MHz
[    4.476571] crc32c_combine: 8373 self tests passed
[    4.477582] rbtree testing -> 28517 cycles
[    5.666720] augmented rbtree testing -> 38804 cycles
[    7.273360] hgafb: HGA card not detected.
[    7.274009] hgafb: probe of hgafb.0 failed with error -22
[    7.274992] usbcore: registered new interface driver udlfb
[    7.275917] ipmi message handler version 39.2
[    7.276638] IPMI System Interface driver.
[    7.277422] ipmi_si: Adding default-specified kcs state machine
[    7.278316] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    7.292806] ipmi_si: Interface detection failed
[    9.140193] ipmi_si: Adding default-specified smic state machine
[    9.141051] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    9.142393] ipmi_si: Interface detection failed
[   12.110182] ipmi_si: Adding default-specified bt state machine
[   12.110775] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   12.111662] ipmi_si: Interface detection failed
[   12.120287] ipmi_si: Unable to find any System Interface(s)
[   12.120861] IPMI Watchdog: driver initialized
[   12.121260] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[   12.122288] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   12.122974] ACPI: Power Button [PWRF]
[   12.140407] r3964: Philips r3964 Driver $Revision: 1.10 $
[   12.140896] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   12.164876] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   12.166617] serial: Freescale lpuart driver
[   12.167420] ppdev: user-space parallel port driver
[   12.167867] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   12.168318] smapi::smapi_init, ERROR invalid usSmapiID
[   12.168743] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[   12.169490] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[   12.170148] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   12.170749] SyncLink PC Card driver $Revision: 4.34 $, tty major#248
[   12.171413] parport_pc 00:04: reported by Plug and Play ACPI
[   12.172037] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   12.254983] brd: module loaded
[   12.257724] loop: module loaded
[   12.258209] dummy-irq: no IRQ given.  Use irq=3DN
[   12.258649] lkdtm: No crash points registered, enable through debugfs
[   12.259316] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   12.260162] c2port c2port0: C2 port uc added
[   12.260539] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   12.261393] usbcore: registered new interface driver rtsx_usb
[   12.262144] Uniform Multi-Platform E-IDE driver
[   12.262585] ide-gd driver 1.18
[   12.262886] ide-cd driver 5.00
[   12.263515] SSFDC read-only Flash Translation layer
[   12.264048] slram: not enough parameters.
[   12.269973] parport0: powerup/reset Butterfly
[   12.400318] parport_pc 00:04: registered master spi42
[   12.401105] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[   12.401599] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[   12.402293] parport_pc 00:04: registered child spi42.1
[   12.402744] parport0: dataflash at spi42.1
[   12.403105] parport0: AVR Butterfly
[   12.403510] parport0: cannot grant exclusive access for device ks0108
[   12.404071] ks0108: ERROR: parport didn't register new device
[   12.404567] cfag12864b: ERROR: ks0108 is not initialized
[   12.405038] cfag12864bfb: ERROR: cfag12864b is not initialized
[   12.405859] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   12.406471] ohci-pci: OHCI PCI platform driver
[   12.406906] ohci-platform: OHCI generic platform driver
[   12.407510] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[   12.408218] IP: [<ffffffff81968843>] setup_test_skip64+0x183/0x270
[   12.408781] PGD 0=20
[   12.409010] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   12.409450] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc5-00225-g=
e65e21a #6
[   12.410102] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   12.410599] task: ffff880012128000 ti: ffff880012130000 task.ti: ffff880=
012130000
[   12.410950] RIP: 0010:[<ffffffff81968843>]  [<ffffffff81968843>] setup_t=
est_skip64+0x183/0x270
[   12.410950] RSP: 0000:ffff880012133d08  EFLAGS: 00010202
[   12.410950] RAX: ffff880012117000 RBX: 0000000000000000 RCX: 00000007800=
0000f
[   12.410950] RDX: 0000000000000040 RSI: 0000000000000f01 RDI: 00000000000=
00000
[   12.410950] RBP: ffff880012133d48 R08: 0000000000000fe0 R09: 00000000000=
00000
[   12.410950] R10: 00000000000f0000 R11: 0000000000000001 R12: 00000000800=
00000
[   12.410950] R13: 0000000000000000 R14: 000000000000ffe0 R15: 00000000000=
0ffe0
[   12.410950] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:=
0000000000000000
[   12.410950] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   12.410950] CR2: 0000000000000000 CR3: 0000000002568000 CR4: 00000000000=
006b0
[   12.410950] Stack:
[   12.410950]  ffff880012133ddc ffff880012133de8 ffff880012133e10 00000000=
00000000
[   12.410950]  0000000000000000 ffff88000b1a2400 0000000000000000 00000000=
00000000
[   12.410950]  ffff880012133e48 ffffffff81d71168 0000000000000000 0000303a=
35343200
[   12.410950] Call Trace:
[   12.410950]  [<ffffffff81d71168>] do_test.constprop.70+0x47/0x894
[   12.410950]  [<ffffffff819686c0>] ? setup_test_32_248_8+0x340/0x340
[   12.410950]  [<ffffffff81826630>] ? device_create_groups_vargs+0xe0/0x1a0
[   12.410950]  [<ffffffff82d3a394>] ? ohci_platform_init+0x60/0x60
[   12.410950]  [<ffffffff82d3a585>] xhci_test_init+0x1f1/0x2a5
[   12.410950]  [<ffffffff819686c0>] ? setup_test_32_248_8+0x340/0x340
[   12.410950]  [<ffffffff81968380>] ? setup_test_wrap64+0x320/0x320
[   12.410950]  [<ffffffff81968060>] ? setup_test_dont_trim+0x2f0/0x2f0
[   12.410950]  [<ffffffff81967d70>] ? xhci_ring_free+0x1d0/0x1d0
[   12.410950]  [<ffffffff82d3a394>] ? ohci_platform_init+0x60/0x60
[   12.410950]  [<ffffffff82ce2695>] do_one_initcall+0x143/0x24d
[   12.410950]  [<ffffffff810dab7b>] ? parse_args+0x2fb/0x530
[   12.410950]  [<ffffffff82ce297b>] kernel_init_freeable+0x1dc/0x2aa
[   12.410950]  [<ffffffff82ce19d5>] ? do_early_param+0xc3/0xc3
[   12.410950]  [<ffffffff81d4b250>] ? rest_init+0xd0/0xd0
[   12.410950]  [<ffffffff81d4b25e>] kernel_init+0xe/0x160
[   12.410950]  [<ffffffff81d88d3c>] ret_from_fork+0x7c/0xb0
[   12.410950]  [<ffffffff81d4b250>] ? rest_init+0xd0/0xd0
[   12.410950] Code: 48 85 ff 40 0f 94 c6 44 0f b6 ce 49 83 c1 02 4a 83 04 =
cd a0 e9 b3 82 01 45 31 c9 40 84 f6 75 0b 45 0f b6 ca 49 c1 e1 04 49 01 f9 =
<49> 8b 39 48 8b 30 48 c1 e1 06 4c 89 78 10 44 89 40 08 01 d3 89=20
[   12.410950] RIP  [<ffffffff81968843>] setup_test_skip64+0x183/0x270
[   12.410950]  RSP <ffff880012133d08>
[   12.410950] CR2: 0000000000000000
[   12.410950] ---[ end trace 3157077290b0c2c1 ]---
[   12.410950] Kernel panic - not syncing: Fatal exception
[   12.410950] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffffbfffffff)

Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsxa2-08280622/e65e21a542cab81d794db4e5fe919c4e1d624ea7/vmlinuz-3.16.0-rc5=
-00225-ge65e21a -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 deb=
ug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdi=
sk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnorma=
l  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig=
-hsxa2-08280622/linux-devel:devel-hourly-2014082722:e65e21a542cab81d794db4e=
5fe919c4e1d624ea7:bisect-linux-5/.vmlinuz-e65e21a542cab81d794db4e5fe919c4e1=
d624ea7-20140827235015-9-vp branch=3Dlinux-devel/devel-hourly-2014082722 BO=
OT_IMAGE=3D/kernel/x86_64-randconfig-hsxa2-08280622/e65e21a542cab81d794db4e=
5fe919c4e1d624ea7/vmlinuz-3.16.0-rc5-00225-ge65e21a drbd.minor_count=3D8'  =
-initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic=
,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -wat=
chdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-qu=
antal-vp-32,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-qu=
antal-vp-32,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-qu=
antal-vp-32,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-qu=
antal-vp-32,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-qu=
antal-vp-32,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-qu=
antal-vp-32,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-vp=
-32 -serial file:/dev/shm/kboot/serial-quantal-vp-32 -daemonize -display no=
ne -monitor null=20

--ibTvN161/egqYuK8
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-hsxa2-08280622-66e8dfa4e0d9600dedc08adcaac83c378b65351b-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-53930.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNjZlOGRmYS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA4MjcyMicKZ2l0IGNoZWNrb3V0IDUyYWRkY2Y5ZDY2NjlmYTQzOTM4NzYx
MGJjNjVjOTJmYTA5ODBjZWYKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDgyNzIyOjUyYWRkY2Y5ZDY2NjlmYTQzOTM4NzYxMGJjNjVjOTJmYTA5ODBjZWY6
YmlzZWN0LWxpbnV4LTUKCjIwMTQtMDgtMjcgMjI6MzA6NTkgNTJhZGRjZjlkNjY2OWZhNDM5
Mzg3NjEwYmM2NWM5MmZhMDk4MGNlZiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4
MDYyMi01MmFkZGNmOWQ2NjY5ZmE0MzkzODc2MTBiYzY1YzkyZmEwOTgwY2VmCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi81
MmFkZGNmOWQ2NjY5ZmE0MzkzODc2MTBiYzY1YzkyZmEwOTgwY2VmCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMi0wODI4MDYyMi01MmFkZGNmOWQ2NjY5ZmE0MzkzODc2MTBiYzY1YzkyZmEwOTgw
Y2VmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIt
NTJhZGRjZjlkNjY2OWZhNDM5Mzg3NjEwYmM2NWM5MmZhMDk4MGNlZgprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvNTJhZGRjZjlkNjY2OWZhNDM5
Mzg3NjEwYmM2NWM5MmZhMDk4MGNlZi92bWxpbnV6LTMuMTcuMC1yYzIKCjIwMTQtMDgtMjcg
MjI6MzM6NTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMjAgU1VDQ0VTUwoKYmlzZWN0OiBn
b29kIGNvbW1pdCA1MmFkZGNmOWQ2NjY5ZmE0MzkzODc2MTBiYzY1YzkyZmEwOTgwY2VmCmdp
dCBiaXNlY3Qgc3RhcnQgNjZlOGRmYTRlMGQ5NjAwZGVkYzA4YWRjYWFjODNjMzc4YjY1MzUx
YiA1MmFkZGNmOWQ2NjY5ZmE0MzkzODc2MTBiYzY1YzkyZmEwOTgwY2VmIC0tCi9jL2tlcm5l
bC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgIjY2ZThkZmE0ZTBkOTYwMGRlZGMwOGFk
Y2FhYzgzYzM3OGI2NTM1MWIiLCAiLWciLCAiNTJhZGRjZjlkNjY2OWZhNDM5Mzg3NjEwYmM2
NWM5MmZhMDk4MGNlZiIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIiwgIi9jL2Jvb3QtYmlzZWN0L2xpbnV4LTUvb2JqLWJpc2VjdCJdCkJpc2VjdGlu
ZzogMTkxMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEg
c3RlcHMpCls1MTFiNmRhYTNhNTk2YWI1YzU0YmVlNWRhYjU2ZWQ0Zjc3MzM3YTQwXSBNZXJn
ZSAnaXB2cy1uZXh0L21hc3RlcicgaW50byBkZXZlbC1ob3VybHktMjAxNDA4MjcyMgpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXgtNS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9saW51eC1kZXZlbDpk
ZXZlbC1ob3VybHktMjAxNDA4MjcyMjo1MTFiNmRhYTNhNTk2YWI1YzU0YmVlNWRhYjU2ZWQ0
Zjc3MzM3YTQwOmJpc2VjdC1saW51eC01CgoyMDE0LTA4LTI3IDIyOjM1OjMxIDUxMWI2ZGFh
M2E1OTZhYjVjNTRiZWU1ZGFiNTZlZDRmNzczMzdhNDAgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWct
aHN4YTItMDgyODA2MjItNTExYjZkYWEzYTU5NmFiNWM1NGJlZTVkYWI1NmVkNGY3NzMzN2E0
MApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTIt
MDgyODA2MjIvNTExYjZkYWEzYTU5NmFiNWM1NGJlZTVkYWI1NmVkNGY3NzMzN2E0MAp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctaHN4YTItMDgyODA2MjItNTExYjZkYWEzYTU5NmFiNWM1NGJlZTVkYWI1
NmVkNGY3NzMzN2E0MAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTIt
MDgyODA2MjIvNTExYjZkYWEzYTU5NmFiNWM1NGJlZTVkYWI1NmVkNGY3NzMzN2E0MC92bWxp
bnV6LTMuMTcuMC1yYzItd2wtYXRoLTAwOTk3LWc1MTFiNmRhCgoyMDE0LTA4LTI3IDIyOjM3
OjMxIGRldGVjdGluZyBib290IHN0YXRlIC4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogOTE1
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykK
WzczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgxODk1MGRjOWUwNWQ1MzRdIE1lcmdlICdoaWQv
Zm9yLTMuMTgvdXBzdHJlYW0nIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwODI3MjIKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4LTUvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwODI3MjI6NzNlOWFjNTQyNzI4ZWEwM2I4Nzk2Y2Y5ODE4OTUwZGM5
ZTA1ZDUzNDpiaXNlY3QtbGludXgtNQoKMjAxNC0wOC0yNyAyMjozOTowMSA3M2U5YWM1NDI3
MjhlYTAzYjg3OTZjZjk4MTg5NTBkYzllMDVkNTM0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEyLTA4MjgwNjIyLTczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgxODk1MGRjOWUwNWQ1MzQK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4
MjgwNjIyLzczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgxODk1MGRjOWUwNWQ1MzQKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLTczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgxODk1
MGRjOWUwNWQ1MzQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4
MjgwNjIyLTczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgxODk1MGRjOWUwNWQ1MzQKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzczZTlhYzU0Mjcy
OGVhMDNiODc5NmNmOTgxODk1MGRjOWUwNWQ1MzQvdm1saW51ei0zLjE3LjAtcmMyLXdsLWF0
aC0wMTUwMi1nNzNlOWFjNQoKMjAxNC0wOC0yNyAyMjo0OTowMiBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgMTIuMTcwMDYzXSBvaGNpX2hjZDogVVNCIDEuMSAn
T3BlbicgSG9zdCBDb250cm9sbGVyIChPSENJKSBEcml2ZXIKWyAgIDEyLjE3MTAzN10gb2hj
aS1wY2k6IE9IQ0kgUENJIHBsYXRmb3JtIGRyaXZlcgpbICAgMTIuMTcxNzkwXSBvaGNpLXBs
YXRmb3JtOiBPSENJIGdlbmVyaWMgcGxhdGZvcm0gZHJpdmVyClsgICAxMi4xNzI4ODddIEJV
RzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0
ICAgICAgICAgICAobnVsbCkKWyAgIDEyLjE3Mzk5Nl0gSVA6IFs8ZmZmZmZmZmY4MTk5MDE3
Mz5dIHNldHVwX3Rlc3Rfc2tpcDY0KzB4MTgzLzB4MjcwClsgICAxMi4xNzQ4ODVdIFBHRCAw
IApbICAgMTIuMTc1MTkyXSBPb3BzOiAwMDAwIFsjMV0gU01QIERFQlVHX1BBR0VBTExPQwpb
ICAgMTIuMTc1ODg2XSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRl
ZCAzLjE3LjAtcmMyLXdsLWF0aC0wMTUwMi1nNzNlOWFjNSAjMQpbICAgMTIuMTc3MDEwXSBI
YXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAx
Mi4xNzc4ODFdIHRhc2s6IGZmZmY4ODAwMTIxMjgwMDAgdGk6IGZmZmY4ODAwMTIxMzAwMDAg
dGFzay50aTogZmZmZjg4MDAxMjEzMDAwMApbICAgMTIuMTc4OTg3XSBSSVA6IDAwMTA6Wzxm
ZmZmZmZmZjgxOTkwMTczPl0gIFs8ZmZmZmZmZmY4MTk5MDE3Mz5dIHNldHVwX3Rlc3Rfc2tp
cDY0KzB4MTgzLzB4MjcwClsgICAxMi4xODAwMjBdIFJTUDogMDAwMDpmZmZmODgwMDEyMTMz
ZDA4ICBFRkxBR1M6IDAwMDEwMjAyClsgICAxMi4xODAwMjBdIFJBWDogZmZmZjg4MDAxMTI3
YzgwMCBSQlg6IDAwMDAwMDAwMDAwMDAwMDAgUkNYOiAwMDAwMDAwNzgwMDAwMDBmClsgICAx
Mi4xODAwMjBdIFJEWDogMDAwMDAwMDAwMDAwMDA0MCBSU0k6IDAwMDAwMDAwMDAwMDBmMDEg
UkRJOiAwMDAwMDAwMDAwMDAwMDAwClsgICAxMi4xODAwMjBdIFJCUDogZmZmZjg4MDAxMjEz
M2Q0OCBSMDg6IDAwMDAwMDAwMDAwMDBmZTAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsgICAx
Mi4xODAwMjBdIFIxMDogMDAwMDAwMDAwMDBmMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAg
UjEyOiAwMDAwMDAwMDgwMDAwMDAwClsgICAxMi4xODAwMjBdIFIxMzogMDAwMDAwMDAwMDAw
MDAwMCBSMTQ6IDAwMDAwMDAwMDAwMGZmZTAgUjE1OiAwMDAwMDAwMDAwMDBmZmUwClsgICAx
Mi4xODAwMjBdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDEyNTAw
MDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgIDEyLjE4MDAyMF0gQ1M6ICAw
MDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMwpbICAgMTIuMTgw
MDIwXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDAyNWM1MDAwIENSNDog
MDAwMDAwMDAwMDA0MDZhMApbICAgMTIuMTgwMDIwXSBTdGFjazoKWyAgIDEyLjE4MDAyMF0g
IGZmZmY4ODAwMTIxMzNkZGMgZmZmZjg4MDAxMjEzM2RlOCBmZmZmODgwMDEyMTMzZTEwIDAw
MDAwMDAwMDAwMDAwMDAKWyAgIDEyLjE4MDAyMF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4
MDAwYWQ5NDQwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDEyLjE4
MDAyMF0gIGZmZmY4ODAwMTIxMzNlNDggZmZmZmZmZmY4MWRhZGNlOSAwMDAwMDAwMDAwMDAw
MDAwIDAwMDAzMDNhMzUzNDMyMDAKWyAgIDEyLjE4MDAyMF0gQ2FsbCBUcmFjZToKWyAgIDEy
LjE4MDAyMF0gIFs8ZmZmZmZmZmY4MWRhZGNlOT5dIGRvX3Rlc3QuY29uc3Rwcm9wLjcwKzB4
NDcvMHg4OTQKWyAgIDEyLjE4MDAyMF0gIFs8ZmZmZmZmZmY4MTk4ZmZmMD5dID8gc2V0dXBf
dGVzdF8zMl8yNDhfOCsweDM0MC8weDM0MApbICAgMTIuMTgwMDIwXSAgWzxmZmZmZmZmZjgx
ODQ0YTAwPl0gPyBkZXZpY2VfY3JlYXRlX2dyb3Vwc192YXJncysweGUwLzB4MWEwClsgICAx
Mi4xODAwMjBdICBbPGZmZmZmZmZmODJkYjJkOTk+XSA/IG9oY2lfcGxhdGZvcm1faW5pdCsw
eDYwLzB4NjAKWyAgIDEyLjE4MDAyMF0gIFs8ZmZmZmZmZmY4MmRiMmY4YT5dIHhoY2lfdGVz
dF9pbml0KzB4MWYxLzB4MmE1ClsgICAxMi4xODAwMjBdICBbPGZmZmZmZmZmODE5OGZmZjA+
XSA/IHNldHVwX3Rlc3RfMzJfMjQ4XzgrMHgzNDAvMHgzNDAKWyAgIDEyLjE4MDAyMF0gIFs8
ZmZmZmZmZmY4MTk4ZmNiMD5dID8gc2V0dXBfdGVzdF93cmFwNjQrMHgzMjAvMHgzMjAKWyAg
IDEyLjE4MDAyMF0gIFs8ZmZmZmZmZmY4MTk4Zjk5MD5dID8gc2V0dXBfdGVzdF9kb250X3Ry
aW0rMHgyZjAvMHgyZjAKWyAgIDEyLjE4MDAyMF0gIFs8ZmZmZmZmZmY4MTk4ZjZhMD5dID8g
eGhjaV9yaW5nX2ZyZWUrMHgxZDAvMHgxZDAKWyAgIDEyLjE4MDAyMF0gIFs8ZmZmZmZmZmY4
MmRiMmQ5OT5dID8gb2hjaV9wbGF0Zm9ybV9pbml0KzB4NjAvMHg2MApbICAgMTIuMTgwMDIw
XSAgWzxmZmZmZmZmZjgyZDU5NmIyPl0gZG9fb25lX2luaXRjYWxsKzB4MTQzLzB4MjRkClsg
ICAxMi4xODAwMjBdICBbPGZmZmZmZmZmODEwZGZmYmI+XSA/IHBhcnNlX2FyZ3MrMHgyZmIv
MHg1MzAKWyAgIDEyLjE4MDAyMF0gIFs8ZmZmZmZmZmY4MmQ1OTk5OD5dIGtlcm5lbF9pbml0
X2ZyZWVhYmxlKzB4MWRjLzB4MmFhClsgICAxMi4xODAwMjBdICBbPGZmZmZmZmZmODJkNTg5
ZDU+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4YzMvMHhjMwpbICAgMTIuMTgwMDIwXSAgWzxmZmZm
ZmZmZjgxZDg4NjAwPl0gPyByZXN0X2luaXQrMHhkMC8weGQwClsgICAxMi4xODAwMjBdICBb
PGZmZmZmZmZmODFkODg2MGU+XSBrZXJuZWxfaW5pdCsweGUvMHgxNjAKWyAgIDEyLjE4MDAy
MF0gIFs8ZmZmZmZmZmY4MWRjNWJmYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAx
Mi4xODAwMjBdICBbPGZmZmZmZmZmODFkODg2MDA+XSA/IHJlc3RfaW5pdCsweGQwLzB4ZDAK
WyAgIDEyLjE4MDAyMF0gQ29kZTogNDggODUgZmYgNDAgMGYgOTQgYzYgNDQgMGYgYjYgY2Ug
NDkgODMgYzEgMDIgNGEgODMgMDQgY2QgYzAgZjIgYmEgODIgMDEgNDUgMzEgYzkgNDAgODQg
ZjYgNzUgMGIgNDUgMGYgYjYgY2EgNDkgYzEgZTEgMDQgNDkgMDEgZjkgPDQ5PiA4YiAzOSA0
OCA4YiAzMCA0OCBjMSBlMSAwNiA0YyA4OSA3OCAxMCA0NCA4OSA0MCAwOCAwMSBkMyA4OSAK
WyAgIDEyLjE4MDAyMF0gUklQICBbPGZmZmZmZmZmODE5OTAxNzM+XSBzZXR1cF90ZXN0X3Nr
aXA2NCsweDE4My8weDI3MApbICAgMTIuMTgwMDIwXSAgUlNQIDxmZmZmODgwMDEyMTMzZDA4
PgpbICAgMTIuMTgwMDIwXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDEyLjE4MDAyMF0g
LS0tWyBlbmQgdHJhY2UgMjY4NTZlN2FkOGQxYjRkMCBdLS0tClsgICAxMi4xODAwMjBdIEtl
cm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi83M2U5YWM1NDI3MjhlYTAzYjg3OTZjZjk4
MTg5NTBkYzllMDVkNTM0L2RtZXNnLXF1YW50YWwta2J1aWxkLTEzOjIwMTQwODI3MjI0NzMz
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAx
NTAyLWc3M2U5YWM1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYy
Mi83M2U5YWM1NDI3MjhlYTAzYjg3OTZjZjk4MTg5NTBkYzllMDVkNTM0L2RtZXNnLXF1YW50
YWwta2J1aWxkLTI4OjIwMTQwODI3MjI0NzMzOng4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4
MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAyLWc3M2U5YWM1OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi83M2U5YWM1NDI3MjhlYTAzYjg3OTZjZjk4
MTg5NTBkYzllMDVkNTM0L2RtZXNnLXF1YW50YWwta2J1aWxkLTEwOjIwMTQwODI3MjI0NzM1
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAx
NTAyLWc3M2U5YWM1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYy
Mi83M2U5YWM1NDI3MjhlYTAzYjg3OTZjZjk4MTg5NTBkYzllMDVkNTM0L2RtZXNnLXF1YW50
YWwta2J1aWxkLTE0OjIwMTQwODI3MjI0NzM0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4
MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAyLWc3M2U5YWM1OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi83M2U5YWM1NDI3MjhlYTAzYjg3OTZjZjk4
MTg5NTBkYzllMDVkNTM0L2RtZXNnLXF1YW50YWwta2J1aWxkLTE1OjIwMTQwODI3MjI0NzM1
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAx
NTAyLWc3M2U5YWM1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYy
Mi83M2U5YWM1NDI3MjhlYTAzYjg3OTZjZjk4MTg5NTBkYzllMDVkNTM0L2RtZXNnLXF1YW50
YWwta2J1aWxkLTE3OjIwMTQwODI3MjI0NzM1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4
MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAyLWc3M2U5YWM1OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi83M2U5YWM1NDI3MjhlYTAzYjg3OTZjZjk4
MTg5NTBkYzllMDVkNTM0L2RtZXNnLXF1YW50YWwta2J1aWxkLTE5OjIwMTQwODI3MjI0NzM1
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAx
NTAyLWc3M2U5YWM1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYy
Mi83M2U5YWM1NDI3MjhlYTAzYjg3OTZjZjk4MTg5NTBkYzllMDVkNTM0L2RtZXNnLXF1YW50
YWwta2J1aWxkLTE6MjAxNDA4MjcyMjQ3MzQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgy
ODA2MjI6My4xNy4wLXJjMi13bC1hdGgtMDE1MDItZzczZTlhYzU6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgx
ODk1MGRjOWUwNWQ1MzQvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjE6MjAxNDA4MjcyMjQ3MzQ6
eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjI6My4xNy4wLXJjMi13bC1hdGgtMDE1
MDItZzczZTlhYzU6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIy
LzczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgxODk1MGRjOWUwNWQ1MzQvZG1lc2ctcXVhbnRh
bC1rYnVpbGQtMjM6MjAxNDA4MjcyMjQ3MzQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgy
ODA2MjI6My4xNy4wLXJjMi13bC1hdGgtMDE1MDItZzczZTlhYzU6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgx
ODk1MGRjOWUwNWQ1MzQvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjY6MjAxNDA4MjcyMjQ3MzU6
eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjI6My4xNy4wLXJjMi13bC1hdGgtMDE1
MDItZzczZTlhYzU6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIy
LzczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgxODk1MGRjOWUwNWQ1MzQvZG1lc2ctcXVhbnRh
bC1rYnVpbGQtMjc6MjAxNDA4MjcyMjQ3MzU6eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgy
ODA2MjI6My4xNy4wLXJjMi13bC1hdGgtMDE1MDItZzczZTlhYzU6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgx
ODk1MGRjOWUwNWQ1MzQvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMzI6MjAxNDA4MjcyMjQ3MzU6
eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjI6My4xNy4wLXJjMi13bC1hdGgtMDE1
MDItZzczZTlhYzU6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIy
LzczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgxODk1MGRjOWUwNWQ1MzQvZG1lc2ctcXVhbnRh
bC1rYnVpbGQtMzoyMDE0MDgyNzIyNDczNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4
MDYyMjozLjE3LjAtcmMyLXdsLWF0aC0wMTUwMi1nNzNlOWFjNToxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvNzNlOWFjNTQyNzI4ZWEwM2I4Nzk2Y2Y5ODE4
OTUwZGM5ZTA1ZDUzNC9kbWVzZy1xdWFudGFsLWtidWlsZC02OjIwMTQwODI3MjI0NzM0Ong4
Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAy
LWc3M2U5YWM1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi83
M2U5YWM1NDI3MjhlYTAzYjg3OTZjZjk4MTg5NTBkYzllMDVkNTM0L2RtZXNnLXF1YW50YWwt
a2J1aWxkLTc6MjAxNDA4MjcyMjQ3MzQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2
MjI6My4xNy4wLXJjMi13bC1hdGgtMDE1MDItZzczZTlhYzU6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzczZTlhYzU0MjcyOGVhMDNiODc5NmNmOTgxODk1
MGRjOWUwNWQ1MzQvZG1lc2ctcXVhbnRhbC1rYnVpbGQtODoyMDE0MDgyNzIyNDczNTp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjozLjE3LjAtcmMyLXdsLWF0aC0wMTUwMi1n
NzNlOWFjNToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvNzNl
OWFjNTQyNzI4ZWEwM2I4Nzk2Y2Y5ODE4OTUwZGM5ZTA1ZDUzNC9kbWVzZy1xdWFudGFsLWti
dWlsZC05OjIwMTQwODI3MjI0NzM0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIy
OjMuMTcuMC1yYzItd2wtYXRoLTAxNTAyLWc3M2U5YWM1OjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMi0wODI4MDYyMi83M2U5YWM1NDI3MjhlYTAzYjg3OTZjZjk4MTg5NTBk
YzllMDVkNTM0L2RtZXNnLXF1YW50YWwta2J1aWxkLTMwOjIwMTQwODI3MjI0NzQwOng4Nl82
NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAyLWc3
M2U5YWM1OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi83M2U5
YWM1NDI3MjhlYTAzYjg3OTZjZjk4MTg5NTBkYzllMDVkNTM0L2RtZXNnLXF1YW50YWwta2J1
aWxkLTMxOjIwMTQwODI3MjI0NzQwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIy
OjMuMTcuMC1yYzItd2wtYXRoLTAxNTAyLWc3M2U5YWM1OjEKMDoyMDoyMCBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOC0yNyAyMjo0OTozMyBSRVBFQVQgQ09V
TlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTUvb2JqLWJpc2VjdC8ucmVwZWF0G1sw
bQoKQmlzZWN0aW5nOiA1MDUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDkgc3RlcHMpCls1MTNkZDE4YmQxYjM5NzkzNTY2MGMwMWRhYTE0ZTUzZTgxOWI5
MjcwXSBNZXJnZSAnbmV0ZGV2LW5leHQvbWFzdGVyJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0
MDgyNzIyCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC01L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDgyNzIyOjUxM2RkMThiZDFiMzk3OTM1NjYw
YzAxZGFhMTRlNTNlODE5YjkyNzA6YmlzZWN0LWxpbnV4LTUKCjIwMTQtMDgtMjcgMjI6NDk6
MzMgNTEzZGQxOGJkMWIzOTc5MzU2NjBjMDFkYWExNGU1M2U4MTliOTI3MCBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi01MTNkZDE4YmQxYjM5NzkzNTY2MGMwMWRhYTE0
ZTUzZTgxOWI5MjcwCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMi0wODI4MDYyMi81MTNkZDE4YmQxYjM5NzkzNTY2MGMwMWRhYTE0ZTUzZTgx
OWI5MjcwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi01MTNkZDE4YmQxYjM5Nzkz
NTY2MGMwMWRhYTE0ZTUzZTgxOWI5MjcwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMi0wODI4MDYyMi01MTNkZDE4YmQxYjM5NzkzNTY2MGMwMWRhYTE0ZTUzZTgx
OWI5MjcwCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYy
Mi81MTNkZDE4YmQxYjM5NzkzNTY2MGMwMWRhYTE0ZTUzZTgxOWI5MjcwL3ZtbGludXotMy4x
Ny4wLXJjMi13bC1hdGgtMDEzNTctZzUxM2RkMTgKCjIwMTQtMDgtMjcgMjI6NTg6MzMgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNDUgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpClthNjE3NDE2
NjI1MTM2ZWVjNzY3ZGY3OTMwODU0NGNiYjQ2ZmUwMzExXSBNZXJnZSAna3ZtLXBwYy9rdm0t
cHBjLXF1ZXVlJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDgyNzIyCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9s
aW51eC01L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDgyNzIyOmE2MTc0MTY2MjUxMzZlZWM3NjdkZjc5MzA4NTQ0Y2JiNDZmZTAzMTE6
YmlzZWN0LWxpbnV4LTUKCjIwMTQtMDgtMjcgMjM6MDA6MDQgYTYxNzQxNjYyNTEzNmVlYzc2
N2RmNzkzMDg1NDRjYmI0NmZlMDMxMSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4
MDYyMi1hNjE3NDE2NjI1MTM2ZWVjNzY3ZGY3OTMwODU0NGNiYjQ2ZmUwMzExCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9h
NjE3NDE2NjI1MTM2ZWVjNzY3ZGY3OTMwODU0NGNiYjQ2ZmUwMzExCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMi0wODI4MDYyMi1hNjE3NDE2NjI1MTM2ZWVjNzY3ZGY3OTMwODU0NGNiYjQ2ZmUw
MzExCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9h
NjE3NDE2NjI1MTM2ZWVjNzY3ZGY3OTMwODU0NGNiYjQ2ZmUwMzExL3ZtbGludXotMy4xNy4w
LXJjMi13bC1hdGgtMDE0MTgtZ2E2MTc0MTYKCjIwMTQtMDgtMjcgMjM6MDI6MDQgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA4NCByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzg1OGJmODhiZjYx
NzVjODA5MjBkYWE4YzkyMTBiMDIwOTQ0M2I3ZTFdIE1lcmdlICdzcGkvZm9yLW5leHQnIGlu
dG8gZGV2ZWwtaG91cmx5LTIwMTQwODI3MjIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTUvb2JqLWJp
c2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctaHN4YTItMDgyODA2MjIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwODI3MjI6
ODU4YmY4OGJmNjE3NWM4MDkyMGRhYThjOTIxMGIwMjA5NDQzYjdlMTpiaXNlY3QtbGludXgt
NQoKMjAxNC0wOC0yNyAyMzowMzozNSA4NThiZjg4YmY2MTc1YzgwOTIwZGFhOGM5MjEwYjAy
MDk0NDNiN2UxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLTg1OGJmODhi
ZjYxNzVjODA5MjBkYWE4YzkyMTBiMDIwOTQ0M2I3ZTEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzg1OGJmODhiZjYxNzVj
ODA5MjBkYWE4YzkyMTBiMDIwOTQ0M2I3ZTEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4Mjgw
NjIyLTg1OGJmODhiZjYxNzVjODA5MjBkYWE4YzkyMTBiMDIwOTQ0M2I3ZTEKa2VybmVsOiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzg1OGJmODhiZjYxNzVj
ODA5MjBkYWE4YzkyMTBiMDIwOTQ0M2I3ZTEvdm1saW51ei0zLjE3LjAtcmMyLXdsLWF0aC0w
MTQ1NS1nODU4YmY4OAoKMjAxNC0wOC0yNyAyMzowNTozNSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAJMTQJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKW2NkYjAzYmM0ODg0OTBiYjM2NGZhMjll
YzI5MmVjZDMyOTFjYTU3NzBdIE1lcmdlICdyZWd1bGF0b3IvZm9yLW5leHQnIGludG8gZGV2
ZWwtaG91cmx5LTIwMTQwODI3MjIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTUvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4
YTItMDgyODA2MjIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwODI3MjI6Y2RiMDNi
YzQ4ODQ5MGJiMzY0ZmEyOWVjMjkyZWNkMzI5MWNhNTc3MDpiaXNlY3QtbGludXgtNQoKMjAx
NC0wOC0yNyAyMzowNjozNSBjZGIwM2JjNDg4NDkwYmIzNjRmYTI5ZWMyOTJlY2QzMjkxY2E1
NzcwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLWNkYjAzYmM0ODg0OTBi
YjM2NGZhMjllYzI5MmVjZDMyOTFjYTU3NzAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2NkYjAzYmM0ODg0OTBiYjM2NGZh
MjllYzI5MmVjZDMyOTFjYTU3NzAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLWNk
YjAzYmM0ODg0OTBiYjM2NGZhMjllYzI5MmVjZDMyOTFjYTU3NzAKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVy
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLWNkYjAzYmM0ODg0OTBiYjM2NGZh
MjllYzI5MmVjZDMyOTFjYTU3NzAKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEyLTA4MjgwNjIyL2NkYjAzYmM0ODg0OTBiYjM2NGZhMjllYzI5MmVjZDMyOTFjYTU3
NzAvdm1saW51ei0zLjE3LjAtcmMyLXdsLWF0aC0wMTQ3OS1nY2RiMDNiYwoKMjAxNC0wOC0y
NyAyMzowOTozNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTIwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMjMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3Rl
cHMpCls4ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3YWI2MzQ2NjVmZjk4ODUwZThmXSBNZXJnZSAn
ZGpidy11c2IvdGQtZnJhZ21lbnRzLXYxJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDgyNzIy
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
Yy9ib290LWJpc2VjdC9saW51eC01L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDgyNzIyOjhmNWE3MWViMjk5NDAxZDYyNTYyZTdhYjYz
NDY2NWZmOTg4NTBlOGY6YmlzZWN0LWxpbnV4LTUKCjIwMTQtMDgtMjcgMjM6MTA6MzYgOGY1
YTcxZWIyOTk0MDFkNjI1NjJlN2FiNjM0NjY1ZmY5ODg1MGU4ZiBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMi0wODI4MDYyMi04ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3YWI2MzQ2NjVmZjk4
ODUwZThmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMi0wODI4MDYyMi84ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3YWI2MzQ2NjVmZjk4ODUwZThm
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi04ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3
YWI2MzQ2NjVmZjk4ODUwZThmCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMi0wODI4MDYyMi84ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3YWI2MzQ2NjVmZjk4ODUwZThm
L3ZtbGludXotMy4xNy4wLXJjMi13bC1hdGgtMDE1MDAtZzhmNWE3MWUKCjIwMTQtMDgtMjcg
MjM6MTI6MzYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAzLjU3
NzQxNV0gb2hjaV9oY2Q6IFVTQiAxLjEgJ09wZW4nIEhvc3QgQ29udHJvbGxlciAoT0hDSSkg
RHJpdmVyClsgICAgMy41NzgzNzRdIG9oY2ktcGNpOiBPSENJIFBDSSBwbGF0Zm9ybSBkcml2
ZXIKWyAgICAzLjU3OTA1MV0gb2hjaS1wbGF0Zm9ybTogT0hDSSBnZW5lcmljIHBsYXRmb3Jt
IGRyaXZlcgpbICAgIDMuNTgwMDE2XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5V
TEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgICAgICAgICAgKG51bGwpClsgICAgMy41ODAw
MjFdIElQOiBbPGZmZmZmZmZmODE5OTAxNzM+XSBzZXR1cF90ZXN0X3NraXA2NCsweDE4My8w
eDI3MApbICAgIDMuNTgwMDIxXSBQR0QgMCAKWyAgICAzLjU4MDAyMV0gT29wczogMDAwMCBb
IzFdIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgICAzLjU4MDAyMV0gQ1BVOiAwIFBJRDogMSBD
b21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNy4wLXJjMi13bC1hdGgtMDE1MDAtZzhm
NWE3MWUgIzQKWyAgICAzLjU4MDAyMV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJ
T1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDMuNTgwMDIxXSB0YXNrOiBmZmZmODgwMDEzNTIw
MDAwIHRpOiBmZmZmODgwMDEzNTI4MDAwIHRhc2sudGk6IGZmZmY4ODAwMTM1MjgwMDAKWyAg
ICAzLjU4MDAyMV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTk5MDE3Mz5dICBbPGZmZmZmZmZm
ODE5OTAxNzM+XSBzZXR1cF90ZXN0X3NraXA2NCsweDE4My8weDI3MApbICAgIDMuNTgwMDIx
XSBSU1A6IDAwMDA6ZmZmZjg4MDAxMzUyYmQwOCAgRUZMQUdTOiAwMDAxMDIwMgpbICAgIDMu
NTgwMDIxXSBSQVg6IGZmZmY4ODAwMTBkZjg4MDAgUkJYOiAwMDAwMDAwMDAwMDAwMDAwIFJD
WDogMDAwMDAwMDc4MDAwMDAwZgpbICAgIDMuNTgwMDIxXSBSRFg6IDAwMDAwMDAwMDAwMDAw
NDAgUlNJOiAwMDAwMDAwMDAwMDAwZjAxIFJESTogMDAwMDAwMDAwMDAwMDAwMApbICAgIDMu
NTgwMDIxXSBSQlA6IGZmZmY4ODAwMTM1MmJkNDggUjA4OiAwMDAwMDAwMDAwMDAwZmUwIFIw
OTogMDAwMDAwMDAwMDAwMDAwMApbICAgIDMuNTgwMDIxXSBSMTA6IDAwMDAwMDAwMDAwZjAw
MDAgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogMDAwMDAwMDA4MDAwMDAwMApbICAgIDMu
NTgwMDIxXSBSMTM6IDAwMDAwMDAwMDAwMDAwMDAgUjE0OiAwMDAwMDAwMDAwMDBmZmUwIFIx
NTogMDAwMDAwMDAwMDAwZmZlMApbICAgIDMuNTgwMDIxXSBGUzogIDAwMDAwMDAwMDAwMDAw
MDAoMDAwMCkgR1M6ZmZmZjg4MDAxMzgwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAw
MDAwClsgICAgMy41ODAwMjFdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAw
MDAwMDAwODAwNTAwM2IKWyAgICAzLjU4MDAyMV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENS
MzogMDAwMDAwMDAwMjVjNTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2YjAKWyAgICAzLjU4MDAy
MV0gU3RhY2s6ClsgICAgMy41ODAwMjFdICBmZmZmODgwMDEzNTJiZGRjIGZmZmY4ODAwMTM1
MmJkZTggZmZmZjg4MDAxMzUyYmUxMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMy41ODAwMjFd
ICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMTBlMDA0MDAgMDAwMDAwMDAwMDAwMDAwMCAw
MDAwMDAwMDAwMDAwMDAwClsgICAgMy41ODAwMjFdICBmZmZmODgwMDEzNTJiZTQ4IGZmZmZm
ZmZmODFkYWRjNDkgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMzAzYTM1MzQzMjAwClsgICAgMy41
ODAwMjFdIENhbGwgVHJhY2U6ClsgICAgMy41ODAwMjFdICBbPGZmZmZmZmZmODFkYWRjNDk+
XSBkb190ZXN0LmNvbnN0cHJvcC43MCsweDQ3LzB4ODk0ClsgICAgMy41ODAwMjFdICBbPGZm
ZmZmZmZmODE5OGZmZjA+XSA/IHNldHVwX3Rlc3RfMzJfMjQ4XzgrMHgzNDAvMHgzNDAKWyAg
ICAzLjU4MDAyMV0gIFs8ZmZmZmZmZmY4MTg0NGEwMD5dID8gZGV2aWNlX2NyZWF0ZV9ncm91
cHNfdmFyZ3MrMHhlMC8weDFhMApbICAgIDMuNTgwMDIxXSAgWzxmZmZmZmZmZjgyZGIyZDk5
Pl0gPyBvaGNpX3BsYXRmb3JtX2luaXQrMHg2MC8weDYwClsgICAgMy41ODAwMjFdICBbPGZm
ZmZmZmZmODJkYjJmOGE+XSB4aGNpX3Rlc3RfaW5pdCsweDFmMS8weDJhNQpbICAgIDMuNTgw
MDIxXSAgWzxmZmZmZmZmZjgxOThmZmYwPl0gPyBzZXR1cF90ZXN0XzMyXzI0OF84KzB4MzQw
LzB4MzQwClsgICAgMy41ODAwMjFdICBbPGZmZmZmZmZmODE5OGZjYjA+XSA/IHNldHVwX3Rl
c3Rfd3JhcDY0KzB4MzIwLzB4MzIwClsgICAgMy41ODAwMjFdICBbPGZmZmZmZmZmODE5OGY5
OTA+XSA/IHNldHVwX3Rlc3RfZG9udF90cmltKzB4MmYwLzB4MmYwClsgICAgMy41ODAwMjFd
ICBbPGZmZmZmZmZmODE5OGY2YTA+XSA/IHhoY2lfcmluZ19mcmVlKzB4MWQwLzB4MWQwClsg
ICAgMy41ODAwMjFdICBbPGZmZmZmZmZmODJkYjJkOTk+XSA/IG9oY2lfcGxhdGZvcm1faW5p
dCsweDYwLzB4NjAKWyAgICAzLjU4MDAyMV0gIFs8ZmZmZmZmZmY4MmQ1OTZiMj5dIGRvX29u
ZV9pbml0Y2FsbCsweDE0My8weDI0ZApbICAgIDMuNTgwMDIxXSAgWzxmZmZmZmZmZjgxMGRm
ZmJiPl0gPyBwYXJzZV9hcmdzKzB4MmZiLzB4NTMwClsgICAgMy41ODAwMjFdICBbPGZmZmZm
ZmZmODJkNTk5OTg+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDFkYy8weDJhYQpbICAgIDMu
NTgwMDIxXSAgWzxmZmZmZmZmZjgyZDU4OWQ1Pl0gPyBkb19lYXJseV9wYXJhbSsweGMzLzB4
YzMKWyAgICAzLjU4MDAyMV0gIFs8ZmZmZmZmZmY4MWQ4ODU2MD5dID8gcmVzdF9pbml0KzB4
ZDAvMHhkMApbICAgIDMuNTgwMDIxXSAgWzxmZmZmZmZmZjgxZDg4NTZlPl0ga2VybmVsX2lu
aXQrMHhlLzB4MTYwClsgICAgMy41ODAwMjFdICBbPGZmZmZmZmZmODFkYzViM2M+XSByZXRf
ZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDMuNTgwMDIxXSAgWzxmZmZmZmZmZjgxZDg4NTYw
Pl0gPyByZXN0X2luaXQrMHhkMC8weGQwClsgICAgMy41ODAwMjFdIENvZGU6IDQ4IDg1IGZm
IDQwIDBmIDk0IGM2IDQ0IDBmIGI2IGNlIDQ5IDgzIGMxIDAyIDRhIDgzIDA0IGNkIGMwIGYy
IGJhIDgyIDAxIDQ1IDMxIGM5IDQwIDg0IGY2IDc1IDBiIDQ1IDBmIGI2IGNhIDQ5IGMxIGUx
IDA0IDQ5IDAxIGY5IDw0OT4gOGIgMzkgNDggOGIgMzAgNDggYzEgZTEgMDYgNGMgODkgNzgg
MTAgNDQgODkgNDAgMDggMDEgZDMgODkgClsgICAgMy41ODAwMjFdIFJJUCAgWzxmZmZmZmZm
ZjgxOTkwMTczPl0gc2V0dXBfdGVzdF9za2lwNjQrMHgxODMvMHgyNzAKWyAgICAzLjU4MDAy
MV0gIFJTUCA8ZmZmZjg4MDAxMzUyYmQwOD4KWyAgICAzLjU4MDAyMV0gQ1IyOiAwMDAwMDAw
MDAwMDAwMDAwClsgICAgMy41ODAwMjFdIC0tLVsgZW5kIHRyYWNlIDQ0M2YyMjY2NTRjMjVj
ZDggXS0tLQpbICAgIDMuNTgwMDIxXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0
YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIv
OGY1YTcxZWIyOTk0MDFkNjI1NjJlN2FiNjM0NjY1ZmY5ODg1MGU4Zi9kbWVzZy15b2N0by12
cC02NDoyMDE0MDgyNzIzMTI0MDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjoz
LjE3LjAtcmMyLXdsLWF0aC0wMTUwMC1nOGY1YTcxZTo0Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHN4YTItMDgyODA2MjIvOGY1YTcxZWIyOTk0MDFkNjI1NjJlN2FiNjM0NjY1ZmY5
ODg1MGU4Zi9kbWVzZy15b2N0by12cC0xMzoyMDE0MDgyNzIzMTI0Njp4ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMi0wODI4MDYyMjozLjE3LjAtcmMyLXdsLWF0aC0wMTUwMC1nOGY1YTcxZTo0
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvOGY1YTcxZWIyOTk0
MDFkNjI1NjJlN2FiNjM0NjY1ZmY5ODg1MGU4Zi9kbWVzZy15b2N0by12cC0xNjoyMDE0MDgy
NzIzMTI0NTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjozLjE3LjAtcmMyLXds
LWF0aC0wMTUwMC1nOGY1YTcxZTo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTIt
MDgyODA2MjIvOGY1YTcxZWIyOTk0MDFkNjI1NjJlN2FiNjM0NjY1ZmY5ODg1MGU4Zi9kbWVz
Zy15b2N0by12cC0yNjoyMDE0MDgyNzIzMTI0Njp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0w
ODI4MDYyMjozLjE3LjAtcmMyLXdsLWF0aC0wMTUwMC1nOGY1YTcxZTo0Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvOGY1YTcxZWIyOTk0MDFkNjI1NjJlN2Fi
NjM0NjY1ZmY5ODg1MGU4Zi9kbWVzZy15b2N0by12cC0yNzoyMDE0MDgyNzIzMTI0NDp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjozLjE3LjAtcmMyLXdsLWF0aC0wMTUwMC1n
OGY1YTcxZTo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvOGY1
YTcxZWIyOTk0MDFkNjI1NjJlN2FiNjM0NjY1ZmY5ODg1MGU4Zi9kbWVzZy15b2N0by12cC0y
ODoyMDE0MDgyNzIzMTI0Njp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjozLjE3
LjAtcmMyLXdsLWF0aC0wMTUwMC1nOGY1YTcxZTo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTItMDgyODA2MjIvOGY1YTcxZWIyOTk0MDFkNjI1NjJlN2FiNjM0NjY1ZmY5ODg1
MGU4Zi9kbWVzZy15b2N0by12cC0yOjIwMTQwODI3MjMxMjQ2Ong4Nl82NC1yYW5kY29uZmln
LWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAwLWc4ZjVhNzFlOjQKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi84ZjVhNzFlYjI5OTQwMWQ2
MjU2MmU3YWI2MzQ2NjVmZjk4ODUwZThmL2RtZXNnLXlvY3RvLXZwLTMwOjIwMTQwODI3MjMx
MjQ2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRo
LTAxNTAwLWc4ZjVhNzFlOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4
MDYyMi84ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3YWI2MzQ2NjVmZjk4ODUwZThmL2RtZXNnLXlv
Y3RvLXZwLTMxOjIwMTQwODI3MjMxMjQ2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4Mjgw
NjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAwLWc4ZjVhNzFlOjQKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi84ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3YWI2MzQ2
NjVmZjk4ODUwZThmL2RtZXNnLXlvY3RvLXZwLTM0OjIwMTQwODI3MjMxMjQ2Ong4Nl82NC1y
YW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAwLWc4ZjVh
NzFlOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi84ZjVhNzFl
YjI5OTQwMWQ2MjU2MmU3YWI2MzQ2NjVmZjk4ODUwZThmL2RtZXNnLXlvY3RvLXZwLTM1OjIw
MTQwODI3MjMxMjQ2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1y
YzItd2wtYXRoLTAxNTAwLWc4ZjVhNzFlOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMi0wODI4MDYyMi84ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3YWI2MzQ2NjVmZjk4ODUwZThm
L2RtZXNnLXlvY3RvLXZwLTQwOjIwMTQwODI3MjMxMjQ2Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAwLWc4ZjVhNzFlOjQKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi84ZjVhNzFlYjI5OTQwMWQ2MjU2
MmU3YWI2MzQ2NjVmZjk4ODUwZThmL2RtZXNnLXlvY3RvLXZwLTQxOjIwMTQwODI3MjMxMjQ2
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAx
NTAwLWc4ZjVhNzFlOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYy
Mi84ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3YWI2MzQ2NjVmZjk4ODUwZThmL2RtZXNnLXlvY3Rv
LXZwLTQzOjIwMTQwODI3MjMxMjQ2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIy
OjMuMTcuMC1yYzItd2wtYXRoLTAxNTAwLWc4ZjVhNzFlOjQKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMi0wODI4MDYyMi84ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3YWI2MzQ2NjVm
Zjk4ODUwZThmL2RtZXNnLXlvY3RvLXZwLTUwOjIwMTQwODI3MjMxMjQ2Ong4Nl82NC1yYW5k
Y29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAwLWc4ZjVhNzFl
OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi84ZjVhNzFlYjI5
OTQwMWQ2MjU2MmU3YWI2MzQ2NjVmZjk4ODUwZThmL2RtZXNnLXlvY3RvLXZwLTUyOjIwMTQw
ODI3MjMxMjQ1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzIt
d2wtYXRoLTAxNTAwLWc4ZjVhNzFlOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
Mi0wODI4MDYyMi84ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3YWI2MzQ2NjVmZjk4ODUwZThmL2Rt
ZXNnLXlvY3RvLXZwLTYwOjIwMTQwODI3MjMxMjQ2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEy
LTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAwLWc4ZjVhNzFlOjQKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi84ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3
YWI2MzQ2NjVmZjk4ODUwZThmL2RtZXNnLXlvY3RvLXZwLTYzOjIwMTQwODI3MjMxMjQ1Ong4
Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxNTAw
LWc4ZjVhNzFlOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi84
ZjVhNzFlYjI5OTQwMWQ2MjU2MmU3YWI2MzQ2NjVmZjk4ODUwZThmL2RtZXNnLXlvY3RvLXZw
LTY6MjAxNDA4MjcyMzEyNDQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjI6My4x
Ny4wLXJjMi13bC1hdGgtMDE1MDAtZzhmNWE3MWU6NAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEyLTA4MjgwNjIyLzhmNWE3MWViMjk5NDAxZDYyNTYyZTdhYjYzNDY2NWZmOTg4
NTBlOGYvZG1lc2cteW9jdG8tdnAtOToyMDE0MDgyNzIzMTI0Njp4ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMi0wODI4MDYyMjozLjE3LjAtcmMyLXdsLWF0aC0wMTUwMC1nOGY1YTcxZTo0CjA6
MjA6MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDgtMjcgMjM6
MTM6MDcgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eC01L29iai1i
aXNlY3QvLnJlcGVhdBtbMG0KCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIGRq
YnctdXNiL3RkLWZyYWdtZW50cy12MQpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBn
aXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgOGY1YTcxZWIyOTk0
MDFkNjI1NjJlN2FiNjM0NjY1ZmY5ODg1MGU4ZiBjZGIwM2JjNDg4NDkwYmIzNjRmYTI5ZWMy
OTJlY2QzMjkxY2E1NzcwIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDhmNWE3MWUu
Li4gTWVyZ2UgJ2RqYnctdXNiL3RkLWZyYWdtZW50cy12MScgaW50byBkZXZlbC1ob3VybHkt
MjAxNDA4MjcyMgpIRUFEIGlzIG5vdyBhdCBmNjBmZThkLi4uIE1lcmdlIGJyYW5jaCAnYWtw
bS1jdXJyZW50L2N1cnJlbnQnCkJpc2VjdGluZzogMTAgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpClthNzVlZjkxMWNmMTAwYjhjZjdkMjVi
YWY2ZGFjODA1MjMyOGE5NmU3XSB4aGNpOiBjbGFyaWZ5ICJyaW5nIHZhbGlkIiBjaGVja3MK
bGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC01L29iai1iaXNlY3QK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4LTUvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwODI3MjI6YTc1ZWY5MTFjZjEwMGI4Y2Y3ZDI1YmFmNmRh
YzgwNTIzMjhhOTZlNzpiaXNlY3QtbGludXgtNQoKMjAxNC0wOC0yNyAyMzoxMzoxMyBhNzVl
ZjkxMWNmMTAwYjhjZjdkMjViYWY2ZGFjODA1MjMyOGE5NmU3IGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEyLTA4MjgwNjIyLWE3NWVmOTExY2YxMDBiOGNmN2QyNWJhZjZkYWM4MDUyMzI4
YTk2ZTcKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEyLTA4MjgwNjIyL2E3NWVmOTExY2YxMDBiOGNmN2QyNWJhZjZkYWM4MDUyMzI4YTk2ZTcK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLWE3NWVmOTExY2YxMDBiOGNmN2QyNWJh
ZjZkYWM4MDUyMzI4YTk2ZTcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEyLTA4MjgwNjIyLWE3NWVmOTExY2YxMDBiOGNmN2QyNWJhZjZkYWM4MDUyMzI4YTk2ZTcK
a2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2E3NWVm
OTExY2YxMDBiOGNmN2QyNWJhZjZkYWM4MDUyMzI4YTk2ZTcvdm1saW51ei0zLjE2LjAtcmM1
LTAwMjE1LWdhNzVlZjkxCgoyMDE0LTA4LTI3IDIzOjIxOjE0IGRldGVjdGluZyBib290IHN0
YXRlIC4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzY1MmI3ZWUzNjIwN2YxODZmM2Q3MDE2
NzU0ODNkZjQzYjQ4NDVjNWNdIHhoY2k6IGtpbGwgLT5udW1fdHJic19mcmVlX3RlbXAgaW4g
c3RydWN0IHhoY2lfcmluZwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNS9vYmotYmlzZWN0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0w
ODI4MDYyMi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA4MjcyMjo2NTJiN2VlMzYy
MDdmMTg2ZjNkNzAxNjc1NDgzZGY0M2I0ODQ1YzVjOmJpc2VjdC1saW51eC01CgoyMDE0LTA4
LTI3IDIzOjIyOjQ0IDY1MmI3ZWUzNjIwN2YxODZmM2Q3MDE2NzU0ODNkZjQzYjQ4NDVjNWMg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjItNjUyYjdlZTM2MjA3ZjE4NmYz
ZDcwMTY3NTQ4M2RmNDNiNDg0NWM1YwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvNjUyYjdlZTM2MjA3ZjE4NmYzZDcwMTY3
NTQ4M2RmNDNiNDg0NWM1Ywp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjItNjUyYjdl
ZTM2MjA3ZjE4NmYzZDcwMTY3NTQ4M2RmNDNiNDg0NWM1Ywp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAxLWNvbnN1bWVyL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLTY1MmI3ZWUzNjIwN2YxODZmM2Q3MDE2
NzU0ODNkZjQzYjQ4NDVjNWMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEyLTA4MjgwNjIyLzY1MmI3ZWUzNjIwN2YxODZmM2Q3MDE2NzU0ODNkZjQzYjQ4NDVjNWMv
dm1saW51ei0zLjE2LjAtcmM1LTAwMjIwLWc2NTJiN2VlCgoyMDE0LTA4LTI3IDIzOjI1OjQ1
IGRldGVjdGluZyBib290IHN0YXRlIC4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbMWMxMWVi
ODU0NWEzMzIxZTdjYTI3ZmM3YmE4YzU2YjZlNmRmMmI1N10geGhjaTogYWRkIHhoY2lfcmlu
Z19yZWFwX3RkKCkgaGVscGVyCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC01L29iai1iaXNlY3QKbHMg
LWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEy
LTA4MjgwNjIyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDgyNzIyOjFjMTFlYjg1
NDVhMzMyMWU3Y2EyN2ZjN2JhOGM1NmI2ZTZkZjJiNTc6YmlzZWN0LWxpbnV4LTUKCjIwMTQt
MDgtMjcgMjM6MjY6NDUgMWMxMWViODU0NWEzMzIxZTdjYTI3ZmM3YmE4YzU2YjZlNmRmMmI1
NyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi0xYzExZWI4NTQ1YTMzMjFl
N2NhMjdmYzdiYThjNTZiNmU2ZGYyYjU3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi8xYzExZWI4NTQ1YTMzMjFlN2NhMjdm
YzdiYThjNTZiNmU2ZGYyYjU3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi0xYzEx
ZWI4NTQ1YTMzMjFlN2NhMjdmYzdiYThjNTZiNmU2ZGYyYjU3CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIv
eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjItMWMxMWViODU0NWEzMzIxZTdjYTI3
ZmM3YmE4YzU2YjZlNmRmMmI1NwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHN4YTItMDgyODA2MjIvMWMxMWViODU0NWEzMzIxZTdjYTI3ZmM3YmE4YzU2YjZlNmRmMmI1
Ny92bWxpbnV6LTMuMTYuMC1yYzUtMDAyMjMtZzFjMTFlYjgKCjIwMTQtMDgtMjcgMjM6Mjk6
NDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKW2U2
NWUyMWE1NDJjYWI4MWQ3OTRkYjRlNWZlOTE5YzRlMWQ2MjRlYTddIHhoY2k6IHVuaXQgdGVz
dCByaW5nIGVucXVldWUvZGVxdWV1ZSByb3V0aW5lcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNS9v
YmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA4
MjcyMjplNjVlMjFhNTQyY2FiODFkNzk0ZGI0ZTVmZTkxOWM0ZTFkNjI0ZWE3OmJpc2VjdC1s
aW51eC01CgoyMDE0LTA4LTI3IDIzOjMxOjQ2IGU2NWUyMWE1NDJjYWI4MWQ3OTRkYjRlNWZl
OTE5YzRlMWQ2MjRlYTcgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjItZTY1
ZTIxYTU0MmNhYjgxZDc5NGRiNGU1ZmU5MTljNGUxZDYyNGVhNwpDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvZTY1ZTIxYTU0
MmNhYjgxZDc5NGRiNGU1ZmU5MTljNGUxZDYyNGVhNwp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTIt
MDgyODA2MjItZTY1ZTIxYTU0MmNhYjgxZDc5NGRiNGU1ZmU5MTljNGUxZDYyNGVhNwp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvamFrZXRv
d24tY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjItZTY1ZTIxYTU0
MmNhYjgxZDc5NGRiNGU1ZmU5MTljNGUxZDYyNGVhNwprZXJuZWw6IC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvZTY1ZTIxYTU0MmNhYjgxZDc5NGRiNGU1ZmU5
MTljNGUxZDYyNGVhNy92bWxpbnV6LTMuMTYuMC1yYzUtMDAyMjUtZ2U2NWUyMWEKCjIwMTQt
MDgtMjcgMjM6NTM6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAg
IDEyLjE4OTIwNl0gb2hjaV9oY2Q6IFVTQiAxLjEgJ09wZW4nIEhvc3QgQ29udHJvbGxlciAo
T0hDSSkgRHJpdmVyClsgICAxMi4xOTAzMDldIG9oY2ktcGNpOiBPSENJIFBDSSBwbGF0Zm9y
bSBkcml2ZXIKWyAgIDEyLjE5MTAxM10gb2hjaS1wbGF0Zm9ybTogT0hDSSBnZW5lcmljIHBs
YXRmb3JtIGRyaXZlcgpbICAgMTIuMTkyMDcyXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2Vy
bmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgICAgICAgICAgKG51bGwpClsgICAx
Mi4xOTMyMTJdIElQOiBbPGZmZmZmZmZmODE5Njg4NDM+XSBzZXR1cF90ZXN0X3NraXA2NCsw
eDE4My8weDI3MApbICAgMTIuMTk0MTIzXSBQR0QgMCAKWyAgIDEyLjE5NDQzOV0gT29wczog
MDAwMCBbIzFdIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgIDEyLjE5NTE1MF0gQ1BVOiAwIFBJ
RDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4wLXJjNS0wMDIyNS1nZTY1
ZTIxYSAjNgpbICAgMTIuMTk2MjAzXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAxMi4xOTcwMDJdIHRhc2s6IGZmZmY4ODAwMTIxMjgw
MDAgdGk6IGZmZmY4ODAwMTIxMzAwMDAgdGFzay50aTogZmZmZjg4MDAxMjEzMDAwMApbICAg
MTIuMTk4MDMxXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxOTY4ODQzPl0gIFs8ZmZmZmZmZmY4
MTk2ODg0Mz5dIHNldHVwX3Rlc3Rfc2tpcDY0KzB4MTgzLzB4MjcwClsgICAxMi4xOTkyMzJd
IFJTUDogMDAwMDpmZmZmODgwMDEyMTMzZDA4ICBFRkxBR1M6IDAwMDEwMjAyClsgICAxMi4x
OTk5NzNdIFJBWDogZmZmZjg4MDAwYWQ2MDAwMCBSQlg6IDAwMDAwMDAwMDAwMDAwMDAgUkNY
OiAwMDAwMDAwNzgwMDAwMDBmClsgICAxMi4yMDAwOTBdIFJEWDogMDAwMDAwMDAwMDAwMDA0
MCBSU0k6IDAwMDAwMDAwMDAwMDBmMDEgUkRJOiAwMDAwMDAwMDAwMDAwMDAwClsgICAxMi4y
MDAwOTBdIFJCUDogZmZmZjg4MDAxMjEzM2Q0OCBSMDg6IDAwMDAwMDAwMDAwMDBmZTAgUjA5
OiAwMDAwMDAwMDAwMDAwMDAwClsgICAxMi4yMDAwOTBdIFIxMDogMDAwMDAwMDAwMDBmMDAw
MCBSMTE6IDAwMDAwMDAwMDAwMTQ2ODAgUjEyOiAwMDAwMDAwMDgwMDAwMDAwClsgICAxMi4y
MDAwOTBdIFIxMzogMDAwMDAwMDAwMDAwMDAwMCBSMTQ6IDAwMDAwMDAwMDAwMGZmZTAgUjE1
OiAwMDAwMDAwMDAwMDBmZmUwClsgICAxMi4yMDAwOTBdIEZTOiAgMDAwMDAwMDAwMDAwMDAw
MCgwMDAwKSBHUzpmZmZmODgwMDEyNDAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAw
MDAKWyAgIDEyLjIwMDA5MF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAw
MDAwMDA4MDA1MDAzYgpbICAgMTIuMjAwMDkwXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1Iz
OiAwMDAwMDAwMDAyNTY4MDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgMTIuMjAwMDkw
XSBTdGFjazoKWyAgIDEyLjIwMDA5MF0gIGZmZmY4ODAwMTIxMzNkZGMgZmZmZjg4MDAxMjEz
M2RlOCBmZmZmODgwMDEyMTMzZTEwIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDEyLjIwMDA5MF0g
IDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwYWQ1YzAwMCAwMDAwMDAwMDAwMDAwMDAwIDAw
MDAwMDAwMDAwMDAwMDAKWyAgIDEyLjIwMDA5MF0gIGZmZmY4ODAwMTIxMzNlNDggZmZmZmZm
ZmY4MWQ3MTE2OCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAzMDNhMzUzNDMyMDAKWyAgIDEyLjIw
MDA5MF0gQ2FsbCBUcmFjZToKWyAgIDEyLjIwMDA5MF0gIFs8ZmZmZmZmZmY4MWQ3MTE2OD5d
IGRvX3Rlc3QuY29uc3Rwcm9wLjcwKzB4NDcvMHg4OTQKWyAgIDEyLjIwMDA5MF0gIFs8ZmZm
ZmZmZmY4MTk2ODZjMD5dID8gc2V0dXBfdGVzdF8zMl8yNDhfOCsweDM0MC8weDM0MApbICAg
MTIuMjAwMDkwXSAgWzxmZmZmZmZmZjgxODI2NjMwPl0gPyBkZXZpY2VfY3JlYXRlX2dyb3Vw
c192YXJncysweGUwLzB4MWEwClsgICAxMi4yMDAwOTBdICBbPGZmZmZmZmZmODJkM2EzOTQ+
XSA/IG9oY2lfcGxhdGZvcm1faW5pdCsweDYwLzB4NjAKWyAgIDEyLjIwMDA5MF0gIFs8ZmZm
ZmZmZmY4MmQzYTU4NT5dIHhoY2lfdGVzdF9pbml0KzB4MWYxLzB4MmE1ClsgICAxMi4yMDAw
OTBdICBbPGZmZmZmZmZmODE5Njg2YzA+XSA/IHNldHVwX3Rlc3RfMzJfMjQ4XzgrMHgzNDAv
MHgzNDAKWyAgIDEyLjIwMDA5MF0gIFs8ZmZmZmZmZmY4MTk2ODM4MD5dID8gc2V0dXBfdGVz
dF93cmFwNjQrMHgzMjAvMHgzMjAKWyAgIDEyLjIwMDA5MF0gIFs8ZmZmZmZmZmY4MTk2ODA2
MD5dID8gc2V0dXBfdGVzdF9kb250X3RyaW0rMHgyZjAvMHgyZjAKWyAgIDEyLjIwMDA5MF0g
IFs8ZmZmZmZmZmY4MTk2N2Q3MD5dID8geGhjaV9yaW5nX2ZyZWUrMHgxZDAvMHgxZDAKWyAg
IDEyLjIwMDA5MF0gIFs8ZmZmZmZmZmY4MmQzYTM5ND5dID8gb2hjaV9wbGF0Zm9ybV9pbml0
KzB4NjAvMHg2MApbICAgMTIuMjAwMDkwXSAgWzxmZmZmZmZmZjgyY2UyNjk1Pl0gZG9fb25l
X2luaXRjYWxsKzB4MTQzLzB4MjRkClsgICAxMi4yMDAwOTBdICBbPGZmZmZmZmZmODEwZGFi
N2I+XSA/IHBhcnNlX2FyZ3MrMHgyZmIvMHg1MzAKWyAgIDEyLjIwMDA5MF0gIFs8ZmZmZmZm
ZmY4MmNlMjk3Yj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MWRjLzB4MmFhClsgICAxMi4y
MDAwOTBdICBbPGZmZmZmZmZmODJjZTE5ZDU+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4YzMvMHhj
MwpbICAgMTIuMjAwMDkwXSAgWzxmZmZmZmZmZjgxZDRiMjUwPl0gPyByZXN0X2luaXQrMHhk
MC8weGQwClsgICAxMi4yMDAwOTBdICBbPGZmZmZmZmZmODFkNGIyNWU+XSBrZXJuZWxfaW5p
dCsweGUvMHgxNjAKWyAgIDEyLjIwMDA5MF0gIFs8ZmZmZmZmZmY4MWQ4OGQzYz5dIHJldF9m
cm9tX2ZvcmsrMHg3Yy8weGIwClsgICAxMi4yMDAwOTBdICBbPGZmZmZmZmZmODFkNGIyNTA+
XSA/IHJlc3RfaW5pdCsweGQwLzB4ZDAKWyAgIDEyLjIwMDA5MF0gQ29kZTogNDggODUgZmYg
NDAgMGYgOTQgYzYgNDQgMGYgYjYgY2UgNDkgODMgYzEgMDIgNGEgODMgMDQgY2QgYTAgZTkg
YjMgODIgMDEgNDUgMzEgYzkgNDAgODQgZjYgNzUgMGIgNDUgMGYgYjYgY2EgNDkgYzEgZTEg
MDQgNDkgMDEgZjkgPDQ5PiA4YiAzOSA0OCA4YiAzMCA0OCBjMSBlMSAwNiA0YyA4OSA3OCAx
MCA0NCA4OSA0MCAwOCAwMSBkMyA4OSAKWyAgIDEyLjIwMDA5MF0gUklQICBbPGZmZmZmZmZm
ODE5Njg4NDM+XSBzZXR1cF90ZXN0X3NraXA2NCsweDE4My8weDI3MApbICAgMTIuMjAwMDkw
XSAgUlNQIDxmZmZmODgwMDEyMTMzZDA4PgpbICAgMTIuMjAwMDkwXSBDUjI6IDAwMDAwMDAw
MDAwMDAwMDAKWyAgIDEyLjIwMDA5MF0gLS0tWyBlbmQgdHJhY2UgOTVjNTFkNmVhZWQ4ODUy
MiBdLS0tClsgICAxMi4yMDAwOTBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRh
bCBleGNlcHRpb24KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9l
NjVlMjFhNTQyY2FiODFkNzk0ZGI0ZTVmZTkxOWM0ZTFkNjI0ZWE3L2RtZXNnLXF1YW50YWwt
dnAtMTI6MjAxNDA4MjcyMzUzNTg6eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjI6
My4xNi4wLXJjNS0wMDIyNS1nZTY1ZTIxYTo2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHN4YTItMDgyODA2MjIvZTY1ZTIxYTU0MmNhYjgxZDc5NGRiNGU1ZmU5MTljNGUxZDYyNGVh
Ny9kbWVzZy1xdWFudGFsLXZwLTE0OjIwMTQwODI3MjM1NDAxOng4Nl82NC1yYW5kY29uZmln
LWhzeGEyLTA4MjgwNjIyOjMuMTYuMC1yYzUtMDAyMjUtZ2U2NWUyMWE6Ngova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2U2NWUyMWE1NDJjYWI4MWQ3OTRkYjRl
NWZlOTE5YzRlMWQ2MjRlYTcvZG1lc2ctcXVhbnRhbC12cC0xNToyMDE0MDgyNzIzNTQwMDp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjozLjE2LjAtcmM1LTAwMjI1LWdlNjVl
MjFhOjYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9lNjVlMjFh
NTQyY2FiODFkNzk0ZGI0ZTVmZTkxOWM0ZTFkNjI0ZWE3L2RtZXNnLXF1YW50YWwtdnAtMTY6
MjAxNDA4MjcyMzUzNTk6eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjI6My4xNi4w
LXJjNS0wMDIyNS1nZTY1ZTIxYTo2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTIt
MDgyODA2MjIvZTY1ZTIxYTU0MmNhYjgxZDc5NGRiNGU1ZmU5MTljNGUxZDYyNGVhNy9kbWVz
Zy1xdWFudGFsLXZwLTE4OjIwMTQwODI3MjM1MzU4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEy
LTA4MjgwNjIyOjMuMTYuMC1yYzUtMDAyMjUtZ2U2NWUyMWE6Ngova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2U2NWUyMWE1NDJjYWI4MWQ3OTRkYjRlNWZlOTE5
YzRlMWQ2MjRlYTcvZG1lc2ctcXVhbnRhbC12cC0xOToyMDE0MDgyNzIzNTQwMDp4ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjozLjE2LjAtcmM1LTAwMjI1LWdlNjVlMjFhOjYK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9lNjVlMjFhNTQyY2Fi
ODFkNzk0ZGI0ZTVmZTkxOWM0ZTFkNjI0ZWE3L2RtZXNnLXF1YW50YWwtdnAtMToyMDE0MDgy
NzIzNTQwMDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjozLjE2LjAtcmM1LTAw
MjI1LWdlNjVlMjFhOjYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYy
Mi9lNjVlMjFhNTQyY2FiODFkNzk0ZGI0ZTVmZTkxOWM0ZTFkNjI0ZWE3L2RtZXNnLXF1YW50
YWwtdnAtMjA6MjAxNDA4MjcyMzU0MDI6eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2
MjI6My4xNi4wLXJjNS0wMDIyNS1nZTY1ZTIxYTo2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTItMDgyODA2MjIvZTY1ZTIxYTU0MmNhYjgxZDc5NGRiNGU1ZmU5MTljNGUxZDYy
NGVhNy9kbWVzZy1xdWFudGFsLXZwLTIzOjIwMTQwODI3MjM1MzU4Ong4Nl82NC1yYW5kY29u
ZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTYuMC1yYzUtMDAyMjUtZ2U2NWUyMWE6Ngova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2U2NWUyMWE1NDJjYWI4MWQ3OTRk
YjRlNWZlOTE5YzRlMWQ2MjRlYTcvZG1lc2ctcXVhbnRhbC12cC0yNDoyMDE0MDgyNzIzNTQw
MDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjozLjE2LjAtcmM1LTAwMjI1LWdl
NjVlMjFhOjYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9lNjVl
MjFhNTQyY2FiODFkNzk0ZGI0ZTVmZTkxOWM0ZTFkNjI0ZWE3L2RtZXNnLXF1YW50YWwtdnAt
MjY6MjAxNDA4MjcyMzUzNTk6eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjI6My4x
Ni4wLXJjNS0wMDIyNS1nZTY1ZTIxYTo2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTItMDgyODA2MjIvZTY1ZTIxYTU0MmNhYjgxZDc5NGRiNGU1ZmU5MTljNGUxZDYyNGVhNy9k
bWVzZy1xdWFudGFsLXZwLTI4OjIwMTQwODI3MjM1MzU5Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEyLTA4MjgwNjIyOjMuMTYuMC1yYzUtMDAyMjUtZ2U2NWUyMWE6Ngova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2U2NWUyMWE1NDJjYWI4MWQ3OTRkYjRlNWZl
OTE5YzRlMWQ2MjRlYTcvZG1lc2ctcXVhbnRhbC12cC0yOToyMDE0MDgyNzIzNTM1ODp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjozLjE2LjAtcmM1LTAwMjI1LWdlNjVlMjFh
OjYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9lNjVlMjFhNTQy
Y2FiODFkNzk0ZGI0ZTVmZTkxOWM0ZTFkNjI0ZWE3L2RtZXNnLXF1YW50YWwtdnAtMzA6MjAx
NDA4MjcyMzU0MDA6eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjI6My4xNi4wLXJj
NS0wMDIyNS1nZTY1ZTIxYTo2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgy
ODA2MjIvZTY1ZTIxYTU0MmNhYjgxZDc5NGRiNGU1ZmU5MTljNGUxZDYyNGVhNy9kbWVzZy1x
dWFudGFsLXZwLTMyOjIwMTQwODI3MjM1NDAyOng4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4
MjgwNjIyOjMuMTYuMC1yYzUtMDAyMjUtZ2U2NWUyMWE6Ngova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGEyLTA4MjgwNjIyL2U2NWUyMWE1NDJjYWI4MWQ3OTRkYjRlNWZlOTE5YzRl
MWQ2MjRlYTcvZG1lc2ctcXVhbnRhbC12cC0zOjIwMTQwODI3MjM1MzU5Ong4Nl82NC1yYW5k
Y29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTYuMC1yYzUtMDAyMjUtZ2U2NWUyMWE6Ngova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2U2NWUyMWE1NDJjYWI4MWQ3
OTRkYjRlNWZlOTE5YzRlMWQ2MjRlYTcvZG1lc2ctcXVhbnRhbC12cC00OjIwMTQwODI3MjM1
NDAwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTYuMC1yYzUtMDAyMjUt
Z2U2NWUyMWE6Ngova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2U2
NWUyMWE1NDJjYWI4MWQ3OTRkYjRlNWZlOTE5YzRlMWQ2MjRlYTcvZG1lc2ctcXVhbnRhbC12
cC02OjIwMTQwODI3MjM1NDAwOng4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMu
MTYuMC1yYzUtMDAyMjUtZ2U2NWUyMWE6Ngova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEyLTA4MjgwNjIyL2U2NWUyMWE1NDJjYWI4MWQ3OTRkYjRlNWZlOTE5YzRlMWQ2MjRlYTcv
ZG1lc2ctcXVhbnRhbC12cC03OjIwMTQwODI3MjM1MzU5Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEyLTA4MjgwNjIyOjMuMTYuMC1yYzUtMDAyMjUtZ2U2NWUyMWE6Ngova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2U2NWUyMWE1NDJjYWI4MWQ3OTRkYjRlNWZl
OTE5YzRlMWQ2MjRlYTcvZG1lc2ctcXVhbnRhbC12cC04OjIwMTQwODI3MjM1NDAxOng4Nl82
NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTYuMC1yYzUtMDAyMjUtZ2U2NWUyMWE6
NgowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA4LTI3
IDIzOjU0OjE3IFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtNS9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCltmYjZmYTNlNjI1ZTFlNDUzYWVh
OWVlYjk3ZDU4YmVlMzBlMWMwNzgxXSB4aGNpOiB2MS4wIHNjYXR0ZXJsaXN0IGVucXVldWUg
c3VwcG9ydCAodGQtZnJhZ21lbnQgcmV3b3JrKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNS9vYmot
YmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMi0wODI4MDYyMi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA4Mjcy
MjpmYjZmYTNlNjI1ZTFlNDUzYWVhOWVlYjk3ZDU4YmVlMzBlMWMwNzgxOmJpc2VjdC1saW51
eC01CgoyMDE0LTA4LTI3IDIzOjU0OjE4IGZiNmZhM2U2MjVlMWU0NTNhZWE5ZWViOTdkNThi
ZWUzMGUxYzA3ODEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjItZmI2ZmEz
ZTYyNWUxZTQ1M2FlYTllZWI5N2Q1OGJlZTMwZTFjMDc4MQpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvZmI2ZmEzZTYyNWUx
ZTQ1M2FlYTllZWI5N2Q1OGJlZTMwZTFjMDc4MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgy
ODA2MjItZmI2ZmEzZTYyNWUxZTQ1M2FlYTllZWI5N2Q1OGJlZTMwZTFjMDc4MQp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvamFrZXRvd24t
Y29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjItZmI2ZmEzZTYyNWUx
ZTQ1M2FlYTllZWI5N2Q1OGJlZTMwZTFjMDc4MQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTItMDgyODA2MjIvZmI2ZmEzZTYyNWUxZTQ1M2FlYTllZWI5N2Q1OGJl
ZTMwZTFjMDc4MS92bWxpbnV6LTMuMTYuMC1yYzUtMDAyMjQtZ2ZiNmZhM2UKCjIwMTQtMDgt
MjcgMjM6NTc6MTggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkyMCBTVUNDRVNTCgplNjVlMjFh
NTQyY2FiODFkNzk0ZGI0ZTVmZTkxOWM0ZTFkNjI0ZWE3IGlzIHRoZSBmaXJzdCBiYWQgY29t
bWl0CmNvbW1pdCBlNjVlMjFhNTQyY2FiODFkNzk0ZGI0ZTVmZTkxOWM0ZTFkNjI0ZWE3CkF1
dGhvcjogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+CkRhdGU6ICAg
VHVlIEp1bCAyMiAwMDowODo1MSAyMDE0IC0wNzAwCgogICAgeGhjaTogdW5pdCB0ZXN0IHJp
bmcgZW5xdWV1ZS9kZXF1ZXVlIHJvdXRpbmVzCiAgICAKICAgIEdpdmVuIHRoZSBjb21wbGV4
aXR5IG9mIHNhdGlzZnlpbmcgeGhjaSAxLjArIGhvc3QgdHJiIGJvdW5kYXJ5CiAgICBjb25z
dHJhaW50cywgcHJvdmlkZSBhIHRlc3QgY2FzZSB0aGF0IGV4ZXJjaXNlcyBpbnNlcnRpbmcg
bWlkLXNlZ21lbnQKICAgIGxpbmtzIGludG8gYSByaW5nLgogICAgCiAgICBUaGUgbGlua2Vy
IC0td3JhcD0gb3B0aW9uIGlzIHVzZWQgdG8gbm90IHBvbGx1dGUgdGhlIGdsb2JhbCBpZGVu
dGlmaWVyCiAgICBzcGFjZSBhbmQgdG8gbWFrZSBpdCBjbGVhciB3aGljaCBzdGFuZGFyZCB4
aGNpIGRyaXZlciByb3V0aW5lcyBhcmUgYmVpbmcKICAgIG1vY2tlZC11cC4gIFRoZSAtLXdy
YXA9IG9wdGlvbiBkb2VzIG5vdCBjb21lIGludG8gcGxheSB3aGVuIGJvdGgKICAgIHhoY2kt
aGNkIGFuZCB4aGNpLXRlc3QgYXJlIGJ1aWx0LWluIHRvIHRoZSBrZXJuZWwsIHNvIG5hbWVz
cGFjZQogICAgY29sbGlzaW9ucyBhcmUgcHJldmVudGVkIGJ5IGV4Y2x1ZGluZyB4aGNpLXRl
c3QgZnJvbSB0aGUgYnVpbGQgd2hlbgogICAgeGhjaS1oY2QgaXMgYnVpbHQtaW4uCiAgICAK
ICAgIEl0J3MgdW5mb3J0dW5hdGUgdGhhdCB0aGlzIGlzIGFuIGluLWtlcm5lbCB0ZXN0IHJh
dGhlciB0aGFuIHVzZXJzcGFjZQogICAgYW5kIHRoYXQgdGhlIGluZnJhc3RydWN0dXJlIGlz
IGN1c3RvbSByYXRoZXIgdGhhbiBnZW5lcmljLiAgVGhhdCBzYWlkLAogICAgaXQgc2VydmVz
IGl0cyBwdXJwb3NlIG9mIGV4ZXJjaXNpbmcgdGhlIGNvcm5lciBjYXNlcyBvZiB0aGUgc2Nh
dHRlcmxpc3QKICAgIHBhcnNpbmcgaW1wbGVtZW50YXRpb24gaW4geGhjaS4KICAgIAogICAg
Q2M6IFJ1c3R5IFJ1c3NlbGwgPHJ1c3R5QHJ1c3Rjb3JwLmNvbS5hdT4KICAgIFNpZ25lZC1v
ZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPgoKOjA0MDAw
MCAwNDAwMDAgNTRmNTAzNzdjYTliNWNlZTBjYjZhZjgwMjBjMzhkNDNlODUyMjhhYSA4Y2Q0
OTU4OTRkMjM3ODBkNGRjODEyZDIwYmViNThhNmJiYzk0YmQ1IE0JZHJpdmVycwpiaXNlY3Qg
cnVuIHN1Y2Nlc3MKSEVBRCBpcyBub3cgYXQgZmI2ZmEzZS4uLiB4aGNpOiB2MS4wIHNjYXR0
ZXJsaXN0IGVucXVldWUgc3VwcG9ydCAodGQtZnJhZ21lbnQgcmV3b3JrKQpscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2
MjIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwODI3MjI6ZmI2ZmEzZTYyNWUxZTQ1
M2FlYTllZWI5N2Q1OGJlZTMwZTFjMDc4MTpiaXNlY3QtbGludXgtNQoKMjAxNC0wOC0yNyAy
Mzo1ODoxOSBmYjZmYTNlNjI1ZTFlNDUzYWVhOWVlYjk3ZDU4YmVlMzBlMWMwNzgxIHJldXNl
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvZmI2ZmEzZTYyNWUx
ZTQ1M2FlYTllZWI5N2Q1OGJlZTMwZTFjMDc4MS92bWxpbnV6LTMuMTYuMC1yYzUtMDAyMjQt
Z2ZiNmZhM2UKCjIwMTQtMDgtMjcgMjM6NTg6MTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4u
CTYwIFNVQ0NFU1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGZiNmZhM2UuLi4geGhj
aTogdjEuMCBzY2F0dGVybGlzdCBlbnF1ZXVlIHN1cHBvcnQgKHRkLWZyYWdtZW50IHJld29y
aykKSEVBRCBpcyBub3cgYXQgNjZlOGRmYS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZl
bC1ob3VybHktMjAxNDA4MjcyMicKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDgyNzIyOjY2ZThkZmE0ZTBkOTYwMGRlZGMwOGFkY2FhYzgzYzM3OGI2NTM1
MWI6YmlzZWN0LWxpbnV4LTUKIFRFU1QgRkFJTFVSRQpbICAgMTMuNDA2MDA5XSBvaGNpX2hj
ZDogVVNCIDEuMSAnT3BlbicgSG9zdCBDb250cm9sbGVyIChPSENJKSBEcml2ZXIKWyAgIDEz
LjQwNjYyM10gb2hjaS1wY2k6IE9IQ0kgUENJIHBsYXRmb3JtIGRyaXZlcgpbICAgMTMuNDA3
MDUzXSBvaGNpLXBsYXRmb3JtOiBPSENJIGdlbmVyaWMgcGxhdGZvcm0gZHJpdmVyClsgICAx
My40MDc3MTRdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRl
cmVmZXJlbmNlIGF0ICAgICAgICAgICAobnVsbCkKWyAgIDEzLjQwODQzMl0gSVA6IFs8ZmZm
ZmZmZmY4MTk5MDRiMz5dIHNldHVwX3Rlc3Rfc2tpcDY0KzB4MTgzLzB4MjcwClsgICAxMy40
MDkwMDJdIFBHRCAwIApbICAgMTMuNDA5MTk3XSBPb3BzOiAwMDAwIFsjMV0gU01QIERFQlVH
X1BBR0VBTExPQwpbICAgMTMuNDA5NjY4XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIv
MCBOb3QgdGFpbnRlZCAzLjE3LjAtcmMyLXdsLWF0aC0wMTkxMi1nNjZlOGRmYSAjMjEKWyAg
IDEzLjQxMDQwNl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEv
MDEvMjAxMQpbICAgMTMuNDEwOTQ3XSB0YXNrOiBmZmZmODgwMDEyMTI4MDAwIHRpOiBmZmZm
ODgwMDEyMTMwMDAwIHRhc2sudGk6IGZmZmY4ODAwMTIxMzAwMDAKWyAgIDEzLjQxMDk0N10g
UklQOiAwMDEwOls8ZmZmZmZmZmY4MTk5MDRiMz5dICBbPGZmZmZmZmZmODE5OTA0YjM+XSBz
ZXR1cF90ZXN0X3NraXA2NCsweDE4My8weDI3MApbICAgMTMuNDEwOTQ3XSBSU1A6IDAwMDA6
ZmZmZjg4MDAxMjEzM2QwOCAgRUZMQUdTOiAwMDAxMDIwMgpbICAgMTMuNDEwOTQ3XSBSQVg6
IGZmZmY4ODAwMTEyMDcwMDAgUkJYOiAwMDAwMDAwMDAwMDAwMDAwIFJDWDogMDAwMDAwMDc4
MDAwMDAwZgpbICAgMTMuNDEwOTQ3XSBSRFg6IDAwMDAwMDAwMDAwMDAwNDAgUlNJOiAwMDAw
MDAwMDAwMDAwZjAxIFJESTogMDAwMDAwMDAwMDAwMDAwMApbICAgMTMuNDEwOTQ3XSBSQlA6
IGZmZmY4ODAwMTIxMzNkNDggUjA4OiAwMDAwMDAwMDAwMDAwZmUwIFIwOTogMDAwMDAwMDAw
MDAwMDAwMApbICAgMTMuNDEwOTQ3XSBSMTA6IDAwMDAwMDAwMDAwZjAwMDAgUjExOiAwMDAw
MDAwMDAwMDAwMDAwIFIxMjogMDAwMDAwMDA4MDAwMDAwMApbICAgMTMuNDEwOTQ3XSBSMTM6
IDAwMDAwMDAwMDAwMDAwMDAgUjE0OiAwMDAwMDAwMDAwMDBmZmUwIFIxNTogMDAwMDAwMDAw
MDAwZmZlMApbICAgMTMuNDEwOTQ3XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6
ZmZmZjg4MDAxMjQwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAxMy40
MTA5NDddIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAw
M2IKWyAgIDEzLjQxMDk0N10gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAw
MjVjNTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2YjAKWyAgIDEzLjQxMDk0N10gU3RhY2s6Clsg
ICAxMy40MTA5NDddICBmZmZmODgwMDEyMTMzZGRjIGZmZmY4ODAwMTIxMzNkZTggZmZmZjg4
MDAxMjEzM2UxMCAwMDAwMDAwMDAwMDAwMDAwClsgICAxMy40MTA5NDddICAwMDAwMDAwMDAw
MDAwMDAwIGZmZmY4ODAwMGFkNzE0MDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAw
MDAwClsgICAxMy40MTA5NDddICBmZmZmODgwMDEyMTMzZTQ4IGZmZmZmZmZmODFkYWUwMzkg
MDAwMDAwMDAwMDAwMDAwMCAwMDAwMzAzYTM1MzQzMjAwClsgICAxMy40MTA5NDddIENhbGwg
VHJhY2U6ClsgICAxMy40MTA5NDddICBbPGZmZmZmZmZmODFkYWUwMzk+XSBkb190ZXN0LmNv
bnN0cHJvcC43MCsweDQ3LzB4ODk0ClsgICAxMy40MTA5NDddICBbPGZmZmZmZmZmODE5OTAz
MzA+XSA/IHNldHVwX3Rlc3RfMzJfMjQ4XzgrMHgzNDAvMHgzNDAKWyAgIDEzLjQxMDk0N10g
IFs8ZmZmZmZmZmY4MTg0NGQxMD5dID8gZGV2aWNlX2NyZWF0ZV9ncm91cHNfdmFyZ3MrMHhl
MC8weDFhMApbICAgMTMuNDEwOTQ3XSAgWzxmZmZmZmZmZjgyZGIyZDk5Pl0gPyBvaGNpX3Bs
YXRmb3JtX2luaXQrMHg2MC8weDYwClsgICAxMy40MTA5NDddICBbPGZmZmZmZmZmODJkYjJm
OGE+XSB4aGNpX3Rlc3RfaW5pdCsweDFmMS8weDJhNQpbICAgMTMuNDEwOTQ3XSAgWzxmZmZm
ZmZmZjgxOTkwMzMwPl0gPyBzZXR1cF90ZXN0XzMyXzI0OF84KzB4MzQwLzB4MzQwClsgICAx
My40MTA5NDddICBbPGZmZmZmZmZmODE5OGZmZjA+XSA/IHNldHVwX3Rlc3Rfd3JhcDY0KzB4
MzIwLzB4MzIwClsgICAxMy40MTA5NDddICBbPGZmZmZmZmZmODE5OGZjZDA+XSA/IHNldHVw
X3Rlc3RfZG9udF90cmltKzB4MmYwLzB4MmYwClsgICAxMy40MTA5NDddICBbPGZmZmZmZmZm
ODE5OGY5ZTA+XSA/IHhoY2lfcmluZ19mcmVlKzB4MWQwLzB4MWQwClsgICAxMy40MTA5NDdd
ICBbPGZmZmZmZmZmODJkYjJkOTk+XSA/IG9oY2lfcGxhdGZvcm1faW5pdCsweDYwLzB4NjAK
WyAgIDEzLjQxMDk0N10gIFs8ZmZmZmZmZmY4MmQ1OTZiMj5dIGRvX29uZV9pbml0Y2FsbCsw
eDE0My8weDI0ZApbICAgMTMuNDEwOTQ3XSAgWzxmZmZmZmZmZjgxMGRmZmJiPl0gPyBwYXJz
ZV9hcmdzKzB4MmZiLzB4NTMwClsgICAxMy40MTA5NDddICBbPGZmZmZmZmZmODJkNTk5OTg+
XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDFkYy8weDJhYQpbICAgMTMuNDEwOTQ3XSAgWzxm
ZmZmZmZmZjgyZDU4OWQ1Pl0gPyBkb19lYXJseV9wYXJhbSsweGMzLzB4YzMKWyAgIDEzLjQx
MDk0N10gIFs8ZmZmZmZmZmY4MWQ4ODk1MD5dID8gcmVzdF9pbml0KzB4ZDAvMHhkMApbICAg
MTMuNDEwOTQ3XSAgWzxmZmZmZmZmZjgxZDg4OTVlPl0ga2VybmVsX2luaXQrMHhlLzB4MTYw
ClsgICAxMy40MTA5NDddICBbPGZmZmZmZmZmODFkYzVmM2M+XSByZXRfZnJvbV9mb3JrKzB4
N2MvMHhiMApbICAgMTMuNDEwOTQ3XSAgWzxmZmZmZmZmZjgxZDg4OTUwPl0gPyByZXN0X2lu
aXQrMHhkMC8weGQwClsgICAxMy40MTA5NDddIENvZGU6IDQ4IDg1IGZmIDQwIDBmIDk0IGM2
IDQ0IDBmIGI2IGNlIDQ5IDgzIGMxIDAyIDRhIDgzIDA0IGNkIGEwIGY0IGJhIDgyIDAxIDQ1
IDMxIGM5IDQwIDg0IGY2IDc1IDBiIDQ1IDBmIGI2IGNhIDQ5IGMxIGUxIDA0IDQ5IDAxIGY5
IDw0OT4gOGIgMzkgNDggOGIgMzAgNDggYzEgZTEgMDYgNGMgODkgNzggMTAgNDQgODkgNDAg
MDggMDEgZDMgODkgClsgICAxMy40MTA5NDddIFJJUCAgWzxmZmZmZmZmZjgxOTkwNGIzPl0g
c2V0dXBfdGVzdF9za2lwNjQrMHgxODMvMHgyNzAKWyAgIDEzLjQxMDk0N10gIFJTUCA8ZmZm
Zjg4MDAxMjEzM2QwOD4KWyAgIDEzLjQxMDk0N10gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwClsg
ICAxMy40MTA5NDddIC0tLVsgZW5kIHRyYWNlIDdkYTBiYmE5YzBhNjY1OTQgXS0tLQpbICAg
MTMuNDEwOTQ3XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9u
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvNjZlOGRmYTRlMGQ5
NjAwZGVkYzA4YWRjYWFjODNjMzc4YjY1MzUxYi9kbWVzZy15b2N0by12cC0yOjIwMTQwODI3
MjIyNTU4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wt
YXRoLTAxOTEyLWc2NmU4ZGZhOjIxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTIt
MDgyODA2MjIvNjZlOGRmYTRlMGQ5NjAwZGVkYzA4YWRjYWFjODNjMzc4YjY1MzUxYi9kbWVz
Zy15b2N0by12cC01NToyMDE0MDgyNzIyMjkzODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0w
ODI4MDYyMjozLjE3LjAtcmMyLXdsLWF0aC0wMTkxMi1nNjZlOGRmYToyMQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzY2ZThkZmE0ZTBkOTYwMGRlZGMwOGFk
Y2FhYzgzYzM3OGI2NTM1MWIvZG1lc2cteW9jdG8tdnAtMToyMDE0MDgyNzIyMjkzODp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjozLjE3LjAtcmMyLXdsLWF0aC0wMTkxMi1n
NjZlOGRmYToyMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzY2
ZThkZmE0ZTBkOTYwMGRlZGMwOGFkY2FhYzgzYzM3OGI2NTM1MWIvZG1lc2ctcXVhbnRhbC12
cC0xNToyMDE0MDgyNzIyMjk1Mzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMjoz
LjE3LjAtcmMyLXdsLWF0aC0wMTkxMi1nNjZlOGRmYToyMQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGEyLTA4MjgwNjIyLzY2ZThkZmE0ZTBkOTYwMGRlZGMwOGFkY2FhYzgzYzM3
OGI2NTM1MWIvZG1lc2ctcXVhbnRhbC12cC01OjIwMTQwODI3MjIyOTUzOng4Nl82NC1yYW5k
Y29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzItd2wtYXRoLTAxOTEyLWc2NmU4ZGZh
OjIxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjIvNjZlOGRmYTRl
MGQ5NjAwZGVkYzA4YWRjYWFjODNjMzc4YjY1MzUxYi9kbWVzZy15b2N0by12cC0zOjIwMTQw
ODI3MjIyOTM4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyOjMuMTcuMC1yYzIt
d2wtYXRoLTAxOTEyLWc2NmU4ZGZhOjIxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTItMDgyODA2MjIvNjZlOGRmYTRlMGQ5NjAwZGVkYzA4YWRjYWFjODNjMzc4YjY1MzUxYi9k
bWVzZy15b2N0by12cC00MjoyMDE0MDgyNzIyMjkzODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hh
Mi0wODI4MDYyMjozLjE3LjAtcmMyLXdsLWF0aC0wMTkxMi1nNjZlOGRmYToyMQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzY2ZThkZmE0ZTBkOTYwMGRlZGMw
OGFkY2FhYzgzYzM3OGI2NTM1MWIvZG1lc2cteW9jdG8tdnAtMTI6MjAxNDA4MjcyMjI5Mzg6
eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjI6My4xNy4wLXJjMi13bC1hdGgtMDE5
MTItZzY2ZThkZmE6MjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYy
Mi82NmU4ZGZhNGUwZDk2MDBkZWRjMDhhZGNhYWM4M2MzNzhiNjUzNTFiL2RtZXNnLXlvY3Rv
LXZwLTIwOjIwMTQwODI3MjIyOTM4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIy
OjMuMTcuMC1yYzItd2wtYXRoLTAxOTEyLWc2NmU4ZGZhOjIxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTItMDgyODA2MjIvNjZlOGRmYTRlMGQ5NjAwZGVkYzA4YWRjYWFjODNj
Mzc4YjY1MzUxYi9kbWVzZy15b2N0by12cC0xNToyMDE0MDgyNzIyMjkzODp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMi0wODI4MDYyMjozLjE3LjAtcmMyLXdsLWF0aC0wMTkxMi1nNjZlOGRm
YToyMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzY2ZThkZmE0
ZTBkOTYwMGRlZGMwOGFkY2FhYzgzYzM3OGI2NTM1MWIvZG1lc2cteW9jdG8tdnAtNjM6MjAx
NDA4MjcyMjI5Mzg6eDg2XzY0LXJhbmRjb25maWctaHN4YTItMDgyODA2MjI6My4xNy4wLXJj
Mi13bC1hdGgtMDE5MTItZzY2ZThkZmE6MjEKMDoxMToxMSBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwoKSEVBRCBpcyBub3cgYXQgNjZlOGRmYSAwZGF5IGhlYWQgZ3VhcmQgZm9yICdk
ZXZlbC1ob3VybHktMjAxNDA4MjcyMicKCj09PT09PT09PSBsaW51cy9tYXN0ZXIgPT09PT09
PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDY2ZThkZmEuLi4gMGRheSBoZWFkIGd1
YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQwODI3MjInCkhFQUQgaXMgbm93IGF0IDY4ZTM3
MDIuLi4gTWVyZ2UgYnJhbmNoICdmb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zMzkwL2xpbnV4CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9saW51
czptYXN0ZXI6NjhlMzcwMjg5YzI5ZTNiZWFjOTlkNTljNmQ4NDBkNDcwYWY5ZGZjZjpiaXNl
Y3QtbGludXgtNQoKMjAxNC0wOC0yOCAwMDowMDoyNSA2OGUzNzAyODljMjllM2JlYWM5OWQ1
OWM2ZDg0MGQ0NzBhZjlkZmNmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIy
LTY4ZTM3MDI4OWMyOWUzYmVhYzk5ZDU5YzZkODQwZDQ3MGFmOWRmY2YKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzY4ZTM3
MDI4OWMyOWUzYmVhYzk5ZDU5YzZkODQwZDQ3MGFmOWRmY2YKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEyLTA4MjgwNjIyLTY4ZTM3MDI4OWMyOWUzYmVhYzk5ZDU5YzZkODQwZDQ3MGFmOWRmY2YK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2ph
a2V0b3duLWNvbnN1bWVyL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLTY4ZTM3
MDI4OWMyOWUzYmVhYzk5ZDU5YzZkODQwZDQ3MGFmOWRmY2YKa2VybmVsOiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyLzY4ZTM3MDI4OWMyOWUzYmVhYzk5ZDU5
YzZkODQwZDQ3MGFmOWRmY2Yvdm1saW51ei0zLjE3LjAtcmMyLTAwMDA5LWc2OGUzNzAyCgoy
MDE0LTA4LTI4IDAwOjE4OjI1IGRldGVjdGluZyBib290IHN0YXRlIAkyCTMwCTYwIFNVQ0NF
U1MKCgo9PT09PT09PT0gbmV4dC9tYXN0ZXIgPT09PT09PT09CkZyb20gZ2l0Oi8vZ2l0bWly
cm9yL25leHQKICsgZmFkMmUzYi4uLmNmMDYzNmMgYWtwbSAgICAgICAtPiBuZXh0L2FrcG0g
IChmb3JjZWQgdXBkYXRlKQogKyBlMTFmZWVlLi4uNmRjMDg1YSBha3BtLWJhc2UgIC0+IG5l
eHQvYWtwbS1iYXNlICAoZm9yY2VkIHVwZGF0ZSkKICsgMWM5ZTQ1Ni4uLmQwNTQ0NmEgbWFz
dGVyICAgICAtPiBuZXh0L21hc3RlciAgKGZvcmNlZCB1cGRhdGUpCiAgIDUyYWRkY2YuLjY4
ZTM3MDIgIHN0YWJsZSAgICAgLT4gbmV4dC9zdGFibGUKRnJvbSBnaXQ6Ly9naXRtaXJyb3Iv
bmV4dAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwODI3IC0+IG5leHQtMjAxNDA4
MjcKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNjhlMzcwMi4uLiBNZXJnZSBicmFuY2gg
J2Zvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3MzOTAvbGludXgKSEVBRCBpcyBub3cgYXQgZDA1NDQ2YS4uLiBBZGQgbGludXgt
bmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA4MjcKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEyLTA4MjgwNjIyL25leHQ6bWFz
dGVyOmQwNTQ0NmFlMjEyODA2NGE0YmI4Zjc0Yzg0ZjY5MDFmZmI1Yzk0YmM6YmlzZWN0LWxp
bnV4LTUKCjIwMTQtMDgtMjggMDA6MjA6MDcgZDA1NDQ2YWUyMTI4MDY0YTRiYjhmNzRjODRm
NjkwMWZmYjVjOTRiYyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi1kMDU0
NDZhZTIxMjgwNjRhNGJiOGY3NGM4NGY2OTAxZmZiNWM5NGJjCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9kMDU0NDZhZTIx
MjgwNjRhNGJiOGY3NGM4NGY2OTAxZmZiNWM5NGJjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0w
ODI4MDYyMi1kMDU0NDZhZTIxMjgwNjRhNGJiOGY3NGM4NGY2OTAxZmZiNWM5NGJjCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93
bi1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi1kMDU0NDZhZTIx
MjgwNjRhNGJiOGY3NGM4NGY2OTAxZmZiNWM5NGJjCmtlcm5lbDogL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMi0wODI4MDYyMi9kMDU0NDZhZTIxMjgwNjRhNGJiOGY3NGM4NGY2
OTAxZmZiNWM5NGJjL3ZtbGludXotMy4xNy4wLXJjMi1uZXh0LTIwMTQwODI3CgoyMDE0LTA4
LTI4IDAwOjMxOjA3IGRldGVjdGluZyBib290IHN0YXRlIC4JMQkzOQk2MCBTVUNDRVNTCgo=

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-rc5-00225-ge65e21a"

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
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_RCU_USER_QS is not set
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_SGETMASK_SYSCALL is not set
CONFIG_SYSFS_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
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
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
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

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
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
# CONFIG_X86_VSMP is not set
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
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
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSWAP is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
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
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
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
CONFIG_ACPI_NUMA=y
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
CONFIG_INTEL_IDLE=y

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
CONFIG_X86_SYSFB=y

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
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
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
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
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
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_I4=y
CONFIG_MTD_CFI_I8=y
# CONFIG_MTD_OTP is not set
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
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
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
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_MTD_UBI_BLOCK=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
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
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set

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
CONFIG_INPUT_EVBUG=y

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
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_HANWANG=y
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
# CONFIG_TOUCHSCREEN_AD7877 is not set
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9034=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_PCAP is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
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
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
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
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_SC16IS7XX is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_TTY_PRINTK=y
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
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
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
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
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
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
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_XCOMM=y
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
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_BATTERY_TWL4030_MADC is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_BATTERY_RX51=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_LP8788=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_MAX14577 is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_CHARGER_TPS65090=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_WM8350=y

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
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=y
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
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
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_EZX_PCAP=y
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TWL4030_AUDIO is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA903X=y
# CONFIG_REGULATOR_DA9063 is not set
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_LTC3589=y
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
CONFIG_IR_LIRC_CODEC=y
CONFIG_IR_NEC_DECODER=y
# CONFIG_IR_RC5_DECODER is not set
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_SHARP_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=y
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
CONFIG_IR_MCEUSB=y
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
CONFIG_IR_STREAMZAP=y
# CONFIG_IR_WINBOND_CIR is not set
CONFIG_IR_IGUANA=y
# CONFIG_IR_TTUSBIR is not set
CONFIG_IR_IMG=y
CONFIG_IR_IMG_RAW=y
CONFIG_IR_IMG_HW=y
CONFIG_IR_IMG_NEC=y
# CONFIG_IR_IMG_JVC is not set
CONFIG_IR_IMG_SONY=y
# CONFIG_IR_IMG_SHARP is not set
CONFIG_IR_IMG_SANYO=y
CONFIG_RC_LOOPBACK=y
CONFIG_IR_GPIO_CIR=y
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog TV USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
CONFIG_VIDEO_USBVISION=y
CONFIG_VIDEO_STK1160_COMMON=y
CONFIG_VIDEO_STK1160=y

#
# Analog/digital TV USB devices
#
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_CX231XX is not set
# CONFIG_VIDEO_TM6000 is not set

#
# Digital TV USB devices
#
CONFIG_DVB_USB=y
# CONFIG_DVB_USB_DEBUG is not set
# CONFIG_DVB_USB_A800 is not set
CONFIG_DVB_USB_DIBUSB_MB=y
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
# CONFIG_DVB_USB_DIBUSB_MC is not set
CONFIG_DVB_USB_DIB0700=y
CONFIG_DVB_USB_UMT_010=y
CONFIG_DVB_USB_CXUSB=y
# CONFIG_DVB_USB_M920X is not set
CONFIG_DVB_USB_DIGITV=y
# CONFIG_DVB_USB_VP7045 is not set
# CONFIG_DVB_USB_VP702X is not set
CONFIG_DVB_USB_GP8PSK=y
# CONFIG_DVB_USB_NOVA_T_USB2 is not set
# CONFIG_DVB_USB_TTUSB2 is not set
# CONFIG_DVB_USB_DTT200U is not set
CONFIG_DVB_USB_OPERA1=y
CONFIG_DVB_USB_AF9005=y
CONFIG_DVB_USB_AF9005_REMOTE=y
CONFIG_DVB_USB_PCTV452E=y
CONFIG_DVB_USB_DW2102=y
CONFIG_DVB_USB_CINERGY_T2=y
# CONFIG_DVB_USB_DTV5100 is not set
CONFIG_DVB_USB_FRIIO=y
# CONFIG_DVB_USB_AZ6027 is not set
CONFIG_DVB_USB_TECHNISAT_USB2=y
# CONFIG_DVB_USB_V2 is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
CONFIG_SMS_USB_DRV=y
CONFIG_DVB_B2C2_FLEXCOP_USB=y
CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG=y

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y
CONFIG_SMS_SIANO_MDTV=y
# CONFIG_SMS_SIANO_RC is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=y

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_CX22702=y
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_DIB8000=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6421=y
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_M88RS2000=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

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
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
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
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_PANDORA is not set
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_VGASTATE is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

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
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_HUION=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=y
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
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
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_OTG_FSM is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_XHCI_TEST=y
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_MAX3421_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=y
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_TEST_MODE=y

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

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
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
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_DWC3_HOST_USB3_LPM_ENABLE=y
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_HOST is not set

#
# Gadget mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=y
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QW is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_XSENS_MT=y
CONFIG_USB_SERIAL_WISHBONE=y
CONFIG_USB_SERIAL_ZTE=y
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
# CONFIG_USB_LINK_LAYER_TEST is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
# CONFIG_TAHVO_USB is not set
CONFIG_USB_ISP1301=y
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
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=y
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_REALTEK_USB=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_MAX8998=y
# CONFIG_RTC_DRV_MAX8997 is not set
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_TPS80031 is not set
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set
# CONFIG_RTC_DRV_S5M is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
# CONFIG_RTC_DRV_DS1343 is not set
CONFIG_RTC_DRV_DS1347=y
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y
CONFIG_RTC_DRV_MCP795=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9063 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y
CONFIG_RTC_DRV_AB3100=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_MOXART is not set
CONFIG_RTC_DRV_XGENE=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
# CONFIG_UIO is not set
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
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_TRANZPORT is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16203 is not set
# CONFIG_ADIS16204 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADIS16220 is not set
# CONFIG_ADIS16240 is not set
CONFIG_SCA3000=y

#
# Analog to digital converters
#
CONFIG_AD7291=y
# CONFIG_AD7192 is not set
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#
# CONFIG_AD5930 is not set
CONFIG_AD9832=y
CONFIG_AD9834=y
# CONFIG_AD9850 is not set
# CONFIG_AD9852 is not set
# CONFIG_AD9910 is not set
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
CONFIG_ADE7754=y
CONFIG_ADE7758=y
# CONFIG_ADE7759 is not set
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
CONFIG_ADE7854_SPI=y

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
# CONFIG_GS_FPGABOOT is not set
CONFIG_CRYPTO_SKEIN=y
CONFIG_CRYPTO_THREEFISH=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
# CONFIG_CHROMEOS_PSTORE is not set

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
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

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
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_MAX14577 is not set
CONFIG_EXTCON_MAX77693=y
# CONFIG_EXTCON_MAX8997 is not set
# CONFIG_EXTCON_PALMAS is not set
# CONFIG_MEMORY is not set
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
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
# CONFIG_KXSD9 is not set
CONFIG_MMA8452=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
CONFIG_AD7298=y
# CONFIG_AD7476 is not set
# CONFIG_AD7791 is not set
CONFIG_AD7793=y
CONFIG_AD7887=y
CONFIG_AD7923=y
CONFIG_AD799X=y
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=y
CONFIG_MCP320X=y
# CONFIG_MCP3422 is not set
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
# CONFIG_TI_AM335X_ADC is not set
CONFIG_TWL4030_MADC=y
CONFIG_TWL6030_GPADC=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5360 is not set
CONFIG_AD5380=y
# CONFIG_AD5421 is not set
CONFIG_AD5446=y
CONFIG_AD5449=y
CONFIG_AD5504=y
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
# CONFIG_AD5755 is not set
CONFIG_AD5764=y
# CONFIG_AD5791 is not set
CONFIG_AD7303=y
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
CONFIG_ADXRS450=y
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_SI7005=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
# CONFIG_INV_MPU6050_IIO is not set
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_APDS9300 is not set
# CONFIG_CM32181 is not set
CONFIG_CM36651=y
# CONFIG_GP2AP020A00F is not set
CONFIG_HID_SENSOR_ALS=y
CONFIG_HID_SENSOR_PROX=y
# CONFIG_SENSORS_LM3533 is not set
# CONFIG_LTR501 is not set
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
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
CONFIG_HID_SENSOR_INCLINOMETER_3D=y
# CONFIG_HID_SENSOR_DEVICE_ROTATION is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
# CONFIG_HID_SENSOR_PRESS is not set
CONFIG_MPL115=y
# CONFIG_MPL3115 is not set
# CONFIG_IIO_ST_PRESS is not set

#
# Lightning sensors
#
CONFIG_AS3935=y

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
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_SAMSUNG_USB2 is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
# CONFIG_MCB is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
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
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_JFFS2_CMODE_NONE=y
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
# CONFIG_UBIFS_FS_ZLIB is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
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
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
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
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
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
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0

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
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
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
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
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
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
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
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
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
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
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
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
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
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
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
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
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
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
# CONFIG_PUBLIC_KEY_ALGO_RSA is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_BINARY_PRINTF=y

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
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y

--ibTvN161/egqYuK8--
