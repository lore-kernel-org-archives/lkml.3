Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3FOXoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 19:44:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:33900 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab3FOXoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 19:44:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,873,1363158000"; 
   d="log'?scan'208";a="350440622"
Date: Sun, 16 Jun 2013 07:43:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Hante Meuleman <meuleman@broadcom.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com
Subject: brcmf_driver_init Oops
Message-ID: <20130615234351.GA7049@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit may be

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


[  128.610401] IP: [<ffffffff82ee0621>] classes_init+0x40/0x40
[  128.610401] PGD 280e067 PUD 280f063 PMD 4a09063 PTE 8000000002ee0163
[  128.610401] Oops: 0011 [#1] 
[  128.610401] CPU: 0 PID: 16 Comm: kworker/0:1 Not tainted 3.10.0-rc4-00345-g64f0389 #6
[  128.610401] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  128.610401] Workqueue: events brcmf_driver_init
[  128.610401] task: ffff88000dd12a00 ti: ffff88000df70000 task.ti: ffff88000df70000
[  128.610401] RIP: 0010:[<ffffffff82ee0621>]  [<ffffffff82ee0621>] classes_init+0x40/0x40
[  128.610401] RSP: 0000:ffff88000df71df0  EFLAGS: 00000202
[  128.610401] RAX: ffff88000df71da0 RBX: ffffffff82bee540 RCX: 0000000000000002
[  128.610401] RDX: ffffffff825fe26e RSI: ffffffff81afb400 RDI: ffffffff82bf17a0
[  128.610401] RBP: ffff88000df71df8 R08: ffff880009201458 R09: 0000000000000000
[  128.610401] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88000de1de10
[  128.610401] R13: ffff88000df71fd8 R14: 0000000000000000 R15: 0000000000000000
[  128.610401] FS:  0000000000000000(0000) GS:ffffffff82846000(0000) knlGS:0000000000000000
[  128.610401] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  128.610401] CR2: ffffffff82ee0621 CR3: 000000000280d000 CR4: 00000000000006b0
[  128.610401] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  128.610401] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  128.610401] Stack:
[  128.610401]  ffffffff81afc8f1 ffff88000df71e08 ffffffff81aec81e ffff88000df71e58
[  128.610401]  ffffffff81104d64 0000000000000000 ffff88000fff2a00 ffff88000de1de40
[  128.610401]  ffffffff828955f0 ffff88000de1de40 ffff88000dd12a00 ffffffff828955e0
[  128.610401] Call Trace:
[  128.610401]  [<ffffffff81afc8f1>] ? brcmf_sdio_init+0x41/0xd0
[  128.610401]  [<ffffffff81aec81e>] brcmf_driver_init+0x1e/0x30

git bisect start 64f0389f50f3576360e5b2870e5b09c8c500a373 v3.9 --
git bisect  bad 73287a43cc79ca06629a88d1a199cd283f42456a  # 11:16      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good 5d434fcb255dec99189f1c58a06e4f56e12bf77d  # 14:59   5070  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
git bisect  bad 91bc033c4d01656e3d8e45a13fd58924a3099693  # 14:59      0  bridge: avoid OOPS if root port not found
git bisect good 953c96e0d85615d1ab1f100e525d376053294dc2  # 20:40   5070  tg3: Use bool not int
git bisect  bad 6d421e54c2277990f3b0e3dd92e446800c90efa3  # 20:40      0  brcmfmac: use lock in brcmf_fws_del_interface()
git bisect good 7350e6cf360d32206cbe4e3d34fb48ab863bdb14  # 06:39   5070  Bluetooth: hidp: merge hidp_process_{ctrl,intr}_transmit()
git bisect good ddf19d206fe4ba4e7dc9629bc14025ba50915886  # 14:06   5070  NFC: pn533: Simplify __pn533_send_frame_async
git bisect  bad a85666627b7f10c4229716b6ffaffcf196a128ca  # 14:06      0-  mac80211/minstrel_ht: use the new rate control API
git bisect good 1b737f88dc1b05cf571e96d42f748aaff6df1eb5  # 17:13   5070+  mac80211: fix P2P-Device management frame RX
git bisect  bad 31ed07dc1e83b7926ce8ee2215ea21599a215990  # 17:13      0-  brcmfmac: remove ifidx variable from brcmf_fws_process_skb()
git bisect good 1e9ab4dd258ecbb0f1c377fd4dbe227cdb93d9bd  # 11:38   5070+  brcmfmac: setup SDIO reset behavior
git bisect  bad 668761ac01d6f5a36b8e5a24d4e154550e2c4c3b  # 11:55    168-  brcmfmac: define and use platform specific data for SDIO.
git bisect good 369508c5656db290f09b32d213effeea6c1431b8  # 05:01   5070+  brcmfmac: Add 43143 SDIO support.
git bisect good 979c29205ffa607c59ba2c9f9c083b967d356c97  # 04:45   5071+  brcmfmac: Add drive strength programming for SDIO 43143.
git bisect good 979c29205ffa607c59ba2c9f9c083b967d356c97  # 11:53  15212+  brcmfmac: Add drive strength programming for SDIO 43143.
git bisect  bad 64f0389f50f3576360e5b2870e5b09c8c500a373  # 11:54      0-  Merge remote-tracking branch 'nfc-fixes/master' into devel-cairo-x86_64-201306070018
git bisect good 6af0d3e67668ffee5f1aefdd339270382b244cc7  # 21:44  12652+  Revert "brcmfmac: define and use platform specific data for SDIO."
git bisect  bad 5938930e71affa390c3fa33fa2fda52f58f850e8  # 23:48   2030-  Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git bisect  bad c04efed734409f5a44715b54a6ca1b54b0ccf215  # 00:45   2732-  Add linux-next specific files for 20130607

Thanks,
Fengguang

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-25322-20130607010209-3.10.0-rc4-00345-g64f0389-6"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc4-00345-g64f0389 (kbuild@cairo) (gcc version 4.7.2 (Debian 4.7.2-4) ) #6 Fri Jun 7 00:56:04 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c26-0606/devel-cairo-x86_64-201306070018/.vmlinuz-64f0389f50f3576360e5b2870e5b09c8c500a373-20130607005654-7-ant branch=linux-devel/devel-cairo-x86_64-201306070018 noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-randconfig-c26-0606/64f0389f50f3576360e5b2870e5b09c8c500a373/vmlinuz-3.10.0-rc4-00345-g64f0389
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03736000, 0x03736fff] PGTABLE
[    0.000000] BRK [0x03737000, 0x03737fff] PGTABLE
[    0.000000] BRK [0x03738000, 0x03738fff] PGTABLE
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
[    0.000000] BRK [0x03739000, 0x03739fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127388(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 1
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64379
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c26-0606/devel-cairo-x86_64-201306070018/.vmlinuz-64f0389f50f3576360e5b2870e5b09c8c500a373-20130607005654-7-ant branch=linux-devel/devel-cairo-x86_64-201306070018 noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-randconfig-c26-0606/64f0389f50f3576360e5b2870e5b09c8c500a373/vmlinuz-3.10.0-rc4-00345-g64f0389
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 184924k/262136k available (18012k kernel code, 440k absent, 76772k reserved, 13325k data, 1144k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3192.131 MHz processor
[    0.037104] Calibrating delay loop (skipped), value calculated using timer frequency.. 6386.27 BogoMIPS (lpj=10640436)
[    0.041945] pid_max: default: 32768 minimum: 301
[    0.061499] Security Framework initialized
[    0.070909] AppArmor: AppArmor disabled by boot time parameter
[    0.080598] Mount-cache hash table entries: 256
[    0.188318] Initializing cgroup subsys debug
[    0.193333] Initializing cgroup subsys devices
[    0.194140] Initializing cgroup subsys net_cls
[    0.197304] Initializing cgroup subsys net_prio
[    0.220843] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.220843] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.220843] tlb_flushall_shift: -1
[    0.223651] CPU: AMD QEMU Virtual CPU version 1.1.2 (fam: 06, model: 02, stepping: 03)
[    0.325646] ACPI: Core revision 20130328
[    0.785604] ACPI: All ACPI Tables successfully acquired
[    0.788289] ACPI: setting ELCR to 0200 (from 0c00)
[    0.835321] Performance Events: 
[    0.837500] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.840167] no hardware sampling interrupt available.
[    0.844073] Broken PMU hardware detected, using software events only.
[    0.845641] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.884160] Apic disabled
[    0.925128] devtmpfs: initialized
[    1.074825] xor: measuring software checksum speed
[    1.120478]    prefetch64-sse:   193.200 MB/sec
[    1.153595]    generic_sse:   201.600 MB/sec
[    1.154941] xor: using function: generic_sse (201.600 MB/sec)
[    1.194280] regulator-dummy: no parameters
[    1.228121] NET: Registered protocol family 16
[    1.298907] ACPI: bus type PCI registered
[    1.318766] PCI: Using configuration type 1 for base access
[    1.919058] bio: create slab <bio-0> at 0
[    1.952243] ACPI: Added _OSI(Module Device)
[    1.953773] ACPI: Added _OSI(Processor Device)
[    1.954695] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.956854] ACPI: Added _OSI(Processor Aggregator Device)
[    1.992381] ACPI: EC: Look up EC in DSDT
[    2.763673] ACPI: Interpreter enabled
[    2.767095] ACPI: (supports S0 S5)
[    2.770358] ACPI: Using PIC for interrupt routing
[    2.777589] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    3.919999] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    3.930986] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    3.933747] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    3.935411] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    3.936930] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    3.940990] PCI: root bus 00: using default resources
[    3.954190] PCI host bridge to bus 0000:00
[    3.957138] pci_bus 0000:00: root bus resource [bus 00-ff]
[    3.958502] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    3.960424] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    3.969891] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    4.013636] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    4.027558] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    4.037876] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    4.079130] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    4.083830] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    4.085609] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    4.095133] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    4.100442] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    4.106991] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    4.123699] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    4.131808] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    4.136977] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    4.143606] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    4.161379] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    4.171368] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    4.177003] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    4.181304] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    4.197000] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    4.211496] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    4.216965] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    4.221207] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    4.251727] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    4.256982] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    4.261312] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    4.291700] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    4.298203] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    4.306965] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    4.343846] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    4.350334] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    4.354719] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    4.381734] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    4.388037] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    4.392367] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    4.423804] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    4.428101] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    4.434794] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    4.473333] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    4.477034] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    4.514201] pci_bus 0000:00: on NUMA node 0
[    4.515681] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    4.653954] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    4.686950] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    4.717996] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    4.756666] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    4.784275] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    4.823333] ACPI: Enabled 16 GPEs in block 00 to 0F
[    4.827945] acpi root: \_SB_.PCI0 notify handler is installed
[    4.831364] Found 1 acpi root devices
[    4.893333] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    4.897052] vgaarb: loaded
[    4.907003] vgaarb: bridge control possible 0000:00:02.0
[    4.915024] tps65010: version 2 May 2005
[    4.951926] tps65010: no chip?
[    4.991810] SCSI subsystem initialized
[    5.018387] pps_core: LinuxPPS API ver. 1 registered
[    5.020230] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    5.031273] EDAC MC: Ver: 3.0.0
[    5.038395] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    5.060182] PCI: Using ACPI for IRQ routing
[    5.061811] PCI: pci_cache_line_size set to 64 bytes
[    5.067390] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    5.070687] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    5.133783] NET: Registered protocol family 23
[    5.140965] Bluetooth: Core ver 2.16
[    5.143698] NET: Registered protocol family 31
[    5.144885] Bluetooth: HCI device and connection manager initialized
[    5.147829] Bluetooth: HCI socket layer initialized
[    5.150845] Bluetooth: L2CAP socket layer initialized
[    5.154795] Bluetooth: SCO socket layer initialized
[    5.157041] NET: Registered protocol family 8
[    5.158088] NET: Registered protocol family 20
[    5.205055] NetLabel: Initializing
[    5.206035] NetLabel:  domain hash size = 128
[    5.206872] NetLabel:  protocols = UNLABELED CIPSOv4
[    5.217929] NetLabel:  unlabeled traffic allowed by default
[    5.227784] nfc: nfc_init: NFC Core ver 0.1
[    5.234055] NET: Registered protocol family 39
[    5.255001] Switching to clocksource hpet
[    5.265613] CE: hpet increased min_delta_ns to 5000 nsec
[    5.265613] CE: hpet increased min_delta_ns to 7500 nsec
[    5.332755] FS-Cache: Loaded
[    5.349752] CacheFiles: Loaded
[    5.371754] pnp: PnP ACPI init
[    5.373268] ACPI: bus type PNP registered
[    5.432572] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    5.468509] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    5.511967] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    5.539700] pnp 00:03: [dma 2]
[    5.559947] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    5.612471] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    5.672228] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    5.791671] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    5.903129] pnp: PnP ACPI: found 7 devices
[    5.908773] ACPI: bus type PNP unregistered
[    6.762935] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    6.769816] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    6.799934] NET: Registered protocol family 2
[    6.902729] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    6.905205] TCP bind hash table entries: 2048 (order: 2, 16384 bytes)
[    6.919598] TCP: Hash tables configured (established 2048 bind 2048)
[    6.926351] TCP: reno registered
[    6.932931] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    6.946059] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    6.979606] NET: Registered protocol family 1
[    6.995737] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    7.009852] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    7.012323] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    7.019767] pci 0000:00:02.0: Boot video device
[    7.021869] PCI: CLS 0 bytes, default 64
[    7.104979] Unpacking initramfs...
[    8.197750] cfg80211: Calling CRDA to update world regulatory domain
[  101.690894] Freeing initrd memory: 23656k freed
[  111.343728] DMA-API: preallocated 65536 debug entries
[  111.357532] DMA-API: debugging enabled by kernel config
[  111.412026] kvm: no hardware support
[  111.452859] kvm: Nested Virtualization enabled
[  112.457733] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[  112.459309] PCLMULQDQ-NI instructions are not detected.
[  112.466530] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[  112.471009] AVX or AES-NI instructions are not detected.
[  112.472257] AVX instructions are not detected.
[  112.487068] AVX instructions are not detected.
[  112.488456] AVX2 instructions are not detected.
[  112.489552] AVX2 or AES-NI instructions are not detected.
[  112.496936] AVX2 instructions are not detected.
[  112.562066] audit: initializing netlink socket (disabled)
[  112.583801] type=2000 audit(1370538070.576:1): initialized
[  113.952004] VFS: Disk quotas dquot_6.5.2
[  113.970934] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[  114.519541] NTFS driver 2.1.30 [Flags: R/W].
[  114.606265] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[  114.632378] jffs2: version 2.2. (NAND) 
[  114.788077] ROMFS MTD (C) 2007 Red Hat, Inc.
[  114.814552] QNX4 filesystem 0.2.3 registered.
[  114.832349] fuse init (API version 7.22)
[  114.941677] NILFS version 2 loaded
[  114.942773] OCFS2 1.5.0
[  115.015859] ocfs2: Registered cluster interface o2cb
[  115.019624] OCFS2 DLMFS 1.5.0
[  115.052887] OCFS2 User DLM kernel interface loaded
[  115.056627] OCFS2 Node Manager 1.5.0
[  115.124525] OCFS2 DLM 1.5.0
[  115.312128] GFS2 installed
[  116.578625] alg: No test for crc32 (crc32-table)
[  116.629770] alg: No test for stdrng (krng)
[  116.669021] NET: Registered protocol family 38
[  116.694762] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[  116.702769] io scheduler noop registered (default)
[  116.738103] xz_dec_test: module loaded
[  116.739141] xz_dec_test: Create a device node with 'mknod xz_dec_test c 249 0' and write .xz files to it.
[  116.778392] no IO addresses supplied
[  116.839497] ipmi message handler version 39.2
[  116.854193] ipmi device interface
[  116.871710] IPMI System Interface driver.
[  116.882849] ipmi_si: Adding default-specified kcs state machine
[  116.897880] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[  116.914292] ipmi_si: Interface detection failed
[  116.924325] ipmi_si: Adding default-specified smic state machine
[  116.925815] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[  116.940957] ipmi_si: Interface detection failed
[  116.942491] ipmi_si: Adding default-specified bt state machine
[  116.949891] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[  116.959757] ipmi_si: Interface detection failed
[  116.982885] ipmi_si: Unable to find any System Interface(s)
[  116.989908] IPMI Watchdog: driver initialized
[  117.049453] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[  117.067658] ACPI: Power Button [PWRF]
[  117.326538] HDLC line discipline maxframe=4096
[  117.332346] N_HDLC line discipline registered.
[  117.339194] r3964: Philips r3964 Driver $Revision: 1.10 $
[  117.349850] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[  117.459744] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  117.619837] lp: driver loaded but no devices found
[  117.643249] ppdev: user-space parallel port driver
[  117.647682] smapi::smapi_init, ERROR invalid usSmapiID
[  117.648921] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[  117.663137] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[  117.667251] mwave: mwavedd::mwave_init: Error: Failed to initialize
[  117.668894] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[  117.682959] Hangcheck: Using getrawmonotonic().
[  117.727009] [drm] Initialized drm 1.1.0 20060810
[  117.754183] events: mcg drbd: 9
[  117.947370] Floppy drive(s): fd0 is 1.44M
[  120.566566] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
[  120.577302] drbd: built-in
[  120.578050] drbd: registered as block device major 147
[  120.598857] dummy-irq: no IRQ given.  Use irq=N
[  120.603305] lkdtm: No crash points registered, enable through debugfs
[  120.732074] Loading iSCSI transport class v2.0-870.
[  120.811509] hp_sw: device handler registered
[  120.812872] emc: device handler registered
[  120.819703] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[  120.895868] osd: LOADED open-osd 0.2.1
[  121.042528] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  121.361853] Failed to ioremap_nocache
[  121.362955] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[  121.389346] slram: not enough parameters.
[  121.616258] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[  121.826372] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[  122.078733] libphy: Fixed MDIO Bus: probed
[  122.153150] tun: Universal TUN/TAP device driver, 1.6
[  122.156986] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  122.234930] PPP generic driver version 2.4.2
[  122.255270] PPP BSD Compression module registered
[  122.262515] PPP Deflate Compression module registered
[  122.272603] PPP MPPE Compression module registered
[  122.279730] NET: Registered protocol family 24
[  122.282771] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
[  122.297364] CSLIP: code copyright 1989 Regents of the University of California.
[  122.299009] SLIP linefill/keepalive option.
[  122.315923] Broadcom 43xx driver loaded [ Features: PL ]
[  122.324342] libertas_sdio: Libertas SDIO driver
[  122.325500] libertas_sdio: Copyright Pierre Ossman
[  122.369847] adummy: version 1.0
[  122.507939] aoe: AoE v81 initialised.
[  122.609492] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[  122.680784] serio: i8042 KBD port at 0x60,0x64 irq 1
[  122.682917] serio: i8042 AUX port at 0x60,0x64 irq 12
[  122.789079] mousedev: PS/2 mouse device common for all mice
[  122.945813] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[  122.989999] input: PC Speaker as /devices/platform/pcspkr/input/input1
[  123.171899] rtc-test rtc-test.0: rtc core: registered test as rtc0
[  123.205509] rtc-test rtc-test.1: rtc core: registered test as rtc1
[  123.216646] i2c /dev entries driver
[  123.256046] i2c-parport-light: adapter type unspecified
[  123.289133] pps pps0: new PPS source ktimer
[  123.299398] pps pps0: ktimer PPS source registered
[  123.306448] pps_parport: parallel port PPS client
[  123.311948] Driver for 1-wire Dallas network protocol.
[  123.346050] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[  123.369449] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[  123.495922] applesmc: supported laptop not found!
[  123.497914] applesmc: driver init failed (ret=-19)!
[  123.696651] acquirewdt: WDT driver for Acquire single board computer initialising
[  123.719451] acquirewdt: I/O address 0x0043 already in use
[  123.725929] acquirewdt: probe of acquirewdt failed with error -5
[  123.748832] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=0)
[  123.763278] ib700wdt: WDT driver for IB700 single board computer initialising
[  123.785725] ib700wdt: failed to register misc device
[  123.789774] ib700wdt: probe of ib700wdt failed with error -16
[  123.794214] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[  123.796359] wafer5823wdt: cannot register miscdev on minor=130 (err=-16)
[  123.812218] it87_wdt: no device
[  123.813192] sc1200wdt: build 20020303
[  123.832301] sc1200wdt: io parameter must be specified
[  123.844565] sbc60xxwdt: cannot register miscdev on minor=130 (err=-16)
[  123.846576] sbc8360: failed to register misc device
[  123.853980] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[  123.855777] w83697hf_wdt: watchdog not found at address 0x2e
[  123.869451] w83697hf_wdt: No W83697HF/HG could be found
[  123.875398] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[  123.885760] w83697ug_wdt: No W83697UG/UF could be found
[  123.896456] w83977f_wdt: driver v1.00
[  123.902499] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[  123.906499] machzwd: MachZ ZF-Logic Watchdog driver initializing
[  123.910615] machzwd: no ZF-Logic found
[  123.912898] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[  123.927190] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[  123.979807] FDC 0 is a S82078B
[  124.066509] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[  124.081638] Bluetooth: Virtual HCI driver ver 1.3
[  124.098513] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[  124.108386] Modular ISDN core version 1.1.29
[  124.139324] NET: Registered protocol family 34
[  124.154535] cpuidle: using governor ladder
[  124.155878] cpuidle: using governor menu
[  124.172814] sdhci: Secure Digital Host Controller Interface driver
[  124.176650] sdhci: Copyright(c) Pierre Ossman
[  124.282310] ledtrig-cpu: registered to indicate activity on CPUs
[  124.365451] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[  124.852704] oprofile: using timer interrupt.
[  124.899827] NET: Registered protocol family 26
[  124.906509] Mirror/redirect action on
[  124.919594] Simple TC action Loaded
[  124.962142] u32 classifier
[  124.962982]     input device check on
[  124.969705]     Actions configured
[  124.978646] Netfilter messages via NETLINK v0.30.
[  125.032596] xt_time: kernel timezone is -0000
[  125.049470] ipip: IPv4 over IPv4 tunneling driver
[  125.103292] gre: GRE over IPv4 demultiplexor driver
[  125.127785] ip_tables: (C) 2000-2006 Netfilter Core Team
[  125.189404] arp_tables: (C) 2002 David S. Miller
[  125.216559] TCP: cubic registered
[  125.300948] NET: Registered protocol family 10
[  125.544792] ip6_tables: (C) 2000-2006 Netfilter Core Team
[  125.579093] sit: IPv6 over IPv4 tunneling driver
[  125.686380] ip6_gre: GRE over IPv6 tunneling driver
[  125.746555] NET: Registered protocol family 17
[  125.782829] NET: Registered protocol family 9
[  125.789400] X.25 for Linux Version 0.2
[  125.893034] IrCOMM protocol (Dag Brattli)
[  126.195140] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[  126.203105] Bluetooth: HIDP socket layer initialized
[  126.238726] NET: Registered protocol family 33
[  126.246029] Key type rxrpc registered
[  126.254240] Key type rxrpc_s registered
[  126.256241] lec:lane_module_init: lec.c: initialized
[  126.264950] l2tp_core: L2TP core driver, V2.0
[  126.279227] l2tp_ppp: PPPoL2TP kernel driver, V2.0
[  126.281607] l2tp_debugfs: L2TP debugfs support
[  126.282679] 8021q: 802.1Q VLAN Support v1.8
[  126.342985] sctp: Hash tables configured (established 8192 bind 8192)
[  126.399882] sctp: sctp_init_sock(sk: ffff8800049c4000)
[  126.419806] lib80211: common routines for IEEE802.11 drivers
[  126.436148] lib80211_crypt: registered algorithm 'NULL'
[  126.437969] tipc: Activated (version 2.0.0)
[  126.503930] NET: Registered protocol family 30
[  126.505129] tipc: Started in single node mode
[  126.533133] Key type dns_resolver registered
[  126.544455] Key type ceph registered
[  126.593220] libceph: loaded (mon/osd proto 15/24)
[  126.636982] batman_adv: B.A.T.M.A.N. advanced 2013.2.0 (compatibility version 14) loaded
[  126.681951] 
[  126.681951] printing PIC contents
[  126.683696] ... PIC  IMR: edb8
[  126.683696] ... PIC  IRR: 0011
[  126.697566] ... PIC  ISR: 0000
[  126.698323] ... PIC ELCR: 0200
[  126.749471] registered taskstats version 1
[  126.813036] Key type trusted registered
[  126.865474] Key type encrypted registered
[  126.907347] IMA: No TPM chip found, activating TPM-bypass!
[  127.062603] console [netcon0] enabled
[  127.076288] netconsole: network logging started
[  127.102391] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[  127.112861] EDD information not available.
[  127.309732] Freeing unused kernel memory: 1144k freed
[  127.685557] Write protecting the kernel read-only data: 24576k
[  127.859219] Freeing unused kernel memory: 320k freed
[  128.559815] Freeing unused kernel memory: 1700k freed
[  128.609902] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[  128.610401] BUG: unable to handle kernel paging request at ffffffff82ee0621
[  128.610401] IP: [<ffffffff82ee0621>] classes_init+0x40/0x40
[  128.610401] PGD 280e067 PUD 280f063 PMD 4a09063 PTE 8000000002ee0163
[  128.610401] Oops: 0011 [#1] 
[  128.610401] CPU: 0 PID: 16 Comm: kworker/0:1 Not tainted 3.10.0-rc4-00345-g64f0389 #6
[  128.610401] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  128.610401] Workqueue: events brcmf_driver_init
[  128.610401] task: ffff88000dd12a00 ti: ffff88000df70000 task.ti: ffff88000df70000
[  128.610401] RIP: 0010:[<ffffffff82ee0621>]  [<ffffffff82ee0621>] classes_init+0x40/0x40
[  128.610401] RSP: 0000:ffff88000df71df0  EFLAGS: 00000202
[  128.610401] RAX: ffff88000df71da0 RBX: ffffffff82bee540 RCX: 0000000000000002
[  128.610401] RDX: ffffffff825fe26e RSI: ffffffff81afb400 RDI: ffffffff82bf17a0
[  128.610401] RBP: ffff88000df71df8 R08: ffff880009201458 R09: 0000000000000000
[  128.610401] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88000de1de10
[  128.610401] R13: ffff88000df71fd8 R14: 0000000000000000 R15: 0000000000000000
[  128.610401] FS:  0000000000000000(0000) GS:ffffffff82846000(0000) knlGS:0000000000000000
[  128.610401] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  128.610401] CR2: ffffffff82ee0621 CR3: 000000000280d000 CR4: 00000000000006b0
[  128.610401] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  128.610401] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  128.610401] Stack:
[  128.610401]  ffffffff81afc8f1 ffff88000df71e08 ffffffff81aec81e ffff88000df71e58
[  128.610401]  ffffffff81104d64 0000000000000000 ffff88000fff2a00 ffff88000de1de40
[  128.610401]  ffffffff828955f0 ffff88000de1de40 ffff88000dd12a00 ffffffff828955e0
[  128.610401] Call Trace:
[  128.610401]  [<ffffffff81afc8f1>] ? brcmf_sdio_init+0x41/0xd0
[  128.610401]  [<ffffffff81aec81e>] brcmf_driver_init+0x1e/0x30
[  128.610401]  [<ffffffff81104d64>] process_one_work+0x1c4/0x5c0
[  128.610401]  [<ffffffff81105994>] worker_thread+0x294/0x650
[  128.610401]  [<ffffffff81105700>] ? rescuer_thread+0x550/0x550
[  128.610401]  [<ffffffff8110f695>] kthread+0xc5/0xe0
[  128.610401]  [<ffffffff8110f5d0>] ? __kthread_parkme+0xb0/0xb0
[  128.610401]  [<ffffffff8219403a>] ret_from_fork+0x7a/0xb0
[  128.610401]  [<ffffffff8110f5d0>] ? __kthread_parkme+0xb0/0xb0
[  128.610401] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 
[  128.610401] RIP  [<ffffffff82ee0621>] classes_init+0x40/0x40
[  128.610401]  RSP <ffff88000df71df0>
[  128.610401] CR2: ffffffff82ee0621
[  128.610401] ---[ end trace 1c90dad9e2481460 ]---
[  128.610401] Kernel panic - not syncing: Fatal exception
[  128.610401] Rebooting in 10 seconds..Elapsed time: 210

--zhXaljGHf11kAtnf
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-64f0389f50f3576360e5b2870e5b09c8c500a373-x86_64-randconfig-c26-0606-BUG:-unable-to-handle-kernel-paging-request-at-6340.log"
Content-Transfer-Encoding: base64

