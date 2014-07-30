Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaG3OFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:05:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:9557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbaG3OFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,764,1400050800"; 
   d="log'?scan'208";a="569460869"
Date: Wed, 30 Jul 2014 22:05:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [x86,kaslr] [ 0.000000] general protection fault: 0000 [#1] SMP
 DEBUG_PAGEALLOC
Message-ID: <20140730140507.GM16537@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7gLe/sNPhR777EPF"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7gLe/sNPhR777EPF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

commit d07c7f1ed61789e175fa975134855be32263be2c
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue Jul 15 18:34:20 2014 -0700
Commit:     Andy Lutomirski <luto@amacapital.net>
CommitDate: Wed Jul 16 10:01:27 2014 -0700

    x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available
    
    It's considerably better than any of the alternatives on KVM.
    
    Rather than reinventing all of the cpu feature query code, this fixes
    native_cpuid to work in PIC objects.
    
    I haven't combined it with boot/cpuflags.c's cpuid implementation:
    including asm/processor.h from boot/cpuflags.c results in a flood of
    unrelated errors, and fixing it might be messy.
    
    Signed-off-by: Andy Lutomirski <luto@amacapital.net>

+------------------------------------------+------------+------------+
|                                          | c6f07a6360 | d07c7f1ed6 |
+------------------------------------------+------------+------------+
| boot_successes                           | 705        | 124        |
| boot_failures                            | 0          | 111        |
| general_protection_fault                 | 0          | 111        |
| RIP:setup_init_fpu_buf                   | 0          | 111        |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 111        |
| backtrace:setup_init_fpu_buf             | 0          | 111        |
| backtrace:xstate_enable_boot_cpu         | 0          | 111        |
| backtrace:xsave_init                     | 0          | 111        |
| backtrace:fpu_init                       | 0          | 111        |
| backtrace:cpu_init                       | 0          | 111        |
| backtrace:trap_init                      | 0          | 111        |
+------------------------------------------+------------+------------+

[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s0-07170233/linux-devel:devel-hourly-2014071701:d07c7f1ed61789e175fa975134855be32263be2c:bisect-linux0/.vmlinuz-d07c7f1ed61789e175fa975134855be32263be2c-20140717182236-14-kbuild branch=linux-devel/devel-hourly-2014071701 BOOT_IMAGE=/kernel/x86_64-randconfig-s0-07170233/d07c7f1ed61789e175fa975134855be32263be2c/vmlinuz-3.16.0-rc5-00004-gd07c7f1 drbd.minor_count=8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc5-00004-gd07c7f1 #1
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] task: ffffffff81c10490 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[    0.000000] RIP: 0010:[<ffffffff81e9757c>]  [<ffffffff81e9757c>] setup_init_fpu_buf+0x104/0x122
[    0.000000] RSP: 0000:ffffffff81c03e30  EFLAGS: 00010086
[    0.000000] RAX: 00000000ffffffff RBX: 0000000000000003 RCX: 0000000000000000
[    0.000000] RDX: 00000000ffffffff RSI: ffffffff81c03e34 RDI: ffff880013ff9000
[    0.000000] RBP: ffffffff81c03e68 R08: 0000000000000040 R09: ffffffff81c03e38
[    0.000000] R10: ffffffff81c03e3c R11: 0000000000000040 R12: ffffffff81c03e3c
[    0.000000] R13: ffffffff81c03e38 R14: ffffffff81c03e34 R15: ffffffff81c03e30
[    0.000000] FS:  0000000000000000(0000) GS:ffff880011000000(0000) knlGS:0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.000000] CR2: ffff8800127ff000 CR3: 0000000001c0b000 CR4: 00000000000406a0
[    0.000000] Stack:
[    0.000000]  0000000000000000 0000000000000000 ffffffff81c03e80 ffffffff81c03e84
[    0.000000]  ffffffff81c03e7c ffffffff81c03e78 0000000000000000 ffffffff81c03ea8
[    0.000000]  ffffffff81e97711 0000000000000007 0000034000000340 0000000000000008
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81e97711>] xstate_enable_boot_cpu+0x177/0x1f6
[    0.000000]  [<ffffffff8100c13e>] xsave_init+0x26/0x28
[    0.000000]  [<ffffffff8100b0c2>] fpu_init+0x96/0x9d
[    0.000000]  [<ffffffff810111e9>] cpu_init+0x2bc/0x2f3
[    0.000000]  [<ffffffff81e93b06>] trap_init+0x543/0x5eb
[    0.000000]  [<ffffffff81e91c2f>] start_kernel+0x1e2/0x3e6
[    0.000000]  [<ffffffff81e917c2>] ? set_init_arg+0x55/0x55
[    0.000000]  [<ffffffff81e91120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81e91471>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81e91561>] x86_64_start_kernel+0xee/0xfb
[    0.000000] Code: cc 48 8b 15 d7 a3 0d 00 48 63 c3 ff c3 89 0c 82 48 8b 15 c0 a3 0d 00 8b 4d c8 89 0c 82 eb bc 83 c8 ff 48 8b 3d 96 a3 0d 00 89 c2 <48> 0f ae 2f 48 8b 3d 89 a3 0d 00 89 c2 48 0f ae 27 58 5a 5b 41 
[    0.000000] RIP  [<ffffffff81e9757c>] setup_init_fpu_buf+0x104/0x122
[    0.000000]  RSP <ffffffff81c03e30>
[    0.000000] ---[ end trace 9ac76427702d2536 ]---
[    0.000000] Kernel panic - not syncing: Fatal exception

git bisect start 5e60c2af7a8bde5cfaee8ffd77cfc5b62db0a04e 1795cd9b3a91d4b5473c97f491d63892442212ab --
git bisect good bc1f2f93f68bccd988af7e6f73384860ac241b78  # 09:45    135+      0  Merge 'socfpga-nex/nios2-upstream' into devel-hourly-2014071701
git bisect  bad 0d7e1ca40ef16fce5297579121717fc793761b38  # 09:45      0-      8  Merge 'dynticks/nohz/sysidle' into devel-hourly-2014071701
git bisect good 33c13bf2487a42efa1ac9bcce5623ab74a375c93  # 09:48    135+      0  Merge 'ubifs/linux-next' into devel-hourly-2014071701
git bisect good 1032f73a32951d7f14ed7fdadedb0fef3c6d0f49  # 09:50    135+      0  Merge 'spi/for-next' into devel-hourly-2014071701
git bisect  bad 1f2859f0786338fe4c2a18ea518a5b2a2f1b5491  # 09:51      0-      2  Merge 'shawnguo/for-next' into devel-hourly-2014071701
git bisect good 73c47688a039158a6d395629d3ab32e606e13d1a  # 09:53    235+      0  Merge 'regulator/for-next' into devel-hourly-2014071701
git bisect  bad b973fdf5e6e6fe84b51f79919e5dc8574ae859da  # 09:53      0-      8  Merge 'luto/sync_rand_seed' into devel-hourly-2014071701
git bisect good 5778e65d5ca52bebbaa023e177d863e44f098e96  # 10:16    235+      0  random,x86: Add arch_get_slow_rng_u64
git bisect  bad d07c7f1ed61789e175fa975134855be32263be2c  # 10:23      0-     50  x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available
git bisect good c6f07a63601fbb36c09bf250b5538abb47b51e44  # 10:35    235+      0  random: Seed pools from arch_get_slow_rng_u64 at startup
# first bad commit: [d07c7f1ed61789e175fa975134855be32263be2c] x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available
git bisect good c6f07a63601fbb36c09bf250b5538abb47b51e44  # 10:47    705+      0  random: Seed pools from arch_get_slow_rng_u64 at startup
git bisect  bad 5e60c2af7a8bde5cfaee8ffd77cfc5b62db0a04e  # 10:47      0-      4  0day head guard for 'devel-hourly-2014071701'
git bisect good b6603fe574af289dbe9eb9fb4c540bca04f5a053  # 12:16    705+      0  Merge tag 'for-linus-20140716' of git://git.infradead.org/linux-mtd
git bisect good d4f4d1d45cd1b9aa60e61c2eab25a5d9a79a26f3  # 12:42    705+      0  Add linux-next specific files for 20140716


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
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

--7gLe/sNPhR777EPF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-kbuild-1:20140717102049:x86_64-randconfig-s0-07170233:3.16.0-rc5-00004-gd07c7f1:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.16.0-rc5-00004-gd07c7f1 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Thu Jul 17 18:19:53 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s0-07170233/linux-devel:=
devel-hourly-2014071701:d07c7f1ed61789e175fa975134855be32263be2c:bisect-lin=
ux0/.vmlinuz-d07c7f1ed61789e175fa975134855be32263be2c-20140717182236-14-kbu=
ild branch=3Dlinux-devel/devel-hourly-2014071701 BOOT_IMAGE=3D/kernel/x86_6=
4-randconfig-s0-07170233/d07c7f1ed61789e175fa975134855be32263be2c/vmlinuz-3=
=2E16.0-rc5-00004-gd07c7f1 drbd.minor_count=3D8
[    0.000000] CPU: vendor_id 'ineIGenuntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02c64000, 0x02c64fff] PGTABLE
[    0.000000] BRK [0x02c65000, 0x02c65fff] PGTABLE
[    0.000000] BRK [0x02c66000, 0x02c66fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x02c67000, 0x02c67fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x02c68000, 0x02c68fff] PGTABLE
[    0.000000] BRK [0x02c69000, 0x02c69fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 13ffe000)
[    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 1000000, base 00000000=
, limit 13ffe000)
[    0.000000] cma: CMA: reserved 16 MiB at 11400000
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
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
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ff9000-0x13ffdfff]
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
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI  =20
[    0.000000] Bus #1 is ISA  =20
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff880011000000 s1914944 r8=
192 d22464 u2097152
[    0.000000] pcpu-alloc: s1914944 r8192 d22464 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s0-07170233/linux=
-devel:devel-hourly-2014071701:d07c7f1ed61789e175fa975134855be32263be2c:bis=
ect-linux0/.vmlinuz-d07c7f1ed61789e175fa975134855be32263be2c-20140717182236=
-14-kbuild branch=3Dlinux-devel/devel-hourly-2014071701 BOOT_IMAGE=3D/kerne=
l/x86_64-randconfig-s0-07170233/d07c7f1ed61789e175fa975134855be32263be2c/vm=
linuz-3.16.0-rc5-00004-gd07c7f1 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc5-00004-gd0=
7c7f1 #1
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] task: ffffffff81c10490 ti: ffffffff81c00000 task.ti: fffffff=
f81c00000
[    0.000000] RIP: 0010:[<ffffffff81e9757c>]  [<ffffffff81e9757c>] setup_i=
nit_fpu_buf+0x104/0x122
[    0.000000] RSP: 0000:ffffffff81c03e30  EFLAGS: 00010086
[    0.000000] RAX: 00000000ffffffff RBX: 0000000000000003 RCX: 00000000000=
00000
[    0.000000] RDX: 00000000ffffffff RSI: ffffffff81c03e34 RDI: ffff880013f=
f9000
[    0.000000] RBP: ffffffff81c03e68 R08: 0000000000000040 R09: ffffffff81c=
03e38
[    0.000000] R10: ffffffff81c03e3c R11: 0000000000000040 R12: ffffffff81c=
03e3c
[    0.000000] R13: ffffffff81c03e38 R14: ffffffff81c03e34 R15: ffffffff81c=
03e30
[    0.000000] FS:  0000000000000000(0000) GS:ffff880011000000(0000) knlGS:=
0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.000000] CR2: ffff8800127ff000 CR3: 0000000001c0b000 CR4: 00000000000=
406a0
[    0.000000] Stack:
[    0.000000]  0000000000000000 0000000000000000 ffffffff81c03e80 ffffffff=
81c03e84
[    0.000000]  ffffffff81c03e7c ffffffff81c03e78 0000000000000000 ffffffff=
81c03ea8
[    0.000000]  ffffffff81e97711 0000000000000007 0000034000000340 00000000=
00000008
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81e97711>] xstate_enable_boot_cpu+0x177/0x1f6
[    0.000000]  [<ffffffff8100c13e>] xsave_init+0x26/0x28
[    0.000000]  [<ffffffff8100b0c2>] fpu_init+0x96/0x9d
[    0.000000]  [<ffffffff810111e9>] cpu_init+0x2bc/0x2f3
[    0.000000]  [<ffffffff81e93b06>] trap_init+0x543/0x5eb
[    0.000000]  [<ffffffff81e91c2f>] start_kernel+0x1e2/0x3e6
[    0.000000]  [<ffffffff81e917c2>] ? set_init_arg+0x55/0x55
[    0.000000]  [<ffffffff81e91120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81e91471>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81e91561>] x86_64_start_kernel+0xee/0xfb
[    0.000000] Code: cc 48 8b 15 d7 a3 0d 00 48 63 c3 ff c3 89 0c 82 48 8b =
15 c0 a3 0d 00 8b 4d c8 89 0c 82 eb bc 83 c8 ff 48 8b 3d 96 a3 0d 00 89 c2 =
<48> 0f ae 2f 48 8b 3d 89 a3 0d 00 89 c2 48 0f ae 27 58 5a 5b 41=20
[    0.000000] RIP  [<ffffffff81e9757c>] setup_init_fpu_buf+0x104/0x122
[    0.000000]  RSP <ffffffff81c03e30>
[    0.000000] ---[ end trace 9ac76427702d2536 ]---
[    0.000000] Kernel panic - not syncing: Fatal exception
[    0.000000] Rebooting in 10 seconds..
Elapsed time: 10
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86=
_64-randconfig-s0-07170233/d07c7f1ed61789e175fa975134855be32263be2c/vmlinuz=
-3.16.0-rc5-00004-gd07c7f1 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s0-07170233/linux=
-devel:devel-hourly-2014071701:d07c7f1ed61789e175fa975134855be32263be2c:bis=
ect-linux0/.vmlinuz-d07c7f1ed61789e175fa975134855be32263be2c-20140717182236=
-14-kbuild branch=3Dlinux-devel/devel-hourly-2014071701 BOOT_IMAGE=3D/kerne=
l/x86_64-randconfig-s0-07170233/d07c7f1ed61789e175fa975134855be32263be2c/vm=
linuz-3.16.0-rc5-00004-gd07c7f1 drbd.minor_count=3D8'  -initrd /kernel-test=
s/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1=
000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc =
base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-kbuild-1 -serial file:=
/dev/shm/kboot/serial-quantal-kbuild-1 -daemonize -display none -monitor nu=
ll=20

