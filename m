Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbaD2AeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:34:05 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37391 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001AbaD2AZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 28/45] percpu: Fix raw_cpu_inc_return()
Date: Mon, 28 Apr 2014 17:25:16 -0700
Message-Id: <1398731133-18925-28-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-7164-0000-0000-0000015FD2DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The definition for raw_cpu_add_return() uses the operation prefix
"raw_add_return_", but the definitions in the various percpu.h files
expect "raw_cpu_add_return_".  This commit therefore appropriately
adjusts the definition of raw_cpu_add_return().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>
---
 include/linux/percpu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index e7a0b95ed527..495c6543a8f2 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -639,7 +639,7 @@ do {									\
 #  define raw_cpu_add_return_8(pcp, val)	raw_cpu_generic_add_return(pcp, val)
 # endif
 # define raw_cpu_add_return(pcp, val)	\
-	__pcpu_size_call_return2(raw_add_return_, pcp, val)
+	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
 #endif
 
 #define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(typeof(pcp))(val))
-- 
1.8.1.5

