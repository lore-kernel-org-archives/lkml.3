Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379Ab3CYSvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:51:32 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37418 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932981Ab3CYSuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:50:10 -0400
Message-Id: <20130325185008.704384989@gulag1.americas.sgi.com>
References: <20130325185007.321022858@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Mar 2013 13:50:16 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 09/15] KDB: Add pshelp command.
Content-Disposition: inline; filename=kdb-add-pshelp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restores the capability for providing help with the
PS and BT arguments.

Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/debug/kdb/kdb_main.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- linux.orig/kernel/debug/kdb/kdb_main.c
+++ linux/kernel/debug/kdb/kdb_main.c
@@ -2787,6 +2787,32 @@ static int kdb_grep_help(int argc, const
 }
 
 /*
+ * display help for the ps and bt status flag
+ */
+static int kdb_ps_help(int argc, const char **argv)
+{
+	kdb_printf("The meaning of the State flag in ps command output:\n");
+	kdb_printf("  R RUNNING\n");
+	kdb_printf("  D TASK_UNINTERRUPTIBLE\n");
+	kdb_printf("  S TASK_INTERRUPTIBLE\n");
+	kdb_printf("  T TASK_STOPPED\n");
+	kdb_printf("  C TASK_TRACED\n");
+	kdb_printf("  Z EXIT_ZOMBIE\n");
+	kdb_printf("  E EXIT_DEAD\n");
+	kdb_printf("  U UNRUNNABLE\n");
+	kdb_printf("  M sleeping DAEMON\n");
+	kdb_printf("  I IDLE\n");
+	kdb_printf("  (note that most idles are named 'kworker/NN')\n");
+	kdb_printf("\n");
+	kdb_printf(
+		"The above can be specified to ps and bta to select tasks\n");
+	kdb_printf("  A all of above\n");
+	kdb_printf("  default is RDSTCZEU  (not Idle or sleeping Daemon)\n");
+	return 0;
+}
+
+
+/*
  * kdb_register_repeat - This function is used to register a kernel
  * 	debugger command.
  * Inputs:
@@ -2972,6 +2998,8 @@ static void __init kdb_inittab(void)
 	  "Enter kgdb mode", 0, KDB_REPEAT_NONE);
 	kdb_register_repeat("ps", kdb_ps, "[<flags>|A]",
 	  "Display active task list", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("pshelp", kdb_ps_help, "",
+	  "Display help for the ps and bt task State flag", 0, KDB_REPEAT_NONE);
 	kdb_register_repeat("pid", kdb_pid, "<pidnum>",
 	  "Switch to another task", 0, KDB_REPEAT_NONE);
 	kdb_register_repeat("reboot", kdb_reboot, "",

-- 
