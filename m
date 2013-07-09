Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab3GIBVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:21:31 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:11427 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3GIBRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:17:41 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v6 03/14] dcache: Add a new helper function d_count() to return refcount
Date: Mon,  8 Jul 2013 21:09:53 -0400
Message-Id: <1373332204-10379-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
References: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new helper function d_count() in dcache.h for
returning the current reference count of the dentry object. It
should be used by all the files outside of the core dcache.c and
namei.c files.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/dcache.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index f42dbe1..7c6bbf0 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -258,6 +258,16 @@ extern int have_submounts(struct dentry *);
 extern void d_rehash(struct dentry *);
 
 /**
+ * d_count - return the reference count in dentry
+ * @entry: dentry pointer
+ * Returns: current value of reference count
+ */
+static inline unsigned int d_count(struct dentry *entry)
+{
+	return entry->d_count;
+}
+
+/**
  * d_add - add dentry to hash queues
  * @entry: dentry to add
  * @inode: The inode to attach to this dentry
-- 
1.7.1

