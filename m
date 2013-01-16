Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab3APJUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:20:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:4397 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758657Ab3APJUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:20:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,478,1355126400"; 
   d="log'?scan'208";a="274387476"
Date: Wed, 16 Jan 2013 16:54:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [madvise]  kernel BUG at block/blk-core.c:2981!
Message-ID: <20130116085434.GA18963@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Shaohua,

I tried bisect and 0d18d770b9180ffc2c3f63b9eb8406ef80105e05 is the first bad commit.

commit 0d18d770b9180ffc2c3f63b9eb8406ef80105e05
Author: Shaohua Li <shli@kernel.org>
Date:   Sat Jan 12 10:56:05 2013 +1100

    mm: make madvise(MADV_WILLNEED) support swap file prefetch

    Make madvise(MADV_WILLNEED) support swap file prefetch.  If memory is
    swapout, this syscall can do swapin prefetch.  It has no impact if the
    memory isn't swapout.

    Signed-off-by: Shaohua Li <shli@fusionio.com>
    Cc: Hugh Dickins <hughd@google.com>
    Cc: Rik van Riel <riel@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


[   32.168655] ok.
[   43.409959] ------------[ cut here ]------------
[   43.410048] kernel BUG at /c/kernel-tests/src/stable/block/blk-core.c:2981!
[   43.410048] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[   43.410048] CPU 0 
[   43.410048] Pid: 144, comm: trinity-child0 Not tainted 3.8.0-rc3-05057-g17e836d #10 Bochs Bochs
[   43.410048] RIP: 0010:[<ffffffff812c913a>]  [<ffffffff812c913a>] blk_flush_plug_list+0x47/0x285
[   43.410048] RSP: 0018:ffff880005ca1e08  EFLAGS: 00010202
[   43.410048] RAX: 0000000000000000 RBX: ffff880005ca1f20 RCX: 0000000a1b6ecfc4
[   43.410048] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81ef8a28
[   43.410048] RBP: ffff880005ca1e68 R08: 00000000ab1758f2 R09: 0000000000000000
[   43.410048] R10: 0000000000000246 R11: 0000000000000246 R12: 0000000000000001
[   43.410048] R13: 000000000000000b R14: 0000000000000000 R15: 4346331c5a4b1a16
[   43.410048] FS:  00007f1a35606700(0000) GS:ffffffff81bf1000(0000) knlGS:0000000000000000
[   43.410048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.410048] CR2: 000000000099ead0 CR3: 0000000006a0a000 CR4: 00000000000006b0
[   43.410048] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   43.410048] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   43.410048] Process trinity-child0 (pid: 144, threadinfo ffff880005ca0000, task ffff8800061656e0)
[   43.410048] Stack:
[   43.410048]  0000000105ca1e48 0000000000000282 ffff880005ca1e18 ffff880005ca1e18
[   43.410048]  ffff880006091d90 ffffffff00000001 043308412d708618 ffff880005ca1f20
[   43.410048]  0000000000000000 000000000000000b 0000000001b3c000 4346331c5a4b1a16
[   43.410048] Call Trace:
[   43.410048]  [<ffffffff812c9730>] blk_finish_plug+0x10/0x30
[   43.410048]  [<ffffffff81112be5>] sys_madvise+0x4f6/0x571
[   43.410048]  [<ffffffff817f83ea>] ? _raw_spin_unlock_irq+0x40/0x60
[   43.410048]  [<ffffffff8106e471>] ? do_setitimer+0x227/0x27c
[   43.410048]  [<ffffffff812e7849>] ? lockdep_sys_exit_thunk+0x35/0x67
[   43.410048]  [<ffffffff817f9927>] system_call_fastpath+0x16/0x1b
[   43.410048] Code: 48 89 45 b0 48 89 45 b8 b8 64 73 82 91 48 39 07 48 c7 c7 28 8a ef 81 41 0f 95 c4 31 d2 41 0f b6 f4 e8 fe 08 e1 ff 45 84 e4 74 02 <0f> 0b 48 8d 45 c0 48 89 45 c0 48 89 45 c8 49 89 c4 eb 5c 48 8b 
[   43.410048] RIP  [<ffffffff812c913a>] blk_flush_plug_list+0x47/0x285
[   43.410048]  RSP <ffff880005ca1e08>

# bad: [17e836d90690666d81376c1f4662aaa6a2829f9c] aio: document, clarify aio_read_events() and shadow_tail
# good: [29594404d7fe73cd80eaa4ee8c43dcc53970c60e] Linux 3.7
git bisect start '17e836d90690666d81376c1f4662aaa6a2829f9c' 'v3.7' '--'
# skip: [7764b5282e7e04ede3020d86787122887840e016] hwmon: (twl4030-madc-hwmon) Fix warning message caused by removal of __devexit
git bisect skip 7764b5282e7e04ede3020d86787122887840e016
# good: [10c39f1d717d3e5e8bcb2998f7dee4362edda26a] staging: line6: drop MIDI from CONFIG_LINE6_USB_DUMP_ANY
git bisect good 10c39f1d717d3e5e8bcb2998f7dee4362edda26a
# skip: [3c2e81ef344a90bb0a39d84af6878b4aeff568a2] Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
git bisect skip 3c2e81ef344a90bb0a39d84af6878b4aeff568a2
# good: [fe36a0b2b55c66f25407cc1f713b631bf7da75fa] ASoC: Ux500: Fixup use of clocks
git bisect good fe36a0b2b55c66f25407cc1f713b631bf7da75fa
# good: [0dfeada90989833d0144b4df25d2b9ce3746624f] Merge tag 'orion_dt_for_3.8' of git://git.infradead.org/users/jcooper/linux into next/dt
git bisect good 0dfeada90989833d0144b4df25d2b9ce3746624f
# skip: [d078fde369d175eb188c92df07c3163079d8beab] Staging: bcm: Remove typedef for _LEDColors and call directly.
git bisect skip d078fde369d175eb188c92df07c3163079d8beab
# good: [c299dd0e2d3dd61d0048a9d9b021aa01f023ed0c] CIFS: Fix write after setting a read lock for read oplock files
git bisect good c299dd0e2d3dd61d0048a9d9b021aa01f023ed0c
# skip: [9360b53661a2c7754517b2925580055bacc8ec38] Revert "bdi: add a user-tunable cpu_list for the bdi flusher threads"
git bisect skip 9360b53661a2c7754517b2925580055bacc8ec38
# skip: [a8b691e6104e6bd27070b6ed6622d0b640707fa8] iwlwifi: request IRQ only once
git bisect skip a8b691e6104e6bd27070b6ed6622d0b640707fa8
# good: [5efc1a7a6544491a8a4df8dcbff45a041600e429] Merge branch 'packaging' into for-next
git bisect good 5efc1a7a6544491a8a4df8dcbff45a041600e429
# skip: [f2ace93136cade6904a71d26e2f4768eef3b9aa3] MIPS: sysmips: Use unreachable().
git bisect skip f2ace93136cade6904a71d26e2f4768eef3b9aa3
# skip: [7f0ae647b29ba80d5a1127804ba478e3de8a6b4c] Bluetooth: Fix HCI command sending when powering on LE-only adapters
git bisect skip 7f0ae647b29ba80d5a1127804ba478e3de8a6b4c
# skip: [8f170faeb458532282dbfa870f456e42c11d1ebb] x86, apb_timer: remove unused variable percpu_timer
git bisect skip 8f170faeb458532282dbfa870f456e42c11d1ebb
# skip: [f3b369e40a0fbf975ab0e39c2104f184e188afc3] mwifiex: rx path enhancement to derive priv only once
git bisect skip f3b369e40a0fbf975ab0e39c2104f184e188afc3
# skip: [d62fdf8b681550881b3fb85f335eaf8e36b971b7] drivers/net: Use of_match_ptr() macro in smsc911x.c
git bisect skip d62fdf8b681550881b3fb85f335eaf8e36b971b7
# good: [79d4969535f1d569d7ddf7f58242994e9479a28d] tg3: Support 5717 C0
git bisect good 79d4969535f1d569d7ddf7f58242994e9479a28d
# skip: [375da3a76dc49f10c35e243ebef62df12e3adf4e] drivers/of/fdt.c: re-use kernel's kbasename()
git bisect skip 375da3a76dc49f10c35e243ebef62df12e3adf4e
# good: [1ea2a0160588582cd8414a8026d5b54f1705dfa1] mn10300: switch to generic fork/vfork/clone
git bisect good 1ea2a0160588582cd8414a8026d5b54f1705dfa1
# skip: [1b8a1636ceea573b1d452a1cccf01c990d8d628a] aoe: update cap on outstanding commands based on config query response
git bisect skip 1b8a1636ceea573b1d452a1cccf01c990d8d628a
# good: [94e014ee98e98dedb080ed1cdf510a583ed0514b] drm/radeon/cayman: add VM CS checker support for CP DMA
git bisect good 94e014ee98e98dedb080ed1cdf510a583ed0514b
# skip: [6fd59a83b9261fa53eaf98fb5514abba504a3ea3] scatterlist: don't BUG when we can trivially return a proper error.
git bisect skip 6fd59a83b9261fa53eaf98fb5514abba504a3ea3
# skip: [24bd410905919696b705a2ce1df5e1d5d4d22032] regulator: max8997: Remove set_voltage_time_sel setting for max8997_ldo_ops
git bisect skip 24bd410905919696b705a2ce1df5e1d5d4d22032
# good: [0cae4685a602a8bf9a86fa2417d6c035c09d6341] staging: net: remove use of __devexit
git bisect good 0cae4685a602a8bf9a86fa2417d6c035c09d6341
# skip: [9228ff90387e276ad67b10c0eb525c9d6a57d5e9] Merge branch 'for-3.8/drivers' of git://git.kernel.dk/linux-block
git bisect skip 9228ff90387e276ad67b10c0eb525c9d6a57d5e9
# skip: [1724ffbc7439de679d536163e03f54f35574d449] mac80211: complete bss_info tracing
git bisect skip 1724ffbc7439de679d536163e03f54f35574d449
# skip: [0f68bb4aed611b05216a9d94457704c738bcb7b9] ARM: shmobile: Include sh73a0 DTSI in kzm9g
git bisect skip 0f68bb4aed611b05216a9d94457704c738bcb7b9
# good: [89377aa5156a93e73a3f7c7ccdc0d0fecf65e0d2] pinctrl: lantiq: Staticize non-exported symbols
git bisect good 89377aa5156a93e73a3f7c7ccdc0d0fecf65e0d2
# good: [71fbad6c9a28629b6af40b0ff48f36c6610a1394] PCI/ACPI: Notify PCI devices when their power resource is turned on
git bisect good 71fbad6c9a28629b6af40b0ff48f36c6610a1394
# skip: [41cad6ab2cb9ccb3b11546ad56b8b285e47c6279] cfq-iosched: convert cfq_group_slice() to use cfqg->vfraction
git bisect skip 41cad6ab2cb9ccb3b11546ad56b8b285e47c6279
# good: [eabc5fa51c1fae4b66cf883e3a3c2b3ca794494c] Merge branch 'spear-for-3.8' of git://git.linaro.org/people/vireshk/linux into next/dt2
git bisect good eabc5fa51c1fae4b66cf883e3a3c2b3ca794494c
# skip: [889b2f8783ee533ffe4117b0a7173319dec86ac8] MAINTAINERS: add an entry for radio-mr800 driver
git bisect skip 889b2f8783ee533ffe4117b0a7173319dec86ac8
# skip: [7fbdadb5e951e4f0c0fc991ff5f50295568786e6] solos-pci: remove superfluous debug output
git bisect skip 7fbdadb5e951e4f0c0fc991ff5f50295568786e6
# good: [d3cec81fc929b6edc43bd42725929685359adef7] firmware: remove last vestiges of dabusb
git bisect good d3cec81fc929b6edc43bd42725929685359adef7
# skip: [6a2b60b17b3e48a418695a94bd2420f6ab32e519] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace
git bisect skip 6a2b60b17b3e48a418695a94bd2420f6ab32e519
# good: [e3224111b3a527eb8f9b9b6deed83b727522941e] staging: dgrp: remove use of real_raw and read_cnt in dgrp_input
git bisect good e3224111b3a527eb8f9b9b6deed83b727522941e
# skip: [b444df2f7267e1a431989ad95169f0c13ac790e2] drivers/video/backlight/pandora_bl.c: change TWL4030_MODULE_PWM0 to TWL_MODULE_PWM
git bisect skip b444df2f7267e1a431989ad95169f0c13ac790e2
# skip: [eee8182aa4424eee71f25cb4ce2c56a53222d523] kvm tools: Convert virtio devices to use IRQ registry
git bisect skip eee8182aa4424eee71f25cb4ce2c56a53222d523
# skip: [667be1e757f5684576d01d7402907a2489b1402f] aoe: provide ATA identify device content to user on request
git bisect skip 667be1e757f5684576d01d7402907a2489b1402f
# skip: [c0b74876ee4873dc89d80b59f5e890a1d0a87be1] ath9k: Add a debugfs file to dump queue statistics
git bisect skip c0b74876ee4873dc89d80b59f5e890a1d0a87be1
# good: [b254e3e407669328ba8edee6454d44609fc34adc] Merge commit 'v3.2-rc2' into linux-next
git bisect good b254e3e407669328ba8edee6454d44609fc34adc
# good: [08fe1172f8433d5e71c1d6cb7b85922724aa0cd8] Merge remote-tracking branch 'vhost/linux-next'
git bisect good 08fe1172f8433d5e71c1d6cb7b85922724aa0cd8
# good: [da4bd8bf7f518375af0b3be165914393dfc51164] Merge remote-tracking branch 'userns/for-next'
git bisect good da4bd8bf7f518375af0b3be165914393dfc51164
# good: [c73f9be37508574ee11aed680f597c3a0f3e9e4b] memcg, oom: provide more precise dump info while memcg oom happening
git bisect good c73f9be37508574ee11aed680f597c3a0f3e9e4b
# bad: [aa0e4b147868e8fd814e6b7d9fa5b0ee567c9df1] drivers/video/backlight/l4f00242t03.c: convert to devm_regulator_get()
git bisect bad aa0e4b147868e8fd814e6b7d9fa5b0ee567c9df1
# bad: [994cc907eebc73a6f528b915d9f051179bf52dd4] mm: memmap_init_zone() performance improvement
git bisect bad 994cc907eebc73a6f528b915d9f051179bf52dd4
# bad: [59de07046c9cfbdf8f9ab3bfa515a85ece93e4a9] mm: use mm_populate() when adjusting brk with MCL_FUTURE in effect
git bisect bad 59de07046c9cfbdf8f9ab3bfa515a85ece93e4a9
# good: [ae751c1843f8c115af922c06eb507cea30c61ba9] mm/page_alloc.c:__setup_per_zone_wmarks: make min_pages unsigned long
git bisect good ae751c1843f8c115af922c06eb507cea30c61ba9
# bad: [6eabfddc7ff9703acbe374ec6e30548156dfbcd9] mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix
git bisect bad 6eabfddc7ff9703acbe374ec6e30548156dfbcd9
# good: [68e330bf77bcd5ff36f26d162a34cc20ceb51f77] mm/ksm.c: use new hashtable implementation
git bisect good 68e330bf77bcd5ff36f26d162a34cc20ceb51f77
# bad: [0d18d770b9180ffc2c3f63b9eb8406ef80105e05] mm: make madvise(MADV_WILLNEED) support swap file prefetch
git bisect bad 0d18d770b9180ffc2c3f63b9eb8406ef80105e05
# good: [6df61eaaa9fad4da8c30340339119d6cc9bbddd9] memcg,vmscan: do not break out targeted reclaim without reclaimed pages
git bisect good 6df61eaaa9fad4da8c30340339119d6cc9bbddd9

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bay-3447-2013-01-14-19-50-22-3.8.0-rc3-05057-g17e836d-10"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.8.0-rc3-05057-g17e836d (kbuild@hive) (gcc ve=
rsion 4.7.1 (GCC) ) #10 Mon Jan 14 19:43:21 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 branch=3Dnext/akpm log_buf_len=3D8M ignore_loglevel debug sched_d=
ebug apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ra=
mdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/r=
am0 rw link=3Dvmlinuz-2013-01-14-19-45-33-next:akpm:17e836d-17e836d-x86_64-=
randconfig-h011-5-bay BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig-h=
011/17e836d/vmlinuz-3.8.0-rc3-05057-g17e836d
[    0.000000] KERNEL supported cpus:
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0e8540=
00-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128216(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000=
001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3901 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 60478 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1bf7540
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 00000000000=
94000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64379
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 branch=3Dnext/akpm log_buf_len=3D8M ignore_loglevel debug =
sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10  pr=
ompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3Dvmlinuz-2013-01-14-19-45-33-next:akpm:17e836d-17e836=
d-x86_64-randconfig-h011-5-bay BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-ran=
dconfig-h011/17e836d/vmlinuz-3.8.0-rc3-05057-g17e836d
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 198404k/262136k available (8181k kernel code, 500k a=
bsent, 63232k reserved, 7334k data, 644k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
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
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |failed|
[    0.000000]             mixed read-write-lock:             |failed|     =
        |failed|
[    0.000000]             mixed write-read-lock:             |failed|     =
        |failed|
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
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
[    0.000000] --------------------------------------------------------
[    0.000000] 133 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ODEBUG: 6 of 6 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2992.556 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5985.11 Bogo=
MIPS (lpj=3D2992556)
[    0.003433] pid_max: default: 32768 minimum: 301
[    0.004167] Security Framework initialized
[    0.005075] Mount-cache hash table entries: 256
[    0.006472] Initializing cgroup subsys devices
[    0.007014] Initializing cgroup subsys freezer
[    0.007687] Initializing cgroup subsys blkio
[    0.008014] Initializing cgroup subsys net_prio
[    0.009118] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009118] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009118] tlb_flushall_shift: -1
[    0.010007] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, =
stepping: 01)
[    0.016068] ACPI: Core revision 20121220
[    0.019595] ACPI: All ACPI Tables successfully acquired
[    0.020405] Performance Events:=20
[    0.021545] ftrace: Allocated trace_printk buffers
[    0.036159] Getting VERSION: 50014
[    0.036698] Getting VERSION: 50014
[    0.037013] Getting ID: 0
[    0.037422] Getting ID: ff000000
[    0.038013] Getting LVT0: 8700
[    0.038481] Getting LVT1: 8400
[    0.039069] enabled ExtINT on CPU#0
[    0.040816] ENABLING IO-APIC IRQs
[    0.041010] init IO_APIC IRQs
[    0.041464]  apic 2 pin 0 not connected
[    0.042015] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.043027] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.044027] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.045024] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.046024] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.047024] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.048024] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.049024] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.050024] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.051024] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.052024] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.053024] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.054024] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.055024] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.056024] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.057022]  apic 2 pin 16 not connected
[    0.058004]  apic 2 pin 17 not connected
[    0.059004]  apic 2 pin 18 not connected
[    0.059590]  apic 2 pin 19 not connected
[    0.060004]  apic 2 pin 20 not connected
[    0.060592]  apic 2 pin 21 not connected
[    0.061004]  apic 2 pin 22 not connected
[    0.062004]  apic 2 pin 23 not connected
[    0.062737] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.063004] Using local APIC timer interrupts.
[    0.063004] calibrating APIC timer ...
[    0.065000] ... lapic delta =3D 6249983
[    0.065000] ... PM-Timer delta =3D 357953
[    0.065000] ... PM-Timer result ok
[    0.065000] ..... delta 6249983
[    0.065000] ..... mult: 268434725
[    0.065000] ..... calibration result: 999997
[    0.065000] ..... CPU clock speed is 2992.0483 MHz.
[    0.065000] ..... host bus clock speed is 999.0997 MHz.
[    0.065084] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.066782] devtmpfs: initialized
[    0.069520] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.071049] regulator-dummy: no parameters
[    0.072086] NET: Registered protocol family 16
[    0.073969] i2c-core: driver [dummy] registered
[    0.075381] ACPI: bus type pci registered
[    0.076212] PCI: Using configuration type 1 for base access
[    0.085006] bio: create slab <bio-0> at 0
[    0.086053] ACPI: Added _OSI(Module Device)
[    0.086816] ACPI: Added _OSI(Processor Device)
[    0.087005] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.088005] ACPI: Added _OSI(Processor Aggregator Device)
[    0.092567] ACPI: EC: Look up EC in DSDT
[    0.099699] ACPI: Interpreter enabled
[    0.100010] ACPI: (supports S0 S3 S4 S5)
[    0.101245] ACPI: Using IOAPIC for interrupt routing
[    0.102045] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.114006] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.115007] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.116693] pci_root PNP0A03:00: ACPI _OSC support notification failed, =
disabling PCIe ASPM
[    0.117005] pci_root PNP0A03:00: Unable to request _OSC control (_OSC su=
pport mask: 0x08)
[    0.118064] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.119005] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.120000] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.120000] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff] (ignored)
[    0.120000] PCI: root bus 00: using default resources
[    0.120080] PCI host bridge to bus 0000:00
[    0.121006] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.122005] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.123005] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
fff]
[    0.124069] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.126299] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.128068] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.130879] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.132723] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.134513] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.135019] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.136236] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.138056] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.140460] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.146452] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.148220] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.150005] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.151617] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.155611] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.157126] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.158421] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.162204] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.163687] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.165327] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.170183] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.171685] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.173328] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.178300] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.180005] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.181620] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.186279] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.188005] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.189620] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.194254] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.196005] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.197620] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.202227] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.204005] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.205327] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.210148] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.211368] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.215124] pci_bus 0000:00: on NUMA node 0
[    0.215890] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.221000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.222433] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.223475] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.225158] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.226471] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.227461] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.229072] i2c-core: driver [ad5398] registered
[    0.230053] i2c-core: driver [max1586] registered
[    0.230919] i2c-core: driver [max8649] registered
[    0.231049] i2c-core: driver [max8973] registered
[    0.232052] i2c-core: driver [tps65023] registered
[    0.234102] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.235015] vgaarb: loaded
[    0.236003] vgaarb: bridge control possible 0000:00:02.0
[    0.237265] i2c-core: driver [88PM80X] registered
[    0.238028] i2c-core: driver [wm831x] registered
[    0.239045] i2c-core: driver [wm8350] registered
[    0.239912] i2c-core: driver [tps6507x] registered
[    0.240023] i2c-core: driver [mc13xxx] registered
[    0.241078] i2c-core: driver [da903x] registered
[    0.242037] i2c-core: driver [lp8788] registered
[    0.243024] i2c-core: driver [max77686] registered
[    0.244019] i2c-core: driver [max8907] registered
[    0.245019] i2c-core: driver [max8997] registered
[    0.246050] i2c-core: driver [max8998] registered
[    0.247025] i2c-core: driver [tps6586x] registered
[    0.247907] i2c-core: driver [palmas] registered
[    0.248019] i2c-core: driver [lm3533] registered
[    0.250073] SCSI subsystem initialized
[    0.250769] ACPI: bus type scsi registered
[    0.251043] libata version 3.00 loaded.
[    0.252152] pps_core: LinuxPPS API ver. 1 registered
[    0.253003] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.254017] PTP clock support registered
[    0.255171] wmi: Mapper loaded
[    0.256120] PCI: Using ACPI for IRQ routing
[    0.257009] PCI: pci_cache_line_size set to 64 bytes
[    0.258359] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.259010] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.261208] irda_init()
[    0.261732] NET: Registered protocol family 23
[    0.262025] Bluetooth: Core ver 2.16
[    0.263030] NET: Registered protocol family 31
[    0.264003] Bluetooth: HCI device and connection manager initialized
[    0.265013] Bluetooth: HCI socket layer initialized
[    0.266005] Bluetooth: L2CAP socket layer initialized
[    0.267030] Bluetooth: SCO socket layer initialized
[    0.268656] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.269065] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.270259] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.272237] Switching to clocksource kvm-clock
[    0.273665] Warning: could not register annotated branches stats
[    0.318993] pnp: PnP ACPI init
[    0.319619] ACPI: bus type pnp registered
[    0.320445] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.321962] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.323266] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.324806] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.326050] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.327566] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.328813] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.330252] pnp 00:03: [dma 2]
[    0.330901] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.332189] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.333680] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.334955] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.336489] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.338192] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.339719] pnp: PnP ACPI: found 7 devices
[    0.340482] ACPI: ACPI bus type pnp unregistered
[    0.341330] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.348165] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.349186] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    0.350368] NET: Registered protocol family 1
[    0.351186] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.352274] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.353347] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.354505] pci 0000:00:02.0: Boot video device
[    0.355474] PCI: CLS 0 bytes, default 64
[    0.356439] Unpacking initramfs...
[    1.915379] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffe=
ffff]
[    1.920901] AVX instructions are not detected.
[    1.943870] Initializing RT-Tester: OK
[    1.944595] audit: initializing netlink socket (disabled)
[    1.945681] type=3D2000 audit(1358164178.945:1): initialized
[    1.946861] rcu-torture:--- Start of test: nreaders=3D2 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D0 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    1.981175] VFS: Disk quotas dquot_6.5.2
[    1.982157] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.985583] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    1.986974] fuse init (API version 7.20)
[    1.988379] SGI XFS with ACLs, security attributes, large block/inode nu=
mbers, no debug enabled
[    1.996763] GFS2 installed
[    1.997281] msgmni has been set to 387
[    2.053967] alg: No test for stdrng (krng)
[    2.056970] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    2.059829] io scheduler noop registered (default)
[    2.070352] xz_dec_test: module loaded
[    2.071051] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[    2.073151] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.074240] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.075435] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    2.076985] acpiphp: Slot [3] registered
[    2.077767] acpiphp: Slot [4] registered
[    2.078551] acpiphp: Slot [5] registered
[    2.079332] acpiphp: Slot [6] registered
[    2.080110] acpiphp: Slot [7] registered
[    2.080897] acpiphp: Slot [8] registered
[    2.081664] acpiphp: Slot [9] registered
[    2.082439] acpiphp: Slot [10] registered
[    2.083253] acpiphp: Slot [11] registered
[    2.084043] acpiphp: Slot [12] registered
[    2.084849] acpiphp: Slot [13] registered
[    2.085650] acpiphp: Slot [14] registered
[    2.086445] acpiphp: Slot [15] registered
[    2.087258] acpiphp: Slot [16] registered
[    2.088055] acpiphp: Slot [17] registered
[    2.088870] acpiphp: Slot [18] registered
[    2.089669] acpiphp: Slot [19] registered
[    2.090463] acpiphp: Slot [20] registered
[    2.091297] acpiphp: Slot [21] registered
[    2.092108] acpiphp: Slot [22] registered
[    2.092894] acpiphp: Slot [23] registered
[    2.093677] acpiphp: Slot [24] registered
[    2.094490] acpiphp: Slot [25] registered
[    2.095318] acpiphp: Slot [26] registered
[    2.096113] acpiphp: Slot [27] registered
[    2.096924] acpiphp: Slot [28] registered
[    2.097769] acpiphp: Slot [29] registered
[    2.098572] acpiphp: Slot [30] registered
[    2.099368] acpiphp: Slot [31] registered
[    2.100729] i2c-core: driver [adp8870_bl] using legacy suspend method
[    2.101893] i2c-core: driver [adp8870_bl] using legacy resume method
[    2.103038] i2c-core: driver [adp8870_bl] registered
[    2.104046] nvidiafb_setup START
[    2.104967] vmlfb: initializing
[    2.106446] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    2.112234] GHES: HEST is not enabled!
[    2.112930] ERST DBG: ERST support is disabled.
[    2.113909] i2c-core: driver [fan53555-regulator] registered
[    2.114953] i2c-core: driver [LP3971] registered
[    2.115811] i2c-core: driver [lp872x] registered
[    2.159161] r3964: Philips r3964 Driver $Revision: 1.10 $
[    2.160188] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.184372] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.210651] Initializing Nozomi driver 2.1d
[    2.212242] Real Time Clock Driver v1.12b
[    2.213388] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
[    2.214761] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    2.216365] Hangcheck: Using getrawmonotonic().
[    2.217237] i2c-core: driver [tpm_i2c_infineon] registered
[    2.218283] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    2.219393] [drm] radeon defaulting to userspace modesetting.
[    2.225224] i2c-core: driver [sil164] registered
[    2.226168] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.227420] lkdtm: No crash points registered, enable through debugfs
[    2.228669] Phantom Linux Driver, version n0.9.8, init OK
[    2.229666] i2c-core: driver [bh1780] registered
[    2.230524] i2c-core: driver [bh1770glc] registered
[    2.231427] i2c-core: driver [apds990x] registered
[    2.232487] i2c-core: driver [apds9802als] using legacy suspend method
[    2.233667] i2c-core: driver [apds9802als] using legacy resume method
[    2.234832] i2c-core: driver [apds9802als] registered
[    2.235765] i2c-core: driver [isl29003] using legacy suspend method
[    2.235828] i2c-core: driver [isl29003] using legacy resume method
[    2.235828] i2c-core: driver [isl29003] registered
[    2.238856] i2c-core: driver [ds1682] registered
[    2.239774] i2c-core: driver [at24] registered
[    2.240591] i2c-core: driver [max6875] registered
[    2.241509] i2c-core: driver [lis3lv02d_i2c] registered
[    2.242481] i2c-core: driver [arizona] registered
[    2.243409] i2c-core: driver [wm8994] registered
[    2.244274] i2c-core: driver [twl6040] registered
[    2.245147] i2c-core: driver [smsc] registered
[    2.245990] i2c-core: driver [adp5520] registered
[    2.247085] Uniform Multi-Platform E-IDE driver
[    2.248342] ide-gd driver 1.18
[    2.248925] ide-cd driver 5.00
[    2.252301] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    2.260678] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    2.261618] YAM driver version 0.8 by F1OAT/F6FBB
[    2.263660] AX.25: bpqether driver version 004
[    2.264488] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    2.264488] baycom_ser_hdx: version 0.10
[    2.267509] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    2.268557] hdlcdrv: version 0.8
[    2.269354] irda_register_dongle : registering dongle "Actisys ACT-220L"=
 (2).
