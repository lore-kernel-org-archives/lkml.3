Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaCFP4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:56:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:34658 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaCFP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:56:17 -0500
Date: Thu, 6 Mar 2014 09:53:16 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: linux-next: Tree for Mar 6
Message-ID: <20140306155316.GG18529@joshc.qualcomm.com>
References: <20140306194821.3715d0b6212cc10415374a68@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20140306194821.3715d0b6212cc10415374a68@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 06, 2014 at 07:48:21PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> There may be build failures in this tree due to the percpu changes in the
> akpm tree.
> 
> This tree fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140305:
> 

Booting on my Samsung Series 9 laptop gives me loads and loads of BUGs
triggered by __this_cpu_add(), making making the system completely
unusable:

[    5.808326] BUG: using __this_cpu_add() in preemptible [00000000] code: swapper/0/1
[    5.812331] caller is __this_cpu_preempt_check+0x2b/0x30
[    5.815654] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    5.819553] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    5.823558]  ffff8801182157c0 ffff880118215790 ffffffff81a64cec 0000000000000000
[    5.827177]  ffff8801182157b0 ffffffff81462360 ffff8800c3d553e0 ffffea00030f5500
[    5.830744]  ffff8801182157e8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    5.834134] Call Trace:
[    5.836848]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    5.839943]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    5.842997]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    5.846022]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    5.848863]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    5.850467] BUG: using __this_cpu_add() in preemptible [00000000] code: khubd/36
[    5.850472] caller is __this_cpu_preempt_check+0x2b/0x30
[    5.859125]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    5.862521]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    5.865599]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    5.868738]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    5.871799]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    5.874754]  [<ffffffff81363e64>] ? ext4_ext_map_blocks+0x184/0x1950
[    5.877818]  [<ffffffff81363e64>] ext4_ext_map_blocks+0x184/0x1950
[    5.880862]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    5.883940]  [<ffffffff81334b2c>] ? ext4_map_blocks+0x2dc/0x530
[    5.886943]  [<ffffffff81334a55>] ext4_map_blocks+0x205/0x530
[    5.889912]  [<ffffffff81334fe6>] ext4_getblk+0x56/0x210
[    5.893511]  [<ffffffff8133fcaf>] ext4_find_entry+0x2df/0x510
[    5.896463]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    5.899355]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    5.902252]  [<ffffffff8133ff22>] ext4_lookup+0x42/0x150
[    5.905132]  [<ffffffff812a4cbd>] lookup_real+0x1d/0x50
[    5.907984]  [<ffffffff812a5813>] __lookup_hash+0x33/0x40
[    5.910827]  [<ffffffff812a58b5>] lookup_slow+0x45/0xc0
[    5.913662]  [<ffffffff812a7b22>] link_path_walk+0x872/0x8b0
[    5.916562]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[    5.919460]  [<ffffffff812aa20f>] path_openat+0x9f/0x6e0
[    5.922247]  [<ffffffff812aa88a>] do_filp_open+0x3a/0x90
[    5.925066]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[    5.928009]  [<ffffffff811952fe>] ? put_lock_stats.isra.20+0xe/0x30
[    5.930945]  [<ffffffff812a2430>] ? do_execve_common.isra.25+0x290/0x8d0
[    5.933942]  [<ffffffff812a07b2>] do_open_exec+0x22/0xe0
[    5.936765]  [<ffffffff812a243f>] do_execve_common.isra.25+0x29f/0x8d0
[    5.939716]  [<ffffffff812a22b6>] ? do_execve_common.isra.25+0x116/0x8d0
[    5.942620]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    5.945391]  [<ffffffff812a2a88>] do_execve+0x18/0x20
[    5.948112]  [<ffffffff8100202b>] run_init_process+0x2b/0x30
[    5.950874]  [<ffffffff81002044>] try_to_run_init_process+0x14/0x40
[    5.953682]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    5.956472]  [<ffffffff81a5ac2c>] kernel_init+0x9c/0xf0
[    5.959059]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    5.962611]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    5.965244] CPU: 1 PID: 36 Comm: khubd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    5.968014] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    5.971766]  ffff8801179ad920 ffff8801179ad8f0 ffffffff81a64cec 0000000000000001
[    5.975058]  ffff8801179ad910 ffffffff81462360 ffff8800c302f2c8 ffffea00030c0b00
[    5.978361]  ffff8801179ad948 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    5.981656] Call Trace:
[    5.981919] BUG: using __this_cpu_add() in preemptible [00000000] code: swapper/0/1
[    5.981923] caller is __this_cpu_preempt_check+0x2b/0x30
[    5.988527]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    5.990873]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    5.993367]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    5.995793]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[    5.998281]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    6.000635]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.002976]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.005473]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    6.007976]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    6.010481]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.012914]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    6.015074]  [<ffffffff816e0f04>] ? urb_destroy+0x24/0x30
[    6.017301]  [<ffffffff816e0f04>] urb_destroy+0x24/0x30
[    6.019513]  [<ffffffff816e1061>] usb_free_urb+0x21/0x30
[    6.021676]  [<ffffffff816e1e92>] usb_start_wait_urb+0xa2/0x160
[    6.023940]  [<ffffffff81a6d7c2>] ? wait_for_common+0x122/0x170
[    6.026200]  [<ffffffff816e2425>] usb_control_msg+0xc5/0x110
[    6.028378]  [<ffffffff816e2de2>] usb_get_descriptor+0x82/0xc0
[    6.030624]  [<ffffffff816e69a3>] usb_get_configuration+0x163/0x1600
[    6.032921]  [<ffffffff81a717bc>] ? _raw_spin_unlock_irq+0x2c/0x60
[    6.035158]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.037469]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.039703]  [<ffffffff81a717cd>] ? _raw_spin_unlock_irq+0x3d/0x60
[    6.041913]  [<ffffffff816d84b8>] usb_new_device+0x2c8/0x370
[    6.044100]  [<ffffffff816db412>] hub_thread+0x792/0x16e0
[    6.046257]  [<ffffffff8118c450>] ? __wake_up_common+0x90/0x90
[    6.048416]  [<ffffffff816dac80>] ? usb_reset_device+0x1d0/0x1d0
[    6.050639]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[    6.052685]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    6.054911]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    6.057052]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80

