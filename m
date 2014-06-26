Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbaFZCDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:03:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:16445 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828AbaFZCDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:03:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,548,1400050800"; 
   d="scan'208";a="553412919"
Date: Thu, 26 Jun 2014 10:03:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Jet Chen <jet.chen@intel.com>
Subject: [block] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000028
Message-ID: <20140626020329.GF12239@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Tejun,

In commit 09571194a9846177bea3afd18458312546112702 ("block, blk-mq:
draining can't be skipped even if bypass_depth was non-zero")

+------------------------------------------------------+------------+------------+
|                                                      | f5372ab3d2 | 09571194a9 |
+------------------------------------------------------+------------+------------+
| boot_successes                                       | 25         | 19         |
| early-boot-hang                                      | 1          |            |
| boot_failures                                        | 0          | 6          |
| BUG:kernel_test_crashed                              | 0          | 1          |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference | 0          | 5          |
| Oops                                                 | 0          | 5          |
| RIP:blk_throtl_drain                                 | 0          | 5          |
| kernel_BUG_at_arch/x86/mm/pageattr.c                 | 0          | 5          |
| invalid_opcode                                       | 0          | 5          |
| RIP:change_page_attr_set_clr                         | 0          | 5          |
| Kernel_panic-not_syncing:Fatal_exception             | 0          | 5          |
| backtrace:scsi_debug_exit                            | 0          | 5          |
| backtrace:SyS_delete_module                          | 0          | 5          |
+------------------------------------------------------+------------+------------+


[ 5703.793032]  sda: unknown partition table
[ 5703.798102] sd 2:0:0:0: [sda] Attached SCSI disk
[ 5706.076059] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[ 5706.078586] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[ 5706.079351] IP: [<ffffffff813cdbb0>] blk_throtl_drain+0x30/0x150
[ 5706.079351] PGD 0 
[ 5706.079351] Oops: 0000 [#1] SMP 
[ 5706.079351] Modules linked in: sd_mod scsi_debug(-) crct10dif_generic crc_t10dif crct10dif_common loop dm_mod fuse sg sr_mod cdrom ata_generic pata_acpi parport_pc parport snd_pcm floppy cirrus syscopyarea sysfillrect sysimgblt ttm drm_kms_helper snd_timer snd soundcore drm pcspkr ata_piix libata i2c_piix4
[ 5706.079351] CPU: 3 PID: 22026 Comm: rmmod Not tainted 3.16.0-rc1-wl-00737-g114249b #1
[ 5706.079351] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 5706.079351] task: ffff8801155f1d80 ti: ffff880100e9c000 task.ti: ffff880100e9c000
[ 5706.079351] RIP: 0010:[<ffffffff813cdbb0>]  [<ffffffff813cdbb0>] blk_throtl_drain+0x30/0x150
[ 5706.079351] RSP: 0018:ffff880100e9fb60  EFLAGS: 00010046
[ 5706.079351] RAX: 0000000000000000 RBX: ffff88007f8b2eb0 RCX: ffff8800974c77a0
[ 5706.079351] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 5706.079351] RBP: ffff880100e9fb78 R08: 0000000000000000 R09: 0000000000000046
[ 5706.079351] R10: ffff880100e9fb78 R11: 0000000000000000 R12: ffff88007f8b2eb0
[ 5706.079351] R13: ffff8800863ef300 R14: ffff88007f8b3508 R15: ffff88008a3c2120
[ 5706.079351] FS:  00007fac6a962700(0000) GS:ffff88011fd80000(0000) knlGS:0000000000000000
[ 5706.079351] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5706.079351] CR2: 0000000000000028 CR3: 0000000110261000 CR4: 00000000000006e0
[ 5706.079351] Stack:
[ 5706.079351]  ffff88007f8b2eb0 0000000000000000 ffff88007f8b3518 ffff880100e9fb88
[ 5706.079351]  ffffffff813cabee ffff880100e9fbb8 ffffffff813afcec ffff88007f8b2eb0
[ 5706.079351]  ffffffff81cf8760 ffff88007f8b2eb0 ffff88008a3c2000 ffff880100e9fbd0
[ 5706.079351] Call Trace:
[ 5706.079351]  [<ffffffff813cabee>] blkcg_drain_queue+0xe/0x10
[ 5706.079351]  [<ffffffff813afcec>] __blk_drain_queue+0x7c/0x180
[ 5706.079351]  [<ffffffff813afe7e>] blk_queue_bypass_start+0x8e/0xd0
[ 5706.079351]  [<ffffffff813c9d98>] blkcg_deactivate_policy+0x38/0x140
[ 5706.079351]  [<ffffffff813cde04>] blk_throtl_exit+0x34/0x50
[ 5706.079351]  [<ffffffff813cac38>] blkcg_exit_queue+0x48/0x70
[ 5706.079351]  [<ffffffff813b3546>] blk_release_queue+0x26/0x100
[ 5706.079351]  [<ffffffff813dbd17>] kobject_cleanup+0x77/0x1b0
[ 5706.079351]  [<ffffffff813dbbc8>] kobject_put+0x28/0x60
[ 5706.079351]  [<ffffffff813acb85>] blk_put_queue+0x15/0x20
[ 5706.079351]  [<ffffffff8151ed0b>] scsi_device_dev_release_usercontext+0xbb/0x120
[ 5706.079351]  [<ffffffff810876c7>] execute_in_process_context+0x67/0x70
[ 5706.079351]  [<ffffffff8151ec4c>] scsi_device_dev_release+0x1c/0x20
[ 5706.079351]  [<ffffffff814ddc02>] device_release+0x32/0xa0
[ 5706.079351]  [<ffffffff813dbd17>] kobject_cleanup+0x77/0x1b0
[ 5706.079351]  [<ffffffff813dbbc8>] kobject_put+0x28/0x60
[ 5706.079351]  [<ffffffff814ddef7>] put_device+0x17/0x20
[ 5706.079351]  [<ffffffff8151f759>] __scsi_remove_device+0xa9/0xe0
[ 5706.079351]  [<ffffffff8151dd04>] scsi_forget_host+0x64/0x70
[ 5706.079351]  [<ffffffff81512207>] scsi_remove_host+0x77/0x120
[ 5706.079351]  [<ffffffffa01c75a9>] sdebug_driver_remove+0x29/0x90 [scsi_debug]
[ 5706.079351]  [<ffffffff814e218f>] __device_release_driver+0x7f/0xf0
[ 5706.079351]  [<ffffffff814e2223>] device_release_driver+0x23/0x30
[ 5706.079351]  [<ffffffff814e1b28>] bus_remove_device+0x108/0x180
[ 5706.079351]  [<ffffffff814de429>] device_del+0x129/0x1c0
[ 5706.079351]  [<ffffffff814de4de>] device_unregister+0x1e/0x60
[ 5706.079351]  [<ffffffffa01c6efc>] sdebug_remove_adapter+0x4c/0x70 [scsi_debug]
[ 5706.079351]  [<ffffffffa01cb52d>] scsi_debug_exit+0x19/0xaec [scsi_debug]
[ 5706.079351]  [<ffffffff810ea4fe>] SyS_delete_module+0x12e/0x1c0
[ 5706.079351]  [<ffffffff818363a2>] ? int_signal+0x12/0x17
[ 5706.079351]  [<ffffffff818360e9>] system_call_fastpath+0x16/0x1b
[ 5706.079351] Code: 55 65 ff 04 25 a0 c7 00 00 48 89 e5 41 55 41 54 49 89 fc 53 4c 8b af 40 07 00 00 49 8b 85 a0 00 00 00 31 ff 48 8b 80 c8 05 00 00 <48> 8b 70 28 e8 f7 9b d2 ff 48 85 c0 48 89 c3 74 61 0f 1f 80 00 
[ 5706.079351] RIP  [<ffffffff813cdbb0>] blk_throtl_drain+0x30/0x150
[ 5706.079351]  RSP <ffff880100e9fb60>
[ 5706.079351] CR2: 0000000000000028
[ 5706.079351] ------------[ cut here ]------------