--7gLe/sNPhR777EPF
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-s0-07170233-5e60c2af7a8bde5cfaee8ffd77cfc5b62db0a04e-general-protection-fault:------81892.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNWU2MGMyYS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA3MTcwMScKZ2l0IGNoZWNrb3V0IDE3OTVjZDliM2E5MWQ0YjU0NzNjOTdm
NDkxZDYzODkyNDQyMjEyYWIKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDcxNzAxOjE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWI6Ymlz
ZWN0LWxpbnV4MAoKMjAxNC0wNy0xNy0wNDowMzozMyAxNzk1Y2Q5YjNhOTFkNGI1NDczYzk3
ZjQ5MWQ2Mzg5MjQ0MjIxMmFiIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLTE3
OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWIKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLzE3OTVjZDliM2E5
MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcw
MjMzLTE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWIKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1j
b25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy0xNzk1Y2Q5YjNhOTFkNGI1
NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMy8xNzk1Y2Q5YjNhOTFkNGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIx
MmFiL3ZtbGludXotMy4xNi4wLXJjNQoKMjAxNC0wNy0xNy0wNDozODozMyBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuLi4uLi4uLi4uLgkyLgkzMC4uLi4uLi4uCTQ1IFNVQ0NFU1MKCmJpc2Vj
dDogZ29vZCBjb21taXQgMTc5NWNkOWIzYTkxZDRiNTQ3M2M5N2Y0OTFkNjM4OTI0NDIyMTJh
YgpnaXQgYmlzZWN0IHN0YXJ0IDVlNjBjMmFmN2E4YmRlNWNmYWVlOGZmZDc3Y2ZjNWI2MmRi
MGEwNGUgMTc5NWNkOWIzYTkxZDRiNTQ3M2M5N2Y0OTFkNjM4OTI0NDIyMTJhYiAtLQovYy9r
ZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICI1ZTYwYzJhZjdhOGJkZTVjZmFl
ZThmZmQ3N2NmYzViNjJkYjBhMDRlIiwgIi1nIiwgIjE3OTVjZDliM2E5MWQ0YjU0NzNjOTdm
NDkxZDYzODkyNDQyMjEyYWIiLCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCIsICIvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdCJdCkJpc2Vj
dGluZzogNjM5NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MTMgc3RlcHMpCltiYzFmMmY5M2Y2OGJjY2Q5ODhhZjdlNmY3MzM4NDg2MGFjMjQxYjc4XSBN
ZXJnZSAnc29jZnBnYS1uZXgvbmlvczItdXBzdHJlYW0nIGludG8gZGV2ZWwtaG91cmx5LTIw
MTQwNzE3MDEKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTpiYzFmMmY5M2Y2OGJjY2Q5ODhhZjdl
NmY3MzM4NDg2MGFjMjQxYjc4OmJpc2VjdC1saW51eDAKCjIwMTQtMDctMTctMDQ6NTA6NDEg
YmMxZjJmOTNmNjhiY2NkOTg4YWY3ZTZmNzMzODQ4NjBhYzI0MWI3OCBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzE3MDIzMy1iYzFmMmY5M2Y2OGJjY2Q5ODhhZjdlNmY3MzM4NDg2MGFj
MjQxYjc4CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzE3MDIzMy9iYzFmMmY5M2Y2OGJjY2Q5ODhhZjdlNmY3MzM4NDg2MGFjMjQxYjc4Cndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy1iYzFmMmY5M2Y2OGJjY2Q5ODhhZjdlNmY3MzM4
NDg2MGFjMjQxYjc4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3
MDIzMy1iYzFmMmY5M2Y2OGJjY2Q5ODhhZjdlNmY3MzM4NDg2MGFjMjQxYjc4Cmtlcm5lbDog
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9iYzFmMmY5M2Y2OGJjY2Q5
ODhhZjdlNmY3MzM4NDg2MGFjMjQxYjc4L3ZtbGludXotMy4xNi4wLXJjNS0wNTAyNS1nYmMx
ZjJmOQoKMjAxNC0wNy0xNy0wNToxNzo0MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMgk0NSBT
VUNDRVNTCgpCaXNlY3Rpbmc6IDEzNzIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbMGQ3ZTFjYTQwZWYxNmZjZTUyOTc1NzkxMjE3MTdm
Yzc5Mzc2MWIzOF0gTWVyZ2UgJ2R5bnRpY2tzL25vaHovc3lzaWRsZScgaW50byBkZXZlbC1o
b3VybHktMjAxNDA3MTcwMQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcw
MjMzL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxNzAxOjBkN2UxY2E0MGVmMTZm
Y2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzg6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNy0xNy0w
NToxODo0MiAwZDdlMWNhNDBlZjE2ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYxYjM4IGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLTBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIx
NzE3ZmM3OTM3NjFiMzgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMwLTA3MTcwMjMzLzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3
NjFiMzgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLTBkN2UxY2E0MGVmMTZmY2U1Mjk3
NTc5MTIxNzE3ZmM3OTM3NjFiMzgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3
MDIzMy0wZDdlMWNhNDBlZjE2ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYxYjM4Cmtlcm5lbDog
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy8wZDdlMWNhNDBlZjE2ZmNl
NTI5NzU3OTEyMTcxN2ZjNzkzNzYxYjM4L3ZtbGludXotMy4xNi4wLXJjNS0wNTYxMS1nMGQ3
ZTFjYQoKMjAxNC0wNy0xNy0wNjowODo0MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLiBURVNU
IEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gUG9saWN5IHpvbmU6IERNQTMyClsgICAgMC4wMDAw
MDBdIEtlcm5lbCBjb21tYW5kIGxpbmU6IGh1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRr
PXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHJj
dXBkYXRlLnJjdV9jcHVfc3RhbGxfdGltZW91dD0xMDAgcGFuaWM9MTAgc29mdGxvY2t1cF9w
YW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyAgcHJvbXB0X3JhbWRpc2s9MCBjb25zb2xlPXR0
eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0vZGV2L3JhbTAgcncg
bGluaz0va2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAt
MDcxNzAyMzMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6MGQ3ZTFjYTQw
ZWYxNmZjZTUyOTc1NzkxMjE3MTdmYzc5Mzc2MWIzODpiaXNlY3QtbGludXgwLy52bWxpbnV6
LTBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzgtMjAxNDA3MTcwNjA4
MzQtMjcta2J1aWxkIGJyYW5jaD1saW51eC1kZXZlbC9kZXZlbC1ob3VybHktMjAxNDA3MTcw
MSBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvMGQ3
ZTFjYTQwZWYxNmZjZTUyOTc1NzkxMjE3MTdmYzc5Mzc2MWIzOC92bWxpbnV6LTMuMTYuMC1y
YzUtMDU2MTEtZzBkN2UxY2EgZHJiZC5taW5vcl9jb3VudD04ClsgICAgMC4wMDAwMDBdIFBJ
RCBoYXNoIHRhYmxlIGVudHJpZXM6IDIwNDggKG9yZGVyOiAyLCAxNjM4NCBieXRlcykKWyAg
ICAwLjAwMDAwMF0gZ2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0OiAwMDAwIFsjMV0gU01QIERF
QlVHX1BBR0VBTExPQwpbICAgIDAuMDAwMDAwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAw
LjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTYu
MC1yYzUtMDU2MTEtZzBkN2UxY2EgIzEKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFtZTog
Qm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDAwMDAwXSB0YXNr
OiBmZmZmZmZmZjgxYzEwNDkwIHRpOiBmZmZmZmZmZjgxYzAwMDAwIHRhc2sudGk6IGZmZmZm
ZmZmODFjMDAwMDAKWyAgICAwLjAwMDAwMF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MWU5NjU3
Yz5dICBbPGZmZmZmZmZmODFlOTY1N2M+XSBzZXR1cF9pbml0X2ZwdV9idWYrMHgxMDQvMHgx
MjIKWyAgICAwLjAwMDAwMF0gUlNQOiAwMDAwOmZmZmZmZmZmODFjMDNlMzAgIEVGTEFHUzog
MDAwMTAwODYKWyAgICAwLjAwMDAwMF0gUkFYOiAwMDAwMDAwMGZmZmZmZmZmIFJCWDogMDAw
MDAwMDAwMDAwMDAwMyBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAwMDAwMF0gUkRY
OiAwMDAwMDAwMGZmZmZmZmZmIFJTSTogZmZmZmZmZmY4MWMwM2UzNCBSREk6IGZmZmY4ODAw
MTNmZjkwMDAKWyAgICAwLjAwMDAwMF0gUkJQOiBmZmZmZmZmZjgxYzAzZTY4IFIwODogMDAw
MDAwMDAwMDAwMDA0MCBSMDk6IGZmZmZmZmZmODFjMDNlMzgKWyAgICAwLjAwMDAwMF0gUjEw
OiBmZmZmZmZmZjgxYzAzZTNjIFIxMTogMDAwMDAwMDAwMDAwMDA0MCBSMTI6IGZmZmZmZmZm
ODFjMDNlM2MKWyAgICAwLjAwMDAwMF0gUjEzOiBmZmZmZmZmZjgxYzAzZTM4IFIxNDogZmZm
ZmZmZmY4MWMwM2UzNCBSMTU6IGZmZmZmZmZmODFjMDNlMzAKWyAgICAwLjAwMDAwMF0gRlM6
ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMTEwMDAwMDAoMDAwMCkga25s
R1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDAwMDAwXSBDUzogIDAwMTAgRFM6IDAwMDAg
RVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgICAgMC4wMDAwMDBdIENSMjogZmZm
Zjg4MDAxMjdmZjAwMCBDUjM6IDAwMDAwMDAwMDFjMGIwMDAgQ1I0OiAwMDAwMDAwMDAwMDQw
NmEwClsgICAgMC4wMDAwMDBdIFN0YWNrOgpbICAgIDAuMDAwMDAwXSAgMDAwMDAwMDAwMDAw
MDAwMCAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODFjMDNlODAgZmZmZmZmZmY4MWMwM2U4
NApbICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4MWMwM2U3YyBmZmZmZmZmZjgxYzAzZTc4IDAw
MDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MWMwM2VhOApbICAgIDAuMDAwMDAwXSAgZmZmZmZm
ZmY4MWU5NjcxMSAwMDAwMDAwMDAwMDAwMDA3IDAwMDAwMzQwMDAwMDAzNDAgMDAwMDAwMDAw
MDAwMDAwOApbICAgIDAuMDAwMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgxZTk2NzExPl0geHN0YXRlX2VuYWJsZV9ib290X2NwdSsweDE3Ny8weDFmMgpb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDBjMTNmPl0geHNhdmVfaW5pdCsweDI2LzB4
MjgKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTAwYjBjMz5dIGZwdV9pbml0KzB4OTYv
MHg5ZApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDExMjcyPl0gY3B1X2luaXQrMHgy
YmMvMHgyZjMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5MmIwNj5dIHRyYXBfaW5p
dCsweDU0My8weDVlYgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTkwYzJmPl0gc3Rh
cnRfa2VybmVsKzB4MWUyLzB4M2U2ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlOTA3
YzI+XSA/IHNldF9pbml0X2FyZysweDU1LzB4NTUKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MWU5MDEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODFlOTA0NzE+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25z
KzB4MmEvMHgyYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTkwNTYxPl0geDg2XzY0
X3N0YXJ0X2tlcm5lbCsweGVlLzB4ZmIKWyAgICAwLjAwMDAwMF0gQ29kZTogY2MgNDggOGIg
MTUgZDcgYjMgMGQgMDAgNDggNjMgYzMgZmYgYzMgODkgMGMgODIgNDggOGIgMTUgYzAgYjMg
MGQgMDAgOGIgNGQgYzggODkgMGMgODIgZWIgYmMgODMgYzggZmYgNDggOGIgM2QgOTYgYjMg
MGQgMDAgODkgYzIgPDQ4PiAwZiBhZSAyZiA0OCA4YiAzZCA4OSBiMyAwZCAwMCA4OSBjMiA0
OCAwZiBhZSAyNyA1OCA1YSA1YiA0MSAKWyAgICAwLjAwMDAwMF0gUklQICBbPGZmZmZmZmZm
ODFlOTY1N2M+XSBzZXR1cF9pbml0X2ZwdV9idWYrMHgxMDQvMHgxMjIKWyAgICAwLjAwMDAw
MF0gIFJTUCA8ZmZmZmZmZmY4MWMwM2UzMD4KWyAgICAwLjAwMDAwMF0gLS0tWyBlbmQgdHJh
Y2UgMzViMGY4YjY2Mzg2OTFkMCBdLS0tClsgICAgMC4wMDAwMDBdIEtlcm5lbCBwYW5pYyAt
IG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNzE3MDIzMy8wZDdlMWNhNDBlZjE2ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYxYjM4
L2RtZXNnLXF1YW50YWwta2J1aWxkLTE3OjIwMTQwNzE3MDYwNzE1Ong4Nl82NC1yYW5kY29u
ZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDU2MTEtZzBkN2UxY2E6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIx
NzE3ZmM3OTM3NjFiMzgvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjU6MjAxNDA3MTcwNjA3MTM6
eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0wNTYxMS1nMGQ3ZTFj
YToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvMGQ3ZTFjYTQwZWYx
NmZjZTUyOTc1NzkxMjE3MTdmYzc5Mzc2MWIzOC9kbWVzZy1xdWFudGFsLWtidWlsZC0yMjoy
MDE0MDcxNzA2MDcyNDp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1
LTA1NjExLWcwZDdlMWNhOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIz
My8wZDdlMWNhNDBlZjE2ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYxYjM4L2RtZXNnLXF1YW50
YWwta2J1aWxkLTI1OjIwMTQwNzE3MDYwNzI0Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcw
MjMzOjMuMTYuMC1yYzUtMDU2MTEtZzBkN2UxY2E6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTA3MTcwMjMzLzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFi
MzgvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjoyMDE0MDcxNzA2MDczMDp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTA1NjExLWcwZDdlMWNhOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy8wZDdlMWNhNDBlZjE2ZmNlNTI5NzU3OTEy
MTcxN2ZjNzkzNzYxYjM4L2RtZXNnLXF1YW50YWwta2J1aWxkLTc6MjAxNDA3MTcwNjA3MjM6
eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0wNTYxMS1nMGQ3ZTFj
YToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvMGQ3ZTFjYTQwZWYx
NmZjZTUyOTc1NzkxMjE3MTdmYzc5Mzc2MWIzOC9kbWVzZy15b2N0by1rYnVpbGQtMTM6MjAx
NDA3MTcwNjA3Mjk6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0w
NTYxMS1nMGQ3ZTFjYToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMv
MGQ3ZTFjYTQwZWYxNmZjZTUyOTc1NzkxMjE3MTdmYzc5Mzc2MWIzOC9kbWVzZy15b2N0by1r
YnVpbGQtNjoyMDE0MDcxNzA2MDcyNDp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzoz
LjE2LjAtcmM1LTA1NjExLWcwZDdlMWNhOjEKMDo4OjggYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKCkJpc2VjdGluZzogNTg2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMCBzdGVwcykKWzMzYzEzYmYyNDg3YTQyZWZhMWFjOWJjY2U1NjIzYWI3
NGEzNzVjOTNdIE1lcmdlICd1Ymlmcy9saW51eC1uZXh0JyBpbnRvIGRldmVsLWhvdXJseS0y
MDE0MDcxNzAxCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6MzNjMTNiZjI0ODdhNDJlZmExYWM5
YmNjZTU2MjNhYjc0YTM3NWM5MzpiaXNlY3QtbGludXgwCgoyMDE0LTA3LTE3LTA2OjA5OjQ0
IDMzYzEzYmYyNDg3YTQyZWZhMWFjOWJjY2U1NjIzYWI3NGEzNzVjOTMgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctczAtMDcxNzAyMzMtMzNjMTNiZjI0ODdhNDJlZmExYWM5YmNjZTU2MjNhYjc0
YTM3NWM5MwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czAtMDcxNzAyMzMvMzNjMTNiZjI0ODdhNDJlZmExYWM5YmNjZTU2MjNhYjc0YTM3NWM5Mwp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMtMzNjMTNiZjI0ODdhNDJlZmExYWM5YmNjZTU2
MjNhYjc0YTM3NWM5Mwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvamFrZXRvd24tY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctczAtMDcx
NzAyMzMtMzNjMTNiZjI0ODdhNDJlZmExYWM5YmNjZTU2MjNhYjc0YTM3NWM5MwprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvMzNjMTNiZjI0ODdhNDJl
ZmExYWM5YmNjZTU2MjNhYjc0YTM3NWM5My92bWxpbnV6LTMuMTYuMC1yYzUtMDUyMjctZzMz
YzEzYmYKCjIwMTQtMDctMTctMDY6NTY6NDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxCTQ1
IFNVQ0NFU1MKCkJpc2VjdGluZzogMzg0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbMTAzMmY3M2EzMjk1MWQ3ZjE0ZWQ3ZmRhZGVkYjBm
ZWYzYzZkMGY0OV0gTWVyZ2UgJ3NwaS9mb3ItbmV4dCcgaW50byBkZXZlbC1ob3VybHktMjAx
NDA3MTcwMQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2xpbnV4
LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxNzAxOjEwMzJmNzNhMzI5NTFkN2YxNGVkN2Zk
YWRlZGIwZmVmM2M2ZDBmNDk6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNy0xNy0wNjo1ODoxNSAx
MDMyZjczYTMyOTUxZDdmMTRlZDdmZGFkZWRiMGZlZjNjNmQwZjQ5IGNvbXBpbGluZwpRdWV1
ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLXMwLTA3MTcwMjMzLTEwMzJmNzNhMzI5NTFkN2YxNGVkN2ZkYWRlZGIwZmVmM2M2
ZDBmNDkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA3MTcwMjMzLzEwMzJmNzNhMzI5NTFkN2YxNGVkN2ZkYWRlZGIwZmVmM2M2ZDBmNDkKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLTEwMzJmNzNhMzI5NTFkN2YxNGVkN2ZkYWRlZGIw
ZmVmM2M2ZDBmNDkKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcw
MjMzLzEwMzJmNzNhMzI5NTFkN2YxNGVkN2ZkYWRlZGIwZmVmM2M2ZDBmNDkvdm1saW51ei0z
LjE2LjAtcmM1LTA1Mzc2LWcxMDMyZjczCgoyMDE0LTA3LTE3LTA3OjA4OjE1IGRldGVjdGlu
ZyBib290IHN0YXRlIC4uCTQ1IFNVQ0NFU1MKCkJpc2VjdGluZzogMjMzIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbMWYyODU5ZjA3ODYz
MzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MV0gTWVyZ2UgJ3NoYXduZ3VvL2Zvci1uZXh0
JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDcxNzAxCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDAvb2Jq
LWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctczAtMDcxNzAyMzMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6
MWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MTpiaXNlY3QtbGludXgw
CgoyMDE0LTA3LTE3LTA3OjA5OjQ1IDFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJh
MmYxYjU0OTEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMtMWYyODU5ZjA3ODYz
MzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvMWYyODU5ZjA3ODYzMzhmZTRjMmEx
OGVhNTE4YTViMmEyZjFiNTQ5MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMtMWYyODU5
ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MQp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAxLWNvbnN1bWVyL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLTFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUx
OGE1YjJhMmYxYjU0OTEKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3
MTcwMjMzLzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvdm1saW51
ei0zLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmCgoyMDE0LTA3LTE3LTA3OjIyOjQ2IGRldGVj
dGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBdIFBvbGljeSB6
b25lOiBETUEzMgpbICAgIDAuMDAwMDAwXSBLZXJuZWwgY29tbWFuZCBsaW5lOiBodW5nX3Rh
c2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBz
eXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAw
IHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21w
dF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3Jt
YWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDcxNzAxOjFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTE6
YmlzZWN0LWxpbnV4MC8udm1saW51ei0xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIy
YTJmMWI1NDkxLTIwMTQwNzE3MTUyMjQxLTkta2J1aWxkIGJyYW5jaD1saW51eC1kZXZlbC9k
ZXZlbC1ob3VybHktMjAxNDA3MTcwMSBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczAtMDcxNzAyMzMvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFi
NTQ5MS92bWxpbnV6LTMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWYgZHJiZC5taW5vcl9jb3Vu
dD04ClsgICAgMC4wMDAwMDBdIFBJRCBoYXNoIHRhYmxlIGVudHJpZXM6IDIwNDggKG9yZGVy
OiAyLCAxNjM4NCBieXRlcykKWyAgICAwLjAwMDAwMF0gZ2VuZXJhbCBwcm90ZWN0aW9uIGZh
dWx0OiAwMDAwIFsjMV0gU01QIERFQlVHX1BBR0VBTExPQwpbICAgIDAuMDAwMDAwXSBNb2R1
bGVzIGxpbmtlZCBpbjoKWyAgICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2Fw
cGVyIE5vdCB0YWludGVkIDMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWYgIzIKWyAgICAwLjAw
MDAwMF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAx
MQpbICAgIDAuMDAwMDAwXSB0YXNrOiBmZmZmZmZmZjgxYzEwNDkwIHRpOiBmZmZmZmZmZjgx
YzAwMDAwIHRhc2sudGk6IGZmZmZmZmZmODFjMDAwMDAKWyAgICAwLjAwMDAwMF0gUklQOiAw
MDEwOls8ZmZmZmZmZmY4MWU5NjU3Yz5dICBbPGZmZmZmZmZmODFlOTY1N2M+XSBzZXR1cF9p
bml0X2ZwdV9idWYrMHgxMDQvMHgxMjIKWyAgICAwLjAwMDAwMF0gUlNQOiAwMDAwOmZmZmZm
ZmZmODFjMDNlMzAgIEVGTEFHUzogMDAwMTAwODYKWyAgICAwLjAwMDAwMF0gUkFYOiAwMDAw
MDAwMGZmZmZmZmZmIFJCWDogMDAwMDAwMDAwMDAwMDAwMyBSQ1g6IDAwMDAwMDAwMDAwMDAw
MDAKWyAgICAwLjAwMDAwMF0gUkRYOiAwMDAwMDAwMGZmZmZmZmZmIFJTSTogZmZmZmZmZmY4
MWMwM2UzNCBSREk6IGZmZmY4ODAwMTNmZjkwMDAKWyAgICAwLjAwMDAwMF0gUkJQOiBmZmZm
ZmZmZjgxYzAzZTY4IFIwODogMDAwMDAwMDAwMDAwMDA0MCBSMDk6IGZmZmZmZmZmODFjMDNl
MzgKWyAgICAwLjAwMDAwMF0gUjEwOiBmZmZmZmZmZjgxYzAzZTNjIFIxMTogMDAwMDAwMDAw
MDAwMDA0MCBSMTI6IGZmZmZmZmZmODFjMDNlM2MKWyAgICAwLjAwMDAwMF0gUjEzOiBmZmZm
ZmZmZjgxYzAzZTM4IFIxNDogZmZmZmZmZmY4MWMwM2UzNCBSMTU6IGZmZmZmZmZmODFjMDNl
MzAKWyAgICAwLjAwMDAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4
ODAwMTEwMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDAwMDAw
XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsg
ICAgMC4wMDAwMDBdIENSMjogZmZmZjg4MDAxMjdmZjAwMCBDUjM6IDAwMDAwMDAwMDFjMGIw
MDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmEwClsgICAgMC4wMDAwMDBdIFN0YWNrOgpbICAgIDAu
MDAwMDAwXSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODFj
MDNlODAgZmZmZmZmZmY4MWMwM2U4NApbICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4MWMwM2U3
YyBmZmZmZmZmZjgxYzAzZTc4IDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MWMwM2VhOApb
ICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4MWU5NjcxMSAwMDAwMDAwMDAwMDAwMDA3IDAwMDAw
MzQwMDAwMDAzNDAgMDAwMDAwMDAwMDAwMDAwOApbICAgIDAuMDAwMDAwXSBDYWxsIFRyYWNl
OgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTk2NzExPl0geHN0YXRlX2VuYWJsZV9i
b290X2NwdSsweDE3Ny8weDFmMgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDBjMTNm
Pl0geHNhdmVfaW5pdCsweDI2LzB4MjgKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTAw
YjBjMz5dIGZwdV9pbml0KzB4OTYvMHg5ZApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgx
MDExMjcyPl0gY3B1X2luaXQrMHgyYmMvMHgyZjMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MWU5MmIwNj5dIHRyYXBfaW5pdCsweDU0My8weDVlYgpbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgxZTkwYzJmPl0gc3RhcnRfa2VybmVsKzB4MWUyLzB4M2U2ClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODFlOTA3YzI+XSA/IHNldF9pbml0X2FyZysweDU1LzB4NTUKWyAg
ICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5MDEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJz
KzB4MTIwLzB4MTIwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlOTA0NzE+XSB4ODZf
NjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4MmEvMHgyYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZm
ZmZmZjgxZTkwNTYxPl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweGVlLzB4ZmIKWyAgICAwLjAw
MDAwMF0gQ29kZTogY2MgNDggOGIgMTUgZDcgYjMgMGQgMDAgNDggNjMgYzMgZmYgYzMgODkg
MGMgODIgNDggOGIgMTUgYzAgYjMgMGQgMDAgOGIgNGQgYzggODkgMGMgODIgZWIgYmMgODMg
YzggZmYgNDggOGIgM2QgOTYgYjMgMGQgMDAgODkgYzIgPDQ4PiAwZiBhZSAyZiA0OCA4YiAz
ZCA4OSBiMyAwZCAwMCA4OSBjMiA0OCAwZiBhZSAyNyA1OCA1YSA1YiA0MSAKWyAgICAwLjAw
MDAwMF0gUklQICBbPGZmZmZmZmZmODFlOTY1N2M+XSBzZXR1cF9pbml0X2ZwdV9idWYrMHgx
MDQvMHgxMjIKWyAgICAwLjAwMDAwMF0gIFJTUCA8ZmZmZmZmZmY4MWMwM2UzMD4KWyAgICAw
LjAwMDAwMF0gLS0tWyBlbmQgdHJhY2UgNTZjNzBlNzcwNzBhMzMwNCBdLS0tClsgICAgMC4w
MDAwMDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy8xZjI4NTlmMDc4NjMzOGZlNGMy
YTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXF1YW50YWwta2J1aWxkLTEwOjIwMTQwNzE3
MDcyMDIyOng4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDU1Njct
ZzFmMjg1OWY6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLzFmMjg1
OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2ctcXVhbnRhbC1rYnVp
bGQtMTM6MjAxNDA3MTcwNzIwMjI6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4x
Ni4wLXJjNS0wNTU2Ny1nMWYyODU5ZjoyCjA6MjoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzCgpCaXNlY3Rpbmc6IDE5MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgOCBzdGVwcykKWzczYzQ3Njg4YTAzOTE1OGE2ZDM5NTYyOWQzYWIzMmU2MDZl
MTNkMWFdIE1lcmdlICdyZWd1bGF0b3IvZm9yLW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIw
MTQwNzE3MDEKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTo3M2M0NzY4OGEwMzkxNThhNmQzOTU2
MjlkM2FiMzJlNjA2ZTEzZDFhOmJpc2VjdC1saW51eDAKCjIwMTQtMDctMTctMDc6MjM6MTgg
NzNjNDc2ODhhMDM5MTU4YTZkMzk1NjI5ZDNhYjMyZTYwNmUxM2QxYSBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzE3MDIzMy03M2M0NzY4OGEwMzkxNThhNmQzOTU2MjlkM2FiMzJlNjA2
ZTEzZDFhCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzE3MDIzMy83M2M0NzY4OGEwMzkxNThhNmQzOTU2MjlkM2FiMzJlNjA2ZTEzZDFhCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy03M2M0NzY4OGEwMzkxNThhNmQzOTU2MjlkM2Fi
MzJlNjA2ZTEzZDFhCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3
MDIzMy83M2M0NzY4OGEwMzkxNThhNmQzOTU2MjlkM2FiMzJlNjA2ZTEzZDFhL3ZtbGludXot
My4xNi4wLXJjNS0wNTQzNi1nNzNjNDc2OAoKMjAxNC0wNy0xNy0wNzoyODoxOCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLi4uCTQ1IFNVQ0NFU1MKCkJpc2VjdGluZzogMTMxIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbYjk3M2ZkZjVl
NmU2ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYV0gTWVyZ2UgJ2x1dG8vc3luY19yYW5k
X3NlZWQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3
MTcwMTpiOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhOmJpc2VjdC1s
aW51eDAKCjIwMTQtMDctMTctMDc6MzE6MTEgYjk3M2ZkZjVlNmU2ZmU4NGI1MWY3OTkxOWU1
ZGM4NTc0YWU4NTlkYSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy1iOTczZmRm
NWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhCkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9iOTczZmRmNWU2ZTZmZTg0
YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy1i
OTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhCmtlcm5lbDogL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5
OTE5ZTVkYzg1NzRhZTg1OWRhL3ZtbGludXotMy4xNi4wLXJjNS0wNTQ0MS1nYjk3M2ZkZgoK
MjAxNC0wNy0xNy0wNzozMzoxMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgk0NSBTVUNDRVNT
CgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSBzaGF3bmd1by9mb3ItbmV4dAps
aW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6
IGdpdCBiaXNlY3Qgc3RhcnQgMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFi
NTQ5MSBiOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhIC0tClByZXZp
b3VzIEhFQUQgcG9zaXRpb24gd2FzIGI5NzNmZGYuLi4gTWVyZ2UgJ2x1dG8vc3luY19yYW5k
X3NlZWQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEKSEVBRCBpcyBub3cgYXQgZTI0
NDdjNS4uLiBNZXJnZSAnY3J5cHRvZGV2L21hc3RlcicgaW50byBkZXZlbC1ob3VybHktMjAx
NDA2MjcxMwpCaXNlY3Rpbmc6IDYyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSA2IHN0ZXBzKQpbZWI3YWMwMThiMWJjMjY1ZjIxZWZmZTE4M2ExYzY5OTk5
MzEwZDMzZF0gQVJNOiBpLk1YMjcgY2xrOiBSZW1vdmUgdW51c2VkIGRlZmluaXRpb25zCmxp
bmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9saW51eC1kZXZlbDpkZXZl
bC1ob3VybHktMjAxNDA3MTcwMTplYjdhYzAxOGIxYmMyNjVmMjFlZmZlMTgzYTFjNjk5OTkz
MTBkMzNkOmJpc2VjdC1saW51eDAKCjIwMTQtMDctMTctMDc6MzU6NTAgZWI3YWMwMThiMWJj
MjY1ZjIxZWZmZTE4M2ExYzY5OTk5MzEwZDMzZCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzE3MDIzMy1lYjdhYzAxOGIxYmMyNjVmMjFlZmZlMTgzYTFjNjk5OTkzMTBkMzNkCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9l
YjdhYzAxOGIxYmMyNjVmMjFlZmZlMTgzYTFjNjk5OTkzMTBkMzNkCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNzE3MDIzMy1lYjdhYzAxOGIxYmMyNjVmMjFlZmZlMTgzYTFjNjk5OTkzMTBkMzNk
Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9lYjdhYzAx
OGIxYmMyNjVmMjFlZmZlMTgzYTFjNjk5OTkzMTBkMzNkL3ZtbGludXotMy4xNi4wLXJjMy0w
MDA2My1nZWI3YWMwMQoKMjAxNC0wNy0xNy0wNzozODo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLgkyOAk0NSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDMxIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbODZmYzA0MWVkNWNmZWE1MDQxNGIw
YjA5ODYwYTcxZmExMTIzMzg1OV0gQVJNOiBkdHM6IGlteDZzeC1zZGI6IGFkZCBncGlvIGtl
eSBzdXBwb3J0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6ODZmYzA0MWVkNWNmZWE1MDQxNGIw
YjA5ODYwYTcxZmExMTIzMzg1OTpiaXNlY3QtbGludXgwCgoyMDE0LTA3LTE3LTA3OjQxOjQz
IDg2ZmMwNDFlZDVjZmVhNTA0MTRiMGIwOTg2MGE3MWZhMTEyMzM4NTkgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctczAtMDcxNzAyMzMtODZmYzA0MWVkNWNmZWE1MDQxNGIwYjA5ODYwYTcxZmEx
MTIzMzg1OQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czAtMDcxNzAyMzMvODZmYzA0MWVkNWNmZWE1MDQxNGIwYjA5ODYwYTcxZmExMTIzMzg1OQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMtODZmYzA0MWVkNWNmZWE1MDQxNGIwYjA5ODYw
YTcxZmExMTIzMzg1OQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvc25iLXNtb2tlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLTg2
ZmMwNDFlZDVjZmVhNTA0MTRiMGIwOTg2MGE3MWZhMTEyMzM4NTkKa2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLzg2ZmMwNDFlZDVjZmVhNTA0MTRiMGIw
OTg2MGE3MWZhMTEyMzM4NTkvdm1saW51ei0zLjE2LjAtcmMzLTAwMDk0LWc4NmZjMDQxCgoy
MDE0LTA3LTE3LTA4OjAxOjQ0IGRldGVjdGluZyBib290IHN0YXRlIC4JOAk0NSBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDE1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA0IHN0ZXBzKQpbOWY4OTg4OTExZmYyODI4NWYxNjRlM2M4MzAwZjg2OWQwZGNmOGM1
OV0gQVJNOiBkdHM6IGlteDZzeDogRml4IHNkbWEgbm9kZQpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgw
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA3MTcwMjMzL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcx
NzAxOjlmODk4ODkxMWZmMjgyODVmMTY0ZTNjODMwMGY4NjlkMGRjZjhjNTk6YmlzZWN0LWxp
bnV4MAoKMjAxNC0wNy0xNy0wODowMzoxNSA5Zjg5ODg5MTFmZjI4Mjg1ZjE2NGUzYzgzMDBm
ODY5ZDBkY2Y4YzU5IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLTlmODk4ODkx
MWZmMjgyODVmMTY0ZTNjODMwMGY4NjlkMGRjZjhjNTkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLzlmODk4ODkxMWZmMjgyODVm
MTY0ZTNjODMwMGY4NjlkMGRjZjhjNTkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLTlm
ODk4ODkxMWZmMjgyODVmMTY0ZTNjODMwMGY4NjlkMGRjZjhjNTkKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVy
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLTlmODk4ODkxMWZmMjgyODVmMTY0ZTNj
ODMwMGY4NjlkMGRjZjhjNTkKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA3MTcwMjMzLzlmODk4ODkxMWZmMjgyODVmMTY0ZTNjODMwMGY4NjlkMGRjZjhjNTkvdm1s
aW51ei0zLjE2LjAtcmMzLTAwMTEwLWc5Zjg5ODg5CgoyMDE0LTA3LTE3LTA5OjE3OjE2IGRl
dGVjdGluZyBib290IHN0YXRlIAkxLgk0NSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDcgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltjOGRhZDk1
MDQ0ZWQzN2ZjZjVmNmNjYWZiYjMwZDJjNjRlYWI0MDFmXSBBUk06IGR0czogdmY2MTA6IGZp
eCBsZW5ndGggb2YgZXNoZGMxIHJlZ2lzdGVyIHByb3BlcnR5CnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eDAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctczAtMDcxNzAyMzMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQw
NzE3MDE6YzhkYWQ5NTA0NGVkMzdmY2Y1ZjZjY2FmYmIzMGQyYzY0ZWFiNDAxZjpiaXNlY3Qt
bGludXgwCgoyMDE0LTA3LTE3LTA5OjE4OjQ2IGM4ZGFkOTUwNDRlZDM3ZmNmNWY2Y2NhZmJi
MzBkMmM2NGVhYjQwMWYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMtYzhkYWQ5
NTA0NGVkMzdmY2Y1ZjZjY2FmYmIzMGQyYzY0ZWFiNDAxZgpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvYzhkYWQ5NTA0NGVkMzdm
Y2Y1ZjZjY2FmYmIzMGQyYzY0ZWFiNDAxZgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMt
YzhkYWQ5NTA0NGVkMzdmY2Y1ZjZjY2FmYmIzMGQyYzY0ZWFiNDAxZgp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAxLWNvbnN1
bWVyL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLWM4ZGFkOTUwNDRlZDM3ZmNmNWY2
Y2NhZmJiMzBkMmM2NGVhYjQwMWYKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTA3MTcwMjMzL2M4ZGFkOTUwNDRlZDM3ZmNmNWY2Y2NhZmJiMzBkMmM2NGVhYjQwMWYv
dm1saW51ei0zLjE2LjAtcmMzLTAwMTE4LWdjOGRhZDk1CgoyMDE0LTA3LTE3LTA5OjIyOjQ2
IGRldGVjdGluZyBib290IHN0YXRlIC4JNgk0NSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDMgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCltjZGRj
MzRkMDkyNGMzZTc4ZmExZWQ0OTM4MjJlZDY5NjVmZDJiYWEwXSBBUk06IGR0czogYWRkIGlu
aXRpYWwgUmV4IEJhc2ljIGJvYXJkIHN1cHBvcnQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmot
YmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMy9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTpj
ZGRjMzRkMDkyNGMzZTc4ZmExZWQ0OTM4MjJlZDY5NjVmZDJiYWEwOmJpc2VjdC1saW51eDAK
CjIwMTQtMDctMTctMDk6MjQ6MTkgY2RkYzM0ZDA5MjRjM2U3OGZhMWVkNDkzODIyZWQ2OTY1
ZmQyYmFhMCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy1jZGRjMzRkMDkyNGMz
ZTc4ZmExZWQ0OTM4MjJlZDY5NjVmZDJiYWEwCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9jZGRjMzRkMDkyNGMzZTc4ZmExZWQ0
OTM4MjJlZDY5NjVmZDJiYWEwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy1jZGRjMzRk
MDkyNGMzZTc4ZmExZWQ0OTM4MjJlZDY5NjVmZDJiYWEwCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2
XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMtY2RkYzM0ZDA5MjRjM2U3OGZhMWVkNDkzODIy
ZWQ2OTY1ZmQyYmFhMAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcx
NzAyMzMvY2RkYzM0ZDA5MjRjM2U3OGZhMWVkNDkzODIyZWQ2OTY1ZmQyYmFhMC92bWxpbnV6
LTMuMTYuMC1yYzMtMDAxMjItZ2NkZGMzNGQKCjIwMTQtMDctMTctMDk6Mjg6MTkgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLi4JNDUgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCltlZDdkNDIyYTk0NWU5
NTcyNTU3MTM4MDYyNTkzMzU4ZjMzNTNhNDI5XSBBUk06IGR0czogdmY2MTA6IGFkZCBGbGV4
Q0FOIG5vZGUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTplZDdkNDIyYTk0NWU5NTcyNTU3MTM4
MDYyNTkzMzU4ZjMzNTNhNDI5OmJpc2VjdC1saW51eDAKCjIwMTQtMDctMTctMDk6Mjk6NTEg
ZWQ3ZDQyMmE5NDVlOTU3MjU1NzEzODA2MjU5MzM1OGYzMzUzYTQyOSBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzE3MDIzMy1lZDdkNDIyYTk0NWU5NTcyNTU3MTM4MDYyNTkzMzU4ZjMz
NTNhNDI5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzE3MDIzMy9lZDdkNDIyYTk0NWU5NTcyNTU3MTM4MDYyNTkzMzU4ZjMzNTNhNDI5Cndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy1lZDdkNDIyYTk0NWU5NTcyNTU3MTM4MDYyNTkz
MzU4ZjMzNTNhNDI5Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3
MDIzMy9lZDdkNDIyYTk0NWU5NTcyNTU3MTM4MDYyNTkzMzU4ZjMzNTNhNDI5L3ZtbGludXot
My4xNi4wLXJjMy0wMDEyMy1nZWQ3ZDQyMgoKMjAxNC0wNy0xNy0wOTozMTo1MSBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLgkzOAk0NSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzY0ZWYwNmI1ZTM0
NzU0ODM2ZGRhMmE2ZmMxZTE3Zjc0MzE4NWE5NGNdIE1lcmdlIGJyYW5jaCAnaW14L2R0JyBp
bnRvIGZvci1uZXh0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdApscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMv
bGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6NjRlZjA2YjVlMzQ3NTQ4MzZk
ZGEyYTZmYzFlMTdmNzQzMTg1YTk0YzpiaXNlY3QtbGludXgwCgoyMDE0LTA3LTE3LTA5OjM0
OjE4IDY0ZWYwNmI1ZTM0NzU0ODM2ZGRhMmE2ZmMxZTE3Zjc0MzE4NWE5NGMgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctczAtMDcxNzAyMzMtNjRlZjA2YjVlMzQ3NTQ4MzZkZGEyYTZmYzFlMTdm
NzQzMTg1YTk0YwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczAtMDcxNzAyMzMvNjRlZjA2YjVlMzQ3NTQ4MzZkZGEyYTZmYzFlMTdmNzQzMTg1YTk0
Ywp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMtNjRlZjA2YjVlMzQ3NTQ4MzZkZGEyYTZm
YzFlMTdmNzQzMTg1YTk0YwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAt
MDcxNzAyMzMvNjRlZjA2YjVlMzQ3NTQ4MzZkZGEyYTZmYzFlMTdmNzQzMTg1YTk0Yy92bWxp
bnV6LTMuMTYuMC1yYzMtMDAxMjUtZzY0ZWYwNmIKCjIwMTQtMDctMTctMDk6MzY6MzIgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgCTQ1IFNVQ0NFU1MKCjFmMjg1OWYwNzg2MzM4ZmU0YzJhMThl
YTUxOGE1YjJhMmYxYjU0OTEgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKYmlzZWN0IHJ1biBz
dWNjZXNzClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDY0ZWYwNmIuLi4gTWVyZ2UgYnJh
bmNoICdpbXgvZHQnIGludG8gZm9yLW5leHQKSEVBRCBpcyBub3cgYXQgYjk3M2ZkZi4uLiBN
ZXJnZSAnbHV0by9zeW5jX3JhbmRfc2VlZCcgaW50byBkZXZlbC1ob3VybHktMjAxNDA3MTcw
MQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
czAtMDcxNzAyMzMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6Yjk3M2Zk
ZjVlNmU2ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYTpiaXNlY3QtbGludXgwCgoyMDE0
LTA3LTE3LTA5OjM5OjU2IGI5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5
ZGEgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9iOTczZmRm
NWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL3ZtbGludXotMy4xNi4wLXJjNS0w
NTQ0MS1nYjk3M2ZkZgoKMjAxNC0wNy0xNy0wOTozOTo1NiBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAuMDAwMDAwXSBQb2xpY3kgem9uZTogRE1BMzIKWyAg
ICAwLjAwMDAwMF0gS2VybmVsIGNvbW1hbmQgbGluZTogaHVuZ190YXNrX3BhbmljPTEgZWFy
bHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2Vu
YWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0
bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNv
bnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYv
cmFtMCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMy9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTpi
OTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhOmJpc2VjdC1saW51eDAv
LnZtbGludXotYjk3M2ZkZjVlNmU2ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYS0yMDE0
MDcxNzA5Mzk1Ni00MC1rYnVpbGQgYnJhbmNoPWxpbnV4LWRldmVsL2RldmVsLWhvdXJseS0y
MDE0MDcxNzAxIEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3
MDIzMy9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL3ZtbGludXot
My4xNi4wLXJjNS0wNTQ0MS1nYjk3M2ZkZiBkcmJkLm1pbm9yX2NvdW50PTgKWyAgICAwLjAw
MDAwMF0gUElEIGhhc2ggdGFibGUgZW50cmllczogMjA0OCAob3JkZXI6IDIsIDE2Mzg0IGJ5
dGVzKQpbICAgIDAuMDAwMDAwXSBnZW5lcmFsIHByb3RlY3Rpb24gZmF1bHQ6IDAwMDAgWyMx
XSBTTVAgREVCVUdfUEFHRUFMTE9DClsgICAgMC4wMDAwMDBdIE1vZHVsZXMgbGlua2VkIGlu
OgpbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRhaW50
ZWQgMy4xNi4wLXJjNS0wNTQ0MS1nYjk3M2ZkZiAjNApbICAgIDAuMDAwMDAwXSBIYXJkd2Fy
ZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMDAw
MDBdIHRhc2s6IGZmZmZmZmZmODFjMTA0OTAgdGk6IGZmZmZmZmZmODFjMDAwMDAgdGFzay50
aTogZmZmZmZmZmY4MWMwMDAwMApbICAgIDAuMDAwMDAwXSBSSVA6IDAwMTA6WzxmZmZmZmZm
ZjgxZTk2NTdjPl0gIFs8ZmZmZmZmZmY4MWU5NjU3Yz5dIHNldHVwX2luaXRfZnB1X2J1Zisw
eDEwNC8weDEyMgpbICAgIDAuMDAwMDAwXSBSU1A6IDAwMDA6ZmZmZmZmZmY4MWMwM2UzMCAg
RUZMQUdTOiAwMDAxMDA4NgpbICAgIDAuMDAwMDAwXSBSQVg6IDAwMDAwMDAwZmZmZmZmZmYg
UkJYOiAwMDAwMDAwMDAwMDAwMDAzIFJDWDogMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDAw
MDAwXSBSRFg6IDAwMDAwMDAwZmZmZmZmZmYgUlNJOiBmZmZmZmZmZjgxYzAzZTM0IFJESTog
ZmZmZjg4MDAxM2ZmOTAwMApbICAgIDAuMDAwMDAwXSBSQlA6IGZmZmZmZmZmODFjMDNlNjgg
UjA4OiAwMDAwMDAwMDAwMDAwMDQwIFIwOTogZmZmZmZmZmY4MWMwM2UzOApbICAgIDAuMDAw
MDAwXSBSMTA6IGZmZmZmZmZmODFjMDNlM2MgUjExOiAwMDAwMDAwMDAwMDAwMDQwIFIxMjog
ZmZmZmZmZmY4MWMwM2UzYwpbICAgIDAuMDAwMDAwXSBSMTM6IGZmZmZmZmZmODFjMDNlMzgg
UjE0OiBmZmZmZmZmZjgxYzAzZTM0IFIxNTogZmZmZmZmZmY4MWMwM2UzMApbICAgIDAuMDAw
MDAwXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4MDAxMTAwMDAwMCgw
MDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMDAwMDBdIENTOiAgMDAxMCBE
UzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKWyAgICAwLjAwMDAwMF0g
Q1IyOiBmZmZmODgwMDEyN2ZmMDAwIENSMzogMDAwMDAwMDAwMWMwYjAwMCBDUjQ6IDAwMDAw
MDAwMDAwNDA2YTAKWyAgICAwLjAwMDAwMF0gU3RhY2s6ClsgICAgMC4wMDAwMDBdICAwMDAw
MDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MWMwM2U4MCBmZmZmZmZm
ZjgxYzAzZTg0ClsgICAgMC4wMDAwMDBdICBmZmZmZmZmZjgxYzAzZTdjIGZmZmZmZmZmODFj
MDNlNzggMDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgxYzAzZWE4ClsgICAgMC4wMDAwMDBd
ICBmZmZmZmZmZjgxZTk2NzExIDAwMDAwMDAwMDAwMDAwMDcgMDAwMDAzNDAwMDAwMDM0MCAw
MDAwMDAwMDAwMDAwMDA4ClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODFlOTY3MTE+XSB4c3RhdGVfZW5hYmxlX2Jvb3RfY3B1KzB4MTc3
LzB4MWYyClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwMGMxM2Y+XSB4c2F2ZV9pbml0
KzB4MjYvMHgyOApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDBiMGMzPl0gZnB1X2lu
aXQrMHg5Ni8weDlkClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwMTEyNzI+XSBjcHVf
aW5pdCsweDJiYy8weDJmMwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTkyYjA2Pl0g
dHJhcF9pbml0KzB4NTQzLzB4NWViClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlOTBj
MmY+XSBzdGFydF9rZXJuZWwrMHgxZTIvMHgzZTYKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MWU5MDdjMj5dID8gc2V0X2luaXRfYXJnKzB4NTUvMHg1NQpbICAgIDAuMDAwMDAwXSAg
WzxmZmZmZmZmZjgxZTkwMTIwPl0gPyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAK
WyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5MDQ3MT5dIHg4Nl82NF9zdGFydF9yZXNl
cnZhdGlvbnMrMHgyYS8weDJjClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlOTA1NjE+
XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4ZWUvMHhmYgpbICAgIDAuMDAwMDAwXSBDb2RlOiBj
YyA0OCA4YiAxNSBkNyBiMyAwZCAwMCA0OCA2MyBjMyBmZiBjMyA4OSAwYyA4MiA0OCA4YiAx
NSBjMCBiMyAwZCAwMCA4YiA0ZCBjOCA4OSAwYyA4MiBlYiBiYyA4MyBjOCBmZiA0OCA4YiAz
ZCA5NiBiMyAwZCAwMCA4OSBjMiA8NDg+IDBmIGFlIDJmIDQ4IDhiIDNkIDg5IGIzIDBkIDAw
IDg5IGMyIDQ4IDBmIGFlIDI3IDU4IDVhIDViIDQxIApbICAgIDAuMDAwMDAwXSBSSVAgIFs8
ZmZmZmZmZmY4MWU5NjU3Yz5dIHNldHVwX2luaXRfZnB1X2J1ZisweDEwNC8weDEyMgpbICAg
IDAuMDAwMDAwXSAgUlNQIDxmZmZmZmZmZjgxYzAzZTMwPgpbICAgIDAuMDAwMDAwXSAtLS1b
IGVuZCB0cmFjZSA2MjkzZTQ0OTZhYjVjZTYxIF0tLS0KWyAgICAwLjAwMDAwMF0gS2VybmVs
IHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA3MTcwMjMzL2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3
NGFlODU5ZGEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTQ6MjAxNDA3MTcwOTM4MDg6eDg2XzY0
LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0wNTQ0MS1nYjk3M2ZkZjo0Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvYjk3M2ZkZjVlNmU2ZmU4NGI1
MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYS9kbWVzZy1xdWFudGFsLWtidWlsZC0xOToyMDE0MDcx
NzA5MzgwODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTA1NDQx
LWdiOTczZmRmOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9iOTcz
ZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2RtZXNnLXlvY3RvLWtidWls
ZC0xMDoyMDE0MDcxNzA5MzgwODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2
LjAtcmM1LTA1NDQxLWdiOTczZmRmOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzE3MDIzMy9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2RtZXNn
LXlvY3RvLWtidWlsZC0xMToyMDE0MDcxNzA5MzgwNzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzE3MDIzMzozLjE2LjAtcmM1LTA1NDQxLWdiOTczZmRmOjQKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzE3MDIzMy9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRh
ZTg1OWRhL2RtZXNnLXlvY3RvLWtidWlsZC0xMjoyMDE0MDcxNzA5MzgwNzp4ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTA1NDQxLWdiOTczZmRmOjQKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5
OTE5ZTVkYzg1NzRhZTg1OWRhL2RtZXNnLXlvY3RvLWtidWlsZC0yODoyMDE0MDcxNzA5Mzgw
Nzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTA1NDQxLWdiOTcz
ZmRmOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9iOTczZmRmNWU2
ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2RtZXNnLXlvY3RvLWtidWlsZC0zMDoy
MDE0MDcxNzA5MzgwOTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1
LTA1NDQxLWdiOTczZmRmOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIz
My9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2RtZXNnLXlvY3Rv
LWtidWlsZC04OjIwMTQwNzE3MDkzODA5Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMz
OjMuMTYuMC1yYzUtMDU0NDEtZ2I5NzNmZGY6NAo0NTo4OjggYWxsX2dvb2Q6YmFkOmFsbF9i
YWQgYm9vdHMKChtbMTszNW0yMDE0LTA3LTE3IDA5OjQwOjI2IGJhZCBiaXNlY3QsIHJldHJ5
IHdpdGggaW5jcmVhc2VkIHJlcGVhdCBjb3VudCAxMzUbWzBtClByZXZpb3VzIEhFQUQgcG9z
aXRpb24gd2FzIGI5NzNmZGYuLi4gTWVyZ2UgJ2x1dG8vc3luY19yYW5kX3NlZWQnIGludG8g
ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEKSEVBRCBpcyBub3cgYXQgNWU2MGMyYS4uLiAwZGF5
IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA3MTcwMScKZ2l0IGNoZWNrb3V0
IDE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWIKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxNzAxOjE3OTVjZDliM2E5MWQ0YjU0NzNj
OTdmNDkxZDYzODkyNDQyMjEyYWI6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNy0xNy0wOTo0MToz
NiAxNzk1Y2Q5YjNhOTFkNGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiIHJldXNlIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvMTc5NWNkOWIzYTkxZDRiNTQ3M2M5
N2Y0OTFkNjM4OTI0NDIyMTJhYi92bWxpbnV6LTMuMTYuMC1yYzUKCjIwMTQtMDctMTctMDk6
NDE6MzYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JOTcJMTM1IFNVQ0NFU1MKCmJpc2VjdDog
Z29vZCBjb21taXQgMTc5NWNkOWIzYTkxZDRiNTQ3M2M5N2Y0OTFkNjM4OTI0NDIyMTJhYgpn
aXQgYmlzZWN0IHN0YXJ0IDVlNjBjMmFmN2E4YmRlNWNmYWVlOGZmZDc3Y2ZjNWI2MmRiMGEw
NGUgMTc5NWNkOWIzYTkxZDRiNTQ3M2M5N2Y0OTFkNjM4OTI0NDIyMTJhYiAtLQovYy9rZXJu
ZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICI1ZTYwYzJhZjdhOGJkZTVjZmFlZThm
ZmQ3N2NmYzViNjJkYjBhMDRlIiwgIi1nIiwgIjE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkx
ZDYzODkyNDQyMjEyYWIiLCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCIsICIvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdCJdCkJpc2VjdGlu
ZzogNjM5NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMg
c3RlcHMpCltiYzFmMmY5M2Y2OGJjY2Q5ODhhZjdlNmY3MzM4NDg2MGFjMjQxYjc4XSBNZXJn
ZSAnc29jZnBnYS1uZXgvbmlvczItdXBzdHJlYW0nIGludG8gZGV2ZWwtaG91cmx5LTIwMTQw
NzE3MDEKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9saW51eC1k
ZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTpiYzFmMmY5M2Y2OGJjY2Q5ODhhZjdlNmY3
MzM4NDg2MGFjMjQxYjc4OmJpc2VjdC1saW51eDAKCjIwMTQtMDctMTctMDk6NDM6MzkgYmMx
ZjJmOTNmNjhiY2NkOTg4YWY3ZTZmNzMzODQ4NjBhYzI0MWI3OCByZXVzZSAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2JjMWYyZjkzZjY4YmNjZDk4OGFmN2U2Zjcz
Mzg0ODYwYWMyNDFiNzgvdm1saW51ei0zLjE2LjAtcmM1LTA1MDI1LWdiYzFmMmY5CgoyMDE0
LTA3LTE3LTA5OjQzOjM5IGRldGVjdGluZyBib290IHN0YXRlIC4JNDYJMTM0CTEzNSBTVUND
RVNTCgpCaXNlY3Rpbmc6IDEzNzIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDExIHN0ZXBzKQpbMGQ3ZTFjYTQwZWYxNmZjZTUyOTc1NzkxMjE3MTdmYzc5
Mzc2MWIzOF0gTWVyZ2UgJ2R5bnRpY2tzL25vaHovc3lzaWRsZScgaW50byBkZXZlbC1ob3Vy
bHktMjAxNDA3MTcwMQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMz
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxNzAxOjBkN2UxY2E0MGVmMTZmY2U1
Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzg6YmlzZWN0LWxpbnV4MAogVEVTVCBGQUlMVVJFClsg
ICAgMC4wMDAwMDBdIFBvbGljeSB6b25lOiBETUEzMgpbICAgIDAuMDAwMDAwXSBLZXJuZWwg
Y29tbWFuZCBsaW5lOiBodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUy
MDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5yY3Vf
Y3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlf
d2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAg
Y29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxNzAxOjBkN2UxY2E0MGVmMTZmY2U1Mjk3
NTc5MTIxNzE3ZmM3OTM3NjFiMzg6YmlzZWN0LWxpbnV4MC8udm1saW51ei0wZDdlMWNhNDBl
ZjE2ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYxYjM4LTIwMTQwNzE3MDYwODM0LTI3LWtidWls
ZCBicmFuY2g9bGludXgtZGV2ZWwvZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEgQk9PVF9JTUFH
RT0va2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLzBkN2UxY2E0MGVmMTZm
Y2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzgvdm1saW51ei0zLjE2LjAtcmM1LTA1NjExLWcw
ZDdlMWNhIGRyYmQubWlub3JfY291bnQ9OApbICAgIDAuMDAwMDAwXSBQSUQgaGFzaCB0YWJs
ZSBlbnRyaWVzOiAyMDQ4IChvcmRlcjogMiwgMTYzODQgYnl0ZXMpClsgICAgMC4wMDAwMDBd
IGdlbmVyYWwgcHJvdGVjdGlvbiBmYXVsdDogMDAwMCBbIzFdIFNNUCBERUJVR19QQUdFQUxM
T0MKWyAgICAwLjAwMDAwMF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4wMDAwMDBdIENQ
VTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE2LjAtcmM1LTA1NjEx
LWcwZDdlMWNhICMxClsgICAgMC4wMDAwMDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hz
LCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjAwMDAwMF0gdGFzazogZmZmZmZmZmY4
MWMxMDQ5MCB0aTogZmZmZmZmZmY4MWMwMDAwMCB0YXNrLnRpOiBmZmZmZmZmZjgxYzAwMDAw
ClsgICAgMC4wMDAwMDBdIFJJUDogMDAxMDpbPGZmZmZmZmZmODFlOTY1N2M+XSAgWzxmZmZm
ZmZmZjgxZTk2NTdjPl0gc2V0dXBfaW5pdF9mcHVfYnVmKzB4MTA0LzB4MTIyClsgICAgMC4w
MDAwMDBdIFJTUDogMDAwMDpmZmZmZmZmZjgxYzAzZTMwICBFRkxBR1M6IDAwMDEwMDg2Clsg
ICAgMC4wMDAwMDBdIFJBWDogMDAwMDAwMDBmZmZmZmZmZiBSQlg6IDAwMDAwMDAwMDAwMDAw
MDMgUkNYOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMDAwMDBdIFJEWDogMDAwMDAwMDBm
ZmZmZmZmZiBSU0k6IGZmZmZmZmZmODFjMDNlMzQgUkRJOiBmZmZmODgwMDEzZmY5MDAwClsg
ICAgMC4wMDAwMDBdIFJCUDogZmZmZmZmZmY4MWMwM2U2OCBSMDg6IDAwMDAwMDAwMDAwMDAw
NDAgUjA5OiBmZmZmZmZmZjgxYzAzZTM4ClsgICAgMC4wMDAwMDBdIFIxMDogZmZmZmZmZmY4
MWMwM2UzYyBSMTE6IDAwMDAwMDAwMDAwMDAwNDAgUjEyOiBmZmZmZmZmZjgxYzAzZTNjClsg
ICAgMC4wMDAwMDBdIFIxMzogZmZmZmZmZmY4MWMwM2UzOCBSMTQ6IGZmZmZmZmZmODFjMDNl
MzQgUjE1OiBmZmZmZmZmZjgxYzAzZTMwClsgICAgMC4wMDAwMDBdIEZTOiAgMDAwMDAwMDAw
MDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDExMDAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAw
MDAwMDAwMDAKWyAgICAwLjAwMDAwMF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENS
MDogMDAwMDAwMDA4MDA1MDAzMwpbICAgIDAuMDAwMDAwXSBDUjI6IGZmZmY4ODAwMTI3ZmYw
MDAgQ1IzOiAwMDAwMDAwMDAxYzBiMDAwIENSNDogMDAwMDAwMDAwMDA0MDZhMApbICAgIDAu
MDAwMDAwXSBTdGFjazoKWyAgICAwLjAwMDAwMF0gIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAw
MDAwMDAwMDAwMCBmZmZmZmZmZjgxYzAzZTgwIGZmZmZmZmZmODFjMDNlODQKWyAgICAwLjAw
MDAwMF0gIGZmZmZmZmZmODFjMDNlN2MgZmZmZmZmZmY4MWMwM2U3OCAwMDAwMDAwMDAwMDAw
MDAwIGZmZmZmZmZmODFjMDNlYTgKWyAgICAwLjAwMDAwMF0gIGZmZmZmZmZmODFlOTY3MTEg
MDAwMDAwMDAwMDAwMDAwNyAwMDAwMDM0MDAwMDAwMzQwIDAwMDAwMDAwMDAwMDAwMDgKWyAg
ICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5
NjcxMT5dIHhzdGF0ZV9lbmFibGVfYm9vdF9jcHUrMHgxNzcvMHgxZjIKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MTAwYzEzZj5dIHhzYXZlX2luaXQrMHgyNi8weDI4ClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODEwMGIwYzM+XSBmcHVfaW5pdCsweDk2LzB4OWQKWyAgICAw
LjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTAxMTI3Mj5dIGNwdV9pbml0KzB4MmJjLzB4MmYzClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlOTJiMDY+XSB0cmFwX2luaXQrMHg1NDMvMHg1
ZWIKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5MGMyZj5dIHN0YXJ0X2tlcm5lbCsw
eDFlMi8weDNlNgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTkwN2MyPl0gPyBzZXRf
aW5pdF9hcmcrMHg1NS8weDU1ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlOTAxMjA+
XSA/IGVhcmx5X2lkdF9oYW5kbGVycysweDEyMC8weDEyMApbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgxZTkwNDcxPl0geDg2XzY0X3N0YXJ0X3Jlc2VydmF0aW9ucysweDJhLzB4MmMK
WyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5MDU2MT5dIHg4Nl82NF9zdGFydF9rZXJu
ZWwrMHhlZS8weGZiClsgICAgMC4wMDAwMDBdIENvZGU6IGNjIDQ4IDhiIDE1IGQ3IGIzIDBk
IDAwIDQ4IDYzIGMzIGZmIGMzIDg5IDBjIDgyIDQ4IDhiIDE1IGMwIGIzIDBkIDAwIDhiIDRk
IGM4IDg5IDBjIDgyIGViIGJjIDgzIGM4IGZmIDQ4IDhiIDNkIDk2IGIzIDBkIDAwIDg5IGMy
IDw0OD4gMGYgYWUgMmYgNDggOGIgM2QgODkgYjMgMGQgMDAgODkgYzIgNDggMGYgYWUgMjcg
NTggNWEgNWIgNDEgClsgICAgMC4wMDAwMDBdIFJJUCAgWzxmZmZmZmZmZjgxZTk2NTdjPl0g
c2V0dXBfaW5pdF9mcHVfYnVmKzB4MTA0LzB4MTIyClsgICAgMC4wMDAwMDBdICBSU1AgPGZm
ZmZmZmZmODFjMDNlMzA+ClsgICAgMC4wMDAwMDBdIC0tLVsgZW5kIHRyYWNlIDM1YjBmOGI2
NjM4NjkxZDAgXS0tLQpbICAgIDAuMDAwMDAwXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2lu
ZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAy
MzMvMGQ3ZTFjYTQwZWYxNmZjZTUyOTc1NzkxMjE3MTdmYzc5Mzc2MWIzOC9kbWVzZy1xdWFu
dGFsLWtidWlsZC0xNzoyMDE0MDcxNzA2MDcxNTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3
MDIzMzozLjE2LjAtcmM1LTA1NjExLWcwZDdlMWNhOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMy8wZDdlMWNhNDBlZjE2ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYx
YjM4L2RtZXNnLXF1YW50YWwta2J1aWxkLTIyOjIwMTQwNzE3MDYwNzI0Ong4Nl82NC1yYW5k
Y29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDU2MTEtZzBkN2UxY2E6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5
MTIxNzE3ZmM3OTM3NjFiMzgvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjU6MjAxNDA3MTcwNjA3
MTM6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0wNTYxMS1nMGQ3
ZTFjYToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvMGQ3ZTFjYTQw
ZWYxNmZjZTUyOTc1NzkxMjE3MTdmYzc5Mzc2MWIzOC9kbWVzZy1xdWFudGFsLWtidWlsZC0y
OjIwMTQwNzE3MDYwNzMwOng4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1y
YzUtMDU2MTEtZzBkN2UxY2E6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcw
MjMzLzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzgvZG1lc2cteW9j
dG8ta2J1aWxkLTEzOjIwMTQwNzE3MDYwNzI5Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcw
MjMzOjMuMTYuMC1yYzUtMDU2MTEtZzBkN2UxY2E6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTA3MTcwMjMzLzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFi
MzgvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjU6MjAxNDA3MTcwNjA3MjQ6eDg2XzY0LXJhbmRj
b25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0wNTYxMS1nMGQ3ZTFjYToxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvMGQ3ZTFjYTQwZWYxNmZjZTUyOTc1Nzkx
MjE3MTdmYzc5Mzc2MWIzOC9kbWVzZy15b2N0by1rYnVpbGQtNjoyMDE0MDcxNzA2MDcyNDp4
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTA1NjExLWcwZDdlMWNh
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy8wZDdlMWNhNDBlZjE2
ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYxYjM4L2RtZXNnLXF1YW50YWwta2J1aWxkLTc6MjAx
NDA3MTcwNjA3MjM6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0w
NTYxMS1nMGQ3ZTFjYToxCjM3Ojg6OCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlz
ZWN0aW5nOiA1ODYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDEwIHN0ZXBzKQpbMzNjMTNiZjI0ODdhNDJlZmExYWM5YmNjZTU2MjNhYjc0YTM3NWM5M10g
TWVyZ2UgJ3ViaWZzL2xpbnV4LW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9saW51eC1kZXZlbDpk
ZXZlbC1ob3VybHktMjAxNDA3MTcwMTozM2MxM2JmMjQ4N2E0MmVmYTFhYzliY2NlNTYyM2Fi
NzRhMzc1YzkzOmJpc2VjdC1saW51eDAKCjIwMTQtMDctMTctMDk6NDU6NDYgMzNjMTNiZjI0
ODdhNDJlZmExYWM5YmNjZTU2MjNhYjc0YTM3NWM5MyByZXVzZSAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA3MTcwMjMzLzMzYzEzYmYyNDg3YTQyZWZhMWFjOWJjY2U1NjIzYWI3
NGEzNzVjOTMvdm1saW51ei0zLjE2LjAtcmM1LTA1MjI3LWczM2MxM2JmCgoyMDE0LTA3LTE3
LTA5OjQ1OjQ2IGRldGVjdGluZyBib290IHN0YXRlIC4uCTEzNAkxMzUgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAzODQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDkgc3RlcHMpClsxMDMyZjczYTMyOTUxZDdmMTRlZDdmZGFkZWRiMGZlZjNjNmQwZjQ5XSBN
ZXJnZSAnc3BpL2Zvci1uZXh0JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDcxNzAxCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvbGludXgtZGV2ZWw6ZGV2ZWwt
aG91cmx5LTIwMTQwNzE3MDE6MTAzMmY3M2EzMjk1MWQ3ZjE0ZWQ3ZmRhZGVkYjBmZWYzYzZk
MGY0OTpiaXNlY3QtbGludXgwCgoyMDE0LTA3LTE3LTA5OjQ4OjI5IDEwMzJmNzNhMzI5NTFk
N2YxNGVkN2ZkYWRlZGIwZmVmM2M2ZDBmNDkgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMy8xMDMyZjczYTMyOTUxZDdmMTRlZDdmZGFkZWRiMGZlZjNjNmQw
ZjQ5L3ZtbGludXotMy4xNi4wLXJjNS0wNTM3Ni1nMTAzMmY3MwoKMjAxNC0wNy0xNy0wOTo0
ODoyOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMTE2CTEzNSBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDIzMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBz
dGVwcykKWzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTFdIE1lcmdl
ICdzaGF3bmd1by9mb3ItbmV4dCcgaW50byBkZXZlbC1ob3VybHktMjAxNDA3MTcwMQpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2xpbnV4LWRldmVsOmRldmVs
LWhvdXJseS0yMDE0MDcxNzAxOjFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYx
YjU0OTE6YmlzZWN0LWxpbnV4MAogVEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBdIFBvbGlj
eSB6b25lOiBETUEzMgpbICAgIDAuMDAwMDAwXSBLZXJuZWwgY29tbWFuZCBsaW5lOiBodW5n
X3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1
ZyBzeXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9
MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHBy
b21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1u
b3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDcxNzAxOjFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0
OTE6YmlzZWN0LWxpbnV4MC8udm1saW51ei0xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThh
NWIyYTJmMWI1NDkxLTIwMTQwNzE3MTUyMjQxLTkta2J1aWxkIGJyYW5jaD1saW51eC1kZXZl
bC9kZXZlbC1ob3VybHktMjAxNDA3MTcwMSBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczAtMDcxNzAyMzMvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEy
ZjFiNTQ5MS92bWxpbnV6LTMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWYgZHJiZC5taW5vcl9j
b3VudD04ClsgICAgMC4wMDAwMDBdIFBJRCBoYXNoIHRhYmxlIGVudHJpZXM6IDIwNDggKG9y
ZGVyOiAyLCAxNjM4NCBieXRlcykKWyAgICAwLjAwMDAwMF0gZ2VuZXJhbCBwcm90ZWN0aW9u
IGZhdWx0OiAwMDAwIFsjMV0gU01QIERFQlVHX1BBR0VBTExPQwpbICAgIDAuMDAwMDAwXSBN
b2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBz
d2FwcGVyIE5vdCB0YWludGVkIDMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWYgIzIKWyAgICAw
LjAwMDAwMF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEv
MjAxMQpbICAgIDAuMDAwMDAwXSB0YXNrOiBmZmZmZmZmZjgxYzEwNDkwIHRpOiBmZmZmZmZm
ZjgxYzAwMDAwIHRhc2sudGk6IGZmZmZmZmZmODFjMDAwMDAKWyAgICAwLjAwMDAwMF0gUklQ
OiAwMDEwOls8ZmZmZmZmZmY4MWU5NjU3Yz5dICBbPGZmZmZmZmZmODFlOTY1N2M+XSBzZXR1
cF9pbml0X2ZwdV9idWYrMHgxMDQvMHgxMjIKWyAgICAwLjAwMDAwMF0gUlNQOiAwMDAwOmZm
ZmZmZmZmODFjMDNlMzAgIEVGTEFHUzogMDAwMTAwODYKWyAgICAwLjAwMDAwMF0gUkFYOiAw
MDAwMDAwMGZmZmZmZmZmIFJCWDogMDAwMDAwMDAwMDAwMDAwMyBSQ1g6IDAwMDAwMDAwMDAw
MDAwMDAKWyAgICAwLjAwMDAwMF0gUkRYOiAwMDAwMDAwMGZmZmZmZmZmIFJTSTogZmZmZmZm
ZmY4MWMwM2UzNCBSREk6IGZmZmY4ODAwMTNmZjkwMDAKWyAgICAwLjAwMDAwMF0gUkJQOiBm
ZmZmZmZmZjgxYzAzZTY4IFIwODogMDAwMDAwMDAwMDAwMDA0MCBSMDk6IGZmZmZmZmZmODFj
MDNlMzgKWyAgICAwLjAwMDAwMF0gUjEwOiBmZmZmZmZmZjgxYzAzZTNjIFIxMTogMDAwMDAw
MDAwMDAwMDA0MCBSMTI6IGZmZmZmZmZmODFjMDNlM2MKWyAgICAwLjAwMDAwMF0gUjEzOiBm
ZmZmZmZmZjgxYzAzZTM4IFIxNDogZmZmZmZmZmY4MWMwM2UzNCBSMTU6IGZmZmZmZmZmODFj
MDNlMzAKWyAgICAwLjAwMDAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZm
ZmY4ODAwMTEwMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDAw
MDAwXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMz
ClsgICAgMC4wMDAwMDBdIENSMjogZmZmZjg4MDAxMjdmZjAwMCBDUjM6IDAwMDAwMDAwMDFj
MGIwMDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmEwClsgICAgMC4wMDAwMDBdIFN0YWNrOgpbICAg
IDAuMDAwMDAwXSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZm
ODFjMDNlODAgZmZmZmZmZmY4MWMwM2U4NApbICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4MWMw
M2U3YyBmZmZmZmZmZjgxYzAzZTc4IDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MWMwM2Vh
OApbICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4MWU5NjcxMSAwMDAwMDAwMDAwMDAwMDA3IDAw
MDAwMzQwMDAwMDAzNDAgMDAwMDAwMDAwMDAwMDAwOApbICAgIDAuMDAwMDAwXSBDYWxsIFRy
YWNlOgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTk2NzExPl0geHN0YXRlX2VuYWJs
ZV9ib290X2NwdSsweDE3Ny8weDFmMgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDBj
MTNmPl0geHNhdmVfaW5pdCsweDI2LzB4MjgKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MTAwYjBjMz5dIGZwdV9pbml0KzB4OTYvMHg5ZApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZm
ZjgxMDExMjcyPl0gY3B1X2luaXQrMHgyYmMvMHgyZjMKWyAgICAwLjAwMDAwMF0gIFs8ZmZm
ZmZmZmY4MWU5MmIwNj5dIHRyYXBfaW5pdCsweDU0My8weDVlYgpbICAgIDAuMDAwMDAwXSAg
WzxmZmZmZmZmZjgxZTkwYzJmPl0gc3RhcnRfa2VybmVsKzB4MWUyLzB4M2U2ClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODFlOTA3YzI+XSA/IHNldF9pbml0X2FyZysweDU1LzB4NTUK
WyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5MDEyMD5dID8gZWFybHlfaWR0X2hhbmRs
ZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlOTA0NzE+XSB4
ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4MmEvMHgyYwpbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgxZTkwNTYxPl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweGVlLzB4ZmIKWyAgICAw
LjAwMDAwMF0gQ29kZTogY2MgNDggOGIgMTUgZDcgYjMgMGQgMDAgNDggNjMgYzMgZmYgYzMg
ODkgMGMgODIgNDggOGIgMTUgYzAgYjMgMGQgMDAgOGIgNGQgYzggODkgMGMgODIgZWIgYmMg
ODMgYzggZmYgNDggOGIgM2QgOTYgYjMgMGQgMDAgODkgYzIgPDQ4PiAwZiBhZSAyZiA0OCA4
YiAzZCA4OSBiMyAwZCAwMCA4OSBjMiA0OCAwZiBhZSAyNyA1OCA1YSA1YiA0MSAKWyAgICAw
LjAwMDAwMF0gUklQICBbPGZmZmZmZmZmODFlOTY1N2M+XSBzZXR1cF9pbml0X2ZwdV9idWYr
MHgxMDQvMHgxMjIKWyAgICAwLjAwMDAwMF0gIFJTUCA8ZmZmZmZmZmY4MWMwM2UzMD4KWyAg
ICAwLjAwMDAwMF0gLS0tWyBlbmQgdHJhY2UgNTZjNzBlNzcwNzBhMzMwNCBdLS0tClsgICAg
MC4wMDAwMDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24K
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy8xZjI4NTlmMDc4NjMzOGZl
NGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXF1YW50YWwta2J1aWxkLTEwOjIwMTQw
NzE3MDcyMDIyOng4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDU1
NjctZzFmMjg1OWY6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLzFm
Mjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2ctcXVhbnRhbC1r
YnVpbGQtMTM6MjAxNDA3MTcwNzIwMjI6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6
My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZjoyCjQzOjI6MiBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwobWzE7MzVtMjAxNC0wNy0xNyAwOTo1MTowMSBSRVBFQVQgQ09VTlQ6IDIzNSAg
IyAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0
aW5nOiAxOTEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDgg
c3RlcHMpCls3M2M0NzY4OGEwMzkxNThhNmQzOTU2MjlkM2FiMzJlNjA2ZTEzZDFhXSBNZXJn
ZSAncmVndWxhdG9yL2Zvci1uZXh0JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDcxNzAxCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9i
b290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwNzE3MDE6NzNjNDc2ODhhMDM5MTU4YTZkMzk1NjI5ZDNhYjMyZTYw
NmUxM2QxYTpiaXNlY3QtbGludXgwCgoyMDE0LTA3LTE3LTA5OjUxOjAyIDczYzQ3Njg4YTAz
OTE1OGE2ZDM5NTYyOWQzYWIzMmU2MDZlMTNkMWEgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzE3MDIzMy83M2M0NzY4OGEwMzkxNThhNmQzOTU2MjlkM2FiMzJlNjA2
ZTEzZDFhL3ZtbGludXotMy4xNi4wLXJjNS0wNTQzNi1nNzNjNDc2OAoKMjAxNC0wNy0xNy0w
OTo1MTowMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxMTAJMjM1IFNVQ0NFU1MKCkJpc2Vj
dGluZzogMTMxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4
IHN0ZXBzKQpbYjk3M2ZkZjVlNmU2ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYV0gTWVy
Z2UgJ2x1dG8vc3luY19yYW5kX3NlZWQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9saW51eC1kZXZlbDpk
ZXZlbC1ob3VybHktMjAxNDA3MTcwMTpiOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1
NzRhZTg1OWRhOmJpc2VjdC1saW51eDAKIFRFU1QgRkFJTFVSRQpbICAgIDAuMDAwMDAwXSBQ
b2xpY3kgem9uZTogRE1BMzIKWyAgICAwLjAwMDAwMF0gS2VybmVsIGNvbW1hbmQgbGluZTog
aHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9
ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1l
b3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmlj
ICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2
Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9saW51eC1kZXZlbDpkZXZl
bC1ob3VybHktMjAxNDA3MTcwMTpiOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRh
ZTg1OWRhOmJpc2VjdC1saW51eDAvLnZtbGludXotYjk3M2ZkZjVlNmU2ZmU4NGI1MWY3OTkx
OWU1ZGM4NTc0YWU4NTlkYS0yMDE0MDcxNzA5Mzk1Ni00MC1rYnVpbGQgYnJhbmNoPWxpbnV4
LWRldmVsL2RldmVsLWhvdXJseS0yMDE0MDcxNzAxIEJPT1RfSU1BR0U9L2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVk
Yzg1NzRhZTg1OWRhL3ZtbGludXotMy4xNi4wLXJjNS0wNTQ0MS1nYjk3M2ZkZiBkcmJkLm1p
bm9yX2NvdW50PTgKWyAgICAwLjAwMDAwMF0gUElEIGhhc2ggdGFibGUgZW50cmllczogMjA0
OCAob3JkZXI6IDIsIDE2Mzg0IGJ5dGVzKQpbICAgIDAuMDAwMDAwXSBnZW5lcmFsIHByb3Rl
Y3Rpb24gZmF1bHQ6IDAwMDAgWyMxXSBTTVAgREVCVUdfUEFHRUFMTE9DClsgICAgMC4wMDAw
MDBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENv
bW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNi4wLXJjNS0wNTQ0MS1nYjk3M2ZkZiAjNApb
ICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAw
MS8wMS8yMDExClsgICAgMC4wMDAwMDBdIHRhc2s6IGZmZmZmZmZmODFjMTA0OTAgdGk6IGZm
ZmZmZmZmODFjMDAwMDAgdGFzay50aTogZmZmZmZmZmY4MWMwMDAwMApbICAgIDAuMDAwMDAw
XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxZTk2NTdjPl0gIFs8ZmZmZmZmZmY4MWU5NjU3Yz5d
IHNldHVwX2luaXRfZnB1X2J1ZisweDEwNC8weDEyMgpbICAgIDAuMDAwMDAwXSBSU1A6IDAw
MDA6ZmZmZmZmZmY4MWMwM2UzMCAgRUZMQUdTOiAwMDAxMDA4NgpbICAgIDAuMDAwMDAwXSBS
QVg6IDAwMDAwMDAwZmZmZmZmZmYgUkJYOiAwMDAwMDAwMDAwMDAwMDAzIFJDWDogMDAwMDAw
MDAwMDAwMDAwMApbICAgIDAuMDAwMDAwXSBSRFg6IDAwMDAwMDAwZmZmZmZmZmYgUlNJOiBm
ZmZmZmZmZjgxYzAzZTM0IFJESTogZmZmZjg4MDAxM2ZmOTAwMApbICAgIDAuMDAwMDAwXSBS
QlA6IGZmZmZmZmZmODFjMDNlNjggUjA4OiAwMDAwMDAwMDAwMDAwMDQwIFIwOTogZmZmZmZm
ZmY4MWMwM2UzOApbICAgIDAuMDAwMDAwXSBSMTA6IGZmZmZmZmZmODFjMDNlM2MgUjExOiAw
MDAwMDAwMDAwMDAwMDQwIFIxMjogZmZmZmZmZmY4MWMwM2UzYwpbICAgIDAuMDAwMDAwXSBS
MTM6IGZmZmZmZmZmODFjMDNlMzggUjE0OiBmZmZmZmZmZjgxYzAzZTM0IFIxNTogZmZmZmZm
ZmY4MWMwM2UzMApbICAgIDAuMDAwMDAwXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkg
R1M6ZmZmZjg4MDAxMTAwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAg
MC4wMDAwMDBdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAw
NTAwMzMKWyAgICAwLjAwMDAwMF0gQ1IyOiBmZmZmODgwMDEyN2ZmMDAwIENSMzogMDAwMDAw
MDAwMWMwYjAwMCBDUjQ6IDAwMDAwMDAwMDAwNDA2YTAKWyAgICAwLjAwMDAwMF0gU3RhY2s6
ClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZm
ZmZmZmY4MWMwM2U4MCBmZmZmZmZmZjgxYzAzZTg0ClsgICAgMC4wMDAwMDBdICBmZmZmZmZm
ZjgxYzAzZTdjIGZmZmZmZmZmODFjMDNlNzggMDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgx
YzAzZWE4ClsgICAgMC4wMDAwMDBdICBmZmZmZmZmZjgxZTk2NzExIDAwMDAwMDAwMDAwMDAw
MDcgMDAwMDAzNDAwMDAwMDM0MCAwMDAwMDAwMDAwMDAwMDA4ClsgICAgMC4wMDAwMDBdIENh
bGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlOTY3MTE+XSB4c3RhdGVf
ZW5hYmxlX2Jvb3RfY3B1KzB4MTc3LzB4MWYyClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODEwMGMxM2Y+XSB4c2F2ZV9pbml0KzB4MjYvMHgyOApbICAgIDAuMDAwMDAwXSAgWzxmZmZm
ZmZmZjgxMDBiMGMzPl0gZnB1X2luaXQrMHg5Ni8weDlkClsgICAgMC4wMDAwMDBdICBbPGZm
ZmZmZmZmODEwMTEyNzI+XSBjcHVfaW5pdCsweDJiYy8weDJmMwpbICAgIDAuMDAwMDAwXSAg
WzxmZmZmZmZmZjgxZTkyYjA2Pl0gdHJhcF9pbml0KzB4NTQzLzB4NWViClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODFlOTBjMmY+XSBzdGFydF9rZXJuZWwrMHgxZTIvMHgzZTYKWyAg
ICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5MDdjMj5dID8gc2V0X2luaXRfYXJnKzB4NTUv
MHg1NQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTkwMTIwPl0gPyBlYXJseV9pZHRf
aGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5MDQ3
MT5dIHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMrMHgyYS8weDJjClsgICAgMC4wMDAwMDBd
ICBbPGZmZmZmZmZmODFlOTA1NjE+XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4ZWUvMHhmYgpb
ICAgIDAuMDAwMDAwXSBDb2RlOiBjYyA0OCA4YiAxNSBkNyBiMyAwZCAwMCA0OCA2MyBjMyBm
ZiBjMyA4OSAwYyA4MiA0OCA4YiAxNSBjMCBiMyAwZCAwMCA4YiA0ZCBjOCA4OSAwYyA4MiBl
YiBiYyA4MyBjOCBmZiA0OCA4YiAzZCA5NiBiMyAwZCAwMCA4OSBjMiA8NDg+IDBmIGFlIDJm
IDQ4IDhiIDNkIDg5IGIzIDBkIDAwIDg5IGMyIDQ4IDBmIGFlIDI3IDU4IDVhIDViIDQxIApb
ICAgIDAuMDAwMDAwXSBSSVAgIFs8ZmZmZmZmZmY4MWU5NjU3Yz5dIHNldHVwX2luaXRfZnB1
X2J1ZisweDEwNC8weDEyMgpbICAgIDAuMDAwMDAwXSAgUlNQIDxmZmZmZmZmZjgxYzAzZTMw
PgpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSA2MjkzZTQ0OTZhYjVjZTYxIF0tLS0K
WyAgICAwLjAwMDAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2Vw
dGlvbgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2I5NzNmZGY1ZTZl
NmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEvZG1lc2cteW9jdG8ta2J1aWxkLTI4OjIw
MTQwNzE3MDkzODA3Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUt
MDU0NDEtZ2I5NzNmZGY6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMz
L2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEvZG1lc2cteW9jdG8t
a2J1aWxkLTEwOjIwMTQwNzE3MDkzODA4Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMz
OjMuMTYuMC1yYzUtMDU0NDEtZ2I5NzNmZGY6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTA3MTcwMjMzL2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEv
ZG1lc2cteW9jdG8ta2J1aWxkLTExOjIwMTQwNzE3MDkzODA3Ong4Nl82NC1yYW5kY29uZmln
LXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDU0NDEtZ2I5NzNmZGY6NAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRj
ODU3NGFlODU5ZGEvZG1lc2cteW9jdG8ta2J1aWxkLTMwOjIwMTQwNzE3MDkzODA5Ong4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDU0NDEtZ2I5NzNmZGY6NAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2I5NzNmZGY1ZTZlNmZlODRi
NTFmNzk5MTllNWRjODU3NGFlODU5ZGEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTQ6MjAxNDA3
MTcwOTM4MDg6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0wNTQ0
MS1nYjk3M2ZkZjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvYjk3
M2ZkZjVlNmU2ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYS9kbWVzZy1xdWFudGFsLWti
dWlsZC0xOToyMDE0MDcxNzA5MzgwODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzoz
LjE2LjAtcmM1LTA1NDQxLWdiOTczZmRmOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzE3MDIzMy9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2Rt
ZXNnLXlvY3RvLWtidWlsZC0xMjoyMDE0MDcxNzA5MzgwNzp4ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzE3MDIzMzozLjE2LjAtcmM1LTA1NDQxLWdiOTczZmRmOjQKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1
NzRhZTg1OWRhL2RtZXNnLXlvY3RvLWtidWlsZC04OjIwMTQwNzE3MDkzODA5Ong4Nl82NC1y
YW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDU0NDEtZ2I5NzNmZGY6NAoxMjc6
ODo4IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJh
bmNoIG1heSBiZSBsdXRvL3N5bmNfcmFuZF9zZWVkCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBv
dmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCBiOTcz
ZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhIDczYzQ3Njg4YTAzOTE1OGE2
ZDM5NTYyOWQzYWIzMmU2MDZlMTNkMWEgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMg
Yjk3M2ZkZi4uLiBNZXJnZSAnbHV0by9zeW5jX3JhbmRfc2VlZCcgaW50byBkZXZlbC1ob3Vy
bHktMjAxNDA3MTcwMQpIRUFEIGlzIG5vdyBhdCBlMjQ0N2M1Li4uIE1lcmdlICdjcnlwdG9k
ZXYvbWFzdGVyJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDYyNzEzCkJpc2VjdGluZzogMiBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbNTc3
OGU2NWQ1Y2E1MmJlYmJhYTAyM2UxNzdkODYzZTQ0ZjA5OGU5Nl0gcmFuZG9tLHg4NjogQWRk
IGFyY2hfZ2V0X3Nsb3dfcm5nX3U2NApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4MC9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczAt
MDcxNzAyMzMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6NTc3OGU2NWQ1
Y2E1MmJlYmJhYTAyM2UxNzdkODYzZTQ0ZjA5OGU5NjpiaXNlY3QtbGludXgwCgoyMDE0LTA3
LTE3LTA5OjUzOjE3IDU3NzhlNjVkNWNhNTJiZWJiYWEwMjNlMTc3ZDg2M2U0NGYwOThlOTYg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMtNTc3OGU2NWQ1Y2E1MmJlYmJhYTAy
M2UxNzdkODYzZTQ0ZjA5OGU5NgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczAtMDcxNzAyMzMvNTc3OGU2NWQ1Y2E1MmJlYmJhYTAyM2UxNzdkODYz
ZTQ0ZjA5OGU5Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMtNTc3OGU2NWQ1Y2E1MmJl
YmJhYTAyM2UxNzdkODYzZTQ0ZjA5OGU5Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iLXNtb2tlL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA3MTcwMjMzLTU3NzhlNjVkNWNhNTJiZWJiYWEwMjNlMTc3ZDg2M2U0NGYwOThlOTYKa2Vy
bmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLzU3NzhlNjVkNWNh
NTJiZWJiYWEwMjNlMTc3ZDg2M2U0NGYwOThlOTYvdm1saW51ei0zLjE2LjAtcmM1LTAwMDAy
LWc1Nzc4ZTY1CgoyMDE0LTA3LTE3LTEwOjEwOjE3IGRldGVjdGluZyBib290IHN0YXRlIC4J
MTMuCTY0CTY4CTgzCTExOAkxMjYJMTc0CTE3OQkyMDgJMjM1IFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVw
KQpbZDA3YzdmMWVkNjE3ODllMTc1ZmE5NzUxMzQ4NTViZTMyMjYzYmUyY10geDg2LGthc2xy
OiBVc2UgTVNSX0tWTV9HRVRfUk5HX1NFRUQgZm9yIEtBU0xSIGlmIGF2YWlsYWJsZQpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2xpbnV4LWRldmVsOmRldmVs
LWhvdXJseS0yMDE0MDcxNzAxOmQwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2
M2JlMmM6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNy0xNy0xMDoxNzozNSBkMDdjN2YxZWQ2MTc4
OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3
MTcwMjMzLWQwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2Qw
N2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXMwLTA3MTcwMjMzLWQwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xr
cC1oc3gwMS1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy1kMDdjN2Yx
ZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjCmtlcm5lbDogL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1
NWJlMzIyNjNiZTJjL3ZtbGludXotMy4xNi4wLXJjNS0wMDAwNC1nZDA3YzdmMQoKMjAxNC0w
Ny0xNy0xMDoyMjozNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAg
IDAuMDAwMDAwXSBQb2xpY3kgem9uZTogRE1BMzIKWyAgICAwLjAwMDAwMF0gS2VybmVsIGNv
bW1hbmQgbGluZTogaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAw
IGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2Nw
dV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dh
dGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNv
bnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTpkMDdjN2YxZWQ2MTc4OWUxNzVmYTk3
NTEzNDg1NWJlMzIyNjNiZTJjOmJpc2VjdC1saW51eDAvLnZtbGludXotZDA3YzdmMWVkNjE3
ODllMTc1ZmE5NzUxMzQ4NTViZTMyMjYzYmUyYy0yMDE0MDcxNzE4MjIzNi0xMzQta2J1aWxk
IGJyYW5jaD1saW51eC1kZXZlbC9kZXZlbC1ob3VybHktMjAxNDA3MTcwMSBCT09UX0lNQUdF
PS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvZDA3YzdmMWVkNjE3ODll
MTc1ZmE5NzUxMzQ4NTViZTMyMjYzYmUyYy92bWxpbnV6LTMuMTYuMC1yYzUtMDAwMDQtZ2Qw
N2M3ZjEgZHJiZC5taW5vcl9jb3VudD04ClsgICAgMC4wMDAwMDBdIFBJRCBoYXNoIHRhYmxl
IGVudHJpZXM6IDIwNDggKG9yZGVyOiAyLCAxNjM4NCBieXRlcykKWyAgICAwLjAwMDAwMF0g
Z2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0OiAwMDAwIFsjMV0gU01QIERFQlVHX1BBR0VBTExP
QwpbICAgIDAuMDAwMDAwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjAwMDAwMF0gQ1BV
OiAwIFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTYuMC1yYzUtMDAwMDQt
Z2QwN2M3ZjEgIzEKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMs
IEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDAwMDAwXSB0YXNrOiBmZmZmZmZmZjgx
YzEwNDkwIHRpOiBmZmZmZmZmZjgxYzAwMDAwIHRhc2sudGk6IGZmZmZmZmZmODFjMDAwMDAK
WyAgICAwLjAwMDAwMF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MWU5NzU3Yz5dICBbPGZmZmZm
ZmZmODFlOTc1N2M+XSBzZXR1cF9pbml0X2ZwdV9idWYrMHgxMDQvMHgxMjIKWyAgICAwLjAw
MDAwMF0gUlNQOiAwMDAwOmZmZmZmZmZmODFjMDNlMzAgIEVGTEFHUzogMDAwMTAwODYKWyAg
ICAwLjAwMDAwMF0gUkFYOiAwMDAwMDAwMGZmZmZmZmZmIFJCWDogMDAwMDAwMDAwMDAwMDAw
MyBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAwMDAwMF0gUkRYOiAwMDAwMDAwMGZm
ZmZmZmZmIFJTSTogZmZmZmZmZmY4MWMwM2UzNCBSREk6IGZmZmY4ODAwMTNmZjkwMDAKWyAg
ICAwLjAwMDAwMF0gUkJQOiBmZmZmZmZmZjgxYzAzZTY4IFIwODogMDAwMDAwMDAwMDAwMDA0
MCBSMDk6IGZmZmZmZmZmODFjMDNlMzgKWyAgICAwLjAwMDAwMF0gUjEwOiBmZmZmZmZmZjgx
YzAzZTNjIFIxMTogMDAwMDAwMDAwMDAwMDA0MCBSMTI6IGZmZmZmZmZmODFjMDNlM2MKWyAg
ICAwLjAwMDAwMF0gUjEzOiBmZmZmZmZmZjgxYzAzZTM4IFIxNDogZmZmZmZmZmY4MWMwM2Uz
NCBSMTU6IGZmZmZmZmZmODFjMDNlMzAKWyAgICAwLjAwMDAwMF0gRlM6ICAwMDAwMDAwMDAw
MDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMTEwMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAw
MDAwMDAwMApbICAgIDAuMDAwMDAwXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1Iw
OiAwMDAwMDAwMDgwMDUwMDMzClsgICAgMC4wMDAwMDBdIENSMjogZmZmZjg4MDAxMjdmZjAw
MCBDUjM6IDAwMDAwMDAwMDFjMGIwMDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmEwClsgICAgMC4w
MDAwMDBdIFN0YWNrOgpbICAgIDAuMDAwMDAwXSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAw
MDAwMDAwMDAwIGZmZmZmZmZmODFjMDNlODAgZmZmZmZmZmY4MWMwM2U4NApbICAgIDAuMDAw
MDAwXSAgZmZmZmZmZmY4MWMwM2U3YyBmZmZmZmZmZjgxYzAzZTc4IDAwMDAwMDAwMDAwMDAw
MDAgZmZmZmZmZmY4MWMwM2VhOApbICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4MWU5NzcxMSAw
MDAwMDAwMDAwMDAwMDA3IDAwMDAwMzQwMDAwMDAzNDAgMDAwMDAwMDAwMDAwMDAwOApbICAg
IDAuMDAwMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTk3
NzExPl0geHN0YXRlX2VuYWJsZV9ib290X2NwdSsweDE3Ny8weDFmNgpbICAgIDAuMDAwMDAw
XSAgWzxmZmZmZmZmZjgxMDBjMTNlPl0geHNhdmVfaW5pdCsweDI2LzB4MjgKWyAgICAwLjAw
MDAwMF0gIFs8ZmZmZmZmZmY4MTAwYjBjMj5dIGZwdV9pbml0KzB4OTYvMHg5ZApbICAgIDAu
MDAwMDAwXSAgWzxmZmZmZmZmZjgxMDExMWU5Pl0gY3B1X2luaXQrMHgyYmMvMHgyZjMKWyAg
ICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5M2IwNj5dIHRyYXBfaW5pdCsweDU0My8weDVl
YgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTkxYzJmPl0gc3RhcnRfa2VybmVsKzB4
MWUyLzB4M2U2ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlOTE3YzI+XSA/IHNldF9p
bml0X2FyZysweDU1LzB4NTUKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5MTEyMD5d
ID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wMDAwMDBdICBbPGZm
ZmZmZmZmODFlOTE0NzE+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4MmEvMHgyYwpb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTkxNTYxPl0geDg2XzY0X3N0YXJ0X2tlcm5l
bCsweGVlLzB4ZmIKWyAgICAwLjAwMDAwMF0gQ29kZTogY2MgNDggOGIgMTUgZDcgYTMgMGQg
MDAgNDggNjMgYzMgZmYgYzMgODkgMGMgODIgNDggOGIgMTUgYzAgYTMgMGQgMDAgOGIgNGQg
YzggODkgMGMgODIgZWIgYmMgODMgYzggZmYgNDggOGIgM2QgOTYgYTMgMGQgMDAgODkgYzIg
PDQ4PiAwZiBhZSAyZiA0OCA4YiAzZCA4OSBhMyAwZCAwMCA4OSBjMiA0OCAwZiBhZSAyNyA1
OCA1YSA1YiA0MSAKWyAgICAwLjAwMDAwMF0gUklQICBbPGZmZmZmZmZmODFlOTc1N2M+XSBz
ZXR1cF9pbml0X2ZwdV9idWYrMHgxMDQvMHgxMjIKWyAgICAwLjAwMDAwMF0gIFJTUCA8ZmZm
ZmZmZmY4MWMwM2UzMD4KWyAgICAwLjAwMDAwMF0gLS0tWyBlbmQgdHJhY2UgNDhiZjM4MWRh
MmZiOTVlYSBdLS0tClsgICAgMC4wMDAwMDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5n
OiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIz
My9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXF1YW50
YWwta2J1aWxkLTE4OjIwMTQwNzE3MTAyMDE3Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcw
MjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2Jl
MmMvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMToyMDE0MDcxNzEwMjAxNzp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEz
NDg1NWJlMzIyNjNiZTJjL2RtZXNnLXF1YW50YWwta2J1aWxkLTI0OjIwMTQwNzE3MTAyMDE4
Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3
ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYx
Nzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2cteW9jdG8ta2J1aWxkLTEyOjIw
MTQwNzE3MTAyMDE3Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUt
MDAwMDQtZ2QwN2M3ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMz
L2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2cteW9jdG8t
a2J1aWxkLTI0OjIwMTQwNzE3MTAyMDE3Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMz
OjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMv
ZG1lc2cteW9jdG8ta2J1aWxkLTMxOjIwMTQwNzE3MTAyMDE4Ong4Nl82NC1yYW5kY29uZmln
LXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1
YmUzMjI2M2JlMmMvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTg6MjAxNDA3MTcxMDIwMzI6eDg2
XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0wMDAwNC1nZDA3YzdmMTox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvZDA3YzdmMWVkNjE3ODll
MTc1ZmE5NzUxMzQ4NTViZTMyMjYzYmUyYy9kbWVzZy1xdWFudGFsLWtidWlsZC0xOjIwMTQw
NzE3MTAyMDI4Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAw
MDQtZ2QwN2M3ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2Qw
N2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2ctcXVhbnRhbC1r
YnVpbGQtMjQ6MjAxNDA3MTcxMDIwMjk6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6
My4xNi4wLXJjNS0wMDAwNC1nZDA3YzdmMToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czAtMDcxNzAyMzMvZDA3YzdmMWVkNjE3ODllMTc1ZmE5NzUxMzQ4NTViZTMyMjYzYmUyYy9k
bWVzZy1xdWFudGFsLWtidWlsZC0yNjoyMDE0MDcxNzEwMjAyODp4ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1
NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0xMToyMDE0MDcxNzEwMjAyNDp4ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUx
NzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0xMjoyMDE0MDcx
NzEwMjAyOTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0
LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdj
N2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWls
ZC0xMzoyMDE0MDcxNzEwMjAyNjp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2
LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNn
LXlvY3RvLWtidWlsZC0xNToyMDE0MDcxNzEwMjAzMTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIy
NjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0yNDoyMDE0MDcxNzEwMjAyODp4ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3
NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0zMDoyMDE0MDcxNzEwMjAy
NDp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdj
N2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2
MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0zMToy
MDE0MDcxNzEwMjAyOTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1
LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIz
My9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3Rv
LWtidWlsZC00OjIwMTQwNzE3MTAyMDI2Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMz
OjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMv
ZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTQ6MjAxNDA3MTcxMDIwMzM6eDg2XzY0LXJhbmRjb25m
aWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0wMDAwNC1nZDA3YzdmMToxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvZDA3YzdmMWVkNjE3ODllMTc1ZmE5NzUxMzQ4
NTViZTMyMjYzYmUyYy9kbWVzZy1xdWFudGFsLWtidWlsZC00OjIwMTQwNzE3MTAyMDMzOng4
Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYxNzg5
ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2cteW9jdG8ta2J1aWxkLTE6MjAxNDA3
MTcxMDIwMzM6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0wMDAw
NC1nZDA3YzdmMToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvZDA3
YzdmMWVkNjE3ODllMTc1ZmE5NzUxMzQ4NTViZTMyMjYzYmUyYy9kbWVzZy1xdWFudGFsLWti
dWlsZC0yMToyMDE0MDcxNzEwMjAzODp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzoz
LjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2Rt
ZXNnLXF1YW50YWwta2J1aWxkLTI2OjIwMTQwNzE3MTAyMDQ0Ong4Nl82NC1yYW5kY29uZmln
LXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1
YmUzMjI2M2JlMmMvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMzoyMDE0MDcxNzEwMjAzNTp4ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUx
NzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0xMToyMDE0MDcx
NzEwMjAzNjp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0
LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdj
N2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWls
ZC0xMzoyMDE0MDcxNzEwMjA0Mzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2
LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNn
LXlvY3RvLWtidWlsZC0xNToyMDE0MDcxNzEwMjA0MTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0w
NzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIy
NjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0xNjoyMDE0MDcxNzEwMjAzNTp4ODZfNjQtcmFu
ZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3
NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0xODoyMDE0MDcxNzEwMjA0
Mjp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdj
N2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2
MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0xOToy
MDE0MDcxNzEwMjAzNTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1
LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIz
My9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3Rv
LWtidWlsZC0yMzoyMDE0MDcxNzEwMjAzNjp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIz
MzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJj
L2RtZXNnLXlvY3RvLWtidWlsZC0yNDoyMDE0MDcxNzEwMjA0NDp4ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1
NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0yOjIwMTQwNzE3MTAyMDQ1Ong4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYxNzg5ZTE3
NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2cteW9jdG8ta2J1aWxkLTMwOjIwMTQwNzE3
MTAyMDQwOng4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQt
Z2QwN2M3ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3
ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2cteW9jdG8ta2J1aWxk
LTMxOjIwMTQwNzE3MTAyMDM5Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYu
MC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3
MTcwMjMzL2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2ct
eW9jdG8ta2J1aWxkLTQ6MjAxNDA3MTcxMDIwNDI6eDg2XzY0LXJhbmRjb25maWctczAtMDcx
NzAyMzM6My4xNi4wLXJjNS0wMDAwNC1nZDA3YzdmMToxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczAtMDcxNzAyMzMvZDA3YzdmMWVkNjE3ODllMTc1ZmE5NzUxMzQ4NTViZTMyMjYz
YmUyYy9kbWVzZy15b2N0by1rYnVpbGQtNToyMDE0MDcxNzEwMjA0Mzp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEz
NDg1NWJlMzIyNjNiZTJjL2RtZXNnLXF1YW50YWwta2J1aWxkLTEzOjIwMTQwNzE3MTAyMDQ2
Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3
ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYx
Nzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTc6
MjAxNDA3MTcxMDIwNDY6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJj
NS0wMDAwNC1nZDA3YzdmMToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAy
MzMvZDA3YzdmMWVkNjE3ODllMTc1ZmE5NzUxMzQ4NTViZTMyMjYzYmUyYy9kbWVzZy15b2N0
by1rYnVpbGQtMTI6MjAxNDA3MTcxMDIwNDU6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAy
MzM6My4xNi4wLXJjNS0wMDAwNC1nZDA3YzdmMToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczAtMDcxNzAyMzMvZDA3YzdmMWVkNjE3ODllMTc1ZmE5NzUxMzQ4NTViZTMyMjYzYmUy
Yy9kbWVzZy1xdWFudGFsLWtidWlsZC0xMjoyMDE0MDcxNzEwMjA0Nzp4ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEz
NDg1NWJlMzIyNjNiZTJjL2RtZXNnLXF1YW50YWwta2J1aWxkLTEzOjIwMTQwNzE3MTAyMDU3
Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3
ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYx
Nzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTQ6
MjAxNDA3MTcxMDIwNTA6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJj
NS0wMDAwNC1nZDA3YzdmMToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAy
MzMvZDA3YzdmMWVkNjE3ODllMTc1ZmE5NzUxMzQ4NTViZTMyMjYzYmUyYy9kbWVzZy1xdWFu
dGFsLWtidWlsZC0xNzoyMDE0MDcxNzEwMjA1Nzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3
MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNi
ZTJjL2RtZXNnLXF1YW50YWwta2J1aWxkLTE4OjIwMTQwNzE3MTAyMDQ5Ong4Nl82NC1yYW5k
Y29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1
MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMToyMDE0MDcxNzEwMjA0
OTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdj
N2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2
MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXF1YW50YWwta2J1aWxkLTIx
OjIwMTQwNzE3MTAyMDU1Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1y
YzUtMDAwMDQtZ2QwN2M3ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcw
MjMzL2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2ctcXVh
bnRhbC1rYnVpbGQtMjY6MjAxNDA3MTcxMDIwNTU6eDg2XzY0LXJhbmRjb25maWctczAtMDcx
NzAyMzM6My4xNi4wLXJjNS0wMDAwNC1nZDA3YzdmMToxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczAtMDcxNzAyMzMvZDA3YzdmMWVkNjE3ODllMTc1ZmE5NzUxMzQ4NTViZTMyMjYz
YmUyYy9kbWVzZy1xdWFudGFsLWtidWlsZC03OjIwMTQwNzE3MTAyMDQ4Ong4Nl82NC1yYW5k
Y29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1
MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2ctcXVhbnRhbC1rYnVpbGQtOToyMDE0MDcxNzEwMjA0
OTp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdj
N2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2
MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0xMjoy
MDE0MDcxNzEwMjA1Njp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1
LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIz
My9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3Rv
LWtidWlsZC0xNToyMDE0MDcxNzEwMjA1Nzp4ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIz
MzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJj
L2RtZXNnLXlvY3RvLWtidWlsZC0xODoyMDE0MDcxNzEwMjA1ODp4ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNzE3MDIzMzozLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9kMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1
NWJlMzIyNjNiZTJjL2RtZXNnLXlvY3RvLWtidWlsZC0xOjIwMTQwNzE3MTAyMDU0Ong4Nl82
NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3ZjFlZDYxNzg5ZTE3
NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2cteW9jdG8ta2J1aWxkLTI0OjIwMTQwNzE3
MTAyMDU1Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQt
Z2QwN2M3ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2QwN2M3
ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2cteW9jdG8ta2J1aWxk
LTMwOjIwMTQwNzE3MTAyMDU2Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzOjMuMTYu
MC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3
MTcwMjMzL2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMvZG1lc2ct
eW9jdG8ta2J1aWxkLTMxOjIwMTQwNzE3MTAyMDU2Ong4Nl82NC1yYW5kY29uZmlnLXMwLTA3
MTcwMjMzOjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQowOjU4OjUwIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCltjNmYwN2E2MzYwMWZiYjM2YzA5YmYyNTBi
NTUzOGFiYjQ3YjUxZTQ0XSByYW5kb206IFNlZWQgcG9vbHMgZnJvbSBhcmNoX2dldF9zbG93
X3JuZ191NjQgYXQgc3RhcnR1cApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMg
LWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3
MTcwMjMzL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxNzAxOmM2ZjA3YTYzNjAx
ZmJiMzZjMDliZjI1MGI1NTM4YWJiNDdiNTFlNDQ6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNy0x
Ny0xMDoyMzowOSBjNmYwN2E2MzYwMWZiYjM2YzA5YmYyNTBiNTUzOGFiYjQ3YjUxZTQ0IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLWM2ZjA3YTYzNjAxZmJiMzZjMDliZjI1
MGI1NTM4YWJiNDdiNTFlNDQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMwLTA3MTcwMjMzL2M2ZjA3YTYzNjAxZmJiMzZjMDliZjI1MGI1NTM4YWJi
NDdiNTFlNDQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLWM2ZjA3YTYzNjAxZmJiMzZj
MDliZjI1MGI1NTM4YWJiNDdiNTFlNDQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1lci94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMy1jNmYwN2E2MzYwMWZiYjM2YzA5YmYyNTBiNTUzOGFiYjQ3YjUx
ZTQ0Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIzMy9jNmYw
N2E2MzYwMWZiYjM2YzA5YmYyNTBiNTUzOGFiYjQ3YjUxZTQ0L3ZtbGludXotMy4xNi4wLXJj
NS0wMDAwMy1nYzZmMDdhNgoKMjAxNC0wNy0xNy0xMDoyODoxMSBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAJMi4JMTgJNDAJNDYJMTA0CTEwOAkxMzMJMTU0CTE3OQkyMDMJMjM1IFNVQ0NFU1MK
CmQwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMgaXMgdGhlIGZpcnN0
IGJhZCBjb21taXQKY29tbWl0IGQwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2
M2JlMmMKQXV0aG9yOiBBbmR5IEx1dG9taXJza2kgPGx1dG9AYW1hY2FwaXRhbC5uZXQ+CkRh
dGU6ICAgVHVlIEp1bCAxNSAxODozNDoyMCAyMDE0IC0wNzAwCgogICAgeDg2LGthc2xyOiBV
c2UgTVNSX0tWTV9HRVRfUk5HX1NFRUQgZm9yIEtBU0xSIGlmIGF2YWlsYWJsZQogICAgCiAg
ICBJdCdzIGNvbnNpZGVyYWJseSBiZXR0ZXIgdGhhbiBhbnkgb2YgdGhlIGFsdGVybmF0aXZl
cyBvbiBLVk0uCiAgICAKICAgIFJhdGhlciB0aGFuIHJlaW52ZW50aW5nIGFsbCBvZiB0aGUg
Y3B1IGZlYXR1cmUgcXVlcnkgY29kZSwgdGhpcyBmaXhlcwogICAgbmF0aXZlX2NwdWlkIHRv
IHdvcmsgaW4gUElDIG9iamVjdHMuCiAgICAKICAgIEkgaGF2ZW4ndCBjb21iaW5lZCBpdCB3
aXRoIGJvb3QvY3B1ZmxhZ3MuYydzIGNwdWlkIGltcGxlbWVudGF0aW9uOgogICAgaW5jbHVk
aW5nIGFzbS9wcm9jZXNzb3IuaCBmcm9tIGJvb3QvY3B1ZmxhZ3MuYyByZXN1bHRzIGluIGEg
Zmxvb2Qgb2YKICAgIHVucmVsYXRlZCBlcnJvcnMsIGFuZCBmaXhpbmcgaXQgbWlnaHQgYmUg
bWVzc3kuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IEFuZHkgTHV0b21pcnNraSA8bHV0b0Bh
bWFjYXBpdGFsLm5ldD4KCjowNDAwMDAgMDQwMDAwIDkwZGQwOThiZDdhYzc4MDJiNzZkYzA2
OTYwMTYwZWUwZmMzNGFlYzMgNzY0NzI0ZjZlYzYwNDY1OGNiMjYzZWQ2ZTZlMjlkZDE0OTZl
OTE4MCBNCWFyY2gKYmlzZWN0IHJ1biBzdWNjZXNzCkhFQUQgaXMgbm93IGF0IGM2ZjA3YTYu
Li4gcmFuZG9tOiBTZWVkIHBvb2xzIGZyb20gYXJjaF9nZXRfc2xvd19ybmdfdTY0IGF0IHN0
YXJ0dXAKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLXMwLTA3MTcwMjMzL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxNzAxOmM2
ZjA3YTYzNjAxZmJiMzZjMDliZjI1MGI1NTM4YWJiNDdiNTFlNDQ6YmlzZWN0LWxpbnV4MAoK
MjAxNC0wNy0xNy0xMDozNToxMCBjNmYwN2E2MzYwMWZiYjM2YzA5YmYyNTBiNTUzOGFiYjQ3
YjUxZTQ0IHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvYzZm
MDdhNjM2MDFmYmIzNmMwOWJmMjUwYjU1MzhhYmI0N2I1MWU0NC92bWxpbnV6LTMuMTYuMC1y
YzUtMDAwMDMtZ2M2ZjA3YTYKCjIwMTQtMDctMTctMTA6MzU6MTAgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4JMjQ2CTI0NwkyODAJMjk1CTMwNwkzNDEJMzYwCTM2OAkzOTQJNDI4CTQ2MAk0
NjkJNDg3CTUyOQk1NDQJNTY4CTYwOQk2MjMJNjM2CTY4Nwk2OTcJNzAxCTcwNSBTVUNDRVNT
CgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBjNmYwN2E2Li4uIHJhbmRvbTogU2VlZCBw
b29scyBmcm9tIGFyY2hfZ2V0X3Nsb3dfcm5nX3U2NCBhdCBzdGFydHVwCkhFQUQgaXMgbm93
IGF0IDVlNjBjMmEuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQw
NzE3MDEnCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMy9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTo1
ZTYwYzJhZjdhOGJkZTVjZmFlZThmZmQ3N2NmYzViNjJkYjBhMDRlOmJpc2VjdC1saW51eDAK
IFRFU1QgRkFJTFVSRQpbICAgIDAuMDAwMDAwXSBQb2xpY3kgem9uZTogRE1BMzIKWyAgICAw
LjAwMDAwMF0gS2VybmVsIGNvbW1hbmQgbGluZTogaHVuZ190YXNrX3BhbmljPTEgZWFybHlw
cmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJs
ZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9j
a3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNv
bGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFt
MCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1zMC0wNzE3MDIzMy9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTo1ZTYw
YzJhZjdhOGJkZTVjZmFlZThmZmQ3N2NmYzViNjJkYjBhMDRlOmJpc2VjdC1saW51eDAvLnZt
bGludXotNWU2MGMyYWY3YThiZGU1Y2ZhZWU4ZmZkNzdjZmM1YjYyZGIwYTA0ZS0yMDE0MDcx
NzA0MDIwMC0yLWtidWlsZCBicmFuY2g9bGludXgtZGV2ZWwvZGV2ZWwtaG91cmx5LTIwMTQw
NzE3MDEgQk9PVF9JTUFHRT0va2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMz
LzVlNjBjMmFmN2E4YmRlNWNmYWVlOGZmZDc3Y2ZjNWI2MmRiMGEwNGUvdm1saW51ei0zLjE2
LjAtcmM1LTA2Mzk2LWc1ZTYwYzJhIGRyYmQubWlub3JfY291bnQ9OApbICAgIDAuMDAwMDAw
XSBQSUQgaGFzaCB0YWJsZSBlbnRyaWVzOiAyMDQ4IChvcmRlcjogMiwgMTYzODQgYnl0ZXMp
ClsgICAgMC4wMDAwMDBdIGdlbmVyYWwgcHJvdGVjdGlvbiBmYXVsdDogMDAwMCBbIzFdIFNN
UCBERUJVR19QQUdFQUxMT0MKWyAgICAwLjAwMDAwMF0gTW9kdWxlcyBsaW5rZWQgaW46Clsg
ICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAz
LjE2LjAtcmM1LTA2Mzk2LWc1ZTYwYzJhICMxOApbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBu
YW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMDAwMDBd
IHRhc2s6IGZmZmZmZmZmODFjMTA0OTAgdGk6IGZmZmZmZmZmODFjMDAwMDAgdGFzay50aTog
ZmZmZmZmZmY4MWMwMDAwMApbICAgIDAuMDAwMDAwXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgx
ZTk2NTdjPl0gIFs8ZmZmZmZmZmY4MWU5NjU3Yz5dIHNldHVwX2luaXRfZnB1X2J1ZisweDEw
NC8weDEyMgpbICAgIDAuMDAwMDAwXSBSU1A6IDAwMDA6ZmZmZmZmZmY4MWMwM2UzMCAgRUZM
QUdTOiAwMDAxMDA4NgpbICAgIDAuMDAwMDAwXSBSQVg6IDAwMDAwMDAwZmZmZmZmZmYgUkJY
OiAwMDAwMDAwMDAwMDAwMDAzIFJDWDogMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDAwMDAw
XSBSRFg6IDAwMDAwMDAwZmZmZmZmZmYgUlNJOiBmZmZmZmZmZjgxYzAzZTM0IFJESTogZmZm
Zjg4MDAxM2ZmOTAwMApbICAgIDAuMDAwMDAwXSBSQlA6IGZmZmZmZmZmODFjMDNlNjggUjA4
OiAwMDAwMDAwMDAwMDAwMDQwIFIwOTogZmZmZmZmZmY4MWMwM2UzOApbICAgIDAuMDAwMDAw
XSBSMTA6IGZmZmZmZmZmODFjMDNlM2MgUjExOiAwMDAwMDAwMDAwMDAwMDQwIFIxMjogZmZm
ZmZmZmY4MWMwM2UzYwpbICAgIDAuMDAwMDAwXSBSMTM6IGZmZmZmZmZmODFjMDNlMzggUjE0
OiBmZmZmZmZmZjgxYzAzZTM0IFIxNTogZmZmZmZmZmY4MWMwM2UzMApbICAgIDAuMDAwMDAw
XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4MDAxMTAwMDAwMCgwMDAw
KSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMDAwMDBdIENTOiAgMDAxMCBEUzog
MDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKWyAgICAwLjAwMDAwMF0gQ1Iy
OiBmZmZmODgwMDEyN2ZmMDAwIENSMzogMDAwMDAwMDAwMWMwYjAwMCBDUjQ6IDAwMDAwMDAw
MDAwNDA2YTAKWyAgICAwLjAwMDAwMF0gU3RhY2s6ClsgICAgMC4wMDAwMDBdICAwMDAwMDAw
MDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MWMwM2U4MCBmZmZmZmZmZjgx
YzAzZTg0ClsgICAgMC4wMDAwMDBdICBmZmZmZmZmZjgxYzAzZTdjIGZmZmZmZmZmODFjMDNl
NzggMDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgxYzAzZWE4ClsgICAgMC4wMDAwMDBdICBm
ZmZmZmZmZjgxZTk2NzExIDAwMDAwMDAwMDAwMDAwMDcgMDAwMDAzNDAwMDAwMDM0MCAwMDAw
MDAwMDAwMDAwMDA4ClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBd
ICBbPGZmZmZmZmZmODFlOTY3MTE+XSB4c3RhdGVfZW5hYmxlX2Jvb3RfY3B1KzB4MTc3LzB4
MWYyClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwMGMxM2Y+XSB4c2F2ZV9pbml0KzB4
MjYvMHgyOApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDBiMGMzPl0gZnB1X2luaXQr
MHg5Ni8weDlkClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwMTEyNzI+XSBjcHVfaW5p
dCsweDJiYy8weDJmMwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTkyYjA2Pl0gdHJh
cF9pbml0KzB4NTQzLzB4NWViClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlOTBjMmY+
XSBzdGFydF9rZXJuZWwrMHgxZTIvMHgzZTYKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MWU5MDdjMj5dID8gc2V0X2luaXRfYXJnKzB4NTUvMHg1NQpbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgxZTkwMTIwPl0gPyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAg
ICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU5MDQ3MT5dIHg4Nl82NF9zdGFydF9yZXNlcnZh
dGlvbnMrMHgyYS8weDJjClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlOTA1NjE+XSB4
ODZfNjRfc3RhcnRfa2VybmVsKzB4ZWUvMHhmYgpbICAgIDAuMDAwMDAwXSBDb2RlOiBjYyA0
OCA4YiAxNSBkNyBiMyAwZCAwMCA0OCA2MyBjMyBmZiBjMyA4OSAwYyA4MiA0OCA4YiAxNSBj
MCBiMyAwZCAwMCA4YiA0ZCBjOCA4OSAwYyA4MiBlYiBiYyA4MyBjOCBmZiA0OCA4YiAzZCA5
NiBiMyAwZCAwMCA4OSBjMiA8NDg+IDBmIGFlIDJmIDQ4IDhiIDNkIDg5IGIzIDBkIDAwIDg5
IGMyIDQ4IDBmIGFlIDI3IDU4IDVhIDViIDQxIApbICAgIDAuMDAwMDAwXSBSSVAgIFs8ZmZm
ZmZmZmY4MWU5NjU3Yz5dIHNldHVwX2luaXRfZnB1X2J1ZisweDEwNC8weDEyMgpbICAgIDAu
MDAwMDAwXSAgUlNQIDxmZmZmZmZmZjgxYzAzZTMwPgpbICAgIDAuMDAwMDAwXSAtLS1bIGVu
ZCB0cmFjZSA4MjBhZTE1NjM4MWMwNjA1IF0tLS0KWyAgICAwLjAwMDAwMF0gS2VybmVsIHBh
bmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMwLTA3MTcwMjMzLzVlNjBjMmFmN2E4YmRlNWNmYWVlOGZmZDc3Y2ZjNWI2MmRi
MGEwNGUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjk6MjAxNDA3MTcwNDAwNTE6eDg2XzY0LXJh
bmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0wNjM5Ni1nNWU2MGMyYToxOAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLzVlNjBjMmFmN2E4YmRlNWNmYWVl
OGZmZDc3Y2ZjNWI2MmRiMGEwNGUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjI6MjAxNDA3MTcw
MjM4NDA6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4xNi4wLXJjNS0wNjM5Ni1n
NWU2MGMyYToxOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLzVlNjBj
MmFmN2E4YmRlNWNmYWVlOGZmZDc3Y2ZjNWI2MmRiMGEwNGUvZG1lc2ctcXVhbnRhbC1rYnVp
bGQtMTU6MjAxNDA3MTcwNDAwNTE6eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzM6My4x
Ni4wLXJjNS0wNjM5Ni1nNWU2MGMyYToxOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA3MTcwMjMzLzVlNjBjMmFmN2E4YmRlNWNmYWVlOGZmZDc3Y2ZjNWI2MmRiMGEwNGUvZG1l
c2ctcXVhbnRhbC1rYnVpbGQtMjM6MjAxNDA3MTcwNDAwNTE6eDg2XzY0LXJhbmRjb25maWct
czAtMDcxNzAyMzM6My4xNi4wLXJjNS0wNjM5Ni1nNWU2MGMyYToxOAoxNzo0OjQgYWxsX2dv
b2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkhFQUQgaXMgbm93IGF0IDVlNjBjMmEgMGRheSBoZWFk
IGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEnCgo9PT09PT09PT0gbGludXMv
bWFzdGVyID09PT09PT09PQpGcm9tIGdpdDovL2dpdG1pcnJvci9saW51cwogICAyZGEyOTQ0
Li5iNjYwM2ZlICBtYXN0ZXIgICAgIC0+IGxpbnVzL21hc3RlcgpQcmV2aW91cyBIRUFEIHBv
c2l0aW9uIHdhcyA1ZTYwYzJhLi4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJs
eS0yMDE0MDcxNzAxJwpIRUFEIGlzIG5vdyBhdCBiNjYwM2ZlLi4uIE1lcmdlIHRhZyAnZm9y
LWxpbnVzLTIwMTQwNzE2JyBvZiBnaXQ6Ly9naXQuaW5mcmFkZWFkLm9yZy9saW51eC1tdGQK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMw
LTA3MTcwMjMzL2xpbnVzOm1hc3RlcjpiNjYwM2ZlNTc0YWYyODlkYmU5ZWI5ZmI0YzU0MGJj
YTA0ZjVhMDUzOmJpc2VjdC1saW51eDAKCjIwMTQtMDctMTctMTA6NDc6NTkgYjY2MDNmZTU3
NGFmMjg5ZGJlOWViOWZiNGM1NDBiY2EwNGY1YTA1MyBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1z
MC0wNzE3MDIzMy1iNjYwM2ZlNTc0YWYyODlkYmU5ZWI5ZmI0YzU0MGJjYTA0ZjVhMDUzCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMC0wNzE3MDIz
My9iNjYwM2ZlNTc0YWYyODlkYmU5ZWI5ZmI0YzU0MGJjYTA0ZjVhMDUzCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1zMC0wNzE3MDIzMy1iNjYwM2ZlNTc0YWYyODlkYmU5ZWI5ZmI0YzU0MGJjYTA0ZjVh
MDUzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMtYjY2
MDNmZTU3NGFmMjg5ZGJlOWViOWZiNGM1NDBiY2EwNGY1YTA1MwprZXJuZWw6IC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczAtMDcxNzAyMzMvYjY2MDNmZTU3NGFmMjg5ZGJlOWViOWZi
NGM1NDBiY2EwNGY1YTA1My92bWxpbnV6LTMuMTYuMC1yYzUtMDAxNDMtZ2I2NjAzZmUKCjIw
MTQtMDctMTctMTA6NTc6NTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTEJMi4JNQk2Lgk4
CTExLi4JMTQJMTUJMTcJMjAJMjEJMjIJMjMJMjQJMjUJMjgJMjkuCTMxCTMzCTM2LgkzOAkz
OQk0MAk0Mwk0OAk0OQk1Mwk1Nwk2Mwk3MQk3Nwk4MAk4Mwk4Nwk5MQk5OAkxMDcJMTEzCTEy
MQkxMzIuCTEzNQkxNDIJMTQ5CTE1MgkxNTcJMTYyCTE2NgkxNzIJMTc2CTE3OAkxODAJMTgz
LgkxODYJMTkzCTE5NwkxOTkJMjA3CTIxMQkyMTYJMjIyCTIyOAkyMzQJMjM3CTI0NQkyNTQJ
MjYwCTI2MgkyNjUJMjcxCTI3OAkyODEJMjg1CTI5MgkyOTUJMjk4CTMwMwkzMDQJMzEwCTMy
MAkzMjQJMzI2CTMzMAkzMzEJMzM0CTMzOAkzNDMJMzQ1CTM0NgkzNDcJMzUyCTM2MAkzNjkJ
Mzc3CTM3OAkzODYJMzg5CTM5Mwk0MDAJNDA0CTQwNQk0MDkJNDEzCTQxNwk0MjAJNDI2CTQz
Mgk0MzgJNDQyCTQ1NAk0NTkJNDYzCTQ3Nwk0ODIJNDk4CTUwNgk1MDkJNTE5CTUyNgk1MzAJ
NTQ0CTU1NQk1NjYJNTcwCTU3NQk1ODIJNTk3CTYwNgk2MTEJNjE2CTYyOQk2MzcJNjQ0CTY1
Nwk2NjQJNjczCTY4Ngk2OTIJNjk5CTcwNSBTVUNDRVNTCgoKPT09PT09PT09IG5leHQvbWFz
dGVyID09PT09PT09PQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiArIGZhYzg0N2IuLi5k
YTEyNTc0IGFrcG0gICAgICAgLT4gbmV4dC9ha3BtICAoZm9yY2VkIHVwZGF0ZSkKICsgODJj
MjM3Ni4uLjY4ODI5YTMgYWtwbS1iYXNlICAtPiBuZXh0L2FrcG0tYmFzZSAgKGZvcmNlZCB1
cGRhdGUpCiArIGJiNjJjNzkuLi5kNGY0ZDFkIG1hc3RlciAgICAgLT4gbmV4dC9tYXN0ZXIg
IChmb3JjZWQgdXBkYXRlKQogICA1MTcwYTNiLi4xNzk1Y2Q5ICBzdGFibGUgICAgIC0+IG5l
eHQvc3RhYmxlCkZyb20gZ2l0Oi8vZ2l0bWlycm9yL25leHQKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDE0MDcwNyAtPiBuZXh0LTIwMTQwNzA3CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxNDA3MDggLT4gbmV4dC0yMDE0MDcwOAogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTQwNzA5IC0+IG5leHQtMjAxNDA3MDkKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDE0MDcxMCAtPiBuZXh0LTIwMTQwNzEwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxNDA3MTEgLT4gbmV4dC0yMDE0MDcxMQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQwNzE0IC0+IG5leHQtMjAxNDA3MTQKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0
MDcxNSAtPiBuZXh0LTIwMTQwNzE1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA3
MTYgLT4gbmV4dC0yMDE0MDcxNgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBiNjYwM2Zl
Li4uIE1lcmdlIHRhZyAnZm9yLWxpbnVzLTIwMTQwNzE2JyBvZiBnaXQ6Ly9naXQuaW5mcmFk
ZWFkLm9yZy9saW51eC1tdGQKSEVBRCBpcyBub3cgYXQgZDRmNGQxZC4uLiBBZGQgbGludXgt
bmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA3MTYKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL25leHQ6bWFzdGVy
OmQ0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjM6YmlzZWN0LWxpbnV4
MAoKMjAxNC0wNy0xNy0xMjoxNzowMCBkNGY0ZDFkNDVjZDFiOWFhNjBlNjFjMmVhYjI1YTVk
OWE3OWEyNmYzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLWQ0ZjRkMWQ0NWNk
MWI5YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2Q0ZjRkMWQ0NWNkMWI5YWE2MGU2
MWMyZWFiMjVhNWQ5YTc5YTI2ZjMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzLWQ0ZjRk
MWQ0NWNkMWI5YWE2MGU2MWMyZWFiMjVhNWQ5YTc5YTI2ZjMKa2VybmVsOiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMwLTA3MTcwMjMzL2Q0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMyZWFi
MjVhNWQ5YTc5YTI2ZjMvdm1saW51ei0zLjE2LjAtcmM1LW5leHQtMjAxNDA3MTYKCjIwMTQt
MDctMTctMTI6MTk6MDAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEJMTEJMTYJMjQJNDYJNDgJ
NTUJNzEJODcJOTQJMTExCTExNgkxMjgJMTQyCTE1NQkxNjMJMTc5CTE4NAkxOTEJMjExCTIy
NAkyMjcJMjQwCTI1MwkyNjcJMjczCTMwMQkzMTIJMzIyCTM0NQkzNjEJMzY3CTM5NAk0MTQJ
NDQwCTQ1Nwk0NzQJNDkwCTUxNQk1MjkJNTQ5CTU3NQk1ODYJNjEyCTY1Mwk2ODgJNzA1IFNV
Q0NFU1MKCg==

