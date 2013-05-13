Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3EMHW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:22:27 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52603 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3EMHW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:22:26 -0400
X-Nat-Received: from [202.181.97.72]:60985 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1368429732.9413
Message-Id: <201305130722.r4D7MCPr004492@www262.sakura.ne.jp>
Subject: [3.10-rc1] tick: NULL pointer dereference at tick_handle_oneshot_broadcast
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: tglx@linutronix.de, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 13 May 2013 16:22:12 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 13052013 #9961454, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I\'m hitting below bug on bootup.

[    1.215727] Switching to clocksource hpet
[    1.217475] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[    1.218467] IP: [<ffffffff810ac77c>] tick_handle_oneshot_broadcast+0xdc/0x280
[    1.218488] PGD 0 
[    1.218509] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    1.218530] Modules linked in:
[    1.218550] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc1 #72
[    1.218571] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/20/2012
[    1.218592] task: ffff88007ad58000 ti: ffff88007acde000 task.ti: ffff88007acde000
[    1.218613] RIP: 0010:[<ffffffff810ac77c>]  [<ffffffff810ac77c>] tick_handle_oneshot_broadcast+0xdc/0x280
[    1.218634] RSP: 0000:ffff88007b203df8  EFLAGS: 00010083
[    1.218655] RAX: 0000000000000004 RBX: 7fffffffffffffff RCX: 0000000000000010
[    1.218676] RDX: 0000000000000004 RSI: 0000000000000010 RDI: 0000000000000000
[    1.218697] RBP: ffff88007b203e48 R08: ffff88007ac05578 R09: 0000000000000000
[    1.218717] R10: ffff88007ac05570 R11: 7fffffffffffffff R12: 7fffffffffffffff
[    1.218738] R13: 000000000000d700 R14: 0000000000000000 R15: ffffffff81e1f040
[    1.218759] FS:  0000000000000000(0000) GS:ffff88007b200000(0000) knlGS:0000000000000000
[    1.218780] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.218801] CR2: 0000000000000018 CR3: 0000000001e0b000 CR4: 00000000000407f0
[    1.218822] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.218843] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.218864] Stack:
[    1.218884]  ffff88007b203e68 0000000000000086 ffff88007b203e18 000000003ec3dd69
[    1.218905]  ffff88007b203e38 ffffffff81e12680 ffff88007ac08488 0000000000000000
[    1.218926]  ffff88007acdfb48 0000000000000000 ffff88007b203e58 ffffffff81005145
[    1.218947] Call Trace:
[    1.218968]  <IRQ> 
[    1.218989]  [<ffffffff81005145>] timer_interrupt+0x15/0x20
[    1.219041]  [<ffffffff810e9f45>] handle_irq_event_percpu+0x95/0x380
[    1.219071]  [<ffffffff810ea278>] handle_irq_event+0x48/0x70
[    1.219101]  [<ffffffff810ed9bd>] handle_edge_irq+0x6d/0x130
[    1.219130]  [<ffffffff8100491c>] handle_irq+0x5c/0x150
[    1.219170]  [<ffffffff811a4b78>] ? d_alloc+0x68/0x80
[    1.219202]  [<ffffffff81048c2b>] ? irq_enter+0x1b/0x90
[    1.219233]  [<ffffffff8182f27d>] do_IRQ+0x5d/0xe0
[    1.219263]  [<ffffffff811a4b78>] ? d_alloc+0x68/0x80
[    1.219294]  [<ffffffff818248af>] common_interrupt+0x6f/0x6f
[    1.219315]  <EOI> 
[    1.219335]  [<ffffffff810b021d>] ? trace_hardirqs_off+0xd/0x10
[    1.219386]  [<ffffffff810b71de>] ? lock_release+0x7e/0x130
[    1.219417]  [<ffffffff818245a3>] _raw_spin_unlock+0x23/0x50
[    1.219447]  [<ffffffff811a4b78>] d_alloc+0x68/0x80
[    1.219478]  [<ffffffff81198793>] lookup_dcache+0xa3/0xd0
[    1.219508]  [<ffffffff811987e3>] __lookup_hash+0x23/0x50
[    1.219540]  [<ffffffff811993e1>] lookup_one_len+0xd1/0x120
[    1.219571]  [<ffffffff81293313>] __create_file+0x93/0x2a0
[    1.219601]  [<ffffffff812935da>] debugfs_create_file+0x1a/0x30
[    1.219631]  [<ffffffff81108f8c>] trace_create_file+0x1c/0x50
[    1.219660]  [<ffffffff81109102>] tracing_init_debugfs_percpu+0xa2/0x210
[    1.219691]  [<ffffffff8110bd78>] init_tracer_debugfs+0x188/0x1e0
[    1.219723]  [<ffffffff820f137b>] tracer_init_debugfs+0x78/0x20f
[    1.219755]  [<ffffffff820f1303>] ? clear_boot_tracer+0x2d/0x2d
[    1.219785]  [<ffffffff810002c2>] do_one_initcall+0xf2/0x1a0
[    1.219816]  [<ffffffff820d385c>] do_basic_setup+0x9d/0xbb
[    1.219849]  [<ffffffff820d39ad>] ? kernel_init_freeable+0x133/0x133
[    1.219879]  [<ffffffff820d3934>] kernel_init_freeable+0xba/0x133
[    1.219909]  [<ffffffff8180f900>] ? rest_init+0x180/0x180
[    1.219938]  [<ffffffff8180f90e>] kernel_init+0xe/0xf0
[    1.219969]  [<ffffffff8182dddc>] ret_from_fork+0x7c/0xb0
[    1.219999]  [<ffffffff8180f900>] ? rest_init+0x180/0x180
[    1.220020] Code: 63 f1 48 89 c7 48 63 d2 e8 42 e5 26 00 8b 0d e4 6f e4 00 89 c2 39 c8 89 ce 7d 74 48 63 fa 48 8b 3c fd 40 23 ef 81 49 8b 7c 3d 00 <4c> 8b 47 18 4c 3b 45 c8 7e 1a 4d 39 e0 7d a5 83 fa ff 41 89 c6 
[    1.220040] RIP  [<ffffffff810ac77c>] tick_handle_oneshot_broadcast+0xdc/0x280
[    1.220061]  RSP <ffff88007b203df8>
[    1.220082] CR2: 0000000000000018
[    1.220103] ---[ end trace c8cac818edfcf493 ]---
[    1.220124] Kernel panic - not syncing: Fatal exception in interrupt

