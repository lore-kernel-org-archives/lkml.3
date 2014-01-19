Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaASWBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 17:01:44 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:51315 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaASWBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 17:01:42 -0500
Message-ID: <1390168823.587.1.camel@localhost>
Subject: [BUG] at drivers/md/raid5.c:291! kernel 3.13-rc8
From: Ian Kumlien <ian.kumlien@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Sun, 19 Jan 2014 23:00:23 +0100
Content-Type: multipart/mixed; boundary="=-APHGKTzmBFit3rrsHQWL"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-APHGKTzmBFit3rrsHQWL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Ok, so third try to actually email this... 
---

Hi,

I started testing 3.13-rc8 on another machine since the first one seemed
to be working fine...

One spontaneous reboot later i'm not so sure ;)

Right now i captured a kernel oops in the raid code it seems...

(Also attached to avoid mangling)

[33411.934672] ------------[ cut here ]------------
[33411.934685] kernel BUG at drivers/md/raid5.c:291!
[33411.934690] invalid opcode: 0000 [#1] PREEMPT SMP 
[33411.934696] Modules linked in: bonding btrfs microcode
[33411.934705] CPU: 4 PID: 2319 Comm: md2_raid6 Not tainted 3.13.0-rc8 #83
[33411.934709] Hardware name: System manufacturer System Product Name/Crosshair IV Formula, BIOS 3029    10/09/2012
[33411.934716] task: ffff880326265880 ti: ffff880320472000 task.ti: ffff880320472000
[33411.934720] RIP: 0010:[<ffffffff81a3a5be>]  [<ffffffff81a3a5be>] do_release_stripe+0x18e/0x1a0
[33411.934731] RSP: 0018:ffff880320473d28  EFLAGS: 00010087
[33411.934735] RAX: ffff8802f0875a60 RBX: 0000000000000001 RCX: ffff8800b0d816b0
[33411.934739] RDX: ffff880324eeee98 RSI: ffff8802f0875a40 RDI: ffff880324eeec00
[33411.934743] RBP: ffff8802f0875a50 R08: 0000000000000000 R09: 0000000000000001
[33411.934747] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880324eeec00
[33411.934752] R13: ffff880324eeee58 R14: ffff880320473e88 R15: 0000000000000000
[33411.934756] FS:  00007fc38654d700(0000) GS:ffff880337d00000(0000) knlGS:0000000000000000
[33411.934761] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[33411.934765] CR2: 00007f0cb28bd000 CR3: 00000002ebcf6000 CR4: 00000000000407e0
[33411.934769] Stack:
[33411.934771]  ffff8800bba09690 ffff8800b4f16588 ffff880303005a40 0000000000000001
[33411.934779]  ffff8800b33e43d0 ffffffff81a3a62d ffff880324eeee58 0000000000000000
[33411.934786]  ffff880324eeee58 ffff880326660670 ffff880326265880 ffffffff81a41692
[33411.934794] Call Trace:
[33411.934798]  [<ffffffff81a3a62d>] ? release_stripe_list+0x4d/0x70
[33411.934803]  [<ffffffff81a41692>] ? raid5d+0xa2/0x4d0
[33411.934808]  [<ffffffff81a65ed6>] ? md_thread+0xe6/0x120
[33411.934814]  [<ffffffff81122060>] ? finish_wait+0x90/0x90
[33411.934818]  [<ffffffff81a65df0>] ? md_rdev_init+0x100/0x100
[33411.934823]  [<ffffffff8110958c>] ? kthread+0xbc/0xe0
[33411.934828]  [<ffffffff81110000>] ? smpboot_park_threads+0x70/0x70Hi,

I started testing 3.13-rc8 on another machine since the first one seemed to be working fine...

One spontaneous reboot later i'm not so sure ;)

Right now i captured a kernel oops in the raid code it seems...

(Also attached to avoid mangling)

[33411.934672] ------------[ cut here ]------------
[33411.934685] kernel BUG at drivers/md/raid5.c:291!
[33411.934690] invalid opcode: 0000 [#1] PREEMPT SMP 
[33411.934696] Modules linked in: bonding btrfs microcode
[33411.934705] CPU: 4 PID: 2319 Comm: md2_raid6 Not tainted 3.13.0-rc8 #83
[33411.934709] Hardware name: System manufacturer System Product Name/Crosshair IV Formula, BIOS 3029    10/09/2012
[33411.934716] task: ffff880326265880 ti: ffff880320472000 task.ti: ffff880320472000
[33411.934720] RIP: 0010:[<ffffffff81a3a5be>]  [<ffffffff81a3a5be>] do_release_stripe+0x18e/0x1a0
[33411.934731] RSP: 0018:ffff880320473d28  EFLAGS: 00010087
[33411.934735] RAX: ffff8802f0875a60 RBX: 0000000000000001 RCX: ffff8800b0d816b0
[33411.934739] RDX: ffff880324eeee98 RSI: ffff8802f0875a40 RDI: ffff880324eeec00
[33411.934743] RBP: ffff8802f0875a50 R08: 0000000000000000 R09: 0000000000000001
[33411.934747] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880324eeec00
[33411.934752] R13: ffff880324eeee58 R14: ffff880320473e88 R15: 0000000000000000
[33411.934756] FS:  00007fc38654d700(0000) GS:ffff880337d00000(0000) knlGS:0000000000000000
[33411.934761] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[33411.934765] CR2: 00007f0cb28bd000 CR3: 00000002ebcf6000 CR4: 00000000000407e0
[33411.934769] Stack:
[33411.934771]  ffff8800bba09690 ffff8800b4f16588 ffff880303005a40 0000000000000001
[33411.934779]  ffff8800b33e43d0 ffffffff81a3a62d ffff880324eeee58 0000000000000000
[33411.934786]  ffff880324eeee58 ffff880326660670 ffff880326265880 ffffffff81a41692
[33411.934794] Call Trace:
[33411.934798]  [<ffffffff81a3a62d>] ? release_stripe_list+0x4d/0x70
[33411.934803]  [<ffffffff81a41692>] ? raid5d+0xa2/0x4d0
[33411.934808]  [<ffffffff81a65ed6>] ? md_thread+0xe6/0x120
[33411.934814]  [<ffffffff81122060>] ? finish_wait+0x90/0x90
[33411.934818]  [<ffffffff81a65df0>] ? md_rdev_init+0x100/0x100
[33411.934823]  [<ffffffff8110958c>] ? kthread+0xbc/0xe0
[33411.934828]  [<ffffffff81110000>] ? smpboot_park_threads+0x70/0x70
[33411.934833]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.934839]  [<ffffffff81d5857c>] ? ret_from_fork+0x7c/0xb0
[33411.934843]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.934847] Code: f7 ff ff 66 90 48 8b 43 18 48 8b b8 48 01 00 00 48 89 14 24 48 89 74 24 08 e8 af 9a 02 00 48 8b 74 24 08 48 8b 14 24 eb 9f 0f 0b <0f> 0b 0f 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 f0 ff 4e 
[33411.934912] RIP  [<ffffffff81a3a5be>] do_release_stripe+0x18e/0x1a0
[33411.934918]  RSP <ffff880320473d28>
[33411.941326] ---[ end trace 42d97d618cc5bfe2 ]---
[33411.941331] ------------[ cut here ]------------
[33411.941337] WARNING: CPU: 4 PID: 2319 at kernel/exit.c:703 do_exit+0x45/0xa40()
[33411.941351] Modules linked in: bonding btrfs microcode
[33411.941377] CPU: 4 PID: 2319 Comm: md2_raid6 Tainted: G      D      3.13.0-rc8 #83
[33411.941395] Hardware name: System manufacturer System Product Name/Crosshair IV Formula, BIOS 3029    10/09/2012
[33411.941417]  0000000000000000 0000000000000009 ffffffff81d4eeb8 0000000000000000
[33411.941449]  ffffffff810eba01 000000000000000b ffff880320473c78 0000000000000096
[33411.941480]  ffff880324eeee58 ffff880320473e88 ffffffff810ed7d5 ffff880324eeee58
[33411.941512] Call Trace:
[33411.941519]  [<ffffffff81d4eeb8>] ? dump_stack+0x4a/0x75
[33411.941530]  [<ffffffff810eba01>] ? warn_slowpath_common+0x81/0xb0
[33411.941544]  [<ffffffff810ed7d5>] ? do_exit+0x45/0xa40
[33411.941557]  [<ffffffff81d4c0d4>] ? printk+0x4f/0x54
[33411.941568]  [<ffffffff810463ed>] ? oops_end+0x8d/0xd0
[33411.941579]  [<ffffffff810431d2>] ? do_invalid_op+0xa2/0x100
[33411.941592]  [<ffffffff81a3a5be>] ? do_release_stripe+0x18e/0x1a0
[33411.941606]  [<ffffffff81d596a8>] ? invalid_op+0x18/0x20
[33411.941617]  [<ffffffff81a3a5be>] ? do_release_stripe+0x18e/0x1a0
[33411.941633]  [<ffffffff81a3a62d>] ? release_stripe_list+0x4d/0x70
[33411.941647]  [<ffffffff81a41692>] ? raid5d+0xa2/0x4d0
[33411.941658]  [<ffffffff81a65ed6>] ? md_thread+0xe6/0x120
[33411.941670]  [<ffffffff81122060>] ? finish_wait+0x90/0x90
[33411.941683]  [<ffffffff81a65df0>] ? md_rdev_init+0x100/0x100
[33411.941695]  [<ffffffff8110958c>] ? kthread+0xbc/0xe0
[33411.941708]  [<ffffffff81110000>] ? smpboot_park_threads+0x70/0x70
[33411.941722]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.941736]  [<ffffffff81d5857c>] ? ret_from_fork+0x7c/0xb0
[33411.941749]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.941762] ---[ end trace 42d97d618cc5bfe3 ]---
[33411.941773] note: md2_raid6[2319] exited with preempt_count 1
[33411.934833]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.934839]  [<ffffffff81d5857c>] ? ret_from_fork+0x7c/0xb0
[33411.934843]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.934847] Code: f7 ff ff 66 90 48 8b 43 18 48 8b b8 48 01 00 00 48 89 14 24 48 89 74 24 08 e8 af 9a 02 00 48 8b 74 24 08 48 8b 14 24 eb 9f 0f 0b <0f> 0b 0f 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 f0 ff 4e 
[33411.934912] RIP  [<ffffffff81a3a5be>] do_release_stripe+0x18e/0x1a0
[33411.934918]  RSP <ffff880320473d28>
[33411.941326] ---[ end trace 42d97d618cc5bfe2 ]---
[33411.941331] ------------[ cut here ]------------
[33411.941337] WARNING: CPU: 4 PID: 2319 at kernel/exit.c:703 do_exit+0x45/0xa40()
[33411.941351] Modules linked in: bonding btrfs microcode
[33411.941377] CPU: 4 PID: 2319 Comm: md2_raid6 Tainted: G      D      3.13.0-rc8 #83
[33411.941395] Hardware name: System manufacturer System Product Name/Crosshair IV Formula, BIOS 3029    10/09/2012
[33411.941417]  0000000000000000 0000000000000009 ffffffff81d4eeb8 0000000000000000
[33411.941449]  ffffffff810eba01 000000000000000b ffff880320473c78 0000000000000096
[33411.941480]  ffff880324eeee58 ffff880320473e88 ffffffff810ed7d5 ffff880324eeee58
[33411.941512] Call Trace:
[33411.941519]  [<ffffffff81d4eeb8>] ? dump_stack+0x4a/0x75
[33411.941530]  [<ffffffff810eba01>] ? warn_slowpath_common+0x81/0xb0
[33411.941544]  [<ffffffff810ed7d5>] ? do_exit+0x45/0xa40
[33411.941557]  [<ffffffff81d4c0d4>] ? printk+0x4f/0x54
[33411.941568]  [<ffffffff810463ed>] ? oops_end+0x8d/0xd0
[33411.941579]  [<ffffffff810431d2>] ? do_invalid_op+0xa2/0x100
[33411.941592]  [<ffffffff81a3a5be>] ? do_release_stripe+0x18e/0x1a0
[33411.941606]  [<ffffffff81d596a8>] ? invalid_op+0x18/0x20
[33411.941617]  [<ffffffff81a3a5be>] ? do_release_stripe+0x18e/0x1a0
[33411.941633]  [<ffffffff81a3a62d>] ? release_stripe_list+0x4d/0x70
[33411.941647]  [<ffffffff81a41692>] ? raid5d+0xa2/0x4d0
[33411.941658]  [<ffffffff81a65ed6>] ? md_thread+0xe6/0x120
[33411.941670]  [<ffffffff81122060>] ? finish_wait+0x90/0x90
[33411.941683]  [<ffffffff81a65df0>] ? md_rdev_init+0x100/0x100
[33411.941695]  [<ffffffff8110958c>] ? kthread+0xbc/0xe0
[33411.941708]  [<ffffffff81110000>] ? smpboot_park_threads+0x70/0x70
[33411.941722]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.941736]  [<ffffffff81d5857c>] ? ret_from_fork+0x7c/0xb0
[33411.941749]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.941762] ---[ end trace 42d97d618cc5bfe3 ]---
[33411.941773] note: md2_raid6[2319] exited with preempt_count 1

