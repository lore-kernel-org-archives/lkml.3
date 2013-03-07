Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3CGJAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:00:30 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:24565 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab3CGJA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:00:27 -0500
Message-ID: <51385712.3050104@huawei.com>
Date: Thu, 7 Mar 2013 17:00:02 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 1/8] sysrq: fix inconstistent help message of sysrq key
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently help message of /proc/sysrq-trigger highlight its
upper-case characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch fix it.

Thanks the comments from Andrew and Randy.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/tty/sysrq.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 3687f0c..0a0de33 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -101,7 +101,7 @@ static void sysrq_handle_SAK(int key)
 }
 static struct sysrq_key_op sysrq_SAK_op = {
 	.handler	= sysrq_handle_SAK,
-	.help_msg	= "saK",
+	.help_msg	= "sak(k)",
 	.action_msg	= "SAK",
 	.enable_mask	= SYSRQ_ENABLE_KEYBOARD,
 };
@@ -117,7 +117,7 @@ static void sysrq_handle_unraw(int key)

 static struct sysrq_key_op sysrq_unraw_op = {
 	.handler	= sysrq_handle_unraw,
-	.help_msg	= "unRaw",
+	.help_msg	= "unraw(r)",
 	.action_msg	= "Keyboard mode set to system default",
 	.enable_mask	= SYSRQ_ENABLE_KEYBOARD,
 };
@@ -135,7 +135,7 @@ static void sysrq_handle_crash(int key)
 }
 static struct sysrq_key_op sysrq_crash_op = {
 	.handler	= sysrq_handle_crash,
-	.help_msg	= "Crash",
+	.help_msg	= "crash(c)",
 	.action_msg	= "Trigger a crash",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -148,7 +148,7 @@ static void sysrq_handle_reboot(int key)
 }
 static struct sysrq_key_op sysrq_reboot_op = {
 	.handler	= sysrq_handle_reboot,
-	.help_msg	= "reBoot",
+	.help_msg	= "reboot(b)",
 	.action_msg	= "Resetting",
 	.enable_mask	= SYSRQ_ENABLE_BOOT,
 };
@@ -159,7 +159,7 @@ static void sysrq_handle_sync(int key)
 }
 static struct sysrq_key_op sysrq_sync_op = {
 	.handler	= sysrq_handle_sync,
-	.help_msg	= "Sync",
+	.help_msg	= "sync(s)",
 	.action_msg	= "Emergency Sync",
 	.enable_mask	= SYSRQ_ENABLE_SYNC,
 };
@@ -171,7 +171,7 @@ static void sysrq_handle_show_timers(int key)

 static struct sysrq_key_op sysrq_show_timers_op = {
 	.handler	= sysrq_handle_show_timers,
-	.help_msg	= "show-all-timers(Q)",
+	.help_msg	= "show-all-timers(q)",
 	.action_msg	= "Show clockevent devices & pending hrtimers (no others)",
 };

@@ -181,7 +181,7 @@ static void sysrq_handle_mountro(int key)
 }
 static struct sysrq_key_op sysrq_mountro_op = {
 	.handler	= sysrq_handle_mountro,
-	.help_msg	= "Unmount",
+	.help_msg	= "unmount(u)",
 	.action_msg	= "Emergency Remount R/O",
 	.enable_mask	= SYSRQ_ENABLE_REMOUNT,
 };
@@ -194,7 +194,7 @@ static void sysrq_handle_showlocks(int key)

 static struct sysrq_key_op sysrq_showlocks_op = {
 	.handler	= sysrq_handle_showlocks,
-	.help_msg	= "show-all-locks(D)",
+	.help_msg	= "show-all-locks(d)",
 	.action_msg	= "Show Locks Held",
 };
 #else
