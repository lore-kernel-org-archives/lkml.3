Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168AbaCHHmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 02:42:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:45687 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaCHHmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 02:42:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,613,1389772800"; 
   d="log'?scan'208";a="488376483"
Date: Sat, 8 Mar 2014 15:42:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Hong Zhiguo <zhiguohong@tencent.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [blkg] WARNING: CPU: 0 PID: 298 at kernel/softirq.c:145
 __local_bh_enable_ip()
Message-ID: <20140308074243.GB30311@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hong Zhiguo,

The WARNINGs introduced by this commit are still in linux-next 20140307.

commit 2c575026fae6e63771bd2a4c1d407214a8096a89
Author:     Hong Zhiguo <zhiguohong@tencent.com>
AuthorDate: Wed Nov 20 10:35:05 2013 -0700
Commit:     Jens Axboe <axboe@kernel.dk>
CommitDate: Wed Nov 20 15:33:04 2013 -0700

    Update of blkg_stat and blkg_rwstat may happen in bh context.
    While u64_stats_fetch_retry is only preempt_disable on 32bit
    UP system. This is not enough to avoid preemption by bh and
    may read strange 64 bit value.
    
    Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
    Acked-by: Tejun Heo <tj@kernel.org>
    Cc: stable@kernel.org
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

+------------------------------------------------------------+------------+---------------+
|                                                            | 2c575026fa | next-20140306 |
+------------------------------------------------------------+------------+---------------+
| boot_successes                                             | 0          | 0             |
| boot_failures                                              | 20         | 19            |
| WARNING:CPU:PID:at_kernel/softirq.c:local_bh_enable()      | 20         |               |
| inconsistent_IN-SOFTIRQ-W-SOFTIRQ-ON-W_usage               | 20         |               |
| backtrace:vfs_read                                         | 20         | 18            |
| backtrace:SyS_read                                         | 20         | 18            |
| backtrace:smpboot_thread_fn                                | 14         |               |
| page_allocation_failure:order:,mode                        | 1          |               |
| backtrace:vmalloc                                          | 1          |               |
| backtrace:SyS_init_module                                  | 1          |               |
| WARNING:CPU:PID:at_kernel/softirq.c:__local_bh_enable_ip() | 0          | 16            |
| inconsistent_IN-HARDIRQ-W-HARDIRQ-ON-W_usage               | 0          | 19            |
| Out_of_memory:Kill_process                                 | 0          | 1             |
| backtrace:do_mount                                         | 0          | 1             |
| backtrace:SyS_mount                                        | 0          | 1             |
| BUG:kernel_boot_hang                                       | 0          | 1             |
+------------------------------------------------------------+------------+---------------+

[    8.215262] ------------[ cut here ]------------
[    8.215318] WARNING: CPU: 0 PID: 287 at /kernel-tests/linux4/kernel/softirq.c:156 local_bh_enable+0xbf/0x20e()
[    8.215331] Modules linked in:
[    8.215338] CPU: 0 PID: 287 Comm: blkid Not tainted 3.12.0-10878-g2c57502 #109
[    8.215340] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    8.215355]  00000000 c53a5bd0 c152b622 c53a5be8 c0259135 c025fdb2 c068e196 00000000
[    8.215364]  c56dac00 c53a5bf8 c02591a1 00000009 00000000 c53a5c04 c025fdb2 00000000
[    8.215372]  c53a5cac c068e196 00000001 00000000 c56d6000 c57ba840 c56dac00 c068002f
[    8.215374] Call Trace:
[    8.215403]  [<c152b622>] dump_stack+0x40/0x5e
[    8.215408]  [<c0259135>] warn_slowpath_common+0xa9/0xea
[    8.215413]  [<c025fdb2>] ? local_bh_enable+0xbf/0x20e
[    8.215435]  [<c068e196>] ? __cfq_set_active_queue+0x110/0x27d
[    8.215440]  [<c02591a1>] warn_slowpath_null+0x2b/0x3d
[    8.215444]  [<c025fdb2>] local_bh_enable+0xbf/0x20e
[    8.215449]  [<c068e196>] __cfq_set_active_queue+0x110/0x27d
[    8.215454]  [<c068002f>] ? add_disk+0x12c/0x781
[    8.215459]  [<c06907a9>] ? cfq_resort_rr_list+0x49/0x5b
[    8.215463]  [<c0690899>] ? cfq_add_cfqq_rr+0xde/0xf3
[    8.215468]  [<c0690c67>] ? cfq_update_idle_window.isra.78+0xf2/0x1f4
[    8.215480]  [<c0294d19>] ? sched_clock_cpu+0x1c4/0x1f9
[    8.215487]  [<c029fb08>] ? trace_hardirqs_off+0x27/0x37
[    8.215492]  [<c0294e4d>] ? local_clock+0xff/0x176
[    8.215497]  [<c06951f7>] cfq_dispatch_requests+0xb92/0x11b0
[    8.215504]  [<c024812f>] ? kvm_clock_read+0x30/0x55
[    8.215515]  [<c020f559>] ? sched_clock+0x3e/0x50
[    8.215520]  [<c06931f4>] ? cfq_insert_request+0x3c9/0x869
[    8.215525]  [<c029fb08>] ? trace_hardirqs_off+0x27/0x37
[    8.215530]  [<c02a77fb>] ? __lock_acquire+0x15a4/0x16ca
[    8.215538]  [<c06aec9f>] ? list_sort+0x1fb/0x253
[    8.215547]  [<c066e10c>] blk_peek_request+0x9e/0x31a
[    8.215566]  [<c0b523bf>] scsi_request_fn+0x62/0x89e
[    8.215571]  [<c066e8fd>] ? blk_flush_plug_list+0x2a4/0x447
[    8.215577]  [<c0668eec>] __blk_run_queue+0x55/0x6c
[    8.215582]  [<c066c588>] queue_unplugged.isra.29+0x40/0x6a
[    8.215586]  [<c066e9bf>] blk_flush_plug_list+0x366/0x447
[    8.215591]  [<c066eabb>] blk_finish_plug+0x1b/0x51
[    8.215607]  [<c03275e3>] __do_page_cache_readahead+0x314/0x364
[    8.215614]  [<c032772f>] force_page_cache_readahead+0x9e/0xea
[    8.215620]  [<c0327d36>] page_cache_sync_readahead+0x5d/0x91
[    8.215624]  [<c0319608>] generic_file_aio_read+0x393/0xb7e
[    8.215638]  [<c03c7bb9>] blkdev_aio_read+0x95/0xb1
[    8.215646]  [<c0375ec0>] do_sync_read+0x5a/0xab
[    8.215651]  [<c0375e66>] ? do_sync_write+0xab/0xab
[    8.215655]  [<c0376b3b>] vfs_read+0xd3/0x1ee
[    8.215659]  [<c0376e5f>] SyS_read+0x73/0xe8
[    8.215668]  [<c154488a>] sysenter_do_call+0x12/0x3c
[    8.215672] ---[ end trace 6f72697fe2d05017 ]---
[    8.215727] 
[    8.215729] =================================
[    8.215730] [ INFO: inconsistent lock state ]
[    8.215733] 3.12.0-10878-g2c57502 #109 Tainted: G        W   
[    8.215735] ---------------------------------
[    8.215737] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[    8.215740] blkid/287 [HC0[0]:SC0[0]:HE1:SE1] takes:
[    8.215749]  (&(&q->__queue_lock)->rlock){+.?...}, at: [<c066e8fd>] blk_flush_plug_list+0x2a4/0x447
[    8.215750] {IN-SOFTIRQ-W} state was registered at:
[    8.215756]   [<c02a7102>] __lock_acquire+0xeab/0x16ca
[    8.215760]   [<c02a7a07>] lock_acquire+0xe6/0x147
[    8.215767]   [<c1542430>] _raw_spin_lock+0x4e/0xee
[    8.215771]   [<c0b52ce9>] scsi_device_unbusy+0xee/0x134
[    8.215781]   [<c0b47e22>] scsi_finish_command+0x2b/0x107
[    8.215785]   [<c0b5303f>] scsi_softirq_done+0x1b5/0x1cb
[    8.215791]   [<c067666b>] blk_done_softirq+0x10e/0x133
[    8.215796]   [<c025f5db>] __do_softirq+0x114/0x318
[    8.215798] irq event stamp: 2152
[    8.215803] hardirqs last  enabled at (2149): [<c1542a61>] _raw_spin_unlock_irq+0x5a/0xba
[    8.215808] hardirqs last disabled at (2150): [<c066e858>] blk_flush_plug_list+0x1ff/0x447
[    8.215813] softirqs last  enabled at (2152): [<c068e196>] __cfq_set_active_queue+0x110/0x27d
[    8.215818] softirqs last disabled at (2151): [<c068e15f>] __cfq_set_active_queue+0xd9/0x27d
[    8.215820] 
[    8.215820] other info that might help us debug this:
[    8.215824]  Possible unsafe locking scenario:
[    8.215824] 
[    8.215825]        CPU0
[    8.215827]        ----
[    8.215830]   lock(&(&q->__queue_lock)->rlock);
[    8.215831]   <Interrupt>
[    8.215833]     lock(&(&q->__queue_lock)->rlock);
[    8.215834] 
[    8.215834]  *** DEADLOCK ***
[    8.215834] 
[    8.215837] 1 lock held by blkid/287:
[    8.215844]  #0:  (&(&q->__queue_lock)->rlock){+.?...}, at: [<c066e8fd>] blk_flush_plug_list+0x2a4/0x447
[    8.215846] 
[    8.215846] stack backtrace:
[    8.215849] CPU: 0 PID: 287 Comm: blkid Tainted: G        W    3.12.0-10878-g2c57502 #109
[    8.215851] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    8.215859]  00000000 c53a5b78 c152b622 c53a5b98 c15263b3 c1a4e107 c1a4dedf c1a4ed62
[    8.215867]  00000006 c535a8b0 00000040 c53a5bc0 c02a5d9e 00000006 00000000 c02a2e66
[    8.215875]  00000004 c535a530 c535a8b0 c535a530 00000000 c53a5be0 c02a92e0 e2d05017
[    8.215876] Call Trace:
[    8.215881]  [<c152b622>] dump_stack+0x40/0x5e
[    8.215891]  [<c15263b3>] print_usage_bug+0x493/0x4ad
[    8.215896]  [<c02a5d9e>] mark_lock+0x575/0xa2e
[    8.215901]  [<c02a2e66>] ? print_irq_inversion_bug+0x374/0x374
[    8.215905]  [<c02a92e0>] mark_held_locks+0x163/0x199
[    8.215910]  [<c025feb5>] ? local_bh_enable+0x1c2/0x20e
[    8.215915]  [<c02a9681>] trace_hardirqs_on_caller+0x36b/0x3b1
[    8.215920]  [<c068e196>] ? __cfq_set_active_queue+0x110/0x27d
[    8.215924]  [<c02a96ee>] trace_hardirqs_on+0x27/0x37
[    8.215928]  [<c025feb5>] local_bh_enable+0x1c2/0x20e
[    8.215932]  [<c068e196>] __cfq_set_active_queue+0x110/0x27d
[    8.215937]  [<c068002f>] ? add_disk+0x12c/0x781
[    8.215941]  [<c06907a9>] ? cfq_resort_rr_list+0x49/0x5b
[    8.215945]  [<c0690899>] ? cfq_add_cfqq_rr+0xde/0xf3
[    8.215949]  [<c0690c67>] ? cfq_update_idle_window.isra.78+0xf2/0x1f4
[    8.215953]  [<c0294d19>] ? sched_clock_cpu+0x1c4/0x1f9
[    8.215958]  [<c029fb08>] ? trace_hardirqs_off+0x27/0x37
[    8.215962]  [<c0294e4d>] ? local_clock+0xff/0x176
[    8.215966]  [<c06951f7>] cfq_dispatch_requests+0xb92/0x11b0
[    8.215970]  [<c024812f>] ? kvm_clock_read+0x30/0x55
[    8.215975]  [<c020f559>] ? sched_clock+0x3e/0x50
[    8.215979]  [<c06931f4>] ? cfq_insert_request+0x3c9/0x869
[    8.215984]  [<c029fb08>] ? trace_hardirqs_off+0x27/0x37
[    8.215988]  [<c02a77fb>] ? __lock_acquire+0x15a4/0x16ca
[    8.215992]  [<c06aec9f>] ? list_sort+0x1fb/0x253
[    8.215997]  [<c066e10c>] blk_peek_request+0x9e/0x31a
[    8.216001]  [<c0b523bf>] scsi_request_fn+0x62/0x89e
[    8.216006]  [<c066e8fd>] ? blk_flush_plug_list+0x2a4/0x447
[    8.216010]  [<c0668eec>] __blk_run_queue+0x55/0x6c
[    8.216015]  [<c066c588>] queue_unplugged.isra.29+0x40/0x6a
[    8.216019]  [<c066e9bf>] blk_flush_plug_list+0x366/0x447
[    8.216024]  [<c066eabb>] blk_finish_plug+0x1b/0x51
[    8.216029]  [<c03275e3>] __do_page_cache_readahead+0x314/0x364
[    8.216035]  [<c032772f>] force_page_cache_readahead+0x9e/0xea
[    8.216040]  [<c0327d36>] page_cache_sync_readahead+0x5d/0x91
[    8.216044]  [<c0319608>] generic_file_aio_read+0x393/0xb7e

git bisect start v3.13 v3.12 --
git bisect good 3bad8bb5cd3048a67df43ac6b1e2f191f19d9ff0  # 05:30     20+      0  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
git bisect  bad 754ac45745711a7ce0067087e5b55a9c277952ad  # 05:52      0-      4  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect good d644c026e6b21959af1f86b15206ae26c64c2e51  # 06:06     20+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
git bisect  bad 002acf1fc16cf60e60345bd68e03734628505b83  # 06:19      0-      2  Merge tag 'pm-3.13-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect good da1965d353c7266fce4fe6c658f2096c88a8bebc  # 06:31     20+      0  Merge tag 'pinctrl-v3.13-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
git bisect good ef1e4e32d595d3e6c9a6d3d2956f087d5886c5e5  # 06:45     20+      0  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect  bad 5ee540613db504a10e15fafaf4c08cac96aa1823  # 06:58      0-      3  Merge branch 'for-linus' of git://git.kernel.dk/linux-block
git bisect good 29be6345bbaec8502a70c4e2204d5818b48c4e8f  # 07:06     20+      0  Merge tag 'nfs-for-3.13-3' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
git bisect  bad e345d767f6530ec9cb0aabab7ea248072a9c6975  # 07:26      0-      5  Merge branch 'stable/for-jens-3.13-take-two' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip into for-linus
git bisect  bad c170bbb45febc03ac4d34ba2b8bb55e06104b7e7  # 07:35      0-      3  block: submit_bio_wait() conversions
git bisect  bad 2c575026fae6e63771bd2a4c1d407214a8096a89  # 07:43      0-      4  Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
# first bad commit: [2c575026fae6e63771bd2a4c1d407214a8096a89] Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
git bisect good 82023bb7f75b0052f40d3e74169d191c3e4e6286  # 08:02     60+      0  Merge tag 'pm+acpi-2-3.13-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect  bad 0ffb2fe7b9c30082876fa3a17da018bf0632cf03  # 08:02      0-     19  Add linux-next specific files for 20140306
git bisect good 538959a390127125581a4fa2f2f7e035b82fa421  # 08:25     60+     37  Revert "Update of blkg_stat and blkg_rwstat may happen in bh context."
git bisect  bad b053940df41808f0f27568eb36820d10a8a987f8  # 08:34      0-      2  ARC: Use correct PTAG register for icache flush
git bisect  bad 1b0a7e3263168a06d3858798e48c5a21d1c78d3c  # 08:44      1-     16  Add linux-next specific files for 20140307

Thanks,
Fengguang

--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-xian-9:20140307071216:i386-randconfig-x1-03070634:3.14.0-rc5-next-20140306-06952-g0ffb2fe:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc5-next-20140306-06952-g0ffb2fe (kbuil=
d@xian) (gcc version 4.8.1 (Debian 4.8.1-8) ) #2 Fri Mar 7 06:57:59 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x03ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
[    0.000000]  [mem 0x0f800000-0x0fbfffff] page 4k
[    0.000000] BRK [0x03bd8000, 0x03bd8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
[    0.000000]  [mem 0x08000000-0x0f7fffff] page 4k
[    0.000000] BRK [0x03bd9000, 0x03bd9fff] PGTABLE
[    0.000000] BRK [0x03bda000, 0x03bdafff] PGTABLE
[    0.000000] BRK [0x03bdb000, 0x03bdbfff] PGTABLE
[    0.000000] BRK [0x03bdc000, 0x03bdcfff] PGTABLE
[    0.000000] BRK [0x03bdd000, 0x03bddfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 198f000, base 00000000=
, limit 00000000)
[    0.000000] cma: CMA: reserved 28 MiB at 0dc00000
[    0.000000] RAMDISK: [mem 0x0fcbd000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0FFFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x0FFFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x0FFFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x0FFFFF40 000040
[    0.000000] ACPI: SSDT 0x0FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x0FFFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x0FFFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2b30a40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-x1-03070634/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3a=
17da018bf0632cf03-20140307070549-7-xian branch=3Dnext/master BOOT_IMAGE=3D/=
kernel/i386-randconfig-x1-03070634/0ffb2fe7b9c30082876fa3a17da018bf0632cf03=
/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 182072K/261744K available (20230K kernel code, 4186K=
 rwdata, 7424K rodata, 808K init, 12124K bss, 79672K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc2f26000 - 0xc2ff0000   ( 808 kB)
[    0.000000]       .data : 0xc23c1bdc - 0xc2f25980   (11663 kB)
[    0.000000]       .text : 0xc1000000 - 0xc23c1bdc   (20230 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dcd80a000 soft=3Dcd80c000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] ACPI: setting ELCR to 0200 (from 0c00)
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc5-next-20140306-06952-g0ffb2fe (kbuil=
d@xian) (gcc version 4.8.1 (Debian 4.8.1-8) ) #2 Fri Mar 7 06:57:59 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x03ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
[    0.000000]  [mem 0x0f800000-0x0fbfffff] page 4k
[    0.000000] BRK [0x03bd8000, 0x03bd8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
[    0.000000]  [mem 0x08000000-0x0f7fffff] page 4k
[    0.000000] BRK [0x03bd9000, 0x03bd9fff] PGTABLE
[    0.000000] BRK [0x03bda000, 0x03bdafff] PGTABLE
[    0.000000] BRK [0x03bdb000, 0x03bdbfff] PGTABLE
[    0.000000] BRK [0x03bdc000, 0x03bdcfff] PGTABLE
[    0.000000] BRK [0x03bdd000, 0x03bddfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 198f000, base 00000000=
, limit 00000000)
[    0.000000] cma: CMA: reserved 28 MiB at 0dc00000
[    0.000000] RAMDISK: [mem 0x0fcbd000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0FFFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x0FFFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x0FFFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x0FFFFF40 000040
[    0.000000] ACPI: SSDT 0x0FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x0FFFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x0FFFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2b30a40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-x1-03070634/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3a=
17da018bf0632cf03-20140307070549-7-xian branch=3Dnext/master BOOT_IMAGE=3D/=
kernel/i386-randconfig-x1-03070634/0ffb2fe7b9c30082876fa3a17da018bf0632cf03=
/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 182072K/261744K available (20230K kernel code, 4186K=
 rwdata, 7424K rodata, 808K init, 12124K bss, 79672K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc2f26000 - 0xc2ff0000   ( 808 kB)
[    0.000000]       .data : 0xc23c1bdc - 0xc2f25980   (11663 kB)
[    0.000000]       .text : 0xc1000000 - 0xc23c1bdc   (20230 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dcd80a000 soft=3Dcd80c000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] ACPI: setting ELCR to 0200 (from 0c00)
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
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.992 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5785.98 Bogo=
MIPS (lpj=3D2892992)
[    0.004016] pid_max: default: 32768 minimum: 301
[    0.005291] Mount-cache hash table entries: 512
[    0.009421] Initializing cgroup subsys freezer
[    0.011018] Initializing cgroup subsys net_cls
[    0.012020] Initializing cgroup subsys blkio
[    0.013020] Initializing cgroup subsys net_prio
[    0.014238] mce: CPU supports 10 MCE banks
[    0.015094] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015094] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.015094] tlb_flushall_shift: 6
[    0.016020] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.035423] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.046252] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.051283] devtmpfs: initialized
[    0.054278] gcov: version magic: 0x3430382a
[    0.069026] prandom: seed boundary self test passed
[    0.074145] prandom: 100 self tests passed
[    0.075017] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.076014] pinctrl core: initialized pinctrl subsystem
[    0.081247] NET: Registered protocol family 16
[    0.087035] EISA bus registered
[    0.089012] cpuidle: using governor ladder
[    0.090018] cpuidle: using governor menu
[    0.093332] ACPI: bus type PCI registered
[    0.094020] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.095446] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.172495] ACPI: Added _OSI(Module Device)
[    0.173018] ACPI: Added _OSI(Processor Device)
[    0.174020] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.175017] ACPI: Added _OSI(Processor Aggregator Device)
[    0.204204] ACPI: Interpreter enabled
[    0.205024] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140214/hwxface-580)
[    0.208030] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140214/hwxface-580)
[    0.211106] ACPI: (supports S0 S3 S5)
[    0.212013] ACPI: Using PIC for interrupt routing
[    0.214011] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.250236] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.251032] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.252207] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.260893] acpiphp: Slot [3] registered
[    0.261181] acpiphp: Slot [4] registered
[    0.262230] acpiphp: Slot [5] registered
[    0.263144] acpiphp: Slot [6] registered
[    0.264166] acpiphp: Slot [7] registered
[    0.266020] acpiphp: Slot [8] registered
[    0.268048] acpiphp: Slot [9] registered
[    0.269196] acpiphp: Slot [10] registered
[    0.270146] acpiphp: Slot [11] registered
[    0.272088] acpiphp: Slot [12] registered
[    0.273274] acpiphp: Slot [13] registered
[    0.274160] acpiphp: Slot [14] registered
[    0.276208] acpiphp: Slot [15] registered
[    0.277142] acpiphp: Slot [16] registered
[    0.278144] acpiphp: Slot [17] registered
[    0.279156] acpiphp: Slot [18] registered
[    0.281137] acpiphp: Slot [19] registered
[    0.282204] acpiphp: Slot [20] registered
[    0.283186] acpiphp: Slot [21] registered
[    0.284208] acpiphp: Slot [22] registered
[    0.285148] acpiphp: Slot [23] registered
[    0.286183] acpiphp: Slot [24] registered
[    0.287144] acpiphp: Slot [25] registered
[    0.288164] acpiphp: Slot [26] registered
[    0.289162] acpiphp: Slot [27] registered
[    0.290141] acpiphp: Slot [28] registered
[    0.291190] acpiphp: Slot [29] registered
[    0.292188] acpiphp: Slot [30] registered
[    0.293144] acpiphp: Slot [31] registered
[    0.294036] PCI host bridge to bus 0000:00
[    0.295026] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.296017] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.297019] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.298022] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.299020] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.301040] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.305055] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.308533] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.316473] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.321477] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.324040] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.325034] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.328426] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.332000] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.334102] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.347103] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.351141] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.354018] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.357000] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.363884] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.366034] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.368906] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.371000] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.381738] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.383890] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.386000] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.398217] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.400901] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.401000] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.412304] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.414000] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.416038] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.429156] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.431877] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.433890] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.443508] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.447000] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.448882] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.459474] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.460956] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.471078] pci_bus 0000:00: on NUMA node 0
[    0.476755] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.480264] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.483177] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.486620] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.489576] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.493000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.495388] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.496035] vgaarb: loaded
[    0.497016] vgaarb: bridge control possible 0000:00:02.0
[    0.500645] SCSI subsystem initialized
[    0.502196] libata version 3.00 loaded.
[    0.503342] ACPI: bus type USB registered
[    0.504265] usbcore: registered new interface driver usbfs
[    0.505175] usbcore: registered new interface driver hub
[    0.506172] usbcore: registered new device driver usb
[    0.508351] pps_core: LinuxPPS API ver. 1 registered
[    0.509016] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.510066] PTP clock support registered
[    0.512111] wmi: Mapper loaded
[    0.513143] PCI: Using ACPI for IRQ routing
[    0.514019] PCI: pci_cache_line_size set to 64 bytes
[    0.515387] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.516040] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.520147] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.522013] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.525094] Switched to clocksource kvm-clock
[    0.527388] pnp: PnP ACPI init
[    0.528528] ACPI: bus type PNP registered
[    0.530113] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.532327] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.534570] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.536455] pnp 00:03: [dma 2]
[    0.537810] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.539763] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.542223] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.545038] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.547517] pnp: PnP ACPI: found 7 devices
[    0.548965] ACPI: bus type PNP unregistered
[    0.600677] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.602340] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.603817] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.605532] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.607424] NET: Registered protocol family 2
[    0.609892] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    0.611903] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.614398] TCP: Hash tables configured (established 2048 bind 2048)
[    0.616224] TCP: reno registered
[    0.617583] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    0.619225] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    0.622009] NET: Registered protocol family 1
[    0.623353] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.624898] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.626858] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.628485] pci 0000:00:02.0: Boot video device
[    0.644423] PCI: CLS 0 bytes, default 64
[    0.646656] Unpacking initramfs...
[    0.897083] debug: unmapping init [mem 0xcfcbd000-0xcffeffff]
[    0.997726] DMA-API: preallocated 65536 debug entries
[    1.006888] DMA-API: debugging enabled by kernel config
[    1.015653] apm: BIOS not found.
[    1.017179] Scanning for low memory corruption every 60 seconds
[    1.020113] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    1.029006] Initializing RT-Tester: OK
[    1.034454] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.046758] spin_lock-torture: Creating torture_shuffle task
[    1.053488] spin_lock-torture: Creating torture_stutter task
[    1.054972] spin_lock-torture: torture_shuffle task started
[    1.064518] spin_lock-torture: Creating lock_torture_writer task
[    1.066221] spin_lock-torture: torture_stutter task started
[    1.067783] spin_lock-torture: Creating lock_torture_writer task
[    1.069768] spin_lock-torture: lock_torture_writer task started
[    1.071645] spin_lock-torture: Creating lock_torture_stats task
[    1.083394] spin_lock-torture: lock_torture_writer task started
[    1.086745] futex hash table entries: 256 (order: 1, 12288 bytes)
[    1.088499] Initialise system trusted keyring
[    1.090093] audit: initializing netlink subsys (disabled)
[    1.102630] audit: type=3D2000 audit(1394147458.814:1): initialized
[    2.394537] spin_lock-torture: lock_torture_stats task started
[    2.406864] DLM installed
[    2.408666] fuse init (API version 7.22)
[    2.410159] JFS: nTxBlock =3D 1646, nTxLock =3D 13171
[    2.427059] SGI XFS with ACLs, security attributes, large block/inode nu=
mbers, no debug enabled
[    2.430550] ceph: loaded (mds proto 32)
[    2.431839] msgmni has been set to 411
[    2.445454] tsc: Refined TSC clocksource calibration: 2892.983 MHz
[    2.449914] Key type asymmetric registered
[    2.453046] Asymmetric key parser 'x509' registered
[    2.454465] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    2.463435] io scheduler noop registered
[    2.465025] io scheduler cfq registered (default)
[    2.483073] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    2.484693] crc32: self tests passed, processed 225944 bytes in 10936470=
 nsec
[    2.487138] crc32c: CRC_LE_BITS =3D 8
[    2.493136] crc32c: self tests passed, processed 225944 bytes in 445390 =
nsec
[    2.949653] crc32_combine: 8373 self tests passed
[    3.431835] crc32c_combine: 8373 self tests passed
[    3.447398] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.450651] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    3.454199] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.465415] vmlfb: initializing
[    3.473843] Could not find Carillo Ranch MCH device.
[    3.477222] hgafb: HGA card not detected.
[    3.482875] hgafb: probe of hgafb.0 failed with error -22
[    3.487195] isapnp: Scanning for PnP cards...
[    4.053892] isapnp: No Plug & Play device found
[    4.056839] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.083373] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.094838] serial: Freescale lpuart driver
[    4.099887] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.102354] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.104589] Hangcheck: Using getrawmonotonic().
[    4.107241] [drm] Initialized drm 1.1.0 20060810
[    4.108639] [drm] radeon kernel modesetting enabled.
[    4.111421] dummy-irq: no IRQ given.  Use irq=3DN
[    4.113622] lkdtm: No crash points registered, enable through debugfs
[    4.115349] Phantom Linux Driver, version n0.9.8, init OK
[    4.116852] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    4.120269] Guest personality initialized and is inactive
[    4.121898] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D59)
[    4.124334] Initialized host personality
[    4.127379] usbcore: registered new interface driver viperboard
[    4.129053] Loading iSCSI transport class v2.0-870.
[    4.132856] fnic: Cisco FCoE HBA Driver, ver 1.5.0.45
[    4.135411] fnic: Successfully Initialized Trace Buffer
[    4.138182] NCR53c406a: no available ports found
[    4.144559] sym53c416.c: Version 1.0.0-ac
[    4.150510] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.12-k.
[    4.159482] iscsi: registered transport (qla4xxx)
[    4.166226] QLogic iSCSI HBA Driver
[    4.195244] Failed initialization of WD-7000 SCSI card!
[    4.197367] DC390: clustering now enabled by default. If you get problem=
s load
[    4.200890]        with "disable_clustering=3D1" and report to maintaine=
rs
[    4.205561] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    4.210490] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    4.218622] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    4.225181] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    4.228494] RocketRAID 3xxx/4xxx Controller driver v1.8
[    4.230991] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    4.232886] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    4.235312] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    4.237079] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    4.238682] iscsi: registered transport (cxgb4i)
[    4.240216] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    4.242477] SCSI Media Changer driver v0.25=20
[    4.278187] scsi_debug: host protection
[    4.280445] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    4.285307] ata_piix 0000:00:01.1: version 2.13
[    4.288162] cma: dma_alloc_from_contiguous(cma c38550e4, count 1, align =
0)
[    4.297880] cma: dma_alloc_from_contiguous(): returned cfa65000
[    4.299904] cma: dma_alloc_from_contiguous(cma c38550e4, count 1, align =
0)
[    4.303843] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    4.306466] cma: dma_alloc_from_contiguous(): returned cfa65024
[    4.314152] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.317341] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    4.320495] scsi1 : ata_piix
[    4.322509] scsi2 : ata_piix
[    4.324135] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[    4.326118] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[    4.333244] sd 0:0:0:0: [sda] Write Protect is off
[    4.334654] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    4.346254] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    4.349166] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    4.359164] libphy: Fixed MDIO Bus: probed
[    4.360742] arcnet loaded.
[    4.361742] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    4.364328] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.19 (Decemb=
er 19, 2013)
[    4.367159] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[    4.371231] Brocade 10G Ethernet driver - version: 3.2.23.0
[    4.373659] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[    4.376056] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    4.377780] i40e: Intel(R) Ethernet Connection XL710 Network Driver - ve=
rsion 0.3.32-k
[    4.380099] i40e: Copyright (c) 2013 - 2014 Intel Corporation.
[    4.382045] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    4.383854] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    4.386645] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    4.388906] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256) (6 bit encapsulation enabled).
[    4.391536] CSLIP: code copyright 1989 Regents of the University of Cali=
fornia.
[    4.394752] hdlc: HDLC support module revision 1.22
[    4.396451] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    4.398116] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    4.400164] usbcore: registered new interface driver kaweth
[    4.401774] usbcore: registered new interface driver r8152
[    4.405573] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    4.407341] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    4.409501] usbcore: registered new interface driver cdc_acm
[    4.411113] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    4.413488] usbcore: registered new interface driver cdc_wdm
[    4.415266] usbcore: registered new interface driver usb-storage
[    4.417854] usbcore: registered new interface driver ums-cypress
[    4.419552] usbcore: registered new interface driver ums-datafab
[    4.421286] usbcore: registered new interface driver ums-isd200
[    4.423066] usbcore: registered new interface driver ums-jumpshot
[    4.424758] usbcore: registered new interface driver ums-onetouch
[    4.426527] usbcore: registered new interface driver ums-realtek
[    4.428279] usbcore: registered new interface driver ums-sddr09
[    4.430023] usbcore: registered new interface driver rio500
[    4.431668] usbcore: registered new interface driver usbtest
[    4.433329] usbcore: registered new interface driver usbsevseg
[    4.435477] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.439349] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.440883] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.443607] usbcore: registered new interface driver aiptek
[    4.445269] usbcore: registered new interface driver wacom
[    4.447290] mk712: device not present
[    4.448642] usbcore: registered new interface driver sur40
[    4.450692] rtc_cmos 00:00: RTC can wake from S4
[    4.452771] rtc (null): alarm rollover: day
[    4.457182] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    4.479482] rtc rtc0: rtc_cmos: dev (254:0)
[    4.480822] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    4.482652] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    4.488421] pps pps0: new PPS source ktimer
[    4.489855] pps pps0: ktimer PPS source registered
[    4.492407] Driver for 1-wire Dallas network protocol.
[    4.495559] f71882fg: Not a Fintek device
[    4.496833] f71882fg: Not a Fintek device
[    4.500232] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    4.502493] sdhci: Secure Digital Host Controller Interface driver
[    4.504220] sdhci: Copyright(c) Pierre Ossman
[    4.505679] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    4.507353] wbsd: Copyright(c) Pierre Ossman
[    4.508894] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    4.510343]  sda: unknown partition table
[    4.512804] usbcore: registered new interface driver vub300
[    4.514509] usbcore: registered new interface driver ushc
[    4.516073] sdhci-pltfm: SDHCI platform and OF driver helper
[    4.518435] ledtrig-cpu: registered to indicate activity on CPUs
[    4.521340] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    4.527098] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    4.529521] hidraw: raw HID events driver (C) Jiri Kosina
[    4.533076] usbcore: registered new interface driver usbhid
[    4.534674] usbhid: USB HID core driver
[    4.536439] usbip_core: usbip_core_init:787: USB/IP Core v1.0.0
[    4.538366] vhci_hcd: vhci_hcd_probe:997: name vhci_hcd id -1
[    4.540135] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    4.541918] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 1
[    4.543773] vhci_hcd: vhci_start:881: enter vhci_start
[    4.549542] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    4.551409] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    4.553673] usb usb1: Product: USB/IP Virtual Host Controller
[    4.555355] usb usb1: Manufacturer: Linux 3.14.0-rc5-next-20140306-06952=
-g0ffb2fe vhci_hcd
[    4.558892] usb usb1: SerialNumber: vhci_hcd
[    4.562889] hub 1-0:1.0: USB hub found
[    4.564290] vhci_hcd: vhci_hub_control:244: typeReq a006 wValue 2900 wIn=
dex 0
[    4.566470] vhci_hcd: vhci_hub_control:302:  GetHubDescriptor
[    4.568151] vhci_hcd: vhci_hub_control:395: port -1
[    4.569628] vhci_hcd: vhci_hub_control:402:  bye
[    4.571146] hub 1-0:1.0: 8 ports detected
[    4.572669] vhci_hcd: vhci_hub_control:244: typeReq a000 wValue 0 wIndex=
 0
