Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaDGL1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:27:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:11410 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbaDGL0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:26:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,809,1389772800"; 
   d="log'?scan'208";a="508350746"
Date: Mon, 7 Apr 2014 19:17:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ken Cox <jkc@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, Jet Chen <jet.chen@intel.com>
Subject: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Message-ID: <20140407111725.GC25152@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ken,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

commit 12e364b9f08aa335dc7716ce74113e834c993765
Author:     Ken Cox <jkc@redhat.com>
AuthorDate: Tue Mar 4 07:58:07 2014 -0600
Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitDate: Tue Mar 4 16:58:21 2014 -0800

    staging: visorchipset driver to provide registration and other services
    
    The visorchipset module receives device creation and destruction
    events from the Command service partition of s-Par, as well as
    controlling registration of shared device drivers with the s-Par
    driver core. The events received are used to populate other s-Par
    modules with their assigned shared devices. Visorchipset is required
    for shared device drivers to function properly. Visorchipset also
    stores information for handling dump disk device creation during
    kdump.
    
    In operation, the visorchipset module processes device creation and
    destruction messages sent by s-Par's Command service partition through
    a channel. These messages result in creation (or destruction) of each
    virtual bus and virtual device. Each bus and device is also associated
    with a communication channel, which is used to communicate with one or
    more IO service partitions to perform device IO on behalf of the
    guest.
    
    Signed-off-by: Ken Cox <jkc@redhat.com>
    Cc: Ben Romer <sparmaintainer@unisys.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

+-------------------------------------------------+------------+---------------+
|                                                 | 12e364b9f0 | next-20140403 |
+-------------------------------------------------+------------+---------------+
| boot_successes                                  | 12         | 0             |
| boot_failures                                   | 18         | 3             |
| invalid_opcode                                  | 2          |               |
| RIP:visorchipset_init                           | 10         | 3             |
| Kernel_panic-not_syncing:Fatal_exception        | 10         | 3             |
| backtrace:visorchipset_init                     | 10         | 3             |
| backtrace:kernel_init_freeable                  | 10         | 3             |
| loadedinvalid_opcode                            | 8          |               |
| BUG:kernel_early_hang_without_any_printk_output | 8          |               |
| loadedinvalid_opcode:PREEMPT_SMP                | 0          | 2             |
| invalid_opcode:PREEMPT_SMP                      | 0          | 1             |
| early-boot-hang                                 | 0          | 4             |
+-------------------------------------------------+------------+---------------+

[   24.135101] FPGA image file name: xlinx_fpga_firmware.bit
[   24.137595] GPIO INIT FAIL!!
[   24.141283] driver version 1.0.0.0 loaded
[   24.142539] chipset driver version 1.0.0.0 loadedinvalid opcode: 0000 [#1] PREEMPT SMP 
[   24.144793] Modules linked in:
[   24.145303] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-00621-g12e364b #1
[   24.145303] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   24.145303] task: ffff88001157a010 ti: ffff88001157c000 task.ti: ffff88001157c000
[   24.145303] RIP: 0010:[<ffffffff81e37115>]  [<ffffffff81e37115>] visorchipset_init+0x7b/0x8c5
[   24.145303] RSP: 0000:ffff88001157de58  EFLAGS: 00000286
[   24.145303] RAX: 000000000000070b RBX: 0000000000000004 RCX: 4000000000000000
[   24.145303] RDX: a70aba7500000000 RSI: ffff88001157de5c RDI: ffff88001157de58
[   24.145303] RBP: ffff88001157de90 R08: 0000000000000002 R09: ffff88001157de60
[   24.145303] R10: ffff88001157de64 R11: 0000000000000000 R12: ffff88001157de5c
[   24.145303] R13: ffff88001157de60 R14: ffff88001157de64 R15: 0000000000000000
[   24.145303] FS:  0000000000000000(0000) GS:ffff880012600000(0000) knlGS:0000000000000000
[   24.145303] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   24.145303] CR2: ffff880002992000 CR3: 0000000001c07000 CR4: 00000000003006f0
[   24.145303] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   24.145303] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[   24.145303] Stack:
[   24.145303]  00000800000306c1 078bfbf982d82203 ffffffff81e3709a 0000000000000000
[   24.145303]  00000000000001df 0000000000000000 0000000000000000 ffff88001157df08
[   24.145303]  ffffffff810002b2 ffffffff810b2600 ffff88001157df08 ffffffff810b27db
[   24.145303] Call Trace:
[   24.145303]  [<ffffffff81e3709a>] ? visorchannel_init+0x1d/0x1d
[   24.145303]  [<ffffffff810002b2>] do_one_initcall+0x8e/0x138
[   24.145303]  [<ffffffff810b2600>] ? param_array_set+0xef/0xf5
[   24.145303]  [<ffffffff810b27db>] ? parse_args+0x180/0x248
[   24.145303]  [<ffffffff81dfbf86>] kernel_init_freeable+0x108/0x199
[   24.145303]  [<ffffffff81dfb73a>] ? do_early_param+0x8a/0x8a
[   24.145303]  [<ffffffff8173f08e>] ? rest_init+0xc2/0xc2
[   24.145303]  [<ffffffff8173f097>] kernel_init+0x9/0xda
[   24.145303]  [<ffffffff8176024c>] ret_from_fork+0x7c/0xb0
[   24.145303]  [<ffffffff8173f08e>] ? rest_init+0xc2/0xc2
[   24.145303] Code: 8d 65 cc 4c 8d 6d d0 4c 8d 75 d4 79 21 48 ba 00 00 00 00 75 ba 0a a7 48 b9 00 00 00 00 00 00 00 40 bb 04 00 00 00 b8 0b 07 00 00 <0f> 01 c1 8b 35 c2 c4 b4 00 48 c7 c7 f5 93 b4 81 31 c0 e8 3b 21 
[   24.145303] RIP  [<ffffffff81e37115>] visorchipset_init+0x7b/0x8c5
[   24.145303]  RSP <ffff88001157de58>
[   24.187247] ---[ end trace 62b5721899a66a6c ]---
[   24.188157] Kernel panic - not syncing: Fatal exception

git bisect start 4b22efdd5595f0acb48f02bf664a451ee98f9a2e v3.14 --
git bisect  bad 850ba1df2c6aa754c9b2c8c23eac3161373d5492  # 16:46      0-      2  Merge remote-tracking branch 'samsung/for-next'
git bisect good 62ff577fa2fec87edbf26f53e87210ba726d4d44  # 16:51     30+      1  Merge tag 'edac_for_3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp
git bisect  bad e6d9bfc63813882c896bf7ea6f6b14ca7b50b755  # 16:54      0-     15  Merge branch 'powernv-cpuidle' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git bisect  bad b33ce442993865180292df2a314ee5251ba38b50  # 16:56      0-      1  Merge branch 'for-3.15/drivers' of git://git.kernel.dk/linux-block
git bisect  bad c12e69c6aaf785fd307d05cb6f36ca0e7577ead7  # 16:59      1-      3  Merge tag 'staging-3.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect good c70929147a10fa4538886cb23b934b509c4c0e49  # 17:04     30+      0  Merge tag 'sound-3.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good 675c354a95d5375153b8bb80a0448cab916c7991  # 17:08     30+      0  Merge tag 'char-misc-3.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect good 158e0d3621683ee0cdfeeba56f0e5ddd97ae984f  # 17:12     30+      0  Merge tag 'driver-core-3.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
git bisect  bad 10933a9cfa258048813fd8a287be844d30711731  # 17:16      0-     11  staging: comedi: pcl818: exit interrupt quick when there is nothing to do
git bisect good b14ec4bd3f576be2bb7dd4c69764a422d782e06d  # 17:19     30+      3  staging: comedi: pcl816: remove 'last_int_sub' from private data
git bisect good f37e756033c918c198bc2df6dada27df25ce5a6f  # 17:26     30+      0  staging: rtl8187se: Convert Stats typedef into a struct
git bisect good 99a1b98b32211713d8e544e9737a5fa20b73dce3  # 17:37     30+      1  staging: comedi: ke_counter: fix ke_counter_insn_write()
git bisect  bad 9b073ac53eea902712f88388b42efcebce211bec  # 17:40      0-      4  staging: dgap: Fix various previously missed checkpatch errors
git bisect  bad 6c76aab5bdec769ac05bb81dc6bb46cd5a253b4b  # 17:43      1-      4  drivers: staging: rtl8187se: refactor/clean signal smoothing
git bisect good 5c2f26def8f3bb252c32df4cbe0979140d8face6  # 17:50     30+      0  staging: octeon-ethernet: add missing include
git bisect  bad 7b2a2d8383d08793aac3f157fa3f38ea90c5d3c0  # 17:53      0-      2  staging: visorchannelstub driver to provide channel support routines
git bisect good 9d9baadd4069c77a97bf530abad9ddb74875fe76  # 18:03     30+      0  staging: visorutil driver to provide common functionality to other s-Par drivers
git bisect  bad 12e364b9f08aa335dc7716ce74113e834c993765  # 18:28      7-     10  staging: visorchipset driver to provide registration and other services
git bisect good e423812a9e430913e41c6565922142fe22f83ad7  # 18:34     43+      0  staging: visorchannel module
# first bad commit: [12e364b9f08aa335dc7716ce74113e834c993765] staging: visorchipset driver to provide registration and other services
git bisect good e423812a9e430913e41c6565922142fe22f83ad7  # 18:39    129+      0  staging: visorchannel module
git bisect  bad 4b22efdd5595f0acb48f02bf664a451ee98f9a2e  # 18:40      0-      7  Add linux-next specific files for 20140403
git bisect  bad 18a1a7a1d862ae0794a0179473d08a414dd49234  # 18:45      0-      1  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile
git bisect  bad abfcdfd63f0b68994bf3d0de84ddb7220d73a063  # 18:48      0-     16  Add linux-next specific files for 20140407


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm
	-kernel $kernel
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

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-f4-128:20140407182830:x86_64-randconfig-br0-04050702:3.14.0-rc5-00621-g12e364b:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.14.0-rc5-00621-g12e364b (kbuild@brickland3) =
(gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP PREEMPT Mon Apr 7 18:17:48 CS=
T 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-br0-04050702/next:master=
:12e364b9f08aa335dc7716ce74113e834c993765:bisect-linux8/.vmlinuz-12e364b9f0=
8aa335dc7716ce74113e834c993765-20140407181806-27-f4 branch=3Dnext/master BO=
OT_IMAGE=3D/kernel/x86_64-randconfig-br0-04050702/12e364b9f08aa335dc7716ce7=
4113e834c993765/vmlinuz-3.14.0-rc5-00621-g12e364b drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02992000, 0x02992fff] PGTABLE
[    0.000000] BRK [0x02993000, 0x02993fff] PGTABLE
[    0.000000] BRK [0x02994000, 0x02994fff] PGTABLE
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
[    0.000000] BRK [0x02995000, 0x02995fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: RSDP 00000000000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013ffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013ffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013ffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 0000000013ffff40 000040
[    0.000000] ACPI: SSDT 0000000013fff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x12916000-0x1293cfff]
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
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012600000 s77824 r8192=
 d20480 u1048576
[    0.000000] pcpu-alloc: s77824 r8192 d20480 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-br0-04050702/next=
:master:12e364b9f08aa335dc7716ce74113e834c993765:bisect-linux8/.vmlinuz-12e=
364b9f08aa335dc7716ce74113e834c993765-20140407181806-27-f4 branch=3Dnext/ma=
ster BOOT_IMAGE=3D/kernel/x86_64-randconfig-br0-04050702/12e364b9f08aa335dc=
7716ce74113e834c993765/vmlinuz-3.14.0-rc5-00621-g12e364b drbd.minor_count=
=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 270620K/327280K available (7567K kernel code, 1947K =
rwdata, 3744K rodata, 1664K init, 10248K bss, 56660K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:56 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.14.0-rc5-00621-g12e364b (kbuild@brickland3) =
(gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP PREEMPT Mon Apr 7 18:17:48 CS=
T 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-br0-04050702/next:master=
:12e364b9f08aa335dc7716ce74113e834c993765:bisect-linux8/.vmlinuz-12e364b9f0=
8aa335dc7716ce74113e834c993765-20140407181806-27-f4 branch=3Dnext/master BO=
OT_IMAGE=3D/kernel/x86_64-randconfig-br0-04050702/12e364b9f08aa335dc7716ce7=
4113e834c993765/vmlinuz-3.14.0-rc5-00621-g12e364b drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02992000, 0x02992fff] PGTABLE
[    0.000000] BRK [0x02993000, 0x02993fff] PGTABLE
[    0.000000] BRK [0x02994000, 0x02994fff] PGTABLE
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
[    0.000000] BRK [0x02995000, 0x02995fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: RSDP 00000000000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013ffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013ffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013ffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 0000000013ffff40 000040
[    0.000000] ACPI: SSDT 0000000013fff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x12916000-0x1293cfff]
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
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012600000 s77824 r8192=
 d20480 u1048576
[    0.000000] pcpu-alloc: s77824 r8192 d20480 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-br0-04050702/next=
:master:12e364b9f08aa335dc7716ce74113e834c993765:bisect-linux8/.vmlinuz-12e=
364b9f08aa335dc7716ce74113e834c993765-20140407181806-27-f4 branch=3Dnext/ma=
ster BOOT_IMAGE=3D/kernel/x86_64-randconfig-br0-04050702/12e364b9f08aa335dc=
7716ce74113e834c993765/vmlinuz-3.14.0-rc5-00621-g12e364b drbd.minor_count=
=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 270620K/327280K available (7567K kernel code, 1947K =
rwdata, 3744K rodata, 1664K init, 10248K bss, 56660K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:56 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
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
[    0.000000]  memory used by lock dependency info: 5855 kB
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
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2693.415 MHz processor
[    0.010472] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5388.28 BogoMIPS (lpj=3D8978050)
[    0.011135] pid_max: default: 32768 minimum: 301
[    0.018634] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.020780] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.021969] Mount-cache hash table entries: 256
[    0.045678] mce: CPU supports 10 MCE banks
[    0.055579] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.055579] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.055579] tlb_flushall_shift: 6
[    0.065448] Freeing SMP alternatives memory: 28K (ffffffff81f88000 - fff=
fffff81f8f000)
[    0.098921] Getting VERSION: 50011
[    0.099607] Getting VERSION: 50011
[    0.100126] Getting ID: 0
[    0.100621] Getting ID: ff000000
[    0.101189] Getting LVT0: 8700
[    0.101711] Getting LVT1: 8400
[    0.102628] enabled ExtINT on CPU#0
[    0.104418] ENABLING IO-APIC IRQs
[    0.105046] Synchronizing Arb IDs.
[    0.105621] init IO_APIC IRQs
[    0.106212]  apic 0 pin 0 not connected
[    0.107612] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.110203] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.111578] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.112898] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.113333] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.113333] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.113333] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.113333] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.113455] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.114780] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.116113] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.116666] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.116666] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.116666] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.116666] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.116666]  apic 0 pin 16 not connected
[    0.116666]  apic 0 pin 17 not connected
[    0.116666]  apic 0 pin 18 not connected
[    0.116666]  apic 0 pin 19 not connected
[    0.116666]  apic 0 pin 20 not connected
[    0.116666]  apic 0 pin 21 not connected
[    0.116666]  apic 0 pin 22 not connected
[    0.116666]  apic 0 pin 23 not connected
[    0.116666] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.150519] smpboot: CPU0: Intel Core Processor (Haswell) (fam: 06, mode=
l: 3c, stepping: 01)
[    0.152673] Using local APIC timer interrupts.
[    0.152673] calibrating APIC timer ...
[    0.156666] ... lapic delta =3D 6249933
[    0.156666] ... PM-Timer delta =3D 357951
[    0.156666] ... PM-Timer result ok
[    0.156666] ..... delta 6249933
[    0.156666] ..... mult: 268432605
[    0.156666] ..... calibration result: 3333297
[    0.156666] ..... CPU clock speed is 2693.2307 MHz.
[    0.156666] ..... host bus clock speed is 1000.0297 MHz.
[    0.158253] Performance Events: unsupported p6 CPU model 60 no PMU drive=
r, software events only.
[    0.212859] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.227755] x86: Booting SMP configuration:
[    0.228536] .... node  #0, CPUs:      #1
[    0.013333] masked ExtINT on CPU#1
[    0.013333] calibrate_delay_direct() dropping max bogoMips estimate 2 =
=3D 62951025
[    0.013333] calibrate_delay_direct() dropping max bogoMips estimate 4 =
=3D 54165614
[    0.013333] calibrate_delay_direct() dropping max bogoMips estimate 0 =
=3D 24184775
[    0.354326] x86: Booted up 1 node, 2 CPUs
[    0.355320] ----------------
[    0.355817] | NMI testsuite:
[    0.356298] --------------------
[    0.356712]   remote IPI:  ok  |
[    0.365802]    local IPI:  ok  |
[    0.376988] --------------------
[    0.377552] Good, all   2 testcases passed! |
[    0.378339] ---------------------------------
[    0.379117] smpboot: Total of 2 processors activated (12727.96 BogoMIPS)
[    0.430161] devtmpfs: initialized
[    0.479012] prandom: seed boundary self test passed
[    0.485958] prandom: 100 self tests passed
[    0.500138] regulator-dummy: no parameters
[    0.509011] NET: Registered protocol family 16
[    0.525246] cpuidle: using governor ladder
[    0.526371] cpuidle: using governor menu
[    0.530062] ACPI: bus type PCI registered
[    0.535190] PCI: Using configuration type 1 for base access
[    0.741242] bio: create slab <bio-0> at 0
[    0.753432] ACPI: Added _OSI(Module Device)
[    0.753432] ACPI: Added _OSI(Processor Device)
[    0.754304] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.755367] ACPI: Added _OSI(Processor Aggregator Device)
[    0.914759] ACPI: Interpreter enabled
[    0.916424] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131218/hwxface-580)
[    0.918561] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131218/hwxface-580)
[    0.922709] ACPI: (supports S0 S3 S5)
[    0.923486] ACPI: Using IOAPIC for interrupt routing
[    0.927877] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.319420] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.320478] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    1.323624] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.336610] PCI host bridge to bus 0000:00
[    1.336610] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.343355] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.347222] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.348500] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.350060] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.352588] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.363290] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.373249] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.379008] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.386537] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.386537] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.390107] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.399884] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.404610] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.407694] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.414337] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.422281] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.424357] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.427159] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.432772] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.439903] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.439903] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.465997] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.470698] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.474900] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.479072] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.481651] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.495527] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.512090] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.513401] vgaarb: loaded
[    1.514022] vgaarb: bridge control possible 0000:00:02.0
[    1.535338] SCSI subsystem initialized
[    1.538909] libata version 3.00 loaded.
[    1.543023] ACPI: bus type USB registered
[    1.546715] usbcore: registered new interface driver usbfs
[    1.547879] usbcore: registered new interface driver hub
[    1.551763] usbcore: registered new device driver usb
[    1.557610] pps_core: LinuxPPS API ver. 1 registered
[    1.558619] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.560383] PTP clock support registered
[    1.563662] EDAC MC: Ver: 3.0.0
[    1.567800] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    1.572176] PCI: Using ACPI for IRQ routing
[    1.573264] PCI: pci_cache_line_size set to 64 bytes
[    1.574000] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.576767] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.595475] irda_init()
[    1.598121] NET: Registered protocol family 23
[    1.600928] Bluetooth: Core ver 2.18
[    1.602483] NET: Registered protocol family 31
[    1.603425] Bluetooth: HCI device and connection manager initialized
[    1.605025] Bluetooth: HCI socket layer initialized
[    1.606383] Bluetooth: L2CAP socket layer initialized
[    1.607368] Bluetooth: SCO socket layer initialized
[    1.608740] NET: Registered protocol family 8
[    1.610074] NET: Registered protocol family 20
[    1.617109] nfc: nfc_init: NFC Core ver 0.1
[    1.619061] NET: Registered protocol family 39
[    1.625330] Switched to clocksource hpet
[    1.632161] FS-Cache: Loaded
[    1.634024] pnp: PnP ACPI init
[    1.635612] ACPI: bus type PNP registered
[    1.638116] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.642352] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.644312] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.647442] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.649146] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.652138] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.654250] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.655817] pnp 00:03: [dma 2]
[    1.658182] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.660352] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.663741] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.665926] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.669272] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.671445] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    1.674528] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.681646] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.686541] pnp: PnP ACPI: found 8 devices
[    1.687342] ACPI: bus type PNP unregistered
[    1.834273] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.835314] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.836188] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.837267] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.839156] NET: Registered protocol family 1
[    1.840360] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.841374] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.842589] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.843765] pci 0000:00:02.0: Boot video device
[    1.844647] PCI: CLS 0 bytes, default 64
[    1.857481] Trying to unpack rootfs image as initramfs...
[   11.979621] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013=
ff0000)
[   11.998014] RAPL PMU detected, hw unit 2^-0 Joules, API unit is 2^-32 Jo=
ules, 3 fixed counters 10737418240 ms ovfl timer
[   12.000508] Machine check injector initialized
[   12.041024] cryptomgr_test (35) used greatest stack depth: 6432 bytes le=
ft
[   12.084377] cryptomgr_test (37) used greatest stack depth: 5256 bytes le=
ft
[   12.178654] cryptomgr_test (54) used greatest stack depth: 4696 bytes le=
ft
[   12.189954] AVX2 version of gcm_enc/dec engaged.
[   12.225436] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[   12.237364] AVX or AES-NI instructions are not detected.
[   12.238747] AVX instructions are not detected.
[   12.239891] AVX instructions are not detected.
[   12.240833] AVX instructions are not detected.
[   12.242162] AVX2 or AES-NI instructions are not detected.
[   12.243965] AVX2 instructions are not detected.
[   12.264722] futex hash table entries: 512 (order: 4, 65536 bytes)
[   12.267891] audit: initializing netlink subsys (disabled)
[   12.272444] audit: type=3D2000 audit(1396895292.266:1): initialized
[   12.380638] Kprobe smoke test started
[   12.500503] Kprobe smoke test passed successfully
[   12.526599] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   12.541438] VFS: Disk quotas dquot_6.5.2
[   12.545209] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   12.570425] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[   12.572576] QNX4 filesystem 0.2.3 registered.
[   12.574071] QNX6 filesystem 1.0.0 registered.
[   12.581190] JFS: nTxBlock =3D 2296, nTxLock =3D 18368
[   12.601122] SGI XFS with security attributes, realtime, large block/inod=
e numbers, no debug enabled
[   12.627768] GFS2 installed
[   12.628747] msgmni has been set to 574
[   12.729897] alg: No test for crc32 (crc32-table)
[   12.736862] alg: No test for lz4hc (lz4hc-generic)
[   12.743625] alg: No test for stdrng (krng)
[   12.752557] NET: Registered protocol family 38
[   12.756475] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[   12.757989] io scheduler noop registered (default)
[   12.759252] list_sort_test: start testing list_sort()
[   12.768781] test_string_helpers: Running tests...
[   12.770428] rbtree testing
[   12.992368] tsc: Refined TSC clocksource calibration: 2693.458 MHz
[   12.996333] Switched to clocksource tsc
[   15.986710]  -> 86613 cycles
[   16.306983] augmented rbtree testing -> 137973 cycles
[   21.776247] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   21.780248] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   21.782536] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   21.795659] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   21.797837] ACPI: Power Button [PWRF]
[   23.007889] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   23.042640] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   23.079240] Non-volatile memory driver v1.3
[   23.080665] smapi::smapi_init, ERROR invalid usSmapiID
[   23.081795] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[   23.083975] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[   23.085631] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   23.212759] brd: module loaded
[   23.230923] nbd: registered device at major 43
[   23.347879] dummy-irq: no IRQ given.  Use irq=3DN
[   23.351347] lkdtm: No crash points registered, enable through debugfs
[   23.354438] Phantom Linux Driver, version n0.9.8, init OK
[   23.356818] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   23.364084] Guest personality initialized and is inactive
[   23.367897] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D60)
[   23.369360] Initialized host personality
[   23.382593] usbcore: registered new interface driver pn533
[   23.402753] emc: device handler registered
[   23.403788] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[   23.408367] SCSI Media Changer driver v0.25=20
[   23.411127] osd: LOADED open-osd 0.2.1
[   23.430749] arcnet loaded.
[   23.431399] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[   23.433140] slcan: serial line CAN interface driver
[   23.434128] slcan: 10 dynamic interface channels.
[   23.435364] CAN device driver interface
[   23.437054] usbcore: registered new interface driver esd_usb2
[   23.438214] sja1000 CAN netdevice driver
[   23.440013] cc770: CAN netdevice driver
[   23.446557] usbcore: registered new interface driver mcs7780
[   23.460715] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMA=
C hardware
[   23.462983] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[   23.465349] usbcore: registered new interface driver pegasus
[   23.467376] usbcore: registered new interface driver r8152
[   23.469270] usbcore: registered new interface driver ax88179_178a
[   23.471258] usbcore: registered new interface driver cdc_ether
[   23.473318] usbcore: registered new interface driver r815x
[   23.475197] usbcore: registered new interface driver cdc_eem
[   23.477165] usbcore: registered new interface driver net1080
[   23.479083] usbcore: registered new interface driver rndis_host
[   23.481032] usbcore: registered new interface driver zaurus
[   23.483251] usbcore: registered new interface driver ipheth
[   23.485471] usbcore: registered new interface driver cdc_ncm
[   23.487423] usbcore: registered new interface driver cdc_mbim
[   23.488714] Fusion MPT base driver 3.04.20
[   23.489645] Copyright (c) 1999-2008 LSI Corporation
[   23.491067] Fusion MPT FC Host driver 3.04.20
[   23.517294] aoe: AoE v85 initialised.
[   23.528101] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   23.529766] uhci_hcd: USB Universal Host Controller Interface driver
[   23.533031] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[   23.534244] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[   23.539393] usbcore: registered new interface driver cdc_wdm
[   23.542454] usbcore: registered new interface driver usb-storage
[   23.544445] usbcore: registered new interface driver ums-alauda
[   23.546510] usbcore: registered new interface driver ums_eneub6250
[   23.551220] usbcore: registered new interface driver usbserial
[   23.553287] usbcore: registered new interface driver belkin_sa
[   23.555966] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[   23.558692] usbcore: registered new interface driver digi_acceleport
[   23.560759] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[   23.563165] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[   23.565361] usbcore: registered new interface driver ftdi_sio
[   23.567306] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[   23.569580] usbcore: registered new interface driver ipw
[   23.571247] usbserial: USB Serial support registered for IPWireless conv=
erter
[   23.573502] usbcore: registered new interface driver ir_usb
[   23.575353] usbserial: USB Serial support registered for IR Dongle
[   23.577285] usbcore: registered new interface driver navman
[   23.579153] usbserial: USB Serial support registered for navman
[   23.581026] usbcore: registered new interface driver pl2303
[   23.583056] usbserial: USB Serial support registered for pl2303
[   23.584818] usbcore: registered new interface driver qcaux
[   23.586836] usbserial: USB Serial support registered for qcaux
[   23.588700] usbcore: registered new interface driver qcserial
[   23.590549] usbserial: USB Serial support registered for Qualcomm USB mo=
dem
[   23.592659] usbcore: registered new interface driver symbolserial
[   23.594551] usbserial: USB Serial support registered for symbol
[   23.596538] usbcore: registered new interface driver ti_usb_3410_5052
[   23.598594] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[   23.600814] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[   23.603216] usbcore: registered new interface driver keyspan_pda
[   23.605027] usbserial: USB Serial support registered for Keyspan PDA
[   23.607132] usbserial: USB Serial support registered for Xircom / Entreg=
ra PGS - (prerenumeration)
[   23.609711] usbcore: registered new interface driver zte_ev
[   23.611679] usbserial: USB Serial support registered for zte_ev
[   23.613753] usbcore: registered new interface driver adutux
[   23.618097] usbcore: registered new interface driver appledisplay
[   23.620259] usbcore: registered new interface driver cytherm
[   23.622306] usbcore: registered new interface driver emi62 - firmware lo=
ader
[   23.624480] usbcore: registered new interface driver idmouse
[   23.626888] usbcore: registered new interface driver iowarrior
[   23.628948] usbcore: registered new interface driver isight_firmware
[   23.631010] usbcore: registered new interface driver usb_ehset_test
[   23.633179] usbcore: registered new interface driver yurex
[   23.637279] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   23.646797] serio: i8042 KBD port at 0x60,0x64 irq 1
[   23.652426] serio: i8042 AUX port at 0x60,0x64 irq 12
[   23.656049] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[   23.670213] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   23.672455] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[   23.696483] i2c /dev entries driver
[   23.699665] i2c-parport-light: adapter type unspecified
[   23.703799] pps pps0: new PPS source ktimer
[   23.704563] pps pps0: ktimer PPS source registered
[   23.705465] Driver for 1-wire Dallas network protocol.
[   23.709189] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   23.711867] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   23.736095] pc87360: PC8736x not detected, module not inserted
[   23.744724] usbcore: registered new interface driver pcwd_usb
[   23.747147] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[   23.750842] acquirewdt: I/O address 0x0043 already in use
[   23.751953] acquirewdt: probe of acquirewdt failed with error -5
[   23.753170] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[   23.756918] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D1)
[   23.757903] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   23.759517] iTCO_vendor_support: vendor-support=3D0
[   23.760361] sc1200wdt: build 20020303
[   23.761544] sc1200wdt: io parameter must be specified
[   23.762850] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   23.766390] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   23.769108] smsc37b787_wdt: Unable to register miscdev on minor 130
[   23.770288] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   23.771363] w83697hf_wdt: watchdog not found at address 0x2e
[   23.772849] w83697hf_wdt: No W83697HF/HG could be found
[   23.773763] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   23.775359] w83697ug_wdt: No W83697UG/UF could be found
[   23.776302] w83977f_wdt: driver v1.00
[   23.777095] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   23.778225] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[   23.900881] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/none/1.1.2.2
[   23.902645] Modular ISDN core version 1.1.29
[   23.906430] NET: Registered protocol family 34
[   23.907268] DSP module 2.0
[   23.907797] mISDN_dsp: DSP clocks every 80 samples. This equals 3 jiffie=
s.
[   23.920869] mISDN: HFC-multi driver 2.03
[   23.922983] Winbond W6692 PCI driver Rev. 2.0
[   23.924743] Netjet PCI driver Rev. 2.0
[   23.926579] mISDNipac module version 2.0
[   23.927537] dss1_divert module successfully installed
[   23.929572] EDAC DEBUG: i5400_init: MC:
[   23.931410] EDAC DEBUG: i7core_init:=20
[   23.935654] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
[   23.941334] ledtrig-cpu: registered to indicate activity on CPUs
[   23.958825] usbip_core: usbip_core_init:787: USB/IP Core v1.0.0
[   23.962455] vhci_hcd: vhci_hcd_probe:997: name vhci_hcd id -1
[   23.964236] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[   23.970661] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 1
[   23.972457] vhci_hcd: vhci_start:881: enter vhci_start
[   24.005827] hub 1-0:1.0: USB hub found
[   24.007081] vhci_hcd: vhci_hub_control:244: typeReq a006 wValue 2900 wIn=
dex 0
[   24.008950] vhci_hcd: vhci_hub_control:302:  GetHubDescriptor
[   24.010025] vhci_hcd: vhci_hub_control:395: port -1
[   24.010810] vhci_hcd: vhci_hub_control:402:  bye
[   24.012169] hub 1-0:1.0: 8 ports detected
[   24.013998] vhci_hcd: vhci_hub_control:244: typeReq a000 wValue 0 wIndex=
 0
