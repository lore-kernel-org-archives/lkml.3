Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaG3OLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:11:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:37987 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbaG3OLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:11:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,764,1400050800"; 
   d="log'?scan'208";a="569463433"
Date: Wed, 30 Jul 2014 22:11:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [x86,kaslr] [ 0.000000] BUG: unable to handle kernel NULL pointer
 dereference at 00000000000006fc
Message-ID: <20140730141109.GO16537@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="V2tfspbppmK1TQo2"
Content-Disposition: inline
In-Reply-To: <20140730140507.GM16537@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V2tfspbppmK1TQo2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andy,

FYI, one more BUG message for commit

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

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================
Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+----------------------------------------------------------+------------+------------+------------------+
|                                                          | c6f07a6360 | d07c7f1ed6 | v3.16-rc5_071701 |
+----------------------------------------------------------+------------+------------+------------------+
| boot_successes                                           | 1139       | 200        | 11               |
| boot_failures                                            | 61         | 100        | 10               |
| BUG:kernel_boot_hang                                     | 61         | 56         | 6                |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference     | 0          | 44         | 4                |
| Oops                                                     | 0          | 44         | 4                |
| RIP:__free_pages_bootmem                                 | 0          | 44         | 4                |
| Kernel_panic-not_syncing:Attempted_to_kill_the_idle_task | 0          | 44         | 4                |
| backtrace:free_all_bootmem                               | 0          | 44         | 4                |
| backtrace:mem_init                                       | 0          | 44         | 4                |
+----------------------------------------------------------+------------+------------+------------------+

[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x0
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at 00000000000006fc
[    0.000000] IP: [<ffffffff81cb4108>] __free_pages_bootmem+0x21/0x9d
[    0.000000] PGD 0 
[    0.000000] Oops: 0002 [#1] 
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc5-00004-gd07c7f1 #1
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] task: ffffffff81a1a4c0 ti: ffffffff81a00000 task.ti: ffffffff81a00000
[    0.000000] RIP: 0010:[<ffffffff81cb4108>]  [<ffffffff81cb4108>] __free_pages_bootmem+0x21/0x9d
[    0.000000] RSP: 0000:ffffffff81a03ed8  EFLAGS: 00010012
[    0.000000] RAX: 0000000000000734 RBX: 0000000000000010 RCX: 0000000000000004
[    0.000000] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000000006fc
[    0.000000] RBP: ffffffff81a03f00 R08: 000000000000000f R09: 0000000000000010
[    0.000000] R10: 000000000000001c R11: 000000000009f000 R12: 0000000000000099
[    0.000000] R13: 0000000000000020 R14: 000000000000000a R15: ffffffff81c9b120
[    0.000000] FS:  0000000000000000(0000) GS:ffffffff81a25000(0000) knlGS:0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.000000] CR2: 00000000000006fc CR3: 0000000001a15000 CR4: 00000000000406a0
[    0.000000] Stack:
[    0.000000]  ffffffff81cb6bd3 0000000000000000 ffffffff81d19940 ffff880013ffc140
[    0.000000]  ffffffff81d200a0 ffffffff81a03f38 ffffffff81cb6de3 0000000000000000
[    0.000000]  0000000000010000 0000000000099000 0000000200000000 ffffffffffffffff
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81cb6bd3>] ? __free_memory_core+0xa2/0xb9
[    0.000000]  [<ffffffff81cb6de3>] free_all_bootmem+0x51/0xd2
[    0.000000]  [<ffffffff81cab152>] mem_init+0xe/0x21
[    0.000000]  [<ffffffff81c9be28>] start_kernel+0x1eb/0x4ea
[    0.000000]  [<ffffffff81c9b98c>] ? set_init_arg+0x55/0x55
[    0.000000]  [<ffffffff81c9b5b1>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81c9b725>] x86_64_start_kernel+0x172/0x181
[    0.000000] Code: 89 e5 5d c3 55 48 89 e5 5d c3 40 88 f1 41 b9 01 00 00 00 41 d3 e1 0f 18 0f 31 d2 48 89 f8 45 8d 41 ff eb 15 48 83 c0 38 0f 18 08 <0f> ba 70 c8 0a c7 40 e4 00 00 00 00 ff c2 41 39 d0 77 e6 4d 6b 
[    0.000000] RIP  [<ffffffff81cb4108>] __free_pages_bootmem+0x21/0x9d
[    0.000000]  RSP <ffffffff81a03ed8>
[    0.000000] CR2: 00000000000006fc
[    0.000000] ---[ end trace 87d1642ee2ad5638 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!

git bisect start 5e60c2af7a8bde5cfaee8ffd77cfc5b62db0a04e 1795cd9b3a91d4b5473c97f491d63892442212ab --
git bisect good bc1f2f93f68bccd988af7e6f73384860ac241b78  # 07:33    300+    123  Merge 'socfpga-nex/nios2-upstream' into devel-hourly-2014071701
git bisect  bad 0d7e1ca40ef16fce5297579121717fc793761b38  # 07:33      0-    123  Merge 'dynticks/nohz/sysidle' into devel-hourly-2014071701
git bisect good 33c13bf2487a42efa1ac9bcce5623ab74a375c93  # 07:37    300+     30  Merge 'ubifs/linux-next' into devel-hourly-2014071701
git bisect good 1032f73a32951d7f14ed7fdadedb0fef3c6d0f49  # 07:43    300+      0  Merge 'spi/for-next' into devel-hourly-2014071701
git bisect  bad 1f2859f0786338fe4c2a18ea518a5b2a2f1b5491  # 08:01     16-     82  Merge 'shawnguo/for-next' into devel-hourly-2014071701
git bisect good 73c47688a039158a6d395629d3ab32e606e13d1a  # 08:27    300+     26  Merge 'regulator/for-next' into devel-hourly-2014071701
git bisect  bad b973fdf5e6e6fe84b51f79919e5dc8574ae859da  # 08:38      1-     32  Merge 'luto/sync_rand_seed' into devel-hourly-2014071701
git bisect good 5778e65d5ca52bebbaa023e177d863e44f098e96  # 08:44    300+      0  random,x86: Add arch_get_slow_rng_u64
git bisect  bad d07c7f1ed61789e175fa975134855be32263be2c  # 08:52      0-      1  x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available
git bisect good c6f07a63601fbb36c09bf250b5538abb47b51e44  # 09:04    300+     58  random: Seed pools from arch_get_slow_rng_u64 at startup
# first bad commit: [d07c7f1ed61789e175fa975134855be32263be2c] x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available
git bisect good c6f07a63601fbb36c09bf250b5538abb47b51e44  # 09:10    900+     61  random: Seed pools from arch_get_slow_rng_u64 at startup
git bisect  bad 5e60c2af7a8bde5cfaee8ffd77cfc5b62db0a04e  # 09:10      0-     10  0day head guard for 'devel-hourly-2014071701'
git bisect good b6603fe574af289dbe9eb9fb4c540bca04f5a053  # 09:49    900+    104  Merge tag 'for-linus-20140716' of git://git.infradead.org/linux-mtd
git bisect good d4f4d1d45cd1b9aa60e61c2eab25a5d9a79a26f3  # 10:06    900+      5  Add linux-next specific files for 20140716


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

--V2tfspbppmK1TQo2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-kbuild-30:20140717085020:x86_64-randconfig-s1-07170206:3.16.0-rc5-00004-gd07c7f1:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc5-00004-gd07c7f1 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 Thu Jul 17 16:51:00 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-07170206/linux-devel:=
devel-hourly-2014071701:d07c7f1ed61789e175fa975134855be32263be2c:bisect-lin=
ux-7/.vmlinuz-d07c7f1ed61789e175fa975134855be32263be2c-20140717165128-196-k=
build branch=3Dlinux-devel/devel-hourly-2014071701 BOOT_IMAGE=3D/kernel/x86=
_64-randconfig-s1-07170206/d07c7f1ed61789e175fa975134855be32263be2c/vmlinuz=
-3.16.0-rc5-00004-gd07c7f1 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] BRK [0x02c32000, 0x02c32fff] PGTABLE
[    0.000000] BRK [0x02c33000, 0x02c33fff] PGTABLE
[    0.000000] BRK [0x02c34000, 0x02c34fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x02c35000, 0x02c35fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x02c36000, 0x02c36fff] PGTABLE
[    0.000000] BRK [0x02c37000, 0x02c37fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
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
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
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
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] Processors: 1
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-07170206/linux=
-devel:devel-hourly-2014071701:d07c7f1ed61789e175fa975134855be32263be2c:bis=
ect-linux-7/.vmlinuz-d07c7f1ed61789e175fa975134855be32263be2c-2014071716512=
8-196-kbuild branch=3Dlinux-devel/devel-hourly-2014071701 BOOT_IMAGE=3D/ker=
nel/x86_64-randconfig-s1-07170206/d07c7f1ed61789e175fa975134855be32263be2c/=
vmlinuz-3.16.0-rc5-00004-gd07c7f1 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x0
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at 000=
00000000006fc
[    0.000000] IP: [<ffffffff81cb4108>] __free_pages_bootmem+0x21/0x9d
[    0.000000] PGD 0=20
[    0.000000] Oops: 0002 [#1]=20
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc5-00004-gd0=
7c7f1 #1
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] task: ffffffff81a1a4c0 ti: ffffffff81a00000 task.ti: fffffff=
f81a00000
[    0.000000] RIP: 0010:[<ffffffff81cb4108>]  [<ffffffff81cb4108>] __free_=
pages_bootmem+0x21/0x9d
[    0.000000] RSP: 0000:ffffffff81a03ed8  EFLAGS: 00010012
[    0.000000] RAX: 0000000000000734 RBX: 0000000000000010 RCX: 00000000000=
00004
[    0.000000] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000000=
006fc
[    0.000000] RBP: ffffffff81a03f00 R08: 000000000000000f R09: 00000000000=
00010
[    0.000000] R10: 000000000000001c R11: 000000000009f000 R12: 00000000000=
00099
[    0.000000] R13: 0000000000000020 R14: 000000000000000a R15: ffffffff81c=
9b120
[    0.000000] FS:  0000000000000000(0000) GS:ffffffff81a25000(0000) knlGS:=
0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.000000] CR2: 00000000000006fc CR3: 0000000001a15000 CR4: 00000000000=
406a0
[    0.000000] Stack:
[    0.000000]  ffffffff81cb6bd3 0000000000000000 ffffffff81d19940 ffff8800=
13ffc140
[    0.000000]  ffffffff81d200a0 ffffffff81a03f38 ffffffff81cb6de3 00000000=
00000000
[    0.000000]  0000000000010000 0000000000099000 0000000200000000 ffffffff=
ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81cb6bd3>] ? __free_memory_core+0xa2/0xb9
[    0.000000]  [<ffffffff81cb6de3>] free_all_bootmem+0x51/0xd2
[    0.000000]  [<ffffffff81cab152>] mem_init+0xe/0x21
[    0.000000]  [<ffffffff81c9be28>] start_kernel+0x1eb/0x4ea
[    0.000000]  [<ffffffff81c9b98c>] ? set_init_arg+0x55/0x55
[    0.000000]  [<ffffffff81c9b5b1>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81c9b725>] x86_64_start_kernel+0x172/0x181
[    0.000000] Code: 89 e5 5d c3 55 48 89 e5 5d c3 40 88 f1 41 b9 01 00 00 =
00 41 d3 e1 0f 18 0f 31 d2 48 89 f8 45 8d 41 ff eb 15 48 83 c0 38 0f 18 08 =
<0f> ba 70 c8 0a c7 40 e4 00 00 00 00 ff c2 41 39 d0 77 e6 4d 6b=20
[    0.000000] RIP  [<ffffffff81cb4108>] __free_pages_bootmem+0x21/0x9d
[    0.000000]  RSP <ffffffff81a03ed8>
[    0.000000] CR2: 00000000000006fc
[    0.000000] ---[ end trace 87d1642ee2ad5638 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] Rebooting in 10 seconds..
Elapsed time: 10
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86=
_64-randconfig-s1-07170206/d07c7f1ed61789e175fa975134855be32263be2c/vmlinuz=
-3.16.0-rc5-00004-gd07c7f1 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-07170206/linux=
-devel:devel-hourly-2014071701:d07c7f1ed61789e175fa975134855be32263be2c:bis=
ect-linux-7/.vmlinuz-d07c7f1ed61789e175fa975134855be32263be2c-2014071716512=
8-196-kbuild branch=3Dlinux-devel/devel-hourly-2014071701 BOOT_IMAGE=3D/ker=
nel/x86_64-randconfig-s1-07170206/d07c7f1ed61789e175fa975134855be32263be2c/=
vmlinuz-3.16.0-rc5-00004-gd07c7f1 drbd.minor_count=3D8'  -initrd /kernel-te=
sts/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3D=
e1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rt=
c base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-kbuild-30 -serial fi=
le:/dev/shm/kboot/serial-quantal-kbuild-30 -daemonize -display none -monito=
r null=20