[    4.574549] vhci_hcd: vhci_hub_control:306:  GetHubStatus
[    4.576098] vhci_hcd: vhci_hub_control:395: port -1
[    4.577549] vhci_hcd: vhci_hub_control:402:  bye
[    4.580550] ata2.01: NODEV after polling detection
[    4.582404] ata2.00: ATAPI: QEMU DVD-ROM, 1.5.0, max UDMA/100
[    4.584751] ata2.00: configured for MWDMA2
[    4.586604] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.588622] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 1
[    4.590423] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[    4.592239] vhci_hcd: vhci_hub_control:395: port 0
[    4.593614] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    4.596824] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.598336] vhci_hcd: dump_port_status_diff:119:=20
[    4.599679] vhci_hcd: vhci_hub_control:402:  bye
[    4.602354] scsi 2:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
5. PQ: 0 ANSI: 5
[    4.606109] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 2
[    4.607883] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[    4.609595] vhci_hcd: vhci_hub_control:395: port 1
[    4.611038] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    4.613391] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.614907] vhci_hcd: dump_port_status_diff:119:=20
[    4.616331] vhci_hcd: vhci_hub_control:402:  bye
[    4.617732] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 3
[    4.619571] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[    4.621635] vhci_hcd: vhci_hub_control:395: port 2
[    4.623114] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    4.625480] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.627029] vhci_hcd: dump_port_status_diff:119:=20
[    4.628391] vhci_hcd: vhci_hub_control:402:  bye
[    4.632405] sr0: scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    4.634061] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.637050] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    4.639361] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    4.641184] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 4
[    4.643034] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[    4.644717] vhci_hcd: vhci_hub_control:395: port 3
[    4.646129] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    4.648470] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.650024] vhci_hcd: dump_port_status_diff:119:=20
[    4.651398] vhci_hcd: vhci_hub_control:402:  bye
[    4.654262] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 5
[    4.656118] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[    4.658744] vhci_hcd: vhci_hub_control:395: port 4
[    4.660199] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    4.662587] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.664138] vhci_hcd: dump_port_status_diff:119:=20
[    4.665576] vhci_hcd: vhci_hub_control:402:  bye
[    4.667056] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 6
[    4.668868] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[    4.670600] vhci_hcd: vhci_hub_control:395: port 5
[    4.672046] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    4.674418] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.676034] vhci_hcd: dump_port_status_diff:119:=20
[    4.677422] vhci_hcd: vhci_hub_control:402:  bye
[    4.678872] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 7
[    4.680728] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[    4.683382] vhci_hcd: vhci_hub_control:395: port 6
[    4.684792] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    4.687228] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.688712] vhci_hcd: dump_port_status_diff:119:=20
[    4.690113] vhci_hcd: vhci_hub_control:402:  bye
[    4.691573] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 8
[    4.693420] vhci_hcd: vhci_hub_control:381:  SetPortFeature: default 8
[    4.695209] vhci_hcd: vhci_hub_control:395: port 7
[    4.696655] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    4.699103] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.700570] vhci_hcd: dump_port_status_diff:119:=20
[    4.702045] vhci_hcd: vhci_hub_control:402:  bye
[    4.704149] vhci_hcd: vhci_hcd_probe:1025: bye
[    4.705502] vhci_hcd: vhci_hcd_init:1147: USB/IP 'Virtual' Host Controll=
er (VHCI) Driver v1.0.0
[    4.709142] usbcore: registered new device driver usbip-host
[    4.710736] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    4.712610] usbcore: registered new interface driver tranzport
[    4.714400] usbcore: registered new interface driver alphatrack
[    4.716567] Loading crystalhd 0.9.27
[    4.719081] ozwpan ozwpan: Ozmo Devices WPAN
[    4.720388] ozwpan ozwpan: new USB bus registered, assigned bus number 2
[    4.722522] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    4.724366] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    4.726510] usb usb2: Product: Ozmo Devices WPAN
[    4.727859] usb usb2: Manufacturer: Linux 3.14.0-rc5-next-20140306-06952=
-g0ffb2fe Ozmo WPAN
[    4.731161] usb usb2: SerialNumber: ozwpan
[    4.733649] hub 2-0:1.0: USB hub found
[    4.734910] hub 2-0:1.0: 8 ports detected
[    4.737735] usbcore: registered new interface driver gdm_wimax
[    4.740183] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[    4.741690] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[    4.746262] NET: Registered protocol family 26
[    4.747646] netem: version 1.3
[    4.748753] Netfilter messages via NETLINK v0.30.
[    4.750208] nfnl_acct: registering with nfnetlink.
[    4.751828] nf_conntrack version 0.5.0 (3292 buckets, 13168 max)
[    4.755250] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    4.757046] nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilte=
r.org>
[    4.759803] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.761544] arp_tables: (C) 2002 David S. Miller
[    4.763023] TCP: cubic registered
[    4.764173] NET: Registered protocol family 17
[    4.765620] NET: Registered protocol family 15
[    4.767059] NET: Registered protocol family 9
[    4.768376] X25: Linux Version 0.2
[    4.769621] NET: Registered protocol family 35
[    4.772552] DCCP: Activated CCID 2 (TCP-like)
[    4.773903] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    4.776613] sctp: Hash tables configured (established 1638 bind 1489)
[    4.779522] Key type dns_resolver registered
[    4.780877] Key type ceph registered
[    4.782153] libceph: loaded (mon/osd proto 15/24)
[    4.783859] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[    4.786192] openvswitch: Open vSwitch switching datapath
[    4.790528] Loading compiled-in X.509 certificates
[    4.801771] Loaded X.509 cert 'Magrathea: Glacier signing key: 6d4737240=
0b9f9f1f33c078f73d95763d3c92984'
[    4.805294] registered taskstats version 1
[    4.809109] Key type trusted registered
[    4.812313] rtc_cmos 00:00: setting system clock to 2014-03-07 07:11:02 =
UTC (1394176262)
[    4.814663] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    4.818825] debug: unmapping init [mem 0xc2f26000-0xc2feffff]
[    4.836628] Write protecting the kernel text: 20232k
[    4.838483] Write protecting the kernel read-only data: 7476k
[    4.851296] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 1
[    4.853328] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 1
[    4.855026] vhci_hcd: vhci_hub_control:352:  GetPortStatus bye 100 0
[    4.856856] vhci_hcd: vhci_hub_control:395: port 0
[    4.859272] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    4.861761] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.863316] vhci_hcd: dump_port_status_diff:119:=20
[    4.864674] vhci_hcd: vhci_hub_control:402:  bye
[    4.866156] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 2
[    4.867974] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 2
[    4.869550] vhci_hcd: vhci_hub_control:352:  GetPortStatus bye 100 0
[    4.871323] vhci_hcd: vhci_hub_control:395: port 1
[    4.872764] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    4.875214] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.876693] vhci_hcd: dump_port_status_diff:119:=20
[    4.878180] vhci_hcd: vhci_hub_control:402:  bye
[    4.887124] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 3
[    4.889067] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 3
[    4.890763] vhci_hcd: vhci_hub_control:352:  GetPortStatus bye 100 0
[    4.892463] vhci_hcd: vhci_hub_control:395: port 2
[    4.893865] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    4.896321] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.897866] vhci_hcd: dump_port_status_diff:119:=20
[    4.899327] vhci_hcd: vhci_hub_control:402:  bye
[    4.909100] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 4
[    4.910892] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 4
[    4.912514] vhci_hcd: vhci_hub_control:352:  GetPortStatus bye 100 0
[    4.914250] vhci_hcd: vhci_hub_control:395: port 3
[    4.915609] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    4.918014] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.919470] vhci_hcd: dump_port_status_diff:119:=20
[    4.920832] vhci_hcd: vhci_hub_control:402:  bye
[    4.925063] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 5
[    4.926837] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 5
[    4.928515] vhci_hcd: vhci_hub_control:352:  GetPortStatus bye 100 0
[    4.931128] vhci_hcd: vhci_hub_control:395: port 4
[    4.932558] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    4.935057] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.936542] vhci_hcd: dump_port_status_diff:119:=20
[    4.938045] vhci_hcd: vhci_hub_control:402:  bye
[    4.945113] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 6
[    4.947025] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 6
[    4.948738] vhci_hcd: vhci_hub_control:352:  GetPortStatus bye 100 0
[    4.950510] vhci_hcd: vhci_hub_control:395: port 5
[    4.951899] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    4.954553] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.956096] vhci_hcd: dump_port_status_diff:119:=20
[    4.958369] vhci_hcd: vhci_hub_control:402:  bye
[    4.974076] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 7
[    4.975897] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 7
[    4.977557] vhci_hcd: vhci_hub_control:352:  GetPortStatus bye 100 0
[    4.979299] vhci_hcd: vhci_hub_control:395: port 6
[    4.980653] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    4.984896] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.987476] vhci_hcd: dump_port_status_diff:119:=20
[    4.989849] vhci_hcd: vhci_hub_control:402:  bye
[    5.009209] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 8
[    5.013121] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 8
[    5.015764] vhci_hcd: vhci_hub_control:352:  GetPortStatus bye 100 0
[    5.023524] vhci_hcd: vhci_hub_control:395: port 7
[    5.025020] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    5.027354] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.029897] vhci_hcd: dump_port_status_diff:119:=20
[    5.034198] vhci_hcd: vhci_hub_control:402:  bye
[    5.932864] ------------[ cut here ]------------
[    5.932976] WARNING: CPU: 0 PID: 298 at kernel/softirq.c:145 __local_bh_=
enable_ip+0xb3/0x202()
[    5.932976] Modules linked in:
[    5.932976] CPU: 0 PID: 298 Comm: edd_id Not tainted 3.14.0-rc5-next-201=
40306-06952-g0ffb2fe #2
[    5.932976] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.932976]  00000000 cb325bb8 c23a7ede cb325bd0 c105c706 c10631af c149b=
663 00000200
[    5.932976]  cb65e000 cb325be0 c105c772 00000009 00000000 cb325bf0 c1063=
1af 00000000
[    5.932976]  00000000 cb325c98 c149b6d5 00000001 00000000 cb65e400 cb7a6=
788 cb65e000
[    5.932976] Call Trace:
[    5.932976]  [<c23a7ede>] dump_stack+0x40/0x5e
[    5.932976]  [<c105c706>] warn_slowpath_common+0xa9/0xea
[    5.932976]  [<c10631af>] ? __local_bh_enable_ip+0xb3/0x202
[    5.932976]  [<c149b663>] ? __cfq_set_active_queue+0x112/0x2f1
[    5.932976]  [<c105c772>] warn_slowpath_null+0x2b/0x3d
[    5.932976]  [<c10631af>] __local_bh_enable_ip+0xb3/0x202
[    5.932976]  [<c149b6d5>] __cfq_set_active_queue+0x184/0x2f1
[    5.932976]  [<c149002f>] ? __delete_partition+0x8/0x30
[    5.932976]  [<c149e028>] ? cfq_resort_rr_list+0x49/0x5b
[    5.932976]  [<c149e178>] ? cfq_add_cfqq_rr+0x13e/0x153
[    5.932976]  [<c149e546>] ? cfq_update_idle_window.isra.78+0xf2/0x254
[    5.932976]  [<c10a5fb5>] ? lock_release_holdtime+0x147/0x194
[    5.932976]  [<c147a165>] ? blk_account_io_start+0x5f/0x271
[    5.932976]  [<c14a305a>] cfq_dispatch_requests+0xb92/0x1212
[    5.932976]  [<c104a30e>] ? kvm_clock_read+0x30/0x55
[    5.932976]  [<c100fd75>] ? sched_clock+0x3e/0x50
[    5.932976]  [<c14a0ed7>] ? cfq_insert_request+0x429/0x8c9
[    5.932976]  [<c10ad8ee>] ? __lock_acquire+0x157f/0x16a5
[    5.932976]  [<c14bcc61>] ? list_sort+0x1fb/0x253
[    5.932976]  [<c147ac0c>] blk_peek_request+0x9e/0x31a
[    5.932976]  [<c19860fb>] scsi_request_fn+0x62/0x8a1
[    5.932976]  [<c147b474>] ? blk_flush_plug_list+0x2a4/0x447
[    5.932976]  [<c147577c>] __blk_run_queue+0x55/0x6c
[    5.932976]  [<c1478f37>] queue_unplugged.isra.29+0x40/0x6a
[    5.932976]  [<c147b536>] blk_flush_plug_list+0x366/0x447
[    5.932976]  [<c147b632>] blk_finish_plug+0x1b/0x51
[    5.932976]  [<c112ed2d>] __do_page_cache_readahead+0x326/0x376
[    5.932976]  [<c112eed0>] ra_submit+0x25/0x38
[    5.932976]  [<c112f30b>] ondemand_readahead+0x428/0x43e
[    5.932976]  [<c112f478>] page_cache_sync_readahead+0x79/0x91
[    5.932976]  [<c1120744>] generic_file_aio_read+0x36e/0xb57
[    5.932976]  [<c11d1aff>] blkdev_aio_read+0x95/0xb1
[    5.932976]  [<c118021c>] do_sync_read+0x5a/0xab
[    5.932976]  [<c11801c2>] ? do_sync_write+0xab/0xab
[    5.932976]  [<c1180eb1>] vfs_read+0xe0/0x1fb
[    5.932976]  [<c11811d5>] SyS_read+0x73/0xe8
[    5.932976]  [<c23c04f8>] syscall_call+0x7/0xb
[    5.932976] ---[ end trace 5214646bee4f2aa1 ]---
[    5.932976]=20
[    5.932976] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    5.932976] [ INFO: inconsistent lock state ]
[    5.932976] 3.14.0-rc5-next-20140306-06952-g0ffb2fe #2 Tainted: G       =
 W  =20
[    5.932976] ---------------------------------
[    5.932976] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[    5.932976] edd_id/298 [HC0[0]:SC0[0]:HE1:SE1] takes:
[    5.932976]  (&(&q->__queue_lock)->rlock){?.-...}, at: [<c147b474>] blk_=
flush_plug_list+0x2a4/0x447
[    5.932976] {IN-HARDIRQ-W} state was registered at:
[    5.932976]   [<c10ad1c2>] __lock_acquire+0xe53/0x16a5
[    5.932976]   [<c10adafa>] lock_acquire+0xe6/0x147
[    5.932976]   [<c23beaf5>] _raw_spin_lock_irqsave+0xda/0x17d
[    5.932976]   [<c1bd5d77>] ata_qc_schedule_eh+0x80/0xcc
[    5.932976]   [<c1bc6854>] ata_qc_complete+0xae/0x34b
[    5.932976]   [<c1bdff70>] ata_hsm_qc_complete+0x12c/0x227
[    5.932976]   [<c1be0240>] ata_sff_hsm_move+0x1d5/0xe47
[    5.932976]   [<c1be1032>] __ata_sff_port_intr+0x180/0x19c
[    5.932976]   [<c1be1143>] ata_bmdma_port_intr+0xf5/0x185
[    5.932976]   [<c1be144f>] ata_bmdma_interrupt+0x27c/0x2c4
[    5.932976]   [<c10bf12f>] handle_irq_event_percpu+0x2f/0x2ae
[    5.932976]   [<c10bf3f6>] handle_irq_event+0x48/0x7b
[    5.932976]   [<c10c35fa>] handle_level_irq+0x134/0x170
[    5.932976] irq event stamp: 1304
[    5.932976] hardirqs last  enabled at (1301): [<c116f02e>] kmem_cache_al=
loc+0x221/0x2eb
[    5.932976] hardirqs last disabled at (1302): [<c147b3cf>] blk_flush_plu=
g_list+0x1ff/0x447
[    5.932976] softirqs last  enabled at (1304): [<c149b663>] __cfq_set_act=
ive_queue+0x112/0x2f1
[    5.932976] softirqs last disabled at (1303): [<c149b663>] __cfq_set_act=
ive_queue+0x112/0x2f1
[    5.932976]=20
[    5.932976] other info that might help us debug this:
[    5.932976]  Possible unsafe locking scenario:
[    5.932976]=20
[    5.932976]        CPU0
[    5.932976]        ----
[    5.932976]   lock(&(&q->__queue_lock)->rlock);
[    5.932976]   <Interrupt>
[    5.932976]     lock(&(&q->__queue_lock)->rlock);
[    5.932976]=20
[    5.932976]  *** DEADLOCK ***
[    5.932976]=20
[    5.932976] 1 lock held by edd_id/298:
[    5.932976]  #0:  (&(&q->__queue_lock)->rlock){?.-...}, at: [<c147b474>]=
 blk_flush_plug_list+0x2a4/0x447
[    5.932976]=20
[    5.932976] stack backtrace:
[    5.932976] CPU: 0 PID: 298 Comm: edd_id Tainted: G        W    3.14.0-r=
c5-next-20140306-06952-g0ffb2fe #2
[    5.932976] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.932976]  00000000 cb325b64 c23a7ede cb325b84 c23a31a1 c2908051 c2907=
e29 c2908c8d
[    5.932976]  00000002 cb2bf610 00000004 cb325bac c10abeb6 00000002 00000=
000 c10a8f69
[    5.932976]  00000000 cb2bf1e0 cb2bf610 cb2bf1e0 00000000 cb325bc8 c10af=
315 00000003
[    5.932976] Call Trace:
[    5.932976]  [<c23a7ede>] dump_stack+0x40/0x5e
[    5.932976]  [<c23a31a1>] print_usage_bug+0x493/0x4ad
[    5.932976]  [<c10abeb6>] mark_lock+0x575/0xa2e
[    5.932976]  [<c10a8f69>] ? print_irq_inversion_bug+0x374/0x374
[    5.932976]  [<c10af315>] mark_held_locks+0xa5/0xda
[    5.932976]  [<c10632b1>] ? __local_bh_enable_ip+0x1b5/0x202
[    5.932976]  [<c10af649>] trace_hardirqs_on_caller+0x2ff/0x3b1
[    5.932976]  [<c149b663>] ? __cfq_set_active_queue+0x112/0x2f1
[    5.932976]  [<c10af722>] trace_hardirqs_on+0x27/0x37
[    5.932976]  [<c10632b1>] __local_bh_enable_ip+0x1b5/0x202
[    5.932976]  [<c149b6d5>] __cfq_set_active_queue+0x184/0x2f1
[    5.932976]  [<c149002f>] ? __delete_partition+0x8/0x30
[    5.932976]  [<c149e028>] ? cfq_resort_rr_list+0x49/0x5b
[    5.932976]  [<c149e178>] ? cfq_add_cfqq_rr+0x13e/0x153
[    5.932976]  [<c149e546>] ? cfq_update_idle_window.isra.78+0xf2/0x254
[    5.932976]  [<c10a5fb5>] ? lock_release_holdtime+0x147/0x194
[    5.932976]  [<c147a165>] ? blk_account_io_start+0x5f/0x271
[    5.932976]  [<c14a305a>] cfq_dispatch_requests+0xb92/0x1212
[    5.932976]  [<c104a30e>] ? kvm_clock_read+0x30/0x55
[    5.932976]  [<c100fd75>] ? sched_clock+0x3e/0x50
[    5.932976]  [<c14a0ed7>] ? cfq_insert_request+0x429/0x8c9
[    5.932976]  [<c10ad8ee>] ? __lock_acquire+0x157f/0x16a5
[    5.932976]  [<c14bcc61>] ? list_sort+0x1fb/0x253
[    5.932976]  [<c147ac0c>] blk_peek_request+0x9e/0x31a
[    5.932976]  [<c19860fb>] scsi_request_fn+0x62/0x8a1
[    5.932976]  [<c147b474>] ? blk_flush_plug_list+0x2a4/0x447
[    5.932976]  [<c147577c>] __blk_run_queue+0x55/0x6c
[    5.932976]  [<c1478f37>] queue_unplugged.isra.29+0x40/0x6a
[    5.932976]  [<c147b536>] blk_flush_plug_list+0x366/0x447
[    5.932976]  [<c147b632>] blk_finish_plug+0x1b/0x51
[    5.932976]  [<c112ed2d>] __do_page_cache_readahead+0x326/0x376
[    5.932976]  [<c112eed0>] ra_submit+0x25/0x38
[    5.932976]  [<c112f30b>] ondemand_readahead+0x428/0x43e
[    5.932976]  [<c112f478>] page_cache_sync_readahead+0x79/0x91
[    5.932976]  [<c1120744>] generic_file_aio_read+0x36e/0xb57
[    5.932976]  [<c11d1aff>] blkdev_aio_read+0x95/0xb1
[    5.932976]  [<c118021c>] do_sync_read+0x5a/0xab
[    5.932976]  [<c11801c2>] ? do_sync_write+0xab/0xab
[    5.932976]  [<c1180eb1>] vfs_read+0xe0/0x1fb
[    5.932976]  [<c11811d5>] SyS_read+0x73/0xe8
[    5.932976]  [<c23c04f8>] syscall_call+0x7/0xb
[    6.509981] random: nonblocking pool is initialized
[    6.616105] ufs was compiled with read-only support, can't be mounted as=
 read-write
Kernel tests: Boot OK!
[   17.674769] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[   20.385706] Bits 55-60 of /proc/PID/pagemap entries are about to stop be=
ing page-shift some time soon. See the linux/Documentation/vm/pagemap.txt f=
or details.
[   64.634924] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[   76.020951] Unregister pv shared memory for cpu 0
[   76.021857] spin_lock-torture: Unscheduled system shutdown detected
[   76.021857] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   76.021857] reboot: Restarting system
[   76.021857] reboot: machine restart
Elapsed time: 50
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-x=
1-03070634/0ffb2fe7b9c30082876fa3a17da018bf0632cf03/vmlinuz-3.14.0-rc5-next=
-20140306-06952-g0ffb2fe -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,1=
15200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-x1-03070634/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3a=
17da018bf0632cf03-20140307070549-7-xian branch=3Dnext/master BOOT_IMAGE=3D/=
kernel/i386-randconfig-x1-03070634/0ffb2fe7b9c30082876fa3a17da018bf0632cf03=
/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe'  -initrd /kernel-tests/in=
itrd/yocto-minimal-i386.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De1000 -=
net user,vlan=3D1,hostfwd=3Dtcp::23381-:22 -boot order=3Dnc -no-reboot -wat=
chdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-yo=
cto-xian-9,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yoc=
to-xian-9,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yoct=
o-xian-9,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto=
-xian-9,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-=
xian-9,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-x=
ian-9,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-xian-9 -se=
rial file:/dev/shm/kboot/serial-yocto-xian-9 -daemonize -display none -moni=
tor null=20

