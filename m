Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbaGDEH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 00:07:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:52605 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaGDEH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 00:07:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,598,1400050800"; 
   d="scan'208";a="538652908"
Message-ID: <53B62897.3050008@intel.com>
Date: Fri, 04 Jul 2014 12:07:51 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [block, blk] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000028
Content-Type: multipart/mixed;
 boundary="------------000404020508090904030204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000404020508090904030204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Tejun,

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-mq-percpu_ref
commit c924ec35e72ce0d6c289b858d323f7eb3f5076a5 ("block, blk-mq: draining can't be skipped even if bypass_depth was non-zero")

+------------------------------------------------------+------------+------------+
|                                                      | ea854572ee | c924ec35e7 |
+------------------------------------------------------+------------+------------+
| boot_successes                                       | 26         | 10         |
| early-boot-hang                                      | 1          |            |
| boot_failures                                        | 0          | 16         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference | 0          | 16         |
| Oops                                                 | 0          | 16         |
| RIP:blk_throtl_drain                                 | 0          | 16         |
| kernel_BUG_at_arch/x86/mm/pageattr.c                 | 0          | 7          |
| invalid_opcode                                       | 0          | 7          |
| RIP:change_page_attr_set_clr                         | 0          | 7          |
| Kernel_panic-not_syncing:Fatal_exception             | 0          | 16         |
| backtrace:scsi_debug_exit                            | 0          | 6          |
| backtrace:SyS_delete_module                          | 0          | 6          |
| backtrace:do_vfs_ioctl                               | 0          | 10         |
| backtrace:SyS_ioctl                                  | 0          | 10         |
+------------------------------------------------------+------------+------------+


