Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab3EJOUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56908 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437Ab3EJOUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Eric Paris" <eparis@redhat.com>, "Al Viro" <viro@zeniv.linux.org.uk>,
        "Chen Gang" <gang.chen@asianux.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.549905950@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [115/118] kernel/audit_tree.c: tree will leak memory when failure
 occurs in audit_trim_trees()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/audit_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