--DKU6Jbt7q3WqK7+M
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-x1-03070634-0ffb2fe7b9c30082876fa3a17da018bf0632cf03-inconsistent----usage--98979.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDA5ZGUxOTIyNDJkODZlZGU0NDkxNDZhYzQyM2VmZmNhNTNiYzE4MTAK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0w
MzA3MDYzNC9uZXh0Om1hc3RlcjowOWRlMTkyMjQyZDg2ZWRlNDQ5MTQ2YWM0MjNlZmZjYTUz
YmMxODEwOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDgtMDQ6MzI6MTkgMDlkZTE5MjI0MmQ4
NmVkZTQ0OTE0NmFjNDIzZWZmY2E1M2JjMTgxMCBjb21waWxpbmcKNjQ2IHJlYWwgIDQ4MDAg
dXNlciAgMzU5IHN5cyAgNzk4LjQ1JSBjcHUgCWkzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYz
NAoKMjAxNC0wMy0wOC0wNDo0NDozMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1
LTA2NDk0LWcwOWRlMTkyLi4uIFRFU1QgRkFJTFVSRQpbICAgIDcuNzg1NTk0XSBpbml0OiBG
YWlsZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKWyAgICA3
LjgwMzc1N10gaW5pdDogRmFpbGVkIHRvIGNyZWF0ZSBwdHkgLSBkaXNhYmxpbmcgbG9nZ2lu
ZyBmb3Igam9iClsgICAgOC43NDk2MzhdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0t
LS0tLS0tLQpbICAgIDguNzQ5NjkwXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAyOTMgYXQgL2tl
cm5lbC10ZXN0cy9saW51eDQva2VybmVsL3NvZnRpcnEuYzoxNDUgX19sb2NhbF9iaF9lbmFi
bGVfaXArMHhiMy8weDIwMigpClsgICAgOC43NDk2OTRdIE1vZHVsZXMgbGlua2VkIGluOgpb
ICAgIDguNzQ5NzAwXSBDUFU6IDAgUElEOiAyOTMgQ29tbTogYmxraWQgTm90IHRhaW50ZWQg
My4xNC4wLXJjNS0wNjQ5NC1nMDlkZTE5MiAjOTYKWyAgICA4Ljc0OTcwMl0gSGFyZHdhcmUg
bmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDguNzQ5NzEz
XSAgMDAwMDAwMDAgYzIzMDViZDAgY2E1OGQ1YmYgYzIzMDViZTggYzkyNWM3NWMgYzkyNjMy
MGYgYzk2OWFiZmMgMDAwMDAyMDAKWyAgICA4Ljc0OTczMF0gIGMyNmFkYzAwIGMyMzA1YmY4
IGM5MjVjN2M4IDAwMDAwMDA5IDAwMDAwMDAwIGMyMzA1YzA4IGM5MjYzMjBmIDAwMDAwMDAw
ClsgICAgOC43NDk3MzddICAwMDAwMDAwMCBjMjMwNWNiMCBjOTY5YWM2ZSAwMDAwMDAwMSAw
MDAwMDAwMCBjMjY5YjAwMCBjMjc3YzgyMCBjMjZhZGMwMApbICAgIDguNzQ5NzM5XSBDYWxs
IFRyYWNlOgpbICAgIDguNzQ5Nzc2XSAgWzxjYTU4ZDViZj5dIGR1bXBfc3RhY2srMHg0MC8w
eDVlClsgICAgOC43NDk3ODJdICBbPGM5MjVjNzVjPl0gd2Fybl9zbG93cGF0aF9jb21tb24r
MHhhOS8weGVhClsgICAgOC43NDk3ODddICBbPGM5MjYzMjBmPl0gPyBfX2xvY2FsX2JoX2Vu
YWJsZV9pcCsweGIzLzB4MjAyClsgICAgOC43NDk4MDRdICBbPGM5NjlhYmZjPl0gPyBfX2Nm
cV9zZXRfYWN0aXZlX3F1ZXVlKzB4MTEyLzB4MmYxClsgICAgOC43NDk4MDldICBbPGM5MjVj
N2M4Pl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MmIvMHgzZApbICAgIDguNzQ5ODE1XSAgWzxj
OTI2MzIwZj5dIF9fbG9jYWxfYmhfZW5hYmxlX2lwKzB4YjMvMHgyMDIKWyAgICA4Ljc0OTgx
OV0gIFs8Yzk2OWFjNmU+XSBfX2NmcV9zZXRfYWN0aXZlX3F1ZXVlKzB4MTg0LzB4MmYxClsg
ICAgOC43NDk4MjRdICBbPGM5NjkwMDJmPl0gPyByZXNjYW5fcGFydGl0aW9ucysweDMzOC8w
eDQ3NApbICAgIDguNzQ5ODI5XSAgWzxjOTY5ZDVjMT5dID8gY2ZxX3Jlc29ydF9ycl9saXN0
KzB4NDkvMHg1YgpbICAgIDguNzQ5ODM0XSAgWzxjOTY5ZDcxMT5dID8gY2ZxX2FkZF9jZnFx
X3JyKzB4MTNlLzB4MTUzClsgICAgOC43NDk4MzldICBbPGM5NjlkYWRmPl0gPyBjZnFfdXBk
YXRlX2lkbGVfd2luZG93LmlzcmEuNzgrMHhmMi8weDI1NApbICAgIDguNzQ5ODUzXSAgWzxj
OTI5OTY5OT5dID8gc2NoZWRfY2xvY2tfY3B1KzB4MTVkLzB4MTk4ClsgICAgOC43NDk4NTld
ICBbPGM5NmEyNWYzPl0gY2ZxX2Rpc3BhdGNoX3JlcXVlc3RzKzB4YjkyLzB4MTIxMgpbICAg
IDguNzQ5ODY3XSAgWzxjOTI0YTM2Yj5dID8ga3ZtX2Nsb2NrX3JlYWQrMHgzMC8weDU1Clsg
ICAgOC43NDk4NzNdICBbPGM5MjBmZDc1Pl0gPyBzY2hlZF9jbG9jaysweDNlLzB4NTAKWyAg
ICA4Ljc0OTg3OV0gIFs8Yzk2YTA0NzA+XSA/IGNmcV9pbnNlcnRfcmVxdWVzdCsweDQyOS8w
eDhjOQpbICAgIDguNzQ5ODg4XSAgWzxjOTJhZGI5OT5dID8gX19sb2NrX2FjcXVpcmUrMHgx
NTk0LzB4MTZiYQpbICAgIDguNzQ5OTAwXSAgWzxjOTY3YTFiMj5dIGJsa19wZWVrX3JlcXVl
c3QrMHg5ZS8weDMxYQpbICAgIDguNzQ5OTIwXSAgWzxjOWI4MmQyND5dIHNjc2lfcmVxdWVz
dF9mbisweDYyLzB4OGExClsgICAgOC43NDk5MjVdICBbPGM5NjdhYTFhPl0gPyBibGtfZmx1
c2hfcGx1Z19saXN0KzB4MmE0LzB4NDQ3ClsgICAgOC43NTAwMDRdICBbPGM5Njc0ZDIyPl0g
X19ibGtfcnVuX3F1ZXVlKzB4NTUvMHg2YwpbICAgIDguNzUwMDA0XSAgWzxjOTY3ODRkZD5d
IHF1ZXVlX3VucGx1Z2dlZC5pc3JhLjI5KzB4NDAvMHg2YQpbICAgIDguNzUwMDA0XSAgWzxj
OTY3YWFkYz5dIGJsa19mbHVzaF9wbHVnX2xpc3QrMHgzNjYvMHg0NDcKWyAgICA4Ljc1MDAw
NF0gIFs8Yzk2N2FiZDg+XSBibGtfZmluaXNoX3BsdWcrMHgxYi8weDUxClsgICAgOC43NTAw
MDRdICBbPGM5MzJlMmRjPl0gX19kb19wYWdlX2NhY2hlX3JlYWRhaGVhZCsweDMxNC8weDM2
NApbICAgIDguNzUwMDA0XSAgWzxjOTMyZTQzMj5dIGZvcmNlX3BhZ2VfY2FjaGVfcmVhZGFo
ZWFkKzB4YTgvMHhlMQpbICAgIDguNzUwMDA0XSAgWzxjOTMyZWEyNj5dIHBhZ2VfY2FjaGVf
c3luY19yZWFkYWhlYWQrMHg1ZC8weDkxClsgICAgOC43NTAwMDRdICBbPGM5MzFmZDA1Pl0g
Z2VuZXJpY19maWxlX2Fpb19yZWFkKzB4MzZlLzB4YjU5ClsgICAgOC43NTAwMDRdICBbPGM5
M2QwMzM5Pl0gYmxrZGV2X2Fpb19yZWFkKzB4OTUvMHhiMQpbICAgIDguNzUwMDA0XSAgWzxj
OTM3ZTg1NT5dIGRvX3N5bmNfcmVhZCsweDVhLzB4YWIKWyAgICA4Ljc1MDAwNF0gIFs8Yzkz
N2U3ZmI+XSA/IGRvX3N5bmNfd3JpdGUrMHhhYi8weGFiClsgICAgOC43NTAwMDRdICBbPGM5
MzdmNGVhPl0gdmZzX3JlYWQrMHhlMC8weDFmYgpbICAgIDguNzUwMDA0XSAgWzxjOTM3Zjgw
ZT5dIFN5U19yZWFkKzB4NzMvMHhlOApbICAgIDguNzUwMDA0XSAgWzxjYTVhNjE4YT5dIHN5
c2VudGVyX2RvX2NhbGwrMHgxMi8weDNjClsgICAgOC43NTAwMDRdIC0tLVsgZW5kIHRyYWNl
IDk3Mzg2ZjZmYmJkMDYwNmEgXS0tLQpbICAgIDguNzUwMDA0XSAKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDEtMDMwNzA2MzQvMDlkZTE5MjI0MmQ4NmVkZTQ0OTE0NmFjNDIzZWZmY2E1
M2JjMTgxMC9kbWVzZy1xdWFudGFsLXNuYi01OjIwMTQwMzA4MDQ0NTQ2OmkzODYtcmFuZGNv
bmZpZy14MS0wMzA3MDYzNDo6CjA6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtb
MTszNW0yMDE0LTAzLTA4IDA0OjQ2OjAzIFJFUEVBVCBDT1VOVDogMjAgICMgL2tlcm5lbC10
ZXN0cy9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0
IDA5ZGUxOTIyNDJkODZlZGU0NDkxNDZhYzQyM2VmZmNhNTNiYzE4MTAKZ2l0IGNoZWNrb3V0
IHYzLjEzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWcteDEtMDMwNzA2MzQvbmV4dDptYXN0ZXI6ZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZTpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA4LTA0OjQ2OjA3IGQ4ZWMy
NmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUgY29tcGlsaW5nCjUyNiByZWFs
ICA0ODM1IHVzZXIgIDM3OSBzeXMgIDk5MS4zOCUgY3B1IAlpMzg2LXJhbmRjb25maWcteDEt
MDMwNzA2MzQKCjIwMTQtMDMtMDgtMDQ6NTU6MTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
My4wLi4uLiBURVNUIEZBSUxVUkUKWyAgIDExLjE2ODUzNF0gaW5pdDogRmFpbGVkIHRvIGNy
ZWF0ZSBwdHkgLSBkaXNhYmxpbmcgbG9nZ2luZyBmb3Igam9iClsgICAxMy40MTQwMTJdIGlu
aXQ6IEZhaWxlZCB0byBjcmVhdGUgcHR5IC0gZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpb
ICAgMTMuNTA4MDQzXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAg
IDEzLjUwODA5Ml0gV0FSTklORzogQ1BVOiAwIFBJRDogMjc5IGF0IC9rZXJuZWwtdGVzdHMv
bGludXg0L2tlcm5lbC9zb2Z0aXJxLmM6MTU2IGxvY2FsX2JoX2VuYWJsZSsweGJmLzB4MjBl
KCkKWyAgIDEzLjUwODA5Nl0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAxMy41MDgxMDBdIENQ
VTogMCBQSUQ6IDI3OSBDb21tOiBibGtpZCBOb3QgdGFpbnRlZCAzLjEzLjAgIzk3ClsgICAx
My41MDgxMDJdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAx
LzIwMTEKWyAgIDEzLjUwODEwOV0gIDAwMDAwMDAwIGM4ZjM1YmQwIGMxNTM3MWQ4IGM4ZjM1
YmU4IGMwMjU5MjVmIGMwMjVmZWRjIGMwNjhmYmFhIDAwMDAwMDAwClsgICAxMy41MDgxMTNd
ICBjOTI2MGMwMCBjOGYzNWJmOCBjMDI1OTJjYiAwMDAwMDAwOSAwMDAwMDAwMCBjOGYzNWMw
NCBjMDI1ZmVkYyAwMDAwMDAwMApbICAgMTMuNTA4MTE4XSAgYzhmMzVjYWMgYzA2OGZiYWEg
MDAwMDAwMDEgMDAwMDAwMDAgYzkyNWEwMDAgYzkzMGM4MjAgYzkyNjBjMDAgYzA2OTAwMmYK
WyAgIDEzLjUwODExOV0gQ2FsbCBUcmFjZToKWyAgIDEzLjUwODE0NF0gIFs8YzE1MzcxZDg+
XSBkdW1wX3N0YWNrKzB4NDAvMHg1ZQpbICAgMTMuNTA4MTQ4XSAgWzxjMDI1OTI1Zj5dIHdh
cm5fc2xvd3BhdGhfY29tbW9uKzB4YTkvMHhlYQpbICAgMTMuNTA4MTUyXSAgWzxjMDI1ZmVk
Yz5dID8gbG9jYWxfYmhfZW5hYmxlKzB4YmYvMHgyMGUKWyAgIDEzLjUwODE2NF0gIFs8YzA2
OGZiYWE+XSA/IF9fY2ZxX3NldF9hY3RpdmVfcXVldWUrMHgxMTAvMHgyN2QKWyAgIDEzLjUw
ODE2N10gIFs8YzAyNTkyY2I+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyYi8weDNkClsgICAx
My41MDgxNzBdICBbPGMwMjVmZWRjPl0gbG9jYWxfYmhfZW5hYmxlKzB4YmYvMHgyMGUKWyAg
IDEzLjUwODE3M10gIFs8YzA2OGZiYWE+XSBfX2NmcV9zZXRfYWN0aXZlX3F1ZXVlKzB4MTEw
LzB4MjdkClsgICAxMy41MDgxNzddICBbPGMwNjkwMDJmPl0gPyBjZnFfZ3JvdXBfc2VydmVk
KzB4MzE4LzB4NDY3ClsgICAxMy41MDgxODBdICBbPGMwNjkyMWJkPl0gPyBjZnFfcmVzb3J0
X3JyX2xpc3QrMHg0OS8weDViClsgICAxMy41MDgxODNdICBbPGMwNjkyMmFkPl0gPyBjZnFf
YWRkX2NmcXFfcnIrMHhkZS8weGYzClsgICAxMy41MDgxODZdICBbPGMwNjkyNjdiPl0gPyBj
ZnFfdXBkYXRlX2lkbGVfd2luZG93LmlzcmEuNzgrMHhmMi8weDFmNApbICAgMTMuNTA4MTkw
XSAgWzxjMDI5NGVkZT5dID8gc2NoZWRfY2xvY2tfY3B1KzB4MWM0LzB4MWY5ClsgICAxMy41
MDgxOTldICBbPGMwMjlmZDM2Pl0gPyB0cmFjZV9oYXJkaXJxc19vZmYrMHgyNy8weDM3Clsg
ICAxMy41MDgyMDNdICBbPGMwMjk1MDEyPl0gPyBsb2NhbF9jbG9jaysweGZmLzB4MTc2Clsg
ICAxMy41MDgyMDZdICBbPGMwNjk2YzBiPl0gY2ZxX2Rpc3BhdGNoX3JlcXVlc3RzKzB4Yjky
LzB4MTFiMApbICAgMTMuNTA4MjA5XSAgWzxjMDI0ODIzZj5dID8ga3ZtX2Nsb2NrX3JlYWQr
MHgzMC8weDU1ClsgICAxMy41MDgyMTRdICBbPGMwMjBmNjRmPl0gPyBzY2hlZF9jbG9jaysw
eDNlLzB4NTAKWyAgIDEzLjUwODIxN10gIFs8YzA2OTRjMDg+XSA/IGNmcV9pbnNlcnRfcmVx
dWVzdCsweDNjOS8weDg2OQpbICAgMTMuNTA4MjE5XSAgWzxjMDI5ZmQzNj5dID8gdHJhY2Vf
aGFyZGlycXNfb2ZmKzB4MjcvMHgzNwpbICAgMTMuNTA4MjIyXSAgWzxjMDJhN2EyOT5dID8g
X19sb2NrX2FjcXVpcmUrMHgxNWE0LzB4MTZjYQpbICAgMTMuNTA4MjI3XSAgWzxjMDZiMDJk
Zj5dID8gbGlzdF9zb3J0KzB4MWZiLzB4MjUzClsgICAxMy41MDgyMzBdICBbPGMwNjZmYjJh
Pl0gYmxrX3BlZWtfcmVxdWVzdCsweDllLzB4MzFhClsgICAxMy41MDgyNDhdICBbPGMwYjVi
MmViPl0gc2NzaV9yZXF1ZXN0X2ZuKzB4NjIvMHg4OWUKWyAgIDEzLjUwODI1MV0gIFs8YzA2
NzAzMWI+XSA/IGJsa19mbHVzaF9wbHVnX2xpc3QrMHgyYTQvMHg0NDcKWyAgIDEzLjUwODI1
Nl0gIFs8YzA2NmE5MGE+XSBfX2Jsa19ydW5fcXVldWUrMHg1NS8weDZjClsgICAxMy41MDgy
NThdICBbPGMwNjZkZmE2Pl0gcXVldWVfdW5wbHVnZ2VkLmlzcmEuMjkrMHg0MC8weDZhClsg
ICAxMy41MDgyNjFdICBbPGMwNjcwM2RkPl0gYmxrX2ZsdXNoX3BsdWdfbGlzdCsweDM2Ni8w
eDQ0NwpbICAgMTMuNTA4MjY0XSAgWzxjMDY3MDRkOT5dIGJsa19maW5pc2hfcGx1ZysweDFi
LzB4NTEKWyAgIDEzLjUwODI2OV0gIFs8YzAzMjdkN2I+XSBfX2RvX3BhZ2VfY2FjaGVfcmVh
ZGFoZWFkKzB4MzE0LzB4MzY0ClsgICAxMy41MDgyNzRdICBbPGMwMzI3ZWM3Pl0gZm9yY2Vf
cGFnZV9jYWNoZV9yZWFkYWhlYWQrMHg5ZS8weGVhClsgICAxMy41MDgyNzddICBbPGMwMzI4
NGNlPl0gcGFnZV9jYWNoZV9zeW5jX3JlYWRhaGVhZCsweDVkLzB4OTEKWyAgIDEzLjUwODI4
MF0gIFs8YzAzMTlkYTA+XSBnZW5lcmljX2ZpbGVfYWlvX3JlYWQrMHgzOTMvMHhiN2UKWyAg
IDEzLjUwODI5MV0gIFs8YzAzYzhiNTA+XSBibGtkZXZfYWlvX3JlYWQrMHg5NS8weGIxClsg
ICAxMy41MDgyOTZdICBbPGMwMzc2ZTZiPl0gZG9fc3luY19yZWFkKzB4NWEvMHhhYgpbICAg
MTMuNTA4Mjk5XSAgWzxjMDM3NmUxMT5dID8gZG9fc3luY193cml0ZSsweGFiLzB4YWIKWyAg
IDEzLjUwODMwMV0gIFs8YzAzNzdhZTY+XSB2ZnNfcmVhZCsweGQzLzB4MWVlClsgICAxMy41
MDgzMDRdICBbPGMwMzc3ZTBhPl0gU3lTX3JlYWQrMHg3My8weGU4ClsgICAxMy41MDgzMDhd
ICBbPGMxNTUwNThhPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MKWyAgIDEzLjUwODMx
MV0gLS0tWyBlbmQgdHJhY2UgYThkZTk3MjNlNGM4MGRmYiBdLS0tClsgICAxMy41MDgzNTBd
IAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC9kOGVjMjZkN2Y4Mjg3ZjU3
ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwtYmVucy0xOjIwMTQwMzA4
MDQ1NjU5OmkzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNDozLjEzLjA6OTcKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZS9kbWVzZy1xdWFudGFsLXNuYi02OjIwMTQwMzA4MDQ1NjUzOmkzODYt
cmFuZGNvbmZpZy14MS0wMzA3MDYzNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAz
MDcwNjM0L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2ct
cXVhbnRhbC1zbmItNDQ6MjAxNDAzMDgwNDU2NTk6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcw
NjM0OjoKMDozOjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMt
MDggMDQ6NTc6MTYgUkVQRUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4NC9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTMKZ2l0IGNo
ZWNrb3V0IHYzLjEyCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWcteDEtMDMwNzA2MzQvbmV4dDptYXN0ZXI6NWUwMWRjN2IyNmQ5ZjI0ZjM5YWJh
Y2U1ZGE5OGNjYmQ2YTVjZWI1MjpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA4LTA0OjU3OjE5
IDVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIgY29tcGlsaW5nCjUw
NCByZWFsICA0NTc5IHVzZXIgIDM2MyBzeXMgIDk3OS41NCUgY3B1IAlpMzg2LXJhbmRjb25m
aWcteDEtMDMwNzA2MzQKCjIwMTQtMDMtMDgtMDU6MDY6MTQgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xMi4wLi4uLi4uLi4uLgk5CTE5CTIwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21t
aXQgdjMuMTIKZ2l0IGJpc2VjdCBzdGFydCB2My4xMyB2My4xMiAtLQovYy9rZXJuZWwtdGVz
dHMvbGluZWFyLWJpc2VjdDogWyItYiIsICJ2My4xMyIsICItZyIsICJ2My4xMiIsICIvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9rZXJuZWwtdGVz
dHMvbGludXg0L29iai1iaXNlY3QiXQpCaXNlY3Rpbmc6IDEzMjg4IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxNCBzdGVwcykKWzNiYWQ4YmI1Y2QzMDQ4
YTY3ZGY0M2FjNmIxZTJmMTkxZjE5ZDlmZjBdIE1lcmdlIGJyYW5jaCAnZm9yLW5leHQnIG9m
IGdpdDovL2dpdC5zYW1iYS5vcmcvc2ZyZW5jaC9jaWZzLTIuNgpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51
eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLXgxLTAzMDcwNjM0L25leHQ6bWFzdGVyOjNiYWQ4YmI1Y2QzMDQ4YTY3ZGY0
M2FjNmIxZTJmMTkxZjE5ZDlmZjA6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0wOC0wNToxMzoy
NyAzYmFkOGJiNWNkMzA0OGE2N2RmNDNhYzZiMWUyZjE5MWYxOWQ5ZmYwIGNvbXBpbGluZwo2
NzYgcmVhbCAgNDg0NSB1c2VyICAzODEgc3lzICA3NzMuMjYlIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLXgxLTAzMDcwNjM0CgoyMDE0LTAzLTA4LTA1OjI2OjE3IGRldGVjdGluZyBib290IHN0
YXRlIDMuMTMuMC1yYzEtMDAyMzUtZzNiYWQ4YmIuLi4uCTQJNwkxMgkxOQkyMCBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDE2OTcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDExIHN0ZXBzKQpbZGQwNTA4MDkzYjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5
ZjU0Nl0gTWVyZ2UgYnJhbmNoICdzY2hlZC11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10
ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0L25leHQ6bWFzdGVyOmRkMDUwODA5M2I3
OTE0MWUwMDQ0Y2EwMmYwYWNiNjMxOWY2OWY1NDY6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0w
OC0wNTozMTowNiBkZDA1MDgwOTNiNzkxNDFlMDA0NGNhMDJmMGFjYjYzMTlmNjlmNTQ2IGNv
bXBpbGluZwo2NDUgcmVhbCAgNDYyMyB1c2VyICAzNTMgc3lzICA3NzEuNjElIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0CjIwMTQtMDMtMDgtMDU6NDM6MDYgZGQwNTA4MDkz
Yjc5MTQxZTAwNDRjYTAyZjBhY2I2MzE5ZjY5ZjU0NiBTS0lQIEJST0tFTiBCVUlMRApDaGVj
ayBlcnJvcyBpbiAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0IGFuZCAvdG1wL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvZGQwNTA4MDkzYjc5MTQxZTAwNDRj
YTAyZjBhY2I2MzE5ZjY5ZjU0NgpCaXNlY3Rpbmc6IDE2OTcgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbNzU0YWM0NTc0NTcxMWE3Y2Uw
MDY3MDg3ZTViNTVhOWMyNzc5NTJhZF0gTWVyZ2UgYnJhbmNoICdmb3ItbGludXMnIG9mIGdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kdG9yL2lucHV0
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
a2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvbmV4dDptYXN0ZXI6NzU0
YWM0NTc0NTcxMWE3Y2UwMDY3MDg3ZTViNTVhOWMyNzc5NTJhZDpiaXNlY3QtbGludXg0Cgoy
MDE0LTAzLTA4LTA1OjQzOjA3IDc1NGFjNDU3NDU3MTFhN2NlMDA2NzA4N2U1YjU1YTljMjc3
OTUyYWQgY29tcGlsaW5nCjMyOCByZWFsICA0ODMwIHVzZXIgIDM3OCBzeXMgIDE1ODYuNzUl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0CgoyMDE0LTAzLTA4LTA1OjQ5OjI0
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTMuMC1yYzMtMDAwODAtZzc1NGFjNDUuLi4uLi4g
VEVTVCBGQUlMVVJFClsgICAgNS4yMzE3MjVdIGluaXQ6IEZhaWxlZCB0byBjcmVhdGUgcHR5
IC0gZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpbICAgIDUuMjQwNDcyXSBpbml0OiBGYWls
ZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKWyAgICA1Ljc3
NTA3M10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgNS43NzUx
MDBdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDI3OSBhdCAva2VybmVsLXRlc3RzL2xpbnV4NC9r
ZXJuZWwvc29mdGlycS5jOjE1NiBsb2NhbF9iaF9lbmFibGUrMHhiZi8weDIwZSgpClsgICAg
NS43NzUxMDJdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDUuNzc1MTA4XSBDUFU6IDAgUElE
OiAyNzkgQ29tbTogYmxraWQgTm90IHRhaW50ZWQgMy4xMy4wLXJjMy0wMDA4MC1nNzU0YWM0
NSAjMTAwClsgICAgNS43NzUxMDldIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9T
IEJvY2hzIDAxLzAxLzIwMTEKWyAgICA1Ljc3NTExNV0gIDAwMDAwMDAwIGM1MjM1YmQwIGMx
NTMzMDZjIGM1MjM1YmU4IGMwMjU5MTM1IGMwMjVmZGIyIGMwNjhlZmI3IDAwMDAwMDAwClsg
ICAgNS43NzUxMThdICBjNTVjNGMwMCBjNTIzNWJmOCBjMDI1OTFhMSAwMDAwMDAwOSAwMDAw
MDAwMCBjNTIzNWMwNCBjMDI1ZmRiMiAwMDAwMDAwMApbICAgIDUuNzc1MTIyXSAgYzUyMzVj
YWMgYzA2OGVmYjcgMDAwMDAwMDEgMDAwMDAwMDAgYzU1YzAwMDAgYzU2OTM4MjAgYzU1YzRj
MDAgYzA2ODAwMmYKWyAgICA1Ljc3NTEyM10gQ2FsbCBUcmFjZToKWyAgICA1Ljc3NTEzNl0g
IFs8YzE1MzMwNmM+XSBkdW1wX3N0YWNrKzB4NDAvMHg1ZQpbICAgIDUuNzc1MTM4XSAgWzxj
MDI1OTEzNT5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4YTkvMHhlYQpbICAgIDUuNzc1MTQx
XSAgWzxjMDI1ZmRiMj5dID8gbG9jYWxfYmhfZW5hYmxlKzB4YmYvMHgyMGUKWyAgICA1Ljc3
NTE1M10gIFs8YzA2OGVmYjc+XSA/IF9fY2ZxX3NldF9hY3RpdmVfcXVldWUrMHgxMTAvMHgy
N2QKWyAgICA1Ljc3NTE1NV0gIFs8YzAyNTkxYTE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgy
Yi8weDNkClsgICAgNS43NzUxNTddICBbPGMwMjVmZGIyPl0gbG9jYWxfYmhfZW5hYmxlKzB4
YmYvMHgyMGUKWyAgICA1Ljc3NTE2MF0gIFs8YzA2OGVmYjc+XSBfX2NmcV9zZXRfYWN0aXZl
X3F1ZXVlKzB4MTEwLzB4MjdkClsgICAgNS43NzUxNjJdICBbPGMwNjgwMDJmPl0gPyBkaXNr
X3NlcWZfbmV4dCsweDIzLzB4NGMKWyAgICA1Ljc3NTE2NF0gIFs8YzA2OTE1Y2E+XSA/IGNm
cV9yZXNvcnRfcnJfbGlzdCsweDQ5LzB4NWIKWyAgICA1Ljc3NTE2Nl0gIFs8YzA2OTE2YmE+
XSA/IGNmcV9hZGRfY2ZxcV9ycisweGRlLzB4ZjMKWyAgICA1Ljc3NTE2OF0gIFs8YzA2OTFh
ODg+XSA/IGNmcV91cGRhdGVfaWRsZV93aW5kb3cuaXNyYS43OCsweGYyLzB4MWY0ClsgICAg
NS43NzUxNzRdICBbPGMwMjk0ZGQwPl0gPyBzY2hlZF9jbG9ja19jcHUrMHgxYzQvMHgxZjkK
WyAgICA1Ljc3NTE3OF0gIFs8YzAyOWZiYmY+XSA/IHRyYWNlX2hhcmRpcnFzX29mZisweDI3
LzB4MzcKWyAgICA1Ljc3NTE4MF0gIFs8YzAyOTRmMDQ+XSA/IGxvY2FsX2Nsb2NrKzB4ZmYv
MHgxNzYKWyAgICA1Ljc3NTE4Ml0gIFs8YzA2OTYwMTg+XSBjZnFfZGlzcGF0Y2hfcmVxdWVz
dHMrMHhiOTIvMHgxMWIwClsgICAgNS43NzUxODZdICBbPGMwMjQ4MTJmPl0gPyBrdm1fY2xv
Y2tfcmVhZCsweDMwLzB4NTUKWyAgICA1Ljc3NTE5Ml0gIFs8YzAyMGY1NTk+XSA/IHNjaGVk
X2Nsb2NrKzB4M2UvMHg1MApbICAgIDUuNzc1MTk0XSAgWzxjMDY5NDAxNT5dID8gY2ZxX2lu
c2VydF9yZXF1ZXN0KzB4M2M5LzB4ODY5ClsgICAgNS43NzUxOTZdICBbPGMwMjlmYmJmPl0g
PyB0cmFjZV9oYXJkaXJxc19vZmYrMHgyNy8weDM3ClsgICAgNS43NzUxOThdICBbPGMwMmE3
OGIyPl0gPyBfX2xvY2tfYWNxdWlyZSsweDE1YTQvMHgxNmNhClsgICAgNS43NzUyMDRdICBb
PGMwNmFmNmVmPl0gPyBsaXN0X3NvcnQrMHgxZmIvMHgyNTMKWyAgICA1Ljc3NTIwOF0gIFs8
YzA2NmYwMWM+XSBibGtfcGVla19yZXF1ZXN0KzB4OWUvMHgzMWEKWyAgICA1Ljc3NTIxOV0g
IFs8YzBiNTdmNDY+XSBzY3NpX3JlcXVlc3RfZm4rMHg2Mi8weDg5ZQpbICAgIDUuNzc1MjIx
XSAgWzxjMDY2ZjgwZD5dID8gYmxrX2ZsdXNoX3BsdWdfbGlzdCsweDJhNC8weDQ0NwpbICAg
IDUuNzc1MjI2XSAgWzxjMDY2OWRmYz5dIF9fYmxrX3J1bl9xdWV1ZSsweDU1LzB4NmMKWyAg
ICA1Ljc3NTIyOF0gIFs8YzA2NmQ0OTg+XSBxdWV1ZV91bnBsdWdnZWQuaXNyYS4yOSsweDQw
LzB4NmEKWyAgICA1Ljc3NTIzMF0gIFs8YzA2NmY4Y2Y+XSBibGtfZmx1c2hfcGx1Z19saXN0
KzB4MzY2LzB4NDQ3ClsgICAgNS43NzUyMzJdICBbPGMwNjZmOWNiPl0gYmxrX2ZpbmlzaF9w
bHVnKzB4MWIvMHg1MQpbICAgIDUuNzc1MjQzXSAgWzxjMDMyN2FmND5dIF9fZG9fcGFnZV9j
YWNoZV9yZWFkYWhlYWQrMHgzMTQvMHgzNjQKWyAgICA1Ljc3NTI0Nl0gIFs8YzAzMjdjNDA+
XSBmb3JjZV9wYWdlX2NhY2hlX3JlYWRhaGVhZCsweDllLzB4ZWEKWyAgICA1Ljc3NTI0OV0g
IFs8YzAzMjgyNDc+XSBwYWdlX2NhY2hlX3N5bmNfcmVhZGFoZWFkKzB4NWQvMHg5MQpbICAg
IDUuNzc1MjUxXSAgWzxjMDMxOWIxOT5dIGdlbmVyaWNfZmlsZV9haW9fcmVhZCsweDM5My8w
eGI3ZQpbICAgIDUuNzc1MjU4XSAgWzxjMDNjODE0YT5dIGJsa2Rldl9haW9fcmVhZCsweDk1
LzB4YjEKWyAgICA1Ljc3NTI2Ml0gIFs8YzAzNzY0Y2Q+XSBkb19zeW5jX3JlYWQrMHg1YS8w
eGFiClsgICAgNS43NzUyNjRdICBbPGMwMzc2NDczPl0gPyBkb19zeW5jX3dyaXRlKzB4YWIv
MHhhYgpbICAgIDUuNzc1MjY2XSAgWzxjMDM3NzE0OD5dIHZmc19yZWFkKzB4ZDMvMHgxZWUK
WyAgICA1Ljc3NTI2OF0gIFs8YzAzNzc0NmM+XSBTeVNfcmVhZCsweDczLzB4ZTgKWyAgICA1
Ljc3NTI3Ml0gIFs8YzE1NGMzY2E+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzYwpbICAg
IDUuNzc1Mjc0XSAtLS1bIGVuZCB0cmFjZSBhNDM1YTYzY2YyY2U4MGExIF0tLS0KWyAgICA1
Ljc3NTMwNF0gCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0Lzc1NGFjNDU3
NDU3MTFhN2NlMDA2NzA4N2U1YjU1YTljMjc3OTUyYWQvZG1lc2ctcXVhbnRhbC1pbm4tMTg6
MjAxNDAzMDgwNTUxNTU6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvNzU0YWM0NTc0NTcxMWE3Y2UwMDY3MDg3ZTVi
NTVhOWMyNzc5NTJhZC9kbWVzZy1xdWFudGFsLWlubi04OjIwMTQwMzA4MDU1MTU4OmkzODYt
cmFuZGNvbmZpZy14MS0wMzA3MDYzNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAz
MDcwNjM0Lzc1NGFjNDU3NDU3MTFhN2NlMDA2NzA4N2U1YjU1YTljMjc3OTUyYWQvZG1lc2ct
eW9jdG8tcm9hbS0xNzoyMDE0MDMwODA1NTIwMzppMzg2LXJhbmRjb25maWcteDEtMDMwNzA2
MzQ6My4xMy4wLXJjMy0wMDA4MC1nNzU0YWM0NToxMDAKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDEtMDMwNzA2MzQvNzU0YWM0NTc0NTcxMWE3Y2UwMDY3MDg3ZTViNTVhOWMyNzc5NTJh
ZC9kbWVzZy1xdWFudGFsLXNuYi0zMzoyMDE0MDMwODA1NTIxMjppMzg2LXJhbmRjb25maWct
eDEtMDMwNzA2MzQ6OgowOjQ6NCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVt
MjAxNC0wMy0wOCAwNTo1MjoyNSBSRVBFQVQgQ09VTlQ6IDIwICAjIC9rZXJuZWwtdGVzdHMv
bGludXg0L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogNDgxIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbZDY0NGMwMjZl
NmIyMTk1OWFmMWY4NmIxNTIwNmFlMjZjNjRjMmU1MV0gTWVyZ2UgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2hlcmJlcnQvY3J5cHRvLTIuNgpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5l
bC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0L25leHQ6bWFzdGVyOmQ2NDRjMDI2
ZTZiMjE5NTlhZjFmODZiMTUyMDZhZTI2YzY0YzJlNTE6YmlzZWN0LWxpbnV4NAoKMjAxNC0w
My0wOC0wNTo1MjoyNiBkNjQ0YzAyNmU2YjIxOTU5YWYxZjg2YjE1MjA2YWUyNmM2NGMyZTUx
IGNvbXBpbGluZwo0MTYgcmVhbCAgNDgyNiB1c2VyICAzODMgc3lzICAxMjUwLjM1JSBjcHUg
CWkzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNAoKMjAxNC0wMy0wOC0wNTo1OTo1MCBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtcmMyLTAwMTQ1LWdkNjQ0YzAyLi4uLgkyCTEzLgkx
NgkxOS4uLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyNjIgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpClswMDJhY2YxZmMxNmNmNjBlNjAz
NDViZDY4ZTAzNzM0NjI4NTA1YjgzXSBNZXJnZSB0YWcgJ3BtLTMuMTMtcmMzJyBvZiBnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcmFmYWVsL2xpbnV4
LXBtCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvbmV4dDptYXN0ZXI6
MDAyYWNmMWZjMTZjZjYwZTYwMzQ1YmQ2OGUwMzczNDYyODUwNWI4MzpiaXNlY3QtbGludXg0
CgoyMDE0LTAzLTA4LTA2OjA3OjAyIDAwMmFjZjFmYzE2Y2Y2MGU2MDM0NWJkNjhlMDM3MzQ2
Mjg1MDViODMgY29tcGlsaW5nCjUyMiByZWFsICA0NjA3IHVzZXIgIDM2MiBzeXMgIDk1MC44
NiUgY3B1IAlpMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQKCjIwMTQtMDMtMDgtMDY6MTc6
MzkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMy4wLXJjMi0wMDI5NS1nMDAyYWNmMS4uLi4g
VEVTVCBGQUlMVVJFClsgICAgOC40MTY1NjNdIGluaXQ6IEZhaWxlZCB0byBjcmVhdGUgcHR5
IC0gZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpbICAgIDguNDI3OTk0XSBpbml0OiBGYWls
ZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKWyAgICA5LjMw
Njk1OV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgOS4zMDcw
MDJdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDI3OSBhdCAva2VybmVsLXRlc3RzL2xpbnV4NC9r
ZXJuZWwvc29mdGlycS5jOjE1NiBsb2NhbF9iaF9lbmFibGUrMHhiZi8weDIwZSgpClsgICAg
OS4zMDcwMDldIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDkuMzA3MDE5XSBDUFU6IDAgUElE
OiAyNzkgQ29tbTogYmxraWQgTm90IHRhaW50ZWQgMy4xMy4wLXJjMi0wMDI5NS1nMDAyYWNm
MSAjMTAyClsgICAgOS4zMDcwMjBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9T
IEJvY2hzIDAxLzAxLzIwMTEKWyAgICA5LjMwNzAzMV0gIDAwMDAwMDAwIGM1MmM3YmQwIGMx
NTMyYjdjIGM1MmM3YmU4IGMwMjU5MTM1IGMwMjVmZGIyIGMwNjhlZjdhIDAwMDAwMDAwClsg
ICAgOS4zMDcwMzldICBjNTVjMWMwMCBjNTJjN2JmOCBjMDI1OTFhMSAwMDAwMDAwOSAwMDAw
MDAwMCBjNTJjN2MwNCBjMDI1ZmRiMiAwMDAwMDAwMApbICAgIDkuMzA3MDQ3XSAgYzUyYzdj
YWMgYzA2OGVmN2EgMDAwMDAwMDEgMDAwMDAwMDAgYzU1YjkwMDAgYzU2NmY4MjAgYzU1YzFj
MDAgYzA2ODAwMmYKWyAgICA5LjMwNzA0OF0gQ2FsbCBUcmFjZToKWyAgICA5LjMwNzA3MF0g
IFs8YzE1MzJiN2M+XSBkdW1wX3N0YWNrKzB4NDAvMHg1ZQpbICAgIDkuMzA3MDc1XSAgWzxj
MDI1OTEzNT5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4YTkvMHhlYQpbICAgIDkuMzA3MDgw
XSAgWzxjMDI1ZmRiMj5dID8gbG9jYWxfYmhfZW5hYmxlKzB4YmYvMHgyMGUKWyAgICA5LjMw
NzEwMF0gIFs8YzA2OGVmN2E+XSA/IF9fY2ZxX3NldF9hY3RpdmVfcXVldWUrMHgxMTAvMHgy
N2QKWyAgICA5LjMwNzEwNV0gIFs8YzAyNTkxYTE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgy
Yi8weDNkClsgICAgOS4zMDcxMDldICBbPGMwMjVmZGIyPl0gbG9jYWxfYmhfZW5hYmxlKzB4
YmYvMHgyMGUKWyAgICA5LjMwNzEyMl0gIFs8YzA2OGVmN2E+XSBfX2NmcV9zZXRfYWN0aXZl
X3F1ZXVlKzB4MTEwLzB4MjdkClsgICAgOS4zMDcxMjhdICBbPGMwNjgwMDJmPl0gPyBkaXNr
X3NlcWZfc3RhcnQrMHgxNC8weGQwClsgICAgOS4zMDcxMzNdICBbPGMwNjkxNThkPl0gPyBj
ZnFfcmVzb3J0X3JyX2xpc3QrMHg0OS8weDViClsgICAgOS4zMDcxMzddICBbPGMwNjkxNjdk
Pl0gPyBjZnFfYWRkX2NmcXFfcnIrMHhkZS8weGYzClsgICAgOS4zMDcxNDFdICBbPGMwNjkx
YTRiPl0gPyBjZnFfdXBkYXRlX2lkbGVfd2luZG93LmlzcmEuNzgrMHhmMi8weDFmNApbICAg
IDkuMzA3MTUyXSAgWzxjMDI5NGRkMD5dID8gc2NoZWRfY2xvY2tfY3B1KzB4MWM0LzB4MWY5
ClsgICAgOS4zMDcxNjBdICBbPGMwMjlmYmJmPl0gPyB0cmFjZV9oYXJkaXJxc19vZmYrMHgy
Ny8weDM3ClsgICAgOS4zMDcxNjRdICBbPGMwMjk0ZjA0Pl0gPyBsb2NhbF9jbG9jaysweGZm
LzB4MTc2ClsgICAgOS4zMDcxNjldICBbPGMwNjk1ZmRiPl0gY2ZxX2Rpc3BhdGNoX3JlcXVl
c3RzKzB4YjkyLzB4MTFiMApbICAgIDkuMzA3MTc3XSAgWzxjMDI0ODEyZj5dID8ga3ZtX2Ns
b2NrX3JlYWQrMHgzMC8weDU1ClsgICAgOS4zMDcxODZdICBbPGMwMjBmNTU5Pl0gPyBzY2hl
ZF9jbG9jaysweDNlLzB4NTAKWyAgICA5LjMwNzE5MV0gIFs8YzA2OTNmZDg+XSA/IGNmcV9p
bnNlcnRfcmVxdWVzdCsweDNjOS8weDg2OQpbICAgIDkuMzA3MTk1XSAgWzxjMDI5ZmJiZj5d
ID8gdHJhY2VfaGFyZGlycXNfb2ZmKzB4MjcvMHgzNwpbICAgIDkuMzA3MjAwXSAgWzxjMDJh
NzhiMj5dID8gX19sb2NrX2FjcXVpcmUrMHgxNWE0LzB4MTZjYQpbICAgIDkuMzA3MjExXSAg
WzxjMDZhZjZhZj5dID8gbGlzdF9zb3J0KzB4MWZiLzB4MjUzClsgICAgOS4zMDcyMTldICBb
PGMwNjZlZmRmPl0gYmxrX3BlZWtfcmVxdWVzdCsweDllLzB4MzFhClsgICAgOS4zMDcyNDRd
ICBbPGMwYjU3ZWM3Pl0gc2NzaV9yZXF1ZXN0X2ZuKzB4NjIvMHg4OWUKWyAgICA5LjMwNzI0
OV0gIFs8YzA2NmY3ZDA+XSA/IGJsa19mbHVzaF9wbHVnX2xpc3QrMHgyYTQvMHg0NDcKWyAg
ICA5LjMwNzI2MF0gIFs8YzA2NjlkYmY+XSBfX2Jsa19ydW5fcXVldWUrMHg1NS8weDZjClsg
ICAgOS4zMDcyNjRdICBbPGMwNjZkNDViPl0gcXVldWVfdW5wbHVnZ2VkLmlzcmEuMjkrMHg0
MC8weDZhClsgICAgOS4zMDcyNjldICBbPGMwNjZmODkyPl0gYmxrX2ZsdXNoX3BsdWdfbGlz
dCsweDM2Ni8weDQ0NwpbICAgIDkuMzA3MjczXSAgWzxjMDY2Zjk4ZT5dIGJsa19maW5pc2hf
cGx1ZysweDFiLzB4NTEKWyAgICA5LjMwNzI5MV0gIFs8YzAzMjdhZjQ+XSBfX2RvX3BhZ2Vf
Y2FjaGVfcmVhZGFoZWFkKzB4MzE0LzB4MzY0ClsgICAgOS4zMDcyOThdICBbPGMwMzI3YzQw
Pl0gZm9yY2VfcGFnZV9jYWNoZV9yZWFkYWhlYWQrMHg5ZS8weGVhClsgICAgOS4zMDczMDRd
ICBbPGMwMzI4MjQ3Pl0gcGFnZV9jYWNoZV9zeW5jX3JlYWRhaGVhZCsweDVkLzB4OTEKWyAg
ICA5LjMwNzMwOV0gIFs8YzAzMTliMTk+XSBnZW5lcmljX2ZpbGVfYWlvX3JlYWQrMHgzOTMv
MHhiN2UKWyAgICA5LjMwNzM4NF0gIFs8YzAzYzgxNGE+XSBibGtkZXZfYWlvX3JlYWQrMHg5
NS8weGIxClsgICAgOS4zMDczOTJdICBbPGMwMzc2NGNkPl0gZG9fc3luY19yZWFkKzB4NWEv
MHhhYgpbICAgIDkuMzA3Mzk3XSAgWzxjMDM3NjQ3Mz5dID8gZG9fc3luY193cml0ZSsweGFi
LzB4YWIKWyAgICA5LjMwNzQwMV0gIFs8YzAzNzcxNDg+XSB2ZnNfcmVhZCsweGQzLzB4MWVl
ClsgICAgOS4zMDc0MDNdICBbPGMwMzc3NDZjPl0gU3lTX3JlYWQrMHg3My8weGU4ClsgICAg
OS4zMDc0MDNdICBbPGMxNTRiZWNhPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MKWyAg
ICA5LjMwNzQwM10gLS0tWyBlbmQgdHJhY2UgZGRkNzI5MmMzZmU1YWZhZSBdLS0tClsgICAg
OS4zMDc0MDNdIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC8wMDJhY2Yx
ZmMxNmNmNjBlNjAzNDViZDY4ZTAzNzM0NjI4NTA1YjgzL2RtZXNnLXF1YW50YWwtc25iLTY6
MjAxNDAzMDgwNjE5MTE6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMDAyYWNmMWZjMTZjZjYwZTYwMzQ1YmQ2OGUw
MzczNDYyODUwNWI4My9kbWVzZy1xdWFudGFsLXNuYi00MzoyMDE0MDMwODA2MTkxMTppMzg2
LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6OgowOjI6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBi
b290cwobWzE7MzVtMjAxNC0wMy0wOCAwNjoxOTo1NCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9r
ZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzog
MTUwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBz
KQpbZGExOTY1ZDM1M2M3MjY2ZmNlNGZlNmM2NThmMjA5NmM4OGE4YmViY10gTWVyZ2UgdGFn
ICdwaW5jdHJsLXYzLjEzLTInIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9saW51c3cvbGludXgtcGluY3RybApydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLXgxLTAzMDcwNjM0L25leHQ6bWFzdGVyOmRhMTk2NWQzNTNjNzI2NmZjZTRmZTZj
NjU4ZjIwOTZjODhhOGJlYmM6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0wOC0wNjoyMDoxOCBk
YTE5NjVkMzUzYzcyNjZmY2U0ZmU2YzY1OGYyMDk2Yzg4YThiZWJjIGNvbXBpbGluZwoyMjgg
cmVhbCAgMzUzIHVzZXIgIDM5IHN5cyAgMTcxLjU5JSBjcHUgCWkzODYtcmFuZGNvbmZpZy14
MS0wMzA3MDYzNAoKMjAxNC0wMy0wOC0wNjoyNjo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEzLjAtcmMyLTAwMjIyLWdkYTE5NjVkLi4JMQkzCTEwCTEzCTE1CTE5CTIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogNzMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDcgc3RlcHMpCltlZjFlNGUzMmQ1OTVkM2U2YzlhNmQzZDI5NTZmMDg3ZDU4ODZjNWU1
XSBNZXJnZSB0YWcgJ2Zvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L21hc29uL2xpbnV4LWJ0cmZzCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4
NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWcteDEtMDMwNzA2MzQvbmV4dDptYXN0ZXI6ZWYxZTRlMzJkNTk1ZDNlNmM5YTZk
M2QyOTU2ZjA4N2Q1ODg2YzVlNTpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA4LTA2OjMxOjIx
IGVmMWU0ZTMyZDU5NWQzZTZjOWE2ZDNkMjk1NmYwODdkNTg4NmM1ZTUgY29tcGlsaW5nCjQ3
MyByZWFsICAyODIgdXNlciAgMzMgc3lzICA2Ni43NSUgY3B1IAlpMzg2LXJhbmRjb25maWct
eDEtMDMwNzA2MzQKCjIwMTQtMDMtMDgtMDY6NDE6MDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMy4wLXJjMi0wMDI2NS1nZWYxZTRlMy4uCTEJNC4JNQkxMQkxOAkyMCBTVUNDRVNTCgpC
aXNlY3Rpbmc6IDMwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSA1IHN0ZXBzKQpbNWVlNTQwNjEzZGI1MDRhMTBlMTVmYWZhZjRjMDhjYWM5NmFhMTgyM10g
TWVyZ2UgYnJhbmNoICdmb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwuZGsvbGludXgt
YmxvY2sKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC9uZXh0Om1hc3Rl
cjo1ZWU1NDA2MTNkYjUwNGExMGUxNWZhZmFmNGMwOGNhYzk2YWExODIzOmJpc2VjdC1saW51
eDQKCjIwMTQtMDMtMDgtMDY6NDU6MzkgNWVlNTQwNjEzZGI1MDRhMTBlMTVmYWZhZjRjMDhj
YWM5NmFhMTgyMyBjb21waWxpbmcKNTg1IHJlYWwgIDMxOSB1c2VyICAzNCBzeXMgIDYwLjUy
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNAoKMjAxNC0wMy0wOC0wNjo1Njoy
MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtcmMyLTAwMjgzLWc1ZWU1NDA2Li4uLiBU
RVNUIEZBSUxVUkUKWyAgIDExLjI0NDM2MF0gWyBJTkZPOiBpbmNvbnNpc3RlbnQgbG9jayBz
dGF0ZSBdClsgICAxMS4yNDQzNjBdIDMuMTMuMC1yYzItMDAyODMtZzVlZTU0MDYgIzEwNSBU
YWludGVkOiBHICAgICAgICBXICAgClsgICAxMS4yNDQzNjBdIC0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQpbICAgMTEuMjQ0MzYwXSBpbmNvbnNpc3RlbnQge0lOLVNPRlRJ
UlEtV30gLT4ge1NPRlRJUlEtT04tV30gdXNhZ2UuClsgICAxMS4yNDQzNjBdIGJsa2lkLzI4
MCBbSEMwWzBdOlNDMFswXTpIRTE6U0UxXSB0YWtlczoKWyAgIDExLjI0NDM2MF0gICgmKCZx
LT5fX3F1ZXVlX2xvY2spLT5ybG9jayl7Ky4/Li4ufSwgYXQ6IFs8YzA2NmY3ZDA+XSBibGtf
Zmx1c2hfcGx1Z19saXN0KzB4MmE0LzB4NDQ3ClsgICAxMS4yNDQzNjBdIHtJTi1TT0ZUSVJR
LVd9IHN0YXRlIHdhcyByZWdpc3RlcmVkIGF0OgpbICAgMTEuMjQ0MzYwXSAgIFs8YzAyYTcx
Yjk+XSBfX2xvY2tfYWNxdWlyZSsweGVhYi8weDE2Y2EKWyAgIDExLjI0NDM2MF0gICBbPGMw
MmE3YWJlPl0gbG9ja19hY3F1aXJlKzB4ZTYvMHgxNDcKWyAgIDExLjI0NDM2MF0gICBbPGMx
NTQ5YTY4Pl0gX3Jhd19zcGluX2xvY2srMHg0ZS8weGVlClsgICAxMS4yNDQzNjBdICAgWzxj
MGI1ODdjNj5dIHNjc2lfZGV2aWNlX3VuYnVzeSsweGVlLzB4MTM0ClsgICAxMS4yNDQzNjBd
ICAgWzxjMGI0ZDhmZj5dIHNjc2lfZmluaXNoX2NvbW1hbmQrMHgyYi8weDEwNwpbICAgMTEu
MjQ0MzYwXSAgIFs8YzBiNThiMWM+XSBzY3NpX3NvZnRpcnFfZG9uZSsweDFiNS8weDFjYgpb
ICAgMTEuMjQ0MzYwXSAgIFs8YzA2Nzc0MmI+XSBibGtfZG9uZV9zb2Z0aXJxKzB4MTBlLzB4
MTMzClsgICAxMS4yNDQzNjBdICAgWzxjMDI1ZjVkYj5dIF9fZG9fc29mdGlycSsweDExNC8w
eDMxOApbICAgMTEuMjQ0MzYwXSAgIFs8YzAyNWY4NTM+XSBydW5fa3NvZnRpcnFkKzB4NzQv
MHgxNzgKWyAgIDExLjI0NDM2MF0gICBbPGMwMjhmMjkwPl0gc21wYm9vdF90aHJlYWRfZm4r
MHgzMTgvMHgzNDgKWyAgIDExLjI0NDM2MF0gICBbPGMwMjg1NDFlPl0ga3RocmVhZCsweDEz
Mi8weDE0NQpbICAgMTEuMjQ0MzYwXSAgIFs8YzE1NGJkZjc+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MWIvMHgyOApbICAgMTEuMjQ0MzYwXSBpcnEgZXZlbnQgc3RhbXA6IDIxOTgK
WyAgIDExLjI0NDM2MF0gaGFyZGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoMjE5NSk6IFs8YzE1
NGEwOTk+XSBfcmF3X3NwaW5fdW5sb2NrX2lycSsweDVhLzB4YmEKWyAgIDExLjI0NDM2MF0g
aGFyZGlycXMgbGFzdCBkaXNhYmxlZCBhdCAoMjE5Nik6IFs8YzA2NmY3MmI+XSBibGtfZmx1
c2hfcGx1Z19saXN0KzB4MWZmLzB4NDQ3ClsgICAxMS4yNDQzNjBdIHNvZnRpcnFzIGxhc3Qg
IGVuYWJsZWQgYXQgKDIxOTgpOiBbPGMwNjhlZjdhPl0gX19jZnFfc2V0X2FjdGl2ZV9xdWV1
ZSsweDExMC8weDI3ZApbICAgMTEuMjQ0MzYwXSBzb2Z0aXJxcyBsYXN0IGRpc2FibGVkIGF0
ICgyMTk3KTogWzxjMDY4ZWY0Mz5dIF9fY2ZxX3NldF9hY3RpdmVfcXVldWUrMHhkOS8weDI3
ZApbICAgMTEuMjQ0MzYwXSAKWyAgIDExLjI0NDM2MF0gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0
IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgIDExLjI0NDM2MF0gIFBvc3NpYmxlIHVuc2FmZSBs
b2NraW5nIHNjZW5hcmlvOgpbICAgMTEuMjQ0MzYwXSAKWyAgIDExLjI0NDM2MF0gICAgICAg
IENQVTAKWyAgIDExLjI0NDM2MF0gICAgICAgIC0tLS0KWyAgIDExLjI0NDM2MF0gICBsb2Nr
KCYoJnEtPl9fcXVldWVfbG9jayktPnJsb2NrKTsKWyAgIDExLjI0NDM2MF0gICA8SW50ZXJy
dXB0PgpbICAgMTEuMjQ0MzYwXSAgICAgbG9jaygmKCZxLT5fX3F1ZXVlX2xvY2spLT5ybG9j
ayk7ClsgICAxMS4yNDQzNjBdIApbICAgMTEuMjQ0MzYwXSAgKioqIERFQURMT0NLICoqKgpb
ICAgMTEuMjQ0MzYwXSAKWyAgIDExLjI0NDM2MF0gMSBsb2NrIGhlbGQgYnkgYmxraWQvMjgw
OgpbICAgMTEuMjQ0MzYwXSAgIzA6ICAoJigmcS0+X19xdWV1ZV9sb2NrKS0+cmxvY2speysu
Py4uLn0sIGF0OiBbPGMwNjZmN2QwPl0gYmxrX2ZsdXNoX3BsdWdfbGlzdCsweDJhNC8weDQ0
NwpbICAgMTEuMjQ0MzYwXSAKWyAgIDExLjI0NDM2MF0gc3RhY2sgYmFja3RyYWNlOgpbICAg
MTEuMjQ0MzYwXSBDUFU6IDAgUElEOiAyODAgQ29tbTogYmxraWQgVGFpbnRlZDogRyAgICAg
ICAgVyAgICAzLjEzLjAtcmMyLTAwMjgzLWc1ZWU1NDA2ICMxMDUKWyAgIDExLjI0NDM2MF0g
SGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAg
MTEuMjQ0MzYwXSAgMDAwMDAwMDAgYzhlOGZiNzggYzE1MzJiM2MgYzhlOGZiOTggYzE1MmQ5
ZDcgYzFhNTlhNDEgYzFhNTk4MTkgYzFhNWE2OWMKWyAgIDExLjI0NDM2MF0gIDAwMDAwMDA2
IGM4ZTg4NjEwIDAwMDAwMDQwIGM4ZThmYmMwIGMwMmE1ZTU1IDAwMDAwMDA2IDAwMDAwMDAw
IGMwMmEyZjFkClsgICAxMS4yNDQzNjBdICAwMDAwMDAwNCBjOGU4ODI5MCBjOGU4ODYxMCBj
OGU4ODI5MCAwMDAwMDAwMCBjOGU4ZmJlMCBjMDJhOTM5NyBiYmI1M2RlYQpbICAgMTEuMjQ0
MzYwXSBDYWxsIFRyYWNlOgpbICAgMTEuMjQ0MzYwXSAgWzxjMTUzMmIzYz5dIGR1bXBfc3Rh
Y2srMHg0MC8weDVlClsgICAxMS4yNDQzNjBdICBbPGMxNTJkOWQ3Pl0gcHJpbnRfdXNhZ2Vf
YnVnKzB4NDkzLzB4NGFkClsgICAxMS4yNDQzNjBdICBbPGMwMmE1ZTU1Pl0gbWFya19sb2Nr
KzB4NTc1LzB4YTJlClsgICAxMS4yNDQzNjBdICBbPGMwMmEyZjFkPl0gPyBwcmludF9pcnFf
aW52ZXJzaW9uX2J1ZysweDM3NC8weDM3NApbICAgMTEuMjQ0MzYwXSAgWzxjMDJhOTM5Nz5d
IG1hcmtfaGVsZF9sb2NrcysweDE2My8weDE5OQpbICAgMTEuMjQ0MzYwXSAgWzxjMDI1ZmVi
NT5dID8gbG9jYWxfYmhfZW5hYmxlKzB4MWMyLzB4MjBlClsgICAxMS4yNDQzNjBdICBbPGMw
MmE5NzM4Pl0gdHJhY2VfaGFyZGlycXNfb25fY2FsbGVyKzB4MzZiLzB4M2IxClsgICAxMS4y
NDQzNjBdICBbPGMwNjhlZjdhPl0gPyBfX2NmcV9zZXRfYWN0aXZlX3F1ZXVlKzB4MTEwLzB4
MjdkClsgICAxMS4yNDQzNjBdICBbPGMwMmE5N2E1Pl0gdHJhY2VfaGFyZGlycXNfb24rMHgy
Ny8weDM3ClsgICAxMS4yNDQzNjBdICBbPGMwMjVmZWI1Pl0gbG9jYWxfYmhfZW5hYmxlKzB4
MWMyLzB4MjBlClsgICAxMS4yNDQzNjBdICBbPGMwNjhlZjdhPl0gX19jZnFfc2V0X2FjdGl2
ZV9xdWV1ZSsweDExMC8weDI3ZApbICAgMTEuMjQ0MzYwXSAgWzxjMDY4MDAyZj5dID8gZGlz
a19zZXFmX3N0YXJ0KzB4MTQvMHhkMApbICAgMTEuMjQ0MzYwXSAgWzxjMDY5MTU4ZD5dID8g
Y2ZxX3Jlc29ydF9ycl9saXN0KzB4NDkvMHg1YgpbICAgMTEuMjQ0MzYwXSAgWzxjMDY5MTY3
ZD5dID8gY2ZxX2FkZF9jZnFxX3JyKzB4ZGUvMHhmMwpbICAgMTEuMjQ0MzYwXSAgWzxjMDY5
MWE0Yj5dID8gY2ZxX3VwZGF0ZV9pZGxlX3dpbmRvdy5pc3JhLjc4KzB4ZjIvMHgxZjQKWyAg
IDExLjI0NDM2MF0gIFs8YzAyOTRkZDA+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweDFjNC8weDFm
OQpbICAgMTEuMjQ0MzYwXSAgWzxjMDI5ZmJiZj5dID8gdHJhY2VfaGFyZGlycXNfb2ZmKzB4
MjcvMHgzNwpbICAgMTEuMjQ0MzYwXSAgWzxjMDI5NGYwND5dID8gbG9jYWxfY2xvY2srMHhm
Zi8weDE3NgpbICAgMTEuMjQ0MzYwXSAgWzxjMDY5NWZkYj5dIGNmcV9kaXNwYXRjaF9yZXF1
ZXN0cysweGI5Mi8weDExYjAKWyAgIDExLjI0NDM2MF0gIFs8YzAyNDgxMmY+XSA/IGt2bV9j
bG9ja19yZWFkKzB4MzAvMHg1NQpbICAgMTEuMjQ0MzYwXSAgWzxjMDIwZjU1OT5dID8gc2No
ZWRfY2xvY2srMHgzZS8weDUwClsgICAxMS4yNDQzNjBdICBbPGMwNjkzZmQ4Pl0gPyBjZnFf
aW5zZXJ0X3JlcXVlc3QrMHgzYzkvMHg4NjkKWyAgIDExLjI0NDM2MF0gIFs8YzAyOWZiYmY+
XSA/IHRyYWNlX2hhcmRpcnFzX29mZisweDI3LzB4MzcKWyAgIDExLjI0NDM2MF0gIFs8YzAy
YTc4YjI+XSA/IF9fbG9ja19hY3F1aXJlKzB4MTVhNC8weDE2Y2EKWyAgIDExLjI0NDM2MF0g
IFs8YzA2YWY2YWY+XSA/IGxpc3Rfc29ydCsweDFmYi8weDI1MwpbICAgMTEuMjQ0MzYwXSAg
WzxjMDY2ZWZkZj5dIGJsa19wZWVrX3JlcXVlc3QrMHg5ZS8weDMxYQpbICAgMTEuMjQ0MzYw
XSAgWzxjMGI1N2U5Yz5dIHNjc2lfcmVxdWVzdF9mbisweDYyLzB4ODllClsgICAxMS4yNDQz
NjBdICBbPGMwNjZmN2QwPl0gPyBibGtfZmx1c2hfcGx1Z19saXN0KzB4MmE0LzB4NDQ3Clsg
ICAxMS4yNDQzNjBdICBbPGMwNjY5ZGJmPl0gX19ibGtfcnVuX3F1ZXVlKzB4NTUvMHg2Ywpb
ICAgMTEuMjQ0MzYwXSAgWzxjMDY2ZDQ1Yj5dIHF1ZXVlX3VucGx1Z2dlZC5pc3JhLjI5KzB4
NDAvMHg2YQpbICAgMTEuMjQ0MzYwXSAgWzxjMDY2Zjg5Mj5dIGJsa19mbHVzaF9wbHVnX2xp
c3QrMHgzNjYvMHg0NDcKWyAgIDExLjI0NDM2MF0gIFs8YzA2NmY5OGU+XSBibGtfZmluaXNo
X3BsdWcrMHgxYi8weDUxClsgICAxMS4yNDQzNjBdICBbPGMwMzI3YWY0Pl0gX19kb19wYWdl
X2NhY2hlX3JlYWRhaGVhZCsweDMxNC8weDM2NApbICAgMTEuMjQ0MzYwXSAgWzxjMDMyN2M0
MD5dIGZvcmNlX3BhZ2VfY2FjaGVfcmVhZGFoZWFkKzB4OWUvMHhlYQpbICAgMTEuMjQ0MzYw
XSAgWzxjMDMyODI0Nz5dIHBhZ2VfY2FjaGVfc3luY19yZWFkYWhlYWQrMHg1ZC8weDkxClsg
ICAxMS4yNDQzNjBdICBbPGMwMzE5YjE5Pl0gZ2VuZXJpY19maWxlX2Fpb19yZWFkKzB4Mzkz
LzB4YjdlClsgICAxMS4yNDQzNjBdICBbPGMwM2M4MTRhPl0gYmxrZGV2X2Fpb19yZWFkKzB4
OTUvMHhiMQpbICAgMTEuMjQ0MzYwXSAgWzxjMDM3NjRjZD5dIGRvX3N5bmNfcmVhZCsweDVh
LzB4YWIKWyAgIDExLjI0NDM2MF0gIFs8YzAzNzY0NzM+XSA/IGRvX3N5bmNfd3JpdGUrMHhh
Yi8weGFiClsgICAxMS4yNDQzNjBdICBbPGMwMzc3MTQ4Pl0gdmZzX3JlYWQrMHhkMy8weDFl
ZQpbICAgMTEuMjQ0MzYwXSAgWzxjMDM3NzQ2Yz5dIFN5U19yZWFkKzB4NzMvMHhlOApbICAg
MTEuMjQ0MzYwXSAgWzxjMTU0YmU4YT5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDNjClsg
ICAxMS40NTE3OTBdIGluaXQ6IEZhaWxlZCB0byBjcmVhdGUgcHR5IC0gZGlzYWJsaW5nIGxv
Z2dpbmcgZm9yIGpvYgpbICAgMTEuNDY3NzI4XSBpbml0OiBUZW1wb3JhcnkgcHJvY2VzcyBz
cGF3biBlcnJvcjogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQpbICAgMTEuNzU5NjIzXSBp
bml0OiBmYWlsc2FmZSBtYWluIHByb2Nlc3MgKDI4Nikga2lsbGVkIGJ5IFRFUk0gc2lnbmFs
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0LzVlZTU0MDYxM2RiNTA0YTEw
ZTE1ZmFmYWY0YzA4Y2FjOTZhYTE4MjMvZG1lc2ctcXVhbnRhbC1zdG9ha2xleS0xOjIwMTQw
MzA4MDY1NzQzOmkzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNDozLjEzLjAtcmMyLTAwMjgz
LWc1ZWU1NDA2OjEwNQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC81ZWU1
NDA2MTNkYjUwNGExMGUxNWZhZmFmNGMwOGNhYzk2YWExODIzL2RtZXNnLXF1YW50YWwtc3Rv
YWtsZXktMzoyMDE0MDMwODA2NTc0NjppMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6My4x
My4wLXJjMi0wMDI4My1nNWVlNTQwNjoxMDUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDMwNzA2MzQvNWVlNTQwNjEzZGI1MDRhMTBlMTVmYWZhZjRjMDhjYWM5NmFhMTgyMy9kbWVz
Zy1xdWFudGFsLXN0b2FrbGV5LTc6MjAxNDAzMDgwNjU3NTM6aTM4Ni1yYW5kY29uZmlnLXgx
LTAzMDcwNjM0OjMuMTMuMC1yYzItMDAyODMtZzVlZTU0MDY6MTA1CjA6MzozIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTA4IDA2OjU4OjI4IFJFUEVBVCBD
T1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0G1sw
bQoKQmlzZWN0aW5nOiAxOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgNSBzdGVwcykKWzI5YmU2MzQ1YmJhZWM4NTAyYTcwYzRlMjIwNGQ1ODE4YjQ4YzRl
OGZdIE1lcmdlIHRhZyAnbmZzLWZvci0zLjEzLTMnIG9mIGdpdDovL2dpdC5saW51eC1uZnMu
b3JnL3Byb2plY3RzL3Ryb25kbXkvbGludXgtbmZzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWcteDEtMDMwNzA2MzQvbmV4dDptYXN0ZXI6MjliZTYzNDViYmFlYzg1MDJhNzBjNGUyMjA0
ZDU4MThiNDhjNGU4ZjpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA4LTA2OjU4OjI5IDI5YmU2
MzQ1YmJhZWM4NTAyYTcwYzRlMjIwNGQ1ODE4YjQ4YzRlOGYgY29tcGlsaW5nCjE0MyByZWFs
ICAyODIgdXNlciAgMzIgc3lzICAyMjAuMTglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgxLTAz
MDcwNjM0CgoyMDE0LTAzLTA4LTA3OjAyOjQyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTMu
MC1yYzItMDAyNzUtZzI5YmU2MzQuLgkyCTgJMTEJMTcJMTkJMjAgU1VDQ0VTUwoKbGluZWFy
LWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgYnJhbmNoICdmb3ItbGludXMnIG9mIGdpdDov
L2dpdC5rZXJuZWwuZGsvbGludXgtYmxvY2sKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIg
dG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDVlZTU0MDYx
M2RiNTA0YTEwZTE1ZmFmYWY0YzA4Y2FjOTZhYTE4MjMgMjliZTYzNDViYmFlYzg1MDJhNzBj
NGUyMjA0ZDU4MThiNDhjNGU4ZiAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAyOWJl
NjM0Li4uIE1lcmdlIHRhZyAnbmZzLWZvci0zLjEzLTMnIG9mIGdpdDovL2dpdC5saW51eC1u
ZnMub3JnL3Byb2plY3RzL3Ryb25kbXkvbGludXgtbmZzCkhFQUQgaXMgbm93IGF0IGZiZTkz
OGUuLi4gTWVyZ2UgJ2FybS1zb2MvbmV4dC9kcml2ZXJzJyBpbnRvIGRldmVsLWhvdXJseS0y
MDE0MDMwNjE4CkJpc2VjdGluZzogMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMiBzdGVwcykKW2UzNDVkNzY3ZjY1MzBlYzljYjBhYWJhYjdlYTI0ODA3
MmE5YzY5NzVdIE1lcmdlIGJyYW5jaCAnc3RhYmxlL2Zvci1qZW5zLTMuMTMtdGFrZS10d28n
IG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC94ZW4v
dGlwIGludG8gZm9yLWxpbnVzCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9s
aW51eDQvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0
L25leHQ6bWFzdGVyOmUzNDVkNzY3ZjY1MzBlYzljYjBhYWJhYjdlYTI0ODA3MmE5YzY5NzU6
YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0wOC0wNzoxMTo0NSBlMzQ1ZDc2N2Y2NTMwZWM5Y2Iw
YWFiYWI3ZWEyNDgwNzJhOWM2OTc1IGNvbXBpbGluZwo3MjUgcmVhbCAgNDU4NyB1c2VyICAz
NDkgc3lzICA2ODAuNzUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0CgoyMDE0
LTAzLTA4LTA3OjI1OjEwIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC0xMDg4Mi1nZTM0
NWQ3Ni4uIFRFU1QgRkFJTFVSRQpbICAgIDUuNzk1MjA5XSBpbml0OiBGYWlsZWQgdG8gY3Jl
YXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKWyAgICA1LjgwNDMwM10gaW5p
dDogRmFpbGVkIHRvIGNyZWF0ZSBwdHkgLSBkaXNhYmxpbmcgbG9nZ2luZyBmb3Igam9iClsg
ICAgNi41NDcxODRdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAg
IDYuNTQ3MjIyXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAyNzggYXQgL2tlcm5lbC10ZXN0cy9s
aW51eDQva2VybmVsL3NvZnRpcnEuYzoxNTYgbG9jYWxfYmhfZW5hYmxlKzB4YmYvMHgyMGUo
KQpbICAgIDYuNTQ3MjI2XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICA2LjU0NzIzMF0gQ1BV
OiAwIFBJRDogMjc4IENvbW06IGJsa2lkIE5vdCB0YWludGVkIDMuMTIuMC0xMDg4Mi1nZTM0
NWQ3NiAjMTA3ClsgICAgNi41NDcyMzJdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBC
SU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICA2LjU0NzI0MV0gIDAwMDAwMDAwIGM1MzM1YmQw
IGMxNTJiNTEyIGM1MzM1YmU4IGMwMjU5MTM1IGMwMjVmZGIyIGMwNjhlMDgzIDAwMDAwMDAw
ClsgICAgNi41NDcyNTBdICBjNTZkOWMwMCBjNTMzNWJmOCBjMDI1OTFhMSAwMDAwMDAwOSAw
MDAwMDAwMCBjNTMzNWMwNCBjMDI1ZmRiMiAwMDAwMDAwMApbICAgIDYuNTQ3MjU2XSAgYzUz
MzVjYWMgYzA2OGUwODMgMDAwMDAwMDEgMDAwMDAwMDAgYzU2ZDUwMDAgYzU3YmY4NDAgYzU2
ZDljMDAgYzA2ODAwMmYKWyAgICA2LjU0NzI1N10gQ2FsbCBUcmFjZToKWyAgICA2LjU0NzI4
M10gIFs8YzE1MmI1MTI+XSBkdW1wX3N0YWNrKzB4NDAvMHg1ZQpbICAgIDYuNTQ3Mjg3XSAg
WzxjMDI1OTEzNT5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4YTkvMHhlYQpbICAgIDYuNTQ3
MjkxXSAgWzxjMDI1ZmRiMj5dID8gbG9jYWxfYmhfZW5hYmxlKzB4YmYvMHgyMGUKWyAgICA2
LjU0NzI5M10gIFs8YzA2OGUwODM+XSA/IF9fY2ZxX3NldF9hY3RpdmVfcXVldWUrMHgxMTAv
MHgyN2QKWyAgICA2LjU0NzI5M10gIFs8YzAyNTkxYTE+XSB3YXJuX3Nsb3dwYXRoX251bGwr
MHgyYi8weDNkClsgICAgNi41NDcyOTNdICBbPGMwMjVmZGIyPl0gbG9jYWxfYmhfZW5hYmxl
KzB4YmYvMHgyMGUKWyAgICA2LjU0NzI5M10gIFs8YzA2OGUwODM+XSBfX2NmcV9zZXRfYWN0
aXZlX3F1ZXVlKzB4MTEwLzB4MjdkClsgICAgNi41NDcyOTNdICBbPGMwNjgwMDJmPl0gPyBh
ZGRfZGlzaysweDIzZi8weDc4MQpbICAgIDYuNTQ3MjkzXSAgWzxjMDY5MDY5Nj5dID8gY2Zx
X3Jlc29ydF9ycl9saXN0KzB4NDkvMHg1YgpbICAgIDYuNTQ3MjkzXSAgWzxjMDY5MDc4Nj5d
ID8gY2ZxX2FkZF9jZnFxX3JyKzB4ZGUvMHhmMwpbICAgIDYuNTQ3MjkzXSAgWzxjMDY5MGI1
ND5dID8gY2ZxX3VwZGF0ZV9pZGxlX3dpbmRvdy5pc3JhLjc4KzB4ZjIvMHgxZjQKWyAgICA2
LjU0NzI5M10gIFs8YzAyOTRkMTk+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweDFjNC8weDFmOQpb
ICAgIDYuNTQ3MjkzXSAgWzxjMDI5ZmIwOD5dID8gdHJhY2VfaGFyZGlycXNfb2ZmKzB4Mjcv
MHgzNwpbICAgIDYuNTQ3MjkzXSAgWzxjMDI5NGU0ZD5dID8gbG9jYWxfY2xvY2srMHhmZi8w
eDE3NgpbICAgIDYuNTQ3MjkzXSAgWzxjMDY5NTBlND5dIGNmcV9kaXNwYXRjaF9yZXF1ZXN0
cysweGI5Mi8weDExYjAKWyAgICA2LjU0NzI5M10gIFs8YzAyNDgxMmY+XSA/IGt2bV9jbG9j
a19yZWFkKzB4MzAvMHg1NQpbICAgIDYuNTQ3MjkzXSAgWzxjMDIwZjU1OT5dID8gc2NoZWRf
Y2xvY2srMHgzZS8weDUwClsgICAgNi41NDcyOTNdICBbPGMwNjkzMGUxPl0gPyBjZnFfaW5z
ZXJ0X3JlcXVlc3QrMHgzYzkvMHg4NjkKWyAgICA2LjU0NzI5M10gIFs8YzAyOWZiMDg+XSA/
IHRyYWNlX2hhcmRpcnFzX29mZisweDI3LzB4MzcKWyAgICA2LjU0NzI5M10gIFs8YzAyYTc3
ZmI+XSA/IF9fbG9ja19hY3F1aXJlKzB4MTVhNC8weDE2Y2EKWyAgICA2LjU0NzI5M10gIFs8
YzA2YWViOGY+XSA/IGxpc3Rfc29ydCsweDFmYi8weDI1MwpbICAgIDYuNTQ3MjkzXSAgWzxj
MDY2ZTEwYz5dIGJsa19wZWVrX3JlcXVlc3QrMHg5ZS8weDMxYQpbICAgIDYuNTQ3MjkzXSAg
WzxjMGI1MjJhZj5dIHNjc2lfcmVxdWVzdF9mbisweDYyLzB4ODllClsgICAgNi41NDcyOTNd
ICBbPGMwNjZlOGZkPl0gPyBibGtfZmx1c2hfcGx1Z19saXN0KzB4MmE0LzB4NDQ3ClsgICAg
Ni41NDcyOTNdICBbPGMwNjY4ZWVjPl0gX19ibGtfcnVuX3F1ZXVlKzB4NTUvMHg2YwpbICAg
IDYuNTQ3MjkzXSAgWzxjMDY2YzU4OD5dIHF1ZXVlX3VucGx1Z2dlZC5pc3JhLjI5KzB4NDAv
MHg2YQpbICAgIDYuNTQ3MjkzXSAgWzxjMDY2ZTliZj5dIGJsa19mbHVzaF9wbHVnX2xpc3Qr
MHgzNjYvMHg0NDcKWyAgICA2LjU0NzI5M10gIFs8YzA2NmVhYmI+XSBibGtfZmluaXNoX3Bs
dWcrMHgxYi8weDUxClsgICAgNi41NDcyOTNdICBbPGMwMzI3NWUzPl0gX19kb19wYWdlX2Nh
Y2hlX3JlYWRhaGVhZCsweDMxNC8weDM2NApbICAgIDYuNTQ3MjkzXSAgWzxjMDMyNzcyZj5d
IGZvcmNlX3BhZ2VfY2FjaGVfcmVhZGFoZWFkKzB4OWUvMHhlYQpbICAgIDYuNTQ3MjkzXSAg
WzxjMDMyN2QzNj5dIHBhZ2VfY2FjaGVfc3luY19yZWFkYWhlYWQrMHg1ZC8weDkxClsgICAg
Ni41NDcyOTNdICBbPGMwMzE5NjA4Pl0gZ2VuZXJpY19maWxlX2Fpb19yZWFkKzB4MzkzLzB4
YjdlClsgICAgNi41NDcyOTNdICBbPGMwM2M3YmI5Pl0gYmxrZGV2X2Fpb19yZWFkKzB4OTUv
MHhiMQpbICAgIDYuNTQ3MjkzXSAgWzxjMDM3NWVjMD5dIGRvX3N5bmNfcmVhZCsweDVhLzB4
YWIKWyAgICA2LjU0NzI5M10gIFs8YzAzNzVlNjY+XSA/IGRvX3N5bmNfd3JpdGUrMHhhYi8w
eGFiClsgICAgNi41NDcyOTNdICBbPGMwMzc2YjNiPl0gdmZzX3JlYWQrMHhkMy8weDFlZQpb
ICAgIDYuNTQ3MjkzXSAgWzxjMDM3NmU1Zj5dIFN5U19yZWFkKzB4NzMvMHhlOApbICAgIDYu
NTQ3MjkzXSAgWzxjMTU0NDc0YT5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDNjClsgICAg
Ni41NDcyOTNdIC0tLVsgZW5kIHRyYWNlIDBiMjAxN2UwNDE0NTMxM2UgXS0tLQpbICAgIDYu
NTQ3MjkzXSAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvZTM0NWQ3Njdm
NjUzMGVjOWNiMGFhYmFiN2VhMjQ4MDcyYTljNjk3NS9kbWVzZy1xdWFudGFsLWlubi0yMDoy
MDE0MDMwODA3MjU0MjppMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC9lMzQ1ZDc2N2Y2NTMwZWM5Y2IwYWFiYWI3ZWEy
NDgwNzJhOWM2OTc1L2RtZXNnLXF1YW50YWwtaW5uLTM2OjIwMTQwMzA4MDcyNTQ1OmkzODYt
cmFuZGNvbmZpZy14MS0wMzA3MDYzNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAz
MDcwNjM0L2UzNDVkNzY3ZjY1MzBlYzljYjBhYWJhYjdlYTI0ODA3MmE5YzY5NzUvZG1lc2ct
cXVhbnRhbC1yb2FtLTE3OjIwMTQwMzA4MDcyNTQ2OmkzODYtcmFuZGNvbmZpZy14MS0wMzA3
MDYzNDozLjEyLjAtMTA4ODItZ2UzNDVkNzY6MTA3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXgxLTAzMDcwNjM0L2UzNDVkNzY3ZjY1MzBlYzljYjBhYWJhYjdlYTI0ODA3MmE5YzY5NzUv
ZG1lc2ctcXVhbnRhbC1yb2FtLTMzOjIwMTQwMzA4MDcyNTQ3OmkzODYtcmFuZGNvbmZpZy14
MS0wMzA3MDYzNDozLjEyLjAtMTA4ODItZ2UzNDVkNzY6MTA3Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTAzMDcwNjM0L2UzNDVkNzY3ZjY1MzBlYzljYjBhYWJhYjdlYTI0ODA3MmE5
YzY5NzUvZG1lc2ctcXVhbnRhbC14aWFuLTQ4OjIwMTQwMzA4MDcyNTUyOmkzODYtcmFuZGNv
bmZpZy14MS0wMzA3MDYzNDozLjEyLjAtMTA4ODItZ2UzNDVkNzY6MTA3CjA6NTo1IGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTA4IDA3OjI2OjE0IFJFUEVB
VCBDT1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0
G1swbQoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSAxIHN0ZXApCltjMTcwYmJiNDVmZWJjMDNhYzRkMzRiYTJiOGJiNTVlMDYxMDRi
N2U3XSBibG9jazogc3VibWl0X2Jpb193YWl0KCkgY29udmVyc2lvbnMKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMv
bGludXg0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC9uZXh0Om1hc3RlcjpjMTcwYmJiNDVmZWJjMDNh
YzRkMzRiYTJiOGJiNTVlMDYxMDRiN2U3OmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDgtMDc6
MjY6MjAgYzE3MGJiYjQ1ZmViYzAzYWM0ZDM0YmEyYjhiYjU1ZTA2MTA0YjdlNyBjb21waWxp
bmcKMzUyIHJlYWwgIDI2NCB1c2VyICAzMSBzeXMgIDg0LjA4JSBjcHUgCWkzODYtcmFuZGNv
bmZpZy14MS0wMzA3MDYzNAoKMjAxNC0wMy0wOC0wNzozMzoyNyBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEyLjAtMTA4NzktZ2MxNzBiYmIuLi4uLiBURVNUIEZBSUxVUkUKWyAgIDI1LjIw
MDE5M10gWyBJTkZPOiBpbmNvbnNpc3RlbnQgbG9jayBzdGF0ZSBdClsgICAyNS4yMDAxOTNd
IDMuMTIuMC0xMDg3OS1nYzE3MGJiYiAjMTA4IFRhaW50ZWQ6IEcgICAgICAgIFcgICAKWyAg
IDI1LjIwMDE5M10gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAyNS4y
MDAxOTNdIGluY29uc2lzdGVudCB7SU4tU09GVElSUS1XfSAtPiB7U09GVElSUS1PTi1XfSB1
c2FnZS4KWyAgIDI1LjIwMDE5M10gYmxraWQvMjc5IFtIQzBbMF06U0MwWzBdOkhFMTpTRTFd
IHRha2VzOgpbICAgMjUuMjAwMTkzXSAgKCYoJnEtPl9fcXVldWVfbG9jayktPnJsb2NrKXsr
Lj8uLi59LCBhdDogWzxjMDY2ZThmZD5dIGJsa19mbHVzaF9wbHVnX2xpc3QrMHgyYTQvMHg0
NDcKWyAgIDI1LjIwMDE5M10ge0lOLVNPRlRJUlEtV30gc3RhdGUgd2FzIHJlZ2lzdGVyZWQg
YXQ6ClsgICAyNS4yMDAxOTNdICAgWzxjMDJhNzEwMj5dIF9fbG9ja19hY3F1aXJlKzB4ZWFi
LzB4MTZjYQpbICAgMjUuMjAwMTkzXSAgIFs8YzAyYTdhMDc+XSBsb2NrX2FjcXVpcmUrMHhl
Ni8weDE0NwpbICAgMjUuMjAwMTkzXSAgIFs8YzE1NDIzMjA+XSBfcmF3X3NwaW5fbG9jaysw
eDRlLzB4ZWUKWyAgIDI1LjIwMDE5M10gICBbPGMwYjUyYmQ5Pl0gc2NzaV9kZXZpY2VfdW5i
dXN5KzB4ZWUvMHgxMzQKWyAgIDI1LjIwMDE5M10gICBbPGMwYjQ3ZDEyPl0gc2NzaV9maW5p
c2hfY29tbWFuZCsweDJiLzB4MTA3ClsgICAyNS4yMDAxOTNdICAgWzxjMGI1MmYyZj5dIHNj
c2lfc29mdGlycV9kb25lKzB4MWI1LzB4MWNiClsgICAyNS4yMDAxOTNdICAgWzxjMDY3NjU1
OD5dIGJsa19kb25lX3NvZnRpcnErMHgxMGUvMHgxMzMKWyAgIDI1LjIwMDE5M10gICBbPGMw
MjVmNWRiPl0gX19kb19zb2Z0aXJxKzB4MTE0LzB4MzE4ClsgICAyNS4yMDAxOTNdICAgWzxj
MDI1Zjg1Mz5dIHJ1bl9rc29mdGlycWQrMHg3NC8weDE3OApbICAgMjUuMjAwMTkzXSAgIFs8
YzAyOGYxZDk+XSBzbXBib290X3RocmVhZF9mbisweDMxOC8weDM0OApbICAgMjUuMjAwMTkz
XSAgIFs8YzAyODUzNjc+XSBrdGhyZWFkKzB4MTMyLzB4MTQ1ClsgICAyNS4yMDAxOTNdICAg
WzxjMTU0NDZiNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAyNS4y
MDAxOTNdIGlycSBldmVudCBzdGFtcDogMjM0OApbICAgMjUuMjAwMTkzXSBoYXJkaXJxcyBs
YXN0ICBlbmFibGVkIGF0ICgyMzQ1KTogWzxjMTU0NDFiOT5dIHJlc3RvcmVfYWxsX25vdHJh
Y2UrMHgwLzB4MTgKWyAgIDI1LjIwMDE5M10gaGFyZGlycXMgbGFzdCBkaXNhYmxlZCBhdCAo
MjM0Nik6IFs8YzA2NmU4NTg+XSBibGtfZmx1c2hfcGx1Z19saXN0KzB4MWZmLzB4NDQ3Clsg
ICAyNS4yMDAxOTNdIHNvZnRpcnFzIGxhc3QgIGVuYWJsZWQgYXQgKDIzNDgpOiBbPGMwNjhl
MDgzPl0gX19jZnFfc2V0X2FjdGl2ZV9xdWV1ZSsweDExMC8weDI3ZApbICAgMjUuMjAwMTkz
XSBzb2Z0aXJxcyBsYXN0IGRpc2FibGVkIGF0ICgyMzQ3KTogWzxjMDY4ZTA0Yz5dIF9fY2Zx
X3NldF9hY3RpdmVfcXVldWUrMHhkOS8weDI3ZApbICAgMjUuMjAwMTkzXSAKWyAgIDI1LjIw
MDE5M10gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgIDI1
LjIwMDE5M10gIFBvc3NpYmxlIHVuc2FmZSBsb2NraW5nIHNjZW5hcmlvOgpbICAgMjUuMjAw
MTkzXSAKWyAgIDI1LjIwMDE5M10gICAgICAgIENQVTAKWyAgIDI1LjIwMDE5M10gICAgICAg
IC0tLS0KWyAgIDI1LjIwMDE5M10gICBsb2NrKCYoJnEtPl9fcXVldWVfbG9jayktPnJsb2Nr
KTsKWyAgIDI1LjIwMDE5M10gICA8SW50ZXJydXB0PgpbICAgMjUuMjAwMTkzXSAgICAgbG9j
aygmKCZxLT5fX3F1ZXVlX2xvY2spLT5ybG9jayk7ClsgICAyNS4yMDAxOTNdIApbICAgMjUu
MjAwMTkzXSAgKioqIERFQURMT0NLICoqKgpbICAgMjUuMjAwMTkzXSAKWyAgIDI1LjIwMDE5
M10gMSBsb2NrIGhlbGQgYnkgYmxraWQvMjc5OgpbICAgMjUuMjAwMTkzXSAgIzA6ICAoJigm
cS0+X19xdWV1ZV9sb2NrKS0+cmxvY2speysuPy4uLn0sIGF0OiBbPGMwNjZlOGZkPl0gYmxr
X2ZsdXNoX3BsdWdfbGlzdCsweDJhNC8weDQ0NwpbICAgMjUuMjAwMTkzXSAKWyAgIDI1LjIw
MDE5M10gc3RhY2sgYmFja3RyYWNlOgpbICAgMjUuMjAwMTkzXSBDUFU6IDAgUElEOiAyNzkg
Q29tbTogYmxraWQgVGFpbnRlZDogRyAgICAgICAgVyAgICAzLjEyLjAtMTA4NzktZ2MxNzBi
YmIgIzEwOApbICAgMjUuMjAwMTkzXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAyNS4yMDAxOTNdICAwMDAwMDAwMCBjOGVlZGI3OCBj
MTUyYjUxMiBjOGVlZGI5OCBjMTUyNjJhMyBjMWE0ZTBjZiBjMWE0ZGVhNyBjMWE0ZWQyYQpb
ICAgMjUuMjAwMTkzXSAgMDAwMDAwMDYgYzhmNWU5YjAgMDAwMDAwNDAgYzhlZWRiYzAgYzAy
YTVkOWUgMDAwMDAwMDYgMDAwMDAwMDAgYzAyYTJlNjYKWyAgIDI1LjIwMDE5M10gIDAwMDAw
MDA0IGM4ZjVlNjMwIGM4ZjVlOWIwIGM4ZjVlNjMwIDAwMDAwMDAwIGM4ZWVkYmUwIGMwMmE5
MmUwIDdmODUxNWRlClsgICAyNS4yMDAxOTNdIENhbGwgVHJhY2U6ClsgICAyNS4yMDAxOTNd
ICBbPGMxNTJiNTEyPl0gZHVtcF9zdGFjaysweDQwLzB4NWUKWyAgIDI1LjIwMDE5M10gIFs8
YzE1MjYyYTM+XSBwcmludF91c2FnZV9idWcrMHg0OTMvMHg0YWQKWyAgIDI1LjIwMDE5M10g
IFs8YzAyYTVkOWU+XSBtYXJrX2xvY2srMHg1NzUvMHhhMmUKWyAgIDI1LjIwMDE5M10gIFs8
YzAyYTJlNjY+XSA/IHByaW50X2lycV9pbnZlcnNpb25fYnVnKzB4Mzc0LzB4Mzc0ClsgICAy
NS4yMDAxOTNdICBbPGMwMmE5MmUwPl0gbWFya19oZWxkX2xvY2tzKzB4MTYzLzB4MTk5Clsg
ICAyNS4yMDAxOTNdICBbPGMwMjVmZWI1Pl0gPyBsb2NhbF9iaF9lbmFibGUrMHgxYzIvMHgy
MGUKWyAgIDI1LjIwMDE5M10gIFs8YzAyYTk2ODE+XSB0cmFjZV9oYXJkaXJxc19vbl9jYWxs
ZXIrMHgzNmIvMHgzYjEKWyAgIDI1LjIwMDE5M10gIFs8YzA2OGUwODM+XSA/IF9fY2ZxX3Nl
dF9hY3RpdmVfcXVldWUrMHgxMTAvMHgyN2QKWyAgIDI1LjIwMDE5M10gIFs8YzAyYTk2ZWU+
XSB0cmFjZV9oYXJkaXJxc19vbisweDI3LzB4MzcKWyAgIDI1LjIwMDE5M10gIFs8YzAyNWZl
YjU+XSBsb2NhbF9iaF9lbmFibGUrMHgxYzIvMHgyMGUKWyAgIDI1LjIwMDE5M10gIFs8YzA2
OGUwODM+XSBfX2NmcV9zZXRfYWN0aXZlX3F1ZXVlKzB4MTEwLzB4MjdkClsgICAyNS4yMDAx
OTNdICBbPGMwNjgwMDJmPl0gPyBhZGRfZGlzaysweDIzZi8weDc4MQpbICAgMjUuMjAwMTkz
XSAgWzxjMDY5MDY5Nj5dID8gY2ZxX3Jlc29ydF9ycl9saXN0KzB4NDkvMHg1YgpbICAgMjUu
MjAwMTkzXSAgWzxjMDY5MDc4Nj5dID8gY2ZxX2FkZF9jZnFxX3JyKzB4ZGUvMHhmMwpbICAg
MjUuMjAwMTkzXSAgWzxjMDY5MGI1ND5dID8gY2ZxX3VwZGF0ZV9pZGxlX3dpbmRvdy5pc3Jh
Ljc4KzB4ZjIvMHgxZjQKWyAgIDI1LjIwMDE5M10gIFs8YzAyOTRkMTk+XSA/IHNjaGVkX2Ns
b2NrX2NwdSsweDFjNC8weDFmOQpbICAgMjUuMjAwMTkzXSAgWzxjMDI5ZmIwOD5dID8gdHJh
Y2VfaGFyZGlycXNfb2ZmKzB4MjcvMHgzNwpbICAgMjUuMjAwMTkzXSAgWzxjMDI5NGU0ZD5d
ID8gbG9jYWxfY2xvY2srMHhmZi8weDE3NgpbICAgMjUuMjAwMTkzXSAgWzxjMDY5NTBlND5d
IGNmcV9kaXNwYXRjaF9yZXF1ZXN0cysweGI5Mi8weDExYjAKWyAgIDI1LjIwMDE5M10gIFs8
YzAyNDgxMmY+XSA/IGt2bV9jbG9ja19yZWFkKzB4MzAvMHg1NQpbICAgMjUuMjAwMTkzXSAg
WzxjMDIwZjU1OT5dID8gc2NoZWRfY2xvY2srMHgzZS8weDUwClsgICAyNS4yMDAxOTNdICBb
PGMwNjkzMGUxPl0gPyBjZnFfaW5zZXJ0X3JlcXVlc3QrMHgzYzkvMHg4NjkKWyAgIDI1LjIw
MDE5M10gIFs8YzAyOWZiMDg+XSA/IHRyYWNlX2hhcmRpcnFzX29mZisweDI3LzB4MzcKWyAg
IDI1LjIwMDE5M10gIFs8YzAyYTc3ZmI+XSA/IF9fbG9ja19hY3F1aXJlKzB4MTVhNC8weDE2
Y2EKWyAgIDI1LjIwMDE5M10gIFs8YzA2YWViOGY+XSA/IGxpc3Rfc29ydCsweDFmYi8weDI1
MwpbICAgMjUuMjAwMTkzXSAgWzxjMDY2ZTEwYz5dIGJsa19wZWVrX3JlcXVlc3QrMHg5ZS8w
eDMxYQpbICAgMjUuMjAwMTkzXSAgWzxjMGI1MjJhZj5dIHNjc2lfcmVxdWVzdF9mbisweDYy
LzB4ODllClsgICAyNS4yMDAxOTNdICBbPGMwNjZlOGZkPl0gPyBibGtfZmx1c2hfcGx1Z19s
aXN0KzB4MmE0LzB4NDQ3ClsgICAyNS4yMDAxOTNdICBbPGMwNjY4ZWVjPl0gX19ibGtfcnVu
X3F1ZXVlKzB4NTUvMHg2YwpbICAgMjUuMjAwMTkzXSAgWzxjMDY2YzU4OD5dIHF1ZXVlX3Vu
cGx1Z2dlZC5pc3JhLjI5KzB4NDAvMHg2YQpbICAgMjUuMjAwMTkzXSAgWzxjMDY2ZTliZj5d
IGJsa19mbHVzaF9wbHVnX2xpc3QrMHgzNjYvMHg0NDcKWyAgIDI1LjIwMDE5M10gIFs8YzA2
NmVhYmI+XSBibGtfZmluaXNoX3BsdWcrMHgxYi8weDUxClsgICAyNS4yMDAxOTNdICBbPGMw
MzI3NWUzPl0gX19kb19wYWdlX2NhY2hlX3JlYWRhaGVhZCsweDMxNC8weDM2NApbICAgMjUu
MjAwMTkzXSAgWzxjMDMyNzcyZj5dIGZvcmNlX3BhZ2VfY2FjaGVfcmVhZGFoZWFkKzB4OWUv
MHhlYQpbICAgMjUuMjAwMTkzXSAgWzxjMDMyN2QzNj5dIHBhZ2VfY2FjaGVfc3luY19yZWFk
YWhlYWQrMHg1ZC8weDkxClsgICAyNS4yMDAxOTNdICBbPGMwMzE5NjA4Pl0gZ2VuZXJpY19m
aWxlX2Fpb19yZWFkKzB4MzkzLzB4YjdlClsgICAyNS4yMDAxOTNdICBbPGMwM2M3YmI5Pl0g
YmxrZGV2X2Fpb19yZWFkKzB4OTUvMHhiMQpbICAgMjUuMjAwMTkzXSAgWzxjMDM3NWVjMD5d
IGRvX3N5bmNfcmVhZCsweDVhLzB4YWIKWyAgIDI1LjIwMDE5M10gIFs8YzAzNzVlNjY+XSA/
IGRvX3N5bmNfd3JpdGUrMHhhYi8weGFiClsgICAyNS4yMDAxOTNdICBbPGMwMzc2YjNiPl0g
dmZzX3JlYWQrMHhkMy8weDFlZQpbICAgMjUuMjAwMTkzXSAgWzxjMDM3NmU1Zj5dIFN5U19y
ZWFkKzB4NzMvMHhlOApbICAgMjUuMjAwMTkzXSAgWzxjMTU0NDc0YT5dIHN5c2VudGVyX2Rv
X2NhbGwrMHgxMi8weDNjClsgICAyNS41NDM5OTRdIGluaXQ6IEZhaWxlZCB0byBjcmVhdGUg
cHR5IC0gZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpbICAgMjUuNTUxNjIwXSBpbml0OiBU
ZW1wb3JhcnkgcHJvY2VzcyBzcGF3biBlcnJvcjogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9y
eQpbICAgMjUuNjU3Mzc4XSBpbml0OiBGYWlsZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGlu
ZyBsb2dnaW5nIGZvciBqb2IKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQv
YzE3MGJiYjQ1ZmViYzAzYWM0ZDM0YmEyYjhiYjU1ZTA2MTA0YjdlNy9kbWVzZy1xdWFudGFs
LXhnd28tNjoyMDE0MDMwODA3MzUyNDppMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6My4x
Mi4wLTEwODc5LWdjMTcwYmJiOjEwOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3
MDYzNC9jMTcwYmJiNDVmZWJjMDNhYzRkMzRiYTJiOGJiNTVlMDYxMDRiN2U3L2RtZXNnLXlv
Y3RvLXNuYi0zMToyMDE0MDMwODA3MzUzOTppMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC9jMTcwYmJiNDVmZWJjMDNh
YzRkMzRiYTJiOGJiNTVlMDYxMDRiN2U3L2RtZXNnLXF1YW50YWwteGd3by00OjIwMTQwMzA4
MDczNTQzOmkzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNDozLjEyLjAtMTA4NzktZ2MxNzBi
YmI6MTA4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0L2MxNzBiYmI0NWZl
YmMwM2FjNGQzNGJhMmI4YmI1NWUwNjEwNGI3ZTcvZG1lc2cteW9jdG8tc25iLTExOjIwMTQw
MzA4MDczNTQ0OmkzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNDo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXgxLTAzMDcwNjM0L2MxNzBiYmI0NWZlYmMwM2FjNGQzNGJhMmI4YmI1NWUw
NjEwNGI3ZTcvZG1lc2cteW9jdG8tc25iLTY6MjAxNDAzMDgwNzM1NDc6aTM4Ni1yYW5kY29u
ZmlnLXgxLTAzMDcwNjM0OjoKMDo1OjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJp
c2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MCBzdGVwcykKWzJjNTc1MDI2ZmFlNmU2Mzc3MWJkMmE0YzFkNDA3MjE0YTgwOTZhODldIFVw
ZGF0ZSBvZiBibGtnX3N0YXQgYW5kIGJsa2dfcndzdGF0IG1heSBoYXBwZW4gaW4gYmggY29u
dGV4dC4gV2hpbGUgdTY0X3N0YXRzX2ZldGNoX3JldHJ5IGlzIG9ubHkgcHJlZW1wdF9kaXNh
YmxlIG9uIDMyYml0IFVQIHN5c3RlbS4gVGhpcyBpcyBub3QgZW5vdWdoIHRvIGF2b2lkIHBy
ZWVtcHRpb24gYnkgYmggYW5kIG1heSByZWFkIHN0cmFuZ2UgNjQgYml0IHZhbHVlLgpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5l
bC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0L25leHQ6bWFzdGVyOjJjNTc1MDI2
ZmFlNmU2Mzc3MWJkMmE0YzFkNDA3MjE0YTgwOTZhODk6YmlzZWN0LWxpbnV4NAoKMjAxNC0w
My0wOC0wNzozNjowMyAyYzU3NTAyNmZhZTZlNjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5
IGNvbXBpbGluZwoyNTMgcmVhbCAgMjc2IHVzZXIgIDMyIHN5cyAgMTIxLjQ5JSBjcHUgCWkz
ODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNAoKMjAxNC0wMy0wOC0wNzo0MToyNCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjEyLjAtMTA4NzgtZzJjNTc1MDIuLi4uIFRFU1QgRkFJTFVSRQpb
ICAgIDcuMzk1NjgwXSBpbml0OiBGYWlsZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBs
b2dnaW5nIGZvciBqb2IKWyAgICA3LjQwOTIwMV0gaW5pdDogRmFpbGVkIHRvIGNyZWF0ZSBw
dHkgLSBkaXNhYmxpbmcgbG9nZ2luZyBmb3Igam9iClsgICAgOC4yMTUyNjJdIC0tLS0tLS0t
LS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDguMjE1MzE4XSBXQVJOSU5HOiBD
UFU6IDAgUElEOiAyODcgYXQgL2tlcm5lbC10ZXN0cy9saW51eDQva2VybmVsL3NvZnRpcnEu
YzoxNTYgbG9jYWxfYmhfZW5hYmxlKzB4YmYvMHgyMGUoKQpbICAgIDguMjE1MzMxXSBNb2R1
bGVzIGxpbmtlZCBpbjoKWyAgICA4LjIxNTMzOF0gQ1BVOiAwIFBJRDogMjg3IENvbW06IGJs
a2lkIE5vdCB0YWludGVkIDMuMTIuMC0xMDg3OC1nMmM1NzUwMiAjMTA5ClsgICAgOC4yMTUz
NDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEK
WyAgICA4LjIxNTM1NV0gIDAwMDAwMDAwIGM1M2E1YmQwIGMxNTJiNjIyIGM1M2E1YmU4IGMw
MjU5MTM1IGMwMjVmZGIyIGMwNjhlMTk2IDAwMDAwMDAwClsgICAgOC4yMTUzNjRdICBjNTZk
YWMwMCBjNTNhNWJmOCBjMDI1OTFhMSAwMDAwMDAwOSAwMDAwMDAwMCBjNTNhNWMwNCBjMDI1
ZmRiMiAwMDAwMDAwMApbICAgIDguMjE1MzcyXSAgYzUzYTVjYWMgYzA2OGUxOTYgMDAwMDAw
MDEgMDAwMDAwMDAgYzU2ZDYwMDAgYzU3YmE4NDAgYzU2ZGFjMDAgYzA2ODAwMmYKWyAgICA4
LjIxNTM3NF0gQ2FsbCBUcmFjZToKWyAgICA4LjIxNTQwM10gIFs8YzE1MmI2MjI+XSBkdW1w
X3N0YWNrKzB4NDAvMHg1ZQpbICAgIDguMjE1NDA4XSAgWzxjMDI1OTEzNT5dIHdhcm5fc2xv
d3BhdGhfY29tbW9uKzB4YTkvMHhlYQpbICAgIDguMjE1NDEzXSAgWzxjMDI1ZmRiMj5dID8g
bG9jYWxfYmhfZW5hYmxlKzB4YmYvMHgyMGUKWyAgICA4LjIxNTQzNV0gIFs8YzA2OGUxOTY+
XSA/IF9fY2ZxX3NldF9hY3RpdmVfcXVldWUrMHgxMTAvMHgyN2QKWyAgICA4LjIxNTQ0MF0g
IFs8YzAyNTkxYTE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyYi8weDNkClsgICAgOC4yMTU0
NDRdICBbPGMwMjVmZGIyPl0gbG9jYWxfYmhfZW5hYmxlKzB4YmYvMHgyMGUKWyAgICA4LjIx
NTQ0OV0gIFs8YzA2OGUxOTY+XSBfX2NmcV9zZXRfYWN0aXZlX3F1ZXVlKzB4MTEwLzB4Mjdk
ClsgICAgOC4yMTU0NTRdICBbPGMwNjgwMDJmPl0gPyBhZGRfZGlzaysweDEyYy8weDc4MQpb
ICAgIDguMjE1NDU5XSAgWzxjMDY5MDdhOT5dID8gY2ZxX3Jlc29ydF9ycl9saXN0KzB4NDkv
MHg1YgpbICAgIDguMjE1NDYzXSAgWzxjMDY5MDg5OT5dID8gY2ZxX2FkZF9jZnFxX3JyKzB4
ZGUvMHhmMwpbICAgIDguMjE1NDY4XSAgWzxjMDY5MGM2Nz5dID8gY2ZxX3VwZGF0ZV9pZGxl
X3dpbmRvdy5pc3JhLjc4KzB4ZjIvMHgxZjQKWyAgICA4LjIxNTQ4MF0gIFs8YzAyOTRkMTk+
XSA/IHNjaGVkX2Nsb2NrX2NwdSsweDFjNC8weDFmOQpbICAgIDguMjE1NDg3XSAgWzxjMDI5
ZmIwOD5dID8gdHJhY2VfaGFyZGlycXNfb2ZmKzB4MjcvMHgzNwpbICAgIDguMjE1NDkyXSAg
WzxjMDI5NGU0ZD5dID8gbG9jYWxfY2xvY2srMHhmZi8weDE3NgpbICAgIDguMjE1NDk3XSAg
WzxjMDY5NTFmNz5dIGNmcV9kaXNwYXRjaF9yZXF1ZXN0cysweGI5Mi8weDExYjAKWyAgICA4
LjIxNTUwNF0gIFs8YzAyNDgxMmY+XSA/IGt2bV9jbG9ja19yZWFkKzB4MzAvMHg1NQpbICAg
IDguMjE1NTE1XSAgWzxjMDIwZjU1OT5dID8gc2NoZWRfY2xvY2srMHgzZS8weDUwClsgICAg
OC4yMTU1MjBdICBbPGMwNjkzMWY0Pl0gPyBjZnFfaW5zZXJ0X3JlcXVlc3QrMHgzYzkvMHg4
NjkKWyAgICA4LjIxNTUyNV0gIFs8YzAyOWZiMDg+XSA/IHRyYWNlX2hhcmRpcnFzX29mZisw
eDI3LzB4MzcKWyAgICA4LjIxNTUzMF0gIFs8YzAyYTc3ZmI+XSA/IF9fbG9ja19hY3F1aXJl
KzB4MTVhNC8weDE2Y2EKWyAgICA4LjIxNTUzOF0gIFs8YzA2YWVjOWY+XSA/IGxpc3Rfc29y
dCsweDFmYi8weDI1MwpbICAgIDguMjE1NTQ3XSAgWzxjMDY2ZTEwYz5dIGJsa19wZWVrX3Jl
cXVlc3QrMHg5ZS8weDMxYQpbICAgIDguMjE1NTY2XSAgWzxjMGI1MjNiZj5dIHNjc2lfcmVx
dWVzdF9mbisweDYyLzB4ODllClsgICAgOC4yMTU1NzFdICBbPGMwNjZlOGZkPl0gPyBibGtf
Zmx1c2hfcGx1Z19saXN0KzB4MmE0LzB4NDQ3ClsgICAgOC4yMTU1NzddICBbPGMwNjY4ZWVj
Pl0gX19ibGtfcnVuX3F1ZXVlKzB4NTUvMHg2YwpbICAgIDguMjE1NTgyXSAgWzxjMDY2YzU4
OD5dIHF1ZXVlX3VucGx1Z2dlZC5pc3JhLjI5KzB4NDAvMHg2YQpbICAgIDguMjE1NTg2XSAg
WzxjMDY2ZTliZj5dIGJsa19mbHVzaF9wbHVnX2xpc3QrMHgzNjYvMHg0NDcKWyAgICA4LjIx
NTU5MV0gIFs8YzA2NmVhYmI+XSBibGtfZmluaXNoX3BsdWcrMHgxYi8weDUxClsgICAgOC4y
MTU2MDddICBbPGMwMzI3NWUzPl0gX19kb19wYWdlX2NhY2hlX3JlYWRhaGVhZCsweDMxNC8w
eDM2NApbICAgIDguMjE1NjE0XSAgWzxjMDMyNzcyZj5dIGZvcmNlX3BhZ2VfY2FjaGVfcmVh
ZGFoZWFkKzB4OWUvMHhlYQpbICAgIDguMjE1NjIwXSAgWzxjMDMyN2QzNj5dIHBhZ2VfY2Fj
aGVfc3luY19yZWFkYWhlYWQrMHg1ZC8weDkxClsgICAgOC4yMTU2MjRdICBbPGMwMzE5NjA4
Pl0gZ2VuZXJpY19maWxlX2Fpb19yZWFkKzB4MzkzLzB4YjdlClsgICAgOC4yMTU2MzhdICBb
PGMwM2M3YmI5Pl0gYmxrZGV2X2Fpb19yZWFkKzB4OTUvMHhiMQpbICAgIDguMjE1NjQ2XSAg
WzxjMDM3NWVjMD5dIGRvX3N5bmNfcmVhZCsweDVhLzB4YWIKWyAgICA4LjIxNTY1MV0gIFs8
YzAzNzVlNjY+XSA/IGRvX3N5bmNfd3JpdGUrMHhhYi8weGFiClsgICAgOC4yMTU2NTVdICBb
PGMwMzc2YjNiPl0gdmZzX3JlYWQrMHhkMy8weDFlZQpbICAgIDguMjE1NjU5XSAgWzxjMDM3
NmU1Zj5dIFN5U19yZWFkKzB4NzMvMHhlOApbICAgIDguMjE1NjY4XSAgWzxjMTU0NDg4YT5d
IHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDNjClsgICAgOC4yMTU2NzJdIC0tLVsgZW5kIHRy
YWNlIDZmNzI2OTdmZTJkMDUwMTcgXS0tLQpbICAgIDguMjE1NzI3XSAKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMmM1NzUwMjZmYWU2ZTYzNzcxYmQyYTRjMWQ0MDcy
MTRhODA5NmE4OS9kbWVzZy1xdWFudGFsLXhwcy0xOjIwMTQwMzA4MDc0MzAxOmkzODYtcmFu
ZGNvbmZpZy14MS0wMzA3MDYzNDozLjEyLjAtMTA4NzgtZzJjNTc1MDI6MTA5Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0LzJjNTc1MDI2ZmFlNmU2Mzc3MWJkMmE0YzFk
NDA3MjE0YTgwOTZhODkvZG1lc2ctcXVhbnRhbC1zbmItMTQ6MjAxNDAzMDgwNzQzMTM6aTM4
Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEt
MDMwNzA2MzQvMmM1NzUwMjZmYWU2ZTYzNzcxYmQyYTRjMWQ0MDcyMTRhODA5NmE4OS9kbWVz
Zy1xdWFudGFsLXNuYi0zODoyMDE0MDMwODA3NDMxMzppMzg2LXJhbmRjb25maWcteDEtMDMw
NzA2MzQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC8yYzU3NTAyNmZh
ZTZlNjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5L2RtZXNnLXF1YW50YWwtc25iLTM6MjAx
NDAzMDgwNzQzMTI6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKMDo0OjQgYWxsX2dv
b2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMDggMDc6NDM6MzggUkVQRUFU
IENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0Ly5yZXBlYXQb
WzBtCgoyYzU3NTAyNmZhZTZlNjM3NzFiZDJhNGMxZDQwNzIxNGE4MDk2YTg5IGlzIHRoZSBm
aXJzdCBiYWQgY29tbWl0CmNvbW1pdCAyYzU3NTAyNmZhZTZlNjM3NzFiZDJhNGMxZDQwNzIx
NGE4MDk2YTg5CkF1dGhvcjogSG9uZyBaaGlndW8gPHpoaWd1b2hvbmdAdGVuY2VudC5jb20+
CkRhdGU6ICAgV2VkIE5vdiAyMCAxMDozNTowNSAyMDEzIC0wNzAwCgogICAgVXBkYXRlIG9m
IGJsa2dfc3RhdCBhbmQgYmxrZ19yd3N0YXQgbWF5IGhhcHBlbiBpbiBiaCBjb250ZXh0Lgog
ICAgV2hpbGUgdTY0X3N0YXRzX2ZldGNoX3JldHJ5IGlzIG9ubHkgcHJlZW1wdF9kaXNhYmxl
IG9uIDMyYml0CiAgICBVUCBzeXN0ZW0uIFRoaXMgaXMgbm90IGVub3VnaCB0byBhdm9pZCBw
cmVlbXB0aW9uIGJ5IGJoIGFuZAogICAgbWF5IHJlYWQgc3RyYW5nZSA2NCBiaXQgdmFsdWUu
CiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IEhvbmcgWmhpZ3VvIDx6aGlndW9ob25nQHRlbmNl
bnQuY29tPgogICAgQWNrZWQtYnk6IFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4KICAgIENj
OiBzdGFibGVAa2VybmVsLm9yZwogICAgU2lnbmVkLW9mZi1ieTogSmVucyBBeGJvZSA8YXhi
b2VAa2VybmVsLmRrPgoKOjA0MDAwMCAwNDAwMDAgODQzMGExMWRkYWY0NjQwNjYzYjdlZDk5
ZmVhY2IxZDNkZTEyNjMyMSA4NWI4MjdmYTMwNjMzOTBlMTA2MjhkZjRlNjZjMGY1NDk1YTI3
MDY3IE0JYmxvY2sKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvbmV4dDptYXN0ZXI6ODIw
MjNiYjdmNzViMDA1MmY0MGQzZTc0MTY5ZDE5MWMzZTRlNjI4NjpiaXNlY3QtbGludXg0Cgoy
MDE0LTAzLTA4LTA3OjQzOjQxIDgyMDIzYmI3Zjc1YjAwNTJmNDBkM2U3NDE2OWQxOTFjM2U0
ZTYyODYgY29tcGlsaW5nCgoyMDE0LTAzLTA4LTA3OjUyOjI1IGRldGVjdGluZyBib290IHN0
YXRlIDMuMTIuMC0xMDg3Ny1nODIwMjNiYi4uLgkzCTEwCTEzCTE2CTE4CTIxCTI1CTMyCTM2
CTQwCTQ3Lgk0OAk1NQk1Nwk1OQk2MCBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0L25leHQ6bWFzdGVyOjBm
ZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDM6YmlzZWN0LWxpbnV4NAog
VEVTVCBGQUlMVVJFClsgICAgMy44OTQ4NDJdIGluaXQ6IEZhaWxlZCB0byBjcmVhdGUgcHR5
IC0gZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpbICAgIDMuOTAxNDYyXSBpbml0OiBGYWls
ZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKWyAgICA0LjMx
ODY4Nl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgNC4zMTg3
MThdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDI5MCBhdCBrZXJuZWwvc29mdGlycS5jOjE0NSBf
X2xvY2FsX2JoX2VuYWJsZV9pcCsweGIzLzB4MjAyKCkKWyAgICA0LjMxODcyMF0gTW9kdWxl
cyBsaW5rZWQgaW46ClsgICAgNC4zMTg3MjVdIENQVTogMCBQSUQ6IDI5MCBDb21tOiBibGtp
ZCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmUg
IzIKWyAgICA0LjMxODcyNl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9j
aHMgMDEvMDEvMjAxMQpbICAgIDQuMzE4NzMyXSAgMDAwMDAwMDAgYzVmYjliZDAgY2E1YTdl
ZGUgYzVmYjliZTggYzkyNWM3MDYgYzkyNjMxYWYgYzk2OWI2NjMgMDAwMDAyMDAKWyAgICA0
LjMxODczNl0gIGM2MzI4MDAwIGM1ZmI5YmY4IGM5MjVjNzcyIDAwMDAwMDA5IDAwMDAwMDAw
IGM1ZmI5YzA4IGM5MjYzMWFmIDAwMDAwMDAwClsgICAgNC4zMTg3NDJdICAwMDAwMDAwMCBj
NWZiOWNiMCBjOTY5YjZkNSAwMDAwMDAwMSAwMDAwMDAwMCBjNjMyODQwMCBjNjNlZjc4OCBj
NjMyODAwMApbICAgIDQuMzE4NzQzXSBDYWxsIFRyYWNlOgpbICAgIDQuMzE4NzY0XSAgWzxj
YTVhN2VkZT5dIGR1bXBfc3RhY2srMHg0MC8weDVlClsgICAgNC4zMTg3NjddICBbPGM5MjVj
NzA2Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHhhOS8weGVhClsgICAgNC4zMTg3NzBdICBb
PGM5MjYzMWFmPl0gPyBfX2xvY2FsX2JoX2VuYWJsZV9pcCsweGIzLzB4MjAyClsgICAgNC4z
MTg3ODBdICBbPGM5NjliNjYzPl0gPyBfX2NmcV9zZXRfYWN0aXZlX3F1ZXVlKzB4MTEyLzB4
MmYxClsgICAgNC4zMTg3ODNdICBbPGM5MjVjNzcyPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4
MmIvMHgzZApbICAgIDQuMzE4Nzg2XSAgWzxjOTI2MzFhZj5dIF9fbG9jYWxfYmhfZW5hYmxl
X2lwKzB4YjMvMHgyMDIKWyAgICA0LjMxODc4OF0gIFs8Yzk2OWI2ZDU+XSBfX2NmcV9zZXRf
YWN0aXZlX3F1ZXVlKzB4MTg0LzB4MmYxClsgICAgNC4zMTg3OTFdICBbPGM5NjkwMDJmPl0g
PyBfX2RlbGV0ZV9wYXJ0aXRpb24rMHg4LzB4MzAKWyAgICA0LjMxODc5NF0gIFs8Yzk2OWUw
Mjg+XSA/IGNmcV9yZXNvcnRfcnJfbGlzdCsweDQ5LzB4NWIKWyAgICA0LjMxODc5Nl0gIFs8
Yzk2OWUxNzg+XSA/IGNmcV9hZGRfY2ZxcV9ycisweDEzZS8weDE1MwpbICAgIDQuMzE4Nzk5
XSAgWzxjOTY5ZTU0Nj5dID8gY2ZxX3VwZGF0ZV9pZGxlX3dpbmRvdy5pc3JhLjc4KzB4ZjIv
MHgyNTQKWyAgICA0LjMxODgwNV0gIFs8YzkyOTk2ZmE+XSA/IHNjaGVkX2Nsb2NrX2NwdSsw
eDE1ZC8weDE5OApbICAgIDQuMzE4ODA4XSAgWzxjOTZhMzA1YT5dIGNmcV9kaXNwYXRjaF9y
ZXF1ZXN0cysweGI5Mi8weDEyMTIKWyAgICA0LjMxODgxMl0gIFs8YzkyNGEzMGU+XSA/IGt2
bV9jbG9ja19yZWFkKzB4MzAvMHg1NQpbICAgIDQuMzE4ODE2XSAgWzxjOTIwZmQ3NT5dID8g
c2NoZWRfY2xvY2srMHgzZS8weDUwClsgICAgNC4zMTg4MTldICBbPGM5NmEwZWQ3Pl0gPyBj
ZnFfaW5zZXJ0X3JlcXVlc3QrMHg0MjkvMHg4YzkKWyAgICA0LjMxODgyM10gIFs8YzkyYWQ4
ZWU+XSA/IF9fbG9ja19hY3F1aXJlKzB4MTU3Zi8weDE2YTUKWyAgICA0LjMxODgyOV0gIFs8
Yzk2YmNjNjE+XSA/IGxpc3Rfc29ydCsweDFmYi8weDI1MwpbICAgIDQuMzE4ODM3XSAgWzxj
OTY3YWMwYz5dIGJsa19wZWVrX3JlcXVlc3QrMHg5ZS8weDMxYQpbICAgIDQuMzE4ODQ4XSAg
WzxjOWI4NjBmYj5dIHNjc2lfcmVxdWVzdF9mbisweDYyLzB4OGExClsgICAgNC4zMTg4NTFd
ICBbPGM5NjdiNDc0Pl0gPyBibGtfZmx1c2hfcGx1Z19saXN0KzB4MmE0LzB4NDQ3ClsgICAg
NC4zMTg4NTRdICBbPGM5Njc1NzdjPl0gX19ibGtfcnVuX3F1ZXVlKzB4NTUvMHg2YwpbICAg
IDQuMzE4ODU2XSAgWzxjOTY3OGYzNz5dIHF1ZXVlX3VucGx1Z2dlZC5pc3JhLjI5KzB4NDAv
MHg2YQpbICAgIDQuMzE4ODU5XSAgWzxjOTY3YjUzNj5dIGJsa19mbHVzaF9wbHVnX2xpc3Qr
MHgzNjYvMHg0NDcKWyAgICA0LjMxODg2Ml0gIFs8Yzk2N2I2MzI+XSBibGtfZmluaXNoX3Bs
dWcrMHgxYi8weDUxClsgICAgNC4zMTg4NzBdICBbPGM5MzJlZDJkPl0gX19kb19wYWdlX2Nh
Y2hlX3JlYWRhaGVhZCsweDMyNi8weDM3NgpbICAgIDQuMzE4ODczXSAgWzxjOTMyZWU1NT5d
IGZvcmNlX3BhZ2VfY2FjaGVfcmVhZGFoZWFkKzB4YTIvMHhkNgpbICAgIDQuMzE4ODc2XSAg
WzxjOTMyZjQ1Yz5dIHBhZ2VfY2FjaGVfc3luY19yZWFkYWhlYWQrMHg1ZC8weDkxClsgICAg
NC4zMTg4ODFdICBbPGM5MzIwNzQ0Pl0gZ2VuZXJpY19maWxlX2Fpb19yZWFkKzB4MzZlLzB4
YjU3ClsgICAgNC4zMTg4OTJdICBbPGM5M2QxYWZmPl0gYmxrZGV2X2Fpb19yZWFkKzB4OTUv
MHhiMQpbICAgIDQuMzE4ODk5XSAgWzxjOTM4MDIxYz5dIGRvX3N5bmNfcmVhZCsweDVhLzB4
YWIKWyAgICA0LjMxODkwMV0gIFs8YzkzODAxYzI+XSA/IGRvX3N5bmNfd3JpdGUrMHhhYi8w
eGFiClsgICAgNC4zMTg5MDRdICBbPGM5MzgwZWIxPl0gdmZzX3JlYWQrMHhlMC8weDFmYgpb
ICAgIDQuMzE4OTA2XSAgWzxjOTM4MTFkNT5dIFN5U19yZWFkKzB4NzMvMHhlOApbICAgIDQu
MzE4OTExXSAgWzxjYTVjMGFjYT5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDNjClsgICAg
NC4zMTg5MTFdIC0tLVsgZW5kIHRyYWNlIDE4ZDViMmMxMGVlNGFjN2UgXS0tLQpbICAgIDQu
MzE4OTExXSAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMGZmYjJmZTdi
OWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by14aWFuLTk6MjAx
NDAzMDcwNzEyMTY6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjMuMTQuMC1yYzUtbmV4
dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZToyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgx
LTAzMDcwNjM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1l
c2cteW9jdG8taXZ5dG93bjItMTI6MjAxNDAzMDcwNzEyMDY6aTM4Ni1yYW5kY29uZmlnLXgx
LTAzMDcwNjM0OjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZToyCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0LzBmZmIyZmU3YjljMzAwODI4NzZm
YTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8teGlhbi0xOToyMDE0MDMwODA0MzQ1
MDppMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2
LTA2OTUyLWcwZmZiMmZlOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQv
MGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by1z
bmItMzc6MjAxNDAzMDgwNDMzMDk6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZh
M2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by1zbmItODoyMDE0MDMwODA0MzMwNTpp
Mzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MS0wMzA3MDYzNC8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2Rt
ZXNnLXF1YW50YWwtc25iLTI3OjIwMTQwMzA4MDQzNDM2OmkzODYtcmFuZGNvbmZpZy14MS0w
MzA3MDYzNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0LzBmZmIyZmU3
YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRhbC1zbmItMjA6
MjAxNDAzMDgwNDMyMjk6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2Rh
MDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by14aWFuLTMwOjIwMTQwMzA3MDcxMjE2OmkzODYt
cmFuZGNvbmZpZy14MS0wMzA3MDYzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTIt
ZzBmZmIyZmU6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC8wZmZiMmZl
N2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXF1YW50YWwtc25iLTg6
MjAxNDAzMDgwNDMxNDQ6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2Rh
MDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by13YWltZWEtMzoyMDE0MDMwNzA3Mjg1MzppMzg2
LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUy
LWcwZmZiMmZlOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMGZmYjJm
ZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLWl2eXRv
d24yLTI6MjAxNDAzMDcwNzExNDY6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjMuMTQu
MC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZToyCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTAzMDcwNjM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYz
MmNmMDMvZG1lc2cteW9jdG8teGlhbi0yOToyMDE0MDMwNzA3MTIxMDppMzg2LXJhbmRjb25m
aWcteDEtMDMwNzA2MzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZl
OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMGZmYjJmZTdiOWMzMDA4
Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLXhpYW4tMTc6MjAxNDAz
MDcwNzEyMDM6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjMuMTQuMC1yYzUtbmV4dC0y
MDE0MDMwNi0wNjk1Mi1nMGZmYjJmZToyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAz
MDcwNjM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ct
cXVhbnRhbC1zbmItMTE6MjAxNDAzMDgwNDM0Mzc6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcw
NjM0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMGZmYjJmZTdiOWMz
MDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLXhpYW4tNDc6MjAx
NDAzMDcwNzEyMTA6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjMuMTQuMC1yYzUtbmV4
dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZToyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgx
LTAzMDcwNjM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1l
c2ctcXVhbnRhbC1qYWtldG93bi04OjIwMTQwMzA4MDQzMjAxOmkzODYtcmFuZGNvbmZpZy14
MS0wMzA3MDYzNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0LzBmZmIy
ZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8teGlhbi0y
MjoyMDE0MDMwNzA3MTIxMDppMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6My4xNC4wLXJj
NS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDEtMDMwNzA2MzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2Yw
My9kbWVzZy15b2N0by1zbmItNDI6MjAxNDAzMDgwNDM1MjY6aTM4Ni1yYW5kY29uZmlnLXgx
LTAzMDcwNjM0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMGZmYjJm
ZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by1zbmItMTk6
MjAxNDAzMDgwNDMzMDg6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKMDoxOToxOSBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKW2RldGFjaGVkIEhFQUQgNTM4OTU5YV0gUmV2
ZXJ0ICJVcGRhdGUgb2YgYmxrZ19zdGF0IGFuZCBibGtnX3J3c3RhdCBtYXkgaGFwcGVuIGlu
IGJoIGNvbnRleHQuIgogQ29tbWl0dGVyOiBXdSBGZW5nZ3VhbmcgPGtidWlsZEBiZWU+Cllv
dXIgbmFtZSBhbmQgZW1haWwgYWRkcmVzcyB3ZXJlIGNvbmZpZ3VyZWQgYXV0b21hdGljYWxs
eSBiYXNlZApvbiB5b3VyIHVzZXJuYW1lIGFuZCBob3N0bmFtZS4gUGxlYXNlIGNoZWNrIHRo
YXQgdGhleSBhcmUgYWNjdXJhdGUuCllvdSBjYW4gc3VwcHJlc3MgdGhpcyBtZXNzYWdlIGJ5
IHNldHRpbmcgdGhlbSBleHBsaWNpdGx5OgoKICAgIGdpdCBjb25maWcgLS1nbG9iYWwgdXNl
ci5uYW1lICJZb3VyIE5hbWUiCiAgICBnaXQgY29uZmlnIC0tZ2xvYmFsIHVzZXIuZW1haWwg
eW91QGV4YW1wbGUuY29tCgpBZnRlciBkb2luZyB0aGlzLCB5b3UgbWF5IGZpeCB0aGUgaWRl
bnRpdHkgdXNlZCBmb3IgdGhpcyBjb21taXQgd2l0aDoKCiAgICBnaXQgY29tbWl0IC0tYW1l
bmQgLS1yZXNldC1hdXRob3IKCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA0
IGRlbGV0aW9ucygtKQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLXgxLTAzMDcwNjM0L25leHQ6bWFzdGVyOjUzODk1OWEzOTAxMjcxMjU1ODFh
NGZhMmYyZjdlMDM1YjgyZmE0MjE6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0wOC0wODowMjo0
MSA1Mzg5NTlhMzkwMTI3MTI1NTgxYTRmYTJmMmY3ZTAzNWI4MmZhNDIxIGNvbXBpbGluZwoK
MjAxNC0wMy0wOC0wODoxMTo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LW5l
eHQtMjAxNDAzMDYtMDAwMDEtZzUzODk1OWEuLi4uCTMJNAk3Lgk4CTEyCTE0CTE1CTE4CTI0
LgkyNwkzNAkzOAk0MQk0OAk1MAk1Mgk1NAk1Nwk1OS4JNjAgU1VDQ0VTUwoKCj09PT09PT09
PSB1cHN0cmVhbSA9PT09PT09PT0KV2FybmluZzogeW91IGFyZSBsZWF2aW5nIDEgY29tbWl0
IGJlaGluZCwgbm90IGNvbm5lY3RlZCB0bwphbnkgb2YgeW91ciBicmFuY2hlczoKCiAgNTM4
OTU5YSBSZXZlcnQgIlVwZGF0ZSBvZiBibGtnX3N0YXQgYW5kIGJsa2dfcndzdGF0IG1heSBo
YXBwZW4gaW4gYmggY29udGV4dC4iCgpJZiB5b3Ugd2FudCB0byBrZWVwIHRoZW0gYnkgY3Jl
YXRpbmcgYSBuZXcgYnJhbmNoLCB0aGlzIG1heSBiZSBhIGdvb2QgdGltZQp0byBkbyBzbyB3
aXRoOgoKIGdpdCBicmFuY2ggbmV3X2JyYW5jaF9uYW1lIDUzODk1OWEKCkhFQUQgaXMgbm93
IGF0IGIwNTM5NDAuLi4gQVJDOiBVc2UgY29ycmVjdCBQVEFHIHJlZ2lzdGVyIGZvciBpY2Fj
aGUgZmx1c2gKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy14MS0wMzA3MDYzNC9uZXh0Om1hc3RlcjpiMDUzOTQwZGY0MTgwOGYwZjI3NTY4ZWIz
NjgyMGQxMGE4YTk4N2Y4OmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDgtMDg6MjU6MzUgYjA1
Mzk0MGRmNDE4MDhmMGYyNzU2OGViMzY4MjBkMTBhOGE5ODdmOCBjb21waWxpbmcKCjIwMTQt
MDMtMDgtMDg6MzM6MTAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wMDIzMi1n
YjA1Mzk0MC4uLiBURVNUIEZBSUxVUkUKWyAgICA1LjM0MjA1Nl0gaW5pdDogRmFpbGVkIHRv
IGNyZWF0ZSBwdHkgLSBkaXNhYmxpbmcgbG9nZ2luZyBmb3Igam9iClsgICAgNS4zNTIyNjZd
IGluaXQ6IEZhaWxlZCB0byBjcmVhdGUgcHR5IC0gZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpv
YgpbICAgIDYuMTIxOTAzXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0K
WyAgICA2LjEyMTk0Ml0gV0FSTklORzogQ1BVOiAwIFBJRDogMjgyIGF0IC9rZXJuZWwtdGVz
dHMvbGludXg0L2tlcm5lbC9zb2Z0aXJxLmM6MTQ1IF9fbG9jYWxfYmhfZW5hYmxlX2lwKzB4
YjMvMHgyMDIoKQpbICAgIDYuMTIxOTQ1XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICA2LjEy
MTk1MV0gQ1BVOiAwIFBJRDogMjgyIENvbW06IGJsa2lkIE5vdCB0YWludGVkIDMuMTQuMC1y
YzUtMDAyMzItZ2IwNTM5NDAgIzExMgpbICAgIDYuMTIxOTUyXSBIYXJkd2FyZSBuYW1lOiBC
b2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgNi4xMjE5NjFdICAwMDAw
MDAwMCBjMjY5OWJkMCBjNjc3YjYzZiBjMjY5OWJlOCBjNTQ1YmI4NCBjNTQ2MjYzNyBjNTg5
NzM4OSAwMDAwMDIwMApbICAgIDYuMTIxOTY2XSAgYzI5ZGMwMDAgYzI2OTliZjggYzU0NWJi
ZjAgMDAwMDAwMDkgMDAwMDAwMDAgYzI2OTljMDggYzU0NjI2MzcgMDAwMDAwMDAKWyAgICA2
LjEyMTk3Ml0gIDAwMDAwMDAwIGMyNjk5Y2IwIGM1ODk3M2ZiIDAwMDAwMDAxIDAwMDAwMDAw
IGMyOWRjNDAwIGMyYWNiODIwIGMyOWRjMDAwClsgICAgNi4xMjE5NzNdIENhbGwgVHJhY2U6
ClsgICAgNi4xMjE5OTddICBbPGM2NzdiNjNmPl0gZHVtcF9zdGFjaysweDQwLzB4NWUKWyAg
ICA2LjEyMjAwMV0gIFs8YzU0NWJiODQ+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweGE5LzB4
ZWEKWyAgICA2LjEyMjAwNV0gIFs8YzU0NjI2Mzc+XSA/IF9fbG9jYWxfYmhfZW5hYmxlX2lw
KzB4YjMvMHgyMDIKWyAgICA2LjEyMjAxN10gIFs8YzU4OTczODk+XSA/IF9fY2ZxX3NldF9h
Y3RpdmVfcXVldWUrMHhiMi8weDI5MQpbICAgIDYuMTIyMDIwXSAgWzxjNTQ1YmJmMD5dIHdh
cm5fc2xvd3BhdGhfbnVsbCsweDJiLzB4M2QKWyAgICA2LjEyMjAyNF0gIFs8YzU0NjI2Mzc+
XSBfX2xvY2FsX2JoX2VuYWJsZV9pcCsweGIzLzB4MjAyClsgICAgNi4xMjIwMjddICBbPGM1
ODk3M2ZiPl0gX19jZnFfc2V0X2FjdGl2ZV9xdWV1ZSsweDEyNC8weDI5MQpbICAgIDYuMTIy
MDM1XSAgWzxjNTg5MDAyZj5dID8gYnNnX3JlbGVhc2UrMHg2MC8weDQyYgpbICAgIDYuMTIy
MDQyXSAgWzxjNTg5OWE5ZT5dID8gY2ZxX3Jlc29ydF9ycl9saXN0KzB4NDkvMHg1YgpbICAg
IDYuMTIyMDQ2XSAgWzxjNTg5OWI4ZT5dID8gY2ZxX2FkZF9jZnFxX3JyKzB4ZGUvMHhmMwpb
ICAgIDYuMTIyMDUwXSAgWzxjNTg5OWY1Yz5dID8gY2ZxX3VwZGF0ZV9pZGxlX3dpbmRvdy5p
c3JhLjc4KzB4ZjIvMHgxZjQKWyAgICA2LjEyMjA1N10gIFs8YzU0OTg5MjA+XSA/IHNjaGVk
X2Nsb2NrX2NwdSsweDE1ZC8weDE5OApbICAgIDYuMTIyMDYxXSAgWzxjNTg5ZTRlYz5dIGNm
cV9kaXNwYXRjaF9yZXF1ZXN0cysweGI5Mi8weDExYjAKWyAgICA2LjEyMjA2N10gIFs8YzU0
NDlkM2Y+XSA/IGt2bV9jbG9ja19yZWFkKzB4MzAvMHg1NQpbICAgIDYuMTIyMDcyXSAgWzxj
NTQwZmQyNT5dID8gc2NoZWRfY2xvY2srMHgzZS8weDUwClsgICAgNi4xMjIwNzZdICBbPGM1
ODljNGU5Pl0gPyBjZnFfaW5zZXJ0X3JlcXVlc3QrMHgzYzkvMHg4NjkKWyAgICA2LjEyMjA4
M10gIFs8YzU0YWM1Zjc+XSA/IF9fbG9ja19hY3F1aXJlKzB4MTVhZS8weDE2ZDQKWyAgICA2
LjEyMjA5MF0gIFs8YzU4NzZjMWI+XSBibGtfcGVla19yZXF1ZXN0KzB4OWUvMHgzMWEKWyAg
ICA2LjEyMjEwM10gIFs8YzVkNzc0YWU+XSBzY3NpX3JlcXVlc3RfZm4rMHg2Mi8weDhhMQpb
ICAgIDYuMTIyMTA2XSAgWzxjNTg3NzQ4Mz5dID8gYmxrX2ZsdXNoX3BsdWdfbGlzdCsweDJh
NC8weDQ0NwpbICAgIDYuMTIyMTA5XSAgWzxjNTg3MTc4OT5dIF9fYmxrX3J1bl9xdWV1ZSsw
eDU1LzB4NmMKWyAgICA2LjEyMjExM10gIFs8YzU4NzRmNDQ+XSBxdWV1ZV91bnBsdWdnZWQu
aXNyYS4yOSsweDQwLzB4NmEKWyAgICA2LjEyMjExNl0gIFs8YzU4Nzc1NDU+XSBibGtfZmx1
c2hfcGx1Z19saXN0KzB4MzY2LzB4NDQ3ClsgICAgNi4xMjIxMTldICBbPGM1ODc3NjQxPl0g
YmxrX2ZpbmlzaF9wbHVnKzB4MWIvMHg1MQpbICAgIDYuMTIyMTI5XSAgWzxjNTUyY2ZlYj5d
IF9fZG9fcGFnZV9jYWNoZV9yZWFkYWhlYWQrMHgzMTQvMHgzNjQKWyAgICA2LjEyMjEzM10g
IFs8YzU1MmQxNDE+XSBmb3JjZV9wYWdlX2NhY2hlX3JlYWRhaGVhZCsweGE4LzB4ZTEKWyAg
ICA2LjEyMjEzNl0gIFs8YzU1MmQ3MzU+XSBwYWdlX2NhY2hlX3N5bmNfcmVhZGFoZWFkKzB4
NWQvMHg5MQpbICAgIDYuMTIyMTQyXSAgWzxjNTUxZWExND5dIGdlbmVyaWNfZmlsZV9haW9f
cmVhZCsweDM2ZS8weGI1OQpbICAgIDYuMTIyMTUyXSAgWzxjNTVjZWZkNj5dIGJsa2Rldl9h
aW9fcmVhZCsweDk1LzB4YjEKWyAgICA2LjEyMjE2MV0gIFs8YzU1N2Q0ZDc+XSBkb19zeW5j
X3JlYWQrMHg1YS8weGFiClsgICAgNi4xMjIxNjVdICBbPGM1NTdkNDdkPl0gPyBkb19zeW5j
X3dyaXRlKzB4YWIvMHhhYgpbICAgIDYuMTIyMTY3XSAgWzxjNTU3ZTE2Yz5dIHZmc19yZWFk
KzB4ZTAvMHgxZmIKWyAgICA2LjEyMjE3MF0gIFs8YzU1N2U0OTA+XSBTeVNfcmVhZCsweDcz
LzB4ZTgKWyAgICA2LjEyMjE3N10gIFs8YzY3OTNlY2E+XSBzeXNlbnRlcl9kb19jYWxsKzB4
MTIvMHgzYwpbICAgIDYuMTIyMTc5XSAtLS1bIGVuZCB0cmFjZSBkNmIzYjc1N2QwZmRjYjg1
IF0tLS0KWyAgICA2LjEyMjE3OV0gCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcw
NjM0L2IwNTM5NDBkZjQxODA4ZjBmMjc1NjhlYjM2ODIwZDEwYThhOTg3ZjgvZG1lc2ctcXVh
bnRhbC1pbm4tMTA6MjAxNDAzMDgwODM0MTg6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0
OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvYjA1Mzk0MGRmNDE4MDhm
MGYyNzU2OGViMzY4MjBkMTBhOGE5ODdmOC9kbWVzZy1xdWFudGFsLXJvYW0tMToyMDE0MDMw
ODA4MzQyMjppMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6My4xNC4wLXJjNS0wMDIzMi1n
YjA1Mzk0MDoxMTIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvYjA1Mzk0
MGRmNDE4MDhmMGYyNzU2OGViMzY4MjBkMTBhOGE5ODdmOC9kbWVzZy1xdWFudGFsLXhpYW4t
Mzc6MjAxNDAzMDgwODM0MzQ6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjMuMTQuMC1y
YzUtMDAyMzItZ2IwNTM5NDA6MTEyCjA6MzoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
CgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRp
b24gd2FzIGIwNTM5NDAuLi4gQVJDOiBVc2UgY29ycmVjdCBQVEFHIHJlZ2lzdGVyIGZvciBp
Y2FjaGUgZmx1c2gKSEVBRCBpcyBub3cgYXQgMWIwYTdlMy4uLiBBZGQgbGludXgtbmV4dCBz
cGVjaWZpYyBmaWxlcyBmb3IgMjAxNDAzMDcKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC9uZXh0Om1hc3RlcjoxYjBhN2Uz
MjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNjOmJpc2VjdC1saW51eDQKCjIwMTQt
MDMtMDgtMDg6MzU6MTEgMWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQz
YyBjb21waWxpbmcKCjIwMTQtMDMtMDgtMDg6NDI6NTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA3Li4JMS4gVEVTVCBGQUlMVVJFClsgICAxOS40MjQ1
ODRdIFsgSU5GTzogaW5jb25zaXN0ZW50IGxvY2sgc3RhdGUgXQpbICAgMTkuNDI0NTg0XSAz
LjE0LjAtcmM1LW5leHQtMjAxNDAzMDcgIzExMyBUYWludGVkOiBHICAgICAgICBXICAgClsg
ICAxOS40MjQ1ODRdIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgMTku
NDI0NTg0XSBpbmNvbnNpc3RlbnQge0lOLVNPRlRJUlEtV30gLT4ge1NPRlRJUlEtT04tV30g
dXNhZ2UuClsgICAxOS40MjQ1ODRdIGJsa2lkLzI4MSBbSEMwWzBdOlNDMFswXTpIRTE6U0Ux
XSB0YWtlczoKWyAgIDE5LjQyNDU4NF0gICgmKCZxLT5fX3F1ZXVlX2xvY2spLT5ybG9jayl7
Ky4/Li4ufSwgYXQ6IFs8YzgwN2MzNjc+XSBibGtfZmx1c2hfcGx1Z19saXN0KzB4MmE0LzB4
NDQ3ClsgICAxOS40MjQ1ODRdIHtJTi1TT0ZUSVJRLVd9IHN0YXRlIHdhcyByZWdpc3RlcmVk
IGF0OgpbICAgMTkuNDI0NTg0XSAgIFs8YzdjYWQyNWI+XSBfX2xvY2tfYWNxdWlyZSsweGU5
MS8weDE2YjAKWyAgIDE5LjQyNDU4NF0gICBbPGM3Y2FkYjYwPl0gbG9ja19hY3F1aXJlKzB4
ZTYvMHgxNDcKWyAgIDE5LjQyNDU4NF0gICBbPGM4ZmE2NTRkPl0gX3Jhd19zcGluX2xvY2sr
MHg0ZS8weGVlClsgICAxOS40MjQ1ODRdICAgWzxjODU4NTY0Mj5dIHNjc2lfZGV2aWNlX3Vu
YnVzeSsweGVlLzB4MTM0ClsgICAxOS40MjQ1ODRdICAgWzxjODU3YTI4Mz5dIHNjc2lfZmlu
aXNoX2NvbW1hbmQrMHgyYi8weDExMwpbICAgMTkuNDI0NTg0XSAgIFs8Yzg1ODU5YTE+XSBz
Y3NpX3NvZnRpcnFfZG9uZSsweDFiYi8weDFkMQpbICAgMTkuNDI0NTg0XSAgIFs8YzgwODQz
ZjY+XSBibGtfZG9uZV9zb2Z0aXJxKzB4MTBhLzB4MTJlClsgICAxOS40MjQ1ODRdICAgWzxj
N2M2MmMzNj5dIF9fZG9fc29mdGlycSsweDE1Ny8weDM2NgpbICAgMTkuNDI0NTg0XSBpcnEg
ZXZlbnQgc3RhbXA6IDE4MzYKWyAgIDE5LjQyNDU4NF0gaGFyZGlycXMgbGFzdCAgZW5hYmxl
ZCBhdCAoMTgzMyk6IFs8YzhmYTZiNmY+XSBfcmF3X3NwaW5fdW5sb2NrX2lycSsweDVhLzB4
YmEKWyAgIDE5LjQyNDU4NF0gaGFyZGlycXMgbGFzdCBkaXNhYmxlZCBhdCAoMTgzNCk6IFs8
YzgwN2MyYzI+XSBibGtfZmx1c2hfcGx1Z19saXN0KzB4MWZmLzB4NDQ3ClsgICAxOS40MjQ1
ODRdIHNvZnRpcnFzIGxhc3QgIGVuYWJsZWQgYXQgKDE4MzYpOiBbPGM4MDljNTU1Pl0gX19j
ZnFfc2V0X2FjdGl2ZV9xdWV1ZSsweDExMi8weDJmMQpbICAgMTkuNDI0NTg0XSBzb2Z0aXJx
cyBsYXN0IGRpc2FibGVkIGF0ICgxODM1KTogWzxjODA5YzU1NT5dIF9fY2ZxX3NldF9hY3Rp
dmVfcXVldWUrMHgxMTIvMHgyZjEKWyAgIDE5LjQyNDU4NF0gClsgICAxOS40MjQ1ODRdIG90
aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6ClsgICAxOS40MjQ1ODRd
ICBQb3NzaWJsZSB1bnNhZmUgbG9ja2luZyBzY2VuYXJpbzoKWyAgIDE5LjQyNDU4NF0gClsg
ICAxOS40MjQ1ODRdICAgICAgICBDUFUwClsgICAxOS40MjQ1ODRdICAgICAgICAtLS0tClsg
ICAxOS40MjQ1ODRdICAgbG9jaygmKCZxLT5fX3F1ZXVlX2xvY2spLT5ybG9jayk7ClsgICAx
OS40MjQ1ODRdICAgPEludGVycnVwdD4KWyAgIDE5LjQyNDU4NF0gICAgIGxvY2soJigmcS0+
X19xdWV1ZV9sb2NrKS0+cmxvY2spOwpbICAgMTkuNDI0NTg0XSAKWyAgIDE5LjQyNDU4NF0g
ICoqKiBERUFETE9DSyAqKioKWyAgIDE5LjQyNDU4NF0gClsgICAxOS40MjQ1ODRdIDEgbG9j
ayBoZWxkIGJ5IGJsa2lkLzI4MToKWyAgIDE5LjQyNDU4NF0gICMwOiAgKCYoJnEtPl9fcXVl
dWVfbG9jayktPnJsb2NrKXsrLj8uLi59LCBhdDogWzxjODA3YzM2Nz5dIGJsa19mbHVzaF9w
bHVnX2xpc3QrMHgyYTQvMHg0NDcKWyAgIDE5LjQyNDU4NF0gClsgICAxOS40MjQ1ODRdIHN0
YWNrIGJhY2t0cmFjZToKWyAgIDE5LjQyNDU4NF0gQ1BVOiAwIFBJRDogMjgxIENvbW06IGJs
a2lkIFRhaW50ZWQ6IEcgICAgICAgIFcgICAgMy4xNC4wLXJjNS1uZXh0LTIwMTQwMzA3ICMx
MTMKWyAgIDE5LjQyNDU4NF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9j
aHMgMDEvMDEvMjAxMQpbICAgMTkuNDI0NTg0XSAgMDAwMDAwMDAgYzI2NjViN2MgYzhmOGZk
NzIgYzI2NjViOWMgYzhmOGIwMzMgYzk0ZTBlNzYgYzk0ZTBjNGUgYzk0ZTFhZDEKWyAgIDE5
LjQyNDU4NF0gIDAwMDAwMDA2IGMyNjFhOTQwIDAwMDAwMDQwIGMyNjY1YmM0IGM3Y2FiZjEx
IDAwMDAwMDA2IDAwMDAwMDAwIGM3Y2E4ZmM0ClsgICAxOS40MjQ1ODRdICAwMDAwMDAwNCBj
MjYxYTUxMCBjMjYxYTk0MCBjMjYxYTUxMCAwMDAwMDAwMCBjMjY2NWJlMCBjN2NhZjM3YiAw
MDAwMDAwNwpbICAgMTkuNDI0NTg0XSBDYWxsIFRyYWNlOgpbICAgMTkuNDI0NTg0XSAgWzxj
OGY4ZmQ3Mj5dIGR1bXBfc3RhY2srMHg0MC8weDVlClsgICAxOS40MjQ1ODRdICBbPGM4Zjhi
MDMzPl0gcHJpbnRfdXNhZ2VfYnVnKzB4NDkzLzB4NGFkClsgICAxOS40MjQ1ODRdICBbPGM3
Y2FiZjExPl0gbWFya19sb2NrKzB4NTc1LzB4YTJlClsgICAxOS40MjQ1ODRdICBbPGM3Y2E4
ZmM0Pl0gPyBwcmludF9pcnFfaW52ZXJzaW9uX2J1ZysweDM3NC8weDM3NApbICAgMTkuNDI0
NTg0XSAgWzxjN2NhZjM3Yj5dIG1hcmtfaGVsZF9sb2NrcysweGE1LzB4ZGEKWyAgIDE5LjQy
NDU4NF0gIFs8YzdjNjMzMGY+XSA/IF9fbG9jYWxfYmhfZW5hYmxlX2lwKzB4MWI1LzB4MjAy
ClsgICAxOS40MjQ1ODRdICBbPGM3Y2FmNzFiPl0gdHJhY2VfaGFyZGlycXNfb25fY2FsbGVy
KzB4MzZiLzB4M2IxClsgICAxOS40MjQ1ODRdICBbPGM4MDljNTU1Pl0gPyBfX2NmcV9zZXRf
YWN0aXZlX3F1ZXVlKzB4MTEyLzB4MmYxClsgICAxOS40MjQ1ODRdICBbPGM3Y2FmNzg4Pl0g
dHJhY2VfaGFyZGlycXNfb24rMHgyNy8weDM3ClsgICAxOS40MjQ1ODRdICBbPGM3YzYzMzBm
Pl0gX19sb2NhbF9iaF9lbmFibGVfaXArMHgxYjUvMHgyMDIKWyAgIDE5LjQyNDU4NF0gIFs8
YzgwOWM1Yzc+XSBfX2NmcV9zZXRfYWN0aXZlX3F1ZXVlKzB4MTg0LzB4MmYxClsgICAxOS40
MjQ1ODRdICBbPGM4MDkwMDJmPl0gPyBfX2Jsa19zZW5kX2dlbmVyaWMuY29uc3Rwcm9wLjcr
MHgyOC8weGE2ClsgICAxOS40MjQ1ODRdICBbPGM4MDllZjFhPl0gPyBjZnFfcmVzb3J0X3Jy
X2xpc3QrMHg0OS8weDViClsgICAxOS40MjQ1ODRdICBbPGM4MDlmMDZhPl0gPyBjZnFfYWRk
X2NmcXFfcnIrMHgxM2UvMHgxNTMKWyAgIDE5LjQyNDU4NF0gIFs8YzgwOWY0Mzg+XSA/IGNm
cV91cGRhdGVfaWRsZV93aW5kb3cuaXNyYS43OCsweGYyLzB4MjU0ClsgICAxOS40MjQ1ODRd
ICBbPGM3Yzk5NzU1Pl0gPyBzY2hlZF9jbG9ja19jcHUrMHgxNWQvMHgxOTgKWyAgIDE5LjQy
NDU4NF0gIFs8YzgwYTNmNGM+XSBjZnFfZGlzcGF0Y2hfcmVxdWVzdHMrMHhiOTIvMHgxMjEy
ClsgICAxOS40MjQ1ODRdICBbPGM3YzRhMzZiPl0gPyBrdm1fY2xvY2tfcmVhZCsweDMwLzB4
NTUKWyAgIDE5LjQyNDU4NF0gIFs8YzdjMGZkNzU+XSA/IHNjaGVkX2Nsb2NrKzB4M2UvMHg1
MApbICAgMTkuNDI0NTg0XSAgWzxjODBhMWRjOT5dID8gY2ZxX2luc2VydF9yZXF1ZXN0KzB4
NDI5LzB4OGM5ClsgICAxOS40MjQ1ODRdICBbPGM3Y2FkOTU0Pl0gPyBfX2xvY2tfYWNxdWly
ZSsweDE1OGEvMHgxNmIwClsgICAxOS40MjQ1ODRdICBbPGM4MGJkYjUxPl0gPyBsaXN0X3Nv
cnQrMHgxZmIvMHgyNTMKWyAgIDE5LjQyNDU4NF0gIFs8YzgwN2JhZmY+XSBibGtfcGVla19y
ZXF1ZXN0KzB4OWUvMHgzMWEKWyAgIDE5LjQyNDU4NF0gIFs8Yzg1ODRkMTU+XSBzY3NpX3Jl
cXVlc3RfZm4rMHg2Mi8weDhhMQpbICAgMTkuNDI0NTg0XSAgWzxjODA3YzM2Nz5dID8gYmxr
X2ZsdXNoX3BsdWdfbGlzdCsweDJhNC8weDQ0NwpbICAgMTkuNDI0NTg0XSAgWzxjODA3NjY2
Zj5dIF9fYmxrX3J1bl9xdWV1ZSsweDU1LzB4NmMKWyAgIDE5LjQyNDU4NF0gIFs8YzgwNzll
MmE+XSBxdWV1ZV91bnBsdWdnZWQuaXNyYS4yOSsweDQwLzB4NmEKWyAgIDE5LjQyNDU4NF0g
IFs8YzgwN2M0Mjk+XSBibGtfZmx1c2hfcGx1Z19saXN0KzB4MzY2LzB4NDQ3ClsgICAxOS40
MjQ1ODRdICBbPGM4MDdjNTI1Pl0gYmxrX2ZpbmlzaF9wbHVnKzB4MWIvMHg1MQpbICAgMTku
NDI0NTg0XSAgWzxjN2QyZWRkYz5dIF9fZG9fcGFnZV9jYWNoZV9yZWFkYWhlYWQrMHgzMjYv
MHgzNzYKWyAgIDE5LjQyNDU4NF0gIFs8YzdkMmVmMDQ+XSBmb3JjZV9wYWdlX2NhY2hlX3Jl
YWRhaGVhZCsweGEyLzB4ZDYKWyAgIDE5LjQyNDU4NF0gIFs8YzdkMmY1MGI+XSBwYWdlX2Nh
Y2hlX3N5bmNfcmVhZGFoZWFkKzB4NWQvMHg5MQpbICAgMTkuNDI0NTg0XSAgWzxjN2QyMDdm
Mz5dIGdlbmVyaWNfZmlsZV9haW9fcmVhZCsweDM2ZS8weGI1OQpbICAgMTkuNDI0NTg0XSAg
WzxjN2RkMWJjNT5dIGJsa2Rldl9haW9fcmVhZCsweDk1LzB4YjEKWyAgIDE5LjQyNDU4NF0g
IFs8YzdkODAyY2I+XSBkb19zeW5jX3JlYWQrMHg1YS8weGFiClsgICAxOS40MjQ1ODRdICBb
PGM3ZDgwMjcxPl0gPyBkb19zeW5jX3dyaXRlKzB4YWIvMHhhYgpbICAgMTkuNDI0NTg0XSAg
WzxjN2Q4MGY2MD5dIHZmc19yZWFkKzB4ZTAvMHgxZmIKWyAgIDE5LjQyNDU4NF0gIFs8Yzdk
ODEyODQ+XSBTeVNfcmVhZCsweDczLzB4ZTgKWyAgIDE5LjQyNDU4NF0gIFs8YzhmYTg5NGE+
XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzYwpbICAgMjAuMDI5MTU0XSBpbml0OiBGYWls
ZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKWyAgIDIwLjAz
Mzc5M10gaW5pdDogVGVtcG9yYXJ5IHByb2Nlc3Mgc3Bhd24gZXJyb3I6IE5vIHN1Y2ggZmls
ZSBvciBkaXJlY3RvcnkKWyAgIDIwLjA2NTMxOF0gaW5pdDogRmFpbGVkIHRvIGNyZWF0ZSBw
dHkgLSBkaXNhYmxpbmcgbG9nZ2luZyBmb3Igam9iCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXgxLTAzMDcwNjM0LzFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2Mv
ZG1lc2ctcXVhbnRhbC1qYWtldG93bi0yMDoyMDE0MDMwODA4NDQyMTppMzg2LXJhbmRjb25m
aWcteDEtMDMwNzA2MzQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC8x
YjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNjL2RtZXNnLXlvY3RvLXNu
Yi0xNToyMDE0MDMwODA4NDQyNTppMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6Ogova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3
OThlNDhjNWEyMWQxYzc4ZDNjL2RtZXNnLXlvY3RvLXNuYi0zMDoyMDE0MDMwODA4NDQyNTpp
Mzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MS0wMzA3MDYzNC8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNjL2Rt
ZXNnLXF1YW50YWwtc25iLTI2OjIwMTQwMzA4MDg0NDI2OmkzODYtcmFuZGNvbmZpZy14MS0w
MzA3MDYzNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0LzFiMGE3ZTMy
NjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2ctcXVhbnRhbC1qYWtldG93
bi0yMzoyMDE0MDMwODA4NDQzNDppMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6Ogova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3
OThlNDhjNWEyMWQxYzc4ZDNjL2RtZXNnLXF1YW50YWwtamFrZXRvd24tMjU6MjAxNDAzMDgw
ODQ0MzM6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDEtMDMwNzA2MzQvMWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3
OGQzYy9kbWVzZy1xdWFudGFsLXNuYi05OjIwMTQwMzA4MDg0NDM0OmkzODYtcmFuZGNvbmZp
Zy14MS0wMzA3MDYzNDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0LzFi
MGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2cteW9jdG8tamFr
ZXRvd24tMTU6MjAxNDAzMDgwODQ0MzQ6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMWIwYTdlMzI2MzE2OGEwNmQz
ODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYy9kbWVzZy15b2N0by1zbmItMTM6MjAxNDAzMDgwODQ0
MzU6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDEtMDMwNzA2MzQvMWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQz
Yy9kbWVzZy15b2N0by1zdG9ha2xleS0zOjIwMTQwMzA4MDg0NDM3OmkzODYtcmFuZGNvbmZp
Zy14MS0wMzA3MDYzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDc6MTEzCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0LzFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1
YTIxZDFjNzhkM2MvZG1lc2cteW9jdG8teGd3by0yOjIwMTQwMzA4MDg0NDMzOmkzODYtcmFu
ZGNvbmZpZy14MS0wMzA3MDYzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDc6MTEzCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0LzFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5
OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2ctcXVhbnRhbC1zbmItNDU6MjAxNDAzMDgwODQ0NDE6
aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDEtMDMwNzA2MzQvMWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYy9k
bWVzZy15b2N0by1qYWtldG93bi0zOToyMDE0MDMwODA4NDQ0MTppMzg2LXJhbmRjb25maWct
eDEtMDMwNzA2MzQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC8xYjBh
N2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNjL2RtZXNnLXlvY3RvLWpha2V0
b3duLTQxOjIwMTQwMzA4MDg0NDM5OmkzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNDo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0LzFiMGE3ZTMyNjMxNjhhMDZkMzg1
ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2cteW9jdG8tc25iLTc6MjAxNDAzMDgwODQ0Mzk6
aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDEtMDMwNzA2MzQvMWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYy9k
bWVzZy1xdWFudGFsLWpha2V0b3duLTY6MjAxNDAzMDgwODQ0NDk6aTM4Ni1yYW5kY29uZmln
LXgxLTAzMDcwNjM0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMWIw
YTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYy9kbWVzZy1xdWFudGFsLXNu
Yi00NDoyMDE0MDMwODA4NDQ0NzppMzg2LXJhbmRjb25maWcteDEtMDMwNzA2MzQ6Ogova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNC8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3
OThlNDhjNWEyMWQxYzc4ZDNjL2RtZXNnLXF1YW50YWwteGd3by00OjIwMTQwMzA4MDg0NDUy
OmkzODYtcmFuZGNvbmZpZy14MS0wMzA3MDYzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDc6
MTEzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0LzFiMGE3ZTMyNjMxNjhh
MDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2cteW9jdG8tamFrZXRvd24tMTc6MjAx
NDAzMDgwODQ0NDg6aTM4Ni1yYW5kY29uZmlnLXgxLTAzMDcwNjM0OjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDEtMDMwNzA2MzQvMWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVh
MjFkMWM3OGQzYy9kbWVzZy15b2N0by1yb2FtLTE2OjIwMTQwMzA4MDg0NDU2OmkzODYtcmFu
ZGNvbmZpZy14MS0wMzA3MDYzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDc6MTEzCjA6MjE6
MTYgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==