Thanks,
Fengguang

--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce
Content-Transfer-Encoding: quoted-printable

mkfs -t xfs /dev/vdd
mkfs -t xfs /dev/vda
mkfs -t xfs /dev/vdb
mkfs -t xfs /dev/vdc
mount -t xfs -o nobarrier,inode64 /dev/vda /fs/vda
mount -t xfs -o nobarrier,inode64 /dev/vdb /fs/vdb
mount -t xfs -o nobarrier,inode64 /dev/vdc /fs/vdc
mount -t xfs -o nobarrier,inode64 /dev/vdd /fs/vdd
export TEST_DIR=3D/fs/vda
export TEST_DEV=3D/dev/vda
export SCRATCH_MNT=3D/fs/scratch
mkdir /fs/scratch -p
export SCRATCH_DEV=3D/dev/vdd
export SCRATCH_LOGDEV=3D/dev/vdb
=2E/check xfs/003 xfs/004 xfs/008 xfs/009 xfs/012 xfs/017 xfs/019 xfs/021 x=
fs/022 xfs/023 xfs/024 xfs/025 xfs/026 xfs/027 xfs/028 xfs/029 xfs/030 xfs/=
031 xfs/033 xfs/034 xfs/035 xfs/036 xfs/037 xfs/038 xfs/039 xfs/040 xfs/041=
 xfs/042 xfs/043 xfs/044 xfs/045 xfs/046 xfs/047 xfs/048 xfs/049 xfs/050 xf=