[   24.015372] vhci_hcd: vhci_hub_control:306:  GetHubStatus
[   24.016282] vhci_hcd: vhci_hub_control:395: port -1
[   24.017115] vhci_hcd: vhci_hub_control:402:  bye
[   24.032409] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 1
[   24.033605] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[   24.034624] vhci_hcd: vhci_hub_control:395: port 0
[   24.035510] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[   24.036926] vhci_hcd: dump_port_status_diff:115:  +POWER
[   24.037762] vhci_hcd: dump_port_status_diff:119:=20
[   24.038640] vhci_hcd: vhci_hub_control:402:  bye
[   24.039722] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 2
[   24.040849] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[   24.042011] vhci_hcd: vhci_hub_control:395: port 1
[   24.042765] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[   24.044112] vhci_hcd: dump_port_status_diff:115:  +POWER
[   24.044931] vhci_hcd: dump_port_status_diff:119:=20
[   24.045778] vhci_hcd: vhci_hub_control:402:  bye
[   24.046769] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 3
[   24.047825] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[   24.048969] vhci_hcd: vhci_hub_control:395: port 2
[   24.049901] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[   24.051464] vhci_hcd: dump_port_status_diff:115:  +POWER
[   24.052657] vhci_hcd: dump_port_status_diff:119:=20
[   24.053716] vhci_hcd: vhci_hub_control:402:  bye
[   24.054687] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 4
[   24.055857] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[   24.056931] vhci_hcd: vhci_hub_control:395: port 3
[   24.057689] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[   24.059086] vhci_hcd: dump_port_status_diff:115:  +POWER
[   24.060000] vhci_hcd: dump_port_status_diff:119:=20
[   24.060734] vhci_hcd: vhci_hub_control:402:  bye
[   24.061744] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 5
[   24.062839] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[   24.063902] vhci_hcd: vhci_hub_control:395: port 4
[   24.064655] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[   24.066031] vhci_hcd: dump_port_status_diff:115:  +POWER
[   24.066932] vhci_hcd: dump_port_status_diff:119:=20
[   24.067672] vhci_hcd: vhci_hub_control:402:  bye
[   24.068686] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 6
[   24.069824] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[   24.070820] vhci_hcd: vhci_hub_control:395: port 5
[   24.071568] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[   24.072980] vhci_hcd: dump_port_status_diff:115:  +POWER
[   24.073876] vhci_hcd: dump_port_status_diff:119:=20
[   24.074609] vhci_hcd: vhci_hub_control:402:  bye
[   24.075602] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 7
[   24.076733] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[   24.077724] vhci_hcd: vhci_hub_control:395: port 6
[   24.078609] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[   24.079949] vhci_hcd: dump_port_status_diff:115:  +POWER
[   24.080773] vhci_hcd: dump_port_status_diff:119:=20
[   24.081506] vhci_hcd: vhci_hub_control:402:  bye
[   24.082496] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 8
[   24.083631] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[   24.084623] vhci_hcd: vhci_hub_control:395: port 7
[   24.085475] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[   24.086814] vhci_hcd: dump_port_status_diff:115:  +POWER
[   24.087636] vhci_hcd: dump_port_status_diff:119:=20
[   24.088495] vhci_hcd: vhci_hub_control:402:  bye
[   24.094191] vhci_hcd: vhci_hcd_probe:1025: bye
[   24.095186] vhci_hcd: vhci_hcd_init:1147: USB/IP 'Virtual' Host Controll=
er (VHCI) Driver v1.0.0
[   24.097728] usbcore: registered new interface driver rts5139
[   24.098774] rts5208: Initializing Realtek PCIE storage driver...
[   24.101951] usbcore: registered new interface driver tranzport
[   24.103930] usbcore: registered new interface driver alphatrack
[   24.105522] usbcore: registered new interface driver serqt_usb2
[   24.107150] usbserial: USB Serial support registered for Quatech USB to =
Serial Driver
[   24.108675] Loading crystalhd 0.9.27
[   24.114411] input: Speakup as /devices/virtual/input/input3
[   24.115471] evbug: Connected device: input3 (Speakup at speakup/input0)
[   24.121851] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[   24.124171] speakup 3.1.6: initialized
[   24.124925] synth name on entry is: (null)
[   24.125750] dgnc: dgnc-1.3-16, Digi International Part Number 40002369_F
[   24.127008] dgnc: For the tools package or updated drivers please visit =
http://www.digi.com
[   24.133596] FPGA DOWNLOAD --->
[   24.134219] built at Mon Apr  7 18:02:05 2014 UTC
[   24.135101] FPGA image file name: xlinx_fpga_firmware.bit
[   24.137595] GPIO INIT FAIL!!
[   24.141283] driver version 1.0.0.0 loaded
[   24.142539] chipset driver version 1.0.0.0 loadedinvalid opcode: 0000 [#=
1] PREEMPT SMP=20
[   24.144793] Modules linked in:
[   24.145303] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-00621-g=
12e364b #1
[   24.145303] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   24.145303] task: ffff88001157a010 ti: ffff88001157c000 task.ti: ffff880=
01157c000
[   24.145303] RIP: 0010:[<ffffffff81e37115>]  [<ffffffff81e37115>] visorch=
ipset_init+0x7b/0x8c5
[   24.145303] RSP: 0000:ffff88001157de58  EFLAGS: 00000286
[   24.145303] RAX: 000000000000070b RBX: 0000000000000004 RCX: 40000000000=
00000
[   24.145303] RDX: a70aba7500000000 RSI: ffff88001157de5c RDI: ffff8800115=
7de58
[   24.145303] RBP: ffff88001157de90 R08: 0000000000000002 R09: ffff8800115=
7de60
[   24.145303] R10: ffff88001157de64 R11: 0000000000000000 R12: ffff8800115=
7de5c
[   24.145303] R13: ffff88001157de60 R14: ffff88001157de64 R15: 00000000000=
00000
[   24.145303] FS:  0000000000000000(0000) GS:ffff880012600000(0000) knlGS:=
0000000000000000
[   24.145303] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   24.145303] CR2: ffff880002992000 CR3: 0000000001c07000 CR4: 00000000003=
006f0
[   24.145303] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   24.145303] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 00000000000=
00000
[   24.145303] Stack:
[   24.145303]  00000800000306c1 078bfbf982d82203 ffffffff81e3709a 00000000=
00000000
[   24.145303]  00000000000001df 0000000000000000 0000000000000000 ffff8800=
1157df08
[   24.145303]  ffffffff810002b2 ffffffff810b2600 ffff88001157df08 ffffffff=
810b27db
[   24.145303] Call Trace:
[   24.145303]  [<ffffffff81e3709a>] ? visorchannel_init+0x1d/0x1d
[   24.145303]  [<ffffffff810002b2>] do_one_initcall+0x8e/0x138
[   24.145303]  [<ffffffff810b2600>] ? param_array_set+0xef/0xf5
[   24.145303]  [<ffffffff810b27db>] ? parse_args+0x180/0x248
[   24.145303]  [<ffffffff81dfbf86>] kernel_init_freeable+0x108/0x199
[   24.145303]  [<ffffffff81dfb73a>] ? do_early_param+0x8a/0x8a
[   24.145303]  [<ffffffff8173f08e>] ? rest_init+0xc2/0xc2
[   24.145303]  [<ffffffff8173f097>] kernel_init+0x9/0xda
[   24.145303]  [<ffffffff8176024c>] ret_from_fork+0x7c/0xb0
[   24.145303]  [<ffffffff8173f08e>] ? rest_init+0xc2/0xc2
[   24.145303] Code: 8d 65 cc 4c 8d 6d d0 4c 8d 75 d4 79 21 48 ba 00 00 00 =
00 75 ba 0a a7 48 b9 00 00 00 00 00 00 00 40 bb 04 00 00 00 b8 0b 07 00 00 =
<0f> 01 c1 8b 35 c2 c4 b4 00 48 c7 c7 f5 93 b4 81 31 c0 e8 3b 21=20
[   24.145303] RIP  [<ffffffff81e37115>] visorchipset_init+0x7b/0x8c5
[   24.145303]  RSP <ffff88001157de58>
[   24.187247] ---[ end trace 62b5721899a66a6c ]---
[   24.188157] Kernel panic - not syncing: Fatal exception
[   24.189644] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[   24.190080] Rebooting in 10 seconds..
Elapsed time: 35
qemu-system-x86_64 -cpu Haswell,+smep,+smap -kernel /kernel/x86_64-randconf=
ig-br0-04050702/12e364b9f08aa335dc7716ce74113e834c993765/vmlinuz-3.14.0-rc5=
-00621-g12e364b -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 deb=
ug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-br0-04050702/next:master:1=
2e364b9f08aa335dc7716ce74113e834c993765:bisect-linux8/.vmlinuz-12e364b9f08a=
a335dc7716ce74113e834c993765-20140407181806-27-f4 branch=3Dnext/master BOOT=
_IMAGE=3D/kernel/x86_64-randconfig-br0-04050702/12e364b9f08aa335dc7716ce741=
13e834c993765/vmlinuz-3.14.0-rc5-00621-g12e364b drbd.minor_count=3D8'  -ini=
trd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vla=
n=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::50457-:22 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm=
/kboot/pid-quantal-f4-128 -serial file:/dev/shm/kboot/serial-quantal-f4-128=
 -daemonize -display none -monitor null=20