--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-next-20140306-06952-g0ffb2fe"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc5 Kernel Configuration
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
CONFIG_NEED_DMA_MAP_STATE=y
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
CONFIG_X86_32_LAZY_GS=y
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
CONFIG_COMPILE_TEST=y
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
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
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
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
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
CONFIG_SYSFS_SYSCALL=y
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
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
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
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
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
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
CONFIG_MODULE_SIG_SHA512=y
CONFIG_MODULE_SIG_HASH="sha512"
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
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
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_RDC321X=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_KVM_GUEST=y
CONFIG_KVM_DEBUG_FS=y
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
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
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
CONFIG_X86_MCE=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_INJECT=m
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
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
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
CONFIG_APM_ALLOW_INTS=y

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
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
# CONFIG_EISA_PCI_EISA is not set
# CONFIG_EISA_VIRTUAL_ROOT is not set
# CONFIG_EISA_NAMES is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=m
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
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
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=y
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
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=m
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
# CONFIG_IP_PIMSM_V2 is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
# CONFIG_NF_CONNTRACK_H323 is not set
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
# CONFIG_NF_CONNTRACK_SNMP is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
CONFIG_NF_CONNTRACK_SANE=m
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=y
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_QUEUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
# CONFIG_NF_NAT_SIP is not set
CONFIG_NF_NAT_TFTP=m
CONFIG_NETFILTER_SYNPROXY=y
CONFIG_NF_TABLES=y
CONFIG_NFT_EXTHDR=y
CONFIG_NFT_META=m
CONFIG_NFT_CT=m
CONFIG_NFT_RBTREE=m
# CONFIG_NFT_HASH is not set
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=y
# CONFIG_NFT_LIMIT is not set
CONFIG_NFT_NAT=m
# CONFIG_NFT_QUEUE is not set
CONFIG_NFT_REJECT=m
CONFIG_NFT_COMPAT=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
CONFIG_NETFILTER_XT_TARGET_LED=m
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ECN is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=m
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
CONFIG_NETFILTER_XT_MATCH_STRING=y
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_NF_TABLES_IPV4 is not set
CONFIG_NF_TABLES_ARP=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=m
# CONFIG_IP_NF_MATCH_ECN is not set
CONFIG_IP_NF_MATCH_RPFILTER=m
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_SYNPROXY=y
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT_IPV4=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
# CONFIG_IP_NF_TARGET_REDIRECT is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
# CONFIG_IP_NF_RAW is not set
CONFIG_IP_NF_ARPTABLES=y
# CONFIG_IP_NF_ARPFILTER is not set
# CONFIG_IP_NF_ARP_MANGLE is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
CONFIG_NF_TABLES_BRIDGE=m
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

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
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=m
# CONFIG_RDS_RDMA is not set
# CONFIG_RDS_TCP is not set
# CONFIG_RDS_DEBUG is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=m
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=m
CONFIG_6LOWPAN_IPHC=m
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=m
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=m
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=m
CONFIG_NET_CLS_BPF=y
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=m
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
# CONFIG_BT_ATH3K is not set
# CONFIG_BT_WILINK is not set
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
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
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
# CONFIG_MAC80211_PS_DEBUG is not set
CONFIG_MAC80211_TDLS_DEBUG=y
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
CONFIG_NFC_DIGITAL=m
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
CONFIG_NFC_SIM=m
CONFIG_NFC_PORT100=m

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
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set
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
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
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
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SBC_GXX is not set
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=m
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=m
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
CONFIG_MTD_GPIO_ADDR=m
CONFIG_MTD_INTEL_VR_NOR=m
# CONFIG_MTD_PLATRAM is not set
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_DENALI_DT=m
CONFIG_MTD_NAND_GPIO=m
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=m
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_CS553X=m
CONFIG_MTD_NAND_NANDSIM=m
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_NAND_SH_FLCTL is not set
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_ATMEL_PWM=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=m
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=m
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_OPTI621=m
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=m
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=m
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5520=m
CONFIG_BLK_DEV_CS5530=m
CONFIG_BLK_DEV_CS5535=m
CONFIG_BLK_DEV_CS5536=m
CONFIG_BLK_DEV_HPT366=m
CONFIG_BLK_DEV_JMICRON=m
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=m
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=m
CONFIG_BLK_DEV_SIS5513=m
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=m
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=m

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=m
CONFIG_BLK_DEV_ALI14XX=m
CONFIG_BLK_DEV_DTC2278=m
# CONFIG_BLK_DEV_HT6560B is not set
CONFIG_BLK_DEV_QD65XX=m
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
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
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
CONFIG_SCSI_CXGB4_ISCSI=y
CONFIG_SCSI_BNX2_ISCSI=m
# CONFIG_SCSI_BNX2X_FCOE is not set
CONFIG_BE2ISCSI=m
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=m
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_7000FASST=y
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AHA152X=y
# CONFIG_SCSI_AHA1542 is not set
CONFIG_SCSI_AHA1740=y
CONFIG_SCSI_AACRAID=m
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=m
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_IN2000=y
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ESAS2R=m
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_UFSHCD_PCI=m
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
CONFIG_SCSI_HPTIOP=y
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_DTC3280=m
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=m
CONFIG_SCSI_GENERIC_NCR5380=m
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
# CONFIG_SCSI_GENERIC_NCR53C400 is not set
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=y
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_NCR53C406A=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_PAS16=y
CONFIG_SCSI_QLOGIC_FAS=m
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=y
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SIM710 is not set
CONFIG_SCSI_SYM53C416=y
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_T128 is not set
CONFIG_SCSI_U14_34F=y
# CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
# CONFIG_SCSI_U14_34F_LINKED_COMMANDS is not set
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=m
CONFIG_SCSI_NSP32=m
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_SRP=m
CONFIG_SCSI_BFA_FC=m
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_CHELSIO_FCOE=m
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=m
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_AHCI_IMX is not set
CONFIG_SATA_INIC162X=y
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_HIGHBANK is not set
CONFIG_SATA_MV=m
# CONFIG_SATA_NV is not set
CONFIG_SATA_PROMISE=m
CONFIG_SATA_RCAR=y
CONFIG_SATA_SIL=y
CONFIG_SATA_SIS=y
# CONFIG_SATA_SVW is not set
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=m
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=y
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=y
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_JMICRON=m
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
CONFIG_PATA_NS87415=y
CONFIG_PATA_OLDPIIX=m
CONFIG_PATA_OPTIDMA=y
CONFIG_PATA_PDC2027X=y
# CONFIG_PATA_PDC_OLD is not set
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RDC=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SCH=y
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_TOSHIBA=y
CONFIG_PATA_TRIFLEX=m
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=y

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_ISAPNP=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=y
CONFIG_PATA_OPTI=y
CONFIG_PATA_PCMCIA=m
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_WINBOND_VLB is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=y
CONFIG_ATA_GENERIC=m
CONFIG_PATA_LEGACY=m
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=y
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=y
CONFIG_SBP_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=m
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=m
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_SUNGEM_PHY=m
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=m
# CONFIG_ARCNET_COM90xx is not set
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_ISA is not set
CONFIG_ARCNET_COM20020_PCI=m
# CONFIG_ARCNET_COM20020_CS is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6060=m
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=m
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
CONFIG_MACB=m
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
CONFIG_BNX2X=y
# CONFIG_BNX2X_SRIOV is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=m
CONFIG_NET_VENDOR_CIRRUS=y
# CONFIG_CS89x0 is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=m
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=m
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=m
CONFIG_E1000=m
CONFIG_E1000E=m
# CONFIG_IGB is not set
CONFIG_IGBVF=y
CONFIG_IXGB=y
CONFIG_IXGBE=m
CONFIG_IXGBE_HWMON=y
CONFIG_I40E=y
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_IP1000=y
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
CONFIG_MLX5_CORE=y
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
CONFIG_FEALNX=m
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=m
# CONFIG_NET_VENDOR_8390 is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=m
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_SMC9194 is not set
# CONFIG_PCMCIA_SMC91C92 is not set
CONFIG_EPIC100=y
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
CONFIG_SMSC9420=m
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
CONFIG_STMMAC_PLATFORM=y
CONFIG_STMMAC_PCI=y
# CONFIG_STMMAC_DEBUG_FS is not set
# CONFIG_STMMAC_DA is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NIU=y
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
CONFIG_FDDI=m
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
# CONFIG_SKFP is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=m
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=m
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOE is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=m
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=m
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SR9700=m
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
# CONFIG_USB_ARMLINUX is not set
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_NET_INT51X1=m
# CONFIG_USB_CDC_PHONET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
# CONFIG_HOSTESS_SV11 is not set
CONFIG_COSA=m
CONFIG_LANMEDIA=y
CONFIG_SEALEVEL_4021=m
CONFIG_HDLC=y
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=m
# CONFIG_HDLC_PPP is not set

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=m
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300TOO=m
# CONFIG_N2 is not set
# CONFIG_C101 is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SDLA=m
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKEHARD=m
CONFIG_VMXNET3=y
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
CONFIG_INPUT_MOUSEDEV=m
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
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_LEDS=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_HANWANG=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_DA9052=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_HTCPEN is not set
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_W90X900=m
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_SUR40=y
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_TOUCHSCREEN_ZFORCE=y
# CONFIG_INPUT_MISC is not set

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
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
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
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=m
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
# CONFIG_SERIAL_SH_SCI is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_ST_ASC=m
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_ATMEL is not set
CONFIG_HW_RANDOM_GEODE=m
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_EXYNOS=m
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
# CONFIG_CARDMAN_4040 is not set
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=m
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=m
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=m
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=m
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
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=m
CONFIG_I2C_GPIO=m
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RIIC is not set
CONFIG_I2C_SH_MOBILE=m
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_ROBOTFUZZ_OSIF=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
# CONFIG_I2C_PCA_ISA is not set
CONFIG_SCx200_ACB=y
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=m
# CONFIG_PPS_CLIENT_PARPORT is not set
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_DEBUG_PINCTRL=y
# CONFIG_PINCTRL_BAYTRAIL is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_DA9052=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=m
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=m
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=m
CONFIG_GPIO_ICH=m
CONFIG_GPIO_VX855=y
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TC3589X=y
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_WM831X=m
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=m
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
CONFIG_GPIO_PALMAS=y

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_MXC=y
CONFIG_W1_MASTER_DS1WM=m
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=m
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=m
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=m
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_88PM860X is not set
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=m
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=m
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=m
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=m
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=m

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
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_RCAR_THERMAL is not set
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
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
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
CONFIG_MFD_JANZ_CMODIO=m
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=m
CONFIG_MFD_88PM805=m
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=m
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=m
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
# CONFIG_DRM_I915_UMS is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_ATY128=m
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=m
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
CONFIG_FB_GEODE_GX=m
# CONFIG_FB_GEODE_GX1 is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=m
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=m
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_ATMEL_PWM=m
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=m
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=m
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_LM3630A=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_PANDORA=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set

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
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_MON=m
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=m
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_HCD_TEST_MODE is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
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
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=y
# CONFIG_USB_STORAGE_USBAT is not set
CONFIG_USB_STORAGE_SDDR09=y
# CONFIG_USB_STORAGE_SDDR55 is not set
CONFIG_USB_STORAGE_JUMPSHOT=y
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=m

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MUSB_HDRC=m
# CONFIG_USB_MUSB_HOST is not set
CONFIG_USB_MUSB_GADGET=y
# CONFIG_USB_MUSB_DUAL_ROLE is not set
CONFIG_USB_MUSB_TUSB6010=m
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_SIMPLE=m
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=m
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=m
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MXUPORT=m
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=m
# CONFIG_USB_SERIAL_XSENS_MT is not set
CONFIG_USB_SERIAL_WISHBONE=m
CONFIG_USB_SERIAL_ZTE=m
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=m
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=m
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=m
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
CONFIG_KEYSTONE_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
# CONFIG_OMAP_USB3 is not set
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=m
CONFIG_SAMSUNG_USB2PHY=m
CONFIG_SAMSUNG_USB3PHY=m
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_ISP1301=m
CONFIG_USB_RCAR_PHY=m
CONFIG_USB_RCAR_GEN2_PHY=y
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_VERBOSE=y
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=m
# CONFIG_USB_FOTG210_UDC is not set
CONFIG_USB_GR_UDC=m
CONFIG_USB_R8A66597=m
CONFIG_USB_PXA27X=m
CONFIG_USB_S3C_HSOTG=m
CONFIG_USB_MV_UDC=m
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
CONFIG_USB_AMD5536UDC=m
CONFIG_USB_NET2272=m
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
CONFIG_USB_EG20T=m
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_PHONET=m
CONFIG_USB_F_EEM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_F_MASS_STORAGE=m
CONFIG_USB_F_FS=m
CONFIG_USB_CONFIGFS=m
CONFIG_USB_CONFIGFS_SERIAL=y
# CONFIG_USB_CONFIGFS_ACM is not set
CONFIG_USB_CONFIGFS_OBEX=y
# CONFIG_USB_CONFIGFS_NCM is not set
CONFIG_USB_CONFIGFS_ECM=y
CONFIG_USB_CONFIGFS_ECM_SUBSET=y
CONFIG_USB_CONFIGFS_RNDIS=y
CONFIG_USB_CONFIGFS_EEM=y
CONFIG_USB_CONFIGFS_PHONET=y
# CONFIG_USB_CONFIGFS_MASS_STORAGE is not set
# CONFIG_USB_CONFIGFS_F_LB_SS is not set
CONFIG_USB_CONFIGFS_F_FS=y
CONFIG_USB_ZERO=m
CONFIG_USB_ETH=m
# CONFIG_USB_ETH_RNDIS is not set
# CONFIG_USB_ETH_EEM is not set
CONFIG_USB_G_NCM=m
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=m
# CONFIG_USB_GADGET_TARGET is not set
CONFIG_USB_G_SERIAL=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
# CONFIG_USB_G_NOKIA is not set
CONFIG_USB_G_ACM_MS=m
# CONFIG_USB_G_MULTI is not set
CONFIG_USB_G_HID=m
# CONFIG_USB_G_DBGP is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=m
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_SDHCI_PXAV3 is not set
CONFIG_MMC_SDHCI_PXAV2=m
# CONFIG_MMC_OMAP_HS is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_SH_MMCIF=m
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
# CONFIG_MMC_REALTEK_PCI is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_ATMEL_PWM is not set
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_PWM=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=m
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=m
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_AMSO1100=y
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
# CONFIG_INFINIBAND_CXGB3 is not set
# CONFIG_INFINIBAND_CXGB4 is not set
# CONFIG_MLX4_INFINIBAND is not set
CONFIG_MLX5_INFINIBAND=y
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_IPOIB is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=y
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_INFINIBAND_ISERT is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD76X=m
CONFIG_EDAC_E7XXX=m
CONFIG_EDAC_E752X=m
# CONFIG_EDAC_I82875P is not set
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I82860=m
CONFIG_EDAC_R82600=m
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
CONFIG_EDAC_I7300=m
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
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_88PM80X=m
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8998 is not set
# CONFIG_RTC_DRV_MAX8997 is not set
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PALMAS is not set
CONFIG_RTC_DRV_PCF2127=m
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=m
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=m
CONFIG_RTC_DRV_S5M=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9052 is not set
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=m
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_WM831X=m
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MOXART=m

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=m
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_ET131X is not set
CONFIG_SLICOSS=y
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
CONFIG_USBIP_HOST=y
CONFIG_USBIP_DEBUG=y
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_PCMCIA_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
# CONFIG_COMEDI_8255 is not set
# CONFIG_PANEL is not set
CONFIG_RTS5139=m
# CONFIG_RTS5139_DEBUG is not set
# CONFIG_RTS5208 is not set
CONFIG_TRANZPORT=y
CONFIG_IDE_PHISON=y
CONFIG_USB_SERIAL_QUATECH2=m
CONFIG_DX_SEP=y

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
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD799X is not set
# CONFIG_LPC32XX_ADC is not set
CONFIG_MXS_LRADC=m
# CONFIG_SPEAR_ADC is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
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
CONFIG_AD5933=m

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_TSL2583 is not set
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7854=m
# CONFIG_ADE7854_I2C is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=m
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_CRYSTALHD=y
# CONFIG_CXT1E1 is not set
CONFIG_FB_XGI=m
CONFIG_ACPI_QUICKSTART=m
CONFIG_SBE_2T3E3=y
CONFIG_USB_ENESTORAGE=m
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=m
# CONFIG_SPEAKUP_SYNTH_ACNTSA is not set
# CONFIG_SPEAKUP_SYNTH_ACNTPC is not set
CONFIG_SPEAKUP_SYNTH_APOLLO=m
CONFIG_SPEAKUP_SYNTH_AUDPTR=m
CONFIG_SPEAKUP_SYNTH_BNS=m
CONFIG_SPEAKUP_SYNTH_DECTLK=m
# CONFIG_SPEAKUP_SYNTH_DECEXT is not set
CONFIG_SPEAKUP_SYNTH_DECPC=m
CONFIG_SPEAKUP_SYNTH_DTLK=m
CONFIG_SPEAKUP_SYNTH_KEYPC=m
CONFIG_SPEAKUP_SYNTH_LTLK=m
CONFIG_SPEAKUP_SYNTH_SOFT=m
CONFIG_SPEAKUP_SYNTH_SPKOUT=m
CONFIG_SPEAKUP_SYNTH_TXPRT=m
CONFIG_SPEAKUP_SYNTH_DUMMY=m
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=y
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
CONFIG_LTE_GDM724X=m
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
CONFIG_DGRP=m
# CONFIG_FIREWIRE_SERIAL is not set
CONFIG_LUSTRE_FS=m
CONFIG_LUSTRE_OBD_MAX_IOCTL_BUFFER=8192
CONFIG_LUSTRE_DEBUG_EXPENSIVE_CHECK=y
CONFIG_LUSTRE_LLITE_LLOOP=m
CONFIG_LNET=m
CONFIG_LNET_MAX_PAYLOAD=1048576
# CONFIG_LNET_SELFTEST is not set
CONFIG_LNET_XPRT_IB=m
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_PCIE=y
# CONFIG_DGNC is not set
CONFIG_DGAP=m
CONFIG_GS_FPGABOOT=m
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
# CONFIG_DELL_LAPTOP is not set
CONFIG_DELL_WMI=m
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_TC1100_WMI is not set
CONFIG_HP_ACCEL=y
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=y
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_INTEL_MENLOW=m
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=m
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
CONFIG_XO15_EBOOK=y
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set
CONFIG_INTEL_RST=y
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=m
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_CHROMEOS_PSTORE=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_WM831X is not set
CONFIG_COMMON_CLK_SI5351=m
CONFIG_COMMON_CLK_S2MPS11=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_PALMAS=y
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
CONFIG_BMA180=m
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
CONFIG_MCP3422=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=y
# CONFIG_TI_AM335X_ADC is not set
# CONFIG_TWL6030_GPADC is not set
CONFIG_VIPERBOARD_ADC=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
CONFIG_AD5446=y
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
CONFIG_HID_SENSOR_GYRO_3D=m
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_ITG3200=m

