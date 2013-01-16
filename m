Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502Ab3APEei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 23:34:38 -0500
Received: from nm6-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.158]:32979
	"EHLO nm6-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758159Ab3APEeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 23:34:36 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2013 23:34:36 EST
X-Yahoo-Newman-Id: 402322.84257.bm@smtp102.rog.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6ME_r6EVM1kIJ0KFQP4_9Ew3i_6tBLXKHlaZRV4a4Lw6DiB
 d8HEDle.iRrmIwNYDMo4A3bJ1POms7JjKdHFtnCPiGTNJYRllaMisplJ3IFJ
 YeIaqOj7HCcGQSTx6Wsd1lV90A3nVGUlRi5AQ0MvK9rrJMLploKHe_4cEcS5
 bs51Kf_YkgBaQ1gQ1dMNoYMZtBrXW7RMOe9BC7L0Xnffe9GceR6uiqrrFBOB
 9cNeia8A8dLWfo3lw1lWlfX_SKV4CwUAjQartjXHGH.rJQ0arIsDYR8rjlMj
 X7IT4vQVFIpV_ZgebAuSI_endTxwfopTJ6O9dTRIcO8y3Z_lsdsBJL1X0sZQ
 QMDvKfQW0mKOseR2oHCeXNuJcnTiubHxcSrgYRtGVo3I7YakceAeuH9K8l7a
 eq2ouS.Vui6v1Ll3eurEdH1xa_11o6AWNZSM1H2Vy8JCo5kLz3mLiuaZZH6J
 zes5TuttvGpEMvxQeafuQV9N8kPhndgQ-
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [3.8.0-0.rc3.git1.2] Processes hanging after unmounting mm0 device (not confirmed related)
Date: Tue, 15 Jan 2013 23:28:24 -0500
Message-ID: <3520549.SVOXqlzsTf@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.9.4 (Linux/3.8.0-0.rc3.git1.2.fc19.x86_64; KDE/4.9.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello kernel folks,

I am seeing problems with snapshot 3.8.0-0.rc3.git1.2 [fc19].

Processes hanging after it appears unmounting my mmc0 (SD) card, I will attempt to reproduce but, I am unclear if the two are related at this moment

<kernel conversation>

[ 9127.631555] mmc0: new high speed SDHC card at address 1234
[ 9127.665816] mmcblk0: mmc0:1234 SA08G 7.42 GiB 
[ 9127.667810]  mmcblk0: p1
[ 9273.215847] mmc0: card 1234 removed
[ 9273.219007] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[ 9273.276972] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[ 9273.336307] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[ 9273.394115] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[ 9273.453340] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[ 9284.165082] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[ 9284.226002] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[ 9284.293369] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[ 9284.360836] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.

Live stack trace:

[10336.859532] SysRq : Show Blocked State
[10336.859538]   task                        PC stack   pid father
[10336.859546] khugepaged      D ffff88023bc93d80     0    32      2 0x00000000
[10336.859551]  ffff88022ff07c80 0000000000000046 ffff88022fef1760 ffff88022ff07fd8
[10336.859555]  ffff88022ff07fd8 ffff88022ff07fd8 ffff880230149760 ffff88022fef1760
[10336.859558]  ffffffff81e8b500 ffff88022fef1760 ffff88022a5e9568 ffffffffffffffff
[10336.859562] Call Trace:
[10336.859574]  [<ffffffff8164ba19>] schedule+0x29/0x70
[10336.859578]  [<ffffffff8164c7c5>] rwsem_down_failed_common+0xb5/0x140
[10336.859581]  [<ffffffff8164c885>] rwsem_down_read_failed+0x15/0x17
[10336.859587]  [<ffffffff81302594>] call_rwsem_down_read_failed+0x14/0x30
[10336.859591]  [<ffffffff8164acb4>] ? down_read+0x24/0x2b
[10336.859597]  [<ffffffff8118bdcd>] khugepaged+0x17d/0x15b0
[10336.859602]  [<ffffffff81082670>] ? wake_up_bit+0x40/0x40
[10336.859606]  [<ffffffff8118bc50>] ? maybe_pmd_mkwrite+0x20/0x20
[10336.859609]  [<ffffffff81081d60>] kthread+0xc0/0xd0
[10336.859614]  [<ffffffff81010000>] ? ftrace_define_fields_xen_mc_entry+0x30/0xf0
[10336.859618]  [<ffffffff81081ca0>] ? kthread_create_on_node+0x120/0x120
[10336.859622]  [<ffffffff816550ec>] ret_from_fork+0x7c/0xb0
[10336.859626]  [<ffffffff81081ca0>] ? kthread_create_on_node+0x120/0x120

[10336.859678] qemu-kvm        D ffff88023bc93d80     0  3697      1 0x00000080
[10336.859682]  ffff8801e0a77cb8 0000000000000086 ffff880190751760 ffff8801e0a77fd8
[10336.859686]  ffff8801e0a77fd8 ffff8801e0a77fd8 ffff8801c3b2aec0 ffff880190751760
[10336.859689]  ffff8801e0a77cb8 ffff880190751760 ffff880212659c88 ffffffffffffffff
[10336.859692] Call Trace:
[10336.859697]  [<ffffffff8164ba19>] schedule+0x29/0x70
[10336.859700]  [<ffffffff8164c7c5>] rwsem_down_failed_common+0xb5/0x140
[10336.859704]  [<ffffffff8164c863>] rwsem_down_write_failed+0x13/0x20
[10336.859708]  [<ffffffff813025c3>] call_rwsem_down_write_failed+0x13/0x20
[10336.859712]  [<ffffffff8164ac82>] ? down_write+0x32/0x40
[10336.859716]  [<ffffffff81162d7d>] vma_adjust+0x10d/0x770
[10336.859720]  [<ffffffff81163867>] vma_merge+0x267/0x320
[10336.859723]  [<ffffffff811649a2>] do_brk+0x1e2/0x370
[10336.859727]  [<ffffffff81164cde>] sys_brk+0x13e/0x150
[10336.859730]  [<ffffffff81655199>] system_call_fastpath+0x16/0x1b

[10336.859785] ps              D ffff88023bc93d80     0  3709   3708 0x00000080
[10336.859788]  ffff88018a765c90 0000000000000086 ffff8801c8161760 ffff88018a765fd8
[10336.859791]  ffff88018a765fd8 ffff88018a765fd8 ffff880230149760 ffff8801c8161760
[10336.859795]  0000000000000001 ffff8801c8161760 ffff88022a5e9568 fffffffeffffffff
[10336.859798] Call Trace:
[10336.859802]  [<ffffffff8164ba19>] schedule+0x29/0x70
[10336.859805]  [<ffffffff8164c7c5>] rwsem_down_failed_common+0xb5/0x140
[10336.859809]  [<ffffffff8164c885>] rwsem_down_read_failed+0x15/0x17
[10336.859813]  [<ffffffff81302594>] call_rwsem_down_read_failed+0x14/0x30
[10336.859817]  [<ffffffff8164acb4>] ? down_read+0x24/0x2b
[10336.859820]  [<ffffffff8115f8df>] __access_remote_vm+0x3f/0x1d0
[10336.859823]  [<ffffffff8116018f>] access_process_vm+0x5f/0x90
[10336.859828]  [<ffffffff8120320a>] proc_pid_cmdline+0x9a/0x130
[10336.859831]  [<ffffffff81203e7f>] proc_info_read+0x9f/0xf0
[10336.859836]  [<ffffffff8119d569>] vfs_read+0xa9/0x180
[10336.859839]  [<ffffffff8119d692>] sys_read+0x52/0xa0
[10336.859843]  [<ffffffff810dec8c>] ? __audit_syscall_exit+0x20c/0x2c0
[10336.859847]  [<ffffffff81655199>] system_call_fastpath+0x16/0x1b

There are more but they show same point in the stack per process.

Active CPU backtrace:

[10718.740248] SysRq : Show backtrace of all active CPUs
[10718.740252] sending NMI to all CPUs:
[10718.740258] NMI backtrace for cpu 0
[10718.740259] CPU 0 
[10718.740262] Pid: 7864, comm: bash Not tainted 3.8.0-0.rc3.git1.2.fc19.x86_64 #1 LENOVO 4058CTO/4058CTO
[10718.740264] RIP: 0010:[<ffffffff81301132>]  [<ffffffff81301132>] __const_udelay+0x12/0x30
[10718.740271] RSP: 0018:ffff88022a7dde08  EFLAGS: 00000046
[10718.740272] RAX: 0000000001062560 RBX: 0000000000002710 RCX: 0000000000000002
[10718.740274] RDX: 0000000000268f12 RSI: 0000000000000080 RDI: 0000000000418958
[10718.740275] RBP: ffff88022a7dde28 R08: 20676e69646e6573 R09: 00000000000024db
[10718.740276] R10: 61206f7420494d4e R11: 3a73555043206c6c R12: 000000000000006c
[10718.740278] R13: 0000000000000286 R14: 0000000000000000 R15: 0000000000000004
[10718.740280] FS:  00007fcdd239e740(0000) GS:ffff88023bc00000(0000) knlGS:0000000000000000
[10718.740281] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10718.740283] CR2: 00000000014940d0 CR3: 00000001e0beb000 CR4: 00000000000427f0
[10718.740284] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10718.740286] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[10718.740287] Process bash (pid: 7864, threadinfo ffff88022a7dc000, task ffff88022f538000)
[10718.740288] Stack:
[10718.740290]  ffff88022a7dde28 ffffffff81039efa 0000000000000000 ffffffff81c88120
[10718.740292]  ffff88022a7dde38 ffffffff813b3d1e ffff88022a7dde78 ffffffff813b4187
[10718.740294]  ffff88022a7ddf08 0000000000000002 ffff8801906d3c00 00007fcdd23bc000
[10718.740297] Call Trace:
[10718.740302]  [<ffffffff81039efa>] ? arch_trigger_all_cpu_backtrace+0x6a/0xa0
[10718.740306]  [<ffffffff813b3d1e>] sysrq_handle_showallcpus+0xe/0x10
[10718.740308]  [<ffffffff813b4187>] __handle_sysrq+0x127/0x190
[10718.740311]  [<ffffffff813b423a>] write_sysrq_trigger+0x4a/0x50
[10718.740314]  [<ffffffff812026a8>] proc_reg_write+0x78/0xb0
[10718.740317]  [<ffffffff8119d3ec>] vfs_write+0xac/0x180
[10718.740319]  [<ffffffff8119d732>] sys_write+0x52/0xa0
[10718.740322]  [<ffffffff810dec8c>] ? __audit_syscall_exit+0x20c/0x2c0
[10718.740326]  [<ffffffff81655199>] system_call_fastpath+0x16/0x1b
[10718.740327] Code: 89 e5 ff 15 a9 ce 97 00 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 8d 04 bd 00 00 00 00 65 48 8b 14 25 d8 3c 01 00 <48> 89 e5 48 69 d2 fa 00 00 00 f7 e2 48 8d 7a 01 ff 15 70 ce 97 
[10718.740349] NMI backtrace for cpu 1
[10718.740350] CPU 1 
[10718.740353] Pid: 758, comm: Xorg Not tainted 3.8.0-0.rc3.git1.2.fc19.x86_64 #1 LENOVO 4058CTO/4058CTO
[10718.740355] RIP: 0033:[<0000000000474187>]  [<0000000000474187>] 0x474186
[10718.740371] RSP: 002b:00007fff4f48e648  EFLAGS: 00003202
[10718.740373] RAX: 000000000080d9a4 RBX: 0000000003285a50 RCX: fffffdffffffffff
[10718.740374] RDX: 0000000000000014 RSI: 0000000000000000 RDI: 0000000000000020
[10718.740376] RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000081b9a0
[10718.740377] R10: 00000000008105c0 R11: 0000000000000000 R12: 0000000000000001
[10718.740378] R13: 0000000000000001 R14: 0000000000000000 R15: 00007fff4f48e680
[10718.740380] FS:  00007fd148d01940(0000) GS:ffff88023bc80000(0000) knlGS:0000000000000000
[10718.740382] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[10718.740383] CR2: 00000000014e8fe1 CR3: 000000022ffbc000 CR4: 00000000000427e0
[10718.740384] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10718.740386] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[10718.740388] Process Xorg (pid: 758, threadinfo ffff880229d12000, task ffff88022e8d8000)

