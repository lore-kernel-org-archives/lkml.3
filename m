Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaF2O5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 10:57:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:52746 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaF2O5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 10:57:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,570,1400050800"; 
   d="log'?scan'208";a="554909693"
Date: Sun, 29 Jun 2014 22:56:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [crypto] kernel BUG at kernel/cred.c:790
Message-ID: <20140629145626.GB9134@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <20140629145246.GA9134@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stephan,

This is another error message for the same commit.

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
commit 64d1cdfbe20c50877576045145313c9b062c50f7
Author:     Stephan Mueller <smueller@chronox.de>
AuthorDate: Sat May 31 17:25:36 2014 +0200
Commit:     Herbert Xu <herbert@gondor.apana.org.au>
CommitDate: Fri Jun 20 21:26:10 2014 +0800

    crypto: drbg - Add DRBG test code to testmgr
    
    The DRBG test code implements the CAVS test approach.
    
    As discussed for the test vectors, all DRBG types are covered with
    testing. However, not every backend cipher is covered with testing. To
    prevent the testmgr from logging missing testing, the NULL test is
    registered for all backend ciphers not covered with specific test cases.
    
    All currently implemented DRBG types and backend ciphers are defined
    in SP800-90A. Therefore, the fips_allowed flag is set for all.
    
    Signed-off-by: Stephan Mueller <smueller@chronox.de>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+------------------------------------------+------------+------------+------------------+
|                                          | 3332ee2a17 | 64d1cdfbe2 | v3.16-rc2_062623 |
+------------------------------------------+------------+------------+------------------+
| boot_successes                           | 83         | 0          | 0                |
| boot_failures                            | 1          | 19         | 13               |
| general_protection_fault                 | 1          |            |                  |
| RIP:__lock_acquire                       | 1          |            |                  |
| Kernel_panic-not_syncing:Fatal_exception | 1          | 19         | 13               |
| backtrace:free_reserved_area             | 1          |            |                  |
| backtrace:free_init_pages                | 1          |            |                  |
| backtrace:populate_rootfs                | 1          |            |                  |
| backtrace:kernel_init_freeable           | 1          |            |                  |
| kernel_BUG_at_kernel/cred.c              | 0          | 19         | 13               |
| invalid_opcode                           | 0          | 19         | 13               |
| RIP:__validate_process_creds             | 0          | 19         | 13               |
| backtrace:cryptomgr_test                 | 0          | 19         | 13               |
+------------------------------------------+------------+------------+------------------+

[    1.091931] CRED: ->*gid = { 0,0,0,0 }
[    1.092559] CRED: Effective creds == Real creds
[    1.093464] ------------[ cut here ]------------
[    1.094334] kernel BUG at kernel/cred.c:790!
[    1.095457] invalid opcode: 0000 [#1] 
[    1.096230] Modules linked in:
[    1.096896] CPU: 0 PID: 77 Comm: cryptomgr_test Not tainted 3.16.0-rc1-00011-g64d1cdf #1
[    1.098434] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    1.099976] task: ffff880011c14000 ti: ffff880011c18000 task.ti: ffff880011c18000
[    1.100619] RIP: 0010:[<ffffffff82e99f14>]  [<ffffffff82e99f14>] __validate_process_creds+0xa9/0xc6
[    1.100619] RSP: 0000:ffff880011c1bd90  EFLAGS: 00010296
[    1.100619] RAX: 0000000000000023 RBX: ffff880011c14000 RCX: ffff880011c147c0
[    1.100619] RDX: 00000000000001c4 RSI: 0000000000000001 RDI: 0000000000000246
[    1.100619] RBP: ffff880011c1bda8 R08: 0000000000000000 R09: 0000000000000000
[    1.100619] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    1.100619] R13: ffffffff830745ed R14: 0000000000000000 R15: 0000000000000000
[    1.100619] FS:  0000000000000000(0000) GS:ffffffff83540000(0000) knlGS:0000000000000000
[    1.100619] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.100619] CR2: 0000000000000000 CR3: 0000000003530000 CR4: 00000000000006f0
[    1.100619] Stack:
[    1.100619]  00000324133a3eb0 ffffffff83479888 ffff880011c14000 ffff880011c1bdb8
[    1.100619]  ffffffff82e9a808 ffff880011c1be30 ffffffff82e7e186 ffff880011c1bde8
[    1.100619]  0000000000000286 ffff8800123fa000 ffff8800123fa08c 0000000011c1be30
[    1.100619] Call Trace:
[    1.100619]  [<ffffffff82e9a808>] validate_creds_for_do_exit+0x21/0x23
[    1.100619]  [<ffffffff82e7e186>] do_exit+0xd4/0x927
[    1.100619]  [<ffffffff82f1a2de>] ? slob_free+0x264/0x271
[    1.100619]  [<ffffffff830745ed>] ? cryptomgr_notify+0x365/0x365
[    1.100619]  [<ffffffff82ec5f6b>] __module_put_and_exit+0x15/0x15
[    1.100619]  [<ffffffff8307462b>] cryptomgr_test+0x3e/0x3e
[    1.100619]  [<ffffffff82e964d4>] kthread+0xfe/0x106
[    1.100619]  [<ffffffff82e963d6>] ? kthread_create_on_node+0x1b4/0x1b4
[    1.100619]  [<ffffffff8328f8fa>] ret_from_fork+0x7a/0xb0
[    1.100619]  [<ffffffff82e963d6>] ? kthread_create_on_node+0x1b4/0x1b4
[    1.100619] Code: 05 00 00 48 3b bb 58 05 00 00 74 11 48 89 da 48 c7 c6 0d 9a 47 83 e8 0d fe ff ff eb 0e 48 c7 c7 17 9a 47 83 31 c0 e8 3e e0 3e 00 <0f> 0b 81 79 10 64 65 73 43 75 86 81 78 10 64 65 73 43 0f 85 79 
[    1.100619] RIP  [<ffffffff82e99f14>] __validate_process_creds+0xa9/0xc6
[    1.100619]  RSP <ffff880011c1bd90>
[    1.139825] ---[ end trace 48832184cdccd42e ]---
[    1.140545] Kernel panic - not syncing: Fatal exception

git bisect start 5dd35a09586ffd4c6bbc1dd80419e14f84aa5ca2 a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee --
git bisect good c25ee141bdf80b619b5610c3da1b1e0c7b7b130f  # 10:41     20+      0  Merge 'nfs/linux-next' into devel-hourly-2014062623
git bisect  bad a10d4e58c9d60e8c1db45dbdf15b6e8451e6a5e9  # 10:44      2-     20  Merge 'ipsec/testing' into devel-hourly-2014062623
git bisect good 1aaccd3e6a7639a4ac0acf3db3308291970b794b  # 11:04     21+      1  Merge 'efi/next' into devel-hourly-2014062623
git bisect  bad 71db7e0dd17d7fda5c16f75c7c88f20f355ba8c3  # 11:08      1-     14  Merge 'kvm-ppc/kvm-ppc-queue' into devel-hourly-2014062623
git bisect  bad 9f9409740f318417a40e004f5378163d241adf43  # 11:19      2-     21  Merge 'cryptodev/master' into devel-hourly-2014062623
git bisect  bad b3416fb8a2f5a1653e4ab72b55907794cc10bde1  # 11:26      1-     20  crypto: qat - Intel(R) QAT accelengine part of fw loader
git bisect good 3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24  # 11:35     21+      1  crypto: drbg - DRBG testmgr test vectors
git bisect  bad d8cba25d2c68992a6e7c1d329b690a9ebe01167d  # 11:39      1-      4  crypto: qat - Intel(R) QAT driver framework
git bisect  bad 3d77565ba5e5b9075a4f6d7d6d15996f5e582659  # 11:42      0-     21  crypto: ccp - Modify PCI support in prep for arm64 support
git bisect  bad 64d1cdfbe20c50877576045145313c9b062c50f7  # 11:48      0-      5  crypto: drbg - Add DRBG test code to testmgr
# first bad commit: [64d1cdfbe20c50877576045145313c9b062c50f7] crypto: drbg - Add DRBG test code to testmgr
git bisect good 3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24  # 11:51     63+      1  crypto: drbg - DRBG testmgr test vectors
git bisect  bad 5dd35a09586ffd4c6bbc1dd80419e14f84aa5ca2  # 11:51      0-     13  0day head guard for 'devel-hourly-2014062623'
git bisect good 24b414d5a7d3e6a716350464dfdb44da610ed142  # 12:13     63+      2  Merge tag 'spi-v3.16-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi
git bisect  bad 96426007c90cde23c0402856f3e0aec0f4cc2e48  # 12:19      0-      1  Add linux-next specific files for 20140627


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm 
	-kernel $kernel
	-initrd $initrd
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

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-wsx01-76:20140629114723:x86_64-randconfig-s1-06271225::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc1-00011-g64d1cdf (kbuild@snb) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-18) ) #1 Sun Jun 29 11:46:47 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-06271225/linux-devel:=
devel-hourly-2014062623:64d1cdfbe20c50877576045145313c9b062c50f7:bisect-lin=
ux0/.vmlinuz-64d1cdfbe20c50877576045145313c9b062c50f7-20140629114712-20-lkp=
-wsx01 branch=3Dlinux-devel/devel-hourly-2014062623 BOOT_IMAGE=3D/kernel/x8=
6_64-randconfig-s1-06271225/64d1cdfbe20c50877576045145313c9b062c50f7/vmlinu=
z-3.16.0-rc1-00011-g64d1cdf drbd.minor_count=3D8
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
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
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
[    0.000000] BRK [0x043dc000, 0x043dcfff] PGTABLE
[    0.000000] BRK [0x043dd000, 0x043ddfff] PGTABLE
[    0.000000] BRK [0x043de000, 0x043defff] PGTABLE
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
[    0.000000] BRK [0x043df000, 0x043dffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
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
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
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
[    0.000000] kvm-stealtime: cpu 0, msr 3550e40
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
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-06271225/linux=
-devel:devel-hourly-2014062623:64d1cdfbe20c50877576045145313c9b062c50f7:bis=
ect-linux0/.vmlinuz-64d1cdfbe20c50877576045145313c9b062c50f7-20140629114712=
-20-lkp-wsx01 branch=3Dlinux-devel/devel-hourly-2014062623 BOOT_IMAGE=3D/ke=
rnel/x86_64-randconfig-s1-06271225/64d1cdfbe20c50877576045145313c9b062c50f7=
/vmlinuz-3.16.0-rc1-00011-g64d1cdf drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 294884K/327280K available (4678K kernel code, 641K r=
wdata, 2592K rodata, 688K init, 13768K bss, 32396K reserved)
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
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
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
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2393.998 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 4787.99 Bogo=
MIPS (lpj=3D23939980)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.020000] ACPI: All ACPI Tables successfully acquired
[    0.020000] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.020000] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.020952] Initializing cgroup subsys freezer
[    0.021556] Initializing cgroup subsys net_cls
[    0.022110] Initializing cgroup subsys perf_event
[    0.022733] Initializing cgroup subsys debug
[    0.023364] mce: CPU supports 10 MCE banks
[    0.023924] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023924] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.023924] tlb_flushall_shift: 6
[    0.025710] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.030773] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.032524] Getting VERSION: 1050014
[    0.033002] Getting VERSION: 1050014
[    0.033417] Getting ID: 0
[    0.033758] Getting ID: ff000000
[    0.034189] Getting LVT0: 8700
[    0.034546] Getting LVT1: 8400
[    0.034999] enabled ExtINT on CPU#0
[    0.036448] ENABLING IO-APIC IRQs
[    0.036864] init IO_APIC IRQs
[    0.037247]  apic 0 pin 0 not connected
[    0.037705] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.038672] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.039625] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.040048] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.041025] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.041982] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.042942] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.043900] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.044858] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.045863] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.046857] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.047824] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.048804] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.050027] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.050995] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.051964]  apic 0 pin 16 not connected
[    0.052431]  apic 0 pin 17 not connected
[    0.052904]  apic 0 pin 18 not connected
[    0.053368]  apic 0 pin 19 not connected
[    0.053846]  apic 0 pin 20 not connected
[    0.054291]  apic 0 pin 21 not connected
[    0.054800]  apic 0 pin 22 not connected
[    0.055321]  apic 0 pin 23 not connected
[    0.055959] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.056833] Using local APIC timer interrupts.
[    0.056833] calibrating APIC timer ...
[    0.060000] ... lapic delta =3D 6250093
[    0.060000] ... PM-Timer delta =3D 358012
[    0.060000] ... PM-Timer result ok
[    0.060000] ..... delta 6250093
[    0.060000] ..... mult: 268439450
[    0.060000] ..... calibration result: 10000148
[    0.060000] ..... CPU clock speed is 2394.4699 MHz.
[    0.060000] ..... host bus clock speed is 1000.0148 MHz.
[    0.060000] devtmpfs: initialized
[    0.060000] xor: measuring software checksum speed
[    0.150007]    prefetch64-sse:  9886.400 MB/sec
[    0.250005]    generic_sse:  8698.400 MB/sec
[    0.250713] xor: using function: prefetch64-sse (9886.400 MB/sec)
[    0.251650] prandom: seed boundary self test passed
[    0.253050] prandom: 100 self tests passed
[    0.254418] regulator-dummy: no parameters
[    0.255367] NET: Registered protocol family 16
[    0.256490] cpuidle: using governor ladder
[    0.257092] cpuidle: using governor menu
[    0.257929] ACPI: bus type PCI registered
[    0.258640] PCI: Using configuration type 1 for base access
[    0.430011] raid6: sse2x1    5054 MB/s
[    0.600007] raid6: sse2x2    5777 MB/s
[    0.770008] raid6: sse2x4    7183 MB/s
[    0.770721] raid6: using algorithm sse2x4 (7183 MB/s)
[    0.771482] raid6: using intx1 recovery algorithm
[    0.772394] ACPI: Added _OSI(Module Device)
[    0.773119] ACPI: Added _OSI(Processor Device)
[    0.773834] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.774608] ACPI: Added _OSI(Processor Aggregator Device)
[    0.785189] ACPI: Interpreter enabled
[    0.785810] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140424/hwxface-580)
[    0.787624] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140424/hwxface-580)
[    0.789182] ACPI: (supports S0 S3 S5)
[    0.789784] ACPI: Using IOAPIC for interrupt routing
[    0.790066] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.806657] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.807669] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.808678] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.810467] PCI host bridge to bus 0000:00
[    0.811192] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.812023] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.812867] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.813805] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.814839] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.815799] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.816837] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.817901] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.819041] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.820899] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.822817] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.826920] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.829698] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.830010] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.831071] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.832074] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.833355] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.834953] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.836469] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.840032] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.842850] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.845591] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.853639] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.855531] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.857897] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.860619] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.867683] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.869497] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.870677] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.876597] pci_bus 0000:00: on NUMA node 0
[    0.878970] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.880817] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.882467] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.884101] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.885469] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.888066] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.890479] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.892081] vgaarb: loaded
[    0.892650] vgaarb: bridge control possible 0000:00:02.0
[    0.893660] ACPI: bus type USB registered
[    0.894571] usbcore: registered new interface driver usbfs
[    0.895666] usbcore: registered new interface driver hub
[    0.896769] usbcore: registered new device driver usb
[    0.897944] EDAC MC: Ver: 3.0.0
[    0.898865] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.900309] PCI: Using ACPI for IRQ routing
[    0.901117] PCI: pci_cache_line_size set to 64 bytes
[    0.902163] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.903319] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.905719] Switched to clocksource kvm-clock
[    0.907072] FS-Cache: Loaded
[    0.907709] pnp: PnP ACPI init
[    0.908355] ACPI: bus type PNP registered
[    0.909187] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.909187] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.909187] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.909187] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.909389] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.910968] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.912276] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.913817] pnp 00:03: [dma 2]
[    0.914531] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.915840] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.917553] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.918853] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.920443] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.922479] pnp: PnP ACPI: found 6 devices
[    0.923220] ACPI: bus type PNP unregistered
[    0.930099] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.931133] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.932159] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.933334] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.934586] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.935626] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.936854] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.938059] NET: Registered protocol family 1
[    0.938898] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.939990] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.941085] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.942246] pci 0000:00:02.0: Boot video device
[    0.943125] PCI: CLS 0 bytes, default 64
[    0.944218] Unpacking initramfs...
[    1.041572] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013f=
f0000)
[    1.043702] Machine check injector initialized
[    1.044859] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.047183] cryptomgr_test (17) used greatest stack depth: 14648 bytes l=
eft
[    1.049619] kworker/u2:0 (26) used greatest stack depth: 14360 bytes left
[    1.051446] cryptomgr_test (23) used greatest stack depth: 13632 bytes l=
eft
[    1.052736] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    1.053778] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.054789] AVX or AES-NI instructions are not detected.
[    1.055599] AVX instructions are not detected.
[    1.056194] AVX instructions are not detected.
[    1.056886] AVX instructions are not detected.
[    1.057567] AVX2 or AES-NI instructions are not detected.
[    1.058335] AVX2 instructions are not detected.
[    1.059624] futex hash table entries: 256 (order: 2, 20480 bytes)
[    1.060568] Initialise system trusted keyring
[    1.061317] audit: initializing netlink subsys (disabled)
[    1.062190] audit: type=3D2000 audit(1404013637.344:1): initialized
[    1.063175] Kprobe smoke test started
[    1.070928] Kprobe smoke test passed successfully
[    1.072195] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.073214] zbud: loaded
[    1.073790] VFS: Disk quotas dquot_6.5.2
[    1.074430] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.075796] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.076579] QNX6 filesystem 1.0.0 registered.
[    1.077349] fuse init (API version 7.23)
[    1.078514] gfs2: GFS2 installed
[    1.082544] alg: No test for lz4 (lz4-generic)
[    1.083224] alg: No test for stdrng (krng)
[    1.084925] cryptomgr_test (67) used greatest stack depth: 13432 bytes l=
eft
[    1.086741] CRED: Invalid process credentials
[    1.087421] CRED: At kernel/cred.c:804
[    1.088477] CRED: Real credentials: ffff8800123fa380 [real][eff]
[    1.089642] CRED: ->magic=3D43736564, put_addr=3D          (null)
[    1.090630] CRED: ->usage=3D1007424747, subscr=3D-2105608935
[    1.091403] CRED: ->*uid =3D { 0,0,0,0 }
[    1.091931] CRED: ->*gid =3D { 0,0,0,0 }
[    1.092559] CRED: Effective creds =3D=3D Real creds
[    1.093464] ------------[ cut here ]------------
[    1.094334] kernel BUG at kernel/cred.c:790!
[    1.095457] invalid opcode: 0000 [#1]=20
[    1.096230] Modules linked in:
[    1.096896] CPU: 0 PID: 77 Comm: cryptomgr_test Not tainted 3.16.0-rc1-0=
0011-g64d1cdf #1
[    1.098434] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[    1.099976] task: ffff880011c14000 ti: ffff880011c18000 task.ti: ffff880=
011c18000
[    1.100619] RIP: 0010:[<ffffffff82e99f14>]  [<ffffffff82e99f14>] __valid=
ate_process_creds+0xa9/0xc6
[    1.100619] RSP: 0000:ffff880011c1bd90  EFLAGS: 00010296
[    1.100619] RAX: 0000000000000023 RBX: ffff880011c14000 RCX: ffff880011c=
147c0
[    1.100619] RDX: 00000000000001c4 RSI: 0000000000000001 RDI: 00000000000=
00246
[    1.100619] RBP: ffff880011c1bda8 R08: 0000000000000000 R09: 00000000000=
00000
[    1.100619] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000
[    1.100619] R13: ffffffff830745ed R14: 0000000000000000 R15: 00000000000=
00000
[    1.100619] FS:  0000000000000000(0000) GS:ffffffff83540000(0000) knlGS:=
0000000000000000
[    1.100619] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.100619] CR2: 0000000000000000 CR3: 0000000003530000 CR4: 00000000000=
006f0
[    1.100619] Stack:
[    1.100619]  00000324133a3eb0 ffffffff83479888 ffff880011c14000 ffff8800=
11c1bdb8
[    1.100619]  ffffffff82e9a808 ffff880011c1be30 ffffffff82e7e186 ffff8800=
11c1bde8
[    1.100619]  0000000000000286 ffff8800123fa000 ffff8800123fa08c 00000000=
11c1be30
[    1.100619] Call Trace:
[    1.100619]  [<ffffffff82e9a808>] validate_creds_for_do_exit+0x21/0x23
[    1.100619]  [<ffffffff82e7e186>] do_exit+0xd4/0x927
[    1.100619]  [<ffffffff82f1a2de>] ? slob_free+0x264/0x271
[    1.100619]  [<ffffffff830745ed>] ? cryptomgr_notify+0x365/0x365
[    1.100619]  [<ffffffff82ec5f6b>] __module_put_and_exit+0x15/0x15
[    1.100619]  [<ffffffff8307462b>] cryptomgr_test+0x3e/0x3e
[    1.100619]  [<ffffffff82e964d4>] kthread+0xfe/0x106
[    1.100619]  [<ffffffff82e963d6>] ? kthread_create_on_node+0x1b4/0x1b4
[    1.100619]  [<ffffffff8328f8fa>] ret_from_fork+0x7a/0xb0
[    1.100619]  [<ffffffff82e963d6>] ? kthread_create_on_node+0x1b4/0x1b4
[    1.100619] Code: 05 00 00 48 3b bb 58 05 00 00 74 11 48 89 da 48 c7 c6 =
0d 9a 47 83 e8 0d fe ff ff eb 0e 48 c7 c7 17 9a 47 83 31 c0 e8 3e e0 3e 00 =
<0f> 0b 81 79 10 64 65 73 43 75 86 81 78 10 64 65 73 43 0f 85 79=20
[    1.100619] RIP  [<ffffffff82e99f14>] __validate_process_creds+0xa9/0xc6
[    1.100619]  RSP <ffff880011c1bd90>
[    1.139825] ---[ end trace 48832184cdccd42e ]---
[    1.140545] Kernel panic - not syncing: Fatal exception
[    1.141238] Kernel Offset: 0x1e00000 from 0xffffffff81000000 (relocation=
 range: 0xffffffff80000000-0xffffffffbfffffff)