--7gLe/sNPhR777EPF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-rc5-00004-gd07c7f1"

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
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
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
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
CONFIG_NO_HZ_FULL_SYSIDLE=y
CONFIG_NO_HZ_FULL_SYSIDLE_SMALL=8
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
# CONFIG_UPROBES is not set
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
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PADATA=y
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
# CONFIG_X86_EXTENDED_PLATFORM is not set
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
CONFIG_ARCH_SLOW_RNG=y
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
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
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
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
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
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
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
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
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
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
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
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=m
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_RAW=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
# CONFIG_BRIDGE_EBT_AMONG is not set
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=m
# CONFIG_BRIDGE_EBT_LIMIT is not set
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
# CONFIG_BRIDGE_EBT_VLAN is not set
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
# CONFIG_BRIDGE_EBT_SNAT is not set
# CONFIG_BRIDGE_EBT_LOG is not set
# CONFIG_BRIDGE_EBT_ULOG is not set
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_NET_DCCPPROBE=y
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=m
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=m
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DAT is not set
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_MCAST=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_TCPPROBE=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
# CONFIG_BAYCOM_SER_FDX is not set
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_BAYCOM_PAR is not set
CONFIG_YAM=m
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

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

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=m
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
CONFIG_NFC_DIGITAL=m
CONFIG_NFC_NCI=m
CONFIG_NFC_NCI_SPI=y
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_TRF7970A is not set
CONFIG_NFC_SIM=m
CONFIG_NFC_MRVL=m
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
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
CONFIG_REGMAP_I2C=m
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
CONFIG_CMA_SIZE_SEL_MIN=y
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=m
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
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
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=m
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SBC_GXX=m
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=m
CONFIG_MTD_PCMCIA_ANONYMOUS=y
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_SST25L=m
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=m
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
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_MTD_UBI_BLOCK=y
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=m
CONFIG_AD525X_DPOT_SPI=m
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
CONFIG_TI_DAC7512=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=y
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=m
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
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
CONFIG_ECHO=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=m
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
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
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
# CONFIG_PCMCIA_FDOMAIN is not set
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=m
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=m
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
CONFIG_BCACHE_CLOSURES_DEBUG=y
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=m
# CONFIG_DM_CACHE_MQ is not set
CONFIG_DM_CACHE_CLEANER=m
CONFIG_DM_ERA=m
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_QL is not set
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
CONFIG_DM_SWITCH=m
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=m
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
CONFIG_SBP_TARGET=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=m
# CONFIG_FIREWIRE_NET is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
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
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_AD7879_SPI=m
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
# CONFIG_TOUCHSCREEN_CYTTSP4_SPI is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=m
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_PIXCIR=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_ST1232=m
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZFORCE=m
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=m
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_SC16IS7XX=m
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=m
CONFIG_SERIAL_MEN_Z135=y
# CONFIG_PRINTER is not set
CONFIG_PPDEV=m
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

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
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=m
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_GPIO=y
# CONFIG_SPI_LM70_LLP is not set
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set
CONFIG_SPI_DW_MMIO=m

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
CONFIG_SPMI=m
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=m
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_LP3943 is not set
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MC33880=m

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

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=m
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7314=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7310=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GPIO_FAN=m
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4222=m
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_MAX16065=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=m
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_NCT6683=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SHTC1=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_ADC128D818=m
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m
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
CONFIG_SOFT_WATCHDOG=m
CONFIG_XILINX_WATCHDOG=m
CONFIG_DW_WATCHDOG=m
CONFIG_RETU_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=m
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=m
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
CONFIG_SC1200_WDT=m
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=m
CONFIG_MEN_A21_WDT=m

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
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
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_BCM590XX=m
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
CONFIG_ABX500_CORE=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=m
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=m
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=m
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_ACT8865=m
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_BCM590XX is not set
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP872X=m
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LTC3589 is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS6524X=m
# CONFIG_REGULATOR_TPS65912 is not set
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
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_PTN3460=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
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
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=m
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
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=m
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
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=m
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=m
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=m
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
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_COMEDI is not set
# CONFIG_PANEL is not set
# CONFIG_RTS5208 is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=m
# CONFIG_ADIS16203 is not set
CONFIG_ADIS16204=m
# CONFIG_ADIS16209 is not set
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=m
# CONFIG_LIS3L02DQ is not set
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
CONFIG_AD7291=m
# CONFIG_AD7606 is not set
# CONFIG_AD7780 is not set
CONFIG_AD7816=m
CONFIG_AD7192=m
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
# CONFIG_ADT7316_SPI is not set
CONFIG_ADT7316_I2C=m

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#
# CONFIG_AD5930 is not set
CONFIG_AD9832=m
# CONFIG_AD9834 is not set
CONFIG_AD9850=m
CONFIG_AD9852=m
CONFIG_AD9910=m
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_TSL2583=m
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
CONFIG_ADE7754=m
CONFIG_ADE7758=m
# CONFIG_ADE7759 is not set
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
CONFIG_AD2S1200=m
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y
CONFIG_FT1000_PCMCIA=m

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=y
CONFIG_ANDROID_TIMED_OUTPUT=y
# CONFIG_ANDROID_TIMED_GPIO is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_SYNC is not set
CONFIG_ION=y
CONFIG_ION_TEST=y
# CONFIG_ION_DUMMY is not set
CONFIG_WIMAX_GDM72XX=m
# CONFIG_WIMAX_GDM72XX_QOS is not set
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_SDIO=y
# CONFIG_DGRP is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
# CONFIG_MTD_SPINAND_MT29F is not set
CONFIG_LUSTRE_FS=m
CONFIG_LUSTRE_OBD_MAX_IOCTL_BUFFER=8192
# CONFIG_LUSTRE_DEBUG_EXPENSIVE_CHECK is not set
CONFIG_LUSTRE_LLITE_LLOOP=m
CONFIG_LNET=m
CONFIG_LNET_MAX_PAYLOAD=1048576
CONFIG_LNET_SELFTEST=m
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
CONFIG_GS_FPGABOOT=y
# CONFIG_CRYPTO_SKEIN is not set
CONFIG_CRYPTO_THREEFISH=y
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=m
CONFIG_CHROMEOS_PSTORE=m

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
CONFIG_MAILBOX=y
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
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=m
CONFIG_HID_SENSOR_ACCEL_3D=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=m
CONFIG_KXSD9=m
CONFIG_MMA8452=m

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
CONFIG_AD7266=m
CONFIG_AD7298=m
# CONFIG_AD7476 is not set
CONFIG_AD7791=m
# CONFIG_AD7793 is not set
CONFIG_AD7887=m
CONFIG_AD7923=m
# CONFIG_AD799X is not set
CONFIG_MAX1363=m
# CONFIG_MCP320X is not set
CONFIG_MCP3422=m
CONFIG_MEN_Z188_ADC=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
CONFIG_TI_AM335X_ADC=m