[    2.270659] irda_register_dongle : registering dongle "Actisys ACT-220L+=
" (3).
[    2.271962] irda_register_dongle : registering dongle "Parallax LiteLink=
" (5).
[    2.272957] Fusion MPT base driver 3.04.20
[    2.273998] Copyright (c) 1999-2008 LSI Corporation
[    2.274899] Fusion MPT SPI Host driver 3.04.20
[    2.275755] Fusion MPT FC Host driver 3.04.20
[    2.276667] Fusion MPT misc device (ioctl) driver 3.04.20
[    2.279815] mptctl: Registered with Fusion MPT base driver
[    2.280819] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    2.281939] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.284328] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.285247] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.362977] mousedev: PS/2 mouse device common for all mice
[    2.364128] i2c-core: driver [as5011] registered
[    2.365229] i2c-core: driver [ad714x_captouch] registered
[    2.366303] i2c-core: driver [mma8450] registered
[    2.367234] i2c-core: driver [mpu3050] registered
[    2.368146] i2c /dev entries driver
[    2.369059] piix4_smbus 0000:00:01.3: Using Interrupt 9 for SMBus.
[    2.370189] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    2.372569] i2c-dev: adapter [SMBus PIIX4 adapter at b100] registered as=
 minor 0
[    2.373955] i2c i2c-0: adapter [SMBus PIIX4 adapter at b100] registered
[    2.375669] pps pps0: new PPS source ktimer
[    2.376454] pps pps0: ktimer PPS source registered
[    2.377409] Driver for 1-wire Dallas network protocol.
[    2.378459] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.379591] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    2.381414] i2c-core: driver [sbs-battery] using legacy suspend method
[    2.382592] i2c-core: driver [sbs-battery] registered
[    2.383588] i2c-core: driver [max17042] registered
[    2.384501] i2c-core: driver [lp8727] registered
[    2.385392] i2c-core: driver [bq2415x-charger] registered
[    2.386497] i2c-core: driver [asb100] registered
[    2.387353] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    2.388524] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D00, ADD=3D5a, =
DAT0=3D00, DAT1=3D00
[    2.391517] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D00, ADD=3D5a,=
 DAT0=3D00, DAT1=3D00
[    2.392955] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D4e, ADD=3D5b, =
DAT0=3D00, DAT1=3D00
[    2.395896] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D4e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.397317] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D4f, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.400354] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D4f, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.401778] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D4e, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.404772] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D4e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.406198] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D4e, ADD=3D5a, =
DAT0=3Df8, DAT1=3D00
[    2.409242] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D4e, ADD=3D5a,=
 DAT0=3Df8, DAT1=3D00
[    2.410658] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D58, ADD=3D5b, =
DAT0=3Df8, DAT1=3D00
[    2.413775] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D58, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.415198] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D4f, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.417123] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    2.418772] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D4f, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.420282] i2c-core: driver [w83795] registered
[    2.421130] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    2.422286] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D4f, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    2.423843] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.425836] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D4f, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    2.427260] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D00, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.429773] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D00, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.431159] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[    2.432369] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    2.433520] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D00, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    2.436317] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D00, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    2.437745] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D00, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.441286] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D00, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.442669] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[    2.443878] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    2.444873] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D00, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    2.447832] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D00, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    2.449250] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D00, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.451800] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D00, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.453183] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[    2.454390] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[    2.455555] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D00, ADD=3D5e, =
DAT0=3Dff, DAT1=3D00
[    2.457774] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D00, ADD=3D5e,=
 DAT0=3Dff, DAT1=3D00
[    2.459189] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D00, ADD=3D5f, =
DAT0=3Dff, DAT1=3D00
[    2.462002] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D00, ADD=3D5f,=
 DAT0=3Dff, DAT1=3D00
[    2.463386] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[    2.464622] i2c-core: driver [w83791d] registered
[    2.465489] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    2.466641] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D00, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    2.469774] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D00, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    2.471202] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.473774] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.475158] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    2.476303] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    2.479057] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    2.480469] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.504418] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.505809] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    2.506796] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    2.516490] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    2.517914] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.520937] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.522323] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[    2.523475] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D5e, =
DAT0=3Dff, DAT1=3D00
[    2.525871] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D5e,=
 DAT0=3Dff, DAT1=3D00
[    2.527297] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D5f, =
DAT0=3Dff, DAT1=3D00
[    2.529773] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D5f,=
 DAT0=3Dff, DAT1=3D00
[    2.531189] i2c-core: driver [ad7414] registered
[    2.532111] i2c-core: driver [ad7418] registered
[    2.533055] i2c-core: driver [adm1025] registered
[    2.533917] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    2.535079] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    2.538119] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    2.539540] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.541770] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.543153] i2c i2c-0: ADM1025 detection failed at 0x2c
[    2.544101] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    2.545253] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    2.548544] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    2.549967] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.552773] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.554153] i2c i2c-0: ADM1025 detection failed at 0x2d
[    2.555098] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    2.556250] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    2.558772] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    2.560198] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.563578] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.564967] i2c i2c-0: ADM1025 detection failed at 0x2e
[    2.565924] i2c-core: driver [adm1026] registered
[    2.565948] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    2.565948] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    2.575717] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    2.577135] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D16, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.579773] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D16, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.581194] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D17, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.583824] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D17, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.585214] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and=
 VERSTEP: 0xff
[    2.586626] i2c i2c-0: Autodetecting device at 0,0x2c...
[    2.587593] i2c i2c-0: Autodetection failed
[    2.588359] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    2.589506] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D17, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    2.591819] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D17, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    2.593243] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D16, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.595771] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D16, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.597193] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D17, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.600012] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D17, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.601391] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and=
 VERSTEP: 0xff
[    2.602806] i2c i2c-0: Autodetecting device at 0,0x2d...
[    2.603754] i2c i2c-0: Autodetection failed
[    2.603802] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    2.603802] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D17, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    2.608766] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D17, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    2.610185] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D16, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.613550] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D16, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.614970] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D17, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.617768] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D17, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.619145] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and=
 VERSTEP: 0xff
[    2.620557] i2c i2c-0: Autodetecting device at 0,0x2e...
[    2.621526] i2c i2c-0: Autodetection failed
[    2.622324] i2c-core: driver [adm1029] registered
[    2.623186] i2c i2c-0: found normal entry for adapter 0, addr 0x28
[    2.624332] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D17, ADD=3D50, =
DAT0=3Dff, DAT1=3D00
[    2.630803] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D17, ADD=3D50,=
 DAT0=3Dff, DAT1=3D00