@@ -245,7 +245,7 @@ static void sysrq_handle_showallcpus(int key)

 static struct sysrq_key_op sysrq_showallcpus_op = {
 	.handler	= sysrq_handle_showallcpus,
-	.help_msg	= "show-backtrace-all-active-cpus(L)",
+	.help_msg	= "show-backtrace-all-active-cpus(l)",
 	.action_msg	= "Show backtrace of all active CPUs",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -260,7 +260,7 @@ static void sysrq_handle_showregs(int key)
 }
 static struct sysrq_key_op sysrq_showregs_op = {
 	.handler	= sysrq_handle_showregs,
-	.help_msg	= "show-registers(P)",
+	.help_msg	= "show-registers(p)",
 	.action_msg	= "Show Regs",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -271,7 +271,7 @@ static void sysrq_handle_showstate(int key)
 }
 static struct sysrq_key_op sysrq_showstate_op = {
 	.handler	= sysrq_handle_showstate,
-	.help_msg	= "show-task-states(T)",
+	.help_msg	= "show-task-states(t)",
 	.action_msg	= "Show State",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -282,7 +282,7 @@ static void sysrq_handle_showstate_blocked(int key)
 }
 static struct sysrq_key_op sysrq_showstate_blocked_op = {
 	.handler	= sysrq_handle_showstate_blocked,
-	.help_msg	= "show-blocked-tasks(W)",
+	.help_msg	= "show-blocked-tasks(w)",
 	.action_msg	= "Show Blocked State",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -296,7 +296,7 @@ static void sysrq_ftrace_dump(int key)
 }
 static struct sysrq_key_op sysrq_ftrace_dump_op = {
 	.handler	= sysrq_ftrace_dump,
-	.help_msg	= "dump-ftrace-buffer(Z)",
+	.help_msg	= "dump-ftrace-buffer(z)",
 	.action_msg	= "Dump ftrace buffer",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -310,7 +310,7 @@ static void sysrq_handle_showmem(int key)
 }
 static struct sysrq_key_op sysrq_showmem_op = {
 	.handler	= sysrq_handle_showmem,
-	.help_msg	= "show-memory-usage(M)",
+	.help_msg	= "show-memory-usage(m)",
 	.action_msg	= "Show Memory",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -341,7 +341,7 @@ static void sysrq_handle_term(int key)
 }
 static struct sysrq_key_op sysrq_term_op = {
 	.handler	= sysrq_handle_term,
-	.help_msg	= "terminate-all-tasks(E)",
+	.help_msg	= "terminate-all-tasks(e)",
 	.action_msg	= "Terminate All Tasks",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
@@ -360,7 +360,7 @@ static void sysrq_handle_moom(int key)
 }
 static struct sysrq_key_op sysrq_moom_op = {
 	.handler	= sysrq_handle_moom,
-	.help_msg	= "memory-full-oom-kill(F)",
+	.help_msg	= "memory-full-oom-kill(f)",
 	.action_msg	= "Manual OOM execution",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
@@ -372,7 +372,7 @@ static void sysrq_handle_thaw(int key)
 }
 static struct sysrq_key_op sysrq_thaw_op = {
 	.handler	= sysrq_handle_thaw,
-	.help_msg	= "thaw-filesystems(J)",
+	.help_msg	= "thaw-filesystems(j)",
 	.action_msg	= "Emergency Thaw of all frozen filesystems",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
@@ -385,7 +385,7 @@ static void sysrq_handle_kill(int key)
 }
 static struct sysrq_key_op sysrq_kill_op = {
 	.handler	= sysrq_handle_kill,
-	.help_msg	= "kill-all-tasks(I)",
+	.help_msg	= "kill-all-tasks(i)",
 	.action_msg	= "Kill All Tasks",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
@@ -396,7 +396,7 @@ static void sysrq_handle_unrt(int key)
 }
 static struct sysrq_key_op sysrq_unrt_op = {
 	.handler	= sysrq_handle_unrt,
-	.help_msg	= "nice-all-RT-tasks(N)",
+	.help_msg	= "nice-all-RT-tasks(n)",
 	.action_msg	= "Nice All RT Tasks",
 	.enable_mask	= SYSRQ_ENABLE_RTNICE,
 };
-- 
1.7.9.7


