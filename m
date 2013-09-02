Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab3IBKXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:23:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:11857 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab3IBKXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:23:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="log'?scan'208";a="389888616"
Date: Mon, 2 Sep 2013 18:23:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Hante Meuleman <meuleman@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: [brcmfmac] BUG: unable to handle kernel paging request at
 ffffffff82196446
Message-ID: <20130902102327.GB14264@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 668761ac01d6f5a36b8e5a24d4e154550e2c4c3b
Author: Hante Meuleman <meuleman@broadcom.com>
Date:   Fri Apr 12 10:55:55 2013 +0200

    brcmfmac: define and use platform specific data for SDIO.
    
    This patch adds support for platform specific data for SDIO
    fullmac devices. Currently OOB interrupts are configured by Kconfig
    BRCMFMAC_SDIO_OOB but that is now determined dynamically by checking
    availibility of platform data.
    
    Cc: Hauke Mehrtens <hauke@hauke-m.de>
    Reviewed-by: Arend Van Spriel <arend@broadcom.com>
    Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
    Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
    Reviewed-by: Piotr Haber <phaber@broadcom.com>
    Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
    Signed-off-by: Arend van Spriel <arend@broadcom.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


[   48.966342] Switched to clocksource tsc
[   48.970002] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[   48.970851] BUG: unable to handle kernel paging request at ffffffff82196446
[   48.970957] IP: [<ffffffff82196446>] classes_init+0x26/0x26
[   48.970957] PGD 1e76067 PUD 1e77063 PMD f388063 PTE 8000000002196163
[   48.970957] Oops: 0011 [#1] 
[   48.970957] CPU: 0 PID: 17 Comm: kworker/0:1 Not tainted 3.11.0-rc7-00444-gc52dd7f #23
[   48.970957] Workqueue: events brcmf_driver_init
[   48.970957] task: ffff8800001d2000 ti: ffff8800001d4000 task.ti: ffff8800001d4000
[   48.970957] RIP: 0010:[<ffffffff82196446>]  [<ffffffff82196446>] classes_init+0x26/0x26
[   48.970957] RSP: 0000:ffff8800001d5d40  EFLAGS: 00000286
[   48.970957] RAX: 0000000000000001 RBX: ffffffff820c5620 RCX: 0000000000000000
[   48.970957] RDX: 0000000000000001 RSI: ffffffff816f7380 RDI: ffffffff820c56c0
[   48.970957] RBP: ffff8800001d5d50 R08: ffff8800001d2508 R09: 0000000000000002
[   48.970957] R10: 0000000000000000 R11: 0001f7ce298c5620 R12: ffff8800001c76b0
[   48.970957] R13: ffffffff81e91d40 R14: 0000000000000000 R15: ffff88000e0ce300
[   48.970957] FS:  0000000000000000(0000) GS:ffffffff81e84000(0000) knlGS:0000000000000000
[   48.970957] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   48.970957] CR2: ffffffff82196446 CR3: 0000000001e75000 CR4: 00000000000006b0
[   48.970957] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   48.970957] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[   48.970957] Stack:
[   48.970957]  ffffffff816f7df8 ffffffff820c5620 ffff8800001d5d60 ffffffff816eeec9
[   48.970957]  ffff8800001d5de0 ffffffff81073dc5 ffffffff81073d68 ffff8800001d5db8
[   48.970957]  0000000000000086 ffffffff820c5620 ffffffff824f7fd0 0000000000000000
[   48.970957] Call Trace:
[   48.970957]  [<ffffffff816f7df8>] ? brcmf_sdio_init+0x18/0x70
[   48.970957]  [<ffffffff816eeec9>] brcmf_driver_init+0x9/0x10
[   48.970957]  [<ffffffff81073dc5>] process_one_work+0x1d5/0x480
[   48.970957]  [<ffffffff81073d68>] ? process_one_work+0x178/0x480
[   48.970957]  [<ffffffff81074188>] worker_thread+0x118/0x3a0
[   48.970957]  [<ffffffff81074070>] ? process_one_work+0x480/0x480
[   48.970957]  [<ffffffff8107aa17>] kthread+0xe7/0xf0
[   48.970957]  [<ffffffff810829f7>] ? finish_task_switch.constprop.57+0x37/0xd0
[   48.970957]  [<ffffffff8107a930>] ? __kthread_parkme+0x80/0x80
[   48.970957]  [<ffffffff81a6923a>] ret_from_fork+0x7a/0xb0
[   48.970957]  [<ffffffff8107a930>] ? __kthread_parkme+0x80/0x80
[   48.970957] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 
[   48.970957] RIP  [<ffffffff82196446>] classes_init+0x26/0x26
[   48.970957]  RSP <ffff8800001d5d40>
[   48.970957] CR2: ffffffff82196446
[   48.970957] ---[ end trace 62980817cd525f14 ]---

git bisect start v3.10 v3.9 --
git bisect  bad 20b4fb485227404329e41ad15588afad3df23050  # 12:16      9-  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect good 19b344efa35dbc253e2d10403dafe6aafda73c56  # 17:54    800+  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect  bad 20074f357da4a637430aec2879c9d864c5d2c23c  # 18:03      1-  filter: fix va_list build error
git bisect good 953c96e0d85615d1ab1f100e525d376053294dc2  # 21:38    800+  tg3: Use bool not int
git bisect  bad 4de41bef3e075dbc787f7c53b3562f23295f1d6d  # 22:21    102-  wil6210: Use cached copy of Tx descriptor
git bisect good e73dcfbf061b524fe9aaef56cf3c2e234a45ec19  # 01:19    800+  Bluetooth: hidp: fix sending output reports on intr channel
git bisect good c79490e1b5ebf35415147fe06f02d8e77ccfe6d4  # 07:18    800+  NFC: pn533: Avoid function declarations
git bisect  bad 06d961a8e210035bff7e82f466107f9ab4a8fd94  # 07:49     55-  mac80211/minstrel: use the new rate control API
git bisect good 97990a060e6757f48b931a3946b17c1c4362c3fb  # 10:43    800+  nl80211: allow using wdev identifiers to get scan results
git bisect  bad 31ed07dc1e83b7926ce8ee2215ea21599a215990  # 11:15     77-  brcmfmac: remove ifidx variable from brcmf_fws_process_skb()
git bisect good 1e9ab4dd258ecbb0f1c377fd4dbe227cdb93d9bd  # 14:16    800+  brcmfmac: setup SDIO reset behavior
git bisect  bad 668761ac01d6f5a36b8e5a24d4e154550e2c4c3b  # 15:03     38-  brcmfmac: define and use platform specific data for SDIO.
git bisect good 369508c5656db290f09b32d213effeea6c1431b8  # 18:30    800+  brcmfmac: Add 43143 SDIO support.
git bisect good 979c29205ffa607c59ba2c9f9c083b967d356c97  # 19:54    800+  brcmfmac: Add drive strength programming for SDIO 43143.
git bisect good 979c29205ffa607c59ba2c9f9c083b967d356c97  # 05:19   2400+  brcmfmac: Add drive strength programming for SDIO 43143.
git bisect  bad c52dd7f94c5d5386413cb95462ac802847fa5f3a  # 05:20      0-  Merge remote-tracking branch 'sound/for-linus' into devel-cairo-x86_64-201308281454
git bisect  bad d9eda0fae1394ea1e1c59c94d4a120ad9c06e64a  # 11:50     27-  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect  bad 797c8d18e6804f054e68555e6cf827827b6a073c  # 12:47      1-  Add linux-next specific files for 20130830