[    1.143390] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s1-06271225/64d1cdfbe20c50877576045145313c9b062c50f7/vmlinuz-3.16.0-rc1-00=
011-g64d1cdf -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pani=
c=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 consol=
e=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/k=
build-tests/run-queue/kvm/x86_64-randconfig-s1-06271225/linux-devel:devel-h=
ourly-2014062623:64d1cdfbe20c50877576045145313c9b062c50f7:bisect-linux0/.vm=
linuz-64d1cdfbe20c50877576045145313c9b062c50f7-20140629114712-20-lkp-wsx01 =
branch=3Dlinux-devel/devel-hourly-2014062623 BOOT_IMAGE=3D/kernel/x86_64-ra=
ndconfig-s1-06271225/64d1cdfbe20c50877576045145313c9b062c50f7/vmlinuz-3.16.=
0-rc1-00011-g64d1cdf drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/yo=
cto-minimal-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net u=
ser,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dloc=
altime -pidfile /dev/shm/kboot/pid-yocto-lkp-wsx01-76 -serial file:/dev/shm=
/kboot/serial-yocto-lkp-wsx01-76 -daemonize -display none -monitor null=20

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-lkp-wsx02-199:20140629112912:x86_64-randconfig-s1-06271225::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc1-00010-g3332ee2 (kbuild@snb) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-18) ) #1 Sun Jun 29 11:28:26 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-06271225/linux-devel:=
devel-hourly-2014062623:3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24:bisect-lin=
ux0/.vmlinuz-3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24-20140629112851-21-lkp=
-wsx02 branch=3Dlinux-devel/devel-hourly-2014062623 BOOT_IMAGE=3D/kernel/x8=
6_64-randconfig-s1-06271225/3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24/vmlinu=
z-3.16.0-rc1-00010-g3332ee2 drbd.minor_count=3D8
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
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
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
[    0.000000] BRK [0x12fdb000, 0x12fdbfff] PGTABLE
[    0.000000] BRK [0x12fdc000, 0x12fdcfff] PGTABLE
[    0.000000] BRK [0x12fdd000, 0x12fddfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11800000-0x119fffff]
[    0.000000]  [mem 0x11800000-0x119fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x117fffff]
[    0.000000]  [mem 0x10000000-0x117fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x11a00000-0x13ffdfff]
[    0.000000]  [mem 0x11a00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
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
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
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
[    0.000000] kvm-stealtime: cpu 0, msr 12150e40
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
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-06271225/linux=
-devel:devel-hourly-2014062623:3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24:bis=
ect-linux0/.vmlinuz-3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24-20140629112851=
-21-lkp-wsx02 branch=3Dlinux-devel/devel-hourly-2014062623 BOOT_IMAGE=3D/ke=
rnel/x86_64-randconfig-s1-06271225/3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24=
/vmlinuz-3.16.0-rc1-00010-g3332ee2 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 281552K/327280K available (4677K kernel code, 647K r=
wdata, 2584K rodata, 688K init, 13768K bss, 45728K reserved)
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
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
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
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2393.996 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 4787.99 Bogo=
MIPS (lpj=3D23939960)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.022269] ACPI: All ACPI Tables successfully acquired
[    0.023383] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.024626] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.027028] Initializing cgroup subsys freezer
[    0.027837] Initializing cgroup subsys net_cls
[    0.028637] Initializing cgroup subsys perf_event
[    0.029414] Initializing cgroup subsys debug
[    0.030189] mce: CPU supports 10 MCE banks
[    0.030949] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030949] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.030949] tlb_flushall_shift: 6
[    0.033308] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.039261] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.041957] Getting VERSION: 1050014
[    0.042594] Getting VERSION: 1050014
[    0.043198] Getting ID: 0
[    0.043678] Getting ID: ff000000
[    0.044226] Getting LVT0: 8700
[    0.044762] Getting LVT1: 8400
[    0.045363] enabled ExtINT on CPU#0
[    0.047549] ENABLING IO-APIC IRQs
[    0.048128] init IO_APIC IRQs
[    0.048642]  apic 0 pin 0 not connected
[    0.049316] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.050060] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.051402] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.052773] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.060037] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.061369] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.070035] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.071343] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.072682] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.073991] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.075337] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.076711] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.078059] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.079419] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.080043] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.081385]  apic 0 pin 16 not connected
[    0.090019]  apic 0 pin 17 not connected
[    0.090690]  apic 0 pin 18 not connected
[    0.091335]  apic 0 pin 19 not connected
[    0.091981]  apic 0 pin 20 not connected
[    0.092638]  apic 0 pin 21 not connected
[    0.093274]  apic 0 pin 22 not connected
[    0.093934]  apic 0 pin 23 not connected
[    0.094761] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.095960] Using local APIC timer interrupts.
[    0.095960] calibrating APIC timer ...
[    0.100000] ... lapic delta =3D 12499854
[    0.100000] ... PM-Timer delta =3D 715906
[    0.100000] APIC calibration not consistent with PM-Timer: 199ms instead=
 of 100ms
[    0.100000] APIC delta adjusted to PM-Timer: 6249944 (12499854)
[    0.100000] TSC delta adjusted to PM-Timer: 239399186 (478797036)
[    0.100000] ..... delta 6249944
[    0.100000] ..... mult: 268433050
[    0.100000] ..... calibration result: 9999910
[    0.100000] ..... CPU clock speed is 2393.9918 MHz.
[    0.100000] ..... host bus clock speed is 999.9910 MHz.
[    0.100970] devtmpfs: initialized
[    0.107789] xor: measuring software checksum speed
[    0.200014]    prefetch64-sse:  7322.800 MB/sec
[    0.300013]    generic_sse:  6792.800 MB/sec
[    0.310007] xor: using function: prefetch64-sse (7322.800 MB/sec)
[    0.311505] prandom: seed boundary self test passed
[    0.313802] prandom: 100 self tests passed
[    0.315699] regulator-dummy: no parameters
[    0.330167] NET: Registered protocol family 16
[    0.331855] cpuidle: using governor ladder
[    0.332970] cpuidle: using governor menu
[    0.334147] ACPI: bus type PCI registered
[    0.335277] PCI: Using configuration type 1 for base access
[    0.510016] raid6: sse2x1    1708 MB/s
[    0.680022] raid6: sse2x2    2207 MB/s
[    0.850018] raid6: sse2x4    1714 MB/s
[    0.850890] raid6: using algorithm sse2x2 (2207 MB/s)
[    0.851958] raid6: using intx1 recovery algorithm
[    0.853015] ACPI: Added _OSI(Module Device)
[    0.853928] ACPI: Added _OSI(Processor Device)
[    0.860009] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.860970] ACPI: Added _OSI(Processor Aggregator Device)
[    0.890681] ACPI: Interpreter enabled
[    0.891508] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140424/hwxface-580)
[    0.898423] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140424/hwxface-580)
[    0.900703] ACPI: (supports S0 S3 S5)
[    0.905100] ACPI: Using IOAPIC for interrupt routing
[    0.906455] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.954306] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.960026] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.961603] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.968307] PCI host bridge to bus 0000:00
[    0.970012] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.971404] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.977160] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.978996] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.980012] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.984583] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.986264] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.990015] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.991970] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.001247] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.008081] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.013919] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.021542] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.027453] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.030009] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.031953] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.037931] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.040566] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.042504] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.045158] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.051857] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.061657] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.081652] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.084321] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.091451] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.101392] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.118982] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.120775] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.125980] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.139831] pci_bus 0000:00: on NUMA node 0
[    1.141776] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.151054] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.153288] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.160993] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.162955] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.171388] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.173667] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.180011] vgaarb: loaded
[    1.180779] vgaarb: bridge control possible 0000:00:02.0
[    1.184516] ACPI: bus type USB registered
[    1.185811] usbcore: registered new interface driver usbfs
[    1.188875] usbcore: registered new interface driver hub
[    1.190160] usbcore: registered new device driver usb
[    1.191815] EDAC MC: Ver: 3.0.0
[    1.194512] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    1.200415] PCI: Using ACPI for IRQ routing
[    1.201560] PCI: pci_cache_line_size set to 64 bytes
[    1.206945] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.210028] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.213479] Switched to clocksource kvm-clock
[    1.217168] FS-Cache: Loaded
[    1.218083] pnp: PnP ACPI init
[    1.219037] ACPI: bus type PNP registered
[    1.221191] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.226534] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.228863] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.235036] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.240768] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.243113] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.248750] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.250995] pnp 00:03: [dma 2]
[    1.252056] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.257499] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.259817] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.265645] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.268008] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.275112] pnp: PnP ACPI: found 6 devices
[    1.276275] ACPI: bus type PNP unregistered
[    1.290922] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.296455] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.298004] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.299553] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.303959] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.305429] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.309500] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.311182] NET: Registered protocol family 1
[    1.313576] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.317856] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.319423] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.325026] pci 0000:00:02.0: Boot video device
[    1.326273] PCI: CLS 0 bytes, default 64
[    1.327711] Unpacking initramfs...
[    1.333034] Initramfs unpacking failed: junk in compressed archive
[    1.335504] general protection fault: 0000 [#1]=20
[    1.340635] Modules linked in:
[    1.341491] CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-rc1-00010-g33=
32ee2 #1
[    1.342727] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[    1.342727] task: ffff880011462000 ti: ffff880011464000 task.ti: ffff880=
011464000
[    1.342727] RIP: 0010:[<ffffffff91aac4bf>]  [<ffffffff91aac4bf>] __lock_=
acquire+0xd2b/0x194c
[    1.342727] RSP: 0000:ffff880011467ca0  EFLAGS: 00010016
[    1.342727] RAX: 00000000000002c0 RBX: ffff8800114627c0 RCX: ccccccccccc=
cccc4
[    1.342727] RDX: 000000000004a400 RSI: ffff8800114627c0 RDI: ffff8800114=
62000
[    1.342727] RBP: ffff880011467d50 R08: 0000000000000001 R09: 00000000000=
00000
[    1.342727] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff92a=
23fb0
[    1.342727] R13: 000000000000cff0 R14: ffff880011462000 R15: ffffffff929=
56ba0
[    1.342727] FS:  0000000000000000(0000) GS:ffffffff92140000(0000) knlGS:=
0000000000000000
[    1.342727] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.342727] CR2: 00000000ffffffff CR3: 0000000012130000 CR4: 00000000000=
006f0
[    1.342727] Stack:
[    1.342727]  ffffffff92a23fc0 000000000004a400 0000000000000000 ffff8800=
00000000
[    1.342727]  ffffffff929d9a70 0000000000000001 00000000000002c0 ffffffff=
91aaa716
[    1.342727]  0000000000000202 ffff880012956000 ffff880011467d10 00000000=
00000002
[    1.342727] Call Trace:
[    1.342727]  [<ffffffff91aaa716>] ? debug_check_no_locks_freed+0x12e/0x1=
50
[    1.342727]  [<ffffffff91aaa4a3>] ? trace_hardirqs_on+0xd/0xf
[    1.342727]  [<ffffffff91aad5b2>] lock_acquire+0xa2/0xc2
[    1.342727]  [<ffffffff91aee710>] ? adjust_managed_page_count+0x19/0x4a
[    1.342727]  [<ffffffff91e8ea50>] _raw_spin_lock+0x30/0x3c
[    1.342727]  [<ffffffff91aee710>] ? adjust_managed_page_count+0x19/0x4a
[    1.342727]  [<ffffffff91aee710>] adjust_managed_page_count+0x19/0x4a
[    1.342727]  [<ffffffff91af1c20>] free_reserved_area+0xdf/0x120
[    1.342727]  [<ffffffff91a26eb4>] free_init_pages+0x87/0x92
[    1.342727]  [<ffffffff921be136>] ? maybe_link.part.1+0x10c/0x10c
[    1.342727]  [<ffffffff921cb2e2>] free_initrd_mem+0x21/0x23
[    1.342727]  [<ffffffff921be1c0>] populate_rootfs+0x8a/0xa9
[    1.342727]  [<ffffffff91a00393>] do_one_initcall+0x18f/0x1a4
[    1.342727]  [<ffffffff91a94900>] ? parameqn+0x29/0x36
[    1.342727]  [<ffffffff91a94acc>] ? parse_args+0x1a0/0x27a
[    1.342727]  [<ffffffff921bd09c>] kernel_init_freeable+0x1cb/0x250
[    1.342727]  [<ffffffff921bc743>] ? initcall_blacklist+0x99/0x99
[    1.342727]  [<ffffffff91e80bbd>] ? rest_init+0x131/0x131
[    1.342727]  [<ffffffff91e80bc6>] kernel_init+0x9/0xd0
[    1.342727]  [<ffffffff91e8f5fa>] ret_from_fork+0x7a/0xb0
[    1.342727]  [<ffffffff91e80bbd>] ? rest_init+0x131/0x131
[    1.342727] Code: be e1 07 00 00 48 c7 c7 a0 a6 07 92 31 c0 e8 a3 12 fd =
ff eb 2f 48 8b 49 08 48 83 e9 08 48 8d 41 08 49 39 c7 74 60 48 8b 44 24 30 =
<48> 39 41 18 75 e4 9c 58 0f 1f 44 00 00 f6 c4 02 75 26 ff 04 25=20
[    1.342727] RIP  [<ffffffff91aac4bf>] __lock_acquire+0xd2b/0x194c
[    1.342727]  RSP <ffff880011467ca0>
[    1.342727] ---[ end trace b9a242d54f6815b8 ]---
[    1.342727] Kernel panic - not syncing: Fatal exception
[    1.342727] Rebooting in 10 seconds..
Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s1-06271225/3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24/vmlinuz-3.16.0-rc1-00=
010-g3332ee2 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pani=
c=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 consol=
e=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/k=
build-tests/run-queue/kvm/x86_64-randconfig-s1-06271225/linux-devel:devel-h=
ourly-2014062623:3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24:bisect-linux0/.vm=
linuz-3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24-20140629112851-21-lkp-wsx02 =
branch=3Dlinux-devel/devel-hourly-2014062623 BOOT_IMAGE=3D/kernel/x86_64-ra=
ndconfig-s1-06271225/3332ee2a17b1bd69e4602e2d6ba1b07edb0c9a24/vmlinuz-3.16.=
0-rc1-00010-g3332ee2 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/qu=
antal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net us=
er,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dloca=
ltime -pidfile /dev/shm/kboot/pid-quantal-lkp-wsx02-199 -serial file:/dev/s=
hm/kboot/serial-quantal-lkp-wsx02-199 -daemonize -display none -monitor nul=
l=20