[  522.186410] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[  522.368967] EXT4-fs (dm-0): recovery complete
[  522.415305] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[  523.030685] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[  523.031682] IP: [<ffffffff813cea30>] blk_throtl_drain+0x30/0x150
[  523.031682] PGD a8d1c067 PUD a71fd067 PMD 0 [  523.031682] Oops: 0000 [#1] SMP [  523.031682] Modules linked in: dm_flakey dm_mod fuse sg sr_mod cdrom ata_generic pata_acpi cirrus syscopyarea snd_pcm sysfillrect snd_timer sysimgblt floppy snd ttm soundcore parport_pc drm_kms_helper parport drm pcspkr i2c_piix4 ata_piix libata
[  523.031682] CPU: 0 PID: 30028 Comm: dmsetup Not tainted 3.16.0-rc1-01463-g94b6452 #1
[  523.031682] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  523.031682] task: ffff88011560bb20 ti: ffff8800a6c7c000 task.ti: ffff8800a6c7c000
[  523.031682] RIP: 0010:[<ffffffff813cea30>]  [<ffffffff813cea30>] blk_throtl_drain+0x30/0x150
[  523.031682] RSP: 0018:ffff8800a6c7fb58  EFLAGS: 00010046
[  523.031682] RAX: 0000000000000000 RBX: ffff88011503be40 RCX: 000000007fffffff
[  523.031682] RDX: 0000000000000016 RSI: 0000000000000000 RDI: 0000000000000000
[  523.031682] RBP: ffff8800a6c7fb70 R08: 0000000000000000 R09: 0000000000000046
[  523.031682] R10: ffff8800a6c7fb70 R11: ffffffff813dcbb1 R12: ffff88011503be40
[  523.031682] R13: ffff8800d50a7700 R14: ffff88011503c498 R15: 0000000000000000
[  523.031682] FS:  00007fa84cf11800(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[  523.031682] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  523.031682] CR2: 0000000000000028 CR3: 000000007ed12000 CR4: 00000000000006f0
[  523.031682] Stack:
[  523.031682]  ffff88011503be40 0000000000000000 ffff88011503c4a8 ffff8800a6c7fb80
[  523.031682]  ffffffff813cba6e ffff8800a6c7fbb0 ffffffff813b0b6c ffff88011503be40
[  523.031682]  ffffffff81cf3920 ffff88011503be40 ffff8800aad17a00 ffff8800a6c7fbc8
[  523.031682] Call Trace:
[  523.031682]  [<ffffffff813cba6e>] blkcg_drain_queue+0xe/0x10
[  523.031682]  [<ffffffff813b0b6c>] __blk_drain_queue+0x7c/0x180
[  523.031682]  [<ffffffff813b0cfe>] blk_queue_bypass_start+0x8e/0xd0
[  523.031682]  [<ffffffff813cac18>] blkcg_deactivate_policy+0x38/0x140
[  523.031682]  [<ffffffff813cec84>] blk_throtl_exit+0x34/0x50
[  523.031682]  [<ffffffff813cbab8>] blkcg_exit_queue+0x48/0x70
[  523.031682]  [<ffffffff813b43c6>] blk_release_queue+0x26/0x100
[  523.031682]  [<ffffffff813dcb97>] kobject_cleanup+0x77/0x1b0
[  523.031682]  [<ffffffff813dca48>] kobject_put+0x28/0x60
[  523.031682]  [<ffffffff813b0e59>] blk_cleanup_queue+0x119/0x1c0
[  523.031682]  [<ffffffffa019c243>] __dm_destroy+0x1f3/0x280 [dm_mod]
[  523.031682]  [<ffffffffa019d083>] dm_destroy+0x13/0x20 [dm_mod]
[  523.031682]  [<ffffffffa01a27de>] dev_remove+0x11e/0x180 [dm_mod]
[  523.031682]  [<ffffffffa01a26c0>] ? dev_suspend+0x250/0x250 [dm_mod]
[  523.031682]  [<ffffffffa01a2ea9>] ctl_ioctl+0x269/0x500 [dm_mod]
[  523.031682]  [<ffffffff814c5c4b>] ? extract_buf+0xbb/0x130
[  523.031682]  [<ffffffffa01a3153>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
[  523.031682]  [<ffffffff811da350>] do_vfs_ioctl+0x300/0x520
[  523.031682]  [<ffffffff813729f6>] ? file_has_perm+0x86/0xa0
[  523.031682]  [<ffffffff811da5f1>] SyS_ioctl+0x81/0xa0
[  523.031682]  [<ffffffff818348a9>] system_call_fastpath+0x16/0x1b
[  523.031682] Code: 55 65 ff 04 25 a0 c7 00 00 48 89 e5 41 55 41 54 49 89 fc 53 4c 8b af 40 07 00 00 49 8b 85 a0 00 00 00 31 ff 48 8b 80 c8 05 00 00 <48> 8b 70 28 e8 37 8d d2 ff 48 85 c0 48 89 c3 74 61 0f 1f 80 00 [  523.031682] RIP  [<ffffffff813cea30>] blk_throtl_drain+0x30/0x150
[  523.031682]  RSP <ffff8800a6c7fb58>
[  523.031682] CR2: 0000000000000028
[  523.031682] ---[ end trace ef34f58eab34804c ]---
[  523.031682] Kernel panic - not syncing: Fatal exception



Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Jet


--------------000404020508090904030204
Content-Type: text/plain; charset=UTF-8;
 name="reproduce"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="reproduce"

mkfs -t ext4 -q /dev/vdb
mkfs -t ext4 -q /dev/vda
mkfs -t ext4 -q /dev/vdc
mkfs -t ext4 -q /dev/vdd
mount -t ext4 /dev/vda /fs/vda
mount -t ext4 /dev/vdb /fs/vdb
mount -t ext4 /dev/vdc /fs/vdc
mount -t ext4 /dev/vdd /fs/vdd
export TEST_DIR=3D/fs/vda
export TEST_DEV=3D/dev/vda
export SCRATCH_MNT=3D/fs/scratch
mkdir /fs/scratch -p
export SCRATCH_DEV=3D/dev/vdd
=2E/check generic/001 generic/002 generic/003 generic/004 generic/005 gen=
eric/006 generic/007 generic/008 generic/009 generic/010 generic/011 gene=
ric/012 generic/014 generic/015 generic/016 generic/017 generic/018 gener=
ic/019 generic/020 generic/021 generic/022 generic/023 generic/024 generi=
c/025 generic/026 generic/027 generic/028 generic/053 generic/062 generic=
/069 generic/076 generic/077 generic/079 generic/088 generic/089 generic/=
093 generic/097 generic/099 generic/105 generic/123 generic/124 generic/1=
26 generic/128 generic/129 generic/131 generic/135 generic/141 generic/16=
9 generic/184 generic/193 generic/198 generic/207 generic/210 generic/211=
 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 =
generic/228 generic/234 generic/235 generic/236 generic/237 generic/239 g=
eneric/240 generic/245 generic/246 generic/248 generic/249 generic/251 ge=
neric/255 generic/257 generic/258 generic/260 generic/277 generic/280 gen=
eric/285 generic/286 generic/288 generic/294 generic/307 generic/308 gene=
ric/309 generic/312 generic/313 generic/314 generic/315 generic/316 gener=
ic/317 generic/318 generic/320 generic/321 generic/322


--------------000404020508090904030204
Content-Type: text/plain; charset=UTF-8;
 name=".dmesg"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=".dmesg"

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc1-01463-g94b6452 (kbuild@ivytown2) =
(gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Fri Jun 20 11:31:13 CST 201=
4
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-2/cyclic=
_xfstests-generic-4HDD-ext4-generic-quick-HEAD-94b64527da25b29ee4fcad1666=
f6dae4178d6d88.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/94b645=
27da25b29ee4fcad1666f6dae4178d6d88/vmlinuz-3.16.0-rc1-01463-g94b6452 kcon=
fig=3Dx86_64-rhel commit=3D94b64527da25b29ee4fcad1666f6dae4178d6d88 initr=
d=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=3D/lkp=
/benchmarks/xfstests.cgz modules_initrd=3D/kernel/x86_64-rhel/94b64527da2=
5b29ee4fcad1666f6dae4178d6d88/modules.cgz max_uptime=3D5420 RESULT_ROOT=3D=
/result/vpx/xfstests/4HDD-ext4-generic-quick/x86_64-rhel/94b64527da25b29e=
e4fcad1666f6dae4178d6d88/0 ip=3D::::vpx-2::dhcp oops=3Dpanic earlyprintk=3D=
ttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_sta=
ll_timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic loa=
d_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vg=
a=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usa=
ble
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped a=
t [ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0213f000, 0x0213ffff] PGTABLE
[    0.000000] BRK [0x02140000, 0x02140fff] PGTABLE
[    0.000000] BRK [0x02141000, 0x02141fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02142000, 0x02142fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x77043000-0x7fffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x00000000DFFFE380 000034 (v01 BOCHS  BXPCRSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x00000000DFFFFF80 000074 (v01 BOCHS  BXPCFACP =
00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x00000000DFFFE3C0 0011A9 (v01 BXPC   BXDSDT   =
00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x00000000DFFFFF40 000040
[    0.000000] ACPI: SSDT 0x00000000DFFFF6E0 000858 (v01 BOCHS  BXPCSSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x00000000DFFFF5B0 000090 (v01 BOCHS  BXPCAPIC =
00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x00000000DFFFF570 000038 (v01 BOCHS  BXPCHPET =
00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011ffffff=
f]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11ffd5000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ff55001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b600=
000-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1048476
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
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
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 =
nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011fc00000 s87552 r81=
92 d23040 u524288
[    0.000000] pcpu-alloc: s87552 r8192 d23040 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0e000
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  To=
tal pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-2=
/cyclic_xfstests-generic-4HDD-ext4-generic-quick-HEAD-94b64527da25b29ee4f=
cad1666f6dae4178d6d88.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel=
/94b64527da25b29ee4fcad1666f6dae4178d6d88/vmlinuz-3.16.0-rc1-01463-g94b64=
52 kconfig=3Dx86_64-rhel commit=3D94b64527da25b29ee4fcad1666f6dae4178d6d8=
8 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=
=3D/lkp/benchmarks/xfstests.cgz modules_initrd=3D/kernel/x86_64-rhel/94b6=
4527da25b29ee4fcad1666f6dae4178d6d88/modules.cgz max_uptime=3D5420 RESULT=
_ROOT=3D/result/vpx/xfstests/4HDD-ext4-generic-quick/x86_64-rhel/94b64527=
da25b29ee4fcad1666f6dae4178d6d88/0 ip=3D::::vpx-2::dhcp oops=3Dpanic earl=
yprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.r=
cu_cpu_stall_timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3D=
panic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3D=
tty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 3895956K/4193904K available (8422K kernel code, 16=
41K rwdata, 3872K rodata, 1792K init, 1876K bss, 297948K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4,=
 Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D4
[    0.000000] NR_IRQS:524544 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc1-01463-g94b6452 (kbuild@ivytown2) =
(gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Fri Jun 20 11:31:13 CST 201=
4
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-2/cyclic=
_xfstests-generic-4HDD-ext4-generic-quick-HEAD-94b64527da25b29ee4fcad1666=
f6dae4178d6d88.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/94b645=
27da25b29ee4fcad1666f6dae4178d6d88/vmlinuz-3.16.0-rc1-01463-g94b6452 kcon=
fig=3Dx86_64-rhel commit=3D94b64527da25b29ee4fcad1666f6dae4178d6d88 initr=
d=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=3D/lkp=
/benchmarks/xfstests.cgz modules_initrd=3D/kernel/x86_64-rhel/94b64527da2=
5b29ee4fcad1666f6dae4178d6d88/modules.cgz max_uptime=3D5420 RESULT_ROOT=3D=
/result/vpx/xfstests/4HDD-ext4-generic-quick/x86_64-rhel/94b64527da25b29e=
e4fcad1666f6dae4178d6d88/0 ip=3D::::vpx-2::dhcp oops=3Dpanic earlyprintk=3D=
ttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_sta=
ll_timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic loa=
d_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vg=
a=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usa=
ble
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped a=
t [ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0213f000, 0x0213ffff] PGTABLE
[    0.000000] BRK [0x02140000, 0x02140fff] PGTABLE
[    0.000000] BRK [0x02141000, 0x02141fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02142000, 0x02142fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x77043000-0x7fffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x00000000DFFFE380 000034 (v01 BOCHS  BXPCRSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x00000000DFFFFF80 000074 (v01 BOCHS  BXPCFACP =
00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x00000000DFFFE3C0 0011A9 (v01 BXPC   BXDSDT   =
00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x00000000DFFFFF40 000040
[    0.000000] ACPI: SSDT 0x00000000DFFFF6E0 000858 (v01 BOCHS  BXPCSSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x00000000DFFFF5B0 000090 (v01 BOCHS  BXPCAPIC =
00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x00000000DFFFF570 000038 (v01 BOCHS  BXPCHPET =
00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011ffffff=
f]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11ffd5000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ff55001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b600=
000-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1048476
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
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
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 =
nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011fc00000 s87552 r81=
92 d23040 u524288
[    0.000000] pcpu-alloc: s87552 r8192 d23040 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0e000
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  To=
tal pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-2=
/cyclic_xfstests-generic-4HDD-ext4-generic-quick-HEAD-94b64527da25b29ee4f=
cad1666f6dae4178d6d88.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel=
/94b64527da25b29ee4fcad1666f6dae4178d6d88/vmlinuz-3.16.0-rc1-01463-g94b64=
52 kconfig=3Dx86_64-rhel commit=3D94b64527da25b29ee4fcad1666f6dae4178d6d8=
8 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=
=3D/lkp/benchmarks/xfstests.cgz modules_initrd=3D/kernel/x86_64-rhel/94b6=
4527da25b29ee4fcad1666f6dae4178d6d88/modules.cgz max_uptime=3D5420 RESULT=
_ROOT=3D/result/vpx/xfstests/4HDD-ext4-generic-quick/x86_64-rhel/94b64527=
da25b29ee4fcad1666f6dae4178d6d88/0 ip=3D::::vpx-2::dhcp oops=3Dpanic earl=
yprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.r=
cu_cpu_stall_timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3D=
panic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3D=
tty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 3895956K/4193904K available (8422K kernel code, 16=
41K rwdata, 3872K rodata, 1792K init, 1876K bss, 297948K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4,=
 Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D4
[    0.000000] NR_IRQS:524544 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.484 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5386.96 Bo=
goMIPS (lpj=3D2693484)
[    0.003010] pid_max: default: 32768 minimum: 301
[    0.003543] ACPI: Core revision 20140424
[    0.005215] ACPI: All ACPI Tables successfully acquired
[    0.006083] Security Framework initialized
[    0.006760] SELinux:  Initializing.
[    0.007019] SELinux:  Starting in permissive mode
[    0.008247] Dentry cache hash table entries: 524288 (order: 10, 419430=
4 bytes)
[    0.012709] Inode-cache hash table entries: 262144 (order: 9, 2097152 =
bytes)
[    0.015041] Mount-cache hash table entries: 8192 (order: 4, 65536 byte=
s)
[    0.015996] Mountpoint-cache hash table entries: 8192 (order: 4, 65536=
 bytes)
[    0.017464] Initializing cgroup subsys memory
[    0.018035] Initializing cgroup subsys devices
[    0.018750] Initializing cgroup subsys freezer
[    0.019011] Initializing cgroup subsys net_cls
[    0.020012] Initializing cgroup subsys blkio
[    0.021012] Initializing cgroup subsys perf_event
[    0.021745] Initializing cgroup subsys hugetlb
[    0.022086] mce: CPU supports 10 MCE banks
[    0.023061] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023061] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.023061] tlb_flushall_shift: 6
[    0.024137] Freeing SMP alternatives memory: 32K (ffffffff81f60000 - f=
fffffff81f68000)
[    0.029081] ftrace: allocating 30765 entries in 121 pages
[    0.037243] Getting VERSION: 50014
[    0.037847] Getting VERSION: 50014
[    0.038008] Getting ID: 0
[    0.038516] Getting ID: ff000000
[    0.039008] Getting LVT0: 8700
[    0.040006] Getting LVT1: 8400
[    0.040626] enabled ExtINT on CPU#0
[    0.041615] ENABLING IO-APIC IRQs
[    0.042007] init IO_APIC IRQs
[    0.043006]  apic 0 pin 0 not connected
[    0.043640] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.044015] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.045015] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.046014] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.047014] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.048013] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.049014] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.050014] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.051014] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.052013] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.053014] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.054031] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.055014] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.056014] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.057014] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.058012]  apic 0 pin 16 not connected
[    0.059002]  apic 0 pin 17 not connected
[    0.060002]  apic 0 pin 18 not connected
[    0.060620]  apic 0 pin 19 not connected
[    0.061002]  apic 0 pin 20 not connected
[    0.062002]  apic 0 pin 21 not connected
[    0.062619]  apic 0 pin 22 not connected
[    0.063002]  apic 0 pin 23 not connected
[    0.064157] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.065004] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model:=
 06, stepping: 01)