[    2.632230] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0d, ADD=3D51, =
DAT0=3Dff, DAT1=3D00
[    2.634890] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0d, ADD=3D51,=
 DAT0=3Dff, DAT1=3D00
[    2.636309] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0e, ADD=3D51, =
DAT0=3Dff, DAT1=3D00
[    2.639574] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0e, ADD=3D51,=
 DAT0=3Dff, DAT1=3D00
[    2.640996] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D06, ADD=3D51, =
DAT0=3Dff, DAT1=3D00
[    2.657240] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D06, ADD=3D51,=
 DAT0=3Dff, DAT1=3D00
[    2.658657] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D51, =
DAT0=3Dff, DAT1=3D00
[    2.668694] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D51,=
 DAT0=3Dff, DAT1=3D00
[    2.670092] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[    2.671073] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D52, =
DAT0=3Dff, DAT1=3D00
[    2.673762] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D52,=
 DAT0=3Dff, DAT1=3D00
[    2.675178] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0d, ADD=3D53, =
DAT0=3Dff, DAT1=3D00
[    2.677766] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0d, ADD=3D53,=
 DAT0=3Dff, DAT1=3D00
[    2.679183] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0e, ADD=3D53, =
DAT0=3Dff, DAT1=3D00
[    2.681762] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0e, ADD=3D53,=
 DAT0=3Dff, DAT1=3D00
[    2.683178] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D06, ADD=3D53, =
DAT0=3Dff, DAT1=3D00
[    2.685761] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D06, ADD=3D53,=
 DAT0=3Dff, DAT1=3D00
[    2.687184] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D53, =
DAT0=3Dff, DAT1=3D00
[    2.689771] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D53,=
 DAT0=3Dff, DAT1=3D00
[    2.691152] i2c i2c-0: found normal entry for adapter 0, addr 0x2a
[    2.692301] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D54, =
DAT0=3Dff, DAT1=3D00
[    2.694959] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D54,=
 DAT0=3Dff, DAT1=3D00
[    2.696374] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0d, ADD=3D55, =
DAT0=3Dff, DAT1=3D00
[    2.698762] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0d, ADD=3D55,=
 DAT0=3Dff, DAT1=3D00
[    2.700176] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0e, ADD=3D55, =
DAT0=3Dff, DAT1=3D00
[    2.702972] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0e, ADD=3D55,=
 DAT0=3Dff, DAT1=3D00
[    2.704399] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D06, ADD=3D55, =
DAT0=3Dff, DAT1=3D00
[    2.707612] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D06, ADD=3D55,=
 DAT0=3Dff, DAT1=3D00
[    2.709043] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D55, =
DAT0=3Dff, DAT1=3D00
[    2.711765] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D55,=
 DAT0=3Dff, DAT1=3D00
[    2.713152] i2c i2c-0: found normal entry for adapter 0, addr 0x2b
[    2.714298] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D56, =
DAT0=3Dff, DAT1=3D00
[    2.716924] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D56,=
 DAT0=3Dff, DAT1=3D00
[    2.718335] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0d, ADD=3D57, =
DAT0=3Dff, DAT1=3D00
[    2.721859] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0d, ADD=3D57,=
 DAT0=3Dff, DAT1=3D00
[    2.723277] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0e, ADD=3D57, =
DAT0=3Dff, DAT1=3D00
[    2.725768] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0e, ADD=3D57,=
 DAT0=3Dff, DAT1=3D00
[    2.727188] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D06, ADD=3D57, =
DAT0=3Dff, DAT1=3D00
[    2.731316] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D06, ADD=3D57,=
 DAT0=3Dff, DAT1=3D00
[    2.732741] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D57, =
DAT0=3Dff, DAT1=3D00
[    2.736133] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D57,=
 DAT0=3Dff, DAT1=3D00
[    2.737517] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    2.738672] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    2.742028] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    2.743439] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0d, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.745998] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0d, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.747421] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0e, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.749763] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0e, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.751179] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D06, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.765791] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D06, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.767211] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.770247] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.771635] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    2.772787] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    2.775759] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    2.777171] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0d, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.779943] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0d, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.781372] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0e, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.783765] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.785184] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D06, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.787763] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D06, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.789183] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.792717] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.794102] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    2.795253] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    2.805672] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    2.807099] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0d, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.809758] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0d, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.811168] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0e, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.814054] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0e, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.815479] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D06, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.818492] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D06, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.819913] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.822758] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.824147] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[    2.825295] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D5e, =
DAT0=3Dff, DAT1=3D00
[    2.827777] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D5e,=
 DAT0=3Dff, DAT1=3D00
[    2.829187] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0d, ADD=3D5f, =
DAT0=3Dff, DAT1=3D00
[    2.831996] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0d, ADD=3D5f,=
 DAT0=3Dff, DAT1=3D00
[    2.833410] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D0e, ADD=3D5f, =
DAT0=3Dff, DAT1=3D00
[    2.835758] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D0e, ADD=3D5f,=
 DAT0=3Dff, DAT1=3D00
[    2.837177] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D06, ADD=3D5f, =
DAT0=3Dff, DAT1=3D00
[    2.839767] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D06, ADD=3D5f,=
 DAT0=3Dff, DAT1=3D00
[    2.841186] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D5f, =
DAT0=3Dff, DAT1=3D00
[    2.844690] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D5f,=
 DAT0=3Dff, DAT1=3D00
[    2.846102] i2c-core: driver [adm1031] registered
[    2.846943] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    2.847063] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    2.850912] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    2.852331] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.860904] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.862329] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.866231] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.867617] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    2.868769] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    2.871894] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    2.873308] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.876248] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.877673] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.880758] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.882150] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    2.883310] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    2.886756] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    2.888182] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.890930] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.892367] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.894766] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.896175] i2c-core: driver [ads1015] registered
[    2.897118] i2c-core: driver [adt7410] registered
[    2.898002] i2c-core: driver [adt7462] registered
[    2.898862] i2c i2c-0: found normal entry for adapter 0, addr 0x58
[    2.900018] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D3e, ADD=3Db1, =
DAT0=3Dff, DAT1=3D00
[    2.904672] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D3e, ADD=3Db1,=
 DAT0=3Dff, DAT1=3D00
[    2.906119] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3Db1, =
DAT0=3Dff, DAT1=3D00
[    2.908755] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3Db1,=
 DAT0=3Dff, DAT1=3D00
[    2.910145] i2c i2c-0: found normal entry for adapter 0, addr 0x5c
[    2.911295] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D3e, ADD=3Db9, =
DAT0=3Dff, DAT1=3D00
[    2.913759] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D3e, ADD=3Db9,=
 DAT0=3Dff, DAT1=3D00
[    2.915183] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3Db9, =
DAT0=3Dff, DAT1=3D00
[    2.917760] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3Db9,=
 DAT0=3Dff, DAT1=3D00
[    2.919170] i2c-core: driver [adt7470] registered
[    2.920034] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    2.921192] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    2.923761] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    2.925185] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.927846] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.929228] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    2.930381] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    2.933667] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    2.935102] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.937760] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.939145] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[    2.940300] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D5e, =
DAT0=3Dff, DAT1=3D00
[    2.942762] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D5e,=
 DAT0=3Dff, DAT1=3D00
[    2.944177] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5f, =
DAT0=3Dff, DAT1=3D00
[    2.946787] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5f,=
 DAT0=3Dff, DAT1=3D00
[    2.948407] i2c-core: driver [adt7475] registered
[    2.949269] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    2.950424] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    2.953175] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    2.954596] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.957964] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.959394] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    2.962356] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    2.963738] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    2.964891] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    2.968330] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    2.969748] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.972759] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.974185] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    2.977595] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    2.978991] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    2.980147] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    2.983371] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    2.984785] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.987753] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.989178] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    2.992331] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    2.993725] applesmc: supported laptop not found!
[    2.994572] applesmc: driver init failed (ret=3D-19)!
[    2.995488] i2c-core: driver [asc7621] registered
[    2.996356] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    2.997510] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    2.999753] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    3.001200] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    3.002605] tsc: Refined TSC clocksource calibration: 2992.497 MHz
[    3.004204] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    3.005626] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    3.009729] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    3.011148] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    3.013760] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    3.015181] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    3.017804] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    3.019184] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.020334] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    3.023748] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    3.025160] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.027754] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.029174] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.031879] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.033297] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.035996] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.037423] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.039788] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.041169] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.042321] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    3.073215] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    3.074635] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    3.077751] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    3.079173] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    3.081752] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    3.083179] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    3.085748] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    3.087168] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    3.090714] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    3.091949] i2c-core: driver [dme1737] registered
[    3.092817] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    3.093966] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    3.097090] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    3.098512] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    3.101424] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    3.102849] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    3.106000] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    3.107377] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.108531] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    3.111384] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    3.112805] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.115760] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.117182] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.131511] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.132897] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.134051] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    3.137252] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    3.138668] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    3.142201] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    3.143623] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    3.146755] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    3.148260] i2c-core: driver [ds1621] registered
[    3.149108] i2c i2c-0: found normal entry for adapter 0, addr 0x48
[    3.150263] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D90, =
DAT0=3Dff, DAT1=3D00
[    3.153517] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D90,=
 DAT0=3Dff, DAT1=3D00
[    3.154947] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dac, ADD=3D91, =
DAT0=3Dff, DAT1=3D00
[    3.157983] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dac, ADD=3D91,=
 DAT0=3Dff, DAT1=3D00
[    3.159359] i2c i2c-0: found normal entry for adapter 0, addr 0x49
[    3.160509] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dac, ADD=3D92, =
DAT0=3Dff, DAT1=3D00
[    3.162840] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dac, ADD=3D92,=
 DAT0=3Dff, DAT1=3D00
[    3.164254] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dac, ADD=3D93, =
DAT0=3Dff, DAT1=3D00
[    3.166780] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dac, ADD=3D93,=
 DAT0=3Dff, DAT1=3D00
[    3.168172] i2c i2c-0: found normal entry for adapter 0, addr 0x4a
[    3.169325] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dac, ADD=3D94, =
DAT0=3Dff, DAT1=3D00
[    3.172812] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dac, ADD=3D94,=
 DAT0=3Dff, DAT1=3D00
[    3.174229] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dac, ADD=3D95, =
DAT0=3Dff, DAT1=3D00
[    3.176745] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dac, ADD=3D95,=
 DAT0=3Dff, DAT1=3D00
[    3.178128] i2c i2c-0: found normal entry for adapter 0, addr 0x4b
[    3.179281] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dac, ADD=3D96, =
DAT0=3Dff, DAT1=3D00
[    3.183642] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dac, ADD=3D96,=
 DAT0=3Dff, DAT1=3D00
[    3.185060] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dac, ADD=3D97, =
DAT0=3Dff, DAT1=3D00
[    3.196609] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dac, ADD=3D97,=
 DAT0=3Dff, DAT1=3D00
[    3.198014] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    3.198998] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dac, ADD=3D98, =
DAT0=3Dff, DAT1=3D00
[    3.202513] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dac, ADD=3D98,=
 DAT0=3Dff, DAT1=3D00
[    3.203929] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dac, ADD=3D99, =
DAT0=3Dff, DAT1=3D00
[    3.206913] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dac, ADD=3D99,=
 DAT0=3Dff, DAT1=3D00
[    3.208298] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    3.209451] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dac, ADD=3D9a, =
DAT0=3Dff, DAT1=3D00
[    3.212396] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dac, ADD=3D9a,=
 DAT0=3Dff, DAT1=3D00
[    3.213813] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dac, ADD=3D9b, =
DAT0=3Dff, DAT1=3D00
[    3.216750] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dac, ADD=3D9b,=
 DAT0=3Dff, DAT1=3D00
[    3.218127] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[    3.219282] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dac, ADD=3D9c, =
DAT0=3Dff, DAT1=3D00
[    3.221785] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dac, ADD=3D9c,=
 DAT0=3Dff, DAT1=3D00
[    3.223193] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dac, ADD=3D9d, =
DAT0=3Dff, DAT1=3D00
[    3.225744] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dac, ADD=3D9d,=
 DAT0=3Dff, DAT1=3D00
[    3.227124] i2c i2c-0: found normal entry for adapter 0, addr 0x4f
[    3.228273] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dac, ADD=3D9e, =
DAT0=3Dff, DAT1=3D00
[    3.231276] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dac, ADD=3D9e,=
 DAT0=3Dff, DAT1=3D00
[    3.232698] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dac, ADD=3D9f, =
DAT0=3Dff, DAT1=3D00
[    3.236001] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dac, ADD=3D9f,=
 DAT0=3Dff, DAT1=3D00
[    3.237391] i2c-core: driver [emc1403] registered
[    3.238252] i2c i2c-0: found normal entry for adapter 0, addr 0x18
[    3.239400] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dac, ADD=3D30, =
DAT0=3Dff, DAT1=3D00
[    3.241747] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dac, ADD=3D30,=
 DAT0=3Dff, DAT1=3D00
[    3.243153] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D31, =
DAT0=3Dff, DAT1=3D00
[    3.245850] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D31,=
 DAT0=3Dff, DAT1=3D00
[    3.247232] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[    3.248383] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D52, =
DAT0=3Dff, DAT1=3D00
[    3.251156] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D52,=
 DAT0=3Dff, DAT1=3D00
[    3.252572] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D53, =
DAT0=3Dff, DAT1=3D00
[    3.255519] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D53,=
 DAT0=3Dff, DAT1=3D00
[    3.256898] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    3.258058] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D98, =
DAT0=3Dff, DAT1=3D00
[    3.268453] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D98,=
 DAT0=3Dff, DAT1=3D00
[    3.269876] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D99, =
DAT0=3Dff, DAT1=3D00
[    3.272744] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D99,=
 DAT0=3Dff, DAT1=3D00
[    3.274137] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    3.275292] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D9a, =
DAT0=3Dff, DAT1=3D00
[    3.278076] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D9a,=
 DAT0=3Dff, DAT1=3D00
[    3.279498] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D9b, =
DAT0=3Dff, DAT1=3D00
[    3.281853] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D9b,=
 DAT0=3Dff, DAT1=3D00
[    3.283329] i2c-core: driver [emc6w201] registered
[    3.284213] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    3.285368] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    3.288138] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    3.289555] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    3.292539] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    3.293930] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.294914] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    3.297742] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    3.299162] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.302293] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.303689] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.304839] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    3.311897] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    3.313319] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    3.316744] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    3.318164] f71882fg: Not a Fintek device
[    3.318945] f71882fg: Not a Fintek device
[    3.319710] i2c-core: driver [f75375] registered
[    3.320542] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.321709] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    3.324833] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    3.326259] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D5d, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.328746] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D5d, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.330170] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D5e, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.333661] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D5e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.335076] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D5a, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.337743] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D5a, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.339171] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D5b, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.341742] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D5b, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.343131] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.344285] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D5b, ADD=3D5c, =
DAT0=3Dff, DAT1=3D00
[    3.347217] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D5b, ADD=3D5c,=
 DAT0=3Dff, DAT1=3D00
[    3.348629] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D5d, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    3.352366] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D5d, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    3.353783] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D5e, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    3.356738] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D5e, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    3.358155] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D5a, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    3.361326] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D5a, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    3.362751] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D5b, ADD=3D5d, =
DAT0=3Dff, DAT1=3D00
[    3.365750] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D5b, ADD=3D5d,=
 DAT0=3Dff, DAT1=3D00
[    3.367162] i2c-core: driver [g760a] registered
[    3.368011] i2c-core: driver [gl520sm] registered
[    3.368874] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    3.370029] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D5b, ADD=3D58, =
DAT0=3Dff, DAT1=3D00
[    3.372753] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D5b, ADD=3D58,=
 DAT0=3Dff, DAT1=3D00
[    3.374172] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D00, ADD=3D59, =
DAT0=3Dff, DAT1=3D00
[    3.376843] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D00, ADD=3D59,=
 DAT0=3Dff, DAT1=3D00
[    3.378212]  (null): Unknown chip type, skipping
[    3.379054] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.380201] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D00, ADD=3D5a, =
DAT0=3Dff, DAT1=3D00
[    3.382736] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D00, ADD=3D5a,=
 DAT0=3Dff, DAT1=3D00
[    3.384147] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D00, ADD=3D5b, =
DAT0=3Dff, DAT1=3D00
[    3.386738] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D00, ADD=3D5b,=
 DAT0=3Dff, DAT1=3D00
[    3.388112]  (null): Unknown chip type, skipping
[    3.389042] i2c-core: driver [jc42] registered
[    3.389854] i2c i2c-0: found normal entry for adapter 0, addr 0x18
[    3.391006] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D00, ADD=3D30, =
DAT0=3Dff, DAT1=3D00
[    3.394045] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D00, ADD=3D30,=
 DAT0=3Dff, DAT1=3D00
[    3.395459] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D00, ADD=3D31, =
DAT0=3Dff, DAT1=3D00
[    3.397744] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D00, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    3.399165] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D01, ADD=3D31, =
DAT0=3Dff, DAT1=3Dff
[    3.402149] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D01, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    3.403586] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D06, ADD=3D31, =
DAT0=3Dff, DAT1=3Dff
[    3.406074] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D06, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    3.407501] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D31, =
DAT0=3Dff, DAT1=3Dff
[    3.409742] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    3.411133] i2c i2c-0: found normal entry for adapter 0, addr 0x19
[    3.412280] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D32, =
DAT0=3Dff, DAT1=3Dff
[    3.414737] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D32,=
 DAT0=3Dff, DAT1=3Dff
[    3.416143] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D00, ADD=3D33, =
DAT0=3Dff, DAT1=3Dff
[    3.419581] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D00, ADD=3D33,=
 DAT0=3Dff, DAT1=3Dff
[    3.421015] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D01, ADD=3D33, =
DAT0=3Dff, DAT1=3Dff
[    3.450691] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D01, ADD=3D33,=
 DAT0=3Dff, DAT1=3Dff
[    3.452087] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D06, ADD=3D33, =
DAT0=3Dff, DAT1=3Dff
[    3.454808] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D06, ADD=3D33,=
 DAT0=3Dff, DAT1=3Dff
[    3.456226] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D33, =
DAT0=3Dff, DAT1=3Dff
[    3.459472] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D33,=
 DAT0=3Dff, DAT1=3Dff
[    3.460864] i2c i2c-0: found normal entry for adapter 0, addr 0x1a
[    3.462017] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D34, =
DAT0=3Dff, DAT1=3Dff
[    3.465130] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D34,=
 DAT0=3Dff, DAT1=3Dff