#
# Humidity sensors
#
CONFIG_DHT11=y
CONFIG_SI7005=m

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=y
CONFIG_CM32181=m
CONFIG_CM36651=m
# CONFIG_GP2AP020A00F is not set
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
# CONFIG_SENSORS_LM3533 is not set
CONFIG_LTR501=m
CONFIG_TCS3472=y
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL4531=y
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_MAG3110=m
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=y
CONFIG_MPL3115=y
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
CONFIG_TMP006=m
CONFIG_NTB=m
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_RENESAS_TPU=m
# CONFIG_PWM_TWL is not set
CONFIG_PWM_TWL_LED=y
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_BCM_KONA_USB2_PHY=m
# CONFIG_POWERCAP is not set
CONFIG_MCB=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
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
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=m
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
# CONFIG_JFFS2_FS_SECURITY is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_UBIFS_FS is not set
CONFIG_LOGFS=m
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_FAULT_INJECTION=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_SUNRPC_DEBUG is not set
CONFIG_CEPH_FS=y
# CONFIG_CEPH_FS_POSIX_ACL is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_UPCALL=y
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_SMB2=y
# CONFIG_CIFS_FSCACHE is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=m
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

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
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_HIGHMEM=y
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
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
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
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_DMA_API_DEBUG=y
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=m
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
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
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_STMP_DEVICE=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
# CONFIG_CRC64_ECMA is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
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
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-snb-14:20140308074313:i386-randconfig-x1-03070634::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-10878-g2c57502 (kbuild@bee) (gcc versio=
n 4.8.1 (Debian 4.8.1-3) ) #109 Sat Mar 8 07:37:35 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x02ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x02cb4000, 0x02cb4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x02cb5000, 0x02cb5fff] PGTABLE
[    0.000000] BRK [0x02cb6000, 0x02cb6fff] PGTABLE
[    0.000000] BRK [0x02cb7000, 0x02cb7fff] PGTABLE
[    0.000000] BRK [0x02cb8000, 0x02cb8fff] PGTABLE
[    0.000000] BRK [0x02cb9000, 0x02cb9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 198f000, base 00000000=
, limit 00000000)
[    0.000000] cma: CMA: reserved 28 MiB at 0c400000
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1c577c0
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-x1-03070634/next:ma=
ster:2c575026fae6e63771bd2a4c1d407214a8096a89:bisect-linux4/.vmlinuz-2c5750=
26fae6e63771bd2a4c1d407214a8096a89-20140308074123-14-snb branch=3Dnext/mast=
er BOOT_IMAGE=3D/kernel/i386-randconfig-x1-03070634/2c575026fae6e63771bd2a4=
c1d407214a8096a89/vmlinuz-3.12.0-10878-g2c57502
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 161648K/261744K available (19733K kernel code, 4055K=
 rwdata, 7064K rodata, 788K init, 11984K bss, 100096K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc202e000 - 0xc20f3000   ( 788 kB)
[    0.000000]       .data : 0xc154599c - 0xc202dfc0   (11169 kB)
[    0.000000]       .text : 0xc0200000 - 0xc154599c   (19734 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dcc00a000 soft=3Dcc00c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-10878-g2c57502 (kbuild@bee) (gcc versio=
n 4.8.1 (Debian 4.8.1-3) ) #109 Sat Mar 8 07:37:35 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x02ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x02cb4000, 0x02cb4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x02cb5000, 0x02cb5fff] PGTABLE
[    0.000000] BRK [0x02cb6000, 0x02cb6fff] PGTABLE
[    0.000000] BRK [0x02cb7000, 0x02cb7fff] PGTABLE
[    0.000000] BRK [0x02cb8000, 0x02cb8fff] PGTABLE
[    0.000000] BRK [0x02cb9000, 0x02cb9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 198f000, base 00000000=
, limit 00000000)
[    0.000000] cma: CMA: reserved 28 MiB at 0c400000
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1c577c0
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-x1-03070634/next:ma=
ster:2c575026fae6e63771bd2a4c1d407214a8096a89:bisect-linux4/.vmlinuz-2c5750=
26fae6e63771bd2a4c1d407214a8096a89-20140308074123-14-snb branch=3Dnext/mast=
er BOOT_IMAGE=3D/kernel/i386-randconfig-x1-03070634/2c575026fae6e63771bd2a4=
c1d407214a8096a89/vmlinuz-3.12.0-10878-g2c57502
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 161648K/261744K available (19733K kernel code, 4055K=
 rwdata, 7064K rodata, 788K init, 11984K bss, 100096K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc202e000 - 0xc20f3000   ( 788 kB)
[    0.000000]       .data : 0xc154599c - 0xc202dfc0   (11169 kB)
[    0.000000]       .text : 0xc0200000 - 0xc154599c   (19734 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dcc00a000 soft=3Dcc00c000
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
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2300.158 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 4600.31 Bogo=
MIPS (lpj=3D2300158)
[    0.004016] pid_max: default: 32768 minimum: 301
[    0.005322] Mount-cache hash table entries: 512
[    0.009719] Initializing cgroup subsys freezer
[    0.010067] Initializing cgroup subsys blkio
[    0.011235] mce: CPU supports 10 MCE banks
[    0.012102] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012102] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012102] tlb_flushall_shift: 6
[    0.013023] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.023769] ACPI: Core revision 20130927
[    0.031709] ACPI: All ACPI Tables successfully acquired
[    0.033516] ACPI: setting ELCR to 0200 (from 0c00)
[    0.036583] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.045210] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.048212] devtmpfs: initialized
[    0.050203] gcov: version magic: 0x3430382a
[    0.059136] prandom: seed boundary self test passed
[    0.062261] prandom: 100 self tests passed
[    0.063019] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.064015] pinctrl core: initialized pinctrl subsystem
[    0.068611] NET: Registered protocol family 16
[    0.071402] EISA bus registered
[    0.072051] cpuidle: using governor ladder
[    0.073018] cpuidle: using governor menu
[    0.075371] ACPI: bus type PCI registered
[    0.076016] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.077365] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.113970] bio: create slab <bio-0> at 0
[    0.115576] ACPI: Added _OSI(Module Device)
[    0.116017] ACPI: Added _OSI(Processor Device)
[    0.117017] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.118016] ACPI: Added _OSI(Processor Aggregator Device)
[    0.143606] ACPI: Interpreter enabled
[    0.145015] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130927/hwxface-580)
[    0.147028] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130927/hwxface-580)
[    0.150146] ACPI: (supports S0 S3 S5)
[    0.151016] ACPI: Using PIC for interrupt routing
[    0.153108] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.159338] ACPI: No dock devices found.
[    0.198154] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.199034] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.200190] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.209122] acpiphp: Slot [3] registered
[    0.210176] acpiphp: Slot [4] registered
[    0.212000] acpiphp: Slot [5] registered
[    0.212193] acpiphp: Slot [6] registered
[    0.214140] acpiphp: Slot [7] registered
[    0.215154] acpiphp: Slot [8] registered
[    0.216154] acpiphp: Slot [9] registered
[    0.217184] acpiphp: Slot [10] registered
[    0.219074] acpiphp: Slot [11] registered
[    0.220202] acpiphp: Slot [12] registered
[    0.221161] acpiphp: Slot [13] registered
[    0.222164] acpiphp: Slot [14] registered
[    0.224172] acpiphp: Slot [15] registered
[    0.225152] acpiphp: Slot [16] registered
[    0.227065] acpiphp: Slot [17] registered
[    0.228184] acpiphp: Slot [18] registered
[    0.229153] acpiphp: Slot [19] registered
[    0.230202] acpiphp: Slot [20] registered
[    0.231160] acpiphp: Slot [21] registered
[    0.232221] acpiphp: Slot [22] registered
[    0.234172] acpiphp: Slot [23] registered
[    0.235166] acpiphp: Slot [24] registered
[    0.237059] acpiphp: Slot [25] registered
[    0.238157] acpiphp: Slot [26] registered
[    0.239151] acpiphp: Slot [27] registered
[    0.240155] acpiphp: Slot [28] registered
[    0.241304] acpiphp: Slot [29] registered
[    0.242181] acpiphp: Slot [30] registered
[    0.244083] acpiphp: Slot [31] registered
[    0.245053] PCI host bridge to bus 0000:00
[    0.246025] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.247023] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.248027] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.250023] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.251018] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.252143] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.255251] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.257825] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.264465] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.268391] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.269673] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.270055] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.272444] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.276095] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.280092] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.295102] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.298173] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.301025] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.304022] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.315023] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.318142] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.321021] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.324020] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.337479] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.340020] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.343021] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.356841] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.359022] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.362020] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.375304] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.379020] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.382021] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.394638] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.397020] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.400023] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.413282] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.416021] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.419018] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.432257] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.434037] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.444177] pci_bus 0000:00: on NUMA node 0
[    0.450386] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.453708] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.456426] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.459599] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.462360] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.468595] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.470028] ACPI: \_SB_.PCI0: notify handler is installed
[    0.472203] Found 1 acpi root devices
[    0.475591] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.476036] vgaarb: loaded
[    0.477016] vgaarb: bridge control possible 0000:00:02.0
[    0.480366] SCSI subsystem initialized
[    0.482191] libata version 3.00 loaded.
[    0.483328] ACPI: bus type USB registered
[    0.484254] usbcore: registered new interface driver usbfs
[    0.485167] usbcore: registered new interface driver hub
[    0.486274] usbcore: registered new device driver usb
[    0.487337] pps_core: LinuxPPS API ver. 1 registered
[    0.488015] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.489068] PTP clock support registered
[    0.491444] wmi: Mapper loaded
[    0.493152] PCI: Using ACPI for IRQ routing
[    0.494023] PCI: pci_cache_line_size set to 64 bytes
[    0.495455] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.496050] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.500595] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.502689] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.507119] Switched to clocksource kvm-clock
[    0.511614] pnp: PnP ACPI init
[    0.514996] ACPI: bus type PNP registered
[    0.519173] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.522597] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.530058] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.534209] pnp 00:03: [dma 2]
[    0.536576] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.542099] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.546437] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.553887] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.559990] pnp: PnP ACPI: found 7 devices
[    0.562430] ACPI: bus type PNP unregistered
[    0.635903] PM-Timer running at invalid rate: 106% of normal - aborting.
[    0.639483] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.643273] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.647019] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.657005] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.659707] NET: Registered protocol family 2
[    0.665729] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    0.672255] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.677889] TCP: Hash tables configured (established 2048 bind 2048)
[    0.681306] TCP: reno registered
[    0.683136] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    0.687631] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    0.723283] NET: Registered protocol family 1
[    0.728369] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.738491] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.740298] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.742192] pci 0000:00:02.0: Boot video device
[    0.744940] PCI: CLS 0 bytes, default 64
[    0.749468] Unpacking initramfs...
[    3.292807] debug: unmapping init [mem 0xce7ab000-0xcffeffff]
[    3.399833] DMA-API: preallocated 65536 debug entries
[    3.401391] DMA-API: debugging enabled by kernel config
[    3.405031] apm: BIOS not found.
[    3.408624] Scanning for low memory corruption every 60 seconds
[    3.419637] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    3.424168] Initializing RT-Tester: OK
[    3.426846] Initialise module verification
[    3.428674] audit: initializing netlink socket (disabled)
[    3.438658] type=3D2000 audit(1394235725.297:1): initialized
[    4.500911] tsc: Refined TSC clocksource calibration: 2299.961 MHz
[    4.506774] DLM installed
[    4.508460] fuse init (API version 7.22)
[    4.510135] JFS: nTxBlock =3D 1486, nTxLock =3D 11895
[    4.514775] SGI XFS with ACLs, security attributes, large block/inode nu=
mbers, no debug enabled
[    4.518207] ceph: loaded (mds proto 32)
[    4.519535] msgmni has been set to 371
[    4.525675] Key type asymmetric registered
[    4.527041] Asymmetric key parser 'x509' registered
[    4.528446] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    4.530729] io scheduler noop registered
[    4.532089] io scheduler cfq registered (default)
[    4.539402] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    4.540844] crc32: self tests passed, processed 225944 bytes in 1015353 =
nsec
[    4.543674] crc32c: CRC_LE_BITS =3D 8
[    4.544760] crc32c: self tests passed, processed 225944 bytes in 502044 =
nsec
[    5.060160] crc32_combine: 8373 self tests passed
[    5.586860] crc32c_combine: 8373 self tests passed
[    5.589586] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.591558] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    5.594111] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.597213] vmlfb: initializing
[    5.598706] Could not find Carillo Ranch MCH device.
[    5.600917] hgafb: HGA card not detected.
[    5.602558] hgafb: probe of hgafb.0 failed with error -22
[    5.605258] isapnp: Scanning for PnP cards...
[    5.980117] isapnp: No Plug & Play device found
[    5.981469] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.005059] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    6.010829] serial: Freescale lpuart driver
[    6.013216] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    6.014971] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    6.017740] Hangcheck: Using getrawmonotonic().
[    6.019528] [drm] Initialized drm 1.1.0 20060810
[    6.021247] [drm] radeon kernel modesetting enabled.
[    6.024281] dummy-irq: no IRQ given.  Use irq=3DN
[    6.025883] lkdtm: No crash points registered, enable through debugfs
[    6.027987] Phantom Linux Driver, version n0.9.8, init OK
[    6.029807] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    6.032887] Guest personality initialized and is inactive
[    6.034889] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D59)
[    6.036823] Initialized host personality
[    6.039096] usbcore: registered new interface driver viperboard
[    6.041060] Loading iSCSI transport class v2.0-870.
[    6.044429] fnic: Cisco FCoE HBA Driver, ver 1.5.0.45
[    6.046395] fnic: Successfully Initialized Trace Buffer
[    6.049708] NCR53c406a: no available ports found
[    6.051255] sym53c416.c: Version 1.0.0-ac
[    6.052839] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.08-k.
[    6.055915] iscsi: registered transport (qla4xxx)
[    6.057494] QLogic iSCSI HBA Driver
[    6.080441] Failed initialization of WD-7000 SCSI card!
[    6.082199] DC390: clustering now enabled by default. If you get problem=
s load
[    6.084442]        with "disable_clustering=3D1" and report to maintaine=
rs
[    6.086733] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    6.088754] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    6.090816] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    6.092892] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    6.095515] RocketRAID 3xxx/4xxx Controller driver v1.8
[    6.097224] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    6.099278] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    6.101732] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    6.103811] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    6.105650] iscsi: registered transport (cxgb4i)
[    6.107686] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    6.110018] SCSI Media Changer driver v0.25=20
[    6.130834] scsi_debug: host protection
[    6.132203] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    6.138854] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    6.142949] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    6.147655] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.151553] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    6.154705] sd 0:0:0:0: [sda] Write Protect is off
[    6.156254] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.161997] libphy: Fixed MDIO Bus: probed
[    6.163541] arcnet loaded.
[    6.164674] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    6.167477] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.18 (Sept 0=
1, 2013)
[    6.169982] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    6.172730] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.17-0 (2013/04/11)
[    6.178525] Brocade 10G Ethernet driver - version: 3.2.21.1
[    6.181417] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[    6.183861] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    6.185749] i40e: Intel(R) Ethernet Connection XL710 Network Driver - ve=
rsion 0.3.11-k
[    6.188207] i40e: Copyright (c) 2013 Intel Corporation.
[    6.189901] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    6.191861] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    6.194681] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    6.197023] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256) (6 bit encapsulation enabled).
[    6.199877] CSLIP: code copyright 1989 Regents of the University of Cali=
fornia.
[    6.202370] hdlc: HDLC support module revision 1.22
[    6.204160] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    6.205951] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    6.208041] usbcore: registered new interface driver kaweth
[    6.209748] usbcore: registered new interface driver r8152
[    6.213233] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    6.215027] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    6.218131] usbcore: registered new interface driver cdc_acm
[    6.219914] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    6.222458] usbcore: registered new interface driver cdc_wdm
[    6.224314] usbcore: registered new interface driver usb-storage
[    6.226085] usbcore: registered new interface driver ums-cypress
[    6.227835] usbcore: registered new interface driver ums-datafab
[    6.229649] usbcore: registered new interface driver ums-isd200
[    6.231411] usbcore: registered new interface driver ums-jumpshot
[    6.233286] usbcore: registered new interface driver ums-onetouch
[    6.235136] usbcore: registered new interface driver ums-realtek
[    6.236937] usbcore: registered new interface driver ums-sddr09
[    6.238726] usbcore: registered new interface driver rio500
[    6.240544] usbcore: registered new interface driver usbtest
[    6.242279] usbcore: registered new interface driver usbsevseg
[    6.244463] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.248731] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.250457] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.252296] usbcore: registered new interface driver aiptek
[    6.254013] usbcore: registered new interface driver wacom
[    6.256044] mk712: device not present
[    6.257938] rtc_cmos 00:00: RTC can wake from S4
[    6.260179] rtc (null): alarm rollover: day
[    6.261885]  sda: unknown partition table
[    6.266456] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    6.270504] rtc rtc0: rtc_cmos: dev (254:0)
[    6.272013] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    6.274008] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    6.278387] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    6.282508] pps pps0: new PPS source ktimer
[    6.283912] pps pps0: ktimer PPS source registered
[    6.285642] Driver for 1-wire Dallas network protocol.
[    6.288547] f71882fg: Not a Fintek device
[    6.290118] f71882fg: Not a Fintek device
[    6.293049] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    6.295536] sdhci: Secure Digital Host Controller Interface driver
[    6.297436] sdhci: Copyright(c) Pierre Ossman
[    6.299072] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    6.300889] wbsd: Copyright(c) Pierre Ossman
[    6.302511] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    6.304696] usbcore: registered new interface driver vub300
[    6.323493] usbcore: registered new interface driver ushc
[    6.325164] sdhci-pltfm: SDHCI platform and OF driver helper
[    6.327644] ledtrig-cpu: registered to indicate activity on CPUs
[    6.333624] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    6.336139] hidraw: raw HID events driver (C) Jiri Kosina
[    6.339171] usbcore: registered new interface driver usbhid
[    6.340851] usbhid: USB HID core driver
[    6.342612] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.344428] usbip_core: usbip_core_init:805: USB/IP Core v1.0.0
[    6.346451] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    6.348250] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    6.350225] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 1
[    6.352260] vhci_hcd: vhci_start:884: enter vhci_start
[    6.356034] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    6.357988] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    6.360393] usb usb1: Product: USB/IP Virtual Host Controller
[    6.362128] usb usb1: Manufacturer: Linux 3.12.0-10878-g2c57502 vhci_hcd
[    6.364067] usb usb1: SerialNumber: vhci_hcd
[    6.368053] hub 1-0:1.0: USB hub found
[    6.369426] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIn=
dex 0
[    6.371685] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    6.373402] vhci_hcd: vhci_hub_control:398: port -1
[    6.374919] vhci_hcd: vhci_hub_control:405:  bye
[    6.376611] hub 1-0:1.0: 8 ports detected
[    6.378280] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex=
 0