And so on.. (full dmesg attached)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="next-20140306.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe (joshc@ultrae) (gcc version 4.8.2 20140206 (prerelease) (GCC) ) #1 SMP PREEMPT Thu Mar 6 08:49:42 CST 2014
[    0.000000] Command line: BOOT_IMAGE=../bzImage-next20140306 root=/dev/sda2 rw snd_hda_intel.power_save=1 usbcore.autosuspend=2
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000b8ea9fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b8eaa000-0x00000000b90abfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b90ac000-0x00000000c93eefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c93ef000-0x00000000daeeefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000daeef000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x11f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask FE0000000 write-back
[    0.000000]   7 base 11F800000 mask FFF800000 uncachable
[    0.000000]   8 base 11F600000 mask FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f0100-0x000f010f] mapped at [ffff8800000f0100]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fe6000, 0x02fe6fff] PGTABLE
[    0.000000] BRK [0x02fe7000, 0x02fe7fff] PGTABLE
[    0.000000] BRK [0x02fe8000, 0x02fe8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11f400000-0x11f5fffff]
[    0.000000]  [mem 0x11f400000-0x11f5fffff] page 4k
[    0.000000] BRK [0x02fe9000, 0x02fe9fff] PGTABLE
[    0.000000] BRK [0x02fea000, 0x02feafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11f3fffff]
[    0.000000]  [mem 0x11c000000-0x11f3fffff] page 4k
[    0.000000] BRK [0x02feb000, 0x02febfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x1fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x40003fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x40005000-0xb8ea9fff]
[    0.000000]  [mem 0x40005000-0xb8ea9fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xb90ac000-0xc93eefff]
[    0.000000]  [mem 0xb90ac000-0xc93eefff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdafff000-0xdaffffff]
[    0.000000]  [mem 0xdafff000-0xdaffffff] page 4k
[    0.000000] ACPI: RSDP 0x00000000000F0120 000024 (v02 SECCSD)
[    0.000000] ACPI: XSDT 0x00000000DAFFE170 000094 (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: FACP 0x00000000DAFEE000 00010C (v05 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: DSDT 0x00000000DAFF1000 0097F2 (v02 SECCSD IVB-CPT  00000000 INTL 20061109)
[    0.000000] ACPI: FACS 0x00000000DAF7B000 000040
[    0.000000] ACPI: SLIC 0x00000000DAFFD000 000176 (v01 SECCSD LH43STAR 00000002 PTL  00000001)
[    0.000000] ACPI: SSDT 0x00000000DAFFB000 001068 (v01 SECCSD PtidDevc 00001000 INTL 20061109)
[    0.000000] ACPI: ASF! 0x00000000DAFF0000 0000A5 (v32 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: HPET 0x00000000DAFED000 000038 (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: APIC 0x00000000DAFEC000 000098 (v03 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: MCFG 0x00000000DAFEB000 00003C (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: FPDT 0x00000000DAFEA000 000064 (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: SSDT 0x00000000DAFE9000 0009E7 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DAFE8000 000B60 (v01 PmRef  CpuPm    00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 0x00000000DAFE7000 000042 (v01 PTL    COMBUF   00000001 PTL  00000001)
[    0.000000] ACPI: MSDM 0x00000000DAF78000 000055 (v03 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: UEFI 0x00000000DAFE6000 00003E (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: UEFI 0x00000000DAFE5000 00022E (v01 SECCSD LH43STAR 00000002 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011a800000-ffff88011e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xb8ea9fff]
[    0.000000]   node   0: [mem 0xb90ac000-0xc93eefff]
[    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x11f5fffff]
[    0.000000] On node 0 totalpages: 951689
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12800 pages used for memmap
[    0.000000]   DMA32 zone: 819181 pages, LIFO batch:31
[    0.000000]   Normal zone: 2008 pages used for memmap
[    0.000000]   Normal zone: 128512 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdba00000-0xdf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xb8eaa000-0xb90abfff]
[    0.000000] PM: Registered nosave memory: [mem 0xc93ef000-0xdaeeefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdaeef000-0xdaf9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdaf9f000-0xdaffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed07fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffcfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffd00000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880119800000 s1925696 r0 d24000 u2097152
[    0.000000] pcpu-alloc: s1925696 r0 d24000 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 936796
[    0.000000] Kernel command line: BOOT_IMAGE=../bzImage-next20140306 root=/dev/sda2 rw snd_hda_intel.power_save=1 usbcore.autosuspend=2
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 3615260K/3806756K available (10725K kernel code, 1317K rwdata, 3548K rodata, 3292K init, 11628K bss, 191496K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 16252928 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 32 of 32 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2494.395 MHz processor
[    0.000109] Calibrating delay loop (skipped), value calculated using timer frequency.. 4990.65 BogoMIPS (lpj=8314650)
[    0.000246] pid_max: default: 32768 minimum: 301
[    0.000824] Mount-cache hash table entries: 256
[    0.002634] Initializing cgroup subsys memory
[    0.002750] Initializing cgroup subsys devices
[    0.002837] Initializing cgroup subsys freezer
[    0.002941] Initializing cgroup subsys blkio
[    0.003170] CPU: Physical Processor ID: 0
[    0.003236] CPU: Processor Core ID: 0
[    0.003305] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.003872] mce: CPU supports 7 MCE banks
[    0.003956] CPU0: Thermal monitoring enabled (TM1)
[    0.004045] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
tlb_flushall_shift: 2
[    0.004405] debug: unmapping init [mem 0xffffffff82482000-0xffffffff82488fff]
[    0.008124] ftrace: allocating 32286 entries in 127 pages
[    0.028956] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.062832] smpboot: CPU0: Intel(R) Core(TM) i7-3537U CPU @ 2.00GHz (fam: 06, model: 3a, stepping: 09)
[    0.064197] TSC deadline timer enabled
[    0.064754] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.066348] ... version:                3
[    0.066885] ... bit width:              48
[    0.067432] ... generic registers:      4
[    0.068006] ... value mask:             0000ffffffffffff
[    0.068697] ... max period:             0000ffffffffffff
[    0.069387] ... fixed-purpose events:   3
[    0.069925] ... event mask:             000000070000000f
[    0.096306] x86: Booting SMP configuration:
[    0.096866] .... node  #0, CPUs:      #1
[    0.112307] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.119893]  #2 #3
[    0.155894] x86: Booted up 1 node, 4 CPUs
[    0.156521] smpboot: Total of 4 processors activated (19963.62 BogoMIPS)
[    0.164707] devtmpfs: initialized
[    0.169841] PM: Registering ACPI NVS region [mem 0xdaeef000-0xdaf9efff] (720896 bytes)
[    0.182828] RTC time:  8:45:16, date: 03/06/14
[    0.184014] NET: Registered protocol family 16
[    0.187073] cpuidle: using governor ladder
[    0.187624] cpuidle: using governor menu
[    0.188346] ACPI: bus type PCI registered
[    0.190134] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.191330] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.208279] PCI: Using configuration type 1 for base access
[    0.286676] ACPI: Added _OSI(Module Device)
[    0.287286] ACPI: Added _OSI(Processor Device)
[    0.287877] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.288497] ACPI: Added _OSI(Processor Aggregator Device)
[    0.355434] ACPI: Executed 1 blocks of module-level executable AML code
[    0.484021] ACPI: SSDT 0x00000000DAE8E818 000784 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.492698] ACPI: Dynamic OEM Table Load:
[    0.493344] ACPI: SSDT 0x0000000000000000 000784 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.511603] ACPI: SSDT 0x00000000DAE8FA98 000303 (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.525197] ACPI: Dynamic OEM Table Load:
[    0.525843] ACPI: SSDT 0x0000000000000000 000303 (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.536010] ACPI: SSDT 0x00000000DAE8DD98 000119 (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.544919] ACPI: Dynamic OEM Table Load:
[    0.545566] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00003000 INTL 20061109)
[    1.007628] ACPI: Interpreter enabled
[    1.008158] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    1.009483] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    1.010993] ACPI: (supports S0 S3 S4 S5)
[    1.011521] ACPI: Using IOAPIC for interrupt routing
[    1.012755] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.241309] ACPI: Power Resource [FN00] (off)
[    1.244952] ACPI: Power Resource [FN01] (off)
[    1.248548] ACPI: Power Resource [FN02] (off)
[    1.252102] ACPI: Power Resource [FN03] (off)
[    1.255800] ACPI: Power Resource [FN04] (off)
[    1.265033] ACPI: \_PR_.CPU4: failed to get CPU APIC ID.
[    1.265145] ACPI: \_PR_.CPU5: failed to get CPU APIC ID.
[    1.265255] ACPI: \_PR_.CPU6: failed to get CPU APIC ID.
[    1.265365] ACPI: \_PR_.CPU7: failed to get CPU APIC ID.
[    1.275752] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.276579] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.280569] \_SB_.PCI0:_OSC invalid UUID
[    1.280578] _OSC request data:1 1f 0 
[    1.280593] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    1.304626] PCI host bridge to bus 0000:00
[    1.305230] pci_bus 0000:00: root bus resource [bus 00-3e]
[    1.305948] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.306748] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.307546] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.308428] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    1.309398] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    1.311605] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    1.311652] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    1.311678] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    1.311695] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
[    1.314077] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    1.314144] pci 0000:00:16.0: reg 0x10: [mem 0xf0805000-0xf080500f 64bit]
[    1.314389] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.316768] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    1.316830] pci 0000:00:1b.0: reg 0x10: [mem 0xf0800000-0xf0803fff 64bit]
[    1.317219] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.318586] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    1.320497] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    1.320825] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.322179] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.324106] pci 0000:00:1c.3: [8086:1e16] type 01 class 0x060400
[    1.324433] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.325817] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    1.327729] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
[    1.328058] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.330562] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    1.330623] pci 0000:00:1d.0: reg 0x10: [mem 0xf0809000-0xf08093ff]
[    1.330912] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.333356] pci 0000:00:1f.0: [8086:1e5d] type 00 class 0x060100
[    1.335768] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    1.335836] pci 0000:00:1f.2: reg 0x10: [io  0x3088-0x308f]
[    1.335861] pci 0000:00:1f.2: reg 0x14: [io  0x3094-0x3097]
[    1.335887] pci 0000:00:1f.2: reg 0x18: [io  0x3080-0x3087]
[    1.335913] pci 0000:00:1f.2: reg 0x1c: [io  0x3090-0x3093]
[    1.335939] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
[    1.335965] pci 0000:00:1f.2: reg 0x24: [mem 0xf0808000-0xf08087ff]
[    1.336165] pci 0000:00:1f.2: PME# supported from D3hot
[    1.338577] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    1.338628] pci 0000:00:1f.3: reg 0x10: [mem 0xf0804000-0xf08040ff 64bit]
[    1.338700] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    1.342054] pci 0000:01:00.0: [8086:088e] type 00 class 0x028000
[    1.342428] pci 0000:01:00.0: reg 0x10: [mem 0xf0700000-0xf0701fff 64bit]
[    1.344546] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    1.345138] pci 0000:01:00.0: System wakeup disabled by ACPI
[    1.353799] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.354466] pci 0000:00:1c.0:   bridge window [mem 0xf0700000-0xf07fffff]
[    1.355432] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    1.355542] pci 0000:02:00.0: reg 0x10: [io  0x2000-0x20ff]
[    1.355703] pci 0000:02:00.0: reg 0x18: [mem 0xf0600000-0xf0600fff 64bit]
[    1.355801] pci 0000:02:00.0: reg 0x20: [mem 0xf0400000-0xf0403fff 64bit pref]
[    1.356497] pci 0000:02:00.0: supports D1 D2
[    1.356500] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.357020] pci 0000:02:00.0: System wakeup disabled by ACPI
[    1.367185] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    1.367844] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.367854] pci 0000:00:1c.3:   bridge window [mem 0xf0600000-0xf06fffff]
[    1.367870] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
[    1.368844] pci 0000:03:00.0: [1912:0015] type 00 class 0x0c0330
[    1.368952] pci 0000:03:00.0: reg 0x10: [mem 0xf0500000-0xf0501fff 64bit]
[    1.369610] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.371183] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.371849] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
[    1.372022] pci_bus 0000:00: on NUMA node 0
[    1.381719] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    1.385075] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.388724] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    1.392087] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    1.395427] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.399030] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.402679] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 11 12 14 15) *7
[    1.406177] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    1.412828] ACPI: Enabled 5 GPEs in block 00 to 3F
[    1.414470] ACPI : EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    1.418333] ACPI : EC: 8 stale EC events cleared
[    1.421000] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.422111] vgaarb: loaded
[    1.422495] vgaarb: bridge control possible 0000:00:02.0
[    1.424800] SCSI subsystem initialized
[    1.425611] libata version 3.00 loaded.
[    1.426279] ACPI: bus type USB registered
[    1.427239] usbcore: registered new interface driver usbfs
[    1.428158] usbcore: registered new interface driver hub
[    1.429384] usbcore: registered new device driver usb
[    1.430760] EDAC MC: Ver: 3.0.0
[    1.433322] Advanced Linux Sound Architecture Driver Initialized.
[    1.434154] PCI: Using ACPI for IRQ routing
[    1.439564] PCI: pci_cache_line_size set to 64 bytes
[    1.439789] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
[    1.439812] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    1.439825] e820: reserve RAM buffer [mem 0xb8eaa000-0xbbffffff]
[    1.439837] e820: reserve RAM buffer [mem 0xc93ef000-0xcbffffff]
[    1.439849] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    1.439862] e820: reserve RAM buffer [mem 0x11f600000-0x11fffffff]
[    1.442577] Bluetooth: Core ver 2.19
[    1.443191] NET: Registered protocol family 31
[    1.443779] Bluetooth: HCI device and connection manager initialized
[    1.444677] Bluetooth: HCI socket layer initialized
[    1.445339] Bluetooth: L2CAP socket layer initialized
[    1.446121] Bluetooth: SCO socket layer initialized
[    1.448177] cfg80211: Calling CRDA to update world regulatory domain
[    1.449998] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.451276] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.454250] Switched to clocksource hpet
[    1.455983] Could not create debugfs 'set_ftrace_filter' entry
[    1.456852] Could not create debugfs 'set_ftrace_notrace' entry
[    1.749869] FS-Cache: Loaded
[    1.751004] CacheFiles: Loaded
[    1.751860] pnp: PnP ACPI init
[    1.752594] ACPI: bus type PNP registered
[    1.755374] pnp 00:00: [dma 4]
[    1.756040] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.756774] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    1.759032] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.759830] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.760741] system 00:04: [io  0x0680-0x069f] has been reserved
[    1.761587] system 00:04: [io  0x1000-0x100f] has been reserved
[    1.762363] system 00:04: [io  0x5000-0x5003] has been reserved
[    1.763137] system 00:04: [io  0xffff] has been reserved
[    1.763871] system 00:04: [io  0x0400-0x0453] could not be reserved
[    1.764752] system 00:04: [io  0x0458-0x047f] has been reserved
[    1.765536] system 00:04: [io  0x0500-0x057f] has been reserved
[    1.766313] system 00:04: [io  0x0a00-0x0a0f] has been reserved
[    1.767089] system 00:04: [io  0x164e-0x164f] has been reserved
[    1.767878] system 00:04: [io  0x5000-0x500f] could not be reserved
[    1.768756] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.769522] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.770872] system 00:06: [io  0x0454-0x0457] has been reserved
[    1.771713] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    1.772607] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.773978] pnp 00:08: Plug and Play ACPI device, IDs ETD0b00 PNP0f13 (active)
[    1.779007] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.779866] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
[    1.780724] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.781649] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.782509] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.783367] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.784224] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
[    1.785144] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.786014] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
[    1.786924] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.787823] system 00:09: [mem 0xfffff000-0xffffffff] has been reserved
[    1.788739] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.796025] pnp: PnP ACPI: found 10 devices
[    1.796585] ACPI: bus type PNP unregistered
[    1.854112] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.854840] pci 0000:00:1c.0:   bridge window [mem 0xf0700000-0xf07fffff]
[    1.855726] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    1.856380] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.857174] pci 0000:00:1c.3:   bridge window [mem 0xf0600000-0xf06fffff]
[    1.858109] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
[    1.860425] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.861085] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
[    1.862034] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.862037] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.862040] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.862043] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
[    1.862046] pci_bus 0000:01: resource 1 [mem 0xf0700000-0xf07fffff]
[    1.862049] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    1.862051] pci_bus 0000:02: resource 1 [mem 0xf0600000-0xf06fffff]
[    1.862054] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf04fffff 64bit pref]
[    1.862057] pci_bus 0000:03: resource 1 [mem 0xf0500000-0xf05fffff]
[    1.862331] NET: Registered protocol family 2
[    1.864479] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    1.866906] TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
[    1.878249] TCP: Hash tables configured (established 32768 bind 32768)
[    1.879201] TCP: reno registered
[    1.879767] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    1.882041] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    1.885354] NET: Registered protocol family 1
[    1.885999] pci 0000:00:02.0: Boot video device
[    1.894912] PCI: CLS 64 bytes, default 64
[    2.185048] DMA-API: preallocated 65536 debug entries
[    2.185777] DMA-API: debugging enabled by kernel config
[    2.186465] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.187291] software IO TLB [mem 0xc53ef000-0xc93ef000] (64MB) mapped at [ffff8800c53ef000-ffff8800c93eefff]
[    2.196285] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    2.198736] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x17
[    2.199597] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x17
[    2.200460] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x17
[    2.201304] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x17
[    2.203004] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.210694] Scanning for low memory corruption every 60 seconds
[    2.213044] cryptomgr_test (43) used greatest stack depth: 6304 bytes left
[    2.226135] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    2.227758] sha256_ssse3: Using AVX optimized SHA-256 implementation
[    2.229917] sha512_ssse3: Using AVX optimized SHA-512 implementation
[    2.231548] AVX or AES-NI instructions are not detected.
[    2.246808] AVX2 or AES-NI instructions are not detected.
[    2.247513] AVX2 instructions are not detected.
[    2.255422] futex hash table entries: 2048 (order: 6, 262144 bytes)
[    2.256900] Initialise system trusted keyring
[    2.257624] audit: initializing netlink subsys (disabled)
[    2.258856] audit: type=2000 audit(1394095518.226:1): initialized
[    2.266523] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.447469] VFS: Disk quotas dquot_6.5.2
[    2.449670] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.481388] fuse init (API version 7.22)
[    2.486583] msgmni has been set to 7061
[    2.514450] NET: Registered protocol family 38
[    2.515089] Key type asymmetric registered
[    2.515719] Asymmetric key parser 'x509' registered
[    2.518015] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.519577] io scheduler noop registered (default)
[    2.520210] io scheduler deadline registered
[    2.523906] io scheduler cfq registered
[    2.535309] intel_idle: MWAIT substates: 0x21120
[    2.535313] intel_idle: v0.4 model 0x3A
[    2.535315] intel_idle: lapic_timer_reliable_states 0xffffffff
[    2.541101] ipmi message handler version 39.2
[    2.541711] ipmi device interface
[    2.542510] IPMI System Interface driver.
[    2.543412] ipmi_si: Adding default-specified kcs state machine
[    2.544233] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    2.545620] ipmi_si: Interface detection failed
[    2.585675] ipmi_si: Adding default-specified smic state machine
[    2.586508] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    2.587819] ipmi_si: Interface detection failed
[    2.619056] ipmi_si: Adding default-specified bt state machine
[    2.619868] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    2.621149] ipmi_si: Interface detection failed
[    2.646117] ipmi_si: Unable to find any System Interface(s)
[    2.646845] IPMI Watchdog: driver initialized
[    2.647422] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.651828] ACPI: AC Adapter [ADP1] (off-line)
[    2.655114] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    2.656487] ACPI: Lid Switch [LID0]
[    2.658079] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    2.659274] ACPI: Power Button [PWRB]
[    2.660909] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.661896] ACPI: Power Button [PWRF]
[    2.663668] ACPI: Fan [FAN0] (off)
[    2.664997] ACPI: Fan [FAN1] (off)
[    2.666391] ACPI: Fan [FAN2] (off)
[    2.667724] ACPI: Fan [FAN3] (off)
[    2.669124] ACPI: Fan [FAN4] (off)
[    2.714572] thermal LNXTHERM:00: registered as thermal_zone0
[    2.715308] ACPI: Thermal Zone [TZ00] (54 C)
[    2.724824] thermal LNXTHERM:01: registered as thermal_zone1
[    2.725557] ACPI: Thermal Zone [TZ01] (30 C)
[    2.727570] GHES: HEST is not enabled!
[    2.728078] ERST DBG: ERST support is disabled.
[    2.729476] xenfs: not registering filesystem on non-xen platform
[    2.731771] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.751493] Non-volatile memory driver v1.3
[    2.753031] [drm] Initialized drm 1.1.0 20060810
[    2.770179] [drm] Memory usable by graphics device = 2048M
[    2.776478] ACPI: Battery Slot [BAT1] (battery present)
[    2.868219] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    2.868360] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.869309] [drm] Driver supports precise vblank timestamp query.
[    2.870981] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    3.014657] fbcon: inteldrmfb (fb0) is primary device
[    3.203049] tsc: Refined TSC clocksource calibration: 2494.329 MHz
[    3.898761] [drm:intel_dp_start_link_train] *ERROR* too many full retries, give up
[    4.189563] Console: switching to colour frame buffer device 240x67
[    4.200388] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    4.201218] i915 0000:00:02.0: registered panic notifier
[    4.204866] Switched to clocksource tsc
[    4.205367] kwatchdog (176) used greatest stack depth: 6032 bytes left
[    4.265133] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    4.284432] acpi device:39: registered as cooling_device9
[    4.287649] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    4.289120] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    4.333252] brd: module loaded
[    4.357225] loop: module loaded
[    4.361159] mei_me 0000:00:16.0: irq 41 for MSI/MSI-X
[    4.367197] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\PMIO) (20140214/utaddress-258)
[    4.369224] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.370487] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140214/utaddress-258)
[    4.372558] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.373830] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140214/utaddress-258)
[    4.375826] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.377079] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    4.380112] ahci 0000:00:1f.2: version 3.0
[    4.382918] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    4.383324] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1 impl SATA mode
[    4.384831] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    4.385818] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    4.408599] scsi0 : ahci
[    4.415178] scsi1 : ahci
[    4.418182] scsi2 : ahci
[    4.421109] scsi3 : ahci
[    4.424033] scsi4 : ahci
[    4.426997] scsi5 : ahci
[    4.428983] ata1: SATA max UDMA/133 abar m2048@0xf0808000 port 0xf0808100 irq 42
[    4.429899] ata2: DUMMY
[    4.430210] ata3: DUMMY
[    4.430521] ata4: DUMMY
[    4.430832] ata5: DUMMY
[    4.431219] ata6: DUMMY
[    4.431959] tun: Universal TUN/TAP device driver, 1.6
[    4.432595] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.434702] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    4.435440] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[    4.437544] r8169 0000:02:00.0: irq 43 for MSI/MSI-X
[    4.440299] r8169 0000:02:00.0 eth0: RTL8168evl/8111evl at 0xffffc9000003c000, 18:67:b0:3b:b9:60, XID 0c900800 IRQ 43
[    4.441672] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    4.443006] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    4.445267] Copyright(c) 2003- 2014 Intel Corporation
[    4.448483] iwlwifi 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM control
[    4.451392] iwlwifi 0000:01:00.0: irq 44 for MSI/MSI-X
[    4.454742] iwlwifi 0000:01:00.0: Direct firmware load failed with error -2
[    4.457170] iwlwifi 0000:01:00.0: Falling back to user helper
[    4.459957] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.462561] ehci-pci: EHCI PCI platform driver
[    4.467608] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    4.470151] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    4.472941] ehci-pci 0000:00:1d.0: debug port 2
[    4.479420] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    4.479628] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf0809000
[    4.491154] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    4.498466] hub 1-0:1.0: USB hub found
[    4.500895] hub 1-0:1.0: 3 ports detected
[    4.507464] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.510132] ohci-pci: OHCI PCI platform driver
[    4.512760] uhci_hcd: USB Universal Host Controller Interface driver
[    4.518344] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    4.520962] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 2
[    4.529639] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
[    4.529685] xhci_hcd 0000:03:00.0: irq 46 for MSI/MSI-X
[    4.529729] xhci_hcd 0000:03:00.0: irq 47 for MSI/MSI-X
[    4.529773] xhci_hcd 0000:03:00.0: irq 48 for MSI/MSI-X
[    4.529816] xhci_hcd 0000:03:00.0: irq 49 for MSI/MSI-X
[    4.535133] hub 2-0:1.0: USB hub found
[    4.537825] hub 2-0:1.0: 2 ports detected
[    4.543221] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    4.545926] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
[    4.553403] hub 3-0:1.0: USB hub found
[    4.556255] hub 3-0:1.0: 2 ports detected
[    4.562148] usbcore: registered new interface driver usb-storage
[    4.565393] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:EPAD] at 0x60,0x64 irq 1,12
[    4.575051] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.578724] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.587894] usbcore: registered new interface driver synaptics_usb
[    4.592578] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    4.594866] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    4.598643] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    4.605269] ACPI Warning: SystemIO range 0x000000000000efa0-0x000000000000efbf conflicts with OpRegion 0x000000000000efa0-0x000000000000efaf (\_SB_.PCI0.SBUS.SMBI) (20140214/utaddress-258)
[    4.609485] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.613681] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    4.616720] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    4.621710] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.624945] usbcore: registered new interface driver btusb
[    4.628006] Intel P-state driver initializing.
[    4.630731] Intel pstate controlling: cpu 0
[    4.633623] Intel pstate controlling: cpu 1
[    4.636390] Intel pstate controlling: cpu 2
[    4.639072] Intel pstate controlling: cpu 3
[    4.642295] hidraw: raw HID events driver (C) Jiri Kosina
[    4.646670] usbcore: registered new interface driver usbhid
[    4.649087] usbhid: USB HID core driver
[    4.652719] samsung_laptop: detected SABI interface: SwSmi@
[    4.655118] samsung_laptop: Backlight controlled by ACPI video driver
[    4.677440] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
[    4.678363] TCP: cubic registered
[    4.691648] sound hdaudioC0D0: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    4.694329] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.696598] NET: Registered protocol family 10
[    4.699130] sound hdaudioC0D0:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[    4.701744] sound hdaudioC0D0:    mono: mono_out=0x0
[    4.702335] mip6: Mobile IPv6
[    4.702374] sit: IPv6 over IPv4 tunneling driver
[    4.707840] ip6_gre: GRE over IPv6 tunneling driver
[    4.710306] NET: Registered protocol family 17
[    4.710897] Bluetooth: RFCOMM TTY layer initialized
[    4.710938] Bluetooth: RFCOMM socket layer initialized
[    4.710995] Bluetooth: RFCOMM ver 1.11
[    4.711044] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.711114] Bluetooth: BNEP socket layer initialized
[    4.711116] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    4.711152] Bluetooth: HIDP socket layer initialized
[    4.711196] Key type dns_resolver registered
[    4.717873] Loading compiled-in X.509 certificates
[    4.717924] registered taskstats version 1
[    4.719410] cryptomgr_probe (204) used greatest stack depth: 5328 bytes left
[    4.719584] Key type encrypted registered
[    4.724579]   Magic number: 6:513:775
[    4.724618] misc fuse: hash matches
[    4.746454] rtc_cmos 00:05: setting system clock to 2014-03-06 08:45:21 UTC (1394095521)
[    4.746598] sound hdaudioC0D0:    inputs:
[    4.746609] sound hdaudioC0D0:      Mic=0x18
[    4.746617] sound hdaudioC0D0:      Internal Mic=0x12
[    4.754806] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    4.759539] ata1.00: ATA-8: LITEONIT LMT-128M6M, DM72001, max UDMA/133
[    4.762665] ata1.00: 250069680 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.762667] PM: Hibernation image not present or could not be loaded.
[    4.762670] ALSA device list:
[    4.762671]   No soundcards found.
[    4.772585] ata1.00: configured for UDMA/133
[    4.777496] scsi 0:0:0:0: Direct-Access     ATA      LITEONIT LMT-128 DM72 PQ: 0 ANSI: 5
[    4.783888] sd 0:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
[    4.786980] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    4.787911] sd 0:0:0:0: [sda] Write Protect is off
[    4.787914] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.788270] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.798848]  sda: sda1 sda2 sda3
[    4.799602] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    4.802432] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    4.815079] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    4.816040] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.953988] hub 1-1:1.0: USB hub found
[    4.959507] hub 1-1:1.0: 6 ports detected
[    5.076758] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[    5.249309] usb 1-1.5: new full-speed USB device number 3 using ehci-pci
[    5.442880] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
[    5.593708] psmouse serio1: elantech: assuming hardware version 4 (with firmware version 0x575f03)
[    5.614352] psmouse serio1: elantech: Synaptics capabilities query result 0x40, 0x14, 0x0d.
[    5.707801] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input6
[    5.728005] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
[    5.737373] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[    5.780458] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    5.784908] VFS: Mounted root (ext4 filesystem) on device 8:2.
[    5.789782] debug: unmapping init [mem 0xffffffff8214b000-0xffffffff82481fff]
[    5.794674] Write protecting the kernel read-only data: 16384k
[    5.799813] debug: unmapping init [mem 0xffff880001a7d000-0xffff880001bfffff]
[    5.803954] debug: unmapping init [mem 0xffff880001f77000-0xffff880001ffffff]
[    5.808326] BUG: using __this_cpu_add() in preemptible [00000000] code: swapper/0/1
[    5.812331] caller is __this_cpu_preempt_check+0x2b/0x30
[    5.815654] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    5.819553] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    5.823558]  ffff8801182157c0 ffff880118215790 ffffffff81a64cec 0000000000000000
[    5.827177]  ffff8801182157b0 ffffffff81462360 ffff8800c3d553e0 ffffea00030f5500
[    5.830744]  ffff8801182157e8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    5.834134] Call Trace:
[    5.836848]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    5.839943]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    5.842997]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    5.846022]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    5.848863]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    5.850467] BUG: using __this_cpu_add() in preemptible [00000000] code: khubd/36
[    5.850472] caller is __this_cpu_preempt_check+0x2b/0x30
[    5.859125]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    5.862521]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    5.865599]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    5.868738]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    5.871799]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    5.874754]  [<ffffffff81363e64>] ? ext4_ext_map_blocks+0x184/0x1950
[    5.877818]  [<ffffffff81363e64>] ext4_ext_map_blocks+0x184/0x1950
[    5.880862]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    5.883940]  [<ffffffff81334b2c>] ? ext4_map_blocks+0x2dc/0x530
[    5.886943]  [<ffffffff81334a55>] ext4_map_blocks+0x205/0x530
[    5.889912]  [<ffffffff81334fe6>] ext4_getblk+0x56/0x210
[    5.893511]  [<ffffffff8133fcaf>] ext4_find_entry+0x2df/0x510
[    5.896463]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    5.899355]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    5.902252]  [<ffffffff8133ff22>] ext4_lookup+0x42/0x150
[    5.905132]  [<ffffffff812a4cbd>] lookup_real+0x1d/0x50
[    5.907984]  [<ffffffff812a5813>] __lookup_hash+0x33/0x40
[    5.910827]  [<ffffffff812a58b5>] lookup_slow+0x45/0xc0
[    5.913662]  [<ffffffff812a7b22>] link_path_walk+0x872/0x8b0
[    5.916562]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[    5.919460]  [<ffffffff812aa20f>] path_openat+0x9f/0x6e0
[    5.922247]  [<ffffffff812aa88a>] do_filp_open+0x3a/0x90
[    5.925066]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[    5.928009]  [<ffffffff811952fe>] ? put_lock_stats.isra.20+0xe/0x30
[    5.930945]  [<ffffffff812a2430>] ? do_execve_common.isra.25+0x290/0x8d0
[    5.933942]  [<ffffffff812a07b2>] do_open_exec+0x22/0xe0
[    5.936765]  [<ffffffff812a243f>] do_execve_common.isra.25+0x29f/0x8d0
[    5.939716]  [<ffffffff812a22b6>] ? do_execve_common.isra.25+0x116/0x8d0
[    5.942620]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    5.945391]  [<ffffffff812a2a88>] do_execve+0x18/0x20
[    5.948112]  [<ffffffff8100202b>] run_init_process+0x2b/0x30
[    5.950874]  [<ffffffff81002044>] try_to_run_init_process+0x14/0x40
[    5.953682]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    5.956472]  [<ffffffff81a5ac2c>] kernel_init+0x9c/0xf0
[    5.959059]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    5.962611]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    5.965244] CPU: 1 PID: 36 Comm: khubd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    5.968014] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    5.971766]  ffff8801179ad920 ffff8801179ad8f0 ffffffff81a64cec 0000000000000001
[    5.975058]  ffff8801179ad910 ffffffff81462360 ffff8800c302f2c8 ffffea00030c0b00
[    5.978361]  ffff8801179ad948 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    5.981656] Call Trace:
[    5.981919] BUG: using __this_cpu_add() in preemptible [00000000] code: swapper/0/1
[    5.981923] caller is __this_cpu_preempt_check+0x2b/0x30
[    5.988527]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    5.990873]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    5.993367]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    5.995793]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[    5.998281]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    6.000635]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.002976]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.005473]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    6.007976]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    6.010481]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.012914]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    6.015074]  [<ffffffff816e0f04>] ? urb_destroy+0x24/0x30
[    6.017301]  [<ffffffff816e0f04>] urb_destroy+0x24/0x30
[    6.019513]  [<ffffffff816e1061>] usb_free_urb+0x21/0x30
[    6.021676]  [<ffffffff816e1e92>] usb_start_wait_urb+0xa2/0x160
[    6.023940]  [<ffffffff81a6d7c2>] ? wait_for_common+0x122/0x170
[    6.026200]  [<ffffffff816e2425>] usb_control_msg+0xc5/0x110
[    6.028378]  [<ffffffff816e2de2>] usb_get_descriptor+0x82/0xc0
[    6.030624]  [<ffffffff816e69a3>] usb_get_configuration+0x163/0x1600
[    6.032921]  [<ffffffff81a717bc>] ? _raw_spin_unlock_irq+0x2c/0x60
[    6.035158]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.037469]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.039703]  [<ffffffff81a717cd>] ? _raw_spin_unlock_irq+0x3d/0x60
[    6.041913]  [<ffffffff816d84b8>] usb_new_device+0x2c8/0x370
[    6.044100]  [<ffffffff816db412>] hub_thread+0x792/0x16e0
[    6.046257]  [<ffffffff8118c450>] ? __wake_up_common+0x90/0x90
[    6.048416]  [<ffffffff816dac80>] ? usb_reset_device+0x1d0/0x1d0
[    6.050639]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[    6.052685]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    6.054911]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    6.057052]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    6.059234] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    6.059290] BUG: using __this_cpu_add() in preemptible [00000000] code: khubd/36
[    6.059295] caller is __this_cpu_preempt_check+0x2b/0x30
[    6.069017] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    6.072443]  ffff8801182157c0 ffff880118215790 ffffffff81a64cec 0000000000000003
[    6.076336]  ffff8801182157b0 ffffffff81462360 ffff8800c3d553e0 ffffea00030f5500
[    6.079998]  ffff8801182157e8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    6.083569] Call Trace:
[    6.085863]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    6.088573]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    6.091443]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    6.094507]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    6.097250]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.100501]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.103307]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    6.106864]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    6.109803]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.112617]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    6.115298]  [<ffffffff81363e64>] ? ext4_ext_map_blocks+0x184/0x1950
[    6.118164]  [<ffffffff81363e64>] ext4_ext_map_blocks+0x184/0x1950
[    6.121212]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.123964]  [<ffffffff81334b2c>] ? ext4_map_blocks+0x2dc/0x530
[    6.126778]  [<ffffffff81334a55>] ext4_map_blocks+0x205/0x530
[    6.129495]  [<ffffffff81334fe6>] ext4_getblk+0x56/0x210
[    6.132214]  [<ffffffff8133fcaf>] ext4_find_entry+0x2df/0x510
[    6.135008]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.137764]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.141400]  [<ffffffff8133ff22>] ext4_lookup+0x42/0x150
[    6.144378]  [<ffffffff812a4cbd>] lookup_real+0x1d/0x50
[    6.147417]  [<ffffffff812a5813>] __lookup_hash+0x33/0x40
[    6.150042]  [<ffffffff812a58b5>] lookup_slow+0x45/0xc0
[    6.152568]  [<ffffffff812a795d>] link_path_walk+0x6ad/0x8b0
[    6.155205]  [<ffffffff812aa20f>] path_openat+0x9f/0x6e0
[    6.157796]  [<ffffffff812aa88a>] do_filp_open+0x3a/0x90
[    6.160355]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[    6.163022]  [<ffffffff811952fe>] ? put_lock_stats.isra.20+0xe/0x30
[    6.165613]  [<ffffffff812a2430>] ? do_execve_common.isra.25+0x290/0x8d0
[    6.168331]  [<ffffffff812a07b2>] do_open_exec+0x22/0xe0
[    6.170875]  [<ffffffff812a243f>] do_execve_common.isra.25+0x29f/0x8d0
[    6.173570]  [<ffffffff812a22b6>] ? do_execve_common.isra.25+0x116/0x8d0
[    6.176217]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    6.178793]  [<ffffffff812a2a88>] do_execve+0x18/0x20
[    6.181307]  [<ffffffff8100202b>] run_init_process+0x2b/0x30
[    6.184190]  [<ffffffff81002044>] try_to_run_init_process+0x14/0x40
[    6.186850]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    6.189325]  [<ffffffff81a5ac2c>] kernel_init+0x9c/0xf0
[    6.192590]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    6.195121]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    6.197828] CPU: 2 PID: 36 Comm: khubd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    6.200471] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    6.207037]  ffff8801179ada00 ffff8801179ad9d0 ffffffff81a64cec 0000000000000002
[    6.210947]  ffff8801179ad9f0 ffffffff81462360 ffff8800c3128690 ffffea00030c4a00
[    6.211980] BUG: using __this_cpu_add() in preemptible [00000000] code: swapper/0/1
[    6.211984] caller is __this_cpu_preempt_check+0x2b/0x30

