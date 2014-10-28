Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaJ1WOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:14:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54095 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917AbaJ1WN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:13:58 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/9] dm: sparse: Annotate field with __rcu for checking
Date: Tue, 28 Oct 2014 15:09:57 -0700
Message-Id: <1414534202-27312-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0033-0000-0000-0000028046B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Annotate the map field with __rcu since this is a rcu pointer which is checked
by sparse.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e7399362722e..3372b8378830 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -140,7 +140,7 @@ struct mapped_device {
 	 * Use dm_get_live_table{_fast} or take suspend_lock for
 	 * dereference.
 	 */
-	struct dm_table *map;
+	struct dm_table __rcu *map;
 
 	struct list_head table_devices;
 	struct mutex table_devices_lock;
-- 
1.8.1.5