[    3.466548] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D00, ADD=3D35, =
DAT0=3Dff, DAT1=3Dff
[    3.468949] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D00, ADD=3D35,=
 DAT0=3Dff, DAT1=3Dff
[    3.470370] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D01, ADD=3D35, =
DAT0=3Dff, DAT1=3Dff
[    3.472738] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D01, ADD=3D35,=
 DAT0=3Dff, DAT1=3Dff
[    3.474153] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D06, ADD=3D35, =
DAT0=3Dff, DAT1=3Dff
[    3.477493] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D06, ADD=3D35,=
 DAT0=3Dff, DAT1=3Dff
[    3.478922] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D35, =
DAT0=3Dff, DAT1=3Dff
[    3.481746] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D35,=
 DAT0=3Dff, DAT1=3Dff
[    3.483113] i2c i2c-0: found normal entry for adapter 0, addr 0x1b
[    3.484247] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D36, =
DAT0=3Dff, DAT1=3Dff
[    3.487113] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D36,=
 DAT0=3Dff, DAT1=3Dff
[    3.488525] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D00, ADD=3D37, =
DAT0=3Dff, DAT1=3Dff
[    3.491378] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D00, ADD=3D37,=
 DAT0=3Dff, DAT1=3Dff
[    3.492801] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D01, ADD=3D37, =
DAT0=3Dff, DAT1=3Dff
[    3.495734] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D01, ADD=3D37,=
 DAT0=3Dff, DAT1=3Dff
[    3.497167] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D06, ADD=3D37, =
DAT0=3Dff, DAT1=3Dff
[    3.504233] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D06, ADD=3D37,=
 DAT0=3Dff, DAT1=3Dff
[    3.505646] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D37, =
DAT0=3Dff, DAT1=3Dff
[    3.508730] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D37,=
 DAT0=3Dff, DAT1=3Dff
[    3.510107] i2c i2c-0: found normal entry for adapter 0, addr 0x1c
[    3.511244] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D38, =
DAT0=3Dff, DAT1=3Dff
[    3.514277] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D38,=
 DAT0=3Dff, DAT1=3Dff
[    3.515698] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D00, ADD=3D39, =
DAT0=3Dff, DAT1=3Dff
[    3.522539] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D00, ADD=3D39,=
 DAT0=3Dff, DAT1=3Dff
[    3.523983] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D01, ADD=3D39, =
DAT0=3Dff, DAT1=3Dff
[    3.526741] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D01, ADD=3D39,=
 DAT0=3Dff, DAT1=3Dff
[    3.528161] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D06, ADD=3D39, =
DAT0=3Dff, DAT1=3Dff
[    3.532732] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D06, ADD=3D39,=
 DAT0=3Dff, DAT1=3Dff
[    3.534164] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D39, =
DAT0=3Dff, DAT1=3Dff
[    3.537351] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D39,=
 DAT0=3Dff, DAT1=3Dff
[    3.538740] i2c i2c-0: found normal entry for adapter 0, addr 0x1d
[    3.539718] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D3a, =
DAT0=3Dff, DAT1=3Dff
[    3.542997] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D3a,=
 DAT0=3Dff, DAT1=3Dff
[    3.544399] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D00, ADD=3D3b, =
DAT0=3Dff, DAT1=3Dff
[    3.553086] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D00, ADD=3D3b,=
 DAT0=3Dff, DAT1=3Dff
[    3.554483] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D01, ADD=3D3b, =
DAT0=3Dff, DAT1=3Dff
[    3.557214] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D01, ADD=3D3b,=
 DAT0=3Dff, DAT1=3Dff
[    3.558633] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D06, ADD=3D3b, =
DAT0=3Dff, DAT1=3Dff
[    3.561734] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D06, ADD=3D3b,=
 DAT0=3Dff, DAT1=3Dff
[    3.563162] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D3b, =
DAT0=3Dff, DAT1=3Dff
[    3.565728] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D3b,=
 DAT0=3Dff, DAT1=3Dff
[    3.567101] i2c i2c-0: found normal entry for adapter 0, addr 0x1e
[    3.568235] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D3c, =
DAT0=3Dff, DAT1=3Dff
[    3.570731] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D3c,=
 DAT0=3Dff, DAT1=3Dff
[    3.572148] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D00, ADD=3D3d, =
DAT0=3Dff, DAT1=3Dff
[    3.585189] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D00, ADD=3D3d,=
 DAT0=3Dff, DAT1=3Dff
[    3.586611] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D01, ADD=3D3d, =
DAT0=3Dff, DAT1=3Dff
[    3.589776] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D01, ADD=3D3d,=
 DAT0=3Dff, DAT1=3Dff
[    3.591190] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D06, ADD=3D3d, =
DAT0=3Dff, DAT1=3Dff
[    3.594271] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D06, ADD=3D3d,=
 DAT0=3Dff, DAT1=3Dff
[    3.595715] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D3d, =
DAT0=3Dff, DAT1=3Dff
[    3.598732] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D3d,=
 DAT0=3Dff, DAT1=3Dff
[    3.600124] i2c i2c-0: found normal entry for adapter 0, addr 0x1f
[    3.601278] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D3e, =
DAT0=3Dff, DAT1=3Dff
[    3.603733] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D3e,=
 DAT0=3Dff, DAT1=3Dff
[    3.605152] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D00, ADD=3D3f, =
DAT0=3Dff, DAT1=3Dff
[    3.607736] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D00, ADD=3D3f,=
 DAT0=3Dff, DAT1=3Dff
[    3.609162] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D01, ADD=3D3f, =
DAT0=3Dff, DAT1=3Dff
[    3.614832] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D01, ADD=3D3f,=
 DAT0=3Dff, DAT1=3Dff
[    3.616261] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D06, ADD=3D3f, =
DAT0=3Dff, DAT1=3Dff
[    3.618766] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D06, ADD=3D3f,=
 DAT0=3Dff, DAT1=3Dff
[    3.620165] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D3f, =
DAT0=3Dff, DAT1=3Dff
[    3.622732] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D3f,=
 DAT0=3Dff, DAT1=3Dff
[    3.624142] i2c-core: driver [lm63] registered
[    3.624937] i2c i2c-0: found normal entry for adapter 0, addr 0x18
[    3.626083] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D30, =
DAT0=3Dff, DAT1=3Dff
[    3.628810] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D30,=
 DAT0=3Dff, DAT1=3Dff
[    3.630205] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D31, =
DAT0=3Dff, DAT1=3Dff
[    3.634414] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    3.635817] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dff, ADD=3D31, =
DAT0=3Dff, DAT1=3Dff
[    3.638732] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dff, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    3.640110] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D03, ADD=3D31, =
DAT0=3Dff, DAT1=3Dff
[    3.643801] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D03, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    3.645216] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dbf, ADD=3D31, =
DAT0=3Dff, DAT1=3Dff
[    3.657858] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dbf, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    3.659274] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D31, =
DAT0=3Dff, DAT1=3Dff
[    3.662261] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    3.663664] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D16, ADD=3D31, =
DAT0=3Dff, DAT1=3Dff
[    3.666293] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D16, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    3.667681] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    3.668801] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    3.669944] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D16, ADD=3D98, =
DAT0=3Dff, DAT1=3Dff
[    3.672879] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D16, ADD=3D98,=
 DAT0=3Dff, DAT1=3Dff
[    3.674293] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D99, =
DAT0=3Dff, DAT1=3Dff
[    3.681970] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D99,=
 DAT0=3Dff, DAT1=3Dff
[    3.683391] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dff, ADD=3D99, =
DAT0=3Dff, DAT1=3Dff
[    3.686236] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dff, ADD=3D99,=
 DAT0=3Dff, DAT1=3Dff
[    3.687652] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D03, ADD=3D99, =
DAT0=3Dff, DAT1=3Dff
[    3.690726] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D03, ADD=3D99,=
 DAT0=3Dff, DAT1=3Dff
[    3.692144] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dbf, ADD=3D99, =
DAT0=3Dff, DAT1=3Dff
[    3.694726] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dbf, ADD=3D99,=
 DAT0=3Dff, DAT1=3Dff
[    3.696148] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D99, =
DAT0=3Dff, DAT1=3Dff
[    3.698726] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D99,=
 DAT0=3Dff, DAT1=3Dff
[    3.700147] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D16, ADD=3D99, =
DAT0=3Dff, DAT1=3Dff
[    3.702729] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D16, ADD=3D99,=
 DAT0=3Dff, DAT1=3Dff
[    3.704114] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    3.705243] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[    3.706397] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D16, ADD=3D9c, =
DAT0=3Dff, DAT1=3Dff
[    3.708723] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D16, ADD=3D9c,=
 DAT0=3Dff, DAT1=3Dff
[    3.710123] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D9d, =
DAT0=3Dff, DAT1=3Dff
[    3.713271] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D9d,=
 DAT0=3Dff, DAT1=3Dff
[    3.714708] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dff, ADD=3D9d, =
DAT0=3Dff, DAT1=3Dff
[    3.718304] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dff, ADD=3D9d,=
 DAT0=3Dff, DAT1=3Dff
[    3.719734] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D03, ADD=3D9d, =
DAT0=3Dff, DAT1=3Dff
[    3.722729] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D03, ADD=3D9d,=
 DAT0=3Dff, DAT1=3Dff
[    3.724161] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dbf, ADD=3D9d, =
DAT0=3Dff, DAT1=3Dff
[    3.727124] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dbf, ADD=3D9d,=
 DAT0=3Dff, DAT1=3Dff
[    3.728550] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D9d, =
DAT0=3Dff, DAT1=3Dff
[    3.730841] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D9d,=
 DAT0=3Dff, DAT1=3Dff
[    3.732265] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D16, ADD=3D9d, =
DAT0=3Dff, DAT1=3Dff
[    3.734726] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D16, ADD=3D9d,=
 DAT0=3Dff, DAT1=3Dff
[    3.736108] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    3.737282] i2c-core: driver [lm73] registered
[    3.738102] i2c i2c-0: found normal entry for adapter 0, addr 0x48
[    3.739262] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D16, ADD=3D90, =
DAT0=3Dff, DAT1=3Dff
[    3.741723] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D16, ADD=3D90,=
 DAT0=3Dff, DAT1=3Dff
[    3.743147] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D04, ADD=3D91, =
DAT0=3Dff, DAT1=3Dff
[    3.745967] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D04, ADD=3D91,=
 DAT0=3Dff, DAT1=3Dff
[    3.747350] i2c i2c-0: found normal entry for adapter 0, addr 0x49
[    3.748512] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D04, ADD=3D92, =
DAT0=3Dff, DAT1=3Dff
[    3.751041] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D04, ADD=3D92,=
 DAT0=3Dff, DAT1=3Dff
[    3.752458] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D04, ADD=3D93, =
DAT0=3Dff, DAT1=3Dff
[    3.754825] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D04, ADD=3D93,=
 DAT0=3Dff, DAT1=3Dff
[    3.756211] i2c i2c-0: found normal entry for adapter 0, addr 0x4a
[    3.757373] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D04, ADD=3D94, =
DAT0=3Dff, DAT1=3Dff
[    3.759724] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D04, ADD=3D94,=
 DAT0=3Dff, DAT1=3Dff
[    3.761141] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D04, ADD=3D95, =
DAT0=3Dff, DAT1=3Dff
[    3.781348] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D04, ADD=3D95,=
 DAT0=3Dff, DAT1=3Dff
[    3.782735] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    3.783894] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D04, ADD=3D98, =
DAT0=3Dff, DAT1=3Dff
[    3.787341] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D04, ADD=3D98,=
 DAT0=3Dff, DAT1=3Dff
[    3.788769] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D04, ADD=3D99, =
DAT0=3Dff, DAT1=3Dff
[    3.791812] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D04, ADD=3D99,=
 DAT0=3Dff, DAT1=3Dff
[    3.793203] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    3.794355] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D04, ADD=3D9a, =
DAT0=3Dff, DAT1=3Dff
[    3.802521] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D04, ADD=3D9a,=
 DAT0=3Dff, DAT1=3Dff
[    3.803951] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D04, ADD=3D9b, =
DAT0=3Dff, DAT1=3Dff
[    3.806932] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D04, ADD=3D9b,=
 DAT0=3Dff, DAT1=3Dff
[    3.808318] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[    3.809474] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D04, ADD=3D9c, =
DAT0=3Dff, DAT1=3Dff
[    3.811724] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D04, ADD=3D9c,=
 DAT0=3Dff, DAT1=3Dff
[    3.813144] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D04, ADD=3D9d, =
DAT0=3Dff, DAT1=3Dff
[    3.815918] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D04, ADD=3D9d,=
 DAT0=3Dff, DAT1=3Dff
[    3.817322] i2c-core: driver [lm78] registered
[    3.818137] i2c i2c-0: found normal entry for adapter 0, addr 0x28
[    3.819293] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D04, ADD=3D50, =
DAT0=3Dff, DAT1=3Dff
[    3.822718] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D04, ADD=3D50,=
 DAT0=3Dff, DAT1=3Dff
[    3.824140] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D51, =
DAT0=3Dff, DAT1=3Dff
[    3.826728] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D51,=
 DAT0=3Dff, DAT1=3Dff
[    3.828116] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[    3.829269] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D52, =
DAT0=3Dff, DAT1=3Dff
[    3.832201] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D52,=
 DAT0=3Dff, DAT1=3Dff
[    3.833616] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D53, =
DAT0=3Dff, DAT1=3Dff
[    3.836724] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D53,=
 DAT0=3Dff, DAT1=3Dff
[    3.838113] i2c i2c-0: found normal entry for adapter 0, addr 0x2a
[    3.839271] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D54, =
DAT0=3Dff, DAT1=3Dff
[    3.842485] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D54,=
 DAT0=3Dff, DAT1=3Dff
[    3.843911] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D55, =
DAT0=3Dff, DAT1=3Dff
[    3.846723] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D55,=
 DAT0=3Dff, DAT1=3Dff
[    3.848112] i2c i2c-0: found normal entry for adapter 0, addr 0x2b
[    3.849265] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D56, =
DAT0=3Dff, DAT1=3Dff
[    3.851716] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D56,=
 DAT0=3Dff, DAT1=3Dff
[    3.853134] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D57, =
DAT0=3Dff, DAT1=3Dff
[    3.855720] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D57,=
 DAT0=3Dff, DAT1=3Dff
[    3.857108] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    3.858259] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D58, =
DAT0=3Dff, DAT1=3Dff
[    3.860718] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D58,=
 DAT0=3Dff, DAT1=3Dff
[    3.862141] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D59, =
DAT0=3Dff, DAT1=3Dff
[    3.865758] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D59,=
 DAT0=3Dff, DAT1=3Dff
[    3.867155] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.868310] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D5a, =
DAT0=3Dff, DAT1=3Dff
[    3.871151] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D5a,=
 DAT0=3Dff, DAT1=3Dff
[    3.872567] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D5b, =
DAT0=3Dff, DAT1=3Dff
[    3.875171] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D5b,=
 DAT0=3Dff, DAT1=3Dff
[    3.876560] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.877721] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D5c, =
DAT0=3Dff, DAT1=3Dff
[    3.880838] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D5c,=
 DAT0=3Dff, DAT1=3Dff
[    3.882254] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D5d, =
DAT0=3Dff, DAT1=3Dff
[    3.885142] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D5d,=
 DAT0=3Dff, DAT1=3Dff
[    3.886530] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[    3.887695] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D5e, =
DAT0=3Dff, DAT1=3Dff
[    3.891007] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D5e,=
 DAT0=3Dff, DAT1=3Dff
[    3.892428] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D5f, =
DAT0=3Dff, DAT1=3Dff
[    3.895321] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D5f,=
 DAT0=3Dff, DAT1=3Dff
[    3.896739] i2c-core: driver [lm80] registered
[    3.897545] i2c i2c-0: found normal entry for adapter 0, addr 0x28
[    3.898708] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D50, =
DAT0=3Dff, DAT1=3Dff
[    3.902175] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D50,=
 DAT0=3Dff, DAT1=3Dff
[    3.903597] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D51, =
DAT0=3Dff, DAT1=3Dff
[    3.906716] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D51,=
 DAT0=3Dff, DAT1=3Dff
[    3.908109] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[    3.909263] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D52, =
DAT0=3Dff, DAT1=3Dff
[    3.912143] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D52,=
 DAT0=3Dff, DAT1=3Dff
[    3.913562] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D53, =
DAT0=3Dff, DAT1=3Dff
[    3.915786] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D53,=
 DAT0=3Dff, DAT1=3Dff
[    3.917173] i2c i2c-0: found normal entry for adapter 0, addr 0x2a
[    3.918328] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D54, =
DAT0=3Dff, DAT1=3Dff
[    3.921178] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D54,=
 DAT0=3Dff, DAT1=3Dff
[    3.922592] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D55, =
DAT0=3Dff, DAT1=3Dff
[    3.925717] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D55,=
 DAT0=3Dff, DAT1=3Dff
[    3.927098] i2c i2c-0: found normal entry for adapter 0, addr 0x2b
[    3.928255] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D56, =
DAT0=3Dff, DAT1=3Dff
[    3.953145] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D56,=
 DAT0=3Dff, DAT1=3Dff
[    3.954561] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D57, =
DAT0=3Dff, DAT1=3Dff
[    3.959472] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D57,=
 DAT0=3Dff, DAT1=3Dff
[    3.960860] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    3.961841] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D58, =
DAT0=3Dff, DAT1=3Dff
[    3.964723] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D58,=
 DAT0=3Dff, DAT1=3Dff
[    3.966143] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D59, =
DAT0=3Dff, DAT1=3Dff
[    3.968721] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D59,=
 DAT0=3Dff, DAT1=3Dff
[    3.970110] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.971264] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D5a, =
DAT0=3Dff, DAT1=3Dff
[    3.973716] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D5a,=
 DAT0=3Dff, DAT1=3Dff
[    3.975141] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D5b, =
DAT0=3Dff, DAT1=3Dff
[    3.978813] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D5b,=
 DAT0=3Dff, DAT1=3Dff
[    3.980201] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.981352] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D5c, =
DAT0=3Dff, DAT1=3Dff
[    3.996897] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D5c,=
 DAT0=3Dff, DAT1=3Dff