--V2tfspbppmK1TQo2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-100:20140717090131:x86_64-randconfig-s1-07170206::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc5-00003-gc6f07a6 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #2 Thu Jul 17 16:59:32 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-07170206/linux-devel:=
devel-hourly-2014071701:c6f07a63601fbb36c09bf250b5538abb47b51e44:bisect-lin=
ux-7/.vmlinuz-c6f07a63601fbb36c09bf250b5538abb47b51e44-20140717165951-191-i=
vb41 branch=3Dlinux-devel/devel-hourly-2014071701 BOOT_IMAGE=3D/kernel/x86_=
64-randconfig-s1-07170206/c6f07a63601fbb36c09bf250b5538abb47b51e44/vmlinuz-=
3.16.0-rc5-00003-gc6f07a6 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02c32000, 0x02c32fff] PGTABLE
[    0.000000] BRK [0x02c33000, 0x02c33fff] PGTABLE
[    0.000000] BRK [0x02c34000, 0x02c34fff] PGTABLE
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
[    0.000000] BRK [0x02c35000, 0x02c35fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFF1C0 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE040 001180 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FFE000 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF234 00093E (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFFB72 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFFBF2 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1a2c1c0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-07170206/linux=
-devel:devel-hourly-2014071701:c6f07a63601fbb36c09bf250b5538abb47b51e44:bis=
ect-linux-7/.vmlinuz-c6f07a63601fbb36c09bf250b5538abb47b51e44-2014071716595=
1-191-ivb41 branch=3Dlinux-devel/devel-hourly-2014071701 BOOT_IMAGE=3D/kern=
el/x86_64-randconfig-s1-07170206/c6f07a63601fbb36c09bf250b5538abb47b51e44/v=
mlinuz-3.16.0-rc5-00003-gc6f07a6 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 268488K/327280K available (5685K kernel code, 2661K =
rwdata, 3028K rodata, 784K init, 15176K bss, 58792K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc5-00003-gc6f07a6 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #2 Thu Jul 17 16:59:32 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-07170206/linux-devel:=
devel-hourly-2014071701:c6f07a63601fbb36c09bf250b5538abb47b51e44:bisect-lin=
ux-7/.vmlinuz-c6f07a63601fbb36c09bf250b5538abb47b51e44-20140717165951-191-i=
vb41 branch=3Dlinux-devel/devel-hourly-2014071701 BOOT_IMAGE=3D/kernel/x86_=
64-randconfig-s1-07170206/c6f07a63601fbb36c09bf250b5538abb47b51e44/vmlinuz-=
3.16.0-rc5-00003-gc6f07a6 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02c32000, 0x02c32fff] PGTABLE
[    0.000000] BRK [0x02c33000, 0x02c33fff] PGTABLE
[    0.000000] BRK [0x02c34000, 0x02c34fff] PGTABLE
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
[    0.000000] BRK [0x02c35000, 0x02c35fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFF1C0 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE040 001180 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FFE000 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF234 00093E (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFFB72 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFFBF2 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1a2c1c0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-07170206/linux=
-devel:devel-hourly-2014071701:c6f07a63601fbb36c09bf250b5538abb47b51e44:bis=
ect-linux-7/.vmlinuz-c6f07a63601fbb36c09bf250b5538abb47b51e44-2014071716595=
1-191-ivb41 branch=3Dlinux-devel/devel-hourly-2014071701 BOOT_IMAGE=3D/kern=
el/x86_64-randconfig-s1-07170206/c6f07a63601fbb36c09bf250b5538abb47b51e44/v=
mlinuz-3.16.0-rc5-00003-gc6f07a6 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 268488K/327280K available (5685K kernel code, 2661K =
rwdata, 3028K rodata, 784K init, 15176K bss, 58792K reserved)
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  memory used by lock dependency info: 8671 kB
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

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.510 MHz processor
[    0.000000] tsc: Detected 2693.510 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 5387.02 Bogo=
MIPS (lpj=3D2693510)
5387.02 BogoMIPS (lpj=3D2693510)
[    0.004006] pid_max: default: 4096 minimum: 301
[    0.004006] pid_max: default: 4096 minimum: 301
[    0.005030] ACPI: Core revision 20140424
[    0.005030] ACPI: Core revision 20140424
[    0.008910] ACPI:=20
[    0.008910] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.010165] Security Framework initialized
[    0.010165] Security Framework initialized
[    0.010998] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.010998] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.011013] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.011013] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.013471] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013471] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.013471] tlb_flushall_shift: -1
[    0.013471] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013471] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.013471] tlb_flushall_shift: -1
[    0.014007] CPU:=20
[    0.014007] CPU: GenuineIntel GenuineIntel Common KVM processorCommon KV=
M processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.018977] Performance Events:=20
[    0.018977] Performance Events: no PMU driver, software events only.
no PMU driver, software events only.
[    0.021498] Getting VERSION: 1050014
[    0.021498] Getting VERSION: 1050014
[    0.022009] Getting VERSION: 1050014
[    0.022009] Getting VERSION: 1050014
[    0.023006] Getting ID: 0
[    0.023006] Getting ID: 0
[    0.023517] Getting ID: ff000000
[    0.023517] Getting ID: ff000000
[    0.024000] Getting LVT0: 8700
[    0.024000] Getting LVT0: 8700
[    0.024006] Getting LVT1: 8400
[    0.024006] Getting LVT1: 8400
[    0.025029] enabled ExtINT on CPU#0
[    0.025029] enabled ExtINT on CPU#0
[    0.027315] ENABLING IO-APIC IRQs
[    0.027315] ENABLING IO-APIC IRQs
[    0.028005] init IO_APIC IRQs
[    0.028005] init IO_APIC IRQs
[    0.028599]  apic 0 pin 0 not connected
[    0.028599]  apic 0 pin 0 not connected
[    0.029041] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.029041] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.030040] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.030040] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.031038] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.031038] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.032025] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.032025] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.033024] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.033024] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.034022] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.034022] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.035021] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.035021] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.036022] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.036022] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.038031] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.038031] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.040010] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.040010] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.041023] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.041023] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.042021] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.042021] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.044026] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.044026] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.045023] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.045023] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.046022] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.046022] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.047023]  apic 0 pin 16 not connected
[    0.047023]  apic 0 pin 16 not connected
[    0.048004]  apic 0 pin 17 not connected
[    0.048004]  apic 0 pin 17 not connected
[    0.049005]  apic 0 pin 18 not connected
[    0.049005]  apic 0 pin 18 not connected
[    0.050003]  apic 0 pin 19 not connected
[    0.050003]  apic 0 pin 19 not connected
[    0.051003]  apic 0 pin 20 not connected
[    0.051003]  apic 0 pin 20 not connected
[    0.052006]  apic 0 pin 21 not connected
[    0.052006]  apic 0 pin 21 not connected
[    0.053004]  apic 0 pin 22 not connected
[    0.053004]  apic 0 pin 22 not connected
[    0.053754]  apic 0 pin 23 not connected
[    0.053754]  apic 0 pin 23 not connected
[    0.054164] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.054164] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.055007] Using local APIC timer interrupts.
[    0.055007] calibrating APIC timer ...
[    0.055007] Using local APIC timer interrupts.
[    0.055007] calibrating APIC timer ...
[    0.057000] ... lapic delta =3D 6249924
[    0.057000] ... lapic delta =3D 6249924
[    0.057000] ... PM-Timer delta =3D 357958
[    0.057000] ... PM-Timer delta =3D 357958
[    0.057000] ... PM-Timer result ok
[    0.057000] ... PM-Timer result ok
[    0.057000] ..... delta 6249924
[    0.057000] ..... delta 6249924
[    0.057000] ..... mult: 268432191
[    0.057000] ..... mult: 268432191
[    0.057000] ..... calibration result: 999987
[    0.057000] ..... calibration result: 999987
[    0.057000] ..... CPU clock speed is 2693.0454 MHz.
[    0.057000] ..... CPU clock speed is 2693.0454 MHz.
[    0.057000] ..... host bus clock speed is 999.0987 MHz.
[    0.057000] ..... host bus clock speed is 999.0987 MHz.
[    0.057580] devtmpfs: initialized
[    0.057580] devtmpfs: initialized
[    0.061278] prandom: seed boundary self test passed
[    0.061278] prandom: seed boundary self test passed
[    0.063322] prandom: 100 self tests passed
[    0.063322] prandom: 100 self tests passed
[    0.065158] regulator-dummy: no parameters
[    0.065158] regulator-dummy: no parameters
[    0.066244] NET: Registered protocol family 16
[    0.066244] NET: Registered protocol family 16
[    0.067374] cpuidle: using governor ladder
[    0.067374] cpuidle: using governor ladder
[    0.068007] cpuidle: using governor menu
[    0.068007] cpuidle: using governor menu
[    0.069182] ACPI: bus type PCI registered
[    0.069182] ACPI: bus type PCI registered
[    0.071051] PCI: Using configuration type 1 for base access
[    0.071051] PCI: Using configuration type 1 for base access
[    0.075829] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.075829] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.076038] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.076038] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.077060] ACPI: Added _OSI(Module Device)
[    0.077060] ACPI: Added _OSI(Module Device)
[    0.078004] ACPI: Added _OSI(Processor Device)
[    0.078004] ACPI: Added _OSI(Processor Device)
[    0.079005] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.079005] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.080005] ACPI: Added _OSI(Processor Aggregator Device)
[    0.080005] ACPI: Added _OSI(Processor Aggregator Device)
[    0.087413] ACPI: Interpreter enabled
[    0.087413] ACPI: Interpreter enabled
[    0.088013] ACPI: (supports S0 S5)
[    0.088013] ACPI: (supports S0 S5)
[    0.089003] ACPI: Using IOAPIC for interrupt routing
[    0.089003] ACPI: Using IOAPIC for interrupt routing
[    0.090045] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.090045] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.100033] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.100033] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.101011] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.101011] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.103060] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.103060] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.104404] PCI host bridge to bus 0000:00
[    0.104404] PCI host bridge to bus 0000:00
[    0.105007] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.105007] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.106005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.106005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.107005] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.107005] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.108005] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.108005] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.109007] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.109007] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.110007] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.110007] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.111018] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.111018] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.112007] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.112007] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.113110] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.113110] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.115071] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.115071] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.116607] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.116607] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.119788] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.119788] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.121427] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.121427] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.122005] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.122005] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.123005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.123005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.124005] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.124005] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.126086] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.126086] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.127357] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.127357] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.128018] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.128018] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.129379] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.129379] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.131467] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.131467] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.133010] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.133010] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.138461] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.138461] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.139632] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.139632] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.141007] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.141007] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.143006] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.143006] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.148465] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.148465] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.149479] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.149479] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.150453] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.150453] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.155251] pci_bus 0000:00: on NUMA node 0
[    0.155251] pci_bus 0000:00: on NUMA node 0
[    0.157700] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.157700] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.158703] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.158703] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.160192] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.160192] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.162574] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.162574] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.164064] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.164064] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.166986] ACPI:=20
[    0.166986] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.167868] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.167868] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.168006] vgaarb: loaded
[    0.168006] vgaarb: loaded
[    0.169003] vgaarb: bridge control possible 0000:00:02.0
[    0.169003] vgaarb: bridge control possible 0000:00:02.0
[    0.170356] SCSI subsystem initialized
[    0.170356] SCSI subsystem initialized
[    0.171054] libata version 3.00 loaded.
[    0.171054] libata version 3.00 loaded.
[    0.172032] ACPI: bus type USB registered
[    0.172032] ACPI: bus type USB registered
[    0.173109] usbcore: registered new interface driver usbfs
[    0.173109] usbcore: registered new interface driver usbfs
[    0.174050] usbcore: registered new interface driver hub
[    0.174050] usbcore: registered new interface driver hub
[    0.175126] usbcore: registered new device driver usb
[    0.175126] usbcore: registered new device driver usb
[    0.176371] PCI: Using ACPI for IRQ routing
[    0.176371] PCI: Using ACPI for IRQ routing
[    0.177006] PCI: pci_cache_line_size set to 64 bytes
[    0.177006] PCI: pci_cache_line_size set to 64 bytes
[    0.178116] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.178116] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.179013] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.179013] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.180670] Switched to clocksource kvm-clock
[    0.180670] Switched to clocksource kvm-clock
[    0.201352] pnp: PnP ACPI init
[    0.201352] pnp: PnP ACPI init
[    0.202506] ACPI: bus type PNP registered
[    0.202506] ACPI: bus type PNP registered
[    0.203996] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.203996] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.206785] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.206785] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.209047] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.209047] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.211787] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.211787] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.214039] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.214039] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.216828] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.216828] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.219085] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.219085] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.221745] pnp 00:03: [dma 2]
[    0.221745] pnp 00:03: [dma 2]
[    0.222838] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.222838] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.225102] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.225102] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.227834] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.227834] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.230102] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.230102] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.232824] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.232824] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.235477] pnp: PnP ACPI: found 6 devices
[    0.235477] pnp: PnP ACPI: found 6 devices
[    0.236869] ACPI: bus type PNP unregistered
[    0.236869] ACPI: bus type PNP unregistered
[    0.243572] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.243572] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.245500] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.245500] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.247342] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.247342] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.249233] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.249233] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.251107] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.251107] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.252424] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.252424] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.253731] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.253731] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.255069] NET: Registered protocol family 1
[    0.255069] NET: Registered protocol family 1
[    0.256097] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.256097] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.257432] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.257432] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.259375] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.259375] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.260844] pci 0000:00:02.0: Boot video device
[    0.260844] pci 0000:00:02.0: Boot video device
[    0.262400] PCI: CLS 0 bytes, default 64
[    0.262400] PCI: CLS 0 bytes, default 64
[    0.263763] Unpacking initramfs...
[    0.263763] Unpacking initramfs...
[    1.052918] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013=
ff0000)
[    1.052918] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013=
ff0000)
[    1.055893] microcode: no support for this CPU vendor
[    1.055893] microcode: no support for this CPU vendor
[    1.058229] cryptomgr_test (19) used greatest stack depth: 14392 bytes l=
eft
[    1.058229] cryptomgr_test (19) used greatest stack depth: 14392 bytes l=
eft
[    1.060974] cryptomgr_test (20) used greatest stack depth: 13496 bytes l=
eft
[    1.060974] cryptomgr_test (20) used greatest stack depth: 13496 bytes l=
eft
[    1.065751] cryptomgr_test (36) used greatest stack depth: 13368 bytes l=
eft
[    1.065751] cryptomgr_test (36) used greatest stack depth: 13368 bytes l=
eft
[    1.068463] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    1.068463] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    1.070740] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.070740] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.072960] AVX or AES-NI instructions are not detected.
[    1.072960] AVX or AES-NI instructions are not detected.
[    1.074723] AVX instructions are not detected.
[    1.074723] AVX instructions are not detected.
[    1.076195] AVX instructions are not detected.
[    1.076195] AVX instructions are not detected.
[    1.077720] AVX instructions are not detected.
[    1.077720] AVX instructions are not detected.
[    1.079223] AVX instructions are not detected.
[    1.079223] AVX instructions are not detected.
[    1.080616] AVX2 or AES-NI instructions are not detected.
[    1.080616] AVX2 or AES-NI instructions are not detected.
[    1.082332] AVX2 instructions are not detected.
[    1.082332] AVX2 instructions are not detected.
[    1.084303] futex hash table entries: 16 (order: -2, 1536 bytes)
[    1.084303] futex hash table entries: 16 (order: -2, 1536 bytes)
[    1.086108] Initialise system trusted keyring
[    1.086108] Initialise system trusted keyring
[    1.087669] Kprobe smoke test started
[    1.087669] Kprobe smoke test started
[    1.095123] Kprobe smoke test passed successfully
[    1.095123] Kprobe smoke test passed successfully
[    1.098506] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    1.098506] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    1.100792] fuse init (API version 7.23)
[    1.100792] fuse init (API version 7.23)
[    1.102802] msgmni has been set to 569
[    1.102802] msgmni has been set to 569
[    1.107019] alg: No test for lz4 (lz4-generic)
[    1.107019] alg: No test for lz4 (lz4-generic)
[    1.109194] alg: No test for stdrng (krng)
[    1.109194] alg: No test for stdrng (krng)
[    1.122691] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    1.122691] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    1.125511] Key type asymmetric registered
[    1.125511] Key type asymmetric registered
[    1.127450] Asymmetric key parser 'x509' registered
[    1.127450] Asymmetric key parser 'x509' registered
[    1.129773] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    1.129773] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    1.133222] io scheduler noop registered (default)
[    1.133222] io scheduler noop registered (default)
[    1.135456] io scheduler deadline registered
[    1.135456] io scheduler deadline registered
[    1.137448] io scheduler cfq registered
[    1.137448] io scheduler cfq registered
[    1.139234] list_sort_test: start testing list_sort()
[    1.139234] list_sort_test: start testing list_sort()
[    1.142613] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.142613] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.146071] ACPI: Power Button [PWRF]
[    1.146071] ACPI: Power Button [PWRF]
[    1.186011] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.186011] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.188520] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.188520] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.223153] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.223153] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.228189] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.228189] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.232842] [drm] Initialized drm 1.1.0 20060810
[    1.232842] [drm] Initialized drm 1.1.0 20060810
[    1.235081] dummy-irq: no IRQ given.  Use irq=3DN
[    1.235081] dummy-irq: no IRQ given.  Use irq=3DN
[    1.237344] mic_init not running on X100 ret -19
[    1.237344] mic_init not running on X100 ret -19
[    1.240113] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    1.240113] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    1.243065] osst :I: Tape driver with OnStream support version 0.99.4
[    1.243065] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    1.243065] osst :I: Tape driver with OnStream support version 0.99.4
[    1.243065] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    1.250090] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    1.250090] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    1.253763] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.253763] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.256415] ehci-pci: EHCI PCI platform driver
[    1.256415] ehci-pci: EHCI PCI platform driver
[    1.257993] ehci-platform: EHCI generic platform driver
[    1.257993] ehci-platform: EHCI generic platform driver
[    1.260146] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    1.260146] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    1.262179] usbcore: registered new interface driver cdc_acm
[    1.262179] usbcore: registered new interface driver cdc_acm
[    1.264029] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    1.264029] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    1.266794] usbcore: registered new interface driver usbtmc
[    1.266794] usbcore: registered new interface driver usbtmc
[    1.268745] usbcore: registered new interface driver mdc800
[    1.268745] usbcore: registered new interface driver mdc800
[    1.270551] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    1.270551] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    1.273261] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    1.273261] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    1.275811] usbcore: registered new interface driver idmouse
[    1.275811] usbcore: registered new interface driver idmouse
[    1.277816] usbcore: registered new interface driver iowarrior
[    1.277816] usbcore: registered new interface driver iowarrior
[    1.279925] usbcore: registered new interface driver isight_firmware
[    1.279925] usbcore: registered new interface driver isight_firmware
[    1.282667] usbcore: registered new interface driver usblcd
[    1.282667] usbcore: registered new interface driver usblcd
[    1.284667] usbcore: registered new interface driver trancevibrator
[    1.284667] usbcore: registered new interface driver trancevibrator
[    1.286929] usbcore: registered new interface driver usbsevseg
[    1.286929] usbcore: registered new interface driver usbsevseg
[    1.289123] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.289123] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.293145] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.293145] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.295117] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.295117] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.298280] mousedev: PS/2 mouse device common for all mice
[    1.298280] mousedev: PS/2 mouse device common for all mice
[    1.302167] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.302167] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.306833] usbcore: registered new interface driver usbtouchscreen
[    1.306833] usbcore: registered new interface driver usbtouchscreen
[    1.310049] usbcore: registered new interface driver sur40
[    1.310049] usbcore: registered new interface driver sur40
[    1.312267] cm109: Keymap for Komunikate KIP1000 phone loaded
[    1.312267] cm109: Keymap for Komunikate KIP1000 phone loaded
[    1.314877] usbcore: registered new interface driver cm109
[    1.314877] usbcore: registered new interface driver cm109
[    1.317355] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    1.317355] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    1.320886] i2c-parport-light: adapter type unspecified
[    1.320886] i2c-parport-light: adapter type unspecified
[    1.322930] usbcore: registered new interface driver i2c-tiny-usb
[    1.322930] usbcore: registered new interface driver i2c-tiny-usb
[    1.325468] Driver for 1-wire Dallas network protocol.
[    1.325468] Driver for 1-wire Dallas network protocol.
[    1.327813] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    1.327813] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    1.330835] acquirewdt: I/O address 0x0043 already in use
[    1.330835] acquirewdt: I/O address 0x0043 already in use
[    1.332867] acquirewdt: probe of acquirewdt failed with error -5
[    1.332867] acquirewdt: probe of acquirewdt failed with error -5
[    1.335060] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    1.335060] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    1.338202] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    1.338202] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    1.340565] it87_wdt: no device
[    1.340565] it87_wdt: no device
[    1.341788] pc87413_wdt: Version 1.1 at io 0x2E
[    1.341788] pc87413_wdt: Version 1.1 at io 0x2E
[    1.343233] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    1.343233] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    1.345643] sbc60xxwdt: I/O address 0x0443 already in use
[    1.345643] sbc60xxwdt: I/O address 0x0443 already in use
[    1.347496] w83877f_wdt: I/O address 0x0443 already in use
[    1.347496] w83877f_wdt: I/O address 0x0443 already in use
[    1.349830] hidraw: raw HID events driver (C) Jiri Kosina
[    1.349830] hidraw: raw HID events driver (C) Jiri Kosina
[    1.352363] usbcore: registered new interface driver usbmouse
[    1.352363] usbcore: registered new interface driver usbmouse
[    1.354874]=20
[    1.354874] printing PIC contents
[    1.354874]=20
[    1.354874] printing PIC contents
[    1.356602] ... PIC  IMR: ffff
[    1.356602] ... PIC  IMR: ffff
[    1.357589] ... PIC  IRR: 1013
[    1.357589] ... PIC  IRR: 1013
[    1.358692] ... PIC  ISR: 0000
[    1.358692] ... PIC  ISR: 0000
[    1.359832] ... PIC ELCR: 0c00
[    1.359832] ... PIC ELCR: 0c00
[    1.360928] printing local APIC contents on CPU#0/0:
[    1.360928] printing local APIC contents on CPU#0/0:
[    1.361922] ... APIC ID:      00000000 (0)
[    1.361922] ... APIC ID:      00000000 (0)
[    1.361922] ... APIC VERSION: 01050014
[    1.361922] ... APIC VERSION: 01050014
[    1.361922] ... APIC TASKPRI: 00000000 (00)
[    1.361922] ... APIC TASKPRI: 00000000 (00)
[    1.361922] ... APIC PROCPRI: 00000000
[    1.361922] ... APIC PROCPRI: 00000000
[    1.361922] ... APIC LDR: 01000000
[    1.361922] ... APIC LDR: 01000000
[    1.361922] ... APIC DFR: ffffffff
[    1.361922] ... APIC DFR: ffffffff
[    1.361922] ... APIC SPIV: 000001ff
[    1.361922] ... APIC SPIV: 000001ff
[    1.361922] ... APIC ISR field:
[    1.361922] ... APIC ISR field:
[    1.361922] 00000000
[    1.361922] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    1.361922] ... APIC TMR field:
[    1.361922] ... APIC TMR field:
[    1.361922] 00000000
[    1.361922] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    1.361922] ... APIC IRR field:
[    1.361922] ... APIC IRR field:
[    1.361922] 00000000
[    1.361922] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    1.361922] ... APIC ESR: 00000000
[    1.361922] ... APIC ESR: 00000000
[    1.361922] ... APIC ICR: 00000831
[    1.361922] ... APIC ICR: 00000831
[    1.361922] ... APIC ICR2: 01000000
[    1.361922] ... APIC ICR2: 01000000
[    1.361922] ... APIC LVTT: 000200ef
[    1.361922] ... APIC LVTT: 000200ef
[    1.361922] ... APIC LVTPC: 00010000
[    1.361922] ... APIC LVTPC: 00010000
[    1.361922] ... APIC LVT0: 00010700
[    1.361922] ... APIC LVT0: 00010700
[    1.361922] ... APIC LVT1: 00000400
[    1.361922] ... APIC LVT1: 00000400
[    1.361922] ... APIC LVTERR: 000000fe
[    1.361922] ... APIC LVTERR: 000000fe
[    1.361922] ... APIC TMICT: 0000f423
[    1.361922] ... APIC TMICT: 0000f423
[    1.361922] ... APIC TMCCT: 0000643f
[    1.361922] ... APIC TMCCT: 0000643f
[    1.361922] ... APIC TDCR: 00000003
[    1.361922] ... APIC TDCR: 00000003
[    1.361922]=20
[    1.361922]=20
[    1.397594] number of MP IRQ sources: 15.
[    1.397594] number of MP IRQ sources: 15.
[    1.399418] number of IO-APIC #0 registers: 24.
[    1.399418] number of IO-APIC #0 registers: 24.
[    1.401526] testing the IO APIC.......................
[    1.401526] testing the IO APIC.......................
[    1.403920] IO APIC #0......
[    1.403920] IO APIC #0......
[    1.405241] .... register #00: 00000000
[    1.405241] .... register #00: 00000000
[    1.407022] .......    : physical APIC id: 00
[    1.407022] .......    : physical APIC id: 00
[    1.409015] .......    : Delivery Type: 0
[    1.409015] .......    : Delivery Type: 0
[    1.410857] .......    : LTS          : 0
[    1.410857] .......    : LTS          : 0
[    1.412698] .... register #01: 00170011
[    1.412698] .... register #01: 00170011
[    1.414496] .......     : max redirection entries: 17
[    1.414496] .......     : max redirection entries: 17
[    1.416805] .......     : PRQ implemented: 0
[    1.416805] .......     : PRQ implemented: 0
[    1.418784] .......     : IO APIC version: 11
[    1.418784] .......     : IO APIC version: 11
[    1.420767] .... register #02: 00000000
[    1.420767] .... register #02: 00000000
[    1.422542] .......     : arbitration: 00
[    1.422542] .......     : arbitration: 00
[    1.424345] .... IRQ redirection table:
[    1.424345] .... IRQ redirection table:
[    1.426147] 1    0    0   0   0    0    0    00
[    1.426147] 1    0    0   0   0    0    0    00
[    1.428273] 0    0    0   0   0    1    1    31
[    1.428273] 0    0    0   0   0    1    1    31
[    1.430348] 0    0    0   0   0    1    1    30
[    1.430348] 0    0    0   0   0    1    1    30
[    1.432419] 0    0    0   0   0    1    1    33
[    1.432419] 0    0    0   0   0    1    1    33
[    1.434531] 1    0    0   0   0    1    1    34
[    1.434531] 1    0    0   0   0    1    1    34
[    1.436642] 1    1    0   0   0    1    1    35
[    1.436642] 1    1    0   0   0    1    1    35
[    1.438742] 0    0    0   0   0    1    1    36
[    1.438742] 0    0    0   0   0    1    1    36
[    1.440834] 0    0    0   0   0    1    1    37
[    1.440834] 0    0    0   0   0    1    1    37
[    1.442929] 0    0    0   0   0    1    1    38
[    1.442929] 0    0    0   0   0    1    1    38
[    1.445014] 0    1    0   0   0    1    1    39
[    1.445014] 0    1    0   0   0    1    1    39
[    1.447131] 1    1    0   0   0    1    1    3A
[    1.447131] 1    1    0   0   0    1    1    3A
[    1.449206] 1    1    0   0   0    1    1    3B
[    1.449206] 1    1    0   0   0    1    1    3B
[    1.451337] 0    0    0   0   0    1    1    3C
[    1.451337] 0    0    0   0   0    1    1    3C
[    1.453520] 0    0    0   0   0    1    1    3D
[    1.453520] 0    0    0   0   0    1    1    3D
[    1.455595] 0    0    0   0   0    1    1    3E
[    1.455595] 0    0    0   0   0    1    1    3E
[    1.457738] 0    0    0   0   0    1    1    3F
[    1.457738] 0    0    0   0   0    1    1    3F
[    1.459844] 1    0    0   0   0    0    0    00
[    1.459844] 1    0    0   0   0    0    0    00
[    1.461936] 1    0    0   0   0    0    0    00
[    1.461936] 1    0    0   0   0    0    0    00
[    1.464059] 1    0    0   0   0    0    0    00
[    1.464059] 1    0    0   0   0    0    0    00
[    1.466233] 1    0    0   0   0    0    0    00
[    1.466233] 1    0    0   0   0    0    0    00
[    1.468341] 1    0    0   0   0    0    0    00
[    1.468341] 1    0    0   0   0    0    0    00
[    1.470411] 1    0    0   0   0    0    0    00
[    1.470411] 1    0    0   0   0    0    0    00
[    1.472519] 1    0    0   0   0    0    0    00
[    1.472519] 1    0    0   0   0    0    0    00
[    1.474650] 1    0    0   0   0    0    0    00
[    1.474650] 1    0    0   0   0    0    0    00
[    1.476740] IRQ to pin mappings:
[    1.476740] IRQ to pin mappings:
[    1.478204] IRQ0=20
[    1.478204] IRQ0 -> 0:2-> 0:2

[    1.479429] IRQ1=20
[    1.479429] IRQ1 -> 0:1-> 0:1

[    1.480619] IRQ3=20
[    1.480619] IRQ3 -> 0:3-> 0:3

[    1.481831] IRQ4=20
[    1.481831] IRQ4 -> 0:4-> 0:4

[    1.483042] IRQ5=20
[    1.483042] IRQ5 -> 0:5-> 0:5

[    1.484229] IRQ6=20
[    1.484229] IRQ6 -> 0:6-> 0:6

[    1.485456] IRQ7=20
[    1.485456] IRQ7 -> 0:7-> 0:7

[    1.486680] IRQ8=20
[    1.486680] IRQ8 -> 0:8-> 0:8

[    1.487888] IRQ9=20
[    1.487888] IRQ9 -> 0:9-> 0:9

[    1.489080] IRQ10=20
[    1.489080] IRQ10 -> 0:10-> 0:10

[    1.490372] IRQ11=20
[    1.490372] IRQ11 -> 0:11-> 0:11

[    1.491644] IRQ12=20
[    1.491644] IRQ12 -> 0:12-> 0:12

[    1.492930] IRQ13=20
[    1.492930] IRQ13 -> 0:13-> 0:13

[    1.494216] IRQ14=20
[    1.494216] IRQ14 -> 0:14-> 0:14

[    1.495487] IRQ15=20
[    1.495487] IRQ15 -> 0:15-> 0:15

