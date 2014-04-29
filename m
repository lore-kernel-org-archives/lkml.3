Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419AbaD2A2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:28:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59736 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104AbaD2AZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Pranith Kumar <bobby.prani@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 44/45] torture: Remove __init from torture_init_begin/end
Date: Mon, 28 Apr 2014 17:25:32 -0700
Message-Id: <1398731133-18925-44-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-0928-0000-0000-0000018D138E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Loading rcutorture as a module (as opposed to building it directly into
the kernel) results in the following splat:

[Wed Apr 16 15:29:33 2014] BUG: unable to handle kernel paging request at ffffffffa0003000
[Wed Apr 16 15:29:33 2014] IP: [<ffffffffa0003000>] 0xffffffffa0003000
[Wed Apr 16 15:29:33 2014] PGD 1c0f067 PUD 1c10063 PMD 378a6067 PTE 0
[Wed Apr 16 15:29:33 2014] Oops: 0010 [#1] SMP
[Wed Apr 16 15:29:33 2014] Modules linked in: rcutorture(+) torture
[Wed Apr 16 15:29:33 2014] CPU: 0 PID: 4257 Comm: modprobe Not tainted 3.15.0-rc1 #10
[Wed Apr 16 15:29:33 2014] Hardware name: innotek GmbH VirtualBox, BIOS VirtualBox 12/01/2006
[Wed Apr 16 15:29:33 2014] task: ffff8800db1e88d0 ti: ffff8800db25c000 task.ti: ffff8800db25c000
[Wed Apr 16 15:29:33 2014] RIP: 0010:[<ffffffffa0003000>]  [<ffffffffa0003000>] 0xffffffffa0003000
[Wed Apr 16 15:29:33 2014] RSP: 0018:ffff8800db25dca0  EFLAGS: 00010282
[Wed Apr 16 15:29:33 2014] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[Wed Apr 16 15:29:33 2014] RDX: ffffffffa00090a8 RSI: 0000000000000001 RDI: ffffffffa0008337
[Wed Apr 16 15:29:33 2014] RBP: ffff8800db25dd50 R08: 0000000000000000 R09: 0000000000000000
[Wed Apr 16 15:29:33 2014] R10: ffffea000357b680 R11: ffffffff8113257a R12: ffffffffa000d000
[Wed Apr 16 15:29:33 2014] R13: ffffffffa00094c0 R14: ffffffffa0009510 R15: 0000000000000001
[Wed Apr 16 15:29:33 2014] FS:  00007fee30ce5700(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
[Wed Apr 16 15:29:33 2014] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[Wed Apr 16 15:29:33 2014] CR2: ffffffffa0003000 CR3: 00000000d5eb1000 CR4: 00000000000006f0
[Wed Apr 16 15:29:33 2014] Stack:
[Wed Apr 16 15:29:33 2014]  ffffffffa000d02c 0000000000000000 ffff88021700d400 0000000000000000
[Wed Apr 16 15:29:33 2014]  ffff8800db25dd40 ffffffff81647951 ffff8802162bd000 ffff88021541846c
[Wed Apr 16 15:29:33 2014]  0000000000000000 ffffffff817dbe2d ffffffff817dbe2d 0000000000000001
[Wed Apr 16 15:29:33 2014] Call Trace:
[Wed Apr 16 15:29:33 2014]  [<ffffffffa000d02c>] ? rcu_torture_init+0x2c/0x8b4 [rcutorture]
[Wed Apr 16 15:29:33 2014]  [<ffffffff81647951>] ? netlink_broadcast_filtered+0x121/0x3a0
[Wed Apr 16 15:29:33 2014]  [<ffffffff817dbe2d>] ? mutex_lock+0xd/0x2a
[Wed Apr 16 15:29:33 2014]  [<ffffffff817dbe2d>] ? mutex_lock+0xd/0x2a
[Wed Apr 16 15:29:33 2014]  [<ffffffff810e7022>] ? trace_module_notify+0x62/0x1d0
[Wed Apr 16 15:29:33 2014]  [<ffffffffa000d000>] ? 0xffffffffa000cfff
[Wed Apr 16 15:29:33 2014]  [<ffffffff8100034a>] do_one_initcall+0xfa/0x140
[Wed Apr 16 15:29:33 2014]  [<ffffffff8106b4ce>] ? __blocking_notifier_call_chain+0x5e/0x80
[Wed Apr 16 15:29:33 2014]  [<ffffffff810b3481>] load_module+0x1931/0x21b0
[Wed Apr 16 15:29:33 2014]  [<ffffffff810b0330>] ? show_initstate+0x50/0x50
[Wed Apr 16 15:29:33 2014]  [<ffffffff810b3d9e>] SyS_init_module+0x9e/0xc0
[Wed Apr 16 15:29:33 2014]  [<ffffffff817e4c22>] system_call_fastpath+0x16/0x1b
[Wed Apr 16 15:29:33 2014] Code:  Bad RIP value.
[Wed Apr 16 15:29:33 2014] RIP  [<ffffffffa0003000>] 0xffffffffa0003000
[Wed Apr 16 15:29:33 2014]  RSP <ffff8800db25dca0>
[Wed Apr 16 15:29:33 2014] CR2: ffffffffa0003000
[Wed Apr 16 15:29:33 2014] ---[ end trace 3e88c173037af84b ]---

This splat is due to the fact that torture_init_begin() and
torture_init_end() are both marked with __init, despite their use
at runtime.  This commit therefore removes __init from both functions.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/torture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index de440a46331c..db8de702abbc 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -599,7 +599,7 @@ static void torture_stutter_cleanup(void)
  * The runnable parameter points to a flag that controls whether or not
  * the test is currently runnable.  If there is no such flag, pass in NULL.
  */
-bool __init torture_init_begin(char *ttype, bool v, int *runnable)
+bool torture_init_begin(char *ttype, bool v, int *runnable)
 {
 	mutex_lock(&fullstop_mutex);
 	if (torture_type != NULL) {
@@ -619,7 +619,7 @@ EXPORT_SYMBOL_GPL(torture_init_begin);
 /*
  * Tell the torture module that initialization is complete.
  */
-void __init torture_init_end(void)
+void torture_init_end(void)
 {
 	mutex_unlock(&fullstop_mutex);
 	register_reboot_notifier(&torture_shutdown_nb);
-- 
1.8.1.5

