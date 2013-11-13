Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab3KMRCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:02:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:60368 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757003Ab3KMRC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:02:28 -0500
Date: Wed, 13 Nov 2013 12:02:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] rcu: Make struct rcu_head searchable
Message-ID: <20131113120225.3aacae13@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After wasting too much time trying to see where struct rcu_head was
declared, I finally found it in include/linux/types.h as a define for
callback_head!

To prevent other developers from wasting their precious time in
searching for this structure, add a comment to help them find it!

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven "frustrated" Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/types.h b/include/linux/types.h
index 4d118ba..073e9a8 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -210,6 +210,9 @@ struct callback_head {
 	struct callback_head *next;
 	void (*func)(struct callback_head *head);
 };
+/*
+ * Make "struct rcu_head {" seachable with this comment.
+ */
 #define rcu_head callback_head
 
 #endif /*  __ASSEMBLY__ */
