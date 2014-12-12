Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935227AbaLLUdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:33:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:9636 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933118AbaLLUdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:33:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,566,1413270000"; 
   d="scan'208";a="653057899"
Date: Fri, 12 Dec 2014 12:33:32 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: [x86-32] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000880
Message-ID: <20141212203332.GA22077@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://github.com/fyu1/linux.git test

commit da12e1dc716f77937779215f74bfbfe42c5b3709
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Wed Dec 10 14:00:44 2014 -0800
Commit:     Fenghua Yu <fenghua.yu@intel.com>
CommitDate: Thu Dec 11 10:40:03 2014 -0800

    x86-32: Allocate pgd in paravirt for XEN
    
    In non-XEN or non-PAE case, still allocate 4KB pgd.
    
    For other cases
    
    Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

+------------------------------------------+------------+------------+------------+
|                                          | 92a578b064 | da12e1dc71 | 4263d929cf |
+------------------------------------------+------------+------------+------------+
| boot_successes                           | 63         | 0          | 0          |
| boot_failures                            | 2          | 20         | 12         |
| BUG:kernel_boot_hang                     | 1          |            |            |
| BUG:kernel_test_crashed                  | 1          |            |            |
| BUG:unable_to_handle_kernel              | 0          | 20         | 12         |
| Oops                                     | 0          | 20         | 12         |
| RIP:pgd_alloc                            | 0          | 20         | 12         |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 15         | 7          |
| backtrace:mm_init                        | 0          | 15         | 7          |
| backtrace:do_execve                      | 0          | 15         | 7          |
| backtrace:run_init_process               | 0          | 15         | 7          |
+------------------------------------------+------------+------------+------------+

[   42.296661] Write protecting the kernel read-only data: 28672k
[   42.382977] Freeing unused kernel memory: 700K (ffff880005951000 - ffff880005a00000)
[   42.563098] Freeing unused kernel memory: 988K (ffff880006109000 - ffff880006200000)
[   42.773320] BUG: unable to handle kernel NULL pointer dereference at 0000000000000880
[   42.774231] IP: [<ffffffff84644a52>] pgd_alloc+0x52/0x1f0
[   42.774231] PGD 0 
[   42.774231] Oops: 0002 [#1] PREEMPT 
[   42.774231] CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-gda12e1d #29
[   42.774231] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[   42.774231] task: ffff880012458000 ti: ffff880012460000 task.ti: ffff880012460000
[   42.774231] RIP: 0010:[<ffffffff84644a52>]  [<ffffffff84644a52>] pgd_alloc+0x52/0x1f0
[   42.774231] RSP: 0000:ffff880012463e78  EFLAGS: 00010293
[   42.774231] RAX: 000000000664e067 RBX: 0000000000000000 RCX: fffffffffffffff8
[   42.774231] RDX: 0000000080000000 RSI: ffffffff8620e880 RDI: 0000000000000888
[   42.774231] RBP: ffff880012463e88 R08: ffffffff85f50f13 R09: ffff880011ff2300
[   42.774231] R10: 0000000000000090 R11: 0000000000000000 R12: ffff880013348000
[   42.774231] R13: ffffffff862151c0 R14: ffffffff86215080 R15: 00000000132c5a00
[   42.774231] FS:  0000000000000000(0000) GS:ffffffff8621f000(0000) knlGS:0000000000000000
[   42.774231] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   42.774231] CR2: 0000000000000880 CR3: 000000000620e000 CR4: 00000000000006f0
[   42.774231] Stack:
[   42.774231]  ffff880013348000 ffff880012458000 ffff880012463ea8 ffffffff8469bff9
[   42.774231]  ffff880013351000 ffff8800132c5900 ffff880012463eb8 ffffffff8469c2cb
[   42.774231]  ffff880012463f28 ffffffff84762920 ffff880012463f08 ffffffff847654e9
[   42.774231] Call Trace:
[   42.774231]  [<ffffffff8469bff9>] mm_init+0x139/0x1b0
[   42.774231]  [<ffffffff8469c2cb>] mm_alloc+0x5b/0x70
[   42.774231]  [<ffffffff84762920>] do_execve+0x1e0/0x5f0
[   42.774231]  [<ffffffff847654e9>] ? getname_kernel+0x39/0x80
[   42.774231]  [<ffffffff8594e607>] ? bad_gs+0x265/0x81e
[   42.774231]  [<ffffffff85927fd0>] ? rest_init+0x80/0x80
[   42.774231]  [<ffffffff84602026>] run_init_process+0x26/0x30
[   42.774231]  [<ffffffff85928008>] kernel_init+0x38/0xf0
[   42.774231]  [<ffffffff8594c7ba>] ret_from_fork+0x7a/0xb0
[   42.774231]  [<ffffffff85927fd0>] ? rest_init+0x80/0x80
[   42.774231] Code: 79 07 00 48 8b 05 4f 9e bc 01 48 8d bb 88 08 00 00 48 8d 8b 80 08 00 00 48 c7 c6 80 e8 20 86 ba 00 00 00 80 48 83 e7 f8 48 29 f9 <48> 89 83 80 08 00 00 48 8b 05 98 a5 bc 01 48 29 ce 81 c1 80 07 
[   42.774231] RIP  [<ffffffff84644a52>] pgd_alloc+0x52/0x1f0
[   42.774231]  RSP <ffff880012463e78>
[   42.774231] CR2: 0000000000000880
[   42.774231] ---[ end trace 486b1714a42d9464 ]---
[   42.774231] Kernel panic - not syncing: Fatal exception