--=-APHGKTzmBFit3rrsHQWL
Content-Disposition: attachment; filename="kernel-oops-3.13-rc8-raid.txt"
Content-Type: text/plain; name="kernel-oops-3.13-rc8-raid.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[33411.934672] ------------[ cut here ]------------
[33411.934685] kernel BUG at drivers/md/raid5.c:291!
[33411.934690] invalid opcode: 0000 [#1] PREEMPT SMP 
[33411.934696] Modules linked in: bonding btrfs microcode
[33411.934705] CPU: 4 PID: 2319 Comm: md2_raid6 Not tainted 3.13.0-rc8 #83
[33411.934709] Hardware name: System manufacturer System Product Name/Crosshair IV Formula, BIOS 3029    10/09/2012
[33411.934716] task: ffff880326265880 ti: ffff880320472000 task.ti: ffff880320472000
[33411.934720] RIP: 0010:[<ffffffff81a3a5be>]  [<ffffffff81a3a5be>] do_release_stripe+0x18e/0x1a0
[33411.934731] RSP: 0018:ffff880320473d28  EFLAGS: 00010087
[33411.934735] RAX: ffff8802f0875a60 RBX: 0000000000000001 RCX: ffff8800b0d816b0
[33411.934739] RDX: ffff880324eeee98 RSI: ffff8802f0875a40 RDI: ffff880324eeec00
[33411.934743] RBP: ffff8802f0875a50 R08: 0000000000000000 R09: 0000000000000001
[33411.934747] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880324eeec00
[33411.934752] R13: ffff880324eeee58 R14: ffff880320473e88 R15: 0000000000000000
[33411.934756] FS:  00007fc38654d700(0000) GS:ffff880337d00000(0000) knlGS:0000000000000000
[33411.934761] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[33411.934765] CR2: 00007f0cb28bd000 CR3: 00000002ebcf6000 CR4: 00000000000407e0
[33411.934769] Stack:
[33411.934771]  ffff8800bba09690 ffff8800b4f16588 ffff880303005a40 0000000000000001
[33411.934779]  ffff8800b33e43d0 ffffffff81a3a62d ffff880324eeee58 0000000000000000
[33411.934786]  ffff880324eeee58 ffff880326660670 ffff880326265880 ffffffff81a41692
[33411.934794] Call Trace:
[33411.934798]  [<ffffffff81a3a62d>] ? release_stripe_list+0x4d/0x70
[33411.934803]  [<ffffffff81a41692>] ? raid5d+0xa2/0x4d0
[33411.934808]  [<ffffffff81a65ed6>] ? md_thread+0xe6/0x120
[33411.934814]  [<ffffffff81122060>] ? finish_wait+0x90/0x90
[33411.934818]  [<ffffffff81a65df0>] ? md_rdev_init+0x100/0x100
[33411.934823]  [<ffffffff8110958c>] ? kthread+0xbc/0xe0
[33411.934828]  [<ffffffff81110000>] ? smpboot_park_threads+0x70/0x70
[33411.934833]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.934839]  [<ffffffff81d5857c>] ? ret_from_fork+0x7c/0xb0
[33411.934843]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.934847] Code: f7 ff ff 66 90 48 8b 43 18 48 8b b8 48 01 00 00 48 89 14 24 48 89 74 24 08 e8 af 9a 02 00 48 8b 74 24 08 48 8b 14 24 eb 9f 0f 0b <0f> 0b 0f 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 f0 ff 4e 
[33411.934912] RIP  [<ffffffff81a3a5be>] do_release_stripe+0x18e/0x1a0
[33411.934918]  RSP <ffff880320473d28>
[33411.941326] ---[ end trace 42d97d618cc5bfe2 ]---
[33411.941331] ------------[ cut here ]------------
[33411.941337] WARNING: CPU: 4 PID: 2319 at kernel/exit.c:703 do_exit+0x45/0xa40()
[33411.941351] Modules linked in: bonding btrfs microcode
[33411.941377] CPU: 4 PID: 2319 Comm: md2_raid6 Tainted: G      D      3.13.0-rc8 #83
[33411.941395] Hardware name: System manufacturer System Product Name/Crosshair IV Formula, BIOS 3029    10/09/2012
[33411.941417]  0000000000000000 0000000000000009 ffffffff81d4eeb8 0000000000000000
[33411.941449]  ffffffff810eba01 000000000000000b ffff880320473c78 0000000000000096
[33411.941480]  ffff880324eeee58 ffff880320473e88 ffffffff810ed7d5 ffff880324eeee58
[33411.941512] Call Trace:
[33411.941519]  [<ffffffff81d4eeb8>] ? dump_stack+0x4a/0x75
[33411.941530]  [<ffffffff810eba01>] ? warn_slowpath_common+0x81/0xb0
[33411.941544]  [<ffffffff810ed7d5>] ? do_exit+0x45/0xa40
[33411.941557]  [<ffffffff81d4c0d4>] ? printk+0x4f/0x54
[33411.941568]  [<ffffffff810463ed>] ? oops_end+0x8d/0xd0
[33411.941579]  [<ffffffff810431d2>] ? do_invalid_op+0xa2/0x100
[33411.941592]  [<ffffffff81a3a5be>] ? do_release_stripe+0x18e/0x1a0
[33411.941606]  [<ffffffff81d596a8>] ? invalid_op+0x18/0x20
[33411.941617]  [<ffffffff81a3a5be>] ? do_release_stripe+0x18e/0x1a0
[33411.941633]  [<ffffffff81a3a62d>] ? release_stripe_list+0x4d/0x70
[33411.941647]  [<ffffffff81a41692>] ? raid5d+0xa2/0x4d0
[33411.941658]  [<ffffffff81a65ed6>] ? md_thread+0xe6/0x120
[33411.941670]  [<ffffffff81122060>] ? finish_wait+0x90/0x90
[33411.941683]  [<ffffffff81a65df0>] ? md_rdev_init+0x100/0x100
[33411.941695]  [<ffffffff8110958c>] ? kthread+0xbc/0xe0
[33411.941708]  [<ffffffff81110000>] ? smpboot_park_threads+0x70/0x70
[33411.941722]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.941736]  [<ffffffff81d5857c>] ? ret_from_fork+0x7c/0xb0
[33411.941749]  [<ffffffff811094d0>] ? flush_kthread_worker+0x80/0x80
[33411.941762] ---[ end trace 42d97d618cc5bfe3 ]---
[33411.941773] note: md2_raid6[2319] exited with preempt_count 1


--=-APHGKTzmBFit3rrsHQWL--