--lrZ03NoBR/3+SXJZ
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-br0-04050702-4b22efdd5595f0acb48f02bf664a451ee98f9a2e-RIP:----visorchipset_init+-x-59736.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNGIyMmVmZC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA0MDMKZ2l0IGNoZWNrb3V0IDc5YjFkMWY1ODYwNTQ1OTczNDYxZDBkY2Ix
ZjBlOGQ5YzMyZGJkYmUKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi9uZXh0Om1hc3Rlcjo3OWIxZDFmNTg2MDU0NTk3
MzQ2MWQwZGNiMWYwZThkOWMzMmRiZGJlOmJpc2VjdC1saW51eDgKCjIwMTQtMDQtMDctMTY6
Mjc6MTMgNzliMWQxZjU4NjA1NDU5NzM0NjFkMGRjYjFmMGU4ZDljMzJkYmRiZSBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItNzliMWQxZjU4NjA1NDU5NzM0NjFkMGRjYjFm
MGU4ZDljMzJkYmRiZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYnIwLTA0MDUwNzAyLzc5YjFkMWY1ODYwNTQ1OTczNDYxZDBkY2IxZjBlOGQ5YzMy
ZGJkYmUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi03OWIxZDFmNTg2MDU0NTk3MzQ2
MWQwZGNiMWYwZThkOWMzMmRiZGJlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLTc5
YjFkMWY1ODYwNTQ1OTczNDYxZDBkY2IxZjBlOGQ5YzMyZGJkYmUKG1sxOzM1bTIwMTQtMDQt
MDcgMTY6Mzc6MTMgS2VybmVsIGJ1aWxkIGZhaWwgb3IgdGltZW91dBtbMG0KMjAxNC0wNC0w
Ny0xNjozNzoxMyA3OWIxZDFmNTg2MDU0NTk3MzQ2MWQwZGNiMWYwZThkOWMzMmRiZGJlIFNL
SVAgQlJPS0VOIEJVSUxECkNoZWNrIC9rZXJuZWwtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82
NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi03OWIxZDFmNTg2MDU0NTk3MzQ2MWQwZGNiMWYw
ZThkOWMzMmRiZGJlCmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIDc5YjFkMWY1ODYw
NTQ1OTczNDYxZDBkY2IxZjBlOGQ5YzMyZGJkYmUKZ2l0IGNoZWNrb3V0IHYzLjE0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQw
NTA3MDIvbmV4dDptYXN0ZXI6NDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNk
ZTExYzpiaXNlY3QtbGludXg4CgoyMDE0LTA0LTA3LTE2OjM3OjE2IDQ1NWM2ZmRiZDIxOTE2
MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYnIwLTA0
MDUwNzAyLTQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi80
NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1icjAtMDQwNTA3MDItNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTEx
Ywp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
Lng4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi00NTVjNmZkYmQyMTkxNjFiZDA5YjEx
NjVmMTE2OTlkNmQ3M2RlMTFjCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1i
cjAtMDQwNTA3MDIvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy92
bWxpbnV6LTMuMTQuMAoKMjAxNC0wNC0wNy0xNjo0MjoxNiBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuCTEwCTMwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgdjMuMTQKZ2l0IGJpc2Vj
dCBzdGFydCA0YjIyZWZkZDU1OTVmMGFjYjQ4ZjAyYmY2NjRhNDUxZWU5OGY5YTJlIHYzLjE0
IC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgIjRiMjJlZmRkNTU5
NWYwYWNiNDhmMDJiZjY2NGE0NTFlZTk4ZjlhMmUiLCAiLWciLCAidjMuMTQiLCAiL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIva2VybmVsLXRlc3Rz
L2xpbnV4OC9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAxMjc4NSByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpCls4NTBiYTFkZjJjNmFhNzU0
YzliMmM4YzIzZWFjMzE2MTM3M2Q1NDkyXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICdzYW1zdW5nL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDgvb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYnIwLTA0
MDUwNzAyL25leHQ6bWFzdGVyOjg1MGJhMWRmMmM2YWE3NTRjOWIyYzhjMjNlYWMzMTYxMzcz
ZDU0OTI6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNC0wNy0xNjo0Mzo1MyA4NTBiYTFkZjJjNmFh
NzU0YzliMmM4YzIzZWFjMzE2MTM3M2Q1NDkyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0w
NDA1MDcwMi04NTBiYTFkZjJjNmFhNzU0YzliMmM4YzIzZWFjMzE2MTM3M2Q1NDkyCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIv
ODUwYmExZGYyYzZhYTc1NGM5YjJjOGMyM2VhYzMxNjEzNzNkNTQ5Mgp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctYnIwLTA0MDUwNzAyLTg1MGJhMWRmMmM2YWE3NTRjOWIyYzhjMjNlYWMzMTYxMzczZDU0
OTIKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi84NTBi
YTFkZjJjNmFhNzU0YzliMmM4YzIzZWFjMzE2MTM3M2Q1NDkyL3ZtbGludXotMy4xNC4wLTA2
NjUyLWc4NTBiYTFkCgoyMDE0LTA0LTA3LTE2OjQ2OjI4IGRldGVjdGluZyBib290IHN0YXRl
IC4gVEVTVCBGQUlMVVJFClsgICAyMy4wMDI2NTFdIEdQSU8gSU5JVCBGQUlMISEKWyAgIDIz
LjAwMzQ2Ml0gZHJpdmVyIHZlcnNpb24gMS4wLjAuMCBsb2FkZWQKWyAgIDIzLjAwMzkyOV0g
Y2hpcHNldCBkcml2ZXIgdmVyc2lvbiAxLjAuMC4wIGxvYWRlZApbICAgMjMuMDAzOTYxXSBp
bnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIFBSRUVNUFQgU01QIApbICAgMjMuMDA0MDU0XSBN
b2R1bGVzIGxpbmtlZCBpbjoKWyAgIDIzLjAwNDE5NV0gQ1BVOiAwIFBJRDogMSBDb21tOiBz
d2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLTA2NjUyLWc4NTBiYTFkICMxClsgICAyMy4w
MDQxOTVdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIw
MTEKWyAgIDIzLjAwNDE5NV0gdGFzazogZmZmZjg4MDAxMTU3MDAxMCB0aTogZmZmZjg4MDAx
MTU3MjAwMCB0YXNrLnRpOiBmZmZmODgwMDExNTcyMDAwClsgICAyMy4wMDQxOTVdIFJJUDog
MDAxMDpbPGZmZmZmZmZmODFlM2Y3YTc+XSAgWzxmZmZmZmZmZjgxZTNmN2E3Pl0gdmlzb3Jj
aGlwc2V0X2luaXQrMHg3Yi8weDg5MgpbICAgMjMuMDA0MTk1XSBSU1A6IDAwMDA6ZmZmZjg4
MDAxMTU3M2U1OCAgRUZMQUdTOiAwMDAwMDI4NgpbICAgMjMuMDA0MTk1XSBSQVg6IDAwMDAw
MDAwMDAwMDA3MGIgUkJYOiAwMDAwMDAwMDAwMDAwMDA0IFJDWDogNDAwMDAwMDAwMDAwMDAw
MApbICAgMjMuMDA0MTk1XSBSRFg6IGE3MGFiYTdlMDAwMDAwMDAgUlNJOiBmZmZmODgwMDEx
NTczZTVjIFJESTogZmZmZjg4MDAxMTU3M2U1OApbICAgMjMuMDA0MTk1XSBSQlA6IGZmZmY4
ODAwMTE1NzNlOTAgUjA4OiAwMDAwMDAwMDAwMDAwMDAxIFIwOTogZmZmZjg4MDAxMTU3M2U2
MApbICAgMjMuMDA0MTk1XSBSMTA6IGZmZmY4ODAwMTE1NzNlNjQgUjExOiAwMDAwMDAwMDAw
MDAwMDAwIFIxMjogZmZmZjg4MDAxMTU3M2U1YwpbICAgMjMuMDA0MTk1XSBSMTM6IGZmZmY4
ODAwMTE1NzNlNjAgUjE0OiBmZmZmODgwMDExNTczZTY0IFIxNTogMDAwMDAwMDAwMDAwMDAw
MApbICAgMjMuMDA0MTk1XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4
MDAxMjYwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAyMy4wMDQxOTVd
IENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAg
IDIzLjAwNDE5NV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAwMWMwYTAw
MCBDUjQ6IDAwMDAwMDAwMDAzMDA2ZjAKWyAgIDIzLjAwNDE5NV0gRFIwOiAwMDAwMDAwMDAw
MDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
IDIzLjAwNDE5NV0gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDAwMDAwMDAw
MCBEUjc6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDIzLjAwNDE5NV0gU3RhY2s6ClsgICAyMy4w
MDQxOTVdICAwMDAwMDgwMDAwMDMwNmMxIDA3OGJmYmY5ODJkODIyMDMgZmZmZmZmZmY4MWUz
ZjcyYyAwMDAwMDAwMDAwMDAwMDAwClsgICAyMy4wMDQxOTVdICAwMDAwMDAwMDAwMDAwMWU5
IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDExNTczZjA4Clsg
ICAyMy4wMDQxOTVdICBmZmZmZmZmZjgxMDAwMmIyIGZmZmZmZmZmODEwYjJiMDAgZmZmZjg4
MDAxMTU3M2YwOCBmZmZmZmZmZjgxMGIyZDM3ClsgICAyMy4wMDQxOTVdIENhbGwgVHJhY2U6
ClsgICAyMy4wMDQxOTVdICBbPGZmZmZmZmZmODFlM2Y3MmM+XSA/IHZpc29yY2hhbm5lbF9p
bml0KzB4MWQvMHgxZApbICAgMjMuMDA0MTk1XSAgWzxmZmZmZmZmZjgxMDAwMmIyPl0gZG9f
b25lX2luaXRjYWxsKzB4OGUvMHgxMzgKWyAgIDIzLjAwNDE5NV0gIFs8ZmZmZmZmZmY4MTBi
MmIwMD5dID8gcGFyYW1fYXJyYXlfc2V0KzB4OTMvMHhmNQpbICAgMjMuMDA0MTk1XSAgWzxm
ZmZmZmZmZjgxMGIyZDM3Pl0gPyBwYXJzZV9hcmdzKzB4MTgwLzB4MjQ4ClsgICAyMy4wMDQx
OTVdICBbPGZmZmZmZmZmODFlMDNmOTA+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEwOC8w
eDE5OQpbICAgMjMuMDA0MTk1XSAgWzxmZmZmZmZmZjgxZTAzNzQ0Pl0gPyBkb19lYXJseV9w
YXJhbSsweDhhLzB4OGEKWyAgIDIzLjAwNDE5NV0gIFs8ZmZmZmZmZmY4MTc0MzQ0Yj5dID8g
cmVzdF9pbml0KzB4YmYvMHhiZgpbICAgMjMuMDA0MTk1XSAgWzxmZmZmZmZmZjgxNzQzNDU0
Pl0ga2VybmVsX2luaXQrMHg5LzB4ZGEKWyAgIDIzLjAwNDE5NV0gIFs8ZmZmZmZmZmY4MTc2
NDdjYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAyMy4wMDQxOTVdICBbPGZmZmZm
ZmZmODE3NDM0NGI+XSA/IHJlc3RfaW5pdCsweGJmLzB4YmYKWyAgIDIzLjAwNDE5NV0gQ29k
ZTogOGQgNjUgY2MgNGMgOGQgNmQgZDAgNGMgOGQgNzUgZDQgNzkgMjEgNDggYmEgMDAgMDAg
MDAgMDAgN2UgYmEgMGEgYTcgNDggYjkgMDAgMDAgMDAgMDAgMDAgMDAgMDAgNDAgYmIgMDQg
MDAgMDAgMDAgYjggMGIgMDcgMDAgMDAgPDBmPiAwMSBjMSA4YiAzNSA5MCBjZiBiNCAwMCA0
OCBjNyBjNyA0ZSBlNyBiNCA4MSAzMSBjMCBlOCBlNCBkZSAKWyAgIDIzLjAwNDE5NV0gUklQ
ICBbPGZmZmZmZmZmODFlM2Y3YTc+XSB2aXNvcmNoaXBzZXRfaW5pdCsweDdiLzB4ODkyClsg
ICAyMy4wMDQxOTVdICBSU1AgPGZmZmY4ODAwMTE1NzNlNTg+ClsgICAyMy4wMDY2NzddIC0t
LVsgZW5kIHRyYWNlIDJhZTIyMzNhMDRmMTE3MDkgXS0tLQpbICAgMjMuMDA2ODMyXSBLZXJu
ZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLzg1MGJhMWRmMmM2YWE3NTRjOWIyYzhjMjNlYWMz
MTYxMzczZDU0OTIvZG1lc2ctcXVhbnRhbC1mMy04NzoyMDE0MDQwNzE2NDY1Mzp4ODZfNjQt
cmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLTA2NjUyLWc4NTBiYTFkOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvODUwYmExZGYyYzZhYTc1NGM5YjJj
OGMyM2VhYzMxNjEzNzNkNTQ5Mi9kbWVzZy15b2N0by1mMy05NjoyMDE0MDQwNzE2NDY0NTp4
ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLTA2NjUyLWc4NTBiYTFkOjEK
MDoyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogNjY1MiByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMgc3RlcHMpCls2MmZm
NTc3ZmEyZmVjODdlZGJmMjZmNTNlODcyMTBiYTcyNmQ0ZDQ0XSBNZXJnZSB0YWcgJ2VkYWNf
Zm9yXzMuMTUnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9icC9icApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDgvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL25l
eHQ6bWFzdGVyOjYyZmY1NzdmYTJmZWM4N2VkYmYyNmY1M2U4NzIxMGJhNzI2ZDRkNDQ6Ymlz
ZWN0LWxpbnV4OAoKMjAxNC0wNC0wNy0xNjo0NzowNiA2MmZmNTc3ZmEyZmVjODdlZGJmMjZm
NTNlODcyMTBiYTcyNmQ0ZDQ0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi02
MmZmNTc3ZmEyZmVjODdlZGJmMjZmNTNlODcyMTBiYTcyNmQ0ZDQ0CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvNjJmZjU3N2Zh
MmZlYzg3ZWRiZjI2ZjUzZTg3MjEwYmE3MjZkNGQ0NAp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYnIwLTA0
MDUwNzAyLTYyZmY1NzdmYTJmZWM4N2VkYmYyNmY1M2U4NzIxMGJhNzI2ZDRkNDQKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQt
cmFuZGNvbmZpZy1icjAtMDQwNTA3MDItNjJmZjU3N2ZhMmZlYzg3ZWRiZjI2ZjUzZTg3MjEw
YmE3MjZkNGQ0NAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUw
NzAyLzYyZmY1NzdmYTJmZWM4N2VkYmYyNmY1M2U4NzIxMGJhNzI2ZDRkNDQvdm1saW51ei0z
LjE0LjAtMDE1MTUtZzYyZmY1NzcKCjIwMTQtMDQtMDctMTY6NDk6MDYgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLgk0CTI1CTI4CTMwIFNVQ0NFU1MKCkJpc2VjdGluZzogNTEzNyByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMgc3RlcHMpCltlNmQ5YmZj
NjM4MTM4ODJjODk2YmY3ZWE2ZjZiMTRjYTdiNTBiNzU1XSBNZXJnZSBicmFuY2ggJ3Bvd2Vy
bnYtY3B1aWRsZScgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L2JlbmgvcG93ZXJwYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDgvb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYnIwLTA0
MDUwNzAyL25leHQ6bWFzdGVyOmU2ZDliZmM2MzgxMzg4MmM4OTZiZjdlYTZmNmIxNGNhN2I1
MGI3NTU6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNC0wNy0xNjo1MTo0MCBlNmQ5YmZjNjM4MTM4
ODJjODk2YmY3ZWE2ZjZiMTRjYTdiNTBiNzU1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0w
NDA1MDcwMi1lNmQ5YmZjNjM4MTM4ODJjODk2YmY3ZWE2ZjZiMTRjYTdiNTBiNzU1CkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIv
ZTZkOWJmYzYzODEzODgyYzg5NmJmN2VhNmY2YjE0Y2E3YjUwYjc1NQp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctYnIwLTA0MDUwNzAyLWU2ZDliZmM2MzgxMzg4MmM4OTZiZjdlYTZmNmIxNGNhN2I1MGI3
NTUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
Ly54ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItZTZkOWJmYzYzODEzODgyYzg5NmJm
N2VhNmY2YjE0Y2E3YjUwYjc1NQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YnIwLTA0MDUwNzAyL2U2ZDliZmM2MzgxMzg4MmM4OTZiZjdlYTZmNmIxNGNhN2I1MGI3NTUv
dm1saW51ei0zLjE0LjAtMDQ4NDgtZ2U2ZDliZmMKCjIwMTQtMDQtMDctMTY6NTM6NDAgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgIDIyLjY1MjcyNl0gRlBHQSBp
bWFnZSBmaWxlIG5hbWU6IHhsaW54X2ZwZ2FfZmlybXdhcmUuYml0ClsgICAyMi42NTUyMDJd
IEdQSU8gSU5JVCBGQUlMISEKWyAgIDIyLjY1NjM5NV0gZHJpdmVyIHZlcnNpb24gMS4wLjAu
MCBsb2FkZWQKWyAgIDIyLjY1NzU4MV0gY2hpcHNldCBkcml2ZXIgdmVyc2lvbiAxLjAuMC4w
IGxvYWRlZGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gUFJFRU1QVCBTTVAgClsgICAyMi42
NTk5MTZdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgMjIuNjYwNDIzXSBDUFU6IDAgUElEOiAx
IENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtMDQ4NDgtZ2U2ZDliZmMgIzEK
WyAgIDIyLjY2MDQyM10gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMg
MDEvMDEvMjAxMQpbICAgMjIuNjYwNDIzXSB0YXNrOiBmZmZmODgwMDExNTcwMDEwIHRpOiBm
ZmZmODgwMDExNTcyMDAwIHRhc2sudGk6IGZmZmY4ODAwMTE1NzIwMDAKWyAgIDIyLjY2MDQy
M10gUklQOiAwMDEwOls8ZmZmZmZmZmY4MWUzZjdjOD5dICBbPGZmZmZmZmZmODFlM2Y3Yzg+
XSB2aXNvcmNoaXBzZXRfaW5pdCsweDdiLzB4ODkyClsgICAyMi42NjA0MjNdIFJTUDogMDAw
MDpmZmZmODgwMDExNTczZTU4ICBFRkxBR1M6IDAwMDAwMjg2ClsgICAyMi42NjA0MjNdIFJB
WDogMDAwMDAwMDAwMDAwMDcwYiBSQlg6IDAwMDAwMDAwMDAwMDAwMDQgUkNYOiA0MDAwMDAw
MDAwMDAwMDAwClsgICAyMi42NjA0MjNdIFJEWDogYTcwYWJhN2UwMDAwMDAwMCBSU0k6IGZm
ZmY4ODAwMTE1NzNlNWMgUkRJOiBmZmZmODgwMDExNTczZTU4ClsgICAyMi42NjA0MjNdIFJC
UDogZmZmZjg4MDAxMTU3M2U5MCBSMDg6IDAwMDAwMDAwMDAwMDAwMDEgUjA5OiBmZmZmODgw
MDExNTczZTYwClsgICAyMi42NjA0MjNdIFIxMDogZmZmZjg4MDAxMTU3M2U2NCBSMTE6IDAw
MDAwMDAwMDAwMDAwMDAgUjEyOiBmZmZmODgwMDExNTczZTVjClsgICAyMi42NjA0MjNdIFIx
MzogZmZmZjg4MDAxMTU3M2U2MCBSMTQ6IGZmZmY4ODAwMTE1NzNlNjQgUjE1OiAwMDAwMDAw
MDAwMDAwMDAwClsgICAyMi42NjA0MjNdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBH
UzpmZmZmODgwMDEyNjAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgIDIy
LjY2MDQyM10gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1
MDAzYgpbICAgMjIuNjYwNDIzXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAw
MDAxYzBhMDAwIENSNDogMDAwMDAwMDAwMDMwMDZmMApbICAgMjIuNjYwNDIzXSBEUjA6IDAw
MDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAw
MDAwMApbICAgMjIuNjYwNDIzXSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAw
MDAwMDAwMDAwIERSNzogMDAwMDAwMDAwMDAwMDAwMApbICAgMjIuNjYwNDIzXSBTdGFjazoK
WyAgIDIyLjY2MDQyM10gIDAwMDAwODAwMDAwMzA2YzEgMDc4YmZiZjk4MmQ4MjIwMyBmZmZm
ZmZmZjgxZTNmNzRkIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDIyLjY2MDQyM10gIDAwMDAwMDAw
MDAwMDAxZTkgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMTE1
NzNmMDgKWyAgIDIyLjY2MDQyM10gIGZmZmZmZmZmODEwMDAyYjIgZmZmZmZmZmY4MTBiMmIw
MCBmZmZmODgwMDExNTczZjA4IGZmZmZmZmZmODEwYjJkMjcKWyAgIDIyLjY2MDQyM10gQ2Fs
bCBUcmFjZToKWyAgIDIyLjY2MDQyM10gIFs8ZmZmZmZmZmY4MWUzZjc0ZD5dID8gdmlzb3Jj
aGFubmVsX2luaXQrMHgxZC8weDFkClsgICAyMi42NjA0MjNdICBbPGZmZmZmZmZmODEwMDAy
YjI+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZS8weDEzOApbICAgMjIuNjYwNDIzXSAgWzxmZmZm
ZmZmZjgxMGIyYjAwPl0gPyBwYXJhbV9hcnJheV9zZXQrMHhhMy8weGY1ClsgICAyMi42NjA0
MjNdICBbPGZmZmZmZmZmODEwYjJkMjc+XSA/IHBhcnNlX2FyZ3MrMHgxODAvMHgyNDgKWyAg
IDIyLjY2MDQyM10gIFs8ZmZmZmZmZmY4MWUwM2Y5MD5dIGtlcm5lbF9pbml0X2ZyZWVhYmxl
KzB4MTA4LzB4MTk5ClsgICAyMi42NjA0MjNdICBbPGZmZmZmZmZmODFlMDM3NDQ+XSA/IGRv
X2Vhcmx5X3BhcmFtKzB4OGEvMHg4YQpbICAgMjIuNjYwNDIzXSAgWzxmZmZmZmZmZjgxNzQz
MmZiPl0gPyByZXN0X2luaXQrMHhiZi8weGJmClsgICAyMi42NjA0MjNdICBbPGZmZmZmZmZm
ODE3NDMzMDQ+XSBrZXJuZWxfaW5pdCsweDkvMHhkYQpbICAgMjIuNjYwNDIzXSAgWzxmZmZm
ZmZmZjgxNzY0NjRjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgIDIyLjY2MDQyM10g
IFs8ZmZmZmZmZmY4MTc0MzJmYj5dID8gcmVzdF9pbml0KzB4YmYvMHhiZgpbICAgMjIuNjYw
NDIzXSBDb2RlOiA4ZCA2NSBjYyA0YyA4ZCA2ZCBkMCA0YyA4ZCA3NSBkNCA3OSAyMSA0OCBi
YSAwMCAwMCAwMCAwMCA3ZSBiYSAwYSBhNyA0OCBiOSAwMCAwMCAwMCAwMCAwMCAwMCAwMCA0
MCBiYiAwNCAwMCAwMCAwMCBiOCAwYiAwNyAwMCAwMCA8MGY+IDAxIGMxIDhiIDM1IDZmIGNm
IGI0IDAwIDQ4IGM3IGM3IDJhIGU0IGI0IDgxIDMxIGMwIGU4IDY2IGRkIApbICAgMjIuNjYw
NDIzXSBSSVAgIFs8ZmZmZmZmZmY4MWUzZjdjOD5dIHZpc29yY2hpcHNldF9pbml0KzB4N2Iv
MHg4OTIKWyAgIDIyLjY2MDQyM10gIFJTUCA8ZmZmZjg4MDAxMTU3M2U1OD4KWyAgIDIyLjcw
MjI5MF0gLS0tWyBlbmQgdHJhY2UgNzU3ZmJjODE0N2IxNDVjOSBdLS0tClsgICAyMi43MDMz
NTVdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvZTZkOWJmYzYzODEzODgyYzg5NmJm
N2VhNmY2YjE0Y2E3YjUwYjc1NS9kbWVzZy15b2N0by1mNC0xNToyMDE0MDQwNzE2NTMzODp4
ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLTA0ODQ4LWdlNmQ5YmZjOjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvZTZkOWJmYzYzODEzODgy
Yzg5NmJmN2VhNmY2YjE0Y2E3YjUwYjc1NS9kbWVzZy15b2N0by1mNC0zMzoyMDE0MDQwNzE2
NTM0Mzp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLTA0ODQ4LWdlNmQ5
YmZjOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvZTZkOWJmYzYz
ODEzODgyYzg5NmJmN2VhNmY2YjE0Y2E3YjUwYjc1NS9kbWVzZy1xdWFudGFsLWYzLTEyMzoy
MDE0MDQwNzE2NTM1MDp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLTA0
ODQ4LWdlNmQ5YmZjOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIv
ZTZkOWJmYzYzODEzODgyYzg5NmJmN2VhNmY2YjE0Y2E3YjUwYjc1NS9kbWVzZy15b2N0by1m
My0xMDg6MjAxNDA0MDcxNjUzNDc6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyOjMu
MTQuMC0wNDg0OC1nZTZkOWJmYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0
MDUwNzAyL2U2ZDliZmM2MzgxMzg4MmM4OTZiZjdlYTZmNmIxNGNhN2I1MGI3NTUvZG1lc2ct
eW9jdG8tZjMtMjk6MjAxNDA0MDcxNjUzNTE6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUw
NzAyOjMuMTQuMC0wNDg0OC1nZTZkOWJmYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YnIwLTA0MDUwNzAyL2U2ZDliZmM2MzgxMzg4MmM4OTZiZjdlYTZmNmIxNGNhN2I1MGI3NTUv
ZG1lc2cteW9jdG8tZjQtMTI0OjIwMTQwNDA3MTY1MzQ3Ong4Nl82NC1yYW5kY29uZmlnLWJy
MC0wNDA1MDcwMjozLjE0LjAtMDQ4NDgtZ2U2ZDliZmM6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWJyMC0wNDA1MDcwMi9lNmQ5YmZjNjM4MTM4ODJjODk2YmY3ZWE2ZjZiMTRjYTdi
NTBiNzU1L2RtZXNnLXlvY3RvLWY0LTg0OjIwMTQwNDA3MTY1MzQ1Ong4Nl82NC1yYW5kY29u
ZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAtMDQ4NDgtZ2U2ZDliZmM6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi9lNmQ5YmZjNjM4MTM4ODJjODk2YmY3ZWE2ZjZi
MTRjYTdiNTBiNzU1L2RtZXNnLXlvY3RvLWY0LTk0OjIwMTQwNDA3MTY1MzQ4Ong4Nl82NC1y
YW5kY29uZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAtMDQ4NDgtZ2U2ZDliZmM6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi9lNmQ5YmZjNjM4MTM4ODJjODk2YmY3
ZWE2ZjZiMTRjYTdiNTBiNzU1L2RtZXNnLXlvY3RvLWY0LTk4OjIwMTQwNDA3MTY1MzUyOng4
Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAtMDQ4NDgtZ2U2ZDliZmM6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi9lNmQ5YmZjNjM4MTM4ODJj
ODk2YmY3ZWE2ZjZiMTRjYTdiNTBiNzU1L2RtZXNnLXlvY3RvLWY0LTk6MjAxNDA0MDcxNjUz
NDc6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyOjMuMTQuMC0wNDg0OC1nZTZkOWJm
YzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL2U2ZDliZmM2Mzgx
Mzg4MmM4OTZiZjdlYTZmNmIxNGNhN2I1MGI3NTUvZG1lc2ctcXVhbnRhbC1mMy02OToyMDE0
MDQwNzE2NTM1Nzp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLTA0ODQ4
LWdlNmQ5YmZjOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvZTZk
OWJmYzYzODEzODgyYzg5NmJmN2VhNmY2YjE0Y2E3YjUwYjc1NS9kbWVzZy1xdWFudGFsLWY0
LTEyMzoyMDE0MDQwNzE2NTQwMTp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4x
NC4wLTA0ODQ4LWdlNmQ5YmZjOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQw
NTA3MDIvZTZkOWJmYzYzODEzODgyYzg5NmJmN2VhNmY2YjE0Y2E3YjUwYjc1NS9kbWVzZy1x
dWFudGFsLWY0LTIwOjIwMTQwNDA3MTY1MzU3Ong4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1
MDcwMjozLjE0LjAtMDQ4NDgtZ2U2ZDliZmM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWJyMC0wNDA1MDcwMi9lNmQ5YmZjNjM4MTM4ODJjODk2YmY3ZWE2ZjZiMTRjYTdiNTBiNzU1
L2RtZXNnLXF1YW50YWwtZjQtMzY6MjAxNDA0MDcxNjUzNTc6eDg2XzY0LXJhbmRjb25maWct
YnIwLTA0MDUwNzAyOjMuMTQuMC0wNDg0OC1nZTZkOWJmYzoxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYnIwLTA0MDUwNzAyL2U2ZDliZmM2MzgxMzg4MmM4OTZiZjdlYTZmNmIxNGNh
N2I1MGI3NTUvZG1lc2cteW9jdG8tZjQtODM6MjAxNDA0MDcxNjUzNTg6eDg2XzY0LXJhbmRj
b25maWctYnIwLTA0MDUwNzAyOjMuMTQuMC0wNDg0OC1nZTZkOWJmYzoxCjA6MTU6MTUgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMzMzMyByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCltiMzNjZTQ0Mjk5Mzg2
NTE4MDI5MmRmMmEzMTRlZTUyNTFiYTM4YjUwXSBNZXJnZSBicmFuY2ggJ2Zvci0zLjE1L2Ry
aXZlcnMnIG9mIGdpdDovL2dpdC5rZXJuZWwuZGsvbGludXgtYmxvY2sKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMv
bGludXg4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi9uZXh0Om1hc3RlcjpiMzNjZTQ0Mjk5Mzg2
NTE4MDI5MmRmMmEzMTRlZTUyNTFiYTM4YjUwOmJpc2VjdC1saW51eDgKCjIwMTQtMDQtMDct
MTY6NTQ6MTQgYjMzY2U0NDI5OTM4NjUxODAyOTJkZjJhMzE0ZWU1MjUxYmEzOGI1MCBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItYjMzY2U0NDI5OTM4NjUxODAyOTJkZjJh
MzE0ZWU1MjUxYmEzOGI1MApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYnIwLTA0MDUwNzAyL2IzM2NlNDQyOTkzODY1MTgwMjkyZGYyYTMxNGVlNTI1
MWJhMzhiNTAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi1iMzNjZTQ0Mjk5Mzg2NTE4
MDI5MmRmMmEzMTRlZTUyNTFiYTM4YjUwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAy
LWIzM2NlNDQyOTkzODY1MTgwMjkyZGYyYTMxNGVlNTI1MWJhMzhiNTAKa2VybmVsOiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi9iMzNjZTQ0Mjk5Mzg2NTE4MDI5
MmRmMmEzMTRlZTUyNTFiYTM4YjUwL3ZtbGludXotMy4xNC4wLTA0NTU1LWdiMzNjZTQ0Cgoy
MDE0LTA0LTA3LTE2OjU2OjE0IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJF
ClsgICAxNS4wOTI1MzldIEZQR0EgaW1hZ2UgZmlsZSBuYW1lOiB4bGlueF9mcGdhX2Zpcm13
YXJlLmJpdApbICAgMTUuMDk1ODM2XSBHUElPIElOSVQgRkFJTCEhClsgICAxNS4wOTcxODRd
IGRyaXZlciB2ZXJzaW9uIDEuMC4wLjAgbG9hZGVkClsgICAxNS4wOTgwMjJdIGNoaXBzZXQg
ZHJpdmVyIHZlcnNpb24gMS4wLjAuMCBsb2FkZWRpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFd
IFBSRUVNUFQgU01QIApbICAgMTUuMTAwNDQwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDE1
LjEwMTI2MF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4x
NC4wLTA0NTU1LWdiMzNjZTQ0ICMxClsgICAxNS4xMDEyNjBdIEhhcmR3YXJlIG5hbWU6IEJv
Y2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDE1LjEwMTI2MF0gdGFzazog
ZmZmZjg4MDAxMjk3MDAxMCB0aTogZmZmZjg4MDAxMjk3MjAwMCB0YXNrLnRpOiBmZmZmODgw
MDEyOTcyMDAwClsgICAxNS4xMDEyNjBdIFJJUDogMDAxMDpbPGZmZmZmZmZmODFlM2M4ZTE+
XSAgWzxmZmZmZmZmZjgxZTNjOGUxPl0gdmlzb3JjaGlwc2V0X2luaXQrMHg3Yi8weDg5Mgpb
ICAgMTUuMTAxMjYwXSBSU1A6IDAwMDA6ZmZmZjg4MDAxMjk3M2U1OCAgRUZMQUdTOiAwMDAw
MDI4NgpbICAgMTUuMTAxMjYwXSBSQVg6IDAwMDAwMDAwMDAwMDA3MGIgUkJYOiAwMDAwMDAw
MDAwMDAwMDA0IFJDWDogNDAwMDAwMDAwMDAwMDAwMApbICAgMTUuMTAxMjYwXSBSRFg6IGE3
MGFiYTdlMDAwMDAwMDAgUlNJOiBmZmZmODgwMDEyOTczZTVjIFJESTogZmZmZjg4MDAxMjk3
M2U1OApbICAgMTUuMTAxMjYwXSBSQlA6IGZmZmY4ODAwMTI5NzNlOTAgUjA4OiAwMDAwMDAw
MDAwMDAwMDAxIFIwOTogZmZmZjg4MDAxMjk3M2U2MApbICAgMTUuMTAxMjYwXSBSMTA6IGZm
ZmY4ODAwMTI5NzNlNjQgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogZmZmZjg4MDAxMjk3
M2U1YwpbICAgMTUuMTAxMjYwXSBSMTM6IGZmZmY4ODAwMTI5NzNlNjAgUjE0OiBmZmZmODgw
MDEyOTczZTY0IFIxNTogMDAwMDAwMDAwMDAwMDAwMApbICAgMTUuMTAxMjYwXSBGUzogIDAw
MDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4MDAxM2EwMDAwMCgwMDAwKSBrbmxHUzow
MDAwMDAwMDAwMDAwMDAwClsgICAxNS4xMDEyNjBdIENTOiAgMDAxMCBEUzogMDAwMCBFUzog
MDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgIDE1LjEwMTI2MF0gQ1IyOiAwMDAwMDAw
MDAwMDAwMDAwIENSMzogMDAwMDAwMDAwMWMwNzAwMCBDUjQ6IDAwMDAwMDAwMDAzMDA2ZjAK
WyAgIDE1LjEwMTI2MF0gRFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAw
MDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDE1LjEwMTI2MF0gRFIzOiAwMDAwMDAw
MDAwMDAwMDAwIERSNjogMDAwMDAwMDAwMDAwMDAwMCBEUjc6IDAwMDAwMDAwMDAwMDAwMDAK
WyAgIDE1LjEwMTI2MF0gU3RhY2s6ClsgICAxNS4xMDEyNjBdICAwMDAwMDgwMDAwMDMwNmMx
IDA3OGJmYmY5ODJkODIyMDMgZmZmZmZmZmY4MWUzYzg2NiAwMDAwMDAwMDAwMDAwMDAwClsg
ICAxNS4xMDEyNjBdICAwMDAwMDAwMDAwMDAwMWU5IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAw
MDAwMDAwMDAwMCBmZmZmODgwMDEyOTczZjA4ClsgICAxNS4xMDEyNjBdICBmZmZmZmZmZjgx
MDAwMmIyIGZmZmZmZmZmODEwYjJiMDAgZmZmZjg4MDAxMjk3M2YwOCBmZmZmZmZmZjgxMGIy
Y2I0ClsgICAxNS4xMDEyNjBdIENhbGwgVHJhY2U6ClsgICAxNS4xMDEyNjBdICBbPGZmZmZm
ZmZmODFlM2M4NjY+XSA/IHZpc29yY2hhbm5lbF9pbml0KzB4MWQvMHgxZApbICAgMTUuMTAx
MjYwXSAgWzxmZmZmZmZmZjgxMDAwMmIyPl0gZG9fb25lX2luaXRjYWxsKzB4OGUvMHgxMzgK
WyAgIDE1LjEwMTI2MF0gIFs8ZmZmZmZmZmY4MTBiMmIwMD5dID8gcGFyYW1lcW4rMHgyMS8w
eDM2ClsgICAxNS4xMDEyNjBdICBbPGZmZmZmZmZmODEwYjJjYjQ+XSA/IHBhcnNlX2FyZ3Mr
MHgxODAvMHgyNDgKWyAgIDE1LjEwMTI2MF0gIFs8ZmZmZmZmZmY4MWUwMGY5MD5dIGtlcm5l
bF9pbml0X2ZyZWVhYmxlKzB4MTA4LzB4MTk5ClsgICAxNS4xMDEyNjBdICBbPGZmZmZmZmZm
ODFlMDA3NDQ+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4OGEvMHg4YQpbICAgMTUuMTAxMjYwXSAg
WzxmZmZmZmZmZjgxNzQzMmRiPl0gPyByZXN0X2luaXQrMHhiZi8weGJmClsgICAxNS4xMDEy
NjBdICBbPGZmZmZmZmZmODE3NDMyZTQ+XSBrZXJuZWxfaW5pdCsweDkvMHhkYQpbICAgMTUu
MTAxMjYwXSAgWzxmZmZmZmZmZjgxNzY0NjRjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAK
WyAgIDE1LjEwMTI2MF0gIFs8ZmZmZmZmZmY4MTc0MzJkYj5dID8gcmVzdF9pbml0KzB4YmYv
MHhiZgpbICAgMTUuMTAxMjYwXSBDb2RlOiA4ZCA2NSBjYyA0YyA4ZCA2ZCBkMCA0YyA4ZCA3
NSBkNCA3OSAyMSA0OCBiYSAwMCAwMCAwMCAwMCA3ZSBiYSAwYSBhNyA0OCBiOSAwMCAwMCAw
MCAwMCAwMCAwMCAwMCA0MCBiYiAwNCAwMCAwMCAwMCBiOCAwYiAwNyAwMCAwMCA8MGY+IDAx
IGMxIDhiIDM1IDE2IGRlIGI0IDAwIDQ4IGM3IGM3IDRhIGU0IGI0IDgxIDMxIGMwIGU4IDJk
IDBjIApbICAgMTUuMTAxMjYwXSBSSVAgIFs8ZmZmZmZmZmY4MWUzYzhlMT5dIHZpc29yY2hp
cHNldF9pbml0KzB4N2IvMHg4OTIKWyAgIDE1LjEwMTI2MF0gIFJTUCA8ZmZmZjg4MDAxMjk3
M2U1OD4KWyAgIDE1LjE0NTkxN10gLS0tWyBlbmQgdHJhY2UgNDdkYTI2M2RkNjg5MmFmZSBd
LS0tClsgICAxNS4xNDY4NjhdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBl
eGNlcHRpb24KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvYjMzY2U0
NDI5OTM4NjUxODAyOTJkZjJhMzE0ZWU1MjUxYmEzOGI1MC9kbWVzZy15b2N0by1mMy01NDoy
MDE0MDQwNzE2NTYzMjp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLTA0
NTU1LWdiMzNjZTQ0OjEKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2Vj
dGluZzogMzA0MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MTIgc3RlcHMpCltjMTJlNjljNmFhZjc4NWZkMzA3ZDA1Y2I2ZjM2Y2EwZTc1NzdlYWQ3XSBN
ZXJnZSB0YWcgJ3N0YWdpbmctMy4xNS1yYzEnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9ncmVna2gvc3RhZ2luZwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51
eDgvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL25leHQ6bWFzdGVyOmMxMmU2OWM2YWFmNzg1ZmQz
MDdkMDVjYjZmMzZjYTBlNzU3N2VhZDc6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNC0wNy0xNjo1
Njo0NyBjMTJlNjljNmFhZjc4NWZkMzA3ZDA1Y2I2ZjM2Y2EwZTc1NzdlYWQ3IGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi1jMTJlNjljNmFhZjc4NWZkMzA3ZDA1Y2I2ZjM2
Y2EwZTc1NzdlYWQ3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1icjAtMDQwNTA3MDIvYzEyZTY5YzZhYWY3ODVmZDMwN2QwNWNiNmYzNmNhMGU3NTc3
ZWFkNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLWMxMmU2OWM2YWFmNzg1ZmQzMDdk
MDVjYjZmMzZjYTBlNzU3N2VhZDcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItYzEy
ZTY5YzZhYWY3ODVmZDMwN2QwNWNiNmYzNmNhMGU3NTc3ZWFkNwprZXJuZWw6IC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL2MxMmU2OWM2YWFmNzg1ZmQzMDdkMDVj
YjZmMzZjYTBlNzU3N2VhZDcvdm1saW51ei0zLjE0LjAtMDM4OTMtZ2MxMmU2OWMKCjIwMTQt
MDQtMDctMTY6NTg6NDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxIFRFU1QgRkFJTFVSRQpb
ICAgMjguMjcxMzU1XSBGUEdBIGltYWdlIGZpbGUgbmFtZTogeGxpbnhfZnBnYV9maXJtd2Fy
ZS5iaXQKWyAgIDI4LjI3NDA1Nl0gR1BJTyBJTklUIEZBSUwhIQpbICAgMjguMjc2MTk0XSBk
cml2ZXIgdmVyc2lvbiAxLjAuMC4wIGxvYWRlZApbICAgMjguMjc2OTQ1XSBjaGlwc2V0IGRy
aXZlciB2ZXJzaW9uIDEuMC4wLjAgbG9hZGVkaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBQ
UkVFTVBUIFNNUCAKWyAgIDI4LjI3OTYxMV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAyOC4y
ODA0NDRdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTQu
MC0wMzg5My1nYzEyZTY5YyAjMQpbICAgMjguMjgxMjkyXSBIYXJkd2FyZSBuYW1lOiBCb2No
cyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAyOC4yODEyOTJdIHRhc2s6IGZm
ZmY4ODAwMTE1NzAwMTAgdGk6IGZmZmY4ODAwMTE1NzIwMDAgdGFzay50aTogZmZmZjg4MDAx
MTU3MjAwMApbICAgMjguMjgxMjkyXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxZTNjOGNkPl0g
IFs8ZmZmZmZmZmY4MWUzYzhjZD5dIHZpc29yY2hpcHNldF9pbml0KzB4N2IvMHg4OTIKWyAg
IDI4LjI4MTI5Ml0gUlNQOiAwMDAwOmZmZmY4ODAwMTE1NzNlNTggIEVGTEFHUzogMDAwMDAy
ODYKWyAgIDI4LjI4MTI5Ml0gUkFYOiAwMDAwMDAwMDAwMDAwNzBiIFJCWDogMDAwMDAwMDAw
MDAwMDAwNCBSQ1g6IDQwMDAwMDAwMDAwMDAwMDAKWyAgIDI4LjI4MTI5Ml0gUkRYOiBhNzBh
YmE3ZTAwMDAwMDAwIFJTSTogZmZmZjg4MDAxMTU3M2U1YyBSREk6IGZmZmY4ODAwMTE1NzNl
NTgKWyAgIDI4LjI4MTI5Ml0gUkJQOiBmZmZmODgwMDExNTczZTkwIFIwODogMDAwMDAwMDAw
MDAwMDAwMSBSMDk6IGZmZmY4ODAwMTE1NzNlNjAKWyAgIDI4LjI4MTI5Ml0gUjEwOiBmZmZm
ODgwMDExNTczZTY0IFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IGZmZmY4ODAwMTE1NzNl
NWMKWyAgIDI4LjI4MTI5Ml0gUjEzOiBmZmZmODgwMDExNTczZTYwIFIxNDogZmZmZjg4MDAx
MTU3M2U2NCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDI4LjI4MTI5Ml0gRlM6ICAwMDAw
MDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMTI2MDAwMDAoMDAwMCkga25sR1M6MDAw
MDAwMDAwMDAwMDAwMApbICAgMjguMjgxMjkyXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAw
MDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAyOC4yODEyOTJdIENSMjogMDAwMDAwMDAw
MDAwMDAwMCBDUjM6IDAwMDAwMDAwMDFjMDcwMDAgQ1I0OiAwMDAwMDAwMDAwMzAwNmYwClsg
ICAyOC4yODEyOTJdIERSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAw
MDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAyOC4yODEyOTJdIERSMzogMDAwMDAwMDAw
MDAwMDAwMCBEUjY6IDAwMDAwMDAwMDAwMDAwMDAgRFI3OiAwMDAwMDAwMDAwMDAwMDAwClsg
ICAyOC4yODEyOTJdIFN0YWNrOgpbICAgMjguMjgxMjkyXSAgMDAwMDA4MDAwMDAzMDZjMSAw
NzhiZmJmOTgyZDgyMjAzIGZmZmZmZmZmODFlM2M4NTIgMDAwMDAwMDAwMDAwMDAwMApbICAg
MjguMjgxMjkyXSAgMDAwMDAwMDAwMDAwMDFlOSAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAw
MDAwMDAwMDAgZmZmZjg4MDAxMTU3M2YwOApbICAgMjguMjgxMjkyXSAgZmZmZmZmZmY4MTAw
MDJiMiBmZmZmZmZmZjgxMGIyYjAwIGZmZmY4ODAwMTE1NzNmMDggZmZmZmZmZmY4MTBiMmNi
NApbICAgMjguMjgxMjkyXSBDYWxsIFRyYWNlOgpbICAgMjguMjgxMjkyXSAgWzxmZmZmZmZm
ZjgxZTNjODUyPl0gPyB2aXNvcmNoYW5uZWxfaW5pdCsweDFkLzB4MWQKWyAgIDI4LjI4MTI5
Ml0gIFs8ZmZmZmZmZmY4MTAwMDJiMj5dIGRvX29uZV9pbml0Y2FsbCsweDhlLzB4MTM4Clsg
ICAyOC4yODEyOTJdICBbPGZmZmZmZmZmODEwYjJiMDA+XSA/IHBhcmFtZXFuKzB4MjEvMHgz
NgpbICAgMjguMjgxMjkyXSAgWzxmZmZmZmZmZjgxMGIyY2I0Pl0gPyBwYXJzZV9hcmdzKzB4
MTgwLzB4MjQ4ClsgICAyOC4yODEyOTJdICBbPGZmZmZmZmZmODFlMDBmOTA+XSBrZXJuZWxf
aW5pdF9mcmVlYWJsZSsweDEwOC8weDE5OQpbICAgMjguMjgxMjkyXSAgWzxmZmZmZmZmZjgx
ZTAwNzQ0Pl0gPyBkb19lYXJseV9wYXJhbSsweDhhLzB4OGEKWyAgIDI4LjI4MTI5Ml0gIFs8
ZmZmZmZmZmY4MTc0MjlmYj5dID8gcmVzdF9pbml0KzB4YmYvMHhiZgpbICAgMjguMjgxMjky
XSAgWzxmZmZmZmZmZjgxNzQyYTA0Pl0ga2VybmVsX2luaXQrMHg5LzB4ZGEKWyAgIDI4LjI4
MTI5Ml0gIFs8ZmZmZmZmZmY4MTc2M2I0Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsg
ICAyOC4yODEyOTJdICBbPGZmZmZmZmZmODE3NDI5ZmI+XSA/IHJlc3RfaW5pdCsweGJmLzB4
YmYKWyAgIDI4LjI4MTI5Ml0gQ29kZTogOGQgNjUgY2MgNGMgOGQgNmQgZDAgNGMgOGQgNzUg
ZDQgNzkgMjEgNDggYmEgMDAgMDAgMDAgMDAgN2UgYmEgMGEgYTcgNDggYjkgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgNDAgYmIgMDQgMDAgMDAgMDAgYjggMGIgMDcgMDAgMDAgPDBmPiAwMSBj
MSA4YiAzNSAyYSBkZSBiNCAwMCA0OCBjNyBjNyA3OSBkZiBiNCA4MSAzMSBjMCBlOCA2MSAw
MyAKWyAgIDI4LjI4MTI5Ml0gUklQICBbPGZmZmZmZmZmODFlM2M4Y2Q+XSB2aXNvcmNoaXBz
ZXRfaW5pdCsweDdiLzB4ODkyClsgICAyOC4yODEyOTJdICBSU1AgPGZmZmY4ODAwMTE1NzNl
NTg+ClsgICAyOC4zMjQ5MjBdIC0tLVsgZW5kIHRyYWNlIDY0Y2IwNjgyZTZjYjY2YzggXS0t
LQpbICAgMjguMzI1OTAzXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhj
ZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL2MxMmU2OWM2
YWFmNzg1ZmQzMDdkMDVjYjZmMzZjYTBlNzU3N2VhZDcvZG1lc2ctcXVhbnRhbC1mMy0zNDoy
MDE0MDQwNzE2NTkxNzp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLTAz
ODkzLWdjMTJlNjljOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIv
YzEyZTY5YzZhYWY3ODVmZDMwN2QwNWNiNmYzNmNhMGU3NTc3ZWFkNy9kbWVzZy15b2N0by1m
My05NzoyMDE0MDQwNzE2NTkxMjp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4x
NC4wLTAzODkzLWdjMTJlNjljOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQw
NTA3MDIvYzEyZTY5YzZhYWY3ODVmZDMwN2QwNWNiNmYzNmNhMGU3NTc3ZWFkNy9kbWVzZy15
b2N0by1mMy01NDoyMDE0MDQwNzE2NTkyMDp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3
MDI6My4xNC4wLTAzODkzLWdjMTJlNjljOjEKMTozOjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKCkJpc2VjdGluZzogMjM3OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTIgc3RlcHMpCltjNzA5MjkxNDdhMTBmYTQ1Mzg4ODZjYjIzYjkzNGI1
MDljNGMwZTQ5XSBNZXJnZSB0YWcgJ3NvdW5kLTMuMTUtcmMxJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGl3YWkvc291bmQKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVz
dHMvbGludXg4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi9uZXh0Om1hc3RlcjpjNzA5MjkxNDdh
MTBmYTQ1Mzg4ODZjYjIzYjkzNGI1MDljNGMwZTQ5OmJpc2VjdC1saW51eDgKCjIwMTQtMDQt
MDctMTY6NTk6NTEgYzcwOTI5MTQ3YTEwZmE0NTM4ODg2Y2IyM2I5MzRiNTA5YzRjMGU0OSBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItYzcwOTI5MTQ3YTEwZmE0NTM4ODg2
Y2IyM2I5MzRiNTA5YzRjMGU0OQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL2M3MDkyOTE0N2ExMGZhNDUzODg4NmNiMjNiOTM0
YjUwOWM0YzBlNDkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi1jNzA5MjkxNDdhMTBm
YTQ1Mzg4ODZjYjIzYjkzNGI1MDljNGMwZTQ5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUw
NzAyLWM3MDkyOTE0N2ExMGZhNDUzODg4NmNiMjNiOTM0YjUwOWM0YzBlNDkKa2VybmVsOiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi9jNzA5MjkxNDdhMTBmYTQ1
Mzg4ODZjYjIzYjkzNGI1MDljNGMwZTQ5L3ZtbGludXotMy4xNC4wLTAyMzM1LWdjNzA5Mjkx
CgoyMDE0LTA0LTA3LTE3OjAxOjUxIGRldGVjdGluZyBib290IHN0YXRlIC4JMTIJMjEJMjgJ
MzAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNTU4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzY3NWMzNTRhOTVkNTM3NTE1M2I4YmI4MGEw
NDQ4Y2FiOTE2Yzc5OTFdIE1lcmdlIHRhZyAnY2hhci1taXNjLTMuMTUtcmMxJyBvZiBnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ3JlZ2toL2NoYXIt
bWlzYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2tlcm5lbC10ZXN0cy9saW51eDgvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL25leHQ6bWFz
dGVyOjY3NWMzNTRhOTVkNTM3NTE1M2I4YmI4MGEwNDQ4Y2FiOTE2Yzc5OTE6YmlzZWN0LWxp
bnV4OAoKMjAxNC0wNC0wNy0xNzowNDoyMiA2NzVjMzU0YTk1ZDUzNzUxNTNiOGJiODBhMDQ0
OGNhYjkxNmM3OTkxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi02NzVjMzU0
YTk1ZDUzNzUxNTNiOGJiODBhMDQ0OGNhYjkxNmM3OTkxCkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvNjc1YzM1NGE5NWQ1Mzc1
MTUzYjhiYjgwYTA0NDhjYWI5MTZjNzk5MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAy
LTY3NWMzNTRhOTVkNTM3NTE1M2I4YmI4MGEwNDQ4Y2FiOTE2Yzc5OTEKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNv
bmZpZy1icjAtMDQwNTA3MDItNjc1YzM1NGE5NWQ1Mzc1MTUzYjhiYjgwYTA0NDhjYWI5MTZj
Nzk5MQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLzY3
NWMzNTRhOTVkNTM3NTE1M2I4YmI4MGEwNDQ4Y2FiOTE2Yzc5OTEvdm1saW51ei0zLjE0LjAt
MDI0NTktZzY3NWMzNTQKCjIwMTQtMDQtMDctMTc6MDY6MjIgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLgk3CTIxCTMwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTQzNCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpClsxNThlMGQzNjIxNjgzZWUw
Y2RmZWViYTU2ZjBlNWRkZDk3YWU5ODRmXSBNZXJnZSB0YWcgJ2RyaXZlci1jb3JlLTMuMTUt
cmMxJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQv
Z3JlZ2toL2RyaXZlci1jb3JlCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4OC9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQw
NTA3MDIvbmV4dDptYXN0ZXI6MTU4ZTBkMzYyMTY4M2VlMGNkZmVlYmE1NmYwZTVkZGQ5N2Fl
OTg0ZjpiaXNlY3QtbGludXg4CgoyMDE0LTA0LTA3LTE3OjA4OjIzIDE1OGUwZDM2MjE2ODNl
ZTBjZGZlZWJhNTZmMGU1ZGRkOTdhZTk4NGYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYnIwLTA0
MDUwNzAyLTE1OGUwZDM2MjE2ODNlZTBjZGZlZWJhNTZmMGU1ZGRkOTdhZTk4NGYKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi8x
NThlMGQzNjIxNjgzZWUwY2RmZWViYTU2ZjBlNWRkZDk3YWU5ODRmCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1icjAtMDQwNTA3MDItMTU4ZTBkMzYyMTY4M2VlMGNkZmVlYmE1NmYwZTVkZGQ5N2FlOTg0
Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
Lng4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi0xNThlMGQzNjIxNjgzZWUwY2RmZWVi
YTU2ZjBlNWRkZDk3YWU5ODRmCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1i
cjAtMDQwNTA3MDIvMTU4ZTBkMzYyMTY4M2VlMGNkZmVlYmE1NmYwZTVkZGQ5N2FlOTg0Zi92
bWxpbnV6LTMuMTQuMC0wMjUwNS1nMTU4ZTBkMwoKMjAxNC0wNC0wNy0xNzoxMDoyMyBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuCTUJMjUJMzAgU1VDQ0VTUwoKbGluZWFyLWJpc2VjdDogYmFk
IGJyYW5jaCBtYXkgYmUgdGFnICdzdGFnaW5nLTMuMTUtcmMxJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ3JlZ2toL3N0YWdpbmcKbGluZWFy
LWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQg
YmlzZWN0IHN0YXJ0IGMxMmU2OWM2YWFmNzg1ZmQzMDdkMDVjYjZmMzZjYTBlNzU3N2VhZDcg
MTU4ZTBkMzYyMTY4M2VlMGNkZmVlYmE1NmYwZTVkZGQ5N2FlOTg0ZiAtLQpQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyAxNThlMGQzLi4uIE1lcmdlIHRhZyAnZHJpdmVyLWNvcmUtMy4x
NS1yYzEnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9ncmVna2gvZHJpdmVyLWNvcmUKSEVBRCBpcyBub3cgYXQgZWRlYTBkMC4uLiBpYTY0OiBr
aWxsIHRocmVhZF9tYXRjaGVzKCksIHVuZXhwb3J0IHB0cmFjZV9jaGVja19hdHRhY2goKQpC
aXNlY3Rpbmc6IDY5MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMTAgc3RlcHMpClsxMDkzM2E5Y2ZhMjU4MDQ4ODEzZmQ4YTI4N2JlODQ0ZDMwNzExNzMx
XSBzdGFnaW5nOiBjb21lZGk6IHBjbDgxODogZXhpdCBpbnRlcnJ1cHQgcXVpY2sgd2hlbiB0
aGVyZSBpcyBub3RoaW5nIHRvIGRvCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0
cy9saW51eDgvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDgvb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYnIwLTA0
MDUwNzAyL25leHQ6bWFzdGVyOjEwOTMzYTljZmEyNTgwNDg4MTNmZDhhMjg3YmU4NDRkMzA3
MTE3MzE6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNC0wNy0xNzoxMjozNiAxMDkzM2E5Y2ZhMjU4
MDQ4ODEzZmQ4YTI4N2JlODQ0ZDMwNzExNzMxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0w
NDA1MDcwMi0xMDkzM2E5Y2ZhMjU4MDQ4ODEzZmQ4YTI4N2JlODQ0ZDMwNzExNzMxCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIv
MTA5MzNhOWNmYTI1ODA0ODgxM2ZkOGEyODdiZTg0NGQzMDcxMTczMQp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctYnIwLTA0MDUwNzAyLTEwOTMzYTljZmEyNTgwNDg4MTNmZDhhMjg3YmU4NDRkMzA3MTE3
MzEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
Ly54ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItMTA5MzNhOWNmYTI1ODA0ODgxM2Zk
OGEyODdiZTg0NGQzMDcxMTczMQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YnIwLTA0MDUwNzAyLzEwOTMzYTljZmEyNTgwNDg4MTNmZDhhMjg3YmU4NDRkMzA3MTE3MzEv
dm1saW51ei0zLjE0LjAtcmM1LTAwNjk0LWcxMDkzM2E5CgoyMDE0LTA0LTA3LTE3OjE1OjM2
IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAyMi44NTcxODZdIEZQ
R0EgaW1hZ2UgZmlsZSBuYW1lOiB4bGlueF9mcGdhX2Zpcm13YXJlLmJpdApbICAgMjIuODYx
MzM3XSBHUElPIElOSVQgRkFJTCEhClsgICAyMi44NjYwNzldIGRyaXZlciB2ZXJzaW9uIDEu
MC4wLjAgbG9hZGVkClsgICAyMi44Njc4NzddIGNoaXBzZXQgZHJpdmVyIHZlcnNpb24gMS4w
LjAuMCBsb2FkZWRpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIFBSRUVNUFQgU01QIApbICAg
MjIuODcyNzE1XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDIyLjg3MzQwMV0gQ1BVOiAxIFBJ
RDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjNS0wMDY5NC1nMTA5
MzNhOSAjMQpbICAgMjIuODczNDAxXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAyMi44NzM0MDFdIHRhc2s6IGZmZmY4ODAwMTE1N2Ew
MTAgdGk6IGZmZmY4ODAwMTE1N2MwMDAgdGFzay50aTogZmZmZjg4MDAxMTU3YzAwMApbICAg
MjIuODczNDAxXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxZTM3MTE1Pl0gIFs8ZmZmZmZmZmY4
MWUzNzExNT5dIHZpc29yY2hpcHNldF9pbml0KzB4N2IvMHg4YzUKWyAgIDIyLjg3MzQwMV0g
UlNQOiAwMDAwOmZmZmY4ODAwMTE1N2RlNTggIEVGTEFHUzogMDAwMDAyODYKWyAgIDIyLjg3
MzQwMV0gUkFYOiAwMDAwMDAwMDAwMDAwNzBiIFJCWDogMDAwMDAwMDAwMDAwMDAwNCBSQ1g6
IDQwMDAwMDAwMDAwMDAwMDAKWyAgIDIyLjg3MzQwMV0gUkRYOiBhNzBhYmE3NTAwMDAwMDAw
IFJTSTogZmZmZjg4MDAxMTU3ZGU1YyBSREk6IGZmZmY4ODAwMTE1N2RlNTgKWyAgIDIyLjg3
MzQwMV0gUkJQOiBmZmZmODgwMDExNTdkZTkwIFIwODogMDAwMDAwMDAwMDAwMDAwMiBSMDk6
IGZmZmY4ODAwMTE1N2RlNjAKWyAgIDIyLjg3MzQwMV0gUjEwOiBmZmZmODgwMDExNTdkZTY0
IFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IGZmZmY4ODAwMTE1N2RlNWMKWyAgIDIyLjg3
MzQwMV0gUjEzOiBmZmZmODgwMDExNTdkZTYwIFIxNDogZmZmZjg4MDAxMTU3ZGU2NCBSMTU6
IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDIyLjg3MzQwMV0gRlM6ICAwMDAwMDAwMDAwMDAwMDAw
KDAwMDApIEdTOmZmZmY4ODAwMTI3MDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAw
MApbICAgMjIuODczNDAxXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAw
MDAwMDgwMDUwMDNiClsgICAyMi44NzM0MDFdIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6
IDAwMDAwMDAwMDFjMDcwMDAgQ1I0OiAwMDAwMDAwMDAwMzAwNmUwClsgICAyMi44NzM0MDFd
IERSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAw
MDAwMDAwMDAwMDAwClsgICAyMi44NzM0MDFdIERSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6
IDAwMDAwMDAwMDAwMDAwMDAgRFI3OiAwMDAwMDAwMDAwMDAwMDAwClsgICAyMi44NzM0MDFd
IFN0YWNrOgpbICAgMjIuODczNDAxXSAgMDEwMDA4MDAwMDAzMDZjMSAwNzhiZmJmOTgyZDgy
MjAzIGZmZmZmZmZmODFlMzcwOWEgMDAwMDAwMDAwMDAwMDAwMApbICAgMjIuODczNDAxXSAg
MDAwMDAwMDAwMDAwMDFkZiAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZm
Zjg4MDAxMTU3ZGYwOApbICAgMjIuODczNDAxXSAgZmZmZmZmZmY4MTAwMDJiMiBmZmZmZmZm
ZjgxMGIyNjAwIGZmZmY4ODAwMTE1N2RmMDggZmZmZmZmZmY4MTBiMjdkYgpbICAgMjIuODcz
NDAxXSBDYWxsIFRyYWNlOgpbICAgMjIuODczNDAxXSAgWzxmZmZmZmZmZjgxZTM3MDlhPl0g
PyB2aXNvcmNoYW5uZWxfaW5pdCsweDFkLzB4MWQKWyAgIDIyLjg3MzQwMV0gIFs8ZmZmZmZm
ZmY4MTAwMDJiMj5dIGRvX29uZV9pbml0Y2FsbCsweDhlLzB4MTM4ClsgICAyMi44NzM0MDFd
ICBbPGZmZmZmZmZmODEwYjI2MDA+XSA/IHBhcmFtX2FycmF5X3NldCsweGVmLzB4ZjUKWyAg
IDIyLjg3MzQwMV0gIFs8ZmZmZmZmZmY4MTBiMjdkYj5dID8gcGFyc2VfYXJncysweDE4MC8w
eDI0OApbICAgMjIuODczNDAxXSAgWzxmZmZmZmZmZjgxZGZiZjg2Pl0ga2VybmVsX2luaXRf
ZnJlZWFibGUrMHgxMDgvMHgxOTkKWyAgIDIyLjg3MzQwMV0gIFs8ZmZmZmZmZmY4MWRmYjcz
YT5dID8gZG9fZWFybHlfcGFyYW0rMHg4YS8weDhhClsgICAyMi44NzM0MDFdICBbPGZmZmZm
ZmZmODE3M2U0M2U+XSA/IHJlc3RfaW5pdCsweGMyLzB4YzIKWyAgIDIyLjg3MzQwMV0gIFs8
ZmZmZmZmZmY4MTczZTQ0Nz5dIGtlcm5lbF9pbml0KzB4OS8weGRhClsgICAyMi44NzM0MDFd
ICBbPGZmZmZmZmZmODE3NWY2MGM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgMjIu
ODczNDAxXSAgWzxmZmZmZmZmZjgxNzNlNDNlPl0gPyByZXN0X2luaXQrMHhjMi8weGMyClsg
ICAyMi44NzM0MDFdIENvZGU6IDhkIDY1IGNjIDRjIDhkIDZkIGQwIDRjIDhkIDc1IGQ0IDc5
IDIxIDQ4IGJhIDAwIDAwIDAwIDAwIDc1IGJhIDBhIGE3IDQ4IGI5IDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDQwIGJiIDA0IDAwIDAwIDAwIGI4IDBiIDA3IDAwIDAwIDwwZj4gMDEgYzEgOGIg
MzUgYjIgYzQgYjQgMDAgNDggYzcgYzcgNTMgOTMgYjQgODEgMzEgYzAgZTggZWIgMTQgClsg
ICAyMi44NzM0MDFdIFJJUCAgWzxmZmZmZmZmZjgxZTM3MTE1Pl0gdmlzb3JjaGlwc2V0X2lu
aXQrMHg3Yi8weDhjNQpbICAgMjIuODczNDAxXSAgUlNQIDxmZmZmODgwMDExNTdkZTU4Pgpb
ICAgMjIuOTc5NDgwXSB2aGNpX2hjZDogdmhjaV9odWJfY29udHJvbDoyNDQ6IHR5cGVSZXEg
YTMwMCB3VmFsdWUgMCB3SW5kZXggMQpbICAgMjIuOTgyNTkzXSB2aGNpX2hjZDogdmhjaV9o
dWJfY29udHJvbDozMTA6ICBHZXRQb3J0U3RhdHVzIHBvcnQgMQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWJyMC0wNDA1MDcwMi8xMDkzM2E5Y2ZhMjU4MDQ4ODEzZmQ4YTI4N2JlODQ0
ZDMwNzExNzMxL2RtZXNnLXF1YW50YWwtZjMtNDY6MjAxNDA0MDcxNzE1MzU6eDg2XzY0LXJh
bmRjb25maWctYnIwLTA0MDUwNzAyOjMuMTQuMC1yYzUtMDA2OTQtZzEwOTMzYTk6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi8xMDkzM2E5Y2ZhMjU4MDQ4ODEz
ZmQ4YTI4N2JlODQ0ZDMwNzExNzMxL2RtZXNnLXlvY3RvLWYzLTExNjoyMDE0MDQwNzE3MTUz
NTp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLXJjNS0wMDY5NC1nMTA5
MzNhOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLzEwOTMzYTlj
ZmEyNTgwNDg4MTNmZDhhMjg3YmU4NDRkMzA3MTE3MzEvZG1lc2ctcXVhbnRhbC1mMy0xMDQ6
MjAxNDA0MDcxNzE1NDQ6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyOjMuMTQuMC1y
YzUtMDA2OTQtZzEwOTMzYTk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1
MDcwMi8xMDkzM2E5Y2ZhMjU4MDQ4ODEzZmQ4YTI4N2JlODQ0ZDMwNzExNzMxL2RtZXNnLXF1
YW50YWwtZjMtNTM6MjAxNDA0MDcxNzE1Mzg6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUw
NzAyOjMuMTQuMC1yYzUtMDA2OTQtZzEwOTMzYTk6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWJyMC0wNDA1MDcwMi8xMDkzM2E5Y2ZhMjU4MDQ4ODEzZmQ4YTI4N2JlODQ0ZDMwNzEx
NzMxL2RtZXNnLXF1YW50YWwtZjMtODI6MjAxNDA0MDcxNzE1NDE6eDg2XzY0LXJhbmRjb25m
aWctYnIwLTA0MDUwNzAyOjMuMTQuMC1yYzUtMDA2OTQtZzEwOTMzYTk6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi8xMDkzM2E5Y2ZhMjU4MDQ4ODEzZmQ4YTI4
N2JlODQ0ZDMwNzExNzMxL2RtZXNnLXlvY3RvLWYzLTI3OjIwMTQwNDA3MTcxNTQ2Ong4Nl82
NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAtcmM1LTAwNjk0LWcxMDkzM2E5OjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvMTA5MzNhOWNmYTI1ODA0
ODgxM2ZkOGEyODdiZTg0NGQzMDcxMTczMS9kbWVzZy15b2N0by1mMy03NToyMDE0MDQwNzE3
MTU0NDp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLXJjNS0wMDY5NC1n
MTA5MzNhOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLzEwOTMz
YTljZmEyNTgwNDg4MTNmZDhhMjg3YmU4NDRkMzA3MTE3MzEvZG1lc2cteW9jdG8tZjMtMjM6
MjAxNDA0MDcxNzE1NDc6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyOjMuMTQuMC1y
YzUtMDA2OTQtZzEwOTMzYTk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1
MDcwMi8xMDkzM2E5Y2ZhMjU4MDQ4ODEzZmQ4YTI4N2JlODQ0ZDMwNzExNzMxL2RtZXNnLXF1
YW50YWwtZjMtNDI6MjAxNDA0MDcxNzE1NTc6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUw
NzAyOjMuMTQuMC1yYzUtMDA2OTQtZzEwOTMzYTk6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWJyMC0wNDA1MDcwMi8xMDkzM2E5Y2ZhMjU4MDQ4ODEzZmQ4YTI4N2JlODQ0ZDMwNzEx
NzMxL2RtZXNnLXlvY3RvLWYzLTQ1OjIwMTQwNDA3MTcxNTUwOng4Nl82NC1yYW5kY29uZmln
LWJyMC0wNDA1MDcwMjozLjE0LjAtcmM1LTAwNjk0LWcxMDkzM2E5OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvMTA5MzNhOWNmYTI1ODA0ODgxM2ZkOGEyODdi
ZTg0NGQzMDcxMTczMS9kbWVzZy15b2N0by1mMy02NToyMDE0MDQwNzE3MTU1Nzp4ODZfNjQt
cmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLXJjNS0wMDY5NC1nMTA5MzNhOToxCjA6
MTE6MTEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMzQ2IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbYjE0ZWM0
YmQzZjU3NmJlMmJiN2RkNGM2OTc2NGE0MjJkNzgyZTA2ZF0gc3RhZ2luZzogY29tZWRpOiBw
Y2w4MTY6IHJlbW92ZSAnbGFzdF9pbnRfc3ViJyBmcm9tIHByaXZhdGUgZGF0YQpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10
ZXN0cy9saW51eDgvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL25leHQ6bWFzdGVyOmIxNGVjNGJk
M2Y1NzZiZTJiYjdkZDRjNjk3NjRhNDIyZDc4MmUwNmQ6YmlzZWN0LWxpbnV4OAoKMjAxNC0w
NC0wNy0xNzoxNjowOSBiMTRlYzRiZDNmNTc2YmUyYmI3ZGQ0YzY5NzY0YTQyMmQ3ODJlMDZk
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi1iMTRlYzRiZDNmNTc2YmUyYmI3
ZGQ0YzY5NzY0YTQyMmQ3ODJlMDZkCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvYjE0ZWM0YmQzZjU3NmJlMmJiN2RkNGM2OTc2
NGE0MjJkNzgyZTA2ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLWIxNGVjNGJkM2Y1
NzZiZTJiYjdkZDRjNjk3NjRhNDIyZDc4MmUwNmQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQw
NTA3MDItYjE0ZWM0YmQzZjU3NmJlMmJiN2RkNGM2OTc2NGE0MjJkNzgyZTA2ZAprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL2IxNGVjNGJkM2Y1NzZi
ZTJiYjdkZDRjNjk3NjRhNDIyZDc4MmUwNmQvdm1saW51ei0zLjE0LjAtcmMzLTAwMzQ3LWdi
MTRlYzRiCgoyMDE0LTA0LTA3LTE3OjE4OjEwIGRldGVjdGluZyBib290IHN0YXRlIAkzCTIx
CTMwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTczIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbZjM3ZTc1NjAzM2M5MThjMTk4YmMyZGY2ZGFk
YTI3ZGYyNWNlNWE2Zl0gc3RhZ2luZzogcnRsODE4N3NlOiBDb252ZXJ0IFN0YXRzIHR5cGVk
ZWYgaW50byBhIHN0cnVjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDgvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUw
NzAyL25leHQ6bWFzdGVyOmYzN2U3NTYwMzNjOTE4YzE5OGJjMmRmNmRhZGEyN2RmMjVjZTVh
NmY6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNC0wNy0xNzoxOTo0MSBmMzdlNzU2MDMzYzkxOGMx
OThiYzJkZjZkYWRhMjdkZjI1Y2U1YTZmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1
MDcwMi1mMzdlNzU2MDMzYzkxOGMxOThiYzJkZjZkYWRhMjdkZjI1Y2U1YTZmCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvZjM3
ZTc1NjAzM2M5MThjMTk4YmMyZGY2ZGFkYTI3ZGYyNWNlNWE2Zgp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWct
YnIwLTA0MDUwNzAyLWYzN2U3NTYwMzNjOTE4YzE5OGJjMmRmNmRhZGEyN2RmMjVjZTVhNmYK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54
ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItZjM3ZTc1NjAzM2M5MThjMTk4YmMyZGY2
ZGFkYTI3ZGYyNWNlNWE2ZgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIw
LTA0MDUwNzAyL2YzN2U3NTYwMzNjOTE4YzE5OGJjMmRmNmRhZGEyN2RmMjVjZTVhNmYvdm1s
aW51ei0zLjE0LjAtcmM0LTAwNTIwLWdmMzdlNzU2CgoyMDE0LTA0LTA3LTE3OjIyOjQxIGRl
dGVjdGluZyBib290IHN0YXRlIC4JNAk3CTE0CTIxCTIzCTI3CTMwIFNVQ0NFU1MKCkJpc2Vj
dGluZzogODYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcg
c3RlcHMpCls5OWExYjk4YjMyMjExNzEzZDhlNTQ0ZTk3MzdhNWZhMjBiNzNkY2UzXSBzdGFn
aW5nOiBjb21lZGk6IGtlX2NvdW50ZXI6IGZpeCBrZV9jb3VudGVyX2luc25fd3JpdGUoKQpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tl
cm5lbC10ZXN0cy9saW51eDgvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL25leHQ6bWFzdGVyOjk5
YTFiOThiMzIyMTE3MTNkOGU1NDRlOTczN2E1ZmEyMGI3M2RjZTM6YmlzZWN0LWxpbnV4OAoK
MjAxNC0wNC0wNy0xNzoyNjo0MiA5OWExYjk4YjMyMjExNzEzZDhlNTQ0ZTk3MzdhNWZhMjBi
NzNkY2UzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi05OWExYjk4YjMyMjEx
NzEzZDhlNTQ0ZTk3MzdhNWZhMjBiNzNkY2UzCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvOTlhMWI5OGIzMjIxMTcxM2Q4ZTU0
NGU5NzM3YTVmYTIwYjczZGNlMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLTk5YTFi
OThiMzIyMTE3MTNkOGU1NDRlOTczN2E1ZmEyMGI3M2RjZTMKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1i
cjAtMDQwNTA3MDItOTlhMWI5OGIzMjIxMTcxM2Q4ZTU0NGU5NzM3YTVmYTIwYjczZGNlMwpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLzk5YTFiOThi
MzIyMTE3MTNkOGU1NDRlOTczN2E1ZmEyMGI3M2RjZTMvdm1saW51ei0zLjE0LjAtcmM1LTAw
NjA3LWc5OWExYjk4CgoyMDE0LTA0LTA3LTE3OjMzOjQyIGRldGVjdGluZyBib290IHN0YXRl
IC4JMwk5CTE1CTI3LgkzMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDQzIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbOWIwNzNhYzUzZWVhOTAy
NzEyZjg4Mzg4YjQyZWZjZWJjZTIxMWJlY10gc3RhZ2luZzogZGdhcDogRml4IHZhcmlvdXMg
cHJldmlvdXNseSBtaXNzZWQgY2hlY2twYXRjaCBlcnJvcnMKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg4
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLWJyMC0wNDA1MDcwMi9uZXh0Om1hc3Rlcjo5YjA3M2FjNTNlZWE5MDI3MTJm
ODgzODhiNDJlZmNlYmNlMjExYmVjOmJpc2VjdC1saW51eDgKCjIwMTQtMDQtMDctMTc6Mzc6
MTMgOWIwNzNhYzUzZWVhOTAyNzEyZjg4Mzg4YjQyZWZjZWJjZTIxMWJlYyBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1icjAtMDQwNTA3MDItOWIwNzNhYzUzZWVhOTAyNzEyZjg4Mzg4YjQyZWZj
ZWJjZTIxMWJlYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYnIwLTA0MDUwNzAyLzliMDczYWM1M2VlYTkwMjcxMmY4ODM4OGI0MmVmY2ViY2UyMTFi
ZWMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi05YjA3M2FjNTNlZWE5MDI3MTJmODgz
ODhiNDJlZmNlYmNlMjExYmVjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLTliMDcz
YWM1M2VlYTkwMjcxMmY4ODM4OGI0MmVmY2ViY2UyMTFiZWMKa2VybmVsOiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi85YjA3M2FjNTNlZWE5MDI3MTJmODgzODhi
NDJlZmNlYmNlMjExYmVjL3ZtbGludXotMy4xNC4wLXJjNS0wMDY1MC1nOWIwNzNhYwoKMjAx
NC0wNC0wNy0xNzo0MDoxMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpb
ICAgMjguOTk1NzAwXSBGUEdBIGltYWdlIGZpbGUgbmFtZTogeGxpbnhfZnBnYV9maXJtd2Fy
ZS5iaXQKWyAgIDI4Ljk5ODkzN10gR1BJTyBJTklUIEZBSUwhIQpbICAgMjkuMDAzNzc3XSBk
cml2ZXIgdmVyc2lvbiAxLjAuMC4wIGxvYWRlZApbICAgMjkuMDA0ODE5XSBjaGlwc2V0IGRy
aXZlciB2ZXJzaW9uIDEuMC4wLjAgbG9hZGVkaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBQ
UkVFTVBUIFNNUCAKWyAgIDI5LjAwNzUwNl0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAyOS4w
MDgwNTRdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTQu
MC1yYzUtMDA2NTAtZzliMDczYWMgIzEKWyAgIDI5LjAwODA1NF0gSGFyZHdhcmUgbmFtZTog
Qm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMjkuMDA4MDU0XSB0YXNr
OiBmZmZmODgwMDExNTdhMDEwIHRpOiBmZmZmODgwMDExNTdjMDAwIHRhc2sudGk6IGZmZmY4
ODAwMTE1N2MwMDAKWyAgIDI5LjAwODA1NF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MWUzNzEx
NT5dICBbPGZmZmZmZmZmODFlMzcxMTU+XSB2aXNvcmNoaXBzZXRfaW5pdCsweDdiLzB4OGM1
ClsgICAyOS4wMDgwNTRdIFJTUDogMDAwMDpmZmZmODgwMDExNTdkZTU4ICBFRkxBR1M6IDAw
MDAwMjg2ClsgICAyOS4wMDgwNTRdIFJBWDogMDAwMDAwMDAwMDAwMDcwYiBSQlg6IDAwMDAw
MDAwMDAwMDAwMDQgUkNYOiA0MDAwMDAwMDAwMDAwMDAwClsgICAyOS4wMDgwNTRdIFJEWDog
YTcwYWJhNzUwMDAwMDAwMCBSU0k6IGZmZmY4ODAwMTE1N2RlNWMgUkRJOiBmZmZmODgwMDEx
NTdkZTU4ClsgICAyOS4wMDgwNTRdIFJCUDogZmZmZjg4MDAxMTU3ZGU5MCBSMDg6IDAwMDAw
MDAwMDAwMDAwMDIgUjA5OiBmZmZmODgwMDExNTdkZTYwClsgICAyOS4wMDgwNTRdIFIxMDog
ZmZmZjg4MDAxMTU3ZGU2NCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiBmZmZmODgwMDEx
NTdkZTVjClsgICAyOS4wMDgwNTRdIFIxMzogZmZmZjg4MDAxMTU3ZGU2MCBSMTQ6IGZmZmY4
ODAwMTE1N2RlNjQgUjE1OiAwMDAwMDAwMDAwMDAwMDAwClsgICAyOS4wMDgwNTRdIEZTOiAg
MDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDEyNjAwMDAwKDAwMDApIGtubEdT
OjAwMDAwMDAwMDAwMDAwMDAKWyAgIDI5LjAwODA1NF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVT
OiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgMjkuMDA4MDU0XSBDUjI6IDAwMDAw
MDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDAxYzA3MDAwIENSNDogMDAwMDAwMDAwMDMwMDZm
MApbICAgMjkuMDA4MDU0XSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAw
MDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMApbICAgMjkuMDA4MDU0XSBEUjM6IDAwMDAw
MDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMDAwMDAwMDAwIERSNzogMDAwMDAwMDAwMDAwMDAw
MApbICAgMjkuMDA4MDU0XSBTdGFjazoKWyAgIDI5LjAwODA1NF0gIDAwMDAwODAwMDAwMzA2
YzEgMDc4YmZiZjk4MmQ4MjIwMyBmZmZmZmZmZjgxZTM3MDlhIDAwMDAwMDAwMDAwMDAwMDAK
WyAgIDI5LjAwODA1NF0gIDAwMDAwMDAwMDAwMDAxZGYgMDAwMDAwMDAwMDAwMDAwMCAwMDAw
MDAwMDAwMDAwMDAwIGZmZmY4ODAwMTE1N2RmMDgKWyAgIDI5LjAwODA1NF0gIGZmZmZmZmZm
ODEwMDAyYjIgZmZmZmZmZmY4MTBiMjYwMCBmZmZmODgwMDExNTdkZjA4IGZmZmZmZmZmODEw
YjI3ZGIKWyAgIDI5LjAwODA1NF0gQ2FsbCBUcmFjZToKWyAgIDI5LjAwODA1NF0gIFs8ZmZm
ZmZmZmY4MWUzNzA5YT5dID8gdmlzb3JjaGFubmVsX2luaXQrMHgxZC8weDFkClsgICAyOS4w
MDgwNTRdICBbPGZmZmZmZmZmODEwMDAyYjI+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZS8weDEz
OApbICAgMjkuMDA4MDU0XSAgWzxmZmZmZmZmZjgxMGIyNjAwPl0gPyBwYXJhbV9hcnJheV9z
ZXQrMHhlZi8weGY1ClsgICAyOS4wMDgwNTRdICBbPGZmZmZmZmZmODEwYjI3ZGI+XSA/IHBh
cnNlX2FyZ3MrMHgxODAvMHgyNDgKWyAgIDI5LjAwODA1NF0gIFs8ZmZmZmZmZmY4MWRmYmY4
Nj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTA4LzB4MTk5ClsgICAyOS4wMDgwNTRdICBb
PGZmZmZmZmZmODFkZmI3M2E+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4OGEvMHg4YQpbICAgMjku
MDA4MDU0XSAgWzxmZmZmZmZmZjgxNzNlNDNlPl0gPyByZXN0X2luaXQrMHhjMi8weGMyClsg
ICAyOS4wMDgwNTRdICBbPGZmZmZmZmZmODE3M2U0NDc+XSBrZXJuZWxfaW5pdCsweDkvMHhk
YQpbICAgMjkuMDA4MDU0XSAgWzxmZmZmZmZmZjgxNzVmNjBjPl0gcmV0X2Zyb21fZm9yaysw
eDdjLzB4YjAKWyAgIDI5LjAwODA1NF0gIFs8ZmZmZmZmZmY4MTczZTQzZT5dID8gcmVzdF9p
bml0KzB4YzIvMHhjMgpbICAgMjkuMDA4MDU0XSBDb2RlOiA4ZCA2NSBjYyA0YyA4ZCA2ZCBk
MCA0YyA4ZCA3NSBkNCA3OSAyMSA0OCBiYSAwMCAwMCAwMCAwMCA3NSBiYSAwYSBhNyA0OCBi
OSAwMCAwMCAwMCAwMCAwMCAwMCAwMCA0MCBiYiAwNCAwMCAwMCAwMCBiOCAwYiAwNyAwMCAw
MCA8MGY+IDAxIGMxIDhiIDM1IGIyIGM0IGI0IDAwIDQ4IGM3IGM3IDUzIDkzIGI0IDgxIDMx
IGMwIGU4IGViIDE0IApbICAgMjkuMDA4MDU0XSBSSVAgIFs8ZmZmZmZmZmY4MWUzNzExNT5d
IHZpc29yY2hpcHNldF9pbml0KzB4N2IvMHg4YzUKWyAgIDI5LjAwODA1NF0gIFJTUCA8ZmZm
Zjg4MDAxMTU3ZGU1OD4KWyAgIDI5LjA1NzAxM10gLS0tWyBlbmQgdHJhY2UgYzQ4YmYxYmNk
ZjY1NGZhYyBdLS0tClsgICAyOS4wNTg0MDFdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5n
OiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3
MDIvOWIwNzNhYzUzZWVhOTAyNzEyZjg4Mzg4YjQyZWZjZWJjZTIxMWJlYy9kbWVzZy15b2N0
by1mMy0xMDQ6MjAxNDA0MDcxNzQwMDM6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAy
OjMuMTQuMC1yYzUtMDA2NTAtZzliMDczYWM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWJyMC0wNDA1MDcwMi85YjA3M2FjNTNlZWE5MDI3MTJmODgzODhiNDJlZmNlYmNlMjExYmVj
L2RtZXNnLXlvY3RvLWYzLTEyNToyMDE0MDQwNzE3NDAyMDp4ODZfNjQtcmFuZGNvbmZpZy1i
cjAtMDQwNTA3MDI6My4xNC4wLXJjNS0wMDY1MC1nOWIwNzNhYzoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLzliMDczYWM1M2VlYTkwMjcxMmY4ODM4OGI0MmVm
Y2ViY2UyMTFiZWMvZG1lc2ctcXVhbnRhbC1mMy02NToyMDE0MDQwNzE3NDAyODp4ODZfNjQt
cmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLXJjNS0wMDY1MC1nOWIwNzNhYzoxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLzliMDczYWM1M2VlYTkwMjcx
MmY4ODM4OGI0MmVmY2ViY2UyMTFiZWMvZG1lc2cteW9jdG8tZjQtNDU6MjAxNDA0MDcxNzQw
MjY6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyOjMuMTQuMC1yYzUtMDA2NTAtZzli
MDczYWM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi85YjA3M2Fj
NTNlZWE5MDI3MTJmODgzODhiNDJlZmNlYmNlMjExYmVjL2RtZXNnLXF1YW50YWwtZjMtMTc6
MjAxNDA0MDcxNzQwMzY6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyOjMuMTQuMC1y
YzUtMDA2NTAtZzliMDczYWM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1
MDcwMi85YjA3M2FjNTNlZWE5MDI3MTJmODgzODhiNDJlZmNlYmNlMjExYmVjL2RtZXNnLXlv
Y3RvLWYzLTEwNDoyMDE0MDQwNzE3NDAzOTp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3
MDI6My4xNC4wLXJjNS0wMDY1MC1nOWIwNzNhYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYnIwLTA0MDUwNzAyLzliMDczYWM1M2VlYTkwMjcxMmY4ODM4OGI0MmVmY2ViY2UyMTFi
ZWMvZG1lc2cteW9jdG8tZjMtMjU6MjAxNDA0MDcxNzQwNDM6eDg2XzY0LXJhbmRjb25maWct
YnIwLTA0MDUwNzAyOjMuMTQuMC1yYzUtMDA2NTAtZzliMDczYWM6MQoxOjc6NCBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAyMSByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzZjNzZhYWI1YmRlYzc2OWFjMDVi
YjgxZGM2YmI0NmNkNWEyNTNiNGJdIGRyaXZlcnM6IHN0YWdpbmc6IHJ0bDgxODdzZTogcmVm
YWN0b3IvY2xlYW4gc2lnbmFsIHNtb290aGluZwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDgvb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctYnIwLTA0MDUwNzAyL25leHQ6bWFzdGVyOjZjNzZhYWI1YmRlYzc2OWFjMDViYjgxZGM2
YmI0NmNkNWEyNTNiNGI6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNC0wNy0xNzo0MDo0NyA2Yzc2
YWFiNWJkZWM3NjlhYzA1YmI4MWRjNmJiNDZjZDVhMjUzYjRiIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLWJyMC0wNDA1MDcwMi02Yzc2YWFiNWJkZWM3NjlhYzA1YmI4MWRjNmJiNDZjZDVhMjUz
YjRiCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAt
MDQwNTA3MDIvNmM3NmFhYjViZGVjNzY5YWMwNWJiODFkYzZiYjQ2Y2Q1YTI1M2I0Ygp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLTZjNzZhYWI1YmRlYzc2OWFjMDViYjgxZGM2YmI0
NmNkNWEyNTNiNGIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItNmM3NmFhYjViZGVj
NzY5YWMwNWJiODFkYzZiYjQ2Y2Q1YTI1M2I0YgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYnIwLTA0MDUwNzAyLzZjNzZhYWI1YmRlYzc2OWFjMDViYjgxZGM2YmI0NmNk
NWEyNTNiNGIvdm1saW51ei0zLjE0LjAtcmM1LTAwNjI4LWc2Yzc2YWFiCgoyMDE0LTA0LTA3
LTE3OjQyOjQ3IGRldGVjdGluZyBib290IHN0YXRlIC4JMSBURVNUIEZBSUxVUkUKWyAgIDQ0
Ljk1NzQwMl0gR1BJTyBJTklUIEZBSUwhIQpbICAgNDQuOTY1OTY0XSBkcml2ZXIgdmVyc2lv
biAxLjAuMC4wIGxvYWRlZApbICAgNDQuOTY3NjYyXSBjaGlwc2V0IGRyaXZlciB2ZXJzaW9u
IDEuMC4wLjAgbG9hZGVkClsgICA0NC45Njc3MDldIGludmFsaWQgb3Bjb2RlOiAwMDAwIFsj
MV0gUFJFRU1QVCBTTVAgClsgICA0NC45Njc4NjNdIE1vZHVsZXMgbGlua2VkIGluOgpbICAg
NDQuOTY4NjA3XSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAz
LjE0LjAtcmM1LTAwNjI4LWc2Yzc2YWFiICMxClsgICA0NC45Njg2MzddIEhhcmR3YXJlIG5h
bWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDQ0Ljk2ODgzM10g
dGFzazogZmZmZjg4MDAxMTU3YTAxMCB0aTogZmZmZjg4MDAxMTU3YzAwMCB0YXNrLnRpOiBm
ZmZmODgwMDExNTdjMDAwClsgICA0NC45Njk2MDZdIFJJUDogMDAxMDpbPGZmZmZmZmZmODFl
MzcxMTU+XSAgWzxmZmZmZmZmZjgxZTM3MTE1Pl0gdmlzb3JjaGlwc2V0X2luaXQrMHg3Yi8w
eDhjNQpbICAgNDQuOTY5NjQ4XSBSU1A6IDAwMDA6ZmZmZjg4MDAxMTU3ZGU1OCAgRUZMQUdT
OiAwMDAwMDI4NgpbICAgNDQuOTY5Njc2XSBSQVg6IDAwMDAwMDAwMDAwMDA3MGIgUkJYOiAw
MDAwMDAwMDAwMDAwMDA0IFJDWDogNDAwMDAwMDAwMDAwMDAwMApbICAgNDQuOTY5NzAzXSBS
RFg6IGE3MGFiYTc1MDAwMDAwMDAgUlNJOiBmZmZmODgwMDExNTdkZTVjIFJESTogZmZmZjg4
MDAxMTU3ZGU1OApbICAgNDQuOTY5NzMxXSBSQlA6IGZmZmY4ODAwMTE1N2RlOTAgUjA4OiAw
MDAwMDAwMDAwMDAwMDAyIFIwOTogZmZmZjg4MDAxMTU3ZGU2MApbICAgNDQuOTY5NzU4XSBS
MTA6IGZmZmY4ODAwMTE1N2RlNjQgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogZmZmZjg4
MDAxMTU3ZGU1YwpbICAgNDQuOTY5Nzk2XSBSMTM6IGZmZmY4ODAwMTE1N2RlNjAgUjE0OiBm
ZmZmODgwMDExNTdkZTY0IFIxNTogMDAwMDAwMDAwMDAwMDAwMApbICAgNDQuOTY5ODkyXSBG
UzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4MDAxMjcwMDAwMCgwMDAwKSBr
bmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICA0NC45Njk5MjBdIENTOiAgMDAxMCBEUzogMDAw
MCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgIDQ0Ljk3MDA4NV0gQ1IyOiAw
MDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAwMWMwNzAwMCBDUjQ6IDAwMDAwMDAwMDAz
MDA2ZTAKWyAgIDQ0Ljk3MDA4NV0gRFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAw
MDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDQ0Ljk3MDA4NV0gRFIzOiAw
MDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDAwMDAwMDAwMCBEUjc6IDAwMDAwMDAwMDAw
MDAwMDAKWyAgIDQ0Ljk3MDA4NV0gU3RhY2s6ClsgICA0NC45NzAwODVdICAwMTAwMDgwMDAw
MDMwNmMxIDA3OGJmYmY5ODJkODIyMDMgZmZmZmZmZmY4MWUzNzA5YSAwMDAwMDAwMDAwMDAw
MDAwClsgICA0NC45NzAwODVdICAwMDAwMDAwMDAwMDAwMWRmIDAwMDAwMDAwMDAwMDAwMDAg
MDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDExNTdkZjA4ClsgICA0NC45NzAwODVdICBmZmZm
ZmZmZjgxMDAwMmIyIGZmZmZmZmZmODEwYjI2MDAgZmZmZjg4MDAxMTU3ZGYwOCBmZmZmZmZm
ZjgxMGIyN2RiClsgICA0NC45NzAwODVdIENhbGwgVHJhY2U6ClsgICA0NC45NzAwODVdICBb
PGZmZmZmZmZmODFlMzcwOWE+XSA/IHZpc29yY2hhbm5lbF9pbml0KzB4MWQvMHgxZApbICAg
NDQuOTcwMDg1XSAgWzxmZmZmZmZmZjgxMDAwMmIyPl0gZG9fb25lX2luaXRjYWxsKzB4OGUv
MHgxMzgKWyAgIDQ0Ljk3MDA4NV0gIFs8ZmZmZmZmZmY4MTBiMjYwMD5dID8gcGFyYW1fYXJy
YXlfc2V0KzB4ZWYvMHhmNQpbICAgNDQuOTcwMDg1XSAgWzxmZmZmZmZmZjgxMGIyN2RiPl0g
PyBwYXJzZV9hcmdzKzB4MTgwLzB4MjQ4ClsgICA0NC45NzAwODVdICBbPGZmZmZmZmZmODFk
ZmJmODY+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEwOC8weDE5OQpbICAgNDQuOTcwMDg1
XSAgWzxmZmZmZmZmZjgxZGZiNzNhPl0gPyBkb19lYXJseV9wYXJhbSsweDhhLzB4OGEKWyAg
IDQ0Ljk3MDA4NV0gIFs8ZmZmZmZmZmY4MTczZjA4ZT5dID8gcmVzdF9pbml0KzB4YzIvMHhj
MgpbICAgNDQuOTcwMDg1XSAgWzxmZmZmZmZmZjgxNzNmMDk3Pl0ga2VybmVsX2luaXQrMHg5
LzB4ZGEKWyAgIDQ0Ljk3MDA4NV0gIFs8ZmZmZmZmZmY4MTc2MDI0Yz5dIHJldF9mcm9tX2Zv
cmsrMHg3Yy8weGIwClsgICA0NC45NzAwODVdICBbPGZmZmZmZmZmODE3M2YwOGU+XSA/IHJl
c3RfaW5pdCsweGMyLzB4YzIKWyAgIDQ0Ljk3MDA4NV0gQ29kZTogOGQgNjUgY2MgNGMgOGQg
NmQgZDAgNGMgOGQgNzUgZDQgNzkgMjEgNDggYmEgMDAgMDAgMDAgMDAgNzUgYmEgMGEgYTcg
NDggYjkgMDAgMDAgMDAgMDAgMDAgMDAgMDAgNDAgYmIgMDQgMDAgMDAgMDAgYjggMGIgMDcg
MDAgMDAgPDBmPiAwMSBjMSA4YiAzNSBjMiBjNCBiNCAwMCA0OCBjNyBjNyBmNSA5MyBiNCA4
MSAzMSBjMCBlOCAzYiAyMSAKWyAgIDQ0Ljk3MDA4NV0gUklQICBbPGZmZmZmZmZmODFlMzcx
MTU+XSB2aXNvcmNoaXBzZXRfaW5pdCsweDdiLzB4OGM1ClsgICA0NC45NzAwODVdICBSU1Ag
PGZmZmY4ODAwMTE1N2RlNTg+ClsgICA0NC45NzQ1NjddIC0tLVsgZW5kIHRyYWNlIGFlODQ5
OTAwN2ZiNzAxN2QgXS0tLQpbICAgNDQuOTc0ODE5XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3lu
Y2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0
MDUwNzAyLzZjNzZhYWI1YmRlYzc2OWFjMDViYjgxZGM2YmI0NmNkNWEyNTNiNGIvZG1lc2ct
eW9jdG8tZjMtMTE1OjIwMTQwNDA3MTc0MzExOng4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1
MDcwMjozLjE0LjAtcmM1LTAwNjI4LWc2Yzc2YWFiOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1icjAtMDQwNTA3MDIvNmM3NmFhYjViZGVjNzY5YWMwNWJiODFkYzZiYjQ2Y2Q1YTI1
M2I0Yi9kbWVzZy15b2N0by1mMy02MjoyMDE0MDQwNzE3NDMxNjp4ODZfNjQtcmFuZGNvbmZp
Zy1icjAtMDQwNTA3MDI6My4xNC4wLXJjNS0wMDYyOC1nNmM3NmFhYjoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLzZjNzZhYWI1YmRlYzc2OWFjMDViYjgxZGM2
YmI0NmNkNWEyNTNiNGIvZG1lc2cteW9jdG8tZjMtODI6MjAxNDA0MDcxNzQzMTQ6eDg2XzY0
LXJhbmRjb25maWctYnIwLTA0MDUwNzAyOjMuMTQuMC1yYzUtMDA2MjgtZzZjNzZhYWI6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi82Yzc2YWFiNWJkZWM3Njlh
YzA1YmI4MWRjNmJiNDZjZDVhMjUzYjRiL2RtZXNnLXF1YW50YWwtZjMtMTE6MjAxNDA0MDcx
NzQzMzg6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyOjMuMTQuMC1yYzUtMDA2Mjgt
ZzZjNzZhYWI6MQoxOjQ6NCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5n
OiAxMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVw
cykKWzVjMmYyNmRlZjhmM2JiMjUyYzMyZGY0Y2JlMDk3OTE0MGQ4ZmFjZTZdIHN0YWdpbmc6
IG9jdGVvbi1ldGhlcm5ldDogYWRkIG1pc3NpbmcgaW5jbHVkZQpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51
eDgvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL25leHQ6bWFzdGVyOjVjMmYyNmRlZjhmM2JiMjUy
YzMyZGY0Y2JlMDk3OTE0MGQ4ZmFjZTY6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNC0wNy0xNzo0
Mzo1MSA1YzJmMjZkZWY4ZjNiYjI1MmMzMmRmNGNiZTA5NzkxNDBkOGZhY2U2IGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi01YzJmMjZkZWY4ZjNiYjI1MmMzMmRmNGNiZTA5
NzkxNDBkOGZhY2U2CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1icjAtMDQwNTA3MDIvNWMyZjI2ZGVmOGYzYmIyNTJjMzJkZjRjYmUwOTc5MTQwZDhm
YWNlNgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLTVjMmYyNmRlZjhmM2JiMjUyYzMy
ZGY0Y2JlMDk3OTE0MGQ4ZmFjZTYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItNWMy
ZjI2ZGVmOGYzYmIyNTJjMzJkZjRjYmUwOTc5MTQwZDhmYWNlNgprZXJuZWw6IC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLzVjMmYyNmRlZjhmM2JiMjUyYzMyZGY0
Y2JlMDk3OTE0MGQ4ZmFjZTYvdm1saW51ei0zLjE0LjAtcmM1LTAwNjE3LWc1YzJmMjZkCgoy
MDE0LTA0LTA3LTE3OjQ2OjUxIGRldGVjdGluZyBib290IHN0YXRlIC4uCTExCTE2CTI2CTI4
CTMwIFNVQ0NFU1MKCkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzdiMmEyZDgzODNkMDg3OTNhYWMzZjE1N2ZhM2Yz
OGVhOTBjNWQzYzBdIHN0YWdpbmc6IHZpc29yY2hhbm5lbHN0dWIgZHJpdmVyIHRvIHByb3Zp
ZGUgY2hhbm5lbCBzdXBwb3J0IHJvdXRpbmVzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4OC9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1icjAtMDQwNTA3MDIvbmV4dDptYXN0ZXI6N2IyYTJkODM4M2QwODc5M2FhYzNmMTU3ZmEz
ZjM4ZWE5MGM1ZDNjMDpiaXNlY3QtbGludXg4CgoyMDE0LTA0LTA3LTE3OjUwOjIyIDdiMmEy
ZDgzODNkMDg3OTNhYWMzZjE1N2ZhM2YzOGVhOTBjNWQzYzAgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctYnIwLTA0MDUwNzAyLTdiMmEyZDgzODNkMDg3OTNhYWMzZjE1N2ZhM2YzOGVhOTBjNWQz
YzAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0w
NDA1MDcwMi83YjJhMmQ4MzgzZDA4NzkzYWFjM2YxNTdmYTNmMzhlYTkwYzVkM2MwCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1icjAtMDQwNTA3MDItN2IyYTJkODM4M2QwODc5M2FhYzNmMTU3ZmEzZjM4
ZWE5MGM1ZDNjMAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVp
bGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi03YjJhMmQ4MzgzZDA4
NzkzYWFjM2YxNTdmYTNmMzhlYTkwYzVkM2MwCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1icjAtMDQwNTA3MDIvN2IyYTJkODM4M2QwODc5M2FhYzNmMTU3ZmEzZjM4ZWE5
MGM1ZDNjMC92bWxpbnV6LTMuMTQuMC1yYzUtMDA2MjItZzdiMmEyZDgKCjIwMTQtMDQtMDct
MTc6NTM6MjIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgIDEzLjM2
MjE1Nl0gRlBHQSBpbWFnZSBmaWxlIG5hbWU6IHhsaW54X2ZwZ2FfZmlybXdhcmUuYml0Clsg
ICAxMy4zNjQ2MDddIEdQSU8gSU5JVCBGQUlMISEKWyAgIDEzLjM2ODIzN10gZHJpdmVyIHZl
cnNpb24gMS4wLjAuMCBsb2FkZWQKWyAgIDEzLjM2ODc2NF0gY2hpcHNldCBkcml2ZXIgdmVy
c2lvbiAxLjAuMC4wIGxvYWRlZGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gUFJFRU1QVCBT
TVAgClsgICAxMy4zNzA1NjRdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgMTMuMzcwNTY0XSBD
UFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM1LTAw
NjIyLWc3YjJhMmQ4ICMxClsgICAxMy4zNzA1NjRdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJv
Y2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDEzLjM3MDU2NF0gdGFzazogZmZmZjg4
MDAxMjk3YTAxMCB0aTogZmZmZjg4MDAxMjk3YzAwMCB0YXNrLnRpOiBmZmZmODgwMDEyOTdj
MDAwClsgICAxMy4zNzA1NjRdIFJJUDogMDAxMDpbPGZmZmZmZmZmODFlMzcxMTU+XSAgWzxm
ZmZmZmZmZjgxZTM3MTE1Pl0gdmlzb3JjaGlwc2V0X2luaXQrMHg3Yi8weDhjNQpbICAgMTMu
MzcwNTY0XSBSU1A6IDAwMDA6ZmZmZjg4MDAxMjk3ZGU1OCAgRUZMQUdTOiAwMDAwMDI4Ngpb
ICAgMTMuMzcwNTY0XSBSQVg6IDAwMDAwMDAwMDAwMDA3MGIgUkJYOiAwMDAwMDAwMDAwMDAw
MDA0IFJDWDogNDAwMDAwMDAwMDAwMDAwMApbICAgMTMuMzcwNTY0XSBSRFg6IGE3MGFiYTc1
MDAwMDAwMDAgUlNJOiBmZmZmODgwMDEyOTdkZTVjIFJESTogZmZmZjg4MDAxMjk3ZGU1OApb
ICAgMTMuMzcwNTY0XSBSQlA6IGZmZmY4ODAwMTI5N2RlOTAgUjA4OiAwMDAwMDAwMDAwMDAw
MDAyIFIwOTogZmZmZjg4MDAxMjk3ZGU2MApbICAgMTMuMzcwNTY0XSBSMTA6IGZmZmY4ODAw
MTI5N2RlNjQgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogZmZmZjg4MDAxMjk3ZGU1Ywpb
ICAgMTMuMzcwNTY0XSBSMTM6IGZmZmY4ODAwMTI5N2RlNjAgUjE0OiBmZmZmODgwMDEyOTdk
ZTY0IFIxNTogMDAwMDAwMDAwMDAwMDAwMApbICAgMTMuMzcwNTY0XSBGUzogIDAwMDAwMDAw
MDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4MDAxM2IwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAw
MDAwMDAwMDAwClsgICAxMy4zNzA1NjRdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBD
UjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgIDEzLjM3MDU2NF0gQ1IyOiAwMDAwMDAwMDAwMDAw
MDAwIENSMzogMDAwMDAwMDAwMWMwNzAwMCBDUjQ6IDAwMDAwMDAwMDAzMDA2ZTAKWyAgIDEz
LjM3MDU2NF0gRFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBE
UjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDEzLjM3MDU2NF0gRFIzOiAwMDAwMDAwMDAwMDAw
MDAwIERSNjogMDAwMDAwMDAwMDAwMDAwMCBEUjc6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDEz
LjM3MDU2NF0gU3RhY2s6ClsgICAxMy4zNzA1NjRdICAwMTAwMDgwMDAwMDMwNmMxIDA3OGJm
YmY5ODJkODIyMDMgZmZmZmZmZmY4MWUzNzA5YSAwMDAwMDAwMDAwMDAwMDAwClsgICAxMy4z
NzA1NjRdICAwMDAwMDAwMDAwMDAwMWRmIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAw
MDAwMCBmZmZmODgwMDEyOTdkZjA4ClsgICAxMy4zNzA1NjRdICBmZmZmZmZmZjgxMDAwMmIy
IGZmZmZmZmZmODEwYjI2MDAgZmZmZjg4MDAxMjk3ZGYwOCBmZmZmZmZmZjgxMGIyN2RiClsg
ICAxMy4zNzA1NjRdIENhbGwgVHJhY2U6ClsgICAxMy4zNzA1NjRdICBbPGZmZmZmZmZmODFl
MzcwOWE+XSA/IHZpc29yY2hhbm5lbF9pbml0KzB4MWQvMHgxZApbICAgMTMuMzcwNTY0XSAg
WzxmZmZmZmZmZjgxMDAwMmIyPl0gZG9fb25lX2luaXRjYWxsKzB4OGUvMHgxMzgKWyAgIDEz
LjM3MDU2NF0gIFs8ZmZmZmZmZmY4MTBiMjYwMD5dID8gcGFyYW1fYXJyYXlfc2V0KzB4ZWYv
MHhmNQpbICAgMTMuMzcwNTY0XSAgWzxmZmZmZmZmZjgxMGIyN2RiPl0gPyBwYXJzZV9hcmdz
KzB4MTgwLzB4MjQ4ClsgICAxMy4zNzA1NjRdICBbPGZmZmZmZmZmODFkZmJmODY+XSBrZXJu
ZWxfaW5pdF9mcmVlYWJsZSsweDEwOC8weDE5OQpbICAgMTMuMzcwNTY0XSAgWzxmZmZmZmZm
ZjgxZGZiNzNhPl0gPyBkb19lYXJseV9wYXJhbSsweDhhLzB4OGEKWyAgIDEzLjM3MDU2NF0g
IFs8ZmZmZmZmZmY4MTczZjA4ZT5dID8gcmVzdF9pbml0KzB4YzIvMHhjMgpbICAgMTMuMzcw
NTY0XSAgWzxmZmZmZmZmZjgxNzNmMDk3Pl0ga2VybmVsX2luaXQrMHg5LzB4ZGEKWyAgIDEz
LjM3MDU2NF0gIFs8ZmZmZmZmZmY4MTc2MDI0Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIw
ClsgICAxMy4zNzA1NjRdICBbPGZmZmZmZmZmODE3M2YwOGU+XSA/IHJlc3RfaW5pdCsweGMy
LzB4YzIKWyAgIDEzLjM3MDU2NF0gQ29kZTogOGQgNjUgY2MgNGMgOGQgNmQgZDAgNGMgOGQg
NzUgZDQgNzkgMjEgNDggYmEgMDAgMDAgMDAgMDAgNzUgYmEgMGEgYTcgNDggYjkgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgNDAgYmIgMDQgMDAgMDAgMDAgYjggMGIgMDcgMDAgMDAgPDBmPiAw
MSBjMSA4YiAzNSBjMiBjNCBiNCAwMCA0OCBjNyBjNyBmNSA5MyBiNCA4MSAzMSBjMCBlOCAz
YiAyMSAKWyAgIDEzLjM3MDU2NF0gUklQICBbPGZmZmZmZmZmODFlMzcxMTU+XSB2aXNvcmNo
aXBzZXRfaW5pdCsweDdiLzB4OGM1ClsgICAxMy4zNzA1NjRdICBSU1AgPGZmZmY4ODAwMTI5
N2RlNTg+ClsgICAxMy40MDUwMDRdIC0tLVsgZW5kIHRyYWNlIGMzYzJhYTVjODUyN2RmYTAg
XS0tLQpbICAgMTMuNDA1NzMyXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwg
ZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLzdiMmEy
ZDgzODNkMDg3OTNhYWMzZjE1N2ZhM2YzOGVhOTBjNWQzYzAvZG1lc2cteW9jdG8tZjMtMTA0
OjIwMTQwNDA3MTc1MzQyOng4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAt
cmM1LTAwNjIyLWc3YjJhMmQ4OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQw
NTA3MDIvN2IyYTJkODM4M2QwODc5M2FhYzNmMTU3ZmEzZjM4ZWE5MGM1ZDNjMC9kbWVzZy15
b2N0by1mMy03MToyMDE0MDQwNzE3NTMzNzp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3
MDI6My4xNC4wLXJjNS0wMDYyMi1nN2IyYTJkODoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYnIwLTA0MDUwNzAyLzdiMmEyZDgzODNkMDg3OTNhYWMzZjE1N2ZhM2YzOGVhOTBjNWQz
YzAvZG1lc2ctcXVhbnRhbC1mMy0zODoyMDE0MDQwNzE3NTM1MDp4ODZfNjQtcmFuZGNvbmZp
Zy1icjAtMDQwNTA3MDI6My4xNC4wLXJjNS0wMDYyMi1nN2IyYTJkODoxCjA6MzoyIGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzlkOWJhYWRkNDA2OWM3N2E5N2Jm
NTMwYWJhZDlkZGI3NDg3NWZlNzZdIHN0YWdpbmc6IHZpc29ydXRpbCBkcml2ZXIgdG8gcHJv
dmlkZSBjb21tb24gZnVuY3Rpb25hbGl0eSB0byBvdGhlciBzLVBhciBkcml2ZXJzCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVs
LXRlc3RzL2xpbnV4OC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvbmV4dDptYXN0ZXI6OWQ5YmFh
ZGQ0MDY5Yzc3YTk3YmY1MzBhYmFkOWRkYjc0ODc1ZmU3NjpiaXNlY3QtbGludXg4CgoyMDE0
LTA0LTA3LTE3OjUzOjU1IDlkOWJhYWRkNDA2OWM3N2E5N2JmNTMwYWJhZDlkZGI3NDg3NWZl
NzYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLTlkOWJhYWRkNDA2OWM3N2E5
N2JmNTMwYWJhZDlkZGI3NDg3NWZlNzYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi85ZDliYWFkZDQwNjljNzdhOTdiZjUzMGFi
YWQ5ZGRiNzQ4NzVmZTc2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItOWQ5YmFhZGQ0
MDY5Yzc3YTk3YmY1MzBhYmFkOWRkYjc0ODc1ZmU3Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWJyMC0w
NDA1MDcwMi05ZDliYWFkZDQwNjljNzdhOTdiZjUzMGFiYWQ5ZGRiNzQ4NzVmZTc2Cmtlcm5l
bDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvOWQ5YmFhZGQ0MDY5
Yzc3YTk3YmY1MzBhYmFkOWRkYjc0ODc1ZmU3Ni92bWxpbnV6LTMuMTQuMC1yYzUtMDA2MTkt
ZzlkOWJhYWQKCjIwMTQtMDQtMDctMTg6MDA6NTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4J
MgkxNwkyNwkzMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzEyZTM2NGI5ZjA4YWEzMzVkYzc3MTZj
ZTc0MTEzZTgzNGM5OTM3NjVdIHN0YWdpbmc6IHZpc29yY2hpcHNldCBkcml2ZXIgdG8gcHJv
dmlkZSByZWdpc3RyYXRpb24gYW5kIG90aGVyIHNlcnZpY2VzCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4
OC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvbmV4dDptYXN0ZXI6MTJlMzY0YjlmMDhhYTMzNWRj
NzcxNmNlNzQxMTNlODM0Yzk5Mzc2NTpiaXNlY3QtbGludXg4CgoyMDE0LTA0LTA3LTE4OjAz
OjU2IDEyZTM2NGI5ZjA4YWEzMzVkYzc3MTZjZTc0MTEzZTgzNGM5OTM3NjUgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLTEyZTM2NGI5ZjA4YWEzMzVkYzc3MTZjZTc0MTEz
ZTgzNGM5OTM3NjUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWJyMC0wNDA1MDcwMi8xMmUzNjRiOWYwOGFhMzM1ZGM3NzE2Y2U3NDExM2U4MzRjOTkz
NzY1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItMTJlMzY0YjlmMDhhYTMzNWRjNzcx
NmNlNzQxMTNlODM0Yzk5Mzc2NQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi0xMmUz
NjRiOWYwOGFhMzM1ZGM3NzE2Y2U3NDExM2U4MzRjOTkzNzY1Cmtlcm5lbDogL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvMTJlMzY0YjlmMDhhYTMzNWRjNzcxNmNl
NzQxMTNlODM0Yzk5Mzc2NS92bWxpbnV6LTMuMTQuMC1yYzUtMDA2MjEtZzEyZTM2NGIKCjIw
MTQtMDQtMDctMTg6MTg6NTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4J
MS4JMgkzCTcgVEVTVCBGQUlMVVJFCkJVRzoga2VybmVsIGVhcmx5IGhhbmcgd2l0aG91dCBh
bnkgcHJpbnRrIG91dHB1dApDb21tYW5kIGxpbmU6IGh1bmdfdGFza19wYW5pYz0xIGVhcmx5
cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFi
bGVkIHJjdXBkYXRlLnJjdV9jcHVfc3RhbGxfdGltZW91dD0xMDAgcGFuaWM9MTAgc29mdGxv
Y2t1cF9wYW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyAgcHJvbXB0X3JhbWRpc2s9MCBjb25z
b2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0vZGV2L3Jh
bTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctYnIwLTA0MDUwNzAyL25leHQ6bWFzdGVyOjEyZTM2NGI5ZjA4YWEzMzVkYzc3MTZjZTc0
MTEzZTgzNGM5OTM3NjU6YmlzZWN0LWxpbnV4OC8udm1saW51ei0xMmUzNjRiOWYwOGFhMzM1
ZGM3NzE2Y2U3NDExM2U4MzRjOTkzNzY1LTIwMTQwNDA3MTgxODA2LTE3LWpha2V0b3duIGJy
YW5jaD1uZXh0L21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YnIwLTA0MDUwNzAyLzEyZTM2NGI5ZjA4YWEzMzVkYzc3MTZjZTc0MTEzZTgzNGM5OTM3NjUv
dm1saW51ei0zLjE0LjAtcmM1LTAwNjIxLWcxMmUzNjRiIGRyYmQubWlub3JfY291bnQ9OApF
YXJseSBoYW5nIGtlcm5lbDogdm1saW51ei0zLjE0LjAtcmM1LTAwNjIxLWcxMmUzNjRiICAj
CkVsYXBzZWQgdGltZTogMzUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3
MDIvMTJlMzY0YjlmMDhhYTMzNWRjNzcxNmNlNzQxMTNlODM0Yzk5Mzc2NS9kbWVzZy15b2N0
by1mNC04MToyMDE0MDQwNzE4MjgxODp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6
My4xNC4wLXJjNS0wMDYyMS1nMTJlMzY0YjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YnIwLTA0MDUwNzAyLzEyZTM2NGI5ZjA4YWEzMzVkYzc3MTZjZTc0MTEzZTgzNGM5OTM3NjUv
ZG1lc2cteW9jdG8tZjQtOTc6MjAxNDA0MDcxODI4MTc6eDg2XzY0LXJhbmRjb25maWctYnIw
LTA0MDUwNzAyOjMuMTQuMC1yYzUtMDA2MjEtZzEyZTM2NGI6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWJyMC0wNDA1MDcwMi8xMmUzNjRiOWYwOGFhMzM1ZGM3NzE2Y2U3NDExM2U4
MzRjOTkzNzY1L2RtZXNnLXlvY3RvLWY0LTg1OjIwMTQwNDA3MTgyODI0Ong4Nl82NC1yYW5k
Y29uZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAtcmM1LTAwNjIxLWcxMmUzNjRiOjEKMDozOjEw
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA0LTA3IDE4OjI4OjI3
IFJFUEVBVCBDT1VOVDogNDMgICMgL2tlcm5lbC10ZXN0cy9saW51eDgvb2JqLWJpc2VjdC8u
cmVwZWF0G1swbQoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbZTQyMzgxMmE5ZTQzMDkxM2U0MWM2NTY1OTIyMTQy
ZmUyMmY4M2FkN10gc3RhZ2luZzogdmlzb3JjaGFubmVsIG1vZHVsZQpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9s
aW51eDgvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL25leHQ6bWFzdGVyOmU0MjM4MTJhOWU0MzA5
MTNlNDFjNjU2NTkyMjE0MmZlMjJmODNhZDc6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNC0wNy0x
ODoyODoyOCBlNDIzODEyYTllNDMwOTEzZTQxYzY1NjU5MjIxNDJmZTIyZjgzYWQ3IGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi1lNDIzODEyYTllNDMwOTEzZTQxYzY1NjU5
MjIxNDJmZTIyZjgzYWQ3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1icjAtMDQwNTA3MDIvZTQyMzgxMmE5ZTQzMDkxM2U0MWM2NTY1OTIyMTQyZmUy
MmY4M2FkNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLWU0MjM4MTJhOWU0MzA5MTNl
NDFjNjU2NTkyMjE0MmZlMjJmODNhZDcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIt
ZTQyMzgxMmE5ZTQzMDkxM2U0MWM2NTY1OTIyMTQyZmUyMmY4M2FkNwprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL2U0MjM4MTJhOWU0MzA5MTNlNDFj
NjU2NTkyMjE0MmZlMjJmODNhZDcvdm1saW51ei0zLjE0LjAtcmM1LTAwNjIwLWdlNDIzODEy
CgoyMDE0LTA0LTA3LTE4OjMxOjI4IGRldGVjdGluZyBib290IHN0YXRlIC4JNQkxNAkyMC4J
MjcJNDMgU1VDQ0VTUwoKMTJlMzY0YjlmMDhhYTMzNWRjNzcxNmNlNzQxMTNlODM0Yzk5Mzc2
NSBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgMTJlMzY0YjlmMDhhYTMzNWRjNzcx
NmNlNzQxMTNlODM0Yzk5Mzc2NQpBdXRob3I6IEtlbiBDb3ggPGprY0ByZWRoYXQuY29tPgpE
YXRlOiAgIFR1ZSBNYXIgNCAwNzo1ODowNyAyMDE0IC0wNjAwCgogICAgc3RhZ2luZzogdmlz
b3JjaGlwc2V0IGRyaXZlciB0byBwcm92aWRlIHJlZ2lzdHJhdGlvbiBhbmQgb3RoZXIgc2Vy
dmljZXMKICAgIAogICAgVGhlIHZpc29yY2hpcHNldCBtb2R1bGUgcmVjZWl2ZXMgZGV2aWNl
IGNyZWF0aW9uIGFuZCBkZXN0cnVjdGlvbgogICAgZXZlbnRzIGZyb20gdGhlIENvbW1hbmQg
c2VydmljZSBwYXJ0aXRpb24gb2Ygcy1QYXIsIGFzIHdlbGwgYXMKICAgIGNvbnRyb2xsaW5n
IHJlZ2lzdHJhdGlvbiBvZiBzaGFyZWQgZGV2aWNlIGRyaXZlcnMgd2l0aCB0aGUgcy1QYXIK
ICAgIGRyaXZlciBjb3JlLiBUaGUgZXZlbnRzIHJlY2VpdmVkIGFyZSB1c2VkIHRvIHBvcHVs
YXRlIG90aGVyIHMtUGFyCiAgICBtb2R1bGVzIHdpdGggdGhlaXIgYXNzaWduZWQgc2hhcmVk
IGRldmljZXMuIFZpc29yY2hpcHNldCBpcyByZXF1aXJlZAogICAgZm9yIHNoYXJlZCBkZXZp
Y2UgZHJpdmVycyB0byBmdW5jdGlvbiBwcm9wZXJseS4gVmlzb3JjaGlwc2V0IGFsc28KICAg
IHN0b3JlcyBpbmZvcm1hdGlvbiBmb3IgaGFuZGxpbmcgZHVtcCBkaXNrIGRldmljZSBjcmVh
dGlvbiBkdXJpbmcKICAgIGtkdW1wLgogICAgCiAgICBJbiBvcGVyYXRpb24sIHRoZSB2aXNv
cmNoaXBzZXQgbW9kdWxlIHByb2Nlc3NlcyBkZXZpY2UgY3JlYXRpb24gYW5kCiAgICBkZXN0
cnVjdGlvbiBtZXNzYWdlcyBzZW50IGJ5IHMtUGFyJ3MgQ29tbWFuZCBzZXJ2aWNlIHBhcnRp
dGlvbiB0aHJvdWdoCiAgICBhIGNoYW5uZWwuIFRoZXNlIG1lc3NhZ2VzIHJlc3VsdCBpbiBj
cmVhdGlvbiAob3IgZGVzdHJ1Y3Rpb24pIG9mIGVhY2gKICAgIHZpcnR1YWwgYnVzIGFuZCB2
aXJ0dWFsIGRldmljZS4gRWFjaCBidXMgYW5kIGRldmljZSBpcyBhbHNvIGFzc29jaWF0ZWQK
ICAgIHdpdGggYSBjb21tdW5pY2F0aW9uIGNoYW5uZWwsIHdoaWNoIGlzIHVzZWQgdG8gY29t
bXVuaWNhdGUgd2l0aCBvbmUgb3IKICAgIG1vcmUgSU8gc2VydmljZSBwYXJ0aXRpb25zIHRv
IHBlcmZvcm0gZGV2aWNlIElPIG9uIGJlaGFsZiBvZiB0aGUKICAgIGd1ZXN0LgogICAgCiAg
ICBTaWduZWQtb2ZmLWJ5OiBLZW4gQ294IDxqa2NAcmVkaGF0LmNvbT4KICAgIENjOiBCZW4g
Um9tZXIgPHNwYXJtYWludGFpbmVyQHVuaXN5cy5jb20+CiAgICBTaWduZWQtb2ZmLWJ5OiBH
cmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPgoKOjA0MDAw
MCAwNDAwMDAgMGIyOTc2MDI5ZDRjYjRkZjQwMmViZjgwYTI0ZTBkOTAzZWM3MmRlYiA0MTUy
NDIwNWYyNGZmYzIzYTk4MzgwNWNlYzMxZDU5OWQ0ZmRkODY2IE0JZHJpdmVycwpiaXNlY3Qg
cnVuIHN1Y2Nlc3MKSEVBRCBpcyBub3cgYXQgZTQyMzgxMi4uLiBzdGFnaW5nOiB2aXNvcmNo
YW5uZWwgbW9kdWxlCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvbmV4dDptYXN0ZXI6ZTQyMzgxMmE5ZTQzMDkxM2U0
MWM2NTY1OTIyMTQyZmUyMmY4M2FkNzpiaXNlY3QtbGludXg4CgoyMDE0LTA0LTA3LTE4OjM0
OjU5IGU0MjM4MTJhOWU0MzA5MTNlNDFjNjU2NTkyMjE0MmZlMjJmODNhZDcgcmV1c2UgL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvZTQyMzgxMmE5ZTQzMDkxM2U0
MWM2NTY1OTIyMTQyZmUyMmY4M2FkNy92bWxpbnV6LTMuMTQuMC1yYzUtMDA2MjAtZ2U0MjM4
MTIKCjIwMTQtMDQtMDctMTg6MzQ6NTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JNDQJNTAJ
NzcJMTAxCTEyMwkxMjYJMTI5IFNVQ0NFU1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IGU0MjM4MTIuLi4gc3RhZ2luZzogdmlzb3JjaGFubmVsIG1vZHVsZQpIRUFEIGlzIG5vdyBh
dCA0YjIyZWZkLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDQw
MwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
YnIwLTA0MDUwNzAyL25leHQ6bWFzdGVyOjRiMjJlZmRkNTU5NWYwYWNiNDhmMDJiZjY2NGE0
NTFlZTk4ZjlhMmU6YmlzZWN0LWxpbnV4OAogVEVTVCBGQUlMVVJFClsgICAzMS42Mzc3NjRd
IEZQR0EgaW1hZ2UgZmlsZSBuYW1lOiB4bGlueF9mcGdhX2Zpcm13YXJlLmJpdApbICAgMzEu
NjQyNDc2XSBHUElPIElOSVQgRkFJTCEhClsgICAzMS42NDQ1NzFdIGRyaXZlciB2ZXJzaW9u
IDEuMC4wLjAgbG9hZGVkClsgICAzMS42NDYyNzZdIGNoaXBzZXQgZHJpdmVyIHZlcnNpb24g
MS4wLjAuMCBsb2FkZWRpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIFBSRUVNUFQgU01QIApb
ICAgMzEuNjQ4OTczXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDMxLjY0ODk3M10gQ1BVOiAw
IFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLW5leHQtMjAxNDA0
MDMgIzI0ClsgICAzMS42NDg5NzNdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9T
IEJvY2hzIDAxLzAxLzIwMTEKWyAgIDMxLjY0ODk3M10gdGFzazogZmZmZjg4MDAxMTU3MDAx
MCB0aTogZmZmZjg4MDAxMTU3MjAwMCB0YXNrLnRpOiBmZmZmODgwMDExNTcyMDAwClsgICAz
MS42NDg5NzNdIFJJUDogMDAxMDpbPGZmZmZmZmZmODFlNDJhZTk+XSAgWzxmZmZmZmZmZjgx
ZTQyYWU5Pl0gdmlzb3JjaGlwc2V0X2luaXQrMHg3Yi8weDg5MgpbICAgMzEuNjQ4OTczXSBS
U1A6IDAwMDA6ZmZmZjg4MDAxMTU3M2U1OCAgRUZMQUdTOiAwMDAwMDI4NgpbICAgMzEuNjQ4
OTczXSBSQVg6IDAwMDAwMDAwMDAwMDA3MGIgUkJYOiAwMDAwMDAwMDAwMDAwMDA0IFJDWDog
NDAwMDAwMDAwMDAwMDAwMApbICAgMzEuNjQ4OTczXSBSRFg6IGE3MGFiYTdlMDAwMDAwMDAg
UlNJOiBmZmZmODgwMDExNTczZTVjIFJESTogZmZmZjg4MDAxMTU3M2U1OApbICAgMzEuNjQ4
OTczXSBSQlA6IGZmZmY4ODAwMTE1NzNlOTAgUjA4OiAwMDAwMDAwMDAwMDAwMDAxIFIwOTog
ZmZmZjg4MDAxMTU3M2U2MApbICAgMzEuNjQ4OTczXSBSMTA6IGZmZmY4ODAwMTE1NzNlNjQg
UjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogZmZmZjg4MDAxMTU3M2U1YwpbICAgMzEuNjQ4
OTczXSBSMTM6IGZmZmY4ODAwMTE1NzNlNjAgUjE0OiBmZmZmODgwMDExNTczZTY0IFIxNTog
MDAwMDAwMDAwMDAwMDAwMApbICAgMzEuNjQ4OTczXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAo
MDAwMCkgR1M6ZmZmZjg4MDAxMjYwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAw
ClsgICAzMS42NDg5NzNdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAw
MDAwODAwNTAwM2IKWyAgIDMxLjY0ODk3M10gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzog
MDAwMDAwMDAwMWMwYTAwMCBDUjQ6IDAwMDAwMDAwMDAzMDA2ZjAKWyAgIDMxLjY0ODk3M10g
RFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgIDMxLjY0ODk3M10gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjog
MDAwMDAwMDAwMDAwMDAwMCBEUjc6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDMxLjY0ODk3M10g
U3RhY2s6ClsgICAzMS42NDg5NzNdICAwMDAwMDgwMDAwMDMwNmMxIDA3OGJmYmY5ODJkODIy
MDMgZmZmZmZmZmY4MWU0MmE2ZSAwMDAwMDAwMDAwMDAwMDAwClsgICAzMS42NDg5NzNdICAw
MDAwMDAwMDAwMDAwMWU5IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZm
ODgwMDExNTczZjA4ClsgICAzMS42NDg5NzNdICBmZmZmZmZmZjgxMDAwMmIyIDAwMDAwMDAw
MDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAxMDAwClsgICAzMS42NDg5
NzNdIENhbGwgVHJhY2U6ClsgICAzMS42NDg5NzNdICBbPGZmZmZmZmZmODFlNDJhNmU+XSA/
IHZpc29yY2hhbm5lbF9pbml0KzB4MWQvMHgxZApbICAgMzEuNjQ4OTczXSAgWzxmZmZmZmZm
ZjgxMDAwMmIyPl0gZG9fb25lX2luaXRjYWxsKzB4OGUvMHgxMzgKWyAgIDMxLjY0ODk3M10g
IFs8ZmZmZmZmZmY4MWUwNmY5MD5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTA4LzB4MTk5
ClsgICAzMS42NDg5NzNdICBbPGZmZmZmZmZmODFlMDY3NDQ+XSA/IGRvX2Vhcmx5X3BhcmFt
KzB4OGEvMHg4YQpbICAgMzEuNjQ4OTczXSAgWzxmZmZmZmZmZjgxNzUwNWNiPl0gPyByZXN0
X2luaXQrMHhiZi8weGJmClsgICAzMS42NDg5NzNdICBbPGZmZmZmZmZmODE3NTA1ZDQ+XSBr
ZXJuZWxfaW5pdCsweDkvMHhkYQpbICAgMzEuNjQ4OTczXSAgWzxmZmZmZmZmZjgxNzcxYjBj
Pl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgIDMxLjY0ODk3M10gIFs8ZmZmZmZmZmY4
MTc1MDVjYj5dID8gcmVzdF9pbml0KzB4YmYvMHhiZgpbICAgMzEuNjQ4OTczXSBDb2RlOiA4
ZCA2NSBjYyA0YyA4ZCA2ZCBkMCA0YyA4ZCA3NSBkNCA3OSAyMSA0OCBiYSAwMCAwMCAwMCAw
MCA3ZSBiYSAwYSBhNyA0OCBiOSAwMCAwMCAwMCAwMCAwMCAwMCAwMCA0MCBiYiAwNCAwMCAw
MCAwMCBiOCAwYiAwNyAwMCAwMCA8MGY+IDAxIGMxIDhiIDM1IGZlIGNkIGI0IDAwIDQ4IGM3
IGM3IDZiIDJhIGI1IDgxIDMxIGMwIGU4IDhjIDdkIApbICAgMzEuNjQ4OTczXSBSSVAgIFs8
ZmZmZmZmZmY4MWU0MmFlOT5dIHZpc29yY2hpcHNldF9pbml0KzB4N2IvMHg4OTIKWyAgIDMx
LjY0ODk3M10gIFJTUCA8ZmZmZjg4MDAxMTU3M2U1OD4KWyAgIDMxLjY5ODQyMV0gLS0tWyBl
bmQgdHJhY2UgYmU1MmVhZDI3ZGJjNDA2NCBdLS0tClsgICAzMS42OTk2OTZdIEtlcm5lbCBw
YW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1icjAtMDQwNTA3MDIvNGIyMmVmZGQ1NTk1ZjBhY2I0OGYwMmJmNjY0YTQ1MWVl
OThmOWEyZS9kbWVzZy1xdWFudGFsLWYzLTEwNjoyMDE0MDQwNTA3MDQxMTp4ODZfNjQtcmFu
ZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLW5leHQtMjAxNDA0MDM6MjQKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvNGIyMmVmZGQ1NTk1ZjBhY2I0OGYwMmJm
NjY0YTQ1MWVlOThmOWEyZS9kbWVzZy1xdWFudGFsLWYzLTEwNToyMDE0MDQwNTA3MDQxMjp4
ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLW5leHQtMjAxNDA0MDM6MjQK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvNGIyMmVmZGQ1NTk1ZjBh
Y2I0OGYwMmJmNjY0YTQ1MWVlOThmOWEyZS9kbWVzZy1xdWFudGFsLWYzLTE3OjIwMTQwNDA1
MDcwNDE2Ong4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAtbmV4dC0yMDE0
MDQwMzoyNAowOjM6NyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cg
YXQgNGIyMmVmZCBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA0MDMK
Cj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3
YXMgNGIyMmVmZC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA0
MDMKSEVBRCBpcyBub3cgYXQgMThhMWE3YS4uLiBNZXJnZSBnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvY21ldGNhbGYvbGludXgtdGlsZQpscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUw
NzAyL2xpbnVzOm1hc3RlcjoxOGExYTdhMWQ4NjJhZTA3OTRhMDE3OTQ3M2QwOGE0MTRkZDQ5
MjM0OmJpc2VjdC1saW51eDgKCjIwMTQtMDQtMDctMTg6NDA6MTQgMThhMWE3YTFkODYyYWUw
Nzk0YTAxNzk0NzNkMDhhNDE0ZGQ0OTIzNCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQw
NTA3MDItMThhMWE3YTFkODYyYWUwNzk0YTAxNzk0NzNkMDhhNDE0ZGQ0OTIzNApDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLzE4
YTFhN2ExZDg2MmFlMDc5NGEwMTc5NDczZDA4YTQxNGRkNDkyMzQKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LWJyMC0wNDA1MDcwMi0xOGExYTdhMWQ4NjJhZTA3OTRhMDE3OTQ3M2QwOGE0MTRkZDQ5MjM0
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8u
eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLTE4YTFhN2ExZDg2MmFlMDc5NGEwMTc5
NDczZDA4YTQxNGRkNDkyMzQKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJy
MC0wNDA1MDcwMi8xOGExYTdhMWQ4NjJhZTA3OTRhMDE3OTQ3M2QwOGE0MTRkZDQ5MjM0L3Zt
bGludXotMy4xNC4wLTEwMzEyLWcxOGExYTdhCgoyMDE0LTA0LTA3LTE4OjQ0OjE0IGRldGVj
dGluZyBib290IHN0YXRlIC4uIFRFU1QgRkFJTFVSRQpbICAgMTQuMTE1NTkyXSBGUEdBIGlt
YWdlIGZpbGUgbmFtZTogeGxpbnhfZnBnYV9maXJtd2FyZS5iaXQKWyAgIDE0LjExODU1N10g
R1BJTyBJTklUIEZBSUwhIQpbICAgMTQuMTE5ODcxXSBkcml2ZXIgdmVyc2lvbiAxLjAuMC4w
IGxvYWRlZApbICAgMTQuMTIwNjE1XSBjaGlwc2V0IGRyaXZlciB2ZXJzaW9uIDEuMC4wLjAg
bG9hZGVkaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUCAKWyAgIDE0LjEy
MzAzNV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAxNC4xMjM4NDBdIENQVTogMSBQSUQ6IDEg
Q29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTQuMC0xMDMxMi1nMThhMWE3YSAjMQpb
ICAgMTQuMTI1MTIxXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAw
MS8wMS8yMDExClsgICAxNC4xMjUxMjFdIHRhc2s6IGZmZmY4ODAwMTI5NzAwMTAgdGk6IGZm
ZmY4ODAwMTI5NzIwMDAgdGFzay50aTogZmZmZjg4MDAxMjk3MjAwMApbICAgMTQuMTI3NDY5
XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxZTQwOGQyPl0gIFs8ZmZmZmZmZmY4MWU0MDhkMj5d
IHZpc29yY2hpcHNldF9pbml0KzB4N2IvMHg4OTIKWyAgIDE0LjEyNzQ2OV0gUlNQOiAwMDAw
OmZmZmY4ODAwMTI5NzNlNTggIEVGTEFHUzogMDAwMDAyODYKWyAgIDE0LjEyNzQ2OV0gUkFY
OiAwMDAwMDAwMDAwMDAwNzBiIFJCWDogMDAwMDAwMDAwMDAwMDAwNCBSQ1g6IDQwMDAwMDAw
MDAwMDAwMDAKWyAgIDE0LjEyNzQ2OV0gUkRYOiBhNzBhYmE3ZTAwMDAwMDAwIFJTSTogZmZm
Zjg4MDAxMjk3M2U1YyBSREk6IGZmZmY4ODAwMTI5NzNlNTgKWyAgIDE0LjEyNzQ2OV0gUkJQ
OiBmZmZmODgwMDEyOTczZTkwIFIwODogMDAwMDAwMDAwMDAwMDAwMSBSMDk6IGZmZmY4ODAw
MTI5NzNlNjAKWyAgIDE0LjEyNzQ2OV0gUjEwOiBmZmZmODgwMDEyOTczZTY0IFIxMTogMDAw
MDAwMDAwMDAwMDAwMCBSMTI6IGZmZmY4ODAwMTI5NzNlNWMKWyAgIDE0LjEyNzQ2OV0gUjEz
OiBmZmZmODgwMDEyOTczZTYwIFIxNDogZmZmZjg4MDAxMjk3M2U2NCBSMTU6IDAwMDAwMDAw
MDAwMDAwMDAKWyAgIDE0LjEyNzQ2OV0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdT
OmZmZmY4ODAwMTNiMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgMTQu
MTI3NDY5XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUw
MDNiClsgICAxNC4xMjc0NjldIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAw
MDFjMGEwMDAgQ1I0OiAwMDAwMDAwMDAwMzAwNmUwClsgICAxNC4xMjc0NjldIERSMDogMDAw
MDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAw
MDAwClsgICAxNC4xNDA4NzhdIERSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAw
MDAwMDAwMDAgRFI3OiAwMDAwMDAwMDAwMDAwMDAwClsgICAxNC4xNDA4NzhdIFN0YWNrOgpb
ICAgMTQuMTQwODc4XSAgMDEwMDA4MDAwMDAzMDZjMSAwNzhiZmJmOTgyZDgyMjAzIGZmZmZm
ZmZmODFlNDA4NTcgMDAwMDAwMDAwMDAwMDAwMApbICAgMTQuMTQwODc4XSAgMDAwMDAwMDAw
MDAwMDFlOCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjk3
M2YwOApbICAgMTQuMTQwODc4XSAgZmZmZmZmZmY4MTAwMDJiMiBmZmZmZmZmZjgxMGIyYjAw
IGZmZmY4ODAwMTI5NzNmMDggZmZmZmZmZmY4MTBiMmNmMwpbICAgMTQuMTQwODc4XSBDYWxs
IFRyYWNlOgpbICAgMTQuMTQwODc4XSAgWzxmZmZmZmZmZjgxZTQwODU3Pl0gPyB2aXNvcmNo
YW5uZWxfaW5pdCsweDFkLzB4MWQKWyAgIDE0LjE0MDg3OF0gIFs8ZmZmZmZmZmY4MTAwMDJi
Mj5dIGRvX29uZV9pbml0Y2FsbCsweDhlLzB4MTM4ClsgICAxNC4xNDA4NzhdICBbPGZmZmZm
ZmZmODEwYjJiMDA+XSA/IHBhcmFtX2FycmF5X3NldCsweGQ3LzB4ZjUKWyAgIDE0LjE0MDg3
OF0gIFs8ZmZmZmZmZmY4MTBiMmNmMz5dID8gcGFyc2VfYXJncysweDE4MC8weDI0OApbICAg
MTQuMTQwODc4XSAgWzxmZmZmZmZmZjgxZTA0ZjkwPl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHgxMDgvMHgxOTkKWyAgIDE0LjE0MDg3OF0gIFs8ZmZmZmZmZmY4MWUwNDc0ND5dID8gZG9f
ZWFybHlfcGFyYW0rMHg4YS8weDhhClsgICAxNC4xNDA4NzhdICBbPGZmZmZmZmZmODE3NGRj
OGI+XSA/IHJlc3RfaW5pdCsweGJmLzB4YmYKWyAgIDE0LjE0MDg3OF0gIFs8ZmZmZmZmZmY4
MTc0ZGM5ND5dIGtlcm5lbF9pbml0KzB4OS8weGRhClsgICAxNC4xNDA4NzhdICBbPGZmZmZm
ZmZmODE3NmYxOGM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgMTQuMTQwODc4XSAg
WzxmZmZmZmZmZjgxNzRkYzhiPl0gPyByZXN0X2luaXQrMHhiZi8weGJmClsgICAxNC4xNDA4
NzhdIENvZGU6IDhkIDY1IGNjIDRjIDhkIDZkIGQwIDRjIDhkIDc1IGQ0IDc5IDIxIDQ4IGJh
IDAwIDAwIDAwIDAwIDdlIGJhIDBhIGE3IDQ4IGI5IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDQw
IGJiIDA0IDAwIDAwIDAwIGI4IDBiIDA3IDAwIDAwIDwwZj4gMDEgYzEgOGIgMzUgYjUgY2Yg
YjQgMDAgNDggYzcgYzcgYWMgMGIgYjUgODEgMzEgYzAgZTggMDEgNzYgClsgICAxNC4xNDA4
NzhdIFJJUCAgWzxmZmZmZmZmZjgxZTQwOGQyPl0gdmlzb3JjaGlwc2V0X2luaXQrMHg3Yi8w
eDg5MgpbICAgMTQuMTQwODc4XSAgUlNQIDxmZmZmODgwMDEyOTczZTU4PgpbICAgMTQuMTY5
MzgwXSB2aGNpX2hjZDogdmhjaV9odWJfY29udHJvbDoyNDQ6IHR5cGVSZXEgYTMwMCB3VmFs
dWUgMCB3SW5kZXggMQpbICAgMTQuMTcwNjI3XSB2aGNpX2hjZDogdmhjaV9odWJfY29udHJv
bDozMTA6ICBHZXRQb3J0U3RhdHVzIHBvcnQgMQpbICAgMTQuMTcwODgwXSAtLS1bIGVuZCB0
cmFjZSBkZWMzNzgzNTUyYzc1ZTZmIF0tLS0KWyAgIDE0LjE3MTA3MV0gS2VybmVsIHBhbmlj
IC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWJyMC0wNDA1MDcwMi8xOGExYTdhMWQ4NjJhZTA3OTRhMDE3OTQ3M2QwOGE0MTRkZDQ5
MjM0L2RtZXNnLXlvY3RvLWYzLTc5OjIwMTQwNDA3MTg0NTA3Ong4Nl82NC1yYW5kY29uZmln
LWJyMC0wNDA1MDcwMjozLjE0LjAtMTAzMTItZzE4YTFhN2E6MQowOjE6MSBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpQcmV2
aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAxOGExYTdhLi4uIE1lcmdlIGdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9jbWV0Y2FsZi9saW51eC10aWxlCkhF
QUQgaXMgbm93IGF0IGFiZmNkZmQuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMg
Zm9yIDIwMTQwNDA3CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvbmV4dDptYXN0ZXI6YWJmY2RmZDYzZjBiNjg5OTRi
ZjNkMGRlODRkZGI3MjIwZDczYTA2MzpiaXNlY3QtbGludXg4CgoyMDE0LTA0LTA3LTE4OjQ1
OjE4IGFiZmNkZmQ2M2YwYjY4OTk0YmYzZDBkZTg0ZGRiNzIyMGQ3M2EwNjMgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctYnIwLTA0MDUwNzAyLWFiZmNkZmQ2M2YwYjY4OTk0YmYzZDBkZTg0ZGRi
NzIyMGQ3M2EwNjMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWJyMC0wNDA1MDcwMi9hYmZjZGZkNjNmMGI2ODk5NGJmM2QwZGU4NGRkYjcyMjBkNzNh
MDYzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDItYWJmY2RmZDYzZjBiNjg5OTRiZjNk
MGRlODRkZGI3MjIwZDczYTA2Mwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi1hYmZj
ZGZkNjNmMGI2ODk5NGJmM2QwZGU4NGRkYjcyMjBkNzNhMDYzCmtlcm5lbDogL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvYWJmY2RmZDYzZjBiNjg5OTRiZjNkMGRl
ODRkZGI3MjIwZDczYTA2My92bWxpbnV6LTMuMTQuMC1uZXh0LTIwMTQwNDA3CgoyMDE0LTA0
LTA3LTE4OjQ4OjE4IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAy
Ni4wMzc0NTldIEZQR0EgaW1hZ2UgZmlsZSBuYW1lOiB4bGlueF9mcGdhX2Zpcm13YXJlLmJp
dApbICAgMjYuMDQwNTY1XSBHUElPIElOSVQgRkFJTCEhClsgICAyNi4wNDE5NzddIGRyaXZl
ciB2ZXJzaW9uIDEuMC4wLjAgbG9hZGVkClsgICAyNi4wNDI2NjRdIGNoaXBzZXQgZHJpdmVy
IHZlcnNpb24gMS4wLjAuMCBsb2FkZWRpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIFBSRUVN
UFQgU01QIApbICAgMjYuMDQ2MzU3XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDI2LjA0NzQx
Nl0gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLW5l
eHQtMjAxNDA0MDcgIzEKWyAgIDI2LjA0Nzg1MV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9j
aHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMjYuMDQ3ODUxXSB0YXNrOiBmZmZmODgw
MDExNTcwMDEwIHRpOiBmZmZmODgwMDExNTcyMDAwIHRhc2sudGk6IGZmZmY4ODAwMTE1NzIw
MDAKWyAgIDI2LjA0Nzg1MV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MWU0MGExNj5dICBbPGZm
ZmZmZmZmODFlNDBhMTY+XSB2aXNvcmNoaXBzZXRfaW5pdCsweDdiLzB4ODkyClsgICAyNi4w
NTMwNTZdIFJTUDogMDAwMDpmZmZmODgwMDExNTczZTU4ICBFRkxBR1M6IDAwMDAwMjg2Clsg
ICAyNi4wNTMwNTZdIFJBWDogMDAwMDAwMDAwMDAwMDcwYiBSQlg6IDAwMDAwMDAwMDAwMDAw
MDQgUkNYOiA0MDAwMDAwMDAwMDAwMDAwClsgICAyNi4wNTMwNTZdIFJEWDogYTcwYWJhN2Uw
MDAwMDAwMCBSU0k6IGZmZmY4ODAwMTE1NzNlNWMgUkRJOiBmZmZmODgwMDExNTczZTU4Clsg
ICAyNi4wNTMwNTZdIFJCUDogZmZmZjg4MDAxMTU3M2U5MCBSMDg6IDAwMDAwMDAwMDAwMDAw
MDEgUjA5OiBmZmZmODgwMDExNTczZTYwClsgICAyNi4wNTMwNTZdIFIxMDogZmZmZjg4MDAx
MTU3M2U2NCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiBmZmZmODgwMDExNTczZTVjClsg
ICAyNi4wNTMwNTZdIFIxMzogZmZmZjg4MDAxMTU3M2U2MCBSMTQ6IGZmZmY4ODAwMTE1NzNl
NjQgUjE1OiAwMDAwMDAwMDAwMDAwMDAwClsgICAyNi4wNTMwNTZdIEZTOiAgMDAwMDAwMDAw
MDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDEyNzAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAw
MDAwMDAwMDAKWyAgIDI2LjA1MzA1Nl0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENS
MDogMDAwMDAwMDA4MDA1MDAzYgpbICAgMjYuMDUzMDU2XSBDUjI6IDAwMDAwMDAwMDAwMDAw
MDAgQ1IzOiAwMDAwMDAwMDAxYzBhMDAwIENSNDogMDAwMDAwMDAwMDMwMDZlMApbICAgMjYu
MDY2MjE1XSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERS
MjogMDAwMDAwMDAwMDAwMDAwMApbICAgMjYuMDY2MjE1XSBEUjM6IDAwMDAwMDAwMDAwMDAw
MDAgRFI2OiAwMDAwMDAwMDAwMDAwMDAwIERSNzogMDAwMDAwMDAwMDAwMDAwMApbICAgMjYu
MDY2MjE1XSBTdGFjazoKWyAgIDI2LjA2NjIxNV0gIDAxMDAwODAwMDAwMzA2YzEgMDc4YmZi
Zjk4MmQ4MjIwMyBmZmZmZmZmZjgxZTQwOTliIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDI2LjA2
NjIxNV0gIDAwMDAwMDAwMDAwMDAxZTkgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAw
MDAwIGZmZmY4ODAwMTE1NzNmMDgKWyAgIDI2LjA2NjIxNV0gIGZmZmZmZmZmODEwMDAyYjIg
ZmZmZmZmZmY4MTBiMmYwMCBmZmZmODgwMDExNTczZjA4IGZmZmZmZmZmODEwYjMwZGMKWyAg
IDI2LjA2NjIxNV0gQ2FsbCBUcmFjZToKWyAgIDI2LjA2NjIxNV0gIFs8ZmZmZmZmZmY4MWU0
MDk5Yj5dID8gdmlzb3JjaGFubmVsX2luaXQrMHgxZC8weDFkClsgICAyNi4wNjYyMTVdICBb
PGZmZmZmZmZmODEwMDAyYjI+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZS8weDEzOApbICAgMjYu
MDY2MjE1XSAgWzxmZmZmZmZmZjgxMGIyZjAwPl0gPyBwYXJhbV9hcnJheV9zZXQrMHhlZS8w
eGY1ClsgICAyNi4wNjYyMTVdICBbPGZmZmZmZmZmODEwYjMwZGM+XSA/IHBhcnNlX2FyZ3Mr
MHgxODAvMHgyNDgKWyAgIDI2LjA2NjIxNV0gIFs8ZmZmZmZmZmY4MWUwNGY5MD5dIGtlcm5l
bF9pbml0X2ZyZWVhYmxlKzB4MTA4LzB4MTk5ClsgICAyNi4wNjYyMTVdICBbPGZmZmZmZmZm
ODFlMDQ3NDQ+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4OGEvMHg4YQpbICAgMjYuMDY2MjE1XSAg
WzxmZmZmZmZmZjgxNzUwMTBiPl0gPyByZXN0X2luaXQrMHhiZi8weGJmClsgICAyNi4wNjYy
MTVdICBbPGZmZmZmZmZmODE3NTAxMTQ+XSBrZXJuZWxfaW5pdCsweDkvMHhkYQpbICAgMjYu
MDY2MjE1XSAgWzxmZmZmZmZmZjgxNzcxNjRjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAK
WyAgIDI2LjA2NjIxNV0gIFs8ZmZmZmZmZmY4MTc1MDEwYj5dID8gcmVzdF9pbml0KzB4YmYv
MHhiZgpbICAgMjYuMDY2MjE1XSBDb2RlOiA4ZCA2NSBjYyA0YyA4ZCA2ZCBkMCA0YyA4ZCA3
NSBkNCA3OSAyMSA0OCBiYSAwMCAwMCAwMCAwMCA3ZSBiYSAwYSBhNyA0OCBiOSAwMCAwMCAw
MCAwMCAwMCAwMCAwMCA0MCBiYiAwNCAwMCAwMCAwMCBiOCAwYiAwNyAwMCAwMCA8MGY+IDAx
IGMxIDhiIDM1IDgxIGNlIGI0IDAwIDQ4IGM3IGM3IDkxIDFiIGI1IDgxIDMxIGMwIGU4IDcy
IDk5IApbICAgMjYuMDY2MjE1XSBSSVAgIFs8ZmZmZmZmZmY4MWU0MGExNj5dIHZpc29yY2hp
cHNldF9pbml0KzB4N2IvMHg4OTIKWyAgIDI2LjA2NjIxNV0gIFJTUCA8ZmZmZjg4MDAxMTU3
M2U1OD4KWyAgIDI2LjA5OTU3NV0gLS0tWyBlbmQgdHJhY2UgN2U1NjAzMWY4MGY0YWMwMSBd
LS0tClsgICAyNi4wOTk5MjJdIHZoY2lfaGNkOiB2aGNpX2h1Yl9jb250cm9sOjI0NDogdHlw
ZVJlcSBhMzAwIHdWYWx1ZSAwIHdJbmRleCAxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YnIwLTA0MDUwNzAyL2FiZmNkZmQ2M2YwYjY4OTk0YmYzZDBkZTg0ZGRiNzIyMGQ3M2EwNjMv
ZG1lc2cteW9jdG8tZjMtMjc6MjAxNDA0MDcxODQ4MDU6eDg2XzY0LXJhbmRjb25maWctYnIw
LTA0MDUwNzAyOjMuMTQuMC1uZXh0LTIwMTQwNDA3OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1icjAtMDQwNTA3MDIvYWJmY2RmZDYzZjBiNjg5OTRiZjNkMGRlODRkZGI3MjIwZDcz
YTA2My9kbWVzZy15b2N0by1mMy03ODoyMDE0MDQwNzE4NDgwNzp4ODZfNjQtcmFuZGNvbmZp
Zy1icjAtMDQwNTA3MDI6My4xNC4wLW5leHQtMjAxNDA0MDc6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWJyMC0wNDA1MDcwMi9hYmZjZGZkNjNmMGI2ODk5NGJmM2QwZGU4NGRkYjcy
MjBkNzNhMDYzL2RtZXNnLXlvY3RvLWYzLTgxOjIwMTQwNDA3MTg0ODA4Ong4Nl82NC1yYW5k
Y29uZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAtbmV4dC0yMDE0MDQwNzoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL2FiZmNkZmQ2M2YwYjY4OTk0YmYzZDBkZTg0
ZGRiNzIyMGQ3M2EwNjMvZG1lc2cteW9jdG8tZjMtMTAyOjIwMTQwNDA3MTg0ODE1Ong4Nl82
NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAtbmV4dC0yMDE0MDQwNzoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL2FiZmNkZmQ2M2YwYjY4OTk0YmYz
ZDBkZTg0ZGRiNzIyMGQ3M2EwNjMvZG1lc2cteW9jdG8tZjMtMTAzOjIwMTQwNDA3MTg0ODEx
Ong4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAtbmV4dC0yMDE0MDQwNzox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL2FiZmNkZmQ2M2YwYjY4
OTk0YmYzZDBkZTg0ZGRiNzIyMGQ3M2EwNjMvZG1lc2ctcXVhbnRhbC1mMy0xMDk6MjAxNDA0
MDcxODQ4MjA6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyOjMuMTQuMC1uZXh0LTIw
MTQwNDA3OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvYWJmY2Rm
ZDYzZjBiNjg5OTRiZjNkMGRlODRkZGI3MjIwZDczYTA2My9kbWVzZy1xdWFudGFsLWYzLTEx
ODoyMDE0MDQwNzE4NDgyMDp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4w
LW5leHQtMjAxNDA0MDc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcw
Mi9hYmZjZGZkNjNmMGI2ODk5NGJmM2QwZGU4NGRkYjcyMjBkNzNhMDYzL2RtZXNnLXF1YW50
YWwtZjMtNTc6MjAxNDA0MDcxODQ4Mjg6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAy
OjMuMTQuMC1uZXh0LTIwMTQwNDA3OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAt
MDQwNTA3MDIvYWJmY2RmZDYzZjBiNjg5OTRiZjNkMGRlODRkZGI3MjIwZDczYTA2My9kbWVz
Zy1xdWFudGFsLWYzLTk6MjAxNDA0MDcxODQ4MjY6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0
MDUwNzAyOjMuMTQuMC1uZXh0LTIwMTQwNDA3OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1icjAtMDQwNTA3MDIvYWJmY2RmZDYzZjBiNjg5OTRiZjNkMGRlODRkZGI3MjIwZDczYTA2
My9kbWVzZy15b2N0by1mMy0xMjg6MjAxNDA0MDcxODQ4Mjg6eDg2XzY0LXJhbmRjb25maWct
YnIwLTA0MDUwNzAyOjMuMTQuMC1uZXh0LTIwMTQwNDA3OjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1icjAtMDQwNTA3MDIvYWJmY2RmZDYzZjBiNjg5OTRiZjNkMGRlODRkZGI3MjIw
ZDczYTA2My9kbWVzZy15b2N0by1mMy0zODoyMDE0MDQwNzE4NDgyMjp4ODZfNjQtcmFuZGNv
bmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLW5leHQtMjAxNDA0MDc6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi9hYmZjZGZkNjNmMGI2ODk5NGJmM2QwZGU4NGRk
YjcyMjBkNzNhMDYzL2RtZXNnLXlvY3RvLWYzLTUzOjIwMTQwNDA3MTg0ODI1Ong4Nl82NC1y
YW5kY29uZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAtbmV4dC0yMDE0MDQwNzoxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyL2FiZmNkZmQ2M2YwYjY4OTk0YmYzZDBk
ZTg0ZGRiNzIyMGQ3M2EwNjMvZG1lc2ctcXVhbnRhbC1mMy0zNjoyMDE0MDQwNzE4NDgzNjp4
ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLW5leHQtMjAxNDA0MDc6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi9hYmZjZGZkNjNmMGI2ODk5
NGJmM2QwZGU4NGRkYjcyMjBkNzNhMDYzL2RtZXNnLXF1YW50YWwtZjMtNTY6MjAxNDA0MDcx
ODQ4NDA6eDg2XzY0LXJhbmRjb25maWctYnIwLTA0MDUwNzAyOjMuMTQuMC1uZXh0LTIwMTQw
NDA3OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDIvYWJmY2RmZDYz
ZjBiNjg5OTRiZjNkMGRlODRkZGI3MjIwZDczYTA2My9kbWVzZy15b2N0by1mMy05MDoyMDE0
MDQwNzE4NDgzNzp4ODZfNjQtcmFuZGNvbmZpZy1icjAtMDQwNTA3MDI6My4xNC4wLW5leHQt
MjAxNDA0MDc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMi9hYmZj
ZGZkNjNmMGI2ODk5NGJmM2QwZGU4NGRkYjcyMjBkNzNhMDYzL2RtZXNnLXlvY3RvLWYzLTI3
OjIwMTQwNDA3MTg0ODQwOng4Nl82NC1yYW5kY29uZmlnLWJyMC0wNDA1MDcwMjozLjE0LjAt
bmV4dC0yMDE0MDQwNzoxCjA6MTY6MTYgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-00621-g12e364b"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.14.0-rc5 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
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
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_NUMA_BALANCING=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
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
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_SECCOMP_FILTER=y
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
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_CMDLINE_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
# CONFIG_SPARSEMEM_VMEMMAP is not set
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
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
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
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
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
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
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
# CONFIG_INTEL_IDLE is not set

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
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
CONFIG_PCIE_PME=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
# CONFIG_HOTPLUG_PCI_CPCI_GENERIC is not set
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

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
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=m
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=m
CONFIG_PHONET=m
CONFIG_IEEE802154=y
CONFIG_6LOWPAN_IPHC=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=m
# CONFIG_NET_SCH_FQ is not set
# CONFIG_NET_SCH_HHF is not set
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_INGRESS=m
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=m
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_BPF=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=y
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_EMATCH_CANID=y
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
CONFIG_CAN_JANZ_ICAN3=m
CONFIG_PCH_CAN=m
CONFIG_CAN_SJA1000=y
# CONFIG_CAN_SJA1000_ISA is not set
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_EMS_PCMCIA=m
CONFIG_CAN_EMS_PCI=y
CONFIG_CAN_PEAK_PCMCIA=m
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_C_CAN is not set
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=m
CONFIG_CAN_CC770_PLATFORM=y

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
CONFIG_CAN_ESD_USB2=y
# CONFIG_CAN_KVASER_USB is not set
CONFIG_CAN_PEAK_USB=m
CONFIG_CAN_8DEV_USB=m
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
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
CONFIG_KINGSUN_DONGLE=m
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=m
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=m
# CONFIG_BT_HCIBLUECARD is not set
CONFIG_BT_HCIBTUART=m
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_LIB80211_DEBUG is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=m
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=m
CONFIG_CAIF_USB=m
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=m
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
CONFIG_NFC_MEI_PHY=m
CONFIG_NFC_SIM=y
CONFIG_NFC_PORT100=m
# CONFIG_NFC_PN544 is not set
# CONFIG_NFC_MICROREAD is not set
CONFIG_NFC_MRVL=m
CONFIG_NFC_MRVL_USB=m
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
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
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
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
# CONFIG_FTL is not set
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
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
CONFIG_MTD_CFI_INTELEXT=m
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
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SBC_GXX is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_PCMCIA is not set
CONFIG_MTD_GPIO_ADDR=m
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_RICOH=m
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=m
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=m
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
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
CONFIG_BLK_DEV_SKD=m
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_VMWARE_VMCI=y

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
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_AHCI_IMX=m
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_SX4=y
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=m
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_RZ1000=m

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_LEGACY is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
CONFIG_SBP_TARGET=m
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_ARCNET_COM20020_CS=m
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
# CONFIG_CAIF_SPI_SLAVE is not set
CONFIG_CAIF_HSI=m
CONFIG_CAIF_VIRTIO=m
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_ETHERNET is not set
CONFIG_FDDI=y
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
# CONFIG_SKFP is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=m
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=m
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=m
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=m
CONFIG_PLIP=m
CONFIG_PPP=m
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=m
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=y
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SR9800=m
CONFIG_USB_NET_SMSC75XX=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_CDC_PHONET=m
CONFIG_USB_IPHETH=y
# CONFIG_USB_SIERRA_NET is not set
CONFIG_USB_VL600=m
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=m
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
CONFIG_HOSTAP=m
# CONFIG_HOSTAP_FIRMWARE is not set
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_AUDIO is not set

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
# CONFIG_ISDN_CAPI is not set
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_I4L=y
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
CONFIG_GIGASET_DEBUG=y
CONFIG_HYSDN=m
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
CONFIG_MISDN_HFCMULTI=y
# CONFIG_MISDN_HFCUSB is not set
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
# CONFIG_MISDN_INFINEON is not set
CONFIG_MISDN_W6692=y
CONFIG_MISDN_NETJET=y
CONFIG_MISDN_IPAC=y
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=y

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
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=m
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=m
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=m
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_CROS_EC=m
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=m
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=m
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
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_UARTLITE=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_SCCNXP=m
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_PCH_UART=m
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=m
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=m
# CONFIG_PRINTER is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
CONFIG_R3964=m
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
# CONFIG_CARDMAN_4040 is not set
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=m
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=m
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=m
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_LP3943 is not set
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=m
CONFIG_GPIO_TWL6040=y
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=m
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#
# CONFIG_GPIO_UCB1400 is not set

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
# CONFIG_GPIO_PALMAS is not set
CONFIG_GPIO_TPS6586X=y
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=m
# CONFIG_MAX8925_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=y
# CONFIG_BATTERY_TWL4030_MADC is not set
CONFIG_CHARGER_PCF50633=y
# CONFIG_BATTERY_RX51 is not set
CONFIG_CHARGER_ISP1704=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_MAX14577 is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_ACPI_INT3403_THERMAL is not set

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
CONFIG_DA9052_WATCHDOG=y
# CONFIG_DW_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=y
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
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
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_KEMPLD=m
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
CONFIG_UCB1400_CORE=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=m
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=m
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=m
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=m
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=m
CONFIG_REGULATOR_AAT2870=m
# CONFIG_REGULATOR_ARIZONA is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8925=m
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_PALMAS=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6586X=m
CONFIG_REGULATOR_TPS65910=m
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_TWL4030=m
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=m
# CONFIG_RC_MAP is not set
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
# CONFIG_IR_JVC_DECODER is not set
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_SANYO_DECODER=m
# CONFIG_IR_MCE_KBD_DECODER is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_SCALE_CROP=m
# CONFIG_SOC_CAMERA_PLATFORM is not set
CONFIG_VIDEO_RCAR_VIN=m
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_SH_VEU=m
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_MEM2MEM_TESTDEV=m

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_CYPRESS_FIRMWARE=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_VIDEO_IR_I2C=m

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_TLV320AIC23B=m
CONFIG_VIDEO_UDA1342=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=m
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_ML86V7667=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA7191=m
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_TVP7002=m
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=m
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=m
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=m
CONFIG_VIDEO_ADV7393=m
CONFIG_VIDEO_AK881X=m
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_VS6624=m
# CONFIG_VIDEO_MT9V011 is not set
CONFIG_VIDEO_SR030PC30=m

