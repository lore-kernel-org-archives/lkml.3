Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750946Ab3GFERE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 00:17:04 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41382 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3GFERC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 00:17:02 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hashtable: add hash_for_each_possible_rcu_notrace()
Date: Sat,  6 Jul 2013 14:16:50 +1000
Message-Id: <1373084210-27767-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds hash_for_each_possible_rcu_notrace() which is basically
a notrace clone of hash_for_each_possible_rcu() which cannot be
used in real mode due to its tracing/debugging capability.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 include/linux/hashtable.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/hashtable.h b/include/linux/hashtable.h
index a9df51f..af8b169 100644
--- a/include/linux/hashtable.h
+++ b/include/linux/hashtable.h
@@ -174,6 +174,21 @@ static inline void hash_del_rcu(struct hlist_node *node)
 		member)
 
 /**
+ * hash_for_each_possible_rcu_notrace - iterate over all possible objects hashing
+ * to the same bucket in an rcu enabled hashtable in a rcu enabled hashtable
+ * @name: hashtable to iterate
+ * @obj: the type * to use as a loop cursor for each entry
+ * @member: the name of the hlist_node within the struct
+ * @key: the key of the objects to iterate over
+ *
+ * This is the same as hash_for_each_possible_rcu() except that it does
+ * not do any RCU debugging or tracing.
+ */
+#define hash_for_each_possible_rcu_notrace(name, obj, member, key)	\
+	hlist_for_each_entry_rcu_notrace(obj, &name[hash_min(key, HASH_BITS(name))],\
+		member)
+
+/**
  * hash_for_each_possible_safe - iterate over all possible objects hashing to the
  * same bucket safe against removals
  * @name: hashtable to iterate
-- 
1.8.3.2

