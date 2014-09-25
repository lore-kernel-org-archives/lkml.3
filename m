Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaIYSDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:03:38 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:58297 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaIYSDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:03:37 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [RFC PATCH] rcu: Add sparse check for RCU_INIT_POINTER()
Date: Thu, 25 Sep 2014 14:03:34 -0400
Message-Id: <1411668214-19199-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sparse check when RCU_INIT_POINTER() is used to assign a non __rcu
annotated pointer. 

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/rcupdate.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a4a819f..a033d8b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1047,6 +1047,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  */
 #define RCU_INIT_POINTER(p, v) \
 	do { \
+		rcu_dereference_sparse(p, __rcu); \
 		p = RCU_INITIALIZER(v); \
 	} while (0)
 
-- 
2.1.0

