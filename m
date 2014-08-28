Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaH1Sil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:38:41 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60882 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaH1Sig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:38:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/14] rcu: Return false instead of 0 in rcu_nocb_adopt_orphan_cbs()
Date: Thu, 28 Aug 2014 11:38:09 -0700
Message-Id: <1409251097-26734-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828183754.GA25488@linux.vnet.ibm.com>
 <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-9332-0000-0000-000001D6C6BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Return false instead of 0 in rcu_nocb_adopt_orphan_cbs() as this has
bool as return type.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a7c5629f1bd2..d1b8b628d24e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2581,7 +2581,7 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 						     struct rcu_data *rdp,
 						     unsigned long flags)
 {
-	return 0;
+	return false;
 }
 
 static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
-- 
1.8.1.5

