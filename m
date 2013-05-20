Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab3ETLLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:11:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56152 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3ETKxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen Gang <gang.chen@asianux.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 046/115] kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()
Date: Mon, 20 May 2013 11:50:46 +0100
Message-Id: <1369047116-9378-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

commit 12b2f117f3bf738c1a00a6f64393f1953a740bd4 upstream.

audit_trim_trees() calls get_tree().  If a failure occurs we must call
put_tree().

[akpm@linux-foundation.org: run put_tree() before mutex_lock() for small scalability improvement]
Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 31fdc48..0caf1f8 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -608,9 +608,9 @@ void audit_trim_trees(void)
 		}
 		spin_unlock(&hash_lock);
 		trim_marked(tree);
-		put_tree(tree);
 		drop_collected_mounts(root_mnt);
 skip_it:
+		put_tree(tree);
 		mutex_lock(&audit_filter_mutex);
 	}
 	list_del(&cursor);
-- 
1.8.1.2

