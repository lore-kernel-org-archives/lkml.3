Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaISBll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 21:41:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:50391 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaISBld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 21:41:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,551,1406617200"; 
   d="log'?scan'208";a="593589482"
Date: Fri, 19 Sep 2014 09:41:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Frank Schaefer <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [media/em28xx] BUG: unable to handle kernel
Message-ID: <20140919014124.GA8326@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

commit a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f
Author:     Frank Schaefer <fschaefer.oss@googlemail.com>
AuthorDate: Mon Mar 24 16:33:25 2014 -0300
Commit:     Mauro Carvalho Chehab <m.chehab@samsung.com>
CommitDate: Fri May 23 13:44:42 2014 -0300

    [media] em28xx: move fields wq_trigger and streaming_started from struct em28xx to struct em28xx_audio
    
    Both wq_trigger and stream_started are used only to control the em28xx
    alsa streaming. They don't belong to em28xx common struct.
    
    Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Attached dmesg for the parent commit, too. It looks like the parent is
actually clean, just that the rcu-tortuture tests take too long time.

+------------------------------------------+------------+------------+---------------+
|                                          | 3319e6f839 | a5c075cfd2 | next-20140917 |
+------------------------------------------+------------+------------+---------------+
| boot_successes                           | 0          | 0          | 0             |
| boot_failures                            | 80         | 20         | 11            |
| BUG:kernel_boot_hang                     | 80         | 1          | 1             |
| BUG:unable_to_handle_kernel              | 0          | 19         | 10            |
| Oops                                     | 0          | 19         | 10            |
| EIP_is_at_af9005_usb_module_init         | 0          | 19         | 10            |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 19         | 10            |
| backtrace:af9005_usb_module_init         | 0          | 19         | 10            |
| backtrace:kernel_init_freeable           | 0          | 19         | 10            |
| backtrace:_usb_module_init               | 0          | 19         | 10            |
+------------------------------------------+------------+------------+---------------+

[    8.528015] usbcore: registered new interface driver dvb_usb_ttusb2
[    8.529751] usbcore: registered new interface driver dvb_usb_af9005
[    8.529751] usbcore: registered new interface driver dvb_usb_af9005
[    8.531584] BUG: unable to handle kernel 
[    8.531584] BUG: unable to handle kernel paging requestpaging request at 02e00000
 at 02e00000
[    8.533385] IP:
[    8.533385] IP: [<7d9d67c6>] af9005_usb_module_init+0x6b/0x9d
 [<7d9d67c6>] af9005_usb_module_init+0x6b/0x9d
[    8.535613] *pde = 00000000 
[    8.535613] *pde = 00000000 

[    8.536416] Oops: 0000 [#1] 
[    8.536416] Oops: 0000 [#1] PREEMPT PREEMPT DEBUG_PAGEALLOCDEBUG_PAGEALLOC

[    8.537863] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc6-00151-ga5c075c #1
[    8.537863] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc6-00151-ga5c075c #1
[    8.539827] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    8.539827] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    8.541519] task: 89c9a670 ti: 89c9c000 task.ti: 89c9c000
[    8.541519] task: 89c9a670 ti: 89c9c000 task.ti: 89c9c000
[    8.541519] EIP: 0060:[<7d9d67c6>] EFLAGS: 00010206 CPU: 0
[    8.541519] EIP: 0060:[<7d9d67c6>] EFLAGS: 00010206 CPU: 0
[    8.541519] EIP is at af9005_usb_module_init+0x6b/0x9d
[    8.541519] EIP is at af9005_usb_module_init+0x6b/0x9d
[    8.541519] EAX: 02e00000 EBX: 00000000 ECX: 00000006 EDX: 00000000
[    8.541519] EAX: 02e00000 EBX: 00000000 ECX: 00000006 EDX: 00000000
[    8.541519] ESI: 00000000 EDI: 7da33ec8 EBP: 89c9df30 ESP: 89c9df2c
[    8.541519] ESI: 00000000 EDI: 7da33ec8 EBP: 89c9df30 ESP: 89c9df2c
[    8.541519]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    8.541519]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    8.541519] CR0: 8005003b CR2: 02e00000 CR3: 05a54000 CR4: 00000690
[    8.541519] CR0: 8005003b CR2: 02e00000 CR3: 05a54000 CR4: 00000690
[    8.541519] Stack:
[    8.541519] Stack:
[    8.541519]  7d9d675b
[    8.541519]  7d9d675b 89c9df90 89c9df90 7d992a49 7d992a49 7d7d5914 7d7d5914 89c9df4c 89c9df4c 7be3a800 7be3a800 7d08c58c 7d08c58c 8a4c3968 8a4c3968

[    8.541519]  89c9df80
[    8.541519]  89c9df80 7be3a966 7be3a966 00000192 00000192 00000006 00000006 00000006 00000006 7d7d3ff4 7d7d3ff4 8a4c397a 8a4c397a 00000200 00000200

[    8.541519]  7d6b1280
[    8.541519]  7d6b1280 8a4c3979 8a4c3979 00000006 00000006 000009a6 000009a6 7da32db8 7da32db8 b13eec81 b13eec81 00000006 00000006 000009a6 000009a6

[    8.541519] Call Trace:
[    8.541519] Call Trace:
[    8.541519]  [<7d9d675b>] ? ttusb2_driver_init+0x16/0x16
[    8.541519]  [<7d9d675b>] ? ttusb2_driver_init+0x16/0x16
[    8.541519]  [<7d992a49>] do_one_initcall+0x77/0x106
[    8.541519]  [<7d992a49>] do_one_initcall+0x77/0x106
[    8.541519]  [<7be3a800>] ? parameqn+0x2/0x35
[    8.541519]  [<7be3a800>] ? parameqn+0x2/0x35
[    8.541519]  [<7be3a966>] ? parse_args+0x113/0x25c
[    8.541519]  [<7be3a966>] ? parse_args+0x113/0x25c
[    8.541519]  [<7d992bc2>] kernel_init_freeable+0xea/0x167
[    8.541519]  [<7d992bc2>] kernel_init_freeable+0xea/0x167
[    8.541519]  [<7cf01070>] kernel_init+0x8/0xb8
[    8.541519]  [<7cf01070>] kernel_init+0x8/0xb8
[    8.541519]  [<7cf27ec0>] ret_from_kernel_thread+0x20/0x30
[    8.541519]  [<7cf27ec0>] ret_from_kernel_thread+0x20/0x30
[    8.541519]  [<7cf01068>] ? rest_init+0x10c/0x10c
[    8.541519]  [<7cf01068>] ? rest_init+0x10c/0x10c
[    8.541519] Code:
[    8.541519] Code: 08 08 c2 c2 c7 c7 05 05 44 44 ed ed f9 f9 7d 7d 00 00 00 00 e0 e0 02 02 c7 c7 05 05 40 40 ed ed f9 f9 7d 7d 00 00 00 00 e0 e0 02 02 c7 c7 05 05 3c 3c ed ed f9 f9 7d 7d 00 00 00 00 e0 e0 02 02 75 75 1f 1f b8 b8 00 00 00 00 e0 e0 02 02 85 85 c0 c0 74 74 16 16 <a1> <a1> 00 00 00 00 e0 e0 02 02 c7 c7 05 05 54 54 84 84 8e 8e 7d 7d 00 00 00 00 e0 e0 02 02 a3 a3 58 58 84 84 8e 8e 7d 7d eb eb

[    8.541519] EIP: [<7d9d67c6>] 
[    8.541519] EIP: [<7d9d67c6>] af9005_usb_module_init+0x6b/0x9daf9005_usb_module_init+0x6b/0x9d SS:ESP 0068:89c9df2c
 SS:ESP 0068:89c9df2c
[    8.541519] CR2: 0000000002e00000
[    8.541519] CR2: 0000000002e00000
[    8.541519] ---[ end trace 768b6faf51370fc7 ]---
[    8.541519] ---[ end trace 768b6faf51370fc7 ]---

git bisect start v3.16 v3.15 --
git bisect  bad 5170a3b24a9141e2349a3420448743b7c68f2223  # 22:58      0-      1  Merge branch 'akpm' (patches from Andrew Morton)
git bisect  bad 1ad96bb0a20fa26b952b2250e89d14b6397bf618  # 23:04      0-      1  Merge tag 'gpio-v3.16-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
git bisect  bad 412dd3a6daf0cadce1b2d6a34fa3713f40255579  # 23:16      0-      1  Merge tag 'xfs-for-linus-3.16-rc1' of git://oss.sgi.com/xfs/xfs
git bisect  bad b1cce8032f6abe900b078d24f3c3938726528f97  # 23:23      0-      2  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
git bisect  bad da85d191f58a44e149a7c07dbae78b3042909798  # 23:29      0-     19  Merge branch 'for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
git bisect  bad f8409abdc592e13cefbe4e4a24a84b3d5741e85f  # 23:38      0-      6  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
git bisect  bad ed81e780a7dd5698a986f246fad6a1d8d0b6f9ce  # 23:44      0-     20  Merge branch 'x86-vdso-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 3f17ea6dea8ba5668873afa54628a91aaa3fb1c0  # 23:55      1-     19  Merge branch 'next' (accumulated 3.16 merge window patches) into master
git bisect good 49eb7b0750d9483c74e9c14ae6ea1e9d62481c3c  # 00:38     20+     20  Merge tag 'tty-3.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty into next
git bisect  bad 535ec214e23adaf72c775938e9e9c6c1cf6fc5b9  # 07:40      0-      2  [media] mt9p031: Fix BLC configuration restore when disabling test pattern
git bisect good 2c52a2fce0f00479548a076d900d1a2ddd001c27  # 21:01     20+     20  [media] em28xx: move struct v4l2_clk *clk from struct em28xx to struct v4l2
git bisect  bad a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f  # 22:07      0-      9  [media] em28xx: move fields wq_trigger and streaming_started from struct em28xx to struct em28xx_audio
git bisect good 58159171c7f201e5d6ea2666c7b3857e782a2861  # 22:52     20+     20  [media] em28xx: move progressive/interlaced fields from struct em28xx to struct v4l2
git bisect good 3854b0d847d558bdc820b93ae8a93c0923d0211d  # 23:31     20+     20  [media] em28xx: move tuner frequency field from struct em28xx to struct v4l2
git bisect good 3319e6f839cf94e33fbad27a21fc4c64f6cec74f  # 00:14     20+     20  [media] em28xx: remove field tuner_addr from struct em28xx
# first bad commit: [a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f] [media] em28xx: move fields wq_trigger and streaming_started from struct em28xx to struct em28xx_audio
git bisect good 3319e6f839cf94e33fbad27a21fc4c64f6cec74f  # 00:55     60+     80  [media] em28xx: remove field tuner_addr from struct em28xx
git bisect  bad 76c2c6dc46fbb5bdd73571ebd0897696c5ab4d73  # 00:58      0-     11  Add linux-next specific files for 20140917
git bisect  bad 4d046e96046faac456f4f5c94c152c52a9c51a3a  # 01:09      2-     57  Add linux-next specific files for 20140918


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-i386.cgz

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

--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-94:20140918220711:i386-randconfig-ib1-09172043::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc6-00151-ga5c075c (kbuild@lkp-ib03) (g=
cc version 4.9.1 (Debian 4.9.1-11) ) #1 PREEMPT Thu Sep 18 21:24:15 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[780f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] initial memory mapped: [mem 0x00000000-0x067fffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 4k
[    0.000000] BRK [0x05fd8000, 0x05fd8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
[    0.000000] BRK [0x05fd9000, 0x05fd9fff] PGTABLE
[    0.000000] BRK [0x05fda000, 0x05fdafff] PGTABLE
[    0.000000] BRK [0x05fdb000, 0x05fdbfff] PGTABLE
[    0.000000] BRK [0x05fdc000, 0x05fdcfff] PGTABLE
[    0.000000] BRK [0x05fdd000, 0x05fddfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13fdffff]
[    0.000000]  [mem 0x12400000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x1279b000-0x13fdffff]
[    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE1885 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1279a001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13fdffff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat 7d98b340, node_mem_map 8a=
4c9024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77792 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 57f3200
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81070
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-ib1-09172043/next:master:a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f=
:bisect-linux-1/.vmlinuz-a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f-201409182=
12424-19-ivb41 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ib=
1-09172043/a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f/vmlinuz-3.15.0-rc6-0015=
1-ga5c075c drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 264020K/327160K available (17571K kernel code, 1739K=
 rwdata, 8912K rodata, 764K init, 5552K bss, 63140K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x8c7e0000 - 0xff7fe000   (1840 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x8bfe0000   ( 319 MB)
[    0.000000]       .init : 0x7d992000 - 0x7da51000   ( 764 kB)
[    0.000000]       .data : 0x7cf29007 - 0x7d990de0   (10655 kB)
[    0.000000]       .text : 0x7be00000 - 0x7cf29007   (17572 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D89c18000 soft=3D89c1a000
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc6-00151-ga5c075c (kbuild@lkp-ib03) (g=
cc version 4.9.1 (Debian 4.9.1-11) ) #1 PREEMPT Thu Sep 18 21:24:15 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[780f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] initial memory mapped: [mem 0x00000000-0x067fffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 4k
[    0.000000] BRK [0x05fd8000, 0x05fd8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
[    0.000000] BRK [0x05fd9000, 0x05fd9fff] PGTABLE
[    0.000000] BRK [0x05fda000, 0x05fdafff] PGTABLE
[    0.000000] BRK [0x05fdb000, 0x05fdbfff] PGTABLE
[    0.000000] BRK [0x05fdc000, 0x05fdcfff] PGTABLE
[    0.000000] BRK [0x05fdd000, 0x05fddfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13fdffff]
[    0.000000]  [mem 0x12400000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x1279b000-0x13fdffff]
[    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE1885 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1279a001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13fdffff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat 7d98b340, node_mem_map 8a=
4c9024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77792 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 57f3200
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81070
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-ib1-09172043/next:master:a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f=
:bisect-linux-1/.vmlinuz-a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f-201409182=
12424-19-ivb41 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ib=
1-09172043/a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f/vmlinuz-3.15.0-rc6-0015=
1-ga5c075c drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 264020K/327160K available (17571K kernel code, 1739K=
 rwdata, 8912K rodata, 764K init, 5552K bss, 63140K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x8c7e0000 - 0xff7fe000   (1840 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x8bfe0000   ( 319 MB)
[    0.000000]       .init : 0x7d992000 - 0x7da51000   ( 764 kB)
[    0.000000]       .data : 0x7cf29007 - 0x7d990de0   (10655 kB)
[    0.000000]       .text : 0x7be00000 - 0x7cf29007   (17572 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D89c18000 soft=3D89c1a000
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D26935080)
5387.01 BogoMIPS (lpj=3D26935080)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020059] ACPI: Core revision 20140214
[    0.020059] ACPI: Core revision 20140214
[    0.033756] ACPI:=20
[    0.033756] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.040088] ACPI: setting ELCR to 0200 (from 0c00)
[    0.040088] ACPI: setting ELCR to 0200 (from 0c00)
[    0.041551] Security Framework initialized
[    0.041551] Security Framework initialized
[    0.042730] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.042730] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.050012] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.050012] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.056770] Initializing cgroup subsys debug
[    0.056770] Initializing cgroup subsys debug
[    0.057950] Initializing cgroup subsys devices
[    0.057950] Initializing cgroup subsys devices
[    0.059171] Initializing cgroup subsys net_cls
[    0.059171] Initializing cgroup subsys net_cls
[    0.060013] Initializing cgroup subsys blkio
[    0.060013] Initializing cgroup subsys blkio
[    0.064186] Initializing cgroup subsys net_prio
[    0.064186] Initializing cgroup subsys net_prio
[    0.065524] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.065524] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.065524] tlb_flushall_shift: 6
[    0.065524] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.065524] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.065524] tlb_flushall_shift: 6
[    0.070007] CPU:=20
[    0.070007] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.091322] Performance Events:=20
[    0.091322] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.099846] Getting VERSION: 1050014
[    0.099846] Getting VERSION: 1050014
[    0.100013] Getting VERSION: 1050014
[    0.100013] Getting VERSION: 1050014
[    0.104001] Getting ID: 0
[    0.104001] Getting ID: 0
[    0.104724] Getting ID: f000000
[    0.104724] Getting ID: f000000
[    0.105586] Getting LVT0: 8700
[    0.105586] Getting LVT0: 8700
[    0.106423] Getting LVT1: 8400
[    0.106423] Getting LVT1: 8400
[    0.107280] enabled ExtINT on CPU#0
[    0.107280] enabled ExtINT on CPU#0
[    0.108231] Using local APIC timer interrupts.
[    0.108231] calibrating APIC timer ...
[    0.108231] Using local APIC timer interrupts.
[    0.108231] calibrating APIC timer ...
[    0.120000] ... lapic delta =3D 5960778
[    0.120000] ... lapic delta =3D 5960778
[    0.120000] ... PM-Timer delta =3D 341388
[    0.120000] ... PM-Timer delta =3D 341388
[    0.120000] APIC calibration not consistent with PM-Timer: 95ms instead =
of 100ms
[    0.120000] APIC calibration not consistent with PM-Timer: 95ms instead =
of 100ms
[    0.120000] APIC delta adjusted to PM-Timer: 6250027 (5960778)
[    0.120000] APIC delta adjusted to PM-Timer: 6250027 (5960778)
[    0.120000] TSC delta adjusted to PM-Timer: 269346843 (256881555)
[    0.120000] TSC delta adjusted to PM-Timer: 269346843 (256881555)
[    0.120000] ..... delta 6250027
[    0.120000] ..... delta 6250027
[    0.120000] ..... mult: 268436615
[    0.120000] ..... mult: 268436615
[    0.120000] ..... calibration result: 10000043
[    0.120000] ..... calibration result: 10000043
[    0.120000] ..... CPU clock speed is 2693.4684 MHz.
[    0.120000] ..... CPU clock speed is 2693.4684 MHz.
[    0.120000] ..... host bus clock speed is 1000.0043 MHz.
[    0.120000] ..... host bus clock speed is 1000.0043 MHz.
[    0.120758] devtmpfs: initialized
[    0.120758] devtmpfs: initialized
[    0.124782] evm: security.selinux
[    0.124782] evm: security.selinux
[    0.125571] evm: security.SMACK64
[    0.125571] evm: security.SMACK64
[    0.126324] evm: security.capability
[    0.126324] evm: security.capability
[    0.129772] xor: measuring software checksum speed
[    0.129772] xor: measuring software checksum speed
[    0.230009]    pIII_sse  :  7256.800 MB/sec
[    0.230009]    pIII_sse  :  7256.800 MB/sec
[    0.330009]    prefetch64-sse:  9022.000 MB/sec
[    0.330009]    prefetch64-sse:  9022.000 MB/sec
[    0.331207] xor: using function: prefetch64-sse (9022.000 MB/sec)
[    0.331207] xor: using function: prefetch64-sse (9022.000 MB/sec)
[    0.332845] pinctrl core: initialized pinctrl subsystem
[    0.332845] pinctrl core: initialized pinctrl subsystem
[    0.335096] regulator-dummy: no parameters
[    0.335096] regulator-dummy: no parameters
[    0.336698] NET: Registered protocol family 16
[    0.336698] NET: Registered protocol family 16
[    0.341036] cpuidle: using governor ladder
[    0.341036] cpuidle: using governor ladder
[    0.342159] cpuidle: using governor menu
[    0.342159] cpuidle: using governor menu
[    0.345559] ACPI: bus type PCI registered
[    0.345559] ACPI: bus type PCI registered
[    0.346657] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.346657] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.348775] PCI: Using configuration type 1 for base access
[    0.348775] PCI: Using configuration type 1 for base access
[    0.660029] raid6: mmxx1     1547 MB/s
[    0.660029] raid6: mmxx1     1547 MB/s
[    0.830012] raid6: mmxx2     2017 MB/s
[    0.830012] raid6: mmxx2     2017 MB/s
[    1.000021] raid6: sse1x1    2258 MB/s
[    1.000021] raid6: sse1x1    2258 MB/s
[    1.170015] raid6: sse1x2    1782 MB/s
[    1.170015] raid6: sse1x2    1782 MB/s
[    1.340019] raid6: sse2x1    2774 MB/s
[    1.340019] raid6: sse2x1    2774 MB/s
[    1.510020] raid6: sse2x2    3729 MB/s
[    1.510020] raid6: sse2x2    3729 MB/s
[    1.511025] raid6: using algorithm sse2x2 (3729 MB/s)
[    1.511025] raid6: using algorithm sse2x2 (3729 MB/s)
[    1.512330] raid6: using intx1 recovery algorithm
[    1.512330] raid6: using intx1 recovery algorithm
[    1.513678] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.513678] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.515577] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.515577] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.517691] ACPI: Added _OSI(Module Device)
[    1.517691] ACPI: Added _OSI(Module Device)
[    1.518799] ACPI: Added _OSI(Processor Device)
[    1.518799] ACPI: Added _OSI(Processor Device)
[    1.519920] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.519920] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.520006] ACPI: Added _OSI(Processor Aggregator Device)
[    1.520006] ACPI: Added _OSI(Processor Aggregator Device)
[    1.528140] ACPI: Interpreter enabled
[    1.528140] ACPI: Interpreter enabled
[    1.530015] ACPI Exception: AE_NOT_FOUND,=20
[    1.530015] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
 (20140214/hwxface-580)
[    1.532860] ACPI Exception: AE_NOT_FOUND,=20
[    1.532860] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
 (20140214/hwxface-580)
[    1.535303] ACPI: (supports S0 S3 S5)
[    1.535303] ACPI: (supports S0 S3 S5)
[    1.536246] ACPI: Using PIC for interrupt routing
[    1.536246] ACPI: Using PIC for interrupt routing
[    1.537559] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.537559] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.556798] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.556798] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.558359] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.558359] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.559805] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.559805] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.560457] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.560457] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.564073] acpiphp: Slot [3] registered
[    1.564073] acpiphp: Slot [3] registered
[    1.565259] acpiphp: Slot [4] registered
[    1.565259] acpiphp: Slot [4] registered
[    1.566433] acpiphp: Slot [5] registered
[    1.566433] acpiphp: Slot [5] registered
[    1.568043] acpiphp: Slot [6] registered
[    1.568043] acpiphp: Slot [6] registered
[    1.570156] acpiphp: Slot [7] registered
[    1.570156] acpiphp: Slot [7] registered
[    1.571271] acpiphp: Slot [8] registered
[    1.571271] acpiphp: Slot [8] registered
[    1.572385] acpiphp: Slot [9] registered
[    1.572385] acpiphp: Slot [9] registered
[    1.573505] acpiphp: Slot [10] registered
[    1.573505] acpiphp: Slot [10] registered
[    1.574682] acpiphp: Slot [11] registered
[    1.574682] acpiphp: Slot [11] registered
[    1.575806] acpiphp: Slot [12] registered
[    1.575806] acpiphp: Slot [12] registered
[    1.576953] acpiphp: Slot [13] registered
[    1.576953] acpiphp: Slot [13] registered
[    1.578103] acpiphp: Slot [14] registered
[    1.578103] acpiphp: Slot [14] registered
[    1.579329] acpiphp: Slot [15] registered
[    1.579329] acpiphp: Slot [15] registered
[    1.580149] acpiphp: Slot [16] registered
[    1.580149] acpiphp: Slot [16] registered
[    1.581393] acpiphp: Slot [17] registered
[    1.581393] acpiphp: Slot [17] registered
[    1.582572] acpiphp: Slot [18] registered
[    1.582572] acpiphp: Slot [18] registered
[    1.584201] acpiphp: Slot [19] registered
[    1.584201] acpiphp: Slot [19] registered
[    1.585401] acpiphp: Slot [20] registered
[    1.585401] acpiphp: Slot [20] registered
[    1.586543] acpiphp: Slot [21] registered
[    1.586543] acpiphp: Slot [21] registered
[    1.587683] acpiphp: Slot [22] registered
[    1.587683] acpiphp: Slot [22] registered
[    1.588817] acpiphp: Slot [23] registered
[    1.588817] acpiphp: Slot [23] registered
[    1.590147] acpiphp: Slot [24] registered
[    1.590147] acpiphp: Slot [24] registered
[    1.591281] acpiphp: Slot [25] registered
[    1.591281] acpiphp: Slot [25] registered
[    1.592439] acpiphp: Slot [26] registered
[    1.592439] acpiphp: Slot [26] registered
[    1.593574] acpiphp: Slot [27] registered
[    1.593574] acpiphp: Slot [27] registered
[    1.594719] acpiphp: Slot [28] registered
[    1.594719] acpiphp: Slot [28] registered
[    1.595847] acpiphp: Slot [29] registered
[    1.595847] acpiphp: Slot [29] registered
[    1.596977] acpiphp: Slot [30] registered
[    1.596977] acpiphp: Slot [30] registered
[    1.598114] acpiphp: Slot [31] registered
[    1.598114] acpiphp: Slot [31] registered
[    1.599163] PCI host bridge to bus 0000:00
[    1.599163] PCI host bridge to bus 0000:00
[    1.600012] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.600012] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.601421] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.601421] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.602987] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.602987] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.604601] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.604601] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.606172] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.606172] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.608612] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.608612] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.610009] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.610009] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.612782] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.612782] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.616645] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.616645] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.621963] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.621963] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.626476] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.626476] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.636164] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.636164] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.643178] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.643178] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.647109] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.647109] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.650007] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.650007] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.653840] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.653840] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.658077] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.658077] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.660420] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.660420] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.664354] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.664354] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.671663] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.671663] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.677760] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.677760] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.683446] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.683446] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.702343] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.702343] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.706814] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.706814] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.712107] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.712107] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.717928] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.717928] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.732050] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.732050] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.736380] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.736380] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.740585] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.740585] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.752662] pci_bus 0000:00: on NUMA node 0
[    1.752662] pci_bus 0000:00: on NUMA node 0
[    1.758008] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.758008] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.760705] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.760705] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.769506] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.769506] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.770611] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.770611] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.772112] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.772112] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.774305] ACPI:=20
[    1.774305] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.781018] SCSI subsystem initialized
[    1.781018] SCSI subsystem initialized
[    1.781962] libata version 3.00 loaded.
[    1.781962] libata version 3.00 loaded.
[    1.783122] ACPI: bus type USB registered
[    1.783122] ACPI: bus type USB registered
[    1.784157] usbcore: registered new interface driver usbfs
[    1.784157] usbcore: registered new interface driver usbfs
[    1.790067] usbcore: registered new interface driver hub
[    1.790067] usbcore: registered new interface driver hub
[    1.791338] usbcore: registered new device driver usb
[    1.791338] usbcore: registered new device driver usb
[    1.792858] media: Linux media interface: v0.10
[    1.792858] media: Linux media interface: v0.10
[    1.794049] Linux video capture interface: v2.00
[    1.794049] Linux video capture interface: v2.00
[    1.795312] pps_core: LinuxPPS API ver. 1 registered
[    1.795312] pps_core: LinuxPPS API ver. 1 registered
[    1.796494] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.796494] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.798719] PTP clock support registered
[    1.798719] PTP clock support registered
[    1.800488] wmi: Mapper loaded
[    1.800488] wmi: Mapper loaded
[    1.801532] Advanced Linux Sound Architecture Driver Initialized.
[    1.801532] Advanced Linux Sound Architecture Driver Initialized.
[    1.803025] PCI: Using ACPI for IRQ routing
[    1.803025] PCI: Using ACPI for IRQ routing
[    1.804045] PCI: pci_cache_line_size set to 64 bytes
[    1.804045] PCI: pci_cache_line_size set to 64 bytes
[    1.805461] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.805461] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.806893] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    1.806893] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    1.809258] NET: Registered protocol family 23
[    1.809258] NET: Registered protocol family 23
[    1.810090] NET: Registered protocol family 8
[    1.810090] NET: Registered protocol family 8
[    1.811076] NET: Registered protocol family 20
[    1.811076] NET: Registered protocol family 20
[    1.812636] NetLabel: Initializing
[    1.812636] NetLabel: Initializing
[    1.813418] NetLabel:  domain hash size =3D 128
[    1.813418] NetLabel:  domain hash size =3D 128
[    1.814457] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.814457] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.815675] NetLabel:  unlabeled traffic allowed by default
[    1.815675] NetLabel:  unlabeled traffic allowed by default
[    1.817234] cfg80211: Calling CRDA to update world regulatory domain
[    1.817234] cfg80211: Calling CRDA to update world regulatory domain
[    1.822210] Switched to clocksource kvm-clock
[    1.822210] Switched to clocksource kvm-clock
[    1.823561] pnp: PnP ACPI init
[    1.823561] pnp: PnP ACPI init
[    1.824349] ACPI: bus type PNP registered
[    1.824349] ACPI: bus type PNP registered
[    1.825473] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.825473] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.827142] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.827142] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.828916] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.828916] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.830000] pnp 00:03: [dma 2]
[    1.830000] pnp 00:03: [dma 2]
[    1.830000] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.830000] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.831163] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.831163] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.832920] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.832920] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.835074] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.835074] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.837273] pnp 00:07: Plug and Play ACPI device, IDs PNP0a06 (active)
[    1.837273] pnp 00:07: Plug and Play ACPI device, IDs PNP0a06 (active)
[    1.838891] pnp: PnP ACPI: found 8 devices
[    1.838891] pnp: PnP ACPI: found 8 devices
[    1.839807] ACPI: bus type PNP unregistered
[    1.839807] ACPI: bus type PNP unregistered
[    1.840848] PnPBIOS: Disabled
[    1.840848] PnPBIOS: Disabled
[    1.877783] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.877783] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.879141] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.879141] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.880567] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.880567] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.881961] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.881961] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.883284] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.883284] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.884599] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.884599] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.886059] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.886059] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.888281] NET: Registered protocol family 2
[    1.888281] NET: Registered protocol family 2
[    1.889819] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    1.889819] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    1.891664] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    1.891664] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    1.893588] TCP: Hash tables configured (established 4096 bind 4096)
[    1.893588] TCP: Hash tables configured (established 4096 bind 4096)
[    1.895196] TCP: reno registered
[    1.895196] TCP: reno registered
[    1.895991] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    1.895991] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    1.907089] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    1.907089] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    1.908977] NET: Registered protocol family 1
[    1.908977] NET: Registered protocol family 1
[    1.910213] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.910213] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.917286] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.917286] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.918762] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.918762] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.920526] pci 0000:00:02.0: Boot video device
[    1.920526] pci 0000:00:02.0: Boot video device
[    1.921676] PCI: CLS 0 bytes, default 64
[    1.921676] PCI: CLS 0 bytes, default 64
[    1.923084] Trying to unpack rootfs image as initramfs...
[    1.923084] Trying to unpack rootfs image as initramfs...
[    3.536899] debug: unmapping init [mem 0x8a79b000-0x8bfdffff]
[    3.536899] debug: unmapping init [mem 0x8a79b000-0x8bfdffff]
[    3.548311] apm: BIOS not found.
[    3.548311] apm: BIOS not found.
[    3.551695] cryptomgr_test (26) used greatest stack depth: 7252 bytes le=
ft
[    3.551695] cryptomgr_test (26) used greatest stack depth: 7252 bytes le=
ft
[    3.555534] PCLMULQDQ-NI instructions are not detected.
[    3.555534] PCLMULQDQ-NI instructions are not detected.
[    3.557873] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    3.557873] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    3.562594] NatSemi SCx200 Driver
[    3.562594] NatSemi SCx200 Driver
[    3.565631] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    3.565631] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    3.572642] spin_lock-torture: Creating torture_shuffle task
[    3.572642] spin_lock-torture: Creating torture_shuffle task
[    3.576385] spin_lock-torture: Creating torture_stutter task
[    3.576385] spin_lock-torture: Creating torture_stutter task
[    3.578898] spin_lock-torture: torture_shuffle task started
[    3.578898] spin_lock-torture: torture_shuffle task started
[    3.582445] spin_lock-torture: Creating lock_torture_writer task
[    3.582445] spin_lock-torture: Creating lock_torture_writer task
[    3.586061] spin_lock-torture: torture_stutter task started
[    3.586061] spin_lock-torture: torture_stutter task started
[    3.588523] spin_lock-torture: lock_torture_writer task started
[    3.588523] spin_lock-torture: lock_torture_writer task started
[    3.592171] spin_lock-torture: Creating lock_torture_writer task
[    3.592171] spin_lock-torture: Creating lock_torture_writer task
[    3.594769] spin_lock-torture: Creating lock_torture_stats task
[    3.594769] spin_lock-torture: Creating lock_torture_stats task
[    3.598388] spin_lock-torture: lock_torture_writer task started
[    3.598388] spin_lock-torture: lock_torture_writer task started
[    3.604054] futex hash table entries: 256 (order: 1, 11264 bytes)
[    3.604054] futex hash table entries: 256 (order: 1, 11264 bytes)
[    3.606804] audit: initializing netlink subsys (disabled)
[    3.606804] audit: initializing netlink subsys (disabled)
[    3.610282] spin_lock-torture: lock_torture_stats task started
[    3.610282] spin_lock-torture: lock_torture_stats task started
[    3.614063] audit: type=3D2000 audit(1411049222.555:1): initialized
[    3.614063] audit: type=3D2000 audit(1411049222.555:1): initialized
[    3.620415] DLM installed
[    3.620415] DLM installed
[    3.622457] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.622457] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.626615] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    3.626615] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    3.631150] fuse init (API version 7.23)
[    3.631150] fuse init (API version 7.23)
[    3.632807] JFS: nTxBlock =3D 2062, nTxLock =3D 16501
[    3.632807] JFS: nTxBlock =3D 2062, nTxLock =3D 16501
[    3.639608] 9p: Installing v9fs 9p2000 file system support
[    3.639608] 9p: Installing v9fs 9p2000 file system support
[    3.643203] NILFS version 2 loaded
[    3.643203] NILFS version 2 loaded
[    3.645106] befs: version: 0.9.3
[    3.645106] befs: version: 0.9.3
[    3.646319] ceph: loaded (mds proto 32)
[    3.646319] ceph: loaded (mds proto 32)
[    3.649264] msgmni has been set to 515
[    3.649264] msgmni has been set to 515
[    3.657635] NET: Registered protocol family 38
[    3.657635] NET: Registered protocol family 38
[    3.659631] async_tx: api initialized (async)
[    3.659631] async_tx: api initialized (async)
[    3.662602] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    3.662602] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    3.666650] io scheduler noop registered (default)
[    3.666650] io scheduler noop registered (default)
[    3.668887] io scheduler deadline registered
[    3.668887] io scheduler deadline registered
[    3.672506] xz_dec_test: module loaded
[    3.672506] xz_dec_test: module loaded
[    3.674488] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
248 0' and write .xz files to it.
[    3.674488] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
248 0' and write .xz files to it.
[    3.684068] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.684068] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.686505] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    3.686505] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    3.692382] cpcihp_generic: not configured, disabling.
[    3.692382] cpcihp_generic: not configured, disabling.
[    3.693665] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.693665] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.700971] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    3.700971] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    3.707406] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.707406] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.711462] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.711462] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.715637] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.715637] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.721086] vmlfb: initializing
[    3.721086] vmlfb: initializing
[    3.723962] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    3.723962] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    3.730156] usbcore: registered new interface driver udlfb
[    3.730156] usbcore: registered new interface driver udlfb
[    3.732647] usbcore: registered new interface driver smscufx
[    3.732647] usbcore: registered new interface driver smscufx
[    3.736890] kworker/u2:0 (81) used greatest stack depth: 7240 bytes left
[    3.736890] kworker/u2:0 (81) used greatest stack depth: 7240 bytes left
[    3.740701] uvesafb: failed to execute /sbin/v86d
[    3.740701] uvesafb: failed to execute /sbin/v86d
[    3.742909] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    3.742909] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    3.746835] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    3.746835] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    3.750767] kworker/u2:0 (82) used greatest stack depth: 7056 bytes left
[    3.750767] kworker/u2:0 (82) used greatest stack depth: 7056 bytes left
[    3.754509] uvesafb: vbe_init() failed with -22
[    3.754509] uvesafb: vbe_init() failed with -22
[    3.756688] uvesafb: probe of uvesafb.0 failed with error -22
[    3.756688] uvesafb: probe of uvesafb.0 failed with error -22
[    3.760355] ipmi message handler version 39.2
[    3.760355] ipmi message handler version 39.2
[    3.762563] IPMI System Interface driver.
[    3.762563] IPMI System Interface driver.
[    3.764767] ipmi_si: Adding default-specified kcs state machine
[    3.764767] ipmi_si: Adding default-specified kcs state machine

[    3.769383] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.769383] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.775072] ipmi_si: Interface detection failed
[    3.775072] ipmi_si: Interface detection failed
[    3.777293] ipmi_si: Adding default-specified smic state machine
[    3.777293] ipmi_si: Adding default-specified smic state machine

[    3.779665] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.779665] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.785439] ipmi_si: Interface detection failed
[    3.785439] ipmi_si: Interface detection failed
[    3.787626] ipmi_si: Adding default-specified bt state machine
[    3.787626] ipmi_si: Adding default-specified bt state machine

[    3.791209] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.791209] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.795846] ipmi_si: Interface detection failed
[    3.795846] ipmi_si: Interface detection failed
[    3.799067] ipmi_si: Unable to find any System Interface(s)
[    3.799067] ipmi_si: Unable to find any System Interface(s)
[    3.802561] IPMI Watchdog: driver initialized
[    3.802561] IPMI Watchdog: driver initialized
[    3.807969] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.807969] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.812181] ACPI: Power Button [PWRF]
[    3.812181] ACPI: Power Button [PWRF]
[    3.814158] GHES: HEST is not enabled!
[    3.814158] GHES: HEST is not enabled!
[    3.815051] ERST DBG: ERST support is disabled.
[    3.815051] ERST DBG: ERST support is disabled.
[    3.816189] isapnp: Scanning for PnP cards...
[    3.816189] isapnp: Scanning for PnP cards...
[    4.296719] isapnp: No Plug & Play device found
[    4.296719] isapnp: No Plug & Play device found
[    4.298868] HDLC line discipline maxframe=3D4096
[    4.298868] HDLC line discipline maxframe=3D4096
[    4.299869] N_HDLC line discipline registered.
[    4.299869] N_HDLC line discipline registered.
[    4.300977] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.300977] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.302226] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.302226] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.341917] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.341917] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.368652] serial: Freescale lpuart driver
[    4.368652] serial: Freescale lpuart driver
[    4.370809] Cyclades driver 2.6
[    4.370809] Cyclades driver 2.6
[    4.405114] MOXA Intellio family driver version 6.0k
[    4.405114] MOXA Intellio family driver version 6.0k
[    4.407380] MOXA Smartio/Industio family driver version 2.0.5
[    4.407380] MOXA Smartio/Industio family driver version 2.0.5
[    4.409589] Initializing Nozomi driver 2.1d
[    4.409589] Initializing Nozomi driver 2.1d
[    4.412708] SyncLink GT
[    4.412708] SyncLink GT
[    4.414326] SyncLink GT, tty major#240
[    4.414326] SyncLink GT, tty major#240
[    4.416247] SyncLink GT no devices found
[    4.416247] SyncLink GT no devices found
[    4.418172] SyncLink MultiPort driver $Revision: 4.38 $
[    4.418172] SyncLink MultiPort driver $Revision: 4.38 $
[    4.446791] SyncLink MultiPort driver $Revision: 4.38 $, tty major#239
[    4.446791] SyncLink MultiPort driver $Revision: 4.38 $, tty major#239
[    4.450101] SyncLink serial driver $Revision: 4.38 $
[    4.450101] SyncLink serial driver $Revision: 4.38 $
[    4.482341] SyncLink serial driver $Revision: 4.38 $, tty major#238
[    4.482341] SyncLink serial driver $Revision: 4.38 $, tty major#238
[    4.487583] DoubleTalk PC - not found
[    4.487583] DoubleTalk PC - not found
[    4.489483] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    4.489483] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    4.491101] Non-volatile memory driver v1.3
[    4.491101] Non-volatile memory driver v1.3
[    4.492133] toshiba: not a supported Toshiba laptop
[    4.492133] toshiba: not a supported Toshiba laptop
[    4.497940] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.497940] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.499174] smapi::smapi_init, ERROR invalid usSmapiID
[    4.499174] smapi::smapi_init, ERROR invalid usSmapiID
[    4.500411] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.500411] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.507656] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.507656] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.509370] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.509370] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.510852] Linux agpgart interface v0.103
[    4.510852] Linux agpgart interface v0.103
[    4.517679] [drm] Initialized drm 1.1.0 20060810
[    4.517679] [drm] Initialized drm 1.1.0 20060810
[    4.518989] [drm] radeon kernel modesetting enabled.
[    4.518989] [drm] radeon kernel modesetting enabled.
[    4.523678] usbcore: registered new interface driver udl
[    4.523678] usbcore: registered new interface driver udl
[    4.540370] tsc: Refined TSC clocksource calibration: 2693.514 MHz
[    4.540370] tsc: Refined TSC clocksource calibration: 2693.514 MHz
[    4.545204] brd: module loaded
[    4.545204] brd: module loaded
[    4.551142] loop: module loaded
[    4.551142] loop: module loaded
[    4.551896] HP CISS Driver (v 3.6.26)
[    4.551896] HP CISS Driver (v 3.6.26)
[    4.553625] MM: desc_per_page =3D 128
[    4.553625] MM: desc_per_page =3D 128
[    4.556125] nbd: registered device at major 43
[    4.556125] nbd: registered device at major 43
[    4.572805] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
[    4.572805] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
[    4.574461] drbd: built-in
[    4.574461] drbd: built-in
[    4.575086] drbd: registered as block device major 147
[    4.575086] drbd: registered as block device major 147
[    4.576291] mtip32xx Version 1.3.1
[    4.576291] mtip32xx Version 1.3.1
[    4.577433] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    4.577433] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    4.579062] dummy-irq: no IRQ given.  Use irq=3DN
[    4.579062] dummy-irq: no IRQ given.  Use irq=3DN
[    4.580302] lkdtm: No crash points registered, enable through debugfs
[    4.580302] lkdtm: No crash points registered, enable through debugfs
[    4.581919] Phantom Linux Driver, version n0.9.8, init OK
[    4.581919] Phantom Linux Driver, version n0.9.8, init OK
[    4.584546] usbcore: registered new interface driver rtsx_usb
[    4.584546] usbcore: registered new interface driver rtsx_usb
[    4.586828] usbcore: registered new interface driver viperboard
[    4.586828] usbcore: registered new interface driver viperboard
[    4.588394] Uniform Multi-Platform E-IDE driver
[    4.588394] Uniform Multi-Platform E-IDE driver
[    4.589596] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    4.589596] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    4.591277] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    4.591277] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    4.593471]     ide0: BM-DMA at 0xc040-0xc047
[    4.593471]     ide0: BM-DMA at 0xc040-0xc047
[    4.594489]     ide1: BM-DMA at 0xc048-0xc04f
[    4.594489]     ide1: BM-DMA at 0xc048-0xc04f
[    4.595507] Probing IDE interface ide0...
[    4.595507] Probing IDE interface ide0...
[    5.200246] Probing IDE interface ide1...
[    5.200246] Probing IDE interface ide1...
[    5.990114] hdc: QEMU DVD-ROM, ATAPI=20
[    5.990114] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROMCD/DVD-ROM drive
 drive
[    6.710241] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    6.710241] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    6.711939] hdc: MWDMA2 mode selected
[    6.711939] hdc: MWDMA2 mode selected
[    6.712967] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.712967] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

[    6.714187] ide1 at 0x170-0x177,0x376 on irq 15
[    6.714187] ide1 at 0x170-0x177,0x376 on irq 15

[    6.717049] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    6.717049] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    6.719524] ide-gd driver 1.18
[    6.719524] ide-gd driver 1.18
[    6.720778] Loading iSCSI transport class v2.0-870.
[    6.720778] Loading iSCSI transport class v2.0-870.
[    6.722777] fnic: Cisco FCoE HBA Driver, ver 1.5.0.45
[    6.722777] fnic: Cisco FCoE HBA Driver, ver 1.5.0.45
[    6.726227] fnic: Successfully Initialized Trace Buffer
[    6.726227] fnic: Successfully Initialized Trace Buffer
[    6.729204] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.2 (Dec=
 11, 2013)
[    6.729204] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.2 (Dec=
 11, 2013)
[    6.733528] iscsi: registered transport (tcp)
[    6.733528] iscsi: registered transport (tcp)
[    6.742727] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    6.742727] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    6.746670] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[    6.746670] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[    6.751151] scsi: <fdomain> Detection failed (no card)
[    6.751151] scsi: <fdomain> Detection failed (no card)
[    6.753625] NCR53c406a: no available ports found
[    6.753625] NCR53c406a: no available ports found
[    6.755918] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.07.00.02-k.
[    6.755918] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.07.00.02-k.
[    6.760652] iscsi: registered transport (qla4xxx)
[    6.760652] iscsi: registered transport (qla4xxx)
[    6.762885] QLogic iSCSI HBA Driver
[    6.762885] QLogic iSCSI HBA Driver
[    6.800084] Failed initialization of WD-7000 SCSI card!
[    6.800084] Failed initialization of WD-7000 SCSI card!
[    6.801405] DC390: clustering now enabled by default. If you get problem=
s load
[    6.801405] DC390: clustering now enabled by default. If you get problem=
s load
[    6.803115]        with "disable_clustering=3D1" and report to maintaine=
rs
[    6.803115]        with "disable_clustering=3D1" and report to maintaine=
rs
[    6.804902] mpt2sas version 16.100.00.00 loaded
[    6.804902] mpt2sas version 16.100.00.00 loaded
[    6.806515] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    6.806515] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    6.808199] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    6.808199] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    6.809991] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    6.809991] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    6.812013] nsp32: loading...
[    6.812013] nsp32: loading...
[    6.813992] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    6.813992] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    6.818098] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    6.818098] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    6.820733] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    6.820733] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    6.824286] iscsi: registered transport (cxgb3i)
[    6.824286] iscsi: registered transport (cxgb3i)
[    6.826491] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.6.2 (Jun 06, 2=
013)
[    6.826491] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.6.2 (Jun 06, 2=
013)
[    6.830495] iscsi: registered transport (bnx2i)
[    6.830495] iscsi: registered transport (bnx2i)
[    6.832752] iscsi: registered transport (be2iscsi)
[    6.832752] iscsi: registered transport (be2iscsi)
[    6.836011] In beiscsi_module_init, tt=3D7d87b6e0
[    6.836011] In beiscsi_module_init, tt=3D7d87b6e0
[    6.837770] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    6.837770] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    6.843421] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    6.843421] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    6.846992] osst :I: Tape driver with OnStream support version 0.99.4
[    6.846992] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    6.846992] osst :I: Tape driver with OnStream support version 0.99.4
[    6.846992] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    6.853652] SCSI Media Changer driver v0.25=20
[    6.853652] SCSI Media Changer driver v0.25=20
[    6.867578] scsi_debug: host protection
[    6.867578] scsi_debug: host protection
[    6.868539] scsi2 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    6.868539] scsi2 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    6.873365] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    6.873365] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    6.882062] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    6.882062] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    6.885136] scsi 2:0:0:0: Attached scsi generic sg0 type 0
[    6.885136] scsi 2:0:0:0: Attached scsi generic sg0 type 0
[    6.948976] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    6.948976] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    6.950419] Copyright (c) 2007 Atheros Corporation.
[    6.950419] Copyright (c) 2007 Atheros Corporation.
[    6.951993] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March =
14, 2014)
[    6.951993] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March =
14, 2014)
[    6.954009] Brocade 10G Ethernet driver - version: 3.2.23.0
[    6.954009] Brocade 10G Ethernet driver - version: 3.2.23.0
[    6.955591] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50
[    6.955591] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50
[    6.957105] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    6.957105] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    6.958601] e100: Copyright(c) 1999-2006 Intel Corporation
[    6.958601] e100: Copyright(c) 1999-2006 Intel Corporation
[    6.959982] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    6.959982] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    6.961734] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.961734] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    7.193015] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    7.193015] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    7.194461] PCI: setting IRQ 11 as level-triggered
[    7.194461] PCI: setting IRQ 11 as level-triggered
[    7.636767] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    7.636767] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    7.641537] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    7.641537] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    7.643188] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    7.643188] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    7.644578] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    7.644578] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    7.645994] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    7.645994] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    7.651129] igb: Copyright (c) 2007-2014 Intel Corporation.
[    7.651129] igb: Copyright (c) 2007-2014 Intel Corporation.
[    7.655494] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[    7.655494] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[    7.660375] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    7.660375] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    7.661831] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    7.661831] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    7.663197] sky2: driver version 1.30
[    7.663197] sky2: driver version 1.30
[    7.665265] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    7.665265] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    7.669981] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    7.669981] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    7.674992] Solarflare NET driver v4.0
[    7.674992] Solarflare NET driver v4.0
[    7.676135] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    7.676135] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    7.677541] tehuti: Options: hw_csum=20
[    7.677541] tehuti: Options: hw_csum=20
[    7.678710] usbcore: registered new interface driver irda-usb
[    7.678710] usbcore: registered new interface driver irda-usb
[    7.684184] usbcore: registered new interface driver stir4200
[    7.684184] usbcore: registered new interface driver stir4200
[    7.686188] usbcore: registered new interface driver mcs7780
[    7.686188] usbcore: registered new interface driver mcs7780
[    7.690641] usbcore: registered new interface driver ksdazzle-sir
[    7.690641] usbcore: registered new interface driver ksdazzle-sir
[    7.692144] usbcore: registered new interface driver ks959-sir
[    7.692144] usbcore: registered new interface driver ks959-sir
[    7.697575] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256) (6 bit encapsulation enabled).
[    7.697575] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256) (6 bit encapsulation enabled).
[    7.699818] hdlc: HDLC support module revision 1.22
[    7.699818] hdlc: HDLC support module revision 1.22
[    7.701118] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    7.701118] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    7.705788] usbcore: registered new interface driver i2400m_usb
[    7.705788] usbcore: registered new interface driver i2400m_usb
[    7.710269] usbcore: registered new interface driver catc
[    7.710269] usbcore: registered new interface driver catc
[    7.711580] usbcore: registered new interface driver kaweth
[    7.711580] usbcore: registered new interface driver kaweth
[    7.715906] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    7.715906] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    7.719088] usbcore: registered new interface driver pegasus
[    7.719088] usbcore: registered new interface driver pegasus
[    7.721103] usbcore: registered new interface driver asix
[    7.721103] usbcore: registered new interface driver asix
[    7.722447] usbcore: registered new interface driver cdc_ether
[    7.722447] usbcore: registered new interface driver cdc_ether
[    7.727224] usbcore: registered new interface driver cdc_eem
[    7.727224] usbcore: registered new interface driver cdc_eem
[    7.731624] usbcore: registered new interface driver sr9700
[    7.731624] usbcore: registered new interface driver sr9700
[    7.732986] usbcore: registered new interface driver smsc95xx
[    7.732986] usbcore: registered new interface driver smsc95xx
[    7.734387] usbcore: registered new interface driver cdc_subset
[    7.734387] usbcore: registered new interface driver cdc_subset
[    7.735823] usbcore: registered new interface driver zaurus
[    7.735823] usbcore: registered new interface driver zaurus
[    7.742232] usbcore: registered new interface driver int51x1
[    7.742232] usbcore: registered new interface driver int51x1
[    7.743590] usbcore: registered new interface driver kalmia
[    7.743590] usbcore: registered new interface driver kalmia
[    7.747498] usbcore: registered new interface driver sierra_net
[    7.747498] usbcore: registered new interface driver sierra_net
[    7.748964] usbcore: registered new interface driver cdc_ncm
[    7.748964] usbcore: registered new interface driver cdc_ncm
[    7.753726] usbcore: registered new interface driver huawei_cdc_ncm
[    7.753726] usbcore: registered new interface driver huawei_cdc_ncm
[    7.755281] usbcore: registered new interface driver lg-vl600
[    7.755281] usbcore: registered new interface driver lg-vl600
[    7.759630] usbcore: registered new interface driver qmi_wwan
[    7.759630] usbcore: registered new interface driver qmi_wwan
[    7.761003] usbcore: registered new interface driver cdc_mbim
[    7.761003] usbcore: registered new interface driver cdc_mbim
[    7.765524] Madge ATM Horizon [Ultra] driver version 1.2.1
[    7.765524] Madge ATM Horizon [Ultra] driver version 1.2.1
[    7.766876] hrz: debug bitmap is 0
[    7.766876] hrz: debug bitmap is 0
[    7.767768] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
[    7.767768] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
[    7.770962] idt77252_init: at 7d9cfae8
[    7.770962] idt77252_init: at 7d9cfae8
[    7.774735] Solos PCI Driver Version 1.04
[    7.774735] Solos PCI Driver Version 1.04
[    7.775886] adummy: version 1.0
[    7.775886] adummy: version 1.0
[    7.777193] Fusion MPT base driver 3.04.20
[    7.777193] Fusion MPT base driver 3.04.20
[    7.778510] Copyright (c) 1999-2008 LSI Corporation
[    7.778510] Copyright (c) 1999-2008 LSI Corporation
[    7.779843] Fusion MPT SPI Host driver 3.04.20
[    7.779843] Fusion MPT SPI Host driver 3.04.20
[    7.781218] Fusion MPT FC Host driver 3.04.20
[    7.781218] Fusion MPT FC Host driver 3.04.20
[    7.784752] aoe: AoE v85 initialised.
[    7.784752] aoe: AoE v85 initialised.
[    7.786398] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.786398] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.788232] ehci-pci: EHCI PCI platform driver
[    7.788232] ehci-pci: EHCI PCI platform driver
[    7.789497] ehci-platform: EHCI generic platform driver
[    7.789497] ehci-platform: EHCI generic platform driver
[    7.791225] uhci_hcd: USB Universal Host Controller Interface driver
[    7.791225] uhci_hcd: USB Universal Host Controller Interface driver
[    7.793126] driver u132_hcd
[    7.793126] driver u132_hcd
[    7.794381] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    7.794381] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    7.796014] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    7.796014] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    7.798530] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    7.798530] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    7.802748] usbcore: registered new interface driver cdc_acm
[    7.802748] usbcore: registered new interface driver cdc_acm
[    7.804365] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    7.804365] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    7.806558] usbcore: registered new interface driver usblp
[    7.806558] usbcore: registered new interface driver usblp
[    7.808849] usbcore: registered new interface driver cdc_wdm
[    7.808849] usbcore: registered new interface driver cdc_wdm
[    7.810564] usbcore: registered new interface driver usbtmc
[    7.810564] usbcore: registered new interface driver usbtmc
[    7.812337] usbcore: registered new interface driver usb-storage
[    7.812337] usbcore: registered new interface driver usb-storage
[    7.814069] usbcore: registered new interface driver ums-freecom
[    7.814069] usbcore: registered new interface driver ums-freecom
[    7.815722] usbcore: registered new interface driver ums-isd200
[    7.815722] usbcore: registered new interface driver ums-isd200
[    7.817444] usbcore: registered new interface driver ums-onetouch
[    7.817444] usbcore: registered new interface driver ums-onetouch
[    7.819116] usbcore: registered new interface driver ums-realtek
[    7.819116] usbcore: registered new interface driver ums-realtek
[    7.820868] usbcore: registered new interface driver ums-sddr09
[    7.820868] usbcore: registered new interface driver ums-sddr09
[    7.822512] usbcore: registered new interface driver ums-usbat
[    7.822512] usbcore: registered new interface driver ums-usbat
[    7.824216] usbcore: registered new interface driver mdc800
[    7.824216] usbcore: registered new interface driver mdc800
[    7.825712] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    7.825712] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    7.827881] usbcore: registered new interface driver microtekX6
[    7.827881] usbcore: registered new interface driver microtekX6
[    7.829628] usbcore: registered new interface driver usbserial
[    7.829628] usbcore: registered new interface driver usbserial
[    7.831370] usbcore: registered new interface driver usbserial_generic
[    7.831370] usbcore: registered new interface driver usbserial_generic
[    7.833225] usbserial: USB Serial support registered for generic
[    7.833225] usbserial: USB Serial support registered for generic
[    7.834972] usbcore: registered new interface driver cp210x
[    7.834972] usbcore: registered new interface driver cp210x
[    7.836536] usbserial: USB Serial support registered for cp210x
[    7.836536] usbserial: USB Serial support registered for cp210x
[    7.838247] usbcore: registered new interface driver cyberjack
[    7.838247] usbcore: registered new interface driver cyberjack
[    7.839870] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    7.839870] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    7.842328] usbcore: registered new interface driver cypress_m8
[    7.842328] usbcore: registered new interface driver cypress_m8
[    7.844064] usbserial: USB Serial support registered for DeLorme Earthma=
te USB
[    7.844064] usbserial: USB Serial support registered for DeLorme Earthma=
te USB
[    7.846051] usbserial: USB Serial support registered for HID->COM RS232 =
Adapter
[    7.846051] usbserial: USB Serial support registered for HID->COM RS232 =
Adapter
[    7.848139] usbserial: USB Serial support registered for Nokia CA-42 V2 =
Adapter
[    7.848139] usbserial: USB Serial support registered for Nokia CA-42 V2 =
Adapter
[    7.850273] usbcore: registered new interface driver usb_debug
[    7.850273] usbcore: registered new interface driver usb_debug
[    7.851892] usbserial: USB Serial support registered for debug
[    7.851892] usbserial: USB Serial support registered for debug
[    7.853621] usbcore: registered new interface driver digi_acceleport
[    7.853621] usbcore: registered new interface driver digi_acceleport
[    7.855384] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[    7.855384] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[    7.857490] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[    7.857490] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[    7.859535] usbcore: registered new interface driver io_edgeport
[    7.859535] usbcore: registered new interface driver io_edgeport
[    7.861331] usbserial: USB Serial support registered for Edgeport 2 port=
 adapter
[    7.861331] usbserial: USB Serial support registered for Edgeport 2 port=
 adapter
[    7.863441] usbserial: USB Serial support registered for Edgeport 4 port=
 adapter
[    7.863441] usbserial: USB Serial support registered for Edgeport 4 port=
 adapter
[    7.865469] usbserial: USB Serial support registered for Edgeport 8 port=
 adapter
[    7.865469] usbserial: USB Serial support registered for Edgeport 8 port=
 adapter
[    7.867586] usbserial: USB Serial support registered for EPiC device
[    7.867586] usbserial: USB Serial support registered for EPiC device
[    7.869358] usbcore: registered new interface driver io_ti
[    7.869358] usbcore: registered new interface driver io_ti
[    7.871014] usbserial: USB Serial support registered for Edgeport TI 1 p=
ort adapter
[    7.871014] usbserial: USB Serial support registered for Edgeport TI 1 p=
ort adapter
[    7.873119] usbserial: USB Serial support registered for Edgeport TI 2 p=
ort adapter
[    7.873119] usbserial: USB Serial support registered for Edgeport TI 2 p=
ort adapter
[    7.875298] usbcore: registered new interface driver empeg
[    7.875298] usbcore: registered new interface driver empeg
[    7.876900] usbserial: USB Serial support registered for empeg
[    7.876900] usbserial: USB Serial support registered for empeg
[    7.878517] usbcore: registered new interface driver ftdi_sio
[    7.878517] usbcore: registered new interface driver ftdi_sio
[    7.880200] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    7.880200] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    7.882225] usbcore: registered new interface driver garmin_gps
[    7.882225] usbcore: registered new interface driver garmin_gps
[    7.884702] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[    7.884702] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[    7.886707] usbcore: registered new interface driver ipw
[    7.886707] usbcore: registered new interface driver ipw
[    7.888203] usbserial: USB Serial support registered for IPWireless conv=
erter
[    7.888203] usbserial: USB Serial support registered for IPWireless conv=
erter
[    7.890270] usbcore: registered new interface driver ir_usb
[    7.890270] usbcore: registered new interface driver ir_usb
[    7.891830] usbserial: USB Serial support registered for IR Dongle
[    7.891830] usbserial: USB Serial support registered for IR Dongle
[    7.893617] usbcore: registered new interface driver iuu_phoenix
[    7.893617] usbcore: registered new interface driver iuu_phoenix
[    7.895276] usbserial: USB Serial support registered for iuu_phoenix
[    7.895276] usbserial: USB Serial support registered for iuu_phoenix
[    7.897108] usbcore: registered new interface driver keyspan
[    7.897108] usbcore: registered new interface driver keyspan
[    7.898714] usbserial: USB Serial support registered for Keyspan - (with=
out firmware)
[    7.898714] usbserial: USB Serial support registered for Keyspan - (with=
out firmware)
[    7.900971] usbserial: USB Serial support registered for Keyspan 1 port =
adapter
[    7.900971] usbserial: USB Serial support registered for Keyspan 1 port =
adapter
[    7.903018] usbserial: USB Serial support registered for Keyspan 2 port =
adapter
[    7.903018] usbserial: USB Serial support registered for Keyspan 2 port =
adapter
[    7.905110] usbserial: USB Serial support registered for Keyspan 4 port =
adapter
[    7.905110] usbserial: USB Serial support registered for Keyspan 4 port =
adapter
[    7.907338] usbcore: registered new interface driver kl5kusb105
[    7.907338] usbcore: registered new interface driver kl5kusb105
[    7.908976] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[    7.908976] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[    7.911370] usbcore: registered new interface driver kobil_sct
[    7.911370] usbcore: registered new interface driver kobil_sct
[    7.913003] usbserial: USB Serial support registered for KOBIL USB smart=
 card terminal
[    7.913003] usbserial: USB Serial support registered for KOBIL USB smart=
 card terminal
[    7.915248] usbcore: registered new interface driver mct_u232
[    7.915248] usbcore: registered new interface driver mct_u232
[    7.916925] usbserial: USB Serial support registered for MCT U232
[    7.916925] usbserial: USB Serial support registered for MCT U232
[    7.918627] usbcore: registered new interface driver metro_usb
[    7.918627] usbcore: registered new interface driver metro_usb
[    7.920359] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[    7.920359] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[    7.922425] usbcore: registered new interface driver mos7720
[    7.922425] usbcore: registered new interface driver mos7720
[    7.924210] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    7.924210] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    7.926220] usbcore: registered new interface driver option
[    7.926220] usbcore: registered new interface driver option
[    7.927850] usbserial: USB Serial support registered for GSM modem (1-po=
rt)
[    7.927850] usbserial: USB Serial support registered for GSM modem (1-po=
rt)
[    7.929762] usbcore: registered new interface driver oti6858
[    7.929762] usbcore: registered new interface driver oti6858
[    7.931438] usbserial: USB Serial support registered for oti6858
[    7.931438] usbserial: USB Serial support registered for oti6858
[    7.933107] usbcore: registered new interface driver pl2303
[    7.933107] usbcore: registered new interface driver pl2303
[    7.934752] usbserial: USB Serial support registered for pl2303
[    7.934752] usbserial: USB Serial support registered for pl2303
[    7.936395] usbcore: registered new interface driver qcaux
[    7.936395] usbcore: registered new interface driver qcaux
[    7.937999] usbserial: USB Serial support registered for qcaux
[    7.937999] usbserial: USB Serial support registered for qcaux
[    7.939622] usbcore: registered new interface driver qcserial
[    7.939622] usbcore: registered new interface driver qcserial
[    7.941443] usbserial: USB Serial support registered for Qualcomm USB mo=
dem
[    7.941443] usbserial: USB Serial support registered for Qualcomm USB mo=
dem
[    7.943457] usbcore: registered new interface driver quatech2
[    7.943457] usbcore: registered new interface driver quatech2
[    7.945043] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[    7.945043] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[    7.947459] usbcore: registered new interface driver safe_serial
[    7.947459] usbcore: registered new interface driver safe_serial
[    7.949117] usbserial: USB Serial support registered for safe_serial
[    7.949117] usbserial: USB Serial support registered for safe_serial
[    7.950982] usbcore: registered new interface driver usb_serial_simple
[    7.950982] usbcore: registered new interface driver usb_serial_simple
[    7.952783] usbserial: USB Serial support registered for zio
[    7.952783] usbserial: USB Serial support registered for zio
[    7.954462] usbserial: USB Serial support registered for funsoft
[    7.954462] usbserial: USB Serial support registered for funsoft
[    7.956131] usbserial: USB Serial support registered for flashloader
[    7.956131] usbserial: USB Serial support registered for flashloader
[    7.957967] usbserial: USB Serial support registered for vivopay
[    7.957967] usbserial: USB Serial support registered for vivopay
[    7.959628] usbserial: USB Serial support registered for moto_modem
[    7.959628] usbserial: USB Serial support registered for moto_modem
[    7.961487] usbserial: USB Serial support registered for hp4x
[    7.961487] usbserial: USB Serial support registered for hp4x
[    7.963083] usbserial: USB Serial support registered for suunto
[    7.963083] usbserial: USB Serial support registered for suunto
[    7.964813] usbserial: USB Serial support registered for siemens_mpi
[    7.964813] usbserial: USB Serial support registered for siemens_mpi
[    7.966563] usbcore: registered new interface driver ssu100
[    7.966563] usbcore: registered new interface driver ssu100
[    7.968175] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[    7.968175] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[    7.970600] usbcore: registered new interface driver symbolserial
[    7.970600] usbcore: registered new interface driver symbolserial
[    7.972291] usbserial: USB Serial support registered for symbol
[    7.972291] usbserial: USB Serial support registered for symbol
[    7.974012] usbcore: registered new interface driver visor
[    7.974012] usbcore: registered new interface driver visor
[    7.975541] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[    7.975541] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[    7.977713] usbserial: USB Serial support registered for Sony Clie 5.0
[    7.977713] usbserial: USB Serial support registered for Sony Clie 5.0
[    7.979516] usbserial: USB Serial support registered for Sony Clie 3.5
[    7.979516] usbserial: USB Serial support registered for Sony Clie 3.5
[    7.981422] usbcore: registered new interface driver wishbone_serial
[    7.981422] usbcore: registered new interface driver wishbone_serial
[    7.983175] usbserial: USB Serial support registered for wishbone_serial
[    7.983175] usbserial: USB Serial support registered for wishbone_serial
[    7.985097] usbcore: registered new interface driver whiteheat
[    7.985097] usbcore: registered new interface driver whiteheat
[    7.986796] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[    7.986796] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[    7.989326] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[    7.989326] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[    7.991479] usbcore: registered new interface driver keyspan_pda
[    7.991479] usbcore: registered new interface driver keyspan_pda
[    7.993142] usbserial: USB Serial support registered for Keyspan PDA
[    7.993142] usbserial: USB Serial support registered for Keyspan PDA
[    7.994982] usbserial: USB Serial support registered for Xircom / Entreg=
ra PGS - (prerenumeration)
[    7.994982] usbserial: USB Serial support registered for Xircom / Entreg=
ra PGS - (prerenumeration)
[    7.997496] usbcore: registered new interface driver xsens_mt
[    7.997496] usbcore: registered new interface driver xsens_mt
[    7.999084] usbserial: USB Serial support registered for xsens_mt
[    7.999084] usbserial: USB Serial support registered for xsens_mt
[    8.000883] usbcore: registered new interface driver zte_ev
[    8.000883] usbcore: registered new interface driver zte_ev
[    8.002438] usbserial: USB Serial support registered for zte_ev
[    8.002438] usbserial: USB Serial support registered for zte_ev
[    8.004169] usbcore: registered new interface driver adutux
[    8.004169] usbcore: registered new interface driver adutux
[    8.005725] usbcore: registered new interface driver cytherm
[    8.005725] usbcore: registered new interface driver cytherm
[    8.007394] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    8.007394] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    8.009333] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    8.009333] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    8.012383] driver ftdi-elan
[    8.012383] driver ftdi-elan
[    8.013548] usbcore: registered new interface driver ftdi-elan
[    8.013548] usbcore: registered new interface driver ftdi-elan
[    8.015177] usbcore: registered new interface driver idmouse
[    8.015177] usbcore: registered new interface driver idmouse
[    8.016848] usbcore: registered new interface driver iowarrior
[    8.016848] usbcore: registered new interface driver iowarrior
[    8.018469] usbcore: registered new interface driver usbled
[    8.018469] usbcore: registered new interface driver usbled
[    8.020130] usbcore: registered new interface driver legousbtower
[    8.020130] usbcore: registered new interface driver legousbtower
[    8.021828] usbcore: registered new interface driver rio500
[    8.021828] usbcore: registered new interface driver rio500
[    8.023473] usbcore: registered new interface driver usbtest
[    8.023473] usbcore: registered new interface driver usbtest
[    8.025049] usbcore: registered new interface driver usb_ehset_test
[    8.025049] usbcore: registered new interface driver usb_ehset_test
[    8.026870] usbcore: registered new interface driver trancevibrator
[    8.026870] usbcore: registered new interface driver trancevibrator
[    8.028612] usbcore: registered new interface driver usbsevseg
[    8.028612] usbcore: registered new interface driver usbsevseg
[    8.030519] usbcore: registered new interface driver cxacru
[    8.030519] usbcore: registered new interface driver cxacru
[    8.032086] usbcore: registered new interface driver speedtch
[    8.032086] usbcore: registered new interface driver speedtch
[    8.033794] usbcore: registered new interface driver ueagle-atm
[    8.033794] usbcore: registered new interface driver ueagle-atm
[    8.035829] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    8.035829] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    8.037916] dummy_hcd dummy_hcd.0: Dummy host controller
[    8.037916] dummy_hcd dummy_hcd.0: Dummy host controller
[    8.039818] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    8.039818] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    8.044309] hub 1-0:1.0: USB hub found
[    8.044309] hub 1-0:1.0: USB hub found
[    8.045414] hub 1-0:1.0: 1 port detected
[    8.045414] hub 1-0:1.0: 1 port detected
[    8.049514] MIDI Gadget
[    8.049514] MIDI Gadget
[    8.050327] MIDI Gadget gadget: MIDI Gadget ready
[    8.050327] MIDI Gadget gadget: MIDI Gadget ready
[    8.051803] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    8.051803] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    8.054971] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.054971] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.056732] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.056732] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.129084] mousedev: PS/2 mouse device common for all mice
[    8.129084] mousedev: PS/2 mouse device common for all mice
[    8.132170] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    8.132170] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    8.135174] usbcore: registered new interface driver iforce
[    8.135174] usbcore: registered new interface driver iforce
[    8.137359] usbcore: registered new interface driver xpad
[    8.137359] usbcore: registered new interface driver xpad
[    8.138896] walkera0701: parport 0 does not exist
[    8.138896] walkera0701: parport 0 does not exist
[    8.140950] usbcore: registered new interface driver usb_acecad
[    8.140950] usbcore: registered new interface driver usb_acecad
[    8.142611] usbcore: registered new interface driver aiptek
[    8.142611] usbcore: registered new interface driver aiptek
[    8.144243] usbcore: registered new interface driver gtco
[    8.144243] usbcore: registered new interface driver gtco
[    8.145751] usbcore: registered new interface driver hanwang
[    8.145751] usbcore: registered new interface driver hanwang
[    8.147414] usbcore: registered new interface driver kbtab
[    8.147414] usbcore: registered new interface driver kbtab
[    8.150575] i2c /dev entries driver
[    8.150575] i2c /dev entries driver
[    8.152225] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[    8.152225] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[    8.360088] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    8.360088] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    8.410780] usbcore: registered new interface driver i2c-diolan-u2c
[    8.410780] usbcore: registered new interface driver i2c-diolan-u2c
[    8.412688] i2c-parport-light: adapter type unspecified
[    8.412688] i2c-parport-light: adapter type unspecified
[    8.414156] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    8.414156] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    8.416432] usbcore: registered new interface driver i2c-tiny-usb
[    8.416432] usbcore: registered new interface driver i2c-tiny-usb
[    8.419911] lirc_dev: IR Remote Control driver registered, major 230=20
[    8.419911] lirc_dev: IR Remote Control driver registered, major 230=20
[    8.421785] IR NEC protocol handler initialized
[    8.421785] IR NEC protocol handler initialized
[    8.423809] IR RC5(x) protocol handler initialized
[    8.423809] IR RC5(x) protocol handler initialized
[    8.427272] IR JVC protocol handler initialized
[    8.427272] IR JVC protocol handler initialized
[    8.428488] IR RC5 (streamzap) protocol handler initialized
[    8.428488] IR RC5 (streamzap) protocol handler initialized
[    8.433461] IR Sharp protocol handler initialized
[    8.433461] IR Sharp protocol handler initialized
[    8.434730] IR LIRC bridge handler initialized
[    8.434730] IR LIRC bridge handler initialized
[    8.435985] usbcore: registered new interface driver ati_remote
[    8.435985] usbcore: registered new interface driver ati_remote
[    8.441074] usbcore: registered new interface driver imon
[    8.441074] usbcore: registered new interface driver imon
[    8.442745] usbcore: registered new interface driver redrat3
[    8.442745] usbcore: registered new interface driver redrat3
[    8.447710] Registered IR keymap rc-empty
[    8.447710] Registered IR keymap rc-empty
[    8.449234] input: rc-core loopback device as /devices/virtual/rc/rc0/in=
put3
[    8.449234] input: rc-core loopback device as /devices/virtual/rc/rc0/in=
put3
[    8.454745] rc0: rc-core loopback device as /devices/virtual/rc/rc0
[    8.454745] rc0: rc-core loopback device as /devices/virtual/rc/rc0
[    8.460389] rc rc0: lirc_dev: driver ir-lirc-codec (rc-loopback) registe=
red at minor =3D 0
[    8.460389] rc rc0: lirc_dev: driver ir-lirc-codec (rc-loopback) registe=
red at minor =3D 0
[    8.462652] usbcore: registered new interface driver iguanair
[    8.462652] usbcore: registered new interface driver iguanair
[    8.467687] usbcore: registered new interface driver ttusbir
[    8.467687] usbcore: registered new interface driver ttusbir
[    8.469228] Marvell M88ALP01 'CAFE' Camera Controller version 2
[    8.469228] Marvell M88ALP01 'CAFE' Camera Controller version 2
[    8.474390] saa7146: register extension 'budget dvb'
[    8.474390] saa7146: register extension 'budget dvb'
[    8.475803] saa7146: register extension 'budget_ci dvb'
[    8.475803] saa7146: register extension 'budget_ci dvb'
[    8.480729] saa7146: register extension 'budget_patch dvb'
[    8.480729] saa7146: register extension 'budget_patch dvb'
[    8.482278] saa7146: register extension 'av7110'
[    8.482278] saa7146: register extension 'av7110'
[    8.487068] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[    8.487068] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[    8.488889] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Di=
gital Devices GmbH
[    8.488889] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Di=
gital Devices GmbH
[    8.495372] saa7146: register extension 'Multimedia eXtension Board'
[    8.495372] saa7146: register extension 'Multimedia eXtension Board'
[    8.497198] saa7146: register extension 'hexium gemini'
[    8.497198] saa7146: register extension 'hexium gemini'
[    8.498703] ivtv: Start initialization, version 1.4.3
[    8.498703] ivtv: Start initialization, version 1.4.3
[    8.500245] ivtv: End initialization
[    8.500245] ivtv: End initialization
[    8.501210] ivtvfb:  no cards found
[    8.501210] ivtvfb:  no cards found
[    8.502155] Zoran MJPEG board driver version 0.10.1
[    8.502155] Zoran MJPEG board driver version 0.10.1
[    8.503585] Linux video codec intermediate layer: v0.2
[    8.503585] Linux video codec intermediate layer: v0.2
[    8.504986] cx18:  Start initialization, version 1.5.1
[    8.504986] cx18:  Start initialization, version 1.5.1
[    8.506493] cx18:  End initialization
[    8.506493] cx18:  End initialization
[    8.507472] cx18-alsa: module loading...
[    8.507472] cx18-alsa: module loading...
[    8.508498] cx25821: driver version 0.0.106 loaded
[    8.508498] cx25821: driver version 0.0.106 loaded
[    8.509877] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    8.509877] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    8.511868] usbcore: registered new interface driver ttusb-dec
[    8.511868] usbcore: registered new interface driver ttusb-dec
[    8.513595] usbcore: registered new interface driver dvb_usb_vp7045
[    8.513595] usbcore: registered new interface driver dvb_usb_vp7045
[    8.515342] usbcore: registered new interface driver dvb_usb_gp8psk
[    8.515342] usbcore: registered new interface driver dvb_usb_gp8psk
[    8.517151] usbcore: registered new interface driver dvb_usb_dtt200u
[    8.517151] usbcore: registered new interface driver dvb_usb_dtt200u
[    8.518920] usbcore: registered new interface driver dvb_usb_a800
[    8.518920] usbcore: registered new interface driver dvb_usb_a800
[    8.520728] usbcore: registered new interface driver dvb_usb_dibusb_mb
[    8.520728] usbcore: registered new interface driver dvb_usb_dibusb_mb
[    8.522539] usbcore: registered new interface driver dvb_usb_nova_t_usb2
[    8.522539] usbcore: registered new interface driver dvb_usb_nova_t_usb2
[    8.524480] usbcore: registered new interface driver dvb_usb_m920x
[    8.524480] usbcore: registered new interface driver dvb_usb_m920x
[    8.526198] usbcore: registered new interface driver dvb_usb_digitv
[    8.526198] usbcore: registered new interface driver dvb_usb_digitv
[    8.528015] usbcore: registered new interface driver dvb_usb_ttusb2
[    8.528015] usbcore: registered new interface driver dvb_usb_ttusb2
[    8.529751] usbcore: registered new interface driver dvb_usb_af9005
[    8.529751] usbcore: registered new interface driver dvb_usb_af9005
[    8.531584] BUG: unable to handle kernel=20
[    8.531584] BUG: unable to handle kernel paging requestpaging request at=
 02e00000
 at 02e00000
[    8.533385] IP:
[    8.533385] IP: [<7d9d67c6>] af9005_usb_module_init+0x6b/0x9d
 [<7d9d67c6>] af9005_usb_module_init+0x6b/0x9d
[    8.535613] *pde =3D 00000000=20
[    8.535613] *pde =3D 00000000=20

[    8.536416] Oops: 0000 [#1]=20
[    8.536416] Oops: 0000 [#1] PREEMPT PREEMPT DEBUG_PAGEALLOCDEBUG_PAGEALL=
OC

[    8.537863] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc6-00151-ga5=
c075c #1
[    8.537863] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc6-00151-ga5=
c075c #1
[    8.539827] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    8.539827] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    8.541519] task: 89c9a670 ti: 89c9c000 task.ti: 89c9c000
[    8.541519] task: 89c9a670 ti: 89c9c000 task.ti: 89c9c000
[    8.541519] EIP: 0060:[<7d9d67c6>] EFLAGS: 00010206 CPU: 0
[    8.541519] EIP: 0060:[<7d9d67c6>] EFLAGS: 00010206 CPU: 0
[    8.541519] EIP is at af9005_usb_module_init+0x6b/0x9d
[    8.541519] EIP is at af9005_usb_module_init+0x6b/0x9d
[    8.541519] EAX: 02e00000 EBX: 00000000 ECX: 00000006 EDX: 00000000
[    8.541519] EAX: 02e00000 EBX: 00000000 ECX: 00000006 EDX: 00000000
[    8.541519] ESI: 00000000 EDI: 7da33ec8 EBP: 89c9df30 ESP: 89c9df2c
[    8.541519] ESI: 00000000 EDI: 7da33ec8 EBP: 89c9df30 ESP: 89c9df2c
[    8.541519]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    8.541519]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    8.541519] CR0: 8005003b CR2: 02e00000 CR3: 05a54000 CR4: 00000690
[    8.541519] CR0: 8005003b CR2: 02e00000 CR3: 05a54000 CR4: 00000690
[    8.541519] Stack:
[    8.541519] Stack:
[    8.541519]  7d9d675b
[    8.541519]  7d9d675b 89c9df90 89c9df90 7d992a49 7d992a49 7d7d5914 7d7d5=
914 89c9df4c 89c9df4c 7be3a800 7be3a800 7d08c58c 7d08c58c 8a4c3968 8a4c3968

[    8.541519]  89c9df80
[    8.541519]  89c9df80 7be3a966 7be3a966 00000192 00000192 00000006 00000=
006 00000006 00000006 7d7d3ff4 7d7d3ff4 8a4c397a 8a4c397a 00000200 00000200

[    8.541519]  7d6b1280
[    8.541519]  7d6b1280 8a4c3979 8a4c3979 00000006 00000006 000009a6 00000=
9a6 7da32db8 7da32db8 b13eec81 b13eec81 00000006 00000006 000009a6 000009a6

[    8.541519] Call Trace:
[    8.541519] Call Trace:
[    8.541519]  [<7d9d675b>] ? ttusb2_driver_init+0x16/0x16
[    8.541519]  [<7d9d675b>] ? ttusb2_driver_init+0x16/0x16
[    8.541519]  [<7d992a49>] do_one_initcall+0x77/0x106
[    8.541519]  [<7d992a49>] do_one_initcall+0x77/0x106
[    8.541519]  [<7be3a800>] ? parameqn+0x2/0x35
[    8.541519]  [<7be3a800>] ? parameqn+0x2/0x35
[    8.541519]  [<7be3a966>] ? parse_args+0x113/0x25c
[    8.541519]  [<7be3a966>] ? parse_args+0x113/0x25c
[    8.541519]  [<7d992bc2>] kernel_init_freeable+0xea/0x167
[    8.541519]  [<7d992bc2>] kernel_init_freeable+0xea/0x167
[    8.541519]  [<7cf01070>] kernel_init+0x8/0xb8
[    8.541519]  [<7cf01070>] kernel_init+0x8/0xb8
[    8.541519]  [<7cf27ec0>] ret_from_kernel_thread+0x20/0x30
[    8.541519]  [<7cf27ec0>] ret_from_kernel_thread+0x20/0x30
[    8.541519]  [<7cf01068>] ? rest_init+0x10c/0x10c
[    8.541519]  [<7cf01068>] ? rest_init+0x10c/0x10c
[    8.541519] Code:
[    8.541519] Code: 08 08 c2 c2 c7 c7 05 05 44 44 ed ed f9 f9 7d 7d 00 00 =
00 00 e0 e0 02 02 c7 c7 05 05 40 40 ed ed f9 f9 7d 7d 00 00 00 00 e0 e0 02 =
02 c7 c7 05 05 3c 3c ed ed f9 f9 7d 7d 00 00 00 00 e0 e0 02 02 75 75 1f 1f =
b8 b8 00 00 00 00 e0 e0 02 02 85 85 c0 c0 74 74 16 16 <a1> <a1> 00 00 00 00=
 e0 e0 02 02 c7 c7 05 05 54 54 84 84 8e 8e 7d 7d 00 00 00 00 e0 e0 02 02 a3=
 a3 58 58 84 84 8e 8e 7d 7d eb eb

[    8.541519] EIP: [<7d9d67c6>]=20
[    8.541519] EIP: [<7d9d67c6>] af9005_usb_module_init+0x6b/0x9daf9005_usb=
_module_init+0x6b/0x9d SS:ESP 0068:89c9df2c
 SS:ESP 0068:89c9df2c
[    8.541519] CR2: 0000000002e00000
[    8.541519] CR2: 0000000002e00000
[    8.541519] ---[ end trace 768b6faf51370fc7 ]---
[    8.541519] ---[ end trace 768b6faf51370fc7 ]---
[    8.541519] Kernel panic - not syncing: Fatal exception
[    8.541519] Kernel panic - not syncing: Fatal exception
[    8.541519] Kernel Offset: 0x2e00000 from 0x79000000 (relocation range: =
0x78000000-0x8c7dffff)
[    8.541519] Kernel Offset: 0x2e00000 from 0x79000000 (relocation range: =
0x78000000-0x8c7dffff)

Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-i=
b1-09172043/a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f/vmlinuz-3.15.0-rc6-001=
51-ga5c075c -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug a=
pic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib1=
-09172043/next:master:a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f:bisect-linux=
-1/.vmlinuz-a5c075cfd2386a4f3ab4f8ed2830ebee557d4b3f-20140918212424-19-ivb4=
1 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ib1-09172043/a5=
c075cfd2386a4f3ab4f8ed2830ebee557d4b3f/vmlinuz-3.15.0-rc6-00151-ga5c075c dr=
bd.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m =
320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm=
/kboot/pid-quantal-ivb41-94 -serial file:/dev/shm/kboot/serial-quantal-ivb4=
1-94 -daemonize -display none -monitor null=20

--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-16:20140919005510:i386-randconfig-ib1-09172043::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc6-00150-g3319e6f (kbuild@lkp-ib03) (g=
cc version 4.9.1 (Debian 4.9.1-11) ) #1 PREEMPT Thu Sep 18 23:34:44 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[780f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] initial memory mapped: [mem 0x00000000-0x0affffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 4k
[    0.000000] BRK [0x0a9f0000, 0x0a9f0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
[    0.000000] BRK [0x0a9f1000, 0x0a9f1fff] PGTABLE
[    0.000000] BRK [0x0a9f2000, 0x0a9f2fff] PGTABLE
[    0.000000] BRK [0x0a9f3000, 0x0a9f3fff] PGTABLE
[    0.000000] BRK [0x0a9f4000, 0x0a9f4fff] PGTABLE
[    0.000000] BRK [0x0a9f5000, 0x0a9f5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13fdffff]
[    0.000000]  [mem 0x12400000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x1279b000-0x13fdffff]
[    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE1885 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1279a001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13fdffff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat 8238f6e0, node_mem_map 8a=
4c9024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77792 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr a1f7200
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81070
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-ib1-09172043/next:master:3319e6f839cf94e33fbad27a21fc4c64f6cec74f=
:bisect-linux-1/.vmlinuz-3319e6f839cf94e33fbad27a21fc4c64f6cec74f-201409190=
01434-43-ivb41 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ib=
1-09172043/3319e6f839cf94e33fbad27a21fc4c64f6cec74f/vmlinuz-3.15.0-rc6-0015=
0-g3319e6f drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 263996K/327160K available (17577K kernel code, 1740K=
 rwdata, 8920K rodata, 764K init, 5556K bss, 63164K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x8c7e0000 - 0xff7fe000   (1840 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x8bfe0000   ( 319 MB)
[    0.000000]       .init : 0x82397000 - 0x82456000   ( 764 kB)
[    0.000000]       .data : 0x8192aa07 - 0x823951a0   (10665 kB)
[    0.000000]       .text : 0x80800000 - 0x8192aa07   (17578 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D89c18000 soft=3D89c1a000
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc6-00150-g3319e6f (kbuild@lkp-ib03) (g=
cc version 4.9.1 (Debian 4.9.1-11) ) #1 PREEMPT Thu Sep 18 23:34:44 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[780f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] initial memory mapped: [mem 0x00000000-0x0affffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 4k
[    0.000000] BRK [0x0a9f0000, 0x0a9f0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
[    0.000000] BRK [0x0a9f1000, 0x0a9f1fff] PGTABLE
[    0.000000] BRK [0x0a9f2000, 0x0a9f2fff] PGTABLE
[    0.000000] BRK [0x0a9f3000, 0x0a9f3fff] PGTABLE
[    0.000000] BRK [0x0a9f4000, 0x0a9f4fff] PGTABLE
[    0.000000] BRK [0x0a9f5000, 0x0a9f5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13fdffff]
[    0.000000]  [mem 0x12400000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x1279b000-0x13fdffff]
[    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE1885 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1279a001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13fdffff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat 8238f6e0, node_mem_map 8a=
4c9024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77792 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr a1f7200
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81070
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-ib1-09172043/next:master:3319e6f839cf94e33fbad27a21fc4c64f6cec74f=
:bisect-linux-1/.vmlinuz-3319e6f839cf94e33fbad27a21fc4c64f6cec74f-201409190=
01434-43-ivb41 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ib=
1-09172043/3319e6f839cf94e33fbad27a21fc4c64f6cec74f/vmlinuz-3.15.0-rc6-0015=
0-g3319e6f drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 263996K/327160K available (17577K kernel code, 1740K=
 rwdata, 8920K rodata, 764K init, 5556K bss, 63164K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x8c7e0000 - 0xff7fe000   (1840 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x8bfe0000   ( 319 MB)
[    0.000000]       .init : 0x82397000 - 0x82456000   ( 764 kB)
[    0.000000]       .data : 0x8192aa07 - 0x823951a0   (10665 kB)
[    0.000000]       .text : 0x80800000 - 0x8192aa07   (17578 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D89c18000 soft=3D89c1a000
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D26935080)
5387.01 BogoMIPS (lpj=3D26935080)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020051] ACPI: Core revision 20140214
[    0.020051] ACPI: Core revision 20140214
[    0.031360] ACPI:=20
[    0.031360] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.036539] ACPI: setting ELCR to 0200 (from 0c00)
[    0.036539] ACPI: setting ELCR to 0200 (from 0c00)
[    0.037690] Security Framework initialized
[    0.037690] Security Framework initialized
[    0.038613] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.038613] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.039976] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.039976] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.040803] Initializing cgroup subsys debug
[    0.040803] Initializing cgroup subsys debug
[    0.041703] Initializing cgroup subsys devices
[    0.041703] Initializing cgroup subsys devices
[    0.042641] Initializing cgroup subsys net_cls
[    0.042641] Initializing cgroup subsys net_cls
[    0.043563] Initializing cgroup subsys blkio
[    0.043563] Initializing cgroup subsys blkio
[    0.044448] Initializing cgroup subsys net_prio
[    0.044448] Initializing cgroup subsys net_prio
[    0.045478] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.045478] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.045478] tlb_flushall_shift: 6
[    0.045478] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.045478] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.045478] tlb_flushall_shift: 6
[    0.048441] CPU:=20
[    0.048441] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.057027] Performance Events:=20
[    0.057027] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.060204] Getting VERSION: 1050014
[    0.060204] Getting VERSION: 1050014
[    0.060971] Getting VERSION: 1050014
[    0.060971] Getting VERSION: 1050014
[    0.061712] Getting ID: 0
[    0.061712] Getting ID: 0
[    0.062260] Getting ID: f000000
[    0.062260] Getting ID: f000000
[    0.062924] Getting LVT0: 8700
[    0.062924] Getting LVT0: 8700
[    0.063556] Getting LVT1: 8400
[    0.063556] Getting LVT1: 8400
[    0.064217] enabled ExtINT on CPU#0
[    0.064217] enabled ExtINT on CPU#0
[    0.064984] Using local APIC timer interrupts.
[    0.064984] calibrating APIC timer ...
[    0.064984] Using local APIC timer interrupts.
[    0.064984] calibrating APIC timer ...
[    0.070000] ... lapic delta =3D 10624195
[    0.070000] ... lapic delta =3D 10624195
[    0.070000] ... PM-Timer delta =3D 608466
[    0.070000] ... PM-Timer delta =3D 608466
[    0.070000] APIC calibration not consistent with PM-Timer: 169ms instead=
 of 100ms
[    0.070000] APIC calibration not consistent with PM-Timer: 169ms instead=
 of 100ms
[    0.070000] APIC delta adjusted to PM-Timer: 6250099 (10624195)
[    0.070000] APIC delta adjusted to PM-Timer: 6250099 (10624195)
[    0.070000] TSC delta adjusted to PM-Timer: 269350233 (457853409)
[    0.070000] TSC delta adjusted to PM-Timer: 269350233 (457853409)
[    0.070000] ..... delta 6250099
[    0.070000] ..... delta 6250099
[    0.070000] ..... mult: 268439708
[    0.070000] ..... mult: 268439708
[    0.070000] ..... calibration result: 10000158
[    0.070000] ..... calibration result: 10000158
[    0.070000] ..... CPU clock speed is 2693.5023 MHz.
[    0.070000] ..... CPU clock speed is 2693.5023 MHz.
[    0.070000] ..... host bus clock speed is 1000.0158 MHz.
[    0.070000] ..... host bus clock speed is 1000.0158 MHz.
[    0.070702] devtmpfs: initialized
[    0.070702] devtmpfs: initialized
[    0.074175] evm: security.selinux
[    0.074175] evm: security.selinux
[    0.074886] evm: security.SMACK64
[    0.074886] evm: security.SMACK64
[    0.075572] evm: security.capability
[    0.075572] evm: security.capability
[    0.078773] xor: measuring software checksum speed
[    0.078773] xor: measuring software checksum speed
[    0.170010]    pIII_sse  :  5468.400 MB/sec
[    0.170010]    pIII_sse  :  5468.400 MB/sec
[    0.270007]    prefetch64-sse:  8323.200 MB/sec
[    0.270007]    prefetch64-sse:  8323.200 MB/sec
[    0.270965] xor: using function: prefetch64-sse (8323.200 MB/sec)
[    0.270965] xor: using function: prefetch64-sse (8323.200 MB/sec)
[    0.272230] pinctrl core: initialized pinctrl subsystem
[    0.272230] pinctrl core: initialized pinctrl subsystem
[    0.274070] regulator-dummy: no parameters
[    0.274070] regulator-dummy: no parameters
[    0.275347] NET: Registered protocol family 16
[    0.275347] NET: Registered protocol family 16
[    0.279185] cpuidle: using governor ladder
[    0.279185] cpuidle: using governor ladder
[    0.280006] cpuidle: using governor menu
[    0.280006] cpuidle: using governor menu
[    0.282998] ACPI: bus type PCI registered
[    0.282998] ACPI: bus type PCI registered
[    0.283850] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.283850] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.285518] PCI: Using configuration type 1 for base access
[    0.285518] PCI: Using configuration type 1 for base access
[    0.620044] raid6: mmxx1     1596 MB/s
[    0.620044] raid6: mmxx1     1596 MB/s
[    0.790022] raid6: mmxx2     2195 MB/s
[    0.790022] raid6: mmxx2     2195 MB/s
[    0.960047] raid6: sse1x1    1730 MB/s
[    0.960047] raid6: sse1x1    1730 MB/s
[    1.130018] raid6: sse1x2    1851 MB/s
[    1.130018] raid6: sse1x2    1851 MB/s
[    1.300011] raid6: sse2x1    3812 MB/s
[    1.300011] raid6: sse2x1    3812 MB/s
[    1.470014] raid6: sse2x2    5432 MB/s
[    1.470014] raid6: sse2x2    5432 MB/s
[    1.470806] raid6: using algorithm sse2x2 (5432 MB/s)
[    1.470806] raid6: using algorithm sse2x2 (5432 MB/s)
[    1.471857] raid6: using intx1 recovery algorithm
[    1.471857] raid6: using intx1 recovery algorithm
[    1.472967] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.472967] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.474143] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.474143] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.475870] ACPI: Added _OSI(Module Device)
[    1.475870] ACPI: Added _OSI(Module Device)
[    1.476746] ACPI: Added _OSI(Processor Device)
[    1.476746] ACPI: Added _OSI(Processor Device)
[    1.480005] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.480005] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.480979] ACPI: Added _OSI(Processor Aggregator Device)
[    1.480979] ACPI: Added _OSI(Processor Aggregator Device)
[    1.488295] ACPI: Interpreter enabled
[    1.488295] ACPI: Interpreter enabled
[    1.489077] ACPI Exception: AE_NOT_FOUND,=20
[    1.489077] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
 (20140214/hwxface-580)
[    1.491118] ACPI Exception: AE_NOT_FOUND,=20
[    1.491118] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
 (20140214/hwxface-580)
[    1.493072] ACPI: (supports S0 S3 S5)
[    1.493072] ACPI: (supports S0 S3 S5)
[    1.493836] ACPI: Using PIC for interrupt routing
[    1.493836] ACPI: Using PIC for interrupt routing
[    1.494891] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.494891] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.511704] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.511704] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.513001] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.513001] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.514160] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.514160] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.515919] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.515919] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.518899] acpiphp: Slot [3] registered
[    1.518899] acpiphp: Slot [3] registered
[    1.519879] acpiphp: Slot [4] registered
[    1.519879] acpiphp: Slot [4] registered
[    1.520145] acpiphp: Slot [5] registered
[    1.520145] acpiphp: Slot [5] registered
[    1.521103] acpiphp: Slot [6] registered
[    1.521103] acpiphp: Slot [6] registered
[    1.522053] acpiphp: Slot [7] registered
[    1.522053] acpiphp: Slot [7] registered
[    1.523006] acpiphp: Slot [8] registered
[    1.523006] acpiphp: Slot [8] registered
[    1.523967] acpiphp: Slot [9] registered
[    1.523967] acpiphp: Slot [9] registered
[    1.524913] acpiphp: Slot [10] registered
[    1.524913] acpiphp: Slot [10] registered
[    1.525869] acpiphp: Slot [11] registered
[    1.525869] acpiphp: Slot [11] registered
[    1.526838] acpiphp: Slot [12] registered
[    1.526838] acpiphp: Slot [12] registered
[    1.527817] acpiphp: Slot [13] registered
[    1.527817] acpiphp: Slot [13] registered
[    1.528788] acpiphp: Slot [14] registered
[    1.528788] acpiphp: Slot [14] registered
[    1.530147] acpiphp: Slot [15] registered
[    1.530147] acpiphp: Slot [15] registered
[    1.531125] acpiphp: Slot [16] registered
[    1.531125] acpiphp: Slot [16] registered
[    1.532097] acpiphp: Slot [17] registered
[    1.532097] acpiphp: Slot [17] registered
[    1.533066] acpiphp: Slot [18] registered
[    1.533066] acpiphp: Slot [18] registered
[    1.534043] acpiphp: Slot [19] registered
[    1.534043] acpiphp: Slot [19] registered
[    1.535032] acpiphp: Slot [20] registered
[    1.535032] acpiphp: Slot [20] registered
[    1.536003] acpiphp: Slot [21] registered
[    1.536003] acpiphp: Slot [21] registered
[    1.536973] acpiphp: Slot [22] registered
[    1.536973] acpiphp: Slot [22] registered
[    1.537945] acpiphp: Slot [23] registered
[    1.537945] acpiphp: Slot [23] registered
[    1.538922] acpiphp: Slot [24] registered
[    1.538922] acpiphp: Slot [24] registered
[    1.540140] acpiphp: Slot [25] registered
[    1.540140] acpiphp: Slot [25] registered
[    1.541113] acpiphp: Slot [26] registered
[    1.541113] acpiphp: Slot [26] registered
[    1.542095] acpiphp: Slot [27] registered
[    1.542095] acpiphp: Slot [27] registered
[    1.543074] acpiphp: Slot [28] registered
[    1.543074] acpiphp: Slot [28] registered
[    1.544053] acpiphp: Slot [29] registered
[    1.544053] acpiphp: Slot [29] registered
[    1.545024] acpiphp: Slot [30] registered
[    1.545024] acpiphp: Slot [30] registered
[    1.545994] acpiphp: Slot [31] registered
[    1.545994] acpiphp: Slot [31] registered
[    1.546843] PCI host bridge to bus 0000:00
[    1.546843] PCI host bridge to bus 0000:00
[    1.547701] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.547701] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.548827] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.548827] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.550006] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.550006] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.551273] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.551273] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.552542] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.552542] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.553802] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.553802] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.555072] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.555072] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.556490] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.556490] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.557943] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.557943] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.560183] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.560183] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.562262] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.562262] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.566389] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.566389] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.568632] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.568632] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.570006] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.570006] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.571343] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.571343] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.572804] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.572804] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.574616] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.574616] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.576207] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.576207] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.577709] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.577709] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.579728] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.579728] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.581383] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.581383] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.584054] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.584054] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.592538] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.592538] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.594481] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.594481] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.596751] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.596751] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.599035] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.599035] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.604986] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.604986] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.610378] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.610378] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.612163] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.612163] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.630309] pci_bus 0000:00: on NUMA node 0
[    1.630309] pci_bus 0000:00: on NUMA node 0
[    1.632310] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.632310] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.633842] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.633842] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.635364] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.635364] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.636883] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.636883] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.638246] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.638246] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.640374] ACPI:=20
[    1.640374] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.652118] SCSI subsystem initialized
[    1.652118] SCSI subsystem initialized
[    1.652996] libata version 3.00 loaded.
[    1.652996] libata version 3.00 loaded.
[    1.654038] ACPI: bus type USB registered
[    1.654038] ACPI: bus type USB registered
[    1.654983] usbcore: registered new interface driver usbfs
[    1.654983] usbcore: registered new interface driver usbfs
[    1.660075] usbcore: registered new interface driver hub
[    1.660075] usbcore: registered new interface driver hub
[    1.661272] usbcore: registered new device driver usb
[    1.661272] usbcore: registered new device driver usb
[    1.662636] media: Linux media interface: v0.10
[    1.662636] media: Linux media interface: v0.10
[    1.663641] Linux video capture interface: v2.00
[    1.663641] Linux video capture interface: v2.00
[    1.664724] pps_core: LinuxPPS API ver. 1 registered
[    1.664724] pps_core: LinuxPPS API ver. 1 registered
[    1.665755] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.665755] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.667640] PTP clock support registered
[    1.667640] PTP clock support registered
[    1.668919] wmi: Mapper loaded
[    1.668919] wmi: Mapper loaded
[    1.670359] Advanced Linux Sound Architecture Driver Initialized.
[    1.670359] Advanced Linux Sound Architecture Driver Initialized.
[    1.671675] PCI: Using ACPI for IRQ routing
[    1.671675] PCI: Using ACPI for IRQ routing
[    1.672541] PCI: pci_cache_line_size set to 64 bytes
[    1.672541] PCI: pci_cache_line_size set to 64 bytes
[    1.673668] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.673668] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.674917] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    1.674917] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    1.677054] NET: Registered protocol family 23
[    1.677054] NET: Registered protocol family 23
[    1.678059] NET: Registered protocol family 8
[    1.678059] NET: Registered protocol family 8
[    1.678968] NET: Registered protocol family 20
[    1.678968] NET: Registered protocol family 20
[    1.680479] NetLabel: Initializing
[    1.680479] NetLabel: Initializing
[    1.681188] NetLabel:  domain hash size =3D 128
[    1.681188] NetLabel:  domain hash size =3D 128
[    1.682089] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.682089] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.683195] NetLabel:  unlabeled traffic allowed by default
[    1.683195] NetLabel:  unlabeled traffic allowed by default
[    1.684664] cfg80211: Calling CRDA to update world regulatory domain
[    1.684664] cfg80211: Calling CRDA to update world regulatory domain
[    1.688392] Switched to clocksource kvm-clock
[    1.688392] Switched to clocksource kvm-clock
[    1.689641] pnp: PnP ACPI init
[    1.689641] pnp: PnP ACPI init
[    1.690000] ACPI: bus type PNP registered
[    1.690000] ACPI: bus type PNP registered
[    1.690000] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.690000] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.690000] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.690000] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.690000] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.690000] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.690000] pnp 00:03: [dma 2]
[    1.690000] pnp 00:03: [dma 2]
[    1.690000] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.690000] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.690000] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.690000] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.691363] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.691363] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.693333] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.693333] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.695153] pnp 00:07: Plug and Play ACPI device, IDs PNP0a06 (active)
[    1.695153] pnp 00:07: Plug and Play ACPI device, IDs PNP0a06 (active)
[    1.696514] pnp: PnP ACPI: found 8 devices
[    1.696514] pnp: PnP ACPI: found 8 devices
[    1.697358] ACPI: bus type PNP unregistered
[    1.697358] ACPI: bus type PNP unregistered
[    1.698218] PnPBIOS: Disabled
[    1.698218] PnPBIOS: Disabled
[    1.735074] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.735074] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.736254] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.736254] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.737433] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.737433] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.738575] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.738575] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.739716] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.739716] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.740869] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.740869] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.742162] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.742162] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.744088] NET: Registered protocol family 2
[    1.744088] NET: Registered protocol family 2
[    1.745442] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    1.745442] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    1.746971] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    1.746971] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    1.748663] TCP: Hash tables configured (established 4096 bind 4096)
[    1.748663] TCP: Hash tables configured (established 4096 bind 4096)
[    1.750067] TCP: reno registered
[    1.750067] TCP: reno registered
[    1.750748] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    1.750748] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    1.752012] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    1.752012] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    1.753613] NET: Registered protocol family 1
[    1.753613] NET: Registered protocol family 1
[    1.754541] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.754541] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.755769] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.755769] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.756978] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.756978] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.758263] pci 0000:00:02.0: Boot video device
[    1.758263] pci 0000:00:02.0: Boot video device
[    1.759218] PCI: CLS 0 bytes, default 64
[    1.759218] PCI: CLS 0 bytes, default 64
[    1.760438] Trying to unpack rootfs image as initramfs...
[    1.760438] Trying to unpack rootfs image as initramfs...
[    2.976438] debug: unmapping init [mem 0x8a79b000-0x8bfdffff]
[    2.976438] debug: unmapping init [mem 0x8a79b000-0x8bfdffff]
[    2.981429] apm: BIOS not found.
[    2.981429] apm: BIOS not found.
[    2.982582] cryptomgr_test (26) used greatest stack depth: 7252 bytes le=
ft
[    2.982582] cryptomgr_test (26) used greatest stack depth: 7252 bytes le=
ft
[    2.984029] PCLMULQDQ-NI instructions are not detected.
[    2.984029] PCLMULQDQ-NI instructions are not detected.
[    2.985109] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.985109] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.987021] NatSemi SCx200 Driver
[    2.987021] NatSemi SCx200 Driver
[    2.987864] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    2.987864] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    2.991120] spin_lock-torture: Creating torture_shuffle task
[    2.991120] spin_lock-torture: Creating torture_shuffle task
[    2.992380] spin_lock-torture: Creating torture_stutter task
[    2.992380] spin_lock-torture: Creating torture_stutter task
[    2.993584] spin_lock-torture: torture_shuffle task started
[    2.993584] spin_lock-torture: torture_shuffle task started
[    2.994744] spin_lock-torture: Creating lock_torture_writer task
[    2.994744] spin_lock-torture: Creating lock_torture_writer task
[    2.996032] spin_lock-torture: torture_stutter task started
[    2.996032] spin_lock-torture: torture_stutter task started
[    2.997196] spin_lock-torture: Creating lock_torture_writer task
[    2.997196] spin_lock-torture: Creating lock_torture_writer task
[    2.998467] spin_lock-torture: lock_torture_writer task started
[    2.998467] spin_lock-torture: lock_torture_writer task started
[    2.999817] spin_lock-torture: Creating lock_torture_stats task
[    2.999817] spin_lock-torture: Creating lock_torture_stats task
[    3.001123] spin_lock-torture: lock_torture_writer task started
[    3.001123] spin_lock-torture: lock_torture_writer task started
[    3.002373] rcu-torture:--- Start of test: nreaders=3D2 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/1 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    3.002373] rcu-torture:--- Start of test: nreaders=3D2 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/1 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    3.008711] rcu-torture: Creating rcu_torture_writer task
[    3.008711] rcu-torture: Creating rcu_torture_writer task
[    3.009859] spin_lock-torture: lock_torture_stats task started
[    3.009859] spin_lock-torture: lock_torture_stats task started
[    3.011136] rcu-torture: rcu_torture_writer task started
[    3.011136] rcu-torture: rcu_torture_writer task started
[    3.012245] rcu-torture: Creating rcu_torture_fakewriter task
[    3.012245] rcu-torture: Creating rcu_torture_fakewriter task
[    3.013465] rcu-torture: Creating rcu_torture_fakewriter task
[    3.013465] rcu-torture: Creating rcu_torture_fakewriter task
[    3.014699] rcu-torture: rcu_torture_fakewriter task started
[    3.014699] rcu-torture: rcu_torture_fakewriter task started
[    3.015884] rcu-torture: Creating rcu_torture_fakewriter task
[    3.015884] rcu-torture: Creating rcu_torture_fakewriter task
[    3.017113] rcu-torture: rcu_torture_fakewriter task started
[    3.017113] rcu-torture: rcu_torture_fakewriter task started
[    3.018505] rcu-torture: Creating rcu_torture_fakewriter task
[    3.018505] rcu-torture: Creating rcu_torture_fakewriter task
[    3.019733] rcu-torture: rcu_torture_fakewriter task started
[    3.019733] rcu-torture: rcu_torture_fakewriter task started
[    3.021909] rcu-torture: Creating rcu_torture_reader task
[    3.021909] rcu-torture: Creating rcu_torture_reader task
[    3.023068] rcu-torture: rcu_torture_fakewriter task started
[    3.023068] rcu-torture: rcu_torture_fakewriter task started
[    3.024243] rcu-torture: Creating rcu_torture_reader task
[    3.024243] rcu-torture: Creating rcu_torture_reader task
[    3.025394] rcu-torture: rcu_torture_reader task started
[    3.025394] rcu-torture: rcu_torture_reader task started
[    3.026498] rcu-torture: Creating rcu_torture_stats task
[    3.026498] rcu-torture: Creating rcu_torture_stats task
[    3.027622] rcu-torture: rcu_torture_reader task started
[    3.027622] rcu-torture: rcu_torture_reader task started
[    3.028732] rcu-torture: Creating torture_shuffle task
[    3.028732] rcu-torture: Creating torture_shuffle task
[    3.029827] rcu-torture: rcu_torture_stats task started
[    3.029827] rcu-torture: rcu_torture_stats task started
[    3.030969] rcu-torture: Creating torture_stutter task
[    3.030969] rcu-torture: Creating torture_stutter task
[    3.032709] rcu-torture: torture_shuffle task started
[    3.032709] rcu-torture: torture_shuffle task started
[    3.033784] rcu-torture: Creating rcu_torture_boost task
[    3.033784] rcu-torture: Creating rcu_torture_boost task
[    3.034957] rcu-torture: torture_stutter task started
[    3.034957] rcu-torture: torture_stutter task started
[    3.036985] futex hash table entries: 256 (order: 1, 11264 bytes)
[    3.036985] futex hash table entries: 256 (order: 1, 11264 bytes)
[    3.038302] audit: initializing netlink subsys (disabled)
[    3.038302] audit: initializing netlink subsys (disabled)
[    3.039548] audit: type=3D2000 audit(1411057464.504:1): initialized
[    3.039548] audit: type=3D2000 audit(1411057464.504:1): initialized
[    3.041092] rcu-torture: rcu_torture_boost started
[    3.041092] rcu-torture: rcu_torture_boost started
[    3.043620] DLM installed
[    3.043620] DLM installed
[    3.044609] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.044609] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.046360] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    3.046360] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    3.047560] fuse init (API version 7.23)
[    3.047560] fuse init (API version 7.23)
[    3.048767] JFS: nTxBlock =3D 2062, nTxLock =3D 16499
[    3.048767] JFS: nTxBlock =3D 2062, nTxLock =3D 16499
[    3.051465] 9p: Installing v9fs 9p2000 file system support
[    3.051465] 9p: Installing v9fs 9p2000 file system support
[    3.052690] NILFS version 2 loaded
[    3.052690] NILFS version 2 loaded
[    3.053399] befs: version: 0.9.3
[    3.053399] befs: version: 0.9.3
[    3.054142] ceph: loaded (mds proto 32)
[    3.054142] ceph: loaded (mds proto 32)
[    3.054960] msgmni has been set to 515
[    3.054960] msgmni has been set to 515
[    3.059132] NET: Registered protocol family 38
[    3.059132] NET: Registered protocol family 38
[    3.060119] async_tx: api initialized (async)
[    3.060119] async_tx: api initialized (async)
[    3.061083] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    3.061083] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    3.062830] io scheduler noop registered (default)
[    3.062830] io scheduler noop registered (default)
[    3.063826] io scheduler deadline registered
[    3.063826] io scheduler deadline registered
[    3.065129] xz_dec_test: module loaded
[    3.065129] xz_dec_test: module loaded
[    3.065916] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
248 0' and write .xz files to it.
[    3.065916] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
248 0' and write .xz files to it.
[    3.069080] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.069080] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.070303] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    3.070303] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    3.071891] cpcihp_generic: not configured, disabling.
[    3.071891] cpcihp_generic: not configured, disabling.
[    3.073009] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.073009] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.077221] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    3.077221] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    3.079248] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.079248] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.081035] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.081035] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.082847] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.082847] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.084823] vmlfb: initializing
[    3.084823] vmlfb: initializing
[    3.086106] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    3.086106] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    3.088661] usbcore: registered new interface driver udlfb
[    3.088661] usbcore: registered new interface driver udlfb
[    3.089855] usbcore: registered new interface driver smscufx
[    3.089855] usbcore: registered new interface driver smscufx
[    3.091683] kworker/u2:0 (93) used greatest stack depth: 7056 bytes left
[    3.091683] kworker/u2:0 (93) used greatest stack depth: 7056 bytes left
[    3.093120] uvesafb: failed to execute /sbin/v86d
[    3.093120] uvesafb: failed to execute /sbin/v86d
[    3.094099] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    3.094099] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    3.095598] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    3.095598] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    3.096955] uvesafb: vbe_init() failed with -22
[    3.096955] uvesafb: vbe_init() failed with -22
[    3.097900] uvesafb: probe of uvesafb.0 failed with error -22
[    3.097900] uvesafb: probe of uvesafb.0 failed with error -22
[    3.099322] ipmi message handler version 39.2
[    3.099322] ipmi message handler version 39.2
[    3.100367] IPMI System Interface driver.
[    3.100367] IPMI System Interface driver.
[    3.101330] ipmi_si: Adding default-specified kcs state machine
[    3.101330] ipmi_si: Adding default-specified kcs state machine

[    3.102577] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.102577] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.104629] ipmi_si: Interface detection failed
[    3.104629] ipmi_si: Interface detection failed
[    3.105584] ipmi_si: Adding default-specified smic state machine
[    3.105584] ipmi_si: Adding default-specified smic state machine

[    3.106838] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.106838] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.108905] ipmi_si: Interface detection failed
[    3.108905] ipmi_si: Interface detection failed
[    3.109844] ipmi_si: Adding default-specified bt state machine
[    3.109844] ipmi_si: Adding default-specified bt state machine

[    3.111507] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.111507] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.113517] ipmi_si: Interface detection failed
[    3.113517] ipmi_si: Interface detection failed
[    3.114598] ipmi_si: Unable to find any System Interface(s)
[    3.114598] ipmi_si: Unable to find any System Interface(s)
[    3.980122] tsc: Refined TSC clocksource calibration: 2693.502 MHz
[    3.980122] tsc: Refined TSC clocksource calibration: 2693.502 MHz
[   63.010563] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[   63.010563] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[   63.042093] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[   63.042093] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[   63.042093] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[   63.042093] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[   63.042093] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[   63.042093] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[   63.042093] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[   63.042093] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  123.010053] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  123.010053] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  123.040080] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  123.040080] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  123.040080] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  123.040080] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  123.040080] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  123.040080] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  123.040080] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  123.040080] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  183.010051] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  183.010051] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  183.040085] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  183.040085] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  183.040085] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  183.040085] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  183.040085] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  183.040085] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  183.040085] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  183.040085] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  243.010055] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  243.010055] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  243.040086] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  243.040086] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  243.040086] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  243.040086] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  243.040086] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  243.040086] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  243.040086] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  243.040086] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  303.010072] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  303.010072] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  303.040711] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  303.040711] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  303.040711] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  303.040711] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  303.040711] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  303.040711] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  303.040711] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  303.040711] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  363.010066] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  363.010066] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  363.125086] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  363.125086] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  363.125086] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  363.125086] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  363.125086] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  363.125086] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  363.125086] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  363.125086] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  423.018148] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  423.018148] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  423.130055] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  423.130055] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  423.130055] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  423.130055] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  423.130055] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  423.130055] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  423.130055] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  423.130055] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  483.020064] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  483.020064] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  483.202123] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  483.202123] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  483.202123] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  483.202123] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  483.202123] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  483.202123] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  483.202123] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  483.202123] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  543.060060] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  543.060060] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  543.201129] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  543.201129] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  543.201129] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  543.201129] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  543.201129] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  543.201129] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  543.201129] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  543.201129] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  603.080047] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  603.080047] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  603.234114] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  603.234114] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  603.234114] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  603.234114] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  603.234114] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  603.234114] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  603.234114] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  603.234114] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  663.080064] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  663.080064] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  663.249103] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  663.249103] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  663.249103] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  663.249103] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  663.249103] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  663.249103] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  663.249103] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  663.249103] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  723.120054] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  723.120054] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  723.250055] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  723.250055] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  723.250055] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  723.250055] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  723.250055] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  723.250055] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  723.250055] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  723.250055] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  783.120052] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  783.120052] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  783.280043] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  783.280043] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  783.280043] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  783.280043] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  783.280043] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  783.280043] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  783.280043] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  783.280043] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  843.120077] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  843.120077] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  843.310053] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  843.310053] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  843.310053] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  843.310053] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  843.310053] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  843.310053] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  843.310053] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  843.310053] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  903.120069] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  903.120069] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  903.340057] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  903.340057] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  903.340057] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  903.340057] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  903.340057] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  903.340057] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  903.340057] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  903.340057] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  963.120087] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  963.120087] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  963.390172] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  963.390172] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  963.390172] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  963.390172] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  963.390172] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[  963.390172] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[  963.390172] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[  963.390172] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1023.122151] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1023.122151] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1023.390046] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1023.390046] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1023.390046] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1023.390046] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1023.390046] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1023.390046] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1023.390046] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1023.390046] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1083.120066] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1083.120066] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1083.452152] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1083.452152] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1083.452152] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1083.452152] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1083.452152] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1083.452152] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1083.452152] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1083.452152] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1143.120061] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1143.120061] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1143.450046] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1143.450046] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1143.450046] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1143.450046] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1143.450046] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1143.450046] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1143.450046] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1143.450046] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1203.129163] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1203.129163] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1203.450056] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1203.450056] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1203.450056] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1203.450056] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1203.450056] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1203.450056] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1203.450056] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1203.450056] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1263.132168] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1263.132168] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1263.523443] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1263.523443] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1263.523443] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1263.523443] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1263.523443] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1263.523443] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1263.523443] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1263.523443] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1323.139173] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1323.139173] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1323.557168] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1323.557168] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1323.557168] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1323.557168] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1323.557168] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1323.557168] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1323.557168] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1323.557168] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1383.142062] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1383.142062] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1383.560054] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1383.560054] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1383.560054] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1383.560054] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1383.560054] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1383.560054] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1383.560054] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1383.560054] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1443.143477] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1443.143477] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1443.590059] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1443.590059] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1443.590059] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1443.590059] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1443.590059] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1443.590059] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1443.590059] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1443.590059] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1503.140047] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1503.140047] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1503.590043] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1503.590043] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1503.590043] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1503.590043] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1503.590043] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1503.590043] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1503.590043] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1503.590043] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1563.153208] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1563.153208] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1563.678209] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1563.678209] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1563.678209] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1563.678209] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1563.678209] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1563.678209] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1563.678209] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1563.678209] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1623.150064] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1623.150064] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1623.680050] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1623.680050] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1623.680050] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1623.680050] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1623.680050] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1623.680050] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1623.680050] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1623.680050] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1683.150064] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1683.150064] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1683.740058] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1683.740058] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1683.740058] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1683.740058] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1683.740058] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1683.740058] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1683.740058] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1683.740058] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1743.150053] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1743.150053] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1743.780056] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1743.780056] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1743.780056] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1743.780056] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1743.780056] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1743.780056] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1743.780056] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1743.780056] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1803.150061] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1803.150061] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[ 1803.780053] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1803.780053] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1803.780053] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1803.780053] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1803.780053] rcu-torture: rtc: 829520c0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf=
: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 barrier: 0/0:0
[ 1803.780053] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
[ 1803.780053] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
[ 1803.780053] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0

BUG: kernel boot hang
Elapsed time: 1805
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-i=
b1-09172043/3319e6f839cf94e33fbad27a21fc4c64f6cec74f/vmlinuz-3.15.0-rc6-001=
50-g3319e6f -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug a=
pic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib1=
-09172043/next:master:3319e6f839cf94e33fbad27a21fc4c64f6cec74f:bisect-linux=
-1/.vmlinuz-3319e6f839cf94e33fbad27a21fc4c64f6cec74f-20140919001434-43-ivb4=
1 branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ib1-09172043/33=
19e6f839cf94e33fbad27a21fc4c64f6cec74f/vmlinuz-3.15.0-rc6-00150-g3319e6f dr=
bd.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m =
320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm=
/kboot/pid-quantal-ivb41-16 -serial file:/dev/shm/kboot/serial-quantal-ivb4=
1-16 -daemonize -display none -monitor null=20

--+HP7ph2BbKc20aGI
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-ib1-09172043-76c2c6dc46fbb5bdd73571ebd0897696c5ab4d73-BUG:-unable-to-handle-kernel-13972.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNzZjMmM2ZC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA5MTcKZ2l0IGNoZWNrb3V0IDllODJiZjAxNDE5NWQ2ZjAwNTQ5ODJjNDYz
NTc1Y2RjZTI0MjkyYmUKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvbmV4dDptYXN0ZXI6OWU4MmJmMDE0MTk1ZDZmMDA1
NDk4MmM0NjM1NzVjZGNlMjQyOTJiZTpiaXNlY3QtbGludXgtMQoKMjAxNC0wOS0xNyAyMDo1
Nzo1NSA5ZTgyYmYwMTQxOTVkNmYwMDU0OTgyYzQ2MzU3NWNkY2UyNDI5MmJlIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1p
YjAzL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtOWU4MmJmMDE0MTk1ZDZmMDA1NDk4
MmM0NjM1NzVjZGNlMjQyOTJiZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0My85ZTgyYmYwMTQxOTVkNmYwMDU0OTgyYzQ2MzU3NWNk
Y2UyNDI5MmJlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9sa3AtaWIwMy9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTllODJiZjAx
NDE5NWQ2ZjAwNTQ5ODJjNDYzNTc1Y2RjZTI0MjkyYmUKG1sxOzM1bTIwMTQtMDktMTcgMjE6
MDk6NTUgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQv
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My05ZTgyYmYwMTQxOTVkNmYwMDU0OTgyYzQ2
MzU3NWNkY2UyNDI5MmJlG1swbQpSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMtc21va2UvaTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0My05ZTgyYmYwMTQxOTVkNmYwMDU0OTgyYzQ2MzU3NWNk
Y2UyNDI5MmJlCnN0YXR1czogRkFJTDogYnVpbGQgZXJyb3IKG1sxOzM1bTIwMTQtMDktMTcg
MjE6MjU6NTUgS2VybmVsIGJ1aWxkIGZhaWwgb3IgdGltZW91dBtbMG0KMjAxNC0wOS0xNyAy
MToyNTo1NSA5ZTgyYmYwMTQxOTVkNmYwMDU0OTgyYzQ2MzU3NWNkY2UyNDI5MmJlIFNLSVAg
QlJPS0VOIEJVSUxECkNoZWNrIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDkxNzIwNDMtOWU4MmJmMDE0MTk1ZDZmMDA1NDk4MmM0NjM1NzVjZGNl
MjQyOTJiZQpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciA5ZTgyYmYwMTQxOTVkNmYw
MDU0OTgyYzQ2MzU3NWNkY2UyNDI5MmJlCmdpdCBjaGVja291dCB2My4xNgpscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9u
ZXh0Om1hc3RlcjoxOTU4M2NhNTg0ZDZmNTc0Mzg0ZTE3ZmU3NjEzZGZhZWFkY2RjNGE2OmJp
c2VjdC1saW51eC0xCgoyMDE0LTA5LTE3IDIxOjI2OjAxIDE5NTgzY2E1ODRkNmY1NzQzODRl
MTdmZTc2MTNkZmFlYWRjZGM0YTYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0My0xOTU4M2NhNTg0ZDZmNTc0Mzg0ZTE3ZmU3NjEzZGZhZWFkY2RjNGE2CkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzE5
NTgzY2E1ODRkNmY1NzQzODRlMTdmZTc2MTNkZmFlYWRjZGM0YTYKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDkxNzIwNDMtMTk1ODNjYTU4NGQ2ZjU3NDM4NGUxN2ZlNzYxM2RmYWVh
ZGNkYzRhNgobWzE7MzVtMjAxNC0wOS0xNyAyMTo1NzowMSBObyBidWlsZCBzZXJ2ZWQgZmls
ZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcy
MDQzLTE5NTgzY2E1ODRkNmY1NzQzODRlMTdmZTc2MTNkZmFlYWRjZGM0YTYbWzBtClJldHJ5
IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9sa3AtaWIwMy1zbW9rZS9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTE5
NTgzY2E1ODRkNmY1NzQzODRlMTdmZTc2MTNkZmFlYWRjZGM0YTYKa2VybmVsOiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvMTk1ODNjYTU4NGQ2ZjU3NDM4NGUxN2Zl
NzYxM2RmYWVhZGNkYzRhNi92bWxpbnV6LTMuMTYuMAoKMjAxNC0wOS0xNyAyMTo1OTowMSBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uIFRFU1QgRkFJTFVSRQpbICAgIDYuNDI1OTE2XSB1
c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91c2JfdHR1c2Iy
ClsgICAgNi40MjY5NDRdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2
ZXIgZHZiX3VzYl9hZjkwMDUKWyAgICA2LjQyNjk0NF0gdXNiY29yZTogcmVnaXN0ZXJlZCBu
ZXcgaW50ZXJmYWNlIGRyaXZlciBkdmJfdXNiX2FmOTAwNQpbICAgIDYuNDI3OTI3XSBCVUc6
IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIApbICAgIDYuNDI3OTI3XSBCVUc6IHVuYWJsZSB0
byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0cGFnaW5nIHJlcXVlc3QgYXQgMDI4MDAw
MDAKIGF0IDAyODAwMDAwClsgICAgNi40Mjg5MzFdIElQOgpbICAgIDYuNDI4OTMxXSBJUDog
Wzw3ZDQzNzFmMj5dIGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkCiBbPDdkNDM3
MWYyPl0gYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQKWyAgICA2LjQyOTgzOF0g
KnBkZSA9IDAwMDAwMDAwIApbICAgIDYuNDI5ODM4XSAqcGRlID0gMDAwMDAwMDAgCgpbICAg
IDYuNDMwMzA4XSBPb3BzOiAwMDAwIFsjMV0gClsgICAgNi40MzAzMDhdIE9vcHM6IDAwMDAg
WyMxXSBQUkVFTVBUIFBSRUVNUFQgREVCVUdfUEFHRUFMTE9DREVCVUdfUEFHRUFMTE9DCgpb
ICAgIDYuNDMwNTc2XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQg
My4xNi4wICMxClsgICAgNi40MzA1NzZdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBO
b3QgdGFpbnRlZCAzLjE2LjAgIzEKWyAgICA2LjQzMDU3Nl0gSGFyZHdhcmUgbmFtZTogQm9j
aHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDYuNDMwNTc2XSBIYXJkd2Fy
ZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgNi40MzA1
NzZdIHRhc2s6IDg5Y2E4NjYwIHRpOiA4OWNhYzAwMCB0YXNrLnRpOiA4OWNhYzAwMApbICAg
IDYuNDMwNTc2XSB0YXNrOiA4OWNhODY2MCB0aTogODljYWMwMDAgdGFzay50aTogODljYWMw
MDAKWyAgICA2LjQzMDU3Nl0gRUlQOiAwMDYwOls8N2Q0MzcxZjI+XSBFRkxBR1M6IDAwMDEw
MjA2IENQVTogMApbICAgIDYuNDMwNTc2XSBFSVA6IDAwNjA6Wzw3ZDQzNzFmMj5dIEVGTEFH
UzogMDAwMTAyMDYgQ1BVOiAwClsgICAgNi40MzA1NzZdIEVJUCBpcyBhdCBhZjkwMDVfdXNi
X21vZHVsZV9pbml0KzB4NmIvMHg5ZApbICAgIDYuNDMwNTc2XSBFSVAgaXMgYXQgYWY5MDA1
X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQKWyAgICA2LjQzMDU3Nl0gRUFYOiAwMjgwMDAw
MCBFQlg6IDAwMDAwMDAwIEVDWDogMDAwMDAwMDYgRURYOiAwMDAwMDAwMApbICAgIDYuNDMw
NTc2XSBFQVg6IDAyODAwMDAwIEVCWDogMDAwMDAwMDAgRUNYOiAwMDAwMDAwNiBFRFg6IDAw
MDAwMDAwClsgICAgNi40MzA1NzZdIEVTSTogNzgzMzY3ZTAgRURJOiAwMDAwMDAwMCBFQlA6
IDg5Y2FkZjMwIEVTUDogODljYWRmMmMKWyAgICA2LjQzMDU3Nl0gRVNJOiA3ODMzNjdlMCBF
REk6IDAwMDAwMDAwIEVCUDogODljYWRmMzAgRVNQOiA4OWNhZGYyYwpbICAgIDYuNDMwNTc2
XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgICA2
LjQzMDU3Nl0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4
ClsgICAgNi40MzA1NzZdIENSMDogODAwNTAwM2IgQ1IyOiAwMjgwMDAwMCBDUjM6IDA1NGI2
MDAwIENSNDogMDAwMDA2OTAKWyAgICA2LjQzMDU3Nl0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAy
ODAwMDAwIENSMzogMDU0YjYwMDAgQ1I0OiAwMDAwMDY5MApbICAgIDYuNDMwNTc2XSBTdGFj
azoKWyAgICA2LjQzMDU3Nl0gU3RhY2s6ClsgICAgNi40MzA1NzZdICA3ZDQzNzE4NwpbICAg
IDYuNDMwNTc2XSAgN2Q0MzcxODcgODljYWRmOTAgODljYWRmOTAgN2QzZjJjMTIgN2QzZjJj
MTIgOGJmZjY5NjIgOGJmZjY5NjIgODljYWRmNGMgODljYWRmNGMgN2I4M2IwMDAgN2I4M2Iw
MDAgN2NhYzJiNzAgN2NhYzJiNzAgOGJmZjY5NTEgOGJmZjY5NTEKClsgICAgNi40MzA1NzZd
ICA4OWNhZGY4MApbICAgIDYuNDMwNTc2XSAgODljYWRmODAgN2I4M2IxOTQgN2I4M2IxOTQg
MDAwMDAxYjggMDAwMDAxYjggMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDAwMDYg
N2QyMmJjNGMgN2QyMmJjNGMgOGJmZjY5NjMgOGJmZjY5NjMgN2QyMmQ3ZGMgN2QyMmQ3ZGMK
ClsgICAgNi40MzA1NzZdICAwMDAwMDIwMApbICAgIDYuNDMwNTc2XSAgMDAwMDAyMDAgN2Qx
MDRhNjIgN2QxMDRhNjIgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDA5ZDEgMDAwMDA5ZDEgN2Q0
OTRkMDggN2Q0OTRkMDggOGQ5Zjg3NjYgOGQ5Zjg3NjYgMDAwMDAwMDYgMDAwMDAwMDYgMDAw
MDA5ZDEgMDAwMDA5ZDEKClsgICAgNi40MzA1NzZdIENhbGwgVHJhY2U6ClsgICAgNi40MzA1
NzZdIENhbGwgVHJhY2U6ClsgICAgNi40MzA1NzZdICBbPDdkNDM3MTg3Pl0gPyB0dHVzYjJf
ZHJpdmVyX2luaXQrMHgxNi8weDE2ClsgICAgNi40MzA1NzZdICBbPDdkNDM3MTg3Pl0gPyB0
dHVzYjJfZHJpdmVyX2luaXQrMHgxNi8weDE2ClsgICAgNi40MzA1NzZdICBbPDdkM2YyYzEy
Pl0gZG9fb25lX2luaXRjYWxsKzB4MTYwLzB4MTZmClsgICAgNi40MzA1NzZdICBbPDdkM2Yy
YzEyPl0gZG9fb25lX2luaXRjYWxsKzB4MTYwLzB4MTZmClsgICAgNi40MzA1NzZdICBbPDdi
ODNiMDAwPl0gPyBwYXJhbV9hcnJheV9zZXQrMHhhYy8weGM3ClsgICAgNi40MzA1NzZdICBb
PDdiODNiMDAwPl0gPyBwYXJhbV9hcnJheV9zZXQrMHhhYy8weGM3ClsgICAgNi40MzA1NzZd
ICBbPDdiODNiMTk0Pl0gPyBwYXJzZV9hcmdzKzB4MTI0LzB4MjY4ClsgICAgNi40MzA1NzZd
ICBbPDdiODNiMTk0Pl0gPyBwYXJzZV9hcmdzKzB4MTI0LzB4MjY4ClsgICAgNi40MzA1NzZd
ICBbPDdkM2YyZDBiPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhlYS8weDE2NwpbICAgIDYu
NDMwNTc2XSAgWzw3ZDNmMmQwYj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZWEvMHgxNjcK
WyAgICA2LjQzMDU3Nl0gIFs8N2M5MmYzNjQ+XSBrZXJuZWxfaW5pdCsweDgvMHhiOApbICAg
IDYuNDMwNTc2XSAgWzw3YzkyZjM2ND5dIGtlcm5lbF9pbml0KzB4OC8weGI4ClsgICAgNi40
MzA1NzZdICBbPDdjOTU2MjIwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAK
WyAgICA2LjQzMDU3Nl0gIFs8N2M5NTYyMjA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4
MjAvMHgzMApbICAgIDYuNDMwNTc2XSAgWzw3YzkyZjM1Yz5dID8gcmVzdF9pbml0KzB4MTBj
LzB4MTBjClsgICAgNi40MzA1NzZdICBbPDdjOTJmMzVjPl0gPyByZXN0X2luaXQrMHgxMGMv
MHgxMGMKWyAgICA2LjQzMDU3Nl0gQ29kZToKWyAgICA2LjQzMDU3Nl0gQ29kZTogMDggMDgg
YzIgYzIgYzcgYzcgMDUgMDUgYTQgYTQgMTkgMTkgY2EgY2EgN2QgN2QgMDAgMDAgMDAgMDAg
ODAgODAgMDIgMDIgYzcgYzcgMDUgMDUgYTAgYTAgMTkgMTkgY2EgY2EgN2QgN2QgMDAgMDAg
MDAgMDAgODAgODAgMDIgMDIgYzcgYzcgMDUgMDUgOWMgOWMgMTkgMTkgY2EgY2EgN2QgN2Qg
MDAgMDAgMDAgMDAgODAgODAgMDIgMDIgNzUgNzUgMWYgMWYgYjggYjggMDAgMDAgMDAgMDAg
ODAgODAgMDIgMDIgODUgODUgYzAgYzAgNzQgNzQgMTYgMTYgPGExPiA8YTE+IDAwIDAwIDAw
IDAwIDgwIDgwIDAyIDAyIGM3IGM3IDA1IDA1IDM0IDM0IDJkIDJkIDM0IDM0IDdkIDdkIDAw
IDAwIDAwIDAwIDgwIDgwIDAyIDAyIGEzIGEzIDM4IDM4IDJkIDJkIDM0IDM0IDdkIDdkIGVi
IGViCgpbICAgIDYuNDMwNTc2XSBFSVA6IFs8N2Q0MzcxZjI+XSAKWyAgICA2LjQzMDU3Nl0g
RUlQOiBbPDdkNDM3MWYyPl0gYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWRhZjkw
MDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZCBTUzpFU1AgMDA2ODo4OWNhZGYyYwogU1M6
RVNQIDAwNjg6ODljYWRmMmMKWyAgICA2LjQzMDU3Nl0gQ1IyOiAwMDAwMDAwMDAyODAwMDAw
ClsgICAgNi40MzA1NzZdIENSMjogMDAwMDAwMDAwMjgwMDAwMApbICAgIDYuNDMwNTc2XSAt
LS1bIGVuZCB0cmFjZSAyN2E0NGI2ZDYzNmJmNmI3IF0tLS0KWyAgICA2LjQzMDU3Nl0gLS0t
WyBlbmQgdHJhY2UgMjdhNDRiNmQ2MzZiZjZiNyBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wOTE3MjA0My8xOTU4M2NhNTg0ZDZmNTc0Mzg0ZTE3ZmU3NjEzZGZhZWFkY2Rj
NGE2L2RtZXNnLXF1YW50YWwtdnAtMTE6MjAxNDA5MTcyMjAwNDI6aTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0MzozLjE2LjA6MQowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwobWzE7MzVtMjAxNC0wOS0xNyAyMjowMTowMiBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4LTEvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQg
Y29tbWl0IHYzLjE2CmdpdCBjaGVja291dCB2My4xNQpscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9uZXh0Om1hc3Rlcjox
ODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkOmJpc2VjdC1saW51eC0x
CgoyMDE0LTA5LTE3IDIyOjAxOjA3IDE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZl
NWFmZDlkMGQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My0xODYw
ZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzE4NjBlMzc5ODc1ZGZl
NzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDkxNzIwNDMtMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZAobWzE7
MzVtMjAxNC0wOS0xNyAyMjowMzowOCBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRl
c3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTE4NjBlMzc5
ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQbWzBtClJldHJ5IGJ1aWxkIC4uCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3At
aWIwMy1zbW9rZS9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTE4NjBlMzc5ODc1ZGZl
NzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDkxNzIwNDMvMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZk
OWQwZC92bWxpbnV6LTMuMTUuMAoKMjAxNC0wOS0xNyAyMjowNTowOCBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4JMS4JMi4JNS4JNy4JOAk5LgkxMQkxMgkxMy4uCTE1Li4uLi4uLi4u
LgkxNi4uCTE3Li4uCTE4LgkxOS4JMjAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2
My4xNQpnaXQgYmlzZWN0IHN0YXJ0IHYzLjE2IHYzLjE1IC0tCi9jL2tlcm5lbC10ZXN0cy9s
aW5lYXItYmlzZWN0OiBbIi1iIiwgInYzLjE2IiwgIi1nIiwgInYzLjE1IiwgIi9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1iaXNlY3Qv
bGludXgtMS9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAxMzgzMCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpCls1MTcwYTNiMjRhOTE0MWUy
MzQ5YTM0MjA0NDg3NDNiN2M2OGYyMjIzXSBNZXJnZSBicmFuY2ggJ2FrcG0nIChwYXRjaGVz
IGZyb20gQW5kcmV3IE1vcnRvbikKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTEvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0My9uZXh0Om1hc3Rlcjo1MTcwYTNiMjRhOTE0MWUyMzQ5YTM0MjA0NDg3NDNiN2M2
OGYyMjIzOmJpc2VjdC1saW51eC0xCgoyMDE0LTA5LTE3IDIyOjU0OjQzIDUxNzBhM2IyNGE5
MTQxZTIzNDlhMzQyMDQ0ODc0M2I3YzY4ZjIyMjMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wOTE3MjA0My01MTcwYTNiMjRhOTE0MWUyMzQ5YTM0MjA0NDg3NDNiN2M2OGYy
MjIzCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5
MTcyMDQzLzUxNzBhM2IyNGE5MTQxZTIzNDlhMzQyMDQ0ODc0M2I3YzY4ZjIyMjMKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAz
LXNtb2tlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtNTE3MGEzYjI0YTkxNDFlMjM0
OWEzNDIwNDQ4NzQzYjdjNjhmMjIyMwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0My81MTcwYTNiMjRhOTE0MWUyMzQ5YTM0MjA0NDg3NDNiN2M2OGYyMjIz
L3ZtbGludXotMy4xNi4wLXJjMy0wMDA5MS1nNTE3MGEzYgoKMjAxNC0wOS0xNyAyMjo1Nzo0
MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgMTAuNTI2NDgwXSB1
c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91c2JfdHR1c2Iy
ClsgICAxMC41Mjc1MjRdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2
ZXIgZHZiX3VzYl9hZjkwMDUKWyAgIDEwLjUyNzUyNF0gdXNiY29yZTogcmVnaXN0ZXJlZCBu
ZXcgaW50ZXJmYWNlIGRyaXZlciBkdmJfdXNiX2FmOTAwNQpbICAgMTAuNTI4NDkxXSBCVUc6
IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIApbICAgMTAuNTI4NDkxXSBCVUc6IHVuYWJsZSB0
byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0cGFnaW5nIHJlcXVlc3QgYXQgMGRhMDAw
MDAKIGF0IDBkYTAwMDAwClsgICAxMC41Mjk0NzddIElQOgpbICAgMTAuNTI5NDc3XSBJUDog
Wzw4ODYzNzBmMT5dIGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkCiBbPDg4NjM3
MGYxPl0gYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQKWyAgIDEwLjUzMDI0N10g
KnBkZSA9IDAwMDAwMDAwIApbICAgMTAuNTMwMjQ3XSAqcGRlID0gMDAwMDAwMDAgCgpbICAg
MTAuNTMwMjQ3XSBPb3BzOiAwMDAwIFsjMV0gClsgICAxMC41MzAyNDddIE9vcHM6IDAwMDAg
WyMxXSBQUkVFTVBUIFBSRUVNUFQgREVCVUdfUEFHRUFMTE9DREVCVUdfUEFHRUFMTE9DCgpb
ICAgMTAuNTMwMjQ3XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQg
My4xNi4wLXJjMy0wMDA5MS1nNTE3MGEzYiAjMQpbICAgMTAuNTMwMjQ3XSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNi4wLXJjMy0wMDA5MS1nNTE3MGEz
YiAjMQpbICAgMTAuNTMwMjQ3XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBC
b2NocyAwMS8wMS8yMDExClsgICAxMC41MzAyNDddIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJv
Y2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDEwLjUzMDI0N10gdGFzazogOGI0YTg2
NjAgdGk6IDhiNGFjMDAwIHRhc2sudGk6IDhiNGFjMDAwClsgICAxMC41MzAyNDddIHRhc2s6
IDhiNGE4NjYwIHRpOiA4YjRhYzAwMCB0YXNrLnRpOiA4YjRhYzAwMApbICAgMTAuNTMwMjQ3
XSBFSVA6IDAwNjA6Wzw4ODYzNzBmMT5dIEVGTEFHUzogMDAwMTAyMDYgQ1BVOiAwClsgICAx
MC41MzAyNDddIEVJUDogMDA2MDpbPDg4NjM3MGYxPl0gRUZMQUdTOiAwMDAxMDIwNiBDUFU6
IDAKWyAgIDEwLjUzMDI0N10gRUlQIGlzIGF0IGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2
Yi8weDlkClsgICAxMC41MzAyNDddIEVJUCBpcyBhdCBhZjkwMDVfdXNiX21vZHVsZV9pbml0
KzB4NmIvMHg5ZApbICAgMTAuNTMwMjQ3XSBFQVg6IDBkYTAwMDAwIEVCWDogMDAwMDAwMDAg
RUNYOiAwMDAwMDAwNiBFRFg6IDAwMDAwMDAwClsgICAxMC41MzAyNDddIEVBWDogMGRhMDAw
MDAgRUJYOiAwMDAwMDAwMCBFQ1g6IDAwMDAwMDA2IEVEWDogMDAwMDAwMDAKWyAgIDEwLjUz
MDI0N10gRVNJOiA4NWIwNDE4MCBFREk6IDAwMDAwMDAwIEVCUDogOGI0YWRmMzAgRVNQOiA4
YjRhZGYyYwpbICAgMTAuNTMwMjQ3XSBFU0k6IDg1YjA0MTgwIEVESTogMDAwMDAwMDAgRUJQ
OiA4YjRhZGYzMCBFU1A6IDhiNGFkZjJjClsgICAxMC41MzAyNDddICBEUzogMDA3YiBFUzog
MDA3YiBGUzogMDAwMCBHUzogMDBlMCBTUzogMDA2OApbICAgMTAuNTMwMjQ3XSAgRFM6IDAw
N2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDEwLjUzMDI0N10g
Q1IwOiA4MDA1MDAzYiBDUjI6IDBkYTAwMDAwIENSMzogMTFlMjkwMDAgQ1I0OiAwMDAwMDY5
MApbICAgMTAuNTMwMjQ3XSBDUjA6IDgwMDUwMDNiIENSMjogMGRhMDAwMDAgQ1IzOiAxMWUy
OTAwMCBDUjQ6IDAwMDAwNjkwClsgICAxMC41MzAyNDddIFN0YWNrOgpbICAgMTAuNTMwMjQ3
XSBTdGFjazoKWyAgIDEwLjUzMDI0N10gIDg4NjM3MDg2ClsgICAxMC41MzAyNDddICA4ODYz
NzA4NiA4YjRhZGY5MCA4YjRhZGY5MCA4ODVmMmMxMiA4ODVmMmMxMiA4YmZmNzk3NSA4YmZm
Nzk3NSA4YjRhZGY0YyA4YjRhZGY0YyA4NmEzYWYwMCA4NmEzYWYwMCA4N2NjMmFiMCA4N2Nj
MmFiMCA4YmZmNzk2NCA4YmZmNzk2NAoKWyAgIDEwLjUzMDI0N10gIDhiNGFkZjgwClsgICAx
MC41MzAyNDddICA4YjRhZGY4MCA4NmEzYjEyMyA4NmEzYjEyMyAwMDAwMDFiNyAwMDAwMDFi
NyAwMDAwMDAwNiAwMDAwMDAwNiAwMDAwMDAwNiAwMDAwMDAwNiA4ODQyYjRiNCA4ODQyYjRi
NCA4YmZmNzk3NiA4YmZmNzk3NiA4ODQyZDAzNCA4ODQyZDAzNAoKWyAgIDEwLjUzMDI0N10g
IDAwMDAwMjAwClsgICAxMC41MzAyNDddICAwMDAwMDIwMCA4ODMwNDMwYyA4ODMwNDMwYyAw
MDAwMDAwNiAwMDAwMDAwNiAwMDAwMDlkMCAwMDAwMDlkMCA4ODY5NDkyOCA4ODY5NDkyOCBi
YTM2ZTBhYyBiYTM2ZTBhYyAwMDAwMDAwNiAwMDAwMDAwNiAwMDAwMDlkMCAwMDAwMDlkMAoK
WyAgIDEwLjUzMDI0N10gQ2FsbCBUcmFjZToKWyAgIDEwLjUzMDI0N10gQ2FsbCBUcmFjZToK
WyAgIDEwLjUzMDI0N10gIFs8ODg2MzcwODY+XSA/IHR0dXNiMl9kcml2ZXJfaW5pdCsweDE2
LzB4MTYKWyAgIDEwLjUzMDI0N10gIFs8ODg2MzcwODY+XSA/IHR0dXNiMl9kcml2ZXJfaW5p
dCsweDE2LzB4MTYKWyAgIDEwLjUzMDI0N10gIFs8ODg1ZjJjMTI+XSBkb19vbmVfaW5pdGNh
bGwrMHgxNjAvMHgxNmYKWyAgIDEwLjUzMDI0N10gIFs8ODg1ZjJjMTI+XSBkb19vbmVfaW5p
dGNhbGwrMHgxNjAvMHgxNmYKWyAgIDEwLjUzMDI0N10gIFs8ODZhM2FmMDA+XSA/IHBhcmFt
X2FycmF5X3NldCsweDFkLzB4YzcKWyAgIDEwLjUzMDI0N10gIFs8ODZhM2FmMDA+XSA/IHBh
cmFtX2FycmF5X3NldCsweDFkLzB4YzcKWyAgIDEwLjUzMDI0N10gIFs8ODZhM2IxMjM+XSA/
IHBhcnNlX2FyZ3MrMHgxMjQvMHgyNjgKWyAgIDEwLjUzMDI0N10gIFs8ODZhM2IxMjM+XSA/
IHBhcnNlX2FyZ3MrMHgxMjQvMHgyNjgKWyAgIDEwLjUzMDI0N10gIFs8ODg1ZjJkMGI+XSBr
ZXJuZWxfaW5pdF9mcmVlYWJsZSsweGVhLzB4MTY3ClsgICAxMC41MzAyNDddICBbPDg4NWYy
ZDBiPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhlYS8weDE2NwpbICAgMTAuNTMwMjQ3XSAg
Wzw4N2IyZjc1OD5dIGtlcm5lbF9pbml0KzB4OC8weGI4ClsgICAxMC41MzAyNDddICBbPDg3
YjJmNzU4Pl0ga2VybmVsX2luaXQrMHg4LzB4YjgKWyAgIDEwLjUzMDI0N10gIFs8ODdiNTY1
MDA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgMTAuNTMwMjQ3XSAg
Wzw4N2I1NjUwMD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsgICAxMC41
MzAyNDddICBbPDg3YjJmNzUwPl0gPyByZXN0X2luaXQrMHgxMGMvMHgxMGMKWyAgIDEwLjUz
MDI0N10gIFs8ODdiMmY3NTA+XSA/IHJlc3RfaW5pdCsweDEwYy8weDEwYwpbICAgMTAuNTMw
MjQ3XSBDb2RlOgpbICAgMTAuNTMwMjQ3XSBDb2RlOiAwOCAwOCBjMiBjMiBjNyBjNyAwNSAw
NSBhNCBhNCAxOSAxOSBlYSBlYSA4OCA4OCAwMCAwMCAwMCAwMCBhMCBhMCAwZCAwZCBjNyBj
NyAwNSAwNSBhMCBhMCAxOSAxOSBlYSBlYSA4OCA4OCAwMCAwMCAwMCAwMCBhMCBhMCAwZCAw
ZCBjNyBjNyAwNSAwNSA5YyA5YyAxOSAxOSBlYSBlYSA4OCA4OCAwMCAwMCAwMCAwMCBhMCBh
MCAwZCAwZCA3NSA3NSAxZiAxZiBiOCBiOCAwMCAwMCAwMCAwMCBhMCBhMCAwZCAwZCA4NSA4
NSBjMCBjMCA3NCA3NCAxNiAxNiA8YTE+IDxhMT4gMDAgMDAgMDAgMDAgYTAgYTAgMGQgMGQg
YzcgYzcgMDUgMDUgMTQgMTQgMmEgMmEgNTQgNTQgODggODggMDAgMDAgMDAgMDAgYTAgYTAg
MGQgMGQgYTMgYTMgMTggMTggMmEgMmEgNTQgNTQgODggODggZWIgZWIKClsgICAxMC41MzAy
NDddIEVJUDogWzw4ODYzNzBmMT5dIApbICAgMTAuNTMwMjQ3XSBFSVA6IFs8ODg2MzcwZjE+
XSBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZGFmOTAwNV91c2JfbW9kdWxlX2lu
aXQrMHg2Yi8weDlkIFNTOkVTUCAwMDY4OjhiNGFkZjJjCiBTUzpFU1AgMDA2ODo4YjRhZGYy
YwpbICAgMTAuNTMwMjQ3XSBDUjI6IDAwMDAwMDAwMGRhMDAwMDAKWyAgIDEwLjUzMDI0N10g
Q1IyOiAwMDAwMDAwMDBkYTAwMDAwClsgICAxMC41MzAyNDddIC0tLVsgZW5kIHRyYWNlIDg3
MmIxZGQ3NTY3YjVkYTcgXS0tLQpbICAgMTAuNTMwMjQ3XSAtLS1bIGVuZCB0cmFjZSA4NzJi
MWRkNzU2N2I1ZGE3IF0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQz
LzUxNzBhM2IyNGE5MTQxZTIzNDlhMzQyMDQ0ODc0M2I3YzY4ZjIyMjMvZG1lc2cteW9jdG8t
dnAtMTA6MjAxNDA5MTcyMjU3NTM6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0MzozLjE2
LjAtcmMzLTAwMDkxLWc1MTcwYTNiOjEKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKG1sxOzM1bTIwMTQtMDktMTcgMjI6NTg6MTQgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9i
b290LWJpc2VjdC9saW51eC0xL29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzog
MTI4MzkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDE0IHN0
ZXBzKQpbMWFkOTZiYjBhMjBmYTI2Yjk1MmIyMjUwZTg5ZDE0YjYzOTdiZjYxOF0gTWVyZ2Ug
dGFnICdncGlvLXYzLjE2LTInIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9saW51c3cvbGludXgtZ3BpbwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMS9v
YmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctaWIxLTA5MTcyMDQzL25leHQ6bWFzdGVyOjFhZDk2YmIwYTIwZmEyNmI5NTJiMjI1
MGU4OWQxNGI2Mzk3YmY2MTg6YmlzZWN0LWxpbnV4LTEKCjIwMTQtMDktMTcgMjI6NTg6MTYg
MWFkOTZiYjBhMjBmYTI2Yjk1MmIyMjUwZTg5ZDE0YjYzOTdiZjYxOCBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy9p
Mzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTFhZDk2YmIwYTIwZmEyNmI5NTJiMjI1MGU4
OWQxNGI2Mzk3YmY2MTgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDkxNzIwNDMvMWFkOTZiYjBhMjBmYTI2Yjk1MmIyMjUwZTg5ZDE0YjYzOTdi
ZjYxOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My0xYWQ5NmJiMGEyMGZh
MjZiOTUyYjIyNTBlODlkMTRiNjM5N2JmNjE4ChtbMTszNW0yMDE0LTA5LTE3IDIzOjAyOjE2
IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtMWFkOTZiYjBhMjBmYTI2Yjk1MmIyMjUwZTg5ZDE0
YjYzOTdiZjYxOBtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzLXNtb2tlL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDkxNzIwNDMtMWFkOTZiYjBhMjBmYTI2Yjk1MmIyMjUwZTg5ZDE0YjYzOTdi
ZjYxOAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8xYWQ5
NmJiMGEyMGZhMjZiOTUyYjIyNTBlODlkMTRiNjM5N2JmNjE4L3ZtbGludXotMy4xNS4wLTEx
OTU2LWcxYWQ5NmJiCgoyMDE0LTA5LTE3IDIzOjA0OjE2IGRldGVjdGluZyBib290IHN0YXRl
IC4gVEVTVCBGQUlMVVJFClsgICAxMC41MTY4MjBdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3
IGludGVyZmFjZSBkcml2ZXIgZHZiX3VzYl90dHVzYjIKWyAgIDEwLjUxNzgzM10gdXNiY29y
ZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBkdmJfdXNiX2FmOTAwNQpbICAg
MTAuNTE3ODMzXSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGR2
Yl91c2JfYWY5MDA1ClsgICAxMC41MTg4MDFdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJu
ZWwgClsgICAxMC41MTg4MDFdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5n
IHJlcXVlc3RwYWdpbmcgcmVxdWVzdCBhdCAwOTQwMDAwMAogYXQgMDk0MDAwMDAKWyAgIDEw
LjUxOTgwOF0gSVA6ClsgICAxMC41MTk4MDhdIElQOiBbPDg0MDM1MmI2Pl0gYWY5MDA1X3Vz
Yl9tb2R1bGVfaW5pdCsweDZiLzB4OWQKIFs8ODQwMzUyYjY+XSBhZjkwMDVfdXNiX21vZHVs
ZV9pbml0KzB4NmIvMHg5ZApbICAgMTAuNTIwNTUwXSAqcGRlID0gMDAwMDAwMDAgClsgICAx
MC41MjA1NTBdICpwZGUgPSAwMDAwMDAwMCAKClsgICAxMC41MjA1NTBdIE9vcHM6IDAwMDAg
WyMxXSAKWyAgIDEwLjUyMDU1MF0gT29wczogMDAwMCBbIzFdIFBSRUVNUFQgUFJFRU1QVCBE
RUJVR19QQUdFQUxMT0NERUJVR19QQUdFQUxMT0MKClsgICAxMC41MjA1NTBdIENQVTogMCBQ
SUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE1LjAtMTE5NTYtZzFhZDk2YmIg
IzEKWyAgIDEwLjUyMDU1MF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWlu
dGVkIDMuMTUuMC0xMTk1Ni1nMWFkOTZiYiAjMQpbICAgMTAuNTIwNTUwXSBIYXJkd2FyZSBu
YW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAxMC41MjA1NTBd
IEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAg
IDEwLjUyMDU1MF0gdGFzazogOGI0YTg2NjAgdGk6IDhiNGFjMDAwIHRhc2sudGk6IDhiNGFj
MDAwClsgICAxMC41MjA1NTBdIHRhc2s6IDhiNGE4NjYwIHRpOiA4YjRhYzAwMCB0YXNrLnRp
OiA4YjRhYzAwMApbICAgMTAuNTIwNTUwXSBFSVA6IDAwNjA6Wzw4NDAzNTJiNj5dIEVGTEFH
UzogMDAwMTAyMDYgQ1BVOiAwClsgICAxMC41MjA1NTBdIEVJUDogMDA2MDpbPDg0MDM1MmI2
Pl0gRUZMQUdTOiAwMDAxMDIwNiBDUFU6IDAKWyAgIDEwLjUyMDU1MF0gRUlQIGlzIGF0IGFm
OTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkClsgICAxMC41MjA1NTBdIEVJUCBpcyBh
dCBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZApbICAgMTAuNTIwNTUwXSBFQVg6
IDA5NDAwMDAwIEVCWDogMDAwMDAwMDAgRUNYOiAwMDAwMDAwNiBFRFg6IDAwMDAwMDAwClsg
ICAxMC41MjA1NTBdIEVBWDogMDk0MDAwMDAgRUJYOiAwMDAwMDAwMCBFQ1g6IDAwMDAwMDA2
IEVEWDogMDAwMDAwMDAKWyAgIDEwLjUyMDU1MF0gRVNJOiA4ODJmODFhMCBFREk6IDAwMDAw
MDAwIEVCUDogOGI0YWRmMzAgRVNQOiA4YjRhZGYyYwpbICAgMTAuNTIwNTUwXSBFU0k6IDg4
MmY4MWEwIEVESTogMDAwMDAwMDAgRUJQOiA4YjRhZGYzMCBFU1A6IDhiNGFkZjJjClsgICAx
MC41MjA1NTBdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDBlMCBTUzogMDA2
OApbICAgMTAuNTIwNTUwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAg
U1M6IDAwNjgKWyAgIDEwLjUyMDU1MF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDA5NDAwMDAwIENS
MzogMTFjYjEwMDAgQ1I0OiAwMDAwMDY5MApbICAgMTAuNTIwNTUwXSBDUjA6IDgwMDUwMDNi
IENSMjogMDk0MDAwMDAgQ1IzOiAxMWNiMTAwMCBDUjQ6IDAwMDAwNjkwClsgICAxMC41MjA1
NTBdIFN0YWNrOgpbICAgMTAuNTIwNTUwXSBTdGFjazoKWyAgIDEwLjUyMDU1MF0gIDg0MDM1
MjRiClsgICAxMC41MjA1NTBdICA4NDAzNTI0YiA4YjRhZGY5MCA4YjRhZGY5MCA4M2ZmMGMx
MiA4M2ZmMGMxMiA4YmZmNjk3MSA4YmZmNjk3MSA4YjRhZGY0YyA4YjRhZGY0YyA4MjQzYWYw
MCA4MjQzYWYwMCA4MzZjMWEzMCA4MzZjMWEzMCA4YmZmNjk2MCA4YmZmNjk2MAoKWyAgIDEw
LjUyMDU1MF0gIDhiNGFkZjgwClsgICAxMC41MjA1NTBdICA4YjRhZGY4MCA4MjQzYjBkMyA4
MjQzYjBkMyAwMDAwMDFiNCAwMDAwMDFiNCAwMDAwMDAwNiAwMDAwMDAwNiAwMDAwMDAwNiAw
MDAwMDAwNiA4M2UyOWRlYyA4M2UyOWRlYyA4YmZmNjk3MiA4YmZmNjk3MiA4M2UyYjkzYyA4
M2UyYjkzYwoKWyAgIDEwLjUyMDU1MF0gIDAwMDAwMjAwClsgICAxMC41MjA1NTBdICAwMDAw
MDIwMCA4M2QwMmNjYiA4M2QwMmNjYiAwMDAwMDAwNiAwMDAwMDAwNiAwMDAwMDljZCAwMDAw
MDljZCA4NDA5Mjg4OCA4NDA5Mjg4OCA5YmI0NGU0ZSA5YmI0NGU0ZSAwMDAwMDAwNiAwMDAw
MDAwNiAwMDAwMDljZCAwMDAwMDljZAoKWyAgIDEwLjUyMDU1MF0gQ2FsbCBUcmFjZToKWyAg
IDEwLjUyMDU1MF0gQ2FsbCBUcmFjZToKWyAgIDEwLjUyMDU1MF0gIFs8ODQwMzUyNGI+XSA/
IHR0dXNiMl9kcml2ZXJfaW5pdCsweDE2LzB4MTYKWyAgIDEwLjUyMDU1MF0gIFs8ODQwMzUy
NGI+XSA/IHR0dXNiMl9kcml2ZXJfaW5pdCsweDE2LzB4MTYKWyAgIDEwLjUyMDU1MF0gIFs8
ODNmZjBjMTI+XSBkb19vbmVfaW5pdGNhbGwrMHgxNjAvMHgxNmYKWyAgIDEwLjUyMDU1MF0g
IFs8ODNmZjBjMTI+XSBkb19vbmVfaW5pdGNhbGwrMHgxNjAvMHgxNmYKWyAgIDEwLjUyMDU1
MF0gIFs8ODI0M2FmMDA+XSA/IHBhcmFtX2FycmF5X3NldCsweDZkLzB4YzcKWyAgIDEwLjUy
MDU1MF0gIFs8ODI0M2FmMDA+XSA/IHBhcmFtX2FycmF5X3NldCsweDZkLzB4YzcKWyAgIDEw
LjUyMDU1MF0gIFs8ODI0M2IwZDM+XSA/IHBhcnNlX2FyZ3MrMHgxMjQvMHgyNjgKWyAgIDEw
LjUyMDU1MF0gIFs8ODI0M2IwZDM+XSA/IHBhcnNlX2FyZ3MrMHgxMjQvMHgyNjgKWyAgIDEw
LjUyMDU1MF0gIFs8ODNmZjBkMGI+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGVhLzB4MTY3
ClsgICAxMC41MjA1NTBdICBbPDgzZmYwZDBiPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhl
YS8weDE2NwpbICAgMTAuNTIwNTUwXSAgWzw4MzUyZTE4MD5dIGtlcm5lbF9pbml0KzB4OC8w
eGI4ClsgICAxMC41MjA1NTBdICBbPDgzNTJlMTgwPl0ga2VybmVsX2luaXQrMHg4LzB4YjgK
WyAgIDEwLjUyMDU1MF0gIFs8ODM1NTRlZTA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4
MjAvMHgzMApbICAgMTAuNTIwNTUwXSAgWzw4MzU1NGVlMD5dIHJldF9mcm9tX2tlcm5lbF90
aHJlYWQrMHgyMC8weDMwClsgICAxMC41MjA1NTBdICBbPDgzNTJlMTc4Pl0gPyByZXN0X2lu
aXQrMHgxMGMvMHgxMGMKWyAgIDEwLjUyMDU1MF0gIFs8ODM1MmUxNzg+XSA/IHJlc3RfaW5p
dCsweDEwYy8weDEwYwpbICAgMTAuNTIwNTUwXSBDb2RlOgpbICAgMTAuNTIwNTUwXSBDb2Rl
OiAwOCAwOCBjMiBjMiBjNyBjNyAwNSAwNSA4NCA4NCBmOSBmOSA4OSA4OSA4NCA4NCAwMCAw
MCAwMCAwMCA0MCA0MCAwOSAwOSBjNyBjNyAwNSAwNSA4MCA4MCBmOSBmOSA4OSA4OSA4NCA4
NCAwMCAwMCAwMCAwMCA0MCA0MCAwOSAwOSBjNyBjNyAwNSAwNSA3YyA3YyBmOSBmOSA4OSA4
OSA4NCA4NCAwMCAwMCAwMCAwMCA0MCA0MCAwOSAwOSA3NSA3NSAxZiAxZiBiOCBiOCAwMCAw
MCAwMCAwMCA0MCA0MCAwOSAwOSA4NSA4NSBjMCBjMCA3NCA3NCAxNiAxNiA8YTE+IDxhMT4g
MDAgMDAgMDAgMDAgNDAgNDAgMDkgMDkgYzcgYzcgMDUgMDUgYjQgYjQgMDMgMDMgZjQgZjQg
ODMgODMgMDAgMDAgMDAgMDAgNDAgNDAgMDkgMDkgYTMgYTMgYjggYjggMDMgMDMgZjQgZjQg
ODMgODMgZWIgZWIKClsgICAxMC41MjA1NTBdIEVJUDogWzw4NDAzNTJiNj5dIApbICAgMTAu
NTIwNTUwXSBFSVA6IFs8ODQwMzUyYjY+XSBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIv
MHg5ZGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkIFNTOkVTUCAwMDY4OjhiNGFk
ZjJjCiBTUzpFU1AgMDA2ODo4YjRhZGYyYwpbICAgMTAuNTIwNTUwXSBDUjI6IDAwMDAwMDAw
MDk0MDAwMDAKWyAgIDEwLjUyMDU1MF0gQ1IyOiAwMDAwMDAwMDA5NDAwMDAwClsgICAxMC41
MjA1NTBdIC0tLVsgZW5kIHRyYWNlIDJhNmFhYTVmYzQ4YWUxNTEgXS0tLQpbICAgMTAuNTIw
NTUwXSAtLS1bIGVuZCB0cmFjZSAyYTZhYWE1ZmM0OGFlMTUxIF0tLS0KL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzFhZDk2YmIwYTIwZmEyNmI5NTJiMjI1MGU4OWQx
NGI2Mzk3YmY2MTgvZG1lc2cteW9jdG8tdnAtMTE6MjAxNDA5MTcyMzA0Mzk6aTM4Ni1yYW5k
Y29uZmlnLWliMS0wOTE3MjA0MzozLjE1LjAtMTE5NTYtZzFhZDk2YmI6MQowOjE6MSBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOS0xNyAyMzowNDo0OCBSRVBF
QVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTEvb2JqLWJpc2VjdC8ucmVw
ZWF0G1swbQoKQmlzZWN0aW5nOiAxMTk1NiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpCls0MTJkZDNhNmRhZjBjYWRjZTFiMmQ2YTM0ZmEz
NzEzZjQwMjU1NTc5XSBNZXJnZSB0YWcgJ3hmcy1mb3ItbGludXMtMy4xNi1yYzEnIG9mIGdp
dDovL29zcy5zZ2kuY29tL3hmcy94ZnMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTEvb2JqLWJpc2Vj
dApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0My9uZXh0Om1hc3Rlcjo0MTJkZDNhNmRhZjBjYWRjZTFiMmQ2YTM0ZmEzNzEz
ZjQwMjU1NTc5OmJpc2VjdC1saW51eC0xCgoyMDE0LTA5LTE3IDIzOjA0OjUwIDQxMmRkM2E2
ZGFmMGNhZGNlMWIyZDZhMzRmYTM3MTNmNDAyNTU1NzkgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wOTE3MjA0My00MTJkZDNhNmRhZjBjYWRjZTFiMmQ2YTM0ZmEzNzEzZjQw
MjU1NTc5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIx
LTA5MTcyMDQzLzQxMmRkM2E2ZGFmMGNhZGNlMWIyZDZhMzRmYTM3MTNmNDAyNTU1NzkKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1p
YjAzL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtNDEyZGQzYTZkYWYwY2FkY2UxYjJk
NmEzNGZhMzcxM2Y0MDI1NTU3OQobWzE7MzVtMjAxNC0wOS0xNyAyMzowNjo1MCBObyBidWls
ZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25m
aWctaWIxLTA5MTcyMDQzLTQxMmRkM2E2ZGFmMGNhZGNlMWIyZDZhMzRmYTM3MTNmNDAyNTU1
NzkbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy1zbW9rZS9pMzg2LXJhbmRjb25maWctaWIx
LTA5MTcyMDQzLTQxMmRkM2E2ZGFmMGNhZGNlMWIyZDZhMzRmYTM3MTNmNDAyNTU1NzkKa2Vy
bmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNDEyZGQzYTZkYWYw
Y2FkY2UxYjJkNmEzNGZhMzcxM2Y0MDI1NTU3OS92bWxpbnV6LTMuMTUuMC0wODc1NC1nNDEy
ZGQzYQoKMjAxNC0wOS0xNyAyMzowODo1MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4u
Li4uLi4uLi4uIFRFU1QgRkFJTFVSRQpbICAgMTQuMTI1MTY4XSB1c2Jjb3JlOiByZWdpc3Rl
cmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91c2JfdHR1c2IyClsgICAxNC4xMjY2MDdd
IHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgZHZiX3VzYl9hZjkw
MDUKWyAgIDE0LjEyNjYwN10gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRy
aXZlciBkdmJfdXNiX2FmOTAwNQpbICAgMTQuMTQ4MTM5XSBCVUc6IHVuYWJsZSB0byBoYW5k
bGUga2VybmVsIApbICAgMTQuMTQ4MTM5XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVs
IHBhZ2luZyByZXF1ZXN0cGFnaW5nIHJlcXVlc3QgYXQgMDgyMDAwMDAKIGF0IDA4MjAwMDAw
ClsgICAxNC4xNDk4NzhdIElQOgpbICAgMTQuMTQ5ODc4XSBJUDogWzw4MmUxYzFlOD5dIGFm
OTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkCiBbPDgyZTFjMWU4Pl0gYWY5MDA1X3Vz
Yl9tb2R1bGVfaW5pdCsweDZiLzB4OWQKWyAgIDE0LjE1MTQ1Ml0gKnBkZSA9IDAwMDAwMDAw
IApbICAgMTQuMTUxNDUyXSAqcGRlID0gMDAwMDAwMDAgCgpbICAgMTQuMTUyMjg0XSBPb3Bz
OiAwMDAwIFsjMV0gClsgICAxNC4xNTIyODRdIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIFBS
RUVNUFQgREVCVUdfUEFHRUFMTE9DREVCVUdfUEFHRUFMTE9DCgpbICAgMTQuMTUzNTgwXSBD
UFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNS4wLTA4NzU0LWc0
MTJkZDNhICMyClsgICAxNC4xNTM1ODBdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBO
b3QgdGFpbnRlZCAzLjE1LjAtMDg3NTQtZzQxMmRkM2EgIzIKWyAgIDE0LjE1NTM3OV0gSGFy
ZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMTQu
MTU1Mzc5XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8y
MDExClsgICAxNC4xNTY4MTFdIHRhc2s6IDg5Y2E3NjYwIHRpOiA4OWNhYTAwMCB0YXNrLnRp
OiA4OWNhYTAwMApbICAgMTQuMTU2ODExXSB0YXNrOiA4OWNhNzY2MCB0aTogODljYWEwMDAg
dGFzay50aTogODljYWEwMDAKWyAgIDE0LjE1ODA5NV0gRUlQOiAwMDYwOls8ODJlMWMxZTg+
XSBFRkxBR1M6IDAwMDEwMjA2IENQVTogMApbICAgMTQuMTU4MDk1XSBFSVA6IDAwNjA6Wzw4
MmUxYzFlOD5dIEVGTEFHUzogMDAwMTAyMDYgQ1BVOiAwClsgICAxNC4xNTgwOTVdIEVJUCBp
cyBhdCBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZApbICAgMTQuMTU4MDk1XSBF
SVAgaXMgYXQgYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQKWyAgIDE0LjE1ODA5
NV0gRUFYOiAwODIwMDAwMCBFQlg6IDAwMDAwMDAwIEVDWDogMDAwMDAwMDYgRURYOiAwMDAw
MDAwMApbICAgMTQuMTU4MDk1XSBFQVg6IDA4MjAwMDAwIEVCWDogMDAwMDAwMDAgRUNYOiAw
MDAwMDAwNiBFRFg6IDAwMDAwMDAwClsgICAxNC4xNTgwOTVdIEVTSTogN2Q3ZTI2NDAgRURJ
OiAwMDAwMDAwMCBFQlA6IDg5Y2FiZjMwIEVTUDogODljYWJmMmMKWyAgIDE0LjE1ODA5NV0g
RVNJOiA3ZDdlMjY0MCBFREk6IDAwMDAwMDAwIEVCUDogODljYWJmMzAgRVNQOiA4OWNhYmYy
YwpbICAgMTQuMTU4MDk1XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAg
U1M6IDAwNjgKWyAgIDE0LjE1ODA5NV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdT
OiAwMGUwIFNTOiAwMDY4ClsgICAxNC4xNTgwOTVdIENSMDogODAwNTAwMzMgQ1IyOiAwODIw
MDAwMCBDUjM6IDBhZTlhMDAwIENSNDogMDAwNDA2OTAKWyAgIDE0LjE1ODA5NV0gQ1IwOiA4
MDA1MDAzMyBDUjI6IDA4MjAwMDAwIENSMzogMGFlOWEwMDAgQ1I0OiAwMDA0MDY5MApbICAg
MTQuMTU4MDk1XSBTdGFjazoKWyAgIDE0LjE1ODA5NV0gU3RhY2s6ClsgICAxNC4xNTgwOTVd
ICA4MmUxYzE3ZApbICAgMTQuMTU4MDk1XSAgODJlMWMxN2QgODljYWJmOTAgODljYWJmOTAg
ODJkZDdiYTkgODJkZDdiYTkgODJjMTJmNDggODJjMTJmNDggODljYWJmNGMgODljYWJmNGMg
ODEyM2IxMDAgODEyM2IxMDAgODI0YWU0NzAgODI0YWU0NzAgOGJmZjY5NjQgOGJmZjY5NjQK
ClsgICAxNC4xNTgwOTVdICA4OWNhYmY4MApbICAgMTQuMTU4MDk1XSAgODljYWJmODAgODEy
M2IyZWUgODEyM2IyZWUgMDAwMDAxYjEgMDAwMDAxYjEgMDAwMDAwMDYgMDAwMDAwMDYgMDAw
MDAwMDYgMDAwMDAwMDYgODJjMTE0MzggODJjMTE0MzggOGJmZjY5NzYgOGJmZjY5NzYgMDAw
MDAyMDAgMDAwMDAyMDAKClsgICAxNC4xNTgwOTVdICA4MmFlYWMzOQpbICAgMTQuMTU4MDk1
XSAgODJhZWFjMzkgOGJmZjY5NzUgOGJmZjY5NzUgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDA5
YzkgMDAwMDA5YzkgODJlNzk2NjggODJlNzk2NjggNjM3NjcwYmEgNjM3NjcwYmEgMDAwMDAw
MDYgMDAwMDAwMDYgMDAwMDA5YzkgMDAwMDA5YzkKClsgICAxNC4xNTgwOTVdIENhbGwgVHJh
Y2U6ClsgICAxNC4xNTgwOTVdIENhbGwgVHJhY2U6ClsgICAxNC4xNTgwOTVdICBbPDgyZTFj
MTdkPl0gPyB0dHVzYjJfZHJpdmVyX2luaXQrMHgxNi8weDE2ClsgICAxNC4xNTgwOTVdICBb
PDgyZTFjMTdkPl0gPyB0dHVzYjJfZHJpdmVyX2luaXQrMHgxNi8weDE2ClsgICAxNC4xNTgw
OTVdICBbPDgyZGQ3YmE5Pl0gZG9fb25lX2luaXRjYWxsKzB4MTYwLzB4MTZmClsgICAxNC4x
NTgwOTVdICBbPDgyZGQ3YmE5Pl0gZG9fb25lX2luaXRjYWxsKzB4MTYwLzB4MTZmClsgICAx
NC4xNTgwOTVdICBbPDgxMjNiMTAwPl0gPyBwYXJhbV9hcnJheV9zZXQrMHg0MS8weGM3Clsg
ICAxNC4xNTgwOTVdICBbPDgxMjNiMTAwPl0gPyBwYXJhbV9hcnJheV9zZXQrMHg0MS8weGM3
ClsgICAxNC4xNTgwOTVdICBbPDgxMjNiMmVlPl0gPyBwYXJzZV9hcmdzKzB4MTEzLzB4MjVj
ClsgICAxNC4xNTgwOTVdICBbPDgxMjNiMmVlPl0gPyBwYXJzZV9hcmdzKzB4MTEzLzB4MjVj
ClsgICAxNC4xNTgwOTVdICBbPDgyZGQ3Y2EyPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhl
YS8weDE2NwpbICAgMTQuMTU4MDk1XSAgWzw4MmRkN2NhMj5dIGtlcm5lbF9pbml0X2ZyZWVh
YmxlKzB4ZWEvMHgxNjcKWyAgIDE0LjE1ODA5NV0gIFs8ODIzMjAzZjg+XSBrZXJuZWxfaW5p
dCsweDgvMHhiOApbICAgMTQuMTU4MDk1XSAgWzw4MjMyMDNmOD5dIGtlcm5lbF9pbml0KzB4
OC8weGI4ClsgICAxNC4xNTgwOTVdICBbPDgyMzQ3NDQwPl0gcmV0X2Zyb21fa2VybmVsX3Ro
cmVhZCsweDIwLzB4MzAKWyAgIDE0LjE1ODA5NV0gIFs8ODIzNDc0NDA+XSByZXRfZnJvbV9r
ZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgMTQuMTU4MDk1XSAgWzw4MjMyMDNmMD5dID8g
cmVzdF9pbml0KzB4MTBjLzB4MTBjClsgICAxNC4xNTgwOTVdICBbPDgyMzIwM2YwPl0gPyBy
ZXN0X2luaXQrMHgxMGMvMHgxMGMKWyAgIDE0LjE1ODA5NV0gQ29kZToKWyAgIDE0LjE1ODA5
NV0gQ29kZTogMDggMDggYzIgYzIgYzcgYzcgMDUgMDUgNjQgNjQgNTkgNTkgNjggNjggODMg
ODMgMDAgMDAgMDAgMDAgMjAgMjAgMDggMDggYzcgYzcgMDUgMDUgNjAgNjAgNTkgNTkgNjgg
NjggODMgODMgMDAgMDAgMDAgMDAgMjAgMjAgMDggMDggYzcgYzcgMDUgMDUgNWMgNWMgNTkg
NTkgNjggNjggODMgODMgMDAgMDAgMDAgMDAgMjAgMjAgMDggMDggNzUgNzUgMWYgMWYgYjgg
YjggMDAgMDAgMDAgMDAgMjAgMjAgMDggMDggODUgODUgYzAgYzAgNzQgNzQgMTYgMTYgPGEx
PiA8YTE+IDAwIDAwIDAwIDAwIDIwIDIwIDA4IDA4IGM3IGM3IDA1IDA1IDM0IDM0IDc0IDc0
IGQyIGQyIDgyIDgyIDAwIDAwIDAwIDAwIDIwIDIwIDA4IDA4IGEzIGEzIDM4IDM4IDc0IDc0
IGQyIGQyIDgyIDgyIGViIGViCgpbICAgMTQuMTU4MDk1XSBFSVA6IFs8ODJlMWMxZTg+XSAK
WyAgIDE0LjE1ODA5NV0gRUlQOiBbPDgyZTFjMWU4Pl0gYWY5MDA1X3VzYl9tb2R1bGVfaW5p
dCsweDZiLzB4OWRhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZCBTUzpFU1AgMDA2
ODo4OWNhYmYyYwogU1M6RVNQIDAwNjg6ODljYWJmMmMKWyAgIDE0LjE1ODA5NV0gQ1IyOiAw
MDAwMDAwMDA4MjAwMDAwClsgICAxNC4xNTgwOTVdIENSMjogMDAwMDAwMDAwODIwMDAwMApb
ICAgMTQuMTU4MDk1XSAtLS1bIGVuZCB0cmFjZSA1NGIyMTJiZDFkMzAxNTRlIF0tLS0KWyAg
IDE0LjE1ODA5NV0gLS0tWyBlbmQgdHJhY2UgNTRiMjEyYmQxZDMwMTU0ZSBdLS0tCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My80MTJkZDNhNmRhZjBjYWRjZTFiMmQ2
YTM0ZmEzNzEzZjQwMjU1NTc5L2RtZXNnLXF1YW50YWwta2J1aWxkLTIzOjIwMTQwOTE3MjMx
MzUyOmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6My4xNS4wLTA4NzU0LWc0MTJkZDNh
OjIKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDktMTcg
MjM6MTY6NTEgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eC0xL29i
ai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogODc1NCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpCltiMWNjZTgwMzJmNmFiZTkw
MGIwNzhkMjRmM2MzOTM4NzI2NTI4Zjk3XSBNZXJnZSBicmFuY2ggJ2Zvci1uZXh0JyBvZiBn
aXQ6Ly9naXQuc2FtYmEub3JnL3NmcmVuY2gvY2lmcy0yLjYKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
LTEvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0My9uZXh0Om1hc3RlcjpiMWNjZTgwMzJmNmFiZTkwMGIw
NzhkMjRmM2MzOTM4NzI2NTI4Zjk3OmJpc2VjdC1saW51eC0xCgoyMDE0LTA5LTE3IDIzOjE2
OjUyIGIxY2NlODAzMmY2YWJlOTAwYjA3OGQyNGYzYzM5Mzg3MjY1MjhmOTcgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWli
MDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My1iMWNjZTgwMzJmNmFiZTkwMGIwNzhk
MjRmM2MzOTM4NzI2NTI4Zjk3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaWIxLTA5MTcyMDQzL2IxY2NlODAzMmY2YWJlOTAwYjA3OGQyNGYzYzM5Mzg3
MjY1MjhmOTcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2xrcC1pYjAzL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtYjFjY2U4MDMy
ZjZhYmU5MDBiMDc4ZDI0ZjNjMzkzODcyNjUyOGY5NwobWzE7MzVtMjAxNC0wOS0xNyAyMzox
OTo1MyBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC9p
Mzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLWIxY2NlODAzMmY2YWJlOTAwYjA3OGQyNGYz
YzM5Mzg3MjY1MjhmOTcbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy1zbW9rZS9pMzg2LXJh
bmRjb25maWctaWIxLTA5MTcyMDQzLWIxY2NlODAzMmY2YWJlOTAwYjA3OGQyNGYzYzM5Mzg3
MjY1MjhmOTcKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMv
YjFjY2U4MDMyZjZhYmU5MDBiMDc4ZDI0ZjNjMzkzODcyNjUyOGY5Ny92bWxpbnV6LTMuMTUu
MC0wNzg2MC1nYjFjY2U4MAoKMjAxNC0wOS0xNyAyMzoyMjo1MyBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDYuNjk0OTY3XSB1c2Jjb3JlOiByZWdpc3RlcmVk
IG5ldyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91c2JfdHR1c2IyClsgICAgNi42OTYwMTZdIHVz
YmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgZHZiX3VzYl9hZjkwMDUK
WyAgICA2LjY5NjAxNl0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZl
ciBkdmJfdXNiX2FmOTAwNQpbICAgIDYuNjk3MDc5XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUg
a2VybmVsIApbICAgIDYuNjk3MDc5XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBh
Z2luZyByZXF1ZXN0cGFnaW5nIHJlcXVlc3QgYXQgMGE0MDAwMDAKIGF0IDBhNDAwMDAwClsg
ICAgNi42OTgzMDRdIElQOgpbICAgIDYuNjk4MzA0XSBJUDogWzw4NTAxNzA0Mj5dIGFmOTAw
NV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkCiBbPDg1MDE3MDQyPl0gYWY5MDA1X3VzYl9t
b2R1bGVfaW5pdCsweDZiLzB4OWQKWyAgICA2LjY5OTQ4Ml0gKnBkZSA9IDAwMDAwMDAwIApb
ICAgIDYuNjk5NDgyXSAqcGRlID0gMDAwMDAwMDAgCgpbICAgIDYuNzAwMTA5XSBPb3BzOiAw
MDAwIFsjMV0gClsgICAgNi43MDAxMDldIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIFBSRUVN
UFQgREVCVUdfUEFHRUFMTE9DREVCVUdfUEFHRUFMTE9DCgpbICAgIDYuNzAxMDE0XSBDUFU6
IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNS4wLTA3ODYwLWdiMWNj
ZTgwICMxClsgICAgNi43MDEwMTRdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3Qg
dGFpbnRlZCAzLjE1LjAtMDc4NjAtZ2IxY2NlODAgIzEKWyAgICA2LjcwMTAxNF0gSGFyZHdh
cmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDYuNzAx
MDE0XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDEx
ClsgICAgNi43MDEwMTRdIHRhc2s6IDg5Y2E4NjYwIHRpOiA4OWNhYzAwMCB0YXNrLnRpOiA4
OWNhYzAwMApbICAgIDYuNzAxMDE0XSB0YXNrOiA4OWNhODY2MCB0aTogODljYWMwMDAgdGFz
ay50aTogODljYWMwMDAKWyAgICA2LjcwMTAxNF0gRUlQOiAwMDYwOls8ODUwMTcwNDI+XSBF
RkxBR1M6IDAwMDEwMjA2IENQVTogMApbICAgIDYuNzAxMDE0XSBFSVA6IDAwNjA6Wzw4NTAx
NzA0Mj5dIEVGTEFHUzogMDAwMTAyMDYgQ1BVOiAwClsgICAgNi43MDEwMTRdIEVJUCBpcyBh
dCBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZApbICAgIDYuNzAxMDE0XSBFSVAg
aXMgYXQgYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQKWyAgICA2LjcwMTAxNF0g
RUFYOiAwYTQwMDAwMCBFQlg6IDAwMDAwMDAwIEVDWDogMDAwMDAwMDYgRURYOiAwMDAwMDAw
MApbICAgIDYuNzAxMDE0XSBFQVg6IDBhNDAwMDAwIEVCWDogMDAwMDAwMDAgRUNYOiAwMDAw
MDAwNiBFRFg6IDAwMDAwMDAwClsgICAgNi43MDEwMTRdIEVTSTogN2Q3OTc0YzAgRURJOiAw
MDAwMDAwMCBFQlA6IDg5Y2FkZjMwIEVTUDogODljYWRmMmMKWyAgICA2LjcwMTAxNF0gRVNJ
OiA3ZDc5NzRjMCBFREk6IDAwMDAwMDAwIEVCUDogODljYWRmMzAgRVNQOiA4OWNhZGYyYwpb
ICAgIDYuNzAxMDE0XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6
IDAwNjgKWyAgICA2LjcwMTAxNF0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAw
MGUwIFNTOiAwMDY4ClsgICAgNi43MDEwMTRdIENSMDogODAwNTAwM2IgQ1IyOiAwYTQwMDAw
MCBDUjM6IDBkMDk1MDAwIENSNDogMDAwMDA2OTAKWyAgICA2LjcwMTAxNF0gQ1IwOiA4MDA1
MDAzYiBDUjI6IDBhNDAwMDAwIENSMzogMGQwOTUwMDAgQ1I0OiAwMDAwMDY5MApbICAgIDYu
NzAxMDE0XSBTdGFjazoKWyAgICA2LjcwMTAxNF0gU3RhY2s6ClsgICAgNi43MDEwMTRdICA4
NTAxNmZkNwpbICAgIDYuNzAxMDE0XSAgODUwMTZmZDcgODljYWRmOTAgODljYWRmOTAgODRm
ZDJiYTkgODRmZDJiYTkgODRlMGU5ZjAgODRlMGU5ZjAgODljYWRmNGMgODljYWRmNGMgODM0
M2IxMDAgODM0M2IxMDAgODQ2YWIzNzAgODQ2YWIzNzAgOGJmZjY5NjAgOGJmZjY5NjAKClsg
ICAgNi43MDEwMTRdICA4OWNhZGY4MApbICAgIDYuNzAxMDE0XSAgODljYWRmODAgODM0M2Iy
ZTEgODM0M2IyZTEgMDAwMDAxYjEgMDAwMDAxYjEgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDAw
MDYgMDAwMDAwMDYgODRlMGNlZTAgODRlMGNlZTAgOGJmZjY5NzIgOGJmZjY5NzIgMDAwMDAy
MDAgMDAwMDAyMDAKClsgICAgNi43MDEwMTRdICA4NGNlNmQyNApbICAgIDYuNzAxMDE0XSAg
ODRjZTZkMjQgOGJmZjY5NzEgOGJmZjY5NzEgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDA5Yzgg
MDAwMDA5YzggODUwNzQ1MjggODUwNzQ1MjggZjlkNTRhNGYgZjlkNTRhNGYgMDAwMDAwMDYg
MDAwMDAwMDYgMDAwMDA5YzggMDAwMDA5YzgKClsgICAgNi43MDEwMTRdIENhbGwgVHJhY2U6
ClsgICAgNi43MDEwMTRdIENhbGwgVHJhY2U6ClsgICAgNi43MDEwMTRdICBbPDg1MDE2ZmQ3
Pl0gPyB0dHVzYjJfZHJpdmVyX2luaXQrMHgxNi8weDE2ClsgICAgNi43MDEwMTRdICBbPDg1
MDE2ZmQ3Pl0gPyB0dHVzYjJfZHJpdmVyX2luaXQrMHgxNi8weDE2ClsgICAgNi43MDEwMTRd
ICBbPDg0ZmQyYmE5Pl0gZG9fb25lX2luaXRjYWxsKzB4MTYwLzB4MTZmClsgICAgNi43MDEw
MTRdICBbPDg0ZmQyYmE5Pl0gZG9fb25lX2luaXRjYWxsKzB4MTYwLzB4MTZmClsgICAgNi43
MDEwMTRdICBbPDgzNDNiMTAwPl0gPyBwYXJhbV9hcnJheV9zZXQrMHg0ZS8weGM3ClsgICAg
Ni43MDEwMTRdICBbPDgzNDNiMTAwPl0gPyBwYXJhbV9hcnJheV9zZXQrMHg0ZS8weGM3Clsg
ICAgNi43MDEwMTRdICBbPDgzNDNiMmUxPl0gPyBwYXJzZV9hcmdzKzB4MTEzLzB4MjVjClsg
ICAgNi43MDEwMTRdICBbPDgzNDNiMmUxPl0gPyBwYXJzZV9hcmdzKzB4MTEzLzB4MjVjClsg
ICAgNi43MDEwMTRdICBbPDg0ZmQyY2EyPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhlYS8w
eDE2NwpbICAgIDYuNzAxMDE0XSAgWzw4NGZkMmNhMj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxl
KzB4ZWEvMHgxNjcKWyAgICA2LjcwMTAxNF0gIFs8ODQ1MWRhOTQ+XSBrZXJuZWxfaW5pdCsw
eDgvMHhiOApbICAgIDYuNzAxMDE0XSAgWzw4NDUxZGE5ND5dIGtlcm5lbF9pbml0KzB4OC8w
eGI4ClsgICAgNi43MDEwMTRdICBbPDg0NTQ0YWMwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVh
ZCsweDIwLzB4MzAKWyAgICA2LjcwMTAxNF0gIFs8ODQ1NDRhYzA+XSByZXRfZnJvbV9rZXJu
ZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgIDYuNzAxMDE0XSAgWzw4NDUxZGE4Yz5dID8gcmVz
dF9pbml0KzB4MTBjLzB4MTBjClsgICAgNi43MDEwMTRdICBbPDg0NTFkYThjPl0gPyByZXN0
X2luaXQrMHgxMGMvMHgxMGMKWyAgICA2LjcwMTAxNF0gQ29kZToKWyAgICA2LjcwMTAxNF0g
Q29kZTogMDggMDggYzIgYzIgYzcgYzcgMDUgMDUgNjQgNjQgMDkgMDkgODggODggODUgODUg
MDAgMDAgMDAgMDAgNDAgNDAgMGEgMGEgYzcgYzcgMDUgMDUgNjAgNjAgMDkgMDkgODggODgg
ODUgODUgMDAgMDAgMDAgMDAgNDAgNDAgMGEgMGEgYzcgYzcgMDUgMDUgNWMgNWMgMDkgMDkg
ODggODggODUgODUgMDAgMDAgMDAgMDAgNDAgNDAgMGEgMGEgNzUgNzUgMWYgMWYgYjggYjgg
MDAgMDAgMDAgMDAgNDAgNDAgMGEgMGEgODUgODUgYzAgYzAgNzQgNzQgMTYgMTYgPGExPiA8
YTE+IDAwIDAwIDAwIDAwIDQwIDQwIDBhIDBhIGM3IGM3IDA1IDA1IDM0IDM0IDM0IDM0IGYy
IGYyIDg0IDg0IDAwIDAwIDAwIDAwIDQwIDQwIDBhIDBhIGEzIGEzIDM4IDM4IDM0IDM0IGYy
IGYyIDg0IDg0IGViIGViCgpbICAgIDYuNzAxMDE0XSBFSVA6IFs8ODUwMTcwNDI+XSAKWyAg
ICA2LjcwMTAxNF0gRUlQOiBbPDg1MDE3MDQyPl0gYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsw
eDZiLzB4OWRhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZCBTUzpFU1AgMDA2ODo4
OWNhZGYyYwogU1M6RVNQIDAwNjg6ODljYWRmMmMKWyAgICA2LjcwMTAxNF0gQ1IyOiAwMDAw
MDAwMDBhNDAwMDAwClsgICAgNi43MDEwMTRdIENSMjogMDAwMDAwMDAwYTQwMDAwMApbICAg
IDYuNzAxMDE0XSAtLS1bIGVuZCB0cmFjZSAzNmMwYjIyYmI2MDRkODdiIF0tLS0KWyAgICA2
LjcwMTAxNF0gLS0tWyBlbmQgdHJhY2UgMzZjMGIyMmJiNjA0ZDg3YiBdLS0tCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9iMWNjZTgwMzJmNmFiZTkwMGIwNzhkMjRm
M2MzOTM4NzI2NTI4Zjk3L2RtZXNnLXF1YW50YWwtdnAtMTc6MjAxNDA5MTcyMzIyMjY6aTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0MzozLjE1LjAtMDc4NjAtZ2IxY2NlODA6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvYjFjY2U4MDMyZjZhYmU5MDBiMDc4
ZDI0ZjNjMzkzODcyNjUyOGY5Ny9kbWVzZy15b2N0by1rYnVpbGQtMjE6MjAxNDA5MTcyMzIw
MzQ6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0MzozLjE1LjAtMDc4NjAtZ2IxY2NlODA6
MQowOjI6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOS0xNyAy
MzoyMzoyNCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTEvb2Jq
LWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA3ODYwIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMyBzdGVwcykKW2RhODVkMTkxZjU4YTQ0ZTE0
OWE3YzA3ZGJhZTc4YjMwNDI5MDk3OThdIE1lcmdlIGJyYW5jaCAnZm9yLTMuMTYnIG9mIGdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90ai93cQpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXgtMS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzL25leHQ6bWFzdGVyOmRhODVk
MTkxZjU4YTQ0ZTE0OWE3YzA3ZGJhZTc4YjMwNDI5MDk3OTg6YmlzZWN0LWxpbnV4LTEKCjIw
MTQtMDktMTcgMjM6MjM6MjUgZGE4NWQxOTFmNThhNDRlMTQ5YTdjMDdkYmFlNzhiMzA0Mjkw
OTc5OCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9sa3AtaWIwMy9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLWRhODVkMTkx
ZjU4YTQ0ZTE0OWE3YzA3ZGJhZTc4YjMwNDI5MDk3OTgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvZGE4NWQxOTFmNThhNDRlMTQ5
YTdjMDdkYmFlNzhiMzA0MjkwOTc5OAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3
MjA0My1kYTg1ZDE5MWY1OGE0NGUxNDlhN2MwN2RiYWU3OGIzMDQyOTA5Nzk4ChtbMTszNW0y
MDE0LTA5LTE3IDIzOjI3OjI1IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMv
YnVpbGQtc2VydmVkL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtZGE4NWQxOTFmNThh
NDRlMTQ5YTdjMDdkYmFlNzhiMzA0MjkwOTc5OBtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAz
LXNtb2tlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtZGE4NWQxOTFmNThhNDRlMTQ5
YTdjMDdkYmFlNzhiMzA0MjkwOTc5OAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0My9kYTg1ZDE5MWY1OGE0NGUxNDlhN2MwN2RiYWU3OGIzMDQyOTA5Nzk4
L3ZtbGludXotMy4xNS4wLTA3MjgzLWdkYTg1ZDE5CgoyMDE0LTA5LTE3IDIzOjI5OjI1IGRl
dGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgNy44MTIzOTFdIHVzYmNv
cmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgZHZiX3VzYl90dHVzYjIKWyAg
ICA3LjgxMzgyNl0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBk
dmJfdXNiX2FmOTAwNQpbICAgIDcuODEzODI2XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBp
bnRlcmZhY2UgZHJpdmVyIGR2Yl91c2JfYWY5MDA1ClsgICAgNy44MTUyMTBdIEJVRzogdW5h
YmxlIHRvIGhhbmRsZSBrZXJuZWwgClsgICAgNy44MTUyMTBdIEJVRzogdW5hYmxlIHRvIGhh
bmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3RwYWdpbmcgcmVxdWVzdCBhdCAwNmEwMDAwMAog
YXQgMDZhMDAwMDAKWyAgICA3LjgxNjY1N10gSVA6ClsgICAgNy44MTY2NTddIElQOiBbPDgx
NjEwZjliPl0gYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQKIFs8ODE2MTBmOWI+
XSBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZApbICAgIDcuODE3OTI4XSAqcGRl
ID0gMDAwMDAwMDAgClsgICAgNy44MTc5MjhdICpwZGUgPSAwMDAwMDAwMCAKClsgICAgNy44
MTg1OTNdIE9vcHM6IDAwMDAgWyMxXSAKWyAgICA3LjgxODU5M10gT29wczogMDAwMCBbIzFd
IFBSRUVNUFQgUFJFRU1QVCBERUJVR19QQUdFQUxMT0NERUJVR19QQUdFQUxMT0MKClsgICAg
Ny44MTk3MzNdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE1
LjAtMDcyODMtZ2RhODVkMTkgIzIKWyAgICA3LjgxOTczM10gQ1BVOiAwIFBJRDogMSBDb21t
OiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTUuMC0wNzI4My1nZGE4NWQxOSAjMgpbICAgIDcu
ODIwODIxXSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlY
LCAxOTk2KSwgQklPUyAxLjcuNS0yMDE0MDUzMV8wODMwMzAtZ2FuZGFsZiAwNC8wMS8yMDE0
ClsgICAgNy44MjA4MjFdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBG
WCArIFBJSVgsIDE5OTYpLCBCSU9TIDEuNy41LTIwMTQwNTMxXzA4MzAzMC1nYW5kYWxmIDA0
LzAxLzIwMTQKWyAgICA3LjgyMDgyMV0gdGFzazogODljOWE2NjAgdGk6IDg5YzljMDAwIHRh
c2sudGk6IDg5YzljMDAwClsgICAgNy44MjA4MjFdIHRhc2s6IDg5YzlhNjYwIHRpOiA4OWM5
YzAwMCB0YXNrLnRpOiA4OWM5YzAwMApbICAgIDcuODIwODIxXSBFSVA6IDAwNjA6Wzw4MTYx
MGY5Yj5dIEVGTEFHUzogMDAwMTAyMDYgQ1BVOiAwClsgICAgNy44MjA4MjFdIEVJUDogMDA2
MDpbPDgxNjEwZjliPl0gRUZMQUdTOiAwMDAxMDIwNiBDUFU6IDAKWyAgICA3LjgyMDgyMV0g
RUlQIGlzIGF0IGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkClsgICAgNy44MjA4
MjFdIEVJUCBpcyBhdCBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZApbICAgIDcu
ODIwODIxXSBFQVg6IDA2YTAwMDAwIEVCWDogMDAwMDAwMDAgRUNYOiAwMDAwMDAwNiBFRFg6
IDAwMDAwMDAwClsgICAgNy44MjA4MjFdIEVBWDogMDZhMDAwMDAgRUJYOiAwMDAwMDAwMCBF
Q1g6IDAwMDAwMDA2IEVEWDogMDAwMDAwMDAKWyAgICA3LjgyMDgyMV0gRVNJOiA3ZDcyODk4
MCBFREk6IDAwMDAwMDAwIEVCUDogODljOWRmMzAgRVNQOiA4OWM5ZGYyYwpbICAgIDcuODIw
ODIxXSBFU0k6IDdkNzI4OTgwIEVESTogMDAwMDAwMDAgRUJQOiA4OWM5ZGYzMCBFU1A6IDg5
YzlkZjJjClsgICAgNy44MjA4MjFdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzog
MDBlMCBTUzogMDA2OApbICAgIDcuODIwODIxXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAw
MDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgICA3LjgyMDgyMV0gQ1IwOiA4MDA1MDAzYiBDUjI6
IDA2YTAwMDAwIENSMzogMDk2OGYwMDAgQ1I0OiAwMDAwMDY5MApbICAgIDcuODIwODIxXSBD
UjA6IDgwMDUwMDNiIENSMjogMDZhMDAwMDAgQ1IzOiAwOTY4ZjAwMCBDUjQ6IDAwMDAwNjkw
ClsgICAgNy44MjA4MjFdIFN0YWNrOgpbICAgIDcuODIwODIxXSBTdGFjazoKWyAgICA3Ljgy
MDgyMV0gIDgxNjEwZjMwClsgICAgNy44MjA4MjFdICA4MTYxMGYzMCA4OWM5ZGY5MCA4OWM5
ZGY5MCA4MTVjY2JhOSA4MTVjY2JhOSA4MTQwOTY0MCA4MTQwOTY0MCA4OWM5ZGY0YyA4OWM5
ZGY0YyA3ZmEzYjEwMCA3ZmEzYjEwMCA4MGNhNzM3MCA4MGNhNzM3MCA4YTRjMzk2NCA4YTRj
Mzk2NAoKWyAgICA3LjgyMDgyMV0gIDg5YzlkZjgwClsgICAgNy44MjA4MjFdICA4OWM5ZGY4
MCA3ZmEzYjJlMSA3ZmEzYjJlMSAwMDAwMDFiMSAwMDAwMDFiMSAwMDAwMDAwNiAwMDAwMDAw
NiAwMDAwMDAwNiAwMDAwMDAwNiA4MTQwN2IzMCA4MTQwN2IzMCA4YTRjMzk3NiA4YTRjMzk3
NiAwMDAwMDIwMCAwMDAwMDIwMAoKWyAgICA3LjgyMDgyMV0gIDgxMmUxYTI0ClsgICAgNy44
MjA4MjFdICA4MTJlMWEyNCA4YTRjMzk3NSA4YTRjMzk3NSAwMDAwMDAwNiAwMDAwMDAwNiAw
MDAwMDljNyAwMDAwMDljNyA4MTY2ZTUyOCA4MTY2ZTUyOCA5NDE1NDM2MCA5NDE1NDM2MCAw
MDAwMDAwNiAwMDAwMDAwNiAwMDAwMDljNyAwMDAwMDljNwoKWyAgICA3LjgyMDgyMV0gQ2Fs
bCBUcmFjZToKWyAgICA3LjgyMDgyMV0gQ2FsbCBUcmFjZToKWyAgICA3LjgyMDgyMV0gIFs8
ODE2MTBmMzA+XSA/IHR0dXNiMl9kcml2ZXJfaW5pdCsweDE2LzB4MTYKWyAgICA3LjgyMDgy
MV0gIFs8ODE2MTBmMzA+XSA/IHR0dXNiMl9kcml2ZXJfaW5pdCsweDE2LzB4MTYKWyAgICA3
LjgyMDgyMV0gIFs8ODE1Y2NiYTk+XSBkb19vbmVfaW5pdGNhbGwrMHgxNjAvMHgxNmYKWyAg
ICA3LjgyMDgyMV0gIFs8ODE1Y2NiYTk+XSBkb19vbmVfaW5pdGNhbGwrMHgxNjAvMHgxNmYK
WyAgICA3LjgyMDgyMV0gIFs8N2ZhM2IxMDA+XSA/IHBhcmFtX2FycmF5X3NldCsweDRlLzB4
YzcKWyAgICA3LjgyMDgyMV0gIFs8N2ZhM2IxMDA+XSA/IHBhcmFtX2FycmF5X3NldCsweDRl
LzB4YzcKWyAgICA3LjgyMDgyMV0gIFs8N2ZhM2IyZTE+XSA/IHBhcnNlX2FyZ3MrMHgxMTMv
MHgyNWMKWyAgICA3LjgyMDgyMV0gIFs8N2ZhM2IyZTE+XSA/IHBhcnNlX2FyZ3MrMHgxMTMv
MHgyNWMKWyAgICA3LjgyMDgyMV0gIFs8ODE1Y2NjYTI+XSBrZXJuZWxfaW5pdF9mcmVlYWJs
ZSsweGVhLzB4MTY3ClsgICAgNy44MjA4MjFdICBbPDgxNWNjY2EyPl0ga2VybmVsX2luaXRf
ZnJlZWFibGUrMHhlYS8weDE2NwpbICAgIDcuODIwODIxXSAgWzw4MGIxOWI5ND5dIGtlcm5l
bF9pbml0KzB4OC8weGI4ClsgICAgNy44MjA4MjFdICBbPDgwYjE5Yjk0Pl0ga2VybmVsX2lu
aXQrMHg4LzB4YjgKWyAgICA3LjgyMDgyMV0gIFs8ODBiNDBiYzA+XSByZXRfZnJvbV9rZXJu
ZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgIDcuODIwODIxXSAgWzw4MGI0MGJjMD5dIHJldF9m
cm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsgICAgNy44MjA4MjFdICBbPDgwYjE5Yjhj
Pl0gPyByZXN0X2luaXQrMHgxMGMvMHgxMGMKWyAgICA3LjgyMDgyMV0gIFs8ODBiMTliOGM+
XSA/IHJlc3RfaW5pdCsweDEwYy8weDEwYwpbICAgIDcuODIwODIxXSBDb2RlOgpbICAgIDcu
ODIwODIxXSBDb2RlOiAwOCAwOCBjMiBjMiBjNyBjNyAwNSAwNSAyNCAyNCBhOSBhOSBlNyBl
NyA4MSA4MSAwMCAwMCAwMCAwMCBhMCBhMCAwNiAwNiBjNyBjNyAwNSAwNSAyMCAyMCBhOSBh
OSBlNyBlNyA4MSA4MSAwMCAwMCAwMCAwMCBhMCBhMCAwNiAwNiBjNyBjNyAwNSAwNSAxYyAx
YyBhOSBhOSBlNyBlNyA4MSA4MSAwMCAwMCAwMCAwMCBhMCBhMCAwNiAwNiA3NSA3NSAxZiAx
ZiBiOCBiOCAwMCAwMCAwMCAwMCBhMCBhMCAwNiAwNiA4NSA4NSBjMCBjMCA3NCA3NCAxNiAx
NiA8YTE+IDxhMT4gMDAgMDAgMDAgMDAgYTAgYTAgMDYgMDYgYzcgYzcgMDUgMDUgMzQgMzQg
ZDEgZDEgNTEgNTEgODEgODEgMDAgMDAgMDAgMDAgYTAgYTAgMDYgMDYgYTMgYTMgMzggMzgg
ZDEgZDEgNTEgNTEgODEgODEgZWIgZWIKClsgICAgNy44MjA4MjFdIEVJUDogWzw4MTYxMGY5
Yj5dIApbICAgIDcuODIwODIxXSBFSVA6IFs8ODE2MTBmOWI+XSBhZjkwMDVfdXNiX21vZHVs
ZV9pbml0KzB4NmIvMHg5ZGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkIFNTOkVT
UCAwMDY4Ojg5YzlkZjJjCiBTUzpFU1AgMDA2ODo4OWM5ZGYyYwpbICAgIDcuODIwODIxXSBD
UjI6IDAwMDAwMDAwMDZhMDAwMDAKWyAgICA3LjgyMDgyMV0gQ1IyOiAwMDAwMDAwMDA2YTAw
MDAwClsgICAgNy44MjA4MjFdIC0tLVsgZW5kIHRyYWNlIDJlMzdkMDM5MDU0NWMwYTIgXS0t
LQpbICAgIDcuODIwODIxXSAtLS1bIGVuZCB0cmFjZSAyZTM3ZDAzOTA1NDVjMGEyIF0tLS0K
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzL2RhODVkMTkxZjU4YTQ0ZTE0
OWE3YzA3ZGJhZTc4YjMwNDI5MDk3OTgvZG1lc2ctcXVhbnRhbC1pdmI0MS00NDoyMDE0MDkx
NzIzMjkxNTppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaWIxLTA5MTcyMDQzL2RhODVkMTkxZjU4YTQ0ZTE0OWE3YzA3ZGJhZTc4YjMw
NDI5MDk3OTgvZG1lc2ctcXVhbnRhbC1pdmI0MS01MToyMDE0MDkxNzIzMjkxNDppMzg2LXJh
bmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5
MTcyMDQzL2RhODVkMTkxZjU4YTQ0ZTE0OWE3YzA3ZGJhZTc4YjMwNDI5MDk3OTgvZG1lc2ct
cXVhbnRhbC12cC0yNzoyMDE0MDkxNzIzMjkyMDppMzg2LXJhbmRjb25maWctaWIxLTA5MTcy
MDQzOjMuMTUuMC0wNzI4My1nZGE4NWQxOToyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0My9kYTg1ZDE5MWY1OGE0NGUxNDlhN2MwN2RiYWU3OGIzMDQyOTA5Nzk4L2Rt
ZXNnLXlvY3RvLXZwLTIwOjIwMTQwOTE3MjMyOTIwOmkzODYtcmFuZGNvbmZpZy1pYjEtMDkx
NzIwNDM6My4xNS4wLTA3MjgzLWdkYTg1ZDE5OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aWIxLTA5MTcyMDQzL2RhODVkMTkxZjU4YTQ0ZTE0OWE3YzA3ZGJhZTc4YjMwNDI5MDk3OTgv
ZG1lc2cteW9jdG8tdnAtNjM6MjAxNDA5MTcyMzI5MTk6aTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0MzozLjE1LjAtMDcyODMtZ2RhODVkMTk6Mgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pYjEtMDkxNzIwNDMvZGE4NWQxOTFmNThhNDRlMTQ5YTdjMDdkYmFlNzhiMzA0MjkwOTc5
OC9kbWVzZy1xdWFudGFsLWl2YjQxLTU2OjIwMTQwOTE3MjMyOTI0OmkzODYtcmFuZGNvbmZp
Zy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMv
ZGE4NWQxOTFmNThhNDRlMTQ5YTdjMDdkYmFlNzhiMzA0MjkwOTc5OC9kbWVzZy1xdWFudGFs
LWl2YjQxLTU4OjIwMTQwOTE3MjMyOTI4OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvZGE4NWQxOTFmNThhNDRl
MTQ5YTdjMDdkYmFlNzhiMzA0MjkwOTc5OC9kbWVzZy1xdWFudGFsLWl2YjQxLTU5OjIwMTQw
OTE3MjMyOTMwOmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvZGE4NWQxOTFmNThhNDRlMTQ5YTdjMDdkYmFlNzhi
MzA0MjkwOTc5OC9kbWVzZy15b2N0by12cC0zMzoyMDE0MDkxNzIzMjkyMzppMzg2LXJhbmRj
b25maWctaWIxLTA5MTcyMDQzOjMuMTUuMC0wNzI4My1nZGE4NWQxOToyCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9kYTg1ZDE5MWY1OGE0NGUxNDlhN2MwN2RiYWU3
OGIzMDQyOTA5Nzk4L2RtZXNnLXF1YW50YWwtaXZiNDEtNTE6MjAxNDA5MTcyMzI5NDI6aTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0My9kYTg1ZDE5MWY1OGE0NGUxNDlhN2MwN2RiYWU3OGIzMDQyOTA5Nzk4L2Rt
ZXNnLXF1YW50YWwtaXZiNDEtNjI6MjAxNDA5MTcyMzI5MzY6aTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9kYTg1
ZDE5MWY1OGE0NGUxNDlhN2MwN2RiYWU3OGIzMDQyOTA5Nzk4L2RtZXNnLXF1YW50YWwtaXZi
NDEtNjM6MjAxNDA5MTcyMzI5Mzg6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9kYTg1ZDE5MWY1OGE0NGUxNDlh
N2MwN2RiYWU3OGIzMDQyOTA5Nzk4L2RtZXNnLXF1YW50YWwtaXZiNDEtNjQ6MjAxNDA5MTcy
MzI5NDA6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wOTE3MjA0My9kYTg1ZDE5MWY1OGE0NGUxNDlhN2MwN2RiYWU3OGIzMDQy
OTA5Nzk4L2RtZXNnLXF1YW50YWwtaXZiNDEtNjU6MjAxNDA5MTcyMzI5NDI6aTM4Ni1yYW5k
Y29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3
MjA0My9kYTg1ZDE5MWY1OGE0NGUxNDlhN2MwN2RiYWU3OGIzMDQyOTA5Nzk4L2RtZXNnLXlv
Y3RvLWtidWlsZC0zMToyMDE0MDkxNzIzMjcwODppMzg2LXJhbmRjb25maWctaWIxLTA5MTcy
MDQzOjMuMTUuMC0wNzI4My1nZGE4NWQxOToyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0My9kYTg1ZDE5MWY1OGE0NGUxNDlhN2MwN2RiYWU3OGIzMDQyOTA5Nzk4L2Rt
ZXNnLXlvY3RvLWtidWlsZC05OjIwMTQwOTE3MjMyNzEzOmkzODYtcmFuZGNvbmZpZy1pYjEt
MDkxNzIwNDM6My4xNS4wLTA3MjgzLWdkYTg1ZDE5OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaWIxLTA5MTcyMDQzL2RhODVkMTkxZjU4YTQ0ZTE0OWE3YzA3ZGJhZTc4YjMwNDI5MDk3
OTgvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjM6MjAxNDA5MTcyMzI3MjE6aTM4Ni1yYW5kY29u
ZmlnLWliMS0wOTE3MjA0MzozLjE1LjAtMDcyODMtZ2RhODVkMTk6Mgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvZGE4NWQxOTFmNThhNDRlMTQ5YTdjMDdkYmFlNzhi
MzA0MjkwOTc5OC9kbWVzZy15b2N0by1rYnVpbGQtMzA6MjAxNDA5MTcyMzI3MTk6aTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0MzozLjE1LjAtMDcyODMtZ2RhODVkMTk6Mgova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvZGE4NWQxOTFmNThhNDRlMTQ5YTdjMDdk
YmFlNzhiMzA0MjkwOTc5OC9kbWVzZy15b2N0by1rYnVpbGQtMzI6MjAxNDA5MTcyMzI3MTk6
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0MzozLjE1LjAtMDcyODMtZ2RhODVkMTk6Mgow
OjE5OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA5LTE3IDIz
OjI5OjU2IFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtMS9vYmot
YmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDcyODMgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbZjg0MDlhYmRjNTkyZTEzY2Vm
YmU0ZTRhMjRhODRiM2Q1NzQxZTg1Zl0gTWVyZ2UgdGFnICdleHQ0X2Zvcl9saW51cycgb2Yg
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3R5dHNvL2V4
dDQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTEvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9uZXh0Om1hc3Rl
cjpmODQwOWFiZGM1OTJlMTNjZWZiZTRlNGEyNGE4NGIzZDU3NDFlODVmOmJpc2VjdC1saW51
eC0xCgoyMDE0LTA5LTE3IDIzOjI5OjU3IGY4NDA5YWJkYzU5MmUxM2NlZmJlNGU0YTI0YTg0
YjNkNTc0MWU4NWYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My1m
ODQwOWFiZGM1OTJlMTNjZWZiZTRlNGEyNGE4NGIzZDU3NDFlODVmCkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzL2Y4NDA5YWJkYzU5
MmUxM2NlZmJlNGU0YTI0YTg0YjNkNTc0MWU4NWYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDkxNzIwNDMtZjg0MDlhYmRjNTkyZTEzY2VmYmU0ZTRhMjRhODRiM2Q1NzQxZTg1Zgob
WzE7MzVtMjAxNC0wOS0xNyAyMzozMjo1NyBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxk
LXRlc3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLWY4NDA5
YWJkYzU5MmUxM2NlZmJlNGU0YTI0YTg0YjNkNTc0MWU4NWYbWzBtClJldHJ5IGJ1aWxkIC4u
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9s
a3AtaWIwMy1zbW9rZS9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLWY4NDA5YWJkYzU5
MmUxM2NlZmJlNGU0YTI0YTg0YjNkNTc0MWU4NWYKa2VybmVsOiAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDkxNzIwNDMvZjg0MDlhYmRjNTkyZTEzY2VmYmU0ZTRhMjRhODRiM2Q1
NzQxZTg1Zi92bWxpbnV6LTMuMTUuMC0wNzI1Mi1nZjg0MDlhYgoKMjAxNC0wOS0xNyAyMzoz
Nzo1NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgMTAuNzE1MTQw
XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91c2JfdHR1
c2IyClsgICAxMC43MTYxMTZdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBk
cml2ZXIgZHZiX3VzYl9hZjkwMDUKWyAgIDEwLjcxNjExNl0gdXNiY29yZTogcmVnaXN0ZXJl
ZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBkdmJfdXNiX2FmOTAwNQpbICAgMTAuNzE3MDg4XSBC
VUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIApbICAgMTAuNzE3MDg4XSBCVUc6IHVuYWJs
ZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0cGFnaW5nIHJlcXVlc3QgYXQgMDc2
MDAwMDAKIGF0IDA3NjAwMDAwClsgICAxMC43MTgwMzNdIElQOgpbICAgMTAuNzE4MDMzXSBJ
UDogWzw4MjIxMGY5Yj5dIGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkCiBbPDgy
MjEwZjliPl0gYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQKWyAgIDEwLjcxODg4
N10gKnBkZSA9IDAwMDAwMDAwIApbICAgMTAuNzE4ODg3XSAqcGRlID0gMDAwMDAwMDAgCgpb
ICAgMTAuNzE5MzQ0XSBPb3BzOiAwMDAwIFsjMV0gClsgICAxMC43MTkzNDRdIE9vcHM6IDAw
MDAgWyMxXSBQUkVFTVBUIFBSRUVNUFQgREVCVUdfUEFHRUFMTE9DREVCVUdfUEFHRUFMTE9D
CgpbICAgMTAuNzIwMDA5XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50
ZWQgMy4xNS4wLTA3MjUyLWdmODQwOWFiICMxClsgICAxMC43MjAwMDldIENQVTogMCBQSUQ6
IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE1LjAtMDcyNTItZ2Y4NDA5YWIgIzEK
WyAgIDEwLjcyMDAwOV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMg
MDEvMDEvMjAxMQpbICAgMTAuNzIwMDA5XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2Nocywg
QklPUyBCb2NocyAwMS8wMS8yMDExClsgICAxMC43MjAwMDldIHRhc2s6IDhiNDk5NjYwIHRp
OiA4YjQ5YzAwMCB0YXNrLnRpOiA4YjQ5YzAwMApbICAgMTAuNzIwMDA5XSB0YXNrOiA4YjQ5
OTY2MCB0aTogOGI0OWMwMDAgdGFzay50aTogOGI0OWMwMDAKWyAgIDEwLjcyMDAwOV0gRUlQ
OiAwMDYwOls8ODIyMTBmOWI+XSBFRkxBR1M6IDAwMDEwMjA2IENQVTogMApbICAgMTAuNzIw
MDA5XSBFSVA6IDAwNjA6Wzw4MjIxMGY5Yj5dIEVGTEFHUzogMDAwMTAyMDYgQ1BVOiAwClsg
ICAxMC43MjAwMDldIEVJUCBpcyBhdCBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5
ZApbICAgMTAuNzIwMDA5XSBFSVAgaXMgYXQgYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZi
LzB4OWQKWyAgIDEwLjcyMDAwOV0gRUFYOiAwNzYwMDAwMCBFQlg6IDAwMDAwMDAwIEVDWDog
MDAwMDAwMDYgRURYOiAwMDAwMDAwMApbICAgMTAuNzIwMDA5XSBFQVg6IDA3NjAwMDAwIEVC
WDogMDAwMDAwMDAgRUNYOiAwMDAwMDAwNiBFRFg6IDAwMDAwMDAwClsgICAxMC43MjAwMDld
IEVTSTogODgyOTI3ZTAgRURJOiAwMDAwMDAwMCBFQlA6IDhiNDlkZjMwIEVTUDogOGI0OWRm
MmMKWyAgIDEwLjcyMDAwOV0gRVNJOiA4ODI5MjdlMCBFREk6IDAwMDAwMDAwIEVCUDogOGI0
OWRmMzAgRVNQOiA4YjQ5ZGYyYwpbICAgMTAuNzIwMDA5XSAgRFM6IDAwN2IgRVM6IDAwN2Ig
RlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDEwLjcyMDAwOV0gIERTOiAwMDdiIEVT
OiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4ClsgICAxMC43MjAwMDldIENSMDog
ODAwNTAwM2IgQ1IyOiAwNzYwMDAwMCBDUjM6IDExY2FlMDAwIENSNDogMDAwMDA2OTAKWyAg
IDEwLjcyMDAwOV0gQ1IwOiA4MDA1MDAzYiBDUjI6IDA3NjAwMDAwIENSMzogMTFjYWUwMDAg
Q1I0OiAwMDAwMDY5MApbICAgMTAuNzIwMDA5XSBTdGFjazoKWyAgIDEwLjcyMDAwOV0gU3Rh
Y2s6ClsgICAxMC43MjAwMDldICA4MjIxMGYzMApbICAgMTAuNzIwMDA5XSAgODIyMTBmMzAg
OGI0OWRmOTAgOGI0OWRmOTAgODIxY2NiYTkgODIxY2NiYTkgODIwMDk2MjAgODIwMDk2MjAg
OGI0OWRmNGMgOGI0OWRmNGMgODA2M2I0MDAgODA2M2I0MDAgODE4YTczNzAgODE4YTczNzAg
OGJmZjY5NjEgOGJmZjY5NjEKClsgICAxMC43MjAwMDldICA4YjQ5ZGY4MApbICAgMTAuNzIw
MDA5XSAgOGI0OWRmODAgODA2M2I1NTMgODA2M2I1NTMgMDAwMDAxYjEgMDAwMDAxYjEgMDAw
MDAwMDYgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDAwMDYgODIwMDdiMTAgODIwMDdiMTAgOGJm
ZjY5NzMgOGJmZjY5NzMgMDAwMDAyMDAgMDAwMDAyMDAKClsgICAxMC43MjAwMDldICA4MWVl
MTlmZgpbICAgMTAuNzIwMDA5XSAgODFlZTE5ZmYgOGJmZjY5NzIgOGJmZjY5NzIgMDAwMDAw
MDYgMDAwMDAwMDYgMDAwMDA5YzcgMDAwMDA5YzcgODIyNmU1MjggODIyNmU1MjggZGE1YzA2
ZDggZGE1YzA2ZDggMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDA5YzcgMDAwMDA5YzcKClsgICAx
MC43MjAwMDldIENhbGwgVHJhY2U6ClsgICAxMC43MjAwMDldIENhbGwgVHJhY2U6ClsgICAx
MC43MjAwMDldICBbPDgyMjEwZjMwPl0gPyB0dHVzYjJfZHJpdmVyX2luaXQrMHgxNi8weDE2
ClsgICAxMC43MjAwMDldICBbPDgyMjEwZjMwPl0gPyB0dHVzYjJfZHJpdmVyX2luaXQrMHgx
Ni8weDE2ClsgICAxMC43MjAwMDldICBbPDgyMWNjYmE5Pl0gZG9fb25lX2luaXRjYWxsKzB4
MTYwLzB4MTZmClsgICAxMC43MjAwMDldICBbPDgyMWNjYmE5Pl0gZG9fb25lX2luaXRjYWxs
KzB4MTYwLzB4MTZmClsgICAxMC43MjAwMDldICBbPDgwNjNiNDAwPl0gPyBwYXJhbWVxbisw
eDE1LzB4MzUKWyAgIDEwLjcyMDAwOV0gIFs8ODA2M2I0MDA+XSA/IHBhcmFtZXFuKzB4MTUv
MHgzNQpbICAgMTAuNzIwMDA5XSAgWzw4MDYzYjU1Mz5dID8gcGFyc2VfYXJncysweDExMy8w
eDI1YwpbICAgMTAuNzIwMDA5XSAgWzw4MDYzYjU1Mz5dID8gcGFyc2VfYXJncysweDExMy8w
eDI1YwpbICAgMTAuNzIwMDA5XSAgWzw4MjFjY2NhMj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxl
KzB4ZWEvMHgxNjcKWyAgIDEwLjcyMDAwOV0gIFs8ODIxY2NjYTI+XSBrZXJuZWxfaW5pdF9m
cmVlYWJsZSsweGVhLzB4MTY3ClsgICAxMC43MjAwMDldICBbPDgxNzE5ZTE0Pl0ga2VybmVs
X2luaXQrMHg4LzB4YjgKWyAgIDEwLjcyMDAwOV0gIFs8ODE3MTllMTQ+XSBrZXJuZWxfaW5p
dCsweDgvMHhiOApbICAgMTAuNzIwMDA5XSAgWzw4MTc0MGU0MD5dIHJldF9mcm9tX2tlcm5l
bF90aHJlYWQrMHgyMC8weDMwClsgICAxMC43MjAwMDldICBbPDgxNzQwZTQwPl0gcmV0X2Zy
b21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAKWyAgIDEwLjcyMDAwOV0gIFs8ODE3MTllMGM+
XSA/IHJlc3RfaW5pdCsweDEwYy8weDEwYwpbICAgMTAuNzIwMDA5XSAgWzw4MTcxOWUwYz5d
ID8gcmVzdF9pbml0KzB4MTBjLzB4MTBjClsgICAxMC43MjAwMDldIENvZGU6ClsgICAxMC43
MjAwMDldIENvZGU6IDA4IDA4IGMyIGMyIGM3IGM3IDA1IDA1IDI0IDI0IGE5IGE5IGE3IGE3
IDgyIDgyIDAwIDAwIDAwIDAwIDYwIDYwIDA3IDA3IGM3IGM3IDA1IDA1IDIwIDIwIGE5IGE5
IGE3IGE3IDgyIDgyIDAwIDAwIDAwIDAwIDYwIDYwIDA3IDA3IGM3IGM3IDA1IDA1IDFjIDFj
IGE5IGE5IGE3IGE3IDgyIDgyIDAwIDAwIDAwIDAwIDYwIDYwIDA3IDA3IDc1IDc1IDFmIDFm
IGI4IGI4IDAwIDAwIDAwIDAwIDYwIDYwIDA3IDA3IDg1IDg1IGMwIGMwIDc0IDc0IDE2IDE2
IDxhMT4gPGExPiAwMCAwMCAwMCAwMCA2MCA2MCAwNyAwNyBjNyBjNyAwNSAwNSAxNCAxNCBk
MSBkMSAxMSAxMSA4MiA4MiAwMCAwMCAwMCAwMCA2MCA2MCAwNyAwNyBhMyBhMyAxOCAxOCBk
MSBkMSAxMSAxMSA4MiA4MiBlYiBlYgoKWyAgIDEwLjcyMDAwOV0gRUlQOiBbPDgyMjEwZjli
Pl0gClsgICAxMC43MjAwMDldIEVJUDogWzw4MjIxMGY5Yj5dIGFmOTAwNV91c2JfbW9kdWxl
X2luaXQrMHg2Yi8weDlkYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQgU1M6RVNQ
IDAwNjg6OGI0OWRmMmMKIFNTOkVTUCAwMDY4OjhiNDlkZjJjClsgICAxMC43MjAwMDldIENS
MjogMDAwMDAwMDAwNzYwMDAwMApbICAgMTAuNzIwMDA5XSBDUjI6IDAwMDAwMDAwMDc2MDAw
MDAKWyAgIDEwLjcyMDAwOV0gLS0tWyBlbmQgdHJhY2UgOTRlMzU2YTI3MWM5NjY3ZSBdLS0t
ClsgICAxMC43MjAwMDldIC0tLVsgZW5kIHRyYWNlIDk0ZTM1NmEyNzFjOTY2N2UgXS0tLQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvZjg0MDlhYmRjNTkyZTEzY2Vm
YmU0ZTRhMjRhODRiM2Q1NzQxZTg1Zi9kbWVzZy15b2N0by12cC0xMToyMDE0MDkxNzIzMzcz
MDppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjMuMTUuMC0wNzI1Mi1nZjg0MDlhYjox
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9mODQwOWFiZGM1OTJlMTNj
ZWZiZTRlNGEyNGE4NGIzZDU3NDFlODVmL2RtZXNnLXlvY3RvLXZwLTE6MjAxNDA5MTcyMzM3
Mjc6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0MzozLjE1LjAtMDcyNTItZ2Y4NDA5YWI6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvZjg0MDlhYmRjNTkyZTEz
Y2VmYmU0ZTRhMjRhODRiM2Q1NzQxZTg1Zi9kbWVzZy15b2N0by12cC0yODoyMDE0MDkxNzIz
MzcyODppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjMuMTUuMC0wNzI1Mi1nZjg0MDlh
YjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9mODQwOWFiZGM1OTJl
MTNjZWZiZTRlNGEyNGE4NGIzZDU3NDFlODVmL2RtZXNnLXlvY3RvLXZwLTU4OjIwMTQwOTE3
MjMzNzI4OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6My4xNS4wLTA3MjUyLWdmODQw
OWFiOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzL2Y4NDA5YWJkYzU5
MmUxM2NlZmJlNGU0YTI0YTg0YjNkNTc0MWU4NWYvZG1lc2cteW9jdG8tdnAtNjE6MjAxNDA5
MTcyMzM3Mjg6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0MzozLjE1LjAtMDcyNTItZ2Y4
NDA5YWI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvZjg0MDlhYmRj
NTkyZTEzY2VmYmU0ZTRhMjRhODRiM2Q1NzQxZTg1Zi9kbWVzZy15b2N0by12cC02OjIwMTQw
OTE3MjMzNzMwOmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6My4xNS4wLTA3MjUyLWdm
ODQwOWFiOjEKMDo2OjYgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQt
MDktMTcgMjM6Mzg6MjkgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51
eC0xL29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogNzI1MiByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMgc3RlcHMpCltlZDgxZTc4MGE3
ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFkOGQwYjZmOWNlXSBNZXJnZSBicmFuY2ggJ3g4Ni12ZHNv
LWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3RpcC90aXAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTEvb2JqLWJpc2VjdApscyAtYSAv
a2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0
My9uZXh0Om1hc3RlcjplZDgxZTc4MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFkOGQwYjZmOWNl
OmJpc2VjdC1saW51eC0xCgoyMDE0LTA5LTE3IDIzOjM4OjI5IGVkODFlNzgwYTdkZDU2OThh
OTg2ZjI0NmZhZDZhMWQ4ZDBiNmY5Y2UgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0My1lZDgxZTc4MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFkOGQwYjZmOWNlCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQz
L2VkODFlNzgwYTdkZDU2OThhOTg2ZjI0NmZhZDZhMWQ4ZDBiNmY5Y2UKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtZWQ4MWU3ODBhN2RkNTY5OGE5ODZmMjQ2ZmFkNmEx
ZDhkMGI2ZjljZQobWzE7MzVtMjAxNC0wOS0xNyAyMzo0MTozMCBObyBidWlsZCBzZXJ2ZWQg
ZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25maWctaWIxLTA5
MTcyMDQzLWVkODFlNzgwYTdkZDU2OThhOTg2ZjI0NmZhZDZhMWQ4ZDBiNmY5Y2UbWzBtClJl
dHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9sa3AtaWIwMy1zbW9rZS9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQz
LWVkODFlNzgwYTdkZDU2OThhOTg2ZjI0NmZhZDZhMWQ4ZDBiNmY5Y2UKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvZWQ4MWU3ODBhN2RkNTY5OGE5ODZm
MjQ2ZmFkNmExZDhkMGI2ZjljZS92bWxpbnV6LTMuMTUuMC0wNzIyMC1nZWQ4MWU3OAoKMjAx
NC0wOS0xNyAyMzo0MzozMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpb
ICAgIDYuOTI0MzI0XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVy
IGR2Yl91c2JfdHR1c2IyClsgICAgNi45MjU5NjRdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3
IGludGVyZmFjZSBkcml2ZXIgZHZiX3VzYl9hZjkwMDUKWyAgICA2LjkyNTk2NF0gdXNiY29y
ZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBkdmJfdXNiX2FmOTAwNQpbICAg
IDYuOTI3NTIzXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIApbICAgIDYuOTI3NTIz
XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0cGFnaW5nIHJl
cXVlc3QgYXQgMGI0MDAwMDAKIGF0IDBiNDAwMDAwClsgICAgNi45MjkxMjNdIElQOgpbICAg
IDYuOTI5MTIzXSBJUDogWzw4NjAxMGY5Yj5dIGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2
Yi8weDlkCiBbPDg2MDEwZjliPl0gYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQK
WyAgICA2LjkzMDU3MV0gKnBkZSA9IDAwMDAwMDAwIApbICAgIDYuOTMwNTcxXSAqcGRlID0g
MDAwMDAwMDAgCgpbICAgIDYuOTMwOTg0XSBPb3BzOiAwMDAwIFsjMV0gClsgICAgNi45MzA5
ODRdIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIFBSRUVNUFQgREVCVUdfUEFHRUFMTE9DREVC
VUdfUEFHRUFMTE9DCgpbICAgIDYuOTMwOTg0XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBw
ZXIgTm90IHRhaW50ZWQgMy4xNS4wLTA3MjIwLWdlZDgxZTc4ICMyClsgICAgNi45MzA5ODRd
IENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE1LjAtMDcyMjAt
Z2VkODFlNzggIzIKWyAgICA2LjkzMDk4NF0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFy
ZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS43LjUtMjAxNDA1MzFfMDgzMDMw
LWdhbmRhbGYgMDQvMDEvMjAxNApbICAgIDYuOTMwOTg0XSBIYXJkd2FyZSBuYW1lOiBRRU1V
IFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyAxLjcuNS0yMDE0MDUz
MV8wODMwMzAtZ2FuZGFsZiAwNC8wMS8yMDE0ClsgICAgNi45MzA5ODRdIHRhc2s6IDg5Yzlh
NjYwIHRpOiA4OWM5YzAwMCB0YXNrLnRpOiA4OWM5YzAwMApbICAgIDYuOTMwOTg0XSB0YXNr
OiA4OWM5YTY2MCB0aTogODljOWMwMDAgdGFzay50aTogODljOWMwMDAKWyAgICA2LjkzMDk4
NF0gRUlQOiAwMDYwOls8ODYwMTBmOWI+XSBFRkxBR1M6IDAwMDEwMjA2IENQVTogMApbICAg
IDYuOTMwOTg0XSBFSVA6IDAwNjA6Wzw4NjAxMGY5Yj5dIEVGTEFHUzogMDAwMTAyMDYgQ1BV
OiAwClsgICAgNi45MzA5ODRdIEVJUCBpcyBhdCBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4
NmIvMHg5ZApbICAgIDYuOTMwOTg0XSBFSVAgaXMgYXQgYWY5MDA1X3VzYl9tb2R1bGVfaW5p
dCsweDZiLzB4OWQKWyAgICA2LjkzMDk4NF0gRUFYOiAwYjQwMDAwMCBFQlg6IDAwMDAwMDAw
IEVDWDogMDAwMDAwMDYgRURYOiAwMDAwMDAwMApbICAgIDYuOTMwOTg0XSBFQVg6IDBiNDAw
MDAwIEVCWDogMDAwMDAwMDAgRUNYOiAwMDAwMDAwNiBFRFg6IDAwMDAwMDAwClsgICAgNi45
MzA5ODRdIEVTSTogN2UyODA3ZTAgRURJOiAwMDAwMDAwMCBFQlA6IDg5YzlkZjMwIEVTUDog
ODljOWRmMmMKWyAgICA2LjkzMDk4NF0gRVNJOiA3ZTI4MDdlMCBFREk6IDAwMDAwMDAwIEVC
UDogODljOWRmMzAgRVNQOiA4OWM5ZGYyYwpbICAgIDYuOTMwOTg0XSAgRFM6IDAwN2IgRVM6
IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgICA2LjkzMDk4NF0gIERTOiAw
MDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4ClsgICAgNi45MzA5ODRd
IENSMDogODAwNTAwM2IgQ1IyOiAwYjQwMDAwMCBDUjM6IDBlMDhmMDAwIENSNDogMDAwMDA2
OTAKWyAgICA2LjkzMDk4NF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDBiNDAwMDAwIENSMzogMGUw
OGYwMDAgQ1I0OiAwMDAwMDY5MApbICAgIDYuOTMwOTg0XSBTdGFjazoKWyAgICA2LjkzMDk4
NF0gU3RhY2s6ClsgICAgNi45MzA5ODRdICA4NjAxMGYzMApbICAgIDYuOTMwOTg0XSAgODYw
MTBmMzAgODljOWRmOTAgODljOWRmOTAgODVmY2NiYTkgODVmY2NiYTkgODVlMDk1ZTggODVl
MDk1ZTggODljOWRmNGMgODljOWRmNGMgODQ0M2I0MDAgODQ0M2I0MDAgODU2YTczNzAgODU2
YTczNzAgOGE0YzM5NjMgOGE0YzM5NjMKClsgICAgNi45MzA5ODRdICA4OWM5ZGY4MApbICAg
IDYuOTMwOTg0XSAgODljOWRmODAgODQ0M2I1NTMgODQ0M2I1NTMgMDAwMDAxYjEgMDAwMDAx
YjEgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDAwMDYgODVlMDdhZDggODVlMDdh
ZDggOGE0YzM5NzUgOGE0YzM5NzUgMDAwMDAyMDAgMDAwMDAyMDAKClsgICAgNi45MzA5ODRd
ICA4NWNlMTlhZQpbICAgIDYuOTMwOTg0XSAgODVjZTE5YWUgOGE0YzM5NzQgOGE0YzM5NzQg
MDAwMDAwMDYgMDAwMDAwMDYgMDAwMDA5YzcgMDAwMDA5YzcgODYwNmU1MjggODYwNmU1Mjgg
NmE5ZGZiZmMgNmE5ZGZiZmMgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDA5YzcgMDAwMDA5YzcK
ClsgICAgNi45MzA5ODRdIENhbGwgVHJhY2U6ClsgICAgNi45MzA5ODRdIENhbGwgVHJhY2U6
ClsgICAgNi45MzA5ODRdICBbPDg2MDEwZjMwPl0gPyB0dHVzYjJfZHJpdmVyX2luaXQrMHgx
Ni8weDE2ClsgICAgNi45MzA5ODRdICBbPDg2MDEwZjMwPl0gPyB0dHVzYjJfZHJpdmVyX2lu
aXQrMHgxNi8weDE2ClsgICAgNi45MzA5ODRdICBbPDg1ZmNjYmE5Pl0gZG9fb25lX2luaXRj
YWxsKzB4MTYwLzB4MTZmClsgICAgNi45MzA5ODRdICBbPDg1ZmNjYmE5Pl0gZG9fb25lX2lu
aXRjYWxsKzB4MTYwLzB4MTZmClsgICAgNi45MzA5ODRdICBbPDg0NDNiNDAwPl0gPyBwYXJh
bWVxbisweDE1LzB4MzUKWyAgICA2LjkzMDk4NF0gIFs8ODQ0M2I0MDA+XSA/IHBhcmFtZXFu
KzB4MTUvMHgzNQpbICAgIDYuOTMwOTg0XSAgWzw4NDQzYjU1Mz5dID8gcGFyc2VfYXJncysw
eDExMy8weDI1YwpbICAgIDYuOTMwOTg0XSAgWzw4NDQzYjU1Mz5dID8gcGFyc2VfYXJncysw
eDExMy8weDI1YwpbICAgIDYuOTMwOTg0XSAgWzw4NWZjY2NhMj5dIGtlcm5lbF9pbml0X2Zy
ZWVhYmxlKzB4ZWEvMHgxNjcKWyAgICA2LjkzMDk4NF0gIFs8ODVmY2NjYTI+XSBrZXJuZWxf
aW5pdF9mcmVlYWJsZSsweGVhLzB4MTY3ClsgICAgNi45MzA5ODRdICBbPDg1NTE5ZGY0Pl0g
a2VybmVsX2luaXQrMHg4LzB4YjgKWyAgICA2LjkzMDk4NF0gIFs8ODU1MTlkZjQ+XSBrZXJu
ZWxfaW5pdCsweDgvMHhiOApbICAgIDYuOTMwOTg0XSAgWzw4NTU0MGUyMD5dIHJldF9mcm9t
X2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsgICAgNi45MzA5ODRdICBbPDg1NTQwZTIwPl0g
cmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAKWyAgICA2LjkzMDk4NF0gIFs8ODU1
MTlkZWM+XSA/IHJlc3RfaW5pdCsweDEwYy8weDEwYwpbICAgIDYuOTMwOTg0XSAgWzw4NTUx
OWRlYz5dID8gcmVzdF9pbml0KzB4MTBjLzB4MTBjClsgICAgNi45MzA5ODRdIENvZGU6Clsg
ICAgNi45MzA5ODRdIENvZGU6IDA4IDA4IGMyIGMyIGM3IGM3IDA1IDA1IDI0IDI0IGE5IGE5
IDg3IDg3IDg2IDg2IDAwIDAwIDAwIDAwIDQwIDQwIDBiIDBiIGM3IGM3IDA1IDA1IDIwIDIw
IGE5IGE5IDg3IDg3IDg2IDg2IDAwIDAwIDAwIDAwIDQwIDQwIDBiIDBiIGM3IGM3IDA1IDA1
IDFjIDFjIGE5IGE5IDg3IDg3IDg2IDg2IDAwIDAwIDAwIDAwIDQwIDQwIDBiIDBiIDc1IDc1
IDFmIDFmIGI4IGI4IDAwIDAwIDAwIDAwIDQwIDQwIDBiIDBiIDg1IDg1IGMwIGMwIDc0IDc0
IDE2IDE2IDxhMT4gPGExPiAwMCAwMCAwMCAwMCA0MCA0MCAwYiAwYiBjNyBjNyAwNSAwNSAx
NCAxNCBkMSBkMSBmMSBmMSA4NSA4NSAwMCAwMCAwMCAwMCA0MCA0MCAwYiAwYiBhMyBhMyAx
OCAxOCBkMSBkMSBmMSBmMSA4NSA4NSBlYiBlYgoKWyAgICA2LjkzMDk4NF0gRUlQOiBbPDg2
MDEwZjliPl0gClsgICAgNi45MzA5ODRdIEVJUDogWzw4NjAxMGY5Yj5dIGFmOTAwNV91c2Jf
bW9kdWxlX2luaXQrMHg2Yi8weDlkYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQg
U1M6RVNQIDAwNjg6ODljOWRmMmMKIFNTOkVTUCAwMDY4Ojg5YzlkZjJjClsgICAgNi45MzA5
ODRdIENSMjogMDAwMDAwMDAwYjQwMDAwMApbICAgIDYuOTMwOTg0XSBDUjI6IDAwMDAwMDAw
MGI0MDAwMDAKWyAgICA2LjkzMDk4NF0gLS0tWyBlbmQgdHJhY2UgMjAzNjk2OTY5NTRmYWFl
YiBdLS0tClsgICAgNi45MzA5ODRdIC0tLVsgZW5kIHRyYWNlIDIwMzY5Njk2OTU0ZmFhZWIg
XS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvZWQ4MWU3ODBhN2Rk
NTY5OGE5ODZmMjQ2ZmFkNmExZDhkMGI2ZjljZS9kbWVzZy1xdWFudGFsLWl2YjQxLTEwNjoy
MDE0MDkxNzIzNDMzODppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzL2VkODFlNzgwYTdkZDU2OThhOTg2ZjI0NmZh
ZDZhMWQ4ZDBiNmY5Y2UvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMjE6MjAxNDA5MTcyMzQzMzg6
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0My9lZDgxZTc4MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFkOGQwYjZmOWNl
L2RtZXNnLXF1YW50YWwtaXZiNDEtMTM6MjAxNDA5MTcyMzQzMzg6aTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9l
ZDgxZTc4MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFkOGQwYjZmOWNlL2RtZXNnLXF1YW50YWwt
aXZiNDEtMTQ6MjAxNDA5MTcyMzQzMzk6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9lZDgxZTc4MGE3ZGQ1Njk4
YTk4NmYyNDZmYWQ2YTFkOGQwYjZmOWNlL2RtZXNnLXF1YW50YWwtaXZiNDEtMjA6MjAxNDA5
MTcyMzQzMzg6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0My9lZDgxZTc4MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFk
OGQwYjZmOWNlL2RtZXNnLXF1YW50YWwtaXZiNDEtMzA6MjAxNDA5MTcyMzQzMzg6aTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0My9lZDgxZTc4MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFkOGQwYjZmOWNlL2RtZXNn
LXF1YW50YWwtaXZiNDEtNDE6MjAxNDA5MTcyMzQzNDA6aTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9lZDgxZTc4
MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFkOGQwYjZmOWNlL2RtZXNnLXF1YW50YWwtaXZiNDEt
NDI6MjAxNDA5MTcyMzQzMzk6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9lZDgxZTc4MGE3ZGQ1Njk4YTk4NmYy
NDZmYWQ2YTFkOGQwYjZmOWNlL2RtZXNnLXF1YW50YWwtaXZiNDEtNTI6MjAxNDA5MTcyMzQz
NDA6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wOTE3MjA0My9lZDgxZTc4MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFkOGQwYjZm
OWNlL2RtZXNnLXF1YW50YWwtaXZiNDEtNToyMDE0MDkxNzIzNDMzODppMzg2LXJhbmRjb25m
aWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQz
L2VkODFlNzgwYTdkZDU2OThhOTg2ZjI0NmZhZDZhMWQ4ZDBiNmY5Y2UvZG1lc2ctcXVhbnRh
bC1pdmI0MS05NjoyMDE0MDkxNzIzNDMzMzppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQz
OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzL2VkODFlNzgwYTdkZDU2
OThhOTg2ZjI0NmZhZDZhMWQ4ZDBiNmY5Y2UvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDQ6MjAx
NDA5MTcyMzQzNDU6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9lZDgxZTc4MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2
YTFkOGQwYjZmOWNlL2RtZXNnLXF1YW50YWwtaXZiNDEtMTA6MjAxNDA5MTcyMzQzNDM6aTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0My9lZDgxZTc4MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFkOGQwYjZmOWNlL2Rt
ZXNnLXF1YW50YWwtaXZiNDEtMTExOjIwMTQwOTE3MjM0MzQ0OmkzODYtcmFuZGNvbmZpZy1p
YjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvZWQ4
MWU3ODBhN2RkNTY5OGE5ODZmMjQ2ZmFkNmExZDhkMGI2ZjljZS9kbWVzZy1xdWFudGFsLWl2
YjQxLTExNDoyMDE0MDkxNzIzNDM0NTppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzL2VkODFlNzgwYTdkZDU2OThh
OTg2ZjI0NmZhZDZhMWQ4ZDBiNmY5Y2UvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMjY6MjAxNDA5
MTcyMzQzNDM6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0My9lZDgxZTc4MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFk
OGQwYjZmOWNlL2RtZXNnLXF1YW50YWwtaXZiNDEtMTU6MjAxNDA5MTcyMzQzNDM6aTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0My9lZDgxZTc4MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFkOGQwYjZmOWNlL2RtZXNn
LXF1YW50YWwtaXZiNDEtMjY6MjAxNDA5MTcyMzQzNDY6aTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9lZDgxZTc4
MGE3ZGQ1Njk4YTk4NmYyNDZmYWQ2YTFkOGQwYjZmOWNlL2RtZXNnLXF1YW50YWwtaXZiNDEt
MzU6MjAxNDA5MTcyMzQzNDM6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9lZDgxZTc4MGE3ZGQ1Njk4YTk4NmYy
NDZmYWQ2YTFkOGQwYjZmOWNlL2RtZXNnLXF1YW50YWwtaXZiNDEtNjY6MjAxNDA5MTcyMzQz
NDQ6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6CjA6MjA6MjAgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDktMTcgMjM6NDQ6MDEgUkVQRUFUIENPVU5U
OiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eC0xL29iai1iaXNlY3QvLnJlcGVhdBtbMG0K
CkJpc2VjdGluZzogNzIyMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMTMgc3RlcHMpClszZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFhM2Zi
MWMwXSBNZXJnZSBicmFuY2ggJ25leHQnIChhY2N1bXVsYXRlZCAzLjE2IG1lcmdlIHdpbmRv
dyBwYXRjaGVzKSBpbnRvIG1hc3RlcgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMS9vYmotYmlzZWN0
CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIx
LTA5MTcyMDQzL25leHQ6bWFzdGVyOjNmMTdlYTZkZWE4YmE1NjY4ODczYWZhNTQ2MjhhOTFh
YWEzZmIxYzA6YmlzZWN0LWxpbnV4LTEKCjIwMTQtMDktMTcgMjM6NDQ6MDEgM2YxN2VhNmRl
YThiYTU2Njg4NzNhZmE1NDYyOGE5MWFhYTNmYjFjMCBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy9pMzg2LXJhbmRj
b25maWctaWIxLTA5MTcyMDQzLTNmMTdlYTZkZWE4YmE1NjY4ODczYWZhNTQ2MjhhOTFhYWEz
ZmIxYzAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDkxNzIwNDMvM2YxN2VhNmRlYThiYTU2Njg4NzNhZmE1NDYyOGE5MWFhYTNmYjFjMAp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWli
MDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My0zZjE3ZWE2ZGVhOGJhNTY2ODg3M2Fm
YTU0NjI4YTkxYWFhM2ZiMWMwChtbMTszNW0yMDE0LTA5LTE3IDIzOjUzOjAyIE5vIGJ1aWxk
IHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL2kzODYtcmFuZGNvbmZp
Zy1pYjEtMDkxNzIwNDMtM2YxN2VhNmRlYThiYTU2Njg4NzNhZmE1NDYyOGE5MWFhYTNmYjFj
MBtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzLXNtb2tlL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDkxNzIwNDMtM2YxN2VhNmRlYThiYTU2Njg4NzNhZmE1NDYyOGE5MWFhYTNmYjFjMAprZXJu
ZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8zZjE3ZWE2ZGVhOGJh
NTY2ODg3M2FmYTU0NjI4YTkxYWFhM2ZiMWMwL3ZtbGludXotMy4xNS4wLTA3MjE4LWczZjE3
ZWE2CgoyMDE0LTA5LTE3IDIzOjU1OjAyIGRldGVjdGluZyBib290IHN0YXRlIAkxIFRFU1Qg
RkFJTFVSRQpbICAgIDIuMDI2MzE2XSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAweDhh
NzliMDAwLTB4OGJmZGZmZmZdClsgICAgMi4wMjYzMTZdIGRlYnVnOiB1bm1hcHBpbmcgaW5p
dCBbbWVtIDB4OGE3OWIwMDAtMHg4YmZkZmZmZl0KCkJVRzoga2VybmVsIGJvb3QgY3Jhc2hl
ZApFbGFwc2VkIHRpbWU6IDIwCnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFi
bGUta3ZtIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzNm
MTdlYTZkZWE4YmE1NjY4ODczYWZhNTQ2MjhhOTFhYWEzZmIxYzAvdm1saW51ei0zLjE1LjAt
MDcyMTgtZzNmMTdlYTYgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9
dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1
cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0tMSBzb2Z0bG9ja3VwX3Bh
bmljPTEgbm1pX3dhdGNoZG9nPXBhbmljIG9vcHM9cGFuaWMgbG9hZF9yYW1kaXNrPTIgcHJv
bXB0X3JhbWRpc2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5v
cm1hbCAgcm9vdD0vZGV2L3JhbTAgcncgbGluaz0va2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9uZXh0Om1hc3RlcjozZjE3ZWE2ZGVh
OGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFhM2ZiMWMwOmJpc2VjdC1saW51eC0xLy52bWxpbnV6
LTNmMTdlYTZkZWE4YmE1NjY4ODczYWZhNTQ2MjhhOTFhYWEzZmIxYzAtMjAxNDA5MTcyMzU0
MTUtNS1pdmI0MSBicmFuY2g9bmV4dC9tYXN0ZXIgQk9PVF9JTUFHRT0va2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvM2YxN2VhNmRlYThiYTU2Njg4NzNhZmE1NDYyOGE5
MWFhYTNmYjFjMC92bWxpbnV6LTMuMTUuMC0wNzIxOC1nM2YxN2VhNiBkcmJkLm1pbm9yX2Nv
dW50PTgnICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3F1YW50YWwtY29yZS1pMzg2
LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVz
ZXIsdmxhbj0xIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNi
IC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50
YWwtaXZiNDEtMTA2IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRh
bC1pdmI0MS0xMDYgLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8zZjE3ZWE2ZGVhOGJhNTY2ODg3
M2FmYTU0NjI4YTkxYWFhM2ZiMWMwL2RtZXNnLXF1YW50YWwtaXZiNDEtMTE1OjIwMTQwOTE3
MjM1NDQ2OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDkxNzIwNDMvM2YxN2VhNmRlYThiYTU2Njg4NzNhZmE1NDYyOGE5MWFh
YTNmYjFjMC9kbWVzZy1xdWFudGFsLWl2YjQxLTYxOjIwMTQwOTE3MjM1NDQ3OmkzODYtcmFu
ZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkx
NzIwNDMvM2YxN2VhNmRlYThiYTU2Njg4NzNhZmE1NDYyOGE5MWFhYTNmYjFjMC9kbWVzZy1x
dWFudGFsLWl2YjQxLTExOToyMDE0MDkxNzIzNTQ1MjppMzg2LXJhbmRjb25maWctaWIxLTA5
MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzNmMTdlYTZk
ZWE4YmE1NjY4ODczYWZhNTQ2MjhhOTFhYWEzZmIxYzAvZG1lc2ctcXVhbnRhbC1pdmI0MS0x
MjM6MjAxNDA5MTcyMzU0NTE6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8zZjE3ZWE2ZGVhOGJhNTY2ODg3M2Fm
YTU0NjI4YTkxYWFhM2ZiMWMwL2RtZXNnLXF1YW50YWwtaXZiNDEtMTI0OjIwMTQwOTE3MjM1
NDUyOmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDkxNzIwNDMvM2YxN2VhNmRlYThiYTU2Njg4NzNhZmE1NDYyOGE5MWFhYTNm
YjFjMC9kbWVzZy1xdWFudGFsLWl2YjQxLTE1OjIwMTQwOTE3MjM1NDUzOmkzODYtcmFuZGNv
bmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIw
NDMvM2YxN2VhNmRlYThiYTU2Njg4NzNhZmE1NDYyOGE5MWFhYTNmYjFjMC9kbWVzZy1xdWFu
dGFsLWl2YjQxLTI3OjIwMTQwOTE3MjM1NDUxOmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIw
NDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvM2YxN2VhNmRlYThi
YTU2Njg4NzNhZmE1NDYyOGE5MWFhYTNmYjFjMC9kbWVzZy1xdWFudGFsLWl2YjQxLTI6MjAx
NDA5MTcyMzU0NTE6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8zZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4
YTkxYWFhM2ZiMWMwL2RtZXNnLXF1YW50YWwtaXZiNDEtMzQ6MjAxNDA5MTcyMzU0NTI6aTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0My8zZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFhM2ZiMWMwL2Rt
ZXNnLXF1YW50YWwtaXZiNDEtMzg6MjAxNDA5MTcyMzU0NTI6aTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8zZjE3
ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFhM2ZiMWMwL2RtZXNnLXF1YW50YWwtaXZi
NDEtNDQ6MjAxNDA5MTcyMzU0NTE6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8zZjE3ZWE2ZGVhOGJhNTY2ODg3
M2FmYTU0NjI4YTkxYWFhM2ZiMWMwL2RtZXNnLXF1YW50YWwtaXZiNDEtNTg6MjAxNDA5MTcy
MzU0NTM6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wOTE3MjA0My8zZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFh
M2ZiMWMwL2RtZXNnLXF1YW50YWwtaXZiNDEtNzg6MjAxNDA5MTcyMzU0NTM6aTM4Ni1yYW5k
Y29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3
MjA0My8zZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFhM2ZiMWMwL2RtZXNnLXF1
YW50YWwtaXZiNDEtODU6MjAxNDA5MTcyMzU0NTM6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3
MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8zZjE3ZWE2ZGVh
OGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFhM2ZiMWMwL2RtZXNnLXF1YW50YWwtaXZiNDEtODg6
MjAxNDA5MTcyMzU0NTE6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8zZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0
NjI4YTkxYWFhM2ZiMWMwL2RtZXNnLXF1YW50YWwtaXZiNDEtMTc6MjAxNDA5MTcyMzU1MjA6
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0My8zZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFhM2ZiMWMw
L2RtZXNnLXF1YW50YWwtaXZiNDEtNjk6MjAxNDA5MTcyMzU1MjA6aTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8z
ZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFhM2ZiMWMwL2RtZXNnLXF1YW50YWwt
aXZiNDEtODQ6MjAxNDA5MTcyMzU1MjA6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6
CjA6MTg6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDktMTcg
MjM6NTU6MzIgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eC0xL29i
ai1iaXNlY3QvLnJlcGVhdBtbMG0KCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJl
IGJyYW5jaCAnbmV4dCcgKGFjY3VtdWxhdGVkIDMuMTYgbWVyZ2Ugd2luZG93IHBhdGNoZXMp
CmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2Vj
dDogZ2l0IGJpc2VjdCBzdGFydCAzZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFh
M2ZiMWMwIDE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQgLS0KUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgM2YxN2VhNi4uLiBNZXJnZSBicmFuY2ggJ25leHQn
IChhY2N1bXVsYXRlZCAzLjE2IG1lcmdlIHdpbmRvdyBwYXRjaGVzKSBpbnRvIG1hc3RlcgpI
RUFEIGlzIG5vdyBhdCBiNGQzMzE4Li4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J2NyeXB0by9tYXN0ZXInCkJpc2VjdGluZzogMzYzNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCls0OWViN2IwNzUwZDk0ODNjNzRlOWMx
NGFlNmVhMWU5ZDYyNDgxYzNjXSBNZXJnZSB0YWcgJ3R0eS0zLjE2LXJjMScgb2YgZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dyZWdraC90dHkgaW50
byBuZXh0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMS9vYmot
YmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0xL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvbmV4dDpt
YXN0ZXI6NDllYjdiMDc1MGQ5NDgzYzc0ZTljMTRhZTZlYTFlOWQ2MjQ4MWMzYzpiaXNlY3Qt
bGludXgtMQoKMjAxNC0wOS0xNyAyMzo1NzoyMyA0OWViN2IwNzUwZDk0ODNjNzRlOWMxNGFl
NmVhMWU5ZDYyNDgxYzNjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIw
NDMtNDllYjdiMDc1MGQ5NDgzYzc0ZTljMTRhZTZlYTFlOWQ2MjQ4MWMzYwpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My80OWViN2Iw
NzUwZDk0ODNjNzRlOWMxNGFlNmVhMWU5ZDYyNDgxYzNjCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy9pMzg2LXJhbmRjb25m
aWctaWIxLTA5MTcyMDQzLTQ5ZWI3YjA3NTBkOTQ4M2M3NGU5YzE0YWU2ZWExZTlkNjI0ODFj
M2MKG1sxOzM1bTIwMTQtMDktMTggMDA6MDU6MjMgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2ti
dWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My00
OWViN2IwNzUwZDk0ODNjNzRlOWMxNGFlNmVhMWU5ZDYyNDgxYzNjG1swbQpSZXRyeSBidWls
ZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvbGtwLWliMDMtc21va2UvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My00OWViN2Iw
NzUwZDk0ODNjNzRlOWMxNGFlNmVhMWU5ZDYyNDgxYzNjCmtlcm5lbDogL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzQ5ZWI3YjA3NTBkOTQ4M2M3NGU5YzE0YWU2ZWEx
ZTlkNjI0ODFjM2Mvdm1saW51ei0zLjE1LjAtcmM4LTAzNTgzLWc0OWViN2IwCgoyMDE0LTA5
LTE4IDAwOjA3OjIzIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxMC4JMjAgU1VDQ0VT
UwoKQmlzZWN0aW5nOiAyMDYwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSAxMSBzdGVwcykKWzE1YjU4ODMwMzE1NWIyMmVkZDU1OTY3MjkwNWRiOGU1OWE0
NGVmOWFdIE1lcmdlIHRhZyAnZmJkZXYtb21hcC0zLjE2JyBvZiBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9tYmEvbGludXggaW50byBuZXh0CnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9i
b290LWJpc2VjdC9saW51eC0xL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvbmV4dDptYXN0ZXI6MTVi
NTg4MzAzMTU1YjIyZWRkNTU5NjcyOTA1ZGI4ZTU5YTQ0ZWY5YTpiaXNlY3QtbGludXgtMQoK
MjAxNC0wOS0xOCAwMDozODo1NSAxNWI1ODgzMDMxNTViMjJlZGQ1NTk2NzI5MDVkYjhlNTlh
NDRlZjlhIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2xrcC1pYjAzL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtMTViNTg4
MzAzMTU1YjIyZWRkNTU5NjcyOTA1ZGI4ZTU5YTQ0ZWY5YQpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8xNWI1ODgzMDMxNTViMjJl
ZGQ1NTk2NzI5MDVkYjhlNTlhNDRlZjlhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy9pMzg2LXJhbmRjb25maWctaWIxLTA5
MTcyMDQzLTE1YjU4ODMwMzE1NWIyMmVkZDU1OTY3MjkwNWRiOGU1OWE0NGVmOWEKdGltZW91
dApSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My0x
NWI1ODgzMDMxNTViMjJlZGQ1NTk2NzI5MDVkYjhlNTlhNDRlZjlhCnRpbWVvdXQKG1sxOzM1
bTIwMTQtMDktMTggMDY6NDI6NTUgS2VybmVsIGJ1aWxkIGZhaWwgb3IgdGltZW91dBtbMG0K
MjAxNC0wOS0xOCAwNjo0Mjo1NSAxNWI1ODgzMDMxNTViMjJlZGQ1NTk2NzI5MDVkYjhlNTlh
NDRlZjlhIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2Vy
dmVkL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtMTViNTg4MzAzMTU1YjIyZWRkNTU5
NjcyOTA1ZGI4ZTU5YTQ0ZWY5YQpCaXNlY3Rpbmc6IDIwNjAgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbNTM1ZWMyMTRlMjNhZGFmNzJj
Nzc1OTM4ZTllOWM2YzFjZjZmYzViOV0gW21lZGlhXSBtdDlwMDMxOiBGaXggQkxDIGNvbmZp
Z3VyYXRpb24gcmVzdG9yZSB3aGVuIGRpc2FibGluZyB0ZXN0IHBhdHRlcm4KcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4LTEvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9uZXh0Om1hc3Rlcjo1MzVlYzIxNGUy
M2FkYWY3MmM3NzU5MzhlOWU5YzZjMWNmNmZjNWI5OmJpc2VjdC1saW51eC0xCgoyMDE0LTA5
LTE4IDA2OjQzOjAyIDUzNWVjMjE0ZTIzYWRhZjcyYzc3NTkzOGU5ZTljNmMxY2Y2ZmM1Yjkg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My01MzVlYzIxNGUyM2Fk
YWY3MmM3NzU5MzhlOWU5YzZjMWNmNmZjNWI5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzUzNWVjMjE0ZTIzYWRhZjcyYzc3NTkz
OGU5ZTljNmMxY2Y2ZmM1YjkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMt
NTM1ZWMyMTRlMjNhZGFmNzJjNzc1OTM4ZTllOWM2YzFjZjZmYzViOQobWzE7MzVtMjAxNC0w
OS0xOCAwNzowODowMiBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxk
LXNlcnZlZC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTUzNWVjMjE0ZTIzYWRhZjcy
Yzc3NTkzOGU5ZTljNmMxY2Y2ZmM1YjkbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy1zbW9r
ZS9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTUzNWVjMjE0ZTIzYWRhZjcyYzc3NTkz
OGU5ZTljNmMxY2Y2ZmM1YjkKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDkxNzIwNDMvNTM1ZWMyMTRlMjNhZGFmNzJjNzc1OTM4ZTllOWM2YzFjZjZmYzViOS92bWxp
bnV6LTMuMTUuMC1yYzYtMDAxNjUtZzUzNWVjMjEKCjIwMTQtMDktMTggMDc6MTY6MDIgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLiBURVNUIEZBSUxVUkUKWyAgIDExLjA5NjcyOF0gdXNiY29yZTogcmVn
aXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBkdmJfdXNiX3R0dXNiMgpbICAgMTEuMDk4
MjAyXSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91c2Jf
YWY5MDA1ClsgICAxMS4wOTgyMDJdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFj
ZSBkcml2ZXIgZHZiX3VzYl9hZjkwMDUKWyAgIDExLjA5OTU5OF0gQlVHOiB1bmFibGUgdG8g
aGFuZGxlIGtlcm5lbCAKWyAgIDExLjA5OTU5OF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtl
cm5lbCBwYWdpbmcgcmVxdWVzdHBhZ2luZyByZXF1ZXN0IGF0IDA3YzAwMDAwCiBhdCAwN2Mw
MDAwMApbICAgMTEuMTAwNjcwXSBJUDoKWyAgIDExLjEwMDY3MF0gSVA6IFs8ODI3ZDg3YzY+
XSBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZAogWzw4MjdkODdjNj5dIGFmOTAw
NV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkClsgICAxMS4xMDA2NzBdICpwZGUgPSAwMDAw
MDAwMCAKWyAgIDExLjEwMDY3MF0gKnBkZSA9IDAwMDAwMDAwIAoKWyAgIDExLjEwMDY3MF0g
T29wczogMDAwMCBbIzFdIApbICAgMTEuMTAwNjcwXSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1Q
VCBQUkVFTVBUIERFQlVHX1BBR0VBTExPQ0RFQlVHX1BBR0VBTExPQwoKWyAgIDExLjEwMDY3
MF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTUuMC1yYzYt
MDAxNjUtZzUzNWVjMjEgIzIKWyAgIDExLjEwMDY3MF0gQ1BVOiAwIFBJRDogMSBDb21tOiBz
d2FwcGVyIE5vdCB0YWludGVkIDMuMTUuMC1yYzYtMDAxNjUtZzUzNWVjMjEgIzIKWyAgIDEx
LjEwMDY3MF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEv
MjAxMQpbICAgMTEuMTAwNjcwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBC
b2NocyAwMS8wMS8yMDExClsgICAxMS4xMDA2NzBdIHRhc2s6IDhiNDk5NjcwIHRpOiA4YjQ5
YzAwMCB0YXNrLnRpOiA4YjQ5YzAwMApbICAgMTEuMTAwNjcwXSB0YXNrOiA4YjQ5OTY3MCB0
aTogOGI0OWMwMDAgdGFzay50aTogOGI0OWMwMDAKWyAgIDExLjEwMDY3MF0gRUlQOiAwMDYw
Ols8ODI3ZDg3YzY+XSBFRkxBR1M6IDAwMDEwMjA2IENQVTogMApbICAgMTEuMTAwNjcwXSBF
SVA6IDAwNjA6Wzw4MjdkODdjNj5dIEVGTEFHUzogMDAwMTAyMDYgQ1BVOiAwClsgICAxMS4x
MDA2NzBdIEVJUCBpcyBhdCBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZApbICAg
MTEuMTAwNjcwXSBFSVAgaXMgYXQgYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQK
WyAgIDExLjEwMDY3MF0gRUFYOiAwN2MwMDAwMCBFQlg6IDAwMDAwMDAwIEVDWDogMDAwMDAw
MDYgRURYOiAwMDAwMDAwMApbICAgMTEuMTAwNjcwXSBFQVg6IDA3YzAwMDAwIEVCWDogMDAw
MDAwMDAgRUNYOiAwMDAwMDAwNiBFRFg6IDAwMDAwMDAwClsgICAxMS4xMDA2NzBdIEVTSTog
MDAwMDAwMDAgRURJOiA4MjgzNWVjOCBFQlA6IDhiNDlkZjMwIEVTUDogOGI0OWRmMmMKWyAg
IDExLjEwMDY3MF0gRVNJOiAwMDAwMDAwMCBFREk6IDgyODM1ZWM4IEVCUDogOGI0OWRmMzAg
RVNQOiA4YjQ5ZGYyYwpbICAgMTEuMTAwNjcwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAw
MDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDExLjEwMDY3MF0gIERTOiAwMDdiIEVTOiAwMDdi
IEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4ClsgICAxMS4xMDA2NzBdIENSMDogODAwNTAw
M2IgQ1IyOiAwN2MwMDAwMCBDUjM6IDAwMDQ0MDAwIENSNDogMDAwMDA2OTAKWyAgIDExLjEw
MDY3MF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDA3YzAwMDAwIENSMzogMDAwNDQwMDAgQ1I0OiAw
MDAwMDY5MApbICAgMTEuMTAwNjcwXSBTdGFjazoKWyAgIDExLjEwMDY3MF0gU3RhY2s6Clsg
ICAxMS4xMDA2NzBdICA4MjdkODc1YgpbICAgMTEuMTAwNjcwXSAgODI3ZDg3NWIgOGI0OWRm
OTAgOGI0OWRmOTAgODI3OTRhNDkgODI3OTRhNDkgODI1ZDZkYmMgODI1ZDZkYmMgOGI0OWRm
NGMgOGI0OWRmNGMgODBjM2E4MDAgODBjM2E4MDAgODFlOGQ1OGMgODFlOGQ1OGMgOGJmZjY5
NjQgOGJmZjY5NjQKClsgICAxMS4xMDA2NzBdICA4YjQ5ZGY4MApbICAgMTEuMTAwNjcwXSAg
OGI0OWRmODAgODBjM2E5NjYgODBjM2E5NjYgMDAwMDAxOTIgMDAwMDAxOTIgMDAwMDAwMDYg
MDAwMDAwMDYgMDAwMDAwMDYgMDAwMDAwMDYgODI1ZDU0OWMgODI1ZDU0OWMgOGJmZjY5NzYg
OGJmZjY5NzYgMDAwMDAyMDAgMDAwMDAyMDAKClsgICAxMS4xMDA2NzBdICA4MjRiMjU4Ywpb
ICAgMTEuMTAwNjcwXSAgODI0YjI1OGMgOGJmZjY5NzUgOGJmZjY5NzUgMDAwMDAwMDYgMDAw
MDAwMDYgMDAwMDA5YTggMDAwMDA5YTggODI4MzRkYjggODI4MzRkYjggZjA3YTMxYWMgZjA3
YTMxYWMgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDA5YTggMDAwMDA5YTgKClsgICAxMS4xMDA2
NzBdIENhbGwgVHJhY2U6ClsgICAxMS4xMDA2NzBdIENhbGwgVHJhY2U6ClsgICAxMS4xMDA2
NzBdICBbPDgyN2Q4NzViPl0gPyB0dHVzYjJfZHJpdmVyX2luaXQrMHgxNi8weDE2ClsgICAx
MS4xMDA2NzBdICBbPDgyN2Q4NzViPl0gPyB0dHVzYjJfZHJpdmVyX2luaXQrMHgxNi8weDE2
ClsgICAxMS4xMDA2NzBdICBbPDgyNzk0YTQ5Pl0gZG9fb25lX2luaXRjYWxsKzB4NzcvMHgx
MDYKWyAgIDExLjEwMDY3MF0gIFs8ODI3OTRhNDk+XSBkb19vbmVfaW5pdGNhbGwrMHg3Ny8w
eDEwNgpbICAgMTEuMTAwNjcwXSAgWzw4MGMzYTgwMD5dID8gcGFyYW1lcW4rMHgyLzB4MzUK
WyAgIDExLjEwMDY3MF0gIFs8ODBjM2E4MDA+XSA/IHBhcmFtZXFuKzB4Mi8weDM1ClsgICAx
MS4xMDA2NzBdICBbPDgwYzNhOTY2Pl0gPyBwYXJzZV9hcmdzKzB4MTEzLzB4MjVjClsgICAx
MS4xMDA2NzBdICBbPDgwYzNhOTY2Pl0gPyBwYXJzZV9hcmdzKzB4MTEzLzB4MjVjClsgICAx
MS4xMDA2NzBdICBbPDgyNzk0YmMyPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhlYS8weDE2
NwpbICAgMTEuMTAwNjcwXSAgWzw4Mjc5NGJjMj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4
ZWEvMHgxNjcKWyAgIDExLjEwMDY3MF0gIFs8ODFkMDFjZWM+XSBrZXJuZWxfaW5pdCsweDgv
MHhiOApbICAgMTEuMTAwNjcwXSAgWzw4MWQwMWNlYz5dIGtlcm5lbF9pbml0KzB4OC8weGI4
ClsgICAxMS4xMDA2NzBdICBbPDgxZDI4YjQwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsw
eDIwLzB4MzAKWyAgIDExLjEwMDY3MF0gIFs8ODFkMjhiNDA+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MjAvMHgzMApbICAgMTEuMTAwNjcwXSAgWzw4MWQwMWNlND5dID8gcmVzdF9p
bml0KzB4MTBjLzB4MTBjClsgICAxMS4xMDA2NzBdICBbPDgxZDAxY2U0Pl0gPyByZXN0X2lu
aXQrMHgxMGMvMHgxMGMKWyAgIDExLjEwMDY3MF0gQ29kZToKWyAgIDExLjEwMDY3MF0gQ29k
ZTogMDggMDggYzIgYzIgYzcgYzcgMDUgMDUgNDQgNDQgMGQgMGQgZGEgZGEgODIgODIgMDAg
MDAgMDAgMDAgYzAgYzAgMDcgMDcgYzcgYzcgMDUgMDUgNDAgNDAgMGQgMGQgZGEgZGEgODIg
ODIgMDAgMDAgMDAgMDAgYzAgYzAgMDcgMDcgYzcgYzcgMDUgMDUgM2MgM2MgMGQgMGQgZGEg
ZGEgODIgODIgMDAgMDAgMDAgMDAgYzAgYzAgMDcgMDcgNzUgNzUgMWYgMWYgYjggYjggMDAg
MDAgMDAgMDAgYzAgYzAgMDcgMDcgODUgODUgYzAgYzAgNzQgNzQgMTYgMTYgPGExPiA8YTE+
IDAwIDAwIDAwIDAwIGMwIGMwIDA3IDA3IGM3IGM3IDA1IDA1IDU0IDU0IGE1IGE1IDZlIDZl
IDgyIDgyIDAwIDAwIDAwIDAwIGMwIGMwIDA3IDA3IGEzIGEzIDU4IDU4IGE1IGE1IDZlIDZl
IDgyIDgyIGViIGViCgpbICAgMTEuMTAwNjcwXSBFSVA6IFs8ODI3ZDg3YzY+XSAKWyAgIDEx
LjEwMDY3MF0gRUlQOiBbPDgyN2Q4N2M2Pl0gYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZi
LzB4OWRhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZCBTUzpFU1AgMDA2ODo4YjQ5
ZGYyYwogU1M6RVNQIDAwNjg6OGI0OWRmMmMKWyAgIDExLjEwMDY3MF0gQ1IyOiAwMDAwMDAw
MDA3YzAwMDAwClsgICAxMS4xMDA2NzBdIENSMjogMDAwMDAwMDAwN2MwMDAwMApbICAgMTEu
MTAwNjcwXSAtLS1bIGVuZCB0cmFjZSA3M2EwYjczMjc1NWY2OTBhIF0tLS0KWyAgIDExLjEw
MDY3MF0gLS0tWyBlbmQgdHJhY2UgNzNhMGI3MzI3NTVmNjkwYSBdLS0tCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My81MzVlYzIxNGUyM2FkYWY3MmM3NzU5MzhlOWU5
YzZjMWNmNmZjNWI5L2RtZXNnLXlvY3RvLXZwLTE1OjIwMTQwOTE4MDc0MDE0OmkzODYtcmFu
ZGNvbmZpZy1pYjEtMDkxNzIwNDM6My4xNS4wLXJjNi0wMDE2NS1nNTM1ZWMyMToyCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My81MzVlYzIxNGUyM2FkYWY3MmM3NzU5
MzhlOWU5YzZjMWNmNmZjNWI5L2RtZXNnLXlvY3RvLXZwLTE6MjAxNDA5MTgwNzQwMTQ6aTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0MzozLjE1LjAtcmM2LTAwMTY1LWc1MzVlYzIxOjIK
MDoyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDktMTggMDc6
NDA6MzggUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eC0xL29iai1i
aXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogODIgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpCls3ZjI4MTZlNTFlYTE0ZDA3YmY1NmZk
NTU3YmRjZGJiZGIwMjAzZGJjXSBbbWVkaWFdIHM1cC1maW1jOiBDaGFuZ2VkIFJHQjMyIHRv
IEJHUjMyCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0xL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvbmV4dDpt
YXN0ZXI6N2YyODE2ZTUxZWExNGQwN2JmNTZmZDU1N2JkY2RiYmRiMDIwM2RiYzpiaXNlY3Qt
bGludXgtMQoKMjAxNC0wOS0xOCAwNzo0MDo0MiA3ZjI4MTZlNTFlYTE0ZDA3YmY1NmZkNTU3
YmRjZGJiZGIwMjAzZGJjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIw
NDMtN2YyODE2ZTUxZWExNGQwN2JmNTZmZDU1N2JkY2RiYmRiMDIwM2RiYwpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My83ZjI4MTZl
NTFlYTE0ZDA3YmY1NmZkNTU3YmRjZGJiZGIwMjAzZGJjCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy9pMzg2LXJhbmRjb25m
aWctaWIxLTA5MTcyMDQzLTdmMjgxNmU1MWVhMTRkMDdiZjU2ZmQ1NTdiZGNkYmJkYjAyMDNk
YmMKG1sxOzM1bTIwMTQtMDktMTggMDc6NDM6NDIgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2ti
dWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My03
ZjI4MTZlNTFlYTE0ZDA3YmY1NmZkNTU3YmRjZGJiZGIwMjAzZGJjG1swbQpSZXRyeSBidWls
ZCAuLgpzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yChtbMTszNW0yMDE0LTA5LTE4IDA3OjQ0
OjQyIEtlcm5lbCBidWlsZCBmYWlsIG9yIHRpbWVvdXQbWzBtCjIwMTQtMDktMTggMDc6NDQ6
NDIgN2YyODE2ZTUxZWExNGQwN2JmNTZmZDU1N2JkY2RiYmRiMDIwM2RiYyBTS0lQIEJST0tF
TiBCVUlMRApDaGVjayAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25m
aWctaWIxLTA5MTcyMDQzLTdmMjgxNmU1MWVhMTRkMDdiZjU2ZmQ1NTdiZGNkYmJkYjAyMDNk
YmMKQmlzZWN0aW5nOiA4MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgNiBzdGVwcykKWzc0YTg2MjcyZjA1YzNkYWU0MGYyZDdiMTdmZjA5YTA2MDhjZjMz
MDRdIFttZWRpYV0gcnRsMjh4eHU6IGFkZCBbMWI4MDpkM2FmXSBTdmVvbiBTVFYyNwpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXgtMS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzL25leHQ6bWFzdGVyOjc0YTg2
MjcyZjA1YzNkYWU0MGYyZDdiMTdmZjA5YTA2MDhjZjMzMDQ6YmlzZWN0LWxpbnV4LTEKCjIw
MTQtMDktMTggMDc6NDQ6NDUgNzRhODYyNzJmMDVjM2RhZTQwZjJkN2IxN2ZmMDlhMDYwOGNm
MzMwNCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9sa3AtaWIwMy9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTc0YTg2Mjcy
ZjA1YzNkYWU0MGYyZDdiMTdmZjA5YTA2MDhjZjMzMDQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNzRhODYyNzJmMDVjM2RhZTQw
ZjJkN2IxN2ZmMDlhMDYwOGNmMzMwNAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3
MjA0My03NGE4NjI3MmYwNWMzZGFlNDBmMmQ3YjE3ZmYwOWEwNjA4Y2YzMzA0ChtbMTszNW0y
MDE0LTA5LTE4IDA3OjQ3OjQ1IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMv
YnVpbGQtc2VydmVkL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtNzRhODYyNzJmMDVj
M2RhZTQwZjJkN2IxN2ZmMDlhMDYwOGNmMzMwNBtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAz
LXNtb2tlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtNzRhODYyNzJmMDVjM2RhZTQw
ZjJkN2IxN2ZmMDlhMDYwOGNmMzMwNApzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yChtbMTsz
NW0yMDE0LTA5LTE4IDA3OjQ5OjQ1IEtlcm5lbCBidWlsZCBmYWlsIG9yIHRpbWVvdXQbWzBt
CjIwMTQtMDktMTggMDc6NDk6NDUgNzRhODYyNzJmMDVjM2RhZTQwZjJkN2IxN2ZmMDlhMDYw
OGNmMzMwNCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayAva2J1aWxkLXRlc3RzL2J1aWxkLXNl
cnZlZC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTc0YTg2MjcyZjA1YzNkYWU0MGYy
ZDdiMTdmZjA5YTA2MDhjZjMzMDQKQmlzZWN0aW5nOiA4MiByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzJjNTJhMmZjZTBmMDA0Nzk1NDhh
MDc2ZDkwMGQxYTJkZGQwMDFjMjddIFttZWRpYV0gZW0yOHh4OiBtb3ZlIHN0cnVjdCB2NGwy
X2NsayAqY2xrIGZyb20gc3RydWN0IGVtMjh4eCB0byBzdHJ1Y3QgdjRsMgpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXgtMS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzL25leHQ6bWFzdGVyOjJjNTJhMmZjZTBm
MDA0Nzk1NDhhMDc2ZDkwMGQxYTJkZGQwMDFjMjc6YmlzZWN0LWxpbnV4LTEKCjIwMTQtMDkt
MTggMDc6NDk6NDYgMmM1MmEyZmNlMGYwMDQ3OTU0OGEwNzZkOTAwZDFhMmRkZDAwMWMyNyBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9sa3AtaWIwMy9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTJjNTJhMmZjZTBmMDA0
Nzk1NDhhMDc2ZDkwMGQxYTJkZGQwMDFjMjcKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvMmM1MmEyZmNlMGYwMDQ3OTU0OGEwNzZk
OTAwZDFhMmRkZDAwMWMyNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My0y
YzUyYTJmY2UwZjAwNDc5NTQ4YTA3NmQ5MDBkMWEyZGRkMDAxYzI3ChtbMTszNW0yMDE0LTA5
LTE4IDA3OjUxOjQ2IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQt
c2VydmVkL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtMmM1MmEyZmNlMGYwMDQ3OTU0
OGEwNzZkOTAwZDFhMmRkZDAwMWMyNxtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzLXNtb2tl
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtMmM1MmEyZmNlMGYwMDQ3OTU0OGEwNzZk
OTAwZDFhMmRkZDAwMWMyNwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0My8yYzUyYTJmY2UwZjAwNDc5NTQ4YTA3NmQ5MDBkMWEyZGRkMDAxYzI3L3ZtbGlu
dXotMy4xNS4wLXJjNi0wMDEzNy1nMmM1MmEyZgoKMjAxNC0wOS0xOCAwNzo1Mzo0NiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
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
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLgkyLi4uLi4uCTUJMTUuLi4uLi4uLi4uLi4uLi4uLgkxOC4u
Li4uLi4uLi4uLi4uLi4uLi4uLgkxOS4uLi4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTMg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpClth
NWMwNzVjZmQyMzg2YTRmM2FiNGY4ZWQyODMwZWJlZTU1N2Q0YjNmXSBbbWVkaWFdIGVtMjh4
eDogbW92ZSBmaWVsZHMgd3FfdHJpZ2dlciBhbmQgc3RyZWFtaW5nX3N0YXJ0ZWQgZnJvbSBz
dHJ1Y3QgZW0yOHh4IHRvIHN0cnVjdCBlbTI4eHhfYXVkaW8KcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
LTEvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0My9uZXh0Om1hc3RlcjphNWMwNzVjZmQyMzg2YTRmM2Fi
NGY4ZWQyODMwZWJlZTU1N2Q0YjNmOmJpc2VjdC1saW51eC0xCgoyMDE0LTA5LTE4IDIxOjAx
OjMyIGE1YzA3NWNmZDIzODZhNGYzYWI0ZjhlZDI4MzBlYmVlNTU3ZDRiM2YgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWli
MDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My1hNWMwNzVjZmQyMzg2YTRmM2FiNGY4
ZWQyODMwZWJlZTU1N2Q0YjNmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaWIxLTA5MTcyMDQzL2E1YzA3NWNmZDIzODZhNGYzYWI0ZjhlZDI4MzBlYmVl
NTU3ZDRiM2YKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2xrcC1pYjAzL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtYTVjMDc1Y2Zk
MjM4NmE0ZjNhYjRmOGVkMjgzMGViZWU1NTdkNGIzZgobWzE7MzVtMjAxNC0wOS0xOCAyMToy
MTozMiBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC9p
Mzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLWE1YzA3NWNmZDIzODZhNGYzYWI0ZjhlZDI4
MzBlYmVlNTU3ZDRiM2YbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy1zbW9rZS9pMzg2LXJh
bmRjb25maWctaWIxLTA5MTcyMDQzLWE1YzA3NWNmZDIzODZhNGYzYWI0ZjhlZDI4MzBlYmVl
NTU3ZDRiM2YKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMv
YTVjMDc1Y2ZkMjM4NmE0ZjNhYjRmOGVkMjgzMGViZWU1NTdkNGIzZi92bWxpbnV6LTMuMTUu
MC1yYzYtMDAxNTEtZ2E1YzA3NWMKCjIwMTQtMDktMTggMjE6MjQ6MzIgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLiBURVNUIEZBSUxVUkUK
WyAgICA5LjQwMTg5NV0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZl
ciBkdmJfdXNiX3R0dXNiMgpbICAgIDkuNDAzMzgwXSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5l
dyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91c2JfYWY5MDA1ClsgICAgOS40MDMzODBdIHVzYmNv
cmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgZHZiX3VzYl9hZjkwMDUKWyAg
ICA5LjQxNTM4M10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCAKWyAgICA5LjQxNTM4
M10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdHBhZ2luZyBy
ZXF1ZXN0IGF0IDA3YzAwMDAwCiBhdCAwN2MwMDAwMApbICAgIDkuNDE3MTI2XSBJUDoKWyAg
ICA5LjQxNzEyNl0gSVA6IFs8ODI3ZDY3YzY+XSBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4
NmIvMHg5ZAogWzw4MjdkNjdjNj5dIGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlk
ClsgICAgOS40MTg3NzFdICpwZGUgPSAwMDAwMDAwMCAKWyAgICA5LjQxODc3MV0gKnBkZSA9
IDAwMDAwMDAwIAoKWyAgICA5LjQxOTY3Ml0gT29wczogMDAwMCBbIzFdIApbICAgIDkuNDE5
NjcyXSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCBQUkVFTVBUIERFQlVHX1BBR0VBTExPQ0RF
QlVHX1BBR0VBTExPQwoKWyAgICA5LjQyMTEyNl0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2Fw
cGVyIE5vdCB0YWludGVkIDMuMTUuMC1yYzYtMDAxNTEtZ2E1YzA3NWMgIzEKWyAgICA5LjQy
MTEyNl0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTUuMC1y
YzYtMDAxNTEtZ2E1YzA3NWMgIzEKWyAgICA5LjQyNTM3MF0gSGFyZHdhcmUgbmFtZTogUUVN
VSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS43LjUtMjAxNDA1
MzFfMDgzMDMwLWdhbmRhbGYgMDQvMDEvMjAxNApbICAgIDkuNDI1MzcwXSBIYXJkd2FyZSBu
YW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyAxLjcu
NS0yMDE0MDUzMV8wODMwMzAtZ2FuZGFsZiAwNC8wMS8yMDE0ClsgICAgOS40MjUzNzBdIHRh
c2s6IDg5YzlhNjcwIHRpOiA4OWM5YzAwMCB0YXNrLnRpOiA4OWM5YzAwMApbICAgIDkuNDI1
MzcwXSB0YXNrOiA4OWM5YTY3MCB0aTogODljOWMwMDAgdGFzay50aTogODljOWMwMDAKWyAg
ICA5LjQyNTM3MF0gRUlQOiAwMDYwOls8ODI3ZDY3YzY+XSBFRkxBR1M6IDAwMDEwMjA2IENQ
VTogMApbICAgIDkuNDI1MzcwXSBFSVA6IDAwNjA6Wzw4MjdkNjdjNj5dIEVGTEFHUzogMDAw
MTAyMDYgQ1BVOiAwClsgICAgOS40MjUzNzBdIEVJUCBpcyBhdCBhZjkwMDVfdXNiX21vZHVs
ZV9pbml0KzB4NmIvMHg5ZApbICAgIDkuNDI1MzcwXSBFSVAgaXMgYXQgYWY5MDA1X3VzYl9t
b2R1bGVfaW5pdCsweDZiLzB4OWQKWyAgICA5LjQyNTM3MF0gRUFYOiAwN2MwMDAwMCBFQlg6
IDAwMDAwMDAwIEVDWDogMDAwMDAwMDYgRURYOiAwMDAwMDAwMApbICAgIDkuNDI1MzcwXSBF
QVg6IDA3YzAwMDAwIEVCWDogMDAwMDAwMDAgRUNYOiAwMDAwMDAwNiBFRFg6IDAwMDAwMDAw
ClsgICAgOS40MjUzNzBdIEVTSTogMDAwMDAwMDAgRURJOiA4MjgzM2VjOCBFQlA6IDg5Yzlk
ZjMwIEVTUDogODljOWRmMmMKWyAgICA5LjQyNTM3MF0gRVNJOiAwMDAwMDAwMCBFREk6IDgy
ODMzZWM4IEVCUDogODljOWRmMzAgRVNQOiA4OWM5ZGYyYwpbICAgIDkuNDI1MzcwXSAgRFM6
IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgICA5LjQyNTM3
MF0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4ClsgICAg
OS40MjUzNzBdIENSMDogODAwNTAwM2IgQ1IyOiAwN2MwMDAwMCBDUjM6IDBhODU0MDAwIENS
NDogMDAwMDA2OTAKWyAgICA5LjQyNTM3MF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDA3YzAwMDAw
IENSMzogMGE4NTQwMDAgQ1I0OiAwMDAwMDY5MApbICAgIDkuNDI1MzcwXSBTdGFjazoKWyAg
ICA5LjQyNTM3MF0gU3RhY2s6ClsgICAgOS40MjUzNzBdICA4MjdkNjc1YgpbICAgIDkuNDI1
MzcwXSAgODI3ZDY3NWIgODljOWRmOTAgODljOWRmOTAgODI3OTJhNDkgODI3OTJhNDkgODI1
ZDU5MTQgODI1ZDU5MTQgODljOWRmNGMgODljOWRmNGMgODBjM2E4MDAgODBjM2E4MDAgODFl
OGM1OGMgODFlOGM1OGMgOGE0YzM5NjggOGE0YzM5NjgKClsgICAgOS40MjUzNzBdICA4OWM5
ZGY4MApbICAgIDkuNDI1MzcwXSAgODljOWRmODAgODBjM2E5NjYgODBjM2E5NjYgMDAwMDAx
OTIgMDAwMDAxOTIgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDAwMDYgODI1ZDNm
ZjQgODI1ZDNmZjQgOGE0YzM5N2EgOGE0YzM5N2EgMDAwMDAyMDAgMDAwMDAyMDAKClsgICAg
OS40MjUzNzBdICA4MjRiMTI4MApbICAgIDkuNDI1MzcwXSAgODI0YjEyODAgOGE0YzM5Nzkg
OGE0YzM5NzkgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDA5YTYgMDAwMDA5YTYgODI4MzJkYjgg
ODI4MzJkYjggODhjZmM1N2UgODhjZmM1N2UgMDAwMDAwMDYgMDAwMDAwMDYgMDAwMDA5YTYg
MDAwMDA5YTYKClsgICAgOS40MjUzNzBdIENhbGwgVHJhY2U6ClsgICAgOS40MjUzNzBdIENh
bGwgVHJhY2U6ClsgICAgOS40MjUzNzBdICBbPDgyN2Q2NzViPl0gPyB0dHVzYjJfZHJpdmVy
X2luaXQrMHgxNi8weDE2ClsgICAgOS40MjUzNzBdICBbPDgyN2Q2NzViPl0gPyB0dHVzYjJf
ZHJpdmVyX2luaXQrMHgxNi8weDE2ClsgICAgOS40MjUzNzBdICBbPDgyNzkyYTQ5Pl0gZG9f
b25lX2luaXRjYWxsKzB4NzcvMHgxMDYKWyAgICA5LjQyNTM3MF0gIFs8ODI3OTJhNDk+XSBk
b19vbmVfaW5pdGNhbGwrMHg3Ny8weDEwNgpbICAgIDkuNDI1MzcwXSAgWzw4MGMzYTgwMD5d
ID8gcGFyYW1lcW4rMHgyLzB4MzUKWyAgICA5LjQyNTM3MF0gIFs8ODBjM2E4MDA+XSA/IHBh
cmFtZXFuKzB4Mi8weDM1ClsgICAgOS40MjUzNzBdICBbPDgwYzNhOTY2Pl0gPyBwYXJzZV9h
cmdzKzB4MTEzLzB4MjVjClsgICAgOS40MjUzNzBdICBbPDgwYzNhOTY2Pl0gPyBwYXJzZV9h
cmdzKzB4MTEzLzB4MjVjClsgICAgOS40MjUzNzBdICBbPDgyNzkyYmMyPl0ga2VybmVsX2lu
aXRfZnJlZWFibGUrMHhlYS8weDE2NwpbICAgIDkuNDI1MzcwXSAgWzw4Mjc5MmJjMj5dIGtl
cm5lbF9pbml0X2ZyZWVhYmxlKzB4ZWEvMHgxNjcKWyAgICA5LjQyNTM3MF0gIFs8ODFkMDEw
NzA+XSBrZXJuZWxfaW5pdCsweDgvMHhiOApbICAgIDkuNDI1MzcwXSAgWzw4MWQwMTA3MD5d
IGtlcm5lbF9pbml0KzB4OC8weGI4ClsgICAgOS40MjUzNzBdICBbPDgxZDI3ZWMwPl0gcmV0
X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAKWyAgICA5LjQyNTM3MF0gIFs8ODFkMjdl
YzA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgIDkuNDI1MzcwXSAg
Wzw4MWQwMTA2OD5dID8gcmVzdF9pbml0KzB4MTBjLzB4MTBjClsgICAgOS40MjUzNzBdICBb
PDgxZDAxMDY4Pl0gPyByZXN0X2luaXQrMHgxMGMvMHgxMGMKWyAgICA5LjQyNTM3MF0gQ29k
ZToKWyAgICA5LjQyNTM3MF0gQ29kZTogMDggMDggYzIgYzIgYzcgYzcgMDUgMDUgNDQgNDQg
ZWQgZWQgZDkgZDkgODIgODIgMDAgMDAgMDAgMDAgYzAgYzAgMDcgMDcgYzcgYzcgMDUgMDUg
NDAgNDAgZWQgZWQgZDkgZDkgODIgODIgMDAgMDAgMDAgMDAgYzAgYzAgMDcgMDcgYzcgYzcg
MDUgMDUgM2MgM2MgZWQgZWQgZDkgZDkgODIgODIgMDAgMDAgMDAgMDAgYzAgYzAgMDcgMDcg
NzUgNzUgMWYgMWYgYjggYjggMDAgMDAgMDAgMDAgYzAgYzAgMDcgMDcgODUgODUgYzAgYzAg
NzQgNzQgMTYgMTYgPGExPiA8YTE+IDAwIDAwIDAwIDAwIGMwIGMwIDA3IDA3IGM3IGM3IDA1
IDA1IDU0IDU0IDg0IDg0IDZlIDZlIDgyIDgyIDAwIDAwIDAwIDAwIGMwIGMwIDA3IDA3IGEz
IGEzIDU4IDU4IDg0IDg0IDZlIDZlIDgyIDgyIGViIGViCgpbICAgIDkuNDI1MzcwXSBFSVA6
IFs8ODI3ZDY3YzY+XSAKWyAgICA5LjQyNTM3MF0gRUlQOiBbPDgyN2Q2N2M2Pl0gYWY5MDA1
X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWRhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIv
MHg5ZCBTUzpFU1AgMDA2ODo4OWM5ZGYyYwogU1M6RVNQIDAwNjg6ODljOWRmMmMKWyAgICA5
LjQyNTM3MF0gQ1IyOiAwMDAwMDAwMDA3YzAwMDAwClsgICAgOS40MjUzNzBdIENSMjogMDAw
MDAwMDAwN2MwMDAwMApbICAgIDkuNDI1MzcwXSAtLS1bIGVuZCB0cmFjZSA4ZGU4NDUyMjQw
YmZmMzlmIF0tLS0KWyAgICA5LjQyNTM3MF0gLS0tWyBlbmQgdHJhY2UgOGRlODQ1MjI0MGJm
ZjM5ZiBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9hNWMwNzVj
ZmQyMzg2YTRmM2FiNGY4ZWQyODMwZWJlZTU1N2Q0YjNmL2RtZXNnLXF1YW50YWwtaXZiNDEt
MjA6MjAxNDA5MTgyMjA3MDE6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9hNWMwNzVjZmQyMzg2YTRmM2FiNGY4
ZWQyODMwZWJlZTU1N2Q0YjNmL2RtZXNnLXF1YW50YWwtaXZiNDEtMzM6MjAxNDA5MTgyMjA3
MDQ6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wOTE3MjA0My9hNWMwNzVjZmQyMzg2YTRmM2FiNGY4ZWQyODMwZWJlZTU1N2Q0
YjNmL2RtZXNnLXF1YW50YWwtaXZiNDEtNzY6MjAxNDA5MTgyMjA2NTk6aTM4Ni1yYW5kY29u
ZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0
My9hNWMwNzVjZmQyMzg2YTRmM2FiNGY4ZWQyODMwZWJlZTU1N2Q0YjNmL2RtZXNnLXF1YW50
YWwtaXZiNDEtOTM6MjAxNDA5MTgyMjA3MDI6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0
Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9hNWMwNzVjZmQyMzg2
YTRmM2FiNGY4ZWQyODMwZWJlZTU1N2Q0YjNmL2RtZXNnLXlvY3RvLWl2YjQxLTQ2OjIwMTQw
OTE4MjIwNjU5OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvYTVjMDc1Y2ZkMjM4NmE0ZjNhYjRmOGVkMjgzMGVi
ZWU1NTdkNGIzZi9kbWVzZy15b2N0by12cC02MzoyMDE0MDkxODIyMDcwNDppMzg2LXJhbmRj
b25maWctaWIxLTA5MTcyMDQzOjMuMTUuMC1yYzYtMDAxNTEtZ2E1YzA3NWM6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvYTVjMDc1Y2ZkMjM4NmE0ZjNhYjRmOGVk
MjgzMGViZWU1NTdkNGIzZi9kbWVzZy15b2N0by1pdmI0MS0xMDI6MjAxNDA5MTgyMjA3MDY6
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0My9hNWMwNzVjZmQyMzg2YTRmM2FiNGY4ZWQyODMwZWJlZTU1N2Q0YjNm
L2RtZXNnLXlvY3RvLWl2YjQxLTU1OjIwMTQwOTE4MjIwNzA2OmkzODYtcmFuZGNvbmZpZy1p
YjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvYTVj
MDc1Y2ZkMjM4NmE0ZjNhYjRmOGVkMjgzMGViZWU1NTdkNGIzZi9kbWVzZy15b2N0by1pdmI0
MS05MzoyMDE0MDkxODIyMDcwNjppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKMDo5
OjkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDktMTggMjI6MDc6
MjMgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eC0xL29iai1iaXNl
Y3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzU4MTU5MTcxYzdmMjAxZTVkNmVhMjY2NmM3
YjM4NTdlNzgyYTI4NjFdIFttZWRpYV0gZW0yOHh4OiBtb3ZlIHByb2dyZXNzaXZlL2ludGVy
bGFjZWQgZmllbGRzIGZyb20gc3RydWN0IGVtMjh4eCB0byBzdHJ1Y3QgdjRsMgpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1i
aXNlY3QvbGludXgtMS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzL25leHQ6bWFzdGVyOjU4MTU5MTcx
YzdmMjAxZTVkNmVhMjY2NmM3YjM4NTdlNzgyYTI4NjE6YmlzZWN0LWxpbnV4LTEKCjIwMTQt
MDktMTggMjI6MDc6MzQgNTgxNTkxNzFjN2YyMDFlNWQ2ZWEyNjY2YzdiMzg1N2U3ODJhMjg2
MSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9sa3AtaWIwMy9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTU4MTU5MTcxYzdm
MjAxZTVkNmVhMjY2NmM3YjM4NTdlNzgyYTI4NjEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNTgxNTkxNzFjN2YyMDFlNWQ2ZWEy
NjY2YzdiMzg1N2U3ODJhMjg2MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0
My01ODE1OTE3MWM3ZjIwMWU1ZDZlYTI2NjZjN2IzODU3ZTc4MmEyODYxChtbMTszNW0yMDE0
LTA5LTE4IDIyOjE4OjM0IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVp
bGQtc2VydmVkL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtNTgxNTkxNzFjN2YyMDFl
NWQ2ZWEyNjY2YzdiMzg1N2U3ODJhMjg2MRtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzLXNt
b2tlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtNTgxNTkxNzFjN2YyMDFlNWQ2ZWEy
NjY2YzdiMzg1N2U3ODJhMjg2MQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0My81ODE1OTE3MWM3ZjIwMWU1ZDZlYTI2NjZjN2IzODU3ZTc4MmEyODYxL3Zt
bGludXotMy4xNS4wLXJjNi0wMDE0NC1nNTgxNTkxNwoKMjAxNC0wOS0xOCAyMjoyMTozNCBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyIHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbMzg1
NGIwZDg0N2Q1NThiZGM4MjBiOTNhZThhOTNjMDkyM2QwMjExZF0gW21lZGlhXSBlbTI4eHg6
IG1vdmUgdHVuZXIgZnJlcXVlbmN5IGZpZWxkIGZyb20gc3RydWN0IGVtMjh4eCB0byBzdHJ1
Y3QgdjRsMgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzL25leHQ6
bWFzdGVyOjM4NTRiMGQ4NDdkNTU4YmRjODIwYjkzYWU4YTkzYzA5MjNkMDIxMWQ6YmlzZWN0
LWxpbnV4LTEKCjIwMTQtMDktMTggMjI6NTI6MjkgMzg1NGIwZDg0N2Q1NThiZGM4MjBiOTNh
ZThhOTNjMDkyM2QwMjExZCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcy
MDQzLTM4NTRiMGQ4NDdkNTU4YmRjODIwYjkzYWU4YTkzYzA5MjNkMDIxMWQKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvMzg1NGIw
ZDg0N2Q1NThiZGM4MjBiOTNhZThhOTNjMDkyM2QwMjExZAp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wOTE3MjA0My0zODU0YjBkODQ3ZDU1OGJkYzgyMGI5M2FlOGE5M2MwOTIzZDAy
MTFkChtbMTszNW0yMDE0LTA5LTE4IDIyOjU1OjMwIE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9r
YnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMt
Mzg1NGIwZDg0N2Q1NThiZGM4MjBiOTNhZThhOTNjMDkyM2QwMjExZBtbMG0KUmV0cnkgYnVp
bGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2xrcC1pYjAzLXNtb2tlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtMzg1NGIw
ZDg0N2Q1NThiZGM4MjBiOTNhZThhOTNjMDkyM2QwMjExZAprZXJuZWw6IC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8zODU0YjBkODQ3ZDU1OGJkYzgyMGI5M2FlOGE5
M2MwOTIzZDAyMTFkL3ZtbGludXotMy4xNS4wLXJjNi0wMDE0OC1nMzg1NGIwZAoKMjAxNC0w
OS0xOCAyMzowMTozMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMS4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkyMCBTVUNDRVNTCgpC
aXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDEgc3RlcCkKWzMzMTllNmY4MzljZjk0ZTMzZmJhZDI3YTIxZmM0YzY0ZjZjZWM3NGZdIFtt
ZWRpYV0gZW0yOHh4OiByZW1vdmUgZmllbGQgdHVuZXJfYWRkciBmcm9tIHN0cnVjdCBlbTI4
eHgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTEvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9uZXh0Om1hc3Rl
cjozMzE5ZTZmODM5Y2Y5NGUzM2ZiYWQyN2EyMWZjNGM2NGY2Y2VjNzRmOmJpc2VjdC1saW51
eC0xCgoyMDE0LTA5LTE4IDIzOjMxOjM5IDMzMTllNmY4MzljZjk0ZTMzZmJhZDI3YTIxZmM0
YzY0ZjZjZWM3NGYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My0z
MzE5ZTZmODM5Y2Y5NGUzM2ZiYWQyN2EyMWZjNGM2NGY2Y2VjNzRmCkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzMzMTllNmY4Mzlj
Zjk0ZTMzZmJhZDI3YTIxZmM0YzY0ZjZjZWM3NGYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzLXNtb2tlL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDkxNzIwNDMtMzMxOWU2ZjgzOWNmOTRlMzNmYmFkMjdhMjFmYzRjNjRmNmNl
Yzc0ZgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My8zMzE5
ZTZmODM5Y2Y5NGUzM2ZiYWQyN2EyMWZjNGM2NGY2Y2VjNzRmL3ZtbGludXotMy4xNS4wLXJj
Ni0wMDE1MC1nMzMxOWU2ZgoKMjAxNC0wOS0xOCAyMzozNTo0MCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLgkyLgk1CTE5CTIwIFNVQ0NFU1MKCmE1YzA3NWNmZDIz
ODZhNGYzYWI0ZjhlZDI4MzBlYmVlNTU3ZDRiM2YgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQK
Y29tbWl0IGE1YzA3NWNmZDIzODZhNGYzYWI0ZjhlZDI4MzBlYmVlNTU3ZDRiM2YKQXV0aG9y
OiBGcmFuayBTY2hhZWZlciA8ZnNjaGFlZmVyLm9zc0Bnb29nbGVtYWlsLmNvbT4KRGF0ZTog
ICBNb24gTWFyIDI0IDE2OjMzOjI1IDIwMTQgLTAzMDAKCiAgICBbbWVkaWFdIGVtMjh4eDog
bW92ZSBmaWVsZHMgd3FfdHJpZ2dlciBhbmQgc3RyZWFtaW5nX3N0YXJ0ZWQgZnJvbSBzdHJ1
Y3QgZW0yOHh4IHRvIHN0cnVjdCBlbTI4eHhfYXVkaW8KICAgIAogICAgQm90aCB3cV90cmln
Z2VyIGFuZCBzdHJlYW1fc3RhcnRlZCBhcmUgdXNlZCBvbmx5IHRvIGNvbnRyb2wgdGhlIGVt
Mjh4eAogICAgYWxzYSBzdHJlYW1pbmcuIFRoZXkgZG9uJ3QgYmVsb25nIHRvIGVtMjh4eCBj
b21tb24gc3RydWN0LgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBGcmFuayBTY2jDpGZlciA8
ZnNjaGFlZmVyLm9zc0Bnb29nbGVtYWlsLmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6IEhhbnMg
VmVya3VpbCA8aGFucy52ZXJrdWlsQGNpc2NvLmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6IE1h
dXJvIENhcnZhbGhvIENoZWhhYiA8bS5jaGVoYWJAc2Ftc3VuZy5jb20+Cgo6MDQwMDAwIDA0
MDAwMCBlNWE1NDBkOWM1NGUyZjRlOGRhZTc4YWI2NzJmNTM2NmUxOTdiNjk1IDFkNTFlNmJm
MzVkNzFkMjgwYjYyMWI5NjM5YjAyYTJlMDM4NTNlZmIgTQlkcml2ZXJzCmJpc2VjdCBydW4g
c3VjY2VzcwpIRUFEIGlzIG5vdyBhdCAzMzE5ZTZmLi4uIFttZWRpYV0gZW0yOHh4OiByZW1v
dmUgZmllbGQgdHVuZXJfYWRkciBmcm9tIHN0cnVjdCBlbTI4eHgKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvbmV4dDpt
YXN0ZXI6MzMxOWU2ZjgzOWNmOTRlMzNmYmFkMjdhMjFmYzRjNjRmNmNlYzc0ZjpiaXNlY3Qt
bGludXgtMQoKMjAxNC0wOS0xOSAwMDoxNDozNCAzMzE5ZTZmODM5Y2Y5NGUzM2ZiYWQyN2Ey
MWZjNGM2NGY2Y2VjNzRmIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3
MjA0My8zMzE5ZTZmODM5Y2Y5NGUzM2ZiYWQyN2EyMWZjNGM2NGY2Y2VjNzRmL3ZtbGludXot
My4xNS4wLXJjNi0wMDE1MC1nMzMxOWU2ZgoKMjAxNC0wOS0xOSAwMDoxNDozNSBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTYJMjQJNjAgU1VDQ0VT
UwoKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMzMxOWU2Zi4uLiBbbWVkaWFdIGVtMjh4
eDogcmVtb3ZlIGZpZWxkIHR1bmVyX2FkZHIgZnJvbSBzdHJ1Y3QgZW0yOHh4CkhFQUQgaXMg
bm93IGF0IDc2YzJjNmQuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIw
MTQwOTE3CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctaWIxLTA5MTcyMDQzL25leHQ6bWFzdGVyOjc2YzJjNmRjNDZmYmI1YmRkNzM1NzFlYmQw
ODk3Njk2YzVhYjRkNzM6YmlzZWN0LWxpbnV4LTEKIFRFU1QgRkFJTFVSRQpbICAgMTMuMTE4
MzMzXSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91c2Jf
dHR1c2IyClsgICAxMy4xMjcyNTBdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFj
ZSBkcml2ZXIgZHZiX3VzYl9hZjkwMDUKWyAgIDEzLjEyNzI1MF0gdXNiY29yZTogcmVnaXN0
ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBkdmJfdXNiX2FmOTAwNQpbICAgMTMuMTMwNTEw
XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIApbICAgMTMuMTMwNTEwXSBCVUc6IHVu
YWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0cGFnaW5nIHJlcXVlc3QgYXQg
MGYwMDAwMDAKIGF0IDBmMDAwMDAwClsgICAxMy4xMzc1NjJdIElQOgpbICAgMTMuMTM3NTYy
XSBJUDogWzw4OWNlNTJmNT5dIGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkCiBb
PDg5Y2U1MmY1Pl0gYWY5MDA1X3VzYl9tb2R1bGVfaW5pdCsweDZiLzB4OWQKWyAgIDEzLjE0
MDQ3MF0gKnBkZSA9IDAwMDAwMDAwIApbICAgMTMuMTQwNDcwXSAqcGRlID0gMDAwMDAwMDAg
CgpbICAgMTMuMTQwNDcwXSBPb3BzOiAwMDAwIFsjMV0gClsgICAxMy4xNDA0NzBdIE9vcHM6
IDAwMDAgWyMxXSBQUkVFTVBUIFBSRUVNUFQgREVCVUdfUEFHRUFMTE9DREVCVUdfUEFHRUFM
TE9DCgpbICAgMTMuMTQwNDcwXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRh
aW50ZWQgMy4xNy4wLXJjNS1uZXh0LTIwMTQwOTE3ICMxMwpbICAgMTMuMTQwNDcwXSBDUFU6
IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNy4wLXJjNS1uZXh0LTIw
MTQwOTE3ICMxMwpbICAgMTMuMTQwNDcwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2Nocywg
QklPUyBCb2NocyAwMS8wMS8yMDExClsgICAxMy4xNDA0NzBdIEhhcmR3YXJlIG5hbWU6IEJv
Y2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDEzLjE0MDQ3MF0gdGFzazog
ODc4OGM2NjAgdGk6IDg3ODhlMDAwIHRhc2sudGk6IDg3ODhlMDAwClsgICAxMy4xNDA0NzBd
IHRhc2s6IDg3ODhjNjYwIHRpOiA4Nzg4ZTAwMCB0YXNrLnRpOiA4Nzg4ZTAwMApbICAgMTMu
MTQwNDcwXSBFSVA6IDAwNjA6Wzw4OWNlNTJmNT5dIEVGTEFHUzogMDAwMTAyMDYgQ1BVOiAw
ClsgICAxMy4xNDA0NzBdIEVJUDogMDA2MDpbPDg5Y2U1MmY1Pl0gRUZMQUdTOiAwMDAxMDIw
NiBDUFU6IDAKWyAgIDEzLjE0MDQ3MF0gRUlQIGlzIGF0IGFmOTAwNV91c2JfbW9kdWxlX2lu
aXQrMHg2Yi8weDlkClsgICAxMy4xNDA0NzBdIEVJUCBpcyBhdCBhZjkwMDVfdXNiX21vZHVs
ZV9pbml0KzB4NmIvMHg5ZApbICAgMTMuMTQwNDcwXSBFQVg6IDBmMDAwMDAwIEVCWDogMDAw
MDAwMDAgRUNYOiA4ODA0ZjQxOCBFRFg6IDg3ODhjNjAwClsgICAxMy4xNDA0NzBdIEVBWDog
MGYwMDAwMDAgRUJYOiAwMDAwMDAwMCBFQ1g6IDg4MDRmNDE4IEVEWDogODc4OGM2MDAKWyAg
IDEzLjE0MDQ3MF0gRVNJOiA3ZGIxODBhMCBFREk6IDAwMDAwMDAwIEVCUDogODc4OGZmMzAg
RVNQOiA4Nzg4ZmYyYwpbICAgMTMuMTQwNDcwXSBFU0k6IDdkYjE4MGEwIEVESTogMDAwMDAw
MDAgRUJQOiA4Nzg4ZmYzMCBFU1A6IDg3ODhmZjJjClsgICAxMy4xNDA0NzBdICBEUzogMDA3
YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDBlMCBTUzogMDA2OApbICAgMTMuMTQwNDcwXSAg
RFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDEzLjE0
MDQ3MF0gQ1IwOiA4MDA1MDAzMyBDUjI6IDBmMDAwMDAwIENSMzogMTFkNjUwMDAgQ1I0OiAw
MDA0MDY5MApbICAgMTMuMTQwNDcwXSBDUjA6IDgwMDUwMDMzIENSMjogMGYwMDAwMDAgQ1Iz
OiAxMWQ2NTAwMCBDUjQ6IDAwMDQwNjkwClsgICAxMy4xNDA0NzBdIFN0YWNrOgpbICAgMTMu
MTQwNDcwXSBTdGFjazoKWyAgIDEzLjE0MDQ3MF0gIDg5Y2U1MjhhClsgICAxMy4xNDA0NzBd
ICA4OWNlNTI4YSA4Nzg4ZmY5MCA4Nzg4ZmY5MCA4OWM5ZmMyNyA4OWM5ZmMyNyA4YmZmNzk3
OCA4YmZmNzk3OCA4Nzg4ZmY0YyA4Nzg4ZmY0YyA4ODAzOTgwMCA4ODAzOTgwMCA4OTMzOTJi
MCA4OTMzOTJiMCA4YmZmNzk2NyA4YmZmNzk2NwoKWyAgIDEzLjE0MDQ3MF0gIDg3ODhmZjgw
ClsgICAxMy4xNDA0NzBdICA4Nzg4ZmY4MCA4ODAzOTlmYiA4ODAzOTlmYiA4OWFkMWU0MCA4
OWFkMWU0MCAwMDAwMDAwNiAwMDAwMDAwNiAwMDAwMDAwNiAwMDAwMDAwNiA4OWFkMDFmMCA4
OWFkMDFmMCAwMDAwMDFjNSAwMDAwMDFjNSA4YmZmNzk3OSA4YmZmNzk3OQoKWyAgIDEzLjE0
MDQ3MF0gIDAwMDAwMjAwClsgICAxMy4xNDA0NzBdICAwMDAwMDIwMCA4OTlhMTc4MiA4OTlh
MTc4MiAwMDAwMDAwNiAwMDAwMDAwNiAwMDAwMDlmMSAwMDAwMDlmMSA4OWQ0MTgzMCA4OWQ0
MTgzMCA3NmFjNmNjYSA3NmFjNmNjYSAwMDAwMDAwNiAwMDAwMDAwNiAwMDAwMDlmMSAwMDAw
MDlmMQoKWyAgIDEzLjE0MDQ3MF0gQ2FsbCBUcmFjZToKWyAgIDEzLjE0MDQ3MF0gQ2FsbCBU
cmFjZToKWyAgIDEzLjE0MDQ3MF0gIFs8ODljZTUyOGE+XSA/IHR0dXNiMl9kcml2ZXJfaW5p
dCsweDE2LzB4MTYKWyAgIDEzLjE0MDQ3MF0gIFs8ODljZTUyOGE+XSA/IHR0dXNiMl9kcml2
ZXJfaW5pdCsweDE2LzB4MTYKWyAgIDEzLjE0MDQ3MF0gIFs8ODljOWZjMjc+XSBkb19vbmVf
aW5pdGNhbGwrMHgxNjAvMHgxNmYKWyAgIDEzLjE0MDQ3MF0gIFs8ODljOWZjMjc+XSBkb19v
bmVfaW5pdGNhbGwrMHgxNjAvMHgxNmYKWyAgIDEzLjE0MDQ3MF0gIFs8ODgwMzk4MDA+XSA/
IHBhcmFtX2FycmF5X3NldCsweDllLzB4YzUKWyAgIDEzLjE0MDQ3MF0gIFs8ODgwMzk4MDA+
XSA/IHBhcmFtX2FycmF5X3NldCsweDllLzB4YzUKWyAgIDEzLjE0MDQ3MF0gIFs8ODgwMzk5
ZmI+XSA/IHBhcnNlX2FyZ3MrMHgxMjgvMHgyN2UKWyAgIDEzLjE0MDQ3MF0gIFs8ODgwMzk5
ZmI+XSA/IHBhcnNlX2FyZ3MrMHgxMjgvMHgyN2UKWyAgIDEzLjE0MDQ3MF0gIFs8ODljOWZk
MjA+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGVhLzB4MTY3ClsgICAxMy4xNDA0NzBdICBb
PDg5YzlmZDIwPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhlYS8weDE2NwpbICAgMTMuMTQw
NDcwXSAgWzw4OTFhMDhiYz5dIGtlcm5lbF9pbml0KzB4OC8weGI4ClsgICAxMy4xNDA0NzBd
ICBbPDg5MWEwOGJjPl0ga2VybmVsX2luaXQrMHg4LzB4YjgKWyAgIDEzLjE0MDQ3MF0gIFs8
ODkxYzdiMjA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgMTMuMTQw
NDcwXSAgWzw4OTFjN2IyMD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsg
ICAxMy4xNDA0NzBdICBbPDg5MWEwOGI0Pl0gPyByZXN0X2luaXQrMHgxMGMvMHgxMGMKWyAg
IDEzLjE0MDQ3MF0gIFs8ODkxYTA4YjQ+XSA/IHJlc3RfaW5pdCsweDEwYy8weDEwYwpbICAg
MTMuMTQwNDcwXSBDb2RlOgpbICAgMTMuMTQwNDcwXSBDb2RlOiAwOCAwOCBjMiBjMiBjNyBj
NyAwNSAwNSAyNCAyNCBlYSBlYSA1NCA1NCA4YSA4YSAwMCAwMCAwMCAwMCAwMCAwMCAwZiAw
ZiBjNyBjNyAwNSAwNSAyMCAyMCBlYSBlYSA1NCA1NCA4YSA4YSAwMCAwMCAwMCAwMCAwMCAw
MCAwZiAwZiBjNyBjNyAwNSAwNSAxYyAxYyBlYSBlYSA1NCA1NCA4YSA4YSAwMCAwMCAwMCAw
MCAwMCAwMCAwZiAwZiA3NSA3NSAxZiAxZiBiOCBiOCAwMCAwMCAwMCAwMCAwMCAwMCAwZiAw
ZiA4NSA4NSBjMCBjMCA3NCA3NCAxNiAxNiA8YTE+IDxhMT4gMDAgMDAgMDAgMDAgMDAgMDAg
MGYgMGYgYzcgYzcgMDUgMDUgNzQgNzQgMGMgMGMgYmYgYmYgODkgODkgMDAgMDAgMDAgMDAg
MDAgMDAgMGYgMGYgYTMgYTMgNzggNzggMGMgMGMgYmYgYmYgODkgODkgZWIgZWIKClsgICAx
My4xNDA0NzBdIEVJUDogWzw4OWNlNTJmNT5dIApbICAgMTMuMTQwNDcwXSBFSVA6IFs8ODlj
ZTUyZjU+XSBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4NmIvMHg5ZGFmOTAwNV91c2JfbW9k
dWxlX2luaXQrMHg2Yi8weDlkIFNTOkVTUCAwMDY4Ojg3ODhmZjJjCiBTUzpFU1AgMDA2ODo4
Nzg4ZmYyYwpbICAgMTMuMTQwNDcwXSBDUjI6IDAwMDAwMDAwMGYwMDAwMDAKWyAgIDEzLjE0
MDQ3MF0gQ1IyOiAwMDAwMDAwMDBmMDAwMDAwClsgICAxMy4xNDA0NzBdIC0tLVsgZW5kIHRy
YWNlIDczNjk0MjFhODZlMDYwMWYgXS0tLQpbICAgMTMuMTQwNDcwXSAtLS1bIGVuZCB0cmFj
ZSA3MzY5NDIxYTg2ZTA2MDFmIF0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5
MTcyMDQzLzc2YzJjNmRjNDZmYmI1YmRkNzM1NzFlYmQwODk3Njk2YzVhYjRkNzMvZG1lc2ct
eW9jdG8tdnAtMzg6MjAxNDA5MTcyMDU3MjE6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0
MzozLjE3LjAtcmM1LW5leHQtMjAxNDA5MTc6MTMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aWIxLTA5MTcyMDQzLzc2YzJjNmRjNDZmYmI1YmRkNzM1NzFlYmQwODk3Njk2YzVhYjRkNzMv
ZG1lc2cteW9jdG8ta2J1aWxkLTI3OjIwMTQwOTE3MjA1MDA3OmkzODYtcmFuZGNvbmZpZy1p
YjEtMDkxNzIwNDM6My4xNy4wLXJjNS1uZXh0LTIwMTQwOTE3OjEzCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0My83NmMyYzZkYzQ2ZmJiNWJkZDczNTcxZWJkMDg5NzY5
NmM1YWI0ZDczL2RtZXNnLXlvY3RvLXZwLTI2OjIwMTQwOTE3MjA1NzE2OmkzODYtcmFuZGNv
bmZpZy1pYjEtMDkxNzIwNDM6My4xNy4wLXJjNS1uZXh0LTIwMTQwOTE3OjEzCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My83NmMyYzZkYzQ2ZmJiNWJkZDczNTcxZWJk
MDg5NzY5NmM1YWI0ZDczL2RtZXNnLXlvY3RvLWtidWlsZC0xMjoyMDE0MDkxNzIwNTUzODpp
Mzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjMuMTcuMC1yYzUtbmV4dC0yMDE0MDkxNzox
Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNzZjMmM2ZGM0NmZiYjVi
ZGQ3MzU3MWViZDA4OTc2OTZjNWFiNGQ3My9kbWVzZy15b2N0by1rYnVpbGQtNjoyMDE0MDkx
NzIwNTUwMjppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjMuMTcuMC1yYzUtbmV4dC0y
MDE0MDkxNzoxMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNzZjMmM2
ZGM0NmZiYjViZGQ3MzU3MWViZDA4OTc2OTZjNWFiNGQ3My9kbWVzZy15b2N0by12cC00Mjoy
MDE0MDkxNzIwNTcxNzppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjMuMTcuMC1yYzUt
bmV4dC0yMDE0MDkxNzoxMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMv
NzZjMmM2ZGM0NmZiYjViZGQ3MzU3MWViZDA4OTc2OTZjNWFiNGQ3My9kbWVzZy1xdWFudGFs
LWtidWlsZC0xODoyMDE0MDkxNzIwNTUzODppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQz
OjMuMTcuMC1yYzUtbmV4dC0yMDE0MDkxNzoxMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDkxNzIwNDMvNzZjMmM2ZGM0NmZiYjViZGQ3MzU3MWViZDA4OTc2OTZjNWFiNGQ3My9k
bWVzZy15b2N0by1rYnVpbGQtMjA6MjAxNDA5MTcyMDU1MzM6aTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0MzozLjE3LjAtcmM1LW5leHQtMjAxNDA5MTc6MTMKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaWIxLTA5MTcyMDQzLzc2YzJjNmRjNDZmYmI1YmRkNzM1NzFlYmQwODk3Njk2
YzVhYjRkNzMvZG1lc2cteW9jdG8tdnAtNzoyMDE0MDkxNzIwNTcyMTppMzg2LXJhbmRjb25m
aWctaWIxLTA5MTcyMDQzOjMuMTcuMC1yYzUtbmV4dC0yMDE0MDkxNzoxMwova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNzZjMmM2ZGM0NmZiYjViZGQ3MzU3MWViZDA4
OTc2OTZjNWFiNGQ3My9kbWVzZy15b2N0by1rYnVpbGQtMjg6MjAxNDA5MTcyMDU1MzM6aTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0MzozLjE3LjAtcmM1LW5leHQtMjAxNDA5MTc6MTMK
MDoxMDoxMSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQgNzZj
MmM2ZCBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA5MTcKCj09PT09
PT09PSBsaW51cy9tYXN0ZXIgPT09PT09PT09CkZyb20gZ2l0Oi8vZ2l0bWlycm9yL2xpbnVz
CiAgIDM3NTA0YTNiLi44YmE0Y2FmIG1hc3RlciAgICAgLT4gbGludXMvbWFzdGVyCk5vdGU6
IGNoZWNraW5nIG91dCAnbGludXMvbWFzdGVyJy4KCllvdSBhcmUgaW4gJ2RldGFjaGVkIEhF
QUQnIHN0YXRlLiBZb3UgY2FuIGxvb2sgYXJvdW5kLCBtYWtlIGV4cGVyaW1lbnRhbApjaGFu
Z2VzIGFuZCBjb21taXQgdGhlbSwgYW5kIHlvdSBjYW4gZGlzY2FyZCBhbnkgY29tbWl0cyB5
b3UgbWFrZSBpbiB0aGlzCnN0YXRlIHdpdGhvdXQgaW1wYWN0aW5nIGFueSBicmFuY2hlcyBi
eSBwZXJmb3JtaW5nIGFub3RoZXIgY2hlY2tvdXQuCgpJZiB5b3Ugd2FudCB0byBjcmVhdGUg
YSBuZXcgYnJhbmNoIHRvIHJldGFpbiBjb21taXRzIHlvdSBjcmVhdGUsIHlvdSBtYXkKZG8g
c28gKG5vdyBvciBsYXRlcikgYnkgdXNpbmcgLWIgd2l0aCB0aGUgY2hlY2tvdXQgY29tbWFu
ZCBhZ2Fpbi4gRXhhbXBsZToKCiAgZ2l0IGNoZWNrb3V0IC1iIG5ld19icmFuY2hfbmFtZQoK
SEVBRCBpcyBub3cgYXQgOGJhNGNhZi4uLiBSZXZlcnQgImluaXQ6IG1ha2Ugcm9vdGRlbGF5
PU4gY29uc2lzdGVudCB3aXRoIHJvb3R3YWl0IGJlaGF2aW91ciIKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvbGludXM6
bWFzdGVyOjhiYTRjYWYxZWUxNTg1ZjAxOGQzMmFiOTI0MjQ0Yzk1ODliYzlmMzc6YmlzZWN0
LWxpbnV4LTEKCjIwMTQtMDktMTkgMDA6NTg6MTIgOGJhNGNhZjFlZTE1ODVmMDE4ZDMyYWI5
MjQyNDRjOTU4OWJjOWYzNyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcy
MDQzLThiYTRjYWYxZWUxNTg1ZjAxOGQzMmFiOTI0MjQ0Yzk1ODliYzlmMzcKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvOGJhNGNh
ZjFlZTE1ODVmMDE4ZDMyYWI5MjQyNDRjOTU4OWJjOWYzNwp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wOTE3MjA0My04YmE0Y2FmMWVlMTU4NWYwMThkMzJhYjkyNDI0NGM5NTg5YmM5
ZjM3ChtbMTszNW0yMDE0LTA5LTE5IDAxOjAwOjEyIE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9r
YnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMt
OGJhNGNhZjFlZTE1ODVmMDE4ZDMyYWI5MjQyNDRjOTU4OWJjOWYzNxtbMG0KUmV0cnkgYnVp
bGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2xrcC1pYjAzLXNtb2tlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMtOGJhNGNh
ZjFlZTE1ODVmMDE4ZDMyYWI5MjQyNDRjOTU4OWJjOWYzNwpzdGF0dXM6IEZBSUw6IGJ1aWxk
IGVycm9yChtbMTszNW0yMDE0LTA5LTE5IDAxOjA1OjEyIEtlcm5lbCBidWlsZCBmYWlsIG9y
IHRpbWVvdXQbWzBtCjIwMTQtMDktMTkgMDE6MDU6MTIgOGJhNGNhZjFlZTE1ODVmMDE4ZDMy
YWI5MjQyNDRjOTU4OWJjOWYzNyBTS0lQIEJST0tFTiBCVUlMRApDaGVjayAva2J1aWxkLXRl
c3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLThiYTRjYWYx
ZWUxNTg1ZjAxOGQzMmFiOTI0MjQ0Yzk1ODliYzlmMzcKCj09PT09PT09PSBuZXh0L21hc3Rl
ciA9PT09PT09PT0KRnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4dAogKyAxZTEzOTI4Li4uMDAz
ZTZiYSBha3BtICAgICAgIC0+IG5leHQvYWtwbSAgKGZvcmNlZCB1cGRhdGUpCiArIDlkMWQx
MWQuLi44YmNmZTM5IGFrcG0tYmFzZSAgLT4gbmV4dC9ha3BtLWJhc2UgIChmb3JjZWQgdXBk
YXRlKQogKyA3NmMyYzZkLi4uNGQwNDZlOSBtYXN0ZXIgICAgIC0+IG5leHQvbWFzdGVyICAo
Zm9yY2VkIHVwZGF0ZSkKICAgMzc1MDRhM2IuLjhiYTRjYWYgc3RhYmxlICAgICAtPiBuZXh0
L3N0YWJsZQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxNDA5MTggLT4gbmV4dC0yMDE0MDkxOApQcmV2aW91cyBIRUFEIHBvc2l0aW9u
IHdhcyA4YmE0Y2FmLi4uIFJldmVydCAiaW5pdDogbWFrZSByb290ZGVsYXk9TiBjb25zaXN0
ZW50IHdpdGggcm9vdHdhaXQgYmVoYXZpb3VyIgpIRUFEIGlzIG5vdyBhdCA0ZDA0NmU5Li4u
IEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDkxOApscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My9u
ZXh0Om1hc3Rlcjo0ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhOmJp
c2VjdC1saW51eC0xCgoyMDE0LTA5LTE5IDAxOjA1OjI3IDRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0
ZjVjOTRjMTUyYzUyYTljNTFhM2EgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMvaTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0My00ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzRk
MDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUyYTljNTFhM2EKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDkxNzIwNDMtNGQwNDZlOTYwNDZmYWFjNDU2ZjRmNWM5NGMxNTJjNTJh
OWM1MWEzYQobWzE7MzVtMjAxNC0wOS0xOSAwMTowNzoyNyBObyBidWlsZCBzZXJ2ZWQgZmls
ZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcy
MDQzLTRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUyYTljNTFhM2EbWzBtClJldHJ5
IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9sa3AtaWIwMy1zbW9rZS9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLTRk
MDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUyYTljNTFhM2EKa2VybmVsOiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFjNDU2ZjRmNWM5
NGMxNTJjNTJhOWM1MWEzYS92bWxpbnV6LTMuMTcuMC1yYzUtbmV4dC0yMDE0MDkxOAoKMjAx
NC0wOS0xOSAwMTowOToyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMiBURVNUIEZBSUxVUkUK
WyAgICA4LjUwMDEwN10gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZl
ciBkdmJfdXNiX3R0dXNiMgpbICAgIDguNTAxODMyXSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5l
dyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91c2JfYWY5MDA1ClsgICAgOC41MDE4MzJdIHVzYmNv
cmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgZHZiX3VzYl9hZjkwMDUKWyAg
ICA4LjUwMjg3NV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCAKWyAgICA4LjUwMjg3
NV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdHBhZ2luZyBy
ZXF1ZXN0IGF0IDBjYzAwMDAwCiBhdCAwY2MwMDAwMApbICAgIDguNTAzOTM3XSBJUDoKWyAg
ICA4LjUwMzkzN10gSVA6IFs8ODc4ZTUyZjU+XSBhZjkwMDVfdXNiX21vZHVsZV9pbml0KzB4
NmIvMHg5ZAogWzw4NzhlNTJmNT5dIGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlk
ClsgICAgOC41MDQ4MjNdICpwZGUgPSAwMDAwMDAwMCAKWyAgICA4LjUwNDgyM10gKnBkZSA9
IDAwMDAwMDAwIAoKWyAgICA4LjUwNTI5Ml0gT29wczogMDAwMCBbIzFdIApbICAgIDguNTA1
MjkyXSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCBQUkVFTVBUIERFQlVHX1BBR0VBTExPQ0RF
QlVHX1BBR0VBTExPQwoKWyAgICA4LjUwNjA2NV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2Fw
cGVyIE5vdCB0YWludGVkIDMuMTcuMC1yYzUtbmV4dC0yMDE0MDkxOCAjMQpbICAgIDguNTA2
MDY1XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNy4wLXJj
NS1uZXh0LTIwMTQwOTE4ICMxClsgICAgOC41MDcyMDBdIEhhcmR3YXJlIG5hbWU6IFFFTVUg
U3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIDEuNy41LTIwMTQwNTMx
XzA4MzAzMC1nYW5kYWxmIDA0LzAxLzIwMTQKWyAgICA4LjUwNzIwMF0gSGFyZHdhcmUgbmFt
ZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS43LjUt
MjAxNDA1MzFfMDgzMDMwLWdhbmRhbGYgMDQvMDEvMjAxNApbICAgIDguNTA4NzUxXSB0YXNr
OiA4YjQ4ZDY2MCB0aTogOGI0OTAwMDAgdGFzay50aTogOGI0OTAwMDAKWyAgICA4LjUwODc1
MV0gdGFzazogOGI0OGQ2NjAgdGk6IDhiNDkwMDAwIHRhc2sudGk6IDhiNDkwMDAwClsgICAg
OC41MDk1ODddIEVJUDogMDA2MDpbPDg3OGU1MmY1Pl0gRUZMQUdTOiAwMDAxMDIwNiBDUFU6
IDAKWyAgICA4LjUwOTU4N10gRUlQOiAwMDYwOls8ODc4ZTUyZjU+XSBFRkxBR1M6IDAwMDEw
MjA2IENQVTogMApbICAgIDguNTEwMDEzXSBFSVAgaXMgYXQgYWY5MDA1X3VzYl9tb2R1bGVf
aW5pdCsweDZiLzB4OWQKWyAgICA4LjUxMDAxM10gRUlQIGlzIGF0IGFmOTAwNV91c2JfbW9k
dWxlX2luaXQrMHg2Yi8weDlkClsgICAgOC41MTAwMTNdIEVBWDogMGNjMDAwMDAgRUJYOiAw
MDAwMDAwMCBFQ1g6IDg1YzRmNDE4IEVEWDogOGI0OGQ2MDAKWyAgICA4LjUxMDAxM10gRUFY
OiAwY2MwMDAwMCBFQlg6IDAwMDAwMDAwIEVDWDogODVjNGY0MTggRURYOiA4YjQ4ZDYwMApb
ICAgIDguNTEwMDEzXSBFU0k6IDg1YTYzNzAwIEVESTogMDAwMDAwMDAgRUJQOiA4YjQ5MWYz
MCBFU1A6IDhiNDkxZjJjClsgICAgOC41MTAwMTNdIEVTSTogODVhNjM3MDAgRURJOiAwMDAw
MDAwMCBFQlA6IDhiNDkxZjMwIEVTUDogOGI0OTFmMmMKWyAgICA4LjUxMDAxM10gIERTOiAw
MDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4ClsgICAgOC41MTAwMTNd
ICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDBlMCBTUzogMDA2OApbICAgIDgu
NTEwMDEzXSBDUjA6IDgwMDUwMDNiIENSMjogMGNjMDAwMDAgQ1IzOiAxMWU5ZDAwMCBDUjQ6
IDAwMDAwNjkwClsgICAgOC41MTAwMTNdIENSMDogODAwNTAwM2IgQ1IyOiAwY2MwMDAwMCBD
UjM6IDExZTlkMDAwIENSNDogMDAwMDA2OTAKWyAgICA4LjUxMDAxM10gU3RhY2s6ClsgICAg
OC41MTAwMTNdIFN0YWNrOgpbICAgIDguNTEwMDEzXSAgODc4ZTUyOGEKWyAgICA4LjUxMDAx
M10gIDg3OGU1MjhhIDhiNDkxZjkwIDhiNDkxZjkwIDg3ODlmYzI3IDg3ODlmYzI3IDhiY2E2
OTc4IDhiY2E2OTc4IDhiNDkxZjRjIDhiNDkxZjRjIDg1YzM5ODAwIDg1YzM5ODAwIDg2ZjM5
MmQwIDg2ZjM5MmQwIDhiY2E2OTY3IDhiY2E2OTY3CgpbICAgIDguNTEwMDEzXSAgOGI0OTFm
ODAKWyAgICA4LjUxMDAxM10gIDhiNDkxZjgwIDg1YzM5OWZiIDg1YzM5OWZiIDg3NmQyMDVj
IDg3NmQyMDVjIDAwMDAwMDA2IDAwMDAwMDA2IDAwMDAwMDA2IDAwMDAwMDA2IDg3NmQwNDBj
IDg3NmQwNDBjIDAwMDAwMWM1IDAwMDAwMWM1IDhiY2E2OTc5IDhiY2E2OTc5CgpbICAgIDgu
NTEwMDEzXSAgMDAwMDAyMDAKWyAgICA4LjUxMDAxM10gIDAwMDAwMjAwIDg3NWExODU3IDg3
NWExODU3IDAwMDAwMDA2IDAwMDAwMDA2IDAwMDAwOWYxIDAwMDAwOWYxIDg3OTQxODMwIDg3
OTQxODMwIDU5NjNjNDI1IDU5NjNjNDI1IDAwMDAwMDA2IDAwMDAwMDA2IDAwMDAwOWYxIDAw
MDAwOWYxCgpbICAgIDguNTEwMDEzXSBDYWxsIFRyYWNlOgpbICAgIDguNTEwMDEzXSBDYWxs
IFRyYWNlOgpbICAgIDguNTEwMDEzXSAgWzw4NzhlNTI4YT5dID8gdHR1c2IyX2RyaXZlcl9p
bml0KzB4MTYvMHgxNgpbICAgIDguNTEwMDEzXSAgWzw4NzhlNTI4YT5dID8gdHR1c2IyX2Ry
aXZlcl9pbml0KzB4MTYvMHgxNgpbICAgIDguNTEwMDEzXSAgWzw4Nzg5ZmMyNz5dIGRvX29u
ZV9pbml0Y2FsbCsweDE2MC8weDE2ZgpbICAgIDguNTEwMDEzXSAgWzw4Nzg5ZmMyNz5dIGRv
X29uZV9pbml0Y2FsbCsweDE2MC8weDE2ZgpbICAgIDguNTEwMDEzXSAgWzw4NWMzOTgwMD5d
ID8gcGFyYW1fYXJyYXlfc2V0KzB4OWUvMHhjNQpbICAgIDguNTEwMDEzXSAgWzw4NWMzOTgw
MD5dID8gcGFyYW1fYXJyYXlfc2V0KzB4OWUvMHhjNQpbICAgIDguNTEwMDEzXSAgWzw4NWMz
OTlmYj5dID8gcGFyc2VfYXJncysweDEyOC8weDI3ZQpbICAgIDguNTEwMDEzXSAgWzw4NWMz
OTlmYj5dID8gcGFyc2VfYXJncysweDEyOC8weDI3ZQpbICAgIDguNTEwMDEzXSAgWzw4Nzg5
ZmQyMD5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZWEvMHgxNjcKWyAgICA4LjUxMDAxM10g
IFs8ODc4OWZkMjA+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGVhLzB4MTY3ClsgICAgOC41
MTAwMTNdICBbPDg2ZGEwYjhjPl0ga2VybmVsX2luaXQrMHg4LzB4YjgKWyAgICA4LjUxMDAx
M10gIFs8ODZkYTBiOGM+XSBrZXJuZWxfaW5pdCsweDgvMHhiOApbICAgIDguNTEwMDEzXSAg
Wzw4NmRjN2UwMD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsgICAgOC41
MTAwMTNdICBbPDg2ZGM3ZTAwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAK
WyAgICA4LjUxMDAxM10gIFs8ODZkYTBiODQ+XSA/IHJlc3RfaW5pdCsweDEwYy8weDEwYwpb
ICAgIDguNTEwMDEzXSAgWzw4NmRhMGI4ND5dID8gcmVzdF9pbml0KzB4MTBjLzB4MTBjClsg
ICAgOC41MTAwMTNdIENvZGU6ClsgICAgOC41MTAwMTNdIENvZGU6IDA4IDA4IGMyIGMyIGM3
IGM3IDA1IDA1IDI0IDI0IGVhIGVhIDE0IDE0IDg4IDg4IDAwIDAwIDAwIDAwIGMwIGMwIDBj
IDBjIGM3IGM3IDA1IDA1IDIwIDIwIGVhIGVhIDE0IDE0IDg4IDg4IDAwIDAwIDAwIDAwIGMw
IGMwIDBjIDBjIGM3IGM3IDA1IDA1IDFjIDFjIGVhIGVhIDE0IDE0IDg4IDg4IDAwIDAwIDAw
IDAwIGMwIGMwIDBjIDBjIDc1IDc1IDFmIDFmIGI4IGI4IDAwIDAwIDAwIDAwIGMwIGMwIDBj
IDBjIDg1IDg1IGMwIGMwIDc0IDc0IDE2IDE2IDxhMT4gPGExPiAwMCAwMCAwMCAwMCBjMCBj
MCAwYyAwYyBjNyBjNyAwNSAwNSA3NCA3NCAwYyAwYyA3ZiA3ZiA4NyA4NyAwMCAwMCAwMCAw
MCBjMCBjMCAwYyAwYyBhMyBhMyA3OCA3OCAwYyAwYyA3ZiA3ZiA4NyA4NyBlYiBlYgoKWyAg
ICA4LjUxMDAxM10gRUlQOiBbPDg3OGU1MmY1Pl0gClsgICAgOC41MTAwMTNdIEVJUDogWzw4
NzhlNTJmNT5dIGFmOTAwNV91c2JfbW9kdWxlX2luaXQrMHg2Yi8weDlkYWY5MDA1X3VzYl9t
b2R1bGVfaW5pdCsweDZiLzB4OWQgU1M6RVNQIDAwNjg6OGI0OTFmMmMKIFNTOkVTUCAwMDY4
OjhiNDkxZjJjClsgICAgOC41MTAwMTNdIENSMjogMDAwMDAwMDAwY2MwMDAwMApbICAgIDgu
NTEwMDEzXSBDUjI6IDAwMDAwMDAwMGNjMDAwMDAKWyAgICA4LjUxMDAxM10gLS0tWyBlbmQg
dHJhY2UgZTQzNWU4MWRjZGNhYjIxMyBdLS0tClsgICAgOC41MTAwMTNdIC0tLVsgZW5kIHRy
YWNlIGU0MzVlODFkY2RjYWIyMTMgXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVz
Zy15b2N0by1pdmI0MS0xMjM6MjAxNDA5MTkwMTA5MDY6aTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My80ZDA0NmU5
NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhL2RtZXNnLXlvY3RvLWl2YjQxLTU1
OjIwMTQwOTE5MDEwOTA2OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFjNDU2ZjRmNWM5
NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS0xODoyMDE0MDkxOTAxMDkwODpp
Mzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aWIxLTA5MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUyYTljNTFhM2Ev
ZG1lc2cteW9jdG8taXZiNDEtMjE6MjAxNDA5MTkwMTA5MDY6aTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My80ZDA0
NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhL2RtZXNnLXlvY3RvLWl2YjQx
LTQ1OjIwMTQwOTE5MDEwOTA2OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFjNDU2ZjRm
NWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS01NzoyMDE0MDkxOTAxMDkw
NjppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUyYTljNTFh
M2EvZG1lc2cteW9jdG8taXZiNDEtNjQ6MjAxNDA5MTkwMTA5MDY6aTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My80
ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhL2RtZXNnLXlvY3RvLWl2
YjQxLTc4OjIwMTQwOTE5MDEwOTA2OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFjNDU2
ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS05MDoyMDE0MDkxOTAx
MDkwODppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUyYTlj
NTFhM2EvZG1lc2cteW9jdG8taXZiNDEtMTA3OjIwMTQwOTE5MDEwOTE3OmkzODYtcmFuZGNv
bmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIw
NDMvNGQwNDZlOTYwNDZmYWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0
by1pdmI0MS0xMDg6MjAxNDA5MTkwMTA5MTM6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0
Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My80ZDA0NmU5NjA0NmZh
YWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhL2RtZXNnLXlvY3RvLWl2YjQxLTEwOToyMDE0
MDkxOTAxMDkxNzppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUy
YzUyYTljNTFhM2EvZG1lc2cteW9jdG8taXZiNDEtMTA6MjAxNDA5MTkwMTA5MTg6aTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhL2RtZXNn
LXlvY3RvLWl2YjQxLTExMDoyMDE0MDkxOTAxMDkxMTppMzg2LXJhbmRjb25maWctaWIxLTA5
MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2
MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUyYTljNTFhM2EvZG1lc2cteW9jdG8taXZiNDEtMTEz
OjIwMTQwOTE5MDEwOTE4OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFjNDU2ZjRmNWM5
NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS0xMTY6MjAxNDA5MTkwMTA5MTQ6
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNh
L2RtZXNnLXlvY3RvLWl2YjQxLTExODoyMDE0MDkxOTAxMDkwOTppMzg2LXJhbmRjb25maWct
aWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzRk
MDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUyYTljNTFhM2EvZG1lc2cteW9jdG8taXZi
NDEtMTE5OjIwMTQwOTE5MDEwOTEzOmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFjNDU2
ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS0xMjA6MjAxNDA5MTkw
MTA5MTg6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wOTE3MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5
YzUxYTNhL2RtZXNnLXlvY3RvLWl2YjQxLTEyMjoyMDE0MDkxOTAxMDkxMzppMzg2LXJhbmRj
b25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcy
MDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUyYTljNTFhM2EvZG1lc2cteW9j
dG8taXZiNDEtMTI6MjAxNDA5MTkwMTA5MTk6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0
Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My80ZDA0NmU5NjA0NmZh
YWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhL2RtZXNnLXlvY3RvLWl2YjQxLTEzOjIwMTQw
OTE5MDEwOTE3OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFjNDU2ZjRmNWM5NGMxNTJj
NTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS0xNDoyMDE0MDkxOTAxMDkxNzppMzg2LXJh
bmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5
MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUyYTljNTFhM2EvZG1lc2ct
eW9jdG8taXZiNDEtMTc6MjAxNDA5MTkwMTA5MTc6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3
MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My80ZDA0NmU5NjA0
NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhL2RtZXNnLXlvY3RvLWl2YjQxLTE5OjIw
MTQwOTE5MDEwOTE3OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFjNDU2ZjRmNWM5NGMx
NTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS0xOjIwMTQwOTE5MDEwOTE4OmkzODYt
cmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVz
Zy15b2N0by1pdmI0MS0yMDoyMDE0MDkxOTAxMDkxODppMzg2LXJhbmRjb25maWctaWIxLTA5
MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2
MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUyYTljNTFhM2EvZG1lc2cteW9jdG8taXZiNDEtMjI6
MjAxNDA5MTkwMTA5MTE6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0
YzE1MmM1MmE5YzUxYTNhL2RtZXNnLXlvY3RvLWl2YjQxLTI6MjAxNDA5MTkwMTA5MTQ6aTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhL2Rt
ZXNnLXlvY3RvLWl2YjQxLTMxOjIwMTQwOTE5MDEwOTE0OmkzODYtcmFuZGNvbmZpZy1pYjEt
MDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZl
OTYwNDZmYWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS0z
NDoyMDE0MDkxOTAxMDkxMzppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVj
OTRjMTUyYzUyYTljNTFhM2EvZG1lc2cteW9jdG8taXZiNDEtMzc6MjAxNDA5MTkwMTA5MTM6
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNh
L2RtZXNnLXlvY3RvLWl2YjQxLTM4OjIwMTQwOTE5MDEwOTEzOmkzODYtcmFuZGNvbmZpZy1p
YjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQw
NDZlOTYwNDZmYWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0
MS00MzoyMDE0MDkxOTAxMDkxODppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0
ZjVjOTRjMTUyYzUyYTljNTFhM2EvZG1lc2cteW9jdG8taXZiNDEtNDg6MjAxNDA5MTkwMTA5
MTM6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wOTE3MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUx
YTNhL2RtZXNnLXlvY3RvLWl2YjQxLTQ5OjIwMTQwOTE5MDEwOTE3OmkzODYtcmFuZGNvbmZp
Zy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMv
NGQwNDZlOTYwNDZmYWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1p
dmI0MS01MjoyMDE0MDkxOTAxMDkxNzppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1
NmY0ZjVjOTRjMTUyYzUyYTljNTFhM2EvZG1lc2cteW9jdG8taXZiNDEtNTM6MjAxNDA5MTkw
MTA5MTg6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wOTE3MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5
YzUxYTNhL2RtZXNnLXlvY3RvLWl2YjQxLTU0OjIwMTQwOTE5MDEwOTE4OmkzODYtcmFuZGNv
bmZpZy1pYjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIw
NDMvNGQwNDZlOTYwNDZmYWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0
by1pdmI0MS01OjIwMTQwOTE5MDEwOTE5OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFj
NDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS02MzoyMDE0MDkx
OTAxMDkxODppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUyYzUy
YTljNTFhM2EvZG1lc2cteW9jdG8taXZiNDEtNjc6MjAxNDA5MTkwMTA5MTc6aTM4Ni1yYW5k
Y29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3
MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhL2RtZXNnLXlv
Y3RvLWl2YjQxLTcwOjIwMTQwOTE5MDEwOTE4OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIw
NDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZm
YWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS03NDoyMDE0
MDkxOTAxMDkxNTppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRjMTUy
YzUyYTljNTFhM2EvZG1lc2cteW9jdG8taXZiNDEtNzc6MjAxNDA5MTkwMTA5MTM6aTM4Ni1y
YW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
OTE3MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhL2RtZXNn
LXlvY3RvLWl2YjQxLTgwOjIwMTQwOTE5MDEwOTE3OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkx
NzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYw
NDZmYWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS04MToy
MDE0MDkxOTAxMDkxNzppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVjOTRj
MTUyYzUyYTljNTFhM2EvZG1lc2cteW9jdG8taXZiNDEtODQ6MjAxNDA5MTkwMTA5MTM6aTM4
Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wOTE3MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNhL2Rt
ZXNnLXlvY3RvLWl2YjQxLTg5OjIwMTQwOTE5MDEwOTE2OmkzODYtcmFuZGNvbmZpZy1pYjEt
MDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZl
OTYwNDZmYWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS05
MzoyMDE0MDkxOTAxMDkxODppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzLzRkMDQ2ZTk2MDQ2ZmFhYzQ1NmY0ZjVj
OTRjMTUyYzUyYTljNTFhM2EvZG1lc2cteW9jdG8taXZiNDEtOTc6MjAxNDA5MTkwMTA5MTg6
aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wOTE3MjA0My80ZDA0NmU5NjA0NmZhYWM0NTZmNGY1Yzk0YzE1MmM1MmE5YzUxYTNh
L2RtZXNnLXlvY3RvLWl2YjQxLTk4OjIwMTQwOTE5MDEwOTEzOmkzODYtcmFuZGNvbmZpZy1p
YjEtMDkxNzIwNDM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQw
NDZlOTYwNDZmYWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0
MS05OjIwMTQwOTE5MDEwOTE3OmkzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDM6Ogova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZmYWFjNDU2ZjRm
NWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1rYnVpbGQtMTY6MjAxNDA5MTkwMTA2
NDE6aTM4Ni1yYW5kY29uZmlnLWliMS0wOTE3MjA0MzozLjE3LjAtcmM1LW5leHQtMjAxNDA5
MTg6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDkxNzIwNDMvNGQwNDZlOTYwNDZm
YWFjNDU2ZjRmNWM5NGMxNTJjNTJhOWM1MWEzYS9kbWVzZy15b2N0by1pdmI0MS01MToyMDE0
MDkxOTAxMDkxODppMzg2LXJhbmRjb25maWctaWIxLTA5MTcyMDQzOjoKMDo1NTo1NyBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwoK

--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.15.0-rc6-00151-ga5c075c"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.15.0-rc6 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_KTIME_SCALAR=y
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
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
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
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
CONFIG_HAVE_CLK=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_RDC321X=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
# CONFIG_X86_UP_IOAPIC is not set
CONFIG_X86_LOCAL_APIC=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
CONFIG_X86_PCC_CPUFREQ=y
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

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
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
CONFIG_PCI_GOMMCONFIG=y
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_SYN_COOKIES=y
# CONFIG_NET_IPVTI is not set
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_MCAST=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
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
CONFIG_SIGMATEL_FIR=y
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
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
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_DRBD=y
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_ATMEL_PWM is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=y
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_CS5535 is not set
CONFIG_BLK_DEV_CS5536=y
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
CONFIG_BLK_DEV_ALI14XX=y
CONFIG_BLK_DEV_DTC2278=y
CONFIG_BLK_DEV_HT6560B=y
CONFIG_BLK_DEV_QD65XX=y
CONFIG_BLK_DEV_UMC8672=y
CONFIG_BLK_DEV_IDEDMA=y

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
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_7000FASST=y
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AHA152X=y
CONFIG_SCSI_AHA1542=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=y
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_IN2000 is not set
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ESAS2R=y
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_DTC3280=y
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_GENERIC_NCR5380=y
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
CONFIG_SCSI_GENERIC_NCR53C400=y
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_NCR53C406A=y
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_PAS16=y
# CONFIG_SCSI_QLOGIC_FAS is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_T128=y
CONFIG_SCSI_U14_34F=y
# CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
# CONFIG_SCSI_ULTRASTOR is not set
CONFIG_SCSI_NSP32=y
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=y
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
# CONFIG_ATA_ACPI is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
# CONFIG_DM_ERA is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_RAID=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
CONFIG_DM_MULTIPATH_ST=y
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
# CONFIG_DM_SWITCH is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
CONFIG_TCM_FC=y
# CONFIG_ISCSI_TARGET is not set
CONFIG_SBP_TARGET=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_TCP=y
# CONFIG_ATM_LANAI is not set
CONFIG_ATM_ENI=y
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
# CONFIG_ATM_FIRESTREAM is not set
CONFIG_ATM_ZATM=y
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_NICSTAR=y
CONFIG_ATM_NICSTAR_USE_SUNI=y
# CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
CONFIG_ATM_IDT77252=y
# CONFIG_ATM_IDT77252_DEBUG is not set
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
# CONFIG_ATM_AMBASSADOR is not set
CONFIG_ATM_HORIZON=y
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=y
CONFIG_ATM_IA_DEBUG=y
CONFIG_ATM_FORE200E=y
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=y
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL3=y
# CONFIG_3C515 is not set
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_ALTERA_TSE=y
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
CONFIG_LANCE=y
# CONFIG_PCNET32 is not set
CONFIG_NI65=y
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
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
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=y
# CONFIG_CHELSIO_T4 is not set
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CIRRUS is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
# CONFIG_IGB_HWMON is not set
CONFIG_IGBVF=y
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
CONFIG_NE2000=y
# CONFIG_NE2K_PCI is not set
CONFIG_ULTRA=y
CONFIG_WD80x3=y
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=y
# CONFIG_8139TOO is not set
CONFIG_R8169=y
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
CONFIG_NET_VENDOR_SAMSUNG=y
CONFIG_SXGBE_ETH=y
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
CONFIG_SFC=y
# CONFIG_SFC_MCDI_MON is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_SMC9194=y
CONFIG_EPIC100=y
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
# CONFIG_NET_VENDOR_TI is not set
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_VELOCITY=y
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM7XXX_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MICREL_KS8995MA=y
CONFIG_PLIP=y
# CONFIG_PPP is not set
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_HUAWEI_CDC_NCM=y
CONFIG_USB_NET_CDC_MBIM=y
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_SR9700=y
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=y
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=y
CONFIG_USB_NET_QMI_WWAN=y
# CONFIG_USB_HSO is not set
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y
CONFIG_HDLC_X25=y
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=y
CONFIG_PC300TOO=y
CONFIG_N2=y
CONFIG_C101=y
CONFIG_FARSYNC=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
# CONFIG_SDLA is not set
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_IEEE802154_AT86RF230 is not set
CONFIG_IEEE802154_MRF24J40=y
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

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
CONFIG_INPUT_EVDEV=y
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
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
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
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_FOURPORT is not set
# CONFIG_SERIAL_8250_ACCENT is not set
CONFIG_SERIAL_8250_BOCA=y
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
# CONFIG_SERIAL_8250_HUB6 is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_TTY_PRINTK=y
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_DTLK=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y
CONFIG_MWAVE=y
# CONFIG_SCx200_GPIO is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_MUX_PINCTRL is not set
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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
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
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_SCx200_ACB is not set
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
CONFIG_SPI_GPIO=y
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

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
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_PINMUX is not set
# CONFIG_PINCONF is not set
CONFIG_DEBUG_PINCTRL=y
# CONFIG_PINCTRL_BAYTRAIL is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_LP3943=y
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
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_TWL6040 is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#
# CONFIG_GPIO_UCB1400 is not set

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_TPS6586X=y

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_BATTERY_TWL4030_MADC=y
CONFIG_BATTERY_RX51=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_LP8788=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_MAX8998=y
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_TWL4030_MADC=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
# CONFIG_TWL4030_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_GEODE_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
CONFIG_KEMPLD_WDT=y
# CONFIG_HPWDT_NMI_DECODING is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
# CONFIG_RDC321X_WDT is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
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
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
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
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
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
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_UCB1400_CORE=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ARIZONA=y
# CONFIG_REGULATOR_BCM590XX is not set
# CONFIG_REGULATOR_DA9055 is not set
# CONFIG_REGULATOR_DA9063 is not set
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_LP8788 is not set
# CONFIG_REGULATOR_MAX14577 is not set
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
# CONFIG_DVB_NET is not set
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
CONFIG_IR_RC5_DECODER=y
# CONFIG_IR_RC6_DECODER is not set
CONFIG_IR_JVC_DECODER=y
# CONFIG_IR_SONY_DECODER is not set
CONFIG_IR_RC5_SZ_DECODER=y
# CONFIG_IR_SANYO_DECODER is not set
CONFIG_IR_SHARP_DECODER=y
# CONFIG_IR_MCE_KBD_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=y
# CONFIG_IR_ENE is not set
CONFIG_IR_IMON=y
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ITE_CIR=y
CONFIG_IR_FINTEK=y
CONFIG_IR_NUVOTON=y
CONFIG_IR_REDRAT3=y
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
CONFIG_IR_IGUANA=y
CONFIG_IR_TTUSBIR=y
# CONFIG_IR_IMG is not set
CONFIG_RC_LOOPBACK=y
# CONFIG_IR_GPIO_CIR is not set
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=y
# CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV is not set
CONFIG_USB_GSPCA=y
CONFIG_USB_M5602=y
# CONFIG_USB_STV06XX is not set
CONFIG_USB_GL860=y
# CONFIG_USB_GSPCA_BENQ is not set
CONFIG_USB_GSPCA_CONEX=y
CONFIG_USB_GSPCA_CPIA1=y
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=y
# CONFIG_USB_GSPCA_FINEPIX is not set
# CONFIG_USB_GSPCA_JEILINJ is not set
# CONFIG_USB_GSPCA_JL2005BCD is not set
CONFIG_USB_GSPCA_KINECT=y
CONFIG_USB_GSPCA_KONICA=y
CONFIG_USB_GSPCA_MARS=y
# CONFIG_USB_GSPCA_MR97310A is not set
CONFIG_USB_GSPCA_NW80X=y
# CONFIG_USB_GSPCA_OV519 is not set
CONFIG_USB_GSPCA_OV534=y
CONFIG_USB_GSPCA_OV534_9=y
CONFIG_USB_GSPCA_PAC207=y
CONFIG_USB_GSPCA_PAC7302=y
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SE401 is not set
CONFIG_USB_GSPCA_SN9C2028=y
# CONFIG_USB_GSPCA_SN9C20X is not set
CONFIG_USB_GSPCA_SONIXB=y
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
CONFIG_USB_GSPCA_SPCA501=y
CONFIG_USB_GSPCA_SPCA505=y
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
CONFIG_USB_GSPCA_SPCA561=y
# CONFIG_USB_GSPCA_SPCA1528 is not set
CONFIG_USB_GSPCA_SQ905=y
CONFIG_USB_GSPCA_SQ905C=y
# CONFIG_USB_GSPCA_SQ930X is not set
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_STK1135 is not set
# CONFIG_USB_GSPCA_STV0680 is not set
CONFIG_USB_GSPCA_SUNPLUS=y
# CONFIG_USB_GSPCA_T613 is not set
CONFIG_USB_GSPCA_TOPRO=y
CONFIG_USB_GSPCA_TV8532=y
CONFIG_USB_GSPCA_VC032X=y
CONFIG_USB_GSPCA_VICAM=y
CONFIG_USB_GSPCA_XIRLINK_CIT=y
# CONFIG_USB_GSPCA_ZC3XX is not set
# CONFIG_USB_PWC is not set
CONFIG_VIDEO_CPIA2=y
CONFIG_USB_ZR364XX=y
CONFIG_USB_STKWEBCAM=y
# CONFIG_USB_S2255 is not set
CONFIG_VIDEO_USBTV=y

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=y
CONFIG_VIDEO_PVRUSB2_SYSFS=y
# CONFIG_VIDEO_PVRUSB2_DVB is not set
CONFIG_VIDEO_PVRUSB2_DEBUGIFC=y
CONFIG_VIDEO_HDPVR=y
# CONFIG_VIDEO_TLG2300 is not set
CONFIG_VIDEO_USBVISION=y
CONFIG_VIDEO_STK1160_COMMON=y
# CONFIG_VIDEO_STK1160_AC97 is not set
CONFIG_VIDEO_STK1160=y

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=y
CONFIG_VIDEO_AU0828_V4L2=y
CONFIG_VIDEO_CX231XX=y
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=y
CONFIG_VIDEO_CX231XX_DVB=y
# CONFIG_VIDEO_TM6000 is not set

#
# Digital TV USB devices
#
CONFIG_DVB_USB=y
CONFIG_DVB_USB_DEBUG=y
CONFIG_DVB_USB_A800=y
CONFIG_DVB_USB_DIBUSB_MB=y
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
# CONFIG_DVB_USB_DIBUSB_MC is not set
# CONFIG_DVB_USB_DIB0700 is not set
# CONFIG_DVB_USB_UMT_010 is not set
# CONFIG_DVB_USB_CXUSB is not set
CONFIG_DVB_USB_M920X=y
CONFIG_DVB_USB_DIGITV=y
CONFIG_DVB_USB_VP7045=y
# CONFIG_DVB_USB_VP702X is not set
CONFIG_DVB_USB_GP8PSK=y
CONFIG_DVB_USB_NOVA_T_USB2=y
CONFIG_DVB_USB_TTUSB2=y
CONFIG_DVB_USB_DTT200U=y
# CONFIG_DVB_USB_OPERA1 is not set
CONFIG_DVB_USB_AF9005=y
# CONFIG_DVB_USB_AF9005_REMOTE is not set
# CONFIG_DVB_USB_PCTV452E is not set
# CONFIG_DVB_USB_DW2102 is not set
# CONFIG_DVB_USB_CINERGY_T2 is not set
CONFIG_DVB_USB_DTV5100=y
CONFIG_DVB_USB_FRIIO=y
CONFIG_DVB_USB_AZ6027=y
# CONFIG_DVB_USB_TECHNISAT_USB2 is not set
CONFIG_DVB_USB_V2=y
CONFIG_DVB_USB_AF9015=y
# CONFIG_DVB_USB_AF9035 is not set
# CONFIG_DVB_USB_ANYSEE is not set
CONFIG_DVB_USB_AU6610=y
# CONFIG_DVB_USB_AZ6007 is not set
CONFIG_DVB_USB_CE6230=y
CONFIG_DVB_USB_EC168=y
CONFIG_DVB_USB_GL861=y
CONFIG_DVB_USB_LME2510=y
CONFIG_DVB_USB_MXL111SF=y
CONFIG_DVB_USB_RTL28XXU=y
# CONFIG_DVB_TTUSB_BUDGET is not set
CONFIG_DVB_TTUSB_DEC=y
# CONFIG_SMS_USB_DRV is not set
# CONFIG_DVB_B2C2_FLEXCOP_USB is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=y
CONFIG_VIDEO_EM28XX_V4L2=y
# CONFIG_VIDEO_EM28XX_ALSA is not set
CONFIG_VIDEO_EM28XX_DVB=y
CONFIG_VIDEO_EM28XX_RC=y
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=y
# CONFIG_VIDEO_IVTV_ALSA is not set
CONFIG_VIDEO_FB_IVTV=y
CONFIG_VIDEO_ZORAN=y
CONFIG_VIDEO_ZORAN_DC30=y
CONFIG_VIDEO_ZORAN_ZR36060=y
CONFIG_VIDEO_ZORAN_BUZ=y
CONFIG_VIDEO_ZORAN_DC10=y
CONFIG_VIDEO_ZORAN_LML33=y
# CONFIG_VIDEO_ZORAN_LML33R10 is not set
# CONFIG_VIDEO_ZORAN_AVS6EYES is not set
CONFIG_VIDEO_HEXIUM_GEMINI=y
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_MXB=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=y
CONFIG_VIDEO_CX18_ALSA=y
# CONFIG_VIDEO_CX23885 is not set
CONFIG_VIDEO_CX25821=y
CONFIG_VIDEO_CX25821_ALSA=y
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_BT848 is not set
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_ALSA=y
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=y
# CONFIG_VIDEO_SAA7164 is not set

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110=y
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=y
CONFIG_DVB_BUDGET=y
CONFIG_DVB_BUDGET_CI=y
# CONFIG_DVB_BUDGET_AV is not set
CONFIG_DVB_BUDGET_PATCH=y
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
# CONFIG_DVB_PLUTO2 is not set
CONFIG_DVB_DM1105=y
# CONFIG_DVB_PT1 is not set
# CONFIG_MANTIS_CORE is not set
CONFIG_DVB_NGENE=y
CONFIG_DVB_DDBRIDGE=y
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=y
# CONFIG_VIDEO_VIA_CAMERA is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=y
# CONFIG_VIDEO_SH_VEU is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_BWQCAM=y
# CONFIG_VIDEO_CQCAM is not set
# CONFIG_VIDEO_PMS is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
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
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7175=y

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_MT9V011=y

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_M52790=y

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
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_M88TS2022=y
CONFIG_MEDIA_TUNER_SI2157=y
CONFIG_MEDIA_TUNER_R820T=y

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y
CONFIG_DVB_M88DS3103=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_DRXD=y
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
CONFIG_DVB_EC100=y
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=y
CONFIG_DVB_SI2168=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=y
CONFIG_DVB_LNBP21=y
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=y
CONFIG_DVB_ISL6423=y
CONFIG_DVB_A8293=y
CONFIG_DVB_IX2505V=y
CONFIG_DVB_M88RS2000=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_INTEL_GTT=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_I915_FBDEV=y
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
# CONFIG_DRM_I915_UMS is not set
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y
CONFIG_DRM_PTN3460=y

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
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
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_I810 is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=y
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_LP8788 is not set
# CONFIG_BACKLIGHT_OT200 is not set
CONFIG_BACKLIGHT_PANDORA=y
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=y
CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
CONFIG_SND_OPL4_LIB_SEQ=y
CONFIG_SND_SBAWE_SEQ=y
CONFIG_SND_EMU10K1_SEQ=y
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_VIRMIDI=y
CONFIG_SND_MTPAV=y
CONFIG_SND_MTS64=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
CONFIG_SND_PORTMAN2X4=y
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB8_DSP=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
# CONFIG_SND_ADLIB is not set
CONFIG_SND_AD1816A=y
CONFIG_SND_AD1848=y
CONFIG_SND_ALS100=y
CONFIG_SND_AZT1605=y
CONFIG_SND_AZT2316=y
CONFIG_SND_AZT2320=y
CONFIG_SND_CMI8328=y
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
CONFIG_SND_CS4236=y
# CONFIG_SND_ES1688 is not set
CONFIG_SND_ES18XX=y
CONFIG_SND_SC6000=y
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
CONFIG_SND_GUSMAX=y
CONFIG_SND_INTERWAVE=y
CONFIG_SND_INTERWAVE_STB=y
CONFIG_SND_JAZZ16=y
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
CONFIG_SND_OPTI92X_CS4231=y
# CONFIG_SND_OPTI93X is not set
CONFIG_SND_MIRO=y
CONFIG_SND_SB8=y
# CONFIG_SND_SB16 is not set
CONFIG_SND_SBAWE=y
CONFIG_SND_SB16_CSP=y
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set
# CONFIG_SND_MSND_PINNACLE is not set
CONFIG_SND_MSND_CLASSIC=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
CONFIG_SND_ALS300=y
CONFIG_SND_ALS4000=y
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
CONFIG_SND_ATIIXP=y
CONFIG_SND_ATIIXP_MODEM=y
CONFIG_SND_AU8810=y
# CONFIG_SND_AU8820 is not set
CONFIG_SND_AU8830=y
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=y
# CONFIG_SND_BT87X is not set
CONFIG_SND_CA0106=y
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CS5530 is not set
CONFIG_SND_CS5535AUDIO=y
CONFIG_SND_CTXFI=y
CONFIG_SND_DARLA20=y
CONFIG_SND_GINA20=y
CONFIG_SND_LAYLA20=y
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
CONFIG_SND_LAYLA24=y
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
CONFIG_SND_INDIGO=y
CONFIG_SND_INDIGOIO=y
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
CONFIG_SND_EMU10K1=y
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
CONFIG_SND_ES1938=y
CONFIG_SND_ES1968=y
# CONFIG_SND_ES1968_INPUT is not set
CONFIG_SND_FM801=y
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
CONFIG_SND_HDSPM=y
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
CONFIG_SND_LX6464ES=y
CONFIG_SND_MAESTRO3=y
# CONFIG_SND_MAESTRO3_INPUT is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
CONFIG_SND_RIPTIDE=y
# CONFIG_SND_RME32 is not set
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SIS7019=y
CONFIG_SND_SONICVIBES=y
# CONFIG_SND_TRIDENT is not set
CONFIG_SND_VIA82XX=y
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
CONFIG_SND_YMFPCI=y

#
# HD-Audio
#
CONFIG_SND_HDA=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
# CONFIG_SND_HDA_HWDEP is not set
CONFIG_SND_HDA_RECONFIG=y
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
CONFIG_SND_HDA_PATCH_LOADER=y
# CONFIG_SND_HDA_CODEC_REALTEK is not set
# CONFIG_SND_HDA_CODEC_ANALOG is not set
CONFIG_SND_HDA_CODEC_SIGMATEL=y
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_HDMI is not set
CONFIG_SND_HDA_I915=y
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
CONFIG_SND_HDA_CODEC_CONEXANT=y
# CONFIG_SND_HDA_CODEC_CA0110 is not set
CONFIG_SND_HDA_CODEC_CA0132=y
# CONFIG_SND_HDA_CODEC_CA0132_DSP is not set
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_SPI is not set
# CONFIG_SND_USB is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
CONFIG_SND_DICE=y
CONFIG_SND_FIREWIRE_SPEAKERS=y
CONFIG_SND_ISIGHT=y
CONFIG_SND_SCS1X=y
CONFIG_SND_SOC=y
CONFIG_SND_ATMEL_SOC=y
CONFIG_SND_DESIGNWARE_I2S=y
CONFIG_SND_SOC_INTEL_SST=y
CONFIG_SND_SOC_INTEL_SST_ACPI=y
# CONFIG_SND_SOC_INTEL_HASWELL_MACH is not set
# CONFIG_SND_SOC_INTEL_BYT_RT5640_MACH is not set
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_ADAU1701=y
# CONFIG_SND_SOC_AK4104 is not set
CONFIG_SND_SOC_AK4554=y
CONFIG_SND_SOC_AK4642=y
CONFIG_SND_SOC_AK5386=y
CONFIG_SND_SOC_CS42L52=y
CONFIG_SND_SOC_CS42L73=y
CONFIG_SND_SOC_CS4270=y
# CONFIG_SND_SOC_CS4271 is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
# CONFIG_SND_SOC_HDMI_CODEC is not set
CONFIG_SND_SOC_PCM1681=y
# CONFIG_SND_SOC_PCM1792A is not set
CONFIG_SND_SOC_PCM512x=y
CONFIG_SND_SOC_PCM512x_I2C=y
CONFIG_SND_SOC_PCM512x_SPI=y
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=y
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_TAS5086=y
CONFIG_SND_SOC_TLV320AIC3X=y
# CONFIG_SND_SOC_WM8510 is not set
CONFIG_SND_SOC_WM8523=y
# CONFIG_SND_SOC_WM8580 is not set
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8728=y
CONFIG_SND_SOC_WM8731=y
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
# CONFIG_SND_SOC_WM8770 is not set
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8962=y
CONFIG_SND_SOC_TPA6130A2=y
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
# CONFIG_SOUND_VMIDI is not set
CONFIG_SOUND_TRIX=y
# CONFIG_TRIX_HAVE_BOOT is not set
# CONFIG_SOUND_MSS is not set
# CONFIG_SOUND_MPU401 is not set
CONFIG_SOUND_PAS=y
# CONFIG_PAS_JOYSTICK is not set
CONFIG_SOUND_PSS=y
# CONFIG_PSS_MIXER is not set
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=y
CONFIG_SOUND_YM3812=y
# CONFIG_SOUND_UART6850 is not set
CONFIG_SOUND_AEDSP16=y
# CONFIG_SC6600 is not set
# CONFIG_SOUND_KAHLUA is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CP2112=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PICOLCD_CIR=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=y
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
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
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y
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
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=y
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
CONFIG_USB_MUSB_GADGET=y
# CONFIG_USB_MUSB_DUAL_ROLE is not set
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
CONFIG_USB_DWC3_EXYNOS=y
# CONFIG_USB_DWC3_PCI is not set
CONFIG_USB_DWC3_KEYSTONE=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
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
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=y
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_XSENS_MT=y
CONFIG_USB_SERIAL_WISHBONE=y
CONFIG_USB_SERIAL_ZTE=y
CONFIG_USB_SERIAL_SSU100=y
CONFIG_USB_SERIAL_QT2=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
# CONFIG_USB_XUSBATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_TAHVO_USB=y
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FUSB300 is not set
# CONFIG_USB_FOTG210_UDC is not set
# CONFIG_USB_GR_UDC is not set
CONFIG_USB_R8A66597=y
# CONFIG_USB_RENESAS_USBHS_UDC is not set
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_S3C_HSOTG is not set
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
# CONFIG_USB_M66592 is not set
CONFIG_USB_AMD5536UDC=y
CONFIG_USB_NET2272=y
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
CONFIG_USB_GOKU=y
CONFIG_USB_EG20T=y
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
CONFIG_USB_MIDI_GADGET=y
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_SDHCI_PXAV3 is not set
# CONFIG_MMC_SDHCI_PXAV2 is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
# CONFIG_MMC_USHC is not set
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
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
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
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_LP8788=y
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8925 is not set
# CONFIG_RTC_DRV_MAX8998 is not set
# CONFIG_RTC_DRV_MAX8997 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TWL4030 is not set
# CONFIG_RTC_DRV_TPS6586X is not set
CONFIG_RTC_DRV_RC5T583=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1347=y
# CONFIG_RTC_DRV_DS1390 is not set
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
# CONFIG_RTC_DRV_DS3234 is not set
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_MOXART is not set

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
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
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
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_ET131X=y
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=y
# CONFIG_USBIP_VHCI_HCD is not set
# CONFIG_USBIP_HOST is not set
# CONFIG_USBIP_DEBUG is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_RTS5139 is not set
# CONFIG_RTS5208 is not set
# CONFIG_TRANZPORT is not set
CONFIG_LINE6_USB=y
CONFIG_LINE6_USB_IMPULSE_RESPONSE=y
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=y
CONFIG_ADIS16203=y
# CONFIG_ADIS16204 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=y
CONFIG_LIS3L02DQ=y
CONFIG_SCA3000=y

#
# Analog to digital converters
#
CONFIG_AD7291=y
# CONFIG_AD7606 is not set
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y
CONFIG_AD7780=y
CONFIG_AD7816=y
# CONFIG_AD7192 is not set
CONFIG_AD7280=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_SPI=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#
CONFIG_AD5930=y
CONFIG_AD9832=y
CONFIG_AD9834=y
CONFIG_AD9850=y
CONFIG_AD9852=y
CONFIG_AD9910=y
CONFIG_AD9951=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
CONFIG_TSL2583=y
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
CONFIG_ADE7753=y
CONFIG_ADE7754=y
CONFIG_ADE7758=y
CONFIG_ADE7759=y
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
CONFIG_ADE7854_SPI=y

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
CONFIG_AD2S1200=y
CONFIG_AD2S1210=y

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
CONFIG_BCM_WIMAX=y
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=y
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_XILLYBUS is not set
CONFIG_DGNC=y
CONFIG_DGAP=y
CONFIG_GS_FPGABOOT=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACERHDF=y
CONFIG_ALIENWARE_WMI=y
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_AMILO_RFKILL is not set
CONFIG_TC1100_WMI=y
CONFIG_HP_ACCEL=y
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=y
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
# CONFIG_SONY_LAPTOP is not set
CONFIG_IDEAPAD_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_ALSA_SUPPORT is not set
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
# CONFIG_THINKPAD_ACPI_VIDEO is not set
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_INTEL_MENLOW=y
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
# CONFIG_ASUS_NB_WMI is not set
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=y
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_WM831X is not set
CONFIG_COMMON_CLK_SI5351=y
CONFIG_CLK_TWL6040=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

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
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_MAX14577 is not set
CONFIG_EXTCON_MAX77693=y
# CONFIG_EXTCON_MAX8997 is not set
CONFIG_EXTCON_ARIZONA=y
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
CONFIG_BMA180=y
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
# CONFIG_KXSD9 is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
CONFIG_AD7476=y
CONFIG_AD7791=y
CONFIG_AD7793=y
# CONFIG_AD7887 is not set
CONFIG_AD7923=y
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=y
CONFIG_MCP320X=y
CONFIG_MCP3422=y
CONFIG_MEN_Z188_ADC=y
CONFIG_NAU7802=y
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=y
CONFIG_TWL4030_MADC=y
# CONFIG_TWL6030_GPADC is not set
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

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
# CONFIG_AD5064 is not set
CONFIG_AD5360=y
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
CONFIG_AD5504=y
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5686=y
# CONFIG_AD5755 is not set
CONFIG_AD5764=y
CONFIG_AD5791=y
CONFIG_AD7303=y
CONFIG_MAX517=y
CONFIG_MCP4725=y

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
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
CONFIG_ADIS16136=y
CONFIG_ADIS16260=y
# CONFIG_ADXRS450 is not set
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_DHT11=y
CONFIG_SI7005=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
CONFIG_CM32181=y
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
# CONFIG_HID_SENSOR_ALS is not set
CONFIG_HID_SENSOR_PROX=y
CONFIG_SENSORS_LM3533=y
# CONFIG_LTR501 is not set
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_MAG3110 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
# CONFIG_HID_SENSOR_PRESS is not set
# CONFIG_MPL3115 is not set
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
CONFIG_TMP006=y
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_SAMSUNG_USB2 is not set
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
CONFIG_GOOGLE_MEMCONSOLE=y

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
# CONFIG_EFI_VARS_PSTORE is not set
CONFIG_EFI_RUNTIME_MAP=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
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
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

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
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_EFIVAR_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CEPH_FS=y
# CONFIG_CEPH_FS_POSIX_ACL is not set
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_9P_FS_SECURITY=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

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
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
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
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

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
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_EARLY_PRINTK_EFI=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
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
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
# CONFIG_SECURITY_SELINUX_AVC_STATS is not set
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_AUDIT=y
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
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
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y

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
# CONFIG_CRYPTO_CTS is not set
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
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_GEODE=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
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
CONFIG_AUDIT_GENERIC=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--+HP7ph2BbKc20aGI--
