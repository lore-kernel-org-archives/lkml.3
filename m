Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbaD2A0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:26:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51994 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008AbaD2AZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:49 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 20/45] torture: Include "Stopping" string to torture_kthread_stopping()
Date: Mon, 28 Apr 2014 17:25:08 -0700
Message-Id: <1398731133-18925-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-8236-0000-0000-000001E64A5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, torture_kthread_stopping() prints only the name of the
kthread that is stopping, which can be unedifying.  This commit therefore
adds "Stopping" to make things more evident.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/torture.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index acc9afc2f26e..f329848c3eee 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -674,8 +674,11 @@ EXPORT_SYMBOL_GPL(torture_must_stop_irq);
  */
 void torture_kthread_stopping(char *title)
 {
+	char buf[128];
+
+	snprintf(buf, sizeof(buf), "Stopping %s", title);
 	if (verbose)
-		VERBOSE_TOROUT_STRING(title);
+		VERBOSE_TOROUT_STRING(buf);
 	while (!kthread_should_stop()) {
 		torture_shutdown_absorb(title);
 		schedule_timeout_uninterruptible(1);
-- 
1.8.1.5

