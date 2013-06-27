Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3F0FDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:03:24 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:62890 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3F0FDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:03:21 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 4/8] hashtable: add hash_for_each_possible_rcu_notrace()
Date: Thu, 27 Jun 2013 15:02:32 +1000
Message-Id: <1372309356-28320-5-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds hash_for_each_possible_rcu_notrace() which is basically
a notrace clone of hash_for_each_possible_rcu() which cannot be
used in real mode due to its tracing/debugging capability.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 include/linux/hashtable.h |   15 +++++++++++++++
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
1.7.10.4

