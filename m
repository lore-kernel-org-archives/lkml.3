Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaFMMzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 08:55:13 -0400
Received: from mail.sf-mail.de ([78.47.74.12]:48056 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaFMMzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:55:09 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [3.15.0] Sun V240: soft lockup - CPU stuck
Date: Fri, 13 Jun 2014 14:48:16 +0200
Message-ID: <3056970.qkBZsAdxy5@devpool02>
User-Agent: KMail/4.13.1 (Linux/3.14.4-2.g0de0f93-desktop; KDE/4.13.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this tonight while running a CMake dashboard build (that is where the
git command was invoked from). The machine has been running for weeks on
3.14 and I never saw this there. In case you need more information just ask.

Greetings,

Eike

[    0.000000] Linux version 3.15.0 (root@alrakis) (gcc version 4.7.3 (Gentoo 4.7.3 p1.3) ) #1 SMP Tue Jun 10 11:26:55 CEST 2014
[…]
[242339.538940] git[1513]: segfault at f77d9b70 ip 00000000f78f6838 (rpc 00000000f7a3e0ac) sp 00000000f77d93e0 error 30001 in libc-2.17.so[f7800000+16a000]
[242360.548826] INFO: rcu_sched self-detected stall on CPU { 1}  (t=2101 jiffies g=2435314 c=2435313 q=2249)
[242360.548847]   CPU[  0]: TSTATE[00000000f0000a03] TPC[00000000f7b4b0b4] TNPC[00000000f7b4b0b8] TASK[openssl:26204]
[242360.548856]              TPC[f7b4b0b4] O7[0] I7[f7b49d44] RPC[f7b49d44]
[242360.548862] * CPU[  1]: TSTATE[0000000011001600] TPC[00000000004fb7c4] TNPC[00000000004fb7c8] TASK[git:1513]
[242360.548896]              TPC[put_compound_page+0x4/0x260] O7[get_user_pages_fast+0x2fc/0x360] I7[get_futex_key+0x1bc/0x2a0] RPC[futex_wake+0x24/0x140]
[242361.678822] BUG: soft lockup - CPU#1 stuck for 22s! [git:1513]
[242361.756631] Modules linked in: ipv6 openpromfs libcrc32c multipath linear raid456 async_pq async_xor xor async_memcpy async_raid6_recov async_tx raid6_pq dm_snapshot dm_bufio dm_crypt dm_mirror dm_region_hash dm_log usb_storage sg
[242361.756678] CPU: 1 PID: 1513 Comm: git Not tainted 3.15.0 #1
[242361.756685] task: fffffc033a65cf00 ti: fffffc033c51c000 task.ti: fffffc033c51c000
[242361.756691] TSTATE: 0000004411001600 TPC: 00000000004fb9a8 TNPC: 00000000004fb9ac Y: 00000000    Not tainted
[242361.756699] TPC: <put_compound_page+0x1e8/0x260>
[242361.756704] g0: 0000000000000001 g1: 0000000000000000 g2: 0000000000000016 g3: 0000000000000000
[242361.756709] g4: fffffc033a65cf00 g5: fffffc133c572000 g6: fffffc033c51c000 g7: 0000000000484048
[242361.756715] o0: 0000000000000016 o1: 0000010002750000 o2: 0000000000400000 o3: 0000000000000001
[242361.756720] o4: 0000010002750000 o5: 0000000000a8e080 sp: fffffc033c51ebe1 ret_pc: 00000000004fb95c
[242361.756727] RPC: <put_compound_page+0x19c/0x260>
[242361.756732] l0: ffffffffff800000 l1: 0100000000000000 l2: fffffc033c360140 l3: fffffc033c4c6008
[242361.756738] l4: 00000000f77da000 l5: fffffc033a0cef78 l6: 00000000f77da000 l7: 0300000000000000
[242361.756743] i0: 0000010002750000 i1: 00000000f77d9fff i2: 0000000000000001 i3: 000001000275001c
[242361.756749] i4: 0000000000000000 i5: 000001000275fb00 i6: fffffc033c51ec91 i7: 00000000004b519c
[242361.756755] I7: <get_futex_key+0x1bc/0x2a0>
[242361.756759] Call Trace:
[242361.756765]  [00000000004b519c] get_futex_key+0x1bc/0x2a0
[242361.756771]  [00000000004b5f64] futex_wake+0x24/0x140
[242361.756777]  [00000000004b7460] do_futex+0x100/0x9a0
[242361.756783]  [00000000004b7d98] SyS_futex+0x98/0x1c0
[242361.756791]  [000000000045ee14] mm_release+0x74/0x100
[242361.756798]  [0000000000462b78] do_exit+0xf8/0x920
[242361.756805]  [00000000004634c8] do_group_exit+0x28/0xc0
[242361.756812]  [0000000000471348] get_signal_to_deliver+0x128/0x520
[242361.756822]  [0000000000448d94] do_signal32+0x14/0xae0
[242361.756832]  [000000000042ce3c] do_signal+0xdc/0x540
[242361.756838]  [000000000042daa0] do_notify_resume+0x40/0x60
[242361.756846]  [0000000000404b04] __handle_signal+0xc/0x2c
[242423.588580] INFO: rcu_sched self-detected stall on CPU { 1}  (t=8405 jiffies g=2435314 c=2435313 q=7340)
[242423.588597]   CPU[  0]: TSTATE[0000000011001606] TPC[0000000000493780] TNPC[0000000000493784] TASK[eselect:1590]
[242423.588628]              TPC[task_tick_fair+0xc0/0x300] O7[task_tick_fair+0x38/0x300] I7[scheduler_tick+0x4c/0xc0] RPC[update_process_times+0x48/0x60]
[242423.588635] * CPU[  1]: TSTATE[0000004411001600] TPC[00000000004539e8] TNPC[00000000004539ec] TASK[git:1513]
[242423.588648]              TPC[get_user_pages_fast+0x1a8/0x360] O7[get_user_pages_fast+0x2fc/0x360] I7[get_futex_key+0x44/0x2a0] RPC[futex_wake+0x24/0x140]
[242486.628334] INFO: rcu_sched self-detected stall on CPU { 1}  (t=14709 jiffies g=2435314 c=2435313 q=100069)
[242486.628350]   CPU[  0]: TSTATE[00000044f0000a02] TPC[00000000f79e2de0] TNPC[00000000f79e2de4] TASK[ctest:2998]
[242486.628356]              TPC[f79e2de0] O7[f7caba24] I7[47ad64] RPC[478724]
[242486.628362] * CPU[  1]: TSTATE[0000004411001600] TPC[00000000004539e8] TNPC[00000000004539ec] TASK[git:1513]
[242486.628377]              TPC[get_user_pages_fast+0x1a8/0x360] O7[get_user_pages_fast+0x2fc/0x360] I7[get_futex_key+0x44/0x2a0] RPC[futex_wake+0x24/0x140]
[242519.442106] Crash[4150]: segfault at 0 ip 0000000000010650 (rpc           (null)) sp 00000000fffb7a60 error 30001 in Crash[10000+2000]
[242549.668087] INFO: rcu_sched self-detected stall on CPU { 1}  (t=21013 jiffies g=2435314 c=2435313 q=172509)
[242549.668103]   CPU[  0]: TSTATE[0000000080001600] TPC[0000000000659e90] TNPC[0000000000659e94] TASK[rcu_sched:9]
[242549.668122]              TPC[cpumask_next_and+0x10/0x80] O7[find_busiest_group+0x49c/0x8e0] I7[load_balance+0x220/0x8a0] RPC[pick_next_task_fair+0x1b0/0x380]
[242549.668129] * CPU[  1]: TSTATE[0000004411001600] TPC[00000000004fb9a8] TNPC[00000000004fb9ac] TASK[git:1513]
[242549.668145]              TPC[put_compound_page+0x1e8/0x260] O7[put_compound_page+0x19c/0x260] I7[get_futex_key+0x1bc/0x2a0] RPC[futex_wake+0x24/0x140]
[242612.707841] INFO: rcu_sched self-detected stall on CPU { 1}  (t=27317 jiffies g=2435314 c=2435313 q=202207)
[242612.707857]   CPU[  0]: TSTATE[0000004480001607] TPC[0000000000495a48] TNPC[0000000000495a4c] TASK[rcu_sched:9]
[242612.707876]              TPC[load_balance+0x388/0x8a0] O7[load_balance+0x3dc/0x8a0] I7[pick_next_task_fair+0x1b0/0x380] RPC[__schedule+0x104/0x3bc]
[242612.707882] * CPU[  1]: TSTATE[0000004411001600] TPC[00000000004fb9a8] TNPC[00000000004fb9ac] TASK[git:1513]
[242612.707898]              TPC[put_compound_page+0x1e8/0x260] O7[put_compound_page+0x19c/0x260] I7[get_futex_key+0x1bc/0x2a0] RPC[futex_wake+0x24/0x140]
[242675.747595] INFO: rcu_sched self-detected stall on CPU { 1}  (t=33621 jiffies g=2435314 c=2435313 q=230705)
[242675.747611]   CPU[  0]: TSTATE[0000004480001605] TPC[00000000004964e4] TNPC[000000000088b5cc] TASK[rcu_sched:9]
[242675.747630]              TPC[pick_next_task_fair+0x1e4/0x380] O7[__schedule+0x104/0x3bc] I7[schedule_timeout+0x100/0x1a0] RPC[rcu_gp_kthread+0x244/0x5a0]
[242675.747636] * CPU[  1]: TSTATE[0000004411001600] TPC[00000000004fb9a8] TNPC[00000000004fb9ac] TASK[git:1513]
[242675.747651]              TPC[put_compound_page+0x1e8/0x260] O7[put_compound_page+0x19c/0x260] I7[get_futex_key+0x1bc/0x2a0] RPC[futex_wake+0x24/0x140]
[242738.787348] INFO: rcu_sched self-detected stall on CPU { 1}  (t=39925 jiffies g=2435314 c=2435313 q=296081)
[242738.787366]   CPU[  0]: TSTATE[0000000011001600] TPC[00000000004922e0] TNPC[00000000004922e4] TASK[cmake:7510]
[242738.787382]              TPC[select_task_rq_fair+0xc0/0x860] O7[          (null)] I7[try_to_wake_up+0x178/0x340] RPC[call_timer_fn+0x10/0x100]
[242738.787389] * CPU[  1]: TSTATE[0000004411001600] TPC[00000000004fb9a8] TNPC[00000000004fb9ac] TASK[git:1513]
[242738.787404]              TPC[put_compound_page+0x1e8/0x260] O7[put_compound_page+0x19c/0x260] I7[get_futex_key+0x1bc/0x2a0] RPC[futex_wake+0x24/0x140]
[242793.001079] kwsysTestProces[8460]: segfault at 4 ip 0000000000011b9c (rpc 0000000000011b90) sp 00000000ffa61868 error 30001 in kwsysTestProcess[10000+c000]
[242801.827102] INFO: rcu_sched self-detected stall on CPU { 1}  (t=46229 jiffies g=2435314 c=2435313 q=349454)
[242801.827119]   CPU[  0]: TSTATE[00000000f0001a02] TPC[0000000000014bac] TNPC[0000000000014bb0] TASK[kwsysTestProces:8461]
[242801.827124]              TPC[14bac] O7[14c64] I7[1497c] RPC[124bc]
[242801.827131] * CPU[  1]: TSTATE[0000004411001600] TPC[00000000004539e8] TNPC[00000000004539ec] TASK[git:1513]
[242801.827145]              TPC[get_user_pages_fast+0x1a8/0x360] O7[get_user_pages_fast+0x2fc/0x360] I7[get_futex_key+0x44/0x2a0] RPC[futex_wake+0x24/0x140]
[242813.153027] kwsysTestProces[8488]: segfault at 4 ip 0000000000011b9c (rpc 0000000000011b90) sp 00000000fff4f868 error 30001 in kwsysTestProcess[10000+c000]
[242864.866856] INFO: rcu_sched self-detected stall on CPU { 1}  (t=52533 jiffies g=2435314 c=2435313 q=378515)
[242864.866872]   CPU[  0]: TSTATE[0000004480001605] TPC[000000000088bb34] TNPC[000000000088bb38] TASK[rcu_sched:9]
[242864.866888]              TPC[switch_to_pc+0x2b8/0x444] O7[switch_to_pc+0x2c8/0x444] I7[schedule_timeout+0x100/0x1a0] RPC[rcu_gp_kthread+0x244/0x5a0]
[242864.866895] * CPU[  1]: TSTATE[0000000011001600] TPC[00000000004fb900] TNPC[00000000004fb904] TASK[git:1513]
[242864.866910]              TPC[put_compound_page+0x140/0x260] O7[put_compound_page+0x10c/0x260] I7[get_futex_key+0x1bc/0x2a0] RPC[futex_wake+0x24/0x140]
[…] and so on and so on
[247362.259334] INFO: task jbd2/dm-3-8:3233 blocked for more than 120 seconds.
[247362.259348]       Not tainted 3.15.0 #1
[247362.259353] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[247362.259359] jbd2/dm-3-8     D 00000000005715e4     0  3233      2 0x01000000
[247362.259370] Call Trace:
[247362.259390]  [000000000088be00] io_schedule+0x40/0x60
[247362.259405]  [00000000005715e4] sleep_on_buffer+0x4/0x20
[247362.259412]  [000000000088c404] __wait_on_bit+0x84/0x100
[247362.259419]  [000000000088c4c4] out_of_line_wait_on_bit+0x44/0x60
[247362.259437]  [0000000000606298] jbd2_journal_commit_transaction+0x9f8/0x1860
[247362.259447]  [000000000060b71c] kjournald2+0x9c/0x1c0
[247362.259460]  [0000000000480608] kthread+0xa8/0xe0
[247362.259472]  [0000000000406084] ret_from_fork+0x1c/0x2c
[247362.259477]  [0000000000000000]           (null)
[247362.259498] INFO: task kworker/u5:1:30366 blocked for more than 120 seconds.
[247362.259503]       Not tainted 3.15.0 #1
[247362.259507] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[247362.259511] kworker/u5:1    D 00000000006028e4     0 30366      2 0x07000000
[247362.259523] Workqueue: writeback bdi_writeback_workfn (flush-253:3)
[247362.259529] Call Trace:
[247362.259535]  [000000000088be00] io_schedule+0x40/0x60
[247362.259542]  [00000000006028e4] sleep_on_shadow_bh+0x4/0x20
[247362.259547]  [000000000088c404] __wait_on_bit+0x84/0x100
[247362.259554]  [000000000088c4c4] out_of_line_wait_on_bit+0x44/0x60
[247362.259561]  [0000000000604bdc] do_get_write_access+0x29c/0x520
[247362.259568]  [0000000000604fb8] jbd2_journal_get_write_access+0x18/0x40
[247362.259575]  [00000000005e8794] __ext4_journal_get_write_access+0x14/0x60
[247362.259582]  [00000000005eff70] ext4_mb_mark_diskspace_used+0x50/0x4c0
[247362.259588]  [00000000005f17e4] ext4_mb_new_blocks+0x284/0x560
[247362.259603]  [00000000005e53b4] ext4_ext_map_blocks+0x874/0x1d20
[247362.259611]  [00000000005b6388] ext4_map_blocks+0x168/0x500
[247362.259618]  [00000000005bbde0] ext4_writepages+0x600/0xbc0
[247362.259634]  [00000000004f9f84] do_writepages+0x24/0x60
[247362.259649]  [000000000056a224] __writeback_single_inode+0x24/0x260
[247362.259654]  [000000000056b480] writeback_sb_inodes+0x1e0/0x3a0
[247362.259660]  [000000000056b6b0] __writeback_inodes_wb+0x70/0xc0
[…] and then more of both