git bisect start 4263d929cffaef10489f2e8077a2a0d0fdff4701 b2776bf7149bddd1f4161f14f79520f17fc1d71d --
git bisect  bad b248a1a8129e68ec740e7d70af6b97ccfa0eea49  # 03:08      0-      1  Merge 'cgroup/tmp' into devel-lkp-nhm1-smoke-201412130236
git bisect good 2a54451092753dbe3f345ca624c0239af3ab4fe2  # 03:24     20+      0  Merge 'microblaze/xnext/fpga-v4' into devel-lkp-nhm1-smoke-201412130236
git bisect good 6464a271776a1650eda1b52a5b98f9fc40e497af  # 03:32     20+      0  Merge 'pm/master' into devel-lkp-nhm1-smoke-201412130236
git bisect  bad 33e2b62d1e5656f0ff104ea405191dcd2be9add1  # 03:36      0-      1  Merge 'fenghua/test' into devel-lkp-nhm1-smoke-201412130236
git bisect  bad 2b0da4faea14f23879f9ca704c11f763129a1283  # 03:43      0-      3  x86-32: Different pgd allocation for Xen Dom0 and DomU in PAE mode
git bisect  bad da12e1dc716f77937779215f74bfbfe42c5b3709  # 03:54      0-     20  x86-32: Allocate pgd in paravirt for XEN
# first bad commit: [da12e1dc716f77937779215f74bfbfe42c5b3709] x86-32: Allocate pgd in paravirt for XEN
git bisect good 92a578b064d0227a3a7fbbdb9e29dbab7f8d400e  # 03:59     60+      2  Merge tag 'pm+acpi-3.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
# extra tests on HEAD of linux-devel/devel-lkp-nhm1-smoke-201412130236
git bisect  bad 4263d929cffaef10489f2e8077a2a0d0fdff4701  # 03:59      0-     12  0day head guard for 'devel-lkp-nhm1-smoke-201412130236'
# extra tests on tree/branch fenghua/test
git bisect  bad 2b0da4faea14f23879f9ca704c11f763129a1283  # 03:59      0-     20  x86-32: Different pgd allocation for Xen Dom0 and DomU in PAE mode
# extra tests on tree/branch linus/master
git bisect good 6ce4436c9cbe903af935291aa219fd6f4c85722d  # 04:08     60+      0  Merge tag 'please-pull-morepstore' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux
# extra tests on tree/branch next/master
git bisect good f4aec88d2134e8ace530be28db614e383961b9c8  # 04:13     60+      0  Add linux-next specific files for 20141212


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

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-client8-16:20141213035415:x86_64-randconfig-n0-12082301:3.18.0-gda12e1d:29"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-gda12e1d (kbuild@lkp-nhm1) (gcc version=
 4.9.1 (Debian 4.9.1-19) ) #29 PREEMPT Sat Dec 13 03:50:35 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12082301/linux-devel:devel-lkp-nhm1-smoke-201412130236:da12e1dc716f=