--CdrF4e02JqNVZeln
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-s1-06271225-5dd35a09586ffd4c6bbc1dd80419e14f84aa5ca2-kernel-BUG-at-4708.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNWRkMzVhMC4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA2MjYyMycKZ2l0IGNoZWNrb3V0IGE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3
Yjk2NDM1YmE4YzJjYjQyZWUKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDYyNjIzOmE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWU6Ymlz
ZWN0LWxpbnV4MAoKMjAxNC0wNi0yOS0xMDoyNDo0OSBhNDk3YzNiYTFkOTdmYzY5YzFlNzhl
N2I5NjQzNWJhOGMyY2I0MmVlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LWE0
OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWUKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2E0OTdjM2JhMWQ5
N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2Mjcx
MjI1LWE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJjYjQyZWUKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS1hNDk3YzNiYTFkOTdmYzY5YzFlNzhlN2I5
NjQzNWJhOGMyY2I0MmVlCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
NjI3MTIyNS9hNDk3YzNiYTFkOTdmYzY5YzFlNzhlN2I5NjQzNWJhOGMyY2I0MmVlL3ZtbGlu
dXotMy4xNi4wLXJjMgoKMjAxNC0wNi0yOS0xMDoyNzo0OSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLi4uCTgJMTIJMTkuLi4uLi4uLi4uLi4JMjAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNv
bW1pdCBhNDk3YzNiYTFkOTdmYzY5YzFlNzhlN2I5NjQzNWJhOGMyY2I0MmVlCmdpdCBiaXNl
Y3Qgc3RhcnQgNWRkMzVhMDk1ODZmZmQ0YzZiYmMxZGQ4MDQxOWUxNGY4NGFhNWNhMiBhNDk3
YzNiYTFkOTdmYzY5YzFlNzhlN2I5NjQzNWJhOGMyY2I0MmVlIC0tCi9jL2tlcm5lbC10ZXN0
cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgIjVkZDM1YTA5NTg2ZmZkNGM2YmJjMWRkODA0MTll
MTRmODRhYTVjYTIiLCAiLWciLCAiYTQ5N2MzYmExZDk3ZmM2OWMxZTc4ZTdiOTY0MzViYThj
MmNiNDJlZSIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IiwgIi9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAxMjY2
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykK
W2MyNWVlMTQxYmRmODBiNjE5YjU2MTBjM2RhMWIxZTBjN2I3YjEzMGZdIE1lcmdlICduZnMv
bGludXgtbmV4dCcgaW50byBkZXZlbC1ob3VybHktMjAxNDA2MjYyMwpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3Qv
bGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDYyNjIzOmMyNWVlMTQxYmRmODBiNjE5YjU2MTBjM2RhMWIxZTBjN2I3YjEzMGY6Ymlz
ZWN0LWxpbnV4MAoKMjAxNC0wNi0yOS0xMDozNzo1MiBjMjVlZTE0MWJkZjgwYjYxOWI1NjEw
YzNkYTFiMWUwYzdiN2IxMzBmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LWMy
NWVlMTQxYmRmODBiNjE5YjU2MTBjM2RhMWIxZTBjN2I3YjEzMGYKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2MyNWVlMTQxYmRm
ODBiNjE5YjU2MTBjM2RhMWIxZTBjN2I3YjEzMGYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2Mjcx
MjI1LWMyNWVlMTQxYmRmODBiNjE5YjU2MTBjM2RhMWIxZTBjN2I3YjEzMGYKa2VybmVsOiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2MyNWVlMTQxYmRmODBiNjE5
YjU2MTBjM2RhMWIxZTBjN2I3YjEzMGYvdm1saW51ei0zLjE2LjAtcmMyLTAwNTcxLWdjMjVl
ZTE0CgoyMDE0LTA2LTI5LTEwOjM5OjUzIGRldGVjdGluZyBib290IHN0YXRlIC4uCTIwIFNV
Q0NFU1MKCkJpc2VjdGluZzogNjk1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMCBzdGVwcykKW2ExMGQ0ZTU4YzlkNjBlOGMxZGI0NWRiZGYxNWI2ZTg0
NTFlNmE1ZTldIE1lcmdlICdpcHNlYy90ZXN0aW5nJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0
MDYyNjIzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvbGludXgt
ZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNjI2MjM6YTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJk
ZjE1YjZlODQ1MWU2YTVlOTpiaXNlY3QtbGludXgwCgoyMDE0LTA2LTI5LTEwOjQxOjI0IGEx
MGQ0ZTU4YzlkNjBlOGMxZGI0NWRiZGYxNWI2ZTg0NTFlNmE1ZTkgY29tcGlsaW5nClF1ZXVl
ZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRj
b25maWctczEtMDYyNzEyMjUtYTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJkZjE1YjZlODQ1MWU2
YTVlOQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEt
MDYyNzEyMjUvYTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJkZjE1YjZlODQ1MWU2YTVlOQp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctczEtMDYyNzEyMjUtYTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJkZjE1YjZl
ODQ1MWU2YTVlOQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEy
MjUvYTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJkZjE1YjZlODQ1MWU2YTVlOS92bWxpbnV6LTMu
MTYuMC1yYzItMDA4ODctZ2ExMGQ0ZTUKCjIwMTQtMDYtMjktMTA6NDQ6MjQgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgCTIgVEVTVCBGQUlMVVJFClsgICAgMS41MjgwMjVdIGNyeXB0b21ncl90
ZXN0ICg2NykgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogMTM0MzIgYnl0ZXMgbGVmdApb
ICAgIDEuNTI4ODg0XSBjcnlwdG9tZ3JfdGVzdCAoNzMpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sg
ZGVwdGg6IDEzMjgwIGJ5dGVzIGxlZnQKWyAgICAxLjUzMDEyOF0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMS41MzA3MjBdIFdBUk5JTkc6IENQVTogMCBQ
SUQ6IDAgYXQgL2tidWlsZC9zcmMvc21va2Uva2VybmVsL2xvY2tpbmcvbG9ja2RlcC5jOjM1
NTQgY2hlY2tfZmxhZ3MrMHgxODUvMHgxYWIoKQpbICAgIDEuNTMxODYxXSBERUJVR19MT0NL
U19XQVJOX09OKCFjdXJyZW50LT5zb2Z0aXJxc19lbmFibGVkKQpbICAgIDEuNTMyNDg4XSBN
b2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjUzMjkxMV0gQ1BVOiAwIFBJRDogMCBDb21tOiAg
Tm90IHRhaW50ZWQgMy4xNi4wLXJjMi0wMDg4Ny1nYTEwZDRlNSAjMQpbICAgIDEuNTMzNzE0
XSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2
KSwgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMS41MzQ2MzFdICAwMDAwMDAwMDAwMDAw
MDAwIGZmZmY4ODAwMDAwODM3ZDAgZmZmZmZmZmY4NTg4OWY5NyBmZmZmODgwMDAwMDgzODA4
ClsgICAgMS41MzU0NzRdICBmZmZmZmZmZjg1NDdkN2MyIGZmZmZmZmZmODU0YWE5ZTYgMDAw
MDAwMDAwMDAwMDA0NiBmZmZmZmZmZjg1NGY5YTBhClsgICAgMS41MzYzOTldICBmZmZmZmZm
Zjg1YjVkZjIwIDAwMDAwMDAwMDAwMDAwMDMgZmZmZjg4MDAwMDA4Mzg2OCBmZmZmZmZmZjg1
NDdkODIyClsgICAgMS41MzczNDJdIENhbGwgVHJhY2U6ClsgICAgMS41Mzc2MjJdICA8VU5L
PiAKWyAgICAxLjUzNzg0OV0gLS0tWyBlbmQgdHJhY2UgNWI2ZDBiZTJjMWYyZjg4OCBdLS0t
ClsgICAgMS41Mzg0NDRdIGlycSBldmVudCBzdGFtcDogMAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA2MjcxMjI1L2ExMGQ0ZTU4YzlkNjBlOGMxZGI0NWRiZGYxNWI2ZTg0NTFl
NmE1ZTkvZG1lc2ctcXVhbnRhbC1pdmI0NC01NjoyMDE0MDYyOTEwNDQyODp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYy
NzEyMjUvYTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJkZjE1YjZlODQ1MWU2YTVlOS9kbWVzZy1x
dWFudGFsLWxrcC13c3gwMS0xNDoyMDE0MDYyOTEwNDQyODp4ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvYTEw
ZDRlNThjOWQ2MGU4YzFkYjQ1ZGJkZjE1YjZlODQ1MWU2YTVlOS9kbWVzZy15b2N0by1pdmI0
NC0xMTg6MjAxNDA2MjkxMDQ0MzE6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2ExMGQ0ZTU4YzlkNjBlOGMx
ZGI0NWRiZGYxNWI2ZTg0NTFlNmE1ZTkvZG1lc2cteW9jdG8tbGtwLW5leDA0LTEwNjoyMDE0
MDYyOTEwNDQyOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvYTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJkZjE1
YjZlODQ1MWU2YTVlOS9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTIxOjIwMTQwNjI5MTA0NDI4
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNjI3MTIyNS9hMTBkNGU1OGM5ZDYwZThjMWRiNDVkYmRmMTViNmU4NDUxZTZh
NWU5L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0xMjc6MjAxNDA2MjkxMDQ0Mjg6eDg2XzY0LXJh
bmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2
MjcxMjI1L2ExMGQ0ZTU4YzlkNjBlOGMxZGI0NWRiZGYxNWI2ZTg0NTFlNmE1ZTkvZG1lc2ct
eW9jdG8tbGtwLW5leDA0LTQzOjIwMTQwNjI5MTA0NDI5Ong4Nl82NC1yYW5kY29uZmlnLXMx
LTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS9hMTBk
NGU1OGM5ZDYwZThjMWRiNDVkYmRmMTViNmU4NDUxZTZhNWU5L2RtZXNnLXlvY3RvLWxrcC13
c3gwMS0xNDY6MjAxNDA2MjkxMDQ0Mjc6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2ExMGQ0ZTU4YzlkNjBl
OGMxZGI0NWRiZGYxNWI2ZTg0NTFlNmE1ZTkvZG1lc2cteW9jdG8tbGtwLXdzeDAxLTIwNjoy
MDE0MDYyOTEwNDQzMDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvYTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJk
ZjE1YjZlODQ1MWU2YTVlOS9kbWVzZy15b2N0by1sa3Atd3N4MDItMTM4OjIwMTQwNjI5MTA0
NDI3Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wNjI3MTIyNS9hMTBkNGU1OGM5ZDYwZThjMWRiNDVkYmRmMTViNmU4NDUx
ZTZhNWU5L2RtZXNnLXlvY3RvLWxrcC13c3gwMi04NDoyMDE0MDYyOTEwNDQyODp4ODZfNjQt
cmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEt
MDYyNzEyMjUvYTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJkZjE1YjZlODQ1MWU2YTVlOS9kbWVz
Zy1xdWFudGFsLWxrcC1uZXgwNC00MjoyMDE0MDYyOTEwNDQzNDp4ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUv
YTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJkZjE1YjZlODQ1MWU2YTVlOS9kbWVzZy1xdWFudGFs
LWxrcC1uZXgwNC05NToyMDE0MDYyOTEwNDQzNDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3
MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvYTEwZDRlNThj
OWQ2MGU4YzFkYjQ1ZGJkZjE1YjZlODQ1MWU2YTVlOS9kbWVzZy15b2N0by1pdmI0NC04MDoy
MDE0MDYyOTEwNDQzMjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvYTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJk
ZjE1YjZlODQ1MWU2YTVlOS9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTMzOjIwMTQwNjI5MTA0
NDMyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wNjI3MTIyNS9hMTBkNGU1OGM5ZDYwZThjMWRiNDVkYmRmMTViNmU4NDUx
ZTZhNWU5L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC00MjoyMDE0MDYyOTEwNDQzMTp4ODZfNjQt
cmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEt
MDYyNzEyMjUvYTEwZDRlNThjOWQ2MGU4YzFkYjQ1ZGJkZjE1YjZlODQ1MWU2YTVlOS9kbWVz
Zy15b2N0by1sa3AtbmV4MDQtODE6MjAxNDA2MjkxMDQ0MzI6eDg2XzY0LXJhbmRjb25maWct
czEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2Ex
MGQ0ZTU4YzlkNjBlOGMxZGI0NWRiZGYxNWI2ZTg0NTFlNmE1ZTkvZG1lc2cteW9jdG8tbGtw
LXdzeDAxLTk5OjIwMTQwNjI5MTA0NDMwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1
OjoKMDoxODoyMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNi0y
OSAxMDo0NDo1NSBSRVBFQVQgQ09VTlQ6IDIxICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDMxNiByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKWzFhYWNjZDNlNmE3NjM5YTRh
YzBhY2YzZGIzMzA4MjkxOTcwYjc5NGJdIE1lcmdlICdlZmkvbmV4dCcgaW50byBkZXZlbC1o
b3VybHktMjAxNDA2MjYyMwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2Mjcx
MjI1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYyNjIzOjFhYWNjZDNlNmE3NjM5
YTRhYzBhY2YzZGIzMzA4MjkxOTcwYjc5NGI6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNi0yOS0x
MDo0NDo1NiAxYWFjY2QzZTZhNzYzOWE0YWMwYWNmM2RiMzMwODI5MTk3MGI3OTRiIGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LTFhYWNjZDNlNmE3NjM5YTRhYzBhY2YzZGIz
MzA4MjkxOTcwYjc5NGIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA2MjcxMjI1LzFhYWNjZDNlNmE3NjM5YTRhYzBhY2YzZGIzMzA4MjkxOTcw
Yjc5NGIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LTFhYWNjZDNlNmE3NjM5YTRhYzBh
Y2YzZGIzMzA4MjkxOTcwYjc5NGIKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA2MjcxMjI1LzFhYWNjZDNlNmE3NjM5YTRhYzBhY2YzZGIzMzA4MjkxOTcwYjc5NGIv
dm1saW51ei0zLjE2LjAtcmMyLTAwNzkwLWcxYWFjY2QzCgoyMDE0LTA2LTI5LTEwOjUzOjU2
IGRldGVjdGluZyBib290IHN0YXRlIC4uCTMJMjAuLi4uLi4uLi4uLi4uLi4uCTIxIFNVQ0NF
U1MKCkJpc2VjdGluZzogOTcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDcgc3RlcHMpCls3MWRiN2UwZGQxN2Q3ZmRhNWMxNmY3NWM3Yzg4ZjIwZjM1NWJh
OGMzXSBNZXJnZSAna3ZtLXBwYy9rdm0tcHBjLXF1ZXVlJyBpbnRvIGRldmVsLWhvdXJseS0y
MDE0MDYyNjIzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNjI2MjM6NzFkYjdlMGRkMTdkN2ZkYTVjMTZm
NzVjN2M4OGYyMGYzNTViYThjMzpiaXNlY3QtbGludXgwCgoyMDE0LTA2LTI5LTExOjA0OjI3
IDcxZGI3ZTBkZDE3ZDdmZGE1YzE2Zjc1YzdjODhmMjBmMzU1YmE4YzMgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctczEtMDYyNzEyMjUtNzFkYjdlMGRkMTdkN2ZkYTVjMTZmNzVjN2M4OGYyMGYz
NTViYThjMwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDYyNzEyMjUvNzFkYjdlMGRkMTdkN2ZkYTVjMTZmNzVjN2M4OGYyMGYzNTViYThjMwp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUtNzFkYjdlMGRkMTdkN2ZkYTVjMTZmNzVjN2M4
OGYyMGYzNTViYThjMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvc25iLXNtb2tlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LTcx
ZGI3ZTBkZDE3ZDdmZGE1YzE2Zjc1YzdjODhmMjBmMzU1YmE4YzMKa2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzcxZGI3ZTBkZDE3ZDdmZGE1YzE2Zjc1
YzdjODhmMjBmMzU1YmE4YzMvdm1saW51ei0zLjE2LjAtcmMyLTAwODUxLWc3MWRiN2UwCgoy
MDE0LTA2LTI5LTExOjA4OjI3IGRldGVjdGluZyBib290IHN0YXRlIAkxIFRFU1QgRkFJTFVS
RQpbICAgIDEuNDgzNTk5XSBDUkVEOiAtPipnaWQgPSB7IDAsMCwwLDAgfQpbICAgIDEuNDg0
MDA4XSBDUkVEOiBFZmZlY3RpdmUgY3JlZHMgPT0gUmVhbCBjcmVkcwpbICAgIDEuNDg0NDk4
XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAxLjQ4NTAxMF0g
a2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9zbW9rZS9rZXJuZWwvY3JlZC5jOjc5MCEKWyAg
ICAxLjQ4NTYyOV0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSAKWyAgICAxLjQ4NjA1N10g
TW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMS40ODY0MzddIENQVTogMCBQSUQ6IDc3IENvbW06
IGNyeXB0b21ncl90ZXN0IE5vdCB0YWludGVkIDMuMTYuMC1yYzItMDA4NTEtZzcxZGI3ZTAg
IzEKWyAgICAxLjQ4NzI5NV0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0
MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDEuNDg4MTUy
XSB0YXNrOiBmZmZmODgwMDBjMGUwMDAwIHRpOiBmZmZmODgwMDBjMTFjMDAwIHRhc2sudGk6
IGZmZmY4ODAwMGMxMWMwMDAKWyAgICAxLjQ4ODk0Nl0gUklQOiAwMDEwOls8ZmZmZmZmZmY4
NGM5OWZkNj5dICBbPGZmZmZmZmZmODRjOTlmZDY+XSBfX3ZhbGlkYXRlX3Byb2Nlc3NfY3Jl
ZHMrMHhhOS8weGM2ClsgICAgMS40ODk5MTFdIFJTUDogMDAwMDpmZmZmODgwMDBjMTFmZDkw
ICBFRkxBR1M6IDAwMDEwMjk2ClsgICAgMS40OTAwMDhdIFJBWDogMDAwMDAwMDAwMDAwMDAy
MyBSQlg6IGZmZmY4ODAwMGMwZTAwMDAgUkNYOiBmZmZmODgwMDBjMGUwN2MwClsgICAgMS40
OTAwMDhdIFJEWDogMDAwMDAwMDAwMDAwMDFjNSBSU0k6IDAwMDAwMDAwMDAwMDAwMDEgUkRJ
OiAwMDAwMDAwMDAwMDAwMjQ2ClsgICAgMS40OTAwMDhdIFJCUDogZmZmZjg4MDAwYzExZmRh
OCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS40
OTAwMDhdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEy
OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS40OTAwMDhdIFIxMzogZmZmZmZmZmY4NGU3NGJh
ZCBSMTQ6IDAwMDAwMDAwMDAwMDAwMDAgUjE1OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS40
OTAwMDhdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmZmZmZjg1MzQxMDAw
KDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjQ5MDAwOF0gQ1M6ICAwMDEw
IERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDEuNDkwMDA4
XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDA1MzMxMDAwIENSNDogMDAw
MDAwMDAwMDAwMDZmMApbICAgIDEuNDkwMDA4XSBTdGFjazoKWyAgICAxLjQ5MDAwOF0gIDAw
MDAwMzI0MTFlYTAxNzAgZmZmZmZmZmY4NTI3OWRhOCBmZmZmODgwMDBjMGUwMDAwIGZmZmY4
ODAwMGMxMWZkYjgKWyAgICAxLjQ5MDAwOF0gIGZmZmZmZmZmODRjOWE4Y2EgZmZmZjg4MDAw
YzExZmUzMCBmZmZmZmZmZjg0YzdlMjE3IGZmZmY4ODAwMGMxMWZkZTgKWyAgICAxLjQ5MDAw
OF0gIDAwMDAwMDAwMDAwMDAyODYgZmZmZjg4MDAwYzBlMjAwMCBmZmZmODgwMDBjMGUyMDhj
IDAwMDAwMDAwMGMxMWZlMzAKWyAgICAxLjQ5MDAwOF0gQ2FsbCBUcmFjZToKWyAgICAxLjQ5
MDAwOF0gIFs8ZmZmZmZmZmY4NGM5YThjYT5dIHZhbGlkYXRlX2NyZWRzX2Zvcl9kb19leGl0
KzB4MjEvMHgyMwpbICAgIDEuNDkwMDA4XSAgWzxmZmZmZmZmZjg0YzdlMjE3Pl0gZG9fZXhp
dCsweGQ0LzB4OTI3ClsgICAgMS40OTAwMDhdICBbPGZmZmZmZmZmODRkMWE2ZWE+XSA/IHNs
b2JfZnJlZSsweDI2NC8weDI3MQpbICAgIDEuNDkwMDA4XSAgWzxmZmZmZmZmZjg0ZTc0YmFk
Pl0gPyBjcnlwdG9tZ3Jfbm90aWZ5KzB4MzY1LzB4MzY1ClsgICAgMS40OTAwMDhdICBbPGZm
ZmZmZmZmODRjYzYwOGE+XSBfX21vZHVsZV9wdXRfYW5kX2V4aXQrMHgxNS8weDE1ClsgICAg
MS40OTAwMDhdICBbPGZmZmZmZmZmODRlNzRiZWI+XSBjcnlwdG9tZ3JfdGVzdCsweDNlLzB4
M2UKWyAgICAxLjQ5MDAwOF0gIFs8ZmZmZmZmZmY4NGM5NjU5Nj5dIGt0aHJlYWQrMHhmZS8w
eDEwNgpbICAgIDEuNDkwMDA4XSAgWzxmZmZmZmZmZjg0Yzk2NDk4Pl0gPyBrdGhyZWFkX2Ny
ZWF0ZV9vbl9ub2RlKzB4MWI0LzB4MWI0ClsgICAgMS40OTAwMDhdICBbPGZmZmZmZmZmODUw
OGZkM2E+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgIDEuNDkwMDA4XSAgWzxmZmZm
ZmZmZjg0Yzk2NDk4Pl0gPyBrdGhyZWFkX2NyZWF0ZV9vbl9ub2RlKzB4MWI0LzB4MWI0Clsg
ICAgMS40OTAwMDhdIENvZGU6IDA1IDAwIDAwIDQ4IDNiIGJiIDU4IDA1IDAwIDAwIDc0IDEx
IDQ4IDg5IGRhIDQ4IGM3IGM2IDJkIDlmIDI3IDg1IGU4IDBkIGZlIGZmIGZmIGViIDBlIDQ4
IGM3IGM3IDM3IDlmIDI3IDg1IDMxIGMwIGU4IDNmIGUzIDNlIDAwIDwwZj4gMGIgODEgNzkg
MTAgNjQgNjUgNzMgNDMgNzUgODYgODEgNzggMTAgNjQgNjUgNzMgNDMgMGYgODUgNzkgClsg
ICAgMS40OTAwMDhdIFJJUCAgWzxmZmZmZmZmZjg0Yzk5ZmQ2Pl0gX192YWxpZGF0ZV9wcm9j
ZXNzX2NyZWRzKzB4YTkvMHhjNgpbICAgIDEuNDkwMDA4XSAgUlNQIDxmZmZmODgwMDBjMTFm
ZDkwPgpbICAgIDEuNTEwMTIwXSAtLS1bIGVuZCB0cmFjZSAxNDYyMzhkNGZjZmUxNTI0IF0t
LS0KWyAgICAxLjUxMDU1OV0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4
Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzcxZGI3ZTBk
ZDE3ZDdmZGE1YzE2Zjc1YzdjODhmMjBmMzU1YmE4YzMvZG1lc2ctcXVhbnRhbC1pdmI0MS02
NzoyMDE0MDYyOTExMDgwODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvNzFkYjdlMGRkMTdkN2ZkYTVjMTZm
NzVjN2M4OGYyMGYzNTViYThjMy9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0xMjU6MjAxNDA2
MjkxMTA4MTM6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzcxZGI3ZTBkZDE3ZDdmZGE1YzE2Zjc1YzdjODhm
MjBmMzU1YmE4YzMvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTI2OjIwMTQwNjI5MTEwODEy
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNjI3MTIyNS83MWRiN2UwZGQxN2Q3ZmRhNWMxNmY3NWM3Yzg4ZjIwZjM1NWJh
OGMzL2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTg2OjIwMTQwNjI5MTEwODE0Ong4Nl82NC1y
YW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
NjI3MTIyNS83MWRiN2UwZGQxN2Q3ZmRhNWMxNmY3NWM3Yzg4ZjIwZjM1NWJhOGMzL2RtZXNn
LXF1YW50YWwtbGtwLW5leDA0LTg5OjIwMTQwNjI5MTEwODExOng4Nl82NC1yYW5kY29uZmln
LXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS83
MWRiN2UwZGQxN2Q3ZmRhNWMxNmY3NWM3Yzg4ZjIwZjM1NWJhOGMzL2RtZXNnLXF1YW50YWwt
bGtwLW5leDA0LTkzOjIwMTQwNjI5MTEwODEyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA2Mjcx
MjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS83MWRiN2UwZGQx
N2Q3ZmRhNWMxNmY3NWM3Yzg4ZjIwZjM1NWJhOGMzL2RtZXNnLXF1YW50YWwtbGtwLXdzeDAy
LTIyMzoyMDE0MDYyOTExMDgxMTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvNzFkYjdlMGRkMTdkN2ZkYTVj
MTZmNzVjN2M4OGYyMGYzNTViYThjMy9kbWVzZy15b2N0by1pdmI0MS0yMzoyMDE0MDYyOTEx
MDgwODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDYyNzEyMjUvNzFkYjdlMGRkMTdkN2ZkYTVjMTZmNzVjN2M4OGYyMGYz
NTViYThjMy9kbWVzZy15b2N0by1pdmI0My0xMDQ6MjAxNDA2MjkxMTA4MDc6eDg2XzY0LXJh
bmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2
MjcxMjI1LzcxZGI3ZTBkZDE3ZDdmZGE1YzE2Zjc1YzdjODhmMjBmMzU1YmE4YzMvZG1lc2ct
eW9jdG8taXZiNDMtMTA1OjIwMTQwNjI5MTEwODA4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2
MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS83MWRiN2Uw
ZGQxN2Q3ZmRhNWMxNmY3NWM3Yzg4ZjIwZjM1NWJhOGMzL2RtZXNnLXlvY3RvLWl2YjQzLTIz
OjIwMTQwNjI5MTEwODA5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS83MWRiN2UwZGQxN2Q3ZmRhNWMxNmY3
NWM3Yzg4ZjIwZjM1NWJhOGMzL2RtZXNnLXlvY3RvLWl2YjQzLTYwOjIwMTQwNjI5MTEwODA2
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNjI3MTIyNS83MWRiN2UwZGQxN2Q3ZmRhNWMxNmY3NWM3Yzg4ZjIwZjM1NWJh
OGMzL2RtZXNnLXlvY3RvLWl2YjQzLTY3OjIwMTQwNjI5MTEwODEwOng4Nl82NC1yYW5kY29u
ZmlnLXMxLTA2MjcxMjI1OjoKMDoxMzoxNCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoK
QmlzZWN0aW5nOiA2MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgNiBzdGVwcykKWzlmOTQwOTc0MGYzMTg0MTdhNDBlMDA0ZjUzNzgxNjNkMjQxYWRmNDNd
IE1lcmdlICdjcnlwdG9kZXYvbWFzdGVyJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDYyNjIz
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
Yy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwNjI2MjM6OWY5NDA5NzQwZjMxODQxN2E0MGUwMDRmNTM3ODE2
M2QyNDFhZGY0MzpiaXNlY3QtbGludXgwCgoyMDE0LTA2LTI5LTExOjA4OjU5IDlmOTQwOTc0
MGYzMTg0MTdhNDBlMDA0ZjUzNzgxNjNkMjQxYWRmNDMgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWct
czEtMDYyNzEyMjUtOWY5NDA5NzQwZjMxODQxN2E0MGUwMDRmNTM3ODE2M2QyNDFhZGY0MwpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEy
MjUvOWY5NDA5NzQwZjMxODQxN2E0MGUwMDRmNTM3ODE2M2QyNDFhZGY0Mwp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRj
b25maWctczEtMDYyNzEyMjUtOWY5NDA5NzQwZjMxODQxN2E0MGUwMDRmNTM3ODE2M2QyNDFh
ZGY0MwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvOWY5
NDA5NzQwZjMxODQxN2E0MGUwMDRmNTM3ODE2M2QyNDFhZGY0My92bWxpbnV6LTMuMTYuMC1y
YzItMDA4MzEtZzlmOTQwOTcKCjIwMTQtMDYtMjktMTE6MTI6NTkgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4uLi4uLi4uLi4uCTIgVEVTVCBGQUlMVVJFClsgICAgMy40MDQyMTBdIENSRUQ6
IC0+KmdpZCA9IHsgMCwwLDAsMCB9ClsgICAgMy40MDU5ODVdIENSRUQ6IEVmZmVjdGl2ZSBj
cmVkcyA9PSBSZWFsIGNyZWRzClsgICAgMy40MDc0MjBdIC0tLS0tLS0tLS0tLVsgY3V0IGhl
cmUgXS0tLS0tLS0tLS0tLQpbICAgIDMuNDA5NzY1XSBrZXJuZWwgQlVHIGF0IC9rYnVpbGQv
c3JjL3Ntb2tlL2tlcm5lbC9jcmVkLmM6NzkwIQpbICAgIDMuNDEwMTc2XSBpbnZhbGlkIG9w
Y29kZTogMDAwMCBbIzFdIApbICAgIDMuNDEwMTc2XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAg
ICAzLjQxMDE3Nl0gQ1BVOiAwIFBJRDogNzcgQ29tbTogY3J5cHRvbWdyX3Rlc3QgTm90IHRh
aW50ZWQgMy4xNi4wLXJjMi0wMDgzMS1nOWY5NDA5NyAjMQpbICAgIDMuNDEwMTc2XSBIYXJk
d2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAgMy40MTAxNzZdIHRhc2s6IGZmZmY4ODAwMGE4ZjAw
MDAgdGk6IGZmZmY4ODAwMGE5MWMwMDAgdGFzay50aTogZmZmZjg4MDAwYTkxYzAwMApbICAg
IDMuNDEwMTc2XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjhmODk5ZmQ2Pl0gIFs8ZmZmZmZmZmY4
Zjg5OWZkNj5dIF9fdmFsaWRhdGVfcHJvY2Vzc19jcmVkcysweGE5LzB4YzYKWyAgICAzLjQx
MDE3Nl0gUlNQOiAwMDAwOmZmZmY4ODAwMGE5MWZkOTAgIEVGTEFHUzogMDAwMTAyOTYKWyAg
ICAzLjQxMDE3Nl0gUkFYOiAwMDAwMDAwMDAwMDAwMDIzIFJCWDogZmZmZjg4MDAwYThmMDAw
MCBSQ1g6IGZmZmY4ODAwMGE4ZjA3YzAKWyAgICAzLjQxMDE3Nl0gUkRYOiAwMDAwMDAwMDAw
MDAwMWM1IFJTSTogMDAwMDAwMDAwMDAwMDAwMSBSREk6IDAwMDAwMDAwMDAwMDAyNDYKWyAg
ICAzLjQxMDE3Nl0gUkJQOiBmZmZmODgwMDBhOTFmZGE4IFIwODogMDAwMDAwMDAwMDAwMDAw
MCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAzLjQxMDE3Nl0gUjEwOiAwMDAwMDAwMDAw
MDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
ICAzLjQxMDE3Nl0gUjEzOiBmZmZmZmZmZjhmYTc0YjZkIFIxNDogMDAwMDAwMDAwMDAwMDAw
MCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAzLjQxMDE3Nl0gRlM6ICAwMDAwMDAwMDAw
MDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmOGZmNDEwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAw
MDAwMDAwMApbICAgIDMuNDEwMTc2XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1Iw
OiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMy40MTAxNzZdIENSMjogMDAwMDAwMDAwMDAwMDAw
MCBDUjM6IDAwMDAwMDAwMGZmMzEwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmYwClsgICAgMy40
MTAxNzZdIFN0YWNrOgpbICAgIDMuNDEwMTc2XSAgMDAwMDAzMjQxMWU0YzFlMCBmZmZmZmZm
ZjhmZTc5ZGE4IGZmZmY4ODAwMGE4ZjAwMDAgZmZmZjg4MDAwYTkxZmRiOApbICAgIDMuNDEw
MTc2XSAgZmZmZmZmZmY4Zjg5YThjYSBmZmZmODgwMDBhOTFmZTMwIGZmZmZmZmZmOGY4N2Uy
MTcgZmZmZjg4MDAwYTkxZmRlOApbICAgIDMuNDEwMTc2XSAgMDAwMDAwMDAwMDAwMDI4NiBm
ZmZmODgwMDBhOGU0MDAwIGZmZmY4ODAwMGE4ZTQwOGMgMDAwMDAwMDAwYTkxZmUzMApbICAg
IDMuNDEwMTc2XSBDYWxsIFRyYWNlOgpbICAgIDMuNDEwMTc2XSAgWzxmZmZmZmZmZjhmODlh
OGNhPl0gdmFsaWRhdGVfY3JlZHNfZm9yX2RvX2V4aXQrMHgyMS8weDIzClsgICAgMy40MTAx
NzZdICBbPGZmZmZmZmZmOGY4N2UyMTc+XSBkb19leGl0KzB4ZDQvMHg5MjcKWyAgICAzLjQx
MDE3Nl0gIFs8ZmZmZmZmZmY4ZjkxYTZlYT5dID8gc2xvYl9mcmVlKzB4MjY0LzB4MjcxClsg
ICAgMy40MTAxNzZdICBbPGZmZmZmZmZmOGZhNzRiNmQ+XSA/IGNyeXB0b21ncl9ub3RpZnkr
MHgzNjUvMHgzNjUKWyAgICAzLjQxMDE3Nl0gIFs8ZmZmZmZmZmY4ZjhjNjA4YT5dIF9fbW9k
dWxlX3B1dF9hbmRfZXhpdCsweDE1LzB4MTUKWyAgICAzLjQxMDE3Nl0gIFs8ZmZmZmZmZmY4
ZmE3NGJhYj5dIGNyeXB0b21ncl90ZXN0KzB4M2UvMHgzZQpbICAgIDMuNDEwMTc2XSAgWzxm
ZmZmZmZmZjhmODk2NTk2Pl0ga3RocmVhZCsweGZlLzB4MTA2ClsgICAgMy40MTAxNzZdICBb
PGZmZmZmZmZmOGY4OTY0OTg+XSA/IGt0aHJlYWRfY3JlYXRlX29uX25vZGUrMHgxYjQvMHgx
YjQKWyAgICAzLjQxMDE3Nl0gIFs8ZmZmZmZmZmY4ZmM4ZmNmYT5dIHJldF9mcm9tX2Zvcmsr
MHg3YS8weGIwClsgICAgMy40MTAxNzZdICBbPGZmZmZmZmZmOGY4OTY0OTg+XSA/IGt0aHJl
YWRfY3JlYXRlX29uX25vZGUrMHgxYjQvMHgxYjQKWyAgICAzLjQxMDE3Nl0gQ29kZTogMDUg
MDAgMDAgNDggM2IgYmIgNTggMDUgMDAgMDAgNzQgMTEgNDggODkgZGEgNDggYzcgYzYgMmQg
OWYgZTcgOGYgZTggMGQgZmUgZmYgZmYgZWIgMGUgNDggYzcgYzcgMzcgOWYgZTcgOGYgMzEg
YzAgZTggZmYgZTIgM2UgMDAgPDBmPiAwYiA4MSA3OSAxMCA2NCA2NSA3MyA0MyA3NSA4NiA4
MSA3OCAxMCA2NCA2NSA3MyA0MyAwZiA4NSA3OSAKWyAgICAzLjQxMDE3Nl0gUklQICBbPGZm
ZmZmZmZmOGY4OTlmZDY+XSBfX3ZhbGlkYXRlX3Byb2Nlc3NfY3JlZHMrMHhhOS8weGM2Clsg
ICAgMy40MTAxNzZdICBSU1AgPGZmZmY4ODAwMGE5MWZkOTA+ClsgICAgMy41MTgzNDRdIC0t
LVsgZW5kIHRyYWNlIGRlN2E3ZDUzMmY5NjQwMDAgXS0tLQpbICAgIDMuNTIwNDIxXSBLZXJu
ZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDYyNzEyMjUvOWY5NDA5NzQwZjMxODQxN2E0MGUwMDRmNTM3ODE2
M2QyNDFhZGY0My9kbWVzZy1xdWFudGFsLWxrcC13c3gwMS0xMTU6MjAxNDA2MjkxMTEzMTM6
eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA2MjcxMjI1LzlmOTQwOTc0MGYzMTg0MTdhNDBlMDA0ZjUzNzgxNjNkMjQxYWRm
NDMvZG1lc2ctcXVhbnRhbC1sa3Atd3N4MDEtMTM5OjIwMTQwNjI5MTExMzE3Ong4Nl82NC1y
YW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
NjI3MTIyNS85Zjk0MDk3NDBmMzE4NDE3YTQwZTAwNGY1Mzc4MTYzZDI0MWFkZjQzL2RtZXNn
LXF1YW50YWwtbGtwLXdzeDAxLTE2MjoyMDE0MDYyOTExMTMxNTp4ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUv
OWY5NDA5NzQwZjMxODQxN2E0MGUwMDRmNTM3ODE2M2QyNDFhZGY0My9kbWVzZy1xdWFudGFs
LWxrcC13c3gwMS0xNzM6MjAxNDA2MjkxMTEzMTc6eDg2XzY0LXJhbmRjb25maWctczEtMDYy
NzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzlmOTQwOTc0
MGYzMTg0MTdhNDBlMDA0ZjUzNzgxNjNkMjQxYWRmNDMvZG1lc2ctcXVhbnRhbC1sa3Atd3N4
MDEtNDA6MjAxNDA2MjkxMTEzMDk6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzlmOTQwOTc0MGYzMTg0MTdh
NDBlMDA0ZjUzNzgxNjNkMjQxYWRmNDMvZG1lc2ctcXVhbnRhbC1sa3Atd3N4MDEtNTQ6MjAx
NDA2MjkxMTEzMTc6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzlmOTQwOTc0MGYzMTg0MTdhNDBlMDA0ZjUz
NzgxNjNkMjQxYWRmNDMvZG1lc2ctcXVhbnRhbC1sa3Atd3N4MDEtOTk6MjAxNDA2MjkxMTEz
MTA6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA2MjcxMjI1LzlmOTQwOTc0MGYzMTg0MTdhNDBlMDA0ZjUzNzgxNjNkMjQx
YWRmNDMvZG1lc2cteW9jdG8taXZiNDMtMTA1OjIwMTQwNjI5MTExMzA3Ong4Nl82NC1yYW5k
Y29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3
MTIyNS85Zjk0MDk3NDBmMzE4NDE3YTQwZTAwNGY1Mzc4MTYzZDI0MWFkZjQzL2RtZXNnLXlv
Y3RvLWl2YjQzLTMyOjIwMTQwNjI5MTExMzA2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2Mjcx
MjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS85Zjk0MDk3NDBm
MzE4NDE3YTQwZTAwNGY1Mzc4MTYzZDI0MWFkZjQzL2RtZXNnLXlvY3RvLWl2YjQzLTYwOjIw
MTQwNjI5MTExMzA2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS85Zjk0MDk3NDBmMzE4NDE3YTQwZTAwNGY1
Mzc4MTYzZDI0MWFkZjQzL2RtZXNnLXlvY3RvLWl2YjQzLTY0OjIwMTQwNjI5MTExMzA3Ong4
Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNjI3MTIyNS85Zjk0MDk3NDBmMzE4NDE3YTQwZTAwNGY1Mzc4MTYzZDI0MWFkZjQz
L2RtZXNnLXlvY3RvLWl2YjQzLTc0OjIwMTQwNjI5MTExMzA2Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS85
Zjk0MDk3NDBmMzE4NDE3YTQwZTAwNGY1Mzc4MTYzZDI0MWFkZjQzL2RtZXNnLXlvY3RvLWxr
cC13c3gwMS0yMTA6MjAxNDA2MjkxMTEzMDc6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEy
MjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzlmOTQwOTc0MGYz
MTg0MTdhNDBlMDA0ZjUzNzgxNjNkMjQxYWRmNDMvZG1lc2cteW9jdG8tbGtwLXdzeDAxLTIx
OToyMDE0MDYyOTExMTMwNzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvOWY5NDA5NzQwZjMxODQxN2E0MGUw
MDRmNTM3ODE2M2QyNDFhZGY0My9kbWVzZy15b2N0by1sa3Atd3N4MDEtMzA6MjAxNDA2Mjkx
MTEzMDM6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA2MjcxMjI1LzlmOTQwOTc0MGYzMTg0MTdhNDBlMDA0ZjUzNzgxNjNk
MjQxYWRmNDMvZG1lc2cteW9jdG8tbGtwLXdzeDAxLTQxOjIwMTQwNjI5MTExMzA3Ong4Nl82
NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNjI3MTIyNS85Zjk0MDk3NDBmMzE4NDE3YTQwZTAwNGY1Mzc4MTYzZDI0MWFkZjQzL2Rt
ZXNnLXlvY3RvLWxrcC13c3gwMS02NDoyMDE0MDYyOTExMTMwNzp4ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUv
OWY5NDA5NzQwZjMxODQxN2E0MGUwMDRmNTM3ODE2M2QyNDFhZGY0My9kbWVzZy15b2N0by1s
a3Atd3N4MDEtODQ6MjAxNDA2MjkxMTEzMDM6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEy
MjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzlmOTQwOTc0MGYz
MTg0MTdhNDBlMDA0ZjUzNzgxNjNkMjQxYWRmNDMvZG1lc2cteW9jdG8tbGtwLXdzeDAxLTk6
MjAxNDA2MjkxMTEzMDc6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6OgowOjE5OjIx
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA2LTI5IDExOjE5OjMw
IFJFUEVBVCBDT1VOVDogMjEgICMgL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3Qv
LnJlcGVhdBtbMG0KCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIGNyeXB0b2Rl
di9tYXN0ZXIKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5l
YXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDlmOTQwOTc0MGYzMTg0MTdhNDBlMDA0ZjUz
NzgxNjNkMjQxYWRmNDMgMWFhY2NkM2U2YTc2MzlhNGFjMGFjZjNkYjMzMDgyOTE5NzBiNzk0
YiAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA5Zjk0MDk3Li4uIE1lcmdlICdjcnlw
dG9kZXYvbWFzdGVyJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDYyNjIzCkhFQUQgaXMgbm93
IGF0IGUyNDQ3YzUuLi4gTWVyZ2UgJ2NyeXB0b2Rldi9tYXN0ZXInIGludG8gZGV2ZWwtaG91
cmx5LTIwMTQwNjI3MTMKQmlzZWN0aW5nOiAyMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKW2IzNDE2ZmI4YTJmNWExNjUzZTRhYjcyYjU1
OTA3Nzk0Y2MxMGJkZTFdIGNyeXB0bzogcWF0IC0gSW50ZWwoUikgUUFUIGFjY2VsZW5naW5l
IHBhcnQgb2YgZncgbG9hZGVyCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3Qv
bGludXgwL29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3
MTIyNS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2MjYyMzpiMzQxNmZiOGEyZjVh
MTY1M2U0YWI3MmI1NTkwNzc5NGNjMTBiZGUxOmJpc2VjdC1saW51eDAKCjIwMTQtMDYtMjkt
MTE6MTk6MzQgYjM0MTZmYjhhMmY1YTE2NTNlNGFiNzJiNTU5MDc3OTRjYzEwYmRlMSBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS1iMzQxNmZiOGEyZjVhMTY1M2U0YWI3MmI1
NTkwNzc5NGNjMTBiZGUxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wNjI3MTIyNS9iMzQxNmZiOGEyZjVhMTY1M2U0YWI3MmI1NTkwNzc5NGNj
MTBiZGUxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS1iMzQxNmZiOGEyZjVhMTY1M2U0
YWI3MmI1NTkwNzc5NGNjMTBiZGUxCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNjI3MTIyNS9iMzQxNmZiOGEyZjVhMTY1M2U0YWI3MmI1NTkwNzc5NGNjMTBiZGUx
L3ZtbGludXotMy4xNi4wLXJjMS0wMDAyMC1nYjM0MTZmYgoKMjAxNC0wNi0yOS0xMToyMjoz
NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4JMSBURVNUIEZBSUxVUkUKWyAgICAzLjg3
MjI5M10gQ1JFRDogLT4qZ2lkID0geyAwLDAsMCwwIH0KWyAgICAzLjg3MzYwNl0gQ1JFRDog
RWZmZWN0aXZlIGNyZWRzID09IFJlYWwgY3JlZHMKWyAgICAzLjg3NjAxMF0gLS0tLS0tLS0t
LS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMy44Nzg3NjRdIGtlcm5lbCBCVUcg
YXQgL2tidWlsZC9zcmMvc21va2Uva2VybmVsL2NyZWQuYzo3OTAhClsgICAgMy44ODAwNDRd
IGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gClsgICAgMy44ODA4MjBdIE1vZHVsZXMgbGlu
a2VkIGluOgpbICAgIDMuODgxNDQ4XSBDUFU6IDAgUElEOiA3NyBDb21tOiBjcnlwdG9tZ3Jf
dGVzdCBOb3QgdGFpbnRlZCAzLjE2LjAtcmMxLTAwMDIwLWdiMzQxNmZiICMxClsgICAgMy44
ODE0NDhdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgs
IDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAzLjg4MTQ0OF0gdGFzazogZmZm
Zjg4MDAwYzBmODAwMCB0aTogZmZmZjg4MDAwYzBmYzAwMCB0YXNrLnRpOiBmZmZmODgwMDBj
MGZjMDAwClsgICAgMy44ODE0NDhdIFJJUDogMDAxMDpbPGZmZmZmZmZmODU4OTlmMTQ+XSAg
WzxmZmZmZmZmZjg1ODk5ZjE0Pl0gX192YWxpZGF0ZV9wcm9jZXNzX2NyZWRzKzB4YTkvMHhj
NgpbICAgIDMuODgxNDQ4XSBSU1A6IDAwMDA6ZmZmZjg4MDAwYzBmZmQ5MCAgRUZMQUdTOiAw
MDAxMDI5NgpbICAgIDMuODgxNDQ4XSBSQVg6IDAwMDAwMDAwMDAwMDAwMjMgUkJYOiBmZmZm
ODgwMDBjMGY4MDAwIFJDWDogZmZmZjg4MDAwYzBmODdjMApbICAgIDMuODgxNDQ4XSBSRFg6
IDAwMDAwMDAwMDAwMDAxYzYgUlNJOiAwMDAwMDAwMDAwMDAwMDAxIFJESTogMDAwMDAwMDAw
MDAwMDI0NgpbICAgIDMuODgxNDQ4XSBSQlA6IGZmZmY4ODAwMGMwZmZkYTggUjA4OiAwMDAw
MDAwMDAwMDAwMDAwIFIwOTogMDAwMDAwMDAwMDAwMDAwMApbICAgIDMuODgxNDQ4XSBSMTA6
IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogMDAwMDAwMDAw
MDAwMDAwMApbICAgIDMuODgxNDQ4XSBSMTM6IGZmZmZmZmZmODVhNzQ1ZWQgUjE0OiAwMDAw
MDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMDAwMDAwMApbICAgIDMuODgxNDQ4XSBGUzog
IDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4NWY0MDAwMCgwMDAwKSBrbmxH
UzowMDAwMDAwMDAwMDAwMDAwClsgICAgMy44ODE0NDhdIENTOiAgMDAxMCBEUzogMDAwMCBF
UzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICAzLjg4MTQ0OF0gQ1IyOiAwMDAw
MDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAwNWYzMDAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2
ZjAKWyAgICAzLjg4MTQ0OF0gU3RhY2s6ClsgICAgMy44ODE0NDhdICAwMDAwMDMyNDExZTlm
ZjA4IGZmZmZmZmZmODVlNzk4ODggZmZmZjg4MDAwYzBmODAwMCBmZmZmODgwMDBjMGZmZGI4
ClsgICAgMy44ODE0NDhdICBmZmZmZmZmZjg1ODlhODA4IGZmZmY4ODAwMGMwZmZlMzAgZmZm
ZmZmZmY4NTg3ZTE4NiBmZmZmODgwMDBjMGZmZGU4ClsgICAgMy44ODE0NDhdICAwMDAwMDAw
MDAwMDAwMjg2IGZmZmY4ODAwMGMwZDcwMDAgZmZmZjg4MDAwYzBkNzA4YyAwMDAwMDAwMDBj
MGZmZTMwClsgICAgMy44ODE0NDhdIENhbGwgVHJhY2U6ClsgICAgMy44ODE0NDhdICBbPGZm
ZmZmZmZmODU4OWE4MDg+XSB2YWxpZGF0ZV9jcmVkc19mb3JfZG9fZXhpdCsweDIxLzB4MjMK
WyAgICAzLjg4MTQ0OF0gIFs8ZmZmZmZmZmY4NTg3ZTE4Nj5dIGRvX2V4aXQrMHhkNC8weDky
NwpbICAgIDMuODgxNDQ4XSAgWzxmZmZmZmZmZjg1OTFhMmRlPl0gPyBzbG9iX2ZyZWUrMHgy
NjQvMHgyNzEKWyAgICAzLjg4MTQ0OF0gIFs8ZmZmZmZmZmY4NWE3NDVlZD5dID8gY3J5cHRv
bWdyX25vdGlmeSsweDM2NS8weDM2NQpbICAgIDMuODgxNDQ4XSAgWzxmZmZmZmZmZjg1OGM1
ZjZiPl0gX19tb2R1bGVfcHV0X2FuZF9leGl0KzB4MTUvMHgxNQpbICAgIDMuODgxNDQ4XSAg
WzxmZmZmZmZmZjg1YTc0NjJiPl0gY3J5cHRvbWdyX3Rlc3QrMHgzZS8weDNlClsgICAgMy44
ODE0NDhdICBbPGZmZmZmZmZmODU4OTY0ZDQ+XSBrdGhyZWFkKzB4ZmUvMHgxMDYKWyAgICAz
Ljg4MTQ0OF0gIFs8ZmZmZmZmZmY4NTg5NjNkNj5dID8ga3RocmVhZF9jcmVhdGVfb25fbm9k
ZSsweDFiNC8weDFiNApbICAgIDMuODgxNDQ4XSAgWzxmZmZmZmZmZjg1YzhmOGZhPl0gcmV0
X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICAzLjg4MTQ0OF0gIFs8ZmZmZmZmZmY4NTg5NjNk
Nj5dID8ga3RocmVhZF9jcmVhdGVfb25fbm9kZSsweDFiNC8weDFiNApbICAgIDMuODgxNDQ4
XSBDb2RlOiAwNSAwMCAwMCA0OCAzYiBiYiA1OCAwNSAwMCAwMCA3NCAxMSA0OCA4OSBkYSA0
OCBjNyBjNiAwZCA5YSBlNyA4NSBlOCAwZCBmZSBmZiBmZiBlYiAwZSA0OCBjNyBjNyAxNyA5
YSBlNyA4NSAzMSBjMCBlOCAzZSBlMCAzZSAwMCA8MGY+IDBiIDgxIDc5IDEwIDY0IDY1IDcz
IDQzIDc1IDg2IDgxIDc4IDEwIDY0IDY1IDczIDQzIDBmIDg1IDc5IApbICAgIDMuODgxNDQ4
XSBSSVAgIFs8ZmZmZmZmZmY4NTg5OWYxND5dIF9fdmFsaWRhdGVfcHJvY2Vzc19jcmVkcysw
eGE5LzB4YzYKWyAgICAzLjg4MTQ0OF0gIFJTUCA8ZmZmZjg4MDAwYzBmZmQ5MD4KWyAgICAz
Ljk4MjYzN10gLS0tWyBlbmQgdHJhY2UgMzUyYjdhMzhiMDkzMDhmOCBdLS0tClsgICAgMy45
ODU5NTZdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS9iMzQxNmZiOGEyZjVhMTY1M2U0
YWI3MmI1NTkwNzc5NGNjMTBiZGUxL2RtZXNnLXF1YW50YWwtaXZiNDQtMTA2OjIwMTQwNjI5
MTEyMzIwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wNjI3MTIyNS9iMzQxNmZiOGEyZjVhMTY1M2U0YWI3MmI1NTkwNzc5
NGNjMTBiZGUxL2RtZXNnLXF1YW50YWwtaXZiNDQtMTEzOjIwMTQwNjI5MTEyMzIwOng4Nl82
NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNjI3MTIyNS9iMzQxNmZiOGEyZjVhMTY1M2U0YWI3MmI1NTkwNzc5NGNjMTBiZGUxL2Rt
ZXNnLXF1YW50YWwtbGtwLXdzeDAxLTEyMjoyMDE0MDYyOTExMjMxMTp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEy
MjUvYjM0MTZmYjhhMmY1YTE2NTNlNGFiNzJiNTU5MDc3OTRjYzEwYmRlMS9kbWVzZy1xdWFu
dGFsLWxrcC13c3gwMS0xNzk6MjAxNDA2MjkxMTIzMTE6eDg2XzY0LXJhbmRjb25maWctczEt
MDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2IzNDE2
ZmI4YTJmNWExNjUzZTRhYjcyYjU1OTA3Nzk0Y2MxMGJkZTEvZG1lc2ctcXVhbnRhbC1sa3At
d3N4MDEtMTg4OjIwMTQwNjI5MTEyMzExOng4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS9iMzQxNmZiOGEyZjVh
MTY1M2U0YWI3MmI1NTkwNzc5NGNjMTBiZGUxL2RtZXNnLXF1YW50YWwtbGtwLXdzeDAxLTE5
NzoyMDE0MDYyOTExMjMxNjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvYjM0MTZmYjhhMmY1YTE2NTNlNGFi
NzJiNTU5MDc3OTRjYzEwYmRlMS9kbWVzZy1xdWFudGFsLWxrcC13c3gwMS0yMDE6MjAxNDA2
MjkxMTIzMTE6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2IzNDE2ZmI4YTJmNWExNjUzZTRhYjcyYjU1OTA3
Nzk0Y2MxMGJkZTEvZG1lc2ctcXVhbnRhbC1sa3Atd3N4MDEtMjI0OjIwMTQwNjI5MTEyMzEx
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNjI3MTIyNS9iMzQxNmZiOGEyZjVhMTY1M2U0YWI3MmI1NTkwNzc5NGNjMTBi
ZGUxL2RtZXNnLXF1YW50YWwtbGtwLXdzeDAxLTU2OjIwMTQwNjI5MTEyMzExOng4Nl82NC1y
YW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
NjI3MTIyNS9iMzQxNmZiOGEyZjVhMTY1M2U0YWI3MmI1NTkwNzc5NGNjMTBiZGUxL2RtZXNn
LXF1YW50YWwtbGtwLXdzeDAxLTY0OjIwMTQwNjI5MTEyMzExOng4Nl82NC1yYW5kY29uZmln
LXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS9i
MzQxNmZiOGEyZjVhMTY1M2U0YWI3MmI1NTkwNzc5NGNjMTBiZGUxL2RtZXNnLXlvY3RvLWl2
YjQxLTEwMzoyMDE0MDYyOTExMjMxMTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvYjM0MTZmYjhhMmY1YTE2
NTNlNGFiNzJiNTU5MDc3OTRjYzEwYmRlMS9kbWVzZy15b2N0by1pdmI0MS05NzoyMDE0MDYy
OTExMjMxMzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDYyNzEyMjUvYjM0MTZmYjhhMmY1YTE2NTNlNGFiNzJiNTU5MDc3
OTRjYzEwYmRlMS9kbWVzZy15b2N0by1pdmI0NC0xMDM6MjAxNDA2MjkxMTIzMjA6eDg2XzY0
LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA2MjcxMjI1L2IzNDE2ZmI4YTJmNWExNjUzZTRhYjcyYjU1OTA3Nzk0Y2MxMGJkZTEvZG1l
c2cteW9jdG8taXZiNDQtMzc6MjAxNDA2MjkxMTIzMjA6eDg2XzY0LXJhbmRjb25maWctczEt
MDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2IzNDE2
ZmI4YTJmNWExNjUzZTRhYjcyYjU1OTA3Nzk0Y2MxMGJkZTEvZG1lc2cteW9jdG8taXZiNDQt
NDI6MjAxNDA2MjkxMTIzMjA6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2IzNDE2ZmI4YTJmNWExNjUzZTRh
YjcyYjU1OTA3Nzk0Y2MxMGJkZTEvZG1lc2cteW9jdG8taXZiNDQtNDM6MjAxNDA2MjkxMTIz
MjA6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA2MjcxMjI1L2IzNDE2ZmI4YTJmNWExNjUzZTRhYjcyYjU1OTA3Nzk0Y2Mx
MGJkZTEvZG1lc2cteW9jdG8taXZiNDQtNTE6MjAxNDA2MjkxMTIzMjA6eDg2XzY0LXJhbmRj
b25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2Mjcx
MjI1L2IzNDE2ZmI4YTJmNWExNjUzZTRhYjcyYjU1OTA3Nzk0Y2MxMGJkZTEvZG1lc2cteW9j
dG8taXZiNDQtODM6MjAxNDA2MjkxMTIzMjA6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEy
MjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2IzNDE2ZmI4YTJm
NWExNjUzZTRhYjcyYjU1OTA3Nzk0Y2MxMGJkZTEvZG1lc2cteW9jdG8tbGtwLXdzeDAxLTE2
MToyMDE0MDYyOTExMjMwNjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6CjA6MTk6
MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogOSByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzMzMzJlZTJhMTdi
MWJkNjllNDYwMmUyZDZiYTFiMDdlZGIwYzlhMjRdIGNyeXB0bzogZHJiZyAtIERSQkcgdGVz
dG1nciB0ZXN0IHZlY3RvcnMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3
MTIyNS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2MjYyMzozMzMyZWUyYTE3YjFi
ZDY5ZTQ2MDJlMmQ2YmExYjA3ZWRiMGM5YTI0OmJpc2VjdC1saW51eDAKCjIwMTQtMDYtMjkt
MTE6MjY6MDYgMzMzMmVlMmExN2IxYmQ2OWU0NjAyZTJkNmJhMWIwN2VkYjBjOWEyNCBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS0zMzMyZWUyYTE3YjFiZDY5ZTQ2MDJlMmQ2
YmExYjA3ZWRiMGM5YTI0CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wNjI3MTIyNS8zMzMyZWUyYTE3YjFiZDY5ZTQ2MDJlMmQ2YmExYjA3ZWRi
MGM5YTI0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS0zMzMyZWUyYTE3YjFiZDY5ZTQ2
MDJlMmQ2YmExYjA3ZWRiMGM5YTI0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWctczEtMDYy
NzEyMjUtMzMzMmVlMmExN2IxYmQ2OWU0NjAyZTJkNmJhMWIwN2VkYjBjOWEyNAprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvMzMzMmVlMmExN2IxYmQ2
OWU0NjAyZTJkNmJhMWIwN2VkYjBjOWEyNC92bWxpbnV6LTMuMTYuMC1yYzEtMDAwMTAtZzMz
MzJlZTIKCjIwMTQtMDYtMjktMTE6Mjk6MDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMS4u
Li4uCTE0Li4JMjEgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbZDhjYmEyNWQyYzY4OTkyYTZlN2Mx
ZDMyOWI2OTBhOWViZTAxMTY3ZF0gY3J5cHRvOiBxYXQgLSBJbnRlbChSKSBRQVQgZHJpdmVy
IGZyYW1ld29yawpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYyNjIzOmQ4Y2JhMjVkMmM2ODk5MmE2ZTdj
MWQzMjliNjkwYTllYmUwMTE2N2Q6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNi0yOS0xMTozNTow
NyBkOGNiYTI1ZDJjNjg5OTJhNmU3YzFkMzI5YjY5MGE5ZWJlMDExNjdkIGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA2MjcxMjI1LWQ4Y2JhMjVkMmM2ODk5MmE2ZTdjMWQzMjliNjkwYTll
YmUwMTE2N2QKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA2MjcxMjI1L2Q4Y2JhMjVkMmM2ODk5MmE2ZTdjMWQzMjliNjkwYTllYmUwMTE2N2QK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LWQ4Y2JhMjVkMmM2ODk5MmE2ZTdjMWQzMjli
NjkwYTllYmUwMTE2N2QKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2
MjcxMjI1L2Q4Y2JhMjVkMmM2ODk5MmE2ZTdjMWQzMjliNjkwYTllYmUwMTE2N2Qvdm1saW51
ei0zLjE2LjAtcmMxLTAwMDE1LWdkOGNiYTI1CgoyMDE0LTA2LTI5LTExOjM3OjA3IGRldGVj
dGluZyBib290IHN0YXRlIC4uLgkxIFRFU1QgRkFJTFVSRQpbICAgIDEuNDkzNTU0XSBDUkVE
OiAtPipnaWQgPSB7IDAsMCwwLDAgfQpbICAgIDEuNDkzOTY3XSBDUkVEOiBFZmZlY3RpdmUg
Y3JlZHMgPT0gUmVhbCBjcmVkcwpbICAgIDEuNDk0NDc1XSAtLS0tLS0tLS0tLS1bIGN1dCBo
ZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAxLjQ5NDk3OV0ga2VybmVsIEJVRyBhdCAva2J1aWxk
L3NyYy9zbW9rZS9rZXJuZWwvY3JlZC5jOjc5MCEKWyAgICAxLjQ5NTYxOF0gaW52YWxpZCBv
cGNvZGU6IDAwMDAgWyMxXSAKWyAgICAxLjQ5NjA0OV0gTW9kdWxlcyBsaW5rZWQgaW46Clsg
ICAgMS40OTY0MDddIENQVTogMCBQSUQ6IDc3IENvbW06IGNyeXB0b21ncl90ZXN0IE5vdCB0
YWludGVkIDMuMTYuMC1yYzEtMDAwMTUtZ2Q4Y2JhMjUgIzEKWyAgICAxLjQ5NzI3OV0gSGFy
ZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJ
T1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDEuNDk4MTU3XSB0YXNrOiBmZmZmODgwMDBjMTFl
MDAwIHRpOiBmZmZmODgwMDBjMTIwMDAwIHRhc2sudGk6IGZmZmY4ODAwMGMxMjAwMDAKWyAg
ICAxLjQ5ODk2N10gUklQOiAwMDEwOls8ZmZmZmZmZmY4ODI5OWYxND5dICBbPGZmZmZmZmZm
ODgyOTlmMTQ+XSBfX3ZhbGlkYXRlX3Byb2Nlc3NfY3JlZHMrMHhhOS8weGM2ClsgICAgMS40
OTk5NjVdIFJTUDogMDAwMDpmZmZmODgwMDBjMTIzZDkwICBFRkxBR1M6IDAwMDEwMjk2Clsg
ICAgMS41MDAwMDhdIFJBWDogMDAwMDAwMDAwMDAwMDAyMyBSQlg6IGZmZmY4ODAwMGMxMWUw
MDAgUkNYOiBmZmZmODgwMDBjMTFlN2MwClsgICAgMS41MDAwMDhdIFJEWDogMDAwMDAwMDAw
MDAwMDFjNCBSU0k6IDAwMDAwMDAwMDAwMDAwMDEgUkRJOiAwMDAwMDAwMDAwMDAwMjQ2Clsg
ICAgMS41MDAwMDhdIFJCUDogZmZmZjg4MDAwYzEyM2RhOCBSMDg6IDAwMDAwMDAwMDAwMDAw
MDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS41MDAwMDhdIFIxMDogMDAwMDAwMDAw
MDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiAwMDAwMDAwMDAwMDAwMDAwClsg
ICAgMS41MDAwMDhdIFIxMzogZmZmZmZmZmY4ODQ3NDVlZCBSMTQ6IDAwMDAwMDAwMDAwMDAw
MDAgUjE1OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS41MDAwMDhdIEZTOiAgMDAwMDAwMDAw
MDAwMDAwMCgwMDAwKSBHUzpmZmZmZmZmZjg4OTQwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAw
MDAwMDAwMDAKWyAgICAxLjUwMDAwOF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENS
MDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDEuNTAwMDA4XSBDUjI6IDAwMDAwMDAwMDAwMDAw
MDAgQ1IzOiAwMDAwMDAwMDA4OTMwMDAwIENSNDogMDAwMDAwMDAwMDAwMDZmMApbICAgIDEu
NTAwMDA4XSBTdGFjazoKWyAgICAxLjUwMDAwOF0gIDAwMDAwMzI0MTFlYTAyNTAgZmZmZmZm
ZmY4ODg3OTg4OCBmZmZmODgwMDBjMTFlMDAwIGZmZmY4ODAwMGMxMjNkYjgKWyAgICAxLjUw
MDAwOF0gIGZmZmZmZmZmODgyOWE4MDggZmZmZjg4MDAwYzEyM2UzMCBmZmZmZmZmZjg4Mjdl
MTg2IGZmZmY4ODAwMGMxMjNkZTgKWyAgICAxLjUwMDAwOF0gIDAwMDAwMDAwMDAwMDAyODYg
ZmZmZjg4MDAwYzBlNjAwMCBmZmZmODgwMDBjMGU2MDhjIDAwMDAwMDAwMGMxMjNlMzAKWyAg
ICAxLjUwMDAwOF0gQ2FsbCBUcmFjZToKWyAgICAxLjUwMDAwOF0gIFs8ZmZmZmZmZmY4ODI5
YTgwOD5dIHZhbGlkYXRlX2NyZWRzX2Zvcl9kb19leGl0KzB4MjEvMHgyMwpbICAgIDEuNTAw
MDA4XSAgWzxmZmZmZmZmZjg4MjdlMTg2Pl0gZG9fZXhpdCsweGQ0LzB4OTI3ClsgICAgMS41
MDAwMDhdICBbPGZmZmZmZmZmODgzMWEyZGU+XSA/IHNsb2JfZnJlZSsweDI2NC8weDI3MQpb
ICAgIDEuNTAwMDA4XSAgWzxmZmZmZmZmZjg4NDc0NWVkPl0gPyBjcnlwdG9tZ3Jfbm90aWZ5
KzB4MzY1LzB4MzY1ClsgICAgMS41MDAwMDhdICBbPGZmZmZmZmZmODgyYzVmNmI+XSBfX21v
ZHVsZV9wdXRfYW5kX2V4aXQrMHgxNS8weDE1ClsgICAgMS41MDAwMDhdICBbPGZmZmZmZmZm
ODg0NzQ2MmI+XSBjcnlwdG9tZ3JfdGVzdCsweDNlLzB4M2UKWyAgICAxLjUwMDAwOF0gIFs8
ZmZmZmZmZmY4ODI5NjRkND5dIGt0aHJlYWQrMHhmZS8weDEwNgpbICAgIDEuNTAwMDA4XSAg
WzxmZmZmZmZmZjg4Mjk2M2Q2Pl0gPyBrdGhyZWFkX2NyZWF0ZV9vbl9ub2RlKzB4MWI0LzB4
MWI0ClsgICAgMS41MDAwMDhdICBbPGZmZmZmZmZmODg2OGY4ZmE+XSByZXRfZnJvbV9mb3Jr
KzB4N2EvMHhiMApbICAgIDEuNTAwMDA4XSAgWzxmZmZmZmZmZjg4Mjk2M2Q2Pl0gPyBrdGhy
ZWFkX2NyZWF0ZV9vbl9ub2RlKzB4MWI0LzB4MWI0ClsgICAgMS41MDAwMDhdIENvZGU6IDA1
IDAwIDAwIDQ4IDNiIGJiIDU4IDA1IDAwIDAwIDc0IDExIDQ4IDg5IGRhIDQ4IGM3IGM2IDBk
IDlhIDg3IDg4IGU4IDBkIGZlIGZmIGZmIGViIDBlIDQ4IGM3IGM3IDE3IDlhIDg3IDg4IDMx
IGMwIGU4IDNlIGUwIDNlIDAwIDwwZj4gMGIgODEgNzkgMTAgNjQgNjUgNzMgNDMgNzUgODYg
ODEgNzggMTAgNjQgNjUgNzMgNDMgMGYgODUgNzkgClsgICAgMS41MDAwMDhdIFJJUCAgWzxm
ZmZmZmZmZjg4Mjk5ZjE0Pl0gX192YWxpZGF0ZV9wcm9jZXNzX2NyZWRzKzB4YTkvMHhjNgpb
ICAgIDEuNTAwMDA4XSAgUlNQIDxmZmZmODgwMDBjMTIzZDkwPgpbICAgIDEuNTIwNDE1XSAt
LS1bIGVuZCB0cmFjZSAzY2VjY2RhYWVlNTdhMmEwIF0tLS0KWyAgICAxLjUyMDkyNl0gS2Vy
bmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L2Q4Y2JhMjVkMmM2ODk5MmE2ZTdjMWQzMjliNjkw
YTllYmUwMTE2N2QvZG1lc2ctcXVhbnRhbC1pdmI0NC0yNDoyMDE0MDYyOTExMzcxODp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDYyNzEyMjUvZDhjYmEyNWQyYzY4OTkyYTZlN2MxZDMyOWI2OTBhOWViZTAxMTY3ZC9k
bWVzZy1xdWFudGFsLWl2YjQ0LTM3OjIwMTQwNjI5MTEzNzE3Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS9k
OGNiYTI1ZDJjNjg5OTJhNmU3YzFkMzI5YjY5MGE5ZWJlMDExNjdkL2RtZXNnLXF1YW50YWwt
bGtwLXdzeDAxLTExNjoyMDE0MDYyOTExMzcyMDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3
MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvZDhjYmEyNWQy
YzY4OTkyYTZlN2MxZDMyOWI2OTBhOWViZTAxMTY3ZC9kbWVzZy1xdWFudGFsLWxrcC13c3gw
MS0xMTg6MjAxNDA2MjkxMTM3MjI6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogow
OjQ6NCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAyIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApClszZDc3NTY1YmE1
ZTViOTA3NWE0ZjZkN2Q2ZDE1OTk2ZjVlNTgyNjU5XSBjcnlwdG86IGNjcCAtIE1vZGlmeSBQ
Q0kgc3VwcG9ydCBpbiBwcmVwIGZvciBhcm02NCBzdXBwb3J0CnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eDAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctczEtMDYyNzEyMjUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQw
NjI2MjM6M2Q3NzU2NWJhNWU1YjkwNzVhNGY2ZDdkNmQxNTk5NmY1ZTU4MjY1OTpiaXNlY3Qt
bGludXgwCgoyMDE0LTA2LTI5LTExOjM5OjA5IDNkNzc1NjViYTVlNWI5MDc1YTRmNmQ3ZDZk
MTU5OTZmNWU1ODI2NTkgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUtM2Q3NzU2
NWJhNWU1YjkwNzVhNGY2ZDdkNmQxNTk5NmY1ZTU4MjY1OQpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvM2Q3NzU2NWJhNWU1Yjkw
NzVhNGY2ZDdkNmQxNTk5NmY1ZTU4MjY1OQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUt
M2Q3NzU2NWJhNWU1YjkwNzVhNGY2ZDdkNmQxNTk5NmY1ZTU4MjY1OQp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iLXNtb2tlL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LTNkNzc1NjViYTVlNWI5MDc1YTRmNmQ3ZDZkMTU5
OTZmNWU1ODI2NTkKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2Mjcx
MjI1LzNkNzc1NjViYTVlNWI5MDc1YTRmNmQ3ZDZkMTU5OTZmNWU1ODI2NTkvdm1saW51ei0z
LjE2LjAtcmMxLTAwMDEyLWczZDc3NTY1CgoyMDE0LTA2LTI5LTExOjQyOjA5IGRldGVjdGlu
ZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgMS44NTM0OThdIENSRUQ6IC0+Kmdp
ZCA9IHsgMCwwLDAsMCB9ClsgICAgMS44NTQyOTNdIENSRUQ6IEVmZmVjdGl2ZSBjcmVkcyA9
PSBSZWFsIGNyZWRzClsgICAgMS44NTUyMThdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0t
LS0tLS0tLS0tLQpbICAgIDEuODU2MTIwXSBrZXJuZWwgQlVHIGF0IC9rYnVpbGQvc3JjL3Nt
b2tlL2tlcm5lbC9jcmVkLmM6NzkwIQpbICAgIDEuODU3MjY1XSBpbnZhbGlkIG9wY29kZTog
MDAwMCBbIzFdIApbICAgIDEuODU4MDE5XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjg1
ODY0Nl0gQ1BVOiAwIFBJRDogNzcgQ29tbTogY3J5cHRvbWdyX3Rlc3QgTm90IHRhaW50ZWQg
My4xNi4wLXJjMS0wMDAxMi1nM2Q3NzU2NSAjMQpbICAgIDEuODYwMDgyXSBIYXJkd2FyZSBu
YW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBCb2No
cyAwMS8wMS8yMDExClsgICAgMS44NjA4MjldIHRhc2s6IGZmZmY4ODAwMGMxMWEwMDAgdGk6
IGZmZmY4ODAwMGMxMDgwMDAgdGFzay50aTogZmZmZjg4MDAwYzEwODAwMApbICAgIDEuODYw
ODI5XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjg4ODk5ZjE0Pl0gIFs8ZmZmZmZmZmY4ODg5OWYx
ND5dIF9fdmFsaWRhdGVfcHJvY2Vzc19jcmVkcysweGE5LzB4YzYKWyAgICAxLjg2MDgyOV0g
UlNQOiAwMDAwOmZmZmY4ODAwMGMxMGJkOTAgIEVGTEFHUzogMDAwMTAyOTYKWyAgICAxLjg2
MDgyOV0gUkFYOiAwMDAwMDAwMDAwMDAwMDIzIFJCWDogZmZmZjg4MDAwYzExYTAwMCBSQ1g6
IGZmZmY4ODAwMGMxMWE3YzAKWyAgICAxLjg2MDgyOV0gUkRYOiAwMDAwMDAwMDAwMDAwMWM0
IFJTSTogMDAwMDAwMDAwMDAwMDAwMSBSREk6IDAwMDAwMDAwMDAwMDAyNDYKWyAgICAxLjg2
MDgyOV0gUkJQOiBmZmZmODgwMDBjMTBiZGE4IFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6
IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjg2MDgyOV0gUjEwOiAwMDAwMDAwMDAwMDAwMDAw
IFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjg2
MDgyOV0gUjEzOiBmZmZmZmZmZjg4YTc0NWVkIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6
IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjg2MDgyOV0gRlM6ICAwMDAwMDAwMDAwMDAwMDAw
KDAwMDApIEdTOmZmZmZmZmZmODhmNDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAw
MApbICAgIDEuODYwODI5XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAw
MDAwMDgwMDUwMDNiClsgICAgMS44NjA4MjldIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6
IDAwMDAwMDAwMDhmMzAwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmYwClsgICAgMS44NjA4Mjld
IFN0YWNrOgpbICAgIDEuODYwODI5XSAgMDAwMDAzMjQxMWVhMDJjMCBmZmZmZmZmZjg4ZTc5
ODg4IGZmZmY4ODAwMGMxMWEwMDAgZmZmZjg4MDAwYzEwYmRiOApbICAgIDEuODYwODI5XSAg
ZmZmZmZmZmY4ODg5YTgwOCBmZmZmODgwMDBjMTBiZTMwIGZmZmZmZmZmODg4N2UxODYgZmZm
Zjg4MDAwYzEwYmRlOApbICAgIDEuODYwODI5XSAgMDAwMDAwMDAwMDAwMDI4NiBmZmZmODgw
MDBjMGU4MDAwIGZmZmY4ODAwMGMwZTgwOGMgMDAwMDAwMDAwYzEwYmUzMApbICAgIDEuODYw
ODI5XSBDYWxsIFRyYWNlOgpbICAgIDEuODYwODI5XSAgWzxmZmZmZmZmZjg4ODlhODA4Pl0g
dmFsaWRhdGVfY3JlZHNfZm9yX2RvX2V4aXQrMHgyMS8weDIzClsgICAgMS44NjA4MjldICBb
PGZmZmZmZmZmODg4N2UxODY+XSBkb19leGl0KzB4ZDQvMHg5MjcKWyAgICAxLjg2MDgyOV0g
IFs8ZmZmZmZmZmY4ODkxYTJkZT5dID8gc2xvYl9mcmVlKzB4MjY0LzB4MjcxClsgICAgMS44
NjA4MjldICBbPGZmZmZmZmZmODhhNzQ1ZWQ+XSA/IGNyeXB0b21ncl9ub3RpZnkrMHgzNjUv
MHgzNjUKWyAgICAxLjg2MDgyOV0gIFs8ZmZmZmZmZmY4ODhjNWY2Yj5dIF9fbW9kdWxlX3B1
dF9hbmRfZXhpdCsweDE1LzB4MTUKWyAgICAxLjg2MDgyOV0gIFs8ZmZmZmZmZmY4OGE3NDYy
Yj5dIGNyeXB0b21ncl90ZXN0KzB4M2UvMHgzZQpbICAgIDEuODYwODI5XSAgWzxmZmZmZmZm
Zjg4ODk2NGQ0Pl0ga3RocmVhZCsweGZlLzB4MTA2ClsgICAgMS44NjA4MjldICBbPGZmZmZm
ZmZmODg4OTYzZDY+XSA/IGt0aHJlYWRfY3JlYXRlX29uX25vZGUrMHgxYjQvMHgxYjQKWyAg
ICAxLjg2MDgyOV0gIFs8ZmZmZmZmZmY4OGM4ZjhmYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8w
eGIwClsgICAgMS44NjA4MjldICBbPGZmZmZmZmZmODg4OTYzZDY+XSA/IGt0aHJlYWRfY3Jl
YXRlX29uX25vZGUrMHgxYjQvMHgxYjQKWyAgICAxLjg2MDgyOV0gQ29kZTogMDUgMDAgMDAg
NDggM2IgYmIgNTggMDUgMDAgMDAgNzQgMTEgNDggODkgZGEgNDggYzcgYzYgMGQgOWEgZTcg
ODggZTggMGQgZmUgZmYgZmYgZWIgMGUgNDggYzcgYzcgMTcgOWEgZTcgODggMzEgYzAgZTgg
M2UgZTAgM2UgMDAgPDBmPiAwYiA4MSA3OSAxMCA2NCA2NSA3MyA0MyA3NSA4NiA4MSA3OCAx
MCA2NCA2NSA3MyA0MyAwZiA4NSA3OSAKWyAgICAxLjg2MDgyOV0gUklQICBbPGZmZmZmZmZm
ODg4OTlmMTQ+XSBfX3ZhbGlkYXRlX3Byb2Nlc3NfY3JlZHMrMHhhOS8weGM2ClsgICAgMS44
NjA4MjldICBSU1AgPGZmZmY4ODAwMGMxMGJkOTA+ClsgICAgMS44OTg4NDNdIC0tLVsgZW5k
IHRyYWNlIGIxY2RiZjJjYmM2MTQ3NWEgXS0tLQpbICAgIDEuODk5ODE2XSBLZXJuZWwgcGFu
aWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDYyNzEyMjUvM2Q3NzU2NWJhNWU1YjkwNzVhNGY2ZDdkNmQxNTk5NmY1ZTU4
MjY1OS9kbWVzZy1xdWFudGFsLWl2YjQxLTEwMToyMDE0MDYyOTExNDE1OTp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYy
NzEyMjUvM2Q3NzU2NWJhNWU1YjkwNzVhNGY2ZDdkNmQxNTk5NmY1ZTU4MjY1OS9kbWVzZy1x
dWFudGFsLWl2YjQxLTEzOjIwMTQwNjI5MTE0MTU5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2
MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS8zZDc3NTY1
YmE1ZTViOTA3NWE0ZjZkN2Q2ZDE1OTk2ZjVlNTgyNjU5L2RtZXNnLXF1YW50YWwtaXZiNDIt
NTA6MjAxNDA2MjkxMTQxNTk6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzNkNzc1NjViYTVlNWI5MDc1YTRm
NmQ3ZDZkMTU5OTZmNWU1ODI2NTkvZG1lc2ctcXVhbnRhbC1sa3Atd3N4MDEtMTMyOjIwMTQw
NjI5MTE0MTU2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS8zZDc3NTY1YmE1ZTViOTA3NWE0ZjZkN2Q2ZDE1
OTk2ZjVlNTgyNjU5L2RtZXNnLXF1YW50YWwtbGtwLXdzeDAxLTQ6MjAxNDA2MjkxMTQxNTc6
eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA2MjcxMjI1LzNkNzc1NjViYTVlNWI5MDc1YTRmNmQ3ZDZkMTU5OTZmNWU1ODI2
NTkvZG1lc2cteW9jdG8taXZiNDItMTI6MjAxNDA2MjkxMTQxNTE6eDg2XzY0LXJhbmRjb25m
aWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1
LzNkNzc1NjViYTVlNWI5MDc1YTRmNmQ3ZDZkMTU5OTZmNWU1ODI2NTkvZG1lc2cteW9jdG8t
aXZiNDItMjc6MjAxNDA2MjkxMTQxNTk6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzNkNzc1NjViYTVlNWI5
MDc1YTRmNmQ3ZDZkMTU5OTZmNWU1ODI2NTkvZG1lc2cteW9jdG8taXZiNDItMzI6MjAxNDA2
MjkxMTQxNTk6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzNkNzc1NjViYTVlNWI5MDc1YTRmNmQ3ZDZkMTU5
OTZmNWU1ODI2NTkvZG1lc2cteW9jdG8taXZiNDItODoyMDE0MDYyOTExNDE1OTp4ODZfNjQt
cmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEt
MDYyNzEyMjUvM2Q3NzU2NWJhNWU1YjkwNzVhNGY2ZDdkNmQxNTk5NmY1ZTU4MjY1OS9kbWVz
Zy15b2N0by1sa3Atd3N4MDEtNjc6MjAxNDA2MjkxMTQxNTI6eDg2XzY0LXJhbmRjb25maWct
czEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzNk
Nzc1NjViYTVlNWI5MDc1YTRmNmQ3ZDZkMTU5OTZmNWU1ODI2NTkvZG1lc2ctcXVhbnRhbC1p
dmI0MS0xMDI6MjAxNDA2MjkxMTQyMDE6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzNkNzc1NjViYTVlNWI5
MDc1YTRmNmQ3ZDZkMTU5OTZmNWU1ODI2NTkvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDM6MjAx
NDA2MjkxMTQyMDE6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzNkNzc1NjViYTVlNWI5MDc1YTRmNmQ3ZDZk
MTU5OTZmNWU1ODI2NTkvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDQ6MjAxNDA2MjkxMTQyMDU6
eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA2MjcxMjI1LzNkNzc1NjViYTVlNWI5MDc1YTRmNmQ3ZDZkMTU5OTZmNWU1ODI2
NTkvZG1lc2ctcXVhbnRhbC1sa3Atd3N4MDEtMTYyOjIwMTQwNjI5MTE0MjAyOng4Nl82NC1y
YW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
NjI3MTIyNS8zZDc3NTY1YmE1ZTViOTA3NWE0ZjZkN2Q2ZDE1OTk2ZjVlNTgyNjU5L2RtZXNn
LXF1YW50YWwtbGtwLXdzeDAxLTIxNzoyMDE0MDYyOTExNDIwMTp4ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUv
M2Q3NzU2NWJhNWU1YjkwNzVhNGY2ZDdkNmQxNTk5NmY1ZTU4MjY1OS9kbWVzZy1xdWFudGFs
LWxrcC13c3gwMS0yNDoyMDE0MDYyOTExNDIwMDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3
MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvM2Q3NzU2NWJh
NWU1YjkwNzVhNGY2ZDdkNmQxNTk5NmY1ZTU4MjY1OS9kbWVzZy1xdWFudGFsLWxrcC13c3gw
MS03MzoyMDE0MDYyOTExNDIwMzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvM2Q3NzU2NWJhNWU1YjkwNzVh
NGY2ZDdkNmQxNTk5NmY1ZTU4MjY1OS9kbWVzZy1xdWFudGFsLWxrcC13c3gwMS04MzoyMDE0
MDYyOTExNDIwMjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvM2Q3NzU2NWJhNWU1YjkwNzVhNGY2ZDdkNmQx
NTk5NmY1ZTU4MjY1OS9kbWVzZy1xdWFudGFsLWxrcC13c3gwMS05MzoyMDE0MDYyOTExNDIw
Mzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDYyNzEyMjUvM2Q3NzU2NWJhNWU1YjkwNzVhNGY2ZDdkNmQxNTk5NmY1ZTU4
MjY1OS9kbWVzZy15b2N0by1pdmI0Mi0yOToyMDE0MDYyOTExNDIwOTp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEy
MjUvM2Q3NzU2NWJhNWU1YjkwNzVhNGY2ZDdkNmQxNTk5NmY1ZTU4MjY1OS9kbWVzZy15b2N0
by1pdmI0Mi03MjoyMDE0MDYyOTExNDIwOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIy
NTo6CjA6MjE6MjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMCBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKWzY0
ZDFjZGZiZTIwYzUwODc3NTc2MDQ1MTQ1MzEzYzliMDYyYzUwZjddIGNyeXB0bzogZHJiZyAt
IEFkZCBEUkJHIHRlc3QgY29kZSB0byB0ZXN0bWdyCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDAvb2Jq
LWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctczEtMDYyNzEyMjUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNjI2MjM6
NjRkMWNkZmJlMjBjNTA4Nzc1NzYwNDUxNDUzMTNjOWIwNjJjNTBmNzpiaXNlY3QtbGludXgw
CgoyMDE0LTA2LTI5LTExOjQyOjQxIDY0ZDFjZGZiZTIwYzUwODc3NTc2MDQ1MTQ1MzEzYzli
MDYyYzUwZjcgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUtNjRkMWNkZmJlMjBj
NTA4Nzc1NzYwNDUxNDUzMTNjOWIwNjJjNTBmNwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvNjRkMWNkZmJlMjBjNTA4Nzc1NzYw
NDUxNDUzMTNjOWIwNjJjNTBmNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUtNjRkMWNk
ZmJlMjBjNTA4Nzc1NzYwNDUxNDUzMTNjOWIwNjJjNTBmNwp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iLXNtb2tlL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA2MjcxMjI1LTY0ZDFjZGZiZTIwYzUwODc3NTc2MDQ1MTQ1MzEzYzliMDYy
YzUwZjcKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzY0
ZDFjZGZiZTIwYzUwODc3NTc2MDQ1MTQ1MzEzYzliMDYyYzUwZjcvdm1saW51ei0zLjE2LjAt
cmMxLTAwMDExLWc2NGQxY2RmCgoyMDE0LTA2LTI5LTExOjQ3OjQxIGRldGVjdGluZyBib290
IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgMS44ODUyNzZdIENSRUQ6IC0+KmdpZCA9IHsg
MCwwLDAsMCB9ClsgICAgMS44ODYwMjBdIENSRUQ6IEVmZmVjdGl2ZSBjcmVkcyA9PSBSZWFs
IGNyZWRzClsgICAgMS44ODY5MTJdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0t
LS0tLQpbICAgIDEuODg3ODA2XSBrZXJuZWwgQlVHIGF0IC9rYnVpbGQvc3JjL3Ntb2tlL2tl
cm5lbC9jcmVkLmM6NzkwIQpbICAgIDEuODg4OTQ3XSBpbnZhbGlkIG9wY29kZTogMDAwMCBb
IzFdIApbICAgIDEuODg5NzI2XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjg5MDA5Nl0g
Q1BVOiAwIFBJRDogNzcgQ29tbTogY3J5cHRvbWdyX3Rlc3QgTm90IHRhaW50ZWQgMy4xNi4w
LXJjMS0wMDAxMS1nNjRkMWNkZiAjMQpbICAgIDEuODkwMDk2XSBIYXJkd2FyZSBuYW1lOiBR
RU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8w
MS8yMDExClsgICAgMS44OTAwOTZdIHRhc2s6IGZmZmY4ODAwMGMwZTIwMDAgdGk6IGZmZmY4
ODAwMGMxMWMwMDAgdGFzay50aTogZmZmZjg4MDAwYzExYzAwMApbICAgIDEuODkwMDk2XSBS
SVA6IDAwMTA6WzxmZmZmZmZmZjhhYTk5ZjE0Pl0gIFs8ZmZmZmZmZmY4YWE5OWYxND5dIF9f
dmFsaWRhdGVfcHJvY2Vzc19jcmVkcysweGE5LzB4YzYKWyAgICAxLjg5MDA5Nl0gUlNQOiAw
MDAwOmZmZmY4ODAwMGMxMWZkOTAgIEVGTEFHUzogMDAwMTAyOTYKWyAgICAxLjg5MDA5Nl0g
UkFYOiAwMDAwMDAwMDAwMDAwMDIzIFJCWDogZmZmZjg4MDAwYzBlMjAwMCBSQ1g6IGZmZmY4
ODAwMGMwZTI3YzAKWyAgICAxLjg5MDA5Nl0gUkRYOiAwMDAwMDAwMDAwMDAwMWM0IFJTSTog
MDAwMDAwMDAwMDAwMDAwMSBSREk6IDAwMDAwMDAwMDAwMDAyNDYKWyAgICAxLjg5MDA5Nl0g
UkJQOiBmZmZmODgwMDBjMTFmZGE4IFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgICAxLjg5MDA5Nl0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTog
MDAwMDAwMDAwMDAwMDAwMCBSMTI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjg5MDA5Nl0g
UjEzOiBmZmZmZmZmZjhhYzc0NWVkIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgICAxLjg5MDA5Nl0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDAp
IEdTOmZmZmZmZmZmOGIxNDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAg
IDEuODkwMDk2XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgw
MDUwMDNiClsgICAgMS44OTAwOTZdIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAw
MDAwMGIxMzAwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmYwClsgICAgMS44OTAwOTZdIFN0YWNr
OgpbICAgIDEuODkwMDk2XSAgMDAwMDAzMjQxMWVhMDEwMCBmZmZmZmZmZjhiMDc5ODg4IGZm
ZmY4ODAwMGMwZTIwMDAgZmZmZjg4MDAwYzExZmRiOApbICAgIDEuODkwMDk2XSAgZmZmZmZm
ZmY4YWE5YTgwOCBmZmZmODgwMDBjMTFmZTMwIGZmZmZmZmZmOGFhN2UxODYgZmZmZjg4MDAw
YzExZmRlOApbICAgIDEuODkwMDk2XSAgMDAwMDAwMDAwMDAwMDI4NiBmZmZmODgwMDBjMGUw
MDAwIGZmZmY4ODAwMGMwZTAwOGMgMDAwMDAwMDAwYzExZmUzMApbICAgIDEuODkwMDk2XSBD
YWxsIFRyYWNlOgpbICAgIDEuODkwMDk2XSAgWzxmZmZmZmZmZjhhYTlhODA4Pl0gdmFsaWRh
dGVfY3JlZHNfZm9yX2RvX2V4aXQrMHgyMS8weDIzClsgICAgMS44OTAwOTZdICBbPGZmZmZm
ZmZmOGFhN2UxODY+XSBkb19leGl0KzB4ZDQvMHg5MjcKWyAgICAxLjg5MDA5Nl0gIFs8ZmZm
ZmZmZmY4YWIxYTJkZT5dID8gc2xvYl9mcmVlKzB4MjY0LzB4MjcxClsgICAgMS44OTAwOTZd
ICBbPGZmZmZmZmZmOGFjNzQ1ZWQ+XSA/IGNyeXB0b21ncl9ub3RpZnkrMHgzNjUvMHgzNjUK
WyAgICAxLjg5MDA5Nl0gIFs8ZmZmZmZmZmY4YWFjNWY2Yj5dIF9fbW9kdWxlX3B1dF9hbmRf
ZXhpdCsweDE1LzB4MTUKWyAgICAxLjg5MDA5Nl0gIFs8ZmZmZmZmZmY4YWM3NDYyYj5dIGNy
eXB0b21ncl90ZXN0KzB4M2UvMHgzZQpbICAgIDEuODkwMDk2XSAgWzxmZmZmZmZmZjhhYTk2
NGQ0Pl0ga3RocmVhZCsweGZlLzB4MTA2ClsgICAgMS44OTAwOTZdICBbPGZmZmZmZmZmOGFh
OTYzZDY+XSA/IGt0aHJlYWRfY3JlYXRlX29uX25vZGUrMHgxYjQvMHgxYjQKWyAgICAxLjg5
MDA5Nl0gIFs8ZmZmZmZmZmY4YWU4ZjhmYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsg
ICAgMS44OTAwOTZdICBbPGZmZmZmZmZmOGFhOTYzZDY+XSA/IGt0aHJlYWRfY3JlYXRlX29u
X25vZGUrMHgxYjQvMHgxYjQKWyAgICAxLjg5MDA5Nl0gQ29kZTogMDUgMDAgMDAgNDggM2Ig
YmIgNTggMDUgMDAgMDAgNzQgMTEgNDggODkgZGEgNDggYzcgYzYgMGQgOWEgMDcgOGIgZTgg
MGQgZmUgZmYgZmYgZWIgMGUgNDggYzcgYzcgMTcgOWEgMDcgOGIgMzEgYzAgZTggM2UgZTAg
M2UgMDAgPDBmPiAwYiA4MSA3OSAxMCA2NCA2NSA3MyA0MyA3NSA4NiA4MSA3OCAxMCA2NCA2
NSA3MyA0MyAwZiA4NSA3OSAKWyAgICAxLjg5MDA5Nl0gUklQICBbPGZmZmZmZmZmOGFhOTlm
MTQ+XSBfX3ZhbGlkYXRlX3Byb2Nlc3NfY3JlZHMrMHhhOS8weGM2ClsgICAgMS44OTAwOTZd
ICBSU1AgPGZmZmY4ODAwMGMxMWZkOTA+ClsgICAgMS45MzI1OTBdIC0tLVsgZW5kIHRyYWNl
IGI5Yjg1ZGE0YjVhNzBiNGYgXS0tLQpbICAgIDEuOTMzNDk5XSBLZXJuZWwgcGFuaWMgLSBu
b3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDYyNzEyMjUvNjRkMWNkZmJlMjBjNTA4Nzc1NzYwNDUxNDUzMTNjOWIwNjJjNTBmNy9k
bWVzZy1xdWFudGFsLWl2YjQxLTExNzoyMDE0MDYyOTExNDcyOTp4ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUv
NjRkMWNkZmJlMjBjNTA4Nzc1NzYwNDUxNDUzMTNjOWIwNjJjNTBmNy9kbWVzZy1xdWFudGFs
LWl2YjQxLTExODoyMDE0MDYyOTExNDcyOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIy
NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvNjRkMWNkZmJlMjBj
NTA4Nzc1NzYwNDUxNDUzMTNjOWIwNjJjNTBmNy9kbWVzZy1xdWFudGFsLWl2YjQxLTE6MjAx
NDA2MjkxMTQ3Mjk6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzY0ZDFjZGZiZTIwYzUwODc3NTc2MDQ1MTQ1
MzEzYzliMDYyYzUwZjcvZG1lc2ctcXVhbnRhbC1pdmI0MS00NDoyMDE0MDYyOTExNDczMTp4
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDYyNzEyMjUvNjRkMWNkZmJlMjBjNTA4Nzc1NzYwNDUxNDUzMTNjOWIwNjJjNTBm
Ny9kbWVzZy1xdWFudGFsLWl2YjQyLTE6MjAxNDA2MjkxMTQ3MzA6eDg2XzY0LXJhbmRjb25m
aWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1
LzY0ZDFjZGZiZTIwYzUwODc3NTc2MDQ1MTQ1MzEzYzliMDYyYzUwZjcvZG1lc2ctcXVhbnRh
bC1pdmI0NC0xMDk6MjAxNDA2MjkxMTQ3MzE6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEy
MjU6OgowOjY6NSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKNjRkMWNkZmJlMjBjNTA4
Nzc1NzYwNDUxNDUzMTNjOWIwNjJjNTBmNyBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21t
aXQgNjRkMWNkZmJlMjBjNTA4Nzc1NzYwNDUxNDUzMTNjOWIwNjJjNTBmNwpBdXRob3I6IFN0
ZXBoYW4gTXVlbGxlciA8c211ZWxsZXJAY2hyb25veC5kZT4KRGF0ZTogICBTYXQgTWF5IDMx
IDE3OjI1OjM2IDIwMTQgKzAyMDAKCiAgICBjcnlwdG86IGRyYmcgLSBBZGQgRFJCRyB0ZXN0
IGNvZGUgdG8gdGVzdG1ncgogICAgCiAgICBUaGUgRFJCRyB0ZXN0IGNvZGUgaW1wbGVtZW50
cyB0aGUgQ0FWUyB0ZXN0IGFwcHJvYWNoLgogICAgCiAgICBBcyBkaXNjdXNzZWQgZm9yIHRo
ZSB0ZXN0IHZlY3RvcnMsIGFsbCBEUkJHIHR5cGVzIGFyZSBjb3ZlcmVkIHdpdGgKICAgIHRl
c3RpbmcuIEhvd2V2ZXIsIG5vdCBldmVyeSBiYWNrZW5kIGNpcGhlciBpcyBjb3ZlcmVkIHdp
dGggdGVzdGluZy4gVG8KICAgIHByZXZlbnQgdGhlIHRlc3RtZ3IgZnJvbSBsb2dnaW5nIG1p
c3NpbmcgdGVzdGluZywgdGhlIE5VTEwgdGVzdCBpcwogICAgcmVnaXN0ZXJlZCBmb3IgYWxs
IGJhY2tlbmQgY2lwaGVycyBub3QgY292ZXJlZCB3aXRoIHNwZWNpZmljIHRlc3QgY2FzZXMu
CiAgICAKICAgIEFsbCBjdXJyZW50bHkgaW1wbGVtZW50ZWQgRFJCRyB0eXBlcyBhbmQgYmFj
a2VuZCBjaXBoZXJzIGFyZSBkZWZpbmVkCiAgICBpbiBTUDgwMC05MEEuIFRoZXJlZm9yZSwg
dGhlIGZpcHNfYWxsb3dlZCBmbGFnIGlzIHNldCBmb3IgYWxsLgogICAgCiAgICBTaWduZWQt
b2ZmLWJ5OiBTdGVwaGFuIE11ZWxsZXIgPHNtdWVsbGVyQGNocm9ub3guZGU+CiAgICBTaWdu
ZWQtb2ZmLWJ5OiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+Cgo6
MDQwMDAwIDA0MDAwMCA5Mzc1YjdkZjA5ODU1MGRjMmFkNTdkNTYzMjIzZjNkNGIzZmRlYWE3
IDAyM2U2YmVlZjA4NjIwYTM3MWM0ODBlMTNlZGJiNjAzMjUwZTE2NzQgTQljcnlwdG8KYmlz
ZWN0IHJ1biBzdWNjZXNzClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDY0ZDFjZGYuLi4g
Y3J5cHRvOiBkcmJnIC0gQWRkIERSQkcgdGVzdCBjb2RlIHRvIHRlc3RtZ3IKSEVBRCBpcyBu
b3cgYXQgMzMzMmVlMi4uLiBjcnlwdG86IGRyYmcgLSBEUkJHIHRlc3RtZ3IgdGVzdCB2ZWN0
b3JzCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNjI3MTIyNS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2MjYyMzozMzMy
ZWUyYTE3YjFiZDY5ZTQ2MDJlMmQ2YmExYjA3ZWRiMGM5YTI0OmJpc2VjdC1saW51eDAKCjIw
MTQtMDYtMjktMTE6NDg6MTMgMzMzMmVlMmExN2IxYmQ2OWU0NjAyZTJkNmJhMWIwN2VkYjBj
OWEyNCByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzMzMzJl
ZTJhMTdiMWJkNjllNDYwMmUyZDZiYTFiMDdlZGIwYzlhMjQvdm1saW51ei0zLjE2LjAtcmMx
LTAwMDEwLWczMzMyZWUyCgoyMDE0LTA2LTI5LTExOjQ4OjEzIGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4uCTMyCTYzIFNVQ0NFU1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDMz
MzJlZTIuLi4gY3J5cHRvOiBkcmJnIC0gRFJCRyB0ZXN0bWdyIHRlc3QgdmVjdG9ycwpIRUFE
IGlzIG5vdyBhdCA1ZGQzNWEwLi4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJs
eS0yMDE0MDYyNjIzJwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctczEtMDYyNzEyMjUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQw
NjI2MjM6NWRkMzVhMDk1ODZmZmQ0YzZiYmMxZGQ4MDQxOWUxNGY4NGFhNWNhMjpiaXNlY3Qt
bGludXgwCiBURVNUIEZBSUxVUkUKWyAgICAxLjk0NzU4Ml0gQ1JFRDogLT4qZ2lkID0geyAw
LDAsMCwwIH0KWyAgICAxLjk0ODkyM10gQ1JFRDogRWZmZWN0aXZlIGNyZWRzID09IFJlYWwg
Y3JlZHMKWyAgICAxLjk1MDE4OF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0t
LS0tClsgICAgMS45NTEzMDddIGtlcm5lbCBCVUcgYXQga2VybmVsL2NyZWQuYzo3OTAhClsg
ICAgMS45NTMxNzddIGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gClsgICAgMS45NTQyOTld
IE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDEuOTU1MjU0XSBDUFU6IDAgUElEOiA3NyBDb21t
OiBjcnlwdG9tZ3JfdGVzdCBOb3QgdGFpbnRlZCAzLjE2LjAtcmMyLXdsLTAxMjY2LWc1ZGQz
NWEwICMxOTEKWyAgICAxLjk1NzQ5M10gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQ
QyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDEu
OTU5NjUyXSB0YXNrOiBmZmZmODgwMDBjMTE2MDAwIHRpOiBmZmZmODgwMDBjMTFjMDAwIHRh
c2sudGk6IGZmZmY4ODAwMGMxMWMwMDAKWyAgICAxLjk2MDE2N10gUklQOiAwMDEwOls8ZmZm
ZmZmZmY4NDI5OWZiNj5dICBbPGZmZmZmZmZmODQyOTlmYjY+XSBfX3ZhbGlkYXRlX3Byb2Nl
c3NfY3JlZHMrMHhhOS8weGM2ClsgICAgMS45NjAxNjddIFJTUDogMDAwMDpmZmZmODgwMDBj
MTFmZDkwICBFRkxBR1M6IDAwMDEwMjk2ClsgICAgMS45NjAxNjddIFJBWDogMDAwMDAwMDAw
MDAwMDAyMyBSQlg6IGZmZmY4ODAwMGMxMTYwMDAgUkNYOiBmZmZmODgwMDBjMTE2N2MwClsg
ICAgMS45NjAxNjddIFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAw
MDEgUkRJOiAwMDAwMDAwMDAwMDAwMjQ2ClsgICAgMS45NjAxNjddIFJCUDogZmZmZjg4MDAw
YzExZmRhOCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsg
ICAgMS45NjAxNjddIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAw
MDAgUjEyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS45NjAxNjddIFIxMzogZmZmZmZmZmY4
NDQ3NGMwZCBSMTQ6IDAwMDAwMDAwMDAwMDAwMDAgUjE1OiAwMDAwMDAwMDAwMDAwMDAwClsg
ICAgMS45NjAxNjddIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmZmZmZjg0
OTQxMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjk2MDE2N10gQ1M6
ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDEu
OTYwMTY3XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDA0OTMxMDAwIENS
NDogMDAwMDAwMDAwMDAwMDZmMApbICAgIDEuOTYwMTY3XSBTdGFjazoKWyAgICAxLjk2MDE2
N10gIDAwMDAwMzI0MTFlYTAwOTAgZmZmZmZmZmY4NDg3OWVjNSBmZmZmODgwMDBjMTE2MDAw
IGZmZmY4ODAwMGMxMWZkYjgKWyAgICAxLjk2MDE2N10gIGZmZmZmZmZmODQyOWE4YWEgZmZm
Zjg4MDAwYzExZmUzMCBmZmZmZmZmZjg0MjdlMWY3IGZmZmY4ODAwMGMxMWZkZTgKWyAgICAx
Ljk2MDE2N10gIDAwMDAwMDAwMDAwMDAyODYgZmZmZjg4MDAwYzBkZTAwMCBmZmZmODgwMDBj
MGRlMDhjIDAwMDAwMDAwMGMxMWZlMzAKWyAgICAxLjk2MDE2N10gQ2FsbCBUcmFjZToKWyAg
ICAxLjk2MDE2N10gIFs8ZmZmZmZmZmY4NDI5YThhYT5dIHZhbGlkYXRlX2NyZWRzX2Zvcl9k
b19leGl0KzB4MjEvMHgyMwpbICAgIDEuOTYwMTY3XSAgWzxmZmZmZmZmZjg0MjdlMWY3Pl0g
ZG9fZXhpdCsweGQ0LzB4OTI3ClsgICAgMS45NjAxNjddICBbPGZmZmZmZmZmODQzMWE2ZjY+
XSA/IHNsb2JfZnJlZSsweDI2NC8weDI3MQpbICAgIDEuOTYwMTY3XSAgWzxmZmZmZmZmZjg0
NDc0YzBkPl0gPyBjcnlwdG9tZ3Jfbm90aWZ5KzB4MzY1LzB4MzY1ClsgICAgMS45NjAxNjdd
ICBbPGZmZmZmZmZmODQyYzYwOTU+XSBfX21vZHVsZV9wdXRfYW5kX2V4aXQrMHgxNS8weDE1
ClsgICAgMS45NjAxNjddICBbPGZmZmZmZmZmODQ0NzRjNGI+XSBjcnlwdG9tZ3JfdGVzdCsw
eDNlLzB4M2UKWyAgICAxLjk2MDE2N10gIFs8ZmZmZmZmZmY4NDI5NjU3Nj5dIGt0aHJlYWQr
MHhmZS8weDEwNgpbICAgIDEuOTYwMTY3XSAgWzxmZmZmZmZmZjg0Mjk2NDc4Pl0gPyBrdGhy
ZWFkX2NyZWF0ZV9vbl9ub2RlKzB4MWI0LzB4MWI0ClsgICAgMS45NjAxNjddICBbPGZmZmZm
ZmZmODQ2OGZmN2E+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgIDEuOTYwMTY3XSAg
WzxmZmZmZmZmZjg0Mjk2NDc4Pl0gPyBrdGhyZWFkX2NyZWF0ZV9vbl9ub2RlKzB4MWI0LzB4
MWI0ClsgICAgMS45NjAxNjddIENvZGU6IDA1IDAwIDAwIDQ4IDNiIGJiIDU4IDA1IDAwIDAw
IDc0IDExIDQ4IDg5IGRhIDQ4IGM3IGM2IDRhIGEwIDg3IDg0IGU4IDBkIGZlIGZmIGZmIGVi
IDBlIDQ4IGM3IGM3IDU0IGEwIDg3IDg0IDMxIGMwIGU4IDlmIGU1IDNlIDAwIDwwZj4gMGIg
ODEgNzkgMTAgNjQgNjUgNzMgNDMgNzUgODYgODEgNzggMTAgNjQgNjUgNzMgNDMgMGYgODUg
NzkgClsgICAgMS45NjAxNjddIFJJUCAgWzxmZmZmZmZmZjg0Mjk5ZmI2Pl0gX192YWxpZGF0
ZV9wcm9jZXNzX2NyZWRzKzB4YTkvMHhjNgpbICAgIDEuOTYwMTY3XSAgUlNQIDxmZmZmODgw
MDBjMTFmZDkwPgpbICAgIDIuMDAwMzMxXSAtLS1bIGVuZCB0cmFjZSBjMTBhNjQ1NmY5ODE2
NTlkIF0tLS0KWyAgICAyLjAwMTUxMV0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZh
dGFsIGV4Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzVk
ZDM1YTA5NTg2ZmZkNGM2YmJjMWRkODA0MTllMTRmODRhYTVjYTIvZG1lc2cteW9jdG8tbGtw
LXdzeDAyLTEyMzoyMDE0MDYyOTEwMjM1NTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIy
NTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvNWRkMzVhMDk1ODZm
ZmQ0YzZiYmMxZGQ4MDQxOWUxNGY4NGFhNWNhMi9kbWVzZy15b2N0by1sa3Atd3N4MDEtODoy
MDE0MDYyOTEwMjM1NTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjUvNWRkMzVhMDk1ODZmZmQ0YzZiYmMxZGQ4
MDQxOWUxNGY4NGFhNWNhMi9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNi0yMDoyMDE0MDYyODE1
MjAwMzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDYyNzEyMjUvNWRkMzVhMDk1ODZmZmQ0YzZiYmMxZGQ4MDQxOWUxNGY4
NGFhNWNhMi9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTE2OjIwMTQwNjI5MTAyMzU3Ong4Nl82
NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wNjI3MTIyNS81ZGQzNWEwOTU4NmZmZDRjNmJiYzFkZDgwNDE5ZTE0Zjg0YWE1Y2EyL2Rt
ZXNnLXF1YW50YWwtbGtwLW5leDA2LTU5OjIwMTQwNjI4MTUyMDAyOng4Nl82NC1yYW5kY29u
ZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIy
NS81ZGQzNWEwOTU4NmZmZDRjNmJiYzFkZDgwNDE5ZTE0Zjg0YWE1Y2EyL2RtZXNnLXlvY3Rv
LWxrcC13c3gwMi0xNDA6MjAxNDA2MjkxMDIzNTY6eDg2XzY0LXJhbmRjb25maWctczEtMDYy
NzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzVkZDM1YTA5
NTg2ZmZkNGM2YmJjMWRkODA0MTllMTRmODRhYTVjYTIvZG1lc2ctcXVhbnRhbC1sa3Atd3N4
MDItMjg6MjAxNDA2MjkxMDIzNTU6eDg2XzY0LXJhbmRjb25maWctczEtMDYyNzEyMjU6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LzVkZDM1YTA5NTg2ZmZkNGM2
YmJjMWRkODA0MTllMTRmODRhYTVjYTIvZG1lc2ctcXVhbnRhbC1sa3Atd3N4MDEtMTg4OjIw
MTQwNjI5MTAyMzU3Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS81ZGQzNWEwOTU4NmZmZDRjNmJiYzFkZDgw
NDE5ZTE0Zjg0YWE1Y2EyL2RtZXNnLXF1YW50YWwtbGtwLXdzeDAxLTE5ODoyMDE0MDYyOTEw
MjM1NTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDYyNzEyMjUvNWRkMzVhMDk1ODZmZmQ0YzZiYmMxZGQ4MDQxOWUxNGY4
NGFhNWNhMi9kbWVzZy1xdWFudGFsLWxrcC13c3gwMi02ODoyMDE0MDYyOTEwMjM1Njp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDYyNzEyMjUvNWRkMzVhMDk1ODZmZmQ0YzZiYmMxZGQ4MDQxOWUxNGY4NGFhNWNhMi9k
bWVzZy1xdWFudGFsLWxrcC13c3gwMi0xNDU6MjAxNDA2MjkxMDIzNTY6eDg2XzY0LXJhbmRj
b25maWctczEtMDYyNzEyMjU6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2Mjcx
MjI1LzVkZDM1YTA5NTg2ZmZkNGM2YmJjMWRkODA0MTllMTRmODRhYTVjYTIvZG1lc2cteW9j
dG8taXZiNDMtMTI1OjIwMTQwNjI5MTAyMzU2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA2Mjcx
MjI1OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS81ZGQzNWEwOTU4
NmZmZDRjNmJiYzFkZDgwNDE5ZTE0Zjg0YWE1Y2EyL2RtZXNnLXF1YW50YWwtbGtwLW5leDA2
LTU4OjIwMTQwNjI4MTUyMDAxOng4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1OjoKMDox
MzoxMyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQgNWRkMzVh
MCAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA2MjYyMycKCj09PT09
PT09PSB1cHN0cmVhbSA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNWRk
MzVhMC4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA2MjYyMycK
SEVBRCBpcyBub3cgYXQgMjRiNDE0ZC4uLiBNZXJnZSB0YWcgJ3NwaS12My4xNi1yYzInIG9m
IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9icm9vbmll
L3NwaQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctczEtMDYyNzEyMjUvbGludXM6bWFzdGVyOjI0YjQxNGQ1YTdkM2U2YTcxNjM1MDQ2NGRm
ZGI0NGRhNjEwZWQxNDI6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNi0yOS0xMTo1MTo0OCAyNGI0
MTRkNWE3ZDNlNmE3MTYzNTA0NjRkZmRiNDRkYTYxMGVkMTQyIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA2MjcxMjI1LTI0YjQxNGQ1YTdkM2U2YTcxNjM1MDQ2NGRmZGI0NGRhNjEwZWQx
NDIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2
MjcxMjI1LzI0YjQxNGQ1YTdkM2U2YTcxNjM1MDQ2NGRmZGI0NGRhNjEwZWQxNDIKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA2MjcxMjI1LTI0YjQxNGQ1YTdkM2U2YTcxNjM1MDQ2NGRmZGI0NGRh
NjEwZWQxNDIKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1
LzI0YjQxNGQ1YTdkM2U2YTcxNjM1MDQ2NGRmZGI0NGRhNjEwZWQxNDIvdm1saW51ei0zLjE2
LjAtcmMyLTAwMzQxLWcyNGI0MTRkCgoyMDE0LTA2LTI5LTExOjU3OjQ4IGRldGVjdGluZyBi
b290IHN0YXRlIC4uCTEJNQk3CTEwCTE1CTI3CTMxCTQwCTQ1CTYxLi4uLi4uLi4uLi4uLi4u
Li4uLgk2MyBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09ClByZXZp
b3VzIEhFQUQgcG9zaXRpb24gd2FzIDI0YjQxNGQuLi4gTWVyZ2UgdGFnICdzcGktdjMuMTYt
cmMyJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQv
YnJvb25pZS9zcGkKSEVBRCBpcyBub3cgYXQgOTY0MjYwMC4uLiBBZGQgbGludXgtbmV4dCBz
cGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA2MjcKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1L25leHQ6bWFzdGVyOjk2NDI2
MDA3YzkwY2RlMjNjMDQwMjg1NmYzZTBhZWMwZjRjYzJlNDg6YmlzZWN0LWxpbnV4MAoKMjAx
NC0wNi0yOS0xMjoxMzo1MiA5NjQyNjAwN2M5MGNkZTIzYzA0MDI4NTZmM2UwYWVjMGY0Y2My
ZTQ4IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LTk2NDI2MDA3YzkwY2RlMjNj
MDQwMjg1NmYzZTBhZWMwZjRjYzJlNDgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1Lzk2NDI2MDA3YzkwY2RlMjNjMDQwMjg1NmYz
ZTBhZWMwZjRjYzJlNDgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA2MjcxMjI1LTk2NDI2MDA3Yzkw
Y2RlMjNjMDQwMjg1NmYzZTBhZWMwZjRjYzJlNDgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wNjI3MTIyNS05NjQyNjAwN2M5MGNkZTIzYzA0MDI4NTZmM2UwYWVjMGY0Y2MyZTQ4
Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wNjI3MTIyNS85NjQyNjAw
N2M5MGNkZTIzYzA0MDI4NTZmM2UwYWVjMGY0Y2MyZTQ4L3ZtbGludXotMy4xNi4wLXJjMi1u
ZXh0LTIwMTQwNjI3CgoyMDE0LTA2LTI5LTEyOjE4OjUyIGRldGVjdGluZyBib290IHN0YXRl
IC4uIFRFU1QgRkFJTFVSRQpbICAgIDMuMzQ4NjI1XSBDUkVEOiAtPipnaWQgPSB7IDAsMCww
LDAgfQpbICAgIDMuMzQ5NDEyXSBDUkVEOiBFZmZlY3RpdmUgY3JlZHMgPT0gUmVhbCBjcmVk
cwpbICAgIDMuMzUwNTE0XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0K
WyAgICAzLjM1MTUwMF0ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy9zbW9rZS9rZXJuZWwv
Y3JlZC5jOjc5MCEKWyAgICAzLjM1MjcwN10gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSAK
WyAgICAzLjM1MzUyNV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMy4zNTQyMDldIENQVTog
MCBQSUQ6IDc3IENvbW06IGNyeXB0b21ncl90ZXN0IE5vdCB0YWludGVkIDMuMTYuMC1yYzIt
bmV4dC0yMDE0MDYyNyAjMQpbICAgIDMuMzU1ODU4XSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0
YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8wMS8yMDEx
ClsgICAgMy4zNTc1NDVdIHRhc2s6IGZmZmY4ODAwMGMxMjIwMDAgdGk6IGZmZmY4ODAwMGMx
MTAwMDAgdGFzay50aTogZmZmZjg4MDAwYzExMDAwMApbICAgIDMuMzU5MTAwXSBSSVA6IDAw
MTA6WzxmZmZmZmZmZjg3ODlhMmUxPl0gIFs8ZmZmZmZmZmY4Nzg5YTJlMT5dIF9fdmFsaWRh
dGVfcHJvY2Vzc19jcmVkcysweGE5LzB4YzYKWyAgICAzLjM2MDQ5Nl0gUlNQOiAwMDAwOmZm
ZmY4ODAwMGMxMTNkOTAgIEVGTEFHUzogMDAwMTAyOTYKWyAgICAzLjM2MDQ5Nl0gUkFYOiAw
MDAwMDAwMDAwMDAwMDIzIFJCWDogZmZmZjg4MDAwYzEyMjAwMCBSQ1g6IGZmZmY4ODAwMGMx
MjI3YzAKWyAgICAzLjM2MDQ5Nl0gUkRYOiAwMDAwMDAwMDAwMDAwMWM3IFJTSTogMDAwMDAw
MDAwMDAwMDAwMSBSREk6IDAwMDAwMDAwMDAwMDAyNDYKWyAgICAzLjM2MDQ5Nl0gUkJQOiBm
ZmZmODgwMDBjMTEzZGE4IFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAw
MDAwMDAKWyAgICAzLjM2MDQ5Nl0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAw
MDAwMDAwMDAwMCBSMTI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAzLjM2MDQ5Nl0gUjEzOiBm
ZmZmZmZmZjg3YTc1NTJkIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDAwMDAwMDAw
MDAwMDAKWyAgICAzLjM2MDQ5Nl0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZm
ZmZmZmZmODdmNDQwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDMuMzYw
NDk2XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNi
ClsgICAgMy4zNjA0OTZdIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMDdm
MzQwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmYwClsgICAgMy4zNjA0OTZdIFN0YWNrOgpbICAg
IDMuMzYwNDk2XSAgMDAwMDAzMjQxMWVhMDNhMCBmZmZmZmZmZjg3ZTdiNDMyIGZmZmY4ODAw
MGMxMjIwMDAgZmZmZjg4MDAwYzExM2RiOApbICAgIDMuMzYwNDk2XSAgZmZmZmZmZmY4Nzg5
YWJkNSBmZmZmODgwMDBjMTEzZTMwIGZmZmZmZmZmODc4N2U1MzAgZmZmZjg4MDAwYzExM2Rl
OApbICAgIDMuMzYwNDk2XSAgMDAwMDAwMDAwMDAwMDI4NiBmZmZmODgwMDBjMGVjMDAwIGZm
ZmY4ODAwMGMwZWMwOGMgMDAwMDAwMDAwYzExM2UzMApbICAgIDMuMzYwNDk2XSBDYWxsIFRy
YWNlOgpbICAgIDMuMzYwNDk2XSAgWzxmZmZmZmZmZjg3ODlhYmQ1Pl0gdmFsaWRhdGVfY3Jl
ZHNfZm9yX2RvX2V4aXQrMHgyMS8weDIzClsgICAgMy4zNjA0OTZdICBbPGZmZmZmZmZmODc4
N2U1MzA+XSBkb19leGl0KzB4ZDQvMHg5MjcKWyAgICAzLjM2MDQ5Nl0gIFs8ZmZmZmZmZmY4
NzkxYThjZD5dID8gc2xvYl9mcmVlKzB4MjY0LzB4MjcxClsgICAgMy4zNjA0OTZdICBbPGZm
ZmZmZmZmODdhNzU1MmQ+XSA/IGNyeXB0b21ncl9ub3RpZnkrMHgzNjUvMHgzNjUKWyAgICAz
LjM2MDQ5Nl0gIFs8ZmZmZmZmZmY4NzhjNjMzNT5dIF9fbW9kdWxlX3B1dF9hbmRfZXhpdCsw
eDE1LzB4MTUKWyAgICAzLjM2MDQ5Nl0gIFs8ZmZmZmZmZmY4N2E3NTU2Yj5dIGNyeXB0b21n
cl90ZXN0KzB4M2UvMHgzZQpbICAgIDMuMzYwNDk2XSAgWzxmZmZmZmZmZjg3ODk2OGExPl0g
a3RocmVhZCsweGZlLzB4MTA2ClsgICAgMy4zNjA0OTZdICBbPGZmZmZmZmZmODc4OTY3YTM+
XSA/IGt0aHJlYWRfY3JlYXRlX29uX25vZGUrMHgxYjQvMHgxYjQKWyAgICAzLjM2MDQ5Nl0g
IFs8ZmZmZmZmZmY4N2M5MGVmYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAgMy4z
NjA0OTZdICBbPGZmZmZmZmZmODc4OTY3YTM+XSA/IGt0aHJlYWRfY3JlYXRlX29uX25vZGUr
MHgxYjQvMHgxYjQKWyAgICAzLjM2MDQ5Nl0gQ29kZTogMDUgMDAgMDAgNDggM2IgYmIgNTgg
MDUgMDAgMDAgNzQgMTEgNDggODkgZGEgNDggYzcgYzYgYjcgYjUgZTcgODcgZTggMGQgZmUg
ZmYgZmYgZWIgMGUgNDggYzcgYzcgYzEgYjUgZTcgODcgMzEgYzAgZTggNGMgZjIgM2UgMDAg
PDBmPiAwYiA4MSA3OSAxMCA2NCA2NSA3MyA0MyA3NSA4NiA4MSA3OCAxMCA2NCA2NSA3MyA0
MyAwZiA4NSA3OSAKWyAgICAzLjM2MDQ5Nl0gUklQICBbPGZmZmZmZmZmODc4OWEyZTE+XSBf
X3ZhbGlkYXRlX3Byb2Nlc3NfY3JlZHMrMHhhOS8weGM2ClsgICAgMy4zNjA0OTZdICBSU1Ag
PGZmZmY4ODAwMGMxMTNkOTA+ClsgICAgMy40MTg4MDddIC0tLVsgZW5kIHRyYWNlIDdiNzgz
Njg2NGIxNDJiY2YgXS0tLQpbICAgIDMuNDMyMzEzXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3lu
Y2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDYy
NzEyMjUvOTY0MjYwMDdjOTBjZGUyM2MwNDAyODU2ZjNlMGFlYzBmNGNjMmU0OC9kbWVzZy1x
dWFudGFsLWl2YjQyLTEyODoyMDE0MDYyOTEyMTkyOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0w
NjI3MTIyNTo6CjA6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgo=

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-rc1-00011-g64d1cdf"

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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_FHANDLE is not set
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

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
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
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
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_PROFILING is not set
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
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
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
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
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
CONFIG_HPET_EMULATE_RTC=y
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
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
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
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
CONFIG_ZBUD=y
CONFIG_ZSWAP=y
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSMALLOC=m
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
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
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
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
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

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
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
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
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
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
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=m
CONFIG_ATM_LANE=m
CONFIG_STP=y
CONFIG_MRP=m
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=m
CONFIG_PHONET=m
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_EMATCH_CANID=y
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_C_CAN=m
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
CONFIG_CAN_GS_USB=m
# CONFIG_CAN_KVASER_USB is not set
CONFIG_CAN_PEAK_USB=m
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=m
CONFIG_CAIF_USB=m
CONFIG_NFC=m
CONFIG_NFC_DIGITAL=m
CONFIG_NFC_NCI=m
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=m
# CONFIG_NFC_SIM is not set
CONFIG_NFC_PORT100=m
# CONFIG_NFC_PN544 is not set
# CONFIG_NFC_MICROREAD is not set
CONFIG_NFC_MRVL=m
CONFIG_NFC_MRVL_USB=m
CONFIG_NFC_ST21NFCA=m
CONFIG_NFC_ST21NFCA_I2C=m
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
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
CONFIG_FTL=m
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m
CONFIG_MTD_SWAP=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
# CONFIG_MTD_JEDECPROBE is not set
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
CONFIG_MTD_CFI_INTELEXT=m
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SBC_GXX=m
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_SPI_NOR is not set
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
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
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_OSD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_VMWARE_BALLOON=m
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_SRAM=y
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
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
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_BOOT_SYSFS is not set
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
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
# CONFIG_BCACHE is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=m
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=m
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_KXTJ9=m
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=m
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=m
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_IMS_PCU=y
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_IDEAPAD_SLIDEBAR=m

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
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
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
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
CONFIG_DEVKMEM=y

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
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_SC16IS7XX=m
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=m
CONFIG_SERIAL_MEN_Z135=y
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=m
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_TIS_I2C_ATMEL=m
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=m
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
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
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_ROBOTFUZZ_OSIF=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
# CONFIG_PPS_CLIENT_PARPORT is not set
CONFIG_PPS_CLIENT_GPIO=m

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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=m
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_MC13783_ADC=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=m
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4222=m
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=m
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_NCT6683=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_ADC128D818=m
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set

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
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=m
CONFIG_DW_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=m
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y

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
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_BCM590XX=m
# CONFIG_MFD_CROS_EC is not set
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_ABX500_CORE=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_BCM590XX is not set
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_FAN53555=m
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=m
# CONFIG_REGULATOR_LTC3589 is not set
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_PFUZE100=m
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65217=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_DVB_CORE=m
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
# CONFIG_CYPRESS_FIRMWARE is not set
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
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MC44S803=m

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
# CONFIG_DRM is not set

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
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
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
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
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
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=m
CONFIG_FB_UDL=m
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=m
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_LV5207LP=m
CONFIG_BACKLIGHT_BD6107=m
# CONFIG_VGASTATE is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=m

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
CONFIG_HID_APPLEIR=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
# CONFIG_HID_HUION is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
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
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=y
CONFIG_USB_MON=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_FUSBH200_HCD=m
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_RENESAS_USBHS_HCD is not set
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=m
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=m

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_HOST is not set

