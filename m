Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbaIRHaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:30:01 -0400
Received: from meine-oma.de ([37.120.161.46]:39822 "EHLO meine-oma.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740AbaIRH37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:29:59 -0400
Message-ID: <541A89F5.6030000@meine-oma.de>
Date: Thu, 18 Sep 2014 09:29:57 +0200
From: Thomas Stein <himbeere@meine-oma.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: bcache call trace
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-SA-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody.

I'm playing around with kernel 3.17-rc and noticed a bcache misbehaviour
every now and then. The machine gets unresponsive and syslog gets this
call trace:

Sep 18 07:56:18 hn kernel: [139899.611485] Task dump for CPU 0:
Sep 18 07:56:18 hn kernel: [139899.611487] bcache_gc       R  running
task    14152  1305      2 0x00080008
Sep 18 07:56:18 hn kernel: [139899.611491]  ffffffff81c411c0
ffff88083fa03d78 ffffffff810713d2 0000000000000000
Sep 18 07:56:18 hn kernel: [139899.611494]  ffffffff81c411c0
ffff88083fa03d98 ffffffff81073ff8 ffff88083fa03dd8
Sep 18 07:56:18 hn kernel: [139899.611504]  0000000000000000
ffff88083fa03dc8 ffffffff8108f245 ffff88083fa0d280
Sep 18 07:56:18 hn kernel: [139899.611505] Call Trace:
Sep 18 07:56:18 hn kernel: [139899.611506]  <IRQ>  [<ffffffff810713d2>]
sched_show_task+0xc2/0x130
Sep 18 07:56:18 hn kernel: [139899.611513]  [<ffffffff81073ff8>]
dump_cpu_task+0x38/0x40
Sep 18 07:56:18 hn kernel: [139899.611515]  [<ffffffff8108f245>]
rcu_dump_cpu_stacks+0x85/0xc0
Sep 18 07:56:18 hn kernel: [139899.611517]  [<ffffffff81092520>]
rcu_check_callbacks+0x3c0/0x680
Sep 18 07:56:18 hn kernel: [139899.611519]  [<ffffffff81096d23>]
update_process_times+0x43/0x80
Sep 18 07:56:18 hn kernel: [139899.611521]  [<ffffffff810a5471>]
tick_sched_handle.isra.13+0x31/0x40
Sep 18 07:56:18 hn kernel: [139899.611523]  [<ffffffff810a55e7>]
tick_sched_timer+0x47/0x70
Sep 18 07:56:18 hn kernel: [139899.611525]  [<ffffffff8109757b>]
__run_hrtimer+0x7b/0x1c0
Sep 18 07:56:18 hn kernel: [139899.611526]  [<ffffffff810a55a0>] ?
tick_sched_do_timer+0x30/0x30
Sep 18 07:56:18 hn kernel: [139899.611528]  [<ffffffff81097d47>]
hrtimer_interrupt+0xf7/0x230
Sep 18 07:56:18 hn kernel: [139899.611530]  [<ffffffff8148f4f0>] ?
bch_ptr_invalid+0x10/0x10
Sep 18 07:56:18 hn kernel: [139899.611532]  [<ffffffff81033196>]
local_apic_timer_interrupt+0x36/0x60
Sep 18 07:56:18 hn kernel: [139899.611534]  [<ffffffff810334de>]
smp_apic_timer_interrupt+0x3e/0x60
Sep 18 07:56:18 hn kernel: [139899.611536]  [<ffffffff8166978a>]
apic_timer_interrupt+0x6a/0x70
Sep 18 07:56:18 hn kernel: [139899.611537]  <EOI>  [<ffffffff81497dd5>]
? __bch_extent_invalid+0x75/0x90
Sep 18 07:56:18 hn kernel: [139899.611548]  [<ffffffff81497eea>] ?
bch_extent_bad+0xea/0x190
Sep 18 07:56:18 hn kernel: [139899.611550]  [<ffffffff81497e28>] ?
bch_extent_bad+0x28/0x190
Sep 18 07:56:18 hn kernel: [139899.611552]  [<ffffffff8148f4fa>]
bch_ptr_bad+0xa/0x10
Sep 18 07:56:18 hn kernel: [139899.611554]  [<ffffffff8148f311>]
bch_btree_iter_next_filter+0x31/0x50
Sep 18 07:56:18 hn kernel: [139899.611556]  [<ffffffff8148f7a9>]
btree_gc_count_keys+0x49/0x60
Sep 18 07:56:18 hn kernel: [139899.611559]  [<ffffffff81494ff5>]
btree_gc_recurse+0x1b5/0x320
Sep 18 07:56:18 hn kernel: [139899.611561]  [<ffffffff81490433>] ?
btree_gc_mark_node+0x63/0x240
Sep 18 07:56:18 hn kernel: [139899.611564]  [<ffffffff81080a3e>] ?
__wake_up+0x4e/0x70
Sep 18 07:56:18 hn kernel: [139899.611566]  [<ffffffff81495575>]
bch_btree_gc+0x415/0x5a0
Sep 18 07:56:18 hn kernel: [139899.611569]  [<ffffffff81080690>] ?
finish_wait+0x80/0x80
Sep 18 07:56:18 hn kernel: [139899.611571]  [<ffffffff81495738>]
bch_gc_thread+0x38/0x120
Sep 18 07:56:18 hn kernel: [139899.611574]  [<ffffffff81495700>] ?
bch_btree_gc+0x5a0/0x5a0
Sep 18 07:56:18 hn kernel: [139899.611576]  [<ffffffff810671f4>]
kthread+0xc4/0xe0
Sep 18 07:56:18 hn kernel: [139899.611579]  [<ffffffff81067130>] ?
kthread_worker_fn+0x150/0x150
Sep 18 07:56:18 hn kernel: [139899.611581]  [<ffffffff816688ec>]
ret_from_fork+0x7c/0xb0
Sep 18 07:56:18 hn kernel: [139899.611583]  [<ffffffff81067130>] ?
kthread_worker_fn+0x150/0x150
Sep 18 07:59:01 hn cron[21319]: (root) CMD (rm -f
/var/spool/cron/lastrun/cron.hourly)
Sep 18 07:59:18 hn kernel: [140079.518912] INFO: rcu_sched self-detected
stall on CPU { 0}  (t=46140768 jiffies g=950110 c=950109 q=0)
Sep 18 07:59:18 hn kernel: [140079.518918] Task dump for CPU 0:
Sep 18 07:59:18 hn kernel: [140079.518920] bcache_gc       R  running
task    14152  1305      2 0x00080008
Sep 18 07:59:18 hn kernel: [140079.518925]  ffffffff81c411c0
ffff88083fa03d78 ffffffff810713d2 0000000000000000
Sep 18 07:59:18 hn kernel: [140079.518927]  ffffffff81c411c0
ffff88083fa03d98 ffffffff81073ff8 ffff88083fa03dd8
Sep 18 07:59:18 hn kernel: [140079.518930]  0000000000000000
ffff88083fa03dc8 ffffffff8108f245 ffff88083fa0d280
Sep 18 07:59:18 hn kernel: [140079.518932] Call Trace:
Sep 18 07:59:18 hn kernel: [140079.518934]  <IRQ>  [<ffffffff810713d2>]
sched_show_task+0xc2/0x130
Sep 18 07:59:18 hn kernel: [140079.518942]  [<ffffffff81073ff8>]
dump_cpu_task+0x38/0x40
Sep 18 07:59:18 hn kernel: [140079.518944]  [<ffffffff8108f245>]
rcu_dump_cpu_stacks+0x85/0xc0
Sep 18 07:59:18 hn kernel: [140079.518947]  [<ffffffff81092520>]
rcu_check_callbacks+0x3c0/0x680
Sep 18 07:59:18 hn kernel: [140079.518950]  [<ffffffff81096d23>]
update_process_times+0x43/0x80
Sep 18 07:59:18 hn kernel: [140079.518952]  [<ffffffff810a5471>]
tick_sched_handle.isra.13+0x31/0x40


...and so on. Is someone working on this issue? If more information is
needed i would be glad to provide it.

best regards
t.
