Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab3A0AP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:15:29 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35058 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3A0AP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:15:28 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/10] rcu: Fix blimit type for trace_rcu_batch_start()
Date: Sat, 26 Jan 2013 16:15:03 -0800
Message-Id: <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20130127001454.GA2682@linux.vnet.ibm.com>
References: <20130127001454.GA2682@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-3620-0000-0000-00000100D546
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

When the type of global variable blimit changed from int to long, the
type of the blimit argument of trace_rcu_batch_start() needed to have
changed.  This commit fixes this issue.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/trace/events/rcu.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index d4f559b..f919498 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -393,7 +393,7 @@ TRACE_EVENT(rcu_kfree_callback,
  */
 TRACE_EVENT(rcu_batch_start,
 
-	TP_PROTO(char *rcuname, long qlen_lazy, long qlen, int blimit),
+	TP_PROTO(char *rcuname, long qlen_lazy, long qlen, long blimit),
 
 	TP_ARGS(rcuname, qlen_lazy, qlen, blimit),
 
@@ -401,7 +401,7 @@ TRACE_EVENT(rcu_batch_start,
 		__field(char *, rcuname)
 		__field(long, qlen_lazy)
 		__field(long, qlen)
-		__field(int, blimit)
+		__field(long, blimit)
 	),
 
 	TP_fast_assign(
@@ -411,7 +411,7 @@ TRACE_EVENT(rcu_batch_start,
 		__entry->blimit = blimit;
 	),
 
-	TP_printk("%s CBs=%ld/%ld bl=%d",
+	TP_printk("%s CBs=%ld/%ld bl=%ld",
 		  __entry->rcuname, __entry->qlen_lazy, __entry->qlen,
 		  __entry->blimit)
 );
-- 
1.7.8