[    1.496833] .................................... done.
[    1.496833] .................................... done.
[    1.499522] bootconsole [earlyser0] disabled
[    1.499522] bootconsole [earlyser0] disabled
[    1.501667] Loading compiled-in X.509 certificates
[    1.503942] Loaded X.509 cert 'Magrathea: Glacier signing key: 11ca681fc=
4465066ffc2b5e49d7d4d0a96cb2c59'
[    1.507258] Key type encrypted registered
[    1.509434] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.510889] EDD information not available.
[    1.515865] Freeing unused kernel memory: 784K (ffffffff81c9b000 - fffff=
fff81d5f000)
[    1.517689] Write protecting the kernel read-only data: 10240k
[    1.522616] Freeing unused kernel memory: 448K (ffff880001590000 - ffff8=
80001600000)
[    1.531193] Freeing unused kernel memory: 1068K (ffff8800018f5000 - ffff=
880001a00000)
[    1.544712] random: init urandom read with 4 bits of entropy available
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[    2.297927] tsc: Refined TSC clocksource calibration: 2693.505 MHz
[   11.729074] sock: sock_set_timeout: `trinity-main' (pid 118) tries to se=
t negative timeout
[   12.418951] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[   13.844808] trinity-main (118) used greatest stack depth: 13032 bytes le=
ft

BUG: kernel boot hang
Elapsed time: 35
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s1-07170206/c6f07a63601fbb36c09bf250b5538abb47b51e44/vmlinuz-3.16.0-rc5-00=
003-gc6f07a6 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pani=
c=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 consol=
e=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/k=
build-tests/run-queue/kvm/x86_64-randconfig-s1-07170206/linux-devel:devel-h=
ourly-2014071701:c6f07a63601fbb36c09bf250b5538abb47b51e44:bisect-linux-7/.v=
mlinuz-c6f07a63601fbb36c09bf250b5538abb47b51e44-20140717165951-191-ivb41 br=
anch=3Dlinux-devel/devel-hourly-2014071701 BOOT_IMAGE=3D/kernel/x86_64-rand=
config-s1-07170206/c6f07a63601fbb36c09bf250b5538abb47b51e44/vmlinuz-3.16.0-=
rc5-00003-gc6f07a6 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/quan=
tal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user=
,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocalt=
ime -pidfile /dev/shm/kboot/pid-quantal-ivb41-100 -serial file:/dev/shm/kbo=
ot/serial-quantal-ivb41-100 -daemonize -display none -monitor null=20

--V2tfspbppmK1TQo2
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-s1-07170206-5e60c2af7a8bde5cfaee8ffd77cfc5b62db0a04e-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-86592.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNWU2MGMyYS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA3MTcwMScKZ2l0IGNoZWNrb3V0IDE3OTVjZDliM2E5MWQ0YjU0NzNjOTdm
NDkxZDYzODkyNDQyMjEyYWIKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDcxNzAxOjE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWI6Ymlz
ZWN0LWxpbnV4LTcKCjIwMTQtMDctMTctMDM6MzY6MDIgMTc5NWNkOWIzYTkxZDRiNTQ3M2M5
N2Y0OTFkNjM4OTI0NDIyMTJhYiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi0x
Nzk1Y2Q5YjNhOTFkNGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiCkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xNzk1Y2Q5YjNh
OTFkNGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3
MDIwNi0xNzk1Y2Q5YjNhOTFkNGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEt
Y29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYtMTc5NWNkOWIzYTkxZDRi
NTQ3M2M5N2Y0OTFkNjM4OTI0NDIyMTJhYgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDcxNzAyMDYvMTc5NWNkOWIzYTkxZDRiNTQ3M2M5N2Y0OTFkNjM4OTI0NDIy
MTJhYi92bWxpbnV6LTMuMTYuMC1yYzUKCjIwMTQtMDctMTctMDQ6MTY6MDIgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4JMzEuCTQ1IFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgMTc5
NWNkOWIzYTkxZDRiNTQ3M2M5N2Y0OTFkNjM4OTI0NDIyMTJhYgpnaXQgYmlzZWN0IHN0YXJ0
IDVlNjBjMmFmN2E4YmRlNWNmYWVlOGZmZDc3Y2ZjNWI2MmRiMGEwNGUgMTc5NWNkOWIzYTkx
ZDRiNTQ3M2M5N2Y0OTFkNjM4OTI0NDIyMTJhYiAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFy
LWJpc2VjdDogWyItYiIsICI1ZTYwYzJhZjdhOGJkZTVjZmFlZThmZmQ3N2NmYzViNjJkYjBh
MDRlIiwgIi1nIiwgIjE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWIi
LCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIvYy9i
b290LWJpc2VjdC9saW51eC03L29iai1iaXNlY3QiXQpCaXNlY3Rpbmc6IDYzOTcgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbYmMxZjJm
OTNmNjhiY2NkOTg4YWY3ZTZmNzMzODQ4NjBhYzI0MWI3OF0gTWVyZ2UgJ3NvY2ZwZ2EtbmV4
L25pb3MyLXVwc3RyZWFtJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDcxNzAxCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJp
c2VjdC9saW51eC03L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDcxNzAxOmJjMWYyZjkzZjY4YmNjZDk4OGFmN2U2ZjczMzg0ODYwYWMyNDFi
Nzg6YmlzZWN0LWxpbnV4LTcKCjIwMTQtMDctMTctMDQ6MTg6MzQgYmMxZjJmOTNmNjhiY2Nk
OTg4YWY3ZTZmNzMzODQ4NjBhYzI0MWI3OCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3
MDIwNi1iYzFmMmY5M2Y2OGJjY2Q5ODhhZjdlNmY3MzM4NDg2MGFjMjQxYjc4CkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iYzFm
MmY5M2Y2OGJjY2Q5ODhhZjdlNmY3MzM4NDg2MGFjMjQxYjc4CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNzE3MDIwNi1iYzFmMmY5M2Y2OGJjY2Q5ODhhZjdlNmY3MzM4NDg2MGFjMjQxYjc4Cndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3At
aHN4MDEtY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYtYmMxZjJmOTNm
NjhiY2NkOTg4YWY3ZTZmNzMzODQ4NjBhYzI0MWI3OAprZXJuZWw6IC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDcxNzAyMDYvYmMxZjJmOTNmNjhiY2NkOTg4YWY3ZTZmNzMzODQ4
NjBhYzI0MWI3OC92bWxpbnV6LTMuMTYuMC1yYzUtMDUwMjMtZ2JjMWYyZjkKCjIwMTQtMDct
MTctMDQ6NDM6MzQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLgkxNy4JNDUgU1VD
Q0VTUwoKQmlzZWN0aW5nOiAxMzcyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMSBzdGVwcykKWzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3
OTM3NjFiMzhdIE1lcmdlICdkeW50aWNrcy9ub2h6L3N5c2lkbGUnIGludG8gZGV2ZWwtaG91
cmx5LTIwMTQwNzE3MDEKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTcvb2JqLWJpc2VjdApscyAtYSAv
a2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAy
MDYvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6MGQ3ZTFjYTQwZWYxNmZj
ZTUyOTc1NzkxMjE3MTdmYzc5Mzc2MWIzODpiaXNlY3QtbGludXgtNwoKMjAxNC0wNy0xNy0w
NDo1MTo0MCAwZDdlMWNhNDBlZjE2ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYxYjM4IGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LTBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIx
NzE3ZmM3OTM3NjFiMzgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2LzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3
NjFiMzgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LTBkN2UxY2E0MGVmMTZmY2U1Mjk3
NTc5MTIxNzE3ZmM3OTM3NjFiMzgKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2LzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzgv
dm1saW51ei0zLjE2LjAtcmM1LTA1NjA5LWcwZDdlMWNhCgoyMDE0LTA3LTE3LTA1OjEzOjQw
IGRldGVjdGluZyBib290IHN0YXRlIC4JMjQJMjkJNDUgU1VDQ0VTUwoKQmlzZWN0aW5nOiA3
ODYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBz
KQpbNTg5OGQ4YTcxMGQ5ODczZmM3ZGVmNDJjNzI2N2RkZmE1YzE0Yjc1MF0gTWVyZ2UgJ3N1
bnhpL3N1bnhpLW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4LTcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQwNzE3MDE6NTg5OGQ4YTcxMGQ5ODczZmM3ZGVmNDJjNzI2N2RkZmE1YzE0Yjc1
MDpiaXNlY3QtbGludXgtNwoKMjAxNC0wNy0xNy0wNToxNjowNSA1ODk4ZDhhNzEwZDk4NzNm
YzdkZWY0MmM3MjY3ZGRmYTVjMTRiNzUwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcw
MjA2LTU4OThkOGE3MTBkOTg3M2ZjN2RlZjQyYzcyNjdkZGZhNWMxNGI3NTAKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzU4OThk
OGE3MTBkOTg3M2ZjN2RlZjQyYzcyNjdkZGZhNWMxNGI3NTAKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA3MTcwMjA2LTU4OThkOGE3MTBkOTg3M2ZjN2RlZjQyYzcyNjdkZGZhNWMxNGI3NTAKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1o
c3gwMS1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi01ODk4ZDhhNzEw
ZDk4NzNmYzdkZWY0MmM3MjY3ZGRmYTVjMTRiNzUwCmtlcm5lbDogL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wNzE3MDIwNi81ODk4ZDhhNzEwZDk4NzNmYzdkZWY0MmM3MjY3ZGRm
YTVjMTRiNzUwL3ZtbGludXotMy4xNi4wLXJjNS0wNjEyOC1nNTg5OGQ4YQoKMjAxNC0wNy0x
Ny0wNTozMTowNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAu
MDAwMDAwXSBEZW50cnkgY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiA2NTUzNiAob3JkZXI6
IDcsIDUyNDI4OCBieXRlcykKWyAgICAwLjAwMDAwMF0gSW5vZGUtY2FjaGUgaGFzaCB0YWJs
ZSBlbnRyaWVzOiAzMjc2OCAob3JkZXI6IDYsIDI2MjE0NCBieXRlcykKWyAgICAwLjAwMDAw
MF0geHNhdmU6IGVuYWJsZWQgeHN0YXRlX2J2IDB4NywgY250eHQgc2l6ZSAweDAKWyAgICAw
LjAwMDAwMF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVy
ZWZlcmVuY2UgYXQgMDAwMDAwMDAwMDAwMDZmYwpbICAgIDAuMDAwMDAwXSBJUDogWzxmZmZm
ZmZmZjgxY2I0MjdmPl0gX19mcmVlX3BhZ2VzX2Jvb3RtZW0rMHgyMS8weDlkClsgICAgMC4w
MDAwMDBdIFBHRCAwIApbICAgIDAuMDAwMDAwXSBPb3BzOiAwMDAyIFsjMV0gClsgICAgMC4w
MDAwMDBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAw
IENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNi4wLXJjNS0wNjEyOC1nNTg5OGQ4YSAj
MgpbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2No
cyAwMS8wMS8yMDExClsgICAgMC4wMDAwMDBdIHRhc2s6IGZmZmZmZmZmODFhMWE0YzAgdGk6
IGZmZmZmZmZmODFhMDAwMDAgdGFzay50aTogZmZmZmZmZmY4MWEwMDAwMApbICAgIDAuMDAw
MDAwXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxY2I0MjdmPl0gIFs8ZmZmZmZmZmY4MWNiNDI3
Zj5dIF9fZnJlZV9wYWdlc19ib290bWVtKzB4MjEvMHg5ZApbICAgIDAuMDAwMDAwXSBSU1A6
IDAwMDA6ZmZmZmZmZmY4MWEwM2VkOCAgRUZMQUdTOiAwMDAxMDAxMgpbICAgIDAuMDAwMDAw
XSBSQVg6IDAwMDAwMDAwMDAwMDA3MzQgUkJYOiAwMDAwMDAwMDAwMDAwMDEwIFJDWDogMDAw
MDAwMDAwMDAwMDAwNApbICAgIDAuMDAwMDAwXSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJ
OiAwMDAwMDAwMDAwMDAwMDA0IFJESTogMDAwMDAwMDAwMDAwMDZmYwpbICAgIDAuMDAwMDAw
XSBSQlA6IGZmZmZmZmZmODFhMDNmMDAgUjA4OiAwMDAwMDAwMDAwMDAwMDBmIFIwOTogMDAw
MDAwMDAwMDAwMDAxMApbICAgIDAuMDAwMDAwXSBSMTA6IDAwMDAwMDAwMDAwMDAwMWMgUjEx
OiAwMDAwMDAwMDAwMDlmMDAwIFIxMjogMDAwMDAwMDAwMDAwMDA5OQpbICAgIDAuMDAwMDAw
XSBSMTM6IDAwMDAwMDAwMDAwMDAwMjAgUjE0OiAwMDAwMDAwMDAwMDAwMDBhIFIxNTogZmZm
ZmZmZmY4MWM5YjEyMApbICAgIDAuMDAwMDAwXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAw
MCkgR1M6ZmZmZmZmZmY4MWEyNTAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsg
ICAgMC4wMDAwMDBdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAw
ODAwNTAwMzMKWyAgICAwLjAwMDAwMF0gQ1IyOiAwMDAwMDAwMDAwMDAwNmZjIENSMzogMDAw
MDAwMDAwMWExNTAwMCBDUjQ6IDAwMDAwMDAwMDAwNDA2YTAKWyAgICAwLjAwMDAwMF0gU3Rh
Y2s6ClsgICAgMC4wMDAwMDBdICBmZmZmZmZmZjgxY2I2ZDRhIDAwMDAwMDAwMDAwMDAwMDAg
ZmZmZmZmZmY4MWQxOTk0MCBmZmZmODgwMDEzZmZjMTQwClsgICAgMC4wMDAwMDBdICBmZmZm
ZmZmZjgxZDIwMGEwIGZmZmZmZmZmODFhMDNmMzggZmZmZmZmZmY4MWNiNmY1YSAwMDAwMDAw
MDAwMDAwMDAwClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwMDEwMDAwIDAwMDAwMDAwMDAw
OTkwMDAgMDAwMDAwMDIwMDAwMDAwMCBmZmZmZmZmZmZmZmZmZmZmClsgICAgMC4wMDAwMDBd
IENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjYjZkNGE+XSA/IF9f
ZnJlZV9tZW1vcnlfY29yZSsweGEyLzB4YjkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MWNiNmY1YT5dIGZyZWVfYWxsX2Jvb3RtZW0rMHg1MS8weGQyClsgICAgMC4wMDAwMDBdICBb
PGZmZmZmZmZmODFjYWIyMGU+XSBtZW1faW5pdCsweGUvMHgyMQpbICAgIDAuMDAwMDAwXSAg
WzxmZmZmZmZmZjgxYzliZTI4Pl0gc3RhcnRfa2VybmVsKzB4MWViLzB4NGVhClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODFjOWI5OGM+XSA/IHNldF9pbml0X2FyZysweDU1LzB4NTUK
WyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWM5YjViMT5dIHg4Nl82NF9zdGFydF9yZXNl
cnZhdGlvbnMrMHgyYS8weDJjClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjOWI3MjU+
XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4MTcyLzB4MTgxClsgICAgMC4wMDAwMDBdIENvZGU6
IDg5IGU1IDVkIGMzIDU1IDQ4IDg5IGU1IDVkIGMzIDQwIDg4IGYxIDQxIGI5IDAxIDAwIDAw
IDAwIDQxIGQzIGUxIDBmIDE4IDBmIDMxIGQyIDQ4IDg5IGY4IDQ1IDhkIDQxIGZmIGViIDE1
IDQ4IDgzIGMwIDM4IDBmIDE4IDA4IDwwZj4gYmEgNzAgYzggMGEgYzcgNDAgZTQgMDAgMDAg
MDAgMDAgZmYgYzIgNDEgMzkgZDAgNzcgZTYgNGQgNmIgClsgICAgMC4wMDAwMDBdIFJJUCAg
WzxmZmZmZmZmZjgxY2I0MjdmPl0gX19mcmVlX3BhZ2VzX2Jvb3RtZW0rMHgyMS8weDlkClsg
ICAgMC4wMDAwMDBdICBSU1AgPGZmZmZmZmZmODFhMDNlZDg+ClsgICAgMC4wMDAwMDBdIENS
MjogMDAwMDAwMDAwMDAwMDZmYwpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSAwYmZh
YmQwYzdlMjhjMjQ0IF0tLS0KWyAgICAwLjAwMDAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5
bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIHRoZSBpZGxlIHRhc2shCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDcxNzAyMDYvNTg5OGQ4YTcxMGQ5ODczZmM3ZGVmNDJjNzI2N2Rk
ZmE1YzE0Yjc1MC9kbWVzZy1xdWFudGFsLWtidWlsZC0xMDoyMDE0MDcxNzA1Mjg1NDp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA2MTI4LWc1ODk4ZDhhOjIK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi81ODk4ZDhhNzEwZDk4NzNm
YzdkZWY0MmM3MjY3ZGRmYTVjMTRiNzUwL2RtZXNnLXF1YW50YWwta2J1aWxkLTIzOjIwMTQw
NzE3MDUyODU0Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDYx
MjgtZzU4OThkOGE6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzU4
OThkOGE3MTBkOTg3M2ZjN2RlZjQyYzcyNjdkZGZhNWMxNGI3NTAvZG1lc2ctcXVhbnRhbC1r
YnVpbGQtMjg6MjAxNDA3MTcwNTI4NTQ6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6
My4xNi4wLXJjNS0wNjEyOC1nNTg5OGQ4YToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDcxNzAyMDYvNTg5OGQ4YTcxMGQ5ODczZmM3ZGVmNDJjNzI2N2RkZmE1YzE0Yjc1MC9k
bWVzZy1xdWFudGFsLWtidWlsZC0yOjIwMTQwNzE3MDUyODU0Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDYxMjgtZzU4OThkOGE6Mgova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzU4OThkOGE3MTBkOTg3M2ZjN2RlZjQyYzcyNjdk
ZGZhNWMxNGI3NTAvZG1lc2ctcXVhbnRhbC1rYnVpbGQtOToyMDE0MDcxNzA1Mjg1NTp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA2MTI4LWc1ODk4ZDhhOjIK
MDo1OjUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogNTE5IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKWzBhMTkx
ZDc4ODY5YzJjYmQ0ZTc2MmUyZWFlYmZlOTg0ZDJlOWE0ODldIE1lcmdlICdwY2kvcGNpL2hv
c3QtZ2VuZXJpYycgaW50byBkZXZlbC1ob3VybHktMjAxNDA3MTcwMQpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3Qv
bGludXgtNy9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxNDA3MTcwMTowYTE5MWQ3ODg2OWMyY2JkNGU3NjJlMmVhZWJmZTk4NGQyZTlhNDg5OmJp
c2VjdC1saW51eC03CgoyMDE0LTA3LTE3LTA1OjMxOjM3IDBhMTkxZDc4ODY5YzJjYmQ0ZTc2
MmUyZWFlYmZlOTg0ZDJlOWE0ODkgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYt
MGExOTFkNzg4NjljMmNiZDRlNzYyZTJlYWViZmU5ODRkMmU5YTQ4OQpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMGExOTFkNzg4
NjljMmNiZDRlNzYyZTJlYWViZmU5ODRkMmU5YTQ4OQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEtMDcx
NzAyMDYtMGExOTFkNzg4NjljMmNiZDRlNzYyZTJlYWViZmU5ODRkMmU5YTQ4OQp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvamFrZXRvd24t
Y29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYtMGExOTFkNzg4NjljMmNi
ZDRlNzYyZTJlYWViZmU5ODRkMmU5YTQ4OQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDcxNzAyMDYvMGExOTFkNzg4NjljMmNiZDRlNzYyZTJlYWViZmU5ODRkMmU5
YTQ4OS92bWxpbnV6LTMuMTYuMC1yYzUtMDU2NTgtZzBhMTkxZDcKCjIwMTQtMDctMTctMDU6
NTY6MzcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAwMDAw
MF0gRGVudHJ5IGNhY2hlIGhhc2ggdGFibGUgZW50cmllczogNjU1MzYgKG9yZGVyOiA3LCA1
MjQyODggYnl0ZXMpClsgICAgMC4wMDAwMDBdIElub2RlLWNhY2hlIGhhc2ggdGFibGUgZW50
cmllczogMzI3NjggKG9yZGVyOiA2LCAyNjIxNDQgYnl0ZXMpClsgICAgMC4wMDAwMDBdIHhz
YXZlOiBlbmFibGVkIHhzdGF0ZV9idiAweDcsIGNudHh0IHNpemUgMHgwClsgICAgMC4wMDAw
MDBdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJl
bmNlIGF0IDAwMDAwMDAwMDAwMDA2ZmMKWyAgICAwLjAwMDAwMF0gSVA6IFs8ZmZmZmZmZmY4
MWNiNDI3Zj5dIF9fZnJlZV9wYWdlc19ib290bWVtKzB4MjEvMHg5ZApbICAgIDAuMDAwMDAw
XSBQR0QgMCAKWyAgICAwLjAwMDAwMF0gT29wczogMDAwMiBbIzFdIApbICAgIDAuMDAwMDAw
XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21t
OiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTYuMC1yYzUtMDU2NTgtZzBhMTkxZDcgIzEKWyAg
ICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEv
MDEvMjAxMQpbICAgIDAuMDAwMDAwXSB0YXNrOiBmZmZmZmZmZjgxYTFhNGMwIHRpOiBmZmZm
ZmZmZjgxYTAwMDAwIHRhc2sudGk6IGZmZmZmZmZmODFhMDAwMDAKWyAgICAwLjAwMDAwMF0g
UklQOiAwMDEwOls8ZmZmZmZmZmY4MWNiNDI3Zj5dICBbPGZmZmZmZmZmODFjYjQyN2Y+XSBf
X2ZyZWVfcGFnZXNfYm9vdG1lbSsweDIxLzB4OWQKWyAgICAwLjAwMDAwMF0gUlNQOiAwMDAw
OmZmZmZmZmZmODFhMDNlZDggIEVGTEFHUzogMDAwMTAwMTIKWyAgICAwLjAwMDAwMF0gUkFY
OiAwMDAwMDAwMDAwMDAwNzM0IFJCWDogMDAwMDAwMDAwMDAwMDAxMCBSQ1g6IDAwMDAwMDAw
MDAwMDAwMDQKWyAgICAwLjAwMDAwMF0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAw
MDAwMDAwMDAwMDAwNCBSREk6IDAwMDAwMDAwMDAwMDA2ZmMKWyAgICAwLjAwMDAwMF0gUkJQ
OiBmZmZmZmZmZjgxYTAzZjAwIFIwODogMDAwMDAwMDAwMDAwMDAwZiBSMDk6IDAwMDAwMDAw
MDAwMDAwMTAKWyAgICAwLjAwMDAwMF0gUjEwOiAwMDAwMDAwMDAwMDAwMDFjIFIxMTogMDAw
MDAwMDAwMDA5ZjAwMCBSMTI6IDAwMDAwMDAwMDAwMDAwOTkKWyAgICAwLjAwMDAwMF0gUjEz
OiAwMDAwMDAwMDAwMDAwMDIwIFIxNDogMDAwMDAwMDAwMDAwMDAwYSBSMTU6IGZmZmZmZmZm
ODFjOWIxMjAKWyAgICAwLjAwMDAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdT
OmZmZmZmZmZmODFhMjUwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAu
MDAwMDAwXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUw
MDMzClsgICAgMC4wMDAwMDBdIENSMjogMDAwMDAwMDAwMDAwMDZmYyBDUjM6IDAwMDAwMDAw
MDFhMTUwMDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmEwClsgICAgMC4wMDAwMDBdIFN0YWNrOgpb
ICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4MWNiNmQ0YSAwMDAwMDAwMDAwMDAwMDAwIGZmZmZm
ZmZmODFkMTk5NDAgZmZmZjg4MDAxM2ZmYzE0MApbICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4
MWQyMDBhMCBmZmZmZmZmZjgxYTAzZjM4IGZmZmZmZmZmODFjYjZmNWEgMDAwMDAwMDAwMDAw
MDAwMApbICAgIDAuMDAwMDAwXSAgMDAwMDAwMDAwMDAxMDAwMCAwMDAwMDAwMDAwMDk5MDAw
IDAwMDAwMDAyMDAwMDAwMDAgZmZmZmZmZmZmZmZmZmZmZgpbICAgIDAuMDAwMDAwXSBDYWxs
IFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2I2ZDRhPl0gPyBfX2ZyZWVf
bWVtb3J5X2NvcmUrMHhhMi8weGI5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjYjZm
NWE+XSBmcmVlX2FsbF9ib290bWVtKzB4NTEvMHhkMgpbICAgIDAuMDAwMDAwXSAgWzxmZmZm
ZmZmZjgxY2FiMjBlPl0gbWVtX2luaXQrMHhlLzB4MjEKWyAgICAwLjAwMDAwMF0gIFs8ZmZm
ZmZmZmY4MWM5YmUyOD5dIHN0YXJ0X2tlcm5lbCsweDFlYi8weDRlYQpbICAgIDAuMDAwMDAw
XSAgWzxmZmZmZmZmZjgxYzliOThjPl0gPyBzZXRfaW5pdF9hcmcrMHg1NS8weDU1ClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODFjOWI1YjE+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRp
b25zKzB4MmEvMHgyYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxYzliNzI1Pl0geDg2
XzY0X3N0YXJ0X2tlcm5lbCsweDE3Mi8weDE4MQpbICAgIDAuMDAwMDAwXSBDb2RlOiA4OSBl
NSA1ZCBjMyA1NSA0OCA4OSBlNSA1ZCBjMyA0MCA4OCBmMSA0MSBiOSAwMSAwMCAwMCAwMCA0
MSBkMyBlMSAwZiAxOCAwZiAzMSBkMiA0OCA4OSBmOCA0NSA4ZCA0MSBmZiBlYiAxNSA0OCA4
MyBjMCAzOCAwZiAxOCAwOCA8MGY+IGJhIDcwIGM4IDBhIGM3IDQwIGU0IDAwIDAwIDAwIDAw
IGZmIGMyIDQxIDM5IGQwIDc3IGU2IDRkIDZiIApbICAgIDAuMDAwMDAwXSBSSVAgIFs8ZmZm
ZmZmZmY4MWNiNDI3Zj5dIF9fZnJlZV9wYWdlc19ib290bWVtKzB4MjEvMHg5ZApbICAgIDAu
MDAwMDAwXSAgUlNQIDxmZmZmZmZmZjgxYTAzZWQ4PgpbICAgIDAuMDAwMDAwXSBDUjI6IDAw
MDAwMDAwMDAwMDA2ZmMKWyAgICAwLjAwMDAwMF0gLS0tWyBlbmQgdHJhY2UgOTExMmIyY2Ji
M2U2YTMyYyBdLS0tClsgICAgMC4wMDAwMDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5n
OiBBdHRlbXB0ZWQgdG8ga2lsbCB0aGUgaWRsZSB0YXNrIQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2LzBhMTkxZDc4ODY5YzJjYmQ0ZTc2MmUyZWFlYmZlOTg0ZDJl
OWE0ODkvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjY6MjAxNDA3MTcwNTU0NTE6eDg2XzY0LXJh
bmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTY1OC1nMGExOTFkNzoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMGExOTFkNzg4NjljMmNiZDRlNzYy
ZTJlYWViZmU5ODRkMmU5YTQ4OS9kbWVzZy1xdWFudGFsLWtidWlsZC0yOjIwMTQwNzE3MDU1
NDQ3Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU2NTgtZzBh
MTkxZDc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzBhMTkxZDc4
ODY5YzJjYmQ0ZTc2MmUyZWFlYmZlOTg0ZDJlOWE0ODkvZG1lc2cteW9jdG8ta2J1aWxkLTE1
OjIwMTQwNzE3MDU1NDQ5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1y
YzUtMDU2NTgtZzBhMTkxZDc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcw
MjA2LzBhMTkxZDc4ODY5YzJjYmQ0ZTc2MmUyZWFlYmZlOTg0ZDJlOWE0ODkvZG1lc2cteW9j
dG8ta2J1aWxkLTIyOjIwMTQwNzE3MDU1NDQ4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcw
MjA2OjMuMTYuMC1yYzUtMDU2NTgtZzBhMTkxZDc6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA3MTcwMjA2LzBhMTkxZDc4ODY5YzJjYmQ0ZTc2MmUyZWFlYmZlOTg0ZDJlOWE0
ODkvZG1lc2cteW9jdG8ta2J1aWxkLTI6MjAxNDA3MTcwNTU0NTE6eDg2XzY0LXJhbmRjb25m
aWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTY1OC1nMGExOTFkNzoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMGExOTFkNzg4NjljMmNiZDRlNzYyZTJlYWVi
ZmU5ODRkMmU5YTQ4OS9kbWVzZy1xdWFudGFsLWtidWlsZC0xOToyMDE0MDcxNzA1NTQ1Njp4
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NjU4LWcwYTE5MWQ3
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8wYTE5MWQ3ODg2OWMy
Y2JkNGU3NjJlMmVhZWJmZTk4NGQyZTlhNDg5L2RtZXNnLXF1YW50YWwta2J1aWxkLTIxOjIw
MTQwNzE3MDU1NDU2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUt
MDU2NTgtZzBhMTkxZDc6MQowOjc6NyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlz
ZWN0aW5nOiA0NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
NiBzdGVwcykKWzBjNWE5YmQ0MDBiMTE3M2E5NGQ4M2Y3NjFlNDliNTY4NTgzODA5ZDFdIE1l
cmdlICdwY21vb3JlLXNlbGludXgvc3RhYmxlLTMuMTYnIGludG8gZGV2ZWwtaG91cmx5LTIw
MTQwNzE3MDEKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6MGM1YTliZDQwMGIxMTczYTk0ZDgz
Zjc2MWU0OWI1Njg1ODM4MDlkMTpiaXNlY3QtbGludXgtNwoKMjAxNC0wNy0xNy0wNTo1Nzow
OSAwYzVhOWJkNDAwYjExNzNhOTRkODNmNzYxZTQ5YjU2ODU4MzgwOWQxIGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA3MTcwMjA2LTBjNWE5YmQ0MDBiMTE3M2E5NGQ4M2Y3NjFlNDliNTY4
NTgzODA5ZDEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2LzBjNWE5YmQ0MDBiMTE3M2E5NGQ4M2Y3NjFlNDliNTY4NTgzODA5ZDEK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LTBjNWE5YmQ0MDBiMTE3M2E5NGQ4M2Y3NjFl
NDliNTY4NTgzODA5ZDEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
NzE3MDIwNi0wYzVhOWJkNDAwYjExNzNhOTRkODNmNzYxZTQ5YjU2ODU4MzgwOWQxCmtlcm5l
bDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8wYzVhOWJkNDAwYjEx
NzNhOTRkODNmNzYxZTQ5YjU2ODU4MzgwOWQxL3ZtbGludXotMy4xNi4wLXJjNS0wNTYzMi1n
MGM1YTliZAoKMjAxNC0wNy0xNy0wNjowMjowOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkx
MSBURVNUIEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gRGVudHJ5IGNhY2hlIGhhc2ggdGFibGUg
ZW50cmllczogNjU1MzYgKG9yZGVyOiA3LCA1MjQyODggYnl0ZXMpClsgICAgMC4wMDAwMDBd
IElub2RlLWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogMzI3NjggKG9yZGVyOiA2LCAyNjIx
NDQgYnl0ZXMpClsgICAgMC4wMDAwMDBdIHhzYXZlOiBlbmFibGVkIHhzdGF0ZV9idiAweDcs
IGNudHh0IHNpemUgMHgwClsgICAgMC4wMDAwMDBdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBr
ZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDAwMDAwMDA2ZmMKWyAg
ICAwLjAwMDAwMF0gSVA6IFs8ZmZmZmZmZmY4MWNiNDI3Zj5dIF9fZnJlZV9wYWdlc19ib290
bWVtKzB4MjEvMHg5ZApbICAgIDAuMDAwMDAwXSBQR0QgMCAKWyAgICAwLjAwMDAwMF0gT29w
czogMDAwMiBbIzFdIApbICAgIDAuMDAwMDAwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAw
LjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTYu
MC1yYzUtMDU2MzItZzBjNWE5YmQgIzEKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFtZTog
Qm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDAwMDAwXSB0YXNr
OiBmZmZmZmZmZjgxYTFhNGMwIHRpOiBmZmZmZmZmZjgxYTAwMDAwIHRhc2sudGk6IGZmZmZm
ZmZmODFhMDAwMDAKWyAgICAwLjAwMDAwMF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MWNiNDI3
Zj5dICBbPGZmZmZmZmZmODFjYjQyN2Y+XSBfX2ZyZWVfcGFnZXNfYm9vdG1lbSsweDIxLzB4
OWQKWyAgICAwLjAwMDAwMF0gUlNQOiAwMDAwOmZmZmZmZmZmODFhMDNlZDggIEVGTEFHUzog
MDAwMTAwMTIKWyAgICAwLjAwMDAwMF0gUkFYOiAwMDAwMDAwMDAwMDAwNzM0IFJCWDogMDAw
MDAwMDAwMDAwMDAxMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDQKWyAgICAwLjAwMDAwMF0gUkRY
OiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAwNCBSREk6IDAwMDAwMDAw
MDAwMDA2ZmMKWyAgICAwLjAwMDAwMF0gUkJQOiBmZmZmZmZmZjgxYTAzZjAwIFIwODogMDAw
MDAwMDAwMDAwMDAwZiBSMDk6IDAwMDAwMDAwMDAwMDAwMTAKWyAgICAwLjAwMDAwMF0gUjEw
OiAwMDAwMDAwMDAwMDAwMDFjIFIxMTogMDAwMDAwMDAwMDA5ZjAwMCBSMTI6IDAwMDAwMDAw
MDAwMDAwOTkKWyAgICAwLjAwMDAwMF0gUjEzOiAwMDAwMDAwMDAwMDAwMDIwIFIxNDogMDAw
MDAwMDAwMDAwMDAwYSBSMTU6IGZmZmZmZmZmODFjOWIxMjAKWyAgICAwLjAwMDAwMF0gRlM6
ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODFhMjUwMDAoMDAwMCkga25s
R1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDAwMDAwXSBDUzogIDAwMTAgRFM6IDAwMDAg
RVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgICAgMC4wMDAwMDBdIENSMjogMDAw
MDAwMDAwMDAwMDZmYyBDUjM6IDAwMDAwMDAwMDFhMTUwMDAgQ1I0OiAwMDAwMDAwMDAwMDQw
NmEwClsgICAgMC4wMDAwMDBdIFN0YWNrOgpbICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4MWNi
NmQ0YSAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODFkMTk5NDAgZmZmZjg4MDAxM2ZmYzE0
MApbICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4MWQyMDBhMCBmZmZmZmZmZjgxYTAzZjM4IGZm
ZmZmZmZmODFjYjZmNWEgMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDAwMDAwXSAgMDAwMDAw
MDAwMDAxMDAwMCAwMDAwMDAwMDAwMDk5MDAwIDAwMDAwMDAyMDAwMDAwMDAgZmZmZmZmZmZm
ZmZmZmZmZgpbICAgIDAuMDAwMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgxY2I2ZDRhPl0gPyBfX2ZyZWVfbWVtb3J5X2NvcmUrMHhhMi8weGI5ClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODFjYjZmNWE+XSBmcmVlX2FsbF9ib290bWVtKzB4NTEv
MHhkMgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2FiMjBlPl0gbWVtX2luaXQrMHhl
LzB4MjEKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWM5YmUyOD5dIHN0YXJ0X2tlcm5l
bCsweDFlYi8weDRlYQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxYzliOThjPl0gPyBz
ZXRfaW5pdF9hcmcrMHg1NS8weDU1ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjOWI1
YjE+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4MmEvMHgyYwpbICAgIDAuMDAwMDAw
XSAgWzxmZmZmZmZmZjgxYzliNzI1Pl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweDE3Mi8weDE4
MQpbICAgIDAuMDAwMDAwXSBDb2RlOiA4OSBlNSA1ZCBjMyA1NSA0OCA4OSBlNSA1ZCBjMyA0
MCA4OCBmMSA0MSBiOSAwMSAwMCAwMCAwMCA0MSBkMyBlMSAwZiAxOCAwZiAzMSBkMiA0OCA4
OSBmOCA0NSA4ZCA0MSBmZiBlYiAxNSA0OCA4MyBjMCAzOCAwZiAxOCAwOCA8MGY+IGJhIDcw
IGM4IDBhIGM3IDQwIGU0IDAwIDAwIDAwIDAwIGZmIGMyIDQxIDM5IGQwIDc3IGU2IDRkIDZi
IApbICAgIDAuMDAwMDAwXSBSSVAgIFs8ZmZmZmZmZmY4MWNiNDI3Zj5dIF9fZnJlZV9wYWdl
c19ib290bWVtKzB4MjEvMHg5ZApbICAgIDAuMDAwMDAwXSAgUlNQIDxmZmZmZmZmZjgxYTAz
ZWQ4PgpbICAgIDAuMDAwMDAwXSBDUjI6IDAwMDAwMDAwMDAwMDA2ZmMKWyAgICAwLjAwMDAw
MF0gLS0tWyBlbmQgdHJhY2UgNjY4OWY2NjU0ZTcxNDFiYSBdLS0tClsgICAgMC4wMDAwMDBd
IEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBBdHRlbXB0ZWQgdG8ga2lsbCB0aGUgaWRs
ZSB0YXNrIQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzBjNWE5YmQ0
MDBiMTE3M2E5NGQ4M2Y3NjFlNDliNTY4NTgzODA5ZDEvZG1lc2ctcXVhbnRhbC1rYnVpbGQt
MTE6MjAxNDA3MTcwNjAxMTQ6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4w
LXJjNS0wNTYzMi1nMGM1YTliZDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcx
NzAyMDYvMGM1YTliZDQwMGIxMTczYTk0ZDgzZjc2MWU0OWI1Njg1ODM4MDlkMS9kbWVzZy1x
dWFudGFsLWtidWlsZC0yNToyMDE0MDcxNzA2MDExNjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0w
NzE3MDIwNjozLjE2LjAtcmM1LTA1NjMyLWcwYzVhOWJkOjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wNzE3MDIwNi8wYzVhOWJkNDAwYjExNzNhOTRkODNmNzYxZTQ5YjU2ODU4
MzgwOWQxL2RtZXNnLXlvY3RvLWtidWlsZC0yNjoyMDE0MDcxNzA2MDExNzp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NjMyLWcwYzVhOWJkOjEKMTE6Mzoz
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA3LTE3IDA2OjAzOjQw
IFJFUEVBVCBDT1VOVDogNTYgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtNy9vYmotYmlzZWN0
Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDIzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbNDlkOGZlMWY3MmFlYmRlOGU1ZTQzMmI0YTRl
ZjQ3NjZhMTIzMDIzNV0gTWVyZ2UgJ2RpZ3NpZy9pbWEtcG9saWN5JyBpbnRvIGRldmVsLWhv
dXJseS0yMDE0MDcxNzAxCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC03L29iai1iaXNlY3QKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcw
MjA2L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxNzAxOjQ5ZDhmZTFmNzJhZWJk
ZThlNWU0MzJiNGE0ZWY0NzY2YTEyMzAyMzU6YmlzZWN0LWxpbnV4LTcKCjIwMTQtMDctMTct
MDY6MDM6NDEgNDlkOGZlMWY3MmFlYmRlOGU1ZTQzMmI0YTRlZjQ3NjZhMTIzMDIzNSBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi00OWQ4ZmUxZjcyYWViZGU4ZTVlNDMyYjRh
NGVmNDc2NmExMjMwMjM1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wNzE3MDIwNi80OWQ4ZmUxZjcyYWViZGU4ZTVlNDMyYjRhNGVmNDc2NmEx
MjMwMjM1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi00OWQ4ZmUxZjcyYWViZGU4ZTVl
NDMyYjRhNGVmNDc2NmExMjMwMjM1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2XzY0LXJhbmRjb25m
aWctczEtMDcxNzAyMDYtNDlkOGZlMWY3MmFlYmRlOGU1ZTQzMmI0YTRlZjQ3NjZhMTIzMDIz
NQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvNDlkOGZl
MWY3MmFlYmRlOGU1ZTQzMmI0YTRlZjQ3NjZhMTIzMDIzNS92bWxpbnV6LTMuMTYuMC1yYzUt
MDU2MjAtZzQ5ZDhmZTEKCjIwMTQtMDctMTctMDY6MzI6NDEgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgCTMgVEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBdIERlbnRyeSBjYWNoZSBoYXNoIHRh
YmxlIGVudHJpZXM6IDY1NTM2IChvcmRlcjogNywgNTI0Mjg4IGJ5dGVzKQpbICAgIDAuMDAw
MDAwXSBJbm9kZS1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDMyNzY4IChvcmRlcjogNiwg
MjYyMTQ0IGJ5dGVzKQpbICAgIDAuMDAwMDAwXSB4c2F2ZTogZW5hYmxlZCB4c3RhdGVfYnYg
MHg3LCBjbnR4dCBzaXplIDB4MApbICAgIDAuMDAwMDAwXSBCVUc6IHVuYWJsZSB0byBoYW5k
bGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAwMDAwMDAwNmZj
ClsgICAgMC4wMDAwMDBdIElQOiBbPGZmZmZmZmZmODFjYjQyN2Y+XSBfX2ZyZWVfcGFnZXNf
Ym9vdG1lbSsweDIxLzB4OWQKWyAgICAwLjAwMDAwMF0gUEdEIDAgClsgICAgMC4wMDAwMDBd
IE9vcHM6IDAwMDIgWyMxXSAKWyAgICAwLjAwMDAwMF0gTW9kdWxlcyBsaW5rZWQgaW46Clsg
ICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAz
LjE2LjAtcmM1LTA1NjIwLWc0OWQ4ZmUxICMyClsgICAgMC4wMDAwMDBdIEhhcmR3YXJlIG5h
bWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjAwMDAwMF0g
dGFzazogZmZmZmZmZmY4MWExYTRjMCB0aTogZmZmZmZmZmY4MWEwMDAwMCB0YXNrLnRpOiBm
ZmZmZmZmZjgxYTAwMDAwClsgICAgMC4wMDAwMDBdIFJJUDogMDAxMDpbPGZmZmZmZmZmODFj
YjQyN2Y+XSAgWzxmZmZmZmZmZjgxY2I0MjdmPl0gX19mcmVlX3BhZ2VzX2Jvb3RtZW0rMHgy
MS8weDlkClsgICAgMC4wMDAwMDBdIFJTUDogMDAwMDpmZmZmZmZmZjgxYTAzZWQ4ICBFRkxB
R1M6IDAwMDEwMDEyClsgICAgMC4wMDAwMDBdIFJBWDogMDAwMDAwMDAwMDAwMDczNCBSQlg6
IDAwMDAwMDAwMDAwMDAwMTAgUkNYOiAwMDAwMDAwMDAwMDAwMDA0ClsgICAgMC4wMDAwMDBd
IFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAwMDQgUkRJOiAwMDAw
MDAwMDAwMDAwNmZjClsgICAgMC4wMDAwMDBdIFJCUDogZmZmZmZmZmY4MWEwM2YwMCBSMDg6
IDAwMDAwMDAwMDAwMDAwMGYgUjA5OiAwMDAwMDAwMDAwMDAwMDEwClsgICAgMC4wMDAwMDBd
IFIxMDogMDAwMDAwMDAwMDAwMDAxYyBSMTE6IDAwMDAwMDAwMDAwOWYwMDAgUjEyOiAwMDAw
MDAwMDAwMDAwMDk5ClsgICAgMC4wMDAwMDBdIFIxMzogMDAwMDAwMDAwMDAwMDAyMCBSMTQ6
IDAwMDAwMDAwMDAwMDAwMGEgUjE1OiBmZmZmZmZmZjgxYzliMTIwClsgICAgMC4wMDAwMDBd
IEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmZmZmZjgxYTI1MDAwKDAwMDAp
IGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAwMDAwMF0gQ1M6ICAwMDEwIERTOiAw
MDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMwpbICAgIDAuMDAwMDAwXSBDUjI6
IDAwMDAwMDAwMDAwMDA2ZmMgQ1IzOiAwMDAwMDAwMDAxYTE1MDAwIENSNDogMDAwMDAwMDAw
MDA0MDZhMApbICAgIDAuMDAwMDAwXSBTdGFjazoKWyAgICAwLjAwMDAwMF0gIGZmZmZmZmZm
ODFjYjZkNGEgMDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgxZDE5OTQwIGZmZmY4ODAwMTNm
ZmMxNDAKWyAgICAwLjAwMDAwMF0gIGZmZmZmZmZmODFkMjAwYTAgZmZmZmZmZmY4MWEwM2Yz
OCBmZmZmZmZmZjgxY2I2ZjVhIDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAwMDAwMF0gIDAw
MDAwMDAwMDAwMTAwMDAgMDAwMDAwMDAwMDA5OTAwMCAwMDAwMDAwMjAwMDAwMDAwIGZmZmZm
ZmZmZmZmZmZmZmYKWyAgICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAwMDAwMF0g
IFs8ZmZmZmZmZmY4MWNiNmQ0YT5dID8gX19mcmVlX21lbW9yeV9jb3JlKzB4YTIvMHhiOQpb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2I2ZjVhPl0gZnJlZV9hbGxfYm9vdG1lbSsw
eDUxLzB4ZDIKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNhYjIwZT5dIG1lbV9pbml0
KzB4ZS8weDIxClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjOWJlMjg+XSBzdGFydF9r
ZXJuZWwrMHgxZWIvMHg0ZWEKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWM5Yjk4Yz5d
ID8gc2V0X2luaXRfYXJnKzB4NTUvMHg1NQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgx
YzliNWIxPl0geDg2XzY0X3N0YXJ0X3Jlc2VydmF0aW9ucysweDJhLzB4MmMKWyAgICAwLjAw
MDAwMF0gIFs8ZmZmZmZmZmY4MWM5YjcyNT5dIHg4Nl82NF9zdGFydF9rZXJuZWwrMHgxNzIv
MHgxODEKWyAgICAwLjAwMDAwMF0gQ29kZTogODkgZTUgNWQgYzMgNTUgNDggODkgZTUgNWQg
YzMgNDAgODggZjEgNDEgYjkgMDEgMDAgMDAgMDAgNDEgZDMgZTEgMGYgMTggMGYgMzEgZDIg
NDggODkgZjggNDUgOGQgNDEgZmYgZWIgMTUgNDggODMgYzAgMzggMGYgMTggMDggPDBmPiBi
YSA3MCBjOCAwYSBjNyA0MCBlNCAwMCAwMCAwMCAwMCBmZiBjMiA0MSAzOSBkMCA3NyBlNiA0
ZCA2YiAKWyAgICAwLjAwMDAwMF0gUklQICBbPGZmZmZmZmZmODFjYjQyN2Y+XSBfX2ZyZWVf
cGFnZXNfYm9vdG1lbSsweDIxLzB4OWQKWyAgICAwLjAwMDAwMF0gIFJTUCA8ZmZmZmZmZmY4
MWEwM2VkOD4KWyAgICAwLjAwMDAwMF0gQ1IyOiAwMDAwMDAwMDAwMDAwNmZjClsgICAgMC4w
MDAwMDBdIC0tLVsgZW5kIHRyYWNlIDBlYWJmOGJiZjJhMDE1ZWMgXS0tLQpbICAgIDAuMDAw
MDAwXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQXR0ZW1wdGVkIHRvIGtpbGwgdGhl
IGlkbGUgdGFzayEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi80OWQ4
ZmUxZjcyYWViZGU4ZTVlNDMyYjRhNGVmNDc2NmExMjMwMjM1L2RtZXNnLXF1YW50YWwta2J1
aWxkLTE0OjIwMTQwNzE3MDYzMDA3Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMu
MTYuMC1yYzUtMDU2MjAtZzQ5ZDhmZTE6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA3MTcwMjA2LzQ5ZDhmZTFmNzJhZWJkZThlNWU0MzJiNGE0ZWY0NzY2YTEyMzAyMzUvZG1l
c2ctcXVhbnRhbC1rYnVpbGQtOToyMDE0MDcxNzA2MzAwNjp4ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NjIwLWc0OWQ4ZmUxOjIKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wNzE3MDIwNi80OWQ4ZmUxZjcyYWViZGU4ZTVlNDMyYjRhNGVmNDc2
NmExMjMwMjM1L2RtZXNnLXlvY3RvLWtidWlsZC0yOjIwMTQwNzE3MDYzMDA3Ong4Nl82NC1y
YW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU2MjAtZzQ5ZDhmZTE6Mgova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzQ5ZDhmZTFmNzJhZWJkZThlNWU0
MzJiNGE0ZWY0NzY2YTEyMzAyMzUvZG1lc2cteW9jdG8ta2J1aWxkLTQ6MjAxNDA3MTcwNjMw
MDc6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTYyMC1nNDlk
OGZlMToyCjI6NDo1IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpsaW5lYXItYmlzZWN0
OiBiYWQgYnJhbmNoIG1heSBiZSBkaWdzaWcvaW1hLXBvbGljeQpsaW5lYXItYmlzZWN0OiBo
YW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3Rh
cnQgNDlkOGZlMWY3MmFlYmRlOGU1ZTQzMmI0YTRlZjQ3NjZhMTIzMDIzNSAwZDdlMWNhNDBl
ZjE2ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYxYjM4IC0tClByZXZpb3VzIEhFQUQgcG9zaXRp
b24gd2FzIDQ5ZDhmZTEuLi4gTWVyZ2UgJ2RpZ3NpZy9pbWEtcG9saWN5JyBpbnRvIGRldmVs
LWhvdXJseS0yMDE0MDcxNzAxCkhFQUQgaXMgbm93IGF0IGEzNWMwN2QuLi4gTWVyZ2UgcmVt
b3RlLXRyYWNraW5nIGJyYW5jaCAnZnRyYWNlL2Zvci1uZXh0JwpCaXNlY3Rpbmc6IDUgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltkNjQ0
ZWEzYjI4ODhiNTI1YzE3N2RhMmQ3MmE2OWMyMmEzOTFiMmMxXSBpbWE6IHBhdGggYmFzZWQg
cG9saWN5IGxvYWRpbmcgaW50ZXJmYWNlCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVu
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1i
aXNlY3QvbGludXgtNy9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC03L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxNzAxOmQ2NDRl
YTNiMjg4OGI1MjVjMTc3ZGEyZDcyYTY5YzIyYTM5MWIyYzE6YmlzZWN0LWxpbnV4LTcKCjIw
MTQtMDctMTctMDY6MzM6MTggZDY0NGVhM2IyODg4YjUyNWMxNzdkYTJkNzJhNjljMjJhMzkx
YjJjMSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi1kNjQ0ZWEzYjI4ODhiNTI1
YzE3N2RhMmQ3MmE2OWMyMmEzOTFiMmMxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9kNjQ0ZWEzYjI4ODhiNTI1YzE3N2RhMmQ3
MmE2OWMyMmEzOTFiMmMxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi1kNjQ0ZWEzYjI4
ODhiNTI1YzE3N2RhMmQ3MmE2OWMyMmEzOTFiMmMxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2XzY0
LXJhbmRjb25maWctczEtMDcxNzAyMDYtZDY0NGVhM2IyODg4YjUyNWMxNzdkYTJkNzJhNjlj
MjJhMzkxYjJjMQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAy
MDYvZDY0NGVhM2IyODg4YjUyNWMxNzdkYTJkNzJhNjljMjJhMzkxYjJjMS92bWxpbnV6LTMu
MTUuMC0wNDk3Ni1nZDY0NGVhMwoKMjAxNC0wNy0xNy0wNjo1NzoxOCBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAJMTMJMjkJNTYgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbYzY3ZWViYzNiMmViODAw
ODNkY2JlOWI3MTcxMDE1ODg5ZGYzZDkwOV0gaW1hOiBwcm92aWRlIGtlcm5lbCBvcHRpb24g
dG8gc3BlY2lmeSB0ZW1wbGF0ZSBmb3JtYXQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTcvb2JqLWJp
c2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctczEtMDcxNzAyMDYvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6YzY3
ZWViYzNiMmViODAwODNkY2JlOWI3MTcxMDE1ODg5ZGYzZDkwOTpiaXNlY3QtbGludXgtNwoK
MjAxNC0wNy0xNy0wNjo1ODo1MCBjNjdlZWJjM2IyZWI4MDA4M2RjYmU5YjcxNzEwMTU4ODlk
ZjNkOTA5IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LWM2N2VlYmMzYjJlYjgw
MDgzZGNiZTliNzE3MTAxNTg4OWRmM2Q5MDkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2M2N2VlYmMzYjJlYjgwMDgzZGNiZTli
NzE3MTAxNTg4OWRmM2Q5MDkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LWM2N2VlYmMz
YjJlYjgwMDgzZGNiZTliNzE3MTAxNTg4OWRmM2Q5MDkKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1lci94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi1jNjdlZWJjM2IyZWI4MDA4M2RjYmU5YjcxNzEw
MTU4ODlkZjNkOTA5Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3
MDIwNi9jNjdlZWJjM2IyZWI4MDA4M2RjYmU5YjcxNzEwMTU4ODlkZjNkOTA5L3ZtbGludXot
My4xNS4wLTA0OTc5LWdjNjdlZWJjCgoyMDE0LTA3LTE3LTA3OjEzOjU3IGRldGVjdGluZyBi
b290IHN0YXRlIC4JNDUJNTYgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCltiMjZhYWUyNWQ3MjNmM2Ix
NTBiNjUxYzczZWU5Y2Q2YjU0MDJmZmQ3XSBpbWE6IHByb3ZpZGUgaW1hX2FwcHJhaXNlPWln
bm9yZSBvcHRpb24KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTcvb2JqLWJpc2VjdApscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYv
bGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6YjI2YWFlMjVkNzIzZjNiMTUw
YjY1MWM3M2VlOWNkNmI1NDAyZmZkNzpiaXNlY3QtbGludXgtNwoKMjAxNC0wNy0xNy0wNzox
NToyNyBiMjZhYWUyNWQ3MjNmM2IxNTBiNjUxYzczZWU5Y2Q2YjU0MDJmZmQ3IGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LWIyNmFhZTI1ZDcyM2YzYjE1MGI2NTFjNzNlZTlj
ZDZiNTQwMmZmZDcKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA3MTcwMjA2L2IyNmFhZTI1ZDcyM2YzYjE1MGI2NTFjNzNlZTljZDZiNTQwMmZm
ZDcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LWIyNmFhZTI1ZDcyM2YzYjE1MGI2NTFj
NzNlZTljZDZiNTQwMmZmZDcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIw
Ni1iMjZhYWUyNWQ3MjNmM2IxNTBiNjUxYzczZWU5Y2Q2YjU0MDJmZmQ3Cmtlcm5lbDogL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iMjZhYWUyNWQ3MjNmM2IxNTBi
NjUxYzczZWU5Y2Q2YjU0MDJmZmQ3L3ZtbGludXotMy4xNS4wLTA5OTc3LWdiMjZhYWUyCgoy
MDE0LTA3LTE3LTA3OjI0OjI3IGRldGVjdGluZyBib290IHN0YXRlIAk0MAk1NiBTVUNDRVNT
Cgo0OWQ4ZmUxZjcyYWViZGU4ZTVlNDMyYjRhNGVmNDc2NmExMjMwMjM1IGlzIHRoZSBmaXJz
dCBiYWQgY29tbWl0CmJpc2VjdCBydW4gc3VjY2VzcwpQcmV2aW91cyBIRUFEIHBvc2l0aW9u
IHdhcyBiMjZhYWUyLi4uIGltYTogcHJvdmlkZSBpbWFfYXBwcmFpc2U9aWdub3JlIG9wdGlv
bgpIRUFEIGlzIG5vdyBhdCAwZDdlMWNhLi4uIE1lcmdlICdkeW50aWNrcy9ub2h6L3N5c2lk
bGUnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDcxNzAxOjBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3
ZmM3OTM3NjFiMzg6YmlzZWN0LWxpbnV4LTcKCjIwMTQtMDctMTctMDc6MjU6MzAgMGQ3ZTFj
YTQwZWYxNmZjZTUyOTc1NzkxMjE3MTdmYzc5Mzc2MWIzOCByZXVzZSAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3
ZmM3OTM3NjFiMzgvdm1saW51ei0zLjE2LjAtcmM1LTA1NjA5LWcwZDdlMWNhCgoyMDE0LTA3
LTE3LTA3OjI1OjMwIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAg
OS4xMzk3NTJdIHJhbmRvbTogbm9uYmxvY2tpbmcgcG9vbCBpcyBpbml0aWFsaXplZApbICAg
MTIuNTIwNzM1XSBzb2NrOiBwcm9jZXNzIGB0cmluaXR5LW1haW4nIGlzIHVzaW5nIG9ic29s
ZXRlIHNldHNvY2tvcHQgU09fQlNEQ09NUEFUCgpCVUc6IGtlcm5lbCBib290IGhhbmcKRWxh
cHNlZCB0aW1lOiAzNQpxZW11LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02NCAtZW5hYmxlLWt2
bSAta2VybmVsIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMGQ3ZTFj
YTQwZWYxNmZjZTUyOTc1NzkxMjE3MTdmYzc5Mzc2MWIzOC92bWxpbnV6LTMuMTYuMC1yYzUt
MDU2MDktZzBkN2UxY2EgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9
dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1
cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3Bh
bmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5
UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBs
aW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
NzE3MDIwNi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTowZDdlMWNhNDBl
ZjE2ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYxYjM4OmJpc2VjdC1saW51eC03Ly52bWxpbnV6
LTBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzgtMjAxNDA3MTcxMzE0
MTItMS1pdmI0MSBicmFuY2g9bGludXgtZGV2ZWwvZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEg
Qk9PVF9JTUFHRT0va2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzBkN2Ux
Y2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzgvdm1saW51ei0zLjE2LjAtcmM1
LTA1NjA5LWcwZDdlMWNhIGRyYmQubWlub3JfY291bnQ9OCcgIC1pbml0cmQgL2tlcm5lbC10
ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLXg4Nl82NC5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0
IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSAtYm9vdCBvcmRlcj1u
YyAtbm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1w
aWRmaWxlIC9kZXYvc2htL2tib290L3BpZC1xdWFudGFsLWl2YjQxLTExNSAtc2VyaWFsIGZp
bGU6L2Rldi9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwtaXZiNDEtMTE1IC1kYWVtb25pemUg
LWRpc3BsYXkgbm9uZSAtbW9uaXRvciBudWxsIAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2LzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzgv
ZG1lc2cteW9jdG8ta2J1aWxkLTI4OjIwMTQwNzE3MDcyMzUxOng4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU2MDktZzBkN2UxY2E6MQoyMToxOjI1IGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA3LTE3IDA3OjI2OjAxIFJFUEVB
VCBDT1VOVDogMzAwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTcvb2JqLWJpc2VjdC8ucmVw
ZWF0G1swbQoKG1sxOzM1bTIwMTQtMDctMTcgMDc6MjY6MDEgYmFkIGJpc2VjdCwgcmV0cnkg
d2l0aCBpbmNyZWFzZWQgcmVwZWF0IGNvdW50IDE2OBtbMG0KUHJldmlvdXMgSEVBRCBwb3Np
dGlvbiB3YXMgMGQ3ZTFjYS4uLiBNZXJnZSAnZHludGlja3Mvbm9oei9zeXNpZGxlJyBpbnRv
IGRldmVsLWhvdXJseS0yMDE0MDcxNzAxCkhFQUQgaXMgbm93IGF0IDVlNjBjMmEuLi4gMGRh
eSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEnCmdpdCBjaGVja291
dCAxNzk1Y2Q5YjNhOTFkNGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiCmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMToxNzk1Y2Q5YjNhOTFkNGI1NDcz
Yzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiOmJpc2VjdC1saW51eC03CgoyMDE0LTA3LTE3LTA3OjI2
OjM4IDE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWIgcmV1c2UgL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xNzk1Y2Q5YjNhOTFkNGI1NDcz
Yzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiL3ZtbGludXotMy4xNi4wLXJjNQoKMjAxNC0wNy0xNy0w
NzoyNjozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTY5CTE0NAkyNjMJMjg5CTMwMCBTVUND
RVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYz
ODkyNDQyMjEyYWIKZ2l0IGJpc2VjdCBzdGFydCA1ZTYwYzJhZjdhOGJkZTVjZmFlZThmZmQ3
N2NmYzViNjJkYjBhMDRlIDE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEy
YWIgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiNWU2MGMyYWY3
YThiZGU1Y2ZhZWU4ZmZkNzdjZmM1YjYyZGIwYTA0ZSIsICItZyIsICIxNzk1Y2Q5YjNhOTFk
NGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1iaXNlY3QvbGludXgtNy9vYmotYmlz
ZWN0Il0KQmlzZWN0aW5nOiA2Mzk3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMyBzdGVwcykKW2JjMWYyZjkzZjY4YmNjZDk4OGFmN2U2ZjczMzg0ODYw
YWMyNDFiNzhdIE1lcmdlICdzb2NmcGdhLW5leC9uaW9zMi11cHN0cmVhbScgaW50byBkZXZl
bC1ob3VybHktMjAxNDA3MTcwMQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNy9vYmotYmlzZWN0Cmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
NzE3MDIwNi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTpiYzFmMmY5M2Y2
OGJjY2Q5ODhhZjdlNmY3MzM4NDg2MGFjMjQxYjc4OmJpc2VjdC1saW51eC03CgoyMDE0LTA3
LTE3LTA3OjI5OjQwIGJjMWYyZjkzZjY4YmNjZDk4OGFmN2U2ZjczMzg0ODYwYWMyNDFiNzgg
cmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iYzFmMmY5M2Y2
OGJjY2Q5ODhhZjdlNmY3MzM4NDg2MGFjMjQxYjc4L3ZtbGludXotMy4xNi4wLXJjNS0wNTAy
My1nYmMxZjJmOQoKMjAxNC0wNy0xNy0wNzoyOTo0MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAu
CTIJNTcJMTg5CTI4OAkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMzcyIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzBkN2UxY2E0MGVm
MTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzhdIE1lcmdlICdkeW50aWNrcy9ub2h6L3N5
c2lkbGUnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
LTcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctczEtMDcxNzAyMDYvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQw
NzE3MDE6MGQ3ZTFjYTQwZWYxNmZjZTUyOTc1NzkxMjE3MTdmYzc5Mzc2MWIzODpiaXNlY3Qt
bGludXgtNwogVEVTVCBGQUlMVVJFClsgICAgOC44OTk5MzBdIHJhbmRvbTogbm9uYmxvY2tp
bmcgcG9vbCBpcyBpbml0aWFsaXplZApbICAgMTIuNDUzOTMwXSBzb2NrOiBwcm9jZXNzIGB0
cmluaXR5LW1haW4nIGlzIHVzaW5nIG9ic29sZXRlIHNldHNvY2tvcHQgU09fQlNEQ09NUEFU
CgpCVUc6IGtlcm5lbCBib290IGhhbmcKRWxhcHNlZCB0aW1lOiAzNQpxZW11LXN5c3RlbS14
ODZfNjQgLWNwdSBrdm02NCAtZW5hYmxlLWt2bSAta2VybmVsIC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDcxNzAyMDYvMGQ3ZTFjYTQwZWYxNmZjZTUyOTc1NzkxMjE3MTdmYzc5
Mzc2MWIzOC92bWxpbnV6LTMuMTYuMC1yYzUtMDU2MDktZzBkN2UxY2EgLWFwcGVuZCAnaHVu
Z190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVi
dWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0
PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBw
cm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9
bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDA3MTcwMTowZDdlMWNhNDBlZjE2ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYx
YjM4OmJpc2VjdC1saW51eC03Ly52bWxpbnV6LTBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIx
NzE3ZmM3OTM3NjFiMzgtMjAxNDA3MTcwNzI1MzAtOTUtaXZiNDEgYnJhbmNoPWxpbnV4LWRl
dmVsL2RldmVsLWhvdXJseS0yMDE0MDcxNzAxIEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8wZDdlMWNhNDBlZjE2ZmNlNTI5NzU3OTEyMTcxN2Zj
NzkzNzYxYjM4L3ZtbGludXotMy4xNi4wLXJjNS0wNTYwOS1nMGQ3ZTFjYSBkcmJkLm1pbm9y
X2NvdW50PTgnICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3F1YW50YWwtY29yZS14
ODZfNjQuY2d6IC1tIDMyMCAtc21wIDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1u
ZXQgdXNlcix2bGFuPTEgLWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYz
MDBlc2IgLXJ0YyBiYXNlPWxvY2FsdGltZSAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQt
cXVhbnRhbC1pdmI0MS0xMDEgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1x
dWFudGFsLWl2YjQxLTEwMSAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVs
bCAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8wZDdlMWNhNDBlZjE2
ZmNlNTI5NzU3OTEyMTcxN2ZjNzkzNzYxYjM4L2RtZXNnLXF1YW50YWwta2J1aWxkLTI2OjIw
MTQwNzE3MDcyNDEwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUt
MDU2MDktZzBkN2UxY2E6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2
LzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzgvZG1lc2cteW9jdG8t
a2J1aWxkLTIwOjIwMTQwNzE3MDcyNDAwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2
OjMuMTYuMC1yYzUtMDU2MDktZzBkN2UxY2E6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2LzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzgv
ZG1lc2cteW9jdG8ta2J1aWxkLTI4OjIwMTQwNzE3MDcyMzUxOng4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU2MDktZzBkN2UxY2E6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzBkN2UxY2E0MGVmMTZmY2U1Mjk3NTc5MTIxNzE3
ZmM3OTM3NjFiMzgvZG1lc2cteW9jdG8ta2J1aWxkLTI4OjIwMTQwNzE3MDcyNDAzOng4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU2MDktZzBkN2UxY2E6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzBkN2UxY2E0MGVmMTZmY2U1
Mjk3NTc5MTIxNzE3ZmM3OTM3NjFiMzgvZG1lc2cteW9jdG8ta2J1aWxkLTU6MjAxNDA3MTcw
NzI0MDQ6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTYwOS1n
MGQ3ZTFjYToxCjkwOjU6MTIzIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0y
MDE0LTA3LTE3IDA3OjMzOjM5IFJFUEVBVCBDT1VOVDogMzAwICAjIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4LTcvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA1ODYgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbMzNjMTNi
ZjI0ODdhNDJlZmExYWM5YmNjZTU2MjNhYjc0YTM3NWM5M10gTWVyZ2UgJ3ViaWZzL2xpbnV4
LW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
LTcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctczEtMDcxNzAyMDYvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQw
NzE3MDE6MzNjMTNiZjI0ODdhNDJlZmExYWM5YmNjZTU2MjNhYjc0YTM3NWM5MzpiaXNlY3Qt
bGludXgtNwoKMjAxNC0wNy0xNy0wNzozMzo0MCAzM2MxM2JmMjQ4N2E0MmVmYTFhYzliY2Nl
NTYyM2FiNzRhMzc1YzkzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LTMzYzEz
YmYyNDg3YTQyZWZhMWFjOWJjY2U1NjIzYWI3NGEzNzVjOTMKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzMzYzEzYmYyNDg3YTQy
ZWZhMWFjOWJjY2U1NjIzYWI3NGEzNzVjOTMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2
LTMzYzEzYmYyNDg3YTQyZWZhMWFjOWJjY2U1NjIzYWI3NGEzNzVjOTMKa2VybmVsOiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzMzYzEzYmYyNDg3YTQyZWZhMWFj
OWJjY2U1NjIzYWI3NGEzNzVjOTMvdm1saW51ei0zLjE2LjAtcmM1LTA1MjI1LWczM2MxM2Jm
CgoyMDE0LTA3LTE3LTA3OjM1OjQwIGRldGVjdGluZyBib290IHN0YXRlIAkyOQkxNjYJMzAw
IFNVQ0NFU1MKCkJpc2VjdGluZzogMzg0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbMTAzMmY3M2EzMjk1MWQ3ZjE0ZWQ3ZmRhZGVkYjBm
ZWYzYzZkMGY0OV0gTWVyZ2UgJ3NwaS9mb3ItbmV4dCcgaW50byBkZXZlbC1ob3VybHktMjAx
NDA3MTcwMQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNy9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMToxMDMyZjczYTMyOTUxZDdmMTRlZDdm
ZGFkZWRiMGZlZjNjNmQwZjQ5OmJpc2VjdC1saW51eC03CgoyMDE0LTA3LTE3LTA3OjM3OjE5
IDEwMzJmNzNhMzI5NTFkN2YxNGVkN2ZkYWRlZGIwZmVmM2M2ZDBmNDkgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctczEtMDcxNzAyMDYtMTAzMmY3M2EzMjk1MWQ3ZjE0ZWQ3ZmRhZGVkYjBmZWYz
YzZkMGY0OQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDcxNzAyMDYvMTAzMmY3M2EzMjk1MWQ3ZjE0ZWQ3ZmRhZGVkYjBmZWYzYzZkMGY0OQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYtMTAzMmY3M2EzMjk1MWQ3ZjE0ZWQ3ZmRhZGVk
YjBmZWYzYzZkMGY0OQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcx
NzAyMDYvMTAzMmY3M2EzMjk1MWQ3ZjE0ZWQ3ZmRhZGVkYjBmZWYzYzZkMGY0OS92bWxpbnV6
LTMuMTYuMC1yYzUtMDUzNzYtZzEwMzJmNzMKCjIwMTQtMDctMTctMDc6NDA6MTkgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLi4JMTE0CTE2OQkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMzMg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpClsx
ZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxXSBNZXJnZSAnc2hhd25n
dW8vZm9yLW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4LTcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5
LTIwMTQwNzE3MDE6MWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MTpi
aXNlY3QtbGludXgtNwoKMjAxNC0wNy0xNy0wNzo0MzowMiAxZjI4NTlmMDc4NjMzOGZlNGMy
YTE4ZWE1MThhNWIyYTJmMWI1NDkxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2
LTFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYw
Nzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3
MTcwMjA2LTFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4
ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvdm1saW51ei0zLjE2LjAtcmM1LTA1NTY3LWcx
ZjI4NTlmCgoyMDE0LTA3LTE3LTA4OjAxOjAyIGRldGVjdGluZyBib290IHN0YXRlIAkxNiBU
RVNUIEZBSUxVUkUKWyAgICA5LjIxMjMzNV0gcmFuZG9tOiBub25ibG9ja2luZyBwb29sIGlz
IGluaXRpYWxpemVkClsgICAxMi43NTAzMThdIHNvY2s6IHByb2Nlc3MgYHRyaW5pdHktbWFp
bicgaXMgdXNpbmcgb2Jzb2xldGUgc2V0c29ja29wdCBTT19CU0RDT01QQVQKCkJVRzoga2Vy
bmVsIGJvb3QgaGFuZwpFbGFwc2VkIHRpbWU6IDM1CnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1
IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL3Zt
bGludXotMy4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZiAtYXBwZW5kICdodW5nX3Rhc2tfcGFu
aWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9h
bHdheXNfZW5hYmxlZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmlj
PTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1k
aXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJv
b3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0
MDcxNzAxOjFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTE6YmlzZWN0
LWxpbnV4LTcvLnZtbGludXotMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFi
NTQ5MS0yMDE0MDcxNzE2MDA1MC0xNTgtaXZiNDMgYnJhbmNoPWxpbnV4LWRldmVsL2RldmVs
LWhvdXJseS0yMDE0MDcxNzAxIEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkx
L3ZtbGludXotMy4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZiBkcmJkLm1pbm9yX2NvdW50PTgn
ICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3F1YW50YWwtY29yZS14ODZfNjQuY2d6
IC1tIDMyMCAtc21wIDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2
bGFuPTEgLWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0
YyBiYXNlPWxvY2FsdGltZSAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1p
dmI0My0xMjQgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFudGFsLWl2
YjQzLTEyNCAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4
ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXF1YW50YWwta2J1aWxkLTIyOjIwMTQwNzE3MDc1
ODIxOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFm
Mjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYw
Nzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTI4
OjIwMTQwNzE3MDc1ODIyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1y
YzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcw
MjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2ctcXVh
bnRhbC1rYnVpbGQtMTA6MjAxNDA3MTcwNzU4Mjg6eDg2XzY0LXJhbmRjb25maWctczEtMDcx
NzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFi
NTQ5MS9kbWVzZy1xdWFudGFsLWtidWlsZC0xMzoyMDE0MDcxNzA3NTgzMjp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4
ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXF1YW50YWwta2J1aWxkLTE1OjIwMTQwNzE3MDc1
ODI4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFm
Mjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYw
Nzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2ctcXVhbnRhbC1rYnVpbGQt
MTk6MjAxNDA3MTcwNzU4Mjk6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4w
LXJjNS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcx
NzAyMDYvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy1x
dWFudGFsLWtidWlsZC0xOjIwMTQwNzE3MDc1ODMwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3
MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYx
YjU0OTEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjI6MjAxNDA3MTcwNzU4MzI6eDg2XzY0LXJh
bmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3ODYzMzhmZTRjMmEx
OGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy1xdWFudGFsLWtidWlsZC0yODoyMDE0MDcxNzA3
NTgzMTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NTY3LWcx
ZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlm
MDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXlvY3RvLWtidWlsZC0x
MzoyMDE0MDcxNzA3NTgyNzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAt
cmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3
MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXlv
Y3RvLWtidWlsZC0xNToyMDE0MDcxNzA3NTgyOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3
MDIwNjozLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1
NDkxL2RtZXNnLXlvY3RvLWtidWlsZC0xNjoyMDE0MDcxNzA3NTgzMjp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1
MThhNWIyYTJmMWI1NDkxL2RtZXNnLXlvY3RvLWtidWlsZC0xODoyMDE0MDcxNzA3NTgyODp4
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlm
OjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMz
OGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXlvY3RvLWtidWlsZC0yMToyMDE0
MDcxNzA3NTgyOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1
NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8x
ZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXlvY3RvLWti
dWlsZC0yMjoyMDE0MDcxNzA3NTgyOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjoz
LjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2Rt
ZXNnLXlvY3RvLWtidWlsZC0yNDoyMDE0MDcxNzA3NTgyNzp4ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIy
YTJmMWI1NDkxL2RtZXNnLXlvY3RvLWtidWlsZC0yNToyMDE0MDcxNzA3NTgyNzp4ODZfNjQt
cmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMy
YTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXlvY3RvLWtidWlsZC0yOjIwMTQwNzE3MDc1
ODI3Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFm
Mjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYw
Nzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTM6
MjAxNDA3MTcwNzU4Mjk6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJj
NS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAy
MDYvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0
by1rYnVpbGQtNjoyMDE0MDcxNzA3NTgyOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIw
NjozLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkx
L2RtZXNnLXlvY3RvLWtidWlsZC03OjIwMTQwNzE3MDc1ODI4Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1
YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTEzOjIwMTQwNzE3MDc1ODM4Ong4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0
YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTE0OjIwMTQwNzE3
MDc1ODM4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1Njct
ZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1
OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8ta2J1aWxk
LTI0OjIwMTQwNzE3MDc1ODM3Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYu
MC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3
MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2ct
eW9jdG8ta2J1aWxkLTI1OjIwMTQwNzE3MDc1ODM4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3
MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYx
YjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTI3OjIwMTQwNzE3MDc1ODM3Ong4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThl
YTUxOGE1YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTI4OjIwMTQwNzE3MDc1ODM3
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1
OWY6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2
MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTI6MjAx
NDA3MTcwNzU4Mzg6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0w
NTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYv
MWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0by1r
YnVpbGQtODoyMDE0MDcxNzA3NTgzNzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjoz
LjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2Rt
ZXNnLXF1YW50YWwta2J1aWxkLTEwOjIwMTQwNzE3MDc1ODM5Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1
YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTc6MjAxNDA3MTcwNzU4Mzk6eDg2XzY0
LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZjozCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3ODYzMzhmZTRj
MmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0by1rYnVpbGQtMTg6MjAxNDA3MTcw
NzU4Mzk6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1n
MWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5
ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0by1rYnVpbGQt
MzoyMDE0MDcxNzA3NTgzOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAt
cmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3
MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXF1
YW50YWwta2J1aWxkLTE1OjIwMTQwNzE3MDc1ODM5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3
MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYx
YjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTIyOjIwMTQwNzE3MDc1ODQwOng4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThl
YTUxOGE1YjJhMmYxYjU0OTEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTI6MjAxNDA3MTcwNzU4
NDA6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYy
ODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3
ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0by1rYnVpbGQtMjE6
MjAxNDA3MTcwNzU4NDA6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJj
NS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAy
MDYvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0
by1rYnVpbGQtNjoyMDE0MDcxNzA3NTg0MDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIw
NjozLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkx
L2RtZXNnLXF1YW50YWwta2J1aWxkLTEzOjIwMTQwNzE3MDc1ODQzOng4Nl82NC1yYW5kY29u
ZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUx
OGE1YjJhMmYxYjU0OTEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTc6MjAxNDA3MTcwNzU4NDI6
eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5
ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3ODYz
MzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy1xdWFudGFsLWtidWlsZC0xOToy
MDE0MDcxNzA3NTg0MDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1
LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIw
Ni8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXF1YW50
YWwta2J1aWxkLTE6MjAxNDA3MTcwNzU4NDE6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAy
MDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDcxNzAyMDYvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5
MS9kbWVzZy1xdWFudGFsLWtidWlsZC0yMDoyMDE0MDcxNzA3NTg0MTp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1
MThhNWIyYTJmMWI1NDkxL2RtZXNnLXF1YW50YWwta2J1aWxkLTIyOjIwMTQwNzE3MDc1ODQ4
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1
OWY6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2
MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjg6
MjAxNDA3MTcwNzU4NDg6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJj
NS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAy
MDYvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy1xdWFu
dGFsLWtidWlsZC0zMToyMDE0MDcxNzA3NTg0Mjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3
MDIwNjozLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1
NDkxL2RtZXNnLXF1YW50YWwta2J1aWxkLTc6MjAxNDA3MTcwNzU4NDI6eDg2XzY0LXJhbmRj
b25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVh
NTE4YTViMmEyZjFiNTQ5MS9kbWVzZy1xdWFudGFsLWtidWlsZC05OjIwMTQwNzE3MDc1ODQy
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1
OWY6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2
MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTE1OjIw
MTQwNzE3MDc1ODQwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUt
MDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2
LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8t
a2J1aWxkLTE2OjIwMTQwNzE3MDc1ODQ0Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2
OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEv
ZG1lc2cteW9jdG8ta2J1aWxkLTE3OjIwMTQwNzE3MDc1ODQ2Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1
YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTI3OjIwMTQwNzE3MDc1ODQ5Ong4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0
YzJhMThlYTUxOGE1YjJhMmYxYjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTg6MjAxNDA3MTcw
NzU4NDg6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1n
MWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5
ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0by1rYnVpbGQt
OToyMDE0MDcxNzA3NTg0NTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAt
cmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3
MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXF1
YW50YWwta2J1aWxkLTE6MjAxNDA3MTcwNzU4NTI6eDg2XzY0LXJhbmRjb25maWctczEtMDcx
NzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFi
NTQ5MS9kbWVzZy1xdWFudGFsLWtidWlsZC0yMDoyMDE0MDcxNzA3NTg1MTp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4
ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXF1YW50YWwta2J1aWxkLTk6MjAxNDA3MTcwNzU4
NTI6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYy
ODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3
ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0by1rYnVpbGQtMTQ6
MjAxNDA3MTcwNzU4NTE6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJj
NS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAy
MDYvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0
by1rYnVpbGQtMTM6MjAxNDA3MTcwNzU4NTQ6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAy
MDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDcxNzAyMDYvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5
MS9kbWVzZy15b2N0by1rYnVpbGQtMTY6MjAxNDA3MTcwNzU4NTQ6eDg2XzY0LXJhbmRjb25m
aWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4
YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0by1rYnVpbGQtMjU6MjAxNDA3MTcwNzU4NTQ6eDg2
XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5Zjoz
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3ODYzMzhm
ZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0by1rYnVpbGQtMjg6MjAxNDA3
MTcwNzU4NTQ6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2
Ny1nMWYyODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYy
ODU5ZjA3ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy15b2N0by1rYnVp
bGQtMjoyMDE0MDcxNzA3NTg1NDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2
LjAtcmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
NzE3MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNn
LXlvY3RvLWtidWlsZC03OjIwMTQwNzE3MDc1ODU1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3
MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYx
YjU0OTEvZG1lc2cteW9jdG8ta2J1aWxkLTE4OjIwMTQwNzE3MDc1ODU2Ong4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThl
YTUxOGE1YjJhMmYxYjU0OTEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTA6MjAxNDA3MTcwNzU5
MDE6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYy
ODU5ZjozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3
ODYzMzhmZTRjMmExOGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy1xdWFudGFsLWtidWlsZC0x
MzoyMDE0MDcxNzA3NTg1OTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAt
cmM1LTA1NTY3LWcxZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3
MDIwNi8xZjI4NTlmMDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXF1
YW50YWwta2J1aWxkLTE1OjIwMTQwNzE3MDc1OTAxOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3
MTcwMjA2OjMuMTYuMC1yYzUtMDU1NjctZzFmMjg1OWY6Mwova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2LzFmMjg1OWYwNzg2MzM4ZmU0YzJhMThlYTUxOGE1YjJhMmYx
YjU0OTEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTc6MjAxNDA3MTcwNzU4NTg6eDg2XzY0LXJh
bmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTU2Ny1nMWYyODU5ZjozCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvMWYyODU5ZjA3ODYzMzhmZTRjMmEx
OGVhNTE4YTViMmEyZjFiNTQ5MS9kbWVzZy1xdWFudGFsLWtidWlsZC0zMToyMDE0MDcxNzA3
NTg1ODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NTY3LWcx
ZjI4NTlmOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi8xZjI4NTlm
MDc4NjMzOGZlNGMyYTE4ZWE1MThhNWIyYTJmMWI1NDkxL2RtZXNnLXF1YW50YWwta2J1aWxk
LTc6MjAxNDA3MTcwNzU4NTg6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4w
LXJjNS0wNTU2Ny1nMWYyODU5ZjozCjU6NzE6ODIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKCkJpc2VjdGluZzogMTkxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSA4IHN0ZXBzKQpbNzNjNDc2ODhhMDM5MTU4YTZkMzk1NjI5ZDNhYjMyZTYwNmUx
M2QxYV0gTWVyZ2UgJ3JlZ3VsYXRvci9mb3ItbmV4dCcgaW50byBkZXZlbC1ob3VybHktMjAx
NDA3MTcwMQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNy9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MTcwMTo3M2M0NzY4OGEwMzkxNThhNmQzOTU2
MjlkM2FiMzJlNjA2ZTEzZDFhOmJpc2VjdC1saW51eC03CgoyMDE0LTA3LTE3LTA4OjAyOjA2
IDczYzQ3Njg4YTAzOTE1OGE2ZDM5NTYyOWQzYWIzMmU2MDZlMTNkMWEgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctczEtMDcxNzAyMDYtNzNjNDc2ODhhMDM5MTU4YTZkMzk1NjI5ZDNhYjMyZTYw
NmUxM2QxYQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDcxNzAyMDYvNzNjNDc2ODhhMDM5MTU4YTZkMzk1NjI5ZDNhYjMyZTYwNmUxM2QxYQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYtNzNjNDc2ODhhMDM5MTU4YTZkMzk1NjI5ZDNh
YjMyZTYwNmUxM2QxYQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvbGtwLWhzeDAxLWNvbnN1bWVyL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3
MTcwMjA2LTczYzQ3Njg4YTAzOTE1OGE2ZDM5NTYyOWQzYWIzMmU2MDZlMTNkMWEKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzczYzQ3Njg4YTAzOTE1
OGE2ZDM5NTYyOWQzYWIzMmU2MDZlMTNkMWEvdm1saW51ei0zLjE2LjAtcmM1LTA1NDM2LWc3
M2M0NzY4CgoyMDE0LTA3LTE3LTA4OjI1OjEyIGRldGVjdGluZyBib290IHN0YXRlIAkxOQk1
NgkxNzcJMzAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTMxIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbYjk3M2ZkZjVlNmU2ZmU4NGI1MWY3
OTkxOWU1ZGM4NTc0YWU4NTlkYV0gTWVyZ2UgJ2x1dG8vc3luY19yYW5kX3NlZWQnIGludG8g
ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDEKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTcvb2JqLWJpc2Vj
dApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
czEtMDcxNzAyMDYvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6Yjk3M2Zk
ZjVlNmU2ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYTpiaXNlY3QtbGludXgtNwoKMjAx
NC0wNy0xNy0wODoyNzoxMyBiOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1
OWRhIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LWI5NzNmZGY1ZTZlNmZlODRi
NTFmNzk5MTllNWRjODU3NGFlODU5ZGEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTll
NWRjODU3NGFlODU5ZGEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LWI5NzNmZGY1ZTZl
NmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNzE3MDIwNi1iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRh
Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iOTczZmRm
NWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL3ZtbGludXotMy4xNi4wLXJjNS0w
NTQ0My1nYjk3M2ZkZgoKMjAxNC0wNy0xNy0wODozODoxMyBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAJMSBURVNUIEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gRGVudHJ5IGNhY2hlIGhhc2ggdGFi
bGUgZW50cmllczogNjU1MzYgKG9yZGVyOiA3LCA1MjQyODggYnl0ZXMpClsgICAgMC4wMDAw
MDBdIElub2RlLWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogMzI3NjggKG9yZGVyOiA2LCAy
NjIxNDQgYnl0ZXMpClsgICAgMC4wMDAwMDBdIHhzYXZlOiBlbmFibGVkIHhzdGF0ZV9idiAw
eDcsIGNudHh0IHNpemUgMHgwClsgICAgMC4wMDAwMDBdIEJVRzogdW5hYmxlIHRvIGhhbmRs
ZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDAwMDAwMDA2ZmMK
WyAgICAwLjAwMDAwMF0gSVA6IFs8ZmZmZmZmZmY4MWNiNDFiNT5dIF9fZnJlZV9wYWdlc19i
b290bWVtKzB4MjEvMHg5ZApbICAgIDAuMDAwMDAwXSBQR0QgMCAKWyAgICAwLjAwMDAwMF0g
T29wczogMDAwMiBbIzFdIApbICAgIDAuMDAwMDAwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAg
ICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMu
MTYuMC1yYzUtMDU0NDMtZ2I5NzNmZGYgIzEKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFt
ZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDAwMDAwXSB0
YXNrOiBmZmZmZmZmZjgxYTFhNGMwIHRpOiBmZmZmZmZmZjgxYTAwMDAwIHRhc2sudGk6IGZm
ZmZmZmZmODFhMDAwMDAKWyAgICAwLjAwMDAwMF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MWNi
NDFiNT5dICBbPGZmZmZmZmZmODFjYjQxYjU+XSBfX2ZyZWVfcGFnZXNfYm9vdG1lbSsweDIx
LzB4OWQKWyAgICAwLjAwMDAwMF0gUlNQOiAwMDAwOmZmZmZmZmZmODFhMDNlZDggIEVGTEFH
UzogMDAwMTAwMTIKWyAgICAwLjAwMDAwMF0gUkFYOiAwMDAwMDAwMDAwMDAwNzM0IFJCWDog
MDAwMDAwMDAwMDAwMDAxMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDQKWyAgICAwLjAwMDAwMF0g
UkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAwNCBSREk6IDAwMDAw
MDAwMDAwMDA2ZmMKWyAgICAwLjAwMDAwMF0gUkJQOiBmZmZmZmZmZjgxYTAzZjAwIFIwODog
MDAwMDAwMDAwMDAwMDAwZiBSMDk6IDAwMDAwMDAwMDAwMDAwMTAKWyAgICAwLjAwMDAwMF0g
UjEwOiAwMDAwMDAwMDAwMDAwMDFjIFIxMTogMDAwMDAwMDAwMDA5ZjAwMCBSMTI6IDAwMDAw
MDAwMDAwMDAwOTkKWyAgICAwLjAwMDAwMF0gUjEzOiAwMDAwMDAwMDAwMDAwMDIwIFIxNDog
MDAwMDAwMDAwMDAwMDAwYSBSMTU6IGZmZmZmZmZmODFjOWIxMjAKWyAgICAwLjAwMDAwMF0g
RlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODFhMjUwMDAoMDAwMCkg
a25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDAwMDAwXSBDUzogIDAwMTAgRFM6IDAw
MDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgICAgMC4wMDAwMDBdIENSMjog
MDAwMDAwMDAwMDAwMDZmYyBDUjM6IDAwMDAwMDAwMDFhMTUwMDAgQ1I0OiAwMDAwMDAwMDAw
MDQwNmEwClsgICAgMC4wMDAwMDBdIFN0YWNrOgpbICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4
MWNiNmM4MCAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODFkMTk5NDAgZmZmZjg4MDAxM2Zm
YzE0MApbICAgIDAuMDAwMDAwXSAgZmZmZmZmZmY4MWQyMDBhMCBmZmZmZmZmZjgxYTAzZjM4
IGZmZmZmZmZmODFjYjZlOTAgMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDAwMDAwXSAgMDAw
MDAwMDAwMDAxMDAwMCAwMDAwMDAwMDAwMDk5MDAwIDAwMDAwMDAyMDAwMDAwMDAgZmZmZmZm
ZmZmZmZmZmZmZgpbICAgIDAuMDAwMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAg
WzxmZmZmZmZmZjgxY2I2YzgwPl0gPyBfX2ZyZWVfbWVtb3J5X2NvcmUrMHhhMi8weGI5Clsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjYjZlOTA+XSBmcmVlX2FsbF9ib290bWVtKzB4
NTEvMHhkMgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxY2FiMTRlPl0gbWVtX2luaXQr
MHhlLzB4MjEKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWM5YmUyOD5dIHN0YXJ0X2tl
cm5lbCsweDFlYi8weDRlYQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxYzliOThjPl0g
PyBzZXRfaW5pdF9hcmcrMHg1NS8weDU1ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFj
OWI1YjE+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4MmEvMHgyYwpbICAgIDAuMDAw
MDAwXSAgWzxmZmZmZmZmZjgxYzliNzI1Pl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweDE3Mi8w
eDE4MQpbICAgIDAuMDAwMDAwXSBDb2RlOiA4OSBlNSA1ZCBjMyA1NSA0OCA4OSBlNSA1ZCBj
MyA0MCA4OCBmMSA0MSBiOSAwMSAwMCAwMCAwMCA0MSBkMyBlMSAwZiAxOCAwZiAzMSBkMiA0
OCA4OSBmOCA0NSA4ZCA0MSBmZiBlYiAxNSA0OCA4MyBjMCAzOCAwZiAxOCAwOCA8MGY+IGJh
IDcwIGM4IDBhIGM3IDQwIGU0IDAwIDAwIDAwIDAwIGZmIGMyIDQxIDM5IGQwIDc3IGU2IDRk
IDZiIApbICAgIDAuMDAwMDAwXSBSSVAgIFs8ZmZmZmZmZmY4MWNiNDFiNT5dIF9fZnJlZV9w
YWdlc19ib290bWVtKzB4MjEvMHg5ZApbICAgIDAuMDAwMDAwXSAgUlNQIDxmZmZmZmZmZjgx
YTAzZWQ4PgpbICAgIDAuMDAwMDAwXSBDUjI6IDAwMDAwMDAwMDAwMDA2ZmMKWyAgICAwLjAw
MDAwMF0gLS0tWyBlbmQgdHJhY2UgN2I4NGU0MTc1NmU4ZTBhOCBdLS0tClsgICAgMC4wMDAw
MDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBBdHRlbXB0ZWQgdG8ga2lsbCB0aGUg
aWRsZSB0YXNrIQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2I5NzNm
ZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEvZG1lc2ctcXVhbnRhbC1rYnVp
bGQtMTA6MjAxNDA3MTcwODM2MDM6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4x
Ni4wLXJjNS0wNTQ0My1nYjk3M2ZkZjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEt
MDcxNzAyMDYvYjk3M2ZkZjVlNmU2ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYS9kbWVz
Zy1xdWFudGFsLWtidWlsZC0xMjoyMDE0MDcxNzA4MzYwMzp4ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NDQzLWdiOTczZmRmOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1
NzRhZTg1OWRhL2RtZXNnLXF1YW50YWwta2J1aWxkLTEzOjIwMTQwNzE3MDgzNjAzOng4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU0NDMtZ2I5NzNmZGY6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2I5NzNmZGY1ZTZlNmZlODRi
NTFmNzk5MTllNWRjODU3NGFlODU5ZGEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTQ6MjAxNDA3
MTcwODM2MDM6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTQ0
My1nYjk3M2ZkZjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvYjk3
M2ZkZjVlNmU2ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYS9kbWVzZy1xdWFudGFsLWti
dWlsZC0xNToyMDE0MDcxNzA4MzYwNDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjoz
LjE2LjAtcmM1LTA1NDQzLWdiOTczZmRmOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNzE3MDIwNi9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2Rt
ZXNnLXF1YW50YWwta2J1aWxkLTE4OjIwMTQwNzE3MDgzNjA0Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU0NDMtZ2I5NzNmZGY6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRj
ODU3NGFlODU5ZGEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMToyMDE0MDcxNzA4MzYwMjp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NDQzLWdiOTczZmRmOjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iOTczZmRmNWU2ZTZmZTg0
YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2RtZXNnLXF1YW50YWwta2J1aWxkLTIwOjIwMTQw
NzE3MDgzNjAyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU0
NDMtZ2I5NzNmZGY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2I5
NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEvZG1lc2ctcXVhbnRhbC1r
YnVpbGQtMjI6MjAxNDA3MTcwODM2MDQ6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6
My4xNi4wLXJjNS0wNTQ0My1nYjk3M2ZkZjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDcxNzAyMDYvYjk3M2ZkZjVlNmU2ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYS9k
bWVzZy1xdWFudGFsLWtidWlsZC0yNDoyMDE0MDcxNzA4MzYwMzp4ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NDQzLWdiOTczZmRmOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVk
Yzg1NzRhZTg1OWRhL2RtZXNnLXF1YW50YWwta2J1aWxkLTI1OjIwMTQwNzE3MDgzNjA0Ong4
Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU0NDMtZ2I5NzNmZGY6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2I5NzNmZGY1ZTZlNmZl
ODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjc6MjAx
NDA3MTcwODM2MDI6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0w
NTQ0My1nYjk3M2ZkZjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYv
Yjk3M2ZkZjVlNmU2ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYS9kbWVzZy1xdWFudGFs
LWtidWlsZC0yOjIwMTQwNzE3MDgzNjAzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2
OjMuMTYuMC1yYzUtMDU0NDMtZ2I5NzNmZGY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2L2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEv
ZG1lc2ctcXVhbnRhbC1rYnVpbGQtMzA6MjAxNDA3MTcwODM2MDE6eDg2XzY0LXJhbmRjb25m
aWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTQ0My1nYjk3M2ZkZjoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvYjk3M2ZkZjVlNmU2ZmU4NGI1MWY3OTkxOWU1
ZGM4NTc0YWU4NTlkYS9kbWVzZy1xdWFudGFsLWtidWlsZC00OjIwMTQwNzE3MDgzNjAzOng4
Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU0NDMtZ2I5NzNmZGY6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2I5NzNmZGY1ZTZlNmZl
ODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtOToyMDE0
MDcxNzA4MzYwMjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1
NDQzLWdiOTczZmRmOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9i
OTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2RtZXNnLXF1YW50YWwt
a2J1aWxkLTEwOjIwMTQwNzE3MDgzNjE4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2
OjMuMTYuMC1yYzUtMDU0NDMtZ2I5NzNmZGY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2L2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEv
ZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTI6MjAxNDA3MTcwODM2MTg6eDg2XzY0LXJhbmRjb25m
aWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTQ0My1nYjk3M2ZkZjoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvYjk3M2ZkZjVlNmU2ZmU4NGI1MWY3OTkxOWU1
ZGM4NTc0YWU4NTlkYS9kbWVzZy1xdWFudGFsLWtidWlsZC0xMzoyMDE0MDcxNzA4MzYxMzp4
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NDQzLWdiOTczZmRm
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iOTczZmRmNWU2ZTZm
ZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2RtZXNnLXF1YW50YWwta2J1aWxkLTE0OjIw
MTQwNzE3MDgzNjE4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUt
MDU0NDMtZ2I5NzNmZGY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2
L2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEvZG1lc2ctcXVhbnRh
bC1rYnVpbGQtMTU6MjAxNDA3MTcwODM2MTU6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAy
MDY6My4xNi4wLXJjNS0wNTQ0My1nYjk3M2ZkZjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDcxNzAyMDYvYjk3M2ZkZjVlNmU2ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlk
YS9kbWVzZy1xdWFudGFsLWtidWlsZC0xODoyMDE0MDcxNzA4MzYxNTp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NDQzLWdiOTczZmRmOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5
ZTVkYzg1NzRhZTg1OWRhL2RtZXNnLXF1YW50YWwta2J1aWxkLTE6MjAxNDA3MTcwODM2MTg6
eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTQ0My1nYjk3M2Zk
ZjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvYjk3M2ZkZjVlNmU2
ZmU4NGI1MWY3OTkxOWU1ZGM4NTc0YWU4NTlkYS9kbWVzZy1xdWFudGFsLWtidWlsZC0yMDoy
MDE0MDcxNzA4MzYxMjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1
LTA1NDQzLWdiOTczZmRmOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIw
Ni9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2RtZXNnLXF1YW50
YWwta2J1aWxkLTIyOjIwMTQwNzE3MDgzNjIwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcw
MjA2OjMuMTYuMC1yYzUtMDU0NDMtZ2I5NzNmZGY6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA3MTcwMjA2L2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5
ZGEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjQ6MjAxNDA3MTcwODM2MTg6eDg2XzY0LXJhbmRj
b25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNTQ0My1nYjk3M2ZkZjoxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvYjk3M2ZkZjVlNmU2ZmU4NGI1MWY3OTkx
OWU1ZGM4NTc0YWU4NTlkYS9kbWVzZy1xdWFudGFsLWtidWlsZC0yNToyMDE0MDcxNzA4MzYx
Njp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NDQzLWdiOTcz
ZmRmOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iOTczZmRmNWU2
ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2RtZXNnLXF1YW50YWwta2J1aWxkLTI5
OjIwMTQwNzE3MDgzNjExOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1y
YzUtMDU0NDMtZ2I5NzNmZGY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcw
MjA2L2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3NGFlODU5ZGEvZG1lc2ctcXVh
bnRhbC1rYnVpbGQtMjoyMDE0MDcxNzA4MzYxOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3
MDIwNjozLjE2LjAtcmM1LTA1NDQzLWdiOTczZmRmOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNzE3MDIwNi9iOTczZmRmNWU2ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1
OWRhL2RtZXNnLXF1YW50YWwta2J1aWxkLTMwOjIwMTQwNzE3MDgzNjExOng4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDU0NDMtZ2I5NzNmZGY6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2I5NzNmZGY1ZTZlNmZlODRiNTFmNzk5
MTllNWRjODU3NGFlODU5ZGEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtNDoyMDE0MDcxNzA4MzYx
ODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNjozLjE2LjAtcmM1LTA1NDQzLWdiOTcz
ZmRmOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iOTczZmRmNWU2
ZTZmZTg0YjUxZjc5OTE5ZTVkYzg1NzRhZTg1OWRhL2RtZXNnLXF1YW50YWwta2J1aWxkLTk6
MjAxNDA3MTcwODM2MTg6eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJj
NS0wNTQ0My1nYjk3M2ZkZjoxCjE6MzI6MzIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
CmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIGx1dG8vc3luY19yYW5kX3NlZWQK
bGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0
OiBnaXQgYmlzZWN0IHN0YXJ0IGI5NzNmZGY1ZTZlNmZlODRiNTFmNzk5MTllNWRjODU3NGFl
ODU5ZGEgNzNjNDc2ODhhMDM5MTU4YTZkMzk1NjI5ZDNhYjMyZTYwNmUxM2QxYSAtLQpQcmV2
aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBiOTczZmRmLi4uIE1lcmdlICdsdXRvL3N5bmNfcmFu
ZF9zZWVkJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDcxNzAxCkhFQUQgaXMgbm93IGF0IGEz
NWMwN2QuLi4gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnZnRyYWNlL2Zvci1uZXh0
JwpCaXNlY3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDEgc3RlcCkKWzU3NzhlNjVkNWNhNTJiZWJiYWEwMjNlMTc3ZDg2M2U0NGYwOThlOTZd
IHJhbmRvbSx4ODY6IEFkZCBhcmNoX2dldF9zbG93X3JuZ191NjQKbGluZWFyLWJpc2VjdDog
Z2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC03L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4LTcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIw
MTQwNzE3MDE6NTc3OGU2NWQ1Y2E1MmJlYmJhYTAyM2UxNzdkODYzZTQ0ZjA5OGU5NjpiaXNl
Y3QtbGludXgtNwoKMjAxNC0wNy0xNy0wODozODo0OCA1Nzc4ZTY1ZDVjYTUyYmViYmFhMDIz
ZTE3N2Q4NjNlNDRmMDk4ZTk2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LTU3
NzhlNjVkNWNhNTJiZWJiYWEwMjNlMTc3ZDg2M2U0NGYwOThlOTYKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzU3NzhlNjVkNWNh
NTJiZWJiYWEwMjNlMTc3ZDg2M2U0NGYwOThlOTYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcw
MjA2LTU3NzhlNjVkNWNhNTJiZWJiYWEwMjNlMTc3ZDg2M2U0NGYwOThlOTYKa2VybmVsOiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzU3NzhlNjVkNWNhNTJiZWJi
YWEwMjNlMTc3ZDg2M2U0NGYwOThlOTYvdm1saW51ei0zLjE2LjAtcmM1LTAwMDAyLWc1Nzc4
ZTY1CgoyMDE0LTA3LTE3LTA4OjQxOjQ4IGRldGVjdGluZyBib290IHN0YXRlIC4JNgkxNjkJ
MjA4CTMwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKW2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0
ODU1YmUzMjI2M2JlMmNdIHg4NixrYXNscjogVXNlIE1TUl9LVk1fR0VUX1JOR19TRUVEIGZv
ciBLQVNMUiBpZiBhdmFpbGFibGUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTcvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEt
MDcxNzAyMDYvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3MDE6ZDA3YzdmMWVk
NjE3ODllMTc1ZmE5NzUxMzQ4NTViZTMyMjYzYmUyYzpiaXNlY3QtbGludXgtNwoKMjAxNC0w
Ny0xNy0wODo0NDoxOCBkMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJj
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LWQwN2M3ZjFlZDYxNzg5ZTE3NWZh
OTc1MTM0ODU1YmUzMjI2M2JlMmMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1
YmUzMjI2M2JlMmMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LWQwN2M3ZjFlZDYxNzg5
ZTE3NWZhOTc1MTM0ODU1YmUzMjI2M2JlMmMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA3MTcwMjA2L2QwN2M3ZjFlZDYxNzg5ZTE3NWZhOTc1MTM0ODU1YmUzMjI2
M2JlMmMvdm1saW51ei0zLjE2LjAtcmM1LTAwMDA0LWdkMDdjN2YxCgoyMDE0LTA3LTE3LTA4
OjUxOjE5IGRldGVjdGluZyBib290IHN0YXRlIC4uIFRFU1QgRkFJTFVSRQpbICAgIDAuMDAw
MDAwXSBEZW50cnkgY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiA2NTUzNiAob3JkZXI6IDcs
IDUyNDI4OCBieXRlcykKWyAgICAwLjAwMDAwMF0gSW5vZGUtY2FjaGUgaGFzaCB0YWJsZSBl
bnRyaWVzOiAzMjc2OCAob3JkZXI6IDYsIDI2MjE0NCBieXRlcykKWyAgICAwLjAwMDAwMF0g
eHNhdmU6IGVuYWJsZWQgeHN0YXRlX2J2IDB4NywgY250eHQgc2l6ZSAweDAKWyAgICAwLjAw
MDAwMF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZl
cmVuY2UgYXQgMDAwMDAwMDAwMDAwMDZmYwpbICAgIDAuMDAwMDAwXSBJUDogWzxmZmZmZmZm
ZjgxY2I0MTA4Pl0gX19mcmVlX3BhZ2VzX2Jvb3RtZW0rMHgyMS8weDlkClsgICAgMC4wMDAw
MDBdIFBHRCAwIApbICAgIDAuMDAwMDAwXSBPb3BzOiAwMDAyIFsjMV0gClsgICAgMC4wMDAw
MDBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENv
bW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNi4wLXJjNS0wMDAwNC1nZDA3YzdmMSAjMQpb
ICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAw
MS8wMS8yMDExClsgICAgMC4wMDAwMDBdIHRhc2s6IGZmZmZmZmZmODFhMWE0YzAgdGk6IGZm
ZmZmZmZmODFhMDAwMDAgdGFzay50aTogZmZmZmZmZmY4MWEwMDAwMApbICAgIDAuMDAwMDAw
XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxY2I0MTA4Pl0gIFs8ZmZmZmZmZmY4MWNiNDEwOD5d
IF9fZnJlZV9wYWdlc19ib290bWVtKzB4MjEvMHg5ZApbICAgIDAuMDAwMDAwXSBSU1A6IDAw
MDA6ZmZmZmZmZmY4MWEwM2VkOCAgRUZMQUdTOiAwMDAxMDAxMgpbICAgIDAuMDAwMDAwXSBS
QVg6IDAwMDAwMDAwMDAwMDA3MzQgUkJYOiAwMDAwMDAwMDAwMDAwMDEwIFJDWDogMDAwMDAw
MDAwMDAwMDAwNApbICAgIDAuMDAwMDAwXSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAw
MDAwMDAwMDAwMDAwMDA0IFJESTogMDAwMDAwMDAwMDAwMDZmYwpbICAgIDAuMDAwMDAwXSBS
QlA6IGZmZmZmZmZmODFhMDNmMDAgUjA4OiAwMDAwMDAwMDAwMDAwMDBmIFIwOTogMDAwMDAw
MDAwMDAwMDAxMApbICAgIDAuMDAwMDAwXSBSMTA6IDAwMDAwMDAwMDAwMDAwMWMgUjExOiAw
MDAwMDAwMDAwMDlmMDAwIFIxMjogMDAwMDAwMDAwMDAwMDA5OQpbICAgIDAuMDAwMDAwXSBS
MTM6IDAwMDAwMDAwMDAwMDAwMjAgUjE0OiAwMDAwMDAwMDAwMDAwMDBhIFIxNTogZmZmZmZm
ZmY4MWM5YjEyMApbICAgIDAuMDAwMDAwXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkg
R1M6ZmZmZmZmZmY4MWEyNTAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAg
MC4wMDAwMDBdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAw
NTAwMzMKWyAgICAwLjAwMDAwMF0gQ1IyOiAwMDAwMDAwMDAwMDAwNmZjIENSMzogMDAwMDAw
MDAwMWExNTAwMCBDUjQ6IDAwMDAwMDAwMDAwNDA2YTAKWyAgICAwLjAwMDAwMF0gU3RhY2s6
ClsgICAgMC4wMDAwMDBdICBmZmZmZmZmZjgxY2I2YmQzIDAwMDAwMDAwMDAwMDAwMDAgZmZm
ZmZmZmY4MWQxOTk0MCBmZmZmODgwMDEzZmZjMTQwClsgICAgMC4wMDAwMDBdICBmZmZmZmZm
ZjgxZDIwMGEwIGZmZmZmZmZmODFhMDNmMzggZmZmZmZmZmY4MWNiNmRlMyAwMDAwMDAwMDAw
MDAwMDAwClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwMDEwMDAwIDAwMDAwMDAwMDAwOTkw
MDAgMDAwMDAwMDIwMDAwMDAwMCBmZmZmZmZmZmZmZmZmZmZmClsgICAgMC4wMDAwMDBdIENh
bGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjYjZiZDM+XSA/IF9fZnJl
ZV9tZW1vcnlfY29yZSsweGEyLzB4YjkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWNi
NmRlMz5dIGZyZWVfYWxsX2Jvb3RtZW0rMHg1MS8weGQyClsgICAgMC4wMDAwMDBdICBbPGZm
ZmZmZmZmODFjYWIxNTI+XSBtZW1faW5pdCsweGUvMHgyMQpbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgxYzliZTI4Pl0gc3RhcnRfa2VybmVsKzB4MWViLzB4NGVhClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODFjOWI5OGM+XSA/IHNldF9pbml0X2FyZysweDU1LzB4NTUKWyAg
ICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWM5YjViMT5dIHg4Nl82NF9zdGFydF9yZXNlcnZh
dGlvbnMrMHgyYS8weDJjClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFjOWI3MjU+XSB4
ODZfNjRfc3RhcnRfa2VybmVsKzB4MTcyLzB4MTgxClsgICAgMC4wMDAwMDBdIENvZGU6IDg5
IGU1IDVkIGMzIDU1IDQ4IDg5IGU1IDVkIGMzIDQwIDg4IGYxIDQxIGI5IDAxIDAwIDAwIDAw
IDQxIGQzIGUxIDBmIDE4IDBmIDMxIGQyIDQ4IDg5IGY4IDQ1IDhkIDQxIGZmIGViIDE1IDQ4
IDgzIGMwIDM4IDBmIDE4IDA4IDwwZj4gYmEgNzAgYzggMGEgYzcgNDAgZTQgMDAgMDAgMDAg
MDAgZmYgYzIgNDEgMzkgZDAgNzcgZTYgNGQgNmIgClsgICAgMC4wMDAwMDBdIFJJUCAgWzxm
ZmZmZmZmZjgxY2I0MTA4Pl0gX19mcmVlX3BhZ2VzX2Jvb3RtZW0rMHgyMS8weDlkClsgICAg
MC4wMDAwMDBdICBSU1AgPGZmZmZmZmZmODFhMDNlZDg+ClsgICAgMC4wMDAwMDBdIENSMjog
MDAwMDAwMDAwMDAwMDZmYwpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSBhYTAwZDA4
Yzg5ZGU0NDYwIF0tLS0KWyAgICAwLjAwMDAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNp
bmc6IEF0dGVtcHRlZCB0byBraWxsIHRoZSBpZGxlIHRhc2shCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDcxNzAyMDYvZDA3YzdmMWVkNjE3ODllMTc1ZmE5NzUxMzQ4NTViZTMy
MjYzYmUyYy9kbWVzZy1xdWFudGFsLWtidWlsZC05OjIwMTQwNzE3MDg0OTU0Ong4Nl82NC1y
YW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUtMDAwMDQtZ2QwN2M3ZjE6MQowOjE6
MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbYzZmMDdhNjM2MDFm
YmIzNmMwOWJmMjUwYjU1MzhhYmI0N2I1MWU0NF0gcmFuZG9tOiBTZWVkIHBvb2xzIGZyb20g
YXJjaF9nZXRfc2xvd19ybmdfdTY0IGF0IHN0YXJ0dXAKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTcv
b2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctczEtMDcxNzAyMDYvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzE3
MDE6YzZmMDdhNjM2MDFmYmIzNmMwOWJmMjUwYjU1MzhhYmI0N2I1MWU0NDpiaXNlY3QtbGlu
dXgtNwoKMjAxNC0wNy0xNy0wODo1MjoyMiBjNmYwN2E2MzYwMWZiYjM2YzA5YmYyNTBiNTUz
OGFiYjQ3YjUxZTQ0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LWM2ZjA3YTYz
NjAxZmJiMzZjMDliZjI1MGI1NTM4YWJiNDdiNTFlNDQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2M2ZjA3YTYzNjAxZmJiMzZj
MDliZjI1MGI1NTM4YWJiNDdiNTFlNDQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LWM2
ZjA3YTYzNjAxZmJiMzZjMDliZjI1MGI1NTM4YWJiNDdiNTFlNDQKa2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2L2M2ZjA3YTYzNjAxZmJiMzZjMDliZjI1
MGI1NTM4YWJiNDdiNTFlNDQvdm1saW51ei0zLjE2LjAtcmM1LTAwMDAzLWdjNmYwN2E2Cgoy
MDE0LTA3LTE3LTA4OjU5OjIyIGRldGVjdGluZyBib290IHN0YXRlIC4uLgkxMwk2NgkxMjMJ
MTI1LgkxMjYJMTkzCTMwMCBTVUNDRVNTCgpkMDdjN2YxZWQ2MTc4OWUxNzVmYTk3NTEzNDg1
NWJlMzIyNjNiZTJjIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCBkMDdjN2YxZWQ2
MTc4OWUxNzVmYTk3NTEzNDg1NWJlMzIyNjNiZTJjCkF1dGhvcjogQW5keSBMdXRvbWlyc2tp
IDxsdXRvQGFtYWNhcGl0YWwubmV0PgpEYXRlOiAgIFR1ZSBKdWwgMTUgMTg6MzQ6MjAgMjAx
NCAtMDcwMAoKICAgIHg4NixrYXNscjogVXNlIE1TUl9LVk1fR0VUX1JOR19TRUVEIGZvciBL
QVNMUiBpZiBhdmFpbGFibGUKICAgIAogICAgSXQncyBjb25zaWRlcmFibHkgYmV0dGVyIHRo
YW4gYW55IG9mIHRoZSBhbHRlcm5hdGl2ZXMgb24gS1ZNLgogICAgCiAgICBSYXRoZXIgdGhh
biByZWludmVudGluZyBhbGwgb2YgdGhlIGNwdSBmZWF0dXJlIHF1ZXJ5IGNvZGUsIHRoaXMg
Zml4ZXMKICAgIG5hdGl2ZV9jcHVpZCB0byB3b3JrIGluIFBJQyBvYmplY3RzLgogICAgCiAg
ICBJIGhhdmVuJ3QgY29tYmluZWQgaXQgd2l0aCBib290L2NwdWZsYWdzLmMncyBjcHVpZCBp
bXBsZW1lbnRhdGlvbjoKICAgIGluY2x1ZGluZyBhc20vcHJvY2Vzc29yLmggZnJvbSBib290
L2NwdWZsYWdzLmMgcmVzdWx0cyBpbiBhIGZsb29kIG9mCiAgICB1bnJlbGF0ZWQgZXJyb3Jz
LCBhbmQgZml4aW5nIGl0IG1pZ2h0IGJlIG1lc3N5LgogICAgCiAgICBTaWduZWQtb2ZmLWJ5
OiBBbmR5IEx1dG9taXJza2kgPGx1dG9AYW1hY2FwaXRhbC5uZXQ+Cgo6MDQwMDAwIDA0MDAw
MCA5MGRkMDk4YmQ3YWM3ODAyYjc2ZGMwNjk2MDE2MGVlMGZjMzRhZWMzIDc2NDcyNGY2ZWM2
MDQ2NThjYjI2M2VkNmU2ZTI5ZGQxNDk2ZTkxODAgTQlhcmNoCmJpc2VjdCBydW4gc3VjY2Vz
cwpIRUFEIGlzIG5vdyBhdCBjNmYwN2E2Li4uIHJhbmRvbTogU2VlZCBwb29scyBmcm9tIGFy
Y2hfZ2V0X3Nsb3dfcm5nX3U2NCBhdCBzdGFydHVwCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9saW51eC1kZXZlbDpk
ZXZlbC1ob3VybHktMjAxNDA3MTcwMTpjNmYwN2E2MzYwMWZiYjM2YzA5YmYyNTBiNTUzOGFi
YjQ3YjUxZTQ0OmJpc2VjdC1saW51eC03CgoyMDE0LTA3LTE3LTA5OjA0OjUzIGM2ZjA3YTYz
NjAxZmJiMzZjMDliZjI1MGI1NTM4YWJiNDdiNTFlNDQgcmV1c2UgL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9jNmYwN2E2MzYwMWZiYjM2YzA5YmYyNTBiNTUzOGFi
YjQ3YjUxZTQ0L3ZtbGludXotMy4xNi4wLXJjNS0wMDAwMy1nYzZmMDdhNgoKMjAxNC0wNy0x
Ny0wOTowNDo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLgkyMDMJMjU1CTMwNgk2MzIJ
NzI2CTc0OQk5MDAgU1VDQ0VTUwoKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYzZmMDdh
Ni4uLiByYW5kb206IFNlZWQgcG9vbHMgZnJvbSBhcmNoX2dldF9zbG93X3JuZ191NjQgYXQg
c3RhcnR1cApIRUFEIGlzIG5vdyBhdCA1ZTYwYzJhLi4uIDBkYXkgaGVhZCBndWFyZCBmb3Ig
J2RldmVsLWhvdXJseS0yMDE0MDcxNzAxJwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvbGludXgtZGV2ZWw6ZGV2ZWwt
aG91cmx5LTIwMTQwNzE3MDE6NWU2MGMyYWY3YThiZGU1Y2ZhZWU4ZmZkNzdjZmM1YjYyZGIw
YTA0ZTpiaXNlY3QtbGludXgtNwogVEVTVCBGQUlMVVJFCi9iaW4vc2g6IC9wcm9jL3NlbGYv
ZmQvOTogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQpbICAgIDguNTM5NzA1XSByYW5kb206
IG5vbmJsb2NraW5nIHBvb2wgaXMgaW5pdGlhbGl6ZWQKCkJVRzoga2VybmVsIGJvb3QgaGFu
ZwpFbGFwc2VkIHRpbWU6IDM1CnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFi
bGUta3ZtIC1rZXJuZWwgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi81
ZTYwYzJhZjdhOGJkZTVjZmFlZThmZmQ3N2NmYzViNjJkYjBhMDRlL3ZtbGludXotMy4xNi4w
LXJjNS0wNjM5Ni1nNWU2MGMyYSAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXBy
aW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxl
ZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2Nr
dXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29s
ZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0w
IHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA3MTcwMjA2L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcxNzAxOjVlNjBj
MmFmN2E4YmRlNWNmYWVlOGZmZDc3Y2ZjNWI2MmRiMGEwNGU6YmlzZWN0LWxpbnV4LTcvLnZt
bGludXotNWU2MGMyYWY3YThiZGU1Y2ZhZWU4ZmZkNzdjZmM1YjYyZGIwYTA0ZS0yMDE0MDcx
NzAzMjE0My00LWl2YjQxIGJyYW5jaD1saW51eC1kZXZlbC9kZXZlbC1ob3VybHktMjAxNDA3
MTcwMSBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYv
NWU2MGMyYWY3YThiZGU1Y2ZhZWU4ZmZkNzdjZmM1YjYyZGIwYTA0ZS92bWxpbnV6LTMuMTYu
MC1yYzUtMDYzOTYtZzVlNjBjMmEgZHJiZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAva2Vy
bmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUteDg2XzY0LmNneiAtbSAzMjAgLXNtcCAy
IC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0xIC1ib290IG9y
ZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRp
bWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwtaXZiNDEtMjAgLXNlcmlh
bCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFudGFsLWl2YjQxLTIwIC1kYWVtb25p
emUgLWRpc3BsYXkgbm9uZSAtbW9uaXRvciBudWxsIAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA3MTcwMjA2LzVlNjBjMmFmN2E4YmRlNWNmYWVlOGZmZDc3Y2ZjNWI2MmRiMGEw
NGUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjg6MjAxNDA3MTcwMzIxNTU6eDg2XzY0LXJhbmRj
b25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNjM5Ni1nNWU2MGMyYToxMgova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzVlNjBjMmFmN2E4YmRlNWNmYWVlOGZm
ZDc3Y2ZjNWI2MmRiMGEwNGUvZG1lc2cteW9jdG8ta2J1aWxkLTQ6MjAxNDA3MTcwMzIxNTA6
eDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDY6My4xNi4wLXJjNS0wNjM5Ni1nNWU2MGMy
YToxMgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2LzVlNjBjMmFmN2E4
YmRlNWNmYWVlOGZmZDc3Y2ZjNWI2MmRiMGEwNGUvZG1lc2cteW9jdG8ta2J1aWxkLTI1OjIw
MTQwNzE3MDMyMTUwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcwMjA2OjMuMTYuMC1yYzUt
MDYzOTYtZzVlNjBjMmE6MTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIw
Ni81ZTYwYzJhZjdhOGJkZTVjZmFlZThmZmQ3N2NmYzViNjJkYjBhMDRlL2RtZXNnLXF1YW50
YWwta2J1aWxkLTE0OjIwMTQwNzE3MDIwODQ3Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA3MTcw
MjA2OjMuMTYuMC1yYzUtMDYzOTYtZzVlNjBjMmE6MTIKMTE6NDoxMCBhbGxfZ29vZDpiYWQ6
YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQgNWU2MGMyYSAwZGF5IGhlYWQgZ3VhcmQg
Zm9yICdkZXZlbC1ob3VybHktMjAxNDA3MTcwMScKCj09PT09PT09PSBsaW51cy9tYXN0ZXIg
PT09PT09PT09CkZyb20gZ2l0Oi8vZ2l0bWlycm9yL2xpbnVzCiAgIDJkYTI5NDQuLmI2NjAz
ZmUgIG1hc3RlciAgICAgLT4gbGludXMvbWFzdGVyClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIDVlNjBjMmEuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtaG91cmx5LTIwMTQw
NzE3MDEnCkhFQUQgaXMgbm93IGF0IGI2NjAzZmUuLi4gTWVyZ2UgdGFnICdmb3ItbGludXMt
MjAxNDA3MTYnIG9mIGdpdDovL2dpdC5pbmZyYWRlYWQub3JnL2xpbnV4LW10ZApscyAtYSAv
a2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAy
MDYvbGludXM6bWFzdGVyOmI2NjAzZmU1NzRhZjI4OWRiZTllYjlmYjRjNTQwYmNhMDRmNWEw
NTM6YmlzZWN0LWxpbnV4LTcKCjIwMTQtMDctMTctMDk6MTE6MDIgYjY2MDNmZTU3NGFmMjg5
ZGJlOWViOWZiNGM1NDBiY2EwNGY1YTA1MyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3
MDIwNi1iNjYwM2ZlNTc0YWYyODlkYmU5ZWI5ZmI0YzU0MGJjYTA0ZjVhMDUzCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9iNjYw
M2ZlNTc0YWYyODlkYmU5ZWI5ZmI0YzU0MGJjYTA0ZjVhMDUzCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNzE3MDIwNi1iNjYwM2ZlNTc0YWYyODlkYmU5ZWI5ZmI0YzU0MGJjYTA0ZjVhMDUzCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3At
aHN4MDEtY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYtYjY2MDNmZTU3
NGFmMjg5ZGJlOWViOWZiNGM1NDBiY2EwNGY1YTA1MwprZXJuZWw6IC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDcxNzAyMDYvYjY2MDNmZTU3NGFmMjg5ZGJlOWViOWZiNGM1NDBi
Y2EwNGY1YTA1My92bWxpbnV6LTMuMTYuMC1yYzUtMDAxNDMtZ2I2NjAzZmUKCjIwMTQtMDct
MTctMDk6MTY6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4JMQkxMgkzNgk1NAk2MQk4
NwkxMDMuLi4uCTExOAkxNDUJMTY5CTE4NgkyMTIJMjQ0CTI1NwkyNTkuCTI2MC4JMjkyCTMw
NgkzMjcJMzU4CTM5Nwk0MTcJNDM5CTQ2Mwk0ODEJNTAzLi4JNTE0CTU2Ngk1ODcJNjA4CTYz
MAk2NjQJNjk0CTY5NS4uCTcwMC4uLgk3MDYJNzIxCTc1Mgk3NjgJNzkwLgk4MTUJODIzCTg1
Ngk4NzMJODk1CTkwMCBTVUNDRVNTCgoKPT09PT09PT09IG5leHQvbWFzdGVyID09PT09PT09
PQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiArIDMxOGNkMmEuLi5kYTEyNTc0IGFrcG0g
ICAgICAgLT4gbmV4dC9ha3BtICAoZm9yY2VkIHVwZGF0ZSkKICsgNjRlMzI0NS4uLjY4ODI5
YTMgYWtwbS1iYXNlICAtPiBuZXh0L2FrcG0tYmFzZSAgKGZvcmNlZCB1cGRhdGUpCiArIGEy
MDQxNmMuLi5kNGY0ZDFkIG1hc3RlciAgICAgLT4gbmV4dC9tYXN0ZXIgIChmb3JjZWQgdXBk
YXRlKQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5l
eHQtMjAxNDA3MTUgLT4gbmV4dC0yMDE0MDcxNQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0
LTIwMTQwNzE2IC0+IG5leHQtMjAxNDA3MTYKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMg
YjY2MDNmZS4uLiBNZXJnZSB0YWcgJ2Zvci1saW51cy0yMDE0MDcxNicgb2YgZ2l0Oi8vZ2l0
LmluZnJhZGVhZC5vcmcvbGludXgtbXRkCkhFQUQgaXMgbm93IGF0IGQ0ZjRkMWQuLi4gQWRk
IGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNzE2CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNzE3MDIwNi9uZXh0
Om1hc3RlcjpkNGY0ZDFkNDVjZDFiOWFhNjBlNjFjMmVhYjI1YTVkOWE3OWEyNmYzOmJpc2Vj
dC1saW51eC03CgoyMDE0LTA3LTE3LTA5OjUzOjM1IGQ0ZjRkMWQ0NWNkMWI5YWE2MGU2MWMy
ZWFiMjVhNWQ5YTc5YTI2ZjMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYtZDRm
NGQxZDQ1Y2QxYjlhYTYwZTYxYzJlYWIyNWE1ZDlhNzlhMjZmMwpDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvZDRmNGQxZDQ1Y2Qx
YjlhYTYwZTYxYzJlYWIyNWE1ZDlhNzlhMjZmMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAy
MDYtZDRmNGQxZDQ1Y2QxYjlhYTYwZTYxYzJlYWIyNWE1ZDlhNzlhMjZmMwprZXJuZWw6IC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDcxNzAyMDYvZDRmNGQxZDQ1Y2QxYjlhYTYw
ZTYxYzJlYWIyNWE1ZDlhNzlhMjZmMy92bWxpbnV6LTMuMTYuMC1yYzUtbmV4dC0yMDE0MDcx
NgoKMjAxNC0wNy0xNy0xMDowMTozNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTQ5CTE2Mgky
MjIJMzUzCTQ5OAk1NzYJNzMyCTkwMCBTVUNDRVNTCgo=

--V2tfspbppmK1TQo2
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
CONFIG_BROKEN_ON_SMP=y
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
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_FHANDLE=y
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

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
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
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
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
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
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
CONFIG_MODULE_SIG_SHA1=y
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha1"
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
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
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_ARCH_SLOW_RNG=y
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
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
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
# CONFIG_X86_16BIT is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=m
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
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

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

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
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
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
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
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
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

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
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
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
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=m
CONFIG_MTD_PCMCIA_ANONYMOUS=y
CONFIG_MTD_GPIO_ADDR=m
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_SPI_NOR=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=m
# CONFIG_MTD_UBI_BLOCK is not set
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
CONFIG_BLK_DEV_FD=m
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
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
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
CONFIG_INTEL_MIC_CARD=y
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECS=m
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
CONFIG_BLK_DEV_CMD640=m
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
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
# CONFIG_SCSI_NETLINK is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
# CONFIG_PCMCIA_QLOGIC is not set
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=y
# CONFIG_ISCSI_TARGET is not set
CONFIG_SBP_TARGET=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=m
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
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
CONFIG_KEYBOARD_QT2160=m
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_GPIO_POLLED=y
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=m
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=m
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=m
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=m
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=m
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=m
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
CONFIG_TOUCHSCREEN_DA9052=m
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
# CONFIG_TOUCHSCREEN_USB_E2I is not set
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_SUR40=y
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_TOUCHSCREEN_ZFORCE=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=m
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
CONFIG_INPUT_GPIO_TILT_POLLED=m
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_KXTJ9=m
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
CONFIG_INPUT_POWERMATE=m
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=m
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_DA9052_ONKEY=m
CONFIG_INPUT_DA9055_ONKEY=m
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_IMS_PCU=m
CONFIG_INPUT_CMA3000=m
# CONFIG_INPUT_CMA3000_I2C is not set
CONFIG_INPUT_IDEAPAD_SLIDEBAR=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
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
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_SC16IS7XX=y
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_SERIAL_MEN_Z135=m
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
# CONFIG_CARDMAN_4040 is not set
CONFIG_MWAVE=m
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
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
CONFIG_I2C_CBUS_GPIO=m
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=m
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_DA9052=m
CONFIG_GPIO_DA9055=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=m
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_WM8350=m
CONFIG_GPIO_WM8994=m
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

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

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=m
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX14577=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=m
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
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
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_DA9055_WATCHDOG=y
# CONFIG_WM8350_WATCHDOG is not set
# CONFIG_XILINX_WATCHDOG is not set
CONFIG_DW_WATCHDOG=y
CONFIG_RETU_WATCHDOG=m
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=m
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=m
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=m

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
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
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X is not set
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=m
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=m
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=m
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=m
CONFIG_REGULATOR_AB3100=m
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LTC3589=m
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8925=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77693=m
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_WM8350=y
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_DVB_CORE=m
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_SCALE_CROP=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_VIDEO_RCAR_VIN=m
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_MEM2MEM_TESTDEV=m

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_SMS_SIANO_MDTV=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

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

#
# soc_camera sensor drivers
#
# CONFIG_SOC_CAMERA_IMX074 is not set
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9M111=m
# CONFIG_SOC_CAMERA_MT9T031 is not set
CONFIG_SOC_CAMERA_MT9T112=m
# CONFIG_SOC_CAMERA_MT9V022 is not set
CONFIG_SOC_CAMERA_OV2640=m
# CONFIG_SOC_CAMERA_OV5642 is not set
# CONFIG_SOC_CAMERA_OV6650 is not set
CONFIG_SOC_CAMERA_OV772X=m
# CONFIG_SOC_CAMERA_OV9640 is not set
CONFIG_SOC_CAMERA_OV9740=m
CONFIG_SOC_CAMERA_RJ54N1=m
# CONFIG_SOC_CAMERA_TW9910 is not set

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

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
CONFIG_DRM=y
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
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
CONFIG_DRM_UDL=m
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
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=m
# CONFIG_FB_S1D13XXX is not set
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
CONFIG_FB_SMSCUFX=m
CONFIG_FB_UDL=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_DA9052=m
CONFIG_BACKLIGHT_MAX8925=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_ADP5520 is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_APPLEIR=m
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CP2112=m
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
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
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_OTG_FSM=m
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
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
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=m
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_ZTE is not set
CONFIG_USB_SERIAL_SSU100=m
# CONFIG_USB_SERIAL_QT2 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=y
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=m
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=m
CONFIG_SAMSUNG_USB2PHY=m
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_USB_GPIO_VBUS=m
CONFIG_USB_ISP1301=m
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=m
CONFIG_MMC_USDHI6ROL0=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=m
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM8350=m
CONFIG_LEDS_DA9052=m
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

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
CONFIG_DMATEST=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
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
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

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
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
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
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
# CONFIG_MMA8452 is not set

#
# Analog to digital converters
#
CONFIG_AD799X=m
CONFIG_MAX1363=m
CONFIG_MCP3422=m
CONFIG_MEN_Z188_ADC=y
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
CONFIG_MAX517=y
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
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_DHT11=m
CONFIG_SI7005=m

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=m
# CONFIG_APDS9300 is not set
CONFIG_CM32181=m
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
CONFIG_LTR501=m
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=m
# CONFIG_MAG3110 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_MPL115=m
CONFIG_MPL3115=y
# CONFIG_IIO_ST_PRESS is not set

#
# Lightning sensors
#

#
# Temperature sensors
#
CONFIG_MLX90614=y
CONFIG_TMP006=m
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=m
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_PHY_SAMSUNG_USB2=m
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
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
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_DEBUG=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set

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
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=y
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
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_VMACACHE=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_MEMORY_NOTIFIER_ERROR_INJECT is not set
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
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_KPROBE_EVENT is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_TRACEPOINT_BENCHMARK=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=m
CONFIG_TEST_LIST_SORT=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=m
CONFIG_TEST_STRING_HELPERS=m
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
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
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
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
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
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
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=m
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
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
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y

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
CONFIG_PERCPU_RWSEM=y
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
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=m
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_BCH=m
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=m
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--V2tfspbppmK1TQo2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--V2tfspbppmK1TQo2--