[    3.998318] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D5d, =
DAT0=3Dff, DAT1=3Dff
[    4.001336] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D5d,=
 DAT0=3Dff, DAT1=3Dff
[    4.002730] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[    4.003714] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D5e, =
DAT0=3Dff, DAT1=3Dff
[    4.006892] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D5e,=
 DAT0=3Dff, DAT1=3Dff
[    4.008320] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D02, ADD=3D5f, =
DAT0=3Dff, DAT1=3Dff
[    4.011093] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D02, ADD=3D5f,=
 DAT0=3Dff, DAT1=3Dff
[    4.012571] i2c-core: driver [lm85] registered
[    4.013401] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.014554] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D02, ADD=3D58, =
DAT0=3Dff, DAT1=3Dff
[    4.017084] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D02, ADD=3D58,=
 DAT0=3Dff, DAT1=3Dff
[    4.018501] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D59, =
DAT0=3Dff, DAT1=3Dff
[    4.020779] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D59,=
 DAT0=3Dff, DAT1=3Dff
[    4.022210] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D59, =
DAT0=3Dff, DAT1=3Dff
[    4.024714] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D59,=
 DAT0=3Dff, DAT1=3Dff
[    4.026104] i2c i2c-0: Detecting device at 0x2c with COMPANY: 0xff and V=
ERSTEP: 0xff
[    4.027494] i2c i2c-0: Autodetection failed: unsupported version
[    4.028585] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.029743] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D5a, =
DAT0=3Dff, DAT1=3Dff
[    4.032715] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D5a,=
 DAT0=3Dff, DAT1=3Dff
[    4.034141] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5b, =
DAT0=3Dff, DAT1=3Dff
[    4.038198] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3Dff
[    4.039620] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D5b, =
DAT0=3Dff, DAT1=3Dff
[    4.042784] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D5b,=
 DAT0=3Dff, DAT1=3Dff
[    4.044166] i2c i2c-0: Detecting device at 0x2d with COMPANY: 0xff and V=
ERSTEP: 0xff
[    4.045551] i2c i2c-0: Autodetection failed: unsupported version
[    4.046633] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.047790] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D5c, =
DAT0=3Dff, DAT1=3Dff
[    4.056992] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D5c,=
 DAT0=3Dff, DAT1=3Dff
[    4.058407] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5d, =
DAT0=3Dff, DAT1=3Dff
[    4.061027] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5d,=
 DAT0=3Dff, DAT1=3Dff
[    4.062450] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3f, ADD=3D5d, =
DAT0=3Dff, DAT1=3Dff
[    4.064960] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3f, ADD=3D5d,=
 DAT0=3Dff, DAT1=3Dff
[    4.066348] i2c i2c-0: Detecting device at 0x2e with COMPANY: 0xff and V=
ERSTEP: 0xff
[    4.067749] i2c i2c-0: Autodetection failed: unsupported version
[    4.068858] i2c-core: driver [lm87] registered
[    4.069678] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.070828] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3f, ADD=3D58, =
DAT0=3Dff, DAT1=3Dff
[    4.074007] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3f, ADD=3D58,=
 DAT0=3Dff, DAT1=3Dff
[    4.075432] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D59, =
DAT0=3Dff, DAT1=3Dff
[    4.077710] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D59,=
 DAT0=3Dff, DAT1=3Dff
[    4.079093] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.080249] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D5a, =
DAT0=3Dff, DAT1=3Dff
[    4.082953] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D5a,=
 DAT0=3Dff, DAT1=3Dff
[    4.084371] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D5b, =
DAT0=3Dff, DAT1=3Dff
[    4.087222] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D5b,=
 DAT0=3Dff, DAT1=3Dff
[    4.088604] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.089759] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D5c, =
DAT0=3Dff, DAT1=3Dff
[    4.092829] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D5c,=
 DAT0=3Dff, DAT1=3Dff
[    4.094249] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D40, ADD=3D5d, =
DAT0=3Dff, DAT1=3Dff
[    4.097271] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D40, ADD=3D5d,=
 DAT0=3Dff, DAT1=3Dff
[    4.098687] i2c-core: driver [lm92] registered
[    4.099490] i2c i2c-0: found normal entry for adapter 0, addr 0x48
[    4.100639] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D40, ADD=3D90, =
DAT0=3Dff, DAT1=3Dff
[    4.103717] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D40, ADD=3D90,=
 DAT0=3Dff, DAT1=3Dff
[    4.105137] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D01, ADD=3D91, =
DAT0=3Dff, DAT1=3Dff
[    4.114951] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D01, ADD=3D91,=
 DAT0=3Dff, DAT1=3Dff
[    4.116376] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D91, =
DAT0=3Dff, DAT1=3Dff
[    4.118710] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D91,=
 DAT0=3Dff, DAT1=3Dff
[    4.120135] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D04, ADD=3D91, =
DAT0=3Dff, DAT1=3Dff
[    4.122711] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D04, ADD=3D91,=
 DAT0=3Dff, DAT1=3Dff
[    4.124133] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D91, =
DAT0=3Dff, DAT1=3Dff
[    4.126719] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D91,=
 DAT0=3Dff, DAT1=3Dff
[    4.128146] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D05, ADD=3D91, =
DAT0=3Dff, DAT1=3Dff
[    4.130924] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D05, ADD=3D91,=
 DAT0=3Dff, DAT1=3Dff
[    4.132349] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D91, =
DAT0=3Dff, DAT1=3Dff
[    4.134976] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D91,=
 DAT0=3Dff, DAT1=3Dff
[    4.136369] i2c i2c-0: found normal entry for adapter 0, addr 0x49
[    4.137523] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D92, =
DAT0=3Dff, DAT1=3Dff
[    4.139737] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D92,=
 DAT0=3Dff, DAT1=3Dff
[    4.141153] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D01, ADD=3D93, =
DAT0=3Dff, DAT1=3Dff
[    4.143714] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D01, ADD=3D93,=
 DAT0=3Dff, DAT1=3Dff
[    4.145138] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D93, =
DAT0=3Dff, DAT1=3Dff
[    4.147714] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D93,=
 DAT0=3Dff, DAT1=3Dff
[    4.149136] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D04, ADD=3D93, =
DAT0=3Dff, DAT1=3Dff
[    4.152418] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D04, ADD=3D93,=
 DAT0=3Dff, DAT1=3Dff
[    4.153850] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D93, =
DAT0=3Dff, DAT1=3Dff
[    4.156924] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D93,=
 DAT0=3Dff, DAT1=3Dff
[    4.158355] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D05, ADD=3D93, =
DAT0=3Dff, DAT1=3Dff
[    4.160894] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D05, ADD=3D93,=
 DAT0=3Dff, DAT1=3Dff
[    4.162325] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D93, =
DAT0=3Dff, DAT1=3Dff
[    4.164711] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D93,=
 DAT0=3Dff, DAT1=3Dff
[    4.166105] i2c i2c-0: found normal entry for adapter 0, addr 0x4a
[    4.167261] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D94, =
DAT0=3Dff, DAT1=3Dff
[    4.170715] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D94,=
 DAT0=3Dff, DAT1=3Dff
[    4.172128] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D01, ADD=3D95, =
DAT0=3Dff, DAT1=3Dff
[    4.174711] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D01, ADD=3D95,=
 DAT0=3Dff, DAT1=3Dff
[    4.176133] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D95, =
DAT0=3Dff, DAT1=3Dff
[    4.179510] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D95,=
 DAT0=3Dff, DAT1=3Dff
[    4.180956] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D04, ADD=3D95, =
DAT0=3Dff, DAT1=3Dff
[    4.185377] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D04, ADD=3D95,=
 DAT0=3Dff, DAT1=3Dff
[    4.186811] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D95, =
DAT0=3Dff, DAT1=3Dff
[    4.189707] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D95,=
 DAT0=3Dff, DAT1=3Dff
[    4.191138] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D05, ADD=3D95, =
DAT0=3Dff, DAT1=3Dff
[    4.194117] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D05, ADD=3D95,=
 DAT0=3Dff, DAT1=3Dff
[    4.195545] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D95, =
DAT0=3Dff, DAT1=3Dff
[    4.197711] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D95,=
 DAT0=3Dff, DAT1=3Dff
[    4.199102] i2c i2c-0: found normal entry for adapter 0, addr 0x4b
[    4.200269] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D96, =
DAT0=3Dff, DAT1=3Dff
[    4.204447] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D96,=
 DAT0=3Dff, DAT1=3Dff
[    4.205871] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D01, ADD=3D97, =
DAT0=3Dff, DAT1=3Dff
[    4.208711] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D01, ADD=3D97,=
 DAT0=3Dff, DAT1=3Dff
[    4.210127] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D97, =
DAT0=3Dff, DAT1=3Dff
[    4.212909] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D97,=
 DAT0=3Dff, DAT1=3Dff
[    4.214339] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D04, ADD=3D97, =
DAT0=3Dff, DAT1=3Dff
[    4.216714] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D04, ADD=3D97,=
 DAT0=3Dff, DAT1=3Dff
[    4.218145] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D97, =
DAT0=3Dff, DAT1=3Dff
[    4.220709] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D97,=
 DAT0=3Dff, DAT1=3Dff
[    4.222137] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D05, ADD=3D97, =
DAT0=3Dff, DAT1=3Dff
[    4.225272] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D05, ADD=3D97,=
 DAT0=3Dff, DAT1=3Dff
[    4.226716] i2c i2c-0: Transaction (pre): CNT=3D0c, CMD=3D07, ADD=3D97, =
DAT0=3Dff, DAT1=3Dff
[    4.230133] i2c i2c-0: Transaction (post): CNT=3D0c, CMD=3D07, ADD=3D97,=
 DAT0=3Dff, DAT1=3Dff
[    4.231537] i2c-core: driver [lm95241] registered
[    4.232407] i2c i2c-0: found normal entry for adapter 0, addr 0x19
[    4.233569] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D07, ADD=3D32, =
DAT0=3Dff, DAT1=3Dff
[    4.236706] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D07, ADD=3D32,=
 DAT0=3Dff, DAT1=3Dff
[    4.238132] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D33, =
DAT0=3Dff, DAT1=3Dff
[    4.241440] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D33,=
 DAT0=3Dff, DAT1=3Dff
[    4.242826] i2c i2c-0: found normal entry for adapter 0, addr 0x2a
[    4.243813] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D54, =
DAT0=3Dff, DAT1=3Dff
[    4.247062] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D54,=
 DAT0=3Dff, DAT1=3Dff
[    4.248487] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D55, =
DAT0=3Dff, DAT1=3Dff
[    4.251229] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D55,=
 DAT0=3Dff, DAT1=3Dff
[    4.252614] i2c i2c-0: found normal entry for adapter 0, addr 0x2b
[    4.253771] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D56, =
DAT0=3Dff, DAT1=3Dff
[    4.256710] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D56,=
 DAT0=3Dff, DAT1=3Dff
[    4.258124] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D57, =
DAT0=3Dff, DAT1=3Dff
[    4.261021] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D57,=
 DAT0=3Dff, DAT1=3Dff
[    4.262419] i2c-core: driver [max6642] registered
[    4.263280] i2c i2c-0: found normal entry for adapter 0, addr 0x48
[    4.264428] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D90, =
DAT0=3Dff, DAT1=3Dff
[    4.267335] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D90,=
 DAT0=3Dff, DAT1=3Dff
[    4.268749] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D91, =
DAT0=3Dff, DAT1=3Dff
[    4.271705] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D91,=
 DAT0=3Dff, DAT1=3Dff
[    4.273102] i2c i2c-0: found normal entry for adapter 0, addr 0x49
[    4.274255] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D92, =
DAT0=3Dff, DAT1=3Dff
[    4.276707] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D92,=
 DAT0=3Dff, DAT1=3Dff
[    4.278122] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D93, =
DAT0=3Dff, DAT1=3Dff
[    4.280736] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D93,=
 DAT0=3Dff, DAT1=3Dff
[    4.282125] i2c i2c-0: found normal entry for adapter 0, addr 0x4a
[    4.283279] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D94, =
DAT0=3Dff, DAT1=3Dff
[    4.287286] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D94,=
 DAT0=3Dff, DAT1=3Dff
[    4.288709] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D95, =
DAT0=3Dff, DAT1=3Dff
[    4.292470] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D95,=
 DAT0=3Dff, DAT1=3Dff
[    4.293851] i2c i2c-0: found normal entry for adapter 0, addr 0x4b
[    4.294838] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D96, =
DAT0=3Dff, DAT1=3Dff
[    4.297708] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D96,=
 DAT0=3Dff, DAT1=3Dff
[    4.299125] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D97, =
DAT0=3Dff, DAT1=3Dff
[    4.302052] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D97,=
 DAT0=3Dff, DAT1=3Dff
[    4.303435] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    4.304596] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D98, =
DAT0=3Dff, DAT1=3Dff
[    4.307710] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D98,=
 DAT0=3Dff, DAT1=3Dff
[    4.309125] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D99, =
DAT0=3Dff, DAT1=3Dff
[    4.311717] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D99,=
 DAT0=3Dff, DAT1=3Dff
[    4.313102] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    4.314255] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D9a, =
DAT0=3Dff, DAT1=3Dff
[    4.316700] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D9a,=
 DAT0=3Dff, DAT1=3Dff
[    4.318115] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D9b, =
DAT0=3Dff, DAT1=3Dff
[    4.320710] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D9b,=
 DAT0=3Dff, DAT1=3Dff
[    4.322091] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[    4.323239] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D9c, =
DAT0=3Dff, DAT1=3Dff
[    4.326019] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D9c,=
 DAT0=3Dff, DAT1=3Dff
[    4.327436] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D9d, =
DAT0=3Dff, DAT1=3Dff
[    4.329948] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D9d,=
 DAT0=3Dff, DAT1=3Dff
[    4.331329] i2c i2c-0: found normal entry for adapter 0, addr 0x4f
[    4.332482] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D9e, =
DAT0=3Dff, DAT1=3Dff
[    4.335191] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D9e,=
 DAT0=3Dff, DAT1=3Dff
[    4.336604] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D9f, =
DAT0=3Dff, DAT1=3Dff
[    4.339811] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D9f,=
 DAT0=3Dff, DAT1=3Dff
[    4.341224] sch56xx_common: Unsupported device id: 0xff
[    4.342196] sch56xx_common: Unsupported device id: 0xff
[    4.343338] i2c-core: driver [smm665] registered
[    4.344247] i2c-core: driver [amc6821] registered
[    4.345109] i2c i2c-0: found normal entry for adapter 0, addr 0x18
[    4.346271] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D30, =
DAT0=3Dff, DAT1=3Dff
[    4.349719] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D30,=
 DAT0=3Dff, DAT1=3Dff
[    4.351101] i2c i2c-0: amc6821_detect called.
[    4.351934] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D31, =
DAT0=3Dff, DAT1=3Dff
[    4.354770] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    4.356195] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D31, =
DAT0=3Dff, DAT1=3Dff
[    4.358721] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D31,=
 DAT0=3Dff, DAT1=3Dff
[    4.360104] i2c i2c-0: amc6821: detection failed at 0x18.
[    4.361083] i2c i2c-0: found normal entry for adapter 0, addr 0x19
[    4.362242] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D32, =
DAT0=3Dff, DAT1=3Dff
[    4.364709] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D32,=
 DAT0=3Dff, DAT1=3Dff
[    4.366087] i2c i2c-0: amc6821_detect called.
[    4.366917] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D33, =
DAT0=3Dff, DAT1=3Dff
[    4.405305] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D33,=
 DAT0=3Dff, DAT1=3Dff
[    4.406732] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D33, =
DAT0=3Dff, DAT1=3Dff
[    4.409700] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D33,=
 DAT0=3Dff, DAT1=3Dff
[    4.411083] i2c i2c-0: amc6821: detection failed at 0x19.
[    4.412063] i2c i2c-0: found normal entry for adapter 0, addr 0x1a
[    4.413215] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D34, =
DAT0=3Dff, DAT1=3Dff
[    4.416028] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D34,=
 DAT0=3Dff, DAT1=3Dff
[    4.417402] i2c i2c-0: amc6821_detect called.
[    4.418244] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D35, =
DAT0=3Dff, DAT1=3Dff
[    4.420700] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D35,=
 DAT0=3Dff, DAT1=3Dff
[    4.422124] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D35, =
DAT0=3Dff, DAT1=3Dff
[    4.424704] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D35,=
 DAT0=3Dff, DAT1=3Dff
[    4.426086] i2c i2c-0: amc6821: detection failed at 0x1a.
[    4.427064] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.428220] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D58, =
DAT0=3Dff, DAT1=3Dff
[    4.430699] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D58,=
 DAT0=3Dff, DAT1=3Dff
[    4.432080] i2c i2c-0: amc6821_detect called.
[    4.432911] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D59, =
DAT0=3Dff, DAT1=3Dff
[    4.435899] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D59,=
 DAT0=3Dff, DAT1=3Dff
[    4.437330] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D59, =
DAT0=3Dff, DAT1=3Dff
[    4.439699] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D59,=
 DAT0=3Dff, DAT1=3Dff
[    4.441095] i2c i2c-0: amc6821: detection failed at 0x2c.
[    4.442075] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.443229] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D5a, =
DAT0=3Dff, DAT1=3Dff
[    4.446029] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D5a,=
 DAT0=3Dff, DAT1=3Dff
[    4.447405] i2c i2c-0: amc6821_detect called.
[    4.448249] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D5b, =
DAT0=3Dff, DAT1=3Dff
[    4.458302] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D5b,=
 DAT0=3Dff, DAT1=3Dff
[    4.459724] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5b, =
DAT0=3Dff, DAT1=3Dff
[    4.462717] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5b,=
 DAT0=3Dff, DAT1=3Dff
[    4.464104] i2c i2c-0: amc6821: detection failed at 0x2d.
[    4.465088] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.466238] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D5c, =
DAT0=3Dff, DAT1=3Dff
[    4.468764] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D5c,=
 DAT0=3Dff, DAT1=3Dff
[    4.470145] i2c i2c-0: amc6821_detect called.
[    4.470986] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D5d, =
DAT0=3Dff, DAT1=3Dff
[    4.473699] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D5d,=
 DAT0=3Dff, DAT1=3Dff
[    4.475125] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D5d, =
DAT0=3Dff, DAT1=3Dff
[    4.477702] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D5d,=
 DAT0=3Dff, DAT1=3Dff
