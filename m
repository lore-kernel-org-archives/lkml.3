Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3BKMUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:20:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab3BKMUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:20:35 -0500
Date: Mon, 11 Feb 2013 04:20:08 -0800
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-56624143151fdb84c32a43463864e6c12a5ebcfc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de, fengguang.wu@intel.com,
        chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, fengguang.wu@intel.com,
        chuansheng.liu@intel.com
In-Reply-To: <1360163901.24670.13.camel@cliu38-desktop-build>
References: <1360163901.24670.13.camel@cliu38-desktop-build>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] Revert "smp: Give WARN()ing if in_interrupt()
  when calling smp_call_function_many()/single()"
Git-Commit-ID: 56624143151fdb84c32a43463864e6c12a5ebcfc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:20:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56624143151fdb84c32a43463864e6c12a5ebcfc
Gitweb:     http://git.kernel.org/tip/56624143151fdb84c32a43463864e6c12a5ebcfc
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 11 Feb 2013 10:03:29 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 10:03:29 +0100

Revert "smp: Give WARN()ing if in_interrupt() when calling smp_call_function_many()/single()"

This reverts commit b29f39c7c3e75a741a7da88244ec707f293ec04c.

Fengguang Wu reported that the commit triggers a bogus warning
on the current networking tree:

[  229.339945] Call Trace:
[  229.341176]  [<ffffffff810353b4>] warn_slowpath_common+0x83/0x9c
[  229.343091]  [<ffffffff817089d6>] ? flow_cache_new_hashrnd+0x98/0x98
[  229.345105]  [<ffffffff810353e7>] warn_slowpath_null+0x1a/0x1c
[  229.346978]  [<ffffffff81090793>] smp_call_function_single+0xbd/0x1c7
[  229.349017]  [<ffffffff81090afe>] smp_call_function_many+0x121/0x23e
[  229.350996]  [<ffffffff817089d6>] ? flow_cache_new_hashrnd+0x98/0x98
[  229.353005]  [<ffffffff81090e09>] smp_call_function+0x37/0x40
[  229.354860]  [<ffffffff8170907e>] flow_cache_flush+0x72/0xa0
[  229.356735]  [<ffffffff81759e33>] xfrm_dev_event+0x14/0x20
[  229.358545]  [<ffffffff817ff8b0>] notifier_call_chain+0x65/0x95
[  229.360469]  [<ffffffff8105ce16>] __raw_notifier_call_chain+0xe/0x10
[  229.362453]  [<ffffffff8105ce2c>] raw_notifier_call_chain+0x14/0x16
[  229.364453]  [<ffffffff816f63d6>] call_netdevice_notifiers+0x4a/0x4f
[  229.366434]  [<ffffffff816fa2ab>] __dev_notify_flags+0x37/0x5b
[  229.368342]  [<ffffffff816fa318>] dev_change_flags+0x49/0x54
[  229.370184]  [<ffffffff8174574a>] devinet_ioctl+0x24f/0x542
[  229.372036]  [<ffffffff81746975>] inet_ioctl+0x97/0xb1
[  229.373774]  [<ffffffff816e5042>] sock_do_ioctl.constprop.42+0x18/0x37
[  229.375791]  [<ffffffff816e5480>] sock_ioctl+0x1fd/0x20a
[  229.377648]  [<ffffffff810bb9cd>] ?  trace_buffer_lock_reserve+0x41/0x56
[  229.379701]  [<ffffffff8112b7c6>] vfs_ioctl+0x26/0x39
[  229.381459]  [<ffffffff8112c0d2>] do_vfs_ioctl+0x41b/0x45e
[  229.383269]  [<ffffffff8100bc3a>] ?  ftrace_raw_event_sys_enter+0x10b/0x11a
[  229.385404]  [<ffffffff817fc118>] ? retint_swapgs+0x13/0x1b
[  229.387227]  [<ffffffff8112c15a>] sys_ioctl+0x45/0x73
[  229.388975]  [<ffffffff818034be>] tracesys+0xd0/0xd5

The intention of the warning is to warn about IPIs generated from
hardirq contexts. But in_interrupt() will also warn from
softirq-disabled contexts.

The warning should probably use in_irq() - but that primitive
is not avaiable on non-genirq platform. So this change needs
more work - revert it until it's ready.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: liu chuansheng <chuansheng.liu@intel.com>
Cc: jun.zhang@intel.com
Cc: peterz@infradead.org
Cc: jbeulich@suse.com
Cc: paulmck@linux.vnet.ibm.com
Cc: mina86@mina86.org
Cc: srivatsa.bhat@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360163901.24670.13.camel@cliu38-desktop-build
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/smp.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index a2f0b2c..69f38bd 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -12,7 +12,6 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
-#include <linux/hardirq.h>
 
 #include "smpboot.h"
 
@@ -324,7 +323,7 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && (irqs_disabled() || in_interrupt())
+	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
 		     && !oops_in_progress);
 
 	if (cpu == this_cpu) {
@@ -422,9 +421,8 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait
-			&& (irqs_disabled() || in_interrupt())
-			&& !oops_in_progress);
+	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
+		     && !oops_in_progress);
 
 	if (cpu == this_cpu) {
 		local_irq_save(flags);
