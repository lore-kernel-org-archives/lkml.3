Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3CRUzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:55:38 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56809 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3CRUzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:55:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] rcu: Make bugginess of code sample more evident
Date: Mon, 18 Mar 2013 13:55:07 -0700
Message-Id: <1363640108-15508-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031820-5518-0000-0000-00000CA80A88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

One of the code samples in whatisRCU.txt shows a bug, but someone scanning
the document quickly might mistake it for a valid use of RCU.  Add some
screaming comments to help keep speed-readers on track.

Reported-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/RCU/whatisRCU.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 0cc7820..10df0b8 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -265,9 +265,9 @@ rcu_dereference()
 		rcu_read_lock();
 		p = rcu_dereference(head.next);
 		rcu_read_unlock();
-		x = p->address;
+		x = p->address;	/* BUG!!! */
 		rcu_read_lock();
-		y = p->data;
+		y = p->data;	/* BUG!!! */
 		rcu_read_unlock();
 
 	Holding a reference from one RCU read-side critical section
-- 
1.8.1.5