[    6.222816]  ffff8801179ada28 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    6.225996] Call Trace:
[    6.228510]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    6.231364]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    6.234364]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    6.237354]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    6.240232]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.243761]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.246529]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    6.249356]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    6.252251]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.255116]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    6.257738]  [<ffffffff816e2434>] ? usb_control_msg+0xd4/0x110
[    6.260459]  [<ffffffff816e2434>] usb_control_msg+0xd4/0x110
[    6.263126]  [<ffffffff816e2de2>] usb_get_descriptor+0x82/0xc0
[    6.265729]  [<ffffffff816e69a3>] usb_get_configuration+0x163/0x1600
[    6.268400]  [<ffffffff81a717bc>] ? _raw_spin_unlock_irq+0x2c/0x60
[    6.271062]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.273754]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.276305]  [<ffffffff81a717cd>] ? _raw_spin_unlock_irq+0x3d/0x60
[    6.278932]  [<ffffffff816d84b8>] usb_new_device+0x2c8/0x370
[    6.281562]  [<ffffffff816db412>] hub_thread+0x792/0x16e0
[    6.284093]  [<ffffffff8118c450>] ? __wake_up_common+0x90/0x90
[    6.287206]  [<ffffffff816dac80>] ? usb_reset_device+0x1d0/0x1d0
[    6.289814]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[    6.292243]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    6.294858]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    6.297683]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    6.300295] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    6.300456] BUG: using __this_cpu_add() in preemptible [00000000] code: khubd/36
[    6.300460] caller is __this_cpu_preempt_check+0x2b/0x30
[    6.307620] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    6.310672]  ffff8801182156c0 ffff880118215690 ffffffff81a64cec 0000000000000003
[    6.313292]  ffff8801182156b0 ffffffff81462360 ffff8800c302f2c8 ffffea00030c0b00
[    6.315864]  ffff8801182156e8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    6.318495] Call Trace:
[    6.320485]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    6.322748]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    6.325232]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    6.327712]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[    6.330225]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    6.332527]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.334910]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.337350]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    6.339892]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    6.342398]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.344928]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    6.347256]  [<ffffffff81363e64>] ? ext4_ext_map_blocks+0x184/0x1950
[    6.349698]  [<ffffffff81363e64>] ext4_ext_map_blocks+0x184/0x1950
[    6.352169]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.354555]  [<ffffffff81334b2c>] ? ext4_map_blocks+0x2dc/0x530
[    6.357016]  [<ffffffff81334a55>] ext4_map_blocks+0x205/0x530
[    6.359376]  [<ffffffff81453c6b>] ? string.isra.5+0x3b/0xf0
[    6.361746]  [<ffffffff81334fe6>] ext4_getblk+0x56/0x210
[    6.364086]  [<ffffffff813351b8>] ext4_bread+0x18/0xb0
[    6.366360]  [<ffffffff8133e20b>] __ext4_read_dirblock+0x3b/0x2e0
[    6.368788]  [<ffffffff8133e4f1>] dx_probe+0x41/0x380
[    6.371092]  [<ffffffff8133f865>] ext4_dx_find_entry+0x45/0x1b0
[    6.373498]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[    6.375783]  [<ffffffff811a00a1>] ? __raw_spin_lock_init+0x21/0x60
[    6.378213]  [<ffffffff8133fe25>] ext4_find_entry+0x455/0x510
[    6.380551]  [<ffffffff811952fe>] ? put_lock_stats.isra.20+0xe/0x30
[    6.382888]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.385132]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.387384]  [<ffffffff8133ff22>] ext4_lookup+0x42/0x150
[    6.389516]  [<ffffffff812a4cbd>] lookup_real+0x1d/0x50
[    6.391685]  [<ffffffff812a9cad>] do_last+0x90d/0xdd0
[    6.393813]  [<ffffffff812aa22e>] path_openat+0xbe/0x6e0
[    6.395927]  [<ffffffff812aa88a>] do_filp_open+0x3a/0x90
[    6.398075]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[    6.400343]  [<ffffffff811952fe>] ? put_lock_stats.isra.20+0xe/0x30
[    6.402567]  [<ffffffff812a2430>] ? do_execve_common.isra.25+0x290/0x8d0
[    6.404877]  [<ffffffff812a07b2>] do_open_exec+0x22/0xe0
[    6.407046]  [<ffffffff812a243f>] do_execve_common.isra.25+0x29f/0x8d0
[    6.409315]  [<ffffffff812a22b6>] ? do_execve_common.isra.25+0x116/0x8d0
[    6.411631]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    6.413789]  [<ffffffff812a2a88>] do_execve+0x18/0x20
[    6.415875]  [<ffffffff8100202b>] run_init_process+0x2b/0x30
[    6.418058]  [<ffffffff81002044>] try_to_run_init_process+0x14/0x40
[    6.420319]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    6.422439]  [<ffffffff81a5ac2c>] kernel_init+0x9c/0xf0
[    6.424570]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    6.426724]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    6.428841] CPU: 0 PID: 36 Comm: khubd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    6.431486] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    6.434551]  ffff8801179adaa0 ffff8801179ada70 ffffffff81a64cec 0000000000000000
[    6.437231]  ffff8801179ada90 ffffffff81462360 ffff8800c311bd90 ffffea00030c4680
[    6.443208]  ffff8801179adac8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    6.447792] Call Trace:
[    6.449892]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    6.450158] BUG: using __this_cpu_add() in preemptible [00000000] code: swapper/0/1
[    6.450162] caller is __this_cpu_preempt_check+0x2b/0x30
[    6.457968]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    6.460777]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    6.464270]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[    6.467200]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    6.470621]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.473161]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.475914]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    6.478742]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    6.481584]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.484385]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    6.486978]  [<ffffffff816e7019>] ? usb_get_configuration+0x7d9/0x1600
[    6.489559]  [<ffffffff816e7019>] usb_get_configuration+0x7d9/0x1600
[    6.492328]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.494977]  [<ffffffff81a717cd>] ? _raw_spin_unlock_irq+0x3d/0x60
[    6.497588]  [<ffffffff816d84b8>] usb_new_device+0x2c8/0x370
[    6.500102]  [<ffffffff816db412>] hub_thread+0x792/0x16e0
[    6.502539]  [<ffffffff8118c450>] ? __wake_up_common+0x90/0x90
[    6.505083]  [<ffffffff816dac80>] ? usb_reset_device+0x1d0/0x1d0
[    6.507650]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[    6.510076]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    6.512589]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    6.515111]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    6.517954] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    6.520636] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    6.521533] BUG: using __this_cpu_add() in preemptible [00000000] code: khubd/36
[    6.521537] caller is __this_cpu_preempt_check+0x2b/0x30
[    6.530091]  ffff880118215660 ffff880118215630 ffffffff81a64cec 0000000000000001
[    6.533831]  ffff880118215650 ffffffff81462360 ffff8800c302f2c8 ffffea00030c0b00
[    6.537447]  ffff880118215688 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    6.540507] Call Trace:
[    6.542813]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    6.545527]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    6.548405]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    6.551276]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[    6.554173]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    6.556907]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.559588]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.562403]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    6.565330]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    6.568447]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.571354]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    6.574055]  [<ffffffff81363e64>] ? ext4_ext_map_blocks+0x184/0x1950
[    6.576944]  [<ffffffff81363e64>] ext4_ext_map_blocks+0x184/0x1950
[    6.579745]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.582558]  [<ffffffff81334b2c>] ? ext4_map_blocks+0x2dc/0x530
[    6.585402]  [<ffffffff81334a55>] ext4_map_blocks+0x205/0x530
[    6.588219]  [<ffffffff81453c6b>] ? string.isra.5+0x3b/0xf0
[    6.591016]  [<ffffffff81334fe6>] ext4_getblk+0x56/0x210
[    6.594318]  [<ffffffff813351b8>] ext4_bread+0x18/0xb0
[    6.597039]  [<ffffffff8133e20b>] __ext4_read_dirblock+0x3b/0x2e0
[    6.600607]  [<ffffffff8133e4f1>] dx_probe+0x41/0x380
[    6.603248]  [<ffffffff8133f865>] ext4_dx_find_entry+0x45/0x1b0
[    6.606067]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[    6.608828]  [<ffffffff811a00a1>] ? __raw_spin_lock_init+0x21/0x60
[    6.611686]  [<ffffffff8133fe25>] ext4_find_entry+0x455/0x510
[    6.614494]  [<ffffffff811952fe>] ? put_lock_stats.isra.20+0xe/0x30
[    6.617370]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.621031]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.623842]  [<ffffffff8133ff22>] ext4_lookup+0x42/0x150
[    6.626465]  [<ffffffff812a4cbd>] lookup_real+0x1d/0x50
[    6.629101]  [<ffffffff812a5813>] __lookup_hash+0x33/0x40
[    6.631890]  [<ffffffff812a58b5>] lookup_slow+0x45/0xc0
[    6.634518]  [<ffffffff812a7b22>] link_path_walk+0x872/0x8b0
[    6.637184]  [<ffffffff812aa537>] path_openat+0x3c7/0x6e0
[    6.639735]  [<ffffffff812aa88a>] do_filp_open+0x3a/0x90
[    6.642330]  [<ffffffff811952fe>] ? put_lock_stats.isra.20+0xe/0x30
[    6.645025]  [<ffffffff812a2430>] ? do_execve_common.isra.25+0x290/0x8d0
[    6.647781]  [<ffffffff812a07b2>] do_open_exec+0x22/0xe0
[    6.650357]  [<ffffffff812a243f>] do_execve_common.isra.25+0x29f/0x8d0
[    6.653008]  [<ffffffff812a22b6>] ? do_execve_common.isra.25+0x116/0x8d0
[    6.655741]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    6.658331]  [<ffffffff812a2a88>] do_execve+0x18/0x20
[    6.660879]  [<ffffffff8100202b>] run_init_process+0x2b/0x30
[    6.664090]  [<ffffffff81002044>] try_to_run_init_process+0x14/0x40
[    6.666704]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    6.669272]  [<ffffffff81a5ac2c>] kernel_init+0x9c/0xf0
[    6.671820]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    6.674377]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    6.676919] CPU: 0 PID: 36 Comm: khubd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    6.679506] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    6.684830]  ffff8801179ad980 ffff8801179ad950 ffffffff81a64cec 0000000000000000
[    6.690953] BUG: using __this_cpu_add() in preemptible [00000000] code: swapper/0/1
[    6.690975]  ffff8801179ad970 ffffffff81462360 ffff8800c302eeb8 ffffea00030c0b00
[    6.690982]  ffff8801179ad9a8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    6.690983] Call Trace:
[    6.690989]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    6.690994]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    6.690999]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    6.691004]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[    6.691008]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    6.691012]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.691017]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.691021]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    6.691026]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    6.691030]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.691035]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    6.691040]  [<ffffffff816e0f04>] ? urb_destroy+0x24/0x30
[    6.691044]  [<ffffffff816e0f04>] urb_destroy+0x24/0x30
[    6.691048]  [<ffffffff816e1061>] usb_free_urb+0x21/0x30
[    6.691052]  [<ffffffff816e1e92>] usb_start_wait_urb+0xa2/0x160
[    6.691057]  [<ffffffff81a6d7c2>] ? wait_for_common+0x122/0x170
[    6.691061]  [<ffffffff816e2425>] usb_control_msg+0xc5/0x110
[    6.691065]  [<ffffffff816e24d9>] usb_get_string+0x69/0xa0
[    6.691070]  [<ffffffff816e2581>] usb_string_sub+0x71/0x150
[    6.691074]  [<ffffffff816e2eba>] usb_string+0x9a/0x260
[    6.691079]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.691083]  [<ffffffff816e30c9>] usb_cache_string+0x49/0xb0
[    6.691087]  [<ffffffff816d826c>] usb_new_device+0x7c/0x370
[    6.691091]  [<ffffffff816db412>] hub_thread+0x792/0x16e0
[    6.691096]  [<ffffffff8118c450>] ? __wake_up_common+0x90/0x90
[    6.691100]  [<ffffffff816dac80>] ? usb_reset_device+0x1d0/0x1d0
[    6.691104]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[    6.691108]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    6.691112]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    6.691116]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    6.777293] caller is __this_cpu_preempt_check+0x2b/0x30
[    6.779573] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    6.782455] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    6.785836]  ffff880118215820 ffff8801182157f0 ffffffff81a64cec 0000000000000001
[    6.788636]  ffff880118215810 ffffffff81462360 ffff8800c3d553e0 ffffea00030f5500
[    6.791302]  ffff880118215848 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    6.793992] Call Trace:
[    6.795950]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    6.798383]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    6.800819]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    6.803179]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    6.805470]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.807798]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.810038]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    6.812440]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    6.814860]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    6.817248]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    6.819375]  [<ffffffff81363e64>] ? ext4_ext_map_blocks+0x184/0x1950
[    6.821736]  [<ffffffff81363e64>] ext4_ext_map_blocks+0x184/0x1950
[    6.824122]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.826315]  [<ffffffff81334b2c>] ? ext4_map_blocks+0x2dc/0x530
[    6.828620]  [<ffffffff81334a55>] ext4_map_blocks+0x205/0x530
[    6.830893]  [<ffffffff81334fe6>] ext4_getblk+0x56/0x210
[    6.833057]  [<ffffffff8133fcaf>] ext4_find_entry+0x2df/0x510
[    6.835331]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    6.837577]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    6.839805]  [<ffffffff8133ff22>] ext4_lookup+0x42/0x150
[    6.842027]  [<ffffffff812a4cbd>] lookup_real+0x1d/0x50
[    6.844242]  [<ffffffff812a9cad>] do_last+0x90d/0xdd0
[    6.846368]  [<ffffffff812aa55e>] path_openat+0x3ee/0x6e0
[    6.848575]  [<ffffffff812aa88a>] do_filp_open+0x3a/0x90
[    6.850730]  [<ffffffff811952fe>] ? put_lock_stats.isra.20+0xe/0x30
[    6.852914]  [<ffffffff812a2430>] ? do_execve_common.isra.25+0x290/0x8d0
[    6.855199]  [<ffffffff812a07b2>] do_open_exec+0x22/0xe0
[    6.857312]  [<ffffffff812a243f>] do_execve_common.isra.25+0x29f/0x8d0
[    6.859515]  [<ffffffff812a22b6>] ? do_execve_common.isra.25+0x116/0x8d0
[    6.861780]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    6.863886]  [<ffffffff812a2a88>] do_execve+0x18/0x20
[    6.865894]  [<ffffffff8100202b>] run_init_process+0x2b/0x30
[    6.868038]  [<ffffffff81002044>] try_to_run_init_process+0x14/0x40
[    6.870189]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    6.872294]  [<ffffffff81a5ac2c>] kernel_init+0x9c/0xf0
[    6.874377]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    6.876424]  [<ffffffff81a5ab90>] ? rest_init+0x140/0x140
[    7.267769] check_preemption_disabled: 243 callbacks suppressed
[    7.271512] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd/1
[    7.275255] caller is __this_cpu_preempt_check+0x2b/0x30
[    7.278775] CPU: 1 PID: 1 Comm: systemd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    7.282638] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    7.286794]  ffff880118215d70 ffff880118215d40 ffffffff81a64cec 0000000000000001
[    7.290320]  ffff880118215d60 ffffffff81462360 ffff8801183f0000 ffffea000460fc00
[    7.294208]  ffff880118215d98 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    7.297825] Call Trace:
[    7.300457]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    7.303488]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    7.306694]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    7.309912]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[    7.313002]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    7.315925]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    7.318879]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    7.321737]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    7.324705]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    7.327729]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    7.330498]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[    7.333232]  [<ffffffff812a5ae2>] ? final_putname+0x22/0x50
[    7.335939]  [<ffffffff812a5ae2>] final_putname+0x22/0x50
[    7.338628]  [<ffffffff812a5d89>] putname+0x29/0x40
[    7.341132]  [<ffffffff812aac0c>] user_path_create+0x4c/0x60
[    7.343635]  [<ffffffff812ab117>] SyS_mkdirat+0x37/0xc0
[    7.346106]  [<ffffffff812ab1b9>] SyS_mkdir+0x19/0x20
[    7.348512]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[    7.351268] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd/1
[    7.353824] caller is __this_cpu_preempt_check+0x2b/0x30
[    7.356177] CPU: 1 PID: 1 Comm: systemd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    7.359013] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    7.362109]  ffff880118215de0 ffff880118215db0 ffffffff81a64cec 0000000000000001
[    7.364763]  ffff880118215dd0 ffffffff81462360 ffff8800c3129110 ffffea00030c4a00
[    7.367357]  ffff880118215e08 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    7.369944] Call Trace:
[    7.371886]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    7.374093]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    7.376518]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    7.379010]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    7.381289]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    7.383539]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    7.385877]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    7.388332]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    7.390754]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    7.393177]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    7.395410]  [<ffffffff812c0f19>] ? SyS_mount+0x99/0xc0
[    7.397639]  [<ffffffff812c0f19>] SyS_mount+0x99/0xc0
[    7.399890]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[    7.402317] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd/1
[    7.407336] caller is __this_cpu_preempt_check+0x2b/0x30
[    7.412021] CPU: 0 PID: 1 Comm: systemd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    7.417305] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    7.422506]  ffff880118215db0 ffff880118215d80 ffffffff81a64cec 0000000000000000
[    7.427346]  ffff880118215da0 ffffffff81462360 ffff8801183f0000 ffffea000460fc00
[    7.431889]  ffff880118215dd8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    7.436337] Call Trace:
[    7.439522]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    7.443056]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    7.446767]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    7.450222]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[    7.453720]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    7.457081]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    7.460239]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    7.463461]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    7.466820]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    7.470021]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    7.473181]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[    7.476255]  [<ffffffff812a5ae2>] ? final_putname+0x22/0x50
[    7.479126]  [<ffffffff812a5ae2>] final_putname+0x22/0x50
[    7.481951]  [<ffffffff812a5d89>] putname+0x29/0x40
[    7.484695]  [<ffffffff812c0f21>] SyS_mount+0xa1/0xc0
[    7.487243]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[    7.489999] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd/1
[    7.495100] caller is __this_cpu_preempt_check+0x2b/0x30
[    7.499810] CPU: 2 PID: 1 Comm: systemd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    7.505047] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    7.510213]  ffff880118215de0 ffff880118215db0 ffffffff81a64cec 0000000000000002
[    7.514947]  ffff880118215dd0 ffffffff81462360 ffff8800c3128fc0 ffffea00030c4a00
[    7.519319]  ffff880118215e08 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    7.523702] Call Trace:
[    7.527430]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    7.530927]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    7.534608]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    7.538039]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    7.541346]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    7.544670]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    7.547810]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    7.551095]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    7.554408]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    7.557695]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    7.560624]  [<ffffffff812c0f2a>] ? SyS_mount+0xaa/0xc0
[    7.563621]  [<ffffffff812c0f2a>] SyS_mount+0xaa/0xc0
[    7.566568]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[    7.569685] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd/1
[    7.571894] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u17:0/34
[    7.571905] caller is __this_cpu_preempt_check+0x2b/0x30
[    7.571911] CPU: 0 PID: 34 Comm: kworker/u17:0 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    7.571915] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    7.571926] Workqueue: hci0 hci_power_off
[    7.571938]  ffff880117e29b30 ffff880117e29b00 ffffffff81a64cec 0000000000000000
[    7.571948]  ffff880117e29b20 ffffffff81462360 ffff8800c3130d20 ffffea00030c4c00
[    7.571958]  ffff880117e29b58 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    7.571960] Call Trace:
[    7.571969]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    7.571978]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    7.571985]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    7.571993]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[    7.572001]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    7.572009]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    7.572016]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    7.572023]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    7.572031]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    7.572039]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    7.572048]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    7.572059]  [<ffffffff81818f6e>] ? skb_release_data+0x11e/0x130
[    7.572067]  [<ffffffff81818f6e>] skb_release_data+0x11e/0x130
[    7.572075]  [<ffffffff81961b22>] ? hci_sock_dev_event+0xc2/0x2b0
[    7.572084]  [<ffffffff81818fa4>] skb_release_all+0x24/0x30
[    7.572092]  [<ffffffff81818d36>] kfree_skb+0x36/0x150
[    7.572098]  [<ffffffff81961b22>] hci_sock_dev_event+0xc2/0x2b0
[    7.572105]  [<ffffffff8193e023>] hci_dev_do_close+0x113/0x490
[    7.572111]  [<ffffffff8193e472>] hci_power_off+0x22/0x50
[    7.572119]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[    7.572125]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[    7.572132]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[    7.572139]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[    7.572145]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[    7.572152]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    7.572159]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    7.572165]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    7.572192] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u17:0/34
[    7.572198] caller is __this_cpu_preempt_check+0x2b/0x30
[    7.572202] CPU: 0 PID: 34 Comm: kworker/u17:0 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    7.572205] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    7.572211] Workqueue: hci0 hci_power_off
[    7.572222]  ffff880117e29b60 ffff880117e29b30 ffffffff81a64cec 0000000000000000
[    7.572232]  ffff880117e29b50 ffffffff81462360 ffff8801179d58c0 ffffea00045e7500
[    7.572242]  ffff880117e29b88 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    7.572243] Call Trace:
[    7.572251]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    7.572258]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    7.572266]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    7.572274]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[    7.572280]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    7.572287]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    7.572294]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    7.572301]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    7.572309]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    7.572316]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    7.572325]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[    7.572332]  [<ffffffff81817787>] ? kfree_skbmem+0x37/0xa0
[    7.572339]  [<ffffffff81961b22>] ? hci_sock_dev_event+0xc2/0x2b0
[    7.572346]  [<ffffffff81817787>] kfree_skbmem+0x37/0xa0
[    7.572354]  [<ffffffff81818d3e>] kfree_skb+0x3e/0x150
[    7.572361]  [<ffffffff81961b22>] hci_sock_dev_event+0xc2/0x2b0
[    7.572367]  [<ffffffff8193e023>] hci_dev_do_close+0x113/0x490
[    7.572373]  [<ffffffff8193e472>] hci_power_off+0x22/0x50
[    7.572380]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[    7.572386]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[    7.572393]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[    7.572399]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[    7.572404]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[    7.572411]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    7.572418]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    7.572423]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    7.572537] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u17:0/34
[    7.572543] caller is __this_cpu_preempt_check+0x2b/0x30
[    7.572547] CPU: 0 PID: 34 Comm: kworker/u17:0 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    7.572550] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    7.572557] Workqueue: hci0 hci_power_off
[    7.572567]  ffff880117e29b70 ffff880117e29b40 ffffffff81a64cec 0000000000000000
[    7.572577]  ffff880117e29b60 ffffffff81462360 ffff8800c31313b0 ffffea00030c4c00
[    7.572587]  ffff880117e29b98 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    7.572588] Call Trace:
[    7.572596]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    7.572604]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    7.572611]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    7.572618]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    7.572625]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    7.572632]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    7.572638]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    7.572646]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    7.572654]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    7.572662]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    7.572671]  [<ffffffff81818f6e>] ? skb_release_data+0x11e/0x130
[    7.572679]  [<ffffffff81818f6e>] skb_release_data+0x11e/0x130
[    7.572685]  [<ffffffff8193e0b6>] ? hci_dev_do_close+0x1a6/0x490
[    7.572693]  [<ffffffff81818fa4>] skb_release_all+0x24/0x30
[    7.572700]  [<ffffffff81818d36>] kfree_skb+0x36/0x150
[    7.572707]  [<ffffffff8193e0b6>] hci_dev_do_close+0x1a6/0x490
[    7.572713]  [<ffffffff8193e472>] hci_power_off+0x22/0x50
[    7.572719]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[    7.572726]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[    7.572732]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[    7.572739]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[    7.572744]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[    7.572750]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    7.572758]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    7.572763]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    7.572785] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u17:0/34
[    7.572791] caller is __this_cpu_preempt_check+0x2b/0x30
[    7.572794] CPU: 0 PID: 34 Comm: kworker/u17:0 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    7.572797] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    7.572803] Workqueue: hci0 hci_power_off
[    7.572813]  ffff880117e29ba0 ffff880117e29b70 ffffffff81a64cec 0000000000000000
[    7.572823]  ffff880117e29b90 ffffffff81462360 ffff8801179d7a80 ffffea00045e7500
[    7.572833]  ffff880117e29bc8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    7.572835] Call Trace:
[    7.572842]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    7.572849]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    7.572857]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    7.572863]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    7.572870]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    7.572877]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    7.572883]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    7.572891]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    7.572898]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    7.572907]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[    7.572914]  [<ffffffff81817787>] ? kfree_skbmem+0x37/0xa0
[    7.572921]  [<ffffffff8193e0b6>] ? hci_dev_do_close+0x1a6/0x490
[    7.572928]  [<ffffffff81817787>] kfree_skbmem+0x37/0xa0
[    7.572936]  [<ffffffff81818d3e>] kfree_skb+0x3e/0x150
[    7.572942]  [<ffffffff8193e0b6>] hci_dev_do_close+0x1a6/0x490
[    7.572948]  [<ffffffff8193e472>] hci_power_off+0x22/0x50
[    7.572954]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[    7.572961]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[    7.572967]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[    7.572974]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[    7.572979]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[    7.572985]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    7.572992]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    7.572997]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    7.573018] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u17:0/34
[    7.573024] caller is __this_cpu_preempt_check+0x2b/0x30
[    7.573028] CPU: 0 PID: 34 Comm: kworker/u17:0 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    7.573030] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    7.573036] Workqueue: hci0 hci_power_off
[    7.573046]  ffff880117e29b70 ffff880117e29b40 ffffffff81a64cec 0000000000000000
[    7.573056]  ffff880117e29b60 ffffffff81462360 ffff8800c30169a0 ffffea00030c0400
[    7.573066]  ffff880117e29b98 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    7.573068] Call Trace:
[    7.573075]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    7.573082]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    7.573090]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    7.573096]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    7.573103]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    7.573110]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    7.573116]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    7.573124]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    7.573131]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    7.573139]  [<ffffffff81287327>] kfree+0x2f7/0x300
[    7.573147]  [<ffffffff81818f6e>] ? skb_release_data+0x11e/0x130
[    7.573155]  [<ffffffff81818f6e>] skb_release_data+0x11e/0x130
[    7.573161]  [<ffffffff8193e0cd>] ? hci_dev_do_close+0x1bd/0x490
[    7.573169]  [<ffffffff81818fa4>] skb_release_all+0x24/0x30
[    7.573177]  [<ffffffff81818d36>] kfree_skb+0x36/0x150
[    7.573183]  [<ffffffff8193e0cd>] hci_dev_do_close+0x1bd/0x490
[    7.573189]  [<ffffffff8193e472>] hci_power_off+0x22/0x50
[    7.573195]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[    7.573202]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[    7.573208]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[    7.573215]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[    7.573220]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[    7.573226]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    7.573233]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[    7.573238]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[    8.394088] caller is __this_cpu_preempt_check+0x2b/0x30
[    8.398688] CPU: 3 PID: 1 Comm: systemd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[    8.403773] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[    8.408777]  ffff880118215cc0 ffff880118215c90 ffffffff81a64cec 0000000000000003
[    8.413507]  ffff880118215cb0 ffffffff81462360 ffff8801183f0000 ffffea000460fc00
[    8.417623]  ffff880118215ce8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[    8.421730] Call Trace:
[    8.425180]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[    8.428674]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[    8.432331]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[    8.435747]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[    8.439021]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[    8.442315]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[    8.445414]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[    8.448676]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[    8.451952]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    8.455192]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[    8.458157]  [<ffffffff812a5ae2>] ? final_putname+0x22/0x50
[    8.461104]  [<ffffffff812a5ae2>] final_putname+0x22/0x50
[    8.464019]  [<ffffffff812a5d89>] putname+0x29/0x40
[    8.466726]  [<ffffffff812a900f>] user_path_at_empty+0x5f/0x90
[    8.469549]  [<ffffffff81a732d9>] ? sysret_check+0x22/0x5d
[    8.472343]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[    8.475095]  [<ffffffff812a9051>] user_path_at+0x11/0x20
[    8.477745]  [<ffffffff81303daa>] SyS_name_to_handle_at+0x4a/0x1e0
[    8.480500]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    8.483300]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[    8.538812] systemd[1]: systemd 208 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    8.580512] systemd[1]: Set hostname to <ultrae>.
[    8.615418] random: systemd urandom read with 120 bits of entropy available
[    8.660366] systemd-system- (218) used greatest stack depth: 4096 bytes left
[    8.688536] systemd-fstab-g (220) used greatest stack depth: 4048 bytes left
[    8.774350] random: nonblocking pool is initialized
[    9.278083] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory.
[    9.282845] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    9.287024] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    9.289983] systemd[1]: Expecting device sys-subsystem-net-devices-wlp1s0.device...
[    9.299525] systemd[1]: Starting Remote File Systems.
[    9.307579] systemd[1]: Reached target Remote File Systems.
[    9.310142] systemd[1]: Expecting device sys-subsystem-net-devices-enp2s0.device...
[    9.318221] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    9.326861] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    9.329475] systemd[1]: Starting Device-mapper event daemon FIFOs.
[    9.337886] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    9.340542] systemd[1]: Starting Delayed Shutdown Socket.
[    9.348455] systemd[1]: Listening on Delayed Shutdown Socket.
[    9.351149] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    9.354730] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    9.357608] systemd[1]: Starting Journal Socket.
[    9.365970] systemd[1]: Listening on Journal Socket.
[    9.371270] systemd[1]: Starting Apply Kernel Variables...
[    9.415396] systemd[1]: Mounting POSIX Message Queue File System...
[    9.436483] systemd[1]: Starting Journal Service...
[    9.469176] systemd[1]: Started Journal Service.
[    9.505851] mount (225) used greatest stack depth: 3456 bytes left
[    9.552623] systemd-journald[226]: Vacuuming done, freed 0 bytes
[   10.391351] EXT4-fs (sda2): re-mounted. Opts: data=ordered
[   10.546791] systemd-udevd[256]: starting version 208
[   11.659076] iwlwifi 0000:01:00.0: loaded firmware version 18.168.6.1 op_mode iwldvm
[   11.662345] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   11.665371] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   11.668387] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[   11.671294] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Advanced-N 6235 AGN, REV=0xB0
[   11.674967] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   11.754665] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   11.909783] systemd-udevd[264]: renamed network interface eth0 to enp2s0
[   12.360069] check_preemption_disabled: 63086 callbacks suppressed
[   12.363036] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-udevd/256
[   12.363043] caller is __this_cpu_preempt_check+0x2b/0x30
[   12.363048] CPU: 1 PID: 256 Comm: systemd-udevd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   12.363050] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   12.363058]  ffff8801143e7b10 ffff8801143e7ae0 ffffffff81a64cec 0000000000000001
[   12.363065]  ffff8801143e7b00 ffffffff81462360 ffff8800c2c66f90 ffffea00030b1800
[   12.363072]  ffff8801143e7b38 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   12.363074] Call Trace:
[   12.363082]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   12.363087]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   12.363092]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   12.363096]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   12.363101]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   12.363104] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-udevd/274
[   12.363109] caller is __this_cpu_preempt_check+0x2b/0x30
[   12.363113]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   12.363118]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   12.363123]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   12.363128]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   12.363133]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.363139]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   12.363145]  [<ffffffff81818f6e>] ? skb_release_data+0x11e/0x130
[   12.363150]  [<ffffffff81818f6e>] skb_release_data+0x11e/0x130
[   12.363155]  [<ffffffff81818fa4>] skb_release_all+0x24/0x30
[   12.363160]  [<ffffffff81819080>] consume_skb+0x30/0x140
[   12.363164]  [<ffffffff8181f645>] skb_free_datagram+0x15/0x40
[   12.363170]  [<ffffffff818d669d>] unix_dgram_recvmsg+0x24d/0x450
[   12.363174]  [<ffffffff8180deb7>] sock_recvmsg+0x77/0x90
[   12.363180]  [<ffffffff812bb846>] ? fget_light+0x16/0x20
[   12.363184]  [<ffffffff8180e180>] ? sockfd_lookup_light+0x20/0x80
[   12.363189]  [<ffffffff8181056c>] SyS_recvfrom+0xec/0x150
[   12.363194]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.363199]  [<ffffffff811974df>] ? trace_hardirqs_on_caller+0x10f/0x230
[   12.363204]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   12.363210]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   12.363214] CPU: 2 PID: 274 Comm: systemd-udevd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   12.363216] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   12.363224]  ffff8800c2c21da0 ffff8800c2c21d70 ffffffff81a64cec 0000000000000002
[   12.363228]  ffff8800c2c21d90 ffffffff81462360
[   12.363228] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-udevd/256
[   12.363232]  ffff8800c333d780 ffffea00030cce00
[   12.363232] caller is __this_cpu_preempt_check+0x2b/0x30

