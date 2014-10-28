Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbaJ1WEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:04:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45783 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbaJ1WET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:04:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/5] documentation: Add atomic_long_t to atomic_ops.txt
Date: Tue, 28 Oct 2014 15:00:16 -0700
Message-Id: <1414533617-25933-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533617-25933-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215937.GA25095@linux.vnet.ibm.com>
 <1414533617-25933-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0033-0000-0000-000000E3F221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/atomic_ops.txt | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 68542fe13b85..183e41bdcb69 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -7,12 +7,13 @@
 maintainers on how to implement atomic counter, bitops, and spinlock
 interfaces properly.
 
-	The atomic_t type should be defined as a signed integer.
-Also, it should be made opaque such that any kind of cast to a normal
-C integer type will fail.  Something like the following should
-suffice:
+	The atomic_t type should be defined as a signed integer and
+the atomic_long_t type as a signed long integer.  Also, they should
+be made opaque such that any kind of cast to a normal C integer type
+will fail.  Something like the following should suffice:
 
 	typedef struct { int counter; } atomic_t;
+	typedef struct { long counter; } atomic_long_t;
 
 Historically, counter has been declared volatile.  This is now discouraged.
 See Documentation/volatile-considered-harmful.txt for the complete rationale.
@@ -37,6 +38,9 @@ initializer is used before runtime.  If the initializer is used at runtime, a
 proper implicit or explicit read memory barrier is needed before reading the
 value with atomic_read from another thread.
 
+As with all of the atomic_ interfaces, replace the leading "atomic_"
+with "atomic_long_" to operate on atomic_long_t.
+
 The second interface can be used at runtime, as in:
 
 	struct foo { atomic_t counter; };
-- 
1.8.1.5