s/052 xfs/054 xfs/055 xfs/056 xfs/057 xfs/058 xfs/059 xfs/060 xfs/061 xfs/0=
63 xfs/064 xfs/065 xfs/066 xfs/067 xfs/071 xfs/072 xfs/073 xfs/078 xfs/080 =
xfs/084 xfs/085 xfs/086 xfs/087 xfs/090 xfs/092 xfs/094 xfs/095 xfs/096 xfs=
/103 xfs/104 xfs/108 xfs/109 xfs/110 xfs/114 xfs/115 xfs/116 xfs/118 xfs/11=
9 xfs/121 xfs/122 xfs/134 xfs/137 xfs/138 xfs/139 xfs/140 xfs/142 xfs/143 x=
fs/144 xfs/145 xfs/146 xfs/147 xfs/148 xfs/149 xfs/150 xfs/151 xfs/152 xfs/=
153 xfs/154 xfs/155 xfs/156 xfs/157 xfs/158 xfs/159 xfs/160 xfs/161 xfs/162=
 xfs/163 xfs/164 xfs/165 xfs/166 xfs/167 xfs/168 xfs/170 xfs/173 xfs/174 xf=
s/175 xfs/176 xfs/177 xfs/179 xfs/180 xfs/181 xfs/182 xfs/183 xfs/185 xfs/1=
86 xfs/187 xfs/188 xfs/189 xfs/190 xfs/191 xfs/194 xfs/195 xfs/196 xfs/197 =
xfs/199 xfs/201 xfs/202 xfs/203 xfs/205 xfs/206 xfs/216 xfs/217 xfs/220 xfs=
/222 xfs/227 xfs/229 xfs/238 xfs/242 xfs/244 xfs/252 xfs/253 xfs/261 xfs/26=
2 xfs/266 xfs/267 xfs/268 xfs/278 xfs/279 xfs/281 xfs/282 xfs/283 xfs/287 x=
fs/290 xfs/291 xfs/298 xfs/299 xfs/300

--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc1-wl-00737-g114249b (kbuild@cairo) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Wed Jun 18 07:17:19 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-5/cyclic_x=
fstests-xfs-4HDD-xfs-xfs-HEAD-114249b348b0671b023b685e44e124b86a6693e5.yaml=
 ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/114249b348b0671b023b685e44e=
124b86a6693e5/vmlinuz-3.16.0-rc1-wl-00737-g114249b kconfig=3Dx86_64-rhel co=
mmit=3D114249b348b0671b023b685e44e124b86a6693e5 initrd=3D/kernel-tests/init=
rd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=3D/lkp/benchmarks/xfstests.cgz=
 modules_initrd=3D/kernel/x86_64-rhel/114249b348b0671b023b685e44e124b86a669=