Thanks,
Fengguang

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-9274-20130828152722-3.11.0-rc7-00444-gc52dd7f-23"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.11.0-rc7-00444-gc52dd7f (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #23 Wed Aug 28 15:18:19 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-c3-0828/devel-cairo-x86_64-20130=
8281454/.vmlinuz-c52dd7f94c5d5386413cb95462ac802847fa5f3a-20130828151901-4-=
ant branch=3Dlinux-devel/devel-cairo-x86_64-201308281454 noapic nolapic noh=
z=3Doff BOOT_IMAGE=3D/kernel/x86_64-randconfig-c3-0828/c52dd7f94c5d5386413c=
b95462ac802847fa5f3a/vmlinuz-3.11.0-rc7-00444-gc52dd7f
[    0.000000] KERNEL supported cpus:
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02bc5000, 0x02bc5fff] PGTABLE
[    0.000000] BRK [0x02bc6000, 0x02bc6fff] PGTABLE
[    0.000000] BRK [0x02bc7000, 0x02bc7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02bc8000, 0x02bc8fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127916(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 896 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 0, APIC =
INT 0a
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c3-0828/devel-cairo-x86_64=
-201308281454/.vmlinuz-c52dd7f94c5d5386413cb95462ac802847fa5f3a-20130828151=
901-4-ant branch=3Dlinux-devel/devel-cairo-x86_64-201308281454 noapic nolap=
ic nohz=3Doff BOOT_IMAGE=3D/kernel/x86_64-randconfig-c3-0828/c52dd7f94c5d53=
86413cb95462ac802847fa5f3a/vmlinuz-3.11.0-rc7-00444-gc52dd7f
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 197308K/261744K available (10666K kernel code, 3112K=
 rwdata, 4076K rodata, 692K init, 9872K bss, 64436K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: 6 of 6 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3192.026 MHz processor
[    0.040865] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6384.05 BogoMIPS (lpj=3D12768104)
[    0.045259] pid_max: default: 32768 minimum: 301
[    0.051443] Mount-cache hash table entries: 256
[    0.091557] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.091557] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.091557] tlb_flushall_shift: -1
[    0.092312] CPU: AuthenticAMD QEMU Virtual CPU version 1.5.0 (fam: 06, m=
odel: 02, stepping: 03)
[    0.122991] ACPI: Core revision 20130517
[    0.393582] ACPI: All ACPI Tables successfully acquired
[    0.394940] ACPI: setting ELCR to 0200 (from 0c00)
[    0.425865] Performance Events:=20
[    0.452314] Apic disabled
[    0.456645] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.502333] xor: measuring software checksum speed
[    0.548394]    prefetch64-sse:   276.000 MB/sec
[    0.588173]    generic_sse:   276.000 MB/sec
[    0.588740] xor: using function: generic_sse (276.000 MB/sec)
[    0.614678] regulator-dummy: no parameters
[    0.624832] NET: Registered protocol family 16
[    0.661425] ACPI: bus type PCI registered
[    0.666914] PCI: Using configuration type 1 for base access
[    1.050789] bio: create slab <bio-0> at 0
[    1.136615] raid6: sse2x1      63 MB/s
[    1.208782] raid6: sse2x2      48 MB/s
[    1.280361] raid6: sse2x4      44 MB/s
[    1.280930] raid6: using algorithm sse2x1 (63 MB/s)
[    1.281610] raid6: using intx1 recovery algorithm
[    1.305774] ACPI: Added _OSI(Module Device)
[    1.306277] ACPI: Added _OSI(Processor Device)
[    1.306705] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.307129] ACPI: Added _OSI(Processor Aggregator Device)
[    1.446959] ACPI: EC: Look up EC in DSDT
[    1.977766] ACPI: Interpreter enabled
[    1.979106] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130517/hwxface-571)
[    1.980915] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130517/hwxface-571)
[    1.986613] ACPI: (supports S0 S3 S4 S5)
[    1.987382] ACPI: Using PIC for interrupt routing
[    1.993825] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    2.733718] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.768750] PCI host bridge to bus 0000:00
[    2.770282] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.771380] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.772162] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.772806] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    2.773374] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    2.777954] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    2.800438] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    2.808343] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    2.820290] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    2.839385] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    2.842421] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    2.843168] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    2.862388] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    2.866313] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    2.872266] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    2.896253] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    2.908284] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    2.912246] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    2.918023] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    2.938107] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    2.954150] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    2.958073] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    2.964200] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    2.984245] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    3.005403] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    3.010185] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    3.014046] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    3.050516] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    3.056209] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    3.060212] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    3.101167] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    3.106181] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    3.112258] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    3.152223] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    3.156275] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    3.161995] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    3.202190] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    3.206068] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    3.212197] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    3.253827] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    3.258133] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    3.264273] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    3.301872] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    3.305255] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    3.336382] pci_bus 0000:00: on NUMA node 0
[    3.337174] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    3.393671] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    3.406408] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    3.417195] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    3.428327] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    3.433390] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    3.475207] ACPI: Enabled 16 GPEs in block 00 to 0F
[    3.477109] ACPI: \_SB_.PCI0: notify handler is installed
[    3.482107] Found 1 acpi root devices
[    3.521478] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    3.522614] vgaarb: loaded
[    3.523031] vgaarb: bridge control possible 0000:00:02.0
[    3.530059] tps65010: version 2 May 2005
[    3.566484] tps65010: no chip?
[    3.589352] SCSI subsystem initialized
[    3.590243] ACPI: bus type ATA registered
[    3.594443] libata version 3.00 loaded.
[    3.601768] media: Linux media interface: v0.10
[    3.603557] Linux video capture interface: v2.00
[    3.608594] pps_core: LinuxPPS API ver. 1 registered
[    3.609246] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    3.610851] PTP clock support registered
[    3.616650] EDAC MC: Ver: 3.0.0
[    3.637542] Advanced Linux Sound Architecture Driver Initialized.
[    3.638238] PCI: Using ACPI for IRQ routing
[    3.639169] PCI: pci_cache_line_size set to 64 bytes
[    3.642963] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    3.644839] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    3.698966] NET: Registered protocol family 23
[    3.702170] NET: Registered protocol family 8
[    3.704299] NET: Registered protocol family 20
[    3.731345] cfg80211: Calling CRDA to update world regulatory domain
[    3.773571] Switched to clocksource hpet
[    3.776000] FS-Cache: Loaded
[    3.776000] pnp: PnP ACPI init
[    3.776000] ACPI: bus type PNP registered
[    3.832897] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.838511] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    3.860343] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    3.873476] pnp 00:03: [dma 2]
[    3.891057] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    3.910630] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    3.918024] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.974434] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    4.012167] pnp: PnP ACPI: found 7 devices
[    4.012958] ACPI: bus type PNP unregistered
[    4.080538] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.081297] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.081956] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.083115] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    4.084530] NET: Registered protocol family 1
[    4.085446] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    4.086251] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    4.100585] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    4.101801] pci 0000:00:02.0: Boot video device
[    4.103454] PCI: CLS 0 bytes, default 64
[    4.145245] Trying to unpack rootfs image as initramfs...
[   34.195346] [sched_delayed] sched: RT throttling activated
[   42.499381] Freeing initrd memory: 23656K (ffff88000e8d6000 - ffff88000f=
ff0000)
[   44.077069] DMA-API: preallocated 65536 debug entries
[   44.077757] DMA-API: debugging enabled by kernel config
[   44.097022] Scanning for low memory corruption every 60 seconds
[   44.115975] cryptomgr_test (18) used greatest stack depth: 7000 bytes le=
ft
[   44.183775] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[   44.184626] PCLMULQDQ-NI instructions are not detected.
[   44.185317] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[   44.186124] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[   44.187382] AVX or AES-NI instructions are not detected.
[   44.188086] AVX instructions are not detected.
[   44.188687] AVX instructions are not detected.
[   44.189280] AVX instructions are not detected.
[   44.240391] Initializing RT-Tester: OK
[   44.268286] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   44.280087] VFS: Disk quotas dquot_6.5.2
[   44.281141] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   44.299210] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   44.327397] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[   44.330090] ROMFS MTD (C) 2007 Red Hat, Inc.
[   44.331909] QNX4 filesystem 0.2.3 registered.
[   44.332794] QNX6 filesystem 1.0.0 registered.
[   44.333351] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, debug enabled
[   44.348187] NILFS version 2 loaded
[   44.348794] BeFS version: 0.9.3
[   44.349635] OCFS2 1.5.0
[   44.360488] ocfs2 stack glue: unable to register sysctl
[   44.361477] ocfs2: Registered cluster interface o2cb
[   44.362190] OCFS2 DLMFS 1.5.0
[   44.365764] OCFS2 User DLM kernel interface loaded
[   44.366440] OCFS2 Node Manager 1.5.0
[   44.460539] OCFS2 DLM 1.5.0
[   44.467500] bio: create slab <bio-1> at 1
[   44.476321] Btrfs loaded
[   44.476776] btrfs: selftest: Running btrfs free space cache tests
[   44.477720] btrfs: selftest: Running extent only tests
[   44.483770] btrfs: selftest: Running bitmap only tests
[   44.489306] btrfs: selftest: Running bitmap and extent tests
[   44.493639] btrfs: selftest: Free space cache tests finished
[   44.509802] GFS2 installed
[   44.516283] msgmni has been set to 431
[   44.621745] NET: Registered protocol family 38
[   44.623929] async_tx: api initialized (async)
[   44.624926] Key type asymmetric registered
[   44.625733] Asymmetric key parser 'x509' registered
[   44.627876] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[   44.629195] io scheduler noop registered
[   44.629794] io scheduler deadline registered (default)
[   44.716528] no IO addresses supplied
[   44.721807] hgafb: HGA card not detected.
[   44.723960] hgafb: probe of hgafb.0 failed with error -22
[   44.753026] kworker/u2:0 (96) used greatest stack depth: 6592 bytes left
[   44.761159] uvesafb: failed to execute /sbin/v86d
[   44.761826] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[   44.763471] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[   44.764455] uvesafb: vbe_init() failed with -22
[   44.765544] uvesafb: probe of uvesafb.0 failed with error -22
[   44.769744] ipmi message handler version 39.2
[   44.772175] IPMI System Interface driver.
[   44.776833] ipmi_si: Adding default-specified kcs state machine
[   44.777967] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   44.780654] ipmi_si: Interface detection failed
[   44.783552] ipmi_si: Adding default-specified smic state machine
[   44.784401] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   44.785865] ipmi_si: Interface detection failed
[   44.787132] ipmi_si: Adding default-specified bt state machine
[   44.787945] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   44.789754] ipmi_si: Interface detection failed
[   44.795641] ipmi_si: Unable to find any System Interface(s)
[   44.798000] IPMI Watchdog: driver initialized
[   44.813226] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   44.815269] ACPI: Power Button [PWRF]
[   45.679728] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   45.713049] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   45.748053] Non-volatile memory driver v1.3
[   45.765803] ppdev: user-space parallel port driver
[   45.767546] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   45.780392] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[   45.988747] brd: module loaded
[   46.015402] nbd: registered device at major 43
[   46.212461] lkdtm: No crash points registered, enable through debugfs
[   46.243236] Uniform Multi-Platform E-IDE driver
[   46.246280] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[   46.248034] ide-gd driver 1.18
[   46.249286] ide-cd driver 5.00
[   46.261466] hp_sw: device handler registered
[   46.262210] emc: device handler registered
[   46.268763] SCSI Media Changer driver v0.25=20
[   46.272567] osd: LOADED open-osd 0.2.1
[   46.279919] HSI/SSI char device loaded
[   46.308207] Floppy drive(s): fd0 is 1.44M
[   46.314074] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[   46.387582] libphy: Fixed MDIO Bus: probed
[   46.404906] tun: Universal TUN/TAP device driver, 1.6
[   46.405499] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   46.408911] arcnet loaded.
[   46.409432] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[   46.410235] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[   46.411529] arcnet: cap mode (`c') encapsulation support loaded.
[   46.412654] arcnet: COM90xx chipset support
[   46.744068] S3: No ARCnet cards found.
[   46.745548] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[   46.746268] E-mail me if you actually test this driver, please!
[   46.747481]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[   46.750271] arcnet: RIM I (entirely mem-mapped) support
[   46.751440] E-mail me if you actually test the RIM I driver, please!
[   46.752167] Given: node 00h, shmem 0h, irq 0
[   46.752674] No autoprobe for RIM I; you must specify the shmem and irq!
[   46.754095] YAM driver version 0.8 by F1OAT/F6FBB
[   46.784442] AX.25: bpqether driver version 004
[   46.785082] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   46.785082] baycom_ser_fdx: version 0.10
[   46.821407] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   46.822121] hdlcdrv: version 0.8
[   46.822546] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   46.822546] baycom_ser_hdx: version 0.10
[   46.855930] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   46.855930] baycom_par: version 0.9
[   46.897296] PPP generic driver version 2.4.2
[   46.904769] PPP MPPE Compression module registered
[   46.905435] NET: Registered protocol family 24
[   46.908913] airo(): Probing for PCI adapters
[   46.911151] airo(): Finished probing for PCI adapters
[   46.913889] Broadcom 43xx driver loaded [ Features: PML ]
[   46.915513] Broadcom 43xx-legacy driver loaded [ Features: PLID ]
[   46.923090] libertas_sdio: Libertas SDIO driver
[   46.923776] libertas_sdio: Copyright Pierre Ossman
[   46.925562] libertas_spi: Libertas SPI driver
[   46.936391] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   46.953601] serio: i8042 KBD port at 0x60,0x64 irq 1
[   46.955703] serio: i8042 AUX port at 0x60,0x64 irq 12
[   46.957344] parkbd: no such parport
[   46.968986] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[   47.017887] input: PC Speaker as /devices/platform/pcspkr/input/input1
[   47.020816] evbug: Connected device: input1 (PC Speaker at isa0061/input=
0)
[   47.037521] lirc_dev: IR Remote Control driver registered, major 247=20
[   47.039342] IR RC5(x) protocol handler initialized
[   47.039884] IR JVC protocol handler initialized
[   47.040308] IR SANYO protocol handler initialized
[   47.040798] IR LIRC bridge handler initialized
[   47.042230] Driver for 1-wire Dallas network protocol.
[   47.080638] applesmc: supported laptop not found!
[   47.081332] applesmc: driver init failed (ret=3D-19)!
[   47.117564] pc87360: PC8736x not detected, module not inserted
[   47.137647] md: linear personality registered for level -1
[   47.138456] md: raid0 personality registered for level 0
[   47.139762] md: raid1 personality registered for level 1
[   47.140347] md: raid6 personality registered for level 6
[   47.140997] md: raid5 personality registered for level 5
[   47.141568] md: raid4 personality registered for level 4
[   47.142216] md: multipath personality registered for level -4
[   47.143391] md: faulty personality registered for level -5
[   47.144566] cpuidle: using governor ladder
[   47.145176] cpuidle: using governor menu
[   47.146569] sdhci: Secure Digital Host Controller Interface driver
[   47.147781] sdhci: Copyright(c) Pierre Ossman
[   47.148319] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   47.149020] wbsd: Copyright(c) Pierre Ossman
[   47.151873] sdhci-pltfm: SDHCI platform and OF driver helper
[   47.180167] hidraw: raw HID events driver (C) Jiri Kosina
[   47.218080] lirc_serial lirc_serial.0: port 03f8 already in use
[   47.219475] lirc_serial lirc_serial.0: use 'setserial /dev/ttySX uart no=
ne'
[   47.220303] lirc_serial lirc_serial.0: or compile the serial port driver=
 as module and
[   47.221122] lirc_serial lirc_serial.0: make sure this module is loaded f=
irst
[   47.222440] lirc_serial: probe of lirc_serial.0 failed with error -16
[   47.227547] platform lirc_serial.0: lirc_dev: driver lirc_serial registe=
red at minor =3D 0
[   47.228441] lirc_zilog: Zilog/Hauppauge IR driver initializing
[   47.230098] lirc_zilog: initialization complete
[   47.231601] panel: driver version 0.9.5 not yet registered
[   47.280819] zram: Created 1 device(s) ...
[   47.284086] logger: created 256K log 'log_main'
[   47.286043] logger: created 256K log 'log_events'
[   47.288655] logger: created 256K log 'log_radio'
[   47.291376] logger: created 256K log 'log_system'
[   47.293147] hdaps: supported laptop not found!
[   47.293669] hdaps: driver init failed (ret=3D-19)!
[   47.568139] no UART detected at 0x1
[   47.612819] NET: Registered protocol family 26
[   47.614330] GACT probability NOT on
[   47.615872] Mirror/redirect action on
[   47.626253] netem: version 1.3
[   47.627639] u32 classifier
[   47.628006]     Actions configured
[   47.632440] NET: Registered protocol family 17
[   47.640782] NET: Registered protocol family 5
[   47.676136] NET: Registered protocol family 6
[   47.762447] NET: Registered protocol family 11
[   47.765364] NET: Registered protocol family 3
[   47.766454] lec:lane_module_init: lec.c: initialized
[   47.767490] lib80211: common routines for IEEE802.11 drivers
[   47.768543] lib80211_crypt: registered algorithm 'NULL'
[   47.770170] lib80211_crypt: registered algorithm 'WEP'
[   47.771438] lib80211_crypt: registered algorithm 'CCMP'
[   47.772119] lib80211_crypt: registered algorithm 'TKIP'
[   47.775643] 9pnet: Installing 9P2000 support
[   47.777374] NET: Registered protocol family 36
[   47.792934] batman_adv: B.A.T.M.A.N. advanced 2013.3.0 (compatibility ve=
rsion 14) loaded
[   47.793913] openvswitch: Open vSwitch switching datapath
[   47.808716]=20
[   47.808716] printing PIC contents
[   47.810369] ... PIC  IMR: edb8
[   47.810948] ... PIC  IRR: 0001
[   47.811975] ... PIC  ISR: 0000
[   47.812400] ... PIC ELCR: 0200
[   47.827773] registered taskstats version 1
[   47.862183] cryptomgr_probe (100) used greatest stack depth: 6216 bytes =
left
[   47.865793] Key type trusted registered
[   47.876048] Key type encrypted registered
[   47.896241] raid6test: testing the 4-disk case...
[   47.904279] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   47.907217] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P) =
 OK
[   47.908896] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q) =
 OK
[   47.912130] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P) =
 OK
[   47.913293] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q) =
 OK
[   47.915321] raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q) =
 OK
[   47.918568] raid6test: testing the 5-disk case...
[   47.923573] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   47.925335] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   47.927548] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P) =
 OK
[   47.929971] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q) =
 OK
[   47.932285] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   47.933972] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P) =
 OK
[   47.936051] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q) =
 OK
[   47.937728] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P) =
 OK
[   47.940660] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q) =
 OK
[   47.942122] raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q) =
 OK
[   47.947752] raid6test: testing the 11-disk case...
[   47.956333] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   47.958692] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   47.963263] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   47.965513] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   47.968339] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   47.972133] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   47.974326] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   47.977310] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   47.980880] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P) =
 OK
[   47.983269] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q)=
  OK
[   47.985584] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   47.988597] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   47.992511] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   47.994417] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   47.997194] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   48.001119] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   48.003971] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   48.006181] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P) =
 OK
[   48.010014] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q)=
  OK
[   48.012915] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   48.015366] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   48.017699] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   48.021349] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   48.024015] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   48.026278] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   48.029834] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P) =
 OK
[   48.032926] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q)=
  OK
[   48.035064] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   48.035064] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   48.041422] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   48.044919] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   48.047949] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   48.051663] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P) =
 OK
[   48.053804] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q)=
  OK
[   48.056604] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   48.060226] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   48.062538] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   48.065324] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   48.068061] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P) =
 OK
[   48.071377] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q)=
  OK
[   48.073681] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   48.076637] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   48.080143] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   48.082385] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P) =
 OK
[   48.085101] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q)=
  OK
[   48.087839] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   48.091358] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   48.093585] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P) =
 OK
[   48.096302] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q)=
  OK
[   48.098796] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   48.102261] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P) =
 OK
[   48.104864] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q)=
  OK
[   48.107732] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P) =
 OK
[   48.110569] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q)=
  OK
[   48.113240] raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q)=
  OK
[   48.127567] raid6test: testing the 12-disk case...
[   48.130817] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   48.133653] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   48.136663] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   48.140210] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   48.142795] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   48.145692] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   48.148593] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   48.152365] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   48.155165] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[   48.157455] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P)=
  OK
[   48.161371] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q)=
  OK
[   48.164324] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   48.167253] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   48.170332] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   48.173208] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   48.176240] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   48.178806] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   48.182297] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   48.185245] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[   48.188106] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P)=
  OK
[   48.191675] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q)=
  OK
[   48.194040] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   48.196927] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   48.200654] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   48.203480] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   48.205875] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   48.208759] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   48.212373] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[   48.215232] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P)=
  OK
[   48.217467] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q)=
  OK
[   48.220998] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   48.223919] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   48.226271] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   48.229802] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   48.232884] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   48.235704] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[   48.237977] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P)=
  OK
[   48.241698] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q)=
  OK
[   48.244628] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   48.247540] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   48.250796] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   48.253565] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   48.256587] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[   48.260110] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P)=
  OK
[   48.262353] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q)=
  OK
[   48.265320] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   48.268121] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   48.271901] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   48.274253] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[   48.277111] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P)=
  OK
[   48.280743] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q)=
  OK
[   48.283571] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   48.285937] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   48.289734] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[   48.292600] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P)=
  OK
[   48.295470] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q)=
  OK
[   48.297901] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   48.301581] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[   48.304603] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P)=
  OK
[   48.307411] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q)=
  OK
[   48.310275] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[   48.312948] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P)=
  OK
[   48.315117] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q)=
  OK
[   48.322103] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P)=
  OK
[   48.324751] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q)=
  OK
[   48.327670] raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q=
)  OK
[   48.336174] raid6test: testing the 16-disk case...
[   48.341133] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   48.345115] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   48.352994] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   48.361017] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   48.368053] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   48.375922] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   48.378506] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   48.382380] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   48.385644] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[   48.388857] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[   48.392422] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[   48.395404] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[   48.398040] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[   48.401870] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(P)=
  OK
[   48.404709] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(Q)=
  OK
[   48.407939] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   48.411688] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   48.414245] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   48.417232] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   48.420951] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   48.423976] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   48.426517] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   48.430209] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[   48.433142] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[   48.436119] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[   48.439936] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[   48.442442] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[   48.445421] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(P)=
  OK
[   48.448337] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(Q)=
  OK
[   48.452238] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   48.455142] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   48.457730] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   48.461587] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   48.467737] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   48.471344] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   48.473941] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[   48.476910] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[   48.480572] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[   48.483582] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[   48.486057] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[   48.489680] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(P)=
  OK
[   48.492546] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(Q)=
  OK
[   48.495487] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   48.498059] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   48.502006] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   48.505067] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   48.508119] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   48.511990] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[   48.514573] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[   48.517630] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[   48.521402] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[   48.524453] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[   48.527272] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(P)=
  OK
[   48.530358] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(Q)=
  OK
[   48.533378] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   48.536166] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   48.540446] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   48.543809] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   48.546761] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[   48.551004] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[   48.553875] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[   48.557241] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[   48.561220] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[   48.564493] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(P)=
  OK
[   48.567650] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(Q)=
  OK
[   48.571490] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   48.574328] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   48.577605] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   48.581703] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[   48.584912] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[   48.588279] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[   48.592316] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[   48.595710] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[   48.598484] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(P)=
  OK
[   48.602403] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(Q)=
  OK
[   48.605695] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   48.608924] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   48.613266] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[   48.616179] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[   48.620582] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[   48.623806] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[   48.626755] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[   48.630536] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(P)=
  OK
[   48.633696] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(Q)=
  OK
[   48.637038] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   48.640788] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[   48.643793] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[   48.646229] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[   48.649748] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[   48.652727] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[   48.655459] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(P)=
  OK
[   48.657826] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(Q)=
  OK
[   48.661757] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[   48.664564] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[   48.667426] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[   48.670506] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[   48.673460] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[   48.676298] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(P)=
  OK
[   48.679725] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(Q)=
  OK
[   48.682240] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[   48.685172] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[   48.688090] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[   48.691838] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[   48.694241] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(P)=
  OK
[   48.697003] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(Q)=
  OK
[   48.700849] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[   48.703847] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[   48.706295] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[   48.709886] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(P=
)  OK
[   48.712760] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(Q=
)  OK
[   48.715693] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[   48.718141] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[   48.721901] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(P=
)  OK
[   48.724804] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(Q=
)  OK
[   48.727643] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[   48.731510] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(P=
)  OK
[   48.733966] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(Q=
)  OK
[   48.736913] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(P=
)  OK
[   48.740489] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(Q=
)  OK
[   48.743170] raid6test: test_disks(14, 15): faila=3D 14(P)  failb=3D 15(Q=
)  OK
[   48.743795] raid6test:=20
[   48.744073] raid6test: complete (257 tests, 0 failures)
[   48.783025] FDC 0 is a S82078B
[   48.807053] hd: no drives specified - use hd=3Dcyl,head,sectors on kerne=
l command line
[   48.816646] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   48.817214] EDD information not available.
[   48.824659] ALSA device list:
[   48.825039]   #0: Dummy 1
[   48.825297]   #1: Loopback 1
[   48.825546]   #2: Virtual MIDI Card 1
[   48.963559] Freeing unused kernel memory: 692K (ffffffff82173000 - fffff=
fff82220000)
[   48.966342] Switched to clocksource tsc
[   48.970002] kernel tried to execute NX-protected page - exploit attempt?=
 (uid: 0)
[   48.970851] BUG: unable to handle kernel paging request at ffffffff82196=
446
[   48.970957] IP: [<ffffffff82196446>] classes_init+0x26/0x26
[   48.970957] PGD 1e76067 PUD 1e77063 PMD f388063 PTE 8000000002196163
[   48.970957] Oops: 0011 [#1]=20
[   48.970957] CPU: 0 PID: 17 Comm: kworker/0:1 Not tainted 3.11.0-rc7-0044=
4-gc52dd7f #23
[   48.970957] Workqueue: events brcmf_driver_init
[   48.970957] task: ffff8800001d2000 ti: ffff8800001d4000 task.ti: ffff880=
0001d4000
[   48.970957] RIP: 0010:[<ffffffff82196446>]  [<ffffffff82196446>] classes=
_init+0x26/0x26
[   48.970957] RSP: 0000:ffff8800001d5d40  EFLAGS: 00000286
[   48.970957] RAX: 0000000000000001 RBX: ffffffff820c5620 RCX: 00000000000=
00000
[   48.970957] RDX: 0000000000000001 RSI: ffffffff816f7380 RDI: ffffffff820=
c56c0
[   48.970957] RBP: ffff8800001d5d50 R08: ffff8800001d2508 R09: 00000000000=
00002
[   48.970957] R10: 0000000000000000 R11: 0001f7ce298c5620 R12: ffff8800001=
c76b0
[   48.970957] R13: ffffffff81e91d40 R14: 0000000000000000 R15: ffff88000e0=
ce300
[   48.970957] FS:  0000000000000000(0000) GS:ffffffff81e84000(0000) knlGS:=
0000000000000000
[   48.970957] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   48.970957] CR2: ffffffff82196446 CR3: 0000000001e75000 CR4: 00000000000=
006b0
[   48.970957] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   48.970957] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 00000000000=
00000
[   48.970957] Stack:
[   48.970957]  ffffffff816f7df8 ffffffff820c5620 ffff8800001d5d60 ffffffff=
816eeec9
[   48.970957]  ffff8800001d5de0 ffffffff81073dc5 ffffffff81073d68 ffff8800=
001d5db8
[   48.970957]  0000000000000086 ffffffff820c5620 ffffffff824f7fd0 00000000=
00000000
[   48.970957] Call Trace:
[   48.970957]  [<ffffffff816f7df8>] ? brcmf_sdio_init+0x18/0x70
[   48.970957]  [<ffffffff816eeec9>] brcmf_driver_init+0x9/0x10
[   48.970957]  [<ffffffff81073dc5>] process_one_work+0x1d5/0x480
[   48.970957]  [<ffffffff81073d68>] ? process_one_work+0x178/0x480
[   48.970957]  [<ffffffff81074188>] worker_thread+0x118/0x3a0
[   48.970957]  [<ffffffff81074070>] ? process_one_work+0x480/0x480
[   48.970957]  [<ffffffff8107aa17>] kthread+0xe7/0xf0
[   48.970957]  [<ffffffff810829f7>] ? finish_task_switch.constprop.57+0x37=
/0xd0
[   48.970957]  [<ffffffff8107a930>] ? __kthread_parkme+0x80/0x80
[   48.970957]  [<ffffffff81a6923a>] ret_from_fork+0x7a/0xb0
[   48.970957]  [<ffffffff8107a930>] ? __kthread_parkme+0x80/0x80
[   48.970957] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc =
cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc =
<cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc=20
[   48.970957] RIP  [<ffffffff82196446>] classes_init+0x26/0x26
[   48.970957]  RSP <ffff8800001d5d40>
[   48.970957] CR2: ffffffff82196446
[   48.970957] ---[ end trace 62980817cd525f14 ]---
[   48.970957] Kernel panic - not syncing: Fatal exception
[   48.970957] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 75
qemu-system-x86_64 -kernel /tmp//kernel/x86_64-randconfig-c3-0828/c52dd7f94=
c5d5386413cb95462ac802847fa5f3a/vmlinuz-3.11.0-rc7-00444-gc52dd7f-9274 -app=
end 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_buf_len=3D=
8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_alwa=
ys_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3D=
tty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x=
86_64-randconfig-c3-0828/devel-cairo-x86_64-201308281454/.vmlinuz-c52dd7f94=
c5d5386413cb95462ac802847fa5f3a-20130828151901-4-ant branch=3Dlinux-devel/d=
evel-cairo-x86_64-201308281454 noapic nolapic nohz=3Doff BOOT_IMAGE=3D/kern=
el/x86_64-randconfig-c3-0828/c52dd7f94c5d5386413cb95462ac802847fa5f3a/vmlin=
uz-3.11.0-rc7-00444-gc52dd7f'  -initrd /kernel-tests/initrd/quantal-core-x8=
6_64.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=
=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::13370-:22 -net nic,vlan=3D1,mod=
el=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300es=
b -drive file=3D/fs/sdc1/disk0-ant-9274,media=3Ddisk,if=3Dvirtio -drive fil=
e=3D/fs/sdc1/disk1-ant-9274,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1=
/disk2-ant-9274,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk3-ant-9=
274,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk4-ant-9274,media=3D=
disk,if=3Dvirtio -drive file=3D/fs/sdc1/disk5-ant-9274,media=3Ddisk,if=3Dvi=
rtio -pidfile /dev/shm/kboot/pid-ant-lkp-9274 -serial file:/dev/shm/kboot/s=
erial-ant-lkp-9274 -daemonize -display none -monitor null=20

--1yeeQ81UyVL57Vl7
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-c52dd7f94c5d5386413cb95462ac802847fa5f3a-x86_64-randconfig-c3-0828-BUG:-unable-to-handle-kernel-paging-request-at-121954.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGQ4ZGZhZDM4NzZlNDM4NjY2NmI3NTlkYTNjODMzZDYyZmI4YjIyNjcK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYzUyZGQ3Zi4uLiBNZXJnZSByZW1vdGUtdHJh
Y2tpbmcgYnJhbmNoICdzb3VuZC9mb3ItbGludXMnIGludG8gZGV2ZWwtY2Fpcm8teDg2XzY0
LTIwMTMwODI4MTQ1NApIRUFEIGlzIG5vdyBhdCBkOGRmYWQzLi4uIExpbnV4IDMuMTEtcmM3
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1j
My0wODI4L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDgyODE0NTQ6ZDhk
ZmFkMzg3NmU0Mzg2NjY2Yjc1OWRhM2M4MzNkNjJmYjhiMjI2NzpiaXNlY3QtdXNiCgoyMDEz
LTA4LTMwLTIwOjE1OjA2IGQ4ZGZhZDM4NzZlNDM4NjY2NmI3NTlkYTNjODMzZDYyZmI4YjIy
NjcgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4L2Q4ZGZhZDM4NzZl
NDM4NjY2NmI3NTlkYTNjODMzZDYyZmI4YjIyNjcvdm1saW51ei0zLjExLjAtcmM3CgoyMDEz
LTA4LTMwLTIwOjE1OjI0IGRldGVjdGluZyBib290IHN0YXRlIC4uLgkxMSBURVNUIEZBSUxV
UkUKWyAgIDIxLjk3NDgwNl0gU3dpdGNoZWQgdG8gY2xvY2tzb3VyY2UgdHNjClsgICAyMS45
NzY0NTddIGtlcm5lbCB0cmllZCB0byBleGVjdXRlIE5YLXByb3RlY3RlZCBwYWdlIC0gZXhw
bG9pdCBhdHRlbXB0PyAodWlkOiAwKQpbICAgMjEuOTc2OTMwXSBCVUc6IHVuYWJsZSB0byBo
YW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IGZmZmZmZmZmODI0YjA0NDYKWyAgIDIx
Ljk3NzM1Ml0gSVA6IFs8ZmZmZmZmZmY4MjRiMDQ0Nj5dIGNsYXNzZXNfaW5pdCsweDI2LzB4
MjYKWyAgIDIxLjk3NzM1Ml0gUEdEIDIxNDYwNjcgUFVEIDIxNDcwNjMgUE1EIGYzYTUwNjMg
UFRFIDgwMDAwMDAwMDI0YjAxNjMKWyAgIDIxLjk3NzM1Ml0gT29wczogMDAxMSBbIzFdIApb
ICAgMjEuOTc3MzUyXSBDUFU6IDAgUElEOiAxNyBDb21tOiBrd29ya2VyLzA6MSBOb3QgdGFp
bnRlZCAzLjExLjAtcmM3ICMyNApbICAgMjEuOTc3MzUyXSBXb3JrcXVldWU6IGV2ZW50cyBi
cmNtZl9kcml2ZXJfaW5pdApbICAgMjEuOTc3MzUyXSB0YXNrOiBmZmZmODgwMDBjY2JlMDAw
IHRpOiBmZmZmODgwMDBjY2MwMDAwIHRhc2sudGk6IGZmZmY4ODAwMGNjYzAwMDAKWyAgIDIx
Ljk3NzM1Ml0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MjRiMDQ0Nj5dICBbPGZmZmZmZmZmODI0
YjA0NDY+XSBjbGFzc2VzX2luaXQrMHgyNi8weDI2ClsgICAyMS45NzczNTJdIFJTUDogMDAx
ODpmZmZmODgwMDBjY2MxZDQwICBFRkxBR1M6IDAwMDAwMjg2ClsgICAyMS45NzczNTJdIFJB
WDogMDAwMDAwMDAwMDAwMDAwMSBSQlg6IGZmZmZmZmZmODIzOTU2MjAgUkNYOiAwMDAwMDAw
MDAwMDAwMDAwClsgICAyMS45NzczNTJdIFJEWDogMDAwMDAwMDAwMDAwMDAwMSBSU0k6IGZm
ZmZmZmZmODE2ZjczYzAgUkRJOiBmZmZmZmZmZjgyMzk1NmMwClsgICAyMS45NzczNTJdIFJC
UDogZmZmZjg4MDAwY2NjMWQ1MCBSMDg6IGZmZmY4ODAwMGNjYmU1MDggUjA5OiAwMDAwMDAw
MDAwMDAwMDAyClsgICAyMS45NzczNTJdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAw
MDFmNzFhMjliOTU2MjAgUjEyOiBmZmZmODgwMDBkMmJmZjQwClsgICAyMS45NzczNTJdIFIx
MzogZmZmZmZmZmY4MjE2MWQ0MCBSMTQ6IDAwMDAwMDAwMDAwMDAwMDAgUjE1OiBmZmZmODgw
MDBlMGNlMzAwClsgICAyMS45NzczNTJdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBH
UzpmZmZmZmZmZjgyMTU0MDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgIDIx
Ljk3NzM1Ml0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1
MDAzYgpbICAgMjEuOTc3MzUyXSBDUjI6IGZmZmZmZmZmODI0YjA0NDYgQ1IzOiAwMDAwMDAw
MDBmM2E0MDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgMjEuOTc3MzUyXSBEUjA6IDAw
MDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAw
MDAwMApbICAgMjEuOTc3MzUyXSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAw
MDAwMDAwMDAwIERSNzogMDAwMDAwMDAwMDAwMDAwMApbICAgMjEuOTc3MzUyXSBTdGFjazoK
WyAgIDIxLjk3NzM1Ml0gIGZmZmZmZmZmODE2ZjdlMzggZmZmZmZmZmY4MjM5NTYyMCBmZmZm
ODgwMDBjY2MxZDYwIGZmZmZmZmZmODE2ZWVmMDkKWyAgIDIxLjk3NzM1Ml0gIGZmZmY4ODAw
MGNjYzFkZTAgZmZmZmZmZmY4MTA3M2RjNSBmZmZmZmZmZjgxMDczZDY4IGZmZmY4ODAwMGNj
YzFkYjgKWyAgIDIxLjk3NzM1Ml0gIDAwMDAwMDAwMDAwMDAwODYgZmZmZmZmZmY4MjM5NTYy
MCBmZmZmZmZmZjgyODE0NzkwIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDIxLjk3NzM1Ml0gQ2Fs
bCBUcmFjZToKWyAgIDIxLjk3NzM1Ml0gIFs8ZmZmZmZmZmY4MTZmN2UzOD5dID8gYnJjbWZf
c2Rpb19pbml0KzB4MTgvMHg3MApbICAgMjEuOTc3MzUyXSAgWzxmZmZmZmZmZjgxNmVlZjA5
Pl0gYnJjbWZfZHJpdmVyX2luaXQrMHg5LzB4MTAKWyAgIDIxLjk3NzM1Ml0gIFs8ZmZmZmZm
ZmY4MTA3M2RjNT5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxZDUvMHg0ODAKWyAgIDIxLjk3NzM1
Ml0gIFs8ZmZmZmZmZmY4MTA3M2Q2OD5dID8gcHJvY2Vzc19vbmVfd29yaysweDE3OC8weDQ4
MApbICAgMjEuOTc3MzUyXSAgWzxmZmZmZmZmZjgxMDc0MTg4Pl0gd29ya2VyX3RocmVhZCsw
eDExOC8weDNhMApbICAgMjEuOTc3MzUyXSAgWzxmZmZmZmZmZjgxMDc0MDcwPl0gPyBwcm9j
ZXNzX29uZV93b3JrKzB4NDgwLzB4NDgwClsgICAyMS45NzczNTJdICBbPGZmZmZmZmZmODEw
N2FhMTc+XSBrdGhyZWFkKzB4ZTcvMHhmMApbICAgMjEuOTc3MzUyXSAgWzxmZmZmZmZmZjgx
MDgyOWY3Pl0gPyBmaW5pc2hfdGFza19zd2l0Y2guY29uc3Rwcm9wLjU3KzB4MzcvMHhkMApb
ICAgMjEuOTc3MzUyXSAgWzxmZmZmZmZmZjgxMDdhOTMwPl0gPyBfX2t0aHJlYWRfcGFya21l
KzB4ODAvMHg4MApbICAgMjEuOTc3MzUyXSAgWzxmZmZmZmZmZjgxYWJlZmJhPl0gcmV0X2Zy
b21fZm9yaysweDdhLzB4YjAKWyAgIDIxLjk3NzM1Ml0gIFs8ZmZmZmZmZmY4MTA3YTkzMD5d
ID8gX19rdGhyZWFkX3BhcmttZSsweDgwLzB4ODAKWyAgIDIxLjk3NzM1Ml0gQ29kZTogY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgPGNjPiBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyAKWyAgIDIxLjk3NzM1Ml0gUklQICBbPGZm
ZmZmZmZmODI0YjA0NDY+XSBjbGFzc2VzX2luaXQrMHgyNi8weDI2ClsgICAyMS45NzczNTJd
ICBSU1AgPGZmZmY4ODAwMGNjYzFkNDA+ClsgICAyMS45NzczNTJdIENSMjogZmZmZmZmZmY4
MjRiMDQ0NgpbICAgMjEuOTc3MzUyXSAtLS1bIGVuZCB0cmFjZSBhMjRhNzc3ZTFkOWMzMmYw
IF0tLS0KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4L2Q4ZGZhZDM4NzZlNDM4
NjY2NmI3NTlkYTNjODMzZDYyZmI4YjIyNjcvZG1lc2cta3ZtLWFudC0xODQwLTIwMTMwODMw
MjAxNjMxLTMuMTEuMC1yYzctMDE4MTQtZ2ZhZjUxYjUtMjgKCmJpc2VjdDogYmFkIGNvbW1p
dCBkOGRmYWQzODc2ZTQzODY2NjZiNzU5ZGEzYzgzM2Q2MmZiOGIyMjY3CmdpdCBjaGVja291
dCB2My4xMApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBkOGRmYWQzLi4uIExpbnV4IDMu
MTEtcmM3CkhFQUQgaXMgbm93IGF0IDhiYjQ5NWUuLi4gTGludXggMy4xMApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzMtMDgyOC9saW51
eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA4MjgxNDU0OjhiYjQ5NWUzZjAyNDAx
ZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzY6YmlzZWN0LXVzYgoKMjAxMy0wOC0zMC0yMDox
Nzo0MCA4YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2IGNvbXBpbGlu
Zwo3MDIgcmVhbCAgMTUwOCB1c2VyICAxMzQgc3lzICAyMzMuNzUlIGNwdSAJeDg2XzY0LXJh
bmRjb25maWctYzMtMDgyOAoKMjAxMy0wOC0zMC0yMDozMToyNiBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEwLjAuLi4uLgkxLi4uLgkyLgkzLi4uLi4JNAk1Li4uLi4uCTYuCTcJOC4uCTEx
CTE1CTIxCTM4CTU1CTc4CTkxIFRFU1QgRkFJTFVSRQpbICAgNDkuOTk4ODgwXSBTd2l0Y2hp
bmcgdG8gY2xvY2tzb3VyY2UgdHNjClsgICA1MC4wMDI0ODZdIGtlcm5lbCB0cmllZCB0byBl
eGVjdXRlIE5YLXByb3RlY3RlZCBwYWdlIC0gZXhwbG9pdCBhdHRlbXB0PyAodWlkOiAwKQpb
ICAgNTAuMDAyNDg2XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1
ZXN0IGF0IGZmZmZmZmZmODI0N2VmMjgKWyAgIDUwLjAwMjQ4Nl0gSVA6IFs8ZmZmZmZmZmY4
MjQ3ZWYyOD5dIGNsYXNzZXNfaW5pdCsweDI2LzB4MjYKWyAgIDUwLjAwMjQ4Nl0gUEdEIDIx
MTYwNjcgUFVEIDIxMTcwNjMgUE1EIGYzOTUwNjMgUFRFIDgwMDAwMDAwMDI0N2UxNjMKWyAg
IDUwLjAwMjQ4Nl0gT29wczogMDAxMSBbIzFdIApbICAgNTAuMDAyNDg2XSBDUFU6IDAgUElE
OiAxNyBDb21tOiBrd29ya2VyLzA6MSBOb3QgdGFpbnRlZCAzLjEwLjAgIzM2MwpbICAgNTAu
MDAyNDg2XSBXb3JrcXVldWU6IGV2ZW50cyBicmNtZl9kcml2ZXJfaW5pdApbICAgNTAuMDAy
NDg2XSB0YXNrOiBmZmZmODgwMDBkM2NlMDAwIHRpOiBmZmZmODgwMDBkM2QwMDAwIHRhc2su
dGk6IGZmZmY4ODAwMGQzZDAwMDAKWyAgIDUwLjAwMjQ4Nl0gUklQOiAwMDEwOls8ZmZmZmZm
ZmY4MjQ3ZWYyOD5dICBbPGZmZmZmZmZmODI0N2VmMjg+XSBjbGFzc2VzX2luaXQrMHgyNi8w
eDI2ClsgICA1MC4wMDI0ODZdIFJTUDogMDAwMDpmZmZmODgwMDBkM2QxZDQwICBFRkxBR1M6
IDAwMDAwMjg2ClsgICA1MC4wMDI0ODZdIFJBWDogMDAwMDAwMDAwMDAwMDAwMSBSQlg6IGZm
ZmZmZmZmODIzNjY4NDAgUkNYOiAwMDAwMDAwMDAwMDAwMDAwClsgICA1MC4wMDI0ODZdIFJE
WDogMDAwMDAwMDAwMDAwMDAwMSBSU0k6IGZmZmZmZmZmODE3MGIzZDAgUkRJOiBmZmZmZmZm
ZjgyMzY2OGUwClsgICA1MC4wMDI0ODZdIFJCUDogZmZmZjg4MDAwZDNkMWQ1MCBSMDg6IGZm
ZmY4ODAwMGQzY2U1MDggUjA5OiAwMDAwMDAwMDAwMDAwMDAyClsgICA1MC4wMDI0ODZdIFIx
MDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDFmNzI1ZTEzNjY4NDAgUjEyOiBmZmZmODgw
MDBkMmJlN2Y4ClsgICA1MC4wMDI0ODZdIFIxMzogZmZmZmZmZmY4MjEzMzk0MCBSMTQ6IDAw
MDAwMDAwMDAwMDAwMDAgUjE1OiBmZmZmODgwMDBlMGNlMzAwClsgICA1MC4wMDI0ODZdIEZT
OiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmZmZmZjgyMTI0MDAwKDAwMDApIGtu
bEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgIDUwLjAwMjQ4Nl0gQ1M6ICAwMDEwIERTOiAwMDAw
IEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgNTAuMDAyNDg2XSBDUjI6IGZm
ZmZmZmZmODI0N2VmMjggQ1IzOiAwMDAwMDAwMDBmMzk0MDAwIENSNDogMDAwMDAwMDAwMDAw
MDZiMApbICAgNTAuMDAyNDg2XSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAw
MDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMApbICAgNTAuMDAyNDg2XSBEUjM6IDAw
MDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMDAwMDAwMDAwIERSNzogMDAwMDAwMDAwMDAw
MDAwMApbICAgNTAuMDAyNDg2XSBTdGFjazoKWyAgIDUwLjAwMjQ4Nl0gIGZmZmZmZmZmODE3
MGMwMTggZmZmZmZmZmY4MjM2Njg0MCBmZmZmODgwMDBkM2QxZDYwIGZmZmZmZmZmODE3MDJl
YzkKWyAgIDUwLjAwMjQ4Nl0gIGZmZmY4ODAwMGQzZDFkZTAgZmZmZmZmZmY4MTA4MTAwNSBm
ZmZmZmZmZjgxMDgwZmE4IGZmZmY4ODAwMGQzZDFkYjgKWyAgIDUwLjAwMjQ4Nl0gIDAwMDAw
MDAwMDAwMDAwODYgZmZmZmZmZmY4MjM2Njg0MCBmZmZmZmZmZjgyN2U3ODUwIDAwMDAwMDAw
MDAwMDAwMDAKWyAgIDUwLjAwMjQ4Nl0gQ2FsbCBUcmFjZToKWyAgIDUwLjAwMjQ4Nl0gIFs8
ZmZmZmZmZmY4MTcwYzAxOD5dID8gYnJjbWZfc2Rpb19pbml0KzB4MTgvMHg3MApbICAgNTAu
MDAyNDg2XSAgWzxmZmZmZmZmZjgxNzAyZWM5Pl0gYnJjbWZfZHJpdmVyX2luaXQrMHg5LzB4
MTAKWyAgIDUwLjAwMjQ4Nl0gIFs8ZmZmZmZmZmY4MTA4MTAwNT5dIHByb2Nlc3Nfb25lX3dv
cmsrMHgxZDUvMHg0ODAKWyAgIDUwLjAwMjQ4Nl0gIFs8ZmZmZmZmZmY4MTA4MGZhOD5dID8g
cHJvY2Vzc19vbmVfd29yaysweDE3OC8weDQ4MApbICAgNTAuMDAyNDg2XSAgWzxmZmZmZmZm
ZjgxMDgxM2M4Pl0gd29ya2VyX3RocmVhZCsweDExOC8weDNhMApbICAgNTAuMDAyNDg2XSAg
WzxmZmZmZmZmZjgxMDgxMmIwPl0gPyBwcm9jZXNzX29uZV93b3JrKzB4NDgwLzB4NDgwClsg
ICA1MC4wMDI0ODZdICBbPGZmZmZmZmZmODEwODdmMzc+XSBrdGhyZWFkKzB4ZTcvMHhmMApb
ICAgNTAuMDAyNDg2XSAgWzxmZmZmZmZmZjgxMDhmZTg3Pl0gPyBmaW5pc2hfdGFza19zd2l0
Y2guY29uc3Rwcm9wLjYyKzB4MzcvMHhkMApbICAgNTAuMDAyNDg2XSAgWzxmZmZmZmZmZjgx
MDg3ZTUwPl0gPyBfX2t0aHJlYWRfcGFya21lKzB4ODAvMHg4MApbICAgNTAuMDAyNDg2XSAg
WzxmZmZmZmZmZjgxYWNiOGJhPl0gcmV0X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgIDUwLjAw
MjQ4Nl0gIFs8ZmZmZmZmZmY4MTA4N2U1MD5dID8gX19rdGhyZWFkX3BhcmttZSsweDgwLzB4
ODAKWyAgIDUwLjAwMjQ4Nl0gQ29kZTogY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgPGNjPiBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyAKWyAgIDUwLjAwMjQ4Nl0gUklQICBbPGZmZmZmZmZmODI0N2VmMjg+XSBjbGFzc2VzX2lu
aXQrMHgyNi8weDI2ClsgICA1MC4wMDI0ODZdICBSU1AgPGZmZmY4ODAwMGQzZDFkNDA+Clsg
ICA1MC4wMDI0ODZdIENSMjogZmZmZmZmZmY4MjQ3ZWYyOApbICAgNTAuMDAyNDg2XSAtLS1b
IGVuZCB0cmFjZSAxZmEwNzdlNDQyMWZiZjJmIF0tLS0KL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jMy0wODI4LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYv
ZG1lc2cta3ZtLWFudC0xODQ0LTIwMTMwODMwMjA1MDI1LTMuMTEuMC1yYzctMDAxNjUtZ2Ji
YTQ1N2EtMzYKCmJpc2VjdDogYmFkIGNvbW1pdCB2My4xMApnaXQgY2hlY2tvdXQgdjMuOQpQ
cmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA4YmI0OTVlLi4uIExpbnV4IDMuMTAKSEVBRCBp
cyBub3cgYXQgYzFiZTVhNS4uLiBMaW51eCAzLjkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMzLTA4MjgvbGludXgtZGV2ZWw6ZGV2ZWwt
Y2Fpcm8teDg2XzY0LTIwMTMwODI4MTQ1NDpjMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5Nzll
YjY2ZGFmYTI0YWQxOmJpc2VjdC11c2IKCjIwMTMtMDgtMzAtMjA6NTE6MjAgYzFiZTVhNWIx
YjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMSBjb21waWxpbmcKMjczIHJlYWwgIDE0
MTMgdXNlciAgMTI1IHN5cyAgNTYyLjY0JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMzLTA4
MjgKCjIwMTMtMDgtMzAtMjA6NTY6NDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAuLi4u
Li4uLi4JMy4uLgk0LgkxOQkyNgkzNwk0MS4uCTQyLgk0My4uCTQ0Li4uLi4uLi4uLi4uLi4u
Li4uLi4uCTQ1Lgk0Nwk0OC4uLi4uLi4uLi4uLi4uLgk0OS4JNTAJNTEuLgk1NQk1Ni4JNTcu
Lgk1OC4uLi4uLi4uLi4JNjAJNjEuLi4uLgk2My4uCTY0CTY2CTY3CTY5Li4uLi4JNzAuLi4J
NzIJNzQJNzUuLi4uLi4uLi4uLi4uLi4uLi4uCTc2Li4uLi4uLi4uCTc3Li4uLgk3OC4uLi4u
Li4uLi4JNzkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTgyLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk4My4uLi4uLi4JODQuLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JODUuLgk4Ni4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uCTg3Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JODguLi4u
Li4JODkuCTkwLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JOTEuLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JOTIuLi4uLi4uLi4uLi4uLi4uLi4u
Lgk5My4uLi4uLi4uLi4uLi4JOTQuLi4uLi4uLi4uLi4uLi4uCTk1Li4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4JOTYuCTk3Li4uLgk5OC4uLi4uLi4uLi4uCTk5Li4uLi4u
Li4uLi4JMTAwLi4JMTAxLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTAyLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTEwMy4u
Li4uLi4uLi4uLi4uCTEwNC4uLi4uLi4uLi4uLi4uLi4JMTA1Li4uLi4uLi4uLi4uLi4uLgkx
MDYuLi4uLi4uCTEwNy4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTA4LgkxMDkuLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTExMC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTEx
Li4uLi4uLi4uLi4JMTEyLi4uCTExMy4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTExNC4uLi4u
CTExNS4uLi4uLi4uLi4uLi4JMTE2Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uCTExNy4uLi4uLi4JMTE4Li4uLi4uLi4uLi4uLi4uLi4uLi4uLgkx
MTkJMTIwLi4uLi4uLgkxMjEuLi4uCTEyMi4uLi4uLi4uLi4uLi4uLi4JMTIzLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4JMTI0Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4JMTI1Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uCTEyNi4uLi4uLi4uCTEyNy4uLi4uLgkxMjkuLi4uLi4uLi4uLi4uLgkx
MzEuCTEzMi4uLi4uLi4uLi4uLi4uLi4uLgkxMzMuLi4uLi4JMTM0Li4uLi4uLi4uCTEzNS4u
Li4uLi4uLi4uLi4uLi4uLi4uCTEzNwkxMzguLi4uLgkxMzkuLi4uLgkxNDAJMTQzCTE0NC4u
Li4uLi4uLi4uLi4uLi4uLgkxNDUuLi4uLi4uLi4JMTQ2LgkxNDcuLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTQ4Li4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uCTE0OS4uLi4JMTUwLi4uLi4uCTE1MS4uLi4uLgkxNTIu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4JMTUzLi4uLi4uLi4uLi4uLi4uLi4JMTU0Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTE1NQkxNTYuLi4uCTE1Ny4uLgkxNTguLi4uLi4u
Li4uLi4uLi4uLi4uLgkxNTkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTYwLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTE2Mi4JMTYzLi4uLi4uLgkxNjQJMTY1LgkxNjYuLi4uLi4u
LgkxNjcuLi4uLgkxNjguCTE2OQkxNzAuLi4uLi4uLi4uLi4uLi4uLgkxNzIJMTczLgkxNzQu
LgkxNzUJMTc4CTE3OS4JMTgyCTE4My4uLgkxODYuLi4uLi4uLgkxODcJMTkwCTE5MgkxOTYJ
MjAyCTIxMQkyMTUJMjIwCTIyNQkyMjkJMjMyCTI0MgkyNTYJMjY4CTI4MAkyOTcJMzA1CTMz
OAkzNjQJMzg5CTQxNwk0MzUJNDcwCTQ4OQk1MDQJNTI3CTU0NAk1OTAJNjM1CTY4OAk3MzIJ
NzQ5CTc2Nwk3NzgJNzkzCTc5OAk4MDAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2
My45CmdpdCBiaXNlY3Qgc3RhcnQgdjMuMTAgdjMuOSAtLQpIRUFEIGlzIG5vdyBhdCBjMWJl
NWE1Li4uIExpbnV4IDMuOQpCaXNlY3Rpbmc6IDczNDUgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbMjBiNGZiNDg1MjI3NDA0MzI5ZTQx
YWQxNTU4OGFmYWQzZGYyMzA1MF0gTWVyZ2UgYnJhbmNoICdmb3ItbGludXMnIG9mIGdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC92aXJvL3ZmcwpnaXQg
YmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4
L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDgyODE0NTQ6MjBiNGZiNDg1
MjI3NDA0MzI5ZTQxYWQxNTU4OGFmYWQzZGYyMzA1MDpiaXNlY3QtdXNiCgoyMDEzLTA4LTMx
LTExOjMzOjQ3IDIwYjRmYjQ4NTIyNzQwNDMyOWU0MWFkMTU1ODhhZmFkM2RmMjMwNTAgY29t
cGlsaW5nCjMyOSByZWFsICAxMjk1IHVzZXIgIDEyOSBzeXMgIDQzMi4zOSUgY3B1IAl4ODZf
NjQtcmFuZGNvbmZpZy1jMy0wODI4CgoyMDEzLTA4LTMxLTExOjM5OjQ4IGRldGVjdGluZyBi
b290IHN0YXRlIDMuOS4wLTA3MzkxLWcyMGI0ZmI0Li4uLi4uLgkxLi4uLi4uLi4uLi4uCTIJ
My4uLi4uLi4uLi4uLi4uCTQuLi4JNQk2Li4uLi4JNy4uLi4uLi4uLi4uLi4uLgk4Li4JOS4u
Li4uLi4gVEVTVCBGQUlMVVJFClsgICA0OC45NjUxNTVdIFN3aXRjaGluZyB0byBjbG9ja3Nv
dXJjZSB0c2MKWyAgIDQ4Ljk2OTEwNl0ga2VybmVsIHRyaWVkIHRvIGV4ZWN1dGUgTlgtcHJv
dGVjdGVkIHBhZ2UgLSBleHBsb2l0IGF0dGVtcHQ/ICh1aWQ6IDApClsgICA0OC45NzAyNzFd
IEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgZmZmZmZm
ZmY4MjQ0ZmRkYwpbICAgNDguOTcwMjcxXSBJUDogWzxmZmZmZmZmZjgyNDRmZGRjPl0gY2xh
c3Nlc19pbml0KzB4MjYvMHgyNgpbICAgNDguOTcwMjcxXSBQR0QgMjBlNjA2NyBQVUQgMjBl
NzA2MyBQTUQgZjM4ODA2MyBQVEUgODAwMDAwMDAwMjQ0ZjE2MwpbICAgNDguOTcwMjcxXSBP
b3BzOiAwMDExIFsjMV0gClsgICA0OC45NzAyNzFdIENQVTogMCBQSUQ6IDE2IENvbW06IGt3
b3JrZXIvMDoxIE5vdCB0YWludGVkIDMuOS4wLTA3MzkxLWcyMGI0ZmI0ICMzNjUKWyAgIDQ4
Ljk3MDI3MV0gV29ya3F1ZXVlOiBldmVudHMgYnJjbWZfZHJpdmVyX2luaXQKWyAgIDQ4Ljk3
MDI3MV0gdGFzazogZmZmZjg4MDAwMDFkMjAwMCB0aTogZmZmZjg4MDAwMDFkNDAwMCB0YXNr
LnRpOiBmZmZmODgwMDAwMWQ0MDAwClsgICA0OC45NzAyNzFdIFJJUDogMDAxMDpbPGZmZmZm
ZmZmODI0NGZkZGM+XSAgWzxmZmZmZmZmZjgyNDRmZGRjPl0gY2xhc3Nlc19pbml0KzB4MjYv
MHgyNgpbICAgNDguOTcwMjcxXSBSU1A6IDAwMDA6ZmZmZjg4MDAwMDFkNWQ0MCAgRUZMQUdT
OiAwMDAwMDI4NgpbICAgNDguOTcwMjcxXSBSQVg6IDAwMDAwMDAwMDAwMDAwMDEgUkJYOiBm
ZmZmZmZmZjgyMzM0ODgwIFJDWDogMDAwMDAwMDAwMDAwMDAwMApbICAgNDguOTcwMjcxXSBS
RFg6IDAwMDAwMDAwMDAwMDAwMDEgUlNJOiBmZmZmZmZmZjgxNmUyMzQwIFJESTogZmZmZmZm
ZmY4MjMzNDkyMApbICAgNDguOTcwMjcxXSBSQlA6IGZmZmY4ODAwMDAxZDVkNTAgUjA4OiBm
ZmZmODgwMDAwMWQyNTA4IFIwOTogMDAwMDAwMDAwMDAwMDAwMgpbICAgNDguOTcwMjcxXSBS
MTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAxZjczMjYwMzM0ODgwIFIxMjogZmZmZjg4
MDAwMDFjMjVmOApbICAgNDguOTcwMjcxXSBSMTM6IGZmZmZmZmZmODIxMDExNDAgUjE0OiAw
MDAwMDAwMDAwMDAwMDAwIFIxNTogZmZmZjg4MDAwZTBjZTMwMApbICAgNDguOTcwMjcxXSBG
UzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4MjBmNDAwMCgwMDAwKSBr
bmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICA0OC45NzAyNzFdIENTOiAgMDAxMCBEUzogMDAw
MCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgIDQ4Ljk3MDI3MV0gQ1IyOiBm
ZmZmZmZmZjgyNDRmZGRjIENSMzogMDAwMDAwMDAwMjBlNTAwMCBDUjQ6IDAwMDAwMDAwMDAw
MDA2YjAKWyAgIDQ4Ljk3MDI3MV0gRFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAw
MDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDQ4Ljk3MDI3MV0gRFIzOiAw
MDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDAwMDAwMDAwMCBEUjc6IDAwMDAwMDAwMDAw
MDAwMDAKWyAgIDQ4Ljk3MDI3MV0gU3RhY2s6ClsgICA0OC45NzAyNzFdICBmZmZmZmZmZjgx
NmUyZjg4IGZmZmZmZmZmODIzMzQ4ODAgZmZmZjg4MDAwMDFkNWQ2MCBmZmZmZmZmZjgxNmQ5
ZjY5ClsgICA0OC45NzAyNzFdICBmZmZmODgwMDAwMWQ1ZGUwIGZmZmZmZmZmODEwNjkxZDUg
ZmZmZmZmZmY4MTA2OTE3OCBmZmZmODgwMDAwMWQ1ZGI4ClsgICA0OC45NzAyNzFdICAwMDAw
MDAwMDAwMDAwMDgyIGZmZmZmZmZmODIzMzQ4ODAgZmZmZmZmZmY4MjdiN2FjMCAwMDAwMDAw
MDAwMDAwMDAwClsgICA0OC45NzAyNzFdIENhbGwgVHJhY2U6ClsgICA0OC45NzAyNzFdICBb
PGZmZmZmZmZmODE2ZTJmODg+XSA/IGJyY21mX3NkaW9faW5pdCsweDE4LzB4NzAKWyAgIDQ4
Ljk3MDI3MV0gIFs8ZmZmZmZmZmY4MTZkOWY2OT5dIGJyY21mX2RyaXZlcl9pbml0KzB4OS8w
eDEwClsgICA0OC45NzAyNzFdICBbPGZmZmZmZmZmODEwNjkxZDU+XSBwcm9jZXNzX29uZV93
b3JrKzB4MWQ1LzB4NDgwClsgICA0OC45NzAyNzFdICBbPGZmZmZmZmZmODEwNjkxNzg+XSA/
IHByb2Nlc3Nfb25lX3dvcmsrMHgxNzgvMHg0ODAKWyAgIDQ4Ljk3MDI3MV0gIFs8ZmZmZmZm
ZmY4MTA2OTU5OD5dIHdvcmtlcl90aHJlYWQrMHgxMTgvMHgzYTAKWyAgIDQ4Ljk3MDI3MV0g
IFs8ZmZmZmZmZmY4MTA2OTQ4MD5dID8gcHJvY2Vzc19vbmVfd29yaysweDQ4MC8weDQ4MApb
ICAgNDguOTcwMjcxXSAgWzxmZmZmZmZmZjgxMDcwMTA3Pl0ga3RocmVhZCsweGU3LzB4ZjAK
WyAgIDQ4Ljk3MDI3MV0gIFs8ZmZmZmZmZmY4MTA3N2Y2Nz5dID8gZmluaXNoX3Rhc2tfc3dp
dGNoLmNvbnN0cHJvcC42MSsweDM3LzB4ZDAKWyAgIDQ4Ljk3MDI3MV0gIFs8ZmZmZmZmZmY4
MTA3MDAyMD5dID8gX19rdGhyZWFkX3BhcmttZSsweDgwLzB4ODAKWyAgIDQ4Ljk3MDI3MV0g
IFs8ZmZmZmZmZmY4MWE5ZjRiYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICA0OC45
NzAyNzFdICBbPGZmZmZmZmZmODEwNzAwMjA+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg4MC8w
eDgwClsgICA0OC45NzAyNzFdIENvZGU6IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNj
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNj
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIDxjYz4gY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgClsgICA0OC45NzAyNzFdIFJJUCAgWzxmZmZmZmZmZjgyNDRmZGRjPl0gY2xhc3Nlc19p
bml0KzB4MjYvMHgyNgpbICAgNDguOTcwMjcxXSAgUlNQIDxmZmZmODgwMDAwMWQ1ZDQwPgpb
ICAgNDguOTcwMjcxXSBDUjI6IGZmZmZmZmZmODI0NGZkZGMKWyAgIDQ4Ljk3MDI3MV0gLS0t
WyBlbmQgdHJhY2UgZGVkYTZiNmM3MmVjMTZiYSBdLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYzMtMDgyOC8yMGI0ZmI0ODUyMjc0MDQzMjllNDFhZDE1NTg4YWZhZDNkZjIzMDUw
L2RtZXNnLWt2bS1hbnQtNDI4OC0yMDEzMDgzMTEyMTYwOS0zLjkuMC0wNzM5MS1nMjBiNGZi
NC0zNjUKCkJpc2VjdGluZzogMzc3MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTIgc3RlcHMpClsxOWIzNDRlZmEzNWRiYzI1M2UyZDEwNDAzZGFmZTZh
YWZkYTczYzU2XSBNZXJnZSBicmFuY2ggJ2Zvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2ppa29zL2hpZApydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9v
YmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1jMy0wODI4L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDgy
ODE0NTQ6MTliMzQ0ZWZhMzVkYmMyNTNlMmQxMDQwM2RhZmU2YWFmZGE3M2M1NjpiaXNlY3Qt
dXNiCgoyMDEzLTA4LTMxLTEyOjE2OjUzIDE5YjM0NGVmYTM1ZGJjMjUzZTJkMTA0MDNkYWZl
NmFhZmRhNzNjNTYgY29tcGlsaW5nCjIzNSByZWFsICAxNDMyIHVzZXIgIDE0MiBzeXMgIDY2
OC44MCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4CgoyMDEzLTA4LTMxLTEyOjIx
OjAyIGRldGVjdGluZyBib290IHN0YXRlIDMuOS4wLTAzNjE3LWcxOWIzNDRlLi4uLi4uLi4J
MS4uLi4uCTIuLi4uLi4uLi4uCTMJNS4JNgk3Li4JMTAuCTEyCTEzLgkxNQkxNgkxOAkxOQkz
Ngk0Nwk2MQk3OAk5MwkxMzMJMTY0CTE5NgkyMTEJMjQ1CTMwMAkzMjIJMzM2CTQwMAk0MzMJ
NDYyCTQ5MAk1MjIJNTUyCTU3Mwk1OTIJNjA2CTYxMgk2MTcJNjIyCTYyMwk2MjYJNjMyCTYz
NQk2MzcJNjQwCTY0My4JNjQ0Lgk2NDUJNjQ2Li4JNjQ5CTY1MC4uCTY1MQk2NTMuLi4uCTY1
NC4JNjU1CTY1Ni4JNjU4CTY1OS4JNjYwLi4JNjYxCTY2Mi4JNjYzLgk2NjQuLgk2NjUuLgk2
NjYuCTY2Nwk2NjkJNjcwCTY3MQk2NzIuLi4uLi4uLi4uLgk2NzMuCTY3NC4uLi4uLi4uLi4u
Li4JNjc1Lgk2NzYJNjc3Li4uLi4JNjc4Li4uCTY3OQk2ODAuCTY4MQk2ODIJNjgzCTY4NC4u
Li4uLi4uLi4uLi4JNjg1Li4uLi4uLi4uLi4uLi4uLi4uLgk2ODYJNjg3Li4uLgk2ODguLi4J
Njg5Li4uCTY5MS4uLi4JNjkyCTY5Mwk2OTQuLi4uLi4uLi4JNjk1CTY5Ngk2OTguLi4uLi4u
Li4uLi4uLi4uLi4uLgk2OTkuLi4uLi4uLi4uLi4uLi4JNzAwLi4uLi4uLi4uLi4uLgk3MDEu
Li4uLgk3MDIuLi4uLi4uLi4uLi4JNzAzLi4uLi4uCTcwNC4uLi4uLi4uLi4uLi4JNzA1Lgk3
MDYuLi4uLi4JNzA3CTcwOC4uCTcxMwk3MTQJNzE2CTczMgk3NTAJNzU0CTc2Ngk3NzgJNzgx
CTc5Mi4uLgk3OTUuCTc5Nwk3OTguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sx
OzM1bWFkZF90b19ydW5fcXVldWUgMhtbMG0KLi4uLi4JNzk5Li4uLi4JODAwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMTk2MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMTEgc3RlcHMpClsyMDA3NGYzNTdkYTRhNjM3NDMwYWVjMjg3OWM5ZDg2NGM1ZDJj
MjNjXSBmaWx0ZXI6IGZpeCB2YV9saXN0IGJ1aWxkIGVycm9yCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLWMzLTA4MjgvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwODI4MTQ1
NDoyMDA3NGYzNTdkYTRhNjM3NDMwYWVjMjg3OWM5ZDg2NGM1ZDJjMjNjOmJpc2VjdC11c2IK
CjIwMTMtMDgtMzEtMTc6NTQ6MTAgMjAwNzRmMzU3ZGE0YTYzNzQzMGFlYzI4NzljOWQ4NjRj
NWQyYzIzYyBjb21waWxpbmcKMjgxIHJlYWwgIDEyOTggdXNlciAgMTMxIHN5cyAgNTA3Ljg0
JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMzLTA4MjgKCjIwMTMtMDgtMzEtMTc6NTk6MDcg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAtcmM4LTAxODEyLWcyMDA3NGYzLi4uLi4uLgkx
LiBURVNUIEZBSUxVUkUKWyAgIDMxLjg2Njk3M10gU3dpdGNoaW5nIHRvIGNsb2Nrc291cmNl
IHRzYwpbICAgMzEuODY5NjQwXSBrZXJuZWwgdHJpZWQgdG8gZXhlY3V0ZSBOWC1wcm90ZWN0
ZWQgcGFnZSAtIGV4cGxvaXQgYXR0ZW1wdD8gKHVpZDogMCkKWyAgIDMxLjg2OTY0MF0gQlVH
OiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCBmZmZmZmZmZjgy
NDEyY2E5ClsgICAzMS44Njk2NDBdIElQOiBbPGZmZmZmZmZmODI0MTJjYTk+XSBjbGFzc2Vz
X2luaXQrMHgyNi8weDI2ClsgICAzMS44Njk2NDBdIFBHRCAyMGI0MDY3IFBVRCAyMGI1MDYz
IFBNRCBmMzg2MDYzIFBURSA4MDAwMDAwMDAyNDEyMTYzClsgICAzMS44Njk2NDBdIE9vcHM6
IDAwMTEgWyMxXSAKWyAgIDMxLjg2OTY0MF0gQ1BVIDAgClsgICAzMS44Njk2NDBdIFBpZDog
MTcsIGNvbW06IGt3b3JrZXIvMDoxIE5vdCB0YWludGVkIDMuOS4wLXJjOC0wMTgxMi1nMjAw
NzRmMyAjMzY3ICAKWyAgIDMxLjg2OTY0MF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MjQxMmNh
OT5dICBbPGZmZmZmZmZmODI0MTJjYTk+XSBjbGFzc2VzX2luaXQrMHgyNi8weDI2ClsgICAz
MS44Njk2NDBdIFJTUDogMDAwMDpmZmZmODgwMDAwMWQ5ZDQ4ICBFRkxBR1M6IDAwMDAwMjgy
ClsgICAzMS44Njk2NDBdIFJBWDogMDAwMDAwMDAwMDAwMDAwMSBSQlg6IGZmZmZmZmZmODIz
MDI2YTAgUkNYOiAwMDAwMDAwMDAwMDAwMDAwClsgICAzMS44Njk2NDBdIFJEWDogMDAwMDAw
MDAwMDAwMDAwMSBSU0k6IGZmZmZmZmZmODE2ZGIzMTAgUkRJOiBmZmZmZmZmZjgyMzAyNzQw
ClsgICAzMS44Njk2NDBdIFJCUDogZmZmZjg4MDAwMDFkOWQ1OCBSMDg6IGZmZmY4ODAwMDAx
ZDY1MDggUjA5OiAwMDAwMDAwMDAwMDAwMDAyClsgICAzMS44Njk2NDBdIFIxMDogMDAwMDAw
MDAwMDAwMDAwMCBSMTE6IDAwMDFmNzNlZTdiMDI2YTAgUjEyOiBmZmZmODgwMDAwMWM2ODg4
ClsgICAzMS44Njk2NDBdIFIxMzogZmZmZmZmZmY4MjBjZjAyMCBSMTQ6IDAwMDAwMDAwMDAw
MDAwMDAgUjE1OiBmZmZmODgwMDBlMGNlMzAwClsgICAzMS44Njk2NDBdIEZTOiAgMDAwMDAw
MDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmZmZmZjgyMGMyMDAwKDAwMDApIGtubEdTOjAwMDAw
MDAwMDAwMDAwMDAKWyAgIDMxLjg2OTY0MF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAw
IENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgMzEuODY5NjQwXSBDUjI6IGZmZmZmZmZmODI0
MTJjYTkgQ1IzOiAwMDAwMDAwMDBmMzgyMDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAg
MzEuODY5NjQwXSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAw
IERSMjogMDAwMDAwMDAwMDAwMDAwMApbICAgMzEuODY5NjQwXSBEUjM6IDAwMDAwMDAwMDAw
MDAwMDAgRFI2OiAwMDAwMDAwMDAwMDAwMDAwIERSNzogMDAwMDAwMDAwMDAwMDAwMApbICAg
MzEuODY5NjQwXSBQcm9jZXNzIGt3b3JrZXIvMDoxIChwaWQ6IDE3LCB0aHJlYWRpbmZvIGZm
ZmY4ODAwMDAxZDgwMDAsIHRhc2sgZmZmZjg4MDAwMDFkNjAwMCkKWyAgIDMxLjg2OTY0MF0g
U3RhY2s6ClsgICAzMS44Njk2NDBdICBmZmZmZmZmZjgxNmRiZjU4IGZmZmZmZmZmODIzMDI2
YTAgZmZmZjg4MDAwMDFkOWQ2OCBmZmZmZmZmZjgxNmQyZjU5ClsgICAzMS44Njk2NDBdICBm
ZmZmODgwMDAwMWQ5ZGUwIGZmZmZmZmZmODEwNjc1MzQgZmZmZmZmZmY4MTA2NzRkNyAwMDAw
MDAwMDAwMDAwMDgyClsgICAzMS44Njk2NDBdICBmZmZmZmZmZjgyMzAyNmEwIGZmZmZmZmZm
ODI3NzdjNDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgyMDRhZDRiClsgICAzMS44Njk2
NDBdIENhbGwgVHJhY2U6ClsgICAzMS44Njk2NDBdICBbPGZmZmZmZmZmODE2ZGJmNTg+XSA/
IGJyY21mX3NkaW9faW5pdCsweDE4LzB4NzAKWyAgIDMxLjg2OTY0MF0gIFs8ZmZmZmZmZmY4
MTZkMmY1OT5dIGJyY21mX2RyaXZlcl9pbml0KzB4OS8weDEwClsgICAzMS44Njk2NDBdICBb
PGZmZmZmZmZmODEwNjc1MzQ+XSBwcm9jZXNzX29uZV93b3JrKzB4MWQ0LzB4MzgwClsgICAz
MS44Njk2NDBdICBbPGZmZmZmZmZmODEwNjc0ZDc+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHgx
NzcvMHgzODAKWyAgIDMxLjg2OTY0MF0gIFs8ZmZmZmZmZmY4MTA2ODI5ZT5dIHdvcmtlcl90
aHJlYWQrMHgxMGUvMHgzYzAKWyAgIDMxLjg2OTY0MF0gIFs8ZmZmZmZmZmY4MTA2ODE5MD5d
ID8gYnVzeV93b3JrZXJfcmViaW5kX2ZuKzB4OTAvMHg5MApbICAgMzEuODY5NjQwXSAgWzxm
ZmZmZmZmZjgxMDZkYzM3Pl0ga3RocmVhZCsweGU3LzB4ZjAKWyAgIDMxLjg2OTY0MF0gIFs8
ZmZmZmZmZmY4MTA3NWFkNz5dID8gZmluaXNoX3Rhc2tfc3dpdGNoLmNvbnN0cHJvcC42Misw
eDM3LzB4ZDAKWyAgIDMxLjg2OTY0MF0gIFs8ZmZmZmZmZmY4MTA2ZGI1MD5dID8gX19rdGhy
ZWFkX3BhcmttZSsweDgwLzB4ODAKWyAgIDMxLjg2OTY0MF0gIFs8ZmZmZmZmZmY4MWE4MGQz
YT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAzMS44Njk2NDBdICBbPGZmZmZmZmZm
ODEwNmRiNTA+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg4MC8weDgwClsgICAzMS44Njk2NDBd
IENvZGU6IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNj
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNj
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIDxjYz4gY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgClsgICAzMS44Njk2NDBd
IFJJUCAgWzxmZmZmZmZmZjgyNDEyY2E5Pl0gY2xhc3Nlc19pbml0KzB4MjYvMHgyNgpbICAg
MzEuODY5NjQwXSAgUlNQIDxmZmZmODgwMDAwMWQ5ZDQ4PgpbICAgMzEuODY5NjQwXSBDUjI6
IGZmZmZmZmZmODI0MTJjYTkKWyAgIDMxLjg2OTY0MF0gLS0tWyBlbmQgdHJhY2UgYTg4ODhm
ZmM5NmNmNjY0NSBdLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzMtMDgyOC8yMDA3
NGYzNTdkYTRhNjM3NDMwYWVjMjg3OWM5ZDg2NGM1ZDJjMjNjL2RtZXNnLWt2bS1hbnQtMTEw
ODktMjAxMzA4MzExODAyMjctMy45LjAtcmM4LTAxODEyLWcyMDA3NGYzLTM2NwoKQmlzZWN0
aW5nOiA5NjQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEw
IHN0ZXBzKQpbOTUzYzk2ZTBkODU2MTVkMWFiMWYxMDBlNTI1ZDM3NjA1MzI5NGRjMl0gdGcz
OiBVc2UgYm9vbCBub3QgaW50CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMzLTA4MjgvbGludXgt
ZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwODI4MTQ1NDo5NTNjOTZlMGQ4NTYxNWQx
YWIxZjEwMGU1MjVkMzc2MDUzMjk0ZGMyOmJpc2VjdC11c2IKCjIwMTMtMDgtMzEtMTg6MDM6
NDAgOTUzYzk2ZTBkODU2MTVkMWFiMWYxMDBlNTI1ZDM3NjA1MzI5NGRjMiBjb21waWxpbmcK
MjE2IHJlYWwgIDE0NTUgdXNlciAgMTM1IHN5cyAgNzM1LjYwJSBjcHUgCXg4Nl82NC1yYW5k
Y29uZmlnLWMzLTA4MjgKCjIwMTMtMDgtMzEtMTg6MDc6MjggZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy45LjAtcmM1LTAxMTQ1LWc5NTNjOTZlLi4uLgkzCTkJMjgJMzQJMzUJMzcJNDUJNTQJ
NTkJNjEJNjIuCTYzCTY0CTY2CTY3CTY5CTcwLi4uLgk3MS4JNzMJODEJODQuCTg2CTkxCTky
Lgk5NgkxMDQJMTA4CTEwOQkxMTAJMTE2CTEyMQkxMjcJMTMxCTEzNQkxNDAJMTQ1CTE0OQkx
NTYJMTU4CTE2NAkxNzMJMTc5CTE4MwkxODUJMTk0CTE5OAkyMDkJMjEyCTIxMwkyMTYJMjE3
CTIyMwkyMjcJMjI4LgkyMzAJMjMxCTIzMwkyMzYJMjM3LgkyNDEJMjQyCTI0NAkyNDkuLi4J
MjUwCTI1NS4JMjcwCTI4MwkyOTcJMzIwCTMzNwkzNTAJMzY1CTM4OQk0MTEJNDMyCTQ1OQk0
ODQJNTIwCTUzNgk1NjkJNTg4CTYwMQk2MTAJNjU1CTY5MAk3MTYJNzY4CTc4OQk3OTIJNzk0
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVl
IDYbWzBtCi4uLi4uCTc5NS4uLgk3OTcJNzk4CTc5OQk4MDAgU1VDQ0VTUwoKQmlzZWN0aW5n
OiA0ODIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3Rl
cHMpCls0ZGU0MWJlZjNlMDc1ZGJjNzg3ZjdjNTNiMzU2MmYyMzI5NWYxZDZkXSB3aWw2MjEw
OiBVc2UgY2FjaGVkIGNvcHkgb2YgVHggZGVzY3JpcHRvcgpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1jMy0wODI4L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDgyODE0NTQ6
NGRlNDFiZWYzZTA3NWRiYzc4N2Y3YzUzYjM1NjJmMjMyOTVmMWQ2ZDpiaXNlY3QtdXNiCgoy
MDEzLTA4LTMxLTIxOjM4OjM0IDRkZTQxYmVmM2UwNzVkYmM3ODdmN2M1M2IzNTYyZjIzMjk1
ZjFkNmQgY29tcGlsaW5nCjI4NCByZWFsICAxMzc3IHVzZXIgIDE0MiBzeXMgIDUzNC44OSUg
Y3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4CgoyMDEzLTA4LTMxLTIxOjQzOjMxIGRl
dGVjdGluZyBib290IHN0YXRlIDMuOS4wLXJjMS0wMDkzOC1nNGRlNDFiZS4uLi4uLi4JMS4u
Li4JMgkzLi4uLi4uLi4uLgk0Li4uLi4uLi4JNS4uLi4uLi4uLi4uLi4uLi4uCTYuLi4uCTcu
Li4uLgk5CTExCTEyLgkxNAkxNQkyMAkyNwk0Mwk1Mwk2Mgk3NQk4NgkxMDIgVEVTVCBGQUlM
VVJFClsgICA1MS40NDgxMDBdIFN3aXRjaGluZyB0byBjbG9ja3NvdXJjZSB0c2MKWyAgIDUx
LjQ1MTg3OF0ga2VybmVsIHRyaWVkIHRvIGV4ZWN1dGUgTlgtcHJvdGVjdGVkIHBhZ2UgLSBl
eHBsb2l0IGF0dGVtcHQ/ICh1aWQ6IDApClsgICA1MS40NTI3NjVdIEJVRzogdW5hYmxlIHRv
IGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgZmZmZmZmZmY4MjQwYWQyMQpbICAg
NTEuNDUzMjEyXSBJUDogWzxmZmZmZmZmZjgyNDBhZDIxPl0gY2xhc3Nlc19pbml0KzB4MjYv
MHgyNgpbICAgNTEuNDUzMjEyXSBQR0QgMjBhYzA2NyBQVUQgMjBhZDA2MyBQTUQgZjM4NjA2
MyBQVEUgODAwMDAwMDAwMjQwYTE2MwpbICAgNTEuNDUzMjEyXSBPb3BzOiAwMDExIFsjMV0g
ClsgICA1MS40NTMyMTJdIENQVSAwIApbICAgNTEuNDUzMjEyXSBQaWQ6IDE3LCBjb21tOiBr
d29ya2VyLzA6MSBOb3QgdGFpbnRlZCAzLjkuMC1yYzEtMDA5MzgtZzRkZTQxYmUgIzM2OSAg
ClsgICA1MS40NTMyMTJdIFJJUDogMDAxMDpbPGZmZmZmZmZmODI0MGFkMjE+XSAgWzxmZmZm
ZmZmZjgyNDBhZDIxPl0gY2xhc3Nlc19pbml0KzB4MjYvMHgyNgpbICAgNTEuNDUzMjEyXSBS
U1A6IDAwMTg6ZmZmZjg4MDAwMDFkOWQ0OCAgRUZMQUdTOiAwMDAwMDI4MgpbICAgNTEuNDUz
MjEyXSBSQVg6IDAwMDAwMDAwMDAwMDAwMDEgUkJYOiBmZmZmZmZmZjgyMmZhMTQwIFJDWDog
MDAwMDAwMDAwMDAwMDAwMApbICAgNTEuNDUzMjEyXSBSRFg6IDAwMDAwMDAwMDAwMDAwMDEg
UlNJOiBmZmZmZmZmZjgxNmQ5ZmYwIFJESTogZmZmZmZmZmY4MjJmYTFlMApbICAgNTEuNDUz
MjEyXSBSQlA6IGZmZmY4ODAwMDAxZDlkNTggUjA4OiBmZmZmODgwMDAwMWQ2NTA4IFIwOTog
MDAwMDAwMDAwMDAwMDAwMgpbICAgNTEuNDUzMjEyXSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAg
UjExOiAwMDAxZjc0MGZkMmZhMTQwIFIxMjogZmZmZjg4MDAwMDFjYTc5MApbICAgNTEuNDUz
MjEyXSBSMTM6IGZmZmZmZmZmODIwYzZmYzAgUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTog
ZmZmZjg4MDAwZTBjZTMwMApbICAgNTEuNDUzMjEyXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAo
MDAwMCkgR1M6ZmZmZmZmZmY4MjBiYTAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAw
ClsgICA1MS40NTMyMTJdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAw
MDAwODAwNTAwM2IKWyAgIDUxLjQ1MzIxMl0gQ1IyOiBmZmZmZmZmZjgyNDBhZDIxIENSMzog
MDAwMDAwMDAwZjM5ZDAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2YjAKWyAgIDUxLjQ1MzIxMl0g
RFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgIDUxLjQ1MzIxMl0gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjog
MDAwMDAwMDAwMDAwMDAwMCBEUjc6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDUxLjQ1MzIxMl0g
UHJvY2VzcyBrd29ya2VyLzA6MSAocGlkOiAxNywgdGhyZWFkaW5mbyBmZmZmODgwMDAwMWQ4
MDAwLCB0YXNrIGZmZmY4ODAwMDAxZDYwMDApClsgICA1MS40NTMyMTJdIFN0YWNrOgpbICAg
NTEuNDUzMjEyXSAgZmZmZmZmZmY4MTZkYWMzOCBmZmZmZmZmZjgyMmZhMTQwIGZmZmY4ODAw
MDAxZDlkNjggZmZmZmZmZmY4MTZkMjRjOQpbICAgNTEuNDUzMjEyXSAgZmZmZjg4MDAwMDFk
OWRlMCBmZmZmZmZmZjgxMDY3NTQ0IGZmZmZmZmZmODEwNjc0ZTcgMDAwMDAwMDAwMDAwMDA4
MgpbICAgNTEuNDUzMjEyXSAgZmZmZmZmZmY4MjJmYTE0MCBmZmZmZmZmZjgyNzcyNmUwIDAw
MDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MjA0MzY2MwpbICAgNTEuNDUzMjEyXSBDYWxsIFRy
YWNlOgpbICAgNTEuNDUzMjEyXSAgWzxmZmZmZmZmZjgxNmRhYzM4Pl0gPyBicmNtZl9zZGlv
X2luaXQrMHgxOC8weDcwClsgICA1MS40NTMyMTJdICBbPGZmZmZmZmZmODE2ZDI0Yzk+XSBi
cmNtZl9kcml2ZXJfaW5pdCsweDkvMHgxMApbICAgNTEuNDUzMjEyXSAgWzxmZmZmZmZmZjgx
MDY3NTQ0Pl0gcHJvY2Vzc19vbmVfd29yaysweDFkNC8weDM4MApbICAgNTEuNDUzMjEyXSAg
WzxmZmZmZmZmZjgxMDY3NGU3Pl0gPyBwcm9jZXNzX29uZV93b3JrKzB4MTc3LzB4MzgwClsg
ICA1MS40NTMyMTJdICBbPGZmZmZmZmZmODEwNjgyYWU+XSB3b3JrZXJfdGhyZWFkKzB4MTBl
LzB4M2MwClsgICA1MS40NTMyMTJdICBbPGZmZmZmZmZmODEwNjgxYTA+XSA/IGJ1c3lfd29y
a2VyX3JlYmluZF9mbisweDkwLzB4OTAKWyAgIDUxLjQ1MzIxMl0gIFs8ZmZmZmZmZmY4MTA2
ZGM0Nz5dIGt0aHJlYWQrMHhlNy8weGYwClsgICA1MS40NTMyMTJdICBbPGZmZmZmZmZmODEw
NzVhYTc+XSA/IGZpbmlzaF90YXNrX3N3aXRjaC5jb25zdHByb3AuNjIrMHgzNy8weGQwClsg
ICA1MS40NTMyMTJdICBbPGZmZmZmZmZmODEwNmRiNjA+XSA/IF9fa3RocmVhZF9wYXJrbWUr
MHg4MC8weDgwClsgICA1MS40NTMyMTJdICBbPGZmZmZmZmZmODFhNzlmYmE+XSByZXRfZnJv
bV9mb3JrKzB4N2EvMHhiMApbICAgNTEuNDUzMjEyXSAgWzxmZmZmZmZmZjgxMDZkYjYwPl0g
PyBfX2t0aHJlYWRfcGFya21lKzB4ODAvMHg4MApbICAgNTEuNDUzMjEyXSBDb2RlOiBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyA8Y2M+IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNj
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIApbICAgNTEuNDUzMjEyXSBSSVAgIFs8ZmZm
ZmZmZmY4MjQwYWQyMT5dIGNsYXNzZXNfaW5pdCsweDI2LzB4MjYKWyAgIDUxLjQ1MzIxMl0g
IFJTUCA8ZmZmZjg4MDAwMDFkOWQ0OD4KWyAgIDUxLjQ1MzIxMl0gQ1IyOiBmZmZmZmZmZjgy
NDBhZDIxClsgICA1MS40NTMyMTJdIC0tLVsgZW5kIHRyYWNlIGNkMzI1MDBmZDQzYTZiOGIg
XS0tLQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMzLTA4MjgvNGRlNDFiZWYzZTA3NWRi
Yzc4N2Y3YzUzYjM1NjJmMjMyOTVmMWQ2ZC9kbWVzZy1rdm0tYW50LTE2OTUwLTIwMTMwODMx
MjIyMDQ3LTMuMTEuMC1yYzYtd2wtNjg1MzYtZ2M4MGM3ZTQtMTExCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzMtMDgyOC80ZGU0MWJlZjNlMDc1ZGJjNzg3ZjdjNTNiMzU2MmYyMzI5
NWYxZDZkL2RtZXNnLWt2bS1hbnQtMjIwMi0yMDEzMDgzMTIyMjA1Ny0zLjExLjAtcmM3LTAw
MjY0LWc2Yjg0ZGNmLTMzOAoKQmlzZWN0aW5nOiAyNDAgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCltlNzNkY2ZiZjA2MWI1MjRmZTlhYWVm
NTZjZjNjMmUyMzRhNDVlYzE5XSBCbHVldG9vdGg6IGhpZHA6IGZpeCBzZW5kaW5nIG91dHB1
dCByZXBvcnRzIG9uIGludHIgY2hhbm5lbApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4
L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDgyODE0NTQ6ZTczZGNmYmYw
NjFiNTI0ZmU5YWFlZjU2Y2YzYzJlMjM0YTQ1ZWMxOTpiaXNlY3QtdXNiCgoyMDEzLTA4LTMx
LTIyOjIxOjM1IGU3M2RjZmJmMDYxYjUyNGZlOWFhZWY1NmNmM2MyZTIzNGE0NWVjMTkgY29t
cGlsaW5nCjYyIHJlYWwgIDE4NiB1c2VyICAyNSBzeXMgIDMzOS41NCUgY3B1IAl4ODZfNjQt
cmFuZGNvbmZpZy1jMy0wODI4CgoyMDEzLTA4LTMxLTIyOjIyOjUwIGRldGVjdGluZyBib290
IHN0YXRlIDMuOS4wLXJjMS0wMDY3Ni1nZTczZGNmYi4uLi4JNAkxNAkyMAkyNQkzMwk1OAk5
MwkxMjEJMTQ1CTE2NgkxOTkJMjAxCTIyNgkyNjYJMjk2CTMyMQkzNDAJMzYwCTQwMQk0MjIJ
NDQyCTQ2MQk0ODcJNTEyCTUzMgk1OTAJNjEyCTY1Mgk3MDcJNzUxCTc3OQk3ODQJNzg3CTc4
OQk3OTAJNzkxCTc5Mi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRk
X3RvX3J1bl9xdWV1ZSA4G1swbQouLi4uLi4uCTc5Mwk3OTYJNzk5CTgwMCBTVUNDRVNTCgpC
aXNlY3Rpbmc6IDEyMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgNyBzdGVwcykKW2M3OTQ5MGUxYjVlYmYzNTQxNTE0N2ZlMDZmMDJkOGU3N2NjZmU2ZDRd
IE5GQzogcG41MzM6IEF2b2lkIGZ1bmN0aW9uIGRlY2xhcmF0aW9ucwpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9v
YmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1jMy0wODI4L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDgy
ODE0NTQ6Yzc5NDkwZTFiNWViZjM1NDE1MTQ3ZmUwNmYwMmQ4ZTc3Y2NmZTZkNDpiaXNlY3Qt
dXNiCgoyMDEzLTA5LTAxLTAxOjE5OjI0IGM3OTQ5MGUxYjVlYmYzNTQxNTE0N2ZlMDZmMDJk
OGU3N2NjZmU2ZDQgY29tcGlsaW5nCjQ0IHJlYWwgIDE4OCB1c2VyICAyNiBzeXMgIDQ4NC42
MyUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4CgoyMDEzLTA5LTAxLTAxOjIwOjIx
IGRldGVjdGluZyBib290IHN0YXRlIDMuOS4wLXJjMS0wMDc3OS1nYzc5NDkwZS4uLgkxCTMJ
NwkxMQkxMgkxMwkyOAkzOAk1OAk3Mgk4NAk4OS4JOTQJMTAxCTEwNwkxMTAJMTE0CTEyMgkx
MjgJMTM2CTE0NgkxNTAJMTU4CTE2NAkxNzIuCTE3OQkxODYJMTg3CTE4OQkxOTQJMTk1Li4u
CTE5Ni4uCTE5Ny4JMTk4LgkxOTkuCTIwMgkyMDMJMjA0CTIwNQkyMDYJMjA3CTIwOC4JMjEy
CTIxMwkyMTkJMjIxCTIzOQkyNTgJMjY3LgkyNzEJMjcyCTI3NAkyNzUJMjc3CTI3OC4uCTI3
OS4uLi4JMjgwLgkyODEuCTI4MgkyODQuLi4uLgkyODUuCTI4Ni4uLi4uLi4uLi4uLi4JMjg3
CTI4OC4uLi4uLi4JMjg5Li4JMjkwLi4uLi4uCTI5MS4uLi4uLi4JMjkyLi4uCTI5My4uLi4u
Li4uLi4uLi4uLi4uLgkyOTQuLi4JMjk1Li4uLi4uLi4uLi4uLi4uLi4JMjk2Li4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLgkyOTcuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLgkyOTguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uCTI5OS4JMzAxLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMzAyLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkzMDMuLi4uLi4uLi4uLi4uLi4uLi4u
LgkzMDQuLgkzMDUuLi4JMzA2Li4uLi4uCTMwNy4uLi4uLi4JMzA4Li4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4JMzA5Li4uCTMxMS4uLi4uLi4uLi4JMzEyLi4uLi4uLi4JMzEzLi4uLi4u
CTMxNAkzMTUuLi4uLi4uLi4uLi4uLi4uLgkzMTYJMzE3CTMxOS4uCTMyMS4JMzIyLgkzMjQJ
MzI2LgkzMjcJMzI4CTMyOQkzMzAJMzMxLi4JMzM1CTMzOQkzNzAJMzgwCTM5Ngk0MTcJNDYx
CTQ5MQk1MzYJNTU3CTU4Mgk2MTcJNjQ5CTY3Ngk2OTEJNzAxLi4JNzA4CTcxMgk3MTUuCTcy
MAk3MjQuLgk3MjYJNzI3CTcyOQk3MzAuCTczMgk3MzMuLgk3MzQuCTczNgk3MzgJNzQ0CTc2
NAk3NzEJNzg2CTc4Nwk3OTEJNzkzCTc5NAk3OTgJNzk5Lgk4MDAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiA2MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBz
dGVwcykKWzA2ZDk2MWE4ZTIxMDAzNWJmZjdlODJmNDY2MTA3ZjlhYjRhOGZkOTRdIG1hYzgw
MjExL21pbnN0cmVsOiB1c2UgdGhlIG5ldyByYXRlIGNvbnRyb2wgQVBJCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNi
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLWMzLTA4MjgvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMw
ODI4MTQ1NDowNmQ5NjFhOGUyMTAwMzViZmY3ZTgyZjQ2NjEwN2Y5YWI0YThmZDk0OmJpc2Vj
dC11c2IKCjIwMTMtMDktMDEtMDc6MTg6MjkgMDZkOTYxYThlMjEwMDM1YmZmN2U4MmY0NjYx
MDdmOWFiNGE4ZmQ5NCBjb21waWxpbmcKMTA5IHJlYWwgIDE4MSB1c2VyICAyNCBzeXMgIDE4
Ni44NiUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4CgoyMDEzLTA5LTAxLTA3OjIw
OjM2IGRldGVjdGluZyBib290IHN0YXRlIDMuOS4wLXJjMS0wMDgxOS1nMDZkOTYxYS4uLi4u
LgkxCTUJNwk4Li4uLi4uLgk5Li4uLgkxMC4uLgkxMS4uLi4uLi4uLi4uLi4uLi4uCTEyLi4u
LgkxMwkxNAkxOC4JMjAJMjEJMjMJMzIJNTUgVEVTVCBGQUlMVVJFClsgICAzOS40NTExNjJd
IFN3aXRjaGluZyB0byBjbG9ja3NvdXJjZSB0c2MKWyAgIDM5LjQ1MzExOV0ga2VybmVsIHRy
aWVkIHRvIGV4ZWN1dGUgTlgtcHJvdGVjdGVkIHBhZ2UgLSBleHBsb2l0IGF0dGVtcHQ/ICh1
aWQ6IDApClsgICAzOS40NTMxMTldIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFn
aW5nIHJlcXVlc3QgYXQgZmZmZmZmZmY4MjQwYWQyMQpbICAgMzkuNDUzMTE5XSBJUDogWzxm
ZmZmZmZmZjgyNDBhZDIxPl0gY2xhc3Nlc19pbml0KzB4MjYvMHgyNgpbICAgMzkuNDUzMTE5
XSBQR0QgMjBhYzA2NyBQVUQgMjBhZDA2MyBQTUQgZjM3YzA2MyBQVEUgODAwMDAwMDAwMjQw
YTE2MwpbICAgMzkuNDUzMTE5XSBPb3BzOiAwMDExIFsjMV0gClsgICAzOS40NTMxMTldIENQ
VSAwIApbICAgMzkuNDUzMTE5XSBQaWQ6IDE3LCBjb21tOiBrd29ya2VyLzA6MSBOb3QgdGFp
bnRlZCAzLjkuMC1yYzEtMDA4MTktZzA2ZDk2MWEgIzM3MiAgClsgICAzOS40NTMxMTldIFJJ
UDogMDAxMDpbPGZmZmZmZmZmODI0MGFkMjE+XSAgWzxmZmZmZmZmZjgyNDBhZDIxPl0gY2xh
c3Nlc19pbml0KzB4MjYvMHgyNgpbICAgMzkuNDUzMTE5XSBSU1A6IDAwMDA6ZmZmZjg4MDAw
MDFkOWQ0OCAgRUZMQUdTOiAwMDAwMDI4MgpbICAgMzkuNDUzMTE5XSBSQVg6IDAwMDAwMDAw
MDAwMDAwMDEgUkJYOiBmZmZmZmZmZjgyMmZhMTQwIFJDWDogMDAwMDAwMDAwMDAwMDAwMApb
ICAgMzkuNDUzMTE5XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDEgUlNJOiBmZmZmZmZmZjgxNmRh
MDAwIFJESTogZmZmZmZmZmY4MjJmYTFlMApbICAgMzkuNDUzMTE5XSBSQlA6IGZmZmY4ODAw
MDAxZDlkNTggUjA4OiBmZmZmODgwMDAwMWQ2NTA4IFIwOTogMDAwMDAwMDAwMDAwMDAwMgpb
ICAgMzkuNDUzMTE5XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAxZjc0MGZkMmZh
MTQwIFIxMjogZmZmZjg4MDAwMDFjYTc5MApbICAgMzkuNDUzMTE5XSBSMTM6IGZmZmZmZmZm
ODIwYzZmYzAgUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogZmZmZjg4MDAwZTBjZTMwMApb
ICAgMzkuNDUzMTE5XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4
MjBiYTAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAzOS40NTMxMTldIENT
OiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgIDM5
LjQ1MzExOV0gQ1IyOiBmZmZmZmZmZjgyNDBhZDIxIENSMzogMDAwMDAwMDAwMjBhYjAwMCBD
UjQ6IDAwMDAwMDAwMDAwMDA2YjAKWyAgIDM5LjQ1MzExOV0gRFIwOiAwMDAwMDAwMDAwMDAw
MDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDM5
LjQ1MzExOV0gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDAwMDAwMDAwMCBE
Ujc6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDM5LjQ1MzExOV0gUHJvY2VzcyBrd29ya2VyLzA6
MSAocGlkOiAxNywgdGhyZWFkaW5mbyBmZmZmODgwMDAwMWQ4MDAwLCB0YXNrIGZmZmY4ODAw
MDAxZDYwMDApClsgICAzOS40NTMxMTldIFN0YWNrOgpbICAgMzkuNDUzMTE5XSAgZmZmZmZm
ZmY4MTZkYWM0OCBmZmZmZmZmZjgyMmZhMTQwIGZmZmY4ODAwMDAxZDlkNjggZmZmZmZmZmY4
MTZkMjRhOQpbICAgMzkuNDUzMTE5XSAgZmZmZjg4MDAwMDFkOWRlMCBmZmZmZmZmZjgxMDY3
NTQ0IGZmZmZmZmZmODEwNjc0ZTcgMDAwMDAwMDAwMDAwMDA4MgpbICAgMzkuNDUzMTE5XSAg
ZmZmZmZmZmY4MjJmYTE0MCBmZmZmZmZmZjgyNzZmODYwIDAwMDAwMDAwMDAwMDAwMDAgZmZm
ZmZmZmY4MjA0MzY2YgpbICAgMzkuNDUzMTE5XSBDYWxsIFRyYWNlOgpbICAgMzkuNDUzMTE5
XSAgWzxmZmZmZmZmZjgxNmRhYzQ4Pl0gPyBicmNtZl9zZGlvX2luaXQrMHgxOC8weDcwClsg
ICAzOS40NTMxMTldICBbPGZmZmZmZmZmODE2ZDI0YTk+XSBicmNtZl9kcml2ZXJfaW5pdCsw
eDkvMHgxMApbICAgMzkuNDUzMTE5XSAgWzxmZmZmZmZmZjgxMDY3NTQ0Pl0gcHJvY2Vzc19v
bmVfd29yaysweDFkNC8weDM4MApbICAgMzkuNDUzMTE5XSAgWzxmZmZmZmZmZjgxMDY3NGU3
Pl0gPyBwcm9jZXNzX29uZV93b3JrKzB4MTc3LzB4MzgwClsgICAzOS40NTMxMTldICBbPGZm
ZmZmZmZmODEwNjgyYWU+XSB3b3JrZXJfdGhyZWFkKzB4MTBlLzB4M2MwClsgICAzOS40NTMx
MTldICBbPGZmZmZmZmZmODEwNjgxYTA+XSA/IGJ1c3lfd29ya2VyX3JlYmluZF9mbisweDkw
LzB4OTAKWyAgIDM5LjQ1MzExOV0gIFs8ZmZmZmZmZmY4MTA2ZGM0Nz5dIGt0aHJlYWQrMHhl
Ny8weGYwClsgICAzOS40NTMxMTldICBbPGZmZmZmZmZmODEwNzVhYTc+XSA/IGZpbmlzaF90
YXNrX3N3aXRjaC5jb25zdHByb3AuNjIrMHgzNy8weGQwClsgICAzOS40NTMxMTldICBbPGZm
ZmZmZmZmODEwNmRiNjA+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg4MC8weDgwClsgICAzOS40
NTMxMTldICBbPGZmZmZmZmZmODFhNzlmYmE+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApb
ICAgMzkuNDUzMTE5XSAgWzxmZmZmZmZmZjgxMDZkYjYwPl0gPyBfX2t0aHJlYWRfcGFya21l
KzB4ODAvMHg4MApbICAgMzkuNDUzMTE5XSBDb2RlOiBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyA8
Y2M+IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNj
IGNjIGNjIGNjIApbICAgMzkuNDUzMTE5XSBSSVAgIFs8ZmZmZmZmZmY4MjQwYWQyMT5dIGNs
YXNzZXNfaW5pdCsweDI2LzB4MjYKWyAgIDM5LjQ1MzExOV0gIFJTUCA8ZmZmZjg4MDAwMDFk
OWQ0OD4KWyAgIDM5LjQ1MzExOV0gQ1IyOiBmZmZmZmZmZjgyNDBhZDIxClsgICAzOS40NTMx
MTldIC0tLVsgZW5kIHRyYWNlIGZmMWNkNmUyNjQ2MjcyNWQgXS0tLQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMzLTA4MjgvMDZkOTYxYThlMjEwMDM1YmZmN2U4MmY0NjYxMDdmOWFi
NGE4ZmQ5NC9kbWVzZy1rdm0tYW50LTE0ODU3LTIwMTMwOTAxMDc0ODE2LTMuMTEuMC1yYzUt
MTI3CgpCaXNlY3Rpbmc6IDI5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSA1IHN0ZXBzKQpbOTc5OTBhMDYwZTY3NTdmNDhiOTMxYTM5NDZiMTdjMWM0MzYy
YzNmYl0gbmw4MDIxMTogYWxsb3cgdXNpbmcgd2RldiBpZGVudGlmaWVycyB0byBnZXQgc2Nh
biByZXN1bHRzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMzLTA4MjgvbGludXgtZGV2ZWw6ZGV2
ZWwtY2Fpcm8teDg2XzY0LTIwMTMwODI4MTQ1NDo5Nzk5MGEwNjBlNjc1N2Y0OGI5MzFhMzk0
NmIxN2MxYzQzNjJjM2ZiOmJpc2VjdC11c2IKCjIwMTMtMDktMDEtMDc6NDk6NDAgOTc5OTBh
MDYwZTY3NTdmNDhiOTMxYTM5NDZiMTdjMWM0MzYyYzNmYiBjb21waWxpbmcKMjM3IHJlYWwg
IDEwNTggdXNlciAgMTAxIHN5cyAgNDg5LjAzJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMz
LTA4MjgKCjIwMTMtMDktMDEtMDc6NTM6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAt
cmMxLTAwMTUxLWc5Nzk5MGEwLi4uLgkxNgkyOQk0Mgk1Mgk3MwkxMTEJMTIxCTEyNgkxNDUJ
MTczCTE5NQkyMTUJMjM4CTI0NgkyODAJMzI2CTM3MwkzOTMJNDAzCTQzNgk1MzQJNTcwCTYy
MAk2NTYJNzA2CTc1Ngk3NzQJNzkxCTc5OC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAyG1swbQouLgk3OTkuLgk4MDAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiAxNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgNCBzdGVwcykKWzMxZWQwN2RjMWU4M2I3OTI2Y2U4ZWUyMjE1ZWEyMTU5OWEyMTU5OTBd
IGJyY21mbWFjOiByZW1vdmUgaWZpZHggdmFyaWFibGUgZnJvbSBicmNtZl9md3NfcHJvY2Vz
c19za2IoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4L2xpbnV4LWRldmVsOmRldmVs
LWNhaXJvLXg4Nl82NC0yMDEzMDgyODE0NTQ6MzFlZDA3ZGMxZTgzYjc5MjZjZThlZTIyMTVl
YTIxNTk5YTIxNTk5MDpiaXNlY3QtdXNiCgoyMDEzLTA5LTAxLTEwOjQzOjU0IDMxZWQwN2Rj
MWU4M2I3OTI2Y2U4ZWUyMjE1ZWEyMTU5OWEyMTU5OTAgY29tcGlsaW5nCjI0MyByZWFsICAx
MDE5IHVzZXIgIDk2IHN5cyAgNDU5LjA4JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMzLTA4
MjgKCjIwMTMtMDktMDEtMTA6NDg6MTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAtcmMx
LTAwNzc0LWczMWVkMDdkLi4uCTEJNgk3CTkuLgkxMAkxMi4uCTE0CTE1LgkxNgkxOC4uLi4u
Li4uLi4uLi4uLgkxOS4JMjAuLgkyMS4JMjIJMjMJMjQJMjguCTM2CTM4CTQzCTQ3CTQ5Lgk1
MC4JNTIJNzcgVEVTVCBGQUlMVVJFClsgICAyNy42MjQ0NTNdIEZyZWVpbmcgdW51c2VkIGtl
cm5lbCBtZW1vcnk6IDcwOGsgZnJlZWQKWyAgIDI3LjY4Mjc1MF0ga2VybmVsIHRyaWVkIHRv
IGV4ZWN1dGUgTlgtcHJvdGVjdGVkIHBhZ2UgLSBleHBsb2l0IGF0dGVtcHQ/ICh1aWQ6IDAp
ClsgICAyNy42ODMzMTVdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJl
cXVlc3QgYXQgZmZmZmZmZmY4MjQwYWQyMQpbICAgMjcuNjgzODgzXSBJUDogWzxmZmZmZmZm
ZjgyNDBhZDIxPl0gY2xhc3Nlc19pbml0KzB4MjYvMHgyNgpbICAgMjcuNjg1NDYwXSBQR0Qg
MjBhYzA2NyBQVUQgMjBhZDA2MyBQTUQgZjM3NzA2MyBQVEUgODAwMDAwMDAwMjQwYTE2Mwpb
ICAgMjcuNjg1NDYxXSBPb3BzOiAwMDExIFsjMV0gClsgICAyNy42ODU0NjFdIENQVSAwIApb
ICAgMjcuNjg1NDYxXSBQaWQ6IDE3LCBjb21tOiBrd29ya2VyLzA6MSBOb3QgdGFpbnRlZCAz
LjkuMC1yYzEtMDA3NzQtZzMxZWQwN2QgIzM3NCAgClsgICAyNy42ODU0NjFdIFJJUDogMDAx
MDpbPGZmZmZmZmZmODI0MGFkMjE+XSAgWzxmZmZmZmZmZjgyNDBhZDIxPl0gY2xhc3Nlc19p
bml0KzB4MjYvMHgyNgpbICAgMjcuNjg1NDYxXSBSU1A6IDAwMDA6ZmZmZjg4MDAwMDFkOWQ0
OCAgRUZMQUdTOiAwMDAwMDI4MgpbICAgMjcuNjg1NDYxXSBSQVg6IDAwMDAwMDAwMDAwMDAw
MDEgUkJYOiBmZmZmZmZmZjgyMmZhMTQwIFJDWDogMDAwMDAwMDAwMDAwMDAwMApbICAgMjcu
Njg1NDYxXSBSRFg6IDAwMDAwMDAwMDAwMDAwMDEgUlNJOiBmZmZmZmZmZjgxNmQ5ZmQwIFJE
STogZmZmZmZmZmY4MjJmYTFlMApbICAgMjcuNjg1NDYxXSBSQlA6IGZmZmY4ODAwMDAxZDlk
NTggUjA4OiBmZmZmODgwMDAwMWQ2NTA4IFIwOTogMDAwMDAwMDAwMDAwMDAwMgpbICAgMjcu
Njg1NDYxXSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAxZjc0MGZkMmZhMTQwIFIx
MjogZmZmZjg4MDAwMDFjYTc5MApbICAgMjcuNjg1NDYxXSBSMTM6IGZmZmZmZmZmODIwYzZm
YzAgUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogZmZmZjg4MDAwZTBjZTMwMApbICAgMjcu
Njg1NDYxXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4MjBiYTAw
MCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAyNy42ODU0NjFdIENTOiAgMDAx
MCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgIDI3LjY4NTQ2
MV0gQ1IyOiBmZmZmZmZmZjgyNDBhZDIxIENSMzogMDAwMDAwMDAwMjBhYjAwMCBDUjQ6IDAw
MDAwMDAwMDAwMDA2YjAKWyAgIDI3LjY4NTQ2MV0gRFIwOiAwMDAwMDAwMDAwMDAwMDAwIERS
MTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDI3LjY4NTQ2
MV0gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDAwMDAwMDAwMCBEUjc6IDAw
MDAwMDAwMDAwMDAwMDAKWyAgIDI3LjY4NTQ2MV0gUHJvY2VzcyBrd29ya2VyLzA6MSAocGlk
OiAxNywgdGhyZWFkaW5mbyBmZmZmODgwMDAwMWQ4MDAwLCB0YXNrIGZmZmY4ODAwMDAxZDYw
MDApClsgICAyNy42ODU0NjFdIFN0YWNrOgpbICAgMjcuNjg1NDYxXSAgZmZmZmZmZmY4MTZk
YWMxOCBmZmZmZmZmZjgyMmZhMTQwIGZmZmY4ODAwMDAxZDlkNjggZmZmZmZmZmY4MTZkMjQ3
OQpbICAgMjcuNjg1NDYxXSAgZmZmZjg4MDAwMDFkOWRlMCBmZmZmZmZmZjgxMDY3NTQ0IGZm
ZmZmZmZmODEwNjc0ZTcgMDAwMDAwMDAwMDAwMDA4MgpbICAgMjcuNjg1NDYxXSAgZmZmZmZm
ZmY4MjJmYTE0MCBmZmZmZmZmZjgyNzZmMjkwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4
MjA0MjUwYgpbICAgMjcuNjg1NDYxXSBDYWxsIFRyYWNlOgpbICAgMjcuNjg1NDYxXSAgWzxm
ZmZmZmZmZjgxNmRhYzE4Pl0gPyBicmNtZl9zZGlvX2luaXQrMHgxOC8weDcwClsgICAyNy42
ODU0NjFdICBbPGZmZmZmZmZmODE2ZDI0Nzk+XSBicmNtZl9kcml2ZXJfaW5pdCsweDkvMHgx
MApbICAgMjcuNjg1NDYxXSAgWzxmZmZmZmZmZjgxMDY3NTQ0Pl0gcHJvY2Vzc19vbmVfd29y
aysweDFkNC8weDM4MApbICAgMjcuNjg1NDYxXSAgWzxmZmZmZmZmZjgxMDY3NGU3Pl0gPyBw
cm9jZXNzX29uZV93b3JrKzB4MTc3LzB4MzgwClsgICAyNy42ODU0NjFdICBbPGZmZmZmZmZm
ODEwNjgyYWU+XSB3b3JrZXJfdGhyZWFkKzB4MTBlLzB4M2MwClsgICAyNy42ODU0NjFdICBb
PGZmZmZmZmZmODEwNjgxYTA+XSA/IGJ1c3lfd29ya2VyX3JlYmluZF9mbisweDkwLzB4OTAK
WyAgIDI3LjY4NTQ2MV0gIFs8ZmZmZmZmZmY4MTA2ZGM0Nz5dIGt0aHJlYWQrMHhlNy8weGYw
ClsgICAyNy42ODU0NjFdICBbPGZmZmZmZmZmODEwNzVhYTc+XSA/IGZpbmlzaF90YXNrX3N3
aXRjaC5jb25zdHByb3AuNjIrMHgzNy8weGQwClsgICAyNy42ODU0NjFdICBbPGZmZmZmZmZm
ODEwNmRiNjA+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg4MC8weDgwClsgICAyNy42ODU0NjFd
ICBbPGZmZmZmZmZmODFhNzhmM2E+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgMjcu
Njg1NDYxXSAgWzxmZmZmZmZmZjgxMDZkYjYwPl0gPyBfX2t0aHJlYWRfcGFya21lKzB4ODAv
MHg4MApbICAgMjcuNjg1NDYxXSBDb2RlOiBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyA8Y2M+IGNj
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNj
IGNjIApbICAgMjcuNjg1NDYxXSBSSVAgIFs8ZmZmZmZmZmY4MjQwYWQyMT5dIGNsYXNzZXNf
aW5pdCsweDI2LzB4MjYKWyAgIDI3LjY4NTQ2MV0gIFJTUCA8ZmZmZjg4MDAwMDFkOWQ0OD4K
WyAgIDI3LjY4NTQ2MV0gQ1IyOiBmZmZmZmZmZjgyNDBhZDIxClsgICAyNy42ODU0NjFdIC0t
LVsgZW5kIHRyYWNlIDRjMzM5YzZkMWNhZGM4OGMgXS0tLQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWMzLTA4MjgvMzFlZDA3ZGMxZTgzYjc5MjZjZThlZTIyMTVlYTIxNTk5YTIxNTk5
MC9kbWVzZy1rdm0tYW50LTIyMDItMjAxMzA5MDExMTE0MjQtMy4xMS4wLXJjNi0wMTAzOS1n
YmEzOTc2Ny0yMDUKCkJpc2VjdGluZzogNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzFlOWFiNGRkMjU4ZWNiYjBmMWMzNzdmZDRkYmUy
MjdjZGI5M2Q5YmRdIGJyY21mbWFjOiBzZXR1cCBTRElPIHJlc2V0IGJlaGF2aW9yCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93
ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWMzLTA4MjgvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0
LTIwMTMwODI4MTQ1NDoxZTlhYjRkZDI1OGVjYmIwZjFjMzc3ZmQ0ZGJlMjI3Y2RiOTNkOWJk
OmJpc2VjdC11c2IKCjIwMTMtMDktMDEtMTE6MTU6NDMgMWU5YWI0ZGQyNThlY2JiMGYxYzM3
N2ZkNGRiZTIyN2NkYjkzZDliZCBjb21waWxpbmcKNDQgcmVhbCAgNjEgdXNlciAgMTYgc3lz
ICAxNzUuOTglIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzMtMDgyOAoKMjAxMy0wOS0wMS0x
MToxNjozOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC1yYzEtMDA3NjYtZzFlOWFiNGQu
Li4JNQk4CTIwCTI1CTM1CTUxCTYxCTc1CTk0CTEwOAkxMjUJMTM2CTE1NAkxNzkJMTg4CTE5
OAkyMTMJMjQ5CTI1OAkyODAJMzAyCTMyNQkzNDEJMzYxCTM4MwkzOTcJNDIwCTQ0NQk0NjUJ
NTAwCTUyOAk1NDMJNTY4CTYyMwk2NTUJNjk5CTczNQk3NTkJNzY2CTc3Mwk3NzguLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgMjIbWzBt
Ci4uCTc4Mgk3ODQJNzg2Lgk3ODkJNzkxCTc5Mgk3OTUJNzk2CTc5OS4JODAwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMiBzdGVwcykKWzY2ODc2MWFjMDFkNmY1YTM2YjhlNWEyNGQ0ZTE1NDU1MGUyYzRjM2Jd
IGJyY21mbWFjOiBkZWZpbmUgYW5kIHVzZSBwbGF0Zm9ybSBzcGVjaWZpYyBkYXRhIGZvciBT
RElPLgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4L2xpbnV4LWRldmVsOmRldmVsLWNh
aXJvLXg4Nl82NC0yMDEzMDgyODE0NTQ6NjY4NzYxYWMwMWQ2ZjVhMzZiOGU1YTI0ZDRlMTU0
NTUwZTJjNGMzYjpiaXNlY3QtdXNiCgoyMDEzLTA5LTAxLTE0OjE2OjEzIDY2ODc2MWFjMDFk
NmY1YTM2YjhlNWEyNGQ0ZTE1NDU1MGUyYzRjM2IgY29tcGlsaW5nCjkyIHJlYWwgIDU0IHVz
ZXIgIDEyIHN5cyAgNzIuNzMlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzMtMDgyOAoKMjAx
My0wOS0wMS0xNDoxODowMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC1yYzEtMDA3NzAt
ZzY2ODc2MWEuLgkxLi4JMi4uLi4uLi4uLi4uLi4JMy4uLi4uLi4uLi4JNC4uCTYuLgk3Li4u
Li4uLi4uLi4JOAk5Li4uLi4uCTEwCTExLi4uLi4JMTIJMTMuLi4uCTE0LgkxNQkxNy4uLi4u
CTE4LgkxOS4uCTIxCTIyCTI1CTI5CTMwLgkzNAkzOCBURVNUIEZBSUxVUkUKWyAgIDM1LjU4
MzgzNV0gU3dpdGNoaW5nIHRvIGNsb2Nrc291cmNlIHRzYwpbICAgMzUuNTg2OTUwXSBrZXJu
ZWwgdHJpZWQgdG8gZXhlY3V0ZSBOWC1wcm90ZWN0ZWQgcGFnZSAtIGV4cGxvaXQgYXR0ZW1w
dD8gKHVpZDogMCkKWyAgIDM1LjU4Nzc4MV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5l
bCBwYWdpbmcgcmVxdWVzdCBhdCBmZmZmZmZmZjgyNDBhZDIxClsgICAzNS41ODg1ODJdIElQ
OiBbPGZmZmZmZmZmODI0MGFkMjE+XSBjbGFzc2VzX2luaXQrMHgyNi8weDI2ClsgICAzNS41
ODg1ODJdIFBHRCAyMGFjMDY3IFBVRCAyMGFkMDYzIFBNRCBmMzgzMDYzIFBURSA4MDAwMDAw
MDAyNDBhMTYzClsgICAzNS41ODg1ODJdIE9vcHM6IDAwMTEgWyMxXSAKWyAgIDM1LjU4ODU4
Ml0gQ1BVIDAgClsgICAzNS41ODg1ODJdIFBpZDogMTcsIGNvbW06IGt3b3JrZXIvMDoxIE5v
dCB0YWludGVkIDMuOS4wLXJjMS0wMDc3MC1nNjY4NzYxYSAjMzc2ICAKWyAgIDM1LjU4ODU4
Ml0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MjQwYWQyMT5dICBbPGZmZmZmZmZmODI0MGFkMjE+
XSBjbGFzc2VzX2luaXQrMHgyNi8weDI2ClsgICAzNS41ODg1ODJdIFJTUDogMDAwMDpmZmZm
ODgwMDAwMWQ5ZDQ4ICBFRkxBR1M6IDAwMDAwMjgyClsgICAzNS41ODg1ODJdIFJBWDogMDAw
MDAwMDAwMDAwMDAwMSBSQlg6IGZmZmZmZmZmODIyZmExNDAgUkNYOiAwMDAwMDAwMDAwMDAw
MDAwClsgICAzNS41ODg1ODJdIFJEWDogMDAwMDAwMDAwMDAwMDAwMSBSU0k6IGZmZmZmZmZm
ODE2ZDlmNTAgUkRJOiBmZmZmZmZmZjgyMmZhMWUwClsgICAzNS41ODg1ODJdIFJCUDogZmZm
Zjg4MDAwMDFkOWQ1OCBSMDg6IGZmZmY4ODAwMDAxZDY1MDggUjA5OiAwMDAwMDAwMDAwMDAw
MDAyClsgICAzNS41ODg1ODJdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDFmNzQw
ZmQyZmExNDAgUjEyOiBmZmZmODgwMDAwMWNhNzkwClsgICAzNS41ODg1ODJdIFIxMzogZmZm
ZmZmZmY4MjBjNmZjMCBSMTQ6IDAwMDAwMDAwMDAwMDAwMDAgUjE1OiBmZmZmODgwMDBlMGNl
MzAwClsgICAzNS41ODg1ODJdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZm
ZmZmZjgyMGJhMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgIDM1LjU4ODU4
Ml0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpb
ICAgMzUuNTg4NTgyXSBDUjI6IGZmZmZmZmZmODI0MGFkMjEgQ1IzOiAwMDAwMDAwMDAyMGFi
MDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgMzUuNTg4NTgyXSBEUjA6IDAwMDAwMDAw
MDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMApb
ICAgMzUuNTg4NTgyXSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMDAwMDAw
MDAwIERSNzogMDAwMDAwMDAwMDAwMDAwMApbICAgMzUuNTg4NTgyXSBQcm9jZXNzIGt3b3Jr
ZXIvMDoxIChwaWQ6IDE3LCB0aHJlYWRpbmZvIGZmZmY4ODAwMDAxZDgwMDAsIHRhc2sgZmZm
Zjg4MDAwMDFkNjAwMCkKWyAgIDM1LjU4ODU4Ml0gU3RhY2s6ClsgICAzNS41ODg1ODJdICBm
ZmZmZmZmZjgxNmRhYjk4IGZmZmZmZmZmODIyZmExNDAgZmZmZjg4MDAwMDFkOWQ2OCBmZmZm
ZmZmZjgxNmQyM2Y5ClsgICAzNS41ODg1ODJdICBmZmZmODgwMDAwMWQ5ZGUwIGZmZmZmZmZm
ODEwNjc1NDQgZmZmZmZmZmY4MTA2NzRlNyAwMDAwMDAwMDAwMDAwMDgyClsgICAzNS41ODg1
ODJdICBmZmZmZmZmZjgyMmZhMTQwIGZmZmZmZmZmODI3NmY2NzAgMDAwMDAwMDAwMDAwMDAw
MCBmZmZmZmZmZjgyMDQyNGYzClsgICAzNS41ODg1ODJdIENhbGwgVHJhY2U6ClsgICAzNS41
ODg1ODJdICBbPGZmZmZmZmZmODE2ZGFiOTg+XSA/IGJyY21mX3NkaW9faW5pdCsweDE4LzB4
NzAKWyAgIDM1LjU4ODU4Ml0gIFs8ZmZmZmZmZmY4MTZkMjNmOT5dIGJyY21mX2RyaXZlcl9p
bml0KzB4OS8weDEwClsgICAzNS41ODg1ODJdICBbPGZmZmZmZmZmODEwNjc1NDQ+XSBwcm9j
ZXNzX29uZV93b3JrKzB4MWQ0LzB4MzgwClsgICAzNS41ODg1ODJdICBbPGZmZmZmZmZmODEw
Njc0ZTc+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHgxNzcvMHgzODAKWyAgIDM1LjU4ODU4Ml0g
IFs8ZmZmZmZmZmY4MTA2ODJhZT5dIHdvcmtlcl90aHJlYWQrMHgxMGUvMHgzYzAKWyAgIDM1
LjU4ODU4Ml0gIFs8ZmZmZmZmZmY4MTA2ODFhMD5dID8gYnVzeV93b3JrZXJfcmViaW5kX2Zu
KzB4OTAvMHg5MApbICAgMzUuNTg4NTgyXSAgWzxmZmZmZmZmZjgxMDZkYzQ3Pl0ga3RocmVh
ZCsweGU3LzB4ZjAKWyAgIDM1LjU4ODU4Ml0gIFs8ZmZmZmZmZmY4MTA3NWFhNz5dID8gZmlu
aXNoX3Rhc2tfc3dpdGNoLmNvbnN0cHJvcC42MisweDM3LzB4ZDAKWyAgIDM1LjU4ODU4Ml0g
IFs8ZmZmZmZmZmY4MTA2ZGI2MD5dID8gX19rdGhyZWFkX3BhcmttZSsweDgwLzB4ODAKWyAg
IDM1LjU4ODU4Ml0gIFs8ZmZmZmZmZmY4MWE3OGViYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8w
eGIwClsgICAzNS41ODg1ODJdICBbPGZmZmZmZmZmODEwNmRiNjA+XSA/IF9fa3RocmVhZF9w
YXJrbWUrMHg4MC8weDgwClsgICAzNS41ODg1ODJdIENvZGU6IGNjIGNjIGNjIGNjIGNjIGNj
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNj
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNj
IGNjIDxjYz4gY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MgClsgICAzNS41ODg1ODJdIFJJUCAgWzxmZmZmZmZmZjgyNDBhZDIx
Pl0gY2xhc3Nlc19pbml0KzB4MjYvMHgyNgpbICAgMzUuNTg4NTgyXSAgUlNQIDxmZmZmODgw
MDAwMWQ5ZDQ4PgpbICAgMzUuNTg4NTgyXSBDUjI6IGZmZmZmZmZmODI0MGFkMjEKWyAgIDM1
LjU4ODU4Ml0gLS0tWyBlbmQgdHJhY2UgMDNiZmEzNjlkMmU5MzhhMCBdLS0tCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYzMtMDgyOC82Njg3NjFhYzAxZDZmNWEzNmI4ZTVhMjRkNGUx
NTQ1NTBlMmM0YzNiL2RtZXNnLWt2bS1hbnQtMjI2Ny0yMDEzMDkwMTE1MDMwNi0zLjExLjAt
cmMzLTAwMjQ3LWdiMjFlM2FmLTE3OQoKQmlzZWN0aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzM2OTUwOGM1NjU2ZGIyOTBmMDli
MzJkMjEzZWZmZWVhNmMxNDMxYjhdIGJyY21mbWFjOiBBZGQgNDMxNDMgU0RJTyBzdXBwb3J0
LgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4L2xpbnV4LWRldmVsOmRldmVsLWNhaXJv
LXg4Nl82NC0yMDEzMDgyODE0NTQ6MzY5NTA4YzU2NTZkYjI5MGYwOWIzMmQyMTNlZmZlZWE2
YzE0MzFiODpiaXNlY3QtdXNiCgoyMDEzLTA5LTAxLTE1OjAzOjM3IDM2OTUwOGM1NjU2ZGIy
OTBmMDliMzJkMjEzZWZmZWVhNmMxNDMxYjggY29tcGlsaW5nCjM0IHJlYWwgIDQ4IHVzZXIg
IDE3IHN5cyAgMTkwLjI2JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMzLTA4MjgKCjIwMTMt
MDktMDEtMTU6MDQ6MjIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAtcmMxLTAwNzY4LWcz
Njk1MDhjLi4uCTEuLgkxMAkxNQkyNQkzOAk1MQk3NAk5NwkxMTAJMTIxCTE0MQkxNTkJMTgz
CTIwMgkyMjMJMjM4CTI2NAkyODcJMzA1CTMyNAkzMzgJMzYxCTM4Mgk0MTAJNDI4CTQ1Ngk0
ODEJNDk5CTUxOQk1MzcJNTU5CTU4Mwk2MDgJNjMyCTY1Mwk2NjEJNjY2CTY2OAk2NzQuCTY4
MQk2ODYJNjkxCTY5NQk3MDkJNzE3CTcyMwk3MjkJNzM1CTczNwk3NDAuCTc0Ngk3NTEJNzU4
CTc2Mwk3NjgJNzczLgk3NzQuLgk3NzUuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
G1sxOzM1bWFkZF90b19ydW5fcXVldWUgMjUbWzBtCi4uLi4uLi4uLi4JNzc2Lgk3NzcJNzgz
CTc4NQk3ODYJNzg4Lgk3ODkJNzk2Li4uCTc5Ny4uLi4uLi4uLgk3OTgJNzk5Li4uLi4uLgk4
MDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbOTc5YzI5MjA1ZmZhNjA3YzU5YmEyYzlmOWMwODNi
OTY3ZDM1NmM5N10gYnJjbWZtYWM6IEFkZCBkcml2ZSBzdHJlbmd0aCBwcm9ncmFtbWluZyBm
b3IgU0RJTyA0MzE0My4KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzMtMDgyOC9saW51eC1kZXZl
bDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA4MjgxNDU0Ojk3OWMyOTIwNWZmYTYwN2M1OWJh
MmM5ZjljMDgzYjk2N2QzNTZjOTc6YmlzZWN0LXVzYgoKMjAxMy0wOS0wMS0xODozMDoyNiA5
NzljMjkyMDVmZmE2MDdjNTliYTJjOWY5YzA4M2I5NjdkMzU2Yzk3IGNvbXBpbGluZwo2OCBy
ZWFsICA0MiB1c2VyICAxMyBzeXMgIDgxLjI3JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMz
LTA4MjgKCjIwMTMtMDktMDEtMTg6MzE6NDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAt
cmMxLTAwNzY5LWc5NzljMjkyLi4uLi4uCTIJNAkxMi4uLgkxMy4JMTQJMTcuLi4uCTE4Lgkx
OQkyMAkyMgkyNgkyOQkzNwk0MAk0Mwk0Nwk1MAk1OQk3MwkxMDIJMTE1CTEyOQkxNTEJMTc0
CTE5NwkyMTIJMjEzCTI0NQkyODIJMzIwCTM1MwkzODAJNDE1CTQ1Mgk0NjYJNTEzCTU1MQk1
NzQJNTkyCTYxMwk2MTkJNjI2CTYzMwk2MzkJNjQ4CTY1Mgk2NTYJNjYwCTY2NQk2NjcJNjcz
CTY3Nwk2ODEuCTY4Ngk2ODcJNjkwCTY5MS4JNjkyCTY5NAk2OTUJNjk2CTY5Nwk2OTgJNjk5
CTcwNAk3MDYuLgk3MDguCTcwOS4uCTcxMC4uLgk3MTEuCTcxMi4uCTcxNAk3MTUuLi4uCTcx
Ny4uLi4uLi4uLi4uLi4uCTcxOS4uCTcyMQk3MjIJNzIzCTcyNS4uLi4JNzI3Lgk3MjguLi4u
Li4uLgk3MzEuLgk3MzIuCTczNQk3NDEJNzQzLgk3NDYJNzQ5CTc2MQk3NzMJNzg3CTc4OC4u
CTc5Mgk3OTYuLi4JNzk3CTgwMCBTVUNDRVNTCgo2Njg3NjFhYzAxZDZmNWEzNmI4ZTVhMjRk
NGUxNTQ1NTBlMmM0YzNiIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCA2Njg3NjFh
YzAxZDZmNWEzNmI4ZTVhMjRkNGUxNTQ1NTBlMmM0YzNiCkF1dGhvcjogSGFudGUgTWV1bGVt
YW4gPG1ldWxlbWFuQGJyb2FkY29tLmNvbT4KRGF0ZTogICBGcmkgQXByIDEyIDEwOjU1OjU1
IDIwMTMgKzAyMDAKCiAgICBicmNtZm1hYzogZGVmaW5lIGFuZCB1c2UgcGxhdGZvcm0gc3Bl
Y2lmaWMgZGF0YSBmb3IgU0RJTy4KICAgIAogICAgVGhpcyBwYXRjaCBhZGRzIHN1cHBvcnQg
Zm9yIHBsYXRmb3JtIHNwZWNpZmljIGRhdGEgZm9yIFNESU8KICAgIGZ1bGxtYWMgZGV2aWNl
cy4gQ3VycmVudGx5IE9PQiBpbnRlcnJ1cHRzIGFyZSBjb25maWd1cmVkIGJ5IEtjb25maWcK
ICAgIEJSQ01GTUFDX1NESU9fT09CIGJ1dCB0aGF0IGlzIG5vdyBkZXRlcm1pbmVkIGR5bmFt
aWNhbGx5IGJ5IGNoZWNraW5nCiAgICBhdmFpbGliaWxpdHkgb2YgcGxhdGZvcm0gZGF0YS4K
ICAgIAogICAgQ2M6IEhhdWtlIE1laHJ0ZW5zIDxoYXVrZUBoYXVrZS1tLmRlPgogICAgUmV2
aWV3ZWQtYnk6IEFyZW5kIFZhbiBTcHJpZWwgPGFyZW5kQGJyb2FkY29tLmNvbT4KICAgIFJl
dmlld2VkLWJ5OiBGcmFua3kgKFpoZW5odWkpIExpbiA8ZnJhbmt5bEBicm9hZGNvbS5jb20+
CiAgICBSZXZpZXdlZC1ieTogUGlldGVyLVBhdWwgR2llc2JlcnRzIDxwaWV0ZXJwZ0Bicm9h
ZGNvbS5jb20+CiAgICBSZXZpZXdlZC1ieTogUGlvdHIgSGFiZXIgPHBoYWJlckBicm9hZGNv
bS5jb20+CiAgICBTaWduZWQtb2ZmLWJ5OiBIYW50ZSBNZXVsZW1hbiA8bWV1bGVtYW5AYnJv
YWRjb20uY29tPgogICAgU2lnbmVkLW9mZi1ieTogQXJlbmQgdmFuIFNwcmllbCA8YXJlbmRA
YnJvYWRjb20uY29tPgogICAgU2lnbmVkLW9mZi1ieTogSm9obiBXLiBMaW52aWxsZSA8bGlu
dmlsbGVAdHV4ZHJpdmVyLmNvbT4KCjowNDAwMDAgMDQwMDAwIDYyY2VlMzllMWY2ZjQwYmRl
M2I2MGJkNDhjODBkYzFhY2M1MWY4NTEgZmJiY2RlODc5MjVkZGNlNmI2YjViMjEyNDZkODM1
MmRjMmViZGE5NSBNCWRyaXZlcnMKOjA0MDAwMCAwNDAwMDAgZmU4OTlmNDQ0MTNmZDRmOGFh
OTkwZTIxYWQxZmQwMDc1NmI4ZmEyOCA2NDBlMGJjZTg5MzliNzMxOTkzYzFmZDgyYjU2NjQ2
MTU2YWRhNjczIE0JaW5jbHVkZQpiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMzLTA4MjgvbGludXgtZGV2
ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwODI4MTQ1NDo5NzljMjkyMDVmZmE2MDdjNTli
YTJjOWY5YzA4M2I5NjdkMzU2Yzk3OmJpc2VjdC11c2IKCjIwMTMtMDktMDEtMTk6NTQ6NDgg
OTc5YzI5MjA1ZmZhNjA3YzU5YmEyYzlmOWMwODNiOTY3ZDM1NmM5NyByZXVzZSAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMzLTA4MjgvOTc5YzI5MjA1ZmZhNjA3YzU5YmEyYzlmOWMw
ODNiOTY3ZDM1NmM5Ny92bWxpbnV6LTMuOS4wLXJjMS0wMDc2OS1nOTc5YzI5MgoKMjAxMy0w
OS0wMS0xOTo1NDo1MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uCTgyNAk4NTEJODUzCTg1
OAk4NzIJODc5CTg4MC4uLi4uLi4JODgzLi4uLi4uCTg4NC4uLi4uLi4uCTg4NQk4ODcuLgk4
OTAuCTg5MS4uCTg5Mgk4OTMuLgk4OTcJODk4CTg5OS4JOTAwLgk5MTAJOTMyCTk2MAk5ODEJ
MTAwMAkxMDMyCTEwOTMJMTEyNAkxMTM4CTExNzYJMTIwMwkxMjUwCTEzMDMJMTM1MAkxMzkx
CTE0MjQJMTQ3MAkxNTEzCTE1NzMJMTU4OAkxNTk5CTE2MDkJMTYyMAkxNjMxCTE2NDAJMTY0
NgkxNjQ5CTE2NjIJMTY2NQkxNjY3CTE2NzQJMTY4MwkxNzMxCTE3NjgJMTc5NQkxODMxCTE4
NzQJMTkxNQkxOTQ3CTE5OTIJMjAzNAkyMDY5CTIwOTYJMjExNwkyMTYzCTIyMDkJMjI0OQky
MjgzCTIzMDUJMjMyMQkyMzQ2CTIzNTUJMjM2Mi4JMjM3MC4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAzMBtbMG0KLi4uLi4uLi4uLi4J
MjM3MS4uLi4uLi4uLi4uLgkyMzczLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjM3NC4uCTIzNzUJ
MjM3Ni4uLgkyMzc3Li4uLi4uLi4uLi4uLi4uCTIzNzguLi4uLi4uLgkyMzc5Li4uLi4uLi4u
Li4uLi4JMjM4MC4JMjM4MS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4JMjM4Mi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
LgkyMzgzLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTIzODQuLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4JMjM4NS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjM4Ni4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkyMzg3Li4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjM4OC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjM4OS4u
Li4uLi4uLi4uLi4uLi4uCTIzOTAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLgkyMzkxLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTIzOTIuLi4u
Li4uLi4uLi4uLi4uCTIzOTMuLi4uLi4uCTIzOTQuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLgkyMzk1Li4uCTIzOTYuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLgkyMzk3Li4uLi4uLi4uLi4uLi4uLi4JMjM5OC4uLi4uLi4uLi4u
CTIzOTkuLi4uLgkyNDAwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4L2xpbnV4LWRldmVsOmRldmVsLWNhaXJv
LXg4Nl82NC0yMDEzMDgyODE0NTQ6YzUyZGQ3Zjk0YzVkNTM4NjQxM2NiOTU0NjJhYzgwMjg0
N2ZhNWYzYTpiaXNlY3QtdXNiCiBURVNUIEZBSUxVUkUKWyAgIDMxLjkwNjg4OV0gU3dpdGNo
ZWQgdG8gY2xvY2tzb3VyY2UgdHNjClsgICAzMS45MDk2NjBdIGtlcm5lbCB0cmllZCB0byBl
eGVjdXRlIE5YLXByb3RlY3RlZCBwYWdlIC0gZXhwbG9pdCBhdHRlbXB0PyAodWlkOiAwKQpb
ICAgMzEuOTA5NjYwXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1
ZXN0IGF0IGZmZmZmZmZmODIxOTY0NDYKWyAgIDMxLjkwOTY2MF0gSVA6IFs8ZmZmZmZmZmY4
MjE5NjQ0Nj5dIGNsYXNzZXNfaW5pdCsweDI2LzB4MjYKWyAgIDMxLjkwOTY2MF0gUEdEIDFl
NzYwNjcgUFVEIDFlNzcwNjMgUE1EIGYzOGUwNjMgUFRFIDgwMDAwMDAwMDIxOTYxNjMKWyAg
IDMxLjkwOTY2MF0gT29wczogMDAxMSBbIzFdIApbICAgMzEuOTA5NjYwXSBDUFU6IDAgUElE
OiAxNyBDb21tOiBrd29ya2VyLzA6MSBOb3QgdGFpbnRlZCAzLjExLjAtcmM3LTAwNDQ0LWdj
NTJkZDdmICMyMwpbICAgMzEuOTA5NjYwXSBXb3JrcXVldWU6IGV2ZW50cyBicmNtZl9kcml2
ZXJfaW5pdApbICAgMzEuOTA5NjYwXSB0YXNrOiBmZmZmODgwMDBkM2RjMDAwIHRpOiBmZmZm
ODgwMDBkM2RlMDAwIHRhc2sudGk6IGZmZmY4ODAwMGQzZGUwMDAKWyAgIDMxLjkwOTY2MF0g
UklQOiAwMDEwOls8ZmZmZmZmZmY4MjE5NjQ0Nj5dICBbPGZmZmZmZmZmODIxOTY0NDY+XSBj
bGFzc2VzX2luaXQrMHgyNi8weDI2ClsgICAzMS45MDk2NjBdIFJTUDogMDAwMDpmZmZmODgw
MDBkM2RmZDQwICBFRkxBR1M6IDAwMDAwMjg2ClsgICAzMS45MDk2NjBdIFJBWDogMDAwMDAw
MDAwMDAwMDAwMSBSQlg6IGZmZmZmZmZmODIwYzU2MjAgUkNYOiAwMDAwMDAwMDAwMDAwMDAw
ClsgICAzMS45MDk2NjBdIFJEWDogMDAwMDAwMDAwMDAwMDAwMSBSU0k6IGZmZmZmZmZmODE2
ZjczODAgUkRJOiBmZmZmZmZmZjgyMGM1NmMwClsgICAzMS45MDk2NjBdIFJCUDogZmZmZjg4
MDAwZDNkZmQ1MCBSMDg6IGZmZmY4ODAwMGQzZGM1MDggUjA5OiAwMDAwMDAwMDAwMDAwMDAy
ClsgICAzMS45MDk2NjBdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDFmN2NlMjk4
YzU2MjAgUjEyOiBmZmZmODgwMDBkMmJmODU4ClsgICAzMS45MDk2NjBdIFIxMzogZmZmZmZm
ZmY4MWU5MWQ0MCBSMTQ6IDAwMDAwMDAwMDAwMDAwMDAgUjE1OiBmZmZmODgwMDBlMGNlMzAw
ClsgICAzMS45MDk2NjBdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmZmZm
ZjgxZTg0MDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgIDMxLjkwOTY2MF0g
Q1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAg
MzEuOTA5NjYwXSBDUjI6IGZmZmZmZmZmODIxOTY0NDYgQ1IzOiAwMDAwMDAwMDBmMzdlMDAw
IENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgMzEuOTA5NjYwXSBEUjA6IDAwMDAwMDAwMDAw
MDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMApbICAg
MzEuOTA5NjYwXSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMDAwMDAwMDAw
IERSNzogMDAwMDAwMDAwMDAwMDAwMApbICAgMzEuOTA5NjYwXSBTdGFjazoKWyAgIDMxLjkw
OTY2MF0gIGZmZmZmZmZmODE2ZjdkZjggZmZmZmZmZmY4MjBjNTYyMCBmZmZmODgwMDBkM2Rm
ZDYwIGZmZmZmZmZmODE2ZWVlYzkKWyAgIDMxLjkwOTY2MF0gIGZmZmY4ODAwMGQzZGZkZTAg
ZmZmZmZmZmY4MTA3M2RjNSBmZmZmZmZmZjgxMDczZDY4IGZmZmY4ODAwMGQzZGZkYjgKWyAg
IDMxLjkwOTY2MF0gIDAwMDAwMDAwMDAwMDAwODYgZmZmZmZmZmY4MjBjNTYyMCBmZmZmZmZm
ZjgyNGY4OTgwIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDMxLjkwOTY2MF0gQ2FsbCBUcmFjZToK
WyAgIDMxLjkwOTY2MF0gIFs8ZmZmZmZmZmY4MTZmN2RmOD5dID8gYnJjbWZfc2Rpb19pbml0
KzB4MTgvMHg3MApbICAgMzEuOTA5NjYwXSAgWzxmZmZmZmZmZjgxNmVlZWM5Pl0gYnJjbWZf
ZHJpdmVyX2luaXQrMHg5LzB4MTAKWyAgIDMxLjkwOTY2MF0gIFs8ZmZmZmZmZmY4MTA3M2Rj
NT5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxZDUvMHg0ODAKWyAgIDMxLjkwOTY2MF0gIFs8ZmZm
ZmZmZmY4MTA3M2Q2OD5dID8gcHJvY2Vzc19vbmVfd29yaysweDE3OC8weDQ4MApbICAgMzEu
OTA5NjYwXSAgWzxmZmZmZmZmZjgxMDc0MTg4Pl0gd29ya2VyX3RocmVhZCsweDExOC8weDNh
MApbICAgMzEuOTA5NjYwXSAgWzxmZmZmZmZmZjgxMDc0MDcwPl0gPyBwcm9jZXNzX29uZV93
b3JrKzB4NDgwLzB4NDgwClsgICAzMS45MDk2NjBdICBbPGZmZmZmZmZmODEwN2FhMTc+XSBr
dGhyZWFkKzB4ZTcvMHhmMApbICAgMzEuOTA5NjYwXSAgWzxmZmZmZmZmZjgxMDgyOWY3Pl0g
PyBmaW5pc2hfdGFza19zd2l0Y2guY29uc3Rwcm9wLjU3KzB4MzcvMHhkMApbICAgMzEuOTA5
NjYwXSAgWzxmZmZmZmZmZjgxMDdhOTMwPl0gPyBfX2t0aHJlYWRfcGFya21lKzB4ODAvMHg4
MApbICAgMzEuOTA5NjYwXSAgWzxmZmZmZmZmZjgxYTY5MjNhPl0gcmV0X2Zyb21fZm9yaysw
eDdhLzB4YjAKWyAgIDMxLjkwOTY2MF0gIFs8ZmZmZmZmZmY4MTA3YTkzMD5dID8gX19rdGhy
ZWFkX3BhcmttZSsweDgwLzB4ODAKWyAgIDMxLjkwOTY2MF0gQ29kZTogY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgPGNjPiBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyAKWyAgIDMxLjkwOTY2MF0gUklQICBbPGZmZmZmZmZmODIx
OTY0NDY+XSBjbGFzc2VzX2luaXQrMHgyNi8weDI2ClsgICAzMS45MDk2NjBdICBSU1AgPGZm
ZmY4ODAwMGQzZGZkNDA+ClsgICAzMS45MDk2NjBdIENSMjogZmZmZmZmZmY4MjE5NjQ0Ngpb
ICAgMzEuOTA5NjYwXSAtLS1bIGVuZCB0cmFjZSBmYTdlMzdlMTkyZmQ5YTg0IF0tLS0KL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4L2M1MmRkN2Y5NGM1ZDUzODY0MTNjYjk1
NDYyYWM4MDI4NDdmYTVmM2EvZG1lc2cta3ZtLWFudC0xMTA4OS0yMDEzMDgzMDIwMTI1NS0z
LjExLjAtcmM1LTAwODUwLWdhYmE4MjY5LTM4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YzMtMDgyOC9jNTJkZDdmOTRjNWQ1Mzg2NDEzY2I5NTQ2MmFjODAyODQ3ZmE1ZjNhL2RtZXNn
LWt2bS1hbnQtOTI3NC0yMDEzMDgyODE1MjcyMi0zLjExLjAtcmM3LTAwNDQ0LWdjNTJkZDdm
LTIzCgpIRUFEIGlzIG5vdyBhdCBjNTJkZDdmIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFu
Y2ggJ3NvdW5kL2Zvci1saW51cycgaW50byBkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA4Mjgx
NDU0Cgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxpbnVzCmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4
L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDgyODE0NTQ6ZDllZGEwZmFl
MTM5NGVhMWUxYzU5Yzk0ZDRhMTIwYWQ5YzA2ZTY0YTpiaXNlY3QtdXNiCgoyMDEzLTA5LTAy
LTA1OjIwOjE3IGQ5ZWRhMGZhZTEzOTRlYTFlMWM1OWM5NGQ0YTEyMGFkOWMwNmU2NGEgY29t
cGlsaW5nCgoyMDEzLTA5LTAyLTA1OjI1OjQ1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEu
MC1yYzctMDA5OTYtZ2Q5ZWRhMGYuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLgkyLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkzLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLgk0CTUuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNi4uLi4uLi4uLi4uLi4J
Ny4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JOC4u
Lgk5Li4uLi4uLi4uLi4uLi4uLi4uLgkxMC4uLi4uLi4uLi4uLi4JMTEuLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxMi4uLgkxMy4uLgkx
NC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxNS4uLi4u
Li4JMTYuLi4uLi4uLi4uLi4uCTE3Li4uLgkxOS4uLi4uLi4uLi4uLi4uLi4uLgkyMC4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjEuLi4uLi4uLi4uLi4u
Li4JMjIuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjMu
Li4uLi4uLi4JMjQuCTI1Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4JMjYuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
CTI3Li4uLi4uLi4uLi4uLi4uLi4uLiBURVNUIEZBSUxVUkUKWyAgIDUwLjg2MzM4NF0gU3dp
dGNoZWQgdG8gY2xvY2tzb3VyY2UgdHNjClsgICA1MC44NzcyNTFdIGtlcm5lbCB0cmllZCB0
byBleGVjdXRlIE5YLXByb3RlY3RlZCBwYWdlIC0gZXhwbG9pdCBhdHRlbXB0PyAodWlkOiAw
KQpbICAgNTAuODc3MjUxXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyBy
ZXF1ZXN0IGF0IGZmZmZmZmZmODI0YWE0NGYKWyAgIDUwLjg3NzI1MV0gSVA6IFs8ZmZmZmZm
ZmY4MjRhYTQ0Zj5dIGNsYXNzZXNfaW5pdCsweDI2LzB4MjYKWyAgIDUwLjg3NzI1MV0gUEdE
IDIxNDAwNjcgUFVEIDIxNDEwNjMgUE1EIGYzOWMwNjMgUFRFIDgwMDAwMDAwMDI0YWExNjMK
WyAgIDUwLjg3NzI1MV0gT29wczogMDAxMSBbIzFdIApbICAgNTAuODc3MjUxXSBDUFU6IDAg
UElEOiA0IENvbW06IGt3b3JrZXIvMDowIE5vdCB0YWludGVkIDMuMTEuMC1yYzctMDA5OTYt
Z2Q5ZWRhMGYgIzM3OQpbICAgNTAuODc3MjUxXSBXb3JrcXVldWU6IGV2ZW50cyBicmNtZl9k
cml2ZXJfaW5pdApbICAgNTAuODc3MjUxXSB0YXNrOiBmZmZmODgwMDAwMDQ4MDAwIHRpOiBm
ZmZmODgwMDAwMDRhMDAwIHRhc2sudGk6IGZmZmY4ODAwMDAwNGEwMDAKWyAgIDUwLjg3NzI1
MV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MjRhYTQ0Zj5dICBbPGZmZmZmZmZmODI0YWE0NGY+
XSBjbGFzc2VzX2luaXQrMHgyNi8weDI2ClsgICA1MC44NzcyNTFdIFJTUDogMDAxODpmZmZm
ODgwMDAwMDRiZDQwICBFRkxBR1M6IDAwMDAwMjg2ClsgICA1MC44NzcyNTFdIFJBWDogMDAw
MDAwMDAwMDAwMDAwMSBSQlg6IGZmZmZmZmZmODIzOGY2MjAgUkNYOiAwMDAwMDAwMDAwMDAw
MDAwClsgICA1MC44NzcyNTFdIFJEWDogMDAwMDAwMDAwMDAwMDAwMSBSU0k6IGZmZmZmZmZm
ODE2ZjdhMTAgUkRJOiBmZmZmZmZmZjgyMzhmNmMwClsgICA1MC44NzcyNTFdIFJCUDogZmZm
Zjg4MDAwMDA0YmQ1MCBSMDg6IGZmZmY4ODAwMDAwNDg1MDggUjA5OiAwMDAwMDAwMDAwMDAw
MDAyClsgICA1MC44NzcyNTFdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDFmNzFi
YTliOGY2MjAgUjEyOiBmZmZmODgwMDAwMDI1ODc4ClsgICA1MC44NzcyNTFdIFIxMzogZmZm
ZmZmZmY4MjE1YmQ0MCBSMTQ6IDAwMDAwMDAwMDAwMDAwMDAgUjE1OiBmZmZmODgwMDBlMGNl
MzAwClsgICA1MC44NzcyNTFdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZm
ZmZmZjgyMTRlMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgIDUwLjg3NzI1
MV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpb
ICAgNTAuODc3MjUxXSBDUjI6IGZmZmZmZmZmODI0YWE0NGYgQ1IzOiAwMDAwMDAwMDBmMzlk
MDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgNTAuODc3MjUxXSBEUjA6IDAwMDAwMDAw
MDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMApb
ICAgNTAuODc3MjUxXSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMDAwMDAw
MDAwIERSNzogMDAwMDAwMDAwMDAwMDAwMApbICAgNTAuODc3MjUxXSBTdGFjazoKWyAgIDUw
Ljg3NzI1MV0gIGZmZmZmZmZmODE2Zjg0ODggZmZmZmZmZmY4MjM4ZjYyMCBmZmZmODgwMDAw
MDRiZDYwIGZmZmZmZmZmODE2ZWY1NTkKWyAgIDUwLjg3NzI1MV0gIGZmZmY4ODAwMDAwNGJk
ZTAgZmZmZmZmZmY4MTA3M2RjNSBmZmZmZmZmZjgxMDczZDY4IGZmZmY4ODAwMDAwNGJkYjgK
WyAgIDUwLjg3NzI1MV0gIDAwMDAwMDAwMDAwMDAwODIgZmZmZmZmZmY4MjM4ZjYyMCBmZmZm
ZmZmZjgyODBlNWEwIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDUwLjg3NzI1MV0gQ2FsbCBUcmFj
ZToKWyAgIDUwLjg3NzI1MV0gIFs8ZmZmZmZmZmY4MTZmODQ4OD5dID8gYnJjbWZfc2Rpb19p
bml0KzB4MTgvMHg3MApbICAgNTAuODc3MjUxXSAgWzxmZmZmZmZmZjgxNmVmNTU5Pl0gYnJj
bWZfZHJpdmVyX2luaXQrMHg5LzB4MTAKWyAgIDUwLjg3NzI1MV0gIFs8ZmZmZmZmZmY4MTA3
M2RjNT5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxZDUvMHg0OTAKWyAgIDUwLjg3NzI1MV0gIFs8
ZmZmZmZmZmY4MTA3M2Q2OD5dID8gcHJvY2Vzc19vbmVfd29yaysweDE3OC8weDQ5MApbICAg
NTAuODc3MjUxXSAgWzxmZmZmZmZmZjgxMDc0MTk4Pl0gd29ya2VyX3RocmVhZCsweDExOC8w
eDNhMApbICAgNTAuODc3MjUxXSAgWzxmZmZmZmZmZjgxMDc0MDgwPl0gPyBwcm9jZXNzX29u
ZV93b3JrKzB4NDkwLzB4NDkwClsgICA1MC44NzcyNTFdICBbPGZmZmZmZmZmODEwN2FhMjc+
XSBrdGhyZWFkKzB4ZTcvMHhmMApbICAgNTAuODc3MjUxXSAgWzxmZmZmZmZmZjgxMDgyYTA3
Pl0gPyBmaW5pc2hfdGFza19zd2l0Y2guY29uc3Rwcm9wLjU3KzB4MzcvMHhkMApbICAgNTAu
ODc3MjUxXSAgWzxmZmZmZmZmZjgxMDdhOTQwPl0gPyBfX2t0aHJlYWRfcGFya21lKzB4ODAv
MHg4MApbICAgNTAuODc3MjUxXSAgWzxmZmZmZmZmZjgxYWJmOGJhPl0gcmV0X2Zyb21fZm9y
aysweDdhLzB4YjAKWyAgIDUwLjg3NzI1MV0gIFs8ZmZmZmZmZmY4MTA3YTk0MD5dID8gX19r
dGhyZWFkX3BhcmttZSsweDgwLzB4ODAKWyAgIDUwLjg3NzI1MV0gQ29kZTogY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgPGNjPiBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYyAKWyAgIDUwLjg3NzI1MV0gUklQICBbPGZmZmZmZmZm
ODI0YWE0NGY+XSBjbGFzc2VzX2luaXQrMHgyNi8weDI2ClsgICA1MC44NzcyNTFdICBSU1Ag
PGZmZmY4ODAwMDAwNGJkNDA+ClsgICA1MC44NzcyNTFdIENSMjogZmZmZmZmZmY4MjRhYTQ0
ZgpbICAgNTAuODc3MjUxXSAtLS1bIGVuZCB0cmFjZSA4MGZmZTUyOTUwM2E2ZTFlIF0tLS0K
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMy0wODI4L2Q5ZWRhMGZhZTEzOTRlYTFlMWM1
OWM5NGQ0YTEyMGFkOWMwNmU2NGEvZG1lc2ctcXVhbnRhbC1hbnQtMTI6MjAxMzA5MDIxMTUw
MTY6My4xMS4wLXJjNy0wMDk5Ni1nZDllZGEwZjozNzkKCgo9PT09PT09PT0gbGludXgtbmV4
dCA9PT09PT09PT0KRmV0Y2hpbmcgbmV4dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzMtMDgyOC9saW51eC1kZXZlbDpkZXZlbC1jYWly
by14ODZfNjQtMjAxMzA4MjgxNDU0Ojc5N2M4ZDE4ZTY4MDRmMDU0ZTY4NTU1ZTZjZjgyNzgy
N2I2YTA3M2M6YmlzZWN0LXVzYgoKMjAxMy0wOS0wMi0xMTo1MTowOCA3OTdjOGQxOGU2ODA0
ZjA1NGU2ODU1NWU2Y2Y4Mjc4MjdiNmEwNzNjIGNvbXBpbGluZwoKMjAxMy0wOS0wMi0xMTo1
Njo1MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmM3LW5leHQtMjAxMzA4MzAtMTAx
ODktZzc5N2M4ZDE4Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxLi4uLi4uLi4uLi4uLi4u
Li4uLi4uIFRFU1QgRkFJTFVSRQpbICAgNDUuOTA0MjU2XSBTd2l0Y2hlZCB0byBjbG9ja3Nv
dXJjZSB0c2MKWyAgIDQ1LjkwNjQ0NF0ga2VybmVsIHRyaWVkIHRvIGV4ZWN1dGUgTlgtcHJv
dGVjdGVkIHBhZ2UgLSBleHBsb2l0IGF0dGVtcHQ/ICh1aWQ6IDApClsgICA0NS45MDY0NDRd
IEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgZmZmZmZm
ZmY4MjFiNjU1NApbICAgNDUuOTA2NDQ0XSBJUDogWzxmZmZmZmZmZjgyMWI2NTU0Pl0gY2xh
c3Nlc19pbml0KzB4MjYvMHgyNgpbICAgNDUuOTA2NDQ0XSBQR0QgMWU5ODA2NyBQVUQgMWU5
OTA2MyBQTUQgZjM5MjA2MyBQVEUgODAwMDAwMDAwMjFiNjE2MwpbICAgNDUuOTA2NDQ0XSBP
b3BzOiAwMDExIFsjMV0gClsgICA0NS45MDY0NDRdIENQVTogMCBQSUQ6IDQgQ29tbToga3dv
cmtlci8wOjAgTm90IHRhaW50ZWQgMy4xMS4wLXJjNy1uZXh0LTIwMTMwODMwLTEwMTg5LWc3
OTdjOGQxOCAjMzgwClsgICA0NS45MDY0NDRdIFdvcmtxdWV1ZTogZXZlbnRzIGJyY21mX2Ry
aXZlcl9pbml0ClsgICA0NS45MDY0NDRdIHRhc2s6IGZmZmY4ODAwMDAwNDgwMDAgdGk6IGZm
ZmY4ODAwMDAwNGEwMDAgdGFzay50aTogZmZmZjg4MDAwMDA0YTAwMApbICAgNDUuOTA2NDQ0
XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgyMWI2NTU0Pl0gIFs8ZmZmZmZmZmY4MjFiNjU1ND5d
IGNsYXNzZXNfaW5pdCsweDI2LzB4MjYKWyAgIDQ1LjkwNjQ0NF0gUlNQOiAwMDAwOmZmZmY4
ODAwMDAwNGJkNDAgIEVGTEFHUzogMDAwMDAyODYKWyAgIDQ1LjkwNjQ0NF0gUkFYOiAwMDAw
MDAwMDAwMDAwMDAxIFJCWDogZmZmZmZmZmY4MjBlOTMwMCBSQ1g6IDAwMDAwMDAwMDAwMDAw
MDAKWyAgIDQ1LjkwNjQ0NF0gUkRYOiAwMDAwMDAwMDAwMDAwMDAxIFJTSTogZmZmZmZmZmY4
MTcwN2RkMCBSREk6IGZmZmZmZmZmODIwZTkzYTAKWyAgIDQ1LjkwNjQ0NF0gUkJQOiBmZmZm
ODgwMDAwMDRiZDUwIFIwODogZmZmZjg4MDAwMDA0ODUwOCBSMDk6IDAwMDAwMDAwMDAwMDAw
MDIKWyAgIDQ1LjkwNjQ0NF0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMWY3YzUz
NjBlOTMwMCBSMTI6IGZmZmY4ODAwMDAwMjgxOTgKWyAgIDQ1LjkwNjQ0NF0gUjEzOiBmZmZm
ZmZmZjgxZWIzZDQwIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IGZmZmY4ODAwMGUwY2Uz
MDAKWyAgIDQ1LjkwNjQ0NF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmZm
ZmZmODFlYTYwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgNDUuOTA2NDQ0
XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsg
ICA0NS45MDY0NDRdIENSMjogZmZmZmZmZmY4MjFiNjU1NCBDUjM6IDAwMDAwMDAwMGYzOGUw
MDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmIwClsgICA0NS45MDY0NDRdIERSMDogMDAwMDAwMDAw
MDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwClsg
ICA0NS45MDY0NDRdIERSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwMDAwMDAw
MDAgRFI3OiAwMDAwMDAwMDAwMDAwMDAwClsgICA0NS45MDY0NDRdIFN0YWNrOgpbICAgNDUu
OTA2NDQ0XSAgZmZmZmZmZmY4MTcwODg0OCBmZmZmZmZmZjgyMGU5MzAwIGZmZmY4ODAwMDAw
NGJkNjAgZmZmZmZmZmY4MTZmZWVkOQpbICAgNDUuOTA2NDQ0XSAgZmZmZjg4MDAwMDA0YmRl
MCBmZmZmZmZmZjgxMDczZmU1IGZmZmZmZmZmODEwNzNmODggZmZmZjg4MDAwMDA0YmRiOApb
ICAgNDUuOTA2NDQ0XSAgMDAwMDAwMDAwMDAwMDA4MiBmZmZmZmZmZjgyMGU5MzAwIGZmZmZm
ZmZmODI1MWFjZTAgMDAwMDAwMDAwMDAwMDAwMApbICAgNDUuOTA2NDQ0XSBDYWxsIFRyYWNl
OgpbICAgNDUuOTA2NDQ0XSAgWzxmZmZmZmZmZjgxNzA4ODQ4Pl0gPyBicmNtZl9zZGlvX2lu
aXQrMHgxOC8weDcwClsgICA0NS45MDY0NDRdICBbPGZmZmZmZmZmODE2ZmVlZDk+XSBicmNt
Zl9kcml2ZXJfaW5pdCsweDkvMHgxMApbICAgNDUuOTA2NDQ0XSAgWzxmZmZmZmZmZjgxMDcz
ZmU1Pl0gcHJvY2Vzc19vbmVfd29yaysweDFkNS8weDQ5MApbICAgNDUuOTA2NDQ0XSAgWzxm
ZmZmZmZmZjgxMDczZjg4Pl0gPyBwcm9jZXNzX29uZV93b3JrKzB4MTc4LzB4NDkwClsgICA0
NS45MDY0NDRdICBbPGZmZmZmZmZmODEwNzQzYjg+XSB3b3JrZXJfdGhyZWFkKzB4MTE4LzB4
M2EwClsgICA0NS45MDY0NDRdICBbPGZmZmZmZmZmODEwNzQyYTA+XSA/IHByb2Nlc3Nfb25l
X3dvcmsrMHg0OTAvMHg0OTAKWyAgIDQ1LjkwNjQ0NF0gIFs8ZmZmZmZmZmY4MTA3YWMzNz5d
IGt0aHJlYWQrMHhlNy8weGYwClsgICA0NS45MDY0NDRdICBbPGZmZmZmZmZmODEwODJjYzc+
XSA/IGZpbmlzaF90YXNrX3N3aXRjaC5jb25zdHByb3AuNTgrMHgzNy8weGQwClsgICA0NS45
MDY0NDRdICBbPGZmZmZmZmZmODEwN2FiNTA+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg4MC8w
eDgwClsgICA0NS45MDY0NDRdICBbPGZmZmZmZmZmODFhODNmZmE+XSByZXRfZnJvbV9mb3Jr
KzB4N2EvMHhiMApbICAgNDUuOTA2NDQ0XSAgWzxmZmZmZmZmZjgxMDdhYjUwPl0gPyBfX2t0
aHJlYWRfcGFya21lKzB4ODAvMHg4MApbICAgNDUuOTA2NDQ0XSBDb2RlOiBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyA8Y2M+IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNj
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIApbICAgNDUuOTA2NDQ0XSBSSVAgIFs8ZmZmZmZmZmY4
MjFiNjU1ND5dIGNsYXNzZXNfaW5pdCsweDI2LzB4MjYKWyAgIDQ1LjkwNjQ0NF0gIFJTUCA8
ZmZmZjg4MDAwMDA0YmQ0MD4KWyAgIDQ1LjkwNjQ0NF0gQ1IyOiBmZmZmZmZmZjgyMWI2NTU0
ClsgICA0NS45MDY0NDRdIC0tLVsgZW5kIHRyYWNlIDkwYTI3YjM4YmM5OWJkMTMgXS0tLQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMzLTA4MjgvNzk3YzhkMThlNjgwNGYwNTRlNjg1
NTVlNmNmODI3ODI3YjZhMDczYy9kbWVzZy1xdWFudGFsLWFudC0xNjoyMDEzMDkwMjEyNDcw
NDozLjExLjAtcmM3LW5leHQtMjAxMzA4MzAtMTAxODktZzc5N2M4ZDE4OjM4MAoK

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-rc7-00444-gc52dd7f"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.11.0-rc7 Kernel Configuration
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
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
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
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

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
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

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
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
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
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

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
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
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
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
CONFIG_ARCH_SUPPORTS_MSI=y
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
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
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

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_BINFMT_SCRIPT is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=y
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_YAM=y
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRNET is not set
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

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
# CONFIG_WINBOND_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_MLME_DEBUG is not set
CONFIG_MAC80211_STA_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_PS_DEBUG=y
CONFIG_MAC80211_MPL_DEBUG=y
CONFIG_MAC80211_MPATH_DEBUG=y
CONFIG_MAC80211_MHWMP_DEBUG=y
CONFIG_MAC80211_MESH_SYNC_DEBUG=y
CONFIG_MAC80211_MESH_PS_DEBUG=y
CONFIG_MAC80211_TDLS_DEBUG=y
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
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
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
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
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
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
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
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
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
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
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_IFB=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
CONFIG_NET_TEAM_MODE_RANDOM=y
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_NLMON is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_PCI is not set
# CONFIG_ARCNET_COM20020_CS is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PLIP=y
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
# CONFIG_PPPOATM is not set
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=y
CONFIG_LIBERTAS_THINFIRM=y
CONFIG_LIBERTAS_THINFIRM_DEBUG=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
CONFIG_AIRO_CS=y
CONFIG_PCMCIA_WL3501=y
# CONFIG_PRISM54 is not set
# CONFIG_RTL8180 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_CARDS=y
CONFIG_ATH_DEBUG=y
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH6KL is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
CONFIG_B43=y
# CONFIG_B43_BCMA is not set
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
# CONFIG_B43_SDIO is not set
CONFIG_B43_PIO=y
# CONFIG_B43_PHY_N is not set
CONFIG_B43_PHY_LP=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMSMAC=y
CONFIG_BRCMFMAC=y
CONFIG_BRCMFMAC_SDIO=y
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
CONFIG_HOSTAP_CS=y
# CONFIG_IPW2100 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_LIBERTAS=y
# CONFIG_LIBERTAS_CS is not set
CONFIG_LIBERTAS_SDIO=y
CONFIG_LIBERTAS_SPI=y
CONFIG_LIBERTAS_DEBUG=y
CONFIG_LIBERTAS_MESH=y
CONFIG_P54_COMMON=y
# CONFIG_P54_PCI is not set
CONFIG_P54_SPI=y
CONFIG_P54_SPI_DEFAULT_EEPROM=y
CONFIG_P54_LEDS=y
CONFIG_RT2X00=y
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
# CONFIG_RT2800PCI is not set
CONFIG_RTL_CARDS=y
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_WL_TI is not set
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_SDIO=y
# CONFIG_MWIFIEX_PCIE is not set
# CONFIG_CW1200 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
# CONFIG_ISDN is not set

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
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TWL4030=y
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
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9034=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
# CONFIG_INPUT_ARIZONA_HAPTICS is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
# CONFIG_INPUT_ADXL34X_SPI is not set
CONFIG_INPUT_CMA3000=y
# CONFIG_INPUT_CMA3000_I2C is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
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
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
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
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
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
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
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
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

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
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_CHARGER_TPS65090=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y

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
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_MFD_CROS_EC_SPI=y
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_STMPE_SPI=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
CONFIG_TPS65010=y
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_ARIZONA=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9055=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_AB3100=y
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_V4L2_INT_DEVICE=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
CONFIG_IR_LIRC_CODEC=y
# CONFIG_IR_NEC_DECODER is not set
CONFIG_IR_RC5_DECODER=y
# CONFIG_IR_RC6_DECODER is not set
CONFIG_IR_JVC_DECODER=y
# CONFIG_IR_SONY_DECODER is not set
# CONFIG_IR_RC5_SZ_DECODER is not set
CONFIG_IR_SANYO_DECODER=y
# CONFIG_IR_MCE_KBD_DECODER is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set

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
# Miscelaneous helper chips
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
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

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
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
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
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
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
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
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
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
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
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_VIRMIDI=y
# CONFIG_SND_MTPAV is not set
CONFIG_SND_MTS64=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
CONFIG_SND_PDAUDIOCF=y
CONFIG_SND_SOC=y
# CONFIG_SND_ATMEL_SOC is not set
CONFIG_SND_SOC_I2C_AND_SPI=y
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

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
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=y
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

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
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
CONFIG_ADIS16203=y
CONFIG_ADIS16204=y
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
# CONFIG_AD7780 is not set
CONFIG_AD7816=y
CONFIG_AD7192=y
# CONFIG_AD7280 is not set

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
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y
CONFIG_ADIS16260=y

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_SENSORS_ISL29028=y
CONFIG_TSL2583=y
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
CONFIG_ADE7754=y
CONFIG_ADE7758=y
CONFIG_ADE7759=y
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
# CONFIG_ADE7854_SPI is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
CONFIG_AD2S1200=y
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_ZSMALLOC=y
CONFIG_ZRAM=y
# CONFIG_ZRAM_DEBUG is not set
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_SOLO6X10 is not set
CONFIG_LIRC_STAGING=y
# CONFIG_LIRC_BT829 is not set
# CONFIG_LIRC_PARALLEL is not set
CONFIG_LIRC_SERIAL=y
CONFIG_LIRC_SERIAL_TRANSMITTER=y
# CONFIG_LIRC_SIR is not set
CONFIG_LIRC_ZILOG=y

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# CONFIG_ASHMEM is not set
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_SYNC=y
CONFIG_SW_SYNC=y
CONFIG_SW_SYNC_USER=y
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_DGRP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
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
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_ARIZONA=y
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
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_KXSD9=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7923 is not set
CONFIG_AD7791=y
CONFIG_AD7793=y
# CONFIG_AD7476 is not set
# CONFIG_AD7887 is not set
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
# CONFIG_MCP320X is not set
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
# CONFIG_AD5421 is not set
CONFIG_AD5624R_SPI=y
CONFIG_AD5446=y
CONFIG_AD5449=y
CONFIG_AD5504=y
CONFIG_AD5755=y
# CONFIG_AD5764 is not set
CONFIG_AD5791=y
CONFIG_AD5686=y
# CONFIG_AD7303 is not set
CONFIG_MAX517=y
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
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
CONFIG_ADIS16136=y
CONFIG_ADXRS450=y
CONFIG_HID_SENSOR_GYRO_3D=y
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
# CONFIG_ADIS16480 is not set
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_SENSORS_LM3533=y
CONFIG_SENSORS_TSL2563=y
CONFIG_VCNL4000=y
# CONFIG_HID_SENSOR_ALS is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure Sensors
#
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
# CONFIG_BTRFS_DEBUG is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_EXOFS_FS=y
CONFIG_EXOFS_DEBUG=y
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_ORE=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
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
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
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
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
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
CONFIG_CRYPTO_ABLK_HELPER_X86=y
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
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
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
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--1yeeQ81UyVL57Vl7--