[    6.380380] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    6.381996] vhci_hcd: vhci_hub_control:398: port -1
[    6.383489] vhci_hcd: vhci_hub_control:405:  bye
[    6.385731] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 1
[    6.387680] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    6.389590] vhci_hcd: vhci_hub_control:398: port 0
[    6.391095] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    6.393695] vhci_hcd: dump_port_status_diff:115:  +POWER
[    6.395285] vhci_hcd: dump_port_status_diff:119:=20
[    6.396862] vhci_hcd: vhci_hub_control:405:  bye
[    6.398366] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 2
[    6.400360] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    6.402215] vhci_hcd: vhci_hub_control:398: port 1
[    6.403718] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    6.406448] vhci_hcd: dump_port_status_diff:115:  +POWER
[    6.408145] vhci_hcd: dump_port_status_diff:119:=20
[    6.409646] vhci_hcd: vhci_hub_control:405:  bye
[    6.411159] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 3
[    6.413137] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    6.414992] vhci_hcd: vhci_hub_control:398: port 2
[    6.416562] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    6.419052] vhci_hcd: dump_port_status_diff:115:  +POWER
[    6.420702] vhci_hcd: dump_port_status_diff:119:=20
[    6.422155] vhci_hcd: vhci_hub_control:405:  bye
[    6.423622] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 4
[    6.425549] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    6.427369] vhci_hcd: vhci_hub_control:398: port 3
[    6.428899] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    6.431340] vhci_hcd: dump_port_status_diff:115:  +POWER
[    6.432964] vhci_hcd: dump_port_status_diff:119:=20
[    6.434395] vhci_hcd: vhci_hub_control:405:  bye
[    6.436069] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 5
[    6.438001] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    6.439823] vhci_hcd: vhci_hub_control:398: port 4
[    6.441367] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    6.443883] vhci_hcd: dump_port_status_diff:115:  +POWER
[    6.445514] vhci_hcd: dump_port_status_diff:119:=20
[    6.446967] vhci_hcd: vhci_hub_control:405:  bye
[    6.448532] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 6
[    6.450454] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    6.452368] vhci_hcd: vhci_hub_control:398: port 5
[    6.453903] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    6.456515] vhci_hcd: dump_port_status_diff:115:  +POWER
[    6.458132] vhci_hcd: dump_port_status_diff:119:=20
[    6.459571] vhci_hcd: vhci_hub_control:405:  bye
[    6.461110] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 7
[    6.463000] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    6.464867] vhci_hcd: vhci_hub_control:398: port 6
[    6.466565] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    6.469112] vhci_hcd: dump_port_status_diff:115:  +POWER
[    6.470709] vhci_hcd: dump_port_status_diff:119:=20
[    6.472235] vhci_hcd: vhci_hub_control:405:  bye
[    6.473762] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 8
[    6.475691] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    6.477628] vhci_hcd: vhci_hub_control:398: port 7
[    6.479125] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    6.481737] vhci_hcd: dump_port_status_diff:115:  +POWER
[    6.483344] vhci_hcd: dump_port_status_diff:119:=20
[    6.484914] vhci_hcd: vhci_hub_control:405:  bye
[    6.486916] vhci_hcd: vhci_hcd_probe:1028: bye
[    6.488480] vhci_hcd: vhci_hcd_init:1150: USB/IP 'Virtual' Host Controll=
er (VHCI) Driver v1.0.0
[    6.491360] usbcore: registered new interface driver usbip-host
[    6.493192] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    6.495129] usbcore: registered new interface driver tranzport
[    6.497000] usbcore: registered new interface driver alphatrack
[    6.499071] Loading crystalhd 0.9.27
[    6.501434] ozwpan ozwpan: Ozmo Devices WPAN
[    6.502871] ozwpan ozwpan: new USB bus registered, assigned bus number 2
[    6.505121] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    6.507023] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    6.509462] usb usb2: Product: Ozmo Devices WPAN
[    6.510939] usb usb2: Manufacturer: Linux 3.12.0-10878-g2c57502 Ozmo WPAN
[    6.512905] usb usb2: SerialNumber: ozwpan
[    6.515246] hub 2-0:1.0: USB hub found
[    6.516731] hub 2-0:1.0: 8 ports detected
[    6.519523] usbcore: registered new interface driver gdm_wimax
[    6.522145] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[    6.523801] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[    6.528122] NET: Registered protocol family 26
[    6.529627] netem: version 1.3
[    6.530854] Netfilter messages via NETLINK v0.30.
[    6.532351] nfnl_acct: registering with nfnetlink.
[    6.534066] nf_conntrack version 0.5.0 (2973 buckets, 11892 max)
[    6.536340] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    6.538055] nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilte=
r.org>
[    6.540750] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.542519] arp_tables: (C) 2002 David S. Miller
[    6.543921] TCP: cubic registered
[    6.544970] NET: Registered protocol family 17
[    6.546433] NET: Registered protocol family 15
[    6.547798] NET: Registered protocol family 9
[    6.549157] X.25 for Linux Version 0.2
[    6.550545] NET: Registered protocol family 35
[    6.553528] DCCP: Activated CCID 2 (TCP-like)
[    6.554842] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    6.557577] sctp: Hash tables configured (established 1638 bind 1489)
[    6.559585] Key type dns_resolver registered
[    6.560997] Key type ceph registered
[    6.562183] libceph: loaded (mon/osd proto 15/24)
[    6.563949] batman_adv: B.A.T.M.A.N. advanced 2013.5.0 (compatibility ve=
rsion 15) loaded
[    6.566172] openvswitch: Open vSwitch switching datapath
[    6.570218] Loading module verification certificates
[    6.581615] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 762993=
4306824afc1c6d026437bdabc955942f84'
[    6.584225] registered taskstats version 1
[    6.587614] Key type trusted registered
[    6.590517] rtc_cmos 00:00: setting system clock to 2014-03-08 07:42:08 =
UTC (1394264528)
[    6.592880] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    6.596369] debug: unmapping init [mem 0xc202e000-0xc20f2fff]
[    6.598825] Write protecting the kernel text: 19736k
[    6.600430] Write protecting the kernel read-only data: 7112k
[    6.613615] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 1
[    6.615663] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    6.617551] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    6.619428] vhci_hcd: vhci_hub_control:398: port 0
[    6.620983] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    6.623487] vhci_hcd: dump_port_status_diff:115:   POWER
[    6.625166] vhci_hcd: dump_port_status_diff:119:=20
[    6.626679] vhci_hcd: vhci_hub_control:405:  bye
[    6.640389] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 2
[    6.642417] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    6.644261] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    6.646105] vhci_hcd: vhci_hub_control:398: port 1
[    6.647604] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    6.650175] vhci_hcd: dump_port_status_diff:115:   POWER
[    6.651790] vhci_hcd: dump_port_status_diff:119:=20
[    6.653282] vhci_hcd: vhci_hub_control:405:  bye
[    6.656645] random: init urandom read with 102 bits of entropy available
[    6.691396] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 3
[    6.693476] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    6.695256] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    6.697184] vhci_hcd: vhci_hub_control:398: port 2
[    6.698706] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    6.701223] vhci_hcd: dump_port_status_diff:115:   POWER
[    6.702858] vhci_hcd: dump_port_status_diff:119:=20
[    6.704388] vhci_hcd: vhci_hub_control:405:  bye
[    6.813217] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 4
[    6.815244] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    6.817118] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    6.818937] vhci_hcd: vhci_hub_control:398: port 3
[    6.820452] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    6.822922] vhci_hcd: dump_port_status_diff:115:   POWER
[    6.824548] vhci_hcd: dump_port_status_diff:119:=20
[    6.825972] vhci_hcd: vhci_hub_control:405:  bye
[    6.868597] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 5
[    6.870496] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    6.872079] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    6.873835] vhci_hcd: vhci_hub_control:398: port 4
[    6.875114] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    6.877456] vhci_hcd: dump_port_status_diff:115:   POWER
[    6.878898] vhci_hcd: dump_port_status_diff:119:=20
[    6.880318] vhci_hcd: vhci_hub_control:405:  bye
[    6.908395] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 6
[    6.910294] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    6.911925] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    6.913642] vhci_hcd: vhci_hub_control:398: port 5
[    6.915061] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    6.917414] vhci_hcd: dump_port_status_diff:115:   POWER
[    6.918907] vhci_hcd: dump_port_status_diff:119:=20
[    6.920208] vhci_hcd: vhci_hub_control:405:  bye
[    6.941487] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 7
[    6.943341] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    6.945000] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    6.946632] vhci_hcd: vhci_hub_control:398: port 6
[    6.948066] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    6.950444] vhci_hcd: dump_port_status_diff:115:   POWER
[    6.951918] vhci_hcd: dump_port_status_diff:119:=20
[    6.953207] vhci_hcd: vhci_hub_control:405:  bye
[    6.975830] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 8
[    6.977701] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    6.979455] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    6.981090] vhci_hcd: vhci_hub_control:398: port 7
[    6.982509] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    6.984831] vhci_hcd: dump_port_status_diff:115:   POWER
[    6.986260] vhci_hcd: dump_port_status_diff:119:=20
[    6.987692] vhci_hcd: vhci_hub_control:405:  bye
[    7.014479] init: Failed to create pty - disabling logging for job
[    7.016556] init: Temporary process spawn error: No such file or directo=
ry
[    7.049041] init: Failed to create pty - disabling logging for job
[    7.051075] init: Temporary process spawn error: No such file or directo=
ry
[    7.116339] init: Failed to create pty - disabling logging for job
[    7.118425] init: Temporary process spawn error: No such file or directo=
ry
[    7.126484] init: Failed to create pty - disabling logging for job
[    7.128487] init: Temporary process spawn error: No such file or directo=
ry
[    7.263621] init: Failed to create pty - disabling logging for job
[    7.267617] init: Temporary process spawn error: No such file or directo=
ry
[    7.279300] init: Failed to create pty - disabling logging for job
[    7.286369] init: Temporary process spawn error: No such file or directo=
ry
[    7.305990] init: Failed to create pty - disabling logging for job
[    7.314962] init: Temporary process spawn error: No such file or directo=
ry
[    7.326281] init: Failed to create pty - disabling logging for job
[    7.342782] init: Failed to create pty - disabling logging for job
[    7.377691] init: Failed to create pty - disabling logging for job
[    7.395680] init: Failed to create pty - disabling logging for job
[    7.409201] init: Failed to create pty - disabling logging for job
[    8.215262] ------------[ cut here ]------------
[    8.215318] WARNING: CPU: 0 PID: 287 at /kernel-tests/linux4/kernel/soft=
irq.c:156 local_bh_enable+0xbf/0x20e()
[    8.215331] Modules linked in:
[    8.215338] CPU: 0 PID: 287 Comm: blkid Not tainted 3.12.0-10878-g2c5750=
2 #109
[    8.215340] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    8.215355]  00000000 c53a5bd0 c152b622 c53a5be8 c0259135 c025fdb2 c068e=
196 00000000
[    8.215364]  c56dac00 c53a5bf8 c02591a1 00000009 00000000 c53a5c04 c025f=
db2 00000000
[    8.215372]  c53a5cac c068e196 00000001 00000000 c56d6000 c57ba840 c56da=
c00 c068002f
[    8.215374] Call Trace:
[    8.215403]  [<c152b622>] dump_stack+0x40/0x5e
[    8.215408]  [<c0259135>] warn_slowpath_common+0xa9/0xea
[    8.215413]  [<c025fdb2>] ? local_bh_enable+0xbf/0x20e
[    8.215435]  [<c068e196>] ? __cfq_set_active_queue+0x110/0x27d
[    8.215440]  [<c02591a1>] warn_slowpath_null+0x2b/0x3d
[    8.215444]  [<c025fdb2>] local_bh_enable+0xbf/0x20e
[    8.215449]  [<c068e196>] __cfq_set_active_queue+0x110/0x27d
[    8.215454]  [<c068002f>] ? add_disk+0x12c/0x781
[    8.215459]  [<c06907a9>] ? cfq_resort_rr_list+0x49/0x5b
[    8.215463]  [<c0690899>] ? cfq_add_cfqq_rr+0xde/0xf3
[    8.215468]  [<c0690c67>] ? cfq_update_idle_window.isra.78+0xf2/0x1f4
[    8.215480]  [<c0294d19>] ? sched_clock_cpu+0x1c4/0x1f9
[    8.215487]  [<c029fb08>] ? trace_hardirqs_off+0x27/0x37
[    8.215492]  [<c0294e4d>] ? local_clock+0xff/0x176
[    8.215497]  [<c06951f7>] cfq_dispatch_requests+0xb92/0x11b0
[    8.215504]  [<c024812f>] ? kvm_clock_read+0x30/0x55
[    8.215515]  [<c020f559>] ? sched_clock+0x3e/0x50
[    8.215520]  [<c06931f4>] ? cfq_insert_request+0x3c9/0x869
[    8.215525]  [<c029fb08>] ? trace_hardirqs_off+0x27/0x37
[    8.215530]  [<c02a77fb>] ? __lock_acquire+0x15a4/0x16ca
[    8.215538]  [<c06aec9f>] ? list_sort+0x1fb/0x253
[    8.215547]  [<c066e10c>] blk_peek_request+0x9e/0x31a
[    8.215566]  [<c0b523bf>] scsi_request_fn+0x62/0x89e
[    8.215571]  [<c066e8fd>] ? blk_flush_plug_list+0x2a4/0x447
[    8.215577]  [<c0668eec>] __blk_run_queue+0x55/0x6c
[    8.215582]  [<c066c588>] queue_unplugged.isra.29+0x40/0x6a
[    8.215586]  [<c066e9bf>] blk_flush_plug_list+0x366/0x447
[    8.215591]  [<c066eabb>] blk_finish_plug+0x1b/0x51
[    8.215607]  [<c03275e3>] __do_page_cache_readahead+0x314/0x364
[    8.215614]  [<c032772f>] force_page_cache_readahead+0x9e/0xea
[    8.215620]  [<c0327d36>] page_cache_sync_readahead+0x5d/0x91
[    8.215624]  [<c0319608>] generic_file_aio_read+0x393/0xb7e
[    8.215638]  [<c03c7bb9>] blkdev_aio_read+0x95/0xb1
[    8.215646]  [<c0375ec0>] do_sync_read+0x5a/0xab
[    8.215651]  [<c0375e66>] ? do_sync_write+0xab/0xab
[    8.215655]  [<c0376b3b>] vfs_read+0xd3/0x1ee
[    8.215659]  [<c0376e5f>] SyS_read+0x73/0xe8
[    8.215668]  [<c154488a>] sysenter_do_call+0x12/0x3c
[    8.215672] ---[ end trace 6f72697fe2d05017 ]---
[    8.215727]=20
[    8.215729] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    8.215730] [ INFO: inconsistent lock state ]
[    8.215733] 3.12.0-10878-g2c57502 #109 Tainted: G        W  =20
[    8.215735] ---------------------------------
[    8.215737] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[    8.215740] blkid/287 [HC0[0]:SC0[0]:HE1:SE1] takes:
[    8.215749]  (&(&q->__queue_lock)->rlock){+.?...}, at: [<c066e8fd>] blk_=
flush_plug_list+0x2a4/0x447
[    8.215750] {IN-SOFTIRQ-W} state was registered at:
[    8.215756]   [<c02a7102>] __lock_acquire+0xeab/0x16ca
[    8.215760]   [<c02a7a07>] lock_acquire+0xe6/0x147
[    8.215767]   [<c1542430>] _raw_spin_lock+0x4e/0xee
[    8.215771]   [<c0b52ce9>] scsi_device_unbusy+0xee/0x134
[    8.215781]   [<c0b47e22>] scsi_finish_command+0x2b/0x107
[    8.215785]   [<c0b5303f>] scsi_softirq_done+0x1b5/0x1cb
[    8.215791]   [<c067666b>] blk_done_softirq+0x10e/0x133
[    8.215796]   [<c025f5db>] __do_softirq+0x114/0x318
[    8.215798] irq event stamp: 2152
[    8.215803] hardirqs last  enabled at (2149): [<c1542a61>] _raw_spin_unl=
ock_irq+0x5a/0xba
[    8.215808] hardirqs last disabled at (2150): [<c066e858>] blk_flush_plu=
g_list+0x1ff/0x447
[    8.215813] softirqs last  enabled at (2152): [<c068e196>] __cfq_set_act=
ive_queue+0x110/0x27d
[    8.215818] softirqs last disabled at (2151): [<c068e15f>] __cfq_set_act=
ive_queue+0xd9/0x27d
[    8.215820]=20
[    8.215820] other info that might help us debug this:
[    8.215824]  Possible unsafe locking scenario:
[    8.215824]=20
[    8.215825]        CPU0
[    8.215827]        ----
[    8.215830]   lock(&(&q->__queue_lock)->rlock);
[    8.215831]   <Interrupt>
[    8.215833]     lock(&(&q->__queue_lock)->rlock);
[    8.215834]=20
[    8.215834]  *** DEADLOCK ***
[    8.215834]=20
[    8.215837] 1 lock held by blkid/287:
[    8.215844]  #0:  (&(&q->__queue_lock)->rlock){+.?...}, at: [<c066e8fd>]=
 blk_flush_plug_list+0x2a4/0x447