YmlzZWN0OiBza2lwIDI5ZWI3NzgyNWNjN2RhOGQ0NWI2NDJkZTJkZTNkNDIzZGM4YTM2M2Y6
IG5vdCBhIGdvb2QgbWVyZ2UgYmFzZQpnaXQgY2hlY2tvdXQgdjMuOQpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyA2NGYwMzg5Li4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J25mYy1maXhlcy9tYXN0ZXInIGludG8gZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAx
OApIRUFEIGlzIG5vdyBhdCBjMWJlNWE1Li4uIExpbnV4IDMuOQpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvbGludXgtZGV2
ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAxODpjMWJlNWE1YjFiMzU1ZDQwZTZj
Zjc5Y2M5NzllYjY2ZGFmYTI0YWQxOmJpc2VjdC1tbQoKMjAxMy0wNi0wNy0xNToxODowNyBj
MWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxIGNvbXBpbGluZwoxMzIg
cmVhbCAgMTg4MCB1c2VyICAxNDAgc3lzICAxNTI4Ljc3JSBjcHUgCXg4Nl82NC1yYW5kY29u
ZmlnLWMyNi0wNjA2CgoyMDEzLTA2LTA3LTE1OjIwOjM1IGRldGVjdGluZyBib290IHN0YXRl
IDMuOS4wLi4uCTIJNgk5CTEyCTE2CTE4CTE5CTIyCTI3CTI4CTMyCTM1CTM4CTQ1CTUwCTU1
CTU3CTY5CTc5CTg2CTk5CTEyMwkxNDIJMTU5CTE2NAkxNjgJMTc2CTE4MgkyMDEJMjA3CTIy
MQkyMzUJMjQ0CTI1MAkyNjQJMjc0CTI4MgkyODcuCTI5OAkzMDAJMzA1CTMxMAkzMTgJMzI0
CTMyOQkzMzUJMzQzCTM0NgkzNDgJMzQ5Li4JMzUwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBj
b21taXQgdjMuOQpnaXQgYmlzZWN0IHN0YXJ0IDY0ZjAzODlmNTBmMzU3NjM2MGU1YjI4NzBl
NWIwOWM4YzUwMGEzNzMgdjMuOSAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBjMWJl
NWE1Li4uIExpbnV4IDMuOQpIRUFEIGlzIG5vdyBhdCAzYzBlZWUzLi4uIExpbnV4IDIuNi4z
NwpCaXNlY3Rpbmc6IDY5NzcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDEzIHN0ZXBzKQpbNzMyODdhNDNjYzc5Y2EwNjYyOWE4OGQxYTE5OWNkMjgzZjQy
NDU2YV0gTWVyZ2UgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L2RhdmVtL25ldC1uZXh0CmdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1jMjYtMDYwNi9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQt
MjAxMzA2MDcwMDE4OjczMjg3YTQzY2M3OWNhMDY2MjlhODhkMWExOTljZDI4M2Y0MjQ1NmE6
YmlzZWN0LW1tCgoyMDEzLTA2LTA3LTE1OjQ5OjM2IDczMjg3YTQzY2M3OWNhMDY2MjlhODhk
MWExOTljZDI4M2Y0MjQ1NmEgY29tcGlsaW5nCjIyMSByZWFsICAxOTMyIHVzZXIgIDE1NCBz
eXMgIDk0My44MSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNgoKMjAxMy0wNi0w
Ny0xNTo1NDoyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC0wMjAwMS1nNzMyODdhNC4u
LgkxCTUJMTAuLi4uCTEyCTE1CTE4CTE5CTIyCTI1LgkyNgkyNwkzMQkzMwkzOQk0MQk0Mgk0
NQk0Nwk1My4JNTQuCTU4CTYwCTYxCTY0LiBURVNUIEZBSUxVUkUKG1sxOzM1bUluY3JlYXNp
bmcgcmVwZWF0IGNvdW50IGZyb20gMzUwIHRvIDY1MBtbMG0KZG1lc2cta3ZtLWFudC0yNTAy
MS0yMDEzMDYwNzE2MTM0MC0zLjkuMC0wMjAwMS1nNzMyODdhNC0yCgpCaXNlY3Rpbmc6IDM2
MDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBz
KQpbNWQ0MzRmY2IyNTVkZWM5OTE4OWYxYzU4YTA2ZTRmNTZlMTJiZjc3ZF0gTWVyZ2UgYnJh
bmNoICdmb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9qaWtvcy90cml2aWFsCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYv
bGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAxODo1ZDQzNGZjYjI1
NWRlYzk5MTg5ZjFjNThhMDZlNGY1NmUxMmJmNzdkOmJpc2VjdC1tbQoKMjAxMy0wNi0wNy0x
NjoxMjowNSA1ZDQzNGZjYjI1NWRlYzk5MTg5ZjFjNThhMDZlNGY1NmUxMmJmNzdkIGNvbXBp
bGluZwozMDkgcmVhbCAgMTkwNiB1c2VyICAxNTAgc3lzICA2NjMuNzQlIGNwdSAJeDg2XzY0
LXJhbmRjb25maWctYzI2LTA2MDYKCjIwMTMtMDYtMDctMTY6MTg6MzYgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy45LjAtMDM0MTYtZzVkNDM0ZmMuLgkxCTIJNAk2CTcJOC4JOS4JMTAuCTEx
CTE1CTE4CTIwCTIyCTI0LgkyNwkzMQkzNS4JNDEJNDcJNTQJNTcJNTkJNjMJNjUJNzAJNzIJ
NzQJNzUJNzYJNzgJODEuLgk4NC4JODYJODgJOTIJOTYJOTcJOTkJMTAxCTEwMwkxMDUJMTA3
CTEwOQkxMTUJMTE4CTEyOAkxMjkJMTMxCTEzNQkxNDEJMTQ2CTE1MwkxNTYJMTU4CTE2MAkx
NjQJMTY1CTE2NwkxNzAuCTE3MS4JMTczLi4JMTc1CTE3Ni4JMTc4CTE3OS4uLgkxODAuLi4u
Li4JMTgxCTE4Mi4uCTE4My4uLi4uCTE4NAkxODUuLi4JMTg2Li4uLi4uLi4JMTg4Li4JMTg5
Li4JMTkxCTE5MwkxOTYJMTk4CTIwMwkyMTEJMjE2CTIxOQkyMjMuCTIyOAkyMzAJMjM2CTIz
OAkyMzkuCTI0MQkyNDIJMjQzCTI0OAkyNDkJMjUxLgkyNTIuLi4JMjUzCTI1NC4JMjU1CTI1
Ni4uLgkyNTkJMjYxCTI2Mi4uLgkyNjMuLi4uCTI2NC4uLi4uLi4JMjY1Li4uLi4JMjY3Lgky
NjguCTI3MC4uLgkyNzIuLgkyNzMuLi4uLi4JMjc0CTI3NS4uLi4uLi4JMjc2Li4uLi4uLi4u
Li4uLi4JMjc4LgkyODAuLi4uLi4JMjgyCTI4Ni4JMjg4CTI5MC4JMjkyLgkyOTQJMjk3Li4u
CTMwMC4uLgkzMDEJMzAyCTMwNS4JMzA2Li4uLgkzMDcuCTMwOAkzMDkuLi4uLi4JMzEwLi4u
Li4JMzExLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTMxMi4uLi4uLgkzMTMuLi4uLi4uLi4uCTMx
NC4uLi4uLi4uLi4uLi4uLi4JMzE1Li4uLi4uLi4uLi4uLi4uLgkzMTYJMzE3LgkzMTguCTMx
OS4JMzIwCTMyMS4uLi4JMzIyLi4JMzIzLgkzMjQuLi4uCTMyNQkzMjYuLi4JMzI3Li4uCTMy
OC4uLgkzMjkuLi4uLgkzMzAuCTMzMQkzMzIJMzM0CTMzNS4JMzM2Li4uLgkzMzcJMzM4Li4J
MzM5LgkzNDAuLgkzNDEuCTM0MgkzNDQuLgkzNDUuLi4uLgkzNDYJMzQ3LgkzNDkJMzUwLgkz
NTEJMzUyLgkzNTMJMzU0CTM1NS4uCTM1NgkzNTguLgkzNTkuCTM2MAkzNjEJMzYyLgkzNjQJ
MzY1LgkzNjYuLi4JMzY4Li4uCTM3MC4uCTM3MQkzNzMJMzc0LgkzNzYuLgkzNzcuLi4JMzc4
Li4JMzc5Li4JMzgwCTM4Mi4uLi4uCTM4MwkzODUuCTM4NgkzODcuLgkzODgJMzg5CTM5MS4u
CTM5MwkzOTQJMzk1CTM5NwkzOTguCTM5OQk0MDAuLgk0MDEuLi4uCTQwMi4JNDAzLi4uCTQw
NS4JNDA3CTQwOAk0MDkuLi4JNDEwLgk0MTIJNDE0CTQxNQk0MTgJNDE5Li4JNDIxCTQyMi4J
NDIzCTQyNgk0MjcuCTQyOC4JNDI5CTQzMAk0MzEJNDMyCTQzNAk0MzUuLi4JNDM2Li4JNDM4
Li4JNDQwLgk0NDEuLi4JNDQyLi4uLgk0NDMuCTQ0NC4uCTQ0NQk0NDYJNDQ3Li4uLgk0NTAu
CTQ1MQk0NTIuCTQ1NQk0NTYJNDU3Li4JNDYwCTQ2Mgk0NjMJNDY0CTQ2Ngk0NjkJNDcxCTQ3
Mgk0NzQuCTQ3NS4JNDc3Lgk0NzgJNDgwLgk0ODEJNDg0Lgk0ODYuCTQ4Ny4uCTQ4OC4JNDg5
CTQ5MS4JNDkyLi4JNDkzCTQ5NC4JNDk1Lgk0OTYJNDk3CTQ5OS4JNTAwLi4JNTAxCTUwMi4u
CTUwMy4uLgk1MDQuCTUwNS4uLi4uLi4uLi4JNTA2Li4JNTA3Li4uLi4uLi4JNTA5CTUxMC4u
Li4JNTExLi4uLi4uLi4JNTEyLgk1MTMJNTE0Li4uLi4JNTE2CTUxNy4uLi4uLi4uLi4uLi4u
CTUxOS4uLgk1MjEuLi4uLi4uLi4uLi4uLgk1MjIuLi4uLi4uLi4uLgk1MjMJNTI0Li4uLi4u
Li4uLi4uCTUyNi4uLi4uLi4uCTUyNy4uLi4JNTI4Li4JNTI5Li4uLi4uLi4uLi4uLi4uCTUz
MS4uLgk1MzIuLgk1MzMuCTUzNC4uLi4uLgk1MzUuLi4JNTM2Li4uLi4uCTUzOC4uLi4uCTUz
OS4JNTQwLi4JNTQxCTU0Mi4uLi4uCTU0My4uCTU0NS4JNTQ2Li4uCTU0Ny4uLi4JNTQ4Lgk1
NDkuLgk1NTAuLgk1NTIJNTUzCTU1NC4JNTU1Lgk1NTYJNTU3Lgk1NTguLi4JNTU5CTU2MC4J
NTYxLgk1NjIuCTU2Mwk1NjQuLi4uCTU2Ngk1NjgJNTY5Li4JNTcxLgk1NzIJNTczLi4uCTU3
NAk1NzYuCTU3OAk1NzkJNTgwLi4uCTU4MS4uLgk1ODIuCTU4NQk1ODcJNTg4CTU4OS4JNTkw
CTU5MS4JNTkyCTU5Mwk1OTQuLi4uLi4uLi4JNTk1Li4uLgk1OTYuLgk1OTcuLgk1OTguLi4u
Li4uLi4uLi4uLgk2MDAuLi4uLi4JNjAxLgk2MDMuCTYwNC4JNjA2CTYwOAk2MDkJNjEwLi4J
NjExCTYxNC4uLi4JNjE1Lgk2MTYJNjE4Li4JNjIwLgk2MjEuLgk2MjMuCTYyNAk2MjUuCTYy
Ni4JNjI3CTYyOS4uLgk2MzAuCTYzMS4uCTYzMwk2MzQJNjM1Lgk2MzcJNjM5CTY0MC4JNjQx
CTY0Mi4uCTY0NC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgNhtbMG0KLi4uCTY0NS4uCTY0Ni4uLgk2NDcJ
NjQ4CTY0OQk2NTAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxODAwIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzkxYmMwMzNjNGQwMTY1NmUz
ZDhlNDVhMTNmZDU4OTI0YTMwOTk2OTNdIGJyaWRnZTogYXZvaWQgT09QUyBpZiByb290IHBv
cnQgbm90IGZvdW5kCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvbGludXgtZGV2ZWw6
ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAxODo5MWJjMDMzYzRkMDE2NTZlM2Q4ZTQ1
YTEzZmQ1ODkyNGEzMDk5NjkzOmJpc2VjdC1tbQoKMjAxMy0wNi0wOC0wMTo0NjowOCA5MWJj
MDMzYzRkMDE2NTZlM2Q4ZTQ1YTEzZmQ1ODkyNGEzMDk5NjkzIGNvbXBpbGluZwoyNjEgcmVh
bCAgMTkyNyB1c2VyICAxNDcgc3lzICA3OTMuNzElIGNwdSAJeDg2XzY0LXJhbmRjb25maWct
YzI2LTA2MDYKCjIwMTMtMDYtMDgtMDE6NTA6NDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45
LjAtcmM4LTAxODAwLWc5MWJjMDMzLi4uLi4uLgkxCTMJNAk1Li4JNy4uCTEwLi4uCTExCTEy
CTEzLi4uLi4uLi4uLgkxNS4uLi4uCTE2Li4uCTE3Li4JMTgJMTkuLi4uCTIwCTIyLgkyMyBU
RVNUIEZBSUxVUkUKZG1lc2cta3ZtLWFudC0yNTUzOS0yMDEzMDYwODAyMjA0Ni0zLjkuMC1y
YzgtMDE4MDAtZzkxYmMwMzMtNAoKQmlzZWN0aW5nOiA5NTIgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbOTUzYzk2ZTBkODU2MTVkMWFi
MWYxMDBlNTI1ZDM3NjA1MzI5NGRjMl0gdGczOiBVc2UgYm9vbCBub3QgaW50CnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
bW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctYzI2LTA2MDYvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIw
MTMwNjA3MDAxODo5NTNjOTZlMGQ4NTYxNWQxYWIxZjEwMGU1MjVkMzc2MDUzMjk0ZGMyOmJp
c2VjdC1tbQoKMjAxMy0wNi0wOC0wMjoxODo0NCA5NTNjOTZlMGQ4NTYxNWQxYWIxZjEwMGU1
MjVkMzc2MDUzMjk0ZGMyIGNvbXBpbGluZwoyMjMgcmVhbCAgMTg3MSB1c2VyICAxNDYgc3lz
ICA5MDQuMzMlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYKCjIwMTMtMDYtMDgt
MDI6MjI6NDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAtcmM1LTAxMTM0LWc5NTNjOTZl
Li4JMS4JMgkzLi4JNC4JNS4uCTYuCTcuCTkuLi4JMTAuLgkxMQkxMgkxMy4JMTQJMTUJMTYu
CTE5CTIwLgkyMS4JMjIJMjMuLgkyNAkyNS4uLi4JMjYJMjcJMjgJMjkuCTMyCTMzLi4JMzQJ
MzYuLgkzNy4uCTM4CTQxLgk0NAk0NS4JNDcuCTQ4CTQ5CTUwCTUzCTU0CTU1Li4JNTYJNTcu
CTU4Li4uLgk1OS4uLi4uLi4uLgk2MQk2Mgk2Mwk2NAk2NQk2Ni4uLi4JNjcJNjgJNjkuLgk3
MC4uCTcxLi4uCTcyCTczCTc1Li4uLgk3Ngk3OC4JNzkuLi4JODAuCTgxCTgyLi4JODMJODYJ
ODgJOTEJOTIuCTk0CTk1CTk3Li4uCTk4Li4JMTAwLi4uCTEwMQkxMDQJMTA2CTEwOC4uLi4J
MTEwCTExMS4JMTEyCTExNAkxMTYJMTE5LgkxMjEuCTEyNC4uLgkxMjYJMTI3CTEyOC4uLi4J
MTMwCTEzMQkxMzIJMTMzLi4uLgkxMzQuCTEzNi4uCTEzOAkxMzkJMTQwCTE0MQkxNDMuCTE0
NS4uCTE0OAkxNDkJMTUxCTE1MwkxNTQuLi4uCTE1NQkxNTYuCTE1OQkxNjEJMTYzCTE2OAkx
NjkJMTcxCTE3MgkxNzMJMTc0Li4uCTE3NS4uLgkxNzcJMTc5CTE4MAkxODIuLi4JMTgzCTE4
NAkxODUuCTE4NgkxODcuLgkxOTAJMTkxCTE5MgkxOTMuCTE5NAkxOTUJMTk2CTE5Ny4JMjAx
LgkyMDIJMjAzCTIwNS4JMjA3CTIwOQkyMTEuCTIxMgkyMTMuLi4uCTIxNS4uCTIxNgkyMTcJ
MjE4LgkyMTkuLgkyMjAJMjIyCTIyNAkyMjUJMjI4Li4uCTIyOQkyMzAuCTIzMS4JMjMzCTIz
Ni4JMjM3Li4uCTIzOS4uLgkyNDAJMjQyLgkyNDMJMjQ0CTI0Ny4JMjQ5LgkyNTAuCTI1MS4J
MjUyLgkyNTYJMjU4LgkyNjEuCTI2MwkyNjQJMjY1LgkyNjkJMjcwCTI3MS4JMjcyCTI3NC4J
Mjc1Li4uLgkyNzcJMjc5CTI4MgkyODQJMjg2CTI4OC4uLgkyOTAJMjkxCTI5MwkyOTUJMjk2
CTI5Ny4JMjk5CTMwMQkzMDIuLi4JMzAzLi4JMzA0Li4uCTMwNQkzMDYJMzA3LgkzMDguLi4u
CTMwOS4uCTMxMAkzMTEJMzEyLgkzMTUJMzE4Li4JMzE5CTMyMAkzMjIJMzIzCTMyNC4JMzI1
CTMyNgkzMjcuCTMyOS4JMzMxCTMzMi4JMzM0Li4JMzM1LgkzMzcJMzM4Li4uLi4JMzQwCTM0
MS4JMzQ0CTM0NQkzNDcuCTM0OS4uCTM1MAkzNTMJMzU1CTM1NwkzNTguLgkzNTkJMzYwCTM2
MS4JMzY1CTM2Ny4JMzY5Li4JMzcxCTM3MwkzNzUJMzc3Li4uLi4JMzc4Li4JMzc5CTM4Mgkz
ODMJMzg0CTM4NQkzODcuCTM4OS4uLgkzOTAuLgkzOTEuCTM5MgkzOTMuCTM5NS4uLi4uCTM5
Ni4JMzk3Li4uCTM5OC4JNDAwLi4JNDAxCTQwMgk0MDMJNDA2CTQwNy4JNDA4Li4JNDA5CTQx
MS4uLgk0MTIJNDEzCTQxNC4JNDE1CTQxNgk0MTcuLgk0MTguCTQyMQk0MjUuCTQyNi4JNDI3
Lgk0MjgJNDMxCTQzMi4JNDM1CTQzNi4JNDM5CTQ0MC4JNDQxCTQ0Mgk0NDMJNDQ0Lgk0NDYu
CTQ0Ny4uCTQ0OC4uCTQ0OQk0NTAuLgk0NTIuCTQ1NAk0NTUJNDU4CTQ2MAk0NjMJNDY1Lgk0
NjYJNDY3CTQ2OC4uLgk0NzAuCTQ3Mgk0NzMJNDc2CTQ3OC4uLgk0NzkJNDgxLi4JNDgyCTQ4
My4uLgk0ODQJNDg1CTQ4Ny4JNDg4Lgk0ODkuLi4uLi4uLi4JNDkyLi4uLgk0OTMuLgk0OTQJ
NDk1CTQ5Ngk0OTcJNDk5CTUwMC4JNTAxLi4JNTAyLgk1MDMJNTA0Li4uCTUwNi4JNTA3CTUw
OS4JNTEwLi4JNTExCTUxMy4JNTE1Lgk1MTcuCTUxOS4JNTIwCTUyMQk1MjIJNTIzCTUyNAk1
MjYuLi4uLi4uCTUyNy4uLi4JNTI4Li4uCTUzMC4JNTMxCTUzMi4JNTMzLgk1MzQuLgk1MzUu
CTUzNi4JNTM4Li4JNTM5Lgk1NDAuLi4JNTQxLgk1NDIuCTU0My4uLi4uLi4uCTU0NC4uLi4u
Li4uLi4uLi4JNTQ1CTU0Ni4uLi4JNTQ3CTU0OAk1NDkuLi4uLi4JNTUwCTU1MS4uLi4uLgk1
NTIuLi4uLi4uLi4uLi4uLi4uLi4uLi4JNTU0Li4uLi4uCTU1NS4JNTU3Lgk1NTguLi4JNTYw
Li4JNTYyLi4uLgk1NjMuCTU2NAk1NjUJNTY2Li4JNTY3Li4uLgk1NjguLgk1NjkuLi4uLi4u
Li4JNTcwLgk1NzEuLgk1NzIuCTU3My4uLi4uLi4uCTU3NC4uLgk1NzYuLi4uCTU3Ny4uLgk1
NzgJNTgxLi4uLi4uLgk1ODIuLi4uLi4uLgk1ODQuCTU4NS4uLi4uCTU4Ngk1ODcuCTU4OC4u
Li4uCTU4OS4uLi4JNTkwLi4uLi4uLgk1OTEJNTkyLgk1OTMuLi4JNTk0Li4uLi4uCTU5NS4u
Li4uLi4uLi4uCTU5Ni4JNTk3Li4uCTU5OC4uLi4uLgk1OTkJNjAwCTYwMi4uLi4uCTYwMy4u
Lgk2MDQuLi4JNjA1Lgk2MDYuLgk2MDcuLi4uCTYwOS4JNjEwLi4uLi4uLgk2MTEJNjEzLi4u
CTYxNC4uLi4uCTYxNS4JNjE2Li4JNjE3Li4JNjE4Li4uLi4uCTYxOS4uLi4uLi4uLi4uCTYy
MC4JNjIxCTYyMi4JNjIzLi4uLi4JNjI0CTYyNS4uCTYyNi4JNjI3Li4uLi4uLi4uLgk2Mjgu
CTYyOS4uLi4uLgk2MzAJNjMxLgk2MzIJNjMzLi4uLgk2MzQuLi4uLi4uLi4uCTYzNS4uLi4u
Li4uLi4JNjM2Li4uLi4JNjM3Li4uLi4uLi4uLgk2MzguLi4uLi4uLgk2MzkuLi4uLi4uLgk2
NDAuLi4JNjQxLi4uLgk2NDIuLgk2NDMJNjQ0Li4JNjQ1CTY0Ni4uLgk2NDcuLi4uCTY0OC4u
CTY0OS4JNjUwIFNVQ0NFU1MKCkJpc2VjdGluZzogNDc2IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbNmQ0MjFlNTRjMjI3Nzk5MGYzYjBl
M2RkOTJlNDQ2ODAwYzkwZWZhM10gYnJjbWZtYWM6IHVzZSBsb2NrIGluIGJyY21mX2Z3c19k
ZWxfaW50ZXJmYWNlKCkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi9saW51eC1kZXZl
bDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDcwMDE4OjZkNDIxZTU0YzIyNzc5OTBmM2Iw
ZTNkZDkyZTQ0NjgwMGM5MGVmYTM6YmlzZWN0LW1tCgoyMDEzLTA2LTA4LTExOjUyOjM1IDZk
NDIxZTU0YzIyNzc5OTBmM2IwZTNkZDkyZTQ0NjgwMGM5MGVmYTMgY29tcGlsaW5nCjI2MCBy
ZWFsICAxODY0IHVzZXIgIDEzOCBzeXMgIDc2Ny44NCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZp
Zy1jMjYtMDYwNgoKMjAxMy0wNi0wOC0xMTo1NzowNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjkuMC1yYzEtMDA5MzItZzZkNDIxZTUuLgkxLgkyLgkzLgk0Li4uLi4JNS4uCTYuLi4uCTgu
Lgk5CTExLi4uCTEyCTEzLi4uLi4uCTE0CTE2CTE3CTE5LgkyMC4uLi4JMjEJMjIuLi4uCTIz
Li4uCTI0LgkyNS4uLgkyNwkyOC4uLi4JMjkuCTMwLgkzMgkzMy4JMzUJMzcuLi4uLi4JMzku
Li4uLgk0MC4uCTQyLi4uCTQzLgk0NAk0NQk0Ni4uLi4JNDcJNDkuCTUxCTUyCTUzLi4JNTQu
Lgk1NQk1Ni4uLi4JNTcJNTguLgk2MAk2MS4JNjIJNjQuLgk2NS4JNjYuLi4uCTY3Li4JNjgu
CTY5Li4uLi4uCTcwCTcxCTcyCTczCTc0Li4uCTc1Lgk3Ngk3Nwk3OAk3OS4JODAuCTgxLi4J
ODIuLi4uLi4uLi4JODQuCTg1Lgk4Ni4uLi4uLgk4Ny4uLi4uCTg4CTg5Li4uCTkwLi4JOTEu
Li4JOTMJOTQJOTUJOTYuLi4uLi4uLi4JOTcuCTk5LgkxMDAJMTAxLi4uLi4uLi4JMTAyCTEw
My4uLgkxMDQuLi4uLi4uLi4JMTA1Li4JMTA2Li4uLi4uCTEwNy4uLi4JMTA4Li4uLi4uLgkx
MTAuCTExMS4uLi4uLi4uCTExMgkxMTQuLi4uLi4uLi4uLi4uLi4uCTExNS4uLi4uCTExNgkx
MTcuLgkxMTguLi4uLi4uLi4uLi4uLi4uLi4uCTExOS4JMTIwLi4uLi4JMTIxLgkxMjIuLi4J
MTIzLi4uLi4JMTI0CTEyNS4uLi4uLi4JMTI2CTEyNwkxMjgJMTI5Li4uLgkxMzAJMTMxCTEz
Mi4uLi4uLi4uLi4JMTMzLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTM0
Li4uLi4JMTM1CTEzNgkxMzcJMTM4CTEzOS4uLgkxNDEJMTQyLgkxNDMuLi4JMTQ0CTE0Ny4g
VEVTVCBGQUlMVVJFChtbMTszNW1JbmNyZWFzaW5nIHJlcGVhdCBjb3VudCBmcm9tIDY1MCB0
byA3NTAbWzBtCmRtZXNnLWt2bS1hbnQtMjQ5NDAtMjAxMzA2MDgxNTQ0NDktMy45LjAtcmMx
LTAwOTMyLWc2ZDQyMWU1LTYKCkJpc2VjdGluZzogMjM3IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbNzM1MGU2Y2YzNjBkMzIyMDZjYmU0
ZTNkMzRmYjQ4YWI4NjNiZGIxNF0gQmx1ZXRvb3RoOiBoaWRwOiBtZXJnZSBoaWRwX3Byb2Nl
c3Nfe2N0cmwsaW50cn1fdHJhbnNtaXQoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2
L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYwNzAwMTg6NzM1MGU2Y2Yz
NjBkMzIyMDZjYmU0ZTNkMzRmYjQ4YWI4NjNiZGIxNDpiaXNlY3QtbW0KCjIwMTMtMDYtMDgt
MTU6NDI6NTkgNzM1MGU2Y2YzNjBkMzIyMDZjYmU0ZTNkMzRmYjQ4YWI4NjNiZGIxNCBjb21w
aWxpbmcKMzgzIHJlYWwgIDE2NDAgdXNlciAgMTQ1IHN5cyAgNDY1LjMxJSBjcHUgCXg4Nl82
NC1yYW5kY29uZmlnLWMyNi0wNjA2CgoyMDEzLTA2LTA4LTE1OjQ5OjQ1IGRldGVjdGluZyBi
b290IHN0YXRlIDMuOS4wLXJjMS0wMDY3My1nNzM1MGU2Yy4uLi4uLi4uLgkxCTIuCTMJNC4u
Li4JNS4JNi4uLgk5Li4JMTAuCTExLi4uLgkxMgkxNC4uCTE1LgkxNi4JMTguLi4uLi4uCTE5
LgkyMC4uCTIxCTIyLi4uLi4uLgkyMy4uLi4uLi4uCTI0Li4uLi4uLgkyNQkyNgkyNy4uCTI4
LgkyOS4uLgkzMAkzMS4uLi4uCTMyLi4uCTMzCTM0CTM1CTM2LgkzNy4uLi4JMzguLi4uLi4J
MzkJNDAJNDIJNDUJNDYuLi4uLi4uCTQ3Li4uCTQ4CTQ5Lgk1MQk1Mi4uLgk1NAk1NS4JNTYJ
NTcuLi4JNTgJNTkuCTYxLi4uLi4JNjMJNjQuLgk2NS4uCTY3Li4uLi4uLgk2OC4uLi4uCTcw
Lgk3MS4uLi4uCTcyLgk3My4uCTc0Li4JNzUJNzgJNzkuLi4uLgk4MAk4My4uLi4uLi4JODUu
Li4JODYuLi4uLi4uLi4JODcJODguLi4uLi4uLgk4OQk5MC4JOTEuLi4uLgk5Mgk5Mwk5NAk5
NS4uLgk5Ni4uLi4JOTcuLi4uLi4uLgk5OS4uLi4JMTAwLi4uLi4uLi4uLi4uLi4uLgkxMDIJ
MTAzCTEwNAkxMDYJMTA3CTEwOC4uCTEwOS4uLi4uLi4uLi4uLi4uLi4JMTExLi4uLgkxMTIu
Li4uLi4uLi4uCTExMwkxMTQuLi4uLi4uLi4uLgkxMTUuLi4JMTE2CTExNwkxMTguCTEyMC4u
Li4JMTIxLgkxMjIJMTIzLgkxMjUuLi4uLi4uLi4uLi4uCTEyNi4uLi4JMTI3Li4uLi4uCTEy
OC4uLgkxMjkuCTEzMS4uLi4uLgkxMzIuLi4uLi4uLi4uLi4uLi4uCTEzMy4uCTEzNC4uLi4u
LgkxMzUuLi4uLi4uLi4JMTM2Li4JMTM3CTEzOC4uLi4uLi4JMTM5CTE0MC4uLgkxNDEJMTQy
LgkxNDMuLi4uCTE0NAkxNDUJMTQ2Li4uLi4uLi4uLi4JMTQ4CTE0OS4uLi4uCTE1MC4uCTE1
MQkxNTIuLi4JMTUzLi4uLi4uLi4uCTE1NC4uCTE1Ni4uCTE1Ny4uLgkxNTgJMTYwLi4uLi4u
CTE2MQkxNjIJMTYzCTE2NC4JMTY1Li4uLgkxNjYuCTE2Ny4uLi4uCTE2OC4uLi4uLi4uLi4u
LgkxNjkuCTE3MC4uLgkxNzEuLgkxNzIuLi4uLi4uLi4uLi4uLi4uLi4uCTE3NC4uLgkxNzUu
Li4uCTE3Ni4uLi4JMTc3Li4uLi4uLi4uLi4JMTc4LgkxNzkuLi4JMTgwLi4uLi4uLi4JMTgx
Li4JMTgyCTE4My4JMTg1Li4JMTg2CTE4Ny4uCTE4OC4uCTE4OS4JMTkwLi4uLgkxOTEJMTky
CTE5MwkxOTUJMTk2CTE5NwkxOTkuCTIwMC4uLi4uLi4JMjAxLi4uLgkyMDIuLi4uLi4uLi4u
Li4uLi4uLi4uLi4JMjAzLi4uCTIwNAkyMDUuLi4uLgkyMDcuCTIwOC4uLi4uLi4uLi4uLgky
MDkuLi4uLi4uLi4JMjEwLgkyMTEuLi4uLi4uCTIxMy4JMjE0CTIxNS4uLgkyMTYuCTIxNwky
MTgJMjE5LgkyMjAuLi4uCTIyMQkyMjMJMjI0CTIyNQkyMjYJMjI3LgkyMjkuLgkyMzAuCTIz
MQkyMzIuLgkyMzMuCTIzNS4uCTIzNi4JMjM3LgkyMzgJMjM5Li4JMjQwLi4uLi4uLgkyNDEu
CTI0MgkyNDMuLi4JMjQ0LgkyNDUuLgkyNDYuLi4uLi4uLi4uLi4uLi4uLi4uCTI0Ny4uCTI0
OS4uLi4uCTI1MAkyNTIuLi4uCTI1My4uCTI1NC4uLi4JMjU1Li4uLi4JMjU2Li4JMjU3CTI1
OQkyNjEJMjYyCTI2MwkyNjQuLi4uCTI2Ni4JMjY3Li4uCTI2OAkyNjkuLi4uLi4JMjcwLi4u
LgkyNzIuCTI3My4JMjc0CTI3NS4uLi4uLi4uCTI3Ni4uLi4uLgkyNzcuLi4JMjc4Li4uLi4u
Li4uLi4uLi4uLi4JMjc5LgkyODAuCTI4MS4uLgkyODIJMjg0Li4JMjg1CTI4NgkyODcuLgky
ODguCTI4OS4uCTI5MS4uLgkyOTIuLi4uCTI5MwkyOTUJMjk2CTI5OAkzMDAJMzAzCTMwNQkz
MDYJMzA3CTMwOC4JMzA5CTMxMC4JMzExCTMxMgkzMTMJMzE1Li4JMzE2LgkzMTcuCTMxOAkz
MjAuCTMyMQkzMjIuLi4uLgkzMjMJMzI0CTMyNS4uCTMyNi4uLi4uLi4uLgkzMjcJMzI4Lgkz
MzAJMzMxCTMzMy4uLgkzMzQuLgkzMzYJMzM3LgkzMzgJMzM5CTM0MC4uCTM0MS4JMzQyLgkz
NDQuLi4uLgkzNDUuLi4uLi4uLi4uLgkzNDYuLi4uLi4uLi4uLi4uLi4uLi4uLgkzNDcuLi4u
CTM0OC4uLi4uLi4uLi4uLi4JMzQ5Li4uLgkzNTAJMzUxLgkzNTMJMzU1Li4uLi4uLi4uLi4u
Li4uLi4uLi4JMzU2LgkzNTcuCTM1OAkzNTkuLi4uCTM2MC4uLgkzNjEJMzYyLi4JMzYzCTM2
NC4JMzY1Li4uLi4uLi4JMzY3LgkzNzAuLi4uCTM3MS4uLi4uLgkzNzIuLi4JMzczLgkzNzQu
Li4uLi4uLgkzNzYuLi4JMzc4Li4uLgkzNzkJMzgyLi4uLi4uLi4uCTM4My4uLi4uLi4uCTM4
NC4uLi4JMzg1LgkzODYuLi4JMzg3Li4uLi4uLi4JMzg4Li4uCTM4OS4uLi4uLi4uCTM5MAkz
OTEuLi4uLi4uCTM5Mi4uLgkzOTMuLi4uLgkzOTQuLi4uLi4uLi4uLi4uLi4JMzk1Li4JMzk2
LgkzOTcuCTM5OC4uCTM5OS4uLi4JNDAwCTQwMS4uCTQwMi4uLi4JNDAzCTQwNQk0MDYJNDA3
Li4JNDA4Li4JNDA5Li4uLi4JNDExCTQxMy4uLgk0MTYuLgk0MTcuLi4uLi4uLi4uLi4uCTQx
OC4uLi4JNDE5Li4uLi4uCTQyMS4JNDIyLgk0MjMuLi4uLi4uLi4uLi4uLi4uCTQyNS4uCTQy
Ngk0MjcuLi4uLi4uLi4uLgk0MjguCTQyOS4uLi4uLgk0MzIuCTQzMwk0MzQuLgk0MzUuCTQz
Ni4uLgk0MzcuLgk0MzguLi4uCTQ0MC4JNDQxLi4uCTQ0Mi4JNDQzLi4JNDQ0Lgk0NDUuLi4u
Li4JNDQ2Lgk0NDcuLi4uLi4uLi4JNDQ4Li4uLi4uLi4uCTQ0OS4uLi4uLgk0NTAuCTQ1MS4J
NDUyLi4uLi4uLi4uLi4uLi4uLi4JNDUzCTQ1NC4uLi4uLi4uCTQ1NS4uLi4uLi4uLgk0NTYu
CTQ1Ny4JNDU4Li4JNDU5Li4uLgk0NjAuLi4JNDYxLi4JNDYzCTQ2NC4JNDY1Lgk0NjYJNDY3
Li4uLgk0NjgJNDY5Li4JNDcwCTQ3MQk0NzIuCTQ3Mwk0NzQuLi4JNDc1Li4JNDc2Li4JNDc3
Li4JNDc4CTQ4MC4uLgk0ODEJNDgyLi4uCTQ4My4uLi4JNDg0Li4uLi4JNDg1Lgk0ODYuCTQ4
Ny4JNDg4Lgk0ODkuLi4uLi4uCTQ5MC4uLi4uLi4uLi4JNDkxLgk0OTMuLi4uLi4uLgk0OTQJ
NDk1Li4uLi4uLi4uCTQ5Ni4uLi4uLi4JNDk3Lgk0OTgJNDk5CTUwMC4uCTUwMS4uLi4uCTUw
Mi4JNTAzLgk1MDQuLi4uLi4uLgk1MDUJNTA2Lgk1MDcuLi4uCTUwOC4uLi4uLi4JNTA5CTUx
MC4uLgk1MTEuCTUxMi4uLgk1MTMJNTE0Li4uLi4uLi4JNTE1Lgk1MTYuCTUxOC4uLi4uLi4u
Li4JNTE5CTUyMC4uLi4uLi4JNTIyLi4uLgk1MjQuLi4uLi4uLi4uLi4uLi4uLgk1MjYuLi4u
Lgk1MjcuLi4uLi4uCTUyOS4JNTMxLi4uCTUzMi4uLi4uLi4uLi4uCTUzMy4JNTM0CTUzNS4J
NTM2Li4uLi4uLi4uLgk1MzcuLi4uLi4JNTM4CTUzOS4JNTQwCTU0Mi4uCTU0Mwk1NDQuLgk1
NDYuLi4JNTQ3Li4uCTU0OC4uLgk1NDkuLgk1NTAuCTU1Mi4uCTU1My4uLi4JNTU1Lgk1NTYu
Li4JNTU3Li4JNTU4Lgk1NTkuCTU2MC4uLi4uLi4uLi4uCTU2MS4JNTYyLi4uLgk1NjMuLi4u
Li4uLi4uCTU2NC4JNTY2Li4JNTY3Li4uCTU2OAk1NjkuLi4JNTcwLgk1NzEuLi4uLgk1NzIu
CTU3My4uLgk1NzQuLgk1NzUuCTU3Nwk1NzgJNTc5CTU4MC4uLi4uLi4JNTgxLi4JNTgyLgk1
ODMuLi4uLi4JNTg0CTU4Ni4uCTU4OC4uLi4uCTU4OS4uLi4uLgk1OTAJNTkxLi4uLi4uLi4J
NTkzLi4JNTk1Li4JNTk2Li4JNTk3Li4uLgk1OTkJNjAwCTYwMi4uCTYwMy4uCTYwNC4uLi4u
CTYwNS4uLi4uCTYwNi4JNjA3Li4uLi4uLi4uLi4JNjA4Li4uLi4uLi4JNjExCTYxMgk2MTMu
Li4uLgk2MTQuLgk2MTUuLi4uLi4uLgk2MTYJNjE3Li4uLi4uLgk2MTguCTYxOS4uLi4uLi4J
NjIwLi4uLgk2MjEuCTYyMy4JNjI0Li4JNjI1Li4uLgk2MjYuLgk2MjcuCTYyOC4uLgk2MjkJ
NjMwCTYzMS4uLi4uLgk2MzIuLgk2MzMuLi4uLi4uCTYzNC4uLgk2MzYuCTYzOC4uLi4uLi4J
NjM5Lgk2NDEuLi4JNjQyCTY0My4JNjQ0Li4uLi4uLi4uLi4uLgk2NDUuLi4uLi4uLi4uCTY0
Ni4uLi4uCTY0Ny4uCTY0OC4uLi4uLgk2NTEJNjUyCTY1My4uCTY1NC4uLgk2NTUuLi4uLi4u
Li4uCTY1Ni4uLi4uLi4uLi4uLi4uLi4uCTY1Ny4uLi4uCTY1OS4uCTY2MC4uLi4uLi4JNjYx
Li4JNjYyCTY2My4uCTY2NS4uLi4uLi4uCTY2Ni4uLi4uLi4uLi4uLi4uCTY2Ny4uCTY2OC4u
Lgk2NjkuCTY3MC4uLgk2NzMuCTY3NC4uLi4uCTY3NS4JNjc2Li4JNjc3Li4uLi4uLi4uCTY3
OC4uLi4uLgk2NzkuCTY4MC4uLgk2ODEuLi4uLgk2ODMuLi4JNjg0Li4uLi4uLgk2ODUuCTY4
Ni4uLgk2ODcuLi4uCTY4OS4JNjkwLgk2OTEuLi4uLgk2OTIuLi4JNjkzLi4uCTY5NC4uLi4u
Lgk2OTUuLi4uLi4uCTY5Ny4uCTY5OC4uCTY5OS4JNzAwLi4uLi4uLgk3MDEJNzAyLi4uLi4u
Li4uLi4uCTcwMy4JNzA0Li4uLi4uLgk3MDUuLi4uLi4uLi4uLi4uLgk3MDcuLi4uLi4uLgk3
MDguLi4uCTcwOS4uLgk3MTAuLi4uCTcxMQk3MTIuLi4uLi4uLi4uCTcxMy4uLi4JNzE0Li4J
NzE1Li4uLgk3MTYuLi4uLi4uLi4JNzE3Lgk3MTguLi4uCTcxOS4uLgk3MjAJNzIyLi4JNzIz
Li4JNzI1CTcyNi4uCTcyOC4uLi4JNzI5CTczMC4uLgk3MzEuCTczMi4uLi4uLi4uLi4uCTcz
My4uCTczNC4uLi4uLi4uLi4uLi4uLgk3MzUuLi4uLi4uLi4uLi4uLgk3MzYuLgk3MzcuLi4u
Li4JNzM4CTczOS4JNzQwLgk3NDEuLgk3NDIuLi4uLi4uLi4uLgk3NDMuLi4uCTc0NC4JNzQ1
Li4uLi4JNzQ2Li4JNzQ3CTc0OAk3NTAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMTggcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCltkZGYxOWQy
MDZmZTRiYTRlN2RjOTYyOWJjMTQwMjViYTUwOTE1ODg2XSBORkM6IHBuNTMzOiBTaW1wbGlm
eSBfX3BuNTMzX3NlbmRfZnJhbWVfYXN5bmMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYw
Ni9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDcwMDE4OmRkZjE5ZDIw
NmZlNGJhNGU3ZGM5NjI5YmMxNDAyNWJhNTA5MTU4ODY6YmlzZWN0LW1tCgoyMDEzLTA2LTA5
LTEzOjMzOjIyIGRkZjE5ZDIwNmZlNGJhNGU3ZGM5NjI5YmMxNDAyNWJhNTA5MTU4ODYgY29t
cGlsaW5nCjY1NyByZWFsICAxNjYzIHVzZXIgIDE0NiBzeXMgIDI3NS40NyUgY3B1IAl4ODZf
NjQtcmFuZGNvbmZpZy1jMjYtMDYwNgoKMjAxMy0wNi0wOS0xMzo0ODowNiBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjkuMC1yYzEtMDA3NzgtZ2RkZjE5ZDIuLi4uLgkxLi4uLi4uLi4uLi4u
Li4uCTIuCTMuLgk0CTUuCTYuCTcuLi4uLi4JOS4uLi4uLi4uLi4uLgkxMC4uLi4uCTExLgkx
MgkxMy4uLgkxNC4uLi4JMTUuLi4uLi4uCTE2Li4uLi4uLgkxNy4JMTkuLi4uLi4uLi4uLi4J
MjAuLi4uLi4uLgkyMS4uCTIyLgkyMy4uLgkyNC4JMjUJMjcuCTI4Li4uLgkyOQkzMC4uLi4J
MzEuLi4uLgkzMi4uLi4uLi4JMzMJMzQuLgkzNi4uLi4JMzgJMzkuCTQwLi4JNDIuCTQzLi4u
Lgk0NC4uLi4JNDUJNDYuLi4uLi4uCTQ3Lgk0OC4JNDkuLi4JNTAJNTEJNTIJNTMJNTQuCTU1
CTU2Li4uLi4uLi4uCTU4Li4uLi4JNTkuLi4uCTYwLgk2MS4uCTYyLi4JNjMJNjQuLi4uCTY1
Li4uLgk2Ni4JNjcuLi4uLi4uCTY4Lgk2OQk3MS4JNzIJNzMJNzQuLi4uLi4JNzUuLi4uLi4u
Li4JNzYuCTc4Lgk3OS4uLi4uLgk4MQk4Mgk4My4uCTg0Lgk4Ngk4Ny4uCTg5Li4uLi4uLi4J
OTEJOTIuLgk5My4JOTQuLi4uLgk5NS4uLi4uCTk2CTk3Li4JOTguLi4uLi4uLgk5OS4uCTEw
MC4uLi4JMTAyCTEwMwkxMDQuLi4uLi4JMTA2CTEwNy4uCTEwOAkxMDkuCTExMAkxMTEJMTEy
LgkxMTMuLgkxMTQJMTE1LgkxMTcuCTExOAkxMTkJMTIwCTEyMi4uLi4uLi4JMTIzLi4JMTI1
Li4uLi4uLgkxMjYuLi4JMTI3Li4uLi4uLgkxMjkuLi4uLi4uCTEzMC4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxMzEJMTM2CTEzOQkxNDAu
Li4JMTQzLgkxNDUuLi4uCTE0OC4uCTE0OS4uLgkxNTAuCTE1MQkxNTIuLi4JMTU0Li4JMTU1
CTE1NwkxNTguLi4uLi4JMTU5Li4uLi4uCTE2MAkxNjEJMTYyCTE2NC4uCTE2NS4JMTY2CTE2
OC4uLgkxNjkJMTcwLi4JMTcxCTE3MgkxNzMuLi4uLi4uLi4JMTc0Li4uLi4uLgkxNzUuLgkx
NzYJMTc4Li4uLi4uCTE3OQkxODAuLi4uLi4uLi4uLi4uLi4JMTgxLgkxODMuCTE4NC4JMTg1
CTE4Ni4uLgkxODgJMTkxLgkxOTIuLi4JMTkzLi4uCTE5NC4JMTk2Li4uLi4uLgkxOTgJMTk5
Li4JMjAyLi4uLi4uLgkyMDMJMjA0CTIwNQkyMDYuCTIwNy4uLi4uCTIwOQkyMTAuLgkyMTEu
Li4uLgkyMTMuLgkyMTUJMjE2Li4JMjE3Li4uCTIxOS4uLi4JMjIwLi4uLgkyMjEuLgkyMjIu
Li4JMjIzCTIyNAkyMjYuLi4uLi4uCTIyOS4JMjMwCTIzMQkyMzMJMjM1CTIzNi4uLi4JMjM4
Li4JMjM5Li4uCTI0MC4JMjQzLi4JMjQ0CTI0NQkyNDcuCTI0OC4JMjQ5Li4uLi4uCTI1MC4J
MjUxLgkyNTQuLi4JMjU1CTI1Ni4uCTI1Ny4uLi4uCTI1OAkyNTkuCTI2MAkyNjEuLi4uLgky
NjMuLgkyNjUuCTI2Ni4JMjY3CTI2OAkyNjkuLi4uLi4JMjcwLgkyNzEuLi4uLgkyNzIuLi4J
MjczCTI3NAkyNzUJMjc2Li4uLi4uLi4uLi4uLi4JMjc3LgkyNzguCTI3OQkyODAuCTI4MS4u
CTI4My4JMjg0Li4JMjg3Li4uLi4JMjg4Li4uCTI4OQkyOTAuLgkyOTEJMjkyCTI5My4uCTI5
NAkyOTUuCTI5NgkyOTcuLgkzMDEJMzAyLgkzMDMuCTMwNC4uLi4uLi4uLi4uLgkzMDUuCTMw
Ni4uCTMwNy4uCTMwOS4JMzEwLgkzMTEuLi4JMzEyLi4uLgkzMTQuCTMxNQkzMTYuCTMxNy4J
MzE5Li4uCTMyMC4JMzIxCTMyMgkzMjQJMzI2CTMyOAkzMzEuLgkzMzcJMzQwCTM0NgkzNDkJ
MzU2CTM2MgkzNjQJMzY4CTM2OQkzNzcJMzgxCTM4NgkzODguCTM5MQkzOTMJMzk1CTQwOAk0
MTMJNDE3CTQyOC4JNDM0CTQ0MAk0NDUJNDQ4CTQ1NQk0NjMJNDY0Li4JNDY2CTQ3MS4JNDc0
CTQ3OQk0ODEJNDkwCTQ5NAk0OTUJNDk3CTUwMAk1MTcJNTIwCTUyMgk1MjMJNTMxCTUzOAk1
NDcJNTUzCTU1Nwk1NjIJNTcyCTU3Mwk1ODEJNTgzCTYwNQk2MDkJNjEwCTYyNAk2MzAJNjMy
CTYzOQk2NDgJNjQ5CTY2MAk2NjMJNjY0Lgk2NzEJNjc5CTY4Mwk2ODkJNjk4CTcwMi4uCTcw
Mwk3MDkJNzEzCTcyMAk3MjEJNzI1CTcyNwk3MjgJNzMwCTczMgk3MzYJNzM4CTczOS4uLi4J
NzQxLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNzQzLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA3G1swbQouLgk3
NDYJNzUwIFNVQ0NFU1MKCkJpc2VjdGluZzogNTkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpClthODU2NjY2MjdiN2YxMGM0MjI5NzE2YjZm
ZmFmZmNmMTk2YTEyOGNhXSBtYWM4MDIxMS9taW5zdHJlbF9odDogdXNlIHRoZSBuZXcgcmF0
ZSBjb250cm9sIEFQSQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2L2xpbnV4LWRldmVs
OmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYwNzAwMTg6YTg1NjY2NjI3YjdmMTBjNDIyOTcx
NmI2ZmZhZmZjZjE5NmExMjhjYTpiaXNlY3QtbW0KCjIwMTMtMDYtMDktMjM6MzE6NDEgYTg1
NjY2NjI3YjdmMTBjNDIyOTcxNmI2ZmZhZmZjZjE5NmExMjhjYSBjb21waWxpbmcKNDA1IHJl
YWwgIDE2MjcgdXNlciAgMTQzIHN5cyAgNDM3LjEwJSBjcHUgCXg4Nl82NC1yYW5kY29uZmln
LWMyNi0wNjA2CgoyMDEzLTA2LTA5LTIzOjM5OjIxIGRldGVjdGluZyBib290IHN0YXRlIDMu
OS4wLXJjMS0wMDgxOC1nYTg1NjY2Ni4uCTEJNwkxMC4JMTIJMjIJMjcJMjkJMzEJMzQJMzYJ
MzkJNDIJNDMJNDkJNTEJNTQJNzAJNzgJODgJOTMJMTAwCTEwMwkxMTQgVEVTVCBGQUlMVVJF
CmRtZXNnLWt2bS1hbnQtMjUwMjEtMjAxMzA2MDkyMzU0MjgtMy45LjAtcmMxLTAwODE4LWdh
ODU2NjY2LTkKCkJpc2VjdGluZzogMjkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDUgc3RlcHMpClsxYjczN2Y4OGRjMWIwNWNmNTcxZTk2ZDQyZjc0OGFh
ZmY2ZGYxZWI1XSBtYWM4MDIxMTogZml4IFAyUC1EZXZpY2UgbWFuYWdlbWVudCBmcmFtZSBS
WApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2L2xpbnV4LWRldmVsOmRldmVsLWNhaXJv
LXg4Nl82NC0yMDEzMDYwNzAwMTg6MWI3MzdmODhkYzFiMDVjZjU3MWU5NmQ0MmY3NDhhYWZm
NmRmMWViNTpiaXNlY3QtbW0KCjIwMTMtMDYtMDktMjM6NTI6MjMgMWI3MzdmODhkYzFiMDVj
ZjU3MWU5NmQ0MmY3NDhhYWZmNmRmMWViNSBjb21waWxpbmcKMjM1IHJlYWwgIDE4NjkgdXNl
ciAgMTQwIHN5cyAgODUzLjcxJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2Cgoy
MDEzLTA2LTA5LTIzOjU2OjI4IGRldGVjdGluZyBib290IHN0YXRlIDMuOS4wLXJjMS0wMDE1
MC1nMWI3MzdmOC4uCTIJMwk0Lgk2CTIzLi4uCTI3CTQ0Li4uCTQ2Lgk1NQk1Nwk2NC4JNjcJ
NzEJNzcJODIuCTg1CTg3Lgk5OC4JMTAwCTEwMQkxMDUJMTEyCTEyMgkxMjQJMTI1LgkxMjkJ
MTQyCTE0NAkxNDcJMTU3CTE1OAkxNjIJMTY3CTE4MAkxODIJMTg1CTE4NgkxOTIuCTE5NQkx
OTcJMjAxLgkyMDgJMjEyCTIxMwkyMTQJMjE1CTIyOAkyMzUJMjM2CTIzNwkyNDAJMjUxCTI2
NS4JMjY4CTI3MQkyODAJMzE4CTMyNwkzMzAJMzMxCTM0NQkzNjMJMzc0CTM4NgkzOTAJMzkx
CTM5Mi4uCTQwMQk0MTUJNDE3CTQyMAk0MjMJNDM0CTQ1Ny4JNDYxCTQ2NAk0NjYJNDc4CTQ3
OQk0ODAJNDgyCTQ4NQk0OTgJNTEyLgk1MTMJNTE0CTUyNQk1MzUJNTQxCTU0Mwk1NDUJNTY3
CTU3MQk1NzcJNTg1CTU4OQk1OTgJNjAzCTYwNi4JNjA5CTYxNQk2MzYJNjQxCTY0NQk2NDgJ
NjYwCTY2Mwk2NjcJNjgwLgk2ODQJNjkwCTY5Mwk2OTQJNzAwCTczNwk3NDAJNzQ4CTc1MCBT
VUNDRVNTCgpCaXNlY3Rpbmc6IDE0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSA0IHN0ZXBzKQpbMzFlZDA3ZGMxZTgzYjc5MjZjZThlZTIyMTVlYTIxNTk5
YTIxNTk5MF0gYnJjbWZtYWM6IHJlbW92ZSBpZmlkeCB2YXJpYWJsZSBmcm9tIGJyY21mX2Z3
c19wcm9jZXNzX3NrYigpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvbGludXgtZGV2
ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAxODozMWVkMDdkYzFlODNiNzkyNmNl
OGVlMjIxNWVhMjE1OTlhMjE1OTkwOmJpc2VjdC1tbQoKMjAxMy0wNi0xMC0wMTowNzozMSAz
MWVkMDdkYzFlODNiNzkyNmNlOGVlMjIxNWVhMjE1OTlhMjE1OTkwIGNvbXBpbGluZwoyNDgg
cmVhbCAgMTg1OCB1c2VyICAxMzkgc3lzICA4MDMuMTAlIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWctYzI2LTA2MDYKCjIwMTMtMDYtMTAtMDE6MTE6NTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My45LjAtcmMxLTAwNzc0LWczMWVkMDdkLi4uCTMJOQkxOQkyNQkyNi4JMjkJNDAJNDIJNDMu
CTQ0CTQ4CTUyCTUzLgk2Mgk3MQk3Mi4uCTg5CTk0Li4JOTkJMTAwCTEwNAkxMTEJMTEyCTEy
MAkxMjUJMTI4CTEzNQkxNDQJMTQ4CTE2MQkxNjQJMTY3CTE3MwkxOTUJMjE0LgkyMTUJMjI1
CTIzNC4uLgkyMzgJMjcxCTI3My4uCTI3NgkyODYuCTI4OAkyODkJMzAxCTMyMi4uCTMyOS4u
CTM0MAkzNDIuCTM0NAkzNDkJMzUxCTM1OAkzNjUJMzY3CTM2OC4JMzc0CTM5MC4JMzk0CTM5
Ngk0MTIJNDI2Lgk0MjcJNDI4CTQ0Mgk0NDkJNDU1Li4JNDY1CTQ3NQk0NzguLi4JNDkzCTQ5
Ni4uCTUwMAk1MDkJNTEyLi4JNTE0CTUyNQk1MjguCTUzMAk1MzMJNTQ3CTU1MQk1NTMuLgk1
NjcJNTcyCTU3My4uCTU3NAk1ODcJNTkwCTU5NAk1OTYJNjAwCTYwOAk2MTUJNjE3CTYyMy4J
NjI3CTYzNgk2NDEJNjQ0CTY0OQk2NTcJNjYxCTY2NQk2NjkJNjc3CTY4Mgk2ODUuCTY5MQk2
OTgJNzAxCTcwMwk3MDgJNzE2CTczMwk3MzUuLgk3MzgJNzQzCTc0NAk3NDYJNzQ5Li4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDEbWzBt
Ci4uCTc1MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCls2ZTNhYjU1NDNiZWQ5ZGZmYjdkMWE2NDA0
YzM3ODIyODRhNDMyYTcwXSBjZmc4MDIxMTogaW52ZXJ0IFAyUC1EZXZpY2UgdnMuIG5ldGRl
diBjaGVjayBvcmRlcmluZwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2L2xpbnV4LWRl
dmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYwNzAwMTg6NmUzYWI1NTQzYmVkOWRmZmI3
ZDFhNjQwNGMzNzgyMjg0YTQzMmE3MDpiaXNlY3QtbW0KCjIwMTMtMDYtMTAtMDU6MDY6Mjgg
NmUzYWI1NTQzYmVkOWRmZmI3ZDFhNjQwNGMzNzgyMjg0YTQzMmE3MCBjb21waWxpbmcKMjg3
IHJlYWwgIDE3NDggdXNlciAgMTM0IHN5cyAgNjU0LjgwJSBjcHUgCXg4Nl82NC1yYW5kY29u
ZmlnLWMyNi0wNjA2CgoyMDEzLTA2LTEwLTA1OjExOjI1IGRldGVjdGluZyBib290IHN0YXRl
IDMuOS4wLXJjMS0wMDgxMC1nNmUzYWI1NS4uCTEJMgk0CTYJNwkxMQkxNAkxNQkxOQkzNAk0
Nwk1OAk2Mgk3Mgk3NAk3OAk4MQk4OQk5NQkxMDAJMTA5CTEyMQkxMzEJMTM1CTE0MQkxNTAJ
MTUyCTE1My4JMTU3CTE2MwkxNjkJMTczCTE3NgkxODMJMTg4CTE5NgkyMDAJMjA2CTIxOAky
MjUJMjMzCTI0MQkyNDMJMjUzCTI1OQkyNjQJMjY2CTI3NwkyOTYJMzA0CTMwOAkzMTQJMzM1
IFRFU1QgRkFJTFVSRQobWzE7MzVtSW5jcmVhc2luZyByZXBlYXQgY291bnQgZnJvbSA3NTAg
dG8gMTY5MBtbMG0KZG1lc2cta3ZtLWtidWlsZC0yMjI0OC0yMDEzMDYxMDA1MzI1MC0zLjku
MC1yYzEtMDA4MTAtZzZlM2FiNTUtMTIKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzliMzgzNjcyNDUyYmIxMDk3
MTI0Yzc2ZmNiNDkwM2UwMDIxZjZiYWZdIGI0MzogdXNlIGJjbWFfcG11X3NwdXJhdm9pZF9w
bGx1cGRhdGUoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2L2xpbnV4LWRldmVsOmRl
dmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYwNzAwMTg6OWIzODM2NzI0NTJiYjEwOTcxMjRjNzZm
Y2I0OTAzZTAwMjFmNmJhZjpiaXNlY3QtbW0KCjIwMTMtMDYtMTAtMDU6Mzk6MjYgOWIzODM2
NzI0NTJiYjEwOTcxMjRjNzZmY2I0OTAzZTAwMjFmNmJhZiBjb21waWxpbmcKMjQ4IHJlYWwg
IDE4NTMgdXNlciAgMTM1IHN5cyAgNzk5Ljk1JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMy
Ni0wNjA2CgoyMDEzLTA2LTEwLTA1OjQzOjQ2IGRldGVjdGluZyBib290IHN0YXRlIDMuOS4w
LXJjMS0wMDc3Ny1nOWIzODM2Ny4uLiBURVNUIEZBSUxVUkUKZG1lc2cta3ZtLWFudC0yNTAy
MS0yMDEzMDYxMDA1NDcxMS0zLjkuMC1yYzEtMDA3NzctZzliMzgzNjctMTMKCkJpc2VjdGlu
ZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVw
KQpbY2M1NTY5ZjYzZWNiODI5NjVmM2ZlMmZkZTVlNjBiZjE2ODlkMTA3YV0gYXRoNWs6IHVz
ZSBtb3JlIGlkaW9tYXRpYyB0cmFjaW5nIGluY2x1ZGUgc3R5bGUKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy1jMjYtMDYwNi9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDcw
MDE4OmNjNTU2OWY2M2VjYjgyOTY1ZjNmZTJmZGU1ZTYwYmYxNjg5ZDEwN2E6YmlzZWN0LW1t
CgoyMDEzLTA2LTEwLTA1OjQ1OjIwIGNjNTU2OWY2M2VjYjgyOTY1ZjNmZTJmZGU1ZTYwYmYx
Njg5ZDEwN2EgY29tcGlsaW5nCjI3NCByZWFsICAxODg3IHVzZXIgIDEzNyBzeXMgIDczNi44
NyUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNgoKMjAxMy0wNi0xMC0wNTo1MTo1
NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC1yYzEtMDA3NzYtZ2NjNTU2OWYuLgk3CTgJ
OQkxMQkxNQkyMwkzNAk0MQk0OAk1Nwk2NAk3Mgk3Nwk3OAk4Mwk5OAkxMTAJMTI0CTEyOQkx
MzQJMTM2CTE1NSBURVNUIEZBSUxVUkUKZG1lc2cta3ZtLWFudC0yNDk0MC0yMDEzMDYxMDA2
MDUyNC0zLjkuMC1yYzEtMDA3NzYtZ2NjNTU2OWYtMTQKCkJpc2VjdGluZzogMCByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKWzhlOGQ0ZmYw
NTE2NzJkNGEyOTM5ZTdkNjkyNWM0YWNkMjM0YjAyMjBdIGJyY204MDIxMTogc2ltcGxpZnkg
bWFrZWZpbGVzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvbGludXgtZGV2ZWw6ZGV2
ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAxODo4ZThkNGZmMDUxNjcyZDRhMjkzOWU3ZDY5
MjVjNGFjZDIzNGIwMjIwOmJpc2VjdC1tbQoKMjAxMy0wNi0xMC0wNjowMzo1OCA4ZThkNGZm
MDUxNjcyZDRhMjkzOWU3ZDY5MjVjNGFjZDIzNGIwMjIwIGNvbXBpbGluZwoyMzYgcmVhbCAg
MTg3MiB1c2VyICAxMzUgc3lzICA4NDkuMjIlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzI2
LTA2MDYKCjIwMTMtMDYtMTAtMDY6MDg6MDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAt
cmMxLTAwNzc1LWc4ZThkNGZmLi4JNwkzMgk0MS4uLi4uLgk0NC4JNTIuLgk1NC4uLgk2MS4u
CTMxMiBURVNUIEZBSUxVUkUKZG1lc2cta3ZtLWFudC0yNTUzOS0yMDEzMDYxMDA2MjIxMC0z
LjkuMC1yYzEtMDA3NzUtZzhlOGQ0ZmYtMTUKCjhlOGQ0ZmYwNTE2NzJkNGEyOTM5ZTdkNjky
NWM0YWNkMjM0YjAyMjAgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDhlOGQ0ZmYw
NTE2NzJkNGEyOTM5ZTdkNjkyNWM0YWNkMjM0YjAyMjAKQXV0aG9yOiBKb2hhbm5lcyBCZXJn
IDxqb2hhbm5lcy5iZXJnQGludGVsLmNvbT4KRGF0ZTogICBUaHUgQXByIDExIDE2OjE1OjI4
IDIwMTMgKzAyMDAKCiAgICBicmNtODAyMTE6IHNpbXBsaWZ5IG1ha2VmaWxlcwogICAgCiAg
ICBUaGlzIGNhbWUgdXAgZHVyaW5nIG15IGJhY2twb3J0aW5nIHdvcmsgYnV0IGl0IHNlZW1z
CiAgICBwZXJmZWN0bHkgYXBwcm9wcmlhdGUgZm9yIHRoZSBrZXJuZWwgYXMgd2VsbC4KICAg
IAogICAgU2lnbmVkLW9mZi1ieTogSm9oYW5uZXMgQmVyZyA8am9oYW5uZXMuYmVyZ0BpbnRl
bC5jb20+CiAgICBBY2tlZC1ieTogQXJlbmQgdmFuIFNwcmllbCA8YXJlbmRAYnJvYWRjb20u
Y29tPgogICAgU2lnbmVkLW9mZi1ieTogSm9obiBXLiBMaW52aWxsZSA8bGludmlsbGVAdHV4
ZHJpdmVyLmNvbT4KCjowNDAwMDAgMDQwMDAwIGM0ZDI1YTZkNmQ4MjlhNGY0MzQwNTdmMGNl
YzhkODYwYjE5ZTAyMDkgOGUxYzUxMDk3NTdmNGE0YjYyNTBhNDU2MTUxZmZhNzM5Mzk4ODgx
MyBNCWRyaXZlcnMKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi9saW51eC1kZXZlbDpkZXZl
bC1jYWlyby14ODZfNjQtMjAxMzA2MDcwMDE4OjMxZWQwN2RjMWU4M2I3OTI2Y2U4ZWUyMjE1
ZWEyMTU5OWEyMTU5OTA6YmlzZWN0LW1tCgoyMDEzLTA2LTEwLTA2OjIwOjEyIDMxZWQwN2Rj
MWU4M2I3OTI2Y2U4ZWUyMjE1ZWEyMTU5OWEyMTU5OTAgcmV1c2UgL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jMjYtMDYwNi8zMWVkMDdkYzFlODNiNzkyNmNlOGVlMjIxNWVhMjE1OTlh
MjE1OTkwL3ZtbGludXotMy45LjAtcmMxLTAwNzc0LWczMWVkMDdkCgoyMDEzLTA2LTEwLTA2
OjIwOjE5IGRldGVjdGluZyBib290IHN0YXRlIC4uCTc1NAk3NjIJNzcyCTc3Nwk3ODEJNzg0
CTgwMgk4MDkJODEzCTgxOQk4MjEJODI0CTgzMwk4NDcJODYwCTg2NAk4NjYJODczCTg3OS4J
ODk5CTkwMQk5MDQJOTExCTk0OSBURVNUIEZBSUxVUkUKZG1lc2cta3ZtLWFudC0yNTE0My0y
MDEzMDYxMDA2MzUzMi0zLjkuMC1yYzEtMDA3NzQtZzMxZWQwN2QtMTEKChtbMTszNW1iYWQg
YmlzZWN0LCByZXRyeSB3aXRoIGluY3JlYXNlZCByZXBlYXQgY291bnQgNTA3MBtbMG0KYmlz
ZWN0OiBza2lwIDI5ZWI3NzgyNWNjN2RhOGQ0NWI2NDJkZTJkZTNkNDIzZGM4YTM2M2Y6IG5v
dCBhIGdvb2QgbWVyZ2UgYmFzZQpnaXQgY2hlY2tvdXQgdjMuOQpQcmV2aW91cyBIRUFEIHBv
c2l0aW9uIHdhcyA2NGYwMzg5Li4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ25m
Yy1maXhlcy9tYXN0ZXInIGludG8gZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAxOApI
RUFEIGlzIG5vdyBhdCBjMWJlNWE1Li4uIExpbnV4IDMuOQpscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvbGludXgtZGV2ZWw6
ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAxODpjMWJlNWE1YjFiMzU1ZDQwZTZjZjc5
Y2M5NzllYjY2ZGFmYTI0YWQxOmJpc2VjdC1tbQoKMjAxMy0wNi0xMC0wNjozNDowOCBjMWJl
NWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxIHJldXNlIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzI2LTA2MDYvYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2
NmRhZmEyNGFkMS92bWxpbnV6LTMuOS4wCgoyMDEzLTA2LTEwLTA2OjM0OjE1IGRldGVjdGlu
ZyBib290IHN0YXRlIC4uCTM1MwkzNjEJMzY3CTM3NQkzODAJMzg2CTM5MQkzOTUJNDAzCTQy
Ngk0MzIJNDM0Lgk0MzgJNDQ3CTQ1MQk0NTUJNDYwCTQ2Nwk0NzQJNDkxLi4JNDk5CTUxNAk1
MjQJNTM1CTU0MAk1NTAJNTU3CTU3MQk1NzUJNTgxCTU4Mwk1ODQJNTg5CTYwNQk2MDgJNjA5
CTYxNQk2MjUJNjMzCTY0MQk2NDkJNjU1CTY2MAk2NzIJNjg2CTY5MAk3MDMJNzExCTcyMAk3
NDgJNzc1CTc4Ngk3OTMJODA4CTgyOQk4NTIJODYyCTg2NAk4NjgJODc1CTg5Mgk4OTkJOTA0
CTkwNwk5MDgJOTE2CTkyMwk5MjYJOTM1CTkzNgk5NDIJOTUxCTk2Mgk5NjkJOTc2CTk4NQk5
ODkJOTk3CTEwMDIJMTAxMwkxMDIxCTEwMjIJMTAyNwkxMDM5CTEwNDkJMTA2NAkxMDY2CTEw
NjcJMTA3MAkxMDgzCTEwOTYJMTEwMgkxMTAzCTExMDQJMTEwNwkxMTM1CTExNDAJMTE0My4J
MTE1NgkxMTg0CTEyMDAJMTIwOQkxMjEyCTEyMTgJMTIzMAkxMjMzCTEyNDcJMTI1NgkxMjY0
CTEyODMJMTI5MAkxMzA1CTEzMTMJMTMxNwkxMzIwCTEzMzAJMTMzOQkxMzQxCTEzNTQJMTM2
NwkxMzk0CTE0MDcJMTQyMQkxNDQ2CTE0NjIJMTQ4NAkxNDkxCTE1MDkJMTUxMgkxNTE5CTE1
MjkJMTU1NQkxNTg4CTE2MDgJMTYyMwkxNjQ2CTE2NTgJMTY2NAkxNjY4CTE2NzIJMTY3Nwkx
Njg0CTE2ODcJMTcwMgkxNzIyCTE3MzYJMTc0NwkxNzUxCTE3NTcJMTc2MQkxNzY1CTE3NzMJ
MTgwNQkxODMxCTE4NjIJMTg3NAkxODgyCTE4OTYJMTkxMQkxOTE2CTE5MTkJMTkyMwkxOTY1
CTE5OTAJMjAxMgkyMDMyCTIwMzYJMjA0MAkyMDYxCTIwNjMJMjA3MQkyMDc3CTIxMDkJMjE2
NAkyMTc2CTIxOTIJMjE5NAkyMjIwCTIyNDUJMjI1NQkyMjYzCTIyNzIJMjI5MgkyMzEyCTIz
MjUJMjMzMwkyMzQxCTIzNjgJMjM5NwkyNDI0CTI0MjcJMjQ1NwkyNDg0CTI0OTgJMjUxNgky
NTI0CTI1MzAJMjUzMwkyNTU4CTI1NzcuCTI1OTkJMjYxNwkyNjIxCTI2NDgJMjY2MQkyNjY1
CTI2NzEJMjY4NAkyNzAzCTI3MzIJMjc1NQkyNzY1CTI3NzIJMjc3OAkyNzg4CTI4MDQJMjgx
MgkyODIzCTI4MzUJMjg0NgkyODY4CTI4NzUJMjkxMwkyOTQyCTI5NzUJMzAwMgkzMDUzCTMw
ODMJMzEyNwkzMTg0CTMyNjEJMzMzMgkzMzkyCTM0NzAJMzYyOAkzNzg5CTM5MDMJNDAyOQk0
MDY4CTQyMTQJNDQyMAk0NTQxCTQ3MTAJNDg1MQk1MDE2CTUwNjYuLgk1MDY4Li4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDIbWzBtCi4u
Li4JNTA3MCBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IHYzLjkKZ2l0IGJpc2VjdCBz
dGFydCA2NGYwMzg5ZjUwZjM1NzYzNjBlNWIyODcwZTViMDljOGM1MDBhMzczIHYzLjkgLS0K
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYzFiZTVhNS4uLiBMaW51eCAzLjkKSEVBRCBp
cyBub3cgYXQgM2MwZWVlMy4uLiBMaW51eCAyLjYuMzcKQmlzZWN0aW5nOiA2OTc3IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMyBzdGVwcykKWzczMjg3
YTQzY2M3OWNhMDY2MjlhODhkMWExOTljZDI4M2Y0MjQ1NmFdIE1lcmdlIGdpdDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kYXZlbS9uZXQtbmV4dApnaXQg
YmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYv
bGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAxODo3MzI4N2E0M2Nj
NzljYTA2NjI5YTg4ZDFhMTk5Y2QyODNmNDI0NTZhOmJpc2VjdC1tbQogVEVTVCBGQUlMVVJF
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvNzMyODdhNDNjYzc5Y2EwNjYy
OWE4OGQxYTE5OWNkMjgzZjQyNDU2YS9kbWVzZy1rdm0tYW50LTI1MDIxLTIwMTMwNjA3MTYx
MzQwLTMuOS4wLTAyMDAxLWc3MzI4N2E0LTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MjYtMDYwNi83MzI4N2E0M2NjNzljYTA2NjI5YTg4ZDFhMTk5Y2QyODNmNDI0NTZhL2RtZXNn
LWt2bS1hbnQtMjUwMjEtMjAxMzA2MDcxNjE4MDMtMy45LjAtMDIwMDEtZzczMjg3YTQtMgoK
QmlzZWN0aW5nOiAzNjAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxMiBzdGVwcykKWzVkNDM0ZmNiMjU1ZGVjOTkxODlmMWM1OGEwNmU0ZjU2ZTEyYmY3
N2RdIE1lcmdlIGJyYW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvamlrb3MvdHJpdmlhbApydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLWMyNi0wNjA2L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYwNzAw
MTg6NWQ0MzRmY2IyNTVkZWM5OTE4OWYxYzU4YTA2ZTRmNTZlMTJiZjc3ZDpiaXNlY3QtbW0K
CjIwMTMtMDYtMTAtMTE6MTY6MTEgNWQ0MzRmY2IyNTVkZWM5OTE4OWYxYzU4YTA2ZTRmNTZl
MTJiZjc3ZCByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2LzVkNDM0
ZmNiMjU1ZGVjOTkxODlmMWM1OGEwNmU0ZjU2ZTEyYmY3N2Qvdm1saW51ei0zLjkuMC0wMzQx
Ni1nNWQ0MzRmYwobWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZTogcmVxdWVzdGVkIDUwNzAsIGxp
bWl0IHRvIDUwMDAbWzBtCgoyMDEzLTA2LTEwLTExOjE2OjE4IGRldGVjdGluZyBib290IHN0
YXRlIC4JMQkyCTMJNQkyNwk3NQkxNTAJMTk1CTE5OAkzNzIJMzgwCTM5OQk0MDgJNDk5CTU0
NAk1OTUJNjA2Lgk2MTAJNjE2Lgk2MjcJNjM4CTY1MQk2ODMJNzA0CTcyNgk3NTgJNzg2CTgw
NAk4NTEuCTg2OAk5MDQJOTIwCTkyMQk5NDIuCTk2MAk5NjUJOTcxCTEwMDkJMTAzNgkxMDY0
CTExMTIJMTEyOQkxMTM4CTExNDAJMTE0NQkxMTUxCTExNjcJMTE3OQkxMTgxCTExODYJMTE5
NwkxMjcxCTEyOTYJMTM2MAkxNDU0Li4JMTQ1OAkxNDcxCTE0NzkJMTQ4MAkxNDg3CTE0OTgJ
MTUwMwkxNTEyCTE1MzkJMTU0MgkxNTk3CTE2MTMJMTY3NQkxNzA4CTE3MDkJMTcxNQkxNzI5
CTE3NDcJMTc1NwkxNzc1CTE3OTUJMTgwOAkxODM4CTE4NjQJMTg3OQkxOTA2CTE5MzcJMTk1
NAkxOTk1CTIwMTAJMjAyNAkyMDk3CTIxNDUJMjE2NgkyMTg5CTIxOTQJMjE5OS4JMjIxMAky
MjUxCTIyNzYJMjI5OAkyMzM5CTI0MDEJMjQxMgkyNDQ4CTI0OTEJMjUxOQkyNTQ5CTI1NzgJ
MjY2NgkyNjg0CTI3MDAJMjczMQkyOTI1CTI5MzUJMzIwMwkzMzEyCTMzNTYJMzQ5NwkzNTI2
CTM1NDIJMzgxMwkzOTczCTM5OTgJNDA5OAk0MTg0CTQxOTYJNDM3OQk0NjA0CTQ2MTcJNDYx
OQk0ODU1CTQ4OTAJNDk2OQk0OTkzCTQ5OTYJNDk5Ny4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA3MxtbMG0KLi4JNTAyNAk1MDU1CTUw
NzAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxODAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzkxYmMwMzNjNGQwMTY1NmUzZDhlNDVhMTNm
ZDU4OTI0YTMwOTk2OTNdIGJyaWRnZTogYXZvaWQgT09QUyBpZiByb290IHBvcnQgbm90IGZv
dW5kCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fp
cm8teDg2XzY0LTIwMTMwNjA3MDAxODo5MWJjMDMzYzRkMDE2NTZlM2Q4ZTQ1YTEzZmQ1ODky
NGEzMDk5NjkzOmJpc2VjdC1tbQogVEVTVCBGQUlMVVJFCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYzI2LTA2MDYvOTFiYzAzM2M0ZDAxNjU2ZTNkOGU0NWExM2ZkNTg5MjRhMzA5OTY5
My9kbWVzZy1rdm0tYW50LTI1NTM5LTIwMTMwNjA4MDIyMDQ2LTMuOS4wLXJjOC0wMTgwMC1n
OTFiYzAzMy00CgpCaXNlY3Rpbmc6IDk1MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCls5NTNjOTZlMGQ4NTYxNWQxYWIxZjEwMGU1MjVk
Mzc2MDUzMjk0ZGMyXSB0ZzM6IFVzZSBib29sIG5vdCBpbnQKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1jMjYtMDYwNi9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDcwMDE4
Ojk1M2M5NmUwZDg1NjE1ZDFhYjFmMTAwZTUyNWQzNzYwNTMyOTRkYzI6YmlzZWN0LW1tCgoy
MDEzLTA2LTEwLTE0OjU5OjMzIDk1M2M5NmUwZDg1NjE1ZDFhYjFmMTAwZTUyNWQzNzYwNTMy
OTRkYzIgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi85NTNjOTZl
MGQ4NTYxNWQxYWIxZjEwMGU1MjVkMzc2MDUzMjk0ZGMyL3ZtbGludXotMy45LjAtcmM1LTAx
MTM0LWc5NTNjOTZlCgoyMDEzLTA2LTEwLTE0OjU5OjM4IGRldGVjdGluZyBib290IHN0YXRl
IC4uLgk2ODYJNjkzCTY5NC4uLi4JNjk1Lgk3MDIJNzA1CTcxNQk3NjkJNzkyCTg0OQk4NzMJ
ODc5CTg4Mgk4OTQJOTE2CTkyMgk5NDUJOTU0CTk2NQk5ODAJMTAwMAkxMDUxCTEwNTUJMTA2
OQkxMTA5CTExNTQJMTE4MgkxMTk0CTExOTYJMTIwNQkxMjE3CTEyNDEJMTI0OAkxMjU2CTEy
NzUJMTMxOQkxNDM4CTE0NTMJMTQ3NQkxNDc3CTE0ODEJMTQ4NAkxNDkyCTE1MTUJMTUzOQkx
NTQxCTE1NjEJMTU5MAkxNjE4CTE2NDAJMTY2NgkxNjc0CTE2NzUJMTY4MwkxNzExCTE3MjkJ
MTc0MgkxNzQzCTE3NjEJMTgzNQkxODgyCTE4OTUJMTkwMwkxOTEwLgkxOTE0CTE5NDkJMTk2
NwkxOTkyCTIwMDEJMjAwOAkyMDM1CTIwODMJMjA4NAkyMDg1CTIwODkJMjEwMQkyMTM0CTIx
NDMJMjE0OQkyMTUwCTIxNTMuLgkyMTU1CTIxNjMJMjE3OAkyMjAyCTIyMDYJMjIxMgkyMjE2
CTIyMTgJMjIxOQkyMjIxCTIyMjYJMjIzMAkyMjQyCTIyNDcJMjI2NAkyMjc5CTIyODEJMjI4
OAkyMjg5CTIzMDEJMjMxMQkyMzI1CTIzMzcJMjM0MgkyMzUxCTIzNjkJMjM4MgkyMzgzCTI0
MDAJMjQwOAkyNDE0CTI0MzAJMjQzNgkyNDM4CTI0NDIJMjQ1NQkyNDYzCTI0NjQJMjQ2OAky
NDg3CTI1MDUJMjUxMAkyNTIxCTI1MzkJMjU3NgkyNTg3CTI2NDAJMjY3NgkyNjk0CTI3MzkJ
Mjc3NgkyODA4CTI4NTcJMjg3OAkyODkxCTI5MDcJMjkxMAkyOTM4CTI5NTgJMjk2MQkyOTY2
CTI5NzkJMjk5MQkzMDA5CTMwMjYJMzAzMgkzMDM3CTMwNTMJMzA1OQkzMDgzCTMwOTYJMzEw
MAkzMTEwCTMxMTMJMzEyOQkzMTQ4CTMxNjAJMzE3MAkzMTc3CTMxODkJMzIwMgkzMjExCTMy
MjYJMzIzNAkzMjM4CTMyNDYJMzI1NgkzMjY4CTMyNzcJMzI4MgkzMjk1CTMzMDUJMzMxNgkz
MzI0CTMzNDMuCTMzNDYJMzM1NwkzMzczLgkzMzc3CTMzODYJMzM5NQkzMzk2CTM0MDgJMzQw
OQkzNDIyCTM0MzUJMzQ0MwkzNDUzCTM0NjQJMzQ2OQkzNTAxCTM1MzEJMzU0NAkzNTY5CTM1
ODIJMzU5OQkzNjI5CTM2NDcJMzY2MwkzNjcwCTM3MTMJMzczMAkzNzU3CTM3NzAJMzc4MAkz
ODAwCTM4MDIJMzgwNgkzODIwCTM4MzQJMzg1NwkzODY3CTM4ODkJMzkxNQkzOTI1CTM5NDYJ
Mzk1OAkzOTYyCTM5OTAJNDAwNgk0MDEwCTQwMTgJNDAzMwk0MDM2CTQwNTUJNDA3My4JNDA5
Mgk0MTAxCTQxMzIJNDE1Nwk0MTg1CTQxOTQJNDIyMgk0MjMxCTQyNTAJNDI4MQk0MzA1CTQz
MjAJNDMyMgk0MzI4CTQzMzQJNDM0NAk0MzUyCTQzNTYJNDM1Nwk0MzY5CTQzNzcJNDM4OQk0
NDAyCTQ0MzYJNDQzOQk0NDU2CTQ0NjIJNDQ2Mwk0NDcyCTQ0ODUuCTQ0ODkJNDUwMgk0NTA2
CTQ1MTIJNDUyMC4JNDUyMQk0NTI2CTQ1MzMJNDU0Ngk0NTQ5Lgk0NTUyCTQ1NjAJNDU3MQk0
NTc3CTQ1OTEuCTQ1OTUJNDYwMQk0NjA0CTQ2MDUJNDYxMi4JNDYyMAk0NjI0CTQ2MjUuCTQ2
MjYJNDYzMgk0NjM1CTQ2NDIJNDY1MQk0NjUzCTQ2NTQJNDY2MS4JNDY2Nwk0NjczCTQ2NzgJ
NDY3OQk0Njg2CTQ2OTcJNDcwNQk0NzA2CTQ3MjMJNDcyNgk0NzMyCTQ3MzcJNDc1NQk0NzU2
CTQ3NzMJNDc3NAk0Nzg0CTQ3OTMJNDgwMAk0ODA4CTQ4MjQJNDgzNgk0ODUzCTQ4NjEJNDg3
NAk0ODg1CTQ4OTkJNDkwNAk0OTA3CTQ5MTQJNDkyMQk0OTIzCTQ5MjQJNDkzMQk0OTMzLi4J
NDkzOS4JNDk1MAk0OTU2CTQ5NTkJNDk2Ngk0OTY3CTQ5NzAJNDk3My4JNDk4MQk1MDA1CTUw
MTEuCTUwMTYJNTAxOAk1MDI1CTUwMjgJNTAzMQk1MDM0CTUwMzUJNTAzNgk1MDQ4CTUwNTAJ
NTA1Mgk1MDU5CTUwNjQuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFk
ZF90b19ydW5fcXVldWUgNhtbMG0KLi4uCTUwNjUJNTA2Ny4JNTA2OAk1MDcwIFNVQ0NFU1MK
CkJpc2VjdGluZzogNDc2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA5IHN0ZXBzKQpbNmQ0MjFlNTRjMjI3Nzk5MGYzYjBlM2RkOTJlNDQ2ODAwYzkwZWZh
M10gYnJjbWZtYWM6IHVzZSBsb2NrIGluIGJyY21mX2Z3c19kZWxfaW50ZXJmYWNlKCkKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21l
L3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZf
NjQtMjAxMzA2MDcwMDE4OjZkNDIxZTU0YzIyNzc5OTBmM2IwZTNkZDkyZTQ0NjgwMGM5MGVm
YTM6YmlzZWN0LW1tCiBURVNUIEZBSUxVUkUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MjYtMDYwNi82ZDQyMWU1NGMyMjc3OTkwZjNiMGUzZGQ5MmU0NDY4MDBjOTBlZmEzL2RtZXNn
LWt2bS1hbnQtMjQ5NDAtMjAxMzA2MDgxNTQ0NDktMy45LjAtcmMxLTAwOTMyLWc2ZDQyMWU1
LTYKCkJpc2VjdGluZzogMjM3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSA4IHN0ZXBzKQpbNzM1MGU2Y2YzNjBkMzIyMDZjYmU0ZTNkMzRmYjQ4YWI4NjNi
ZGIxNF0gQmx1ZXRvb3RoOiBoaWRwOiBtZXJnZSBoaWRwX3Byb2Nlc3Nfe2N0cmwsaW50cn1f
dHJhbnNtaXQoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2L2xpbnV4LWRldmVsOmRl
dmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYwNzAwMTg6NzM1MGU2Y2YzNjBkMzIyMDZjYmU0ZTNk
MzRmYjQ4YWI4NjNiZGIxNDpiaXNlY3QtbW0KCjIwMTMtMDYtMTAtMjA6NDA6NTUgNzM1MGU2
Y2YzNjBkMzIyMDZjYmU0ZTNkMzRmYjQ4YWI4NjNiZGIxNCByZXVzZSAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMyNi0wNjA2LzczNTBlNmNmMzYwZDMyMjA2Y2JlNGUzZDM0ZmI0OGFi
ODYzYmRiMTQvdm1saW51ei0zLjkuMC1yYzEtMDA2NzMtZzczNTBlNmMKCjIwMTMtMDYtMTAt
MjA6NDE6MDAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JNzUxLgk3NTIJNzUzLgk3NTUuCTc1
Ni4JNzU5CTc2NQk3NjcJNzcwCTc4MAk3ODYJNzg4CTc5Mwk3OTguCTgwMQk4MDYJODEwCTgy
OAk4MzQJODQyCTg1Mwk4NTgJODYzCTg2Ngk4NzAJODc2CTg3OQk4ODQJODk1CTkwNwk5MTUJ
OTIyLgk5MjcJOTM3Lgk5NDQJOTY0CTk2NQk5NzAJOTc1CTk4MAk5ODIJOTg3Lgk5OTQJOTk3
CTEwMDgJMTAyOAkxMDM1CTEwMzYJMTA0My4JMTA0OAkxMDU3CTEwNzAJMTA3MwkxMDg0CTEx
MDEJMTExMgkxMTE2CTExMTguCTExMjUJMTEyNi4JMTEyNwkxMTMxCTExNDkJMTE1NAkxMTU2
CTExNjQJMTE3MQkxMTgxCTExODMJMTE4NAkxMTg3LgkxMTg4CTExOTYJMTIwMgkxMjA2CTEy
MTQJMTIyMgkxMjMwLgkxMjM3CTEyNDIJMTI1NgkxMjYzCTEyNjUuCTEyNjYJMTI3OAkxMjg1
CTEyODkJMTI5NAkxMzAzCTEzMTIJMTMxNC4uCTEzMTUuCTEzMTcJMTMxOQkxMzIxLgkxMzI1
CTEzMjcJMTMyOQkxMzMyCTEzMzYJMTM0MwkxMzQ3CTEzNTMJMTM2MwkxMzY5CTEzNzAJMTM3
OQkxMzg0CTEzODYJMTQwMQkxNDE0CTE0MjAJMTQyOAkxNDM0CTE0MzkJMTQ0NQkxNDQ4CTE0
NDkJMTQ1NgkxNDYxCTE0NzEJMTQ3NAkxNDg2CTE0OTEJMTUwMAkxNTA0CTE1MDUJMTUwOAkx
NTE2CTE1MjQJMTUzMAkxNTMyCTE1NDAJMTU1MwkxNTU4CTE1NjIJMTU2MwkxNTczCTE1ODkJ
MTU5NQkxNTk2CTE1OTgJMTYwMgkxNjExCTE2MjYJMTYzNAkxNjQ0CTE2NTIJMTY2NwkxNjc3
CTE2OTAJMTY5NgkxNzAzCTE3MTQJMTcyMQkxNzI4CTE3MzQJMTc0MAkxNzQ4CTE3NjEJMTc3
OQkxNzg0CTE3OTAJMTgwNQkxODI3CTE4NDQJMTg1MQkxODYwCTE4NjcJMTg3MwkxODg3CTE4
OTMJMTkwMwkxOTA2CTE5MTUJMTkyOQkxOTQxCTE5NTEJMTk1MwkxOTU5CTE5NjcJMTk5Ngky
MDAxCTIwMDUJMjAwOAkyMDI0CTIwNDcJMjA1MwkyMDU0LgkyMDU4CTIwODYJMjA5MQkyMDk2
CTIwOTgJMjEwOAkyMTA5CTIxMTEJMjExMwkyMTE2CTIxMjAJMjEyOAkyMTM0CTIxMzcJMjEz
OQkyMTQ2CTIxNTAJMjE1MQkyMTUyCTIxNjEuCTIxNjcJMjE3NAkyMTc3CTIxNzgJMjE4Mwky
MTkxCTIyMDIJMjIwOQkyMjE5CTIyMjcJMjIzNAkyMjQwCTIyNTQJMjI3Ny4JMjI5NQkyMzAw
CTIzMDkJMjMxNgkyMzE4CTIzMTkuCTIzMjMJMjMyNgkyMzI3LgkyMzI4LgkyMzMwCTIzMzQu
LgkyMzM2CTIzMzcJMjMzOAkyMzQzCTIzNTAJMjM1MgkyMzYyCTIzNjcJMjM2OQkyMzcyCTIz
NzYJMjM4MQkyMzgzCTIzODUJMjM4NgkyMzg5CTIzOTMJMjM5NgkyMzk3CTI0MDIJMjQwOQky
NDEyCTI0MTQJMjQxOAkyNDIwCTI0MjMJMjQzMAkyNDM3CTI0NDAJMjQ0My4JMjQ0NAkyNDU3
CTI0NTkuCTI0NjIJMjQ2NwkyNDczCTI0ODYJMjQ5MC4JMjQ5MgkyNTAxCTI1MDkJMjUxMAky
NTE0CTI1MjAJMjUyNgkyNTM4CTI1NDMJMjU0NgkyNTQ3CTI1NTQJMjU2MAkyNTcwCTI1NzQu
CTI1NzgJMjU3OQkyNTgwCTI1ODEJMjU4NC4JMjU4NQkyNTg5CTI1OTQJMjYwNQkyNjE5CTI2
MjcJMjYzMgkyNjUwCTI2NTMJMjY1NAkyNjY1CTI2NzIJMjY3NwkyNjg4CTI2OTEJMjY5Mgky
NzAyLgkyNzA5CTI3MTcJMjcyMwkyNzI0CTI3MjkJMjczOAkyNzQ0CTI3NDgJMjc1NC4JMjc1
OAkyNzYzCTI3NjYJMjc3MAkyNzcxCTI3NzcJMjc5MgkyODAzLgkyODA0CTI4MTEJMjgxNwky
ODIwLgkyODI4CTI4MzkJMjg0OAkyODQ5CTI4NTIJMjg1NgkyODYzCTI4NjcJMjg3MQkyODc0
CTI4NzgJMjg3OQkyODgwCTI4ODMJMjg4NgkyODg4CTI4OTIJMjg5Ni4uCTI5MDIJMjkwNQky
OTA4CTI5MTUJMjkxOAkyOTIxCTI5MjcJMjkzNQkyOTM2CTI5MzcuLi4uLi4JMjk1NQkyOTU2
Li4uCTI5NTkJMjk2MS4JMjk2NC4uCTI5NjUJMjk2Ni4uCTI5NjcJMjk3MC4uLgkyOTcyCTI5
NzMuLi4uCTI5NzQuLi4JMjk3Ni4uCTI5NzcJMjk3OC4JMjk4NAkyOTg4CTI5OTcJMzAwMgkz
MDAzCTMwMDcJMzAxNAkzMDE2Li4JMzAxNwkzMDE5CTMwMjAuLgkzMDIxCTMwMjIJMzAyMy4u
CTMwMjQJMzAyNS4uLgkzMDI3LgkzMDI5LgkzMDMyCTMwMzMJMzAzNAkzMDQxCTMwNDMuLgkz
MDQ0CTMwNDgJMzA1MS4uCTMwNTUJMzA2MAkzMDYzLgkzMDY0CTMwNjcJMzA2OAkzMDY5CTMw
NzEJMzA3OC4JMzA3OS4uLgkzMDgwCTMwODEuCTMwODMJMzA4NQkzMDkwCTMwOTEJMzA5Ni4J
MzA5NwkzMTAzCTMxMDQJMzEwNgkzMTA5CTMxMTQJMzExNwkzMTIyLgkzMTI0CTMxMjYJMzEy
OC4JMzEyOS4uCTMxMzAJMzEzMS4uLgkzMTMzCTMxMzQuLgkzMTM1CTMxMzYuLgkzMTQwCTMx
NDQJMzE0Ni4uCTMxNTEuCTMxNTIuCTMxNTMuCTMxNTUJMzE1NgkzMTYwCTMxNjEJMzE2Mwkz
MTY2CTMxNjkJMzE3MgkzMTc3CTMxNzgJMzE4MQkzMTgzCTMxODcJMzE5MgkzMTk0CTMyMDIJ
MzIwOAkzMjEzLi4JMzIxNAkzMjE2CTMyMjIJMzIyMy4uCTMyMjYJMzIyOAkzMjMxCTMyMzYJ
MzI0MwkzMjQ2CTMyNTIJMzI1NQkzMjU4Li4JMzI1OS4uLgkzMjYxCTMyNjIJMzI2NC4uCTMy
NjUuCTMyNjYJMzI2OQkzMjcxLi4JMzI3MgkzMjc3CTMyNzgJMzI3OQkzMjg0LgkzMjg2CTMy
OTAJMzI5MS4JMzI5MwkzMjk5CTMzMDAuLi4JMzMwMwkzMzA1CTMzMDcJMzMwOQkzMzEwCTMz
MTEJMzMxNAkzMzE1CTMzMTYJMzMxOAkzMzE5CTMzMjMJMzMzMwkzMzM1CTMzNDIJMzM0OAkz
MzU1CTMzNjAJMzM2NgkzMzY3CTMzNjkJMzM3NAkzMzgwCTMzOTUJMzQwMAkzNDAyCTM0MDYJ
MzQxMgkzNDE0CTM0MjAuCTM0MjUJMzQyOQkzNDMwLgkzNDM0CTM0MzcJMzQ0OAkzNDU3CTM0
NjUJMzQ2OQkzNDcwCTM0NzYJMzQ4MgkzNDg2CTM0ODkJMzQ5NQkzNDk5CTM1MTMJMzUxOQkz
NTIxLgkzNTI0CTM1MjcJMzUzMAkzNTMyCTM1MzYJMzU0OAkzNTU2CTM1NTkJMzU2MQkzNTY0
CTM1NjUJMzU3MwkzNTc1CTM1NzYJMzU4MAkzNTg4CTM1OTYJMzU5OAkzNTk5CTM2MDAJMzYw
NAkzNjEwCTM2MTUJMzYyMQkzNjIyCTM2MjgJMzYzNgkzNjQwCTM2NDcJMzY0OQkzNjUwCTM2
NTQJMzY1NwkzNjYzCTM2NjkJMzY3MwkzNjc2CTM2ODEJMzY4MwkzNjg3CTM2OTAJMzcwNQkz
NzExCTM3MTMJMzcxNQkzNzE4CTM3MjQJMzcyNQkzNzI4CTM3MjkJMzczMQkzNzM2CTM3NDUJ
Mzc2MAkzNzY3CTM3NzIJMzc4NAkzNzg2CTM3OTIJMzc5NAkzNzk1CTM3OTkuCTM4MDQJMzgw
OQkzODEzCTM4MTkJMzgyMQkzODI2CTM4NDEJMzg0MgkzODQ1CTM4NDgJMzg1MQkzODY2CTM4
NjkJMzg4MAkzODg0CTM4OTkJMzkwNgkzOTA3CTM5MTQJMzkxNgkzOTI0CTM5MzcJMzk0MQkz
OTUwCTM5NTkJMzk3MAkzOTg2CTM5OTQJMzk5OQk0MDA1CTQwMTIJNDAxOAk0MDIzCTQwMjcJ
NDAzOAk0MDQ2CTQwNTAJNDA1NQk0MDU4CTQwNjEJNDA2OAk0MDc0Lgk0MDc1Lgk0MDgyCTQw
OTAuCTQwOTEuCTQwOTMJNDA5Nwk0MTAwCTQxMDQJNDEwNwk0MTEwCTQxMTUuLi4JNDExNi4J
NDExNy4uCTQxMjMJNDEyOC4uCTQxMjkJNDEzNQk0MTM3Lgk0MTQwLgk0MTQ1CTQxNDYuCTQx
NDcJNDE0OQk0MTUyLgk0MTUzCTQxNTQJNDE1OAk0MTU5CTQxNjEuCTQxNzIuCTQxNzMJNDE3
NQk0MTc2CTQxNzkJNDE4Ngk0MTg4CTQxOTEuLgk0MTk5CTQyMDQJNDIwOQk0MjEwCTQyMjIJ
NDIyNgk0MjI3CTQyMzAJNDIzMgk0MjM5CTQyNDYJNDI1MAk0MjU0Lgk0MjYyCTQyNjQJNDI2
OQk0MjcwCTQyNzEJNDI3NQk0Mjc4CTQyODEJNDI4Mwk0Mjg0CTQyODUJNDI4OAk0Mjg5CTQy
OTEuCTQyOTcJNDMwNi4JNDMyMAk0MzI1CTQzMzEJNDM1MQk0MzY0CTQzODIJNDQyNAk0NDc2
CTQ1MTcJNDU1MAk0NTc5CTQ1ODQJNDY2OQk0NzA0CTQ3MzUJNDc4MAk0ODIxCTQ4NTMJNDkx
Nwk0OTY0CTUwMDUJNTA0NAk1MDYyLi4JNTA2Mwk1MDY0Li4uLgk1MDY1Li4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDUbWzBtCi4uCTUw
NjYJNTA3MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDExOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKW2RkZjE5ZDIwNmZlNGJhNGU3ZGM5NjI5
YmMxNDAyNWJhNTA5MTU4ODZdIE5GQzogcG41MzM6IFNpbXBsaWZ5IF9fcG41MzNfc2VuZF9m
cmFtZV9hc3luYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2L2xpbnV4LWRldmVsOmRl
dmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYwNzAwMTg6ZGRmMTlkMjA2ZmU0YmE0ZTdkYzk2Mjli
YzE0MDI1YmE1MDkxNTg4NjpiaXNlY3QtbW0KCjIwMTMtMDYtMTEtMDY6Mzk6NTUgZGRmMTlk
MjA2ZmU0YmE0ZTdkYzk2MjliYzE0MDI1YmE1MDkxNTg4NiByZXVzZSAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMyNi0wNjA2L2RkZjE5ZDIwNmZlNGJhNGU3ZGM5NjI5YmMxNDAyNWJh
NTA5MTU4ODYvdm1saW51ei0zLjkuMC1yYzEtMDA3NzgtZ2RkZjE5ZDIKCjIwMTMtMDYtMTEt
MDY6NDA6MDAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JNzUyCTc1Nwk4MTUJODYxCTkwMAk5
NTQJMTAwNgkxMDIyCTEwMzkJMTA2NAkxMDc5CTEwOTAJMTA5MwkxMDk3CTExMDEJMTEwNgkx
MTA5CTExMTEuCTExMTUJMTEzMAkxMTQ1CTExNDYuCTExNDkJMTE1NgkxMTYyCTExNjYuCTEx
NzMuCTExODIJMTE5OAkxMjA4CTEyMDkuCTEyMTIJMTIxMwkxMjE4CTEyMjEJMTIyMgkxMjI1
CTEyMjcJMTIyOAkxMjM0CTEyMzcJMTIzOAkxMjQyCTEyNTUJMTI2NgkxMjcwCTEyNzIJMTI3
NQkxMjc5CTEyODMJMTI4OQkxMjkyCTEyOTUJMTMwMwkxMzA2CTEzMTQJMTMyMAkxMzIxCTEz
MjIJMTMyMwkxMzI0CTEzMjkJMTMzMQkxMzM4CTEzNTEJMTM1NQkxMzU3CTEzNTgJMTM2Ngkx
Mzc1CTEzNzYJMTM3OAkxMzgzCTEzODUJMTM5NAkxNDA4CTE0MTAJMTQxMgkxNDE1CTE0MjIu
CTE0MzgJMTQ0NAkxNDQ3LgkxNDQ4CTE0NjgJMTQ3MAkxNDczLgkxNDc0CTE0ODAJMTQ4MQkx
NDg2CTE0OTAJMTQ5NwkxNDk5CTE1MDcJMTUyMQkxNTIzCTE1MjQJMTUzNgkxNTUxCTE1NjIu
CTE1NjMJMTU2NAkxNTc3CTE1ODYJMTU5NwkxNjAwCTE2MDYJMTYxNQkxNjI0CTE2MzIJMTYz
OAkxNjQ0CTE2NDcJMTY1NwkxNjYzCTE2NjkJMTY3Ni4JMTY4MAkxNjkwCTE2OTkJMTcwNgkx
NzEwCTE3MTEJMTcyMwkxNzI5CTE3MzUJMTczOQkxNzQ4LgkxNzQ5CTE3NTkJMTc2OQkxNzgy
CTE3ODcJMTc5NQkxODE0CTE4MTcJMTgyNAkxODI1LgkxODM0CTE4NDkJMTg1MgkxODU0CTE4
NTcJMTg2MQkxODczCTE4ODEJMTg4NgkxODkzCTE4OTgJMTkwMQkxOTAzCTE5MDkJMTkxMAkx
OTE2CTE5MTgJMTkyMwkxOTMwCTE5MzUJMTkzOS4JMTk0OAkxOTUzCTE5NTkJMTk3MQkxOTc1
CTE5ODEJMTk5NgkyMDAxCTIwMDkuCTIwMTUJMjAyMwkyMDQxCTIwNTQJMjA1OQkyMDYwCTIw
NjYJMjA3OAkyMDg1Li4JMjA5OAkyMTAzCTIxMTEJMjExNgkyMTI1CTIxMzAJMjEzNQkyMTQx
CTIxNDMJMjE0OAkyMTQ5CTIxNTgJMjE1OQkyMTY0CTIxNzIJMjE3NQkyMTc4LgkyMTg1CTIx
ODgJMjE5MQkyMTkzCTIyMDcJMjIxMAkyMjEzCTIyMTgJMjIyMAkyMjI5CTIyMzMJMjIzNwky
MjQwCTIyNDUJMjI1OAkyMjY0CTIyNjcJMjI3MgkyMjgzCTIyODQJMjI4NwkyMjkwCTIyOTIJ
MjI5NwkyMzA0CTIzMDcJMjMyMgkyMzI2CTIzMjgJMjMzNQkyMzQ0CTIzNTEJMjM1NAkyMzY2
CTIzNzEuCTIzNzgJMjM4NAkyMzkxCTIzOTMJMjQwMQkyNDA5CTI0MjIJMjQzMgkyNDM0CTI0
MzUJMjQ0MAkyNDU1CTI0NjMJMjQ3MwkyNDc0CTI0NzcJMjQ4OAkyNDk4CTI1MDkJMjUxMgky
NTE0CTI1MjUJMjUyOQkyNTM1CTI1NDQJMjU1MgkyNTYwCTI1NjEJMjU2OAkyNTc4CTI1ODQJ
MjU5MC4JMjU5MwkyNTk4CTI2MDQJMjYwOAkyNjE1CTI2MTcJMjYxOAkyNjIxCTI2MjUJMjYz
MAkyNjM3CTI2NDgJMjY1OAkyNjY4CTI2NzQJMjY5MAkyNzA0CTI3MTYuCTI3MjQuCTI3MzEJ
Mjc0MwkyNzQ3CTI3NTcJMjc1OQkyNzY0CTI3NjcJMjc3NAkyNzc4CTI3ODEJMjc4NQkyNzkz
CTI4MDAJMjgwNQkyODE4CTI4MjMJMjgzMwkyODQxCTI4NDQJMjg1NQkyODU3CTI4NTkuCTI4
NzIJMjg3OQkyODg1CTI4OTEJMjg5NgkyOTEwCTI5MTgJMjkyNwkyOTMyCTI5MzUJMjk0MAky
OTUyCTI5NjMJMjk2NgkyOTY5CTI5NzkJMjk4OAkyOTkwCTI5OTcJMzAwNAkzMDEyCTMwMjgJ
MzA0OQkzMDUzCTMwNjQJMzA2OQkzMDcwCTMwNzEJMzA3NAkzMDc1LgkzMDc5CTMwODEJMzA5
MAkzMDkzCTMxMDUJMzEwNwkzMTEwCTMxMTYJMzEzNQkzMTM4CTMxNDEJMzE0NwkzMTU3CTMx
NzAJMzE3MgkzMTczCTMxODEJMzE4NwkzMTk2CTMxOTkJMzIwMgkzMjA1CTMyMDYJMzIxOAkz
MjIyCTMyMjUuCTMyMjYJMzIzNgkzMjQ1CTMyNDYJMzI0NwkzMjU0CTMyNTYJMzI2Ny4JMzI3
MgkzMjc2CTMyNzgJMzI4MwkzMjg0CTMyODcJMzMwNgkzMzIwLgkzMzI2CTMzMzEJMzMzOC4J
MzM0MQkzMzQ5CTMzNTQJMzM2MQkzMzYyCTMzNjcJMzM3NwkzMzg3CTMzOTAJMzM5OQkzNDA5
CTM0MTgJMzQyNgkzNDM1CTM0NDEJMzQ0NQkzNDQ4CTM0NTgJMzQ2MC4JMzQ2MwkzNDY0CTM0
NjcJMzQ3MAkzNDc1CTM0ODcJMzQ5NwkzNTA2CTM1MTYJMzUxOQkzNTQwCTM1NTEJMzU2Mgkz
NTY5CTM1NzkJMzU4OAkzNTkzCTM1OTYJMzU5OQkzNjA4CTM2MjYJMzY0MQkzNjQyCTM2NTIJ
MzY2MwkzNjc4CTM2ODEJMzY4OQkzNjk2CTM3MTAJMzcyMQkzNzIzCTM3MzEJMzczOAkzNzQw
CTM3NjcJMzc4MQkzNzkyCTM4MDAJMzgxMAkzODM0CTM4MzcJMzg0NAkzODQ3CTM4NTYJMzg2
OQkzODc3CTM4ODcJMzg5MgkzOTA3CTM5MzQJMzkzNwkzOTQ1CTM5NDgJMzk1MQkzOTc1CTM5
ODkJMzk5MQk0MDAyCTQwMTUJNDAyNQk0MDM5CTQwNDUJNDA0OAk0MDQ5CTQwNTAJNDA2NAk0
MDY2Lgk0MDY5CTQwNzMJNDA4OQk0MDk0CTQwOTUJNDA5OQk0MTIyCTQxMzkJNDE0MAk0MTQ0
CTQxNTIJNDE1Nwk0MTkzCTQxOTYJNDIwOQk0MjI3CTQyMzMJNDIzOAk0MjU4CTQyODQJNDI4
OQk0MzA0CTQzMDgJNDMzMgk0MzM5CTQzNTAJNDM2NQk0Mzc3CTQzOTMJNDQwNgk0NDI4CTQ0
NDIJNDQ0OQk0NDUzCTQ0NjAJNDQ2Mwk0NDcxCTQ0ODgJNDQ5MAk0NDk0CTQ0OTUJNDUwNgk0
NTEyCTQ1MTYuCTQ1NDEJNDU1Mwk0NTU5CTQ1NjYJNDU4OAk0NTkyCTQ2MDUJNDYxNAk0NjE3
CTQ2MjgJNDYzMAk0NjMzCTQ2NDIJNDY1NAk0NjU2CTQ2NzMJNDY4Mwk0NzA2CTQ3MTUJNDcz
Mwk0NzY1CTQ3NzAJNDc5Nwk0ODAxCTQ4MjEJNDgzNgk0ODM5CTQ4NTYJNDg3Mgk0ODg4CTQ5
MTcJNDk1OAk0OTc5CTUwMDUJNTAyMwk1MDYxCTUwNjUuLi4uCTUwNjYuLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgNBtbMG0KLi4JNTA2
OS4uLi4uCTUwNzAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1OSByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKW2E4NTY2NjYyN2I3ZjEwYzQyMjk3
MTZiNmZmYWZmY2YxOTZhMTI4Y2FdIG1hYzgwMjExL21pbnN0cmVsX2h0OiB1c2UgdGhlIG5l
dyByYXRlIGNvbnRyb2wgQVBJCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvbGludXgt
ZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAxODphODU2NjY2MjdiN2YxMGM0
MjI5NzE2YjZmZmFmZmNmMTk2YTEyOGNhOmJpc2VjdC1tbQogVEVTVCBGQUlMVVJFCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvYTg1NjY2NjI3YjdmMTBjNDIyOTcxNmI2
ZmZhZmZjZjE5NmExMjhjYS9kbWVzZy1rdm0tYW50LTI1MDIxLTIwMTMwNjA5MjM1NDI4LTMu
OS4wLXJjMS0wMDgxOC1nYTg1NjY2Ni05CgpCaXNlY3Rpbmc6IDI5IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbMWI3MzdmODhkYzFiMDVj
ZjU3MWU5NmQ0MmY3NDhhYWZmNmRmMWViNV0gbWFjODAyMTE6IGZpeCBQMlAtRGV2aWNlIG1h
bmFnZW1lbnQgZnJhbWUgUlgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi9saW51eC1k
ZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDcwMDE4OjFiNzM3Zjg4ZGMxYjA1Y2Y1
NzFlOTZkNDJmNzQ4YWFmZjZkZjFlYjU6YmlzZWN0LW1tCgoyMDEzLTA2LTExLTE0OjA2OjU4
IDFiNzM3Zjg4ZGMxYjA1Y2Y1NzFlOTZkNDJmNzQ4YWFmZjZkZjFlYjUgcmV1c2UgL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi8xYjczN2Y4OGRjMWIwNWNmNTcxZTk2ZDQy
Zjc0OGFhZmY2ZGYxZWI1L3ZtbGludXotMy45LjAtcmMxLTAwMTUwLWcxYjczN2Y4CgoyMDEz
LTA2LTExLTE0OjA3OjA2IGRldGVjdGluZyBib290IHN0YXRlIC4uCTc1Mwk3NjEJNzY5CTc4
OQk3OTEJODAwCTgxMS4JODEyCTg1MAk4NzIJODgwCTkxNwk5NTUJOTc5CTEwMzEJMTEyNwkx
MTkyCTEyMjkJMTMwOAkxMzQwCTE0MTkJMTUyMgkxNTk0CTE2NTMJMTcyNwkxODUzCTE5MTEJ
MjAyOQkyMTA2CTIyMTYJMjMwOQkyNDI3CTI1MjcJMjY2MwkyNzI1CTI4NTAJMjkyOAkzMDM4
CTMxMTUJMzMxNAkzNDE1CTM1MjQJMzY4MAkzNzgwCTM4ODYJMzkyOAk0MTYyCTQyNjEJNDM1
NAk0Mzk3CTQ0MjAJNDcwNQk0NzY4CTQ4NTQJNDk3Ngk1MDM5CTUwNjMJNTA2NAk1MDY2Li4J
NTA2Ny4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9x
dWV1ZSAzG1swbQouLi4JNTA2OAk1MDY5CTUwNzAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNCBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzMx
ZWQwN2RjMWU4M2I3OTI2Y2U4ZWUyMjE1ZWEyMTU5OWEyMTU5OTBdIGJyY21mbWFjOiByZW1v
dmUgaWZpZHggdmFyaWFibGUgZnJvbSBicmNtZl9md3NfcHJvY2Vzc19za2IoKQpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWMyNi0wNjA2L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0y
MDEzMDYwNzAwMTg6MzFlZDA3ZGMxZTgzYjc5MjZjZThlZTIyMTVlYTIxNTk5YTIxNTk5MDpi
aXNlY3QtbW0KIFRFU1QgRkFJTFVSRQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNi0w
NjA2LzMxZWQwN2RjMWU4M2I3OTI2Y2U4ZWUyMjE1ZWEyMTU5OWEyMTU5OTAvZG1lc2cta3Zt
LWFudC0yNTE0My0yMDEzMDYxMDA2MzUzMi0zLjkuMC1yYzEtMDA3NzQtZzMxZWQwN2QtMTEK
CkJpc2VjdGluZzogNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMyBzdGVwcykKWzFlOWFiNGRkMjU4ZWNiYjBmMWMzNzdmZDRkYmUyMjdjZGI5M2Q5YmRd
IGJyY21mbWFjOiBzZXR1cCBTRElPIHJlc2V0IGJlaGF2aW9yCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctYzI2LTA2MDYvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAx
ODoxZTlhYjRkZDI1OGVjYmIwZjFjMzc3ZmQ0ZGJlMjI3Y2RiOTNkOWJkOmJpc2VjdC1tbQoK
MjAxMy0wNi0xMS0xNzoxNDowMCAxZTlhYjRkZDI1OGVjYmIwZjFjMzc3ZmQ0ZGJlMjI3Y2Ri
OTNkOWJkIGNvbXBpbGluZwozOTggcmVhbCAgMTY2MyB1c2VyICAxNTIgc3lzICA0NTUuMzYl
IGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYKG1sxOzM1bWFkZF90b19ydW5fcXVl
dWU6IHJlcXVlc3RlZCA1MDcwLCBsaW1pdCB0byA1MDAwG1swbQoKMjAxMy0wNi0xMS0xNzoy
MDo1OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC1yYzEtMDA3NjYtZzFlOWFiNGQuLi4u
Li4JMS4JNS4uCTYuCTcJOAk5CTEwLi4JMTEJMTIuCTEzCTE1CTE3CTE4CTIwCTI3CTI5Lgkz
MQkzMgkzMy4JMzQJMzYuCTM4CTQxCTQ0CTUwCTU0CTY2CTc2Li4uCTc4CTgwCTkwCTkzCTk1
CTEwMS4JMTAzCTEwNwkxMTEJMTE2CTEyMgkxMzAJMTMxCTEzNwkxMzgJMTM5CTE0NAkxNDYu
CTE0NwkxNTAJMTUxCTE1MgkxNTMJMTU0CTE1NQkxNTcJMTYyCTE2OC4JMTY5CTE3NgkxODAJ
MTgyCTE4MwkxODUJMTg3CTE5MgkxOTcJMjAyCTIwNwkyMTEJMjEzLgkyMTgJMjI2Li4JMjMx
CTIzMgkyMzgJMjQxLgkyNDIuCTI0MwkyNDQuLgkyNDYuCTI0NwkyNDgJMjUxCTI1MwkyNTUu
CTI1OC4uCTI2MwkyNjUJMjY3LgkyNjgJMjY5CTI3MgkyNzMJMjc0CTI3OC4JMjgwCTI4My4J
Mjk2CTI5OC4JMzAxCTMwNwkzMTQJMzE2CTMxOS4JMzIwCTMyNQkzMzMuCTMzNy4uCTM0MAkz
NDEJMzQzCTM0NAkzNTUJMzU3Li4uCTM1OAkzNTkJMzYxCTM2MgkzNjMJMzcwCTM3MwkzNzYJ
Mzc4CTM4MAkzODMuLgkzODQJMzg2CTM5MAkzOTIJMzkzCTM5NAkzOTYJNDAwCTQwNC4JNDA4
CTQxOAk0MjAuLgk0MjYuLgk0MjkJNDMxCTQzNAk0NTAJNDU1CTQ1Ni4JNDU4CTQ2MQk0NjUJ
NDcxCTQ3Mwk0NzgJNDgyCTQ5Mgk0OTUJNTA0CTUxMy4uCTUzNy4JNTUwCTU1Mi4JNTU2CTU2
Mgk1NjUJNTcwCTU3OAk1NzkJNTkxCTU5Mi4uCTU5NAk1OTcJNjAwCTYwMgk2MDgJNjA5CTYx
NQk2MTcJNjIxLgk2MjMJNjI0CTYyNi4JNjI3CTYzMAk2MzMJNjM0Lgk2MzYJNjQwCTY0MQk2
NDUJNjUwCTY1NS4JNjY3CTY3Mwk2NzYJNjc4CTY3OQk2ODMJNjg4Li4JNjkxCTY5Ngk3MDcJ
NzE2CTcxOS4JNzIwCTcyMQk3MjUuCTczMC4JNzM1CTczNgk3MzcuCTc0MQk3NDIJNzQ0CTc0
NS4uCTc0OQk3NTMJNzU2CTc1OAk3NjQuCTc2NQk3NjYuLgk3NzAuCTc3MQk3NzIJNzczCTc3
NAk3NzYuLgk3ODAuLgk3ODEJNzgzLi4JNzg0CTc4NS4JNzg2Li4uCTc4OAk3ODkuLi4uLi4u
Li4uLi4uCTc5MAk3OTEuLi4JNzk0Li4uLi4JNzk3Li4uCTgwMAk4MDEuCTgwMy4JODA1Li4u
Lgk4MDYuCTgwOAk4MTIuCTgxMwk4MTUJODE2Li4JODI1CTgyNwk4MzAJODM0Lgk4MzkJODQx
Li4uCTg0Mi4uLgk4NDYJODQ3Li4uCTg1Mgk4NTMuCTg1OAk4NTkuCTg2Mi4uCTg2NQk4NjgJ
ODY5Li4JODcxLgk4NzIuCTg3My4JODc0Li4JODc1Li4JODc3CTg3OAk4NzkuCTg4MS4JODgy
Lgk4ODUJODg2CTg4OAk4OTEJODk0CTg5OAk4OTkJOTAyLgk5MDMJOTA2CTkwNwk5MDkuCTkx
MAk5MTIJOTE0CTkxOS4JOTIyLgk5MjguCTkyOQk5MzEuCTkzMgk5MzUJOTM3CTkzOAk5Mzku
Lgk5NDAuCTk0My4JOTQ0CTk0Ngk5NDguLi4JOTUxCTk2MAk5NjQJOTY3CTk3MQk5NzguCTk3
OS4uCTk4MQk5ODMJOTg0CTk4Nwk5ODkJOTkxLgk5OTIuLgk5OTMJOTk0Li4JOTk1Li4JOTk3
CTk5OAk5OTkJMTAwMAkxMDAzCTEwMDYJMTAxMAkxMDExCTEwMTcJMTAyMQkxMDI0CTEwMjUJ
MTAzMAkxMDM0CTEwMzcJMTAzOQkxMDQwCTEwNDMJMTA0NAkxMDQ2LgkxMDQ5CTEwNTEJMTA1
NAkxMDU4CTEwNjEJMTA2NAkxMDY1CTEwNjYJMTA3MQkxMDc0CTEwNzUuLgkxMDgyCTEwODgJ
MTA5MAkxMDkyCTEwOTUJMTEwMQkxMTA4CTExMTEuCTExMTMJMTEyMQkxMTIyCTExMjYuCTEx
MjcJMTEyOS4JMTEzMgkxMTM1LgkxMTQxCTExNDQJMTE1MwkxMTU1CTExNTkJMTE2NgkxMTcx
LgkxMTc2CTExNzcJMTE4MQkxMTgzCTExODYJMTE4NwkxMTkxCTExOTMJMTE5OAkxMjA0CTEy
MDYuCTEyMDcJMTIwOAkxMjEyCTEyMTMuCTEyMTQuCTEyMTUJMTIxOAkxMjE5LgkxMjI0CTEy
MjYJMTIyNwkxMjMwCTEyMzYJMTIzNwkxMjM4LgkxMjQwCTEyNDkJMTI1MQkxMjU4CTEyNjIJ
MTI2NAkxMjY3CTEyNzMJMTI3NC4JMTI4MQkxMjg1CTEyODYJMTI5MQkxMjk5CTEzMTEJMTMx
OAkxMzIxCTEzMjUJMTM0NQkxMzU1CTEzNjIJMTM2MwkxMzY4CTEzNzUJMTM4MS4JMTM4Nwkx
NDAyCTE0MDgJMTQxOQkxNDI3CTE0MzYJMTQ0NQkxNDU0CTE0NTYJMTQ1OQkxNDYwCTE0NjEJ
MTQ2MgkxNDYzCTE0NjcJMTQ2OQkxNDcyLgkxNDc0CTE0NzYJMTQ3OQkxNDgxCTE0ODIJMTQ4
MwkxNDg2CTE0OTQuLgkxNDk1CTE0OTcJMTUwMQkxNTAzLi4JMTUwOAkxNTEwLi4uCTE1MTIu
CTE1MTMJMTUxNQkxNTE2LgkxNTE3CTE1MTgJMTUxOS4uCTE1MjEJMTUyNQkxNTMwCTE1MzUJ
MTU0NwkxNTU2CTE1NjcJMTU3MQkxNTczCTE1ODAJMTU4MwkxNTg3CTE1OTYJMTYwMwkxNjEy
CTE2MTMJMTYyMQkxNjI2CTE2MjgJMTYyOQkxNjMwLi4JMTYzMi4JMTYzMwkxNjM2CTE2NDEu
LgkxNjQyCTE2NDcJMTY0OAkxNjQ5CTE2NTAJMTY1MwkxNjU5CTE2NjAJMTY2MgkxNjYzLgkx
NjY3CTE2NzAJMTY3MQkxNjcyLgkxNjc0Li4JMTY3NgkxNjgwCTE2ODEJMTY4MgkxNjg1CTE2
ODYuLgkxNjg4CTE2ODkuCTE2OTMJMTY5NQkxNjk3CTE2OTkJMTcwMC4uCTE3MDMJMTcwNAkx
NzA2LgkxNzA3CTE3MDkJMTcxMAkxNzExCTE3MTIuLgkxNzEzCTE3MTQJMTcxNwkxNzE4CTE3
MjAJMTcyNwkxNzM1CTE3NDAJMTc0NQkxNzQ4CTE3NTEJMTc1OAkxNzY1CTE3NjYJMTc3Mwkx
Nzc5CTE3ODQJMTc4NwkxNzg5CTE3OTQJMTgwMgkxODE3CTE4MTkJMTgyMQkxODI4CTE4MjkJ
MTgzNQkxODM5CTE4NDguCTE4NTAJMTg1MwkxODU4CTE4NjAJMTg3MAkxODc1LgkxODc3CTE4
ODUJMTg4OAkxODkzLgkxODk4CTE4OTkJMTkwMgkxOTAzCTE5MDkJMTkxNwkxOTE4CTE5MjAJ
MTkyOQkxOTQzCTE5NDQJMTk0NQkxOTUxCTE5NTQJMTk2MAkxOTY3CTE5NzYJMTk4NgkxOTky
CTE5OTkJMjAwNQkyMDA3CTIwMTEJMjAxOAkyMDI2CTIwNDAJMjA0OQkyMDU1CTIwNjIJMjA3
NgkyMDc3CTIwODAJMjA5MQkyMDk0CTIxMDYJMjExMwkyMTIxCTIxMjQJMjEzMQkyMTQwCTIx
NDUJMjE1MQkyMTU2CTIxNzAJMjE3MwkyMTc1CTIxODYJMjE5MQkyMjAyCTIyMDYJMjIwOQky
MjE1CTIyMjUJMjIzOAkyMjQ5CTIyNjMJMjI3MwkyMjc2CTIzMDUJMjMxNAkyMzE1LgkyMzMz
CTIzMzUJMjM0OAkyMzY2CTIzNzgJMjM4NAkyMzk1CTI0MDMJMjQxMAkyNDE2CTI0MTkuCTI0
MjIJMjQyNgkyNDI3LgkyNDI4CTI0MjkuCTI0MzIJMjQzNi4uCTI0MzkJMjQ0NgkyNDQ3CTI0
NTAuCTI0NTEJMjQ1MgkyNDUzCTI0NTQJMjQ1NQkyNDU4CTI0NTkJMjQ2MAkyNDYxCTI0NjIJ
MjQ2NAkyNDY4Li4JMjQ2OS4JMjQ3MQkyNDc1CTI0NzguCTI0NzkJMjQ4MAkyNDgxLi4uCTI0
ODIJMjQ4MwkyNDg0CTI0ODkuCTI0OTEJMjQ5My4uCTI0OTQJMjQ5NS4JMjQ5Ni4JMjQ5Ny4u
CTI1MDAJMjUwMQkyNTA0CTI1MDYJMjUwNwkyNTA5CTI1MTAJMjUxMwkyNTE0CTI1MTUJMjUx
NgkyNTE3CTI1MTkJMjUyMQkyNTIzCTI1MjQJMjUyNQkyNTI4LgkyNTMyCTI1MzQJMjUzNQky
NTM2CTI1MzkJMjU0MC4uCTI1NDMJMjU0NwkyNTQ4LgkyNTQ5CTI1NTAJMjU1MgkyNTU0CTI1
NTYuCTI1NjEuCTI1NjUJMjU2NwkyNTY4CTI1NzIJMjU4MQkyNTg4CTI1OTAJMjU5MgkyNTkz
CTI2MDEuCTI2MDQJMjYwOC4JMjYxMC4JMjYxMQkyNjEzLgkyNjE5LgkyNjI1LgkyNjM2CTI2
MzkJMjY0NC4JMjY0NgkyNjQ3Li4JMjY0OC4JMjY0OQkyNjUxCTI2NTIuCTI2NTMJMjY1NAky
NjU2Li4uCTI2NTkJMjY2MwkyNjY2CTI2NjguCTI2NzAJMjY3MS4JMjY3MgkyNjczCTI2NzQu
CTI2NzYuCTI2NzcJMjY3OAkyNjc5CTI2ODIuCTI2ODQJMjY4NgkyNjg5CTI3MDEJMjcwNwky
NzExCTI3MjEJMjczMQkyNzQ4CTI3NTQJMjc1OAkyNzYzCTI3NjcJMjc2OAkyNzY5CTI3NzAJ
Mjc3NQkyNzgyCTI3ODgJMjc5MAkyNzkyCTI4MDUJMjgxMy4JMjgxNQkyODI0CTI4MzYJMjg0
NAkyODU0CTI4NTgJMjg2Mi4JMjg2NQkyODc1CTI4NzYJMjg4MAkyODgxCTI4ODIJMjg4OAky
ODg5LgkyODkzCTI4OTQJMjkwMgkyOTEyCTI5MTMJMjkxNQkyOTE5CTI5MjgJMjkzOS4JMjk0
MC4JMjk0MwkyOTQ4CTI5NTAJMjk1MQkyOTUyCTI5NTMJMjk1OAkyOTYwCTI5NjQJMjk2OAky
OTcyCTI5ODAJMjk4MQkyOTg0CTI5ODUuCTI5ODYJMjk5NC4uLgkyOTk1CTI5OTcJMjk5OAky
OTk5LgkzMDAxCTMwMDQJMzAwNQkzMDA2CTMwMDgJMzAxMAkzMDE1CTMwMjAuCTMwMjEJMzAy
NAkzMDMxCTMwMzMuCTMwMzUJMzAzOAkzMDQwLi4JMzA0MQkzMDQ0CTMwNTEJMzA1NgkzMDYw
CTMwNjQuLgkzMDY2LgkzMDY4CTMwNzEuLgkzMDc0Li4uCTMwNzYJMzA3NwkzMDc4Li4JMzA3
OQkzMDgxLi4JMzA4MwkzMDg1CTMwODcJMzA4OC4JMzA5MAkzMDk1CTMwOTYJMzA5NwkzMTAy
CTMxMDcJMzEwOC4uCTMxMDkJMzExMQkzMTEyCTMxMTUJMzExNi4JMzExOS4JMzEyMAkzMTIx
CTMxMjIJMzEyNS4uCTMxMjcJMzEyOAkzMTMwLgkzMTMyCTMxMzgJMzE0MAkzMTQ1CTMxNDgJ
MzE1MS4uCTMxNTIJMzE1NgkzMTU3CTMxNTkJMzE2MwkzMTY0CTMxNjUJMzE3NAkzMTgwCTMx
ODIJMzE4NAkzMTg4Li4uLgkzMTkwCTMxOTEuCTMxOTIJMzE5MwkzMTk3CTMxOTgJMzIwMAkz
MjAxCTMyMDYJMzIwOC4JMzIwOQkzMjE0CTMyMTcJMzIxOAkzMjIwCTMyMjEJMzIyMgkzMjI2
CTMyMjcuCTMyMjgJMzIzNAkzMjM1CTMyMzYJMzI0MQkzMjQyLgkzMjQzCTMyNDYuCTMyNDcu
LgkzMjYwCTMyNzQJMzI3NwkzMjc5CTMyODQJMzI5MAkzMjkzCTMyOTUuCTMyOTYJMzI5Nwkz
MzAwLi4JMzMwMgkzMzA2CTMzMTIJMzMxNAkzMzE1CTMzMTYJMzMxNwkzMzE5CTMzMjEJMzMy
Mi4JMzMzMC4uCTMzMzIJMzMzNi4uCTMzMzcJMzM0MQkzMzQzCTMzNDcJMzM0OQkzMzUxCTMz
NTMJMzM1OQkzMzYzCTMzNzEJMzM3OQkzMzg3CTMzOTEJMzM5MgkzMzk1LgkzNDAyCTM0MDMu
LgkzNDA0CTM0MDYJMzQwOS4uLgkzNDEzCTM0MTUuCTM0MTgJMzQxOQkzNDI3CTM0MzYJMzQz
OC4JMzQzOQkzNDUzCTM0NjAJMzQ2MgkzNDYzCTM0NjYJMzQ2Ny4JMzQ3MAkzNDc0CTM0NzUJ
MzQ4MwkzNDg1CTM0ODcJMzQ5NAkzNDk3CTM1MDAJMzUwNAkzNTA4CTM1MTEJMzUxMgkzNTE4
CTM1MTkuCTM1MjEJMzUyMwkzNTI4LgkzNTMwLi4JMzUzNAkzNTM1LgkzNTM2LgkzNTQwLgkz
NTQxCTM1NDMJMzU0Ny4uCTM1NTMJMzU1NQkzNTU2CTM1NTkJMzU2MAkzNTYxCTM1NjIuCTM1
NjMJMzU2NQkzNTY2CTM1NjcJMzU3MwkzNTc1CTM1NzcuLi4JMzU3OAkzNTgxLi4uCTM1ODQJ
MzU4NQkzNTg5CTM1OTEJMzU5OQkzNjAyCTM2MDYJMzYwNwkzNjExCTM2MTYJMzYyNAkzNjI2
CTM2MjguCTM2MzMJMzYzOAkzNjUwCTM2NTEJMzY1NgkzNjU4CTM2NjUJMzY2OAkzNjcwCTM2
NzEJMzY3NwkzNjgzCTM2ODcJMzY5MAkzNzExCTM3MTYJMzcyNAkzNzI5CTM3MzIJMzczNQkz
NzM5CTM3NDAJMzc0OQkzNzUzCTM3NjEJMzc2NwkzNzY5LgkzNzcyCTM3NzQJMzc3NwkzNzgy
CTM3ODMJMzc4NgkzNzg4CTM3OTkJMzgwMi4JMzgwNAkzODA1CTM4MTEJMzgyOC4JMzgyOQkz
ODMxCTM4MzgJMzgzOS4JMzg0MQkzODQzCTM4NDQJMzg0NgkzODQ3LgkzODQ5LgkzODUxCTM4
NTIuCTM4NTQJMzg1OQkzODY3LgkzODcxCTM4NzkJMzkwMAkzOTAxCTM5MDQJMzkxMwkzOTI3
CTM5NDMJMzk0NQkzOTQ3CTM5NTcJMzk2OQkzOTczCTM5NzUJMzk4MAkzOTg3CTM5OTEJMzk5
NgkzOTk3CTM5OTkJNDAwNgk0MDA3CTQwMjMJNDAyOAk0MDI5CTQwMzQuCTQwNDIJNDA0NAk0
MDQ1CTQwNTAJNDA1Mgk0MDU2CTQwNTkJNDA3MQk0MDc2CTQwNzkJNDA4NAk0MDg3Lgk0MDg5
Lgk0MDk5CTQxMDQuLi4JNDEwNS4JNDEwNi4uCTQxMDcJNDEwOAk0MTA5Lgk0MTExCTQxMTIJ
NDEyMwk0MTI3CTQxMzEJNDE0Mgk0MTQ3CTQxNDkJNDE1MC4JNDE1Mgk0MTU5CTQxNjIJNDE2
NAk0MTY2CTQxNjgJNDE3NAk0MTc1CTQxNzcJNDE4MQk0MTk3CTQyMDIJNDIwMwk0MjA0CTQy
MDUJNDIxOQk0MjI0CTQyMjcJNDIyOQk0MjQwCTQyNDIJNDI0Ngk0MjUyCTQyNTMJNDI1NS4J
NDI1OQk0MjY2CTQyNzEJNDI3Nwk0Mjc4CTQyODUJNDI5Ngk0Mjk3CTQzMDQJNDMxMgk0MzE0
CTQzMTUJNDMxOAk0MzIyCTQzMjkJNDM0MAk0MzQ0CTQzNDkJNDM2Nwk0Mzc2CTQzNzgJNDM4
MAk0MzkyCTQzOTYJNDQwMAk0NDA4CTQ0MTYJNDQyNAk0NDI3CTQ0MzEJNDQzNAk0NDQ1CTQ0
NTIJNDQ1NS4uLgk0NDU4CTQ0NjcJNDQ2OC4JNDQ3MQk0NDgwCTQ0ODcJNDQ5MAk0NDkxCTQ0
OTMJNDQ5Ny4JNDQ5OQk0NTAxCTQ1MDYJNDUxNAk0NTE5CTQ1MjgJNDUzMQk0NTM1Lgk0NTQz
Lgk0NTQ2CTQ1NTUJNDU2Mwk0NTY3CTQ1NzAJNDU3Mgk0NTc3CTQ1ODIJNDU4NQk0NTg5CTQ1
OTgJNDU5OQk0NjAwLgk0NjAyCTQ2MTAJNDYyMQk0NjIzCTQ2MzAJNDYzMwk0NjQ0CTQ2NTUJ
NDY2OQk0NjczCTQ2NzUJNDY5MQk0Njk3CTQ3MDkJNDcxMgk0NzIzCTQ3MzMJNDc1My4JNDc1
Ni4JNDc2MQk0NzY3CTQ3NzYJNDc5MAk0ODA2CTQ4MTMJNDgyMQk0ODI1CTQ4MzcJNDg0Mwk0
ODQ4CTQ4NjUJNDg4Mwk0OTAwCTQ5MTcJNDkyNgk0OTM4CTQ5NTgJNDk3Ngk0OTk2CTQ5OTcu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTQ5OTguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
G1sxOzM1bWFkZF90b19ydW5fcXVldWUgNzIbWzBtCi4uCTQ5OTkJNTAxMgk1MDI3CTUwMzkJ
NTA0NQk1MDQ2CTUwNTQJNTA2MAk1MDYyCTUwNzAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzIHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbNjY4
NzYxYWMwMWQ2ZjVhMzZiOGU1YTI0ZDRlMTU0NTUwZTJjNGMzYl0gYnJjbWZtYWM6IGRlZmlu
ZSBhbmQgdXNlIHBsYXRmb3JtIHNwZWNpZmljIGRhdGEgZm9yIFNESU8uCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0v
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctYzI2LTA2MDYvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMw
NjA3MDAxODo2Njg3NjFhYzAxZDZmNWEzNmI4ZTVhMjRkNGUxNTQ1NTBlMmM0YzNiOmJpc2Vj
dC1tbQoKMjAxMy0wNi0xMi0xMTozODoxNCA2Njg3NjFhYzAxZDZmNWEzNmI4ZTVhMjRkNGUx
NTQ1NTBlMmM0YzNiIGNvbXBpbGluZwozODggcmVhbCAgMTYwOSB1c2VyICAxMzMgc3lzICA0
NDguNjklIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYKG1sxOzM1bWFkZF90b19y
dW5fcXVldWU6IHJlcXVlc3RlZCA1MDcwLCBsaW1pdCB0byA1MDAwG1swbQoKMjAxMy0wNi0x
Mi0xMTo0NTowNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC1yYzEtMDA3NzAtZzY2ODc2
MWEuLgk1CTEzCTE1CTIyCTM0CTUyCTY1CTcyCTgwCTg1CTg3CTk3CTExNwkxMTkJMTI2CTEz
MAkxNDIJMTY4IFRFU1QgRkFJTFVSRQpkbWVzZy1rdm0tYW50LTI0ODU3LTIwMTMwNjEyMTE1
NzAyLTMuOS4wLXJjMS0wMDc3MC1nNjY4NzYxYS0xNwoKQmlzZWN0aW5nOiAxIHJldmlzaW9u
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzM2OTUwOGM1NjU2
ZGIyOTBmMDliMzJkMjEzZWZmZWVhNmMxNDMxYjhdIGJyY21mbWFjOiBBZGQgNDMxNDMgU0RJ
TyBzdXBwb3J0LgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2L2xpbnV4LWRldmVsOmRl
dmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYwNzAwMTg6MzY5NTA4YzU2NTZkYjI5MGYwOWIzMmQy
MTNlZmZlZWE2YzE0MzFiODpiaXNlY3QtbW0KCjIwMTMtMDYtMTItMTE6NTU6MDggMzY5NTA4
YzU2NTZkYjI5MGYwOWIzMmQyMTNlZmZlZWE2YzE0MzFiOCBjb21waWxpbmcKMjQxIHJlYWwg
IDE4MzQgdXNlciAgMTM0IHN5cyAgODE0LjI3JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMy
Ni0wNjA2ChtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlOiByZXF1ZXN0ZWQgNTA3MCwgbGltaXQg
dG8gNTAwMBtbMG0KCjIwMTMtMDYtMTItMTE6NTk6MjcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My45LjAtcmMxLTAwNzY4LWczNjk1MDhjLi4JNAkxMQkxOAkyNAkzOAk0NAk0Ngk1Nwk2Ngk2
OAk3Mwk3Nwk5MQk5OQkxMTEJMTIxCTE0NQkxNTEJMTYzCTE2NQkxNzEJMTcyLi4JMTczCTE3
OAkxODUJMjAyCTIxMAkyMTUJMjI1CTIyNgkyMzEJMjM0CTIzOAkyNDIJMjQ4LgkyNTgJMjcw
CTI3NQkyOTIJMjkzCTMxMwkzMjAJMzI1CTMzNgkzNDEJMzU0CTM2OQkzNzQJMzg2CTM5Mgkz
OTcJNDAxCTQxNgk0MjAJNDI3CTQzMAk0MzUJNDQ1CTQ1MQk0NjEJNDY0CTQ3MQk0ODYJNTAw
CTUwMwk1MjIJNTM3Lgk1NDcJNTcxCTU3Mgk1NzgJNTc5CTU5MQk1OTkJNjA4CTYxNAk2MjEJ
NjI2CTYyOAk2MzgJNjU5CTY2NAk2NjcJNjY5CTY4Mgk2OTMJNjk3CTY5OC4JNzEwCTcxNgk3
MjYJNzMzCTczNAk3NDYJNzUwCTc1NAk3NTkJNzYzCTc2Ngk3NjcJNzY5CTc3OAk3ODYJNzkz
CTgwMgk4MDcJODEwCTgxNwk4MjQuCTgyOAk4NDQJODU3CTg2NAk4ODQJODg4CTkwMAk5MDIJ
OTExCTkyNQk5MjYJOTMwCTk0MAk5NDgJOTU2CTk2MAk5NjgJOTc2CTk3OQk5ODcJMTAxNAkx
MDE5CTEwMzMJMTAzNwkxMDQ3CTEwNjAJMTA2OAkxMDc2CTEwODQuCTExMDgJMTEyMwkxMTM3
CTExNDkuCTExNTgJMTE3MAkxMTg4CTExOTMJMTIwMAkxMjA0CTEyMTMJMTIzOAkxMjUwCTEy
NTcJMTI2MwkxMjY1CTEyNzAJMTI5NQkxMzA0LgkxMzIyCTEzMjkJMTM0MwkxMzU4CTEzNjgJ
MTM3NAkxMzg0CTEzOTAJMTM5NQkxNDAwCTE0MDYJMTQxMQkxNDMyCTE0MzYJMTQzNwkxNDU2
CTE0NzYJMTQ4NQkxNDk1CTE0OTYJMTUwMwkxNTIyCTE1NDEJMTU0MgkxNTQ1CTE1NDgJMTU1
NgkxNTc4CTE1OTIJMTYwNgkxNjIxCTE2MjMuCTE2MjUJMTYyNwkxNjI4CTE2MzAuCTE2MzEJ
MTYzNAkxNjM1CTE2MzgJMTY0Mi4JMTY0NAkxNjQ3CTE2NDguLgkxNjU3LgkxNjU4CTE2NjIu
CTE2NjUJMTY2OQkxNjcxCTE2NzUuLgkxNjc3CTE2ODAJMTY4MQkxNjgzCTE2ODUJMTY4Ny4J
MTY4OC4uLgkxNjg5Li4JMTY5MgkxNjk0CTE2OTgJMTcwMQkxNzAyLgkxNzA1LgkxNzA3Lgkx
NzA4CTE3MTEuCTE3MTQJMTcxNgkxNzE4CTE3MTkJMTcyMAkxNzIxCTE3MjMJMTczMAkxNzMy
CTE3MzQJMTczNwkxNzQ3CTE3NjAJMTc4MS4JMTc4MgkxNzg1CTE3OTAJMTc5MQkxNzkzCTE3
OTQJMTc5OAkxODA4CTE4MTIJMTgxNAkxODE4CTE4MjAuCTE4MjYJMTgyOAkxODMwLi4JMTgz
MQkxODMzCTE4MzkJMTg0NAkxODQ2CTE4NDcJMTg0OS4JMTg1MAkxODUzLi4uCTE4NTQuCTE4
NTUJMTg1NgkxODU3CTE4NTgJMTg1OS4uCTE4NjEJMTg2MgkxODY0CTE4NzAJMTg3NgkxODgw
LgkxODgxCTE4ODUuCTE4ODYuCTE4ODkJMTg5MQkxODkzCTE4OTYJMTg5Ny4JMTg5OQkxOTA1
CTE5MDgJMTkwOQkxOTEzCTE5MTUJMTkyMQkxOTMwCTE5MzgJMTkzOQkxOTQwCTE5NDYuCTE5
NDkJMTk1NgkxOTU4CTE5NjMJMTk3MAkxOTczCTE5NzUJMTk3NwkxOTgxCTE5ODIJMTk4NQkx
OTkwLgkxOTk0CTE5OTkuLgkyMDAwCTIwMDEJMjAwMgkyMDA1CTIwMDgJMjAxMAkyMDEzLgky
MDE1CTIwMjEJMjAyOQkyMDMzCTIwNDEJMjA0NAkyMDQ1CTIwNTAuLgkyMDUzCTIwNTUJMjA2
MAkyMDY1CTIwNjcuCTIwNjkJMjA3OQkyMDgxCTIwODMJMjA4NAkyMDg3CTIwOTIJMjA5Mwky
MDk1CTIwOTcJMjEwMQkyMTA1Li4JMjExMAkyMTExCTIxMTMuCTIxMTQJMjExNQkyMTIxCTIx
MjUJMjEzMgkyMTUxCTIxNTQJMjE1NwkyMTU4LgkyMTYyCTIxNjMJMjE2NAkyMTY2CTIxNzAJ
MjE3MgkyMTc0CTIxNzkJMjE5MAkyMTk3LgkyMjA0Li4JMjIwNy4JMjIwOQkyMjEzCTIyMTcJ
MjIzMi4uCTIyMzUJMjIzNgkyMjM3LgkyMjM4CTIyNDEJMjI0NAkyMjQ4CTIyNDkJMjI1MS4J
MjI1MgkyMjUzLgkyMjU1CTIyNjEJMjI2NgkyMjcwCTIyNzIJMjI3MwkyMjc3CTIyODIJMjI4
MwkyMjg0LgkyMjg2CTIyOTEJMjI5NAkyMjk2LgkyMzAwCTIzMDEuCTIzMDQJMjMwNgkyMzEw
LgkyMzExCTIzMTUJMjMxNi4JMjMxNwkyMzE4CTIzMjAuCTIzMjEJMjMyMgkyMzIzLgkyMzI0
CTIzMjYJMjMyOS4JMjMzMAkyMzMzCTIzMzYJMjM0NAkyMzQ2CTIzNDcuCTIzNDkJMjM1My4u
CTIzNTUJMjM1Ni4uCTIzNTcJMjM1OQkyMzYxCTIzNjMuCTIzNjcJMjM3MQkyMzczCTIzNzcu
CTIzNzgJMjM3OQkyMzgwLgkyMzgxLgkyMzgyLi4uLgkyMzgzLgkyMzg0CTIzODUuCTIzODcu
LgkyMzg4Li4JMjM5MQkyMzk0Li4uCTIzOTYJMjM5OC4JMjM5OQkyNDAwCTI0MDEJMjQwOQky
NDExCTI0MTMuCTI0MTQJMjQxOAkyNDIwLi4uCTI0MjIJMjQyMwkyNDI4CTI0MjkuLgkyNDMy
CTI0MzMuLi4JMjQzNS4uLgkyNDM4CTI0NDAuLgkyNDQyCTI0NDUJMjQ0OAkyNDUxLi4uCTI0
NTIJMjQ1MwkyNDU0CTI0NTUuCTI0NTYJMjQ2MgkyNDY0Li4uLi4JMjQ2Ni4uLi4JMjQ2OQky
NDczCTI0NzQuLi4uLgkyNDc2CTI0NzgJMjQ4MC4JMjQ4NwkyNDg5CTI0OTEJMjQ5NwkyNTAy
CTI1MDQJMjUwOAkyNTEyCTI1MTQuCTI1MTYJMjUxOC4uCTI1MjEJMjUyNi4JMjUyOQkyNTMw
CTI1MzMJMjUzNAkyNTQxCTI1NDIJMjU0NAkyNTQ1CTI1NDYJMjU0NwkyNTQ4LgkyNTUyCTI1
NTYJMjU1NwkyNTU5LgkyNTYxCTI1NjkJMjU3MS4uCTI1NzIJMjU4MAkyNTgxCTI1ODIuCTI1
ODMJMjU4NAkyNTg5CTI1OTAJMjU5MQkyNTkzLi4uCTI1OTQJMjU5Ni4JMjU5NwkyNTk4Lgky
NjAwCTI2MDYJMjYwOQkyNjExCTI2MTQJMjYxNQkyNjIyCTI2MjcJMjYyOS4uCTI2MzQJMjY0
NgkyNjQ3Li4JMjY0OQkyNjUxLgkyNjUzCTI2NTUuCTI2NTguLgkyNjU5CTI2NjMJMjY2Ny4J
MjY2OS4JMjY3MC4uLgkyNjcyLi4JMjY3MwkyNjc0Li4JMjY3NgkyNjc3LgkyNjc4LgkyNjc5
CTI2ODEJMjY4My4uLgkyNjg1Li4JMjY4NgkyNjg5CTI2OTEuLgkyNjkyLi4uLgkyNjk0CTI2
OTcuLgkyNjk4CTI3MDAJMjcwMi4uLgkyNzAzCTI3MDQuCTI3MDYJMjcwNy4uLgkyNzEwLi4u
CTI3MTIJMjcxNgkyNzE4CTI3MTkuCTI3MjAJMjcyMgkyNzI2Li4uCTI3MzEuCTI3MzMuCTI3
MzYJMjc0MC4JMjc0MS4JMjc1MAkyNzYwCTI3NjUuCTI3NzQJMjc3OAkyNzgyCTI3OTMJMjc5
NgkyNzk3CTI3OTkJMjgwMQkyODA0CTI4MDcJMjgxMAkyODExCTI4MTIJMjgxNQkyODE2CTI4
MTcJMjgxOC4JMjgyMC4uCTI4MjEuLgkyODIyLi4JMjgyNAkyODI1LgkyODI4CTI4MzAuCTI4
MzIJMjgzMwkyODM2CTI4MzkJMjg0MQkyODQ0CTI4NDcJMjg1MAkyODUyCTI4NTUJMjg1Ngky
ODU5CTI4NjAJMjg2MS4JMjg2MwkyODY1Li4JMjg2NgkyODcwCTI4NzMJMjg3NQkyODc5CTI4
ODIJMjg4NAkyODg4CTI4OTAJMjg5Mi4uCTI4OTYJMjg5OAkyODk5CTI5MDEJMjkwNAkyOTA4
CTI5MTQJMjkxOAkyOTIwLgkyOTIzCTI5MjQJMjkyOAkyOTM3CTI5NDMJMjk0NwkyOTU0Lgky
OTYwCTI5NjEJMjk2NAkyOTY5LgkyOTcxCTI5NzYJMjk3OAkyOTgxLgkyOTgyLgkyOTgzLgky
OTkxCTI5OTIJMjk5NC4JMjk5OAkzMDA2CTMwMTMJMzAxNAkzMDE1CTMwMTYJMzAxNwkzMDIz
CTMwMjQuCTMwMjcJMzAzMgkzMDM1CTMwMzYJMzAzOAkzMDQ3CTMwNDkJMzA1MC4JMzA1NQkz
MDU5CTMwNjMJMzA2NgkzMDY5LgkzMDczCTMwNzUJMzA3NgkzMDc5CTMwODMJMzA4Ny4JMzA4
OC4uCTMwODkJMzA5MAkzMDkxLgkzMDkzCTMwOTQJMzA5OAkzMTAwLgkzMTAxCTMxMDYJMzEx
MgkzMTEzCTMxMTQJMzExNS4JMzEyMAkzMTI1CTMxMjkuLgkzMTM0CTMxMzUJMzEzNwkzMTQw
LgkzMTQyCTMxNDQJMzE0OQkzMTUwCTMxNTQJMzE1NwkzMTU4CTMxNTkJMzE2MgkzMTY2CTMx
NjgJMzE3OAkzMTc5CTMxODAJMzE4MwkzMTkxCTMxOTQJMzE5NQkzMTk2CTMxOTkJMzIwMQkz
MjAzLgkzMjA3LgkzMjEwLgkzMjExCTMyMTMJMzIxNQkzMjE5LgkzMjIxCTMyMjQJMzIzMQkz
MjMyCTMyMzMJMzIzNAkzMjM2CTMyMzkJMzI0MQkzMjQyLgkzMjQ0CTMyNDkJMzI1MgkzMjU2
LgkzMjU3CTMyNjMJMzI3MQkzMjc2CTMyODAJMzI4NQkzMjkwCTMyOTUJMzMwMAkzMzA1CTMz
MDgJMzMxMgkzMzEzCTMzMTUJMzMxNgkzMzIwCTMzMjMuLgkzMzI3CTMzMzEJMzMzMgkzMzM1
CTMzMzcJMzM0NgkzMzQ5CTMzNTIJMzM1My4JMzM1NC4JMzM1NwkzMzU5LgkzMzYyCTMzNzEJ
MzM3MgkzMzczCTMzNzUJMzM3NgkzMzc5CTMzODEuCTMzODIJMzM4MwkzMzg0CTMzODgJMzM5
Ny4JMzM5OAkzNDAzCTM0MTEJMzQxNQkzNDE2LgkzNDIyCTM0MjcJMzQyOS4uCTM0MzUJMzQz
OAkzNDM5CTM0NDEJMzQ0NS4JMzQ0OC4uLgkzNDQ5CTM0NTAJMzQ1MQkzNDUyCTM0NTQJMzQ1
NQkzNDU3CTM0NjcuCTM0NjgJMzQ3NQkzNDc3LgkzNDc4CTM0ODMJMzQ4NAkzNDg4CTM0OTMJ
MzUwMi4JMzUwNAkzNTA2CTM1MTEJMzUxNgkzNTE4CTM1MjAJMzUyMwkzNTI2CTM1MzAJMzUz
NC4uCTM1MzgJMzUzOQkzNTQxCTM1NDMuCTM1NDQJMzU0Ni4JMzU0OS4uLi4JMzU1NAkzNTU1
CTM1NjAJMzU2NQkzNTcxCTM1ODIJMzU4My4uCTM1OTMJMzU5NQkzNTk2LgkzNTk5CTM2MDIJ
MzYwNwkzNjExCTM2MTYJMzYyMAkzNjIxCTM2MjMJMzYyNAkzNjMwCTM2MzkJMzY0MQkzNjQy
CTM2NDYJMzY1Mi4uCTM2NTMJMzY2MgkzNjY5CTM2NzAJMzY3MQkzNjc0CTM2ODAJMzY4Mi4J
MzY4NAkzNjk0LgkzNjk3CTM3MDAuLgkzNzA0CTM3MDgJMzcxMC4uLgkzNzE1Li4JMzcxNwkz
NzE5Li4JMzcyMwkzNzI2LgkzNzI3CTM3MjkJMzczOAkzNzM5CTM3NDIuCTM3NDUuLi4JMzc0
OAkzNzUwLgkzNzUxLgkzNzUzLgkzNzU2CTM3NTkuCTM3NjAJMzc2MwkzNzY3CTM3NjgJMzc2
OQkzNzcwCTM3NzMJMzc4MS4uLi4JMzc4NAkzNzg2CTM3ODgJMzc5MAkzNzkyCTM3OTgJMzgw
MC4JMzgwMQkzODA2CTM4MTIJMzgxOQkzODIwCTM4MzIJMzgzOQkzODQ5CTM4NTQJMzg1OAkz
ODY3CTM4ODAJMzg4NC4JMzg4OQkzOTA5CTM5MTUJMzkxNwkzOTI0CTM5MzYJMzk0NwkzOTUy
CTM5NTcJMzk2NAkzOTgyCTQwMDIJNDAwNAk0MDA4CTQwMTMJNDAzNAk0MDM3Lgk0MDM4CTQw
NDIJNDA1OAk0MDY1CTQwNjcJNDA3Nwk0MDg2CTQwOTYJNDEwNgk0MTEwCTQxMTMJNDExNQk0
MTM0CTQxMzcJNDE0MAk0MTQ0CTQxNjQJNDE2OAk0MTY5CTQxNzMJNDE5Mwk0MjEyCTQyMTQJ
NDIyNgk0MjM4CTQyNDIJNDI1OQk0MjkxCTQyOTkJNDMwMQk0MzExCTQzMjgJNDM0MAk0MzQ2
CTQzNTYJNDM4OQk0Mzk0CTQzOTcJNDQxMgk0NDI5CTQ0MzUuCTQ0MzkJNDQ1Mwk0NDYwCTQ0
NjQJNDQ3Mgk0NDg0Lgk0NDg1CTQ0ODgJNDQ5NQk0NTE0CTQ1MTYJNDUxOAk0NTIxCTQ1MzMJ
NDU2MAk0NTYzCTQ1NzEJNDU3NQk0NjAyCTQ2MTQuCTQ2MTgJNDYyOAk0NjUxCTQ2NTIJNDY1
Mwk0NjcyCTQ2OTIJNDY5Mwk0Njk0CTQ3MDAuCTQ3MTEJNDcxNQk0NzE5CTQ3MjYJNDc0Mwk0
NzQ2CTQ3NTMJNDc1OQk0NzY3CTQ3NjgJNDc3Mwk0NzkwCTQ3OTMJNDc5Nwk0ODI0CTQ4MjYJ
NDgzMgk0ODM1CTQ4NDEJNDg0NQk0ODUzCTQ4NjEJNDg3OAk0ODkyCTQ4OTUJNDkxMgk0OTM1
CTQ5MzYJNDk0Mgk0OTcyCTQ5OTUuLi4uLi4uLi4uCTQ5OTYuLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNDk5Ny4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA3MxtbMG0KLi4uCTUwMDIJNTAzMwk1
MDM4CTUwNDkJNTA2NQk1MDY4Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTUwNjkuLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNTA3MCBTVUNDRVNTCgpCaXNlY3Rpbmc6
IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMp
Cls5NzljMjkyMDVmZmE2MDdjNTliYTJjOWY5YzA4M2I5NjdkMzU2Yzk3XSBicmNtZm1hYzog
QWRkIGRyaXZlIHN0cmVuZ3RoIHByb2dyYW1taW5nIGZvciBTRElPIDQzMTQzLgpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWMyNi0wNjA2L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0y
MDEzMDYwNzAwMTg6OTc5YzI5MjA1ZmZhNjA3YzU5YmEyYzlmOWMwODNiOTY3ZDM1NmM5Nzpi
aXNlY3QtbW0KCjIwMTMtMDYtMTMtMDU6MDE6NTYgOTc5YzI5MjA1ZmZhNjA3YzU5YmEyYzlm
OWMwODNiOTY3ZDM1NmM5NyBjb21waWxpbmcKNDAwIHJlYWwgIDE2MjAgdXNlciAgMTM5IHN5
cyAgNDM5LjEyJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2ChtbMTszNW1hZGRf
dG9fcnVuX3F1ZXVlOiByZXF1ZXN0ZWQgNTA3MCwgbGltaXQgdG8gNTAwMBtbMG0KCjIwMTMt
MDYtMTMtMDU6MDg6NTggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAtcmMxLTAwNzY5LWc5
NzljMjkyLi4uCTEJNC4JOAkxMS4JMTYJMTguCTIwCTIzCTI2CTMxCTMyLgk0MQk0Mwk0Nwk0
OAk1MAk1Ngk3NAk3OC4uCTgwCTg4Li4uCTkyCTk4Li4JMTAwCTEwMQkxMDIuLgkxMDkuLi4J
MTE1CTExNwkxMTguLgkxMjAJMTIzCTEyNgkxMjcJMTMwCTEzNAkxNDAJMTQ0CTE0NgkxNTEJ
MTU3CTE1OAkxNTkJMTYzCTE3MQkxNzkJMTgzCTE4NAkxODgJMTk3CTE5OS4uCTIwMC4JMjA1
CTIwNwkyMDgJMjA5CTIxOAkyMjUJMjQwCTI0MQkyNDMuLgkyNTQJMjU3CTI2NgkyNzAJMjc3
CTI3OAkyNzkuCTI4NAkyODYJMjg4Li4JMjkyCTMwMAkzMDEuLgkzMDIJMzAzCTMwOAkzMTIJ
MzE5CTMyMwkzMzAuCTMzMQkzMzIJMzQ3CTM0OC4JMzUxCTM1NAkzNTUJMzYwLgkzNjMJMzcy
CTM3NC4JMzc5CTM4NAkzODgJMzg5CTM5MAkzOTMJMzk5CTQwNQk0MDkJNDExCTQxMwk0MTkJ
NDIyCTQyNgk0MzkJNDQ2Lgk0NDgJNDU1CTQ2Nwk0NzEJNDcyCTQ3Ngk0ODUuCTQ4OQk0OTAu
CTQ5OAk1MDYJNTA4CTUxMQk1MTMJNTIwCTUyMQk1MjMJNTI0CTUyNgk1MjcJNTMxCTUzMwk1
MzQJNTQwCTU0Mgk1NDUJNTQ2CTU0Nwk1NDgJNTUzLgk1NTcJNTYwCTU2Mgk1NjMJNTY2CTU2
OQk1NzEJNTc3CTU4NQk1ODgJNTkzCTU5Nwk2MDIJNjA5Lgk2MTEJNjE0CTYxNQk2MTcJNjE4
CTYxOS4JNjIwCTYyMQk2MjMuLgk2MzIJNjM3CTY0MS4JNjQ0CTY1Mwk2NTgJNjYwCTY2NQk2
NzMJNjc2CTY3OAk2ODMJNjkwCTY5Mgk2OTYJNjk4CTcxMgk3MTMuLgk3MTQJNzIwLgk3MjIJ
NzI0Lgk3MjgJNzI5CTczMAk3MzIJNzMzCTczNAk3MzgJNzQyCTc0NQk3NDYJNzUxLgk3NTQJ
NzU4CTc2MQk3NjIJNzY0CTc3MS4uLgk3NzUuCTc3Nwk3ODMJNzg3CTc5MAk3OTYJODA2CTgx
MC4uLgk4MTMJODE1CTgyNAk4MjkJODM2CTgzOQk4NDAJODQ0CTg1MAk4NTYJODYxCTg2Mi4J
ODY0CTg2NQk4NjcJODY5Li4uLgk4NzAJODcxCTg3NAk4NzUJODc2CTg4MQk4ODgJODg5CTg5
Mgk4OTQJOTAzCTkwNwk5MTYJOTE3CTkyMAk5MjIJOTI1CTkyOS4JOTMwCTkzNwk5MzkJOTQy
CTk0Mwk5NDcJOTUxCTk1OC4uCTk1OS4JOTY0Lgk5NjUuLgk5NjguLgk5NjkJOTcxCTk3Mgk5
NzUJOTc3CTk3OAk5ODEJOTg0Lgk5OTQJMTAwMgkxMDA0CTEwMDkJMTAxNQkxMDE5CTEwMjAJ
MTAyMwkxMDI1LgkxMDMzCTEwMzYJMTAzNwkxMDM5CTEwNDEJMTA0NQkxMDQ2CTEwNDgJMTA1
MAkxMDUzLgkxMDU0LgkxMDU4CTEwNjIJMTA2MwkxMDY0CTEwNjcJMTA2OAkxMDcwCTEwNzQJ
MTA3NgkxMDc3CTEwNzgJMTA4Ny4uCTEwOTIJMTA5NS4JMTA5NgkxMDk5CTExMDQJMTEwNwkx
MTEwCTExMTMuCTExMjAJMTEyMgkxMTI3CTExMzEJMTEzOAkxMTQ3CTExNTAJMTE1NgkxMTYx
CTExNjQJMTE4MAkxMTgzCTExOTYJMTE5NwkxMjAwLgkxMjAxCTEyMTAJMTIyMAkxMjIxLi4J
MTIzMgkxMjM2LgkxMjM3CTEyMzgJMTI0NAkxMjQ4CTEyNDkuCTEyNTAJMTI1MQkxMjU0CTEy
NTYuCTEyNTkJMTI2MAkxMjYzCTEyNzIJMTI4MgkxMjgzCTEyODYJMTI4OQkxMjkxCTEyOTIJ
MTI5MwkxMjk2CTEyOTgJMTMwMwkxMzA0CTEzMDUJMTMxNAkxMzE5CTEzMjEJMTMyMwkxMzI1
CTEzMjcJMTMzMQkxMzMzLgkxMzM0CTEzMzUJMTMzNwkxMzM4CTEzNDIuCTEzNDQJMTM1MAkx
MzU2CTEzNTcJMTM1OQkxMzY2LgkxMzY5CTEzNzYuLgkxMzc3CTEzODIJMTM4OS4JMTM5MAkx
MzkyCTEzOTcJMTM5OAkxNDAzCTE0MDYJMTQwOQkxNDE1CTE0MTYuCTE0MTcJMTQxOQkxNDIw
LgkxNDIxLi4JMTQyMi4uCTE0MjMJMTQyNQkxNDI5CTE0MzIJMTQzNAkxNDM2CTE0NDAJMTQ0
MQkxNDQyCTE0NDMJMTQ0NQkxNDQ2CTE0NDgJMTQ1MAkxNDUzCTE0NTQJMTQ1NwkxNDU4CTE0
NTkuCTE0NjEuLi4JMTQ2OAkxNDcxCTE0NzgJMTQ4MwkxNDg2CTE0ODcJMTQ4OQkxNDkzCTE1
MDEJMTUwOAkxNTE0CTE1MTUJMTUxOAkxNTI1CTE1MzcJMTU0MAkxNTQyCTE1NDMJMTU0Ngkx
NTQ5CTE1NTIJMTU1NgkxNTYwCTE1NjIJMTU2NAkxNTY1CTE1NjYJMTU2NwkxNTc0CTE1NzkJ
MTU4MQkxNTg3CTE1ODkJMTU5NgkxNjE0CTE2MjMJMTYyOAkxNjMwCTE2MzIJMTYzNgkxNjM3
CTE2NDUJMTY1MwkxNjU5LgkxNjYzCTE2NjUJMTY2OAkxNjc5CTE2ODAJMTY4MQkxNjgzCTE2
ODgJMTcwMC4JMTcwMwkxNzA4CTE3MTUJMTcyNS4JMTcyNgkxNzMyCTE3MzQJMTc0MgkxNzQ3
CTE3NTQJMTc1NgkxNzU5CTE3NjIJMTc2NQkxNzcxCTE3NzIJMTc3OQkxNzgxCTE3ODMJMTc4
Ny4JMTc4OQkxNzkzLgkxODAxCTE4MDUJMTgwNwkxODExLgkxODE3CTE4MjEJMTgyMgkxODI0
CTE4MjUJMTgyNwkxODMwCTE4NDEJMTg0MgkxODQzCTE4NDQJMTg0NgkxODQ5CTE4NTEuCTE4
NTQJMTg2MAkxODY0CTE4NjkJMTg3MQkxODcyCTE4NzMJMTg3NgkxODc4CTE4ODAJMTg4Mgkx
ODgzLgkxODg0CTE4ODgJMTg5MwkxODk2CTE4OTcJMTkwMQkxOTAyCTE5MDcJMTkwOQkxOTEz
CTE5MTQJMTkxNQkxOTIwCTE5MjEJMTkyMwkxOTI2CTE5MjgJMTkzMgkxOTM1CTE5NDEJMTk0
NwkxOTUwLgkxOTUxCTE5NTQJMTk1NQkxOTY0CTE5NjUJMTk2OS4JMTk3MAkxOTc0CTE5NzYJ
MTk4MQkxOTgyLi4JMTk5MgkxOTk2CTE5OTcuLgkyMDAwCTIwMDIJMjAxMAkyMDEyCTIwMTMJ
MjAxNwkyMDIxCTIwMjIuCTIwMjUJMjAyOS4uLi4JMjAzMQkyMDM0CTIwMzguCTIwNDEJMjA0
Mi4JMjA0NQkyMDQ3CTIwNTAJMjA1MS4JMjA1MgkyMDU3CTIwNjMJMjA2NS4JMjA2OQkyMDcy
CTIwNzMJMjA3Ni4uCTIwODAJMjA4MgkyMDgzCTIwODQuLgkyMDg1Li4uCTIwODYuCTIwODkJ
MjA5MAkyMDkxLgkyMDkzCTIwOTQuLgkyMDk1Li4JMjA5NgkyMDk3Li4uCTIwOTguCTIxMDAu
CTIxMDEuCTIxMDIJMjEwNAkyMTA3Li4JMjEwOAkyMTEwCTIxMTEJMjExNQkyMTE3CTIxMjIJ
MjEyNgkyMTM0CTIxNDAJMjE0MS4uLgkyMTQ3LgkyMTQ5CTIxNTEJMjE1MgkyMTU2CTIxNTgJ
MjE1OS4JMjE2NAkyMTY2CTIxNjkuCTIxNzEJMjE3My4uCTIxNzUuLgkyMTc2CTIxNzcJMjE3
OC4JMjE4MAkyMTg2LgkyMTg3LgkyMTg5CTIxOTAuLi4JMjE5MQkyMTk2LgkyMTk3LgkyMjAw
CTIyMDQJMjIwNQkyMjA3LgkyMjEwCTIyMTMuCTIyMTcJMjIxOQkyMjIzCTIyMzAJMjIzMi4J
MjIzNAkyMjM5CTIyNDAJMjI0MQkyMjQyCTIyNDQuLi4JMjI0NQkyMjQ3Li4uLi4JMjI0OAky
MjQ5Li4uCTIyNTAuLgkyMjUyCTIyNTMJMjI1NQkyMjU2CTIyNTcuCTIyNTgJMjI1OS4uLi4u
CTIyNjAuLgkyMjYyLgkyMjYzCTIyNjQJMjI2NS4JMjI2Ny4JMjI2OAkyMjY5CTIyNzAJMjI3
MS4uLi4JMjI3My4JMjI3NAkyMjc2CTIyODIJMjI4NwkyMjkyCTIzMDAuCTIzMDEJMjMwNgky
MzExCTIzMTUJMjMyMAkyMzIyCTIzMzEJMjMzMwkyMzQyCTIzNDcJMjM1NAkyMzU1CTIzNjYJ
MjM3MwkyMzc0CTIzODQJMjM5MwkyNDAyCTI0MDUJMjQxNC4JMjQyMgkyNDMxCTI0NTIJMjQ1
NwkyNDYxCTI0NjQJMjQ2NwkyNDc5CTI0ODAJMjQ4MgkyNDg0Li4JMjQ4OAkyNDkwCTI0OTEJ
MjQ5NAkyNTAxLgkyNTAyCTI1MDQuCTI1MDYJMjUwOC4uLgkyNTExCTI1MjIJMjUyMy4JMjUy
NC4JMjUzMAkyNTMzCTI1MzYJMjUzNy4JMjUzOAkyNTQwCTI1NDEuCTI1NDUJMjU0NgkyNTU5
CTI1NjQJMjU3MAkyNTc5CTI1ODMJMjU4NwkyNTkyCTI2MTMuCTI2MTcJMjYyMS4JMjYyNwky
NjM2LgkyNjM3CTI2NDAuCTI2NDEJMjY0OC4uCTI2NDkuCTI2NTMuLi4JMjY1Ni4uCTI2NTgJ
MjY2MAkyNjY2CTI2NzEJMjY3My4JMjY3NgkyNjc3CTI2ODAJMjY4MQkyNjg0CTI2ODgJMjY5
MQkyNjkzLi4JMjcwOQkyNzE1CTI3MTYJMjcxOAkyNzIxCTI3MjMJMjczMAkyNzMzCTI3MzYu
CTI3MzcJMjc0NAkyNzQ2CTI3NDcJMjc1MgkyNzU4CTI3NjMJMjc3MQkyNzc1CTI3NzYJMjc4
MAkyNzgzLgkyNzg2CTI3ODkJMjc5MgkyNzkzLgkyODAyCTI4MjAJMjgyOAkyODM0CTI4NDEu
CTI4NTgJMjg2MwkyODY0CTI4NjUuCTI4NjYJMjg3OQkyODkwCTI4OTEJMjg5NAkyODk1CTI4
OTkJMjkwNwkyOTA4CTI5MTkJMjkyMQkyOTIyCTI5MzAJMjkzOS4JMjk0MAkyOTQzCTI5NTgJ
Mjk3MgkyOTc3LgkyOTc4CTI5ODEJMjk4NwkyOTkwCTI5OTgJMzAwNgkzMDE1CTMwMjcJMzAz
MwkzMDM5CTMwNDEJMzA1NQkzMDU2CTMwNTkJMzA2OAkzMDczCTMwODIJMzA4NwkzMTAxCTMx
MTAJMzExNAkzMTE3CTMxMjUJMzEzMQkzMTM3CTMxNDMJMzE1NQkzMTU4CTMxOTAJMzIwMAkz
MjEzCTMyMTUJMzIyMwkzMjI0CTMyMzgJMzI1MwkzMjYwCTMyNzYJMzI4OQkzMzA3CTMzMjEJ
MzMyOQkzMzMzCTMzMzQJMzMzOAkzMzQyCTMzNDMJMzM0NgkzMzU3CTMzNTgJMzM2MQkzMzY1
CTMzNjkJMzM3NwkzMzg5CTMzOTUJMzM5NgkzNDAzCTM0MTQJMzQxNQkzNDIyCTM0MjQJMzQy
NgkzNDMzCTM0MzgJMzQ0NQkzNDQ4CTM0NTEJMzQ1NwkzNDYxCTM0NzMJMzQ4NgkzNDkyCTM0
OTUJMzUwMAkzNTAzCTM1MDkJMzUxOQkzNTI5CTM1MzAJMzUzMy4JMzUzNAkzNTM2CTM1MzkJ
MzU0NC4JMzU1MAkzNTUxCTM1NjEJMzU2OAkzNTcyLgkzNTczCTM1NzQJMzU3NwkzNTc4CTM1
ODMJMzU4NwkzNTg4CTM1OTQJMzYwMAkzNjAzCTM2MDYJMzYxNAkzNjIwCTM2MjIJMzYyOQkz
NjMwCTM2MzMuCTM2MzQJMzYzNwkzNjQ0LgkzNjQ2CTM2NDgJMzY1MgkzNjU0CTM2NTUuCTM2
NTcJMzY1OS4JMzY2OAkzNjczCTM2NzUuCTM2ODYJMzY5MwkzNjk5CTM3MDQJMzcwNgkzNzA4
CTM3MTEJMzcxNAkzNzIxCTM3MjcJMzcyOQkzNzMwCTM3MzEJMzc0MgkzNzQ0Li4JMzc0NQkz
NzQ2CTM3NTQJMzc1OAkzNzcwCTM3NzMJMzc3OQkzNzg2CTM3OTEuCTM3OTQuCTM3OTYJMzgw
MgkzODAzCTM4MDQuLgkzODA2CTM4MDkJMzgxNC4JMzgxNwkzODE4CTM4MTkJMzgyMQkzODI0
CTM4MjcuCTM4MjkJMzgzMgkzODM0CTM4MzYJMzgzOAkzODQxCTM4NDIuLgkzODQ3CTM4NTQJ
Mzg1NQkzODU3CTM4NjAJMzg2MgkzODY3CTM4NzAJMzg3MQkzODcyCTM4NzQJMzg3NQkzODc5
CTM4ODAJMzg4MS4JMzg4MwkzODg0LgkzODg1Li4JMzg4OC4JMzg4OQkzODkwLgkzODkxLi4J
Mzg5NQkzODk5LgkzOTAwCTM5MDYJMzkxMAkzOTExCTM5MTIJMzkxMwkzOTE2CTM5MTguLgkz
OTE5CTM5MjIJMzkyMwkzOTI2CTM5MjkJMzkzMAkzOTMyCTM5MzQJMzkzOC4JMzk0MAkzOTQ0
CTM5NTIJMzk1NwkzOTYyLgkzOTcwLgkzOTcyCTM5NzQJMzk3NQkzOTc3CTM5ODAJMzk4NQkz
OTkwLgkzOTk2CTQwMDYJNDAwOAk0MDE0CTQwMjUJNDAyOAk0MDMyCTQwMzcJNDA0NQk0MDUw
CTQwNTYJNDA2NQk0MDc2CTQwODIJNDA4OAk0MDk0CTQxMDgJNDExMgk0MTI3CTQxMzcJNDE0
NAk0MTQ5CTQxNTgJNDE2Mgk0MTcwCTQxNzIJNDE3OAk0MTg1CTQxOTEJNDE5Mwk0MjAwCTQy
MDguCTQyMTAJNDIxMwk0MjE3CTQyMjEJNDIyOQk0MjM2CTQyMzgJNDI0Nwk0MjUzCTQyNjEJ
NDI2NAk0MjY4CTQyNzIuCTQyNzUJNDI3Ngk0Mjc3CTQyNzgJNDI4MQk0MjgzCTQyODQJNDI4
NS4JNDI4Ngk0MjkwCTQyOTEJNDI5My4JNDI5Ngk0Mjk3Lgk0Mjk5CTQzMDEJNDMwNC4uLgk0
MzA2CTQzMDcJNDMwOAk0MzExCTQzMTMuLgk0MzE2CTQzMjEJNDMyNwk0MzM0CTQzNDAJNDM0
NQk0MzUxCTQzNTYJNDM2MQk0MzYzCTQzNjQJNDM2Nwk0MzY5CTQzNzMuCTQzODgJNDM5Mgk0
Mzk0CTQzOTUJNDM5OAk0NDAxCTQ0MTIJNDQyMgk0NDIzCTQ0MzEJNDQ0MAk0NDUyCTQ0NTQJ
NDQ1OQk0NDY1CTQ0NzAJNDQ3NAk0NDgwCTQ0ODcJNDQ5Nwk0NTAxCTQ1MDUJNDUxMAk0NTE2
CTQ1MjAJNDUyNAk0NTM0CTQ1MzcJNDU0OAk0NTUyLgk0NTU3CTQ1NjYJNDU3MAk0NTc1CTQ1
NzYJNDU4Mwk0NTg4CTQ1OTEJNDU5NQk0NTk5CTQ2MDAJNDYwNAk0NjA2CTQ2MDkJNDYxMQk0
NjEyCTQ2MTMuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk0NjE0Li4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNDYxNQk0NjE2Li4JNDYxNy4JNDYxOAk0NjE5
CTQ2MjAuLgk0NjIxLi4JNDYyMgk0NjIzLgk0NjI1Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk0NjI2Li4u
CTQ2MjcuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5f
cXVldWUgNDQzG1swbQouLi4uLi4JNDYyOAk0NjI5CTQ2MzAuLi4uLgk0NjMxLi4uCTQ2MzIJ
NDYzMy4uLi4JNDYzNC4JNDYzNS4JNDYzNi4JNDYzOC4JNDY0MAk0NjQxCTQ2NDMJNDY0NAk0
NjQ4CTQ2NTMJNDY1NQk0NjYyCTQ2NjYJNDY2Ny4uLi4uLgk0Njg0CTQ2ODUuLi4JNDY4Nwk0
Njg5CTQ2OTAJNDY5MQk0NjkzCTQ2OTQuCTQ2OTUuLi4JNDY5Ny4uLgk0Njk4Li4uLi4uLgk0
Njk5Lgk0NzAyLi4JNDcwMwk0NzA2CTQ3MTAuLgk0NzEyCTQ3MTUJNDcxNi4JNDcyMgk0NzI1
CTQ3MjcJNDczMAk0NzMyLgk0NzMzLgk0NzM2CTQ3MzcJNDczOAk0NzQwLgk0NzQyLi4JNDc0
My4uLgk0NzQ0CTQ3NDcJNDc0OQk0NzUxLi4uLi4uLi4uLgk0NzUyLi4JNDc1My4JNDc1NAk0
NzU2Li4uLgk0NzU3Li4JNDc1OC4JNDc1OQk0NzYwLi4uLi4JNDc2MS4uCTQ3NjIuCTQ3NjMu
CTQ3NjUuLi4uLi4uLgk0NzY2Li4uLi4uLgk0NzY3Li4JNDc2OC4uLi4uLi4uCTQ3NjkuLi4u
Li4uLgk0NzcwLgk0NzcxLi4uLi4uCTQ3NzIuCTQ3NzMJNDc3NAk0Nzc1Lgk0Nzc2Lgk0Nzc3
Li4uLi4uLi4uLi4uLi4uLi4uLi4JNDc3OC4uLi4uLi4uLi4uLi4uCTQ3NzkuLi4uLi4uLgk0
NzgwLi4uLi4uLi4uCTQ3ODEuLi4uLi4uLi4uLi4JNDc4Mgk0NzgzCTQ3ODQuLgk0Nzg1Li4u
Li4JNDc4Ni4uCTQ3ODcuLi4uLgk0Nzg5CTQ3OTAJNDc5MQk0NzkzLi4uLgk0Nzk0Lgk0Nzk2
Li4uCTQ3OTcuCTQ3OTgJNDgwMS4uLi4uLi4uLgk0ODAyLi4uLi4uLi4uLi4uCTQ4MDMuLgk0
ODA0Li4JNDgwNS4uLi4uLi4uLi4uLi4JNDgwNi4JNDgwNy4JNDgwOC4JNDgwOS4uLi4uLgk0
ODEwLi4uCTQ4MTEJNDgxMwk0ODE0Lgk0ODE1CTQ4MTgJNDgxOQk0ODIwLgk0ODIxLi4uCTQ4
MjIJNDgyMy4uCTQ4MjQuCTQ4MjYuCTQ4MjcuLi4uLgk0ODI4Li4JNDgzMC4JNDgzMS4uLi4u
Li4JNDgzMi4uLi4uLgk0ODM0CTQ4MzUuCTQ4MzYJNDgzNwk0ODM4Li4uLi4uLi4JNDgzOS4u
Lgk0ODQxLi4uCTQ4NDIuLi4uCTQ4NDMJNDg0NAk0ODQ1CTQ4NDcuLgk0ODQ5Li4uCTQ4NTAJ
NDg1Mi4JNDg1NAk0ODU2Li4JNDg1OC4JNDg1OQk0ODYwLgk0ODYxCTQ4NjIJNDg2Mwk0ODY0
CTQ4NjYJNDg2Ny4JNDg2OS4JNDg3MQk0ODcyLi4JNDg3NC4JNDg3Nwk0ODgwCTQ4ODEJNDg4
Mwk0ODg0CTQ4ODkJNDg5MC4uCTQ4OTIJNDg5Mwk0OTAzLgk0OTA5CTQ5MTEJNDkxMgk0OTE0
Lgk0OTE5Lgk0OTIxLgk0OTI1Lgk0OTI2CTQ5MjcJNDkyOQk0OTMxLgk0OTM1CTQ5NDAJNDk0
MQk0OTQyLgk0OTQzLgk0OTQ3CTQ5NDkuCTQ5NTAJNDk1Mgk0OTU0CTQ5NTUJNDk1Ngk0OTU4
CTQ5NTkuLgk0OTYxCTQ5NjMJNDk2NQk0OTY2CTQ5NjkuLi4uLgk0OTcxLgk0OTcyCTQ5NzUJ
NDk3Ni4uCTQ5NzcJNDk3OQk0OTgwLi4JNDk4MQk0OTg1Lgk0OTg2Lgk0OTg3CTQ5OTEJNDk5
Mgk0OTk1CTUwMDEJNTAwNQk1MDA4CTUwMTEJNTAxMgk1MDE0CTUwMTYJNTAyMQk1MDIyCTUw
MjQuCTUwMjYuLi4JNTAyOC4JNTAyOS4JNTAzMQk1MDM1CTUwMzgJNTA0MAk1MDQxCTUwNDQJ
NTA0NQk1MDQ2CTUwNDkJNTA1MC4JNTA1My4JNTA1NC4JNTA1OC4JNTA2MAk1MDYyLi4uCTUw
NjMJNTA2NS4JNTA2Nwk1MDY4CTUwNzEgU1VDQ0VTUwoKNjY4NzYxYWMwMWQ2ZjVhMzZiOGU1
YTI0ZDRlMTU0NTUwZTJjNGMzYiBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgNjY4
NzYxYWMwMWQ2ZjVhMzZiOGU1YTI0ZDRlMTU0NTUwZTJjNGMzYgpBdXRob3I6IEhhbnRlIE1l
dWxlbWFuIDxtZXVsZW1hbkBicm9hZGNvbS5jb20+CkRhdGU6ICAgRnJpIEFwciAxMiAxMDo1
NTo1NSAyMDEzICswMjAwCgogICAgYnJjbWZtYWM6IGRlZmluZSBhbmQgdXNlIHBsYXRmb3Jt
IHNwZWNpZmljIGRhdGEgZm9yIFNESU8uCiAgICAKICAgIFRoaXMgcGF0Y2ggYWRkcyBzdXBw
b3J0IGZvciBwbGF0Zm9ybSBzcGVjaWZpYyBkYXRhIGZvciBTRElPCiAgICBmdWxsbWFjIGRl
dmljZXMuIEN1cnJlbnRseSBPT0IgaW50ZXJydXB0cyBhcmUgY29uZmlndXJlZCBieSBLY29u
ZmlnCiAgICBCUkNNRk1BQ19TRElPX09PQiBidXQgdGhhdCBpcyBub3cgZGV0ZXJtaW5lZCBk
eW5hbWljYWxseSBieSBjaGVja2luZwogICAgYXZhaWxpYmlsaXR5IG9mIHBsYXRmb3JtIGRh
dGEuCiAgICAKICAgIENjOiBIYXVrZSBNZWhydGVucyA8aGF1a2VAaGF1a2UtbS5kZT4KICAg
IFJldmlld2VkLWJ5OiBBcmVuZCBWYW4gU3ByaWVsIDxhcmVuZEBicm9hZGNvbS5jb20+CiAg
ICBSZXZpZXdlZC1ieTogRnJhbmt5IChaaGVuaHVpKSBMaW4gPGZyYW5reWxAYnJvYWRjb20u
Y29tPgogICAgUmV2aWV3ZWQtYnk6IFBpZXRlci1QYXVsIEdpZXNiZXJ0cyA8cGlldGVycGdA
YnJvYWRjb20uY29tPgogICAgUmV2aWV3ZWQtYnk6IFBpb3RyIEhhYmVyIDxwaGFiZXJAYnJv
YWRjb20uY29tPgogICAgU2lnbmVkLW9mZi1ieTogSGFudGUgTWV1bGVtYW4gPG1ldWxlbWFu
QGJyb2FkY29tLmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6IEFyZW5kIHZhbiBTcHJpZWwgPGFy
ZW5kQGJyb2FkY29tLmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6IEpvaG4gVy4gTGludmlsbGUg
PGxpbnZpbGxlQHR1eGRyaXZlci5jb20+Cgo6MDQwMDAwIDA0MDAwMCA2MmNlZTM5ZTFmNmY0
MGJkZTNiNjBiZDQ4YzgwZGMxYWNjNTFmODUxIGZiYmNkZTg3OTI1ZGRjZTZiNmI1YjIxMjQ2
ZDgzNTJkYzJlYmRhOTUgTQlkcml2ZXJzCjowNDAwMDAgMDQwMDAwIGZlODk5ZjQ0NDEzZmQ0
ZjhhYTk5MGUyMWFkMWZkMDA3NTZiOGZhMjggNjQwZTBiY2U4OTM5YjczMTk5M2MxZmQ4MmI1
NjY0NjE1NmFkYTY3MyBNCWluY2x1ZGUKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi9saW51
eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDcwMDE4Ojk3OWMyOTIwNWZmYTYw
N2M1OWJhMmM5ZjljMDgzYjk2N2QzNTZjOTc6YmlzZWN0LW1tCgoyMDEzLTA2LTE0LTA0OjQ1
OjA0IDk3OWMyOTIwNWZmYTYwN2M1OWJhMmM5ZjljMDgzYjk2N2QzNTZjOTcgcmV1c2UgL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi85NzljMjkyMDVmZmE2MDdjNTliYTJj
OWY5YzA4M2I5NjdkMzU2Yzk3L3ZtbGludXotMy45LjAtcmMxLTAwNzY5LWc5NzljMjkyChtb
MTszNW1hZGRfdG9fcnVuX3F1ZXVlOiByZXF1ZXN0ZWQgMTUyMTAsIGxpbWl0IHRvIDUwMDAb
WzBtCgoyMDEzLTA2LTE0LTA0OjQ1OjA4IGRldGVjdGluZyBib290IHN0YXRlIAk0CTcJOAkx
MgkyMAkyNgkzMC4JMzIJMzMJMzYJMzkJNDEJNDQuLgk0NQk0OAk0OQk1MQk1Mgk1Ni4uLgk1
Ny4uCTU4Li4JNTkuCTYwLgk2MQk2Mi4uCTYzCTY0CTY2CTY5CTcwCTcxCTcyCTc1Lgk3Ny4J
ODAJODEuCTgzCTg3Li4JODgJOTIJOTUJOTcuCTk5LgkxMDEJMTAyCTEwMwkxMDUJMTA2Lgkx
MDcJMTA4CTEwOS4uCTExMC4JMTEyCTExNS4uCTExNi4JMTE4CTExOS4uCTEyMC4uLi4uLi4u
Li4uLi4uCTEyMS4uLi4uLi4JMTI4CTEzMAkxMzIuCTEzNS4JMTM3CTEzOC4uCTE0MC4uLi4u
Li4JMTQxLi4JMTQzLgkxNDUuCTE0NgkxNDgJMTUwCTE1MS4JMTUyLi4uCTE1NQkxNTYJMTU3
CTE1OC4JMTYwCTE2MQkxNjIuLgkxNjMJMTY1CTE2Ny4uCTE2OAkxNzAuCTE3MS4JMTczLgkx
NzQuLi4JMTc1Li4uCTE3Ni4uLgkxNzguLgkxODEuCTE4MgkxODMuLgkxODQuCTE4NQkxODYJ
MTg3LgkxOTAuLgkxOTEJMTk0LgkxOTYuLgkyMDAJMjAxLgkyMDIJMjAzLi4uCTIwNgkyMDcJ
MjA4CTIxMC4uCTIxMwkyMTQuCTIxNgkyMTcuCTIxOQkyMjAJMjIyLi4uLi4uLgkyMjQJMjI2
LgkyMjcJMjI5Li4uLi4uLi4uLgkyMzAJMjMxCTIzMgkyMzQuLgkyMzUuCTIzNgkyMzcuCTIz
OC4uCTI0MC4JMjQxCTI0MgkyNDQJMjQ1LgkyNDYJMjQ3Li4JMjQ5CTI1MS4uLi4uLi4uLgky
NTIuLi4JMjUzLi4JMjU0Li4JMjU1CTI1Ni4uCTI1OC4uLi4uLi4JMjYwCTI2MS4uLi4JMjYy
LgkyNjQuLgkyNjYuCTI2OQkyNzIuLgkyNzMJMjc0LgkyNzUJMjc2CTI3OAkyNzkuLi4JMjgz
Li4uLgkyODQuCTI4NS4JMjg3LgkyOTAuCTI5MQkyOTIuLi4uLi4uCTI5My4JMjk0Li4JMjk1
Li4uCTI5NwkyOTgJMjk5LgkzMDAJMzAxLi4JMzAyCTMwMwkzMDQuLi4JMzA2Li4uLi4JMzA3
Li4uLi4uLi4JMzA5CTMxMQkzMTIJMzE0LgkzMTUuCTMxNy4uLgkzMTgJMzIwLi4JMzIxCTMy
MwkzMjYJMzI3CTMyOC4JMzMwCTMzMS4JMzMyCTMzMwkzMzQJMzM1CTMzNwkzMzgJMzM5CTM0
MAkzNDEJMzQyCTM0NS4JMzQ2CTM0OAkzNTAJMzU0CTM1Ny4uCTM1OQkzNjIJMzYzCTM2Ngkz
NzMJMzc4CTM3OQkzODQJMzg4CTM5Ngk0MDUJNDA3CTQwOQk0MTQJNDE4CTQxOS4uCTQyMAk0
MjUJNDI2CTQyOAk0MzEJNDMyCTQzNAk0MzcJNDQwCTQ0Mi4JNDQzCTQ0NAk0NDYJNDQ4CTQ1
MAk0NTIJNDU2CTQ1Nwk0NjAuLgk0NjYuCTQ2Nwk0NjgJNDczCTQ3OAk0NzkJNDg5CTQ5Mwk0
OTQJNDk3CTQ5OAk1MDQJNTA1CTUwNgk1MDgJNTE4CTUyMAk1MjMJNTI0CTUyOQk1MzEJNTMy
CTUzOAk1NDAJNTQ0CTU0Nwk1NDkJNTUwCTU1Mgk1NTMJNTU2CTU1Nwk1NjEuCTU2Mgk1NjMJ
NTY1CTU2Nwk1NjgJNTcxCTU3NAk1NzYJNTc4CTU4MAk1ODMJNTg1CTU4Ni4JNTg3Lgk1ODkJ
NTk2CTU5Nwk1OTkJNjAwCTYwNwk2MTUJNjE5CTYyOC4JNjM0CTYzOAk2MzkuCTY0MAk2NDMJ
NjQ0CTY0OAk2NTEJNjU1CTY1Ngk2NTkJNjYyCTY2OQk2NzAJNjcxCTY3OAk2ODAJNjgxCTY4
Ny4JNjg5CTY5MQk2OTQJNjk2CTY5Nwk3MDAJNzAyCTcwMwk3MDcJNzA5CTcxMQk3MTQJNzI0
CTcyOAk3MjkJNzMzCTczOAk3NDQJNzQ1Lgk3NDcJNzUwCTc1NAk3NTYuCTc1OQk3NjIJNzY2
CTc2OAk3NzAJNzc4CTc3OS4uCTc4Mwk3ODQJNzkwCTc5Mi4JNzk1CTc5OAk4MDAJODAyCTgw
NQk4MDYJODEwCTgyMgk4MjQJODI2CTgyOAk4MzEJODM4CTgzOQk4NDAJODQ0CTg1MAk4NTYJ
ODY2CTg2Nwk4NzAJODc3CTg3OAk4NzkJODgyCTg5MQk4OTcJOTAwCTkwNAk5MDcJOTExCTkx
Mwk5MTQJOTE5CTkyMgk5MzAJOTM0CTkzOAk5NDQuCTk0Nwk5NTAJOTUxCTk1Nwk5NjEJOTY5
CTk3Mwk5NzYJOTgzCTk4OQk5OTQJMTAwMQkxMDA0CTEwMTAJMTAxMgkxMDE0CTEwMTYJMTAx
OAkxMDE5CTEwMjIJMTAyMwkxMDI4LgkxMDMyLgkxMDM3CTEwMzkJMTA0Mi4JMTA0My4JMTA0
NQkxMDQ5CTEwNTAJMTA1NQkxMDU5CTEwNjMJMTA2OQkxMDcxCTEwNzkJMTA4OAkxMDkyCTEx
MDUJMTEwOAkxMTEyCTExMTgJMTEyNwkxMTMwCTExMzQJMTE0MQkxMTQ5CTExNTEJMTE1NQkx
MTYyCTExNjMJMTE3MgkxMTczCTExNzYJMTE4NAkxMTg5CTExOTgJMTE5OQkxMjAzCTEyMTAJ
MTIxMwkxMjIxLgkxMjI1CTEyMjkJMTIzMgkxMjM2CTEyMzkJMTI0NgkxMjUxCTEyNTYuCTEy
NjcJMTI3MgkxMjc1CTEyNzguCTEyODAJMTI4NAkxMjg1CTEyOTMJMTMwMQkxMzA1CTEzMDcJ
MTMxNAkxMzE2CTEzMjQJMTMyNQkxMzI2CTEzMjgJMTMzMAkxMzM0CTEzMzUJMTMzNy4uCTEz
MzgJMTM0MAkxMzQ0CTEzNDcJMTM1MwkxMzU0CTEzNjAJMTM2MwkxMzY0CTEzNjUuCTEzNzEu
CTEzNzIJMTM3MwkxMzc4CTEzODIJMTM4NAkxMzg4CTEzODkJMTM5NQkxNDAzCTE0MDcJMTQx
MQkxNDEzCTE0MjAJMTQyMi4JMTQyMwkxNDMyCTE0MzQJMTQzNgkxNDM3CTE0NDUJMTQ1Mwkx
NDYzCTE0NjYJMTQ2OAkxNDczCTE0NzQJMTQ3NQkxNDgxCTE0ODYJMTQ4OAkxNDkxCTE0OTYJ
MTQ5NwkxNDk5CTE1MDUJMTUwNgkxNTA4CTE1MTEJMTUxOQkxNTM0CTE1MzcJMTU0MQkxNTQ5
CTE1NTgJMTU2MgkxNTYzCTE1NjYJMTU3MgkxNTc0Li4JMTU4NAkxNTg3CTE1OTMuCTE1OTcJ
MTYwMAkxNjAzLgkxNjEwCTE2MTEJMTYxNAkxNjE1CTE2MTYJMTYyMQkxNjI2CTE2MjkuCTE2
MzQJMTYzOAkxNjQyCTE2NDQJMTY0NgkxNjUyLgkxNjU2LgkxNjU3CTE2NjAJMTY2NAkxNjY4
CTE2NjkJMTY3MS4JMTY3Mi4JMTY3NAkxNjgwCTE2ODEJMTY4MgkxNjg1CTE2ODcJMTY5MS4J
MTY5NAkxNzAyCTE3MDUJMTcwOAkxNzA5CTE3MTkJMTcyMgkxNzIzLgkxNzI0CTE3MjYuCTE3
MzAJMTczMS4uCTE3MzMuLi4uLi4uLgkxNzM0LgkxNzM2CTE3MzcuLgkxNzM4CTE3NDIuCTE3
NDYJMTc1MAkxNzUyCTE3NTUJMTc1OAkxNzY0CTE3NjYJMTc3MAkxNzcyLgkxNzc2CTE3NzcJ
MTc4MC4JMTc4NAkxNzg3LgkxNzg4CTE3OTQJMTc5NQkxNzk3LgkxNzk5CTE4MDEJMTgwMwkx
ODA0LgkxODA4CTE4MDkJMTgxMQkxODE1CTE4MTcuCTE4MTkJMTgyMwkxODI0CTE4MjYJMTgy
OAkxODMzCTE4MzgJMTg0MQkxODQ1CTE4NTAJMTg1NAkxODU3CTE4NjAJMTg2NwkxODcwCTE4
NzEJMTg3MwkxODc3CTE4NzkJMTg4MAkxODg1CTE4ODcJMTg4OQkxODk0CTE5MDAJMTkwMwkx
OTA1CTE5MDYJMTkxMAkxOTE1CTE5MjAJMTkyNAkxOTMwCTE5MzYJMTk0MwkxOTQ0CTE5NDgJ
MTk1NwkxOTY1CTE5NjkJMTk3NgkxOTc4CTE5ODUJMTk5NAkxOTk1CTIwMDIJMjAwNQkyMDA4
CTIwMTIJMjAyMgkyMDI0CTIwMjYJMjAzNAkyMDM1CTIwMzgJMjA0MQkyMDQyCTIwNDgJMjA2
MwkyMDY5CTIwNzQJMjA3NwkyMDgxCTIwODIJMjA4NQkyMDg5CTIwOTIJMjA5NwkyMTAwLi4J
MjEwNQkyMTA3CTIxMTAJMjExNgkyMTIwCTIxMjMJMjEyNQkyMTM3CTIxNDIJMjE0NgkyMTU0
CTIxNjAJMjE2NAkyMTY2CTIxNzIJMjE3NgkyMTgyCTIxODgJMjE5MQkyMTk5CTIyMDYJMjIx
MwkyMjE3CTIyMjAJMjIyNgkyMjM4CTIyNDIJMjI1MQkyMjY0CTIyNzgJMjI4NgkyMzAxCTIz
MDgJMjMxNgkyMzMxCTIzNDUJMjM1MwkyMzY1CTIzNzMJMjQwMAkyNDIyCTI0NTMJMjQ2OAky
NDkwCTI1MTEJMjUzMwkyNTQ1CTI1NzIJMjU3OAkyNTk4CTI2MDkJMjYyMgkyNjQyCTI2NTgJ
MjY3MwkyNzAwCTI3MTUJMjcyNQkyNzQ0CTI3NjQJMjc4MAkyNzkxCTI4MDYJMjgzMAkyODQy
CTI4NDgJMjg1OQkyODczCTI4OTkJMjkwNgkyOTE1CTI5MjIJMjk0NQkyOTU3CTI5NjcJMjk2
OAkyOTgzCTI5OTYJMzAwNQkzMDA5CTMwMTgJMzAzNwkzMDQ1CTMwNDgJMzA1MQkzMDYxCTMw
NjUJMzA3MQkzMDc0CTMwNzkJMzA4MAkzMDgyCTMwODMJMzA4NAkzMDg3Li4JMzA4OAkzMDky
CTMwOTUJMzEwMAkzMTE3CTMxMjgJMzEzMQkzMTM3CTMxNDAJMzE0NwkzMTUyCTMxNTYJMzE1
OAkzMTYxCTMxNjMJMzE2NQkzMTc0CTMxODIJMzE4NAkzMTg5CTMxOTcJMzIwMAkzMjAzCTMy
MTIJMzIxOAkzMjE5CTMyMjMJMzIyNwkzMjMwCTMyMzMJMzIzOQkzMjQyCTMyNDgJMzI0OQkz
MjUxCTMyNTIJMzI1OAkzMjYxCTMyNjYJMzI3MAkzMjc2CTMyODIJMzI4NgkzMjg5CTMyOTMJ
MzI5Ny4JMzI5OS4uLgkzMzA1CTMzMDYJMzMxMgkzMzE5CTMzMjAJMzMzOAkzMzQ3CTMzNjIJ
MzM3NgkzMzc5LgkzMzgzCTMzOTYJMzM5OAkzNDI3CTM0MzIJMzQ0MwkzNDc3CTM0ODAJMzQ5
MwkzNTEwCTM1MjIJMzU0MQkzNTYzCTM1OTQJMzYyMwkzNjMwCTM2MzgJMzY1NgkzNjcyCTM2
ODgJMzcwNwkzNzExCTM3MzUJMzczNgkzNzQxCTM3NDcJMzc1OAkzNzY2CTM3NzcJMzc4Nwkz
Nzk2CTM4MTIJMzgyMQkzODM4CTM4NzAJMzg3OAkzODkxCTM4OTgJMzkwMQkzOTI1CTM5MzEJ
MzkzOAkzOTQ5CTM5NTUJMzk1OAkzOTY1CTM5NzkJMzk5NAkzOTk4CTQwMDYJNDAxNQk0MDE4
CTQwMjYJNDA1OQk0MDYyCTQwNjYJNDA3OAk0MDgwCTQwODQJNDA5MAk0MDkzCTQxMDEJNDEw
NQk0MTEyCTQxMjAJNDEyOQk0MTMyCTQxMzYJNDE0MAk0MTQxCTQxNTIJNDE2Ngk0MTc1CTQx
ODQJNDE4OAk0MjAzCTQyMTAJNDIxNAk0MjIwCTQyMzEJNDIzOQk0MjQzCTQyNTQJNDI2NQk0
Mjc3CTQyODMJNDI5MQk0MzAzCTQzMDgJNDMxNwk0MzI2CTQzMzAJNDMzMwk0MzM3CTQzNDAJ
NDM0Mgk0MzQ0Lgk0MzQ5CTQzNjQJNDM2Ngk0MzY5CTQzODMJNDM5Mwk0Mzk1CTQ0MDMJNDQx
Ngk0NDIzCTQ0MzQJNDQ1MQk0NDU0CTQ0NjAJNDQ2Mwk0NDY3CTQ0ODEJNDQ5NAk0NTA1CTQ1
MTEJNDUxNAk0NTE2CTQ1MzEJNDU0Ngk0NTQ3CTQ1NjAJNDU3OAk0NTkzCTQ2MDcJNDYyNAk0
NjM0CTQ2NDUJNDY3OAk0Njk2CTQ3MTEJNDcyOQk0NzMzCTQ3NDgJNDc3Mgk0Nzc1CTQ3ODMJ
NDgwNwk0ODEzCTQ4MjIJNDgzMgk0ODM2CTQ4NDUJNDg2Mwk0ODY5CTQ4NzUJNDg5Mgk0OTAy
CTQ5MTUJNDkzMQk0OTQzCTQ5NTQJNDk2Mwk0OTc0CTQ5NzgJNDk5Mgk1MDA1Lgk1MDA2Li4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDEw
MjA0G1swbQobWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZTogcmVxdWVzdGVkIDEwMjA0LCBsaW1p
dCB0byA1MDAwG1swbQouLgk1MDA5CTUwMTIJNTAyMgk1MDM0CTUwMzcJNTA0Nwk1MDU1CTUw
NTcJNTA2NQk1MDc1CTUwNzgJNTA5NQk1MTA1CTUxMDkJNTEzMAk1MTM5CTUxNDgJNTE1Mgk1
MTc2CTUxOTAJNTE5Mwk1MjE0CTUyMjEJNTIyNgk1MjM4CTUyNjQJNTI3MQk1Mjg3CTUzMDQJ
NTMwNgk1MzE1CTUzMjcJNTMzMQk1MzQ4CTUzODIJNTM4OQk1NDE2CTU0NDMJNTQ1NQk1NDg1
CTU1MDcJNTUyNQk1NTQxCTU1NzQJNTYwMAk1NjIzCTU2NDgJNTY3NQk1NzEyCTU3NDMJNTc2
Nwk1NzkxCTU4MTAJNTgzNAk1ODY4CTU4OTIJNTkxMwk1OTM1CTU5NTMJNTk3Mwk1OTg1CTYw
MDEJNjAwOAk2MDE3CTYwMjMJNjAyOQk2MDM4CTYwNDEJNjA1Ngk2MDU5CTYwNzEJNjA3NQk2
MDc4CTYwOTkJNjExNwk2MTQ0CTYxNjUJNjE3NAk2MTc4CTYyMDkJNjIyMAk2MjI1CTYyNjcJ
NjI3Mgk2Mjg1CTYzMDIJNjMwNgk2MzEzCTYzNDkJNjM4Ngk2Mzk2CTY0MDMJNjQyOAk2NDQy
CTY0NzEJNjQ4Ngk2NDkwCTY1MTcJNjU1Ngk2NTgwCTY2MDkJNjYyMAk2NjY0CTY2OTYJNjcx
MAk2NzM1CTY3NzIJNjgxMgk2ODUzCTY4NTYJNjg1OS4uCTY4NjEuLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLgk2ODYzLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
LhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDgzNDcbWzBtChtbMTszNW1hZGRfdG9fcnVuX3F1
ZXVlOiByZXF1ZXN0ZWQgODM0NywgbGltaXQgdG8gNTAwMBtbMG0KLgk2ODY0CTY5NTYJNzAx
NQk3MDg2CTcxNDgJNzE2Mwk3MjM0CTcyNzcJNzMxNAk3NDExCTc0NzMJNzU2MQk3NjgxCTc3
MDUJNzc4Mgk3ODUxCTc5MDkJNzk4NAk4MDU5CTgxMTAJODE2NQk4MjYzCTgzMjYJODM4OAk4
NDQwCTg1NTQJODYzMgk4Njk0CTg3NTMJODg1NQk4ODkzCTg5NjYJOTAwMwk5MDI0Li4uLgk5
MDI1Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4J
OTAyNi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JOTAyNy4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA2MTgzG1swbQobWzE7MzVtYWRkX3Rv
X3J1bl9xdWV1ZTogb3ZlcnNpemVkIHF1ZXVlOiAxMTkxOTM2IC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi9saW51eC1kZXZlbDpkZXZl
bC1jYWlyby14ODZfNjQtMjAxMzA2MDcwMDE4Ojk3OWMyOTIwNWZmYTYwN2M1OWJhMmM5Zjlj
MDgzYjk2N2QzNTZjOTc6YmlzZWN0LW1tG1swbQobWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZTog
cmVxdWVzdGVkIDYxODMsIGxpbWl0IHRvIDEwMDAbWzBtCi4JOTAyOAk5MTE1CTkzMjEJOTQ0
Mwk5NTgyCTk3NzgJOTgxNwk5ODE4CTk4MTkuCTk4MjAJOTgyMi4JOTgyMy4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk5ODI1CTk4MzQuCTk4MzcJOTg0MAk5
ODQyCTk4NTkJOTg2NQk5ODg5CTk5MTQJOTkzNgk5OTYyCTEwMDAzCTEwMDMwCTEwMDQyCTEw
MDY4CTEwMDg1CTEwMTA4CTEwMTM0CTEwMTU2CTEwMTc4CTEwMjAzCTEwMjI2CTEwMjY0CTEw
MjkyCTEwMzE1CTEwMzU2CTEwMzg4CTEwNDA1CTEwNDUzCTEwNDcyCTEwNTAzCTEwNTQwCTEw
NTU5CTEwNTg3CTEwNjIyCTEwNjU5CTEwNjc5CTEwNzEzCTEwNzQ1CTEwNzgyCTEwODIyCTEw
ODU4CTEwODg2CTEwOTA4CTEwOTU0CTEwOTk0CTExMDE2CTExMDYxCTExMDg5CTExMTEyCTEx
MTU5CTExMTk3CTExMjQ1CTExMjg0CTExMzA5CTExMzQzCTExMzgxCTExNDI3CTExNDU1CTEx
NDk1CTExNTQ0CTExNTg1CTExNjE4CTExNjU3CTExNjk0CTExNzQ5CTExODA4CTExOTI0CTEy
MDU0CTEyMTc1CTEyMjkwCTEyMzI2CTEyMzI5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLgkxMjMzNQkxMjQzMwkxMjU2OAkxMjY1OQkxMjcwNC4JMTI3
MDcuLi4uLgkxMjcwOAkxMjcxMQkxMjcxMy4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxMjczNwkxMjc2MgkxMjgxMgkx
Mjg5MQkxMjkzMAkxMjk0OAkxMjk1NAkxMjk1NS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxMjk1OAkxMjk3MgkxMzAxMgkxMzA2MgkxMzA5
MwkxMzE0NQkxMzE3OAkxMzIwNwkxMzI1NQkxMzI3OQkxMzMwMAkxMzMxOQkxMzM1NQkxMzQw
NwkxMzQ0OQkxMzQ2OQkxMzQ4OQkxMzUyNgkxMzU1MwkxMzU4NgkxMzY2OAkxMzY4NgkxMzc0
MAkxMzc3NgkxMzc5OQkxMzgzMAkxMzg3NAkxMzk0OAkxMzk3NAkxMzk5NwkxNDAzMwkxNDA1
OAkxNDA5NgkxNDE1MQkxNDIwNAkxNDIyNAkxNDI3MwkxNDMwMAkxNDMzNAkxNDM2OAkxNDQw
NQkxNDQ0MQkxNDQ2NAkxNDQ4NgkxNDUyMgkxNDU0NQkxNDU2OAkxNDYwOQkxNDcwNQkxNDcy
OQkxNDc2MQkxNDc5MQkxNDg0MgkxNDg1NgkxNDkxMgkxNDkyNi4uLi4uCTE0OTI3Li4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDI4Mxtb
MG0KLi4uLi4JMTQ5NDQJMTUwMDUJMTUwODcJMTUxMzgJMTUxNzgJMTUxOTIuLi4JMTUxOTgu
Li4uLi4uLi4uLi4uLi4uCTE1MTk5CTE1MjAxLgkxNTIwMgkxNTIwMwkxNTIwNC4JMTUyMDUu
LgkxNTIwOAkxNTIxMiBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8t
eDg2XzY0LTIwMTMwNjA3MDAxODo2NGYwMzg5ZjUwZjM1NzYzNjBlNWIyODcwZTViMDljOGM1
MDBhMzczOmJpc2VjdC1tbQogVEVTVCBGQUlMVVJFCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzI2LTA2MDYvNjRmMDM4OWY1MGYzNTc2MzYwZTViMjg3MGU1YjA5YzhjNTAwYTM3My9k
bWVzZy1rdm0tYW50LTI0Nzc0LTIwMTMwNjA3MTUxOTI4LTMuMTAuMC1yYzQtMDAzNDUtZzY0
ZjAzODktNgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2LzY0ZjAzODlmNTBm
MzU3NjM2MGU1YjI4NzBlNWIwOWM4YzUwMGEzNzMvZG1lc2cta3ZtLWFudC0yNDg1Ny0yMDEz
MDYwNzE1MjAwOS0zLjEwLjAtcmM0LTAwMzQ1LWc2NGYwMzg5LTYKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jMjYtMDYwNi82NGYwMzg5ZjUwZjM1NzYzNjBlNWIyODcwZTViMDljOGM1
MDBhMzczL2RtZXNnLWt2bS1hbnQtMjUwMjEtMjAxMzA2MDcxNTE5MzQtMy4xMC4wLXJjNC0w
MDM0NS1nNjRmMDM4OS02Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvNjRm
MDM4OWY1MGYzNTc2MzYwZTViMjg3MGU1YjA5YzhjNTAwYTM3My9kbWVzZy1rdm0tYW50LTI1
MTQzLTIwMTMwNjA3MTUxOTA2LTMuMTAuMC1yYzQtMDAzNDUtZzY0ZjAzODktNgova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMyNi0wNjA2LzY0ZjAzODlmNTBmMzU3NjM2MGU1YjI4NzBl
NWIwOWM4YzUwMGEzNzMvZG1lc2cta3ZtLWFudC0yNTMyMi0yMDEzMDYwNzAxMDIwOS0zLjEw
LjAtcmM0LTAwMzQ1LWc2NGYwMzg5LTYKCltkZXRhY2hlZCBIRUFEIDZhZjBkM2U2XSBSZXZl
cnQgImJyY21mbWFjOiBkZWZpbmUgYW5kIHVzZSBwbGF0Zm9ybSBzcGVjaWZpYyBkYXRhIGZv
ciBTRElPLiIKIDYgZmlsZXMgY2hhbmdlZCwgMTg3IGluc2VydGlvbnMoKyksIDI1MCBkZWxl
dGlvbnMoLSkKIGRlbGV0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL2xpbnV4L3BsYXRmb3JtX2Rh
dGEvYnJjbWZtYWMtc2Rpby5oCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZf
NjQtMjAxMzA2MDcwMDE4OjZhZjBkM2U2NzY2OGZmZWU1ZjFhZWZkZDMzOTI3MDM4MmIyNDRj
Yzc6YmlzZWN0LW1tCgoyMDEzLTA2LTE1LTExOjU0OjEwIDZhZjBkM2U2NzY2OGZmZWU1ZjFh
ZWZkZDMzOTI3MDM4MmIyNDRjYzcgY29tcGlsaW5nChtbMTszNW1hZGRfdG9fcnVuX3F1ZXVl
OiByZXF1ZXN0ZWQgMTUyMTAsIGxpbWl0IHRvIDUwMDAbWzBtCgoyMDEzLTA2LTE1LTEyOjAx
OjQ2IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzQtMDAzNDYtZzZhZjBkM2U2Li4u
Li4uLi4JMgkyNAk0NAk1OQk2NQk4Nwk5MgkxMDkJMTE1CTEyMwkxNDIJMTU1CTE2OQkxNzkJ
MTg3CTE5NAkyMDAJMjEzCTI0MQkyNTYJMjYzCTI4MAkyOTAJMzA2CTMxMwkzMzIJMzQ2CTM1
NwkzNjcJMzc5CTM4OQkzOTIJNDI2CTQ1NQk0ODIJNTA0CTUzMwk1NTQJNTkyCTYwNwk2MjEJ
Njc5CTc0MAk4MDEJODI5CTg1Nwk4ODMJOTA4CTkyNAk5MzMJOTUzCTk3MAk5NzMuCTk4Nwkx
MDAzCTEwMTkJMTAyNAkxMDUwCTEwNzQJMTA5NQkxMTE2CTExMjMJMTEzNQkxMTQ2CTExNTMJ
MTE2OAkxMTg2CTExOTYJMTIwMQkxMjA5CTEyMjkJMTI0OQkxMjUyCTEyNzMJMTI5NwkxMzE0
CTEzMjMJMTMzMwkxMzQxCTEzNjMJMTM3NgkxMzkzCTE0MDAJMTQxOAkxNDI5CTE0NDUJMTQ2
MgkxNDgxCTE0ODkJMTQ5OAkxNTEwCTE1MjUJMTU0MgkxNTUyCTE1NjkJMTU4MgkxNTkzCTE2
MTIJMTYzMgkxNjU4CTE2ODYJMTcxMQkxNzI2CTE3NDYJMTc3MgkxNzk1CTE4MDUJMTgzNAkx
ODQ5CTE4NjYJMTg3NQkxODg1CTE4OTYJMTkwOQkxOTI4CTE5MzUJMTk1NgkxOTc1CTE5ODEJ
MTk4NwkyMDAyCTIwMjQJMjA0MAkyMDU1CTIwNjEJMjA3NQkyMDkwCTIxMDQJMjExMQkyMTMw
CTIxNTYJMjE4NwkyMjAxCTIyMjIJMjI2MwkyMzEzCTIzNzAJMjQyNQkyNDUxCTI0NTQJMjQ3
OQkyNTY4CTI2NDgJMjcyNwkyNzU2CTI3NjQJMjc3MQkyNzgzCTI3ODcJMjc5Mi4JMjgwMQky
ODEwCTI4MTYuCTI4MTguLgkyODM4CTI4ODIJMjkyNgkyOTQ5CTI5NjIJMjk3MgkyOTc3CTI5
ODMuCTMwMTgJMzA2MAkzMDkxCTMxMTUJMzEzMQkzMTQxCTMxNTQJMzE2NQkzMTcyCTMxODMJ
MzE5NwkzMjAyCTMyMDcJMzIyNQkzMjQ4CTMyNzMJMzI5NQkzMzA4CTMzMjgJMzM0NQkzMzUx
CTMzNzAJMzM4MAkzMzg2CTMzOTIJMzQwNQkzNDE3CTM0MjkJMzQ0NAkzNDQ4CTM0NTkJMzQ3
MAkzNDg1CTM0OTMJMzUwMgkzNTI0CTM1NDgJMzU2NQkzNTcyCTM1NzgJMzU4NgkzNjA3CTM2
MTgJMzYzMwkzNjQ0CTM2NDUJMzY1NQkzNjczCTM2OTQJMzcwNgkzNzEzCTM3MjEJMzczNwkz
NzcwCTM4MDIJMzgyMwkzODI4CTM4MzMJMzgzOAkzODM5CTM4NTAJMzg2OQkzODg3CTM5MTEJ
MzkyNwkzOTM2CTM5NDYJMzk2MQk0MDA5CTQwNjkJNDExMwk0MTYzCTQyMjAJNDI3MQk0MzIy
CTQzNzgJNDQzMgk0NDc4CTQ1MTUJNDU2MQk0NTk4CTQ2MjYJNDY2MAk0NjgwCTQ3MTYJNDc0
OAk0NzczCTQ3OTQJNDgxNgk0ODM0CTQ4NDcJNDg2Nwk0ODgzCTQ4OTMJNDg5Nwk0OTIzCTQ5
NzEJNTAyMQk1MDkxCTUxNTMJNTIxNgk1MjczCTUzMzgJNTQwMQk1NDU0CTU1MDQJNTU1OAk1
NjEwCTU2NjUJNTcwMwk1NzU4CTU4MDIJNTg0Nwk1ODgwCTU5MTYJNTk1Mwk1OTg3CTYwMTkJ
NjA0Mgk2MDY3CTYwODkJNjEyMgk2MTM3CTYxNTMJNjE3NAk2MTg4CTYxOTcJNjIwNQk2MjE3
CTYyMjQJNjIzMQk2MjM1Li4uLi4uLi4uLi4uLgk2MjM3CTYyNDAJNjI0NAk2MjQ4CTYyNTIJ
NjI1OQk2MjY2CTYyNzIJNjI4Mwk2MzAxCTYzMDYJNjMxOAk2MzMwCTYzMzkJNjM0NAk2MzUz
CTYzNjEJNjM2NQk2MzcwCTYzNzMJNjM4MAk2MzgzCTYzODQJNjM4NQk2Mzg3CTYzOTAJNjM5
Mwk2Mzk3CTYzOTgJNjQwMS4uLi4uLi4uLi4uCTY0MDMJNjQwOQk2NDE1CTY0MjIJNjQyOQk2
NDM4CTY0NTAJNjQ2MQk2NDc0CTY0ODQJNjUwMgk2NTE3CTY1MzMJNjU0OQk2NTcwCTY1ODQJ
NjU5OQk2NjE0CTY2MzUJNjY0Ngk2NjYxCTY2NzcJNjY4OAk2Njk1CTY3MDgJNjcxNAk2NzE3
CTY3MjQJNjcyNwk2Nzc4CTY4MzcJNjkwNAk2OTM5CTY5NTgJNjk4Ngk3MDIzCTcwNTcJNzA5
Mgk3MTIzCTcxODUJNzI0MAk3Mjk3CTczMzgJNzM4OQk3NDM0CTc0OTUJNzU1Mgk3NjIzCTc2
OTcJNzc3Ngk3ODM3CTc5MTEJNzk5NAk4MDY0CTgxMzQJODIxNwk4Mjk1CTgzNTAJODQwMAk4
NDQ0CTg0NzkJODUzOQk4NjI0CTg3MDkJODc4OAk4ODYwCTg5NDMJOTAwMgk5MDYzCTkxMzEJ
OTE5MQk5MjQ2CTkzMDEJOTM0Ngk5Mzk3CTk0MzMJOTQ3NQk5NTEzCTk1NTYJOTU5OQk5NjMz
CTk2NjUJOTcwMQk5NzMyCTk3NTEJOTc4OAk5ODIxCTk4NDgJOTg4MQk5OTE3CTk5MzgJOTk3
NgkxMDAxMgkxMDA1MwkxMDA4NAkxMDExMgkxMDE0MQkxMDE4MAkxMDIwMgkxMDIzMgkxMDI2
MAkxMDI3OAkxMDMwMwkxMDM0MQkxMDM3NwkxMDQwOQkxMDQzMAkxMDQ1NQkxMDQ4MgkxMDUx
MQkxMDUzNgkxMDU1MQkxMDU3MQkxMDU5MwkxMDYxMgkxMDYzMQkxMDY0MwkxMDY2NQkxMDY4
MwkxMDY5MQkxMDcxMwkxMDczMAkxMDc0OQkxMDc2MwkxMDc3OQkxMDc5NAkxMDgwOQkxMDgy
OQkxMDg0MwkxMDg1OQkxMDg3MQkxMDg4NQkxMDg5MQkxMDkwNAkxMDkxMwkxMDkyNwkxMDkz
OQkxMDk0OQkxMDk1NQkxMDk1OS4JMTA5NjcJMTA5NzUJMTA5ODUJMTA5ODkJMTA5OTUJMTEw
MDMJMTEwMTQJMTEwMTkJMTEwMjkJMTEwMzcJMTEwNTAJMTEwNTkJMTEwNjcJMTEwNjguCTEx
MDcyLgkxMTA3MwkxMTA3NgkxMTA4MAkxMTA4NgkxMTEwMQkxMTEwNQkxMTEwOAkxMTExMAkx
MTExMwkxMTExOAkxMTEyMwkxMTEyNC4JMTExMjgJMTExMzIJMTExMzQJMTExMzcuCTExMTM5
CTExMTQwLi4uLi4uLgkxMTE0Ni4JMTExNDguLi4uLi4uLi4JMTExNDkuLi4JMTExNTEuCTEx
MTUyLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1
ZXVlIDQwNTgbWzBtCi4uLi4uLi4JMTExNTMJMTExNTYJMTExNjUJMTExNjkJMTExNzIJMTEx
NzMJMTExNzcJMTExODIJMTExOTAJMTEyMDAJMTEyMDIJMTEyMDQJMTEyMDYJMTEyMDkJMTEy
MTMJMTEyMTUJMTEyMTcJMTEyMTkJMTEyMjQJMTEyMjcJMTEyMjkuCTExMjMwCTExMjMzCTEx
MjM3LgkxMTI0MwkxMTI0NS4JMTEyNDYuCTExMjU3CTExMjc3CTExMjg1CTExMjk2CTExMjk3
LgkxMTI5OAkxMTMwOAkxMTMxMQkxMTMxMwkxMTMxOQkxMTMyMC4JMTEzMjIJMTEzMjgJMTEz
MzAJMTEzMzEJMTEzMzIJMTEzMzQuCTExMzM4CTExMzQzCTExMzQ2CTExMzUxCTExMzU2CTEx
MzU5CTExMzYwLgkxMTM2MS4uLi4JMTEzNjkJMTEzODUJMTEzOTUJMTE0MTIJMTE0MTgJMTE0
MjAJMTE0MjMJMTE0MzEJMTE0MzMJMTE0NDMJMTE0NDUJMTE0NDcJMTE0NDgJMTE0NTAJMTE0
NTMJMTE0NTQuLgkxMTQ1NgkxMTQ2MwkxMTQ4MAkxMTQ4NwkxMTQ5MwkxMTQ5OAkxMTUwOAkx
MTUyMQkxMTUyNwkxMTUyOAkxMTUzMQkxMTUzNgkxMTU0NQkxMTU1NAkxMTU1OAkxMTU2My4J
MTE1NjYJMTE1NzQJMTE1ODAJMTE1ODQJMTE1ODgJMTE1OTAJMTE1OTcJMTE2MDgJMTE2MTAJ
MTE2MTQJMTE2MTYJMTE2MTcJMTE2MjAJMTE2MjUJMTE2MjgJMTE2MzYJMTE2MzcJMTE2MzgJ
MTE2MzkuCTExNjQwCTExNjQ3CTExNjU4CTExNjY4CTExNjcyCTExNjc2CTExNjc4CTExNjg5
CTExNjk0CTExNjk2CTExNjk4CTExNzAwCTExNzAxCTExNzAyCTExNzEzCTExNzIxCTExNzM0
CTExNzM4CTExNzQyCTExNzUwCTExNzYyCTExNzY0CTExNzczCTExNzc2CTExNzg2CTExNzg5
CTExNzk4LgkxMTc5OQkxMTgwNgkxMTgxNAkxMTgyNAkxMTgzMAkxMTgzMQkxMTgzNQkxMTgz
OQkxMTg0MAkxMTg0NS4uCTExODQ3CTExODQ5CTExODU1CTExODgyCTExOTE0CTExOTIyCTEx
OTMwCTExOTM3CTExOTM4CTExOTQwCTExOTQ4CTExOTQ5CTExOTUxCTExOTU2CTExOTYwCTEx
OTcxCTExOTc2CTExOTg3CTExOTk1CTExOTk3CTEyMDA0CTEyMDA2CTEyMDExCTEyMDE2CTEy
MDIyCTEyMDI4CTEyMDMwCTEyMDM2CTEyMDQyCTEyMDQ3CTEyMDUxCTEyMDU3LgkxMjA2Mwkx
MjA2OC4JMTIwODgJMTIwOTgJMTIxMDQJMTIxMDYJMTIxMTIJMTIxMTUJMTIxMjkJMTIxMzAJ
MTIxMzMJMTIxMzguCTEyMTQ0Li4JMTIxNTAJMTIxNTQJMTIxNTYJMTIxNTcJMTIxNjEJMTIx
NjYJMTIxNzUJMTIxNzcJMTIxODQJMTIxODkuCTEyMTk0CTEyMjEwCTEyMjExCTEyMjE3CTEy
MjIxCTEyMjI2CTEyMjI4LgkxMjIzMgkxMjI1NgkxMjI2MQkxMjI2Mi4JMTIyNjgJMTIyNzEJ
MTIyNzMJMTIyNzUJMTIyNzkJMTIyODQJMTIyOTMJMTIzMDAJMTIzMDcJMTIzMDgJMTIzMTgJ
MTIzMjIJMTIzMzAJMTIzMzUJMTIzMzcJMTIzNDQJMTIzNTUJMTIzNTgJMTIzNjIJMTIzNjgJ
MTIzNzMJMTIzODcJMTI0MDYJMTI0MjIJMTI0MjYJMTI0MzcJMTI0NDQJMTI0NTYJMTI0NzAJ
MTI0ODEJMTI0ODUJMTI0ODkJMTI0OTEJMTI0OTUJMTI1MDEJMTI1MjkJMTI1MzMuCTEyNTM5
CTEyNTQzCTEyNTUxCTEyNTYxCTEyNTY3CTEyNTc2CTEyNTgxCTEyNTgzLgkxMjU4OAkxMjU5
MAkxMjU5MwkxMjYwMAkxMjYwNgkxMjYxMgkxMjY0MQkxMjY0MwkxMjY1MiBTVUNDRVNTCgoK
PT09PT09PT09IHVwc3RyZWFtID09PT09PT09PQpGZXRjaGluZyBsaW51cwpscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzI2LTA2MDYvbGlu
dXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA3MDAxODo1OTM4OTMwZTcxYWZm
YTM5MGMzZmEzM2ZhMmZkYTUyZjU4Zjg1MGU4OmJpc2VjdC1tbQoKMjAxMy0wNi0xNS0yMTo0
NDo0OCA1OTM4OTMwZTcxYWZmYTM5MGMzZmEzM2ZhMmZkYTUyZjU4Zjg1MGU4IGNvbXBpbGlu
ZwobWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZTogcmVxdWVzdGVkIDEwMDAwLCBsaW1pdCB0byA1
MDAwG1swbQoKMjAxMy0wNi0xNS0yMTo1Njo1NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEw
LjAtcmM1LTAwMDc4LWc1OTM4OTMwLi4JMQkyCTgJMzcJMzgJMzkJNTMJNTkJNjcuLi4JOTUJ
MTA2CTEwOQkxMTUJMTIxCTEzMQkxNTMJMTU2LgkxNTgJMTY4CTE4NwkxOTYJMjEwCTIxMwky
MTgJMjM2CTI2OQkyNzUJMjg1CTI5MgkyOTgJMjk5CTMwNQkzMDgJMzE2CTMzMQkzNDgJMzYy
CTM2NgkzNjkJMzc4CTM5MAk0MDUJNDE5CTQzNAk0NDAJNDQ1CTQ1OAk0NjcJNDc3CTQ5MAk0
OTQJNTA1CTUyMwk1MzIJNTM0CTUzNwk1NDMJNTcxCTU3OAk1ODcJNTk1CTYxNAk2MjgJNjM2
CTY0NQk2NzIJNjgyCTY5MQk2OTQJNzAwCTcwNwk3MTYJNzI4Lgk3MzUJNzQzCTc1Mwk3NTkJ
NzY5CTc4Mwk3OTcJODA5CTgyMQk4MjkJODM4CTg0Mwk4NTAJODU1CTg2MQk4NjUJODY5CTg4
MAk4OTgJOTAzCTkwNi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTkwOAk5NTcJMTA1MwkxMDU2CTExNTYJMTIxOAkxMjIyCTEz
MjYJMTM5MAkxNDY4CTE0ODMJMTUxNAkxNTMxCTE1MzkJMTU0MC4JMTU3NQkxNTkwCTE2MDEJ
MTYwOAkxNjE1CTE2MzIJMTY0MwkxNjUzCTE2NjEJMTY2OAkxNjczCTE2NzUJMTY4MQkxNjkx
CTE2OTMJMTY5NgkxNzAzCTE3MDkJMTcxMwkxNzE4CTE3MjMJMTczMQkxNzQxCTE3NTIJMTc1
NAkxNzU5CTE3NjIJMTc2NAkxNzY4CTE3NzcJMTc3OQkxNzg5CTE3OTIJMTgwNgkxODE3CTE4
MjkJMTgzOAkxODQ1CTE4NTYJMTg2OAkxODkxCTE5MDgJMTkzMgkxOTU0CTE5NzgJMjAwNQky
MDMwIFRFU1QgRkFJTFVSRQpkbWVzZy1rdm0taW5uLTEyMTQ4LTIwMTMwNjE1MjM0NzQ1LTMu
MTAuMC1yYzUtMDAwNzgtZzU5Mzg5MzAtMjEKZG1lc2cta3ZtLWlubi0xMzM4OC0yMDEzMDYx
NTIzNDgwMC0zLjEwLjAtcmM1LTAwMDc4LWc1OTM4OTMwLTIxCmRtZXNnLWt2bS1pbm4tMTM3
NDUtMjAxMzA2MTUyMzQ4MDAtMy4xMC4wLXJjNS0wMDA3OC1nNTkzODkzMC0yMQoKCj09PT09
PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRjaGluZyBuZXh0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi9saW51eC1k
ZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDcwMDE4OmMwNGVmZWQ3MzQ0MDlmNWE0
NDcxNWI1NGE2Y2ExYjU0YjBjY2YyMTU6YmlzZWN0LW1tCgoyMDEzLTA2LTE1LTIzOjQ4OjQ3
IGMwNGVmZWQ3MzQ0MDlmNWE0NDcxNWI1NGE2Y2ExYjU0YjBjY2YyMTUgcmV1c2UgL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1jMjYtMDYwNi9jMDRlZmVkNzM0NDA5ZjVhNDQ3MTViNTRh
NmNhMWI1NGIwY2NmMjE1L3ZtbGludXotMy4xMC4wLXJjNC1uZXh0LTIwMTMwNjA3ChtbMTsz
NW1hZGRfdG9fcnVuX3F1ZXVlOiByZXF1ZXN0ZWQgOTk5MSwgbGltaXQgdG8gNTAwMBtbMG0K
CjIwMTMtMDYtMTUtMjM6NDg6NTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMTQJMjAJNDQJ
NjUJODIJMTAzCTExNQkxMjUJMTM0CTE0OAkxNjAJMTgxCTE5MAkyMDYJMjIwCTI0MAkyNDQJ
MjUzCTI2OQkyOTIJMzAyLi4uLi4uLgk0MjgJNTQzCTYxOAk2MjQJNjU5CTY4Mwk3MDUJNzM2
CTc1Mgk3ODMJODAwCTgzMgk4NjAJODgyCTg5Mi4uCTg5NAk5NTgJMTAwMQkxMDM5CTEwNjIJ
MTA4MAkxMDgxCTEwODkJMTE2OQkxMTgwCTExODQJMTI3NwkxMjk5CTEzMTIJMTM2MQkxMzg0
CTE0MDkJMTQ0NgkxNDY3CTE1MjMJMTUzMwkxNTUxCTE1NTkJMTYxMS4JMTY1MgkxNjc0CTE3
MDAuCTE3MTEJMTc4OAkxODE3CTE4NDEJMTg2MQkxODg3CTE5MDkJMTkzMgkxOTY4CTE5OTMJ
MjAxOAkyMDQ1CTIwNTQuCTIwODQJMjEzMQkyMTYxCTIxOTQJMjIyNgkyMjQ4CTIyNTkJMjI4
NgkyMzAyCTIzMzEJMjM1MQkyMzgyCTI0MDUJMjQyNgkyNDU1CTI0ODYJMjUxMwkyNTQ4CTI1
NzcJMjYwMwkyNjM1CTI2NzUJMjY5NwkyNzMyIFRFU1QgRkFJTFVSRQpkbWVzZy1rdm0tYW50
LTI0Nzc0LTIwMTMwNjE2MDA0NzEyLTMuMTAuMC1yYzQtbmV4dC0yMDEzMDYwNy0yNQoK

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc4 Kernel Configuration
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
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
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
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
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
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
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
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
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
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
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
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
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
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
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

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
CONFIG_ISA_DMA_API=y
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

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
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
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
# CONFIG_IPV6_PIMSM_V2 is not set
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=y
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_HL=y
CONFIG_NETFILTER_XT_TARGET_HMARK=y
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TEE=y
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
CONFIG_NETFILTER_XT_MATCH_BPF=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=y
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
CONFIG_NETFILTER_XT_MATCH_RECENT=y
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
CONFIG_IP_NF_MATCH_RPFILTER=y
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_NF_TARGET_ECN is not set
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
# CONFIG_IP_NF_SECURITY is not set
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
# CONFIG_IP_NF_ARP_MANGLE is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_AH=y
CONFIG_IP6_NF_MATCH_EUI64=y
CONFIG_IP6_NF_MATCH_FRAG=y
CONFIG_IP6_NF_MATCH_OPTS=y
CONFIG_IP6_NF_MATCH_HL=y
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
CONFIG_IP6_NF_MATCH_MH=y
CONFIG_IP6_NF_MATCH_RT=y
# CONFIG_IP6_NF_FILTER is not set
# CONFIG_IP6_NF_MANGLE is not set
# CONFIG_IP6_NF_RAW is not set
CONFIG_IP6_NF_SECURITY=y
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_ACT_CSUM=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NETPRIO_CGROUP=y
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
CONFIG_IRNET=y
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

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
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_BT_WILINK=y
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_MLME_DEBUG is not set
# CONFIG_MAC80211_STA_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_PS_DEBUG is not set
# CONFIG_MAC80211_TDLS_DEBUG is not set
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
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
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
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
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
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
CONFIG_BLK_DEV_DRBD=y
CONFIG_DRBD_FAULT_INJECTION=y
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_OSD=y
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_MII=y
CONFIG_IFB=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
# CONFIG_NET_TEAM_MODE_RANDOM is not set
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
# CONFIG_MACVTAP is not set
# CONFIG_VXLAN is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_TCP=y
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
# CONFIG_NET_VENDOR_8390 is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
# CONFIG_WIZNET_BUS_INDIRECT is not set
CONFIG_WIZNET_BUS_ANY=y
# CONFIG_FDDI is not set
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
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
# CONFIG_PPTP is not set
CONFIG_PPPOL2TP=y
CONFIG_PPP_ASYNC=y
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_RTL8180 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=y
CONFIG_ATH_CARDS=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=y
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_AHB is not set
CONFIG_ATH9K_DEBUGFS=y
CONFIG_ATH9K_MAC_DEBUG=y
CONFIG_ATH9K_RATE_CONTROL=y
CONFIG_ATH6KL=y
CONFIG_ATH6KL_SDIO=y
CONFIG_ATH6KL_DEBUG=y
# CONFIG_WIL6210 is not set
CONFIG_B43=y
CONFIG_B43_BCMA=y
# CONFIG_B43_BCMA_EXTRA is not set
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
# CONFIG_B43_SDIO is not set
CONFIG_B43_BCMA_PIO=y
CONFIG_B43_PIO=y
# CONFIG_B43_PHY_N is not set
CONFIG_B43_PHY_LP=y
CONFIG_B43_PHY_HT=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
# CONFIG_B43LEGACY is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMSMAC=y
CONFIG_BRCMFMAC=y
CONFIG_BRCMFMAC_SDIO=y
# CONFIG_BRCM_TRACING is not set
CONFIG_BRCMDBG=y
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_SDIO=y
CONFIG_LIBERTAS_DEBUG=y
CONFIG_LIBERTAS_MESH=y
# CONFIG_P54_COMMON is not set
CONFIG_RT2X00=y
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
# CONFIG_RT2800PCI is not set
# CONFIG_RTLWIFI is not set
CONFIG_WL_TI=y
CONFIG_WL1251=y
CONFIG_WL1251_SDIO=y
CONFIG_WL12XX=y
# CONFIG_WL18XX is not set
CONFIG_WLCORE=y
CONFIG_WLCORE_SDIO=y
CONFIG_WILINK_PLATFORM_DATA=y
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_SDIO=y
# CONFIG_MWIFIEX_PCIE is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=y
# CONFIG_MISDN_DSP is not set
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
# CONFIG_MISDN_HFCMULTI is not set
# CONFIG_MISDN_AVMFRITZ is not set
# CONFIG_MISDN_SPEEDFAX is not set
# CONFIG_MISDN_INFINEON is not set
# CONFIG_MISDN_W6692 is not set
# CONFIG_MISDN_NETJET is not set

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
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
# CONFIG_INPUT_TWL4030_VIBRA is not set
# CONFIG_INPUT_TWL6040_VIBRA is not set
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF50633_PMU=y
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
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
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
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
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
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
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
CONFIG_SSBI=y
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

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
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
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_BATTERY_RX51 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_LP8788 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_MC13783_ADC is not set

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
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

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
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_BLOCKIO=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8925 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_AS3711=y
# CONFIG_MEDIA_SUPPORT is not set

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
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
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
# CONFIG_FB_MODE_HELPERS is not set
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
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
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
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
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
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_PS3REMOTE=y
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_WIIMOTE_EXT is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DEBUG is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_R8A66597=y
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=y
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
# CONFIG_USB_ETH_RNDIS is not set
# CONFIG_USB_ETH_EEM is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
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
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA9633=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
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
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM80X is not set
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_LP8788 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX77686=y
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TWL4030 is not set
CONFIG_RTC_DRV_RC5T583=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
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
# CONFIG_ECHO is not set
# CONFIG_PANEL is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
# CONFIG_AD799X is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
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

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

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
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7854=y
# CONFIG_ADE7854_I2C is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_GPIO_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_ZSMALLOC is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# CONFIG_ASHMEM is not set
# CONFIG_ANDROID_LOGGER is not set
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
# CONFIG_SYNC is not set
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_SDIO=y
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=y
# CONFIG_X86_PLATFORM_DEVICES is not set

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
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
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
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_SENSORS_TSL2563=y
CONFIG_VCNL4000=y
CONFIG_HID_SENSOR_ALS=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
# CONFIG_PWM_TWL is not set
CONFIG_PWM_TWL_LED=y
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

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
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=y
CONFIG_EXOFS_DEBUG=y
# CONFIG_F2FS_FS is not set
CONFIG_ORE=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
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
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
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
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
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
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_AUDIT is not set
CONFIG_IMA_LSM_RULES=y
CONFIG_IMA_APPRAISE=y
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_XOR=y
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
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
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
# CONFIG_CRYPTO_CCM is not set
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
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

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
CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
CONFIG_CRYPTO_TWOFISH_AVX2_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
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
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--zhXaljGHf11kAtnf--