#
# Amplifiers
#
CONFIG_AD8366=m

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_SPI=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5360 is not set
CONFIG_AD5380=m
CONFIG_AD5421=m
CONFIG_AD5446=m
CONFIG_AD5449=m
CONFIG_AD5504=m
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5686=m
# CONFIG_AD5755 is not set
CONFIG_AD5764=m
CONFIG_AD5791=m
CONFIG_AD7303=m
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=m
CONFIG_ADIS16130=m
CONFIG_ADIS16136=m
CONFIG_ADIS16260=m
CONFIG_ADXRS450=m
# CONFIG_HID_SENSOR_GYRO_3D is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=m
CONFIG_ADIS16480=m
CONFIG_INV_MPU6050_IIO=m
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=m
CONFIG_CM32181=m
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=m
# CONFIG_HID_SENSOR_ALS is not set
CONFIG_HID_SENSOR_PROX=m
CONFIG_SENSORS_LM3533=m
CONFIG_LTR501=m
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
CONFIG_AK8975=m
CONFIG_MAG3110=m
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
CONFIG_IIO_ST_MAGN_SPI_3AXIS=m

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
# CONFIG_HID_SENSOR_DEVICE_ROTATION is not set

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=m
CONFIG_MPL115=m
CONFIG_MPL3115=m
# CONFIG_IIO_ST_PRESS is not set

#
# Lightning sensors
#
CONFIG_AS3935=m

#
# Temperature sensors
#
CONFIG_MLX90614=m
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
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
CONFIG_EXT4_FS=m
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
# CONFIG_CEPH_FS_POSIX_ACL is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SMB2 is not set
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=m
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=m
CONFIG_9P_FSCACHE=y
# CONFIG_9P_FS_POSIX_ACL is not set
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=m
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

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
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_VMACACHE=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
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
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
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
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=m
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
# CONFIG_TEST_BPF is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
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
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
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
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
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
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA1_SSSE3=m
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
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
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y

--7gLe/sNPhR777EPF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--7gLe/sNPhR777EPF--