#
# Gadget mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_PERIPHERAL=y
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_ATM=m
# CONFIG_USB_SPEEDTOUCH is not set
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=m
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_TAHVO_USB=m
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
CONFIG_USB_GR_UDC=m
CONFIG_USB_R8A66597=m
CONFIG_USB_RENESAS_USBHS_UDC=m
CONFIG_USB_PXA27X=m
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=m
CONFIG_USB_M66592=m
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_EEM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_F_MASS_STORAGE=m
CONFIG_USB_F_FS=m
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=m
# CONFIG_USB_ETH_RNDIS is not set
CONFIG_USB_ETH_EEM=y
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
CONFIG_USB_FUNCTIONFS=m
CONFIG_USB_FUNCTIONFS_ETH=y
# CONFIG_USB_FUNCTIONFS_RNDIS is not set
# CONFIG_USB_FUNCTIONFS_GENERIC is not set
# CONFIG_USB_MASS_STORAGE is not set
CONFIG_USB_G_SERIAL=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
# CONFIG_USB_G_NOKIA is not set
CONFIG_USB_G_ACM_MS=m
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y
# CONFIG_USB_G_MULTI_CDC is not set
CONFIG_USB_G_HID=m
CONFIG_USB_G_DBGP=m
CONFIG_USB_G_DBGP_PRINTK=y
# CONFIG_USB_G_DBGP_SERIAL is not set
# CONFIG_USB_G_WEBCAM is not set
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
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
CONFIG_MMC_USDHI6ROL0=m
CONFIG_MMC_REALTEK_USB=y
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
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_MEMSTICK_REALTEK_USB=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_DECODE_MCE is not set
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
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=m
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_ISL12057=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF2127=m
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_S35390A=m
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=m
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
CONFIG_RTC_DRV_MOXART=y
CONFIG_RTC_DRV_XGENE=y

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=m
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_PCI is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
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
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=m
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=m
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
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
CONFIG_EXTCON_ADC_JACK=m
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=m
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_MMA8452=m

#
# Analog to digital converters
#
CONFIG_AD799X=m
CONFIG_MAX1363=m
CONFIG_MCP3422=m
CONFIG_MEN_Z188_ADC=m
# CONFIG_NAU7802 is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_AM335X_ADC is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5380=m
# CONFIG_AD5446 is not set
CONFIG_MAX517=m
CONFIG_MCP4725=m

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
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_SI7005=m

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=m
CONFIG_CM32181=m
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=m
CONFIG_SENSORS_LM3533=m
CONFIG_LTR501=m
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_MAG3110=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
CONFIG_MPL115=m
CONFIG_MPL3115=m
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Lightning sensors
#

#
# Temperature sensors
#
CONFIG_MLX90614=m
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
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
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=m
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
# CONFIG_JFFS2_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_EXOFS_FS=m
# CONFIG_EXOFS_DEBUG is not set
CONFIG_F2FS_FS=m
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_F2FS_CHECK_FS=y
CONFIG_ORE=m
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=m
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
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
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
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

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
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
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
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYTPO_DRBG=y
# CONFIG_CRYPTO_DRBG_HMAC is not set
# CONFIG_CRYPTO_DRBG_HASH is not set
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_CCP is not set
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
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=m
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--CdrF4e02JqNVZeln--
