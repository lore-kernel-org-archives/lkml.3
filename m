Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaEERag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:30:36 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:36146 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbaEERaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:30:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoEJAHvJZ1NbsEtU/2dsb2JhbABZgwarUQcBAgUBmgyBFxd0gmYcIxiBAiQTiEUBzASFVoh8hEYBA48aihkBin6HdoM2Ow
Date: Mon, 5 May 2014 19:30:33 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/backtracetest.c: replace no level printk by
 pr_info()
Message-Id: <20140505193033.00bc9fb4a6736cfc152eb570@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/backtracetest.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c
index a5e026b..1323360 100644
--- a/kernel/backtracetest.c
+++ b/kernel/backtracetest.c
@@ -19,8 +19,8 @@
 
 static void backtrace_test_normal(void)
 {
-	printk("Testing a backtrace from process context.\n");
-	printk("The following trace is a kernel self test and not a bug!\n");
+	pr_info("Testing a backtrace from process context.\n");
+	pr_info("The following trace is a kernel self test and not a bug!\n");
 
 	dump_stack();
 }
@@ -37,8 +37,8 @@ static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0);
 
 static void backtrace_test_irq(void)
 {
-	printk("Testing a backtrace from irq context.\n");
-	printk("The following trace is a kernel self test and not a bug!\n");
+	pr_info("Testing a backtrace from irq context.\n");
+	pr_info("The following trace is a kernel self test and not a bug!\n");
 
 	init_completion(&backtrace_work);
 	tasklet_schedule(&backtrace_tasklet);
@@ -51,8 +51,8 @@ static void backtrace_test_saved(void)
 	struct stack_trace trace;
 	unsigned long entries[8];
 
-	printk("Testing a saved backtrace.\n");
-	printk("The following trace is a kernel self test and not a bug!\n");
+	pr_info("Testing a saved backtrace.\n");
+	pr_info("The following trace is a kernel self test and not a bug!\n");
 
 	trace.nr_entries = 0;
 	trace.max_entries = ARRAY_SIZE(entries);
@@ -65,19 +65,19 @@ static void backtrace_test_saved(void)
 #else
 static void backtrace_test_saved(void)
 {
-	printk("Saved backtrace test skipped.\n");
+	pr_info("Saved backtrace test skipped.\n");
 }
 #endif
 
 static int backtrace_regression_test(void)
 {
-	printk("====[ backtrace testing ]===========\n");
+	pr_info("====[ backtrace testing ]===========\n");
 
 	backtrace_test_normal();
 	backtrace_test_irq();
 	backtrace_test_saved();
 
-	printk("====[ end of backtrace testing ]====\n");
+	pr_info("====[ end of backtrace testing ]====\n");
 	return 0;
 }
 
-- 
1.9.1