[    4.479088] i2c i2c-0: amc6821: detection failed at 0x2e.
[    4.480068] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    4.481227] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D98, =
DAT0=3Dff, DAT1=3Dff
[    4.483698] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D98,=
 DAT0=3Dff, DAT1=3Dff
[    4.485080] i2c i2c-0: amc6821_detect called.
[    4.485918] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D99, =
DAT0=3Dff, DAT1=3Dff
[    4.497195] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D99,=
 DAT0=3Dff, DAT1=3Dff
[    4.498627] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D99, =
DAT0=3Dff, DAT1=3Dff
[    4.501862] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D99,=
 DAT0=3Dff, DAT1=3Dff
[    4.503254] i2c i2c-0: amc6821: detection failed at 0x4c.
[    4.504233] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    4.505386] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D9a, =
DAT0=3Dff, DAT1=3Dff
[    4.507813] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D9a,=
 DAT0=3Dff, DAT1=3Dff
[    4.509190] i2c i2c-0: amc6821_detect called.
[    4.510026] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D9b, =
DAT0=3Dff, DAT1=3Dff
[    4.512696] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D9b,=
 DAT0=3Dff, DAT1=3Dff
[    4.514118] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D9b, =
DAT0=3Dff, DAT1=3Dff
[    4.516704] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D9b,=
 DAT0=3Dff, DAT1=3Dff
[    4.518089] i2c i2c-0: amc6821: detection failed at 0x4d.
[    4.519072] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[    4.520221] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D9c, =
DAT0=3Dff, DAT1=3Dff
[    4.522700] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D9c,=
 DAT0=3Dff, DAT1=3Dff
[    4.524080] i2c i2c-0: amc6821_detect called.
[    4.524911] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3d, ADD=3D9d, =
DAT0=3Dff, DAT1=3Dff
[    4.527818] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3d, ADD=3D9d,=
 DAT0=3Dff, DAT1=3Dff
[    4.529247] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3D3e, ADD=3D9d, =
DAT0=3Dff, DAT1=3Dff
[    4.532497] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3D3e, ADD=3D9d,=
 DAT0=3Dff, DAT1=3Dff
[    4.533887] i2c i2c-0: amc6821: detection failed at 0x4e.
[    4.534874] i2c-core: driver [tmp401] registered
[    4.534874] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    4.534874] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3D3e, ADD=3D98, =
DAT0=3Dff, DAT1=3Dff
[    4.539698] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3D3e, ADD=3D98,=
 DAT0=3Dff, DAT1=3Dff
[    4.541116] i2c i2c-0: Transaction (pre): CNT=3D08, CMD=3Dfe, ADD=3D99, =
DAT0=3Dff, DAT1=3Dff
[    4.543944] i2c i2c-0: Transaction (post): CNT=3D08, CMD=3Dfe, ADD=3D99,=
 DAT0=3Dff, DAT1=3Dff
[    4.545450] i2c-core: driver [lm25066] registered
[    4.546389] i2c-core: driver [max34440] registered
[    4.547285] i2c-core: driver [max8688] registered
[    4.548163] i2c-core: driver [ucd9000] registered
[    4.549040] i2c-core: driver [zl6100] registered
[    4.549880] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    4.551457] acquirewdt: I/O address 0x0043 already in use
[    4.552448] acquirewdt: probe of acquirewdt failed with error -5
[    4.553540] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    4.555490] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    4.556701] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[    4.557881] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    4.559302] wafer5823wdt: I/O address 0x0443 already in use
[    4.560470] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    4.561796] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[    4.562984] i6300ESB timer: probe of 0000:00:0b.0 failed with error -16
[    4.564191] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    4.565220] iTCO_vendor_support: vendor-support=3D0
[    4.566074] sc1200wdt: build 20020303
[    4.566766] sc1200wdt: io parameter must be specified
[    4.567702] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    4.568745] sbc8360: failed to register misc device
[    4.569648] cpu5wdt: misc_register failed
[    4.570376] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    4.572877] smsc37b787_wdt: Unable to register miscdev on minor 130
[    4.574010] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    4.575127] w83697hf_wdt: watchdog not found at address 0x2e
[    4.576149] w83697hf_wdt: No W83697HF/HG could be found
[    4.577095] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    4.578679] w83697ug_wdt: No W83697UG/UF could be found
[    4.579613] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    4.579653] machzwd: no ZF-Logic found
[    4.579653] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    4.582664] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    4.584121] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    4.589149] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    4.591138] Bluetooth: HCI UART driver ver 2.2
[    4.591953] Bluetooth: HCI H4 protocol initialized
[    4.592824] Bluetooth: HCILL protocol initialized
[    4.595033] i2c-core: driver [lm3530-led] registered
[    4.595968] i2c-core: driver [lp3944] registered
[    4.596886] i2c-core: driver [lp5523x] registered
[    4.597788] i2c-core: driver [leds-tca6507] registered
[    4.598790] leds_ss4200: no LED devices found
[    4.599596] i2c-core: driver [leds-lm355x] registered
[    4.600598] i2c-core: driver [blinkm] registered
[    4.601451] i2c i2c-0: found normal entry for adapter 0, addr 0x09
[    4.602613] i2c i2c-0: Transaction (pre): CNT=3D00, CMD=3Dfe, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    4.605894] i2c i2c-0: Transaction (post): CNT=3D00, CMD=3Dfe, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    4.607312] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    4.609772] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    4.622698] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    4.627405] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    4.639694] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    4.642700] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    4.686616] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    4.690739] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    4.703692] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    4.706698] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    4.742432] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    4.747764] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    4.765083] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    4.767690] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    4.783389] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    4.785687] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    4.798690] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    4.801683] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    4.830881] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    4.833774] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    4.847226] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    4.850287] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    4.862688] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    4.865857] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    4.879160] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    4.881687] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    4.907241] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    4.909686] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    4.922687] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    4.925779] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    4.938680] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    4.941692] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    4.982826] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    4.985797] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.004364] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.007209] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.029823] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.032693] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.046498] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.048677] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.061810] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.064682] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.091642] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.094681] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.107672] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.110685] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.128960] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.131823] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.145388] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.147672] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.163903] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.166676] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.179678] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.182682] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.209994] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.212674] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.225670] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.228673] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.241674] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.245120] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.286085] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.288672] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.301814] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.304749] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.317956] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.320668] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.347344] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.349779] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.362664] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.365672] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.396000] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.398665] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.413748] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.416671] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.429667] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.433202] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.445691] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.448669] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.477037] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.479720] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.498161] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.500665] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.513664] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.516737] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.535160] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.537667] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.550657] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.553667] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.566662] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.569660] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.599021] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.602287] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.614661] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.617794] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.630671] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.634315] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.646660] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.650929] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.663660] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.666661] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.709937] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.712841] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.725651] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.728663] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.748303] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.750652] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.763656] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.766952] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.789872] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.792653] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.805649] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.808658] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.836682] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.839652] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.852651] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.855654] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.909129] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.911706] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.943947] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.947297] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.964399] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    5.967084] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    5.979638] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    5.982943] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    5.999684] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.002647] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.027389] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.030131] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.042637] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.045653] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.058640] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.061644] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.093416] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.098127] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.110644] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.113648] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.134728] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.138386] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.161321] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.164129] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.176643] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.179639] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.192630] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.196202] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.218208] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.221671] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.234634] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.237641] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.258482] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.261694] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.274634] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.277637] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.304746] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.307668] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.320631] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.336359] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.349931] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.352636] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.366927] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.369860] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.382916] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.385633] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.398636] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.401646] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.435377] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.437628] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.450620] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.468533] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.483995] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.486648] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.499753] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.503000] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.515996] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.518963] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.531631] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.534742] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.566225] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.568623] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.582635] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.585622] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.603381] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.606087] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.619633] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.622630] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.635627] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.638827] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.651615] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.654632] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.686474] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.688617] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.701929] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.704627] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.717963] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.721241] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.739587] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.742613] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.762478] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.765686] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.778735] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.781619] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.802599] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.805619] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.817619] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.820741] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.833614] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.836615] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.848620] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.852257] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.900232] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.907489] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.927488] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.929789] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.947133] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.949607] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.961603] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    6.964617] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    6.980601] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    6.983619] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    6.996603] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.009991] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.024597] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.027608] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.039608] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.042616] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.075475] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.078849] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.092424] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.094609] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.107603] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.110985] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.123661] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.126614] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.148402] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.150632] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.170383] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.172602] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.186363] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.188597] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.202445] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.204600] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.218061] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.220597] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.266246] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.268594] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.282918] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.285594] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.301405] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.303596] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.349311] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.351595] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.365785] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.368617] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.381591] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.384614] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.417659] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.420606] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.468300] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.480228] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.492591] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.495601] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.507588] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.510606] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.552350] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.554591] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.568335] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.570596] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.584651] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.587600] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.599594] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.602606] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.636746] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.639603] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.655937] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.658583] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.674494] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.677584] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.723458] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.725586] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.738856] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.741581] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.787316] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.789577] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.803650] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.806591] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.818582] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.821596] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.856020] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.858574] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.873902] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.876578] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.892552] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.895581] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.907577] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.910582] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    7.947649] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    7.950580] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    7.962576] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    7.965591] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.000071] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.002580] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.017583] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.020579] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.032566] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.035586] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.069323] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.071567] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.085498] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.088565] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.106438] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.108569] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.121985] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.124565] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.140100] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.142568] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.188289] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.190561] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.204564] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.207573] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.219554] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.222584] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.260947] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.263559] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.279155] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.281559] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.327329] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.329562] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.343326] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.346584] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.358561] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.361575] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.405340] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.407559] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.421849] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.424566] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.441038] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.443554] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.475040] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.477556] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.493314] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.495553] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.510143] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.512553] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.527773] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.530559] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.575284] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.577551] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.592005] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.594552] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.610218] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.612551] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.658325] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.660546] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.674853] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.677544] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.693975] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.696546] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.741286] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.743542] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.757851] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.760545] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.777072] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.779545] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.825343] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.827541] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.841642] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.844549] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.889313] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.891550] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.905891] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.908538] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.924958] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.927534] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    8.943529] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    8.952604] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    8.964532] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    8.967543] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    9.004880] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    9.007533] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    9.024033] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    9.026533] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    9.042122] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    9.044537] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    9.059833] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    9.062531] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    9.074534] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    9.097207] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    9.109719] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    9.112535] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    9.158205] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    9.160530] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    9.175262] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    9.177529] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    9.192233] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    9.194528] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    9.209151] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    9.212535] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    9.224524] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D12, =
DAT0=3Dff, DAT1=3Dff
[    9.227530] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D12,=
 DAT0=3Dff, DAT1=3Dff
[    9.271239] i2c i2c-0: Transaction (pre): CNT=3D04, CMD=3D61, ADD=3D13, =
DAT0=3Dff, DAT1=3Dff
[    9.273525] i2c i2c-0: Transaction (post): CNT=3D04, CMD=3D61, ADD=3D13,=
 DAT0=3Dff, DAT1=3Dff