77937779215f74bfbfe42c5b3709:bisect-linux-8/.vmlinuz-da12e1dc716f7793777921=
5f74bfbfe42c5b3709-20141213035115-14-client8 branch=3Dlinux-devel/devel-lkp=
-nhm1-smoke-201412130236 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12082301=
/da12e1dc716f77937779215f74bfbfe42c5b3709/vmlinuz-3.18.0-gda12e1d drbd.mino=
r_count=3D8
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
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
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
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC =20
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0664e000, 0x0664efff] PGTABLE
[    0.000000] BRK [0x0664f000, 0x0664ffff] PGTABLE
[    0.000000] BRK [0x06650000, 0x06650fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x06651000, 0x06651fff] PGTABLE
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
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 62324c0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12082301/linux-devel:devel-lkp-nhm1-smoke-201412130236:da12e=
1dc716f77937779215f74bfbfe42c5b3709:bisect-linux-8/.vmlinuz-da12e1dc716f779=
37779215f74bfbfe42c5b3709-20141213035115-14-client8 branch=3Dlinux-devel/de=
vel-lkp-nhm1-smoke-201412130236 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-1=
2082301/da12e1dc716f77937779215f74bfbfe42c5b3709/vmlinuz-3.18.0-gda12e1d dr=
bd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 263736K/327160K available (19771K kernel code, 1892K=
 rwdata, 7204K rodata, 1264K init, 1240K bss, 63424K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:48 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-gda12e1d (kbuild@lkp-nhm1) (gcc version=
 4.9.1 (Debian 4.9.1-19) ) #29 PREEMPT Sat Dec 13 03:50:35 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12082301/linux-devel:devel-lkp-nhm1-smoke-201412130236:da12e1dc716f=
77937779215f74bfbfe42c5b3709:bisect-linux-8/.vmlinuz-da12e1dc716f7793777921=
5f74bfbfe42c5b3709-20141213035115-14-client8 branch=3Dlinux-devel/devel-lkp=
-nhm1-smoke-201412130236 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12082301=
/da12e1dc716f77937779215f74bfbfe42c5b3709/vmlinuz-3.18.0-gda12e1d drbd.mino=
r_count=3D8
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
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
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
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC =20
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0664e000, 0x0664efff] PGTABLE
[    0.000000] BRK [0x0664f000, 0x0664ffff] PGTABLE
[    0.000000] BRK [0x06650000, 0x06650fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x06651000, 0x06651fff] PGTABLE
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
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 62324c0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12082301/linux-devel:devel-lkp-nhm1-smoke-201412130236:da12e=
1dc716f77937779215f74bfbfe42c5b3709:bisect-linux-8/.vmlinuz-da12e1dc716f779=
37779215f74bfbfe42c5b3709-20141213035115-14-client8 branch=3Dlinux-devel/de=
vel-lkp-nhm1-smoke-201412130236 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-1=
2082301/da12e1dc716f77937779215f74bfbfe42c5b3709/vmlinuz-3.18.0-gda12e1d dr=
bd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 263736K/327160K available (19771K kernel code, 1892K=
 rwdata, 7204K rodata, 1264K init, 1240K bss, 63424K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:48 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2925.998 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5851.99 Bogo=
MIPS (lpj=3D2925998)
[    0.003454] pid_max: default: 32768 minimum: 301
[    0.004008] ACPI: Core revision 20141107
[    0.006013] ACPI: All ACPI Tables successfully acquired
[    0.006929] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.007004] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.008108] Initializing cgroup subsys net_cls
[    0.009005] Initializing cgroup subsys blkio
[    0.010004] Initializing cgroup subsys net_prio
[    0.010657] Initializing cgroup subsys debug
[    0.011051] mce: CPU supports 10 MCE banks
[    0.012038] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012038] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.013002] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.029320] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.030782] Getting VERSION: 1050014
[    0.031007] Getting VERSION: 1050014
[    0.032006] Getting ID: 0
[    0.032559] Getting ID: ff000000
[    0.033015] Getting LVT0: 8700
[    0.033668] Getting LVT1: 8400
[    0.034058] enabled ExtINT on CPU#0
[    0.036281] ENABLING IO-APIC IRQs
[    0.036975] init IO_APIC IRQs
[    0.037003]  apic 0 pin 0 not connected
[    0.038006] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.039019] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.040019] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.041018] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.042018] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.043018] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.044018] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.045018] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.046023] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.047021] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.048021] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.049020] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.050020] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.051020] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.052020] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.053020] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.054018]  apic 0 pin 16 not connected
[    0.055002]  apic 0 pin 17 not connected
[    0.056002]  apic 0 pin 18 not connected
[    0.057002]  apic 0 pin 19 not connected
[    0.058002]  apic 0 pin 20 not connected
[    0.058875]  apic 0 pin 21 not connected
[    0.059000]  apic 0 pin 22 not connected
[    0.059000]  apic 0 pin 23 not connected
[    0.059149] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.060002] Using local APIC timer interrupts.
[    0.060002] calibrating APIC timer ...
[    0.062000] ... lapic delta =3D 6314366
[    0.062000] ... PM-Timer delta =3D 361663
[    0.062000] APIC calibration not consistent with PM-Timer: 101ms instead=
 of 100ms