[    0.066644] Using local APIC timer interrupts.
[    0.066644] calibrating APIC timer ...
[    0.068000] ... lapic delta =3D 6254044
[    0.068000] ... PM-Timer delta =3D 358158
[    0.068000] ... PM-Timer result ok
[    0.068000] ..... delta 6254044
[    0.068000] ..... mult: 268609144
[    0.068000] ..... calibration result: 1000647
[    0.068000] ..... CPU clock speed is 2695.0006 MHz.
[    0.068000] ..... host bus clock speed is 1000.0647 MHz.
[    0.068294] Performance Events: unsupported Netburst CPU model 6 no PM=
U driver, software events only.
[    0.076448] NMI watchdog: disabled (cpu0): hardware events not enabled=

[    0.079135] x86: Booting SMP configuration:
[    0.080066] .... node  #0, CPUs:      #1
[    0.076379] kvm-clock: cpu 1, msr 1:1ff55041, secondary cpu clock
[    0.076379] masked ExtINT on CPU#1
[    0.094201] KVM setup async PF for cpu 1
[    0.095000] kvm-stealtime: cpu 1, msr 11fc8e000
[    0.094395]  #2
[    0.094395] kvm-clock: cpu 2, msr 1:1ff55081, secondary cpu clock
[    0.094395] masked ExtINT on CPU#2
[    0.108118] KVM setup async PF for cpu 2
[    0.109000]  #3
[    0.109000] kvm-stealtime: cpu 2, msr 11fd0e000
[    0.108195] kvm-clock: cpu 3, msr 1:1ff550c1, secondary cpu clock
[    0.108195] masked ExtINT on CPU#3
[    0.122039] x86: Booted up 1 node, 4 CPUs
[    0.122007] KVM setup async PF for cpu 3
[    0.122007] kvm-stealtime: cpu 3, msr 11fd8e000
[    0.124006] smpboot: Total of 4 processors activated (21547.87 BogoMIP=
S)
[    0.126242] devtmpfs: initialized
[    0.129617] evm: security.selinux
[    0.130002] evm: security.ima
[    0.130587] evm: security.capability
[    0.132882] atomic64_test: passed for x86-64 platform with CX8 and wit=
h SSE
[    0.134026] NET: Registered protocol family 16
[    0.135062] cpuidle: using governor menu
[    0.136013] ACPI: bus type PCI registered
[    0.136721] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.137145] PCI: Using configuration type 1 for base access
[    0.144024] ACPI: Added _OSI(Module Device)
[    0.144913] ACPI: Added _OSI(Processor Device)
[    0.145027] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.146007] ACPI: Added _OSI(Processor Aggregator Device)
[    0.150585] ACPI: Interpreter enabled
[    0.151057] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S1_] (20140424/hwxface-580)
[    0.153032] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20140424/hwxface-580)
[    0.155046] ACPI: (supports S0 S3 S4 S5)
[    0.155742] ACPI: Using IOAPIC for interrupt routing
[    0.156121] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.159449] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.160014] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments =
MSI]
[    0.161011] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASP=
M
[    0.162104] acpi PNP0A03:00: fail to add MMCONFIG information, can't a=
ccess extended PCI configuration space under this bridge.
[    0.163305] acpiphp: Slot [3] registered
[    0.164022] acpiphp: Slot [4] registered
[    0.164729] acpiphp: Slot [5] registered
[    0.165021] acpiphp: Slot [6] registered
[    0.166021] acpiphp: Slot [7] registered
[    0.167028] acpiphp: Slot [8] registered
[    0.167728] acpiphp: Slot [9] registered
[    0.168026] acpiphp: Slot [10] registered
[    0.169021] acpiphp: Slot [11] registered
[    0.169790] acpiphp: Slot [12] registered
[    0.170151] acpiphp: Slot [13] registered
[    0.171131] acpiphp: Slot [14] registered
[    0.172116] acpiphp: Slot [15] registered
[    0.173145] acpiphp: Slot [24] registered
[    0.174021] acpiphp: Slot [25] registered
[    0.174742] acpiphp: Slot [26] registered
[    0.175021] acpiphp: Slot [27] registered
[    0.176029] acpiphp: Slot [28] registered
[    0.177021] acpiphp: Slot [29] registered
[    0.177733] acpiphp: Slot [30] registered
[    0.178028] acpiphp: Slot [31] registered
[    0.179017] PCI host bridge to bus 0000:00
[    0.179728] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.180007] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.181003] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.182003] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.183013] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebff=
fff]
[    0.184103] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.186625] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.188244] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.191800] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.193816] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-=
0x01f7]
[    0.194003] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]=