[    9.274865]  (null): enodev DEV ADDR =3D 0xFF
[    9.275655] ledtrig-cpu: registered to indicate activity on CPUs
[    9.276703] EFI Variables Facility v0.08 2004-May-17
[    9.278334] i2c-core: driver [ad7291] registered
[    9.279191] i2c-core: driver [ad7150] registered
[    9.280073] i2c-core: driver [ad7152] registered
[    9.280955] i2c-core: driver [ad5933] registered
[    9.281877] i2c-core: driver [tsl2563] registered
[    9.282743] i2c-core: driver [tsl2583] registered
[    9.283696] Loading crystalhd 0.9.27
[    9.284426] MULTI INIT
[    9.285733] msi_laptop: Brightness ignored, must be controlled by ACPI v=
ideo driver
[    9.287191] dell_wmi: No known WMI GUID found
[    9.287963] acer_wmi: Acer Laptop ACPI-WMI Extras
[    9.288788] acer_wmi: No or unsupported WMI interface, unable to load
[    9.289902] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[    9.290850] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[    9.292526] hdaps: supported laptop not found!
[    9.293295] hdaps: driver init failed (ret=3D-19)!
[    9.294586] fujitsu_laptop: driver 0.6.0 successfully loaded
[    9.295598] fujitsu_tablet: Unknown (using defaults)
[    9.296516] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[    9.298107] intel_oaktrail: Platform not recognized (You could try the m=
odule's force-parameter)
[    9.299636] hv_vmbus: registering driver hv_balloon
[    9.300627] i2c-core: driver [max1363] registered
[    9.301476] i2c-core: driver [adc081c] registered
[    9.302337] i2c-core: driver [ad5380] registered
[    9.303242] i2c-core: driver [ad5064] registered
[    9.304084] i2c-core: driver [ad5446] registered
[    9.304999] i2c-core: driver [adjd_s311] registered
[    9.305978] netem: version 1.3
[    9.306547] NET: Registered protocol family 17
[    9.309505] NET: Registered protocol family 11
[    9.310317] NET: Registered protocol family 3
[    9.311092] can: controller area network core (rev 20120528 abi 9)
[    9.312181] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[    9.313356] NET: Registered protocol family 29
[    9.314141] can: netlink gateway (rev 20101209)
[    9.315408] IrCOMM protocol (Dag Brattli)
[    9.323252] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    9.324194] Bluetooth: BNEP filters: multicast
[    9.324977] Bluetooth: BNEP socket layer initialized
[    9.325852] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    9.326880] Bluetooth: HIDP socket layer initialized
[    9.328569] batman_adv: B.A.T.M.A.N. advanced 2012.5.0 (compatibility ve=
rsion 14) loaded
[    9.329982] openvswitch: Open vSwitch switching datapath
[    9.331447]=20
[    9.331447] printing PIC contents
[    9.332294] ... PIC  IMR: ffff
[    9.332839] ... PIC  IRR: 1013
[    9.333405] ... PIC  ISR: 0000
[    9.333967] ... PIC ELCR: 0c00
[    9.334521] printing local APIC contents on CPU#0/0:
[    9.335375] ... APIC ID:      00000000 (0)
[    9.335506] ... APIC VERSION: 00050014
[    9.335506] ... APIC TASKPRI: 00000000 (00)
[    9.335506] ... APIC PROCPRI: 00000000
[    9.335506] ... APIC LDR: 01000000
[    9.335506] ... APIC DFR: ffffffff
[    9.335506] ... APIC SPIV: 000001ff
[    9.335506] ... APIC ISR field:
[    9.335506] 000000000000000000000000000000000000000000000000000000000000=
0000
[    9.335506] ... APIC TMR field:
[    9.335506] 000000000000000000000000000000000000000000000000000000000000=
0000
[    9.335506] ... APIC IRR field:
[    9.335506] 000000000000000000000000000000000000000000000000000000000000=
8000
[    9.335506] ... APIC ESR: 00000000
[    9.335506] ... APIC ICR: 00000831
[    9.335506] ... APIC ICR2: 01000000
[    9.335506] ... APIC LVTT: 000200ef
[    9.335506] ... APIC LVTPC: 00010000
[    9.335506] ... APIC LVT0: 00010700
[    9.335506] ... APIC LVT1: 00000400
[    9.335506] ... APIC LVTERR: 000000fe
[    9.335506] ... APIC TMICT: 0000f423
[    9.335506] ... APIC TMCCT: 0000e2e9
[    9.335506] ... APIC TDCR: 00000003
[    9.335506]=20
[    9.353055] number of MP IRQ sources: 15.
[    9.353752] number of IO-APIC #2 registers: 24.
[    9.354051] testing the IO APIC.......................
[    9.355475] IO APIC #2......
[    9.355983] .... register #00: 00000000
[    9.356468] .......    : physical APIC id: 00
[    9.357416] .......    : Delivery Type: 0
[    9.358126] .......    : LTS          : 0
[    9.358833] .... register #01: 00170011
[    9.359516] .......     : max redirection entries: 17
[    9.360384] .......     : PRQ implemented: 0
[    9.361136] .......     : IO APIC version: 11
[    9.361904] .... register #02: 00000000
[    9.362580] .......     : arbitration: 00
[    9.363285] .... IRQ redirection table:
[    9.363961]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    9.364931]  00 00  1    0    0   0   0    0    0    00
[    9.365884]  01 01  0    0    0   0   0    1    1    31
[    9.366836]  02 01  0    0    0   0   0    1    1    30
[    9.367783]  03 01  0    0    0   0   0    1    1    33
[    9.368735]  04 01  1    0    0   0   0    1    1    34
[    9.369687]  05 01  1    1    0   0   0    1    1    35
[    9.370642]  06 01  0    0    0   0   0    1    1    36
[    9.371595]  07 01  0    0    0   0   0    1    1    37
[    9.372550]  08 01  0    0    0   0   0    1    1    38
[    9.373498]  09 01  0    1    0   0   0    1    1    39
[    9.374437]  0a 01  1    1    0   0   0    1    1    3A
[    9.375405]  0b 01  1    1    0   0   0    1    1    3B
[    9.376359]  0c 01  0    0    0   0   0    1    1    3C
[    9.377315]  0d 01  0    0    0   0   0    1    1    3D
[    9.378271]  0e 01  0    0    0   0   0    1    1    3E
[    9.379223]  0f 01  0    0    0   0   0    1    1    3F
[    9.380176]  10 00  1    0    0   0   0    0    0    00
[    9.381129]  11 00  1    0    0   0   0    0    0    00
[    9.382079]  12 00  1    0    0   0   0    0    0    00
[    9.383032]  13 00  1    0    0   0   0    0    0    00
[    9.383985]  14 00  1    0    0   0   0    0    0    00
[    9.384947]  15 00  1    0    0   0   0    0    0    00
[    9.385899]  16 00  1    0    0   0   0    0    0    00
[    9.386855]  17 00  1    0    0   0   0    0    0    00
[    9.387786] IRQ to pin mappings:
[    9.388358] IRQ0 -> 0:2
[    9.388868] IRQ1 -> 0:1
[    9.389352] IRQ3 -> 0:3
[    9.389856] IRQ4 -> 0:4
[    9.390341] IRQ5 -> 0:5
[    9.390839] IRQ6 -> 0:6
[    9.391333] IRQ7 -> 0:7
[    9.391830] IRQ8 -> 0:8
[    9.392321] IRQ9 -> 0:9
[    9.392820] IRQ10 -> 0:10
[    9.393345] IRQ11 -> 0:11
[    9.393880] IRQ12 -> 0:12
[    9.394394] IRQ13 -> 0:13
[    9.394925] IRQ14 -> 0:14
[    9.395437] IRQ15 -> 0:15
[    9.395972] .................................... done.
[    9.404713] PM: Hibernation image not present or could not be loaded.
[    9.405857] IMA: No TPM chip found, activating TPM-bypass!
[    9.407638] dmaengine: __dma_request_channel: fail ((null))
[    9.408758] i2c-core: driver [wl1273-fm] registered
[    9.409635] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    9.412107] debug: unmapping init [mem 0xffffffff81f29000-0xffffffff81fc=
9fff]
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   31.165995] warning: process `trinity-child0' used the deprecated sysctl=
 system call with=20
[   32.128335] CPA self-test:
[   32.131860]  4k 65534 large 0 gb 0 x 65529[ffff880000000000-ffff88000fff=
d000] miss 0
[   32.150657]  4k 65534 large 0 gb 0 x 65529[ffff880000000000-ffff88000fff=
d000] miss 0
[   32.167187]  4k 65534 large 0 gb 0 x 65529[ffff880000000000-ffff88000fff=
d000] miss 0
[   32.168655] ok.
[   43.409959] ------------[ cut here ]------------
[   43.410048] kernel BUG at /c/kernel-tests/src/stable/block/blk-core.c:29=
81!
[   43.410048] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[   43.410048] CPU 0=20
[   43.410048] Pid: 144, comm: trinity-child0 Not tainted 3.8.0-rc3-05057-g=
17e836d #10 Bochs Bochs
[   43.410048] RIP: 0010:[<ffffffff812c913a>]  [<ffffffff812c913a>] blk_flu=
sh_plug_list+0x47/0x285
[   43.410048] RSP: 0018:ffff880005ca1e08  EFLAGS: 00010202
[   43.410048] RAX: 0000000000000000 RBX: ffff880005ca1f20 RCX: 0000000a1b6=
ecfc4
[   43.410048] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81e=
f8a28
[   43.410048] RBP: ffff880005ca1e68 R08: 00000000ab1758f2 R09: 00000000000=
00000
[   43.410048] R10: 0000000000000246 R11: 0000000000000246 R12: 00000000000=
00001
[   43.410048] R13: 000000000000000b R14: 0000000000000000 R15: 4346331c5a4=
b1a16
[   43.410048] FS:  00007f1a35606700(0000) GS:ffffffff81bf1000(0000) knlGS:=
0000000000000000
[   43.410048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.410048] CR2: 000000000099ead0 CR3: 0000000006a0a000 CR4: 00000000000=
006b0
[   43.410048] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   43.410048] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[   43.410048] Process trinity-child0 (pid: 144, threadinfo ffff880005ca000=
0, task ffff8800061656e0)
[   43.410048] Stack:
[   43.410048]  0000000105ca1e48 0000000000000282 ffff880005ca1e18 ffff8800=
05ca1e18
[   43.410048]  ffff880006091d90 ffffffff00000001 043308412d708618 ffff8800=
05ca1f20
[   43.410048]  0000000000000000 000000000000000b 0000000001b3c000 4346331c=
5a4b1a16
[   43.410048] Call Trace:
[   43.410048]  [<ffffffff812c9730>] blk_finish_plug+0x10/0x30
[   43.410048]  [<ffffffff81112be5>] sys_madvise+0x4f6/0x571
[   43.410048]  [<ffffffff817f83ea>] ? _raw_spin_unlock_irq+0x40/0x60
[   43.410048]  [<ffffffff8106e471>] ? do_setitimer+0x227/0x27c
[   43.410048]  [<ffffffff812e7849>] ? lockdep_sys_exit_thunk+0x35/0x67
[   43.410048]  [<ffffffff817f9927>] system_call_fastpath+0x16/0x1b
[   43.410048] Code: 48 89 45 b0 48 89 45 b8 b8 64 73 82 91 48 39 07 48 c7 =
c7 28 8a ef 81 41 0f 95 c4 31 d2 41 0f b6 f4 e8 fe 08 e1 ff 45 84 e4 74 02 =
<0f> 0b 48 8d 45 c0 48 89 45 c0 48 89 45 c8 49 89 c4 eb 5c 48 8b=20
[   43.410048] RIP  [<ffffffff812c913a>] blk_flush_plug_list+0x47/0x285
[   43.410048]  RSP <ffff880005ca1e08>
[   43.449912] ---[ end trace a4f8652aa0ea5758 ]---
[   43.450746] Kernel panic - not syncing: Fatal exception
[   43.450906] Rebooting in 10 seconds..
--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="17e836d-bisect.log"

bisect: skip 62d2a771c8043af093882feb1d73287c96ffab77: not a good merge base
git checkout v3.7

2013-01-16-09:59:36 29594404d7fe73cd80eaa4ee8c43dcc53970c60e compiling
/home/wfg/tip

2013-01-16-10:02:21 detecting boot state 3.7.0-bisect2 #6 1.2.3.4..5.......6.....7..............................OK 8..OK 910..OK .11OK .12OK .13OK .14....OK 15....OK 16.....OK 17..............................OK  SUCCESS
bisect: good commit v3.7
git bisect start 17e836d90690666d81376c1f4662aaa6a2829f9c v3.7 --
Bisecting: 8672 revisions left to test after this (roughly 13 steps)
[7764b5282e7e04ede3020d86787122887840e016] hwmon: (twl4030-madc-hwmon) Fix warning message caused by removal of __devexit
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-10:05:48 7764b5282e7e04ede3020d86787122887840e016 compiling
2013-01-16-10:07:56 7764b5282e7e04ede3020d86787122887840e016 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 8672 revisions left to test after this (roughly 13 steps)
[10c39f1d717d3e5e8bcb2998f7dee4362edda26a] staging: line6: drop MIDI from CONFIG_LINE6_USB_DUMP_ANY
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-10:08:20 10c39f1d717d3e5e8bcb2998f7dee4362edda26a compiling
/home/wfg/tip

2013-01-16-10:11:02 detecting boot state 3.7.0-rc5-bisect2-00932-g10c39f1 #1 .................1..23..4..56..7.....8...9.....10...............................OK 11..OK .12.OK .13..OK .14.....OK .15..OK 16..OK .17.....OK 18..............................OK .19.OK  SUCCESS
Bisecting: 7947 revisions left to test after this (roughly 13 steps)
[3c2e81ef344a90bb0a39d84af6878b4aeff568a2] Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-10:14:46 3c2e81ef344a90bb0a39d84af6878b4aeff568a2 compiling
2013-01-16-10:16:55 3c2e81ef344a90bb0a39d84af6878b4aeff568a2 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7947 revisions left to test after this (roughly 13 steps)
[fe36a0b2b55c66f25407cc1f713b631bf7da75fa] ASoC: Ux500: Fixup use of clocks
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-10:17:11 fe36a0b2b55c66f25407cc1f713b631bf7da75fa compiling
/home/wfg/tip

2013-01-16-10:20:08 detecting boot state 3.7.0-rc2-bisect2-00001-gfe36a0b #1 ....................................................................OK ..OK ....OK .123............................................................OK .4.OK .OK 567.......................................................OK .8..................................................................................................................................................................................OK ..............................OK .910.........................................................OK  SUCCESS
Bisecting: 7947 revisions left to test after this (roughly 13 steps)
[0dfeada90989833d0144b4df25d2b9ce3746624f] Merge tag 'orion_dt_for_3.8' of git://git.infradead.org/users/jcooper/linux into next/dt
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-10:31:54 0dfeada90989833d0144b4df25d2b9ce3746624f compiling
/home/wfg/tip

2013-01-16-10:34:40 detecting boot state 3.7.0-rc6-bisect2-00518-g0dfeada #2 ..........................................12...................................................................................OK .3...45..............................................................................................................OK ...............................6.............................7OK .89...................................................................OK .........10............................................................OK .OK 1112OK .OK .1314........................................................OK .OK  SUCCESS
Bisecting: 7947 revisions left to test after this (roughly 13 steps)
[d078fde369d175eb188c92df07c3163079d8beab] Staging: bcm: Remove typedef for _LEDColors and call directly.
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-10:47:34 d078fde369d175eb188c92df07c3163079d8beab compiling
2013-01-16-10:49:45 d078fde369d175eb188c92df07c3163079d8beab SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7947 revisions left to test after this (roughly 13 steps)
[c299dd0e2d3dd61d0048a9d9b021aa01f023ed0c] CIFS: Fix write after setting a read lock for read oplock files
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-10:50:03 c299dd0e2d3dd61d0048a9d9b021aa01f023ed0c compiling
/home/wfg/tip

2013-01-16-10:53:05 detecting boot state 3.7.0-rc8-bisect2-00057-gc299dd0 #1 ..................1...2.3..45..6..78...........................................OK .9..OK .10OK 11...OK 12OK 13..OK 14..OK .OK .1516.........................................OK 17....OK  SUCCESS
Bisecting: 7923 revisions left to test after this (roughly 13 steps)
[9360b53661a2c7754517b2925580055bacc8ec38] Revert "bdi: add a user-tunable cpu_list for the bdi flusher threads"
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-10:56:53 9360b53661a2c7754517b2925580055bacc8ec38 compiling
2013-01-16-10:58:56 9360b53661a2c7754517b2925580055bacc8ec38 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7923 revisions left to test after this (roughly 13 steps)
[a8b691e6104e6bd27070b6ed6622d0b640707fa8] iwlwifi: request IRQ only once
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-10:59:08 a8b691e6104e6bd27070b6ed6622d0b640707fa8 compiling
2013-01-16-11:01:11 a8b691e6104e6bd27070b6ed6622d0b640707fa8 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7923 revisions left to test after this (roughly 13 steps)
[5efc1a7a6544491a8a4df8dcbff45a041600e429] Merge branch 'packaging' into for-next
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:01:40 5efc1a7a6544491a8a4df8dcbff45a041600e429 compiling
/home/wfg/tip

2013-01-16-11:03:57 detecting boot state 2.6.39-rc1-bisect2-00189-g5efc1a7 #1 ..............OK .1.....OK ..2OK .OK 3OK .4OK 56......OK .7OK .8OK 910OK  SUCCESS
Bisecting: 7802 revisions left to test after this (roughly 13 steps)
[f2ace93136cade6904a71d26e2f4768eef3b9aa3] MIPS: sysmips: Use unreachable().
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:05:19 f2ace93136cade6904a71d26e2f4768eef3b9aa3 compiling
2013-01-16-11:07:36 f2ace93136cade6904a71d26e2f4768eef3b9aa3 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7802 revisions left to test after this (roughly 13 steps)
[7f0ae647b29ba80d5a1127804ba478e3de8a6b4c] Bluetooth: Fix HCI command sending when powering on LE-only adapters
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:07:54 7f0ae647b29ba80d5a1127804ba478e3de8a6b4c compiling
2013-01-16-11:09:25 7f0ae647b29ba80d5a1127804ba478e3de8a6b4c SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version include/generated/uapi/linux/version.h
make: Leaving directory `/c/wfg/tip'
Bisecting: 7802 revisions left to test after this (roughly 13 steps)
[8f170faeb458532282dbfa870f456e42c11d1ebb] x86, apb_timer: remove unused variable percpu_timer
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:09:41 8f170faeb458532282dbfa870f456e42c11d1ebb compiling
2013-01-16-11:11:51 8f170faeb458532282dbfa870f456e42c11d1ebb SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7802 revisions left to test after this (roughly 13 steps)
[f3b369e40a0fbf975ab0e39c2104f184e188afc3] mwifiex: rx path enhancement to derive priv only once
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:12:06 f3b369e40a0fbf975ab0e39c2104f184e188afc3 compiling
2013-01-16-11:13:35 f3b369e40a0fbf975ab0e39c2104f184e188afc3 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version include/generated/uapi/linux/version.h
make: Leaving directory `/c/wfg/tip'
Bisecting: 7802 revisions left to test after this (roughly 13 steps)
[d62fdf8b681550881b3fb85f335eaf8e36b971b7] drivers/net: Use of_match_ptr() macro in smsc911x.c
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:13:50 d62fdf8b681550881b3fb85f335eaf8e36b971b7 compiling
2013-01-16-11:16:05 d62fdf8b681550881b3fb85f335eaf8e36b971b7 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7802 revisions left to test after this (roughly 13 steps)
[79d4969535f1d569d7ddf7f58242994e9479a28d] tg3: Support 5717 C0
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:16:21 79d4969535f1d569d7ddf7f58242994e9479a28d compiling
/home/wfg/tip

2013-01-16-11:19:04 detecting boot state 3.7.0-rc1-bisect2-00311-g79d4969 #1 ........................................................................................................................OK .1...........................................................OK .2........OK ..34..............................................OK .5............OK .6....................................................................OK .OK .7............................................................................OK 89.........................................................OK 10..OK  SUCCESS
Bisecting: 7711 revisions left to test after this (roughly 13 steps)
[375da3a76dc49f10c35e243ebef62df12e3adf4e] drivers/of/fdt.c: re-use kernel's kbasename()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:30:53 375da3a76dc49f10c35e243ebef62df12e3adf4e compiling
2013-01-16-11:33:00 375da3a76dc49f10c35e243ebef62df12e3adf4e SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7711 revisions left to test after this (roughly 13 steps)
[1ea2a0160588582cd8414a8026d5b54f1705dfa1] mn10300: switch to generic fork/vfork/clone
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:33:16 1ea2a0160588582cd8414a8026d5b54f1705dfa1 compiling
/home/wfg/tip

2013-01-16-11:36:03 detecting boot state 3.7.0-rc7-bisect2-00138-g1ea2a01 #1 .................OK ..12.................................................................OK .34.................................................................................OK .56...........................................................OK ..7.OK ..8910.....................................................OK .11..OK .12OK 13.OK .14OK  SUCCESS
Bisecting: 7650 revisions left to test after this (roughly 13 steps)
[1b8a1636ceea573b1d452a1cccf01c990d8d628a] aoe: update cap on outstanding commands based on config query response
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:43:45 1b8a1636ceea573b1d452a1cccf01c990d8d628a compiling
2013-01-16-11:46:16 1b8a1636ceea573b1d452a1cccf01c990d8d628a SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7650 revisions left to test after this (roughly 13 steps)
[94e014ee98e98dedb080ed1cdf510a583ed0514b] drm/radeon/cayman: add VM CS checker support for CP DMA
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:46:30 94e014ee98e98dedb080ed1cdf510a583ed0514b compiling
/home/wfg/tip

2013-01-16-11:49:46 detecting boot state 3.7.0-rc7-bisect2-00541-g94e014e #1 OK 1OK .OK 23..............................................OK .4.OK .5..OK .6..OK 78.OK 9OK 10..OK  SUCCESS
Bisecting: 7598 revisions left to test after this (roughly 13 steps)
[6fd59a83b9261fa53eaf98fb5514abba504a3ea3] scatterlist: don't BUG when we can trivially return a proper error.
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:51:38 6fd59a83b9261fa53eaf98fb5514abba504a3ea3 compiling
2013-01-16-11:53:43 6fd59a83b9261fa53eaf98fb5514abba504a3ea3 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7598 revisions left to test after this (roughly 13 steps)
[24bd410905919696b705a2ce1df5e1d5d4d22032] regulator: max8997: Remove set_voltage_time_sel setting for max8997_ldo_ops
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:53:59 24bd410905919696b705a2ce1df5e1d5d4d22032 compiling
2013-01-16-11:56:04 24bd410905919696b705a2ce1df5e1d5d4d22032 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7598 revisions left to test after this (roughly 13 steps)
[0cae4685a602a8bf9a86fa2417d6c035c09d6341] staging: net: remove use of __devexit
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-11:56:21 0cae4685a602a8bf9a86fa2417d6c035c09d6341 compiling
/home/wfg/tip

2013-01-16-11:59:03 detecting boot state 3.7.0-rc6-bisect2-01102-g0cae468 #1 OK 1.OK 2OK 34...OK .OK 56........................................OK 7.OK 8.....OK 9.OK 10OK  SUCCESS
Bisecting: 7165 revisions left to test after this (roughly 13 steps)
[9228ff90387e276ad67b10c0eb525c9d6a57d5e9] Merge branch 'for-3.8/drivers' of git://git.kernel.dk/linux-block
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:00:45 9228ff90387e276ad67b10c0eb525c9d6a57d5e9 compiling
2013-01-16-12:02:59 9228ff90387e276ad67b10c0eb525c9d6a57d5e9 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7165 revisions left to test after this (roughly 13 steps)
[1724ffbc7439de679d536163e03f54f35574d449] mac80211: complete bss_info tracing
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:03:18 1724ffbc7439de679d536163e03f54f35574d449 compiling
2013-01-16-12:04:51 1724ffbc7439de679d536163e03f54f35574d449 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version include/generated/uapi/linux/version.h
make: Leaving directory `/c/wfg/tip'
Bisecting: 7165 revisions left to test after this (roughly 13 steps)
[0f68bb4aed611b05216a9d94457704c738bcb7b9] ARM: shmobile: Include sh73a0 DTSI in kzm9g
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:05:07 0f68bb4aed611b05216a9d94457704c738bcb7b9 compiling
2013-01-16-12:08:10 0f68bb4aed611b05216a9d94457704c738bcb7b9 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7165 revisions left to test after this (roughly 13 steps)
[89377aa5156a93e73a3f7c7ccdc0d0fecf65e0d2] pinctrl: lantiq: Staticize non-exported symbols
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:08:34 89377aa5156a93e73a3f7c7ccdc0d0fecf65e0d2 compiling
/home/wfg/tip

2013-01-16-12:11:25 detecting boot state 3.7.0-rc5-bisect2-00064-g89377aa #1 .OK .1OK .2...OK 3...OK 4..OK .5...................................OK ...................OK 67.OK .8..OK 9......................................................OK  SUCCESS
Bisecting: 7165 revisions left to test after this (roughly 13 steps)
[71fbad6c9a28629b6af40b0ff48f36c6610a1394] PCI/ACPI: Notify PCI devices when their power resource is turned on
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:14:51 71fbad6c9a28629b6af40b0ff48f36c6610a1394 compiling
/home/wfg/tip