[    0.062000] APIC delta adjusted to PM-Timer: 6249609 (6314366)
[    0.062000] TSC delta adjusted to PM-Timer: 292594320 (295626085)
[    0.062000] ..... delta 6249609
[    0.062000] ..... mult: 268418662
[    0.062000] ..... calibration result: 999937
[    0.062000] ..... CPU clock speed is 2925.0943 MHz.
[    0.062000] ..... host bus clock speed is 999.0937 MHz.
[    0.062934] xor: measuring software checksum speed
[    0.073004]    prefetch64-sse: 12160.000 MB/sec
[    0.083004]    generic_sse: 10764.000 MB/sec
[    0.083955] xor: using function: prefetch64-sse (12160.000 MB/sec)
[    0.084197] NET: Registered protocol family 16
[    0.088011] cpuidle: using governor ladder
[    0.091012] cpuidle: using governor menu
[    0.092151] ACPI: bus type PCI registered
[    0.093093] PCI: Using configuration type 1 for base access
[    0.120029] raid6: sse2x1    5179 MB/s
[    0.138012] raid6: sse2x2    8375 MB/s
[    0.155010] raid6: sse2x4    9960 MB/s
[    0.155676] raid6: using algorithm sse2x4 (9960 MB/s)
[    0.156002] raid6: using intx1 recovery algorithm
[    0.157079] ACPI: Added _OSI(Module Device)
[    0.157750] ACPI: Added _OSI(Processor Device)
[    0.158002] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.159002] ACPI: Added _OSI(Processor Aggregator Device)
[    0.161195] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.163076] ACPI: Interpreter enabled
[    0.163990] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20141107/hwxface-580)
[    0.165467] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20141107/hwxface-580)
[    0.167021] ACPI: (supports S0 S3 S5)
[    0.167662] ACPI: Using IOAPIC for interrupt routing
[    0.168038] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.171428] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.172014] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.173014] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.174091] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.175055] PCI host bridge to bus 0000:00
[    0.176005] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.177004] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.178004] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.179005] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.180004] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.181004] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.182003] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.183003] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.184042] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.185341] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.187205] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.191004] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.193031] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.194003] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.195003] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.196003] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.197197] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.198359] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.199014] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.200190] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.202007] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.204007] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.210007] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.211147] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.213391] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.215377] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.221527] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.222226] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.223571] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.228409] pci_bus 0000:00: on NUMA node 0
[    0.230080] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.232077] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.234082] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.236074] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.237914] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.239629] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.240259] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.241000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.241002] vgaarb: loaded
[    0.241503] vgaarb: bridge control possible 0000:00:02.0
[    0.242192] SCSI subsystem initialized
[    0.243013] libata version 3.00 loaded.
[    0.243694] Linux video capture interface: v2.00
[    0.244015] pps_core: LinuxPPS API ver. 1 registered
[    0.245001] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.246011] PTP clock support registered
[    0.247037] wmi: Mapper loaded
[    0.248035] Advanced Linux Sound Architecture Driver Initialized.
[    0.249004] PCI: Using ACPI for IRQ routing
[    0.249694] PCI: pci_cache_line_size set to 64 bytes
[    0.250080] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.251002] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.252089] NET: Registered protocol family 8
[    0.253002] NET: Registered protocol family 20
[    0.254011] nfc: nfc_init: NFC Core ver 0.1
[    0.254709] NET: Registered protocol family 39
[    0.255358] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.256495] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.260013] Switched to clocksource kvm-clock
[    0.261150] FS-Cache: Loaded
[    0.261916] CacheFiles: Loaded
[    0.262869] pnp: PnP ACPI init
[    0.263708] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.268846] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.270403] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.272345] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.273927] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.275724] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.277107] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.278848] pnp 00:03: [dma 2]
[    0.279734] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.281335] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.283164] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.284566] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.286314] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.287992] pnp: PnP ACPI: found 6 devices
[    0.294948] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.296320] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.297721] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.299012] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.300414] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.301764] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.303246] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.304842] NET: Registered protocol family 2
[    0.306187] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    0.307765] TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
[    0.309301] TCP: Hash tables configured (established 4096 bind 4096)
[    0.310773] TCP: reno registered
[    0.311653] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.312896] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.314202] NET: Registered protocol family 1
[    0.315245] RPC: Registered named UNIX socket transport module.
[    0.316555] RPC: Registered udp transport module.
[    0.317596] RPC: Registered tcp transport module.
[    0.318738] RPC: Registered tcp NFSv4.1 backchannel transport module
--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--xHFwDpU9dbj6ez1V--