#
# Flash devices
#
CONFIG_VIDEO_ADP1653=m
CONFIG_VIDEO_AS3645A=m
# CONFIG_VIDEO_LM3560 is not set

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
CONFIG_SOC_CAMERA_IMX074=m
# CONFIG_SOC_CAMERA_MT9M001 is not set
# CONFIG_SOC_CAMERA_MT9M111 is not set
CONFIG_SOC_CAMERA_MT9T031=m
# CONFIG_SOC_CAMERA_MT9T112 is not set
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_OV2640=m
CONFIG_SOC_CAMERA_OV5642=m
CONFIG_SOC_CAMERA_OV6650=m
# CONFIG_SOC_CAMERA_OV772X is not set
# CONFIG_SOC_CAMERA_OV9640 is not set
# CONFIG_SOC_CAMERA_OV9740 is not set
CONFIG_SOC_CAMERA_RJ54N1=m
CONFIG_SOC_CAMERA_TW9910=m

#
# Customise DVB Frontends
#
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_QXL is not set
CONFIG_DRM_BOCHS=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
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
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=m
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=m
CONFIG_FB_SMSCUFX=m
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_DA9052=m
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=m
CONFIG_BACKLIGHT_LM3630A=m
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_PANDORA=m
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=m
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
# CONFIG_SND_VIRMIDI is not set
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_SB_COMMON=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
# CONFIG_SND_ASIHPI is not set
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
# CONFIG_SND_AU8810 is not set
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
CONFIG_SND_AW2=m
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
# CONFIG_SND_ECHO3G is not set
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_FM801=m
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
CONFIG_SND_NM256=m
# CONFIG_SND_PCXHR is not set
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
CONFIG_SND_VIA82XX_MODEM=m
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
# CONFIG_SND_USB is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
# CONFIG_SND_DICE is not set
# CONFIG_SND_FIREWIRE_SPEAKERS is not set
CONFIG_SND_ISIGHT=m
CONFIG_SND_SCS1X=m
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=m
CONFIG_SND_ATMEL_SOC=m
CONFIG_SND_SOC_I2C_AND_SPI=m
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
CONFIG_SOUND_TRACEINIT=y
CONFIG_SOUND_DMAP=y
CONFIG_SOUND_VMIDI=y
CONFIG_SOUND_TRIX=m
CONFIG_SOUND_MSS=m
# CONFIG_SOUND_MPU401 is not set
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=y
# CONFIG_PSS_MIXER is not set
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=y
# CONFIG_SOUND_AEDSP16 is not set
CONFIG_SOUND_KAHLUA=m
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

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
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=m
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
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
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PCI is not set
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=m
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_WHCI_HCD=m
# CONFIG_USB_HWA_HCD is not set
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=m
# CONFIG_REALTEK_AUTOPM is not set
CONFIG_USB_STORAGE_DATAFAB=m
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
# CONFIG_USB_STORAGE_SDDR55 is not set
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_STORAGE_ENE_UB6250=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=m
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=m
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=m
CONFIG_USB_DWC3_EXYNOS=m
# CONFIG_USB_DWC3_PCI is not set
CONFIG_USB_DWC3_KEYSTONE=m

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_CHIPIDEA=m
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=m
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_VISOR=m
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=m
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=m
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=m
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=m
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=m
CONFIG_USB_SERIAL_MOS7720=m
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_XSENS_MT=m
CONFIG_USB_SERIAL_WISHBONE=m
CONFIG_USB_SERIAL_ZTE=y
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=m
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_SAMSUNG_USBPHY=m
CONFIG_SAMSUNG_USB2PHY=m
CONFIG_SAMSUNG_USB3PHY=m
CONFIG_USB_GPIO_VBUS=m
CONFIG_TAHVO_USB=m
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
CONFIG_USB_ISP1301=y
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_PCI=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=m
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_DA9052=m
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=y
# CONFIG_EDAC_I3200 is not set
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=m
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PALMAS is not set
CONFIG_RTC_DRV_PCF2127=m
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_TWL4030=m
# CONFIG_RTC_DRV_TPS6586X is not set
# CONFIG_RTC_DRV_TPS65910 is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=m
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_DS2404=m
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
CONFIG_UIO_MF624=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_ET131X=y
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
# CONFIG_USBIP_HOST is not set
CONFIG_USBIP_DEBUG=y
# CONFIG_COMEDI is not set
# CONFIG_PANEL is not set
CONFIG_R8187SE=m
CONFIG_RTL8192U=m
CONFIG_RTLLIB=m
# CONFIG_RTLLIB_CRYPTO_CCMP is not set
# CONFIG_RTLLIB_CRYPTO_TKIP is not set
# CONFIG_RTLLIB_CRYPTO_WEP is not set
# CONFIG_RTL8192E is not set
# CONFIG_R8712U is not set
CONFIG_R8188EU=m
# CONFIG_88EU_AP_MODE is not set
# CONFIG_88EU_P2P is not set
CONFIG_RTS5139=y
CONFIG_RTS5139_DEBUG=y
CONFIG_RTS5208=y
CONFIG_RTS5208_DEBUG=y
CONFIG_TRANZPORT=y
CONFIG_LINE6_USB=m
# CONFIG_LINE6_USB_IMPULSE_RESPONSE is not set
CONFIG_USB_SERIAL_QUATECH2=y
CONFIG_VT6655=m
# CONFIG_VT6656 is not set
CONFIG_DX_SEP=m

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7291=m
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m
# CONFIG_AD799X is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
CONFIG_ADT7316_I2C=m

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7152 is not set
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_ISL29028=m
CONFIG_TSL2583=m
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_WLAGS49_H2 is not set
CONFIG_WLAGS49_H25=m
CONFIG_CRYSTALHD=y
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_USB_ENESTORAGE=m
# CONFIG_BCM_WIMAX is not set
CONFIG_FT1000=m
CONFIG_FT1000_USB=m
CONFIG_FT1000_PCMCIA=m

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
CONFIG_SPEAKUP_SYNTH_ACNTSA=y
CONFIG_SPEAKUP_SYNTH_APOLLO=y
CONFIG_SPEAKUP_SYNTH_AUDPTR=m
CONFIG_SPEAKUP_SYNTH_BNS=y
# CONFIG_SPEAKUP_SYNTH_DECTLK is not set
CONFIG_SPEAKUP_SYNTH_DECEXT=y
# CONFIG_SPEAKUP_SYNTH_LTLK is not set
CONFIG_SPEAKUP_SYNTH_SOFT=y
CONFIG_SPEAKUP_SYNTH_SPKOUT=y
# CONFIG_SPEAKUP_SYNTH_TXPRT is not set
CONFIG_SPEAKUP_SYNTH_DUMMY=y
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y
CONFIG_VIDEO_DT3155=m
CONFIG_DT3155_CCIR=y
# CONFIG_DT3155_STREAMING is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_USB_MSI3101 is not set
# CONFIG_VIDEO_TCM825X is not set
CONFIG_SOLO6X10=m
# CONFIG_LIRC_STAGING is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_LTE_GDM724X is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
CONFIG_XILLYBUS=m
# CONFIG_XILLYBUS_PCIE is not set
CONFIG_DGNC=y
CONFIG_DGAP=m
CONFIG_GS_FPGABOOT=y
CONFIG_UNISYSSPAR=y
CONFIG_UNISYS_VISORUTIL=y
CONFIG_UNISYS_VISORCHANNEL=y
CONFIG_UNISYS_VISORCHIPSET=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=m
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=m
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_CHROMEOS_PSTORE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
CONFIG_EXTCON_ADC_JACK=m
CONFIG_EXTCON_MAX14577=m
CONFIG_EXTCON_MAX77693=m
# CONFIG_EXTCON_MAX8997 is not set
CONFIG_EXTCON_ARIZONA=m
# CONFIG_EXTCON_PALMAS is not set
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
# CONFIG_BMA180 is not set
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
CONFIG_MCP3422=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
# CONFIG_TWL6030_GPADC is not set
# CONFIG_VIPERBOARD_ADC is not set

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
CONFIG_AD5446=m
CONFIG_MAX517=m
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
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
# CONFIG_APDS9300 is not set
# CONFIG_CM32181 is not set
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=m
CONFIG_SENSORS_LM3533=m
CONFIG_LTR501=m
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=m
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
CONFIG_AK8975=m
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
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
CONFIG_TMP006=m
CONFIG_NTB=m
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
# CONFIG_VME_USER is not set
# CONFIG_VME_PIO2 is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

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
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=m
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
# CONFIG_EXOFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
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
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
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
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_PREEMPT is not set

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
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_PROVE_RCU_DELAY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
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
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=m
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
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
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
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
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4HC_COMPRESS=y
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
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_FONT_SUPPORT=m
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
CONFIG_FONT_ACORN_8x8=y
# CONFIG_FONT_MINI_4x6 is not set
CONFIG_FONT_SUN8x16=y
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set

--lrZ03NoBR/3+SXJZ--