Config is at http://I-love.SAKURA.ne.jp/tmp/config-3.10-rc1
Full dmesg is at http://I-love.SAKURA.ne.jp/tmp/dmesg-3.10-rc1.txt

Below patch

---------- debug printk() start ----------
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 206bbfb..952df89 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -189,7 +189,9 @@ static void tick_do_broadcast(struct cpumask *mask)
 	if (cpumask_test_cpu(cpu, mask)) {
 		cpumask_clear_cpu(cpu, mask);
 		td = &per_cpu(tick_cpu_device, cpu);
-		td->evtdev->event_handler(td->evtdev);
+		printk(KERN_INFO \"test=%d td=%p td->evtdev=%p\\n\", cpu, td, td->evtdev);
+		if (td->evtdev)
+			td->evtdev->event_handler(td->evtdev);
 	}
 
 	if (!cpumask_empty(mask)) {
@@ -200,7 +202,9 @@ static void tick_do_broadcast(struct cpumask *mask)
 		 * misfeature only on x86 (lapic)
 		 */
 		td = &per_cpu(tick_cpu_device, cpumask_first(mask));
-		td->evtdev->broadcast(mask);
+		printk(KERN_INFO \"first td=%p td->evtdev=%p\\n\", td, td->evtdev);
+		if (td->evtdev)
+			td->evtdev->broadcast(mask);
 	}
 }
 
@@ -497,6 +501,9 @@ again:
 	/* Find all expired events */
 	for_each_cpu(cpu, tick_broadcast_oneshot_mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
+		printk(KERN_INFO \"cpu=%d td=%p td->evtdev=%p\\n\", cpu, td, td->evtdev);
+		if (!td->evtdev)
+			continue;
 		if (td->evtdev->next_event.tv64 <= now.tv64) {
 			cpumask_set_cpu(cpu, tmpmask);
 			/*
---------- debug printk() end ----------

makes my kernel boots OK, with reports that some of td->evtdev == NULL.

---------- debug output start ----------
[    1.205720] Switching to clocksource hpet
[    1.207419] cpu=4 td=ffff88007ba0d700 td->evtdev=          (null)
[    1.208919] cpu=5 td=ffff88007bc0d700 td->evtdev=          (null)
[    1.210480] cpu=6 td=ffff88007be0d700 td->evtdev=          (null)
[    1.212008] cpu=7 td=ffff88007c00d700 td->evtdev=          (null)
[    1.213560] cpu=8 td=ffff88007c20d700 td->evtdev=          (null)
[    1.215094] cpu=10 td=ffff88007c60d700 td->evtdev=          (null)
[    1.216624] cpu=12 td=ffff88007ca0d700 td->evtdev=          (null)
[    1.218250] cpu=14 td=ffff88007ce0d700 td->evtdev=          (null)
[    1.219768] first td=ffff88007ba0d700 td->evtdev=          (null)
[    1.295536] pnp: PnP ACPI init
---------- debug output end ----------

My VM has 4 CPUs and CONFIG_NR_CPUS is set to 16. Thus it seems to me that
td->evtdev for nonexistent (and by other reasons?) cpu became NULL.

I don\'t know why but bisection reached commit b352bc1c
\"tick: Convert broadcast cpu bitmaps to cpumask_var_t\".

Regards.