2013-01-16-12:17:13 detecting boot state 3.7.0-rc3-bisect2-00009-g71fbad6 #2 ........................12.34..5......................................................OK .OK 6.OK .OK 78OK 9...OK .10................................................................................................................................................................................OK ......................1112...........................................................OK .OK .13.OK  SUCCESS
Bisecting: 7165 revisions left to test after this (roughly 13 steps)
[41cad6ab2cb9ccb3b11546ad56b8b285e47c6279] cfq-iosched: convert cfq_group_slice() to use cfqg->vfraction
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:26:20 41cad6ab2cb9ccb3b11546ad56b8b285e47c6279 compiling
2013-01-16-12:28:23 41cad6ab2cb9ccb3b11546ad56b8b285e47c6279 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7165 revisions left to test after this (roughly 13 steps)
[eabc5fa51c1fae4b66cf883e3a3c2b3ca794494c] Merge branch 'spear-for-3.8' of git://git.linaro.org/people/vireshk/linux into next/dt2
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:28:40 eabc5fa51c1fae4b66cf883e3a3c2b3ca794494c compiling
/home/wfg/tip

2013-01-16-12:31:15 detecting boot state 3.7.0-rc7-bisect2-00068-geabc5fa #1 ...............................12.3............................................................OK ..4.OK .56..........................................................................................................................................................................................................................................................OK .................................................................................7OK .8............................................................OK ..9OK 10111213...........................................................OK .14OK 15OK .OK  SUCCESS
Bisecting: 7165 revisions left to test after this (roughly 13 steps)
[889b2f8783ee533ffe4117b0a7173319dec86ac8] MAINTAINERS: add an entry for radio-mr800 driver
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:45:30 889b2f8783ee533ffe4117b0a7173319dec86ac8 compiling
2013-01-16-12:47:01 889b2f8783ee533ffe4117b0a7173319dec86ac8 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7165 revisions left to test after this (roughly 13 steps)
[7fbdadb5e951e4f0c0fc991ff5f50295568786e6] solos-pci: remove superfluous debug output
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:47:16 7fbdadb5e951e4f0c0fc991ff5f50295568786e6 compiling
2013-01-16-12:49:15 7fbdadb5e951e4f0c0fc991ff5f50295568786e6 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7165 revisions left to test after this (roughly 13 steps)
[d3cec81fc929b6edc43bd42725929685359adef7] firmware: remove last vestiges of dabusb
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:49:28 d3cec81fc929b6edc43bd42725929685359adef7 compiling
/home/wfg/tip

2013-01-16-12:52:10 detecting boot state 3.7.0-rc6-bisect2-00199-gd3cec81 #1 ...................................OK .OK 12..OK .OK 34...OK .5...OK .6............................................OK .OK 78...OK .OK  SUCCESS
Bisecting: 7126 revisions left to test after this (roughly 13 steps)
[6a2b60b17b3e48a418695a94bd2420f6ab32e519] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:54:53 6a2b60b17b3e48a418695a94bd2420f6ab32e519 compiling
2013-01-16-12:56:54 6a2b60b17b3e48a418695a94bd2420f6ab32e519 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7126 revisions left to test after this (roughly 13 steps)
[e3224111b3a527eb8f9b9b6deed83b727522941e] staging: dgrp: remove use of real_raw and read_cnt in dgrp_input
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-12:57:11 e3224111b3a527eb8f9b9b6deed83b727522941e compiling
/home/wfg/tip

2013-01-16-12:59:53 detecting boot state 3.7.0-rc2-bisect2-00049-ge322411 #1 OK .....................................OK 1OK .2OK 3...OK .4OK .5.OK .6..OK .7OK .8..........................................OK  SUCCESS
Bisecting: 7126 revisions left to test after this (roughly 13 steps)
[b444df2f7267e1a431989ad95169f0c13ac790e2] drivers/video/backlight/pandora_bl.c: change TWL4030_MODULE_PWM0 to TWL_MODULE_PWM
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:02:32 b444df2f7267e1a431989ad95169f0c13ac790e2 compiling
2013-01-16-13:04:40 b444df2f7267e1a431989ad95169f0c13ac790e2 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7126 revisions left to test after this (roughly 13 steps)
[eee8182aa4424eee71f25cb4ce2c56a53222d523] kvm tools: Convert virtio devices to use IRQ registry
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:05:04 eee8182aa4424eee71f25cb4ce2c56a53222d523 compiling
2013-01-16-13:06:06 eee8182aa4424eee71f25cb4ce2c56a53222d523 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/genksyms
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated
  CLEAN   .config .config.old .version include/linux/version.h
make: Leaving directory `/c/wfg/tip'
Bisecting: 7126 revisions left to test after this (roughly 13 steps)
[667be1e757f5684576d01d7402907a2489b1402f] aoe: provide ATA identify device content to user on request
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:06:34 667be1e757f5684576d01d7402907a2489b1402f compiling
2013-01-16-13:08:34 667be1e757f5684576d01d7402907a2489b1402f SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version .old_version include/generated/uapi/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/tip'
Bisecting: 7126 revisions left to test after this (roughly 13 steps)
[c0b74876ee4873dc89d80b59f5e890a1d0a87be1] ath9k: Add a debugfs file to dump queue statistics
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:08:50 c0b74876ee4873dc89d80b59f5e890a1d0a87be1 compiling
2013-01-16-13:10:21 c0b74876ee4873dc89d80b59f5e890a1d0a87be1 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/tip-bisect2-x86_64 ARCH=x86_64 distclean
make: Entering directory `/c/wfg/tip'
  CLEAN   .
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   drivers/gpu/drm/radeon
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated arch/x86/include/generated
  CLEAN   .config .config.old .version include/generated/uapi/linux/version.h
make: Leaving directory `/c/wfg/tip'
Bisecting: 7126 revisions left to test after this (roughly 13 steps)
[b254e3e407669328ba8edee6454d44609fc34adc] Merge commit 'v3.2-rc2' into linux-next
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:10:40 b254e3e407669328ba8edee6454d44609fc34adc compiling
/home/wfg/tip

2013-01-16-13:13:42 detecting boot state 3.2.0-rc2-bisect2-00008-gb254e3e #1 ...OK .OK 1OK 2OK 3...OK .4.OK 5OK 6..................................................OK .OK 7OK  SUCCESS
Bisecting: 7125 revisions left to test after this (roughly 13 steps)
[08fe1172f8433d5e71c1d6cb7b85922724aa0cd8] Merge remote-tracking branch 'vhost/linux-next'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:15:40 08fe1172f8433d5e71c1d6cb7b85922724aa0cd8 compiling
/home/wfg/tip

2013-01-16-13:18:28 detecting boot state 3.8.0-rc3-bisect2-04294-g08fe117 #2 12..34567...................................................OK 8OK .OK .910OK 11OK .12OK .OK 13OK 1415.................................................OK .16OK  SUCCESS
Bisecting: 437 revisions left to test after this (roughly 9 steps)
[da4bd8bf7f518375af0b3be165914393dfc51164] Merge remote-tracking branch 'userns/for-next'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:21:36 da4bd8bf7f518375af0b3be165914393dfc51164 compiling
/home/wfg/tip

2013-01-16-13:24:28 detecting boot state 3.8.0-rc3-bisect2-04619-gda4bd8b #3 .....1.2...345..678....9..........................................OK .10....OK 11.OK .12OK 13OK 14..OK .OK 15OK 1617OK 18...........................................OK  SUCCESS
Bisecting: 218 revisions left to test after this (roughly 8 steps)
[c73f9be37508574ee11aed680f597c3a0f3e9e4b] memcg, oom: provide more precise dump info while memcg oom happening
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:27:43 c73f9be37508574ee11aed680f597c3a0f3e9e4b compiling
/home/wfg/tip

2013-01-16-13:30:32 detecting boot state 3.8.0-rc3-bisect2-04838-gc73f9be #4 .........1........23.45..6789..10.....................................OK .11.......OK .12OK .OK 1314OK 15.OK .OK 16OK 17OK 1819..OK  SUCCESS
Bisecting: 108 revisions left to test after this (roughly 7 steps)
[aa0e4b147868e8fd814e6b7d9fa5b0ee567c9df1] drivers/video/backlight/l4f00242t03.c: convert to devm_regulator_get()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:32:53 aa0e4b147868e8fd814e6b7d9fa5b0ee567c9df1 compiling
/home/wfg/tip

2013-01-16-13:35:36 detecting boot state 3.8.0-rc3-bisect2-04948-gaa0e4b1 #5 123.4..567.8...9......... TEST FAILURE
Bisecting: 54 revisions left to test after this (roughly 6 steps)
[994cc907eebc73a6f528b915d9f051179bf52dd4] mm: memmap_init_zone() performance improvement
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:36:16 994cc907eebc73a6f528b915d9f051179bf52dd4 compiling
/home/wfg/tip

2013-01-16-13:38:59 detecting boot state 3.8.0-rc3-bisect2-04893-g994cc90 #6 ........12....34..56....7... TEST FAILURE
Bisecting: 26 revisions left to test after this (roughly 5 steps)
[59de07046c9cfbdf8f9ab3bfa515a85ece93e4a9] mm: use mm_populate() when adjusting brk with MCL_FUTURE in effect
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:39:42 59de07046c9cfbdf8f9ab3bfa515a85ece93e4a9 compiling
/home/wfg/tip

2013-01-16-13:42:29 detecting boot state 3.8.0-rc3-bisect2-04866-g59de070 #7 .1...2...3.45.6...........7. TEST FAILURE
Bisecting: 13 revisions left to test after this (roughly 4 steps)
[ae751c1843f8c115af922c06eb507cea30c61ba9] mm/page_alloc.c:__setup_per_zone_wmarks: make min_pages unsigned long
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:43:13 ae751c1843f8c115af922c06eb507cea30c61ba9 compiling
/home/wfg/tip

2013-01-16-13:45:41 detecting boot state 3.8.0-rc3-bisect2-04852-gae751c1 #8 ......12..3..4......56.............................OK .OK 7OK 8....OK 9.........OK .10.OK 11OK 12..OK 13......OK .14.............................OK  SUCCESS
Bisecting: 6 revisions left to test after this (roughly 3 steps)
[6eabfddc7ff9703acbe374ec6e30548156dfbcd9] mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:48:32 6eabfddc7ff9703acbe374ec6e30548156dfbcd9 compiling
/home/wfg/tip

2013-01-16-13:49:56 detecting boot state 3.8.0-rc3-bisect2-04859-g6eabfddc #9 .....1.2...3.4........5...6.7...8....9... TEST FAILURE
Bisecting: 2 revisions left to test after this (roughly 2 steps)
[68e330bf77bcd5ff36f26d162a34cc20ceb51f77] mm/ksm.c: use new hashtable implementation
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:50:59 68e330bf77bcd5ff36f26d162a34cc20ceb51f77 compiling
/home/wfg/tip

2013-01-16-13:52:27 detecting boot state 3.8.0-rc3-bisect2-04856-g68e330b #10 ...............12....3...4........................OK .5.OK .6.OK .OK 7OK 89.................OK .OK 1011...OK .12..OK 13.........................OK  SUCCESS
Bisecting: 0 revisions left to test after this (roughly 1 step)
[0d18d770b9180ffc2c3f63b9eb8406ef80105e05] mm: make madvise(MADV_WILLNEED) support swap file prefetch
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:55:16 0d18d770b9180ffc2c3f63b9eb8406ef80105e05 compiling
/home/wfg/tip

2013-01-16-13:56:35 detecting boot state 3.8.0-rc3-bisect2-04858-g0d18d77 #11 ........1..2..3.4..................56...78..9..... TEST FAILURE
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[6df61eaaa9fad4da8c30340339119d6cc9bbddd9] memcg,vmscan: do not break out targeted reclaim without reclaimed pages
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-01-16-13:57:50 6df61eaaa9fad4da8c30340339119d6cc9bbddd9 compiling
/home/wfg/tip

2013-01-16-13:59:11 detecting boot state 3.8.0-rc3-bisect2-04857-g6df61ea #12 ..........12....3..4.............................OK .OK 56OK 7OK .8....OK .9..........OK 1011....OK 12..OK 13..............................OK .OK  SUCCESS
0d18d770b9180ffc2c3f63b9eb8406ef80105e05 is the first bad commit
commit 0d18d770b9180ffc2c3f63b9eb8406ef80105e05
Author: Shaohua Li <shli@kernel.org>
Date:   Sat Jan 12 10:56:05 2013 +1100

    mm: make madvise(MADV_WILLNEED) support swap file prefetch
    
    Make madvise(MADV_WILLNEED) support swap file prefetch.  If memory is
    swapout, this syscall can do swapin prefetch.  It has no impact if the
    memory isn't swapout.
    
    Signed-off-by: Shaohua Li <shli@fusionio.com>
    Cc: Hugh Dickins <hughd@google.com>
    Cc: Rik van Riel <riel@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

:040000 040000 268f8b0e14aa7a68083c6097b028c6f7611216ea 10e6122876d96d79ccef60cff00d1b6243610af9 M	mm
bisect run success

========= linux-next =========

2013-01-16-14:02:09 a21f55581c83e04a323578cfc8398127992984d1 compiling
/home/wfg/tip

2013-01-16-14:04:53 detecting boot state 3.8.0-rc3-bisect2-next-20130116 #13 ........12....3..4...........5..6..7..8..............................OK .OK 9OK 10...OK .11..OK 12...........OK 13.OK .14.OK .15.OK .16..............................OK  SUCCESS

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.8.0-rc3 Kernel Configuration
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
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
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
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
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
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
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
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_HAVE_UID16=y
CONFIG_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

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
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y

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
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_KVMTOOL_TEST_ENABLE is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_X86_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
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
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
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
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
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
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
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
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_CPU_IDLE is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_XEN_PCIDEV_FRONTEND=y
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_NETPRIO_CGROUP=y
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
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
CONFIG_YAM=y
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

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
CONFIG_DONGLE=y
# CONFIG_ESI_DONGLE is not set
CONFIG_ACTISYS_DONGLE=y
# CONFIG_TEKRAM_DONGLE is not set
# CONFIG_TOIM3232_DONGLE is not set
CONFIG_LITELINK_DONGLE=y
# CONFIG_MA600_DONGLE is not set
# CONFIG_GIRBIL_DONGLE is not set
# CONFIG_MCP2120_DONGLE is not set
# CONFIG_OLD_BELKIN_DONGLE is not set
# CONFIG_ACT200L_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
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
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
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
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=y
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

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
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
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
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
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
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
CONFIG_ISCSI_TARGET=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

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
CONFIG_INPUT_EVBUG=y

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
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM80X_ONKEY is not set
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
# CONFIG_INPUT_AD714X_SPI is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_TWL6040_VIBRA=y
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
# CONFIG_INPUT_ADXL34X_SPI is not set
CONFIG_INPUT_CMA3000=y
# CONFIG_INPUT_CMA3000_I2C is not set
# CONFIG_INPUT_XEN_KBDDEV_FRONTEND is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_INTEL_MID=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
# CONFIG_HSI is not set

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
CONFIG_PPS_CLIENT_GPIO=y

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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_LP8788=y
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_FAIR_SHARE=y
# CONFIG_STEP_WISE is not set
CONFIG_USER_SPACE=y
CONFIG_CPU_THERMAL=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_GEODE_WDT is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=y
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_XEN_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_MFD_LM3533=y
# CONFIG_TPS6105X is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_SMSC=y
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_CS5535=y
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8907 is not set
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8997 is not set
CONFIG_REGULATOR_MAX8998=y
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_PALMAS is not set
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_TTM is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_KMS is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_MGA=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
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
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
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
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_VIRTUAL=y
# CONFIG_XEN_FBDEV_FRONTEND is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
CONFIG_LCD_AMS369FG06=y
# CONFIG_LCD_LMS501KF03 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_LP8788 is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_APPLE=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_ICADE=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_PS3REMOTE=y
# CONFIG_HID_HYPERV_MOUSE is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_HCD_BCMA is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set

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
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_DELL_NETBOOKS=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC is not set
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_BALLOON=y

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
# CONFIG_XENFS is not set
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
# CONFIG_XEN_PCIDEV_BACKEND is not set
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_ECHO is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#
CONFIG_IIO_ST_HWMON=y
CONFIG_IIO_SW_RING=y

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16203 is not set
# CONFIG_ADIS16204 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=y
CONFIG_KXSD9=y
CONFIG_SCA3000=y

#
# Analog to digital converters
#
CONFIG_AD7291=y
# CONFIG_AD799X is not set
CONFIG_AD7192=y
# CONFIG_ADT7410 is not set
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#
# CONFIG_AD5930 is not set
CONFIG_AD9832=y
# CONFIG_AD9834 is not set
# CONFIG_AD9850 is not set
# CONFIG_AD9852 is not set
CONFIG_AD9910=y
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16060 is not set
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS450 is not set

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL2583=y
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7753=y
CONFIG_ADE7754=y
# CONFIG_ADE7758 is not set
CONFIG_ADE7759=y
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=y

#
# Triggers - standalone
#
# CONFIG_IIO_SYSFS_TRIGGER is not set
CONFIG_IIO_DUMMY_EVGEN=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_ZSMALLOC is not set
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_WIMAX_GDM72XX=y
# CONFIG_WIMAX_GDM72XX_QOS is not set
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_NET_VENDOR_SILICOM=y
# CONFIG_DGRP is not set
CONFIG_SB105X=y
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_DELL_WMI=y
# CONFIG_DELL_WMI_AIO is not set
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WMI=y
CONFIG_MSI_LAPTOP=y
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
CONFIG_SONY_LAPTOP=y
# CONFIG_SONYPI_COMPAT is not set
CONFIG_IDEAPAD_LAPTOP=y
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
CONFIG_XO15_EBOOK=y
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
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

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
# CONFIG_AD7298 is not set
CONFIG_AD7791=y
# CONFIG_AD7793 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7887 is not set
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=y
CONFIG_TI_ADC081C=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5624R_SPI=y
CONFIG_AD5446=y
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5764 is not set
CONFIG_AD5791=y
# CONFIG_AD5686 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

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
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16136=y

#
# Inertial measurement units
#
# CONFIG_ADIS16480 is not set
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_SENSORS_LM3533 is not set
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

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
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
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
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
# CONFIG_IMA_APPRAISE is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_X86_64=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

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
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_VHOST_NET is not set
CONFIG_BINARY_PRINTF=y

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
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
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
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
# CONFIG_ISDN_DRV_LOOP is not set

--TB36FDmn/VVEgNH/--