[   12.363240]  ffff8800c2c21dc8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   12.363241] Call Trace:
[   12.363248]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   12.363253]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   12.363257]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   12.363262]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   12.363267]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   12.363271]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   12.363276]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   12.363280]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   12.363285]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.363291]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   12.363295]  [<ffffffff812a5ae2>] ? final_putname+0x22/0x50
[   12.363299]  [<ffffffff812a5ae2>] final_putname+0x22/0x50
[   12.363302]  [<ffffffff812a5d89>] putname+0x29/0x40
[   12.363307]  [<ffffffff8129a569>] do_sys_open+0x199/0x220
[   12.363311]  [<ffffffff8129a60e>] SyS_open+0x1e/0x20
[   12.363315]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   12.363319] CPU: 1 PID: 256 Comm: systemd-udevd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   12.363321] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   12.363328]  ffff8801143e7b40 ffff8801143e7b10 ffffffff81a64cec 0000000000000001
[   12.363489] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-udevd/274
[   12.363493] caller is __this_cpu_preempt_check+0x2b/0x30
[   12.363611]  ffff8801143e7b30 ffffffff81462360 ffff8800c2e1fcc0 ffffea00030b8700
[   12.363618]  ffff8801143e7b68 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   12.363620] Call Trace:
[   12.363625]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   12.363630]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   12.363634]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   12.363639]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   12.363644]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   12.363648]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   12.363653]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   12.363657]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   12.363662]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   12.363667]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.363672]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   12.363678]  [<ffffffff81817787>] ? kfree_skbmem+0x37/0xa0
[   12.363683]  [<ffffffff81817787>] kfree_skbmem+0x37/0xa0
[   12.363687]  [<ffffffff81819088>] consume_skb+0x38/0x140
[   12.363691]  [<ffffffff8181f645>] skb_free_datagram+0x15/0x40
[   12.363696]  [<ffffffff818d669d>] unix_dgram_recvmsg+0x24d/0x450
[   12.363700]  [<ffffffff8180deb7>] sock_recvmsg+0x77/0x90
[   12.363705]  [<ffffffff812bb846>] ? fget_light+0x16/0x20
[   12.363709]  [<ffffffff8180e180>] ? sockfd_lookup_light+0x20/0x80
[   12.363713]  [<ffffffff8181056c>] SyS_recvfrom+0xec/0x150
[   12.363718]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.363723]  [<ffffffff811974df>] ? trace_hardirqs_on_caller+0x10f/0x230
[   12.363728]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   12.363732]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   12.363736] CPU: 2 PID: 274 Comm: systemd-udevd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   12.363738] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   12.363746]  ffff8800c2c21c70 ffff8800c2c21c40 ffffffff81a64cec 0000000000000002
[   12.363754]  ffff8800c2c21c60 ffffffff81462360 ffff8800c2c8a290 ffffea00030b2200
[   12.363762]  ffff8800c2c21c98 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   12.363763] Call Trace:
[   12.363770]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   12.363775]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   12.363780]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   12.363785]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   12.363789]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   12.363794]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   12.363798]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   12.363803]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   12.363808]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   12.363813]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.363818]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   12.363824]  [<ffffffff816101fd>] ? uevent_show+0xed/0x110
[   12.363829]  [<ffffffff816101fd>] uevent_show+0xed/0x110
[   12.363833]  [<ffffffff816103d0>] dev_attr_show+0x20/0x60
[   12.363839]  [<ffffffff8131e3a9>] ? sysfs_file_ops+0x49/0x70
[   12.363844]  [<ffffffff8131e4a2>] sysfs_kf_seq_show+0x72/0x120
[   12.363849]  [<ffffffff8131d0e6>] kernfs_seq_show+0x26/0x30
[   12.363854]  [<ffffffff812c1d04>] seq_read+0x164/0x3e0
[   12.363859]  [<ffffffff8131d92d>] kernfs_fop_read+0xfd/0x170
[   12.363864]  [<ffffffff8129b64a>] vfs_read+0x9a/0x170
[   12.363868]  [<ffffffff8129bb1c>] SyS_read+0x4c/0xa0
[   12.363872]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   12.363897] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-udevd/274
[   12.363900] caller is __this_cpu_preempt_check+0x2b/0x30
[   12.363903] CPU: 2 PID: 274 Comm: systemd-udevd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   12.363905] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   12.363912]  ffff8800c2c21d00 ffff8800c2c21cd0 ffffffff81a64cec 0000000000000002
[   12.363919]  ffff8800c2c21cf0 ffffffff81462360 ffff8800c2dc88e8 ffffea00030b7200
[   12.363926]  ffff8800c2c21d28 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   12.363927] Call Trace:
[   12.363932]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   12.363936]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   12.363941]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   12.363945]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   12.363949]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   12.363954]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   12.363958]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   12.363962]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   12.363967]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.363972]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   12.363976]  [<ffffffff8131da12>] ? kernfs_put_open_node.isra.3+0x72/0x90
[   12.363981]  [<ffffffff8131da12>] kernfs_put_open_node.isra.3+0x72/0x90
[   12.363985]  [<ffffffff8131da69>] kernfs_fop_release+0x39/0x60
[   12.363989]  [<ffffffff8129cb38>] __fput+0xb8/0x230
[   12.363993]  [<ffffffff8129ccfe>] ____fput+0xe/0x10
[   12.363999]  [<ffffffff8116117c>] task_work_run+0xac/0xe0
[   12.364003]  [<ffffffff81067ecc>] do_notify_resume+0x8c/0xa0
[   12.364008]  [<ffffffff81a735ea>] int_signal+0x12/0x17
[   12.364021] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-udevd/274
[   12.364024] caller is __this_cpu_preempt_check+0x2b/0x30
[   12.364026] CPU: 2 PID: 274 Comm: systemd-udevd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   12.364028] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   12.364035]  ffff8800c2c21d10 ffff8800c2c21ce0 ffffffff81a64cec 0000000000000002
[   12.364042]  ffff8800c2c21d00 ffffffff81462360 ffff8800c32133d8 ffffea00030c8400
[   12.364049]  ffff8800c2c21d38 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   12.364050] Call Trace:
[   12.364055]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   12.364059]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   12.364064]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   12.364068]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   12.364072]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   12.364077]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   12.364081]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   12.364085]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   12.364089]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   12.364094]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.364099]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   12.364104]  [<ffffffff812c20a9>] ? seq_release+0x19/0x30
[   12.364108]  [<ffffffff812c20a9>] seq_release+0x19/0x30
[   12.364113]  [<ffffffff8131da74>] kernfs_fop_release+0x44/0x60
[   12.364116]  [<ffffffff8129cb38>] __fput+0xb8/0x230
[   12.364120]  [<ffffffff8129ccfe>] ____fput+0xe/0x10
[   12.364125]  [<ffffffff8116117c>] task_work_run+0xac/0xe0
[   12.364129]  [<ffffffff81067ecc>] do_notify_resume+0x8c/0xa0
[   12.364133]  [<ffffffff81a735ea>] int_signal+0x12/0x17
[   12.364147] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-udevd/274
[   12.364150] caller is __this_cpu_preempt_check+0x2b/0x30
[   12.364153] CPU: 2 PID: 274 Comm: systemd-udevd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   12.364155] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   12.364162]  ffff8800c2c21d10 ffff8800c2c21ce0 ffffffff81a64cec 0000000000000002
[   12.364169]  ffff8800c2c21d00 ffffffff81462360 ffff8800c2c66c48 ffffea00030b1800
[   12.364175]  ffff8800c2c21d38 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   12.364177] Call Trace:
[   12.364181]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   12.364186]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   12.364190]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   12.364195]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   12.364199]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   12.364203]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   12.364208]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   12.364212]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   12.364217]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   12.364221]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.364226]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   12.364231]  [<ffffffff812c20b1>] ? seq_release+0x21/0x30
[   12.364236]  [<ffffffff812c20b1>] seq_release+0x21/0x30
[   12.364240]  [<ffffffff8131da74>] kernfs_fop_release+0x44/0x60
[   12.364244]  [<ffffffff8129cb38>] __fput+0xb8/0x230
[   12.364248]  [<ffffffff8129ccfe>] ____fput+0xe/0x10
[   12.364252]  [<ffffffff8116117c>] task_work_run+0xac/0xe0
[   12.364256]  [<ffffffff81067ecc>] do_notify_resume+0x8c/0xa0
[   12.364261]  [<ffffffff81a735ea>] int_signal+0x12/0x17
[   12.364272] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-udevd/274
[   12.364275] caller is __this_cpu_preempt_check+0x2b/0x30
[   12.364278] CPU: 2 PID: 274 Comm: systemd-udevd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   12.364280] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   12.364287]  ffff8800c2c21d30 ffff8800c2c21d00 ffffffff81a64cec 0000000000000002
[   12.364294]  ffff8800c2c21d20 ffffffff81462360 ffff8800c1c00000 ffffea0003070000
[   12.364301]  ffff8800c2c21d58 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   12.364303] Call Trace:
[   12.364307]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   12.364312]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   12.364317]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   12.364321]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   12.364326]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   12.364330]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   12.364334]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   12.364339]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   12.364344]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.364349]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   12.364353]  [<ffffffff8131da7c>] ? kernfs_fop_release+0x4c/0x60
[   12.364358]  [<ffffffff8131da7c>] kernfs_fop_release+0x4c/0x60
[   12.364362]  [<ffffffff8129cb38>] __fput+0xb8/0x230
[   12.364366]  [<ffffffff8129ccfe>] ____fput+0xe/0x10
[   12.364371]  [<ffffffff8116117c>] task_work_run+0xac/0xe0
[   12.364375]  [<ffffffff81067ecc>] do_notify_resume+0x8c/0xa0
[   12.364379]  [<ffffffff81a735ea>] int_signal+0x12/0x17
[   12.364428] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-udevd/274
[   12.364431] caller is __this_cpu_preempt_check+0x2b/0x30
[   12.364434] CPU: 2 PID: 274 Comm: systemd-udevd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   12.364438] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   12.364445]  ffff8800c2c21d70 ffff8800c2c21d40 ffffffff81a64cec 0000000000000002
[   12.364453]  ffff8800c2c21d60 ffffffff81462360 ffff880113805f80 ffffea00044e0100
[   12.364460]  ffff8800c2c21d98 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   12.364462] Call Trace:
[   12.364467]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   12.364472]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   12.364476]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   12.364480]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   12.364485]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   12.364489]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   12.364493]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   12.364498]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   12.364503]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.364510]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   12.364515]  [<ffffffff81268ca0>] ? remove_vma+0x60/0x70
[   12.364519]  [<ffffffff81268ca0>] remove_vma+0x60/0x70
[   12.364524]  [<ffffffff8126ad58>] do_munmap+0x278/0x390
[   12.364528]  [<ffffffff8126bd44>] vm_munmap+0x44/0x60
[   12.364532]  [<ffffffff8126bd82>] SyS_munmap+0x22/0x30
[   12.364537]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   12.364728] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-udevd/274
[   12.364731] caller is __this_cpu_preempt_check+0x2b/0x30
[   12.364734] CPU: 2 PID: 274 Comm: systemd-udevd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   12.364736] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   12.364743]  ffff8800c2c21da0 ffff8800c2c21d70 ffffffff81a64cec 0000000000000002
[   12.364750]  ffff8800c2c21d90 ffffffff81462360 ffff8800c2fc5780 ffffea00030bf000
[   12.364757]  ffff8800c2c21dc8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   12.364759] Call Trace:
[   12.364764]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   12.364768]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   12.364773]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   12.364777]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   12.364781]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   12.364786]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   12.364791]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   12.364796]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   12.364801]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   12.364806]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   12.364810]  [<ffffffff812a5ae2>] ? final_putname+0x22/0x50
[   12.364814]  [<ffffffff812a5ae2>] final_putname+0x22/0x50
[   12.364818]  [<ffffffff812a5d89>] putname+0x29/0x40
[   12.364822]  [<ffffffff8129a569>] do_sys_open+0x199/0x220
[   12.364826]  [<ffffffff8129a60e>] SyS_open+0x1e/0x20
[   12.364830]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   12.951414] systemd-udevd[263]: renamed network interface wlan0 to wlp1s0
[   13.385569] FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   13.593194] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: data=ordered
[   13.692558] systemd-journald[226]: Received request to flush runtime journal from PID 1
[   15.073008] r8169 0000:02:00.0 enp2s0: link down
[   15.077013] IPv6: ADDRCONF(NETDEV_UP): enp2s0: link is not ready
[   16.248327] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   16.258339] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
[   16.550719] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   16.562787] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
[   16.704571] IPv6: ADDRCONF(NETDEV_UP): wlp1s0: link is not ready
[   18.021402] check_preemption_disabled: 48720 callbacks suppressed
[   18.026772] BUG: using __this_cpu_add() in preemptible [00000000] code: ntpd/364
[   18.026945] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   18.026959] caller is __this_cpu_preempt_check+0x2b/0x30
[   18.026966] CPU: 0 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   18.026969] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   18.026982]  ffff8800c33f99d0 ffff8800c33f99a0 ffffffff81a64cec 0000000000000000
[   18.026992]  ffff8800c33f99c0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   18.027002]  ffff8800c33f99f8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   18.027004] Call Trace:
[   18.027017]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   18.027026]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   18.027034]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   18.027042]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   18.027052]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.027059]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   18.027066]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   18.027075]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   18.027082]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   18.027092]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   18.027103]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   18.027110]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   18.027120]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   18.027129]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   18.027137]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   18.027148]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   18.027154]  [<ffffffff812b6d7e>] update_time+0x7e/0xd0
[   18.027161]  [<ffffffff812b9280>] file_update_time+0x80/0xc0
[   18.027169]  [<ffffffff8133b8f5>] ext4_page_mkwrite+0x55/0x430
[   18.027180]  [<ffffffff812600cf>] do_page_mkwrite+0x3f/0xc0
[   18.027188]  [<ffffffff81261de9>] do_wp_page+0x6f9/0x8d0
[   18.027194]  [<ffffffff81265903>] handle_mm_fault+0x5c3/0xc70
[   18.027203]  [<ffffffff81198307>] ? __lock_is_held+0x57/0x80
[   18.027212]  [<ffffffff810ac647>] __do_page_fault+0x167/0x510
[   18.027221]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[   18.027228]  [<ffffffff81a72c76>] ? error_sti+0x5/0x6
[   18.027236]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   18.027243]  [<ffffffff811976a9>] ? trace_hardirqs_off_caller+0x99/0x160
[   18.027251]  [<ffffffff81457eda>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   18.027257]  [<ffffffff810aca2e>] do_page_fault+0xe/0x10
[   18.027264]  [<ffffffff81a72a28>] page_fault+0x28/0x30
[   18.027842] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   18.027849] caller is __this_cpu_preempt_check+0x2b/0x30
[   18.027854] CPU: 0 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   18.027857] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   18.027867]  ffff8800c33f9b80 ffff8800c33f9b50 ffffffff81a64cec 0000000000000000
[   18.027877]  ffff8800c33f9b70 ffffffff81462360 ffff8800c3267d48 ffffea00030c9900
[   18.027888]  ffff8800c33f9ba8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   18.027890] Call Trace:
[   18.027898]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   18.027906]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   18.027913]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   18.027920]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   18.027928]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.027935]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   18.027941]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   18.027949]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   18.027957]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   18.027966]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   18.027974]  [<ffffffff81362a2f>] ? ext4_ext_remove_space+0x39f/0x13c0
[   18.027981]  [<ffffffff81362a2f>] ext4_ext_remove_space+0x39f/0x13c0
[   18.027989]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[   18.027996]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.028003]  [<ffffffff813656f0>] ext4_ext_truncate+0xc0/0xf0
[   18.028011]  [<ffffffff81339328>] ext4_truncate+0x3f8/0x570
[   18.028019]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   18.028026]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   18.028033]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   18.028042]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   18.028051]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   18.028059]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   18.028067]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   18.028075]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   18.028124] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   18.028130] caller is __this_cpu_preempt_check+0x2b/0x30
[   18.028134] CPU: 0 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   18.028136] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   18.028146]  ffff8800c33f9bb0 ffff8800c33f9b80 ffffffff81a64cec 0000000000000000
[   18.028156]  ffff8800c33f9ba0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   18.028166]  ffff8800c33f9bd8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   18.028168] Call Trace:
[   18.028175]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   18.028182]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   18.028190]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   18.028197]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   18.028204]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   18.028211]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.028217]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   18.028223]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   18.028231]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   18.028239]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   18.028247]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   18.028254]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   18.028261]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   18.028268]  [<ffffffff813390c7>] ? ext4_truncate+0x197/0x570
[   18.028276]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   18.028283]  [<ffffffff813390db>] ext4_truncate+0x1ab/0x570
[   18.028291]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   18.028297]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   18.028303]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   18.028311]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   18.028319]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   18.028327]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   18.028334]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   18.028342]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   18.028394] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   18.028400] caller is __this_cpu_preempt_check+0x2b/0x30
[   18.028403] CPU: 0 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   18.028406] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   18.028416]  ffff8800c33f9b90 ffff8800c33f9b60 ffffffff81a64cec 0000000000000000
[   18.028425]  ffff8800c33f9b80 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   18.028435]  ffff8800c33f9bb8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   18.028437] Call Trace:
[   18.028444]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   18.028452]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   18.028459]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   18.028467]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   18.028473]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   18.028480]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.028487]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   18.028493]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   18.028500]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   18.028508]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   18.028516]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   18.028523]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   18.028529]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   18.028537]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   18.028545]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   18.028552]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   18.028560]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   18.028567]  [<ffffffff8133b19b>] ext4_setattr+0x2eb/0x810
[   18.028574]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   18.028580]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   18.028588]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   18.028596]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   18.028603]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   18.028611]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   18.028618]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   18.028894] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   18.028901] caller is __this_cpu_preempt_check+0x2b/0x30
[   18.028905] CPU: 0 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   18.028908] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   18.028918]  ffff8800c33f9bd0 ffff8800c33f9ba0 ffffffff81a64cec 0000000000000000
[   18.028929]  ffff8800c33f9bc0 ffffffff81462360 ffff8800bf9278e0 ffffea0002fe4900
[   18.028939]  ffff8800c33f9bf8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   18.028941] Call Trace:
[   18.028949]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   18.028956]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   18.028964]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   18.028971]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   18.028978]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.028985]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   18.028991]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   18.028999]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   18.029007]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   18.029015]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   18.029023]  [<ffffffff81363e64>] ? ext4_ext_map_blocks+0x184/0x1950
[   18.029030]  [<ffffffff81363e64>] ext4_ext_map_blocks+0x184/0x1950
[   18.029037]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.029045]  [<ffffffff81334b2c>] ? ext4_map_blocks+0x2dc/0x530
[   18.029053]  [<ffffffff81334a55>] ext4_map_blocks+0x205/0x530
[   18.029060]  [<ffffffff813658cc>] ? ext4_fallocate+0x1ac/0x7c0
[   18.029067]  [<ffffffff813658ef>] ext4_fallocate+0x1cf/0x7c0
[   18.029076]  [<ffffffff812995c6>] do_fallocate+0xf6/0x1b0
[   18.029084]  [<ffffffff812996cc>] SyS_fallocate+0x4c/0x80
[   18.029091]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   18.029244] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   18.029250] caller is __this_cpu_preempt_check+0x2b/0x30
[   18.029254] CPU: 0 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   18.029256] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   18.029267]  ffff8800c33f9b60 ffff8800c33f9b30 ffffffff81a64cec 0000000000000000
[   18.029277]  ffff8800c33f9b50 ffffffff81462360 ffff8800c2284000 ffffea000308a100
[   18.029287]  ffff8800c33f9b88 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   18.029289] Call Trace:
[   18.029296]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   18.029304]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   18.029312]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   18.029319]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   18.029326]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   18.029333]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.029340]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   18.029346]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   18.029354]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   18.029362]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   18.029370]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   18.029379]  [<ffffffff81370012>] ? ext4_mb_new_blocks+0x192/0x860
[   18.029387]  [<ffffffff81370012>] ext4_mb_new_blocks+0x192/0x860
[   18.029394]  [<ffffffff8135fc3c>] ? ext4_ext_find_extent+0x12c/0x2d0
[   18.029401]  [<ffffffff813642b1>] ext4_ext_map_blocks+0x5d1/0x1950
[   18.029408]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.029416]  [<ffffffff81334b3d>] ext4_map_blocks+0x2ed/0x530
[   18.029423]  [<ffffffff813658cc>] ? ext4_fallocate+0x1ac/0x7c0
[   18.029430]  [<ffffffff813658ef>] ext4_fallocate+0x1cf/0x7c0
[   18.029439]  [<ffffffff812995c6>] do_fallocate+0xf6/0x1b0
[   18.029447]  [<ffffffff812996cc>] SyS_fallocate+0x4c/0x80
[   18.029454]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   18.029483] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   18.029489] caller is __this_cpu_preempt_check+0x2b/0x30
[   18.029493] CPU: 0 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   18.029495] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   18.029506]  ffff8800c33f9bd0 ffff8800c33f9ba0 ffffffff81a64cec 0000000000000000
[   18.029516]  ffff8800c33f9bc0 ffffffff81462360 ffff8800bf9278e0 ffffea0002fe4900
[   18.029526]  ffff8800c33f9bf8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   18.029528] Call Trace:
[   18.029535]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   18.029543]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   18.029550]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   18.029557]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   18.029564]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.029571]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   18.029577]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   18.029585]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   18.029592]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   18.029600]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   18.029608]  [<ffffffff81363e64>] ? ext4_ext_map_blocks+0x184/0x1950
[   18.029615]  [<ffffffff81363e64>] ext4_ext_map_blocks+0x184/0x1950
[   18.029621]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.029629]  [<ffffffff81334b3d>] ext4_map_blocks+0x2ed/0x530
[   18.029636]  [<ffffffff813658cc>] ? ext4_fallocate+0x1ac/0x7c0
[   18.029643]  [<ffffffff813658ef>] ext4_fallocate+0x1cf/0x7c0
[   18.029652]  [<ffffffff812995c6>] do_fallocate+0xf6/0x1b0
[   18.029660]  [<ffffffff812996cc>] SyS_fallocate+0x4c/0x80
[   18.029667]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   18.029708] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   18.029714] caller is __this_cpu_preempt_check+0x2b/0x30
[   18.029717] CPU: 0 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   18.029720] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   18.029730]  ffff8800c33f9c40 ffff8800c33f9c10 ffffffff81a64cec 0000000000000000
[   18.029739]  ffff8800c33f9c30 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   18.029749]  ffff8800c33f9c68 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   18.029751] Call Trace:
[   18.029758]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   18.029765]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   18.029773]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   18.029780]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   18.029787]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   18.029793]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.029947]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   18.029953]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   18.029961]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   18.029969]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   18.029977]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   18.029984]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   18.029991]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   18.029998]  [<ffffffff81365987>] ? ext4_fallocate+0x267/0x7c0
[   18.030005]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   18.030012]  [<ffffffff813659b5>] ext4_fallocate+0x295/0x7c0
[   18.030020]  [<ffffffff812995c6>] do_fallocate+0xf6/0x1b0
[   18.030028]  [<ffffffff812996cc>] SyS_fallocate+0x4c/0x80
[   18.030035]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   18.030165] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   18.030171] caller is __this_cpu_preempt_check+0x2b/0x30
[   18.030174] CPU: 0 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   18.030177] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   18.030187]  ffff8800c33f9af0 ffff8800c33f9ac0 ffffffff81a64cec 0000000000000000
[   18.030197]  ffff8800c33f9ae0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   18.030206]  ffff8800c33f9b18 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   18.030208] Call Trace:
[   18.030216]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   18.030223]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   18.030230]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   18.030237]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   18.030244]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   18.030251]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   18.030257]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   18.030265]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   18.030272]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   18.030280]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   18.030287]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   18.030294]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   18.030302]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   18.030309]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   18.030317]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   18.030325]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   18.030330]  [<ffffffff812b6d7e>] update_time+0x7e/0xd0
[   18.030336]  [<ffffffff812b90a9>] touch_atime+0xf9/0x140
[   18.030344]  [<ffffffff8132d85d>] ext4_file_mmap+0x4d/0x70
[   18.030351]  [<ffffffff8126b703>] mmap_region+0x3b3/0x5b0
[   18.030357]  [<ffffffff8126bc56>] do_mmap_pgoff+0x356/0x400
[   18.030364]  [<ffffffff81257a4a>] vm_mmap_pgoff+0x6a/0xa0
[   18.030370]  [<ffffffff8126a09e>] SyS_mmap_pgoff+0xbe/0x250
[   18.030379]  [<ffffffff8106e262>] SyS_mmap+0x22/0x30
[   18.030386]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   19.305893] caller is __this_cpu_preempt_check+0x2b/0x30
[   19.310592] CPU: 2 PID: 364 Comm: ntpd Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   19.315772] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   19.320921]  ffff8800c115db10 ffff8800c115dae0 ffffffff81a64cec 0000000000000002
[   19.325766]  ffff8800c115db00 ffffffff81462360 ffff8800bf80f6d8 ffffea0002fe0380
[   19.330265]  ffff8800c115db38 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   19.334049] Call Trace:
[   19.337230]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   19.340859]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   19.344550]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   19.348295]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   19.351565]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   19.354292]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   19.357144]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   19.360087]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   19.363104]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   19.365904]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   19.368707]  [<ffffffff812c613f>] ? kfree_put_link+0x1f/0x30
[   19.371191]  [<ffffffff812c613f>] kfree_put_link+0x1f/0x30
[   19.373492]  [<ffffffff812a772f>] link_path_walk+0x47f/0x8b0
[   19.376053]  [<ffffffff812a7677>] link_path_walk+0x3c7/0x8b0
[   19.378397]  [<ffffffff812aa20f>] path_openat+0x9f/0x6e0
[   19.381039]  [<ffffffff812a5b5f>] ? getname_flags+0x4f/0x1a0
[   19.383738]  [<ffffffff811952fe>] ? put_lock_stats.isra.20+0xe/0x30
[   19.386132]  [<ffffffff810ac6d4>] ? __do_page_fault+0x1f4/0x510
[   19.388499]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[   19.390817]  [<ffffffff812aa88a>] do_filp_open+0x3a/0x90
[   19.393099]  [<ffffffff81a716f1>] ? _raw_spin_unlock+0x31/0x50
[   19.395508]  [<ffffffff812bb12f>] ? __alloc_fd+0xaf/0x1c0
[   19.397714]  [<ffffffff8129a4f4>] do_sys_open+0x124/0x220
[   19.400011]  [<ffffffff8129a60e>] SyS_open+0x1e/0x20
[   19.402339]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   20.173049] wlp1s0: authenticate with c0:c1:c0:37:f4:ad
[   20.185252] wlp1s0: send auth to c0:c1:c0:37:f4:ad (try 1/3)
[   20.189048] wlp1s0: authenticated
[   20.192752] wlp1s0: associate with c0:c1:c0:37:f4:ad (try 1/3)
[   20.197583] wlp1s0: RX AssocResp from c0:c1:c0:37:f4:ad (capab=0x411 status=0 aid=3)
[   20.226651] IPv6: ADDRCONF(NETDEV_CHANGE): wlp1s0: link becomes ready
[   20.230294] wlp1s0: associated
[   23.106196] check_preemption_disabled: 13294 callbacks suppressed
[   23.107093] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u16:5/195
[   23.108192] caller is __this_cpu_preempt_check+0x2b/0x30
[   23.108912] CPU: 2 PID: 195 Comm: kworker/u16:5 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   23.110514] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   23.110852] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   23.110871] caller is __this_cpu_preempt_check+0x2b/0x30
[   23.114195] Workqueue: phy0 ieee80211_iface_work
[   23.114874]  ffff8800c42c9b60 ffff8800c42c9b30 ffffffff81a64cec 0000000000000002
[   23.116227]  ffff8800c42c9b50 ffffffff81462360 ffff8800c30159c8 ffffea00030c0400
[   23.117346]  ffff8800c42c9b88 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   23.118455] Call Trace:
[   23.118846]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   23.119743]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   23.120627]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   23.121498]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   23.122235]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   23.123129]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   23.123933]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.124849]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   23.125899]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.126783]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   23.127452]  [<ffffffff81818f6e>] ? skb_release_data+0x11e/0x130
[   23.128265]  [<ffffffff81818f6e>] skb_release_data+0x11e/0x130
[   23.129197]  [<ffffffff819fa1a0>] ? ieee80211_iface_work+0xd0/0x360
[   23.130034]  [<ffffffff81818fa4>] skb_release_all+0x24/0x30
[   23.130814]  [<ffffffff81818d36>] kfree_skb+0x36/0x150
[   23.131504]  [<ffffffff819fa1a0>] ieee80211_iface_work+0xd0/0x360
[   23.132424]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[   23.133197]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[   23.133992]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[   23.134732]  [<ffffffff8118cc22>] ? complete+0x42/0x50
[   23.135414]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.136398]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[   23.137193]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[   23.137854]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   23.138659]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[   23.139480]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   23.140288] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   23.140316] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u16:5/195
[   23.140321] caller is __this_cpu_preempt_check+0x2b/0x30
[   23.143480] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   23.144998]  ffff8800c33f99d0 ffff8800c33f99a0 ffffffff81a64cec 0000000000000003
[   23.146143]  ffff8800c33f99c0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   23.147213]  ffff8800c33f99f8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   23.148247] Call Trace:
[   23.148584]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   23.149348]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   23.150187]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   23.151015]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   23.151737]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   23.152544]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   23.153310]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.154218]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   23.155135]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.156057]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   23.159717]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   23.163254]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   23.166772]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   23.170208]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   23.173535]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   23.177002]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   23.180152]  [<ffffffff812b6d7e>] update_time+0x7e/0xd0
[   23.183228]  [<ffffffff812b9280>] file_update_time+0x80/0xc0
[   23.186216]  [<ffffffff8133b8f5>] ext4_page_mkwrite+0x55/0x430
[   23.189217]  [<ffffffff812600cf>] do_page_mkwrite+0x3f/0xc0
[   23.192121]  [<ffffffff81261de9>] do_wp_page+0x6f9/0x8d0
[   23.195046]  [<ffffffff81265903>] handle_mm_fault+0x5c3/0xc70
[   23.197893]  [<ffffffff81198307>] ? __lock_is_held+0x57/0x80
[   23.200708]  [<ffffffff810ac647>] __do_page_fault+0x167/0x510
[   23.203800]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[   23.206473]  [<ffffffff81a72c76>] ? error_sti+0x5/0x6
[   23.209323]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.212032]  [<ffffffff811976a9>] ? trace_hardirqs_off_caller+0x99/0x160
[   23.214819]  [<ffffffff81457eda>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   23.217565]  [<ffffffff810aca2e>] do_page_fault+0xe/0x10
[   23.220158]  [<ffffffff81a72a28>] page_fault+0x28/0x30
[   23.222733] CPU: 2 PID: 195 Comm: kworker/u16:5 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   23.222837] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   23.222841] caller is __this_cpu_preempt_check+0x2b/0x30
[   23.232088] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   23.235520] Workqueue: phy0 ieee80211_iface_work
[   23.238114]  ffff8800c42c9b90 ffff8800c42c9b60 ffffffff81a64cec 0000000000000002
[   23.241151]  ffff8800c42c9b80 ffffffff81462360 ffff8800c2d38fc0 ffffea00030b4e00
[   23.244188]  ffff8800c42c9bb8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   23.247207] Call Trace:
[   23.249577]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   23.252986]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   23.255828]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   23.258591]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   23.262248]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   23.264979]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   23.267802]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.271616]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   23.274533]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.277412]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   23.280207]  [<ffffffff81817787>] ? kfree_skbmem+0x37/0xa0
[   23.282958]  [<ffffffff819fa1a0>] ? ieee80211_iface_work+0xd0/0x360
[   23.285734]  [<ffffffff81817787>] kfree_skbmem+0x37/0xa0
[   23.288495]  [<ffffffff81818d3e>] kfree_skb+0x3e/0x150
[   23.291200]  [<ffffffff819fa1a0>] ieee80211_iface_work+0xd0/0x360
[   23.294027]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[   23.297183]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[   23.300029]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[   23.302778]  [<ffffffff8118cc22>] ? complete+0x42/0x50
[   23.305355]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.308184]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[   23.310947]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[   23.313535]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   23.316225]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[   23.318716]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   23.322220] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   23.322256] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u16:5/195
[   23.322259] caller is __this_cpu_preempt_check+0x2b/0x30
[   23.331779] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   23.335273]  ffff8800c33f99d0 ffff8800c33f99a0 ffffffff81a64cec 0000000000000003
[   23.338353]  ffff8800c33f99c0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   23.341442]  ffff8800c33f99f8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   23.344563] Call Trace:
[   23.346990]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   23.349758]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   23.352670]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   23.355500]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   23.358270]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   23.361071]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   23.363920]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.366876]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   23.369871]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.372800]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   23.375693]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   23.378578]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   23.381453]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   23.384308]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   23.387172]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   23.390004]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   23.392856]  [<ffffffff812b6d7e>] update_time+0x7e/0xd0
[   23.395568]  [<ffffffff812b9280>] file_update_time+0x80/0xc0
[   23.398402]  [<ffffffff8133b8f5>] ext4_page_mkwrite+0x55/0x430
[   23.401264]  [<ffffffff812600cf>] do_page_mkwrite+0x3f/0xc0
[   23.404660]  [<ffffffff81261de9>] do_wp_page+0x6f9/0x8d0
[   23.408018]  [<ffffffff81265903>] handle_mm_fault+0x5c3/0xc70
[   23.410863]  [<ffffffff81198307>] ? __lock_is_held+0x57/0x80
[   23.413686]  [<ffffffff810ac647>] __do_page_fault+0x167/0x510
[   23.416521]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[   23.419186]  [<ffffffff81a72c76>] ? error_sti+0x5/0x6
[   23.421869]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.424721]  [<ffffffff811976a9>] ? trace_hardirqs_off_caller+0x99/0x160
[   23.427550]  [<ffffffff81457eda>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   23.430314]  [<ffffffff810aca2e>] do_page_fault+0xe/0x10
[   23.433429]  [<ffffffff81a72a28>] page_fault+0x28/0x30
[   23.435928] CPU: 2 PID: 195 Comm: kworker/u16:5 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   23.436140] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   23.436144] caller is __this_cpu_preempt_check+0x2b/0x30
[   23.444324] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   23.447663] Workqueue: phy0 ieee80211_iface_work
[   23.450499]  ffff8800c42c9b60 ffff8800c42c9b30 ffffffff81a64cec 0000000000000002
[   23.454170]  ffff8800c42c9b50 ffffffff81462360 ffff8800c30159c8 ffffea00030c0400
[   23.457084]  ffff8800c42c9b88 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   23.460407] Call Trace:
[   23.462625]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   23.465222]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   23.467989]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   23.470740]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   23.473365]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   23.475949]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   23.478637]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.481446]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   23.484274]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.487057]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   23.489644]  [<ffffffff81818f6e>] ? skb_release_data+0x11e/0x130
[   23.492312]  [<ffffffff81818f6e>] skb_release_data+0x11e/0x130
[   23.495011]  [<ffffffff819fa1a0>] ? ieee80211_iface_work+0xd0/0x360
[   23.497762]  [<ffffffff81818fa4>] skb_release_all+0x24/0x30
[   23.500805]  [<ffffffff81818d36>] kfree_skb+0x36/0x150
[   23.503427]  [<ffffffff819fa1a0>] ieee80211_iface_work+0xd0/0x360
[   23.506146]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[   23.508786]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[   23.511495]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[   23.514133]  [<ffffffff8118cc22>] ? complete+0x42/0x50
[   23.516714]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.520009]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[   23.522559]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[   23.525708]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   23.528307]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[   23.530797]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   23.533360] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   23.533481] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u16:5/195
[   23.533487] caller is __this_cpu_preempt_check+0x2b/0x30
[   23.540914] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   23.544018]  ffff8800c33f99e0 ffff8800c33f99b0 ffffffff81a64cec 0000000000000003
[   23.546661]  ffff8800c33f99d0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   23.549248]  ffff8800c33f9a08 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   23.551922] Call Trace:
[   23.553930]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   23.556255]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   23.558682]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   23.561160]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   23.563514]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   23.565831]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   23.568251]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.570788]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   23.573333]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.575781]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   23.578191]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   23.580649]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   23.583081]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   23.585448]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   23.587884]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   23.590293]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   23.592671]  [<ffffffff812b6d7e>] update_time+0x7e/0xd0
[   23.595022]  [<ffffffff812b9280>] file_update_time+0x80/0xc0
[   23.597431]  [<ffffffff8133b8f5>] ext4_page_mkwrite+0x55/0x430
[   23.599862]  [<ffffffff812600cf>] do_page_mkwrite+0x3f/0xc0
[   23.602200]  [<ffffffff81262e66>] do_shared_fault+0x76/0x220
[   23.604605]  [<ffffffff811b5584>] ? __rcu_read_unlock+0x54/0xa0
[   23.607042]  [<ffffffff8126556c>] handle_mm_fault+0x22c/0xc70
[   23.609401]  [<ffffffff81198307>] ? __lock_is_held+0x57/0x80
[   23.611785]  [<ffffffff810ac647>] __do_page_fault+0x167/0x510
[   23.614149]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[   23.616424]  [<ffffffff81a72c76>] ? error_sti+0x5/0x6
[   23.618650]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.621031]  [<ffffffff811976a9>] ? trace_hardirqs_off_caller+0x99/0x160
[   23.623417]  [<ffffffff81457eda>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   23.625712]  [<ffffffff810aca2e>] do_page_fault+0xe/0x10
[   23.627920]  [<ffffffff81a72a28>] page_fault+0x28/0x30
[   23.630149] CPU: 0 PID: 195 Comm: kworker/u16:5 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   23.630257] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   23.630260] caller is __this_cpu_preempt_check+0x2b/0x30
[   23.637714] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   23.640793] Workqueue: phy0 ieee80211_iface_work
[   23.643149]  ffff8800c42c9b90 ffff8800c42c9b60 ffffffff81a64cec 0000000000000000
[   23.645742]  ffff8800c42c9b80 ffffffff81462360 ffff8800c2d398c0 ffffea00030b4e00
[   23.648398]  ffff8800c42c9bb8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   23.651127] Call Trace:
[   23.653139]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   23.655411]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   23.657946]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   23.660434]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   23.662735]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   23.665126]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   23.667559]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.670092]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   23.672584]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.675092]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   23.677520]  [<ffffffff81817787>] ? kfree_skbmem+0x37/0xa0
[   23.679910]  [<ffffffff819fa1a0>] ? ieee80211_iface_work+0xd0/0x360
[   23.682333]  [<ffffffff81817787>] kfree_skbmem+0x37/0xa0
[   23.684692]  [<ffffffff81818d3e>] kfree_skb+0x3e/0x150
[   23.687035]  [<ffffffff819fa1a0>] ieee80211_iface_work+0xd0/0x360
[   23.689423]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[   23.691838]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[   23.694272]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[   23.696634]  [<ffffffff8118cc22>] ? complete+0x42/0x50
[   23.698852]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.701323]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[   23.703668]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[   23.705795]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   23.708115]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[   23.710347]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   23.712591] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   23.712622] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u16:5/195
[   23.712625] caller is __this_cpu_preempt_check+0x2b/0x30
[   23.720129] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   23.723201]  ffff8800c33f99e0 ffff8800c33f99b0 ffffffff81a64cec 0000000000000003
[   23.725775]  ffff8800c33f99d0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   23.728414]  ffff8800c33f9a08 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   23.731059] Call Trace:
[   23.733061]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   23.735330]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   23.737816]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   23.740298]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   23.742591]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   23.744960]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   23.747378]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.749910]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   23.752401]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.754901]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   23.757318]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   23.759788]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   23.762165]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   23.764591]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   23.767026]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   23.769368]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   23.771803]  [<ffffffff812b6d7e>] update_time+0x7e/0xd0
[   23.774155]  [<ffffffff812b9280>] file_update_time+0x80/0xc0
[   23.776559]  [<ffffffff8133b8f5>] ext4_page_mkwrite+0x55/0x430
[   23.778932]  [<ffffffff812600cf>] do_page_mkwrite+0x3f/0xc0
[   23.781335]  [<ffffffff81262e66>] do_shared_fault+0x76/0x220
[   23.783737]  [<ffffffff811b5584>] ? __rcu_read_unlock+0x54/0xa0
[   23.786121]  [<ffffffff8126556c>] handle_mm_fault+0x22c/0xc70
[   23.788537]  [<ffffffff81198307>] ? __lock_is_held+0x57/0x80
[   23.790945]  [<ffffffff810ac647>] __do_page_fault+0x167/0x510
[   23.793328]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[   23.795565]  [<ffffffff81a72c76>] ? error_sti+0x5/0x6
[   23.797821]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.800231]  [<ffffffff811976a9>] ? trace_hardirqs_off_caller+0x99/0x160
[   23.802568]  [<ffffffff81457eda>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   23.804923]  [<ffffffff810aca2e>] do_page_fault+0xe/0x10
[   23.807131]  [<ffffffff81a72a28>] page_fault+0x28/0x30
[   23.809251] CPU: 0 PID: 195 Comm: kworker/u16:5 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   23.809345] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   23.809347] caller is __this_cpu_preempt_check+0x2b/0x30
[   23.816761] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   23.819826] Workqueue: phy0 ieee80211_iface_work
[   23.822014]  ffff8800c42c9b60 ffff8800c42c9b30 ffffffff81a64cec 0000000000000000
[   23.824778]  ffff8800c42c9b50 ffffffff81462360 ffff8800c30149f0 ffffea00030c0400
[   23.827481]  ffff8800c42c9b88 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   23.830196] Call Trace:
[   23.832135]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   23.834471]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   23.837072]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   23.839489]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   23.841848]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   23.844287]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   23.846725]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.849205]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   23.851750]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.854260]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   23.856616]  [<ffffffff81818f6e>] ? skb_release_data+0x11e/0x130
[   23.859009]  [<ffffffff81818f6e>] skb_release_data+0x11e/0x130
[   23.861433]  [<ffffffff819fa1a0>] ? ieee80211_iface_work+0xd0/0x360
[   23.863904]  [<ffffffff81818fa4>] skb_release_all+0x24/0x30
[   23.866231]  [<ffffffff81818d36>] kfree_skb+0x36/0x150
[   23.868563]  [<ffffffff819fa1a0>] ieee80211_iface_work+0xd0/0x360
[   23.871013]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[   23.873429]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[   23.875779]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[   23.878113]  [<ffffffff8118cc22>] ? complete+0x42/0x50
[   23.880379]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.882752]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[   23.885060]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[   23.887246]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   23.889506]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[   23.891719]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   23.894011] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   23.896813] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   23.899792]  ffff8800c33f99d0 ffff8800c33f99a0 ffffffff81a64cec 0000000000000003
[   23.902387]  ffff8800c33f99c0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   23.904983]  ffff8800c33f99f8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   23.907592] Call Trace:
[   23.909495]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   23.911789]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   23.914238]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   23.916677]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   23.918933]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   23.921266]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   23.923648]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   23.926223]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   23.928740]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.931210]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   23.933586]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   23.935999]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   23.938417]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   23.940832]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   23.943170]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   23.945534]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   23.947931]  [<ffffffff812b6d7e>] update_time+0x7e/0xd0
[   23.950311]  [<ffffffff812b9280>] file_update_time+0x80/0xc0
[   23.952620]  [<ffffffff8133b8f5>] ext4_page_mkwrite+0x55/0x430
[   23.955010]  [<ffffffff812600cf>] do_page_mkwrite+0x3f/0xc0
[   23.957371]  [<ffffffff81261de9>] do_wp_page+0x6f9/0x8d0
[   23.959632]  [<ffffffff81265903>] handle_mm_fault+0x5c3/0xc70
[   23.961999]  [<ffffffff81198307>] ? __lock_is_held+0x57/0x80
[   23.964364]  [<ffffffff810ac647>] __do_page_fault+0x167/0x510
[   23.966733]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[   23.968972]  [<ffffffff81a72c76>] ? error_sti+0x5/0x6
[   23.971233]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   23.973650]  [<ffffffff811976a9>] ? trace_hardirqs_off_caller+0x99/0x160
[   23.976015]  [<ffffffff81457eda>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   23.978383]  [<ffffffff810aca2e>] do_page_fault+0xe/0x10
[   23.980566]  [<ffffffff81a72a28>] page_fault+0x28/0x30
[   28.129300] check_preemption_disabled: 9625 callbacks suppressed
[   28.133924] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u16:5/195
[   28.134271] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   28.134287] caller is __this_cpu_preempt_check+0x2b/0x30
[   28.134294] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   28.134297] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   28.134310]  ffff8800c33f99d0 ffff8800c33f99a0 ffffffff81a64cec 0000000000000003
[   28.134320]  ffff8800c33f99c0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   28.134330]  ffff8800c33f99f8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   28.134332] Call Trace:
[   28.134347]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   28.134356]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   28.134364]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   28.134372]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   28.134381]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.134388]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   28.134396]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   28.134405]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   28.134412]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   28.134423]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   28.134434]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   28.134441]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   28.134451]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   28.134460]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   28.134468]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   28.134480]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   28.134486]  [<ffffffff812b6d7e>] update_time+0x7e/0xd0
[   28.134493]  [<ffffffff812b9280>] file_update_time+0x80/0xc0
[   28.134501]  [<ffffffff8133b8f5>] ext4_page_mkwrite+0x55/0x430
[   28.134512]  [<ffffffff812600cf>] do_page_mkwrite+0x3f/0xc0
[   28.134520]  [<ffffffff81261de9>] do_wp_page+0x6f9/0x8d0
[   28.134526]  [<ffffffff81265903>] handle_mm_fault+0x5c3/0xc70
[   28.134535]  [<ffffffff81198307>] ? __lock_is_held+0x57/0x80
[   28.134544]  [<ffffffff810ac647>] __do_page_fault+0x167/0x510
[   28.134553]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[   28.134562]  [<ffffffff81a72c76>] ? error_sti+0x5/0x6
[   28.134570]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   28.134577]  [<ffffffff811976a9>] ? trace_hardirqs_off_caller+0x99/0x160
[   28.134584]  [<ffffffff81457eda>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   28.134591]  [<ffffffff810aca2e>] do_page_fault+0xe/0x10
[   28.134598]  [<ffffffff81a72a28>] page_fault+0x28/0x30
[   28.135072] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   28.135083] caller is __this_cpu_preempt_check+0x2b/0x30
[   28.135089] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   28.135092] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   28.135104]  ffff8800c33f9b80 ffff8800c33f9b50 ffffffff81a64cec 0000000000000003
[   28.135114]  ffff8800c33f9b70 ffffffff81462360 ffff8800c3386470 ffffea00030ce100
[   28.135125]  ffff8800c33f9ba8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   28.135127] Call Trace:
[   28.135139]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   28.135148]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   28.135156]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   28.135164]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   28.135172]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.135180]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   28.135187]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   28.135195]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   28.135204]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   28.135213]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   28.135223]  [<ffffffff81362a2f>] ? ext4_ext_remove_space+0x39f/0x13c0
[   28.135231]  [<ffffffff81362a2f>] ext4_ext_remove_space+0x39f/0x13c0
[   28.135238]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[   28.135246]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.135254]  [<ffffffff813656f0>] ext4_ext_truncate+0xc0/0xf0
[   28.135264]  [<ffffffff81339328>] ext4_truncate+0x3f8/0x570
[   28.135274]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   28.135282]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   28.135289]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   28.135298]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   28.135307]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   28.135317]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   28.135325]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   28.135334]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   28.135390] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   28.135397] caller is __this_cpu_preempt_check+0x2b/0x30
[   28.135401] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   28.135405] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   28.135416]  ffff8800c33f9bb0 ffff8800c33f9b80 ffffffff81a64cec 0000000000000003
[   28.135427]  ffff8800c33f9ba0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   28.135437]  ffff8800c33f9bd8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   28.135439] Call Trace:
[   28.135449]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   28.135457]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   28.135465]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   28.135473]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   28.135479]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   28.135487]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.135494]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   28.135501]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   28.135510]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   28.135518]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   28.135527]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   28.135535]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   28.135542]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   28.135551]  [<ffffffff813390c7>] ? ext4_truncate+0x197/0x570
[   28.135560]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   28.135568]  [<ffffffff813390db>] ext4_truncate+0x1ab/0x570
[   28.135577]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   28.135584]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   28.135590]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   28.135598]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   28.135606]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   28.135614]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   28.135623]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   28.135631]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   28.135698] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   28.135704] caller is __this_cpu_preempt_check+0x2b/0x30
[   28.135709] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   28.135712] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   28.135723]  ffff8800c33f9b90 ffff8800c33f9b60 ffffffff81a64cec 0000000000000003
[   28.135734]  ffff8800c33f9b80 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   28.135744]  ffff8800c33f9bb8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   28.135746] Call Trace:
[   28.135756]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   28.135765]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   28.135773]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   28.135781]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   28.135788]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   28.135796]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.135803]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   28.135810]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   28.135818]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   28.135825]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   28.135835]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   28.135841]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   28.135848]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   28.135856]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   28.135865]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   28.135874]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   28.135883]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   28.135891]  [<ffffffff8133b19b>] ext4_setattr+0x2eb/0x810
[   28.135898]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   28.135904]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   28.135912]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   28.135921]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   28.135930]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   28.135939]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   28.135946]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   28.136489] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   28.136496] caller is __this_cpu_preempt_check+0x2b/0x30
[   28.136500] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   28.136503] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   28.136514]  ffff8800c33f9b80 ffff8800c33f9b50 ffffffff81a64cec 0000000000000003
[   28.136524]  ffff8800c33f9b70 ffffffff81462360 ffff8800c3386470 ffffea00030ce100
[   28.136535]  ffff8800c33f9ba8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   28.136537] Call Trace:
[   28.136545]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   28.136553]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   28.136560]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   28.136567]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   28.136574]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.136581]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   28.136588]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   28.136596]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   28.136603]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   28.136612]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   28.136620]  [<ffffffff81362a2f>] ? ext4_ext_remove_space+0x39f/0x13c0
[   28.136627]  [<ffffffff81362a2f>] ext4_ext_remove_space+0x39f/0x13c0
[   28.136635]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[   28.136642]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.136649]  [<ffffffff813656f0>] ext4_ext_truncate+0xc0/0xf0
[   28.136657]  [<ffffffff81339328>] ext4_truncate+0x3f8/0x570
[   28.136665]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   28.136672]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   28.136678]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   28.136686]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   28.136694]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   28.136703]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   28.136710]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   28.136718]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   28.136762] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   28.136768] caller is __this_cpu_preempt_check+0x2b/0x30
[   28.136772] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   28.136775] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   28.136785]  ffff8800c33f9bb0 ffff8800c33f9b80 ffffffff81a64cec 0000000000000003
[   28.136794]  ffff8800c33f9ba0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   28.136804]  ffff8800c33f9bd8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   28.136806] Call Trace:
[   28.136813]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   28.136820]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   28.136828]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   28.136835]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   28.136842]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   28.136849]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.136855]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   28.136861]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   28.136869]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   28.136876]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   28.136884]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   28.136891]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   28.136898]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   28.136906]  [<ffffffff813390c7>] ? ext4_truncate+0x197/0x570
[   28.136913]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   28.136921]  [<ffffffff813390db>] ext4_truncate+0x1ab/0x570
[   28.136928]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   28.136934]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   28.136940]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   28.136948]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   28.136956]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   28.136964]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   28.136971]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   28.136978]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   28.137029] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   28.137034] caller is __this_cpu_preempt_check+0x2b/0x30
[   28.137038] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   28.137040] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   28.137050]  ffff8800c33f9b90 ffff8800c33f9b60 ffffffff81a64cec 0000000000000003
[   28.137060]  ffff8800c33f9b80 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   28.137070]  ffff8800c33f9bb8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   28.137072] Call Trace:
[   28.137079]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   28.137086]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   28.137094]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   28.137101]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   28.137108]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   28.137114]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.137121]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   28.137127]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   28.137135]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   28.137142]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   28.137150]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   28.137157]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   28.137164]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   28.137172]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   28.137179]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   28.137187]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   28.137194]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   28.137202]  [<ffffffff8133b19b>] ext4_setattr+0x2eb/0x810
[   28.137208]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   28.137214]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   28.137222]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   28.137230]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   28.137237]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   28.137245]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   28.137252]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   28.137602] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   28.137608] caller is __this_cpu_preempt_check+0x2b/0x30
[   28.137613] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   28.137615] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   28.137626]  ffff8800c33f9b80 ffff8800c33f9b50 ffffffff81a64cec 0000000000000003
[   28.137636]  ffff8800c33f9b70 ffffffff81462360 ffff8800c3386470 ffffea00030ce100
[   28.137646]  ffff8800c33f9ba8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   28.137648] Call Trace:
[   28.137656]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   28.137664]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   28.137671]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   28.137678]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   28.137685]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.137692]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   28.137698]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   28.137706]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   28.137714]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   28.137722]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   28.137730]  [<ffffffff81362a2f>] ? ext4_ext_remove_space+0x39f/0x13c0
[   28.137737]  [<ffffffff81362a2f>] ext4_ext_remove_space+0x39f/0x13c0
[   28.137745]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[   28.137752]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.137759]  [<ffffffff813656f0>] ext4_ext_truncate+0xc0/0xf0
[   28.137767]  [<ffffffff81339328>] ext4_truncate+0x3f8/0x570
[   28.137775]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   28.137782]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   28.137788]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   28.137796]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   28.137804]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   28.137812]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   28.137820]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   28.137827]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   28.137869] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   28.137875] caller is __this_cpu_preempt_check+0x2b/0x30
[   28.137878] CPU: 3 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   28.137881] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   28.137891]  ffff8800c33f9bb0 ffff8800c33f9b80 ffffffff81a64cec 0000000000000003
[   28.137901]  ffff8800c33f9ba0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   28.137910]  ffff8800c33f9bd8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   28.137912] Call Trace:
[   28.137919]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   28.137927]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   28.137934]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   28.137942]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   28.137948]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   28.137955]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   28.137962]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   28.137968]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   28.137975]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   28.137983]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   28.138085]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   28.138092]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   28.138098]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   28.138106]  [<ffffffff813390c7>] ? ext4_truncate+0x197/0x570
[   28.138113]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   28.138121]  [<ffffffff813390db>] ext4_truncate+0x1ab/0x570
[   28.138128]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   28.138135]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   28.138140]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   28.138148]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   28.138156]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   28.138164]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   28.138171]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   28.138178]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   29.477915] caller is __this_cpu_preempt_check+0x2b/0x30
[   29.482765] CPU: 0 PID: 195 Comm: kworker/u16:5 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   29.488254] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   29.493591] Workqueue: phy0 ieee80211_iface_work
[   29.498009]  ffff8800c42c9b60 ffff8800c42c9b30 ffffffff81a64cec 0000000000000000
[   29.502491]  ffff8800c42c9b50 ffffffff81462360 ffff8800c2c1df10 ffffea00030b0600
[   29.506959]  ffff8800c42c9b88 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   29.510945] Call Trace:
[   29.514263]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   29.517948]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   29.521510]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   29.525057]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   29.528497]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   29.531879]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   29.535152]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   29.538568]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   29.541761]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   29.545023]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   29.548070]  [<ffffffff81818f6e>] ? skb_release_data+0x11e/0x130
[   29.551056]  [<ffffffff81818f6e>] skb_release_data+0x11e/0x130
[   29.554016]  [<ffffffff819fa1a0>] ? ieee80211_iface_work+0xd0/0x360
[   29.557146]  [<ffffffff81818fa4>] skb_release_all+0x24/0x30
[   29.559933]  [<ffffffff81818d36>] kfree_skb+0x36/0x150
[   29.562578]  [<ffffffff819fa1a0>] ieee80211_iface_work+0xd0/0x360
[   29.565499]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[   29.568640]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[   29.571518]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[   29.574198]  [<ffffffff8118cc22>] ? complete+0x42/0x50
[   29.576856]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   29.579524]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[   29.582148]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[   29.584759]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   29.587405]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[   29.589887]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   33.146785] check_preemption_disabled: 20184 callbacks suppressed
[   33.151656] BUG: using __this_cpu_add() in preemptible [00000000] code: keychain/520
[   33.151902] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   33.151916] caller is __this_cpu_preempt_check+0x2b/0x30
[   33.151923] CPU: 2 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   33.151925] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   33.151938]  ffff8800c33f99d0 ffff8800c33f99a0 ffffffff81a64cec 0000000000000002
[   33.151948]  ffff8800c33f99c0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   33.151958]  ffff8800c33f99f8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   33.151960] Call Trace:
[   33.151974]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   33.151986]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   33.152009]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   33.152019]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   33.152032]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   33.152043]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   33.152054]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   33.152065]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   33.152075]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   33.152089]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   33.152102]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   33.152110]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   33.152123]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   33.152136]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   33.152146]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   33.152160]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   33.152169]  [<ffffffff812b6d7e>] update_time+0x7e/0xd0
[   33.152179]  [<ffffffff812b9280>] file_update_time+0x80/0xc0
[   33.152190]  [<ffffffff8133b8f5>] ext4_page_mkwrite+0x55/0x430
[   33.152204]  [<ffffffff812600cf>] do_page_mkwrite+0x3f/0xc0
[   33.152215]  [<ffffffff81261de9>] do_wp_page+0x6f9/0x8d0
[   33.152224]  [<ffffffff81265903>] handle_mm_fault+0x5c3/0xc70
[   33.152235]  [<ffffffff81198307>] ? __lock_is_held+0x57/0x80
[   33.152247]  [<ffffffff810ac647>] __do_page_fault+0x167/0x510
[   33.152257]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[   33.152269]  [<ffffffff81a72c76>] ? error_sti+0x5/0x6
[   33.152280]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   33.152290]  [<ffffffff811976a9>] ? trace_hardirqs_off_caller+0x99/0x160
[   33.152300]  [<ffffffff81457eda>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   33.152310]  [<ffffffff810aca2e>] do_page_fault+0xe/0x10
[   33.152320]  [<ffffffff81a72a28>] page_fault+0x28/0x30
[   33.152404] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u16:5/195
[   33.152415] caller is __this_cpu_preempt_check+0x2b/0x30
[   33.152423] CPU: 0 PID: 195 Comm: kworker/u16:5 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   33.152427] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   33.152444] Workqueue: phy0 ieee80211_iface_work
[   33.152461]  ffff8800c42c9b60 ffff8800c42c9b30 ffffffff81a64cec 0000000000000000
[   33.152478]  ffff8800c42c9b50 ffffffff81462360 ffff8800c2c1e458 ffffea00030b0600
[   33.152495]  ffff8800c42c9b88 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   33.152498] Call Trace:
[   33.152511]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   33.152522]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   33.152532]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   33.152542]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   33.152553]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   33.152563]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   33.152573]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   33.152584]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   33.152595]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   33.152608]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   33.152622]  [<ffffffff81818f6e>] ? skb_release_data+0x11e/0x130
[   33.152645]  [<ffffffff81818f6e>] skb_release_data+0x11e/0x130
[   33.152657]  [<ffffffff819fa1a0>] ? ieee80211_iface_work+0xd0/0x360
[   33.152670]  [<ffffffff81818fa4>] skb_release_all+0x24/0x30
[   33.152682]  [<ffffffff81818d36>] kfree_skb+0x36/0x150
[   33.152694]  [<ffffffff819fa1a0>] ieee80211_iface_work+0xd0/0x360
[   33.152709]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[   33.152720]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[   33.152731]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[   33.152745]  [<ffffffff8118cc22>] ? complete+0x42/0x50
[   33.152757]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   33.152767]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[   33.152778]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[   33.152790]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   33.152802]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[   33.152812]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   33.152817] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   33.152824] caller is __this_cpu_preempt_check+0x2b/0x30
[   33.152830] CPU: 2 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   33.152832] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   33.152844]  ffff8800c33f9b80 ffff8800c33f9b50 ffffffff81a64cec 0000000000000002
[   33.152853]  ffff8800c33f9b70 ffffffff81462360
[   33.152853] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u16:5/195
[   33.152860]  ffff8800c1d34848 ffffea0003074d00
[   33.152863] caller is __this_cpu_preempt_check+0x2b/0x30
[   33.152873]  ffff8800c33f9ba8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   33.152875] Call Trace:
[   33.152883]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   33.152891]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   33.152899]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   33.152906]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   33.152913]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   33.152920]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   33.152927]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   33.152935]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   33.152943]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   33.152952]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   33.152960]  [<ffffffff81362a2f>] ? ext4_ext_remove_space+0x39f/0x13c0
[   33.152967]  [<ffffffff81362a2f>] ext4_ext_remove_space+0x39f/0x13c0
[   33.152975]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[   33.152982]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   33.152990]  [<ffffffff813656f0>] ext4_ext_truncate+0xc0/0xf0
[   33.152998]  [<ffffffff81339328>] ext4_truncate+0x3f8/0x570
[   33.153006]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   33.153013]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   33.153020]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   33.153029]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   33.153037]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   33.153045]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   33.153053]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   33.153061]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   33.153069] CPU: 0 PID: 195 Comm: kworker/u16:5 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   33.153074] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   33.153086] Workqueue: phy0 ieee80211_iface_work
[   33.153106]  ffff8800c42c9b90 ffff8800c42c9b60 ffffffff81a64cec 0000000000000000
[   33.153110] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   33.153116]  ffff8800c42c9b80
[   33.153117] caller is __this_cpu_preempt_check+0x2b/0x30
[   33.153131]  ffffffff81462360 ffff8800c2e1d680 ffffea00030b8700
[   33.153150]  ffff8800c42c9bb8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   33.153153] Call Trace:
[   33.153166]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   33.153185]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   33.153197]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   33.153208]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   33.153220]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   33.153231]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   33.153242]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   33.153255]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   33.153267]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   33.153280]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   33.153292]  [<ffffffff81817787>] ? kfree_skbmem+0x37/0xa0
[   33.153305]  [<ffffffff819fa1a0>] ? ieee80211_iface_work+0xd0/0x360
[   33.153318]  [<ffffffff81817787>] kfree_skbmem+0x37/0xa0
[   33.153333]  [<ffffffff81818d3e>] kfree_skb+0x3e/0x150
[   33.153345]  [<ffffffff819fa1a0>] ieee80211_iface_work+0xd0/0x360
[   33.153356]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[   33.153366]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[   33.153378]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[   33.153392]  [<ffffffff8118cc22>] ? complete+0x42/0x50
[   33.153404]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   33.153415]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[   33.153424]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[   33.153435]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   33.153446]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[   33.153455]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   33.153461] CPU: 2 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   33.153464] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   33.153474]  ffff8800c33f9bb0 ffff8800c33f9b80 ffffffff81a64cec 0000000000000002
[   33.153483]  ffff8800c33f9ba0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   33.153493]  ffff8800c33f9bd8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   33.153495] Call Trace:
[   33.153503]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   33.153510]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   33.153518]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   33.153525]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   33.153532]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   33.153539]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   33.153545]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   33.153552]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   33.153560]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   33.153567]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   33.153575]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   33.153583]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   33.153589]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   33.153597]  [<ffffffff813390c7>] ? ext4_truncate+0x197/0x570
[   33.153605]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   33.153612]  [<ffffffff813390db>] ext4_truncate+0x1ab/0x570
[   33.153620]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   33.153626]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   33.153632]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   33.153640]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   33.153648]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   33.153656]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   33.153664]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   33.153671]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   33.153822] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   33.153828] caller is __this_cpu_preempt_check+0x2b/0x30
[   33.153832] CPU: 2 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   33.153835] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   33.153845]  ffff8800c33f9b90 ffff8800c33f9b60 ffffffff81a64cec 0000000000000002
[   33.153855]  ffff8800c33f9b80 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   33.153865]  ffff8800c33f9bb8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   33.153866] Call Trace:
[   33.153876]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   33.153887]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   33.153910]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   33.153921]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   33.153930]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   33.153940]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   33.153950]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   33.153960]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   33.153971]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   33.153982]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   33.153993]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   33.154003]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   33.154013]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   33.154025]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   33.154036]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   33.154046]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   33.154057]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   33.154068]  [<ffffffff8133b19b>] ext4_setattr+0x2eb/0x810
[   33.154078]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   33.154087]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   33.154098]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   33.154109]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   33.154118]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   33.154125]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   33.154145]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   33.154355] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   33.154361] caller is __this_cpu_preempt_check+0x2b/0x30
[   33.154366] CPU: 2 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   33.154368] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   33.154378]  ffff8800c33f99d0 ffff8800c33f99a0 ffffffff81a64cec 0000000000000002
[   33.154388]  ffff8800c33f99c0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   33.154398]  ffff8800c33f99f8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   33.154400] Call Trace:
[   33.154408]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   33.154415]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   33.154423]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   33.154429]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   33.154436]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   33.154443]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   33.154449]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   33.154457]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   33.154464]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   33.154472]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   33.154479]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   33.154486]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   33.154494]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   33.154502]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   33.154509]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   33.154517]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   33.154522]  [<ffffffff812b6d7e>] update_time+0x7e/0xd0
[   33.154528]  [<ffffffff812b9280>] file_update_time+0x80/0xc0
[   33.154536]  [<ffffffff8133b8f5>] ext4_page_mkwrite+0x55/0x430
[   33.154545]  [<ffffffff812600cf>] do_page_mkwrite+0x3f/0xc0
[   33.154552]  [<ffffffff81261de9>] do_wp_page+0x6f9/0x8d0
[   33.154558]  [<ffffffff81265903>] handle_mm_fault+0x5c3/0xc70
[   33.154565]  [<ffffffff81198307>] ? __lock_is_held+0x57/0x80
[   33.154572]  [<ffffffff810ac647>] __do_page_fault+0x167/0x510
[   33.154579]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[   33.154586]  [<ffffffff81a72c76>] ? error_sti+0x5/0x6
[   33.154594]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   33.154600]  [<ffffffff811976a9>] ? trace_hardirqs_off_caller+0x99/0x160
[   33.154608]  [<ffffffff81457eda>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   33.154614]  [<ffffffff810aca2e>] do_page_fault+0xe/0x10
[   33.154621]  [<ffffffff81a72a28>] page_fault+0x28/0x30
[   33.154845] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   33.154852] caller is __this_cpu_preempt_check+0x2b/0x30
[   33.154856] CPU: 2 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   33.154858] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   33.154869]  ffff8800c33f9b80 ffff8800c33f9b50 ffffffff81a64cec 0000000000000002
[   33.154879]  ffff8800c33f9b70 ffffffff81462360 ffff8800c1d34848 ffffea0003074d00
[   33.154889]  ffff8800c33f9ba8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   33.154891] Call Trace:
[   33.154899]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   33.154907]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   33.154914]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   33.154921]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   33.154928]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   33.154935]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   33.154942]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   33.154949]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   33.154957]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   33.154965]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   33.154973]  [<ffffffff81362a2f>] ? ext4_ext_remove_space+0x39f/0x13c0
[   33.154980]  [<ffffffff81362a2f>] ext4_ext_remove_space+0x39f/0x13c0
[   33.154988]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[   33.154995]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   33.155002]  [<ffffffff813656f0>] ext4_ext_truncate+0xc0/0xf0
[   33.155010]  [<ffffffff81339328>] ext4_truncate+0x3f8/0x570
[   33.155018]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   33.155025]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   33.155031]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   33.155040]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   33.155048]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   33.155055]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   33.155063]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   33.155071]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   33.155114] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   33.155120] caller is __this_cpu_preempt_check+0x2b/0x30
[   33.155123] CPU: 2 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   33.155126] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   33.155136]  ffff8800c33f9bb0 ffff8800c33f9b80 ffffffff81a64cec 0000000000000002
[   33.155145]  ffff8800c33f9ba0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   33.155155]  ffff8800c33f9bd8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   33.155157] Call Trace:
[   33.155164]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   33.155171]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   33.155179]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   33.155186]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   33.155193]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   33.155199]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   33.155206]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   33.155212]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   33.155220]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   33.155227]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   33.155235]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   33.155242]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   33.155249]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   33.155257]  [<ffffffff813390c7>] ? ext4_truncate+0x197/0x570
[   33.155264]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   33.155272]  [<ffffffff813390db>] ext4_truncate+0x1ab/0x570
[   33.155279]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   33.155285]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   33.155291]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   33.155299]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   33.155307]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   33.155314]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   33.155322]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   33.155329]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   34.560028] caller is __this_cpu_preempt_check+0x2b/0x30
[   34.564874] CPU: 1 PID: 520 Comm: keychain Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   34.570265] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   34.575542]  ffff880113997da0 ffff880113997d70 ffffffff81a64cec 0000000000000001
[   34.580601]  ffff880113997d90 ffffffff81462360 ffff8800c1da9180 ffffea0003076a00
[   34.584972]  ffff880113997dc8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   34.589549] Call Trace:
[   34.592901]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   34.596665]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   34.600497]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   34.604065]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   34.607543]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   34.610975]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   34.614304]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   34.617625]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   34.621022]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   34.624189]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   34.627255]  [<ffffffff812a5ae2>] ? final_putname+0x22/0x50
[   34.630318]  [<ffffffff812a5ae2>] final_putname+0x22/0x50
[   34.633181]  [<ffffffff812a5d89>] putname+0x29/0x40
[   34.635973]  [<ffffffff8129a569>] do_sys_open+0x199/0x220
[   34.638830]  [<ffffffff8129a60e>] SyS_open+0x1e/0x20
[   34.641402]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   38.176000] check_preemption_disabled: 6531 callbacks suppressed
[   38.180938] BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u16:5/195
[   38.181338] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   38.181352] caller is __this_cpu_preempt_check+0x2b/0x30
[   38.181360] CPU: 1 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   38.181363] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   38.181376]  ffff8800c33f99e0 ffff8800c33f99b0 ffffffff81a64cec 0000000000000001
[   38.181386]  ffff8800c33f99d0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   38.181396]  ffff8800c33f9a08 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   38.181398] Call Trace:
[   38.181412]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   38.181421]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   38.181429]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   38.181436]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   38.181446]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.181453]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   38.181461]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   38.181470]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   38.181477]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   38.181489]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   38.181499]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   38.181507]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   38.181517]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   38.181526]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   38.181534]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   38.181545]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   38.181552]  [<ffffffff812b6d7e>] update_time+0x7e/0xd0
[   38.181558]  [<ffffffff812b9280>] file_update_time+0x80/0xc0
[   38.181566]  [<ffffffff8133b8f5>] ext4_page_mkwrite+0x55/0x430
[   38.181577]  [<ffffffff812600cf>] do_page_mkwrite+0x3f/0xc0
[   38.181586]  [<ffffffff81262e66>] do_shared_fault+0x76/0x220
[   38.181595]  [<ffffffff811b5584>] ? __rcu_read_unlock+0x54/0xa0
[   38.181601]  [<ffffffff8126556c>] handle_mm_fault+0x22c/0xc70
[   38.181609]  [<ffffffff81198307>] ? __lock_is_held+0x57/0x80
[   38.181619]  [<ffffffff810ac647>] __do_page_fault+0x167/0x510
[   38.181627]  [<ffffffff81455739>] ? snprintf+0x39/0x40
[   38.181636]  [<ffffffff81a72c76>] ? error_sti+0x5/0x6
[   38.181643]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   38.181650]  [<ffffffff811976a9>] ? trace_hardirqs_off_caller+0x99/0x160
[   38.181658]  [<ffffffff81457eda>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   38.181664]  [<ffffffff810aca2e>] do_page_fault+0xe/0x10
[   38.181671]  [<ffffffff81a72a28>] page_fault+0x28/0x30
[   38.181984] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   38.181991] caller is __this_cpu_preempt_check+0x2b/0x30
[   38.181996] CPU: 1 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   38.181999] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   38.182011]  ffff8800c33f9b80 ffff8800c33f9b50 ffffffff81a64cec 0000000000000001
[   38.182023]  ffff8800c33f9b70 ffffffff81462360 ffff8800c3385f78 ffffea00030ce100
[   38.182033]  ffff8800c33f9ba8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   38.182035] Call Trace:
[   38.182046]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   38.182055]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   38.182064]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   38.182071]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   38.182078]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.182086]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   38.182094]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   38.182103]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   38.182112]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   38.182121]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   38.182129]  [<ffffffff81362a2f>] ? ext4_ext_remove_space+0x39f/0x13c0
[   38.182136]  [<ffffffff81362a2f>] ext4_ext_remove_space+0x39f/0x13c0
[   38.182145]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[   38.182153]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.182161]  [<ffffffff813656f0>] ext4_ext_truncate+0xc0/0xf0
[   38.182171]  [<ffffffff81339328>] ext4_truncate+0x3f8/0x570
[   38.182181]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   38.182189]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   38.182197]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   38.182207]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   38.182216]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   38.182225]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   38.182233]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   38.182241]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   38.182290] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   38.182296] caller is __this_cpu_preempt_check+0x2b/0x30
[   38.182300] CPU: 1 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   38.182303] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   38.182313]  ffff8800c33f9bb0 ffff8800c33f9b80 ffffffff81a64cec 0000000000000001
[   38.182323]  ffff8800c33f9ba0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   38.182332]  ffff8800c33f9bd8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   38.182334] Call Trace:
[   38.182342]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   38.182350]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   38.182357]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   38.182365]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   38.182371]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   38.182378]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.182385]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   38.182391]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   38.182399]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   38.182406]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   38.182414]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   38.182422]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   38.182428]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   38.182436]  [<ffffffff813390c7>] ? ext4_truncate+0x197/0x570
[   38.182444]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   38.182451]  [<ffffffff813390db>] ext4_truncate+0x1ab/0x570
[   38.182459]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   38.182465]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   38.182472]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   38.182480]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   38.182488]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   38.182495]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   38.182503]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   38.182510]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   38.182564] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   38.182570] caller is __this_cpu_preempt_check+0x2b/0x30
[   38.182574] CPU: 1 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   38.182576] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   38.182586]  ffff8800c33f9b90 ffff8800c33f9b60 ffffffff81a64cec 0000000000000001
[   38.182596]  ffff8800c33f9b80 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   38.182605]  ffff8800c33f9bb8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   38.182607] Call Trace:
[   38.182614]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   38.182622]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   38.182629]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   38.182637]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   38.182643]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   38.182650]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.182657]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   38.182663]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   38.182670]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   38.182678]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   38.182686]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   38.182693]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   38.182699]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   38.182707]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   38.182715]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   38.182722]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   38.182730]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   38.182738]  [<ffffffff8133b19b>] ext4_setattr+0x2eb/0x810
[   38.182744]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   38.182750]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   38.182758]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   38.182766]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   38.182773]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   38.182942]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   38.182949]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   38.183358] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   38.183365] caller is __this_cpu_preempt_check+0x2b/0x30
[   38.183369] CPU: 1 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   38.183372] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   38.183383]  ffff8800c33f9b80 ffff8800c33f9b50 ffffffff81a64cec 0000000000000001
[   38.183393]  ffff8800c33f9b70 ffffffff81462360 ffff8800c3385f78 ffffea00030ce100
[   38.183403]  ffff8800c33f9ba8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   38.183405] Call Trace:
[   38.183414]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   38.183421]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   38.183429]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   38.183435]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   38.183443]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.183450]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   38.183456]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   38.183464]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   38.183472]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   38.183480]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   38.183488]  [<ffffffff81362a2f>] ? ext4_ext_remove_space+0x39f/0x13c0
[   38.183495]  [<ffffffff81362a2f>] ext4_ext_remove_space+0x39f/0x13c0
[   38.183503]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[   38.183510]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.183518]  [<ffffffff813656f0>] ext4_ext_truncate+0xc0/0xf0
[   38.183526]  [<ffffffff81339328>] ext4_truncate+0x3f8/0x570
[   38.183533]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   38.183540]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   38.183547]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   38.183555]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   38.183563]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   38.183571]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   38.183578]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   38.183586]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   38.183629] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   38.183634] caller is __this_cpu_preempt_check+0x2b/0x30
[   38.183638] CPU: 1 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   38.183641] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   38.183651]  ffff8800c33f9bb0 ffff8800c33f9b80 ffffffff81a64cec 0000000000000001
[   38.183660]  ffff8800c33f9ba0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   38.183670]  ffff8800c33f9bd8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   38.183672] Call Trace:
[   38.183679]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   38.183687]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   38.183694]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   38.183702]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   38.183708]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   38.183715]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.183722]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   38.183728]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   38.183735]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   38.183743]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   38.183751]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   38.183758]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   38.183765]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   38.183772]  [<ffffffff813390c7>] ? ext4_truncate+0x197/0x570
[   38.183780]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   38.183787]  [<ffffffff813390db>] ext4_truncate+0x1ab/0x570
[   38.183795]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   38.183801]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   38.183807]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   38.183815]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   38.183823]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   38.183830]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   38.183838]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   38.183845]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   38.183895] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   38.183900] caller is __this_cpu_preempt_check+0x2b/0x30
[   38.183904] CPU: 1 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   38.183906] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   38.183916]  ffff8800c33f9b90 ffff8800c33f9b60 ffffffff81a64cec 0000000000000001
[   38.183926]  ffff8800c33f9b80 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   38.183936]  ffff8800c33f9bb8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   38.183938] Call Trace:
[   38.183945]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   38.183952]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   38.183960]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   38.183967]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   38.183974]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   38.183980]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.183987]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   38.183993]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   38.184001]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   38.184008]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   38.184016]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   38.184023]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   38.184030]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   38.184038]  [<ffffffff8133b700>] ? ext4_dirty_inode+0x40/0x60
[   38.184045]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   38.184052]  [<ffffffff8133b714>] ext4_dirty_inode+0x54/0x60
[   38.184060]  [<ffffffff812cbbca>] __mark_inode_dirty+0x3a/0x460
[   38.184068]  [<ffffffff8133b19b>] ext4_setattr+0x2eb/0x810
[   38.184074]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   38.184080]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   38.184088]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   38.184096]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   38.184103]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   38.184111]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   38.184118]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   38.184555] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   38.184562] caller is __this_cpu_preempt_check+0x2b/0x30
[   38.184566] CPU: 1 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   38.184569] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   38.184580]  ffff8800c33f9b80 ffff8800c33f9b50 ffffffff81a64cec 0000000000000001
[   38.184590]  ffff8800c33f9b70 ffffffff81462360 ffff8800c3385f78 ffffea00030ce100
[   38.184600]  ffff8800c33f9ba8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   38.184602] Call Trace:
[   38.184610]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   38.184618]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   38.184625]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   38.184632]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   38.184639]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.184646]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   38.184652]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   38.184660]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   38.184668]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   38.184676]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   38.184684]  [<ffffffff81362a2f>] ? ext4_ext_remove_space+0x39f/0x13c0
[   38.184691]  [<ffffffff81362a2f>] ext4_ext_remove_space+0x39f/0x13c0
[   38.184699]  [<ffffffff81462380>] ? debug_smp_processor_id+0x10/0x20
[   38.184706]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.184713]  [<ffffffff813656f0>] ext4_ext_truncate+0xc0/0xf0
[   38.184721]  [<ffffffff81339328>] ext4_truncate+0x3f8/0x570
[   38.184729]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   38.184735]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   38.184742]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   38.184750]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   38.184758]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   38.184766]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   38.184774]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   38.184781]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   38.184823] BUG: using __this_cpu_add() in preemptible [00000000] code: systemd-journal/226
[   38.184828] caller is __this_cpu_preempt_check+0x2b/0x30
[   38.184832] CPU: 1 PID: 226 Comm: systemd-journal Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   38.184835] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   38.184845]  ffff8800c33f9bb0 ffff8800c33f9b80 ffffffff81a64cec 0000000000000001
[   38.184854]  ffff8800c33f9ba0 ffffffff81462360 ffff8800c4a3bd48 ffffea0003128e00
[   38.184864]  ffff8800c33f9bd8 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   38.184866] Call Trace:
[   38.184873]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   38.184880]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   38.184888]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   38.184895]  [<ffffffff81462300>] ? check_preemption_disabled+0x70/0xe0
[   38.184902]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   38.184908]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   38.184915]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   38.184923]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   38.184935]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   38.184945]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   38.184958]  [<ffffffff81286b67>] kmem_cache_free+0x367/0x3a0
[   38.184968]  [<ffffffff81381dbd>] ? jbd2_journal_stop+0x24d/0x500
[   38.184979]  [<ffffffff81381dbd>] jbd2_journal_stop+0x24d/0x500
[   38.184992]  [<ffffffff813390c7>] ? ext4_truncate+0x197/0x570
[   38.185002]  [<ffffffff81366947>] __ext4_journal_stop+0x37/0x90
[   38.185014]  [<ffffffff813390db>] ext4_truncate+0x1ab/0x570
[   38.185025]  [<ffffffff8133b183>] ext4_setattr+0x2d3/0x810
[   38.185035]  [<ffffffff8119760d>] ? trace_hardirqs_on+0xd/0x10
[   38.185045]  [<ffffffff812b9a29>] notify_change+0x159/0x3a0
[   38.185058]  [<ffffffff812990bf>] do_truncate+0x6f/0xa0
[   38.185070]  [<ffffffff812991fe>] do_sys_ftruncate.constprop.18+0x10e/0x160
[   38.185082]  [<ffffffff81457e9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   38.185093]  [<ffffffff812994ae>] SyS_ftruncate+0xe/0x10
[   38.185105]  [<ffffffff81a732ad>] system_call_fastpath+0x1a/0x1f
[   39.540957] caller is __this_cpu_preempt_check+0x2b/0x30
[   39.540964] CPU: 2 PID: 195 Comm: kworker/u16:5 Not tainted 3.14.0-rc5-next-20140306-joshc-08290-g0ffb2fe #1
[   39.540975] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 900X3C/900X3D/900X3E/900X4C/900X4D/NP900X3E-A02US, BIOS P07ABK 04/09/2013
[   39.541136] Workqueue: phy0 ieee80211_iface_work
[   39.541157]  ffff8800c42c9b60 ffff8800c42c9b30 ffffffff81a64cec 0000000000000002
[   39.541177]  ffff8800c42c9b50 ffffffff81462360 ffff8800c2c19fb0 ffffea00030b0600
[   39.541196]  ffff8800c42c9b88 ffffffff814623bb 635f736968745f5f 29286464615f7570
[   39.541200] Call Trace:
[   39.541216]  [<ffffffff81a64cec>] dump_stack+0x4e/0x7a
[   39.541227]  [<ffffffff81462360>] check_preemption_disabled+0xd0/0xe0
[   39.541235]  [<ffffffff814623bb>] __this_cpu_preempt_check+0x2b/0x30
[   39.541242]  [<ffffffff81a6331d>] __slab_free+0x38/0x590
[   39.541251]  [<ffffffff811759dd>] ? get_parent_ip+0xd/0x50
[   39.541258]  [<ffffffff81175b3b>] ? preempt_count_sub+0x6b/0xf0
[   39.541265]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   39.541273]  [<ffffffff81462e5e>] ? __debug_check_no_obj_freed+0x13e/0x240
[   39.541281]  [<ffffffff814623bb>] ? __this_cpu_preempt_check+0x2b/0x30
[   39.541290]  [<ffffffff81287327>] kfree+0x2f7/0x300
[   39.541301]  [<ffffffff81818f6e>] ? skb_release_data+0x11e/0x130
[   39.541309]  [<ffffffff81818f6e>] skb_release_data+0x11e/0x130
[   39.541317]  [<ffffffff819fa1a0>] ? ieee80211_iface_work+0xd0/0x360
[   39.541325]  [<ffffffff81818fa4>] skb_release_all+0x24/0x30
[   39.541333]  [<ffffffff81818d36>] kfree_skb+0x36/0x150
[   39.541340]  [<ffffffff819fa1a0>] ieee80211_iface_work+0xd0/0x360
[   39.541348]  [<ffffffff8115aeb4>] process_one_work+0x1e4/0x690
[   39.541354]  [<ffffffff8115ae4a>] ? process_one_work+0x17a/0x690
[   39.541361]  [<ffffffff8115b47b>] worker_thread+0x11b/0x3a0
[   39.541370]  [<ffffffff8118cc22>] ? complete+0x42/0x50
[   39.541377]  [<ffffffff81a7175a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[   39.541383]  [<ffffffff8115b360>] ? process_one_work+0x690/0x690
[   39.541389]  [<ffffffff81163ea0>] kthread+0xf0/0x110
[   39.541396]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80
[   39.541404]  [<ffffffff81a731fc>] ret_from_fork+0x7c/0xb0
[   39.541409]  [<ffffffff81163db0>] ? insert_kthread_work+0x80/0x80

--PNTmBPCT7hxwcZjr--