[    8.215846]=20
[    8.215846] stack backtrace:
[    8.215849] CPU: 0 PID: 287 Comm: blkid Tainted: G        W    3.12.0-10=
878-g2c57502 #109
[    8.215851] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    8.215859]  00000000 c53a5b78 c152b622 c53a5b98 c15263b3 c1a4e107 c1a4d=
edf c1a4ed62
[    8.215867]  00000006 c535a8b0 00000040 c53a5bc0 c02a5d9e 00000006 00000=
000 c02a2e66
[    8.215875]  00000004 c535a530 c535a8b0 c535a530 00000000 c53a5be0 c02a9=
2e0 e2d05017
[    8.215876] Call Trace:
[    8.215881]  [<c152b622>] dump_stack+0x40/0x5e
[    8.215891]  [<c15263b3>] print_usage_bug+0x493/0x4ad
[    8.215896]  [<c02a5d9e>] mark_lock+0x575/0xa2e
[    8.215901]  [<c02a2e66>] ? print_irq_inversion_bug+0x374/0x374
[    8.215905]  [<c02a92e0>] mark_held_locks+0x163/0x199
[    8.215910]  [<c025feb5>] ? local_bh_enable+0x1c2/0x20e
[    8.215915]  [<c02a9681>] trace_hardirqs_on_caller+0x36b/0x3b1
[    8.215920]  [<c068e196>] ? __cfq_set_active_queue+0x110/0x27d
[    8.215924]  [<c02a96ee>] trace_hardirqs_on+0x27/0x37
[    8.215928]  [<c025feb5>] local_bh_enable+0x1c2/0x20e
[    8.215932]  [<c068e196>] __cfq_set_active_queue+0x110/0x27d
[    8.215937]  [<c068002f>] ? add_disk+0x12c/0x781
[    8.215941]  [<c06907a9>] ? cfq_resort_rr_list+0x49/0x5b
[    8.215945]  [<c0690899>] ? cfq_add_cfqq_rr+0xde/0xf3
[    8.215949]  [<c0690c67>] ? cfq_update_idle_window.isra.78+0xf2/0x1f4
[    8.215953]  [<c0294d19>] ? sched_clock_cpu+0x1c4/0x1f9
[    8.215958]  [<c029fb08>] ? trace_hardirqs_off+0x27/0x37
[    8.215962]  [<c0294e4d>] ? local_clock+0xff/0x176
[    8.215966]  [<c06951f7>] cfq_dispatch_requests+0xb92/0x11b0
[    8.215970]  [<c024812f>] ? kvm_clock_read+0x30/0x55
[    8.215975]  [<c020f559>] ? sched_clock+0x3e/0x50
[    8.215979]  [<c06931f4>] ? cfq_insert_request+0x3c9/0x869
[    8.215984]  [<c029fb08>] ? trace_hardirqs_off+0x27/0x37
[    8.215988]  [<c02a77fb>] ? __lock_acquire+0x15a4/0x16ca
[    8.215992]  [<c06aec9f>] ? list_sort+0x1fb/0x253
[    8.215997]  [<c066e10c>] blk_peek_request+0x9e/0x31a
[    8.216001]  [<c0b523bf>] scsi_request_fn+0x62/0x89e
[    8.216006]  [<c066e8fd>] ? blk_flush_plug_list+0x2a4/0x447
[    8.216010]  [<c0668eec>] __blk_run_queue+0x55/0x6c
[    8.216015]  [<c066c588>] queue_unplugged.isra.29+0x40/0x6a
[    8.216019]  [<c066e9bf>] blk_flush_plug_list+0x366/0x447
[    8.216024]  [<c066eabb>] blk_finish_plug+0x1b/0x51
[    8.216029]  [<c03275e3>] __do_page_cache_readahead+0x314/0x364
[    8.216035]  [<c032772f>] force_page_cache_readahead+0x9e/0xea
[    8.216040]  [<c0327d36>] page_cache_sync_readahead+0x5d/0x91
[    8.216044]  [<c0319608>] generic_file_aio_read+0x393/0xb7e
[    8.216051]  [<c03c7bb9>] blkdev_aio_read+0x95/0xb1
[    8.216055]  [<c0375ec0>] do_sync_read+0x5a/0xab
[    8.216059]  [<c0375e66>] ? do_sync_write+0xab/0xab
[    8.216063]  [<c0376b3b>] vfs_read+0xd3/0x1ee
[    8.216067]  [<c0376e5f>] SyS_read+0x73/0xe8
[    8.216071]  [<c154488a>] sysenter_do_call+0x12/0x3c
[    8.235829] init: Failed to create pty - disabling logging for job
[    8.235946] init: Temporary process spawn error: No such file or directo=
ry
[    8.540957] init: Failed to create pty - disabling logging for job
[    8.541089] init: Temporary process spawn error: No such file or directo=
ry
[    8.558060] init: Failed to create pty - disabling logging for job
[    8.558234] init: Temporary process spawn error: No such file or directo=
ry
[    8.579991] init: Failed to create pty - disabling logging for job
[    8.580107] init: Temporary process spawn error: No such file or directo=
ry
[    8.638537] init: Failed to create pty - disabling logging for job
[    8.640374] init: Temporary process spawn error: No such file or directo=
ry
[    8.663372] init: udev-fallback-graphics main process (306) terminated w=
ith status 127
[    8.668930] init: Failed to create pty - disabling logging for job
[    8.670726] init: Temporary process spawn error: No such file or directo=
ry
[    8.684489] init: Failed to create pty - disabling logging for job
[    8.686565] init: Temporary process spawn error: No such file or directo=
ry
[    8.697089] init: Failed to create pty - disabling logging for job
[    8.698901] init: Temporary process spawn error: No such file or directo=
ry
[    8.715879] init: plymouth-splash main process (317) terminated with sta=
tus 1
[    8.752222] init: failsafe main process (294) killed by TERM signal
[    8.759567] init: networking main process (319) terminated with status 1
[    8.839847] init: Failed to create pty - disabling logging for job
[    8.852410] init: Failed to create pty - disabling logging for job
[    8.893808] init: Failed to create pty - disabling logging for job
[    8.906482] init: Failed to create pty - disabling logging for job
[    8.918966] init: Failed to create pty - disabling logging for job
Kernel tests: Boot OK!
[   66.931191] init: Failed to create pty - disabling logging for job
[   68.291879] reboot: Restarting system
Elapsed time: 80
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-x=
1-03070634/2c575026fae6e63771bd2a4c1d407214a8096a89/vmlinuz-3.12.0-10878-g2=
c57502 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/i386-randconfig-x1-03070634/next:master:2c575026fae6e=
63771bd2a4c1d407214a8096a89:bisect-linux4/.vmlinuz-2c575026fae6e63771bd2a4c=
1d407214a8096a89-20140308074123-14-snb branch=3Dnext/master BOOT_IMAGE=3D/k=
ernel/i386-randconfig-x1-03070634/2c575026fae6e63771bd2a4c1d407214a8096a89/=
vmlinuz-3.12.0-10878-g2c57502'  -initrd /kernel-tests/initrd/quantal-core-i=
386.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,ho=
stfwd=3Dtcp::11312-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc =
base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-quantal-snb-14,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-snb-14,medi=
a=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-snb-14,med=
ia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-quantal-snb-14,me=
dia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-quantal-snb-14,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-quantal-snb-14,=
media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-snb-14 -serial=
 file:/dev/shm/kboot/serial-quantal-snb-14 -daemonize -display none -monito=
r null=20

--DKU6Jbt7q3WqK7+M--
