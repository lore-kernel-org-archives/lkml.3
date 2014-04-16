Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaDPTqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:46:45 -0400
Received: from mxip3-inbound.gatech.edu ([130.207.182.45]:2074 "EHLO
	mxip3-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaDPTqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:46:43 -0400
X-RemoteIP: 130.207.185.161
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 81396411
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.97,873,1389762000"; 
   d="scan'208";a="81396411"
X-GT-Spam-Rating: (0%)
Message-ID: <534EDBF4.6030702@gatech.edu>
Date: Wed, 16 Apr 2014 15:37:24 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] kernel/torture.c: unmark torture_init_*  as __inline
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to run rcutorture module and came across the following crash when loading the module

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

Upon investigation I found that the function torture_init_begin and torture_init_end are marked with __init,
but these functions are used later on too. Unmarking these functions fixed the bug.

Patch attached. I bisected this and it seems to have appeared after 3.14-rc3. So may be should be marked in stable too.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/torture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index acc9afc..d5ef30c 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -596,7 +596,7 @@ static void torture_stutter_cleanup(void)
  * The runnable parameter points to a flag that controls whether or not
  * the test is currently runnable.  If there is no such flag, pass in NULL.
  */
-void __init torture_init_begin(char *ttype, bool v, int *runnable)
+void torture_init_begin(char *ttype, bool v, int *runnable)
 {
 	mutex_lock(&fullstop_mutex);
 	torture_type = ttype;
@@ -610,7 +610,7 @@ EXPORT_SYMBOL_GPL(torture_init_begin);
 /*
  * Tell the torture module that initialization is complete.
  */
-void __init torture_init_end(void)
+void torture_init_end(void)
 {
 	mutex_unlock(&fullstop_mutex);
 	register_reboot_notifier(&torture_shutdown_nb);
-- 1.7.10.4 