[    0.195002] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-=
0x0177]
[    0.196002] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]=

[    0.198055] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.199248] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PI=
IX4 ACPI
[    0.200011] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PI=
IX4 SMB
[    0.201193] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.203625] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pre=
f]
[    0.205039] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.212785] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pre=
f]
[    0.214405] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.216003] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.218006] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.224006] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pre=
f]
[    0.225183] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.227003] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.229003] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.235273] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.237003] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.239003] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.247321] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.250005] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.252032] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.260786] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.262007] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.265004] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.273143] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.275654] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.277004] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.283269] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.285003] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.287003] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.293257] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.294536] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.299468] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.300734] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.302079] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.303368] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.304604] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.305861] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.307217] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.308004] vgaarb: loaded
[    0.309002] vgaarb: bridge control possible 0000:00:02.0
[    0.310223] SCSI subsystem initialized
[    0.311045] ACPI: bus type USB registered
[    0.311784] usbcore: registered new interface driver usbfs
[    0.312024] usbcore: registered new interface driver hub
[    0.313112] usbcore: registered new device driver usb
[    0.314043] pps_core: LinuxPPS API ver. 1 registered
[    0.315002] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    0.316011] PTP clock support registered
[    0.317122] PCI: Using ACPI for IRQ routing
[    0.318007] PCI: pci_cache_line_size set to 64 bytes
[    0.319173] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.320005] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[    0.321210] NetLabel: Initializing
[    0.322004] NetLabel:  domain hash size =3D 128
[    0.322730] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.323022] NetLabel:  unlabeled traffic allowed by default
[    0.324182] HPET: 3 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.325020] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.326569] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.346025] Switched to clocksource kvm-clock
[    0.361632] pnp: PnP ACPI init
[    0.362257] ACPI: bus type PNP registered
[    0.362975] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:15)
[    0.364318] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.365295] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:15)
[    0.366622] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)=

[    0.367589] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:15)
[    0.368935] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)=

[    0.369909] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:15)
[    0.371227] pnp 00:03: [dma 2]
[    0.371818] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)=

[    0.372797] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:15)
[    0.374142] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)=

[    0.375123] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:15)
[    0.376445] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.377423] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:15)
[    0.378748] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.379834] pnp: PnP ACPI: found 7 devices
[    0.380533] ACPI: bus type PNP unregistered
[    0.390391] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.391242] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.392082] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.392974] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.393933] NET: Registered protocol family 2
[    0.394896] TCP established hash table entries: 32768 (order: 6, 26214=
4 bytes)
[    0.396323] TCP bind hash table entries: 32768 (order: 7, 524288 bytes=
)
[    0.397613] TCP: Hash tables configured (established 32768 bind 32768)=

[    0.398676] TCP: reno registered
[    0.399380] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.400460] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.401518] NET: Registered protocol family 1
[    0.402511] RPC: Registered named UNIX socket transport module.
[    0.403401] RPC: Registered udp transport module.
[    0.404155] RPC: Registered tcp transport module.
[    0.404889] RPC: Registered tcp NFSv4.1 backchannel transport module

--------------000404020508090904030204--