3e5/modules.cgz max_uptime=3D19326 RESULT_ROOT=3D/result/vpx/xfstests/4HDD-=
xfs-xfs/x86_64-rhel/114249b348b0671b023b685e44e124b86a6693e5/0 ip=3D::::vpx=
-5::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_a=
lways_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D10 softlockup_pa=
nic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
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
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02144000, 0x02144fff] PGTABLE
[    0.000000] BRK [0x02145000, 0x02145fff] PGTABLE
[    0.000000] BRK [0x02146000, 0x02146fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02147000, 0x02147fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x77056000-0x7fffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x00000000DFFFE380 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x00000000DFFFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x00000000DFFFE3C0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x00000000DFFFFF40 000040
[    0.000000] ACPI: SSDT 0x00000000DFFFF6E0 000858 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x00000000DFFFF5B0 000090 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x00000000DFFFF570 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11ffd5000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ff55001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
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
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011fc00000 s87552 r8192=
 d23040 u524288
[    0.000000] pcpu-alloc: s87552 r8192 d23040 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0e000
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-5/c=
yclic_xfstests-xfs-4HDD-xfs-xfs-HEAD-114249b348b0671b023b685e44e124b86a6693=
e5.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/114249b348b0671b023b=
685e44e124b86a6693e5/vmlinuz-3.16.0-rc1-wl-00737-g114249b kconfig=3Dx86_64-=
rhel commit=3D114249b348b0671b023b685e44e124b86a6693e5 initrd=3D/kernel-tes=
ts/initrd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=3D/lkp/benchmarks/xfste=
sts.cgz modules_initrd=3D/kernel/x86_64-rhel/114249b348b0671b023b685e44e124=
b86a6693e5/modules.cgz max_uptime=3D19326 RESULT_ROOT=3D/result/vpx/xfstest=
s/4HDD-xfs-xfs/x86_64-rhel/114249b348b0671b023b685e44e124b86a6693e5/0 ip=3D=
::::vpx-5::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug =
sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D10 softlo=
ckup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 3896012K/4193904K available (8428K kernel code, 1650=
K rwdata, 3876K rodata, 1792K init, 1876K bss, 297892K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[    0.000000] NR_IRQS:524544 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc1-wl-00737-g114249b (kbuild@cairo) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Wed Jun 18 07:17:19 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-5/cyclic_x=
fstests-xfs-4HDD-xfs-xfs-HEAD-114249b348b0671b023b685e44e124b86a6693e5.yaml=
 ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/114249b348b0671b023b685e44e=
124b86a6693e5/vmlinuz-3.16.0-rc1-wl-00737-g114249b kconfig=3Dx86_64-rhel co=
mmit=3D114249b348b0671b023b685e44e124b86a6693e5 initrd=3D/kernel-tests/init=
rd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=3D/lkp/benchmarks/xfstests.cgz=
 modules_initrd=3D/kernel/x86_64-rhel/114249b348b0671b023b685e44e124b86a669=
3e5/modules.cgz max_uptime=3D19326 RESULT_ROOT=3D/result/vpx/xfstests/4HDD-=
xfs-xfs/x86_64-rhel/114249b348b0671b023b685e44e124b86a6693e5/0 ip=3D::::vpx=
-5::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_a=
lways_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D10 softlockup_pa=
nic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
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
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02144000, 0x02144fff] PGTABLE
[    0.000000] BRK [0x02145000, 0x02145fff] PGTABLE
[    0.000000] BRK [0x02146000, 0x02146fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02147000, 0x02147fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x77056000-0x7fffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x00000000DFFFE380 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x00000000DFFFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x00000000DFFFE3C0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x00000000DFFFFF40 000040
[    0.000000] ACPI: SSDT 0x00000000DFFFF6E0 000858 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x00000000DFFFF5B0 000090 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x00000000DFFFF570 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11ffd5000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ff55001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
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
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011fc00000 s87552 r8192=
 d23040 u524288
[    0.000000] pcpu-alloc: s87552 r8192 d23040 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0e000
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-5/c=
yclic_xfstests-xfs-4HDD-xfs-xfs-HEAD-114249b348b0671b023b685e44e124b86a6693=
e5.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/114249b348b0671b023b=
685e44e124b86a6693e5/vmlinuz-3.16.0-rc1-wl-00737-g114249b kconfig=3Dx86_64-=
rhel commit=3D114249b348b0671b023b685e44e124b86a6693e5 initrd=3D/kernel-tes=
ts/initrd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=3D/lkp/benchmarks/xfste=
sts.cgz modules_initrd=3D/kernel/x86_64-rhel/114249b348b0671b023b685e44e124=
b86a6693e5/modules.cgz max_uptime=3D19326 RESULT_ROOT=3D/result/vpx/xfstest=
s/4HDD-xfs-xfs/x86_64-rhel/114249b348b0671b023b685e44e124b86a6693e5/0 ip=3D=
::::vpx-5::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug =
sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D10 softlo=
ckup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 3896012K/4193904K available (8428K kernel code, 1650=
K rwdata, 3876K rodata, 1792K init, 1876K bss, 297892K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[    0.000000] NR_IRQS:524544 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.484 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5386.96 Bogo=
MIPS (lpj=3D2693484)
[    0.003006] pid_max: default: 32768 minimum: 301
[    0.003578] ACPI: Core revision 20140424
[    0.005290] ACPI: All ACPI Tables successfully acquired
[    0.006058] Security Framework initialized
[    0.007012] SELinux:  Initializing.
[    0.007664] SELinux:  Starting in permissive mode
[    0.008260] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.012096] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.014612] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.015011] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 b=
ytes)
[    0.017100] Initializing cgroup subsys memory
[    0.017864] Initializing cgroup subsys devices
[    0.018011] Initializing cgroup subsys freezer
[    0.019008] Initializing cgroup subsys net_cls
[    0.020010] Initializing cgroup subsys blkio
[    0.020745] Initializing cgroup subsys perf_event
[    0.021006] Initializing cgroup subsys hugetlb
[    0.022066] mce: CPU supports 10 MCE banks
[    0.023047] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023047] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.023047] tlb_flushall_shift: 6
[    0.024127] Freeing SMP alternatives memory: 32K (ffffffff81f65000 - fff=
fffff81f6d000)
[    0.029178] ftrace: allocating 30776 entries in 121 pages
[    0.036179] Getting VERSION: 50014
[    0.037009] Getting VERSION: 50014
[    0.038009] Getting ID: 0
[    0.038584] Getting ID: ff000000
[    0.039011] Getting LVT0: 8700
[    0.039636] Getting LVT1: 8400
[    0.040056] enabled ExtINT on CPU#0
[    0.042054] ENABLING IO-APIC IRQs
[    0.042682] init IO_APIC IRQs
[    0.043004]  apic 0 pin 0 not connected
[    0.044008] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.045017] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.046016] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.047016] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.048016] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.049016] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.050016] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.051015] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.052016] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.053016] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.054015] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.055016] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.056015] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.057016] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.058016] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.059014]  apic 0 pin 16 not connected
[    0.059708]  apic 0 pin 17 not connected
[    0.060002]  apic 0 pin 18 not connected
[    0.061003]  apic 0 pin 19 not connected
[    0.061701]  apic 0 pin 20 not connected
[    0.062002]  apic 0 pin 21 not connected
[    0.063003]  apic 0 pin 22 not connected
[    0.064004]  apic 0 pin 23 not connected
[    0.064840] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.065003] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.066677] Using local APIC timer interrupts.
[    0.066677] calibrating APIC timer ...
[    0.068000] ... lapic delta =3D 6249813
[    0.068000] ... PM-Timer delta =3D 357950
[    0.068000] ... PM-Timer result ok
[    0.068000] ..... delta 6249813
[    0.068000] ..... mult: 268427424
[    0.068000] ..... calibration result: 999970
[    0.068000] ..... CPU clock speed is 2693.0369 MHz.
[    0.068000] ..... host bus clock speed is 999.0970 MHz.
[    0.068062] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.071863] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.072202] x86: Booting SMP configuration:
[    0.073003] .... node  #0, CPUs:      #1
[    0.071841] kvm-clock: cpu 1, msr 1:1ff55041, secondary cpu clock
[    0.071841] masked ExtINT on CPU#1
[    0.086012] KVM setup async PF for cpu 1
[    0.087000]  #2
[    0.087000] kvm-stealtime: cpu 1, msr 11fc8e000
[    0.086026] kvm-clock: cpu 2, msr 1:1ff55081, secondary cpu clock
[    0.086026] masked ExtINT on CPU#2
[    0.099012] KVM setup async PF for cpu 2
[    0.099803]  #3
[    0.099804] kvm-stealtime: cpu 2, msr 11fd0e000
[    0.099025] kvm-clock: cpu 3, msr 1:1ff550c1, secondary cpu clock
[    0.099025] masked ExtINT on CPU#3
[    0.112025] x86: Booted up 1 node, 4 CPUs
[    0.112009] KVM setup async PF for cpu 3
[    0.112013] kvm-stealtime: cpu 3, msr 11fd8e000
[    0.114003] smpboot: Total of 4 processors activated (21547.87 BogoMIPS)
[    0.116170] devtmpfs: initialized
[    0.119134] evm: security.selinux
[    0.119777] evm: security.ima
[    0.120002] evm: security.capability
[    0.122213] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.123094] NET: Registered protocol family 16
[    0.124245] cpuidle: using governor menu
[    0.125242] ACPI: bus type PCI registered
[    0.126003] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.127115] PCI: Using configuration type 1 for base access
[    0.132041] ACPI: Added _OSI(Module Device)
[    0.132785] ACPI: Added _OSI(Processor Device)
[    0.133003] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.134002] ACPI: Added _OSI(Processor Aggregator Device)
[    0.136797] ACPI: Interpreter enabled
[    0.137007] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140424/hwxface-580)
[    0.139003] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140424/hwxface-580)
[    0.140520] ACPI: (supports S0 S3 S4 S5)
[    0.141002] ACPI: Using IOAPIC for interrupt routing
[    0.142016] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.145896] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.146008] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.147006] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.148085] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.150012] acpiphp: Slot [3] registered
[    0.150732] acpiphp: Slot [4] registered
[    0.151022] acpiphp: Slot [5] registered
[    0.152022] acpiphp: Slot [6] registered
[    0.152746] acpiphp: Slot [7] registered
[    0.153029] acpiphp: Slot [8] registered
[    0.154022] acpiphp: Slot [9] registered
[    0.155022] acpiphp: Slot [10] registered
[    0.155746] acpiphp: Slot [11] registered
[    0.156021] acpiphp: Slot [12] registered
[    0.157021] acpiphp: Slot [13] registered
[    0.158004] acpiphp: Slot [14] registered
[    0.158733] acpiphp: Slot [15] registered
[    0.159102] acpiphp: Slot [24] registered
[    0.160021] acpiphp: Slot [25] registered
[    0.161028] acpiphp: Slot [26] registered
[    0.161758] acpiphp: Slot [27] registered
[    0.162029] acpiphp: Slot [28] registered
[    0.163022] acpiphp: Slot [29] registered
[    0.163749] acpiphp: Slot [30] registered
[    0.164028] acpiphp: Slot [31] registered
[    0.165011] PCI host bridge to bus 0000:00
[    0.166004] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.167003] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.167939] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.168003] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.169003] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.171025] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.172245] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.173412] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.177277] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.179024] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.180003] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.181003] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.182003] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.183137] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.184297] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.185011] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.186183] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.189036] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.191636] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.199034] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.200412] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.202518] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.204520] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.210003] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.211189] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.213521] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.215522] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.221788] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.223521] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.225521] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.231785] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.233513] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.235511] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.242157] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.244003] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.246003] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.252269] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.254006] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.256003] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.262273] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.264003] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.266003] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.272254] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.274003] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.278593] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.280048] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.281075] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.282555] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.283705] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.285377] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.286287] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.287004] vgaarb: loaded
[    0.287578] vgaarb: bridge control possible 0000:00:02.0
[    0.288244] SCSI subsystem initialized
[    0.289066] ACPI: bus type USB registered
[    0.290041] usbcore: registered new interface driver usbfs
[    0.291029] usbcore: registered new interface driver hub
[    0.292135] usbcore: registered new device driver usb
[    0.293050] pps_core: LinuxPPS API ver. 1 registered
[    0.293864] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.294009] PTP clock support registered
[    0.295138] PCI: Using ACPI for IRQ routing
[    0.296008] PCI: pci_cache_line_size set to 64 bytes
[    0.297122] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.298006] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[    0.299222] NetLabel: Initializing
[    0.299875] NetLabel:  domain hash size =3D 128
[    0.300002] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.301019] NetLabel:  unlabeled traffic allowed by default
[    0.302192] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.303022] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.304580] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.311082] Switched to clocksource kvm-clock
[    0.328425] pnp: PnP ACPI init
[    0.329082] ACPI: bus type PNP registered
[    0.329848] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[    0.331261] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.332296] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[    0.333698] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.334711] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[    0.336135] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.337156] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[    0.338533] pnp 00:03: [dma 2]
[    0.339169] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.340193] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[    0.341599] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.342629] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[    0.344036] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.345061] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:15)
[    0.346450] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.347597] pnp: PnP ACPI: found 7 devices
[    0.348332] ACPI: bus type PNP unregistered
[    0.358444] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.359342] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.360233] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.361194] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.362223] NET: Registered protocol family 2
[    0.363313] TCP established hash table entries: 32768 (order: 6, 262144 =
bytes)
[    0.364831] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.366174] TCP: Hash tables configured (established 32768 bind 32768)
[    0.367264] TCP: reno registered
[    0.367903] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.368898] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.370043] NET: Registered protocol family 1
[    0.371031] RPC: Registered named UNIX socket transport module.
[    0.371949] RPC: Registered udp transport module.
[    0.372741] RPC: Registered tcp transport module.
[    0.373536] RPC: Registered tcp NFSv4.1 backchannel transport module
--EuxKj2iCbKjpUGkD--