Memory usage:

[10851.548392] SysRq : Show Memory
[10851.548398] Mem-Info:
[10851.548401] Node 0 DMA per-cpu:
[10851.548405] CPU    0: hi:    0, btch:   1 usd:   0
[10851.548407] CPU    1: hi:    0, btch:   1 usd:   0
[10851.548409] Node 0 DMA32 per-cpu:
[10851.548411] CPU    0: hi:  186, btch:  31 usd: 214
[10851.548413] CPU    1: hi:  186, btch:  31 usd: 211
[10851.548415] Node 0 Normal per-cpu:
[10851.548417] CPU    0: hi:  186, btch:  31 usd: 116
[10851.548419] CPU    1: hi:  186, btch:  31 usd: 173
[10851.548425] active_anon:220297 inactive_anon:42049 isolated_anon:0
 active_file:49906 inactive_file:137288 isolated_file:0
 unevictable:0 dirty:16 writeback:0 unstable:0
 free:1498976 slab_reclaimable:21341 slab_unreclaimable:9117
 mapped:52809 shmem:42309 pagetables:13227 bounce:0
 free_cma:0
[10851.548430] Node 0 DMA free:15896kB min:128kB low:160kB high:192kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB managed:15904kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[10851.548437] lowmem_reserve[]: 0 2967 7944 7944
[10851.548442] Node 0 DMA32 free:3007644kB min:25192kB low:31488kB high:37788kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3038524kB managed:2974660kB mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[10851.548448] lowmem_reserve[]: 0 0 4977 4977
[10851.548452] Node 0 Normal free:2972364kB min:42256kB low:52820kB high:63384kB active_anon:881188kB inactive_anon:168196kB active_file:199624kB inactive_file:549152kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:5096448kB managed:5045104kB mlocked:0kB dirty:64kB writeback:0kB mapped:211232kB shmem:169236kB slab_reclaimable:85364kB slab_unreclaimable:36460kB kernel_stack:2776kB pagetables:52908kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[10851.548459] lowmem_reserve[]: 0 0 0 0
[10851.548462] Node 0 DMA: 0*4kB 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15896kB
[10851.548477] Node 0 DMA32: 11*4kB (UM) 4*8kB (M) 5*16kB (M) 6*32kB (UM) 7*64kB (M) 7*128kB (UM) 6*256kB (M) 6*512kB (UM) 3*1024kB (UM) 2*2048kB (UM) 731*4096kB (MR) = 3007644kB
[10851.548492] Node 0 Normal: 281*4kB (UEM) 377*8kB (UEM) 3120*16kB (UEM) 8847*32kB (UEM) 4749*64kB (UEM) 2267*128kB (UEM) 1035*256kB (EM) 405*512kB (UEM) 190*1024kB (UEM) 57*2048kB (EM) 307*4096kB (MR) = 2972364kB
[10851.548508] 229502 total pagecache pages
[10851.548510] 0 pages in swap cache
[10851.548513] Swap cache stats: add 0, delete 0, find 0/0
[10851.548514] Free swap  = 0kB
[10851.548516] Total swap = 0kB
[10851.549119] 2080752 pages RAM
[10851.549119] 63133 pages reserved
[10851.549119] 821089 pages shared
[10851.549119] 400696 pages non-shared


