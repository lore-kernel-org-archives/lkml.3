Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaBJTTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:19:47 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:56207 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaBJTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:19:44 -0500
MIME-Version: 1.0
Date: Mon, 10 Feb 2014 21:19:43 +0200
Message-ID: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
Subject: lockdep: strange %s#5 lock name
From: Tommi Rantala <tt.rantala@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        trinity@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Noticed a suspicious "%s#5" lock name in a lockdep splat while fuzzing
with trinity.

Tommi

[249844.491141] INFO: task kworker/u2:2:32113 blocked for more than 120 seconds.
[249844.493268]       Not tainted v3.13-11268-g8a1f006 #3
[249844.494731] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[249844.496922] kworker/u2:2    D ffff880074a92520     0 32113      2 0x00000000
[249844.498985] Workqueue: netns cleanup_net
[249844.500188]  ffff8800956d1c78 0000000000000046 ffff880074a92520
00000000001d4f80
[249844.502360]  ffff8800956d1fd8 00000000001d4f80 ffff880074a90000
ffff880074a92520
[249844.504617]  ffff8800b414dab8 ffffffff82db4d20 ffffffff82db4d28
0000000000000246
[249844.506647] Call Trace:
[249844.507331]  [<ffffffff82378b75>] schedule+0x65/0x70
[249844.508576]  [<ffffffff82378b91>] schedule_preempt_disabled+0x11/0x20
[249844.510185]  [<ffffffff8237a0e5>] mutex_lock_nested+0x285/0x4a0
[249844.511777]  [<ffffffff81f89160>] ? cleanup_net+0x80/0x1e0
[249844.513422]  [<ffffffff81f89160>] ? cleanup_net+0x80/0x1e0
[249844.514998]  [<ffffffff81f89160>] cleanup_net+0x80/0x1e0
[249844.516523]  [<ffffffff8115b096>] process_one_work+0x366/0x690
[249844.518172]  [<ffffffff8115af70>] ? process_one_work+0x240/0x690
[249844.519840]  [<ffffffff8115b8de>] worker_thread+0x21e/0x370
[249844.521422]  [<ffffffff8115b6c0>] ? rescuer_thread+0x2c0/0x2c0
[249844.523040]  [<ffffffff81164420>] kthread+0xf0/0x100
[249844.524425]  [<ffffffff8116dde1>] ? finish_task_switch+0x81/0x130
[249844.525987]  [<ffffffff81164330>] ? insert_kthread_work+0x90/0x90
[249844.527487]  [<ffffffff8237f50c>] ret_from_fork+0x7c/0xb0
[249844.528959]  [<ffffffff81164330>] ? insert_kthread_work+0x90/0x90
[249844.530451] 3 locks held by kworker/u2:2/32113:
[249844.531638]  #0:  (%s#5){.+.+.+}, at: [<ffffffff8115af70>]
process_one_work+0x240/0x690
[249844.533891]  #1:  (net_cleanup_work){+.+.+.}, at:
[<ffffffff8115af70>] process_one_work+0x240/0x690
[249844.536317]  #2:  (net_mutex){+.+.+.}, at: [<ffffffff81f89160>]
cleanup_net+0x80/0x1e0
[249844.538744] INFO: task trinity-c10:23911 blocked for more than 120 seconds.
[249844.540723]       Not tainted v3.13-11268-g8a1f006 #3
[249844.542192] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[249844.544785] trinity-c10     D ffff8800b963a520     0 23911  22465 0x00000004
[249844.546929]  ffff880020d49df8 0000000000000046 ffff8800b963a520
00000000001d4f80
[249844.549183]  ffff880020d49fd8 00000000001d4f80 ffff8800bb42a520
ffff8800b963a520
[249844.551401]  ffff880024e58000 ffffffff82db4d20 ffffffff82db4d28
0000000000000246
[249844.553376] Call Trace:
[249844.553998]  [<ffffffff82378b75>] schedule+0x65/0x70
[249844.555237]  [<ffffffff82378b91>] schedule_preempt_disabled+0x11/0x20
[249844.556844]  [<ffffffff8237a0e5>] mutex_lock_nested+0x285/0x4a0
[249844.558349]  [<ffffffff81f89357>] ? copy_net_ns+0x97/0x150
[249844.559748]  [<ffffffff81f89357>] ? copy_net_ns+0x97/0x150
[249844.561305]  [<ffffffff81f89357>] copy_net_ns+0x97/0x150
[249844.562789]  [<ffffffff811693e6>] create_new_namespaces+0x126/0x1c0
[249844.564551]  [<ffffffff81fffffd>] ? ip_build_and_send_pkt+0x1cd/0x260
[249844.566484]  [<ffffffff81169797>] unshare_nsproxy_namespaces+0xa7/0xe0
[249844.568325]  [<ffffffff81139876>] SyS_unshare+0x116/0x2c0
[249844.569838]  [<ffffffff81fffffd>] ? ip_build_and_send_pkt+0x1cd/0x260
[249844.571664]  [<ffffffff8237f5b9>] system_call_fastpath+0x16/0x1b
[249844.573328]  [<ffffffff81fffffd>] ? ip_build_and_send_pkt+0x1cd/0x260
[249844.574886] 1 lock held by trinity-c10/23911:
[249844.576036]  #0:  (net_mutex){+.+.+.}, at: [<ffffffff81f89357>]
copy_net_ns+0x97/0x150
