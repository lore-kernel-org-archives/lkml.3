Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbaD2A2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:28:14 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59730 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094AbaD2AZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Pranith Kumar <pranith@gatech.edu>,
        Pranith Kumar <bobby.prani@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 45/45] torture: Remove unused definition
Date: Mon, 28 Apr 2014 17:25:33 -0700
Message-Id: <1398731133-18925-45-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-0928-0000-0000-0000018D1390
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <pranith@gatech.edu>

The torture_parm() macro is the same as torture_param(), and torture_parm()
is not used.  This commit therefore removes torture_parm().

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index f998574247fd..5ca58fcbaf1b 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -49,12 +49,6 @@
 #define VERBOSE_TOROUT_ERRSTRING(s) \
 	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! %s\n", torture_type, s); } while (0)
 
-/* Definitions for a non-string torture-test module parameter. */
-#define torture_parm(type, name, init, msg) \
-	static type name = init; \
-	module_param(name, type, 0444); \
-	MODULE_PARM_DESC(name, msg);
-
 /* Definitions for online/offline exerciser. */
 int torture_onoff_init(long ooholdoff, long oointerval);
 char *torture_onoff_stats(char *page);
-- 
1.8.1.5

